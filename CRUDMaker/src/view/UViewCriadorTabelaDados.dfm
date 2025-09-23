object ViewCriadorTabelaDados: TViewCriadorTabelaDados
  Left = 0
  Top = 0
  Caption = 'Criador de Tabela - Inserir Dados'
  ClientHeight = 500
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object PainelTopo: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 41
    Align = alTop
    TabOrder = 0
    object RotuloTitulo: TLabel
      Left = 8
      Top = 14
      Width = 39
      Height = 13
      Caption = 'T'#195#173'tulo:'
    end
    object EditarTitulo: TEdit
      Left = 44
      Top = 11
      Width = 250
      Height = 21
      TabOrder = 0
      Text = 'Nova Tabela'
    end
    object BotaoSalvar: TButton
      Left = 310
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Salvar'
      TabOrder = 1
      OnClick = BotaoSalvarClick
    end
    object BotaoCancelar: TButton
      Left = 400
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 2
      OnClick = BotaoCancelarClick
    end
  end
  object DBGridDados: TDBGrid
    Left = 0
    Top = 41
    Width = 800
    Height = 434
    Align = alClient
    DataSource = DataSourceDados
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnExit = DBGridDadosExit
    OnMouseMove = DBGridDadosMouseMove
  end
  object PainelRodape: TPanel
    Left = 0
    Top = 475
    Width = 800
    Height = 25
    Align = alBottom
    TabOrder = 2
    object BarraStatus: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 23
      Panels = <>
      SimplePanel = True
    end
  end
  object ClientDataSetDados: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 80
  end
  object DataSourceDados: TDataSource
    DataSet = ClientDataSetDados
    Left = 128
    Top = 80
  end
end
