program GridFlow;

uses
  Vcl.Forms,
  UConfigurarBD in 'src\Config\UConfigurarBD.pas',
  ULogBancoDados in 'src\Config\ULogBancoDados.pas',
  UConstantesGlobais in 'src\Utils\UConstantesGlobais.pas',
  UFuncoesGlobais in 'src\Utils\UFuncoesGlobais.pas',
  UServerPinger in 'src\Utils\Log\Conexão\UServerPinger.pas',
  UFormBaseMinTopoCentro in 'src\Utils\Views\UFormBaseMinTopoCentro.pas',
  USegurancaDadosHandler in 'src\Repo\Programa\USegurancaDadosHandler.pas',
  UDBConnection in 'src\Repo\BD\UDBConnection.pas',
  UPostgresDAO in 'src\Repo\BD\UPostgresDAO.pas',
  ULoginDTO in 'src\DTO\ULoginDTO.pas',
  UTabelaDTO in 'src\DTO\UTabelaDTO.pas',
  UPlanilhaDTO in 'src\DTO\UPlanilhaDTO.pas',
  URelatorioDTO in 'src\DTO\URelatorioDTO.pas',
  UTabelasRelatoriosDTO in 'src\DTO\UTabelasRelatoriosDTO.pas',
  UTabelaConfiguracaoDTO in 'src\DTO\UTabelaConfiguracaoDTO.pas',
  UAceiteTermoDTO in 'src\DTO\UAceiteTermoDTO.pas',
  ULogEntryDTO in 'src\DTO\ULogEntryDTO.pas',
  UPersistenciaLocalService in 'src\Modulos\Arquivos\Common\UPersistenciaLocalService.pas',
  UXMLService in 'src\Modulos\Arquivos\XML\UXMLService.pas',
  UCSVService in 'src\Modulos\Arquivos\CSV\UCSVService.pas',
  UPDFService in 'src\Modulos\Arquivos\PDF\UPDFService.pas',
  UEditarTabelaService in 'src\Modulos\Tabelas\Application\Service\UEditarTabelaService.pas',
  UPlanilhaService in 'src\Modulos\Planilhas\Application\Service\UPlanilhaService.pas',
  URelatorioService in 'src\Modulos\Relatorios\Application\Service\URelatorioService.pas',
  UAuthService in 'src\Modulos\Inicializadores\Login\Application\Service\UAuthService.pas',
  UShowViewService in 'src\Modulos\Navegadores\UShowViewService.pas',
  UCriadorRelatorioController in 'src\Modulos\Relatorios\Visual\Controller\UCriadorRelatorioController.pas',
  UViewLogin in 'src\Modulos\Inicializadores\Login\Visual\View\UViewLogin.pas' {ViewLogin},
  UViewModalTermos in 'src\Modulos\Inicializadores\Termos\Visual\View\UViewModalTermos.pas' {ViewModalTermos},
  UViewPrincipal in 'src\Modulos\Inicializadores\Principal\Visual\View\UViewPrincipal.pas' {ViewPrincipal},
  UPrincipalService in 'src\Modulos\Inicializadores\Principal\Application\Service\UPrincipalService.pas',
  UViewEditorTabela in 'src\Modulos\Tabelas\Application\Editar\UViewEditorTabela.pas' {ViewEditorTabela},
  UViewSalvarAssociacao in 'src\Modulos\Associações\Salvar\UViewSalvarAssociacao.pas' {ViewCompartilhamento},
  UViewEditorRelatorio in 'src\Modulos\Relatorios\Visual\View\Editar\UViewEditorRelatorio.pas' {ViewEditorRelatorio},
  UViewImprimirRelatorioPronto in 'src\Modulos\Relatorios\Visual\View\Imprimir\UViewImprimirRelatorioPronto.pas' {ViewVisualizadorRelatorio},
  UCriadorTabelaController in 'src\Modulos\Tabelas\Visual\Controller\Criar\UCriadorTabelaController.pas',
  UViewSelecionarPlanilhaParaTabela in 'src\Modulos\Tabelas\Visual\View\Criar\UViewSelecionarPlanilhaParaTabela.pas' {ViewSelecionarPlanilhaParaTabela},
  UViewConfigurarTabela in 'src\Modulos\Tabelas\Visual\View\Criar\UViewConfigurarTabela.pas' {ViewConfigurarTabela},
  UViewCriadorTabelaDados in 'src\Modulos\Tabelas\Visual\View\Criar\UViewCriadorTabelaDados.pas' {ViewCriadorTabelaDados},
  UEditorTabelaController in 'src\Modulos\Tabelas\Visual\Controller\Editar\UEditorTabelaController.pas',
  UPlanilhaController in 'src\Modulos\Planilhas\Visual\Controller\UPlanilhaController.pas',
  UInfoTabelaPlanilhaDTO in 'src\DTO\UInfoTabelaPlanilhaDTO.pas',
  UPrincipalController in 'src\Modulos\Inicializadores\Principal\Visual\Controller\UPrincipalController.pas';

{$R *.res}

begin
  Application.Initialize;
  TShowViewService.Instance.IniciarAplicacao;
  Application.Run;

  Application.MainFormOnTaskbar := True;
end.
