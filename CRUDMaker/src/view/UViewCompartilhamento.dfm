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
  object PageControlCompartilhar: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 478
    ActivePage = TabSheetCompPlanilhas
    Align = alClient
    TabOrder = 0
    object TabSheetCompPlanilhas: TTabSheet
      Caption = 'Sele'#231#227'o de Planilha'
      object PanelCompPlanTop: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object CheckBoxSelecionarTodasPlan: TCheckBox
          Left = 10
          Top = 10
          Width = 150
          Height = 17
          Caption = 'Selecionar Todas'
          TabOrder = 0
        end
      end
      object ListBoxCompPlanilhas: TListBox
        Left = 0
        Top = 40
        Width = 792
        Height = 378
        Align = alClient
        ItemHeight = 15
        MultiSelect = True
        TabOrder = 1
      end
      object PanelCompPlanBotoes: TPanel
        Left = 0
        Top = 418
        Width = 792
        Height = 30
        Align = alBottom
        TabOrder = 2
        object ButtonExportarPlanilhas: TButton
          Left = 10
          Top = 2
          Width = 150
          Height = 25
          Caption = 'Exportar Selecionadas'
          TabOrder = 0
        end
      end
    end
    object TabSheetCompRelatorios: TTabSheet
      Caption = 'Sele'#231#227'o de Relat'#243'rio'
      ImageIndex = 1
      object PanelCompRelTop: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object CheckBoxSelecionarTodosRel: TCheckBox
          Left = 10
          Top = 10
          Width = 150
          Height = 17
          Caption = 'Selecionar Todos'
          TabOrder = 0
        end
      end
      object ListBoxCompRelatorios: TListBox
        Left = 0
        Top = 40
        Width = 792
        Height = 378
        Align = alClient
        ItemHeight = 15
        MultiSelect = True
        TabOrder = 1
      end
      object PanelCompRelBotoes: TPanel
        Left = 0
        Top = 418
        Width = 792
        Height = 30
        Align = alBottom
        TabOrder = 2
        object ButtonExportarRelatorios: TButton
          Left = 10
          Top = 2
          Width = 150
          Height = 25
          Caption = 'Exportar Selecionados'
          TabOrder = 0
        end
      end
    end
    object TabSheetCompAssociacoes: TTabSheet
      Caption = 'Planilhas com Relat'#243'rios'
      ImageIndex = 2
      object PanelCompAssocTop: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object CheckBoxSelecionarTodasAssoc: TCheckBox
          Left = 10
          Top = 10
          Width = 150
          Height = 17
          Caption = 'Selecionar Todas'
          TabOrder = 0
        end
      end
      object ListBoxCompAssociacoes: TListBox
        Left = 0
        Top = 40
        Width = 792
        Height = 378
        Align = alClient
        ItemHeight = 15
        MultiSelect = True
        TabOrder = 1
      end
      object PanelCompAssocBotoes: TPanel
        Left = 0
        Top = 418
        Width = 792
        Height = 30
        Align = alBottom
        TabOrder = 2
        object ButtonExportarAssociacoes: TButton
          Left = 10
          Top = 2
          Width = 150
          Height = 25
          Caption = 'Exportar Selecionadas'
          TabOrder = 0
        end
      end
    end
  end
  object PanelCompartilharBottom: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 1
    object StatusBarCompartilhar: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end
