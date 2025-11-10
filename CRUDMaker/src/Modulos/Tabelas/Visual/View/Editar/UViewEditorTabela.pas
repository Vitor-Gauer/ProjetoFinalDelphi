unit UViewEditorTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Math,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient,
  UTabelaDTO, UEditorTabelaController,
   UFormBaseMinTopoCentro;

type
  TEventoSolicitarSalvarTabela = procedure(const ATabela: TTabelaDTO) of object;

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
    constructor Create(AOwner: TComponent); reintroduce;
    function Execute: Boolean;
  end;

  TViewEditorTabela = class(TFormBaseMinTopoCentro)
    PainelEditorTopo: TPanel;
    RotuloTituloTabela: TLabel;
    EditarTituloTabela: TEdit;
    BotaoSalvarTabela: TButton;
    BotaoSairTabela: TButton;
    DBGridEditor: TDBGrid;
    PainelEditorRodape: TPanel;
    BarraStatusEditor: TStatusBar;
    ClientDataSetEditor: TClientDataSet;
    DataSourceEditor: TDataSource;
    RotuloTituloPlanilha: TLabel;
    EditarTituloPlanilha: TEdit;
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoSairClick(Sender: TObject);
    procedure DBGridEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DBGridEditorExit(Sender: TObject);
  private
    FTabela: TTabelaDTO;
    FSendoEditada: Boolean;
    FController: TEditorTabelaController;
    procedure AtualizarTabelaDoInterface;
    procedure ExecutarSalvarComConfirmacao;
  public
    constructor Create(AOwner: TComponent); reintroduce; overload;
    constructor Create(AOwner: TComponent; ATabela: TTabelaDTO); reintroduce; overload;
    class function CreateEditorComDados(const APlanilhaNome:string;ATabelaDTO: TTabelaDTO; ADataSetCarregado: TDataSet): TViewEditorTabela;
    destructor Destroy; override;
  end;

var
  ViewEditorTabela: TViewEditorTabela;
  NewView: TViewEditorTabela;
  NewController: TEditorTabelaController;
  HojeTempo : TDateTime;
  NomePlanilha, NomeTabela, DiretorioExatoDaTabela, DiretorioExatoDaTabelaBackup, HojeString: string;
  booleana:bool;
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
  DataSourceEditor.DataSet := ClientDataSetEditor;
  // O ClientDataSet permanece fechado até que o usuário carregue um arquivo
  BarraStatusEditor.SimpleText := 'Pronto - Nenhum arquivo carregado. Use "Carregar".';
  ClientDataSetEditor.Close;
  if Assigned(FTabela) then
  EditarTituloTabela.Text := FTabela.Titulo;
end;

class function TViewEditorTabela.CreateEditorComDados(const APlanilhaNome:string; ATabelaDTO: TTabelaDTO; ADataSetCarregado: TDataSet): TViewEditorTabela;
begin
  booleana := false;
  NewView := TViewEditorTabela.Create(nil); // Cria a instância da view
  NewController := TEditorTabelaController.Create; // Cria o Controller *dentro* do construtor da View
  try
    // Injeta o DTO
    NewView.FTabela := ATabelaDTO; // Armazena referência ao DTO (cuidado com posse!)
    // Injeta o Controller
    NewView.FController := NewController; // Armazena referência ao Controller criado
    // Associa o DataSet carregado ao DataSource da View (e consequentemente ao DBGrid)
    if not assigned(ADataSetCarregado) then
        showmessage('ita porr');


    NewView.DataSourceEditor.DataSet := ADataSetCarregado; // O DataSet carregado é associado diretamente

    if Assigned(ATabelaDTO) then
    begin
      NomeTabela := ATabelaDTO.Titulo;
      NomePlanilha := APlanilhaNome;
      NewView.EditarTituloTabela.Text := NomeTabela;
      NewView.EditarTituloPlanilha.Text := NomePlanilha;
    end;

    if Assigned(ATabelaDTO) and (ATabelaDTO.CaminhoArquivoCSV <> '') then
      NewView.BarraStatusEditor.SimpleText := 'Dados carregados do CSV: ' + ATabelaDTO.CaminhoArquivoCSV
    else
      NewView.BarraStatusEditor.SimpleText := 'Dados carregados (origem desconhecida).';

    if Assigned(ADataSetCarregado) and not ADataSetCarregado.Active then
      ADataSetCarregado.Open; // Abrir o DataSet se necessário

    Result := NewView; // Retorna a view pronta com seu controller e dados
  except
    on E: Exception do
    begin
      // Se ocorrer erro, liberar o Controller criado e a View parcialmente criada
      NewController.Free; // Libera o controller em caso de erro
      NewView.Free; // Libera a view em caso de erro
      raise; // Relevanta a exceção
    end;
  end;
end;

destructor TViewEditorTabela.Destroy;
begin
  FController.Destroy;
  inherited;
end;

procedure TViewEditorTabela.ExecutarSalvarComConfirmacao;
var
  TituloTabela: string;
  LocalDoArquivo, LocalDoArquivoBackup: string;
  ConfirmForm: TSalvarConfirmacaoDialog;
  Resposta: Boolean;
  DataSetOrigem: TDataSet;
