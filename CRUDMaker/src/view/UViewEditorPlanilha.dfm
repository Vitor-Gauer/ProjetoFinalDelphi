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
  object PanelEditorTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 50
    Align = alTop
    TabOrder = 0
    object LabelTituloPlanilha: TLabel
      Left = 10
      Top = 15
      Width = 30
      Height = 15
      Caption = 'T'#237'tulo:'
    end
    object EditTituloPlanilha: TEdit
      Left = 50
      Top = 12
      Width = 300
      Height = 23
      TabOrder = 0
    end
    object ButtonSalvarPlanilha: TButton
      Left = 690
      Top = 10
      Width = 100
      Height = 30
      Caption = 'Salvar'
      TabOrder = 1
    end
  end
  object StringGridEditor: TStringGrid
    Left = 0
    Top = 50
    Width = 800
    Height = 428
    Align = alClient
    ColCount = 10
    FixedCols = 0
    RowCount = 20
    TabOrder = 1
  end
  object PanelEditorBottom: TPanel
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Align = alBottom
    TabOrder = 2
    object StatusBarEditor: TStatusBar
      Left = 1
      Top = 1
      Width = 798
      Height = 20
      Panels = <>
      SimplePanel = True
    end
  end
end