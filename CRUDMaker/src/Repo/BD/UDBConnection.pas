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
    procedure ConfigurarConexao; // Novo método para configuração
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
  ConfigurarConexao; // Chama o método para definir os parâmetros
end;

destructor TDBConnection.Destroy;
begin
  if FConnection.Connected then
    FConnection.Connected := False; // Garante desconexão
  FConnection.Free;
  inherited;
end;

function TDBConnection.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

// --- Novo Método ---
procedure TDBConnection.ConfigurarConexao;
var
  ConnectionString: string;
begin
  // Limpa parâmetros anteriores
  FConnection.Params.Clear;

  // Define o Driver ID para PostgreSQL
  FConnection.Params.DriverID := 'PG';

  // Adiciona os parâmetros de conexão como strings
  FConnection.Params.Add('Server=' + TConfigService.GetDatabaseHost); // Ex: localhost
  FConnection.Params.Add('Port=' + TConfigService.GetDatabasePort);   // Ex: 5432
  FConnection.Params.Add('Database=' + TConfigService.GetDatabaseName); // Ex: gauer
  FConnection.Params.Add('User_Name=' + TConfigService.GetDatabaseUser); // Ex: postgres
  FConnection.Params.Add('Password=' + TConfigService.GetDatabasePassword); // Ex: sua_senha

  // Opcional: Adicionar opções de conexão adicionais
  // Ex: Desabilitar SSL para conexão local (CUIDADO em produção!)
  FConnection.Params.Add('ConnectOptions=sslmode=disable');

  // Outras opções comuns:
  // FConnection.Params.Add('CharacterSet=UTF8');
  // FConnection.Params.Add('FetchOptions.CursorKind=ckClient');
  // FConnection.Params.Add('FormatOptions.StrsEmpty2Null=True');

  // A string de conexão antiga em UConfigurarBD era para outro banco,
  // então não a usamos diretamente aqui para os parâmetros específicos do PG.
  // Mas poderíamos ter um campo ali com a string completa do FireDAC para PG,
  // e usar FConnection.Params.ParseStrings(TConfigService.GetPGFireDACConnectionString, True);
  // Para este exemplo, montamos manualmente usando os métodos de configuração.
end;

// --- Métodos para conectar/desconectar ---
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
        // Trate o erro de conexão (log, tentar novamente, fechar aplicação)
        raise Exception.Create('Erro ao conectar ao banco de dados: ' + E.Message);
        // Não re-lançar aqui se quiser lidar internamente, apenas propagar a falha
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
