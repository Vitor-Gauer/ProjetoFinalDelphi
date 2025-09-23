unit UViewCriadorTabela;  // Esboço

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.DBCtrls, Data.DB, Data.FMTBcd, Datasnap.DBClient, UTabelaDTO, UCriadorTabelaController, Math;

type
  TViewCriadorTabela = class(TForm)
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
    FController: TCriadorTabelaController;
    procedure ConfigurarClientDataSet;
    procedure AtualizarTabelaDoInterface;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  end;

var
  ViewCriadorTabela: TViewCriadorTabela;

implementation

{$R *.dfm}

constructor TViewCriadorTabela.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTabela := TTabelaDTO.Create; // Cria um novo DTO para a nova tabela
  FController := TCriadorTabelaController.Create;
end;

destructor TViewCriadorTabela.Destroy;
begin
  FController.Free;
  FTabela.Free;
  inherited;
end;

procedure TViewCriadorTabela.FormCreate(Sender: TObject);
begin
  ConfigurarClientDataSet;
  BarraStatus.SimpleText := 'Pronto - Nova Tabela';
end;

procedure TViewCriadorTabela.ConfigurarClientDataSet;
var
  i, j: Integer;
  FieldDef: TFieldDef;
begin
  ClientDataSetDados.Close;
  ClientDataSetDados.FieldDefs.Clear;
  // Cria 50 campos (colunas) para exemplo
  for i := 1 to 50 do
  begin
    FieldDef := ClientDataSetDados.FieldDefs.AddFieldDef;
    FieldDef.Name := 'Coluna' + IntToStr(i);
    FieldDef.DataType := ftString;
    FieldDef.Size := 200;
  end;
  ClientDataSetDados.CreateDataSet;
  ClientDataSetDados.Open;

  // Insere 100 registros (linhas) para exemplo
  ClientDataSetDados.DisableControls;
  try
    for i := 1 to 100 do
    begin
      ClientDataSetDados.Append;
      for j := 1 to 50 do
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

  // Ajusta largura das colunas
  for i := 0 to Min(DBGridDados.Columns.Count - 1, 9) do
  begin
    DBGridDados.Columns[i].Width := 80;
  end;
end;

procedure TViewCriadorTabela.AtualizarTabelaDoInterface;
begin
  FTabela.Titulo := EditarTitulo.Text;
end;

procedure TViewCriadorTabela.BotaoSalvarClick(Sender: TObject);
begin
  AtualizarTabelaDoInterface;
  if Assigned(FController) then
  begin
    try
      if FController.ExecutarCriarTabela(FTabela, ClientDataSetDados) then
      begin
         // Sucesso, pode fechar ou limpar
         Self.Close; // Ou mostrar mensagem e limpar para nova tabela
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
    ShowMessage('Erro: Controller não disponível.');
  end;
end;

procedure TViewCriadorTabela.BotaoCancelarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TViewCriadorTabela.DBGridDadosMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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

procedure TViewCriadorTabela.DBGridDadosExit(Sender: TObject);
begin
  BarraStatus.SimpleText := 'Pronto - Nova Tabela';
end;

end.
