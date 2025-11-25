unit UConfigurarBD;

interface

uses
  System.SysUtils;

type
  TConfigService = class
  public
    class function GetDatabaseConnectionString: string; static;
    class function GetServerAddress: string; static;
    class function GetDatabaseName: string; static;
    class function GetDatabaseUser: string; static;
    class function GetDatabasePassword: string; static;
    class function GetDatabaseHost: string; static;
    class function GetDatabasePort: string; static;
  end;

implementation

{ TConfigService }

class function TConfigService.GetDatabaseConnectionString: string;
begin
  Result := 'FIRE_DAC_PG_CONFIG';
end;

class function TConfigService.GetServerAddress: string;
begin
  Result := 'http://localhost:8080';
end;

class function TConfigService.GetDatabaseName: string;
begin
  Result := 'gauer';
end;

class function TConfigService.GetDatabaseUser: string;
begin
  Result := 'postgres';
end;

class function TConfigService.GetDatabasePassword: string;
begin
  Result := 'root';
end;

class function TConfigService.GetDatabaseHost: string;
begin
  Result := 'localhost';
end;

class function TConfigService.GetDatabasePort: string;
begin
  Result := '5432';
end;

end.
