# Ambiente de Desenvolvimento

## Objetivo

Este documento descreve o ambiente local de desenvolvimento e as principais ferramentas utilizadas para construir, gerenciar, validar e documentar a Plataforma Corporativa de Dados do Atlas Engineering.

Seu objetivo é fornecer uma referência clara da estação de trabalho de desenvolvimento e das dependências de software e ferramentas de apoio utilizadas para reproduzir e manter o ambiente do projeto.

---

## Sistema Operacional

O ambiente local de desenvolvimento utiliza:

- Windows 11 Pro

O sistema operacional fornece a plataforma da estação de trabalho para as atividades de desenvolvimento, administração, validação, documentação e gerenciamento de repositório realizadas no Atlas Engineering.

---

## Ferramentas de Desenvolvimento

O ambiente local de desenvolvimento do Atlas Engineering utiliza atualmente as seguintes ferramentas principais.

### Git

Utilizado para controle de versão distribuído e gerenciamento do repositório local.

O Git fornece a funcionalidade de controle de versão utilizada para rastrear alterações nos artefatos do projeto e manter o histórico do repositório local.

### GitHub Desktop

Utilizado como interface gráfica para operações do Git e sincronização entre o repositório local e o repositório remoto no GitHub.

O GitHub Desktop oferece suporte ao fluxo de trabalho atual de desenvolvimento, mas não substitui o Git como sistema de controle de versão subjacente.

### Visual Studio Code

Utilizado para navegação no repositório, edição da documentação, desenvolvimento de *scripts* e gerenciamento geral dos arquivos do projeto.

É o editor principal utilizado para os arquivos-fonte e a documentação versionados do Atlas Engineering.

### SQL Server 2025 Developer Edition

Utilizado como plataforma local de banco de dados relacional para desenvolvimento, *deployment*, testes e validação do AtlasCommerce.

O SQL Server Developer Edition fornece o conjunto de funcionalidades do SQL Server necessário para desenvolver e validar a plataforma de banco de dados no ambiente local não produtivo.

### SQL Server Management Studio

Utilizado para administração do SQL Server, desenvolvimento em T-SQL, execução de *deployments*, inspeção de bancos de dados, diagnóstico e validação.

É a principal interface gráfica de administração e desenvolvimento utilizada para o ambiente SQL Server local.

### Schemity Lite

Utilizado para criar e manter o Diagrama Entidade-Relacionamento (ERD) do modelo de dados relacional do AtlasCommerce.

O diagrama gerado fornece uma representação visual da estrutura e dos relacionamentos do banco de dados e complementa os *scripts* de banco de dados versionados e a documentação de arquitetura mantidos no projeto.

---

## Repositório Remoto

O GitHub é utilizado como plataforma de hospedagem do repositório remoto do Atlas Engineering.

O repositório Git local é sincronizado com o repositório remoto por meio do GitHub Desktop, fornecendo persistência remota dos artefatos versionados do projeto, histórico do repositório e sincronização controlada entre os ambientes local e remoto.

O GitHub complementa o fluxo de trabalho local de desenvolvimento ao fornecer a plataforma remota de controle de versão do projeto.