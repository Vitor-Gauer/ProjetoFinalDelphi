unit URelatorioService;

interface

uses
  URelatorioDTO, UPostgresDAO;

type
  TRelatorioService = class
  private
    FDAO: TPostgresDAO;
  public
    constructor Create(ADao: TPostgresDAO);
    function GerarRelatorio(AIdPlanilha: Integer): TRelatorioDTO;
  end;

implementation

{ TRelatorioService }

constructor TRelatorioService.Create(ADao: TPostgresDAO);
begin
  FDAO := ADao;
end;

function TRelatorioService.GerarRelatorio(AIdPlanilha: Integer): TRelatorioDTO;
begin
  Result := nil;
end;

end.
