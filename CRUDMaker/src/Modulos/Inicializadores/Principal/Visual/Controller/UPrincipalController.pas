unit UPrincipalController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  System.IOUtils, Datasnap.DBClient, Data.Db,
  UFuncoesGlobais,
  UTabelaDTO, UPlanilhaDTO, URelatorioDTO,
  UPrincipalService, UPersistenciaLocalService, UPlanilhaService,
  UCSVService;

type
  // --- Tipos de Evento (POObj)
  TNavegarParaCriadorTabelaEvent = procedure of object;
  TNavegarParaEditorTabelaEvent = procedure(const APlanilhaNome, ATabelaNome: string) of object;
  TNavegarParaNovoRelatorioComBaseEvent = procedure(const ATabelaBase: TTabelaDTO) of object;
  TNavegarParaEditorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TNavegarParaVisualizadorRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TOnSolicitarLogoutEvent = procedure of object;
  TOnAbrirSalvarAssociacaoEvent = procedure of object;
  TExcluirPlanilhaEvent = procedure(const APlanilha: string) of object;
  TExcluirTabelaEvent = procedure(const ATabela: string; APlanilha:string) of object;
  TCriarPlanilhaEvent = procedure(const ANomeSugerido: string) of object;
  TListaPlanilhasAtualizadaEvent = procedure(const AListaPlanilhas: TStringList) of object;
  TGradeTabelasAtualizadaEvent = procedure(const AInfoTabelas: TStringList) of object;

  TPrincipalController = class
  private
    FService: TPrincipalService;
    FPersistenciaService: TPersistenciaLocalService;
    FPlanilhaService: TPlanilhaService;
    FCSVService: TCSVService;

    // --- Métodos Manipuladores (renomeados de handlers) ---
    procedure ManipuladorNavegarParaCriadorTabela;
    procedure ManipuladorNavegarParaEditorTabela(const APlanilhaNome, ATabelaNome: string);
    procedure ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
    procedure ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
    procedure ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
    procedure ManipuladorSolicitarLogout;
    procedure ManipuladorAbrirSalvarAssociacao;

    // --- MÉTODOS MANIPULADORES EXISTENTES (renomeados) ---
    procedure ManipuladorExcluirPlanilha(const APlanilha:string);
    procedure ManipuladorExcluirTabela(const ATabela: string; APlanilha:string);
    procedure ManipuladorSolicitarAtualizacaoPlanilha(const APlanilha: TPlanilhaDTO);
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
    ListaPlanilhas: TStringList;
    FOnCriarPlanilha: TCriarPlanilhaEvent;
    FOnExcluirPlanilha: TExcluirPlanilhaEvent;
    FOnExcluirTabela: TExcluirTabelaEvent;
    FOnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent;
    FOnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent;
    FOnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent;
    FOnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent;
    FOnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent;
    FOnSolicitarLogout: TOnSolicitarLogoutEvent;
    FOnAbrirSalvarAssociacao: TOnAbrirSalvarAssociacaoEvent;

    constructor Create(AService: TPrincipalService; APersistenciaService: TPersistenciaLocalService; APlanilhaService: TPlanilhaService);
    destructor Destroy; override;

    // --- Propriedades que ativem ShowViewService ---
    property OnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent read FOnNavegarParaCriadorTabela write FOnNavegarParaCriadorTabela;
    property OnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent read FOnNavegarParaEditorTabela write FOnNavegarParaEditorTabela;
    property OnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent read FOnNavegarParaNovoRelatorioComBase write FOnNavegarParaNovoRelatorioComBase;
    property OnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent read FOnNavegarParaEditorRelatorio write FOnNavegarParaEditorRelatorio;
    property OnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent read FOnNavegarParaVisualizadorRelatorio write FOnNavegarParaVisualizadorRelatorio;
    property OnSolicitarLogout: TOnSolicitarLogoutEvent read FOnSolicitarLogout write FOnSolicitarLogout;
    property OnAbrirSalvarAssociacao: TOnAbrirSalvarAssociacaoEvent read FOnAbrirSalvarAssociacao write FOnAbrirSalvarAssociacao;

    // --- Propriedades que ativem PrincipalService ---
    property OnListaPlanilhasAtualizada: TListaPlanilhasAtualizadaEvent read FOnListaPlanilhasAtualizada write FOnListaPlanilhasAtualizada;
    property OnGradeTabelasAtualizada: TGradeTabelasAtualizadaEvent read FOnGradeTabelasAtualizada write FOnGradeTabelasAtualizada;
    property OnCriarPlanilha: TCriarPlanilhaEvent read FOnCriarPlanilha write FOnCriarPlanilha;
    property OnExcluirPlanilha: TExcluirPlanilhaEvent read FOnExcluirPlanilha write FOnExcluirPlanilha;
    property OnExcluirTabela: TExcluirTabelaEvent read FOnExcluirTabela write FOnExcluirTabela;

    // --- Propriedades para DTOs selecionados ---
    property TabelaSelecionada: TTabelaDTO read FTabelaSelecionada write FTabelaSelecionada;
    property PlanilhaSelecionada: TPlanilhaDTO read FPlanilhaSelecionada write FPlanilhaSelecionada;
    property RelatorioSelecionado: TRelatorioDTO read FRelatorioSelecionado write FRelatorioSelecionado;

    // --- MÉTODOS EXISTENTES ---
    procedure AtualizarListaPlanilhas;
    function ExcluirPlanilha(const ANomePlanilha: string): Boolean;
    function ExcluirTabela(const ANomeTabela: string; ANomePlanilha: string): boolean;
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
  FPlanilhaService := APlanilhaService; // Atribuição do serviço injetado

  // Conectar os manipuladores (métodos) aos eventos (POObj)
  FOnNavegarParaCriadorTabela := ManipuladorNavegarParaCriadorTabela;
  // Conectar o novo manipulador ao evento alterado
  FOnNavegarParaEditorTabela := ManipuladorNavegarParaEditorTabela;
  FOnNavegarParaNovoRelatorioComBase := ManipuladorNavegarParaNovoRelatorioComBase;
  FOnNavegarParaEditorRelatorio := ManipuladorNavegarParaEditorRelatorio;
  FOnNavegarParaVisualizadorRelatorio := ManipuladorNavegarParaVisualizadorRelatorio;
  FOnSolicitarLogout := ManipuladorSolicitarLogout;
  FOnAbrirSalvarAssociacao := ManipuladorAbrirSalvarAssociacao;
  FOnExcluirPlanilha := ManipuladorExcluirPlanilha;
  FOnCriarPlanilha := ManipuladorCriarPlanilha;
  FOnExcluirTabela := ManipuladorExcluirTabela;
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

