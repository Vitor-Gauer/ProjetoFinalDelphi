## Documentação: Implementação de Relatórios e Associações

### Novos arquivos:

*   `URelatorioConfiguracaoDTO.pas`: DTO para representar estruturalmente a configuração de um relatório (tipo, linhas, colunas, escopos, extras).
*   `TRelatorioService.pas`: Serviço com lógica de interpretação de configuração e coordenação com Fast Reports.
*   `TAssociacaoService.pas`: Serviço dedicado ao CRUD de associações (tabela <-> relatório).
*   `TAssociacaoController.pas`: Controller com lógica de negócio para associações.
*   `TViewCriadorAssociacao.dfm/pas`: View para criar associações (escolher relatório, definir local de PDF).
*   `TViewEditorAssociacao.dfm/pas`: View para editar associações (escolher entre editar tabela ou relatório associado).
*   `TViewCriadorRelatorio.dfm/pas`: View para criar/editar a *configuração* de um relatório (tipos, colunas, escopos).

### Arquivos atualizados:

*   `UPersistenciaLocalService.pas`: Adição de métodos generalizados para caminhos (`CaminhodeTabela`, `CaminhodePlanilha`, `CaminhodeRelatorio`, `CaminhodeAssociacao`).
*   `UXMLService.pas`: Adição de métodos para ler/escrever *apenas* a tag `<Relatorio>` em arquivos dedicados.
*   `UPDFService.pas`: Atualização para integrar com `TRelatorioService` na geração do PDF.
*   `TShowViewService.pas`: Adição de métodos para navegar para as novas views de relatório e associação.
*   `URelatorioDTO.pas`: Adição do campo `ConfiguracaoString: string`.
*   `UCriadorRelatorioController.pas`: Atualização para usar os novos serviços e persistência.
*   `TViewEditorRelatorio.pas`: Atualização para carregar/editar a configuração do relatório a partir do arquivo dedicado.
*   `TViewImprimirRelatorioPronto.pas`: Atualização para carregar dados da tabela e aplicar a configuração do relatório (via associação) para gerar o PDF.

### Métodos (separados por arquivo):

**UPersistenciaLocalService.pas:**

*   `CaminhodeTabela(const APlanilhaNome, ATabelaNome: string; ABackup: Boolean = False): string;`
    *   Explicação: Retorna o caminho para o diretório de uma tabela específica. Chamado no fluxo do CRUD de tabelas (ex: `TCriadorTabelaController.ExecutarCriarTabela` após formatação de nomes no controller).
*   `CaminhodePlanilha(const ANomePlanilha: string; ABackup: Boolean = False): string;`
    *   Explicação: Retorna o caminho para o diretório de uma planilha. Chamado por serviços que lidam com planilhas (ex: `TPlanilhaService.CriarNovaPlanilha`).
*   `CaminhodeRelatorio(const ANomeRelatorio: string; ABackup: Boolean = False): string;`
    *   Explicação: Retorna o caminho para o arquivo XML de configuração de um relatório. Chamado por `TRelatorioService` para carregar/salvar configurações.
*   `CaminhodeAssociacao(const APlanilhaNome, ANomeAssociacao: string; ABackup: Boolean = False): string;`
    *   Explicação: Retorna o caminho para o arquivo XML de associação. Chamado por `TAssociacaoService` para carregar/salvar vínculos.

**UXMLService.pas:**

*   `LerXMLConfiguraçãoRelatório(const ACaminhoArquivo: string): string;`
    *   Explicação: Lê e retorna a string contida na tag `<Relatorio>` de um arquivo XML dedicado. Chamado por `TRelatorioService.CarregarConfiguracaoRelatorio`.
*   `GravarXMLConfiguraçãoRelatório(const ACaminhoArquivo: string; const AConfiguracaoString: string): Boolean;`
    *   Explicação: Grava uma string como conteúdo da tag `<Relatorio>` em um arquivo XML dedicado. Chamado por `TRelatorioService.SalvarConfiguracaoRelatorio`.

**UPDFService.pas:**

*   `GerarPDF(const ATituloTabela: string; const ACaminhoDados: string; const AConfiguracaoString: string; const ACaminhoPDFSaida: string): Boolean;`
    *   Explicação: Recebe dados da tabela e a string de configuração do relatório, chama o `TRelatorioService` para processar e gera o PDF final. Chamado quando é necessário gerar o PDF do relatório (ex: após criação/edição de associação, ou visualização via `TViewImprimirRelatorioPronto`).

**TRelatorioService.pas:**

*   `CarregarConfiguracaoRelatorio(const ACaminhoArquivo: string): string;`
    *   Explicação: Lê a configuração do relatório do seu arquivo XML dedicado via `UXMLService`. Chamado ao iniciar a edição de um relatório ou ao gerar o PDF a partir de uma associação.
*   `SalvarConfiguracaoRelatorio(const ACaminhoArquivo: string; const AConfiguracaoString: string): Boolean;`
    *   Explicação: Salva a string de configuração no arquivo XML dedicado do relatório via `UXMLService`. Chamado após finalizar a criação ou edição da configuração de um relatório.
