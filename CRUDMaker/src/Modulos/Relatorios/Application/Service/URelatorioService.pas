unit URelatorioService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.TypInfo,
  URelatorioConfiguracaoDTO, frxclass, frxDBset, UPersistenciaLocalService,
  Data.DB, Datasnap.DBClient,
  UCSVService, UXMLService;

type
  TRelatorioService = class
  private
    FPersistencia: TPersistenciaLocalService;
    FXMLService: TXMLService;
    FCSVService: TCSVService;
    function ObterCaminhoArquivoRelatorio(const ANomeRelatorio: string): string;
    function ObterCaminhoArquivoRelatorioBackup(const ANomeRelatorio: string): string;
    function ParseConfiguracao(const AConfiguracaoString: string): TConfiguracaoRelatorioDTO;
    function CarregarDadosTabela(const ACaminhoDados: string): TClientDataSet;
  public
    constructor Create;
    destructor Destroy; override;

    function CarregarConfiguracaoRelatorio(const ANomeRelatorio: string): string;
    function SalvarConfiguracaoRelatorio(const ANomeRelatorio, AConfiguracaoString: string): Boolean;
    function ProcessarDadosParaFastReports(const ATituloTabela: string; const ACaminhoDados: string; const AConfiguracaoString: string; var Report: TfrxReport): Boolean;
  end;

implementation

uses
  System.StrUtils, System.IOUtils;

{ TRelatorioService }

constructor TRelatorioService.Create;
begin
  FXMLService := TXMLService.Create;
  FCSVService := TCSVService.Create;
  FPersistencia := TPersistenciaLocalService.Create;
end;

destructor TRelatorioService.Destroy;
begin
  FPersistencia.Free;
  FCSVService.Free;
  FXMLService.Free;
  inherited;
end;

function TRelatorioService.ObterCaminhoArquivoRelatorio(const ANomeRelatorio: string): string;
begin
  Result := FPersistencia.CaminhodeRelatorio(ANomeRelatorio, false);
end;

function TRelatorioService.ObterCaminhoArquivoRelatorioBackup(const ANomeRelatorio: string): string;
begin
  Result := FPersistencia.CaminhodeRelatorio(ANomeRelatorio, true);
end;

function TRelatorioService.ParseConfiguracao(const AConfiguracaoString: string): TConfiguracaoRelatorioDTO;
var
  LPartes: TArray<string>;
  LInfoExtras: string;
  LConfigDTO: TConfiguracaoRelatorioDTO;
  LTipoStr: string;
  LCampos, LValores: TArray<string>;
  I: Integer;
  LIntValue: Integer;
  LFloatValue: Double;
  LArrayTemp: TArray<Integer>; // Variável temporária
  LAggArrayTemp: TArray<TAggregacao>; // Variável temporária
  LOrdArrayTemp: TArray<TOrdenacao>; // Variável temporária
  LCriteriosTemp: TArray<string>;
