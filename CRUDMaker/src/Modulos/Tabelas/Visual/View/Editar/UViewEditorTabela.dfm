object ViewEditorTabela: TViewEditorTabela
  Left = 0
  Top = 0
  Caption = 'Editar Tabela'
  ClientHeight = 538
  ClientWidth = 801
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object PainelEditorTopo: TPanel
    Left = 0
    Top = 0
    Width = 801
    Height = 38
    Align = alTop
    TabOrder = 0
    DesignSize = (
      801
      38)
    object RotuloTituloTabela: TLabel
      Left = 5
      Top = 10
      Width = 34
      Height = 15
      Caption = 'T'#237'tulo:'
    end
    object RotuloTituloPlanilha: TLabel
      Left = 280
      Top = 10
      Width = 45
      Height = 15
      Caption = 'Planilha:'
    end
    object EditarTituloTabela: TEdit
      Left = 45
      Top = 7
      Width = 230
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 0
    end
    object BotaoSalvarTabela: TButton
      AlignWithMargins = True
      Left = 580
      Top = 4
      Width = 98
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Salvar'
      TabOrder = 1
      OnClick = BotaoSalvarClick
    end
    object BotaoSairTabela: TButton
      AlignWithMargins = True
      Left = 690
      Top = 4
      Width = 100
      Height = 30
      Anchors = [akTop, akRight]
      Caption = 'Sair'
      TabOrder = 2
      OnClick = BotaoSairClick
    end
    object EditarTituloPlanilha: TEdit
      Left = 330
      Top = 7
      Width = 230
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      Enabled = False
      TabOrder = 3
    end
  end
  object DBGridEditor: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 41
    Width = 795
    Height = 472
    Align = alClient
    DataSource = DataSourceEditor
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnExit = DBGridEditorExit
    OnMouseMove = DBGridEditorMouseMove
  end
  object PainelEditorRodape: TPanel
    Left = 0
    Top = 516
    Width = 801
    Height = 22
    Align = alBottom
    TabOrder = 2
    object BarraStatusEditor: TStatusBar
      Left = 1
      Top = 1
      Width = 799
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
  object ClientDataSetEditor: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 560
    Top = 160
  end
  object DataSourceEditor: TDataSource
    DataSet = ClientDataSetEditor
    Left = 600
    Top = 160
  end
end
