unit UPlanilhaService;

interface

uses
  UPlanilhaDTO, UPostgresDAO;

type
  TPlanilhaService = class
  private
    FDAO: TPostgresDAO;
  public
    constructor Create(ADao: TPostgresDAO);
    function GetPlanilha(AId: Integer): TPlanilhaDTO;
    procedure AtualizarPlanilha(APlanilha: TPlanilhaDTO);
  end;

implementation

{ TPlanilhaService }

constructor TPlanilhaService.Create(ADao: TPostgresDAO);
begin
  FDAO := ADao;
end;

function TPlanilhaService.GetPlanilha(AId: Integer): TPlanilhaDTO;
begin
  Result := nil;
end;

procedure TPlanilhaService.AtualizarPlanilha(APlanilha: TPlanilhaDTO);
begin
end;

end.
