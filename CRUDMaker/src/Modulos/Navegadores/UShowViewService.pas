unit UShowViewService;

interface

uses
  System.SysUtils, System.Classes, System.UITypes, System.variants,
  Vcl.Forms, VCL.Dialogs,
  Data.Db,
  UCriadorTabelaController, UPrincipalController,
  UTabelaConfiguracaoDTO, UTabelaDTO, UPlanilhaDTO,
  URelatorioDTO,
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
  UViewConfigurarTabela, UViewCriadorTabelaDados;
{ TShowViewService }
var
  GViewSelecionar: TViewSelecionarPlanilhaParaTabela;
  GViewConfigurar: TViewConfigurarTabela;
  GViewCriadorDados: TViewCriadorTabelaDados;

class procedure TShowViewService.ManipuladorSolicitarLogout;
begin
end;

class procedure TShowViewService.ManipuladorNavegarParaCriadorTabela;
begin
  Instance.ShowViewCriadorTabela;
end;

class procedure TShowViewService.ManipuladorNavegarParaNovoRelatorioComBase(const ATabelaBase: TTabelaDTO);
begin
  ShowMessage('Navegação para Novo Relatório com Base solicitada (DTO: ' + ATabelaBase.Titulo + ').');
end;

class procedure TShowViewService.ManipuladorNavegarParaEditorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  Instance.ShowViewEditorRelatorio(ARelatorio);
end;

class procedure TShowViewService.ManipuladorNavegarParaVisualizadorRelatorio(const ARelatorio: TRelatorioDTO);
begin
  ShowMessage('Navegação para Visualizador de Relatório solicitada (DTO: ' + ARelatorio.Titulo + ').');
end;

class procedure TShowViewService.ManipuladorAbrirSalvarAssociacao;
begin
  Instance.ShowViewSalvarAssociacao;
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
  GViewSelecionar := TViewSelecionarPlanilhaParaTabela.Create(Application);
  GViewSelecionar.OnAvancar := AuxFluxoCriarTabela_Selecionar_Avancar;
  GViewSelecionar.OnCancelar := AuxFluxoCriarTabela_Selecionar_Cancelar;
  GViewSelecionar.ShowModal;
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Selecionar_Avancar(Sender: TObject);
begin
  if Sender is TViewSelecionarPlanilhaParaTabela then
  begin
    try
      GViewSelecionar := TViewSelecionarPlanilhaParaTabela(Sender);
      GViewConfigurar := TViewConfigurarTabela.Create(Application, GViewSelecionar.PlanilhaSelecionada);
        GViewConfigurar.OnAvancar := AuxFluxoCriarTabela_Configurar_Avancar;
        GViewConfigurar.OnVoltar := AuxFluxoCriarTabela_Configurar_Voltar;
        GViewConfigurar.OnCancelar := AuxFluxoCriarTabela_Configurar_Cancelar;
        GViewConfigurar.ShowModal;
    finally
    end;
  end;
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Selecionar_Cancelar(Sender: TObject);
begin
  if Sender is TViewSelecionarPlanilhaParaTabela then
  begin
     TViewSelecionarPlanilhaParaTabela(Sender).Close;
  end;
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Configurar_Avancar(AConfiguracao: UTabelaConfiguracaoDTO.TConfiguracaoTabelaDTO);
begin
  GViewCriadorDados := TViewCriadorTabelaDados.Create(Application, AConfiguracao);
  try
    GViewCriadorDados.OnClose := AuxFluxoCriarTabela_Dados_Fechar;
    GViewCriadorDados.ShowModal;
  finally
  end;
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Configurar_Cancelar(Sender: TObject);
begin
  if Sender is TViewConfigurarTabela then
  begin
     TViewConfigurarTabela(Sender).Close;
  end;
end;

class procedure TShowViewService.AuxFluxoCriarTabela_Configurar_Voltar(Sender: TObject);
begin
  if Sender is TViewConfigurarTabela then
  begin
    GViewConfigurar := TViewConfigurarTabela(Sender);
    GViewSelecionar := TViewSelecionarPlanilhaParaTabela.Create(Application);
    try
      GViewSelecionar.OnAvancar := AuxFluxoCriarTabela_Selecionar_Avancar;
      GViewSelecionar.OnCancelar := AuxFluxoCriarTabela_Selecionar_Cancelar;
      GViewSelecionar.ShowModal;
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

  LPlanilhaService := TPlanilhaService.Create(nil {DAO}, nil {XMLService}, nil {CSVService});
  LPrincipalController := TPrincipalController.Create(TPrincipalService.Create, TPersistenciaLocalService.Create, LPlanilhaService);;
  LView.FController := LPrincipalController;

  LPrincipalController.OnNavegarParaCriadorTabela := Self.ManipuladorNavegarParaCriadorTabela;
  LPrincipalController.OnSolicitarLogout := Self.ManipuladorSolicitarLogout;
  LPrincipalController.OnAbrirSalvarAssociacao := Self.ManipuladorAbrirSalvarAssociacao;
  
  try
    LView.DefinirNomeUsuario(AUsuarioNome);
    LView.ShowModal;
  finally
    LPrincipalController.Free;
    LPlanilhaService.Free;
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

procedure TShowViewService.ShowViewEditorTabela(const APlanilhaNome:string ; ATabela: TTabelaDTO; ADataSet: TDataSet);
var
  LView: TViewEditorTabela;
begin
  try
    LView := TViewEditorTabela.CreateEditorComDados(APlanilhaNome, ATabela, ADataSet);
    try
      LView.ShowModal;
    finally
      LView.Free;
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

  LView.OnLogin := TShowViewService.ManipuladorLogin;
  LView.OnCancelarLogin := TShowViewService.ManipuladorCancelarLogin;

  LView.ConectarEventosController;

  if AModal then
  begin
    LView.ShowModal;
    if FTempLoginSucesso then
    begin
      ShowViewPrincipalModal(FTempNomeUsuario);
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
