unit UViewEditorTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient, UTabelaDTO, UEditorTabelaController, Math;

type
  TEventoSolicitarSalvarTabela = procedure(const ATabela: TTabelaDTO) of object;
  TEventoSolicitarCancelarEdicao = procedure of object;

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
    procedure AoClicarBotaoSalvar(Sender: TObject);
    procedure AoClicarBotaoCancelar(Sender: TObject);
    procedure AoCriarFormulario(Sender: TObject);
    procedure DBGridEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DBGridEditorExit(Sender: TObject);
  private
    FTabela: TTabelaDTO;
    FSendoEditada: Boolean;
    FController: TEditorTabelaController;
    FEventoSalvar: TEventoSolicitarSalvarTabela;
    FEventoCancelar: TEventoSolicitarCancelarEdicao;
    procedure AtualizarTabelaDoInterface;
    procedure ConfigurarClientDataSet;
    procedure CarregarClientDataSetDeArquivo;
    procedure ExecutarSalvarComConfirmacao;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ATabela: TTabelaDTO); reintroduce; overload;
    destructor Destroy; override;
    property EventoSalvar: TEventoSolicitarSalvarTabela read FEventoSalvar write FEventoSalvar;
    property EventoCancelar: TEventoSolicitarCancelarEdicao read FEventoCancelar write FEventoCancelar;
  end;
  TSalvarConfirmacaoDialog = class(TForm)
  private
    FTimer: TTimer;
    FSecondsLeft: Integer;
    FLabel: TLabel;
    FYesButton: TButton;
    FNoButton: TButton;
    procedure TimerTimer(Sender: TObject);
    procedure SalvarVerdadeiroClick(Sender: TObject);
    procedure SalvarFalsoClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const ATituloTabela: string); reintroduce;
    function Execute: Boolean;
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

procedure TViewEditorTabela.AoCriarFormulario(Sender: TObject);
begin
  // Configura o TClientDataSet com 200 colunas e 2000 linhas
  ConfigurarClientDataSet;
  if Assigned(FTabela) and (FTabela.CaminhoArquivoXML <> '') then
  begin
    // O DTO tem um caminho, então carregue os dados
    CarregarClientDataSetDeArquivo;
  end
  else
  begin
    // É uma nova tabela, apenas carrega o título se existir
    if Assigned(FTabela) then
      EditarTituloTabela.Text := FTabela.Titulo;
  end;
  // Configurações iniciais para StatusBar
  BarraStatusEditor.SimpleText := 'Pronto';
end;

procedure TViewEditorTabela.ConfigurarClientDataSet;
var
  i, j: Integer;
  FieldDef: TFieldDef;
begin
  ClientDataSetEditor.Close;
  ClientDataSetEditor.FieldDefs.Clear; // Limpa definições anteriores

  // Cria 200 campos (colunas)
  for i := 1 to 200 do
  begin
    FieldDef := ClientDataSetEditor.FieldDefs.AddFieldDef; // Adiciona nova definição de campo
    FieldDef.Name := 'Coluna' + IntToStr(i); // Nome do campo
    FieldDef.DataType := ftString; // Tipo de dado string
    FieldDef.Size := 300; // Limite de 300 caracteres por campo
  end;

  ClientDataSetEditor.CreateDataSet;
  ClientDataSetEditor.Open;

  // Insere 2000 registros (linhas)
  ClientDataSetEditor.DisableControls; // Otimiza inserção porque não atualiza a UI a cada inserção
  try
    for i := 1 to 2000 do // i controla o número do registro (linha)
    begin
      ClientDataSetEditor.Append; // Inicia um novo registro
      for j := 1 to 200 do // j controla o número da coluna dentro do registro
      begin
        ClientDataSetEditor.FieldByName('Coluna' + IntToStr(j)).AsString := ''; // Inicializa com string vazia
        // Para ser modificado para valores padrão deve ser feito a seguinte verificação antes disso:
        // if Assigned(FTabela) and (Length(FTabela.ValoresPadrao) >= j) then
        //   ClientDataSetEditor.FieldByName('Coluna' + IntToStr(j)).AsString := FTabela.ValoresPadrao[j - 1];
        // Caso contrário, todos os campos começam vazios
        // não implementado pois ainda nao tem a funcionalidade de preencher o DTO
      end;
      ClientDataSetEditor.Post; // Salva o registro
    end;
  finally
    ClientDataSetEditor.EnableControls; // Reabilita atualizações da UI
  end;

  // Posiciona no primeiro registro
  if not ClientDataSetEditor.IsEmpty then
    ClientDataSetEditor.First;

  // Ajusta a largura das colunas no DBGrid
  // Mas nao ajusta o limite de caracteres do campo, que permanece 300
  // O min é para evitar erro caso tenha menos de 20 colunas
  for i := 0 to Min(DBGridEditor.Columns.Count - 1, 19) do // Ajusta só as primeiras 20, por performance
  begin
    DBGridEditor.Columns[i].Width := 60; // Largura fixa de 60 pixels, suficiente para 20 caracteres
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
      FTabela.CaminhoArquivoXML := FilePath;
    end;
  finally
    OpenDialog.Free;
  end;
