unit UPDFService;

interface

uses
  System.SysUtils, System.Classes,
  frxclass, frxExportBaseDialog, frxExportPDF;

type
  TPDFService = class
  private
    FPDFExport: TfrxPDFExport;
    function ObterCaminhoSaidaPadrao(const ANomeArquivo: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    function GerarPDF(const AReport: TfrxReport; const ACaminhoSaida: string = ''): Boolean;
  end;

implementation

uses
  System.IOUtils;

{ TPDFService }

constructor TPDFService.Create;
begin
  FPDFExport := TfrxPDFExport.Create(nil);
  // Configurações padrão do PDF
  FPDFExport.ShowProgress := True;
  FPDFExport.EmbeddedFonts := True;
  FPDFExport.Author := 'Sistema';
  FPDFExport.Subject := 'Relatório';
  FPDFExport.Title := 'Relatório';
end;

destructor TPDFService.Destroy;
begin
  FPDFExport.Free;
  inherited;
end;

function TPDFService.ObterCaminhoSaidaPadrao(const ANomeArquivo: string): string;
begin
  Result := TPath.Combine(TPath.GetDocumentsPath, ANomeArquivo + '.pdf');
end;

function TPDFService.GerarPDF(const AReport: TfrxReport; const ACaminhoSaida: string): Boolean;
var
  LCaminhoFinal: string;
  LDir: string;
begin
  Result := False;
  if not Assigned(AReport) then Exit;

  // Se não for fornecido um caminho de saída, usa um padrão
  if ACaminhoSaida = '' then
    LCaminhoFinal := ObterCaminhoSaidaPadrao('Relatorio_' + FormatDateTime('yyyymmdd_hhnnss', Now))
  else
    LCaminhoFinal := ACaminhoSaida;

  LDir := TPath.GetDirectoryName(LCaminhoFinal);
  if not TDirectory.Exists(LDir) then
    TDirectory.CreateDirectory(LDir);

  try
    AReport.PrepareReport(True);
    AReport.Export(FPDFExport);
    Result := True;
  except
    on E: Exception do
    begin
      // Log de erro pode ser adicionado aqui
      Result := False;
    end;
  end;
end;

end.
