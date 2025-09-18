object ViewVisualizadorRelatorio: TViewVisualizadorRelatorio
  Left = 0
  Top = 0
  Caption = 'Visualizar Relat'#243'rio'
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
  object PainelVisualizadorTopo: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    TabOrder = 0
    DesignSize = (
      800
      50)
    object RotuloNomeRelatorio: TLabel
      Left = 10
      Top = 15
      Width = 100
      Height = 15
      Caption = 'Nome do Relat'#243'rio'
    end
    object BotaoImprimir: TButton
      Left = 690
      Top = 10
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Imprimir'
      TabOrder = 0
    end
  end
  object EditorVisualizador: TRichEdit
    Left = 0
    Top = 50
    Width = 800
    Height = 428
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Calibri'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object PainelVisualizadorRodape: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 2
    object BarraStatusVisualizador: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end