// --- Implementação dos Manipuladores ---
procedure TPrincipalController.ManipuladorNavegarParaCriadorTabela;
begin
  TShowViewService.Instance.ShowViewCriadorTabela; // Chamada direta ao serviço
end;

procedure TPrincipalController.ManipuladorNavegarParaEditorTabela(const APlanilhaNome, ATabelaNome: string);
var
  CaminhoCSV: string;
  TabelaDTO: TTabelaDTO;
  DataSetCarregado: TClientDataSet;
begin
  CaminhoCSV := FService.ObterCaminhoCSV(APlanilhaNome, ATabelaNome);

  // Criar o DTO e preencher com as informações básicas
  TabelaDTO := TTabelaDTO.Create;
  try
    TabelaDTO.Titulo := ATabelaNome;
    TabelaDTO.CaminhoArquivoCSV := CaminhoCSV;
    // Outros campos do DTO podem ser preenchidos aqui futuramente se necessários

    DataSetCarregado := TClientDataSet.Create(nil); // Criar um DataSet temporário para carregar os dados
    try
      FCSVService.LerCSV(DataSetCarregado, CaminhoCSV); // O serviço lê o CSV e preenche o DataSet

      // Agora, o DataSetCarregado contém os dados do CSV.

      // --- Chamar o TShowViewService para mostrar a View ---
      // Passa o DTO e o DataSet carregado
      TShowViewService.Instance.ShowViewEditorTabela(APlanilhaNome, TabelaDTO, DataSetCarregado);

    except
      on E: Exception do
      begin
        ShowMessage('Erro ao carregar dados CSV para edição: ' + E.Message);
        // Garantir que o DTO e o DataSet temporário sejam liberados em caso de erro
        DataSetCarregado.Free; // Libera o DataSet temporário
        TabelaDTO.Free;        // Libera o DTO temporário
        raise;
      end;
    end;
    DataSetCarregado.Free; // Libera o DataSet temporário após passar para o ShowViewService

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao preparar DTO para edição: ' + E.Message);
      TabelaDTO.Free; // Garante a liberação em caso de erro na inicialização do DTO
      raise; // Relevanta a exceção se necessário
    end;
  end;
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

procedure TPrincipalController.ManipuladorAbrirSalvarAssociacao;
begin
  TShowViewService.Instance.ShowViewSalvarAssociacao; // Chamada direta ao serviço
end;

procedure TPrincipalController.ManipuladorExcluirPlanilha(const APlanilha: string);
begin
    // Log de exclusão
  if ExcluirPlanilha(APlanilha) then
  begin
    ShowMessage('A Planilha: ' + APlanilha + ' foi excluida');
    // Log que excluiu
  end
  else
  begin
    showmessage('Deu algo errado no serviço de excluir planilha');
    // Log de erro
  end;
end;

procedure TPrincipalController.ManipuladorExcluirTabela(const ATabela: string; APlanilha:string);
begin
    // Log de exclusão
  if ExcluirTabela(ATabela, APlanilha) then
  begin
    ShowMessage('A Tabela: ' + ATabela + ' foi excluida');
    // Log que excluiu
  end
  else
  begin
    showmessage('Deu algo errado no serviço de excluir tabela');
    // Log de erro
  end;
end;

procedure TPrincipalController.ManipuladorSolicitarAtualizacaoPlanilha(const APlanilha: TPlanilhaDTO);
begin
  AtualizarListaPlanilhas;
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

function TPrincipalController.ExcluirPlanilha(const ANomePlanilha: string): boolean;
begin
  Result := FService.ExcluirPlanilha(ANomePlanilha);
end;

function TPrincipalController.ExcluirTabela(const ANomeTabela: string; ANomePlanilha: string): boolean;
begin
  Result := FService.ExcluirTabela(ANomeTabela,ANomePlanilha);
end;

procedure TPrincipalController.AtualizarGradeTabelasInterna(const ANomePlanilha: string);
begin
  ListaInfoTabelas := FService.ObterInfoTabelasDaPlanilha(ANomePlanilha);
end;

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
