unit UViewEditorTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient,
  UTabelaDTO, UEditorTabelaController,
  Math, UFormBaseMinTopoCentro;

type
  TEventoSolicitarSalvarTabela = procedure(const ATabela: TTabelaDTO) of object;
  TEventoSolicitarCancelarEdicao = procedure of object;

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

  TViewEditorTabela = class(TFormBaseMinTopoCentro)
    PainelEditorTopo: TPanel;
    RotuloTituloTabela: TLabel;
    EditarTituloTabela: TEdit;
    BotaoSalvarTabela: TButton;
    BotaoCancelarTabela: TButton;
    BotaoCarregarTabela: TButton;
    DBGridEditor: TDBGrid;
    PainelEditorRodape: TPanel;
    BarraStatusEditor: TStatusBar;
    ClientDataSetEditor: TClientDataSet;
    DataSourceEditor: TDataSource;
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure BotaoCarregarClick(Sender: TObject);
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
    procedure ExecutarSalvarComConfirmacao;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ATabela: TTabelaDTO); reintroduce; overload;
    destructor Destroy; override;
    property EventoSalvar: TEventoSolicitarSalvarTabela read FEventoSalvar write FEventoSalvar;
    property EventoCancelar: TEventoSolicitarCancelarEdicao read FEventoCancelar write FEventoCancelar;
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
  // Cria uma nova instância do controller
  FController := TEditorTabelaController.Create;
end;

destructor TViewEditorTabela.Destroy;
begin
  // Libera os recursos alocados
  FController.Free;
  if not FSendoEditada and Assigned(FTabela) then
    FTabela.Free;
  inherited;
end;

procedure TViewEditorTabela.AoCriarFormulario(Sender: TObject);
begin
  // Configuração inicial do DataSource
  DataSourceEditor.DataSet := ClientDataSetEditor;
  ClientDataSetEditor.Close; // Inicia fechado

  // O ClientDataSet permanece fechado até que o usuário carregue um arquivo
  BarraStatusEditor.SimpleText := 'Pronto - Nenhum arquivo carregado. Use "Carregar".';
  // O título pode vir do DTO se for uma edição
  if Assigned(FTabela) then
    EditarTituloTabela.Text := FTabela.Titulo;
end;

procedure TViewEditorTabela.BotaoCarregarClick(Sender: TObject);
begin
  // Delega a tarefa de carregar ao controller
  if Assigned(FController) then
  begin
    try
      // Chama o método do controller, passando o DTO (que pode ser modificado) e o ClientDataSet
      if FController.CarregarTabela(FTabela, ClientDataSetEditor) then
      begin
        // Se bem-sucedido, o controller atualizou o ClientDataSet e o FTabela
        ClientDataSetEditor.Open; // Garante que esteja aberto
        if not ClientDataSetEditor.IsEmpty then
          ClientDataSetEditor.First;

        // Atualiza a interface com base nos dados carregados
        if Assigned(FTabela) then
        begin
          EditarTituloTabela.Text := FTabela.Titulo;
        end;
        BarraStatusEditor.SimpleText := 'Arquivo carregado com sucesso.';
      end
      else
      begin
        // O controller ou o serviço já mostrou mensagem de erro
        BarraStatusEditor.SimpleText := 'Falha no carregamento.';
        ClientDataSetEditor.Close; // Mantém fechado
      end;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao carregar tabela: ' + E.Message);
        BarraStatusEditor.SimpleText := 'Erro ao carregar.';
        ClientDataSetEditor.Close;
      end;
    end;
  end
  else
  begin
    ShowMessage('Erro: Controller não disponível para carregamento.');
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
           // Chama o controller para salvar
           if FController.ExecutarSalvarTabela(FTabela, ClientDataSetEditor) then
           begin
              ShowMessage('Tabela salva com sucesso!');
              // Fechar a view ou resetar para nova tabela?
              Self.Close;
           end;
           // Se retornar False, o controller/service já mostrou o erro
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

procedure TViewEditorTabela.BotaoSalvarClick(Sender: TObject);
begin
  ExecutarSalvarComConfirmacao;
end;

procedure TViewEditorTabela.BotaoCancelarClick(Sender: TObject);
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
  // Outros campos do DTO seriam atualizados aqui, se houvesse
end;

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
      if RowIndex = 0 then
         BarraStatusEditor.SimpleText := Format('Coluna: %s', [DBGridEditor.Columns[ColIndex].Title.Caption])
      else if RowIndex > 0 then
         BarraStatusEditor.SimpleText := Format('Linha: %d, Coluna: %s', [RowIndex, DBGridEditor.Columns[ColIndex].Title.Caption]);
    except
      on E: Exception do
        BarraStatusEditor.SimpleText := 'Erro ao ler célula: ' + E.Message;
    end;
  end else
    BarraStatusEditor.SimpleText := 'Pronto';
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
  // Armazena o título para uso no Timer/Execute
  FLabel.Caption := ATituloTabela;

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
  // Atualiza o caption com o título da tabela
  FLabel.Caption := Format('Tem certeza que deseja salvar as alterações na tabela "%s"?', [FLabel.Caption]);
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
