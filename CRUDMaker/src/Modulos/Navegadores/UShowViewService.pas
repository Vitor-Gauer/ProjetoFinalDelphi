unit UShowViewService;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.variants,
  Vcl.Forms, VCL.Dialogs,
  Data.Db,
  UCriadorTabelaController, UPrincipalController,
  UTabelaConfiguracaoDTO, UTabelaDTO, UPlanilhaDTO,
  URelatorioDTO, UAssociacaoDTO,
  UPrincipalService, UPersistenciaLocalService, UPlanilhaService;

type
  // --- Tipos de Evento (POObj)
  TNavegarParaCriadorTabelaEvent = procedure of object;
  TNavegarParaEditorTabelaEvent = procedure(const APlanilhaNome, ATabelaNome: string) of object;
  TNavegarParaNovoRelatorioComBaseEvent = procedure(const ATabelaBase: TTabelaDTO) of object;
  TNavegarParaEditorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TNavegarParaVisualizadorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TOnSolicitarLogoutEvent = procedure of object;
  TOnAbrirSalvarAssociacaoEvent = procedure of object;

  TShowViewService = class
  private
    class var FInstance: TShowViewService;
    class function GetInstance: TShowViewService; static;
    class var FTempLoginSucesso: Boolean;
    class var FTempNomeUsuario: string;
    // --- Métodos Auxiliares para o Fluxo de Criação de Tabelas ---
    class procedure AuxFluxoCriarTabela_Configurar_Avancar(AConfiguracao: UTabelaConfiguracaoDTO.TConfiguracaoTabelaDTO);
    class procedure AuxFluxoCriarTabela_Configurar_Cancelar(Sender: TObject);
    class procedure AuxFluxoCriarTabela_Configurar_Voltar(Sender: TObject);
    class procedure AuxFluxoCriarTabela_Dados_Fechar(Sender: TObject; var Action: TCloseAction);
    class procedure AuxFluxoCriarTabela_Iniciar;
    class procedure AuxFluxoCriarTabela_Selecionar_Avancar(Sender: TObject);
    class procedure AuxFluxoCriarTabela_Selecionar_Cancelar(Sender: TObject);
  public
    class property Instance: TShowViewService read GetInstance;
    procedure CloseViewPrincipal;
    class procedure FreeInstance;
    procedure IniciarAplicacao;
    procedure ShowViewSalvarAssociacao;
    procedure ShowViewEditorRelatorio(ARelatorio: TRelatorioDTO = nil; APlanilhaBase: TPlanilhaDTO = nil);
    procedure ShowViewEditorTabela(const APlanilhaNome:string ; ATabela: TTabelaDTO; ADataSet: TDataSet);
    procedure ShowViewLogin(AModal: Boolean = False);
    function ShowViewModalTermos: Boolean;
    procedure ShowViewPrincipalModal(AUsuarioNome: string);
    class procedure ShowViewCriadorTabela;
    procedure ShowViewImprimirRelatorioPronto(ARelatorio: TRelatorioDTO);

    // --- NOVOS MÉTODOS PARA RELATÓRIOS E ASSOCIAÇÕES ---
    procedure ShowViewCriadorRelatorio(ATabelaBase: TTabelaDTO);
    procedure ShowViewCriadorAssociacao(APlanilhaBase: TPlanilhaDTO);
    procedure ShowViewEditorAssociacao(AAssociacao: TAssociacaoDTO);

    // --- Manipuladores Estáticos
    class procedure ManipuladorSolicitarLogout;
    class procedure ManipuladorNavegarParaCriadorTabela;
    class procedure ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
    class procedure ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
    class procedure ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
    class procedure ManipuladorAbrirSalvarAssociacao;
    class procedure ManipuladorLogin(const AUsuario, ASenha: string; AModoPublico: Boolean);
    class procedure ManipuladorCancelarLogin;
  end;

implementation
uses
  UViewLogin, UViewPrincipal, UViewModalTermos, UViewEditorTabela,
  UViewEditorRelatorio, UViewImprimirRelatorioPronto,
  UViewSalvarAssociacao, UViewSelecionarPlanilhaParaTabela,
  UViewConfigurarTabela, UViewCriadorTabelaDados,

  UViewCriadorRelatorio, UViewCriadorAssociacao, UViewEditorAssociacao;
{ TShowViewService }
var
  GViewSelecionar: TViewSelecionarPlanilhaParaTabela; //Foram criadas globalmente, pois é necessário passar os dados de quando elas são criadas até quando são destruidas
  GViewConfigurar: TViewConfigurarTabela;
  GViewCriadorDados: TViewCriadorTabelaDados;
  GViewEditorAssociacao: TViewEditorAssociacao;

