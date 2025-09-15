unit UXMLService;

interface

uses
  System.SysUtils, System.Classes, Xml.XMLDoc, Xml.XMLIntf, UTabelaDTO, Data.DB, Datasnap.DBClient;

type
  EXMLServiceException = class(Exception);

  /// Serviço para manipulação de arquivos XML no formato específico da aplicação.
  TXMLService = class
  private
    /// Converte um índice numérico para a letra da coluna (A, B, ..., Z, AA, AB, ...).
    // <param name="AIndice"> Índice base 1 da coluna.</param>
    // <returns> Letra correspondente à coluna.</returns>
    function IndiceParaLetraColuna(AIndice: Integer): string;

    /// Converte a letra da coluna para um índice numérico.
    // <param name="ALetra"> Letra da coluna (A, B, ..., Z, AA, AB, ...).</param>
    // <returns> Índice base 1 da coluna.</returns>
    function LetraColunaParaIndice(ALetra: string): Integer;
  public
    /// Construtor do serviço.
    constructor Create;

    /// Destrutor do serviço.
    destructor Destroy; override;

    /// Lê um arquivo XML específico e popula o TTabelaDTO com os dados.
    // Assume que o DTO já tenha o CaminhoArquivoXML definido.
    // <param name="ATabelaDTO"> O DTO que será preenchido com os dados do XML.</param>
    // <param name="ADataSetDestino"> O TClientDataSet que será populado com os dados da grade.</param>
    procedure LerArquivoXML(ATabelaDTO: TTabelaDTO; ADataSetDestino: TClientDataSet);

    /// Salva os dados de um TClientDataSet em um arquivo XML no formato especificado.
    // O caminho do arquivo é obtido de ATabelaDTO.CaminhoArquivoXML.
    // <param name="ATabelaDTO"> O DTO contendo os metadados (título, caminho, ID).</param>
    // <param name="ADataSet"> O TClientDataSet contendo os dados da tabela a serem salvos.</param>
    procedure SalvarArquivoXML(ATabelaDTO: TTabelaDTO; ADataSet: TClientDataSet);
  end;

implementation

{ TXMLService }

constructor TXMLService.Create;
begin
  inherited Create;
end;

destructor TXMLService.Destroy;
begin
  inherited;
end;

// --- Funções auxiliares para colunas (baseadas em 1) ---
function TXMLService.IndiceParaLetraColuna(AIndice: Integer): string;
var
  Letra1, Letra2: string;
  TempIndice: Integer;
begin
  // AIndice é base 1 (1=A, 2=B, ..., 26=Z, 27=AA, ...)
  if (AIndice < 1) or (AIndice > 18278) then // 18278 = ZZZ
  begin
    raise EXMLServiceException.Create('Índice de coluna inválido: ' + IntToStr(AIndice));
  end;
  if AIndice <= 26 then
  begin
    Result := Chr(Ord('A') + AIndice - 1);
  end
  else if AIndice <= 702 then // 26 + 26*26
  begin
    TempIndice := AIndice - 1;
    Letra1 := Chr(Ord('A') + (TempIndice div 26) - 1);
    Letra2 := Chr(Ord('A') + (TempIndice mod 26));
    Result := Letra1 + Letra2;
  end
  else
  begin
    // Suporte para 3 letras (AAA, AAB, ...)
    TempIndice := AIndice - 1;
    Letra1 := Chr(Ord('A') + (TempIndice div 676) - 1); // 676 = 26*26
    TempIndice := TempIndice mod 676;
    Letra2 := Chr(Ord('A') + (TempIndice div 26) - 1);
    Result := Letra1 + Letra2 + Chr(Ord('A') + (TempIndice mod 26));
  end;
end;

function TXMLService.LetraColunaParaIndice(ALetra: string): Integer;
var
  i, Len: Integer;
begin
  Result := 0;
  Len := Length(ALetra);
  for i := 1 to Len do
  begin
    if (ALetra[i] < 'A') or (ALetra[i] > 'Z') then
    begin
       raise EXMLServiceException.Create('Letra de coluna inválida: ' + ALetra);
    end;
    Result := Result * 26 + (Ord(ALetra[i]) - Ord('A') + 1);
  end;
  // O cálculo acima já resulta em índice base 1
end;
// --- Fim das funções auxiliares ---

