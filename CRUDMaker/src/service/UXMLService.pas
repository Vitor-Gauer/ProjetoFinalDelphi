unit UXMLService;

interface

uses
  System.SysUtils, System.Classes, Xml.XMLDoc, Xml.XMLIntf, UTabelaDTO, Data.DB, Datasnap.DBClient;

type
  EXMLServiceException = class(Exception);

  /// Servi�o para manipula��o de arquivos XML no formato espec�fico da aplica��o.
  TXMLService = class
  private
    /// Converte um �ndice num�rico para a letra da coluna (A, B, ..., Z, AA, AB, ...).
    // <param name="AIndice"> �ndice base 1 da coluna.</param>
    // <returns> Letra correspondente � coluna.</returns>
    function IndiceParaLetraColuna(AIndice: Integer): string;

    /// Converte a letra da coluna para um �ndice num�rico.
    // <param name="ALetra"> Letra da coluna (A, B, ..., Z, AA, AB, ...).</param>
    // <returns> �ndice base 1 da coluna.</returns>
    function LetraColunaParaIndice(ALetra: string): Integer;
  public
    /// Construtor do servi�o.
    constructor Create;

    /// Destrutor do servi�o.
    destructor Destroy; override;

    /// L� um arquivo XML espec�fico e popula o TTabelaDTO com os dados.
    // Assume que o DTO j� tenha o CaminhoArquivoXML definido.
    // <param name="ATabelaDTO"> O DTO que ser� preenchido com os dados do XML.</param>
    // <param name="ADataSetDestino"> O TClientDataSet que ser� populado com os dados da grade.</param>
    procedure LerArquivoXML(ATabelaDTO: TTabelaDTO; ADataSetDestino: TClientDataSet);

    /// Salva os dados de um TClientDataSet em um arquivo XML no formato especificado.
    // O caminho do arquivo � obtido de ATabelaDTO.CaminhoArquivoXML.
    // <param name="ATabelaDTO"> O DTO contendo os metadados (t�tulo, caminho, ID).</param>
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

// --- Fun��es auxiliares para colunas (baseadas em 1) ---
function TXMLService.IndiceParaLetraColuna(AIndice: Integer): string;
var
  Letra1, Letra2: string;
  TempIndice: Integer;
begin
  // AIndice � base 1 (1=A, 2=B, ..., 26=Z, 27=AA, ...)
  if (AIndice < 1) or (AIndice > 18278) then // 18278 = ZZZ
  begin
    raise EXMLServiceException.Create('�ndice de coluna inv�lido: ' + IntToStr(AIndice));
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
       raise EXMLServiceException.Create('Letra de coluna inv�lida: ' + ALetra);
    end;
    Result := Result * 26 + (Ord(ALetra[i]) - Ord('A') + 1);
  end;
  // O c�lculo acima j� resulta em �ndice base 1
end;
// --- Fim das fun��es auxiliares ---

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
  ChildNode: IXMLNode; // Vari�vel auxiliar para iterar
