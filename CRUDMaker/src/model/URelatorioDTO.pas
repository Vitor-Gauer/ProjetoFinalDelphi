unit URelatorioDTO;

interface

uses
  System.Classes, System.SysUtils;

type
  // DTO Armazena apenas o identificador �nico do relat�rio.
  // As configura��es reais (layout, formata��o) s�o gerenciadas externamente
  TRelatorioDTO = class
  private
    FId: string;      // Identificador �nico do relat�rio (ex: hash)
    FTitulo: string;  // Nome/T�tulo do relat�rio para exibi��o
    FDescricao: string; // Caso for necess�rio no futuro implementar uma view disso
  public
    constructor Create; overload;
    constructor Create(const AId, ATitulo: string; const ADescricao: string = ''); overload;
    property Id: string read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

constructor TRelatorioDTO.Create;  // Criar DTO vazio, exemplo quando
                                   // � criado um novo relat�rio
begin
  inherited Create;
  FId := '';
  FTitulo := '';
  FDescricao := '';
end;

constructor TRelatorioDTO.Create(const AId, ATitulo: string; const ADescricao: string = '');
begin                              // Criar DTO com dados
  inherited Create;
  FId := AId;
  FTitulo := ATitulo;
  FDescricao := ADescricao;
end;

end.
