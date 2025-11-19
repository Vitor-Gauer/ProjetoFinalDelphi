# GridFlow - Sistema de Planilhas e Relatórios em Delphi 12

![GridFlow Logo](https://i.ibb.co/xSYp0NzB/LogoInv.png)

**GridFlow** é uma aplicação para criação, edição e gerenciamento de planilhas e relatórios. Desenvolvida em **Delphi 12 Community Edition**, utiliza **PostgreSQL** para dados públicos e arquivos **XML/CSV** locais para dados privados, oferecendo um modelo híbrido seguro e modular.

---

## 🔍 Funcionalidades Principais

✅ **Criação e edição de planilhas**  
Crie e edite planilhas com estrutura dinâmica (linhas e colunas) e salve os dados em arquivos XML e CSV com hash único para integridade.

🔐 **Autenticação com dois modos: público (via servidor) e privado (local)**  
- **Modo Público**: Conecta-se ao banco de dados PostgreSQL via servidor Docker, validando credenciais e limitando o número de planilhas.  
- **Modo Privado**: Opera offline, armazenando dados localmente em arquivos XML e CSV, ideal para demonstrações ou uso isolado.

📊 **Geração de relatórios** *(Em desenvolvimento)*  
*(Mantido para referência futura - a funcionalidade de geração de relatórios ainda não está implementada no código, mas é um objetivo do projeto.)*

🔄 **Exportação de dados**  
Exporte dados para formatos XML e CSV, com suporte à exportação de vínculos entre tabelas e relatórios futuros.

🛡️ **Segurança**  
Segurança com hashing de senhas (em desenvolvimento) e controle de acesso baseado em autenticação.

📂 **Armazenamento híbrido: PostgreSQL (público) e XML/CSV (privado)**  
- PostgreSQL: Para metadados (usuários, logs de atividade).  
- Arquivos locais: Dados das planilhas são persistidos em XML e CSV, garantindo privacidade e portabilidade.

---

## 🏗️ Estrutura do Projeto

```
src/
├── Config/               # Configurações de conexão e constantes
│   ├── UConfigurarBD.pas
│   └── ULogBancoDados.pas
│
├── DTO/                  # Data Transfer Objects (camada de dados)
│   ├── ULoginDTO.pas
│   ├── UUsuarioDTO.pas
│   ├── UPlanilhaDTO.pas
│   ├── URelatorioDTO.pas
│   ├── UTabelaDTO.pas
│   ├── UTabelasRelatoriosDTO.pas
│   ├── UAceiteTermoDTO.pas
│   └── ...
│
├── Modulos/
│   ├── Arquivos/
│   │   ├── Common/
│   │   │   └── UPersistenciaLocalService.pas
│   │   ├── CSV/
│   │   │   └── UCSVService.pas
│   │   ├── PDF/          # (Simulado - geração real ainda não integrada)
│   │   │   └── UPDFService.pas
│   │   └── XML/
│   │       └── UXMLService.pas
│   │
│   ├── Associacoes/
│   │   └── Salvar/
│   │       ├── UViewSalvarAssociacao.dfm
│   │       └── UViewSalvarAssociacao.pas
│   │
│   ├── Inicializadores/
│   │   ├── Login/
│   │   │   ├── Application/
│   │   │   │   ├── Service/
│   │   │   │   │   ├── UAuthService.pas
│   │   │   │   │   └── UViewLoginService.pas
│   │   │   │   └── Controller/
│   │   │   │       └── ULoginController.pas
│   │   │   └── View/
│   │   │       ├── UViewLogin.dfm
│   │   │       └── UViewLogin.pas
│   │   │
│   │   ├── Principal/
│   │   │   ├── Application/
│   │   │   │   └── Service/
│   │   │   │       └── UPrincipalService.pas
│   │   │   ├── Controller/
│   │   │   │   └── UPrincipalController.pas
│   │   │   └── View/
│   │   │       ├── UViewPrincipal.dfm
│   │   │       └── UViewPrincipal.pas
│   │   │
│   │   └── Termos/
│   │       └── View/
│   │           ├── UViewModalTermos.dfm
│   │           └── UViewModalTermos.pas
│   │
│   ├── Navegadores/
│   │   └── UShowViewService.pas
│   │
│   ├── Planilhas/
│   │   ├── Application/
│   │   │   ├── Service/
│   │   │   │   └── UPlanilhaService.pas
│   │   │   └── Controller/
│   │   │       └── UPlanilhaController.pas
│   │   └── Visual/
│   │       └── Controller/
│   │           └── UPlanilhaController.pas
│   │
│   ├── Relatorios/
│   │   ├── Application/
│   │   │   └── Service/
│   │   │       └── URelatorioService.pas
│   │   └── Visual/
│   │       ├── Controller/
│   │       │   └── UCriadorRelatorioController.pas
│   │       └── View/
│   │           ├── Editar/
│   │           │   ├── UViewEditorRelatorio.dfm
│   │           │   └── UViewEditorRelatorio.pas
│   │           └── Imprimir/
│   │               ├── UViewImprimirRelatorioPronto.dfm
│   │               └── UViewImprimirRelatorioPronto.pas
│   │
│   └── Tabelas/
│       ├── Application/
│       │   └── Service/
│       │       └── UEditarTabelaService.pas
│       ├── Controller/
│       │   ├── Criar/
│       │   │   └── UCriadorTabelaController.pas
│       │   └── Editar/
│       │       └── UEditorTabelaController.pas
│       └── View/
│           ├── Criar/
│           │   ├── UViewConfigurarTabela.dfm
│           │   ├── UViewCriadorTabelaDados.dfm
│           │   ├── UViewSelecionarPlanilhaParaTabela.dfm
│           │   ├── UViewConfigurarTabela.pas
│           │   ├── UViewCriadorTabelaDados.pas
│           │   └── UViewSelecionarPlanilhaParaTabela.pas
│           └── Editar/
│               ├── UViewEditorTabela.dfm
│               └── UViewEditorTabela.pas
│
├── Repo/
│   ├── BD/
│   │   ├── UDBConnection.pas
│   │   └── UPostgresDAO.pas
│   └── Programa/
│       ├── ULogService.pas
│       └── USegurancaDadosHandler.pas
│
└── Utils/
    ├── Log/
    │   └── Conexão/
    │       └── UServerPinger.pas
    ├── Views/
    │   └── UFormBaseMinTopoCentro.pas
    ├── UConstantesGlobais.pas
    └── UFuncoesGlobais.pas
```

---

## 🔐 Modos de Operação

### 🌐 Modo Público (Conectado ao Servidor)
- Conecta-se ao banco de dados **PostgreSQL** ***localmente***.
- Valida credenciais no servidor.
- Registra aceite de termos e logs de atividade no banco.
- Ideal para salvar dados por fora.

### 🖥️ Modo Privado (Offline)
- Dados armazenados localmente em arquivos **XML e CSV**.
- Nenhum limite de dados.
- Sem dependência de rede ou servidor.
- Ideal para uso local.

---

## 📁 Arquitetura de Dados

- **PostgreSQL**: Para dados públicos (usuários, logs de atividade).
- **XML/CSV**: Para dados das planilhas, garantindo portabilidade e controle total sobre os dados.
- **FireDAC**: Conexão segura e eficiente com PostgreSQL.
- **Hashing com Salt**: *(Em desenvolvimento)* Proteção de senhas em ambos os modos.

---

## 💬 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir *issues* ou enviar *pull requests*.

> **Documentação complementar**: Consulte o arquivo `Proposta.pdf` e o código-fonte para detalhes técnicos da implementação.
