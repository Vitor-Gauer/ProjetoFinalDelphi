unit UEditorTabelaController;

interface

uses
  System.SysUtils, UTabelaDTO, UEditarTabelaService, UCSVService, Data.DB, Datasnap.DBClient, VCL.Dialogs;

type
  TEditorTabelaController = class
  private
    FService: TEditarTabelaService;
    FCSVService: TCSVService;
  public
    constructor Create;
    destructor Destroy; override;

    // Inicia o processo de carregamento de uma tabela.
    function CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;

    // Inicia o processo de salvamento de uma tabela.
    function ExecutarSalvarTabela(ADataSet: TDataSet; ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO): Boolean;
  end;

implementation

{ TEditorTabelaController }

uses
UViewEditorTabela;

constructor TEditorTabelaController.Create;
begin
  inherited Create;
  FCSVService := TCSVService.Create;
  FService := TEditarTabelaService.Create(FCSVService); // Injeta o XMLService
end;

destructor TEditorTabelaController.Destroy;
begin
  FService.Free;
  FCSVService.Free;
  inherited;
end;

function TEditorTabelaController.CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;
begin
  Result := FService.Carregar(ATabelaDTO);
end;

function TEditorTabelaController.ExecutarSalvarTabela(ADataSet: TDataSet; ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO): Boolean;
begin
  Result := False;
  try
    // 1. Chama o service para validar os dados
    if FService.ValidarDados(ADataSet) then
    begin
      // 2. Se válido, chama o service para salvar (inicia o processo)
      FService.Salvar(ADataSet, ACaminhoArquivo, ATabelaDTO);
      Result := True; // Indica que a etapa de validação/salvamento inicial foi bem
    end;
    // Se não for válido, o service já mostrou o erro. O controller retorna False.
  except
    on E: Exception do
    begin
      ShowMessage('Erro durante o processo de salvamento: ' + E.Message);
    end;
  end;
end;

end.
