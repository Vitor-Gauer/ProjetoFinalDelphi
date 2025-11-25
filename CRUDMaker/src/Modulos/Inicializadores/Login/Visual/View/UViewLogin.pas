unit UViewLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  ULoginController;

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
    FController: TLoginController;
    FOnLogin: TOnLoginEvent;
    FOnCancelarLogin: TOnCancelarLoginEvent;
    procedure AtualizarEstadoControles;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ConectarEventosController;
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
  FController := TLoginController.Create;

  FController.OnLogin := Self.OnLogin;
  FController.OnCancelarLogin := Self.OnCancelarLogin;
end;

procedure TViewLogin.ConectarEventosController;
begin
  FController.OnLogin := Self.FOnLogin;
  FController.OnCancelarLogin := Self.FOnCancelarLogin;
end;

destructor TViewLogin.Destroy;
begin
  FController.Free;
  inherited;
end;

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

  EditarUsuario.Enabled := not LModoPrivado;
  EditarSenha.Enabled := not LModoPrivado;
  RotuloUsuario.Enabled := not LModoPrivado;
  RotuloSenha.Enabled := not LModoPrivado;

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

procedure TViewLogin.RadioButtonModoClick(Sender: TObject);
begin
  AtualizarEstadoControles;
end;

procedure TViewLogin.BotaoLoginClick(Sender: TObject);
var
  LModoPublico, LModoPrivado: Boolean;
  LUsuario, LSenha: string;
begin
  LModoPublico := RadioButtonPublico.Checked;
  LModoPrivado := RadioButtonPrivado.Checked;
  if LModoPrivado then
  begin
      FController.LogarUsuario('Anonimo', '', False);
      Self.Close;
  end
  else if LModoPublico then
  begin
    LUsuario := EditarUsuario.Text;
    LSenha := EditarSenha.Text;

    if FController.LogarUsuario(LUsuario, LSenha, LModoPublico) then
    Self.Close;
  end
  else
  ShowMessage('Preencha os campos e o modo!');
end;

procedure TViewLogin.BotaoCancelarClick(Sender: TObject);
begin
  FController.CancelarLogin;
  Application.Terminate;
end;

end.