procedure TShowViewService.ShowViewCriadorRelatorio(ATabelaBase: TTabelaDTO);
var
  LView: TViewCriadorRelatorio;
begin
  // A view TViewCriadorRelatorio agora é responsável por criar seu próprio controller
  // dentro de seu método Create.
  // O ShowViewService apenas instancia e exibe.
  LView := TViewCriadorRelatorio.Create(Application, ATabelaBase);
  try
    LView.ShowModal; // Exemplo: pode ser Show ou ShowModal dependendo do fluxo desejado
  finally
    LView.Free;
  end;
end;

procedure TShowViewService.ShowViewCriadorAssociacao(APlanilhaBase: TPlanilhaDTO);
var
  LView: TViewCriadorAssociacao;
begin
  // A view TViewCriadorAssociacao agora é responsável por criar seu próprio controller
  // dentro de seu método Create.
  // O ShowViewService apenas instancia e exibe.
  LView := TViewCriadorAssociacao.Create(Application, APlanilhaBase);
  try
    LView.ShowModal; // Exemplo: pode ser Show ou ShowModal dependendo do fluxo desejado
  finally
    LView.Free;
  end;
end;

procedure TShowViewService.ShowViewEditorAssociacao(AAssociacao: TAssociacaoDTO);
begin
  // A view TViewEditorAssociacao agora é responsável por criar seu próprio controller
  // dentro de seu método Create.
  // O ShowViewService apenas instancia e exibe.
  GViewEditorAssociacao := TViewEditorAssociacao.Create(Application, AAssociacao);
  try
    GViewEditorAssociacao.ShowModal; // Exemplo: pode ser Show ou ShowModal dependendo do fluxo desejado
  finally
    GViewEditorAssociacao.Free;
  end;
end;

// --- Métodos Auxiliares e outros mantidos inalterados ---
// (Todo o código existente permanece como estava)

class procedure TShowViewService.ManipuladorSolicitarLogout;
begin
//  // Chama a lógica de logout e navegação
//  ShowViewLogin(False); // Abre login não modal
//  CloseViewPrincipal; // Fecha a principal
end;

class procedure TShowViewService.ManipuladorNavegarParaCriadorTabela;
begin
  Instance.ShowViewCriadorTabela; // Chama o serviço via instância
end;

class procedure TShowViewService.ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
begin
  ShowMessage('Navegação para Novo Relatório com Base solicitada (DTO: ' + ATabelaBase.Titulo + ').');
  // Implementar chamada real ao serviço de criação de relatório com base em uma tabela
end;

class procedure TShowViewService.ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  Instance.ShowViewEditorRelatorio(ARelatorio); // Chama o serviço via instância, passando DTO
end;

class procedure TShowViewService.ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  ShowMessage('Navegação para Visualizador de Relatório solicitada (DTO: ' + ARelatorio.Titulo + ').');
  // Implementar chamada real ao visualizador de relatório
end;

class procedure TShowViewService.ManipuladorAbrirSalvarAssociacao;
begin
  Instance.ShowViewSalvarAssociacao; // Chama o serviço via instância
end;

class procedure TShowViewService.ManipuladorLogin(const AUsuario, ASenha: string; AModoPublico: Boolean);
begin
  FTempNomeUsuario := AUsuario;
  if FTempNomeUsuario = '' then
    FTempNomeUsuario := 'Anônimo';
  FTempLoginSucesso := True;
end;

class procedure TShowViewService.ManipuladorCancelarLogin;
begin
  FTempLoginSucesso := False;
  FTempNomeUsuario := 'Anônimo';
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Iniciar;
begin
  // Cria a primeira View do fluxo
  GViewSelecionar := TViewSelecionarPlanilhaParaTabela.Create(Application);
  // Conecta os eventos da ViewSelecionar
  GViewSelecionar.OnAvancar := AuxFluxoCriarTabela_Selecionar_Avancar;
  GViewSelecionar.OnCancelar := AuxFluxoCriarTabela_Selecionar_Cancelar;
  // Exibe a ViewSelecionar MODALMENTE
  GViewSelecionar.ShowModal; // <-- O fluxo espera aqui até ViewSelecionar fechar
end;

