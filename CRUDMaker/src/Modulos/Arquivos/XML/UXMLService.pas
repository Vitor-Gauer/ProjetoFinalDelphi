unit UXMLService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient, System.IOUtils,
  System.StrUtils, System.Math,  // Para Random, StringReplace, TryStrToInt, CharInSet etc.
  Xml.XMLDoc, Xml.XMLIntf, UTabelaDTO; // Adiciona unidades XML

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
    procedure GravarXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);

    // Fun��o auxiliar para obter o hash gerado (se necess�rio fora do GravarXML).
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

procedure TXMLService.GravarXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO);
var
  XMLDoc: IXMLDocument;
  RootNode, Redor1Node, Redor2Node, TabelaNode, TituloNode: IXMLNode;
  LinhaNode, ColunasNode, CelulaNode: IXMLNode;
  Bookmark: TBookmark;
  i, j: Integer;
  Field: TField;
  NovoHashXML: string;
begin
  if not Assigned(AClientDataSet) or not AClientDataSet.Active then
    raise Exception.Create('ClientDataSet inv�lido ou n�o ativo.');

  if (ACaminhoArquivo = '') then
    raise Exception.Create('Caminho do arquivo XML inv�lido.');

  if not Assigned(ATabelaDTO) then
     raise Exception.Create('DTO da tabela n�o fornecido para atualiza��o do hash.');

  XMLDoc := TXMLDocument.Create(nil);
  try
    // Cria a estrutura b�sica do XML
    XMLDoc.Active := True;
    RootNode := XMLDoc.AddChild('Corpo');
    Redor1Node := RootNode.AddChild('Redor');
    Redor2Node := Redor1Node.AddChild('Redor');
    TabelaNode := Redor2Node.AddChild('Tabela');
    TituloNode := TabelaNode.AddChild('Titulo');
    TituloNode.Text := ATabelaDTO.Titulo; // Usa o t�tulo do DTO

    // Salva posi��o atual
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
    XMLDoc := nil;
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

end.
