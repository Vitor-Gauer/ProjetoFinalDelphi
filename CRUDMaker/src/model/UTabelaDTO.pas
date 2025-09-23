unit UTabelaDTO;

interface

uses
  System.Classes;

type
  /// DTO para uma Tabela individual dentro de uma Planilha.
  TTabelaDTO = class(TPersistent)
  private
    FTitulo: string;
    FCaminhoArquivoXML: string;
    FID: Integer; // Para armazenar o ID da tabela durante o carregamento
  public
    constructor Create; virtual;
    property Titulo: string read FTitulo write FTitulo;
    property CaminhoArquivoXML: string read FCaminhoArquivoXML write FCaminhoArquivoXML;
    property ID: Integer read FID write FID; // Somente leitura ap�s carregamento
  end;

implementation

{ TTabelaDTO }

constructor TTabelaDTO.Create;
begin
  inherited Create;
  FTitulo := '';
  FCaminhoArquivoXML := '';
  FID := -1; // Valor padr�o indicando que ainda n�o foi carregado
end;

end.
