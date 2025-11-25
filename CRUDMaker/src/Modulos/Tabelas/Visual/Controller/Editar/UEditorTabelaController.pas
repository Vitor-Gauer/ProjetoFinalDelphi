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

    function CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;
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
  FService := TEditarTabelaService.Create(FCSVService);
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
    if FService.ValidarDados(ADataSet) then
    begin
      FService.Salvar(ADataSet, ACaminhoArquivo, ATabelaDTO);
      Result := True;
    end;
  except
    on E: Exception do
    begin
      ShowMessage('Erro durante o processo de salvamento: ' + E.Message);
    end;
  end;
end;

end.
