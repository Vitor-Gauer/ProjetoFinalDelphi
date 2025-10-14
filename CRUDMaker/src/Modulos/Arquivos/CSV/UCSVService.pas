unit UCSVService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient,
  System.StrUtils, System.Math, // Para Random,
  UTabelaDTO; // Adiciona UTabelaDTO

type
  // Service responsável por operações de exportação/importação em formato CSV.
  TCSVService = class
  private
    // Gera uma string hash aleatória de 20 dígitos numéricos.
    function GerarHashCSV: string;
    // Escreve o cabeçalho CSV (nomes das colunas) no Stream.
    // <param name="AStream">Stream onde o CSV está sendo escrito.</param>
    procedure EscreverCabecalhoCSV(AStream: TStream; AClientDataSet: TClientDataSet);

    // Escreve os dados de uma linha do ClientDataSet no Stream como CSV.
    // <param name="ADelimitador">Caractere delimitador (geralmente vírgula).</param>
    procedure EscreverLinhaCSV(AStream: TStream; AClientDataSet: TClientDataSet; const ADelimitador: Char = ',');
  public
    // Carrega os dados de um arquivo CSV para o ClientDataSet.
    // Assume que a primeira linha contém os cabeçalhos.
    procedure LerCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);

    // Exporta os dados do ClientDataSet para um arquivo CSV.
    // Gera um hash único para o DTO.
    // <param name="ATabelaDTO">DTO da tabela para atualizar o caminho e o hash.</param>
    procedure GravarCSV(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);

    // Função auxiliar para obter o hash gerado (se necessário fora do GravarCSV).
    function ObterUltimoHashGerado: string;

    // Obtém as dimensões (número de linhas e colunas) de um arquivo CSV.
    // Conta linhas (exceto o cabeçalho) e colunas (baseado no cabeçalho).
    function ObterDimensoesDoCSV(const ACaminhoArquivo: string): string;
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
begin
  if not Assigned(AClientDataSet) then
    raise Exception.Create('ClientDataSet inválido.');

  if (ACaminhoArquivo = '') or not FileExists(ACaminhoArquivo) then
    raise Exception.Create('Caminho do arquivo CSV inválido ou arquivo não encontrado.');

  AClientDataSet.Close;
  AClientDataSet.LoadFromFile(ACaminhoArquivo);
  AClientDataSet.Open;
end;

function TCSVService.ObterDimensoesDoCSV(const ACaminhoArquivo: string): string;
var
  TempClientDataSet: TClientDataSet;
  NumLinhas: Integer;
  NumColunas: Integer;
begin
  Result := 'Erro desconhecido';
  if (ACaminhoArquivo = '') or not FileExists(ACaminhoArquivo) then
  begin
    Result := 'Arquivo não encontrado';
    Exit;
  end;

  TempClientDataSet := TClientDataSet.Create(nil);
  try
    try
      // Lê o CSV para o ClientDataSet temporário
      Self.LerCSV(TempClientDataSet, ACaminhoArquivo);

      if TempClientDataSet.Active and not TempClientDataSet.IsEmpty then
      begin
        // Número de registros de dados (linhas) - desconsidera o registro de inserção
        NumLinhas := TempClientDataSet.RecordCount;
        // Número de campos (colunas) - baseado na estrutura carregada do CSV
        NumColunas := TempClientDataSet.FieldCount;

        // Formata a string de dimensões
        Result := IntToStr(NumLinhas) + 'x' + IntToStr(NumColunas);
      end
      else
      begin
        // CSV vazio ou não carregado corretamente
        Result := '0x0';
      end;
    except
      on E: Exception do
      begin
        // Captura qualquer erro durante a leitura ou contagem
        Result := 'Erro: ' + E.Message;
      end;
    end;
  finally
    TempClientDataSet.Free; // Libera o ClientDataSet temporário
  end;
end;

end.
