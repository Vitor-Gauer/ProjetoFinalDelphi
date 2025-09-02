unit UViewController;

interface

uses
  // Model/DTO units (for passing data)
  UPlanilhaDTO, URelatorioDTO,
  // System units
  System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls, Vcl.Dialogs,
  // Views units (TODAS adicionadas para reconhecimento dos tipos TView...)
  UViewModalTermos, UViewLogin, UViewPrincipal, UViewEditorPlanilha,
  UViewEditorRelatorio, UViewVisualizadorRelatorio, UViewGerenciadorDados,
  UViewCompartilhamento;

type
  /// Controller responsável por gerenciar a navegação e o ciclo de vida das views da aplicação.
  TViewController = class
  private
    class var FInstance: TViewController;
    class function GetInstance: TViewController; static;
    // --- Métodos auxiliares internos ---
    procedure MostrarLoginViewInterno(AModal: Boolean = False); // Auxiliar (opcional)
  public
    class property Instance: TViewController read GetInstance;
    // --- Gerenciamento de Views ---
    /// Mostra a view de Login. Normalmente a primeira view exibida.
    procedure MostrarLoginView(AModal: Boolean = False);
    /// Mostra a view principal da aplicação após o login bem-sucedido.
    procedure MostrarMainView(AUsuarioNome: string);
    /// Mostra o modal de Termos de Uso.
    function MostrarTermosView: Boolean;
    // --- Navegação de Planilha ---
    /// Abre a view do Editor de Planilha.
    procedure MostrarEditorPlanilhaView(APlanilha: TPlanilhaDTO = nil);
    // --- Navegação de Relatório ---
    /// Abre a view do Editor de Relatório.
    procedure MostrarEditorRelatorioView(ARelatorio: TRelatorioDTO = nil; APlanilhaBase: TPlanilhaDTO = nil);
    /// Abre a view do Visualizador de Relatório.
    procedure MostrarVisualizadorRelatorioView(ARelatorio: TRelatorioDTO);
    // --- Views Auxiliares ---
    /// Abre a view do Gerenciador de Dados.
    procedure MostrarGerenciadorDadosView;
    /// Abre a view de Compartilhamento.
    procedure MostrarCompartilhamentoView;
    // --- Utilitário ---
    /// Fecha a view principal atual (UViewPrincipal).
    procedure CloseMainView;
    /// Libera a instância singleton.
    class procedure FreeInstance;

    // --- Novo Método para Fluxo Inicial ---
    /// Coordena o fluxo inicial da aplicação: Termos -> Login/Main
    procedure IniciarFluxoInicial(AOwner: TComponent = nil);
  end;

implementation

uses
  Winapi.Windows; // Para OutputDebugString

{ TViewController }

class function TViewController.GetInstance: TViewController;
begin
  if not Assigned(FInstance) then
    FInstance := TViewController.Create;
  Result := FInstance;
end;

// --- Métodos Renomeados ---
procedure TViewController.MostrarLoginView(AModal: Boolean);
{
  Mostra a view de Login.
  @param AModal Se True, mostra o login como um diálogo modal. Se False, mostra como uma janela normal.
}
var
  LView: TViewLogin;
begin
  LView := TViewLogin.Create(nil); // Ou Application, dependendo do gerenciamento desejado
  try
    if AModal then
      LView.ShowModal
    else
      LView.Show;
    // Nota: Se não for modal, gerenciar o ciclo de vida de LView se torna mais complexo.
  finally
    if AModal then
      LView.Free; // Se modal, libera aqui
    // Se não modal, LView.Show assume a propriedade (geralmente Application ou Owner)
    // e será liberado automaticamente quando o Owner for destruído ou por Close.
  end;
end;

procedure TViewController.MostrarMainView(AUsuarioNome: string);
{
  Mostra a view principal da aplicação após o login bem-sucedido.
  @param AUsuarioNome O nome do usuário logado para exibir na interface.
}
var
  LView: TViewPrincipal;
  I: Integer;
  ExistingMainView: TViewPrincipal;
begin
  // Verifica se já existe uma instância de TViewPrincipal
  // Se sim, apenas traz para frente. Se não, cria uma nova.
  // Isso evita múltiplas janelas principais.
  ExistingMainView := nil;
  for I := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[I] is TViewPrincipal then
    begin
      ExistingMainView := TViewPrincipal(Screen.Forms[I]);
      Break;
    end;
  end;

  if Assigned(ExistingMainView) then
  begin
    ExistingMainView.Show;
    ExistingMainView.BringToFront;
  end
  else
    begin
      LView := TViewPrincipal.Create(Application); // Propriedade do Application
      // Passa info do usuário se necessário
      LView.DefinirNomeUsuario(AUsuarioNome); // Exemplo
      LView.Show;
    end;
end;

{
  Mostra o modal de Termos de Uso.
  @return True se os termos foram aceitos (usuário clicou em 'Aceitar'), False se foram recusados ou o modal foi cancelado.
}
function TViewController.MostrarTermosView: Boolean;
var
  LView: TViewModalTermos;
