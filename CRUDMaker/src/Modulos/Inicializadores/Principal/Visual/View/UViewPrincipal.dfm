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
    StyleElements = [seFont, seClient]
    object AbaPlanilhas: TTabSheet
      BorderWidth = 10
      Caption = 'Planilhas'
      ParentShowHint = False
      ShowHint = False
      object DivisorPlanilha: TSplitter
        Left = 206
        Top = 0
        Height = 418
        Beveled = True
        Color = clBlack
        ParentColor = False
        ExplicitLeft = 209
        ExplicitTop = 3
        ExplicitHeight = 450
      end
      object PainelEsquerdoPlanilhas: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 200
        Height = 412
        Align = alLeft
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
        object ListaPlanilhas: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 190
          Height = 373
          Cursor = crArrow
          Align = alClient
          BevelInner = bvNone
          BevelOuter = bvNone
          ItemHeight = 15
          TabOrder = 0
          OnClick = ListaPlanilhasClick
          ExplicitLeft = 5
          ExplicitTop = 1
        end
        object PainelBotaoAtualizar: TPanel
          Left = 0
          Top = 379
          Width = 196
          Height = 29
          Align = alBottom
          BevelOuter = bvNone
          BiDiMode = bdLeftToRight
          BorderWidth = 1
          ParentBiDiMode = False
          TabOrder = 1
          OnClick = BotaoAtualizarPlanilhaClick
          object BotaoAtualizarPlanilhas: TButton
            Left = 50
            Top = 1
            Width = 100
            Height = 25
            Caption = 'Atualizar'
            TabOrder = 0
            OnClick = BotaoAtualizarPlanilhaClick
          end
        end
      end
      object PainelDireitoTabelas: TPanel
        AlignWithMargins = True
        Left = 212
        Top = 3
        Width = 657
        Height = 412
        Align = alClient
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 1
        object PainelBotoesTabela: TPanel
          Left = 0
          Top = 378
          Width = 653
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 0
          object BotaoEditarTabela: TButton
            Left = 10
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Editar'
            TabOrder = 0
            OnClick = BotaoEditarTabelaClick
          end
          object BotaoExcluir: TButton
            Left = 120
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
            OnClick = BotaoExcluirClick
          end
          object BotaoCriarPlanilha: TButton
            Left = 230
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Criar Planilha'
            TabOrder = 2
            OnClick = BotaoCriarPlanilhaClick
          end
          object BotaoCriarTabela: TButton
            Left = 340
            Top = 2
            Width = 100
            Height = 25
            Caption = 'Criar Tabela'
            TabOrder = 3
            OnClick = BotaoCriarTabelaClick
          end
        end
        object ListaTabelas: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 647
          Height = 372
          Align = alClient
          ItemHeight = 15
          TabOrder = 1
        end
      end
    end
    object AbaRelatorios: TTabSheet
      BorderWidth = 10
      Caption = 'Relat'#243'rios'
      ImageIndex = 1
      object DivisorRelatorio: TSplitter
        AlignWithMargins = True
        Left = 209
        Top = 3
        Height = 412
        ExplicitLeft = 200
        ExplicitTop = 0
        ExplicitHeight = 437
      end
      object PainelEsquerdoRelatorios: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 200
        Height = 412
        Align = alLeft
        BevelKind = bkTile
        BevelOuter = bvNone
        TabOrder = 0
        object ListaRelatorios: TListBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 190
          Height = 402
          Align = alClient
          ItemHeight = 15
          TabOrder = 0
        end
      end
      object PainelDireitoRelatorios: TPanel
        AlignWithMargins = True
        Left = 218
        Top = 3
        Width = 651
        Height = 412
        Align = alClient
        BevelKind = bkTile
        BevelOuter = bvNone
        TabOrder = 1
        object MemoVisualizadorRelatorio: TMemo
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 641
          Height = 372
          Align = alClient
          BevelKind = bkFlat
          BevelOuter = bvNone
          ScrollBars = ssVertical
          TabOrder = 0
        end
        object PainelBotoesRelatorio: TPanel
          Left = 0
          Top = 378
          Width = 647
          Height = 30
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 1
          object BotaoEditarRelatorio: TButton
            Left = 10
            Top = 1
            Width = 100
            Height = 25
            Caption = 'Editar'
            TabOrder = 0
            OnClick = BotaoEditarRelatorioClick
          end
          object BotaoExcluirRelatorio: TButton
            Left = 120
            Top = 1
            Width = 100
            Height = 25
            Caption = 'Excluir'
            TabOrder = 1
            OnClick = BotaoExcluirRelatorioClick
          end
          object BotaoVisualizarRelatorio: TButton
            Left = 230
            Top = 1
            Width = 100
            Height = 25
            Caption = 'Visualizar'
            TabOrder = 2
            OnClick = BotaoVisualizarRelatorioClick
          end
          object BotaoCriarRelatorio: TButton
            Left = 340
            Top = 1
            Width = 150
            Height = 25
            Caption = 'Criar Relat'#243'rio'
            TabOrder = 3
          end
        end
      end
    end
    object AbaAssociacoes: TTabSheet
      Caption = 'Associa'#231#245'es'
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
  object ClientDataSetTabelas: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 464
    Top = 8
  end
  object DataSourceTabelas: TDataSource
    DataSet = ClientDataSetTabelas
    Left = 584
    Top = 8
  end
  object MainMenuPrincipal: TMainMenu
    Left = 704
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
