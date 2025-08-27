program CRUDMaker;

uses
  Vcl.Forms,
  GridFlow in 'src\view\GridFlow.pas',
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
  UAppConstants in 'src\utils\UAppConstants.pas',
  UAppUtils in 'src\utils\UAppUtils.pas',
  UServerPinger in 'src\utils\UServerPinger.pas',
  UViewModalTermos in 'src\view\UViewModalTermos.pas',
  UViewCompartilhamento in 'src\view\UViewCompartilhamento.pas',
  UViewGerenciadorDados in 'src\view\UViewGerenciadorDados.pas',
  UViewEditorRelatorio in 'src\view\UViewEditorRelatorio.pas',
  UViewEditorPlanilha in 'src\view\UViewEditorPlanilha.pas',
  UViewPrincipal in 'src\view\UViewPrincipal.pas',
  UViewLogin in 'src\view\UViewLogin.pas',
  UViewVisualizadorRelatorio in 'src\view\UViewVisualizadorRelatorio.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFGridFlow, FGridFlow);
  Application.CreateForm(TViewModalTermos, ViewModalTermos);
  Application.CreateForm(TViewCompartilhamento, ViewCompartilhamento);
  Application.CreateForm(TViewLogin, ViewLogin);
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.CreateForm(TViewEditorPlanilha, ViewEditorPlanilha);
  Application.CreateForm(TViewEditorRelatorio, ViewEditorRelatorio);
  Application.CreateForm(TViewGerenciadorDados, ViewGerenciadorDados);
  Application.CreateForm(TViewVisualizadorRelatorio, ViewVisualizadorRelatorio);
  Application.Run;
end.
