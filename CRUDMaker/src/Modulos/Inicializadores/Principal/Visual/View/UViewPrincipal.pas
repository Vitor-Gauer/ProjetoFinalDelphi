unit UViewPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids,
  Data.DB, Datasnap.DBClient,
  Vcl.StdCtrls, Vcl.Menus,
  UTabelaDTO, UPlanilhaDTO, URelatorioDTO, UShowViewController, UFormBaseMinTopoCentro;

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
    procedure BotaoEditarRelatorioClick(Sender: TObject);
    procedure BotaoExcluirRelatorioClick(Sender: TObject);
    procedure BotaoVisualizarRelatorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListaPlanilhasClick(Sender: TObject);
  private
    FTabelaSelecionada: TPlanilhaDTO;
    FRelatorioSelecionado: TRelatorioDTO;
    FOnCriarPlanilha: TCriarPlanilhaEvent;
    FOnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent;
    FOnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent;
    FOnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent;
    FOnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent;
    FOnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent;
    FOnSolicitarLogout: TOnSolicitarLogoutEvent;
    FOnAbrirGerenciador: TOnAbrirGerenciadorEvent;
    FOnAbrirCompartilhamento: TOnAbrirCompartilhamentoEvent;
    procedure AtualizarExibicaoPlanilha;
    procedure AtualizarExibicaoRelatorio;
    //procedure PopularGradeTabelas(const ANomePlanilha: string);
  public
    procedure DefinirNomeUsuario(const ANome: string);
    property OnCriarPlanilha: TCriarPlanilhaEvent read FOnCriarPlanilha write FOnCriarPlanilha;
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

{$R *.dfm}

uses
  System.UITypes, System.IOUtils; // System.IOUtils para manipulação de diretórios

procedure TViewPrincipal.FormCreate(Sender: TObject);
begin
  ControleAbasPrincipal.ActivePageIndex := 0;
  ClientDataSetTabelas.FieldDefs.Add('Nome', ftString, 250, False);
  ClientDataSetTabelas.FieldDefs.Add('Vazio', ftString, 10, False); // Coluna vazia
  ClientDataSetTabelas.FieldDefs.Add('Dimensoes', ftString, 100, False);
  ClientDataSetTabelas.CreateDataSet;
  ClientDataSetTabelas.Open;
  // Associa o DataSource ao ClientDataSet
  DataSourceTabelas.DataSet := ClientDataSetTabelas;
  // Associa o DBGrid ao DataSource
  GradeTabelas.DataSource := DataSourceTabelas;
  // Configura colunas do DBGrid,
  // Certifique-se de que GradeTabelas.Columns esteja habilitado (dgColLines, dgRowLines no Options)
  if GradeTabelas.Columns.Count >= 3 then
  begin
    GradeTabelas.Columns[0].Title.Caption := 'Nome da Tabela';
    GradeTabelas.Columns[1].Title.Caption := '';
    GradeTabelas.Columns[2].Title.Caption := 'Dimensões';
    GradeTabelas.Columns[0].Width := 200;
    GradeTabelas.Columns[1].Width := 20; // Coluna vazia pequena
    GradeTabelas.Columns[2].Width := 150;
  end;
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
      ShowMessage('Exclusão da planilha "' + FTabelaSelecionada.Titulo + '" solicitada. Implementar no controller.');
    end;
  end;
end;

// --- NOVO: Implementação do botão Criar Planilha ---
procedure TViewPrincipal.BotaoCriarPlanilhaClick(Sender: TObject);
var
  NomeNovaPlanilha: string;
  InputResult: Boolean;
