object ViewEditorPlanilha: TViewEditorPlanilha
  Left = 0
  Top = 0
  Caption = 'Editar Planilha'
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
  object PainelEditorTopo: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    TabOrder = 0
    object RotuloTituloPlanilha: TLabel
      Left = 10
      Top = 15
      Width = 34
      Height = 15
      Caption = 'T'#237'tulo:'
    end
    object EditarTituloPlanilha: TEdit
      Left = 50
      Top = 12
      Width = 300
      Height = 23
      TabOrder = 0
    end
    object BotaoSalvarPlanilha: TButton
      Left = 580
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Salvar'
      TabOrder = 1
    end
    object BotaoCancelarPlanilha: TButton
      Left = 690
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Cancelar'
      TabOrder = 2
    end
  end
  object GradeEditor: TStringGrid
    Left = 0
    Top = 50
    Width = 800
    Height = 428
    Align = alClient
    ColCount = 10
    FixedCols = 0
    RowCount = 20
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goEditing]
    TabOrder = 1
  end
  object PainelEditorRodape: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 2
    object BarraStatusEditor: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end
