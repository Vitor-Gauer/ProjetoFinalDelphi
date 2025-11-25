unit UTabelaConfiguracaoDTO;

interface

uses
  System.Classes, System.SysUtils;

type
  TTipoCabecalho = (tcLinha, tcColuna);
  TConfiguracaoTabelaDTO = class
  private
    FNumLinhas: Integer;
    FNumColunas: Integer;
    FTipoCabecalho: TTipoCabecalho;
    FPlanilhaNome: string;
  public
    constructor Create; overload;
    property NumLinhas: Integer read FNumLinhas write FNumLinhas;
    property NumColunas: Integer read FNumColunas write FNumColunas;
    property TipoCabecalho: TTipoCabecalho read FTipoCabecalho write FTipoCabecalho;
    property PlanilhaNome: string read FPlanilhaNome write FPlanilhaNome;
  end;

implementation

constructor TConfiguracaoTabelaDTO.Create;
begin
  inherited Create;
  FNumLinhas := 0;
  FNumColunas := 0;
  FTipoCabecalho := tcLinha;
  FPlanilhaNome := '';
end;

end.
