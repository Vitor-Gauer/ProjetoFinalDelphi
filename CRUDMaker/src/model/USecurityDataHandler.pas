unit USecurityDataHandler;

interface

uses
  System.SysUtils;

type
  TSecurityDataHandler = class
  public
    class function HashPassword(const APassword: string): string; static;
    class function VerifyPassword(const APassword, AHashedPassword: string): Boolean; static;
  end;

implementation

{ TSecurityDataHandler }

class function TSecurityDataHandler.HashPassword(const APassword: string): string;
begin
  Result := '';
end;

class function TSecurityDataHandler.VerifyPassword(const APassword, AHashedPassword: string): Boolean;
begin
  Result := False;
end;

end.
