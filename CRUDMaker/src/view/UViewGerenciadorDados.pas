unit UViewGerenciadorDados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Data.DB, Vcl.StdCtrls,
  Vcl.Grids;

type
  TViewGerenciadorDados = class(TForm)
    PageControlGerenciador: TPageControl;
    TabSheetGerPlanilhas: TTabSheet;
    PanelGerPlanilhasTop: TPanel;
    ButtonNovaPlanilha: TButton;
    DBGridGerPlanilhas: TDBGrid;
    TabSheetGerRelatorios: TTabSheet;
    PanelGerRelatoriosTop: TPanel;
    ButtonNovoRelatorio: TButton;
    DBGridGerRelatorios: TDBGrid;
    TabSheetGerAssociacoes: TTabSheet;
    PanelGerAssociacoesTop: TPanel;
    ButtonNovaAssociacao: TButton;
    DBGridGerAssociacoes: TDBGrid;
    PanelGerenciadorBottom: TPanel;
    StatusBarGerenciador: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewGerenciadorDados: TViewGerenciadorDados;

implementation

{$R *.dfm}

end.