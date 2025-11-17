unit UPersistenciaLocalService;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils, UTabelaDTO;

type
  TPersistenciaLocalService = class
  private
    function GetExePath: string;
  public
    constructor Create;
    destructor Destroy; override;

    function ValidarNomeGenerico(const ANome: string): Boolean;
    function ObterCaminhosDosArquivos(ATabelaDTO: TTabelaDTO): TArray<string>; // Ex: [XMLPath, CSVPath, PDFPath]

    // --- Novos métodos para Relatórios e Associações ---
    function CaminhodeTabela(const APlanilhaNome, ATabelaNome: string; ABackup: Boolean = False): string;
    function CaminhodePlanilha(const ANomePlanilha: string; ABackup: Boolean = False): string;
    function CaminhodeRelatorio(const ANomeRelatorio: string; ABackup: Boolean = False): string;
    function CaminhodeAssociacao(const APlanilhaNome, ANomeAssociacao: string; ABackup: Boolean = False): string;
    function CaminhodeDados(const ANomeArquivo: string): string;
    function CaminhoRelatoriosGerados: string;

  end;

implementation

{ TPersistenciaLocalService }

constructor TPersistenciaLocalService.Create;
begin
  inherited;
end;

destructor TPersistenciaLocalService.Destroy;
begin
  inherited;
end;

function TPersistenciaLocalService.GetExePath: string;
begin
  Result := ExtractFilePath(ParamStr(0));
end;

function TPersistenciaLocalService.ValidarNomeGenerico(const ANome: string): Boolean;
begin
  Result := True; // Assume válido inicialmente
  // Validação se o nome tem caracteres inválidos para nomes de pastas/arquivos no Windows
  if (Pos('\', ANome) > 0) or (Pos('/', ANome) > 0) or
     (Pos(':', ANome) > 0) or (Pos('*', ANome) > 0) or
     (Pos('?', ANome) > 0) or (Pos('"', ANome) > 0) or
     (Pos('<', ANome) > 0) or (Pos('>', ANome) > 0) or
     (Pos('|', ANome) > 0) then
    Result := False;
end;

function TPersistenciaLocalService.ObterCaminhosDosArquivos(ATabelaDTO: TTabelaDTO): TArray<string>;
begin
  SetLength(Result, 3);
  Result[0] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.xml');
  Result[1] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.csv');
  Result[2] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.pdf');
end;

function TPersistenciaLocalService.CaminhodeTabela(const APlanilhaNome, ATabelaNome: string; ABackup: Boolean = False): string;
var
  BasePath: string;
begin
  if ABackup then
    BasePath := TPath.Combine(GetExePath, 'Backup')
  else
    BasePath := GetExePath;

  Result := TPath.Combine(TPath.Combine(BasePath, 'Planilhas'), APlanilhaNome, ATabelaNome);
end;

function TPersistenciaLocalService.CaminhodePlanilha(const ANomePlanilha: string; ABackup: Boolean = False): string;
var
  BasePath: string;
begin
  if ABackup then
    BasePath := TPath.Combine(GetExePath, 'Backup', 'Planilhas')
  else
    BasePath := TPath.Combine(GetExePath, 'Planilhas');

  Result := TPath.Combine(BasePath, ANomePlanilha);
end;

function TPersistenciaLocalService.CaminhodeRelatorio(const ANomeRelatorio: string; ABackup: Boolean = False): string;
var
  BasePath: string;
begin
  if ABackup then
    BasePath := TPath.Combine(GetExePath, 'Backup', 'Relatórios')
  else
    BasePath := TPath.Combine(GetExePath, 'Relatórios');

  Result := TPath.Combine(BasePath, ANomeRelatorio + '.xml');
end;

function TPersistenciaLocalService.CaminhodeAssociacao(const APlanilhaNome, ANomeAssociacao: string; ABackup: Boolean = False): string;
var
  BasePath: string;
begin
  if ABackup then
  begin
    BasePath := TPath.Combine(GetExePath, 'Backup', 'Planilhas', APlanilhaNome);
    BasePath := TPath.COmbine(BasePath, 'Associações')
  end
  else
    BasePath := TPath.Combine(GetExePath, 'Planilhas', APlanilhaNome, 'Associações');

  Result := TPath.Combine(BasePath, ANomeAssociacao + '.xml');
end;

function TPersistenciaLocalService.CaminhodeDados(const ANomeArquivo: string): string;
var
  BasePath: string;
begin
  BasePath := TPath.Combine(GetExePath, 'Dados');
  Result := TPath.Combine(BasePath, ANomeArquivo);
end;

function TPersistenciaLocalService.CaminhoRelatoriosGerados: string;
begin
  Result := TPath.Combine(TPath.GetDocumentsPath, 'RelatoriosGerados');
end;

end.
