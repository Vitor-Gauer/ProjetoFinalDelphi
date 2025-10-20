unit ULoginController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs,
  // --- Adicione as units ---
  UAuthService, UPostgresDAO, ULoginDTO, UDBConnection, // ou UDMConexao se for usar TDataModule
  UShowViewService; // Para chamar a navegação após login

type
  // Tipos de evento definidos aqui ou em outro lugar comum
  TOnLoginEvent = procedure(const AUsuario, ASenha: string; AModoPublico: Boolean) of object;
  TOnCancelarLoginEvent = procedure of object;

  TLoginController = class
  private
    FAuthService: TAuthService; // Referência ao serviço
    FPostgresDAO: TPostgresDAO; // Referência ao DAO
    FDBConnection: TDBConnection; // Referência à conexão central

    // --- Campos para armazenar os eventos recebidos ---
    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;

    procedure InicializarInfraEstrutura;
  public
    constructor Create; // Inicializa conexão, DAO e Serviço
    destructor Destroy; override; // Libera conexão, DAO e Serviço

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
      raise; // Re-lança para o chamador (View ou Program.pas) lidar
    end;
  end;

  FPostgresDAO := TPostgresDAO.Create(FDBConnection.GetConnection);
  FAuthService := TAuthService.Create(FPostgresDAO);
end;

// --- Método principal para executar a lógica de login ---
// Dispara o evento interno FOnLogin se bem-sucedido
procedure TLoginController.LogarUsuario(const AUsuario, ASenha: string; AModoPublico: Boolean);
var
  LLoginDTO: TLoginDTO;
  LAutenticado: Boolean;
begin
  if AModoPublico then
  begin
    // Modo Público: Verifica credenciais no banco
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
            // A View chama Self.Close após este método retornar
          end
          else
          begin
            ShowMessage('Usuário ou senha inválidos ou usuário inativo.');
            // A View pode limpar campos e focar no usuário após este retorno
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
        ShowMessage('Preencha os campos de usuário e senha.');
      end;
    finally
      LLoginDTO.Free;
    end;
  end
  else // Modo Privado ou Anônimo
  begin
    // Lógica para modo privado
    if Assigned(FOnLogin) then
      FOnLogin('Anonimo', '', False);
    // A View chama Self.Close após este método retornar
  end;
end;

// --- Método para cancelar o login ---
// Dispara o evento interno FOnCancelarLogin
procedure TLoginController.CancelarLogin;
begin
  // Dispara o evento de cancelamento armazenado internamente
  if Assigned(FOnCancelarLogin) then
    FOnCancelarLogin;
  // A View decide o que fazer (fechar, minimizar, etc.)
end;

end.
