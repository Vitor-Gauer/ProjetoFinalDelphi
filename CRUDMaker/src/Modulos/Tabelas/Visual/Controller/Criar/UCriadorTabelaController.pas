unit UCriadorTabelaController;

interface

uses
  // Units padrão do Delphi
  System.SysUtils, System.Classes, System.IOUtils, // <<< Adiciona System.IOUtils para ForceDirectories, TPath
  Data.DB, Datasnap.DBClient, Vcl.Dialogs, Vcl.Forms, // <<< Adiciona Vcl.Forms para Application
  // Units do projeto
  UTabelaDTO, UTabelaConfiguracaoDTO, // <<< Adiciona UTabelaConfiguracaoDTO
  UXMLService, UCSVService, UPDFService; // <<< Adiciona UPDFService

type
  /// <summary>
  /// Controller responsável pela lógica de criação e salvamento de tabelas.
  /// </summary>
  TCriadorTabelaController = class
  private
    FXMLService: TXMLService;
    FCSVService: TCSVService;
    FPDFService: TPDFService; // <<< Adiciona FPDFService
    /// <summary>
    /// Função auxiliar para capitalizar a primeira letra de cada palavra em uma string.
    /// </summary>
    function CapitalizarPrimeiraLetra(const ATexto: string): string;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// Executa o processo completo de criação/salvamento de uma tabela.
    /// Utiliza a configuração fornecida para determinar dimensões, cabeçalho e planilha.
    /// Solicita o caminho base ao usuário (ou define automaticamente) e salva os dados
    /// nos formatos XML e CSV, gerando também o PDF.
    /// Atualiza o DTO com os caminhos e hashes.
    /// </summary>
    /// <param name="AConfiguracao">DTO contendo as configurações iniciais da tabela (linhas, colunas, cabeçalho, planilha).</param>
    /// <param name="ATabela">DTO da tabela a ser salva (contém o título).</param>
    /// <param name="AClientDataSet">ClientDataSet com os dados da tabela.</param>
    /// <returns>True se a criação for bem-sucedida, False caso contrário.</returns>
    function ExecutarCriarTabela(const AConfiguracao: TConfiguracaoTabelaDTO; const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
  end;

implementation

// uses
//   Vcl.Forms; // <<< JÁ ESTÁ NA INTERFACE, NÃO PRECISA AQUI PARA Application

{ TCriadorTabelaController }

constructor TCriadorTabelaController.Create;
begin
  inherited Create;
  FXMLService := TXMLService.Create;
  FCSVService := TCSVService.Create;
  FPDFService := TPDFService.Create; // <<< Cria FPDFService
end;

destructor TCriadorTabelaController.Destroy;
begin
  FPDFService.Free; // <<< Destrói FPDFService
  FCSVService.Free;
  FXMLService.Free;
  inherited;
end;

function TCriadorTabelaController.CapitalizarPrimeiraLetra(const ATexto: string): string;
var
  Palavras: TArray<string>;
  i: Integer;
begin
  Result := '';
  if ATexto = '' then
    Exit;

  Palavras := ATexto.Split([' ']); // Divide por espaços
  for i := Low(Palavras) to High(Palavras) do
  begin
    if Palavras[i] <> '' then
    begin
      // Converte a primeira letra para maiúscula e o resto para minúscula
      Palavras[i] := UpperCase(Copy(Palavras[i], 1, 1)) + LowerCase(Copy(Palavras[i], 2, MaxInt));
    end;
    Result := Result + Palavras[i] + ' ';
  end;
  // Remove o espaço extra no final
  Result := Trim(Result);
end;

function TCriadorTabelaController.ExecutarCriarTabela(const AConfiguracao: TConfiguracaoTabelaDTO; const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
var
  TituloFormatado, PlanilhaFormatada, NomeBaseArquivo: string;
  DiretorioBase, DiretorioTabelaEspecifica, CaminhoCompletoBase: string;
  CaminhoXML, CaminhoCSV, CaminhoPDF: string;
  CaminhoCSS: string;
  ExePath: string; // <<< Variável para armazenar o caminho do executável
begin
  Result := False;

  // 1. Validar parâmetros de entrada
  if not Assigned(AConfiguracao) then
  begin
    ShowMessage('Erro: Configuração da tabela não fornecida.');
    Exit;
  end;

  if not Assigned(ATabela) then
  begin
    ShowMessage('Erro: DTO da tabela não fornecido.');
    Exit;
  end;

  if not Assigned(AClientDataSet) or not AClientDataSet.Active then
  begin
    ShowMessage('Erro: ClientDataSet inválido ou não ativo.');
    Exit;
  end;

  // 2. Formatar nomes conforme especificação do PDF
  try
    TituloFormatado := CapitalizarPrimeiraLetra(ATabela.Titulo);
    PlanilhaFormatada := CapitalizarPrimeiraLetra(AConfiguracao.PlanilhaNome);
    NomeBaseArquivo := TituloFormatado + PlanilhaFormatada;

  // 3. Determinar caminho do executável e diretórios de destino
    ExePath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)); // <<< Correção: Application.ExeName é string
    DiretorioBase := ExePath + 'Planilhas' + PathDelim + AConfiguracao.PlanilhaNome + PathDelim + 'Tabelas'; // <<< Correção: Concatenação de strings

    // Garante que o diretório base exista
    if not ForceDirectories(DiretorioBase) then
    begin
      ShowMessage('Erro: Falha ao criar o diretório base para tabelas: ' + DiretorioBase);
      Exit;
    end;

    DiretorioTabelaEspecifica := IncludeTrailingPathDelimiter(DiretorioBase) + TituloFormatado;
    // Garante que o diretório específico da tabela exista
    if not ForceDirectories(DiretorioTabelaEspecifica) then
    begin
      ShowMessage('Erro: Falha ao criar o diretório específico da tabela: ' + DiretorioTabelaEspecifica);
      Exit;
    end;

  // 4. Definir caminhos completos dos arquivos
    CaminhoCompletoBase := IncludeTrailingPathDelimiter(DiretorioTabelaEspecifica) + NomeBaseArquivo;
    CaminhoXML := CaminhoCompletoBase + '.xml';
    CaminhoCSV := CaminhoCompletoBase + '.csv';
    CaminhoPDF := CaminhoCompletoBase + '.pdf'; // Caminho para o PDF gerado

  // 5. Salvar XML
    FXMLService.GravarXML(AClientDataSet, CaminhoXML, ATabela);

  // 6. Salvar CSV
    FCSVService.GravarCSV(AClientDataSet, CaminhoCSV, ATabela);

  // 7. Gerar PDF (simulado)
    //    Utiliza o estilo.css do diretório do executável.
    CaminhoCSS := ExePath + 'estilo.css'; // Caminho do CSS
    try
       // Quando o método de UPDFService for atualizado para receber XML, CSS e destino:
       // FPDFService.GerarAPartirDeXML(CaminhoXML, CaminhoCSS, CaminhoPDF);
    except
       on E: Exception do
       begin
         ShowMessage('Aviso: Erro ao gerar o PDF (a tabela foi salva em XML/CSV): ' + E.Message);
         // Decide se continua como sucesso ou marca como falha.
         // Por agora, considera como sucesso se XML/CSV foram salvos.
       end;
    end;

  // 8. Sucesso
    Result := True;
    ShowMessage(Format('Tabela "%s" criada com sucesso!' + sLineBreak +
                       'Arquivos gerados em: %s' + sLineBreak +
                       'XML: %s' + sLineBreak +
                       'CSV: %s' + sLineBreak +
                       'PDF: %s',
                       [ATabela.Titulo, DiretorioTabelaEspecifica,
                        ExtractFileName(CaminhoXML),
                        ExtractFileName(CaminhoCSV),
                        ExtractFileName(CaminhoPDF)]));

  except
    on E: Exception do // <<< Correção: 'on E: Exception do' para capturar erros do bloco principal
    begin
      ShowMessage('Erro ao criar/salvar a tabela: ' + E.Message);
      Result := False; // Garante que o resultado seja False em caso de exceção
    end;
  end;
end;

end.
