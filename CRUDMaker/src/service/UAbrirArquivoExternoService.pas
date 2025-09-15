unit UAbrirArquivoExternoService;

interface

uses
  System.SysUtils, Winapi.ShellAPI, Winapi.Windows;

type
  TAbrirArquivoExternoService = class
  public
    constructor Create;
    destructor Destroy; override;

    /// Abre um arquivo usando o aplicativo padrão do sistema.
    // <param name="ACaminhoArquivo"> Caminho completo do arquivo a ser aberto.</param>
    // <returns> True se o comando foi enviado com sucesso, False em caso de erro.</returns>
    function AbrirArquivo(const ACaminhoArquivo: string): Boolean;
  end;

implementation

{ TAbrirArquivoExternoService }

constructor TAbrirArquivoExternoService.Create;
begin
  inherited;
end;

destructor TAbrirArquivoExternoService.Destroy;
begin
  inherited;
end;

function TAbrirArquivoExternoService.AbrirArquivo(const ACaminhoArquivo: string): Boolean;
var
  Ret: HINST;
begin
  Result := False;
  if not FileExists(ACaminhoArquivo) then
  begin
    // ShowMessage('Arquivo não encontrado: ' + ACaminhoArquivo);
    Exit;
  end;

  Ret := ShellExecute(0, 'open', PChar(ACaminhoArquivo), nil, nil, SW_SHOWNORMAL);
  Result := Ret > 32; // ShellExecute retorna > 32 se bem-sucedido
  if not Result then
  begin
    // ShowMessage('Erro ao abrir o arquivo: ' + SysErrorMessage(GetLastError));
  end;
end;

end.
