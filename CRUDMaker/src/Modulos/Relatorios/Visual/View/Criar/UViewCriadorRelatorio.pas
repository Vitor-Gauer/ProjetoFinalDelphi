unit UViewCriadorRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  // Seus units
  URelatorioDTO, URelatorioConfiguracaoDTO, URelatorioService,
  UPersistenciaLocalService, UShowViewService, Vcl.CheckLst, frCoreClasses,
  frxClass;

type
  TViewCriadorRelatorio = class(TForm)
    PainelTopo: TPanel;
    RotuloTitulo: TLabel;
    EditarTitulo: TEdit;
    RotuloTipo: TLabel;
    ComboBoxTipo: TComboBox;
    PainelCentro: TPanel;
    PainelRodape: TPanel;
    BotaoSalvar: TButton;
    BotaoCancelar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure ComboBoxTipoChange(Sender: TObject);
  private
    FRelatorioDTO: TRelatorioDTO;
    FConfiguracaoDTO: TConfiguracaoRelatorioDTO;
    FRelatorioService: TRelatorioService;
    FPersistenciaService: TPersistenciaLocalService;
    procedure AtualizarPainelOpcoesPorTipo;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  end;

var
  ViewCriadorRelatorio: TViewCriadorRelatorio;

implementation

{$R *.dfm}

constructor TViewCriadorRelatorio.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRelatorioDTO := TRelatorioDTO.Create;
  FConfiguracaoDTO := TConfiguracaoRelatorioDTO.Create;
  FRelatorioService := TRelatorioService.Create; // Usando Singleton
  FPersistenciaService := TPersistenciaLocalService.Create;
  // Preencher ComboBoxTipo
  ComboBoxTipo.Items.Clear;
  ComboBoxTipo.Items.Add('Resumo');
  ComboBoxTipo.Items.Add('Eventos');
  ComboBoxTipo.Items.Add('Análise e Tendência');
  ComboBoxTipo.Items.Add('Classificação');
  ComboBoxTipo.Items.Add('Exceção');
  ComboBoxTipo.Items.Add('Pivotamento');
end;

destructor TViewCriadorRelatorio.Destroy;
begin
  FRelatorioDTO.Free;
  FConfiguracaoDTO.Free;
  // FRelatorioService (Singleton) não é liberado aqui
  FPersistenciaService.Free;
  inherited;
end;

procedure TViewCriadorRelatorio.FormCreate(Sender: TObject);
begin
  inherited;
  AtualizarPainelOpcoesPorTipo;
end;

procedure TViewCriadorRelatorio.ComboBoxTipoChange(Sender: TObject);
begin
  AtualizarPainelOpcoesPorTipo;
end;

procedure TViewCriadorRelatorio.AtualizarPainelOpcoesPorTipo;
var
  Tipo: TTipoRelatorioDTO;
begin
  // Limpar PainelCentro e adicionar controles dinamicamente baseados no tipo
  PainelCentro.DisableAlign;
  try
    PainelCentro.Controls.Clear; // Remove controles antigos

    case ComboBoxTipo.ItemIndex of
      0: Tipo := trResumo;
      1: Tipo := trEventos;
      2: Tipo := trAnaliseTendencia;
      3: Tipo := trClassificacao;
      4: Tipo := trExcecao;
      5: Tipo := trPivotamento;
      else Tipo := trEventos; // Padrão
    end;

    // Exemplo de adição de controles genéricos
    // A lógica real dependerá de como você deseja coletar as informações para cada tipo
    // Ex: TCheckListBox para selecionar colunas, TEdit para critérios, etc.
    case Tipo of
      trResumo, trEventos:
      begin
        // Adicionar TCheckListBox para selecionar colunas
        // Adicionar TComboBox para tipo de agregação (para trResumo)
      end;
      trPivotamento:
      begin
        // Adicionar TComboBox para Linhas
        // Adicionar TComboBox para Colunas
        // Adicionar TComboBox para Valores
      end;
      // Adicionar lógica para outros tipos
    end;

  finally
    PainelCentro.EnableAlign;
  end;
