unit UPostgresDAO;

interface

uses
  Data.DB, FireDAC.Comp.Client;

type
  TPostgresDAO = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
  end;

implementation

{ TPostgresDAO }

constructor TPostgresDAO.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

end.
