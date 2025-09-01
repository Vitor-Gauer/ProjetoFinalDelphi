object ViewLogin: TViewLogin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Login - GridFlow'
  ClientHeight = 250
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object PanelLogin: TPanel
    Left = 0
    Top = 0
    Width = 400
    Height = 250
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 8
    ExplicitWidth = 385
    ExplicitHeight = 233
    object LabelUsuario: TLabel
      Left = 50
      Top = 60
      Width = 42
      Height = 15
      Caption = 'Usu'#225'rio:'
    end
    object LabelSenha: TLabel
      Left = 50
      Top = 110
      Width = 37
      Height = 15
      Caption = 'Senha:'
    end
    object EditUsuario: TEdit
      Left = 50
      Top = 80
      Width = 300
      Height = 23
      TabOrder = 0
    end
    object EditSenha: TEdit
      Left = 50
      Top = 130
      Width = 300
      Height = 23
      PasswordChar = '*'
      TabOrder = 1
    end
    object ButtonLogin: TButton
      Left = 150
      Top = 180
      Width = 100
      Height = 30
      Caption = 'Entrar'
      TabOrder = 2
    end
    object RadioButtonPublico: TRadioButton
      Left = 50
      Top = 20
      Width = 113
      Height = 17
      Caption = 'Modo P'#250'blico'
      Checked = True
      TabOrder = 3
      TabStop = True
    end
    object RadioButtonPrivado: TRadioButton
      Left = 180
      Top = 20
      Width = 113
      Height = 17
      Caption = 'Modo Privado'
      TabOrder = 4
    end
  end
end