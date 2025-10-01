unit USegurancaDadosHandler;

interface

uses
  System.SysUtils;

type
  TSegurancaDadosHandler = class
  public
    class function HashPassword(const APassword: string): string; static;
    class function VerifyPassword(const APassword, AHashedPassword: string): Boolean; static;
  end;

implementation

{ TSegurancaDadosHandler }

class function TSegurancaDadosHandler.HashPassword(const APassword: string): string;
begin
  Result := '';
end;

class function TSegurancaDadosHandler.VerifyPassword(const APassword, AHashedPassword: string): Boolean;
begin
  Result := False;
end;

end.
