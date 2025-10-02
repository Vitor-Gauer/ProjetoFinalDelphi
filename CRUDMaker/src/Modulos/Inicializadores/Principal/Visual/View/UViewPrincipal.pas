unit UViewPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  System.UITypes, System.IOUtils,

  Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls,
  Vcl.Menus,

  Data.DB, Datasnap.DBClient,

  UTabelaDTO, UPlanilhaDTO, URelatorioDTO,
  UPrincipalController, UShowViewController, UFormBaseMinTopoCentro;

type
  TCriarPlanilhaEvent = procedure(const ANomeSugerido: string) of object;

  TNavegarParaCriadorTabelaEvent = procedure of object;
  TNavegarParaEditorTabelaEvent = procedure(const APlanilha: TPlanilhaDTO) of object;
  TNavegarParaNovoRelatorioComBaseEvent = procedure(const APlanilhaBase: TPlanilhaDTO) of object;
  TNavegarParaEditorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TNavegarParaVisualizadorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TOnSolicitarLogoutEvent = procedure of object;
  TOnAbrirGerenciadorEvent = procedure of object;
  TOnAbrirCompartilhamentoEvent = procedure of object;

  TViewPrincipal = class(TFormBaseMinTopoCentro)
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
    BotaoCriarPlanilha: TButton;
    BotaoCriarTabela: TButton;
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
    ClientDataSetTabelas: TClientDataSet;
    DataSourceTabelas: TDataSource;
    procedure MenuItemSairClick(Sender: TObject);
    procedure MenuItemGerenciarDadosClick(Sender: TObject);
    procedure MenuItemCompartilharClick(Sender: TObject);
    procedure BotaoEditarTabelaClick(Sender: TObject);
    procedure BotaoExcluirPlanilhaClick(Sender: TObject);
    procedure BotaoCriarTabelaClick(Sender: TObject);
    procedure BotaoCriarPlanilhaClick(Sender: TObject);
    procedure BotaoAtualizarPlanilhaClick(Sender: TObject);
    procedure BotaoEditarRelatorioClick(Sender: TObject);
    procedure BotaoExcluirRelatorioClick(Sender: TObject);
    procedure BotaoVisualizarRelatorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListaPlanilhasClick(Sender: TObject);
    procedure BotaoCriarPlanilhaClick(Sender: TObject);
  private
    FTabelaSelecionada: TPlanilhaDTO;
    FRelatorioSelecionado: TRelatorioDTO;
    FController: TPrincipalController;
    FOnCriarPlanilha: TCriarPlanilhaEvent;
    FOnExcluirPlanilha: TExcluirPlanilhaEvent;
    FOnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent;
    FOnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent;
    FOnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent;
    FOnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent;
    FOnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent;
    FOnSolicitarLogout: TOnSolicitarLogoutEvent;
    FOnSolicitarAtualizacaoPlanilha: TNotifyEvent;
    FOnAbrirGerenciador: TOnAbrirGerenciadorEvent;
    FOnAbrirCompartilhamento: TOnAbrirCompartilhamentoEvent;
    procedure AtualizarExibicaoPlanilha;
    procedure AtualizarExibicaoRelatorio;
    procedure PopularGradeTabelas(const ANomePlanilha: string);
  public
    procedure DefinirNomeUsuario(const ANome: string);
    property OnCriarPlanilha: TCriarPlanilhaEvent read FOnCriarPlanilha write FOnCriarPlanilha;
    property OnExcluirPlanilha: TExcluirPlanilhaEvent read FOnExcluirPlanilha write FOnExcluirPlanilha;
    property OnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent read FOnNavegarParaCriadorTabela write FOnNavegarParaCriadorTabela;
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
//(* NÃO coloque nenhum comentário acima dessa linha.
//(* NÃO implemente métodos que não estejam no prompt OU que não estão com //(*
{$R *.dfm}

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  ControleAbasPrincipal.ActivePageIndex := 0;
  ClientDataSetTabelas.Close;
  ClientDataSetTabelas.FieldDefs.Clear;
  ClientDataSetTabelas.FieldDefs.Add('Nome', ftString, 250, False);
  ClientDataSetTabelas.FieldDefs.Add('Vazio', ftString, 10, False); // Coluna vazia
  ClientDataSetTabelas.FieldDefs.Add('Dimensoes', ftString, 500, False); // Para a string formatada
  ClientDataSetTabelas.CreateDataSet;
  ClientDataSetTabelas.Open;
  DataSourceTabelas.DataSet := ClientDataSetTabelas;
  GradeTabelas.DataSource := DataSourceTabelas;
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
var
  NomePlanilhaParaExcluir: string;
