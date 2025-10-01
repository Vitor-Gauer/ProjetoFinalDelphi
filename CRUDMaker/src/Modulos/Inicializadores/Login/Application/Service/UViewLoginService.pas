unit UViewLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TViewLogin = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    EditUsuario: TEdit;
    EditSenha: TEdit;
    ButtonLogin: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewLogin: TViewLogin;

implementation

{$R *.dfm}

end.
