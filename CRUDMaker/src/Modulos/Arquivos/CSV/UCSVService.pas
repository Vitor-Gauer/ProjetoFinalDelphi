unit UCSVService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient,
  System.StrUtils, System.Math, System.IOUtils, // Para Random,
  UTabelaDTO; // Adiciona UTabelaDTO

type
  // Service responsável por operações de exportação/importação em formato CSV.
  TCSVService = class
  private
    // Gera uma string hash aleatória de 20 dígitos numéricos.
    function GerarHashCSV: string;
    // Escreve o cabeçalho CSV (nomes das colunas) no Stream.
    // <param name="AStream">Stream onde o CSV está sendo escrito.</param>
    procedure EscreverCabecalhoCSV(AStream: TStream; AClientDataSet: TDataSet);


    // Escreve os dados de uma linha do ClientDataSet no Stream como CSV.
    // <param name="ADelimitador">Caractere delimitador (geralmente vírgula).</param>
    procedure EscreverLinhaCSV(AStream: TStream; AClientDataSet: TDataSet; const ADelimitador: Char = ',');
  public
    // Carrega os dados de um arquivo CSV para o ClientDataSet.
    // Assume que a primeira linha contém os cabeçalhos.
    procedure LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);

    // Exporta os dados do ClientDataSet para um arquivo CSV.
    // Gera um hash único para o DTO.
    // <param name="ATabelaDTO">DTO da tabela para atualizar o caminho e o hash.</param>
    procedure GravarCSV(const AClientDataSet: TDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);

    // Função auxiliar para obter o hash gerado (se necessário fora do GravarCSV).
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
  Randomize; // Inicializa o gerador de números aleatórios

  // Gera 20 dígitos numéricos
  for i := 1 to 20 do
  begin
    Result := Result + Digitos[Random(Length(Digitos)) + 1];
  end;
end;

function TCSVService.ObterUltimoHashGerado: string;
begin
  // Esta implementação simples não armazena o último hash.
  // Se for necessário acessar o hash fora de GravarCSV, considere armazená-lo em um campo privado.
  // Por enquanto, vamos gerar um novo hash se chamado.
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
  Cabecalho := Cabecalho + sLineBreak; // Adiciona quebra de linha
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
    // Escapa aspas duplas dentro do valor
    Valor := StringReplace(Valor, '"', '""', [rfReplaceAll]);
    Linha := Linha + '"' + Valor + '"';
  end;
  Linha := Linha + sLineBreak; // Adiciona quebra de linha
  Bytes := TEncoding.UTF8.GetBytes(Linha);
  AStream.WriteBuffer(Bytes, Length(Bytes));
end;

procedure TCSVService.GravarCSV(const AClientDataSet: TDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
var
  FileStream: TFileStream;
  Bookmark: TBookmark;
  NovoHashCSV: string; // Renomeado
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

  // Gera hash e atualiza DTO
  NovoHashCSV := GerarHashCSV(); // Renomeado
  ATabelaDTO.HashCSV := NovoHashCSV;
  ATabelaDTO.CaminhoArquivoCSV := ACaminhoArquivo; // Garante que o caminho está atualizado
end;

procedure TCSVService.LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);
var
  FileStream: TStreamReader; // Usar StreamReader para lidar com codificação
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

  // Certifica que o DataSet está fechado antes de começar
  AClientDataSet.Close;
  AClientDataSet.FieldDefs.Clear; // Limpa definições anteriores

  FileStream := TStreamReader.Create(ACaminhoArquivo, TEncoding.UTF8);
  try
    // --- Ler a primeira linha (cabeçalho) ---
    if FileStream.EndOfStream then
      Exit; // Arquivo vazio

    Line := FileStream.ReadLine;
    if Line = '' then
      Exit; // Primeira linha vazia

    Headers := Line.Split(['","']);

    if Length(Headers) > 0 then // se está dentro do headers
    begin
      // Remove a aspa de abertura da primeira coluna
      if (Length(Headers[Low(Headers)]) > 0) and (Headers[Low(Headers)][1] = '"') then
        Headers[Low(Headers)] := Copy(Headers[Low(Headers)], 2, MaxInt);

      // Remove a aspa de fechamento da última coluna
      if (Length(Headers[High(Headers)]) > 0) and (Headers[High(Headers)][Length(Headers[High(Headers)])] = '"') then
        Headers[High(Headers)] := Copy(Headers[High(Headers)], 1, Length(Headers[High(Headers)]) - 1);
    end;
    // --- Criar definições de campo baseadas nos cabeçalhos ---
    for i := Low(Headers) to High(Headers) do
    begin
      Headers[i] := Trim(Headers[i]); // Remover espaços em branco
      if Headers[i] = '' then
        Headers[i] := 'Campo' + IntToStr(i); // Nome padrão se o cabeçalho estiver vazio

      FieldDef := AClientDataSet.FieldDefs.AddFieldDef;
      FieldDef.Name := Headers[i];
      FieldDef.DataType := ftString; // Começamos com string, pode ser refinado posteriormente
      FieldDef.Size := 50000;
    end;

    // --- Abrir o DataSet ---
    AClientDataSet.CreateDataSet;
    AClientDataSet.Open;

    // --- Definir o tamanho das colunas que serão mostradas para o usuario ---
    for i := 0 to AClientDataSet.FieldCount - 1 do
    begin
        AClientDataSet.Fields[i].DisplayWidth := 80;
    end;

    // --- Ler linhas de dados ---
    while not FileStream.EndOfStream do
    begin
      Line := FileStream.ReadLine;
      if Line <> '' then // Ignorar linhas vazias
      begin
        // Separar os valores da linha (simplificado)
        RowValues := Line.Split(['","']);

        if Length(RowValues) > 0 then
        begin
          // Remove a aspa de abertura da primeira coluna
          (* Se primeiro valor posicional é não vazio e se primeiro valor posicional, '[1]', for '"' então... *)
          if (Length(RowValues[Low(RowValues)]) > 0) and (RowValues[Low(RowValues)][1] = '"') then
            RowValues[Low(RowValues)] := Copy(RowValues[Low(RowValues)], 2, MaxInt);

          // Remove a aspa de fechamento da última coluna:
          (* Se array é não vazio e se ultimo valor posicional for '"' então *)
          if (Length(RowValues[High(RowValues)]) > 0) and (RowValues[High(RowValues)][Length(RowValues[High(RowValues)])] = '"') then
            RowValues[High(RowValues)] := Copy(RowValues[High(RowValues)], 1, Length(RowValues[High(RowValues)]) - 1);
        end;

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
