unit UInfoTabelaPlanilhaDTO;

interface

uses
  System.Classes;

type
  // DTO para transportar informacoes resumidas de uma tabela dentro de uma planilha.
  // Usado, por exemplo, para exibir listas de tabelas com dimensoes/tamanhos na UI.
  TInfoTabelaPlanilhaDTO = class
  public
    // Nome da tabela (geralmente o nome da pasta que a contem).
    Nome: string;

    // Dimensoes da tabela no formato "LinhasxColunas" (ex: "100x50").
    // Pode conter mensagens de erro se a obtencao falhar.
    Dimensoes: string;

    // Tamanho do arquivo associado (CSV ou XML) formatado em Megabytes (ex: "2.50 MB").
    // Pode conter mensagens de erro.
    TamanhoMB: string;

    // Formato de origem primaria dos dados: 'CSV' ou 'XML'.
    // Indica qual arquivo foi usado para obter as informacoes.
    Formato: string;

    // Caminho completo do arquivo (.csv ou .xml) utilizado para obter as informacoes.
    CaminhoArquivo: string;

    constructor Create(const ANome, ADimensoes, ATamanhoMB, AFormato, ACaminho: string);
  end;

implementation

{ TInfoTabelaPlanilhaDTO }

constructor TInfoTabelaPlanilhaDTO.Create(const ANome, ADimensoes, ATamanhoMB, AFormato, ACaminho: string);
begin
  inherited Create;
  Nome := ANome;
  Dimensoes := ADimensoes;
  TamanhoMB := ATamanhoMB;
  Formato := AFormato;
  CaminhoArquivo := ACaminho;
end;

end.
