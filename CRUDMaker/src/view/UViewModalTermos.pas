// Arquivo: UViewModalTermos.pas

unit UViewModalTermos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  /// Evento disparado quando o usuário aceita os termos.
  TOnAceitarTermosEvent = procedure of object;
  /// Evento disparado quando o usuário recusa os termos.
  TOnRecusarTermosEvent = procedure of object;

  TViewModalTermos = class(TForm)
    MemoTermos: TMemo;
    PainelBotoesTermos: TPanel;
    BotaoAceitar: TButton;
    BotaoRecusar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BotaoAceitarClick(Sender: TObject);
    procedure BotaoRecusarClick(Sender: TObject);
  private
    FOnAceitarTermos: TOnAceitarTermosEvent;
    FOnRecusarTermos: TOnRecusarTermosEvent;
  public
    /// Evento chamado quando o usuário clica em 'Aceitar'.
    property OnAceitarTermos: TOnAceitarTermosEvent read FOnAceitarTermos write FOnAceitarTermos;
    /// Evento chamado quando o usuário clica em 'Recusar'.
    property OnRecusarTermos: TOnRecusarTermosEvent read FOnRecusarTermos write FOnRecusarTermos;
  end;

var
  ViewModalTermos: TViewModalTermos;

implementation

{$R *.dfm}

{
  Configura o conteúdo do memo com os termos de uso.
}
procedure TViewModalTermos.FormCreate(Sender: TObject);
begin
  MemoTermos.Lines.Text :=
    'TERMO DE RESPONSABILIDADE' + sLineBreak + sLineBreak +
    'Ao utilizar este sistema em modo público, você concorda com:' + sLineBreak + sLineBreak +
    '1. O armazenamento de seus dados no servidor da empresa.' + sLineBreak +
    '2. O registro de suas atividades para fins de auditoria.' + sLineBreak +
    '3. A responsabilidade pelo uso adequado dos recursos disponibilizados.' + sLineBreak +
    '4. O cumprimento das políticas de segurança da informação da empresa.';
end;

{
  Trata o clique no botão 'Aceitar'.
  Dispara o evento OnAceitarTermos (se atribuído) e define o resultado do modal como mrOk.
}
procedure TViewModalTermos.BotaoAceitarClick(Sender: TObject);
begin
  // --- PONTO DE DEBUG 1: Início do handler ---
  OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - INICIO');

  try
    // --- PONTO DE DEBUG 2: Antes de chamar evento personalizado ---
    OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - Antes de FOnAceitarTermos');

    if Assigned(FOnAceitarTermos) then
    begin
      OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - Chamando FOnAceitarTermos');
      FOnAceitarTermos;
      OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - FOnAceitarTermos RETORNOU');
    end;

    // --- PONTO DE DEBUG 3: Antes de definir ModalResult ---
    OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - Antes de ModalResult := mrOk');

    ModalResult := mrOk;

    // --- PONTO DE DEBUG 4: Após definir ModalResult ---
    OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - ModalResult := mrOk DEFINIDO');

  except
    on E: Exception do
    begin
      // --- PONTO DE DEBUG 5: Captura de exceção ---
      OutputDebugString(PWideChar('DEBUG: TViewModalTermos.BotaoAceitarClick - EXCECAO: ' + E.Message));
      // Re-raise para que o comportamento padrão (fechar o modal) ainda ocorra
      // ModalResult := mrCancel; // Ou outro valor para indicar erro
      raise;
    end;
  end;

  OutputDebugString('DEBUG: TViewModalTermos.BotaoAceitarClick - FIM');
end;

{
  Trata o clique no botão 'Recusar'.
  Dispara o evento OnRecusarTermos (se atribuído) e define o resultado do modal como mrCancel.
}
procedure TViewModalTermos.BotaoRecusarClick(Sender: TObject);
begin
  // --- PONTO DE DEBUG 1: Início do handler ---
  OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - INICIO');

  try
    // --- PONTO DE DEBUG 2: Antes de chamar evento personalizado ---
    OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - Antes de FOnRecusarTermos');

    if Assigned(FOnRecusarTermos) then
    begin
      OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - Chamando FOnRecusarTermos');
      FOnRecusarTermos;
      OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - FOnRecusarTermos RETORNOU');
    end;

    // --- PONTO DE DEBUG 3: Antes de definir ModalResult ---
    OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - Antes de ModalResult := mrCancel');

    ModalResult := mrCancel;

    // --- PONTO DE DEBUG 4: Após definir ModalResult ---
    OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - ModalResult := mrCancel DEFINIDO');

  except
    on E: Exception do
    begin
      // --- PONTO DE DEBUG 5: Captura de exceção ---
      OutputDebugString(PWideChar('DEBUG: TViewModalTermos.BotaoRecusarClick - EXCECAO: ' + E.Message));
      // Re-raise
      raise;
    end;
  end;

  OutputDebugString('DEBUG: TViewModalTermos.BotaoRecusarClick - FIM');
end;

end.
