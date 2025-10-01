unit UTabelaDTO;

interface

uses
  System.Classes, System.SysUtils;

type
  TTabelaDTO = class
  private
    FTitulo: string;
    FCaminhoArquivoXML: string;
    FCaminhoArquivoCSV: string;
    FHashXML: string;          // Hash único para o conteúdo XML (20 chars, 5+++ letras)
    FHashCSV: string;          // Hash único para o conteúdo CSV (20 números)
  public
    constructor Create; overload;
    constructor Create(const ATitulo: string; const ACaminhoArquivoXML: string = ''; const ACaminhoArquivoCSV: string = ''; const AHashXML: string = ''; const AHashCSV: string = ''); overload;
    property Titulo: string read FTitulo write FTitulo;
    property CaminhoArquivoXML: string read FCaminhoArquivoXML write FCaminhoArquivoXML;
    property CaminhoArquivoCSV: string read FCaminhoArquivoCSV write FCaminhoArquivoCSV;
    property HashXML: string read FHashXML write FHashXML;
    property HashCSV: string read FHashCSV write FHashCSV;
  end;

implementation

constructor TTabelaDTO.Create;
begin
  inherited Create;
  FTitulo := '';
  FCaminhoArquivoXML := '';
  FCaminhoArquivoCSV := '';
  FHashXML := '';
  FHashCSV := '';
end;

constructor TTabelaDTO.Create(const ATitulo: string; const ACaminhoArquivoXML: string = ''; const ACaminhoArquivoCSV: string = ''; const AHashXML: string = ''; const AHashCSV: string = '');
begin
  inherited Create;
  FTitulo := ATitulo;
  FCaminhoArquivoXML := ACaminhoArquivoXML;
  FCaminhoArquivoCSV := ACaminhoArquivoCSV;
  FHashXML := AHashXML;
  FHashCSV := AHashCSV;
end;

end.
