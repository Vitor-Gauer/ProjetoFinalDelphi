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
    function ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TStringList;
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
    // Caminho da pasta 'Planilhas' relativo ao execut�vel
    DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';
    if TDirectory.Exists(DiretorioPlanilhas) then
    begin
      // Obter todos os subdiret�rios
      Diretorios := TDirectory.GetDirectories(DiretorioPlanilhas);
      for i := Low(Diretorios) to High(Diretorios) do
      begin
        // Extrair apenas o nome da pasta
        NomePasta := ExtractFileName(Diretorios[i]);
        // Adicionar � lista se o nome n�o for vazio
        if NomePasta <> '' then
          Result.Add(NomePasta);
      end;
    end;
    // Resultado pode estar vazio se a pasta n�o existir ou estiver vazia, o que � aceit�vel.
  except
    on E: Exception do
    begin
      Result.Clear; // Limpa qualquer dado parcial
      Result.Add('Erro ao ler pastas de planilhas: ' + E.Message); // Adiciona mensagem de erro
      // Poderia logar a exce��o tamb�m, se TLogService estivesse dispon�vel e configurado aqui
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
        // Adicionar � lista se o nome n�o for vazio
        if NomeTabela <> '' then
          Result.Add(NomeTabela);
      end;

  except
    on E: Exception do
    begin
      Result.Clear; // Limpa qualquer dado parcial
      Result.Add('Erro ao ler pastas de tabelas: ' + E.Message); // Adiciona mensagem de erro
      // Poderia logar a exce��o tamb�m, se TLogService estivesse dispon�vel e configurado aqui
    end;
  end;
end;

end.
