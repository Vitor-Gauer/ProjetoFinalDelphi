unit UEditarTabelaService;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,
  UTabelaDTO, UCSVService;

type
  TCellData = record
    Row: Integer;
    Col: Integer;
    Value: string;
  end;

  TRowData = record
    Number: Integer;
    Cells: TArray<TCellData>;
  end;

  TPreparedData = TArray<TRowData>;

  TEditarTabelaService = class
  private
    FCSVService: TCSVService;
    function ContemConteudoPerigoso(const ATexto: string): Boolean;
    function ExtrairTextoParaValidacao(const ATexto: string): string;
  public
    constructor Create(ACSVService: TCSVService);
    destructor Destroy; override;

    function Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
    function ValidarDados(ADataSet: TDataSet): Boolean;
    function PrepararParaTransformacao(ADataSet: TClientDataSet): TPreparedData;
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

  TempDataSet.Free;
end;

function TEditarTabelaService.ExtrairTextoParaValidacao(const ATexto: string): string;
begin
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

  if not Assigned(ADataSet) or not ADataSet.Active then
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
          TrimmedValueForValidation := ExtrairTextoParaValidacao(CellValue);

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
  SetLength(Result, 0);
  if not Assigned(ADataSet) or not ADataSet.Active or ADataSet.IsEmpty then
    Exit;

  ADataSet.DisableControls;
  try
    ADataSet.First;
    RowIndex := 1;
    while not ADataSet.Eof do
    begin
      HasRowData := False;
      SetLength(CurrentRow.Cells, 0);

      for ColIndex := 0 to ADataSet.FieldCount - 1 do
      begin
        if ADataSet.Fields[ColIndex] is TStringField then
        begin
          CellValue := ADataSet.Fields[ColIndex].AsString;
          TrimmedValue := Trim(CellValue);

          if TrimmedValue <> '' then
          begin
            HasRowData := True;

            SetLength(CurrentRow.Cells, Length(CurrentRow.Cells) + 1);
            CurrentCell.Row := RowIndex;
            CurrentCell.Col := ColIndex + 1;
            CurrentCell.Value := CellValue;
            CurrentRow.Cells[High(CurrentRow.Cells)] := CurrentCell;
          end;
        end;
      end;

      if HasRowData then
      begin
        CurrentRow.Number := RowIndex;
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
