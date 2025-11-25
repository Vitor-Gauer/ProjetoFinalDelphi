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
    DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';
    if TDirectory.Exists(DiretorioPlanilhas) then
    begin
      Diretorios := TDirectory.GetDirectories(DiretorioPlanilhas);
      for i := Low(Diretorios) to High(Diretorios) do
      begin
        NomePasta := ExtractFileName(Diretorios[i]);
        if NomePasta <> '' then
          Result.Add(NomePasta);
      end;
    end;
  except
    on E: Exception do
    begin
      Result.Clear;
      Result.Add('Erro ao ler pastas de planilhas: ' + E.Message);
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
        NomeTabela := ExtractFileName(SubDirs[i]);
        if NomeTabela <> '' then
          Result.Add(NomeTabela);
      end;

  except
    on E: Exception do
    begin
      Result.Clear;
      Result.Add('Erro ao ler pastas de tabelas: ' + E.Message);
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
