unit UFormBaseMinTopoCentro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFormBaseMinTopoCentro = class(TForm)
  private
    FEstaMinimizadoNoTopo: Boolean;
    FLarguraOriginal, FAlturaOriginal: Integer;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure WMNCLButtonDblClk(var Message: TMessage);
    procedure AtualizarLayoutFormsMinimizados;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoMinimizarParaTopo;
    procedure DoRestaurarParaTopo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    class procedure LimparListaGlobalMinimizados;
  end;

implementation

uses
  System.Types; // Para TRect, TPoint

var
  ListaFormsMinimizados: TList;

{ TFormBaseMinTopoCentro }

constructor TFormBaseMinTopoCentro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEstaMinimizadoNoTopo := False;
  // Inicializa a lista global se ainda não estiver sido
  if not Assigned(ListaFormsMinimizados) then
    ListaFormsMinimizados := TList.Create;
end;

destructor TFormBaseMinTopoCentro.Destroy;
begin
  // Remove este formulário da lista global ao ser destruído
  if FEstaMinimizadoNoTopo and Assigned(ListaFormsMinimizados) then
  begin
    ListaFormsMinimizados.Remove(Self);
    FEstaMinimizadoNoTopo := False;
    AtualizarLayoutFormsMinimizados; // Atualiza layout após remover
  end;
  inherited;
end;

procedure TFormBaseMinTopoCentro.WMNCLButtonDblClk(var Message: TMessage);
begin
  // A mensagem WM_NCLBUTTONDBLCLK é enviada com o Hittest Code no parâmetro WParam.
  // Se o clique duplo foi na barra de título, o código será HTCAPTION.
  if (Message.WParam = HTCAPTION) and FEstaMinimizadoNoTopo then
  begin
    Message.Result := 0; // Consome a mensagem para evitar comportamento padrão
    DoRestaurarParaTopo;
    Exit;
  end;

  // Se não for clique duplo na barra de título, ou não estiver minimizado,
  // permite que o processamento padrão (ex: maximizar) ocorra.
  inherited;
end;

class procedure TFormBaseMinTopoCentro.LimparListaGlobalMinimizados;
begin
  if Assigned(ListaFormsMinimizados) then
  begin
    // Limpa os itens da lista (não destrói os forms, apenas remove as referências)
    ListaFormsMinimizados.Clear;
    // Libera o objeto TList
    ListaFormsMinimizados.Free;
    // Atribui nil à variável global para indicar que a lista foi liberada
    ListaFormsMinimizados := nil;
  end;
end;

procedure TFormBaseMinTopoCentro.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CAPTION or WS_SYSMENU;
end;

procedure TFormBaseMinTopoCentro.CreateWnd;
begin
  inherited CreateWnd;
  if IsIconic(Handle) then
  begin
    FEstaMinimizadoNoTopo := True;
    if Assigned(ListaFormsMinimizados) then // Verifica se a lista foi criada
    begin
       ListaFormsMinimizados.Add(Self);
       DoMinimizarParaTopo;
    end;
  end;
end;

procedure TFormBaseMinTopoCentro.WMSysCommand(var Message: TWMSysCommand);
begin
  // O valor do CmdType deve ser mascarado com $FFF0 para ignorar bits de posição.
  case Message.CmdType and $FFF0 of
    SC_MINIMIZE:
    begin
      Message.Result := 0;
      DoMinimizarParaTopo;
      Exit;
    end;

    // Foca apenas no RESTORE
    SC_MAXIMIZE:
    begin
      // VERIFICA SE O FORMULÁRIO ESTÁ NA SUA LISTA PERSONALIZADA
      if Assigned(ListaFormsMinimizados) and (ListaFormsMinimizados.IndexOf(Self) <> -1) then
      begin
        // A flag interna FEstaMinimizadoNoTopo deve ser True se ele está na lista,
        // mas usar a lista é mais seguro
        Message.Result := 0; // Consome a mensagem
        DoRestaurarParaTopo;
        Exit;
      end;
    end;
  end;

  inherited;
end;

procedure TFormBaseMinTopoCentro.DoMinimizarParaTopo;
begin
  if FEstaMinimizadoNoTopo then
    Exit;

  FLarguraOriginal := Width;
  FAlturaOriginal := Height;
  SendToback;
  FEstaMinimizadoNoTopo := True;
  if Assigned(ListaFormsMinimizados) then // Verifica se a lista foi criada
  begin
    ListaFormsMinimizados.Add(Self);
    AtualizarLayoutFormsMinimizados;
  end;
end;

procedure TFormBaseMinTopoCentro.DoRestaurarParaTopo;
var
  NovaPosicaoleft, NovaPosicaoTop: Integer;
begin
  if not FEstaMinimizadoNoTopo then
    Exit;

  if Assigned(ListaFormsMinimizados) then
  begin
    ListaFormsMinimizados.Remove(Self);
    FEstaMinimizadoNoTopo := False;
  end;

  Width := FLarguraOriginal;
  Height := FAlturaOriginal;

  // Centralização: (Largura da Área de Trabalho - Altura do Formulário) / 2
  NovaPosicaoLeft := (Screen.WorkAreaWidth - Width) div 2;

  // Centralização: (Altura da Área de Trabalho - Altura do Formulário) / 2
  NovaPosicaoTop := (Screen.WorkAreaHeight - Height) div 2;

  // 3. Define a nova posição (o VCL usará SendMessage/SetWindowPos internamente)
  Left := NovaPosicaoLeft;
  Top := NovaPosicaoTop;

  // Tira o formulário do estado de minimizado e o restaura para a posição e tamanho normais
  ShowWindow(Handle, SW_RESTORE);

  // Traz para frente e atualiza a lista de minimizados restantes
  BringToFront;
  AtualizarLayoutFormsMinimizados;
end;

procedure TFormBaseMinTopoCentro.AtualizarLayoutFormsMinimizados;
const
  FLarguraForm = 1000;
  FormHeight = 40;
var
  FLarguraTela, FLarguraTotal, FStartX, i: Integer;
  FNovoTamanho: TRect;
  Form: TFormBaseMinTopoCentro;
begin
  if not Assigned(ListaFormsMinimizados) or (ListaFormsMinimizados.Count = 0) then
    Exit;

  FLarguraTela := Screen.WorkAreaWidth;
  FLarguraTotal := ListaFormsMinimizados.Count * FLarguraForm;

  FStartX := (FLarguraTela - FLarguraTotal) div 2;

  for i := 0 to ListaFormsMinimizados.Count - 1 do
  begin
    Form := TFormBaseMinTopoCentro(ListaFormsMinimizados.Items[i]);
    if Assigned(Form) and Form.FEstaMinimizadoNoTopo then
    begin
      FNovoTamanho := Rect(FStartX + (i * FLarguraForm), 0, FStartX + (i * FLarguraForm) + FLarguraForm, FormHeight);
      SetWindowPos(Form.Handle, 0,
                   FNovoTamanho.Left, FNovoTamanho.Top,
                   FNovoTamanho.Right - FNovoTamanho.Left, FNovoTamanho.Bottom - FNovoTamanho.Top,
                   SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    end;
  end;
end;

end.
