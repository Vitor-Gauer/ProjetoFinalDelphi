object ViewEditorRelatorio: TViewEditorRelatorio
  Left = 0
  Top = 0
  Caption = 'Editar Relat'#243'rio'
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
  object PanelRelatorioTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 100
    Align = alTop
    TabOrder = 0
    object LabelTituloRelatorio: TLabel
      Left = 10
      Top = 15
      Width = 30
      Height = 15
      Caption = 'T'#237'tulo:'
    end
    object LabelTipoRelatorio: TLabel
      Left = 10
      Top = 55
      Width = 28
      Height = 15
      Caption = 'Tipo:'
    end
    object EditTituloRelatorio: TEdit
      Left = 50
      Top = 12
      Width = 300
      Height = 23
      TabOrder = 0
    end
    object ComboBoxTipoRelatorio: TComboBox
      Left = 50
      Top = 52
      Width = 200
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Ordenador'
      Items.Strings = (
        'Ordenador'
        'Anal'#237'tico'
        'Gr'#225'fico/Visual'
        'Riscos/Alertas')
    end
    object ButtonSalvarRelatorio: TButton
      Left = 690
      Top = 35
      Width = 100
      Height = 30
      Caption = 'Salvar'
      TabOrder = 2
    end
  end
  object MemoConfiguracaoRelatorio: TMemo
    Left = 0
    Top = 100
    Width = 800
    Height = 378
    Align = alClient
    Lines.Strings = (
      'Configura'#231#245'es do Relat'#243'rio...')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object PanelRelatorioBottom: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 2
    object StatusBarRelatorio: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end