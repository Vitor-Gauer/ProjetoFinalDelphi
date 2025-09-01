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
    procedure FormCreate(Sender: TObject);
  private
    FRelatorio: TRelatorioDTO;
    procedure ExibirRelatorioNaInterface;
  public
    constructor Create(AOwner: TComponent; ARelatorio: TRelatorioDTO); reintroduce;
    destructor Destroy; override;
  end;

var
  ViewVisualizadorRelatorio: TViewVisualizadorRelatorio;

implementation

{$R *.dfm}

constructor TViewVisualizadorRelatorio.Create(AOwner: TComponent; ARelatorio: TRelatorioDTO);
begin
  inherited Create(AOwner);
  FRelatorio := ARelatorio;
end;

destructor TViewVisualizadorRelatorio.Destroy;
begin
  inherited;
end;

procedure TViewVisualizadorRelatorio.FormCreate(Sender: TObject);
begin
  if Assigned(FRelatorio) then
  begin
    ExibirRelatorioNaInterface;
  end;
end;

procedure TViewVisualizadorRelatorio.ExibirRelatorioNaInterface;
begin
  if Assigned(FRelatorio) then
  begin
    RotuloNomeRelatorio.Caption := FRelatorio.Titulo;
    EditorVisualizador.Lines.Text := 'Conteúdo do relatório: ' + FRelatorio.Conteudo;
  end;
end;

procedure TViewVisualizadorRelatorio.BotaoImprimirClick(Sender: TObject);
begin
  ShowMessage('Funcionalidade de impressão acionada.');
end;

end.
