unit UEditorTabelaController;

interface

uses
  System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Dialogs,
  UTabelaDTO, UEditarTabelaService, UXMLService, UCSVService;

type
  TEditorTabelaController = class
  private
    FService: TEditarTabelaService;
    FXMLService: TXMLService;
    FCSVService: TCSVService;
  public
    constructor Create;
    destructor Destroy; override;
    function CarregarTabela(var ATabelaDTO: TTabelaDTO; ADataSet: TDataSet): Boolean;
    function ExecutarSalvarTabela(ATabelaDTO: TTabelaDTO; ADataSet: TDataSet): Boolean;
  end;

implementation

uses
  System.IOUtils, Vcl.Forms; // Para TFile, TOpenDialog

{ TEditorTabelaController }

constructor TEditorTabelaController.Create;
begin
  inherited Create;
  // Cria instâncias dos serviços necessários
  FXMLService := TXMLService.Create;
  FCSVService := TCSVService.Create;
  // Injeta o XMLService no serviço de edição (se ele o utiliza internamente)
  FService := TEditarTabelaService.Create(FXMLService);
end;

destructor TEditorTabelaController.Destroy;
begin
  // Libera os recursos alocados
  FService.Free;
  FCSVService.Free;
  FXMLService.Free;
  inherited;
end;

function TEditorTabelaController.CarregarTabela(var ATabelaDTO: TTabelaDTO; ADataSet: TDataSet): Boolean;
var
  CaminhoArquivo: string;
  FileExt: string;
  OpenDialog: TOpenDialog;
begin
  Result := False; // Assume falha inicialmente

  // 1. Validar parâmetros de entrada
  if not Assigned(ADataSet) or not (ADataSet is TClientDataSet) then
  begin
    ShowMessage('DataSet inválido ou não é um TClientDataSet.');
    Exit;
  end;
  // Se ATabelaDTO for nil, o controller pode criar um ou exigir que a View passe um.
  // Para simplificar, vamos assumir que a View passa um (potencialmente vazio).
  // Se for nil, podemos criar um aqui:
  if not Assigned(ATabelaDTO) then
    ATabelaDTO := TTabelaDTO.Create;

  // 2. Determinar o caminho do arquivo
  CaminhoArquivo := ATabelaDTO.CaminhoArquivoXML; // Pode estar vazio

  if (CaminhoArquivo = '') or not TFile.Exists(CaminhoArquivo) then
  begin
    // Caminho inválido ou arquivo não existe, solicitar ao usuário
    OpenDialog := TOpenDialog.Create(nil);
    try
      OpenDialog.Filter := 'Arquivos de Dados (XML/CSV)|*.xml;*.csv|XML Files (*.xml)|*.xml|CSV Files (*.csv)|*.csv|All Files (*.*)|*.*';
      OpenDialog.DefaultExt := 'xml';
      OpenDialog.Title := 'Selecione o arquivo XML ou CSV para carregar';
      if OpenDialog.Execute then
        CaminhoArquivo := OpenDialog.FileName
      else
      begin
        // Usuário cancelou a seleção
        Exit; // Result continua False
      end;
    finally
      OpenDialog.Free;
    end;
  end;

  if not TFile.Exists(CaminhoArquivo) then
  begin
    ShowMessage('Arquivo não encontrado: ' + CaminhoArquivo);
    Exit;
  end;

  FileExt := LowerCase(ExtractFileExt(CaminhoArquivo));
  TClientDataSet(ADataSet).Close; // Garante que o dataset esteja fechado antes

  try
    // 3. Carregar dados com base na extensão
    if FileExt = '.xml' then
    begin
      if Assigned(FXMLService) then
      begin
        FXMLService.LerXML(TClientDataSet(ADataSet), CaminhoArquivo);
        Result := True;
      end
      else
        raise Exception.Create('Serviço XML não disponível.');
    end
    else if FileExt = '.csv' then
    begin
      if Assigned(FCSVService) then
      begin
        FCSVService.LerCSV(TClientDataSet(ADataSet), CaminhoArquivo);
        Result := True;
      end
      else
        raise Exception.Create('Serviço CSV não disponível.');
    end
    else
    begin
      ShowMessage('Formato de arquivo não suportado: ' + FileExt);
      Exit; // Result continua False
    end;

    // 4. Atualizar DTO em caso de sucesso
    if Result then
    begin
      // Atualiza o caminho no DTO (mesmo que tenha sido selecionado pelo diálogo)
      ATabelaDTO.CaminhoArquivoXML := CaminhoArquivo;
      // O título pode ser inferido do nome do arquivo, se desejado
      // ATabelaDTO.Titulo := ChangeFileExt(ExtractFileName(CaminhoArquivo), '');
    end;

  except
    on E: Exception do
    begin
      ShowMessage('Erro ao carregar o arquivo "' + CaminhoArquivo + '": ' + E.Message);
      TClientDataSet(ADataSet).Close; // Garante que fique fechado em caso de erro
      Result := False; // Garante o retorno False
    end;
  end;
end;

function TEditorTabelaController.ExecutarSalvarTabela(ATabelaDTO: TTabelaDTO; ADataSet: TDataSet): Boolean;
begin
  Result := False;
  try
    // 1. Validar parâmetros e dataset
    if not Assigned(ATabelaDTO) then
    begin
      ShowMessage('DTO da tabela não fornecido para salvamento.');
      Exit;
    end;
    if not Assigned(ADataSet) or not (ADataSet is TClientDataSet) then
    begin
      ShowMessage('DataSet inválido ou não é um TClientDataSet.');
      Exit;
    end;

    // 2. Chama o service para validar os dados
    if FService.ValidarDados(TClientDataSet(ADataSet)) then
    begin
      // 3. Se válido, chama o service para salvar (inicia o processo)
      FService.Salvar(ATabelaDTO, TClientDataSet(ADataSet));
      Result := True; // Indica que a etapa de validação/salvamento inicial foi bem
    end;
    // Se não for válido, o service já mostrou o erro. O controller retorna False.
  except
    on E: Exception do
    begin
      ShowMessage('Erro durante o processo de salvamento: ' + E.Message);
      // Result já é False
    end;
  end;
end;

end.