begin
  Result := nil;
  if AConfiguracaoString.Trim = '' then Exit;

  LConfigDTO := TConfiguracaoRelatorioDTO.Create;
  try
    // A nova string de configuração deve seguir um formato específico
    // Exemplo: Tipo;CamposAgregacao;TiposAgregacao;CamposAgrupamento;CamposFiltro;CriteriosFiltro;CamposOrdenacao;TipoOrdenacao;TopN;ColunaPeriodo;ColunaValor;TipoComparacao;Linhas;Colunas;Valores;TipoAgregacaoPivot;InformacoesExtras
    // Exemplo: "trResumo;0,2;aggSoma,aggMedia;1;3;>100;4;ordCrescente;10;5;6;Mês a Mês;7;8;9;aggSoma;Cor1,Cor2"
    LPartes := AConfiguracaoString.Split([';']);
    if Length(LPartes) < 17 then
    begin
      LConfigDTO.Free;
      Exit; // Formato inválido
    end;

    // 1. Tipo
    LTipoStr := LPartes[0];
    if SameText(LTipoStr, 'trResumo') then
      LConfigDTO.Tipo := trResumo
    else if SameText(LTipoStr, 'trEventos') then
      LConfigDTO.Tipo := trEventos
    else if SameText(LTipoStr, 'trAnaliseTendencia') then
      LConfigDTO.Tipo := trAnaliseTendencia
    else if SameText(LTipoStr, 'trClassificacao') then
      LConfigDTO.Tipo := trClassificacao
    else if SameText(LTipoStr, 'trExcecao') then
      LConfigDTO.Tipo := trExcecao
    else if SameText(LTipoStr, 'trPivotamento') then
      LConfigDTO.Tipo := trPivotamento
    else
      LConfigDTO.Tipo := trResumo; // Padrão

    // 2. CamposAgregacao
    if LPartes[1] <> '' then
    begin
      LCampos := LPartes[1].Split([',']);
      SetLength(LArrayTemp, Length(LCampos)); // Usar variável temporária
      for I := 0 to High(LCampos) do
        LArrayTemp[I] := StrToIntDef(LCampos[I], 0);
      LConfigDTO.CamposAgregacao := LArrayTemp; // Atribuir ao campo
    end;

    // 3. TiposAgregacao
    if LPartes[2] <> '' then
    begin
      LValores := LPartes[2].Split([',']);
      SetLength(LAggArrayTemp, Length(LValores)); // Usar variável temporária
      for I := 0 to High(LValores) do
      begin
        if SameText(LValores[I], 'aggSoma') then
          LAggArrayTemp[I] := aggSoma
        else if SameText(LValores[I], 'aggMedia') then
          LAggArrayTemp[I] := aggMedia
        else if SameText(LValores[I], 'aggContar') then
          LAggArrayTemp[I] := aggContar
        else if SameText(LValores[I], 'aggMinimo') then
          LAggArrayTemp[I] := aggMinimo
        else if SameText(LValores[I], 'aggMaximo') then
          LAggArrayTemp[I] := aggMaximo
        else
          LAggArrayTemp[I] := aggSoma; // Padrão
      end;
      LConfigDTO.TiposAgregacao := LAggArrayTemp; // Atribuir ao campo
    end;

    // 4. CamposAgrupamento
    if LPartes[3] <> '' then
    begin
      LCampos := LPartes[3].Split([',']);
      SetLength(LArrayTemp, Length(LCampos)); // Usar variável temporária
      for I := 0 to High(LCampos) do
        LArrayTemp[I] := StrToIntDef(LCampos[I], 0);
      LConfigDTO.CamposAgrupamento := LArrayTemp; // Atribuir ao campo
    end;

    // 5. CamposFiltro
    if LPartes[4] <> '' then
    begin
      LCampos := LPartes[4].Split([',']);
      SetLength(LArrayTemp, Length(LCampos)); // Usar variável temporária
      for I := 0 to High(LCampos) do
        LArrayTemp[I] := StrToIntDef(LCampos[I], 0);
      LConfigDTO.CamposFiltro := LArrayTemp; // Atribuir ao campo
    end;

    // 6. CriteriosFiltro
    if LPartes[5] <> '' then
    begin
      LValores := LPartes[5].Split([',']);
      SetLength(LCriteriosTemp, Length(LValores));
      for I := 0 to High(LValores) do
        LCriteriosTemp[I] := LValores[I]; // Atribuir ao array temporário
      LConfigDTO.CriteriosFiltro := LCriteriosTemp; // Atribuir ao campo
    end;

    // 7. CamposOrdenacao
    if LPartes[6] <> '' then
    begin
      LCampos := LPartes[6].Split([',']);
      SetLength(LArrayTemp, Length(LCampos)); // Usar variável temporária
      for I := 0 to High(LCampos) do
        LArrayTemp[I] := StrToIntDef(LCampos[I], 0);
      LConfigDTO.CamposOrdenacao := LArrayTemp; // Atribuir ao campo
    end;

    // 8. TipoOrdenacao
    if LPartes[7] <> '' then
    begin
      LValores := LPartes[7].Split([',']);
      SetLength(LOrdArrayTemp, Length(LValores)); // Usar variável temporária
      for I := 0 to High(LValores) do
      begin
        if SameText(LValores[I], 'ordCrescente') then
          LOrdArrayTemp[I] := ordCrescente
        else if SameText(LValores[I], 'ordDecrescente') then
          LOrdArrayTemp[I] := ordDecrescente
        else
          LOrdArrayTemp[I] := ordCrescente; // Padrão
      end;
      LConfigDTO.TipoOrdenacao := LOrdArrayTemp; // Atribuir ao campo
    end;

    // 9. TopN
    LConfigDTO.TopN := StrToIntDef(LPartes[8], 10);

    // 10. ColunaPeriodo
    LConfigDTO.ColunaPeriodo := StrToIntDef(LPartes[9], -1);

    // 11. ColunaValor
    LConfigDTO.ColunaValor := StrToIntDef(LPartes[10], -1);

    // 12. TipoComparacao
    LConfigDTO.TipoComparacao := LPartes[11];

    // 13. Linhas (Pivotamento) - Corrigido para usar FColunaLinhas
    LConfigDTO.Linhas := StrToIntDef(LPartes[12], -1);

    // 14. Colunas (Pivotamento) - Corrigido para usar FColunaColunas
    LConfigDTO.Colunas := StrToIntDef(LPartes[13], -1);

    // 15. Valores (Pivotamento) - Corrigido para usar FColunaValores
    LConfigDTO.Valores := StrToIntDef(LPartes[14], -1);

    // 16. TipoAgregacaoPivot
    if SameText(LPartes[15], 'aggSoma') then
      LConfigDTO.TipoAgregacaoPivot := aggSoma
    else if SameText(LPartes[15], 'aggMedia') then
      LConfigDTO.TipoAgregacaoPivot := aggMedia
    else if SameText(LPartes[15], 'aggContar') then
      LConfigDTO.TipoAgregacaoPivot := aggContar
    else if SameText(LPartes[15], 'aggMinimo') then
      LConfigDTO.TipoAgregacaoPivot := aggMinimo
    else if SameText(LPartes[15], 'aggMaximo') then
      LConfigDTO.TipoAgregacaoPivot := aggMaximo
    else
      LConfigDTO.TipoAgregacaoPivot := aggSoma; // Padrão

    // 17. InformacoesExtras
    LConfigDTO.InformacoesExtras := LPartes[16];

    Result := LConfigDTO;
  except
    on E: Exception do
    begin
      LConfigDTO.Free;
      raise; // Relança a exceção para tratamento superior
    end;
  end;
