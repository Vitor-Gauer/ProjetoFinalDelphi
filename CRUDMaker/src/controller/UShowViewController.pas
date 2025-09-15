unit UShowViewController;

interface

uses
  System.Classes, System.SysUtils, Vcl.Forms, Vcl.Controls,
  UPlanilhaDTO, URelatorioDTO, UTabelaDTO;

type
  TViewController = class
  private
    class var FInstance: TViewController;
    class function GetInstance: TViewController; static;
    class var FTempNomeUsuario: string;
    class var FTempLoginSucesso: Boolean;
    class procedure TempOnLoginHandler(const AUsuario, ASenha: string; AModoPublico: Boolean);
    class procedure TempOnCancelarLoginHandler;

  public
    class property Instance: TViewController read GetInstance;

    // Métodos para mostrar as views
    procedure IniciarAplicacao;
    procedure ShowViewLogin(AModal: Boolean = False);
    procedure ShowViewPrincipalModal(AUsuarioNome: string);
    procedure ShowViewPrincipal(AUsuarioNome: string);
    function ShowViewModalTermos: Boolean;
    procedure ShowViewEditorTabela(ATabela: TTabelaDTO = nil);
    procedure ShowViewEditorRelatorio(ARelatorio: TRelatorioDTO = nil; APlanilhaBase: TPlanilhaDTO = nil);
    //procedure ShowViewVisualizadorRelatorio2(ARelatorio: TRelatorioDTO = nil);
    procedure ShowViewGerenciadorDados;
    procedure ShowViewCompartilhamento;
    procedure CloseViewPrincipal;
    class procedure FreeInstance;
  end;

implementation

{ TViewController }
uses
  UViewEditorTabela, UViewEditorRelatorio, UViewGerenciadorDados, UViewCompartilhamento,
  UViewModalTermos, UViewLogin, UViewPrincipal, UViewVisualizadorRelatorio;

class function TViewController.GetInstance: TViewController;
begin
  if not Assigned(FInstance) then
    FInstance := TViewController.Create;
  Result := FInstance;
end;

// - Implementação dos métodos auxiliares -
class procedure TViewController.TempOnLoginHandler(const AUsuario, ASenha: string; AModoPublico: Boolean);
begin
  // Este método estático captura os dados do login
  FTempNomeUsuario := AUsuario;
  if FTempNomeUsuario = '' then
    FTempNomeUsuario := 'Anônimo';
  FTempLoginSucesso := True;
end;

class procedure TViewController.TempOnCancelarLoginHandler;
begin
  FTempLoginSucesso := False;
  FTempNomeUsuario := 'Anônimo';
end;

// - Fim da implementação dos métodos auxiliares -

procedure TViewController.IniciarAplicacao;
begin
  // 1. Mostra os termos modalmente
  if Self.ShowViewModalTermos then
  begin
    // 2a. Termos ACEITOS (mrOk): Mostrar Login Modal
    Self.ShowViewLogin(True);
  end
  else
  begin
    // 2b. Termos RECUSADOS (mrCancel): Mostrar Principal como 'Anônimo'
    Self.ShowViewPrincipalModal('Anônimo');
  end;
end;

procedure TViewController.ShowViewLogin(AModal: Boolean);
var
  LView: TViewLogin;
begin
  // 1. Mostra os termos e verifica o resultado
  // 2a. Termos ACEITOS
  LView := TViewLogin.Create(nil);
  try
    FTempLoginSucesso := False;
    FTempNomeUsuario := 'Anônimo';
    // Conecta os eventos usando os métodos auxiliares estáticos
    LView.OnLogin := TempOnLoginHandler;
    LView.OnCancelarLogin := TempOnCancelarLoginHandler;

    if AModal then
    begin
      // 3a. Mostra MODAL e ESPERA
      LView.ShowModal;
      // 4a. Após ShowModal retornar, verifica o resultado
      if FTempLoginSucesso then
      begin
        // Login bem-sucedido
        Self.ShowViewPrincipalModal(FTempNomeUsuario);
      end
      else
      begin
        Exit;
      end;
    end
    else
    begin
      // 3b. Mostra NÃO MODAL (não espera)
      // Conecta eventos para ações pós-login não modal
      LView.OnLogin := TempOnLoginHandler;
      LView.OnCancelarLogin := TempOnCancelarLoginHandler;
      LView.Show;
      Exit;
    end;
  finally
    // Libera o formulário SOMENTE se foi modal (já foi fechado)
    if AModal then
      LView.Free;
  end;
end;

procedure TViewController.ShowViewPrincipalModal(AUsuarioNome: string);
var
  LView: TViewPrincipal;
begin
  LView := TViewPrincipal.Create(Application);
  try
    LView.DefinirNomeUsuario(AUsuarioNome);
    LView.ShowModal;
  finally
    LView.Free;
    Application.Terminate;
  end;
end;

procedure TViewController.ShowViewPrincipal(AUsuarioNome: string);
var
  LView: TViewPrincipal;
begin
  LView := TViewPrincipal.Create(Application);
  LView.DefinirNomeUsuario(AUsuarioNome);
  LView.Show;
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

procedure TViewController.ShowViewEditorTabela(ATabela: TTabelaDTO);
var
  LView: TViewEditorTabela;
begin
  LView := TViewEditorTabela.Create(Application, ATabela);
  LView.Show;
end;

procedure TViewController.ShowViewEditorRelatorio(ARelatorio: TRelatorioDTO; APlanilhaBase: TPlanilhaDTO);
var
  LView: TViewEditorRelatorio;
begin
  LView := TViewEditorRelatorio.Create(Application){, ARelatorio, APlanilhaBase)};
  LView.Show;
end;

//procedure ShowViewVisualizadorRelatorio2(ARelatorio: TRelatorioDTO);
//var
//  LView:TViewVisualizadorRelatorio;
//  begin
//    LView := TViewVisualizadorRelatorio.Create(Application, ARelatorio);
//    LView.Show;
//  end;

procedure TViewController.ShowViewGerenciadorDados;
var
  LView: TViewGerenciadorDados;
begin
  LView := TViewGerenciadorDados.Create(Application);
  LView.Show;
end;

procedure TViewController.ShowViewCompartilhamento;
var
  LView: TViewCompartilhamento;
begin
  LView := TViewCompartilhamento.Create(Application);
  LView.Show;
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
    FreeAndNil(FInstance);
  end;
end;

end.
