unit UViewEditorPlanilha;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB, Datasnap.DBClient, Vcl.DBGrids Vcl.DB, Data.DB, Data.FMTBcd, Data.DBClient, // <-- Bibliotecas adicionadas para TClientDataSet
  UPlanilhaDTO;

type
  TSolicitarSalvarPlanilhaEvent = procedure(const APlanilha: TPlanilhaDTO) of object;
  TSolicitarCancelarEdicaoEvent = procedure of object;

  TViewEditorPlanilha = class(TForm)
    PainelEditorTopo: TPanel;
    RotuloTituloPlanilha: TLabel;
    EditarTituloPlanilha: TEdit;
    BotaoSalvarPlanilha: TButton;
    BotaoCancelarPlanilha: TButton;
    DBGridEditor: TDBGrid; // <-- Substitui TStringGrid
    PainelEditorRodape: TPanel;
    BarraStatusEditor: TStatusBar;
    ClientDataSetEditor: TClientDataSet; // <-- Novo componente
    DataSourceEditor: TDataSource; // <-- Novo componente
    procedure BotaoSalvarPlanilhaClick(Sender: TObject);
    procedure BotaoCancelarPlanilhaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FPlanilha: TPlanilhaDTO;
    FSendoEditada: Boolean;
    FOnSolicitarSalvar: TSolicitarSalvarPlanilhaEvent;
    FOnSolicitarCancelar: TSolicitarCancelarEdicaoEvent;

    procedure CarregarPlanilhaNaInterface;
    procedure AtualizarPlanilhaDoInterface;
    procedure ConfigurarClientDataSet; // <-- Método para configurar colunas
    procedure SalvarClientDataSetParaArquivo; // <-- Método para salvar
    procedure CarregarClientDataSetDeArquivo; // <-- Método para carregar
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; APlanilha: TPlanilhaDTO); reintroduce; overload;
    destructor Destroy; override;
    property OnSolicitarSalvar: TSolicitarSalvarPlanilhaEvent read FOnSolicitarSalvar write FOnSolicitarSalvar;
    property OnSolicitarCancelar: TSolicitarCancelarEdicaoEvent read FOnSolicitarCancelar write FOnSolicitarCancelar;
  end;

var
  ViewEditorPlanilha: TViewEditorPlanilha;

implementation

{$R *.dfm}

{ TViewEditorPlanilha }

constructor TViewEditorPlanilha.Create(AOwner: TComponent);
begin
  Create(AOwner, nil);
end;

constructor TViewEditorPlanilha.Create(AOwner: TComponent; APlanilha: TPlanilhaDTO);
begin
  inherited Create(AOwner);
  FPlanilha := APlanilha;
  FSendoEditada := Assigned(APlanilha);
end;

destructor TViewEditorPlanilha.Destroy;
begin
  if not FSendoEditada and Assigned(FPlanilha) then
    FPlanilha.Free;
  inherited;
end;

procedure TViewEditorPlanilha.FormCreate(Sender: TObject);
begin
  // Configura o TClientDataSet com 200 colunas
  ConfigurarClientDataSet;

  if Assigned(FPlanilha) then
  begin
    CarregarPlanilhaNaInterface;
  end;
end;

procedure TViewEditorPlanilha.ConfigurarClientDataSet;
var
  i: Integer;
  FieldDef: TFieldDef;
begin
  // Desativa o dataset para modificar sua estrutura
  ClientDataSetEditor.Close;

  // Limpa as definições de campo existentes
  ClientDataSetEditor.FieldDefs.Clear;

  // Cria 200 campos (colunas)
  for i := 1 to 200 do
  begin
    FieldDef := ClientDataSetEditor.FieldDefs.AddFieldDef;
    FieldDef.Name := 'Coluna' + IntToStr(i);
    FieldDef.DataType := ftString;
    FieldDef.Size := 300; // Limite de 300 caracteres por campo
  end;

  // Cria os campos no dataset
  ClientDataSetEditor.CreateDataSet;

  // Define o número de linhas (registros) para 2000
  // OBS: O TClientDataSet não pré-aloca linhas. Ele cresce dinamicamente.
  // Para garantir 2000 linhas, você pode pré-inseri-las ou deixar o usuário inserir conforme necessário.
  // Aqui, vamos deixar o usuário inserir conforme necessário, mas podemos garantir pelo menos 1 linha.
  ClientDataSetEditor.Open;
  if ClientDataSetEditor.IsEmpty then
    ClientDataSetEditor.InsertRecord([nil]); // Insere uma linha vazia

  // Opcional: Ajusta a largura das colunas no DBGrid
  for i := 0 to DBGridEditor.Columns.Count - 1 do
  begin
    DBGridEditor.Columns[i].Width := 20; // 20 pixels de largura
  end;
