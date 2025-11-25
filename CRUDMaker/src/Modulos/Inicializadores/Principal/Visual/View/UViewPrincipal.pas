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

  Data.DB, Datasnap.DBClient, UTabelaDTO,
  UPrincipalController, UFormBaseMinTopoCentro;

type
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
    DivisorPlanilha: TSplitter;
    PainelEsquerdoPlanilhas: TPanel;
    ListaPlanilhas: TListBox;
    PainelDireitoTabelas: TPanel;
    PainelBotoesTabela: TPanel;
    BotaoEditarTabela: TButton;
    BotaoExcluir: TButton;
    BotaoCriarPlanilha: TButton;
    BotaoCriarTabela: TButton;
    AbaRelatorios: TTabSheet;
    DivisorRelatorio: TSplitter;
    PainelEsquerdoRelatorios: TPanel;
    ListaRelatorios: TListBox;
    ListaTabelas: TListBox;
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
    procedure MenuItemLogoutClick(Sender: TObject);
    procedure MenuItemSalvarAssociacaoClick(Sender: TObject);
    procedure BotaoEditarTabelaClick(Sender: TObject);
    procedure BotaoExcluirClick(Sender: TObject);
    procedure BotaoCriarTabelaClick(Sender: TObject);
    procedure BotaoCriarPlanilhaClick(Sender: TObject);
    procedure BotaoAtualizarPlanilhaClick(Sender: TObject);
    procedure BotaoEditarRelatorioClick(Sender: TObject);
    procedure BotaoExcluirRelatorioClick(Sender: TObject);
    procedure BotaoVisualizarRelatorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListaPlanilhasClick(Sender: TObject);
  private
    procedure HandleListaPlanilhasAtualizada(const ALista: TStringList);
    procedure AtualizarExibicaoPlanilha;
    procedure AtualizarExibicaoRelatorio;
    procedure PopularGradeTabelas(const ANomeTabela: string);
  public
    FController: TPrincipalController;
    procedure DefinirNomeUsuario(const ANome: string);
  end;

var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  inherited;
  FController.FPlanilhaSelecionada := nil;
  FController.FRelatorioSelecionado := nil;

  if Assigned(FController) then
  begin
    FController.OnListaPlanilhasAtualizada := HandleListaPlanilhasAtualizada;

    FController.PopularListaPlanilhasNaView;
  end;

  BarraStatusPrincipal.SimpleText := 'Pronto - Nenhum arquivo carregado. Use "Carregar".';
end;

procedure TViewPrincipal.DefinirNomeUsuario(const ANome: string);
begin
  RotuloBemVindo.Caption := 'Bem-vindo, ' + ANome + '!';
end;

procedure TViewPrincipal.MenuItemLogoutClick(Sender: TObject);
begin
  if Assigned(FController.FOnSolicitarLogout) then
    FController.FOnSolicitarLogout
  else
    ShowMessage('Método: FOnSolicitarLogout não está sendo criado!');
end;

procedure TViewPrincipal.MenuItemSalvarAssociacaoClick(Sender: TObject);
begin
  if Assigned(FController.FOnAbrirSalvarAssociacao) then
    FController.FOnAbrirSalvarAssociacao
  else
    ShowMessage('Método: FOnAbrirSalvarAssociacao não está sendo criado!');
end;

procedure TViewPrincipal.BotaoEditarTabelaClick(Sender: TObject);
var
  NomeTabelaSelecionada: string;
  NomePlanilhaSelecionada: string;
begin
  if ListaTabelas.ItemIndex >= 0 then
  begin
    NomeTabelaSelecionada := ListaTabelas.Items[ListaTabelas.ItemIndex];

    if ListaPlanilhas.ItemIndex >= 0 then
    begin
      NomePlanilhaSelecionada := ListaPlanilhas.Items[ListaPlanilhas.ItemIndex];
    end
    else
    begin
      ShowMessage('Nenhuma planilha selecionada. Selecione uma planilha primeiro.');
      Exit;
    end;

    if Assigned(FController.FOnNavegarParaEditorTabela) then
    begin
      FController.FOnNavegarParaEditorTabela(NomePlanilhaSelecionada, NomeTabelaSelecionada);
    end
    else
    begin
      ShowMessage('Método: FOnNavegarParaEditorTabela não está sendo criado!');
    end;
  end
  else
  begin
    ShowMessage('Selecione uma tabela para editar.');
  end;
end;

procedure TViewPrincipal.BotaoCriarTabelaClick(Sender: TObject);
begin
  if Assigned(FController.FOnNavegarParaCriadorTabela) then
    FController.FOnNavegarParaCriadorTabela
  else
    ShowMessage('Método: FOnNavegarParaCriadorTabela não está sendo criado!');
end;

procedure TViewPrincipal.HandleListaPlanilhasAtualizada(const ALista: TStringList);
begin
  ListaPlanilhas.Items.Assign(ALista);
end;

procedure TViewPrincipal.AtualizarExibicaoPlanilha;
begin
  if Assigned(FController) then
  begin
    FController.AtualizarListaPlanilhas;
    ListaPlanilhas.Items.Assign(FController.ListaPlanilhas);
    PopularGradeTabelas('Tirar tudo da grade tabelas');
  end
  else
  begin
    ShowMessage('Erro: Controller não está disponível para atualizar a lista de planilhas.');
  end;