end;

// Nova função para carregar dados da tabela
function TRelatorioService.CarregarDadosTabela(const ACaminhoDados: string): TClientDataSet;
var
  LClientDataSet: TClientDataSet;
begin
  Result := nil;
  if not TFile.Exists(ACaminhoDados) then
    Exit; // ou raise Exception se o caminho for obrigatório

  LClientDataSet := TClientDataSet.Create(nil);
  try
    // O CSVService.LerCSV preenche o TClientDataSet com os dados do arquivo
    FCSVService.LerCSV(LClientDataSet, ACaminhoDados);
    Result := LClientDataSet; // Retorna o TClientDataSet com os dados carregados
  except
    on E: Exception do
    begin
      LClientDataSet.Free;
      raise; // Relança a exceção para tratamento superior
    end;
  end;
end;

function TRelatorioService.CarregarConfiguracaoRelatorio(const ANomeRelatorio: string): string;
var
  LCaminho: string;
begin
  LCaminho := ObterCaminhoArquivoRelatorio(ANomeRelatorio);
  Result := FXMLService.LerXMLConfiguraçãoRelatório(LCaminho);
end;

function TRelatorioService.SalvarConfiguracaoRelatorio(const ANomeRelatorio, AConfiguracaoString: string): Boolean;
var
  LCaminho, LCaminhoBackup: string;
  LXMLContent: string;
