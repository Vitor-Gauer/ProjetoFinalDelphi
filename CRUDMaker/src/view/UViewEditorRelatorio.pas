unit UViewEditorRelatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TViewEditorRelatorio = class(TForm)
    PanelRelatorioTop: TPanel;
    LabelTituloRelatorio: TLabel;
    LabelTipoRelatorio: TLabel;
    EditTituloRelatorio: TEdit;
    ComboBoxTipoRelatorio: TComboBox;
    ButtonSalvarRelatorio: TButton;
    MemoConfiguracaoRelatorio: TMemo;
    PanelRelatorioBottom: TPanel;
    StatusBarRelatorio: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ViewEditorRelatorio: TViewEditorRelatorio;

implementation

{$R *.dfm}

end.