unit UViewPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Vcl.StdCtrls, Vcl.Menus,
  UPlanilhaDTO, URelatorioDTO, UShowViewController;

type
  TNavegarParaEditorTabelaEvent = procedure(const APlanilha: TPlanilhaDTO) of object;
  TNavegarParaNovoRelatorioComBaseEvent = procedure(const APlanilhaBase: TPlanilhaDTO) of object;
  TNavegarParaEditorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TNavegarParaVisualizadorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TOnSolicitarLogoutEvent = procedure of object;
  TOnAbrirGerenciadorEvent = procedure of object;
  TOnAbrirCompartilhamentoEvent = procedure of object;

  TViewPrincipal = class(TForm)
    MainMenuPrincipal: TMainMenu;
    MenuItemArquivo: TMenuItem;
    MenuItemSair: TMenuItem;
    MenuItemFerramentas: TMenuItem;
    MenuItemGerenciarDados: TMenuItem;
    MenuItemCompartilhar: TMenuItem;
    MenuItemAjuda: TMenuItem;
    MenuItemSobre: TMenuItem;
    PainelTopo: TPanel;
    RotuloBemVindo: TLabel;
    ControleAbasPrincipal: TPageControl;
    AbaPlanilhas: TTabSheet;
    Divisor1: TSplitter;
    PainelEsquerdoPlanilhas: TPanel;
    ListaPlanilhas: TListBox;
    PainelDireitoTabelas: TPanel;
    GradeTabelas: TDBGrid;
    PainelBotoesTabela: TPanel;
    BotaoEditarPlanilha: TButton;
    BotaoExcluirPlanilha: TButton;
    BotaoCriarRelatorioPlanilha: TButton;
    AbaRelatorios: TTabSheet;
    Divisor2: TSplitter;
    PainelEsquerdoRelatorios: TPanel;
    ListaRelatorios: TListBox;
    PainelDireitoRelatorios: TPanel;
    MemoVisualizadorRelatorio: TMemo;
    PainelBotoesRelatorio: TPanel;
    BotaoEditarRelatorio: TButton;
    BotaoExcluirRelatorio: TButton;
    BotaoVisualizarRelatorio: TButton;
    AbaAssociacoes: TTabSheet;
    GradeAssociacoes: TDBGrid;
    BarraStatusPrincipal: TStatusBar;
    BotaoCriarRelatorio: TButton;
    procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemGerenciarDadosClick(Sender: TObject);
    procedure MenuItemCompartilharClick(Sender: TObject);
    procedure BotaoEditarTabelaClick(Sender: TObject);
    procedure BotaoExcluirPlanilhaClick(Sender: TObject);
    procedure BotaoCriarTabelaClick(Sender: TObject);
    procedure BotaoEditarRelatorioClick(Sender: TObject);
    procedure BotaoExcluirRelatorioClick(Sender: TObject);
    procedure BotaoVisualizarRelatorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTabelaSelecionada: TPlanilhaDTO;
    FRelatorioSelecionado: TRelatorioDTO;
    FOnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent;
    FOnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent;
    FOnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent;
    FOnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent;
    FOnSolicitarLogout: TOnSolicitarLogoutEvent;
    FOnAbrirGerenciador: TOnAbrirGerenciadorEvent;
    FOnAbrirCompartilhamento: TOnAbrirCompartilhamentoEvent;
    procedure AtualizarExibicaoPlanilha;
    procedure AtualizarExibicaoRelatorio;
  public
    procedure DefinirNomeUsuario(const ANome: string);
    property OnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent read FOnNavegarParaEditorTabela write FOnNavegarParaEditorTabela;
    property OnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent read FOnNavegarParaNovoRelatorioComBase write FOnNavegarParaNovoRelatorioComBase;
    property OnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent read FOnNavegarParaEditorRelatorio write FOnNavegarParaEditorRelatorio;
    property OnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent read FOnNavegarParaVisualizadorRelatorio write FOnNavegarParaVisualizadorRelatorio;
    property OnSolicitarLogout: TOnSolicitarLogoutEvent read FOnSolicitarLogout write FOnSolicitarLogout;
    property OnAbrirGerenciador: TOnAbrirGerenciadorEvent read FOnAbrirGerenciador write FOnAbrirGerenciador;
    property OnAbrirCompartilhamento: TOnAbrirCompartilhamentoEvent read FOnAbrirCompartilhamento write FOnAbrirCompartilhamento;
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

