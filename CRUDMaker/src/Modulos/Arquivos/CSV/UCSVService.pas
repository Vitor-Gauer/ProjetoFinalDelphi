unit UCSVService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient,
  System.StrUtils, System.Math, System.IOUtils,
  UTabelaDTO;

type
  TCSVService = class
  private
    function GerarHashCSV: string;
    procedure EscreverCabecalhoCSV(AStream: TStream; AClientDataSet: TDataSet);
    procedure EscreverLinhaCSV(AStream: TStream; AClientDataSet: TDataSet; const ADelimitador: Char = ',');
  public
    procedure LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);
    procedure GravarCSV(const AClientDataSet: TDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
    function ObterUltimoHashGerado: string;
  end;

implementation

{ TCSVService }

function TCSVService.GerarHashCSV: string;
const
  Digitos = '0123456789';
var
  i: Integer;
begin
  Result := '';
  Randomize;

  for i := 1 to 20 do
  begin
    Result := Result + Digitos[Random(Length(Digitos)) + 1];
  end;
end;

function TCSVService.ObterUltimoHashGerado: string;
begin
  Result := GerarHashCSV;
end;

procedure TCSVService.EscreverCabecalhoCSV(AStream: TStream; AClientDataSet: TDataSet);
var
  i: Integer;
  Field: TField;
  Cabecalho: string;
  Bytes: TBytes;
begin
  Cabecalho := '';
  for i := 0 to AClientDataSet.FieldCount - 1 do
  begin
    Field := AClientDataSet.Fields[i];
    if i > 0 then
      Cabecalho := Cabecalho + ',';
    Cabecalho := Cabecalho + '"' + StringReplace(Field.FieldName, '"', '""', [rfReplaceAll]) + '"';
  end;
  Cabecalho := Cabecalho + sLineBreak;
  Bytes := TEncoding.UTF8.GetBytes(Cabecalho);
  AStream.WriteBuffer(Bytes, Length(Bytes));
end;

procedure TCSVService.EscreverLinhaCSV(AStream: TStream; AClientDataSet: TDataSet; const ADelimitador: Char = ',');
var
  i: Integer;
  Field: TField;
  Valor: string;
  Linha: string;
  Bytes: TBytes;
begin
  Linha := '';
  for i := 0 to AClientDataSet.FieldCount - 1 do
  begin
    Field := AClientDataSet.Fields[i];
    if i > 0 then
      Linha := Linha + ADelimitador;
    Valor := Field.AsString;
    Valor := StringReplace(Valor, '"', '""', [rfReplaceAll]);
    Linha := Linha + '"' + Valor + '"';
  end;
  Linha := Linha + sLineBreak;
  Bytes := TEncoding.UTF8.GetBytes(Linha);
  AStream.WriteBuffer(Bytes, Length(Bytes));
end;

procedure TCSVService.GravarCSV(const AClientDataSet: TDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
var
  FileStream: TFileStream;
  Bookmark: TBookmark;
  NovoHashCSV: string;
begin
  if not Assigned(AClientDataSet) or not AClientDataSet.Active then
    raise Exception.Create('ClientDataSet inválido ou não ativo.');

  if ACaminhoArquivo = '' then
    raise Exception.Create('Caminho do arquivo CSV inválido.');

  if not Assigned(ATabelaDTO) then
     raise Exception.Create('DTO da tabela não fornecido para atualização do hash.');

  FileStream := TFileStream.Create(ACaminhoArquivo, fmCreate);
  try
    AClientDataSet.DisableControls;
    Bookmark := AClientDataSet.GetBookmark;
    try
      EscreverCabecalhoCSV(FileStream, AClientDataSet);

      AClientDataSet.First;
      while not AClientDataSet.Eof do
      begin
        EscreverLinhaCSV(FileStream, AClientDataSet);
        AClientDataSet.Next;
      end;
    finally
      AClientDataSet.GotoBookmark(Bookmark);
      AClientDataSet.EnableControls;
    end;
  finally
    FileStream.Free;
  end;

  NovoHashCSV := GerarHashCSV();
  ATabelaDTO.HashCSV := NovoHashCSV;
  ATabelaDTO.CaminhoArquivoCSV := ACaminhoArquivo;
end;

procedure TCSVService.LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);
var
  FileStream: TStreamReader;
  Line: string;
  Headers: TArray<string>;
  i: Integer;
  FieldDef: TFieldDef;
  RowValues: TArray<string>;
begin
  if acaminhoarquivo = '0' then

  if not Assigned(AClientDataSet) then
    raise Exception.Create('ClientDataSet inválido.');

  if (ACaminhoArquivo = '') or not TFile.Exists(ACaminhoArquivo) then
    raise Exception.Create('Caminho do arquivo CSV inválido ou arquivo não encontrado: ' + ACaminhoArquivo);

  AClientDataSet.Close;
  AClientDataSet.FieldDefs.Clear;

  FileStream := TStreamReader.Create(ACaminhoArquivo, TEncoding.UTF8);
  try
    if FileStream.EndOfStream then
      Exit;

    Line := FileStream.ReadLine;
    if Line = '' then
      Exit;

    Headers := Line.Split(['","']);

    if Length(Headers) > 0 then
    begin
      if (Length(Headers[Low(Headers)]) > 0) and (Headers[Low(Headers)][1] = '"') then
        Headers[Low(Headers)] := Copy(Headers[Low(Headers)], 2, MaxInt);

      if (Length(Headers[High(Headers)]) > 0) and (Headers[High(Headers)][Length(Headers[High(Headers)])] = '"') then
        Headers[High(Headers)] := Copy(Headers[High(Headers)], 1, Length(Headers[High(Headers)]) - 1);
    end;
    for i := Low(Headers) to High(Headers) do
    begin
      Headers[i] := Trim(Headers[i]);
      if Headers[i] = '' then
        Headers[i] := 'Campo' + IntToStr(i);

      FieldDef := AClientDataSet.FieldDefs.AddFieldDef;
      FieldDef.Name := Headers[i];
      FieldDef.DataType := ftString;
      FieldDef.Size := 50000;
    end;

    AClientDataSet.CreateDataSet;
    AClientDataSet.Open;

    for i := 0 to AClientDataSet.FieldCount - 1 do
    begin
        AClientDataSet.Fields[i].DisplayWidth := 80;
    end;

    while not FileStream.EndOfStream do
    begin
      Line := FileStream.ReadLine;
      if Line <> '' then
      begin
        RowValues := Line.Split(['","']);

        if Length(RowValues) > 0 then
        begin
          if (Length(RowValues[Low(RowValues)]) > 0) and (RowValues[Low(RowValues)][1] = '"') then
            RowValues[Low(RowValues)] := Copy(RowValues[Low(RowValues)], 2, MaxInt);

          if (Length(RowValues[High(RowValues)]) > 0) and (RowValues[High(RowValues)][Length(RowValues[High(RowValues)])] = '"') then
            RowValues[High(RowValues)] := Copy(RowValues[High(RowValues)], 1, Length(RowValues[High(RowValues)]) - 1);
        end;

        AClientDataSet.Append;
        for i := Low(RowValues) to Min(High(RowValues), High(Headers)) do
        begin
          if i < AClientDataSet.FieldCount then
            AClientDataSet.Fields[i].AsString := Trim(RowValues[i]);
        end;
        AClientDataSet.Post;
      end;
    end;

  finally
    FileStream.Free;
  end;
end;

end.
