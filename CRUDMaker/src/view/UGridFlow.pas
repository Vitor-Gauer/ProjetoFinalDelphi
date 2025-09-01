unit UGridFlow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls;

type
  TFGridFlow = class(TForm)
    MainMenu1: TMainMenu;
    Arquivo1: TMenuItem;
    Novo1: TMenuItem;
    Abrir1: TMenuItem;
    Salvar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Editar1: TMenuItem;
    Exibir1: TMenuItem;
    Ferramentas1: TMenuItem;
    Ajuda1: TMenuItem;
    StatusBar1: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGridFlow: TFGridFlow;

implementation

{$R *.dfm}

end.
