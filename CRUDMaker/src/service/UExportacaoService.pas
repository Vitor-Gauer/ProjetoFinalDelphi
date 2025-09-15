unit UExportacaoService;

interface

type
  TExportacaoService = class
  public
    procedure ExportarParaPDF(const AConteudo: string);
    procedure ExportarParaCSV(const AConteudo: string);
    procedure ExportarParaXML(const AConteudo: string);
  end;

implementation

{ TExportacaoService }

procedure TExportacaoService.ExportarParaPDF(const AConteudo: string);
begin
end;

procedure TExportacaoService.ExportarParaCSV(const AConteudo: string);
begin
end;

procedure TExportacaoService.ExportarParaXML(const AConteudo: string);
begin
end;

end.
