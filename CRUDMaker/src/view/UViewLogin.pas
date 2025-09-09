unit UViewLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
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
    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;
    procedure AtualizarEstadoControles;
  public
    property OnLogin: TOnLoginEvent read FOnLogin write FOnLogin;
    property OnCancelarLogin: TOnCancelarLoginEvent read FOnCancelarLogin write FOnCancelarLogin;
  end;

var
  ViewLogin: TViewLogin;

implementation

{$R *.dfm}

procedure TViewLogin.FormCreate(Sender: TObject);
begin
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

// Implementação do novo evento para os RadioButtons <<< Adicionado
procedure TViewLogin.RadioButtonModoClick(Sender: TObject);
begin
  // Sempre que um RadioButton for clicado, atualiza os controles
  AtualizarEstadoControles;
end;

procedure TViewLogin.BotaoLoginClick(Sender: TObject);
var
  LModoPublico: Boolean;
  LUsuario, LSenha: string;
begin
  LModoPublico := RadioButtonPublico.Checked;
  // Verifica o modo de operação
  if RadioButtonPrivado.Checked then
  begin
    // Modo Privado: Login automático como 'Anônimo'
    if Assigned(FOnLogin) then
      FOnLogin('Anônimo', '', False);
    Self.Close;
  end
  else if RadioButtonPublico.Checked then
  begin
    // Modo Público: Login normal
    LUsuario := EditarUsuario.Text;
    LSenha := EditarSenha.Text;
    if Assigned(FOnLogin) then
      FOnLogin(LUsuario, LSenha, LModoPublico);
    Self.Close; // No Self.Close, ele abre o ViewPrincipal
  end
  else
  showmessage('Preencha os campos e o modo!');
end;

procedure TViewLogin.BotaoCancelarClick(Sender: TObject);
begin
  if Assigned(FOnCancelarLogin) then
    FOnCancelarLogin;
    Application.Terminate;
end;

end.
