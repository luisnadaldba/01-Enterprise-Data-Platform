# Atlas Engineering — Fluxo e Processamento de Dados

## Índice

- [1. Propósito](#1-propósito)

- [2. Contexto de Processamento](#2-contexto-de-processamento)
   - [2.1 Limite de Processamento](#21-limite-de-processamento)
   - [2.2 Modelo de Processamento Assíncrono](#22-modelo-de-processamento-assíncrono)
   - [2.3 Estados e Transições de Processamento](#23-estados-e-transições-de-processamento)
   - [2.4 Controles Transversais de Processamento](#24-controles-transversais-de-processamento)

- [3. Confirmação na Origem e Captura de Alterações](#3-confirmação-na-origem-e-captura-de-alterações)
   - [3.1 Confirmação da Transação na Origem](#31-confirmação-da-transação-na-origem)
   - [3.2 SQL Server Native CDC](#32-sql-server-native-cdc)
   - [3.3 Posição de Captura e Ordenação na Origem](#33-posição-de-captura-e-ordenação-na-origem)
   - [3.4 Limites de Transação](#34-limites-de-transação)
   - [3.5 Escopo da Captura](#35-escopo-da-captura)
   - [3.6 Latência de Captura](#36-latência-de-captura)
   - [3.7 Considerações sobre Falha e Recuperação](#37-considerações-sobre-falha-e-recuperação)
   - [3.8 Garantias da Captura de Alterações](#38-garantias-da-captura-de-alterações)

- [4. Criação de Eventos e Metadados Técnicos](#4-criação-de-eventos-e-metadados-técnicos)
   - [4.1 Representação do Evento](#41-representação-do-evento)
   - [4.2 *Payload* de Negócio](#42-payload-de-negócio)
   - [4.3 Metadados Técnicos](#43-metadados-técnicos)
   - [4.4 Identidade do Evento](#44-identidade-do-evento)
   - [4.5 Semântica das Operações](#45-semântica-das-operações)
   - [4.6 Posição na Origem e Identidade do Evento](#46-posição-na-origem-e-identidade-do-evento)
   - [4.7 Referência de *Schema* e Contrato](#47-referência-de-schema-e-contrato)
   - [4.8 Tempo do Evento e Tempo de Processamento](#48-tempo-do-evento-e-tempo-de-processamento)
   - [4.9 Correlação e Rastreabilidade](#49-correlação-e-rastreabilidade)
   - [4.10 Dados Sensíveis em Eventos](#410-dados-sensíveis-em-eventos)
   - [4.11 Garantias da Criação de Eventos](#411-garantias-da-criação-de-eventos)

- [5. Governança de *Schema* e Contratos](#5-governança-de-schema-e-contratos)
   - [5.1 Contrato de Evento](#51-contrato-de-evento)
   - [5.2 Responsabilidades de Produtores e Consumidores](#52-responsabilidades-de-produtores-e-consumidores)
   - [5.3 Registro de *Schemas*](#53-registro-de-schemas)
   - [5.4 Evolução de Contratos](#54-evolução-de-contratos)
   - [5.5 Política de Compatibilidade](#55-política-de-compatibilidade)
   - [5.6 Alterações Compatíveis](#56-alterações-compatíveis)
   - [5.7 Alterações Incompatíveis](#57-alterações-incompatíveis)
   - [5.8 Identificação da Versão do Contrato](#58-identificação-da-versão-do-contrato)
   - [5.9 Evolução de Contratos e Histórico da Bronze](#59-evolução-de-contratos-e-histórico-da-bronze)
   - [5.10 Validação e Testes de Contratos](#510-validação-e-testes-de-contratos)
   - [5.11 Responsabilidade e Documentação dos Contratos](#511-responsabilidade-e-documentação-dos-contratos)
   - [5.12 Ciclo de Vida dos Contratos](#512-ciclo-de-vida-dos-contratos)
   - [5.13 Garantias de Governança de *Schema* e Contratos](#513-garantias-de-governança-de-schema-e-contratos)

- [6. Transporte, Particionamento e Ordenação no Kafka](#6-transporte-particionamento-e-ordenação-no-kafka)
   - [6.1 *Topics*](#61-topics)
   - [6.2 Partições](#62-partições)
   - [6.3 Chave de Particionamento](#63-chave-de-particionamento)
   - [6.4 Garantias de Ordenação](#64-garantias-de-ordenação)
   - [6.5 *Offset* do Kafka](#65-offset-do-kafka)
   - [6.6 Grupos de Consumidores](#66-grupos-de-consumidores)
   - [6.7 Semântica de Entrega](#67-semântica-de-entrega)
   - [6.8 Gerenciamento de *Offsets*](#68-gerenciamento-de-offsets)
   - [6.9 Retenção](#69-retenção)
   - [6.10 *Backlog* e *Lag* do Consumidor](#610-backlog-e-lag-do-consumidor)
   - [6.11 Recuperação de *Backlog*](#611-recuperação-de-backlog)
   - [6.12 Rebalanceamento](#612-rebalanceamento)
   - [6.13 Falha e Recuperação do Kafka](#613-falha-e-recuperação-do-kafka)
   - [6.14 Observabilidade do Kafka](#614-observabilidade-do-kafka)
   - [6.15 Garantias do Transporte Kafka](#615-garantias-do-transporte-kafka)

- [7. Persistência na Bronze e Confirmação de *Offsets*](#7-persistência-na-bronze-e-confirmação-de-offsets)
   - [7.1 Limite de Persistência na Bronze](#71-limite-de-persistência-na-bronze)
   - [7.2 Conteúdo do Registro na Bronze](#72-conteúdo-do-registro-na-bronze)
   - [7.3 Persistência Histórica Imutável](#73-persistência-histórica-imutável)
   - [7.4 Gravação Temporária e Promoção Atômica](#74-gravação-temporária-e-promoção-atômica)
   - [7.5 Validação da Persistência](#75-validação-da-persistência)
   - [7.6 Confirmação do *Offset* do Kafka](#76-confirmação-do-offset-do-kafka)
   - [7.7 Falha Antes da Persistência na Bronze](#77-falha-antes-da-persistência-na-bronze)
   - [7.8 Falha Durante a Gravação Temporária](#78-falha-durante-a-gravação-temporária)
   - [7.9 Falha Após a Promoção na Bronze, mas Antes da Confirmação do *Offset*](#79-falha-após-a-promoção-na-bronze-mas-antes-da-confirmação-do-offset)
   - [7.10 Falha Após a Confirmação do *Offset*](#710-falha-após-a-confirmação-do-offset)
   - [7.11 Processamento Idempotente na Bronze](#711-processamento-idempotente-na-bronze)
   - [7.12 Granularidade dos Arquivos e Lotes](#712-granularidade-dos-arquivos-e-lotes)
   - [7.13 Organização da Bronze](#713-organização-da-bronze)
   - [7.14 *Replay* da Bronze](#714-replay-da-bronze)
   - [7.15 Retenção da Bronze](#715-retenção-da-bronze)
   - [7.16 Observabilidade da Bronze](#716-observabilidade-da-bronze)
   - [7.17 Reconciliação da Bronze](#717-reconciliação-da-bronze)
   - [7.18 Garantias de Persistência na Bronze](#718-garantias-de-persistência-na-bronze)

- [8. Processamento, Padronização e Desduplicação na Silver](#8-processamento-padronização-e-desduplicação-na-silver)
   - [8.1 Limite de Processamento da Silver](#81-limite-de-processamento-da-silver)
   - [8.2 Bronze como Entrada Histórica](#82-bronze-como-entrada-histórica)
   - [8.3 Interpretação Consciente do Contrato](#83-interpretação-consciente-do-contrato)
   - [8.4 Aplicação de Tipos](#84-aplicação-de-tipos)
   - [8.5 Padronização](#85-padronização)
   - [8.6 Normalização](#86-normalização)
   - [8.7 Desduplicação](#87-desduplicação)
   - [8.8 Processamento Idempotente na Silver](#88-processamento-idempotente-na-silver)
   - [8.9 Semântica das Operações](#89-semântica-das-operações)
   - [8.10 Estado Atual e Eventos Históricos](#810-estado-atual-e-eventos-históricos)
   - [8.11 Versão de Processamento](#811-versão-de-processamento)
   - [8.12 Registros Inválidos e Quarentena](#812-registros-inválidos-e-quarentena)
   - [8.13 Publicação na Silver](#813-publicação-na-silver)
   - [8.14 Processamento Incremental](#814-processamento-incremental)
   - [8.15 Reprocessamento](#815-reprocessamento)
   - [8.16 *Backfill*](#816-backfill)
   - [8.17 Reconciliação da Silver](#817-reconciliação-da-silver)
   - [8.18 Observabilidade da Silver](#818-observabilidade-da-silver)
   - [8.19 Garantias do Processamento da Silver](#819-garantias-do-processamento-da-silver)

- [9. Processamento Dimensional na Gold](#9-processamento-dimensional-na-gold)
   - [9.1 Limite de Processamento da Gold](#91-limite-de-processamento-da-gold)
   - [9.2 Modelo Dimensional](#92-modelo-dimensional)
   - [9.3 Grão do Fato](#93-grão-do-fato)
   - [9.4 Chaves de Negócio e Naturais](#94-chaves-de-negócio-e-naturais)
   - [9.5 Chaves Substitutas](#95-chaves-substitutas)
   - [9.6 Processamento de Dimensões](#96-processamento-de-dimensões)
   - [9.7 Dimensões de Mudança Lenta](#97-dimensões-de-mudança-lenta)
   - [9.8 Dimensões Conformadas](#98-dimensões-conformadas)
   - [9.9 Processamento de Fatos](#99-processamento-de-fatos)
   - [9.10 Consulta de Dimensões e Membros Desconhecidos](#910-consulta-de-dimensões-e-membros-desconhecidos)
   - [9.11 Consistência Temporal](#911-consistência-temporal)
   - [9.12 Processamento Incremental da Gold](#912-processamento-incremental-da-gold)
   - [9.13 Processamento Idempotente na Gold](#913-processamento-idempotente-na-gold)
   - [9.14 Versão de Processamento da Gold](#914-versão-de-processamento-da-gold)
   - [9.15 Reprocessamento da Gold](#915-reprocessamento-da-gold)
   - [9.16 Publicação na Gold](#916-publicação-na-gold)
   - [9.17 Reconciliação da Gold](#917-reconciliação-da-gold)
   - [9.18 Observabilidade da Gold](#918-observabilidade-da-gold)
   - [9.19 Garantias do Processamento da Gold](#919-garantias-do-processamento-da-gold)

- [10. Validação de Qualidade e Reconciliação](#10-validação-de-qualidade-e-reconciliação)
   - [10.1 Limite de Validação de Qualidade](#101-limite-de-validação-de-qualidade)
   - [10.2 Dimensões de Qualidade dos Dados](#102-dimensões-de-qualidade-dos-dados)
   - [10.3 Qualidade Estrutural](#103-qualidade-estrutural)
   - [10.4 Regras de Qualidade de Negócio](#104-regras-de-qualidade-de-negócio)
   - [10.5 Controles Críticos e Não Críticos](#105-controles-críticos-e-não-críticos)
   - [10.6 Controles Baseados em Limites](#106-controles-baseados-em-limites)
   - [10.7 Reconciliação da Origem ao Destino](#107-reconciliação-da-origem-ao-destino)
   - [10.8 Reconciliação entre Camadas](#108-reconciliação-entre-camadas)
   - [10.9 Janelas de Reconciliação](#109-janelas-de-reconciliação)
   - [10.10 Dados que Chegam com Atraso](#1010-dados-que-chegam-com-atraso)
   - [10.11 Tratamento de Falhas de Qualidade](#1011-tratamento-de-falhas-de-qualidade)
   - [10.12 Última Versão Reconhecidamente Confiável](#1012-última-versão-reconhecidamente-confiável)
   - [10.13 Decisão de Certificação](#1013-decisão-de-certificação)
   - [10.14 Publicação Atômica na Certified Gold](#1014-publicação-atômica-na-certified-gold)
   - [10.15 Atualidade *End-to-End*](#1015-atualidade-end-to-end)
   - [10.16 Observabilidade de Qualidade e Reconciliação](#1016-observabilidade-de-qualidade-e-reconciliação)
   - [10.17 Evolução das Regras de Qualidade](#1017-evolução-das-regras-de-qualidade)
   - [10.18 Garantias de Qualidade e Reconciliação](#1018-garantias-de-qualidade-e-reconciliação)

- [11. Publicação na Certified Gold e Consumo Analítico](#11-publicação-na-certified-gold-e-consumo-analítico)
   - [11.1 Limite da Certified Gold](#111-limite-da-certified-gold)
   - [11.2 Versões Candidata e Publicada](#112-versões-candidata-e-publicada)
   - [11.3 Publicação Bem-Sucedida](#113-publicação-bem-sucedida)
   - [11.4 Falha na Publicação da Versão Candidata](#114-falha-na-publicação-da-versão-candidata)
   - [11.5 Publicação Atômica](#115-publicação-atômica)
   - [11.6 *Timestamp* de Publicação](#116-timestamp-de-publicação)
   - [11.7 Contrato de Consumo Analítico](#117-contrato-de-consumo-analítico)
   - [11.8 Consumo pelo Power BI](#118-consumo-pelo-power-bi)
   - [11.9 Isolamento do Consumidor em Relação ao Processamento](#119-isolamento-do-consumidor-em-relação-ao-processamento)
   - [11.10 Falha de Publicação](#1110-falha-de-publicação)
   - [11.11 *Rollback*](#1111-rollback)
   - [11.12 Atualidade para os Consumidores](#1112-atualidade-para-os-consumidores)
   - [11.13 Comportamento dos Consumidores Durante Desatualização](#1113-comportamento-dos-consumidores-durante-desatualização)
   - [11.14 Controle de Acesso](#1114-controle-de-acesso)
   - [11.15 Metadados do Produto Certificado](#1115-metadados-do-produto-certificado)
   - [11.16 Observabilidade da Publicação](#1116-observabilidade-da-publicação)
   - [11.17 Garantias de Consumo Analítico](#1117-garantias-de-consumo-analítico)

- [12. Tratamento de Falhas, *Replay* e Recuperação](#12-tratamento-de-falhas-replay-e-recuperação)
   - [12.1 Domínios de Falha](#121-domínios-de-falha)
   - [12.2 Classificação de Falhas](#122-classificação-de-falhas)
   - [12.3 Nova Tentativa](#123-nova-tentativa)
   - [12.4 Checkpoints de Processamento](#124-checkpoints-de-processamento)
   - [12.5 Recuperação a partir do Kafka](#125-recuperação-a-partir-do-kafka)
   - [12.6 Recuperação a partir da Bronze](#126-recuperação-a-partir-da-bronze)
   - [12.7 Recuperação a partir da Silver](#127-recuperação-a-partir-da-silver)
   - [12.8 Recuperação a partir de Backup](#128-recuperação-a-partir-de-backup)
   - [12.9 Seleção da Fonte de Recuperação](#129-seleção-da-fonte-de-recuperação)
   - [12.10 Replay](#1210-replay)
   - [12.11 Segurança do Replay](#1211-segurança-do-replay)
   - [12.12 Reprocessamento](#1212-reprocessamento)
   - [12.13 Backfill](#1213-backfill)
   - [12.14 Rebuild](#1214-rebuild)
   - [12.15 Recuperação e Versões de Contrato](#1215-recuperação-e-versões-de-contrato)
   - [12.16 Recuperação e Versões de Processamento](#1216-recuperação-e-versões-de-processamento)
   - [12.17 Recuperação e Certified Gold](#1217-recuperação-e-certified-gold)
   - [12.18 Recuperação de Backlog](#1218-recuperação-de-backlog)
   - [12.19 Ponto de Recuperação e Tempo de Recuperação](#1219-ponto-de-recuperação-e-tempo-de-recuperação)
   - [12.20 Falha Parcial](#1220-falha-parcial)
   - [12.21 Registros Venenosos](#1221-registros-venenosos)
   - [12.22 Validação da Recuperação](#1222-validação-da-recuperação)
   - [12.23 Evidências de Recuperação](#1223-evidências-de-recuperação)
   - [12.24 Observabilidade da Recuperação](#1224-observabilidade-da-recuperação)
   - [12.25 Garantias de Tratamento de Falhas e Recuperação](#1225-garantias-de-tratamento-de-falhas-e-recuperação)

- [13. Rastreabilidade e Linhagem *End-to-End*](#13-rastreabilidade-e-linhagem-end-to-end)
   - [13.1 Limite de Rastreabilidade e Linhagem](#131-limite-de-rastreabilidade-e-linhagem)
   - [13.2 Rastreabilidade da Origem](#132-rastreabilidade-da-origem)
   - [13.3 Identidade do Evento](#133-identidade-do-evento)
   - [13.4 Rastreabilidade no Kafka](#134-rastreabilidade-no-kafka)
   - [13.5 Linhagem da Bronze](#135-linhagem-da-bronze)
   - [13.6 Linhagem da Silver](#136-linhagem-da-silver)
   - [13.7 Linhagem da Gold](#137-linhagem-da-gold)
   - [13.8 Linhagem Dimensional](#138-linhagem-dimensional)
   - [13.9 Linhagem da Certified Gold](#139-linhagem-da-certified-gold)
   - [13.10 Linhagem do Produto Analítico](#1310-linhagem-do-produto-analítico)
   - [13.11 Análise de Impacto *Forward*](#1311-análise-de-impacto-forward)
   - [13.12 Investigação Reversa](#1312-investigação-reversa)
   - [13.13 Linhagem através de Agregação](#1313-linhagem-através-de-agregação)
   - [13.14 Linhagem através de Replay e Reprocessamento](#1314-linhagem-através-de-replay-e-reprocessamento)
   - [13.15 Linhagem e Versões de Processamento](#1315-linhagem-e-versões-de-processamento)
   - [13.16 Identificadores de Correlação e Execução](#1316-identificadores-de-correlação-e-execução)
   - [13.17 Rastreabilidade e Observabilidade](#1317-rastreabilidade-e-observabilidade)
   - [13.18 Gerenciamento de Metadados de Linhagem](#1318-gerenciamento-de-metadados-de-linhagem)
   - [13.19 Retenção da Linhagem](#1319-retenção-da-linhagem)
   - [13.20 Validação da Linhagem](#1320-validação-da-linhagem)
   - [13.21 Evidências de Linhagem](#1321-evidências-de-linhagem)
   - [13.22 Garantias de Rastreabilidade e Linhagem](#1322-garantias-de-rastreabilidade-e-linhagem)

- [14. Observabilidade e Medição Operacional](#14-observabilidade-e-medição-operacional)
   - [14.1 Dimensões de Observabilidade](#141-dimensões-de-observabilidade)
   - [14.2 Saúde da Infraestrutura](#142-saúde-da-infraestrutura)
   - [14.3 Saúde do Fluxo de Dados](#143-saúde-do-fluxo-de-dados)
   - [14.4 *Throughput*](#144-throughput)
   - [14.5 Latência por Etapa](#145-latência-por-etapa)
   - [14.6 Latência *End-to-End*](#146-latência-end-to-end)
   - [14.7 Percentis](#147-percentis)
   - [14.8 Backlog](#148-backlog)
   - [14.9 Trabalho Pendente Mais Antigo](#149-trabalho-pendente-mais-antigo)
   - [14.10 Detecção de Ausência de Eventos](#1410-detecção-de-ausência-de-eventos)
   - [14.11 Sucesso e Falha do Processamento](#1411-sucesso-e-falha-do-processamento)
   - [14.12 Classificação de Erros](#1412-classificação-de-erros)
   - [14.13 *Logging* Estruturado](#1413-logging-estruturado)
   - [14.14 Correlação](#1414-correlação)
   - [14.15 Observabilidade da Qualidade](#1415-observabilidade-da-qualidade)
   - [14.16 Observabilidade da Reconciliação](#1416-observabilidade-da-reconciliação)
   - [14.17 Observabilidade da Certificação e Publicação](#1417-observabilidade-da-certificação-e-publicação)
   - [14.18 Observabilidade do Consumidor](#1418-observabilidade-do-consumidor)
   - [14.19 SLI e SLO](#1419-sli-e-slo)
   - [14.20 Alertas](#1420-alertas)
   - [14.21 Linhas de Base Sazonais e de Carga de Trabalho](#1421-linhas-de-base-sazonais-e-de-carga-de-trabalho)
   - [14.22 Observabilidade da Recuperação](#1422-observabilidade-da-recuperação)
   - [14.23 Observabilidade de Capacidade](#1423-observabilidade-de-capacidade)
   - [14.24 Linha de Base Medida](#1424-linha-de-base-medida)
   - [14.25 Estratégia de Dashboards](#1425-estratégia-de-dashboards)
   - [14.26 Evidências a partir da Observabilidade](#1426-evidências-a-partir-da-observabilidade)
   - [14.27 Evolução com OpenTelemetry](#1427-evolução-com-opentelemetry)
   - [14.28 Garantias de Observabilidade](#1428-garantias-de-observabilidade)

- [15. Evidências de Processamento e Estratégia de Validação](#15-evidências-de-processamento-e-estratégia-de-validação)
   - [15.1 Escopo da Validação](#151-escopo-da-validação)
   - [15.2 Validação do Caminho Normal](#152-validação-do-caminho-normal)
   - [15.3 Injeção de Falhas](#153-injeção-de-falhas)
   - [15.4 Validação da Idempotência](#154-validação-da-idempotência)
   - [15.5 Validação de Offsets e Durabilidade](#155-validação-de-offsets-e-durabilidade)
   - [15.6 Validação da Persistência Atômica](#156-validação-da-persistência-atômica)
   - [15.7 Validação da Evolução de Contratos](#157-validação-da-evolução-de-contratos)
   - [15.8 Validação das Transformações](#158-validação-das-transformações)
   - [15.9 Validação do *Gate* de Qualidade](#159-validação-do-gate-de-qualidade)
   - [15.10 Validação da Reconciliação](#1510-validação-da-reconciliação)
   - [15.11 Validação da Publicação Certificada](#1511-validação-da-publicação-certificada)
   - [15.12 Validação de *Replay*](#1512-validação-de-replay)
   - [15.13 Validação de *Backfill*](#1513-validação-de-backfill)
   - [15.14 Validação da Recuperação](#1514-validação-da-recuperação)
   - [15.15 Validação da Recuperação de *Backlog*](#1515-validação-da-recuperação-de-backlog)
   - [15.16 Validação do SLO](#1516-validação-do-slo)
   - [15.17 Validação de Carga de Trabalho e Capacidade](#1517-validação-de-carga-de-trabalho-e-capacidade)
   - [15.18 Validação da Rastreabilidade](#1518-validação-da-rastreabilidade)
   - [15.19 Estrutura das Evidências](#1519-estrutura-das-evidências)
   - [15.20 Nomenclatura das Evidências](#1520-nomenclatura-das-evidências)
   - [15.21 Qualidade das Evidências](#1521-qualidade-das-evidências)
   - [15.22 Evidências Negativas](#1522-evidências-negativas)
   - [15.23 Evidências e Evolução da Arquitetura](#1523-evidências-e-evolução-da-arquitetura)
   - [15.24 Afirmações de Laboratório](#1524-afirmações-de-laboratório)
   - [15.25 Garantias da Validação de Processamento](#1525-garantias-da-validação-de-processamento)

---

## 1. Propósito

O propósito deste documento é descrever o fluxo de dados *end-to-end* e o comportamento de processamento da **camada de Engenharia de Dados** dentro do **Atlas Engineering — Enterprise Data Platform**.

Enquanto a **Visão Geral da Arquitetura** define os componentes de alto nível, as responsabilidades, os limites e os princípios arquiteturais da plataforma, este documento concentra-se em como os dados se movimentam entre esses componentes e em como se espera que cada transição de processamento se comporte.

O documento descreve o caminho completo desde uma alteração operacional confirmada no **AtlasCommerce** até sua disponibilização como dados analíticos certificados, incluindo captura de alterações, criação e transporte de eventos, governança de *schemas*, persistência histórica, transformação, processamento dimensional, validação de qualidade, reconciliação, certificação e publicação analítica.

Ele também define as garantias de processamento e os mecanismos de controle necessários ao longo desse caminho, incluindo identidade de eventos, ordenação, semântica de entrega, idempotência, desduplicação, persistência atômica, gerenciamento de *offsets*, *replay*, *backfill*, rastreabilidade, tratamento de falhas e comportamento de recuperação.

O principal fluxo de processamento *end-to-end* é:

**AtlasCommerce → SQL Server Native CDC → Debezium → Apache Kafka → Bronze → Silver → Gold → Qualidade e Reconciliação → Certified Gold → Consumo Analítico**

O **Apicurio Registry** governa os *schemas* e a compatibilidade dos contratos de eventos utilizados ao longo do caminho de integração orientado a eventos e, portanto, é tratado como uma capacidade transversal de governança de contratos, e não como uma etapa de transporte pela qual todos os eventos devem passar.

O modelo de processamento descrito aqui representa o comportamento-alvo da **Versão 1 (V1)**. Procedimentos específicos de implementação, valores de configuração, *runbooks* operacionais e evidências de execução são documentados separadamente e devem permanecer consistentes com as garantias de processamento definidas neste documento.

---

## 2. Contexto de Processamento

O fluxo de processamento de Engenharia de Dados começa após uma transação de negócio ter sido confirmada com sucesso no **AtlasCommerce**.

A plataforma analítica não participa da transação operacional e não deve se tornar uma dependência síncrona da carga de trabalho da origem. Uma transação confirmada no AtlasCommerce permanece operacionalmente válida independentemente da disponibilidade imediata dos componentes *downstream* de Engenharia de Dados.

Após a confirmação, a alteração correspondente torna-se elegível para captura por meio do **SQL Server Native CDC**. O **Debezium** lê as informações da alteração capturada e produz uma representação do evento para transporte assíncrono por meio do **Apache Kafka**.

A partir desse ponto, o evento progride por uma sequência de estados controlados de processamento:

**Alteração Confirmada na Origem → Alteração Capturada → Evento Publicado → Registro Persistido na Bronze → Registro Padronizado na Silver → Dados Modelados na Gold → Dados Validados e Reconciliados → Publicação da Certified Gold → Consumo Analítico**

Cada transição introduz uma responsabilidade específica e deve preservar as informações necessárias para rastreabilidade, recuperação, reconciliação e medição.

O caminho de processamento é assíncrono por design. A indisponibilidade temporária ou a redução da capacidade de processamento em um componente *downstream* pode atrasar a atualidade analítica e criar *backlog*, mas não deve exigir que a transação na origem aguarde a conclusão do processamento pela plataforma analítica.

Essa separação permite que as cargas de trabalho operacional e analítica evoluam de forma independente, mantendo uma relação rastreável entre a alteração originalmente confirmada e sua representação analítica *downstream*.

### 2.1 Limite de Processamento

O limite de processamento coberto por este documento começa com uma alteração confirmada no AtlasCommerce e termina quando a representação analítica correspondente conclui com sucesso os controles necessários de qualidade, reconciliação, certificação e publicação.

Para produtos analíticos governados, o processamento não é considerado concluído apenas porque os dados chegaram à **Gold**.

O limite de processamento *end-to-end* é concluído quando os dados correspondentes se tornam disponíveis por meio da **Certified Gold** para consumo analítico governado.

Esse limite é consistente com a medição de atualidade *end-to-end* da V1 definida pela arquitetura:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

### 2.2 Modelo de Processamento Assíncrono

A plataforma utiliza processamento assíncrono para desacoplar a execução das transações operacionais do processamento analítico *downstream*.

Isso significa que:

- o AtlasCommerce confirma as transações de negócio independentemente do processamento analítico *downstream*;
- o CDC captura as alterações confirmadas após o limite da transação operacional;
- o Kafka fornece transporte assíncrono, *buffering* e retenção;
- os consumidores *downstream* processam os dados de acordo com sua capacidade disponível;
- diferenças temporárias entre a taxa de chegada de eventos e a taxa de processamento podem criar *backlog*;
- o *backlog* deve permanecer observável e recuperável;
- a atualidade analítica pode se degradar durante uma interrupção *downstream* sem invalidar a transação operacional já confirmada.

O modelo assíncrono, portanto, fornece desacoplamento temporal entre a carga de trabalho da origem e a plataforma analítica.

### 2.3 Estados e Transições de Processamento

Os dados não se tornam informações analíticas certificadas por meio de uma única transformação.

Eles progridem por estados explícitos de processamento, cada um com um significado distinto:

**Alteração Confirmada na Origem**  
A transação de negócio foi confirmada com sucesso no AtlasCommerce.

**Alteração Capturada**  
O SQL Server Native CDC disponibilizou a alteração confirmada para captura *downstream*.

**Evento Publicado**  
O Debezium representou a alteração capturada como um evento e a disponibilizou por meio do Kafka.

**Registro Persistido na Bronze**  
O evento foi persistido de forma durável na camada histórica imutável, juntamente com os metadados técnicos necessários.

**Registro Padronizado na Silver**  
A representação histórica foi tipada, padronizada, normalizada e desduplicada de acordo com as regras de processamento aplicáveis.

**Dados Modelados na Gold**  
Os dados padronizados foram transformados em estruturas dimensionais orientadas ao negócio.

**Dados Validados e Reconciliados**  
As estruturas analíticas resultantes passaram com sucesso pelos controles necessários de qualidade e reconciliação entre origem e destino.

**Publicação na Certified Gold**  
A versão analítica validada foi promovida atomicamente ao estado de publicação governada.

**Consumo Analítico**  
Os dados certificados estão disponíveis para consumidores analíticos autorizados de acordo com o contrato do produto de dados correspondente.

Uma transição entre estados não deve implicar que garantias posteriores já tenham sido satisfeitas. Por exemplo, a persistência bem-sucedida na Bronze não implica processamento bem-sucedido na Silver, e a transformação bem-sucedida na Gold não implica certificação.

### 2.4 Controles Transversais de Processamento

Alguns controles se aplicam a múltiplos estados de processamento, em vez de pertencerem a uma única transição.

Eles incluem:

- identidade de eventos e metadados técnicos;
- governança de *schemas* e contratos;
- controles de ordenação;
- idempotência;
- desduplicação;
- rastreabilidade e linhagem;
- observabilidade;
- segurança;
- controles de qualidade;
- reconciliação;
- comportamento de novas tentativas e recuperação;
- controles de *replay* e *backfill*;
- versionamento.

Esses controles devem preservar as garantias pretendidas durante novas tentativas, falhas, reprocessamento e operações de recuperação.

Seu comportamento detalhado é descrito nas seções correspondentes deste documento.

---

## 3. Confirmação na Origem e Captura de Alterações

O fluxo *end-to-end* de Engenharia de Dados começa com uma transação de negócio confirmada com sucesso no **AtlasCommerce**.

Somente alterações confirmadas na origem são elegíveis para entrar no caminho de processamento analítico. A plataforma de Engenharia de Dados não participa da transação na origem e deve preservar o limite da transação operacional estabelecido pelo AtlasCommerce.

A captura de alterações é implementada por meio do **SQL Server Native Change Data Capture (CDC)**, que fornece a base no lado da origem para identificar inserções, atualizações e exclusões confirmadas que devem ser propagadas *downstream*.

### 3.1 Confirmação da Transação na Origem

Uma alteração na origem torna-se relevante para a plataforma de Engenharia de Dados somente após a transação correspondente ter sido confirmada com sucesso no AtlasCommerce.

A confirmação estabelece a verdade operacional da alteração.

Antes da confirmação, a alteração não deve ser tratada como um evento analítico, pois a transação na origem ainda pode falhar ou sofrer *rollback*.

Após a confirmação:

- o AtlasCommerce permanece como a fonte operacional autoritativa;
- a alteração confirmada torna-se elegível para captura pelo CDC;
- a plataforma analítica pode iniciar o processamento assíncrono *downstream*;
- uma falha *downstream* não invalida a transação confirmada na origem.

O *timestamp* associado à alteração confirmada na origem fornece a referência temporal inicial para a medição da atualidade *end-to-end* e é representado arquiteturalmente como `source_commit_ts`.

### 3.2 SQL Server Native CDC

O **SQL Server Native CDC** captura alterações de dados confirmadas a partir do *transaction log* e disponibiliza as informações das alterações para consumo *downstream*.

O CDC é responsável pela captura, no lado da origem, das alterações relevantes sem exigir extrações completas recorrentes das tabelas ou *polling* no nível da aplicação como mecanismo principal de ingestão.

As informações da alteração capturada devem preservar contexto suficiente da origem para dar suporte à criação de eventos *downstream*, ordenação, rastreabilidade, reconciliação, análise de *replay* e medição de latência.

Dependendo da operação na origem, as alterações capturadas podem representar:

- linhas inseridas;
- linhas atualizadas;
- linhas excluídas.

A representação exata de uma operação pelo CDC é uma questão de implementação, mas o processamento *downstream* deve preservar o significado de negócio da alteração confirmada na origem.

### 3.3 Posição de Captura e Ordenação na Origem

O *transaction log* da origem fornece um registro ordenado das atividades confirmadas no banco de dados.

O CDC expõe informações de posição na origem que permitem ao processamento *downstream* identificar onde uma alteração capturada se originou dentro desse histórico ordenado.

Para a arquitetura V1, o **Log Sequence Number (LSN)** é tratado como um metadado técnico importante para rastreabilidade na origem e controle de processamento.

Os metadados de posição na origem podem ser utilizados para dar suporte a:

- identificação das alterações capturadas;
- ordenação relativa na origem;
- rastreabilidade até a alteração na origem;
- análise de reinicialização e recuperação;
- reconciliação;
- investigação de duplicidades;
- análise de latência.

Um LSN é um metadado técnico da origem e não deve ser interpretado como um identificador de negócio.

### 3.4 Limites de Transação

Uma única transação na origem pode afetar mais de uma linha e pode afetar mais de uma tabela.

O modelo de processamento de eventos *downstream* deve, portanto, distinguir entre:

- a identidade da transação na origem;
- a identidade de cada alteração capturada;
- a identidade do evento criado a partir dessa alteração;
- as chaves de negócio contidas nos dados afetados.

Esses identificadores possuem finalidades diferentes e não devem ser tratados como intercambiáveis.

Quando os metadados da transação estiverem disponíveis e forem necessários para processamento ou rastreabilidade, eles devem ser preservados para que a análise *downstream* possa relacionar alterações individuais à transação de origem que as produziu.

A arquitetura orientada a eventos não implica que uma transação de negócio inteira envolvendo múltiplas linhas deva sempre ser representada como um único evento Kafka. A granularidade do evento é determinada pelo contrato de evento aplicável e pelos requisitos de processamento.

### 3.5 Escopo da Captura

O CDC deve ser habilitado somente para estruturas da origem que sejam intencionalmente integradas à plataforma de Engenharia de Dados.

O escopo inicial de implementação é orientado pelo domínio **Sales** e pelas estruturas da origem necessárias para produzir o produto analítico **Daily Sales**.

À medida que domínios adicionais forem incorporados, o escopo do CDC deve ser expandido por meio da incorporação controlada de novas estruturas, em vez de capturar automaticamente todas as tabelas do AtlasCommerce.

Para cada nova estrutura da origem capturada, a plataforma deve avaliar:

- requisito analítico;
- volume esperado de alterações;
- chaves da origem;
- semântica das operações;
- requisitos de ordenação;
- sensibilidade dos dados;
- requisitos do contrato de eventos;
- requisitos de reconciliação;
- implicações de retenção e recuperação.

Esse escopo controlado reduz a movimentação desnecessária de dados e impede que a camada de ingestão se torne uma cópia indiscriminada do banco de dados operacional.

### 3.6 Latência de Captura

O tempo entre a confirmação na origem e a disponibilidade *downstream* da alteração capturada contribui para o objetivo de atualidade *end-to-end*.

A latência de captura deve, portanto, ser observável independentemente das etapas posteriores de processamento.

Conceitualmente:

**Latência de Captura do CDC = cdc_capture_ts - source_commit_ts**

Essa medição ajuda a distinguir o atraso de captura no lado da origem dos atrasos de transporte, persistência, transformação, certificação e publicação.

O *timestamp* exato utilizado para representar `cdc_capture_ts` deve ser definido de forma consistente durante a implementação, para que as medições permaneçam comparáveis e reproduzíveis.

### 3.7 Considerações sobre Falha e Recuperação

A indisponibilidade temporária *downstream* não deve exigir que transações já confirmadas na origem sejam repetidas.

Se o Debezium ou outro componente *downstream* estiver temporariamente impossibilitado de consumir as alterações capturadas, a arquitetura deve preservar uma posição recuperável a partir da qual o processamento possa ser retomado sem ignorar silenciosamente alterações elegíveis na origem.

O comportamento de recuperação deve considerar:

- a última posição da origem processada com segurança;
- a disponibilidade do histórico necessário do CDC;
- entrega duplicada após a reinicialização;
- implicações de ordenação;
- limites de retenção;
- lacunas ou descontinuidades observáveis.

Se o histórico necessário do CDC não estiver mais disponível, a recuperação incremental normal pode deixar de ser possível. Nessa situação, a recuperação deve seguir um procedimento explícito de *rebuild* ou *backfill*, em vez de continuar silenciosamente a partir de um histórico incompleto da origem.

### 3.8 Garantias da Captura de Alterações

No limite de captura da origem, a arquitetura exige as seguintes garantias:

- somente alterações confirmadas entram no caminho analítico *downstream*;
- a transação operacional não depende de forma síncrona do processamento *downstream*;
- os metadados de posição na origem são preservados quando necessários para rastreabilidade e recuperação;
- as alterações capturadas permanecem atribuíveis à sua origem operacional;
- falhas temporárias *downstream* devem ser recuperáveis enquanto o histórico necessário do CDC permanecer disponível;
- a ausência de histórico da origem deve ser detectada, em vez de silenciosamente ignorada;
- o comportamento da captura deve ser observável e mensurável.

Essas garantias estabelecem a base sobre a qual são construídas a criação de eventos e a semântica de entrega *downstream*.

---

## 4. Criação de Eventos e Metadados Técnicos

Depois que uma alteração confirmada na origem se torna disponível por meio do **SQL Server Native CDC**, o **Debezium** converte a alteração capturada em uma representação de evento adequada para transporte assíncrono por meio do **Apache Kafka**.

O evento deve preservar as informações de negócio necessárias ao processamento *downstream* e, ao mesmo tempo, transportar metadados técnicos suficientes para dar suporte à identidade, rastreabilidade, ordenação, interpretação de *schema*, idempotência, reconciliação, observabilidade, *replay* e recuperação.

Os dados de negócio e os metadados técnicos atendem a finalidades diferentes e devem permanecer distinguíveis ao longo de todo o caminho de processamento.

As garantias introduzidas nesta seção estabelecem o modelo comum de processamento da plataforma e são ampliadas nas seções subsequentes de acordo com o limite arquitetural no qual cada garantia se aplica.

### 4.1 Representação do Evento

Um evento representa uma alteração capturada na origem disponibilizada aos consumidores *downstream*.

A representação do evento deve fornecer informações suficientes para que um consumidor autorizado compreenda:

- qual estrutura da origem produziu a alteração;
- qual tipo de operação ocorreu;
- quais dados da origem foram afetados;
- quando a alteração na origem foi confirmada;
- onde a alteração se originou no histórico de alterações da origem;
- qual contrato de evento se aplica;
- como o evento pode ser identificado de forma única e rastreado.

O formato exato de serialização e a estrutura física da mensagem são questões de implementação, mas devem preservar as garantias arquiteturais definidas neste documento.

### 4.2 *Payload* de Negócio

O *payload* de negócio contém as informações da origem necessárias para o processamento analítico *downstream*.

Seu conteúdo é determinado pelo contrato de evento correspondente e pode variar de acordo com:

- entidade da origem;
- tipo de operação;
- requisito analítico;
- *schema* da origem;
- sensibilidade dos dados;
- requisitos de processamento *downstream*.

O *payload* não deve ser expandido indiscriminadamente simplesmente porque colunas adicionais estão disponíveis na origem.

Somente as informações exigidas pelos requisitos aplicáveis de integração e análise devem ser propagadas, especialmente quando dados pessoais ou sensíveis estiverem envolvidos.

### 4.3 Metadados Técnicos

Os eventos devem preservar os metadados técnicos necessários para operar e validar o caminho de processamento *downstream*.

O modelo inicial de metadados inclui, conforme aplicável:

- `event_id`;
- `source_commit_ts`;
- LSN da origem ou metadado equivalente de posição na origem;
- banco de dados da origem;
- *schema* da origem;
- tabela da origem;
- tipo de operação;
- versão do *schema* ou contrato do evento;
- *timestamp* de criação ou ingestão do evento;
- metadados da transação, quando disponíveis e necessários;
- identificador de *trace* ou correlação, quando aplicável.

Metadados adicionais podem ser introduzidos quando evidências de implementação demonstrarem a necessidade de maior rastreabilidade, recuperação, observabilidade ou controle de processamento.

Os metadados técnicos devem permanecer interpretáveis independentemente do *payload* de negócio.

### 4.4 Identidade do Evento

Cada evento deve possuir uma identidade estável que permita ao processamento *downstream* distinguir um evento de outro e reconhecer a entrega repetida do mesmo evento lógico.

A representação arquitetural dessa identidade é `event_id`.

`event_id` é um identificador técnico de processamento e não deve ser confundido com:

- uma chave primária da origem;
- um identificador de transação de negócio;
- um *offset* do Kafka;
- um LSN da origem;
- um identificador de *trace* ou correlação.

Esses valores podem participar da rastreabilidade ou dos controles de processamento, mas representam conceitos diferentes.

O mecanismo exato utilizado para derivar ou atribuir `event_id` deve ser determinístico ou, de outra forma, preservar uma identidade estável durante novas tentativas de entrega quando o reconhecimento de duplicidades for necessário.

### 4.5 Semântica das Operações

O evento deve identificar a operação na origem representada pela alteração capturada.

No mínimo, o modelo de processamento deve distinguir a semântica aplicável de:

- inserção;
- atualização;
- exclusão.

Quando a representação do CDC expuser valores anteriores e posteriores à alteração, os contratos *downstream* devem definir quais representações serão propagadas e como os consumidores deverão interpretá-las.

Um evento de exclusão não deve se tornar indistinguível de dados ausentes, e uma atualização deve preservar contexto suficiente para que o processamento *downstream* determine o estado analítico resultante.

A semântica das operações deve permanecer explícita ao longo das etapas que dela necessitem para reconstrução, desduplicação, reconciliação ou processamento dimensional.

### 4.6 Posição na Origem e Identidade do Evento

A posição na origem e a identidade do evento fornecem garantias complementares.

O LSN da origem identifica onde uma alteração capturada se originou no histórico ordenado de alterações da origem.

`event_id` identifica a representação do evento utilizada pelo processamento *downstream*.

Conceitualmente:

**Posição na Origem → Onde a alteração se originou?**

**Identidade do Evento → Qual evento estou processando?**

Nenhum deles deve ser tratado como substituto do outro.

Preservar ambos permite que os sistemas *downstream* investiguem entregas duplicadas, comportamento de ordenação, *replay*, recuperação e linhagem sem depender de um único identificador sobrecarregado de significados.

### 4.7 Referência de *Schema* e Contrato

Cada evento deve ser interpretável de acordo com um contrato de evento explícito.

A representação do evento deve, portanto, fornecer, diretamente ou por meio do mecanismo de serialização aplicável, informações suficientes para identificar a versão do *schema* ou contrato necessária para interpretar corretamente o evento.

O **Apicurio Registry** governa os *schemas* de eventos registrados e suas políticas de compatibilidade.

A governança de *schemas* aplica-se à evolução dos contratos de eventos e não exige que cada evento consulte de forma síncrona o *registry* durante o transporte.

Os consumidores devem ser capazes de determinar qual contrato se aplica a um evento e não devem interpretar silenciosamente um evento incompatível utilizando suposições de outra versão do *schema*.

### 4.8 Tempo do Evento e Tempo de Processamento

A arquitetura distingue entre o tempo associado à alteração na origem e os *timestamps* introduzidos à medida que o evento percorre a plataforma.

Exemplos incluem:

- `source_commit_ts` — quando a alteração operacional foi confirmada;
- *timestamp* de criação do evento — quando a representação do evento foi produzida;
- *timestamp* de disponibilidade no Kafka — quando o evento se tornou disponível para consumo;
- *timestamp* de persistência na Bronze — quando o evento foi persistido de forma durável na Bronze;
- *timestamps* de processamento *downstream* — quando ocorreram as transformações posteriores;
- `certified_gold_publish_ts` — quando os dados analíticos resultantes se tornaram disponíveis por meio da Certified Gold.

Esses *timestamps* atendem a finalidades diferentes e não devem ser tratados como intercambiáveis.

`source_commit_ts` permanece como a principal referência inicial para a atualidade analítica *end-to-end*.

Os *timestamps* de processamento permitem que a plataforma decomponha essa latência e identifique onde o tempo é consumido ao longo do *pipeline*.

### 4.9 Correlação e Rastreabilidade

Uma única operação de negócio pode gerar múltiplas alterações capturadas e múltiplos eventos *downstream*.

Quando a correlação entre eventos for necessária, a plataforma pode preservar metadados de transação, correlação ou *trace* que permitam que eventos relacionados sejam investigados em conjunto.

A correlação não substitui a identidade do evento.

Por exemplo:

**uma transação na origem → múltiplas alterações capturadas → múltiplas identidades de eventos → contexto compartilhado de transação ou correlação**

Essa distinção permite que a plataforma rastreie tanto unidades individuais de processamento quanto sua relação com uma ação operacional mais ampla.

### 4.10 Dados Sensíveis em Eventos

A criação de eventos deve respeitar os princípios de minimização de dados e segurança da plataforma.

Informações sensíveis não devem ser propagadas apenas porque existem na estrutura da origem.

Para cada contrato de evento, o *payload* necessário deve ser avaliado de acordo com:

- necessidade analítica;
- propósito de negócio;
- classificação de sensibilidade;
- requisitos de acesso *downstream*;
- implicações de retenção;
- requisitos de privacidade aplicáveis.

Quando apropriado, campos sensíveis podem ser excluídos, mascarados, transformados por *hash*, tokenizados ou protegidos de outra forma, de acordo com os controles de segurança e governança aplicáveis.

Os metadados técnicos também devem ser revisados quanto à exposição não intencional de informações sensíveis.

### 4.11 Garantias da Criação de Eventos

No limite de criação de eventos, a arquitetura exige as seguintes garantias:

- somente alterações confirmadas na origem e capturadas são representadas como eventos *downstream* normais;
- cada evento permanece atribuível à sua origem;
- a identidade do evento é estável o suficiente para dar suporte ao comportamento necessário de reconhecimento de duplicidades;
- a semântica das operações permanece explícita;
- as informações do contrato aplicável permanecem identificáveis;
- os metadados de posição na origem são preservados quando necessários;
- o *payload* de negócio e os metadados técnicos permanecem distinguíveis;
- os *timestamps* necessários permitem a decomposição da latência *end-to-end*;
- dados sensíveis são propagados somente de acordo com requisitos definidos;
- a criação de eventos permanece observável e rastreável.

Essas garantias estabelecem a representação de evento que o Kafka transporta e que os consumidores *downstream* processam.

---

## 5. Governança de *Schema* e Contratos

A integração orientada a eventos exige que produtores e consumidores compartilhem um entendimento explícito da estrutura e da semântica dos eventos trocados entre eles.

Dentro da plataforma Atlas Engineering, esse entendimento compartilhado é representado por meio de **contratos de eventos** versionados e governados pelo **Apicurio Registry**.

Um contrato de evento define a estrutura necessária para interpretar um evento e estabelece a interface controlada entre a produção de eventos e o consumo *downstream*.

A governança de contratos existe para permitir que as estruturas dos eventos evoluam de forma deliberada, impedindo que alterações incompatíveis se propaguem silenciosamente pela plataforma.

### 5.1 Contrato de Evento

Um contrato de evento define a representação esperada de um evento para um contexto específico de integração.

Dependendo da tecnologia de serialização e *schema* selecionada durante a implementação, o contrato pode definir características como:

- nomes dos campos;
- tipos de dados dos campos;
- campos obrigatórios e opcionais;
- estruturas aninhadas;
- tipos lógicos;
- valores padrão, quando aplicável;
- evolução estrutural permitida;
- versão do contrato.

O contrato descreve a interface do evento e deve permanecer distinto da definição física da tabela do banco de dados de origem.

Uma tabela da origem pode conter informações que são intencionalmente excluídas de um contrato de evento, e um contrato de evento pode incluir metadados técnicos que não existem como uma coluna de negócio na tabela da origem.

### 5.2 Responsabilidades de Produtores e Consumidores

O produtor é responsável por criar eventos que estejam em conformidade com o contrato de evento aplicável.

Os consumidores são responsáveis por interpretar os eventos de acordo com a versão do contrato associada a esses eventos.

Nenhum dos lados deve depender de suposições estruturais não documentadas.

Um consumidor não deve presumir que:

- os campos permanecerão sempre inalterados, a menos que o contrato garanta isso;
- todas as colunas da origem estejam presentes no evento;
- a ordem dos campos tenha significado de negócio, a menos que isso seja explicitamente definido;
- um campo recém-introduzido seja automaticamente significativo para todos os consumidores;
- um campo opcional ausente represente a mesma condição que um valor explicitamente preenchido.

O contrato estabelece, portanto, um limite controlado entre a produção e o consumo de eventos.

### 5.3 Registro de *Schemas*

Os *schemas* de eventos são registrados e versionados por meio do **Apicurio Registry**.

O *registry* fornece a referência governada para as versões de *schema* associadas aos contratos de eventos e permite que políticas de compatibilidade sejam aplicadas à medida que esses contratos evoluem.

O registro de *schemas* é um controle sobre a definição e a evolução dos contratos.

Ele não deve ser interpretado como uma exigência de que cada evento individual consulte de forma síncrona ou passe fisicamente pelo *registry* durante o transporte pelo Kafka.

O mecanismo de serialização utilizado durante a implementação deve permitir que os consumidores identifiquem a versão aplicável do *schema* ou contrato necessária para interpretar corretamente um evento.

### 5.4 Evolução de Contratos

Espera-se que os contratos de eventos evoluam à medida que os sistemas de origem, os requisitos analíticos e as capacidades da plataforma mudem.

A evolução deve ser controlada.

Exemplos de possíveis evoluções de contrato incluem:

- adicionar um novo campo opcional;
- adicionar um campo com um valor padrão aplicável;
- alterar se um campo é obrigatório;
- alterar o tipo de dados de um campo;
- renomear um campo;
- remover um campo;
- alterar uma estrutura aninhada;
- alterar o significado semântico de um campo existente.

Nem todas as alterações estruturais possuem o mesmo impacto.

Uma alteração que pareça tecnicamente pequena ainda pode ser semanticamente incompatível se os consumidores interpretarem o campo afetado de maneira diferente após a alteração.

A evolução dos contratos deve, portanto, considerar tanto a **compatibilidade estrutural** quanto a **compatibilidade semântica**.

### 5.5 Política de Compatibilidade

As políticas de compatibilidade definem quais alterações de *schema* podem ser aceitas sem exigir uma migração explícita para uma versão incompatível.

O modo exato de compatibilidade utilizado para cada contrato é uma decisão de implementação que deve ser documentada e validada em relação à tecnologia de serialização e *schema* selecionada.

A política deve proteger os consumidores existentes contra evoluções incompatíveis, permitindo ao mesmo tempo que alterações seguras prossigam sem interrupções desnecessárias.

Uma alteração de *schema* aceita por uma verificação de compatibilidade do *registry* não comprova automaticamente que o significado de negócio do evento permanece compatível.

Tanto a compatibilidade técnica quanto a compatibilidade semântica devem ser consideradas.

### 5.6 Alterações Compatíveis

Uma alteração compatível é aquela que pode ser introduzida de acordo com a política de contrato aplicável sem invalidar a interação suportada entre produtores e consumidores.

Uma evolução compatível pode permitir que diferentes versões de contrato coexistam durante uma transição controlada.

Mesmo quando uma alteração for tecnicamente compatível, a plataforma deve avaliar se:

- os consumidores existentes podem ignorar com segurança novas informações;
- o significado analítico necessário permanece inalterado;
- valores padrão ou ausentes são interpretados de forma consistente;
- as transformações *downstream* permanecem válidas;
- as regras de qualidade e reconciliação permanecem corretas;
- os metadados e a linhagem permanecem precisos.

A compatibilidade, portanto, protege o comportamento da integração, e não apenas a sintaxe do *schema*.

### 5.7 Alterações Incompatíveis

Uma alteração incompatível modifica o contrato de uma forma que não permite preservar com segurança a interação suportada entre produtor e consumidor sob as expectativas de compatibilidade existentes.

Exemplos podem incluir:

- remover um campo exigido pelos consumidores existentes;
- introduzir um tipo de dados incompatível;
- alterar o significado de um campo existente;
- reestruturar os dados de uma forma não suportada pelos consumidores existentes;
- alterar de forma incompatível o comportamento obrigatório/opcional.

Alterações incompatíveis exigem uma estratégia explícita de migração.

Dependendo do impacto, a estratégia pode incluir:

- uma nova versão do contrato;
- transição do produtor;
- transição dos consumidores;
- coexistência temporária entre versões;
- alterações nas transformações;
- requisitos de *replay* ou *rebuild*;
- critérios de validação;
- procedimentos de *rollback*;
- período de descontinuação;
- critérios de remoção.

Alterações incompatíveis não devem ser introduzidas silenciosamente sob a suposição de que os consumidores *downstream* se adaptarão automaticamente.

### 5.8 Identificação da Versão do Contrato

O processamento *downstream* deve ser capaz de determinar qual contrato se aplica a um evento.

A identificação da versão do contrato deve permanecer suficientemente estável para dar suporte a:

- desserialização correta;
- processamento de acordo com a estrutura aplicável;
- interpretação histórica;
- *replay*;
- *debugging*;
- linhagem;
- migração entre versões.

Eventos históricos devem permanecer interpretáveis de acordo com o contrato que se aplicava quando foram produzidos, mesmo após a introdução de versões mais recentes do contrato.

Esse requisito é especialmente importante para o *replay* da Bronze, pois dados históricos imutáveis podem conter eventos produzidos sob múltiplas versões de contrato.

### 5.9 Evolução de Contratos e Histórico da Bronze

A Bronze preserva representações históricas dos eventos.

À medida que os contratos evoluem, a Bronze pode, portanto, conter múltiplas versões de *schema* para a mesma família lógica de eventos.

O processamento *downstream* não deve presumir que todos os registros históricos da Bronze estejam em conformidade com a versão mais recente do contrato.

O processamento da Silver deve tratar explicitamente as versões históricas suportadas necessárias para reconstrução ou *replay*.

Quando uma versão mais antiga não for mais suportada diretamente, deve existir um caminho explícito de migração ou normalização antes que o histórico afetado possa participar com segurança da reconstrução *downstream*.

A evolução dos contratos não deve tornar os dados históricos preservados silenciosamente ininterpretáveis.

### 5.10 Validação e Testes de Contratos

As alterações de contratos devem ser validadas antes de serem introduzidas no caminho normal de processamento governado.

A validação deve incluir, conforme aplicável:

- validação de compatibilidade pelo *registry*;
- testes de serialização do produtor;
- testes de desserialização dos consumidores;
- testes das versões suportadas;
- testes de transformação;
- validação das regras de qualidade;
- validação da reconciliação;
- validação de *replay*;
- testes de migração para alterações incompatíveis.

Os testes devem verificar o comportamento que se espera que o contrato preserve, em vez de depender apenas do registro bem-sucedido do *schema*.

As evidências dos testes de evolução de contratos devem ser preservadas quando a alteração afetar garantias críticas de processamento ou produtos analíticos certificados.

### 5.11 Responsabilidade e Documentação dos Contratos

Cada contrato de evento governado deve possuir uma responsabilidade identificável.

A documentação do contrato deve incluir, conforme aplicável:

- propósito do contrato;
- produtor;
- consumidores;
- origem;
- localização do *schema* ou referência no *registry*;
- política de compatibilidade;
- versões suportadas;
- considerações de sensibilidade;
- estado do ciclo de vida;
- transformações relacionadas;
- informações de descontinuação.

A responsabilidade garante que a evolução do contrato tenha um ponto de decisão responsável, em vez de ocorrer implicitamente por meio de alterações no *schema* da origem.

Uma alteração no *schema* de origem do AtlasCommerce não autoriza automaticamente uma alteração incompatível correspondente em um contrato de evento.

### 5.12 Ciclo de Vida dos Contratos

Os contratos de eventos devem seguir um ciclo de vida controlado.

O ciclo de vida inicial é:

**Rascunho → Ativo → Descontinuado → Removido**

**Rascunho**  
O contrato está sendo projetado ou alterado e ainda não está autorizado para o processamento governado normal.

**Ativo**  
A versão do contrato é suportada para produção e consumo normais de eventos.

**Descontinuado**  
O contrato permanece temporariamente suportado, mas está programado para substituição ou retirada.

**Removido**  
A versão do contrato não é mais suportada para processamento normal.

A remoção deve considerar os requisitos de *replay* histórico e reconstrução antes que o suporte a uma versão mais antiga do contrato seja eliminado.

### 5.13 Garantias de Governança de *Schema* e Contratos

No limite de governança de contratos, a arquitetura exige as seguintes garantias:

- os eventos são interpretados por meio de contratos explícitos e versionados;
- a evolução de *schemas* é governada, em vez de introduzida silenciosamente;
- compatibilidade técnica e compatibilidade semântica são tratadas como preocupações distintas;
- alterações incompatíveis exigem migração explícita;
- os consumidores podem identificar o contrato aplicável a um evento;
- eventos históricos permanecem interpretáveis durante o período necessário de *replay* e retenção;
- alterações de contratos são validadas para além da simples aceitação pelo *registry*;
- a responsabilidade e o ciclo de vida dos contratos permanecem documentados;
- a evolução do *schema* da origem não redefine automaticamente os contratos de eventos *downstream*.

Essas garantias permitem que o caminho de integração orientado a eventos evolua sem sacrificar a compatibilidade controlada entre produtores e consumidores.

---

## 6. Transporte, Particionamento e Ordenação no Kafka

O **Apache Kafka** fornece a camada de transporte de eventos entre a captura de alterações na origem e os consumidores *downstream* de Engenharia de Dados.

Suas principais responsabilidades são transportar eventos de forma assíncrona, absorver diferenças temporárias entre as taxas de produção e consumo, reter eventos por um período controlado, preservar a ordenação dentro de limites definidos e fornecer posições a partir das quais os consumidores possam retomar o processamento.

O Kafka não é o sistema histórico permanente de registro da plataforma analítica. Sua retenção oferece suporte ao transporte, à recuperação operacional e ao *replay* controlado, enquanto a **Bronze** fornece a base histórica durável e imutável para reconstrução *downstream*.

### 6.1 *Topics*

Os eventos são publicados em *topics* do Kafka de acordo com os limites de integração e domínio definidos pela plataforma.

Um *topic* representa um fluxo lógico de eventos e deve possuir propósito claro, responsabilidade, contrato de evento aplicável, expectativa de retenção e contexto de consumo.

O design dos *topics* deve evitar ambos os extremos:

- criar *topics* desnecessariamente fragmentados sem justificativa arquitetural;
- combinar famílias de eventos não relacionadas em um único fluxo apenas para reduzir a quantidade de *topics*.

A estratégia inicial de *topics* deve ser orientada pela implementação do domínio **Sales** e refinada a partir do comportamento de processamento medido antes da incorporação de domínios adicionais.

As convenções de nomenclatura de *topics* e suas definições concretas são padrões de implementação e são documentadas separadamente.

### 6.2 Partições

Um *topic* do Kafka é dividido em uma ou mais partições.

As partições fornecem a principal unidade de ordenação e consumo paralelo dentro de um *topic*.

Os eventos atribuídos à mesma partição são mantidos em uma sequência ordenada, enquanto eventos atribuídos a partições diferentes podem ser processados de forma independente e concorrente.

O particionamento, portanto, afeta tanto:

- a escalabilidade do processamento;
- as garantias de ordenação.

Aumentar a quantidade de partições pode aumentar o paralelismo disponível para os consumidores, mas também cria limites adicionais e independentes de ordenação.

A quantidade de partições deve, portanto, ser tratada como uma decisão arquitetural e operacional de dimensionamento, e não como um valor arbitrário de configuração.

### 6.3 Chave de Particionamento

Quando eventos relacionados exigirem processamento ordenado, a estratégia de particionamento deve utilizar uma chave estável que faça com que esses eventos sejam atribuídos consistentemente à mesma partição.

A chave de particionamento apropriada depende do requisito de ordenação da família de eventos correspondente.

As chaves possíveis podem incluir, dependendo do domínio e do contrato:

- identificador da entidade de negócio;
- identificador da transação;
- identificador do agregado;
- outra chave estável de processamento.

A chave selecionada deve preservar o limite de ordenação efetivamente exigido pelo processamento *downstream*.

Uma chave não deve ser selecionada apenas porque fornece uma distribuição uniforme se isso comprometer a ordenação necessária dos eventos.

Por outro lado, uma chave que concentre tráfego excessivo em um pequeno número de partições pode preservar a ordenação, mas limitar a escalabilidade.

A seleção da chave de particionamento exige, portanto, um equilíbrio explícito entre **correção da ordenação** e **paralelismo de processamento**.

### 6.4 Garantias de Ordenação

A ordenação do Kafka é garantida dentro de uma partição, e não globalmente entre todas as partições de um *topic*.

Conceitualmente:

**Mesma Partição → Sequência Ordenada**

**Partições Diferentes → Sem Garantia de Ordem Global de Processamento**

A arquitetura deve, portanto, evitar suposições que exijam uma ordenação total de eventos não relacionados, a menos que essa ordenação seja explicitamente projetada e justificada.

Se dois eventos precisarem ser processados na ordem relativa da origem, a estratégia de particionamento e o modelo de eventos devem preservar a relação necessária.

Quando a ordenação global não for necessária, deve ser permitido que partições independentes avancem de forma concorrente.

O processamento *downstream* não deve reconstruir uma ordem global artificial a partir de *offsets* do Kafka pertencentes a partições diferentes.

### 6.5 *Offset* do Kafka

Dentro de cada partição, o Kafka atribui um *offset* que identifica a posição de um registro naquela partição.

Um *offset* é uma posição de transporte do Kafka.

Ele não deve ser confundido com:

- `event_id`;
- chave primária da origem;
- identificador da transação de negócio;
- LSN da origem;
- versão do contrato de evento;
- identificador de *trace* ou correlação.

Conceitualmente:

**LSN da Origem → posição no histórico de alterações da origem**

**event_id → identidade do evento *downstream***

**partição + offset do Kafka → posição do evento dentro de uma partição do Kafka**

Os *offsets* do Kafka possuem significado dentro de suas respectivas partições e não devem ser interpretados como identificadores globalmente ordenados entre partições.

### 6.6 Grupos de Consumidores

Os grupos de consumidores do Kafka permitem que o trabalho de processamento seja distribuído entre múltiplas instâncias de consumidores.

Dentro de um grupo de consumidores, uma partição é processada por, no máximo, uma instância ativa de consumidor por vez naquele grupo.

Isso permite que os consumidores escalem horizontalmente, preservando a ordenação no nível da partição.

O paralelismo efetivo de processamento de um grupo de consumidores é, portanto, limitado pela quantidade de partições disponíveis para esse grupo.

Adicionar instâncias de consumidores além da quantidade de partições disponíveis não cria paralelismo adicional de processamento das partições.

O design dos grupos de consumidores deve refletir:

- volume da carga de trabalho;
- limites de ordenação necessários;
- concorrência esperada de processamento;
- comportamento de falha e rebalanceamento;
- objetivos de recuperação;
- disponibilidade de recursos.

### 6.7 Semântica de Entrega

A arquitetura V1 utiliza entrega **at-least-once**.

Nesse modelo, um evento que ainda não tenha sido reconhecido com segurança como processado pode ser entregue novamente.

A entrega duplicada é, portanto, uma condição esperada de processamento, e não uma violação arquitetural excepcional.

A plataforma não deve depender de o Kafka entregar cada evento lógico exatamente uma vez para alcançar resultados analíticos corretos.

A correção é obtida pela combinação de:

- identidade estável do evento;
- gerenciamento controlado de *offsets*;
- processamento *downstream* idempotente;
- desduplicação quando necessária;
- controles de reconciliação e qualidade.

A relação detalhada entre persistência e confirmação de *offsets* é definida na seção de processamento da Bronze deste documento.

### 6.8 Gerenciamento de *Offsets*

Os *offsets* dos consumidores representam o progresso de um grupo de consumidores em cada partição do Kafka.

Um *offset* deve avançar somente quando a etapa de processamento protegida por essa confirmação tiver sido concluída de acordo com suas garantias de durabilidade exigidas.

Para o consumidor inicial da Bronze, a regra arquitetural é:

**Persistir com Sucesso na Bronze → Validar a Persistência → Confirmar o Offset do Kafka**

O *offset* não deve ser confirmado apenas porque o evento foi recebido ou porque a transformação foi iniciada.

Se o processamento falhar antes que o *offset* seja confirmado com segurança, o Kafka poderá entregar o evento novamente após a recuperação.

Esse comportamento é intencional e é uma das razões pelas quais o processamento *downstream* deve ser idempotente.

### 6.9 Retenção

O Kafka retém eventos de acordo com políticas de retenção configuradas.

A retenção fornece uma janela limitada para:

- *buffering* temporário;
- recuperação dos consumidores;
- *replay* operacional;
- investigação;
- reprocessamento controlado.

A retenção do Kafka não deve ser tratada como substituta da retenção histórica da Bronze.

O período de retenção necessário no Kafka deve ser determinado a partir de fatores medidos e documentados, como:

- carga de trabalho esperada;
- indisponibilidade máxima tolerada do consumidor;
- tempo de recuperação;
- requisitos de *replay*;
- armazenamento disponível;
- risco operacional;
- estratégia de recuperação *downstream*.

Os valores de retenção devem ser validados por meio de implementação e testes de falha, em vez de serem selecionados apenas a partir de valores padrão arbitrários.

### 6.10 *Backlog* e *Lag* do Consumidor

Quando os eventos são produzidos mais rapidamente do que são consumidos, ou quando os consumidores estão indisponíveis, eventos não processados se acumulam.

Esse acúmulo forma um *backlog* de processamento.

O *lag* dos consumidores do Kafka fornece uma medida importante de quanto um grupo de consumidores está atrasado em relação à posição mais recente disponível em cada partição.

No entanto, somente a quantidade de eventos não descreve completamente o impacto operacional do *backlog*.

A plataforma também deve observar a idade do trabalho pendente, particularmente o **evento pendente mais antigo**, pois um *backlog* relativamente pequeno ainda pode representar um atraso inaceitável de atualidade.

Conceitualmente:

**Tamanho do Backlog → Quanto trabalho está aguardando?**

**Evento Pendente Mais Antigo → Qual a idade do trabalho que ainda está aguardando?**

Ambas as medições contribuem para a compreensão da atualidade analítica e do comportamento de recuperação.

### 6.11 Recuperação de *Backlog*

Após uma interrupção, um consumidor recuperado pode precisar processar tanto:

- o *backlog* acumulado;
- novos eventos que continuam chegando.

Para que o *backlog* diminua, o *throughput* sustentado de processamento deve exceder a taxa de entrada de eventos.

Conceitualmente:

**Capacidade de Recuperação = Taxa de Processamento - Taxa de Entrada**

Se:

**Taxa de Processamento ≤ Taxa de Entrada**

o consumidor pode estar operacional, mas o *backlog* não diminuirá.

A validação da recuperação deve, portanto, medir não apenas se o consumo foi retomado, mas também se a plataforma consegue retornar ao seu objetivo normal de atualidade dentro de condições aceitáveis.

Os testes de recuperação de *backlog* devem medir, conforme aplicável:

- *backlog* acumulado durante a interrupção;
- evento pendente mais antigo;
- *throughput* de processamento após a recuperação;
- taxa de entrada de eventos;
- taxa de redução do *backlog*;
- tempo necessário para retornar à latência normal;
- utilização de recursos durante o *catch-up*.

### 6.12 Rebalanceamento

Alterações na composição de um grupo de consumidores podem fazer com que o Kafka redistribua a responsabilidade pelas partições entre as instâncias de consumidores.

Esse processo é conhecido como rebalanceamento.

O rebalanceamento pode ocorrer quando, por exemplo:

- um consumidor é iniciado;
- um consumidor é interrompido;
- um consumidor falha;
- a composição do grupo de consumidores muda;
- a disponibilidade ou atribuição das partições muda.

O processamento *downstream* deve tolerar o rebalanceamento sem assumir que uma instância de consumidor possui permanentemente uma partição específica.

O estado de processamento que afeta a correção não deve, portanto, depender exclusivamente da posse efêmera em memória de uma partição.

O comportamento de rebalanceamento deve ser considerado no gerenciamento de *offsets*, idempotência, novas tentativas e testes de falha.

### 6.13 Falha e Recuperação do Kafka

A indisponibilidade temporária do Kafka ou dos consumidores pode atrasar o processamento, mas não deve alterar silenciosamente o significado dos eventos já capturados.

A recuperação deve preservar a capacidade de determinar:

- quais partições foram afetadas;
- quais *offsets* foram confirmados com segurança;
- quais eventos podem ser entregues novamente;
- se os eventos necessários ainda permanecem dentro da retenção;
- se as garantias de ordenação permanecem preservadas;
- se houve acúmulo de *backlog*;
- se o SLO *end-to-end* foi afetado.

Se os eventos necessários não estiverem mais disponíveis dentro da retenção do Kafka, a recuperação deve utilizar a próxima fonte de recuperação apropriada definida pela arquitetura, em vez de ignorar silenciosamente o intervalo ausente.

O Kafka é, portanto, um mecanismo de recuperação dentro de uma hierarquia mais ampla:

**Kafka → Bronze → Silver → Backup**

### 6.14 Observabilidade do Kafka

A camada de transporte Kafka deve expor informações suficientes para observar tanto a saúde da infraestrutura quanto o comportamento do processamento.

A observabilidade inicial deve considerar, conforme aplicável:

- disponibilidade dos *brokers*;
- disponibilidade de *topics* e partições;
- erros dos produtores;
- erros dos consumidores;
- estado dos grupos de consumidores;
- *lag* do consumidor por partição;
- *backlog* total;
- evento pendente mais antigo;
- taxa de produção de eventos;
- taxa de consumo de eventos;
- *throughput* de processamento;
- atividade de rebalanceamento;
- risco relacionado à retenção;
- latência de transporte.

A saúde da infraestrutura e a saúde do fluxo de dados devem ser interpretadas em conjunto.

Um processo Kafka saudável não comprova que os consumidores estejam atualizados, e um *lag* reportado como zero, isoladamente, não comprova que os eventos esperados da origem estejam chegando.

### 6.15 Garantias do Transporte Kafka

No limite de transporte do Kafka, a arquitetura exige as seguintes garantias:

- os eventos são transportados de forma assíncrona entre produtores e consumidores;
- a ordenação é preservada dentro do limite de partição necessário;
- nenhuma suposição não suportada de ordenação global é introduzida entre partições;
- as posições de transporte permanecem identificáveis por meio da partição e do *offset*;
- a entrega *at-least-once* é tolerada pelo processamento *downstream*;
- os *offsets* avançam somente após a etapa de processamento protegida satisfazer seu requisito de durabilidade;
- *backlog* e *lag* permanecem observáveis;
- a retenção fornece uma janela controlada de recuperação;
- o rebalanceamento dos consumidores não compromete a correção do processamento;
- a ausência do histórico retido é detectada, em vez de silenciosamente ignorada;
- o Kafka permanece como uma camada de transporte e *replay* limitado, e não como a base histórica permanente.

Essas garantias estabelecem o comportamento de transporte do qual depende a persistência durável na Bronze.

---

## 7. Persistência na Bronze e Confirmação de *Offsets*

A **camada Bronze** é o primeiro limite de persistência histórica durável da plataforma de Engenharia de Dados.

Os eventos consumidos do **Apache Kafka** são persistidos na Bronze como registros históricos imutáveis utilizando **Parquet** com **compressão Snappy** no **MinIO**.

A persistência na Bronze deve preservar as informações do evento e os metadados técnicos necessários para reconstrução histórica, rastreabilidade, *replay*, reconciliação e processamento *downstream*.

A relação entre a persistência na Bronze e a confirmação dos *offsets* do Kafka é crítica para o modelo de processamento **at-least-once** da V1.

A regra fundamental de processamento é:

**Consumir Evento → Preparar Objeto da Bronze → Validar Persistência → Promover Atomicamente → Confirmar Offset do Kafka**

Um *offset* do Kafka não deve ser confirmado até que a persistência correspondente na Bronze tenha alcançado com sucesso o estado durável exigido pela arquitetura.

### 7.1 Limite de Persistência na Bronze

A Bronze representa o primeiro ponto *downstream* no qual um evento se torna preservado de forma durável fora da camada de transporte do Kafka.

O recebimento bem-sucedido de um evento por um consumidor não constitui persistência durável na Bronze.

Da mesma forma, iniciar a gravação de um arquivo ou criar um objeto temporário não significa que o evento tenha sido persistido com segurança.

Um evento é considerado persistido com sucesso na Bronze somente depois que:

- o conteúdo necessário do evento tiver sido gravado;
- os metadados técnicos necessários tiverem sido preservados;
- o objeto resultante tiver passado pela validação de persistência aplicável;
- o objeto tiver sido promovido ao seu estado final visível;
- o objeto final estiver disponível no local esperado da Bronze.

Somente depois que essas condições forem satisfeitas o *offset* protegido do Kafka poderá ser confirmado de acordo com a estratégia aplicável de gerenciamento de *offsets*.

### 7.2 Conteúdo do Registro na Bronze

A Bronze deve preservar uma representação suficientemente próxima do evento original para dar suporte à interpretação histórica e à reconstrução *downstream*.

A representação persistida deve incluir, conforme aplicável:

- *payload* de negócio;
- `event_id`;
- `source_commit_ts`;
- metadados de posição na origem, como LSN;
- banco de dados, *schema* e tabela da origem;
- tipo de operação;
- versão do contrato de evento ou *schema*;
- *timestamp* de criação ou ingestão do evento;
- *topic* do Kafka;
- partição do Kafka;
- *offset* do Kafka;
- *timestamp* de persistência na Bronze;
- metadados de transação, *trace* ou correlação, quando necessários.

A Bronze pode introduzir metadados técnicos de armazenamento necessários para operar a camada histórica, mas não deve redefinir silenciosamente o significado de negócio do evento original.

### 7.3 Persistência Histórica Imutável

A Bronze é *append-only* e preservada historicamente.

O processamento normal não deve sobrescrever destrutivamente um registro histórico existente apenas porque um evento mais recente para a mesma entidade de negócio chegou.

Por exemplo:

**INSERT entidade A → registro histórico 1 na Bronze**

**UPDATE entidade A → registro histórico 2 na Bronze**

**DELETE entidade A → registro histórico 3 na Bronze**

A sequência histórica permanece preservada.

Correções na lógica de processamento ou na interpretação *downstream* devem ser representadas por meio de reprocessamento controlado, novas versões derivadas ou procedimentos explícitos de remediação, e não pela reescrita silenciosa da representação histórica original do evento.

### 7.4 Gravação Temporária e Promoção Atômica

A persistência na Bronze deve impedir que objetos parcialmente gravados se tornem visíveis como dados finais válidos.

O padrão de persistência da V1 é:

**Objeto Temporário → Gravação → Validação → Promoção Atômica → Objeto Final**

O consumidor primeiro grava a saída em uma localização temporária ou, de outra forma, não final.

A gravação é então validada de acordo com os controles de persistência aplicáveis.

Somente após uma validação bem-sucedida o objeto é promovido à sua localização final na Bronze.

Se o processamento falhar antes da promoção final, o objeto temporário ou incompleto não deve ser interpretado pelo processamento *downstream* como dado da Bronze persistido com sucesso.

A operação exata do MinIO utilizada para implementar a promoção final deve ser validada durante a implementação, pois a semântica de armazenamento de objetos pode diferir da semântica tradicional de renomeação de sistemas de arquivos.

A arquitetura exige comportamento de publicação atômica; ela não presume uma operação específica de sistema de arquivos sem evidência de implementação.

### 7.5 Validação da Persistência

Antes da promoção final, o consumidor deve executar a validação necessária para estabelecer que o objeto da Bronze é utilizável de acordo com o contrato de persistência.

A validação pode incluir, conforme aplicável:

- criação bem-sucedida do objeto;
- formato de arquivo esperado;
- leitura bem-sucedida do Parquet;
- presença dos *schemas* ou metadados necessários;
- quantidade esperada de registros;
- identidade esperada do evento;
- ausência de saída incompleta;
- verificações de plausibilidade do tamanho do objeto;
- validação de *checksum* ou integridade, quando implementada.

O conjunto exato de validações pode evoluir com base em evidências de implementação, mas deve ser suficiente para impedir que um objeto incompleto ou inválido seja reconhecido como persistido com sucesso.

### 7.6 Confirmação do *Offset* do Kafka

A confirmação do *offset* do Kafka representa a declaração do grupo de consumidores de que o trabalho de processamento protegido avançou além de uma posição específica no Kafka.

Para o consumidor inicial da Bronze, a ordenação arquitetural é:

**Durabilidade na Bronze Primeiro → Confirmação do Offset do Kafka Depois**

O *offset* não deve ser confirmado:

- imediatamente após o recebimento do evento;
- apenas após a desserialização;
- quando a gravação na Bronze começar;
- enquanto existir somente um objeto temporário;
- antes que a validação da persistência seja bem-sucedida;
- antes que a promoção final na Bronze seja bem-sucedida.

Essa ordenação reduz o risco de reconhecer um evento que ainda não tenha sido preservado de forma durável.

### 7.7 Falha Antes da Persistência na Bronze

Se o processamento falhar antes que o evento tenha sido persistido com sucesso na Bronze e antes que seu *offset* do Kafka tenha sido confirmado, o evento permanece elegível para reentrega.

Conceitualmente:

**Consumir → Falha → Sem Persistência na Bronze → Sem Confirmação do Offset → Reentrega**

Após a recuperação, o consumidor processa o evento novamente.

Esse é o comportamento esperado sob o modelo *at-least-once*.

A falha deve permanecer observável, e falhas repetidas não devem resultar em eventos silenciosamente ignorados.

### 7.8 Falha Durante a Gravação Temporária

Se o consumidor falhar durante a gravação do objeto temporário da Bronze, o objeto temporário incompleto não deve se tornar visível como dado final válido da Bronze.

Após a recuperação:

- o Kafka pode reenviar o evento;
- artefatos temporários incompletos devem ser detectados ou isolados com segurança;
- o evento pode ser processado novamente;
- a promoção final ocorre somente após uma gravação completa e válida.

A limpeza de objetos temporários deve ser controlada operacionalmente para que artefatos abandonados não se acumulem indefinidamente nem sejam confundidos com objetos finais válidos.

### 7.9 Falha Após a Promoção na Bronze, mas Antes da Confirmação do *Offset*

Um cenário crítico de falha em um modelo *at-least-once* ocorre quando:

1. o evento é persistido com sucesso na Bronze;
2. o objeto final da Bronze torna-se válido e visível;
3. o consumidor falha antes de confirmar o *offset* do Kafka.

Após a recuperação, o Kafka pode entregar o mesmo evento novamente.

Conceitualmente:

**Persistido com Sucesso → Falha → Offset Não Confirmado → Evento Reentregue**

Esse cenário cria a possibilidade de processamento duplicado.

Ele não deve criar um segundo evento histórico logicamente distinto apenas porque o mesmo evento do Kafka foi entregue novamente.

A plataforma deve utilizar identidade estável de evento e controles de processamento idempotente para reconhecer a entrega repetida de acordo com a estratégia aplicável de persistência na Bronze.

### 7.10 Falha Após a Confirmação do *Offset*

Se o objeto da Bronze tiver sido persistido, validado e promovido com sucesso, e o *offset* correspondente do Kafka tiver sido confirmado com segurança, o consumidor poderá avançar além dessa posição no Kafka.

Uma falha posterior do consumidor não deve exigir que o evento já reconhecido seja tratado como não processado apenas porque a instância do consumidor foi reinicializada.

A representação durável na Bronze torna-se a base histórica *downstream* para processamento e recuperação posteriores.

### 7.11 Processamento Idempotente na Bronze

O processamento na Bronze deve tolerar a entrega repetida do mesmo evento lógico sem produzir um estado histórico incorreto.

Idempotência não significa que alterações subsequentes legítimas para a mesma entidade de negócio sejam descartadas.

A plataforma deve distinguir:

**Mesma entidade de negócio + identidade de evento diferente → alterações históricas legítimas**

de:

**Mesma identidade de evento entregue novamente → entrega repetida do mesmo evento lógico**

Por exemplo:

**TRN_id = 100 / event_id = A → persistir**

**TRN_id = 100 / event_id = B → persistir**

**TRN_id = 100 / event_id = B novamente → reconhecer entrega repetida**

O mecanismo exato de idempotência pode utilizar identidade determinística do objeto, metadados de controle no nível do evento, estado persistido de processamento ou outro mecanismo validado durante a fase de laboratório.

O requisito arquitetural é o comportamento: a entrega repetida não deve corromper nem multiplicar falsamente o registro histórico lógico.

### 7.12 Granularidade dos Arquivos e Lotes

A persistência na Bronze pode agrupar múltiplos eventos em um objeto Parquet para aumentar a eficiência de processamento e armazenamento.

A granularidade exata dos arquivos é uma decisão de implementação e dimensionamento.

O processamento em lote introduz um importante limite de confirmação: se uma confirmação de *offset* do Kafka proteger múltiplos eventos persistidos em conjunto, a plataforma deve garantir que todo o lote protegido tenha alcançado o estado durável necessário antes que os *offsets* correspondentes avancem.

O dimensionamento dos lotes deve considerar:

- volume de eventos;
- latência de processamento;
- eficiência do tamanho dos arquivos;
- uso de memória;
- granularidade de recuperação;
- custo de novas tentativas;
- quantidade de objetos;
- eficiência de leitura *downstream*;
- impacto no SLO *end-to-end*.

Lotes maiores podem melhorar a eficiência de armazenamento e processamento, ao mesmo tempo em que aumentam a quantidade de trabalho repetido após uma falha.

Lotes menores podem reduzir a granularidade das novas tentativas, ao mesmo tempo em que aumentam a quantidade de objetos e o custo operacional.

O dimensionamento dos lotes deve, portanto, ser medido, em vez de selecionado apenas a partir de um valor padrão arbitrário.

### 7.13 Organização da Bronze

Os objetos da Bronze devem ser organizados utilizando convenções determinísticas de armazenamento que deem suporte à descoberta eficiente, *replay*, gerenciamento do ciclo de vida e rastreabilidade.

A organização física pode considerar dimensões como:

- sistema de origem;
- domínio;
- família de eventos;
- tabela da origem;
- data do evento;
- data de ingestão;
- versão do contrato;
- versão de processamento.

A convenção exata de caminhos é um padrão de implementação e é documentada separadamente.

A organização do armazenamento não deve depender de informações que não possam ser reconstruídas de forma confiável durante o *replay*.

### 7.14 *Replay* da Bronze

A Bronze é a principal base histórica durável para reconstrução *downstream* quando o histórico necessário estiver disponível.

O *replay* a partir da Bronze pode ser necessário quando, por exemplo:

- a lógica de processamento da Silver mudar;
- um defeito *downstream* for corrigido;
- a Gold precisar ser reconstruída;
- uma regra de qualidade exigir reavaliação histórica;
- um novo requisito analítico necessitar de informações históricas preservadas;
- a retenção do Kafka não contiver mais os eventos necessários.

O *replay* deve preservar a distinção entre:

- identidade original do evento;
- *timestamps* originais da origem;
- versão original do contrato;
- momento de execução do *replay*;
- versão de processamento utilizada durante o *replay*.

Executar o *replay* de um evento não deve fazer com que o evento histórico pareça ter se originado no momento do *replay*.

### 7.15 Retenção da Bronze

A retenção da Bronze deve ser definida independentemente da retenção do Kafka.

O Kafka fornece retenção limitada para transporte.

A Bronze fornece a base histórica durável necessária para *replay* e reconstrução de prazo mais longo.

A retenção da Bronze deve considerar:

- requisitos de reconstrução analítica;
- requisitos de histórico da origem;
- obrigações regulatórias ou de privacidade;
- capacidade de armazenamento;
- suporte às versões de contrato;
- políticas de ciclo de vida;
- estratégia de *backup*;
- requisitos de recuperação *downstream*.

A retenção não deve ser reduzida sem avaliar se as capacidades necessárias de *replay* ou reconstrução seriam perdidas.

### 7.16 Observabilidade da Bronze

O processamento na Bronze deve expor informações suficientes para determinar se os eventos estão sendo persistidos corretamente e se o progresso no Kafka reflete com precisão a persistência histórica durável.

A observabilidade inicial deve incluir, conforme aplicável:

- eventos consumidos;
- eventos persistidos;
- falhas de persistência;
- falhas de validação;
- falhas em objetos temporários;
- falhas de promoção;
- entregas duplicadas detectadas;
- tratamento idempotente de duplicidades;
- *offsets* do Kafka recebidos;
- *offsets* do Kafka confirmados;
- latência de gravação na Bronze;
- *throughput* de persistência na Bronze;
- quantidade de objetos;
- tamanho dos objetos;
- objetos temporários abandonados;
- novas tentativas de processamento;
- evento não persistido mais antigo;
- utilização da capacidade de armazenamento.

A observabilidade deve permitir que a plataforma distinga entre:

**o consumidor recebeu o evento**

e:

**o evento está disponível de forma durável na Bronze**.

### 7.17 Reconciliação da Bronze

A persistência na Bronze deve dar suporte à reconciliação entre o consumo no Kafka e o armazenamento histórico durável.

A plataforma deve ser capaz de investigar se:

- os eventos esperados do Kafka foram persistidos;
- os eventos persistidos mantêm seus metadados de posição no Kafka;
- entregas repetidas foram tratadas de acordo com a estratégia de idempotência;
- os *offsets* confirmados não avançam além dos dados que deveriam ter sido protegidos de forma durável;
- existem lacunas entre os intervalos esperados e persistidos de eventos.

O mecanismo exato de reconciliação pode variar de acordo com o processamento em lote e a organização do armazenamento, mas divergências silenciosas entre o progresso no Kafka e a durabilidade na Bronze não são aceitáveis.

### 7.18 Garantias de Persistência na Bronze

No limite de persistência na Bronze, a arquitetura exige as seguintes garantias:

- eventos consumidos não são reconhecidos como processados com segurança antes que a durabilidade exigida na Bronze seja alcançada;
- gravações incompletas não se tornam visíveis como dados finais válidos da Bronze;
- a publicação final segue um padrão de promoção atômica;
- o *payload* de negócio e os metadados técnicos necessários permanecem historicamente preservados;
- alterações legítimas da origem permanecem *append-only*;
- a entrega repetida é tolerada por meio de processamento idempotente;
- os *offsets* do Kafka são confirmados somente após o sucesso do trabalho de persistência protegido;
- uma falha antes da confirmação do *offset* pode resultar em reentrega segura;
- o processamento em lote não enfraquece a garantia de durabilidade antes da confirmação;
- a Bronze permanece apta a *replay* durante o período de retenção necessário;
- o *replay* preserva o contexto original do evento;
- o progresso do Kafka até a Bronze permanece observável e reconciliável.

Essas garantias estabelecem a Bronze como a base histórica durável a partir da qual o processamento padronizado *downstream* pode prosseguir.

---

## 8. Processamento, Padronização e Desduplicação na Silver

A **camada Silver** transforma o histórico imutável da Bronze em dados analíticos padronizados, tipados, normalizados, desduplicados e reutilizáveis.

A Bronze preserva a representação histórica dos eventos da origem. A Silver interpreta esses eventos de acordo com seus contratos e regras de processamento aplicáveis, resolve diferenças estruturais suportadas, aplica padronização técnica e produz uma base consistente para o processamento *downstream* da Gold.

A Silver deve permanecer reconstruível a partir do histórico necessário da Bronze e deve dar suporte ao reprocessamento controlado quando a lógica de transformação, o tratamento de contratos ou os requisitos de qualidade dos dados evoluírem.

O modelo fundamental de processamento é:

**Histórico da Bronze → Interpretação do Contrato → Validação → Tipagem e Padronização → Desduplicação → Normalização → Publicação na Silver**

O processamento da Silver deve ser determinístico e idempotente para o mesmo histórico de entrada, regras de processamento e versão de processamento.

### 8.1 Limite de Processamento da Silver

O processamento da Silver começa com dados históricos válidos persistidos na Bronze.

O limite da Silver é concluído quando a entrada aplicável da Bronze tiver sido interpretada, padronizada, desduplicada, normalizada, validada e publicada com sucesso de acordo com o contrato de processamento da Silver.

A persistência bem-sucedida na Bronze não implica processamento bem-sucedido na Silver.

Da mesma forma, o processamento bem-sucedido na Silver não implica que tenham ocorrido modelagem dimensional orientada ao negócio, reconciliação, certificação ou publicação analítica.

A Silver representa, portanto, um limite técnico de transformação analítica entre eventos históricos preservados e estruturas da Gold orientadas ao negócio.

### 8.2 Bronze como Entrada Histórica

A Bronze é a entrada histórica autoritativa para a reconstrução normal da Silver.

O processamento da Silver deve preservar linhagem suficiente para identificar os dados da Bronze dos quais cada resultado da Silver foi derivado.

Dependendo da estratégia de processamento, a linhagem pode referenciar informações como:

- sistema de origem;
- família de eventos;
- objeto ou conjunto de objetos da Bronze;
- identidade do evento;
- posição na origem;
- versão do contrato de evento;
- execução do processamento;
- versão de processamento.

A Silver não deve exigir modificação destrutiva do histórico da Bronze para corrigir a lógica de transformação *downstream*.

Quando a lógica da Silver mudar, os dados afetados da Silver devem, preferencialmente, ser reconstruídos ou reprocessados a partir do histórico preservado da Bronze, quando o histórico necessário da origem permanecer disponível.

### 8.3 Interpretação Consciente do Contrato

A Bronze pode conter eventos produzidos sob múltiplas versões suportadas de contrato.

O processamento da Silver deve interpretar cada evento histórico de acordo com a versão do contrato aplicável àquele evento.

A lógica de processamento não deve presumir que todo o histórico da Bronze esteja em conformidade com o contrato de evento mais recente.

Quando múltiplas versões históricas de contrato representarem formas compatíveis da mesma informação lógica, a Silver poderá normalizá-las em uma representação padronizada comum.

Conceitualmente:

**Contrato V1 ─┐**

**Contrato V2 ─┼→ Representação Padronizada da Silver**

**Contrato V3 ─┘**

Essa normalização deve preservar a correção semântica.

Se um contrato mais antigo não puder ser mapeado com segurança para a representação atual da Silver, a plataforma deve utilizar uma regra explícita de migração, manter uma representação versionada apropriada ou impedir o processamento inseguro, em vez de inventar silenciosamente semânticas ausentes.

### 8.4 Aplicação de Tipos

A Silver introduz tipagem analítica explícita.

Os valores originados nos *payloads* dos eventos devem ser interpretados e convertidos de acordo com o contrato de dados da Silver aplicável e as regras de transformação.

A aplicação de tipos pode incluir, conforme aplicável:

- tipos numéricos;
- precisão e escala de decimais;
- datas;
- *timestamps*;
- representações booleanas;
- identificadores;
- valores textuais controlados;
- nulabilidade;
- tipos lógicos.

Falhas de conversão de tipos não devem ser silenciosamente convertidas em valores aparentemente válidos.

Valores inválidos ou incompatíveis devem seguir o comportamento aplicável de qualidade, quarentena, rejeição ou remediação definido para o conjunto de dados.

A aplicação de tipos deve permanecer determinística e testável.

### 8.5 Padronização

A Silver padroniza representações tecnicamente equivalentes em formas analíticas consistentes.

A padronização pode incluir, conforme aplicável:

- nomenclatura consistente;
- representação consistente de datas e *timestamps*;
- valores booleanos normalizados;
- representação controlada de valores nulos;
- precisão decimal consistente;
- representação textual canônica;
- representação controlada de códigos;
- metadados técnicos padronizados;
- tratamento consistente das versões suportadas de contrato.

A padronização não deve alterar silenciosamente o significado de negócio.

Uma representação técnica pode ser normalizada somente quando o valor resultante permanecer semanticamente equivalente à informação da origem ou seguir uma regra analítica explicitamente documentada.

### 8.6 Normalização

A Silver pode normalizar representações da origem ou dos eventos para melhorar a reutilização e a consistência *downstream*.

A normalização pode incluir:

- resolução de representações estruturais equivalentes;
- separação dos metadados técnicos dos atributos analíticos;
- alinhamento das versões históricas suportadas de contrato;
- derivação de campos técnicos estáveis exigidos pelo processamento *downstream*;
- aplicação de representações canônicas documentadas.

A normalização na Silver não é modelagem dimensional.

O design de fatos e dimensões, a atribuição de chaves substitutas, as dimensões conformadas e as estruturas analíticas orientadas ao negócio permanecem responsabilidades da Gold.

### 8.7 Desduplicação

O processamento da Silver deve impedir que a entrega repetida ou o processamento repetido do mesmo evento lógico crie registros analíticos duplicados incorretos.

A desduplicação deve distinguir entre:

**Entrega repetida do mesmo evento**

e:

**Eventos legítimos diferentes afetando a mesma entidade de negócio**

Por exemplo:

**TRN_id = 100 / event_id = A → evento legítimo**

**TRN_id = 100 / event_id = B → evento subsequente legítimo**

**TRN_id = 100 / event_id = B novamente → candidato a entrega repetida**

Uma chave de negócio isoladamente é, portanto, insuficiente para identificar duplicidade no nível do evento.

A estratégia de desduplicação deve utilizar a identidade do evento e qualquer contexto adicional de processamento exigido pelo conjunto de dados aplicável.

A desduplicação não deve remover alterações históricas legítimas apenas porque múltiplos eventos fazem referência à mesma entidade de negócio.

### 8.8 Processamento Idempotente na Silver

As transformações da Silver devem ser idempotentes.

Reprocessar a mesma entrada da Bronze utilizando as mesmas regras e a mesma versão de processamento não deve produzir uma multiplicação incorreta dos resultados da Silver nem corromper de outra forma o estado padronizado.

Conceitualmente:

**Mesma Entrada + Mesma Versão de Processamento → Mesmo Resultado Lógico na Silver**

A idempotência pode ser implementada por meio de transformação determinística, substituição controlada de partições ou conjuntos de dados derivados, lógica de *merge*, metadados de estado de processamento ou outro mecanismo validado durante a implementação.

A arquitetura define o comportamento exigido, em vez de prescrever um único mecanismo de implementação antes da validação em laboratório.

### 8.9 Semântica das Operações

O processamento da Silver deve preservar ou interpretar corretamente a semântica das operações na origem necessária para reconstruir o estado analítico.

Eventos de inserção, atualização e exclusão podem exigir comportamentos de processamento diferentes.

Por exemplo:

- uma inserção pode introduzir um novo estado de entidade;
- uma atualização pode substituir ou evoluir um estado existente;
- uma exclusão pode representar remoção ou encerramento explícito, e não simples ausência.

A interpretação exata depende do conjunto de dados e dos requisitos analíticos *downstream*.

A Silver não deve descartar a semântica das operações antes que todo o processamento *downstream* que dependa dessa semântica tenha sido concluído.

### 8.10 Estado Atual e Eventos Históricos

A Bronze preserva o histórico de eventos.

A Silver pode expor eventos históricos padronizados, estado atual reconstruído ou ambos, dependendo do requisito *downstream*.

Essas representações devem permanecer conceitualmente distintas.

Por exemplo:

**Visão de Eventos Históricos**
→ preserva a sequência padronizada de alterações.

**Visão de Estado Atual**
→ representa o estado aplicável mais recente derivado dessas alterações.

Uma representação de estado atual não deve apagar a base histórica da qual foi derivada.

As representações necessárias da Silver devem ser definidas por conjunto de dados de acordo com os requisitos de reconstrução da Gold, *replay*, reconciliação e análise.

### 8.11 Versão de Processamento

As saídas da Silver devem permanecer atribuíveis à lógica de transformação que as produziu.

Quando o comportamento da transformação puder evoluir, a plataforma deve preservar informações suficientes sobre a versão de processamento para determinar qual lógica foi aplicada a um resultado da Silver.

A versão de processamento é distinta da versão do contrato de evento:

**Versão do Contrato de Evento**
→ descreve a estrutura utilizada para interpretar o evento de entrada.

**Versão de Processamento**
→ identifica a lógica de transformação utilizada para produzir a representação da Silver.

Essa distinção dá suporte à reprodutibilidade, *debugging*, reprocessamento controlado e comparação entre versões de transformação.

### 8.12 Registros Inválidos e Quarentena

Um registro que não possa ser processado com segurança não deve ser silenciosamente convertido em dado aparentemente válido da Silver.

Dependendo do tipo de falha e da política do conjunto de dados, registros inválidos podem exigir:

- rejeição;
- quarentena;
- nova tentativa;
- remediação;
- tratamento explícito de exceção.

O mecanismo de tratamento deve preservar contexto suficiente para determinar:

- qual registro falhou;
- qual entrada da Bronze o produziu;
- por que o processamento falhou;
- qual versão do contrato se aplicava;
- qual versão de processamento foi utilizada;
- se a falha permite nova tentativa;
- se o processamento *downstream* foi afetado.

Dados em quarentena ou rejeitados devem permanecer observáveis e não devem desaparecer da visibilidade operacional.

### 8.13 Publicação na Silver

A saída da Silver deve ser publicada somente após a unidade de processamento correspondente ter concluído os controles necessários de transformação e validação.

Saídas da Silver parcialmente gravadas ou incompletas não devem se tornar visíveis como um conjunto de dados concluído e válido.

Quando for utilizado armazenamento da Silver baseado em arquivos, a publicação deve seguir um padrão de promoção atômica ou controlada equivalente apropriado à tecnologia de armazenamento.

O mecanismo físico exato é uma questão de implementação e deve ser validado durante a fase de laboratório.

O requisito arquitetural é que o processamento *downstream* da Gold não interprete uma saída incompleta da Silver como dados publicados com sucesso.

### 8.14 Processamento Incremental

O processamento normal da Silver deve, preferencialmente, processar de forma incremental os novos dados disponíveis na Bronze, quando apropriado.

O processamento incremental deve preservar:

- limites de entrada;
- progresso do processamento;
- idempotência;
- interpretação das versões de contrato;
- comportamento de desduplicação;
- linhagem;
- capacidade de novas tentativas.

A estratégia incremental não deve tornar impossível uma reconstrução completa.

A Silver deve permanecer reconstruível a partir do histórico necessário da Bronze quando um reprocessamento completo e controlado for necessário.

### 8.15 Reprocessamento

O reprocessamento da Silver pode ser necessário quando:

- a lógica de transformação mudar;
- um defeito for corrigido;
- o tratamento das versões de contrato mudar;
- regras históricas de padronização evoluírem;
- um problema de qualidade exigir remediação;
- a reconstrução *downstream* exigir uma reconstrução limpa da Silver.

O reprocessamento deve definir o intervalo de entrada afetado, a versão de processamento, o escopo da saída, os critérios de validação e o comportamento de substituição ou coexistência.

O reprocessamento não deve sobrescrever dados válidos e não relacionados da Silver nem fazer com que a entrada histórica pareça ter se originado no momento do reprocessamento.

### 8.16 *Backfill*

Um *backfill* introduz ou reconstrói dados para um intervalo histórico que esteja ausente, tenha se tornado necessário ou esteja sendo intencionalmente adicionado ao escopo normal de processamento.

O *backfill* está relacionado ao *replay*, mas é distinto dele.

Conceitualmente:

**Replay**
→ processar novamente uma entrada histórica preservada.

**Backfill**
→ preencher um intervalo histórico necessário que esteja ausente ou que tenha sido recém-introduzido no escopo de processamento de destino.

Um *backfill* pode utilizar o histórico da Bronze, outra fonte de recuperação aprovada ou uma extração controlada da origem, dependendo da razão da lacuna histórica e dos dados disponíveis.

A execução do *backfill* deve preservar a rastreabilidade entre o período histórico da origem e o momento em que o *backfill* foi executado.

### 8.17 Reconciliação da Silver

O processamento da Silver deve dar suporte à reconciliação em relação à sua entrada da Bronze.

A plataforma deve ser capaz de determinar, de acordo com a semântica do conjunto de dados aplicável:

- se a entrada esperada da Bronze foi processada;
- se eventos repetidos foram tratados corretamente;
- se registros foram rejeitados ou colocados em quarentena;
- se a semântica das operações foi preservada;
- se as contagens de saída e os totais de controle são plausíveis;
- se existem lacunas de processamento;
- qual versão de processamento produziu a saída.

A simples igualdade entre contagens de linhas não é universalmente suficiente, pois um evento da Bronze não corresponde necessariamente a exatamente um registro na Silver.

As regras de reconciliação devem refletir a semântica de transformação do conjunto de dados.

### 8.18 Observabilidade da Silver

O processamento da Silver deve expor informações suficientes para compreender a saúde do processamento, o comportamento dos dados e o estado de recuperação.

A observabilidade inicial deve considerar, conforme aplicável:

- volume de entrada da Bronze;
- volume de saída da Silver;
- duração do processamento;
- *throughput* de processamento;
- falhas de conversão de tipos;
- falhas de validação;
- eventos duplicados detectados;
- registros rejeitados;
- registros em quarentena;
- novas tentativas;
- informações da versão de processamento;
- versões de contrato processadas;
- posição do processamento incremental;
- estado do reprocessamento;
- estado do *backfill*;
- falhas de publicação na Silver;
- entrada não processada mais antiga da Bronze;
- latência de processamento da Bronze até a Silver.

A observabilidade deve permitir que a plataforma distinga entre um processo tecnicamente em execução e um processo que esteja produzindo dados completos e válidos na Silver.

### 8.19 Garantias do Processamento da Silver

No limite de processamento da Silver, a arquitetura exige as seguintes garantias:

- a Silver permanece reconstruível a partir do histórico necessário da Bronze;
- versões históricas de contrato são interpretadas de acordo com seus contratos aplicáveis;
- diferenças estruturais suportadas são normalizadas explicitamente;
- tipagem e padronização são determinísticas;
- a normalização técnica não redefine silenciosamente a semântica de negócio;
- entregas repetidas não criam registros analíticos duplicados incorretos;
- alterações históricas legítimas não são removidas como duplicidades;
- o processamento é idempotente para a mesma entrada e versão de processamento;
- registros inválidos são tratados explicitamente, em vez de silenciosamente convertidos;
- saídas incompletas da Silver não são publicadas como válidas;
- o processamento incremental não elimina a capacidade de reconstrução completa;
- *replay*, reprocessamento e *backfill* permanecem rastreáveis;
- a linhagem entre Silver e Bronze permanece disponível;
- a saúde do processamento e as falhas de qualidade dos dados permanecem observáveis e reconciliáveis.

Essas garantias estabelecem a Silver como a base analítica padronizada e reutilizável a partir da qual as estruturas da Gold orientadas ao negócio podem ser construídas.

---

## 9. Processamento Dimensional na Gold

A **camada Gold** transforma dados padronizados da Silver em estruturas analíticas orientadas ao negócio, projetadas para uso analítico governado.

Na arquitetura V1, a Gold é implementada no **AtlasWarehouse** utilizando **SQL Server** e segue princípios de modelagem dimensional baseados na **metodologia Kimball**.

A Gold introduz estruturas analíticas como fatos, dimensões, chaves substitutas, dimensões conformadas, comportamento histórico de dimensões e regras de transformação orientadas ao negócio.

A Silver fornece uma entrada analítica padronizada e reutilizável. A Gold aplica a semântica dimensional e de negócio necessária para transformar essa entrada em estruturas otimizadas para interpretação e consumo analítico.

O modelo fundamental de processamento é:

**Silver → Transformação de Negócio → Processamento de Dimensões → Processamento de Fatos → Validação da Gold → Publicação na Gold**

O processamento bem-sucedido na Gold não certifica, por si só, os dados para consumo analítico oficial. A Gold ainda deve passar pelos controles necessários de qualidade, reconciliação e certificação antes da publicação por meio da **Certified Gold**.

### 9.1 Limite de Processamento da Gold

O processamento da Gold começa com dados válidos e publicados na Silver.

O limite de processamento da Gold é concluído quando a entrada aplicável da Silver tiver sido transformada nas estruturas dimensionais necessárias e a unidade de processamento resultante da Gold tiver concluído com sucesso sua validação no nível da transformação.

A Gold é responsável pela modelagem analítica orientada ao negócio.

Ela não é responsável por:

- preservar a representação original e imutável do evento;
- substituir a persistência histórica da Bronze;
- realizar captura de alterações na origem;
- transportar eventos;
- governar a compatibilidade dos contratos de eventos;
- conceder certificação apenas porque a transformação foi concluída com sucesso.

A distinção entre o processamento da Gold e a publicação na Certified Gold deve permanecer explícita.

### 9.2 Modelo Dimensional

A Gold organiza os dados analíticos em estruturas dimensionais projetadas para dar suporte a consultas analíticas compreensíveis, reutilizáveis e eficientes.

O modelo dimensional da V1 segue o padrão geral:

**Dimensões → contexto descritivo de negócio**

**Fatos → eventos ou processos de negócio mensuráveis**

Para o produto inicial **Daily Sales**, o grão exato do fato, as dimensões, as medidas e os relacionamentos dimensionais devem ser derivados da semântica de negócio aprovada do AtlasCommerce e dos requisitos analíticos definidos durante a implementação.

O modelo dimensional não deve introduzir definições de negócio que contradigam a documentação operacional da origem.

### 9.3 Grão do Fato

Toda estrutura de fato deve possuir um grão explicitamente definido.

O grão descreve o que uma linha do fato representa.

Por exemplo, um fato de vendas poderia teoricamente representar:

- uma transação;
- um item de transação;
- um produto por transação;
- uma agregação diária por produto;
- outro evento analítico explicitamente definido.

A arquitetura não seleciona um grão apenas por conveniência ou pelo layout esperado do relatório.

O grão deve ser definido a partir do requisito analítico e deve permanecer consistente com as medidas e dimensões associadas ao fato.

Medidas com grãos incompatíveis não devem ser combinadas na mesma estrutura de fato sem uma justificativa explícita de modelagem.

### 9.4 Chaves de Negócio e Naturais

Identificadores de negócio da origem podem ser necessários para relacionar os dados da Silver às dimensões e fatos da Gold.

Esses identificadores preservam a relação entre o modelo analítico e a entidade operacional de negócio.

Uma chave da origem ou de negócio é distinta de uma chave substituta da Gold.

Conceitualmente:

**Chave de Negócio / Natural**
→ identifica a entidade de negócio de acordo com a semântica aplicável da origem ou do negócio.

**Chave Substituta**
→ identifica um registro dimensional dentro do modelo analítico.

Ambas podem ser necessárias porque atendem a finalidades diferentes.

### 9.5 Chaves Substitutas

As dimensões da Gold podem utilizar chaves substitutas para fornecer identificadores analíticos estáveis e independentes das chaves físicas do sistema de origem.

As chaves substitutas dão suporte a requisitos de modelagem dimensional como:

- versões históricas de dimensões;
- independência em relação às chaves da origem;
- dimensões conformadas;
- relacionamentos entre fatos e dimensões;
- tratamento controlado de atributos descritivos mutáveis.

Uma chave substituta não deve substituir a capacidade de rastrear o membro da dimensão até o identificador de negócio ou da origem aplicável.

A geração de chaves substitutas deve ser determinística em seu comportamento e segura sob processamento incremental, novas tentativas, reprocessamento e execução concorrente.

O mecanismo exato de geração é uma decisão de implementação que deve ser validada em relação à estratégia de carga dimensional selecionada no SQL Server.

### 9.6 Processamento de Dimensões

O processamento de dimensões transforma entidades padronizadas da Silver em estruturas analíticas descritivas.

Dependendo da dimensão, o processamento pode incluir:

- identificar membros existentes;
- inserir novos membros;
- atualizar atributos aplicáveis;
- criar versões históricas;
- atribuir chaves substitutas;
- preservar chaves de negócio;
- gerenciar períodos de vigência;
- resolver referências desconhecidas ou não resolvidas;
- aplicar semântica conformada.

O comportamento de cada dimensão deve ser explicitamente definido de acordo com seu propósito analítico.

Nem toda alteração de atributo exige versionamento histórico, e nem toda dimensão exige a mesma estratégia de gerenciamento de alterações.

### 9.7 Dimensões de Mudança Lenta

Quando a interpretação analítica histórica exigir que alterações em atributos descritivos sejam preservadas, a Gold pode implementar comportamento de **Slowly Changing Dimension (SCD)**.

A estratégia SCD aplicável deve ser selecionada de acordo com o significado de negócio da dimensão e do atributo.

Por exemplo:

**Tipo 1**
→ substitui o valor analítico anterior do atributo quando a preservação histórica dessa alteração não é necessária.

**Tipo 2**
→ cria uma nova versão dimensional quando a interpretação histórica precisa preservar tanto o estado anterior quanto o novo.

A arquitetura não exige que toda dimensão ou todo atributo utilize histórico Tipo 2.

O comportamento histórico deve ser definido deliberadamente no nível aplicável do atributo ou da dimensão.

Quando o comportamento Tipo 2 for utilizado, o processamento deve preservar o período de vigência e permitir que os fatos sejam resolvidos para a versão dimensional apropriada de acordo com as regras de negócio e temporais definidas.

### 9.8 Dimensões Conformadas

Entidades de negócio compartilhadas entre múltiplos domínios analíticos devem, preferencialmente, utilizar dimensões conformadas quando exigirem interpretação analítica consistente.

Uma dimensão conformada fornece uma definição dimensional reutilizável que permite que fatos de diferentes domínios sejam analisados por meio de um contexto de negócio comum.

Por exemplo, domínios futuros podem precisar avaliar se entidades como:

- cliente;
- produto;
- data;
- canal;
- localização;

podem ser candidatas ao uso de uma dimensão conformada existente.

A conformidade deve ser baseada em compatibilidade semântica, e não apenas em nomes ou colunas da origem semelhantes.

Quando um novo domínio exigir atributos dimensionais adicionais e legítimos, a dimensão existente deve ser avaliada para evolução controlada, em vez de ser automaticamente duplicada ou modificada sem análise de impacto.

### 9.9 Processamento de Fatos

O processamento de fatos transforma eventos ou estados de negócio da Silver em estruturas analíticas mensuráveis no grão definido do fato.

O processamento de fatos pode incluir:

- resolver chaves substitutas das dimensões;
- derivar medidas documentadas;
- aplicar regras de transformação de negócio;
- preservar dimensões degeneradas ou identificadores de negócio necessários;
- tratar referências desconhecidas de dimensões;
- aplicar o grão do fato;
- aplicar relacionamentos temporais;
- manter linhagem até a entrada da Silver.

Os fatos não devem alterar silenciosamente seu grão entre execuções de processamento.

Uma medida deve ser calculada de forma consistente de acordo com sua definição de negócio documentada.

### 9.10 Consulta de Dimensões e Membros Desconhecidos

O processamento de fatos pode encontrar uma chave de negócio para a qual o membro correspondente da dimensão ainda não esteja disponível ou não possa ser resolvido.

A plataforma deve definir um comportamento explícito para referências dimensionais não resolvidas.

Dependendo do modelo analítico aplicável, a estratégia pode incluir:

- adiar o processamento do fato;
- tentar novamente a resolução da dimensão;
- atribuir um membro desconhecido controlado;
- colocar o fato afetado em quarentena;
- seguir outro caminho de remediação explicitamente documentado.

Uma referência de dimensão ausente não deve ser silenciosamente convertida em um membro válido arbitrário da dimensão.

Quando um membro desconhecido for utilizado, seu significado deve ser explícito e distinguível de uma entidade de negócio legitimamente conhecida.

### 9.11 Consistência Temporal

O processamento da Gold deve preservar os relacionamentos temporais exigidos pelo modelo analítico.

Quando dimensões históricas forem utilizadas, o processamento de fatos deve resolver a versão dimensional aplicável ao *timestamp* de negócio definido.

Conceitualmente:

**Tempo do Evento de Negócio → Versão Dimensional Aplicável**

O *timestamp* aplicável deve ser definido de acordo com a semântica analítica do fato e não deve ser selecionado arbitrariamente a partir de qualquer *timestamp* de processamento mais conveniente.

Tempo de processamento e tempo de vigência de negócio devem permanecer distinguíveis.

### 9.12 Processamento Incremental da Gold

O processamento normal da Gold deve, preferencialmente, consumir de forma incremental os novos dados disponíveis da Silver, quando apropriado.

O processamento incremental deve preservar:

- grão do fato;
- consistência dimensional;
- estabilidade das chaves substitutas;
- comportamento histórico das dimensões;
- idempotência;
- linhagem;
- progresso do processamento;
- capacidade de novas tentativas.

A carga incremental não deve tornar impossível uma reconstrução completa e controlada.

A Gold deve permanecer reconstruível a partir da base necessária da Silver quando uma reconstrução completa ou parcial for necessária.

### 9.13 Processamento Idempotente na Gold

O processamento da Gold deve ser idempotente.

Reprocessar a mesma entrada da Silver sob as mesmas regras de transformação e dimensionais não deve criar fatos duplicados, versões dimensionais duplicadas ou relacionamentos inconsistentes de chaves substitutas.

Conceitualmente:

**Mesma Entrada da Silver + Mesma Versão de Processamento → Mesmo Resultado Lógico na Gold**

A idempotência deve considerar tanto:

- processamento de fatos;
- processamento de dimensões.

O mecanismo de implementação pode diferir entre fatos e dimensões, mas o estado analítico resultante deve permanecer correto durante novas tentativas e reprocessamento controlado.

### 9.14 Versão de Processamento da Gold

As saídas da Gold devem permanecer atribuíveis à lógica de transformação e de modelo dimensional que as produziu.

Quando a lógica da Gold evoluir, informações suficientes de versão devem ser preservadas para dar suporte a:

- reprodutibilidade;
- *debugging*;
- reprocessamento;
- análise de impacto;
- comparação entre versões;
- evidências de certificação.

A versão de processamento da Gold é distinta tanto da:

- versão do contrato de evento;
- versão de processamento da Silver.

Essas versões descrevem etapas diferentes do caminho de processamento *end-to-end* e não devem ser tratadas como intercambiáveis.

### 9.15 Reprocessamento da Gold

O reprocessamento da Gold pode ser necessário quando:

- a lógica de transformação de negócio mudar;
- a lógica dimensional mudar;
- um defeito for corrigido;
- uma regra de SCD mudar;
- a definição de uma medida mudar;
- uma dimensão conformada evoluir;
- dados históricos exigirem remediação;
- a certificação identificar um defeito que exija reconstrução.

O reprocessamento deve definir:

- entrada da Silver afetada;
- estruturas da Gold afetadas;
- versão de processamento;
- impacto dimensional;
- impacto nos fatos;
- intervalo histórico;
- critérios de validação;
- comportamento de substituição ou coexistência;
- requisitos de *rollback*.

Uma alteração em dimensões compartilhadas deve incluir análise de impacto para todos os fatos ou produtos analíticos dependentes.

### 9.16 Publicação na Gold

A saída da Gold não deve se tornar disponível como uma unidade de processamento concluída até que a transformação dimensional correspondente tenha sido concluída com sucesso.

O processamento parcial de fatos ou dimensões não deve ser apresentado como um resultado completo da Gold.

Quando um ciclo de processamento atualizar múltiplas estruturas relacionadas da Gold, o comportamento de publicação deve impedir que a certificação *downstream* avalie uma combinação internamente inconsistente de estados antigos e novos de processamento.

O mecanismo exato de publicação depende da implementação do AtlasWarehouse e deve ser validado durante a fase de laboratório.

A publicação na Gold indica processamento dimensional bem-sucedido.

Ela não indica certificação analítica.

### 9.17 Reconciliação da Gold

A Gold deve dar suporte à reconciliação em relação à sua entrada da Silver e, quando necessário, em relação à origem operacional por meio do caminho de linhagem preservado.

A reconciliação pode incluir, de acordo com a semântica analítica:

- contagens de transações;
- contagens de itens;
- quantidades;
- totais monetários;
- contagens de membros de dimensões;
- referências dimensionais não resolvidas;
- registros rejeitados;
- consistência das versões históricas;
- totais de controle da origem até o destino.

A reconciliação deve considerar diferenças de grão.

A contagem de eventos da Silver e a contagem de linhas de fatos da Gold não precisam ser iguais, a menos que a semântica da transformação estabeleça explicitamente uma relação um para um.

As regras de reconciliação devem, portanto, validar completude e consistência de negócio, em vez de depender apenas da igualdade física entre contagens de linhas.

### 9.18 Observabilidade da Gold

O processamento da Gold deve expor informações suficientes para compreender a saúde do processamento dimensional e a completude analítica.

A observabilidade inicial deve considerar, conforme aplicável:

- volume de entrada da Silver;
- linhas de fatos processadas;
- membros de dimensões inseridos;
- membros de dimensões atualizados;
- versões históricas de dimensões criadas;
- referências dimensionais não resolvidas;
- atribuições de membros desconhecidos;
- registros rejeitados ou em quarentena;
- duração do processamento;
- *throughput* de processamento;
- novas tentativas;
- versão de processamento;
- posição do processamento incremental;
- estado do reprocessamento;
- falhas de publicação;
- latência da Silver até a Gold;
- estado da reconciliação.

A observabilidade deve permitir que a plataforma distinga entre execução bem-sucedida de um *job* e processamento dimensional correto.

### 9.19 Garantias do Processamento da Gold

No limite de processamento da Gold, a arquitetura exige as seguintes garantias:

- as estruturas da Gold seguem grãos analíticos explicitamente definidos;
- a modelagem dimensional permanece alinhada com a semântica de negócio documentada;
- chaves de negócio e chaves substitutas permanecem conceitualmente distintas;
- os relacionamentos de chaves substitutas permanecem rastreáveis até as entidades de negócio da origem;
- o histórico dimensional é aplicado somente quando analiticamente necessário;
- as dimensões conformadas são baseadas em compatibilidade semântica;
- o processamento de fatos preserva o grão definido e a semântica das medidas;
- referências dimensionais não resolvidas seguem regras explícitas de tratamento;
- os relacionamentos temporais utilizam o contexto apropriado de vigência de negócio;
- o processamento incremental permanece idempotente e reconstruível;
- novas tentativas e reprocessamento não criam fatos duplicados nem versões dimensionais inválidas;
- alterações em dimensões compartilhadas incluem análise de impacto *downstream*;
- processamento incompleto da Gold não é apresentado como um resultado completo;
- a Gold permanece reconciliável com sua base na Silver e com os controles aplicáveis da origem;
- o processamento bem-sucedido na Gold não implica certificação.

Essas garantias estabelecem a Gold como a camada dimensional orientada ao negócio a partir da qual a certificação governada pode prosseguir.

---

## 10. Validação de Qualidade e Reconciliação

Dados que concluíram com sucesso o processamento técnico não estão automaticamente aptos para consumo analítico governado.

Antes que um resultado da Gold possa ser promovido para a **Certified Gold**, ele deve passar pelos controles de qualidade e reconciliação definidos para o produto analítico correspondente.

A validação de qualidade avalia se os dados resultantes atendem às expectativas explícitas relacionadas à estrutura, completude, validade, consistência, unicidade, comportamento referencial, atualidade e regras de negócio.

A reconciliação avalia se o resultado analítico permanece consistente com os dados *upstream* autoritativos e com as transformações aplicadas ao longo do caminho de processamento.

Esses controles estabelecem o limite de validação entre dados da **Gold** processados com sucesso e dados da **Certified Gold** aptos para publicação.

O caminho fundamental de certificação é:

**Gold → Validação de Qualidade → Reconciliação → Decisão de Certificação → Certified Gold**

A falha de um controle crítico deve impedir a promoção da versão candidata afetada, preservando ao mesmo tempo a última versão certificada reconhecidamente confiável para os consumidores.

### 10.1 Limite de Validação de Qualidade

A validação de qualidade começa depois que a unidade candidata de processamento da Gold conclui as transformações necessárias para o produto analítico.

A validação deve avaliar a versão candidata antes que essa versão se torne a publicação analítica governada.

O limite de validação deve distinguir entre:

- execução bem-sucedida da transformação;
- validação de qualidade dos dados bem-sucedida;
- reconciliação bem-sucedida;
- certificação bem-sucedida.

Esses estados não devem ser combinados em um único estado genérico de sucesso do *job*.

Uma execução de processamento da Gold pode, portanto, ser concluída com sucesso enquanto a versão candidata resultante permanece não certificada.

### 10.2 Dimensões de Qualidade dos Dados

As regras de qualidade devem ser definidas de acordo com as características e os requisitos de negócio de cada conjunto de dados.

As dimensões de qualidade aplicáveis podem incluir:

**Completude**  
Os dados obrigatórios estão presentes de acordo com as regras analíticas aplicáveis.

**Validade**  
Os valores estão em conformidade com os domínios, intervalos, formatos, tipos e regras controladas esperados.

**Consistência**  
Valores relacionados não se contradizem entre as estruturas analíticas aplicáveis.

**Unicidade**  
Registros que devem ser únicos de acordo com o grão definido ou regra de negócio não apresentam duplicidades inválidas.

**Integridade Referencial**  
Os relacionamentos analíticos exigidos são resolvidos de acordo com o modelo dimensional e sua estratégia explícita para membros desconhecidos ou exceções.

**Pontualidade / Atualidade**  
Os dados estão disponíveis dentro das expectativas de atualidade e do SLO aplicável.

**Conformidade com Regras de Negócio**  
Os dados resultantes atendem à semântica de negócio documentada e às regras analíticas.

Nem todo conjunto de dados exige regras ou limites idênticos.

Os controles de qualidade devem refletir o propósito analítico e a criticidade do produto de dados correspondente.

### 10.3 Qualidade Estrutural

A qualidade estrutural verifica se os dados analíticos candidatos estão em conformidade com a estrutura técnica esperada.

Os controles podem incluir:

- colunas obrigatórias;
- tipos de dados esperados;
- regras de nulabilidade;
- precisão e escala esperadas;
- estrutura das chaves dimensionais;
- grão esperado;
- restrições de unicidade;
- metadados obrigatórios;
- informações da versão de processamento.

A validação estrutural não deve ser tratada como prova suficiente da correção de negócio.

Um conjunto de dados pode ser estruturalmente válido e ainda conter valores de negócio incorretos.

### 10.4 Regras de Qualidade de Negócio

As regras de qualidade de negócio validam expectativas derivadas da semântica de negócio documentada e das definições analíticas.

Os exemplos podem incluir, dependendo do produto:

- as quantidades devem seguir as regras de negócio aplicáveis;
- as medidas monetárias devem utilizar a semântica de cálculo documentada;
- o status da transação deve ser válido para o contexto analítico;
- os relacionamentos exigidos entre dados de transações e itens devem permanecer consistentes;
- estados operacionais excluídos não devem contribuir para medidas que os excluam explicitamente;
- a classificação dimensional deve seguir as definições de negócio aprovadas.

As regras de negócio utilizadas para certificação devem ser documentadas e rastreáveis até suas definições analíticas ou de negócio da origem correspondentes.

A Engenharia de Dados não deve inventar semânticas da origem não documentadas apenas para fazer com que uma regra de qualidade seja aprovada.

### 10.5 Controles Críticos e Não Críticos

Os controles de qualidade devem ser classificados de acordo com seu impacto na certificação.

Um **controle crítico** representa uma condição cuja falha torna a versão analítica candidata inadequada para publicação governada.

Um **controle não crítico** representa uma condição que pode exigir alerta, investigação ou remediação, mas que não necessariamente impede a certificação de acordo com a política aplicável do produto.

A classificação deve ser explícita.

Um *framework* de validação não deve decidir silenciosamente que uma regra com falha é não crítica apenas porque permitir a publicação é operacionalmente conveniente.

Para cada controle governado, a documentação deve, preferencialmente, definir, conforme aplicável:

- propósito do controle;
- lógica de validação;
- resultado esperado;
- limite;
- severidade;
- impacto na certificação;
- responsabilidade;
- expectativa de remediação.

### 10.6 Controles Baseados em Limites

Nem todo controle de qualidade exige uma condição absoluta de zero erros.

Alguns controles podem utilizar limites explicitamente aprovados.

Por exemplo, um produto pode definir uma tolerância para determinada condição não crítica quando o impacto de negócio é compreendido e aceito.

Os limites devem ser:

- explícitos;
- mensuráveis;
- justificados;
- versionados quando necessário;
- observáveis;
- associados a uma consequência de certificação definida.

Um limite não deve ser introduzido após uma falha apenas para fazer com que a execução atual seja aprovada.

Alterações nos limites de certificação são mudanças governadas e exigem justificativa documentada.

### 10.7 Reconciliação da Origem ao Destino

A reconciliação valida se os resultados analíticos *downstream* permanecem consistentes com as informações *upstream* autoritativas das quais foram derivados.

Dependendo da transformação e do grão, a reconciliação pode comparar medidas como:

- contagens de transações;
- contagens de itens de transação;
- quantidades;
- valores brutos;
- descontos;
- valores líquidos;
- distribuições de status;
- intervalos de datas;
- cobertura de chaves de negócio;
- totais de controle.

A medida de reconciliação apropriada depende da semântica da transformação.

Não se deve presumir que as contagens físicas de linhas correspondam entre as camadas quando seus grãos forem diferentes.

Por exemplo:

**itens de transação do AtlasCommerce → eventos padronizados da Silver → fatos dimensionais da Gold**

podem envolver diferentes contagens físicas de registros e ainda preservar totais de negócio equivalentes.

A reconciliação deve, portanto, validar equivalência de negócio significativa, em vez de exigir correspondência arbitrária de uma linha para uma linha.

### 10.8 Reconciliação entre Camadas

Quando necessário, a reconciliação deve, preferencialmente, permitir que a plataforma rastreie e compare dados entre múltiplos limites de processamento.

Conceitualmente:

**AtlasCommerce → Bronze → Silver → Gold**

A plataforma deve, preferencialmente, ser capaz de investigar em qual ponto uma discrepância observada foi introduzida.

Por exemplo:

**Origem correta / Bronze incorreta**
→ investigar captura ou persistência.

**Bronze correta / Silver incorreta**
→ investigar padronização, desduplicação ou transformação.

**Silver correta / Gold incorreta**
→ investigar transformação dimensional ou de negócio.

Essa abordagem de reconciliação em camadas reduz o escopo de diagnóstico dos incidentes de qualidade dos dados.

### 10.9 Janelas de Reconciliação

A reconciliação deve comparar janelas equivalentes de processamento e de negócio.

Comparar um dia completo da origem com um dia parcialmente processado na Gold pode produzir uma discrepância aparente que reflita diferença de tempo, e não perda de dados.

O processo de reconciliação deve, portanto, definir:

- limite da origem;
- limite de processamento *downstream*;
- período de negócio aplicável;
- comportamento de dados que chegam com atraso;
- regras de corte;
- regras de fuso horário;
- critérios de conclusão.

As definições das janelas devem ser determinísticas e reproduzíveis.

### 10.10 Dados que Chegam com Atraso

Os dados podem chegar legitimamente após a janela normal de processamento devido a atraso *upstream*, recuperação, *backlog*, *replay* ou ao próprio momento do processo de negócio.

A plataforma deve distinguir dados válidos que chegaram com atraso de dados ausentes.

O produto analítico aplicável deve definir como dados que chegam com atraso afetam:

- processamento da Gold;
- reconciliação;
- certificação;
- períodos publicados anteriormente;
- reprocessamento;
- atualidade analítica.

Dados que chegam com atraso não devem ser silenciosamente descartados apenas porque uma janela de processamento anterior já foi concluída.

Quando dados que chegam com atraso alterarem um resultado previamente certificado, o período analítico afetado deve seguir o procedimento aplicável de reprocessamento e recertificação controlados.

### 10.11 Tratamento de Falhas de Qualidade

Quando um controle de qualidade ou reconciliação falhar, a plataforma deve preservar evidências suficientes para determinar:

- qual versão candidata falhou;
- qual regra falhou;
- resultado observado;
- resultado esperado ou limite;
- escopo dos dados afetados;
- versão de processamento;
- escopo da origem ou *upstream*;
- *timestamp* da falha;
- impacto na certificação.

Falhas críticas devem bloquear a promoção da versão candidata afetada.

A versão candidata com falha deve permanecer distinguível da última versão certificada reconhecidamente confiável.

O tratamento da falha pode incluir:

- investigação;
- quarentena;
- remediação;
- reprocessamento controlado;
- *replay*;
- *backfill*;
- rejeição da versão candidata.

Uma tentativa de certificação com falha não deve exigir modificação destrutiva da versão anteriormente certificada.

### 10.12 Última Versão Reconhecidamente Confiável

A plataforma deve preservar a última versão analítica certificada com sucesso enquanto uma nova candidata estiver sendo processada e validada.

Conceitualmente:

**Versão Certificada N → permanece disponível**

enquanto:

**Versão Candidata N+1 → processamento e validação**

Se a Versão Candidata N+1 falhar em um controle crítico:

**Versão Certificada N → permanece publicada**

**Versão Candidata N+1 → não é promovida**

Isso impede que uma atualização com falha substitua automaticamente dados analíticos reconhecidamente confiáveis por uma versão candidata reconhecidamente inválida.

A versão publicada pode se tornar desatualizada durante uma falha prolongada, e essa degradação da atualidade deve permanecer observável.

Dados desatualizados, porém certificados, e dados atuais, porém não certificados, representam estados operacionais diferentes e não devem ser confundidos.

### 10.13 Decisão de Certificação

A certificação é uma decisão governada explícita baseada na conclusão bem-sucedida dos controles exigidos.

Uma versão candidata da Gold pode ser certificada somente quando:

- o processamento obrigatório da Gold tiver sido concluído com sucesso;
- os controles críticos de qualidade tiverem sido aprovados;
- os controles obrigatórios de reconciliação tiverem sido aprovados;
- os metadados necessários estiverem disponíveis;
- os critérios de certificação aplicáveis tiverem sido atendidos.

A certificação deve produzir um resultado auditável identificando, conforme aplicável:

- conjunto de dados ou produto de dados;
- versão candidata;
- status da certificação;
- execução da validação;
- resultados dos controles;
- *timestamp* da certificação;
- versão de processamento;
- versão aplicável das regras de qualidade.

A certificação é, portanto, um estado de processamento sustentado por evidências, e não apenas um rótulo descritivo associado a uma tabela.

### 10.14 Publicação Atômica na Certified Gold

Após uma certificação bem-sucedida, a versão candidata aprovada deve ser promovida de modo que os consumidores observem um estado certificado completo.

Os consumidores não devem observar uma combinação parcialmente publicada de estruturas certificadas antigas e novas.

Conceitualmente:

**Construir Candidata → Validar → Reconciliar → Certificar → Publicar Atomicamente**

O mecanismo exato de publicação depende da implementação de disponibilização e deve ser validado durante a fase de laboratório.

A arquitetura exige o seguinte comportamento:

**Os consumidores veem a versão certificada anterior ou a nova versão certificada completa, nunca um estado intermediário incompleto.**

O *timestamp* em que a nova versão certificada se torna disponível é representado arquiteturalmente como `certified_gold_publish_ts`.

### 10.15 Atualidade *End-to-End*

A certificação e a publicação fazem parte do caminho de atualidade *end-to-end*.

A medição de atualidade da V1 permanece:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

Isso significa que a transformação bem-sucedida da Gold não interrompe a medição de atualidade.

O tempo gasto na validação de qualidade, reconciliação, certificação e publicação contribui para a atualidade analítica percebida pelos consumidores governados.

A plataforma deve, portanto, medir essas etapas, em vez de tratar a certificação como uma sobrecarga operacional invisível.

### 10.16 Observabilidade de Qualidade e Reconciliação

Qualidade e reconciliação devem expor tanto o estado atual quanto evidências históricas de execução.

A observabilidade inicial deve considerar, conforme aplicável:

- controles de qualidade executados;
- controles aprovados;
- controles com falha;
- falhas críticas;
- alertas não críticos;
- resultados da reconciliação;
- diferenças de reconciliação;
- limites aplicados;
- versão candidata;
- versão certificada;
- versões candidatas rejeitadas;
- status da certificação;
- duração da validação;
- duração da reconciliação;
- duração da certificação;
- duração da publicação;
- *timestamp* da última certificação bem-sucedida;
- idade da versão certificada atualmente publicada.

O monitoramento deve possibilitar distinguir:

**pipeline saudável**

de:

**dados certificados e atuais**.

### 10.17 Evolução das Regras de Qualidade

As regras de qualidade e reconciliação podem evoluir à medida que os produtos analíticos amadurecem.

As alterações nas regras devem ser controladas porque podem modificar se os mesmos dados são considerados aptos para certificação.

As alterações podem incluir:

- novos controles;
- controles removidos;
- alterações de limites;
- alterações de severidade;
- alterações em regras de negócio;
- alterações de reconciliação.

A evolução das regras deve preservar versionamento suficiente para determinar quais critérios de validação foram aplicados a uma versão certificada.

Uma versão histórica previamente certificada não deve ser representada retroativamente como se tivesse sido aprovada por uma regra de qualidade que não existia quando aquela versão foi certificada.

Quando novas regras exigirem reavaliação histórica, essa atividade deve ser representada como um processo explícito de validação ou recertificação.

### 10.18 Garantias de Qualidade e Reconciliação

No limite de qualidade e reconciliação, a arquitetura exige as seguintes garantias:

- processamento técnico bem-sucedido não implica automaticamente certificação analítica;
- versões candidatas governadas da Gold são validadas antes da publicação na Certified Gold;
- controles de qualidade refletem expectativas técnicas e de negócio explícitas;
- controles críticos e não críticos permanecem distinguíveis;
- limites são explícitos e governados;
- a reconciliação compara dados semanticamente equivalentes, e não contagens físicas arbitrárias de linhas;
- as janelas de reconciliação são determinísticas e reproduzíveis;
- dados que chegam com atraso seguem comportamento explícito de processamento e recertificação;
- falhas em controles críticos bloqueiam a promoção da versão candidata;
- a última versão certificada reconhecidamente confiável permanece disponível durante atualizações com falha;
- a certificação produz evidências auditáveis;
- a publicação na Certified Gold é atômica do ponto de vista do consumidor;
- a latência de certificação e publicação contribui para o SLO *end-to-end*;
- a evolução das regras de qualidade permanece versionada e rastreável.

Essas garantias estabelecem o limite de validação entre dados analíticos processados e dados analíticos governados e autorizados para consumo.

---

## 11. Publicação na Certified Gold e Consumo Analítico

A **Certified Gold** é o limite de publicação governada da plataforma de Engenharia de Dados.

Uma versão candidata da Gold torna-se elegível para a Certified Gold somente após concluir os controles exigidos de processamento, validação de qualidade, reconciliação e certificação.

A Certified Gold representa o estado analítico que a plataforma autoriza explicitamente para consumo governado.

O caminho fundamental de publicação é:

**Versão Candidata da Gold → Validação de Qualidade → Reconciliação → Certificação → Publicação Atômica → Certified Gold → Consumo Analítico**

Os consumidores analíticos devem utilizar o limite de publicação certificada, em vez de depender diretamente de estados intermediários de processamento quando dados governados forem necessários.

Na arquitetura V1, o **Power BI** consome as estruturas analíticas certificadas publicadas por meio da **Certified Gold**.

### 11.1 Limite da Certified Gold

A Certified Gold separa dados analíticos processados com sucesso de dados analíticos explicitamente aprovados para consumo governado.

A distinção é:

**Gold**
→ dados analíticos orientados ao negócio que concluíram o processamento dimensional.

**Certified Gold**
→ dados da Gold que, adicionalmente, passaram pelos controles exigidos de qualidade, reconciliação, certificação e publicação.

Uma versão candidata da Gold não deve se tornar visível por meio da interface governada da Certified Gold apenas porque seu *job* de transformação foi concluído com sucesso.

O status de certificação deve permanecer explícito e auditável.

### 11.2 Versões Candidata e Publicada

A plataforma deve distinguir entre a versão atualmente disponível para consumidores governados e uma nova versão que esteja sendo preparada para publicação.

Conceitualmente:

**Versão Certificada N**
→ publicação governada atual.

**Versão Candidata N+1**
→ nova versão analítica sendo processada e validada.

Enquanto a Versão Candidata N+1 estiver em avaliação, a Versão Certificada N permanece disponível para os consumidores.

A versão candidata não deve substituir parcialmente a versão certificada durante o processamento ou a validação.

### 11.3 Publicação Bem-Sucedida

Quando a versão candidata conclui com sucesso todos os controles exigidos de certificação, ela se torna elegível para publicação.

A sequência de publicação é:

**Candidata Concluída → Qualidade Aprovada → Reconciliação Aprovada → Certificação Aprovada → Publicar**

A publicação deve expor o novo estado certificado como uma versão analítica completa.

Após uma publicação bem-sucedida:

**Versão Certificada N+1**
→ torna-se a versão governada atual.

A versão anteriormente certificada pode permanecer disponível de acordo com a política aplicável de retenção, *rollback*, auditoria ou recuperação.

### 11.4 Falha na Publicação da Versão Candidata

Se uma versão candidata falhar em um controle crítico de qualidade, reconciliação ou certificação, ela não deve substituir a versão certificada atual.

Conceitualmente:

**Versão Certificada N → permanece disponível**

**Versão Candidata N+1 → certificação falhou → não publicada**

A versão candidata com falha e suas evidências de validação devem permanecer identificáveis para investigação e remediação.

Uma atualização com falha pode fazer com que a versão certificada atual se torne mais antiga do que o objetivo de atualidade desejado.

Essa condição deve ser observável.

A plataforma deve distinguir entre:

**Certificada e Atual**

**Certificada, porém Desatualizada**

**Candidata, porém Não Certificada**

Esses estados possuem significados operacionais diferentes e não devem ser representados como equivalentes.

### 11.5 Publicação Atômica

A publicação certificada deve impedir que os consumidores observem um estado analítico parcialmente atualizado.

Quando múltiplas estruturas participarem do mesmo produto analítico governado, os consumidores não devem observar uma combinação inconsistente, como:

- novos dados de fatos com dimensões obrigatórias antigas;
- partições parcialmente atualizadas;
- resultados de agregação incompletos;
- uma combinação de estruturas candidatas e anteriormente certificadas.

O requisito arquitetural é:

**Os consumidores observam a versão certificada completa anterior ou a nova versão certificada completa.**

O mecanismo físico exato utilizado para alcançar a publicação atômica depende da implementação de disponibilização e deve ser validado durante a fase de laboratório.

Os possíveis mecanismos de implementação devem ser avaliados de acordo com sua capacidade de fornecer a semântica de publicação exigida e visível aos consumidores, e não selecionados apenas por conveniência.

### 11.6 *Timestamp* de Publicação

O *timestamp* em que uma versão certificada com sucesso se torna disponível para consumo governado é representado como:

`certified_gold_publish_ts`

Esse *timestamp* marca o ponto final da medição de atualidade analítica *end-to-end* da V1:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

O *timestamp* deve representar a disponibilidade real da publicação, e não apenas:

- a conclusão do processamento da Gold;
- a conclusão da validação de qualidade;
- o momento da decisão de certificação;
- o início da publicação.

Essa distinção garante que a medição de atualidade reflita quando os consumidores governados puderam efetivamente acessar o resultado certificado.

### 11.7 Contrato de Consumo Analítico

Um produto analítico governado deve expor um contrato de consumo definido.

O contrato deve, preferencialmente, identificar, conforme aplicável:

- nome do produto;
- propósito de negócio;
- grão analítico;
- dimensões;
- medidas;
- definições de negócio;
- expectativa de atualidade;
- status de certificação;
- responsabilidade;
- classificação de sensibilidade;
- expectativas de acesso;
- garantias de qualidade aplicáveis.

O contrato de consumo analítico é distinto do contrato de evento utilizado no caminho de integração do Kafka.

Conceitualmente:

**Contrato de Evento**
→ governa a estrutura trocada entre produtores e consumidores de eventos.

**Contrato de Consumo Analítico**
→ governa o significado e as expectativas do produto analítico publicado.

Ambos são contratos, mas operam em limites arquiteturais diferentes.

### 11.8 Consumo pelo Power BI

Na V1, o **Power BI** é o principal consumidor analítico da Certified Gold.

O Power BI deve consumir estruturas analíticas governadas expostas por meio do limite de publicação certificada, em vez de depender diretamente de:

- *topics* do Kafka;
- objetos da Bronze;
- conjuntos de dados da Silver;
- versões candidatas não certificadas da Gold.

Isso preserva a separação entre as camadas de processamento e o consumo governado.

O modelo semântico do Power BI pode introduzir cálculos e relacionamentos orientados à apresentação quando apropriado, mas as definições de negócio que determinam o significado analítico certificado devem permanecer governadas e documentadas, em vez de existirem apenas dentro de um relatório.

O *dashboard* deve, portanto, ser tratado como consumidor do produto analítico governado, e não como o local em que semânticas de dados *upstream* ausentes são silenciosamente inventadas.

### 11.9 Isolamento do Consumidor em Relação ao Processamento

Os consumidores analíticos não deveriam precisar conhecer o estado interno de processamento da Bronze, Silver ou das execuções candidatas da Gold para consultar o produto certificado atual.

Processamento e consumo devem permanecer desacoplados.

Por exemplo, enquanto uma nova versão candidata está sendo construída:

**Power BI → Versão Certificada N**

enquanto:

**Engenharia de Dados → Versão Candidata N+1**

Somente após a certificação e publicação bem-sucedidas o estado visível ao consumidor é alterado.

Esse isolamento impede que consultas analíticas normais observem trabalhos de processamento incompletos.

### 11.10 Falha de Publicação

Uma falha pode ocorrer depois que os controles de certificação são aprovados, mas antes que a nova versão se torne disponível com sucesso aos consumidores.

O sucesso da certificação e o sucesso da publicação devem, portanto, permanecer distinguíveis.

Conceitualmente:

**Validação Aprovada → Certificação Aprovada → Falha de Publicação**

Nesse cenário:

- a publicação certificada anterior deve permanecer disponível sempre que tecnicamente possível;
- a nova versão candidata não deve ser representada como publicada com sucesso;
- a falha de publicação deve ser observável;
- o comportamento de novas tentativas deve preservar a correção da publicação;
- `certified_gold_publish_ts` não deve ser registrado como bem-sucedido até que a publicação seja efetivamente concluída.

Uma versão candidata não é a versão atual da Certified Gold até que o limite de publicação governada tenha sido atualizado com sucesso.

### 11.11 *Rollback*

A estratégia de publicação deve dar suporte a *rollback* controlado quando for posteriormente determinado que uma versão recém-publicada precisa ser retirada.

O *rollback* deve identificar:

- a versão atualmente publicada;
- a versão certificada anterior elegível;
- o motivo do *rollback*;
- o produto afetado;
- *timestamp* do *rollback*;
- status da validação;
- comportamento necessário de atualização *downstream*.

O *rollback* não deve reescrever silenciosamente o histórico de certificação.

Se uma versão tiver sido certificada e publicada e posteriormente for retirada, o registro histórico deve preservar essa sequência de eventos.

A capacidade de *rollback* deve ser validada durante a implementação, em vez de ser presumida apenas pela retenção de versões.

### 11.12 Atualidade para os Consumidores

Os consumidores devem ser capazes de determinar a atualidade dos dados certificados que estão utilizando.

Uma consulta bem-sucedida não comprova que os dados retornados atendam ao objetivo de atualidade esperado.

A plataforma deve, portanto, expor ou permitir derivar informações como:

- versão certificada atual;
- *timestamp* de certificação;
- `certified_gold_publish_ts`;
- período mais recente aplicável da origem;
- status de atualidade;
- conformidade com o SLO, quando aplicável.

Isso permite que a plataforma distinga:

**dados disponíveis**

de:

**dados disponíveis e suficientemente atuais**.

### 11.13 Comportamento dos Consumidores Durante Desatualização

Se a última versão certificada reconhecidamente confiável permanecer disponível enquanto novas versões candidatas falham na certificação ou publicação, os consumidores podem continuar consultando essa versão.

A política do produto deve definir como uma desatualização prolongada será comunicada.

Dependendo do caso de uso analítico, isso pode incluir:

- indicadores de atualidade;
- alertas;
- alertas de monitoramento;
- informações de status no *dashboard*;
- restrições temporárias de consumo para produtos críticos.

A arquitetura não exige que dados certificados desatualizados sejam silenciosamente removidos apenas porque o SLO de atualidade não foi atendido.

Disponibilidade, certificação e atualidade são características separadas e devem permanecer observáveis de forma independente.

### 11.14 Controle de Acesso

A Certified Gold deve ser exposta somente a consumidores autorizados, de acordo com as políticas aplicáveis de segurança e governança.

Os controles de acesso devem, preferencialmente, operar no limite apropriado de disponibilização e seguir os princípios de privilégio mínimo.

O fato de os dados terem passado pela certificação de qualidade não implica que todos os consumidores estejam autorizados a acessá-los.

A publicação deve, portanto, preservar tanto:

- certificação analítica;
- governança de acesso.

Atributos analíticos sensíveis ou restritos devem permanecer protegidos de acordo com sua classificação e uso autorizado.

### 11.15 Metadados do Produto Certificado

Os produtos analíticos certificados devem expor metadados suficientes para dar suporte à descoberta, interpretação, governança e compreensão operacional.

Os metadados devem, preferencialmente, incluir, conforme aplicável:

- nome do produto;
- descrição;
- responsável;
- versão atual;
- status de certificação;
- *timestamp* de publicação;
- versão de processamento;
- versão das regras de qualidade;
- domínios de origem;
- referência de linhagem;
- grão;
- medidas;
- dimensões;
- expectativa de atualidade;
- classificação de sensibilidade;
- referência de documentação.

Os metadados devem permitir que um consumidor ou operador compreenda o que está sendo consumido sem precisar inspecionar o código interno de processamento.

### 11.16 Observabilidade da Publicação

A publicação na Certified Gold e o consumo analítico devem expor informações suficientes para determinar se o produto governado está disponível, atual e sendo consumido com sucesso.

A observabilidade inicial deve considerar, conforme aplicável:

- versão candidata;
- versão certificada atual;
- resultado da certificação;
- status da publicação;
- falhas de publicação;
- novas tentativas de publicação;
- duração da publicação;
- `certified_gold_publish_ts`;
- idade dos dados certificados;
- status do SLO de atualidade;
- eventos de *rollback*;
- disponibilidade para os consumidores;
- status de atualização do Power BI, quando integrado;
- falhas de acesso.

A observabilidade deve distinguir entre:

**Sucesso do Processamento da Gold**

**Sucesso da Certificação**

**Sucesso da Publicação**

**Disponibilidade para o Consumidor**

Esses são estados operacionais relacionados, porém distintos.

### 11.17 Garantias de Consumo Analítico

No limite da Certified Gold e do consumo analítico, a arquitetura exige as seguintes garantias:

- consumidores governados acessam dados analíticos certificados, e não estados intermediários de processamento;
- versões candidatas e publicadas permanecem distintas;
- versões candidatas com falha não substituem a última versão certificada reconhecidamente confiável;
- a publicação é atômica do ponto de vista do consumidor;
- `certified_gold_publish_ts` representa a disponibilidade governada real;
- contratos de consumo analítico permanecem distintos dos contratos de eventos;
- o Power BI consome o limite de publicação governada;
- o processamento interno permanece isolado do consumo analítico normal;
- o sucesso da certificação não implica sucesso da publicação;
- o *rollback* permanece controlado e auditável;
- os consumidores podem determinar a atualidade dos dados certificados;
- dados certificados desatualizados permanecem distinguíveis de dados certificados atuais;
- a certificação não ignora os requisitos de controle de acesso;
- os metadados do produto certificado dão suporte à interpretação e à governança;
- a publicação e a disponibilidade para os consumidores permanecem observáveis.

Essas garantias concluem o caminho normal de processamento *end-to-end*, desde a alteração operacional confirmada até o consumo analítico governado.

---

## 12. Tratamento de Falhas, *Replay* e Recuperação

Falhas são condições operacionais esperadas em uma plataforma distribuída de Engenharia de Dados e devem ser tratadas por meio de comportamentos de recuperação explícitos, observáveis e testáveis.

A arquitetura não deve depender da disponibilidade contínua de todos os componentes para preservar a correção do processamento.

Uma falha pode atrasar a atualidade analítica, criar *backlog*, exigir nova tentativa, acionar *replay* ou exigir reconstrução controlada. Ela não deve fazer silenciosamente com que dados elegíveis desapareçam, sejam logicamente duplicados, fiquem incorretamente reordenados ou substituam uma versão analítica certificada reconhecidamente confiável.

A recuperação baseia-se no princípio de que o processamento deve, preferencialmente, ser retomado a partir do estado durável disponível mais seguro, em vez de reiniciar automaticamente todo o *pipeline* *end-to-end*.

A hierarquia de recuperação da V1 é:

**Kafka → Bronze → Silver → Backup**

A fonte de recuperação apropriada depende da localização da falha, do histórico retido, do estado do processamento e do requisito de reconstrução.

### 12.1 Domínios de Falha

Falhas podem ocorrer em diferentes limites arquiteturais e devem ser diagnosticadas de acordo com a etapa que afetam.

Os domínios de falha relevantes incluem:

- captura de alterações na origem;
- produção de eventos pelo Debezium;
- tratamento de *schema* ou contrato;
- transporte pelo Kafka;
- processamento dos consumidores;
- persistência na Bronze;
- transformação na Silver;
- processamento dimensional na Gold;
- validação de qualidade;
- reconciliação;
- certificação;
- publicação na Certified Gold;
- consumo analítico;
- orquestração;
- dependências de infraestrutura.

Uma falha em um domínio não deve ser automaticamente interpretada como falha de todos os componentes *downstream* ou *upstream*.

A plataforma deve preservar estado e observabilidade suficientes para identificar o limite de processamento afetado.

### 12.2 Classificação de Falhas

As falhas devem, preferencialmente, ser classificadas de acordo com a possibilidade de serem resolvidas razoavelmente por uma nova tentativa normal.

Conceitualmente, as falhas podem ser:

**Transitórias**
→ condições temporárias que podem ter sucesso quando tentadas novamente.

Os exemplos podem incluir interrupção temporária de rede, indisponibilidade temporária de serviço ou contenção de recursos de curta duração.

**Persistentes**
→ condições que continuam até que configuração, código, infraestrutura ou dados sejam corrigidos.

Os exemplos podem incluir contratos incompatíveis, lógica de transformação inválida, histórico necessário indisponível ou falha persistente de armazenamento.

**Relacionadas aos Dados**
→ condições causadas por entradas que não podem satisfazer com segurança as regras aplicáveis de processamento ou qualidade.

Os exemplos podem incluir tipos inválidos, relacionamentos obrigatórios não resolvidos ou valores fora das regras de negócio governadas.

**Críticas para Recuperação**
→ condições nas quais a continuação incremental normal já não é suficiente para garantir completude ou correção.

Os exemplos podem incluir histórico obrigatório do Kafka ou CDC que não esteja mais disponível.

A classificação determina o comportamento apropriado de nova tentativa, quarentena, *replay*, *rebuild*, escalonamento ou remediação.

### 12.3 Nova Tentativa

Uma nova tentativa é apropriada quando a mesma operação de processamento pode ser executada novamente com segurança e espera-se que a falha seja temporária.

O comportamento de novas tentativas deve preservar a idempotência.

Uma nova tentativa não deve criar saída duplicada incorreta apenas porque a mesma unidade de processamento foi executada mais de uma vez.

As políticas de novas tentativas devem, preferencialmente, definir, conforme aplicável:

- tipos de falha que permitem nova tentativa;
- número máximo de tentativas;
- comportamento de atraso ou *backoff*;
- critérios de escalonamento;
- requisitos de observabilidade;
- estado final de falha.

Novas tentativas silenciosas e infinitas não são uma estratégia de recuperação aceitável.

Um componente que tente continuamente sem progredir deve permanecer operacionalmente visível.

### 12.4 Checkpoints de Processamento

A recuperação exige conhecimento do último estado de processamento concluído com segurança.

Diferentes etapas utilizam diferentes formas de posição de processamento ou estado durável.

Os exemplos incluem:

- LSN da origem;
- partição do Kafka e *offset* confirmado;
- objetos persistidos na Bronze;
- limites de processamento da Silver;
- versões de processamento da Gold;
- versões candidatas e publicadas certificadas.

Um *checkpoint* é significativo somente quando o trabalho protegido por ele tiver atendido à garantia de durabilidade exigida.

Por exemplo:

**Offset do Kafka confirmado**
deve implicar que a persistência correspondente e protegida na Bronze já tenha sido concluída com sucesso.

A recuperação não deve avançar a partir de um *checkpoint* cujo trabalho protegido esteja incompleto.

### 12.5 Recuperação a partir do Kafka

O Kafka é a fonte de recuperação preferencial quando os eventos necessários ainda estiverem disponíveis dentro da retenção e o consumidor puder retomar com segurança a partir dos *offsets* confirmados aplicáveis.

Esse é o caminho normal de recuperação para uma interrupção temporária do consumidor.

Conceitualmente:

**Falha do Consumidor → Reinicializar → Retomar a partir do Offset Confirmado → Reentrega se Necessário → Continuar Processamento**

A entrega *at-least-once* significa que alguns eventos podem ser entregues novamente após a recuperação.

A idempotência *downstream* deve tornar esse comportamento seguro.

A recuperação a partir do Kafka deve verificar:

- se os *offsets* necessários permanecem disponíveis;
- se as atribuições de partições são válidas;
- se o estado do grupo de consumidores é compreendido;
- se a reentrega é tratada corretamente;
- se o *backlog* é observável;
- se as garantias de ordenação permanecem preservadas;
- se a capacidade de *catch-up* é suficiente.

### 12.6 Recuperação a partir da Bronze

Quando o histórico necessário do Kafka não estiver mais disponível, ou quando camadas *downstream* exigirem reconstrução independente do transporte pelo Kafka, a Bronze torna-se a principal fonte histórica durável de recuperação.

Os exemplos incluem:

- reconstruir a Silver após alterações de transformação;
- reconstruir a Silver após corrupção ou perda;
- reconstruir a Gold a partir do histórico padronizado;
- reprocessar eventos históricos além da retenção do Kafka;
- aplicar lógica *downstream* corrigida.

O *replay* da Bronze deve preservar:

- identidade original do evento;
- *timestamps* originais da origem;
- metadados originais de posição na origem, quando retidos;
- versão original do contrato;
- distinção entre ingestão original e execução do *replay*;
- linhagem até a execução do *replay* e a versão de processamento.

A recuperação a partir da Bronze não deve fazer com que eventos submetidos a *replay* pareçam novas alterações originadas na fonte.

### 12.7 Recuperação a partir da Silver

A Silver pode ser utilizada como fonte de recuperação quando a reconstrução da Bronze for desnecessária e os dados padronizados necessários permanecerem válidos para o objetivo de recuperação.

Os exemplos podem incluir:

- reconstruir a Gold após alterações na lógica dimensional;
- reconstruir a Gold após perda do AtlasWarehouse;
- executar novamente qualidade e reconciliação sobre dados inalterados da Silver;
- regenerar um produto analítico a partir de uma base padronizada já validada.

A recuperação a partir da Silver é apropriada somente quando a alteração de transformação exigida não invalida a própria representação da Silver.

Se a lógica da Silver ou a interpretação do contrato fizer parte do defeito, a recuperação deve começar a partir da Bronze ou de outra fonte válida anterior.

### 12.8 Recuperação a partir de Backup

O *backup* é a fonte final de recuperação na hierarquia da V1 quando o histórico necessário de processamento *online* estiver indisponível, corrompido ou for insuficiente para o objetivo de recuperação.

A recuperação a partir de *backup* pode ser aplicada ao estado da plataforma, estruturas analíticas, metadados ou dados históricos de acordo com a estratégia de *backup* implementada.

A recuperação a partir de *backup* não deve ser tratada como automaticamente equivalente à restauração do estado atual completo da plataforma.

Após a restauração, a plataforma ainda pode precisar:

- identificar o ponto de recuperação restaurado;
- determinar a lacuna de dados após esse ponto;
- executar *replay* dos eventos retidos;
- reprocessar camadas *downstream*;
- reconciliar dados restaurados e recém-processados;
- recertificar produtos analíticos afetados.

O *backup*, portanto, fornece uma base de recuperação, e não necessariamente o estado analítico final recuperado.

### 12.9 Seleção da Fonte de Recuperação

O processo de recuperação deve, preferencialmente, começar a partir do estado durável confiável mais recente capaz de atender ao objetivo de reconstrução necessário.

Conceitualmente:

**O Kafka pode fornecer com segurança o histórico necessário?**
→ recuperar a partir do Kafka.

**Se não, a Bronze pode fornecer o histórico necessário?**
→ recuperar a partir da Bronze.

**Se a reconstrução da Bronze for desnecessária e a Silver for válida para o objetivo**
→ recuperar a partir da Silver.

**Se o histórico online necessário estiver indisponível**
→ recuperar a partir do Backup.

A fonte de recuperação não deve ser selecionada apenas porque é a opção operacionalmente mais fácil.

Ela deve fornecer as informações necessárias para restaurar correção e completude.

### 12.10 Replay

*Replay* significa processar novamente entradas históricas preservadas por meio de uma ou mais etapas de processamento *downstream*.

O *replay* pode ser necessário para:

- recuperação;
- correção de defeitos;
- alterações de transformação;
- reconstrução histórica;
- reavaliação de regras de qualidade;
- reconstrução de produto analítico.

O *replay* deve definir:

- fonte do *replay*;
- intervalo histórico;
- famílias de eventos ou conjuntos de dados afetados;
- etapas de processamento de destino;
- versão de processamento;
- saída esperada;
- critérios de validação;
- impacto nos dados atualmente publicados.

O *replay* deve permanecer distinguível do processamento incremental normal.

### 12.11 Segurança do Replay

O *replay* não deve corromper estado válido existente.

O mecanismo de *replay* deve considerar:

- idempotência;
- desduplicação;
- versões de processamento;
- substituição ou coexistência das saídas;
- histórico dimensional;
- estabilidade das chaves substitutas;
- duplicação de fatos;
- estado de certificação;
- limites de publicação.

Um *replay* não deve publicar automaticamente seus resultados apenas porque o processamento foi concluído.

Quando o *replay* afetar produtos analíticos governados, a versão candidata resultante deve passar pelos controles aplicáveis de qualidade, reconciliação, certificação e publicação.

### 12.12 Reprocessamento

Reprocessamento significa executar intencionalmente a lógica de processamento novamente para um escopo histórico de entrada definido.

O reprocessamento pode utilizar a mesma versão de processamento ou uma versão diferente, dependendo do objetivo de recuperação, correção ou reconstrução.

Os exemplos incluem:

- processar novamente um escopo histórico da Bronze por meio da lógica da Silver;
- processar novamente dados históricos da Silver após a correção de um defeito de transformação;
- recalcular a Gold após uma correção no modelo dimensional;
- recalcular uma medida após uma alteração governada de regra de negócio;
- regenerar estado *downstream* a partir de um limite histórico confiável de processamento.

Reprocessamento é distinto de nova tentativa.

**Nova Tentativa**
→ repete uma operação porque a tentativa anterior falhou ou produziu resultado incerto.

**Reprocessamento**
→ revisita intencionalmente um escopo histórico de entrada por meio da lógica de processamento.

Reprocessamento também é distinto de *rebuild*.

**Reprocessamento**
→ descreve a execução repetida da lógica de processamento.

**Rebuild**
→ descreve a reconstrução de um estado derivado.

Um *rebuild* pode utilizar reprocessamento como parte de sua implementação.

O reprocessamento deve definir:

- escopo de entrada;
- limite de processamento;
- versão de processamento;
- estado resultante esperado;
- requisitos de idempotência;
- critérios de validação;
- impacto na certificação, quando aplicável;
- linhagem até a execução do reprocessamento.

### 12.13 Backfill

*Backfill* preenche um intervalo histórico ausente ou recém-exigido no escopo de processamento de destino.

O *backfill* pode ser necessário quando:

- uma nova estrutura de origem é integrada;
- um novo domínio é incorporado;
- dados históricos anteriores à ingestão normal por CDC são necessários;
- um intervalo histórico anteriormente indisponível torna-se recuperável;
- um novo produto analítico exige histórico mais antigo da origem.

O *backfill* deve definir:

- origem histórica;
- período da origem;
- método de extração ou *replay*;
- regras de contrato ou mapeamento;
- versão de processamento;
- camadas de destino;
- critérios de reconciliação;
- impacto na certificação.

Os dados de *backfill* devem permanecer operacionalmente distinguíveis dos novos dados incrementais recebidos, preservando os *timestamps* originais de vigência de negócio.

### 12.14 Rebuild

Um *rebuild* reconstrói um conjunto de dados, camada, produto ou escopo histórico definido completo a partir de uma base confiável anterior.

Os exemplos incluem:

**Bronze → reconstruir Silver**

**Silver → reconstruir Gold**

**Bronze → reconstruir Silver → reconstruir Gold**

Um *rebuild* pode ser necessário quando o estado incremental já não puder ser considerado confiável ou quando uma alteração afetar um intervalo histórico suficientemente amplo.

Os procedimentos de *rebuild* devem definir:

- fonte confiável;
- escopo afetado;
- versões de processamento;
- localização temporária da saída;
- critérios de validação;
- critérios de reconciliação;
- comportamento de publicação;
- plano de *rollback*.

A saída certificada existente deve, preferencialmente, permanecer protegida até que a versão candidata reconstruída conclua o processo de certificação exigido.

### 12.15 Recuperação e Versões de Contrato

A recuperação histórica pode encontrar múltiplas versões de contratos de eventos.

*Replay* e *rebuild* devem interpretar cada evento histórico de acordo com o contrato aplicável quando o evento foi produzido.

Um processo de recuperação não deve presumir que os dados históricos da Bronze estejam em conformidade com a versão mais recente do contrato.

Se um contrato histórico necessário não for mais diretamente suportado, deve existir um caminho explícito de migração ou normalização.

A remoção do suporte a uma versão antiga de contrato deve, portanto, considerar os requisitos de recuperação e reconstrução da plataforma.

### 12.16 Recuperação e Versões de Processamento

A recuperação também pode envolver múltiplas versões de processamento.

A plataforma deve preservar a distinção entre:

- a versão que originalmente produziu uma saída;
- a versão utilizada durante a recuperação ou *rebuild*.

Por exemplo:

**Processamento Original da Silver V1**

pode ser reconstruído posteriormente utilizando:

**Processamento da Silver V2**

A saída resultante deve permanecer atribuível à V2, em vez de ser representada como se tivesse sido produzida pela lógica histórica da V1.

Essa distinção dá suporte à reprodutibilidade e auditabilidade.

### 12.17 Recuperação e Certified Gold

As atividades de recuperação não devem ignorar o limite da Certified Gold.

Se recuperação, *replay*, *backfill* ou *rebuild* alterarem um produto analítico governado, a saída resultante será uma nova versão candidata até concluir com sucesso os controles exigidos.

Conceitualmente:

**Saída da Recuperação → Gold Candidata → Qualidade → Reconciliação → Certificação → Publicação**

A versão atualmente certificada deve, preferencialmente, permanecer disponível enquanto a versão candidata recuperada estiver sendo validada, sempre que tecnicamente possível.

O sucesso da recuperação, portanto, não implica automaticamente sucesso da publicação.

### 12.18 Recuperação de Backlog

Após uma interrupção, a chegada normal de eventos pode continuar enquanto o *backlog* acumulado está sendo processado.

A plataforma deve verificar se a capacidade recuperada de processamento é suficiente para reduzir o *backlog* enquanto também trata novas chegadas.

Conceitualmente:

**Taxa de Recuperação do Backlog = Taxa de Processamento - Taxa de Entrada**

Para que o *backlog* diminua:

**Taxa de Processamento > Taxa de Entrada**

Os testes de recuperação devem medir não apenas se o processamento foi reiniciado, mas se a plataforma retornou ao estado de atualidade esperado.

As medições relevantes incluem:

- *backlog* no início da recuperação;
- taxa de entrada;
- taxa de processamento;
- evento pendente mais antigo;
- taxa de redução do *backlog*;
- duração da recuperação;
- utilização de recursos;
- latência *end-to-end* durante a recuperação;
- tempo necessário para retornar ao SLO.

### 12.19 Ponto de Recuperação e Tempo de Recuperação

A recuperação deve ser avaliada utilizando objetivos explícitos de recuperação.

A plataforma deve, preferencialmente, medir, quando aplicável:

**Ponto de Recuperação**
→ quanto do estado de processamento ou dos dados pode precisar ser reconstruído após uma falha.

**Tempo de Recuperação**
→ quanto tempo a plataforma necessita para restaurar a capacidade necessária de processamento ou análise.

Esses conceitos podem ser formalizados como **Recovery Point Objective (RPO)** e **Recovery Time Objective (RTO)** quando o produto ou a plataforma exigir metas explícitas.

Os testes de laboratório da V1 devem, preferencialmente, medir o comportamento de recuperação observado antes que objetivos em nível de produção sejam declarados.

### 12.20 Falha Parcial

O processamento distribuído pode falhar parcialmente.

Por exemplo:

- uma partição do Kafka pode deixar de progredir enquanto outras continuam;
- um conjunto de dados da Silver pode falhar enquanto conjuntos não relacionados têm sucesso;
- uma dimensão da Gold pode falhar enquanto outra unidade de processamento é concluída;
- um produto analítico pode falhar na certificação enquanto outro permanece saudável.

A recuperação deve identificar o menor escopo afetado que seja seguro.

A arquitetura deve, preferencialmente, evitar reconstruir dados saudáveis e não relacionados quando um limite de recuperação mais restrito puder restaurar a correção com segurança.

No entanto, minimizar o escopo da recuperação não deve criar um estado analítico internamente inconsistente.

### 12.21 Registros Venenosos

Um evento ou registro específico pode falhar repetidamente no processamento enquanto os dados ao redor permanecem válidos.

Esse registro não deve causar um ciclo infinito e silencioso de novas tentativas que impeça indefinidamente todo o trabalho recuperável subsequente de avançar.

A etapa de processamento aplicável deve definir comportamento explícito para falhas persistentes no nível do registro, que pode incluir:

- quarentena;
- tratamento controlado por *dead-letter*, quando implementado;
- remediação manual;
- *replay* corrigido;
- escalonamento.

O registro com falha deve permanecer rastreável até sua entrada original e o motivo da falha.

Ignorar um registro venenoso não deve ocorrer silenciosamente nem ser interpretado como processamento completo e bem-sucedido.

### 12.22 Validação da Recuperação

A reinicialização bem-sucedida de um componente não comprova que a recuperação teve sucesso.

A recuperação deve validar o estado resultante dos dados.

Dependendo da falha, a validação pode incluir:

- cobertura esperada de eventos;
- detecção de duplicidades;
- continuidade da posição na origem;
- continuidade dos *offsets* do Kafka;
- completude da Bronze;
- reconciliação da Silver;
- reconciliação da Gold;
- consistência dimensional;
- controles de qualidade;
- status da certificação;
- atualidade *end-to-end*.

A recuperação é concluída somente quando as garantias necessárias de processamento e dados tiverem sido restauradas.

### 12.23 Evidências de Recuperação

Cenários críticos de recuperação devem produzir evidências.

As evidências devem, preferencialmente, identificar, conforme aplicável:

- falha introduzida;
- *timestamp* da falha;
- componente afetado;
- estado do processamento antes da falha;
- fonte de recuperação;
- ação de recuperação;
- comportamento de reentrega ou *replay*;
- resultado do tratamento de duplicidades;
- resultado da reconciliação;
- *backlog* acumulado;
- duração da recuperação;
- estado final do processamento;
- estado final da certificação;
- impacto no SLO.

Essas evidências permitem que as afirmações sobre recuperação sejam demonstradas, e não apenas descritas.

### 12.24 Observabilidade da Recuperação

O comportamento de recuperação deve permanecer observável em toda a plataforma.

A observabilidade inicial da recuperação deve considerar, conforme aplicável:

- estado de falha do componente;
- tentativas de nova execução;
- último *checkpoint* bem-sucedido;
- *offsets* confirmados do Kafka;
- *lag* dos consumidores;
- evento pendente mais antigo;
- execuções de *replay*;
- execuções de reprocessamento;
- execuções de *backfill*;
- estado de *rebuild*;
- registros em quarentena;
- fonte de recuperação;
- duração da recuperação;
- taxa de redução do *backlog*;
- estado da reconciliação;
- estado da certificação;
- degradação da atualidade;
- tempo de retorno ao SLO.

A observabilidade deve permitir distinguir entre:

**componente reinicializado**

de:

**processamento recuperado**

e de:

**correção dos dados restaurada**.

### 12.25 Garantias de Tratamento de Falhas e Recuperação

No limite de tratamento de falhas e recuperação, a arquitetura exige as seguintes garantias:

- falhas são condições operacionais explícitas, e não estados excepcionais indefinidos;
- a recuperação é retomada a partir do estado durável apropriado mais seguro;
- o comportamento de novas tentativas permanece limitado, observável e idempotente;
- *checkpoints* de processamento protegem apenas trabalho que atingiu o estado durável exigido;
- o Kafka é preferido para recuperação normal de eventos ainda retidos;
- a Bronze fornece a principal base histórica durável de reconstrução;
- a Silver pode ser utilizada quando seu estado padronizado permanecer válido para o objetivo de recuperação;
- o *backup* fornece a base final de recuperação quando o histórico *online* necessário estiver indisponível;
- *replay*, reprocessamento, *backfill* e *rebuild* permanecem conceitualmente distintos e rastreáveis;
- versões históricas de contrato e processamento permanecem interpretáveis durante a recuperação;
- a saída analítica recuperada não ignora os controles de qualidade, reconciliação, certificação ou publicação;
- a recuperação de *backlog* é medida pelo retorno ao processamento normal e à atualidade, e não apenas pela reinicialização de componentes;
- registros venenosos persistentes não desaparecem silenciosamente;
- falhas parciais são recuperadas no menor escopo seguro;
- o sucesso da recuperação inclui validação da correção dos dados;
- cenários críticos de recuperação produzem evidências preservadas.

Essas garantias estabelecem um modelo de recuperação no qual a plataforma pode falhar, retomar, reconstruir e demonstrar a restauração da correção sem depender de suposições silenciosas.

---

## 13. Rastreabilidade e Linhagem *End-to-End*

A plataforma de Engenharia de Dados deve preservar rastreabilidade e linhagem suficientes para explicar como os dados analíticos governados foram produzidos a partir dos dados operacionais da origem.

A rastreabilidade permite que a plataforma identifique e acompanhe um evento, registro, execução de processamento ou resultado analítico específico através dos limites arquiteturais.

A linhagem descreve os relacionamentos entre dados de origem, transformações, conjuntos de dados derivados, estruturas analíticas e produtos de dados publicados.

Em conjunto, essas capacidades devem dar suporte à investigação operacional, análise de qualidade dos dados, recuperação, auditoria, análise de impacto, *debugging* e confiança analítica.

O caminho fundamental de linhagem é:

**AtlasCommerce → CDC → Kafka → Bronze → Silver → Gold → Certified Gold → Consumo Analítico**

A plataforma deve preservar metadados suficientes em cada limite para reconstruir o caminho de processamento aplicável sem depender exclusivamente de *logs* da aplicação ou da memória humana.

### 13.1 Limite de Rastreabilidade e Linhagem

A rastreabilidade começa no limite da origem operacional e continua até a publicação analítica governada.

Cada etapa de processamento deve preservar ou gerar os identificadores e metadados necessários para relacionar sua saída à entrada *upstream* aplicável e à execução de processamento.

A rastreabilidade deve dar suporte tanto à:

**Rastreabilidade Direta**
→ determinar quais dados e produtos *downstream* foram afetados por um evento da origem ou alteração de processamento.

**Rastreabilidade Reversa**
→ determinar quais dados da origem, transformações e versões de processamento contribuíram para um resultado analítico *downstream*.

A granularidade exata pode diferir entre as camadas, mas a cadeia de linhagem não deve ser silenciosamente interrompida em um limite de transformação.

### 13.2 Rastreabilidade da Origem

O limite de captura da origem deve preservar informações suficientes para identificar a origem operacional de uma alteração capturada.

Os metadados relevantes podem incluir:

- sistema de origem;
- banco de dados da origem;
- *schema* da origem;
- tabela da origem;
- chave primária ou de negócio da origem;
- operação na origem;
- *timestamp* de confirmação na origem;
- metadados da transação na origem;
- posição na origem, como LSN;
- metadados de captura aplicáveis.

Essas informações estabelecem o relacionamento entre um evento e a alteração operacional confirmada da qual ele se originou.

A rastreabilidade da origem não deve depender apenas de consultas ao estado atual da origem, pois a entidade da origem pode ter sido alterada novamente depois que o evento original foi capturado.

### 13.3 Identidade do Evento

Cada evento lógico deve possuir uma identidade estável que permita à plataforma distinguir:

- um evento de outro;
- alterações subsequentes legítimas na mesma entidade de negócio;
- entrega repetida do mesmo evento lógico.

A identidade do evento deve permanecer rastreável através das etapas que exigirem linhagem no nível do evento.

Conceitualmente:

**Alteração na Origem → Identidade Estável do Evento → Kafka → Bronze → Rastreabilidade Downstream**

O mecanismo exato de geração da identidade do evento deve ser definido e validado durante a implementação.

Ele deve permanecer determinístico ou, de outra forma, estável de acordo com a arquitetura de eventos selecionada e não deve gerar uma nova identidade lógica apenas porque o mesmo evento foi submetido a *replay* ou reentregue.

### 13.4 Rastreabilidade no Kafka

Os metadados de transporte do Kafka devem dar suporte ao rastreamento de um evento através do limite de *event streaming*.

Os metadados relevantes incluem, conforme aplicável:

- *topic*;
- partição;
- *offset*;
- identidade do evento;
- versão do contrato de evento;
- posição na origem;
- *timestamp* do evento;
- metadados do produtor ou *connector*, quando necessários.

A combinação de *topic*, partição e *offset* identifica uma posição física de registro no Kafka.

Essa posição física é distinta da identidade lógica do evento.

Conceitualmente:

**Identidade Lógica**
→ identifica o evento.

**Posição no Kafka**
→ identifica onde uma entrega desse evento existe no Kafka.

Essa distinção é importante porque *replay* ou republicação podem criar uma posição de transporte diferente sem alterar o significado lógico do evento original.

### 13.5 Linhagem da Bronze

A Bronze deve preservar os metadados necessários para relacionar registros históricos persistidos às suas origens de evento e de fonte.

A linhagem da Bronze deve, preferencialmente, incluir, conforme aplicável:

- identidade do evento;
- sistema de origem;
- objeto da origem;
- identificador de negócio da origem;
- operação na origem;
- *timestamp* de confirmação na origem;
- posição na origem;
- versão do contrato de evento;
- *topic* do Kafka;
- partição do Kafka;
- *offset* do Kafka;
- *timestamp* de persistência na Bronze;
- identidade ou caminho do objeto da Bronze;
- identificador da execução de ingestão ou persistência.

A Bronze deve preservar o contexto original do evento mesmo quando os dados forem posteriormente submetidos a *replay*.

Os metadados de *replay* devem complementar a linhagem original, e não substituí-la.

### 13.6 Linhagem da Silver

A saída da Silver deve permanecer rastreável à entrada da Bronze e à lógica de transformação da qual foi derivada.

A linhagem da Silver deve, preferencialmente, identificar, conforme aplicável:

- escopo de entrada da Bronze;
- identidade ou identidades dos eventos de origem;
- objeto ou conjunto de objetos da origem;
- versão do contrato de evento;
- versão de processamento da Silver;
- identificador da execução de processamento;
- *timestamp* da transformação;
- contexto de padronização ou normalização;
- status de rejeição ou quarentena, quando aplicável.

Quando múltiplos registros da Bronze contribuírem para um resultado da Silver, o modelo de linhagem deve dar suporte ao relacionamento muitos-para-um aplicável.

Quando um registro da Bronze produzir múltiplas saídas da Silver, o modelo de linhagem deve dar suporte ao relacionamento um-para-muitos aplicável.

A linhagem deve, portanto, refletir a semântica da transformação, em vez de presumir uma correspondência permanente de um para um entre as camadas.

### 13.7 Linhagem da Gold

As estruturas da Gold devem permanecer rastreáveis à base da Silver e à lógica de processamento dimensional que as produziu.

A linhagem da Gold deve, preferencialmente, permitir identificar, conforme aplicável:

- escopo de entrada da Silver;
- versão de processamento da Gold;
- execução de processamento;
- grão do fato;
- identificadores de negócio;
- comportamento de resolução de dimensões;
- relacionamentos de chaves substitutas;
- versões dimensionais aplicáveis;
- derivação das medidas;
- *timestamp* da transformação.

Para medidas derivadas, a linhagem deve identificar a definição de negócio governada ou a regra de transformação utilizada para calcular a medida.

Um consumidor não deveria precisar inspecionar código SQL não documentado para descobrir o significado pretendido de uma medida analítica certificada.

### 13.8 Linhagem Dimensional

A modelagem dimensional introduz relacionamentos de linhagem que podem diferir dos relacionamentos físicos do sistema de origem.

Por exemplo, um identificador de cliente da origem pode ser mapeado para múltiplas chaves substitutas históricas sob comportamento SCD Tipo 2.

Conceitualmente:

**Cliente 157 da Origem**

pode corresponder a:

**CustomerKey 845 → versão histórica 1**

**CustomerKey 932 → versão histórica 2**

A linhagem deve preservar o relacionamento entre cada versão dimensional analítica e a entidade de negócio da origem que ela representa.

A linhagem dos fatos também deve permitir determinar por que uma versão dimensional específica foi selecionada de acordo com as regras temporais e de negócio aplicáveis.

### 13.9 Linhagem da Certified Gold

Uma versão analítica certificada deve permanecer atribuível ao contexto completo de processamento e validação que autorizou sua publicação.

A linhagem da Certified Gold deve, preferencialmente, identificar, conforme aplicável:

- produto analítico;
- versão certificada;
- versão candidata da Gold;
- versão de processamento da Gold;
- versão de processamento da Silver;
- versões aplicáveis dos contratos de eventos;
- versão das regras de qualidade;
- execução da reconciliação;
- resultado da certificação;
- *timestamp* da certificação;
- `certified_gold_publish_ts`;
- execução da publicação;
- cobertura do período da origem.

A linhagem da certificação deve permitir que a plataforma determine não apenas:

**quais dados foram publicados**

mas também:

**por que aquela versão foi considerada elegível para publicação governada**.

### 13.10 Linhagem do Produto Analítico

Os produtos analíticos devem documentar suas dependências *upstream*.

Para o produto inicial **Daily Sales**, a linhagem deve, em última instância, identificar as dependências relevantes entre:

- entidades de origem do AtlasCommerce;
- famílias de eventos capturadas;
- dados históricos da Bronze;
- conjuntos de dados padronizados da Silver;
- fatos e dimensões da Gold;
- controles de qualidade e reconciliação;
- publicação na Certified Gold;
- estruturas semânticas e de relatórios do Power BI.

Esse modelo de dependências dá suporte tanto à investigação técnica quanto à interpretação de negócio.

À medida que domínios e produtos analíticos adicionais forem introduzidos, o modelo de linhagem deve evoluir para representar dependências compartilhadas e estruturas analíticas conformadas.

### 13.11 Análise de Impacto *Forward*

A linhagem deve dar suporte à determinação do possível impacto *downstream* de uma alteração *upstream*.

Os exemplos incluem:

- alteração de coluna na origem;
- evolução do contrato de evento;
- alteração de transformação na Silver;
- alteração na definição de medida da Gold;
- alteração de dimensão;
- alteração de regra de qualidade;
- alteração de produto analítico.

Conceitualmente:

**Alteração Upstream → Identificar Dependências Downstream → Avaliar Impacto Antes do Deployment**

Por exemplo, uma alteração em uma dimensão conformada pode afetar múltiplos fatos e produtos analíticos.

A análise de impacto deve, portanto, considerar os relacionamentos de dependência, e não apenas o componente que está sendo diretamente modificado.

### 13.12 Investigação Reversa

A linhagem deve dar suporte à investigação de um resultado analítico a partir do limite do consumidor em direção à sua origem operacional.

Por exemplo, uma investigação pode começar com:

**valor no Power BI parece incorreto**

e prosseguir por:

**Certified Gold → Medida da Gold → Fato da Gold → Entrada da Silver → Eventos da Bronze → Alterações na Origem**

O objetivo não é necessariamente representar cada agregado analítico como um ponteiro direto para uma única linha da origem.

Resultados analíticos agregados podem depender de muitos registros *upstream*.

O modelo de linhagem deve, em vez disso, preservar relacionamentos e contexto de processamento suficientes para identificar o escopo aplicável de contribuição.

### 13.13 Linhagem através de Agregação

A agregação altera a granularidade da linhagem.

Por exemplo:

**1.000 registros de itens de transação**

podem contribuir para:

**50 registros de Daily Sales na Gold**

que podem contribuir para:

**um total em um visual do Power BI**.

A plataforma não deve fingir que um resultado agregado possui relacionamento de um para um com a origem.

A linhagem através de agregação deve, preferencialmente, identificar o conjunto de dados contribuinte, o escopo de processamento, o período de negócio, o grão, a lógica de transformação e a cobertura aplicável da origem.

Quando a linhagem no nível de registro for operacionalmente necessária, a implementação deve preservar os identificadores ou mecanismos de reconciliação necessários para dar suporte a esse requisito.

### 13.14 Linhagem através de Replay e Reprocessamento

*Replay*, reprocessamento, *backfill* e *rebuild* devem preservar a linhagem.

Um resultado reconstruído deve identificar tanto:

- o contexto original da origem ou da entrada histórica;
- a execução de recuperação ou processamento que produziu o novo resultado derivado.

Conceitualmente:

**Tempo Original do Evento ≠ Tempo do Replay**

e:

**Versão Original de Processamento ≠ Versão de Processamento da Recuperação**

quando uma lógica diferente for utilizada.

A atividade de recuperação deve, portanto, estender a linhagem, em vez de substituir a proveniência histórica.

### 13.15 Linhagem e Versões de Processamento

A plataforma pode conter múltiplas dimensões independentes de versão, incluindo:

- versão do contrato de evento;
- versão de processamento da Silver;
- versão de processamento da Gold;
- versão das regras de qualidade;
- versão do produto analítico certificado.

Essas versões descrevem diferentes aspectos arquiteturais.

A linhagem deve preservar seus relacionamentos para que a plataforma possa responder a perguntas como:

- qual contrato de evento foi utilizado;
- qual lógica da Silver interpretou o evento;
- qual lógica da Gold produziu a estrutura analítica;
- quais regras de qualidade a validaram;
- qual versão certificada a expôs aos consumidores.

Os identificadores de versão não devem ser combinados em um único campo genérico `version` quando isso tornar seu significado ambíguo.

### 13.16 Identificadores de Correlação e Execução

As execuções de processamento devem, preferencialmente, utilizar identificadores estáveis de execução ou correlação quando necessário para conectar *logs*, métricas, transformações e dados resultantes.

Os exemplos podem incluir:

- ID da execução de ingestão;
- ID da execução de processamento da Silver;
- ID da execução de processamento da Gold;
- ID da execução de validação de qualidade;
- ID da execução de certificação;
- ID da execução de publicação;
- ID da execução de *replay* ou recuperação.

Os identificadores de execução dão suporte à rastreabilidade operacional.

Eles são distintos dos identificadores de negócio e da identidade do evento.

Conceitualmente:

**ID de Negócio**
→ identifica a entidade de negócio.

**ID do Evento**
→ identifica o evento lógico.

**ID da Execução**
→ identifica a atividade de processamento.

Esses identificadores não devem ser tratados como intercambiáveis.

### 13.17 Rastreabilidade e Observabilidade

Rastreabilidade e observabilidade são relacionadas, mas distintas.

**Observabilidade**
→ explica o comportamento operacional e a saúde da plataforma.

**Rastreabilidade e Linhagem**
→ explicam a origem, o caminho de transformação e as dependências dos dados.

Por exemplo:

**Lag do consumidor = 50.000**
é um fato de observabilidade.

**Este resultado certificado de Daily Sales foi produzido a partir destas entradas da Silver utilizando Gold Processing V3**
é um fato de linhagem.

A plataforma deve, preferencialmente, correlacionar ambos quando isso for útil durante uma investigação.

### 13.18 Gerenciamento de Metadados de Linhagem

Os metadados de linhagem devem ser gerenciados como informações da plataforma, em vez de existirem apenas em *logs* temporários ou no conhecimento individual dos desenvolvedores.

A implementação pode combinar:

- metadados técnicos persistidos;
- tabelas de controle de processamento;
- metadados de conjuntos de dados;
- metadados de contratos;
- metadados de execução;
- metadados de orquestração;
- ferramentas de catálogo ou linhagem, quando introduzidas.

A arquitetura não exige que todas as capacidades de linhagem sejam implementadas por meio de um único produto.

O requisito é que os relacionamentos de linhagem necessários permaneçam reconstruíveis, duráveis e consultáveis de acordo com as necessidades operacionais e de governança da plataforma.

### 13.19 Retenção da Linhagem

A retenção da linhagem deve ser suficiente para dar suporte aos dados históricos e versões analíticas certificadas que permaneçam governados ou recuperáveis.

Excluir metadados de linhagem enquanto os dados analíticos históricos correspondentes são mantidos pode tornar esses dados impossíveis de explicar ou auditar.

As políticas de retenção devem, portanto, considerar os relacionamentos entre:

- retenção da Bronze;
- retenção da Silver;
- retenção da Gold;
- retenção das versões certificadas;
- retenção das versões de contrato;
- retenção das versões de processamento;
- evidências de qualidade;
- metadados de linhagem.

A retenção da linhagem deve ser avaliada como parte da estratégia mais ampla de ciclo de vida e recuperação.

### 13.20 Validação da Linhagem

A existência de metadados de linhagem não garante que a linhagem esteja correta.

Relacionamentos críticos de linhagem devem, preferencialmente, ser validados durante a implementação e os testes.

A validação pode incluir:

- identidade do evento preservada do Kafka até a Bronze;
- entrada da Bronze corretamente associada à saída da Silver;
- escopo da Silver corretamente associado ao processamento da Gold;
- chaves de negócio corretamente relacionadas às chaves substitutas;
- versões de processamento corretamente registradas;
- evidências de certificação corretamente relacionadas às versões publicadas;
- linhagem de *replay* preservando o contexto original da origem.

Falhas de linhagem devem ser observáveis, pois uma linhagem incorreta pode produzir falsa confiança durante uma investigação.

### 13.21 Evidências de Linhagem

A implementação V1 deve, preferencialmente, produzir evidências práticas que demonstrem rastreabilidade *end-to-end*.

Pelo menos um fluxo representativo de Sales deve, preferencialmente, ser rastreável desde a alteração operacional na origem até o caminho de publicação analítica.

As evidências devem, preferencialmente, demonstrar, conforme aplicável:

- registro da origem ou entidade de negócio;
- metadados da alteração na origem;
- identidade do evento;
- posição no Kafka;
- persistência na Bronze;
- transformação na Silver;
- relacionamento com fato ou dimensão da Gold;
- evidências de certificação;
- publicação na Certified Gold;
- consumo analítico.

Uma investigação reversa também deve, preferencialmente, ser demonstrada a partir de um resultado analítico selecionado em direção ao escopo da origem que contribuiu para ele.

Essas evidências fornecem prova prática de que a linhagem é operacional, e não apenas documentada.

### 13.22 Garantias de Rastreabilidade e Linhagem

No limite de rastreabilidade e linhagem, a arquitetura exige as seguintes garantias:

- alterações operacionais permanecem rastreáveis através do caminho de processamento *downstream* aplicável;
- rastreabilidade direta e reversa são suportadas de acordo com a granularidade necessária;
- a identidade do evento permanece distinta da posição de transporte no Kafka;
- identidade de negócio, identidade do evento e identidade da execução de processamento permanecem conceitualmente distintas;
- a Bronze preserva o contexto original da origem e do transporte;
- a Silver permanece atribuível à entrada da Bronze e à lógica de processamento da Silver;
- a Gold permanece atribuível à entrada da Silver e à lógica de processamento dimensional;
- chaves substitutas dimensionais permanecem rastreáveis às entidades de negócio aplicáveis;
- a Certified Gold permanece atribuível às suas evidências de processamento, qualidade, reconciliação, certificação e publicação;
- a agregação não cria falsas suposições de linhagem de um para um;
- *replay* e reprocessamento estendem a linhagem, em vez de sobrescrever a proveniência original;
- dimensões independentes de versão permanecem distinguíveis;
- a linhagem dá suporte à análise de impacto *downstream*;
- os metadados de linhagem permanecem duráveis além dos *logs* temporários de execução;
- a retenção da linhagem permanece alinhada à retenção dos dados governados;
- relacionamentos críticos de linhagem são validados por meio de evidências de implementação.

Essas garantias estabelecem uma cadeia analítica explicável desde a alteração operacional na origem até o consumo analítico governado.

---

## 14. Observabilidade e Medição Operacional

A observabilidade fornece a visibilidade operacional necessária para determinar se a plataforma de Engenharia de Dados está saudável, progredindo, recuperando-se e atendendo aos níveis de serviço esperados.

A base de observabilidade da V1 utiliza **Prometheus**, **Grafana** e *logging* estruturado.

A observabilidade deve abranger tanto a saúde da infraestrutura quanto o comportamento do fluxo de dados.

O fato de um componente estar disponível não comprova que os dados estejam fluindo corretamente, e o processamento bem-sucedido não comprova que os dados analíticos estejam completos, atuais ou certificados.

A plataforma deve, portanto, medir o caminho completo de processamento:

**Confirmação na Origem → CDC → Kafka → Bronze → Silver → Gold → Qualidade e Reconciliação → Certified Gold → Consumo Analítico**

O objetivo é tornar o comportamento do processamento mensurável, diagnosticável e verificável, em vez de inferi-lo a partir do estado isolado dos componentes.

### 14.1 Dimensões de Observabilidade

A visibilidade operacional deve abranger, conforme aplicável:

- disponibilidade;
- *throughput*;
- latência;
- *backlog*;
- taxa de erros;
- sucesso e falha do processamento;
- comportamento de novas tentativas;
- comportamento de recuperação;
- estado da qualidade dos dados;
- estado da reconciliação;
- estado da certificação;
- estado da publicação;
- atualidade;
- utilização de recursos;
- comportamento da capacidade.

Essas dimensões devem ser interpretadas em conjunto.

Por exemplo, alta disponibilidade com *backlog* crescente ainda pode representar um serviço analítico não saudável.

### 14.2 Saúde da Infraestrutura

O monitoramento da infraestrutura deve expor o estado operacional dos serviços exigidos pela plataforma.

Dependendo do componente, os indicadores relevantes podem incluir:

- disponibilidade do serviço;
- utilização de CPU;
- utilização de memória;
- utilização de armazenamento;
- comportamento da rede;
- falhas de conexão;
- reinicializações de processos;
- saturação de recursos;
- risco de capacidade de armazenamento.

As métricas de infraestrutura fornecem contexto diagnóstico importante, mas não devem ser utilizadas como o único indicador da saúde da plataforma de dados.

### 14.3 Saúde do Fluxo de Dados

A plataforma deve determinar se os dados estão realmente percorrendo o caminho de processamento esperado.

A saúde do fluxo de dados deve, preferencialmente, incluir, conforme aplicável:

- alterações observadas na origem;
- alterações capturadas pelo CDC;
- eventos produzidos;
- eventos disponíveis no Kafka;
- eventos consumidos;
- registros persistidos na Bronze;
- registros processados na Silver;
- processamento da Gold concluído;
- controles de qualidade executados;
- reconciliação concluída;
- certificação concluída;
- Certified Gold publicada.

Uma lacuna entre etapas consecutivas deve ser observável.

Por exemplo:

**CDC ativo → Kafka inativo**
exige uma investigação diferente de:

**Kafka ativo → Bronze inativa**

ou:

**Gold concluída → certificação bloqueada**.

### 14.4 *Throughput*

*Throughput* mede quanto trabalho a plataforma processa ao longo do tempo.

As medições relevantes de *throughput* podem incluir:

- alterações na origem por segundo ou minuto;
- eventos produzidos por segundo;
- taxa de consumo do Kafka;
- taxa de persistência na Bronze;
- taxa de processamento da Silver;
- taxa de processamento da Gold;
- taxa de processamento da certificação.

O *throughput* deve ser avaliado em relação à carga de trabalho de entrada.

Uma alta taxa de processamento não é suficiente se a taxa de entrada for consistentemente maior.

Conceitualmente:

**Margem de Capacidade de Processamento = Taxa de Processamento - Taxa de Entrada**

Uma margem positiva e sustentada permite a recuperação do *backlog*.

Uma margem igual a zero ou negativa indica que o *backlog* pode permanecer estável ou continuar crescendo.

### 14.5 Latência por Etapa

A plataforma deve medir a latência entre limites significativos de processamento.

As medições iniciais incluem:

- confirmação na origem até captura pelo CDC;
- captura pelo CDC até disponibilidade no Kafka;
- disponibilidade no Kafka até persistência na Bronze;
- persistência na Bronze até publicação na Silver;
- publicação na Silver até conclusão da Gold;
- conclusão da Gold até publicação na Certified Gold.

Essas medições permitem que a plataforma identifique qual etapa mais contribui para o atraso *end-to-end*.

A latência por etapa deve, preferencialmente, ser medida utilizando distribuições, e não apenas médias, quando apropriado.

### 14.6 Latência *End-to-End*

A principal medição de atualidade analítica da V1 é:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

O objetivo formal inicial é:

**P95 ≤ 15 minutos**

Sob condições normais de operação, a plataforma inicialmente tem como objetivo disponibilizar os dados analíticos em aproximadamente **3–5 minutos**.

A faixa operacional esperada e o SLO formal atendem a finalidades diferentes e devem permanecer distinguíveis.

A latência *end-to-end* deve incluir o tempo gasto em:

- captura;
- transporte;
- *buffering*;
- persistência;
- transformação;
- espera em *backlog*;
- validação de qualidade;
- reconciliação;
- certificação;
- publicação.

A medição de atualidade é encerrada somente quando o resultado analítico certificado se torna disponível para consumo governado.

### 14.7 Percentis

A latência não deve ser avaliada utilizando apenas médias.

A plataforma deve, preferencialmente, observar, conforme aplicável:

- **P50**;
- **P95**;
- **P99**.

Conceitualmente:

**P50**
→ comportamento mediano típico.

**P95**
→ objetivo formal de nível de serviço da V1.

**P99**
→ visibilidade sobre o comportamento da cauda mais lenta.

As tendências dos percentis ajudam a identificar degradações que podem permanecer ocultas por uma média estável.

### 14.8 Backlog

*Backlog* representa trabalho que chegou, mas ainda não concluiu a etapa de processamento aplicável.

O *backlog* pode existir em vários locais, incluindo:

- Kafka;
- Bronze aguardando processamento na Silver;
- Silver aguardando processamento na Gold;
- versões candidatas da Gold aguardando validação ou certificação.

A plataforma não deve tratar *backlog* como uma preocupação exclusiva do Kafka.

Cada limite de processamento capaz de acumular trabalho pendente deve, preferencialmente, expor um indicador apropriado de *backlog*.

### 14.9 Trabalho Pendente Mais Antigo

O tamanho do *backlog*, isoladamente, não descreve completamente o impacto na atualidade.

A plataforma também deve, preferencialmente, medir a idade do trabalho pendente mais antigo, quando aplicável.

Conceitualmente:

**Tamanho do Backlog**
→ quanto trabalho está aguardando.

**Trabalho Pendente Mais Antigo**
→ há quanto tempo o trabalho mais atrasado está aguardando.

Essa distinção é particularmente importante em períodos de baixo volume, nos quais um *backlog* pequeno ainda pode representar desatualização analítica severa.

### 14.10 Detecção de Ausência de Eventos

A ausência de novos eventos não deve ser automaticamente classificada como saudável.

Um período sem eventos pode representar:

- inatividade legítima do negócio;
- falha na captura da origem;
- falha do Debezium;
- falha do produtor do Kafka;
- interrupção de transporte;
- outro problema de processamento *upstream*.

A detecção de ausência de eventos deve considerar:

- padrões esperados de carga de trabalho;
- taxas históricas de eventos;
- calendário de negócio;
- atividade da origem;
- saúde do CDC;
- saúde do produtor;
- estado dos componentes *downstream*.

A plataforma deve, preferencialmente, aprender com o comportamento medido da carga de trabalho antes de definir limites estáticos de alerta para ausência de eventos.

### 14.11 Sucesso e Falha do Processamento

O monitoramento do processamento deve distinguir entre estados operacionais significativos.

Os exemplos incluem:

- iniciado;
- em execução;
- concluído com sucesso;
- concluído com alertas;
- falhou;
- em nova tentativa;
- em quarentena;
- bloqueado por qualidade;
- bloqueado por reconciliação;
- certificação falhou;
- publicação falhou.

Um único estado genérico `SUCCESS` ou `FAILURE` é insuficiente para diagnosticar o *pipeline* *end-to-end*.

### 14.12 Classificação de Erros

Os erros devem, preferencialmente, ser observáveis de acordo com seu contexto de processamento.

Classificações úteis podem incluir:

- erros transitórios de infraestrutura;
- erros persistentes de infraestrutura;
- falhas de serialização ou desserialização;
- incompatibilidade de contrato;
- falhas de conversão de tipos;
- falhas de validação de dados;
- falhas de regras de qualidade;
- falhas de reconciliação;
- falhas de armazenamento;
- falhas de publicação;
- falhas de segurança ou autorização.

A classificação ajuda a determinar se nova tentativa, quarentena, remediação, escalonamento, *replay* ou *rebuild* são apropriados.

### 14.13 *Logging* Estruturado

Os *logs* das aplicações e do processamento devem ser estruturados para que eventos operacionais possam ser correlacionados entre as etapas de processamento.

Quando aplicável, os registros de *log* devem, preferencialmente, incluir identificadores como:

- *timestamp*;
- severidade;
- componente;
- identidade do evento;
- posição na origem;
- *topic* do Kafka;
- partição do Kafka;
- *offset* do Kafka;
- identificador da execução de processamento;
- conjunto de dados;
- versão de processamento;
- versão do contrato;
- classificação do erro;
- tentativa de nova execução;
- identificador de correlação ou *trace*.

O *logging* estruturado deve dar suporte à análise legível por máquina, em vez de depender exclusivamente de mensagens de texto livre.

Dados sensíveis não devem ser gravados desnecessariamente nos *logs*.

### 14.14 Correlação

A observabilidade deve permitir que métricas e *logs* relacionados sejam correlacionados entre limites de processamento.

Por exemplo, uma investigação deve, preferencialmente, ser capaz de relacionar:

**aumento do lag do consumidor**

a:

**redução da velocidade de persistência na Bronze**

e então a:

**latência ou falha de armazenamento**

quando as evidências sustentarem essa relação.

Identificadores de correlação e *timestamps* compartilhados devem, preferencialmente, ser preservados quando fornecerem valor diagnóstico significativo.

### 14.15 Observabilidade da Qualidade

A qualidade dos dados deve ser observável como um estado operacional.

As informações relevantes incluem:

- controles executados;
- controles aprovados;
- controles com falha;
- falhas críticas;
- alertas;
- conjunto de dados afetado;
- versão candidata afetada;
- versão das regras de qualidade;
- duração da validação.

Um *pipeline* tecnicamente saudável que falha repetidamente em verificações críticas de qualidade não é saudável sob a perspectiva da entrega analítica governada.

### 14.16 Observabilidade da Reconciliação

O monitoramento da reconciliação deve expor:

- estado da execução da reconciliação;
- escopo comparado da origem e do destino;
- valores de controle esperados;
- valores de controle observados;
- diferenças absolutas e relativas, quando aplicável;
- limites;
- duração da reconciliação;
- versão candidata afetada.

Falhas de reconciliação devem permanecer visíveis independentemente das falhas de infraestrutura.

### 14.17 Observabilidade da Certificação e Publicação

A plataforma deve observar a sequência completa de certificação e publicação.

Os indicadores relevantes incluem:

- versão candidata;
- status da certificação;
- duração da certificação;
- status da publicação;
- duração da publicação;
- falhas de publicação;
- novas tentativas de publicação;
- versão certificada atual;
- última certificação bem-sucedida;
- `certified_gold_publish_ts`;
- idade dos dados atualmente certificados.

Isso permite identificar se a desatualização analítica é causada por atraso na transformação, certificação ou publicação.

### 14.18 Observabilidade do Consumidor

O consumo analítico governado deve, preferencialmente, expor informações suficientes para determinar se os dados certificados estão efetivamente disponíveis aos consumidores.

Quando integrado, o monitoramento pode incluir:

- disponibilidade da camada de disponibilização da Certified Gold;
- disponibilidade das consultas analíticas;
- status de atualização do Power BI;
- duração da atualização do Power BI;
- falhas de acesso dos consumidores;
- atualidade exibida aos consumidores.

O SLO de Engenharia de Dados da V1 termina quando a Certified Gold se torna disponível.

O comportamento de atualização do Power BI pode ser medido separadamente, pois o agendamento de atualização da BI pode introduzir atraso adicional visível ao consumidor além do limite de publicação da Engenharia de Dados.

### 14.19 SLI e SLO

Um **Service Level Indicator (SLI)** é um valor medido que representa um aspecto relevante do comportamento do serviço.

Os exemplos incluem:

- latência *end-to-end*;
- taxa de publicações bem-sucedidas;
- atualidade;
- duração da recuperação.

Um **Service Level Objective (SLO)** define o objetivo esperado para o indicador correspondente.

Para a V1:

**SLI**
→ atualidade analítica *end-to-end* medida.

**SLO**
→ **P95 ≤ 15 minutos**.

A plataforma pode introduzir SLIs e SLOs adicionais à medida que as evidências de implementação e os requisitos de negócio amadurecerem.

Um SLO deve ser mensurável por meio de indicadores definidos e não deve existir apenas como uma expectativa não documentada.

### 14.20 Alertas

Os alertas devem, preferencialmente, identificar condições acionáveis, em vez de reproduzir todas as métricas disponíveis.

As condições potenciais de alerta incluem:

- componente indisponível;
- inatividade do CDC fora do comportamento esperado;
- *lag* do consumidor aumentando além dos níveis esperados;
- trabalho pendente mais antigo excedendo o limite;
- falha de processamento;
- novas tentativas repetidas;
- crescimento da quarentena;
- falha crítica de qualidade;
- falha de reconciliação;
- falha de certificação;
- falha de publicação;
- violação do SLO de atualidade;
- risco de capacidade de armazenamento.

Os limites dos alertas devem ser calibrados utilizando o comportamento medido da linha de base sempre que possível.

Alertas excessivos e não acionáveis reduzem a confiança no sistema de alertas e devem, preferencialmente, ser evitados.

### 14.21 Linhas de Base Sazonais e de Carga de Trabalho

O comportamento esperado da carga de trabalho pode variar de acordo com:

- horário do dia;
- dia da semana;
- calendário de negócio;
- períodos promocionais;
- eventos operacionais.

Limites estáticos podem, portanto, criar falsos alertas ou deixar de detectar anomalias.

A plataforma deve, preferencialmente, coletar inicialmente e compreender os padrões medidos da carga de trabalho antes de introduzir alertas sazonais ou comportamentais mais avançados.

A V1 pode começar com limites mais simples, preservando a arquitetura para monitoramento futuro consciente de linhas de base.

### 14.22 Observabilidade da Recuperação

A recuperação deve ser observável como um processo, e não apenas como o estado de um componente.

As medições relevantes incluem:

- horário de início da falha;
- horário de início da recuperação;
- horário de reinicialização do componente;
- horário de retomada do processamento;
- *backlog* no momento da recuperação;
- taxa de processamento durante a recuperação;
- taxa de entrada;
- taxa de redução do *backlog*;
- evento pendente mais antigo;
- tempo para restaurar o processamento correto;
- tempo para retornar ao SLO;
- estado final da reconciliação;
- estado final da certificação.

Isso preserva a distinção entre:

**componente recuperado**

**processamento recuperado**

**correção dos dados recuperada**

**nível de serviço recuperado**.

### 14.23 Observabilidade de Capacidade

A plataforma deve coletar medições que deem suporte a futuras decisões de capacidade.

As medições relevantes podem incluir:

- taxa de eventos;
- tamanho dos eventos;
- taxa de compressão;
- crescimento do armazenamento;
- quantidade de objetos;
- *throughput* de processamento;
- utilização de CPU;
- utilização de memória;
- utilização de armazenamento;
- *throughput* de rede;
- paralelismo dos consumidores;
- capacidade de recuperação do *backlog*.

A análise de capacidade deve correlacionar o uso de recursos com o comportamento real da carga de trabalho.

Um componente utilizando muita CPU não representa automaticamente um problema se o *throughput* e os níveis de serviço permanecerem saudáveis.

Da mesma forma, baixa utilização de CPU não comprova que a plataforma possui capacidade adequada se o gargalo estiver em outro ponto.

### 14.24 Linha de Base Medida

À medida que a implementação avança, a plataforma deve substituir comportamentos presumidos por informações medidas de linha de base.

As medições devem, preferencialmente, estabelecer progressivamente:

- taxas normais de eventos;
- distribuição normal de latência;
- comportamento normal do *backlog*;
- duração normal do processamento;
- crescimento normal do armazenamento;
- utilização esperada de recursos;
- comportamento esperado de falhas e novas tentativas.

Isso produz a transição:

**Linha de Base Presumida → Linha de Base Medida → Capacidade Validada**

A linha de base medida torna-se a referência utilizada para identificar comportamentos anormais e avaliar futuras decisões de escalabilidade.

### 14.25 Estratégia de Dashboards

Os *dashboards* do Grafana devem, preferencialmente, ser organizados em torno de questões operacionais, em vez de apenas em torno de tecnologias individuais.

Perspectivas úteis de *dashboard* podem incluir:

**Saúde da Plataforma**
→ os serviços necessários estão disponíveis?

**Fluxo de Dados**
→ os dados estão progredindo por cada etapa?

**Atualidade**
→ os produtos analíticos estão dentro da latência esperada?

**Kafka e Backlog**
→ os consumidores estão acompanhando a carga e se recuperando?

**Processamento**
→ Bronze, Silver e Gold estão sendo concluídas corretamente?

**Qualidade e Certificação**
→ as versões candidatas estão passando pelos controles governados?

**Recuperação**
→ a plataforma está retornando ao normal após uma interrupção?

**Capacidade**
→ como o comportamento da carga de trabalho está consumindo os recursos disponíveis?

*Dashboards* específicos de tecnologia podem complementar essas visões, mas não devem, preferencialmente, substituir a visibilidade operacional *end-to-end*.

### 14.26 Evidências a partir da Observabilidade

Métricas e *logs* também são fontes de evidências arquiteturais.

Testes controlados devem, preferencialmente, preservar a saída de observabilidade relevante necessária para demonstrar comportamentos como:

- latência normal de processamento;
- tratamento de reentrega duplicada;
- acúmulo de *backlog*;
- recuperação de *backlog*;
- indisponibilidade do consumidor;
- falha de armazenamento;
- falha de qualidade;
- bloqueio da certificação;
- recuperação da publicação;
- retorno ao SLO.

As evidências devem incluir contexto suficiente para explicar as condições do teste e, preferencialmente, não devem consistir apenas em capturas de tela isoladas sem interpretação.

### 14.27 Evolução com OpenTelemetry

A V1 começa com Prometheus, Grafana e *logging* estruturado.

O **OpenTelemetry** fica reservado como evolução futura para correlação mais ampla de telemetria e rastreamento distribuído.

Sua introdução deve, preferencialmente, ser motivada por um requisito identificado de rastreamento mais robusto entre componentes, e não pela suposição de que toda plataforma deve adotar rastreamento distribuído imediatamente.

A arquitetura atual preserva identificadores e metadados estruturados que podem dar suporte à futura correlação de telemetria.

### 14.28 Garantias de Observabilidade

No limite de observabilidade, a arquitetura exige as seguintes garantias:

- saúde da infraestrutura e saúde do fluxo de dados permanecem distinguíveis;
- todo limite crítico de processamento expõe informações significativas de progresso;
- o *throughput* é interpretado em relação à carga de trabalho de entrada;
- latência por etapa e *end-to-end* permanecem mensuráveis;
- P50, P95 e P99 podem ser observados quando aplicável;
- tamanho do *backlog* e trabalho pendente mais antigo permanecem distinguíveis;
- condições de ausência de eventos são avaliadas em relação ao comportamento esperado da origem;
- estados de processamento permanecem mais expressivos do que sucesso ou falha genéricos;
- *logs* estruturados preservam metadados úteis de correlação;
- qualidade, reconciliação, certificação e publicação permanecem observáveis de forma independente;
- disponibilidade para o consumidor permanece distinta da publicação na Certified Gold;
- SLIs dão suporte a SLOs mensuráveis;
- alertas concentram-se em condições acionáveis;
- linhas de base medidas substituem suposições ao longo do tempo;
- a observabilidade da recuperação mede o retorno à correção e ao nível de serviço, e não apenas a reinicialização de componentes;
- decisões de capacidade são sustentadas por medições de carga de trabalho e recursos;
- a saída de observabilidade pode ser preservada como evidência arquitetural.

Essas garantias estabelecem a base de medição operacional necessária para compreender, validar e evoluir a plataforma de Engenharia de Dados.

---

## 15. Evidências de Processamento e Estratégia de Validação

As garantias de processamento definidas neste documento devem ser validadas por meio de implementação e testes controlados.

A documentação estabelece o comportamento pretendido da plataforma de Engenharia de Dados.

A implementação fornece o mecanismo.

Os testes exercitam os comportamentos esperados e de falha.

A observabilidade expõe o que ocorreu durante a execução.

As evidências registram o resultado sob condições documentadas.

A cadeia de validação é:

**Requisito Arquitetural → Implementação → Teste → Observabilidade → Evidência**

O propósito desta estratégia não é criar evidências para cada detalhe da implementação.

É garantir que as garantias críticas de processamento possam ser demonstradas, em vez de inferidas exclusivamente a partir da documentação de design ou da execução normal bem-sucedida.

### 15.1 Escopo da Validação

A validação deve concentrar-se nos comportamentos que afetam materialmente a correção dos dados, capacidade de recuperação, atualidade, rastreabilidade, certificação e confiança analítica.

As áreas críticas de validação incluem:

- captura de alterações confirmadas;
- identidade do evento;
- compatibilidade de contratos;
- ordenação no Kafka;
- entrega *at-least-once*;
- gerenciamento de *offsets*;
- durabilidade da Bronze;
- persistência atômica;
- idempotência;
- tratamento de duplicidades;
- padronização da Silver;
- correção dimensional da Gold;
- validação de qualidade;
- reconciliação;
- publicação na Certified Gold;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- recuperação de falhas;
- recuperação de *backlog*;
- rastreabilidade *end-to-end*;
- medição do SLO.

O inventário exato de testes pode evoluir à medida que a implementação revelar riscos ou comportamentos adicionais de processamento.

### 15.2 Validação do Caminho Normal

A plataforma deve primeiro demonstrar o processamento *end-to-end* correto sob condições normais e controladas.

Para a implementação inicial de **Sales**, a validação deve demonstrar que uma alteração confirmada no AtlasCommerce pode percorrer:

**AtlasCommerce → CDC → Debezium → Kafka → Bronze → Silver → Gold → Qualidade e Reconciliação → Certified Gold → Consumo Analítico**

O teste do caminho normal deve preservar metadados suficientes para demonstrar:

- alteração na origem;
- criação do evento;
- posição no Kafka;
- persistência na Bronze;
- transformação na Silver;
- resultado na Gold;
- resultado de qualidade e reconciliação;
- certificação;
- publicação;
- latência *end-to-end*.

O sucesso no caminho normal estabelece a linha de base em relação à qual os cenários de falha poderão ser posteriormente avaliados.

### 15.3 Injeção de Falhas

Comportamentos críticos de recuperação devem ser testados por meio de injeção controlada de falhas.

O laboratório deve, preferencialmente, reproduzir intencionalmente cenários como:

- interrupção do consumidor;
- falha antes da persistência na Bronze;
- falha durante a gravação temporária na Bronze;
- falha após a promoção na Bronze, mas antes da confirmação do *offset*;
- indisponibilidade do Kafka;
- indisponibilidade do armazenamento de objetos;
- falha no processamento da Silver;
- falha no processamento da Gold;
- registro persistentemente inválido;
- incompatibilidade de *schema*;
- falha em regra de qualidade;
- falha de reconciliação;
- falha na publicação da Certified Gold.

A injeção de falhas deve ser controlada de modo que o estado inicial, o ponto da falha e o comportamento esperado de recuperação sejam conhecidos.

O objetivo é observar o comportamento da plataforma sob falha, e não apenas verificar se um componente pode ser reinicializado.

### 15.4 Validação da Idempotência

A idempotência deve ser demonstrada explicitamente.

Os testes devem incluir o processamento repetido do mesmo evento lógico ou da mesma entrada de processamento.

O resultado esperado é que a entrega ou execução repetida não crie efeitos de negócio duplicados incorretos.

A validação deve, preferencialmente, abranger, conforme aplicável:

- reentrega duplicada na Bronze;
- reprocessamento da Silver;
- reprocessamento de fatos da Gold;
- reprocessamento de dimensões;
- *replay*;
- nova tentativa de publicação.

As evidências devem distinguir entre:

**Entrega repetida do mesmo evento**

e

**Eventos legítimos diferentes afetando a mesma entidade de negócio**.

### 15.5 Validação de Offsets e Durabilidade

O relacionamento entre a confirmação do *offset* do Kafka e a durabilidade da Bronze deve ser testado diretamente.

No mínimo, os testes devem, preferencialmente, demonstrar o comportamento quando uma falha ocorre:

**antes da persistência na Bronze**

e:

**após a persistência na Bronze, mas antes da confirmação do offset do Kafka**.

O resultado esperado é que:

- trabalho não protegido permaneça elegível para reentrega;
- trabalho persistido com segurança não seja perdido;
- entregas repetidas não produzam duplicação histórica incorreta;
- *offsets* confirmados não avancem além do limite de durabilidade que protegem.

Essa validação fornece evidência prática para o modelo de processamento *at-least-once* da V1.

### 15.6 Validação da Persistência Atômica

A Bronze e outros limites de publicação baseados em arquivos devem demonstrar que saídas incompletas não se tornam visíveis como dados válidos e concluídos.

Os testes devem, preferencialmente, verificar que:

- saídas temporárias permanecem distinguíveis das saídas finais;
- gravações interrompidas não aparecem como objetos finais válidos;
- uma promoção bem-sucedida expõe somente saídas validadas;
- o processamento *downstream* ignora artefatos incompletos.

O mecanismo específico da implementação deve ser validado em relação ao comportamento real do armazenamento de objetos, em vez de ser presumido a partir da semântica tradicional de sistemas de arquivos.

### 15.7 Validação da Evolução de Contratos

A evolução de *schemas* e contratos de eventos deve ser testada além do registro bem-sucedido no *registry*.

A validação deve, preferencialmente, incluir, conforme aplicável:

- evolução compatível de *schema*;
- rejeição de alteração incompatível de *schema*;
- serialização pelo produtor;
- interpretação pelo consumidor;
- versões históricas suportadas;
- *replay* da Bronze entre versões de contrato;
- normalização da Silver entre versões suportadas;
- comportamento explícito de migração para alterações incompatíveis.

O resultado esperado é que a evolução dos eventos não interrompa silenciosamente o processamento *downstream* suportado.

### 15.8 Validação das Transformações

A lógica de transformação da Silver e da Gold deve ser testada independentemente da disponibilidade da infraestrutura.

A validação da Silver deve, preferencialmente, incluir, conforme aplicável:

- aplicação de tipos;
- padronização;
- normalização;
- tratamento de duplicidades;
- semântica das operações;
- tratamento das versões de contrato;
- comportamento de registros inválidos.

A validação da Gold deve, preferencialmente, incluir, conforme aplicável:

- grão do fato;
- definições das medidas;
- resolução de dimensões;
- comportamento das chaves substitutas;
- comportamento histórico das dimensões;
- consistência temporal;
- comportamento das dimensões conformadas;
- reprocessamento idempotente.

A correção das transformações não deve ser inferida exclusivamente a partir da conclusão bem-sucedida de um *job*.

### 15.9 Validação do *Gate* de Qualidade

Os controles de certificação devem ser testados tanto com dados candidatos válidos quanto intencionalmente inválidos.

Os testes devem, preferencialmente, demonstrar que:

**Versão Candidata Válida**
→ passa pelos controles exigidos e torna-se elegível para publicação.

**Versão Candidata com Falha Crítica**
→ falha na certificação e não substitui a versão certificada atual.

O teste deve verificar que a última versão certificada reconhecidamente confiável permanece disponível sempre que tecnicamente possível.

A validação do *gate* de qualidade deve, preferencialmente, incluir as evidências necessárias para identificar qual regra bloqueou a certificação e por quê.

### 15.10 Validação da Reconciliação

A reconciliação deve ser validada utilizando valores de controle conhecidos da origem e do ambiente *downstream*.

Os testes devem, preferencialmente, verificar que a lógica de reconciliação identifica corretamente tanto:

- equivalência esperada;
- discrepância intencional.

Os testes de reconciliação devem refletir o grão real da transformação e a semântica de negócio.

Um teste que compare apenas contagens de linhas é insuficiente quando as estruturas da origem e do destino não possuem grão de um para um.

Para a implementação de Sales, a reconciliação representativa pode incluir quantidades, contagens de transações, contagens de itens de transação, totais monetários e outros controles aprovados de acordo com o modelo analítico final.

### 15.11 Validação da Publicação Certificada

A publicação na Certified Gold deve demonstrar atomicidade visível ao consumidor.

Os testes devem, preferencialmente, verificar que:

- a versão certificada anterior permanece visível enquanto uma versão candidata é preparada;
- versões candidatas incompletas não são expostas;
- versões candidatas com falha não são publicadas;
- versões candidatas bem-sucedidas tornam-se visíveis como versões certificadas completas;
- uma falha de publicação não produz um `certified_gold_publish_ts` falso;
- o *rollback* pode restaurar uma versão anterior elegível quando implementado.

A validação deve concentrar-se no comportamento visível ao consumidor, e não apenas nos comandos internos de publicação.

### 15.12 Validação de *Replay*

O *replay* deve ser demonstrado a partir de uma entrada histórica preservada.

Um teste de *replay* deve, preferencialmente, identificar:

- fonte do *replay*;
- intervalo histórico;
- identidade original do evento;
- *timestamps* originais;
- versão de processamento;
- execução do *replay*;
- estado *downstream* resultante;
- resultado do tratamento de duplicidades;
- resultado da reconciliação.

O teste deve demonstrar que o *replay* não reescreve o histórico original dos eventos nem multiplica incorretamente os efeitos analíticos *downstream*.

### 15.13 Validação de *Backfill*

Quando uma capacidade de *backfill* for implementada, os testes devem demonstrar que um intervalo histórico pode ser introduzido ou reconstruído sem corromper o processamento incremental normal.

A validação deve, preferencialmente, verificar:

- limites do período histórico;
- *timestamps* originais de vigência de negócio;
- atribuição da versão de processamento;
- comportamento de sobreposição com dados existentes;
- prevenção de duplicidades;
- reconciliação;
- impacto na certificação.

As evidências de *backfill* devem distinguir o período histórico de negócio do momento de execução do *backfill*.

### 15.14 Validação da Recuperação

Os testes de recuperação devem validar mais do que a reinicialização de componentes.

Um cenário de recuperação é considerado bem-sucedido somente quando as garantias necessárias de processamento e dados tiverem sido restauradas.

A validação deve, preferencialmente, incluir, conforme aplicável:

- processamento retomado a partir da posição durável correta;
- eventos necessários permanecem completos;
- reentregas duplicadas foram tratadas com segurança;
- a ordenação permanece correta;
- o *backlog* diminui;
- Silver e Gold tornam-se reconciliáveis;
- a certificação é concluída com sucesso;
- a Certified Gold torna-se atual novamente;
- a atualidade *end-to-end* retorna à faixa esperada.

Isso distingue:

**Reinicialização do Componente**

de

**Recuperação do Processamento**

de

**Recuperação da Correção dos Dados**

de

**Recuperação do Nível de Serviço**.

### 15.15 Validação da Recuperação de *Backlog*

O laboratório deve criar *backlog* intencionalmente e medir o comportamento de recuperação.

Um teste representativo deve, preferencialmente, registrar:

- taxa de entrada de eventos;
- taxa de processamento;
- *backlog* no momento da interrupção;
- *backlog* no início da recuperação;
- evento pendente mais antigo;
- taxa de redução do *backlog*;
- utilização de recursos;
- latência *end-to-end*;
- tempo necessário para eliminar ou normalizar o *backlog*;
- tempo necessário para retornar ao SLO.

A condição esperada para redução sustentada do *backlog* é:

**Taxa de Processamento > Taxa de Entrada**

O teste deve demonstrar comportamento de *catch-up*, e não apenas a reinicialização bem-sucedida do consumidor.

### 15.16 Validação do SLO

O SLO de atualidade da V1 deve ser medido por meio de processamento *end-to-end* real.

A medição principal é:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

A validação deve calcular a distribuição aplicável de latência e determinar:

- P50;
- P95;
- P99.

O objetivo formal da V1 é:

**P95 ≤ 15 minutos**

A faixa inicial de **3–5 minutos** representa o objetivo operacional normal esperado e deve permanecer distinta do limite formal do SLO.

As evidências do SLO devem identificar as condições de carga de trabalho sob as quais a medição foi coletada.

### 15.17 Validação de Carga de Trabalho e Capacidade

Os testes de desempenho devem avaliar progressivamente o comportamento do processamento sob aumento de carga de trabalho.

A referência inicial de validação da V1 inclui:

- aproximadamente **10 GB** de dados operacionais iniciais;
- aproximadamente **250 MB/dia** de volume esperado de alterações;
- picos de carga de aproximadamente **3× a linha de base**.

Esses valores são premissas iniciais e metas de laboratório, e não limites arquiteturais de capacidade.

Os testes devem, preferencialmente, medir, conforme aplicável:

- *throughput* de eventos;
- *throughput* de processamento;
- comportamento do *backlog*;
- taxa de compressão;
- crescimento do armazenamento;
- utilização de CPU;
- utilização de memória;
- utilização de rede;
- latência por etapa;
- latência *end-to-end*;
- capacidade de recuperação.

As evidências resultantes dão suporte à transição:

**Linha de Base Presumida → Linha de Base Medida → Capacidade Validada**

### 15.18 Validação da Rastreabilidade

Pelo menos um fluxo representativo de Sales deve demonstrar rastreabilidade *end-to-end*.

A validação direta deve, preferencialmente, rastrear uma alteração operacional controlada através de:

**AtlasCommerce → CDC → Kafka → Bronze → Silver → Gold → Certified Gold → Consumo Analítico**

A validação reversa deve, preferencialmente, começar com um resultado analítico selecionado e identificar seu escopo contribuinte de processamento e origem.

As evidências devem, preferencialmente, preservar, quando aplicável:

- identificador de negócio da origem;
- posição na origem;
- identidade do evento;
- partição e *offset* do Kafka;
- objeto da Bronze;
- execução de processamento da Silver;
- execução de processamento da Gold;
- evidências de certificação;
- versão certificada;
- produto analítico.

Esse teste demonstra que a linhagem pode ser utilizada operacionalmente, em vez de existir apenas como documentação.

### 15.19 Estrutura das Evidências

As evidências dos testes devem conter contexto suficiente para permanecerem significativas após a conclusão da execução.

As evidências devem, preferencialmente, identificar, conforme aplicável:

- identificador do teste;
- propósito do teste;
- requisito arquitetural;
- ambiente;
- versão da implementação;
- data do teste;
- estado inicial;
- entrada do teste;
- falha induzida, quando aplicável;
- comportamento esperado;
- comportamento observado;
- métricas relevantes;
- *logs* relevantes;
- resultado da reconciliação;
- resultado da qualidade;
- resultado da recuperação;
- impacto no SLO;
- estado final;
- conclusão.

As evidências devem, preferencialmente, ser reproduzíveis sempre que viável.

### 15.20 Nomenclatura das Evidências

Cenários críticos de laboratório devem, preferencialmente, utilizar identificadores estáveis para que a documentação de arquitetura, os testes e as evidências possam referenciar o mesmo cenário de validação.

Por exemplo:

**REL-001 — Indisponibilidade e Recuperação do Consumidor**

Um identificador estável permite relacionamentos como:

**Requisito Arquitetural**
→ **Teste REL-001**
→ **Evidência REL-001**

A taxonomia exata dos identificadores é mantida como parte dos padrões de testes e evidências, em vez de ser definida exaustivamente neste documento.

### 15.21 Qualidade das Evidências

As evidências devem demonstrar comportamento, e não apenas mostrar que um comando foi executado.

Por exemplo, uma captura de tela mostrando um consumidor reinicializado é evidência insuficiente de uma recuperação bem-sucedida.

Evidências robustas de recuperação demonstrariam:

- consumidor interrompido;
- *backlog* acumulado;
- aumento da idade do evento pendente mais antigo;
- consumidor reinicializado;
- reentrega repetida tratada com segurança;
- taxa de processamento superior à taxa de entrada;
- redução do *backlog*;
- reconciliação aprovada;
- certificação recuperada;
- SLO retornando ao estado esperado.

As evidências devem, portanto, preferencialmente preservar a sequência e a interpretação necessárias para sustentar a afirmação arquitetural correspondente.

### 15.22 Evidências Negativas

Um teste com falha pode fornecer evidência arquitetural valiosa.

Se um teste controlado demonstrar que a plataforma não atende a um comportamento esperado, o resultado não deve ser ocultado nem reescrito como sucesso.

A falha pode identificar:

- um defeito de implementação;
- uma premissa arquitetural incorreta;
- uma margem de capacidade insuficiente;
- um limite inválido;
- uma limitação de recuperação;
- um refinamento arquitetural necessário.

O resultado da falha deve, preferencialmente, ser preservado até que o problema seja compreendido e a alteração resultante seja validada.

Um teste bem-sucedido posterior não deve apagar as evidências históricas que levaram à correção.

### 15.23 Evidências e Evolução da Arquitetura

As evidências de implementação podem acionar uma mudança arquitetural controlada.

Quando as evidências revelarem uma limitação significativa, a plataforma deve, preferencialmente, avaliar:

**Comportamento Observado → Causa Raiz → Alternativas → Decisão Arquitetural → Alteração de Implementação → Revalidação**

Alterações significativas devem, preferencialmente, ser refletidas no Architecture Decision Record aplicável e na documentação relacionada.

As evidências, portanto, fornecem insumos para a evolução arquitetural, em vez de servirem apenas como prova após a implementação.

### 15.24 Afirmações de Laboratório

As evidências de laboratório devem sempre ser interpretadas dentro das condições nas quais foram produzidas.

Um teste bem-sucedido pode demonstrar:

- correção sob o cenário testado;
- *throughput* medido;
- latência medida;
- comportamento de recuperação medido;
- capacidade validada dentro da carga de trabalho testada.

Ele não deve ser automaticamente apresentado como prova de:

- escalabilidade ilimitada;
- prontidão para produção;
- capacidade em escala corporativa;
- Alta Disponibilidade além da topologia testada;
- desempenho sob cargas de trabalho não testadas.

As afirmações devem permanecer proporcionais às evidências.

### 15.25 Garantias da Validação de Processamento

No limite de validação do processamento, a arquitetura exige as seguintes garantias:

- garantias críticas de processamento são validadas por meio de testes controlados;
- o comportamento do caminho normal é demonstrado antes que cenários de falha sejam interpretados;
- a injeção de falhas é deliberada e reproduzível sempre que viável;
- a idempotência é testada por meio de entrega ou execução repetida;
- a ordenação entre confirmação do *offset* e durabilidade da Bronze é validada diretamente;
- persistência incompleta não aparece como saída final válida;
- a evolução de contratos é testada além da aceitação pelo *registry*;
- a correção das transformações é testada independentemente da conclusão do *job*;
- falhas críticas de qualidade são comprovadamente capazes de bloquear a certificação;
- a reconciliação detecta discrepâncias intencionais;
- a publicação na Certified Gold é validada a partir da perspectiva do consumidor;
- *replay*, *backfill*, reprocessamento e recuperação preservam rastreabilidade e correção;
- a recuperação de *backlog* demonstra capacidade real de *catch-up*;
- a conformidade com o SLO é medida desde a confirmação na origem até a publicação na Certified Gold;
- afirmações de capacidade permanecem limitadas às condições testadas;
- pelo menos um fluxo representativo de Sales demonstra linhagem *end-to-end*;
- as evidências preservam contexto suficiente para sustentar afirmações arquiteturais;
- testes com falha permanecem evidências válidas e podem orientar a evolução arquitetural.

Essas garantias completam o modelo de processamento ao conectar intenção arquitetural à implementação, medição, validação e evidências demonstráveis.