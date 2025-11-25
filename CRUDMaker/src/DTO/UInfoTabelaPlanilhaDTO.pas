unit UInfoTabelaPlanilhaDTO;

interface

uses
  System.Classes;

type
  TInfoTabelaPlanilhaDTO = class
  public
    Nome: string;
    Dimensoes: string;
    TamanhoMB: string;
    Formato: string;
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
