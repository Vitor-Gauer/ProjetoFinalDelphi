unit UViewVisualizadorRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  URelatorioDTO;

type
  TViewVisualizadorRelatorio = class(TForm)
    PainelVisualizadorTopo: TPanel;
    RotuloNomeRelatorio: TLabel;
    BotaoImprimir: TButton;
    EditorVisualizador: TRichEdit;
    PainelVisualizadorRodape: TPanel;
    BarraStatusVisualizador: TStatusBar;
    procedure BotaoImprimirClick(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
  private
  public
    FRelatorio: TRelatorioDTO;
    //procedure ExibirRelatorioNaInterface;
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ARelatorio: TRelatorioDTO); reintroduce; overload;
    destructor Destroy; override;
    property Relatorio: TRelatorioDTO read FRelatorio write FRelatorio;
  end;

var
  ViewVisualizadorRelatorio: TViewVisualizadorRelatorio;

implementation

{$R *.dfm}

constructor TViewVisualizadorRelatorio.Create(AOwner: TComponent);
begin
  Create(AOwner);
  FRelatorio := nil;
end;

constructor TViewVisualizadorRelatorio.Create(AOwner: TComponent; ARelatorio: TRelatorioDTO);
begin
  inherited Create(AOwner);
  FRelatorio := nil;
end;

destructor TViewVisualizadorRelatorio.Destroy;
begin
  if Assigned(FRelatorio) then
    FRelatorio.Free;
  inherited;
end;

procedure TViewVisualizadorRelatorio.BotaoImprimirClick(Sender: TObject);
begin
  if Assigned(FRelatorio) then
    ShowMessage('Funcionalidade de impressão acionada para: ' + FRelatorio.Titulo + '.')
  else
    ShowMessage('Nenhum relatório disponível para imprimir.');
end;

end.
