# Atlas Engineering — Arquitetura de Engenharia de Dados

## Índice

- [1. Propósito](#1-propósito)

- [2. Contexto Arquitetural](#2-contexto-arquitetural)

- [3. Princípios da Arquitetura](#3-princípios-da-arquitetura)

  - [3.1 Arquitetura Desacoplada](#31-arquitetura-desacoplada)
  - [3.2 Processamento Incremental e Orientado a Eventos](#32-processamento-incremental-e-orientado-a-eventos)
  - [3.3 Histórico Bruto Imutável](#33-histórico-bruto-imutável)
  - [3.4 Processamento Idempotente](#34-processamento-idempotente)
  - [3.5 Capacidade de *Replay* e Recuperabilidade](#35-capacidade-de-replay-e-recuperabilidade)
  - [3.6 Contratos de Dados Explícitos e Evolução de *Schema*](#36-contratos-de-dados-explícitos-e-evolução-de-schema)
  - [3.7 Qualidade Antes da Certificação](#37-qualidade-antes-da-certificação)
  - [3.8 Observabilidade por Projeto](#38-observabilidade-por-projeto)
  - [3.9 Segurança por Projeto](#39-segurança-por-projeto)
  - [3.10 Metadados e Linhagem como Ativos Arquiteturais](#310-metadados-e-linhagem-como-ativos-arquiteturais)
  - [3.11 Validação Baseada em Evidências](#311-validação-baseada-em-evidências)
  - [3.12 As Restrições do Laboratório Não Devem Definir a Arquitetura](#312-as-restrições-do-laboratório-não-devem-definir-a-arquitetura)

- [4. Escopo](#4-escopo)
  - [4.1 Escopo Arquitetural](#41-escopo-arquitetural)
  - [4.2 Escopo da Implementação Inicial](#42-escopo-da-implementação-inicial)
  - [4.3 Expansão Incremental](#43-expansão-incremental)
  - [4.4 Limites de Escopo](#44-limites-de-escopo)

- [5. Perfil de Carga de Trabalho](#5-perfil-de-carga-de-trabalho)
  - [5.1 Volume Inicial de Dados](#51-volume-inicial-de-dados)
  - [5.2 Volume Diário de Alterações](#52-volume-diário-de-alterações)
  - [5.3 Carga de Pico](#53-carga-de-pico)
  - [5.4 Crescimento e Retenção](#54-crescimento-e-retenção)
  - [5.5 Recalibração da Linha de Base](#55-recalibração-da-linha-de-base)

- [6. Objetivo de Nível de Serviço](#6-objetivo-de-nível-de-serviço)
  - [6.1 Objetivo de Atualização de Ponta a Ponta](#61-objetivo-de-atualização-de-ponta-a-ponta)
  - [6.2 Medição Baseada em Percentis](#62-medição-baseada-em-percentis)
  - [6.3 Decomposição da Latência](#63-decomposição-da-latência)
  - [6.4 SLO e *Backlog*](#64-slo-e-backlog)
  - [6.5 Detecção de Ausência de Eventos](#65-detecção-de-ausência-de-eventos)
  - [6.6 Objetivo Inicial e Recalibração](#66-objetivo-inicial-e-recalibração)

- [7. Arquitetura de Alto Nível](#7-arquitetura-de-alto-nível)
  - [7.1 Origem Operacional](#71-origem-operacional)
  - [7.2 Change Data Capture](#72-change-data-capture)
  - [7.3 Governança de Schema](#73-governança-de-schema)
  - [7.4 Transmissão de Eventos](#74-transmissão-de-eventos)
  - [7.5 Processamento de Dados](#75-processamento-de-dados)
  - [7.6 Armazenamento Bronze](#76-armazenamento-bronze)
  - [7.7 Armazenamento Silver](#77-armazenamento-silver)
  - [7.8 Camada de Disponibilização Gold](#78-camada-de-disponibilização-gold)
  - [7.9 Certified Gold](#79-certified-gold)
  - [7.10 Consumo Analítico](#710-consumo-analítico)
  - [7.11 Orquestração](#711-orquestração)
  - [7.12 Observabilidade](#712-observabilidade)

- [8. Fluxo de Dados](#8-fluxo-de-dados)
  - [8.1 Confirmação da Transação na Origem](#81-confirmação-da-transação-na-origem)
  - [8.2 Captura pelo CDC](#82-captura-pelo-cdc)
  - [8.3 Criação de Eventos](#83-criação-de-eventos)
  - [8.4 Governança e Compatibilidade de Schema](#84-governança-e-compatibilidade-de-schema)
  - [8.5 Transporte Kafka](#85-transporte-kafka)
  - [8.6 Persistência na Bronze](#86-persistência-na-bronze)
  - [8.7 Transformação na Silver](#87-transformação-na-silver)
  - [8.8 Transformação na Gold](#88-transformação-na-gold)
  - [8.9 Validação de Qualidade e Reconciliação](#89-validação-de-qualidade-e-reconciliação)
  - [8.10 Publicação na Certified Gold](#810-publicação-na-certified-gold)
  - [8.11 Consumo Analítico](#811-consumo-analítico)
  - [8.12 Rastreabilidade de Ponta a Ponta](#812-rastreabilidade-de-ponta-a-ponta)

- [9. Camadas de Dados](#9-camadas-de-dados)
  - [9.1 Source — AtlasCommerce](#91-source-atlascommerce)
  - [9.2 Bronze](#92-bronze)
  - [9.3 Silver](#93-silver)
  - [9.4 Gold](#94-gold)
  - [9.5 Certified Gold](#95-certified-gold)
  - [9.6 Consumo Analítico](#96-consumo-analítico)
  - [9.7 Progressão das Camadas](#97-progressão-das-camadas)

- [10. Capacidades Transversais](#10-capacidades-transversais)
  - [10.1 Orquestração](#101-orquestração)
  - [10.2 Observabilidade](#102-observabilidade)
  - [10.3 Segurança](#103-segurança)
  - [10.4 Governança e Metadados](#104-governança-e-metadados)
  - [10.5 Versionamento](#105-versionamento)

- [11. Produto de Dados Inicial](#11-produto-de-dados-inicial)
  - [11.1 Propósito de Negócio](#111-propósito-de-negócio)
  - [11.2 Caminho de Validação de Ponta a Ponta](#112-caminho-de-validação-de-ponta-a-ponta)
  - [11.3 Certificação](#113-certificação)
  - [11.4 Publicação](#114-publicação)
  - [11.5 Consumo](#115-consumo)
  - [11.6 Propriedade e Metadados do Produto](#116-propriedade-e-metadados-do-produto)
  - [11.7 Evidências](#117-evidências)
  - [11.8 Papel na Evolução da Plataforma](#118-papel-na-evolução-da-plataforma)

- [12. Estratégia de Incorporação Incremental de Domínios](#12-estratégia-de-incorporação-incremental-de-domínios)
  - [12.1 Validação do Primeiro Domínio](#121-validação-do-primeiro-domínio)
  - [12.2 Incorporação de Domínios](#122-incorporação-de-domínios)
  - [12.3 Reutilização Antes da Duplicação](#123-reutilização-antes-da-duplicação)
  - [12.4 Dimensões Conformadas](#124-dimensões-conformadas)
  - [12.5 Variação Específica do Domínio](#125-variação-específica-do-domínio)
  - [12.6 Validação Independente](#126-validação-independente)
  - [12.7 Evolução da Documentação](#127-evolução-da-documentação)

- [13. Arquitetura de Laboratório e Corporativa](#13-arquitetura-de-laboratório-e-corporativa)
  - [13.1 Propósito do Laboratório](#131-propósito-do-laboratório)
  - [13.2 Restrições Físicas do Laboratório](#132-restrições-físicas-do-laboratório)
  - [13.3 Separação Lógica](#133-separação-lógica)
  - [13.4 Evolução Corporativa](#134-evolução-corporativa)
  - [13.5 Escalabilidade](#135-escalabilidade)
  - [13.6 Alta Disponibilidade e Resiliência](#136-alta-disponibilidade-e-resiliência)
  - [13.7 Evolução da Segurança](#137-evolução-da-segurança)
  - [13.8 Das Evidências do Laboratório às Decisões Corporativas](#138-das-evidências-do-laboratório-às-decisões-corporativas)
  - [13.9 Responsabilidades Corporativas Típicas](#139-responsabilidades-corporativas-típicas)

- [14. Evolução da Arquitetura](#14-evolução-da-arquitetura)
  - [14.1 Fatores para Mudança Arquitetural](#141-fatores-para-mudança-arquitetural)
  - [14.2 Evolução Baseada em Evidências](#142-evolução-baseada-em-evidências)
  - [14.3 Mudança Controlada](#143-mudança-controlada)
  - [14.4 Architecture Decision Records](#144-architecture-decision-records)
  - [14.5 Evolução Tecnológica](#145-evolução-tecnológica)
  - [14.6 Compatibilidade Retroativa e Migração](#146-compatibilidade-retroativa-e-migração)
  - [14.7 Documentação como Parte da Arquitetura](#147-documentação-como-parte-da-arquitetura)
  - [14.8 Linha de Base da Versão 1](#148-linha-de-base-da-versão-1)

- [15. Documentação Relacionada](#15-documentação-relacionada)
  - [15.1 Documentação de Arquitetura](#151-documentação-de-arquitetura)
  - [15.2 Decisões de Arquitetura](#152-decisões-de-arquitetura)
  - [15.3 Padrões](#153-padrões)
  - [15.4 Documentação de Negócio](#154-documentação-de-negócio)
  - [15.5 Testes e Evidências](#155-testes-e-evidências)
  - [15.6 FAQ de Arquitetura](#156-faq-de-arquitetura)
  - [15.7 Consistência da Documentação](#157-consistência-da-documentação)

---

## 1. Propósito

O propósito deste documento é fornecer a visão arquitetural de alto nível da **camada de Engenharia de Dados** dentro da **Atlas Engineering — Enterprise Data Platform**.

Esta arquitetura define como os dados operacionais produzidos pelo **AtlasCommerce** são capturados, transportados, persistidos, transformados, validados, publicados e disponibilizados para consumo analítico.

O documento estabelece o contexto arquitetural, o escopo, os princípios, os principais componentes, as camadas de dados e o fluxo de ponta a ponta da plataforma. Também identifica as capacidades transversais necessárias para operar a arquitetura, incluindo orquestração, observabilidade, segurança, governança, gerenciamento de metadados e versionamento.

Procedimentos detalhados de implementação, configurações específicas de tecnologia, *runbooks* operacionais e evidências de execução de testes estão intencionalmente fora do escopo desta visão geral e são documentados separadamente.

A arquitetura descrita aqui representa a arquitetura-alvo da **Versão 1 (V1)**. Ela foi projetada para ser implementável no ambiente de laboratório atual, preservando ao mesmo tempo os limites arquiteturais que permitem que componentes individuais evoluam para alternativas de nível produtivo ou serviços gerenciados sem exigir o redesenho de toda a plataforma.

--- 

## 2. Contexto Arquitetural

**AtlasCommerce** é o sistema de origem operacional da **Atlas Engineering — Enterprise Data Platform**. Ele é implementado como um banco de dados transacional SQL Server e representa o sistema de registro oficial (*system of record*) para os domínios de negócio inicialmente integrados à plataforma analítica.

A arquitetura de Engenharia de Dados começa no limite entre a carga de trabalho operacional e a plataforma de dados analíticos. Sua responsabilidade é capturar as alterações confirmadas na origem, transportá-las de forma confiável por meio de um pipeline orientado a eventos, preservar seu histórico, transformá-las progressivamente em estruturas analíticas governadas e publicar produtos de dados adequados ao consumo.

A arquitetura segue o seguinte fluxo lógico:

**AtlasCommerce → Change Data Capture → Event Streaming → Bronze → Silver → Gold → Certified Gold → Analytical Consumption**

Cada estágio possui uma responsabilidade distinta. A origem operacional permanece responsável pelo processamento transacional, enquanto as camadas posteriores introduzem progressivamente preservação histórica, padronização, transformação de negócio, modelagem dimensional, validação de qualidade, certificação e consumo analítico.

A implementação inicial concentra-se no domínio **Sales** e em um primeiro produto analítico certificado, **Daily Sales**, permitindo que a arquitetura seja validada de ponta a ponta antes que domínios adicionais sejam incorporados de forma incremental.

Esse escopo representa a primeira etapa de implementação da plataforma, e não sua cobertura analítica final. À medida que domínios de negócio adicionais forem implementados e validados, este documento deverá ser atualizado para refletir a arquitetura, os fluxos de dados, as dependências e os produtos analíticos certificados ampliados.

A arquitetura é projetada em torno de limites explícitos entre captura da origem, transporte, armazenamento, transformação, disponibilização, orquestração, observabilidade, segurança e governança. Esses limites permitem que componentes individuais evoluam de forma independente, preservando as responsabilidades e os contratos da plataforma como um todo.

---

## 3. Princípios da Arquitetura

A arquitetura de Engenharia de Dados é orientada por um conjunto de princípios que definem como os dados são capturados, processados, armazenados, publicados, operados e evoluídos em toda a plataforma.

### 3.1 Arquitetura Desacoplada

A plataforma separa a captura da origem, o transporte de eventos, o armazenamento, a transformação, a disponibilização, a orquestração, a observabilidade e a governança em responsabilidades arquiteturais explícitas.

Os componentes podem evoluir ou ser substituídos de forma independente, desde que seus contratos e responsabilidades sejam preservados.

### 3.2 Processamento Incremental e Orientado a Eventos

As alterações operacionais são propagadas de forma incremental pela plataforma, em vez de depender de extrações completas e repetidas dos dados de origem.

A arquitetura utiliza eventos de alteração para reduzir leituras desnecessárias na origem, permitir a propagação quase em tempo real e preservar a sequência e o contexto necessários para o processamento posterior.

### 3.3 Histórico Bruto Imutável

A camada Bronze preserva o histórico bruto recebido do fluxo de eventos em armazenamento somente para adição (*append-only*).

Os dados brutos históricos não são atualizados nem excluídos como parte do processamento normal. Correções e reprocessamentos geram novos resultados de processamento sem reescrever o histórico originalmente capturado.

### 3.4 Processamento Idempotente

O processamento de dados deve tolerar novas tentativas, entregas duplicadas, reinicializações e *replay* sem produzir efeitos de negócio duplicados.

A idempotência é tratada como um requisito arquitetural em toda a ingestão, transformação e publicação, e não como um detalhe de implementação de um único componente.

### 3.5 Capacidade de *Replay* e Recuperabilidade

A plataforma deve preservar dados e metadados suficientes para permitir que as camadas posteriores sejam reconstruídas quando necessário.

As estratégias de recuperação distinguem entre *replay* do transporte, reprocessamento baseado na Bronze, reconstrução analítica, restauração de *backup* e recuperação de desastre, de acordo com o cenário de falha e a retenção disponível.

### 3.6 Contratos de Dados Explícitos e Evolução de *Schema*

Os dados trocados entre os estágios arquiteturais devem seguir contratos explícitos.

As alterações de *schema* são classificadas de acordo com compatibilidade e risco. Alterações compatíveis podem seguir uma evolução controlada, enquanto alterações incompatíveis ou destrutivas exigem procedimentos de migração explícitos e nunca devem ser propagadas silenciosamente.

### 3.7 Qualidade Antes da Certificação

Os dados não são considerados certificados simplesmente porque o processamento foi concluído com sucesso.

As regras de qualidade, os controles de reconciliação, as expectativas de atualização e os critérios de publicação devem ser atendidos antes que os dados analíticos sejam expostos por meio da camada Certified Gold.

### 3.8 Observabilidade por Projeto

A observabilidade faz parte da arquitetura, e não é um recurso operacional adicionado após a implementação.

A plataforma deve fornecer métricas, *logs*, *timestamps*, identificadores e informações de integridade suficientes para determinar se os dados estão fluindo, onde estão ocorrendo atrasos ou falhas e se os objetivos de nível de serviço estão sendo atendidos.

### 3.9 Segurança por Projeto

Os controles de segurança são aplicados durante todo o ciclo de vida dos dados.

A arquitetura segue os princípios de acesso com menor privilégio, identidades separadas por serviço ou função, gerenciamento controlado de segredos, criptografia quando apropriado e minimização de dados pessoais ou sensíveis.

### 3.10 Metadados e Linhagem como Ativos Arquiteturais

Os metadados técnicos e de negócio são tratados como parte da própria plataforma.

Os conjuntos de dados devem possuir identificação de propriedade, informações de *schema*, estado do ciclo de vida e linhagem suficientes para explicar sua origem, transformações, dependências e uso pretendido.

### 3.11 Validação Baseada em Evidências

Os requisitos arquiteturais devem ser verificáveis por meio de implementação, testes, observabilidade e evidências preservadas.

Uma decisão de projeto não é considerada operacionalmente demonstrada apenas porque está documentada; comportamentos críticos, como recuperação, *replay*, idempotência, aplicação de regras de qualidade e tratamento de falhas, devem ser validados por meio de testes controlados.

### 3.12 As Restrições do Laboratório Não Devem Definir a Arquitetura

A plataforma inicial é implementada em um ambiente de laboratório com recursos limitados, mas essas limitações físicas não devem se tornar premissas arquiteturais.

Os limites lógicos são preservados para que componentes individuais possam posteriormente evoluir para infraestrutura dedicada, implantações em *cluster* ou serviços gerenciados sem exigir um redesenho das responsabilidades fundamentais da plataforma.

---

## 4. Escopo

A arquitetura da Versão 1 define a fundação inicial de Engenharia de Dados de ponta a ponta da **Atlas Engineering — Enterprise Data Platform**, desde o limite da origem operacional até o consumo analítico certificado.

Seu escopo inclui as capacidades arquiteturais necessárias para capturar alterações operacionais, transportar eventos, preservar o histórico bruto, transformar e padronizar dados, construir estruturas analíticas dimensionais, validar a qualidade dos dados, certificar resultados analíticos, orquestrar o processamento, observar a integridade da plataforma, proteger os dados, gerenciar metadados e oferecer suporte à recuperação e ao reprocessamento controlados.

### 4.1 Escopo Arquitetural

A arquitetura V1 abrange as seguintes capacidades principais:

- captura de alterações operacionais do **AtlasCommerce**;
- transporte orientado a eventos e armazenamento temporário (buffering);
- contratos de *schema* e evolução controlada de *schema*;
- armazenamento histórico bruto imutável na camada **Bronze**;
- dados analíticos padronizados e reutilizáveis na camada **Silver**;
- modelagem analítica dimensional na camada **Gold**;
- publicação controlada por critérios de qualidade através da **Certified Gold**;
- consumo analítico através do **Power BI**;
- orquestração de processamento agendado e baseado em dependências;
- observabilidade de ponta a ponta, incluindo métricas, *logs*, latência, *backlog* e monitoramento de nível de serviço;
- segurança, separação de identidades, gerenciamento de segredos e minimização de dados;
- gerenciamento de metadados, propriedade, estado do ciclo de vida e linhagem;
- idempotência, *replay*, *backfill*, reconciliação e recuperação controlada;
- testes e geração de evidências para comportamentos arquiteturais críticos.

### 4.2 Escopo da Implementação Inicial

O primeiro ciclo de implementação utiliza o domínio **Sales** como a primeira fatia de negócio por meio da qual a arquitetura será construída, integrada, testada, observada e validada de ponta a ponta.

O primeiro produto analítico certificado é o **Daily Sales**, fornecendo um caminho controlado desde as transações operacionais no AtlasCommerce até o consumo analítico certificado.

Esse domínio inicial é intencionalmente limitado. Seu propósito é validar o padrão arquitetural antes de expandir as mesmas capacidades da plataforma para domínios de negócio adicionais.

### 4.3 Expansão Incremental

Domínios adicionais são incorporados de forma incremental após a validação do primeiro fluxo de ponta a ponta.

Cada novo domínio deve seguir os mesmos princípios arquiteturais, ao mesmo tempo em que define seus próprios objetos de origem, contratos de eventos, transformações, regras de qualidade, estruturas dimensionais, propriedade, linhagem, critérios de reconciliação e produtos analíticos certificados.

A arquitetura e sua documentação devem evoluir à medida que esses domínios forem implementados e validados. Domínios planejados ou conceituais não devem ser representados como capacidades implementadas antes que existam evidências que os sustentem.

### 4.4 Limites de Escopo

A arquitetura V1 estabelece os limites e as responsabilidades da plataforma, mas não implica que todas as capacidades de nível corporativo estejam implementadas em sua forma final de produção durante a etapa de laboratório.

Os itens a seguir estão fora do escopo da implementação inicial ou são tratados como evolução futura:

- dimensionamento de infraestrutura em escala de produção e planejamento de capacidade;
- implantação em múltiplos nós com alta disponibilidade de cada componente da plataforma;
- substituições por serviços de nuvem gerenciados para serviços hospedados no laboratório;
- adoção completa do OpenTelemetry e rastreamento distribuído;
- coleta automatizada de linhagem em toda a plataforma;
- federação de identidades corporativas e integração com IAM corporativo centralizado;
- recuperação de desastre em múltiplas regiões;
- validação de desempenho e estresse em larga escala representativa de uma carga de trabalho de produção;
- implementação simultânea de todos os domínios de negócio do AtlasCommerce.

Esses limites não eliminam as respectivas preocupações arquiteturais. O projeto V1 preserva a separação lógica e os contratos necessários para que essas capacidades sejam introduzidas posteriormente sem redefinir a arquitetura fundamental.

---

## 5. Perfil de Carga de Trabalho

O perfil de carga de trabalho inicial fornece uma referência mensurável para a implementação, os testes e a observação da arquitetura da Versão 1.

Esses valores representam as condições iniciais esperadas do laboratório e são utilizados como premissas de referência para estimativa de capacidade, planejamento de retenção, testes de desempenho, simulação de *backlog* e validação de nível de serviço. Eles não representam limites de capacidade arquitetural.

### 5.1 Volume Inicial de Dados

Espera-se que o conjunto de dados operacionais inicial seja de aproximadamente **10 GB**.

Esse volume fornece o ponto de partida para o primeiro ciclo de implementação e permite a validação inicial dos processos de ingestão, armazenamento, transformação, modelagem analítica, reconciliação e recuperação.

### 5.2 Volume Diário de Alterações

O volume inicial esperado de alterações é de aproximadamente **250 MB por dia**.

Esse valor representa o volume diário de referência das alterações operacionais propagadas pelo pipeline de Engenharia de Dados e é utilizado para estimar o comportamento da ingestão, o crescimento do armazenamento, os requisitos de retenção e a demanda de processamento.

### 5.3 Carga de Pico

A arquitetura deve ser inicialmente validada contra picos de carga de aproximadamente **3× a linha de base normal**.

A validação de pico tem como objetivo verificar se aumentos temporários na geração de eventos não comprometem imediatamente a ingestão, o processamento, a recuperação de *backlog* ou a atualização dos dados analíticos.

O fator de pico é uma meta de validação de laboratório, e não um limite permanente de escalabilidade.

### 5.4 Crescimento e Retenção

O planejamento de capacidade deve considerar não apenas o volume diário atual, mas também o efeito acumulado da retenção histórica, dos requisitos de *replay*, do crescimento analítico, dos metadados, dos *logs*, dos *backups* e da margem operacional.

As políticas de retenção variam de acordo com a responsabilidade de cada componente da plataforma. A retenção do transporte, o armazenamento histórico imutável, a retenção analítica e a retenção de *backups* devem, portanto, ser planejadas de forma independente, em vez de serem tratadas como um único valor para toda a plataforma.

### 5.5 Recalibração da Linha de Base

As premissas iniciais de carga de trabalho devem ser substituídas ou recalibradas à medida que a implementação produzir evidências mensuráveis.

As taxas de eventos observadas, os tamanhos dos eventos, as taxas de compressão, a duração do processamento, o crescimento do armazenamento, o comportamento do *backlog*, os percentis de latência e o desempenho da recuperação devem progressivamente se tornar a base para as decisões de capacidade e desempenho.

A arquitetura deve, portanto, distinguir entre **linha de base assumida**, **linha de base medida** e **capacidade validada**.

Um teste de laboratório bem-sucedido demonstra o comportamento nas condições testadas; ele não deve ser interpretado como prova de escalabilidade ilimitada ou de capacidade de produção.

---

## 6. Objetivo de Nível de Serviço

A arquitetura da Versão 1 estabelece um Objetivo de Nível de Serviço (*Service Level Objective — SLO*) inicial para a atualização dos dados analíticos.

O objetivo é fornecer uma expectativa mensurável sobre a rapidez com que as alterações operacionais confirmadas se tornam disponíveis na camada analítica de disponibilização e criar uma linha de base que possa ser validada, monitorada e recalibrada à medida que a plataforma evolui.

### 6.1 Objetivo de Atualização de Ponta a Ponta

O objetivo inicial de atualização de ponta a ponta é:

**P95 ≤ 15 minutos**

Em condições normais de operação, a plataforma tem inicialmente como meta disponibilizar os dados analíticos em aproximadamente **3–5 minutos**. Isso representa uma faixa operacional esperada, e não o limite formal de nível de serviço.

O SLO da V1 exige que, nas condições de carga de trabalho para as quais a plataforma foi validada, pelo menos 95% das alterações operacionais medidas se tornem disponíveis como dados analíticos certificados em até 15 minutos após o momento em que foram confirmadas na origem.

A principal medição é:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

onde:

- `source_commit_ts` representa o *timestamp* associado à alteração confirmada na origem operacional;
- `certified_gold_publish_ts` representa o *timestamp* no qual os dados analíticos correspondentes concluíram com sucesso os controles de certificação necessários e se tornaram disponíveis por meio da Certified Gold para consumo analítico governado.

### 6.2 Medição Baseada em Percentis

O SLO é definido utilizando o percentil 95, em vez de considerar apenas a latência média.

A latência média pode ocultar eventos lentos atrás de uma grande quantidade de eventos rápidos. A medição P95 fornece visibilidade sobre a experiência da parcela mais lenta da carga de trabalho processada, permanecendo adequada como um objetivo operacional inicial.

Percentis adicionais, incluindo **P50** e **P99**, também devem ser observados para fornecer uma visão mais ampla da distribuição da latência e identificar degradações que podem não ser visíveis por meio de uma única métrica.

### 6.3 Decomposição da Latência

A latência de ponta a ponta deve poder ser decomposta em estágios intermediários para que os atrasos possam ser localizados, e não apenas detectados.

A arquitetura deve oferecer suporte à medição de, no mínimo:

- confirmação na origem até a captura pelo CDC;
- captura pelo CDC até a disponibilidade no Kafka;
- disponibilidade no Kafka até a persistência na Bronze;
- persistência na Bronze até o processamento na Silver;
- processamento na Silver até a publicação na Gold;
- processamento na Gold até a publicação na Certified Gold.

Essas medições complementam o SLO de ponta a ponta e fornecem o contexto diagnóstico necessário para identificar se a latência tem origem na captura, no transporte, no armazenamento, na transformação, no *backlog* ou na publicação.

### 6.4 SLO e *Backlog*

A degradação da atualização pode ocorrer mesmo quando todos os componentes da plataforma permanecem tecnicamente disponíveis.

Um *backlog* crescente indica que os dados estão chegando mais rapidamente do que um ou mais estágios posteriores conseguem processá-los. Por esse motivo, o monitoramento de nível de serviço deve considerar tanto a latência quanto o comportamento do *backlog*.

O monitoramento do *backlog* não deve incluir apenas a profundidade da fila ou o atraso do consumidor, mas também a idade do evento pendente mais antigo, sempre que aplicável. Essa distinção ajuda a determinar o impacto real do trabalho acumulado para o negócio.

### 6.5 Detecção de Ausência de Eventos

A ausência de novos eventos não deve ser automaticamente interpretada como uma condição saudável.

Um período sem eventos pode representar uma ausência legítima de atividade de negócio, mas também pode indicar uma falha na captura da origem, no transporte ou no processamento.

A plataforma deve, portanto, correlacionar a ausência de eventos com os padrões de carga de trabalho esperados, a atividade da origem, a integridade dos componentes e o comportamento histórico antes de classificar a condição como normal ou anômala.

### 6.6 Objetivo Inicial e Recalibração

A meta de **P95 ≤ 15 minutos** é o objetivo de nível de serviço inicial da V1 e deve ser validada por meio de implementação e medição.

À medida que a plataforma acumular evidências operacionais reais, o SLO poderá ser recalibrado com base nas características medidas da carga de trabalho, nos requisitos de negócio, no comportamento do processamento e na capacidade validada da plataforma.

Qualquer alteração futura no SLO deve ser explícita, documentada, mensurável e sustentada por evidências, em vez de ser inferida exclusivamente a partir das especificações da infraestrutura ou de execuções isoladas bem-sucedidas.

---

## 7. Arquitetura de Alto Nível

A arquitetura de Engenharia de Dados da Versão 1 é composta por capacidades lógicas independentes conectadas por meio de fluxos de dados e contratos explícitos.

A arquitetura combina captura de alterações, transmissão de eventos, governança de *schema*, armazenamento de objetos, transformação analítica, disponibilização dimensional, orquestração, observabilidade e consumo analítico em uma única plataforma de ponta a ponta.

O fluxo tecnológico de alto nível é:

**AtlasCommerce (SQL Server) → SQL Server Native CDC → Debezium → Apache Kafka → Python/PyArrow → MinIO Bronze → MinIO Silver → AtlasWarehouse (SQL Server / Gold) → Certified Gold → Power BI**

O **Apicurio Registry** fornece governança de *schema* para os contratos de eventos utilizados no fluxo de integração orientado a eventos.

O **Apache Airflow** fornece a orquestração do fluxo de processamento, enquanto **Prometheus**, **Grafana** e o registro estruturado fornecem a base inicial de observabilidade.

### 7.1 Origem Operacional

O **AtlasCommerce**, implementado em **SQL Server**, é a origem operacional e o sistema de registro oficial (*system of record*) dos dados de negócio integrados à plataforma.

As responsabilidades transacionais permanecem isoladas do processamento analítico posterior. A arquitetura de Engenharia de Dados consome as alterações operacionais confirmadas sem transferir responsabilidades de processamento analítico para o sistema de origem.

### 7.2 Change Data Capture

O **SQL Server Native CDC** captura as alterações confirmadas na origem operacional.

O **Debezium** lê as informações do CDC e converte as alterações da origem em eventos adequados ao transporte e processamento posteriores.

O modelo inicial de captura utiliza CDC baseado em *log*, em vez de publicação de eventos no nível da aplicação ou extrações repetidas de tabelas completas.

### 7.3 Governança de Schema

O **Apicurio Registry** fornece gerenciamento centralizado de *schema* para os contratos de eventos.

Os *schemas* dos eventos são versionados e avaliados de acordo com regras de compatibilidade, permitindo que a evolução do *schema* seja controlada antes que alterações incompatíveis se propaguem pelos consumidores posteriores.

### 7.4 Transmissão de Eventos

O **Apache Kafka** fornece a camada de transporte e armazenamento temporário (*buffering*) de eventos.

O Kafka desacopla a captura da origem do processamento posterior, permitindo que produtores e consumidores operem de forma independente, ao mesmo tempo em que fornece o fluxo de eventos retido necessário para processamento assíncrono, *replay* controlado e absorção temporária de *backlog*.

A implantação inicial da V1 utiliza um ambiente Kafka de nó único para implementação em laboratório, preservando os limites lógicos necessários para futuras implantações em *cluster* ou serviços gerenciados.

### 7.5 Processamento de Dados

**Python** e **PyArrow** fornecem a base inicial de processamento para consumo de eventos, validação, transformação e geração de arquivos Parquet.

O processamento é projetado para ser idempotente e preservar os metadados necessários para rastreabilidade, *replay*, reconciliação e medição de latência.

### 7.6 Armazenamento Bronze

A camada **Bronze** é armazenada no **MinIO**, utilizando **Parquet com compressão Snappy**.

A Bronze é somente para adição (*append-only*) e preserva o histórico bruto de eventos recebido do Kafka, juntamente com os metadados necessários para rastreabilidade e reconstrução posterior.

Os objetos são publicados atomicamente por meio da criação temporária do objeto, seguida de sua promoção final após a validação bem-sucedida.

### 7.7 Armazenamento Silver

A camada **Silver** também é armazenada no **MinIO**, utilizando **Parquet com compressão Snappy**.

A Silver contém dados analíticos padronizados, tipados, deduplicados e reutilizáveis, produzidos a partir da Bronze. Ela representa a camada de transformação governada a partir da qual as estruturas analíticas posteriores podem ser reconstruídas.

### 7.8 Camada de Disponibilização Gold

A camada **Gold** é implementada no **AtlasWarehouse**, um banco de dados analítico **SQL Server**.

A Gold introduz estruturas analíticas dimensionais otimizadas para consumo de negócio e fornece a base de disponibilização a partir da qual são produzidos os resultados analíticos certificados.

A estratégia dimensional inicial utiliza **modelagem dimensional no estilo Kimball**, incluindo dimensões conformadas quando aplicável.

### 7.9 Certified Gold

A **Certified Gold** é o limite controlado de publicação para dados analíticos considerados adequados ao consumo oficial.

A publicação ocorre somente após o processamento necessário, a validação de qualidade, a reconciliação e o atendimento dos critérios de certificação exigidos.

A publicação certificada segue uma estratégia de publicação atômica para que os consumidores não observem conjuntos de dados analíticos parcialmente atualizados.

### 7.10 Consumo Analítico

O **Power BI** é a ferramenta inicial de consumo analítico.

O Power BI consome dados analíticos certificados, em vez de se conectar diretamente às camadas Bronze, Silver ou ao banco de dados operacional AtlasCommerce para os produtos analíticos governados definidos por esta arquitetura.

### 7.11 Orquestração

O **Apache Airflow** orquestra o processamento agendado, as dependências, as novas tentativas, os *backfills* e os fluxos de trabalho operacionais em toda a plataforma.

O Airflow coordena o processamento, mas não substitui o Kafka como mecanismo de transporte de eventos nem as camadas de armazenamento como sistemas de persistência.

### 7.12 Observabilidade

A base inicial de observabilidade é composta por **Prometheus**, **Grafana** e registro estruturado.

A observabilidade abrange todo o caminho dos dados e foi projetada para expor a integridade dos componentes, o fluxo de eventos, o *backlog*, a latência, o comportamento do processamento, as falhas de qualidade e a conformidade com os níveis de serviço.

O **OpenTelemetry** é reservado como uma evolução futura para rastreamento distribuído mais amplo e correlação de telemetria.

---

## 8. Fluxo de Dados

O pipeline de Engenharia de Dados propaga alterações operacionais confirmadas por meio de uma sequência de estágios controlados, cada um com uma responsabilidade específica de transporte, persistência, transformação, validação ou publicação.

O fluxo lógico de ponta a ponta é:

**Source Commit → CDC Capture → Event Creation → Kafka → Bronze → Silver → Gold → Quality and Reconciliation → Certified Gold → Analytical Consumption**

Os estágios abaixo descrevem o caminho normal de processamento. A recuperação de falhas, o *replay*, o *backfill* e a recuperação de desastre utilizam os mesmos limites arquiteturais, mas podem reingressar no fluxo a partir de diferentes pontos de recuperação.

### 8.1 Confirmação da Transação na Origem

O fluxo começa quando uma transação de negócio é confirmada com sucesso no **AtlasCommerce**.

Somente alterações operacionais confirmadas são elegíveis para propagação para a plataforma analítica. O AtlasCommerce permanece como o sistema de registro oficial (*system of record*) da transação de origem, e o pipeline analítico não participa da própria confirmação transacional.

O *timestamp* da confirmação na origem fornece a referência temporal inicial utilizada para a medição da latência de ponta a ponta.

### 8.2 Captura pelo CDC

O **SQL Server Native CDC** registra as alterações confirmadas necessárias ao pipeline de Engenharia de Dados.

O CDC fornece as informações de alteração sem exigir extrações repetidas de tabelas completas e sem exigir que a aplicação AtlasCommerce publique eventos analíticos de forma síncrona.

A alteração capturada permanece associada às informações da origem necessárias para a rastreabilidade e a ordenação posteriores.

### 8.3 Criação de Eventos

O **Debezium** lê as informações do CDC e converte as alterações da origem em eventos para processamento posterior.

Os eventos devem preservar os identificadores e os metadados da origem necessários para determinar sua origem, operação, ordenação e contexto de processamento.

Os metadados iniciais do evento incluem, conforme aplicável:

- `event_id`;
- `source_commit_ts`;
- LSN da origem ou posição equivalente na origem;
- tabela de origem;
- tipo de operação;
- versão do *schema*;
- *timestamp* de ingestão;
- identificador de rastreamento ou correlação.

Esses elementos de metadados oferecem suporte à idempotência, observabilidade, reconciliação, *replay* e linhagem em todo o pipeline.

### 8.4 Governança e Compatibilidade de Schema

Os contratos de eventos são governados por meio do **Apicurio Registry**.

Os *schemas* associados ao caminho de integração orientado a eventos são versionados e avaliados de acordo com a política de compatibilidade definida para o contrato correspondente.

Alterações compatíveis de *schema* podem seguir uma evolução controlada sem interromper desnecessariamente os consumidores existentes. Alterações incompatíveis ou destrutivas exigem uma estratégia de migração explícita e não devem ser introduzidas como se o contrato existente permanecesse inalterado.

A governança de *schema* é, portanto, um controle aplicado à evolução dos contratos de eventos, e não um estágio de transporte separado pelo qual cada evento individual deva passar.

### 8.5 Transporte Kafka

Os eventos validados são publicados no **Apache Kafka**, onde se tornam disponíveis para os consumidores posteriores.

O Kafka fornece transporte assíncrono, armazenamento temporário (*buffering*), retenção e capacidade de absorver diferenças temporárias entre as taxas de processamento dos produtores e consumidores.

O modelo inicial de entrega é **at-least-once**. Portanto, a entrega duplicada é possível e deve ser tratada de forma segura pelo processamento idempotente posterior.

A ordenação dos eventos é preservada dentro da partição Kafka aplicável. Portanto, o particionamento deve utilizar uma chave de negócio estável sempre que for necessária a ordenação entre eventos relacionados.

### 8.6 Persistência na Bronze

O consumidor da Bronze lê os eventos do Kafka e os persiste no **MinIO** em **Parquet com compressão Snappy**.

A Bronze preserva o histórico bruto de eventos em formato somente para adição (*append-only*), juntamente com os metadados necessários para rastreabilidade e reconstrução.

A persistência segue um padrão de escrita atômica:

**Temporary Object → Validation → Final Promotion**

Um lote da Bronze é considerado persistido com sucesso somente após o objeto final ter sido validado e promovido para seu caminho definitivo.

Os *offsets* do Kafka são confirmados somente após a persistência bem-sucedida na Bronze. Se o processamento falhar antes desse ponto, os mesmos eventos poderão ser entregues novamente e deverão ser tratados de forma idempotente.

### 8.7 Transformação na Silver

O processamento da Silver lê os dados validados da Bronze e os transforma em estruturas analíticas padronizadas, tipadas, deduplicadas e reutilizáveis.

Esse estágio aplica normalização estrutural e regras de transformação reutilizáveis, preservando os metadados necessários para linhagem, reconciliação e processamento posterior.

A Silver é persistida no **MinIO** utilizando **Parquet com compressão Snappy** e atua como um ponto de reconstrução governado para as estruturas analíticas posteriores.

### 8.8 Transformação na Gold

Os dados Silver validados são transformados em estruturas analíticas dimensionais no **AtlasWarehouse**.

A camada Gold aplica as transformações orientadas ao negócio e a modelagem dimensional necessárias aos casos de uso analítico.

A implementação inicial segue uma abordagem dimensional no estilo **Kimball** e introduz dimensões conformadas quando as entidades são compartilhadas entre múltiplos domínios analíticos.

O processamento da Gold deve permanecer executável novamente (*rerunnable*) e idempotente para que novas tentativas, *replay* ou reconstruções controladas não produzam efeitos analíticos duplicados.

### 8.9 Validação de Qualidade e Reconciliação

Uma transformação bem-sucedida não autoriza automaticamente a publicação analítica.

Antes da certificação, o pipeline avalia as regras de qualidade e os controles de reconciliação aplicáveis.

A validação pode incluir:

- unicidade;
- requisitos `NOT NULL`;
- integridade referencial;
- valores aceitos;
- regras de negócio;
- atualização;
- reconciliação entre origem e destino;
- completude do processamento.

Falhas críticas de qualidade bloqueiam a certificação e geram a visibilidade operacional e as evidências correspondentes.

### 8.10 Publicação na Certified Gold

Após o atendimento dos critérios necessários de qualidade e reconciliação, o conjunto de dados analítico torna-se elegível para publicação por meio da **Certified Gold**.

A publicação é atômica.

Os novos dados são preparados em uma estrutura de *staging* ou *shadow*, validados de forma independente e promovidos somente após a conclusão bem-sucedida dos controles necessários.

O padrão de publicação é:

**Prepare → Validate → Atomic Promote → Preserve Previous Version**

Os consumidores devem, portanto, observar o conjunto de dados anteriormente certificado ou o novo conjunto de dados certificado, nunca um estado intermediário parcialmente atualizado.

### 8.11 Consumo Analítico

Após a certificação bem-sucedida, o produto analítico torna-se disponível para consumo governado por meio do **Power BI**.

O produto certificado inicial é o **Daily Sales**.

O Power BI consome as estruturas de disponibilização certificadas, em vez de participar da captura na origem, da transformação dos dados brutos ou da lógica de certificação.

### 8.12 Rastreabilidade de Ponta a Ponta

O fluxo completo deve preservar metadados suficientes para rastrear os dados analíticos ao longo de seu caminho de processamento.

Quando aplicável, um resultado analítico deve poder ser rastreado por meio de:

**Certified Gold → Gold → Silver → Bronze → Kafka Event → Source Change**

Essa rastreabilidade oferece suporte à solução de problemas, reconciliação, auditabilidade, linhagem, análise de latência, investigação de *replay* e geração de evidências.

---

## 9. Camadas de Dados

A plataforma organiza os dados em camadas com responsabilidades distintas relacionadas à propriedade operacional, preservação histórica, padronização, modelagem analítica, certificação e consumo.

Os dados não passam por essas camadas simplesmente para mudar de local de armazenamento. Cada transição representa um aumento deliberado de estrutura, interpretação, governança ou preparação para uso analítico.

As principais camadas de dados são:

**Source → Bronze → Silver → Gold → Certified Gold → Analytical Consumption**

O Change Data Capture e o Event Streaming conectam a origem operacional às camadas analíticas, mas são capacidades de transporte e propagação, e não camadas de dados analíticos propriamente ditas.

### 9.1 Source — AtlasCommerce

O **AtlasCommerce** é a origem operacional e o sistema de registro oficial (*system of record*) das transações de negócio integradas à plataforma.

Sua responsabilidade principal é o processamento transacional. O modelo de origem é projetado de acordo com os requisitos operacionais do negócio e não deve ser remodelado simplesmente para facilitar o processamento analítico posterior.

A plataforma de Engenharia de Dados consome alterações confirmadas do AtlasCommerce, preservando a separação entre as cargas de trabalho operacionais e analíticas.

A origem é a fonte autoritativa para a transação operacional original, enquanto as camadas analíticas posteriores podem introduzir representações históricas, padronizadas, dimensionais e certificadas adequadas às suas próprias responsabilidades.

### 9.2 Bronze

A camada **Bronze** é a camada histórica imutável de aterrissagem da plataforma analítica.

Sua responsabilidade principal é preservar os eventos recebidos da camada de transmissão com transformação mínima e com metadados suficientes para oferecer suporte à rastreabilidade, ao *replay*, à reconciliação e à reconstrução.

A Bronze é:

- somente para adição (*append-only*);
- preservada historicamente;
- próxima da representação do evento de origem;
- persistida no **MinIO**;
- armazenada como **Parquet**;
- comprimida utilizando **Snappy**;
- enriquecida com os metadados técnicos necessários à operação da plataforma.

A Bronze não é a camada destinada à limpeza orientada ao negócio, à modelagem dimensional ou à certificação analítica.

Seu valor está na preservação de uma representação histórica confiável a partir da qual o processamento posterior pode ser repetido sem retornar desnecessariamente à origem operacional.

### 9.3 Silver

A camada **Silver** é a camada de transformação analítica padronizada e reutilizável.

A Silver transforma os dados da Bronze em estruturas mais consistentes e adequadas ao processamento analítico posterior.

As responsabilidades típicas da Silver incluem:

- tipagem explícita;
- padronização estrutural;
- normalização das representações;
- deduplicação controlada;
- regras de transformação reutilizáveis;
- preservação dos metadados técnicos de linhagem;
- preparação de conjuntos de dados consistentes em nível de domínio.

A Silver é persistida no **MinIO** utilizando **Parquet com compressão Snappy**.

A Silver não representa o modelo dimensional final de disponibilização e, por si só, não implica certificação analítica.

Seu papel é fornecer uma base governada e reutilizável a partir da qual as estruturas Gold podem ser construídas ou reconstruídas.

### 9.4 Gold

A camada **Gold** é a camada de disponibilização analítica orientada ao negócio, implementada no **AtlasWarehouse**.

A Gold transforma os dados padronizados da Silver em estruturas dimensionais projetadas para acesso analítico e interpretação pelo negócio.

Suas responsabilidades incluem:

- modelagem dimensional;
- fatos e dimensões;
- gerenciamento de chaves substitutas quando aplicável;
- comportamento dimensional histórico;
- dimensões conformadas;
- transformações orientadas ao negócio;
- estruturas otimizadas para consultas analíticas.

A estratégia de modelagem inicial segue a **modelagem dimensional no estilo Kimball**.

A Gold é projetada para ser executável novamente (*rerunnable*) e idempotente, de modo que o reprocessamento controlado não gere efeitos analíticos duplicados.

Os dados existentes na Gold são modelados analiticamente, mas não são automaticamente considerados certificados para consumo oficial.

### 9.5 Certified Gold

A **Certified Gold** é o limite governado de publicação para conjuntos de dados analíticos que atenderam aos critérios de certificação necessários.

A certificação pode exigir sucesso em:

- transformação;
- validação de qualidade;
- reconciliação;
- validação de atualização;
- verificações de completude;
- validação de regras de negócio;
- controles de publicação.

Falhas críticas de validação impedem que uma nova versão do conjunto de dados se torne certificada.

A Certified Gold utiliza uma estratégia de publicação atômica para que os consumidores observem a versão válida anterior ou a nova versão validada.

A certificação representa, portanto, uma transição de estado controlada, e não simplesmente outra cópia física dos mesmos dados.

### 9.6 Consumo Analítico

A camada de consumo analítico disponibiliza produtos de dados certificados para consumidores de inteligência de negócios e análise.

A tecnologia inicial de consumo é o **Power BI**, e o primeiro produto analítico certificado é o **Daily Sales**.

Os produtos analíticos governados consomem a Certified Gold em vez de acessar diretamente o AtlasCommerce, a Bronze ou a Silver.

Esse limite protege a origem operacional, impede que os consumidores dependam de estruturas intermediárias de processamento e estabelece uma distinção clara entre os dados existentes na plataforma e os dados aprovados para uso analítico oficial.

### 9.7 Progressão das Camadas

A progressão pela plataforma pode ser resumida como:

**Source**
→ verdade operacional

**Bronze**
→ histórico bruto preservado

**Silver**
→ dados analíticos padronizados e reutilizáveis

**Gold**
→ dados dimensionais orientados ao negócio

**Certified Gold**
→ dados analíticos validados e oficialmente publicáveis

**Analytical Consumption**
→ uso governado de produtos de dados certificados

Cada camada deve preservar as responsabilidades da arquitetura anterior, acrescentando os controles e a interpretação apropriados à sua própria finalidade.

---

## 10. Capacidades Transversais

A arquitetura de Engenharia de Dados inclui capacidades cujas responsabilidades abrangem múltiplos estágios do ciclo de vida dos dados, em vez de pertencerem a uma única camada de dados.

Essas capacidades fornecem os mecanismos de controle operacional, visibilidade, proteção, governança e evolução necessários para operar a plataforma como um sistema integrado.

As principais capacidades transversais da Versão 1 são:

- orquestração;
- observabilidade;
- segurança;
- governança e metadados;
- versionamento.

### 10.1 Orquestração

O **Apache Airflow** fornece a principal capacidade de orquestração para fluxos de dados agendados, orientados por dependências e operacionais.

Suas responsabilidades incluem:

- agendamento de fluxos de trabalho;
- gerenciamento de dependências;
- novas tentativas;
- *backfills* controlados;
- coordenação dos estágios de transformação;
- execução de verificações de qualidade;
- fluxos de trabalho de reconciliação;
- fluxos de trabalho de certificação;
- procedimentos de recuperação operacional quando a orquestração for necessária.

O Airflow coordena o trabalho em toda a plataforma, mas não substitui as responsabilidades dos componentes subjacentes.

Em particular, o Airflow não é utilizado como camada de transporte de eventos, não substitui a retenção do Kafka e não se torna o mecanismo de persistência dos dados analíticos.

Streaming e orquestração permanecem, portanto, como preocupações arquiteturais distintas:

**Kafka transporta e armazena temporariamente os eventos. Airflow coordena os fluxos de processamento.**

### 10.2 Observabilidade

A observabilidade abrange todo o caminho dos dados, desde a captura na origem até a publicação analítica certificada.

A base inicial de observabilidade é composta por:

- **Prometheus** para coleta de métricas;
- **Grafana** para painéis e visualização de alertas;
- registro estruturado para eventos de processamento e operacionais.

A plataforma deve fornecer visibilidade sobre:

- integridade dos componentes;
- atividade do CDC;
- comportamento dos produtores e consumidores Kafka;
- atraso do consumidor;
- *backlog*;
- idade do evento pendente mais antigo;
- persistência na Bronze;
- processamento da Silver e da Gold;
- duração do processamento;
- latência de certificação e publicação;
- falhas de qualidade;
- falhas de reconciliação;
- latência de ponta a ponta;
- percentis de latência;
- conformidade com o SLO;
- status da publicação.

A observabilidade deve ajudar a responder não apenas se um componente está disponível, mas se os dados estão efetivamente fluindo de forma correta e dentro do nível de serviço esperado.

Métricas e registros devem preservar *timestamps* e identificadores suficientes para correlacionar o comportamento entre os estágios de processamento.

O **OpenTelemetry** é reservado como uma evolução futura para rastreamento distribuído mais amplo e correlação de telemetria.

### 10.3 Segurança

Os controles de segurança são aplicados durante todo o ciclo de vida dos dados.

A arquitetura segue o princípio do menor privilégio e exige separação lógica entre identidades de serviços e responsabilidades.

As capacidades de segurança incluem:

- identidades separadas por serviço ou função;
- acesso restrito à origem;
- acesso controlado aos tópicos Kafka;
- acesso controlado ao armazenamento de objetos;
- permissões restritas no banco de dados analítico;
- gerenciamento de segredos fora do código-fonte;
- criptografia em trânsito quando suportada;
- criptografia em repouso quando suportada;
- acesso controlado às interfaces de observabilidade e orquestração;
- proteção de informações pessoais e sensíveis.

Os dados pessoais devem ser minimizados sempre que os valores completos da origem não forem necessários para o uso analítico.

Mascaramento, *hashing*, tokenização, acesso restrito ou exclusão podem ser aplicados de acordo com o requisito analítico e a classificação dos dados.

### 10.4 Governança e Metadados

A governança fornece as informações necessárias para compreender quais dados existem, quem é responsável por eles, como estão estruturados, de onde vieram e se são adequados para uso.

A Versão 1 adota um catálogo de metadados simplificado baseado em metadados controlados pelo repositório, em vez de introduzir uma plataforma dedicada de catálogo corporativo.

O catálogo inicial registra, quando aplicável:

- nome do conjunto de dados;
- descrição de negócio e técnica;
- proprietário;
- origem;
- *schema*;
- camada de dados;
- expectativa de atualização ou processamento;
- classificação de sensibilidade;
- estado do ciclo de vida;
- referências de linhagem.

Os estados do ciclo de vida dos conjuntos de dados são:

**Draft → Active → Deprecated → Removed**

Os metadados são versionados no Git para que alterações de propriedade, definições, *schemas*, ciclo de vida e linhagem permaneçam passíveis de revisão e rastreamento.

A linhagem começa com relacionamentos documentados e controlados pelo repositório entre conjuntos de dados de origem e analíticos. A coleta automatizada de linhagem pode ser introduzida como uma evolução futura.

### 10.5 Versionamento

O versionamento é aplicado aos artefatos que definem ou influenciam o comportamento da plataforma.

Os artefatos sob controle de versão incluem, quando aplicável:

- código-fonte;
- scripts SQL;
- configuração de infraestrutura;
- DAGs do Airflow;
- *schemas* de eventos;
- lógica de transformação;
- regras de qualidade;
- definições de metadados;
- documentação.

O **Git** é o mecanismo principal de controle de versão para os artefatos gerenciados pelo repositório.

As versões dos *schemas* de eventos são adicionalmente governadas pelo **Apicurio Registry**, refletindo seu papel como contratos de dados em tempo de execução entre produtores e consumidores.

O versionamento deve permitir que as alterações sejam revisadas, rastreadas, comparadas e, quando apropriado, associadas à implementação, aos testes, à implantação e às evidências.

Alterações que afetem contratos de dados, semântica analítica, regras de qualidade ou produtos publicados devem ser tratadas como alterações controladas da plataforma, e não como modificações isoladas de código.

---

## 11. Produto de Dados Inicial

O primeiro produto de dados analítico certificado da **Atlas Engineering — Enterprise Data Platform** é o **Daily Sales**.

O Daily Sales fornece o primeiro caso de uso de negócio por meio do qual toda a arquitetura de Engenharia de Dados é implementada e validada de ponta a ponta.

Seu propósito vai além de disponibilizar um conjunto de dados analítico orientado a vendas. O produto atua como o primeiro caminho de implementação controlada para validar as capacidades arquiteturais definidas na Versão 1.

### 11.1 Propósito de Negócio

O Daily Sales fornece uma visão analítica governada da atividade de vendas em nível diário.

O produto destina-se a apoiar uma análise consistente do desempenho de vendas utilizando dados que passaram por todo o ciclo de vida da plataforma, em vez de serem consultados diretamente no banco de dados operacional AtlasCommerce.

Sua definição analítica final, medidas, dimensões e regras de negócio devem permanecer alinhadas à documentação de negócio do AtlasCommerce e aos requisitos analíticos estabelecidos durante a implementação.

### 11.2 Caminho de Validação de Ponta a Ponta

O Daily Sales deve percorrer todo o caminho de dados governado:

**AtlasCommerce → CDC → Debezium → Kafka → Bronze → Silver → AtlasWarehouse / Gold → Quality and Reconciliation → Certified Gold → Power BI**

A governança de *schema* por meio do **Apicurio Registry** aplica-se aos contratos de eventos utilizados no caminho de integração orientado a eventos e é validada como parte das capacidades arquiteturais de ponta a ponta.

O produto fornece, portanto, uma implementação concreta por meio da qual a plataforma pode validar:

- captura de alterações na origem;
- criação e transporte de eventos;
- governança de *schema*;
- persistência na Bronze;
- padronização na Silver;
- transformação dimensional;
- aplicação de regras de qualidade;
- reconciliação;
- certificação;
- publicação atômica;
- consumo analítico;
- orquestração;
- observabilidade;
- controles de segurança;
- metadados e linhagem;
- idempotência;
- comportamento de *replay* e recuperação;
- medição de nível de serviço.

### 11.3 Certificação

O Daily Sales torna-se disponível para consumo analítico oficial somente após o atendimento dos critérios de certificação aplicáveis.

A certificação deve avaliar os controles necessários ao produto, incluindo qualidade dos dados, reconciliação, completude, atualização e validação das regras de negócio.

A conclusão bem-sucedida de um processamento não certifica, por si só, o produto.

Se um controle crítico de certificação falhar, a nova versão não deve substituir a versão anteriormente certificada.

### 11.4 Publicação

O produto segue a estratégia de publicação atômica da Certified Gold.

Uma nova versão do Daily Sales é preparada separadamente, validada e promovida somente após a conclusão bem-sucedida de todos os controles de certificação necessários.

A sequência de publicação é:

**Prepare → Validate → Atomic Promote → Preserve Previous Version**

Isso garante que os consumidores analíticos observem a versão anteriormente certificada do Daily Sales ou a nova versão certificada, nunca um estado intermediário parcialmente publicado.

### 11.5 Consumo

O consumidor governado inicial do Daily Sales é o **Power BI**.

O Power BI acessa a representação analítica certificada e não reproduz a lógica de transformação, reconciliação ou certificação que pertence à plataforma de Engenharia de Dados.

Essa separação preserva uma definição única e governada do produto analítico e reduz o risco de diferentes relatórios implementarem de forma independente regras de negócio conflitantes.

### 11.6 Propriedade e Metadados do Produto

O Daily Sales deve ser representado como um produto de dados governado, e não apenas como uma tabela, *view* ou conjunto de dados técnico.

Seus metadados devem identificar, quando aplicável:

- nome do produto;
- propósito de negócio;
- proprietário;
- domínio de origem;
- conjuntos de dados de origem;
- estruturas Gold;
- critérios de certificação;
- expectativa de atualização ou processamento;
- classificação de sensibilidade;
- linhagem;
- estado do ciclo de vida;
- consumidores.

Essas informações tornam-se parte do catálogo de metadados da plataforma e evoluem junto com o produto.

### 11.7 Evidências

O Daily Sales é o primeiro produto por meio do qual a arquitetura deve produzir evidências de implementação e validação.

As evidências geradas durante sua implementação podem incluir:

- processamento de ponta a ponta bem-sucedido;
- reconciliação entre origem e destino;
- resultados dos testes de qualidade;
- validação do tratamento de duplicidades;
- resultados de *replay*;
- resultados de recuperação;
- medições de latência;
- conformidade com o SLO;
- comportamento do *backlog*;
- falhas de certificação e recuperação;
- validação da publicação atômica.

As evidências devem descrever as condições nas quais o comportamento foi testado, para que os resultados de laboratório não sejam apresentados como garantias mais amplas de capacidade ou de produção.

### 11.8 Papel na Evolução da Plataforma

O Daily Sales é o primeiro produto de dados certificado, e não o escopo analítico final da plataforma.

Sua implementação estabelece o padrão inicial reutilizável para a incorporação de produtos analíticos e domínios de negócio adicionais.

As lições, medições, falhas e evidências arquiteturais obtidas durante a implementação do Daily Sales podem levar a refinamentos controlados da plataforma antes que os mesmos padrões sejam expandidos para domínios adicionais.

---

## 12. Estratégia de Incorporação Incremental de Domínios

A Enterprise Data Platform é expandida por meio da incorporação controlada e incremental de domínios de negócio.

A implementação inicial utiliza o domínio **Sales** para estabelecer e validar o primeiro padrão arquitetural completo. Domínios adicionais são introduzidos somente após o fluxo inicial de ponta a ponta ter sido implementado, testado, observado e sustentado por evidências suficientes.

A expansão incremental não significa que todos os domínios devam ser implementados de forma idêntica. Os princípios arquiteturais e os limites da plataforma permanecem consistentes, enquanto os contratos específicos do domínio, as transformações, as regras de qualidade, os modelos dimensionais, a propriedade e os produtos analíticos são definidos de acordo com as características de cada domínio de negócio.

### 12.1 Validação do Primeiro Domínio

O domínio **Sales** atua como a primeira implementação completa da arquitetura de Engenharia de Dados.

Antes que a plataforma seja expandida para domínios adicionais, o fluxo de Sales deve fornecer evidências suficientes de que as principais capacidades arquiteturais operam em conjunto conforme planejado.

Isso inclui, quando aplicável:

- captura de alterações na origem;
- governança de *schema*;
- transporte de eventos;
- persistência na Bronze;
- transformação na Silver;
- processamento dimensional na Gold;
- validação de qualidade;
- reconciliação;
- certificação;
- publicação analítica;
- orquestração;
- observabilidade;
- idempotência;
- *replay*;
- recuperação;
- medição de nível de serviço.

O objetivo não é provar que todo domínio futuro terá comportamento idêntico, mas validar a fundação arquitetural comum da qual os domínios adicionais dependerão.

### 12.2 Incorporação de Domínios

Cada domínio adicional deve ser incorporado por meio de um processo controlado de integração.

Antes da implementação, o domínio deve identificar, quando aplicável:

- propósito de negócio;
- objetos de origem;
- propriedade da origem;
- volume esperado de alterações;
- contratos de eventos;
- requisitos de particionamento e ordenação;
- conjuntos de dados Bronze;
- conjuntos de dados Silver e regras de transformação;
- fatos e dimensões Gold;
- dimensões conformadas;
- regras de qualidade dos dados;
- critérios de reconciliação;
- classificação de sensibilidade;
- requisitos de retenção;
- metadados e linhagem;
- produtos analíticos;
- critérios de certificação;
- consumidores;
- requisitos de observabilidade;
- considerações de recuperação e *replay*.

Isso impede que a expansão de domínios se torne apenas um exercício técnico de conexão de tabelas adicionais da origem ao pipeline.

### 12.3 Reutilização Antes da Duplicação

Novos domínios devem reutilizar as capacidades existentes da plataforma e as estruturas analíticas governadas sempre que sua semântica for compatível.

Isso inclui a reutilização de:

- padrões de ingestão;
- componentes de processamento de eventos;
- convenções de armazenamento;
- padrões de orquestração;
- mecanismos de observabilidade;
- estruturas de qualidade;
- estruturas de metadados;
- procedimentos de recuperação;
- dimensões conformadas.

A reutilização não deve substituir a correção semântica.

Uma estrutura existente deve ser reutilizada somente quando representar o mesmo significado de negócio e atender aos requisitos do novo domínio.

### 12.4 Dimensões Conformadas

Entidades de negócio compartilhadas devem utilizar **dimensões conformadas** quando exigirem uma interpretação analítica consistente entre múltiplos domínios.

Exemplos podem incluir entidades como:

- Data;
- Cliente;
- Produto;
- Loja.

Uma dimensão conformada fornece uma definição consistente e uma estrutura de chave analítica que pode ser compartilhada por múltiplas tabelas fato.

O primeiro domínio que exigir uma entidade compartilhada pode estabelecer sua representação dimensional inicial. Quando um domínio subsequente exigir a mesma entidade, a dimensão existente deve ser avaliada quanto à conformidade, em vez de ser automaticamente duplicada.

Se a estrutura existente não oferecer suporte adequado ao novo domínio, ela deverá evoluir por meio de uma alteração arquitetural controlada.

### 12.5 Variação Específica do Domínio

Não se espera que todos os domínios produzam o mesmo volume de eventos, complexidade de transformação, requisito de atualização, período de retenção, modelo dimensional ou regras de certificação.

A plataforma, portanto, distingue entre:

**Padrões arquiteturais compartilhados**

e

**Requisitos específicos do domínio**

Os padrões compartilhados preservam a consistência da plataforma.

Os requisitos específicos do domínio preservam a correção do negócio.

Um novo domínio não deve ser forçado a uma implementação inadequada apenas para que se assemelhe à primeira implementação de Sales.

### 12.6 Validação Independente

Cada novo domínio deve ser validado de forma independente antes que seus produtos analíticos sejam considerados certificados.

A implementação bem-sucedida de Sales não comprova automaticamente que outro domínio atende aos seus próprios requisitos.

A validação do domínio deve considerar seus requisitos específicos de:

- contratos de dados;
- regras de transformação;
- controles de qualidade;
- requisitos de reconciliação;
- comportamento de desempenho;
- expectativas de atualização;
- comportamento de recuperação;
- critérios de certificação.

As evidências devem, portanto, evoluir junto com a cobertura dos domínios.

### 12.7 Evolução da Documentação

A documentação da arquitetura deve evoluir à medida que os domínios são implementados e validados.

Um domínio recém-implementado pode exigir atualizações em:

- diagramas de arquitetura;
- fluxos de dados;
- perfis de carga de trabalho;
- catálogo de metadados;
- linhagem;
- modelos dimensionais;
- regras de qualidade;
- observabilidade;
- classificações de segurança;
- procedimentos de recuperação;
- documentação dos produtos certificados.

A documentação deve distinguir entre:

**Planned**  
→ considerado arquiteturalmente, mas ainda não implementado

**Implemented**  
→ tecnicamente disponível na plataforma

**Validated**  
→ testado sob condições documentadas

**Certified**  
→ aprovado para consumo analítico governado

Essa distinção impede que uma intenção arquitetural futura seja apresentada como uma capacidade de plataforma já demonstrada.

---

## 13. Arquitetura de Laboratório e Corporativa

A arquitetura da Versão 1 é implementada em um ambiente de laboratório projetado para aprendizado, implementação, testes, simulação de falhas, medição e validação arquitetural.

O laboratório opera intencionalmente com restrições de infraestrutura que não representariam a topologia final de uma plataforma corporativa de produção.

Essas restrições afetam a implantação física dos componentes, mas não devem redefinir suas responsabilidades lógicas, contratos ou limites arquiteturais.

### 13.1 Propósito do Laboratório

O laboratório existe para fornecer um ambiente controlado no qual toda a arquitetura de Engenharia de Dados possa ser implementada e exercitada.

Seus objetivos incluem:

- implementar o fluxo de dados de ponta a ponta;
- compreender o comportamento operacional de cada componente da plataforma;
- validar a integração entre os componentes;
- medir a carga de trabalho e o comportamento do processamento;
- observar a latência e o *backlog*;
- testar a idempotência e o tratamento de duplicidades;
- executar *replay* e *backfill*;
- simular falhas de componentes;
- validar procedimentos de recuperação;
- testar a evolução de *schema*;
- validar a qualidade dos dados e a reconciliação;
- produzir evidências arquiteturais.

O laboratório, portanto, não se limita a demonstrar execuções bem-sucedidas em condições normais.

Falhas controladas e cenários de recuperação fazem parte da implementação pretendida.

### 13.2 Restrições Físicas do Laboratório

O ambiente inicial pode hospedar múltiplos componentes da plataforma em um número limitado de recursos físicos ou virtuais.

Componentes que normalmente seriam distribuídos entre infraestruturas dedicadas podem inicialmente coexistir no mesmo ambiente de laboratório.

A implementação inicial da V1 pode, portanto, incluir características como:

- serviços de nó único;
- recursos computacionais compartilhados;
- limites de rede compartilhados;
- capacidade de armazenamento limitada;
- redundância reduzida;
- escala de carga de trabalho reduzida;
- simulação manual de falhas.

Essas características descrevem o ambiente de implementação, e não as responsabilidades arquiteturais-alvo da plataforma.

### 13.3 Separação Lógica

Mesmo quando os componentes compartilham a mesma infraestrutura física, suas responsabilidades lógicas permanecem separadas.

A arquitetura preserva limites independentes para:

- origem operacional;
- captura de alterações;
- governança de *schema*;
- transporte de eventos;
- armazenamento Bronze;
- armazenamento Silver;
- disponibilização analítica;
- publicação certificada;
- orquestração;
- observabilidade;
- segurança;
- metadados e governança.

Um servidor de laboratório compartilhado não deve resultar em acoplamento não controlado entre essas responsabilidades.

Os componentes devem interagir por meio de suas interfaces, contratos, limites de armazenamento e controles de acesso definidos, em vez de depender de uma proximidade acidental dentro do ambiente de laboratório.

### 13.4 Evolução Corporativa

A arquitetura lógica é projetada para que componentes individuais possam evoluir para modelos de implantação mais resilientes ou escaláveis sem redefinir todo o fluxo de dados.

Dependendo dos requisitos futuros, a evolução pode incluir:

- recursos computacionais dedicados;
- serviços em *cluster*;
- armazenamento replicado;
- processamento distribuído;
- isolamento de rede mais rigoroso;
- gerenciamento centralizado de identidades corporativas;
- plataformas externas de gerenciamento de segredos;
- provisionamento automatizado de infraestrutura;
- serviços de nuvem gerenciados;
- implantação em múltiplas zonas ou regiões;
- recursos ampliados de *backup* e recuperação de desastre;
- consumidores escalados horizontalmente;
- infraestrutura de monitoramento e alertas de nível de produção.

Essa evolução altera a topologia física e as características operacionais da plataforma, preservando, ao mesmo tempo, as responsabilidades e os contratos fundamentais estabelecidos pela arquitetura.

### 13.5 Escalabilidade

A arquitetura deve distinguir entre **escalabilidade arquitetural** e **capacidade validada**.

Escalabilidade arquitetural significa que a plataforma preserva limites e padrões de processamento que permitem que os componentes sejam escalados ou substituídos de forma independente, quando apropriado.

Capacidade validada representa as condições de carga de trabalho que foram efetivamente testadas e sustentadas por evidências.

Uma implementação de laboratório pode demonstrar escalabilidade arquitetural sem afirmar capacidade em escala de produção.

Da mesma forma, substituir um componente de nó único por uma alternativa em *cluster* ou gerenciada não comprova, por si só, que toda a plataforma atende a uma determinada carga de trabalho corporativa.

As afirmações de capacidade devem permanecer baseadas em medição e validação.

### 13.6 Alta Disponibilidade e Resiliência

O laboratório não busca reproduzir a alta disponibilidade corporativa completa de todos os componentes durante a implementação inicial.

Em vez disso, a V1 concentra-se na compreensão dos modos de falha, na preservação da recuperabilidade, na validação das estratégias de *replay* e reconstrução e na manutenção dos limites arquiteturais que suportam modelos de disponibilidade mais robustos em futuras implantações.

A evolução corporativa pode introduzir redundância em múltiplos níveis, incluindo:

- *brokers* Kafka;
- armazenamento de objetos;
- serviços de orquestração;
- bancos de dados analíticos;
- serviços de observabilidade;
- recursos computacionais.

A topologia necessária deve ser determinada pelos requisitos de disponibilidade do negócio, domínios de falha, RPO, RTO, carga de trabalho e restrições operacionais, e não pela simples reprodução da implantação do laboratório.

### 13.7 Evolução da Segurança

O laboratório implementa os princípios de segurança que podem ser validados de forma significativa em seu ambiente, incluindo separação de identidades, menor privilégio, proteção de segredos, acesso restrito e minimização de dados.

Uma implantação corporativa pode ampliar esses controles por meio de federação de identidades corporativas, IAM centralizado, cofres externos de segredos, gerenciamento de certificados, segmentação de rede, monitoramento de segurança e processos formais de governança de acesso.

A arquitetura de segurança, portanto, evolui em maturidade de implementação enquanto preserva os mesmos princípios fundamentais.

### 13.8 Das Evidências do Laboratório às Decisões Corporativas

Os resultados do laboratório fornecem evidências sobre o comportamento da arquitetura sob condições de teste documentadas.

Eles podem demonstrar:

- correção funcional;
- comportamento diante de falhas;
- comportamento de recuperação;
- idempotência;
- capacidade de *replay*;
- observabilidade;
- aplicação de regras de qualidade;
- desempenho medido;
- latência medida;
- capacidade testada.

Esses resultados não devem ser apresentados como prova automática de prontidão para produção ou de capacidade em escala corporativa.

Em vez disso, as evidências do laboratório fornecem uma base factual para identificar gargalos, estimar requisitos futuros, avaliar modelos alternativos de implantação e tomar decisões fundamentadas de arquitetura corporativa.

### 13.9 Responsabilidades Corporativas Típicas

O laboratório da Atlas Engineering implementa intencionalmente responsabilidades que, em um ambiente corporativo, podem ser distribuídas entre diversas equipes especializadas.

O mapeamento a seguir representa um modelo típico de responsabilidades e é fornecido para contexto organizacional. A propriedade real varia de acordo com a estrutura da empresa, a maturidade da plataforma, o modelo operacional e os limites entre as equipes.

| Capacidade Arquitetural | Responsabilidade Primária Típica | Colaboração Comum |
|---|---|---|
| Banco de dados operacional | DBA / Engenharia de Banco de Dados | Engenharia de Aplicações |
| Change Data Capture | Engenharia de Dados | DBA / Engenharia de Banco de Dados |
| Transmissão de eventos | Engenharia de Plataforma de Dados | Engenharia de Dados / SRE |
| Governança de *schema* e contratos de dados | Engenharia de Dados / Plataforma de Dados | Equipes das aplicações de origem |
| Processamento Bronze e Silver | Engenharia de Dados | Plataforma de Dados |
| Modelagem dimensional Gold | Engenharia de Dados / Engenharia Analítica | Negócio / BI |
| Qualidade de dados e reconciliação | Engenharia de Dados | Analytics / Governança de Dados |
| Orquestração de fluxos de trabalho | Engenharia de Dados | Plataforma de Dados / SRE |
| Observabilidade da plataforma | SRE / Plataforma de Dados | Engenharia de Dados |
| Engenharia de SLO e confiabilidade | SRE / Plataforma de Dados | Engenharia de Dados |
| Infraestrutura e disponibilidade dos serviços | Plataforma / SRE / DevOps | Responsáveis pelos componentes |
| *Backup* e recuperação de desastre | Plataforma / SRE / DBA | Engenharia de Dados |
| Identidade, segredos e controles de segurança | Segurança / Plataforma | Engenharia de Dados |
| Metadados, propriedade e linhagem | Governança de Dados / Engenharia de Dados | Responsáveis pelo negócio |
| Consumo analítico | BI / Engenharia Analítica | Engenharia de Dados |

Essas responsabilidades são intencionalmente colaborativas, e não absolutas. A propriedade arquitetural define o que uma capacidade deve fornecer, enquanto a propriedade organizacional determina qual equipe implementa, opera e oferece suporte a essa capacidade.

No laboratório da Atlas Engineering, esses limites são explorados por meio da implementação direta, para que as interações entre Engenharia de Dados e disciplinas adjacentes possam ser compreendidas e validadas na prática.

---

## 14. Evolução da Arquitetura

A arquitetura da Versão 1 estabelece o estado-alvo inicial da plataforma de Engenharia de Dados, mas não foi projetada para permanecer estática.

A arquitetura deve evoluir à medida que novos domínios de negócio, características de carga de trabalho, requisitos operacionais, evidências de implementação e capacidades corporativas forem introduzidos.

A evolução deve ser controlada, baseada em evidências e documentada. As alterações arquiteturais devem preservar a integridade das responsabilidades e dos contratos existentes, a menos que uma migração explícita os substitua intencionalmente.

### 14.1 Fatores para Mudança Arquitetural

A evolução arquitetural pode ser motivada por:

- novos domínios de negócio;
- novos produtos analíticos;
- crescimento medido da carga de trabalho;
- gargalos de desempenho;
- requisitos de nível de serviço;
- requisitos de confiabilidade;
- requisitos de segurança ou regulatórios;
- novos objetivos de recuperação;
- mudanças no ciclo de vida das tecnologias;
- complexidade operacional;
- evidências de implementação;
- limitações identificadas por meio de testes ou simulação de falhas.

Uma alteração tecnológica, por si só, não constitui necessariamente uma alteração arquitetural.

A substituição de um componente por outra implementação que preserve a mesma responsabilidade e o mesmo contrato pode representar uma evolução da implementação, e não um redesenho da plataforma.

### 14.2 Evolução Baseada em Evidências

As decisões arquiteturais devem evoluir a partir do comportamento observado sempre que houver evidências mensuráveis disponíveis.

Exemplos incluem:

- vazão medida;
- percentis de latência;
- crescimento e recuperação de *backlog*;
- crescimento do armazenamento;
- comportamento da compressão;
- duração do processamento;
- frequência de falhas;
- tempo de recuperação;
- falhas de qualidade;
- resultados de reconciliação;
- utilização de recursos.

As evidências coletadas durante a implementação e os testes de laboratório fornecem uma base factual para decidir se um componente, uma topologia, uma estratégia de processamento ou um controle operacional requer alteração.

A arquitetura não deve ser alterada simplesmente porque existe uma tecnologia ou topologia mais complexa.

### 14.3 Mudança Controlada

Alterações que afetem responsabilidades arquiteturais, interfaces, contratos de dados, semântica de processamento, comportamento de recuperação ou produtos analíticos certificados devem ser tratadas como alterações controladas.

Dependendo do impacto, uma alteração pode exigir atualizações em:

- documentação da arquitetura;
- *Architecture Decision Records* (ADRs);
- *schemas* de eventos;
- catálogo de metadados;
- linhagem;
- lógica de transformação;
- regras de qualidade;
- controles de reconciliação;
- observabilidade;
- controles de segurança;
- procedimentos de recuperação;
- testes;
- evidências;
- documentação dos produtos analíticos.

Alterações incompatíveis exigem uma estratégia de migração explícita.

### 14.4 Architecture Decision Records

Decisões e alterações arquiteturais significativas devem ser registradas por meio de **Architecture Decision Records (ADRs)**.

Um ADR deve registrar, quando aplicável:

- o contexto arquitetural;
- o problema ou requisito;
- as alternativas consideradas;
- a decisão selecionada;
- a justificativa;
- os *trade-offs*;
- as consequências;
- as implicações de implementação;
- referências de validação ou evidências.

Os ADRs preservam o raciocínio por trás da arquitetura para que futuros responsáveis pela manutenção possam compreender não apenas o que foi selecionado, mas também por que foi selecionado.

### 14.5 Evolução Tecnológica

A arquitetura separa intencionalmente a responsabilidade lógica da implementação tecnológica específica.

Isso permite que os componentes evoluam quando os requisitos justificarem a alteração.

Exemplos podem incluir:

- Kafka de nó único evoluindo para uma plataforma de transmissão de eventos em *cluster* ou gerenciada;
- MinIO de laboratório evoluindo para armazenamento de objetos distribuído ou gerenciado;
- segredos gerenciados localmente evoluindo para um serviço corporativo de gerenciamento de segredos;
- registro estruturado evoluindo para uma integração mais ampla com OpenTelemetry;
- linhagem baseada no repositório evoluindo para coleta automatizada de linhagem;
- serviços hospedados no laboratório evoluindo para infraestrutura dedicada ou gerenciada.

Essas alterações devem preservar a responsabilidade arquitetural do componente ou documentar explicitamente por que essa responsabilidade está sendo redesenhada.

### 14.6 Compatibilidade Retroativa e Migração

A evolução arquitetural deve considerar os produtores, consumidores, conjuntos de dados, produtos analíticos e procedimentos operacionais existentes.

Quando a compatibilidade retroativa puder ser preservada com segurança, a coexistência controlada entre versões poderá reduzir o risco de migração.

Quando a compatibilidade não puder ser preservada, a migração deverá definir:

- produtores e consumidores afetados;
- transição de versão;
- requisitos de migração ou reconstrução dos dados;
- sequência de implantação;
- estratégia de reversão;
- critérios de validação;
- período de descontinuação;
- critérios de remoção.

Alterações incompatíveis nunca devem depender de premissas não documentadas sobre os consumidores posteriores.

### 14.7 Documentação como Parte da Arquitetura

A documentação da arquitetura faz parte do estado mantido da plataforma.

Quando a arquitetura implementada ou validada for alterada, a documentação correspondente deve ser atualizada para que continue representando a plataforma real.

A documentação deve distinguir entre intenção futura e capacidade demonstrada.

Uma arquitetura proposta pode ser documentada como planejada, mas não deve substituir a descrição da arquitetura atualmente implementada e validada até que a alteração correspondente tenha sido concluída e sustentada por evidências.

### 14.8 Linha de Base da Versão 1

Uma vez implementada e validada, a Versão 1 torna-se a primeira linha de base arquitetural da plataforma de Engenharia de Dados.

A evolução futura deve ser avaliada em relação a essa linha de base, para que alterações em responsabilidades, contratos, topologia, comportamento operacional e capacidades validadas permaneçam rastreáveis.

O objetivo não é impedir alterações arquiteturais.

O objetivo é garantir que a plataforma evolua deliberadamente, com uma compreensão clara do que mudou, por que mudou, o que é afetado e quais evidências sustentam o novo estado.

---

## 15. Documentação Relacionada

Esta visão geral de arquitetura é o ponto de entrada para a compreensão da arquitetura de Engenharia de Dados da **Atlas Engineering — Enterprise Data Platform**.

Ele fornece intencionalmente uma visão de alto nível da plataforma e não substitui a documentação especializada necessária para descrever preocupações arquiteturais individuais, decisões de implementação, procedimentos operacionais, padrões, testes e evidências.

A documentação relacionada é organizada de acordo com sua responsabilidade dentro do repositório.

### 15.1 Documentação de Arquitetura

A documentação de arquitetura descreve a estrutura, as responsabilidades, os limites, os fluxos e o comportamento da plataforma.

Este documento fornece o contexto arquitetural inicial. Os documentos especializados de arquitetura expandem preocupações específicas sem duplicar suas responsabilidades.

A documentação especializada de arquitetura atual inclui:

- [**Data Flow and Processing**](Data-Flow-and-Processing.md) — descreve o comportamento do processamento de ponta a ponta, os estados de processamento, os contratos, o transporte Kafka, o processamento Bronze e Silver, o processamento dimensional Gold, a certificação, a recuperação, a linhagem, a observabilidade e a estratégia de validação.

- [**Reliability and Recovery**](Reliability-and-Recovery.md) — define o modelo de falhas, a semântica de recuperação, o estado durável, os *checkpoints*, o *replay*, o reprocessamento, o *backfill*, a reconstrução, a recuperação de *backlog*, o isolamento de falhas, o tratamento de registros problemáticos (*poison records*), RPO e RTO, os requisitos de observabilidade, os testes de recuperação, as evidências e os limites entre a resiliência de laboratório e a Alta Disponibilidade e Recuperação de Desastre corporativas.

- [**Security and Governance**](Security-and-Governance.md) — define o modelo de segurança, privacidade, identidade e acesso, segredos, proteção de rede, classificação de dados, retenção, auditabilidade, resposta a incidentes, validação de segurança e governança da plataforma.

- [**Observability**](Observability.md) — define o modelo de evidências operacionais da plataforma, incluindo *logs*, eventos operacionais estruturados, métricas, estado do processamento, correlação, atualização, atraso, *backlog*, visibilidade de falhas e recuperação, alertas, painéis, retenção de evidências e os limites entre a observabilidade de laboratório e as capacidades corporativas de monitoramento.

- [**Testing and Evidence Strategy**](Testing-and-Evidence-Strategy.md) — define como o comportamento arquitetural é validado por meio de cenários controlados e reproduzíveis, incluindo princípios de teste, classificação e cobertura de testes, projeto de cenários, critérios de aceitação, coleta e correlação de evidências, testes de falha e recuperação, qualidade dos dados, validação de certificação e segurança, validação arquitetural de ponta a ponta e preservação das evidências de teste e do histórico de validação.

Documentos adicionais de arquitetura podem ampliar preocupações como:

- perguntas frequentes de arquitetura.

Os documentos especializados de arquitetura devem complementar esta visão geral, e não duplicá-lo.

### 15.2 Decisões de Arquitetura

As decisões arquiteturais significativas são documentadas separadamente da visão geral de arquitetura.

Os Architecture Decision Records preservam o contexto, as alternativas, a justificativa, os *trade-offs*, as consequências e as evidências associadas às decisões importantes.

Essa separação permite que a visão geral de arquitetura descreva a arquitetura atual, enquanto os registros de decisão explicam por que escolhas significativas foram feitas.

### 15.3 Padrões

Os padrões definem regras e convenções reutilizáveis que devem ser seguidas de forma consistente em toda a plataforma.

Enquanto a arquitetura define responsabilidades e limites, os padrões definem como as preocupações técnicas recorrentes são implementadas de maneira consistente.

A documentação de arquitetura pode fazer referência aos padrões aplicáveis sem reproduzir seu conteúdo completo.

### 15.4 Documentação de Negócio

A documentação de negócio permanece como a fonte autoritativa para o significado operacional e as regras de negócio do **AtlasCommerce**.

As transformações de Engenharia de Dados, as definições analíticas, as regras de qualidade e os produtos certificados devem permanecer consistentes com as definições de negócio aplicáveis, a menos que uma regra analítica explícita introduza uma interpretação documentada.

A arquitetura de Engenharia de Dados não deve redefinir silenciosamente a semântica de negócio da origem.

### 15.5 Testes e Evidências

Os testes validam se o comportamento implementado da plataforma atende aos requisitos arquiteturais correspondentes.

As evidências registram os resultados observados dessas validações.

Quando aplicável, a documentação de arquitetura deve ser rastreável por meio de:

**Architecture Requirement → Implementation → Test → Observability → Evidence**

As evidências podem incluir *logs*, métricas, resultados de reconciliação, medições de latência, simulações de falhas, resultados de recuperação, resultados de testes de qualidade e outros artefatos reproduzíveis.

A documentação descreve a arquitetura pretendida e validada; as evidências demonstram as condições nas quais os comportamentos críticos foram observados.

### 15.6 FAQ de Arquitetura

O Architecture FAQ reúne perguntas arquiteturais recorrentes que surgem durante o projeto, a implementação, os testes, a revisão e a operação da plataforma.

Seu propósito é fornecer respostas concisas, direcionando os leitores à documentação autoritativa de arquitetura, decisões, padrões, testes ou evidências para obter detalhes mais aprofundados.

Perguntas derivadas de discussões reais de implementação e revisão são preferenciais porque refletem as preocupações que engenheiros, revisores e entrevistadores provavelmente apresentarão.

O FAQ não deve se tornar um substituto da documentação subjacente.

### 15.7 Consistência da Documentação

Toda a documentação relacionada deve descrever o mesmo estado arquitetural implementado.

Quando uma alteração arquitetural afetar múltiplos documentos, a documentação afetada deve ser revisada em conjunto para que diagramas, decisões, padrões, metadados, testes, evidências e descrições arquiteturais permaneçam consistentes.

Nenhum documento individual deve ser tratado como uma fonte de verdade isolada quando a capacidade documentada abranger múltiplas preocupações arquiteturais.

O repositório como um todo representa o estado mantido da documentação da plataforma.