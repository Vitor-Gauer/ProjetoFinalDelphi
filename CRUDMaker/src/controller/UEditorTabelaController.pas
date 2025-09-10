unit UEditorTabelaController;

interface

uses
  System.SysUtils, UTabelaDTO, UEditarTabelaService, UXMLService;

type
  TEditorTabelaController = class
  private
    FService: TEditarTabelaService;
    FXMLService: TXMLService;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// Inicia o processo de carregamento de uma tabela.
    /// </summary>
    /// <param name="ATabelaDTO">DTO da tabela a ser carregada.</param>
    /// <returns>DTO atualizado com os dados carregados.</returns>
    function CarregarTabela(ATabelaDTO: TTabelaDTO): TTabelaDTO;

    /// <summary>
    /// Inicia o processo de salvamento de uma tabela.
    /// </summary>
    /// <param name="ATabelaDTO">DTO da tabela a ser salva.</param>
    procedure SalvarTabela(ATabelaDTO: TTabelaDTO);
  end;

implementation

{ TEditorTabelaController }

constructor TEditorTabelaController.Create;
begin
  inherited Create;
  FXMLService := TXMLService.Create; // Ou injetado via construtor
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
  // O service faz a validação, chama o XMLService e retorna o DTO atualizado
  Result := FService.Carregar(ATabelaDTO);
end;

procedure TEditorTabelaController.SalvarTabela(ATabelaDTO: TTabelaDTO);
begin
  // O service faz a validação e chama o XMLService para salvar
  FService.Salvar(ATabelaDTO);
end;

end.
