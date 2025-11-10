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

  // Conectar os eventos do Controller para atualizar a View (tem de ser refeito para o próprio controller redirecionar)
  if Assigned(FController) then
  begin
    // Conecta o evento do Controller para atualizar a lista de planilhas
    FController.OnListaPlanilhasAtualizada := HandleListaPlanilhasAtualizada;

    // Chama o Controller para atualizar a lista na inicialização
    FController.PopularListaPlanilhasNaView;
  end;

  // Atualiza status
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
  // Obter o nome da tabela selecionada na ListBox
  if ListaTabelas.ItemIndex >= 0 then
  begin
    NomeTabelaSelecionada := ListaTabelas.Items[ListaTabelas.ItemIndex];

    // Obter o nome da planilha selecionada
    if ListaPlanilhas.ItemIndex >= 0 then
    begin
      NomePlanilhaSelecionada := ListaPlanilhas.Items[ListaPlanilhas.ItemIndex];
    end
    else
    begin
      ShowMessage('Nenhuma planilha selecionada. Selecione uma planilha primeiro.');
      Exit; // Interrompe a execução se nenhuma planilha estiver selecionada
    end;

    // Chamar o evento do controller, passando os nomes
    if Assigned(FController.FOnNavegarParaEditorTabela) then
    begin
      // Passa os nomes diretamente
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
  // Atualiza o TListBox com a nova lista recebida do Controller
  ListaPlanilhas.Items.Assign(ALista); // Atribui diretamente os itens da lista recebida
end;

procedure TViewPrincipal.AtualizarExibicaoPlanilha;
begin
  if Assigned(FController) then
  begin
    // Chama diretamente o método do Controller responsável por atualizar a lista
    // Este método (AtualizarListaPlanilhas) irá chamar o Service e disparar o evento.
    FController.AtualizarListaPlanilhas;
    ListaPlanilhas.Items.Assign(FController.ListaPlanilhas);
    PopularGradeTabelas('Tirar tudo da grade tabelas');
  end
  else
  begin
    // Tratamento de erro caso o Controller não esteja disponível
    ShowMessage('Erro: Controller não está disponível para atualizar a lista de planilhas.');
    // Log de erro
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
    // Atualiza a grade se nenhuma planilha estiver selecionada
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
    FController.FOnNavegarParaEditorRelatorio(FController.FRelatorioSelecionado) // Passa DTO
  else
    ShowMessage('Método: FOnNavegarParaEditorRelatorio não está sendo criado!');
end;

procedure TViewPrincipal.BotaoExcluirRelatorioClick(Sender: TObject);
begin
  // Exemplo de como seria com um evento de exclusão no controller (ainda não existe no UPrincipalService/Controller atualizado)
  // if Assigned(FController.FRelatorioSelecionado) then
  // begin
  //   if MessageDlg('Tem certeza que deseja excluir o relatório "' + FController.FRelatorioSelecionado.Titulo + '"?',
  //     mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  //   begin
  //     if Assigned(FController.FOnExcluirRelatorio) then
  //       FController.FOnExcluirRelatorio(FController.FRelatorioSelecionado)
  //     else
  //       ShowMessage('Evento OnExcluirRelatorio não está conectado.');
  //   end;
  // end
  // else
  // begin
  //   ShowMessage('Nenhum relatório selecionado para exclusão.');
  // end;

  ShowMessage('Exclusão de relatório ainda não implementada via novo padrão.');
end;

procedure TViewPrincipal.BotaoVisualizarRelatorioClick(Sender: TObject);
begin
  if Assigned(FController.FOnNavegarParaVisualizadorRelatorio) then
    FController.FOnNavegarParaVisualizadorRelatorio(FController.FRelatorioSelecionado) // Passa DTO
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
      'Clique "Sim" se você quer continuar com essa tabela, "Não" se você quiser deletar a planilha dessa tabela e "Cancelar" para sair dessa caixa', // Sua pergunta
      mtConfirmation, // Tipo de mensagem (ícone de confirmação)
      [mbYes, mbNo, mbCancel], // Botões: Sim, Não, Cancelar
      0
    );
    case Resultado of
      mrYes:
        begin
          Resultado := MessageDlg(
            'Opção selecionada: excluir a tabela: ' + NomeTabelaSelecionada + slinebreak + slinebreak +
            'Clique "Sim" se você quer continuar com essa exclusão e "Cancelar" se você não quiser deletar', // Sua pergunta
            mtConfirmation,
            [mbYes, mbCancel],
            0
          );
          case Resultado of
            mrYes:
              begin
                // Log + Deletação Lógica no BD
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
            'Clique "Sim" se você quer continuar com a exclusão da planilha: '+ NomePlanilhaSelecionada + ' e "Cancelar" se você não quiser deletar', // Sua pergunta
            mtConfirmation,
            [mbYes, mbCancel],
            0
          );
          case Resultado of
            mrYes:
            begin
              // Log + Deletação Lógica no BD
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
  // Gera um nome sugerido
  NomeNovaPlanilha := 'NovaPlanilha_' + FormatDateTime('yyyymmdd_hhnnss', Now);
  // Solicita o nome ao usuário
  InputResult := InputQuery('Criar Planilha', 'Digite o nome da nova planilha:', NomeNovaPlanilha);

  if InputResult and (Trim(NomeNovaPlanilha) <> '') then
  begin
    // Dispara o evento de criação no Controller, passando o nome sugerido
    if Assigned(FController.FOnCriarPlanilha) then
      FController.FOnCriarPlanilha(Trim(NomeNovaPlanilha)) // Passa o nome
    else
      ShowMessage('Evento OnCriarPlanilha não está conectado.');
  end
  else
  begin
    if InputResult then // Se o InputQuery foi cancelado, InputResult é False
      ShowMessage('Nome da planilha não pode ser vazio.');
  end;
end;

end.