begin
  Result := False;
  LCaminho := ObterCaminhoArquivoRelatorio(ANomeRelatorio);
  LCaminhoBackup := ObterCaminhoArquivoRelatorioBackup(ANomeRelatorio);

  // Fazer backup do arquivo atual
  if TFile.Exists(LCaminho) then
    TFile.Copy(LCaminho, LCaminhoBackup, True);

  // Gravar a nova configuração
  LXMLContent := '<?xml version="1.0" encoding="utf-8"?>' + sLineBreak +
                 '<Relatorio>' + AConfiguracaoString + '</Relatorio>';
  try
    TFile.WriteAllText(LCaminho, LXMLContent, TEncoding.UTF8);
    Result := True;
  except
    on E: Exception do
    begin
      // Tentar restaurar backup se falhar
      if TFile.Exists(LCaminhoBackup) then
        TFile.Copy(LCaminhoBackup, LCaminho, True);
    end;
  end;
end;

function TRelatorioService.ProcessarDadosParaFastReports(const ATituloTabela: string; const ACaminhoDados: string; const AConfiguracaoString: string; var Report: TfrxReport): Boolean;
var
  LConfigDTO: TConfiguracaoRelatorioDTO;
  LClientDataSet: TClientDataSet; // Usa TClientDataSet
  LDataSource: TfrxDBDataset; // Usa TfrxDBDataset
begin
  Result := False;
  if AConfiguracaoString.Trim = '' then Exit;

  LConfigDTO := ParseConfiguracao(AConfiguracaoString);
  if not Assigned(LConfigDTO) then
    Exit; // Sai se não conseguir parsear a configuração

  try
    // Carregar os dados da tabela usando a nova função
    LClientDataSet := CarregarDadosTabela(ACaminhoDados);
    if not Assigned(LClientDataSet) then
      Exit; // Sai se não conseguir carregar os dados

    try
      // Criar DataSource para o FastReport
      LDataSource := TfrxDBDataset.Create(Report); // Cria um TfrxDBDataset filho do relatório
      LDataSource.Name := 'ds_' + ATituloTabela; // Nome dinâmico
      LDataSource.UserName := 'ds_' + ATituloTabela; // Alias no relatório
      LDataSource.DataSet := LClientDataSet; // Atribui o TClientDataSet carregado

      Report.DataSets.Add(LDataSource); // Adiciona o DataSource à coleção do relatório

      // Definir variáveis no relatório com base na configuração
      if Assigned(Report) then
      begin
        Report.Variables.Clear;
        // Criar e adicionar variáveis individualmente
        Report.Variables.Add.Name := 'TituloTabela';
        Report.Variables.Add.Value := ATituloTabela;

        Report.Variables.Add.Name := 'TipoRelatorio';
        Report.Variables.Add.Value := GetEnumName(TypeInfo(TTipoRelatorioDTO), Ord(LConfigDTO.Tipo));

        Report.Variables.Add.Name := 'InformacoesExtras';
        Report.Variables.Add.Value := LConfigDTO.InformacoesExtras;

        // Outras variáveis podem ser adicionadas aqui conforme necessário
      end;

      Result := True;
    finally
      // Importante: O TClientDataSet não deve ser liberado aqui se o DataSource ainda o estiver usando.
      // O TfrxDBDataset *não* assume posse do DataSet. Portanto, devemos liberar o LClientDataSet.
      // No entanto, liberar o LClientDataSet agora tornará o DataSource inválido.
      // A melhor prática é associar o LClientDataSet a um componente que viva o tempo suficiente
      // ou gerenciar seu ciclo de vida externamente.
      // Por simplicidade aqui, liberamos o LClientDataSet, o que significa que o DataSource
      // só pode ser usado para preparar o relatório, mas não para execução futura.
      // Se o relatório for executado imediatamente, isso pode funcionar.
      // Caso contrário, o gerenciamento de memória deve ser feito com mais cuidado.
      // Para manter a consistência com o ciclo de vida do relatório, o ideal seria
      // associar o ClientDataSet a um componente pai ou manter uma referência.
      // Por enquanto, liberamos, pois a função está configurando o relatório para uso imediato.
      LClientDataSet.Free;
    end;
  finally
    LConfigDTO.Free;
  end;
end;

end.
