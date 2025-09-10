unit UViewEditorTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient, UTabelaDTO, UEditorTabelaController;

type
  TSolicitarSalvarTabelaEvent = procedure(const ATabela: TTabelaDTO) of object;
  TSolicitarCancelarEdicaoEvent = procedure of object;

  TViewEditorTabela = class(TForm)
    PainelEditorTopo: TPanel;
    RotuloTituloTabela: TLabel;
    EditarTituloTabela: TEdit;
    BotaoSalvarTabela: TButton;
    BotaoCancelarTabela: TButton;
    DBGridEditor: TDBGrid;
    PainelEditorRodape: TPanel;
    BarraStatusEditor: TStatusBar;
    ClientDataSetEditor: TClientDataSet;
    DataSourceEditor: TDataSource;
    procedure BotaoSalvarTabelaClick(Sender: TObject);
    procedure BotaoCancelarTabelaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FTabela: TTabelaDTO;
    FSendoEditada: Boolean;
    FController: TEditorTabelaController;
    FOnSolicitarSalvar: TSolicitarSalvarTabelaEvent;
    FOnSolicitarCancelar: TSolicitarCancelarEdicaoEvent;

    procedure CarregarTabelaNaInterface;
    procedure AtualizarTabelaDoInterface;
    procedure ConfigurarClientDataSet;
    procedure SalvarClientDataSetParaArquivo;
    procedure CarregarClientDataSetDeArquivo;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ATabela: TTabelaDTO); reintroduce; overload;
    destructor Destroy; override;
    property OnSolicitarSalvar: TSolicitarSalvarTabelaEvent read FOnSolicitarSalvar write FOnSolicitarSalvar;
    property OnSolicitarCancelar: TSolicitarCancelarEdicaoEvent read FOnSolicitarCancelar write FOnSolicitarCancelar;
  end;

var
  ViewEditorTabela: TViewEditorTabela;

implementation

{$R *.dfm}

{ TViewEditorTabela }

constructor TViewEditorTabela.Create(AOwner: TComponent);
begin
  Create(AOwner, nil);
end;

constructor TViewEditorTabela.Create(AOwner: TComponent; ATabela: TTabelaDTO);
begin
  inherited Create(AOwner);
  FTabela := ATabela;
  FSendoEditada := Assigned(ATabela);
  FController := TEditorTabelaController.Create;
end;

destructor TViewEditorTabela.Destroy;
begin
  FController.Free;
  if not FSendoEditada and Assigned(FTabela) then
    FTabela.Free;
  inherited;
end;

procedure TViewEditorTabela.FormCreate(Sender: TObject);
begin
  // Configura o TClientDataSet com 200 colunas
  ConfigurarClientDataSet;

  if Assigned(FTabela) and (FTabela.CaminhoArquivoXML <> '') then
  begin
    // O DTO tem um caminho, então vamos carregar os dados
    CarregarClientDataSetDeArquivo;
  end
  else
  begin
    // É uma nova tabela, apenas carrega o título se existir
    if Assigned(FTabela) then
      EditarTituloTabela.Text := FTabela.Titulo;
  end;
end;

procedure TViewEditorTabela.ConfigurarClientDataSet;
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

procedure TViewEditorTabela.CarregarClientDataSetDeArquivo;
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
      EditarTituloTabela.Text := ChangeFileExt(ExtractFileName(FilePath), '');

      // Atualiza o DTO
      AtualizarTabelaDoInterface;
      FTabela.CaminhoArquivoXML := FilePath; // <-- Assumindo que TTabelaDTO tem essa propriedade
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TViewEditorTabela.SalvarClientDataSetParaArquivo;
var
  SaveDialog: TSaveDialog;
  FilePath: string;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
    SaveDialog.DefaultExt := 'xml';
    SaveDialog.FileName := EditarTituloTabela.Text + '.xml';

    if SaveDialog.Execute then
    begin
      FilePath := SaveDialog.FileName;
      // Salva o TClientDataSet como XML
      ClientDataSetEditor.SaveToFile(FilePath, dfXMLUTF8);
      // Atualiza o DTO com o caminho do arquivo salvo
      AtualizarTabelaDoInterface;
      FTabela.CaminhoArquivoXML := FilePath; // <-- Assumindo que TTabelaDTO tem essa propriedade
      ShowMessage('Tabela salva com sucesso em: ' + FilePath);
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TViewEditorTabela.AtualizarTabelaDoInterface;
begin
  if not Assigned(FTabela) then
    FTabela := TTabelaDTO.Create;
  FTabela.Titulo := EditarTituloTabela.Text;
  // Outros campos do DTO, se houver, seriam atualizados aqui
end;

procedure TViewEditorTabela.BotaoSalvarTabelaClick(Sender: TObject);
begin
  // Primeiro, salva o TClientDataSet em um arquivo XML
  SalvarClientDataSetParaArquivo;

  // Depois, notifica o controller para que ele possa fazer outras operações
  // (como mover o arquivo para o diretório final, se necessário)
  if Assigned(FOnSolicitarSalvar) then
    FOnSolicitarSalvar(FTabela);
end;

procedure TViewEditorTabela.BotaoCancelarTabelaClick(Sender: TObject);
begin
  if Assigned(FOnSolicitarCancelar) then
    FOnSolicitarCancelar;
  Self.Close;
end;

end.
