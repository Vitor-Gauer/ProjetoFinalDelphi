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
  System.Types;

var
  ListaFormsMinimizados: TList;

{ TFormBaseMinTopoCentro }

constructor TFormBaseMinTopoCentro.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FEstaMinimizadoNoTopo := False;
  if not Assigned(ListaFormsMinimizados) then
    ListaFormsMinimizados := TList.Create;
end;

destructor TFormBaseMinTopoCentro.Destroy;
begin
  if FEstaMinimizadoNoTopo and Assigned(ListaFormsMinimizados) then
  begin
    ListaFormsMinimizados.Remove(Self);
    FEstaMinimizadoNoTopo := False;
    AtualizarLayoutFormsMinimizados;
  end;
  inherited;
end;

procedure TFormBaseMinTopoCentro.WMNCLButtonDblClk(var Message: TMessage);
begin
  if (Message.WParam = HTCAPTION) and FEstaMinimizadoNoTopo then
  begin
    Message.Result := 0;
    DoRestaurarParaTopo;
    Exit;
  end;
  inherited;
end;

class procedure TFormBaseMinTopoCentro.LimparListaGlobalMinimizados;
begin
  if Assigned(ListaFormsMinimizados) then
  begin
    ListaFormsMinimizados.Clear;
    ListaFormsMinimizados.Free;
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
    if Assigned(ListaFormsMinimizados) then
    begin
       ListaFormsMinimizados.Add(Self);
       DoMinimizarParaTopo;
    end;
  end;
end;

procedure TFormBaseMinTopoCentro.WMSysCommand(var Message: TWMSysCommand);
begin
  case Message.CmdType and $FFF0 of
    SC_MINIMIZE:
    begin
      Message.Result := 0;
      DoMinimizarParaTopo;
      Exit;
    end;

    SC_MAXIMIZE:
    begin
      if Assigned(ListaFormsMinimizados) and (ListaFormsMinimizados.IndexOf(Self) <> -1) then
      begin
        Message.Result := 0;
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
  if Assigned(ListaFormsMinimizados) then
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
  NovaPosicaoLeft := (Screen.WorkAreaWidth - Width) div 2;
  NovaPosicaoTop := (Screen.WorkAreaHeight - Height) div 2;
  Left := NovaPosicaoLeft;
  Top := NovaPosicaoTop;
  ShowWindow(Handle, SW_RESTORE);
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
