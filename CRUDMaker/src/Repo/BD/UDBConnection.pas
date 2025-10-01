unit UDBConnection;

interface

uses
  System.SysUtils, System.Classes,
  // Units FireDAC essenciais para a conex�o
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Comp.Client;

type
  TDBConnection = class
  private
    FConnection: TFDConnection;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TFDConnection;
  end;

implementation

{ TDBConnection }

constructor TDBConnection.Create;
begin
  inherited;
  FConnection := TFDConnection.Create(nil);
  // Inicializa��o e configura��o da conex�o aqui
end;

destructor TDBConnection.Destroy;
begin
  FConnection.Free;
  inherited;
end;

function TDBConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

end.
