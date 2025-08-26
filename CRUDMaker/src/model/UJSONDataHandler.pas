unit UJSONDataHandler;

interface

uses
  System.JSON, System.SysUtils;

type
  TJSONDataHandler = class
  public
    // Restri��o de tipo: a serializa��o pode funcionar com qualquer tipo, ent�o n�o precisamos de restri��o
    class function Serialize<T>(AObject: T): string; static;

    // Restri��o de tipo: 'T' deve ser uma classe para que 'nil' e 'T.Create' sejam v�lidos
    class function Deserialize<T: class>(AJson: string): T; static;
  end;

implementation

{ TJSONDataHandler }

class function TJSONDataHandler.Serialize<T>(AObject: T): string;
begin
  // A l�gica de serializa��o entraria aqui
  Result := '';
end;

class function TJSONDataHandler.Deserialize<T>(AJson: string): T;
begin
  // A l�gica de deserializa��o entraria aqui
  Result := nil;
end;

end.
