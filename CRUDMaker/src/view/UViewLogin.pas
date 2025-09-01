unit UViewLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TViewLogin = class(TForm)
    PanelLogin: TPanel;
    LabelUsuario: TLabel;
    LabelSenha: TLabel;
    EditUsuario: TEdit;
    EditSenha: TEdit;
    ButtonLogin: TButton;
    RadioButtonPublico: TRadioButton;
    RadioButtonPrivado: TRadioButton;
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