procedure TXMLService.LerArquivoXML(ATabelaDTO: TTabelaDTO; ADataSetDestino: TClientDataSet);
var
  XMLDoc: IXMLDocument;
  RootNode, RedorExtNode, RedorIntNode, TabelaNode, TituloNode: IXMLNode;
  LinhasNodeList: IXMLNodeList;
  LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  CelulasNodeList: IXMLNodeList;
  CaminhoArquivo: string;
  i, j, NumeroLinha, NumeroColunaIndice: Integer;
  NumeroLinhaStr, NumeroCelulaStr: string;
  ValorCelula: string;
  FieldName: string;
  MaxColunasEncontradas: Integer;
  ChildNode: IXMLNode; // Variável auxiliar para iterar
begin
  if not Assigned(ATabelaDTO) or (ATabelaDTO.CaminhoArquivoXML = '') then
    raise EXMLServiceException.Create('DTO ou CaminhoArquivoXML inválido para leitura.');
  CaminhoArquivo := ATabelaDTO.CaminhoArquivoXML;
  if not FileExists(CaminhoArquivo) then
    raise EXMLServiceException.Create('Arquivo XML não encontrado: ' + CaminhoArquivo);
  if not Assigned(ADataSetDestino) then
     raise EXMLServiceException.Create('TClientDataSet destino não fornecido.');
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromFile(CaminhoArquivo);
    XMLDoc.Active := True;
    // Inicializa o DTO
    ATabelaDTO.ID := -1;
    ATabelaDTO.Titulo := '';
    RootNode := XMLDoc.DocumentElement; // <Corpo>
    if (RootNode = nil) or (RootNode.NodeName <> 'Corpo') then
       raise EXMLServiceException.Create('Documento XML inválido: Raiz não é <Corpo>.');
    // Navegação corrigida para acessar os nós filhos
    if RootNode.ChildNodes.Count = 0 then
       raise EXMLServiceException.Create('Documento XML inválido: <Corpo> está vazio.');
    RedorExtNode := RootNode.ChildNodes.Get(0); // <Redor> externo
    if (RedorExtNode = nil) or (RedorExtNode.NodeName <> 'Redor') then
       raise EXMLServiceException.Create('Documento XML inválido: Falta <Redor> externo.');
    if RedorExtNode.ChildNodes.Count = 0 then
       raise EXMLServiceException.Create('Documento XML inválido: <Redor> externo está vazio.');
    RedorIntNode := RedorExtNode.ChildNodes.Get(0); // <Redor> interno
    if (RedorIntNode = nil) or (RedorIntNode.NodeName <> 'Redor') then
       raise EXMLServiceException.Create('Documento XML inválido: Falta <Redor> interno.');
    if RedorIntNode.ChildNodes.Count = 0 then
       raise EXMLServiceException.Create('Documento XML inválido: <Redor> interno está vazio.');
    TabelaNode := RedorIntNode.ChildNodes.Get(0); // <Tabela>
    if (TabelaNode = nil) or (TabelaNode.NodeName <> 'Tabela') then
       raise EXMLServiceException.Create('Documento XML inválido: Falta <Tabela>.');
    // --- Leitura de Metadados ---
    // Lê o ID
    if TabelaNode.HasAttribute('id') then
      ATabelaDTO.ID := StrToIntDef(TabelaNode.Attributes['id'], -1);
    // Lê o Título
    TituloNode := TabelaNode.ChildNodes.FindNode('Titulo');
    if Assigned(TituloNode) and (TituloNode.Text <> '') then
      ATabelaDTO.Titulo := TituloNode.Text
    else
      ATabelaDTO.Titulo := ChangeFileExt(ExtractFileName(CaminhoArquivo), ''); // Fallback
    // --- Leitura das Linhas e Células ---
    ADataSetDestino.Close;
    ADataSetDestino.FieldDefs.Clear; // Limpa campos existentes
    // Primeira passagem: Determinar o número máximo de colunas
    MaxColunasEncontradas := 0;
    // LinhasNodeList := TabelaNode.ChildNodes; // <-- Erro corrigido
    // Usar FindNode para 'Linha' não funciona diretamente para múltiplos nós.
    // A melhor forma é iterar por todos os nós filhos e verificar o nome.
    for i := 0 to TabelaNode.ChildNodes.Count - 1 do
    begin
      ChildNode := TabelaNode.ChildNodes.Get(i);
      if (ChildNode <> nil) and (ChildNode.NodeName = 'Linha') then
      begin
         LinhaNode := ChildNode; // Trata ChildNode como LinhaNode
         ColunasNode := LinhaNode.ChildNodes.FindNode('Colunas');
         if Assigned(ColunasNode) then
         begin
           // Iterar pelas células dentro de <Colunas>
           for j := 0 to ColunasNode.ChildNodes.Count - 1 do
           begin
             CelulaNode := ColunasNode.ChildNodes.Get(j);
             if (CelulaNode <> nil) and (CelulaNode.NodeName = 'Celula') then
             begin
               NumeroCelulaStr := CelulaNode.Attributes['numero'];
               if NumeroCelulaStr <> '' then
               begin
                  try
                    NumeroColunaIndice := LetraColunaParaIndice(NumeroCelulaStr);
                    if NumeroColunaIndice > MaxColunasEncontradas then
                      MaxColunasEncontradas := NumeroColunaIndice;
                  except
                    on E: Exception do
                      raise EXMLServiceException.Create('Erro ao processar célula na linha ' + IntToStr(i+1) + ': ' + E.Message);
                  end;
               end;
             end;
           end;
         end;
      end;
    end;
    // Configura o ClientDataSet com o número correto de colunas
    if MaxColunasEncontradas = 0 then MaxColunasEncontradas := 1; // Garante pelo menos uma coluna
    for i := 1 to MaxColunasEncontradas do
    begin
      ADataSetDestino.FieldDefs.Add('Coluna' + IntToStr(i), ftString, 300); // Tamanho máximo 300
    end;
    ADataSetDestino.CreateDataSet;
    ADataSetDestino.Open;
    // Segunda passagem: Popular os dados
    ADataSetDestino.EmptyDataSet; // Limpa dados existentes
    // Re-iterar para popular os dados
    for i := 0 to TabelaNode.ChildNodes.Count - 1 do
    begin
      ChildNode := TabelaNode.ChildNodes.Get(i);
      if (ChildNode <> nil) and (ChildNode.NodeName = 'Linha') then
      begin
        ADataSetDestino.Append; // Adiciona nova linha no ClientDataSet
        LinhaNode := ChildNode; // Trata ChildNode como LinhaNode
        ColunasNode := LinhaNode.ChildNodes.FindNode('Colunas');
        if Assigned(ColunasNode) then
        begin
          // Iterar pelas células dentro de <Colunas>
          for j := 0 to ColunasNode.ChildNodes.Count - 1 do
          begin
            CelulaNode := ColunasNode.ChildNodes.Get(j);
            if (CelulaNode <> nil) and (CelulaNode.NodeName = 'Celula') then
            begin
              NumeroCelulaStr := CelulaNode.Attributes['numero'];
              ValorCelula := CelulaNode.Text;
              if NumeroCelulaStr <> '' then
              begin
                try
                  NumeroColunaIndice := LetraColunaParaIndice(NumeroCelulaStr);
                  // Verifica se o índice da coluna é válido para o ClientDataSet
                  if (NumeroColunaIndice >= 1) and (NumeroColunaIndice <= ADataSetDestino.FieldCount) then
                  begin
                    FieldName := 'Coluna' + IntToStr(NumeroColunaIndice);
                    ADataSetDestino.FieldByName(FieldName).AsString := ValorCelula;
                  end;
                except
                  on E: Exception do
                    raise EXMLServiceException.Create('Erro ao processar célula na linha ' + IntToStr(i+1) + ': ' + E.Message);
                end;
              end;
            end;
          end;
        end;
        ADataSetDestino.Post; // Confirma a linha no ClientDataSet
      end;
    end;
    // Garante que haja pelo menos uma linha vazia se o arquivo estiver vazio
    if ADataSetDestino.IsEmpty then
       ADataSetDestino.AppendRecord([nil]);
  finally
    XMLDoc := nil; // Libera a interface
  end;
