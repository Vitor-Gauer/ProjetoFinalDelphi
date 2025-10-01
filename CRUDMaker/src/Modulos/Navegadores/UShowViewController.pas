unit UShowViewController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, Vcl.Controls,
  UTabelaDTO, UPlanilhaDTO, URelatorioDTO, UTabelaConfiguracaoDTO;

type
  TViewController = class
  private
    class var FInstance: TViewController;
    class function GetInstance: TViewController; static;
    class var FTempLoginSucesso: Boolean;
    class var FTempNomeUsuario: string;
    class procedure AuxFluxoCriarTabela_Configurar_Avancar(AConfiguracao: UTabelaConfiguracaoDTO.TConfiguracaoTabelaDTO);
    class procedure AuxFluxoCriarTabela_Configurar_Cancelar(Sender: TObject);
    class procedure AuxFluxoCriarTabela_Configurar_Voltar(Sender: TObject);
    class procedure AuxFluxoCriarTabela_Dados_Fechar(Sender: TObject; var Action: TCloseAction);
    class procedure AuxFluxoCriarTabela_Iniciar;
    class procedure AuxFluxoCriarTabela_Selecionar_Avancar(Sender: TObject);
    class procedure AuxFluxoCriarTabela_Selecionar_Cancelar(Sender: TObject);
    class procedure TempOnCancelarLoginHandler;
    class procedure TempOnLoginHandler(const AUsuario, ASenha: string; AModoPublico: Boolean);
    class procedure TempOnNavegarParaCriadorTabelaHandler;
    class procedure TempOnCriarPlanilhaHandler(const ANomeSugerido: string);
  public
    class property Instance: TViewController read GetInstance;
    procedure CloseViewPrincipal;
    class procedure FreeInstance;
    procedure IniciarAplicacao;
    procedure ShowViewSalvarAssociacao;
    procedure ShowViewEditorRelatorio(ARelatorio: TRelatorioDTO = nil; APlanilhaBase: TPlanilhaDTO = nil);
    procedure ShowViewEditorTabela(ATabela: TTabelaDTO = nil);
    procedure ShowViewLogin(AModal: Boolean = False);
    function ShowViewModalTermos: Boolean;
    procedure ShowViewPrincipal(AUsuarioNome: string);
    procedure ShowViewPrincipalModal(AUsuarioNome: string);
    class procedure ShowViewCriadorTabela;
    procedure ShowViewImprimirRelatorioPronto(ARelatorio: TRelatorioDTO);
    procedure HandleCriarPlanilha(const ANomePlanilha: string);
  end;

implementation

uses
  UViewLogin, UViewModalTermos, UViewPrincipal, UViewEditorTabela,
  UViewEditorRelatorio, UViewImprimirRelatorioPronto,
  UViewSalvarAssociacao, System.UITypes, UViewSelecionarPlanilhaParaTabela,
  UViewConfigurarTabela, UViewCriadorTabelaDados, UCriadorTabelaController,
  System.IOUtils; // System.IOUtils para manipulação de diretórios

{ TViewController }

// --- Implementação dos métodos existentes permanecem os mesmos ---
// (AuxFluxoCriarTabela_*, TempOn*, FreeInstance, GetInstance, etc.)

class procedure TViewController.AuxFluxoCriarTabela_Configurar_Avancar(AConfiguracao: UTabelaConfiguracaoDTO.TConfiguracaoTabelaDTO);
var
  ViewCriadorDados: TViewCriadorTabelaDados;
begin
  ViewCriadorDados := TViewCriadorTabelaDados.Create(Application, AConfiguracao);
  try
    ViewCriadorDados.OnClose := AuxFluxoCriarTabela_Dados_Fechar;
    ViewCriadorDados.ShowModal;
  finally
    ViewCriadorDados.Free;
  end;
end;

class procedure TViewController.AuxFluxoCriarTabela_Configurar_Cancelar(Sender: TObject);
begin
  if Sender is TViewConfigurarTabela then
  begin
     TViewConfigurarTabela(Sender).Close;
  end;
end;

class procedure TViewController.AuxFluxoCriarTabela_Configurar_Voltar(Sender: TObject);
var
  ViewConfigurar: TViewConfigurarTabela;
  ViewSelecionar: TViewSelecionarPlanilhaParaTabela;
