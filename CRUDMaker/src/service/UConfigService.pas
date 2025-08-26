unit UConfigService;

interface

uses
  System.SysUtils;

type
  TConfigService = class
  public
    class function GetDatabaseConnectionString: string; static;
    class function GetServerAddress: string; static;
  end;

implementation

{ TConfigService }

class function TConfigService.GetDatabaseConnectionString: string;
begin
  Result := 'Server=localhost;Port=5432;Database=crudmaker;User=postgres;Password=root;';
end;

class function TConfigService.GetServerAddress: string;
begin
  Result := 'http://localhost:8080';
end;

end.