begin
  if not Assigned(ATabelaDTO) or (ATabelaDTO.CaminhoArquivoXML = '') then
    raise EXMLServiceException.Create('DTO ou CaminhoArquivoXML inv�lido para leitura.');
  CaminhoArquivo := ATabelaDTO.CaminhoArquivoXML;
  if not FileExists(CaminhoArquivo) then
    raise EXMLServiceException.Create('Arquivo XML n�o encontrado: ' + CaminhoArquivo);
  if not Assigned(ADataSetDestino) then
     raise EXMLServiceException.Create('TClientDataSet destino n�o fornecido.');
  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.LoadFromFile(CaminhoArquivo);
    XMLDoc.Active := True;
    // Inicializa o DTO
    ATabelaDTO.ID := -1;
    ATabelaDTO.Titulo := '';
    RootNode := XMLDoc.DocumentElement; // <Corpo>
    if (RootNode = nil) or (RootNode.NodeName <> 'Corpo') then
       raise EXMLServiceException.Create('Documento XML inv�lido: Raiz n�o � <Corpo>.');
    // Navega��o corrigida para acessar os n�s filhos
    if RootNode.ChildNodes.Count = 0 then
       raise EXMLServiceException.Create('Documento XML inv�lido: <Corpo> est� vazio.');
    RedorExtNode := RootNode.ChildNodes.Get(0); // <Redor> externo
    if (RedorExtNode = nil) or (RedorExtNode.NodeName <> 'Redor') then
       raise EXMLServiceException.Create('Documento XML inv�lido: Falta <Redor> externo.');
    if RedorExtNode.ChildNodes.Count = 0 then
       raise EXMLServiceException.Create('Documento XML inv�lido: <Redor> externo est� vazio.');
    RedorIntNode := RedorExtNode.ChildNodes.Get(0); // <Redor> interno
    if (RedorIntNode = nil) or (RedorIntNode.NodeName <> 'Redor') then
       raise EXMLServiceException.Create('Documento XML inv�lido: Falta <Redor> interno.');
    if RedorIntNode.ChildNodes.Count = 0 then
       raise EXMLServiceException.Create('Documento XML inv�lido: <Redor> interno est� vazio.');
    TabelaNode := RedorIntNode.ChildNodes.Get(0); // <Tabela>
    if (TabelaNode = nil) or (TabelaNode.NodeName <> 'Tabela') then
       raise EXMLServiceException.Create('Documento XML inv�lido: Falta <Tabela>.');
    // --- Leitura de Metadados ---
    // L� o ID
    if TabelaNode.HasAttribute('id') then
      ATabelaDTO.ID := StrToIntDef(TabelaNode.Attributes['id'], -1);
    // L� o T�tulo
    TituloNode := TabelaNode.ChildNodes.FindNode('Titulo');
    if Assigned(TituloNode) and (TituloNode.Text <> '') then
      ATabelaDTO.Titulo := TituloNode.Text
    else
      ATabelaDTO.Titulo := ChangeFileExt(ExtractFileName(CaminhoArquivo), ''); // Fallback
    // --- Leitura das Linhas e C�lulas ---
    ADataSetDestino.Close;
    ADataSetDestino.FieldDefs.Clear; // Limpa campos existentes
    // Primeira passagem: Determinar o n�mero m�ximo de colunas
    MaxColunasEncontradas := 0;
    // LinhasNodeList := TabelaNode.ChildNodes; // <-- Erro corrigido
    // Usar FindNode para 'Linha' n�o funciona diretamente para m�ltiplos n�s.
    // A melhor forma � iterar por todos os n�s filhos e verificar o nome.
    for i := 0 to TabelaNode.ChildNodes.Count - 1 do
    begin
      ChildNode := TabelaNode.ChildNodes.Get(i);
      if (ChildNode <> nil) and (ChildNode.NodeName = 'Linha') then
      begin
         LinhaNode := ChildNode; // Trata ChildNode como LinhaNode
         ColunasNode := LinhaNode.ChildNodes.FindNode('Colunas');
         if Assigned(ColunasNode) then
         begin
           // Iterar pelas c�lulas dentro de <Colunas>
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
                      raise EXMLServiceException.Create('Erro ao processar c�lula na linha ' + IntToStr(i+1) + ': ' + E.Message);
                  end;
               end;
             end;
           end;
         end;
      end;
    end;
    // Configura o ClientDataSet com o n�mero correto de colunas
    if MaxColunasEncontradas = 0 then MaxColunasEncontradas := 1; // Garante pelo menos uma coluna
    for i := 1 to MaxColunasEncontradas do
    begin
      ADataSetDestino.FieldDefs.Add('Coluna' + IntToStr(i), ftString, 300); // Tamanho m�ximo 300
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
          // Iterar pelas c�lulas dentro de <Colunas>
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
                  // Verifica se o �ndice da coluna � v�lido para o ClientDataSet
                  if (NumeroColunaIndice >= 1) and (NumeroColunaIndice <= ADataSetDestino.FieldCount) then
                  begin
                    FieldName := 'Coluna' + IntToStr(NumeroColunaIndice);
                    ADataSetDestino.FieldByName(FieldName).AsString := ValorCelula;
                  end;
                except
                  on E: Exception do
                    raise EXMLServiceException.Create('Erro ao processar c�lula na linha ' + IntToStr(i+1) + ': ' + E.Message);
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
  HasData: Boolean; // Flag para verificar se h� dados
