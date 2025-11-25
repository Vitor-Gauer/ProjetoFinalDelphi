unit UViewSelecionarPlanilhaParaTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UFormBaseMinTopoCentro;

type
  TViewSelecionarPlanilhaParaTabela = class(TFormBaseMinTopoCentro)
    PainelBotoes: TPanel;
    BotaoAvancar: TButton;
    BotaoCancelar: TButton;
    ListBoxPlanilhas: TListBox;
    LabelInstrucoes: TLabel;
    procedure BotaoAvancarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBoxPlanilhasClick(Sender: TObject);
  private
    FPlanilhaSelecionada: string;
    FOnAvancar: TNotifyEvent;
    FOnCancelar: TNotifyEvent;
    procedure PopularListaPlanilhas;
    procedure AtualizarEstadoBotoes;
  public
    property PlanilhaSelecionada: string read FPlanilhaSelecionada;
    property OnAvancar: TNotifyEvent read FOnAvancar write FOnAvancar;
    property OnCancelar: TNotifyEvent read FOnCancelar write FOnCancelar;
  end;

var
  ViewSelecionarPlanilhaParaTabela: TViewSelecionarPlanilhaParaTabela;

implementation

{$R *.dfm}

uses
  System.IOUtils;

procedure TViewSelecionarPlanilhaParaTabela.FormCreate(Sender: TObject);
begin
  FPlanilhaSelecionada := '';
  PopularListaPlanilhas;
  AtualizarEstadoBotoes;
end;

procedure TViewSelecionarPlanilhaParaTabela.PopularListaPlanilhas;
var
  DiretorioPlanilhas: string;
  Diretorios: TArray<string>;
  i: Integer;
  NomePasta: string;
begin
  ListBoxPlanilhas.Items.Clear;
  DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';

  if TDirectory.Exists(DiretorioPlanilhas) then
  begin
    Diretorios := TDirectory.GetDirectories(DiretorioPlanilhas);
    for i := Low(Diretorios) to High(Diretorios) do
    begin
      NomePasta := ExtractFileName(Diretorios[i]);
      if NomePasta <> '' then
        ListBoxPlanilhas.Items.Add(NomePasta);
    end;
  end;

  if ListBoxPlanilhas.Items.Count = 0 then
  begin
    ShowMessage('Nenhuma planilha encontrada em: ' + DiretorioPlanilhas + '. Crie uma planilha primeiro.');
    end;
end;

procedure TViewSelecionarPlanilhaParaTabela.ListBoxPlanilhasClick(Sender: TObject);
begin
  if ListBoxPlanilhas.ItemIndex >= 0 then
    FPlanilhaSelecionada := ListBoxPlanilhas.Items[ListBoxPlanilhas.ItemIndex]
  else
    FPlanilhaSelecionada := '';
  AtualizarEstadoBotoes;
end;

procedure TViewSelecionarPlanilhaParaTabela.AtualizarEstadoBotoes;
begin
  BotaoAvancar.Enabled := (FPlanilhaSelecionada <> '');
end;

procedure TViewSelecionarPlanilhaParaTabela.BotaoAvancarClick(Sender: TObject);
begin
 modalresult := mrOk;
  if Assigned(FOnAvancar) and (FPlanilhaSelecionada <> '') then
    FOnAvancar(Self);
end;

procedure TViewSelecionarPlanilhaParaTabela.BotaoCancelarClick(Sender: TObject);
begin
 modalresult := mrCancel;
  if Assigned(FOnCancelar) then
    FOnCancelar(Self);
end;

end.
