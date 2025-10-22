unit UCriadorTabelaController;

interface

uses
  // Units padr�o do Delphi
  System.SysUtils, System.Classes, System.IOUtils,
  Data.DB, Datasnap.DBClient, Vcl.Dialogs, Vcl.Forms,
  // Units do projeto
  UTabelaDTO, UTabelaConfiguracaoDTO,
  UXMLService, UCSVService, UPDFService;

type
  TCriadorTabelaController = class
  private
    FXMLService: TXMLService;
    FCSVService: TCSVService;
    FPDFService: TPDFService;
    function CapitalizarPrimeiraLetra(const ATexto: string): string;
  public
    constructor Create;
    destructor Destroy; override;
    function ExecutarCriarTabela(const AConfiguracao: TConfiguracaoTabelaDTO; const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
  end;

implementation

{ TCriadorTabelaController }

constructor TCriadorTabelaController.Create;
begin
  inherited Create;
  FXMLService := TXMLService.Create;
  FCSVService := TCSVService.Create;
  FPDFService := TPDFService.Create;
end;

destructor TCriadorTabelaController.Destroy;
begin
  FPDFService.Free;
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

  Palavras := ATexto.Split([' ']); // Divide por espa�os
  for i := Low(Palavras) to High(Palavras) do
  begin
    if Palavras[i] <> '' then
    begin
      // Converte a primeira letra para mai�scula e o resto para min�scula
      Palavras[i] := UpperCase(Copy(Palavras[i], 1, 1)) + LowerCase(Copy(Palavras[i], 2, MaxInt));
    end;
    Result := Result + Palavras[i] + ' ';
  end;
  // Remove o espa�o extra no final
  Result := Trim(Result);
end;

function TCriadorTabelaController.ExecutarCriarTabela(const AConfiguracao: TConfiguracaoTabelaDTO; const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
var
  TituloFormatado, PlanilhaFormatada, NomeBaseArquivo: string;
  DiretorioBase, DiretorioTabelaEspecifica, CaminhoCompletoBase: string;
  CaminhoXML, CaminhoCSV, CaminhoPDF: string;
  CaminhoCSS: string;
  ExePath: string;
begin
  Result := False;

  // 1. Validar par�metros de entrada
  if not Assigned(AConfiguracao) then
  begin
    ShowMessage('Erro: Configura��o da tabela n�o fornecida.');
    Exit;
  end;

  if not Assigned(ATabela) then
  begin
    ShowMessage('Erro: DTO da tabela n�o fornecido.');
    Exit;
  end;

  if not Assigned(AClientDataSet) or not AClientDataSet.Active then
  begin
    ShowMessage('Erro: ClientDataSet inv�lido ou n�o ativo.');
    Exit;
  end;

  // 2. Formatar nomes conforme especifica��o do PDF
  try
    TituloFormatado := CapitalizarPrimeiraLetra(ATabela.Titulo);
    PlanilhaFormatada := CapitalizarPrimeiraLetra(AConfiguracao.PlanilhaNome);
    NomeBaseArquivo := TituloFormatado;

  // 3. Determinar caminho do execut�vel e diret�rios de destino
    ExePath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
    DiretorioBase :=
    ExePath + 'Planilhas' +
    PathDelim + AConfiguracao.PlanilhaNome +
    PathDelim + 'Tabelas';

    // Garante que o diret�rio base exista
    if not ForceDirectories(DiretorioBase) then
    begin
      ShowMessage('Erro: Falha ao criar o diret�rio base para tabelas: ' + DiretorioBase);
      Exit;
    end;

    DiretorioTabelaEspecifica := IncludeTrailingPathDelimiter(DiretorioBase) + TituloFormatado;
    // Garante que o diret�rio espec�fico da tabela exista
    if not ForceDirectories(DiretorioTabelaEspecifica) then
    begin
      ShowMessage('Erro: Falha ao criar o diret�rio espec�fico da tabela: ' + DiretorioTabelaEspecifica);
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
    //    Utiliza o estilo.css do diret�rio do execut�vel.
    CaminhoCSS := ExePath + 'estilo.css'; // Caminho do CSS
    try
       // Quando o m�todo de UPDFService for atualizado para receber XML, CSS e destino:
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
    on E: Exception do // <<< Corre��o: 'on E: Exception do' para capturar erros do bloco principal
    begin
      ShowMessage('Erro ao criar/salvar a tabela: ' + E.Message);
      Result := False; // Garante que o resultado seja False em caso de exce��o
    end;
  end;
end;

end.
