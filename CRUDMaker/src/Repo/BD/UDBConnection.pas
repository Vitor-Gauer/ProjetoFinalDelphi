unit UDBConnection;

interface

uses
  System.SysUtils, System.Classes,
  // Units FireDAC essenciais para a conexão
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
  // Inicialização e configuração da conexão aqui
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
