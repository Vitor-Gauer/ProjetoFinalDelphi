unit UTransformadorService;

interface

uses
  System.SysUtils, System.Classes, UTabelaDTO, UEditarTabelaService; // Use o record TPreparedData

type
  TTransformadorService = class
  public
    constructor Create;
    destructor Destroy; override;

    /// Gera os arquivos XML, CSV e PDF a partir dos dados preparados.
    // <param name="ATabelaDTO"> DTO com metadados da tabela.</param>
    // <param name="APreparedData"> Dados preparados pelo service de edição.</param>
    // <param name="AProgressCallback"> Callback para atualizar o progresso (opcional).</param>
    // <param name="ACancelCallback"> Callback para verificar se o usuário cancelou (opcional).</param>
    // <returns> True se todos os arquivos foram gerados com sucesso, False se cancelado ou erro.</returns>
    function GerarArquivos(ATabelaDTO: TTabelaDTO; APreparedData: TPreparedData;
      AProgressCallback: TProc<string> = nil; // Recebe mensagem de progresso
      ACancelCallback: TFunc<Boolean> = nil   // Retorna True se cancelado
      ): Boolean;

    /// Obtém os caminhos completos dos arquivos gerados.
    // <param name="ATabelaDTO"> DTO com metadados da tabela.</param>
    // <returns> Record ou array com os caminhos para XML, CSV e PDF.</returns>
    function ObterCaminhosDosArquivos(ATabelaDTO: TTabelaDTO): TArray<string>; // Ex: [XMLPath, CSVPath, PDFPath]
  end;

implementation

{ TTransformadorService }

constructor TTransformadorService.Create;
begin
  inherited;
end;

destructor TTransformadorService.Destroy;
begin
  inherited;
end;

function TTransformadorService.GerarArquivos(ATabelaDTO: TTabelaDTO; APreparedData: TPreparedData;
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

function TTransformadorService.ObterCaminhosDosArquivos(ATabelaDTO: TTabelaDTO): TArray<string>;
begin
  // Implementar lógica para determinar os caminhos dos arquivos gerados
  // Exemplo:
  SetLength(Result, 3);
  Result[0] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.xml');
  Result[1] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.csv');
  Result[2] := ChangeFileExt(ATabelaDTO.CaminhoArquivoXML, '.pdf');
end;

end.
