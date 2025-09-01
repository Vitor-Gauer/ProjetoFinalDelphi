unit UViewController;

interface

uses
  // Model/DTO units (for passing data)
  UPlanilhaDTO, URelatorioDTO,
  // System units
  System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls;

type
  /// <summary>
  /// Controller responsável por gerenciar a navegação e o ciclo de vida das views da aplicação.
  /// </summary>
  TViewController = class
  private
    class var FInstance: TViewController;
    class function GetInstance: TViewController; static;
  public
    class property Instance: TViewController read GetInstance;

    // --- Gerenciamento de Views ---
    /// <summary>
    /// Mostra a view de Login. Normalmente a primeira view exibida.
    /// </summary>
    procedure ShowLoginView(AModal: Boolean = False);

    /// <summary>
    /// Mostra a view principal da aplicação após o login bem-sucedido.
    /// </summary>
    procedure ShowMainView(AUsuarioNome: string);

    /// <summary>
    /// Mostra o modal de Termos de Uso.
    /// </summary>
    /// <returns>True se aceito, False se recusado/cancelado.</returns>
    function ShowTermsView: Boolean;

    // --- Navegação de Planilha ---
    /// <summary>
    /// Abre a view do Editor de Planilha.
    /// </summary>
    /// <param name="APlanilha">O DTO da planilha para editar (pode ser nil para nova).</param>
    procedure ShowEditorPlanilhaView(APlanilha: TPlanilhaDTO = nil);

    // --- Navegação de Relatório ---
    /// <summary>
    /// Abre a view do Editor de Relatório.
    /// </summary>
    /// <param name="ARelatorio">O DTO do relatório para editar (pode ser nil para novo).</param>
    /// <param name="APlanilhaBase">Planilha opcional para usar como base.</param>
    procedure ShowEditorRelatorioView(ARelatorio: TRelatorioDTO = nil; APlanilhaBase: TPlanilhaDTO = nil);

    /// <summary>
    /// Abre a view do Visualizador de Relatório.
    /// </summary>
    /// <param name="ARelatorio">O DTO do relatório para visualizar.</param>
    procedure ShowVisualizadorRelatorioView(ARelatorio: TRelatorioDTO);

    // --- Views Auxiliares ---
    /// <summary>
    /// Abre a view do Gerenciador de Dados.
    /// </summary>
    procedure ShowGerenciadorDadosView;

    /// <summary>
    /// Abre a view de Compartilhamento.
    /// </summary>
    procedure ShowCompartilhamentoView;

    // --- Utilitário ---
    /// <summary>
    /// Fecha a view principal atual (UViewPrincipal).
    /// </summary>
    procedure CloseMainView;

    /// <summary>
    /// Libera a instância singleton.
    /// </summary>
    class procedure FreeInstance;
  end;

implementation

uses
  UViewLogin, UViewPrincipal, UViewEditorPlanilha, UViewEditorRelatorio,
  UViewGerenciadorDados, UViewCompartilhamento, UViewVisualizadorRelatorio,
  UViewModalTermos;

{ TViewController }

class function TViewController.GetInstance: TViewController;
begin
  if not Assigned(FInstance) then
    FInstance := TViewController.Create;
  Result := FInstance;
end;

procedure TViewController.ShowLoginView(AModal: Boolean);
var
  LView: TViewLogin;
begin
  LView := TViewLogin.Create(nil);
  try
    if AModal then
      LView.ShowModal
    else
      LView.Show;
  finally
    if AModal then
      LView.Free;
  end;
end;

procedure TViewController.ShowMainView(AUsuarioNome: string);
var
  LView: TViewPrincipal;
begin
  LView := TViewPrincipal.Create(Application);
  LView.DefinirNomeUsuario(AUsuarioNome);
  LView.Show;
end;

function TViewController.ShowTermsView: Boolean;
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

procedure TViewController.ShowEditorPlanilhaView(APlanilha: TPlanilhaDTO);
var
  LView: TViewEditorPlanilha;
begin
  LView := TViewEditorPlanilha.Create(Application);
  LView.Show;
end;

procedure TViewController.ShowEditorRelatorioView(ARelatorio: TRelatorioDTO; APlanilhaBase: TPlanilhaDTO);
var
  LView: TViewEditorRelatorio;
begin
  LView := TViewEditorRelatorio.Create(Application);
  LView.Show;
end;

procedure TViewController.ShowVisualizadorRelatorioView(ARelatorio: TRelatorioDTO);
var
  LView: TViewVisualizadorRelatorio;
begin
  LView := TViewVisualizadorRelatorio.Create(Application, ARelatorio);
  LView.Show;
end;

procedure TViewController.ShowGerenciadorDadosView;
var
  LView: TViewGerenciadorDados;
begin
  LView := TViewGerenciadorDados.Create(Application);
  LView.Show;
end;

procedure TViewController.ShowCompartilhamentoView;
var
  LView: TViewCompartilhamento;
begin
  LView := TViewCompartilhamento.Create(Application);
  LView.Show;
end;

procedure TViewController.CloseMainView;
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
    FreeAndNil(FInstance);
  end;
end;

end.
