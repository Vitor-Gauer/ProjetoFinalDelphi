unit UEditorTabelaController;

interface

uses
  System.SysUtils, UTabelaDTO, UEditarTabelaService, UXMLService, Data.DB, Datasnap.DBClient, VCL.Dialogs;

type
  /// Controlador para a funcionalidade de edição de tabelas.
  TEditorTabelaController = class
  private
    FService: TEditarTabelaService;
    FXMLService: TXMLService;
  public
    /// Construtor do controlador.
    constructor Create;

    /// Destrutor do controlador.
    destructor Destroy; override;

    /// Inicia o processo de carregamento de uma tabela.
    // <param name="ATabelaDTO"> DTO da tabela a ser carregada.</param>
    // <returns> DTO atualizado com os dados carregados.</returns>
    function CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;

    /// Inicia o processo de salvamento de uma tabela.
    // <param name="ATabelaDTO"> DTO da tabela a ser salva.</param>
    // <param name="ADataSet"> O ClientDataSet com os dados.</param>
    // <returns> True se o processo de salvamento (validação) foi iniciado com sucesso.</returns>
    function ExecutarSalvarTabela(ATabelaDTO: TTabelaDTO; ADataSet: TDataSet): Boolean;
  end;

implementation

{ TEditorTabelaController }

uses
UViewEditorTabela;

constructor TEditorTabelaController.Create;
begin
  inherited Create;
  FXMLService := TXMLService.Create;
  FService := TEditarTabelaService.Create(FXMLService); // Injeta o XMLService
end;

destructor TEditorTabelaController.Destroy;
begin
  FService.Free;
  FXMLService.Free;
  inherited;
end;

function TEditorTabelaController.CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;
begin
  Result := FService.Carregar(ATabelaDTO);
end;

function TEditorTabelaController.ExecutarSalvarTabela(ATabelaDTO: TTabelaDTO; ADataSet: TDataSet): Boolean;
begin
  Result := False;
  try
    // 1. Chama o service para validar os dados
    if FService.ValidarDados(TClientDataSet(ADataSet)) then // Assume que é TClientDataSet
    begin
      // 2. Se válido, chama o service para salvar (inicia o processo)
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
