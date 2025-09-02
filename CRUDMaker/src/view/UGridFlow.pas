unit UGridFlow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, UViewController;

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
    procedure FormShow(Sender: TObject); // Certifique-se que este evento existe no .dfm
  private
    FFluxoInicialExecutado: Boolean;
  public
    { Public declarations }
  end;

var
  FGridFlow: TFGridFlow;

implementation

{$R *.dfm}

procedure TFGridFlow.FormShow(Sender: TObject);
begin
  OutputDebugString('DEBUG: TFGridFlow.FormShow - INICIO');

  if not FFluxoInicialExecutado then
  begin
    FFluxoInicialExecutado := True;
    OutputDebugString('DEBUG: TFGridFlow.FormShow - Chamando TViewController.Instance.IniciarFluxoInicial');
    TViewController.Instance.IniciarFluxoInicial(Self);
  end;

  OutputDebugString('DEBUG: TFGridFlow.FormShow - FIM');
end;

end.
