unit UDBConnection;

interface

uses
  System.SysUtils, System.Classes,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.DApt,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  UConfigurarBD;

type
  TDBConnection = class
  private
    FConnection: TFDConnection;
    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TFDConnection;
    procedure Conectar;
    procedure Desconectar;
  end;

implementation

{ TDBConnection }

constructor TDBConnection.Create;
begin
  inherited;
  FConnection := TFDConnection.Create(nil);
  ConfigurarConexao;
end;

destructor TDBConnection.Destroy;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
  FConnection.Free;
  inherited;
end;

function TDBConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

procedure TDBConnection.ConfigurarConexao;
var
  ConnectionString: string;
begin
  FConnection.Params.Clear;

  FConnection.Params.DriverID := 'PG';

  FConnection.Params.Add('Server=' + TConfigService.GetDatabaseHost); // Ex: localhost
  FConnection.Params.Add('Port=' + TConfigService.GetDatabasePort);   // Ex: 5432
  FConnection.Params.Add('Database=' + TConfigService.GetDatabaseName); // Ex: gauer
  FConnection.Params.Add('User_Name=' + TConfigService.GetDatabaseUser); // Ex: postgres
  FConnection.Params.Add('Password=' + TConfigService.GetDatabasePassword); // Ex: sua_senha

  FConnection.Params.Add('ConnectOptions=sslmode=disable');
end;
procedure TDBConnection.Conectar;
begin
  if not FConnection.Connected then
  begin
    try
      FConnection.Connected := True;
    except
      on E: Exception do
      begin
        raise Exception.Create('Erro ao conectar ao banco de dados: ' + E.Message);
      end;
    end;
  end;
end;

procedure TDBConnection.Desconectar;
begin
  if FConnection.Connected then
    FConnection.Connected := False;
end;

end.