begin
  if Sender is TViewConfigurarTabela then
  begin
    ViewConfigurar := TViewConfigurarTabela(Sender);
    ViewSelecionar := TViewSelecionarPlanilhaParaTabela.Create(Application);
    try
      ViewSelecionar.OnAvancar := AuxFluxoCriarTabela_Selecionar_Avancar;
      ViewSelecionar.OnCancelar := AuxFluxoCriarTabela_Selecionar_Cancelar;

      ViewConfigurar.Close;
      ViewSelecionar.ShowModal;
    finally
      ViewSelecionar.Free;
    end;
  end;
end;

class procedure TViewController.AuxFluxoCriarTabela_Dados_Fechar(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

class procedure TViewController.AuxFluxoCriarTabela_Iniciar;
var
  ViewSelecionar: TViewSelecionarPlanilhaParaTabela;
begin
  ViewSelecionar := TViewSelecionarPlanilhaParaTabela.Create(Application);
  try
    ViewSelecionar.OnAvancar := AuxFluxoCriarTabela_Selecionar_Avancar;
    ViewSelecionar.OnCancelar := AuxFluxoCriarTabela_Selecionar_Cancelar;
    ViewSelecionar.ShowModal;
  finally
    ViewSelecionar.Free;
  end;
end;

class procedure TViewController.AuxFluxoCriarTabela_Selecionar_Avancar(Sender: TObject);
var
  ViewSelecionar: TViewSelecionarPlanilhaParaTabela;
  ViewConfigurar: TViewConfigurarTabela;
begin
  if Sender is TViewSelecionarPlanilhaParaTabela then
  begin
    ViewSelecionar := TViewSelecionarPlanilhaParaTabela(Sender);
    ViewConfigurar := TViewConfigurarTabela.Create(Application, ViewSelecionar.PlanilhaSelecionada);
    try
      ViewConfigurar.OnAvancar := AuxFluxoCriarTabela_Configurar_Avancar;
      ViewConfigurar.OnVoltar := AuxFluxoCriarTabela_Configurar_Voltar;
      ViewConfigurar.OnCancelar := AuxFluxoCriarTabela_Configurar_Cancelar;

      ViewSelecionar.Close;
      ViewConfigurar.ShowModal;
    finally
      ViewConfigurar.Free;
    end;
  end;
end;

class procedure TViewController.AuxFluxoCriarTabela_Selecionar_Cancelar(Sender: TObject);
begin
  if Sender is TViewSelecionarPlanilhaParaTabela then
  begin
     TViewSelecionarPlanilhaParaTabela(Sender).Close;
  end;
end;

procedure TViewController.CloseViewPrincipal;
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

class procedure TViewController.FreeInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

class function TViewController.GetInstance: TViewController;
begin
  if not Assigned(FInstance) then
    FInstance := TViewController.Create;
  Result := FInstance;
end;

procedure TViewController.IniciarAplicacao;
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

procedure TViewController.ShowViewSalvarAssociacao;
var
  LView: TViewSalvarAssociacao;
begin
  LView := TViewSalvarAssociacao.Create(Application);
  LView.Show;
end;

procedure TViewController.ShowViewEditorRelatorio(ARelatorio: TRelatorioDTO; APlanilhaBase: TPlanilhaDTO);
var
  LView: TViewEditorRelatorio;
begin
  LView := TViewEditorRelatorio.Create(Application, ARelatorio);
  LView.Show;
end;

procedure TViewController.ShowViewEditorTabela(ATabela: TTabelaDTO);
var
  LView: TViewEditorTabela;
begin
  LView := TViewEditorTabela.Create(Application, ATabela);
  LView.Show;
end;

procedure TViewController.ShowViewLogin(AModal: Boolean);
var
  LView: TViewLogin;
begin
  LView := TViewLogin.Create(nil);
  try
    FTempLoginSucesso := False;
    FTempNomeUsuario := 'Anônimo';
    LView.OnLogin := TempOnLoginHandler;
    LView.OnCancelarLogin := TempOnCancelarLoginHandler;
    if AModal then
    begin
      LView.ShowModal;
      if FTempLoginSucesso then
      begin
        Self.ShowViewPrincipalModal(FTempNomeUsuario);
      end
      else
      begin
        Exit;
      end;
    end
    else
    begin
      LView.OnLogin := TempOnLoginHandler;
      LView.OnCancelarLogin := TempOnCancelarLoginHandler;
      LView.Show;
      Exit;
    end;
  finally
    if AModal then
      LView.Free;
  end;
end;

function TViewController.ShowViewModalTermos: Boolean;
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

procedure TViewController.ShowViewPrincipal(AUsuarioNome: string);
var
  LView: TViewPrincipal;
begin
  LView := TViewPrincipal.Create(Application);
  LView.DefinirNomeUsuario(AUsuarioNome);
  // --- CONECTA O NOVO EVENTO DE CRIAR PLANILHA ---
  LView.OnCriarPlanilha := TempOnCriarPlanilhaHandler;
  // Conecta outros eventos existentes...
  LView.OnNavegarParaCriadorTabela := TempOnNavegarParaCriadorTabelaHandler;
  // ...
  LView.Show;
end;

procedure TViewController.ShowViewPrincipalModal(AUsuarioNome: string);
var
  LView: TViewPrincipal;
begin
  LView := TViewPrincipal.Create(Application);
  try
    LView.DefinirNomeUsuario(AUsuarioNome);
    // --- CONECTA O NOVO EVENTO DE CRIAR PLANILHA ---
    LView.OnCriarPlanilha := TempOnCriarPlanilhaHandler;
    // Conecta outros eventos existentes...
    LView.OnNavegarParaCriadorTabela := TempOnNavegarParaCriadorTabelaHandler;
    // ...
    LView.ShowModal;
  finally
    LView.Free;
    Application.Terminate;
  end;
end;

class procedure TViewController.ShowViewCriadorTabela;
begin
  AuxFluxoCriarTabela_Iniciar;
end;

procedure TViewController.ShowViewImprimirRelatorioPronto(ARelatorio: TRelatorioDTO);
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

class procedure TViewController.TempOnCancelarLoginHandler;
begin
  FTempLoginSucesso := False;
  FTempNomeUsuario := 'Anônimo';
end;

class procedure TViewController.TempOnLoginHandler(const AUsuario, ASenha: string; AModoPublico: Boolean);
begin
  FTempNomeUsuario := AUsuario;
  if FTempNomeUsuario = '' then
    FTempNomeUsuario := 'Anônimo';
  FTempLoginSucesso := True;
end;

class procedure TViewController.TempOnNavegarParaCriadorTabelaHandler;
begin
  TViewController.Instance.ShowViewCriadorTabela;
end;

// --- NOVO: Implementação do handler auxiliar estático ---
class procedure TViewController.TempOnCriarPlanilhaHandler(const ANomeSugerido: string);
begin
  // Este handler estático é chamado quando o evento OnCriarPlanilha
  // da ViewPrincipal é disparado. Ele chama o método de instância
  // do ViewController para tratar a criação.
  TViewController.Instance.HandleCriarPlanilha(ANomeSugerido);
end;

// --- NOVO: Implementação do método de instância para criar planilha ---
procedure TViewController.HandleCriarPlanilha(const ANomePlanilha: string);
var
  DiretorioPlanilhas, DiretorioNovaPlanilha: string;
begin
  if ANomePlanilha = '' then
  begin
    ShowMessage('Nome da planilha inválido.');
    Exit;
  end;

  DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';

  // Verifica/cria o diretório base de planilhas
  if not TDirectory.Exists(DiretorioPlanilhas) then
  begin
    if not ForceDirectories(DiretorioPlanilhas) then
    begin
      ShowMessage('Erro: Não foi possível criar o diretório base de planilhas.');
      Exit;
    end;
  end;

  DiretorioNovaPlanilha := IncludeTrailingPathDelimiter(DiretorioPlanilhas) + ANomePlanilha;

  // Verifica se a planilha já existe
  if TDirectory.Exists(DiretorioNovaPlanilha) then
  begin
    ShowMessage('Erro: Uma planilha com o nome "' + ANomePlanilha + '" já existe.');
    Exit;
  end;

  // Tenta criar o diretório da nova planilha
  try
    if ForceDirectories(DiretorioNovaPlanilha) then
    begin
      ShowMessage('Planilha "' + ANomePlanilha + '" criada com sucesso.');
      // TODO: Atualizar a lista de planilhas na ViewPrincipal
      // Isso pode exigir um método público na ViewPrincipal ou um evento de atualização
      // Por exemplo: ViewPrincipal.AtualizarListaPlanilhas;
    end
    else
    begin
      ShowMessage('Erro: Falha ao criar o diretório da nova planilha.');
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao criar a planilha: ' + E.Message);
  end;
end;

end.