begin
  // Garante que qualquer edição pendente no DBGrid seja aplicada ao DataSet
  DataSetOrigem := NewView.DataSourceEditor.DataSet;
  if assigned(DataSetOrigem) and DataSetOrigem.Active then
    DataSetOrigem.CheckBrowseMode;

  AtualizarTabelaDoInterface();

  if Assigned(FTabela) and (FTabela.Titulo <> '') then
    TituloTabela := FTabela.Titulo
  else
    TituloTabela := 'Sem Título';

  ConfirmForm := TSalvarConfirmacaoDialog.Create(Self);
  try
    Resposta := ConfirmForm.Execute;
    if Resposta then
    begin
      LocalDoArquivo := DiretorioExatoDaTabela;
      LocalDoArquivoBackup := DiretorioExatoDaTabelaBackup;
      if (LocalDoArquivo <> '') and Assigned(FController) then
      begin
        try
          if FController.ExecutarSalvarTabela(DataSetOrigem, LocalDoArquivo, FTabela) then
          begin
            FController.ExecutarSalvarTabela(DataSetOrigem, LocalDoArquivoBackup, FTabela);
            ShowMessage('Tabela salva com sucesso!');
            Self.Close;
          end;
        except
          on E: Exception do
          begin
            ShowMessage('Erro ao iniciar o salvamento: ' + E.Message);
          end;
        end;
      end
      else if LocalDoArquivo = '' then
      begin
         ShowMessage('Operação de salvamento cancelada. O local do arquivo não foi especificado.');
      end
      else
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

procedure TViewEditorTabela.BotaoSairClick(Sender: TObject);
begin
  if booleana then
  Self.Close
  else
  showmessage('Tenha certeza que você já salvou as alterações');
  booleana := true;
end;

procedure TViewEditorTabela.AtualizarTabelaDoInterface;
begin
  if not Assigned(FTabela) then
    FTabela := TTabelaDTO.Create;
  FTabela.Titulo := EditarTituloTabela.Text;
end;

procedure TViewEditorTabela.DBGridEditorMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Coord: TGridCoord;
  ColIndex, RowIndex: Integer;
  DataSetAtivo: TDataSet; // Referência local para o DataSet do DataSource
begin
  Coord := DBGridEditor.MouseCoord(X, Y);
  ColIndex := Coord.X;
  RowIndex := Coord.Y;

  // Obter referência ao DataSet do DataSource para evitar acessos diretos ao componente DFM
  DataSetAtivo := DataSourceEditor.DataSet;

  // Verificar primeiro se o DataSet está ativo e se os índices são válidos
  if Assigned(DataSetAtivo) and // Verificar se o DataSet está associado
     DataSetAtivo.Active and   // Verificar se está aberto ANTES de acessar RecordCount ou IsEmpty
     (ColIndex >= 0) and (ColIndex < DBGridEditor.Columns.Count) and
     (RowIndex >= 0) and (RowIndex <= DataSetAtivo.RecordCount) and
     not DataSetAtivo.IsEmpty then
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

constructor TSalvarConfirmacaoDialog.Create(AOwner: TComponent);
begin
  inherited CreateNew(AOwner);
  Self.BorderStyle := bsDialog;
  Self.Caption := 'Confirmar Salvar';
  Self.Width := 700;
  Self.Height := 150;
  Self.Position := poMainFormCenter;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.AutoSize := False;
  FLabel.WordWrap := True;
  FLabel.Width := Self.ClientWidth-20;
  FLabel.Left := 10;
  FLabel.Top := 10;
  // Armazena o título para uso no Timer/Execute
  FLabel.Caption := NomeTabela;

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
  DiretorioExatoDaTabela := ExtractFilePath(Application.ExeName);
  DiretorioExatoDaTabela := DiretorioExatoDaTabela + 'planilhas';
  DiretorioExatoDaTabela := DiretorioExatoDaTabela + pathdelim + NomePlanilha;
  DiretorioExatoDaTabela := DiretorioExatoDaTabela + pathdelim + 'tabelas';
  DiretorioExatoDaTabela := DiretorioExatoDaTabela + pathdelim + NomeTabela + pathdelim + NomeTabela + '.csv';

  HojeTempo := Now;
  HojeString := FormatDateTime(' yyyy-mm-dd hh_nn_ss ', HojeTempo);
  DiretorioExatoDaTabelaBackup := ExtractFilePath(Application.ExeName);
  DiretorioExatoDaTabelaBackup := DiretorioExatoDaTabelaBackup + 'backup';
  DiretorioExatoDaTabelaBackup := DiretorioExatoDaTabelaBackup + pathdelim + 'planilhas';
  DiretorioExatoDaTabelaBackup := DiretorioExatoDaTabelaBackup + pathdelim + NomePlanilha;
  DiretorioExatoDaTabelaBackup := DiretorioExatoDaTabelaBackup + pathdelim + 'tabelas';
  DiretorioExatoDaTabelaBackup := DiretorioExatoDaTabelaBackup + pathdelim + NomeTabela + pathdelim + NomeTabela + ' ('+HojeString+')' + '.csv';
end;

function TSalvarConfirmacaoDialog.Execute: Boolean;
var
  ResultadoModal: TModalResult;
begin
  FSecondsLeft := 5;

  // Atualiza o caption com o título da tabela
  FLabel.Caption := Format('Tem certeza que deseja salvar as alterações na tabela: "%s"?', [FLabel.Caption]);
  FYesButton.Caption := Format('Sim (%d)', [FSecondsLeft]);
  FYesButton.Enabled := False;
  FTimer.Enabled := True;

  // O ShowModal exibe a janela e o código PAUSA até o usuário clicar em Sim ou Não
  ResultadoModal := Self.ShowModal;

  // Desabilita o timer após o retorno do modal, caso o usuário feche a janela ou clique
  FTimer.Enabled := False;
  if ResultadoModal = mrYes then
  Result:=True
  else
  Result:=False;
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