// --- Etapa 1: Selecionar Planilha -> Configurar Tabela ---
class procedure TShowViewService.AuxFluxoCriarTabela_Selecionar_Avancar(Sender: TObject);
begin
  if Sender is TViewSelecionarPlanilhaParaTabela then
  begin
    try
      GViewSelecionar := TViewSelecionarPlanilhaParaTabela(Sender);
      // Cria a próxima View (Configurar)
      GViewConfigurar := TViewConfigurarTabela.Create(Application, GViewSelecionar.PlanilhaSelecionada);
        // Conecta os eventos da ViewConfigurar
        GViewConfigurar.OnAvancar := AuxFluxoCriarTabela_Configurar_Avancar; // Chama o próximo passo
        GViewConfigurar.OnVoltar := AuxFluxoCriarTabela_Configurar_Voltar;   // Chama o passo anterior
        GViewConfigurar.OnCancelar := AuxFluxoCriarTabela_Configurar_Cancelar; // Fecha a ViewConfigurar
        // Exibe ViewConfigurar MODALMENTE
        GViewConfigurar.ShowModal; // <-- O fluxo espera aqui até ViewConfigurar fechar
    finally
    end;
  end;
end;

// --- Etapa 1: Cancelar Selecionar Planilha ---
class procedure TShowViewService.AuxFluxoCriarTabela_Selecionar_Cancelar(Sender: TObject);
begin
  if Sender is TViewSelecionarPlanilhaParaTabela then
  begin
     TViewSelecionarPlanilhaParaTabela(Sender).Close; // Fecha a ViewSelecionar
  end;
end;

// --- Etapa 2: Configurar Tabela -> Criador Dados ---
class procedure TShowViewService.AuxFluxoCriarTabela_Configurar_Avancar(AConfiguracao: UTabelaConfiguracaoDTO.TConfiguracaoTabelaDTO);
begin
  // Cria a próxima View (CriadorDados)
  GViewCriadorDados := TViewCriadorTabelaDados.Create(Application, AConfiguracao);
  try
    GViewCriadorDados.OnClose := AuxFluxoCriarTabela_Dados_Fechar;
    // Exibe ViewCriadorDados MODALMENTE
    GViewCriadorDados.ShowModal; // <-- O fluxo espera aqui até ViewCriadorDados fechar
  finally
  end;
end;

// --- Etapa 2: Cancelar Configurar Tabela ---
class procedure TShowViewService.AuxFluxoCriarTabela_Configurar_Cancelar(Sender: TObject);
begin
  if Sender is TViewConfigurarTabela then
  begin
     TViewConfigurarTabela(Sender).Close; // Fecha a ViewConfigurar
  end;
end;

// --- Etapa 2: Voltar Configurar Tabela -> Selecionar Planilha ---
class procedure TShowViewService.AuxFluxoCriarTabela_Configurar_Voltar(Sender: TObject);
begin
  if Sender is TViewConfigurarTabela then
  begin
    GViewConfigurar := TViewConfigurarTabela(Sender);
    // Cria a View anterior (Selecionar)
    GViewSelecionar := TViewSelecionarPlanilhaParaTabela.Create(Application);
    try
      // Conecta os eventos da ViewSelecionar
      GViewSelecionar.OnAvancar := AuxFluxoCriarTabela_Selecionar_Avancar;
      GViewSelecionar.OnCancelar := AuxFluxoCriarTabela_Selecionar_Cancelar;
      // Exibe ViewSelecionar MODALMENTE
      GViewSelecionar.ShowModal; // <-- O fluxo espera aqui até ViewSelecionar fechar
    finally
    end;
  end;
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Dados_Fechar(Sender: TObject; var Action: TCloseAction);
begin
   if not assigned(GViewSelecionar) then
   begin
     ShowMessage('Algo deu errado no GViewSelecionar');
   end;
   if not assigned(GViewConfigurar) then
   begin
     ShowMessage('Algo deu errado no GViewConfigurar');
   end;
   if not assigned(GViewCriadorDados) then
   begin
     ShowMessage('Algo deu errado no GViewCriadorDados 1');
   end;
end;

class function TShowViewService.GetInstance: TShowViewService;
begin
  if not Assigned(FInstance) then
    FInstance := TShowViewService.Create;
  Result := FInstance;
end;

class procedure TShowViewService.FreeInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TShowViewService.IniciarAplicacao;
begin
  if Self.ShowViewModalTermos then
  begin
    Self.ShowViewLogin(True);
  end
  else
  begin
    Self.ShowViewPrincipalModal('Anônimo');
  end;
end;

function TShowViewService.ShowViewModalTermos: Boolean;
var
  LView: TViewModalTermos;