uses System.UITypes;

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  ControleAbasPrincipal.ActivePageIndex := 0;
end;

procedure TViewPrincipal.DefinirNomeUsuario(const ANome: string);
begin
  RotuloBemVindo.Caption := 'Bem-vindo, ' + ANome + '!';
end;

procedure TViewPrincipal.MenuItemSairClick(Sender: TObject);
begin
  if Assigned(FOnSolicitarLogout) then
    FOnSolicitarLogout;
end;

procedure TViewPrincipal.MenuItemGerenciarDadosClick(Sender: TObject);
begin
  if Assigned(FOnAbrirGerenciador) then
    FOnAbrirGerenciador;
end;

procedure TViewPrincipal.MenuItemCompartilharClick(Sender: TObject);
begin
   if Assigned(FOnAbrirCompartilhamento) then
    FOnAbrirCompartilhamento;
end;

procedure TViewPrincipal.BotaoEditarTabelaClick(Sender: TObject);
begin
   if Assigned(FOnNavegarParaEditorTabela) then
     OnNavegarParaEditorTabela(FTabelaSelecionada);
     TViewController.Instance.ShowViewEditorTabela;
end;

procedure TViewPrincipal.BotaoExcluirPlanilhaClick(Sender: TObject);
begin
  if Assigned(FTabelaSelecionada) then
  begin
    if MessageDlg('Tem certeza que deseja excluir a planilha "' + FTabelaSelecionada.Titulo + '"?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      // TODO: Chamar serviço para excluir a planilha
    end;
  end;
end;

procedure TViewPrincipal.BotaoCriarTabelaClick(Sender: TObject);
begin
  if Assigned(FTabelaSelecionada) then
  begin
     if Assigned(OnNavegarParaNovoRelatorioComBase) then
       OnNavegarParaNovoRelatorioComBase(FTabelaSelecionada);
  end;
end;

procedure TViewPrincipal.BotaoEditarRelatorioClick(Sender: TObject);
begin
  if Assigned(FOnNavegarParaEditorRelatorio) then
    FOnNavegarParaEditorRelatorio(FRelatorioSelecionado);
    TViewController.Instance.ShowViewEditorRelatorio
end;

procedure TViewPrincipal.BotaoExcluirRelatorioClick(Sender: TObject);
begin
  if Assigned(FRelatorioSelecionado) then
  begin
    if MessageDlg('Tem certeza que deseja excluir o relatório "' + FRelatorioSelecionado.Titulo + '"?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      // TODO: Chamar serviço para excluir o relatório
    end;
  end;
end;

procedure TViewPrincipal.BotaoVisualizarRelatorioClick(Sender: TObject);
begin
    if Assigned(FOnNavegarParaVisualizadorRelatorio) then
      FOnNavegarParaVisualizadorRelatorio(FRelatorioSelecionado);
      TViewController.Instance.ShowViewVisualizadorRelatorio(FRelatorioSelecionado);
end;

procedure TViewPrincipal.AtualizarExibicaoPlanilha;
begin
  // Lógica para atualizar GradePlanilha com base na seleção em ListaPlanilhas
end;

procedure TViewPrincipal.AtualizarExibicaoRelatorio;
begin
  // Lógica para atualizar MemoVisualizadorRelatorio com base na seleção em ListaRelatorios
end;

end.