end;

procedure TViewEditorPlanilha.CarregarPlanilhaNaInterface;
begin
  if Assigned(FPlanilha) then
  begin
    EditarTituloPlanilha.Text := FPlanilha.Titulo;
    // Aqui você carregaria os dados do DTO para o TClientDataSet.
    // Como o DTO atual (TPlanilhaDTO) não tem uma estrutura de dados tabular definida,
    // você precisará implementar essa lógica conforme a estrutura do seu DTO.
    // Por exemplo:
    // ClientDataSetEditor.LoadFromFile(FPlanilha.CaminhoArquivoXML);
  end;
end;

procedure TViewEditorPlanilha.AtualizarPlanilhaDoInterface;
begin
  if not Assigned(FPlanilha) then
    FPlanilha := TPlanilhaDTO.Create;
  FPlanilha.Titulo := EditarTituloPlanilha.Text;
  // Aqui você salvaria os dados do TClientDataSet para o DTO.
  // Por exemplo, você poderia definir uma propriedade no DTO:
  // FPlanilha.CaminhoArquivoXML := 'ultimo_caminho_salvo.xml';
end;

procedure TViewEditorPlanilha.SalvarClientDataSetParaArquivo;
var
  SaveDialog: TSaveDialog;
  FilePath: string;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
    SaveDialog.DefaultExt := 'xml';
    SaveDialog.FileName := EditarTituloPlanilha.Text + '.xml';

    if SaveDialog.Execute then
    begin
      FilePath := SaveDialog.FileName;
      // Salva o TClientDataSet como XML
      ClientDataSetEditor.SaveToFile(FilePath, dfXMLUTF8);
      // Atualiza o DTO com o caminho do arquivo salvo
      AtualizarPlanilhaDoInterface;
      FPlanilha.CaminhoArquivoXML := FilePath; // <-- Assumindo que TPlanilhaDTO tem essa propriedade
      ShowMessage('Planilha salva com sucesso em: ' + FilePath);
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TViewEditorPlanilha.CarregarClientDataSetDeArquivo;
var
  OpenDialog: TOpenDialog;
  FilePath: string;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
    OpenDialog.DefaultExt := 'xml';

    if OpenDialog.Execute then
    begin
      FilePath := OpenDialog.FileName;
      // Carrega o XML para o TClientDataSet
      ClientDataSetEditor.Close;
      ClientDataSetEditor.LoadFromFile(FilePath);
      ClientDataSetEditor.Open;

      // Atualiza o título da planilha com o nome do arquivo (sem extensão)
      EditarTituloPlanilha.Text := ChangeFileExt(ExtractFileName(FilePath), '');

      // Atualiza o DTO
      AtualizarPlanilhaDoInterface;
      FPlanilha.CaminhoArquivoXML := FilePath; // <-- Assumindo que TPlanilhaDTO tem essa propriedade
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TViewEditorPlanilha.BotaoSalvarPlanilhaClick(Sender: TObject);
begin
  // Primeiro, salva o TClientDataSet em um arquivo XML
  SalvarClientDataSetParaArquivo;

  // Depois, notifica o controller para que ele possa fazer outras operações
  // (como mover o arquivo para o diretório final, se necessário)
  if Assigned(FOnSolicitarSalvar) then
    FOnSolicitarSalvar(FPlanilha);
end;

procedure TViewEditorPlanilha.BotaoCancelarPlanilhaClick(Sender: TObject);
begin
  if Assigned(FOnSolicitarCancelar) then
    FOnSolicitarCancelar;
  Self.Close;
end;

end.