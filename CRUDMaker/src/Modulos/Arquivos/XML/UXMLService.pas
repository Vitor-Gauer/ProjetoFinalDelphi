unit UXMLService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient, System.IOUtils,
  System.StrUtils, System.Math, VCL.Forms,  // Para Random, StringReplace, TryStrToInt, CharInSet etc.
  XMLDoc, XMLIntf, MSXML,
  UTabelaDTO, UTabelaConfiguracaoDTO;

type
  TXMLService = class
  private
    // Gera uma string hash aleat�ria de 20 caracteres.
    // Os primeiros 5 caracteres s�o letras, os restantes s�o letras ou n�meros.
    function GerarHashXML: string;
  public
    // Carrega os dados de um arquivo XML personalizado para o ClientDataSet.
    procedure LerXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);

    // Salva os dados do ClientDataSet em um arquivo XML personalizado.
    procedure GravarXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO; const AConfiguracao: TConfiguracaoTabelaDTO);
    // --- Relatórios ---
    class function LerXMLConfiguraçãoRelatório(const ACaminhoArquivo: string): string;

    class function GravarXMLConfiguraçãoRelatório(const ACaminhoArquivo: string; const AConfiguracaoString: string): Boolean;
    // --- Associações ---
    class function LerXMLAssociacao(const ACaminhoArquivo: string): string;

    class function GravarXMLAssociacao(const ACaminhoArquivo: string; const AAssociacaoString: string): Boolean;

    function ObterUltimoHashGerado: string;

    function ObterDimensoesDoXML(const ACaminhoArquivo: string): string;
  end;

implementation

{ TXMLService }

function TXMLService.GerarHashXML: string;
const
  Letras = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  Alfanumericos = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
var
  i: Integer;
begin
  Result := '';
  Randomize; // Inicializa o gerador de n�meros aleat�rios

  // Gera os primeiros 5 caracteres como letras
  for i := 1 to 5 do
  begin
    Result := Result + Letras[Random(Length(Letras)) + 1];
  end;

  // Gera os pr�ximos 15 caracteres como letras ou n�meros
  for i := 6 to 20 do
  begin
    Result := Result + Alfanumericos[Random(Length(Alfanumericos)) + 1];
  end;
end;

function TXMLService.ObterUltimoHashGerado: string;
begin
  Result := GerarHashXML; // Vol�til, pegando da mem�ria, tem que salvar no arquivo depois
end;

procedure TXMLService.LerXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);
var
  XMLDoc: IXMLDocument;
  TabelaNode: IXMLNode;
  LinhasNodeList, ColunasNodeList, CelulasNodeList: IXMLNodeList;
  LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  i, j, k, NumLinhas, NumColunas: Integer;
  FieldDef: TFieldDef;
  MaxColunas: Integer;
  ValorCelula: string;
begin
  if not Assigned(AClientDataSet) then
    raise Exception.Create('ClientDataSet inv�lido.');

  if (ACaminhoArquivo = '') or not FileExists(ACaminhoArquivo) then
    raise Exception.Create('Caminho do arquivo XML inv�lido ou arquivo n�o encontrado.');

  AClientDataSet.Close;
  AClientDataSet.FieldDefs.Clear;

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromFile(ACaminhoArquivo);
    XMLDoc.Active := True;

    // Encontra o primeiro n� <Tabela>
    TabelaNode := XMLDoc.DocumentElement.ChildNodes.FindNode('Redor');
    if Assigned(TabelaNode) then
      TabelaNode := TabelaNode.ChildNodes.FindNode('Redor'); // Navega para o segundo Redor
    if Assigned(TabelaNode) then
      TabelaNode := TabelaNode.ChildNodes.FindNode('Tabela');

    if not Assigned(TabelaNode) then
      raise Exception.Create('Estrutura XML inv�lida: n� <Tabela> n�o encontrado.');

    // Determina o n�mero m�ximo de colunas olhando todas as linhas
    MaxColunas := 0;
    LinhasNodeList := TabelaNode.ChildNodes.FindNode('Linha').ChildNodes.FindNode('Colunas').ChildNodes; // Assume pelo menos uma linha
    if Assigned(LinhasNodeList) then
      MaxColunas := LinhasNodeList.Count;

    // Cria campos no ClientDataSet com base no n�mero m�ximo de colunas
    for i := 1 to MaxColunas do
    begin
      FieldDef := AClientDataSet.FieldDefs.AddFieldDef;
      FieldDef.Name := 'Coluna' + IntToStr(i);
      FieldDef.DataType := ftString;
      FieldDef.Size := 300; // Tamanho padr�o, pode ser ajustado
    end;

    AClientDataSet.CreateDataSet;
    AClientDataSet.Open;

    // Itera pelas linhas
    LinhasNodeList := TabelaNode.ChildNodes;
    if Assigned(LinhasNodeList) then
    begin
      NumLinhas := LinhasNodeList.Count;
      for i := 0 to NumLinhas - 1 do
      begin
        LinhaNode := LinhasNodeList[i];
        if (LinhaNode.NodeName = 'Linha') then
        begin
          ColunasNode := LinhaNode.ChildNodes.FindNode('Colunas');
          if Assigned(ColunasNode) then
          begin
            CelulasNodeList := ColunasNode.ChildNodes;
            if Assigned(CelulasNodeList) then
            begin
              AClientDataSet.Append;
              NumColunas := CelulasNodeList.Count;
              for j := 0 to Min(NumColunas, MaxColunas) - 1 do
              begin
                CelulaNode := CelulasNodeList[j];
                if (CelulaNode.NodeName = 'Celula') then
                begin
                  ValorCelula := CelulaNode.Text;
                  try
                    AClientDataSet.FieldByName('Coluna' + IntToStr(j + 1)).AsString := ValorCelula;
                  except
                    on E: EDatabaseError do
                      // Ignora campos inexistentes ou erros de convers�o
                  end;
                end;
              end;
              AClientDataSet.Post;
            end;
          end;
        end;
      end;
    end;

    if not AClientDataSet.IsEmpty then
      AClientDataSet.First;

  finally
    XMLDoc := nil; // Libera a interface
  end;
