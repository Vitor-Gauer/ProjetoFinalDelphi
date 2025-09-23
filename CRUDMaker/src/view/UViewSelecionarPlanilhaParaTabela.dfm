object ViewSelecionarPlanilhaParaTabela: TViewSelecionarPlanilhaParaTabela
  Left = 0
  Top = 0
  Caption = 'Selecionar Planilha'
  ClientHeight = 300
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object LabelInstrucoes: TLabel
    Left = 8
    Top = 8
    Width = 249
    Height = 13
    Caption = 'Selecione a planilha onde a nova tabela ser'#225' criada:'
  end
  object ListBoxPlanilhas: TListBox
    Left = 8
    Top = 27
    Width = 384
    Height = 226
    ItemHeight = 13
    TabOrder = 0
    OnClick = ListBoxPlanilhasClick
  end
  object PainelBotoes: TPanel
    Left = 0
    Top = 269
    Width = 400
    Height = 31
    Align = alBottom
    TabOrder = 1
    object BotaoAvancar: TButton
      Left = 237
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Avan'#231'ar'
      TabOrder = 0
      OnClick = BotaoAvancarClick
    end
    object BotaoCancelar: TButton
      Left = 318
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 1
      OnClick = BotaoCancelarClick
    end
  end
end
