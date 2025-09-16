object ViewCompartilhamento: TViewCompartilhamento
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
  object ControleAbasCompartilhar: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 478
    ActivePage = AbaCompPlanilhas
    Align = alClient
    TabOrder = 0
    object AbaCompPlanilhas: TTabSheet
      Caption = 'Sele'#231#227'o de Planilha'
      object PainelCompPlanTopo: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object CaixaSelecaoTodasPlan: TCheckBox
          Left = 10
          Top = 10
          Width = 150
          Height = 17
          Anchors = [akLeft, akTop]
          Caption = 'Selecionar Todas'
          TabOrder = 0
        end
      end
      object ListaCompPlanilhas: TListBox
        Left = 0
        Top = 40
        Width = 792
        Height = 378
        Align = alClient
        ItemHeight = 15
        MultiSelect = True
        TabOrder = 1
      end
      object PainelCompPlanBotoes: TPanel
        Left = 0
        Top = 418
        Width = 792
        Height = 30
        Align = alBottom
        TabOrder = 2
        object BotaoExportarPlanilhas: TButton
          Left = 10
          Top = 3
          Width = 150
          Height = 25
          Anchors = [akLeft, akTop]
          Caption = 'Exportar Selecionadas'
          TabOrder = 0
        end
      end
    end
    object AbaCompRelatorios: TTabSheet
      Caption = 'Sele'#231#227'o de Relat'#243'rio'
      ImageIndex = 1
      object PainelCompRelTopo: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object CaixaSelecaoTodosRel: TCheckBox
          Left = 10
          Top = 10
          Width = 150
          Height = 17
          Anchors = [akLeft, akTop]
          Caption = 'Selecionar Todos'
          TabOrder = 0
        end
      end
      object ListaCompRelatorios: TListBox
        Left = 0
        Top = 40
        Width = 792
        Height = 378
        Align = alClient
        ItemHeight = 15
        MultiSelect = True
        TabOrder = 1
      end
      object PainelCompRelBotoes: TPanel
        Left = 0
        Top = 418
        Width = 792
        Height = 30
        Align = alBottom
        TabOrder = 2
        object BotaoExportarRelatorios: TButton
          Left = 10
          Top = 2
          Width = 150
          Height = 25
          Anchors = [akLeft, akTop]
          Caption = 'Exportar Selecionados'
          TabOrder = 0
        end
      end
    end
    object AbaCompAssociacoes: TTabSheet
      Caption = 'Planilhas com Relat'#243'rios'
      ImageIndex = 2
      object PainelCompAssocTopo: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object CaixaSelecaoTodasAssoc: TCheckBox
          Left = 10
          Top = 10
          Width = 150
          Height = 17
          Anchors = [akLeft, akTop]
          Caption = 'Selecionar Todas'
          TabOrder = 0
        end
      end
      object ListaCompAssociacoes: TListBox
        Left = 0
        Top = 40
        Width = 792
        Height = 378
        Align = alClient
        ItemHeight = 15
        MultiSelect = True
        TabOrder = 1
      end
      object PainelCompAssocBotoes: TPanel
        Left = 0
        Top = 418
        Width = 792
        Height = 30
        Align = alBottom
        TabOrder = 2
        object BotaoExportarAssociacoes: TButton
          Left = 10
          Top = 2
          Width = 150
          Height = 25
          Anchors = [akLeft, akTop]
          Caption = 'Exportar Selecionadas'
          TabOrder = 0
        end
      end
    end
  end
  object PainelCompartilharRodape: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 1
    object BarraStatusCompartilhar: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end