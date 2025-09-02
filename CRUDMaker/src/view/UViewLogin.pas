unit UViewLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

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
  private
    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;
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
  RadioButtonPrivado.Checked := True;    // Privado tem que ser ativo por default
end;

procedure TViewLogin.BotaoLoginClick(Sender: TObject);
begin
  if Assigned(FOnLogin) then // se o evento login existe
    FOnLogin(EditarUsuario.Text, EditarSenha.Text, RadioButtonPublico.Checked); // assinala em ordem: AUsuario, ASenha, AModoPublico
end;

procedure TViewLogin.BotaoCancelarClick(Sender: TObject);
begin
  if Assigned(FOnCancelarLogin) then   // Se o evento de CancelarLogin existe, Cancele o login
    FOnCancelarLogin;
  Self.Close;
end;

end.
