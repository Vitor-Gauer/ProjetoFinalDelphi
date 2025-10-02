unit UPlanilhaService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  System.IOUtils, VCL.Forms,
  UTabelaDTO, UPlanilhaDTO, UInfoTabelaPlanilhaDTO,
  UXMLService, UCSVService, UPostgresDAO;

type
  TPlanilhaService = class
  private
    FDAO: TPostgresDAO;
    FXMLService: TXMLService;
    FCSVService: TCSVService;
  public
    constructor Create(ADao: TPostgresDAO; AXMLService: TXMLService; ACVSService: TCSVService);
    function GetPlanilha(AId: Integer): TPlanilhaDTO;
    procedure AtualizarPlanilha(APlanilha: TPlanilhaDTO);
    function ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
  end;

implementation

{ TPlanilhaService }

constructor TPlanilhaService.Create(ADao: TPostgresDAO; AXMLService: TXMLService; ACVSService: TCSVService);
begin
  inherited Create;
  FDAO := ADao;
  FXMLService := AXMLService;
  FCSVService := ACVSService;
end;

function TPlanilhaService.GetPlanilha(AId: Integer): TPlanilhaDTO;
begin
  // Implementacao de exemplo
  Result := TPlanilhaDTO.Create; // Ou buscar do banco/DAO
  Result.Id := AId;
  Result.Titulo := 'Planilha Exemplo';
end;

procedure TPlanilhaService.AtualizarPlanilha(APlanilha: TPlanilhaDTO);
begin
  // Implementacao de exemplo
  if Assigned(APlanilha) then
    // Salvar/atualizar APlanilha usando FDAO
end;

function TPlanilhaService.ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
var
  DiretorioPlanilha, DiretorioTabelas: string;
  SubDirs: TArray<string>;
  i: Integer;
  NomeTabela: string;
  CaminhoPastaTabela: string;
  ArquivosCSV: TArray<string>;
  ArquivosXML: TArray<string>;
  CaminhoCSV: string;
  CaminhoXML: string;
  TamanhoBytes: Int64;
  TamanhoMB: string;
  Dimensoes: string;
  InfoTabela: TInfoTabelaPlanilhaDTO;
  TabelasProcessadas: TStringList; // Para controlar quais tabelas ja foram adicionadas via CSV
begin
  Result := TObjectList<TInfoTabelaPlanilhaDTO>.Create(True); // OwnsObjects = True
  TabelasProcessadas := TStringList.Create;
  try
    if ANomePlanilha = '' then
      Exit;

    DiretorioPlanilha := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
                         'Planilhas' + PathDelim + ANomePlanilha;
    DiretorioTabelas := IncludeTrailingPathDelimiter(DiretorioPlanilha) + 'Tabelas';

    if not TDirectory.Exists(DiretorioTabelas) then
      Exit;

    SubDirs := TDirectory.GetDirectories(DiretorioTabelas);

    // --- PASSO 1: Processar arquivos .CSV primeiro ---
    for i := Low(SubDirs) to High(SubDirs) do
    begin
      NomeTabela := ExtractFileName(SubDirs[i]);
      CaminhoPastaTabela := SubDirs[i];

      // Assume que o CSV tem o nome base da tabela
      CaminhoCSV := IncludeTrailingPathDelimiter(CaminhoPastaTabela) + NomeTabela + '.csv';

      Dimensoes := 'Desconhecido';
      TamanhoMB := '0 MB';

      // Verifica se o arquivo CSV esperado existe
      if TFile.Exists(CaminhoCSV) then
      begin
        try
          // --- Obter Dimensoes do CSV (reutiliza logica existente no service) ---
          Dimensoes := FCSVService.ObterDimensoesDoCSV(CaminhoCSV);

          // --- Obter Tamanho do Arquivo CSV ---
          TamanhoBytes := TFile.GetSize(CaminhoCSV);
          TamanhoMB := FormatFloat('0.00 MB', TamanhoBytes / (1024 * 1024));
        except
          on E: Exception do
          begin
            TamanhoMB := 'Erro';
            Dimensoes := 'Erro ao ler CSV: ' + E.ClassName;
          end;
        end;

        InfoTabela := TInfoTabelaPlanilhaDTO.Create(NomeTabela, Dimensoes, TamanhoMB, 'CSV', CaminhoCSV);
        Result.Add(InfoTabela);
        TabelasProcessadas.Add(NomeTabela); // Marca como processada via CSV
      end;
    end;

    // --- PASSO 2: Verificar por arquivos .XML adicionais nao listados pelo CSV ---
    for i := Low(SubDirs) to High(SubDirs) do
    begin
      NomeTabela := ExtractFileName(SubDirs[i]);
      CaminhoPastaTabela := SubDirs[i];

      // So processa se a tabela NAO foi listada via CSV
      if TabelasProcessadas.IndexOf(NomeTabela) = -1 then
      begin
        // Assume que o XML tem o nome base da tabela
        CaminhoXML := IncludeTrailingPathDelimiter(CaminhoPastaTabela) + NomeTabela + '.xml';

        Dimensoes := 'Desconhecido';
        TamanhoMB := '0 MB';

        // Verifica se o arquivo XML esperado existe
        if TFile.Exists(CaminhoXML) then
        begin
          try
            // --- Obter Dimensoes do XML (reutiliza logica existente no service) ---
            Dimensoes := FXMLService.ObterDimensoesDoXML(CaminhoXML);

            // --- Obter Tamanho do Arquivo XML ---
            TamanhoBytes := TFile.GetSize(CaminhoXML);
            TamanhoMB := FormatFloat('0.00 MB', TamanhoBytes / (1024 * 1024));
          except
            on E: Exception do
            begin
              TamanhoMB := 'Erro';
              Dimensoes := 'Erro ao ler XML: ' + E.ClassName;
            end;
          end;

          InfoTabela := TInfoTabelaPlanilhaDTO.Create(NomeTabela, Dimensoes, TamanhoMB, 'XML', CaminhoXML);
          Result.Add(InfoTabela);
          // Nao adiciona ao TabelasProcessadas aqui, pois eh uma fonte secundaria/adicional
        end;
      end;
    end;

  finally
    TabelasProcessadas.Free;
  end;
end;

end.
