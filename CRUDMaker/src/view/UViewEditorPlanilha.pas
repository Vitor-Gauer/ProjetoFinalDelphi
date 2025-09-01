unit UViewEditorPlanilha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TViewEditorPlanilha = class(TForm)
    PanelEditorTop: TPanel;
    LabelTituloPlanilha: TLabel;
    EditTituloPlanilha: TEdit;
    ButtonSalvarPlanilha: TButton;
    StringGridEditor: TStringGrid;
    PanelEditorBottom: TPanel;
    StatusBarEditor: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewEditorPlanilha: TViewEditorPlanilha;

implementation

{$R *.dfm}

end.