unit UAceiteTermoDTO;

interface

uses
  System.SysUtils, System.DateUtils;

type
  TAceiteTermoDTO = class
  private
    FId: Integer;
    FIdUsuario: Integer;
    FDataAceite: TDateTime;
  public
    property Id: Integer read FId write FId;
    property IdUsuario: Integer read FIdUsuario write FIdUsuario;
    property DataAceite: TDateTime read FDataAceite write FDataAceite;
  end;

implementation

end.
