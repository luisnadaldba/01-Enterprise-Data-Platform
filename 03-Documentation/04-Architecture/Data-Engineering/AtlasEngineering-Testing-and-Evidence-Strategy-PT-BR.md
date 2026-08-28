# Atlas Engineering — Estratégia de Testes e Evidências

## Índice

- [1. Propósito e Escopo](#1-propósito-e-escopo)

- [2. Princípios de Testes](#2-princípios-de-testes)
  - [2.1 Os Testes São Projetados com a Arquitetura](#21-os-testes-são-projetados-com-a-arquitetura)
  - [2.2 Os Testes Devem Ter Intenção Explícita](#22-os-testes-devem-ter-intenção-explícita)
  - [2.3 O Comportamento Esperado Deve Ser Definido Antes da Avaliação](#23-o-comportamento-esperado-deve-ser-definido-antes-da-avaliação)
  - [2.4 Execução Bem-Sucedida Não É Evidência Suficiente](#24-execução-bem-sucedida-não-é-evidência-suficiente)
  - [2.5 Os Testes Devem Verificar o Estado Autoritativo](#25-os-testes-devem-verificar-o-estado-autoritativo)
  - [2.6 Os Testes Devem Ser Repetíveis](#26-os-testes-devem-ser-repetíveis)
  - [2.7 Os Testes Devem Preservar o Escopo de Processamento](#27-os-testes-devem-preservar-o-escopo-de-processamento)
  - [2.8 A Falha É um Resultado de Teste Válido](#28-a-falha-é-um-resultado-de-teste-válido)
  - [2.9 Os Testes de Falha Devem Ser Controlados](#29-os-testes-de-falha-devem-ser-controlados)
  - [2.10 A Recuperação Deve Ser Validada Além da Reinicialização](#210-a-recuperação-deve-ser-validada-além-da-reinicialização)
  - [2.11 As Evidências Devem Ser Correlacionadas](#211-as-evidências-devem-ser-correlacionadas)
  - [2.12 As Evidências Devem Ser Proporcionais](#212-as-evidências-devem-ser-proporcionais)
  - [2.13 Os Testes Devem Respeitar a Segurança e a Governança](#213-os-testes-devem-respeitar-a-segurança-e-a-governança)
  - [2.14 Os Testes Devem Distinguir Evidências de Laboratório de Garantias Corporativas](#214-os-testes-devem-distinguir-evidências-de-laboratório-de-garantias-corporativas)
  - [2.15 A Validação Deve Ser Revisável](#215-a-validação-deve-ser-revisável)

- [3. Modelo de Testes e Evidências](#3-modelo-de-testes-e-evidências)
  - [3.1 Expectativa Arquitetural](#31-expectativa-arquitetural)
  - [3.2 Cenário de Validação](#32-cenário-de-validação)
  - [3.3 Execução do Teste](#33-execução-do-teste)
  - [3.4 Comportamento Observado](#34-comportamento-observado)
  - [3.5 Estado Resultante](#35-estado-resultante)
  - [3.6 Evidências](#36-evidências)
  - [3.7 Evidências Esperadas](#37-evidências-esperadas)
  - [3.8 Critérios de Aceitação](#38-critérios-de-aceitação)
  - [3.9 Resultado da Validação](#39-resultado-da-validação)
  - [3.10 Diagnóstico e Correção de Falhas](#310-diagnóstico-e-correção-de-falhas)
  - [3.11 Novo Teste](#311-novo-teste)
  - [3.12 Pacote de Evidências do Teste](#312-pacote-de-evidências-do-teste)
  - [3.13 Rastreabilidade das Evidências](#313-rastreabilidade-das-evidências)
  - [3.14 Evidências Não Substituem a Arquitetura](#314-evidências-não-substituem-a-arquitetura)
  - [3.15 A Confiança na Validação É Proporcional às Evidências](#315-a-confiança-na-validação-é-proporcional-às-evidências)

- [4. Classificação e Cobertura de Testes](#4-classificação-e-cobertura-de-testes)
  - [4.1 Testes de Componentes](#41-testes-de-componentes)
  - [4.2 Testes de Integração](#42-testes-de-integração)
  - [4.3 Testes de Contratos de Dados](#43-testes-de-contratos-de-dados)
  - [4.4 Testes de Transformação](#44-testes-de-transformação)
  - [4.5 Testes de Qualidade de Dados](#45-testes-de-qualidade-de-dados)
  - [4.6 Testes de Certificação](#46-testes-de-certificação)
  - [4.7 Testes de Estado e *Checkpoints*](#47-testes-de-estado-e-checkpoints)
  - [4.8 Testes de Idempotência e Repetibilidade](#48-testes-de-idempotência-e-repetibilidade)
  - [4.9 Testes de Falha](#49-testes-de-falha)
  - [4.10 Testes de Recuperação](#410-testes-de-recuperação)
  - [4.11 Testes de *Backlog* e *Catch-Up*](#411-testes-de-backlog-e-catch-up)
  - [4.12 Testes de Observabilidade](#412-testes-de-observabilidade)
  - [4.13 Testes de Segurança e Governança](#413-testes-de-segurança-e-governança)
  - [4.14 Testes de Performance e Capacidade](#414-testes-de-performance-e-capacidade)
  - [4.15 Testes *End-to-End*](#415-testes-end-to-end)
  - [4.16 Testes de Regressão](#416-testes-de-regressão)
  - [4.17 Testes Negativos e de Limite](#417-testes-negativos-e-de-limite)
  - [4.18 Cobertura de Testes](#418-cobertura-de-testes)
  - [4.19 Rastreabilidade da Cobertura](#419-rastreabilidade-da-cobertura)

- [5. Projeto de Cenários de Teste](#5-projeto-de-cenários-de-teste)
  - [5.1 Objetivo do Cenário](#51-objetivo-do-cenário)
  - [5.2 Referência à Arquitetura e ao Requisito](#52-referência-à-arquitetura-e-ao-requisito)
  - [5.3 Pré-condições](#53-pré-condições)
  - [5.4 Estado Inicial](#54-estado-inicial)
  - [5.5 Dados de Teste](#55-dados-de-teste)
  - [5.6 Escopo de Processamento](#56-escopo-de-processamento)
  - [5.7 Ação Controlada](#57-ação-controlada)
  - [5.8 Injeção de Falhas](#58-injeção-de-falhas)
  - [5.9 Tempo e Ordenação](#59-tempo-e-ordenação)
  - [5.10 Comportamento Esperado](#510-comportamento-esperado)
  - [5.11 Estado Resultante Esperado](#511-estado-resultante-esperado)
  - [5.12 Evidências Esperadas](#512-evidências-esperadas)
  - [5.13 Critérios de Aceitação](#513-critérios-de-aceitação)
  - [5.14 Restauração e Limpeza](#514-restauração-e-limpeza)
  - [5.15 Isolamento de Atividades Não Relacionadas](#515-isolamento-de-atividades-não-relacionadas)
  - [5.16 Dependências do Cenário](#516-dependências-do-cenário)
  - [5.17 Variantes do Cenário](#517-variantes-do-cenário)
  - [5.18 Identificação do Cenário](#518-identificação-do-cenário)
  - [5.19 Versionamento do Cenário](#519-versionamento-do-cenário)
  - [5.20 Revisabilidade do Cenário](#520-revisabilidade-do-cenário)

- [6. Resultados Esperados e Critérios de Aceitação](#6-resultados-esperados-e-critérios-de-aceitação)
  - [6.1 Comportamento Esperado](#61-comportamento-esperado)
  - [6.2 Estado Resultante Esperado](#62-estado-resultante-esperado)
  - [6.3 Resultados Determinísticos](#63-resultados-determinísticos)
  - [6.4 Medições Não Determinísticas](#64-medições-não-determinísticas)
  - [6.5 Critérios de Transição de Estado](#65-critérios-de-transição-de-estado)
  - [6.6 Critérios de Correção dos Dados](#66-critérios-de-correção-dos-dados)
  - [6.7 Critérios de Escopo de Processamento](#67-critérios-de-escopo-de-processamento)
  - [6.8 Critérios de Falha](#68-critérios-de-falha)
  - [6.9 Critérios de Recuperação](#69-critérios-de-recuperação)
  - [6.10 Critérios de Qualidade de Dados e Certificação](#610-critérios-de-qualidade-de-dados-e-certificação)
  - [6.11 Critérios de Observabilidade](#611-critérios-de-observabilidade)
  - [6.12 Critérios de Segurança e Governança](#612-critérios-de-segurança-e-governança)
  - [6.13 Critérios Obrigatórios e de Suporte](#613-critérios-obrigatórios-e-de-suporte)
  - [6.14 PASS](#614-pass)
  - [6.15 FAIL](#615-fail)
  - [6.16 Resultado Inconclusivo](#616-resultado-inconclusivo)
  - [6.17 Estados Bloqueado e Não Executado](#617-estados-bloqueado-e-não-executado)
  - [6.18 Sucesso Parcial](#618-sucesso-parcial)
  - [6.19 Tolerâncias](#619-tolerâncias)
  - [6.20 Critérios com Limite de Tempo](#620-critérios-com-limite-de-tempo)
  - [6.21 Suficiência das Evidências](#621-suficiência-das-evidências)
  - [6.22 Revisão dos Critérios de Aceitação](#622-revisão-dos-critérios-de-aceitação)

- [7. Coleta e Correlação de Evidências](#7-coleta-e-correlação-de-evidências)
  - [7.1 Fontes de Evidências](#71-fontes-de-evidências)
  - [7.2 Evidências Autoritativas](#72-evidências-autoritativas)
  - [7.3 Evidências de Suporte](#73-evidências-de-suporte)
  - [7.4 A Coleta de Evidências Deve Seguir o Cenário](#74-a-coleta-de-evidências-deve-seguir-o-cenário)
  - [7.5 Evidências Pré-Execução](#75-evidências-pré-execução)
  - [7.6 Evidências da Execução](#76-evidências-da-execução)
  - [7.7 Evidências Pós-Execução](#77-evidências-pós-execução)
  - [7.8 Correlação de Evidências](#78-correlação-de-evidências)
  - [7.9 Correlação Temporal](#79-correlação-temporal)
  - [7.10 Correlação do Escopo de Processamento](#710-correlação-do-escopo-de-processamento)
  - [7.11 Correlação de Falhas](#711-correlação-de-falhas)
  - [7.12 Correlação da Recuperação](#712-correlação-da-recuperação)
  - [7.13 Evidências entre Etapas](#713-evidências-entre-etapas)
  - [7.14 Consistência das Evidências](#714-consistência-das-evidências)
  - [7.15 Completude das Evidências](#715-completude-das-evidências)
  - [7.16 Integridade das Evidências](#716-integridade-das-evidências)
  - [7.17 Evidências Visuais](#717-evidências-visuais)
  - [7.18 Coleta Automatizada de Evidências](#718-coleta-automatizada-de-evidências)
  - [7.19 Coleta Manual de Evidências](#719-coleta-manual-de-evidências)
  - [7.20 Nomenclatura e Organização das Evidências](#720-nomenclatura-e-organização-das-evidências)
  - [7.21 Evidências e Novos Testes](#721-evidências-e-novos-testes)
  - [7.22 Evidências e Regressão](#722-evidências-e-regressão)
  - [7.23 Segurança e Governança das Evidências](#723-segurança-e-governança-das-evidências)
  - [7.24 Qualidade das Evidências](#724-qualidade-das-evidências)
  - [7.25 As Evidências Sustentam a Conclusão](#725-as-evidências-sustentam-a-conclusão)

- [8. Testes de Falha e Recuperação](#8-testes-de-falha-e-recuperação)
  - [8.1 Seleção de Cenários de Falha](#81-seleção-de-cenários-de-falha)
  - [8.2 Injeção Controlada de Falhas](#82-injeção-controlada-de-falhas)
  - [8.3 Estado Pré-Falha](#83-estado-pré-falha)
  - [8.4 Detecção de Falhas](#84-detecção-de-falhas)
  - [8.5 Isolamento de Falhas](#85-isolamento-de-falhas)
  - [8.6 Estado de Falha e Evidências Duráveis](#86-estado-de-falha-e-evidências-duráveis)
  - [8.7 Testes de Novas Tentativas](#87-testes-de-novas-tentativas)
  - [8.8 Testes de Reinicialização](#88-testes-de-reinicialização)
  - [8.9 Testes de *Replay*](#89-testes-de-replay)
  - [8.10 Testes de Reprocessamento](#810-testes-de-reprocessamento)
  - [8.11 Testes de *Backfill*](#811-testes-de-backfill)
  - [8.12 Testes de *Rebuild*](#812-testes-de-rebuild)
  - [8.13 Testes de Criação de *Backlog*](#813-testes-de-criação-de-backlog)
  - [8.14 Testes de Recuperação de *Backlog* e *Catch-Up*](#814-testes-de-recuperação-de-backlog-e-catch-up)
  - [8.15 Validação do Escopo de Recuperação](#815-validação-do-escopo-de-recuperação)
  - [8.16 Testes de Recuperação de *Checkpoints*](#816-testes-de-recuperação-de-checkpoints)
  - [8.17 Validação de Duplicidades e Omissões](#817-validação-de-duplicidades-e-omissões)
  - [8.18 Testes de Registros Venenosos](#818-testes-de-registros-venenosos)
  - [8.19 Testes de Falha na Recuperação](#819-testes-de-falha-na-recuperação)
  - [8.20 Recuperação Concorrente e Novo Processamento](#820-recuperação-concorrente-e-novo-processamento)
  - [8.21 Validação da Conclusão da Recuperação](#821-validação-da-conclusão-da-recuperação)
  - [8.22 Validação Pós-Recuperação](#822-validação-pós-recuperação)
  - [8.23 Validação de RPO](#823-validação-de-rpo)
  - [8.24 Validação de RTO](#824-validação-de-rto)
  - [8.25 Validação da Observabilidade da Recuperação](#825-validação-da-observabilidade-da-recuperação)
  - [8.26 Testes Repetidos de Recuperação](#826-testes-repetidos-de-recuperação)
  - [8.27 Evidências de Falha e Recuperação](#827-evidências-de-falha-e-recuperação)
  - [8.28 Afirmações de Resiliência em Laboratório](#828-afirmações-de-resiliência-em-laboratório)

- [9. Validação de Qualidade de Dados, Certificação e Segurança](#9-validação-de-qualidade-de-dados-certificação-e-segurança)
  - [9.1 Validação de Qualidade de Dados](#91-validação-de-qualidade-de-dados)
  - [9.2 Cenários com Dados Válidos](#92-cenários-com-dados-válidos)
  - [9.3 Cenários com Dados Inválidos](#93-cenários-com-dados-inválidos)
  - [9.4 Rejeição Esperada](#94-rejeição-esperada)
  - [9.5 Rejeição Inesperada](#95-rejeição-inesperada)
  - [9.6 Tratamento de Dados Rejeitados](#96-tratamento-de-dados-rejeitados)
  - [9.7 Validação de Limites de Qualidade](#97-validação-de-limites-de-qualidade)
  - [9.8 Validação da Certificação](#98-validação-da-certificação)
  - [9.9 Certificação Bem-Sucedida](#99-certificação-bem-sucedida)
  - [9.10 Falha de Certificação](#910-falha-de-certificação)
  - [9.11 Recuperação da Certificação](#911-recuperação-da-certificação)
  - [9.12 Escopo da Certificação](#912-escopo-da-certificação)
  - [9.13 Disponibilidade *Downstream* de Dados Certificados](#913-disponibilidade-downstream-de-dados-certificados)
  - [9.14 Validação de Segurança](#914-validação-de-segurança)
  - [9.15 Acesso Autorizado](#915-acesso-autorizado)
  - [9.16 Acesso Não Autorizado](#916-acesso-não-autorizado)
  - [9.17 Validação de Menor Privilégio](#917-validação-de-menor-privilégio)
  - [9.18 Validação do Tratamento de Segredos](#918-validação-do-tratamento-de-segredos)
  - [9.19 Validação da Exposição de Dados Sensíveis](#919-validação-da-exposição-de-dados-sensíveis)
  - [9.20 Validação da Auditabilidade](#920-validação-da-auditabilidade)
  - [9.21 Validação da Retenção](#921-validação-da-retenção)
  - [9.22 Validação da Exclusão](#922-validação-da-exclusão)
  - [9.23 Segurança das Evidências de Teste](#923-segurança-das-evidências-de-teste)
  - [9.24 Evidências de Falha de Segurança](#924-evidências-de-falha-de-segurança)
  - [9.25 Limites da Validação de Governança](#925-limites-da-validação-de-governança)
  - [9.26 Cenários entre Controles](#926-cenários-entre-controles)
  - [9.27 Evidências de Validação](#927-evidências-de-validação)

- [10. Validação *End-to-End* e Arquitetural](#10-validação-end-to-end-e-arquitetural)
  - [10.1 Objetivo da Validação *End-to-End*](#101-objetivo-da-validação-end-to-end)
  - [10.2 Escopo de Processamento *End-to-End*](#102-escopo-de-processamento-end-to-end)
  - [10.3 Validação da Origem](#103-validação-da-origem)
  - [10.4 Validação da Ingestão](#104-validação-da-ingestão)
  - [10.5 Validação do Transporte pelo Kafka](#105-validação-do-transporte-pelo-kafka)
  - [10.6 Validação da Bronze](#106-validação-da-bronze)
  - [10.7 Validação da Silver](#107-validação-da-silver)
  - [10.8 Validação da Gold](#108-validação-da-gold)
  - [10.9 Validação da Certificação](#109-validação-da-certificação)
  - [10.10 Validação *Downstream*](#1010-validação-downstream)
  - [10.11 Correção dos Dados entre Etapas](#1011-correção-dos-dados-entre-etapas)
  - [10.12 Completude entre Etapas](#1012-completude-entre-etapas)
  - [10.13 Rastreabilidade entre Etapas](#1013-rastreabilidade-entre-etapas)
  - [10.14 Atualidade *End-to-End*](#1014-atualidade-end-to-end)
  - [10.15 Validação de Falha *End-to-End*](#1015-validação-de-falha-end-to-end)
  - [10.16 Validação de Recuperação *End-to-End*](#1016-validação-de-recuperação-end-to-end)
  - [10.17 Certificação como Limite *End-to-End*](#1017-certificação-como-limite-end-to-end)
  - [10.18 Disponibilidade *Downstream* Faz Parte do Resultado](#1018-disponibilidade-downstream-faz-parte-do-resultado)
  - [10.19 Validação de Cenários Arquiteturais](#1019-validação-de-cenários-arquiteturais)
  - [10.20 Validação entre Documentos](#1020-validação-entre-documentos)
  - [10.21 Validação de Afirmações Arquiteturais](#1021-validação-de-afirmações-arquiteturais)
  - [10.22 Validação de Garantias Negativas](#1022-validação-de-garantias-negativas)
  - [10.23 Validação Arquitetural com Múltiplos Cenários](#1023-validação-arquitetural-com-múltiplos-cenários)
  - [10.24 Regressão do Comportamento Arquitetural](#1024-regressão-do-comportamento-arquitetural)
  - [10.25 Matriz de Validação Arquitetural](#1025-matriz-de-validação-arquitetural)
  - [10.26 Pacote de Evidências *End-to-End*](#1026-pacote-de-evidências-end-to-end)
  - [10.27 Conclusão da Validação Arquitetural](#1027-conclusão-da-validação-arquitetural)

- [11. Preservação de Evidências e Histórico de Testes](#11-preservação-de-evidências-e-histórico-de-testes)
  - [11.1 Objetivos da Preservação](#111-objetivos-da-preservação)
  - [11.2 Preservação da Definição do Cenário](#112-preservação-da-definição-do-cenário)
  - [11.3 Histórico de Execuções](#113-histórico-de-execuções)
  - [11.4 Preservação do Resultado](#114-preservação-do-resultado)
  - [11.5 Histórico de Testes com Falha](#115-histórico-de-testes-com-falha)
  - [11.6 Histórico de Diagnóstico](#116-histórico-de-diagnóstico)
  - [11.7 Histórico de Correções](#117-histórico-de-correções)
  - [11.8 Histórico de Novos Testes](#118-histórico-de-novos-testes)
  - [11.9 Histórico de Regressão](#119-histórico-de-regressão)
  - [11.10 Contexto de Versão das Evidências](#1110-contexto-de-versão-das-evidências)
  - [11.11 Substituição das Evidências](#1111-substituição-das-evidências)
  - [11.12 Validade das Evidências](#1112-validade-das-evidências)
  - [11.13 Categorias de Retenção de Evidências](#1113-categorias-de-retenção-de-evidências)
  - [11.14 Evidências de Alto Volume](#1114-evidências-de-alto-volume)
  - [11.15 Evidências Brutas e Resumidas](#1115-evidências-brutas-e-resumidas)
  - [11.16 Reprodutibilidade das Evidências](#1116-reprodutibilidade-das-evidências)
  - [11.17 Integridade das Evidências](#1117-integridade-das-evidências)
  - [11.18 Rastreabilidade das Evidências](#1118-rastreabilidade-das-evidências)
  - [11.19 Localização das Evidências](#1119-localização-das-evidências)
  - [11.20 Segurança das Evidências](#1120-segurança-das-evidências)
  - [11.21 Exclusão de Evidências](#1121-exclusão-de-evidências)
  - [11.22 Evidências de Marcos Arquiteturais](#1122-evidências-de-marcos-arquiteturais)
  - [11.23 Evidências de Portfólio](#1123-evidências-de-portfólio)
  - [11.24 Estado Atual da Validação](#1124-estado-atual-da-validação)
  - [11.25 Histórico de Testes como Evidência de Engenharia](#1125-histórico-de-testes-como-evidência-de-engenharia)

- [12. Limites Arquiteturais e Princípios de Encerramento](#12-limites-arquiteturais-e-princípios-de-encerramento)
  - [12.1 Limite de Processamento](#121-limite-de-processamento)
  - [12.2 Limite de Confiabilidade e Recuperação](#122-limite-de-confiabilidade-e-recuperação)
  - [12.3 Limite de Segurança e Governança](#123-limite-de-segurança-e-governança)
  - [12.4 Limite de Observabilidade](#124-limite-de-observabilidade)
  - [12.5 Limite de Qualidade de Dados e Certificação](#125-limite-de-qualidade-de-dados-e-certificação)
  - [12.6 Limite de Requisitos](#126-limite-de-requisitos)
  - [12.7 Limite de Implementação](#127-limite-de-implementação)
  - [12.8 Limite da Automação de Testes](#128-limite-da-automação-de-testes)
  - [12.9 Limite de Ferramentas](#129-limite-de-ferramentas)
  - [12.10 Limite entre Laboratório e Ambiente Corporativo](#1210-limite-entre-laboratório-e-ambiente-corporativo)
  - [12.11 Limite das Evidências](#1211-limite-das-evidências)
  - [12.12 Limite da Documentação](#1212-limite-da-documentação)
  - [12.13 Retorno para a Arquitetura](#1213-retorno-para-a-arquitetura)
  - [12.14 Princípios de Encerramento](#1214-princípios-de-encerramento)

---

## 1. Propósito e Escopo

Este documento define a estratégia de testes e evidências da plataforma de dados Atlas Engineering.

Seu propósito é estabelecer como comportamentos arquiteturais, garantias de processamento, tratamento de falhas, mecanismos de recuperação, controles de qualidade de dados, controles de segurança, capacidades de observabilidade e outras responsabilidades relevantes da plataforma são validados por meio de cenários controlados e repetíveis.

Os testes são tratados como uma capacidade de validação arquitetural, e não como uma atividade final de verificação realizada somente após a implementação.

O objetivo não é apenas demonstrar que componentes individuais podem ser executados com sucesso.

A estratégia deve fornecer evidências suficientes para determinar se a plataforma se comporta conforme projetado durante o processamento normal, condições de falha, operações de recuperação, violações de qualidade de dados e outros cenários relevantes para as garantias arquiteturais que estão sendo avaliadas.

O modelo de testes, portanto, abrange aspectos que incluem:

- processamento *end-to-end* normal;
- comportamento de componentes e etapas de processamento;
- contratos e validação de dados;
- qualidade e certificação de dados;
- detecção e isolamento de falhas;
- comportamento de novas tentativas;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- recuperação de *backlog*;
- comportamento de *checkpoints* e estado durável;
- observabilidade;
- controles de segurança e governança quando forem viáveis de testar na prática;
- disponibilidade de dados *downstream*;
- objetivos de recuperação;
- comportamento de reexecução e repetibilidade.

Os testes devem ser projetados com expectativas explícitas.

Quando viável, um cenário de validação deve estabelecer, antes da execução:

- qual comportamento está sendo avaliado;
- quais pré-condições são necessárias;
- qual escopo de processamento está envolvido;
- qual ação ou condição de falha será introduzida;
- qual resultado é esperado;
- quais evidências devem ser coletadas;
- qual estado autoritativo deve ser verificado;
- quais condições determinam PASS ou FAIL.

A estratégia distingue execução bem-sucedida de validação bem-sucedida.

A conclusão de um processo sem erro não comprova, por si só, que o comportamento arquitetural esperado ocorreu.

A validação pode exigir a análise de:

- dados resultantes;
- estado autoritativo de processamento;
- *checkpoints*;
- resultados de certificação;
- *logs*;
- eventos operacionais;
- métricas;
- *offsets* ou *lag* do Kafka;
- metadados de recuperação;
- estado *downstream*;
- outras evidências relevantes para o comportamento que está sendo testado.

As evidências devem ser suficientes para sustentar a conclusão alcançada pelo teste sem exigir suposições não fundamentadas sobre o que ocorreu internamente.

Testes que falharam fazem parte das evidências de engenharia.

Uma validação que falhou não deve ser removida apenas para apresentar um histórico de execução limpo. Quando um defeito ou lacuna arquitetural for identificado, as evidências devem preservar a relação entre:

**comportamento esperado → comportamento observado → diagnóstico → correção → novo teste → comportamento resultante.**

Isso permite que o projeto diferencie claramente entre:

**comportamento projetado** — o que a arquitetura especifica;

**comportamento implementado** — o que foi construído;

**comportamento validado** — o que os testes controlados e as evidências resultantes demonstram.

Este documento define a estratégia para comprovar o comportamento arquitetural implementado.

Ele não redefine a semântica de processamento estabelecida por **Fluxo e Processamento de Dados**, as garantias de recuperação estabelecidas por **Confiabilidade e Recuperação**, os controles estabelecidos por **Segurança e Governança** ou o modelo de evidências operacionais estabelecido por **Observabilidade**.

Em vez disso, ele define como essas responsabilidades são testadas sistematicamente e como as evidências resultantes são avaliadas e preservadas.

---

## 2. Princípios de Testes

Os testes no Atlas Engineering devem fornecer evidências repetíveis e revisáveis de que o comportamento implementado da plataforma é consistente com a arquitetura.

Os testes devem avaliar comportamentos significativos, em vez de apenas demonstrar que tecnologias individuais podem ser executadas.

Os princípios a seguir regem a estratégia de testes e evidências.

### 2.1 Os Testes São Projetados com a Arquitetura

Os requisitos de testes devem ser considerados quando o comportamento arquitetural é definido.

Um comportamento que não pode ser validado de forma significativa cria incerteza sobre se a implementação atende à arquitetura pretendida.

Quando viável, as decisões arquiteturais devem, portanto, preferencialmente identificar:

- qual comportamento deve ser demonstrado;
- qual estado ou resultado pode verificar esse comportamento;
- quais evidências são necessárias;
- quais condições de falha são relevantes;
- qual comportamento de recuperação deve ser observável;
- quais condições determinam uma validação bem-sucedida.

Os testes não são adiados até que a arquitetura e a implementação sejam consideradas concluídas.

### 2.2 Os Testes Devem Ter Intenção Explícita

Todo teste relevante deve identificar qual comportamento pretende avaliar.

Um teste não deve existir apenas porque um componente, *framework* ou ferramenta de testes facilita sua execução.

A intenção do teste deve, preferencialmente, deixar claro:

- a responsabilidade arquitetural que está sendo avaliada;
- o escopo de processamento envolvido;
- o comportamento esperado;
- os critérios de aceitação relevantes;
- as evidências necessárias para sustentar o resultado.

A intenção explícita permite que o resultado do teste seja interpretado em relação a uma expectativa arquitetural, e não apenas em relação ao sucesso da execução.

### 2.3 O Comportamento Esperado Deve Ser Definido Antes da Avaliação

Quando viável, o comportamento esperado e os critérios de aceitação devem ser definidos antes que o resultado do teste seja avaliado.

Isso reduz o risco de interpretar qualquer resultado observado após a execução como evidência de que a arquitetura se comportou corretamente.

O comportamento esperado pode incluir:

- estado dos dados resultantes;
- estado de processamento;
- progressão de *checkpoints*;
- estado de certificação;
- comportamento de falha;
- comportamento de novas tentativas;
- comportamento de recuperação;
- evidências de observabilidade;
- disponibilidade *downstream*.

Comportamentos inesperados devem permanecer visíveis mesmo quando o resultado final parecer operacionalmente aceitável.

### 2.4 Execução Bem-Sucedida Não É Evidência Suficiente

A conclusão bem-sucedida de um processo de teste não comprova, por si só, que o comportamento testado estava correto.

Por exemplo:

- um *pipeline* pode ser concluído enquanto produz dados incorretos;
- uma nova tentativa pode ser bem-sucedida após repetir trabalho não intencional;
- um *replay* pode ser concluído enquanto omite parte do escopo pretendido;
- um processo de recuperação pode ser concluído enquanto o *backlog* permanece não resolvido;
- uma carga na Gold pode ser concluída enquanto a certificação falha;
- um alerta pode ser disparado enquanto a condição subjacente é identificada incorretamente.

A validação deve avaliar o estado resultante e as evidências relevantes, e não apenas o status de saída da execução.

### 2.5 Os Testes Devem Verificar o Estado Autoritativo

Quando um comportamento arquitetural depender de estado autoritativo, a validação deve examinar esse estado diretamente.

Evidências autoritativas relevantes podem incluir:

- dados persistidos na origem ou no destino;
- estado de processamento;
- *checkpoints* duráveis;
- *offsets* do Kafka, quando aplicável;
- estado de certificação;
- estado de recuperação;
- disponibilidade de dados *downstream*.

*Logs*, métricas, alertas e *dashboards* podem apoiar a validação, mas não devem substituir o estado autoritativo quando este estiver disponível.

### 2.6 Os Testes Devem Ser Repetíveis

Cenários de validação relevantes devem, preferencialmente, ser repetíveis sob condições controladas equivalentes.

A repetibilidade exige informações suficientes para reconstruir:

- pré-condições;
- dados de teste ou escopo de processamento;
- configuração relevante para o cenário;
- ações realizadas;
- condições de falha introduzidas;
- resultados esperados;
- etapas de validação.

Execuções equivalentes e repetidas não precisam produzir *timestamps*, identificadores, durações ou medições de infraestrutura idênticos.

Elas devem produzir um comportamento consistente com as mesmas expectativas arquiteturais.

### 2.7 Os Testes Devem Preservar o Escopo de Processamento

A validação deve identificar quais dados, execução, lote, partição, intervalo de *offsets*, janela de tempo, conjunto de dados ou outro escopo determinístico estão sendo testados.

Isso é particularmente importante para:

- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- nova tentativa;
- isolamento de falhas;
- recuperação de *backlog*.

Sem um escopo de processamento explícito, pode ser impossível determinar se o trabalho pretendido foi concluído, repetido, omitido ou afetado involuntariamente.

### 2.8 A Falha É um Resultado de Teste Válido

Um teste que falhou constitui evidência de engenharia válida.

Um teste que expõe um defeito de implementação, uma suposição incorreta, um controle ausente, observabilidade incompleta ou uma lacuna arquitetural produziu informações úteis.

A falha não deve ser ocultada apenas porque uma correção posterior foi bem-sucedida.

Quando relevante, as evidências devem, preferencialmente, preservar:

- comportamento esperado;
- comportamento observado;
- condição de falha;
- diagnóstico;
- correção;
- novo teste;
- resultado final.

O objetivo não é produzir um histórico artificial no qual todos os testes foram aprovados na primeira execução.

O objetivo é demonstrar como a plataforma foi validada e aprimorada.

### 2.9 Os Testes de Falha Devem Ser Controlados

As falhas introduzidas para validação devem ter propósito, escopo e procedimentos de restauração explícitos.

Os testes controlados de falha devem evitar criar ambiguidade sobre se o comportamento resultante foi causado pelo cenário pretendido ou por condições ambientais não relacionadas.

Quando viável, um cenário de falha deve, preferencialmente, definir:

- a condição que está sendo introduzida;
- o componente ou a etapa de processamento afetada;
- a duração pretendida;
- a resposta esperada da plataforma;
- o comportamento de recuperação esperado;
- a ação de restauração;
- as evidências necessárias após a restauração.

A injeção de falhas é uma técnica de validação, e não uma interrupção não controlada.

### 2.10 A Recuperação Deve Ser Validada Além da Reinicialização

Os testes de recuperação devem verificar o estado resultante de processamento e dos dados após a execução do mecanismo de recuperação.

Reiniciar um componente, retomar um consumidor ou concluir um *job* de recuperação não demonstra, por si só, uma recuperação bem-sucedida.

A validação pode precisar determinar:

- se o processamento foi retomado a partir da posição correta;
- se o escopo pretendido foi concluído;
- se duplicidades não intencionais foram introduzidas;
- se dados foram omitidos;
- se os *checkpoints* progrediram corretamente;
- se o *backlog* convergiu;
- se o processamento *downstream* foi retomado;
- se a certificação foi bem-sucedida;
- se a atualidade esperada foi restaurada.

A recuperação é validada pelo estado restaurado, e não apenas pela retomada da execução.

### 2.11 As Evidências Devem Ser Correlacionadas

As evidências coletadas para um cenário de validação devem ser atribuíveis à execução e ao escopo de processamento que estão sendo testados.

Quando aplicável, a correlação deve, preferencialmente, conectar:

- cenário de teste;
- identificadores de execução;
- escopo de processamento;
- *timestamps*;
- dados resultantes;
- *checkpoints*;
- *logs*;
- eventos operacionais;
- métricas;
- falhas;
- atividade de recuperação;
- resultados de certificação;
- estado *downstream*.

Evidências que não possam ser relacionadas de forma confiável ao cenário testado possuem valor limitado para validação.

### 2.12 As Evidências Devem Ser Proporcionais

Os testes devem coletar evidências suficientes para sustentar a conclusão da validação sem preservar informações desnecessárias.

As evidências necessárias dependem do comportamento que está sendo testado.

Uma validação determinística simples pode exigir apenas o estado resultante e evidências de execução.

Um cenário de falha e recuperação pode exigir estado correlacionado, *logs*, métricas, *checkpoints*, eventos de recuperação e validação *downstream*.

O volume de evidências deve permanecer proporcional ao seu valor diagnóstico, de validação, histórico e arquitetural.

### 2.13 Os Testes Devem Respeitar a Segurança e a Governança

Os testes não ignoram o modelo de segurança e governança da plataforma.

Dados de teste, *logs*, evidências preservadas, artefatos de falha, registros rejeitados, credenciais e metadados operacionais permanecem sujeitos aos controles aplicáveis.

Os testes devem evitar a exposição desnecessária de:

- credenciais;
- segredos;
- *tokens*;
- dados pessoais;
- informações comerciais sensíveis;
- *payloads* completos quando não forem necessários.

As evidências preservadas para validação arquitetural são, elas próprias, dados governados.

### 2.14 Os Testes Devem Distinguir Evidências de Laboratório de Garantias Corporativas

O Atlas Engineering utiliza cenários controlados de laboratório para demonstrar comportamentos arquiteturais orientados à produção.

Uma validação bem-sucedida em laboratório demonstra que o comportamento implementado operou conforme esperado sob as condições testadas.

Ela não comprova, por si só, o comportamento sob todas as cargas de trabalho em escala corporativa, falhas de infraestrutura, indisponibilidades geográficas, incidentes de segurança ou condições operacionais.

As afirmações baseadas em testes devem permanecer proporcionais aos cenários e às evidências efetivamente validados.

### 2.15 A Validação Deve Ser Revisável

Um resultado de teste relevante deve, preferencialmente, ser compreensível por alguém diferente da pessoa que o executou.

As informações preservadas devem, preferencialmente, permitir determinar:

- o que foi testado;
- por que foi testado;
- o que era esperado;
- o que realmente ocorreu;
- quais evidências sustentam a conclusão;
- se o teste foi aprovado ou reprovado;
- o que mudou caso um novo teste tenha sido necessário.

Um teste que só pode ser interpretado por meio de conhecimento pessoal não documentado não constitui evidência arquitetural suficiente.

---

## 3. Modelo de Testes e Evidências

O modelo de testes do Atlas Engineering conecta expectativas arquiteturais à execução controlada, ao estado resultante, às evidências coletadas e às conclusões explícitas da validação.

Um teste não é representado apenas por uma ação e um resultado PASS ou FAIL.

Uma validação relevante deve preservar contexto suficiente para determinar qual comportamento era esperado, quais condições foram estabelecidas, o que ocorreu durante a execução, qual estado resultou e por que as evidências disponíveis sustentam a conclusão final.

O modelo, portanto, trata os testes como uma relação entre:

**expectativa arquitetural → cenário de validação → execução controlada → comportamento observado → estado resultante → evidências → resultado da validação.**

### 3.1 Expectativa Arquitetural

Um teste relevante começa com uma expectativa arquitetural.

A expectativa identifica o comportamento que se espera que a plataforma forneça.

Exemplos podem incluir:

- alterações na origem tornam-se disponíveis para processamento *downstream*;
- o processamento preserva os contratos de dados definidos;
- registros inválidos são rejeitados de acordo com as regras estabelecidas;
- *checkpoints* duráveis preservam a posição de reinicialização;
- novas tentativas não criam efeitos de processamento não intencionais;
- o *replay* processa o escopo histórico pretendido;
- o *backlog* converge após a restauração da capacidade de processamento;
- a certificação impede que dados não validados se tornem certificados;
- falhas relevantes produzem evidências observáveis;
- controles de segurança impedem acesso não autorizado.

A expectativa deve ser derivada de uma responsabilidade arquitetural implementada, e não inventada exclusivamente para o teste.

### 3.2 Cenário de Validação

Um cenário de validação traduz uma expectativa arquitetural em uma condição controlada que pode ser executada e avaliada.

Um cenário deve, preferencialmente, identificar, quando aplicável:

- objetivo;
- responsabilidade arquitetural;
- pré-condições;
- escopo de processamento;
- dados de teste;
- estado inicial;
- ação realizada;
- condição ou falha introduzida;
- comportamento esperado;
- evidências esperadas;
- critérios de aceitação;
- requisitos de restauração.

Uma única expectativa arquitetural pode exigir múltiplos cenários quando o comportamento diferir entre processamento normal, falha, recuperação ou condições de limite.

### 3.3 Execução do Teste

A execução do teste é a realização controlada do cenário de validação.

A execução deve, preferencialmente, preservar contexto suficiente para distingui-la de atividades não relacionadas da plataforma.

Quando viável, as informações da execução devem, preferencialmente, incluir:

- identificador do cenário;
- identificador da execução;
- horário da execução;
- ambiente;
- configuração relevante;
- escopo de processamento;
- referência dos dados de teste;
- ações realizadas;
- falha ou condição introduzida;
- ação de restauração, quando aplicável.

O registro da execução fornece contexto para interpretar as evidências resultantes.

### 3.4 Comportamento Observado

O comportamento observado representa o que ocorreu durante a execução do teste.

Ele pode incluir:

- progressão do processamento;
- transições de estado;
- falhas;
- novas tentativas;
- registros rejeitados;
- movimentação de *checkpoints*;
- comportamento do *backlog*;
- atividade de recuperação;
- resultados de certificação;
- disponibilidade *downstream*;
- comportamento dos controles de segurança;
- sinais de observabilidade.

O comportamento observado deve ser registrado independentemente do comportamento esperado.

O teste não deve reescrever a expectativa após a execução apenas para fazê-la corresponder ao que ocorreu.

### 3.5 Estado Resultante

A validação deve determinar o estado relevante produzido pelo teste.

Dependendo do cenário, o estado resultante pode incluir:

- dados persistidos;
- status do processamento;
- posição do *checkpoint*;
- estado dos *offsets* do Kafka;
- estado dos dados rejeitados;
- estado de certificação;
- estado de recuperação;
- disponibilidade de dados *downstream*;
- resultado do controle de acesso;
- outro estado autoritativo definido pela arquitetura.

O estado resultante é particularmente importante quando a execução parece bem-sucedida, mas o resultado arquitetural pretendido pode não ter sido alcançado.

### 3.6 Evidências

Evidências são as informações utilizadas para sustentar a conclusão da validação.

As evidências podem incluir:

- estado autoritativo resultante;
- dados resultantes;
- registros de execução;
- *checkpoints*;
- *offsets* do Kafka;
- *logs*;
- eventos operacionais estruturados;
- métricas;
- medições de *backlog* ou *lag*;
- registros de recuperação;
- resultados de certificação;
- registros de dados rejeitados;
- validação *downstream*;
- resultados de segurança ou controle de acesso;
- capturas de tela selecionadas ou artefatos visuais, quando úteis.

Nenhum tipo de evidência é automaticamente suficiente para todos os testes.

O conjunto de evidências deve ser apropriado ao comportamento arquitetural que está sendo avaliado.

### 3.7 Evidências Esperadas

Quando viável, as evidências esperadas de um cenário devem ser identificadas antes da execução.

As evidências esperadas descrevem o que deve, preferencialmente, tornar-se observável se a plataforma se comportar conforme projetado.

Por exemplo, espera-se que uma interrupção controlada de um consumidor produza:

1. consumo interrompido ou reduzido;
2. aumento do *lag* do consumidor;
3. atraso no processamento *downstream*;
4. um sinal operacional caso uma condição de alerta estabelecida seja atingida;
5. retomada do consumo após a restauração;
6. redução do *backlog*;
7. restauração da atualidade *downstream*.

As evidências reais devem então ser comparadas com essas expectativas.

As evidências esperadas não devem ser confundidas com as evidências efetivamente observadas.

### 3.8 Critérios de Aceitação

Os critérios de aceitação definem as condições que devem ser satisfeitas para que o comportamento testado seja considerado validado.

Os critérios devem ser específicos o suficiente para sustentar uma decisão defensável de PASS ou FAIL.

Dependendo do cenário, os critérios podem avaliar:

- correção dos dados resultantes;
- conclusão esperada do processamento;
- posição do *checkpoint*;
- ausência de duplicidades não intencionais;
- ausência de omissões não intencionais;
- comportamento esperado de rejeição;
- resultado da certificação;
- conclusão da recuperação;
- convergência do *backlog*;
- restauração da atualidade;
- evidências de observabilidade esperadas;
- aplicação dos controles de segurança.

Um teste pode conter múltiplos critérios de aceitação.

Todos os critérios identificados como obrigatórios devem ser satisfeitos para que o cenário seja considerado PASS.

### 3.9 Resultado da Validação

Uma execução de validação deve produzir um resultado explícito.

No mínimo, o resultado deve distinguir:

- **PASS** — os critérios de aceitação obrigatórios foram satisfeitos;
- **FAIL** — um ou mais critérios de aceitação obrigatórios não foram satisfeitos.

Quando útil, uma implementação pode representar adicionalmente estados como:

- não executado;
- em andamento;
- bloqueado;
- inconclusivo.

Esses estados não devem ser apresentados como PASS.

Um teste inconclusivo indica que as evidências disponíveis são insuficientes para sustentar uma validação bem-sucedida ou uma validação com falha e deve resultar em investigação ou testes adicionais.

### 3.10 Diagnóstico e Correção de Falhas

Quando um teste falha, o registro de validação deve, preferencialmente, preservar a relação entre a falha observada e qualquer ação de engenharia resultante.

Quando aplicável, isso pode incluir:

- critério de aceitação não atendido;
- evidências observadas;
- causa suspeita;
- causa confirmada;
- lacuna arquitetural;
- defeito de implementação;
- problema de configuração;
- problema no projeto do teste;
- correção aplicada;
- alteração na documentação;
- alteração de requisito.

Um teste que falhou não comprova automaticamente que a implementação está com defeito.

O próprio teste, sua expectativa ou seu ambiente podem estar incorretos.

O diagnóstico deve determinar qual suposição ou implementação requer correção.

### 3.11 Novo Teste

Uma correção que afete um comportamento validado deve ser seguida por um novo teste apropriado.

O novo teste deve, preferencialmente, preservar sua relação com a execução anterior que falhou, em vez de substituí-la.

Um histórico de validação pode, portanto, apresentar:

**FAIL → diagnóstico → correção → NOVO TESTE → PASS**

ou:

**FAIL → diagnóstico → correção → NOVO TESTE → FAIL**

até que o comportamento esperado seja demonstrado ou que a expectativa arquitetural subjacente seja formalmente revisada.

As evidências anteriores permanecem como parte do histórico de engenharia.

### 3.12 Pacote de Evidências do Teste

Para cenários arquiteturais relevantes, as informações coletadas podem ser organizadas como um pacote de evidências do teste.

Um pacote de evidências do teste pode conter:

- definição do cenário;
- expectativa arquitetural;
- referência do requisito ou da arquitetura;
- informações da execução;
- escopo de processamento;
- comportamento esperado;
- evidências esperadas;
- critérios de aceitação;
- comportamento observado;
- estado resultante;
- evidências coletadas;
- resultado PASS ou FAIL;
- diagnóstico, quando necessário;
- correção, quando necessária;
- relação com o novo teste;
- estado final validado.

A representação física exata pode variar de acordo com o tipo de teste.

A arquitetura define as informações que devem permanecer compreensíveis e revisáveis, em vez de exigir que todos os testes utilizem um formato de artefato idêntico.

### 3.13 Rastreabilidade das Evidências

Evidências relevantes devem, preferencialmente, ser rastreáveis até a responsabilidade arquitetural que pretendem validar.

Quando viável, o projeto deve, preferencialmente, ser capaz de navegar pela relação:

**arquitetura → requisito → cenário de teste → execução → evidências → resultado.**

Essa relação permite que afirmações arquiteturais sejam sustentadas por validações concretas, e não apenas pela documentação.

A relação inversa também é valiosa:

**evidência de falha → cenário de teste → requisito → responsabilidade arquitetural.**

Isso permite que falhas descobertas durante os testes identifiquem qual comportamento arquitetural pode exigir revisão de implementação, requisito ou projeto.

### 3.14 Evidências Não Substituem a Arquitetura

As evidências dos testes demonstram o comportamento observado sob condições definidas.

Elas não redefinem a arquitetura pretendida.

Se o comportamento da implementação e a expectativa arquitetural divergirem, a divergência deve ser investigada.

A resolução apropriada pode ser:

- corrigir a implementação;
- corrigir o teste;
- corrigir uma configuração;
- esclarecer o requisito;
- revisar formalmente a arquitetura.

O comportamento observado não deve se tornar silenciosamente a nova regra arquitetural apenas porque foi isso que a implementação atual produziu.

### 3.15 A Confiança na Validação É Proporcional às Evidências

A força de uma afirmação de validação deve permanecer proporcional ao escopo e à qualidade das evidências que a sustentam.

Uma única execução bem-sucedida demonstra o comportamento sob as condições daquela execução.

Execuções controladas repetidas, cenários de limite, testes de falha, testes de recuperação, validação do estado resultante e evidências correlacionadas podem fornecer maior confiança.

Nenhum conjunto finito de testes de laboratório comprova que uma plataforma nunca poderá falhar.

O propósito do modelo de testes é fornecer evidências disciplinadas e revisáveis de que a arquitetura implementada se comporta conforme esperado nos cenários que foram efetivamente validados.

---

## 4. Classificação e Cobertura de Testes

O Atlas Engineering utiliza múltiplas categorias de testes para validar diferentes aspectos do comportamento da plataforma.

Nenhuma categoria isolada de teste é suficiente para demonstrar que a plataforma atende às suas responsabilidades arquiteturais.

Os testes devem, portanto, fornecer cobertura sobre o comportamento de processamento, limites de integração, correção dos dados, tratamento de falhas, recuperação, observabilidade, segurança, governança e resultados *end-to-end*, de acordo com as capacidades efetivamente implementadas pela plataforma.

A classificação dos testes existe para organizar as responsabilidades de validação.

Ela não deve criar limites artificiais que impeçam um único cenário de validar múltiplos comportamentos arquiteturais relacionados.

### 4.1 Testes de Componentes

Os testes de componentes validam o comportamento dentro de um componente individual da plataforma ou unidade de processamento.

Dependendo do componente, a validação pode incluir:

- comportamento da configuração;
- lógica de processamento;
- lógica de transformação;
- validação de entrada;
- geração de saída;
- tratamento de erros;
- comportamento de novas tentativas;
- transições de estado;
- interação com *checkpoints*;
- evidências operacionais.

Os testes de componentes ajudam a identificar defeitos próximos à responsabilidade que os produz.

Testes de componentes bem-sucedidos não demonstram, por si só, que as integrações ou o processamento *end-to-end* se comportam corretamente.

### 4.2 Testes de Integração

Os testes de integração validam o comportamento através dos limites entre componentes.

Limites relevantes podem incluir:

- sistema de origem para ingestão;
- ingestão para Kafka;
- Kafka para consumidores;
- Kafka para Bronze;
- Bronze para Silver;
- Silver para Gold;
- processamento da Gold para certificação;
- dados certificados para consumo *downstream*;
- componentes de processamento para estado durável;
- componentes de processamento para mecanismos de observabilidade.

Os testes de integração devem avaliar o contrato e o comportamento através do limite, em vez de apenas confirmar que ambos os componentes estão disponíveis independentemente.

### 4.3 Testes de Contratos de Dados

Os testes de contratos de dados validam se os dados que atravessam limites arquiteturais estão em conformidade com a estrutura e a semântica esperadas.

Dependendo do contrato, a validação pode incluir:

- campos obrigatórios;
- tipos de dados;
- identificadores;
- estrutura dos eventos;
- valores controlados;
- compatibilidade de *schema*;
- expectativas de nulabilidade;
- semântica de *timestamps*;
- expectativas de versão;
- outras regras de contrato definidas pela plataforma.

Os testes de contratos devem, preferencialmente, incluir tanto condições aceitas quanto rejeitadas, quando relevante.

Um produtor emitir dados com sucesso e um consumidor recebê-los com sucesso não comprovam, por si só, que o contrato está correto.

### 4.4 Testes de Transformação

Os testes de transformação validam se a lógica de processamento produz o resultado de dados esperado.

A validação relevante pode incluir:

- derivação de campos;
- normalização;
- filtragem;
- desduplicação;
- enriquecimento;
- *joins*;
- agregações;
- transformações dimensionais;
- aplicação de regras de negócio;
- tratamento de valores ausentes ou inválidos.

Os testes de transformação devem comparar os dados resultantes com expectativas explícitas.

O sucesso da execução, por si só, é insuficiente.

### 4.5 Testes de Qualidade de Dados

Os testes de qualidade de dados validam os controles que determinam se os dados atendem às expectativas de qualidade estabelecidas.

Dependendo da etapa da plataforma, os testes podem incluir:

- completude;
- validade;
- unicidade;
- consistência;
- expectativas referenciais;
- registros aceitos e rejeitados;
- limites de qualidade;
- comportamento de quarentena ou rejeição;
- resultados das regras de qualidade.

Os testes de qualidade de dados devem distinguir entre:

- um registro que falha corretamente em uma regra de qualidade;
- um mecanismo de controle de qualidade que falha ao ser executado;
- uma execução de processamento que falha por um motivo operacional não relacionado.

Uma rejeição esperada pode representar um teste bem-sucedido.

### 4.6 Testes de Certificação

Os testes de certificação validam se os dados se tornam certificados somente quando as condições de validação exigidas são satisfeitas.

Os cenários devem, preferencialmente, abranger, quando aplicável:

- processamento bem-sucedido e certificação bem-sucedida;
- processamento bem-sucedido com falha na certificação;
- processamento concluído enquanto a certificação permanece pendente;
- incompletude *upstream* impedindo a certificação;
- correção dos dados ou do processamento seguida por recertificação bem-sucedida.

Os testes de certificação devem verificar o estado de certificação resultante, em vez de inferir a certificação a partir do sucesso do processamento.

### 4.7 Testes de Estado e *Checkpoints*

Os testes de estado e *checkpoints* validam o estado durável de processamento utilizado para dar suporte à reinicialização, ao acompanhamento do progresso e à recuperação.

Cenários relevantes podem avaliar:

- criação de *checkpoints*;
- progressão de *checkpoints*;
- posição de reinicialização;
- execução repetida;
- comportamento de *checkpoints* desatualizados;
- processamento interrompido;
- continuação bem-sucedida;
- relação entre o estado do *checkpoint* e os dados resultantes.

O objetivo é demonstrar que o estado durável representa o progresso do processamento de forma consistente com a semântica arquitetural definida pela plataforma.

### 4.8 Testes de Idempotência e Repetibilidade

Quando se espera que o processamento tolere execução repetida, os testes devem validar o estado resultante após um trabalho equivalente ser executado mais de uma vez.

Questões relevantes podem incluir:

- A execução repetida cria duplicidades não intencionais?
- Ela omite trabalho necessário?
- Ela altera inesperadamente dados que já estavam corretos?
- Ela preserva resultados determinísticos quando exigido?
- O estado resultante permanece consistente com a semântica de processamento pretendida?

A idempotência deve ser validada por meio do estado resultante.

Ela não deve ser presumida apenas porque um processo pode ser executado repetidamente sem gerar erro.

### 4.9 Testes de Falha

Os testes de falha validam o comportamento da plataforma quando condições controladas de falha são introduzidas.

Os cenários podem incluir:

- componente indisponível;
- processamento interrompido;
- interrupção de consumidor;
- falha transitória de dependência;
- entrada inválida;
- exceção de processamento;
- dependência *downstream* indisponível;
- restrição de capacidade;
- outras falhas representativas relevantes para a arquitetura implementada.

Os testes de falha devem, preferencialmente, avaliar:

- detecção;
- isolamento;
- estado resultante;
- comportamento de novas tentativas;
- observabilidade;
- impacto sobre outros processamentos;
- requisitos de recuperação.

Os testes de falha são expandidos posteriormente no capítulo dedicado aos testes de falha e recuperação.

### 4.10 Testes de Recuperação

Os testes de recuperação validam se a plataforma restaura o estado esperado de processamento e dos dados após uma falha ou operação controlada de recuperação.

Mecanismos relevantes podem incluir:

- nova tentativa;
- reinicialização;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- recuperação de *backlog*.

Os testes de recuperação devem verificar mais do que a execução do mecanismo de recuperação.

Eles devem avaliar o estado resultante e as garantias arquiteturais relevantes associadas a esse mecanismo.

### 4.11 Testes de *Backlog* e *Catch-Up*

Quando o processamento assíncrono puder acumular trabalho pendente, os testes devem, preferencialmente, validar o comportamento durante a criação e a recuperação de *backlog*.

Cenários relevantes podem avaliar:

- acúmulo de *backlog*;
- crescimento do *lag* do consumidor;
- *throughput* de processamento;
- idade do *backlog*;
- processamento após a restauração da capacidade;
- progressão do *catch-up*;
- convergência;
- atualidade dos dados correntes durante a recuperação.

O objetivo é determinar se a plataforma consegue retornar em direção ao seu estado esperado de processamento sob as condições de carga de trabalho e recuperação testadas.

### 4.12 Testes de Observabilidade

Os testes de observabilidade validam se a plataforma produz as evidências operacionais esperadas durante condições normais, de falha e de recuperação.

A validação relevante pode incluir:

- eventos de ciclo de vida;
- visibilidade de falhas;
- visibilidade de novas tentativas;
- visibilidade da recuperação;
- métricas;
- visibilidade de *lag* e *backlog*;
- visibilidade da atualidade;
- geração de alertas;
- resolução de alertas;
- estado dos *dashboards*;
- correlação das evidências.

Os testes de observabilidade devem avaliar se as evidências representam com precisão o comportamento subjacente.

A simples existência de telemetria não demonstra observabilidade correta.

### 4.13 Testes de Segurança e Governança

Os testes de segurança e governança validam controles que podem ser demonstrados de forma significativa dentro do ambiente de laboratório implementado.

Dependendo da capacidade testada, os cenários podem incluir:

- acesso autorizado;
- acesso negado;
- comportamento de menor privilégio;
- tratamento de segredos;
- prevenção da exposição de dados sensíveis;
- evidências de auditoria;
- comportamento de retenção;
- comportamento de exclusão;
- acesso governado às evidências operacionais.

Os testes devem permanecer dentro dos limites de segurança e governança definidos pela plataforma.

O laboratório não precisa reproduzir todas as capacidades de validação de segurança de um ambiente corporativo.

### 4.14 Testes de Performance e Capacidade

Os testes de performance e capacidade avaliam o comportamento mensurável do processamento sob condições definidas de carga de trabalho.

Medições relevantes podem incluir:

- duração do processamento;
- *throughput*;
- latência;
- *lag* do consumidor;
- crescimento do *backlog*;
- recuperação do *backlog*;
- utilização de recursos;
- atualidade dos dados.

Os resultados de performance devem preservar as condições sob as quais foram medidos.

Uma medição de laboratório não deve ser apresentada como garantia de capacidade em escala corporativa.

Os testes de performance devem, preferencialmente, estabelecer comportamentos observáveis, linhas de base, gargalos ou limitações arquiteturais sob as condições testadas.

### 4.15 Testes *End-to-End*

Os testes *end-to-end* validam o comportamento através de todo o caminho relevante de processamento.

Um cenário pode abranger:

**origem → ingestão → Kafka → Bronze → Silver → Gold → certificação → consumo *downstream*.**

Dependendo do objetivo, a validação *end-to-end* pode avaliar:

- chegada dos dados;
- preservação dos contratos;
- transformações;
- progresso do processamento;
- dados resultantes;
- certificação;
- atualidade;
- disponibilidade *downstream*;
- observabilidade;
- comportamento de falha e recuperação.

O sucesso *end-to-end* não deve ser reduzido à conclusão bem-sucedida do último *job* de processamento.

Os estados arquiteturais intermediários e resultantes relevantes também devem satisfazer as expectativas do cenário.

### 4.16 Testes de Regressão

Os testes de regressão validam se comportamentos anteriormente demonstrados permanecem corretos após alterações relevantes.

A regressão pode ser necessária após alterações em:

- lógica de processamento;
- *schemas* ou contratos;
- configuração;
- dependências;
- comportamento de *checkpoints*;
- lógica de recuperação;
- regras de qualidade;
- certificação;
- controles de segurança;
- observabilidade;
- infraestrutura;
- orquestração.

O escopo da regressão deve, preferencialmente, ser proporcional ao impacto potencial da alteração.

Evidências anteriormente bem-sucedidas não comprovam que o comportamento permanece correto após alterações na implementação.

### 4.17 Testes Negativos e de Limite

Os testes devem, preferencialmente, incluir condições relevantes fora do caminho esperado de sucesso.

Exemplos podem incluir:

- valores inválidos;
- campos obrigatórios ausentes;
- dados duplicados;
- entrada vazia;
- ordenação inesperada;
- entrega repetida;
- processamento atrasado;
- dependência indisponível;
- *timestamps* de limite;
- escopos de processamento sem dados qualificados;
- valores máximos ou mínimos relevantes para as regras implementadas.

O objetivo não é inventar casos arbitrários de falha.

Os cenários negativos e de limite devem, preferencialmente, ser derivados de suposições arquiteturais, contratos, controles e modos de falha significativos.

### 4.18 Cobertura de Testes

A cobertura deve ser avaliada em relação às responsabilidades arquiteturais, e não apenas pela quantidade de testes.

Uma grande quantidade de testes não demonstra cobertura adequada se comportamentos arquiteturais importantes permanecerem sem validação.

A cobertura relevante deve, preferencialmente, considerar se a plataforma implementada possui evidências para áreas como:

- processamento normal;
- limites de integração;
- contratos;
- transformações;
- qualidade de dados;
- certificação;
- estado durável;
- repetibilidade;
- falhas;
- recuperação;
- convergência de *backlog*;
- observabilidade;
- controles de segurança e governança;
- comportamento de performance;
- resultados *end-to-end*.

Nem toda responsabilidade arquitetural exige a mesma quantidade ou o mesmo tipo de testes.

A cobertura deve permanecer proporcional à importância, ao risco, à complexidade e ao escopo implementado do comportamento que está sendo validado.

### 4.19 Rastreabilidade da Cobertura

Quando viável, responsabilidades arquiteturais relevantes devem, preferencialmente, ser rastreáveis até um ou mais cenários de validação.

Isso permite que o projeto identifique:

- comportamentos arquiteturais com evidências de validação existentes;
- comportamentos implementados, mas ainda não validados;
- comportamentos que exigem cenários adicionais;
- testes que não correspondem mais à arquitetura atual;
- cobertura afetada por alterações arquiteturais ou de implementação.

A rastreabilidade da cobertura deve, preferencialmente, dar suporte à relação:

**arquitetura → requisito → cenário de validação → evidência → resultado.**

O objetivo não é maximizar um percentual numérico de cobertura.

O objetivo é tornar visíveis lacunas significativas de validação.

---

## 5. Projeto de Cenários de Teste

Um cenário de validação deve traduzir uma expectativa arquitetural em um teste controlado, compreensível e repetível.

O cenário deve definir contexto suficiente para determinar o que está sendo testado, sob quais condições, quais ações serão realizadas, qual comportamento é esperado e como o estado resultante será avaliado.

O projeto do cenário deve, preferencialmente, permanecer proporcional à complexidade e ao risco do comportamento que está sendo validado.

Uma transformação determinística simples não exige o mesmo nível de preparação que um cenário de falha e recuperação envolvendo múltiplas etapas.

### 5.1 Objetivo do Cenário

Todo cenário de validação relevante deve ter um objetivo explícito.

O objetivo deve, preferencialmente, descrever o comportamento que está sendo validado, em vez de apenas a ação que está sendo realizada.

Por exemplo:

**Objetivo fraco:**

"Parar o consumidor Kafka."

**Objetivo de validação:**

"Validar que a interrupção do consumidor causa acúmulo observável de *lag* e que o processamento é retomado a partir da posição esperada após a restauração do consumidor."

A ação faz parte do cenário.

O comportamento arquitetural é o propósito do cenário.

### 5.2 Referência à Arquitetura e ao Requisito

Quando viável, o cenário deve, preferencialmente, identificar a responsabilidade arquitetural ou o requisito que motiva o teste.

Essa referência pode apontar para:

- um documento de arquitetura;
- uma seção arquitetural;
- uma garantia de processamento;
- uma garantia de recuperação;
- um contrato de dados;
- uma regra de qualidade de dados;
- um requisito de certificação;
- um controle de segurança;
- um requisito de observabilidade;
- outra responsabilidade documentada da plataforma.

O objetivo é preservar a rastreabilidade entre o que a plataforma afirma e o que o teste pretende validar.

### 5.3 Pré-condições

Um cenário deve identificar as condições que devem existir antes da execução quando essas condições afetarem a interpretação do resultado.

As pré-condições podem incluir:

- os componentes necessários estão disponíveis;
- os dados necessários na origem existem;
- o processamento está em um *checkpoint* conhecido;
- o *backlog* está ausente ou dentro de um intervalo conhecido;
- uma configuração específica está ativa;
- o processamento anterior foi concluído;
- a certificação está em um estado conhecido;
- as credenciais ou permissões necessárias existem;
- os mecanismos de observabilidade relevantes estão ativos.

As pré-condições devem distinguir suposições de condições que foram efetivamente verificadas.

Um teste cujo estado inicial seja desconhecido pode produzir evidências que não possam ser interpretadas de forma confiável.

### 5.4 Estado Inicial

Quando o estado resultante for comparado com o estado anterior à execução, o estado inicial relevante deve ser capturado ou determinável.

Isso pode incluir:

- estado do registro na origem;
- estado do registro no destino;
- contagens de linhas;
- posição do *checkpoint*;
- *offsets* do Kafka;
- *lag* do consumidor;
- estado de certificação;
- *backlog*;
- status do processamento;
- disponibilidade *downstream*;
- estado relevante de controle de acesso.

O estado inicial não exige a captura de todas as medições da plataforma.

Somente as informações necessárias para avaliar o cenário devem ser preservadas.

### 5.5 Dados de Teste

Os dados de teste devem ser apropriados ao comportamento que está sendo validado.

Quando viável, os dados de teste devem, preferencialmente, ser:

- controlados;
- identificáveis;
- reproduzíveis;
- limitados ao escopo necessário;
- distinguíveis de dados não relacionados;
- seguros para o ambiente;
- consistentes com os requisitos aplicáveis de segurança e governança.

O cenário deve, preferencialmente, identificar como os dados de teste foram criados, selecionados ou referenciados quando essas informações forem necessárias para repetição ou interpretação.

### 5.6 Escopo de Processamento

O cenário deve definir o escopo de processamento quando o comportamento testado depender de um conjunto delimitado de trabalho.

Dependendo da arquitetura, o escopo pode ser representado por:

- identificadores da origem;
- identificadores de eventos;
- lote;
- execução;
- partição e intervalo de *offsets* do Kafka;
- janela de tempo;
- conjunto de dados;
- tabela;
- partição de processamento;
- escopo de processamento dimensional;
- período histórico;
- outro limite determinístico.

O escopo deve ser preciso o suficiente para determinar se o trabalho pretendido foi processado, repetido, omitido, rejeitado, recuperado ou afetado involuntariamente.

### 5.7 Ação Controlada

O cenário deve descrever a ação que inicia ou exercita o comportamento que está sendo validado.

Exemplos podem incluir:

- criar ou alterar dados na origem;
- iniciar uma execução de processamento;
- publicar um evento;
- repetir uma execução;
- parar um consumidor;
- interromper um componente;
- restaurar uma dependência;
- introduzir dados inválidos;
- iniciar um *replay*;
- iniciar um reprocessamento;
- executar um *backfill*;
- iniciar um *rebuild*;
- alterar uma condição de acesso.

As ações devem, preferencialmente, ser definidas em um nível que permita que o cenário seja repetido sem acoplar desnecessariamente o teste arquitetural a detalhes incidentais de implementação.

### 5.8 Injeção de Falhas

Quando um cenário introduzir intencionalmente uma falha, a condição injetada deve ser definida explicitamente.

O cenário deve, preferencialmente, identificar, quando aplicável:

- a falha que está sendo introduzida;
- o componente ou limite afetado;
- o ponto em que a falha é introduzida;
- a duração pretendida;
- o efeito imediato esperado;
- o comportamento esperado de isolamento;
- o comportamento esperado de nova tentativa ou recuperação;
- o procedimento de restauração.

A injeção de falhas deve ser controlada o suficiente para que as evidências resultantes possam ser razoavelmente atribuídas à condição pretendida.

Instabilidades ambientais não relacionadas não devem ser silenciosamente tratadas como parte do teste planejado.

### 5.9 Tempo e Ordenação

Quando o tempo ou a ordenação afetarem o comportamento esperado, o cenário deve definir a sequência relevante.

Isso pode incluir:

- quando os dados de origem são criados;
- quando o processamento começa;
- quando a falha é introduzida;
- por quanto tempo a falha permanece ativa;
- quando ocorre a restauração;
- quando as medições são coletadas;
- quando se espera que a recuperação comece;
- quando o estado resultante é avaliado.

Horários exatos não são necessários, a menos que sejam relevantes para o comportamento que está sendo validado.

O propósito é preservar a sequência causal e relações temporais significativas.

### 5.10 Comportamento Esperado

O comportamento esperado deve descrever o que a plataforma deve fazer durante e após o cenário.

Dependendo do teste, isso pode incluir:

- progressão do processamento;
- transformação esperada;
- rejeição;
- isolamento de falhas;
- nova tentativa;
- comportamento do *checkpoint*;
- acúmulo de *backlog*;
- início da recuperação;
- progressão da recuperação;
- comportamento de certificação;
- disponibilidade *downstream*;
- negação ou aprovação de acesso;
- comportamento operacional observável.

O comportamento esperado deve ser derivado da responsabilidade arquitetural que está sendo testada.

Ele não deve ser reescrito após a execução apenas para corresponder ao resultado observado.

### 5.11 Estado Resultante Esperado

Quando aplicável, o cenário deve, preferencialmente, definir explicitamente o estado esperado após a execução.

Isso pode incluir:

- dados persistidos esperados;
- estado esperado das linhas;
- *checkpoint* esperado;
- posição esperada do *offset*;
- estado esperado de rejeição;
- estado esperado de certificação;
- estado esperado de recuperação;
- condição esperada do *backlog*;
- estado *downstream* esperado.

Definir o estado resultante separadamente do comportamento de execução ajuda a distinguir:

**"as ações esperadas ocorreram"**

de:

**"a plataforma atingiu o estado final esperado."**

Ambos podem ser necessários para uma validação bem-sucedida.

### 5.12 Evidências Esperadas

O cenário deve, preferencialmente, identificar as evidências esperadas para sustentar a validação.

Evidências relevantes podem incluir:

- dados resultantes;
- estado de processamento;
- *checkpoints*;
- *offsets* do Kafka;
- *logs*;
- eventos operacionais estruturados;
- métricas;
- medições de *lag* ou *backlog*;
- registros de recuperação;
- registros de dados rejeitados;
- resultados de certificação;
- validação *downstream*;
- resultados de controle de acesso;
- capturas de tela ou artefatos visuais, quando úteis.

As evidências esperadas devem, preferencialmente, ser definidas antes da execução, quando viável.

Isso reduz a seleção retrospectiva apenas das evidências que parecem sustentar a conclusão desejada.

### 5.13 Critérios de Aceitação

O cenário deve definir as condições que determinam se o comportamento é aprovado na validação.

Os critérios de aceitação devem, preferencialmente, ser:

- explícitos;
- observáveis ou verificáveis;
- relevantes para a expectativa arquitetural;
- suficientemente precisos para sustentar uma conclusão defensável.

Por exemplo, um cenário de *replay* pode exigir que:

1. o escopo histórico pretendido seja selecionado;
2. todos os registros necessários dentro desse escopo sejam processados;
3. nenhum registro fora do escopo pretendido seja afetado involuntariamente;
4. os dados resultantes satisfaçam as regras de transformação esperadas;
5. efeitos de duplicidade não sejam introduzidos além da semântica de processamento definida;
6. a atividade de recuperação seja observável;
7. a validação *downstream* seja bem-sucedida, quando aplicável.

Os critérios exatos dependem do comportamento que está sendo testado.

### 5.14 Restauração e Limpeza

Cenários que modificam o estado da plataforma, introduzem falhas, criam dados temporários ou alteram configurações devem definir restauração ou limpeza quando necessário.

A restauração pode incluir:

- reiniciar um componente interrompido;
- restaurar a configuração;
- remover dados temporários de teste;
- retornar permissões ao estado original;
- remover condições temporárias de falha;
- restaurar a capacidade esperada de processamento;
- validar que o processamento normal foi retomado.

A limpeza não deve remover evidências necessárias para compreender o teste concluído.

O retorno do ambiente de teste ao estado normal não justifica a exclusão do histórico relevante de validação.

### 5.15 Isolamento de Atividades Não Relacionadas

Quando viável, o projeto do teste deve, preferencialmente, tornar o cenário distinguível de atividades não relacionadas da plataforma.

O isolamento pode ser obtido por meio de:

- dados de teste identificáveis;
- escopo de processamento delimitado;
- identificadores de execução;
- temporização controlada;
- janelas dedicadas de teste;
- metadados de correlação;
- estado inicial conhecido.

O isolamento completo do ambiente nem sempre é necessário.

O requisito é que atividades não relacionadas não tornem o resultado do teste materialmente ambíguo.

### 5.16 Dependências do Cenário

Um cenário pode depender de capacidades previamente validadas.

Por exemplo, um cenário de recuperação *end-to-end* pode depender de:

- ingestão normal funcionando;
- persistência de *checkpoints* funcionando;
- contratos de dados relevantes sendo válidos;
- observabilidade estando disponível.

As dependências devem ser compreendidas para que um cenário que falhou possa ser diagnosticado corretamente.

Uma falha de validação *downstream* causada por um pré-requisito indisponível não deve ser automaticamente interpretada como falha do próprio comportamento *downstream*.

### 5.17 Variantes do Cenário

Um único comportamento arquitetural pode exigir múltiplas variantes de cenário.

As variantes podem abranger:

- caminho bem-sucedido;
- entrada inválida;
- execução repetida;
- falha parcial;
- falha transitória;
- falha persistente;
- recuperação;
- condição de limite;
- diferentes escopos de processamento.

As variantes devem, preferencialmente, ser criadas quando validarem comportamentos significativamente diferentes.

Elas não devem ser multiplicadas apenas para aumentar a quantidade de testes registrados.

### 5.18 Identificação do Cenário

Cenários de validação relevantes devem, preferencialmente, possuir identificadores estáveis ou outro método determinístico de identificação.

A identificação do cenário dá suporte a:

- execução repetida;
- organização das evidências;
- rastreabilidade;
- testes de regressão;
- comparação entre execuções;
- histórico de falhas e novos testes;
- referências na documentação.

O identificador deve, preferencialmente, representar a definição do cenário, e não uma única execução desse cenário.

Execuções individuais podem possuir seus próprios identificadores de execução.

### 5.19 Versionamento do Cenário

Quando um cenário mudar materialmente, o projeto deve, preferencialmente, preservar informações suficientes para determinar qual definição de cenário produziu as evidências históricas.

Alterações materiais podem incluir:

- expectativa arquitetural alterada;
- escopo de processamento alterado;
- critérios de aceitação alterados;
- condição de falha alterada;
- método de validação alterado;
- evidências obrigatórias alteradas.

Alterações editoriais menores não exigem necessariamente uma nova versão do cenário.

Resultados históricos PASS não devem ser considerados como validação de critérios materialmente alterados que não foram avaliados quando esses resultados foram produzidos.

### 5.20 Revisabilidade do Cenário

A definição de um cenário deve, preferencialmente, conter informações suficientes para que outro engenheiro compreenda:

- o que está sendo testado;
- por que o teste existe;
- o que deve ser verdadeiro antes da execução;
- quais dados ou escopo de processamento estão envolvidos;
- quais ações são realizadas;
- qual comportamento é esperado;
- quais evidências devem ser coletadas;
- como PASS ou FAIL é determinado;
- como o ambiente é restaurado, quando necessário.

O cenário não precisa documentar todos os comandos ou detalhes de implementação quando esses detalhes forem mantidos em artefatos executáveis de teste.

O cenário arquitetural define a intenção e a semântica da validação.

Os artefatos executáveis implementam o procedimento.

---

## 6. Resultados Esperados e Critérios de Aceitação

Os resultados esperados e os critérios de aceitação definem como o comportamento observado durante o teste é avaliado em relação à expectativa arquitetural.

Um cenário de validação não deve depender de interpretação subjetiva após a execução para determinar se a plataforma se comportou corretamente.

Quando viável, o resultado esperado e as condições necessárias para uma validação bem-sucedida devem, portanto, ser estabelecidos antes que o cenário seja executado.

O nível de precisão necessário depende do comportamento que está sendo testado.

Uma transformação determinística de dados pode permitir valores esperados exatos, enquanto um cenário de performance ou recuperação pode exigir intervalos, tendências, transições de estado ou outras condições mensuráveis.

### 6.1 Comportamento Esperado

O comportamento esperado descreve o que se espera que a plataforma faça durante o cenário de validação.

Dependendo do cenário, isso pode incluir:

- progressão do processamento;
- comportamento da transformação;
- aplicação de contratos;
- aceitação ou rejeição de registros;
- progressão de *checkpoints*;
- comportamento de novas tentativas;
- isolamento de falhas;
- acúmulo de *backlog*;
- início da recuperação;
- progressão da recuperação;
- comportamento da certificação;
- disponibilidade *downstream*;
- comportamento de observabilidade;
- aplicação de controles de segurança.

O comportamento esperado deve ser derivado da responsabilidade arquitetural que está sendo validada.

Ele deve permanecer distinguível do que foi efetivamente observado durante a execução.

### 6.2 Estado Resultante Esperado

O estado resultante esperado define qual estado relevante da plataforma deve existir após o cenário atingir seu ponto de avaliação.

Dependendo do teste, isso pode incluir:

- dados persistidos esperados;
- contagens ou valores esperados das linhas;
- status esperado do processamento;
- posição esperada do *checkpoint*;
- estado esperado dos *offsets* do Kafka;
- estado esperado dos dados rejeitados;
- estado esperado de certificação;
- condição esperada do *backlog*;
- estado esperado de recuperação;
- disponibilidade *downstream* esperada;
- estado esperado do controle de acesso.

O estado resultante deve ser avaliado utilizando evidências autoritativas quando existir estado autoritativo.

Uma mensagem de execução bem-sucedida não deve substituir a verificação do estado esperado.

### 6.3 Resultados Determinísticos

Quando a arquitetura definir comportamento determinístico, os critérios de aceitação devem, preferencialmente, validar o resultado exato esperado quando viável.

Exemplos podem incluir:

- valores transformados esperados;
- quantidade esperada de registros;
- rejeição esperada;
- resultado esperado da certificação;
- posição esperada do *checkpoint*;
- escopo de processamento esperado;
- negação de acesso esperada.

A validação determinística deve evitar critérios desnecessariamente amplos que permitam que resultados materialmente incorretos sejam aprovados.

### 6.4 Medições Não Determinísticas

Alguns resultados de validação não podem razoavelmente exigir um resultado numérico idêntico em todas as execuções.

Exemplos podem incluir:

- duração do processamento;
- *throughput*;
- utilização de recursos;
- *lag* do consumidor;
- duração da recuperação de *backlog*;
- medições de infraestrutura.

Esses resultados ainda devem ser avaliados em relação a critérios explícitos.

Os critérios podem utilizar:

- intervalos aceitáveis;
- valores máximos ou mínimos;
- tendências;
- percentis;
- comparação relativa;
- comportamento de convergência;
- linhas de base estabelecidas;
- outras semânticas de medição definidas.

A variação não elimina a necessidade de uma expectativa testável.

### 6.5 Critérios de Transição de Estado

Alguns comportamentos arquiteturais são melhor validados por meio de transições de estado esperadas, em vez de um único valor final.

Por exemplo, um cenário de recuperação pode exigir a sequência:

**RUNNING → FAILED → RECOVERING → SUCCEEDED**

ou outra progressão de estados definida pela arquitetura implementada.

A validação deve determinar se:

- as transições obrigatórias ocorreram;
- transições inválidas não ocorreram;
- o estado resultante está correto;
- as transições são sustentadas por evidências relevantes.

O modelo exato de estados permanece responsabilidade da arquitetura que define o comportamento.

Os testes validam se a implementação segue esse modelo.

### 6.6 Critérios de Correção dos Dados

Quando um cenário afetar dados, os critérios de aceitação devem avaliar o resultado relevante dos dados.

Dependendo do cenário, os critérios podem verificar se:

- os registros esperados existem;
- os valores esperados estão corretos;
- registros obrigatórios não foram omitidos;
- registros não intencionais não foram introduzidos;
- duplicidades não foram criadas além da semântica definida;
- as transformações foram aplicadas corretamente;
- os registros rejeitados foram tratados conforme esperado;
- os relacionamentos dimensionais permanecem corretos;
- os dados certificados atendem às condições exigidas.

Contagens de linhas, por si só, são insuficientes quando a correção de valores individuais ou relacionamentos é relevante.

### 6.7 Critérios de Escopo de Processamento

Os critérios de aceitação devem verificar se o escopo de processamento pretendido foi respeitado quando o escopo for arquiteturalmente relevante.

A validação pode precisar demonstrar que:

- todo o trabalho pretendido foi incluído;
- trabalho fora do escopo pretendido não foi afetado involuntariamente;
- trabalho repetido seguiu a semântica definida;
- a recuperação processou o intervalo necessário;
- o *replay* selecionou o intervalo histórico pretendido;
- o *backfill* cobriu o período ausente pretendido;
- o *rebuild* afetou o conjunto de dados ou o limite de processamento pretendido.

A conclusão bem-sucedida de um mecanismo não comprova que ele processou o escopo correto.

### 6.8 Critérios de Falha

Um cenário de falha pode ser considerado PASS porque a plataforma falhou da maneira controlada esperada.

Os critérios de aceitação podem exigir que:

- a falha pretendida tenha sido detectada;
- o estado de falha tenha sido registrado;
- o escopo afetado tenha sido identificável;
- processamentos não relacionados tenham permanecido isolados quando exigido;
- uma nova tentativa tenha ocorrido ou não de acordo com a política;
- nenhum estado inválido de sucesso tenha sido produzido;
- evidências operacionais relevantes tenham sido geradas;
- o comportamento de recuperação necessário tenha se tornado possível.

A presença de um erro não significa automaticamente que um teste de falha falhou.

O teste avalia se a plataforma tratou o erro de acordo com a arquitetura.

### 6.9 Critérios de Recuperação

Os critérios de aceitação da recuperação devem avaliar a restauração do estado esperado, e não apenas a reinicialização ou a conclusão do mecanismo de recuperação.

Dependendo do cenário, a validação pode exigir que:

- a recuperação comece a partir da posição correta;
- o trabalho pretendido seja recuperado;
- nenhum trabalho necessário seja omitido;
- nenhum efeito de duplicidade não intencional seja introduzido;
- os *checkpoints* progridam corretamente;
- o *backlog* diminua;
- o *catch-up* convirja;
- o processamento *downstream* seja retomado;
- a certificação seja bem-sucedida, quando aplicável;
- a atualidade esperada seja restaurada;
- evidências de recuperação estejam disponíveis.

Um cenário de recuperação não deve ser considerado PASS apenas porque o comando ou *job* de recuperação foi concluído com sucesso.

### 6.10 Critérios de Qualidade de Dados e Certificação

Os cenários de qualidade de dados devem distinguir o comportamento correto de rejeição da falha do próprio mecanismo de qualidade.

Os critérios de aceitação podem verificar se:

- registros válidos são aceitos;
- registros inválidos são rejeitados;
- os motivos da rejeição são identificáveis;
- os dados rejeitados são tratados de acordo com a arquitetura definida;
- os limites de qualidade são avaliados corretamente;
- a certificação ocorre com sucesso somente quando as condições exigidas são satisfeitas;
- a falha na certificação impede que os dados sejam apresentados como certificados.

Uma rejeição esperada pode, portanto, contribuir para um resultado PASS.

### 6.11 Critérios de Observabilidade

Quando a observabilidade fizer parte do comportamento que está sendo testado, os critérios de aceitação devem identificar as evidências operacionais esperadas para o cenário.

Os critérios podem exigir visibilidade de:

- ciclo de vida da execução;
- progresso do processamento;
- falha;
- nova tentativa;
- rejeição;
- progressão de *checkpoints*;
- *lag* ou *backlog*;
- atividade de recuperação;
- estado de certificação;
- atualidade;
- geração de alertas;
- resolução de alertas.

Os critérios de observabilidade devem ser avaliados em relação ao comportamento subjacente da plataforma.

Uma métrica, *log*, alerta ou estado de *dashboard* que contradiga o estado autoritativo representa uma preocupação de validação, mesmo quando o próprio mecanismo de telemetria tiver sido executado com sucesso.

### 6.12 Critérios de Segurança e Governança

Quando controles de segurança ou governança estiverem sendo validados, os critérios de aceitação devem refletir o comportamento pretendido do controle.

Exemplos podem incluir:

- acesso autorizado é bem-sucedido;
- acesso não autorizado é negado;
- restrições de menor privilégio são aplicadas;
- segredos não são expostos;
- informações sensíveis não são gravadas desnecessariamente em *logs*;
- acessos relevantes são auditáveis;
- comportamentos de retenção ou exclusão operam conforme definido.

Um teste de segurança não deve ser considerado bem-sucedido apenas porque a ação tentada foi concluída.

O resultado esperado de autorização ou negação determina a validação.

### 6.13 Critérios Obrigatórios e de Suporte

Um cenário pode conter critérios obrigatórios e critérios de suporte.

**Critérios obrigatórios** determinam se o comportamento arquitetural pode ser considerado validado com sucesso.

**Critérios de suporte** fornecem evidências adicionais de diagnóstico, operação ou contexto, mas não determinam, por si só, PASS ou FAIL.

Essa distinção deve ser explícita quando utilizada.

Um cenário não pode ser considerado PASS quando um critério obrigatório falhar apenas porque as evidências de suporte parecem favoráveis.

### 6.14 PASS

Um cenário pode ser classificado como **PASS** quando todos os critérios obrigatórios de aceitação forem satisfeitos por evidências suficientes.

PASS significa que o comportamento testado foi demonstrado sob as condições e dentro do escopo daquela execução.

PASS não significa:

- que o componente nunca poderá falhar;
- que o comportamento foi comprovado sob toda carga de trabalho possível;
- que todos os modos de falha possíveis foram testados;
- que garantias em escala corporativa foram demonstradas;
- que responsabilidades arquiteturais não relacionadas foram validadas.

A conclusão deve permanecer proporcional ao cenário efetivamente executado.

### 6.15 FAIL

Um cenário deve ser classificado como **FAIL** quando um ou mais critérios obrigatórios de aceitação não forem satisfeitos.

FAIL pode indicar:

- defeito de implementação;
- lacuna arquitetural;
- problema de configuração;
- problema ambiental;
- requisito incorreto;
- expectativa de teste incorreta;
- projeto de teste insuficiente ou incorreto.

O resultado identifica que o cenário não satisfez seus critérios de aceitação atuais.

O diagnóstico determina o motivo.

### 6.16 Resultado Inconclusivo

Um cenário pode ser classificado como **INCONCLUSIVE** quando as evidências disponíveis forem insuficientes para determinar se os critérios obrigatórios de aceitação foram satisfeitos.

Exemplos podem incluir:

- ausência de evidências obrigatórias;
- instabilidade ambiental não relacionada;
- execução incompleta;
- dados de teste corrompidos;
- impossibilidade de verificar o estado autoritativo;
- ambiguidade sobre o escopo de processamento.

INCONCLUSIVE não deve ser apresentado como PASS.

O cenário deve, preferencialmente, ser corrigido, repetido ou investigado até que uma conclusão defensável de validação possa ser alcançada, quando viável.

### 6.17 Estados Bloqueado e Não Executado

Quando útil para o gerenciamento de testes, os cenários podem adicionalmente ser representados como:

- **BLOCKED** — a execução não pode prosseguir porque uma dependência ou pré-condição necessária está indisponível;
- **NOT EXECUTED** — o cenário ainda não foi executado.

Esses estados descrevem o status da execução, e não o sucesso da validação.

Nenhum desses estados representa evidência de que o comportamento arquitetural funciona.

### 6.18 Sucesso Parcial

Um cenário com múltiplos critérios obrigatórios não deve ser classificado como PASS apenas porque a maioria dos critérios foi satisfeita.

O sucesso parcial pode ser registrado como informação de diagnóstico, mas o cenário permanece FAIL quando qualquer critério obrigatório não for satisfeito.

Quando comportamentos independentes exigirem conclusões independentes, eles devem, preferencialmente, ser representados por critérios separados ou cenários separados, conforme apropriado.

Isso impede que resultados agregados ocultem falhas arquiteturais relevantes.

### 6.19 Tolerâncias

Quando a igualdade exata não for necessária, os critérios de aceitação podem definir tolerâncias.

As tolerâncias devem ter uma justificativa explícita.

Elas podem refletir:

- variação esperada das medições;
- variabilidade temporal;
- processamento assíncrono;
- variabilidade da infraestrutura;
- precisão numérica;
- comportamento conhecido da carga de trabalho.

Uma tolerância não deve ser introduzida após a execução apenas para converter um resultado FAIL em PASS.

Se as evidências demonstrarem que uma tolerância existente é inadequada, ela pode ser formalmente revisada para validações futuras, com a justificativa documentada.

### 6.20 Critérios com Limite de Tempo

Alguns critérios de aceitação dependem de um comportamento ocorrer dentro de um período definido.

Exemplos podem incluir:

- uma nova tentativa começa dentro de um intervalo esperado;
- o *backlog* converge dentro de uma janela de recuperação estabelecida;
- os dados tornam-se disponíveis dentro de uma expectativa de atualidade;
- o alerta ocorre após uma condição sustentada;
- a recuperação atende a uma expectativa de RTO aplicável.

Critérios com limite de tempo devem definir o que está sendo medido e os pontos relevantes de início e término.

Quando a arquitetura não estabelecer um objetivo formal de tempo, as medições de laboratório devem ser apresentadas como performance observada, e não como garantias inventadas.

### 6.21 Suficiência das Evidências

Os critérios de aceitação devem ser sustentados por evidências suficientes para justificar a conclusão.

A suficiência das evidências depende do comportamento que está sendo validado.

Por exemplo:

- um teste de transformação pode exigir os dados de entrada e os dados resultantes;
- um teste de *checkpoint* pode exigir os estados duráveis inicial e final;
- um teste de recuperação pode exigir estado do *checkpoint*, dados resultantes, eventos de recuperação e validação *downstream*;
- um teste de observabilidade pode exigir a comparação entre o comportamento autoritativo e a telemetria produzida.

Mais evidências não significam automaticamente evidências melhores.

As evidências necessárias são aquelas suficientes para sustentar a afirmação que está sendo feita.

### 6.22 Revisão dos Critérios de Aceitação

Os critérios de aceitação devem, preferencialmente, ser revisados quando a arquitetura subjacente, o requisito, a semântica da implementação ou o método de validação mudar materialmente.

Os resultados históricos devem permanecer associados aos critérios sob os quais foram avaliados.

Um PASS anterior não deve ser silenciosamente tratado como evidência para novos critérios introduzidos após a execução.

Quando critérios alterados representarem comportamento materialmente diferente, uma validação adicional será necessária.

---

## 7. Coleta e Correlação de Evidências

As evidências de validação devem ser coletadas e correlacionadas de maneira que sustentem uma conclusão defensável sobre o comportamento arquitetural que está sendo testado.

A coleta de evidências não se limita à telemetria de observabilidade.

Dependendo do cenário, a validação pode exigir a combinação de estado autoritativo, dados resultantes, registros de execução, *checkpoints*, estado do Kafka, resultados de certificação, resultados de controles de segurança, *logs*, métricas, eventos operacionais e outros artefatos relevantes.

O conjunto de evidências deve permanecer proporcional à afirmação que está sendo validada.

O objetivo não é coletar tudo o que a plataforma pode expor.

O objetivo é preservar informações confiáveis e correlacionadas suficientes para determinar o que ocorreu, qual estado resultou e se o cenário satisfez seus critérios de aceitação.

### 7.1 Fontes de Evidências

As evidências de validação podem se originar de múltiplas fontes arquiteturais e operacionais.

Fontes relevantes podem incluir:

- dados de origem;
- dados resultantes da Bronze, Silver, Gold ou dados certificados;
- estado autoritativo de processamento;
- *checkpoints* duráveis;
- tópicos, partições, *offsets* e estado dos grupos de consumidores do Kafka;
- registros de execução;
- registros de dados rejeitados;
- resultados de certificação;
- metadados de recuperação;
- estado *downstream*;
- *logs*;
- eventos operacionais estruturados;
- métricas;
- alertas;
- *dashboards*;
- resultados de controles de acesso;
- registros de auditoria;
- medições de infraestrutura;
- artefatos de execução dos testes.

Nenhuma fonte de evidência é automaticamente autoritativa para todos os comportamentos arquiteturais.

O papel de cada fonte depende do que está sendo validado.

### 7.2 Evidências Autoritativas

Quando existir estado autoritativo para o comportamento que está sendo testado, ele deve ser incluído na validação quando necessário para sustentar a conclusão.

Exemplos podem incluir:

- dados persistidos para correção dos dados;
- estado durável do *checkpoint* para a posição de reinicialização;
- estado de certificação para a disponibilidade dos dados certificados;
- estado de processamento para o resultado da execução;
- resultado do controle de acesso para o comportamento de autorização;
- dados resultantes *downstream* para validação de disponibilidade.

A telemetria de observabilidade pode explicar ou contextualizar o estado autoritativo.

Ela não deve substituir a validação direta desse estado quando a validação direta for necessária.

### 7.3 Evidências de Suporte

As evidências de suporte fornecem contexto adicional para compreender como o estado resultante foi alcançado.

Exemplos podem incluir:

- *logs*;
- métricas;
- eventos operacionais;
- alertas;
- visualizações de *dashboards*;
- medições de recursos;
- informações temporais.

As evidências de suporte podem ser essenciais para o diagnóstico, mesmo quando não forem suficientes, por si só, para determinar PASS ou FAIL.

A distinção entre evidências autoritativas e de suporte deve permanecer clara quando afetar a conclusão da validação.

### 7.4 A Coleta de Evidências Deve Seguir o Cenário

As evidências devem ser coletadas de acordo com o comportamento, as evidências esperadas e os critérios de aceitação definidos pelo cenário de validação.

O cenário deve, preferencialmente, determinar quais evidências são necessárias.

A telemetria disponível não deve determinar o que o cenário afirma validar.

Isso impede que um teste seja declarado bem-sucedido apenas porque alguma evidência conveniente estava disponível após a execução.

### 7.5 Evidências Pré-Execução

Alguns cenários exigem evidências do estado anterior à execução.

As evidências pré-execução podem incluir:

- estado da origem;
- estado do destino;
- contagens de linhas;
- posição do *checkpoint*;
- *offsets* do Kafka;
- *backlog* ou *lag*;
- estado de certificação;
- status do processamento;
- estado *downstream*;
- configuração do controle de acesso.

As evidências pré-execução estabelecem a linha de base necessária para interpretar o estado resultante.

Elas devem ser coletadas apenas quando o estado inicial afetar materialmente a validação.

### 7.6 Evidências da Execução

As evidências coletadas durante a execução podem demonstrar como a plataforma se comportou enquanto o cenário estava ativo.

Evidências relevantes podem incluir:

- início da execução;
- progresso do processamento;
- transições de estado;
- atividade no Kafka;
- progressão de *checkpoints*;
- falhas;
- novas tentativas;
- registros rejeitados;
- alterações de *lag* ou *backlog*;
- início da recuperação;
- progressão da recuperação;
- atividade de certificação;
- alertas;
- comportamento dos recursos.

As evidências da execução são particularmente importantes para cenários cujos critérios de aceitação dependem do comportamento intermediário, e não apenas do estado final.

### 7.7 Evidências Pós-Execução

As evidências pós-execução validam o estado produzido após o cenário atingir seu ponto de avaliação.

Dependendo do teste, isso pode incluir:

- dados resultantes;
- estado final de processamento;
- posição final do *checkpoint*;
- estado final do Kafka;
- estado de rejeição;
- resultado da certificação;
- resultado da recuperação;
- condição do *backlog*;
- disponibilidade *downstream*;
- atualidade;
- resultado do controle de acesso;
- resolução de alertas.

Um teste não deve interromper a coleta de evidências no momento em que um processo de execução informa sua conclusão se os critérios de aceitação exigirem a validação do estado resultante.

### 7.8 Correlação de Evidências

As evidências provenientes de diferentes fontes devem ser suficientemente correlacionadas para demonstrar que pertencem ao cenário e ao escopo de processamento que estão sendo avaliados.

A correlação pode utilizar:

- identificador do cenário;
- identificador da execução;
- escopo de processamento;
- identificador do lote;
- identificador do evento;
- tópico, partição e *offset* do Kafka;
- identificadores da origem;
- *timestamps*;
- identificador de recuperação;
- escopo de certificação;
- outro contexto determinístico.

Nem todos os componentes precisam utilizar o mesmo identificador.

O requisito é que a relação entre as evidências relevantes possa ser reconstruída de forma confiável.

### 7.9 Correlação Temporal

Os *timestamps* utilizados como evidências de validação devem preservar seu significado.

Tempos relevantes podem incluir:

- horário do evento na origem;
- horário de ingestão;
- início do processamento;
- conclusão do processamento;
- horário de persistência;
- horário da falha;
- horário da nova tentativa;
- início da recuperação;
- conclusão da recuperação;
- horário da certificação;
- horário de disponibilidade *downstream*;
- horário da coleta da evidência.

Um *timestamp* genérico não deve ser interpretado como representando um evento diferente do ciclo de vida sem contexto que sustente essa interpretação.

Quando diferenças temporais entre sistemas puderem afetar a interpretação, essas limitações devem ser consideradas na conclusão da validação.

### 7.10 Correlação do Escopo de Processamento

As evidências devem permanecer atribuíveis ao escopo de processamento pretendido.

Isso é especialmente importante para:

- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- novas tentativas;
- isolamento de falhas;
- recuperação de *backlog*;
- processamento concorrente.

As evidências devem, preferencialmente, permitir determinar:

- qual trabalho pertencia ao cenário;
- qual trabalho foi processado;
- qual trabalho foi repetido;
- qual trabalho foi rejeitado;
- qual trabalho permaneceu incompleto;
- se trabalho não relacionado foi afetado.

Evidências que não consigam distinguir o escopo testado de processamentos não relacionados podem ser insuficientes para a validação.

### 7.11 Correlação de Falhas

As evidências de falha devem estar conectadas à execução e ao escopo afetado pela falha.

Quando aplicável, a correlação deve, preferencialmente, identificar:

- horário da falha;
- componente afetado;
- etapa de processamento afetada;
- execução afetada;
- escopo de processamento afetado;
- classificação do erro;
- comportamento de novas tentativas;
- estado resultante;
- atividade de recuperação.

Uma mensagem de falha sem contexto suficiente pode auxiliar no diagnóstico, mas pode ser inadequada como evidência de validação arquitetural.

### 7.12 Correlação da Recuperação

As evidências de recuperação devem preservar a relação entre:

- processamento original;
- condição de falha;
- escopo afetado;
- mecanismo de recuperação;
- execução da recuperação;
- estado resultante.

Essa relação é necessária para determinar se a recuperação tratou a falha e o escopo de processamento pretendidos.

Uma execução posterior bem-sucedida não deve ser automaticamente tratada como evidência de que o escopo que falhou anteriormente foi recuperado corretamente.

### 7.13 Evidências entre Etapas

Cenários *end-to-end* e de múltiplas etapas podem exigir evidências provenientes de múltiplos limites de processamento.

Quando aplicável, as evidências devem, preferencialmente, permitir reconstruir a progressão através de:

**origem → ingestão → Kafka → Bronze → Silver → Gold → certificação → consumo *downstream*.**

As evidências não precisam utilizar um formato físico idêntico em todas as etapas.

Elas devem fornecer relações contextuais suficientes para determinar como o escopo testado progrediu através dos limites relevantes.

### 7.14 Consistência das Evidências

Evidências provenientes de fontes diferentes podem ocasionalmente divergir.

Por exemplo:

- um *log* pode informar conclusão bem-sucedida enquanto o estado autoritativo permanece incompleto;
- um *dashboard* pode aparentar estar saudável enquanto o *backlog* continua crescendo;
- um estado de processamento pode indicar conclusão enquanto a certificação falhou;
- um evento de recuperação pode informar conclusão enquanto os dados *downstream* necessários permanecem indisponíveis.

Essa divergência deve ser investigada.

As evidências não devem ser descartadas seletivamente apenas porque entram em conflito com o resultado esperado.

Quando existir estado autoritativo, ele tem precedência para o comportamento que representa de forma autoritativa.

A própria divergência pode constituir evidência de um defeito de observabilidade, implementação ou validação.

### 7.15 Completude das Evidências

A completude das evidências significa que as evidências coletadas são suficientes para avaliar todos os critérios obrigatórios de aceitação.

Isso não significa que todos os *logs*, métricas, eventos, capturas de tela, resultados de consultas ou medições de infraestrutura disponíveis devam ser preservados.

Um cenário possui evidências incompletas quando um critério obrigatório não pode ser avaliado de forma confiável a partir das informações disponíveis.

Evidências incompletas podem exigir que o resultado seja classificado como **INCONCLUSIVE**, em vez de PASS ou FAIL.

### 7.16 Integridade das Evidências

As evidências de validação devem permanecer suficientemente confiáveis para a conclusão que sustentam.

Quando relevante, o projeto deve, preferencialmente, preservar:

- a relação entre as evidências e a execução;
- o resultado original observado;
- *timestamps* e identificadores necessários para interpretação;
- alterações ou correções realizadas após uma falha;
- distinção entre as evidências originais e as evidências do novo teste.

As evidências não devem ser modificadas de maneira que obscureça o resultado real da execução.

Anotações e explicações podem ser adicionadas, mas o resultado histórico deve permanecer compreensível.

### 7.17 Evidências Visuais

Capturas de tela, registros visuais de *dashboards*, diagramas ou outros artefatos visuais podem apoiar a validação quando melhorarem a compreensão.

As evidências visuais podem ser úteis para demonstrar:

- estado do *dashboard*;
- comportamento de alertas;
- tendências de *lag*;
- recuperação de *backlog*;
- comportamento dos recursos;
- linhas do tempo operacionais.

Os artefatos visuais não devem substituir a validação direta do estado autoritativo quando este for necessário.

Uma captura de tela constitui evidência de suporte, a menos que o próprio estado visual seja o comportamento que está sendo testado.

### 7.18 Coleta Automatizada de Evidências

Quando viável, testes repetíveis podem automatizar a coleta de evidências relevantes.

A automação pode melhorar:

- consistência;
- repetibilidade;
- correlação;
- captura de *timestamps*;
- comparação entre execuções;
- validação de regressão.

A automação não elimina a necessidade de compreender o que as evidências coletadas representam.

A coleta automática de uma métrica ou resultado de consulta não torna essa evidência relevante ou suficiente por si só.

### 7.19 Coleta Manual de Evidências

A coleta manual de evidências pode ser apropriada quando a automação adicionaria complexidade desnecessária ou quando o cenário for exploratório, pouco frequente ou avaliado visualmente.

A coleta manual ainda deve preservar contexto suficiente para determinar:

- o que foi coletado;
- de qual cenário e execução;
- quando foi coletado;
- o que representa;
- qual critério de aceitação sustenta.

As evidências coletadas manualmente não devem depender exclusivamente da memória não documentada da pessoa que executou o teste.

### 7.20 Nomenclatura e Organização das Evidências

Evidências relevantes devem, preferencialmente, utilizar uma organização consistente que permita associá-las a:

- cenário;
- execução;
- resultado;
- escopo de processamento;
- evento de falha ou recuperação, quando aplicável.

A estrutura exata do repositório e a convenção de nomenclatura podem evoluir com a implementação.

O requisito arquitetural é que as evidências permaneçam localizáveis e atribuíveis sem depender de nomes de arquivos ambíguos ou conhecimento pessoal.

### 7.21 Evidências e Novos Testes

As evidências de uma execução que falhou devem permanecer distinguíveis das evidências produzidas por um novo teste posterior.

Um novo teste não deve sobrescrever as evidências originais.

O histórico de validação deve, preferencialmente, preservar relações como:

**Execução 1 — FAIL**

**Diagnóstico**

**Correção**

**Execução 2 — PASS**

Quando múltiplos novos testes forem necessários, cada execução permanece como parte do histórico de evidências.

Isso permite que o projeto demonstre não apenas o comportamento final validado, mas também o processo de engenharia que o produziu.

### 7.22 Evidências e Regressão

As evidências de validações anteriores bem-sucedidas podem estabelecer uma referência para testes de regressão.

Após uma alteração relevante, novas evidências devem demonstrar se o comportamento anteriormente validado permanece correto.

As evidências históricas fornecem contexto para comparação.

Elas não substituem a execução dos cenários de regressão necessários após o comportamento ou suas dependências terem sido materialmente alterados.

### 7.23 Segurança e Governança das Evidências

As evidências coletadas permanecem sujeitas ao modelo de segurança e governança da plataforma.

A coleta de evidências deve evitar preservar desnecessariamente:

- credenciais;
- segredos;
- *tokens*;
- dados pessoais;
- informações comerciais sensíveis;
- *payloads* completos;
- registros rejeitados sem restrições de acesso.

Quando informações sensíveis forem necessárias para um propósito específico de validação, seu tratamento deve permanecer consistente com os controles aplicáveis.

Evidências arquiteturais não estão isentas de governança por terem sido produzidas por um teste.

### 7.24 Qualidade das Evidências

Antes de sustentar uma conclusão de validação, as evidências devem, preferencialmente, ser avaliadas quanto a características como:

- relevância;
- atribuição;
- completude;
- consistência;
- interpretabilidade;
- integridade;
- autoridade apropriada.

Um grande pacote de evidências não compensa evidências que não possam ser relacionadas ao comportamento testado.

A qualidade das evidências é determinada pelo quão bem elas sustentam a afirmação que está sendo avaliada.

### 7.25 As Evidências Sustentam a Conclusão

A conclusão final da validação deve poder ser explicada a partir das evidências coletadas.

Outro engenheiro ao revisar o cenário deve, preferencialmente, ser capaz de acompanhar a relação:

**comportamento esperado → execução → comportamento observado → estado resultante → evidências → critérios de aceitação → resultado.**

Se a conclusão depender de suposições que não estejam representadas pelo cenário ou pelas evidências, a validação estará incompleta.

O objetivo não é apenas preservar artefatos.

O objetivo é preservar uma cadeia defensável de evidências que conecte a expectativa arquitetural ao comportamento validado.

---

## 8. Testes de Falha e Recuperação

Os testes de falha e recuperação validam se a plataforma Atlas Engineering se comporta de acordo com sua arquitetura definida de confiabilidade e recuperação quando falhas controladas representativas são introduzidas.

O modelo de falhas, a semântica de recuperação, o estado durável, os *checkpoints*, as novas tentativas, o *replay*, o reprocessamento, o *backfill*, o *rebuild*, a recuperação de *backlog*, o RPO, o RTO e as garantias relacionadas são definidos por **Confiabilidade e Recuperação**.

Esta estratégia de testes não redefine esses mecanismos.

Ela define como o comportamento implementado de falha e recuperação é exercitado, observado, avaliado e sustentado por evidências.

Um teste de recuperação bem-sucedido deve demonstrar mais do que a restauração da disponibilidade de um componente.

Ele deve determinar se o escopo de processamento pretendido e o estado resultante dos dados foram restaurados corretamente.

### 8.1 Seleção de Cenários de Falha

Os cenários de falha devem, preferencialmente, ser derivados dos modos de falha relevantes para a arquitetura implementada.

Cenários representativos podem incluir:

- indisponibilidade da origem;
- interrupção da ingestão;
- falha do produtor Kafka;
- interrupção do consumidor Kafka;
- falha de componente de processamento;
- indisponibilidade de dependência;
- interrupção do processamento da Bronze;
- falha no processamento da Silver;
- falha no processamento da Gold;
- falha de certificação;
- indisponibilidade *downstream*;
- falha transitória de infraestrutura;
- comportamento de registros inválidos ou venenosos;
- acúmulo de *backlog*;
- falha relacionada a *checkpoints*;
- falha de operação de recuperação.

O laboratório não precisa simular todas as falhas teoricamente possíveis.

A seleção de cenários deve, preferencialmente, priorizar falhas que exercitem de maneira significativa as garantias arquiteturais implementadas pela plataforma.

### 8.2 Injeção Controlada de Falhas

A injeção de falhas deve ser intencional, delimitada e atribuível ao cenário de validação.

Quando aplicável, o cenário deve definir:

- condição de falha;
- componente afetado;
- etapa de processamento afetada;
- escopo de processamento;
- ponto de injeção;
- efeito imediato esperado;
- duração pretendida;
- procedimento de restauração;
- comportamento esperado de recuperação;
- evidências esperadas.

A falha introduzida deve ser distinguível de instabilidades ambientais não relacionadas.

A injeção de falhas não deve criar riscos desnecessários para dados, credenciais, infraestrutura ou evidências preservadas.

### 8.3 Estado Pré-Falha

Quando necessário para a validação, o estado relevante da plataforma deve ser estabelecido antes que a falha seja introduzida.

As evidências pré-falha podem incluir:

- status do processamento;
- posição do *checkpoint*;
- *offsets* do Kafka;
- *lag* do consumidor;
- *backlog*;
- estado da origem;
- dados persistidos;
- estado de certificação;
- disponibilidade *downstream*;
- métricas relevantes.

O estado pré-falha fornece a referência necessária para determinar o que mudou em decorrência da condição injetada e se a recuperação restaurou o comportamento pretendido.

### 8.4 Detecção de Falhas

Os testes de falha devem determinar se a condição introduzida se torna detectável de acordo com a arquitetura implementada.

A validação pode avaliar:

- estado explícito de falha;
- evento de erro;
- evidências em *logs*;
- alteração de métrica;
- interrupção do processamento;
- *lag* do consumidor;
- crescimento do *backlog*;
- degradação da atualidade;
- geração de alerta;
- impacto na certificação.

A detecção da falha deve refletir a condição real.

Um componente permanecer tecnicamente disponível enquanto deixa de realizar progresso útil de processamento não deve ser automaticamente interpretado como saudável.

### 8.5 Isolamento de Falhas

Quando a arquitetura definir comportamento de isolamento, os testes devem determinar se a falha permanece dentro do limite pretendido.

Questões relevantes podem incluir:

- O processamento não relacionado continuou?
- Apenas a partição ou o escopo afetado foi interrompido?
- Um único registro inválido impediu o progresso de registros válidos não relacionados?
- As etapas *downstream* foram corretamente interrompidas quando o estado *upstream* necessário estava incompleto?
- A falha contaminou dados que já estavam certificados?
- Conjuntos de dados não relacionados permaneceram disponíveis?

Os critérios de isolamento de falhas dependem do limite arquitetural que está sendo testado.

Os testes não devem presumir que toda falha deve permitir que todos os demais processamentos continuem.

### 8.6 Estado de Falha e Evidências Duráveis

Os testes de falha devem determinar se a plataforma preserva estado durável e evidências suficientes para permitir diagnóstico e recuperação.

Dependendo do cenário, isso pode incluir:

- estado da execução que falhou;
- último *checkpoint* bem-sucedido;
- escopo de processamento afetado;
- classificação da falha;
- estado das novas tentativas;
- estado de registros rejeitados ou venenosos;
- posição no Kafka;
- estado do *backlog*;
- elegibilidade para recuperação;
- evidências operacionais relevantes.

Uma falha que desaparece do histórico operacional após a reinicialização de um componente fornece evidências insuficientes para uma validação significativa da recuperação.

### 8.7 Testes de Novas Tentativas

Os testes de novas tentativas validam o comportamento para falhas que devem ser submetidas a novas tentativas.

Cenários relevantes devem, preferencialmente, determinar:

- se uma nova tentativa ocorre nas condições pretendidas;
- se uma nova tentativa não ocorre para condições não elegíveis;
- se o número de tentativas é identificável;
- se o atraso entre tentativas segue a política implementada;
- se tentativas repetidas permanecem observáveis;
- se a nova tentativa preserva o escopo de processamento pretendido;
- se uma nova tentativa bem-sucedida produz o estado resultante esperado;
- se o esgotamento das tentativas leva ao estado esperado de falha ou recuperação.

O sucesso de uma nova tentativa deve ser avaliado por meio do estado resultante.

A ausência de uma exceção após uma nova tentativa não demonstra, por si só, comportamento correto.

### 8.8 Testes de Reinicialização

Os testes de reinicialização validam se o processamento pode ser retomado corretamente após a interrupção e posterior reinicialização de um componente ou execução.

A validação pode exigir a determinação de:

- posição de reinicialização;
- utilização de *checkpoints*;
- trabalho repetido;
- trabalho omitido;
- dados resultantes;
- transição do estado de processamento;
- continuidade *downstream*;
- observabilidade da interrupção e da reinicialização.

A reinicialização não deve ser tratada como sinônimo de *replay* ou reprocessamento, a menos que a arquitetura defina explicitamente esse comportamento.

### 8.9 Testes de *Replay*

Os testes de *replay* validam o reconsumo intencional de dados previamente preservados na origem ou no transporte, de acordo com a semântica de *replay* definida pela plataforma.

Um cenário de *replay* deve, preferencialmente, verificar, quando aplicável:

- escopo pretendido do *replay*;
- posição inicial;
- posição final;
- disponibilidade da fonte preservada;
- comportamento do processamento;
- interação com *checkpoints*;
- tratamento de duplicidades;
- dados resultantes;
- efeitos *downstream*;
- identificação do *replay*;
- evidências de observabilidade.

O *replay* não deve afetar involuntariamente dados fora do escopo pretendido.

O consumo bem-sucedido de eventos históricos, por si só, é insuficiente para validar o *replay*.

### 8.10 Testes de Reprocessamento

Os testes de reprocessamento validam a repetição intencional da transformação ou do processamento de um escopo de dados existente.

A validação relevante pode incluir:

- escopo de entrada pretendido;
- lógica de processamento aplicada;
- dados resultantes;
- semântica de idempotência ou substituição;
- comportamento de *checkpoints*;
- impacto na certificação;
- efeitos *downstream*;
- observabilidade.

O reprocessamento deve permanecer distinguível do *replay* quando a arquitetura atribuir semânticas diferentes a esses mecanismos.

### 8.11 Testes de *Backfill*

Os testes de *backfill* validam o processamento controlado de dados históricos que não foram processados anteriormente ou que precisam ser preenchidos para um escopo histórico definido.

Um cenário de *backfill* deve, preferencialmente, verificar:

- escopo histórico;
- disponibilidade da origem;
- limites de processamento;
- interação com o processamento corrente;
- completude dos dados resultantes;
- prevenção de duplicidades ou comportamento definido de substituição;
- certificação;
- disponibilidade *downstream*;
- evidências operacionais.

A conclusão do *backfill* deve ser avaliada em relação ao escopo histórico pretendido, e não apenas ao status de conclusão do processo de *backfill*.

### 8.12 Testes de *Rebuild*

Os testes de *rebuild* validam a reconstrução de um conjunto de dados derivado ou de uma camada de processamento a partir de uma fonte autoritativa *upstream*, de acordo com a arquitetura.

A validação relevante pode incluir:

- fonte do *rebuild*;
- escopo do *rebuild*;
- estado inicial do destino;
- comportamento da reconstrução;
- completude resultante;
- correção resultante;
- semântica de duplicidade ou substituição;
- certificação;
- estado *downstream*;
- evidências do *rebuild*.

Um *rebuild* deve demonstrar que o estado reconstruído é consistente com as entradas autoritativas e com a lógica de transformação definida.

### 8.13 Testes de Criação de *Backlog*

Os testes de *backlog* podem interromper intencionalmente ou reduzir a capacidade de processamento enquanto o trabalho *upstream* continua.

O cenário deve, preferencialmente, estabelecer, quando aplicável:

- *backlog* ou *lag* inicial;
- ponto de interrupção;
- carga de trabalho recebida;
- duração da redução do processamento;
- crescimento esperado do *backlog*;
- impacto sobre a atualidade;
- sinais operacionais relevantes.

O objetivo é produzir um *backlog* controlado cujo comportamento de recuperação possa ser posteriormente avaliado.

### 8.14 Testes de Recuperação de *Backlog* e *Catch-Up*

Após a restauração da capacidade de processamento, os testes devem determinar se o trabalho acumulado converge em direção ao estado esperado.

Evidências relevantes podem incluir:

- tamanho do *backlog*;
- idade do *backlog*;
- *lag* do consumidor;
- *throughput*;
- progressão de *checkpoints*;
- duração do processamento;
- atualidade;
- disponibilidade *downstream*.

A validação deve, preferencialmente, determinar se:

- o processamento foi retomado;
- o *backlog* diminui;
- o sistema apresenta progresso sustentado;
- o trabalho acumulado é concluído;
- o processamento corrente retorna em direção à atualidade esperada.

Um consumidor em execução não demonstra, por si só, recuperação bem-sucedida do *backlog*.

### 8.15 Validação do Escopo de Recuperação

Todo mecanismo de recuperação deve ser avaliado em relação ao escopo que deveria recuperar.

Os testes devem, preferencialmente, determinar:

- qual trabalho exigia recuperação;
- qual trabalho foi efetivamente recuperado;
- se trabalho necessário foi omitido;
- se trabalho fora do escopo pretendido foi afetado;
- se o processamento repetido seguiu a semântica definida.

O escopo de recuperação é particularmente importante para *replay*, reprocessamento, *backfill*, *rebuild* e cenários de falha parcial.

### 8.16 Testes de Recuperação de *Checkpoints*

Quando *checkpoints* duráveis participarem da recuperação, os testes devem validar seu comportamento durante interrupção e restauração.

Cenários relevantes podem determinar:

- último *checkpoint* durável antes da falha;
- posição de reinicialização;
- progressão do *checkpoint* após a recuperação;
- processamento repetido entre o *checkpoint* e a falha;
- correção dos dados resultantes;
- consistência do *checkpoint* com o estado autoritativo de processamento.

A existência de um *checkpoint* não comprova, por si só, que ele representa a posição correta de recuperação.

### 8.17 Validação de Duplicidades e Omissões

Os testes de recuperação devem avaliar explicitamente o comportamento de duplicidades e omissões quando o processamento repetido ou retomado puder afetar a correção dos dados.

A validação pode exigir a determinação de:

- se os registros necessários existem;
- se algum registro necessário está ausente;
- se registros repetidos produziram efeitos de duplicidade não intencionais;
- se a semântica definida de idempotência ou substituição se comportou corretamente;
- se os resultados *downstream* permanecem corretos.

A comparação de contagens pode contribuir para essa validação, mas é insuficiente quando a correção no nível dos registros ou dos relacionamentos for relevante.

### 8.18 Testes de Registros Venenosos

Quando a arquitetura definir o tratamento de registros venenosos ou que falham repetidamente, cenários controlados devem, preferencialmente, validar esse comportamento.

Os testes podem avaliar:

- identificação da falha;
- comportamento de novas tentativas;
- esgotamento das tentativas;
- isolamento;
- preservação das evidências de falha;
- escopo de processamento afetado;
- tratamento de registros não relacionados;
- caminho de recuperação ou correção.

Um registro venenoso não deve desaparecer silenciosamente apenas para permitir que o restante do processamento pareça bem-sucedido.

O comportamento esperado deve seguir a política definida pela arquitetura de confiabilidade.

### 8.19 Testes de Falha na Recuperação

Os próprios mecanismos de recuperação podem falhar.

Quando relevante, os testes devem, preferencialmente, incluir cenários nos quais:

- o *replay* falha;
- o reprocessamento falha;
- o *backfill* é interrompido;
- o *rebuild* falha;
- a recuperação de *backlog* deixa de progredir;
- um componente reinicializado falha novamente.

A validação deve, preferencialmente, determinar se a falha de recuperação:

- torna-se visível;
- preserva o escopo afetado;
- mantém estado suficiente;
- permanece distinguível da falha original;
- permite diagnóstico e recuperação subsequentes.

Uma recuperação que falhou não deve apagar as evidências da falha original.

### 8.20 Recuperação Concorrente e Novo Processamento

Quando a implementação permitir que a recuperação e o trabalho recém-chegado sejam executados simultaneamente, os testes devem, preferencialmente, avaliar sua interação.

Questões relevantes podem incluir:

- O novo processamento continua?
- A recuperação progride?
- O *backlog* aumenta ou diminui?
- A atualidade dos dados correntes é afetada?
- Os escopos de processamento são distinguíveis?
- Uma carga de trabalho impede o progresso da outra?
- A semântica dos dados resultantes é preservada?

Os testes validam o comportamento de agendamento e priorização implementado pela plataforma.

Eles não definem esse comportamento de forma independente.

### 8.21 Validação da Conclusão da Recuperação

A conclusão da recuperação deve ser validada em relação ao estado resultante pretendido.

Dependendo do cenário, os critérios de conclusão podem exigir:

- conclusão do escopo de processamento recuperado;
- alcance do *checkpoint* esperado;
- presença dos dados esperados;
- ausência de omissões não intencionais;
- ausência de efeitos de duplicidade não intencionais;
- retorno do *backlog* à condição esperada;
- retomada do processamento *downstream*;
- sucesso da certificação;
- restauração da atualidade esperada;
- conclusão das evidências de recuperação.

O término de um processo de recuperação não constitui evidência suficiente de recuperação bem-sucedida.

### 8.22 Validação Pós-Recuperação

Após a conclusão da recuperação, os testes devem determinar se o comportamento normal da plataforma foi restaurado.

Questões relevantes podem incluir:

- O processamento está progredindo normalmente?
- Novos registros estão sendo processados?
- O *backlog* está estável ou foi eliminado?
- A atualidade retornou em direção ao estado esperado?
- Os conjuntos de dados *downstream* estão disponíveis?
- A certificação foi retomada?
- Falhas repetidas estão ocorrendo?
- Alertas ou estados de falha foram corretamente resolvidos?

A validação pós-recuperação ajuda a identificar situações nas quais o mecanismo imediato de recuperação é bem-sucedido, mas a plataforma permanece degradada.

### 8.23 Validação de RPO

Quando um Objetivo de Ponto de Recuperação (RPO) aplicável estiver definido, os testes devem, preferencialmente, coletar evidências suficientes para avaliar o ponto de recuperação observado em relação a esse objetivo.

Evidências relevantes podem incluir:

- último estado durável;
- posição do *checkpoint*;
- escopo de processamento afetado;
- dados recuperáveis na origem;
- dados resultantes recuperados;
- qualquer intervalo não recuperável.

A validação em laboratório demonstra o comportamento observado sob o cenário de falha testado.

Ela não deve ampliar a afirmação de RPO além da arquitetura e das condições efetivamente validadas.

### 8.24 Validação de RTO

Quando um Objetivo de Tempo de Recuperação (RTO) aplicável estiver definido, os testes devem, preferencialmente, medir a duração da recuperação utilizando pontos de início e término explicitamente definidos.

A medição pode incluir, dependendo da definição arquitetural:

- ocorrência ou detecção da falha;
- início da recuperação;
- restauração do processamento;
- convergência do *backlog*;
- restauração da certificação;
- disponibilidade *downstream*.

A semântica exata do RTO permanece definida por **Confiabilidade e Recuperação**.

Os testes medem se o comportamento implementado atende ao objetivo aplicável sob as condições testadas.

### 8.25 Validação da Observabilidade da Recuperação

Os cenários de falha e recuperação também devem determinar se as evidências operacionais esperadas foram produzidas.

Evidências relevantes podem incluir:

- detecção da falha;
- estado de falha;
- tentativas realizadas;
- estado do *checkpoint*;
- *lag* do consumidor;
- crescimento do *backlog*;
- início da recuperação;
- progresso da recuperação;
- comportamento do *catch-up*;
- conclusão da recuperação;
- restauração da atualidade;
- ciclo de vida dos alertas.

A funcionalidade da recuperação e a observabilidade da recuperação são aspectos de validação relacionados, porém distintos.

Um mecanismo de recuperação pode funcionar corretamente enquanto sua visibilidade operacional permanece inadequada.

### 8.26 Testes Repetidos de Recuperação

Cenários relevantes de recuperação devem, preferencialmente, ser repetíveis.

Execuções repetidas podem ajudar a demonstrar:

- semântica determinística de recuperação;
- comportamento estável de *checkpoints*;
- tratamento consistente de duplicidades;
- prevenção consistente de omissões;
- evidências comparáveis de recuperação;
- ausência de dependências manuais ocultas.

Testes repetidos de recuperação não precisam produzir tempos ou medições de infraestrutura idênticos.

Eles devem permanecer consistentes com as mesmas expectativas arquiteturais.

### 8.27 Evidências de Falha e Recuperação

O pacote de evidências de um cenário relevante de falha e recuperação deve, preferencialmente, preservar informações suficientes para reconstruir:

**estado pré-falha → falha injetada → comportamento observado da falha → estado resultante de falha → ação de recuperação → progressão da recuperação → estado resultante recuperado → validação pós-recuperação.**

Quando um cenário inicialmente falhar na validação, o histórico deve, adicionalmente, preservar:

**FAIL → diagnóstico → correção → novo teste → estado resultante da validação.**

Essas evidências demonstram não apenas que um componente foi reinicializado, mas que o comportamento implementado de confiabilidade e recuperação foi exercitado e avaliado.

### 8.28 Afirmações de Resiliência em Laboratório

Testes bem-sucedidos de falha e recuperação sustentam afirmações de resiliência somente dentro do escopo dos cenários efetivamente validados.

Uma interrupção controlada de um consumidor Kafka pode demonstrar comportamento correto para essa interrupção sob a carga de trabalho e o ambiente testados.

Ela não demonstra, por si só, resiliência contra:

- falhas arbitrárias de infraestrutura;
- indisponibilidades regionais;
- falhas simultâneas não relacionadas;
- cargas de trabalho em escala corporativa;
- todos os cenários possíveis de corrupção;
- todos os incidentes de segurança possíveis.

O Atlas Engineering deve distinguir entre:

**capacidade de recuperação implementada;**

**comportamento de recuperação validado em laboratório;**

e

**garantias de resiliência corporativa.**

O projeto deve, preferencialmente, afirmar somente aquilo que sua arquitetura, implementação, testes e evidências preservadas sustentam.

---

## 9. Validação de Qualidade de Dados, Certificação e Segurança

Os controles de qualidade de dados, certificação, segurança e governança devem ser validados de acordo com as responsabilidades definidas pela arquitetura do Atlas Engineering.

Esta estratégia de testes não redefine regras de qualidade de dados, semântica de certificação, políticas de acesso, controles de segurança, requisitos de privacidade ou responsabilidades de governança.

Ela define como os controles implementados são exercitados e como as evidências são utilizadas para determinar se eles se comportam conforme projetado.

Um controle não é considerado validado apenas porque o mecanismo responsável por executá-lo foi concluído com sucesso.

A validação deve avaliar a decisão, o estado, os dados ou o comportamento de acesso resultante produzido pelo controle.

### 9.1 Validação de Qualidade de Dados

Os testes de qualidade de dados devem determinar se as regras de qualidade implementadas distinguem corretamente os dados que satisfazem as expectativas estabelecidas daqueles que não as satisfazem.

Dependendo da etapa de processamento, a validação pode incluir:

- completude;
- validade;
- unicidade;
- consistência;
- expectativas referenciais;
- valores controlados;
- atributos obrigatórios;
- conformidade com regras de negócio;
- outras regras de qualidade implementadas.

Os testes devem, preferencialmente, incluir condições válidas e inválidas representativas quando viável.

O objetivo é validar o comportamento do controle de qualidade, e não apenas executar o mecanismo de verificação da qualidade.

### 9.2 Cenários com Dados Válidos

Os controles de qualidade não devem apenas rejeitar dados inválidos.

Eles também devem permitir que dados válidos progridam de acordo com a arquitetura.

Cenários com dados válidos podem verificar se:

- os registros esperados são aceitos;
- as transformações obrigatórias ocorrem;
- nenhuma rejeição não intencional é produzida;
- o processamento continua;
- os dados resultantes estão corretos;
- as etapas *downstream* recebem o escopo esperado;
- a certificação permanece possível.

Um controle que rejeita todos os registros pode tecnicamente detectar dados inválidos, mas não representa comportamento correto de qualidade.

### 9.3 Cenários com Dados Inválidos

Cenários controlados com dados inválidos devem, preferencialmente, validar se as regras de qualidade detectam e tratam violações de acordo com a arquitetura.

Exemplos podem incluir:

- ausência de valores obrigatórios;
- valores controlados inválidos;
- identificadores malformados;
- relacionamentos inválidos;
- dados duplicados quando a unicidade é obrigatória;
- valores fora das regras definidas;
- registros inconsistentes;
- outras violações representativas de contrato ou qualidade.

O cenário deve definir qual regra deverá falhar e qual comportamento resultante é esperado.

### 9.4 Rejeição Esperada

Uma rejeição esperada de dados pode representar um resultado de validação bem-sucedido.

Um cenário projetado para fornecer dados inválidos pode ser considerado PASS quando:

- a regra pretendida detecta a violação;
- o registro afetado é rejeitado ou isolado de acordo com a política;
- o motivo da rejeição é identificável;
- o processamento válido não relacionado se comporta conforme esperado;
- o registro rejeitado não é incorretamente certificado;
- as evidências necessárias são produzidas.

A presença de um registro rejeitado, portanto, não deve ser automaticamente interpretada como falha do teste.

### 9.5 Rejeição Inesperada

A rejeição de um registro válido representa uma preocupação de validação diferente.

Os testes devem, preferencialmente, determinar se a rejeição foi causada por:

- regra de qualidade incorreta;
- implementação incorreta;
- dados de teste incorretos;
- expectativa de contrato incorreta;
- problema de configuração;
- defeito nos dados *upstream*.

Uma rejeição inesperada deve permanecer visível mesmo que a execução geral do processamento seja concluída com sucesso.

### 9.6 Tratamento de Dados Rejeitados

Quando a arquitetura preservar dados rejeitados ou em quarentena, os testes devem, preferencialmente, validar o tratamento resultante.

Questões relevantes podem incluir:

- O registro rejeitado é preservado quando necessário?
- O motivo da rejeição está disponível?
- O escopo de processamento afetado pode ser identificado?
- As informações sensíveis estão protegidas?
- O processamento válido não relacionado continua quando esperado?
- Os dados corrigidos podem seguir o caminho pretendido de recuperação ou reprocessamento?

Dados rejeitados não devem desaparecer silenciosamente quando a arquitetura exigir evidências ou remediação.

### 9.7 Validação de Limites de Qualidade

Quando decisões de certificação ou processamento dependerem de limites de qualidade, os testes devem validar o comportamento em torno de limites significativos.

Os cenários podem incluir:

- valor abaixo do limite;
- valor exatamente no limite;
- valor acima do limite.

A validação deve confirmar tanto a medição calculada quanto a decisão resultante.

Os limites devem ser derivados da arquitetura ou de requisitos definidos.

Eles não devem ser inventados durante os testes apenas para classificar um resultado observado como aceitável.

### 9.8 Validação da Certificação

Os testes de certificação devem determinar se os dados se tornam certificados somente quando as condições necessárias são satisfeitas.

A validação deve, preferencialmente, distinguir estados como:

- processamento concluído e certificação bem-sucedida;
- processamento concluído, mas certificação com falha;
- processamento concluído e certificação pendente;
- certificação impossibilitada porque o processamento *upstream* necessário está incompleto.

O processamento bem-sucedido da Gold não deve, por si só, implicar certificação bem-sucedida.

O estado da certificação deve ser verificado diretamente.

### 9.9 Certificação Bem-Sucedida

Um cenário de certificação bem-sucedida deve, preferencialmente, verificar, quando aplicável:

- o processamento necessário foi concluído;
- as verificações de qualidade necessárias foram concluídas;
- os critérios obrigatórios de certificação foram satisfeitos;
- o estado de certificação foi persistido;
- os dados certificados correspondem ao escopo de processamento pretendido;
- o consumo *downstream* de dados certificados torna-se possível;
- evidências relevantes de certificação estão disponíveis.

O teste deve verificar a decisão de certificação, em vez de inferi-la a partir da conclusão de um *job downstream*.

### 9.10 Falha de Certificação

Cenários controlados devem, preferencialmente, validar que a certificação falha quando as condições obrigatórias de certificação não são satisfeitas.

A validação pode exigir que:

- o critério que falhou seja identificável;
- o estado de certificação represente a falha;
- o escopo afetado seja identificável;
- dados não validados não sejam apresentados como certificados;
- evidências da falha estejam disponíveis;
- remediação ou reprocessamento permaneçam possíveis quando definidos.

Um processo de certificação que corretamente se recusa a certificar dados inválidos representa comportamento bem-sucedido do controle e pode, portanto, produzir um resultado PASS no teste.

### 9.11 Recuperação da Certificação

Quando uma certificação que falhou puder ser corrigida e repetida, os testes devem, preferencialmente, validar o caminho de recuperação.

Um cenário pode incluir:

1. o processamento é concluído;
2. a certificação falha;
3. a causa é identificada;
4. o dado, a regra, a configuração ou o defeito de processamento é corrigido;
5. o processamento ou a validação necessários são repetidos;
6. a certificação é executada novamente;
7. a certificação é bem-sucedida;
8. a disponibilidade *downstream* dos dados certificados é restaurada.

As evidências da certificação original que falhou devem permanecer preservadas.

A recertificação bem-sucedida não deve apagar o histórico da falha anterior.

### 9.12 Escopo da Certificação

A validação da certificação deve confirmar que a decisão de certificação se aplica aos dados ou ao escopo de processamento pretendidos.

O escopo pode ser representado por:

- execução;
- lote;
- janela de processamento;
- conjunto de dados;
- partição;
- escopo de processamento dimensional;
- outro limite de certificação definido.

Uma decisão de certificação bem-sucedida para um escopo não deve ser interpretada como certificação de dados não relacionados ou incompletos.

### 9.13 Disponibilidade *Downstream* de Dados Certificados

Quando consumidores *downstream* dependerem de dados certificados, os testes devem, preferencialmente, verificar se o estado correto de certificação controla a disponibilidade conforme projetado.

Cenários relevantes podem determinar se:

- dados certificados com sucesso tornam-se disponíveis;
- uma falha de certificação impede disponibilidade certificada inadequada;
- certificação pendente é distinguível do estado certificado;
- dados corrigidos e recertificados tornam-se disponíveis após a recuperação.

A disponibilidade *downstream* deve permanecer consistente com a semântica de certificação definida pela plataforma.

### 9.14 Validação de Segurança

Os testes de segurança devem validar os controles de segurança implementados dentro do escopo que possa ser exercitado de forma significativa pelo laboratório.

Controles relevantes podem incluir:

- autenticação;
- autorização;
- menor privilégio;
- tratamento de segredos;
- comunicação protegida;
- acesso a dados sensíveis;
- auditabilidade;
- acesso a evidências operacionais.

Os testes devem avaliar o resultado real do controle.

A existência de configuração de segurança, por si só, não demonstra que o controle seja efetivo.

### 9.15 Acesso Autorizado

Cenários positivos de segurança devem, preferencialmente, verificar se identidades com as permissões necessárias podem executar as operações pretendidas.

A validação pode incluir:

- autenticação bem-sucedida;
- acesso permitido aos dados;
- interação permitida com componentes;
- comportamento esperado da função;
- acesso às evidências operacionais necessárias.

O acesso autorizado bem-sucedido confirma apenas as permissões representadas pela identidade e pelo escopo testados.

Ele não deve ser interpretado como validação de controles de segurança não relacionados.

### 9.16 Acesso Não Autorizado

Cenários negativos de segurança devem, preferencialmente, verificar se operações fora do limite de permissões pretendido são negadas.

Dependendo dos controles implementados, os cenários podem incluir tentativas de:

- acessar dados não autorizados;
- modificar dados protegidos;
- executar processamento não autorizado;
- acessar segredos;
- acessar telemetria restrita;
- executar operações administrativas privilegiadas.

Uma solicitação negada pode representar um resultado PASS quando a negação for o comportamento de segurança esperado.

### 9.17 Validação de Menor Privilégio

Quando funções ou identidades forem projetadas segundo o princípio de menor privilégio, os testes devem, preferencialmente, determinar se as operações necessárias são permitidas enquanto operações desnecessárias permanecem negadas.

A validação deve evitar testar apenas se uma identidade "funciona".

Ela deve, preferencialmente, avaliar o limite do que essa identidade tem permissão para fazer.

Isso ajuda a distinguir acesso funcional de acesso excessivo.

### 9.18 Validação do Tratamento de Segredos

Os testes devem, preferencialmente, verificar, quando viável, se os segredos são tratados de acordo com o modelo de segurança implementado.

A validação relevante pode incluir confirmar que segredos não sejam expostos desnecessariamente em:

- código-fonte;
- configurações submetidas ao repositório;
- *logs*;
- evidências de teste;
- capturas de tela;
- mensagens de exceção;
- *dashboards* operacionais.

Os testes não devem publicar intencionalmente segredos reais apenas para demonstrar que a exposição de segredos seria visível.

Valores controlados e seguros devem ser utilizados quando testes de exposição forem necessários.

### 9.19 Validação da Exposição de Dados Sensíveis

Quando o processamento envolver informações sensíveis, os testes devem, preferencialmente, determinar se os artefatos operacionais e de validação expõem mais informações do que o necessário.

Artefatos relevantes podem incluir:

- *logs*;
- registros de dados rejeitados;
- *labels* de métricas;
- alertas;
- *dashboards*;
- evidências de teste;
- capturas de tela.

O objetivo não é eliminar todo contexto útil.

É garantir que o valor de diagnóstico e validação não crie uma cópia secundária não controlada de dados sensíveis.

### 9.20 Validação da Auditabilidade

Quando a arquitetura exigir ações ou acessos auditáveis, os testes devem, preferencialmente, verificar se a atividade relevante produz evidências suficientes.

A validação pode determinar se as evidências de auditoria identificam, quando aplicável:

- ação;
- identidade;
- recurso afetado;
- *timestamp*;
- resultado.

As evidências de auditoria devem permanecer distinguíveis de *logging* geral de diagnóstico quando a arquitetura atribuir responsabilidades diferentes a esses mecanismos.

### 9.21 Validação da Retenção

Quando o comportamento de retenção estiver implementado e puder ser testado de forma prática, os cenários devem, preferencialmente, verificar se as informações são retidas de acordo com a política definida.

Os testes podem avaliar:

- retenção esperada;
- expiração;
- elegibilidade para exclusão;
- preservação das evidências necessárias;
- proteção contra retenção indefinida não intencional.

Políticas de longa duração podem exigir validação acelerada ou controlada em laboratório, em vez de aguardar que períodos corporativos de retenção transcorram.

Qualquer validação acelerada deve permanecer claramente identificada como tal.

### 9.22 Validação da Exclusão

Quando o comportamento de exclusão estiver implementado, os testes devem, preferencialmente, verificar se os dados ou evidências pretendidos são removidos de acordo com o escopo definido sem remover involuntariamente informações obrigatórias não relacionadas.

A validação relevante pode incluir:

- alvo da exclusão;
- escopo da exclusão;
- estado resultante;
- evidências de auditoria preservadas quando necessário;
- implicações *downstream*.

A validação da exclusão deve respeitar a distinção da arquitetura entre dados operacionais, dados analíticos, telemetria e evidências de validação preservadas.

### 9.23 Segurança das Evidências de Teste

As próprias evidências de teste devem permanecer protegidas de acordo com seu conteúdo e propósito.

Os artefatos de validação podem conter:

- amostras de dados;
- identificadores;
- resultados de consultas;
- *logs*;
- informações de falha;
- detalhes de configuração;
- resultados de controles de acesso;
- capturas de tela.

As evidências não devem se tornar um mecanismo para contornar os controles que protegem a própria plataforma.

Quando possível, as evidências devem preservar o mínimo de conteúdo sensível necessário para sustentar a conclusão da validação.

### 9.24 Evidências de Falha de Segurança

Falhas de controles de segurança devem permanecer visíveis como evidências de engenharia.

Se um teste demonstrar que uma identidade obteve acesso que deveria ter sido negado, o resultado de falha deve ser preservado.

A correção e o novo teste devem permanecer relacionados à falha original:

**negação esperada → acesso não autorizado observado → FAIL → diagnóstico → correção → novo teste → negação esperada → PASS.**

A falha original de segurança não deve ser removida apenas porque o controle foi posteriormente corrigido.

### 9.25 Limites da Validação de Governança

Nem toda responsabilidade de governança pode ser completamente validada por meio de testes automatizados ou de curta duração em laboratório.

Alguns controles podem depender de:

- processos organizacionais;
- interpretação jurídica;
- retenção de longo prazo;
- procedimentos formais de incidentes;
- sistemas corporativos de identidade;
- *workflows* de aprovação humana;
- requisitos externos de conformidade.

Quando esses controles estiverem fora da implementação de laboratório, o projeto deve distinguir entre:

- requisito arquitetural;
- controle implementado;
- comportamento validado em laboratório;
- responsabilidade operacional corporativa.

Os testes não devem afirmar validação para um controle que não tenha sido efetivamente exercitado.

### 9.26 Cenários entre Controles

Alguns cenários de validação podem exercitar intencionalmente múltiplos controles em conjunto.

Por exemplo, um registro inválido contendo informações sensíveis pode exigir validação de:

- rejeição por qualidade de dados;
- tratamento dos dados rejeitados;
- proteção dos dados sensíveis;
- observabilidade;
- impedimento da certificação;
- evidências de auditoria.

Cenários entre controles são úteis quando o comportamento arquitetural depende da interação entre responsabilidades.

Cada critério obrigatório deve permanecer explícito para que o sucesso de um controle não oculte a falha de outro.

### 9.27 Evidências de Validação

As evidências para cenários de qualidade de dados, certificação, segurança e governança devem ser suficientes para demonstrar o resultado relevante do controle.

Dependendo do cenário, as evidências podem incluir:

- dados de entrada;
- dados resultantes;
- estado dos dados rejeitados;
- resultados das regras de qualidade;
- estado de certificação;
- estado *downstream*;
- resultado de autorização;
- registro de auditoria;
- *logs*;
- eventos operacionais;
- registros de execução do teste.

O conjunto de evidências deve permanecer proporcional ao controle que está sendo validado.

Um controle é validado pelo comportamento demonstrado e pelo estado resultante, e não apenas pela presença da configuração destinada a implementá-lo.

---

## 10. Validação *End-to-End* e Arquitetural

A validação *end-to-end* e arquitetural determina se as responsabilidades implementadas da plataforma operam corretamente quando exercitadas em conjunto através dos limites de processamento relevantes.

Testes individuais de componentes, integração, transformação, qualidade, recuperação, segurança e observabilidade fornecem evidências importantes.

Eles não demonstram, de forma independente, que o fluxo completo de dados produz o resultado arquitetural esperado.

A validação *end-to-end*, portanto, avalia a relação relevante entre:

**origem → ingestão → Kafka → Bronze → Silver → Gold → certificação → consumo *downstream*.**

Nem todo cenário *end-to-end* precisa exercitar todas as capacidades possíveis da plataforma.

O escopo necessário depende do comportamento arquitetural que está sendo validado.

### 10.1 Objetivo da Validação *End-to-End*

Um cenário *end-to-end* deve definir o resultado arquitetural que pretende validar.

O objetivo deve, preferencialmente, descrever um comportamento significativo da plataforma, em vez de apenas exigir que todos os componentes sejam executados.

Exemplos podem incluir:

- uma alteração na origem torna-se corretamente disponível como dado analítico certificado;
- dados inválidos na origem são detectados e impedidos de se tornarem certificados;
- o processamento interrompido em uma etapa intermediária pode se recuperar sem efeitos de dados não intencionais;
- dados históricos podem ser processados por meio de um *backfill* controlado;
- o *backlog* acumulado converge após a capacidade de processamento ser restaurada;
- consumidores *downstream* recebem apenas dados que satisfaçam o estado de certificação exigido.

O objetivo determina quais etapas, estados e evidências devem ser avaliados.

### 10.2 Escopo de Processamento *End-to-End*

O escopo de processamento de um cenário *end-to-end* deve permanecer identificável através dos limites arquiteturais relevantes.

Dependendo do cenário, o escopo pode ser representado por:

- registros da origem;
- identificadores de transações da origem;
- eventos;
- tópico, partição e intervalo de *offsets* do Kafka;
- execução;
- lote;
- janela de processamento;
- conjunto de dados;
- escopo dimensional;
- escopo de certificação;
- conjunto de dados *downstream*.

A representação exata pode mudar entre as etapas.

As evidências devem preservar correlação suficiente para demonstrar que o escopo pretendido da origem produziu o resultado *downstream* avaliado.

### 10.3 Validação da Origem

Quando o cenário começar com dados da origem, o estado relevante da origem deve ser conhecido.

A validação pode incluir:

- existência do registro na origem;
- valores esperados na origem;
- horário da alteração na origem;
- identificador da origem;
- estado inicial de negócio;
- elegibilidade esperada para ingestão.

O estado da origem fornece a referência em relação à qual o processamento *downstream* pode ser avaliado.

Um resultado *downstream* não pode ser validado de forma significativa em relação a um estado de origem desconhecido ou ambíguo.

### 10.4 Validação da Ingestão

A validação *end-to-end* deve, preferencialmente, determinar se o escopo pretendido da origem foi capturado pelo mecanismo de ingestão.

Evidências relevantes podem incluir:

- evento de ingestão;
- estado da ingestão;
- identificador da origem capturado;
- *timestamp* de ingestão;
- evento produzido;
- evidências de falha ou nova tentativa, quando aplicável.

O teste deve, preferencialmente, distinguir entre:

- nenhuma alteração qualificável na origem;
- alteração na origem não capturada;
- falha de ingestão;
- ingestão bem-sucedida.

### 10.5 Validação do Transporte pelo Kafka

Quando o Kafka participar do cenário, a validação deve, preferencialmente, determinar se os dados pretendidos foram transportados pelo tópico e comportamento de partição esperados.

Evidências relevantes podem incluir:

- tópico;
- partição;
- *offset*;
- identificador do evento;
- estrutura do evento;
- evidência do produtor;
- evidência do consumidor;
- estado do grupo de consumidores.

A disponibilidade do Kafka, por si só, não demonstra que o evento pretendido foi corretamente transportado e consumido.

### 10.6 Validação da Bronze

A validação da Bronze deve determinar se os dados ingeridos pretendidos chegaram ao armazenamento bruto durável de acordo com a semântica de processamento definida.

Dependendo da arquitetura, a validação pode avaliar:

- presença esperada do registro bruto;
- metadados da origem;
- metadados de ingestão;
- escopo de processamento;
- estado de persistência;
- comportamento de duplicidades;
- estado relevante do *checkpoint* ou da execução.

O sucesso da Bronze deve ser avaliado em relação ao escopo pretendido da origem e do transporte.

### 10.7 Validação da Silver

A validação da Silver deve determinar se os dados da Bronze foram processados de acordo com as regras esperadas de validação e transformação.

A validação relevante pode incluir:

- registros esperados aceitos;
- registros inválidos rejeitados;
- transformações aplicadas;
- comportamento de deduplicação;
- correção dos dados resultantes;
- motivos de rejeição;
- estado do processamento;
- *checkpoints* relevantes.

A conclusão do processamento da Silver, por si só, não demonstra que os dados resultantes estão corretos.

### 10.8 Validação da Gold

A validação da Gold deve determinar se o escopo pretendido da Silver produziu o resultado dimensional ou analítico esperado.

A validação relevante pode incluir:

- estado das dimensões;
- estado dos fatos;
- chaves e relacionamentos;
- comportamento histórico;
- agregações;
- transformações dimensionais;
- escopo de processamento;
- completude dos dados resultantes;
- correção dos dados resultantes.

A validação exata depende da semântica dimensional definida pela plataforma.

### 10.9 Validação da Certificação

Quando a certificação for obrigatória antes do consumo analítico, a validação *end-to-end* deve verificar diretamente o resultado da certificação.

O cenário deve, preferencialmente, determinar se:

- o processamento *upstream* necessário foi concluído;
- a validação necessária foi concluída;
- a certificação foi bem-sucedida ou falhou conforme esperado;
- a certificação se aplica ao escopo pretendido;
- dados não certificados não são apresentados como certificados.

A conclusão do processamento da Gold não deve ser tratada como equivalente à certificação.

### 10.10 Validação *Downstream*

Quando o cenário incluir consumo *downstream*, os testes devem determinar se o resultado certificado esperado está efetivamente disponível no limite de consumo pretendido.

A validação relevante pode incluir:

- disponibilidade do conjunto de dados;
- registros esperados;
- valores esperados;
- atualidade;
- estado de certificação;
- resultado de consulta;
- disponibilidade do modelo semântico;
- outro comportamento de consumo implementado.

Um *pipeline upstream* bem-sucedido não demonstra, de forma independente, disponibilidade *downstream*.

### 10.11 Correção dos Dados entre Etapas

A validação *end-to-end* deve determinar se a semântica relevante dos dados permanece correta à medida que os dados progridem pelas etapas de processamento.

Dependendo do cenário, isso pode exigir a comparação de:

- valores da origem com a ingestão bruta;
- dados brutos com dados validados;
- dados validados com resultados dimensionais;
- dados dimensionais com dados certificados;
- dados certificados com resultados *downstream*.

O objetivo não é necessariamente preservar uma representação física idêntica entre as etapas.

O objetivo é demonstrar que as transformações pretendidas preservam ou produzem o significado de negócio esperado.

### 10.12 Completude entre Etapas

Quando a completude for relevante, a validação deve, preferencialmente, determinar se todos os dados necessários progrediram pelo caminho de processamento pretendido.

As verificações relevantes podem incluir:

- registros esperados da origem capturados;
- eventos esperados transportados;
- registros esperados da Bronze persistidos;
- registros esperados da Silver aceitos ou explicitamente rejeitados;
- escopo esperado da Gold produzido;
- escopo esperado de certificação avaliado;
- dados esperados *downstream* disponíveis.

Diferenças nas contagens de registros entre etapas devem ser interpretadas de acordo com a semântica de transformação, filtragem, rejeição, deduplicação e agregação.

A igualdade de contagens não deve ser presumida quando a arquitetura não a exigir.

### 10.13 Rastreabilidade entre Etapas

As evidências devem, preferencialmente, permitir que o escopo de processamento testado seja rastreado através das etapas relevantes.

A rastreabilidade pode utilizar:

- identificadores da origem;
- identificadores de eventos;
- identificadores de execução;
- identificadores de lote;
- metadados do Kafka;
- escopo de processamento;
- *timestamps*;
- identificadores dimensionais;
- escopo de certificação.

Nem toda etapa precisa preservar o mesmo identificador físico.

As evidências devem fornecer relações suficientes para reconstruir a progressão relevante para o cenário de validação.

### 10.14 Atualidade *End-to-End*

Quando a atualidade dos dados fizer parte da expectativa arquitetural, os testes devem, preferencialmente, medir a relação temporal relevante entre o estado da origem e a disponibilidade *downstream*.

A medição deve definir seus pontos de início e término.

Por exemplo:

**horário do evento na origem → horário da disponibilidade certificada *downstream***

ou outro limite do ciclo de vida explicitamente definido.

A atualidade *end-to-end* deve permanecer distinguível da duração da execução de etapas individuais de processamento.

### 10.15 Validação de Falha *End-to-End*

Cenários *end-to-end* podem introduzir intencionalmente uma falha em um limite arquitetural e avaliar seus efeitos em todo o fluxo relevante.

A validação relevante pode determinar:

- onde o processamento foi interrompido;
- qual escopo foi afetado;
- se o processamento *upstream* continuou;
- se o processamento *downstream* foi corretamente interrompido ou permaneceu isolado;
- se dados incompletos foram impedidos de serem certificados;
- se evidências da falha foram produzidas;
- se dados não relacionados permaneceram disponíveis quando esperado.

O comportamento esperado de propagação ou isolamento deve seguir a arquitetura que está sendo testada.

### 10.16 Validação de Recuperação *End-to-End*

Após uma falha *end-to-end*, os testes devem, preferencialmente, determinar se a recuperação restaura o caminho de processamento pretendido e o estado resultante.

A validação relevante pode incluir:

- posição inicial da recuperação;
- escopo de processamento recuperado;
- progressão de *checkpoints*;
- comportamento de *replay* ou reprocessamento;
- estado resultante da Bronze, Silver e Gold;
- certificação;
- disponibilidade *downstream*;
- restauração da atualidade;
- comportamento de duplicidades e omissões.

A recuperação deve ser validada por meio do resultado completo relevante, e não apenas no componente em que a falha ocorreu.

### 10.17 Certificação como Limite *End-to-End*

A certificação representa um limite arquitetural importante entre o processamento concluído e os dados aprovados para uso analítico *downstream*.

A validação *end-to-end* deve preservar essa distinção.

Um cenário pode, portanto, produzir:

**processamento PASS + certificação PASS**

ou:

**processamento PASS + certificação FAIL**

sem contradição.

O segundo resultado pode demonstrar comportamento arquitetural correto quando a certificação impede adequadamente que dados inadequados se tornem certificados.

### 10.18 Disponibilidade *Downstream* Faz Parte do Resultado

Quando o consumo *downstream* estiver incluído na arquitetura implementada, a validação não deve terminar na certificação bem-sucedida.

O teste deve, preferencialmente, determinar se os dados certificados tornaram-se disponíveis por meio do limite *downstream* pretendido.

Isso pode incluir, dependendo da implementação:

- consulta analítica;
- modelo semântico;
- conjunto de dados de *dashboard*;
- conjunto de dados exportado;
- outra interface de consumo definida.

A estratégia de testes valida o limite *downstream* implementado sem exigir que todas as tecnologias possíveis de consumo sejam testadas.

### 10.19 Validação de Cenários Arquiteturais

Alguns testes validam comportamentos arquiteturais que abrangem múltiplas preocupações, em vez de uma única etapa do *pipeline*.

Exemplos podem incluir:

- comportamento de *checkpoints* duráveis durante falha e reinicialização;
- isolamento de registros venenosos enquanto registros válidos continuam;
- certificação impedindo disponibilidade analítica inválida;
- recuperação restaurando a atualidade *downstream*;
- controles de segurança protegendo evidências de observabilidade;
- recuperação de *backlog* enquanto novo processamento continua.

Esses cenários devem, preferencialmente, identificar cada responsabilidade arquitetural que está sendo avaliada e os critérios obrigatórios associados a ela.

O sucesso em uma preocupação não deve ocultar a falha em outra.

### 10.20 Validação entre Documentos

Cenários arquiteturais podem derivar expectativas de múltiplos documentos especializados de arquitetura.

Por exemplo, um cenário de falha e recuperação pode depender de:

- semântica de processamento de **Fluxo e Processamento de Dados**;
- semântica de recuperação de **Confiabilidade e Recuperação**;
- requisitos de segurança de **Segurança e Governança**;
- requisitos de evidências operacionais de **Observabilidade**;
- regras de validação desta estratégia de testes.

O cenário deve, preferencialmente, preservar rastreabilidade suficiente para determinar quais responsabilidades arquiteturais estão sendo validadas.

Esta estratégia de testes coordena a validação entre essas responsabilidades sem redefini-las.

### 10.21 Validação de Afirmações Arquiteturais

Afirmações arquiteturais relevantes devem, preferencialmente, ser sustentadas por evidências de validação quando viável.

Uma afirmação como:

**"A plataforma suporta *replay* controlado."**

deve ser distinguível de:

**"*Replay* controlado está implementado."**

e:

**"*Replay* controlado foi validado para o cenário e o escopo de processamento documentados."**

A afirmação mais forte deve ser sustentada pela implementação e pelas evidências correspondentes.

A documentação não deve apresentar comportamento pretendido como comportamento experimentalmente validado quando a validação ainda não tiver ocorrido.

### 10.22 Validação de Garantias Negativas

Algumas expectativas arquiteturais descrevem comportamentos que não devem ocorrer.

Exemplos podem incluir:

- dados inválidos não devem se tornar certificados;
- acesso não autorizado não deve ser bem-sucedido;
- o *replay* não deve afetar escopos de processamento não relacionados;
- execuções repetidas não devem criar efeitos de duplicidade não intencionais;
- uma etapa *upstream* que falhou não deve ser representada como processamento *downstream* bem-sucedido.

Garantias negativas exigem evidências apropriadas para demonstrar sua ausência dentro do escopo testado.

A ausência de mensagens de erro observadas, por si só, não constitui evidência suficiente de que o comportamento proibido não ocorreu.

### 10.23 Validação Arquitetural com Múltiplos Cenários

Uma responsabilidade arquitetural significativa pode exigir mais de um cenário antes que possa ser considerada significativamente validada.

Por exemplo, a validação de *replay* pode exigir cenários que cubram:

- *replay* bem-sucedido;
- escopo delimitado de *replay*;
- *replay* repetido;
- falha de *replay*;
- recuperação do *replay*;
- correção *downstream*.

O conjunto de cenários necessário depende do risco e da complexidade do comportamento arquitetural.

Um único caminho bem-sucedido não deve ser automaticamente tratado como validação completa de todas as condições associadas de falha e limite.

### 10.24 Regressão do Comportamento Arquitetural

Quando alterações na implementação afetarem uma responsabilidade arquitetural previamente validada, os cenários *end-to-end* ou arquiteturais relevantes devem, preferencialmente, ser repetidos.

As alterações podem incluir:

- alterações no contrato da origem;
- alterações na configuração do Kafka;
- alterações na lógica de processamento;
- alterações em *checkpoints*;
- alterações no modelo dimensional;
- alterações nas regras de certificação;
- alterações na recuperação;
- alterações nos controles de segurança;
- alterações na observabilidade;
- alterações na orquestração.

O escopo da regressão deve ser proporcional ao impacto arquitetural potencial.

Evidências históricas de PASS permanecem valiosas, mas não comprovam comportamento inalterado após mudanças materiais na implementação.

### 10.25 Matriz de Validação Arquitetural

Quando viável, o Atlas Engineering deve, preferencialmente, manter uma visão rastreável conectando as principais responsabilidades arquiteturais ao seu estado de validação.

A matriz pode identificar:

- documento de arquitetura;
- responsabilidade arquitetural;
- requisito;
- cenário de validação;
- execução mais recente;
- resultado;
- referência das evidências;
- status de implementação;
- status de validação.

O formato exato do artefato pode evoluir com o projeto.

Seu propósito é tornar visível se uma responsabilidade arquitetural documentada está:

- projetada;
- implementada;
- validada;
- com falha;
- bloqueada;
- ainda não testada.

A matriz não deve reduzir a qualidade da validação a um percentual numérico.

Seu propósito é fornecer rastreabilidade e visibilidade das lacunas de validação arquitetural.

### 10.26 Pacote de Evidências *End-to-End*

Um pacote relevante de evidências *end-to-end* deve, preferencialmente, preservar informações suficientes para reconstruir o caminho testado.

Dependendo do cenário, isso pode incluir:

- estado da origem;
- identificadores do cenário e da execução;
- escopo de processamento;
- evidências de ingestão;
- evidências do Kafka;
- estado da Bronze;
- estado da Silver;
- estado da Gold;
- estado de certificação;
- resultado *downstream*;
- *checkpoints*;
- falhas;
- atividade de recuperação;
- métricas;
- *logs*;
- eventos operacionais;
- critérios de aceitação;
- resultado final.

O pacote de evidências deve permanecer proporcional ao cenário.

O objetivo não é arquivar todos os artefatos gerados pela plataforma.

O objetivo é preservar evidências suficientes para demonstrar a conclusão arquitetural *end-to-end*.

### 10.27 Conclusão da Validação Arquitetural

Uma conclusão de validação arquitetural deve permanecer proporcional ao comportamento, ao escopo, ao ambiente e às evidências efetivamente testados.

Um cenário *end-to-end* bem-sucedido demonstra que a plataforma implementada se comportou de acordo com as expectativas definidas sob aquelas condições.

Ele não comprova, de forma independente:

- correção para todas as entradas possíveis;
- resiliência contra todas as falhas;
- escalabilidade ilimitada;
- disponibilidade em escala corporativa;
- conformidade universal de segurança;
- correção de responsabilidades arquiteturais não incluídas no cenário.

A validação arquitetural fortalece a confiança por meio de evidências controladas.

Ela não substitui o julgamento de engenharia, testes contínuos, observação operacional ou o reconhecimento explícito dos limites ainda não validados.

---

## 11. Preservação de Evidências e Histórico de Testes

As evidências de validação devem permanecer disponíveis por um período apropriado ao seu valor arquitetural, investigativo, de regressão e histórico.

A preservação de evidências não tem como objetivo criar um arquivo indefinido de todos os artefatos produzidos durante os testes.

Seu propósito é reter informações suficientes para compreender o que foi testado, o que ocorreu, qual conclusão foi alcançada, como as falhas foram tratadas e quais comportamentos arquiteturais foram efetivamente demonstrados.

O histórico de testes deve preservar a distinção entre execuções individuais, correções, novos testes e resultados posteriores de regressão.

Uma execução posterior bem-sucedida não deve apagar nem substituir evidências relevantes de uma falha anterior.

### 11.1 Objetivos da Preservação

As evidências devem, preferencialmente, ser preservadas quando contribuírem para um ou mais propósitos relevantes, incluindo:

- validação arquitetural;
- revisão de testes;
- investigação de falhas;
- diagnóstico;
- histórico de novos testes;
- comparação de regressão;
- validação de recuperação;
- validação de segurança;
- comparação de performance;
- evolução arquitetural;
- evidências de portfólio.

A quantidade e a duração das evidências preservadas devem, preferencialmente, permanecer proporcionais a esses propósitos.

### 11.2 Preservação da Definição do Cenário

As evidências históricas devem permanecer interpretáveis em relação à definição do cenário sob a qual foram produzidas.

Quando relevante, a preservação deve, preferencialmente, incluir ou referenciar:

- identificador do cenário;
- versão do cenário;
- expectativa arquitetural;
- escopo de processamento;
- pré-condições;
- comportamento esperado;
- evidências esperadas;
- critérios de aceitação;
- requisitos de restauração.

Um resultado histórico PASS ou FAIL possui valor limitado se os critérios utilizados para produzir esse resultado não puderem mais ser determinados.

### 11.3 Histórico de Execuções

Cada execução relevante deve, preferencialmente, permanecer distinguível das demais execuções do mesmo cenário.

O histórico de execuções pode incluir:

- identificador da execução;
- identificador e versão do cenário;
- horário da execução;
- ambiente;
- escopo de processamento;
- resultado;
- referência das evidências;
- referência da falha, quando aplicável;
- relação com novo teste, quando aplicável.

O cenário representa a definição reutilizável da validação.

A execução representa uma ocorrência desse cenário.

### 11.4 Preservação do Resultado

O resultado original de uma execução de validação concluída deve permanecer preservado.

Resultados relevantes podem incluir:

- **PASS**;
- **FAIL**;
- **INCONCLUSIVE**;
- **BLOCKED**;
- **NOT EXECUTED**, quando mantido pelo modelo de gerenciamento de testes.

Uma execução posterior não deve alterar retroativamente o resultado histórico de uma execução anterior.

Se for descoberto que um resultado anterior foi classificado incorretamente, a correção deve, preferencialmente, ser documentada, preservando o estado originalmente registrado e, quando viável, o motivo da reclassificação.

### 11.5 Histórico de Testes com Falha

Testes que falharam fazem parte do histórico de engenharia da plataforma.

Quando uma validação relevante falhar, o histórico preservado deve, preferencialmente, permitir reconstruir:

**comportamento esperado → comportamento observado → critério que falhou → evidências → diagnóstico → correção → novo teste.**

Uma execução com falha pode revelar:

- defeito de implementação;
- lacuna arquitetural;
- configuração incorreta;
- requisito incorreto;
- problema no projeto do teste;
- problema ambiental;
- defeito de observabilidade;
- evidências insuficientes.

A falha permanece valiosa mesmo após o problema subjacente ter sido corrigido.

### 11.6 Histórico de Diagnóstico

Quando um diagnóstico for necessário após um teste com resultado FAIL ou INCONCLUSIVE, a conclusão de engenharia resultante deve, preferencialmente, permanecer associada à execução.

Informações relevantes podem incluir:

- sintoma observado;
- critério de aceitação que falhou;
- escopo de processamento afetado;
- causa suspeita;
- causa confirmada;
- evidências que sustentam o diagnóstico;
- responsabilidade arquitetural afetada.

O diagnóstico deve distinguir as evidências observadas das suposições feitas durante a investigação.

Uma causa inicialmente suspeita pode ser diferente da causa confirmada.

### 11.7 Histórico de Correções

Quando uma falha de validação resultar em uma alteração, a correção deve, preferencialmente, permanecer rastreável até a falha que a motivou.

As correções podem incluir:

- alteração de implementação;
- alteração de configuração;
- alteração arquitetural;
- esclarecimento de requisito;
- correção dos dados de teste;
- correção do cenário;
- correção dos critérios de aceitação;
- melhoria de observabilidade;
- alteração de documentação.

A existência de uma correção não converte a execução original com falha em PASS.

O comportamento corrigido deve ser avaliado por meio de um novo teste apropriado.

### 11.8 Histórico de Novos Testes

Novos testes devem permanecer conectados às execuções que os tornaram necessários.

Um histórico de validação pode, portanto, conter:

**Execução 1 — FAIL**

**Diagnóstico**

**Correção**

**Execução 2 — FAIL**

**Diagnóstico adicional**

**Correção**

**Execução 3 — PASS**

As três execuções permanecem como parte do histórico de validação.

O PASS final demonstra o comportamento corrigido sob as condições da Execução 3.

Isso não significa que as Execuções 1 e 2 não tenham ocorrido.

### 11.9 Histórico de Regressão

Execuções de regressão devem permanecer distinguíveis da validação inicial e dos novos testes corretivos.

Um cenário pode, portanto, acumular evidências demonstrando:

- validação inicial;
- falha e correção;
- novo teste bem-sucedido;
- regressão posterior após alteração na implementação;
- resultados subsequentes de regressão.

Esse histórico ajuda a determinar se um comportamento permaneceu estável ao longo da evolução da plataforma.

Um PASS histórico não deve ser presumido como ainda válido após alterações materiais sem a validação de regressão apropriada.

### 11.10 Contexto de Versão das Evidências

As evidências devem permanecer associadas a contexto de implementação suficiente para permitir uma interpretação significativa quando esse contexto puder afetar o comportamento.

O contexto relevante pode incluir:

- versão do cenário;
- versão da aplicação ou componente;
- versão da configuração;
- versão do *schema* ou contrato;
- configuração da infraestrutura;
- versão da arquitetura ou revisão do documento;
- versão de dependência relevante.

Nem toda versão de dependência precisa ser capturada para todos os testes.

O contexto necessário depende do que possa afetar materialmente a conclusão da validação.

### 11.11 Substituição das Evidências

Evidências mais recentes podem substituir evidências anteriores para fins de descrição do estado validado atual da plataforma.

A substituição não significa exclusão das evidências históricas.

Por exemplo:

- um PASS antigo pode deixar de representar o comportamento atual após uma alteração material na implementação;
- uma execução com falha pode ser seguida por um PASS após a correção;
- uma linha de base de performance antiga pode ser substituída por medições de uma arquitetura mais recente;
- um cenário pode ser substituído por uma versão materialmente revisada.

As evidências históricas devem permanecer identificáveis como históricas, em vez de serem apresentadas como validação atual.

### 11.12 Validade das Evidências

As evidências de validação permanecem aplicáveis somente enquanto as premissas e a implementação relevantes para o comportamento testado permanecerem suficientemente inalteradas.

A validade das evidências pode ser afetada por alterações em:

- lógica de processamento;
- contratos;
- *schemas*;
- semântica de *checkpoints*;
- comportamento de recuperação;
- regras de qualidade;
- certificação;
- controles de segurança;
- observabilidade;
- orquestração;
- infraestrutura;
- critérios de aceitação do cenário.

Uma alteração não invalida automaticamente todos os testes históricos.

O impacto deve ser avaliado de acordo com a responsabilidade arquitetural afetada.

### 11.13 Categorias de Retenção de Evidências

Diferentes evidências de validação podem exigir períodos de retenção diferentes.

As categorias podem incluir:

- evidências de execuções rotineiras;
- evidências de testes com falha;
- evidências de recuperação;
- evidências de controles de segurança;
- evidências de performance;
- evidências de regressão;
- evidências de marcos arquiteturais;
- evidências selecionadas de portfólio.

O projeto não exige um único período de retenção para todas as categorias.

A retenção deve refletir valor, sensibilidade, volume, capacidade de reprodução e requisitos de governança.

### 11.14 Evidências de Alto Volume

Alguns testes podem produzir grandes quantidades de *logs*, métricas, eventos ou artefatos intermediários.

Evidências de alto volume não precisam ser retidas indefinidamente quando um conjunto menor de evidências preservadas for suficiente para sustentar a conclusão da validação.

Quando apropriado, o projeto pode preservar:

- *logs* relevantes selecionados;
- métricas resumidas;
- medições representativas;
- estado autoritativo final;
- resultados de consultas;
- referências de eventos correlacionados;
- artefatos visuais selecionados.

A redução não deve remover informações necessárias para compreender ou defender o resultado do teste.

### 11.15 Evidências Brutas e Resumidas

As evidências podem existir tanto em formas brutas quanto resumidas.

Evidências brutas podem fornecer valor detalhado para diagnóstico.

Evidências resumidas podem facilitar a revisão e a preservação de longo prazo.

Quando evidências brutas não forem retidas indefinidamente, o resumo deve permanecer suficientemente preciso para identificar:

- cenário;
- execução;
- escopo;
- observações relevantes;
- estado resultante;
- critérios de aceitação;
- conclusão.

Um resumo não deve alterar materialmente nem ocultar evidências contraditórias da execução original.

### 11.16 Reprodutibilidade das Evidências

Quando viável, a confiança de longo prazo deve se basear na capacidade de reproduzir cenários importantes de validação, em vez da preservação indefinida de todos os artefatos brutos.

A reprodutibilidade exige preservar informações suficientes para reconstruir:

- cenário;
- dados necessários;
- configuração relevante;
- escopo de processamento;
- ações;
- comportamento esperado;
- critérios de aceitação;
- método de coleta de evidências.

Um teste reproduzível oferece maior valor de longo prazo do que uma coleção sem explicação de capturas de tela ou arquivos de *log*.

### 11.17 Integridade das Evidências

As evidências preservadas devem permanecer suficientemente intactas para representar o que ocorreu durante a execução.

As evidências não devem ser alteradas para remover:

- falhas;
- comportamentos inesperados;
- observações contraditórias;
- tentativas malsucedidas;
- informações temporais relevantes;
- evidências de estado incorreto.

Anotações, explicações, diagnósticos e conclusões posteriores podem ser adicionados.

Eles devem permanecer distinguíveis das evidências originalmente observadas quando essa distinção for relevante.

### 11.18 Rastreabilidade das Evidências

As evidências preservadas devem, preferencialmente, manter a relação:

**arquitetura → requisito → cenário → execução → evidências → resultado.**

Quando ocorrerem falhas, a relação pode se estender para:

**resultado → diagnóstico → correção → novo teste → novo resultado.**

Quando alterações posteriores ocorrerem, ela pode se estender ainda mais para:

**comportamento validado → alteração de implementação → cenário de regressão → resultado da regressão.**

A rastreabilidade permite que o projeto determine não apenas se existem evidências, mas qual afirmação arquitetural essas evidências efetivamente sustentam.

### 11.19 Localização das Evidências

As evidências devem ser organizadas de forma que o histórico relevante de validação possa ser localizado sem depender da memória pessoal.

A localização pode ser apoiada por meio de:

- identificadores determinísticos;
- nomenclatura consistente;
- referências de cenário;
- referências de execução;
- matrizes de validação;
- índices de evidências;
- estrutura do repositório;
- links de documentação.

A implementação exata pode evoluir.

O requisito arquitetural é que as evidências importantes permaneçam atribuíveis e revisáveis.

### 11.20 Segurança das Evidências

As evidências de teste preservadas permanecem sujeitas ao modelo de segurança e governança da plataforma.

As decisões de retenção devem considerar se as evidências contêm:

- dados pessoais;
- dados comerciais sensíveis;
- credenciais;
- segredos;
- *tokens*;
- detalhes de configuração;
- informações de controle de acesso;
- registros rejeitados;
- detalhes de infraestrutura.

As evidências devem preservar o mínimo de informações sensíveis necessário para sustentar seu propósito de validação.

Períodos maiores de retenção aumentam a responsabilidade de governança.

### 11.21 Exclusão de Evidências

Evidências que não precisem mais ser retidas podem ser removidas de acordo com os requisitos aplicáveis do projeto e de governança.

As decisões de exclusão devem, preferencialmente, considerar:

- valor atual de validação;
- valor histórico;
- reprodutibilidade;
- valor para regressão;
- valor como marco arquitetural;
- sensibilidade de segurança;
- custo de armazenamento;
- requisitos aplicáveis de retenção.

A exclusão não deve ser utilizada para criar um histórico de testes artificialmente bem-sucedido por meio da remoção seletiva de evidências de falhas enquanto se preservam evidências bem-sucedidas da mesma sequência relevante de validação.

### 11.22 Evidências de Marcos Arquiteturais

Evidências selecionadas podem ser preservadas como parte de grandes marcos arquiteturais.

Exemplos podem incluir a validação de:

- primeiro processamento *end-to-end* bem-sucedido;
- primeiro conjunto de dados Gold certificado;
- *replay* controlado;
- recuperação após interrupção do consumidor;
- convergência de *backlog*;
- *rebuild*;
- rejeição por qualidade de dados;
- falha de certificação e recuperação;
- aplicação de controle de segurança;
- observabilidade durante falha controlada.

As evidências de marcos podem demonstrar a progressão desde o projeto arquitetural até o comportamento implementado e validado.

Elas devem permanecer representativas e revisáveis, em vez de se tornarem um arquivo não controlado de todas as execuções de laboratório.

### 11.23 Evidências de Portfólio

Como o Atlas Engineering também serve como plataforma de portfólio, evidências selecionadas de validação podem ser preparadas para revisão pública.

As evidências públicas devem permanecer tecnicamente precisas, respeitando ao mesmo tempo os requisitos de segurança, privacidade, governança e qualidade do repositório.

As evidências públicas podem incluir:

- descrição do cenário;
- expectativa arquitetural;
- comandos ou configurações sanitizados;
- *logs* selecionados;
- métricas ou capturas de *dashboards*;
- consultas do estado resultante;
- resultado PASS ou FAIL;
- histórico de diagnóstico e correção;
- conclusão arquitetural.

Informações sensíveis não devem ser expostas apenas para que as evidências pareçam mais detalhadas.

### 11.24 Estado Atual da Validação

O projeto deve, preferencialmente, ser capaz de distinguir evidências históricas do estado atual de validação de uma responsabilidade arquitetural.

Uma responsabilidade pode estar atualmente:

- projetada, mas não implementada;
- implementada, mas não validada;
- validada;
- com validação falha;
- bloqueada;
- aguardando regressão;
- substituída por alteração arquitetural.

As evidências históricas explicam como o projeto chegou ao seu estado atual.

O estado atual da validação comunica o que o projeto pode afirmar no presente.

### 11.25 Histórico de Testes como Evidência de Engenharia

O histórico de testes é, por si só, um artefato de engenharia.

Uma sequência como:

**FAIL → diagnóstico → correção → FAIL → diagnóstico → correção → PASS**

pode fornecer evidências mais fortes de disciplina de engenharia do que um repositório contendo apenas capturas isoladas de execuções bem-sucedidas.

O histórico demonstra:

- expectativas explícitas;
- validação controlada;
- descoberta de defeitos;
- diagnóstico;
- ação corretiva;
- repetição dos testes;
- comportamento final demonstrado.

O propósito de preservar o histórico de testes não é celebrar falhas.

É preservar um registro preciso e revisável de como a confiança arquitetural foi estabelecida.

---

## 12. Limites Arquiteturais e Princípios de Encerramento

Testes e evidências são capacidades transversais de validação arquitetural da plataforma Atlas Engineering.

Eles fornecem os mecanismos disciplinados necessários para determinar se o comportamento implementado é consistente com as expectativas arquiteturais documentadas.

Os testes não criam as garantias arquiteturais que estão sendo avaliadas.

Eles exercitam essas garantias sob condições controladas e preservam evidências suficientes para sustentar conclusões sobre o comportamento que foi efetivamente demonstrado.

### 12.1 Limite de Processamento

**Fluxo e Processamento de Dados** define como os dados percorrem a plataforma, como as etapas de processamento se comportam e quais semânticas de processamento se aplicam através dos limites arquiteturais.

Os testes validam esses comportamentos implementados.

Eles podem determinar se:

- os dados esperados foram processados;
- o processamento seguiu o escopo pretendido;
- as transformações produziram o resultado esperado;
- o estado progrediu corretamente;
- dados inválidos foram tratados conforme definido;
- o processamento *downstream* recebeu a saída esperada.

Os testes não redefinem de forma independente a semântica de processamento quando o comportamento observado da implementação divergir da arquitetura.

Essa divergência deve ser investigada e resolvida explicitamente.

### 12.2 Limite de Confiabilidade e Recuperação

**Confiabilidade e Recuperação** define o modelo de falhas, o estado durável, os *checkpoints*, as novas tentativas, o *replay*, o reprocessamento, o *backfill*, o *rebuild*, a recuperação de *backlog*, os objetivos de recuperação e as garantias relacionadas.

Os testes exercitam e avaliam esses mecanismos.

Eles podem demonstrar se:

- as falhas são tratadas de acordo com o modelo definido;
- os *checkpoints* preservam a posição esperada de recuperação;
- as novas tentativas produzem o resultado pretendido;
- o *replay* respeita seu escopo definido;
- a recuperação restaura o processamento e o estado dos dados esperados;
- o *backlog* converge;
- os objetivos aplicáveis de RPO e RTO são satisfeitos sob as condições testadas.

Os testes não criam garantias de recuperação mais fortes do que aquelas definidas pela arquitetura de confiabilidade.

### 12.3 Limite de Segurança e Governança

**Segurança e Governança** define os controles da plataforma para identidade, acesso, segredos, informações sensíveis, privacidade, retenção, auditabilidade e responsabilidades relacionadas de governança.

Os testes validam os controles implementados quando eles puderem ser exercitados de forma significativa.

Eles podem demonstrar se:

- o acesso autorizado é bem-sucedido;
- o acesso não autorizado é negado;
- os limites de menor privilégio são aplicados;
- os segredos permanecem protegidos;
- informações sensíveis não são expostas desnecessariamente;
- evidências de auditoria são produzidas;
- o comportamento de retenção ou exclusão opera conforme definido.

Os testes não estabelecem de forma independente requisitos jurídicos, regulatórios, organizacionais ou corporativos de governança.

### 12.4 Limite de Observabilidade

**Observabilidade** define o modelo de evidências operacionais da plataforma.

Ela estabelece como processamento, falhas, recuperação, atualidade, *backlog*, certificação e outros comportamentos relevantes se tornam visíveis e diagnosticáveis.

Os testes utilizam essas evidências e validam se os próprios mecanismos de observabilidade se comportam conforme esperado.

As evidências de observabilidade podem sustentar uma conclusão de teste por meio de:

- *logs*;
- eventos operacionais;
- métricas;
- alertas;
- *dashboards*;
- estado de execução;
- evidências de recuperação;
- contexto de processamento correlacionado.

Os testes não tratam a telemetria de observabilidade como estado autoritativo quando a arquitetura definir outra fonte autoritativa para o comportamento que está sendo avaliado.

### 12.5 Limite de Qualidade de Dados e Certificação

As regras de qualidade de dados e os requisitos de certificação definem as condições sob as quais os dados satisfazem as expectativas estabelecidas pela plataforma e podem se tornar certificados para uso analítico.

Os testes validam a implementação desses controles.

Eles podem determinar se:

- dados válidos são aceitos;
- dados inválidos são rejeitados;
- as regras de qualidade produzem a decisão esperada;
- a certificação é bem-sucedida quando as condições obrigatórias são satisfeitas;
- a certificação falha quando as condições obrigatórias não são satisfeitas;
- dados não certificados permanecem distinguíveis de dados certificados.

Os testes não inventam regras de qualidade ou requisitos de certificação apenas para produzir um resultado de teste.

### 12.6 Limite de Requisitos

Os cenários de validação devem derivar suas expectativas de requisitos arquiteturais ou de implementação identificáveis.

Os testes podem revelar que um requisito é:

- ambíguo;
- incompleto;
- inconsistente;
- incorreto;
- não mais alinhado à arquitetura pretendida.

Quando isso ocorrer, o requisito pode precisar de esclarecimento ou revisão formal.

O resultado observado da implementação não deve se tornar silenciosamente o requisito apenas porque é assim que o sistema atual se comporta.

### 12.7 Limite de Implementação

Os testes avaliam o comportamento implementado.

Uma capacidade arquitetural documentada que ainda não tenha sido implementada não pode ser experimentalmente validada como funcional.

O projeto deve, portanto, preservar a distinção entre:

**comportamento projetado** — definido pela arquitetura;

**comportamento implementado** — presente na plataforma;

**comportamento validado** — demonstrado por meio de testes controlados e evidências suficientes.

Essa distinção se aplica tanto ao acompanhamento interno do projeto quanto às afirmações arquiteturais públicas.

### 12.8 Limite da Automação de Testes

A automação de testes é uma técnica de implementação para executar cenários, coletar evidências, comparar resultados e dar suporte à regressão.

A automação pode melhorar:

- repetibilidade;
- consistência;
- velocidade de execução;
- coleta de evidências;
- comparação;
- cobertura de regressão.

A automação não determina se um teste é arquiteturalmente significativo.

Um teste totalmente automatizado, sem expectativa arquitetural clara ou critérios de aceitação defensáveis, pode oferecer menos valor de validação do que um teste manual controlado com intenção explícita e evidências suficientes.

A estratégia define a semântica da validação.

A automação implementa essa semântica quando apropriado.

### 12.9 Limite de Ferramentas

A estratégia de testes e evidências não é definida por um *framework* específico de testes, linguagem de *script*, produto de monitoramento, plataforma de CI/CD ou repositório de evidências.

Diferentes responsabilidades de validação podem utilizar ferramentas diferentes.

As ferramentas podem evoluir à medida que a plataforma se desenvolve, desde que os requisitos arquiteturais de:

- repetibilidade;
- rastreabilidade;
- qualidade das evidências;
- critérios de aceitação;
- preservação histórica;
- revisabilidade;

permaneçam satisfeitos.

As ferramentas implementam a estratégia de testes.

Elas não a definem.

### 12.10 Limite entre Laboratório e Ambiente Corporativo

O Atlas Engineering é uma plataforma de laboratório e portfólio projetada para demonstrar princípios de engenharia orientados à produção.

A validação em laboratório deve fornecer evidências significativas para os comportamentos efetivamente implementados e testados.

Ela não precisa reproduzir todas as condições de um grande ambiente corporativo de produção.

A validação corporativa pode adicionalmente exigir:

- testes de carga em escala de produção;
- testes de falhas geograficamente distribuídas;
- exercícios formais de recuperação de desastre;
- integração com identidade corporativa;
- testes de penetração;
- avaliação independente de segurança;
- validação formal de conformidade;
- exercícios de incidentes em escala organizacional;
- testes de confiabilidade de longa duração;
- validação contratual de níveis de serviço;
- experimentação controlada em produção.

A ausência dessas capacidades corporativas não invalida as evidências de laboratório.

Ela limita o escopo das afirmações que as evidências de laboratório podem sustentar.

### 12.11 Limite das Evidências

As evidências sustentam uma conclusão de validação.

As evidências não se tornam uma garantia além do cenário, escopo, ambiente e condições sob os quais foram produzidas.

Um teste bem-sucedido demonstra comportamento observado sob as condições testadas.

Testes repetidos bem-sucedidos podem aumentar a confiança.

Testes de falha, testes de limite, testes de regressão e testes *end-to-end* podem aumentar ainda mais essa confiança.

Nenhum conjunto finito de evidências comprova que a plataforma nunca poderá falhar ou que todas as condições possíveis foram validadas.

### 12.12 Limite da Documentação

A documentação deve distinguir claramente entre comportamento pretendido, implementado e validado.

A documentação arquitetural pode descrever capacidades antes da implementação quando elas representarem projeto aprovado.

A documentação de implementação pode descrever capacidades que foram construídas.

A documentação de validação pode afirmar comportamento demonstrado somente quando existirem testes e evidências correspondentes.

Quando viável, afirmações públicas devem, preferencialmente, ser rastreáveis ao nível de evidência que as sustenta.

As evidências de teste não devem ser utilizadas para sugerir garantias mais amplas do que aquelas efetivamente demonstradas.

### 12.13 Retorno para a Arquitetura

Os testes não são apenas uma atividade de verificação.

Os resultados da validação podem fornecer retorno para a própria arquitetura.

Um teste pode revelar:

- uma suposição incorreta;
- um modo de falha não tratado;
- semântica de recuperação insuficiente;
- um limite de processamento ambíguo;
- observabilidade inadequada;
- privilégio excessivo;
- regras de qualidade incompletas;
- expectativas de performance não realistas;
- critérios de aceitação ausentes;
- uma responsabilidade arquitetural que não pode ser validada de forma significativa.

Quando as evidências revelarem uma fraqueza arquitetural, a resposta apropriada pode ser revisar a arquitetura, em vez de forçar a implementação ou o teste a preservar um projeto inadequado.

Alterações arquiteturais devem permanecer explícitas e revisáveis.

### 12.14 Princípios de Encerramento

A estratégia de testes e evidências do Atlas Engineering é regida pelos seguintes princípios de encerramento:

1. **Os testes validam o comportamento arquitetural; eles não substituem a arquitetura.**
2. **Todo teste relevante deve ter intenção explícita e comportamento esperado.**
3. **Os critérios de aceitação devem ser definidos antes da avaliação do resultado, quando viável.**
4. **Execução bem-sucedida não comprova, por si só, validação bem-sucedida.**
5. **O estado autoritativo deve ser verificado quando determinar o comportamento que está sendo testado.**
6. **O escopo de processamento deve permanecer identificável durante toda a validação.**
7. **Falha é evidência válida de engenharia e não deve ser ocultada.**
8. **A recuperação é validada pelo estado restaurado, e não apenas pela reinicialização ou conclusão de um *job*.**
9. **As evidências devem ser suficientes, correlacionadas, atribuíveis e revisáveis.**
10. **Evidências contraditórias devem ser investigadas, e não descartadas seletivamente.**
11. **Um novo teste não apaga o resultado que tornou esse novo teste necessário.**
12. **Evidências históricas de PASS podem exigir regressão após alterações materiais.**
13. **As evidências de teste permanecem sujeitas aos requisitos de segurança e governança.**
14. **As afirmações de validação devem permanecer proporcionais aos cenários e condições efetivamente testados.**
15. **Comportamentos projetados, implementados e validados devem permanecer distinguíveis.**
16. **Quantidade de testes não substitui cobertura arquitetural significativa.**
17. **Ferramentas e automação implementam a estratégia; elas não definem sua semântica.**
18. **Os testes podem revelar que a arquitetura, os requisitos, a implementação ou o próprio teste precisam mudar.**
19. **Evidências de laboratório demonstram comportamento validado em laboratório, e não garantias corporativas ilimitadas.**
20. **A confiança arquitetural é estabelecida por meio de expectativas explícitas, execução controlada, estado autoritativo, evidências suficientes e validação repetível.**

O objetivo dos testes no Atlas Engineering, portanto, não é simplesmente responder:

**"O teste foi executado com sucesso?"**

É fornecer evidências suficientes para responder:

**"A plataforma implementada se comportou de acordo com a expectativa arquitetural documentada, dentro do escopo e das condições testadas, e essa conclusão pode ser revisada e reproduzida de forma independente?"**

