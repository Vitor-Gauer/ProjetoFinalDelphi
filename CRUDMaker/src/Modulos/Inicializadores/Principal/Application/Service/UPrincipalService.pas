unit UPrincipalService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Forms,
  System.IOUtils,
  Xml.XMLDoc, Xml.XMLIntf,
  UCSVService;

type
  TInfoTabelaPlanilhaDTO = class
  public
    Nome: string;
    Dimensoes: string; // Ex: "100x200" ou mensagem de erro
    TamanhoMB: string; // Ex: "2.50 MB"
    constructor Create(const ANome, ADimensoes, ATamanhoMB: string);
  end;

  TPrincipalService = class
  public
    function ObterListaPlanilhas: TStringList;
    function ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
  end;

implementation

{ TInfoTabelaPlanilhaDTO }

constructor TInfoTabelaPlanilhaDTO.Create(const ANome, ADimensoes, ATamanhoMB: string);
begin
  inherited Create;
  Nome := ANome;
  Dimensoes := ADimensoes;
  TamanhoMB := ATamanhoMB;
end;

{ TPrincipalService }

function TPrincipalService.ObterListaPlanilhas: TStringList;
var
  DiretorioPlanilhas: string;
  Diretorios: TArray<string>;
  i: Integer;
  NomePasta: string;
begin
  Result := TStringList.Create;
  try
    // Caminho da pasta 'Planilhas' relativo ao executável
    DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';
    if TDirectory.Exists(DiretorioPlanilhas) then
    begin
      // Obter todos os subdiretórios
      Diretorios := TDirectory.GetDirectories(DiretorioPlanilhas);
      for i := Low(Diretorios) to High(Diretorios) do
      begin
        // Extrair apenas o nome da pasta
        NomePasta := ExtractFileName(Diretorios[i]);
        // Adicionar à lista se o nome não for vazio
        if NomePasta <> '' then
          Result.Add(NomePasta);
      end;
    end;
    // Resultado pode estar vazio se a pasta não existir ou estiver vazia, o que é aceitável.
  except
    on E: Exception do
    begin
      Result.Clear; // Limpa qualquer dado parcial
      Result.Add('Erro ao ler pastas de planilhas: ' + E.Message); // Adiciona mensagem de erro
      // Poderia logar a exceção também, se TLogService estivesse disponível e configurado aqui
    end;
  end;
end;

function TPrincipalService.ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
var
  DiretorioPlanilha, DiretorioTabelas: string;
  SubDirs: TArray<string>;
  i: Integer;
  NomeTabela: string;
  CaminhoPastaTabela: string;
  ArquivosCSV: TArray<string>;
  CaminhoCSV: string;
  TamanhoBytes: Int64;
  TamanhoMB: string;
  Dimensoes: string;
  InfoTabela: TInfoTabelaPlanilhaDTO;
  TabelasProcessadas: TStringList;
  LCSVService: TCSVService; // Variável local temporária
begin
  Result := TObjectList<TInfoTabelaPlanilhaDTO>.Create(True); // OwnsObjects = True
  TabelasProcessadas := TStringList.Create;
  LCSVService := TCSVService.Create; // Cria uma instância temporária do CSVService
  try
    if ANomePlanilha = '' then
      Exit;

    DiretorioPlanilha := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas' + PathDelim + ANomePlanilha;
    DiretorioTabelas := IncludeTrailingPathDelimiter(DiretorioPlanilha) + 'Tabelas';
    if not TDirectory.Exists(DiretorioTabelas) then
      Exit;

    SubDirs := TDirectory.GetDirectories(DiretorioTabelas);

    for i := Low(SubDirs) to High(SubDirs) do
    begin
      NomeTabela := ExtractFileName(SubDirs[i]);
      CaminhoPastaTabela := SubDirs[i];

      // Procura arquivos .CSV na pasta da tabela
      ArquivosCSV := TDirectory.GetFiles(CaminhoPastaTabela, '*.csv');
      if Length(ArquivosCSV) > 0 then
      begin
        CaminhoCSV := ArquivosCSV[0]; // Assume o primeiro CSV encontrado

        // --- USAR O SERVIÇO IMPLEMENTADO ---
        try
          // Obter Dimensões do Arquivo CSV usando o serviço
          Dimensoes := LCSVService.ObterDimensoesDoCSV(CaminhoCSV);
          if Dimensoes.StartsWith('Erro') then
          begin
             // Se o serviço retornar um erro, use uma string de erro
             Dimensoes := Dimensoes; // Mantém a mensagem de erro
          end;
        except
          on E: Exception do
            Dimensoes := 'Erro ao ler CSV: ' + E.Message; // Tratamento de exceção adicional
        end;

        // Obter Tamanho do Arquivo CSV
        TamanhoBytes := TFile.GetSize(CaminhoCSV);
        TamanhoMB := FormatFloat('0.00 MB', TamanhoBytes / (1024 * 1024));

        // Criar o DTO com os dados obtidos (Nome, Dimensoes, TamanhoMB)
        // O formato (CSV) e o caminho são informações internas para o cálculo,
        // mas o DTO final só precisa dos dados resumidos.
        InfoTabela := TInfoTabelaPlanilhaDTO.Create(NomeTabela, Dimensoes, TamanhoMB);
        Result.Add(InfoTabela);
        TabelasProcessadas.Add(NomeTabela); // Marca como processada via CSV
      end;
      // NÃO PROCESSAR XML - Conforme instrução "Não irá ser feito chamada por XML"
      // O bloco 'else' que lia XML foi removido.
    end;

  finally
    LCSVService.Free; // Libera o serviço temporário
    TabelasProcessadas.Free;
  end;
end;

end.

end.
