object ViewGerenciadorDados: TViewGerenciadorDados
  Left = 0
  Top = 0
  Caption = 'Gerenciar Dados'
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
  object ControleAbasGerenciador: TPageControl
    Left = 0
    Top = 0
    Width = 800
    Height = 478
    ActivePage = AbaGerPlanilhas
    Align = alClient
    TabOrder = 0
    object AbaGerPlanilhas: TTabSheet
      Caption = 'Planilhas'
      object PainelGerPlanilhasTopo: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object BotaoNovaPlanilha: TButton
          Left = 10
          Top = 5
          Width = 120
          Height = 30
          Anchors = [akLeft, akTop]
          Caption = 'Nova Planilha'
          TabOrder = 0
        end
      end
      object GradeGerPlanilhas: TDBGrid
        Left = 0
        Top = 40
        Width = 792
        Height = 408
        Align = alClient
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object AbaGerRelatorios: TTabSheet
      Caption = 'Relat'#243'rios'
      ImageIndex = 1
      object PainelGerRelatoriosTopo: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object BotaoNovoRelatorio: TButton
          Left = 10
          Top = 5
          Width = 120
          Height = 30
          Anchors = [akLeft, akTop]
          Caption = 'Novo Relat'#243'rio'
          TabOrder = 0
        end
      end
      object GradeGerRelatorios: TDBGrid
        Left = 0
        Top = 40
        Width = 792
        Height = 408
        Align = alClient
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
    object AbaGerAssociacoes: TTabSheet
      Caption = 'Associa'#231#245'es'
      ImageIndex = 2
      object PainelGerAssociacoesTopo: TPanel
        Left = 0
        Top = 0
        Width = 792
        Height = 40
        Align = alTop
        TabOrder = 0
        object BotaoNovaAssociacao: TButton
          Left = 10
          Top = 5
          Width = 150
          Height = 30
          Anchors = [akLeft, akTop]
          Caption = 'Nova Associa'#231#227'o'
          TabOrder = 0
        end
      end
      object GradeGerAssociacoes: TDBGrid
        Left = 0
        Top = 40
        Width = 792
        Height = 408
        Align = alClient
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
      end
    end
  end
  object PainelGerenciadorRodape: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 1
    object BarraStatusGerenciador: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end