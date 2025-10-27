unit UTabelaConfiguracaoDTO;

interface

uses
  System.Classes, System.SysUtils;

type
  // Enum para definir o tipo de cabeçalho da tabela.
  TTipoCabecalho = (tcLinha, tcColuna);

  // DTO para transportar as configurações iniciais da tabela durante o processo de criação.
  TConfiguracaoTabelaDTO = class
  private
    FNumLinhas: Integer;
    FNumColunas: Integer;
    FTipoCabecalho: TTipoCabecalho;
    FPlanilhaNome: string;
  public
    constructor Create; overload;
    // constructor Create(AConfig: TConfiguracaoTabela); overload; // Se precisar copiar de outra config
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

// constructor TConfiguracaoTabelaDTO.Create(AConfig: TConfiguracaoTabela);
// begin
//   inherited Create;
//   FNumLinhas := AConfig.NumLinhas;
//   FNumColunas := AConfig.NumColunas;
//   FTipoCabecalho := AConfig.TipoCabecalho;
//   FPlanilhaNome := AConfig.PlanilhaNome;
// end;

end.
