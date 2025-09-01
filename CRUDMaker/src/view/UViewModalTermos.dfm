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
  TextHeight = 15
  object MemoTermos: TMemo
    Left = 0
    Top = 0
    Width = 600
    Height = 350
    Align = alTop
    Lines.Strings = (
      'TERMO DE RESPONSABILIDADE'
      ''
      'Ao utilizar este sistema em modo p'#250'blico, voc'#234' concorda com:'
      ''
      '1. O armazenamento de seus dados no servidor da empresa.'
      '2. O registro de suas atividades para fins de auditoria.'
      '3. ... (Demais cl'#225'usulas do termo)')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object PanelBotoesTermos: TPanel
    Left = 0
    Top = 350
    Width = 600
    Height = 50
    Align = alClient
    TabOrder = 1
    object ButtonAceitar: TButton
      Left = 150
      Top = 10
      Width = 120
      Height = 30
      Caption = 'Aceitar'
      Default = True
      TabOrder = 0
    end
    object ButtonRecusar: TButton
      Left = 330
      Top = 10
      Width = 120
      Height = 30
      Caption = 'Recusar'
      TabOrder = 1
    end
  end
end