*   `ProcessarDadosParaFastReports(const ATituloTabela: string; const ACaminhoDados: string; const AConfiguracaoString: string): Boolean;`
    *   Explicação: Interpreta a string de configuração, carrega dados da tabela e prepara o ambiente para o Fast Reports. Chamado internamente por `UPDFService.GerarPDF`.

**TAssociacaoService.pas:**

*   `CriarAssociacao(const ANomeAssociacao, ATituloTabela, ANomeRelatorio: string; const ACaminhoPDFSaida: string): Boolean;`
    *   Explicação: Cria um vínculo entre uma tabela e um relatório, salvando a configuração do relatório no arquivo de associação e gerando o PDF. Chamado após o usuário definir os detalhes da associação em `TViewCriadorAssociacao`.
*   `EditarAssociacao(const ACaminhoArquivoAssociacao: string; AEditarTabelaOuRelatorio: Boolean): Boolean;`
    *   Explicação: Permite escolher entre editar a configuração da *tabela* ou do *relatório* associado. Chamado ao clicar em "Editar" em `TViewEditorAssociacao`.
*   `ExcluirAssociacao(const ACaminhoArquivoAssociacao: string): Boolean;`
    *   Explicação: Exclui o arquivo de associação (não o backup). Chamado ao confirmar exclusão em `TViewEditorAssociacao`.
*   `CarregarAssociacao(const ACaminhoArquivoAssociacao: string): TPair<string, string>; // Retorna (TituloTabela, NomeRelatorio)`
    *   Explicação: Carrega o título da tabela e o nome do relatório do arquivo de associação. Chamado ao carregar `TViewEditorAssociacao` ou `TViewImprimirRelatorioPronto`.

**TAssociacaoController.pas:**

*   `CriarNovaAssociacao(const ANomeAssociacao, ATituloTabela, ANomeRelatorio: string; const ACaminhoPDFSaida: string): Boolean;`
    *   Explicação: Coordena a criação da associação com o `TAssociacaoService`. Chamado ao confirmar a criação em `TViewCriadorAssociacao`.
*   `EditarAssociacaoExistente(const ACaminhoArquivo: string; AEditarTabelaOuRelatorio: Boolean): Boolean;`
    *   Explicação: Coordena a edição da associação com o `TAssociacaoService`. Chamado ao confirmar edição em `TViewEditorAssociacao`.
*   `ExcluirAssociacaoExistente(const ACaminhoArquivo: string): Boolean;`
    *   Explicação: Coordena a exclusão da associação com o `TAssociacaoService`. Chamado ao confirmar exclusão em `TViewEditorAssociacao`.

**TShowViewService.pas:**

*   `ShowViewCriadorRelatorio(const ATabelaBase: TTabelaDTO): Boolean;`
    *   Explicação: Abre a view `TViewCriadorRelatorio`. Chamado ao clicar em "Criar Relatório" na aba de relatórios, passando a tabela base.
*   `ShowViewEditorRelatorio(const ACaminhoArquivoRelatorio: string): Boolean;`
    *   Explicação: Abre a view `TViewEditorRelatorio` carregando a configuração do relatório. Chamado ao clicar em "Editar" na aba de relatórios.
*   `ShowViewCriadorAssociacao(const ATituloTabela, ANomeRelatorio: string): Boolean;`
    *   Explicação: Abre a view `TViewCriadorAssociacao`. Chamado ao clicar em "Criar Associação".
*   `ShowViewEditorAssociacao(const ACaminhoArquivoAssociacao: string): Boolean;`
    *   Explicação: Abre a view `TViewEditorAssociacao`. Chamado ao clicar em "Editar" em uma associação existente.
*   `ShowViewImprimirRelatorioPronto(const ACaminhoAssociacao: string): Boolean;`
    *   Explicação: Abre a view `TViewImprimirRelatorioPronto`. Chamado ao clicar em "Visualizar" na aba de relatórios ou ao abrir uma associação.

**TViewCriadorRelatorio.pas:**

*   `(Construtores/Eventos)`: Lógica de interface para definir a configuração do relatório (tipos, colunas, escopos). Acionado pelo fluxo de criação de relatório via `TShowViewService.ShowViewCriadorRelatorio`.

**TViewEditorRelatorio.pas:**

*   `(Construtores/Eventos)`: Lógica de interface para carregar e editar a configuração do relatório a partir do seu arquivo XML dedicado. Acionado pelo fluxo de edição de relatório via `TShowViewService.ShowViewEditorRelatorio`.

**TViewCriadorAssociacao.pas:**

*   `(Construtores/Eventos)`: Lógica de interface para selecionar relatório e local de salvamento do PDF. Acionado pelo fluxo de criação de associação via `TShowViewService.ShowViewCriadorAssociacao`.

**TViewEditorAssociacao.pas:**

*   `(Construtores/Eventos)`: Lógica de interface para escolher entre editar a tabela ou o relatório associado. Acionado pelo fluxo de edição de associação via `TShowViewService.ShowViewEditorAssociacao`.

**TViewImprimirRelatorioPronto.pas:**

*   `(Construtores/Eventos)`: Lógica de interface para carregar dados da tabela e aplicar a configuração do relatório (via associação) para gerar e exibir o PDF. Acionado ao clicar em "Visualizar" na aba de relatórios ou ao abrir uma associação via `TShowViewService.ShowViewImprimirRelatorioPronto`.