end;

procedure TXMLService.GravarXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO; const AConfiguracao: TConfiguracaoTabelaDTO);
var
  XMLDoc: TXMLDocument;
  RootNode, CorpoNode, Redor1Node, Redor2Node, TabelaNode, TituloNode: IXMLNode;
  LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  Bookmark: TBookmark;
  i, j: Integer;
  Field: TField;
  FXMLEstilo, NovoHashXML, FEstilocss, FEstilocsscaminho, ExePath: string;
begin
  ExePath := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName));
  if not Assigned(AClientDataSet) or not AClientDataSet.Active then
    raise Exception.Create('ClientDataSet inv�lido ou n�o ativo.');

  if (ACaminhoArquivo = '') then
    raise Exception.Create('Caminho do arquivo XML inv�lido.');

  if not Assigned(ATabelaDTO) then
     raise Exception.Create('DTO da tabela n�o fornecido para atualiza��o do hash.');

  XMLDoc := TXMLDocument.Create(nil);
  try
    // Cria a estrutura básica do XML
    XMLDoc.Active := True;
    XMLDoc.Version := '1.0';
    XMLDoc.Encoding := 'UTF-8';
    case (AConfiguracao.TipoCabecalho) of
      tcLinha:
      begin
        FEstilocsscaminho := ExePath + 'estilolinha.css';
        FEstilocss := 'type="text/css" href="' + FEstilocsscaminho + '"';
      end;
      tcColuna:
      begin
        FEstilocsscaminho := ExePath + 'estilocoluna.css';
        FEstilocss := 'type="text/css" href="' + FEstilocsscaminho + '"';
      end;
    end;
    RootNode := XMLDoc.CreateNode('xml-stylesheet', ntProcessingInstr, FEstilocss);
    XMLDoc.ChildNodes.Insert(1, RootNode); // lembre-se: 0-index
    CorpoNode := XMLDoc.AddChild('Corpo');
    Redor1Node := CorpoNode.AddChild('Redor');
    Redor2Node := Redor1Node.AddChild('Redor');
    TabelaNode := Redor2Node.AddChild('Tabela');
    TituloNode := TabelaNode.AddChild('Titulo');
    TituloNode.Text := ATabelaDTO.Titulo;

    AClientDataSet.DisableControls;
    Bookmark := AClientDataSet.GetBookmark;
    try
      AClientDataSet.First;
      while not AClientDataSet.Eof do
      begin
        LinhaNode := TabelaNode.AddChild('Linha');
        LinhaNode.Attributes['numero'] := IntToStr(AClientDataSet.RecNo);
        ColunasNode := LinhaNode.AddChild('Colunas');

        for j := 0 to AClientDataSet.FieldCount - 1 do
        begin
          Field := AClientDataSet.Fields[j];
          CelulaNode := ColunasNode.AddChild('Celula');
          CelulaNode.Attributes['numero'] := IntToStr(j + 1);
          CelulaNode.Text := Field.AsString;
        end;

        AClientDataSet.Next;
      end;
    finally
      AClientDataSet.GotoBookmark(Bookmark);
      AClientDataSet.EnableControls;
    end;

    XMLDoc.SaveToFile(ACaminhoArquivo);

    // Gera hash e atualiza DTO
    NovoHashXML := GerarHashXML();
    ATabelaDTO.HashXML := NovoHashXML;
    ATabelaDTO.CaminhoArquivoXML := ACaminhoArquivo; // Garante que o caminho est� atualizado

  finally
    XMLDoc := nil; // Freeandnil não funciona, mas nil funciona
  end;