begin
  if not Assigned(ATabelaDTO) or (ATabelaDTO.Titulo = '') or not Assigned(ADataSet) then
    raise EXMLServiceException.Create('DTO, T�tulo ou TClientDataSet inv�lido para salvamento.');
  CaminhoArquivo := ATabelaDTO.CaminhoArquivoXML;
  if CaminhoArquivo = '' then
     raise EXMLServiceException.Create('Caminho do arquivo XML n�o definido no DTO.');

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.Active := True;
    XMLDoc.Encoding := 'UTF-8';

    // Cria o n� raiz <Corpo>
    RootNode := XMLDoc.AddChild('Corpo');

    // Adiciona a instru��o de processamento <?xml-stylesheet ... ?>
    ProcInst := XMLDoc.CreateNode('xml-stylesheet type="text/css" href="estilo.css"', ntProcessingInstr);
    XMLDoc.ChildNodes.Insert(0, ProcInst); // Insere como primeiro n� do documento

    // Cria a estrutura aninhada <Redor><Redor><Tabela>
    RedorExtNode := RootNode.AddChild('Redor');
    RedorIntNode := RedorExtNode.AddChild('Redor');
    TabelaNode := RedorIntNode.AddChild('Tabela');

    // Define o atributo 'id' da Tabela
    TabelaNode.Attributes['id'] := IntToStr(ATabelaDTO.ID); // Assume que o ID j� foi definido

    // Adiciona o <Titulo>
    TituloNode := TabelaNode.AddChild('Titulo');
    TituloNode.Text := ATabelaDTO.Titulo;

    // --- Salvar as linhas e c�lulas do TClientDataSet ---
    HasData := False; // Inicializa a flag

    if not ADataSet.IsEmpty and (ADataSet.RecordCount > 0) then
    begin
      ADataSet.First;
      i := 1; // N�mero da linha no XML (come�ando de 1)
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

        if HasData then // S� salva a linha se tiver dados
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
            // Salva a c�lula apenas se tiver conte�do (ou sempre, dependendo do requisito)
            if Trim(ValorCelula) <> '' then
            begin
              // <Celula numero="Y">Valor</Celula>
              CelulaNode := ColunasNode.AddChild('Celula');
              // Converte �ndice base 0 para letra de coluna (A=1, B=2, ...)
              CelulaNode.Attributes['numero'] := IndiceParaLetraColuna(j + 1);
              CelulaNode.Text := ValorCelula; // Usa o valor completo, incluindo espa�os internos
            end;
          end;
        end;
        ADataSet.Next;
        Inc(i);
      end;
    end;

    // Se n�o houver dados em nenhuma linha, salva pelo menos uma linha vazia
    if not HasData then
    begin
       LinhaNode := TabelaNode.AddChild('Linha');
       LinhaNode.Attributes['numero'] := '1';
       ColunasNode := LinhaNode.AddChild('Colunas');
       // Adicionando uma c�lula vazia para a primeira coluna:
       CelulaNode := ColunasNode.AddChild('Celula');
       CelulaNode.Attributes['numero'] := 'A';
       CelulaNode.Text := '';
    end;
    // --- Fim do salvamento das linhas e c�lulas ---

    XMLDoc.SaveToFile(CaminhoArquivo);
  finally
    XMLDoc := nil;
  end;
end;

end.
