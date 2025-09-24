unit UViewCompartilhamento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  UFormBaseMinTopoCentro;

type
  TViewCompartilhamento = class(TFormBaseMinTopoCentro)
    ControleAbasCompartilhar: TPageControl;
    AbaCompPlanilhas: TTabSheet;
    PainelCompPlanTopo: TPanel;
    CaixaSelecaoTodasPlan: TCheckBox;
    ListaCompPlanilhas: TListBox;
    PainelCompPlanBotoes: TPanel;
    BotaoExportarPlanilhas: TButton;
    AbaCompRelatorios: TTabSheet;
    PainelCompRelTopo: TPanel;
    CaixaSelecaoTodosRel: TCheckBox;
    ListaCompRelatorios: TListBox;
    PainelCompRelBotoes: TPanel;
    BotaoExportarRelatorios: TButton;
    AbaCompAssociacoes: TTabSheet;
    PainelCompAssocTopo: TPanel;
    CaixaSelecaoTodasAssoc: TCheckBox;
    ListaCompAssociacoes: TListBox;
    PainelCompAssocBotoes: TPanel;
    BotaoExportarAssociacoes: TButton;
    PainelCompartilharRodape: TPanel;
    BarraStatusCompartilhar: TStatusBar;
    procedure BotaoExportarPlanilhasClick(Sender: TObject);
    procedure BotaoExportarRelatoriosClick(Sender: TObject);
    procedure BotaoExportarAssociacoesClick(Sender: TObject);
  private
  public
  end;

var
  ViewCompartilhamento: TViewCompartilhamento;

implementation

{$R *.dfm}

procedure TViewCompartilhamento.BotaoExportarPlanilhasClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de exportar planilhas acionada.');
end;

procedure TViewCompartilhamento.BotaoExportarRelatoriosClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de exportar relatórios acionada.');
end;

procedure TViewCompartilhamento.BotaoExportarAssociacoesClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de exportar associações acionada.');
end;

end.
