unit UPrincipalService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Forms,
  System.IOUtils,
  Xml.XMLDoc, Xml.XMLIntf,
  UCSVService;

type
  TPrincipalService = class
  public
    function ObterListaPlanilhas: TStringList;
    function ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TStringList;
    function ObterCaminhoCSV(const APlanilhaNome, ATabelaNome: string): string;
    function ExcluirPlanilha(const APlanilhaNome: string): boolean;
    function ExcluirTabela(const ATabelaNome: string; APlanilhaNome:string ): boolean;
  end;

implementation

{ TPrincipalService }

function TPrincipalService.ObterCaminhoCSV(const APlanilhaNome, ATabelaNome: string): string;
begin
  result := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
            'Planilhas' + PathDelim + APlanilhaNome + PathDelim +
            'Tabelas' + PathDelim + ATabelaNome + PathDelim + ATabelaNome + '.csv';
end;

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

function TPrincipalService.ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TStringList;
var
  DiretorioPlanilha, DiretorioTabelas: string;
  SubDirs: TArray<string>;
  i: Integer;
  NomeTabela: string;
begin
  Result := TStringList.Create;
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
        // Extrair apenas o nome da pasta
        NomeTabela := ExtractFileName(SubDirs[i]);
        // Adicionar à lista se o nome não for vazio
        if NomeTabela <> '' then
          Result.Add(NomeTabela);
      end;

  except
    on E: Exception do
    begin
      Result.Clear; // Limpa qualquer dado parcial
      Result.Add('Erro ao ler pastas de tabelas: ' + E.Message); // Adiciona mensagem de erro
      // Poderia logar a exceção também, se TLogService estivesse disponível e configurado aqui
    end;
  end;
end;

function TPrincipalService.ExcluirPlanilha(const APlanilhaNome: string): boolean;
var
CaminhoDiretorio: string;
begin
  CaminhoDiretorio := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
            'Planilhas' + PathDelim + APlanilhaNome;
  if TDirectory.Exists(CaminhoDiretorio) then
  begin
    // Exclui o diretório e todo o seu conteúdo (arquivos e subdiretórios)
    TDirectory.Delete(CaminhoDiretorio, True);
    Result := true;
  end
  else
  begin
    result := false;
  end;
end;

function TPrincipalService.ExcluirTabela(const ATabelaNome: string; APlanilhaNome:string): boolean;
var
CaminhoDiretorio: string;
begin
  CaminhoDiretorio := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
            'Planilhas' + PathDelim + APlanilhaNome + PathDelim + 'Tabelas' + PathDelim + ATabelaNome;
  if TDirectory.Exists(CaminhoDiretorio) then
  begin
    // Exclui o diretório e todo o seu conteúdo (arquivos e subdiretórios)
    TDirectory.Delete(CaminhoDiretorio, True);
    Result := true;
  end
  else
  begin
    result := false;
    exit;
  end;
end;

end.
