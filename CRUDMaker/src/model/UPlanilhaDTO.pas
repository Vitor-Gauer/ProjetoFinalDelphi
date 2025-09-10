unit UPlanilhaDTO;

interface

uses
  System.SysUtils;

type
  TPlanilhaDTO = class
  private
    FId: Integer;
    FTitulo: string;
    FCaminhosArquivosXML: string;
  public
    property Id: Integer read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Caminhos: string read FCaminhosArquivosXML write FCaminhosArquivosXML;
  end;

implementation

end.
