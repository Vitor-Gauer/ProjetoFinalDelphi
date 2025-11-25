unit UXMLService;

interface

uses
  System.Classes, System.SysUtils, Data.DB, Datasnap.DBClient, System.IOUtils,
  System.StrUtils, System.Math, VCL.Forms,
  XMLDoc, XMLIntf, MSXML, UTabelaDTO, UTabelaConfiguracaoDTO;

type
  TXMLService = class
  private
    function GerarHashXML: string;
  public
    procedure LerXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string);
    procedure GravarXML(const AClientDataSet: TClientDataSet; const ACaminhoArquivo: string; ATabelaDTO: TTabelaDTO; const AConfiguracao: TConfiguracaoTabelaDTO);
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
  Randomize;

  for i := 1 to 5 do
  begin
    Result := Result + Letras[Random(Length(Letras)) + 1];
  end;

  for i := 6 to 20 do
  begin
    Result := Result + Alfanumericos[Random(Length(Alfanumericos)) + 1];
  end;
end;

function TXMLService.ObterUltimoHashGerado: string;
begin
  Result := GerarHashXML;
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

    TabelaNode := XMLDoc.DocumentElement.ChildNodes.FindNode('Redor');
    if Assigned(TabelaNode) then
      TabelaNode := TabelaNode.ChildNodes.FindNode('Redor');
    if Assigned(TabelaNode) then
      TabelaNode := TabelaNode.ChildNodes.FindNode('Tabela');

    if not Assigned(TabelaNode) then
      raise Exception.Create('Estrutura XML inv�lida: n� <Tabela> n�o encontrado.');

    MaxColunas := 0;
    LinhasNodeList := TabelaNode.ChildNodes.FindNode('Linha').ChildNodes.FindNode('Colunas').ChildNodes;
    if Assigned(LinhasNodeList) then
      MaxColunas := LinhasNodeList.Count;

    for i := 1 to MaxColunas do
    begin
      FieldDef := AClientDataSet.FieldDefs.AddFieldDef;
      FieldDef.Name := 'Coluna' + IntToStr(i);
      FieldDef.DataType := ftString;
      FieldDef.Size := 300;
    end;

    AClientDataSet.CreateDataSet;
    AClientDataSet.Open;

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
    XMLDoc := nil;
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
    XMLDoc.ChildNodes.Insert(1, RootNode);
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

    NovoHashXML := GerarHashXML();
    ATabelaDTO.HashXML := NovoHashXML;
    ATabelaDTO.CaminhoArquivoXML := ACaminhoArquivo;

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
        NumLinhas := TempClientDataSet.RecordCount;
        NumColunas := TempClientDataSet.FieldCount;

        Result := Format('%dx%d', [NumLinhas, NumColunas]);
      end
      else
      begin
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
