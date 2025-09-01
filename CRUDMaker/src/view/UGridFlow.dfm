object FGridFlow: TFGridFlow
  Left = 0
  Top = 0
  Caption = 'GridFlow'
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
  object MainMenu1: TMainMenu
    Left = 24
    Top = 16
    object Arquivo1: TMenuItem
      Caption = '&Arquivo'
      object Novo1: TMenuItem
        Caption = '&Novo'
      end
      object Abrir1: TMenuItem
        Caption = '&Abrir'
      end
      object Salvar1: TMenuItem
        Caption = '&Salvar'
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Sair1: TMenuItem
        Caption = 'Sai&r'
      end
    end
    object Editar1: TMenuItem
      Caption = '&Editar'
    end
    object Exibir1: TMenuItem
      Caption = 'E&xibir'
    end
    object Ferramentas1: TMenuItem
      Caption = '&Ferramentas'
    end
    object Ajuda1: TMenuItem
      Caption = '&Ajuda'
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 478
    Width = 800
    Height = 22
    Panels = <>
    SimplePanel = True
  end
end