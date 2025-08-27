# GridFlow - Sistema de Planilhas e Relatórios em Delphi 12

![Logo GridFlow](https://i.ibb.co/xSYp0NzB/LogoInv.png)

> **GridFlow** é uma aplicação para criação, edição e gerenciamento de planilhas e relatórios. Desenvolvida em **Delphi 12 Community Edition**, utiliza PostgreSQL para dados públicos e arquivos JSON locais para dados privados, oferecendo um modelo híbrido seguro e modular.

---

## 🚀 Funcionalidades Principais

- ✅ Criação e edição de planilhas e relatórios
- 🔐 Autenticação com dois modos: público (via servidor) e privado (local)
- 📊 Geração de relatórios analíticos, gráficos e de auditoria
- 🔄 Exportação de dados para JSON (para backup e compartilhamento)
- 🛡️ Segurança com hashing de senhas e controle de acesso
- 📂 Armazenamento híbrido: PostgreSQL (público) e JSON (privado)

---

## 🧩 Estrutura do Projeto

```
src/
├── model/              # DTOs e classes de dados
│   ├── ULoginDTO.pas
│   ├── UUsuarioDTO.pas
│   ├── UPlanilhaDTO.pas
│   ├── URelatorioDTO.pas
│   ├── ULogEntryDTO.pas
│   ├── UAceiteTermoDTO.pas
│   ├── UPostgresDAO.pas
│   ├── UDBConnection.pas
│   ├── UJSONDataHandler.pas
│   └── USecurityDataHandler.pas
│
├── service/            # Lógica de negócios
│   ├── UAuthService.pas
│   ├── UPlanilhaService.pas
│   ├── URelatorioService.pas
│   ├── ULogService.pas
│   ├── UExportacaoService.pas
│   └── UConfigService.pas
│
├── utils/              # Funções utilitárias
│   ├── UAppConstants.pas
│   ├── UAppUtils.pas
│   └── UServerPinger.pas
│
└── view/               # Interfaces do usuário
    ├── UGridFlow.pas
    ├── UViewLogin.pas
    ├── UViewPrincipal.pas
    ├── UViewEditorPlanilha.pas
    ├── UViewEditorRelatorio.pas
    ├── UViewGerenciadorDados.pas
    ├── UViewCompartilhamento.pas
    ├── UViewVisualizadorRelatorio.pas
    └── UViewModalTermos.pas
```

---

## 🔐 Modos de Operação

### 🌐 Modo Público (Conectado ao Servidor)
- Conecta-se ao banco de dados PostgreSQL via servidor Docker
- Valida credenciais no servidor
- Limitado a 10 planilhas por usuário
- Registra aceite de termos e logs de atividade no banco

### 🖥️ Modo Privado (Offline)
- Dados armazenados localmente em arquivos JSON
- Nenhum limite de dados
- Sem dependência de rede ou servidor
- Ideal para demonstração e uso offline

---

## 📝 Tipos de Relatórios

| Tipo | Descrição |
|------|----------|
| **Relatório 1** | Nome e tamanho de cada planilha salva |
| **Relatório 2** | Quantidade de dados em cada coluna |
| **Relatório 3** | Nome, tamanho, caminho e tipo de relatórios |
| **Relatório de Auditoria** | Log detalhado de todas as ações realizadas |

---

## 📁 Arquitetura de Dados

- **PostgreSQL**: Para dados públicos (usuários, planilhas, relatórios, logs)
- **JSON**: Para dados privados (armazenamento local, segurança e portabilidade)
- **FireDAC**: Conexão segura com PostgreSQL
- **Hashing com Salt**: Proteção de senhas em ambos os modos

## 💬 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

---

> **Desenvolvido com ❤️ em Delphi 12**  
> *Para mais informações, consulte o arquivo `Proposta.pdf`.*
