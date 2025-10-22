unit UCSVService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient,
  System.StrUtils, System.Math, System.IOUtils, // Para Random,
  UTabelaDTO; // Adiciona UTabelaDTO

type
  // Service respons�vel por opera��es de exporta��o/importa��o em formato CSV.
  TCSVService = class
  private
    // Gera uma string hash aleat�ria de 20 d�gitos num�ricos.
    function GerarHashCSV: string;
    // Escreve o cabe�alho CSV (nomes das colunas) no Stream.
    // <param name="AStream">Stream onde o CSV est� sendo escrito.</param>
    procedure EscreverCabecalhoCSV(AStream: TStream; AClientDataSet: TClientDataSet);

    // Escreve os dados de uma linha do ClientDataSet no Stream como CSV.
    // <param name="ADelimitador">Caractere delimitador (geralmente v�rgula).</param>
    procedure EscreverLinhaCSV(AStream: TStream; AClientDataSet: TClientDataSet; const ADelimitador: Char = ',');
  public
    // Carrega os dados de um arquivo CSV para o ClientDataSet.
    // Assume que a primeira linha cont�m os cabe�alhos.
    procedure LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);

    // Exporta os dados do ClientDataSet para um arquivo CSV.
    // Gera um hash �nico para o DTO.
    // <param name="ATabelaDTO">DTO da tabela para atualizar o caminho e o hash.</param>
    procedure GravarCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);

    // Fun��o auxiliar para obter o hash gerado (se necess�rio fora do GravarCSV).
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
  Randomize; // Inicializa o gerador de n�meros aleat�rios

  // Gera 20 d�gitos num�ricos
  for i := 1 to 20 do
  begin
    Result := Result + Digitos[Random(Length(Digitos)) + 1];
  end;
end;

function TCSVService.ObterUltimoHashGerado: string;
begin
  // Esta implementa��o simples n�o armazena o �ltimo hash.
  // Se for necess�rio acessar o hash fora de GravarCSV, considere armazen�-lo em um campo privado.
  // Por enquanto, vamos gerar um novo hash se chamado.
  Result := GerarHashCSV;
end;

procedure TCSVService.EscreverCabecalhoCSV(AStream: TStream; AClientDataSet: TClientDataSet);
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
  Cabecalho := Cabecalho + sLineBreak; // Adiciona quebra de linha
  Bytes := TEncoding.UTF8.GetBytes(Cabecalho);
  AStream.WriteBuffer(Bytes, Length(Bytes));
end;

procedure TCSVService.EscreverLinhaCSV(AStream: TStream; AClientDataSet: TClientDataSet; const ADelimitador: Char = ',');
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
    // Escapa aspas duplas dentro do valor
    Valor := StringReplace(Valor, '"', '""', [rfReplaceAll]);
    Linha := Linha + '"' + Valor + '"';
  end;
  Linha := Linha + sLineBreak; // Adiciona quebra de linha
  Bytes := TEncoding.UTF8.GetBytes(Linha);
  AStream.WriteBuffer(Bytes, Length(Bytes));
end;

procedure TCSVService.GravarCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
var
  FileStream: TFileStream;
  Bookmark: TBookmark;
  NovoHashCSV: string; // Renomeado
begin
  if not Assigned(AClientDataSet) or not AClientDataSet.Active then
    raise Exception.Create('ClientDataSet inv�lido ou n�o ativo.');

  if ACaminhoArquivo = '' then
    raise Exception.Create('Caminho do arquivo CSV inv�lido.');

  if not Assigned(ATabelaDTO) then
     raise Exception.Create('DTO da tabela n�o fornecido para atualiza��o do hash.');

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

  // Gera hash e atualiza DTO
  NovoHashCSV := GerarHashCSV(); // Renomeado
  ATabelaDTO.HashCSV := NovoHashCSV;
  ATabelaDTO.CaminhoArquivoCSV := ACaminhoArquivo; // Garante que o caminho est� atualizado
end;

procedure TCSVService.LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);
var
  FileStream: TStreamReader; // Usar StreamReader para lidar com codifica��o
  Line: string;
  Headers: TArray<string>;
  i: Integer;
  FieldDef: TFieldDef;
  RowValues: TArray<string>;
begin
  if not Assigned(AClientDataSet) then
    raise Exception.Create('ClientDataSet inv�lido.');

  if (ACaminhoArquivo = '') or not TFile.Exists(ACaminhoArquivo) then
    raise Exception.Create('Caminho do arquivo CSV inv�lido ou arquivo n�o encontrado: ' + ACaminhoArquivo);

  // Certifica que o DataSet est� fechado antes de come�ar
  AClientDataSet.Close;
  AClientDataSet.FieldDefs.Clear; // Limpa defini��es anteriores

  FileStream := TStreamReader.Create(ACaminhoArquivo, TEncoding.UTF8);
  try
    // --- Ler a primeira linha (cabe�alho) ---
    if FileStream.EndOfStream then
      Exit; // Arquivo vazio

    Line := FileStream.ReadLine;
    if Line = '' then
      Exit; // Primeira linha vazia

    Headers := Line.Split([',']);

    // --- Criar defini��es de campo baseadas nos cabe�alhos ---
    for i := Low(Headers) to High(Headers) do
    begin
      Headers[i] := Trim(Headers[i]); // Remover espa�os em branco
      if Headers[i] = '' then
        Headers[i] := 'Campo' + IntToStr(i); // Nome padr�o se o cabe�alho estiver vazio

      FieldDef := AClientDataSet.FieldDefs.AddFieldDef;
      FieldDef.Name := Headers[i];
      FieldDef.DataType := ftString; // Come�amos com string, pode ser refinado posteriormente
      FieldDef.Size := 255; // Tamanho padr�o, ajust�vel
    end;

    // --- Abrir o DataSet ---
    AClientDataSet.CreateDataSet;
    AClientDataSet.Open;

    // --- Ler linhas de dados ---
    while not FileStream.EndOfStream do
    begin
      Line := FileStream.ReadLine;
      if Line <> '' then // Ignorar linhas vazias
      begin
        // Separar os valores da linha (simplificado)
        RowValues := Line.Split([',']);

        AClientDataSet.Append;
        // Preencher campos da linha
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
