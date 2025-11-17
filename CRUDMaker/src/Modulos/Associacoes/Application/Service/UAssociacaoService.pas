unit UAssociacaoService;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  UXMLService, UPersistenciaLocalService;

type
  TAssociacaoService = class
  private
    FXMLService: TXMLService;
    FPersistencia: TPersistenciaLocalService;
    function ObterCaminhoArquivoAssociacao(const ANomePlanilha, ANomeAssociacao: string): string;
    function ObterCaminhoArquivoAssociacaoBackup(const ANomePlanilha, ANomeAssociacao: string): string;
    function ParseAssociacaoXML(const AXMLContent: string): string; // Retorna string de configuração
    function GerarXMLAssociacao(const AConfiguracaoString: string): string; // Gera XML a partir da string
  public
    constructor Create;
    destructor Destroy; override;

    function CriarAssociacao(const ANomePlanilha, ANomeAssociacao: string; const AConfiguracaoString: string): Boolean;
    function EditarAssociacao(const ANomePlanilha, ANomeAssociacao: string; const ANovaConfiguracaoString: string): Boolean;
    function ExcluirAssociacao(const ANomePlanilha, ANomeAssociacao: string): Boolean;
    function CarregarAssociacao(const ANomePlanilha, ANomeAssociacao: string): string; // Retorna string de configuração
  end;

implementation

uses
  System.IOUtils;

{ TAssociacaoService }

constructor TAssociacaoService.Create;
begin
  FXMLService := TXMLService.Create;
  FPersistencia := TPersistenciaLocalService.Create;
end;

destructor TAssociacaoService.Destroy;
begin
  FPersistencia.Free;
  FXMLService.Free;
  inherited;
end;

function TAssociacaoService.ObterCaminhoArquivoAssociacao(const ANomePlanilha, ANomeAssociacao: string): string;
begin
  Result := FPersistencia.CaminhodeAssociacao(ANomePlanilha, ANomeAssociacao, False);
end;

function TAssociacaoService.ObterCaminhoArquivoAssociacaoBackup(const ANomePlanilha, ANomeAssociacao: string): string;
begin
  Result := FPersistencia.CaminhodeAssociacao(ANomePlanilha, ANomeAssociacao, True);
end;

// Função para converter XML em string de configuração
// Exemplo de XML esperado:
// <Associacao>
//   <Nome>NomeDaAssociacao</Nome>
//   <Itens>
//     <Item>
//       <TabelaNome>Tabela1</TabelaNome>
//       <RelatorioNome>Relatorio1</RelatorioNome>
//       <PosicaoResultadoLinhas>1-5</PosicaoResultadoLinhas>
//       <PosicaoResultadoColunas>2</PosicaoResultadoColunas>
//       <TipoCabecalho>Padrão</TipoCabecalho>
//     </Item>
//   </Itens>
//   <CaminhoPDFSaida>C:\...</CaminhoPDFSaida>
// </Associacao>
// Esta função deve extrair os dados relevantes e criar uma string de configuração.
// Por simplicidade, assumiremos um formato de string de configuração fixo baseado nos itens.
// Ex: "Tabela1,Relatorio1,1-5,2,Padrão|Tabela2,Relatorio2,6-10,3,Customizado"
function TAssociacaoService.ParseAssociacaoXML(const AXMLContent: string): string;
var
  LSL: TStringList;
  LLine, LTag, LValue: string;
  LItemParts: TArray<string>;
  LInItens, LInItem: Boolean;
  LCurrentItem: string;
  I: Integer;
  LResultList: TList<string>;