begin
  // Sugere um nome padrão (pode ser melhorado)
  NomeNovaPlanilha := 'NovaPlanilha_' + FormatDateTime('yyyymmdd_hhnnss', Now);

  // Solicita o nome ao usuário
  InputResult := InputQuery('Criar Planilha', 'Digite o nome da nova planilha:', NomeNovaPlanilha);

  if InputResult and (Trim(NomeNovaPlanilha) <> '') then
  begin
    // Validação básica do nome (opcional, pode ser mais robusta)
    if (Pos('\', NomeNovaPlanilha) > 0) or (Pos('/', NomeNovaPlanilha) > 0) or
       (Pos(':', NomeNovaPlanilha) > 0) or (Pos('*', NomeNovaPlanilha) > 0) or
       (Pos('?', NomeNovaPlanilha) > 0) or (Pos('"', NomeNovaPlanilha) > 0) or
       (Pos('<', NomeNovaPlanilha) > 0) or (Pos('>', NomeNovaPlanilha) > 0) or
       (Pos('|', NomeNovaPlanilha) > 0) then
    begin
      ShowMessage('Nome inválido. Não use os seguintes caracteres: \ / : * ? " < > |');
      Exit;
    end;

    // Dispara o evento para que o controller trate a criação
    if Assigned(FOnCriarPlanilha) then
      FOnCriarPlanilha(Trim(NomeNovaPlanilha))
    else
      ShowMessage('Evento OnCriarPlanilha não está conectado.');
  end
  else
  begin
    if InputResult then // Se o usuário clicou OK mas deixou o nome vazio
      ShowMessage('Nome da planilha não pode ser vazio.');
    // Se InputResult for False, o usuário cancelou, então não faz nada.
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
    // TViewController.Instance.ShowViewEditorRelatorio // Esta linha parece estar fora do lugar
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
      // TViewController.Instance.ShowViewVisualizadorRelatorio(FRelatorioSelecionado); // Esta linha parece estar fora do lugar
end;

procedure TViewPrincipal.AtualizarExibicaoPlanilha;
begin
  // Lógica para atualizar GradePlanilha com base na seleção em ListaPlanilhas
  // Esta lógica agora é feita em ListaPlanilhasClick
end;

procedure TViewPrincipal.AtualizarExibicaoRelatorio;
begin
  // Lógica para atualizar MemoVisualizadorRelatorio com base na seleção em ListaRelatorios
end;

// --- NOVO: Popular GradeTabelas ao selecionar uma planilha ---
procedure TViewPrincipal.ListaPlanilhasClick(Sender: TObject);
var
  NomePlanilhaSelecionada: string;
begin
  if ListaPlanilhas.ItemIndex >= 0 then
  begin
    NomePlanilhaSelecionada := ListaPlanilhas.Items[ListaPlanilhas.ItemIndex];
    // Atualiza a grade com as tabelas dessa planilha
    //PopularGradeTabelas(NomePlanilhaSelecionada);
  end
  else
  begin
    // Limpa a grade se nenhuma planilha estiver selecionada
   ClientDataSetTabelas.Close;
    ClientDataSetTabelas.EmptyDataSet;
    ClientDataSetTabelas.Open;
  end;
end;

(*procedure TViewPrincipal.PopularGradeTabelas(const ANomePlanilha: string);
var
  DiretorioPlanilha, DiretorioTabelas: string;
  SubDirs: TArray<string>;
  ArquivosXML: TArray<string>;
  i, j: Integer;
  NomeTabela: string;
  CaminhoTabela: string;
  Dimensoes: string;
  // Para ler o XML
  XMLDoc: IXMLDocument;
  TabelaNode, LinhasNodeList, LinhaNode, ColunasNode, CelulasNodeList: IXMLNode;
  NumLinhas, NumColunas: Integer;
  MaxColunasEncontradas: Integer;
begin
  ClientDataSetTabelas.Close;
  ClientDataSetTabelas.EmptyDataSet;
  ClientDataSetTabelas.Open;

  DiretorioPlanilha := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
                       'Planilhas' + PathDelim + ANomePlanilha;
  DiretorioTabelas := IncludeTrailingPathDelimiter(DiretorioPlanilha) + 'Tabelas';

  if TDirectory.Exists(DiretorioTabelas) then
  begin
    SubDirs := TDirectory.GetDirectories(DiretorioTabelas);
    for i := Low(SubDirs) to High(SubDirs) do
    begin
      NomeTabela := ExtractFileName(SubDirs[i]);
      // Assume que dentro da pasta da tabela há um arquivo .xml com o nome base
      CaminhoTabela := IncludeTrailingPathDelimiter(SubDirs[i]) + NomeTabela + '*.xml';
      ArquivosXML := TDirectory.GetFiles(SubDirs[i], '*.xml');

      Dimensoes := 'Não encontrado'; // Valor padrão se não houver XML
      if Length(ArquivosXML) > 0 then
      begin
        // Tenta ler o primeiro arquivo XML encontrado para obter dimensões
        try
          XMLDoc := TXMLDocument.Create(nil);
          XMLDoc.LoadFromFile(ArquivosXML[0]);
          XMLDoc.Active := True;

          // Navega até o nó <Tabela>
          TabelaNode := XMLDoc.DocumentElement.ChildNodes.FindNode('Redor');
          if Assigned(TabelaNode) then
            TabelaNode := TabelaNode.ChildNodes.FindNode('Redor');
          if Assigned(TabelaNode) then
            TabelaNode := TabelaNode.ChildNodes.FindNode('Tabela');

          if Assigned(TabelaNode) then
          begin
            LinhasNodeList := TabelaNode.ChildNodes; // Lista de nós <Linha>
            if Assigned(LinhasNodeList) then
            begin
              NumLinhas := LinhasNodeList.Count;
              MaxColunasEncontradas := 0;
              // Itera pelas linhas para encontrar o máximo de colunas
              for j := 0 to LinhasNodeList.Count - 1 do
              begin
                LinhaNode := LinhasNodeList[j];
                if (LinhaNode.NodeName = 'Linha') then
                begin
                  ColunasNode := LinhaNode.ChildNodes.FindNode('Colunas');
                  if Assigned(ColunasNode) then
                  begin
                    CelulasNodeList := ColunasNode.ChildNodes;
                    if Assigned(CelulasNodeList) then
                    begin
                      NumColunas := CelulasNodeList.Count;
                      if NumColunas > MaxColunasEncontradas then
                        MaxColunasEncontradas := NumColunas;
                    end;
                  end;
                end;
              end;
              Dimensoes := Format('%dx%d', [NumLinhas, MaxColunasEncontradas]);
            end
            else
            begin
               Dimensoes := '0x0 (sem linhas)';
            end;
          end
          else
          begin
            Dimensoes := 'Estrutura XML inválida';
          end;
        except
          on E: Exception do
          begin
            Dimensoes := 'Erro ao ler XML: ' + E.ClassName;
            // Opcional: Logar o erro E.Message
          end;
        end;
        XMLDoc := nil; // Libera a interface
      end;

      ClientDataSetTabelas.Append;
      ClientDataSetTabelas.FieldByName('Nome').AsString := NomeTabela;
      ClientDataSetTabelas.FieldByName('Vazio').AsString := '';
      ClientDataSetTabelas.FieldByName('Dimensoes').AsString := Dimensoes;
      ClientDataSetTabelas.Post;
    end;
  end;

  if ClientDataSetTabelas.IsEmpty then
  begin
    // Opcional: Mostra uma mensagem se não houver tabelas
    ClientDataSetTabelas.Append;
    ClientDataSetTabelas.FieldByName('Nome').AsString := '(Nenhuma tabela encontrada)';
    ClientDataSetTabelas.FieldByName('Vazio').AsString := '';
    ClientDataSetTabelas.FieldByName('Dimensoes').AsString := '';
    ClientDataSetTabelas.Post;
  end;
end;   *)

end.
