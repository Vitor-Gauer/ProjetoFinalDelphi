unit UPlanilhaService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.IOUtils, VCL.Forms, VCL.Dialogs,
  UTabelaDTO, UPlanilhaDTO,
  UXMLService, UCSVService, UPostgresDAO;

type
  TPlanilhaService = class
  private
    FDAO: TPostgresDAO;
    FXMLService: TXMLService;
    FCSVService: TCSVService;
  public
    constructor Create(ADao: TPostgresDAO; AXMLService: TXMLService; ACSVService: TCSVService);
    function GetPlanilha(AId: Integer): TPlanilhaDTO;
    function CriarNovaPlanilha(const ANomeSugerido: string): Boolean;
  end;

implementation

{ TPlanilhaService }

constructor TPlanilhaService.Create(ADao: TPostgresDAO; AXMLService: TXMLService; ACSVService: TCSVService);
begin
  inherited Create;
  FDAO := ADao;
  FXMLService := AXMLService;
  FCSVService := ACSVService;
end;

function TPlanilhaService.GetPlanilha(AId: Integer): TPlanilhaDTO;
begin
  Result := TPlanilhaDTO.Create;
  Result.Id := AId;
  Result.Titulo := 'Planilha Exemplo';
end;


function TPlanilhaService.CriarNovaPlanilha(const ANomeSugerido: string): Boolean;
var
  DiretorioPlanilhas, DiretorioNovaPlanilha: string;
  PlanilhaDTO: TPlanilhaDTO;
  i: Integer;
begin
  Result := False;
  try
    if ANomeSugerido = '' then
    begin
      ShowMessage('Nome da planilha inválido.');
      Exit;
    end;
    DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';

    for i := 0 to 1 do
    begin
      if i = 1 then
      DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Backup' + pathdelim + 'Planilhas';

      DiretorioNovaPlanilha := IncludeTrailingPathDelimiter(DiretorioPlanilhas) + ANomeSugerido;
      if TDirectory.Exists(DiretorioNovaPlanilha) then
      begin
        ShowMessage('Já existe uma planilha com este nome.');
        Exit;
      end;

      if not ForceDirectories(DiretorioNovaPlanilha) then
      begin
        ShowMessage('Falha ao criar o diretório da nova planilha.');
        Exit;
      end;

      if not ForceDirectories(IncludeTrailingPathDelimiter(DiretorioNovaPlanilha) + 'Tabelas') then
      begin
        ShowMessage('Falha ao criar o subdiretório "Tabelas" da nova planilha.');
        Exit;
      end;

      if not ForceDirectories(IncludeTrailingPathDelimiter(DiretorioNovaPlanilha) + 'Associações') then
      begin
        ShowMessage('Falha ao criar o subdiretório "Associações" da nova planilha.');
        Exit;
      end;
    end;

    Result := True;
    ShowMessage('Planilha "' + ANomeSugerido + '" criada com sucesso.');
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Erro ao criar a planilha: ' + E.Message);
      raise;
    end;
  end;
end;

end.
