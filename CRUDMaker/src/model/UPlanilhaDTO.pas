unit UPlanilhaDTO;

interface

uses
  System.SysUtils;

type
  TPlanilhaDTO = class
  private
    FId: Integer;
    FTitulo: string;
    FCaminhoDiretorio: string;
  public
    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Caminho: string read FCaminhoDiretorio write FCaminhoDiretorio;
  end;

implementation

end.
