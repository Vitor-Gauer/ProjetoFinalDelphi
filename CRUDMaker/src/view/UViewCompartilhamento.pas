unit UViewCompartilhamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TViewCompartilhamento = class(TForm)
    PageControlCompartilhar: TPageControl;
    TabSheetCompPlanilhas: TTabSheet;
    PanelCompPlanTop: TPanel;
    CheckBoxSelecionarTodasPlan: TCheckBox;
    ListBoxCompPlanilhas: TListBox;
    PanelCompPlanBotoes: TPanel;
    ButtonExportarPlanilhas: TButton;
    TabSheetCompRelatorios: TTabSheet;
    PanelCompRelTop: TPanel;
    CheckBoxSelecionarTodosRel: TCheckBox;
    ListBoxCompRelatorios: TListBox;
    PanelCompRelBotoes: TPanel;
    ButtonExportarRelatorios: TButton;
    TabSheetCompAssociacoes: TTabSheet;
    PanelCompAssocTop: TPanel;
    CheckBoxSelecionarTodasAssoc: TCheckBox;
    ListBoxCompAssociacoes: TListBox;
    PanelCompAssocBotoes: TPanel;
    ButtonExportarAssociacoes: TButton;
    PanelCompartilharBottom: TPanel;
    StatusBarCompartilhar: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewCompartilhamento: TViewCompartilhamento;

implementation

{$R *.dfm}

end.