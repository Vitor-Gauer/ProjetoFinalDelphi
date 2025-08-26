program CRUDMaker;

uses
  Vcl.Forms,
  GridFlow in 'src\view\GridFlow.pas' {FGridFlow},
  ULoginDTO in 'src\model\ULoginDTO.pas',
  UUsuarioDTO in 'src\model\UUsuarioDTO.pas',
  UPlanilhaDTO in 'src\model\UPlanilhaDTO.pas',
  URelatorioDTO in 'src\model\URelatorioDTO.pas',
  ULogEntryDTO in 'src\model\ULogEntryDTO.pas',
  UAceiteTermoDTO in 'src\model\UAceiteTermoDTO.pas',
  UDBConnection in 'src\model\UDBConnection.pas',
  UPostgresDAO in 'src\model\UPostgresDAO.pas',
  UJSONDataHandler in 'src\model\UJSONDataHandler.pas',
  USecurityDataHandler in 'src\model\USecurityDataHandler.pas',
  UAuthService in 'src\service\UAuthService.pas',
  UPlanilhaService in 'src\service\UPlanilhaService.pas',
  URelatorioService in 'src\service\URelatorioService.pas',
  ULogService in 'src\service\ULogService.pas',
  UExportacaoService in 'src\service\UExportacaoService.pas',
  UConfigService in 'src\service\UConfigService.pas',
  UViewLogin in 'src\view\UViewLogin.pas',
  UViewPrincipal in 'src\view\UViewPrincipal.pas',
  UViewEditorPlanilha in 'src\view\UViewEditorPlanilha.pas',
  UViewEditorRelatorio in 'src\view\UViewEditorRelatorio.pas',
  UViewGerenciadorDados in 'src\view\UViewGerenciadorDados.pas',
  UViewCompartilhamento in 'src\view\UViewCompartilhamento.pas',
  UViewVisualizadorRelatorio in 'src\view\UViewVisualizadorRelatorio.pas',
  UViewModalTermos in 'src\view\UViewModalTermos.pas',
  UAppConstants in 'src\utils\UAppConstants.pas',
  Unit1 in 'src\utils\Unit1.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFGridFlow, FGridFlow);
  Application.Run;
end.
