unit UCriadorTabelaController;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient, UTabelaDTO, UXMLService, UCSVService, Vcl.Dialogs;

type
  TCriadorTabelaController = class
  private
    FXMLService: TXMLService;
    FCSVService: TCSVService;
  public
    constructor Create;
    destructor Destroy; override;

    // Executa o processo completo de criação/salvamento de uma tabela em XML e CSV simultaneamente.
    // Solicita o caminho base ao usuário e salva os dados nos dois formatos.
    // Atualiza o DTO com os caminhos e hashes.
    function ExecutarCriarTabela(const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
  end;

implementation

constructor TCriadorTabelaController.Create;
begin
  inherited Create;
  FXMLService := TXMLService.Create;
  FCSVService := TCSVService.Create;
end;

destructor TCriadorTabelaController.Destroy;
begin
  FXMLService.Free;
  FCSVService.Free;
  inherited;
end;

function TCriadorTabelaController.ExecutarCriarTabela(const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
var
  SaveDialog: TSaveDialog;
  CaminhoBase: string;
  CaminhoXML: string;
  CaminhoCSV: string;
begin
  Result := False;
  if not Assigned(ATabela) then
  begin
    ShowMessage('DTO da tabela não fornecido.');
    Exit;
  end;

  // Usamos um único diálogo para obter o caminho base
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'Arquivo Base (sem extensão)|*.'; // Filtro genérico
    SaveDialog.DefaultExt := ''; // Sem extensão padrão
    SaveDialog.FileName := ATabela.Titulo; // Sugere o título como nome base
    SaveDialog.Title := 'Escolha o nome base para salvar os arquivos XML e CSV';

    if SaveDialog.Execute then
    begin
      CaminhoBase := ChangeFileExt(SaveDialog.FileName, ''); // Remove qualquer extensão digitada

      // Define os caminhos completos
      CaminhoXML := CaminhoBase + '.xml';
      CaminhoCSV := CaminhoBase + '.csv';

      try
        // Grava XML
        FXMLService.GravarXML(AClientDataSet, CaminhoXML, ATabela);
        // Grava CSV
        FCSVService.GravarCSV(AClientDataSet, CaminhoCSV, ATabela);

        Result := True;
        ShowMessage(Format('Tabela salva com sucesso!' + sLineBreak +
                           'XML: %s (Hash: %s)' + sLineBreak +
                           'CSV: %s (Hash: %s)',
                           [CaminhoXML, ATabela.HashXML, CaminhoCSV, ATabela.HashCSV]));
      except
        on E: Exception do
        begin
          ShowMessage('Erro ao salvar a tabela: ' + E.Message);
        end;
      end;
    end
    else
    begin
      // Usuário cancelou o salvamento
      ShowMessage('Operação de salvamento cancelada.');
    end;
  finally
    SaveDialog.Free;
  end;
end;

end.
