unit ULoginController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs,
  UAuthService, UPostgresDAO, ULoginDTO, UDBConnection,
  UShowViewService;

type
  TOnLoginEvent = procedure(const AUsuario, ASenha: string; AModoPublico: Boolean) of object;
  TOnCancelarLoginEvent = procedure of object;

  TLoginController = class
  private
    FAuthService: TAuthService;
    FPostgresDAO: TPostgresDAO;
    FDBConnection: TDBConnection;

    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;

    procedure InicializarInfraEstrutura;
  public
    constructor Create;
    destructor Destroy; override;

    function LogarUsuario(const AUsuario, ASenha: string; AModoPublico: Boolean): boolean;
    procedure CancelarLogin;

    property OnLogin: TOnLoginEvent read FOnLogin write FOnLogin;
    property OnCancelarLogin: TOnCancelarLoginEvent read FOnCancelarLogin write FOnCancelarLogin;
  end;

implementation

{ TLoginController }

constructor TLoginController.Create;
begin
  inherited Create;
  InicializarInfraEstrutura;
end;

destructor TLoginController.Destroy;
begin
  FAuthService.Free;
  FPostgresDAO.Free;
  FDBConnection.Free;
  inherited;
end;

procedure TLoginController.InicializarInfraEstrutura;
begin
  FDBConnection := TDBConnection.Create;
  try
    FDBConnection.Conectar;
  except
    on E: Exception do
    begin
      ShowMessage('Falha ao conectar ao banco de dados: ' + E.Message);
      raise;
    end;
  end;

  FPostgresDAO := TPostgresDAO.Create(FDBConnection.GetConnection);
  FAuthService := TAuthService.Create(FPostgresDAO);
end;

function TLoginController.LogarUsuario(const AUsuario, ASenha: string; AModoPublico: Boolean): boolean;
var
  LLoginDTO: TLoginDTO;
  LAutenticado: Boolean;
begin
  result := true;
  if AModoPublico then
  begin
    LLoginDTO := TLoginDTO.Create;
    try
      LLoginDTO.Usuario := AUsuario;
      LLoginDTO.Senha := ASenha;

      if (Trim(LLoginDTO.Usuario) <> '') and (Trim(LLoginDTO.Senha) <> '') then
      begin
        try
          LAutenticado := FAuthService.Authenticate(LLoginDTO);
          if LAutenticado then
          begin
            if Assigned(FOnLogin) then
              FOnLogin(LLoginDTO.Usuario, LLoginDTO.Senha, AModoPublico);
          end
          else
          begin
            ShowMessage('Usuário ou senha inválidos ou usuário inativo.');
            result := false;
          end;
        except
          on E: Exception do
          begin
            ShowMessage('Erro durante o login (Controller): ' + E.Message);
            result := false;
          end;
        end;
      end
      else
      begin
        ShowMessage('Preencha os campos de usuário e senha.');
        result := false;
      end;
    finally
      LLoginDTO.Free;
    end;
  end
  else
  begin
    if Assigned(FOnLogin) then
      FOnLogin('Anonimo', '', False);
  end;
end;

procedure TLoginController.CancelarLogin;
begin
  if Assigned(FOnCancelarLogin) then
    FOnCancelarLogin;
end;

end.
