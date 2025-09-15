unit UViewEditorTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient, UTabelaDTO, UEditorTabelaController, Math;

type
  /// Tipo de evento para solicitar o salvamento de uma tabela.
  // <param name="ATabela"> DTO da tabela a ser salva.</param>
  TEventoSolicitarSalvarTabela = procedure(const ATabela: TTabelaDTO) of object;

  /// Tipo de evento para solicitar o cancelamento da edição.
  TEventoSolicitarCancelarEdicao = procedure of object;

  /// Formulário para editar uma tabela.
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
    /// Evento acionado ao clicar no botão Salvar.
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure AoClicarBotaoSalvar(Sender: TObject);

    /// Evento acionado ao clicar no botão Cancelar.
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure AoClicarBotaoCancelar(Sender: TObject);

    /// Evento acionado ao criar o formulário.
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure AoCriarFormulario(Sender: TObject);

    /// Evento acionado ao mover o mouse sobre o DBGrid.
    // <param name="Sender"> Objeto que disparou o evento.</param>
    // <param name="Shift"> Estado das teclas Shift.</param>
    // <param name="X"> Coordenada X do mouse.</param>
    // <param name="Y"> Coordenada Y do mouse.</param>
    procedure DBGridEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    /// Evento acionado ao sair do DBGrid.
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure DBGridEditorExit(Sender: TObject);
  private
    FTabela: TTabelaDTO;
    FSendoEditada: Boolean;
    FController: TEditorTabelaController;
    FEventoSalvar: TEventoSolicitarSalvarTabela;
    FEventoCancelar: TEventoSolicitarCancelarEdicao;

    /// Atualiza os dados do DTO com base nos valores da interface.
    procedure AtualizarTabelaDoInterface;

    /// Configura o ClientDataSet com 200 colunas e 2000 linhas.
    procedure ConfigurarClientDataSet;

    /// Carrega os dados de um arquivo XML para o ClientDataSet.
    procedure CarregarClientDataSetDeArquivo;

    /// Executa o processo de salvamento com confirmação do usuário.
    procedure ExecutarSalvarComConfirmacao;
  public
    /// Construtor padrão.
    // <param name="AOwner"> Componente proprietário.</param>
    constructor Create(AOwner: TComponent); reintroduce; overload;

    /// Construtor com DTO de tabela.
    // <param name="AOwner"> Componente proprietário.</param>
    // <param name="ATabela"> DTO da tabela a ser editada.</param>
    constructor Create(AOwner: TComponent; ATabela: TTabelaDTO); reintroduce; overload;

    /// Destrutor.
    destructor Destroy; override;

    /// Evento disparado quando o salvamento é solicitado.
    property EventoSalvar: TEventoSolicitarSalvarTabela read FEventoSalvar write FEventoSalvar;

    /// Evento disparado quando o cancelamento é solicitado.
    property EventoCancelar: TEventoSolicitarCancelarEdicao read FEventoCancelar write FEventoCancelar;
  end;

  /// Formulário de diálogo para confirmar o salvamento com timer.
  TSalvarConfirmacaoDialog = class(TForm)
  private
    FTimer: TTimer;
    FSecondsLeft: Integer;
    FLabel: TLabel;
    FYesButton: TButton;
    FNoButton: TButton;
    /// Evento do timer para atualizar a contagem regressiva.
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure TimerTimer(Sender: TObject);
    /// Evento acionado ao clicar no botão "Sim".
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure SalvarVerdadeiroClick(Sender: TObject);
    /// Evento acionado ao clicar no botão "Não".
    // <param name="Sender"> Objeto que disparou o evento.</param>
    procedure SalvarFalsoClick(Sender: TObject);
  public
    /// Construtor do diálogo.
    // <param name="AOwner"> Componente proprietário.</param>
    // <param name="ATituloTabela"> Título da tabela a ser salva.</param>
    constructor Create(AOwner: TComponent; const ATituloTabela: string); reintroduce;
    /// Exibe o diálogo e retorna o resultado.
    // <returns> True se o usuário confirmou, False caso contrário.</returns>
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
    // O DTO tem um caminho, então vamos carregar os dados
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
  ClientDataSetEditor.FieldDefs.Clear;

  // Cria 200 campos (colunas)
  for i := 1 to 200 do
  begin
    FieldDef := ClientDataSetEditor.FieldDefs.AddFieldDef;
    FieldDef.Name := 'Coluna' + IntToStr(i);
    FieldDef.DataType := ftString;
    FieldDef.Size := 300; // Limite de 300 caracteres por campo
  end;

  ClientDataSetEditor.CreateDataSet;
  ClientDataSetEditor.Open;

  // Insere 2000 registros (linhas)
  ClientDataSetEditor.DisableControls; // Otimiza inserção
  try
    for i := 1 to 2000 do
    begin
      ClientDataSetEditor.Append;
      ClientDataSetEditor.Post;
    end;
  finally
    ClientDataSetEditor.EnableControls;
  end;

  // Posiciona no primeiro registro
  if not ClientDataSetEditor.IsEmpty then
    ClientDataSetEditor.First;

  // Ajusta a largura das colunas no DBGrid (opcional)
  for i := 0 to Min(DBGridEditor.Columns.Count - 1, 19) do // Ajusta só as primeiras 20
  begin
    DBGridEditor.Columns[i].Width := 60; // Ajuste conforme necessário
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
  // Chama o novo método de salvar com confirmação
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
  if not Assigned(FTabela) then
    FTabela := TTabelaDTO.Create;
  FTabela.Titulo := EditarTituloTabela.Text;
  // Outros campos do DTO, se houver, seriam atualizados aqui
end;

// --- Adição: Mostrar conteúdo da célula na StatusBar ---
procedure TViewEditorTabela.DBGridEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Coord: TGridCoord;
  ColIndex, RowIndex: Integer;
begin
  Coord := DBGridEditor.MouseCoord(X, Y);
  ColIndex := Coord.X;
  RowIndex := Coord.Y;

  if (ColIndex >= 0) and (ColIndex < DBGridEditor.Columns.Count) and
     (RowIndex >= 0) and (RowIndex <= ClientDataSetEditor.RecordCount) and
     (ClientDataSetEditor.Active) and not (ClientDataSetEditor.IsEmpty) then
  begin
    try
      // Verifica se está sobre o cabeçalho ou uma célula de dados
      if RowIndex = 0 then
      begin
         // Se estiver sobre o cabeçalho
         BarraStatusEditor.SimpleText := Format('Coluna: %s', [DBGridEditor.Columns[ColIndex].Title.Caption]);
      end
      else if RowIndex > 0 then
      begin
         // Mostra linha e coluna
         BarraStatusEditor.SimpleText := Format('Linha: %d, Coluna: %s', [RowIndex, DBGridEditor.Columns[ColIndex].Title.Caption]);
      end;
    except
      on E: Exception do
        BarraStatusEditor.SimpleText := 'Erro ao ler célula: ' + E.Message;
    end;
  end else
  begin
    BarraStatusEditor.SimpleText := 'Pronto';
  end;
end;

procedure TViewEditorTabela.DBGridEditorExit(Sender: TObject);
begin
  BarraStatusEditor.SimpleText := 'Pronto';
end;
// --- Fim da adição ---

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
