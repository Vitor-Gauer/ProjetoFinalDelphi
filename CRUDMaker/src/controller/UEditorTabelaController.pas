unit UEditorTabelaController;

interface

uses
  System.SysUtils, UTabelaDTO, UEditarTabelaService, UXMLService, Data.DB, Datasnap.DBClient, VCL.Dialogs;

type
  TEditorTabelaController = class
  private
    FService: TEditarTabelaService;
    FXMLService: TXMLService;
  public
    constructor Create;
    destructor Destroy; override;

    // Inicia o processo de carregamento de uma tabela.
    function CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;

    // Inicia o processo de salvamento de uma tabela.
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
    if FService.ValidarDados(TClientDataSet(ADataSet)) then // Assume que � TClientDataSet
    begin
      // 2. Se v�lido, chama o service para salvar (inicia o processo)
      FService.Salvar(ATabelaDTO, TClientDataSet(ADataSet));
      Result := True; // Indica que a etapa de valida��o/salvamento inicial foi bem
    end;
    // Se n�o for v�lido, o service j� mostrou o erro. O controller retorna False.
  except
    on E: Exception do
    begin
      ShowMessage('Erro durante o processo de salvamento: ' + E.Message);
      // Result j� � False
    end;
  end;
end;

end.
