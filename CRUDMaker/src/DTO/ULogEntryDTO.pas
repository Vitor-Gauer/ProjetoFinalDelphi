unit ULogEntryDTO;

interface

uses
  System.SysUtils, System.DateUtils;

type
  TLogEntryDTO = class
  private
    FId: Integer;
    FDataHora: TDateTime;
    FDescricao: string;
  public
    property Id: Integer read FId write FId;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property Descricao: string read FDescricao write FDescricao;
  end;

implementation

end.
