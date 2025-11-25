unit URelatorioDTO;

interface

uses
  System.Classes, System.SysUtils;

type
  TRelatorioDTO = class
  private
    FId: string;
    FTitulo: string;
    FDescricao: string;
  public
    constructor Create; overload;
    constructor Create(const AId, ATitulo: string; const ADescricao: string = ''); overload;
    property Id: string read FId write FId;
    property Titulo: string read FTitulo write FTitulo;
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

constructor TRelatorioDTO.Create;
begin
  inherited Create;
  FId := '';
  FTitulo := '';
  FDescricao := '';
end;

constructor TRelatorioDTO.Create(const AId, ATitulo: string; const ADescricao: string = '');
begin
  inherited Create;
  FId := AId;
  FTitulo := ATitulo;
  FDescricao := ADescricao;
end;

end.
