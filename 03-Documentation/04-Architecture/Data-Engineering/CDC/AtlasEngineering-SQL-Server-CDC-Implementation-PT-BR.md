# Atlas Engineering — Implementação do CDC do SQL Server

**Projeto:** Atlas Engineering — Plataforma Corporativa de Dados  
**Sistema de Origem:** AtlasCommerce  
**Domínio Inicial:** `AtlasCommerce.sales`  
**Versão do Documento:** V1  
**Status:** Aprovado

---

## Índice

- [1. Objetivo](#1-objetivo)

- [2. Escopo](#2-escopo)
    - [2.1 Cobertura da Implementação](#21-cobertura-da-implementação)
    - [2.2 Tabelas de Origem](#22-tabelas-de-origem)
    - [2.3 Fora do Escopo](#23-fora-do-escopo)
    - [2.4 Fronteira de Evidência](#24-fronteira-de-evidência)

- [3. Contexto da Implementação](#3-contexto-da-implementação)
    - [3.1 Papel Arquitetural do CDC do SQL Server](#31-papel-arquitetural-do-cdc-do-sql-server)
    - [3.2 Princípio de Proteção da Origem](#32-princípio-de-proteção-da-origem)
    - [3.3 Decisão, Implementação e Evidência](#33-decisão-implementação-e-evidência)
    - [3.4 Ambiente de Laboratório](#34-ambiente-de-laboratório)

- [4. Baseline Pré-CDC — M01.08](#4-baseline-pré-cdc--m0108)
    - [4.1 Instância do SQL Server](#41-instância-do-sql-server)
    - [4.2 Estado do Banco de Dados AtlasCommerce](#42-estado-do-banco-de-dados-atlascommerce)
    - [4.3 Baseline do Log de Transações](#43-baseline-do-log-de-transações)
    - [4.4 Contagem de Linhas da Origem](#44-contagem-de-linhas-da-origem)
    - [4.5 SQL Server Agent](#45-sql-server-agent)
    - [4.6 Estado Inicial do CDC](#46-estado-inicial-do-cdc)
    - [4.7 Resultado Observado](#47-resultado-observado)
    - [4.8 Conclusão](#48-conclusão)

- [5. Habilitação do CDC no Nível do Banco de Dados — M01.09](#5-habilitação-do-cdc-no-nível-do-banco-de-dados--m0109)
    - [5.1 Objetivo](#51-objetivo)
    - [5.2 Implementação](#52-implementação)
    - [5.3 Objetos Criados pelo SQL Server](#53-objetos-criados-pelo-sql-server)
    - [5.4 Resultado Observado](#54-resultado-observado)
    - [5.5 Conclusão](#55-conclusão)

- [6. Habilitação do CDC em `sales.Transaction` — M01.10](#6-habilitação-do-cdc-em-salestransaction--m0110)
    - [6.1 Estado Antes da Habilitação](#61-estado-antes-da-habilitação)
    - [6.2 Configuração da Captura](#62-configuração-da-captura)
    - [6.3 Instância de Captura](#63-instância-de-captura)
    - [6.4 Colunas Capturadas](#64-colunas-capturadas)
    - [6.5 Objetos do CDC Gerados](#65-objetos-do-cdc-gerados)
    - [6.6 Configuração de Net Changes](#66-configuração-de-net-changes)
    - [6.7 Aviso sobre Partition Switching](#67-aviso-sobre-partition-switching)
    - [6.8 Resultado Observado](#68-resultado-observado)
    - [6.9 Conclusão](#69-conclusão)

- [7. Jobs do CDC e Configuração Operacional](#7-jobs-do-cdc-e-configuração-operacional)
    - [7.1 Job de Captura](#71-job-de-captura)
    - [7.2 Job de Cleanup](#72-job-de-cleanup)
    - [7.3 Polling da Captura](#73-polling-da-captura)
    - [7.4 Retenção Inicial](#74-retenção-inicial)

- [8. Partition Switching e CDC](#8-partition-switching-e-cdc)
    - [8.1 Restrição do SQL Server](#81-restrição-do-sql-server)
    - [8.2 Contexto de Particionamento do AtlasCommerce](#82-contexto-de-particionamento-do-atlascommerce)
    - [8.3 Verificação do Repositório](#83-verificação-do-repositório)
    - [8.4 Decisão Arquitetural](#84-decisão-arquitetural)
    - [8.5 Fronteira Operacional](#85-fronteira-operacional)

- [9. Backfill Inicial e Cutover do CDC](#9-backfill-inicial-e-cutover-do-cdc)
    - [9.1 Por que o CDC Não Substitui o Backfill Inicial](#91-por-que-o-cdc-não-substitui-o-backfill-inicial)
    - [9.2 Baseline Histórico](#92-baseline-histórico)
    - [9.3 Princípio de Cutover](#93-princípio-de-cutover)
    - [9.4 Sobreposição Controlada](#94-sobreposição-controlada)
    - [9.5 Semântica Histórica](#95-semântica-histórica)

- [10. Retenção do CDC — M01.10B](#10-retenção-do-cdc--m0110b)
    - [10.1 Retenção Padrão](#101-retenção-padrão)
    - [10.2 Requisito de Recuperação](#102-requisito-de-recuperação)
    - [10.3 Decisão de Retenção da V1](#103-decisão-de-retenção-da-v1)
    - [10.4 Implementação](#104-implementação)
    - [10.5 Erro Operacional do Job de Cleanup](#105-erro-operacional-do-job-de-cleanup)
    - [10.6 Causa Raiz](#106-causa-raiz)
    - [10.7 Correção](#107-correção)
    - [10.8 Resultado Observado](#108-resultado-observado)
    - [10.9 Atualização dos Dados vs. Janela de Recuperação](#109-atualização-dos-dados-vs-janela-de-recuperação)
    - [10.10 Conclusão](#1010-conclusão)

- [11. Anatomia da Tabela de Alterações — M01.11](#11-anatomia-da-tabela-de-alterações--m0111)
    - [11.1 Tabela de Alterações](#111-tabela-de-alterações)
    - [11.2 Colunas de Metadados do CDC](#112-colunas-de-metadados-do-cdc)
    - [11.3 Colunas Capturadas da Origem](#113-colunas-capturadas-da-origem)
    - [11.4 Índice Físico](#114-índice-físico)
    - [11.5 Nulabilidade da Origem vs. Nulabilidade da Tabela de Alterações](#115-nulabilidade-da-origem-vs-nulabilidade-da-tabela-de-alterações)
    - [11.6 Estado Inicial da Tabela de Alterações](#116-estado-inicial-da-tabela-de-alterações)
    - [11.7 Semântica dos Metadados do CDC](#117-semântica-dos-metadados-do-cdc)
    - [11.8 Conclusão](#118-conclusão)

- [12. INSERT Controlado — M01.12](#12-insert-controlado--m0112)
    - [12.1 Objetivo](#121-objetivo)
    - [12.2 Transação de Teste](#122-transação-de-teste)
    - [12.3 Resultado Esperado](#123-resultado-esperado)
    - [12.4 Observação Imediatamente Após a Confirmação](#124-observação-imediatamente-após-a-confirmação)
    - [12.5 Observação Após a Captura](#125-observação-após-a-captura)
    - [12.6 Representação do INSERT](#126-representação-do-insert)
    - [12.7 Evidência de Captura Assíncrona](#127-evidência-de-captura-assíncrona)
    - [12.8 Conclusão](#128-conclusão)

- [13. UPDATE Controlado — M01.13](#13-update-controlado--m0113)
    - [13.1 Objetivo](#131-objetivo)
    - [13.2 Estado da Linha Antes do UPDATE](#132-estado-da-linha-antes-do-update)
    - [13.3 Imagens UPDATE BEFORE e AFTER](#133-imagens-update-before-e-after)
    - [13.4 Máscara de Atualização](#134-máscara-de-atualização)
    - [13.5 Resultado Observado](#135-resultado-observado)
    - [13.6 Conclusão](#136-conclusão)

- [14. Múltiplos Comandos de UPDATE em uma Única Transação — M01.14](#14-múltiplos-comandos-de-update-em-uma-única-transação--m0114)
    - [14.1 Objetivo](#141-objetivo)
    - [14.2 Estrutura da Transação](#142-estrutura-da-transação)
    - [14.3 Ordenação dos Comandos](#143-ordenação-dos-comandos)
    - [14.4 Máscaras de Atualização](#144-máscaras-de-atualização)
    - [14.5 Correlação da Transação](#145-correlação-da-transação)
    - [14.6 Resultado Observado](#146-resultado-observado)
    - [14.7 Conclusão](#147-conclusão)

- [15. DELETE Controlado — M01.15](#15-delete-controlado--m0115)
    - [15.1 Objetivo](#151-objetivo)
    - [15.2 Estado da Origem Antes do DELETE](#152-estado-da-origem-antes-do-delete)
    - [15.3 Execução do DELETE](#153-execução-do-delete)
    - [15.4 Representação do DELETE no CDC](#154-representação-do-delete-no-cdc)
    - [15.5 Detecção de DELETE Físico](#155-detecção-de-delete-físico)
    - [15.6 Resultado Observado](#156-resultado-observado)
    - [15.7 Conclusão](#157-conclusão)

- [16. Habilitação do CDC em `sales.TransactionItem` — M01.16](#16-habilitação-do-cdc-em-salestransactionitem--m0116)
    - [16.1 Validação Pré-Habilitação — M01.16A](#161-validação-pré-habilitação--m0116a)
    - [16.2 Chave Primária](#162-chave-primária)
    - [16.3 Chave Estrangeira e ON DELETE CASCADE](#163-chave-estrangeira-e-on-delete-cascade)
    - [16.4 Particionamento](#164-particionamento)
    - [16.5 Habilitação do CDC — M01.16B](#165-habilitação-do-cdc--m0116b)
    - [16.6 Instância de Captura](#166-instância-de-captura)
    - [16.7 Objetos do CDC Gerados](#167-objetos-do-cdc-gerados)
    - [16.8 Estado Inicial da Tabela de Alterações](#168-estado-inicial-da-tabela-de-alterações)
    - [16.9 Observação Inicial do LSN Mínimo](#169-observação-inicial-do-lsn-mínimo)
    - [16.10 Conclusão](#1610-conclusão)

- [17. Preparação do CDC entre Tabelas — M01.17A](#17-preparação-do-cdc-entre-tabelas--m0117a)
    - [17.1 Objetivo](#171-objetivo)
    - [17.2 Validação das Instâncias de Captura](#172-validação-das-instâncias-de-captura)
    - [17.3 Erro de Script em `sp_cdc_help_change_data_capture`](#173-erro-de-script-em-sp_cdc_help_change_data_capture)
    - [17.4 Causa Raiz](#174-causa-raiz)
    - [17.5 Correção](#175-correção)
    - [17.6 Estado de LSN](#176-estado-de-lsn)
    - [17.7 Conclusão](#177-conclusão)

- [18. Transação de INSERT entre Tabelas — M01.17B](#18-transação-de-insert-entre-tabelas--m0117b)
    - [18.1 Objetivo](#181-objetivo)
    - [18.2 Estrutura da Transação](#182-estrutura-da-transação)
    - [18.3 Linhas Criadas na Origem](#183-linhas-criadas-na-origem)
    - [18.4 Estado Imediato do CDC](#184-estado-imediato-do-cdc)
    - [18.5 Estado Capturado pelo CDC](#185-estado-capturado-pelo-cdc)
    - [18.6 Correlação da Transação entre Tabelas](#186-correlação-da-transação-entre-tabelas)
    - [18.7 Ordenação dos Comandos](#187-ordenação-dos-comandos)
    - [18.8 Fronteira da Evidência](#188-fronteira-da-evidência)
    - [18.9 Conclusão](#189-conclusão)

- [19. UPDATE Coordenado entre Tabelas — M01.18](#19-update-coordenado-entre-tabelas--m0118)
    - [19.1 Objetivo](#191-objetivo)
    - [19.2 Estrutura da Transação](#192-estrutura-da-transação)
    - [19.3 Estado Final da Origem](#193-estado-final-da-origem)
    - [19.4 LSN de Transação Compartilhado](#194-lsn-de-transação-compartilhado)
    - [19.5 Identificadores de Comando e Valores de Sequência](#195-identificadores-de-comando-e-valores-de-sequência)
    - [19.6 Máscaras de Atualização](#196-máscaras-de-atualização)
    - [19.7 Semântica dos Pares de UPDATE](#197-semântica-dos-pares-de-update)
    - [19.8 Conclusão](#198-conclusão)

- [20. DELETE do Pai com ON DELETE CASCADE — M01.19](#20-delete-do-pai-com-on-delete-cascade--m0119)
    - [20.1 Objetivo](#201-objetivo)
    - [20.2 Estado da Origem Antes do DELETE](#202-estado-da-origem-antes-do-delete)
    - [20.3 DELETE Explícito do Pai](#203-delete-explícito-do-pai)
    - [20.4 Cascata Referencial](#204-cascata-referencial)
    - [20.5 Representação no CDC](#205-representação-no-cdc)
    - [20.6 LSN de Transação Compartilhado](#206-lsn-de-transação-compartilhado)
    - [20.7 Ordenação dos Comandos](#207-ordenação-dos-comandos)
    - [20.8 Ação da Aplicação versus Alterações Físicas](#208-ação-da-aplicação-versus-alterações-físicas)
    - [20.9 Resultado Observado](#209-resultado-observado)
    - [20.10 Conclusão](#2010-conclusão)

- [21. Modelo Consolidado de Transações do CDC](#21-modelo-consolidado-de-transações-do-cdc)
    - [21.1 LSN de Transação](#211-lsn-de-transação)
    - [21.2 Identificador de Comando](#212-identificador-de-comando)
    - [21.3 Valor de Sequência](#213-valor-de-sequência)
    - [21.4 Operação](#214-operação)
    - [21.5 Máscara de Atualização](#215-máscara-de-atualização)
    - [21.6 Modelo dos Pares de UPDATE](#216-modelo-dos-pares-de-update)
    - [21.7 Correlação entre Tabelas](#217-correlação-entre-tabelas)

- [22. Modelo de Captura Assíncrona](#22-modelo-de-captura-assíncrona)
    - [22.1 Confirmação da Transação versus Disponibilidade no CDC](#221-confirmação-da-transação-versus-disponibilidade-no-cdc)
    - [22.2 Polling do Job de Captura](#222-polling-do-job-de-captura)
    - [22.3 Observação de Laboratório](#223-observação-de-laboratório)
    - [22.4 Fronteira da Evidência em Produção](#224-fronteira-da-evidência-em-produção)

- [23. Semântica de Tempo](#23-semântica-de-tempo)
    - [23.1 Tempo do Evento de Negócio](#231-tempo-do-evento-de-negócio)
    - [23.2 Tempo da Transação no CDC](#232-tempo-da-transação-no-cdc)
    - [23.3 Futuro Tempo de Ingestão da Plataforma](#233-futuro-tempo-de-ingestão-da-plataforma)

- [24. Erros e Correções da Implementação](#24-erros-e-correções-da-implementação)
    - [24.1 Solicitação de Parada do Job de Cleanup](#241-solicitação-de-parada-do-job-de-cleanup)
    - [24.2 Erro de Parâmetro em `sp_cdc_help_change_data_capture`](#242-erro-de-parâmetro-em-sp_cdc_help_change_data_capture)
    - [24.3 Observação Transitória do LSN Mínimo](#243-observação-transitória-do-lsn-mínimo)
    - [24.4 Lições de Engenharia](#244-lições-de-engenharia)

- [25. Resumo das Evidências](#25-resumo-das-evidências)
    - [25.1 Comportamentos Comprovados](#251-comportamentos-comprovados)
    - [25.2 Comportamentos Ainda Não Comprovados](#252-comportamentos-ainda-não-comprovados)
    - [25.3 Afirmações de Laboratório vs. Produção](#253-afirmações-de-laboratório-vs-produção)

- [26. Status da Implementação](#26-status-da-implementação)

- [27. Próxima Etapa — Consumo do CDC](#27-próxima-etapa--consumo-do-cdc)
    - [27.1 M01.20 — Consumo do CDC](#271-m0120--consumo-do-cdc)
    - [27.2 M01.20A — Inspeção da Janela de LSN](#272-m0120a--inspeção-da-janela-de-lsn)
    - [27.3 Funções de Consulta de Todas as Alterações](#273-funções-de-consulta-de-todas-as-alterações)
    - [27.4 Opções de Filtro de Linhas](#274-opções-de-filtro-de-linhas)
    - [27.5 Questões de Checkpoint](#275-questões-de-checkpoint)
    - [27.6 O Contexto da Transação Deve Ser Preservado](#276-o-contexto-da-transação-deve-ser-preservado)
    - [27.7 Limite de Retenção](#277-limite-de-retenção)
    - [27.8 Evidências Necessárias Antes da Conclusão](#278-evidências-necessárias-antes-da-conclusão)
    - [27.9 Ponto Atual da Engenharia](#279-ponto-atual-da-engenharia)

---

## 1. Objetivo

Este documento define e registra a implementação do Change Data Capture (CDC) do SQL Server para o domínio inicial `AtlasCommerce.sales` da plataforma Atlas Engineering.

Seu objetivo é documentar não apenas a configuração resultante do CDC, mas também o processo de engenharia utilizado para estabelecer e validar essa configuração. Isso inclui o *baseline* do sistema de origem, a habilitação nos níveis de banco de dados e de tabela, a configuração operacional, os testes controlados de alterações, os metadados do CDC observados, o comportamento de transações entre tabelas, os erros e as correções de implementação e as evidências produzidas durante o ciclo de laboratório.

A implementação documentada aqui abrange o trabalho controlado de laboratório realizado do M01.08 ao M01.19.

Este documento, portanto, serve como registro de implementação e de evidências da parte de CDC do SQL Server da Estratégia de Captura V1. Ele complementa a documentação mais ampla da estratégia de captura, que define por que o CDC foi selecionado para as tabelas de origem relevantes e como ele se encaixa na arquitetura geral de captura do Atlas Engineering.

A próxima fase, que começa com o consumo do CDC, está intencionalmente excluída da implementação concluída documentada aqui.

---

## 2. Escopo

### 2.1 Cobertura da Implementação

Este documento abrange as atividades de implementação e validação do CDC do SQL Server realizadas durante o ciclo controlado de laboratório do M01.08 ao M01.19.

As atividades abrangidas incluem:

- estabelecer o *baseline* da origem antes da habilitação do CDC;
- habilitar o CDC no nível do banco de dados `AtlasCommerce`;
- habilitar o CDC nas tabelas de origem iniciais;
- inspecionar os objetos e metadados do CDC gerados;
- configurar e validar os *jobs* de captura e *cleanup* do CDC;
- definir a janela de retenção do CDC;
- examinar a estrutura física e lógica das tabelas de alterações do CDC;
- validar operações controladas de `INSERT`, `UPDATE` e `DELETE`;
- validar múltiplos comandos na origem executados em uma única transação;
- validar a correlação de transações entre múltiplas tabelas com CDC habilitado;
- validar operações coordenadas de `UPDATE` entre tabelas;
- validar um `DELETE` na tabela pai que produz exclusões de linhas filhas por meio de `ON DELETE CASCADE`;
- registrar erros de implementação, causas raiz, correções e as lições de engenharia resultantes.

O escopo é intencionalmente limitado ao comportamento que foi diretamente implementado ou observado durante o ciclo de laboratório.

### 2.2 Tabelas de Origem

A implementação do CDC abrangida por este documento se aplica às seguintes tabelas de origem:

- `sales.Transaction`
- `sales.TransactionItem`

Essas tabelas representam o escopo transacional inicial de alta taxa de alterações selecionado para o CDC do SQL Server na Estratégia de Captura V1.

A implementação é avaliada tanto no nível individual de cada tabela quanto na relação transacional entre as duas tabelas.

### 2.3 Fora do Escopo

Os seguintes itens estão fora do escopo de implementação deste documento:

- consumo do CDC pela plataforma de dados Atlas Engineering;
- persistência de *checkpoint* para consumidores do CDC;
- implementação de *replay* e recuperação no lado consumidor;
- ingestão na zona de dados brutos;
- transformação ou processamento analítico;
- orquestração de *pipelines* subsequentes;
- implantação em produção;
- validação de *throughput* ou latência em escala de produção;
- monitoramento e alertas em produção;
- habilitação do CDC para tabelas de origem fora do escopo inicial validado.

Esses aspectos podem depender do comportamento do CDC estabelecido aqui, mas exigem implementação e evidências separadas.

### 2.4 Fronteira de Evidência

As conclusões deste documento estão limitadas às evidências produzidas no ambiente controlado de laboratório do Atlas Engineering.

Um comportamento é considerado validado somente quando foi observado diretamente por meio da configuração implementada do CDC do SQL Server e do teste controlado correspondente.

As observações de laboratório não devem ser generalizadas como garantias de produção sem evidências que as sustentem.

Quando a implementação estabelece o comportamento do SQL Server, mas não fornece evidências suficientes sobre características em escala de produção, essa distinção é declarada explicitamente.

---

## 3. Contexto da Implementação

### 3.1 Papel Arquitetural do CDC do SQL Server

O CDC do SQL Server é o mecanismo da Estratégia de Captura V1 selecionado para as tabelas transacionais com alta taxa de alterações no domínio inicial `AtlasCommerce.sales`.

Dentro desse escopo, o CDC fornece um mecanismo baseado no *log* de transações para expor alterações confirmadas na origem, sem exigir que a plataforma Atlas Engineering deduza essas alterações por meio de comparações completas e repetidas das tabelas ou de *timestamps* gerenciados pela aplicação.

A implementação documentada aqui concentra-se em estabelecer a capacidade de CDC no lado da origem e comprovar a semântica das alterações exigida pelo futuro consumidor.

Ela não define a arquitetura completa de ingestão subsequente.

### 3.2 Princípio de Proteção da Origem

O banco de dados `AtlasCommerce` é tratado como o sistema de origem OLTP autoritativo.

O CDC deve, portanto, ser implementado sem transferir responsabilidades de processamento da plataforma de dados para a camada da aplicação transacional.

O sistema de origem é responsável por sua carga de trabalho transacional e por expor as informações de alterações fornecidas pelo CDC do SQL Server. O processamento subsequente, *replay*, gerenciamento de *checkpoint*, ingestão histórica, transformações e cargas de trabalho analíticas permanecem como responsabilidades da plataforma de dados.

Essa fronteira é uma restrição central da implementação: o mecanismo de captura deve dar suporte à plataforma sem transformar o banco de dados OLTP no mecanismo de processamento da plataforma de dados.

### 3.3 Decisão, Implementação e Evidência

Três aspectos distintos são mantidos separados ao longo deste documento:

**Decisão arquitetural** define o que a plataforma pretende utilizar e por quê.

**Implementação** registra como o CDC do SQL Server foi configurado para o escopo de origem validado.

**Evidência** registra o que foi efetivamente observado durante a execução controlada.

Essa distinção impede que uma expectativa arquitetural seja apresentada como um comportamento observado do SQL Server e impede que uma observação de laboratório seja elevada a uma garantia mais ampla sem evidências que a sustentem.

### 3.4 Ambiente de Laboratório

A implementação foi realizada no banco de dados de origem `AtlasCommerce` do Atlas Engineering, no ambiente controlado de laboratório do projeto.

O laboratório fornece o ambiente necessário para inspecionar o estado da origem, configurar o CDC do SQL Server, executar transações controladas, inspecionar os metadados e as tabelas de alterações do CDC e correlacionar as operações observadas na origem com os registros de alterações capturados.

O ambiente é utilizado para estabelecer o comportamento da implementação e produzir evidências sob condições controladas. Ele não é tratado como substituto para evidências provenientes de cargas de trabalho, escala, retenção, latência ou operações em produção.

---

## 4. Baseline Pré-CDC — M01.08

Antes da habilitação do Change Data Capture, foi estabelecido um *baseline* controlado para o ambiente de origem `AtlasCommerce`.

O objetivo desse *baseline* foi registrar o estado da instância do SQL Server, do banco de dados de origem, do *log* de transações, das tabelas de origem iniciais, do SQL Server Agent e da configuração de CDC existente antes da introdução de qualquer alteração relacionada ao CDC.

Isso forneceu um ponto de partida conhecido a partir do qual os efeitos das etapas subsequentes da implementação puderam ser avaliados.

### 4.1 Instância do SQL Server

O laboratório de implementação do CDC foi conduzido no seguinte ambiente do SQL Server:

```text
Instância:
Instância Padrão

Edição:
SQL Server Enterprise Developer Edition (64-bit)

Versão:
17.0.1125.2

Lançamento:
RTM
```

O ambiente forneceu os recursos do SQL Server necessários para o ciclo controlado de implementação e validação do CDC documentado aqui.

### 4.2 Estado do Banco de Dados AtlasCommerce

Antes da habilitação do CDC, o banco de dados `AtlasCommerce` foi verificado como:

```text
Banco de Dados:
AtlasCommerce

Estado:
ONLINE

Modelo de Recuperação:
FULL

Nível de Compatibilidade:
170

CDC Habilitado:
0
```

O valor:

```text
is_cdc_enabled = 0
```

confirmou que o CDC no nível do banco de dados ainda não havia sido habilitado.

Esse estado foi registrado antes da execução de qualquer procedimento de habilitação do CDC para que a transição introduzida pelo M01.09 pudesse ser validada diretamente.

### 4.3 Baseline do Log de Transações

O *log* de transações foi inspecionado antes da habilitação do CDC.

O *baseline* observado foi:

```text
Tamanho Total do Log:
255.99 MB

Espaço Utilizado do Log:
30.87 MB

Espaço Utilizado do Log:
12.06%

Espera para Reutilização do Log:
NOTHING
```

O valor:

```text
log_reuse_wait_desc = NOTHING
```

indicou que, no momento da inspeção do *baseline*, o SQL Server não estava reportando uma condição que impedisse a reutilização do *log* de transações.

Essa medição representa o estado observado naquele *checkpoint* específico do laboratório. Ela não deve ser interpretada como uma característica permanente do banco de dados nem como evidência do comportamento futuro do *log* de transações relacionado ao CDC.

### 4.4 Contagem de Linhas da Origem

As contagens iniciais de linhas das tabelas de `AtlasCommerce.sales` foram registradas como:

| Tabela de Origem | Linhas |
|---|---:|
| `sales.Transaction` | 6,306 |
| `sales.TransactionItem` | 13,769 |
| `sales.TransactionChannel` | 2 |
| `sales.TransactionStatus` | 5 |

Essas contagens estabeleceram o *baseline* conhecido do estado da origem antes da habilitação do CDC.

Elas são particularmente relevantes para a validação subsequente do comportamento do CDC porque permitem que a implementação diferencie entre:

- linhas que já existiam antes da habilitação do CDC; e
- alterações geradas após o estabelecimento da fronteira de captura do CDC.

Essa distinção torna-se importante ao validar se o CDC do SQL Server captura automaticamente linhas históricas que existiam antes da habilitação no nível da tabela.

### 4.5 SQL Server Agent

O SQL Server Agent foi verificado antes da habilitação do CDC.

O estado observado foi:

```text
Estado:
RUNNING

Modo de Inicialização:
Automatic
```

Essa validação foi relevante porque o CDC do SQL Server depende de *jobs* do SQL Server Agent para as operações de captura e *cleanup*.

O *baseline* estabeleceu, portanto, que a infraestrutura do SQL Server Agent exigida pela implementação subsequente do CDC estava disponível antes da habilitação do CDC.

### 4.6 Estado Inicial do CDC

No início do ciclo de implementação:

```text
CDC Habilitado no Banco de Dados:
NÃO

Schema do CDC Presente:
NÃO

Instâncias de Captura do CDC:
NENHUMA
```

Nenhum *schema* ou estrutura de captura do CDC existia no banco de dados nesse momento.

O ambiente representava, portanto, um estado pré-CDC limpo para a implementação controlada.

### 4.7 Resultado Observado

O *baseline* do M01.08 estabeleceu o seguinte estado inicial:

```text
AtlasCommerce
│
├── ONLINE
├── modelo de recuperação FULL
├── nível de compatibilidade 170
├── CDC desabilitado
│
├── SQL Server Agent
│   └── RUNNING / Automatic
│
├── Log de Transações
│   ├── total = 255.99 MB
│   ├── utilizado = 30.87 MB
│   ├── utilizado = 12.06%
│   └── log_reuse_wait_desc = NOTHING
│
└── Linhas da Origem
    ├── Transaction = 6,306
    ├── TransactionItem = 13,769
    ├── TransactionChannel = 2
    └── TransactionStatus = 5
```

Nenhuma operação de habilitação ou captura do CDC havia sido realizada até esse momento.

### 4.8 Conclusão

O M01.08 estabeleceu um *baseline* pré-CDC controlado e documentado para o ambiente de origem `AtlasCommerce`.

O banco de dados estava online e operando sob o modelo de recuperação `FULL`. O SQL Server Agent estava em execução, nenhuma espera para reutilização do *log* de transações foi reportada no momento da observação e o CDC não estava habilitado.

As linhas transacionais existentes também foram quantificadas antes do início da captura.

Esse *baseline* forneceu o ponto de referência necessário para que as etapas subsequentes da implementação demonstrassem o que mudou como resultado direto da habilitação e configuração do CDC do SQL Server.

**Status do M01.08: APROVADO**

---

## 5. Habilitação do CDC no Nível do Banco de Dados — M01.09

Com o *baseline* pré-CDC estabelecido, a próxima etapa da implementação foi habilitar o Change Data Capture no nível do banco de dados `AtlasCommerce`.

A habilitação no nível do banco de dados estabelece a infraestrutura de CDC exigida pelo SQL Server antes que tabelas de origem individuais possam ser configuradas para a captura de alterações.

Nesse estágio, nenhuma tabela de origem foi colocada automaticamente sob rastreamento do CDC.

### 5.1 Objetivo

O objetivo do M01.09 foi:

- habilitar o CDC do SQL Server para o banco de dados `AtlasCommerce`;
- verificar a transição a partir do estado pré-CDC;
- inspecionar a infraestrutura de CDC criada pelo SQL Server;
- confirmar que a habilitação no nível do banco de dados não habilita automaticamente o CDC nas tabelas de origem.

Antes da execução, o *baseline* estabelecido no M01.08 apresentava:

```text
is_cdc_enabled = 0
```

e nenhum *schema* `cdc` estava presente.

### 5.2 Implementação

O CDC no nível do banco de dados foi habilitado utilizando a *stored procedure* de sistema do SQL Server:

```sql
USE [AtlasCommerce];
GO

EXEC sys.sp_cdc_enable_db;
GO
```

A ação essencial da implementação é a execução de:

```sql
EXEC sys.sp_cdc_enable_db;
```

Essa *stored procedure* habilita a infraestrutura de CDC para o banco de dados atual.

A lógica completa de execução e validação é mantida no *script* SQL correspondente ao M01.09. O documento de implementação registra o objetivo de engenharia, o comportamento relevante e as evidências observadas, em vez de duplicar o *script* completo.

### 5.3 Objetos Criados pelo SQL Server

Após a habilitação do CDC no nível do banco de dados, o SQL Server criou a infraestrutura de CDC necessária para gerenciar os metadados de captura e as instâncias subsequentes de captura no nível das tabelas.

A infraestrutura observada incluiu o *schema* `cdc` e estruturas de metadados do CDC para áreas como:

- mapeamento de LSN para tempo;
- tabelas de alterações registradas;
- metadados das colunas capturadas;
- histórico de DDL;
- metadados das colunas de índice;
- funções e *stored procedures* internas do CDC.

Entre os objetos de metadados observados durante a validação estavam estruturas correspondentes a:

```text
cdc.lsn_time_mapping
cdc.change_tables
cdc.captured_columns
cdc.ddl_history
cdc.index_columns
```

Esses objetos pertencem à infraestrutura de CDC gerenciada pelo SQL Server.

Sua criação representa a inicialização do CDC no nível do banco de dados; isso não significa que uma tabela específica da aplicação já esteja sendo capturada.

### 5.4 Resultado Observado

Após a execução da *stored procedure* de habilitação no nível do banco de dados, o estado do banco de dados foi validado novamente.

O estado resultante foi:

```text
Banco de Dados:
AtlasCommerce

CDC Habilitado:
1

Schema do CDC:
PRESENTE

Infraestrutura de Metadados do CDC:
PRESENTE
```

A transição:

```text
is_cdc_enabled = 0
        ↓
sys.sp_cdc_enable_db
        ↓
is_cdc_enabled = 1
```

confirmou que o CDC havia sido habilitado com sucesso no nível do banco de dados.

A validação também confirmou uma importante fronteira de implementação:

```text
CDC Habilitado no Banco de Dados
        ≠
Tabela de Origem Capturada Automaticamente
```

Nenhuma tabela da aplicação teve o CDC habilitado apenas pela execução de `sys.sp_cdc_enable_db`.

A captura no nível da tabela permaneceu como uma etapa de implementação separada e explícita.

### 5.5 Conclusão

O M01.09 habilitou com sucesso o CDC do SQL Server no nível do banco de dados `AtlasCommerce`.

O SQL Server criou o *schema* do CDC e a infraestrutura de metadados de suporte, e o banco de dados passou de:

```text
is_cdc_enabled = 0
```

para:

```text
is_cdc_enabled = 1
```

A implementação também confirmou que a habilitação do CDC no nível do banco de dados estabelece a infraestrutura necessária, mas não configura automaticamente tabelas de origem individuais para captura.

Essa distinção é fundamental para a sequência de implementação:

```text
Habilitação do CDC no Nível do Banco de Dados
        ↓
Infraestrutura de CDC Disponível
        ↓
Habilitação Explícita no Nível da Tabela
        ↓
Tabela de Origem Capturada
```

O ambiente estava, portanto, pronto para a próxima etapa controlada da implementação: habilitar o CDC em `sales.Transaction`.

**Status do M01.09: APROVADO**

---

## 6. Habilitação do CDC em `sales.Transaction` — M01.10

Com o CDC habilitado no nível do banco de dados `AtlasCommerce`, a próxima etapa da implementação foi configurar a primeira tabela de origem transacional para a captura de alterações.

`sales.Transaction` foi selecionada como a primeira tabela com CDC habilitado porque faz parte do escopo transacional com alta taxa de alterações definido pela Estratégia de Captura V1.

O M01.10 estabeleceu a primeira instância de captura no nível da tabela e forneceu a base para os testes controlados de `INSERT`, `UPDATE` e `DELETE` realizados nas etapas subsequentes.

### 6.1 Estado Antes da Habilitação

Antes da habilitação no nível da tabela, o estado da implementação era:

```text
Banco de dados AtlasCommerce:
CDC habilitado

sales.Transaction:
CDC ainda não habilitado

Linhas existentes na origem:
6,306
```

As linhas existentes já estavam presentes antes de a tabela entrar na fronteira de captura do CDC.

Essa distinção é importante porque habilitar o CDC em uma tabela existente não cria automaticamente registros de alterações que representem suas linhas históricas.

Esse comportamento foi posteriormente validado por meio da inspeção da tabela de alterações.

### 6.2 Configuração da Captura

O CDC foi habilitado para `sales.Transaction` utilizando `sys.sp_cdc_enable_table`.

A configuração relevante foi:

```text
Schema de Origem:
sales

Tabela de Origem:
Transaction

Nome da Role:
NULL

Suporte a Net Changes:
0
```

A implementação essencial no nível da tabela segue esta configuração:

```sql
EXEC sys.sp_cdc_enable_table
    @source_schema        = N'sales',
    @source_name          = N'Transaction',
    @role_name            = NULL,
    @supports_net_changes = 0;
```

`@role_name = NULL` significa que nenhuma *role* dedicada de controle de acesso foi especificada por meio dessa configuração do CDC.

`@supports_net_changes = 0` significa que a instância de captura foi configurada para acesso a todas as alterações, em vez de oferecer suporte a *net changes*.

A lógica completa de execução e validação é mantida no *script* SQL correspondente ao M01.10.

### 6.3 Instância de Captura

O SQL Server criou a seguinte instância de captura:

```text
sales_Transaction
```

O LSN inicial observado foi:

```text
0x0000002C0000FCEC0067
```

A instância de captura identifica os metadados e objetos do CDC associados à tabela de origem.

O índice configurado utilizado pela instância de captura foi:

```text
PK_TRN
```

A instância de captura estabeleceu, portanto, a fronteira do CDC a partir da qual as alterações subsequentes em `sales.Transaction` poderiam ser capturadas pela infraestrutura de CDC.

### 6.4 Colunas Capturadas

Todas as nove colunas de origem configuradas para a instância de captura de `sales.Transaction` foram incluídas nos metadados das colunas capturadas.

Nenhum subconjunto reduzido de colunas foi configurado para esta implementação.

A estrutura completa das colunas capturadas foi posteriormente inspecionada por meio da tabela de alterações do CDC durante o M01.11, quando a relação entre as colunas de origem e as colunas de metadados do CDC foi examinada em detalhes.

### 6.5 Objetos do CDC Gerados

A habilitação no nível da tabela resultou na criação, pelo SQL Server, das estruturas do CDC associadas à instância de captura `sales_Transaction`.

Os principais objetos observados incluíram:

```text
cdc.sales_Transaction_CT
cdc.fn_cdc_get_all_changes_sales_Transaction
```

O primeiro objeto é a tabela de alterações do CDC utilizada para armazenar os registros de alterações capturados para a instância de captura.

O segundo é a função de consulta do CDC utilizada para recuperar todas as alterações dentro de um intervalo de LSN.

Como a instância de captura foi configurada com:

```text
supports_net_changes = 0
```

uma função de consulta correspondente para *net changes* não foi criada.

Essa distinção é intencional e torna-se relevante quando o modelo de consumo do CDC for avaliado em uma etapa posterior da implementação.

### 6.6 Configuração de Net Changes

A implementação utilizou deliberadamente:

```text
supports_net_changes = 0
```

A camada de origem do CDC expõe, portanto, os registros individuais de alterações capturados, em vez de depender do SQL Server para consolidar um intervalo de LSN em um resultado líquido para cada linha da origem.

Nesta etapa da implementação, o objetivo foi preservar e inspecionar a semântica detalhada das alterações produzidas pelo CDC, incluindo operações individuais e a representação de antes/depois dos `UPDATE`.

A estratégia efetiva de consumo permanece fora da fronteira de evidência do M01.10 e não é tratada como já implementada.

### 6.7 Aviso sobre Partition Switching

`sales.Transaction` é particionada.

Durante a habilitação do CDC, o SQL Server produziu o aviso de *partition switching* associado a uma tabela particionada com CDC habilitado quando *partition switching* permanece permitido.

A configuração resultante manteve:

```text
allow_partition_switch = 1
```

Esse aviso foi tratado como uma restrição de implementação que exige avaliação arquitetural explícita, e não como uma falha na habilitação do CDC.

A verificação do repositório não encontrou uso implementado de:

```sql
ALTER TABLE ... SWITCH
```

na implementação atual do sistema de origem `AtlasCommerce`.

A decisão da V1 foi, portanto, governar *partition switching*, em vez de bloqueá-lo apenas porque o CDC havia sido habilitado.

Dentro dessa fronteira:

```text
SWITCH IN:
Não planejado como mecanismo normal de ingestão.

SWITCH OUT:
Pode ser considerado no futuro somente como uma operação controlada.

CDC + partition switching:
Exige governança operacional explícita.
```

A restrição é documentada porque *partition switching* pode interagir com as expectativas do CDC e não deve ser tratado como equivalente à atividade DML comum capturada pelo CDC.

A ausência de `ALTER TABLE ... SWITCH` no repositório atual estabelece o estado da base de código implementada do `AtlasCommerce` examinada durante esta etapa. Isso não estabelece que *partition switching* seja universalmente seguro nem que nunca possa ser introduzido posteriormente.

### 6.8 Resultado Observado

Após o M01.10, o estado da implementação era:

```text
AtlasCommerce
│
├── CDC do Banco de Dados
│   └── HABILITADO
│
└── sales.Transaction
    ├── CDC habilitado
    ├── capture_instance = sales_Transaction
    ├── index = PK_TRN
    ├── supports_net_changes = 0
    ├── colunas capturadas = 9
    ├── start_lsn = 0x0000002C0000FCEC0067
    │
    ├── Tabela de Alterações
    │   └── cdc.sales_Transaction_CT
    │
    └── Função de Todas as Alterações
        └── cdc.fn_cdc_get_all_changes_sales_Transaction
```

A configuração do CDC no nível da tabela foi estabelecida com sucesso.

Nesse momento, a existência da instância de captura e de seus objetos gerados demonstrava que `sales.Transaction` estava incluída no escopo de implementação do CDC.

Isso ainda não comprovava o comportamento de operações individuais de `INSERT`, `UPDATE` ou `DELETE`. Esses comportamentos exigiam os testes controlados realizados nas etapas subsequentes.

### 6.9 Conclusão

O M01.10 habilitou com sucesso o CDC do SQL Server para `sales.Transaction`.

A instância de captura `sales_Transaction` foi criada com todas as nove colunas de origem configuradas, `PK_TRN` como índice configurado e suporte a *net changes* desabilitado.

O SQL Server criou a tabela de alterações correspondente e a função de consulta de todas as alterações.

A implementação também expôs a restrição de *partition switching* associada à tabela de origem particionada. Em vez de tratar o aviso como uma falha de implementação, o projeto estabeleceu uma fronteira operacional explícita: *partition switching* permanece governado e não é utilizado como mecanismo normal de ingestão da tabela.

A tabela estava então preparada para a inspeção detalhada de sua infraestrutura de CDC e para os testes controlados de alterações subsequentes.

**Status do M01.10: APROVADO**

---

## 7. Jobs do CDC e Configuração Operacional

A habilitação do CDC para `sales.Transaction` também estabeleceu os componentes operacionais responsáveis por mover as alterações confirmadas do *log* de transações para as estruturas do CDC e por gerenciar o ciclo de vida dos dados capturados.

O CDC do SQL Server utiliza responsabilidades operacionais separadas para captura e *cleanup*. Compreender essas responsabilidades é importante porque a habilitação bem-sucedida no nível da tabela, por si só, não descreve como as alterações se tornam disponíveis para os consumidores nem por quanto tempo os dados capturados permanecem disponíveis.

### 7.1 Job de Captura

O *job* de captura do CDC é responsável por processar as alterações confirmadas elegíveis do *log* de transações do SQL Server e torná-las disponíveis por meio da infraestrutura de CDC.

A configuração observada do *job* de captura foi:

```text
maxtrans:
10000

maxscans:
10

continuous:
1

pollinginterval:
5 segundos
```

A configuração mostrou que o processo de captura estava operando continuamente e realizando *polling* para trabalho adicional em um intervalo de cinco segundos.

Os parâmetros relevantes possuem finalidades operacionais distintas:

- `maxtrans` limita o número de transações processadas durante um ciclo de varredura;
- `maxscans` limita o número de ciclos de varredura realizados antes da aplicação do intervalo de *polling* configurado;
- `continuous = 1` configura o processo de captura para operação contínua;
- `pollinginterval = 5` estabelece um intervalo de *polling* de cinco segundos para a configuração observada.

Esses valores descrevem a configuração inspecionada no laboratório do Atlas Engineering. Eles não devem ser interpretados, por si só, como uma latência de dados *end-to-end* garantida de cinco segundos.

O atraso efetivo entre o `COMMIT` de uma transação na origem e a disponibilidade de seus registros do CDC depende do processamento da captura e das condições de execução.

Essa distinção foi posteriormente demonstrada diretamente por meio dos testes controlados do CDC.

### 7.2 Job de Cleanup

O *job* de *cleanup* do CDC gerencia a remoção de entradas das tabelas de alterações que excederam a janela de retenção configurada do CDC.

A configuração inicial observada de *cleanup* incluía:

```text
retention:
4320 minutos

threshold:
4999
```

Um valor de retenção de:

```text
4320 minutos
```

corresponde a:

```text
3 dias
```

Essa era a configuração de retenção do CDC do SQL Server observada antes da aplicação do requisito de recuperação do Atlas Engineering.

O *job* de *cleanup* é operacionalmente diferente do *job* de captura.

O processo de captura determina como as alterações confirmadas são representadas no CDC, enquanto o processo de *cleanup* determina quando as alterações capturadas anteriormente se tornam elegíveis para remoção de acordo com a política de retenção configurada.

Essa separação é importante porque a disponibilidade da captura e a duração da janela de recuperação representam preocupações operacionais diferentes.

### 7.3 Polling da Captura

A configuração de captura observada utilizava:

```text
pollinginterval = 5
```

Esse valor estabelece o intervalo de *polling* configurado; ele não estabelece uma garantia de entrega em cinco segundos.

A captura do CDC é assíncrona em relação à transação da aplicação.

Conceitualmente, a implementação opera por meio da seguinte sequência:

```text
Transação na origem
        ↓
COMMIT
        ↓
Log de transações contém a alteração confirmada
        ↓
Processamento da captura do CDC
        ↓
Registro de alteração do CDC torna-se disponível
```

Portanto:

```text
COMMIT
   ≠
Registro do CDC necessariamente disponível imediatamente
```

Esse comportamento é importante para o futuro consumidor porque uma consulta vazia ao CDC imediatamente após um `COMMIT` na origem não pode, por si só, ser interpretada como evidência de que a transação na origem não ocorreu.

O comportamento assíncrono não foi meramente presumido a partir da configuração do *job*. Ele foi posteriormente observado por meio de transações controladas no laboratório, nas quais o estado da origem estava confirmado antes que os registros correspondentes do CDC se tornassem visíveis.

Esses experimentos estão documentados nas seções posteriores do M01.12 ao M01.19.

### 7.4 Retenção Inicial

A retenção inicial do CDC observada durante a implementação foi:

```text
4320 minutos
=
72 horas
=
3 dias
```

Esse valor estabeleceu o estado operacional inicial, mas não foi aceito como a janela de recuperação V1 do Atlas Engineering.

O projeto trata a retenção do CDC principalmente como um *buffer* de recuperação operacional, e não como armazenamento histórico permanente.

A janela inicial de três dias exigiu, portanto, avaliação em relação às necessidades de recuperação do futuro *pipeline* de captura.

Essa avaliação resultou em uma alteração controlada e separada da configuração durante o M01.10B, na qual o período de retenção foi aumentado para:

```text
21600 minutos
=
360 horas
=
15 dias
```

A justificativa, a implementação, o problema operacional encontrado durante a alteração, a correção e a validação final estão documentados separadamente na seção de retenção do M01.10B.

Nesta etapa, a distinção importante é:

```text
Job de Captura
    → torna as alterações confirmadas disponíveis para o CDC

Job de Cleanup
    → gerencia a expiração dos dados capturados pelo CDC

Intervalo de Polling
    → configuração do processo de captura

Retenção
    → configuração da janela de recuperação
```

Esses mecanismos operam em conjunto, mas solucionam problemas operacionais diferentes.

Os *jobs* do CDC e sua configuração inicial foram identificados e documentados com sucesso como parte do *baseline* da implementação no lado da origem.

---

## 8. Partition Switching e CDC

A habilitação do CDC na tabela particionada `sales.Transaction` introduziu uma interação importante entre o CDC do SQL Server e *partition switching* de tabelas.

Essa interação exigiu avaliação explícita porque *partition switching* é uma operação baseada em metadados e não se deve presumir que se comporte como uma atividade comum de `INSERT`, `UPDATE` ou `DELETE` no nível das linhas sob a perspectiva do CDC.

O aviso observado durante o M01.10 foi, portanto, tratado como uma restrição arquitetural e operacional, em vez de ser ignorado como uma mensagem rotineira de habilitação.

### 8.1 Restrição do SQL Server

Quando o CDC foi habilitado em `sales.Transaction`, a configuração resultante manteve:

```text
allow_partition_switch = 1
```

O SQL Server apresentou um aviso sobre o uso de *partition switching* em uma tabela com CDC habilitado.

O princípio importante da implementação é que *partition switching* e DML comum capturada não possuem semânticas equivalentes no CDC.

Uma partição pode ser movida por meio de uma operação de metadados, em vez das alterações individuais de linhas normalmente esperadas por um mecanismo de captura de alterações.

Por esse motivo, a implementação do Atlas Engineering não deve presumir que:

```text
Movimentação de partição
=
Captura de alterações linha a linha pelo CDC
```

O aviso identifica, portanto, uma fronteira que deve ser explicitamente governada sempre que CDC e tabelas particionadas coexistirem.

### 8.2 Contexto de Particionamento do AtlasCommerce

`sales.Transaction` já estava particionada antes da habilitação do CDC.

O CDC não introduziu o modelo de particionamento.

A implementação teve, portanto, que considerar simultaneamente duas características existentes:

```text
sales.Transaction
│
├── Tabela particionada
│
└── Origem transacional com alta taxa de alterações
        ↓
      CDC
```

Desabilitar automaticamente *partition switching* teria alterado as capacidades operacionais de uma tabela de origem já particionada.

Permiti-lo sem governança, entretanto, poderia criar suposições incorretas sobre o que o CDC capturaria caso uma futura operação de *partition switching* fosse introduzida.

A implementação exigiu, portanto, uma decisão explícita, em vez de tratar qualquer um dos comportamentos como um padrão automático.

### 8.3 Verificação do Repositório

O repositório do AtlasCommerce foi inspecionado em busca de operações de *partition switching* implementadas.

Nenhum uso atual de:

```sql
ALTER TABLE ... SWITCH
```

foi encontrado no repositório examinado durante esta etapa da implementação.

Isso forneceu um fato importante da implementação:

```text
Capacidade de Partition Switching:
Disponível

Implementação de Partition Switching encontrada no repositório:
Não
```

O resultado reduziu o risco operacional imediato porque a implementação atual da aplicação não dependia de *partition switching* como parte de seu fluxo normal de dados.

Essa evidência está intencionalmente limitada ao estado do repositório que foi inspecionado.

Ela não comprova que *partition switching* nunca possa ser introduzido por meio de código futuro, *stored procedures* administrativas, operações de manutenção ou outros mecanismos operacionais.

### 8.4 Decisão Arquitetural

A decisão da V1 foi manter:

```text
allow_partition_switch = 1
```

ao mesmo tempo que se estabeleceu uma fronteira explícita de governança em torno das operações de *partition switching*.

A decisão pode ser resumida como:

```text
Não desabilitar uma capacidade existente sem um requisito demonstrado.

Não tratar a capacidade como segura para o CDC sem controle explícito.
```

Para a arquitetura atual:

```text
SWITCH IN
    → Não planejado como mecanismo normal de ingestão.

SWITCH OUT
    → Pode ser considerado no futuro como uma operação controlada.

DML transacional comum
    → Caminho esperado das alterações na origem para captura pelo CDC.

Partition Switching
    → Operação excepcional que exige avaliação explícita.
```

Em particular, `SWITCH IN` não deve ser introduzido como mecanismo para mover novos dados transacionais para `sales.Transaction` presumindo que o CDC exponha a movimentação como inserções equivalentes no nível das linhas.

A decisão preserva, portanto, a capacidade existente de particionamento sem incorporar *partition switching* ao contrato normal de captura do CDC.

### 8.5 Fronteira Operacional

A fronteira operacional resultante da V1 é:

```text
sales.Transaction
│
├── Particionada
├── CDC habilitado
├── allow_partition_switch = 1
│
├── Alterações normais na origem
│   └── INSERT / UPDATE / DELETE
│
└── ALTER TABLE ... SWITCH
    └── Exceção controlada — não é ingestão normal do CDC
```

Qualquer introdução futura de *partition switching* deve ser avaliada em relação ao modelo de captura do CDC antes que a operação seja aceita no ciclo de vida normal da origem.

A implementação documentada aqui não afirma ter validado experimentalmente o comportamento do CDC durante uma operação de *partition switching*.

O que foi estabelecido é mais restrito:

- `sales.Transaction` é particionada;
- o CDC foi habilitado com sucesso;
- `allow_partition_switch` permaneceu habilitado;
- o SQL Server apresentou o aviso correspondente;
- nenhuma implementação de `ALTER TABLE ... SWITCH` foi encontrada no repositório examinado;
- a V1 não utiliza `SWITCH IN` como caminho normal de ingestão;
- futuras operações de *partition switching* exigem governança explícita.

Essa distinção preserva a fronteira entre decisão arquitetural e evidência de laboratório.

O aviso de *partition switching*, portanto, não invalidou o M01.10. Ele identificou uma restrição operacional que foi avaliada, documentada e incorporada ao modelo de implementação do CDC da V1.

---

## 9. Backfill Inicial e Cutover do CDC

A habilitação do CDC estabelece uma fronteira de captura de alterações voltada para o futuro. Ela não transforma automaticamente as linhas que já existiam na tabela de origem em eventos históricos do CDC.

Isso cria um requisito importante de implementação para um sistema transacional existente como o `AtlasCommerce`: a plataforma deve estabelecer um *baseline* histórico inicial e, ao mesmo tempo, proteger as alterações que ocorram após a criação da fronteira do CDC.

O modelo de implementação resultante separa o *backfill* inicial da captura contínua do CDC.

### 9.1 Por que o CDC Não Substitui o Backfill Inicial

Antes da habilitação do CDC, o *baseline* do M01.08 registrou:

```text
sales.Transaction:
6,306 linhas

sales.TransactionItem:
13,769 linhas
```

Essas linhas existiam antes de as respectivas tabelas entrarem em suas fronteiras de captura do CDC.

A habilitação do CDC não reconstrói retroativamente a sequência histórica de operações que produziu essas linhas.

Portanto:

```text
Linhas existentes na origem
        ≠
Eventos históricos do CDC
```

O estado inicial da origem e o futuro fluxo de alterações representam duas responsabilidades diferentes de ingestão.

As linhas existentes exigem um *backfill* inicial, enquanto as alterações que ocorrem após a fronteira do CDC são tratadas por meio do CDC.

Essa distinção também impede que a plataforma invente semânticas históricas que não estão disponíveis na origem.

Por exemplo, o estado atual de uma transação existente não fornece evidências suficientes para reconstruir todas as transições de estado anteriores que ocorreram antes da habilitação do CDC.

### 9.2 Baseline Histórico

O *backfill* inicial representa o estado conhecido da origem no início do ciclo de vida de captura do Atlas Engineering.

Para o escopo transacional estabelecido durante o M01.08, o *baseline* era:

| Tabela de Origem | Linhas Existentes |
|---|---:|
| `sales.Transaction` | 6,306 |
| `sales.TransactionItem` | 13,769 |

Essas linhas formam o conjunto de dados inicial do estado atual que deverá, posteriormente, ser incorporado à plataforma de dados.

O *baseline* deve, portanto, ser interpretado como:

```text
O que se sabe existir no ponto inicial de ingestão
```

em vez de:

```text
Uma reconstrução de tudo o que aconteceu antes do CDC
```

Essa distinção preserva a integridade do modelo histórico.

Se o histórico de eventos anterior ao CDC não foi capturado por uma fonte autoritativa, o Atlas Engineering não deve fabricar esse histórico a partir do estado atual das linhas.

### 9.3 Princípio de Cutover

O princípio de *cutover* da V1 é:

```text
Proteger primeiro o futuro e, depois, carregar o passado.
```

A sequência foi intencionalmente projetada para reduzir o risco de criar uma lacuna silenciosa de captura entre a carga histórica e o início do processamento incremental.

Conceitualmente:

```text
1. Estabelecer a fronteira do CDC
        ↓
2. Proteger futuras alterações na origem
        ↓
3. Carregar o baseline conhecido do estado atual
        ↓
4. Processar o CDC acumulado após a fronteira
        ↓
5. Reconciliar a sobreposição
        ↓
6. Entrar em operação incremental normal
```

Essa abordagem evita depender da suposição de que a origem permanecerá inalterada enquanto o *baseline* histórico estiver sendo carregado.

Para um sistema OLTP ativo, tal suposição criaria um período no qual alterações poderiam ocorrer sem serem representadas nem na carga histórica concluída nem no fluxo incremental.

### 9.4 Sobreposição Controlada

O modelo de *cutover* prefere deliberadamente uma sobreposição controlada a uma lacuna silenciosa.

Os dois riscos são fundamentalmente diferentes:

```text
Sobreposição controlada
    → o mesmo estado lógico pode ser encontrado tanto pelo backfill quanto pelo processamento incremental;
    → pode ser detectado e reconciliado por meio de processamento determinístico e idempotência.

Lacuna silenciosa
    → alterações na origem podem não pertencer a nenhum dos caminhos de ingestão;
    → dados podem ser permanentemente perdidos sem uma fonte explícita de recuperação.
```

Para o Atlas Engineering, a direção arquitetural mais segura é, portanto:

```text
Sobreposição conhecida
    >
Dados ausentes desconhecidos
```

Isso não significa que a idempotência *end-to-end* já tenha sido implementada ou validada.

No estágio atual da implementação, a sobreposição controlada é o princípio de *cutover*. Os mecanismos subsequentes necessários para reconciliar essa sobreposição pertencem às etapas de implementação do consumo e da ingestão do CDC e exigem suas próprias evidências.

### 9.5 Semântica Histórica

O *backfill* inicial e o fluxo do CDC representam semânticas históricas diferentes e devem permanecer distinguíveis subsequentemente.

Metadados candidatos de ingestão para preservar essa distinção incluem:

```text
ingestion_mode = INITIAL_BACKFILL
```

para linhas introduzidas por meio do *baseline* histórico inicial, e:

```text
ingestion_mode = CDC_STREAM
```

para alterações introduzidas por meio do processamento contínuo do CDC.

Esses valores representam metadados candidatos da plataforma para o futuro modelo de ingestão; eles não são apresentados aqui como campos subsequentes já implementados.

A fronteira semântica é o requisito importante:

```text
INITIAL BACKFILL
    → estado conhecido da origem carregado a partir de linhas já existentes

CDC STREAM
    → alterações capturadas que ocorrem dentro do ciclo de vida do CDC
```

Isso impede que a plataforma represente falsamente um *snapshot* inicial do estado atual como se fosse uma sequência de eventos históricos da origem.

O modelo resultante é:

```text
                    Fronteira do CDC
                         │
                         │
Passado                   │                     Futuro
─────────────────────────┼──────────────────────────────
                         │
Estado existente da origem│   Novas alterações confirmadas
        │                │            │
        ▼                │            ▼
Backfill Inicial         │       Captura do CDC
        │                │            │
        └──────────────┐ │ ┌──────────┘
                       ▼ ▼ ▼
                  Sobreposição
                   controlada
                       │
                       ▼
                  Reconciliação
                       │
                       ▼
                Operação incremental
                     normal
```

A implementação estabelece, portanto, uma separação clara entre a carga do *baseline* histórico e a captura de alterações voltada para o futuro.

O CDC captura alterações elegíveis na origem a partir da fronteira de captura estabelecida. O *backfill* inicial fornece o estado conhecido que existia antes dessa fronteira. Nenhum dos mecanismos deve ser utilizado para inventar um histórico da origem que nunca foi capturado.

A execução efetiva desse modelo de *cutover*, incluindo *checkpointing*, reconciliação da sobreposição, idempotência e persistência durável nas etapas subsequentes, permanece fora da evidência estabelecida até o M01.19 e exige validação durante as etapas subsequentes da implementação.

---

## 10. Retenção do CDC — M01.10B

Após a inspeção da configuração operacional inicial do CDC, a janela de retenção de *cleanup* exigiu avaliação explícita.

A retenção padrão observada era de três dias. Para a V1 do Atlas Engineering, esse período foi considerado insuficiente como *buffer* de recuperação operacional para interrupções que pudessem se estender por vários dias.

O M01.10B estabeleceu e validou, portanto, uma janela de retenção do CDC mais longa.

### 10.1 Retenção Padrão

A configuração inicial do *job* de *cleanup* observada durante o M01.10 era:

```text
retention:
4320 minutos

threshold:
4999
```

O valor de retenção corresponde a:

```text
4320 minutos
=
72 horas
=
3 dias
```

Esse valor determina por quanto tempo os dados capturados pelo CDC permanecem disponíveis antes de se tornarem elegíveis para *cleanup*, de acordo com o processo de *cleanup* do CDC.

A configuração de três dias foi tratada como o ponto de partida observado, em vez de ser automaticamente aceita como o requisito de recuperação do Atlas Engineering.

### 10.2 Requisito de Recuperação

A retenção do CDC é tratada no Atlas Engineering como um *buffer* de recuperação operacional.

Seu objetivo é fornecer tempo suficiente para que a plataforma se recupere de uma interrupção antes que as alterações necessárias da origem se tornem indisponíveis nas tabelas de alterações do CDC.

O modelo de planejamento da V1 considerou um cenário de recuperação composto aproximadamente por:

```text
Possível ausência prolongada:
10 dias

Diagnóstico:
2 dias

Reparo e reprocessamento:
3 dias

Janela total de recuperação:
15 dias
```

O objetivo desse cálculo não é prever que todos os incidentes seguirão exatamente essa linha do tempo.

Ele estabelece uma margem deliberada de recuperação substancialmente maior que a configuração inicial de três dias.

O requisito resultante da V1 foi:

```text
Retenção do CDC:
15 dias
```

### 10.3 Decisão de Retenção da V1

O valor de retenção selecionado foi:

```text
21600 minutos
=
360 horas
=
15 dias
```

Essa decisão estabelece o CDC como uma fonte temporária de recuperação operacional, e não como um repositório histórico permanente.

A responsabilidade pretendida é:

```text
CDC do SQL Server
    → disponibilidade temporária de alterações
    → buffer de recuperação operacional
```

A futura camada durável da plataforma de dados é responsável por preservar os dados capturados além do período de retenção do CDC na origem.

Portanto:

```text
Retenção do CDC
    ≠
Retenção histórica permanente
```

A janela de quinze dias fornece capacidade de recuperação na fronteira da origem, evitando o erro arquitetural de tratar as tabelas de alterações do CDC do SQL Server como o armazenamento histórico permanente do Atlas Engineering.

### 10.4 Implementação

A configuração de retenção do *job* de *cleanup* foi alterada utilizando:

```sql
EXEC sys.sp_cdc_change_job
    @job_type = N'cleanup',
    @retention = 21600;
```

A alteração essencial da configuração foi:

```text
retention:
4320
    ↓
21600 minutos
```

Após a alteração, a configuração de *cleanup* observada era:

```text
retention:
21600 minutos

threshold:
4999
```

O *threshold* permaneceu:

```text
4999
```

A sequência completa de execução e validação é mantida no *script* SQL correspondente ao M01.10B.

### 10.5 Erro Operacional do Job de Cleanup

Durante o procedimento operacional, foi realizada uma tentativa de interromper o *job* de *cleanup* do CDC.

O SQL Server retornou:

```text
Msg 22022

Request to stop job cdc.AtlasCommerce_cleanup refused
because the job is not currently running.
```

Essa mensagem foi encontrada inicialmente durante o procedimento controlado de alteração da retenção e exigiu interpretação antes de prosseguir.

Era importante não classificar automaticamente a mensagem como uma falha na implementação do CDC.

### 10.6 Causa Raiz

O *job* de *cleanup* é periódico e não está necessariamente em execução no exato momento em que um *script* administrativo tenta interrompê-lo.

A solicitação de interrupção encontrou, portanto, um *job* que já não estava em execução.

Conceitualmente:

```text
STOP solicitado
      │
      ▼
O job de cleanup está em execução?
      │
      └── NÃO
           │
           ▼
SQL Server recusa a solicitação de STOP
porque não há execução em andamento para interromper
```

O erro não demonstrou uma falha na captura do CDC, na configuração de *cleanup* ou na retenção.

Ele demonstrou que o *script* operacional fez uma suposição sobre o estado atual de execução do *job* do SQL Server Agent.

O problema estava, portanto, associado à lógica de controle operacional, e não ao próprio CDC.

### 10.7 Correção

A lição operacional resultante da solicitação de interrupção que falhou foi que *scripts* de controle de *jobs* devem verificar o estado de execução antes de emitir um comando de interrupção.

O padrão de controle mais seguro é:

```text
Identificar o job
      ↓
Inspecionar o estado atual de execução
      ↓
Em execução?
  │          │
 SIM         NÃO
  │          │
  ▼          ▼
STOP       Não solicitar
job        STOP
```

Isso evita tratar um *job* periódico que já esteja parado como uma condição excepcional do CDC.

O *job* de *cleanup* foi posteriormente iniciado conforme exigido pelo procedimento controlado, e o valor de retenção configurado foi validado.

A correção preservou, portanto, a configuração pretendida do CDC, ao mesmo tempo que aprimorou o entendimento operacional sobre o controle de *jobs* do SQL Server Agent.

### 10.8 Resultado Observado

Após a conclusão e validação da configuração de retenção, o estado observado do *job* de *cleanup* incluía:

```text
retention:
21600 minutos

threshold:
4999
```

A transição efetiva da retenção foi:

```text
3 dias
   ↓
15 dias
```

A implementação do M01.10B estabeleceu, portanto, a janela de recuperação do CDC pretendida para a V1.

A `Msg 22022` encontrada durante o procedimento não invalidou o resultado porque sua causa raiz foi identificada como uma tentativa de interromper um *job* que não estava em execução, e não como uma falha na aplicação da configuração de retenção.

### 10.9 Atualização dos Dados vs. Janela de Recuperação

A retenção do CDC e a atualização dos dados solucionam problemas operacionais diferentes e não devem ser combinadas em um único requisito.

Para a V1 do Atlas Engineering:

```text
Atualização dos Dados
    → com que rapidez as alterações confirmadas na origem devem tornar-se disponíveis para os processos subsequentes

Janela de Recuperação
    → por quanto tempo as alterações capturadas na origem permanecem disponíveis para recuperação
```

Os objetivos arquiteturais atuais distinguem essas dimensões:

```text
Atualização típica dos dados:
aproximadamente 3–5 minutos

Objetivo formal P95 de atualização:
≤ 15 minutos

Retenção do CDC:
15 dias
```

O valor de retenção de quinze dias não significa que se espera que os dados levem quinze dias para chegar à plataforma.

Da mesma forma, um objetivo de captura de baixa latência não elimina a necessidade de uma janela de recuperação suficientemente ampla.

Eles representam dimensões diferentes de confiabilidade:

```text
Atualização
    → minutos

Capacidade de recuperação
    → dias
```

Os valores de atualização são objetivos arquiteturais e não devem ser apresentados como medições de produção estabelecidas pelo laboratório de CDC.

O laboratório demonstrou o comportamento assíncrono do CDC, mas a latência *end-to-end* em produção permanece fora da evidência estabelecida até o M01.19.

### 10.10 Conclusão

O M01.10B alterou a retenção de *cleanup* do CDC do SQL Server da configuração inicial de três dias para a janela de recuperação de quinze dias da V1 do Atlas Engineering:

```text
4320 minutos
      ↓
21600 minutos
```

A configuração resultante foi validada com:

```text
retention = 21600
threshold = 4999
```

A implementação também expôs um problema de *script* operacional quando uma solicitação de interrupção foi emitida contra um *job* de *cleanup* que não estava em execução naquele momento.

A `Msg 22022` resultante foi diagnosticada como um problema de controle de estado do *job*, e não como uma falha do CDC, estabelecendo uma regra operacional importante: *scripts* que controlam *jobs* do SQL Server Agent devem verificar o estado atual de execução antes de solicitar uma interrupção.

Por fim, a implementação preserva uma distinção rigorosa entre retenção do CDC e atualização dos dados.

A retenção do CDC fornece um *buffer* temporário de recuperação. Ela não é armazenamento histórico permanente, e sua duração de quinze dias é independente do objetivo de atualização dos dados da plataforma na escala de minutos.

**Status do M01.10B: APROVADO**

---

## 11. Anatomia da Tabela de Alterações — M01.11

Com o CDC habilitado em `sales.Transaction`, a próxima etapa foi inspecionar a estrutura física e lógica criada pelo SQL Server para as alterações capturadas.

O M01.11 concentrou-se em `cdc.sales_Transaction_CT`, a tabela de alterações associada à instância de captura `sales_Transaction`.

O objetivo ainda não era gerar alterações na origem, mas compreender a estrutura na qual os eventos subsequentes de `INSERT`, `UPDATE` e `DELETE` seriam capturados.

### 11.1 Tabela de Alterações

A habilitação do CDC no nível da tabela realizada no M01.10 criou:

```text
cdc.sales_Transaction_CT
```

Essa tabela combina metadados do CDC com os valores capturados das colunas da origem.

Conceitualmente:

```text
cdc.sales_Transaction_CT
│
├── Colunas de metadados do CDC
│
└── Colunas capturadas da origem
```

A tabela de alterações é uma estrutura gerenciada pelo CDC e não deve ser interpretada como uma réplica do projeto físico ou do modelo de restrições da tabela de origem.

Seu objetivo é representar as alterações capturadas juntamente com os metadados necessários para identificar e interpretar essas alterações.

### 11.2 Colunas de Metadados do CDC

A inspeção de `cdc.sales_Transaction_CT` identificou as seguintes colunas de metadados do CDC:

```text
__$start_lsn
__$end_lsn
__$seqval
__$operation
__$update_mask
__$command_id
```

Essas colunas fornecem o contexto de transação e de operação necessário para interpretar as linhas capturadas.

Suas funções no modelo de transação podem ser resumidas como:

```text
__$start_lsn
    → contexto do log de transações utilizado para correlacionar
      alterações pertencentes à transação capturada

__$command_id
    → distingue comandos observados dentro
      da mesma transação

__$seqval
    → fornece informações de sequenciamento para
      as alterações capturadas

__$operation
    → identifica a operação da imagem de linha do CDC

__$update_mask
    → identifica as colunas da origem declaradas
      como afetadas por um UPDATE

__$end_lsn
    → metadado do CDC não utilizado pelo Atlas Engineering
      como base principal para ordenação de negócio
      ou correlação de transações
```

A semântica detalhada desses campos foi progressivamente validada por meio dos testes controlados do M01.12 ao M01.19.

O M01.11 estabeleceu sua presença física; experimentos posteriores forneceram as evidências necessárias para interpretar seu comportamento em transações reais.

### 11.3 Colunas Capturadas da Origem

Além das colunas de metadados do CDC, a tabela de alterações continha as nove colunas da origem configuradas para a instância de captura `sales_Transaction`.

A estrutura resultante pode, portanto, ser representada conceitualmente como:

```text
cdc.sales_Transaction_CT
│
├── __$start_lsn
├── __$end_lsn
├── __$seqval
├── __$operation
├── __$update_mask
│
├── colunas capturadas de sales.Transaction
│
└── __$command_id
```

Os valores capturados da origem fornecem a imagem da linha associada a cada operação do CDC.

Sua interpretação depende de `__$operation`.

Por exemplo, testes controlados subsequentes demonstraram que um `UPDATE` pode produzir imagens de linha separadas de antes e depois, enquanto `INSERT` e `DELETE` utilizam códigos de operação diferentes.

### 11.4 Índice Físico

A tabela de alterações continha um índice *clustered unique* com a seguinte ordem de chaves:

```text
__$start_lsn
__$command_id
__$seqval
__$operation
```

Conceitualmente:

```text
Índice Clustered Unique
        │
        ├── 1. __$start_lsn
        ├── 2. __$command_id
        ├── 3. __$seqval
        └── 4. __$operation
```

Essa estrutura física é consistente com a necessidade de distinguir múltiplos registros capturados pelo contexto da transação, sequenciamento de comandos e semântica da operação.

Entretanto, a existência e a ordem das chaves do índice físico não devem ser tratadas como substitutas da semântica documentada do CDC ou de um modelo explícito de ordenação do consumidor.

O futuro consumidor deve utilizar deliberadamente os metadados do CDC, em vez de inferir seu contrato de processamento de negócio exclusivamente a partir da ordem física de armazenamento.

### 11.5 Nulabilidade da Origem vs. Nulabilidade da Tabela de Alterações

A inspeção revelou uma diferença estrutural importante entre a tabela de origem e sua tabela de alterações do CDC.

Colunas definidas como `NOT NULL` em `sales.Transaction` podem aparecer como anuláveis em:

```text
cdc.sales_Transaction_CT
```

Portanto:

```text
Modelo de restrições da origem
        ≠
Modelo de restrições da tabela de alterações do CDC
```

Isso não significa que a coluna original da origem tenha se tornado anulável.

A tabela de alterações do CDC é uma estrutura de captura projetada para representar alterações na origem. Ela não se destina a reproduzir todas as restrições da tabela de origem.

Um consumidor subsequente não deve, portanto, inferir as regras de nulabilidade da origem exclusivamente a partir dos metadados físicos de nulabilidade da tabela de alterações do CDC.

A semântica do *schema* da origem e a semântica de armazenamento do CDC devem permanecer distintas.

### 11.6 Estado Inicial da Tabela de Alterações

Imediatamente após o CDC ser habilitado em `sales.Transaction`, a tabela de alterações continha:

```text
change_rows = 0
```

Ao mesmo tempo, o *baseline* da origem estabelecia:

```text
sales.Transaction rows = 6,306
```

A observação resultante foi:

```text
Origem:
6,306 linhas existentes

Tabela de alterações do CDC:
0 linhas
```

Isso forneceu evidência direta de que a habilitação do CDC não populou automaticamente a tabela de alterações com as linhas que já existiam em `sales.Transaction`.

Portanto:

```text
Habilitação do CDC
        ≠
Backfill histórico automático
```

Essa observação sustenta a separação estabelecida no modelo de *backfill* inicial e *cutover*:

```text
Estado existente da origem
    → Backfill Inicial

Alterações após a fronteira do CDC
    → CDC
```

### 11.7 Semântica dos Metadados do CDC

O significado completo dos metadados do CDC não pôde ser estabelecido apenas a partir da anatomia da tabela.

Os experimentos controlados realizados após o M01.11 demonstraram progressivamente o seguinte modelo:

```text
__$start_lsn
    → contexto de transação compartilhado pelas alterações observadas na mesma transação SQL

__$command_id
    → distingue múltiplos comandos dentro dessa transação

__$seqval
    → contribui com informações de sequenciamento para as alterações capturadas

__$operation
    → identifica o tipo de imagem de linha capturada

__$update_mask
    → representa as colunas declaradas como afetadas por um UPDATE
```

Os valores de operação observados e utilizados ao longo do laboratório foram:

| `__$operation` | Significado no CDC |
|---:|---|
| `1` | `DELETE` |
| `2` | `INSERT` |
| `3` | `UPDATE_BEFORE` |
| `4` | `UPDATE_AFTER` |

Para um `UPDATE`, os experimentos posteriores demonstraram uma representação em pares:

```text
UPDATE
  │
  ├── operation = 3
  │      UPDATE_BEFORE
  │
  └── operation = 4
         UPDATE_AFTER
```

As imagens correspondentes de antes e depois foram observadas com o mesmo contexto de transação e comando.

Esse comportamento torna-se particularmente importante quando múltiplos comandos e múltiplas tabelas com CDC habilitado participam da mesma transação SQL.

Esses casos são documentados separadamente no M01.14 e do M01.17 ao M01.19.

O Atlas Engineering não constrói seu modelo de correlação de transações ou ordenação de negócio em torno de `__$end_lsn`.

A implementação concentra-se, em vez disso, nos metadados do CDC cujo comportamento foi diretamente exercitado e correlacionado durante o ciclo controlado de laboratório.

### 11.8 Conclusão

O M01.11 estabeleceu a anatomia da tabela de alterações do CDC de `sales.Transaction` antes da introdução de alterações controladas na origem.

A inspeção confirmou que `cdc.sales_Transaction_CT` contém tanto os metadados do CDC quanto as nove colunas capturadas da origem, com um índice *clustered unique* ordenado por:

```text
__$start_lsn
__$command_id
__$seqval
__$operation
```

A implementação também confirmou que a tabela de alterações não reproduz diretamente o modelo de restrições da origem, incluindo a nulabilidade das colunas da origem.

Mais importante, a tabela de alterações continha zero linhas capturadas, apesar de `sales.Transaction` já conter 6,306 linhas.

Isso forneceu evidência direta de que o CDC do SQL Server não realiza automaticamente o *backfill* do estado existente da origem quando a captura é habilitada.

O M01.11 estabeleceu, portanto, a base estrutural necessária para interpretar os experimentos controlados de `INSERT`, `UPDATE` e `DELETE` que se seguiram.

**Status do M01.11: APROVADO**

---

## 12. INSERT Controlado — M01.12

Após a inspeção da estrutura da tabela de alterações do CDC, a próxima etapa foi gerar a primeira alteração controlada na origem e observar como o CDC do SQL Server a representava.

O M01.12 utilizou um `INSERT` controlado em `sales.Transaction` para validar o primeiro caminho completo entre uma transação confirmada na origem e um registro capturado pelo CDC.

O teste também forneceu a primeira evidência direta de laboratório de que a captura do CDC é assíncrona em relação ao `COMMIT` da transação na origem.

### 12.1 Objetivo

O objetivo do M01.12 foi validar:

- que uma nova linha confirmada em `sales.Transaction` fosse capturada pelo CDC;
- como um `INSERT` era representado em `cdc.sales_Transaction_CT`;
- qual código de operação do CDC representava a linha inserida;
- a representação da máscara de atualização produzida para o `INSERT`;
- a relação entre o `COMMIT` na origem e a disponibilidade no CDC;
- a distinção entre o tempo do evento de negócio na origem e o tempo da transação no CDC.

O teste foi intencionalmente controlado para que a linha resultante na origem pudesse ser correlacionada diretamente com sua representação no CDC.

### 12.2 Transação de Teste

A transação controlada criou:

```text
TRN_id:
6307

Status:
PENDING

Canal:
ONLINE

Valor Bruto:
100

Valor do Desconto:
10
```

A transação foi confirmada na origem antes da inspeção da tabela de alterações do CDC.

O teste estabeleceu, portanto, uma sequência clara:

```text
INSERT controlado
        ↓
COMMIT
        ↓
Linha existe na origem
        ↓
Inspecionar CDC
```

O objetivo não era apenas determinar se a linha eventualmente apareceria no CDC, mas também inspecionar sua disponibilidade imediatamente após o `COMMIT` e novamente após permitir tempo para o processamento da captura.

### 12.3 Resultado Esperado

Para um `INSERT` na origem capturado com sucesso, a representação esperada no CDC era um novo registro na tabela de alterações contendo os valores inseridos na origem juntamente com os metadados do CDC que identificavam a operação como uma inserção.

O modelo lógico esperado era:

```text
sales.Transaction
        │
        │ INSERT + COMMIT
        ▼
Log de Transações
        │
        ▼
Captura do CDC
        │
        ▼
cdc.sales_Transaction_CT
        │
        └── Imagem da linha do INSERT
```

Como a captura do CDC opera de forma assíncrona, o teste não presumiu que a linha do CDC precisaria estar disponível no exato momento em que a transação na origem fosse confirmada.

As observações imediata e posterior foram, portanto, tratadas como *checkpoints* separados.

### 12.4 Observação Imediatamente Após a Confirmação

Imediatamente após a confirmação da transação na origem, a linha inserida existia em `sales.Transaction`.

Entretanto, a inspeção do CDC retornou:

```text
matching_change_rows = 0
```

Portanto, naquele ponto de observação:

```text
Transação na origem:
CONFIRMADA

Linha na origem:
DISPONÍVEL

Linha correspondente no CDC:
AINDA NÃO DISPONÍVEL
```

Esse resultado não foi tratado como falha de captura.

Em vez disso, ele estabeleceu a primeira evidência direta de que a confirmação bem-sucedida na origem e a disponibilidade da linha no CDC são momentos distintos.

Conceitualmente:

```text
COMMIT
   │
   ├── Estado da origem torna-se confirmado
   │
   └── Registro do CDC ainda pode estar aguardando captura
```

### 12.5 Observação Após a Captura

O teste controlado aguardou aproximadamente seis segundos para o processamento da captura do CDC antes de inspecionar novamente a tabela de alterações.

Após esse intervalo:

```text
matching_change_rows = 1
```

A transação inserida estava agora representada em:

```text
cdc.sales_Transaction_CT
```

A sequência observada foi, portanto:

```text
INSERT
   ↓
COMMIT
   ↓
Inspeção imediata do CDC
   ↓
0 linhas correspondentes
   ↓
Aproximadamente 6 segundos
   ↓
Inspeção do CDC
   ↓
1 linha correspondente
```

Essa observação foi consistente com a configuração do *job* de captura inspecionada anteriormente:

```text
continuous = 1
pollinginterval = 5
```

Entretanto, a observação de aproximadamente seis segundos no laboratório não deve ser interpretada como uma latência garantida do CDC.

O teste demonstrou comportamento de captura assíncrona sob as condições observadas no laboratório, e não um objetivo de nível de serviço para latência em produção.

### 12.6 Representação do INSERT

A linha capturada foi representada com:

```text
__$operation = 2
```

No modelo de operações do CDC:

```text
1 = DELETE
2 = INSERT
3 = UPDATE_BEFORE
4 = UPDATE_AFTER
```

Portanto, a transação controlada confirmou:

```text
INSERT na origem
      ↓
operação do CDC = 2
```

O registro capturado preservou a imagem da linha inserida na origem juntamente com seus metadados do CDC.

A máscara de atualização observada foi:

```text
__$update_mask = 0x01FF
```

Para esse `INSERT`, a máscara correspondia ao conjunto completo das nove colunas capturadas da origem.

O identificador de comando observado foi:

```text
__$command_id = 1
```

Esses valores de metadados estabeleceram o primeiro registro concreto do CDC que poderia ser utilizado como *baseline* para comparação com as transações mais complexas de atualização e múltiplos comandos testadas posteriormente.

### 12.7 Evidência de Captura Assíncrona

O M01.12 estabeleceu uma distinção importante entre três conceitos diferentes de tempo que futuramente coexistirão na plataforma de dados.

A transação na origem continha seu próprio *timestamp* do evento de negócio:

```text
TRN_transaction_at
```

O CDC fornece um mapeamento do tempo da transação por meio do LSN capturado, utilizando mecanismos como:

```text
sys.fn_cdc_map_lsn_to_time(...)
```

Um futuro *pipeline* de ingestão do Atlas Engineering também terá seu próprio tempo de ingestão na plataforma.

Esses conceitos devem permanecer distintos:

```text
Tempo do Evento de Negócio
        │
        └── Quando o evento de negócio é representado como ocorrido no domínio de origem

Tempo da Transação no CDC
        │
        └── Tempo associado à transação capturada por meio dos metadados do CDC

Tempo de Ingestão na Plataforma
        │
        └── Quando a futura plataforma de dados recebe ou persiste a alteração
```

Portanto:

```text
Tempo do Evento de Negócio
        ≠
Tempo da Transação no CDC
        ≠
Tempo de Ingestão na Plataforma
```

O M01.12 observou diretamente os dois primeiros conceitos.

O terceiro permanece como parte da futura implementação de ingestão e não deve ser apresentado como já validado.

### 12.8 Conclusão

O M01.12 produziu e capturou com sucesso o primeiro `INSERT` controlado para `sales.Transaction`.

A transação de teste criou `TRN_id = 6307`, e a linha confirmada estava inicialmente ausente da tabela de alterações do CDC:

```text
matching_change_rows = 0
```

Após aproximadamente seis segundos, o registro correspondente do CDC estava disponível:

```text
matching_change_rows = 1
```

O registro capturado foi representado como:

```text
__$operation   = 2
__$update_mask = 0x01FF
__$command_id  = 1
```

O experimento estabeleceu, portanto, evidência direta de laboratório para dois comportamentos fundamentais do CDC:

```text
INSERT confirmado
    → capturado como operação 2

COMMIT na origem
    → não exige disponibilidade imediata no CDC
```

O atraso observado demonstra captura assíncrona sob as condições controladas do laboratório. Ele não estabelece uma latência de captura fixa ou garantida em produção.

O M01.12 também estabeleceu a necessidade de preservar semânticas distintas para o tempo do evento de negócio, o tempo da transação no CDC e o futuro tempo de ingestão na plataforma.

**Status do M01.12: APROVADO**

---

## 13. UPDATE Controlado — M01.13

Após validar o primeiro `INSERT` controlado, o experimento seguinte examinou como o CDC do SQL Server representa um `UPDATE`.

O M01.13 atualizou a transação criada durante o M01.12 e inspecionou os registros resultantes no CDC.

O experimento foi particularmente importante porque uma atualização não é representada como uma única linha de substituição no modelo configurado de todas as alterações do CDC. Em vez disso, o SQL Server preserva tanto o estado anterior à alteração quanto o estado posterior à alteração.

### 13.1 Objetivo

O objetivo do M01.13 foi validar:

- como um `UPDATE` é representado na tabela de alterações do CDC;
- se tanto a imagem anterior quanto a imagem resultante da linha são preservadas;
- os códigos de operação associados a essas imagens;
- se ambas as imagens podem ser correlacionadas ao mesmo comando na origem;
- como `__$update_mask` representa as colunas afetadas pela atualização.

O teste controlado reutilizou:

```text
TRN_id = 6307
```

que havia sido inserido e capturado durante o M01.12.

### 13.2 Estado da Linha Antes do UPDATE

A atualização controlada alterou o *status* da transação de:

```text
PENDING
```

para:

```text
CONFIRMED
```

A atualização também afetou o *timestamp* de atualização da transação.

Conceitualmente, a transição na origem foi:

```text
TRN_id = 6307

Antes
│
├── Status = PENDING
└── updated_at anterior
        │
        │ UPDATE
        ▼
Depois
│
├── Status = CONFIRMED
└── Novo updated_at
```

A transação foi confirmada antes da avaliação dos registros correspondentes no CDC.

### 13.3 Imagens UPDATE BEFORE e AFTER

O CDC representou a atualização na origem utilizando duas linhas da tabela de alterações.

O primeiro registro utilizou:

```text
__$operation = 3
```

e representou:

```text
UPDATE_BEFORE
```

O segundo utilizou:

```text
__$operation = 4
```

e representou:

```text
UPDATE_AFTER
```

O modelo resultante foi:

```text
UPDATE na origem
      │
      ▼
┌────────────────────────────┐
│ CDC UPDATE_BEFORE          │
│ __$operation = 3           │
│ Status = PENDING           │
└────────────────────────────┘
              +
┌────────────────────────────┐
│ CDC UPDATE_AFTER           │
│ __$operation = 4           │
│ Status = CONFIRMED         │
└────────────────────────────┘
```

Os dois registros preservam, portanto, a transição, em vez de apenas o estado final da origem.

Isso é fundamentalmente diferente de consultar a tabela de origem após a atualização, onde apenas o estado resultante `CONFIRMED` permanece visível.

### 13.4 Máscara de Atualização

A máscara de atualização observada para a operação foi:

```text
__$update_mask = 0x0108
```

A máscara correspondia às colunas afetadas pela atualização controlada:

```text
TRN_TRNST_id
TRN_updated_at
```

A observação demonstrou que `__$update_mask` fornece metadados sobre as colunas capturadas declaradas como afetadas pela operação de atualização.

Conceitualmente:

```text
UPDATE
│
├── TRN_TRNST_id
└── TRN_updated_at
        │
        ▼
__$update_mask = 0x0108
```

A máscara deve, portanto, ser interpretada em relação ao mapeamento ordinal das colunas capturadas para a instância de captura, e não como um identificador de negócio independente.

### 13.5 Resultado Observado

As duas linhas do CDC que representavam a atualização compartilhavam o mesmo contexto de transação e comando.

A relação observada foi:

```text
UPDATE_BEFORE
│
├── __$operation = 3
├── __$start_lsn = mesmo
├── __$command_id = mesmo
├── __$seqval = mesmo
└── __$update_mask = 0x0108

UPDATE_AFTER
│
├── __$operation = 4
├── __$start_lsn = mesmo
├── __$command_id = mesmo
├── __$seqval = mesmo
└── __$update_mask = 0x0108
```

O metadado que distinguia as imagens de linha emparelhadas era, portanto, o código da operação:

```text
3 → estado antes do UPDATE
4 → estado depois do UPDATE
```

Os metadados compartilhados, por sua vez, permitiam que ambos os registros fossem interpretados como duas imagens da mesma operação de atualização.

Para a transição controlada de *status*:

```text
PENDING
   │
   │ UPDATE
   ▼
CONFIRMED
```

O CDC preservou:

```text
PENDING      → operação 3
CONFIRMED    → operação 4
```

Isso forneceu evidência direta de que o modelo configurado de todas as alterações do CDC preserva ambos os lados da transição de estado na origem.

### 13.6 Conclusão

O M01.13 validou com sucesso a representação no CDC de um `UPDATE` controlado em `sales.Transaction`.

A transição de *status*:

```text
PENDING
    ↓
CONFIRMED
```

produziu dois registros no CDC:

```text
operação 3 → UPDATE_BEFORE
operação 4 → UPDATE_AFTER
```

Ambos os registros compartilhavam os mesmos:

```text
__$start_lsn
__$command_id
__$seqval
__$update_mask
```

e a máscara de atualização observada:

```text
0x0108
```

identificou as colunas capturadas afetadas:

```text
TRN_TRNST_id
TRN_updated_at
```

O experimento estabeleceu, portanto, que uma atualização no CDC deve ser interpretada como um par correlacionado de antes/depois, e não como duas alterações de negócio independentes.

Esse modelo de transação torna-se cada vez mais importante quando múltiplos comandos de `UPDATE` são executados dentro da mesma transação SQL, comportamento avaliado no M01.14.

**Status do M01.13: APROVADO**

---

## 14. Múltiplos Comandos de UPDATE em uma Única Transação — M01.14

Após validar a representação de antes e depois de um único `UPDATE`, o experimento seguinte aumentou a complexidade transacional.

O M01.14 executou múltiplos comandos de `UPDATE` na mesma linha de `sales.Transaction` dentro de uma única transação SQL.

O objetivo foi determinar como o CDC distingue comandos separados na origem enquanto preserva seu contexto comum de transação.

### 14.1 Objetivo

O objetivo do M01.14 foi validar:

- se múltiplos comandos de `UPDATE` executados dentro de uma única transação SQL compartilham o mesmo contexto de transação no CDC;
- como comandos separados dentro dessa transação são distinguidos;
- se cada atualização produz seu próprio par `UPDATE_BEFORE` e `UPDATE_AFTER`;
- como `__$command_id` se comporta entre múltiplos comandos;
- como `__$update_mask` difere de acordo com as colunas afetadas por cada comando;
- como os metadados do CDC podem ser utilizados para reconstruir a estrutura de uma transação com múltiplos comandos.

O experimento controlado continuou com:

```text
TRN_id = 6307
```

cujo estado anterior havia sido estabelecido por meio do M01.12 e M01.13.

### 14.2 Estrutura da Transação

Dois comandos separados de `UPDATE` foram executados dentro de uma única transação SQL.

O primeiro comando alterou o *status* da transação de:

```text
CONFIRMED
```

para:

```text
COMPLETED
```

e também afetou o *timestamp* de atualização da transação.

O segundo comando alterou os valores monetários de:

```text
Valor Bruto:
100

Valor do Desconto:
10
```

para:

```text
Valor Bruto:
105

Valor do Desconto:
15
```

e também afetou o *timestamp* de atualização da transação.

Conceitualmente:

```text
BEGIN TRANSACTION
│
├── Comando 1
│   └── UPDATE status + updated_at
│
├── Comando 2
│   └── UPDATE valor bruto + valor do desconto + updated_at
│
└── COMMIT
```

Embora os comandos tenham sido executados separadamente, eles pertenciam a uma única transação SQL confirmada.

### 14.3 Ordenação dos Comandos

O CDC preservou um contexto comum de transação enquanto distinguia os dois comandos na origem.

Os identificadores de comando observados foram:

```text
Comando 1
__$command_id = 1

Comando 2
__$command_id = 2
```

Ambos os comandos pertenciam ao mesmo contexto de transação representado pelo `__$start_lsn` compartilhado.

O modelo resultante foi:

```text
Uma Transação SQL
│
├── __$start_lsn = compartilhado
│
├── Comando 1
│   └── __$command_id = 1
│
└── Comando 2
    └── __$command_id = 2
```

Isso demonstrou que a identidade da transação e a identidade do comando representam níveis diferentes dos metadados do CDC.

Um consumidor não deve, portanto, tratar cada linha do CDC que compartilha o mesmo LSN de transação como se tivesse sido originada pelo mesmo comando SQL individual.

### 14.4 Máscaras de Atualização

Cada comando afetou um conjunto diferente de colunas capturadas da origem.

Para a primeira atualização, a máscara observada foi:

```text
__$update_mask = 0x0108
```

correspondendo a:

```text
TRN_TRNST_id
TRN_updated_at
```

Para a segunda atualização, a máscara observada foi:

```text
__$update_mask = 0x0160
```

correspondendo a:

```text
TRN_gross_amount
TRN_discount_amount
TRN_updated_at
```

Portanto:

```text
Comando 1
│
├── Status
├── Updated At
└── Máscara = 0x0108

Comando 2
│
├── Valor Bruto
├── Valor do Desconto
├── Updated At
└── Máscara = 0x0160
```

O experimento demonstrou que `__$update_mask` está associado às colunas capturadas afetadas por cada comando de atualização, e não à transação como um todo.

Dois comandos na mesma transação podem, portanto, compartilhar um LSN de transação enquanto apresentam máscaras de atualização diferentes.

### 14.5 Correlação da Transação

Cada comando de atualização produziu seu próprio par de antes e depois.

Conceitualmente, a representação no CDC foi:

```text
__$start_lsn compartilhado
│
├── Comando 1 — __$command_id = 1
│   │
│   ├── operation = 3
│   │   UPDATE_BEFORE
│   │
│   └── operation = 4
│       UPDATE_AFTER
│
└── Comando 2 — __$command_id = 2
    │
    ├── operation = 3
    │   UPDATE_BEFORE
    │
    └── operation = 4
        UPDATE_AFTER
```

Dentro de cada par, as imagens de antes e depois compartilhavam os correspondentes:

```text
__$start_lsn
__$command_id
__$seqval
__$update_mask
```

`__$operation`, por sua vez, distinguia as duas imagens de linha.

Entre os dois comandos:

```text
__$start_lsn
    → permaneceu compartilhado

__$command_id
    → distinguiu o comando 1 do comando 2

__$update_mask
    → refletiu as colunas afetadas por cada comando
```

Isso estabeleceu um modelo de transação mais completo do que aquele que poderia ser derivado apenas do teste com uma única atualização.

### 14.6 Resultado Observado

Após a conclusão da transação, o estado final na origem para os valores controlados era:

```text
Status:
COMPLETED

Valor Bruto:
105

Valor do Desconto:
15
```

O CDC preservou os limites intermediários dos comandos, em vez de expor apenas esse estado final da origem.

A estrutura observada da transação pode ser resumida como:

```text
Transação SQL
│
│  __$start_lsn compartilhado
│
├── Comando 1
│   ├── __$command_id = 1
│   ├── __$update_mask = 0x0108
│   ├── operation 3 → antes
│   └── operation 4 → depois
│
└── Comando 2
    ├── __$command_id = 2
    ├── __$update_mask = 0x0160
    ├── operation 3 → antes
    └── operation 4 → depois
```

Isso demonstrou por que as linhas do CDC não podem ser interpretadas corretamente como registros isolados.

O significado de uma linha individual depende dos metadados de transação e de comando ao seu redor.

### 14.7 Conclusão

O M01.14 validou com sucesso a representação no CDC de múltiplos comandos de `UPDATE` executados dentro de uma única transação SQL.

O experimento demonstrou que os dois comandos compartilhavam o mesmo:

```text
__$start_lsn
```

enquanto eram distinguidos por:

```text
__$command_id = 1
__$command_id = 2
```

Cada comando produziu seu próprio par correlacionado:

```text
UPDATE_BEFORE
+
UPDATE_AFTER
```

As diferentes máscaras de atualização:

```text
Comando 1:
0x0108

Comando 2:
0x0160
```

também demonstraram que os metadados de alteração de colunas pertencem ao comando individual de atualização, e não à transação como um todo.

O M01.14 estabeleceu, portanto, um princípio central de interpretação do CDC para o Atlas Engineering:

```text
As linhas do CDC devem ser interpretadas no contexto da transação.
```

Uma transação pode conter múltiplos comandos, e cada comando pode produzir múltiplas imagens de linha no CDC. A interpretação correta exige preservar a relação entre o LSN da transação, o identificador do comando, o valor de sequência, a operação e a máscara de atualização.

**Status do M01.14: APROVADO**

---

## 15. DELETE Controlado — M01.15

Após validar o comportamento de `INSERT` e `UPDATE`, o experimento seguinte completou o ciclo básico de validação DML testando um `DELETE` físico controlado.

O M01.15 excluiu a transação criada durante o M01.12 e posteriormente modificada durante o M01.13 e M01.14.

O experimento foi projetado para determinar se o CDC do SQL Server preservava evidência de uma linha depois que essa linha deixava de existir na tabela de origem.

Esse comportamento é particularmente importante para o projeto da estratégia de captura porque um mecanismo incremental baseado em *timestamp* pode identificar linhas alteradas que permanecem presentes, mas não consegue, por si só, descobrir uma linha que tenha sido fisicamente removida da origem.

### 15.1 Objetivo

O objetivo do M01.15 foi validar:

- se um `DELETE` físico confirmado era capturado pelo CDC;
- como a linha excluída era representada na tabela de alterações do CDC;
- qual código de operação do CDC representava a exclusão;
- se a última imagem da linha na origem permanecia disponível por meio do CDC após a própria linha ter sido removida da origem;
- por que a detecção de exclusões físicas é uma capacidade importante do mecanismo de captura selecionado para tabelas transacionais com alta taxa de alterações.

O teste controlado utilizou:

```text
TRN_id = 6307
```

Antes da exclusão, a transação de teste não possuía mais linhas filhas em `sales.TransactionItem`.

Isso permitiu que o experimento isolasse a exclusão direta da transação pai sem introduzir comportamento de cascata referencial.

O comportamento de cascata foi avaliado separadamente durante o M01.19.

### 15.2 Estado da Origem Antes do DELETE

Antes de executar a exclusão controlada, o estado da origem foi validado.

O estado relevante era:

```text
sales.Transaction
TRN_id = 6307
Linhas = 1

sales.TransactionItem
Linhas associadas ao TRN_id = 6307
Linhas = 0
```

O teste começou, portanto, com:

```text
Transação pai:
EXISTE

Itens filhos da transação:
NENHUM
```

Esse *baseline* tornou inequívoca a transição esperada na origem.

A única linha que se esperava que fosse fisicamente removida pela ação controlada era a própria linha de `sales.Transaction`.

### 15.3 Execução do DELETE

A ação controlada removeu:

```text
TRN_id = 6307
```

de:

```text
sales.Transaction
```

Após a confirmação da exclusão, a validação da origem mostrou:

```text
sales.Transaction
TRN_id = 6307
Linhas = 0
```

A transição na origem foi, portanto:

```text
Antes do DELETE
│
└── TRN_id 6307 existe
        │
        │ DELETE + COMMIT
        ▼
Depois do DELETE
│
└── TRN_id 6307 não existe mais
```

No nível da tabela de origem, a linha não estava mais disponível para ser redescoberta por uma consulta incremental futura.

### 15.4 Representação do DELETE no CDC

O CDC preservou um registro de alteração representando a transação excluída.

A operação observada foi:

```text
__$operation = 1
```

Dentro do modelo de operações do CDC:

```text
1 = DELETE
2 = INSERT
3 = UPDATE_BEFORE
4 = UPDATE_AFTER
```

Portanto:

```text
DELETE na origem
      ↓
operação no CDC = 1
```

O registro do CDC preservou a última imagem capturada da linha associada à linha excluída da origem.

A máscara de atualização observada foi:

```text
__$update_mask = 0x01FF
```

representando o conjunto completo de colunas capturadas para a linha excluída.

Conceitualmente:

```text
sales.Transaction
│
│ DELETE TRN_id = 6307
▼
Linha removida da origem
│
│
└──────────────► CDC
                 │
                 ├── __$operation = 1
                 ├── __$update_mask = 0x01FF
                 └── imagem da linha excluída preservada
```

Isso significa que o desaparecimento da linha da origem não eliminou a evidência necessária para identificar a exclusão dentro da janela de retenção do CDC.

### 15.5 Detecção de DELETE Físico

O teste controlado demonstrou uma diferença crítica entre captura de alterações e uma consulta incremental simples baseada em *timestamp*.

Considere um modelo que recupere apenas linhas da origem que satisfaçam uma condição como:

```sql
WHERE updated_at > @watermark
```

Após um `DELETE` físico:

```text
Linha excluída
    ↓
Não existe mais na origem
    ↓
Não pode satisfazer uma futura condição WHERE na tabela de origem
```

A linha desapareceu do conjunto de dados consultado.

Sem outro mecanismo de exclusão, o consumidor não consegue determinar, apenas a partir das linhas restantes na origem, que o registro excluído existia anteriormente.

O CDC fornece evidência explícita da exclusão:

```text
Linha Existente
    │
    │ DELETE
    ▼
Nenhuma Linha na Origem
    +
operação no CDC = 1
```

Essa capacidade é uma das razões importantes pelas quais o CDC é apropriado para o escopo transacional com alta taxa de alterações em que a propagação de exclusões físicas é necessária.

O experimento não implica que estratégias incrementais baseadas em *timestamp* sejam universalmente inadequadas.

Ele estabelece a conclusão de engenharia mais restrita de que um *watermark* de *timestamp*, isoladamente, não fornece detecção equivalente de `DELETE` físico para uma linha removida fisicamente.

### 15.6 Resultado Observado

O estado controlado final foi:

```text
Origem
│
└── TRN_id = 6307
    └── NÃO PRESENTE

CDC
│
└── TRN_id = 6307
    ├── __$operation = 1
    ├── __$update_mask = 0x01FF
    └── última imagem da linha preservada
```

O experimento demonstrou, portanto:

```text
DELETE Físico
     │
     ├── remove a linha da origem
     │
     └── produz evidência explícita de DELETE no CDC
```

O teste controlado envolveu apenas a exclusão direta da linha da transação porque não existiam registros filhos em `sales.TransactionItem` para `TRN_id = 6307`.

Essa distinção é importante porque o M01.15 comprova a captura direta de `DELETE` físico, enquanto o M01.19 avalia posteriormente o caso mais complexo em que uma exclusão explícita do pai provoca exclusões físicas adicionais dos filhos por meio de `ON DELETE CASCADE`.

### 15.7 Conclusão

O M01.15 validou com sucesso a representação no CDC de um `DELETE` físico controlado em `sales.Transaction`.

A linha da origem:

```text
TRN_id = 6307
```

foi fisicamente removida de `sales.Transaction`, enquanto o CDC preservou um registro de alteração correspondente representado por:

```text
__$operation = 1
__$update_mask = 0x01FF
```

O experimento demonstrou, portanto, que o CDC do SQL Server pode fornecer evidência explícita de uma exclusão física mesmo depois que a linha excluída deixa de estar presente na tabela de origem.

Isso estabelece um requisito importante da estratégia de captura para o Atlas Engineering:

```text
Se a detecção de DELETE físico for necessária, o mecanismo de captura deverá preservar a evidência da exclusão.
```

Um *watermark* de *timestamp* aplicado apenas às linhas que permanecem na origem não pode fornecer evidência equivalente de uma linha fisicamente excluída.

Com os comportamentos básicos de `INSERT`, `UPDATE` e `DELETE` validados para `sales.Transaction`, a próxima etapa da implementação estende o CDC para `sales.TransactionItem`, de modo que o comportamento transacional possa ser avaliado entre tabelas de origem relacionadas.

**Status do M01.15: APROVADO**

---

## 16. Habilitação do CDC em `sales.TransactionItem` — M01.16

Após concluir o ciclo básico de validação dos comportamentos de `INSERT`, `UPDATE` e `DELETE` para `sales.Transaction`, o escopo da implementação foi expandido para `sales.TransactionItem`.

O objetivo do M01.16 não era apenas habilitar uma segunda tabela para o CDC, mas também preparar o ambiente para experimentos controlados de transações entre tabelas.

Como `sales.TransactionItem` participa da relação transacional com `sales.Transaction`, sua estrutura na origem e seu comportamento referencial foram validados antes da habilitação do CDC.

### 16.1 Validação Pré-Habilitação — M01.16A

Antes de modificar a configuração do CDC no nível da tabela, o estado atual de `sales.TransactionItem` foi inspecionado.

O estado observado foi:

```text
Tabela de Origem:
sales.TransactionItem

Rastreada pelo CDC:
NÃO

Linhas Existentes:
13.769
```

Portanto:

```text
is_tracked_by_cdc = 0
```

confirmou que a tabela ainda não havia sido incluída em uma instância de captura do CDC.

Isso forneceu o *baseline* pré-habilitação necessário para distinguir o estado existente na origem das alterações geradas após o estabelecimento da fronteira do CDC.

A validação também inspecionou a chave primária da tabela, a relação referencial com `sales.Transaction` e o modelo de particionamento, pois essas características eram diretamente relevantes para os experimentos de CDC entre tabelas planejados para as etapas subsequentes.

### 16.2 Chave Primária

A chave primária identificada para `sales.TransactionItem` foi:

```text
PK_TRNIT
```

com a estrutura de chave:

```text
TRNIT_id
TRNIT_transaction_at
```

Conceitualmente:

```text
PK_TRNIT
│
├── TRNIT_id
└── TRNIT_transaction_at
```

Essa chave foi posteriormente utilizada como o índice configurado para a instância de captura do CDC.

A estrutura de chave composta faz parte do projeto da tabela de origem e permanece distinta dos metadados do CDC utilizados para identificar o contexto da transação e do comando.

### 16.3 Chave Estrangeira e ON DELETE CASCADE

A relação entre `sales.TransactionItem` e sua transação pai foi validada antes da habilitação do CDC.

A chave estrangeira observada foi:

```text
FK_TRNIT_TRN
```

com:

```text
ON DELETE CASCADE
```

Portanto, excluir uma linha pai de `sales.Transaction` pode fazer com que as linhas relacionadas em `sales.TransactionItem` sejam fisicamente excluídas pelo SQL Server por meio da ação referencial.

Conceitualmente:

```text
sales.Transaction
        │
        │ DELETE do pai
        ▼
FK_TRNIT_TRN
ON DELETE CASCADE
        │
        ▼
sales.TransactionItem
linhas filhas relacionadas excluídas
```

Era importante estabelecer esse comportamento antes do experimento de exclusão entre tabelas.

Ele cria uma distinção entre:

```text
Ação da Aplicação
```

e:

```text
Alterações Físicas no Banco de Dados
```

Uma instrução explícita de `DELETE` no pai pode resultar em múltiplas exclusões físicas de linhas entre tabelas relacionadas.

Nesta etapa, a configuração referencial foi verificada.

A representação efetiva da cascata no CDC ainda não era considerada comprovada e foi validada separadamente durante o M01.19.

### 16.4 Particionamento

Também foi confirmado que `sales.TransactionItem` era particionada.

Seu particionamento seguia o mesmo contexto mensal do modelo de origem utilizado pelos dados transacionais relacionados.

O estado relevante da implementação era, portanto:

```text
sales.TransactionItem
│
├── Chave primária composta
├── Chave estrangeira para o pai
│   └── ON DELETE CASCADE
├── Particionada
└── CDC ainda não habilitado
```

Como a tabela era particionada, a habilitação do CDC introduziu a mesma classe de consideração sobre *partition switching* anteriormente avaliada para `sales.Transaction`.

O princípio de governança da V1 permaneceu inalterado: *partition switching* não é tratado como o caminho normal de ingestão e exige controle explícito quando utilizado com tabelas habilitadas para CDC.

### 16.5 Habilitação do CDC — M01.16B

Após a conclusão da validação pré-habilitação, o CDC foi habilitado em `sales.TransactionItem`.

A configuração de captura resultante incluiu:

```text
Schema de Origem:
sales

Tabela de Origem:
TransactionItem

Instância de Captura:
sales_TransactionItem

Índice:
PK_TRNIT

Suporte a Net Changes:
0
```

A tabela foi configurada para capturar todas as nove colunas da origem.

Assim como em `sales.Transaction`, o suporte a *net changes* permaneceu desabilitado:

```text
supports_net_changes = 0
```

Isso preservou o modelo detalhado de todas as alterações necessário para os experimentos controlados de transações.

A implementação essencial no nível da tabela seguiu o mesmo mecanismo do CDC utilizado para a primeira tabela transacional:

```sql
EXEC sys.sp_cdc_enable_table
    @source_schema        = N'sales',
    @source_name          = N'TransactionItem',
    @role_name            = NULL,
    @supports_net_changes = 0;
```

A lógica completa de execução e validação é mantida nos *scripts* SQL correspondentes ao M01.16.

### 16.6 Instância de Captura

O SQL Server criou a instância de captura:

```text
sales_TransactionItem
```

O LSN inicial observado foi:

```text
0x0000002D00001044008A
```

O índice configurado foi:

```text
PK_TRNIT
```

O escopo transacional resultante do CDC passou a conter duas instâncias de captura:

```text
AtlasCommerce
│
├── sales.Transaction
│   └── sales_Transaction
│
└── sales.TransactionItem
    └── sales_TransactionItem
```

Isso estabeleceu a infraestrutura necessária no lado da origem para os experimentos subsequentes envolvendo uma única transação SQL que modificasse ambas as tabelas.

### 16.7 Objetos do CDC Gerados

A habilitação no nível da tabela criou os objetos do CDC associados à nova instância de captura.

Os principais objetos gerados incluíram:

```text
cdc.sales_TransactionItem_CT
cdc.fn_cdc_get_all_changes_sales_TransactionItem
```

Como:

```text
supports_net_changes = 0
```

a implementação não criou uma função de consulta de *net changes* correspondente para essa instância de captura.

O escopo resultante do CDC forneceu, portanto, tabelas de alterações e funções de todas as alterações separadas para as tabelas transacionais pai e filha.

Conceitualmente:

```text
sales.Transaction
        │
        ▼
cdc.sales_Transaction_CT

sales.TransactionItem
        │
        ▼
cdc.sales_TransactionItem_CT
```

As estruturas físicas de captura separadas tornaram a correlação do CDC entre tabelas um problema de metadados, e não um problema de armazenamento em uma tabela compartilhada.

Esse comportamento foi avaliado durante o M01.17 até o M01.19.

### 16.8 Estado Inicial da Tabela de Alterações

Imediatamente após a habilitação do CDC, a nova tabela de alterações continha:

```text
change_rows = 0
```

enquanto a tabela de origem continha:

```text
Linhas em sales.TransactionItem = 13.769
```

Portanto:

```text
Origem:
13.769 linhas existentes

Tabela de alterações do CDC:
0 linhas
```

Isso reproduziu o comportamento anteriormente observado para `sales.Transaction`.

A habilitação do CDC em uma tabela de origem existente não gerou registros do CDC para linhas que já estavam presentes.

A segunda instância de captura reforçou, portanto, o princípio de implementação estabelecido anteriormente:

```text
Habilitação do CDC ≠ Backfill Histórico
```

As 13.769 linhas existentes em `sales.TransactionItem` permaneceram sob responsabilidade do *backfill* inicial, em vez de se tornarem eventos sintéticos do CDC.

### 16.9 Observação Inicial do LSN Mínimo

Imediatamente após a habilitação da nova instância de captura, foi observado um estado transitório importante.

Os metadados da instância de captura já continham o LSN inicial:

```text
0x0000002D00001044008A
```

enquanto:

```text
sys.fn_cdc_get_min_lsn(...)
```

retornou temporariamente:

```text
NULL
```

Naquele ponto da observação, o processo de captura do CDC ainda não havia avançado o suficiente para que o LSN mínimo consultável da nova instância de captura se tornasse disponível.

O estado pode ser representado como:

```text
Instância de captura criada
        │
        ├── start_lsn estabelecido
        └── LSN mínimo consultável temporariamente NULL
                         │
                         ▼
                  Captura avança
                         │
                         ▼
              LSN mínimo torna-se disponível
```

Uma validação posterior mostrou que o LSN mínimo se tornou:

```text
0x0000002D00001044008A
```

correspondendo ao LSN inicial da instância de captura.

O `NULL` transitório não foi, portanto, tratado como uma falha de habilitação.

Ele demonstrou que a criação dos metadados da instância de captura e a disponibilidade do LSN mínimo não são necessariamente simultâneas.

Essa distinção torna-se operacionalmente importante para *scripts* que habilitam uma instância de captura e imediatamente tentam determinar seu intervalo consultável de LSNs.

Esses *scripts* não devem interpretar automaticamente um LSN mínimo `NULL` imediato como evidência de falha na habilitação do CDC no nível da tabela.

### 16.10 Conclusão

O M01.16 expandiu com sucesso a implementação do CDC de `sales.Transaction` para `sales.TransactionItem`.

A validação pré-habilitação estabeleceu:

```text
Linhas existentes = 13.769
Rastreada pelo CDC = NÃO
Chave primária = PK_TRNIT
Chave estrangeira = FK_TRNIT_TRN
Comportamento de exclusão = ON DELETE CASCADE
Particionada = SIM
```

O CDC foi então habilitado com:

```text
capture_instance = sales_TransactionItem
index = PK_TRNIT
supports_net_changes = 0
captured columns = 9
start_lsn = 0x0000002D00001044008A
```

O SQL Server criou a tabela de alterações e a função de todas as alterações correspondentes, enquanto a tabela de alterações inicial permaneceu vazia apesar das 13.769 linhas já presentes na origem.

A implementação também capturou um comportamento transitório importante: imediatamente após a habilitação, a instância de captura possuía um LSN inicial estabelecido, enquanto seu LSN mínimo consultável retornava temporariamente `NULL`. Posteriormente, o LSN mínimo tornou-se disponível e correspondeu ao LSN inicial da instância de captura.

Com ambas as tabelas transacionais agora habilitadas para CDC, o ambiente de origem estava preparado para a validação controlada de transações entre tabelas.

**Status do M01.16: APROVADO**

---

## 17. Preparação do CDC entre Tabelas — M01.17A

Com `sales.Transaction` e `sales.TransactionItem` habilitadas para CDC, a etapa seguinte preparou o ambiente para a validação controlada de transações entre tabelas.

Antes de gerar uma transação que modificasse ambas as tabelas de origem, o M01.17A verificou as instâncias de captura ativas e inspecionou seu estado atual de LSN.

Durante essa preparação, o *script* de validação expôs um uso incorreto de `sys.sp_cdc_help_change_data_capture`. O erro foi diagnosticado e corrigido antes da continuidade do experimento entre tabelas.

### 17.1 Objetivo

O objetivo do M01.17A foi:

- confirmar que ambas as instâncias de captura transacionais estavam ativas;
- inspecionar a configuração do CDC antes de gerar alterações entre tabelas;
- estabelecer o estado de LSN disponível para ambas as instâncias de captura;
- verificar se o ambiente estava preparado para testes de transações entre tabelas;
- corrigir quaisquer problemas no *script* de validação antes de produzir novas evidências.

As instâncias de captura esperadas eram:

```text
sales_Transaction
sales_TransactionItem
```

Essa etapa de preparação foi intencionalmente separada do teste de transação para que a validação da configuração e a evidência de geração de alterações não fossem misturadas.

### 17.2 Validação das Instâncias de Captura

O ambiente foi inspecionado para confirmar que ambas as tabelas de origem permaneciam habilitadas para CDC.

O mapeamento esperado era:

```text
sales.Transaction
        │
        └── capture_instance
            sales_Transaction

sales.TransactionItem
        │
        └── capture_instance
            sales_TransactionItem
```

Ambas as instâncias de captura estavam disponíveis.

Isso estabeleceu a configuração necessária no lado da origem para o experimento seguinte, no qual uma única transação SQL inseriria linhas em ambas as tabelas de origem.

### 17.3 Erro de Script em `sp_cdc_help_change_data_capture`

Durante o procedimento de validação, o *script* tentou executar:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

O SQL Server retornou:

```text
Msg 22972
```

O erro ocorreu porque a chamada da *stored procedure* forneceu `@source_schema` sem fornecer também o nome correspondente da tabela de origem.

Esse foi um erro no *script* de validação.

Ele não era evidência de:

```text
Falha na captura do CDC
Corrupção dos metadados do CDC
Falha da instância de captura
Falha do CDC entre tabelas
```

Nenhuma transação entre tabelas havia sido executada ainda como parte do M01.17B.

O erro precisava, portanto, ser corrigido antes da continuidade para que a própria etapa de preparação permanecesse confiável.

### 17.4 Causa Raiz

`sys.sp_cdc_help_change_data_capture` não oferece suporte ao fornecimento apenas de:

```text
@source_schema
```

A *stored procedure* exige que o *schema* e o nome da origem sejam fornecidos juntos ao solicitar informações para uma tabela de origem específica, ou que nenhum dos parâmetros seja fornecido ao solicitar a configuração de captura disponível.

O padrão inválido era:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

Conceitualmente:

```text
source_schema fornecido
        +
source_name omitido
        ↓
Combinação de parâmetros inválida
        ↓
Msg 22972
```

A falha foi, portanto, causada pelo uso dos parâmetros no *script* de inspeção, e não pela própria configuração do CDC.

Essa distinção é importante para o modelo de evidências:

```text
Falha do Script ≠ Falha do CDC
```

Um erro de implementação deve ser diagnosticado na camada em que ocorreu antes que sejam extraídas conclusões sobre o comportamento da plataforma subjacente.

### 17.5 Correção

Para a validação necessária, a chamada da *stored procedure* foi corrigida para listar as informações de captura configuradas no CDC sem o filtro parcial inválido:

```sql
EXEC sys.sp_cdc_help_change_data_capture;
```

Isso permitiu que a configuração de captura ativa fosse inspecionada corretamente.

Quando forem necessárias informações para uma tabela de origem individual, o *schema* e o nome da origem deverão ser fornecidos juntos.

A lógica de validação corrigida restabeleceu o fluxo de preparação sem exigir uma reconfiguração do CDC.

Nenhuma instância de captura precisou ser desabilitada, recriada ou reparada como resultado do erro original.

### 17.6 Estado de LSN

Após a correção do *script* de validação, o estado de LSN das duas instâncias de captura foi inspecionado.

O LSN mínimo observado para `sales.Transaction` foi:

```text
0x0000002C0000FCEC0067
```

O LSN mínimo observado para `sales.TransactionItem` foi:

```text
0x0000002D00001044008A
```

Esses valores correspondiam às respectivas fronteiras das instâncias de captura estabelecidas quando o CDC foi habilitado em cada tabela de origem.

As instâncias de captura, portanto, não possuíam valores idênticos de LSN mínimo:

```text
sales_Transaction
min_lsn =
0x0000002C0000FCEC0067

sales_TransactionItem
min_lsn =
0x0000002D00001044008A
```

Essa diferença é esperada no contexto da implementação porque as duas tabelas ingressaram no CDC em etapas diferentes.

No ponto da observação, ambas as instâncias de captura compartilhavam o mesmo LSN máximo processado atualmente disponível.

Conceitualmente:

```text
Linha do tempo do CDC
──────────────────────────────────────────────────────►

sales_Transaction
      │
      └── começa antes
          min_lsn =
          0x0000002C0000FCEC0067
          │
          └──────────────────────────────┐
                                         │
                                         ▼
                                    LSN máximo atual

sales_TransactionItem
                    │
                    └── começa depois
                        min_lsn =
                        0x0000002D00001044008A
                        │
                        └────────────────┘
```

Isso estabeleceu uma fronteira importante para o consumo futuro entre tabelas.

Um consumidor que consulte múltiplas instâncias de captura não pode presumir automaticamente que todas elas possuam a mesma fronteira histórica inferior de LSN.

O algoritmo efetivo de consumo incremental e a estratégia de *checkpoint* ainda não haviam sido implementados e, portanto, permanecem fora da evidência estabelecida pelo M01.17A.

### 17.7 Conclusão

O M01.17A preparou com sucesso o ambiente do CDC para os testes de transações entre tabelas.

Ambas as instâncias de captura foram confirmadas:

```text
sales_Transaction
sales_TransactionItem
```

e seus valores mínimos de LSN foram observados como:

```text
sales_Transaction:
0x0000002C0000FCEC0067

sales_TransactionItem:
0x0000002D00001044008A
```

Ambas as instâncias de captura haviam alcançado o mesmo LSN máximo processado atualmente disponível no ponto da validação.

A etapa de preparação também identificou um erro no *script* de validação original:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

que produziu:

```text
Msg 22972
```

A causa raiz foi a combinação parcial inválida de parâmetros. O *script* foi corrigido para:

```sql
EXEC sys.sp_cdc_help_change_data_capture;
```

e o próprio CDC não exigiu nenhum reparo ou reconfiguração.

O M01.17A estabeleceu, portanto, tanto a prontidão técnica das duas instâncias de captura quanto um princípio importante de engenharia para o registro da implementação:

```text
Um erro no script de validação não deve ser classificado incorretamente como uma falha da tecnologia que está sendo validada.
```

Com a preparação concluída, o ambiente estava pronto para o M01.17B: a primeira transação SQL controlada produzindo alterações relacionadas entre ambas as tabelas de origem habilitadas para CDC.

**Status do M01.17A: APROVADO COM CORREÇÃO DE SCRIPT**

---

## 18. Transação de INSERT entre Tabelas — M01.17B

Com ambas as instâncias de captura validadas, o experimento seguinte introduziu a primeira transação controlada que modificou ambas as tabelas de origem habilitadas para CDC.

O M01.17B inseriu uma linha pai em `sales.Transaction` e duas linhas filhas relacionadas em `sales.TransactionItem` dentro de uma única transação SQL.

O objetivo foi determinar se os metadados do CDC poderiam ser utilizados para correlacionar alterações capturadas independentemente por duas instâncias de captura diferentes à mesma transação de origem.

### 18.1 Objetivo

O objetivo do M01.17B foi validar:

- se alterações em múltiplas tabelas habilitadas para CDC dentro de uma única transação SQL compartilham um contexto comum de transação;
- se os `INSERT`s do pai e dos filhos poderiam ser correlacionados por meio de `__$start_lsn`;
- como `__$command_id` distinguia os comandos individuais na origem;
- se a ordenação dos comandos permanecia observável entre as duas instâncias de captura;
- se a disponibilidade do CDC permanecia assíncrona para uma transação entre tabelas;
- o que a evidência no lado da origem comprovava e não comprovava sobre o futuro tratamento de transações nos processos subsequentes.

O experimento foi projetado especificamente para distinguir:

```text
Uma Transação SQL
```

de:

```text
Múltiplos Registros do CDC Armazenados Independentemente
```

### 18.2 Estrutura da Transação

A transação SQL controlada executou três comandos de `INSERT`:

```text
BEGIN TRANSACTION
│
├── Comando 1
│   └── INSERT sales.Transaction
│
├── Comando 2
│   └── INSERT sales.TransactionItem
│
├── Comando 3
│   └── INSERT sales.TransactionItem
│
└── COMMIT
```

O `INSERT` do pai criou:

```text
TRN_id:
6308

Status:
PENDING

Canal:
ONLINE

Valor Bruto:
150

Valor do Desconto:
15
```

Dois itens relacionados da transação foram criados:

```text
Item da Transação:
13770

Variante do Produto:
1

Quantidade:
1

Preço:
100

Desconto:
10
```

e:

```text
Item da Transação:
13771

Variante do Produto:
2

Quantidade:
1

Preço:
50

Desconto:
5
```

As três linhas da origem pertenciam, portanto, a uma única transação SQL explicitamente controlada.

### 18.3 Linhas Criadas na Origem

Após a confirmação da transação, o estado esperado da origem estava presente em ambas as tabelas.

Conceitualmente:

```text
sales.Transaction
│
└── TRN_id = 6308
    ├── PENDING
    ├── ONLINE
    ├── Bruto = 150
    └── Desconto = 15
          │
          ├─────────────────────────┐
          │                         │
          ▼                         ▼
sales.TransactionItem       sales.TransactionItem
│                           │
└── TRNIT_id = 13770        └── TRNIT_id = 13771
    ├── ProductVariant = 1      ├── ProductVariant = 2
    ├── Quantidade = 1          ├── Quantidade = 1
    ├── Preço = 100             ├── Preço = 50
    └── Desconto = 10           └── Desconto = 5
```

O banco de dados de origem continha, portanto, o estado completo de pai e filhos imediatamente após a confirmação da transação.

A questão seguinte era se os registros correspondentes do CDC já estavam disponíveis.

### 18.4 Estado Imediato do CDC

Imediatamente após a confirmação da transação SQL, a inspeção do CDC retornou:

```text
Alterações correspondentes em sales_Transaction:
0

Alterações correspondentes em sales_TransactionItem:
0
```

Portanto:

```text
Transação na Origem:
CONFIRMADA

Linha Pai na Origem:
DISPONÍVEL

Linhas Filhas na Origem:
DISPONÍVEIS

Registro do Pai no CDC:
AINDA NÃO DISPONÍVEL

Registros dos Filhos no CDC:
AINDA NÃO DISPONÍVEIS
```

Isso reproduziu, entre múltiplas instâncias de captura, o comportamento assíncrono anteriormente observado durante o primeiro `INSERT` controlado.

A transação na origem estava concluída antes que suas representações correspondentes no CDC se tornassem visíveis.

### 18.5 Estado Capturado pelo CDC

Após aguardar o processamento da captura pelo CDC, a transação foi inspecionada novamente.

O estado resultante no CDC foi:

```text
sales_Transaction:
1 INSERT capturado

sales_TransactionItem:
2 INSERTs capturados
```

Os três registros do CDC representavam os três comandos executados na origem dentro da transação SQL original.

Todos os três registros foram capturados com:

```text
__$operation = 2
__$update_mask = 0x01FF
```

O código de operação confirmou que todos os três registros representavam inserções.

A estrutura completa capturada foi, portanto:

```text
sales_Transaction
│
└── TRN_id = 6308
    ├── operation = 2
    └── update_mask = 0x01FF

sales_TransactionItem
│
├── TRNIT_id = 13770
│   ├── operation = 2
│   └── update_mask = 0x01FF
│
└── TRNIT_id = 13771
    ├── operation = 2
    └── update_mask = 0x01FF
```

A transição assíncrona observada no experimento foi:

```text
COMMIT
   ↓
Linhas disponíveis na origem
   ↓
Inspeção imediata do CDC
   ↓
Transaction = 0
TransactionItem = 0
   ↓
Processamento da captura pelo CDC
   ↓
Transaction = 1
TransactionItem = 2
```

### 18.6 Correlação da Transação entre Tabelas

A observação mais importante do M01.17B foi que todos os três registros capturados compartilhavam o mesmo:

```text
__$start_lsn = 0x0000002D00001A740028
```

Portanto:

```text
sales.Transaction
TRN_id = 6308
        │
        └── __$start_lsn
            0x0000002D00001A740028

sales.TransactionItem
TRNIT_id = 13770
        │
        └── __$start_lsn
            0x0000002D00001A740028

sales.TransactionItem
TRNIT_id = 13771
        │
        └── __$start_lsn
            0x0000002D00001A740028
```

O experimento forneceu, portanto, evidência direta de que alterações capturadas por diferentes instâncias de captura do CDC podem preservar um LSN de transação compartilhado quando se originam da mesma transação SQL.

Esse é um resultado fundamental para o futuro modelo de consumo.

Os registros do CDC são fisicamente expostos por meio de estruturas de instâncias de captura diferentes:

```text
cdc.sales_Transaction_CT

cdc.sales_TransactionItem_CT
```

mas seus metadados de transação permitem que as alterações relacionadas na origem sejam correlacionadas.

Conceitualmente:

```text
                    Transação SQL
                          │
              __$start_lsn compartilhado
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
CDC de sales_Transaction    CDC de sales_TransactionItem
       1 registro                    2 registros
```

### 18.7 Ordenação dos Comandos

Embora todos os três registros compartilhassem o mesmo LSN de transação, seus identificadores de comando eram diferentes.

A ordenação observada dos comandos foi:

```text
INSERT do Pai
TRN_id = 6308
__$command_id = 1

Primeiro INSERT do Filho
TRNIT_id = 13770
__$command_id = 2

Segundo INSERT do Filho
TRNIT_id = 13771
__$command_id = 3
```

Isso correspondeu à sequência controlada de comandos executada dentro da transação SQL:

```text
Comando 1
    → INSERT do pai

Comando 2
    → INSERT do primeiro filho

Comando 3
    → INSERT do segundo filho
```

O modelo de metadados resultante foi:

```text
__$start_lsn = 0x0000002D00001A740028
│
├── __$command_id = 1
│   └── sales.Transaction / 6308
│
├── __$command_id = 2
│   └── sales.TransactionItem / 13770
│
└── __$command_id = 3
    └── sales.TransactionItem / 13771
```

O M01.17B estendeu, portanto, o modelo de transação anteriormente observado dentro de uma única tabela.

`__$command_id` permaneceu útil para distinguir comandos mesmo quando esses comandos afetavam diferentes tabelas de origem habilitadas para CDC.

### 18.8 Fronteira da Evidência

O experimento entre tabelas estabeleceu o comportamento do CDC do SQL Server no lado da origem.

Ele comprovou que, na transação controlada em laboratório:

```text
Uma Transação SQL
        ↓
Alterações em duas tabelas habilitadas para CDC
        ↓
__$start_lsn compartilhado
        +
Valores distintos de __$command_id
```

Ele não comprovou como as tecnologias subsequentes preservarão ou exporão essa relação.

Em particular, o M01.17B não estabelece que:

```text
Debezium
Kafka
Ingestão Bronze
Futuro Consumidor do CDC
```

entregarão automaticamente as três alterações capturadas como um único pacote indivisível nas etapas subsequentes.

Esses componentes ainda não haviam sido implementados ou testados.

Portanto:

```text
Correlação da Transação no SQL Server ≠ Entrega Atômica Subsequente Comprovada
```

A evidência sustenta um projeto futuro que possa utilizar os metadados de transação do CDC para correlação.

Ela não permite que o documento de implementação afirme atomicidade transacional *end-to-end* antes que o caminho subsequente de captura tenha sido validado.

### 18.9 Conclusão

O M01.17B validou com sucesso a primeira transação controlada do CDC entre tabelas.

Uma transação SQL inseriu:

```text
1 linha em sales.Transaction
+
2 linhas em sales.TransactionItem
```

e todos os três registros capturados pelo CDC compartilharam:

```text
__$start_lsn = 0x0000002D00001A740028
```

enquanto seus identificadores de comando preservaram a sequência controlada dos comandos na origem:

```text
1 → INSERT do pai
2 → INSERT do primeiro filho
3 → INSERT do segundo filho
```

Todos os três registros foram representados como:

```text
__$operation = 2
__$update_mask = 0x01FF
```

O experimento também reproduziu o modelo de captura assíncrona: as linhas confirmadas na origem estavam disponíveis antes que seus registros no CDC aparecessem.

Mais importante, o M01.17B estabeleceu evidência direta de que os metadados do CDC podem correlacionar alterações originadas pela mesma transação SQL entre instâncias de captura separadas.

A evidência permanece intencionalmente limitada ao CDC do SQL Server. A representação transacional, a ordenação da entrega, a atomicidade e a persistência nas etapas subsequentes ainda não haviam sido testadas e, portanto, permanecem não comprovadas.

**Status do M01.17B: APROVADO**

---

## 19. UPDATE Coordenado entre Tabelas — M01.18

Após validar uma transação de `INSERT` entre tabelas, o experimento seguinte examinou operações coordenadas de `UPDATE` na mesma estrutura de pai e filhos.

O M01.18 atualizou a linha de `sales.Transaction` e ambas as linhas relacionadas de `sales.TransactionItem` criadas durante o M01.17B dentro de uma única transação SQL.

O objetivo foi determinar como o CDC do SQL Server representa múltiplos comandos de `UPDATE` entre diferentes instâncias de captura, preservando ao mesmo tempo a correlação da transação, os limites dos comandos, as informações de sequência, as imagens de antes e depois e os metadados de alteração de colunas.

### 19.1 Objetivo

O objetivo do M01.18 foi validar:

- se operações coordenadas de `UPDATE` em múltiplas tabelas habilitadas para CDC compartilham o mesmo `__$start_lsn`;
- se comandos separados de `UPDATE` permanecem distinguíveis por meio de `__$command_id`;
- como `__$seqval` se comporta entre os comandos capturados;
- se cada `UPDATE` preserva seu próprio par `UPDATE_BEFORE` e `UPDATE_AFTER`;
- se cada par de atualização compartilha os mesmos metadados de transação, comando, sequência e máscara de atualização;
- se diferentes comandos de `UPDATE` produzem máscaras correspondentes às respectivas colunas afetadas.

O experimento reutilizou o conjunto de dados de pai e filhos estabelecido durante o M01.17B:

```text
sales.Transaction
TRN_id = 6308

sales.TransactionItem
TRNIT_id = 13770

sales.TransactionItem
TRNIT_id = 13771
```

### 19.2 Estrutura da Transação

Uma única transação SQL executou três comandos coordenados de `UPDATE`.

Conceitualmente:

```text
BEGIN TRANSACTION
│
├── Comando 1
│   └── UPDATE sales.Transaction
│
├── Comando 2
│   └── UPDATE sales.TransactionItem
│       TRNIT_id = 13770
│
├── Comando 3
│   └── UPDATE sales.TransactionItem
│       TRNIT_id = 13771
│
└── COMMIT
```

A transação pai foi alterada de seu estado anterior para:

```text
TRN_id:
6308

Status:
CONFIRMED

Valor Bruto:
200

Valor do Desconto:
20
```

O primeiro filho passou a ter:

```text
TRNIT_id:
13770

Quantidade:
2

Preço:
100

Desconto:
15
```

O segundo filho passou a ter:

```text
TRNIT_id:
13771

Quantidade:
1

Preço:
60

Desconto:
5
```

Os três `UPDATE`s foram confirmados como parte da mesma transação SQL.

### 19.3 Estado Final da Origem

Após a confirmação da transação, o estado final da origem era:

```text
sales.Transaction
│
└── TRN_id = 6308
    ├── Status = CONFIRMED
    ├── Bruto = 200
    └── Desconto = 20
          │
          ├───────────────────────────┐
          │                           │
          ▼                           ▼
sales.TransactionItem         sales.TransactionItem
│                             │
└── TRNIT_id = 13770          └── TRNIT_id = 13771
    ├── Quantidade = 2            ├── Quantidade = 1
    ├── Preço = 100               ├── Preço = 60
    └── Desconto = 15             └── Desconto = 5
```

A tabela de origem mostra apenas o estado resultante após a confirmação da transação.

O CDC, entretanto, preservou as transições que produziram esse estado final.

### 19.4 LSN de Transação Compartilhado

Todos os seis registros do CDC gerados pelos três comandos de `UPDATE` compartilharam:

```text
__$start_lsn = 0x0000002D00001CB9000E
```

Os seis registros consistiam em:

```text
UPDATE do Pai:
2 registros do CDC

UPDATE do Primeiro Filho:
2 registros do CDC

UPDATE do Segundo Filho:
2 registros do CDC
```

Portanto:

```text
Uma Transação SQL
        │
        │ __$start_lsn compartilhado
        ▼
0x0000002D00001CB9000E
        │
        ├── UPDATE_BEFORE do Pai
        ├── UPDATE_AFTER do Pai
        ├── UPDATE_BEFORE do Filho 13770
        ├── UPDATE_AFTER do Filho 13770
        ├── UPDATE_BEFORE do Filho 13771
        └── UPDATE_AFTER do Filho 13771
```

Isso reproduziu e ampliou o comportamento de correlação entre tabelas observado durante o M01.17B.

O experimento demonstrou que o LSN de transação compartilhado permaneceu disponível mesmo quando cada comando na origem gerou duas imagens de linha no CDC em vez de um único registro de inserção.

### 19.5 Identificadores de Comando e Valores de Sequência

Os três comandos na origem foram distinguidos por meio de `__$command_id`.

A estrutura observada foi:

```text
UPDATE do Pai
│
├── __$command_id = 1
└── __$seqval = ...0002

UPDATE do Filho 13770
│
├── __$command_id = 2
└── __$seqval = ...0007

UPDATE do Filho 13771
│
├── __$command_id = 3
└── __$seqval = ...000B
```

Os valores completos de sequência diferiam entre os três comandos, enquanto cada par de antes e depois compartilhava seu valor de sequência correspondente.

Conceitualmente:

```text
__$start_lsn compartilhado
│
├── Comando 1
│   ├── seqval ...0002
│   ├── operation 3
│   └── operation 4
│
├── Comando 2
│   ├── seqval ...0007
│   ├── operation 3
│   └── operation 4
│
└── Comando 3
    ├── seqval ...000B
    ├── operation 3
    └── operation 4
```

O experimento forneceu, portanto, evidência de responsabilidades distintas dos metadados:

```text
__$start_lsn
    → contexto comum da transação

__$command_id
    → distinção dos comandos dentro da transação

__$seqval
    → informações de sequenciamento das alterações capturadas

__$operation
    → semântica das imagens de linha de antes/depois
```

Os valores de sequência observados são evidências desta transação controlada. Eles não devem ser generalizados como uma regra de incremento numérico não documentada.

### 19.6 Máscaras de Atualização

Cada comando de `UPDATE` produziu uma máscara de atualização correspondente às colunas capturadas afetadas por esse comando.

Para a atualização do pai:

```text
TRN_id:
6308

__$command_id:
1

__$update_mask:
0x0168
```

Para a atualização do primeiro filho:

```text
TRNIT_id:
13770

__$command_id:
2

__$update_mask:
0x0150
```

Para a atualização do segundo filho:

```text
TRNIT_id:
13771

__$command_id:
3

__$update_mask:
0x0120
```

O modelo resultante foi:

```text
Pai
Comando 1
Máscara 0x0168
        │
        └── colunas afetadas pelo UPDATE do pai

Filho 13770
Comando 2
Máscara 0x0150
        │
        └── colunas afetadas pelo primeiro UPDATE do filho

Filho 13771
Comando 3
Máscara 0x0120
        │
        └── colunas afetadas pelo segundo UPDATE do filho
```

As diferentes máscaras demonstraram que os metadados de alteração de colunas permaneceram associados a cada comando individual de `UPDATE`, embora todos os três comandos pertencessem à mesma transação.

Portanto:

```text
Mesma Transação ≠ Mesma Máscara de Atualização
```

### 19.7 Semântica dos Pares de UPDATE

Cada um dos três comandos de `UPDATE` na origem produziu um par no CDC composto por:

```text
__$operation = 3
UPDATE_BEFORE

__$operation = 4
UPDATE_AFTER
```

Dentro de cada par, a relação observada entre os metadados foi:

```text
mesmo __$start_lsn
mesmo __$command_id
mesmo __$seqval
mesmo __$update_mask
__$operation diferente
```

A transação completa pode, portanto, ser representada como:

```text
__$start_lsn compartilhado
0x0000002D00001CB9000E
│
├── Comando 1 — Pai
│   ├── seqval ...0002
│   ├── máscara 0x0168
│   ├── op 3 → UPDATE_BEFORE
│   └── op 4 → UPDATE_AFTER
│
├── Comando 2 — Filho 13770
│   ├── seqval ...0007
│   ├── máscara 0x0150
│   ├── op 3 → UPDATE_BEFORE
│   └── op 4 → UPDATE_AFTER
│
└── Comando 3 — Filho 13771
    ├── seqval ...000B
    ├── máscara 0x0120
    ├── op 3 → UPDATE_BEFORE
    └── op 4 → UPDATE_AFTER
```

Isso estabelece que os seis registros físicos do CDC não devem ser interpretados como seis alterações de negócio não relacionadas.

Eles representam:

```text
1 transação SQL
3 comandos de UPDATE
3 pares de antes/depois
6 imagens de linha no CDC
```

A interpretação correta exige, portanto, múltiplos níveis de correlação.

### 19.8 Conclusão

O M01.18 validou com sucesso o comportamento de operações coordenadas de `UPDATE` entre tabelas.

Uma transação SQL atualizou:

```text
1 linha em sales.Transaction
+
2 linhas em sales.TransactionItem
```

e produziu:

```text
3 comandos de UPDATE
6 registros do CDC
```

Todos os seis registros compartilharam:

```text
__$start_lsn = 0x0000002D00001CB9000E
```

enquanto os comandos foram distinguidos por:

```text
Pai:
__$command_id = 1
__$seqval = ...0002
__$update_mask = 0x0168

Filho 13770:
__$command_id = 2
__$seqval = ...0007
__$update_mask = 0x0150

Filho 13771:
__$command_id = 3
__$seqval = ...000B
__$update_mask = 0x0120
```

Cada comando produziu um par correlacionado:

```text
operation 3 → UPDATE_BEFORE
operation 4 → UPDATE_AFTER
```

compartilhando o mesmo LSN de transação, identificador de comando, valor de sequência e máscara de atualização.

O M01.18 fortaleceu, portanto, o modelo de transação do CDC estabelecido durante os experimentos anteriores:

```text
Transação
    → __$start_lsn

Comando
    → __$command_id

Sequenciamento das Alterações
    → __$seqval

Semântica da Imagem de Linha
    → __$operation

Colunas Capturadas Afetadas
    → __$update_mask
```

O experimento demonstrou esse modelo entre instâncias de captura separadas do CDC, mantendo a fronteira entre a evidência do CDC do SQL Server e o comportamento subsequente que ainda não havia sido implementado ou testado.

**Status do M01.18: APROVADO**

---

## 20. DELETE do Pai com ON DELETE CASCADE — M01.19

Após validar operações de `INSERT` e `UPDATE` coordenadas entre tabelas, o experimento final do CDC no lado da origem examinou o comportamento de cascata referencial.

O M01.19 excluiu a linha pai de `sales.Transaction` criada durante o M01.17B e atualizada durante o M01.18.

Como o relacionamento de `sales.TransactionItem` estava configurado com `ON DELETE CASCADE`, o experimento permitiu ao projeto distinguir entre a única ação explícita executada pelo teste e as múltiplas alterações físicas de linhas produzidas pelo SQL Server.

### 20.1 Objetivo

O objetivo do M01.19 foi validar:

- se um `DELETE` explícito do pai era capturado pelo CDC;
- se as linhas filhas removidas por meio de `ON DELETE CASCADE` também eram capturadas;
- se os registros de exclusão do pai e dos filhos compartilhavam o mesmo contexto de transação;
- como `__$command_id` e `__$seqval` representavam as alterações físicas resultantes;
- se o CDC expunha os efeitos físicos da transação no banco de dados, em vez de apenas a instrução explícita da aplicação;
- se a correlação entre tabelas permanecia disponível para exclusões geradas por ações referenciais.

O experimento reutilizou:

```text
sales.Transaction
TRN_id = 6308

sales.TransactionItem
TRNIT_id = 13770

sales.TransactionItem
TRNIT_id = 13771
```

### 20.2 Estado da Origem Antes do DELETE

Antes de executar a exclusão controlada, o estado da origem foi validado.

A linha pai existia:

```text
sales.Transaction

TRN_id:
6308

Linhas:
1
```

e duas linhas filhas relacionadas existiam:

```text
sales.TransactionItem

TRNIT_id:
13770

TRNIT_id:
13771

Linhas:
2
```

O estado inicial era, portanto:

```text
Pai:
1 linha

Filhos:
2 linhas
```

O relacionamento de chave estrangeira havia sido validado anteriormente como:

```text
FK_TRNIT_TRN
ON DELETE CASCADE
```

Isso estabeleceu o comportamento referencial esperado antes da execução da ação de teste.

### 20.3 DELETE Explícito do Pai

O teste controlado executou um `DELETE` apenas contra a tabela pai.

Conceitualmente:

```sql
DELETE
FROM sales.Transaction
WHERE TRN_id = 6308;
```

Nenhuma instrução `DELETE` explícita foi executada contra:

```text
sales.TransactionItem
```

A ação no nível da aplicação era, portanto:

```text
1 instrução DELETE explícita
        │
        ▼
sales.Transaction
TRN_id = 6308
```

Como a chave estrangeira entre pai e filhos utilizava `ON DELETE CASCADE`, o SQL Server era responsável por remover as linhas filhas relacionadas como parte da mesma operação transacional.

### 20.4 Cascata Referencial

Após a confirmação da exclusão do pai, o estado da origem era:

```text
sales.Transaction
TRN_id = 6308
Linhas = 0

sales.TransactionItem
TRNIT_id IN (13770, 13771)
Linhas = 0
```

A transição física da origem foi, portanto:

```text
Antes
│
├── Pai 6308
├── Filho 13770
└── Filho 13771
        │
        │ DELETE explícito do pai
        ▼
ON DELETE CASCADE
        │
        ▼
Depois
│
├── Pai 6308 removido
├── Filho 13770 removido
└── Filho 13771 removido
```

Uma instrução explícita resultou, portanto, em três exclusões físicas de linhas.

Essa distinção é essencial ao interpretar os registros resultantes do CDC.

### 20.5 Representação no CDC

O CDC capturou:

```text
sales.Transaction:
1 DELETE

sales.TransactionItem:
2 DELETEs
```

Todos os três registros foram representados com:

```text
__$operation = 1
```

A máscara de atualização observada para os registros de exclusão foi:

```text
__$update_mask = 0x01FF
```

A representação resultante no CDC foi:

```text
DELETE explícito do pai
        │
        ▼
Processamento referencial do SQL Server
        │
        ├── Linha pai excluída
        │       ↓
        │   operation 1 no CDC
        │
        ├── Filho 13770 excluído
        │       ↓
        │   operation 1 no CDC
        │
        └── Filho 13771 excluído
                ↓
            operation 1 no CDC
```

O CDC expôs, portanto, as alterações físicas de linhas resultantes entre ambas as instâncias de captura.

### 20.6 LSN de Transação Compartilhado

Todos os três registros de exclusão compartilharam:

```text
__$start_lsn = 0x0000002D00001D000017
```

O contexto comum de transação foi, portanto, preservado entre:

```text
sales.Transaction
```

e:

```text
sales.TransactionItem
```

Conceitualmente:

```text
__$start_lsn
0x0000002D00001D000017
│
├── DELETE do Pai
│
├── DELETE do Filho 13770
│
└── DELETE do Filho 13771
```

Os três registros também foram associados ao mesmo horário de transação observado no CDC:

```text
2026-08-29 09:22:53.427
```

Isso forneceu evidência adicional de que as exclusões capturadas do pai e dos filhos geradas pela cascata pertenciam ao mesmo contexto de transação na origem.

### 20.7 Ordenação dos Comandos

Os registros de exclusão capturados foram distinguidos por meio de `__$command_id` e `__$seqval`.

Os metadados observados foram:

```text
Pai 6308
│
├── __$command_id = 1
├── __$seqval = ...0009
└── __$operation = 1

Filho 13770
│
├── __$command_id = 2
├── __$seqval = ...0011
└── __$operation = 1

Filho 13771
│
├── __$command_id = 3
├── __$seqval = ...0016
└── __$operation = 1
```

Todos os três registros compartilharam o mesmo LSN de transação, preservando metadados distintos de comando e sequência.

A estrutura observada foi:

```text
Uma Transação SQL
│
│  __$start_lsn =
│  0x0000002D00001D000017
│
├── Comando 1
│   └── DELETE do Pai
│
├── Comando 2
│   └── DELETE do Filho 13770
│
└── Comando 3
    └── DELETE do Filho 13771
```

Os valores de sequência são registrados como evidência desta transação controlada e não devem ser generalizados como uma regra aritmética ou de incremento não documentada.

### 20.8 Ação da Aplicação versus Alterações Físicas

O M01.19 estabeleceu uma distinção semântica importante.

No nível da aplicação ou do *script* de teste:

```text
Instruções DELETE explícitas:
1
```

No nível das alterações físicas na origem:

```text
Linhas excluídas:
3
```

No nível do CDC:

```text
Registros de DELETE:
3
```

Portanto:

```text
1 ação lógica da aplicação
        │
        ▼
1 DELETE explícito do pai
        │
        ▼
Cascata referencial
        │
        ▼
3 exclusões físicas de linhas
        │
        ▼
3 registros de DELETE no CDC
```

A presença de três eventos de exclusão no CDC não deve ser interpretada como evidência de que a aplicação executou três instruções `DELETE` explícitas.

O CDC expõe as alterações capturadas no banco de dados, incluindo alterações produzidas por ações referenciais.

Essa distinção é importante para futuros consumidores subsequentes porque:

```text
Número de Registros do CDC ≠ Número de Instruções Explícitas da Aplicação
```

O contexto da transação deve ser preservado ao interpretar alterações relacionadas.

### 20.9 Resultado Observado

Após o processamento da captura, o estado acumulado do CDC para os registros controlados do laboratório mostrou:

```text
sales.Transaction

transaction_change_rows_after:
4

transaction_deletes:
1
```

e:

```text
sales.TransactionItem

item_change_rows_after:
8

item_deletes:
2
```

Para a própria transação do M01.19, a evidência relevante de exclusão foi:

```text
Pai 6308
│
├── operation = 1
├── command_id = 1
├── seqval = ...0009
├── update_mask = 0x01FF
└── start_lsn =
    0x0000002D00001D000017

Filho 13770
│
├── operation = 1
├── command_id = 2
├── seqval = ...0011
├── update_mask = 0x01FF
└── start_lsn =
    0x0000002D00001D000017

Filho 13771
│
├── operation = 1
├── command_id = 3
├── seqval = ...0016
├── update_mask = 0x01FF
└── start_lsn =
    0x0000002D00001D000017
```

O estado da origem após a transação não continha nem o pai nem suas duas linhas filhas.

O CDC capturou evidências das três exclusões físicas.

### 20.10 Conclusão

O M01.19 validou com sucesso o comportamento do CDC para um `DELETE` do pai combinado com `ON DELETE CASCADE`.

O teste controlado executou apenas:

```text
1 DELETE explícito
```

contra:

```text
sales.Transaction
TRN_id = 6308
```

O SQL Server removeu então:

```text
1 linha pai
+
2 linhas filhas
=
3 exclusões físicas
```

O CDC capturou todas as três alterações físicas como:

```text
__$operation = 1
```

com o contexto de transação compartilhado:

```text
__$start_lsn = 0x0000002D00001D000017
```

e os identificadores de comando:

```text
1 → Pai 6308
2 → Filho 13770
3 → Filho 13771
```

O experimento estabeleceu, portanto, que os efeitos da cascata referencial são visíveis por meio do CDC e podem ser correlacionados entre as instâncias de captura do pai e dos filhos.

Mais importante, ele estabeleceu a distinção:

```text
Ação da Aplicação ≠ Número de Alterações Físicas no Banco de Dados ≠ Número de Registros do CDC Interpretados como Instruções da Aplicação
```

Um consumidor subsequente deve preservar o contexto da transação em vez de inferir o comportamento da aplicação exclusivamente a partir da quantidade de registros individuais do CDC.

O M01.19 conclui o ciclo controlado de comportamento do CDC no lado da origem para o escopo transacional inicial de `AtlasCommerce.sales`.

A implementação validou agora o comportamento de `INSERT`, `UPDATE` e `DELETE` em tabelas individuais e entre tabelas, incluindo múltiplos comandos dentro de uma única transação e os efeitos da cascata referencial.

**Status do M01.19: APROVADO**

---

## 21. Modelo Consolidado de Transações do CDC

Os experimentos controlados do M01.12 ao M01.19 estabeleceram progressivamente como os metadados do CDC do SQL Server representam alterações dentro do escopo transacional validado de `AtlasCommerce.sales`.

Os testes individuais examinaram comportamentos específicos, como inserções, atualizações, múltiplos comandos, transações entre tabelas e exclusões geradas por cascata.

Esta seção consolida essas observações em um único modelo de transação.

O modelo é baseado no comportamento diretamente observado durante o ciclo controlado de laboratório. Ele não pretende redefinir os mecanismos internos do CDC do SQL Server além das evidências estabelecidas por esses experimentos.

### 21.1 LSN de Transação

Nos experimentos com múltiplos comandos e entre tabelas, as alterações originadas pela mesma transação SQL confirmada compartilharam:

```text
__$start_lsn
```

Esse comportamento foi observado em:

```text
M01.14
Múltiplos comandos de UPDATE dentro de uma única transação

M01.17B
Transação de INSERT entre tabelas

M01.18
UPDATE coordenado entre tabelas

M01.19
DELETE do pai com ON DELETE CASCADE
```

O modelo de correlação resultante é:

```text
Transação SQL
      │
      ▼
__$start_lsn compartilhado
      │
      ├── alteração capturada
      ├── alteração capturada
      ├── alteração capturada
      └── ...
```

Para transações entre tabelas, o mesmo LSN de transação foi observado em registros armazenados por meio de diferentes instâncias de captura.

Por exemplo:

```text
CDC de sales.Transaction
        │
        └──────────┐
                   │
                   ▼
          __$start_lsn compartilhado
                   ▲
                   │
        ┌──────────┘
        │
CDC de sales.TransactionItem
```

Dentro do modelo validado no lado da origem, `__$start_lsn` fornece, portanto, o principal metadado do CDC utilizado para correlacionar alterações capturadas ao contexto comum de sua transação SQL.

Isso não significa que `__$start_lsn`, isoladamente, forneça o modelo completo de ordenação ou processamento. Metadados adicionais são necessários para distinguir comandos e imagens de linha dentro da transação.

### 21.2 Identificador de Comando

Os experimentos controlados demonstraram que uma única transação SQL pode conter múltiplos comandos na origem.

Dentro de um LSN de transação compartilhado, o valor observado de:

```text
__$command_id
```

distinguiu esses comandos.

Por exemplo, o M01.17B produziu:

```text
__$start_lsn compartilhado
│
├── command_id = 1
│   └── INSERT do Pai
│
├── command_id = 2
│   └── INSERT do Primeiro Filho
│
└── command_id = 3
    └── INSERT do Segundo Filho
```

O M01.18 e o M01.19 reproduziram a mesma relação geral para operações coordenadas de `UPDATE` e exclusões relacionadas à cascata.

A hierarquia resultante é:

```text
Transação
│
└── __$start_lsn
    │
    ├── Comando
    │   └── __$command_id
    │
    ├── Comando
    │   └── __$command_id
    │
    └── Comando
        └── __$command_id
```

Portanto:

```text
__$start_lsn
    → contexto da transação

__$command_id
    → distinção dos comandos dentro desse contexto
```

Essa distinção impede que um consumidor interprete incorretamente todos os registros do CDC que compartilham um LSN de transação como representações do mesmo comando na origem.

### 21.3 Valor de Sequência

Os experimentos também observaram:

```text
__$seqval
```

como parte dos metadados de sequenciamento das alterações capturadas.

Durante o M01.18, por exemplo:

```text
UPDATE do Pai
seqval = ...0002

UPDATE do Filho 13770
seqval = ...0007

UPDATE do Filho 13771
seqval = ...000B
```

Durante o M01.19:

```text
DELETE do Pai
seqval = ...0009

DELETE do Filho 13770
seqval = ...0011

DELETE do Filho 13771
seqval = ...0016
```

Para cada atualização controlada, os registros `UPDATE_BEFORE` e `UPDATE_AFTER` pertencentes ao mesmo comando de `UPDATE` compartilharam o mesmo valor de sequência.

Portanto, o modelo observado foi:

```text
Comando de UPDATE
│
├── UPDATE_BEFORE
│   └── mesmo __$seqval
│
└── UPDATE_AFTER
    └── mesmo __$seqval
```

Entre comandos distintos, foram observados valores de sequência diferentes.

Os valores de sequência são utilizados como informações de sequenciamento dentro do modelo de transação do CDC, mas os valores hexadecimais exatos observados durante o laboratório não devem ser interpretados como definição de uma regra aritmética de incremento.

O Atlas Engineering registra a relação de ordenação observada sem inventar semânticas não documentadas a partir das diferenças numéricas entre os valores.

### 21.4 Operação

O metadado `__$operation` identifica a semântica da imagem de linha representada por um registro individual do CDC.

O ciclo controlado de laboratório observou:

| `__$operation` | Significado |
|---:|---|
| `1` | `DELETE` |
| `2` | `INSERT` |
| `3` | `UPDATE_BEFORE` |
| `4` | `UPDATE_AFTER` |

O modelo básico é:

```text
INSERT
    ↓
operation = 2
```

```text
DELETE
    ↓
operation = 1
```

e:

```text
UPDATE
   │
   ├── operation = 3
   │   UPDATE_BEFORE
   │
   └── operation = 4
       UPDATE_AFTER
```

O código de operação não pode, portanto, ser interpretado independentemente dos metadados de transação e comando que o cercam.

Em particular:

```text
operation 3
+
operation 4
```

com o mesmo contexto de transação, comando, sequência e máscara de atualização representam as imagens de antes e depois da mesma atualização controlada.

Eles não representam duas atualizações independentes da aplicação.

### 21.5 Máscara de Atualização

`__$update_mask` fornece metadados sobre as colunas capturadas declaradas como afetadas por uma operação de `UPDATE`.

Diferentes comandos controlados de `UPDATE` produziram máscaras diferentes.

Entre os valores observados durante o laboratório estavam:

```text
0x0108
0x0160
0x0168
0x0150
0x0120
```

Os valores variaram de acordo com as colunas capturadas afetadas por cada comando controlado.

Portanto:

```text
Mesma Transação ≠ Mesma Máscara de Atualização
```

Para um par de atualização, entretanto, as imagens de antes e depois compartilharam a mesma máscara observada:

```text
UPDATE
│
├── operation 3
│   └── update_mask = X
│
└── operation 4
    └── update_mask = X
```

Para as operações controladas de `INSERT` e `DELETE` desta implementação, a máscara observada foi:

```text
0x01FF
```

correspondente ao conjunto completo das nove colunas capturadas.

A máscara deve ser interpretada em relação aos metadados das colunas capturadas da instância de captura correspondente.

Ela é um metadado de alteração do CDC, não um identificador do domínio de negócio.

### 21.6 Modelo dos Pares de UPDATE

Os experimentos estabeleceram um modelo consistente para as operações controladas de `UPDATE`:

```text
Um comando de UPDATE na origem
        │
        ▼
Duas imagens de linha no CDC
        │
        ├── UPDATE_BEFORE
        │   operation = 3
        │
        └── UPDATE_AFTER
            operation = 4
```

Dentro do par observado:

```text
__$start_lsn
    → mesmo

__$command_id
    → mesmo

__$seqval
    → mesmo

__$update_mask
    → mesmo

__$operation
    → diferente
```

Portanto, o modelo de correlação é:

```text
UPDATE_BEFORE
│
├── transação X
├── comando Y
├── sequência Z
├── máscara M
└── operation 3

        ↕

UPDATE_AFTER
│
├── transação X
├── comando Y
├── sequência Z
├── máscara M
└── operation 4
```

Isso fornece a base estrutural para interpretar as duas linhas do CDC como uma única transição de `UPDATE` na origem.

Um futuro consumidor do CDC deve considerar essa representação em pares, em vez de tratar cada linha física da tabela de alterações como um evento lógico independente da origem.

O algoritmo efetivo do consumidor permanece fora das evidências de implementação estabelecidas até o M01.19.

### 21.7 Correlação entre Tabelas

A extensão mais importante do modelo de transação veio do M01.17B ao M01.19.

Os experimentos demonstraram que os metadados de transação podem ser utilizados para correlacionar alterações entre:

```text
cdc.sales_Transaction_CT
```

e:

```text
cdc.sales_TransactionItem_CT
```

quando essas alterações se originaram da mesma transação SQL.

O modelo consolidado é:

```text
Transação SQL
│
└── __$start_lsn
    │
    ├── Comando 1
    │   ├── __$command_id
    │   ├── __$seqval
    │   ├── __$operation
    │   └── __$update_mask
    │
    ├── Comando 2
    │   ├── __$command_id
    │   ├── __$seqval
    │   ├── __$operation
    │   └── __$update_mask
    │
    └── Comando N
        ├── __$command_id
        ├── __$seqval
        ├── __$operation
        └── __$update_mask
```

em que os comandos podem pertencer a diferentes instâncias de captura do CDC.

O laboratório estabeleceu, portanto, o seguinte modelo de interpretação no lado da origem:

```text
Transação
    → __$start_lsn

Comando dentro da transação
    → __$command_id

Sequenciamento das alterações capturadas
    → __$seqval

Semântica da imagem de linha
    → __$operation

Colunas capturadas afetadas
    → __$update_mask
```

Esse modelo explica por que os registros do CDC devem ser interpretados em contexto.

Por exemplo:

```text
1 ação da aplicação
```

pode resultar em:

```text
múltiplas alterações físicas no banco de dados
```

que podem resultar em:

```text
múltiplos registros do CDC
```

entre:

```text
múltiplas instâncias de captura
```

ainda pertencendo a:

```text
uma única transação SQL na origem
```

O modelo é deliberadamente limitado ao comportamento do CDC do SQL Server validado em laboratório.

Ele não estabelece que uma futura implementação com Debezium, Kafka ou Bronze preservará automaticamente esses registros como um pacote transacional indivisível.

Esse comportamento subsequente exige implementação e evidências separadas.

O modelo consolidado de transações do CDC torna-se, portanto, a base no lado da origem para o próximo problema de engenharia: projetar um consumidor capaz de processar o CDC incrementalmente sem descartar o contexto de transação demonstrado do M01.12 ao M01.19.

---

## 22. Modelo de Captura Assíncrona

Os experimentos controlados demonstraram que a captura do CDC do SQL Server é assíncrona em relação à confirmação da transação na origem.

Um `COMMIT` bem-sucedido estabelece o estado confirmado da origem, mas não implica que os registros correspondentes do CDC já estejam disponíveis para consumo exatamente naquele momento.

Essa distinção foi observada diretamente durante o ciclo de laboratório e é fundamental para o projeto do futuro consumidor do CDC.

### 22.1 Confirmação da Transação versus Disponibilidade no CDC

A primeira evidência direta da captura assíncrona foi produzida durante o M01.12.

Após o `INSERT` controlado de:

```text
TRN_id = 6307
```

a transação na origem havia sido confirmada com sucesso e a linha estava disponível em `sales.Transaction`.

Uma inspeção imediata do CDC, entretanto, retornou:

```text
matching_change_rows = 0
```

Após aproximadamente seis segundos, a mesma inspeção retornou:

```text
matching_change_rows = 1
```

A sequência observada foi, portanto:

```text
DML na Origem
    ↓
COMMIT
    ↓
Estado da origem disponível
    ↓
Registro do CDC não necessariamente disponível
    ↓
Processamento da captura
    ↓
Registro do CDC disponível
```

O mesmo comportamento geral foi reproduzido durante o experimento de `INSERT` entre tabelas no M01.17B.

Imediatamente após a confirmação da transação:

```text
Correspondências no CDC de sales.Transaction:
0

Correspondências no CDC de sales.TransactionItem:
0
```

Após o processamento da captura:

```text
Correspondências no CDC de sales.Transaction:
1

Correspondências no CDC de sales.TransactionItem:
2
```

A observação repetida estabeleceu:

```text
COMMIT ≠ Disponibilidade Imediata no CDC
```

Isso não significa que a transação na origem esteja incompleta enquanto a captura pelo CDC está pendente.

A transação na origem já foi confirmada.

O atraso existe entre o estado confirmado da origem e sua disponibilidade subsequente por meio das estruturas de captura do CDC.

### 22.2 Polling do Job de Captura

A configuração do *job* de captura inspecionada durante a implementação incluía:

```text
continuous:
1

pollinginterval:
5 segundos

maxtrans:
10000

maxscans:
10
```

A configuração observada é consistente com um processo de captura em execução contínua que verifica periodicamente a existência de trabalho adicional.

Conceitualmente:

```text
Log de Transações
      │
      │ alterações confirmadas
      ▼
Processo de Captura do CDC
      │
      ├── varredura
      ├── processamento das alterações elegíveis
      ├── ciclos adicionais de varredura
      └── intervalo de polling
              │
              ▼
Tabelas de Alterações do CDC
```

O valor configurado:

```text
pollinginterval = 5
```

não deve ser interpretado como:

```text
Latência do CDC = exatamente 5 segundos
```

nem como:

```text
Latência do CDC ≤ 5 segundos
```

O intervalo de *polling* é um parâmetro operacional do processo de captura.

A disponibilidade efetiva depende das condições de execução e do processamento da captura.

Portanto:

```text
Configuração de Polling ≠ Garantia de Latência
```

### 22.3 Observação de Laboratório

Os *scripts* controlados de laboratório frequentemente aguardavam aproximadamente seis segundos antes de realizar a inspeção posterior à captura.

Esse intervalo foi útil para os experimentos controlados porque a configuração de captura observada utilizava um intervalo de *polling* de cinco segundos.

O padrão resultante no laboratório foi:

```text
COMMIT
    ↓
Inspeção imediata
    ↓
Evento do CDC pode ainda não existir
    ↓
AGUARDAR aproximadamente 6 segundos
    ↓
Segunda inspeção
    ↓
Evento do CDC observado
```

Esse padrão forneceu um mecanismo prático para demonstrar a fronteira assíncrona.

Ele não deve ser convertido em uma regra de implementação em produção, como:

```text
Sempre aguardar seis segundos antes de ler o CDC.
```

Uma regra desse tipo confundiria uma técnica de observação utilizada em laboratório com uma estratégia de consumo em produção.

Os experimentos demonstraram que os registros do CDC podem tornar-se disponíveis após a confirmação da transação na origem, em vez de simultaneamente a ela.

Eles não comprovam que seis segundos sejam universalmente suficientes, necessários, ideais ou garantidos.

### 22.4 Fronteira da Evidência em Produção

A arquitetura do Atlas Engineering distingue entre o comportamento do CDC observado em laboratório e o futuro objetivo de atualização dos dados em produção.

O objetivo arquitetural atual inclui:

```text
Atualização típica dos dados:
aproximadamente 3–5 minutos

Meta formal P95:
≤ 15 minutos
```

Esses valores são objetivos da plataforma.

Eles não foram medidos como latência *end-to-end* em produção durante o M01.08 ao M01.19.

A evidência de laboratório estabelece apenas o comportamento assíncrono no lado da origem:

```text
COMMIT na Origem
      │
      ▼
Captura pelo CDC ocorre de forma assíncrona
      │
      ▼
Registro do CDC torna-se disponível
```

O caminho completo em produção conterá etapas adicionais:

```text
COMMIT na Origem
      ↓
CDC do SQL Server
      ↓
Consumo do CDC
      ↓
Transporte / Integração
      ↓
Persistência Bronze
      ↓
Disponibilidade na Plataforma
```

A latência desse caminho completo ainda não foi implementada nem medida.

Portanto:

```text
Atraso Observado na Captura do CDC ≠ Latência End-to-End da Plataforma

Intervalo de Polling Configurado ≠ SLO de Atualização em Produção

Duração do WAITFOR em Laboratório ≠ Contrato de Polling do Consumidor
```

O futuro consumidor deve ser projetado em torno do fato de que a disponibilidade no CDC é assíncrona, e não em torno de uma suposição fixa sobre quantos segundos a captura exigirá.

O M01.12 e o M01.17B fornecem evidência direta de laboratório para esse modelo assíncrono.

A latência em produção, o comportamento de *backlog*, o desempenho de *catch-up* e a atualização *end-to-end* permanecem fora das evidências estabelecidas até o M01.19 e exigem validação nas etapas subsequentes da implementação.

---

## 23. Semântica de Tempo

A implementação do CDC expôs múltiplas noções de tempo que representam diferentes estágios do ciclo de vida de uma alteração.

Esses *timestamps* não devem ser tratados como intercambiáveis.

Uma transação de negócio pode carregar seu próprio *timestamp* do evento, o CDC do SQL Server pode associar a alteração confirmada ao tempo da transação derivado de seu LSN, e a futura plataforma de dados introduzirá um *timestamp* adicional de ingestão quando o evento for persistido nas etapas subsequentes.

O modelo resultante contém pelo menos três domínios de tempo distintos:

```text
Tempo do Evento de Negócio
        ↓
Tempo da Transação no CDC
        ↓
Tempo de Ingestão na Plataforma
```

Cada domínio de tempo responde a uma pergunta diferente.

### 23.1 Tempo do Evento de Negócio

O tempo do evento de negócio é representado por *timestamps* armazenados nos dados de negócio da origem.

Para `sales.Transaction`, os experimentos controlados incluíram:

```text
TRN_transaction_at
```

Esse valor pertence ao modelo do domínio da origem.

Conceitualmente, ele responde:

```text
Quando o registro de negócio da origem indica que a transação ocorreu?
```

Ele faz parte dos dados capturados da origem e não deve ser confundido com o momento em que o CDC processou a alteração correspondente.

Por exemplo:

```text
sales.Transaction
│
├── TRN_id
├── TRN_transaction_at
├── TRN_status
├── TRN_gross_amount
└── ...
```

Quando o CDC captura a linha, `TRN_transaction_at` permanece uma coluna da origem.

Sua semântica tem origem na aplicação transacional e no modelo do banco de dados, e não no próprio CDC.

Portanto:

```text
TRN_transaction_at = Timestamp do Domínio de Negócio
```

Ele não estabelece quando o SQL Server confirmou a transação visível ao CDC.

### 23.2 Tempo da Transação no CDC

O CDC do SQL Server fornece um mecanismo separado para associar um LSN ao tempo da transação.

Durante os experimentos controlados, o LSN da transação pôde ser mapeado utilizando:

```sql
sys.fn_cdc_map_lsn_to_time(...)
```

Conceitualmente:

```text
__$start_lsn
      │
      ▼
sys.fn_cdc_map_lsn_to_time(...)
      │
      ▼
Tempo da transação no CDC
```

Esse *timestamp* pertence ao contexto da transação do CDC, e não aos dados de negócio.

Por exemplo, o M01.19 observou os registros de exclusão do pai e dos filhos gerados pela cascata com o mesmo:

```text
__$start_lsn = 0x0000002D00001D000017
```

e o mesmo tempo de transação mapeado no CDC:

```text
2026-08-29 09:22:53.427
```

A relação foi:

```text
DELETE do Pai
│
├── start_lsn = X
└── tempo da transação no CDC = T

DELETE do Filho
│
├── start_lsn = X
└── tempo da transação no CDC = T

DELETE do Filho
│
├── start_lsn = X
└── tempo da transação no CDC = T
```

Isso reforçou o contexto de transação compartilhado já estabelecido por meio dos metadados do CDC.

O tempo da transação no CDC responde a uma pergunta diferente daquela respondida pelo *timestamp* de negócio da origem:

```text
Tempo do Evento de Negócio
    → tempo representado pelos dados de negócio da origem

Tempo da Transação no CDC
    → tempo da transação associado ao LSN do CDC
```

Portanto:

```text
TRN_transaction_at ≠ sys.fn_cdc_map_lsn_to_time(__$start_lsn)
```

Os valores podem, em alguns casos, ser temporalmente próximos, mas não se deve inferir equivalência semântica a partir dessa proximidade.

Um futuro consumidor deve preservar essa distinção caso ambos os valores sejam levados para a plataforma.

### 23.3 Futuro Tempo de Ingestão na Plataforma

A futura plataforma de dados introduzirá outro *timestamp* quando os dados do CDC forem consumidos e persistidos nas etapas subsequentes.

Conceitualmente:

```text
ingestion_time
```

responderia:

```text
Quando a plataforma Atlas Engineering recebeu ou persistiu esta alteração?
```

Esse *timestamp* ainda não pertence à origem no SQL Server nem às tabelas de captura do CDC.

Ele será introduzido em uma etapa posterior da implementação.

A linha do tempo conceitual completa é, portanto:

```text
Evento de Negócio
      │
      │ TRN_transaction_at
      ▼
Transação na Origem
      │
      │ COMMIT
      ▼
Contexto da Transação no CDC
      │
      │ __$start_lsn
      │ tempo da transação mapeado
      ▼
Disponibilidade Assíncrona no CDC
      │
      ▼
Futuro Consumidor do CDC
      │
      ▼
Persistência na Plataforma
      │
      │ ingestion_time
      ▼
Bronze
```

Os três domínios de tempo respondem a perguntas diferentes:

| Domínio de Tempo | Exemplo | Significado |
|---|---|---|
| Tempo do Evento de Negócio | `TRN_transaction_at` | Tempo representado pelo evento de negócio da origem |
| Tempo da Transação no CDC | `sys.fn_cdc_map_lsn_to_time(__$start_lsn)` | Tempo da transação associado ao LSN do CDC |
| Tempo de Ingestão na Plataforma | Futuro `ingestion_time` | Momento em que a plataforma recebe ou persiste a alteração |

Os dois primeiros estavam disponíveis para inspeção durante o laboratório do CDC no lado da origem.

O terceiro ainda não foi implementado.

Portanto, nenhum *timestamp* de ingestão observado nem latência *end-to-end* podem ser afirmados com base no M01.08 ao M01.19.

Essa distinção se tornará especialmente importante quando os futuros componentes da plataforma calcularem:

```text
atraso da origem até a captura

atraso da captura até a ingestão

atualização end-to-end
```

Essas medições exigem *timestamps* provenientes de diferentes fronteiras do ciclo de vida.

A implementação do CDC estabelece a semântica no lado da origem necessária para essa futura medição, mas ainda não fornece evidência de produção para a cadeia temporal completa.

---

## 24. Erros e Correções da Implementação

O ciclo de implementação do CDC incluiu diversas situações nas quais ocorreram resultados inesperados durante a execução ou validação.

Essas situações fazem parte das evidências de engenharia.

Elas são documentadas porque um registro confiável da implementação deve distinguir entre:

```text
Falha da Plataforma
```

e:

```text
Erro de Script
Estado Operacional
Estado Transitório da Plataforma
Interpretação Incorreta
```

Nenhum dos incidentes documentados nesta seção invalidou os comportamentos do CDC comprovados até o M01.19.

Em vez disso, cada incidente produziu uma lição operacional ou de implementação adicional que deve ser incorporada aos futuros *scripts* e à automação.

### 24.1 Solicitação de Parada do Job de Cleanup

Durante o M01.10B, a retenção do *cleanup* do CDC foi alterada do valor original:

```text
4.320 minutos
```

para o valor operacional da V1:

```text
21.600 minutos
```

que corresponde a:

```text
15 dias
```

Como parte do procedimento operacional, o *script* tentou interromper o *job* de *cleanup* do CDC.

O SQL Server Agent retornou:

```text
Msg 22022
```

com a condição relevante indicando que a solicitação para interromper:

```text
cdc.AtlasCommerce_cleanup
```

foi recusada porque o *job* não estava em execução naquele momento.

A distinção importante foi:

```text
STOP solicitado
        │
        ▼
Job já não estava em execução
        │
        ▼
Solicitação de parada recusada
```

em vez de:

```text
Falha do Job de Cleanup do CDC
```

O *job* de *cleanup* é periódico e não se espera que permaneça continuamente ativo.

Portanto, solicitar sua parada enquanto o *job* já está inativo é uma condição de estado operacional, e não evidência de mau funcionamento do CDC.

A configuração de retenção foi posteriormente confirmada como:

```text
retention = 21600
threshold = 4999
```

e o *job* de *cleanup* foi posteriormente iniciado com sucesso.

O incidente não invalidou a alteração da retenção.

O requisito resultante para os *scripts* é:

```text
Antes de solicitar STOP
        │
        ▼
Inspecionar o estado atual do job do SQL Server Agent
        │
        ├── Em execução
        │      ↓
        │    STOP
        │
        └── Não está em execução
               ↓
             Não emitir STOP desnecessário
```

Os futuros *scripts* operacionais devem, portanto, verificar o estado do *job* antes de tentar interromper um *job* do CDC.

### 24.2 Erro de Parâmetro em `sp_cdc_help_change_data_capture`

Durante o M01.17A, o *script* de validação tentou executar:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

O SQL Server retornou:

```text
Msg 22972
```

A chamada inicial era inválida porque `sys.sp_cdc_help_change_data_capture` não oferece suporte à inspeção pretendida quando apenas o *schema* da origem é fornecido.

Para uma tabela específica, os parâmetros necessários para identificação da origem devem ser fornecidos em conjunto.

Para a inspeção necessária de todo o ambiente, a execução corrigida foi:

```sql
EXEC sys.sp_cdc_help_change_data_capture;
```

A classificação da falha foi, portanto:

```text
Script de Validação:
ERRO

Configuração do CDC:
NÃO FALHOU
```

Nenhuma instância de captura precisou ser:

```text
desabilitada
recriada
reparada
```

A correção ficou limitada ao *script* de inspeção.

Esse incidente reforça um princípio geral de implementação:

```text
Um erro retornado durante a inspeção de um subsistema não comprova automaticamente que o subsistema inspecionado apresenta erro.
```

O comando que falhou, seus parâmetros e o estado real da plataforma devem ser separados durante o diagnóstico.

### 24.3 Observação Transitória do LSN Mínimo

Uma classe diferente de estado inesperado ocorreu durante o M01.16B após o CDC ser habilitado em:

```text
sales.TransactionItem
```

A instância de captura já havia sido criada com:

```text
start_lsn = 0x0000002D00001044008A
```

mas uma chamada imediata para determinar o LSN mínimo disponível retornou temporariamente:

```text
NULL
```

Naquele momento, o estado observado era:

```text
Instância de Captura:
Criada

LSN Inicial:
Disponível

LSN Mínimo Consultável:
NULL
```

Uma inspeção posterior retornou:

```text
minimum_lsn = 0x0000002D00001044008A
```

correspondendo ao LSN inicial da instância de captura.

A transição foi, portanto:

```text
Habilitar instância de captura
        │
        ▼
start_lsn estabelecido
        │
        ▼
Inspeção imediata do LSN mínimo
        │
        ▼
NULL
        │
        ▼
Processamento da captura avança
        │
        ▼
minimum_lsn disponível
```

O `NULL` inicial não foi classificado como:

```text
Falha na Habilitação do CDC
```

porque a validação subsequente demonstrou que a instância de captura tornou-se consultável a partir de seu limite inferior esperado sem exigir reconfiguração.

Esse comportamento tem implicações diretas para futuras automações.

Um *script* que habilita o CDC e solicita imediatamente o LSN mínimo deve considerar a possibilidade de que o limite consultável ainda não esteja disponível naquele exato momento da observação.

Portanto:

```text
NULL Imediato no LSN Mínimo ≠ Comprovação Automática de Falha do CDC
```

A resposta correta é inspecionar o estado do CDC ao redor dessa condição e considerar a inicialização assíncrona antes de declarar uma falha.

### 24.4 Lições de Engenharia

Os incidentes observados durante o ciclo de implementação enquadram-se em três categorias distintas:

| Incidente | Classificação | Falha do CDC |
|---|---|---|
| Parada do *job* de *cleanup* recusada | Condição de estado operacional | Não |
| Erro em `sp_cdc_help_change_data_capture` | Erro no *script* de validação | Não |
| LSN mínimo temporariamente `NULL` | Estado transitório do CDC | Não |

Esses incidentes estabeleceram diversas regras de implementação para futuras automações do Atlas Engineering.

Primeiro, os *scripts* devem validar o estado operacional antes de emitir comandos dependentes de estado.

```text
Inspecionar
    ↓
Determinar o estado atual
    ↓
Executar a ação apropriada
    ↓
Validar o estado resultante
```

Segundo, um erro produzido por um comando de validação deve ser diagnosticado no nível do *script* e dos parâmetros antes de ser atribuído à plataforma subjacente.

```text
Comando falha
    ↓
Validar sintaxe e parâmetros do comando
    ↓
Inspecionar o estado real do subsistema
    ↓
Classificar a falha
```

Terceiro, componentes assíncronos não devem ser validados sob a premissa de convergência imediata do estado.

```text
Configuração Aceita ≠ Todos os Valores Dependentes de Execução Imediatamente Disponíveis
```

Quarto, a remediação deve atuar sobre a camada que efetivamente apresentou a falha.

Os incidentes observados exigiram:

```text
Condição de parada do cleanup
    → melhorar o tratamento do estado operacional

Erro de parâmetro da stored procedure
    → corrigir o script de validação

LSN mínimo transitório
    → considerar o estado assíncrono
```

Eles não exigiram:

```text
Ciclo de desabilitação/habilitação do CDC
Reconstrução do banco de dados
Recriação da instância de captura
Modificação dos dados da origem
```

Por fim, as evidências de implementação devem preservar falhas e correções, em vez de omiti-las da documentação final.

Um ciclo de engenharia bem-sucedido não é representado pela suposição de que todos os comandos foram executados com sucesso na primeira tentativa.

O registro relevante é:

```text
O que aconteceu
    ↓
Por que aconteceu
    ↓
Como foi classificado
    ↓
O que foi corrigido
    ↓
O que foi revalidado
    ↓
Qual conclusão é sustentada pelas evidências
```

Essa abordagem impede que defeitos de *script*, condições operacionais e estados transitórios sejam promovidos incorretamente a conclusões arquiteturais sobre o CDC do SQL Server.

Ela também fornece requisitos concretos para o futuro endurecimento dos *scripts* do CDC do M01 antes que sejam tratados como artefatos operacionais reutilizáveis.

---

## 25. Resumo das Evidências

O ciclo de laboratório do M01.08 ao M01.19 estabeleceu a base do CDC do SQL Server no lado da origem para o escopo transacional inicial de `AtlasCommerce.sales`.

Os experimentos avançaram desde a validação do ambiente e a habilitação do CDC até alterações controladas de dados em uma única tabela e entre tabelas.

Esta seção consolida o que as evidências da implementação sustentam, o que permanece não comprovado e onde deve ser mantida a fronteira entre as observações de laboratório e as futuras afirmações sobre produção.

### 25.1 Comportamentos Comprovados

O ciclo de implementação produziu evidências diretas dos seguintes comportamentos do CDC do SQL Server dentro do ambiente controlado de laboratório do Atlas Engineering.

#### Habilitação do CDC no Nível do Banco de Dados

O M01.09 demonstrou que o CDC pôde ser habilitado com sucesso para `AtlasCommerce`.

A implementação estabeleceu:

```text
Estado do CDC no Banco de Dados:
Desabilitado
    ↓
sys.sp_cdc_enable_db
    ↓
Habilitado
```

A operação no nível do banco de dados criou o *schema* do CDC e a infraestrutura de metadados de suporte sem colocar automaticamente as tabelas de origem sob captura.

Portanto, a habilitação do CDC no nível do banco de dados e a configuração da captura no nível da tabela foram confirmadas como etapas distintas da implementação.

#### Instâncias de Captura no Nível da Tabela

O CDC foi habilitado com sucesso para:

```text
sales.Transaction
sales.TransactionItem
```

com as instâncias de captura:

```text
sales_Transaction
sales_TransactionItem
```

Ambas as instâncias de captura foram configuradas com:

```text
supports_net_changes = 0
```

e expuseram suas funções correspondentes de consulta de todas as alterações.

A implementação estabeleceu, portanto, duas estruturas de captura do CDC configuradas independentemente para o escopo transacional inicial.

#### Ausência de Backfill Histórico Automático

Ambas as tabelas continham dados existentes na origem antes da habilitação do CDC.

Os *baselines* observados incluíam:

```text
sales.Transaction:
6.306 linhas

sales.TransactionItem:
13.769 linhas
```

Após a criação de suas respectivas instâncias de captura, as tabelas de alterações inicialmente continham:

```text
0 linhas capturadas
```

Portanto, a implementação demonstrou diretamente:

```text
Linhas existentes na origem ≠ Histórico do CDC gerado automaticamente
```

O laboratório demonstrou a captura pelo CDC das alterações elegíveis na origem ocorridas após o limite de captura configurado.

O estado existente na origem exige uma estratégia separada de *backfill* inicial.

#### Captura Assíncrona

As transações controladas demonstraram que alterações confirmadas na origem podem existir antes que os registros correspondentes do CDC se tornem disponíveis.

O padrão observado foi:

```text
COMMIT
    ↓
Estado da origem disponível
    ↓
Inspeção imediata do CDC pode não retornar nenhum registro
    ↓
Processamento da captura
    ↓
Registro do CDC disponível
```

Esse comportamento foi observado diretamente tanto nos experimentos em uma única tabela quanto nos experimentos entre tabelas.

#### Representação de INSERT

As inserções controladas foram representadas com:

```text
__$operation = 2
```

Os experimentos validaram inserções em:

```text
sales.Transaction
sales.TransactionItem
```

incluindo inserções que afetaram ambas as tabelas dentro de uma única transação SQL.

#### Representação de Antes e Depois do UPDATE

As operações controladas de `UPDATE` geraram:

```text
__$operation = 3
UPDATE_BEFORE

__$operation = 4
UPDATE_AFTER
```

As imagens correspondentes de antes e depois compartilharam os valores observados de:

```text
__$start_lsn
__$command_id
__$seqval
__$update_mask
```

enquanto diferiam em:

```text
__$operation
```

Esse comportamento foi validado tanto para operações individuais quanto para operações coordenadas de `UPDATE` entre tabelas.

#### Representação de DELETE

As exclusões físicas controladas foram representadas com:

```text
__$operation = 1
```

A implementação validou tanto:

```text
DELETE explícito na origem
```

quanto:

```text
DELETE causado por ON DELETE CASCADE
```

como alterações físicas capturadas.

#### Múltiplos Comandos em uma Única Transação

O M01.14 demonstrou que múltiplos comandos de `UPDATE` executados dentro de uma única transação SQL compartilharam um contexto comum de transação, permanecendo distinguíveis por meio dos metadados de comando.

O modelo foi posteriormente reproduzido durante os experimentos entre tabelas.

#### Correlação de Transações entre Tabelas

O M01.17B, o M01.18 e o M01.19 demonstraram que alterações capturadas por meio de instâncias de captura separadas podem compartilhar:

```text
__$start_lsn
```

quando se originam da mesma transação SQL.

Os experimentos abrangeram:

```text
INSERT entre tabelas

UPDATE entre tabelas

DELETE do pai com cascata nos filhos
```

Isso estabeleceu a correlação de transações no lado da origem entre as duas instâncias de captura transacionais.

#### Identificação e Sequenciamento de Comandos

Dentro das transações controladas com múltiplos comandos:

```text
__$command_id
```

distinguiu os comandos observados na origem.

Comandos diferentes também produziram valores observados distintos de:

```text
__$seqval
```

enquanto cada par controlado de `UPDATE_BEFORE` / `UPDATE_AFTER` compartilhou seu valor de sequência.

A implementação estabeleceu, portanto, o seguinte modelo prático de transação:

```text
__$start_lsn
    → contexto da transação

__$command_id
    → distinção dos comandos

__$seqval
    → metadado observado de sequenciamento das alterações

__$operation
    → semântica da imagem de linha

__$update_mask
    → metadado das colunas capturadas afetadas
```

#### Máscaras de Atualização

As operações controladas de `UPDATE` produziram máscaras correspondentes às colunas capturadas afetadas.

Entre os exemplos observados estavam:

```text
0x0108
0x0160
0x0168
0x0150
0x0120
```

As operações controladas de `INSERT` e `DELETE` nas instâncias de captura testadas produziram:

```text
0x01FF
```

A implementação validou, portanto, a inspeção prática dos metadados da máscara de atualização do CDC para os conjuntos configurados de nove colunas capturadas.

#### Captura da Cascata Referencial

O M01.19 demonstrou que um único `DELETE` explícito do pai poderia produzir:

```text
1 DELETE do pai
+
2 DELETE dos filhos
```

por meio de `ON DELETE CASCADE`.

O CDC capturou todas as três alterações físicas, preservando seu contexto comum de transação.

Isso estabeleceu:

```text
Número de Registros do CDC ≠ Número de Instruções Explícitas da Aplicação
```

#### Retenção de Cleanup Configurável

A retenção do *cleanup* foi alterada com sucesso de:

```text
4.320 minutos
```

para:

```text
21.600 minutos
```

ou:

```text
15 dias
```

A implementação confirmou que a retenção do CDC pode ser configurada independentemente do futuro objetivo de atualização dos dados da plataforma.

O valor de 15 dias é um *buffer* operacional de recuperação para o projeto V1, e não uma estratégia de armazenamento histórico permanente.

#### Restrição de Partition Switching Identificada

Ambas as tabelas transacionais foram avaliadas no contexto de seu projeto particionado na origem.

A implementação do CDC revelou a restrição de *partition switching* associada ao comportamento configurado do CDC.

A verificação do repositório não encontrou nenhum caminho normal de ingestão existente baseado em:

```text
ALTER TABLE ... SWITCH
```

A decisão resultante para a V1 foi controlar explicitamente o *partition switching*, em vez de tratar a restrição como uma falha de implementação.

Esse é um limite operacional identificado, e não evidência de que operações arbitrárias de *partition switching* tenham sido validadas com o CDC.

### 25.2 Comportamentos Ainda Não Comprovados

A conclusão do ciclo do CDC no lado da origem não significa que o *pipeline* completo de dados de alteração tenha sido implementado.

Os seguintes comportamentos permanecem fora das evidências estabelecidas até o M01.19.

#### Consumo Incremental do CDC

Um consumidor definitivo ainda não foi implementado.

O projeto ainda não comprovou:

```text
Como a próxima janela de LSN é selecionada

Como cada instância de captura é consultada incrementalmente

Quando uma janela é considerada processada com sucesso

Como o próximo checkpoint é calculado
```

Essas questões pertencem à próxima etapa da implementação.

#### Estratégia de Checkpoint

Nenhum mecanismo persistente definitivo de *checkpoint* foi validado até o momento.

O projeto ainda não comprovou:

```text
Armazenamento do checkpoint

Semântica de confirmação do checkpoint

Coordenação do checkpoint entre tabelas

Comportamento de reinicialização a partir de um checkpoint armazenado
```

Um projeto correto de *checkpoint* deve ser implementado e testado, em vez de inferido a partir dos experimentos do CDC no lado da origem.

#### Comportamento de Replay e Reinicialização

Embora a retenção de 15 dias do CDC forneça uma janela operacional de recuperação, a implementação ainda não demonstrou um ciclo de reinicialização ou *replay* do consumidor.

Permanecem não comprovados:

```text
Reinicialização do consumidor

Replay a partir de um checkpoint anterior

Tratamento de duplicidades durante o replay

Recuperação após falha parcial nas etapas subsequentes
```

#### Comportamento do Debezium

Nenhuma implementação do Debezium fez parte do M01.08 ao M01.19.

Portanto, o projeto ainda não demonstrou:

```text
Representação de transações no Debezium

Comportamento de ordenação no Debezium

Comportamento de reinicialização do conector

Tratamento de offset do conector

Como os metadados do CDC do SQL Server são propagados para as etapas subsequentes
```

A correlação de transações do CDC do SQL Server não deve ser apresentada como evidência do comportamento do Debezium.

#### Semântica de Entrega do Kafka

O Kafka não fez parte do ciclo validado no lado da origem.

Portanto, o projeto ainda não comprovou:

```text
Particionamento no Kafka

Ordenação entre tabelas no Kafka

Comportamento de entrega

Comportamento de grupos de consumidores

Recuperação de offset

Empacotamento transacional
```

Em particular:

```text
__$start_lsn compartilhado no SQL Server ≠ Entrega Indivisível Comprovada no Kafka
```

#### Persistência Bronze

A camada Bronze ainda não foi implementada como parte deste ciclo do CDC.

O projeto ainda não comprovou:

```text
Schema do CDC na Bronze

Persistência dos dados brutos do CDC

Preservação dos metadados

Particionamento dos dados do CDC

Durabilidade histórica além da retenção do CDC na origem
```

O papel arquitetural da Bronze pode já estar definido, mas seu comportamento em execução não constitui evidência proveniente do M01.08 ao M01.19.

#### Idempotência End-to-End

Os experimentos controlados na origem não estabelecem processamento idempotente *end-to-end*.

A implementação ainda não demonstrou:

```text
Gravações seguras para replay

Tratamento de eventos duplicados

Atomicidade entre checkpoint e gravação

Persistência idempotente nas etapas subsequentes
```

#### Recuperação de Falhas

Os erros operacionais encontrados durante a configuração e a inspeção do CDC foram diagnosticados com sucesso, mas não equivalem ao teste de um modelo completo de recuperação de falhas do *pipeline*.

O projeto ainda não validou cenários como:

```text
Indisponibilidade do consumidor

Backlog prolongado de captura

Indisponibilidade do armazenamento subsequente

Falha parcial de batch

Falha de checkpoint

Replay após recuperação das etapas subsequentes
```

#### Comportamento de Backlog e Catch-Up

O laboratório não gerou *backlog* do CDC em escala de produção.

Portanto, atualmente nenhuma evidência estabelece:

```text
Throughput de catch-up

Taxa de redução do backlog

Comportamento próximo aos limites de retenção

Taxa máxima sustentável de alterações na origem
```

#### Escala e Desempenho

Os testes controlados foram projetados para validar semântica, e não desempenho em escala de produção.

Eles não estabelecem:

```text
Throughput em produção

Sobrecarga de CPU

Sobrecarga de I/O

Impacto no log de transações sob carga sustentada

Desempenho de consultas em grandes janelas do CDC

Escalabilidade do consumidor
```

#### SLO de Atualização End-to-End

A arquitetura atualmente define objetivos de atualização, incluindo:

```text
Típico:
aproximadamente 3–5 minutos

Meta formal P95:
≤ 15 minutos
```

Esses são objetivos.

O M01.08 ao M01.19 não implementou nem mediu o caminho completo *end-to-end* necessário para validá-los.

Portanto:

```text
Objetivo de Atualização ≠ SLO Observado em Produção
```

### 25.3 Afirmações de Laboratório versus Produção

As evidências geradas até o M01.19 provêm de uma implementação controlada em laboratório.

A interpretação correta é:

```text
Observado em Laboratório
        ↓
Evidência Válida de Implementação
        ↓
Sustenta a Próxima Decisão de Engenharia
```

Isso não deve se transformar automaticamente em:

```text
Observado em Laboratório
        ↓
Comportamento Presumido em Produção
```

Por exemplo:

```text
Aproximadamente 6 segundos utilizados durante a validação em laboratório
```

não estabelece:

```text
Latência do CDC de 6 segundos em produção
```

Da mesma forma:

```text
__$start_lsn compartilhado entre instâncias de captura
```

não estabelece:

```text
Entrega atômica nas etapas subsequentes entre todos os futuros componentes
```

E:

```text
Retenção de 15 dias do CDC configurada com sucesso
```

não estabelece:

```text
15 dias de capacidade de recuperação garantida para a plataforma completa
```

A capacidade completa de recuperação também depende do futuro comportamento do consumidor, dos *checkpoints*, da persistência subsequente, dos procedimentos operacionais e do gerenciamento de retenção.

A fronteira das evidências pode, portanto, ser resumida como:

```text
COMPROVADO
│
├── Configuração do CDC no SQL Server na origem
├── Comportamento das instâncias de captura
├── Representação de INSERT
├── Representação de UPDATE antes/depois
├── Representação de DELETE
├── Correlação de transações entre tabelas
├── Alterações físicas geradas por cascata
├── Comportamento de captura assíncrona
├── Semântica dos metadados do CDC observada nos testes
├── Retenção de cleanup configurável
└── Requisito de backfill inicial

AINDA NÃO COMPROVADO
│
├── Consumo definitivo do CDC
├── Estratégia persistente de checkpoint
├── Reinicialização e replay do consumidor
├── Comportamento do Debezium
├── Comportamento do Kafka
├── Persistência Bronze
├── Idempotência end-to-end
├── Recuperação de falhas
├── Desempenho de backlog e catch-up
├── Desempenho em escala de produção
└── SLO de atualização end-to-end
```

A base do CDC no lado da origem está, portanto, suficientemente comprovada para prosseguir ao próximo problema de implementação sem superestimar o que o projeto já demonstrou.

A próxima etapa deve converter a semântica validada do CDC na origem em um modelo controlado de consumo incremental e gerar novas evidências para os comportamentos que permanecem não comprovados.

---

## 26. Status da Implementação

A implementação do CDC do SQL Server no lado da origem para o escopo transacional inicial de `AtlasCommerce.sales` concluiu seu ciclo de validação controlada até o M01.19.

A implementação avançou por:

```text
M01.08
Baseline Pré-CDC
        ↓
M01.09
Habilitação do CDC no Nível do Banco de Dados
        ↓
M01.10
Habilitação do CDC em sales.Transaction
        ↓
M01.10B
Configuração da Retenção do CDC
        ↓
M01.11
Anatomia da Tabela de Alterações
        ↓
M01.12
INSERT Controlado
        ↓
M01.13
UPDATE Controlado
        ↓
M01.14
Múltiplos Comandos de UPDATE
em uma Única Transação
        ↓
M01.15
DELETE Controlado
        ↓
M01.16
Habilitação do CDC em sales.TransactionItem
        ↓
M01.17A
Preparação do CDC entre Tabelas
        ↓
M01.17B
INSERT entre Tabelas
        ↓
M01.18
UPDATE Coordenado entre Tabelas
        ↓
M01.19
DELETE do Pai com
ON DELETE CASCADE
```

O estado final do ciclo validado no lado da origem é:

```text
Habilitação do CDC no banco de dados do SQL Server:
CONCLUÍDA

Instância de captura de sales.Transaction:
CONCLUÍDA

Instância de captura de sales.TransactionItem:
CONCLUÍDA

Configuração operacional do CDC:
CONCLUÍDA PARA O ESCOPO ATUAL DA ORIGEM NA V1

Validação de alterações em uma única tabela:
CONCLUÍDA

Validação de transações entre tabelas:
CONCLUÍDA

Validação de cascata referencial:
CONCLUÍDA

Investigação dos metadados do CDC no lado da origem:
CONCLUÍDA

Consolidação do modelo de transações do CDC:
CONCLUÍDA
```

A implementação estabeleceu evidências suficientes no lado da origem para avançar além da pergunta:

```text
O CDC do SQL Server pode representar as alterações transacionais necessárias na origem?
```

Para o escopo testado, a resposta é sustentada pelas evidências controladas de laboratório.

O projeto demonstrou:

```text
INSERT
UPDATE
DELETE
UPDATE_BEFORE / UPDATE_AFTER
Múltiplos comandos por transação
Correlação de transações entre tabelas
Captura de cascata referencial
Disponibilidade assíncrona do CDC
Correlação pelo LSN da transação
Identificação de comandos
Metadados de sequência
Máscaras de atualização
Retenção configurável
Ausência de backfill histórico automático
```

A fronteira atual da implementação é:

```text
                    CONCLUÍDO
                        │
                        ▼
┌─────────────────────────────────────────┐
│ Origem no SQL Server                   │
│                                        │
│ AtlasCommerce                          │
│                                        │
│ sales.Transaction                      │
│ sales.TransactionItem                  │
│                                        │
│ CDC do SQL Server                      │
│                                        │
│ Comportamento do CDC na origem         │
│ validado                               │
└─────────────────────────────────────────┘
                        │
                        │
                        ▼
              PRÓXIMA IMPLEMENTAÇÃO
                        │
                        ▼
┌─────────────────────────────────────────┐
│ Consumo do CDC                         │
│                                        │
│ Janelas de LSN                         │
│ Leituras incrementais                  │
│ Semântica de checkpoint                │
│ Reinicialização / replay               │
│ Considerações de consumo entre tabelas │
└─────────────────────────────────────────┘
```

Essa fronteira é intencional.

A implementação do CDC no lado da origem não deve ser estendida conceitualmente aos componentes subsequentes antes que esses componentes sejam implementados e testados.

Portanto, permanecem como trabalhos futuros de implementação:

```text
Consumidor definitivo do CDC
Checkpoint persistente
Reinicialização e replay
Idempotência nas etapas subsequentes
Integração com Debezium
Integração com Kafka
Persistência Bronze
Recuperação de falhas
Validação de backlog e catch-up
Desempenho em escala de produção
Medição de atualização end-to-end
```

O *status* deste documento também é distinto do *status* das evidências da implementação.

O ciclo de implementação até o M01.19 está concluído e validado.

O ciclo de documentação ainda deve concluir suas etapas editoriais, estruturais, de tradução e de validação restantes antes que o próprio documento possa ser considerado totalmente aprovado e publicado.

Portanto:

```text
Implementação M01.08–M01.19:
CONCLUÍDA

Validação do CDC no lado da origem:
APROVADA

Documento de implementação em inglês:
APROVADO

Documento de implementação PT-BR:
PENDENTE DO FLUXO FINAL DE DOCUMENTAÇÃO

Consumo do CDC:
NÃO INICIADO
```

Nenhum resultado de implementação do M01.20 está incluído no conjunto atual de evidências.

Isso preserva o *checkpoint* da implementação:

```text
M01.19
    ↓
Ciclo do CDC no lado da origem concluído
    ↓
Documentação concluída e validada
    ↓
M01.20
Consumo do CDC
```

O projeto pode prosseguir para o M01.20 somente após a conclusão do ciclo atual de documentação do CDC de acordo com as etapas de validação da documentação do Atlas Engineering.

---

## 27. Próxima Etapa — Consumo do CDC

A conclusão do M01.19 encerrou o ciclo controlado de comportamento do CDC no lado da origem para o escopo transacional inicial de `AtlasCommerce.sales`.

O próximo problema de engenharia não é mais determinar se o CDC do SQL Server consegue capturar as alterações necessárias na origem.

Esse comportamento foi validado.

O próximo problema é:

```text
Como o Atlas Engineering deve consumir essas alterações incrementalmente, com segurança e de forma repetível?
```

Isso marca a transição de:

```text
Produção do CDC
```

para:

```text
Consumo do CDC
```

A fronteira da implementação é:

```text
AtlasCommerce
      │
      ▼
Log de Transações
      │
      ▼
CDC do SQL Server
      │
      │
      │  validado até o M01.19
      ▼
Tabelas de Alterações do CDC
      │
      │
      │  próxima fronteira de engenharia
      ▼
Consumidor Incremental do CDC
```

A primeira etapa desse próximo ciclo é o M01.20.

### 27.1 M01.20 — Consumo do CDC

O M01.20 iniciará a investigação de como um consumidor pode recuperar alterações das instâncias de captura do CDC sem depender de premissas que não foram testadas durante o ciclo no lado da origem.

As instâncias de captura iniciais são:

```text
sales_Transaction
sales_TransactionItem
```

Suas funções de todas as alterações são:

```text
cdc.fn_cdc_get_all_changes_sales_Transaction

cdc.fn_cdc_get_all_changes_sales_TransactionItem
```

A investigação do consumo deve preservar a semântica de transações estabelecida até o M01.19 enquanto introduz um limite confiável de leitura incremental.

Conceitualmente:

```text
Posição anterior de processamento
        │
        ▼
Determinar a janela de LSN do CDC
        │
        ▼
Ler alterações elegíveis
        │
        ▼
Interpretar os metadados do CDC
        │
        ▼
Processar com sucesso
        │
        ▼
Avançar a posição de processamento
```

Cada etapa exige evidências de implementação separadas.

### 27.2 M01.20A — Inspeção da Janela de LSN

O primeiro experimento será:

```text
M01.20A — Inspeção da Janela de LSN
```

Seu objetivo é inspecionar os limites de consulta do CDC antes de projetar o consumidor definitivo.

A investigação utilizará:

```sql
sys.fn_cdc_get_min_lsn(...)
```

e:

```sql
sys.fn_cdc_get_max_lsn()
```

em conjunto com as funções de todas as alterações para ambas as instâncias de captura.

O modelo básico de inspeção é:

```text
Instância de Captura
      │
      ├── LSN mínimo disponível
      │
      └── LSN máximo disponível
                │
                ▼
          Janela Consultável
```

O experimento deve determinar o que pode efetivamente ser consultado a partir do estado atual do CDC antes de introduzir uma semântica persistente de *checkpoint*.

### 27.3 Funções de Consulta de Todas as Alterações

Os primeiros testes de consumo utilizarão:

```sql
cdc.fn_cdc_get_all_changes_sales_Transaction
```

e:

```sql
cdc.fn_cdc_get_all_changes_sales_TransactionItem
```

O objetivo é inspecionar como os registros validados das tabelas de alterações são expostos por meio da interface de consulta suportada pelo CDC.

Isso é intencionalmente diferente de tratar as tabelas físicas de alterações como o contrato definitivo do consumidor.

A investigação começará com as funções do CDC fornecidas para as instâncias de captura configuradas.

Conceitualmente:

```text
Tabela de Alterações do CDC
        │
        ▼
Função de Todas as Alterações do CDC
        │
        ▼
Janela de LSN Definida
        │
        ▼
Conjunto de Resultados do Consumidor
```

O comportamento deve ser observado antes que um padrão permanente de consumo seja selecionado.

### 27.4 Opções de Filtro de Linhas

A investigação inicial comparará:

```text
'all'
```

com:

```text
'all update old'
```

ao consultar as funções de todas as alterações.

Essa comparação é importante porque os experimentos no lado da origem estabeleceram que as operações de `UPDATE` possuem uma semântica significativa de antes e depois.

A investigação do consumidor deve determinar como essa semântica é exposta pela função de consulta suportada sob cada opção.

Conceitualmente:

```text
Consulta do CDC
│
├── 'all'
│
│   └── comportamento a ser inspecionado
│
└── 'all update old'
    └── comportamento a ser inspecionado
```

Nenhum resultado é presumido antecipadamente.

Os registros efetivamente retornados se tornarão as evidências para o modelo de consumo.

### 27.5 Questões de Checkpoint

O M01.20A inspecionará as janelas de LSN, mas não estabelecerá automaticamente a arquitetura definitiva de *checkpoint*.

O próximo ciclo de implementação deve responder a questões como:

```text
Qual LSN representa o processamento concluído?

Quando essa posição pode avançar com segurança?

O checkpoint é compartilhado entre as instâncias de captura ou mantido independentemente?

O que acontece se o processamento for concluído com sucesso para uma instância de captura e falhar para outra?

Como a reinicialização é realizada?

Como o replay é solicitado?

Como as duplicidades são tratadas após o replay?

O que acontece se o checkpoint armazenado ficar fora da retenção do CDC?
```

Essas questões não podem ser respondidas apenas com as evidências do M01.08 ao M01.19.

Elas exigem experimentos controlados com o consumidor.

### 27.6 O Contexto da Transação Deve Ser Preservado

Os experimentos no lado da origem demonstraram que alterações de uma única transação SQL podem aparecer em múltiplas instâncias de captura enquanto compartilham:

```text
__$start_lsn
```

O futuro projeto de consumo deve, portanto, evitar descartar prematuramente o contexto da transação.

Por exemplo:

```text
sales.Transaction
        │
        │ start_lsn = X
        ▼
Alteração do Pai

sales.TransactionItem
        │
        │ start_lsn = X
        ▼
Alteração do Filho
```

O consumidor deve reconhecer que:

```text
Instâncias de captura separadas ≠ Transações de origem necessariamente não relacionadas
```

Ao mesmo tempo, as evidências atuais não estabelecem que todas as futuras etapas de processamento devam fornecer entrega atômica indivisível entre tabelas.

Esse comportamento arquitetural deve ser projetado e validado separadamente.

### 27.7 Limite de Retenção

A retenção configurada do *cleanup* do CDC é:

```text
21.600 minutos
=
15 dias
```

Isso introduz um limite operacional para o consumo futuro.

Conceitualmente:

```text
Intervalo Atual do CDC
│
├── LSN mínimo disponível
│
│
├── alterações válidas retidas
│
│
└── LSN máximo atual
```

Um futuro *checkpoint* que fique atrás do limite retido pelo CDC cria uma condição de recuperação que não pode ser resolvida simplesmente solicitando alterações que o CDC do SQL Server já removeu.

Portanto, o projeto do consumidor deve, futuramente, considerar:

```text
Checkpoint
    +
LSN mínimo disponível do CDC
    +
Janela de retenção
    +
Estratégia de recuperação
```

A retenção de 15 dias fornece um *buffer* operacional.

Ela não substitui a persistência durável nas etapas subsequentes nem uma estratégia de recuperação testada.

### 27.8 Evidências Necessárias Antes da Conclusão

A etapa de consumo do CDC deve produzir evidências suficientes antes que possa ser considerada concluída.

No mínimo, os experimentos subsequentes devem validar:

```text
Construção da janela de LSN

Recuperação incremental de alterações

Comportamento dos limites

Avanço do checkpoint

Reinicialização a partir do checkpoint

Comportamento de replay

Tratamento de duplicidades

Tratamento do limite de retenção

Comportamento do consumo entre tabelas
```

Etapas posteriores da implementação poderão estender essas evidências para incluir:

```text
Debezium

Kafka

Persistência Bronze

Idempotência end-to-end

Recuperação de falhas

Backlog e catch-up

Medição de atualização dos dados
```

Essas etapas devem permanecer separadas das evidências no lado da origem já estabelecidas.

### 27.9 Ponto Atual da Engenharia

Atualmente, o projeto está interrompido na seguinte fronteira:

```text
M01.08–M01.19
Base do CDC do SQL Server na Origem
        │
        ▼
CONCLUÍDA E VALIDADA
        │
        ▼
Documentação da Implementação do CDC
        │
        ▼
TRABALHO ATUAL
        │
        ▼
M01.20A
Inspeção da Janela de LSN
        │
        ▼
AINDA NÃO INICIADO
```

Este documento não afirma nenhum resultado do M01.20.

O próximo ciclo de laboratório começa somente após a documentação atual do CDC concluir o fluxo necessário de validação e publicação.

O primeiro objetivo técnico após esse ponto é:

```text
Inspecionar a janela válida de LSN do CDC
        ↓
Consultar ambas as instâncias de captura
        ↓
Comparar 'all' e 'all update old'
        ↓
Observar o comportamento real
        ↓
Usar as evidências para projetar o modelo de consumo incremental
```

Isso preserva a disciplina de implementação do Atlas Engineering:

```text
Compreender
    ↓
Implementar
    ↓
Observar
    ↓
Validar
    ↓
Documentar
    ↓
Somente então avançar
```

A base do CDC do SQL Server na origem está concluída.

A próxima fase começa com o consumo controlado do CDC.