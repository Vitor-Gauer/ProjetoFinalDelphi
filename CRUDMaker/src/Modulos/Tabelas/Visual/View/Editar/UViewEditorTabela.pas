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
    class function CreateEditorComDados(const ATabelaDTO: TTabelaDTO; ADataSetCarregado: TDataSet): TViewEditorTabela;
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

class function TViewEditorTabela.CreateEditorComDados(const ATabelaDTO: TTabelaDTO; ADataSetCarregado: TDataSet): TViewEditorTabela;
var
  NewView: TViewEditorTabela;
  NewController: TEditorTabelaController; // Controller a ser criado
begin
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

    // Opcional: Atualizar a interface com base nos dados do DTO
    if Assigned(ATabelaDTO) then
      NewView.EditarTituloTabela.Text := ATabelaDTO.Titulo;

    // Opcional: Atualizar status
    if Assigned(ATabelaDTO) and (ATabelaDTO.CaminhoArquivoCSV <> '') then
      NewView.BarraStatusEditor.SimpleText := 'Dados carregados do CSV: ' + ATabelaDTO.CaminhoArquivoCSV
    else
      NewView.BarraStatusEditor.SimpleText := 'Dados carregados (origem desconhecida).';

    // A View está pronta, mas o DataSet pode estar aberto ou fechado dependendo de como o CSVService o deixou.
    // Se o CSVService o abriu, pode não ser necessário abrir novamente.
    // Se o CSVService o deixou fechado, abrir aqui.
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
  // Libera os recursos alocados
  FreeandNil(FController);
  inherited;
end;

procedure TViewEditorTabela.AoCriarFormulario(Sender: TObject);
begin
  // Configuração inicial do DataSource
  DataSourceEditor.DataSet := ClientDataSetEditor;
  // O ClientDataSet permanece fechado até que o usuário carregue um arquivo
  BarraStatusEditor.SimpleText := 'Pronto - Nenhum arquivo carregado. Use "Carregar".';
  ClientDataSetEditor.Close;
  // O título pode vir do DTO se for uma edição
  if Assigned(FTabela) then
    EditarTituloTabela.Text := FTabela.Titulo;
end;

// --- MODIFICADO: Handler para o botão Carregar ---
procedure TViewEditorTabela.BotaoCarregarClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
  FilePath: string;
  FileExt: string;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    // Atualiza o filtro para incluir XML e CSV
    OpenDialog.Filter := 'Arquivos de Dados (XML/CSV)|*.xml;*.csv|XML Files (*.xml)|*.xml|CSV Files (*.csv)|*.csv|All Files (*.*)|*.*';
    OpenDialog.DefaultExt := 'xml'; // Padrão para XML
    if OpenDialog.Execute then
    begin
      FilePath := OpenDialog.FileName;
      FileExt := LowerCase(ExtractFileExt(FilePath));

      ClientDataSetEditor.Close; // Fecha o dataset antes de carregar novos dados

      try
        if FileExt = '.xml' then
        begin
          // Carrega usando o serviço XML personalizado
          if Assigned(FController) then
          begin
            // Chama o método do controller, passando o DTO (que pode ser modificado) e o ClientDataSet
            (*if FController.CarregarTabela(FTabela, ClientDataSetEditor) then
            begin
              // Se bem-sucedido, o controller atualizou o ClientDataSet e potencialmente o FTabela
              ClientDataSetEditor.Open; // Garante que esteja aberto
              if not ClientDataSetEditor.IsEmpty then
                ClientDataSetEditor.First;

              // Atualiza a interface com base nos dados carregados
              if Assigned(FTabela) then
              begin
                EditarTituloTabela.Text := FTabela.Titulo;
                // Se o título não estivesse no DTO, poderia inferir do nome do arquivo:
                // if FTabela.Titulo = '' then
                //   EditarTituloTabela.Text := ChangeFileExt(ExtractFileName(FTabela.CaminhoArquivoXML), '');
              end;
              BarraStatusEditor.SimpleText := 'Arquivo XML carregado com sucesso.';
            end
            else
            begin
              // O controller ou o serviço já mostrou mensagem de erro
              BarraStatusEditor.SimpleText := 'Falha no carregamento do XML.';
              ClientDataSetEditor.Close; // Mantém fechado
            end;*)
          end
          else
          begin
            ShowMessage('Erro: Controller não disponível para carregamento.');
          end;
        end
        else if FileExt = '.csv' then
        begin
          // Carrega usando o serviço CSV
          if Assigned(FController) then
          begin
            // Chama o método do controller, passando o DTO (que pode ser modificado) e o ClientDataSet
            (* if FController.CarregarTabela(FTabela, ClientDataSetEditor) then
            begin
              // Se bem-sucedido, o controller atualizou o ClientDataSet e potencialmente o FTabela
              ClientDataSetEditor.Open; // Garante que esteja aberto
              if not ClientDataSetEditor.IsEmpty then
                ClientDataSetEditor.First;

              // Atualiza a interface com base nos dados carregados
              if Assigned(FTabela) then
              begin
                EditarTituloTabela.Text := FTabela.Titulo;
                // Se o título não estivesse no DTO, poderia inferir do nome do arquivo:
                // if FTabela.Titulo = '' then
                //   EditarTituloTabela.Text := ChangeFileExt(ExtractFileName(FTabela.CaminhoArquivoXML), '');
              end;
              BarraStatusEditor.SimpleText := 'Arquivo CSV carregado com sucesso.';
            end
            else
            begin
              // O controller ou o serviço já mostrou mensagem de erro
              BarraStatusEditor.SimpleText := 'Falha no carregamento do CSV.';
              ClientDataSetEditor.Close; // Mantém fechado
            end;*)
          end
          else
          begin
            ShowMessage('Erro: Controller não disponível para carregamento.');
          end;
        end
        else
        begin
          ShowMessage('Formato de arquivo não suportado para carregamento: ' + FileExt);
          Exit; // Sai sem atualizar o título ou DTO
        end;

      except
        on E: Exception do
        begin
          ShowMessage('Erro ao carregar o arquivo: ' + E.Message);
          BarraStatusEditor.SimpleText := 'Erro ao carregar.';
          ClientDataSetEditor.Close; // Garante que está fechado em caso de erro
        end;
      end;
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
           // Chama o controller para salvar
           if FController.ExecutarSalvarTabela(FTabela, ClientDataSetEditor) then
           begin
              ShowMessage('Tabela salva com sucesso!');
              Self.Close;
           end;
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
