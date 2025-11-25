unit UViewImprimirRelatorioPronto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  URelatorioDTO, UFormBaseMinTopoCentro;

type
  TViewImprimirRelatorioPronto = class(TFormBaseMinTopoCentro)
    PainelVisualizadorTopo: TPanel;
    RotuloNomeRelatorio: TLabel;
    BotaoImprimir: TButton;
    EditorVisualizador: TRichEdit;
    PainelVisualizadorRodape: TPanel;
    BarraStatusVisualizador: TStatusBar;
    procedure BotaoImprimirClick(Sender: TObject);
  private
  public
    FRelatorio: TRelatorioDTO;
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ARelatorio: TRelatorioDTO); reintroduce; overload;
    destructor Destroy; override;
    property Relatorio: TRelatorioDTO read FRelatorio write FRelatorio;
  end;

var
  ViewImprimirRelatorioPronto: TViewImprimirRelatorioPronto;

implementation

{$R *.dfm}

constructor TViewImprimirRelatorioPronto.Create(AOwner: TComponent);
begin
  Create(AOwner);
  FRelatorio := nil;
end;

constructor TViewImprimirRelatorioPronto.Create(AOwner: TComponent; ARelatorio: TRelatorioDTO);
begin
  inherited Create(AOwner);
  FRelatorio := nil;
end;

destructor TViewImprimirRelatorioPronto.Destroy;
begin
  if Assigned(FRelatorio) then
    FRelatorio.Free;
  inherited;
end;

procedure TViewImprimirRelatorioPronto.BotaoImprimirClick(Sender: TObject);
begin
  if Assigned(FRelatorio) then
    ShowMessage('Funcionalidade de impressão acionada para: ' + FRelatorio.Titulo + '.')
  else
    ShowMessage('Nenhum relatório disponível para imprimir.');
end;

end.
