unit URelatorioConfiguracaoDTO;

interface

uses
  System.SysUtils;

type
  TTipoRelatorioDTO = (trResumo, trEventos, trAnaliseTendencia, trClassificacao, trExcecao, trPivotamento);

  // --- Tipos auxiliares ---
  TAggregacao = (aggSoma, aggMedia, aggContar, aggMinimo, aggMaximo);
  TOrdenacao = (ordCrescente, ordDecrescente);

  TConfiguracaoRelatorioDTO = class
  private
    // --- Campos Comuns ---
    FTipo: TTipoRelatorioDTO;
    FInformacoesExtras: string; // Ex: cores, estilos
    FEscopos: TArray<string>; // Ex: ["1-7", "1", "3-6"] - Escopos de colunas/linhas (não mais usado como no início, ver TRelatorioDTO)

    // --- Campos Específicos por Tipo ---
    // Campos para trResumo
    FCamposAgregacao: TArray<Integer>; // Índices das colunas a serem agregadas
    FTiposAgregacao: TArray<TAggregacao>; // Tipo de agregação para cada campo (SOMA, MEDIA, etc.)
    FCamposAgrupamento: TArray<Integer>; // Índices das colunas usadas para agrupar

    // Campos para trEventos, trClassificacao, trExcecao
    FCamposFiltro: TArray<Integer>; // Índices das colunas para critérios de filtro
    FCriteriosFiltro: TArray<string>; // Critérios de filtro (ex: ">100", "='Ativo'", "LIKE '%abc%'")
    FCamposOrdenacao: TArray<Integer>; // Índices das colunas para ordenação
    FTipoOrdenacao: TArray<TOrdenacao>; // Tipo de ordenação (Crescente, Decrescente)

    // Campos para trClassificacao
    FTopN: Integer; // Número de itens no Top N (ex: Top 10)

    // Campos para trAnaliseTendencia
    FColunaPeriodo: Integer; // Índice da coluna contendo o período (data, mês, ano)
    FColunaValor: Integer; // Índice da coluna contendo o valor a ser analisado
    FTipoComparacao: string; // Ex: "Mês a Mês", "Ano a Ano", "Variação Percentual"

    // Campos para trPivotamento
    FColunaLinhas: Integer; // Índice da coluna para os rótulos das linhas da tabela dinâmica
    FColunaColunas: Integer; // Índice da coluna para os rótulos das colunas da tabela dinâmica
    FColunaValores: Integer; // Índice da coluna contendo os valores a serem agregados na interseção
    FTipoAgregacaoPivot: TAggregacao; // Tipo de agregação usada na tabela dinâmica (SOMA, MEDIA, etc.)

  public
    // --- Propriedades Comuns ---
    property Tipo: TTipoRelatorioDTO read FTipo write FTipo;
    property InformacoesExtras: string read FInformacoesExtras write FInformacoesExtras;
    property Escopos: TArray<string> read FEscopos write FEscopos;

    // --- Propriedades Específicas ---
    // Resumo
    property CamposAgregacao: TArray<Integer> read FCamposAgregacao write FCamposAgregacao;
    property TiposAgregacao: TArray<TAggregacao> read FTiposAgregacao write FTiposAgregacao;
    property CamposAgrupamento: TArray<Integer> read FCamposAgrupamento write FCamposAgrupamento;

    // Eventos, Classificação, Exceção
    property CamposFiltro: TArray<Integer> read FCamposFiltro write FCamposFiltro;
    property CriteriosFiltro: TArray<string> read FCriteriosFiltro write FCriteriosFiltro;
    property CamposOrdenacao: TArray<Integer> read FCamposOrdenacao write FCamposOrdenacao;
    property TipoOrdenacao: TArray<TOrdenacao> read FTipoOrdenacao write FTipoOrdenacao;

    // Classificação
    property TopN: Integer read FTopN write FTopN;

    // Análise e Tendência
    property ColunaPeriodo: Integer read FColunaPeriodo write FColunaPeriodo;
    property ColunaValor: Integer read FColunaValor write FColunaValor;
    property TipoComparacao: string read FTipoComparacao write FTipoComparacao;

    // Pivotamento
    property Linhas: Integer read FColunaLinhas write FColunaLinhas;
    property Colunas: Integer read FColunaColunas write FColunaColunas;
    property Valores: Integer read FColunaValores write FColunaValores;
    property TipoAgregacaoPivot: TAggregacao read FTipoAgregacaoPivot write FTipoAgregacaoPivot;
  end;

implementation

end.
