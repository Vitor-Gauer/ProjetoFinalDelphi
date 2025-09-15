unit UViewModalTermos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TOnAceitarTermosEvent = procedure of object;
  TOnRecusarTermosEvent = procedure of object;

  TViewModalTermos = class(TForm)
    MemoTermos: TMemo;
    PainelBotoesTermos: TPanel;
    BotaoAceitar: TButton;
    BotaoRecusar: TButton;
    procedure BotaoAceitarClick(Sender: TObject);
    procedure BotaoRecusarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FOnAceitarTermos: TOnAceitarTermosEvent;
    FOnRecusarTermos: TOnRecusarTermosEvent;
  public
    property OnAceitarTermos: TOnAceitarTermosEvent read FOnAceitarTermos write FOnAceitarTermos;
    property OnRecusarTermos: TOnRecusarTermosEvent read FOnRecusarTermos write FOnRecusarTermos;
  end;

var
  ViewModalTermos: TViewModalTermos;

implementation

{$R *.dfm}

procedure TViewModalTermos.BotaoAceitarClick(Sender: TObject);
begin
  ModalResult := mrOK; // Chamado o resultado no UShowViewController para abrir a view certa
end;

procedure TViewModalTermos.BotaoRecusarClick(Sender: TObject);
begin
  ModalResult := mrCancel; // Chamado o resultado no UShowViewController para abrir a view certa
end;

procedure TViewModalTermos.FormCreate(Sender: TObject);
begin
  MemoTermos.Text := 'TERMO DE RESPONSABILIDADE' + sLineBreak + sLineBreak +
                     'Ao utilizar este sistema em modo público, você concorda com:' + sLineBreak + sLineBreak +
                     '1. O armazenamento de seus dados no servidor da empresa.' + sLineBreak +
                     '2. O registro de suas atividades para fins de auditoria.' + sLineBreak +
                     '3. A responsabilidade pelo uso adequado dos recursos disponibilizados.' + sLineBreak +
                     '4. O cumprimento das políticas de segurança da informação da empresa.';
end;

end.
