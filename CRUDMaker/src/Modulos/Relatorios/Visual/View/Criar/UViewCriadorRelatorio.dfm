object ViewCriadorRelatorio: TViewCriadorRelatorio
  Left = 0
  Top = 0
  Caption = 'Criar Relat'#243'rio'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object PainelTopo: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 80
    Align = alTop
    TabOrder = 0
    object RotuloTitulo: TLabel
      Left = 16
      Top = 16
      Width = 34
      Height = 15
      Caption = 'T'#237'tulo:'
    end
    object RotuloTipo: TLabel
      Left = 16
      Top = 48
      Width = 27
      Height = 15
      Caption = 'Tipo:'
    end
    object EditarTitulo: TEdit
      Left = 56
      Top = 13
      Width = 720
      Height = 23
      TabOrder = 0
    end
    object ComboBoxTipo: TComboBox
      Left = 56
      Top = 45
      Width = 200
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      OnChange = ComboBoxTipoChange
    end
  end
  object PainelCentro: TPanel
    Left = 0
    Top = 80
    Width = 800
    Height = 440
    Align = alClient
    TabOrder = 1
    object PainelConfigResumo: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 438
      Align = alClient
      TabOrder = 0
      Visible = False
      object RotuloCamposAgregacao: TLabel
        Left = 16
        Top = 16
        Width = 133
        Height = 15
        Caption = 'Campos para Agrega'#231#227'o:'
      end
      object RotuloTipoAgregacao: TLabel
        Left = 16
        Top = 56
        Width = 103
        Height = 15
        Caption = 'Tipo de Agrega'#231#227'o:'
      end
      object RotuloCamposAgrupamento: TLabel
        Left = 16
        Top = 96
        Width = 150
        Height = 15
        Caption = 'Campos para Agrupamento:'
      end
      object CheckListBoxCamposAgregacao: TCheckListBox
        Left = 160
        Top = 16
        Width = 200
        Height = 60
        ItemHeight = 15
        TabOrder = 0
      end
      object ComboBoxTipoAgregacao: TComboBox
        Left = 160
        Top = 53
        Width = 145
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = 'Soma'
        Items.Strings = (
          'Soma'
          'M'#233'dia'
          'Contar'
          'M'#237'nimo'
          'M'#225'ximo')
      end
      object CheckListBoxCamposAgrupamento: TCheckListBox
        Left = 160
        Top = 96
        Width = 200
        Height = 60
        ItemHeight = 15
        TabOrder = 2
      end
    end
    object PainelConfigEventos: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 438
      Align = alClient
      TabOrder = 1
      Visible = False
      object RotuloCamposFiltro: TLabel
        Left = 16
        Top = 16
        Width = 103
        Height = 15
        Caption = 'Campos para Filtro:'
      end
      object RotuloCriteriosFiltro: TLabel
        Left = 16
        Top = 56
        Width = 93
        Height = 15
        Caption = 'Crit'#233'rios de Filtro:'
      end
      object RotuloCamposOrdenacao: TLabel
        Left = 16
        Top = 96
        Width = 134
        Height = 15
        Caption = 'Campos para Ordena'#231#227'o:'
      end
      object CheckListBoxCamposFiltro: TCheckListBox
        Left = 160
        Top = 16
        Width = 200
        Height = 20
        ItemHeight = 15
        TabOrder = 0
      end
      object EditCriteriosFiltro: TEdit
        Left = 160
        Top = 53
        Width = 200
        Height = 23
        TabOrder = 1
        TextHint = 'Ex: >100, ='#39'Ativo'#39', LIKE '#39'%abc%'#39
      end
      object CheckListBoxCamposOrdenacao: TCheckListBox
        Left = 160
        Top = 96
        Width = 200
        Height = 20
        ItemHeight = 15
        TabOrder = 2
      end
      object ComboBoxTipoOrdenacao: TComboBox
        Left = 160
        Top = 120
        Width = 145
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'Crescente'
        Items.Strings = (
          'Crescente'
          'Decrescente')
      end
    end
    object PainelConfigClassificacao: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 438
      Align = alClient
      TabOrder = 2
      Visible = False
      object RotuloCamposOrdenacaoClassificacao: TLabel
        Left = 16
        Top = 16
        Width = 134
        Height = 15
        Caption = 'Campos para Ordena'#231#227'o:'
      end
      object RotuloTopN: TLabel
        Left = 16
        Top = 56
        Width = 35
        Height = 15
        Caption = 'Top N:'
      end
      object CheckListBoxCamposOrdenacaoClassificacao: TCheckListBox
        Left = 160
        Top = 16
        Width = 200
        Height = 20
        ItemHeight = 15
        TabOrder = 0
      end
      object ComboBoxTipoOrdenacaoClassificacao: TComboBox
        Left = 160
        Top = 40
        Width = 145
        Height = 23
        Style = csDropDownList
        ItemIndex = 1
        TabOrder = 1
        Text = 'Decrescente'
        Items.Strings = (
          'Crescente'
          'Decrescente')
      end
      object EditTopN: TEdit
        Left = 160
        Top = 53
        Width = 50
        Height = 23
        NumbersOnly = True
        TabOrder = 2
        Text = '10'
      end
    end
    object PainelConfigExcecao: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 438
      Align = alClient
      TabOrder = 3
      Visible = False
      object RotuloCamposFiltroExcecao: TLabel
        Left = 16
        Top = 16
        Width = 103
        Height = 15
        Caption = 'Campos para Filtro:'
      end
      object RotuloCriteriosFiltroExcecao: TLabel
        Left = 16
        Top = 56
        Width = 93
        Height = 15
        Caption = 'Crit'#233'rios de Filtro:'
      end
      object CheckListBoxCamposFiltroExcecao: TCheckListBox
        Left = 160
        Top = 16
        Width = 200
        Height = 20
        ItemHeight = 15
        TabOrder = 0
      end
      object EditCriteriosFiltroExcecao: TEdit
        Left = 160
        Top = 53
        Width = 200
        Height = 23
        TabOrder = 1
        TextHint = 'Ex: >20, <3, ='#39'Sim'#39
      end
    end
    object PainelConfigAnaliseTendencia: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 438
      Align = alClient
      TabOrder = 4
      Visible = False
      object RotuloColunaPeriodo: TLabel
        Left = 16
        Top = 16
        Width = 101
        Height = 15
        Caption = 'Coluna de Per'#237'odo:'
      end
      object RotuloColunaValor: TLabel
        Left = 16
        Top = 56
        Width = 86
        Height = 15
        Caption = 'Coluna de Valor:'
      end
      object RotuloTipoComparacao: TLabel
        Left = 16
        Top = 96
        Width = 114
        Height = 15
        Caption = 'Tipo de Compara'#231#227'o:'
      end
      object ComboBoxColunaPeriodo: TComboBox
        Left = 160
        Top = 13
        Width = 200
        Height = 23
        Style = csDropDownList
        TabOrder = 0
      end
      object ComboBoxColunaValor: TComboBox
        Left = 160
        Top = 53
        Width = 200
        Height = 23
        Style = csDropDownList
        TabOrder = 1
      end
      object ComboBoxTipoComparacao: TComboBox
        Left = 160
        Top = 93
        Width = 145
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 2
        Text = 'M'#234's a M'#234's'
        Items.Strings = (
          'M'#234's a M'#234's'
          'Ano a Ano'
          'Varia'#231#227'o Percentual')
      end
    end
    object PainelConfigPivotamento: TPanel
      Left = 1
      Top = 1
      Width = 798
      Height = 438
      Align = alClient
      TabOrder = 5
      Visible = False
      object RotuloColunaLinhas: TLabel
        Left = 16
        Top = 16
        Width = 104
        Height = 15
        Caption = 'Coluna para Linhas:'
      end
      object RotuloColunaColunas: TLabel
        Left = 16
        Top = 56
        Width = 113
        Height = 15
        Caption = 'Coluna para Colunas:'
      end
      object RotuloColunaValores: TLabel
        Left = 16
        Top = 96
        Width = 107
        Height = 15
        Caption = 'Coluna para Valores:'
      end
      object RotuloTipoAgregacaoPivot: TLabel
        Left = 16
        Top = 136
        Width = 133
        Height = 15
        Caption = 'Tipo de Agrega'#231#227'o Pivot:'
      end
      object ComboBoxColunaLinhas: TComboBox
        Left = 160
        Top = 13
        Width = 200
        Height = 23
        Style = csDropDownList
        TabOrder = 0
      end
      object ComboBoxColunaColunas: TComboBox
        Left = 160
        Top = 53
        Width = 200
        Height = 23
        Style = csDropDownList
        TabOrder = 1
      end
      object ComboBoxColunaValores: TComboBox
        Left = 160
        Top = 93
        Width = 200
        Height = 23
        Style = csDropDownList
        TabOrder = 2
      end
      object ComboBoxTipoAgregacaoPivot: TComboBox
        Left = 160
        Top = 133
        Width = 145
        Height = 23
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'Soma'
        Items.Strings = (
          'Soma'
          'M'#233'dia'
          'Contar'
          'M'#237'nimo'
          'M'#225'ximo')
      end
    end
  end
  object PainelRodape: TPanel
    Left = 0
    Top = 520
    Width = 800
    Height = 80
    Align = alBottom
    TabOrder = 2
    object BotaoSalvar: TButton
      Left = 240
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Salvar'
      TabOrder = 0
      OnClick = BotaoSalvarClick
    end
    object BotaoCancelar: TButton
      Left = 400
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = BotaoCancelarClick
    end
  end
end
