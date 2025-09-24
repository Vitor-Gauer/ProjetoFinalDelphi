unit UViewGerenciadorDados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.DBGrids, Data.DB, Vcl.StdCtrls,
  Vcl.Grids, UFormBaseMinTopoCentro;

type
  TViewGerenciadorDados = class(TFormBaseMinTopoCentro)
    ControleAbasGerenciador: TPageControl;
    AbaGerPlanilhas: TTabSheet;
    PainelGerPlanilhasTopo: TPanel;
    BotaoNovaPlanilha: TButton;
    GradeGerPlanilhas: TDBGrid;
    AbaGerRelatorios: TTabSheet;
    PainelGerRelatoriosTopo: TPanel;
    BotaoNovoRelatorio: TButton;
    GradeGerRelatorios: TDBGrid;
    AbaGerAssociacoes: TTabSheet;
    PainelGerAssociacoesTopo: TPanel;
    BotaoNovaAssociacao: TButton;
    GradeGerAssociacoes: TDBGrid;
    PainelGerenciadorRodape: TPanel;
    BarraStatusGerenciador: TStatusBar;
    procedure BotaoNovaPlanilhaClick(Sender: TObject);
    procedure BotaoNovoRelatorioClick(Sender: TObject);
    procedure BotaoNovaAssociacaoClick(Sender: TObject);
  private
  public
  end;

var
  ViewGerenciadorDados: TViewGerenciadorDados;

implementation

{$R *.dfm}

procedure TViewGerenciadorDados.BotaoNovaPlanilhaClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de criar nova planilha acionada. O controller deve tratar isso.');
end;

procedure TViewGerenciadorDados.BotaoNovoRelatorioClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de criar novo relatório acionada. O controller deve tratar isso.');
end;

procedure TViewGerenciadorDados.BotaoNovaAssociacaoClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de criar nova associação acionada. O controller deve tratar isso.');
end;

end.
