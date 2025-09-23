unit UXMLService;

interface

uses
  System.SysUtils, System.Classes, Xml.XMLDoc, Xml.XMLIntf, UTabelaDTO, Data.DB, Datasnap.DBClient;

type
  EXMLServiceException = class(Exception);

  TXMLService = class
  private
    // Fun��o auxiliar para converter �ndice num�rico para letra de coluna (A, B, ..., Z, AA, AB, ...)
    function IndiceParaLetraColuna(AIndice: Integer): string;
    // Fun��o auxiliar para converter letra de coluna para �ndice num�rico
    function LetraColunaParaIndice(ALetra: string): Integer;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>
    /// L� um arquivo XML espec�fico e popula o TTabelaDTO com os dados.
    /// Assume que o DTO j� tenha o CaminhoArquivoXML definido.
    /// </summary>
    /// <param name="ATabelaDTO">O DTO que ser� preenchido com os dados do XML.</param>
    /// <param name="ADataSetDestino">O TClientDataSet que ser� populado com os dados da grade.</param>
    procedure LerArquivoXML(ATabelaDTO: TTabelaDTO; ADataSetDestino: TClientDataSet);

    /// <summary>
    /// Salva os dados de um TClientDataSet em um arquivo XML no formato especificado.
    /// O caminho do arquivo � obtido de ATabelaDTO.CaminhoArquivoXML.
    /// </summary>
    /// <param name="ATabelaDTO">O DTO contendo os metadados (t�tulo, caminho, ID).</param>
    /// <param name="ADataSet">O TClientDataSet contendo os dados da tabela a serem salvos.</param>
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
  LinhasNodeList: IXMLNodeList; // <-- Corre��o: usar IXMLNodeList
  LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  CelulasNodeList: IXMLNodeList; // <-- Corre��o: usar IXMLNodeList
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
  ProcInst: IXMLNode; // <-- Para a instru��o de processamento
  RootNode, RedorExtNode, RedorIntNode, TabelaNode, TituloNode, LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  i, j: Integer;
  NumeroLinhaStr: string;
  ValorCelula: string;
  NomeCampo: string;
  CaminhoArquivo: string;
begin
  if not Assigned(ATabelaDTO) or (ATabelaDTO.Titulo = '') or not Assigned(ADataSet) then
    raise EXMLServiceException.Create('DTO, T�tulo ou TClientDataSet inv�lido para salvamento.');

  CaminhoArquivo := ATabelaDTO.CaminhoArquivoXML;
  if CaminhoArquivo = '' then
     raise EXMLServiceException.Create('Caminho do arquivo XML n�o definido no DTO.');

  XMLDoc := TXMLDocument.Create(nil);
  try
    XMLDoc.Active := True;
    // <?xml version="1.0" encoding="UTF-8"?>
    XMLDoc.Encoding := 'UTF-8';

    // Cria e adiciona a instru��o de processamento <?xml-stylesheet ?> ANTES do n� raiz
    // Isso � feito adicionando-a ao documento, n�o a um n� espec�fico.
    ProcInst := XMLDoc.CreateNode('xml-stylesheet type="text/css" href="estilo.css"', ntProcessingInstr);
    XMLDoc.DocumentElement := ProcInst; // Isso pode n�o funcionar como esperado

    // Uma abordagem mais confi�vel � criar o n� raiz primeiro e depois inserir a instru��o
    // como o primeiro filho do documento.
    RootNode := XMLDoc.AddChild('Corpo');

    // Cria a instru��o de processamento
    ProcInst := XMLDoc.CreateNode('xml-stylesheet type="text/css" href="estilo.css"', ntProcessingInstr);
    // Insere a instru��o de processamento como o primeiro n� do documento
    // O m�todo InsertBefore funciona com o DocumentElement (RootNode)
    XMLDoc.DocumentElement.Parent.InsertBefore(ProcInst, XMLDoc.DocumentElement);


    // <Redor> externo
    RedorExtNode := RootNode.AddChild('Redor');

    // <Redor> interno
    RedorIntNode := RedorExtNode.AddChild('Redor');

    // <Tabela id="X">
    TabelaNode := RedorIntNode.AddChild('Tabela');
    // O ID deve ser gerenciado antes de chamar este m�todo
    TabelaNode.Attributes['id'] := IntToStr(ATabelaDTO.ID);

    // <Titulo>...</Titulo>
    TituloNode := TabelaNode.AddChild('Titulo');
    TituloNode.Text := ATabelaDTO.Titulo;

    // --- Salvar as linhas e c�lulas do TClientDataSet ---
    if not ADataSet.IsEmpty and (ADataSet.RecordCount > 0) then
    begin
      ADataSet.First;
      i := 1; // N�mero da linha no XML (come�ando de 1)
      while not ADataSet.Eof do
      begin
        // <Linha numero="X">
        LinhaNode := TabelaNode.AddChild('Linha');
        NumeroLinhaStr := IntToStr(i);
        LinhaNode.Attributes['numero'] := NumeroLinhaStr;

        // <Colunas>
        ColunasNode := LinhaNode.AddChild('Colunas');

        // Percorre os campos (colunas) do ClientDataSet
        // Salva todas as colunas que existem no ClientDataSet
        for j := 0 to ADataSet.FieldCount - 1 do
        begin
          // <Celula numero="Y">Valor</Celula>
          // Converte �ndice base 0 para base 1 e depois para letra
          CelulaNode := ColunasNode.AddChild('Celula');
          CelulaNode.Attributes['numero'] := IndiceParaLetraColuna(j + 1); // j+1 � �ndice base 1

          // Obt�m o valor do campo
          ValorCelula := '';
          if Assigned(ADataSet.Fields[j]) then
            ValorCelula := ADataSet.Fields[j].AsString;

          CelulaNode.Text := ValorCelula;
        end;

        ADataSet.Next;
        Inc(i);
      end;
    end
    else
    begin
       // Se o ClientDataSet estiver vazio, salva pelo menos uma linha vazia
       LinhaNode := TabelaNode.AddChild('Linha');
       LinhaNode.Attributes['numero'] := '1';
       ColunasNode := LinhaNode.AddChild('Colunas');
       // Adiciona c�lulas vazias para as 200 colunas padr�o, se necess�rio
       // Ou apenas uma c�lula vazia para a Coluna1
       CelulaNode := ColunasNode.AddChild('Celula');
       CelulaNode.Attributes['numero'] := 'A';
       CelulaNode.Text := '';
    end;
    // --- Fim do salvamento das linhas e c�lulas ---

    // Salva o arquivo
    XMLDoc.SaveToFile(CaminhoArquivo);
  finally
    XMLDoc := nil;
  end;
end;

end.