end;


procedure TViewEditorTabela.ExecutarSalvarComConfirmacao;
var
  TituloTabela: string;
  ConfirmForm: TSalvarConfirmacaoDialog;
  Resposta: Boolean;
begin
  AtualizarTabelaDoInterface();

  if Assigned(FTabela) and (FTabela.Titulo <> '') then
    TituloTabela := FTabela.Titulo
  else
    TituloTabela := 'Sem Título';

  ConfirmForm := TSalvarConfirmacaoDialog.Create(Self, TituloTabela);
  try
    Resposta := ConfirmForm.Execute;
    if Resposta then
    begin
       if Assigned(FController) then
       begin
         try
           // Chama o controller, que agora gerencia todo o fluxo
           FController.ExecutarSalvarTabela(FTabela, ClientDataSetEditor);
         except
           on E: Exception do
           begin
             ShowMessage('Erro ao iniciar o salvamento: ' + E.Message);
           end;
         end;
       end else
       begin
         ShowMessage('Erro: Controller não disponível.');
       end;
    end;
  finally
    ConfirmForm.Free;
  end;
end;

procedure TViewEditorTabela.AoClicarBotaoSalvar(Sender: TObject);
begin
  ExecutarSalvarComConfirmacao;
end;

procedure TViewEditorTabela.AoClicarBotaoCancelar(Sender: TObject);
begin
  if Assigned(FEventoCancelar) then
    FEventoCancelar;
  Self.Close;
end;

procedure TViewEditorTabela.AtualizarTabelaDoInterface;
begin
  if not Assigned(FTabela) then // Cria o DTO se não existir
    FTabela := TTabelaDTO.Create;
  FTabela.Titulo := EditarTituloTabela.Text;
  // O caminho do arquivo XML é atualizado apenas ao carregar um arquivo
  // Campo de id que é um hash de 20 caracteres nao implementado
end;

procedure TViewEditorTabela.DBGridEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Coord: TGridCoord;
  ColIndex, RowIndex: Integer;
begin
  Coord := DBGridEditor.MouseCoord(X, Y); // Obtém a coordenada da célula sob o mouse
  ColIndex := Coord.X; // Coluna (0-based)
  RowIndex := Coord.Y; // Linha (0-based, 0 é o cabeçalho)

  if (ColIndex >= 0) and (ColIndex < DBGridEditor.Columns.Count) and // se estiver sobre uma coluna válida (ColIndex = 0 é a primeira coluna)
     (RowIndex >= 0) and (RowIndex <= ClientDataSetEditor.RecordCount) and // se estiver sobre uma linha válida (RowIndex = 0 é o cabeçalho, >0 são dados)
     (ClientDataSetEditor.Active) and not (ClientDataSetEditor.IsEmpty) then // e se o dataset estiver ativo e não vazio
  begin
    try
      // Verifica se está sobre o cabeçalho ou uma célula de dados
      if RowIndex = 0 then
      begin
         // Se estiver sobre o cabeçalho
         BarraStatusEditor.SimpleText := Format('Coluna: %s', [DBGridEditor.Columns[ColIndex].Title.Caption]); // %s vem do título da coluna
      end
      else if RowIndex > 0 then
      begin
         // Se estiver sobre uma célula de dados,
         // Atualiza a StatusBar com a linha e o título da coluna
         BarraStatusEditor.SimpleText := Format('Linha: %d, Coluna: %s', [RowIndex, DBGridEditor.Columns[ColIndex].Title.Caption]);
      end;
    except
      on E: Exception do
        BarraStatusEditor.SimpleText := 'Erro ao ler célula: ' + E.Message;
    end;
  end else // esse else é para quando não está sobre uma célula válida
  begin
    BarraStatusEditor.SimpleText := 'Pronto';
  end;