end;

procedure TXMLService.SalvarArquivoXML(ATabelaDTO: TTabelaDTO; ADataSet: TClientDataSet);
var
  XMLDoc: IXMLDocument;
  ProcInst: IXMLNode;
  RootNode, RedorExtNode, RedorIntNode, TabelaNode, TituloNode, LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  i, j: Integer;
  ValorCelula: string;
  CaminhoArquivo: string;
  HasData: Boolean; // Flag para verificar se há dados
begin
  if not Assigned(ATabelaDTO) or (ATabelaDTO.Titulo = '') or not Assigned(ADataSet) then
    raise EXMLServiceException.Create('DTO, Título ou TClientDataSet inválido para salvamento.');
  CaminhoArquivo := ATabelaDTO.CaminhoArquivoXML;
  if CaminhoArquivo = '' then
     raise EXMLServiceException.Create('Caminho do arquivo XML não definido no DTO.');

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.Active := True;
    XMLDoc.Encoding := 'UTF-8';

    // Cria o nó raiz <Corpo>
    RootNode := XMLDoc.AddChild('Corpo');

    // Adiciona a instrução de processamento <?xml-stylesheet ... ?>
    ProcInst := XMLDoc.CreateNode('xml-stylesheet type="text/css" href="estilo.css"', ntProcessingInstr);
    XMLDoc.ChildNodes.Insert(0, ProcInst); // Insere como primeiro nó do documento

    // Cria a estrutura aninhada <Redor><Redor><Tabela>
    RedorExtNode := RootNode.AddChild('Redor');
    RedorIntNode := RedorExtNode.AddChild('Redor');
    TabelaNode := RedorIntNode.AddChild('Tabela');

    // Define o atributo 'id' da Tabela
    TabelaNode.Attributes['id'] := IntToStr(ATabelaDTO.ID); // Assume que o ID já foi definido

    // Adiciona o <Titulo>
    TituloNode := TabelaNode.AddChild('Titulo');
    TituloNode.Text := ATabelaDTO.Titulo;

    // --- Salvar as linhas e células do TClientDataSet ---
    HasData := False; // Inicializa a flag

    if not ADataSet.IsEmpty and (ADataSet.RecordCount > 0) then
    begin
      ADataSet.First;
      i := 1; // Número da linha no XML (começando de 1)
      while not ADataSet.Eof do
      begin
        // Verifica se a linha atual tem algum dado
        HasData := False;
        for j := 0 to ADataSet.FieldCount - 1 do
        begin
          if Trim(ADataSet.Fields[j].AsString) <> '' then
          begin
            HasData := True;
            Break;
          end;
        end;

        if HasData then // Só salva a linha se tiver dados
        begin
          // <Linha numero="X">
          LinhaNode := TabelaNode.AddChild('Linha');
          LinhaNode.Attributes['numero'] := IntToStr(i);

          // <Colunas>
          ColunasNode := LinhaNode.AddChild('Colunas');

          // Percorre os campos (colunas) do ClientDataSet e salva
          for j := 0 to ADataSet.FieldCount - 1 do
          begin
            ValorCelula := ADataSet.Fields[j].AsString;
            // Salva a célula apenas se tiver conteúdo (ou sempre, dependendo do requisito)
            if Trim(ValorCelula) <> '' then
            begin
              // <Celula numero="Y">Valor</Celula>
              CelulaNode := ColunasNode.AddChild('Celula');
              // Converte índice base 0 para letra de coluna (A=1, B=2, ...)
              CelulaNode.Attributes['numero'] := IndiceParaLetraColuna(j + 1);
              CelulaNode.Text := ValorCelula; // Usa o valor completo, incluindo espaços internos
            end;
          end;
        end;
        ADataSet.Next;
        Inc(i);
      end;
    end;

    // Se não houver dados em nenhuma linha, salva pelo menos uma linha vazia
    if not HasData then
    begin
       LinhaNode := TabelaNode.AddChild('Linha');
       LinhaNode.Attributes['numero'] := '1';
       ColunasNode := LinhaNode.AddChild('Colunas');
       // Adicionando uma célula vazia para a primeira coluna:
       CelulaNode := ColunasNode.AddChild('Celula');
       CelulaNode.Attributes['numero'] := 'A';
       CelulaNode.Text := '';
    end;
    // --- Fim do salvamento das linhas e células ---

    XMLDoc.SaveToFile(CaminhoArquivo);
  finally
    XMLDoc := nil;
  end;
end;

end.
