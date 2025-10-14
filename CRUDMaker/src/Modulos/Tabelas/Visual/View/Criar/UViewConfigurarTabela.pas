unit UViewConfigurarTabela;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UTabelaConfiguracaoDTO; // DTO auxiliar

type
  /// <summary>
  /// View para configurar as dimensões iniciais e o tipo de cabeçalho da nova tabela.
  /// </summary>
  TViewConfigurarTabela = class(TForm)
    PainelBotoes: TPanel;
    BotaoAvancar: TButton;
    BotaoCancelar: TButton;
    EditNumLinhas: TEdit;
    EditNumColunas: TEdit;
    LabelLinhas: TLabel;
    LabelColunas: TLabel;
    RadioGroupCabecalho: TRadioGroup;
    LabelInstrucoes: TLabel;
    procedure BotaoAvancarClick(Sender: TObject);
    procedure BotaoVoltarClick(Sender: TObject);
    procedure BotaoCancelarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditNumLinhasChange(Sender: TObject);
    procedure EditNumColunasChange(Sender: TObject);
  private
    FConfiguracao: TConfiguracaoTabelaDTO;
    FOnAvancar: TProc<TConfiguracaoTabelaDTO>; // Evento para passar a configuração
    FOnVoltar: TNotifyEvent;
    FOnCancelar: TNotifyEvent;
    procedure AtualizarEstadoBotoes;
    function ValidarEntradas(out AMensagemErro: string): Boolean;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    constructor Create(AOwner: TComponent; const ANomePlanilha: string); reintroduce;
    destructor Destroy; override;
    property OnAvancar: TProc<TConfiguracaoTabelaDTO> read FOnAvancar write FOnAvancar;
    property OnVoltar: TNotifyEvent read FOnVoltar write FOnVoltar;
    property OnCancelar: TNotifyEvent read FOnCancelar write FOnCancelar;
  end;

var
  ViewConfigurarTabela: TViewConfigurarTabela;

implementation

{$R *.dfm}

constructor TViewConfigurarTabela.Create(AOwner: TComponent; const ANomePlanilha: string);
begin
  inherited Create(AOwner);
  FConfiguracao := TConfiguracaoTabelaDTO.Create;
  FConfiguracao.PlanilhaNome := ANomePlanilha;
  // Inicializa com valores padrão ou vazios
  EditNumLinhas.Text := '10';
  EditNumColunas.Text := '5';
  RadioGroupCabecalho.ItemIndex := 0; // Assume Linha como padrão
end;

destructor TViewConfigurarTabela.Destroy;
begin
//  FConfiguracao.Free;
end;

procedure TViewConfigurarTabela.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree; // Esta linha garante que o formulário será destruído
end;

procedure TViewConfigurarTabela.FormCreate(Sender: TObject);
begin
  AtualizarEstadoBotoes;
end;

procedure TViewConfigurarTabela.EditNumLinhasChange(Sender: TObject);
begin
  AtualizarEstadoBotoes;
end;

procedure TViewConfigurarTabela.EditNumColunasChange(Sender: TObject);
begin
  AtualizarEstadoBotoes;
end;

procedure TViewConfigurarTabela.AtualizarEstadoBotoes;
var
  Dummy: string;
begin
  BotaoAvancar.Enabled := ValidarEntradas(Dummy); // Verifica se pode avançar
end;

function TViewConfigurarTabela.ValidarEntradas(out AMensagemErro: string): Boolean;
var
  NumLinhas, NumColunas: Integer;
begin
  Result := False;
  AMensagemErro := '';

  if not TryStrToInt(EditNumLinhas.Text, NumLinhas) or (NumLinhas <= 0) then
  begin
    AMensagemErro := 'Número de linhas inválido. Deve ser um número inteiro positivo.';
    Exit;
  end;

  if not TryStrToInt(EditNumColunas.Text, NumColunas) or (NumColunas <= 0) then
  begin
    AMensagemErro := 'Número de colunas inválido. Deve ser um número inteiro positivo.';
    Exit;
  end;

  if RadioGroupCabecalho.ItemIndex = -1 then
  begin
    AMensagemErro := 'Selecione o tipo de cabeçalho.';
    Exit;
  end;

  Result := True;
end;

procedure TViewConfigurarTabela.BotaoAvancarClick(Sender: TObject);
var
  MensagemErro: string;
begin
    if ValidarEntradas(MensagemErro) then
    begin
      FConfiguracao.NumLinhas := StrToInt(EditNumLinhas.Text);
      FConfiguracao.NumColunas := StrToInt(EditNumColunas.Text);
      if RadioGroupCabecalho.ItemIndex = 0 then
        FConfiguracao.TipoCabecalho := tcLinha
      else
        FConfiguracao.TipoCabecalho := tcColuna;
      modalresult := mrOk;
      if Assigned(FOnAvancar) then
        FOnAvancar(FConfiguracao);
    end
    else
    begin
      ShowMessage(MensagemErro);
    end;
end;

procedure TViewConfigurarTabela.BotaoVoltarClick(Sender: TObject);
begin
modalresult := mrCancel;
  if Assigned(FOnVoltar) then
    FOnVoltar(Self);
end;

procedure TViewConfigurarTabela.BotaoCancelarClick(Sender: TObject);
begin
modalresult := mrCancel;
  if Assigned(FOnCancelar) then
    FOnCancelar(Self);
end;

end.