begin
  LView := TViewModalTermos.Create(nil);
  try
    Result := (LView.ShowModal = mrOk);
  finally
    LView.Free;
  end;
end;

procedure TShowViewService.ShowViewPrincipalModal(AUsuarioNome: string);
var
  LView: TViewPrincipal;
  LPrincipalController: TPrincipalController;
  LPlanilhaService: TPlanilhaService;
begin
  LView := TViewPrincipal.Create(Application);

  //Criadores
  LPlanilhaService := TPlanilhaService.Create(nil {DAO}, nil {XMLService}, nil {CSVService}); // Ajustar injeção real após BD
  LPrincipalController := TPrincipalController.Create(TPrincipalService.Create, TPersistenciaLocalService.Create, LPlanilhaService);;
  LView.FController := LPrincipalController;

  // Conectar os manipuladores estáticos do serviço aos eventos do novo controller
  LPrincipalController.OnNavegarParaCriadorTabela := Self.ManipuladorNavegarParaCriadorTabela;
  LPrincipalController.OnSolicitarLogout := Self.ManipuladorSolicitarLogout;
  LPrincipalController.OnAbrirSalvarAssociacao := Self.ManipuladorAbrirSalvarAssociacao;
  // LPrincipalController.OnNavegarParaEditorTabela := Self.ManipuladorNavegarParaEditorTabela; // Conectar quando for chamado

  try
    LView.DefinirNomeUsuario(AUsuarioNome);
    LView.ShowModal;
  finally
    LPrincipalController.Free; // Libera o controller
    LPlanilhaService.Free; // Libera o serviço
    LView.Free;
  end;
end;

class procedure TShowViewService.ShowViewCriadorTabela;
begin
  AuxFluxoCriarTabela_Iniciar;
end;

procedure TShowViewService.ShowViewSalvarAssociacao;
var
  LView: TViewSalvarAssociacao;
begin
  LView := TViewSalvarAssociacao.Create(Application);
  LView.Show;
end;

procedure TShowViewService.ShowViewEditorRelatorio(ARelatorio: TRelatorioDTO = nil; APlanilhaBase: TPlanilhaDTO = nil);
var
  LView: TViewEditorRelatorio;
begin
  LView := TViewEditorRelatorio.Create(Application, ARelatorio);
  LView.Show;
end;

procedure TShowViewService.ShowViewEditorTabela(const APlanilhaNome:string ; ATabela: TTabelaDTO; ADataSet: TDataSet); // <- Novo parâmetro
var
  LView: TViewEditorTabela;
begin
  try
    LView := TViewEditorTabela.CreateEditorComDados(APlanilhaNome, ATabela, ADataSet); // <- Novo construtor estático, sem LController
    try
      // Exibir a view
      LView.ShowModal;
    finally
      LView.Free; // Libera a view
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao Criar TViewEditorTabela no ShowViewService: ' + E.Message);
      raise;
    end;
  end;
end;

procedure TShowViewService.ShowViewImprimirRelatorioPronto(ARelatorio: TRelatorioDTO);
var
  LView: TViewImprimirRelatorioPronto;
begin
  LView := TViewImprimirRelatorioPronto.Create(Application, ARelatorio);
  try
    ShowMessage('Criando formulário: ' + LView.Caption);
    LView.Show;
  except
    LView.Free;
    raise;
  end;
end;

procedure TShowViewService.ShowViewLogin(AModal: Boolean = False);
var
  LView: TViewLogin;
begin
  LView := TViewLogin.Create(Application);

  // Conectar os eventos da ViewLogin ao manipulador estático do serviço
  LView.OnLogin := TShowViewService.ManipuladorLogin; // Conecta o evento
  LView.OnCancelarLogin := TShowViewService.ManipuladorCancelarLogin; // Conecta o evento

  LView.ConectarEventosController;

  if AModal then
  begin
    LView.ShowModal;
    // --- DESCOMENTE AS LINHAS ABAIXO ---
    if FTempLoginSucesso then
    begin
      // Abre a tela principal
      ShowViewPrincipalModal(FTempNomeUsuario); // Passa o nome do usuário logado
    end
    else
    begin
      Showmessage('Não deu sucesso!');
    end;
  end
  else
  begin
  end;
end;

procedure TShowViewService.CloseViewPrincipal;
var
  I: Integer;
  LForm: TForm;
begin
  for I := 0 to Application.ComponentCount - 1 do
  begin
    if Application.Components[I] is TViewPrincipal then
    begin
      LForm := TForm(Application.Components[I]);
      LForm.Close;
    end;
  end;
end;

end.
