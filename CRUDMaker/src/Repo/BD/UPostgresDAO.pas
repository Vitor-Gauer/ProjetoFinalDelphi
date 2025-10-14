unit UPostgresDAO;

interface

uses
  System.SysUtils, System.Classes,
  Data.DB,
  FireDAC.Comp.Client,
  ULoginDTO;

type
  TPostgresDAO = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function AutenticarUsuario(const AUsuario, ASenha: string): Boolean;
  end;

implementation

{ TPostgresDAO }

constructor TPostgresDAO.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
  if not Assigned(FConnection) then
    raise Exception.Create('Conexão não fornecida para TPostgresDAO.');
end;

function TPostgresDAO.AutenticarUsuario(const AUsuario, ASenha: string): Boolean;
var
  Query: TFDQuery;
  SQL: string;
begin
  Result := False;
  // Opcional: Hash da senha aqui ou na camada superior
  SQL := 'SELECT "id" FROM "Usuario" WHERE "Usuario" = :pUsuario AND "Senha" = :pSenha AND "Ativo" = TRUE';

  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := SQL;
    Query.Params.ParamByName('pUsuario').AsString := AUsuario;
    Query.Params.ParamByName('pSenha').AsString := ASenha; // Use o hash se tiver
    Query.Open;
    Result := not Query.IsEmpty;
    Query.Close;
  finally
    Query.Free;
  end;
end;

end.
