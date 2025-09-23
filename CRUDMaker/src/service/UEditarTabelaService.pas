unit UEditarTabelaService;

interface

uses
  System.SysUtils, System.Classes, UTabelaDTO, UXMLService; // Adicione Data.DB se precisar validar TClientDataSet

type
  EEditarTabelaServiceException = class(Exception);

  TEditarTabelaService = class
  private
    FXMLService: TXMLService;
  public
    constructor Create(AXMLService: TXMLService);
    /// <summary>
    /// Carrega os dados de uma tabela do XML para o DTO.
    /// </summary>
    function Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
    /// <summary>
    /// Salva os dados de uma tabela do DTO para o XML.
    /// </summary>
    procedure Salvar(ATabelaDTO: TTabelaDTO);
  end;

implementation

{ TEditarTabelaService }

constructor TEditarTabelaService.Create(AXMLService: TXMLService);
begin
  inherited Create;
  FXMLService := AXMLService;
end;

function TEditarTabelaService.Carregar(ATabelaDTO: TTabelaDTO): TTabelaDTO;
begin
  if not Assigned(ATabelaDTO) then
    raise EEditarTabelaServiceException.Create('DTO da tabela n�o pode ser nulo.');

  if (ATabelaDTO.CaminhoArquivoXML = '') or not FileExists(ATabelaDTO.CaminhoArquivoXML) then
    raise EEditarTabelaServiceException.Create('Caminho do arquivo XML inv�lido ou arquivo n�o encontrado.');

  // Valida��o de seguran�a b�sica (exemplo simples)
  if Pos('..\', ATabelaDTO.CaminhoArquivoXML) > 0 then
    raise EEditarTabelaServiceException.Create('Caminho do arquivo cont�m sequ�ncia inv�lida.');

  // Chama o XMLService para ler e parsear o arquivo
  // O XMLService preencher� o DTO com os dados (t�tulo, ID, etc.)
//  FXMLService.LerArquivoXML(ATabelaDTO); // Assumindo que LerArquivoXML modifica o DTO passado

  Result := ATabelaDTO; // Retorna o DTO atualizado
end;

procedure TEditarTabelaService.Salvar(ATabelaDTO: TTabelaDTO);
begin
  if not Assigned(ATabelaDTO) then
    raise EEditarTabelaServiceException.Create('DTO da tabela n�o pode ser nulo.');

  if ATabelaDTO.Titulo = '' then
    raise EEditarTabelaServiceException.Create('O t�tulo da tabela n�o pode estar vazio.');

  // Outras valida��es: tamanho do t�tulo, caracteres especiais, etc.

  // Chama o XMLService para salvar o DTO em XML
//  FXMLService.SalvarArquivoXML(ATabelaDTO); // Assumindo que SalvarArquivoXML usa os dados do DTO
end;

end.
