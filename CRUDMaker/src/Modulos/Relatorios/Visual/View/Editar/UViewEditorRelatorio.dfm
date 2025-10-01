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
  object PainelRelatorioTopo: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 100
    Align = alTop
    TabOrder = 0
    DesignSize = (
      800
      100)
    object RotuloTituloRelatorio: TLabel
      Left = 10
      Top = 15
      Width = 34
      Height = 15
      Caption = 'T'#237'tulo:'
    end
    object RotuloTipoRelatorio: TLabel
      Left = 10
      Top = 55
      Width = 27
      Height = 15
      Caption = 'Tipo:'
    end
    object EditarTituloRelatorio: TEdit
      Left = 50
      Top = 12
      Width = 520
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
    end
    object ComboBoxTipoRelatorio: TComboBox
      Left = 50
      Top = 52
      Width = 200
      Height = 23
      Style = csDropDownList
      TabOrder = 1
    end
    object BotaoSalvarRelatorio: TButton
      Left = 580
      Top = 35
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Salvar'
      TabOrder = 2
    end
    object BotaoCancelarRelatorio: TButton
      Left = 690
      Top = 35
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      TabOrder = 3
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
  object PainelRelatorioRodape: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 2
    object BarraStatusRelatorio: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end
