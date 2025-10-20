unit UPersistenciaLocalService;

interface

uses
  System.SysUtils, System.Classes, UTabelaDTO, UEditarTabelaService; // Use o record TPreparedData

type
  TPersistenciaLocalService = class
  public
    constructor Create;
    destructor Destroy; override;
    function ValidarNomeGenerico(const ANome: string): Boolean;
    function GerarArquivos(ATabelaDTO: TTabelaDTO; APreparedData: TPreparedData;
      AProgressCallback: TProc<string> = nil;
      ACancelCallback: TFunc<Boolean> = nil
      ): Boolean;

    function ObterCaminhosDosArquivos(ATabelaDTO: TTabelaDTO): TArray<string>; // Ex: [XMLPath, CSVPath, PDFPath]
  end;

implementation

{ TPersistenciaLocalService }

constructor TPersistenciaLocalService.Create;
begin
  inherited;
end;

destructor TPersistenciaLocalService.Destroy;
begin
  inherited;
end;

function TPersistenciaLocalService.ValidarNomeGenerico(const ANome: string): Boolean;
begin
  Result := True; // Assume válido inicialmente

  // Validação se o nome tem caracteres inválidos para nomes de pastas/arquivos no Windows
  if (Pos('\', ANome) > 0) or (Pos('/', ANome) > 0) or
     (Pos(':', ANome) > 0) or (Pos('*', ANome) > 0) or
     (Pos('?', ANome) > 0) or (Pos('"', ANome) > 0) or
     (Pos('<', ANome) > 0) or (Pos('>', ANome) > 0) or
     (Pos('|', ANome) > 0) then
  begin
    Result := False;
    Exit;
  end;
end;

function TPersistenciaLocalService.GerarArquivos(ATabelaDTO: TTabelaDTO; APreparedData: TPreparedData;
  AProgressCallback: TProc<string>; ACancelCallback: TFunc<Boolean>): Boolean;
var
  i: Integer;
begin
  Result := False;
  try
    // Simular processo de geração
    if Assigned(AProgressCallback) then AProgressCallback('Iniciando geração de arquivos...');

    for i := 1 to 3 do // Simula 3 etapas
    begin
      if Assigned(ACancelCallback) and ACancelCallback() then
      begin
        if Assigned(AProgressCallback) then AProgressCallback('Processo cancelado pelo usuário.');
        Exit(False); // Retorna False se cancelado
      end;
      case i of
        1: if Assigned(AProgressCallback) then AProgressCallback('Gerando XML...');
        2: if Assigned(AProgressCallback) then AProgressCallback('Gerando CSV...');
        3: if Assigned(AProgressCallback) then AProgressCallback('Gerando PDF...');
      end;
      Sleep(1000); // Simula trabalho
    end;

    if Assigned(AProgressCallback) then AProgressCallback('Arquivos gerados com sucesso.');
    Result := True; // Indica sucesso
  except
    on E: Exception do
    begin
      if Assigned(AProgressCallback) then AProgressCallback('Erro ao gerar arquivos: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TPersistenciaLocalService.ObterCaminhosDosArquivos(ATabelaDTO: TTabelaDTO): TArray<string>;
begin
  // Implementar lógica para determinar os caminhos dos arquivos gerados
  // Exemplo:
  SetLength(Result, 3);
  Result[0] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.xml');
  Result[1] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.csv');
  Result[2] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.pdf');
end;

end.
