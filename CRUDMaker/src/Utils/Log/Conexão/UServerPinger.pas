unit UServerPinger;     // verificar se um servidor está online
                        // em qualquer parte do código

interface

uses
  System.SysUtils;

type
  TServerPinger = class
  public
    class function IsServerOnline(const AServerAddress: string): Boolean; static;
  end;

implementation

{ TServerPinger }

class function TServerPinger.IsServerOnline(const AServerAddress: string): Boolean;
begin
  Result := False;
end;

end.