begin
  Result := False;
  LView := TViewModalTermos.Create(nil);
  try
    Result := (LView.ShowModal = mrOk);
  finally
    LView.Free;
  end;
end;


procedure TViewController.MostrarEditorPlanilhaView(APlanilha: TPlanilhaDTO);
{
  Abre a view do Editor de Planilha.
  @param APlanilha O DTO da planilha para editar. Se nil, o editor será aberto para criar uma nova planilha.
}
var
  LView: TViewEditorPlanilha;
begin
  LView := TViewEditorPlanilha.Create(Application);
  // TODO: Passar dados de APlanilha para a view para edição/carregamento
  // ex: LView.LoadPlanilha(APlanilha);
  LView.Show;
end;

procedure TViewController.MostrarEditorRelatorioView(ARelatorio: TRelatorioDTO; APlanilhaBase: TPlanilhaDTO);
{
  Abre a view do Editor de Relatório.
  @param ARelatorio O DTO do relatório para editar. Se nil, o editor será aberto para criar um novo relatório.
  @param APlanilhaBase Planilha opcional para usar como base ao criar um novo relatório.
}
var
  LView: TViewEditorRelatorio;
begin
  LView := TViewEditorRelatorio.Create(Application);
  // TODO: Passar dados de ARelatorio para edição ou APlanilhaBase para criar um novo
  // ex: LView.LoadRelatorio(ARelatorio) ou LView.SetPlanilhaBase(APlanilhaBase);
  LView.Show;
end;

procedure TViewController.MostrarVisualizadorRelatorioView(ARelatorio: TRelatorioDTO);
{
  Abre a view do Visualizador de Relatório.
  @param ARelatorio O DTO do relatório para visualizar.
}
var
  LView: TViewVisualizadorRelatorio;
begin
  // Cria a view passando a instância de TRelatorioDTO
  LView := TViewVisualizadorRelatorio.Create(Application, ARelatorio);
  // TODO: Passar dados de ARelatorio para a view para exibição
  // ex: LView.DisplayRelatorio(ARelatorio);
  LView.Show;
end;

procedure TViewController.MostrarGerenciadorDadosView;
{
  Abre a view do Gerenciador de Dados.
}
var
  LView: TViewGerenciadorDados;
begin
  LView := TViewGerenciadorDados.Create(Application);
  LView.Show;
end;

procedure TViewController.MostrarCompartilhamentoView;
{
  Abre a view de Compartilhamento.
}
var
  LView: TViewCompartilhamento;
begin
  LView := TViewCompartilhamento.Create(Application);
  LView.Show;
end;

// --- Métodos Não Renomeados (porque são utilitários ou destrutores) ---
procedure TViewController.CloseMainView;
{
  Fecha a view principal atual (UViewPrincipal).
}
var
  I: Integer;
begin
  // Procura e fecha a view principal (UViewPrincipal)
  for I := Screen.FormCount - 1 downto 0 do // Itera de trás para frente para evitar problemas ao fechar
  begin
    if Screen.Forms[I] is TViewPrincipal then
    begin
      Screen.Forms[I].Close; // Isso irá disparar o evento OnClose
    end;
  end;
end;

class procedure TViewController.FreeInstance;
{
  Libera a instância singleton.
}
begin
  if Assigned(FInstance) then
  begin
    FreeAndNil(FInstance);
  end;
end;

// --- Novos Métodos ou Métodos Modificados ---
procedure TViewController.MostrarLoginViewInterno(AModal: Boolean);
begin
  // Reutiliza a lógica existente de MostrarLoginView
  Self.MostrarLoginView(AModal);
end;

{
  Coordena o fluxo inicial da aplicação: Termos -> Login/Main
  @param AOwner Form Owner (opcional, pode ser Application).
}
procedure TViewController.IniciarFluxoInicial(AOwner: TComponent);
var
  LTermosAceitos: Boolean;
begin
  OutputDebugString('DEBUG: TViewController.IniciarFluxoInicial - INICIO');

  // 1. Mostrar Termos
  OutputDebugString('DEBUG: TViewController.IniciarFluxoInicial - Chamando MostrarTermosView');
  LTermosAceitos := Self.MostrarTermosView; // Chama o método renomeado

  // --- PONTO DE DEBUG CRÍTICO 3: Depois que MostrarTermosView retorna ---
  OutputDebugString(PWideChar('DEBUG: TViewController.IniciarFluxoInicial - MostrarTermosView RETORNOU. TermosAceitos = ' + BoolToStr(LTermosAceitos, True)));

  // 2. Decidir o próximo passo com base na resposta
  if LTermosAceitos then
  begin
    OutputDebugString('DEBUG: TViewController.IniciarFluxoInicial - Mostrando Login');
    Self.MostrarLoginView(True); // Mostra como modal
  end
  else
  begin
    OutputDebugString('DEBUG: TViewController.IniciarFluxoInicial - Mostrando Principal');
    Self.MostrarMainView('UsuarioPadrao'); // Substitua 'UsuarioPadrao' conforme necessário
  end;

  OutputDebugString('DEBUG: TViewController.IniciarFluxoInicial - FIM');
end;

end.
