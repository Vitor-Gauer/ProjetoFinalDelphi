unit UPrincipalController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  System.IOUtils,
  UFuncoesGlobais,
  UTabelaDTO, UPlanilhaDTO, URelatorioDTO,
  UInfoTabelaPlanilhaDTO,
  UPrincipalService, UPersistenciaLocalService, UPlanilhaService;

type
  // --- Tipos de Evento (POObj)
  TNavegarParaCriadorTabelaEvent = procedure of object;
  TNavegarParaEditorTabelaEvent = procedure(const ATabela: TTabelaDTO) of object;
  TNavegarParaNovoRelatorioComBaseEvent = procedure(const ATabelaBase: TTabelaDTO) of object;
  TNavegarParaEditorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TNavegarParaVisualizadorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TOnSolicitarLogoutEvent = procedure of object;
  TOnAbrirSalvarAssociacaoEvent = procedure of object;
  TExcluirPlanilhaEvent = procedure(const APlanilha: TPlanilhaDTO) of object;
  TCriarPlanilhaEvent = procedure(const ANomeSugerido: string) of object;
  TSolicitarAtualizacaoPlanilha = procedure(const APlanilha: TPlanilhaDTO) of object;
  TListaPlanilhasAtualizadaEvent = procedure(const AListaPlanilhas: TStringList) of object;
  TGradeTabelasAtualizadaEvent = procedure(const AInfoTabelas: TStringList) of object;

  TPrincipalController = class
  private
    FService: TPrincipalService;
    FPersistenciaService: TPersistenciaLocalService;
    FPlanilhaService: TPlanilhaService;

    // --- Métodos Manipuladores (renomeados de handlers) ---
    procedure ManipuladorNavegarParaCriadorTabela;
    procedure ManipuladorNavegarParaEditorTabela(const ATabela: TTabelaDTO);
    procedure ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
    procedure ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
    procedure ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
    procedure ManipuladorSolicitarLogout;
    // procedure ManipuladorAbrirGerenciador; // REMOVIDO
    procedure ManipuladorAbrirSalvarAssociacao;

    // --- MÉTODOS MANIPULADORES EXISTENTES (renomeados) ---
    procedure ManipuladorExcluirPlanilha(const APlanilha: TPlanilhaDTO);
    procedure ManipuladorSolicitarAtualizacaoPlanilha(const APlanilha: TPlanilhaDTO);
    procedure ManipuladorListaPlanilhasAtualizada(const AListaPlanilhas: TStringList);
    procedure ManipuladorGradeTabelasAtualizada(const AInfoTabelas: TObjectList<TInfoTabelaPlanilhaDTO>);
    // --- ALTERAR ESTE MÉTODO ---
    procedure ManipuladorCriarPlanilha(const ANomeSugerido: string); // Este manipulador já existia, mas foi renomeado

  public
    // --- Campos para DTOs selecionados ---
    FTabelaSelecionada: TTabelaDTO;
    FPlanilhaSelecionada: TPlanilhaDTO;
    FRelatorioSelecionado: TRelatorioDTO;
    // --- POObj (Propriedades de Objetos de Eventos) ---
    FOnListaPlanilhasAtualizada: TListaPlanilhasAtualizadaEvent;
    FOnGradeTabelasAtualizada: TGradeTabelasAtualizadaEvent;
    ListaInfoTabelas: TStringList;
    FOnSolicitarAtualizacaoPlanilha: TSolicitarAtualizacaoPlanilha;
    ListaPlanilhas: TStringList;
    FOnCriarPlanilha: TCriarPlanilhaEvent;
    FOnExcluirPlanilha: TExcluirPlanilhaEvent;
    FOnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent;
    FOnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent;
    FOnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent;
    FOnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent;
    FOnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent;
    FOnSolicitarLogout: TOnSolicitarLogoutEvent;
    FOnAbrirSalvarAssociacao: TOnAbrirSalvarAssociacaoEvent;


    // --- Propriedades Públicas para os POObj ---
    property OnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent read FOnNavegarParaCriadorTabela write FOnNavegarParaCriadorTabela;
    property OnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent read FOnNavegarParaEditorTabela write FOnNavegarParaEditorTabela;
    property OnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent read FOnNavegarParaNovoRelatorioComBase write FOnNavegarParaNovoRelatorioComBase;
    property OnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent read FOnNavegarParaEditorRelatorio write FOnNavegarParaEditorRelatorio;
    property OnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent read FOnNavegarParaVisualizadorRelatorio write FOnNavegarParaVisualizadorRelatorio;
    property OnSolicitarLogout: TOnSolicitarLogoutEvent read FOnSolicitarLogout write FOnSolicitarLogout;
    property OnAbrirSalvarAssociacao: TOnAbrirSalvarAssociacaoEvent read FOnAbrirSalvarAssociacao write FOnAbrirSalvarAssociacao;

    // --- PROPRIEDADES EXISTENTES ---
    property OnListaPlanilhasAtualizada: TListaPlanilhasAtualizadaEvent read FOnListaPlanilhasAtualizada write FOnListaPlanilhasAtualizada;
    property OnGradeTabelasAtualizada: TGradeTabelasAtualizadaEvent read FOnGradeTabelasAtualizada write FOnGradeTabelasAtualizada;
    property OnSolicitarAtualizacaoPlanilha: TSolicitarAtualizacaoPlanilha read FOnSolicitarAtualizacaoPlanilha write FOnSolicitarAtualizacaoPlanilha;
    property OnCriarPlanilha: TCriarPlanilhaEvent read FOnCriarPlanilha write FOnCriarPlanilha;
    property OnExcluirPlanilha: TExcluirPlanilhaEvent read FOnExcluirPlanilha write FOnExcluirPlanilha;

    // --- Propriedades para DTOs selecionados ---
    property TabelaSelecionada: TTabelaDTO read FTabelaSelecionada write FTabelaSelecionada;
    property PlanilhaSelecionada: TPlanilhaDTO read FPlanilhaSelecionada write FPlanilhaSelecionada;
    property RelatorioSelecionado: TRelatorioDTO read FRelatorioSelecionado write FRelatorioSelecionado;

    constructor Create(AService: TPrincipalService; APersistenciaService: TPersistenciaLocalService; APlanilhaService: TPlanilhaService); // Alterar construtor
    destructor Destroy; override;

    // --- MÉTODOS EXISTENTES ---
    procedure AtualizarListaPlanilhas;
    procedure PopularListaPlanilhasNaView;
    procedure PopularGradeTabelasNaView(const ANomePlanilha: string);
    procedure AtualizarListaPlanilhasInterna;
    procedure AtualizarGradeTabelasInterna(const ANomePlanilha: string);
    procedure HandleCriarPlanilha(const ANomeSugerido: string);
    function ValidarNomePlanilha(const ANome: string): Boolean;
  end;

