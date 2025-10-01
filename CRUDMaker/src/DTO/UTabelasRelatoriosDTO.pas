unit UTabelasRelatoriosDTO;

interface

uses
  System.Classes, System.SysUtils, UTabelaDTO, URelatorioDTO;

type
  // DTO para representar o vínculo entre uma Tabela e um Relatório.
  // Armazena o hash da tabela (XML ou CSV) e o ID do relatório a ser aplicado.
  TTabelasRelatoriosDTO = class
  private
    FHashTabelaOrigem: string;
    FIdRelatorio: string;      // ID do relatório aplicado (de TRelatorioDTO.Id)
  public
    constructor Create; overload;
    constructor Create(const AHashTabelaOrigem, AIdRelatorio: string); overload;
    property HashTabelaOrigem: string read FHashTabelaOrigem write FHashTabelaOrigem;
    property IdRelatorio: string read FIdRelatorio write FIdRelatorio;
  end;

implementation

constructor TTabelasRelatoriosDTO.Create;  // Criar um DTO do zero, ex. nova rel
begin
  inherited Create;
  FHashTabelaOrigem := '';
  FIdRelatorio := '';
end;

constructor TTabelasRelatoriosDTO.Create(const AHashTabelaOrigem, AIdRelatorio: string);
                                           // Cria um DTO com algo
begin
  inherited Create;
  FHashTabelaOrigem := AHashTabelaOrigem;
  FIdRelatorio := AIdRelatorio;
end;

end.
