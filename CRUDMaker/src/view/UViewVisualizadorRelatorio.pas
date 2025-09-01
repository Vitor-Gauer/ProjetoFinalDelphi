unit UViewVisualizadorRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TViewVisualizadorRelatorio = class(TForm)
    PanelVisualizadorTop: TPanel;
    LabelNomeRelatorio: TLabel;
    ButtonImprimir: TButton;
    RichEditVisualizador: TRichEdit;
    PanelVisualizadorBottom: TPanel;
    StatusBarVisualizador: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewVisualizadorRelatorio: TViewVisualizadorRelatorio;

implementation

{$R *.dfm}

end.