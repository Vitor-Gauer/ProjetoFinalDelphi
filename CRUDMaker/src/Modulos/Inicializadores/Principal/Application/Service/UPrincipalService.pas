unit UPrincipalService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Forms,
  System.IOUtils,
  Xml.XMLDoc, Xml.XMLIntf;

type
  TInfoTabelaPlanilhaDTO = class
  public
    Nome: string;
    Dimensoes: string; // Ex: "100x200" ou mensagem de erro
    TamanhoMB: string; // Ex: "2.50 MB"
    constructor Create(const ANome, ADimensoes, ATamanhoMB: string);
  end;

  TPrincipalService = class
  public
    function ObterListaPlanilhas: TStringList;
    function ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
  end;

implementation

{ TInfoTabelaPlanilhaDTO }

constructor TInfoTabelaPlanilhaDTO.Create(const ANome, ADimensoes, ATamanhoMB: string);
begin
  inherited Create;
  Nome := ANome;
  Dimensoes := ADimensoes;
  TamanhoMB := ATamanhoMB;
end;

{ TPrincipalService }

function TPrincipalService.ObterListaPlanilhas: TStringList;
var
  DiretorioPlanilhas: string;
  Diretorios: TArray<string>;
  i: Integer;
  NomePasta: string;
begin
  Result := TStringList.Create;
  try
    DiretorioPlanilhas := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + 'Planilhas';

    if TDirectory.Exists(DiretorioPlanilhas) then
    begin
      Diretorios := TDirectory.GetDirectories(DiretorioPlanilhas);
      for i := Low(Diretorios) to High(Diretorios) do
      begin
        NomePasta := ExtractFileName(Diretorios[i]);
        if NomePasta <> '' then
          Result.Add(NomePasta);
      end;
    end;
  except
    on E: Exception do
    begin
      Result.Clear;
      Result.Add('Erro ao listar planilhas: ' + E.Message);
    end;
  end;
end;

function TPrincipalService.ObterInfoTabelasDaPlanilha(const ANomePlanilha: string): TObjectList<TInfoTabelaPlanilhaDTO>;
var
  DiretorioPlanilha, DiretorioTabelas: string;
  SubDirs: TArray<string>;
  i: Integer;
  NomeTabela: string;
  CaminhoPastaTabela: string;
  ArquivosXML: TArray<string>;
  CaminhoXML: string;
  TamanhoBytes: Int64;
  TamanhoMB: string;
  Dimensoes: string;
  InfoTabela: TInfoTabelaPlanilhaDTO;
  XMLDoc: IXMLDocument;
  TabelaNode, LinhaNode, ColunasNode: IXMLNode;
  NodeListAux, LinhasNodeList, CelulasNodeList: IXMLNodeList;
  NumLinhas, NumColunas, MaxColunasEncontradas, j: Integer;
begin
  Result := TObjectList<TInfoTabelaPlanilhaDTO>.Create(True); // OwnsObjects = True
  try
    if ANomePlanilha = '' then
      Exit;

    DiretorioPlanilha := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) +
                         'Planilhas' + PathDelim + ANomePlanilha;
    DiretorioTabelas := IncludeTrailingPathDelimiter(DiretorioPlanilha) + 'Tabelas';

    if not TDirectory.Exists(DiretorioTabelas) then
      Exit;

    SubDirs := TDirectory.GetDirectories(DiretorioTabelas);

    for i := Low(SubDirs) to High(SubDirs) do
    begin
      NomeTabela := ExtractFileName(SubDirs[i]);
      CaminhoPastaTabela := SubDirs[i];

      // Assume que o XML tem o nome base da tabela
      // CaminhoXML := IncludeTrailingPathDelimiter(CaminhoPastaTabela) + NomeTabela + '*.xml'; // Padrão de nome base
      ArquivosXML := TDirectory.GetFiles(CaminhoPastaTabela, '*.xml');

      Dimensoes := 'Desconhecido';
      TamanhoMB := '0 MB';
      CaminhoXML := '';

      if Length(ArquivosXML) > 0 then
      begin
        CaminhoXML := ArquivosXML[0]; // Usa o primeiro arquivo .xml encontrado
        try
          XMLDoc := TXMLDocument.Create(nil);
          XMLDoc.LoadFromFile(CaminhoXML);
          XMLDoc.Active := True;

          // Navega até o nó <Tabela>
          TabelaNode := XMLDoc.DocumentElement; // <Corpo>
          if Assigned(TabelaNode) then
            TabelaNode := TabelaNode.ChildNodes.FindNode('Redor'); // <Redor> nivel 1
          if Assigned(TabelaNode) then
            TabelaNode := TabelaNode.ChildNodes.FindNode('Redor'); // <Redor> nivel 2
          if Assigned(TabelaNode) then
            TabelaNode := TabelaNode.ChildNodes.FindNode('Tabela');

          if not Assigned(TabelaNode) then
          begin
            Dimensoes := 'Estrutura XML inválida (<Tabela> não encontrada)';
          end
          else
          begin
            // Obter a lista de filhos de <Tabela> (que são <Linha>)
            LinhasNodeList := TabelaNode.ChildNodes;
            if not Assigned(LinhasNodeList) or (LinhasNodeList.Count = 0) then
            begin
              Dimensoes := '0x0 (sem linhas)';
            end
            else
            begin
              NumLinhas := LinhasNodeList.Count;
              MaxColunasEncontradas := 0;

              // Itera pelas linhas para encontrar o máximo de colunas
              for j := 0 to LinhasNodeList.Count - 1 do
              begin
                // Acessa o nó <Linha> individual
                LinhaNode := LinhasNodeList[j];
                if (LinhaNode.NodeName = 'Linha') then
                begin
                  // Encontra o nó <Colunas> dentro da <Linha>
                  ColunasNode := LinhaNode.ChildNodes.FindNode('Colunas');
                  if Assigned(ColunasNode) then
                  begin
                    // Obtém a lista de <Celula> dentro de <Colunas>
                    CelulasNodeList := ColunasNode.ChildNodes;
                    if Assigned(CelulasNodeList) then
                    begin
                      NumColunas := CelulasNodeList.Count;
                      if NumColunas > MaxColunasEncontradas then
                        MaxColunasEncontradas := NumColunas;
                    end;
                  end;
                end;
              end;
              Dimensoes := Format('%dx%d', [NumLinhas, MaxColunasEncontradas]);
            end;
          end;

          // --- Obter Tamanho do Arquivo ---
          if TFile.Exists(CaminhoXML) then // <<< If movido
          begin
            TamanhoBytes := TFile.GetSize(CaminhoXML);
            TamanhoMB := FormatFloat('0.00 MB', TamanhoBytes / (1024 * 1024));
          end;

        except
          on E: Exception do
          begin
            TamanhoMB := 'Erro';
            Dimensoes := 'Erro ao ler XML: ' + E.ClassName;
            // Opcional: Logar E.Message
          end;
        end;
      end;

      InfoTabela := TInfoTabelaPlanilhaDTO.Create(NomeTabela, Dimensoes, TamanhoMB);
      Result.Add(InfoTabela);
    end;
    // --- FIM DA LÓGICA MOVIDA ---
  except
    on E: Exception do
    begin
      // Em caso de erro grave, adiciona um item indicando o erro
      InfoTabela := TInfoTabelaPlanilhaDTO.Create('Erro', 'Erro ao processar planilha', '0 MB');
      Result.Add(InfoTabela);
      // Opcional: Logar E.Message
    end;
  end;
end;

end.
