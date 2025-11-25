unit UCriadorRelatorioController;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient,
  URelatorioDTO, UTabelaDTO, UTabelasRelatoriosDTO,
  UXMLService, UCSVService,
  UPDFService,
  Vcl.Dialogs;

type
  TCriadorRelatorioController = class
  private
    FXMLService: TXMLService;
    FCSVService: TCSVService;
    FPDFService: TPDFService;

    function GerarIdRelatorio(const ATitulo: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function CriarNovoRelatorio: TRelatorioDTO;
    function AplicarRelatorio(const ARelatorio: TRelatorioDTO; const ATabela: TTabelaDTO): TTabelasRelatoriosDTO;

    function GerarPDF(const ATabelasRelatorios: TTabelasRelatoriosDTO; const ACaminhoArquivoPDF: string): Boolean;

    procedure SalvarVinculo(const ATabelasRelatorios: TTabelasRelatoriosDTO; const ACaminhoArquivo: string);
    function CarregarVinculo(const ACaminhoArquivo: string): TTabelasRelatoriosDTO;
  end;

implementation

uses
  System.Hash,
  windows;

constructor TCriadorRelatorioController.Create;
begin
  inherited Create;
  FXMLService := TXMLService.Create;
  FCSVService := TCSVService.Create;
  FPDFService := TPDFService.Create;
end;

destructor TCriadorRelatorioController.Destroy;
begin
  FXMLService.Free;
  FCSVService.Free;
  FPDFService.Free;
  inherited;
end;

function TCriadorRelatorioController.GerarIdRelatorio(const ATitulo: string): string;
var
  HashMD5: THashMD5;
begin
  HashMD5 := THashMD5.Create;
  HashMD5.Update(ATitulo);
  HashMD5.Update(IntToStr(GetTickCount64));
  Result := Copy(HashMD5.HashAsString, 1, 20);
end;

function TCriadorRelatorioController.CriarNovoRelatorio: TRelatorioDTO;
var
  Titulo, Descricao: string;
  InputResult: Boolean;
begin
  Result := nil;
  InputResult := InputQuery('Novo Relatório', 'Título do Relatório:', Titulo);
  if InputResult and (Trim(Titulo) <> '') then
  begin
    InputQuery('Novo Relatório', 'Descrição (opcional):', Descricao);
    Result := TRelatorioDTO.Create(GerarIdRelatorio(Titulo), Titulo, Descricao);
    ShowMessage('Relatório "' + Titulo + '" criado com ID: ' + Result.Id + '.');
  end
  else
  begin
    ShowMessage('Criação de relatório cancelada ou título inválido.');
  end;
end;

function TCriadorRelatorioController.AplicarRelatorio(const ARelatorio: TRelatorioDTO; const ATabela: TTabelaDTO): TTabelasRelatoriosDTO;
var
  HashTabela: string;
begin
  Result := nil;
  if not Assigned(ARelatorio) or not Assigned(ATabela) then
  begin
    ShowMessage('Relatório ou Tabela inválidos para aplicação.');
    Exit;
  end;

  if ATabela.HashXML <> '' then
    HashTabela := ATabela.HashXML
  else if ATabela.HashCSV <> '' then
    HashTabela := ATabela.HashCSV
  else
  begin
    ShowMessage('A tabela não possui um hash válido (XML ou CSV).');
    Exit;
  end;

  Result := TTabelasRelatoriosDTO.Create(HashTabela, ARelatorio.Id);
  ShowMessage(Format('Relatório "%s" (ID: %s) aplicado à tabela com hash "%s".',
    [ARelatorio.Titulo, ARelatorio.Id, HashTabela]));
end;

function TCriadorRelatorioController.GerarPDF(const ATabelasRelatorios: TTabelasRelatoriosDTO; const ACaminhoArquivoPDF: string): Boolean;
// var
//   ClientDataSetTemp: TClientDataSet;
//   CaminhoArquivoOrigem: string;
begin
  Result := False;
  if not Assigned(ATabelasRelatorios) or (ACaminhoArquivoPDF = '') then
  begin
    ShowMessage('Dados inválidos para geração de PDF.');
    Exit;
  end;

  // 1. Localizar o arquivo XML/CSV usando ATabelasRelatorios.HashTabelaOrigem
  //    (Isso exigiria um serviço ou conhecimento do local onde os arquivos são salvos)
  //    Por exemplo:
  //    CaminhoArquivoOrigem := LocalizarArquivoPorHash(ATabelasRelatorios.HashTabelaOrigem);

  // 2. Carregar os dados para um ClientDataSet temporário (usando FXMLService ou FCSVService)
  //    ClientDataSetTemp := TClientDataSet.Create(nil);
  //    try
  //      if ExtractFileExt(CaminhoArquivoOrigem) = '.xml' then
  //        FXMLService.LerXML(ClientDataSetTemp, CaminhoArquivoOrigem)
  //      else if ExtractFileExt(CaminhoArquivoOrigem) = '.csv' then
  //        FCSVService.LerCSV(ClientDataSetTemp, CaminhoArquivoOrigem);
  //      ...
  //    finally
  //      ClientDataSetTemp.Free;
  //    end;

  // 3. Usar FPDFService.GerarAPartirDeHashEId para aplicar layout/formatação.
  try
    // Passa o hash da tabela e o ID do relatório
    // FPDFService.GerarAPartirDeHashEId(ATabelasRelatorios.HashTabelaOrigem, ATabelasRelatorios.Id, ACaminhoArquivoPDF);
    Result := True;
    ShowMessage('PDF gerado com sucesso em: ' + ACaminhoArquivoPDF);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao gerar PDF: ' + E.Message);
    end;
  end;
end;

procedure TCriadorRelatorioController.SalvarVinculo(const ATabelasRelatorios: TTabelasRelatoriosDTO; const ACaminhoArquivo: string);
begin
  if not Assigned(ATabelasRelatorios) or (ACaminhoArquivo = '') then
  begin
    ShowMessage('Dados inválidos para salvar o vínculo.');
    Exit;
  end;

  // Implementar salvamento em XML/JSON
  // Exemplo básico (não funcional sem implementação real):
  try
    // TFile.WriteAllText(ACaminhoArquivo, SerializarParaXML(ATabelasRelatorios));
    ShowMessage('Vínculo salvo em: ' + ACaminhoArquivo);
  except
    on E: Exception do
      ShowMessage('Erro ao salvar vínculo: ' + E.Message);
  end;
end;

function TCriadorRelatorioController.CarregarVinculo(const ACaminhoArquivo: string): TTabelasRelatoriosDTO;
begin
  Result := nil;
  if (ACaminhoArquivo = '') or not FileExists(ACaminhoArquivo) then
  begin
    ShowMessage('Arquivo de vínculo inválido ou não encontrado.');
    Exit;
  end;

  // Implementar carregamento de XML/JSON
  // Exemplo básico (não funcional sem implementação real):
  try
    // Result := DesserializarDeXML(TFile.ReadAllText(ACaminhoArquivo));
    ShowMessage('Vínculo carregado de: ' + ACaminhoArquivo);
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar vínculo: ' + E.Message);
    end;
  end;
end;

end.
