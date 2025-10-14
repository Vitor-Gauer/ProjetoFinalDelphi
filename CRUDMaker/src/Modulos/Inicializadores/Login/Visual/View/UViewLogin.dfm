object ViewLogin: TViewLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Login - GridFlow'
  ClientHeight = 220
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object PainelLogin: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 220
    Align = alClient
    TabOrder = 0
    DesignSize = (
      400
      220)
    object RotuloUsuario: TLabel
      Left = 24
      Top = 24
      Width = 43
      Height = 15
      Caption = 'Usu'#225'rio:'
    end
    object RotuloSenha: TLabel
      Left = 24
      Top = 64
      Width = 35
      Height = 15
      Caption = 'Senha:'
    end
    object GrupoBoxModo: TGroupBox
      Left = 24
      Top = 104
      Width = 353
      Height = 57
      Anchors = [akLeft, akTop, akRight]
      Caption = ' Modo de Opera'#231#227'o '
      TabOrder = 4
      object RadioButtonPublico: TRadioButton
        Left = 16
        Top = 24
        Width = 113
        Height = 17
        Caption = 'P'#250'blico (Servidor)'
        TabOrder = 0
        OnClick = RadioButtonModoClick
      end
      object RadioButtonPrivado: TRadioButton
        Left = 184
        Top = 24
        Width = 113
        Height = 17
        Caption = 'Privado (Local)'
        TabOrder = 1
        OnClick = RadioButtonModoClick
      end
    end
    object EditarUsuario: TEdit
      Left = 88
      Top = 21
      Width = 289
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
    end
    object EditarSenha: TEdit
      Left = 88
      Top = 61
      Width = 289
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      PasswordChar = '*'
      TabOrder = 1
    end
    object BotaoLogin: TButton
      Left = 120
      Top = 176
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Entrar'
      Default = True
      TabOrder = 2
      OnClick = BotaoLoginClick
    end
    object BotaoCancelar: TButton
      Left = 208
      Top = 176
      Width = 75
      Height = 25
      Anchors = [akLeft, akBottom]
      Caption = 'Cancelar'
      TabOrder = 3
      OnClick = BotaoCancelarClick
    end
  end
end