end;

procedure TViewCriadorRelatorio.BotaoSalvarClick(Sender: TObject);
var
  NomeRelatorio, CaminhoRelatorio: string;
  ConfiguracaoJSON: string;
  JSONObj: TJSONObject;
  JSONLinhas, JSONColunas, JSONEscopos: TJSONArray;
  I: Integer;
begin
  if Trim(EditarTitulo.Text) = '' then
  begin
    ShowMessage('O título do relatório é obrigatório.');
    Exit;
  end;

  FRelatorioDTO.Titulo := Trim(EditarTitulo.Text);
  case ComboBoxTipo.ItemIndex of
    0: FConfiguracaoDTO.Tipo := trResumo;
    1: FConfiguracaoDTO.Tipo := trEventos;
    2: FConfiguracaoDTO.Tipo := trAnaliseTendencia;
    3: FConfiguracaoDTO.Tipo := trClassificacao;
    4: FConfiguracaoDTO.Tipo := trExcecao;
    5: FConfiguracaoDTO.Tipo := trPivotamento;
  end;

  // Preencher Linhas e Colunas com base na interface (ex: TCheckListBox)
  // Preencher Escopos com base na interface (ex: TEdit com "1-7,1,3-6")
  // Preencher InformacoesExtras com base na interface (ex: TEdit)

  // Converter DTO para JSON (ou outro formato de string)
//  JSONObj := TJSONObject.Create;
//  try
//    JSONObj.AddPair('Tipo', GetEnumName(TypeInfo(TTipoRelatorioDTO), Ord(FConfiguracaoDTO.Tipo)));
//
//    JSONLinhas := TJSONArray.Create;
//    for I := Low(FConfiguracaoDTO.Linhas) to High(FConfiguracaoDTO.Linhas) do
//      JSONLinhas.Add(FConfiguracaoDTO.Linhas[I]);
//    JSONObj.AddPair('Linhas', JSONLinhas);
//
//    JSONColunas := TJSONArray.Create;
//    for I := Low(FConfiguracaoDTO.Colunas) to High(FConfiguracaoDTO.Colunas) do
//      JSONColunas.Add(FConfiguracaoDTO.Colunas[I]);
//    JSONObj.AddPair('Colunas', JSONColunas);
//
//    JSONObj.AddPair('InformacoesExtras', FConfiguracaoDTO.InformacoesExtras);
//
//    JSONEscopos := TJSONArray.Create;
//    for I := Low(FConfiguracaoDTO.Escopos) to High(FConfiguracaoDTO.Escopos) do
//      JSONEscopos.Add(FConfiguracaoDTO.Escopos[I]);
//    JSONObj.AddPair('Escopos', JSONEscopos);
//
//    ConfiguracaoJSON := JSONObj.ToJSON;
//  finally
//    JSONObj.Free;
//  end;
//
//  FRelatorioDTO.ConfiguracaoString := ConfiguracaoJSON;

  // Gerar nome do arquivo: Titulo_Tipo
  NomeRelatorio := FRelatorioDTO.Titulo + '_' + GetEnumName(TypeInfo(TTipoRelatorioDTO), Ord(FConfiguracaoDTO.Tipo));
  FRelatorioDTO.NomeArquivo := NomeRelatorio + '.xml'; // Exemplo

  CaminhoRelatorio := FPersistenciaService.CaminhodeRelatorio(NomeRelatorio, False);

  if FRelatorioService.SalvarConfiguracaoRelatorio(CaminhoRelatorio, ConfiguracaoJSON) then
  begin
    ShowMessage('Relatório "' + NomeRelatorio + '" criado com sucesso.');
    ModalResult := mrOk;
  end
  else
    ShowMessage('Erro ao salvar o relatório.');
end;

procedure TViewCriadorRelatorio.BotaoCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