begin
  Result := '';
  LSL := TStringList.Create;
  LResultList := TList<string>.Create;
  try
    LSL.Text := AXMLContent;
    LInItens := False;
    LInItem := False;
    LCurrentItem := '';

    for I := 0 to LSL.Count - 1 do
    begin
      LLine := Trim(LSL[I]);

      if LLine = '<Itens>' then
      begin
        LInItens := True;
        Continue;
      end;
      if LLine = '</Itens>' then
      begin
        LInItens := False;
        Continue;
      end;

      if LInItens then
      begin
        if LLine.StartsWith('<Item>') then
        begin
          LInItem := True;
          LCurrentItem := '';
          Continue;
        end;

        if LLine.EndsWith('</Item>') and LInItem then
        begin
          LInItem := False;
          if LCurrentItem <> '' then
            LResultList.Add(LCurrentItem);
          Continue;
        end;

        if LInItem then
        begin
          if LLine.StartsWith('<TabelaNome>') and LLine.EndsWith('</TabelaNome>') then
          begin
            LTag := '<TabelaNome>';
            LValue := LLine.Substring(Length(LTag), LLine.Length - Length(LTag) - Length('</TabelaNome>'));
            LCurrentItem := LValue + ',';
          end
          else if LLine.StartsWith('<RelatorioNome>') and LLine.EndsWith('</RelatorioNome>') then
          begin
            LTag := '<RelatorioNome>';
            LValue := LLine.Substring(Length(LTag), LLine.Length - Length(LTag) - Length('</RelatorioNome>'));
            LCurrentItem := LCurrentItem + LValue + ',';
          end
          else if LLine.StartsWith('<PosicaoResultadoLinhas>') and LLine.EndsWith('</PosicaoResultadoLinhas>') then
          begin
            LTag := '<PosicaoResultadoLinhas>';
            LValue := LLine.Substring(Length(LTag), LLine.Length - Length(LTag) - Length('</PosicaoResultadoLinhas>'));
            LCurrentItem := LCurrentItem + LValue + ',';
          end
          else if LLine.StartsWith('<PosicaoResultadoColunas>') and LLine.EndsWith('</PosicaoResultadoColunas>') then
          begin
            LTag := '<PosicaoResultadoColunas>';
            LValue := LLine.Substring(Length(LTag), LLine.Length - Length(LTag) - Length('</PosicaoResultadoColunas>'));
            LCurrentItem := LCurrentItem + LValue + ',';
          end
          else if LLine.StartsWith('<TipoCabecalho>') and LLine.EndsWith('</TipoCabecalho>') then
          begin
            LTag := '<TipoCabecalho>';
            LValue := LLine.Substring(Length(LTag), LLine.Length - Length(LTag) - Length('</TipoCabecalho>'));
            LCurrentItem := LCurrentItem + LValue; // Último campo, sem vírgula
          end;
        end;
      end;
    end;

    Result := string.Join('|', LResultList.ToArray);

  finally
    LResultList.Free;
    LSL.Free;
  end;
end;

// Função para converter string de configuração em XML
// Exemplo de string: "Tabela1,Relatorio1,1-5,2,Padrão|Tabela2,Relatorio2,6-10,3,Customizado"
function TAssociacaoService.GerarXMLAssociacao(const AConfiguracaoString: string): string;
var
  LItems: TArray<string>;
  LItemParts: TArray<string>;
  I, J: Integer;
  LXML: TStringList;
