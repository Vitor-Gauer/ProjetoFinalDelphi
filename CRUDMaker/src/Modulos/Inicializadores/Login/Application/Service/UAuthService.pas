unit UAuthService;

interface

uses
  System.SysUtils,
  UPostgresDAO,
  ULoginDTO,
  VCL.Dialogs;

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
  if not Assigned(FDAO) then
    raise Exception.Create('DAO não fornecido para TAuthService.');
end;

function TAuthService.Authenticate(const ALoginDTO: TLoginDTO): Boolean;
begin
  Result := False;
  if Assigned(FDAO) and Assigned(ALoginDTO) then
  begin
    try
      Result := FDAO.AutenticarUsuario(ALoginDTO.Usuario, ALoginDTO.Senha);
    except
      on E: Exception do
      begin
        ShowMessage('Erro durante a autenticação: ' + E.Message);
        Result := False;
      end;
    end;
  end;
end;

end.
