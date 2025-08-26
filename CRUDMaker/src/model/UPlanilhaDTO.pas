unit UPlanilhaDTO;

interface

uses
  System.SysUtils;

type
  TPlanilhaDTO = class
  private
    FId: Integer;
    FTitulo: string;
    FConteudo: string;
  public
    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Conteudo: string read FConteudo write FConteudo;
  end;

implementation

end.
