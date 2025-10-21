object ViewConfigurarTabela: TViewConfigurarTabela
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Configurar Tabela'
  ClientHeight = 200
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object LabelInstrucoes: TLabel
    Left = 8
    Top = 8
    Width = 171
    Height = 13
    Caption = 'Defina as dimens'#245'es e o cabe'#231'alho:'
  end
  object LabelLinhas: TLabel
    Left = 24
    Top = 40
    Width = 30
    Height = 13
    Caption = 'Linhas'
  end
  object LabelColunas: TLabel
    Left = 24
    Top = 72
    Width = 38
    Height = 13
    Caption = 'Colunas'
  end
  object EditNumLinhas: TEdit
    Left = 80
    Top = 37
    Width = 121
    Height = 21
    TabOrder = 0
    Text = '10'
    OnChange = EditNumLinhasChange
  end
  object EditNumColunas: TEdit
    Left = 80
    Top = 69
    Width = 121
    Height = 21
    TabOrder = 1
    Text = '5'
    OnChange = EditNumColunasChange
  end
  object RadioGroupCabecalho: TRadioGroup
    Left = 224
    Top = 32
    Width = 161
    Height = 73
    Caption = 'Cabe'#231'alho'
    ItemIndex = 0
    Items.Strings = (
      'Primeira Linha'
      'Primeira Coluna')
    TabOrder = 2
  end
  object PainelBotoes: TPanel
    Left = 0
    Top = 169
    Width = 400
    Height = 31
    Align = alBottom
    TabOrder = 3
    object BotaoAvancar: TButton
      Left = 159
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Avan'#231'ar'
      TabOrder = 0
      OnClick = BotaoAvancarClick
    end
    object BotaoVoltar: TButton
      Left = 237
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Voltar'
      TabOrder = 1
      OnClick = BotaoVoltarClick
    end
    object BotaoCancelar: TButton
      Left = 318
      Top = 3
      Width = 75
      Height = 25
      Caption = '&Cancelar'
      TabOrder = 2
      OnClick = BotaoCancelarClick
    end
  end
end
