unit UJSONDataHandler;

interface

uses
  System.JSON, System.SysUtils;

type
  TJSONDataHandler = class
  public
    // Restrição de tipo: a serialização pode funcionar com qualquer tipo, então não precisamos de restrição
    class function Serialize<T>(AObject: T): string; static;

    // Restrição de tipo: 'T' deve ser uma classe para que 'nil' e 'T.Create' sejam válidos
    class function Deserialize<T: class>(AJson: string): T; static;
  end;

implementation

{ TJSONDataHandler }

class function TJSONDataHandler.Serialize<T>(AObject: T): string;
begin
  // A lógica de serialização entraria aqui
  Result := '';
end;

class function TJSONDataHandler.Deserialize<T>(AJson: string): T;
begin
  // A lógica de deserialização entraria aqui
  Result := nil;
end;

end.
