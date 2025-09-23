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
  object PainelTopo: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 60
    Align = alTop
    TabOrder = 1
    object RotuloBemVindo: TLabel
      Left = 10
      Top = 20
      Width = 108
      Height = 15
      Caption = 'Bem-vindo, Usu'#225'rio!'
    end
  end
  object ControleAbasPrincipal: TPageControl
    Left = 0
    Top = 60
    Width = 900
    Height = 468
    ActivePage = AbaPlanilhas
    Align = alClient
    TabOrder = 0
    object AbaPlanilhas: TTabSheet
      Caption = 'Planilhas'
      object Divisor1: TSplitter
        Left = 200
        Top = 0
        Height = 438
        ExplicitHeight = 437
      end
      object PainelEsquerdoPlanilhas: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 438
        Align = alLeft
        TabOrder = 0
        object ListaPlanilhas: TListBox
          Left = 1
          Top = 1
          Width = 198
          Height = 436
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
          ExplicitLeft = 0
        end
      end
      object PainelDireitoTabelas: TPanel
        Left = 203
        Top = 0
        Width = 689
        Height = 438
        Align = alClient
        TabOrder = 1
        object GradeTabelas: TDBGrid
          Left = 1
          Top = 1
          Width = 687
          Height = 406
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = 'Segoe UI'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              Visible = True
            end>
        end
        object PainelBotoesTabela: TPanel
          Left = 1
          Top = 407
          Width = 687
          Height = 30
          Align = alBottom
          TabOrder = 1
          object BotaoEditarPlanilha: TButton
            Left = 10
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Editar'
            TabOrder = 0
            OnClick = BotaoEditarTabelaClick
          end
          object BotaoExcluirPlanilha: TButton
            Left = 120
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
            OnClick = BotaoExcluirPlanilhaClick
          end
          object BotaoCriarRelatorioPlanilha: TButton
            Left = 230
            Top = 2
            Width = 150
            Height = 25
            Caption = 'Criar Tabela'
            TabOrder = 2
            OnClick = BotaoCriarTabelaClick
          end
        end
      end
    end
    object AbaRelatorios: TTabSheet
      Caption = 'Relat'#243'rios'
      ImageIndex = 1
      object Divisor2: TSplitter
        Left = 200
        Top = 0
        Height = 438
        ExplicitHeight = 437
      end
      object PainelEsquerdoRelatorios: TPanel
        Left = 0
        Top = 0
        Width = 200
        Height = 438
        Align = alLeft
        TabOrder = 0
        object ListaRelatorios: TListBox
          Left = 1
          Top = 1
          Width = 198
          Height = 436
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object PainelDireitoRelatorios: TPanel
        Left = 203
        Top = 0
        Width = 689
        Height = 438
        Align = alClient
        TabOrder = 1
        object MemoVisualizadorRelatorio: TMemo
          Left = 1
          Top = 1
          Width = 687
          Height = 406
          Align = alClient
          ScrollBars = ssVertical
          TabOrder = 0
          ExplicitLeft = 2
        end
        object PainelBotoesRelatorio: TPanel
          Left = 1
          Top = 407
          Width = 687
          Height = 30
          Align = alBottom
          TabOrder = 1
          object BotaoEditarRelatorio: TButton
            Left = 10
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Editar'
            TabOrder = 0
            OnClick = BotaoEditarRelatorioClick
          end
          object BotaoExcluirRelatorio: TButton
            Left = 120
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
            OnClick = BotaoExcluirRelatorioClick
          end
          object BotaoVisualizarRelatorio: TButton
            Left = 230
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Visualizar'
            TabOrder = 2
            OnClick = BotaoVisualizarRelatorioClick
          end
          object BotaoCriarRelatorio: TButton
            Left = 340
            Top = 2
            Width = 150
            Height = 25
            Caption = 'Criar Relat'#243'rio'
            TabOrder = 3
          end
        end
      end
    end
    object AbaAssociacoes: TTabSheet
      Caption = 'TabelasRelat'#243'rios'
      ImageIndex = 2
      object GradeAssociacoes: TDBGrid
        Left = 0
        Top = 0
        Width = 892
        Height = 438
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
  object BarraStatusPrincipal: TStatusBar
    Left = 0
    Top = 528
    Width = 900
    Height = 22
    Panels = <>
    SimplePanel = True
  end
  object MainMenuPrincipal: TMainMenu
    Left = 696
    Top = 8
    object MenuItemArquivo: TMenuItem
      Caption = '&Arquivo'
      object MenuItemSair: TMenuItem
        Caption = 'Sai&r'
      end
    end
    object MenuItemFerramentas: TMenuItem
      Caption = '&Ferramentas'
      object MenuItemGerenciarDados: TMenuItem
        Caption = '&Gerenciar Dados'
      end
      object MenuItemCompartilhar: TMenuItem
        Caption = '&Compartilhar'
      end
    end
    object MenuItemAjuda: TMenuItem
      Caption = '&Ajuda'
      object MenuItemSobre: TMenuItem
        Caption = '&Sobre'
      end
    end
  end
end
