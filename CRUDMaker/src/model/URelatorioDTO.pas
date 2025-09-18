unit URelatorioDTO;

interface

uses
  System.Classes, System.SysUtils;

type
  // DTO Armazena apenas o identificador único do relatório.
  // As configurações reais (layout, formatação) são gerenciadas externamente
  TRelatorioDTO = class
  private
    FId: string;      // Identificador único do relatório (ex: hash)
    FTitulo: string;  // Nome/Título do relatório para exibição
    FDescricao: string; // Caso for necessário no futuro implementar uma view disso
  public
    constructor Create; overload;
    constructor Create(const AId, ATitulo: string; const ADescricao: string = ''); overload;
    property Id: string read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

constructor TRelatorioDTO.Create;  // Criar DTO vazio, exemplo quando
                                   // é criado um novo relatório
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
