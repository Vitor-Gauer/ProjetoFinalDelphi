unit URelatorioDTO;

interface

uses
  System.SysUtils;

type
  TRelatorioDTO = class
  private
    FId: string; // ID único do relatório (ex: hash ou nome do arquivo de configuração)
    FTitulo: string; // Título do relatório
    FDescricao: string; // Descrição (opcional)
    FNomeArquivo: string; // Nome do arquivo XML de configuração (ex: "Titulo_Tipo.xml")
  public
    constructor Create; overload;
    constructor Create(const AId, ATitulo: string; const ADescricao: string = ''); overload;

    property Id: string read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
    property NomeArquivo: string read FNomeArquivo write FNomeArquivo;
  end;

implementation

{ TRelatorioDTO }

constructor TRelatorioDTO.Create;
begin
  inherited Create;
  FId := '';
  FTitulo := '';
  FDescricao := '';
  FNomeArquivo := '';
end;

constructor TRelatorioDTO.Create(const AId, ATitulo: string; const ADescricao: string = '');
begin
  Create; // Chama o construtor padrão
  FId := AId;
  FTitulo := ATitulo;
  FDescricao := ADescricao;
  FNomeArquivo := AId + '.xml'; // Exemplo: ID como base para nome de arquivo
end;

end.