begin
  LXML := TStringList.Create;
  try
    LXML.Add('<?xml version="1.0" encoding="utf-8"?>');
    LXML.Add('<Associacao>');
    LXML.Add(Format('  <Nome>%s</Nome>', ['AssociacaoDinamica'])); // Nome genérico ou pode ser passado como parâmetro
    LXML.Add('  <Itens>');

    LItems := AConfiguracaoString.Split(['|']);
    for I := 0 to High(LItems) do
    begin
      LItemParts := LItems[I].Split([',']);
      if Length(LItemParts) >= 5 then // Verifica se tem os 5 campos esperados
      begin
        LXML.Add('    <Item>');
        LXML.Add(Format('      <TabelaNome>%s</TabelaNome>', [LItemParts[0]]));
        LXML.Add(Format('      <RelatorioNome>%s</RelatorioNome>', [LItemParts[1]]));
        LXML.Add(Format('      <PosicaoResultadoLinhas>%s</PosicaoResultadoLinhas>', [LItemParts[2]]));
        LXML.Add(Format('      <PosicaoResultadoColunas>%s</PosicaoResultadoColunas>', [LItemParts[3]]));
        LXML.Add(Format('      <TipoCabecalho>%s</TipoCabecalho>', [LItemParts[4]]));
        LXML.Add('    </Item>');
      end;
    end;

    LXML.Add('  </Itens>');
    LXML.Add(Format('  <CaminhoPDFSaida>%s</CaminhoPDFSaida>', [TPath.GetDocumentsPath])); // Caminho padrão ou pode ser passado
    LXML.Add('</Associacao>');
    Result := LXML.Text;
  finally
    LXML.Free;
  end;
end;

function TAssociacaoService.CriarAssociacao(const ANomePlanilha, ANomeAssociacao: string; const AConfiguracaoString: string): Boolean;
var
  LCaminho, LCaminhoBackup: string;
  LXMLContent: string;
begin
  Result := False;
  LCaminho := ObterCaminhoArquivoAssociacao(ANomePlanilha, ANomeAssociacao);

  // Verificar se já existe
  if TFile.Exists(LCaminho) then Exit;

  LXMLContent := GerarXMLAssociacao(AConfiguracaoString);

  // Garantir que o diretório existe
  TDirectory.CreateDirectory(TPath.GetDirectoryName(LCaminho));

  try
    TFile.WriteAllText(LCaminho, LXMLContent, TEncoding.UTF8);
    Result := True;
  except
    on E: Exception do
    begin
      Result := False;
    end;
  end;
end;

function TAssociacaoService.EditarAssociacao(const ANomePlanilha, ANomeAssociacao: string; const ANovaConfiguracaoString: string): Boolean;
var
  LCaminho, LCaminhoBackup: string;
  LXMLContent: string;
begin
  Result := False;
  LCaminho := ObterCaminhoArquivoAssociacao(ANomePlanilha, ANomeAssociacao);

  // Fazer backup do arquivo atual
  if TFile.Exists(LCaminho) then
  begin
    LCaminhoBackup := ObterCaminhoArquivoAssociacaoBackup(ANomePlanilha, ANomeAssociacao);
    TFile.Copy(LCaminho, LCaminhoBackup, True);
  end;

  LXMLContent := GerarXMLAssociacao(ANovaConfiguracaoString);

  try
    TFile.WriteAllText(LCaminho, LXMLContent, TEncoding.UTF8);
    Result := True;
  except
    on E: Exception do
    begin
      // Restaurar backup se falhar
      if TFile.Exists(LCaminhoBackup) then
        TFile.Copy(LCaminhoBackup, LCaminho, True);
      Result := False;
    end;
  end;
end;

function TAssociacaoService.ExcluirAssociacao(const ANomePlanilha, ANomeAssociacao: string): Boolean;
var
  LCaminho: string;
begin
  Result := False;
  LCaminho := ObterCaminhoArquivoAssociacao(ANomePlanilha, ANomeAssociacao);

  if TFile.Exists(LCaminho) then
  begin
    try
      TFile.Delete(LCaminho);
      Result := True;
    except
      Result := False;
    end;
  end;
end;

function TAssociacaoService.CarregarAssociacao(const ANomePlanilha, ANomeAssociacao: string): string;
var
  LCaminho: string;
  LXMLContent: string;
begin
  Result := '';
  LCaminho := ObterCaminhoArquivoAssociacao(ANomePlanilha, ANomeAssociacao);

  if not TFile.Exists(LCaminho) then Exit;

  LXMLContent := TFile.ReadAllText(LCaminho, TEncoding.UTF8);
  Result := ParseAssociacaoXML(LXMLContent); // Converte XML para string de configuração
end;

end.
