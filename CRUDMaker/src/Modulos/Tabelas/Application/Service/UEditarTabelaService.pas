unit UEditarTabelaService;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,
  UTabelaDTO, UCSVService;

type
  // Record para representar uma célula válida
  TCellData = record
    Row: Integer;
    Col: Integer; // Base 1
    Value: string;
  end;

  // Record para representar uma linha válida
  TRowData = record
    Number: Integer;
    Cells: TArray<TCellData>;
  end;

  // Tipo para os dados preparados para transformação
  TPreparedData = TArray<TRowData>;

  TEditarTabelaService = class
  private
    FCSVService: TCSVService;
    function ContemConteudoPerigoso(const ATexto: string): Boolean;
    function ExtrairTextoParaValidacao(const ATexto: string): string; // Remove espaços para validação
  public
    constructor Create(ACSVService: TCSVService);
    destructor Destroy; override;

    function Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
    function ValidarDados(ADataSet: TDataSet): Boolean;
    function PrepararParaTransformacao(ADataSet: TClientDataSet): TPreparedData; // Novo método
    procedure Salvar(ADataSet: TDataSet; ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
  end;

implementation

{ TEditarTabelaService }

constructor TEditarTabelaService.Create(ACSVService: TCSVService);
begin
  inherited Create;
  FCSVService := ACSVService;
end;

destructor TEditarTabelaService.Destroy;
begin
  // FXMLService é injetado, não deve ser destruído aqui
  inherited;
end;

function TEditarTabelaService.Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
var
  TempDataSet: TClientDataSet;
begin
  if not Assigned(ATabelaDTO) then
    raise Exception.Create('TabelaDTO não fornecido para carregamento.');

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
  // Remove espaços iniciais e finais para validação
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
  // Adicione mais verificações conforme necessário
end;

function TEditarTabelaService.ValidarDados(ADataSet: TDataSet): Boolean;
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

  if not Assigned(ADataSet) or not ADataSet.Active then // Se ADataSet Nao existir ou Se o DataSet estiver Inativo,
  begin
    MsgErro := 'DataSet inválido ou inativo.';
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
          TrimmedValueForValidation := ExtrairTextoParaValidacao(CellValue); // Usa o valor sem espaços para validação

          if TrimmedValueForValidation <> '' then
          begin
            HasData := True;
            if ContemConteudoPerigoso(TrimmedValueForValidation) then
            begin
              HasInvalidData := True;
              MsgErro := Format('Conteúdo potencialmente perigoso encontrado na linha %d, coluna %d.', [ADataSet.RecNo, j + 1]);
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
    MsgErro := 'A tabela deve conter pelo menos uma célula preenchida.';
    HasInvalidData := True;
  end;

  if HasInvalidData then
  begin
    ShowMessage('Erro de validação: ' + MsgErro + sLineBreak + 'Por favor, corrija os dados antes de salvar.');
  end
  else
  begin
    Result := True;
  end;
end;

// Novo método para preparar dados para transformação
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
    RowIndex := 1; // Começa da linha 1
    while not ADataSet.Eof do
    begin
      HasRowData := False;
      SetLength(CurrentRow.Cells, 0); // Inicializa array de células vazio

      for ColIndex := 0 to ADataSet.FieldCount - 1 do
      begin
        if ADataSet.Fields[ColIndex] is TStringField then
        begin
          CellValue := ADataSet.Fields[ColIndex].AsString;
          TrimmedValue := Trim(CellValue); // Verifica se tem conteúdo

          if TrimmedValue <> '' then
          begin
            HasRowData := True;
            // Adiciona célula válida ao array temporário da linha
            SetLength(CurrentRow.Cells, Length(CurrentRow.Cells) + 1);
            CurrentCell.Row := RowIndex;
            CurrentCell.Col := ColIndex + 1; // Converte para base 1
            CurrentCell.Value := CellValue; // Passa o valor original (com espaços)
            CurrentRow.Cells[High(CurrentRow.Cells)] := CurrentCell;
          end;
        end;
      end;

      if HasRowData then
      begin
        CurrentRow.Number := RowIndex;
        // Adiciona linha válida ao array de resultado
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


procedure TEditarTabelaService.Salvar(ADataSet: TDataSet; ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
begin
  if not Assigned(ATabelaDTO) or not Assigned(ADataSet) then
    raise Exception.Create('DTO ou DataSet não fornecidos para salvamento.');

  FCSVService.GravarCSV(ADataSet, ACaminhoArquivo, ATabelaDTO)
end;

end.
