program GridFlow;

uses
  Vcl.Forms,
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
  UViewModalTermos in 'src\view\UViewModalTermos.pas' {ViewModalTermos},
  UViewCompartilhamento in 'src\view\UViewCompartilhamento.pas' {ViewCompartilhamento},
  UViewGerenciadorDados in 'src\view\UViewGerenciadorDados.pas' {ViewGerenciadorDados},
  UViewEditorRelatorio in 'src\view\UViewEditorRelatorio.pas' {ViewEditorRelatorio},
  UViewEditorTabela in 'src\view\UViewEditorTabela.pas' {ViewEditorTabela},
  UViewPrincipal in 'src\view\UViewPrincipal.pas' {ViewPrincipal},
  UViewLogin in 'src\view\UViewLogin.pas' {ViewLogin},
  UViewVisualizadorRelatorio in 'src\view\UViewVisualizadorRelatorio.pas' {ViewVisualizadorRelatorio},
  UShowViewController in 'src\controller\UShowViewController.pas',
  UTabelaDTO in 'src\model\UTabelaDTO.pas',
  UEditorTabelaController in 'src\controller\UEditorTabelaController.pas',
  UEditarTabelaService in 'src\service\UEditarTabelaService.pas',
  UXMLService in 'src\service\UXMLService.pas',
  UTransformadorService in 'src\service\UTransformadorService.pas',
  UAbrirArquivoExternoService in 'src\service\UAbrirArquivoExternoService.pas',
  UTabelasRelatoriosDTO in 'src\model\UTabelasRelatoriosDTO.pas',
  UCriadorRelatorioController in 'src\controller\UCriadorRelatorioController.pas',
  UCSVService in 'src\service\UCSVService.pas',
  UCriadorTabelaController in 'src\controller\UCriadorTabelaController.pas',
  UPDFService in 'src\service\UPDFService.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  TViewController.Instance.IniciarAplicacao;

  Application.Run;

  TViewController.FreeInstance;
end.
