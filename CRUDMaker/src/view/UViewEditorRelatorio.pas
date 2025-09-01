unit UViewEditorRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  URelatorioDTO, UPlanilhaDTO;

type
  TSolicitarSalvarRelatorioEvent = procedure(const ARelatorio: TRelatorioDTO) of object;
  TSolicitarCancelarEdicaoRelatorioEvent = procedure of object;

  TViewEditorRelatorio = class(TForm)
    PainelRelatorioTopo: TPanel;
    RotuloTituloRelatorio: TLabel;
    RotuloTipoRelatorio: TLabel;
    EditarTituloRelatorio: TEdit;
    ComboBoxTipoRelatorio: TComboBox;
    BotaoSalvarRelatorio: TButton;
    BotaoCancelarRelatorio: TButton;
    MemoConfiguracaoRelatorio: TMemo;
    PainelRelatorioRodape: TPanel;
    BarraStatusRelatorio: TStatusBar;
    procedure BotaoSalvarRelatorioClick(Sender: TObject);
    procedure BotaoCancelarRelatorioClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FRelatorio: TRelatorioDTO;
    FSendoEditada: Boolean;
    FOnSolicitarSalvar: TSolicitarSalvarRelatorioEvent;
    FOnSolicitarCancelar: TSolicitarCancelarEdicaoRelatorioEvent;
    procedure CarregarRelatorioNaInterface;
    procedure AtualizarRelatorioDoInterface;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ARelatorio: TRelatorioDTO); reintroduce; overload;
    destructor Destroy; override;
    property OnSolicitarSalvar: TSolicitarSalvarRelatorioEvent read FOnSolicitarSalvar write FOnSolicitarSalvar;
    property OnSolicitarCancelar: TSolicitarCancelarEdicaoRelatorioEvent read FOnSolicitarCancelar write FOnSolicitarCancelar;
  end;

var
  ViewEditorRelatorio: TViewEditorRelatorio;

implementation

{$R *.dfm}

constructor TViewEditorRelatorio.Create(AOwner: TComponent);
begin
  Create(AOwner, nil);
end;

constructor TViewEditorRelatorio.Create(AOwner: TComponent; ARelatorio: TRelatorioDTO);
begin
  inherited Create(AOwner);
  FRelatorio := ARelatorio;
  FSendoEditada := Assigned(ARelatorio);
end;

destructor TViewEditorRelatorio.Destroy;
begin
  if not FSendoEditada and Assigned(FRelatorio) then
    FRelatorio.Free;
  inherited;
end;

procedure TViewEditorRelatorio.FormCreate(Sender: TObject);
begin
  ComboBoxTipoRelatorio.Items.CommaText := 'Ordenador,Analítico,Gráfico/Visual,Riscos/Alertas';
  ComboBoxTipoRelatorio.ItemIndex := 0;
  if Assigned(FRelatorio) then
  begin
    CarregarRelatorioNaInterface;
  end;
end;

procedure TViewEditorRelatorio.CarregarRelatorioNaInterface;
begin
  if Assigned(FRelatorio) then
  begin
    EditarTituloRelatorio.Text := FRelatorio.Titulo;
  end;
end;

procedure TViewEditorRelatorio.AtualizarRelatorioDoInterface;
begin
  if not Assigned(FRelatorio) then
    FRelatorio := TRelatorioDTO.Create;
  FRelatorio.Titulo := EditarTituloRelatorio.Text;
end;

procedure TViewEditorRelatorio.BotaoSalvarRelatorioClick(Sender: TObject);
begin
  AtualizarRelatorioDoInterface;
  if Assigned(FOnSolicitarSalvar) then
    FOnSolicitarSalvar(FRelatorio);
end;

procedure TViewEditorRelatorio.BotaoCancelarRelatorioClick(Sender: TObject);
begin
  if Assigned(FOnSolicitarCancelar) then
    FOnSolicitarCancelar;
  Self.Close;
end;

end.
