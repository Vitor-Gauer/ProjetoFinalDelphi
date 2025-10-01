object ViewSalvarAssociacao: TViewSalvarAssociacao
  Left = 0
  Top = 0
  Caption = 'Compartilhar'
  ClientHeight = 500
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object PainelCompartilharRodape: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 0
    object BarraStatusCompartilhar: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
  object PainelCompAssocBotoes: TPanel
    Left = 0
    Top = 448
    Width = 800
    Height = 30
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 418
    ExplicitWidth = 792
    object BotaoExportarAssociacoes: TButton
      Left = 10
      Top = 2
      Width = 150
      Height = 25
      Caption = 'Exportar Selecionadas'
      TabOrder = 0
    end
  end
  object ListaCompAssociacoes: TListBox
    Left = 0
    Top = 46
    Width = 800
    Height = 402
    Align = alClient
    ItemHeight = 15
    MultiSelect = True
    TabOrder = 2
  end
  object PainelCompAssocTopo: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 794
    Height = 40
    Align = alTop
    Alignment = taLeftJustify
    Caption = 'Exportar Associa'#231#245'es'
    TabOrder = 3
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitWidth = 792
    object CaixaSelecaoTodasAssoc: TCheckBox
      Left = 676
      Top = 12
      Width = 150
      Height = 17
      Caption = 'Selecionar Todas'
      TabOrder = 0
    end
  end
end