end;

function TXMLService.ObterDimensoesDoXML(const ACaminhoArquivo: string): string;
var
  TempClientDataSet: TClientDataSet;
  NumLinhas: Integer;
  NumColunas: Integer;
begin
  Result := 'Erro desconhecido';
  if (ACaminhoArquivo = '') or not FileExists(ACaminhoArquivo) then
  begin
    Result := 'Arquivo não encontrado';
    Exit;
  end;

  TempClientDataSet := TClientDataSet.Create(nil);
  try
    try
      Self.LerXML(TempClientDataSet, ACaminhoArquivo);
      if TempClientDataSet.Active and not TempClientDataSet.IsEmpty then
      begin
        // Número de registros de dados (linhas)
        NumLinhas := TempClientDataSet.RecordCount;
        // Número de campos (colunas)
        NumColunas := TempClientDataSet.FieldCount;

        Result := Format('%dx%d', [NumLinhas, NumColunas]);
      end
      else
      begin
        // Dataset vazio ou não ativado corretamente
        Result := '0x0 (dataset vazio ou inativo)';
      end;
    except
      on E: Exception do
      begin
        Result := 'Erro ao carregar/ler XML: ' + E.ClassName;
      end;
    end;
  finally
    TempClientDataSet.Free;
  end;
end;

class function TXMLService.LerXMLConfiguraçãoRelatório(const ACaminhoArquivo: string): string;
var
  LConteudoArquivo: string;
  LTagInicio, LTagFim: string;
  LPosicaoInicio, LPosicaoFim: Integer;
begin
  Result := '';
  if not TFile.Exists(ACaminhoArquivo) then
    Exit;

  LConteudoArquivo := TFile.ReadAllText(ACaminhoArquivo, TEncoding.UTF8);

  // Assume que o conteúdo relevante está dentro do elemento <Relatorio>
  LTagInicio := '<Relatorio>';
  LTagFim := '</Relatorio>';
  LPosicaoInicio := Pos(LTagInicio, LConteudoArquivo);
  LPosicaoFim := Pos(LTagFim, LConteudoArquivo);

  if (LPosicaoInicio > 0) and (LPosicaoFim > LPosicaoInicio) then
  begin
    Inc(LPosicaoInicio, Length(LTagInicio));
    Result := Copy(LConteudoArquivo, LPosicaoInicio, LPosicaoFim - LPosicaoInicio);
  end;
end;

class function TXMLService.GravarXMLConfiguraçãoRelatório(const ACaminhoArquivo: string; const AConfiguracaoString: string): Boolean;
var
  LDiretorio: string;
  LConteudoXML: string;
begin
  Result := False;
  // Obtém o diretório do caminho completo do arquivo
  LDiretorio := TPath.GetDirectoryName(ACaminhoArquivo);

  // Cria o diretório se ele não existir
  if not TDirectory.Exists(LDiretorio) then
    TDirectory.CreateDirectory(LDiretorio);

  // Monta o conteúdo XML completo
  LConteudoXML := '<?xml version="1.0" encoding="utf-8"?>' + sLineBreak +
                  '<Relatorio>' + AConfiguracaoString + '</Relatorio>';

  try
    // Escreve o conteúdo no arquivo
    TFile.WriteAllText(ACaminhoArquivo, LConteudoXML, TEncoding.UTF8);
    Result := True;
  except
    // Em caso de erro na gravação
    Result := False;
  end;
end;

class function TXMLService.LerXMLAssociacao(const ACaminhoArquivo: string): string;
var
  XMLContent: string;
  StartPos, EndPos: Integer;
begin
  Result := '';
  if not TFile.Exists(ACaminhoArquivo) then
    Exit;

  XMLContent := TFile.ReadAllText(ACaminhoArquivo, TEncoding.UTF8);

  // Procura pela tag <Associacao>...</Associacao>
  StartPos := Pos('<Associacao>', XMLContent);
  if StartPos > 0 then
  begin
    Inc(StartPos, Length('<Associacao>'));
    EndPos := Pos('</Associacao>', XMLContent);
    if EndPos > StartPos then
      Result := Copy(XMLContent, StartPos, EndPos - StartPos);
  end;
end;

class function TXMLService.GravarXMLAssociacao(const ACaminhoArquivo: string; const AAssociacaoString: string): Boolean;
var
  XMLContent: string;
begin
  Result := False;
  try
    XMLContent := '<?xml version="1.0" encoding="utf-8"?>' + sLineBreak +
                  '<Associacao>' + AAssociacaoString + '</Associacao>' + sLineBreak;
    TFile.WriteAllText(ACaminhoArquivo, XMLContent, TEncoding.UTF8);
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

end.

end.
