unit UViewCriadorTabelaDados;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient,
  UTabelaDTO, UTabelaConfiguracaoDTO, UCriadorTabelaController, Math, UFormBaseMinTopoCentro;

type
  TViewCriadorTabelaDados = class(TFormBaseMinTopoCentro)
    PainelTopo: TPanel;
    RotuloTitulo: TLabel;
    EditarTitulo: TEdit;
    BotaoSalvar: TButton;
    BotaoCancelar: TButton;
    DBGridDados: TDBGrid;
    PainelRodape: TPanel;
    BarraStatus: TStatusBar;
    ClientDataSetDados: TClientDataSet;
    DataSourceDados: TDataSource;
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridDadosMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DBGridDadosExit(Sender: TObject);
  private
    FTabela: TTabelaDTO;
    FConfiguracao: TConfiguracaoTabelaDTO;
    FController: TCriadorTabelaController;
    procedure ConfigurarClientDataSet(const AConfig: TConfiguracaoTabelaDTO);
    procedure AtualizarTabelaDoInterface;
  public
    constructor Create(AOwner: TComponent; const AConfiguracao: TConfiguracaoTabelaDTO); reintroduce;
    destructor Destroy; override;
  end;

var
  ViewCriadorTabelaDados: TViewCriadorTabelaDados;

implementation

{$R *.dfm}

constructor TViewCriadorTabelaDados.Create(AOwner: TComponent; const AConfiguracao: TConfiguracaoTabelaDTO);
begin
  inherited Create(AOwner);
  FConfiguracao := AConfiguracao;
  FTabela := TTabelaDTO.Create;
  FController := TCriadorTabelaController.Create;
end;

destructor TViewCriadorTabelaDados.Destroy;
begin
  FreeandNil(FController);
  FreeandNil(FTabela);
  if Assigned(FConfiguracao) then
    FConfiguracao.Free;
  inherited;
end;

procedure TViewCriadorTabelaDados.FormCreate(Sender: TObject);
begin
  if Assigned(FConfiguracao) then
  begin
    ConfigurarClientDataSet(FConfiguracao);
    EditarTitulo.Text := 'NovaTabela' + FConfiguracao.PlanilhaNome;
  end
  else
  begin
    ShowMessage('Erro: Configuração da tabela não fornecida.');
    Self.Close;
  end;
  BarraStatus.SimpleText := 'Pronto - Nova Tabela';
end;

procedure TViewCriadorTabelaDados.ConfigurarClientDataSet(const AConfig: TConfiguracaoTabelaDTO);
var
  i, j: Integer;
  FieldDef: TFieldDef;
begin
  if not Assigned(AConfig) then
    raise Exception.Create('Configuração de tabela não fornecida para criação.');

  ClientDataSetDados.Close;
  ClientDataSetDados.FieldDefs.Clear;

  for i := 1 to AConfig.NumColunas do
  begin
    FieldDef := ClientDataSetDados.FieldDefs.AddFieldDef;
    FieldDef.Name := 'Coluna' + IntToStr(i);
    FieldDef.DataType := ftString;
    FieldDef.Size := 300;
  end;

  ClientDataSetDados.CreateDataSet;
  ClientDataSetDados.Open;

  ClientDataSetDados.DisableControls;
  try
    for i := 1 to AConfig.NumLinhas do
    begin
      ClientDataSetDados.Append;
      for j := 1 to AConfig.NumColunas do
      begin
        ClientDataSetDados.FieldByName('Coluna' + IntToStr(j)).AsString := '';
      end;
      ClientDataSetDados.Post;
    end;
  finally
    ClientDataSetDados.EnableControls;
  end;

  if not ClientDataSetDados.IsEmpty then
    ClientDataSetDados.First;

  for i := 0 to Min(DBGridDados.Columns.Count - 1, 19) do
  begin
    DBGridDados.Columns[i].Width := 80;
  end;
end;

procedure TViewCriadorTabelaDados.AtualizarTabelaDoInterface;
begin
  if Assigned(FTabela) then
    FTabela.Titulo := EditarTitulo.Text;
end;

procedure TViewCriadorTabelaDados.BotaoSalvarClick(Sender: TObject);
begin
  AtualizarTabelaDoInterface;

  if Assigned(FController) and Assigned(FTabela) and Assigned(ClientDataSetDados) and Assigned(FConfiguracao) then
  begin
    try
      if FController.ExecutarCriarTabela(FConfiguracao, FTabela, ClientDataSetDados) then
      begin
        ShowMessage('Tabela criada com sucesso!');
        Self.ModalResult := mrOk;
      end;
    except
      on E: Exception do
      begin
        ShowMessage('Erro ao salvar tabela: ' + E.Message);
      end;
    end;
  end
  else
  begin
    ShowMessage('Erro: Componentes necessários para criação não disponíveis.');
  end;
end;

procedure TViewCriadorTabelaDados.BotaoCancelarClick(Sender: TObject);
begin
  Self.ModalResult := mrCancel;
end;

procedure TViewCriadorTabelaDados.DBGridDadosMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Coord: TGridCoord;
  ColIndex, RowIndex: Integer;
begin
  Coord := DBGridDados.MouseCoord(X, Y);
  ColIndex := Coord.X;
  RowIndex := Coord.Y;

  if (ColIndex >= 0) and (ColIndex < DBGridDados.Columns.Count) and
     (RowIndex >= 0) and (RowIndex <= ClientDataSetDados.RecordCount) and
     (ClientDataSetDados.Active) and not (ClientDataSetDados.IsEmpty) then
  begin
    try
      if RowIndex = 0 then
      begin
         BarraStatus.SimpleText := Format('Coluna: %s', [DBGridDados.Columns[ColIndex].Title.Caption]);
      end
      else if RowIndex > 0 then
      begin
         BarraStatus.SimpleText := Format('Linha: %d, Coluna: %s', [RowIndex, DBGridDados.Columns[ColIndex].Title.Caption]);
      end;
    except
      on E: Exception do
        BarraStatus.SimpleText := 'Erro ao ler célula: ' + E.Message;
    end;
  end else
  begin
    BarraStatus.SimpleText := 'Pronto - Nova Tabela';
  end;
end;

procedure TViewCriadorTabelaDados.DBGridDadosExit(Sender: TObject);
begin
  BarraStatus.SimpleText := 'Pronto - Nova Tabela';
end;

end.
