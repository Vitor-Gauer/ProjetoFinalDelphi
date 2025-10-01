unit UEditarTabelaService;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,
  UTabelaDTO, UXMLService;

type
  // Record para representar uma c�lula v�lida
  TCellData = record
    Row: Integer;
    Col: Integer; // Base 1
    Value: string;
  end;

  // Record para representar uma linha v�lida
  TRowData = record
    Number: Integer;
    Cells: TArray<TCellData>;
  end;

  // Tipo para os dados preparados para transforma��o
  TPreparedData = TArray<TRowData>;

  TEditarTabelaService = class
  private
    FXMLService: TXMLService;
    function ContemConteudoPerigoso(const ATexto: string): Boolean;
    function ExtrairTextoParaValidacao(const ATexto: string): string; // Remove espa�os para valida��o
  public
    constructor Create(AXMLService: TXMLService);
    destructor Destroy; override;

    function Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
    function ValidarDados(ADataSet: TClientDataSet): Boolean;
    function PrepararParaTransformacao(ADataSet: TClientDataSet): TPreparedData; // Novo m�todo
    procedure Salvar(ATabelaDTO: TTabelaDTO; ADataSet: TClientDataSet); // Atualizado para receber DataSet
  end;

implementation

{ TEditarTabelaService }

constructor TEditarTabelaService.Create(AXMLService: TXMLService);
begin
  inherited Create;
  FXMLService := AXMLService;
end;

destructor TEditarTabelaService.Destroy;
begin
  // FXMLService � injetado, n�o deve ser destru�do aqui
  inherited;
end;

function TEditarTabelaService.Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
var
  TempDataSet: TClientDataSet;
begin
  if not Assigned(ATabelaDTO) then
    raise Exception.Create('TabelaDTO n�o fornecido para carregamento.');

  Result := ATabelaDTO;

  TempDataSet := TClientDataSet.Create(nil);
  try
//    FXMLService.LerArquivoXML(Result, TempDataSet);
  finally
    TempDataSet.Free;
  end;
end;

function TEditarTabelaService.ExtrairTextoParaValidacao(const ATexto: string): string;
begin
  // Remove espa�os iniciais e finais para valida��o
  Result := Trim(ATexto);
end;

function TEditarTabelaService.ContemConteudoPerigoso(const ATexto: string): Boolean;
var
  TextoLower: string;
begin
  Result := False;
  TextoLower := LowerCase(ATexto);

  if (Pos('select', TextoLower) > 0) and (Pos('from', TextoLower) > 0) then Exit(True);
  if (Pos('insert', TextoLower) > 0) and (Pos('into', TextoLower) > 0) then Exit(True);
  if (Pos('update', TextoLower) > 0) and (Pos('set', TextoLower) > 0) then Exit(True);
  if (Pos('delete', TextoLower) > 0) and (Pos('from', TextoLower) > 0) then Exit(True);
  if (Pos('drop', TextoLower) > 0) or (Pos('create', TextoLower) > 0) then Exit(True);
  if (Pos('http://', TextoLower) > 0) or (Pos('https://', TextoLower) > 0) then Exit(True);
  // Adicione mais verifica��es conforme necess�rio
end;

function TEditarTabelaService.ValidarDados(ADataSet: TClientDataSet): Boolean;
var
  HasData: Boolean;
  HasInvalidData: Boolean;
  i, j: Integer;
  CellValue, TrimmedValueForValidation: string;
  MsgErro: string;
