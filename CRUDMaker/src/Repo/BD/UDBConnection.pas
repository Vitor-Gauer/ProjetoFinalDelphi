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
    procedure ConfigurarConexao; // Novo m�todo para configura��o
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
  ConfigurarConexao; // Chama o m�todo para definir os par�metros
end;

destructor TDBConnection.Destroy;
begin
  if FConnection.Connected then
    FConnection.Connected := False; // Garante desconex�o
  FConnection.Free;
  inherited;
end;

function TDBConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

// --- Novo M�todo ---
procedure TDBConnection.ConfigurarConexao;
var
  ConnectionString: string;
begin
  // Limpa par�metros anteriores
  FConnection.Params.Clear;

  // Define o Driver ID para PostgreSQL
  FConnection.Params.DriverID := 'PG';

  // Adiciona os par�metros de conex�o como strings
  FConnection.Params.Add('Server=' + TConfigService.GetDatabaseHost); // Ex: localhost
  FConnection.Params.Add('Port=' + TConfigService.GetDatabasePort);   // Ex: 5432
  FConnection.Params.Add('Database=' + TConfigService.GetDatabaseName); // Ex: gauer
  FConnection.Params.Add('User_Name=' + TConfigService.GetDatabaseUser); // Ex: postgres
  FConnection.Params.Add('Password=' + TConfigService.GetDatabasePassword); // Ex: sua_senha

  // Opcional: Adicionar op��es de conex�o adicionais
  // Ex: Desabilitar SSL para conex�o local (CUIDADO em produ��o!)
  FConnection.Params.Add('ConnectOptions=sslmode=disable');

  // Outras op��es comuns:
  // FConnection.Params.Add('CharacterSet=UTF8');
  // FConnection.Params.Add('FetchOptions.CursorKind=ckClient');
  // FConnection.Params.Add('FormatOptions.StrsEmpty2Null=True');

  // A string de conex�o antiga em UConfigurarBD era para outro banco,
  // ent�o n�o a usamos diretamente aqui para os par�metros espec�ficos do PG.
  // Mas poder�amos ter um campo ali com a string completa do FireDAC para PG,
  // e usar FConnection.Params.ParseStrings(TConfigService.GetPGFireDACConnectionString, True);
  // Para este exemplo, montamos manualmente usando os m�todos de configura��o.
end;

// --- M�todos para conectar/desconectar ---
procedure TDBConnection.Conectar;
begin
  if not FConnection.Connected then
  begin
    try
      FConnection.Connected := True;
      // Log ou mensagem opcional
      // ShowMessage('Conectado ao banco de dados!');
    except
      on E: Exception do
      begin
        // Trate o erro de conex�o (log, tentar novamente, fechar aplica��o)
        raise Exception.Create('Erro ao conectar ao banco de dados: ' + E.Message);
        // N�o re-lan�ar aqui se quiser lidar internamente, apenas propagar a falha
        // por exemplo, retornando um status ou mostrando uma mensagem e encerrando.
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
