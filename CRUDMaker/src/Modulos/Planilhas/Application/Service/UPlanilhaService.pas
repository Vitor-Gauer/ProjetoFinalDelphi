unit UPlanilhaService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.IOUtils, VCL.Forms, VCL.Dialogs,
  UTabelaDTO, UPlanilhaDTO, UInfoTabelaPlanilhaDTO,
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
  // Implementacao de exemplo
  Result := TPlanilhaDTO.Create; // Ou buscar do banco/DAO
  Result.Id := AId;
  Result.Titulo := 'Planilha Exemplo';
end;


function TPlanilhaService.CriarNovaPlanilha(const ANomeSugerido: string): Boolean;
var
  DiretorioPlanilhas, DiretorioNovaPlanilha: string;
  PlanilhaDTO: TPlanilhaDTO;
begin
  Result := False;
  try
    if ANomeSugerido = '' then
    begin
      ShowMessage('Nome da planilha inválido.');
      Exit;
    end;

    // Usa o padrão encontrado no exemplo: caminho base + subpasta
    DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';
    DiretorioNovaPlanilha := IncludeTrailingPathDelimiter(DiretorioPlanilhas) + ANomeSugerido;

    // Verifica se a planilha já existe
    if TDirectory.Exists(DiretorioNovaPlanilha) then
    begin
      ShowMessage('Já existe uma planilha com este nome.');
      Exit;
    end;

    // Tenta criar o diretório da nova planilha
    if not ForceDirectories(DiretorioNovaPlanilha) then
    begin
      ShowMessage('Falha ao criar o diretório da nova planilha.');
      Exit;
    end;

    // Criar subdiretório 'Tabelas' dentro da nova planilha
    if not ForceDirectories(IncludeTrailingPathDelimiter(DiretorioNovaPlanilha) + 'Tabelas') then
    begin
      ShowMessage('Falha ao criar o subdiretório "Tabelas" da nova planilha.');
      Exit;
    end;

    // Criar subdiretório 'Relatorios' dentro da nova planilha
    if not ForceDirectories(IncludeTrailingPathDelimiter(DiretorioNovaPlanilha) + 'Associações') then
    begin
      ShowMessage('Falha ao criar o subdiretório "Associações" da nova planilha.');
      Exit;
    end;

    // Criar DTO para a nova planilha (exemplo)
    PlanilhaDTO := TPlanilhaDTO.Create;
    try
      PlanilhaDTO.Titulo := ANomeSugerido;
      PlanilhaDTO.Caminho := DiretorioNovaPlanilha; // Pode ser útil para o DTO
      // FDAO.SalvarPlanilha(PlanilhaDTO); // Exemplo de persistência via DAO
    finally
      PlanilhaDTO.Free;
    end;

    Result := True;
    ShowMessage('Planilha "' + ANomeSugerido + '" criada com sucesso.');
  except
    on E: Exception do
    begin
      Result := False;
      ShowMessage('Erro ao criar a planilha: ' + E.Message);
      // Poderia logar a exceção também
      raise; // Re-lança para que o controller ou view possa tratar se necessário
    end;
  end;
end;

end.
