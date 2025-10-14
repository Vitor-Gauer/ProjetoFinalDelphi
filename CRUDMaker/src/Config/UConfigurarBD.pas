unit UConfigurarBD;

interface

uses
  System.SysUtils;

type
  TConfigService = class
  public
    class function GetDatabaseConnectionString: string; static;
    class function GetServerAddress: string; static;
    // Adicione outras configurações relevantes
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
  // ATENÇÃO: ESTA STRING É PARA OUTROS TIPOS DE BANCO!
  // Result := 'Server=localhost;Port=5432;Database=crudmaker;User=postgres;Password=root;';
  // Para PostgreSQL via FireDAC, a string de conexão é montada internamente no TDBConnection
  // usando os métodos GetDatabase* abaixo.
  // Esta função pode ser usada para outros fins ou mantida para compatibilidade futura.
  // Por enquanto, vamos retornar uma string vazia ou um identificador.
  Result := 'FIRE_DAC_PG_CONFIG'; // Marcador
end;

class function TConfigService.GetServerAddress: string;
begin
  Result := 'http://localhost:8080'; // Mantém como está
end;

// --- Novos métodos para configuração do PostgreSQL ---
class function TConfigService.GetDatabaseName: string;
begin
  Result := 'gauer';
end;

class function TConfigService.GetDatabaseUser: string;
begin
  Result := 'postgres'; // Substitua pelo usuário correto
end;

class function TConfigService.GetDatabasePassword: string;
begin
  Result := 'root'; // Substitua pela senha correta e segura!
end;

class function TConfigService.GetDatabaseHost: string;
begin
  Result := 'localhost'; // ou o IP do servidor
end;

class function TConfigService.GetDatabasePort: string;
begin
  Result := '5432';
end;

end.
