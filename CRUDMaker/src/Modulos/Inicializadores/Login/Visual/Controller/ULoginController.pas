unit ULoginController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs,
  // --- Adicione as units ---
  UAuthService, UPostgresDAO, ULoginDTO, UDBConnection, // ou UDMConexao se for usar TDataModule
  UShowViewService; // Para chamar a navega��o ap�s login

type
  // Tipos de evento definidos aqui ou em outro lugar comum
  TOnLoginEvent = procedure(const AUsuario, ASenha: string; AModoPublico: Boolean) of object;
  TOnCancelarLoginEvent = procedure of object;

  TLoginController = class
  private
    FAuthService: TAuthService; // Refer�ncia ao servi�o
    FPostgresDAO: TPostgresDAO; // Refer�ncia ao DAO
    FDBConnection: TDBConnection; // Refer�ncia � conex�o central

    // --- Campos para armazenar os eventos recebidos ---
    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;

    procedure InicializarInfraEstrutura;
  public
    constructor Create; // Inicializa conex�o, DAO e Servi�o
    destructor Destroy; override; // Libera conex�o, DAO e Servi�o

    procedure LogarUsuario(const AUsuario, ASenha: string; AModoPublico: Boolean);
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
      raise; // Re-lan�a para o chamador (View ou Program.pas) lidar
    end;
  end;

  FPostgresDAO := TPostgresDAO.Create(FDBConnection.GetConnection);
  FAuthService := TAuthService.Create(FPostgresDAO);
end;

// --- M�todo principal para executar a l�gica de login ---
// Dispara o evento interno FOnLogin se bem-sucedido
procedure TLoginController.LogarUsuario(const AUsuario, ASenha: string; AModoPublico: Boolean);
var
  LLoginDTO: TLoginDTO;
  LAutenticado: Boolean;
begin
  if AModoPublico then
  begin
    // Modo P�blico: Verifica credenciais no banco
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
            // Login bem-sucedido
            // Dispara o evento armazenado internamente
            if Assigned(FOnLogin) then
              FOnLogin(LLoginDTO.Usuario, LLoginDTO.Senha, AModoPublico);
            // A View chama Self.Close ap�s este m�todo retornar
          end
          else
          begin
            ShowMessage('Usu�rio ou senha inv�lidos ou usu�rio inativo.');
            // A View pode limpar campos e focar no usu�rio ap�s este retorno
          end;
        except
          on E: Exception do
          begin
            ShowMessage('Erro durante o login (Controller): ' + E.Message);
          end;
        end;
      end
      else
      begin
        ShowMessage('Preencha os campos de usu�rio e senha.');
      end;
    finally
      LLoginDTO.Free;
    end;
  end
  else // Modo Privado ou An�nimo
  begin
    // L�gica para modo privado
    if Assigned(FOnLogin) then
      FOnLogin('Anonimo', '', False);
    // A View chama Self.Close ap�s este m�todo retornar
  end;
end;

// --- M�todo para cancelar o login ---
// Dispara o evento interno FOnCancelarLogin
procedure TLoginController.CancelarLogin;
begin
  // Dispara o evento de cancelamento armazenado internamente
  if Assigned(FOnCancelarLogin) then
    FOnCancelarLogin;
  // A View decide o que fazer (fechar, minimizar, etc.)
end;

end.
