unit UViewEditorPlanilha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  UPlanilhaDTO;

type
  TSolicitarSalvarPlanilhaEvent = procedure(const APlanilha: TPlanilhaDTO) of object;
  TSolicitarCancelarEdicaoEvent = procedure of object;

  TViewEditorPlanilha = class(TForm)
    PainelEditorTopo: TPanel;
    RotuloTituloPlanilha: TLabel;
    EditarTituloPlanilha: TEdit;
    BotaoSalvarPlanilha: TButton;
    BotaoCancelarPlanilha: TButton;
    GradeEditor: TStringGrid;
    PainelEditorRodape: TPanel;
    BarraStatusEditor: TStatusBar;
    procedure BotaoSalvarPlanilhaClick(Sender: TObject);
    procedure BotaoCancelarPlanilhaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FPlanilha: TPlanilhaDTO;
    FSendoEditada: Boolean;
    FOnSolicitarSalvar: TSolicitarSalvarPlanilhaEvent;
    FOnSolicitarCancelar: TSolicitarCancelarEdicaoEvent;
    procedure CarregarPlanilhaNaInterface;
    procedure AtualizarPlanilhaDoInterface;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; APlanilha: TPlanilhaDTO); reintroduce; overload;
    destructor Destroy; override;
    property OnSolicitarSalvar: TSolicitarSalvarPlanilhaEvent read FOnSolicitarSalvar write FOnSolicitarSalvar;
    property OnSolicitarCancelar: TSolicitarCancelarEdicaoEvent read FOnSolicitarCancelar write FOnSolicitarCancelar;
  end;

var
  ViewEditorPlanilha: TViewEditorPlanilha;

implementation

{$R *.dfm}

constructor TViewEditorPlanilha.Create(AOwner: TComponent);
begin
  Create(AOwner, nil);
end;

constructor TViewEditorPlanilha.Create(AOwner: TComponent; APlanilha: TPlanilhaDTO);
begin
  inherited Create(AOwner);
  FPlanilha := APlanilha;
  FSendoEditada := Assigned(APlanilha);
end;

destructor TViewEditorPlanilha.Destroy;
begin
  if not FSendoEditada and Assigned(FPlanilha) then
    FPlanilha.Free;
  inherited;
end;

procedure TViewEditorPlanilha.FormCreate(Sender: TObject);
begin
  if Assigned(FPlanilha) then
  begin
    CarregarPlanilhaNaInterface;
  end;
end;

procedure TViewEditorPlanilha.CarregarPlanilhaNaInterface;
begin
  if Assigned(FPlanilha) then
  begin
    EditarTituloPlanilha.Text := FPlanilha.Titulo;
  end;
end;

procedure TViewEditorPlanilha.AtualizarPlanilhaDoInterface;
begin
  if not Assigned(FPlanilha) then
    FPlanilha := TPlanilhaDTO.Create;
  FPlanilha.Titulo := EditarTituloPlanilha.Text;
end;

procedure TViewEditorPlanilha.BotaoSalvarPlanilhaClick(Sender: TObject);
begin
  AtualizarPlanilhaDoInterface;
  if Assigned(FOnSolicitarSalvar) then
    FOnSolicitarSalvar(FPlanilha);
end;

procedure TViewEditorPlanilha.BotaoCancelarPlanilhaClick(Sender: TObject);
begin
  if Assigned(FOnSolicitarCancelar) then
    FOnSolicitarCancelar;
  Self.Close;
end;

end.