implementation
uses
UShowViewService;
{ TPrincipalController }

// --- Implementação dos Manipuladores ---
procedure TPrincipalController.ManipuladorNavegarParaCriadorTabela;
begin
  TShowViewService.Instance.ShowViewCriadorTabela; // Chamada direta ao serviço
end;

procedure TPrincipalController.ManipuladorNavegarParaEditorTabela(const ATabela: TTabelaDTO);
begin
  TShowViewService.Instance.ShowViewEditorTabela(ATabela); // Chamada direta ao serviço, passando DTO
end;

procedure TPrincipalController.ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
begin
  // Chamada direta ao serviço, passando DTO
  TShowViewService.ManipuladorNavegarParaNovoRelatorioComBase(ATabelaBase); // Pode chamar manipulador estático ou outro método do serviço
end;

procedure TPrincipalController.ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  TShowViewService.Instance.ShowViewEditorRelatorio(ARelatorio); // Chamada direta ao serviço, passando DTO
end;

procedure TPrincipalController.ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  // Chamada direta ao serviço, passando DTO
  TShowViewService.ManipuladorNavegarParaVisualizadorRelatorio(ARelatorio); // Pode chamar manipulador estático ou outro método do serviço
end;

procedure TPrincipalController.ManipuladorSolicitarLogout;
begin
  // Chamada direta ao serviço de navegação para logout
  TShowViewService.ManipuladorSolicitarLogout; // Chama o manipulador estático que encapsula a lógica de logout e navegação
end;

// procedure TPrincipalController.ManipuladorAbrirGerenciador; // REMOVIDO
// begin
//   // Chamada direta ao serviço
//   TShowViewService.ManipuladorAbrirGerenciador; // Chama o manipulador estático
// end;

procedure TPrincipalController.ManipuladorAbrirSalvarAssociacao;
begin
  TShowViewService.Instance.ShowViewSalvarAssociacao; // Chamada direta ao serviço
end;

// --- MÉTODOS MANIPULADORES EXISTENTES ---
procedure TPrincipalController.ManipuladorExcluirPlanilha(const APlanilha: TPlanilhaDTO);
begin
  // TODO: Implementar lógica de exclusão via serviço
  ShowMessage('Exclusão de planilha "' + APlanilha.Titulo + '" solicitada via manipulador.');
end;

procedure TPrincipalController.ManipuladorSolicitarAtualizacaoPlanilha(const APlanilha: TPlanilhaDTO);
begin
  AtualizarListaPlanilhas;
end;

procedure TPrincipalController.ManipuladorListaPlanilhasAtualizada(const AListaPlanilhas: TStringList);
begin
  (*
    Este manipulador provavelmente vai ser usado futuramente. A View se conecta diretamente a FOnListaPlanilhasAtualizada
    e executa a lógica de atualização da lista (ex: ListBox.Items.Assign(AListaPlanilhas))
  *)
end;

procedure TPrincipalController.ManipuladorGradeTabelasAtualizada(const AInfoTabelas: TObjectList<TInfoTabelaPlanilhaDTO>);
begin
  (*
    Este manipulador provavelmente vai ser usado futuramente. A View se conecta diretamente a FOnGradeTabelasAtualizada por agora
    e executa a lógica de atualização da grade (ex: preencher uma StringGrid ou DBGrid)
  *)
