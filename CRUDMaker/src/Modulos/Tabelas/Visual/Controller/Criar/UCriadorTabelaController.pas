unit UCriadorTabelaController;

interface

uses
  System.SysUtils, System.Classes, System.IOUtils,
  Data.DB, Datasnap.DBClient, Vcl.Dialogs, Vcl.Forms,

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

  Palavras := ATexto.Split([' ']);
  for i := Low(Palavras) to High(Palavras) do
  begin
    if Palavras[i] <> '' then
    begin
      Palavras[i] := UpperCase(Copy(Palavras[i], 1, 1)) + LowerCase(Copy(Palavras[i], 2, MaxInt));
    end;
    Result := Result + Palavras[i] + ' ';
  end;
  Result := Trim(Result);
end;

function TCriadorTabelaController.ExecutarCriarTabela(const AConfiguracao: TConfiguracaoTabelaDTO; const ATabela: TTabelaDTO; AClientDataSet: TClientDataSet): Boolean;
var
  TituloFormatado, PlanilhaFormatada, NomeBaseArquivo, NomeBaseArquivoBackup: string;
  DiretorioBase, DiretorioTabelaEspecifica, CaminhoCompletoBase: string;
  CaminhoXML, CaminhoCSV: string;
  CaminhoCSS: string;
  ExePath: string;
  HojeTempo: TDateTime;
  HojeString: string;
  i:integer;
  CaminhosPrincipais, CaminhosBackup: TArray<string>;
  DiretorioPrincipal, DiretorioBackup: string;
begin
  Result := False;

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

  try
    TituloFormatado := CapitalizarPrimeiraLetra(ATabela.Titulo);
    PlanilhaFormatada := CapitalizarPrimeiraLetra(AConfiguracao.PlanilhaNome);
    NomeBaseArquivo := TituloFormatado;

    ExePath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
    for i := 0 to 1 do
    begin
      if i = 1 then
        DiretorioBase := ExePath + 'Backup'
        + PathDelim + 'Planilhas'
        + PathDelim + AConfiguracao.PlanilhaNome
        + PathDelim + 'Tabelas'
      else
        DiretorioBase := ExePath + 'Planilhas'
        + PathDelim + AConfiguracao.PlanilhaNome + PathDelim + 'Tabelas';

      if not ForceDirectories(DiretorioBase) then
      begin
        ShowMessage('Erro: Falha ao criar o diretório base para tabelas: ' + DiretorioBase);
        Exit;
      end;

      DiretorioTabelaEspecifica := IncludeTrailingPathDelimiter(DiretorioBase) + TituloFormatado;
      if not ForceDirectories(DiretorioTabelaEspecifica) then
      begin
        ShowMessage('Erro: Falha ao criar o diretório específico da tabela: ' + DiretorioTabelaEspecifica);
        Exit;
      end;

      if i = 0 then
      begin
        CaminhoCompletoBase := IncludeTrailingPathDelimiter(DiretorioTabelaEspecifica) + NomeBaseArquivo;
        CaminhoXML := CaminhoCompletoBase + '.xml';
        CaminhoCSV := CaminhoCompletoBase + '.csv';

        CaminhosPrincipais := [CaminhoXML, CaminhoCSV];
        DiretorioPrincipal := DiretorioTabelaEspecifica;

        FXMLService.GravarXML(AClientDataSet, CaminhoXML, ATabela, AConfiguracao);
        FCSVService.GravarCSV(AClientDataSet, CaminhoCSV, ATabela);
      end;

      if i = 1 then
      begin
        HojeTempo := Now;
        HojeString := FormatDateTime(' yyyy-mm-dd hh_nn_ss ', HojeTempo);
        NomeBaseArquivoBackup := TituloFormatado + HojeString;
        CaminhoCompletoBase := IncludeTrailingPathDelimiter(DiretorioTabelaEspecifica) + NomeBaseArquivoBackup;
        CaminhoXML := CaminhoCompletoBase + '.xml';
        CaminhoCSV := CaminhoCompletoBase + '.csv';

        CaminhosBackup := [CaminhoXML, CaminhoCSV];
        DiretorioBackup := DiretorioTabelaEspecifica;

        FXMLService.GravarXML(AClientDataSet, CaminhoXML, ATabela, AConfiguracao);
        FCSVService.GravarCSV(AClientDataSet, CaminhoCSV, ATabela);
      end;
      Result := True;
    end;

  ShowMessage(Format('Tabela "%s" criada com sucesso!' + sLineBreak +
                     'Arquivos gerados em: %s' + sLineBreak +
                     'XML: %s' + sLineBreak +
                     'CSV: %s',
                     [ATabela.Titulo, DiretorioPrincipal,
                      ExtractFileName(CaminhosPrincipais[0]),
                      ExtractFileName(CaminhosPrincipais[1])]));
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao criar/salvar a tabela: ' + E.Message);
      Result := False;
    end;
  end;
end;

end.
