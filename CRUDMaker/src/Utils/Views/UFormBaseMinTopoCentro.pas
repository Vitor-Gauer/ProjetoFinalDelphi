unit UFormBaseMinTopoCentro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFormBaseMinTopoCentro = class(TForm)
  private
    FEstaMinimizadoNoTopo: Boolean;
    procedure WMSysCommand(var Message: TWMSysCommand); message WM_SYSCOMMAND;
    procedure AtualizarLayoutFormsMinimizados;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DoMinimizarParaTopo;
    procedure DoRestaurarDoTopo;
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
  // Inicializa a lista global se ainda não estiver
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
  if (Message.CmdType = SC_MINIMIZE) then
  begin
    Message.Result := 0;
    DoMinimizarParaTopo;
    Exit;
  end;
  inherited;
end;

procedure TFormBaseMinTopoCentro.DoMinimizarParaTopo;
begin
  if FEstaMinimizadoNoTopo then
    Exit;

  FEstaMinimizadoNoTopo := True;
  if Assigned(ListaFormsMinimizados) then // Verifica se a lista foi criada
  begin
    ListaFormsMinimizados.Add(Self);
    AtualizarLayoutFormsMinimizados;
  end;
end;

procedure TFormBaseMinTopoCentro.DoRestaurarDoTopo;
begin
  if not FEstaMinimizadoNoTopo then
    Exit;

  if Assigned(ListaFormsMinimizados) then // Verifica se a lista foi criada
  begin
    ListaFormsMinimizados.Remove(Self);
    FEstaMinimizadoNoTopo := False;
  end;
  ShowWindow(Handle, SW_RESTORE);
  BringToFront;
  AtualizarLayoutFormsMinimizados;
end;

procedure TFormBaseMinTopoCentro.AtualizarLayoutFormsMinimizados;
var
  ScreenWidth, FormWidth, TotalWidth, StartX, i: Integer;
  NewRect: TRect;
  Form: TFormBaseMinTopoCentro;
  FormHeight: Integer;
begin
  if not Assigned(ListaFormsMinimizados) or (ListaFormsMinimizados.Count = 0) then
    Exit;

  ScreenWidth := Screen.WorkAreaWidth;
  FormWidth := 200;
  FormHeight := 40;

  TotalWidth := ListaFormsMinimizados.Count * FormWidth;

  StartX := (ScreenWidth - TotalWidth) div 2;

  for i := 0 to ListaFormsMinimizados.Count - 1 do
  begin
    Form := TFormBaseMinTopoCentro(ListaFormsMinimizados.Items[i]);
    if Assigned(Form) and Form.FEstaMinimizadoNoTopo then
    begin
      NewRect := Rect(StartX + (i * FormWidth), 0, StartX + (i * FormWidth) + FormWidth, FormHeight);
      SetWindowPos(Form.Handle, 0,
                   NewRect.Left, NewRect.Top,
                   NewRect.Right - NewRect.Left, NewRect.Bottom - NewRect.Top,
                   SWP_NOZORDER or SWP_NOACTIVATE or SWP_SHOWWINDOW);
    end;
  end;
end;

end.
