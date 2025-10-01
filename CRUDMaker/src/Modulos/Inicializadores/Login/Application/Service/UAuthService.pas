unit UAuthService;

interface

uses
  ULoginDTO, UPostgresDAO;

type
  TAuthService = class
  private
    FDAO: TPostgresDAO;
  public
    constructor Create(ADao: TPostgresDAO);
    function Authenticate(const ALoginDTO: TLoginDTO): Boolean;
  end;

implementation

{ TAuthService }

constructor TAuthService.Create(ADao: TPostgresDAO);
begin
  FDAO := ADao;
end;

function TAuthService.Authenticate(const ALoginDTO: TLoginDTO): Boolean;
begin
  Result := False;
end;

end.