end;

procedure TViewEditorTabela.DBGridEditorExit(Sender: TObject);
begin
  BarraStatusEditor.SimpleText := 'Pronto';
end;

{ TSalvarConfirmacaoDialog }

constructor TSalvarConfirmacaoDialog.Create(AOwner: TComponent; const ATituloTabela: string);
begin
  inherited CreateNew(AOwner);
  Self.BorderStyle := bsDialog;
  Self.Caption := 'Confirmar Salvar';
  Self.Width := 400;
  Self.Height := 150;
  Self.Position := poMainFormCenter;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.AutoSize := False;
  FLabel.WordWrap := True;
  FLabel.Width := Self.ClientWidth - 20;
  FLabel.Left := 10;
  FLabel.Top := 10;
  FLabel.Caption := Format('Tem certeza que deseja salvar as alterações na tabela "%s"?', [ATituloTabela]);

  FYesButton := TButton.Create(Self);
  FYesButton.Parent := Self;
  FYesButton.Caption := 'Sim (5)';
  FYesButton.ModalResult := mrYes;
  FYesButton.Left := (Self.ClientWidth div 2) - FYesButton.Width - 10;
  FYesButton.Top := FLabel.Top + FLabel.Height + 20;
  FYesButton.Enabled := False; // Desabilita inicialmente
  FYesButton.OnClick := SalvarVerdadeiroClick;

  FNoButton := TButton.Create(Self);
  FNoButton.Parent := Self;
  FNoButton.Caption := 'Não';
  FNoButton.ModalResult := mrNo;
  FNoButton.Left := (Self.ClientWidth div 2) + 10;
  FNoButton.Top := FYesButton.Top;
  FNoButton.OnClick := SalvarFalsoClick;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 1000; // 1 segundo
  FTimer.Enabled := False;
  FTimer.OnTimer := TimerTimer;

  FSecondsLeft := 5;
end;

function TSalvarConfirmacaoDialog.Execute: Boolean;
begin
  FSecondsLeft := 5;
  FLabel.Caption := Format('Tem certeza que deseja salvar as alterações na tabela "%s"?', [Copy(FLabel.Caption, Pos('"', FLabel.Caption) + 1, Pos('"', Copy(FLabel.Caption, Pos('"', FLabel.Caption) + 1, MaxInt)) - 1)]);
  FYesButton.Caption := Format('Sim (%d)', [FSecondsLeft]);
  FYesButton.Enabled := False;
  FTimer.Enabled := True; // Inicia o timer quando o diálogo é mostrado
  Result := ShowModal = mrYes;
end;

procedure TSalvarConfirmacaoDialog.TimerTimer(Sender: TObject);
begin
  Dec(FSecondsLeft);
  FYesButton.Caption := Format('Sim (%d)', [FSecondsLeft]);
  if FSecondsLeft <= 0 then
  begin
    FTimer.Enabled := False;
    FYesButton.Enabled := True;
    FYesButton.Caption := 'Sim';
  end;
end;

procedure TSalvarConfirmacaoDialog.SalvarVerdadeiroClick(Sender: TObject);
begin
  FTimer.Enabled := False;
end;

procedure TSalvarConfirmacaoDialog.SalvarFalsoClick(Sender: TObject);
begin
  FTimer.Enabled := False;
end;

end.