end;

procedure TViewPrincipal.BotaoAtualizarPlanilhaClick(Sender: TObject);
begin
  AtualizarExibicaoPlanilha;
end;

procedure TViewPrincipal.AtualizarExibicaoRelatorio;
begin
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
    AtualizarExibicaoPlanilha;
  end;
end;

procedure TViewPrincipal.PopularGradeTabelas(const ANomeTabela: string);
begin
  if Assigned(FController) then
  begin
    FController.PopularGradeTabelasNaView(ANomeTabela);
    ListaTabelas.Items.Assign(FController.ListaInfoTabelas)
  end
  else
  begin
    ShowMessage('Erro: Controller não disponível para popular a grade de tabelas.');
  end;
end;

procedure TViewPrincipal.BotaoEditarRelatorioClick(Sender: TObject);
begin
  if Assigned(FController.FOnNavegarParaEditorRelatorio) then
    FController.FOnNavegarParaEditorRelatorio(FController.FRelatorioSelecionado)
  else
    ShowMessage('Método: FOnNavegarParaEditorRelatorio não está sendo criado!');
end;

procedure TViewPrincipal.BotaoExcluirRelatorioClick(Sender: TObject);
begin
  ShowMessage('Exclusão de relatório ainda não implementada via novo padrão.');
end;

procedure TViewPrincipal.BotaoVisualizarRelatorioClick(Sender: TObject);
begin
  if Assigned(FController.FOnNavegarParaVisualizadorRelatorio) then
    FController.FOnNavegarParaVisualizadorRelatorio(FController.FRelatorioSelecionado)
  else
    ShowMessage('Método: FOnNavegarParaVisualizadorRelatorio não está sendo criado!');
end;

procedure TViewPrincipal.BotaoExcluirClick(Sender: TObject);
var
  NomePlanilhaParaExcluir: string;
  NomeTabelaSelecionada, NomePlanilhaSelecionada: string;
  Resultado: integer;
begin
  if ListaTabelas.ItemIndex >= 0 then
  begin
    NomeTabelaSelecionada := ListaTabelas.Items[ListaTabelas.ItemIndex];
    NomePlanilhaSelecionada := ListaPlanilhas.Items[ListaPlanilhas.ItemIndex];

    Resultado := MessageDlg(
      'Você selecionou a tabela: ' + NomeTabelaSelecionada + ' para exclusão.' + slinebreak + slinebreak +
      'Clique "Sim" se você quer continuar com essa tabela, "Não" se você quiser deletar a planilha dessa tabela e "Cancelar" para sair dessa caixa',
      mtConfirmation,
      [mbYes, mbNo, mbCancel],
      0
    );
    case Resultado of
      mrYes:
        begin
          Resultado := MessageDlg(
            'Opção selecionada: excluir a tabela: ' + NomeTabelaSelecionada + slinebreak + slinebreak +
            'Clique "Sim" se você quer continuar com essa exclusão e "Cancelar" se você não quiser deletar',
            mtConfirmation,
            [mbYes, mbCancel],
            0
          );
          case Resultado of
            mrYes:
              begin
                FController.FOnExcluirTabela(NomeTabelaSelecionada, NomePlanilhaSelecionada);
                PopularGradeTabelas(NomePlanilhaSelecionada);
                Exit;
              end;
            mrCancel:
              begin
               Exit;
              end;
          end;
        end;

      mrNo:
        begin
          if not (NomePlanilhaSelecionada <> '') then
          begin
            showmessage('Selecione uma planilha!');
          end;
          Resultado := MessageDlg(
            'Opção selecionada: excluir a planilha associada: ' + NomePlanilhaSelecionada + slinebreak + slinebreak +
            'Clique "Sim" se você quer continuar com a exclusão da planilha: '+ NomePlanilhaSelecionada + ' e "Cancelar" se você não quiser deletar',
            mtConfirmation,
            [mbYes, mbCancel],
            0
          );
          case Resultado of
            mrYes:
            begin
              FController.FOnExcluirPlanilha(NomePlanilhaSelecionada);
              PopularGradeTabelas(NomePlanilhaSelecionada);
              AtualizarExibicaoPlanilha;
              Exit;
            end;
            mrCancel:
            begin
               Exit;
            end;
          end;
        end;

      mrCancel:
        begin
          Exit;
        end;
    end;
  end
  else
  begin
    BarraStatusPrincipal.SimpleText := ' - Selecione uma Planilha e Tabela antes de começar uma exclusão';
    Sleep(3000);
    BarraStatusPrincipal.SimpleText := '';
    exit;
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
    if Assigned(FController.FOnCriarPlanilha) then
      FController.FOnCriarPlanilha(Trim(NomeNovaPlanilha))
    else
      ShowMessage('Evento OnCriarPlanilha não está conectado.');
  end
  else
  begin
    if InputResult then
      ShowMessage('Nome da planilha não pode ser vazio.');
  end;
end;

end.
