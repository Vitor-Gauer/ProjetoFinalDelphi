unit UTabelasRelatoriosDTO;

interface

uses
  System.Classes, System.SysUtils, UTabelaDTO, URelatorioDTO;

type
  TTabelasRelatoriosDTO = class
  private
    FHashTabelaOrigem: string;
    FIdRelatorio: string;
  public
    constructor Create; overload;
    constructor Create(const AHashTabelaOrigem, AIdRelatorio: string); overload;
    property HashTabelaOrigem: string read FHashTabelaOrigem write FHashTabelaOrigem;
    property IdRelatorio: string read FIdRelatorio write FIdRelatorio;
  end;

implementation

constructor TTabelasRelatoriosDTO.Create;
begin
  inherited Create;
  FHashTabelaOrigem := '';
  FIdRelatorio := '';
end;

constructor TTabelasRelatoriosDTO.Create(const AHashTabelaOrigem, AIdRelatorio: string);
begin
  inherited Create;
  FHashTabelaOrigem := AHashTabelaOrigem;
  FIdRelatorio := AIdRelatorio;
end;

end.
