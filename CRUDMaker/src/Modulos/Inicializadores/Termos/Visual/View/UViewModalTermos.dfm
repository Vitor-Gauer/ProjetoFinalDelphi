object ViewModalTermos: TViewModalTermos
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Termos de Uso e Responsabilidade'
  ClientHeight = 400
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object MemoTermos: TMemo
    Left = 0
    Top = 0
    Width = 600
    Height = 350
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object PainelBotoesTermos: TPanel
    Left = 0
    Top = 350
    Width = 600
    Height = 50
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      600
      50)
    object BotaoAceitar: TButton
      Left = 150
      Top = 10
      Width = 120
      Height = 30
      Anchors = [akTop]
      Caption = 'Aceitar'
      Default = True
      TabOrder = 0
      OnClick = BotaoAceitarClick
    end
    object BotaoRecusar: TButton
      Left = 330
      Top = 10
      Width = 120
      Height = 30
      Anchors = [akTop]
      Caption = 'Recusar'
      TabOrder = 1
      OnClick = BotaoRecusarClick
    end
  end
end
