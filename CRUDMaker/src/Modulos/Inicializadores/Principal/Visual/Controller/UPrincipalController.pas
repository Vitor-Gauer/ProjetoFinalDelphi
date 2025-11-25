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

    procedure ManipuladorNavegarParaCriadorTabela;
    procedure ManipuladorNavegarParaEditorTabela(const APlanilhaNome, ATabelaNome: string);
    procedure ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
    procedure ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
    procedure ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
    procedure ManipuladorSolicitarLogout;
    procedure ManipuladorAbrirSalvarAssociacao;
    procedure ManipuladorExcluirPlanilha(const APlanilha:string);
    procedure ManipuladorExcluirTabela(const ATabela: string; APlanilha:string);
    procedure ManipuladorSolicitarAtualizacaoPlanilha(const APlanilha: TPlanilhaDTO);
    procedure ManipuladorCriarPlanilha(const ANomeSugerido: string);

  public
    FTabelaSelecionada: TTabelaDTO;
    FPlanilhaSelecionada: TPlanilhaDTO;
    FRelatorioSelecionado: TRelatorioDTO;
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

    property OnNavegarParaCriadorTabela: TNavegarParaCriadorTabelaEvent read FOnNavegarParaCriadorTabela write FOnNavegarParaCriadorTabela;
    property OnNavegarParaEditorTabela: TNavegarParaEditorTabelaEvent read FOnNavegarParaEditorTabela write FOnNavegarParaEditorTabela;
    property OnNavegarParaNovoRelatorioComBase: TNavegarParaNovoRelatorioComBaseEvent read FOnNavegarParaNovoRelatorioComBase write FOnNavegarParaNovoRelatorioComBase;
    property OnNavegarParaEditorRelatorio: TNavegarParaEditorRelatorioEvent read FOnNavegarParaEditorRelatorio write FOnNavegarParaEditorRelatorio;
    property OnNavegarParaVisualizadorRelatorio: TNavegarParaVisualizadorRelatorioEvent read FOnNavegarParaVisualizadorRelatorio write FOnNavegarParaVisualizadorRelatorio;
    property OnSolicitarLogout: TOnSolicitarLogoutEvent read FOnSolicitarLogout write FOnSolicitarLogout;
    property OnAbrirSalvarAssociacao: TOnAbrirSalvarAssociacaoEvent read FOnAbrirSalvarAssociacao write FOnAbrirSalvarAssociacao;

    property OnListaPlanilhasAtualizada: TListaPlanilhasAtualizadaEvent read FOnListaPlanilhasAtualizada write FOnListaPlanilhasAtualizada;
    property OnGradeTabelasAtualizada: TGradeTabelasAtualizadaEvent read FOnGradeTabelasAtualizada write FOnGradeTabelasAtualizada;
    property OnCriarPlanilha: TCriarPlanilhaEvent read FOnCriarPlanilha write FOnCriarPlanilha;
    property OnExcluirPlanilha: TExcluirPlanilhaEvent read FOnExcluirPlanilha write FOnExcluirPlanilha;
    property OnExcluirTabela: TExcluirTabelaEvent read FOnExcluirTabela write FOnExcluirTabela;

    property TabelaSelecionada: TTabelaDTO read FTabelaSelecionada write FTabelaSelecionada;
    property PlanilhaSelecionada: TPlanilhaDTO read FPlanilhaSelecionada write FPlanilhaSelecionada;
    property RelatorioSelecionado: TRelatorioDTO read FRelatorioSelecionado write FRelatorioSelecionado;

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
    raise Exception.Create('TPlanilhaService não pode ser nulo.');

  FService := AService;
  FPersistenciaService := APersistenciaService;
  FPlanilhaService := APlanilhaService;

  FOnNavegarParaCriadorTabela := ManipuladorNavegarParaCriadorTabela;
  FOnNavegarParaEditorTabela := ManipuladorNavegarParaEditorTabela;
  FOnNavegarParaNovoRelatorioComBase := ManipuladorNavegarParaNovoRelatorioComBase;
  FOnNavegarParaEditorRelatorio := ManipuladorNavegarParaEditorRelatorio;
  FOnNavegarParaVisualizadorRelatorio := ManipuladorNavegarParaVisualizadorRelatorio;
  FOnSolicitarLogout := ManipuladorSolicitarLogout;
  FOnAbrirSalvarAssociacao := ManipuladorAbrirSalvarAssociacao;
  FOnExcluirPlanilha := ManipuladorExcluirPlanilha;
  FOnCriarPlanilha := ManipuladorCriarPlanilha;
  FOnExcluirTabela := ManipuladorExcluirTabela;
  end;