begin
  Result := False;
  HasData := False;
  HasInvalidData := False;
  MsgErro := '';

  if not Assigned(ADataSet) or not ADataSet.Active then
  begin
    MsgErro := 'DataSet inv�lido ou inativo.';
    ShowMessage(MsgErro);
    Exit;
  end;

  ADataSet.DisableControls;
  try
    ADataSet.First;
    while not ADataSet.Eof do
    begin
      for j := 0 to ADataSet.FieldCount - 1 do
      begin
        if ADataSet.Fields[j] is TStringField then
        begin
          CellValue := ADataSet.Fields[j].AsString;
          TrimmedValueForValidation := ExtrairTextoParaValidacao(CellValue); // Usa o valor sem espa�os para valida��o

          if TrimmedValueForValidation <> '' then
          begin
            HasData := True;
            if Length(CellValue) > 300 then
            begin
              HasInvalidData := True;
              MsgErro := Format('C�lula na linha %d, coluna %d excede 300 caracteres.', [ADataSet.RecNo, j + 1]);
              Break;
            end;
            if ContemConteudoPerigoso(TrimmedValueForValidation) then
            begin
              HasInvalidData := True;
              MsgErro := Format('Conte�do potencialmente perigoso encontrado na linha %d, coluna %d.', [ADataSet.RecNo, j + 1]);
              Break;
            end;
          end;
        end;
      end;
      if HasInvalidData then Break;
      ADataSet.Next;
    end;
  finally
    ADataSet.EnableControls;
  end;

  if not HasData then
  begin
    MsgErro := 'A tabela deve conter pelo menos uma c�lula preenchida.';
    HasInvalidData := True;
  end;

  if HasInvalidData then
  begin
    ShowMessage('Erro de valida��o: ' + MsgErro + sLineBreak + 'Por favor, corrija os dados antes de salvar.');
  end
  else
  begin
    Result := True;
  end;
end;

// Novo m�todo para preparar dados para transforma��o
function TEditarTabelaService.PrepararParaTransformacao(ADataSet: TClientDataSet): TPreparedData;
var
  RowIndex: Integer;
  ColIndex: Integer;
  HasRowData: Boolean;
  CellValue: string;
  TrimmedValue: string;
  CurrentRow: TRowData;
  CurrentCell: TCellData;
begin
  SetLength(Result, 0); // Inicializa array vazio
  if not Assigned(ADataSet) or not ADataSet.Active or ADataSet.IsEmpty then
    Exit;

  ADataSet.DisableControls;
  try
    ADataSet.First;
    RowIndex := 1; // Come�a da linha 1
    while not ADataSet.Eof do
    begin
      HasRowData := False;
      SetLength(CurrentRow.Cells, 0); // Inicializa array de c�lulas vazio

      for ColIndex := 0 to ADataSet.FieldCount - 1 do
      begin
        if ADataSet.Fields[ColIndex] is TStringField then
        begin
          CellValue := ADataSet.Fields[ColIndex].AsString;
          TrimmedValue := Trim(CellValue); // Verifica se tem conte�do

          if TrimmedValue <> '' then
          begin
            HasRowData := True;
            // Adiciona c�lula v�lida ao array tempor�rio da linha
            SetLength(CurrentRow.Cells, Length(CurrentRow.Cells) + 1);
            CurrentCell.Row := RowIndex;
            CurrentCell.Col := ColIndex + 1; // Converte para base 1
            CurrentCell.Value := CellValue; // Passa o valor original (com espa�os)
            CurrentRow.Cells[High(CurrentRow.Cells)] := CurrentCell;
          end;
        end;
      end;

      if HasRowData then
      begin
        CurrentRow.Number := RowIndex;
        // Adiciona linha v�lida ao array de resultado
        SetLength(Result, Length(Result) + 1);
        Result[High(Result)] := CurrentRow;
      end;

      ADataSet.Next;
      Inc(RowIndex);
    end;
  finally
    ADataSet.EnableControls;
  end;
end;


procedure TEditarTabelaService.Salvar(ATabelaDTO: TTabelaDTO; ADataSet: TClientDataSet);
begin
  if not Assigned(ATabelaDTO) or not Assigned(ADataSet) then
    raise Exception.Create('DTO ou DataSet n�o fornecidos para salvamento.');

  // Chama o XMLService para salvar o arquivo XML
//  FXMLService.SalvarArquivoXML(ATabelaDTO, ADataSet);
end;

end.
