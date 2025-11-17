unit UAssociacaoDTO;

interface

uses
  System.SysUtils, System.Generics.Collections;

type
  TAssociacaoTabelaRelatorioItemDTO = class
  private
    FTabelaNome: string; // Nome da tabela envolvida
    FRelatorioNome: string; // Nome do relatório aplicado
    FPosicaoResultadoLinhas: string; // Ex: "1-10" ou "15-25" - Onde no layout final o resultado vai
    FPosicaoResultadoColunas: string; // Ex: "1-3" ou "5-7" - Onde no layout final o resultado vai
    FTipoCabecalho: string; // Ex: "tcLinha", "tcColuna", "tcNenhum" - Como usar a primeira linha/coluna DO RESULTADO
  public
    property TabelaNome: string read FTabelaNome write FTabelaNome;
    property RelatorioNome: string read FRelatorioNome write FRelatorioNome;
    property PosicaoResultadoLinhas: string read FPosicaoResultadoLinhas write FPosicaoResultadoLinhas;
    property PosicaoResultadoColunas: string read FPosicaoResultadoColunas write FPosicaoResultadoColunas;
    property TipoCabecalho: string read FTipoCabecalho write FTipoCabecalho;
  end;

  // DTO principal para representar uma associação complexa entre várias tabelas e relatórios
  TAssociacaoDTO = class
  private
    FNomeAssociacao: string; // Nome do arquivo de associação
    FItens: TObjectList<TAssociacaoTabelaRelatorioItemDTO>; // Lista de mapeamentos Tabela->Relatório->Posição
    FCaminhoPDFSaida: string; // Caminho onde o PDF final gerado será salvo
  public
    constructor Create;
    destructor Destroy; override;

    property NomeAssociacao: string read FNomeAssociacao write FNomeAssociacao;
    property Itens: TObjectList<TAssociacaoTabelaRelatorioItemDTO> read FItens;
    property CaminhoPDFSaida: string read FCaminhoPDFSaida write FCaminhoPDFSaida;
  end;

implementation

{ TAssociacaoDTO }

constructor TAssociacaoDTO.Create;
begin
  inherited Create;
  FItens := TObjectList<TAssociacaoTabelaRelatorioItemDTO>.Create(True); // OwnsObjects = True
end;

destructor TAssociacaoDTO.Destroy;
begin
  FItens.Free;
  inherited;
end;

end.
