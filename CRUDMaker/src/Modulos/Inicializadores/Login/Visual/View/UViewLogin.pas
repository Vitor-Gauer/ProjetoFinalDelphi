unit UViewLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  // --- Importar o Controller ---
  ULoginController;

type
  // --- Tipos de Evento (já devem estar definidos ou importados) ---
  TOnLoginEvent = procedure(const AUsuario, ASenha: string; AModoPublico: Boolean) of object;
  TOnCancelarLoginEvent = procedure of object;

  TViewLogin = class(TForm)
    PainelLogin: TPanel;
    RotuloUsuario: TLabel;
    RotuloSenha: TLabel;
    EditarUsuario: TEdit;
    EditarSenha: TEdit;
    BotaoLogin: TButton;
    BotaoCancelar: TButton;
    GrupoBoxModo: TGroupBox;
    RadioButtonPublico: TRadioButton;
    RadioButtonPrivado: TRadioButton;
    procedure BotaoLoginClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RadioButtonModoClick(Sender: TObject);
  private
    FController: TLoginController;
    // --- Campos de Evento (devem estar definidos na interface original) ---
    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;
    procedure AtualizarEstadoControles;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConectarEventosController;
    // --- Propriedades para conectar os eventos ---
    property OnLogin: TOnLoginEvent read FOnLogin write FOnLogin;
    property OnCancelarLogin: TOnCancelarLoginEvent read FOnCancelarLogin write FOnCancelarLogin;
  end;

var
  ViewLogin: TViewLogin;

implementation

{$R *.dfm}

constructor TViewLogin.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  // Cria o Controller. A conexão, DAO e Serviço são criados dentro do Controller.Create
  FController := TLoginController.Create;

  // Conecta os eventos da View ao Controller
  // O Controller armazena esses eventos internamente
  FController.OnLogin := Self.OnLogin;
  FController.OnCancelarLogin := Self.OnCancelarLogin;
end;

procedure TViewLogin.ConectarEventosController;
begin
  FController.OnLogin := Self.FOnLogin;
  FController.OnCancelarLogin := Self.FOnCancelarLogin;
end;

// --- Destrutor da View ---
destructor TViewLogin.Destroy;
begin
  FController.Free; // Libera o Controller (e tudo que ele contém)
  inherited;
end;

// --- Evento OnCreate do Form ---
procedure TViewLogin.FormCreate(Sender: TObject);
begin
  // NÃO chama inherited Create(AOwner) aqui!
  // inherited Create(AOwner); // REMOVA ESTA LINHA

  // Inicializações específicas do Form
  RadioButtonPublico.Checked := False;
  RadioButtonPrivado.Checked := False;
  AtualizarEstadoControles;
end;

procedure TViewLogin.AtualizarEstadoControles;
var
  LModoPrivado: Boolean;
begin
  LModoPrivado := RadioButtonPrivado.Checked;

  // Habilita/Desabilita campos de usuário e senha baseado no modo
  EditarUsuario.Enabled := not LModoPrivado;
  EditarSenha.Enabled := not LModoPrivado;
  RotuloUsuario.Enabled := not LModoPrivado;
  RotuloSenha.Enabled := not LModoPrivado;

  // Limpa os campos, e coloca se mudar para privado
  if LModoPrivado then
  begin
    EditarUsuario.Clear;
    EditarSenha.Clear;
    EditarUsuario.Text := 'Anonimo';
    EditarSenha.Text := '';
  end
  else
    EditarUsuario.Clear;
    EditarSenha.Clear;
end;

// Implementação do novo evento para os RadioButtons
procedure TViewLogin.RadioButtonModoClick(Sender: TObject);
begin
  // Sempre que um RadioButton for clicado, atualiza os controles
  AtualizarEstadoControles;
end;

procedure TViewLogin.BotaoLoginClick(Sender: TObject);
var
  LModoPublico, LModoPrivado: Boolean;
  LUsuario, LSenha: string;
begin
  LModoPublico := RadioButtonPublico.Checked;
  LModoPrivado := RadioButtonPrivado.Checked;
  // Verifica o modo de operação
  if LModoPrivado then
  begin
      // Modo Privado: Chama o Controller para lidar com login anônimo
      // O Controller acessa seu próprio FOnLogin
      FController.LogarUsuario('Anonimo', '', False);
      Self.Close; // Fecha a tela de login após o Controller processar
  end
  else if LModoPublico then
  begin
    // Modo Público: Login normal
    LUsuario := EditarUsuario.Text;
    LSenha := EditarSenha.Text;
    // O Controller encapsula a lógica de autenticação e dispara o evento interno
    // O Controller acessa seu próprio FOnLogin
    FController.LogarUsuario(LUsuario, LSenha, LModoPublico);
    Self.Close; // Fecha a tela de login após o Controller processar
  end
  else
  ShowMessage('Preencha os campos e o modo!');
end;

procedure TViewLogin.BotaoCancelarClick(Sender: TObject);
begin
  // Chama o Controller para lidar com o cancelamento
  // O Controller acessa seu próprio FOnCancelarLogin
  FController.CancelarLogin;
  // A View decide o que fazer após (ex: Application.Terminate aqui ou no manipulador do evento)
  Application.Terminate; // Exemplo: encerra a aplicação ao cancelar login
end;

end.
