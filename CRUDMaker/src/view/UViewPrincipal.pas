unit UViewPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Vcl.StdCtrls;

type
  TViewPrincipal = class(TForm)
    PanelTop: TPanel;
    LabelBemVindo: TLabel;
    ButtonLogout: TButton;
    PageControlMain: TPageControl;
    TabSheetPlanilhas: TTabSheet;
    Splitter1: TSplitter;
    PanelPlanilhasEsquerda: TPanel;
    ListBoxPlanilhas: TListBox;
    PanelPlanilhasDireita: TPanel;
    DBGridPlanilha: TDBGrid;
    PanelPlanilhaBotoes: TPanel;
    ButtonEditarPlanilha: TButton;
    ButtonExcluirPlanilha: TButton;
    ButtonNovoRelatorioPlanilha: TButton;
    TabSheetRelatorios: TTabSheet;
    Splitter2: TSplitter;
    PanelRelatoriosEsquerda: TPanel;
    ListBoxRelatorios: TListBox;
    PanelRelatoriosDireita: TPanel;
    MemoVisualizadorRelatorio: TMemo;
    PanelRelatorioBotoes: TPanel;
    ButtonEditarRelatorio: TButton;
    ButtonExcluirRelatorio: TButton;
    ButtonVisualizarRelatorio: TButton;
    TabSheetAssociacoes: TTabSheet;
    DBGridAssociacoes: TDBGrid;
    StatusBarPrincipal: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

end.