object ViewPrincipal: TViewPrincipal
  Left = 0
  Top = 0
  Caption = 'GridFlow - Principal'
  ClientHeight = 550
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 60
    Align = alTop
    TabOrder = 0
    object LabelBemVindo: TLabel
      Left = 10
      Top = 20
      Width = 100
      Height = 15
      Caption = 'Bem-vindo, Usu'#225'rio!'
    end
    object ButtonLogout: TButton
      Left = 790
      Top = 15
      Width = 100
      Height = 30
      Caption = 'Sair'
      TabOrder = 0
    end
  end
  object PageControlMain: TPageControl
    Left = 0
    Top = 60
    Width = 900
    Height = 468
    ActivePage = TabSheetPlanilhas
    Align = alClient
    TabOrder = 1
    object TabSheetPlanilhas: TTabSheet
      Caption = 'Planilhas'
      object Splitter1: TSplitter
        Left = 200
        Top = 0
        Height = 437
        ExplicitLeft = 248
        ExplicitTop = 88
        ExplicitHeight = 100
      end
      object PanelPlanilhasEsquerda: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 437
        Align = alLeft
        TabOrder = 0
        object ListBoxPlanilhas: TListBox
          Left = 1
          Top = 1
          Width = 198
          Height = 435
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object PanelPlanilhasDireita: TPanel
        Left = 203
        Top = 0
        Width = 689
        Height = 437
        Align = alClient
        TabOrder = 1
        object DBGridPlanilha: TDBGrid
          Left = 1
          Top = 1
          Width = 687
          Height = 405
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
        end
        object PanelPlanilhaBotoes: TPanel
          Left = 1
          Top = 406
          Width = 687
          Height = 30
          Align = alBottom
          TabOrder = 1
          object ButtonEditarPlanilha: TButton
            Left = 10
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Editar'
            TabOrder = 0
          end
          object ButtonExcluirPlanilha: TButton
            Left = 120
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
          end
          object ButtonNovoRelatorioPlanilha: TButton
            Left = 230
            Top = 2
            Width = 150
            Height = 25
            Caption = 'Criar Relat'#243'rio'
            TabOrder = 2
          end
        end
      end
    end
    object TabSheetRelatorios: TTabSheet
      Caption = 'Relat'#243'rios'
      ImageIndex = 1
      object Splitter2: TSplitter
        Left = 200
        Top = 0
        Height = 437
        ExplicitLeft = 280
        ExplicitTop = 168
        ExplicitHeight = 100
      end
      object PanelRelatoriosEsquerda: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 437
        Align = alLeft
        TabOrder = 0
        object ListBoxRelatorios: TListBox
          Left = 1
          Top = 1
          Width = 198
          Height = 435
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object PanelRelatoriosDireita: TPanel
        Left = 203
        Top = 0
        Width = 689
        Height = 437
        Align = alClient
        TabOrder = 1
        object MemoVisualizadorRelatorio: TMemo
          Left = 1
          Top = 1
          Width = 687
          Height = 405
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object PanelRelatorioBotoes: TPanel
          Left = 1
          Top = 406
          Width = 687
          Height = 30
          Align = alBottom
          TabOrder = 1
          object ButtonEditarRelatorio: TButton
            Left = 10
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Editar'
            TabOrder = 0
          end
          object ButtonExcluirRelatorio: TButton
            Left = 120
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
          end
          object ButtonVisualizarRelatorio: TButton
            Left = 230
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Visualizar'
            TabOrder = 2
          end
        end
      end
    end
    object TabSheetAssociacoes: TTabSheet
      Caption = 'Planilhas & Relat'#243'rios'
      ImageIndex = 2
      object DBGridAssociacoes: TDBGrid
        Left = 0
        Top = 0
        Width = 892
        Height = 437
        Align = alClient
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
  end
  object StatusBarPrincipal: TStatusBar
    Left = 0
    Top = 528
    Width = 900
    Height = 22
    Panels = <>
    SimplePanel = True
  end
end