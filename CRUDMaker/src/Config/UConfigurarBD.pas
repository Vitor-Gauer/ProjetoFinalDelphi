unit UConfigurarBD;

interface

uses
  System.SysUtils;

type
  TConfigService = class
  public
    class function GetDatabaseConnectionString: string; static;
    class function GetServerAddress: string; static;
    // Adicione outras configura��es relevantes
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
  // ATEN��O: ESTA STRING � PARA OUTROS TIPOS DE BANCO!
  // Result := 'Server=localhost;Port=5432;Database=crudmaker;User=postgres;Password=root;';
  // Para PostgreSQL via FireDAC, a string de conex�o � montada internamente no TDBConnection
  // usando os m�todos GetDatabase* abaixo.
  // Esta fun��o pode ser usada para outros fins ou mantida para compatibilidade futura.
  // Por enquanto, vamos retornar uma string vazia ou um identificador.
  Result := 'FIRE_DAC_PG_CONFIG'; // Marcador
end;

class function TConfigService.GetServerAddress: string;
begin
  Result := 'http://localhost:8080'; // Mant�m como est�
end;

// --- Novos m�todos para configura��o do PostgreSQL ---
class function TConfigService.GetDatabaseName: string;
begin
  Result := 'gauer';
end;

class function TConfigService.GetDatabaseUser: string;
begin
  Result := 'postgres'; // Substitua pelo usu�rio correto
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
