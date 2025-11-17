unit UViewSalvarAssociacao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls,
  UFormBaseMinTopoCentro;

type
  TViewSalvarAssociacao = class(TFormBaseMinTopoCentro)
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
  ViewSalvarAssociacao: TViewSalvarAssociacao;

implementation

{$R *.dfm}

procedure TViewSalvarAssociacao.BotaoExportarPlanilhasClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de exportar planilhas acionada.');
end;

procedure TViewSalvarAssociacao.BotaoExportarRelatoriosClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de exportar relatórios acionada.');
end;

procedure TViewSalvarAssociacao.BotaoExportarAssociacoesClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de exportar associações acionada.');
end;

end.