destructor TPrincipalController.Destroy;
begin
  inherited;
end;

// --- Implementação dos Manipuladores ---

procedure TPrincipalController.ManipuladorNavegarParaCriadorTabela;
begin
  TShowViewService.Instance.ShowViewCriadorTabela;
end;

procedure TPrincipalController.ManipuladorNavegarParaEditorTabela(const APlanilhaNome, ATabelaNome: string);
var
  CaminhoCSV: string;
  TabelaDTO: TTabelaDTO;
  DataSetCarregado: TClientDataSet;
begin
  CaminhoCSV := FService.ObterCaminhoCSV(APlanilhaNome, ATabelaNome);

  TabelaDTO := TTabelaDTO.Create;
  try
    TabelaDTO.Titulo := ATabelaNome;
    TabelaDTO.CaminhoArquivoCSV := CaminhoCSV;

    DataSetCarregado := TClientDataSet.Create(nil);
    try
      FCSVService.LerCSV(DataSetCarregado, CaminhoCSV);
      TShowViewService.Instance.ShowViewEditorTabela(APlanilhaNome, TabelaDTO, DataSetCarregado);

    except
      on E: Exception do
      begin
        ShowMessage('Erro ao carregar dados CSV para edição: ' + E.Message);
        DataSetCarregado.Free;
        TabelaDTO.Free;
        raise;
      end;
    end;
    DataSetCarregado.Free;

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao preparar DTO para edição: ' + E.Message);
      TabelaDTO.Free;
      raise;
    end;
  end;
end;

procedure TPrincipalController.ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
begin
  TShowViewService.ManipuladorNavegarParaNovoRelatorioComBase(ATabelaBase);
end;

procedure TPrincipalController.ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  TShowViewService.Instance.ShowViewEditorRelatorio(ARelatorio);
end;

procedure TPrincipalController.ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  TShowViewService.ManipuladorNavegarParaVisualizadorRelatorio(ARelatorio);
end;

procedure TPrincipalController.ManipuladorSolicitarLogout;
begin
  TShowViewService.ManipuladorSolicitarLogout;
end;

procedure TPrincipalController.ManipuladorAbrirSalvarAssociacao;
begin
  TShowViewService.Instance.ShowViewSalvarAssociacao;
end;

procedure TPrincipalController.ManipuladorExcluirPlanilha(const APlanilha: string);
begin
  if ExcluirPlanilha(APlanilha) then
  begin
    ShowMessage('A Planilha: ' + APlanilha + ' foi excluida');
  end
  else
  begin
    showmessage('Deu algo errado no serviço de excluir planilha');
  end;
end;

procedure TPrincipalController.ManipuladorExcluirTabela(const ATabela: string; APlanilha:string);
begin
  if ExcluirTabela(ATabela, APlanilha) then
  begin
    ShowMessage('A Tabela: ' + ATabela + ' foi excluida');
  end
  else
  begin
    showmessage('Deu algo errado no serviço de excluir tabela');
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
    FPlanilhaService.CriarNovaPlanilha(ANomeSugerido);
    AtualizarListaPlanilhas;
  end
  else
  begin
    ShowMessage('Erro: Serviço de Planilha não está disponível.');
  end;
end;

procedure TPrincipalController.AtualizarListaPlanilhas;
begin
  AtualizarListaPlanilhasInterna;
end;

procedure TPrincipalController.PopularListaPlanilhasNaView;
begin
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