begin
  if Assigned(FPlanilhaSelecionada) and (FPlanilhaSelecionada.Titulo <> '') then
  begin
    NomePlanilhaParaExcluir := FPlanilhaSelecionada.Titulo;

    if MessageDlg('Tem certeza que deseja excluir a planilha "' + NomePlanilhaParaExcluir + '"?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if Assigned(FOnExcluirPlanilha) then
        FOnExcluirPlanilha(NomePlanilhaParaExcluir)
      else
        ShowMessage('Evento OnExcluirPlanilha não está conectado.');
    end;
  end
  else
  begin
    ShowMessage('Nenhuma planilha selecionada para exclusão.');
  end;
end;

procedure TViewPrincipal.BotaoCriarPlanilhaClick(Sender: TObject);
var
  NomeNovaPlanilha: string;
  InputResult: Boolean;
begin
  NomeNovaPlanilha := 'NovaPlanilha_' + FormatDateTime('yyyymmdd_hhnnss', Now);
  InputResult := InputQuery('Criar Planilha', 'Digite o nome da nova planilha:', NomeNovaPlanilha);
  if InputResult and (Trim(NomeNovaPlanilha) <> '') then
  begin
    if Assigned(FOnCriarPlanilha) then
      FOnCriarPlanilha(Trim(NomeNovaPlanilha))
    else
      ShowMessage('Evento OnCriarPlanilha não está conectado.');
  end
  else
  begin
    if InputResult then
      ShowMessage('Nome da planilha não pode ser vazio.');
  end;
end;

procedure TViewPrincipal.BotaoCriarTabelaClick(Sender: TObject);
begin
  if Assigned(FOnNavegarParaCriadorTabela) then
  begin
    FOnNavegarParaCriadorTabela();
  end
  else
  begin
     ShowMessage('Navegação para o criador de tabela não configurada.');
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
      ShowMessage('Exclusão do relatório "' + FRelatorioSelecionado.Titulo + '" solicitada. Implementar no controller.');
    end;
  end;
end;

procedure TViewPrincipal.BotaoVisualizarRelatorioClick(Sender: TObject);
begin
    if Assigned(FOnNavegarParaVisualizadorRelatorio) then
      FOnNavegarParaVisualizadorRelatorio(FRelatorioSelecionado);
end;

procedure TViewPrincipal.AtualizarExibicaoPlanilha;
begin
  if Assigned(FOnSolicitarAtualizacaoPlanilha) then
      FOnSolicitarAtualizacaoPlanilha();
  end;
end;

procedure TViewPrincipal.BotaoAtualizarPlanilhaClick(Sender: TObject);
begin
  AtualizarExibicaoPlanilha;
end;

procedure TViewPrincipal.AtualizarExibicaoRelatorio;
begin
  // Lógica para atualizar MemoVisualizadorRelatorio com base na seleção em ListaRelatorios
end;

procedure TViewPrincipal.ListaPlanilhasClick(Sender: TObject);
var
  NomePlanilhaSelecionada: string;
begin
  if ListaPlanilhas.ItemIndex >= 0 then
  begin
    NomePlanilhaSelecionada := ListaPlanilhas.Items[ListaPlanilhas.ItemIndex];
    PopularGradeTabelas(NomePlanilhaSelecionada);
  end
  else
  begin
    // Limpa a grade se nenhuma planilha estiver selecionada
    ClientDataSetTabelas.Close;
    ClientDataSetTabelas.EmptyDataSet;
    ClientDataSetTabelas.Open;
  end;
  //(* esse IF acima inteiro deveria ser de um service
end;

procedure TViewPrincipal.PopularGradeTabelas(const ANomePlanilha: string);
begin
  if Assigned(FController) then
  begin
    FController.PopularGradeTabelasNaView(ANomePlanilha);
  end
  else
  begin
    ShowMessage('Erro: Controller não disponível para popular a grade de tabelas.');
  end;
end;

end.