end;

procedure TPrincipalController.ManipuladorCriarPlanilha(const ANomeSugerido: string);
begin
  if Assigned(FPlanilhaService) then
  begin
    // A chamada ao serviço encapsula a lógica e a mensagem de sucesso/erro
    FPlanilhaService.CriarNovaPlanilha(ANomeSugerido);
    // Após criar, atualizar a lista de planilhas para refletir a nova planilha
    AtualizarListaPlanilhas;
  end
  else
  begin
    ShowMessage('Erro: Serviço de Planilha não está disponível.');
  end;
end;

constructor TPrincipalController.Create(AService: TPrincipalService; APersistenciaService: TPersistenciaLocalService; APlanilhaService: TPlanilhaService);
begin
  inherited Create;
  if not Assigned(AService) then
    raise Exception.Create('TPrincipalService não pode ser nulo.');
  if not Assigned(APersistenciaService) then
    raise Exception.Create('TPersistenciaLocalService não pode ser nulo.');
  if not Assigned(APlanilhaService) then
    raise Exception.Create('TPlanilhaService não pode ser nulo.'); // Nova validação

  FService := AService;
  FPersistenciaService := APersistenciaService;
  FPlanilhaService := APlanilhaService;

  // Conectar os manipuladores (métodos) aos eventos (POObj)
  FOnNavegarParaCriadorTabela := ManipuladorNavegarParaCriadorTabela;
  FOnNavegarParaEditorTabela := ManipuladorNavegarParaEditorTabela;
  FOnNavegarParaNovoRelatorioComBase := ManipuladorNavegarParaNovoRelatorioComBase;
  FOnNavegarParaEditorRelatorio := ManipuladorNavegarParaEditorRelatorio;
  FOnNavegarParaVisualizadorRelatorio := ManipuladorNavegarParaVisualizadorRelatorio;
  FOnSolicitarLogout := ManipuladorSolicitarLogout;
  FOnAbrirSalvarAssociacao := ManipuladorAbrirSalvarAssociacao;

  // Conectar manipuladores para eventos existentes
  FOnCriarPlanilha := ManipuladorCriarPlanilha; // Conectar o manipulador ao evento
  // FOnExcluirPlanilha := ManipuladorExcluirPlanilha; // Exemplo - Conectar quando necessário
  // FOnSolicitarAtualizacaoPlanilha := ManipuladorSolicitarAtualizacaoPlanilha; // Exemplo - Conectar quando necessário
  // FOnListaPlanilhasAtualizada := ManipuladorListaPlanilhasAtualizada; // Exemplo - A View conecta diretamente
  // FOnGradeTabelasAtualizada := ManipuladorGradeTabelasAtualizada; // Exemplo - A View conecta diretamente
end;

destructor TPrincipalController.Destroy;
begin
  // Liberar DTOs se necessário (geralmente não são liberados aqui, a menos que sejam criados internamente)
  // FTabelaSelecionada.Free; // Exemplo, depende da origem do DTO
  // FPlanilhaSelecionada.Free;
  // FRelatorioSelecionado.Free;
  // Os serviços injetados não são liberados aqui (FService, FPersistenciaService, FPlanilhaService)
  inherited;
end;

// Método chamado pela View
procedure TPrincipalController.AtualizarListaPlanilhas;
begin
  AtualizarListaPlanilhasInterna;
end;

// Método chamado pela View na inicialização (pode ser o mesmo que AtualizarListaPlanilhas)
procedure TPrincipalController.PopularListaPlanilhasNaView;
begin
  // Este método também delega a atualização interna
  AtualizarListaPlanilhasInterna;
end;

procedure TPrincipalController.AtualizarListaPlanilhasInterna;
begin
  ListaPlanilhas := FService.ObterListaPlanilhas;
end;

procedure TPrincipalController.PopularGradeTabelasNaView(const ANomePlanilha: string);
begin
  AtualizarGradeTabelasInterna(ANomePlanilha);
end;

procedure TPrincipalController.AtualizarGradeTabelasInterna(const ANomePlanilha: string);
begin
  ListaInfoTabelas := FService.ObterInfoTabelasDaPlanilha(ANomePlanilha);
end;

//function TPrincipalController.ExcluirPlanilha(const ANomePlanilha: string): Boolean;
//begin
//  // Implementação para excluir planilha via serviço
//  // ...
//  Result := False; // Placeholder
//end;

function TPrincipalController.ValidarNomePlanilha(const ANome: string): Boolean;
begin
  Result := FPersistenciaService.ValidarNomeGenerico(ANome);
end;

procedure TPrincipalController.HandleCriarPlanilha(const ANomeSugerido: string);
begin
  if assigned(FOnCriarPlanilha) then
  ManipuladorCriarPlanilha(ANomeSugerido)
  else
  Showmessage('Passou, mas nao passou');
end;

end.
