unit UPrincipalController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, System.Generics.Collections,
  UFuncoesGlobais,
  UPersistenciaLocalService,
  UTabelaDTO, UPlanilhaDTO, URelatorioDTO,
  UViewPrincipal,
  UPrincipalService;

type
  TPrincipalController = class
  private
    FView: TViewPrincipal;
    FService: TPrincipalService;
    procedure OnViewFormCreate(Sender: TObject);
    procedure OnViewListaPlanilhasClick(Sender: TObject);
  public
    constructor Create(AView: TViewPrincipal; AService: TPrincipalService);
    destructor Destroy; override;
    procedure PopularListaPlanilhasNaView;
    procedure PopularGradeTabelasNaView(const ANomePlanilha: string);
  end;
implementation

{ TPrincipalController }

constructor TPrincipalController.Create(AView: TViewPrincipal; AService: TPrincipalService);
begin
  inherited Create;
  FView := AView;
  FService := AService;

  // Conecta os eventos da View ao Controller
  if Assigned(FView) then
  begin
    FView.OnCreate := OnViewFormCreate;
    FView.OnListaPlanilhasClick := OnViewListaPlanilhasClick;
  end;
end;

destructor TPrincipalController.Destroy;
begin
  // Desconecta os eventos da View do Controller para evitar dangling pointers
  if Assigned(FView) then
  begin
    FView.OnCreate := nil;
    FView.OnListaPlanilhasClick := nil;
  end;
  inherited;
end;

procedure TPrincipalController.OnViewFormCreate(Sender: TObject);
begin
  // Lógica a ser executada quando a ViewPrincipal é criada
  if Sender = FView then
  begin
    PopularListaPlanilhasNaView;
    FView.BarraStatusPrincipal.SimpleText := 'Pronto - Nenhum arquivo carregado. Use "Carregar".';
  end;
end;

procedure TPrincipalController.OnViewListaPlanilhasClick(Sender: TObject);
var
  NomePlanilhaSelecionada: string;
begin
  // Lógica a ser executada quando um item da ListaPlanilhas é clicado
  if (Sender = FView) and (FView.ListaPlanilhas.ItemIndex >= 0) then
  begin
    NomePlanilhaSelecionada := FView.ListaPlanilhas.Items[FView.ListaPlanilhas.ItemIndex];
    PopularGradeTabelasNaView(NomePlanilhaSelecionada);
  end
  else
  begin
    // Limpa a grade se nenhuma planilha estiver selecionada
     FView.ClientDataSetTabelas.Close;
     FView.ClientDataSetTabelas.EmptyDataSet;
     FView.ClientDataSetTabelas.Open;
  end;
end;

procedure TPrincipalController.PopularListaPlanilhasNaView;
var
  ListaNomesPlanilhas: TStringList;
  i: Integer;
begin
  if not Assigned(FView) or not Assigned(FService) then
    Exit;

  FView.ListaPlanilhas.Items.Clear;

  // Chama o Service para obter a lista de nomes de planilhas
  ListaNomesPlanilhas := FService.ObterListaPlanilhas;
  try
    if Assigned(ListaNomesPlanilhas) and (ListaNomesPlanilhas.Count > 0) then
    begin
      for i := 0 to ListaNomesPlanilhas.Count - 1 do
      begin
        FView.ListaPlanilhas.Items.Add(ListaNomesPlanilhas[i]);
      end;
    end
    else
    begin
      FView.ListaPlanilhas.Items.Add('(Nenhuma planilha encontrada)');
    end;
  finally
    ListaNomesPlanilhas.Free;
  end;
end;

procedure TPrincipalController.PopularGradeTabelasNaView(const ANomePlanilha: string);
var
  // Assume que TPrincipalService retorna uma lista de DTOs ou records com as infos
  ListaInfoTabelas: TObjectList<TInfoTabelaPlanilhaDTO>;
  InfoTabela: TInfoTabelaPlanilhaDTO;
  i: Integer;
begin
  if not Assigned(FView) or not Assigned(FService) then
    Exit;

  FView.ClientDataSetTabelas.Close;
  FView.ClientDataSetTabelas.EmptyDataSet;
  FView.ClientDataSetTabelas.Open;

  ListaInfoTabelas := FService.ObterInfoTabelasDaPlanilha(ANomePlanilha);
  try
    if Assigned(ListaInfoTabelas) and (ListaInfoTabelas.Count > 0) then
    begin
      for i := 0 to ListaInfoTabelas.Count - 1 do
      begin
        InfoTabela := ListaInfoTabelas[i];
        FView.ClientDataSetTabelas.Append;
        // Preenche os campos do ClientDataSet com os dados do DTO
        FView.ClientDataSetTabelas.FieldByName('Nome').AsString := InfoTabela.Nome;
        FView.ClientDataSetTabelas.FieldByName('Vazio').AsString := ''; // Coluna vazia
        // Formata a string conforme solicitado no PDF
        FView.ClientDataSetTabelas.FieldByName('Dimensoes').AsString :=
          Format('"%s","%s","%s"', [InfoTabela.Nome, InfoTabela.Dimensoes, InfoTabela.TamanhoMB]);
        FView.ClientDataSetTabelas.Post;
      end;
    end
    else
    begin
      // Nenhuma tabela encontrada
      FView.ClientDataSetTabelas.Append;
      FView.ClientDataSetTabelas.FieldByName('Nome').AsString := '(Nenhuma tabela encontrada)';
      FView.ClientDataSetTabelas.FieldByName('Vazio').AsString := '';
      FView.ClientDataSetTabelas.FieldByName('Dimensoes').AsString := '';
      FView.ClientDataSetTabelas.Post;
    end;
  finally
    ListaInfoTabelas.Free;
  end;
end;

end.
