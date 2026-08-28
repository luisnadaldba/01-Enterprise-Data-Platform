# Atlas Engineering — Segurança e Governança

## Índice

[1. Propósito](#1-propósito)

[2. Contexto de Segurança e Governança](#2-contexto-de-segurança-e-governança)

[3. Princípios de Segurança](#3-princípios-de-segurança)
    - [3.1 Segurança por Design](#31-segurança-por-design)
    - [3.2 Negar por Padrão](#32-negar-por-padrão)
    - [3.3 Privilégio Mínimo](#33-privilégio-mínimo)
    - [3.4 Separação de Responsabilidades](#34-separação-de-responsabilidades)
    - [3.5 Limites de Confiança Explícitos](#35-limites-de-confiança-explícitos)
    - [3.6 Defesa em Profundidade](#36-defesa-em-profundidade)
    - [3.7 Minimização de Dados](#37-minimização-de-dados)
    - [3.8 Acesso Limitado ao Propósito](#38-acesso-limitado-ao-propósito)
    - [3.9 Tratamento Seguro de Credenciais](#39-tratamento-seguro-de-credenciais)
    - [3.10 Criptografia de Acordo com o Risco e o Limite](#310-criptografia-de-acordo-com-o-risco-e-o-limite)
    - [3.11 Ações de Segurança Auditáveis](#311-ações-de-segurança-auditáveis)
    - [3.12 Falha e Recuperação Seguras](#312-falha-e-recuperação-seguras)
    - [3.13 Os Controles de Segurança Devem Ser Testáveis](#313-os-controles-de-segurança-devem-ser-testáveis)
    - [3.14 As Afirmações de Segurança Devem Corresponder às Evidências](#314-as-afirmações-de-segurança-devem-corresponder-às-evidências)
    - [3.15 A Segurança Deve Evoluir sem Romper os Limites Arquiteturais](#315-a-segurança-deve-evoluir-sem-romper-os-limites-arquiteturais)

[4. Gerenciamento de Identidades e Acessos](#4-gerenciamento-de-identidades-e-acessos)
    - [4.1 Tipos de Identidade](#41-tipos-de-identidade)
    - [4.2 Identidades Humanas](#42-identidades-humanas)
    - [4.3 Identidades de Serviço](#43-identidades-de-serviço)
    - [4.4 Separação de Identidades de Serviço](#44-separação-de-identidades-de-serviço)
    - [4.5 Identidades Administrativas](#45-identidades-administrativas)
    - [4.6 Contas Compartilhadas](#46-contas-compartilhadas)
    - [4.7 Acesso Baseado em Funções](#47-acesso-baseado-em-funções)
    - [4.8 Escopo de Acesso](#48-escopo-de-acesso)
    - [4.9 Limites de Acesso Baseados em Camadas](#49-limites-de-acesso-baseados-em-camadas)
    - [4.10 Ciclo de Vida do Acesso](#410-ciclo-de-vida-do-acesso)
    - [4.11 Revisão de Acesso](#411-revisão-de-acesso)
    - [4.12 Elevação de Privilégios](#412-elevação-de-privilégios)
    - [4.13 Falha de Autenticação e Negação de Acesso](#413-falha-de-autenticação-e-negação-de-acesso)
    - [4.14 Metadados de Identidade e Acesso](#414-metadados-de-identidade-e-acesso)
    - [4.15 Modelo de Identidade do Laboratório](#415-modelo-de-identidade-do-laboratório)
    - [4.16 Evolução para o Ambiente Corporativo](#416-evolução-para-o-ambiente-corporativo)
    - [4.17 Garantias de Identidade e Acesso](#417-garantias-de-identidade-e-acesso)

[5. Autenticação e Autorização](#5-autenticação-e-autorização)
    - [5.1 Autenticação](#51-autenticação)
    - [5.2 Autenticação Humana](#52-autenticação-humana)
    - [5.3 Autenticação de Serviço](#53-autenticação-de-serviço)
    - [5.4 Autenticação entre Limites de Serviço](#54-autenticação-entre-limites-de-serviço)
    - [5.5 Autorização](#55-autorização)
    - [5.6 Autenticação Não Implica Autorização](#56-autenticação-não-implica-autorização)
    - [5.7 Autorização no Nível do Recurso](#57-autorização-no-nível-do-recurso)
    - [5.8 Separação entre Leitura e Gravação](#58-separação-entre-leitura-e-gravação)
    - [5.9 Autorização Administrativa](#59-autorização-administrativa)
    - [5.10 Autorização no Limite da Certified Gold](#510-autorização-no-limite-da-certified-gold)
    - [5.11 Autorização e Dados Sensíveis](#511-autorização-e-dados-sensíveis)
    - [5.12 Falhas de Autenticação e Autorização](#512-falhas-de-autenticação-e-autorização)
    - [5.13 Rotação de Credenciais e Continuidade da Autenticação](#513-rotação-de-credenciais-e-continuidade-da-autenticação)
    - [5.14 Revogação](#514-revogação)
    - [5.15 Testes de Autenticação e Autorização](#515-testes-de-autenticação-e-autorização)
    - [5.16 Evidências de Autenticação e Autorização](#516-evidências-de-autenticação-e-autorização)
    - [5.17 Autenticação no Laboratório e no Ambiente Corporativo](#517-autenticação-no-laboratório-e-no-ambiente-corporativo)
    - [5.18 Garantias de Autenticação e Autorização](#518-garantias-de-autenticação-e-autorização)

[6. Gerenciamento de Segredos e Credenciais](#6-gerenciamento-de-segredos-e-credenciais)
    - [6.1 Classificação de Segredos](#61-classificação-de-segredos)
    - [6.2 Segredos Não Devem Ser Commitados](#62-segredos-não-devem-ser-commitados)
    - [6.3 Referências a Segredos](#63-referências-a-segredos)
    - [6.4 Variáveis de Ambiente](#64-variáveis-de-ambiente)
    - [6.5 Armazenamento de Segredos](#65-armazenamento-de-segredos)
    - [6.6 Credenciais Específicas por Serviço](#66-credenciais-específicas-por-serviço)
    - [6.7 Escopo das Credenciais](#67-escopo-das-credenciais)
    - [6.8 Rotação de Credenciais](#68-rotação-de-credenciais)
    - [6.9 Revogação de Credenciais](#69-revogação-de-credenciais)
    - [6.10 Exposição de Segredos](#610-exposição-de-segredos)
    - [6.11 Exposição no Controle de Versão](#611-exposição-no-controle-de-versão)
    - [6.12 Segredos em Logs e Observabilidade](#612-segredos-em-logs-e-observabilidade)
    - [6.13 Segredos em Evidências](#613-segredos-em-evidências)
    - [6.14 Segredos em Documentação e Exemplos](#614-segredos-em-documentação-e-exemplos)
    - [6.15 Backup e Recuperação de Segredos](#615-backup-e-recuperação-de-segredos)
    - [6.16 Recuperação de Segredos e Confiança Invalidada](#616-recuperação-de-segredos-e-confiança-invalidada)
    - [6.17 Responsabilidade por Segredos](#617-responsabilidade-por-segredos)
    - [6.18 Inventário e Metadados de Segredos](#618-inventário-e-metadados-de-segredos)
    - [6.19 Ciclo de Vida dos Segredos](#619-ciclo-de-vida-dos-segredos)
    - [6.20 Gerenciamento de Segredos no Laboratório](#620-gerenciamento-de-segredos-no-laboratório)
    - [6.21 Evolução para o Ambiente Corporativo](#621-evolução-para-o-ambiente-corporativo)
    - [6.22 Varredura de Segredos](#622-varredura-de-segredos)
    - [6.23 Testes de Segredos e Credenciais](#623-testes-de-segredos-e-credenciais)
    - [6.24 Evidências de Segredos e Credenciais](#624-evidências-de-segredos-e-credenciais)
    - [6.25 Garantias de Segredos e Credenciais](#625-garantias-de-segredos-e-credenciais)

[7. Segurança de Rede e Comunicação entre Serviços](#7-segurança-de-rede-e-comunicação-entre-serviços)
    - [7.1 Exposição de Rede](#71-exposição-de-rede)
    - [7.2 Caminhos de Comunicação entre Serviços](#72-caminhos-de-comunicação-entre-serviços)
    - [7.3 Limites de Confiança Explícitos](#73-limites-de-confiança-explícitos)
    - [7.4 Segmentação de Rede](#74-segmentação-de-rede)
    - [7.5 Comunicação East-West e North-South](#75-comunicação-east-west-e-north-south)
    - [7.6 Exposição Pública](#76-exposição-pública)
    - [7.7 Interfaces Administrativas](#77-interfaces-administrativas)
    - [7.8 Criptografia em Trânsito](#78-criptografia-em-trânsito)
    - [7.9 TLS e Confiança em Certificados](#79-tls-e-confiança-em-certificados)
    - [7.10 Autenticação Mútua](#710-autenticação-mútua)
    - [7.11 Proteção de Credenciais Durante o Transporte](#711-proteção-de-credenciais-durante-o-transporte)
    - [7.12 DNS, Hostnames e Configuração de Endpoints](#712-dns-hostnames-e-configuração-de-endpoints)
    - [7.13 Comunicação da Orquestração](#713-comunicação-da-orquestração)
    - [7.14 Comunicação da Observabilidade](#714-comunicação-da-observabilidade)
    - [7.15 Comunicação de Consumidores Analíticos](#715-comunicação-de-consumidores-analíticos)
    - [7.16 Comportamento em Falhas de Rede](#716-comportamento-em-falhas-de-rede)
    - [7.17 Observabilidade de Rede e Comunicação](#717-observabilidade-de-rede-e-comunicação)
    - [7.18 Inventário de Comunicação](#718-inventário-de-comunicação)
    - [7.19 Governança de Alterações de Rede](#719-governança-de-alterações-de-rede)
    - [7.20 Modelo de Rede do Laboratório](#720-modelo-de-rede-do-laboratório)
    - [7.21 Evolução para o Ambiente Corporativo](#721-evolução-para-o-ambiente-corporativo)
    - [7.22 Testes de Rede e Comunicação](#722-testes-de-rede-e-comunicação)
    - [7.23 Evidências de Rede e Comunicação](#723-evidências-de-rede-e-comunicação)
    - [7.24 Garantias de Rede e Comunicação entre Serviços](#724-garantias-de-rede-e-comunicação-entre-serviços)

[8. Proteção de Dados e Criptografia](#8-proteção-de-dados-e-criptografia)
    - [8.1 Escopo da Proteção de Dados](#81-escopo-da-proteção-de-dados)
    - [8.2 Proteção de Acordo com a Classificação dos Dados](#82-proteção-de-acordo-com-a-classificação-dos-dados)
    - [8.3 Criptografia em Trânsito](#83-criptografia-em-trânsito)
    - [8.4 Criptografia em Repouso](#84-criptografia-em-repouso)
    - [8.5 Criptografia Não Substitui Autorização](#85-criptografia-não-substitui-autorização)
    - [8.6 Criptografia Não Substitui Minimização de Dados](#86-criptografia-não-substitui-minimização-de-dados)
    - [8.7 Proteção dos Dados da Origem](#87-proteção-dos-dados-da-origem)
    - [8.8 Proteção de Eventos e Dados do Kafka](#88-proteção-de-eventos-e-dados-do-kafka)
    - [8.9 Proteção dos Dados da Bronze](#89-proteção-dos-dados-da-bronze)
    - [8.10 Proteção dos Dados da Silver](#810-proteção-dos-dados-da-silver)
    - [8.11 Proteção dos Dados da Gold](#811-proteção-dos-dados-da-gold)
    - [8.12 Proteção da Certified Gold](#812-proteção-da-certified-gold)
    - [8.13 Dados Temporários](#813-dados-temporários)
    - [8.14 Dados em Quarentena](#814-dados-em-quarentena)
    - [8.15 Proteção de Backups](#815-proteção-de-backups)
    - [8.16 Gerenciamento de Chaves de Criptografia](#816-gerenciamento-de-chaves-de-criptografia)
    - [8.17 Rotação de Chaves](#817-rotação-de-chaves)
    - [8.18 Recuperação de Chaves](#818-recuperação-de-chaves)
    - [8.19 Comprometimento de Chaves](#819-comprometimento-de-chaves)
    - [8.20 Logs e Dados Sensíveis](#820-logs-e-dados-sensíveis)
    - [8.21 Métricas e Dados Sensíveis](#821-métricas-e-dados-sensíveis)
    - [8.22 Evidências e Dados Sensíveis](#822-evidências-e-dados-sensíveis)
    - [8.23 Dados de Ambientes Não Produtivos](#823-dados-de-ambientes-não-produtivos)
    - [8.24 Exportação de Dados](#824-exportação-de-dados)
    - [8.25 Proteção de Dados Durante a Recuperação](#825-proteção-de-dados-durante-a-recuperação)
    - [8.26 Proteção de Dados e Retenção](#826-proteção-de-dados-e-retenção)
    - [8.27 Descarte Seguro](#827-descarte-seguro)
    - [8.28 Proteção de Dados no Laboratório](#828-proteção-de-dados-no-laboratório)
    - [8.29 Evolução para o Ambiente Corporativo](#829-evolução-para-o-ambiente-corporativo)
    - [8.30 Testes de Proteção de Dados](#830-testes-de-proteção-de-dados)
    - [8.31 Evidências de Proteção de Dados](#831-evidências-de-proteção-de-dados)
    - [8.32 Garantias de Proteção de Dados e Criptografia](#832-garantias-de-proteção-de-dados-e-criptografia)

[9. Classificação de Dados e Dados Sensíveis](#9-classificação-de-dados-e-dados-sensíveis)
    - [9.1 Modelo de Classificação](#91-modelo-de-classificação)
    - [9.2 Dados Públicos](#92-dados-públicos)
    - [9.3 Dados Internos](#93-dados-internos)
    - [9.4 Dados Confidenciais](#94-dados-confidenciais)
    - [9.5 Dados Restritos](#95-dados-restritos)
    - [9.6 A Classificação É Independente da Camada Arquitetural](#96-a-classificação-é-independente-da-camada-arquitetural)
    - [9.7 Herança de Classificação](#97-herança-de-classificação)
    - [9.8 Dados Pessoais](#98-dados-pessoais)
    - [9.9 Dados Pessoais Sensíveis](#99-dados-pessoais-sensíveis)
    - [9.10 Dados Sensíveis de Negócio](#910-dados-sensíveis-de-negócio)
    - [9.11 Dados Sensíveis à Segurança](#911-dados-sensíveis-à-segurança)
    - [9.12 Metadados de Classificação de Dados](#912-metadados-de-classificação-de-dados)
    - [9.13 Classificação no Nível de Atributo](#913-classificação-no-nível-de-atributo)
    - [9.14 Classificação e Minimização de Dados](#914-classificação-e-minimização-de-dados)
    - [9.15 Classificação ao Longo do Fluxo de Dados](#915-classificação-ao-longo-do-fluxo-de-dados)
    - [9.16 Classificação da Bronze](#916-classificação-da-bronze)
    - [9.17 Classificação da Silver](#917-classificação-da-silver)
    - [9.18 Classificação da Gold](#918-classificação-da-gold)
    - [9.19 Classificação da Certified Gold](#919-classificação-da-certified-gold)
    - [9.20 Classificação e Observabilidade](#920-classificação-e-observabilidade)
    - [9.21 Classificação e Evidências](#921-classificação-e-evidências)
    - [9.22 Classificação e Consumo Analítico](#922-classificação-e-consumo-analítico)
    - [9.23 Classificação e Exportação](#923-classificação-e-exportação)
    - [9.24 Classificação e Retenção](#924-classificação-e-retenção)
    - [9.25 Revisão da Classificação](#925-revisão-da-classificação)
    - [9.26 Responsabilidade pela Classificação](#926-responsabilidade-pela-classificação)
    - [9.27 Classificação Desconhecida](#927-classificação-desconhecida)
    - [9.28 Alterações de Classificação](#928-alterações-de-classificação)
    - [9.29 Modelo de Classificação do Laboratório](#929-modelo-de-classificação-do-laboratório)
    - [9.30 Evolução para o Ambiente Corporativo](#930-evolução-para-o-ambiente-corporativo)
    - [9.31 Testes de Classificação](#931-testes-de-classificação)
    - [9.32 Evidências de Classificação](#932-evidências-de-classificação)
    - [9.33 Garantias de Classificação de Dados e Dados Sensíveis](#933-garantias-de-classificação-de-dados-e-dados-sensíveis)

[10. LGPD e Governança de Privacidade](#10-lgpd-e-governança-de-privacidade)
    - [10.1 Identificação de Dados Pessoais](#101-identificação-de-dados-pessoais)
    - [10.2 Dados Pessoais Sensíveis](#102-dados-pessoais-sensíveis)
    - [10.3 Propósito do Processamento](#103-propósito-do-processamento)
    - [10.4 Limitação de Propósito](#104-limitação-de-propósito)
    - [10.5 Minimização de Dados](#105-minimização-de-dados)
    - [10.6 Privacidade ao Longo do Pipeline de Dados](#106-privacidade-ao-longo-do-pipeline-de-dados)
    - [10.7 Limite de Privacidade da Origem](#107-limite-de-privacidade-da-origem)
    - [10.8 Privacidade no Kafka e nos Eventos](#108-privacidade-no-kafka-e-nos-eventos)
    - [10.9 Privacidade na Bronze](#109-privacidade-na-bronze)
    - [10.10 Privacidade na Silver](#1010-privacidade-na-silver)
    - [10.11 Privacidade na Gold](#1011-privacidade-na-gold)
    - [10.12 Privacidade na Certified Gold](#1012-privacidade-na-certified-gold)
    - [10.13 Identificadores Diretos e Indiretos](#1013-identificadores-diretos-e-indiretos)
    - [10.14 Pseudonimização](#1014-pseudonimização)
    - [10.15 Anonimização](#1015-anonimização)
    - [10.16 Mascaramento](#1016-mascaramento)
    - [10.17 Privacidade e Controle de Acesso](#1017-privacidade-e-controle-de-acesso)
    - [10.18 Privacidade e Observabilidade](#1018-privacidade-e-observabilidade)
    - [10.19 Privacidade e Linhagem](#1019-privacidade-e-linhagem)
    - [10.20 Privacidade e Metadados](#1020-privacidade-e-metadados)
    - [10.21 Exatidão e Correção dos Dados](#1021-exatidão-e-correção-dos-dados)
    - [10.22 Solicitações dos Titulares dos Dados](#1022-solicitações-dos-titulares-dos-dados)
    - [10.23 Exclusão e Apagamento](#1023-exclusão-e-apagamento)
    - [10.24 Exclusão versus Integridade Histórica](#1024-exclusão-versus-integridade-histórica)
    - [10.25 Privacidade e Backups](#1025-privacidade-e-backups)
    - [10.26 Privacidade e Replay](#1026-privacidade-e-replay)
    - [10.27 Privacidade e Retenção de Dados](#1027-privacidade-e-retenção-de-dados)
    - [10.28 Privacidade e Exportação de Dados](#1028-privacidade-e-exportação-de-dados)
    - [10.29 Considerações sobre Incidentes de Privacidade](#1029-considerações-sobre-incidentes-de-privacidade)
    - [10.30 Privacidade por Design](#1030-privacidade-por-design)
    - [10.31 Governança de Privacidade para Novos Produtos de Dados](#1031-governança-de-privacidade-para-novos-produtos-de-dados)
    - [10.32 Modelo de Privacidade do Laboratório](#1032-modelo-de-privacidade-do-laboratório)
    - [10.33 Evolução para o Ambiente Corporativo](#1033-evolução-para-o-ambiente-corporativo)
    - [10.34 Testes de Privacidade](#1034-testes-de-privacidade)
    - [10.35 Evidências de Privacidade](#1035-evidências-de-privacidade)
    - [10.36 Garantias de LGPD e Governança de Privacidade](#1036-garantias-de-lgpd-e-governança-de-privacidade)

[11. Acesso aos Dados por Camada Arquitetural](#11-acesso-aos-dados-por-camada-arquitetural)
    - [11.1 Acesso à Origem Operacional](#111-acesso-à-origem-operacional)
    - [11.2 Acesso ao CDC](#112-acesso-ao-cdc)
    - [11.3 Acesso do Debezium](#113-acesso-do-debezium)
    - [11.4 Acesso dos Produtores Kafka](#114-acesso-dos-produtores-kafka)
    - [11.5 Acesso dos Consumidores Kafka](#115-acesso-dos-consumidores-kafka)
    - [11.6 Acesso Administrativo ao Kafka](#116-acesso-administrativo-ao-kafka)
    - [11.7 Acesso à Bronze](#117-acesso-à-bronze)
    - [11.8 Acesso de Gravação à Bronze](#118-acesso-de-gravação-à-bronze)
    - [11.9 Acesso à Silver](#119-acesso-à-silver)
    - [11.10 Acesso de Gravação à Silver](#1110-acesso-de-gravação-à-silver)
    - [11.11 Acesso à Gold](#1111-acesso-à-gold)
    - [11.12 Acesso às Candidatas da Gold](#1112-acesso-às-candidatas-da-gold)
    - [11.13 Acesso à Certified Gold](#1113-acesso-à-certified-gold)
    - [11.14 Acesso de Gravação e Publicação na Certified Gold](#1114-acesso-de-gravação-e-publicação-na-certified-gold)
    - [11.15 Acesso do Power BI](#1115-acesso-do-power-bi)
    - [11.16 Acesso do Airflow](#1116-acesso-do-airflow)
    - [11.17 Acesso à Observabilidade](#1117-acesso-à-observabilidade)
    - [11.18 Acesso a Metadados e Linhagem](#1118-acesso-a-metadados-e-linhagem)
    - [11.19 Acesso à Quarentena](#1119-acesso-à-quarentena)
    - [11.20 Acesso aos Backups](#1120-acesso-aos-backups)
    - [11.21 Acesso às Evidências](#1121-acesso-às-evidências)
    - [11.22 Acesso entre Camadas](#1122-acesso-entre-camadas)
    - [11.23 Acesso Durante Replay e Recuperação](#1123-acesso-durante-replay-e-recuperação)
    - [11.24 Acesso Durante Investigação](#1124-acesso-durante-investigação)
    - [11.25 Separação de Ambientes](#1125-separação-de-ambientes)
    - [11.26 Matriz de Acesso](#1126-matriz-de-acesso)
    - [11.27 Validação da Matriz de Acesso](#1127-validação-da-matriz-de-acesso)
    - [11.28 Access Drift](#1128-access-drift)
    - [11.29 Alterações nos Limites de Acesso](#1129-alterações-nos-limites-de-acesso)
    - [11.30 Modelo de Acesso do Laboratório](#1130-modelo-de-acesso-do-laboratório)
    - [11.31 Evolução para o Ambiente Corporativo](#1131-evolução-para-o-ambiente-corporativo)
    - [11.32 Testes de Acesso às Camadas](#1132-testes-de-acesso-às-camadas)
    - [11.33 Evidências de Acesso às Camadas](#1133-evidências-de-acesso-às-camadas)
    - [11.34 Garantias de Acesso aos Dados por Camada Arquitetural](#1134-garantias-de-acesso-aos-dados-por-camada-arquitetural)

[12. Governança de Schemas, Contratos e Metadados](#12-governança-de-schemas-contratos-e-metadados)
    - [12.1 Definições Governadas](#121-definições-governadas)
    - [12.2 Governança do Schema da Origem](#122-governança-do-schema-da-origem)
    - [12.3 Governança de Contratos de Eventos](#123-governança-de-contratos-de-eventos)
    - [12.4 Responsabilidade pelos Contratos](#124-responsabilidade-pelos-contratos)
    - [12.5 Versionamento de Contratos](#125-versionamento-de-contratos)
    - [12.6 Governança de Compatibilidade](#126-governança-de-compatibilidade)
    - [12.7 Governança de Alterações Incompatíveis](#127-governança-de-alterações-incompatíveis)
    - [12.8 Governança das Definições de Processamento](#128-governança-das-definições-de-processamento)
    - [12.9 Versão de Processamento da Silver](#129-versão-de-processamento-da-silver)
    - [12.10 Versão de Processamento da Gold](#1210-versão-de-processamento-da-gold)
    - [12.11 Governança das Regras de Qualidade](#1211-governança-das-regras-de-qualidade)
    - [12.12 Governança das Regras de Reconciliação](#1212-governança-das-regras-de-reconciliação)
    - [12.13 Governança da Certificação](#1213-governança-da-certificação)
    - [12.14 Governança do Contrato de Consumo Analítico](#1214-governança-do-contrato-de-consumo-analítico)
    - [12.15 Governança de Metadados](#1215-governança-de-metadados)
    - [12.16 Metadados Técnicos](#1216-metadados-técnicos)
    - [12.17 Metadados de Negócio](#1217-metadados-de-negócio)
    - [12.18 Metadados de Governança e Metadados de Segurança](#1218-metadados-de-governança-e-metadados-de-segurança)
    - [12.19 Responsabilidade pelos Metadados](#1219-responsabilidade-pelos-metadados)
    - [12.20 Governança da Linhagem](#1220-governança-da-linhagem)
    - [12.21 Relações entre Versões](#1221-relações-entre-versões)
    - [12.22 Análise de Impacto das Alterações](#1222-análise-de-impacto-das-alterações)
    - [12.23 Aprovação de Alterações](#1223-aprovação-de-alterações)
    - [12.24 Architecture Decision Records](#1224-architecture-decision-records)
    - [12.25 Consistência da Documentação](#1225-consistência-da-documentação)
    - [12.26 Metadata Drift](#1226-metadata-drift)
    - [12.27 Contract Drift](#1227-contract-drift)
    - [12.28 Quality Rule Drift](#1228-quality-rule-drift)
    - [12.29 Certified Product Drift](#1229-certified-product-drift)
    - [12.30 Governança do Ciclo de Vida](#1230-governança-do-ciclo-de-vida)
    - [12.31 Descontinuação](#1231-descontinuação)
    - [12.32 Remoção](#1232-remoção)
    - [12.33 Governança Durante a Recuperação](#1233-governança-durante-a-recuperação)
    - [12.34 Governança Durante a Experimentação](#1234-governança-durante-a-experimentação)
    - [12.35 Estrutura do Repositório de Governança](#1235-estrutura-do-repositório-de-governança)
    - [12.36 Artefatos de Governança Públicos e Privados](#1236-artefatos-de-governança-públicos-e-privados)
    - [12.37 Testes de Governança](#1237-testes-de-governança)
    - [12.38 Evidências de Governança](#1238-evidências-de-governança)
    - [12.39 Garantias de Governança de Schemas, Contratos e Metadados](#1239-garantias-de-governança-de-schemas-contratos-e-metadados)

[13. Retenção, Arquivamento e Descarte](#13-retenção-arquivamento-e-descarte)
    - [13.1 Princípios de Retenção](#131-princípios-de-retenção)
    - [13.2 Retenção por Camada Arquitetural](#132-retenção-por-camada-arquitetural)
    - [13.3 Retenção do Kafka](#133-retenção-do-kafka)
    - [13.4 Retenção do CDC](#134-retenção-do-cdc)
    - [13.5 Retenção da Bronze](#135-retenção-da-bronze)
    - [13.6 Retenção da Silver](#136-retenção-da-silver)
    - [13.7 Retenção da Gold](#137-retenção-da-gold)
    - [13.8 Retenção da Certified Gold](#138-retenção-da-certified-gold)
    - [13.9 Retenção de Dados Candidatos](#139-retenção-de-dados-candidatos)
    - [13.10 Retenção da Quarentena](#1310-retenção-da-quarentena)
    - [13.11 Retenção de Artefatos Temporários](#1311-retenção-de-artefatos-temporários)
    - [13.12 Retenção de Logs](#1312-retenção-de-logs)
    - [13.13 Retenção de Métricas](#1313-retenção-de-métricas)
    - [13.14 Retenção da Linhagem](#1314-retenção-da-linhagem)
    - [13.15 Retenção de Metadados](#1315-retenção-de-metadados)
    - [13.16 Retenção de Versões de Contratos](#1316-retenção-de-versões-de-contratos)
    - [13.17 Retenção de Versões de Processamento](#1317-retenção-de-versões-de-processamento)
    - [13.18 Retenção de Evidências](#1318-retenção-de-evidências)
    - [13.19 Retenção da Auditoria de Segurança](#1319-retenção-da-auditoria-de-segurança)
    - [13.20 Retenção de Backups](#1320-retenção-de-backups)
    - [13.21 Arquivamento](#1321-arquivamento)
    - [13.22 Dados Online versus Dados Arquivados](#1322-dados-online-versus-dados-arquivados)
    - [13.23 Arquivamento e Replay](#1323-arquivamento-e-replay)
    - [13.24 Arquivamento e Criptografia](#1324-arquivamento-e-criptografia)
    - [13.25 Retenção e Privacidade](#1325-retenção-e-privacidade)
    - [13.26 Retenção e Solicitações dos Titulares dos Dados](#1326-retenção-e-solicitações-dos-titulares-dos-dados)
    - [13.27 Retenção e Risco de Replay](#1327-retenção-e-risco-de-replay)
    - [13.28 Retenção e Certificação](#1328-retenção-e-certificação)
    - [13.29 Descarte](#1329-descarte)
    - [13.30 Exclusão Lógica](#1330-exclusão-lógica)
    - [13.31 Descarte Físico](#1331-descarte-físico)
    - [13.32 Descarte Criptográfico](#1332-descarte-criptográfico)
    - [13.33 Descarte e Backups](#1333-descarte-e-backups)
    - [13.34 Descarte e Replay](#1334-descarte-e-replay)
    - [13.35 Metadados da Política de Retenção](#1335-metadados-da-política-de-retenção)
    - [13.36 Responsabilidade pela Retenção](#1336-responsabilidade-pela-retenção)
    - [13.37 Revisão da Retenção](#1337-revisão-da-retenção)
    - [13.38 Retention Drift](#1338-retention-drift)
    - [13.39 Modelo de Retenção do Laboratório](#1339-modelo-de-retenção-do-laboratório)
    - [13.40 Evolução para o Ambiente Corporativo](#1340-evolução-para-o-ambiente-corporativo)
    - [13.41 Testes de Retenção e Descarte](#1341-testes-de-retenção-e-descarte)
    - [13.42 Evidências de Retenção e Descarte](#1342-evidências-de-retenção-e-descarte)
    - [13.43 Garantias de Retenção, Arquivamento e Descarte](#1343-garantias-de-retenção-arquivamento-e-descarte)

[14. Auditabilidade e Observabilidade de Segurança](#14-auditabilidade-e-observabilidade-de-segurança)
    - [14.1 Auditabilidade](#141-auditabilidade)
    - [14.2 Observabilidade de Segurança](#142-observabilidade-de-segurança)
    - [14.3 Atribuição de Identidade](#143-atribuição-de-identidade)
    - [14.4 Atribuição de Serviços](#144-atribuição-de-serviços)
    - [14.5 Eventos de Autenticação](#145-eventos-de-autenticação)
    - [14.6 Eventos de Autorização](#146-eventos-de-autorização)
    - [14.7 Alterações de Privilégios](#147-alterações-de-privilégios)
    - [14.8 Operações Administrativas](#148-operações-administrativas)
    - [14.9 Alterações de Configuração de Segurança](#149-alterações-de-configuração-de-segurança)
    - [14.10 Acesso a Recursos Sensíveis](#1410-acesso-a-recursos-sensíveis)
    - [14.11 Auditabilidade da Certified Gold e da Publicação](#1411-auditabilidade-da-certified-gold-e-da-publicação)
    - [14.12 Classificação dos Dados de Auditoria de Segurança](#1412-classificação-dos-dados-de-auditoria-de-segurança)
    - [14.13 Segredos Não Devem Ser Auditados como Valores](#1413-segredos-não-devem-ser-auditados-como-valores)
    - [14.14 Dados Pessoais em Logs de Segurança](#1414-dados-pessoais-em-logs-de-segurança)
    - [14.15 Logging Estruturado de Segurança](#1415-logging-estruturado-de-segurança)
    - [14.16 Correlação entre Componentes](#1416-correlação-entre-componentes)
    - [14.17 Consistência Temporal](#1417-consistência-temporal)
    - [14.18 Integridade da Auditoria](#1418-integridade-da-auditoria)
    - [14.19 Disponibilidade da Auditoria](#1419-disponibilidade-da-auditoria)
    - [14.20 Métricas de Segurança](#1420-métricas-de-segurança)
    - [14.21 Dashboards de Segurança](#1421-dashboards-de-segurança)
    - [14.22 Alertas de Segurança](#1422-alertas-de-segurança)
    - [14.23 Linha de Base do Comportamento de Segurança](#1423-linha-de-base-do-comportamento-de-segurança)
    - [14.24 Trilha de Auditoria para Alterações de Acesso](#1424-trilha-de-auditoria-para-alterações-de-acesso)
    - [14.25 Trilha de Auditoria para o Ciclo de Vida das Credenciais](#1425-trilha-de-auditoria-para-o-ciclo-de-vida-das-credenciais)
    - [14.26 Trilha de Auditoria para Recuperação](#1426-trilha-de-auditoria-para-recuperação)
    - [14.27 Investigação de Segurança](#1427-investigação-de-segurança)
    - [14.28 Evidências de Incidentes de Segurança](#1428-evidências-de-incidentes-de-segurança)
    - [14.29 Evidências Negativas de Segurança](#1429-evidências-negativas-de-segurança)
    - [14.30 Observabilidade de Segurança Durante Falhas](#1430-observabilidade-de-segurança-durante-falhas)
    - [14.31 Auditabilidade e Privacidade](#1431-auditabilidade-e-privacidade)
    - [14.32 Auditabilidade e Retenção](#1432-auditabilidade-e-retenção)
    - [14.33 Observabilidade de Segurança do Laboratório](#1433-observabilidade-de-segurança-do-laboratório)
    - [14.34 Evolução para o Ambiente Corporativo](#1434-evolução-para-o-ambiente-corporativo)
    - [14.35 Testes de Auditabilidade](#1435-testes-de-auditabilidade)
    - [14.36 Evidências de Auditabilidade](#1436-evidências-de-auditabilidade)
    - [14.37 Garantias de Auditabilidade e Observabilidade de Segurança](#1437-garantias-de-auditabilidade-e-observabilidade-de-segurança)

[15. Considerações sobre Incidentes de Segurança e Recuperação](#15-considerações-sobre-incidentes-de-segurança-e-recuperação)
    - [15.1 Classificação de Incidentes de Segurança](#151-classificação-de-incidentes-de-segurança)
    - [15.2 Detecção](#152-detecção)
    - [15.3 Avaliação Inicial](#153-avaliação-inicial)
    - [15.4 Contenção](#154-contenção)
    - [15.5 Comprometimento de Credenciais](#155-comprometimento-de-credenciais)
    - [15.6 Exposição de Segredos](#156-exposição-de-segredos)
    - [15.7 Acesso Não Autorizado](#157-acesso-não-autorizado)
    - [15.8 Privilégio Excessivo](#158-privilégio-excessivo)
    - [15.9 Comprometimento de Identidade de Serviço](#159-comprometimento-de-identidade-de-serviço)
    - [15.10 Incidente de Confidencialidade dos Dados](#1510-incidente-de-confidencialidade-dos-dados)
    - [15.11 Incidente de Integridade dos Dados](#1511-incidente-de-integridade-dos-dados)
    - [15.12 Recuperação de Integridade](#1512-recuperação-de-integridade)
    - [15.13 Incidente de Segurança na Certified Gold](#1513-incidente-de-segurança-na-certified-gold)
    - [15.14 Último Estado Reconhecidamente Confiável](#1514-último-estado-reconhecidamente-confiável)
    - [15.15 Recuperação de Segurança e Backup](#1515-recuperação-de-segurança-e-backup)
    - [15.16 A Recuperação Não Deve Restaurar Confiança Invalidada](#1516-a-recuperação-não-deve-restaurar-confiança-invalidada)
    - [15.17 Recuperação e Acesso Privilegiado](#1517-recuperação-e-acesso-privilegiado)
    - [15.18 Acesso Break-Glass](#1518-acesso-break-glass)
    - [15.19 Preservação de Evidências](#1519-preservação-de-evidências)
    - [15.20 Integridade das Evidências](#1520-integridade-das-evidências)
    - [15.21 Correlação do Incidente](#1521-correlação-do-incidente)
    - [15.22 Incidente e Linhagem](#1522-incidente-e-linhagem)
    - [15.23 Incidente e Governança de Privacidade](#1523-incidente-e-governança-de-privacidade)
    - [15.24 Incidente e Retenção](#1524-incidente-e-retenção)
    - [15.25 Validação da Recuperação de Segurança](#1525-validação-da-recuperação-de-segurança)
    - [15.26 Recuperação de Segurança no Nível do Serviço](#1526-recuperação-de-segurança-no-nível-do-serviço)
    - [15.27 Revisão Pós-Incidente](#1527-revisão-pós-incidente)
    - [15.28 Cenários de Teste de Incidentes de Segurança](#1528-cenários-de-teste-de-incidentes-de-segurança)
    - [15.29 Evidências de Incidentes de Segurança](#1529-evidências-de-incidentes-de-segurança)
    - [15.30 Recuperação de Segurança no Laboratório](#1530-recuperação-de-segurança-no-laboratório)
    - [15.31 Evolução para o Ambiente Corporativo](#1531-evolução-para-o-ambiente-corporativo)
    - [15.32 Garantias para Incidentes de Segurança e Recuperação](#1532-garantias-para-incidentes-de-segurança-e-recuperação)

[16. Funções e Responsabilidades](#16-funções-e-responsabilidades)
    - [16.1 Modelo de Responsabilidades](#161-modelo-de-responsabilidades)
    - [16.2 Engenharia de Dados](#162-engenharia-de-dados)
    - [16.3 Engenharia de Dados e Responsabilidade pela Origem](#163-engenharia-de-dados-e-responsabilidade-pela-origem)
    - [16.4 Administração de Banco de Dados](#164-administração-de-banco-de-dados)
    - [16.5 DBA e CDC](#165-dba-e-cdc)
    - [16.6 Plataforma / SRE](#166-plataforma--sre)
    - [16.7 Responsabilidade pela Confiabilidade da Plataforma](#167-responsabilidade-pela-confiabilidade-da-plataforma)
    - [16.8 Segurança](#168-segurança)
    - [16.9 Segurança e Equipes Técnicas](#169-segurança-e-equipes-técnicas)
    - [16.10 Governança de Dados](#1610-governança-de-dados)
    - [16.11 Governança de Dados e Engenharia de Dados](#1611-governança-de-dados-e-engenharia-de-dados)
    - [16.12 Privacidade / Jurídico](#1612-privacidade--jurídico)
    - [16.13 Privacidade e Engenharia de Dados](#1613-privacidade-e-engenharia-de-dados)
    - [16.14 Responsável pelos Dados de Negócio](#1614-responsável-pelos-dados-de-negócio)
    - [16.15 Responsabilidade de Negócio e Responsabilidade Técnica](#1615-responsabilidade-de-negócio-e-responsabilidade-técnica)
    - [16.16 Business Intelligence / Analytics](#1616-business-intelligence--analytics)
    - [16.17 BI e Lógica de Negócio](#1617-bi-e-lógica-de-negócio)
    - [16.18 Consumidor de Dados](#1618-consumidor-de-dados)
    - [16.19 Responsabilidade pelo Produto de Dados](#1619-responsabilidade-pelo-produto-de-dados)
    - [16.20 Responsabilidade pelo Contrato de Eventos](#1620-responsabilidade-pelo-contrato-de-eventos)
    - [16.21 Responsabilidade pela Qualidade](#1621-responsabilidade-pela-qualidade)
    - [16.22 Responsabilidade pela Reconciliação](#1622-responsabilidade-pela-reconciliação)
    - [16.23 Responsabilidade pela Certificação](#1623-responsabilidade-pela-certificação)
    - [16.24 Responsabilidade pela Publicação](#1624-responsabilidade-pela-publicação)
    - [16.25 Responsabilidade por Backup e Recuperação](#1625-responsabilidade-por-backup-e-recuperação)
    - [16.26 Responsabilidade por Incidentes](#1626-responsabilidade-por-incidentes)
    - [16.27 Responsabilidade por Mudanças](#1627-responsabilidade-por-mudanças)
    - [16.28 Responsabilidade pela Documentação](#1628-responsabilidade-pela-documentação)
    - [16.29 Responsabilidade pelas Evidências](#1629-responsabilidade-pelas-evidências)
    - [16.30 Separação de Responsabilidades](#1630-separação-de-responsabilidades)
    - [16.31 Consolidação de Funções no Laboratório](#1631-consolidação-de-funções-no-laboratório)
    - [16.32 Separação Lógica no Laboratório](#1632-separação-lógica-no-laboratório)
    - [16.33 Distribuição de Funções no Ambiente Corporativo](#1633-distribuição-de-funções-no-ambiente-corporativo)
    - [16.34 Matriz de Responsabilidades](#1634-matriz-de-responsabilidades)
    - [16.35 Lacunas de Responsabilidade](#1635-lacunas-de-responsabilidade)
    - [16.36 Sobreposição de Responsabilidades](#1636-sobreposição-de-responsabilidades)
    - [16.37 Escalonamento](#1637-escalonamento)
    - [16.38 Funções e Privilégio Mínimo](#1638-funções-e-privilégio-mínimo)
    - [16.39 Funções e Evidências](#1639-funções-e-evidências)
    - [16.40 Revisão de Funções](#1640-revisão-de-funções)
    - [16.41 Testes de Funções e Responsabilidades](#1641-testes-de-funções-e-responsabilidades)
    - [16.42 Evidências de Funções e Responsabilidades](#1642-evidências-de-funções-e-responsabilidades)
    - [16.43 Garantias de Funções e Responsabilidades](#1643-garantias-de-funções-e-responsabilidades)

[17. Estratégia de Validação de Segurança](#17-estratégia-de-validação-de-segurança)
    - [17.1 Escopo da Validação](#171-escopo-da-validação)
    - [17.2 Testes Positivos de Segurança](#172-testes-positivos-de-segurança)
    - [17.3 Testes Negativos de Segurança](#173-testes-negativos-de-segurança)
    - [17.4 Identificadores de Teste](#174-identificadores-de-teste)
    - [17.5 Definição do Teste](#175-definição-do-teste)
    - [17.6 Critérios de PASS e FAIL](#176-critérios-de-pass-e-fail)
    - [17.7 Validação de Autenticação](#177-validação-de-autenticação)
    - [17.8 Validação de Autorização](#178-validação-de-autorização)
    - [17.9 Isolamento de Identidades de Serviço](#179-isolamento-de-identidades-de-serviço)
    - [17.10 Validação do Acesso Administrativo](#1710-validação-do-acesso-administrativo)
    - [17.11 Validação da Rotação de Credenciais](#1711-validação-da-rotação-de-credenciais)
    - [17.12 Validação de Exposição de Segredos](#1712-validação-de-exposição-de-segredos)
    - [17.13 Validação de Acesso à Rede](#1713-validação-de-acesso-à-rede)
    - [17.14 Validação de TLS](#1714-validação-de-tls)
    - [17.15 Validação da Proteção de Dados](#1715-validação-da-proteção-de-dados)
    - [17.16 Validação da Classificação](#1716-validação-da-classificação)
    - [17.17 Validação de Privacidade](#1717-validação-de-privacidade)
    - [17.18 Validação de Acesso às Camadas](#1718-validação-de-acesso-às-camadas)
    - [17.19 Validação de Governança](#1719-validação-de-governança)
    - [17.20 Validação da Retenção](#1720-validação-da-retenção)
    - [17.21 Validação da Auditabilidade](#1721-validação-da-auditabilidade)
    - [17.22 Validação de Incidentes](#1722-validação-de-incidentes)
    - [17.23 Validação da Segurança na Recuperação](#1723-validação-da-segurança-na-recuperação)
    - [17.24 Testes de Regressão de Segurança](#1724-testes-de-regressão-de-segurança)
    - [17.25 Isolamento dos Testes](#1725-isolamento-dos-testes)
    - [17.26 Limpeza dos Testes](#1726-limpeza-dos-testes)
    - [17.27 Repetibilidade](#1727-repetibilidade)
    - [17.28 Automação](#1728-automação)
    - [17.29 Ambiente dos Testes de Segurança](#1729-ambiente-dos-testes-de-segurança)
    - [17.30 Estrutura das Evidências de Segurança](#1730-estrutura-das-evidências-de-segurança)
    - [17.31 Sanitização das Evidências](#1731-sanitização-das-evidências)
    - [17.32 Evidências Negativas](#1732-evidências-negativas)
    - [17.33 Evidências e Decisões Arquiteturais](#1733-evidências-e-decisões-arquiteturais)
    - [17.34 Linha de Base de Segurança](#1734-linha-de-base-de-segurança)
    - [17.35 Níveis das Afirmações de Segurança](#1735-níveis-das-afirmações-de-segurança)
    - [17.36 Afirmações do Laboratório](#1736-afirmações-do-laboratório)
    - [17.37 Revisão da Validação de Segurança](#1737-revisão-da-validação-de-segurança)
    - [17.38 Garantias da Validação de Segurança](#1738-garantias-da-validação-de-segurança)

[18. Limites de Segurança do Laboratório e do Ambiente Corporativo](#18-limites-de-segurança-do-laboratório-e-do-ambiente-corporativo)
    - [18.1 Propósito do Laboratório](#181-propósito-do-laboratório)
    - [18.2 Restrições Físicas do Laboratório](#182-restrições-físicas-do-laboratório)
    - [18.3 Preservação dos Limites Lógicos](#183-preservação-dos-limites-lógicos)
    - [18.4 Ambiente com Operador Único](#184-ambiente-com-operador-único)
    - [18.5 Limitações de Identidade do Laboratório](#185-limitações-de-identidade-do-laboratório)
    - [18.6 Limitações de Segredos do Laboratório](#186-limitações-de-segredos-do-laboratório)
    - [18.7 Limitações de Rede do Laboratório](#187-limitações-de-rede-do-laboratório)
    - [18.8 Escopo de Criptografia do Laboratório](#188-escopo-de-criptografia-do-laboratório)
    - [18.9 Dados do Laboratório](#189-dados-do-laboratório)
    - [18.10 Afirmações de Privacidade do Laboratório](#1810-afirmações-de-privacidade-do-laboratório)
    - [18.11 Auditabilidade do Laboratório](#1811-auditabilidade-do-laboratório)
    - [18.12 Resposta a Incidentes no Laboratório](#1812-resposta-a-incidentes-no-laboratório)
    - [18.13 Disponibilidade e Redundância do Laboratório](#1813-disponibilidade-e-redundância-do-laboratório)
    - [18.14 Escala do Laboratório](#1814-escala-do-laboratório)
    - [18.15 Evolução Corporativa de Identidade](#1815-evolução-corporativa-de-identidade)
    - [18.16 Evolução Corporativa de Segredos](#1816-evolução-corporativa-de-segredos)
    - [18.17 Evolução Corporativa de Rede](#1817-evolução-corporativa-de-rede)
    - [18.18 Evolução Corporativa de Criptografia](#1818-evolução-corporativa-de-criptografia)
    - [18.19 Observabilidade Corporativa e Operações de Segurança](#1819-observabilidade-corporativa-e-operações-de-segurança)
    - [18.20 Evolução Corporativa da Governança de Dados](#1820-evolução-corporativa-da-governança-de-dados)
    - [18.21 Separação Corporativa de Responsabilidades](#1821-separação-corporativa-de-responsabilidades)
    - [18.22 Separação de Ambientes Corporativos](#1822-separação-de-ambientes-corporativos)
    - [18.23 Aplicação de Políticas no Ambiente Corporativo](#1823-aplicação-de-políticas-no-ambiente-corporativo)
    - [18.24 Alta Disponibilidade Corporativa](#1824-alta-disponibilidade-corporativa)
    - [18.25 Recuperação de Desastre Corporativa](#1825-recuperação-de-desastre-corporativa)
    - [18.26 Governança Corporativa de Segurança](#1826-governança-corporativa-de-segurança)
    - [18.27 Substituição de Controles de Segurança](#1827-substituição-de-controles-de-segurança)
    - [18.28 Fortalecimento dos Controles de Segurança](#1828-fortalecimento-dos-controles-de-segurança)
    - [18.29 Portabilidade da Arquitetura de Segurança](#1829-portabilidade-da-arquitetura-de-segurança)
    - [18.30 Limites das Evidências do Laboratório](#1830-limites-das-evidências-do-laboratório)
    - [18.31 Afirmações do Laboratório versus Corporativas](#1831-afirmações-do-laboratório-versus-corporativas)
    - [18.32 Documentação das Lacunas Corporativas](#1832-documentação-das-lacunas-corporativas)
    - [18.33 Evitando Teatro de Segurança](#1833-evitando-teatro-de-segurança)
    - [18.34 Evolução Corporativa Orientada por Evidências](#1834-evolução-corporativa-orientada-por-evidências)
    - [18.35 Evolução Corporativa e ADRs](#1835-evolução-corporativa-e-adrs)
    - [18.36 Validação no Laboratório e no Ambiente Corporativo](#1836-validação-no-laboratório-e-no-ambiente-corporativo)
    - [18.37 Garantias de Segurança do Laboratório e do Ambiente Corporativo](#1837-garantias-de-segurança-do-laboratório-e-do-ambiente-corporativo)

[19. Garantias de Segurança e Governança](#19-garantias-de-segurança-e-governança)
    - [19.1 Identidade e Acesso](#191-identidade-e-acesso)
    - [19.2 Negar por Padrão](#192-negar-por-padrão)
    - [19.3 Isolamento de Serviços](#193-isolamento-de-serviços)
    - [19.4 Proteção de Segredos](#194-proteção-de-segredos)
    - [19.5 Limites de Confiança Explícitos](#195-limites-de-confiança-explícitos)
    - [19.6 Exposição Controlada de Rede](#196-exposição-controlada-de-rede)
    - [19.7 Proteção de Dados ao Longo do Ciclo de Vida](#197-proteção-de-dados-ao-longo-do-ciclo-de-vida)
    - [19.8 Minimização de Dados](#198-minimização-de-dados)
    - [19.9 Classificação de Dados](#199-classificação-de-dados)
    - [19.10 Dados Pessoais e Privacidade](#1910-dados-pessoais-e-privacidade)
    - [19.11 Privacidade por Design](#1911-privacidade-por-design)
    - [19.12 Acesso Baseado em Camadas](#1912-acesso-baseado-em-camadas)
    - [19.13 Separação entre Dados Candidatos e Certificados](#1913-separação-entre-dados-candidatos-e-certificados)
    - [19.14 Governança das Definições](#1914-governança-das-definições)
    - [19.15 Governança de Contratos](#1915-governança-de-contratos)
    - [19.16 Separação de Versões](#1916-separação-de-versões)
    - [19.17 Metadados e Linhagem](#1917-metadados-e-linhagem)
    - [19.18 Governança da Qualidade e Certificação](#1918-governança-da-qualidade-e-certificação)
    - [19.19 Governança de Retenção](#1919-governança-de-retenção)
    - [19.20 Governança de Arquivamento](#1920-governança-de-arquivamento)
    - [19.21 Governança de Descarte](#1921-governança-de-descarte)
    - [19.22 Auditabilidade](#1922-auditabilidade)
    - [19.23 Observabilidade de Segurança](#1923-observabilidade-de-segurança)
    - [19.24 Tratamento de Incidentes de Segurança](#1924-tratamento-de-incidentes-de-segurança)
    - [19.25 Último Estado Reconhecidamente Confiável](#1925-último-estado-reconhecidamente-confiável)
    - [19.26 A Recuperação Não Restaura Confiança Invalidada](#1926-a-recuperação-não-restaura-confiança-invalidada)
    - [19.27 A Recuperação Preserva a Governança](#1927-a-recuperação-preserva-a-governança)
    - [19.28 Funções e Responsabilidades](#1928-funções-e-responsabilidades)
    - [19.29 Responsabilidade e Privilégio](#1929-responsabilidade-e-privilégio)
    - [19.30 Validação](#1930-validação)
    - [19.31 Evidências](#1931-evidências)
    - [19.32 Evidências Negativas](#1932-evidências-negativas)
    - [19.33 Drift](#1933-drift)
    - [19.34 Documentação](#1934-documentação)
    - [19.35 Limite do Laboratório](#1935-limite-do-laboratório)
    - [19.36 Evolução para o Ambiente Corporativo](#1936-evolução-para-o-ambiente-corporativo)
    - [19.37 Afirmações Limitadas pelas Evidências](#1937-afirmações-limitadas-pelas-evidências)
    - [19.38 Princípio de Encerramento](#1938-princípio-de-encerramento)

---

## 1. Propósito

Este documento define a arquitetura de segurança e governança da plataforma de dados Atlas Engineering.

Seu propósito é estabelecer como identidades, acessos, credenciais, dados, metadados, contratos, requisitos de privacidade, políticas de retenção, auditabilidade e responsabilidades de segurança são governados em toda a plataforma.

Enquanto a **Visão Geral da Arquitetura** define a estrutura da plataforma e o documento **Fluxo e Processamento de Dados** define como os dados se movimentam e são processados, este documento define os controles que protegem e governam essas operações ao longo de todo o seu ciclo de vida.

A arquitetura é projetada com base no princípio de que segurança e governança são capacidades transversais, e não etapas isoladas de implementação. Elas se aplicam desde a origem operacional, passando por ingestão, *streaming*, armazenamento, transformação e certificação, até o consumo analítico.

O documento define os requisitos arquiteturais para:

- gerenciamento de identidades e acessos;
- autenticação e autorização;
- acesso com privilégio mínimo;
- gerenciamento de segredos e credenciais;
- comunicação segura entre os serviços da plataforma;
- proteção de dados em trânsito e em repouso;
- classificação e tratamento de dados sensíveis;
- controles relacionados à privacidade e à LGPD;
- limites de acesso entre Bronze, Silver, Gold e Certified Gold;
- governança de *schemas*, contratos e metadados;
- retenção, arquivamento e descarte controlado;
- auditabilidade e observabilidade de segurança;
- considerações relacionadas à segurança em incidentes e recuperação;
- separação de responsabilidades entre funções e equipes da plataforma;
- controles de segurança do laboratório e sua evolução para o ambiente corporativo;
- validação e evidências dos controles de segurança implementados.

O documento não afirma que um controle documentado esteja automaticamente implementado, testado ou em conformidade.

Os requisitos de segurança e governança devem progredir pelo mesmo ciclo de vida baseado em evidências utilizado em toda a Atlas Engineering:

**Requisito Arquitetural → Implementação → Teste → Observabilidade → Evidência**

Quando requisitos legais, regulatórios ou organizacionais forem aplicáveis, a arquitetura define os mecanismos técnicos e de governança capazes de dar suporte a esses requisitos. A conformidade formal com requisitos legais ou regulatórios não deve ser inferida exclusivamente a partir da existência de controles arquiteturais.

A implementação da Versão 1 concentra-se nos controles necessários para proteger e governar o produto de dados Sales inicial e os componentes da plataforma que lhe dão suporte.

O modelo de segurança e governança foi projetado para se estender a futuros produtos de dados sem redefinir seus limites arquiteturais fundamentais.

---

## 2. Contexto de Segurança e Governança

A Atlas Engineering processa dados operacionais através de múltiplos limites arquiteturais, tecnologias, camadas de armazenamento e estágios de processamento.

Os dados têm origem no AtlasCommerce e percorrem captura de alterações, criação de eventos, governança de *schemas*, transporte pelo Kafka, persistência na Bronze, transformação na Silver, processamento dimensional na Gold, certificação e consumo analítico.

Cada transição introduz responsabilidades de segurança e governança.

Portanto, a plataforma não pode tratar segurança como um controle aplicado apenas no perímetro da infraestrutura, nem governança como documentação aplicada somente depois que os dados já foram produzidos.

Segurança e governança devem acompanhar os dados ao longo de todo o seu ciclo de vida.

O contexto arquitetural inclui:

- uma origem operacional SQL Server contendo dados de negócio e potencialmente sensíveis;
- SQL Server CDC e Debezium para captura de alterações e criação de eventos;
- Apicurio Registry para governança de contratos de eventos;
- Kafka para transporte assíncrono de eventos;
- MinIO para armazenamento durável da Bronze e da Silver;
- SQL Server para processamento dimensional da Gold e publicação da Certified Gold;
- Airflow para orquestração;
- Prometheus, Grafana e *logs* estruturados para observabilidade operacional;
- Power BI como consumidor analítico inicial;
- mecanismos de metadados, linhagem, qualidade, reconciliação, certificação e evidências que abrangem múltiplos componentes da plataforma.

Esses componentes possuem diferentes responsabilidades, limites de confiança, requisitos de acesso e características de exposição de dados.

A segurança, portanto, é aplicada de acordo com a identidade que executa uma responsabilidade definida e com o recurso necessário para o cumprimento dessa responsabilidade.

A sequência de acesso pretendida é:

**Identidade → Autenticação → Autorização → Acesso Controlado aos Dados → Atividade Auditável**

A governança aplica-se não apenas aos dados de negócio, mas também, quando aplicável, a:

- contratos de eventos e versões de *schema*;
- versões de processamento;
- regras de qualidade e reconciliação;
- metadados e linhagem;
- estado de certificação;
- políticas de retenção;
- políticas de acesso;
- informações de auditoria;
- evidências de validação.

Segurança e governança também devem permanecer efetivas durante falhas e recuperação.

A recuperação deve restaurar o processamento legítimo sem contornar silenciosamente autenticação, autorização, proteção de dados, auditabilidade ou limites de publicação governada.

O laboratório da Versão 1 implementa esses princípios dentro das restrições de um ambiente local controlado de treinamento.

As limitações do laboratório podem afetar a robustez física, a redundância ou a sofisticação de controles individuais, mas não redefinem os limites lógicos de segurança e governança da arquitetura.

---

## 3. Princípios de Segurança

As decisões de segurança e governança na Atlas Engineering seguem um conjunto consistente de princípios arquiteturais.

Esses princípios se aplicam à infraestrutura, aos serviços, às cargas de processamento, às camadas de armazenamento, aos metadados, aos produtos analíticos, aos procedimentos operacionais e à evolução futura da plataforma.

### 3.1 Segurança por Design

A segurança é considerada durante o projeto da arquitetura e da implementação, em vez de ser adicionada somente depois que um componente entra em operação.

Novos serviços, fluxos de dados, interfaces, locais de armazenamento e produtos analíticos devem ser avaliados quanto às suas implicações de segurança antes de se tornarem parte da plataforma governada.

Os requisitos de segurança, portanto, evoluem juntamente com a arquitetura.

### 3.2 Negar por Padrão

O acesso é negado, a menos que seja explicitamente concedido para um propósito definido.

Conectividade de rede, compatibilidade técnica ou posse de credenciais válidas não constituem autorização.

Novas identidades, serviços, conjuntos de dados, interfaces e recursos não devem herdar acesso amplo apenas por conveniência operacional.

### 3.3 Privilégio Mínimo

Toda identidade humana ou de serviço recebe somente as permissões necessárias para executar suas responsabilidades definidas.

As permissões devem ser limitadas de acordo com:

- recurso;
- operação;
- escopo dos dados;
- ambiente;
- duração;
- responsabilidade operacional.

Privilégios administrativos não devem ser utilizados para processamento rotineiro quando permissões mais restritas forem suficientes para atender ao requisito.

### 3.4 Separação de Responsabilidades

Responsabilidades que criem níveis conflitantes de controle devem ser separadas sempre que possível.

A arquitetura distingue responsabilidades como:

- administração da plataforma;
- engenharia de dados;
- consumo de dados;
- administração de segurança;
- governança;
- certificação;
- auditoria e investigação.

O laboratório da Versão 1 pode combinar diversas responsabilidades sob um único operador, mas sua separação lógica permanece como parte da arquitetura.

### 3.5 Limites de Confiança Explícitos

A confiança não é implicitamente estendida entre componentes arquiteturais.

A comunicação entre serviços, camadas, ambientes e consumidores atravessa limites de confiança explícitos, avaliados de acordo com:

- identidade;
- autenticação;
- autorização;
- exposição de rede;
- sensibilidade dos dados;
- requisitos de criptografia;
- auditabilidade.

Um serviço considerado confiável para uma responsabilidade não é automaticamente considerado confiável para outra.

### 3.6 Defesa em Profundidade

Nenhum controle de segurança isolado é considerado capaz de fornecer proteção completa.

Quando apropriado, a proteção combina controles como:

- identidade;
- autenticação;
- autorização;
- isolamento de rede;
- criptografia;
- gerenciamento de segredos;
- minimização de dados;
- auditoria;
- monitoramento;
- controles de recuperação.

A falha ou configuração incorreta de um controle não deve remover automaticamente todas as proteções existentes ao redor de um ativo.

### 3.7 Minimização de Dados

A plataforma deve processar, propagar, persistir e expor somente os dados necessários para um propósito técnico ou de negócio definido.

A presença de um atributo na origem operacional não justifica automaticamente sua presença em todos os eventos *downstream*, camadas de armazenamento, modelos dimensionais ou produtos analíticos.

Dados sensíveis exigem atenção especial quanto à necessidade, exposição, retenção e propagação *downstream*.

### 3.8 Acesso Limitado ao Propósito

O acesso aos dados é concedido de acordo com um propósito operacional, analítico, de governança ou de suporte explicitamente definido.

A capacidade técnica de acessar um conjunto de dados não estabelece uma razão válida para acessá-lo.

Os consumidores devem utilizar a representação governada apropriada ao seu propósito, em vez de contornar camadas arquiteturais sem justificativa.

### 3.9 Tratamento Seguro de Credenciais

Senhas, *tokens*, chaves, certificados, *connection strings* contendo credenciais e segredos equivalentes não devem ser tratados como dados comuns de configuração.

Segredos não devem ser intencionalmente incorporados ao código-fonte, enviados ao repositório, expostos na documentação ou gravados desnecessariamente em *logs* ou evidências.

O ciclo de vida das credenciais e os mecanismos de armazenamento devem ser apropriados ao ambiente de implantação.

### 3.10 Criptografia de Acordo com o Risco e o Limite

A proteção em trânsito e em repouso deve ser avaliada de acordo com a sensibilidade dos dados, os limites de confiança, as capacidades da plataforma, o ambiente de implantação e os requisitos aplicáveis.

Uma rede interna ou implantação local não elimina a necessidade de avaliar a criptografia.

Quando o laboratório não puder reproduzir um modelo corporativo de criptografia, essa limitação deve permanecer explícita.

### 3.11 Ações de Segurança Auditáveis

Ações relevantes para a segurança devem ser observáveis e atribuíveis, quando tecnicamente aplicável.

Isso inclui, quando relevante:

- eventos de autenticação e autorização;
- alterações de privilégios e configurações de segurança;
- operações administrativas;
- eventos do ciclo de vida de credenciais;
- acesso a recursos sensíveis;
- certificação e publicação;
- recuperação relacionada à segurança.

A auditabilidade não deve exigir o registro de segredos nem expor desnecessariamente dados sensíveis.

### 3.12 Falha e Recuperação Seguras

O tratamento de falhas, *replay*, reprocessamento, *backfill*, *rebuild*, *rollback* e recuperação devem preservar os controles de segurança e governança aplicáveis.

A recuperação não deve depender de elevação de privilégios não documentada, credenciais compartilhadas, acesso não controlado ou desvio dos limites governados de publicação e certificação.

O acesso emergencial com privilégios elevados, quando necessário, deve permanecer explícito, controlado e auditável.

### 3.13 Os Controles de Segurança Devem Ser Testáveis

Um requisito de segurança documentado não é considerado comprovado apenas porque existe uma configuração ou política.

Sempre que possível, os controles devem ser validados por meio de testes que demonstrem tanto o comportamento autorizado quanto o comportamento proibido.

Os resultados relevantes devem ser preservados como evidências quando o controle fizer parte da arquitetura validada.

### 3.14 As Afirmações de Segurança Devem Corresponder às Evidências

A Atlas Engineering distingue entre:

- requisitos de segurança documentados;
- controles implementados;
- controles testados;
- comportamento observado;
- evidências validadas.

Um controle não deve ser descrito como comprovado, pronto para produção, em conformidade ou de nível corporativo além do que sua implementação e suas evidências demonstrarem.

A validação em laboratório demonstra comportamento somente sob a topologia, configuração, carga de trabalho e condições de teste documentadas.

### 3.15 A Segurança Deve Evoluir sem Romper os Limites Arquiteturais

Os mecanismos de segurança podem evoluir à medida que a plataforma cresce.

Por exemplo:

**Credenciais Locais → Gerenciamento Corporativo de Segredos**

**Identidades Locais → Gerenciamento Centralizado de Identidades**

**Controles de Rede Locais → Segmentação de Rede Corporativa**

O mecanismo de implementação pode mudar enquanto o requisito de segurança subjacente permanece estável.

A evolução para o ambiente corporativo deve fortalecer a aplicação dos controles de segurança sem invalidar os limites arquiteturais fundamentais da plataforma.

---

## 4. Gerenciamento de Identidades e Acessos

O Gerenciamento de Identidades e Acessos define como identidades humanas e de serviço são representadas, separadas, delimitadas, revisadas e governadas em toda a Atlas Engineering.

O objetivo é garantir que o acesso corresponda a uma responsabilidade definida e permaneça identificável ao longo de todo o seu ciclo de vida.

O modelo governante é:

**Identidade → Responsabilidade → Acesso Necessário → Ciclo de Vida Controlado**

Os mecanismos de autenticação e o comportamento de autorização no nível dos recursos são detalhados separadamente no capítulo seguinte.

### 4.1 Tipos de Identidade

A Atlas Engineering distingue entre:

**Identidades Humanas**
→ representam indivíduos que executam atividades administrativas, de engenharia, governança, análise ou suporte.

**Identidades de Serviço**
→ representam aplicações, componentes da plataforma, cargas de processamento ou processos automatizados.

**Identidades Administrativas**
→ representam acessos elevados utilizados para responsabilidades administrativas explicitamente autorizadas.

Essas categorias descrevem limites de responsabilidade e privilégio.

Uma pessoa pode operar mais de uma identidade quando diferentes responsabilidades exigirem diferentes níveis de privilégio.

### 4.2 Identidades Humanas

O acesso humano deve ser individualmente atribuível quando houver suporte técnico para isso.

Identidades pessoais devem ser preferidas a contas humanas compartilhadas, pois a atribuição individual melhora:

- responsabilização;
- revisão de acesso;
- investigação;
- revogação;
- auditabilidade.

O acesso humano deve corresponder a uma responsabilidade definida, e não à mera conveniência técnica.

### 4.3 Identidades de Serviço

Os componentes automatizados da plataforma devem utilizar identidades de serviço apropriadas às suas responsabilidades.

Identidades de serviço representativas podem incluir:

- Debezium;
- produtores e consumidores Kafka;
- processamento da Bronze;
- processamento da Silver;
- processamento da Gold;
- certificação e publicação;
- Airflow;
- componentes de observabilidade;
- Power BI ou serviços de consumo analítico.

Uma identidade de serviço deve existir porque uma carga de trabalho exige acesso técnico identificável, e não simplesmente porque uma credencial é necessária.

### 4.4 Separação de Identidades de Serviço

Responsabilidades independentes da plataforma não devem compartilhar uma única identidade de serviço irrestrita.

Sempre que possível, cargas de trabalho distintas devem receber identidades e credenciais separadas para que o acesso possa ser delimitado, revogado, rotacionado, monitorado e investigado de forma independente.

Por exemplo:

**Processador Bronze**
→ consome eventos Kafka aprovados e grava dados na Bronze.

**Processador Silver**
→ lê a Bronze e grava na Silver.

**Processador Gold**
→ lê entradas aprovadas da Silver e produz candidatas à Gold.

**Processo de Publicação**
→ controla a publicação do estado aprovado da Certified Gold.

A separação reduz o raio de impacto e preserva a responsabilização.

### 4.5 Identidades Administrativas

O acesso administrativo deve permanecer distinguível do processamento e consumo rotineiros.

Identidades administrativas podem exigir privilégios mais amplos para atividades como:

- configuração da plataforma;
- administração de banco de dados;
- configuração de segurança;
- recuperação;
- *troubleshooting* controlado.

Esses privilégios não devem se tornar o contexto normal de execução de serviços ou de atividades analíticas comuns.

Sempre que possível, responsabilidades rotineiras e elevadas devem utilizar caminhos de acesso ou identidades distinguíveis.

### 4.6 Contas Compartilhadas

Contas humanas compartilhadas devem ser evitadas quando a atribuição individual for viável.

Uma conta compartilhada enfraquece:

- responsabilização;
- revogação;
- revisão de acesso;
- investigação de incidentes.

Quando uma restrição tecnológica ou do laboratório exigir acesso compartilhado, a limitação e os controles compensatórios devem ser documentados.

Identidades técnicas compartilhadas podem ser aceitáveis somente quando representarem uma única responsabilidade de serviço claramente definida, e não múltiplas cargas de trabalho não relacionadas.

### 4.7 Acesso Baseado em Funções

As permissões devem ser atribuídas de acordo com responsabilidades definidas, em vez de serem acumuladas individualmente sem uma estrutura.

Funções lógicas representativas podem incluir:

- Engenharia de Dados;
- DBA;
- Plataforma / SRE;
- Segurança;
- Governança de Dados;
- Privacidade / Jurídico;
- Responsável pelos Dados de Negócio;
- BI / Analytics;
- Consumidor de Dados.

As funções descrevem limites de responsabilidade.

O mesmo operador humano pode desempenhar múltiplas funções no laboratório da Versão 1, mas essas responsabilidades permanecem logicamente distintas.

### 4.8 Escopo de Acesso

O acesso deve ser delimitado de acordo com a combinação mínima necessária para uma responsabilidade.

As dimensões relevantes incluem:

- recurso;
- operação;
- conjunto de dados;
- camada arquitetural;
- ambiente;
- duração.

Acessos de leitura, gravação, administração, publicação e gerenciamento de segurança não devem ser tratados como privilégios equivalentes.

### 4.9 Limites de Acesso Baseados em Camadas

As camadas arquiteturais representam limites de acesso, além de limites de processamento.

O acesso a uma camada não implica automaticamente acesso a outra.

Por exemplo:

**Power BI**
→ requer acesso analítico governado à Certified Gold.

Portanto, ele não requer automaticamente acesso direto a:

- AtlasCommerce;
- estruturas de CDC;
- Kafka;
- Bronze;
- Silver;
- estruturas de processamento da Gold.

O modelo detalhado de acesso para cada camada arquitetural é definido no Capítulo 11.

### 4.10 Ciclo de Vida do Acesso

O acesso deve ser governado ao longo de todo o seu ciclo de vida.

Um ciclo de vida representativo é:

**Solicitação / Requisito → Aprovação → Provisionamento → Uso → Revisão → Modificação ou Revogação**

Um acesso que já foi justificado não deve ser considerado justificável indefinidamente.

Alterações de responsabilidade, arquitetura de serviços, ambiente ou propósito operacional podem exigir que o acesso seja modificado ou removido.

### 4.11 Revisão de Acesso

O acesso deve ser revisado quando ocorrerem condições capazes de alterar sua justificativa.

Os gatilhos relevantes incluem:

- alterações de função;
- alterações de serviço;
- novos produtos de dados;
- novos dados sensíveis;
- alterações arquiteturais;
- incidentes de segurança;
- alterações de ambiente;
- elevação de privilégios;
- identificação de *access drift*.

Ambientes corporativos também podem introduzir processos periódicos de certificação de acesso.

### 4.12 Elevação de Privilégios

Acesso temporário com privilégios elevados pode ser necessário para administração, investigação ou recuperação.

Essa elevação deve ser:

- explícita;
- justificada;
- limitada ao escopo necessário;
- temporária, sempre que possível;
- atribuível;
- auditável;
- removida quando não for mais necessária.

O acesso emergencial não deve se transformar silenciosamente em acesso permanente.

### 4.13 Falha de Autenticação e Negação de Acesso

Falha de autenticação e negação de autorização são resultados de segurança distintos.

Uma identidade pode falhar porque não consegue comprovar quem é ou porque uma identidade autenticada não possui permissão para executar a ação solicitada.

Ambos os resultados devem permanecer observáveis quando houver suporte técnico para isso.

O comportamento detalhado de autenticação e autorização é definido no Capítulo 5.

### 4.14 Metadados de Identidade e Acesso

A governança de identidades e acessos deve preservar metadados suficientes para explicar:

- qual identidade existe;
- se ela representa uma pessoa ou um serviço;
- sua responsabilidade;
- seu responsável, quando aplicável;
- seu escopo de acesso pretendido;
- se possui privilégios elevados;
- seu estado no ciclo de vida.

Os metadados devem dar suporte à revisão e à investigação sem expor valores de credenciais.

### 4.15 Modelo de Identidade do Laboratório

A Versão 1 pode utilizar identidades locais e credenciais gerenciadas localmente porque a plataforma opera como um laboratório controlado de treinamento.

O laboratório ainda deve demonstrar:

- identidades humanas e de serviço distinguíveis, sempre que possível;
- acesso específico por serviço;
- privilégio mínimo;
- acesso administrativo controlado;
- revogação;
- revisão de acesso;
- comportamento de segurança auditável.

As restrições da implementação local não eliminam o modelo lógico de IAM.

### 4.16 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer o IAM por meio de capacidades como:

- provedores de identidade centralizados;
- integração com diretórios;
- *single sign-on*;
- autenticação multifator;
- identidades gerenciadas para cargas de trabalho;
- gerenciamento de acessos privilegiados;
- provisionamento e desprovisionamento automatizados;
- certificação periódica de acesso.

Esses mecanismos fortalecem a aplicação dos controles sem alterar o princípio fundamental de que identidade e acesso seguem a responsabilidade.

### 4.17 Garantias de Identidade e Acesso

O modelo de IAM da Atlas Engineering deve preservar as seguintes garantias:

1. identidades humanas e de serviço permanecem distinguíveis sempre que tecnicamente possível;
2. o acesso administrativo permanece distinguível do processamento e consumo rotineiros;
3. responsabilidades de serviço independentes não dependem de uma única identidade compartilhada irrestrita;
4. contas humanas compartilhadas são evitadas quando a atribuição individual é viável;
5. o acesso segue uma responsabilidade definida;
6. as permissões são delimitadas de acordo com o privilégio mínimo;
7. o acesso a uma camada arquitetural não implica automaticamente acesso a outra;
8. o consumo analítico não exige acesso *upstream* irrestrito;
9. o acesso possui um ciclo de vida explícito e pode ser revisado, modificado ou revogado;
10. o acesso elevado permanece explícito e controlado;
11. falha de autenticação e negação de autorização permanecem distinguíveis;
12. os metadados de identidade e acesso dão suporte à governança sem expor credenciais;
13. as restrições do laboratório não redefinem os limites lógicos de identidade;
14. mecanismos corporativos de IAM podem fortalecer a aplicação dos controles sem alterar o modelo de responsabilidade subjacente.

---


## 5. Autenticação e Autorização

Autenticação e autorização aplicam os limites de identidade e acesso definidos pela Atlas Engineering.

A autenticação responde:

**Quem ou o que está solicitando acesso?**

A autorização responde:

**O que essa identidade autenticada tem permissão para fazer?**

A sequência governante é:

**Identidade → Autenticação → Autorização → Acesso ao Recurso → Atividade Auditável**

Autenticação e autorização são controles distintos.

A autenticação bem-sucedida comprova a identidade de acordo com o mecanismo implementado.

Ela não concede, de forma independente, permissão para acessar um recurso ou executar uma operação.

### 5.1 Autenticação

A autenticação verifica a identidade de um usuário humano, serviço, carga de trabalho ou agente administrativo antes que o acesso protegido seja concedido.

Os mecanismos de autenticação dependem da tecnologia e do ambiente de implantação.

Eles podem incluir:

- senhas;
- credenciais de serviço;
- *tokens*;
- certificados;
- mecanismos integrados de identidade;
- identidades gerenciadas em futuros ambientes corporativos.

As credenciais de autenticação devem ser tratadas de acordo com os requisitos de gerenciamento de segredos definidos no Capítulo 6.

### 5.2 Autenticação Humana

O acesso humano deve utilizar autenticação individualmente atribuível quando houver suporte técnico para isso.

A autenticação deve preservar a distinção entre:

- acesso rotineiro de usuário;
- acesso administrativo;
- acesso temporário com privilégios elevados.

A autenticação humana compartilhada deve ser evitada quando a atribuição individual for viável.

Ambientes corporativos podem fortalecer a autenticação humana por meio de identidade centralizada, *single sign-on*, autenticação multifator e mecanismos de acesso privilegiado.

### 5.3 Autenticação de Serviço

Os serviços devem se autenticar utilizando mecanismos apropriados às suas responsabilidades técnicas.

Serviços autenticados representativos podem incluir:

- Debezium;
- produtores e consumidores Kafka;
- processamento da Bronze;
- processamento da Silver;
- processamento da Gold;
- certificação e publicação;
- Airflow;
- componentes de observabilidade;
- serviços de consumo analítico.

Uma credencial de serviço deve identificar uma carga de trabalho definida, em vez de fornecer acesso genérico a toda a plataforma.

### 5.4 Autenticação entre Limites de Serviço

A autenticação deve ser avaliada em cada limite de serviço protegido.

A autenticação bem-sucedida em um componente da plataforma não estabelece automaticamente acesso autenticado ou autorizado a outro.

Por exemplo:

**Debezium → SQL Server**

e:

**Debezium → Kafka**

representam relacionamentos de serviço distintos e podem exigir diferentes mecanismos de autenticação ou credenciais.

A confiança não deve se propagar implicitamente pela plataforma.

### 5.5 Autorização

A autorização determina se uma identidade autenticada pode executar uma operação solicitada sobre um recurso específico.

A autorização deve considerar, quando aplicável:

- identidade;
- função;
- recurso;
- operação;
- camada arquitetural;
- conjunto de dados;
- ambiente;
- responsabilidade administrativa.

O princípio governante é:

**Autenticado ≠ Autorizado**

### 5.6 Autenticação Não Implica Autorização

Uma identidade pode se autenticar com sucesso e, ainda assim, ter o acesso a um recurso ou operação negado.

Por exemplo:

**Autenticação do Power BI → SUCESSO**

não implica:

**Acesso Direto ao AtlasCommerce → PERMITIDO**

Da mesma forma:

**Autenticação do Processador Bronze → SUCESSO**

não implica:

**Modificação da Certified Gold → PERMITIDA**

Essa distinção é fundamental para a aplicação do privilégio mínimo.

### 5.7 Autorização no Nível do Recurso

A autorização deve ser aplicada o mais próximo possível do recurso protegido.

Dependendo da tecnologia, a autorização pode controlar o acesso a:

- bancos de dados;
- *schemas*;
- tabelas;
- *views*;
- tópicos Kafka;
- grupos de consumidores;
- *buckets* ou caminhos de armazenamento de objetos;
- recursos de orquestração;
- *dashboards*;
- métricas;
- metadados;
- interfaces administrativas.

O acesso amplo à plataforma não deve substituir a autorização específica por recurso quando controles mais restritos estiverem disponíveis.

### 5.8 Separação entre Leitura e Gravação

Permissões de leitura e gravação devem ser tratadas como privilégios distintos.

Um consumidor que requer acesso de leitura não necessita automaticamente de:

- INSERT;
- UPDATE;
- DELETE;
- DDL;
- publicação;
- operações administrativas.

Da mesma forma, uma carga de processamento deve receber somente os privilégios de gravação necessários para sua responsabilidade de saída.

Essa distinção é particularmente importante nos limites de publicação governada.

### 5.9 Autorização Administrativa

Operações administrativas exigem autorização elevada explícita.

Ações administrativas representativas incluem:

- alterar configurações de segurança;
- gerenciar identidades ou permissões;
- modificar configurações de infraestrutura;
- gerenciar recursos administrativos do Kafka;
- alterar a segurança do banco de dados;
- alterar certificados ou configurações sensíveis à segurança;
- executar operações privilegiadas de recuperação.

A autorização administrativa deve permanecer distinguível do acesso rotineiro das cargas de trabalho.

### 5.10 Autorização no Limite da Certified Gold

A Certified Gold é um limite governado de consumo.

Consumidores analíticos comuns devem normalmente receber somente acesso de leitura.

Modificação, substituição, certificação ou publicação da Certified Gold exigem autoridade separada.

O modelo pretendido é:

**Candidata à Gold**
→ validada e reconciliada.

**Autoridade de Certificação**
→ determina se os critérios de publicação foram atendidos.

**Autoridade de Publicação**
→ publica o estado aprovado.

**Consumidor Analítico**
→ lê o estado certificado.

A mesma implementação técnica pode executar mais de uma responsabilidade na Versão 1, mas os limites de autorização permanecem logicamente distintos.

### 5.11 Autorização e Dados Sensíveis

A autorização deve considerar a sensibilidade dos dados, além do acesso técnico ao recurso.

A permissão para acessar um conjunto de dados não justifica automaticamente o acesso a todos os atributos sensíveis que ele contém.

Quando houver suporte e necessidade, o acesso pode ser restringido por meio de mecanismos como:

- *views* governadas;
- conjuntos de dados reduzidos;
- controles no nível de coluna;
- representações mascaradas;
- produtos analíticos separados.

Os requisitos de classificação e privacidade são definidos nos Capítulos 9 e 10.

### 5.12 Falhas de Autenticação e Autorização

Falhas de autenticação e autorização são resultados de segurança esperados quando o acesso é inválido ou proibido.

Condições representativas incluem:

- credencial inválida;
- credencial expirada;
- credencial revogada;
- identidade desabilitada;
- recurso não autorizado;
- operação não autorizada;
- privilégio insuficiente.

A negação de uma operação proibida é um resultado bem-sucedido da aplicação do controle.

As falhas devem ser observáveis quando houver suporte técnico para isso, sem expor valores de segredos.

### 5.13 Rotação de Credenciais e Continuidade da Autenticação

A rotação de credenciais deve preservar a autenticação legítima enquanto invalida credenciais que não devem mais ser consideradas confiáveis.

Um ciclo de vida representativo é:

**Credencial V1 → Substituição V2 → Transição da Carga de Trabalho → Revogação da V1**

Após a transição bem-sucedida:

**V2 → ACEITA**

**V1 → REJEITADA**

O comportamento da rotação deve ser validado quando implementado.

Os requisitos detalhados do ciclo de vida das credenciais são definidos no Capítulo 6.

### 5.14 Revogação

A revogação remove a confiança de uma identidade, credencial, certificado, *token*, permissão ou mecanismo de acesso equivalente.

Quando aplicável, a revogação deve entrar em vigor sem exigir o redesenho de partes não relacionadas da plataforma.

Exemplos incluem:

- desabilitar uma identidade humana;
- revogar uma credencial de serviço;
- remover uma permissão;
- invalidar um certificado;
- remover acesso temporário com privilégios elevados.

A recuperação não deve restaurar silenciosamente uma confiança revogada.

### 5.15 Testes de Autenticação e Autorização

Os controles de autenticação e autorização devem ser testados por meio de cenários positivos e negativos, sempre que possível.

Testes positivos representativos incluem:

- identidade válida autentica-se com sucesso;
- serviço autorizado acessa o recurso necessário;
- consumidor analítico aprovado lê a Certified Gold.

Testes negativos representativos incluem:

- credencial inválida ou revogada é rejeitada;
- identidade autenticada tem acesso negado a um recurso não autorizado;
- consumidor somente leitura não consegue modificar dados;
- identidade de serviço não consegue atravessar um limite de camada não autorizado.

O projeto detalhado dos testes e os requisitos de evidências são definidos no Capítulo 17.

### 5.16 Evidências de Autenticação e Autorização

As evidências de validação devem preservar contexto suficiente para demonstrar:

- identidade ou função testada;
- recurso de destino;
- operação solicitada;
- resultado esperado;
- resultado observado;
- evento de segurança relevante;
- PASS ou FAIL.

As evidências não devem expor credenciais reutilizáveis nem informações sensíveis desnecessárias.

### 5.17 Autenticação no Laboratório e no Ambiente Corporativo

A Versão 1 pode utilizar mecanismos de autenticação locais apropriados a um laboratório controlado.

O laboratório ainda deve demonstrar as propriedades lógicas de:

- acesso identificável;
- autenticação;
- autorização;
- privilégio mínimo;
- negação de operações proibidas;
- rotação ou revogação de credenciais, quando implementadas;
- auditabilidade.

Ambientes corporativos podem substituir mecanismos locais por identidade centralizada, identidade gerenciada de carga de trabalho, autenticação multifator, gerenciamento de acesso privilegiado ou controles equivalentes.

O mecanismo pode evoluir enquanto os limites necessários de autenticação e autorização permanecem estáveis.

### 5.18 Garantias de Autenticação e Autorização

O modelo de autenticação e autorização da Atlas Engineering deve preservar as seguintes garantias:

1. autenticação e autorização permanecem controles distintos;
2. autenticação bem-sucedida não implica acesso irrestrito;
3. autenticação humana e de serviço permanece atribuível sempre que tecnicamente possível;
4. a confiança não se propaga automaticamente através dos limites de serviço;
5. a autorização é delimitada aos recursos e operações necessários;
6. privilégios de leitura, gravação, administração, certificação, publicação e consumo permanecem distinguíveis;
7. operações administrativas exigem autorização elevada explícita;
8. modificação e publicação da Certified Gold permanecem distintas do consumo analítico comum;
9. a sensibilidade dos dados pode restringir ainda mais um acesso a recurso que, de outra forma, seria válido;
10. acessos inválidos, expirados, revogados ou não autorizados são rejeitados quando o mecanismo implementado oferece suporte à aplicação desse controle;
11. a negação de acesso proibido é tratada como comportamento de segurança bem-sucedido;
12. a rotação de credenciais invalida a confiança substituída quando implementada;
13. uma confiança revogada não é restaurada silenciosamente durante a recuperação;
14. comportamentos positivos e negativos de autorização podem ser validados;
15. as evidências demonstram os resultados sem expor credenciais reutilizáveis;
16. os mecanismos do laboratório podem evoluir sem redefinir os limites fundamentais de autenticação e autorização.

---

## 6. Gerenciamento de Segredos e Credenciais

Segredos e credenciais fornecem acesso a recursos protegidos da plataforma e, portanto, exigem controles ao longo de todo o seu ciclo de vida.

A Atlas Engineering trata material secreto como informação sensível à segurança, e não como configuração comum de aplicação.

O ciclo de vida governante é:

**Criação → Armazenamento Protegido → Distribuição Controlada → Uso → Rotação → Revogação → Descarte**

Uma credencial que tenha sido exposta ou invalidada não deve recuperar a confiança simplesmente porque permanece disponível no controle de versão, histórico de configurações, *backups*, *logs* ou artefatos de recuperação.

### 6.1 Classificação de Segredos

Material secreto inclui informações capazes de autenticar uma identidade, estabelecer confiança privilegiada, descriptografar informações protegidas ou, de outra forma, permitir acesso não autorizado caso sejam divulgadas.

Exemplos incluem:

- senhas;
- *tokens* de API;
- chaves de acesso;
- chaves privadas;
- segredos de cliente;
- *connection strings* contendo credenciais;
- material de chave privada de certificados;
- segredos de autenticação equivalentes.

Identificadores públicos, nomes de usuário, material público de certificados e configurações não sensíveis não são automaticamente segredos.

A classificação depende de a divulgação criar ou não um risco de segurança.

### 6.2 Segredos Não Devem Ser Commitados

Segredos reais não devem ser intencionalmente commitados no controle de versão.

Isso se aplica a:

- código-fonte;
- *scripts* SQL;
- definições de orquestração;
- configurações de infraestrutura;
- *notebooks*;
- documentação;
- arquivos de teste;
- exemplos;
- configurações exportadas.

O histórico do repositório também deve ser considerado, pois remover um segredo da versão atual não elimina a exposição anterior.

Uma credencial funcional commitada deve ser tratada como potencialmente comprometida.

### 6.3 Referências a Segredos

Configurações mantidas sob controle de versão devem referenciar segredos, em vez de conter seus valores reais.

Por exemplo:

`SQL_PASSWORD=<provided externally>`

`KAFKA_PASSWORD=<provided externally>`

`MINIO_SECRET_KEY=<provided externally>`

O repositório pode documentar:

- nomes dos segredos necessários;
- propósito esperado;
- serviço responsável;
- estrutura de configuração;
- instruções de provisionamento.

Ele não deve exigir a publicação do valor real do segredo.

### 6.4 Variáveis de Ambiente

Variáveis de ambiente podem ser utilizadas como mecanismo de injeção de segredos na Versão 1 quando apropriado ao laboratório local.

Elas separam os valores de execução das configurações commitadas, mas não são inerentemente seguras apenas por serem variáveis de ambiente.

Sua proteção ainda depende de:

- acesso ao *host*;
- isolamento de processos;
- comportamento de *logging*;
- configuração da orquestração;
- controles do sistema operacional.

Variáveis de ambiente são, portanto, um mecanismo de implementação, e não a própria arquitetura de segurança.

### 6.5 Armazenamento de Segredos

O armazenamento de segredos deve ser compatível com o ambiente de implantação e com a sensibilidade do recurso protegido.

A Versão 1 pode utilizar mecanismos locais protegidos apropriados a um laboratório controlado.

Ambientes corporativos podem utilizar plataformas centralizadas de gerenciamento de segredos.

Independentemente do mecanismo, o armazenamento de segredos deve impedir divulgação desnecessária e restringir o acesso às identidades que necessitam do segredo.

### 6.6 Credenciais Específicas por Serviço

Responsabilidades de serviço independentes devem utilizar credenciais separadas sempre que possível.

Por exemplo:

**Credencial do Debezium**
→ responsabilidades de captura da origem.

**Credencial do Processador Bronze**
→ consumo do Kafka e persistência na Bronze.

**Credencial do Processador Silver**
→ leitura da Bronze e gravação na Silver.

**Credencial do Power BI**
→ consumo analítico governado.

Uma única credencial irrestrita não deve se tornar o mecanismo de autenticação padrão para serviços não relacionados da plataforma.

### 6.7 Escopo das Credenciais

As credenciais devem conceder somente o acesso necessário à identidade e à responsabilidade que representam.

O escopo pode incluir:

- recurso;
- operação;
- conjunto de dados;
- camada arquitetural;
- ambiente;
- período de validade.

A posse de uma credencial não deve implicar autorização mais ampla do que a exigida pela responsabilidade associada.

### 6.8 Rotação de Credenciais

As credenciais devem poder ser substituídas sem exigir o redesenho do serviço que as utiliza.

Um ciclo de vida representativo de rotação é:

**Credencial V1 → Criar V2 → Distribuir V2 → Validar V2 → Revogar V1**

Sempre que operacionalmente possível, a rotação deve preservar a continuidade legítima do serviço enquanto reduz o período durante o qual credenciais substituídas permanecem válidas.

### 6.9 Revogação de Credenciais

As credenciais devem poder ser revogadas quando a confiança precisar ser encerrada.

Condições relevantes incluem:

- suspeita de exposição;
- comprometimento confirmado;
- desativação de serviço;
- remoção de identidade;
- alteração de privilégio;
- substituição de credencial;
- desativação de ambiente.

A revogação deve invalidar o uso futuro de acordo com as capacidades do mecanismo de autenticação implementado.

### 6.10 Exposição de Segredos

Um segredo deve ser tratado como exposto quando sua confidencialidade não puder mais ser razoavelmente presumida.

A resposta pode exigir:

**Detectar → Conter → Revogar → Substituir → Investigar → Validar**

Alterar a localização de um segredo exposto sem invalidá-lo não restaura a confiança.

### 6.11 Exposição no Controle de Versão

Um segredo funcional commitado no controle de versão deve ser tratado como potencialmente comprometido, mesmo que o repositório seja privado ou que o arquivo seja posteriormente excluído.

A remediação deve incluir, quando aplicável:

- revogar ou rotacionar o segredo;
- remover o segredo dos arquivos atuais;
- avaliar o histórico do repositório;
- identificar os recursos afetados;
- validar as credenciais substitutas.

A limpeza do repositório não substitui a revogação da credencial.

### 6.12 Segredos em Logs e Observabilidade

*Logs*, métricas, *traces*, *dashboards* e alertas não devem expor intencionalmente valores de segredos reutilizáveis.

Aplicações e componentes da plataforma devem evitar registrar:

- senhas;
- *tokens*;
- chaves privadas;
- *connection strings* completas contendo credenciais;
- material de autenticação reutilizável equivalente.

A observabilidade deve descrever eventos de segurança sem reproduzir o segredo envolvido.

### 6.13 Segredos em Evidências

As evidências de validação não devem conter segredos reutilizáveis.

Capturas de tela, saídas de terminal, *logs*, trechos de configuração e artefatos de teste devem ser revisados antes da publicação ou preservação de longo prazo.

Quando a redação de informações sensíveis for necessária, a evidência deve preservar contexto suficiente para demonstrar o comportamento testado sem revelar o valor protegido.

### 6.14 Segredos em Documentação e Exemplos

A documentação e os exemplos devem utilizar *placeholders*, valores sintéticos ou credenciais claramente inválidas.

Por exemplo:

`DB_PASSWORD=<SECRET>`

`KAFKA_USERNAME=<SERVICE_ACCOUNT>`

Os exemplos não devem incentivar a cópia de credenciais reais para arquivos mantidos sob controle de versão.

### 6.15 Backup e Recuperação de Segredos

A estratégia de *backup* deve considerar se material secreto é necessário para a recuperação.

Segredos não devem ser copiados para *backups* comuns apenas por conveniência.

Quando credenciais protegidas ou material de chaves precisarem ser recuperáveis, seu mecanismo de recuperação deve preservar a confidencialidade e as restrições de acesso apropriadas.

Um *backup* que contenha material sensível à segurança deve ser protegido de forma correspondente.

### 6.16 Recuperação de Segredos e Confiança Invalidada

A recuperação não deve restaurar a confiança em uma credencial que tenha sido revogada, comprometida, expirada ou invalidada de outra forma após a criação do ponto de recuperação.

A regra governante é:

**Recuperar Configuração ≠ Restaurar Confiança Histórica**

O estado atual de segurança tem precedência sobre o estado obsoleto de credenciais preservado em *backups* ou configurações históricas.

### 6.17 Responsabilidade por Segredos

Cada segredo operacional deve possuir um responsável identificável ou um serviço responsável, sempre que possível.

A responsabilidade deve permitir determinar:

- o que utiliza o segredo;
- qual recurso ele protege;
- quem ou o que é responsável pela rotação;
- quando ele pode ser revogado;
- o que pode ser afetado por sua substituição.

Credenciais sem responsabilidade definida criam riscos operacionais e de segurança.

### 6.18 Inventário e Metadados de Segredos

A plataforma deve manter metadados suficientes para governar credenciais importantes sem registrar seus valores.

Metadados relevantes podem incluir:

- identificador ou nome lógico do segredo;
- serviço responsável;
- recurso protegido;
- ambiente;
- tipo de credencial;
- responsável;
- estado no ciclo de vida;
- requisito de rotação;
- expiração, quando aplicável.

O inventário de segredos deve descrevê-los sem se transformar em outro repositório de segredos.

### 6.19 Ciclo de Vida dos Segredos

O gerenciamento de segredos abrange todo o ciclo de vida:

**Criar → Armazenar → Distribuir → Usar → Revisar → Rotacionar → Revogar → Descartar**

Os controles do ciclo de vida devem impedir que credenciais obsoletas permaneçam indefinidamente válidas ou não documentadas.

O estado das credenciais deve permanecer consistente com o modelo de identidade e acesso ao qual dão suporte.

### 6.20 Gerenciamento de Segredos no Laboratório

A Versão 1 pode utilizar arquivos locais protegidos, variáveis de ambiente, credenciais específicas por serviço, exclusões do controle de versão e outros mecanismos apropriados a um laboratório controlado.

O laboratório deve demonstrar as propriedades arquiteturais de:

- segredos externalizados;
- credenciais específicas por serviço;
- acesso delimitado;
- rotação;
- revogação;
- resposta à exposição;
- evidências seguras em relação a segredos.

O laboratório não reivindica equivalência com uma infraestrutura corporativa de gerenciamento de segredos.

### 6.21 Evolução para o Ambiente Corporativo

Uma implantação corporativa pode introduzir capacidades como:

- *vaults* centralizados de segredos;
- serviços gerenciados de segredos em nuvem;
- credenciais de curta duração;
- credenciais dinâmicas;
- identidades gerenciadas para cargas de trabalho;
- rotação automatizada;
- automação do ciclo de vida de certificados;
- proteção de chaves baseada em *hardware*;
- auditoria centralizada do acesso a segredos.

Esses mecanismos fortalecem a implementação enquanto preservam os mesmos requisitos de ciclo de vida e privilégio mínimo.

### 6.22 Varredura de Segredos

Os artefatos mantidos sob controle de versão devem poder ser verificados quanto à exposição acidental de segredos.

A varredura pode incluir:

- conteúdo do repositório;
- arquivos de configuração;
- *scripts*;
- documentação;
- artefatos gerados.

A varredura automatizada é valiosa, mas não garante a inexistência de segredos.

Um segredo funcional detectado exige a remediação da própria credencial, e não apenas a remoção do texto detectado.

### 6.23 Testes de Segredos e Credenciais

Os controles de gerenciamento de segredos devem ser testados sempre que possível.

Testes representativos incluem:

- o serviço necessário autentica-se com sua credencial válida;
- um serviço não relacionado não consegue utilizar essa credencial fora do escopo pretendido;
- a credencial substituta funciona após a rotação;
- a credencial substituída falha após a revogação;
- o repositório e os artefatos de evidência não expõem segredos funcionais;
- a recuperação não reativa credenciais invalidadas.

A estrutura detalhada dos testes de segurança é definida no Capítulo 17.

### 6.24 Evidências de Segredos e Credenciais

As evidências devem demonstrar o comportamento dos controles de gerenciamento de segredos sem revelar os valores dos segredos.

Evidências relevantes podem incluir:

- autenticação bem-sucedida com uma credencial válida;
- falha de autenticação após a revogação;
- sequência de rotação;
- resultado da varredura de segredos;
- configuração sanitizada;
- evento de auditoria;
- validação de recuperação.

As evidências devem demonstrar o controle, e não a própria credencial.

### 6.25 Garantias de Segredos e Credenciais

O modelo de segredos e credenciais da Atlas Engineering deve preservar as seguintes garantias:

1. segredos reais não são intencionalmente commitados no controle de versão;
2. configurações mantidas sob controle de versão referenciam segredos em vez de publicar seus valores;
3. variáveis de ambiente são tratadas como um mecanismo de injeção, e não como uma solução completa de segurança;
4. o armazenamento de segredos é apropriado ao ambiente de implantação e ao recurso protegido;
5. responsabilidades de serviço independentes utilizam credenciais separadas sempre que possível;
6. as credenciais permanecem delimitadas à responsabilidade pretendida;
7. as credenciais podem ser rotacionadas e revogadas de acordo com o mecanismo implementado;
8. credenciais expostas são tratadas como potencialmente comprometidas;
9. remover um segredo exposto de um arquivo não restaura a confiança de forma independente;
10. *logs*, observabilidade, documentação e evidências não expõem intencionalmente segredos reutilizáveis;
11. *backup* e recuperação preservam a proteção do material de segurança necessário;
12. a recuperação não restaura credenciais invalidadas a um estado confiável;
13. segredos importantes possuem responsabilidade identificável e metadados de ciclo de vida sempre que possível;
14. o inventário de segredos não contém os valores dos segredos que governa;
15. os mecanismos do laboratório demonstram o modelo lógico de gerenciamento de segredos sem serem apresentados como equivalentes a um *vault* corporativo;
16. mecanismos corporativos podem fortalecer o gerenciamento de segredos sem alterar os requisitos fundamentais do ciclo de vida;
17. a varredura de segredos auxilia na detecção, mas não substitui a remediação da credencial;
18. os controles de segredos implementados podem ser testados e evidenciados sem expor os valores protegidos.

---

## 7. Segurança de Rede e Comunicação entre Serviços

A segurança de rede e da comunicação entre serviços define como os componentes da Atlas Engineering se comunicam através de limites de confiança explícitos.

A existência de conectividade de rede não estabelece confiança nem autorização.

O modelo governante é:

**Comunicação Necessária → Exposição Controlada → Endpoint Autenticado → Interação Autorizada → Resultado Observável**

Os caminhos de comunicação devem existir porque uma responsabilidade arquitetural os exige, e não simplesmente porque os componentes são tecnicamente capazes de se comunicar entre si.

### 7.1 Exposição de Rede

Os componentes da plataforma devem expor somente as interfaces de rede e portas necessárias para suas responsabilidades definidas.

A exposição desnecessária aumenta a superfície de ataque e enfraquece os limites arquiteturais.

As decisões de exposição devem considerar:

- serviço que realiza a comunicação;
- protocolo necessário;
- origem e destino;
- requisitos administrativos;
- consumo analítico;
- observabilidade;
- ambiente de implantação.

O fato de um serviço estar acessível não implica que toda identidade capaz de alcançá-lo esteja autorizada a utilizá-lo.

### 7.2 Caminhos de Comunicação entre Serviços

Os caminhos de comunicação necessários devem ser identificáveis a partir da arquitetura.

Caminhos representativos da Versão 1 incluem:

**AtlasCommerce / SQL Server → Debezium**
→ captura de alterações.

**Debezium → Apicurio Registry**
→ interação com contratos de eventos quando necessária.

**Debezium → Kafka**
→ publicação de eventos.

**Kafka → Processamento Bronze**
→ consumo de eventos.

**Processamento Bronze → MinIO Bronze**
→ persistência bruta durável.

**MinIO Bronze → Processamento Silver**
→ entrada para transformação.

**Processamento Silver → MinIO Silver**
→ persistência confiável.

**MinIO Silver → Processamento Gold**
→ entrada para processamento dimensional.

**Processamento Gold → SQL Server Gold**
→ produção de candidatas.

**Certificação / Publicação → Certified Gold**
→ publicação analítica governada.

**Certified Gold → Power BI**
→ consumo analítico.

**Componentes da Plataforma → Observabilidade**
→ métricas, *logs* e sinais operacionais.

A comunicação fora dos caminhos documentados exige justificativa arquitetural explícita.

### 7.3 Limites de Confiança Explícitos

Cada relacionamento entre serviços atravessa um limite de confiança que deve ser avaliado de forma independente.

As considerações relevantes incluem:

- identidade;
- autenticação;
- autorização;
- protocolo;
- *endpoint*;
- exposição de rede;
- classificação dos dados;
- criptografia;
- auditabilidade.

A confiança em um relacionamento não deve se propagar automaticamente para outro.

Por exemplo:

**Debezium considerado confiável para ler os dados de CDC necessários**

não implica:

**Debezium considerado confiável para administrar o SQL Server**

ou:

**Debezium considerado confiável para administrar o Kafka**.

### 7.4 Segmentação de Rede

A segmentação de rede deve reduzir a comunicação desnecessária entre componentes.

A Versão 1 pode utilizar mecanismos lógicos como:

- redes de *containers*;
- regras de *firewall* do *host*;
- associação ao *localhost*;
- publicação seletiva de portas.

Implementações corporativas podem utilizar segmentação física ou virtual mais robusta.

O requisito arquitetural permanece:

**Somente os caminhos de comunicação necessários devem estar disponíveis.**

### 7.5 Comunicação East-West e North-South

A Atlas Engineering distingue conceitualmente entre:

**Comunicação East-West**
→ comunicação entre componentes internos da plataforma.

**Comunicação North-South**
→ comunicação que entra ou sai dos limites da plataforma.

Exemplos de comunicação *east-west* incluem:

- Debezium → Kafka;
- serviços de processamento → MinIO;
- Airflow → serviços de processamento;
- componentes da plataforma → serviços de observabilidade.

Exemplos de comunicação *north-south* podem incluir:

- Power BI → Certified Gold;
- acesso administrativo de um operador;
- integrações externas aprovadas.

Ambas as direções exigem limites de confiança controlados.

A comunicação interna não deve ser considerada inerentemente confiável apenas por permanecer dentro da plataforma.

### 7.6 Exposição Pública

Os principais serviços de processamento e armazenamento não devem ser expostos publicamente, a menos que exista um requisito documentado.

Componentes como:

- Kafka;
- MinIO;
- serviços internos de processamento;
- componentes internos de orquestração;
- *endpoints* administrativos de banco de dados;

devem normalmente permanecer dentro de limites de rede controlados.

Um serviço destinado ao uso interno da plataforma não deve se tornar externamente acessível apenas por conveniência.

### 7.7 Interfaces Administrativas

Interfaces administrativas exigem considerações de acesso mais rigorosas do que a comunicação comum entre serviços.

Exemplos podem incluir:

- administração de banco de dados;
- administração do Kafka;
- administração do armazenamento de objetos;
- administração da orquestração;
- administração da observabilidade;
- configuração de segurança.

Interfaces administrativas devem ser expostas somente quando necessário e protegidas por autenticação e autorização apropriadas.

Cargas de trabalho rotineiras não devem exigir acesso administrativo à rede.

### 7.8 Criptografia em Trânsito

A criptografia em trânsito protege dados e credenciais enquanto atravessam limites de comunicação.

Sua necessidade deve ser avaliada de acordo com:

- sensibilidade dos dados;
- limite de confiança;
- exposição de rede;
- mecanismo de autenticação;
- ambiente de implantação;
- requisitos aplicáveis.

A implantação local não elimina automaticamente a necessidade de avaliar a proteção do transporte.

Quando a criptografia em trânsito não estiver implementada na Versão 1, essa limitação deve permanecer explícita.

### 7.9 TLS e Confiança em Certificados

Quando TLS estiver implementado, a segurança dependerá não apenas da criptografia, mas também da validação apropriada dos certificados.

Os controles relevantes podem incluir:

- autoridades certificadoras confiáveis;
- validade dos certificados;
- validação do nome do *host* ou *endpoint*;
- monitoramento de expiração;
- configuração segura do protocolo.

Uma conexão que tenha sucesso somente porque a validação do certificado está desabilitada não deve ser apresentada como segurança TLS totalmente validada.

### 7.10 Autenticação Mútua

Alguns caminhos de comunicação corporativos podem exigir que ambos os *endpoints* autentiquem um ao outro.

TLS mútuo ou mecanismos equivalentes podem fornecer confiança mais robusta entre serviços quando apropriado.

A Versão 1 não exige autenticação mútua para todos os caminhos de comunicação internos.

O requisito arquitetural é que a robustez da autenticação permaneça apropriada ao limite de confiança e ao risco que está sendo protegido.

### 7.11 Proteção de Credenciais Durante o Transporte

O material de autenticação não deve ser exposto desnecessariamente durante a comunicação de rede.

As credenciais não devem ser:

- transmitidas por canais desprotegidos quando a proteção for necessária;
- incorporadas desnecessariamente em URLs;
- expostas em *query strings*;
- reproduzidas em *logs*;
- incluídas em mensagens de erro.

A proteção do transporte e o gerenciamento de segredos devem funcionar em conjunto.

A criptografia protege as credenciais em trânsito; ela não corrige o tratamento inadequado de credenciais nos *endpoints*.

### 7.12 DNS, Hostnames e Configuração de Endpoints

Os *endpoints* dos serviços devem ser definidos por meio de configuração controlada, em vez de depender de suposições desnecessariamente codificadas de forma fixa.

A configuração de *endpoints* pode incluir:

- *hostname*;
- porta;
- protocolo;
- nome do serviço;
- endereço específico do ambiente.

Isso permite a evolução do ambiente sem alterar a arquitetura lógica de comunicação.

A configuração de *endpoints* não deve conter material secreto quando um mecanismo separado para segredos for apropriado.

### 7.13 Comunicação da Orquestração

O Airflow requer comunicação com os serviços ou cargas de trabalho que coordena.

O acesso da orquestração deve ser limitado às interfaces necessárias para:

- acionar o processamento;
- inspecionar o estado da execução;
- obter as informações operacionais necessárias;
- coordenar dependências.

O Airflow não exige automaticamente acesso administrativo irrestrito a todos os componentes que orquestra.

A responsabilidade pela orquestração e a administração da plataforma permanecem distintas.

### 7.14 Comunicação da Observabilidade

Métricas, *logs*, informações de integridade e outros sinais operacionais exigem comunicação entre os componentes da plataforma e os serviços de observabilidade.

Os caminhos de observabilidade devem expor somente as informações necessárias para monitoramento e investigação.

Eles não devem se transformar em um caminho não controlado para:

- divulgação de segredos;
- dados pessoais desnecessários;
- replicação de dados de negócio;
- acesso administrativo.

A conectividade de observabilidade não implica autoridade administrativa sobre o componente monitorado.

### 7.15 Comunicação de Consumidores Analíticos

Os consumidores analíticos devem se comunicar por meio de interfaces governadas de consumo.

Para a Versão 1:

**Power BI → Certified Gold**

é o limite de comunicação analítica pretendido.

O Power BI não deve exigir acesso direto de rede ao Kafka, Bronze, Silver ou aos serviços internos de processamento para o consumo analítico comum.

Isso reduz o acoplamento e limita a exposição desnecessária da plataforma.

### 7.16 Comportamento em Falhas de Rede

Falhas de rede devem ser tratadas como uma condição operacional, e não como justificativa para contornar controles de segurança.

Exemplos incluem:

- indisponibilidade temporária do SQL Server;
- perda de conectividade com o Kafka;
- perda de conectividade com o MinIO;
- indisponibilidade do *registry*;
- falha de conectividade com a observabilidade;
- falha de conectividade com a Certified Gold.

A recuperação deve restaurar o caminho de comunicação pretendido.

Ela não deve depender da abertura permanente de acessos de rede mais amplos, da desativação da autenticação ou do desvio da validação de certificados apenas para restaurar a conectividade.

### 7.17 Observabilidade de Rede e Comunicação

Falhas de comunicação e condições relevantes de segurança devem ser observáveis quando houver suporte técnico para isso.

Sinais úteis podem incluir:

- falhas de conexão;
- falhas de autenticação;
- falhas de TLS;
- expiração de certificados;
- *endpoints* inacessíveis;
- conexões negadas repetidamente;
- exposição inesperada;
- padrões anormais de comunicação.

Os requisitos detalhados de observabilidade de segurança são definidos no Capítulo 14.

### 7.18 Inventário de Comunicação

A plataforma deve ser capaz de documentar relacionamentos significativos de comunicação.

Um inventário de comunicação pode registrar:

- origem;
- destino;
- protocolo;
- porta;
- propósito;
- mecanismo de autenticação;
- estado da criptografia;
- serviço responsável;
- ambiente.

O inventário deve descrever a comunicação necessária sem expor valores de segredos.

Posteriormente, ele pode dar suporte à revisão da arquitetura, *troubleshooting*, validação de segurança e migração para o ambiente corporativo.

### 7.19 Governança de Alterações de Rede

Alterações que criem ou modifiquem caminhos de comunicação devem ser avaliadas quanto ao impacto de segurança.

Exemplos incluem:

- expor uma nova porta;
- adicionar um consumidor externo;
- alterar um protocolo;
- desabilitar TLS;
- adicionar uma interface administrativa;
- alterar a segmentação de rede;
- introduzir uma nova dependência de serviço.

Uma conexão tecnicamente bem-sucedida não constitui justificativa suficiente para tornar o caminho permanente.

### 7.20 Modelo de Rede do Laboratório

A Versão 1 pode executar diversos componentes em uma única estação de trabalho física.

Os limites lógicos podem, portanto, depender de:

- isolamento de *containers*;
- publicação controlada de portas do *host*;
- comportamento do *firewall* local;
- autenticação de serviços;
- configuração explícita de *endpoints*.

Essa topologia não consegue reproduzir todos os controles corporativos de segurança de rede.

Ainda assim, ela pode demonstrar os princípios lógicos de exposição controlada, caminhos explícitos de comunicação, autenticação, autorização e falha observável.

### 7.21 Evolução para o Ambiente Corporativo

Uma implantação corporativa pode fortalecer a segurança de rede e comunicação por meio de capacidades como:

- sub-redes privadas;
- *security groups*;
- políticas de *firewall*;
- listas de controle de acesso à rede;
- *private endpoints*;
- controle de *ingress* e *egress*;
- *service meshes*;
- infraestrutura gerenciada de certificados;
- monitoramento de fluxo de rede;
- acesso à rede baseado em *zero trust*.

Esses mecanismos podem substituir os controles do laboratório sem alterar os relacionamentos fundamentais de comunicação definidos pela arquitetura.

### 7.22 Testes de Rede e Comunicação

Os controles de rede devem ser testados por meio de cenários de comunicação necessária e proibida, sempre que possível.

Testes representativos incluem:

- o serviço necessário alcança seu *endpoint* aprovado;
- uma porta desnecessária não está externamente acessível;
- uma identidade não autorizada não consegue utilizar um serviço acessível;
- uma conexão TLS protegida é bem-sucedida com confiança válida;
- um certificado inválido é rejeitado quando a validação é necessária;
- o consumidor analítico alcança a Certified Gold sem exigir acesso ao processamento *upstream*;
- o serviço se recupera após uma interrupção temporária de rede sem enfraquecer os controles de segurança.

A metodologia detalhada de validação é definida no Capítulo 17.

### 7.23 Evidências de Rede e Comunicação

As evidências devem demonstrar o comportamento da comunicação sem expor credenciais ou configurações sensíveis desnecessárias.

Evidências relevantes podem incluir:

- conexão necessária bem-sucedida;
- conexão proibida rejeitada;
- estado de exposição de portas;
- resultado da validação TLS;
- *log* de serviço;
- métrica relacionada à rede;
- resultado da recuperação;
- inventário de comunicação sanitizado.

As evidências devem identificar o limite testado e o comportamento esperado.

### 7.24 Garantias de Rede e Comunicação entre Serviços

O modelo de rede e comunicação entre serviços da Atlas Engineering deve preservar as seguintes garantias:

1. os caminhos de comunicação existem para responsabilidades arquiteturais definidas;
2. a acessibilidade de rede não implica confiança nem autorização;
3. a exposição desnecessária de serviços é evitada;
4. a confiança é avaliada de forma independente em cada limite de serviço;
5. a comunicação interna não é automaticamente considerada confiável;
6. a segmentação de rede limita a comunicação desnecessária sempre que tecnicamente possível;
7. os principais serviços de processamento e armazenamento não são expostos publicamente sem justificativa documentada;
8. interfaces administrativas permanecem distintas da comunicação rotineira entre serviços;
9. a criptografia em trânsito é avaliada de acordo com o risco e o limite de confiança;
10. afirmações sobre TLS exigem validação apropriada de certificados quando implementado;
11. o tratamento de credenciais permanece protegido tanto nos limites de transporte quanto nos *endpoints*;
12. a configuração de *endpoints* permanece separável dos valores de segredos quando apropriado;
13. o acesso da orquestração não implica automaticamente administração irrestrita da plataforma;
14. a comunicação da observabilidade não se transforma em um caminho não controlado para dados sensíveis ou acesso administrativo;
15. consumidores analíticos utilizam limites governados de consumo em vez de conectividade *upstream* desnecessária;
16. falhas de rede não justificam o enfraquecimento permanente dos controles de segurança;
17. falhas relevantes de comunicação e segurança permanecem observáveis quando houver suporte técnico para isso;
18. relacionamentos significativos de comunicação podem ser documentados sem expor segredos;
19. alterações de comunicação estão sujeitas à revisão de segurança;
20. as restrições físicas do laboratório não redefinem os limites lógicos de comunicação;
21. mecanismos corporativos de rede podem fortalecer a aplicação dos controles sem alterar a arquitetura fundamental;
22. comportamentos de comunicação necessária e proibida podem ser testados e evidenciados sempre que possível.

---

## 8. Proteção de Dados e Criptografia

A proteção de dados define como a Atlas Engineering protege as informações ao longo de todo o seu ciclo de vida.

Os requisitos de proteção se aplicam enquanto os dados são:

- capturados;
- transmitidos;
- persistidos;
- transformados;
- consumidos;
- incluídos em *backups*;
- exportados;
- retidos;
- recuperados;
- descartados.

A criptografia é um dos mecanismos de proteção dentro desse modelo mais amplo.

O princípio governante é:

**Dados Necessários → Classificação → Proteção Apropriada → Acesso Controlado → Ciclo de Vida Governado**

A proteção deve refletir a sensibilidade, o propósito, a localização, a exposição e o ciclo de vida dos dados, em vez de depender de um único controle universal.

### 8.1 Escopo da Proteção de Dados

A proteção de dados se aplica onde quer que as informações da plataforma existam ou sejam movimentadas.

Os locais relevantes incluem:

- AtlasCommerce;
- estruturas de CDC;
- eventos;
- Kafka;
- Bronze;
- Silver;
- Gold;
- Certified Gold;
- artefatos temporários;
- quarentena;
- *backups*;
- *logs*;
- métricas;
- metadados;
- evidências de validação;
- dados exportados.

Os requisitos de proteção podem variar entre esses locais.

Um conjunto de dados não exige automaticamente controles idênticos em todas as etapas de seu ciclo de vida.

### 8.2 Proteção de Acordo com a Classificação dos Dados

Os mecanismos de proteção devem ser selecionados de acordo com a classificação e o propósito dos dados.

Os fatores relevantes podem incluir:

- conteúdo pessoal ou sensível;
- informações confidenciais de negócio;
- informações sensíveis à segurança;
- propósito analítico;
- uso operacional ou histórico;
- requisitos de recuperação;
- exposição externa;
- requisitos aplicáveis de privacidade, contratuais, organizacionais ou regulatórios.

A classificação deve influenciar as decisões de tratamento, em vez de existir apenas como metadado descritivo.

O modelo de classificação é definido no Capítulo 9.

### 8.3 Criptografia em Trânsito

Os dados devem ser avaliados quanto à proteção enquanto se movimentam entre os componentes da plataforma.

Os caminhos de comunicação relevantes incluem:

- SQL Server → Debezium;
- Debezium → Kafka;
- Kafka → consumidores;
- cargas de processamento → MinIO;
- cargas de processamento → SQL Server;
- comunicação de orquestração;
- comunicação de observabilidade;
- Certified Gold → consumidores analíticos.

Quando a criptografia em trânsito for necessária, a implementação deve utilizar proteção apropriada ao protocolo, limite de confiança, sensibilidade dos dados e ambiente de implantação.

A proteção do transporte se aplica tanto aos dados quanto às credenciais transportadas pela conexão.

Os requisitos detalhados de segurança da comunicação são definidos no Capítulo 7.

### 8.4 Criptografia em Repouso

Os dados persistidos devem ser avaliados quanto à proteção em repouso.

Os locais de persistência relevantes incluem:

- arquivos de dados e de *log* do SQL Server;
- registros persistidos no Kafka;
- objetos do MinIO;
- conjuntos de dados Bronze e Silver;
- estruturas Gold e Certified Gold;
- *backups*;
- artefatos temporários;
- metadados sensíveis à segurança.

A criptografia em repouso pode ser implementada em diferentes camadas, incluindo:

- nível de aplicação ou dos dados;
- nível de banco de dados;
- nível do serviço de armazenamento;
- nível de sistema de arquivos;
- nível de volume ou disco;
- nível de infraestrutura ou serviço de nuvem.

O mecanismo selecionado deve refletir o ambiente de implantação, o modelo de ameaças, a classificação, os requisitos operacionais e as capacidades da tecnologia.

### 8.5 Criptografia Não Substitui Autorização

Criptografia e autorização tratam riscos diferentes.

Dados criptografados ainda podem ser expostos se uma identidade possuir permissões excessivas para acessá-los após a descriptografia.

O modelo de segurança, portanto, exige:

**Criptografia + Autenticação + Autorização + Privilégio Mínimo**

Uma identidade com privilégios amplos não se torna adequadamente restrita apenas porque a comunicação ou o armazenamento subjacente está criptografado.

### 8.6 Criptografia Não Substitui Minimização de Dados

A criptografia não justifica coleta, propagação ou retenção desnecessárias.

Para informações sensíveis, a sequência preferencial é:

**Os dados são necessários?**

Se não:

**Não os propague nem persista desnecessariamente.**

Se sim:

**Aplique proteção apropriada à sua classificação, propósito e exposição.**

Reduzir dados desnecessários reduz tanto o risco de segurança quanto a complexidade da governança.

### 8.7 Proteção dos Dados da Origem

O AtlasCommerce é a origem operacional autoritativa e pode conter informações que os produtos analíticos *downstream* não exigem.

O acesso à origem deve, portanto, permanecer controlado de forma independente.

A captura de alterações não justifica acesso irrestrito ao banco de dados operacional.

A identidade de captura deve acessar somente as estruturas e operações necessárias para sua responsabilidade.

Atributos sensíveis devem ser avaliados antes de sua propagação *downstream*.

### 8.8 Proteção de Eventos e Dados do Kafka

Os eventos podem conter dados de negócio e metadados técnicos derivados da origem operacional.

O projeto dos eventos deve, portanto, avaliar se cada atributo propagado é necessário *downstream*.

A proteção do Kafka deve considerar:

- autorização de produtores e consumidores;
- escopo dos tópicos;
- dados de eventos persistidos;
- proteção do transporte;
- retenção;
- acesso operacional;
- acesso administrativo.

O Kafka não é um meio de transporte neutro em relação à segurança.

Os dados permanecem sujeitos aos requisitos de proteção enquanto estiverem retidos no Kafka.

### 8.9 Proteção dos Dados da Bronze

A Bronze preserva eventos históricos derivados da origem com transformação mínima.

Como a Bronze pode reter atributos posteriormente removidos, generalizados, mascarados ou transformados de outra forma, ela pode conter informações mais sensíveis do que as camadas analíticas *downstream*.

O acesso à Bronze deve, portanto, permanecer restrito às responsabilidades que exigem acesso histórico, de processamento, recuperação, governança ou investigação autorizada.

Seu valor para *replay* não justifica consumo irrestrito.

### 8.10 Proteção dos Dados da Silver

A Silver contém dados padronizados, normalizados, deduplicados e sensíveis aos contratos.

A transformação pode reduzir a exposição desnecessária, mas a Silver permanece uma camada de processamento, e não o limite geral de consumo analítico.

O acesso deve permanecer limitado às cargas de trabalho e funções com responsabilidades definidas de processamento, validação, governança ou suporte.

Atributos sensíveis que não sejam mais necessários *downstream* devem ser removidos ou adequadamente transformados de acordo com o projeto de dados governado.

### 8.11 Proteção dos Dados da Gold

A Gold organiza os dados para processamento analítico governado.

Nem toda estrutura da Gold é necessariamente apropriada para consumo analítico direto.

Estruturas dimensionais internas, estados candidatos, metadados de processamento, informações de reconciliação e mecanismos de certificação podem exigir acessos diferentes da representação final publicada.

O processamento da Gold e o consumo da Certified Gold permanecem, portanto, limites distintos de proteção.

### 8.12 Proteção da Certified Gold

A Certified Gold é o limite governado de publicação analítica.

Os conjuntos de dados publicados devem expor somente os atributos necessários para seu propósito analítico definido.

Quando informações sensíveis continuarem sendo necessárias, a proteção deve considerar:

- propósito do consumidor;
- classificação;
- autorização;
- requisitos de privacidade;
- necessidade analítica.

Os consumidores analíticos devem receber a representação governada necessária ao seu propósito, em vez de acesso *upstream* irrestrito.

### 8.13 Dados Temporários

Dados temporários permanecem sujeitos aos requisitos de proteção.

Exemplos incluem:

- arquivos intermediários;
- tabelas temporárias;
- objetos de *staging*;
- saídas parciais;
- *caches*;
- amostras extraídas;
- arquivos de diagnóstico.

Artefatos temporários devem ser considerados quanto a:

- controle de acesso;
- exposição de dados sensíveis;
- criptografia quando apropriado;
- limpeza;
- recuperação após falhas.

O caráter temporário não deve se tornar justificativa para cópias de longo prazo não gerenciadas de informações governadas.

### 8.14 Dados em Quarentena

Registros em quarentena podem conter as mesmas informações sensíveis que registros processados com sucesso.

A quarentena deve, portanto, permanecer uma área governada.

O acesso deve ser limitado às responsabilidades que exijam:

- investigação;
- correção;
- reprocessamento;
- governança;
- suporte autorizado.

Os requisitos de retenção e descarte continuam aplicáveis.

### 8.15 Proteção de Backups

Os *backups* herdam a sensibilidade das informações que preservam.

A proteção deve considerar:

- acesso ao armazenamento;
- criptografia;
- transporte;
- proteção de credenciais;
- retenção;
- duplicação;
- autorização para restauração;
- descarte seguro.

Quando dados criptografados exigirem material criptográfico para restauração, a proteção e a capacidade de recuperação desse material passam a fazer parte do projeto de *backup*.

### 8.16 Gerenciamento de Chaves de Criptografia

Chaves criptográficas são ativos sensíveis à segurança.

Quando mecanismos de criptografia exigirem chaves gerenciadas, seu ciclo de vida deve considerar:

- geração;
- armazenamento protegido;
- uso autorizado;
- separação dos dados protegidos quando apropriado;
- rotação;
- expiração;
- retirada de uso;
- recuperação quando necessária;
- destruição.

O mecanismo exato depende da tecnologia de criptografia selecionada e do ambiente de implantação.

A criptografia é tão confiável quanto a proteção das chaves das quais depende.

### 8.17 Rotação de Chaves

Quando houver suporte ou exigência, a rotação de chaves deve preservar tanto a segurança quanto a disponibilidade legítima dos dados.

A rotação pode precisar considerar:

- novas gravações;
- dados criptografados existentes;
- dados históricos;
- *backups*;
- procedimentos de recuperação;
- identificação da versão da chave;
- retirada de chaves anteriores.

Uma chave não deve ser destruída enquanto dados legitimamente retidos ainda dependerem dela, a menos que esses dados tenham sido recriptografados com segurança ou estejam sendo intencionalmente tornados irrecuperáveis.

### 8.18 Recuperação de Chaves

O planejamento de recuperação deve incluir as dependências criptográficas necessárias.

Um *backup* que não possa ser descriptografado porque sua chave necessária está indisponível não é um ativo de recuperação utilizável.

A recuperação de chaves deve, portanto, equilibrar:

- disponibilidade;
- confidencialidade;
- integridade;
- autorização;
- separação de responsabilidades;
- auditabilidade.

Cópias recuperáveis de chaves são, por si só, ativos sensíveis à segurança.

### 8.19 Comprometimento de Chaves

Uma chave cuja confidencialidade não possa mais ser razoavelmente considerada confiável deve ser tratada como comprometida.

A resposta pode exigir:

**Conter → Substituir → Recriptografar Quando Aplicável → Retirar ou Revogar → Investigar → Validar**

A recuperação não deve restaurar silenciosamente a confiança em uma chave histórica comprometida.

### 8.20 Logs e Dados Sensíveis

*Logs* operacionais não devem se transformar em réplicas não controladas dos dados de negócio.

O *logging* deve preservar contexto suficiente para operação e investigação sem registrar desnecessariamente *payloads* sensíveis completos.

Sempre que possível, o contexto de diagnóstico deve priorizar:

- identificadores;
- metadados de correlação;
- classificações;
- resumos controlados;
- representações protegidas.

Segredos não devem ser intencionalmente registrados em *logs*.

Os requisitos detalhados de auditabilidade são definidos no Capítulo 14.

### 8.21 Métricas e Dados Sensíveis

As métricas devem descrever o comportamento da plataforma, em vez de reproduzir registros de negócio.

Métricas representativas incluem:

- contagens de eventos;
- *throughput*;
- latência;
- contagens de erros;
- *backlog*;
- resultados de qualidade;
- estado de certificação.

*Labels* e dimensões exigem atenção especial porque valores específicos de registros ou usuários podem expor informações sensíveis ou criar cardinalidade desnecessária.

Dados pessoais não devem ser introduzidos em métricas apenas por conveniência de *troubleshooting*.

### 8.22 Evidências e Dados Sensíveis

As evidências de validação devem comprovar o comportamento da plataforma sem reproduzir desnecessariamente informações protegidas.

As evidências podem utilizar:

- dados sintéticos de teste;
- identificadores;
- valores ocultados;
- *logs* sanitizados;
- capturas de tela controladas;
- resultados resumidos.

Evidências públicas exigem atenção especial porque a publicação no repositório altera o limite de exposição.

Os requisitos de evidências são detalhados no Capítulo 17.

### 8.23 Dados de Ambientes Não Produtivos

Ambientes não produtivos não exigem automaticamente cópias irrestritas de dados de produção.

Quando dados representativos forem necessários para desenvolvimento, testes ou validação, as opções preferenciais devem ser avaliadas nesta ordem, sempre que possível:

**Dados Sintéticos → Dados Reduzidos ou Transformados → Dados Reais Controlados Quando Justificados**

O uso de dados reais sensíveis fora de seu ambiente operacional exige justificativa explícita e proteção apropriada.

O laboratório da Versão 1 deve priorizar dados sintéticos controlados sempre que eles puderem validar o comportamento necessário.

### 8.24 Exportação de Dados

A exportação de dados cria uma nova cópia e, potencialmente, um novo limite de proteção.

As exportações podem incluir:

- extratos analíticos;
- arquivos CSV;
- planilhas;
- amostras para *troubleshooting*;
- evidências;
- *backups*;
- transferências de dados.

Antes da exportação, a plataforma ou o operador responsável deve considerar:

- propósito;
- classificação;
- destinatário;
- atributos necessários;
- destino de armazenamento;
- proteção;
- retenção;
- descarte.

A autorização para consultar dados não justifica automaticamente sua exportação irrestrita.

### 8.25 Proteção de Dados Durante a Recuperação

As operações de recuperação devem preservar os controles de proteção de dados aplicáveis.

A recuperação não deve exigir permanentemente:

- desabilitar a autorização;
- expor armazenamento protegido;
- publicar dados sensíveis;
- restaurar credenciais ou chaves invalidadas;
- contornar limites analíticos governados.

O acesso temporário com privilégios elevados, quando necessário, deve permanecer explícito e controlado.

Os dados restaurados permanecem sujeitos aos mesmos requisitos aplicáveis de classificação e proteção do estado governado original.

### 8.26 Proteção de Dados e Retenção

As responsabilidades de proteção continuam enquanto cópias governadas dos dados permanecerem retidas.

As decisões de retenção devem, portanto, considerar:

- sensibilidade;
- propósito operacional;
- valor histórico;
- requisitos de *replay*;
- requisitos de *backup*;
- requisitos de privacidade;
- risco de segurança.

Uma retenção mais longa aumenta o período durante o qual as informações protegidas devem permanecer governadas.

As regras detalhadas de retenção são definidas no Capítulo 13.

### 8.27 Descarte Seguro

O descarte deve considerar mais do que a exclusão do conjunto de dados ativo.

Cópias relevantes podem existir em:

- retenção do Kafka;
- histórico da Bronze;
- *backups*;
- artefatos temporários;
- quarentena;
- arquivos exportados;
- evidências;
- armazenamento arquivado.

O mecanismo apropriado de descarte depende da tecnologia de armazenamento, do mecanismo de proteção, do requisito de retenção e da sensibilidade dos dados.

Os requisitos de descarte são definidos em maior detalhe no Capítulo 13.

### 8.28 Proteção de Dados no Laboratório

A Versão 1 implementa controles de proteção de dados dentro das restrições de um ambiente local controlado de treinamento.

O laboratório deve demonstrar, quando aplicável:

- acesso controlado;
- minimização de dados;
- separação entre os limites de processamento e consumo;
- tratamento protegido de credenciais;
- proteção em trânsito;
- proteção em repouso;
- *backups* protegidos;
- controle de dados temporários e em quarentena;
- *logs*, métricas e evidências seguros em relação a dados sensíveis.

Nem toda capacidade corporativa de criptografia ou gerenciamento de chaves precisa existir localmente para que a arquitetura seja válida.

Qualquer controle não implementado deve permanecer explicitamente distinguível de um controle implementado e validado.

### 8.29 Evolução para o Ambiente Corporativo

Uma implantação corporativa pode fortalecer a proteção de dados por meio de capacidades como:

- serviços gerenciados de criptografia;
- gerenciamento centralizado de chaves;
- proteção de chaves baseada em *hardware*;
- rotação automatizada de chaves;
- infraestrutura gerenciada de certificados;
- *tokenization*;
- pseudonimização;
- mascaramento dinâmico;
- prevenção contra perda de dados;
- proteção corporativa de *backups*;
- aplicação centralizada de políticas.

Esses mecanismos podem fortalecer a implementação sem alterar os limites fundamentais de proteção de dados.

### 8.30 Testes de Proteção de Dados

Os controles implementados devem ser validados de acordo com os mecanismos selecionados para a Versão 1.

Testes representativos podem verificar:

- acesso autorizado e proibido a dados protegidos;
- proteção em trânsito configurada;
- proteção em repouso quando implementada;
- ausência de atributos sensíveis desnecessários *downstream*;
- proteção de dados temporários e em quarentena;
- *logs* e métricas seguros em relação a dados sensíveis;
- comportamento protegido de *backup* e restauração;
- exportação controlada;
- ausência de informações sensíveis em evidências públicas.

O comportamento esperado deve ser definido antes da execução.

A metodologia detalhada de validação é definida no Capítulo 17.

### 8.31 Evidências de Proteção de Dados

As evidências devem demonstrar o comportamento de proteção implementado sem reproduzir desnecessariamente as informações protegidas.

Evidências relevantes podem identificar:

- identificador do teste;
- classificação;
- camada arquitetural;
- mecanismo de proteção;
- comportamento esperado;
- comportamento observado;
- estado de acesso ou criptografia;
- versão da implementação;
- conclusão.

Valores sensíveis devem ser ocultados ou substituídos por dados de teste controlados quando seus valores reais não forem necessários para comprovar o controle.

### 8.32 Garantias de Proteção de Dados e Criptografia

O modelo de proteção de dados da Atlas Engineering deve preservar as seguintes garantias:

1. a proteção de dados se aplica ao longo de todo o ciclo de vida governado dos dados;
2. os requisitos de proteção refletem classificação, propósito, exposição e ciclo de vida;
3. a criptografia complementa, em vez de substituir, autenticação, autorização e privilégio mínimo;
4. a criptografia não justifica propagação ou retenção desnecessárias;
5. o acesso à origem permanece controlado independentemente do acesso analítico *downstream*;
6. Kafka e Bronze permanecem locais de persistência de dados protegidos;
7. as camadas de processamento permanecem distintas do limite de consumo da Certified Gold;
8. dados temporários e em quarentena permanecem governados;
9. *backups* herdam os requisitos de proteção dos dados que preservam;
10. chaves criptográficas são protegidas como ativos sensíveis à segurança quando aplicável;
11. o ciclo de vida e a capacidade de recuperação das chaves permanecem consistentes com a retenção dos dados criptografados;
12. chaves comprometidas não recuperam confiança por meio da recuperação;
13. *logs*, métricas e evidências não se tornam intencionalmente cópias não controladas de dados sensíveis;
14. o uso em ambientes não produtivos não justifica automaticamente dados irrestritos de produção;
15. a exportação de dados cria um novo limite governado de proteção;
16. a recuperação preserva os controles de proteção de dados aplicáveis;
17. a proteção continua durante todo o período de retenção governada;
18. o descarte considera cópias retidas, exportadas, arquivadas e recuperáveis;
19. os controles do laboratório permanecem distinguíveis de mecanismos equivalentes de ambiente corporativo;
20. os controles de proteção implementados são testáveis e baseados em evidências;
21. as afirmações de segurança permanecem limitadas ao comportamento efetivamente implementado e validado.

---

## 9. Classificação de Dados e Dados Sensíveis

A classificação de dados define como a Atlas Engineering identifica a sensibilidade das informações governadas e conecta essa sensibilidade a requisitos reais de tratamento.

A classificação não é apenas um metadado descritivo.

Ela deve influenciar, quando aplicável:

- acesso;
- propagação;
- proteção;
- observabilidade;
- exposição analítica;
- retenção;
- exportação;
- evidências;
- descarte.

O modelo inicial de classificação é:

**Público → Interno → Confidencial → Restrito**

A classificação é avaliada de acordo com o conteúdo, propósito, exposição e risco das informações, e não exclusivamente de acordo com a tecnologia ou camada arquitetural em que elas estão armazenadas.

A condição de dado pessoal, a sensibilidade de negócio e a sensibilidade de segurança são considerações relacionadas, mas permanecem conceitos distintos.

### 9.1 Modelo de Classificação

A Atlas Engineering utiliza quatro níveis iniciais de classificação de segurança:

1. **Público**
2. **Interno**
3. **Confidencial**
4. **Restrito**

Os níveis representam uma sensibilidade crescente e, portanto, requisitos de tratamento potencialmente mais rigorosos.

A classificação deve refletir a própria informação e seu uso pretendido, e não apenas seu local de armazenamento.

A ausência de uma decisão de classificação não implica que os dados sejam Públicos.

### 9.2 Dados Públicos

Dados Públicos são informações intencionalmente aprovadas para divulgação externa irrestrita.

Exemplos podem incluir:

- documentação técnica publicada;
- descrições públicas da arquitetura;
- exemplos sintéticos intencionalmente publicados;
- conteúdo não sensível do repositório.

A classificação como Público deve ser explícita.

Uma informação não se torna Pública apenas porque existe em um ambiente de demonstração ou laboratório.

### 9.3 Dados Internos

Dados Internos destinam-se ao uso da plataforma, engenharia, operação ou organização, mas normalmente não apresentam o mesmo risco de divulgação que informações Confidenciais ou Restritas.

Exemplos podem incluir:

- metadados operacionais não sensíveis;
- estado interno de processamento;
- configuração técnica sem credenciais;
- estatísticas de qualidade não sensíveis;
- informações de observabilidade não sensíveis.

Dados Internos não são automaticamente apropriados para divulgação pública.

Seu uso ainda deve respeitar o propósito arquitetural e os limites de acesso.

### 9.4 Dados Confidenciais

Dados Confidenciais são informações cuja divulgação não autorizada pode criar riscos de negócio, privacidade, operação ou segurança.

Exemplos podem incluir:

- transações detalhadas de negócio;
- informações comerciais não públicas;
- informações relacionadas a clientes;
- conjuntos de dados analíticos internos;
- informações operacionais detalhadas;
- metadados sensíveis.

Dados Confidenciais exigem acesso controlado.

A acessibilidade técnica ou autenticação bem-sucedida não justificam, de forma independente, o acesso.

### 9.5 Dados Restritos

Dados Restritos representam o nível mais elevado de sensibilidade no modelo de classificação da Atlas Engineering.

Exemplos podem incluir:

- segredos de autenticação;
- chaves criptográficas privadas;
- credenciais de segurança;
- informações pessoais altamente sensíveis, quando aplicável;
- informações administrativas sensíveis à segurança;
- informações cuja divulgação possa comprometer diretamente a segurança da plataforma.

Dados Restritos exigem os controles de tratamento aplicáveis mais rigorosos.

O acesso deve ser limitado a identidades com um requisito operacional, de segurança, jurídico ou de governança explícito.

Valores Restritos não devem aparecer intencionalmente em repositórios públicos, *logs* comuns, *dashboards*, capturas de tela ou evidências públicas.

### 9.6 A Classificação É Independente da Camada Arquitetural

A camada arquitetural e a classificação de segurança são conceitos relacionados, mas distintos.

Por exemplo:

- a Bronze pode conter informações em diferentes níveis de classificação, dependendo do conteúdo de sua origem;
- a Silver pode remover ou transformar atributos sensíveis;
- a Gold pode conter informações analíticas Confidenciais;
- a Certified Gold pode permanecer Confidencial apesar de ser governada e certificada para consumo.

O movimento *downstream* não reduz automaticamente a sensibilidade.

A classificação muda somente quando as informações resultantes e suas características de exposição justificarem uma reavaliação.

### 9.7 Herança de Classificação

Dados derivados devem manter proteção apropriada à sua origem, a menos que a transformação altere de forma demonstrável a sensibilidade das informações resultantes.

Operações como:

- agregação;
- mascaramento;
- *tokenization*;
- pseudonimização;
- remoção de atributos;

podem reduzir a exposição, mas não justificam automaticamente uma classificação inferior.

A reavaliação deve considerar o que ainda pode ser identificado, inferido, reconstruído, associado ou exposto.

### 9.8 Dados Pessoais

Dados pessoais devem ser identificados independentemente do nível geral de classificação de segurança.

Uma informação pode constituir dado pessoal quando estiver relacionada a uma pessoa natural identificada ou identificável.

Exemplos podem incluir:

- nome;
- identificadores de documentos pessoais;
- endereço de e-mail;
- número de telefone;
- endereço de entrega ou residencial;
- identificadores de clientes que possam ser associados a um indivíduo;
- combinações de atributos capazes de identificar um indivíduo.

A condição de dado pessoal introduz requisitos de governança de privacidade adicionais à classificação geral de segurança.

Os requisitos detalhados de privacidade são definidos no Capítulo 10.

### 9.9 Dados Pessoais Sensíveis

Dados pessoais sensíveis devem ser identificados separadamente quando aplicável.

A plataforma não deve presumir que todo atributo de cliente seja um dado pessoal sensível.

A determinação depende do significado real da informação e dos requisitos de privacidade aplicáveis.

Quando tais dados existirem, sua classificação e tratamento devem refletir o impacto adicional à privacidade associado ao processamento ou divulgação não autorizados.

As considerações detalhadas de LGPD e privacidade são definidas no Capítulo 10.

### 9.10 Dados Sensíveis de Negócio

Informações sensíveis não se limitam a dados pessoais.

Informações sensíveis de negócio podem incluir:

- informações de vendas não públicas;
- estratégias de preços;
- histórico detalhado de transações;
- indicadores internos de desempenho;
- resultados analíticos ainda não divulgados;
- informações operacionais cuja divulgação possa afetar a organização.

Esses dados podem exigir tratamento como Confidenciais ou Restritos mesmo quando não contiverem informações pessoais.

### 9.11 Dados Sensíveis à Segurança

Informações sensíveis à segurança são dados cuja divulgação pode enfraquecer a segurança da plataforma.

Exemplos incluem:

- credenciais;
- material criptográfico privado;
- configurações de segurança;
- informações de acesso privilegiado;
- detalhes de vulnerabilidades;
- material interno de investigação de segurança;
- informações que revelem controles defensivos sensíveis.

Informações sensíveis à segurança podem exigir classificação como Restritas independentemente de conterem dados pessoais ou de negócio.

### 9.12 Metadados de Classificação de Dados

As decisões de classificação devem ser representadas como metadados governados sempre que possível.

Metadados relevantes podem incluir:

- conjunto de dados;
- atributo;
- nível de classificação;
- justificativa da classificação;
- indicador de dado pessoal;
- indicador de dado pessoal sensível, quando aplicável;
- responsável ou função responsável;
- requisitos de tratamento;
- estado da revisão;
- versão ou data de vigência.

Os metadados de classificação devem descrever as informações protegidas sem reproduzir desnecessariamente valores sensíveis.

### 9.13 Classificação no Nível de Atributo

A classificação no nível do conjunto de dados pode ser insuficiente quando atributos individuais possuem sensibilidades significativamente diferentes.

Por exemplo, um conjunto de dados pode conter:

- data de transação não sensível;
- valor de transação Confidencial;
- identificador pessoal de cliente;
- metadados relacionados à segurança classificados como Restritos.

Quando necessário, a classificação deve, portanto, poder ser expressa no nível de atributo.

A proteção efetiva de um conjunto de dados deve considerar seu conteúdo relevante mais sensível e os controles disponíveis para separar ou transformar esse conteúdo.

### 9.14 Classificação e Minimização de Dados

A classificação deve orientar as decisões sobre se uma informação deve ser propagada *downstream*.

Para cada atributo, a plataforma deve ser capaz de perguntar:

**Este atributo é necessário para o próximo propósito de processamento ou análise?**

Se não:

A propagação desnecessária deve ser evitada.

Se sim:

O tratamento necessário deve refletir sua classificação.

A classificação, portanto, dá suporte à minimização, em vez de apenas documentar a sensibilidade depois que os dados já se propagaram pela plataforma.

### 9.15 Classificação ao Longo do Fluxo de Dados

A classificação deve permanecer significativa à medida que os dados percorrem:

**Origem → CDC → Evento → Kafka → Bronze → Silver → Gold → Certified Gold → Consumidor**

Um atributo não exige automaticamente a mesma representação *downstream* em todas as etapas.

A transformação pode:

- preservá-lo;
- removê-lo;
- mascará-lo;
- pseudonimizá-lo;
- agregá-lo;
- derivar uma representação menos identificável.

Qualquer alteração significativa na sensibilidade deve ser avaliada, e não presumida.

### 9.16 Classificação da Bronze

A Bronze preserva eventos históricos derivados da origem com transformação mínima.

Ela pode, portanto, reter informações posteriormente removidas ou transformadas *downstream*.

A Bronze deve ser tratada como uma camada histórica e de processamento controlada, e não como uma camada geral de consumo analítico.

Sua classificação depende das informações que ela efetivamente contém.

### 9.17 Classificação da Silver

A Silver padroniza, normaliza, deduplica e valida os dados para processamento *downstream*.

Essa camada oferece uma oportunidade para remover ou transformar atributos que não sejam mais necessários.

A Silver não se torna automaticamente não sensível porque ocorreu uma transformação.

Sua classificação deve refletir as informações resultantes após o processamento.

### 9.18 Classificação da Gold

A Gold contém estruturas analíticas governadas.

Informações no nível de cliente ou transação podem permanecer Confidenciais mesmo quando organizadas para análise.

A agregação não torna automaticamente um conjunto de dados Público.

A classificação deve considerar tanto os atributos individuais quanto o que pode ser inferido a partir de sua combinação.

### 9.19 Classificação da Certified Gold

A Certified Gold é um limite governado de consumo, e não um limite de publicação irrestrita.

A certificação significa que um produto de dados satisfez seus requisitos definidos de processamento, qualidade, reconciliação e publicação.

Ela não significa que o produto seja Público ou não sensível.

O acesso à Certified Gold deve continuar respeitando:

- classificação;
- propósito do consumidor;
- autorização;
- requisitos de privacidade;
- minimização de dados.

Um produto analítico certificado pode legitimamente permanecer Confidencial.

### 9.20 Classificação e Observabilidade

*Logs*, métricas, *traces*, *dashboards* e alertas devem respeitar a classificação dos dados.

A observabilidade deve priorizar metadados operacionais em vez de *payloads* completos de negócio.

Valores Restritos não devem aparecer intencionalmente em saídas comuns de observabilidade.

Informações Confidenciais ou pessoais devem aparecer somente quando explicitamente necessárias, justificadas e adequadamente protegidas.

A conveniência de diagnóstico não deve criar um repositório secundário não controlado de dados sensíveis.

Os requisitos detalhados de observabilidade são definidos no Capítulo 14.

### 9.21 Classificação e Evidências

Artefatos de evidência herdam a sensibilidade das informações que contêm.

Mover informações para um diretório de evidências não altera sua classificação.

Evidências públicas devem priorizar:

- dados sintéticos;
- saídas com valores ocultados;
- identificadores controlados;
- resultados agregados;
- configurações sem credenciais;
- capturas de tela sem valores sensíveis.

As evidências devem comprovar o comportamento necessário sem expor desnecessariamente as informações protegidas.

### 9.22 Classificação e Consumo Analítico

Os consumidores analíticos devem receber somente as informações e a classificação apropriadas ao seu propósito definido.

Diferentes consumidores do mesmo domínio de negócio podem legitimamente exigir representações diferentes.

Por exemplo:

**Investigação Operacional**
→ pode exigir detalhes no nível de cliente mediante autorização.

**Dashboard de Tendências de Vendas**
→ pode exigir apenas informações agregadas ou não identificáveis.

A existência de um conjunto de dados *upstream* mais rico não justifica a exposição desse conjunto de dados a todos os consumidores analíticos.

### 9.23 Classificação e Exportação

Dados exportados mantêm sua classificação.

Por exemplo:

**Conjunto de Dados Confidencial → Exportação CSV → Artefato Confidencial**

**Valor Restrito → Exportação de Texto → Artefato Restrito**

A exportação não transforma informações governadas em informações não sensíveis e não gerenciadas.

Os artefatos exportados permanecem sujeitos aos requisitos aplicáveis de:

- controle de acesso;
- proteção;
- retenção;
- descarte;
- privacidade.

### 9.24 Classificação e Retenção

A classificação orienta a retenção, mas não determina a retenção de forma independente.

As decisões de retenção devem considerar:

**Propósito + Classificação + Requisito Legal ou de Negócio + Requisito de Recuperação + Requisito Analítico**

Uma sensibilidade mais elevada pode justificar uma retenção mais curta quando as informações não forem mais necessárias, enquanto requisitos legítimos de negócio, recuperação, auditoria, análise ou legislação podem justificar uma retenção controlada.

A disponibilidade de armazenamento, por si só, não é uma razão válida para retenção indefinida.

A governança detalhada de retenção é definida no Capítulo 13.

### 9.25 Revisão da Classificação

A classificação deve ser revisável quando alterações puderem afetar a sensibilidade ou o uso permitido.

Os gatilhos relevantes incluem:

- novos conjuntos de dados;
- novos atributos;
- alteração da semântica da origem;
- novos consumidores;
- alteração do propósito analítico;
- novos destinos de exportação;
- alteração dos requisitos de privacidade ou segurança;
- transformações que alterem significativamente a sensibilidade.

A classificação é, portanto, parte da governança de mudanças, e não uma atividade única de documentação.

### 9.26 Responsabilidade pela Classificação

As decisões de classificação exigem uma responsabilidade identificável.

A responsabilidade deve dar suporte a decisões relacionadas a:

- significado de negócio;
- sensibilidade;
- condição de dado pessoal;
- necessidade analítica;
- consumidores permitidos;
- retenção;
- propagação *downstream*.

As responsabilidades corporativas podem envolver responsáveis pelos dados, *data stewards*, Segurança, áreas de Privacidade ou Jurídico, Engenharia de Dados e Engenharia de Plataforma.

O laboratório da Versão 1 pode consolidar essas responsabilidades sob um único operador, preservando sua distinção lógica.

### 9.27 Classificação Desconhecida

Informações cuja sensibilidade ainda não tenha sido determinada não devem ser automaticamente tratadas como Públicas.

Quando a classificação permanecer não resolvida, uma abordagem conservadora de tratamento deve ser aplicada até a conclusão da revisão.

Uma classificação desconhecida é uma questão de governança que exige resolução, e não uma permissão para uso irrestrito.

### 9.28 Alterações de Classificação

Uma alteração de classificação pode exigir mudanças nos controles técnicos ou de governança.

As áreas potencialmente afetadas incluem:

- consumidores autorizados;
- proteção de armazenamento;
- criptografia;
- *logging*;
- retenção;
- exportação;
- exposição analítica;
- tratamento de evidências.

Alterar apenas os metadados de classificação é insuficiente quando a nova classificação exige controles diferentes.

O impacto *downstream* deve, portanto, ser avaliado.

### 9.29 Modelo de Classificação do Laboratório

A Versão 1 utiliza dados controlados e sintéticos do projeto, em vez de dados reais de clientes de produção.

Isso reduz a exposição do mundo real, mas não elimina a necessidade de implementar e validar o comportamento de classificação.

Dados sintéticos representativos podem demonstrar:

- classificação;
- decisões de propagação;
- restrições de acesso;
- minimização;
- tratamento na observabilidade;
- tratamento de evidências.

O laboratório não deve reivindicar proteção de privacidade equivalente à do mundo real apenas porque dados sintéticos foram utilizados.

### 9.30 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer a governança de classificação por meio de capacidades como:

- catálogos de dados centralizados;
- descoberta automatizada;
- classificação automatizada;
- varredura de dados sensíveis;
- classificação integrada à linhagem;
- acesso baseado em políticas;
- controles de prevenção contra perda de dados;
- retenção baseada em classificação;
- mascaramento baseado em classificação;
- aplicação automatizada de políticas.

Esses mecanismos fortalecem a aplicação dos controles sem alterar o princípio de que a classificação deve influenciar o tratamento efetivo dos dados.

### 9.31 Testes de Classificação

Os controles de classificação implementados devem ser validados sempre que possível.

Testes representativos incluem:

- atributo sensível recebe a classificação esperada;
- atributo minimizado não aparece em uma representação *downstream* não autorizada;
- consumidor não autorizado não consegue acessar um conjunto de dados classificado;
- valores Restritos não aparecem em *logs* comuns;
- valores sensíveis estão ausentes de evidências públicas;
- artefatos exportados preservam os requisitos de tratamento aplicáveis;
- alterações de classificação acionam a revisão dos controles afetados.

Dados controlados ou sintéticos devem ser utilizados sempre que informações sensíveis reais forem desnecessárias.

A metodologia detalhada de validação é definida no Capítulo 17.

### 9.32 Evidências de Classificação

As evidências devem demonstrar o comportamento da classificação sem expor desnecessariamente as informações que estão sendo protegidas.

Evidências relevantes podem identificar:

- conjunto de dados ou atributo;
- nível de classificação;
- justificativa;
- indicador de dado pessoal, quando aplicável;
- tratamento esperado;
- propagação observada;
- resultado do acesso;
- presença ou ausência *downstream*;
- metadados relevantes;
- versão da implementação;
- conclusão.

A própria evidência permanece sujeita à classificação de acordo com seu conteúdo.

### 9.33 Garantias de Classificação de Dados e Dados Sensíveis

O modelo de classificação da Atlas Engineering deve preservar as seguintes garantias:

1. a classificação influencia o tratamento efetivo dos dados;
2. a ausência de um rótulo de classificação não implica dados Públicos;
3. a camada arquitetural não determina automaticamente a classificação;
4. dados derivados mantêm proteção apropriada, a menos que a transformação justifique uma reavaliação;
5. dados pessoais, dados sensíveis de negócio e dados sensíveis à segurança permanecem conceitos distinguíveis;
6. a classificação no nível de atributo está disponível quando a classificação no nível do conjunto de dados for insuficiente;
7. a classificação orienta a minimização e a propagação *downstream*;
8. atributos da origem não percorrem automaticamente todo o *pipeline* de dados;
9. a Bronze permanece uma camada histórica e de processamento controlada;
10. a transformação na Silver pode reduzir, mas não elimina automaticamente, a sensibilidade;
11. Gold e Certified Gold podem permanecer Confidenciais;
12. certificação não implica divulgação pública;
13. observabilidade e evidências não criam intencionalmente cópias não controladas de informações sensíveis;
14. informações exportadas mantêm sua classificação;
15. a retenção considera a classificação juntamente com o propósito e os requisitos aplicáveis;
16. uma classificação não resolvida não implica uso irrestrito;
17. alterações de classificação acionam a avaliação dos controles afetados;
18. as decisões de classificação possuem responsabilidade identificável;
19. a validação em laboratório pode utilizar dados sintéticos sem reivindicar equivalência às condições reais de privacidade em produção;
20. o comportamento de classificação implementado é testável e baseado em evidências.

---

## 10. LGPD e Governança de Privacidade

A Atlas Engineering incorpora a governança de privacidade à arquitetura da plataforma de dados.

O objetivo não é reivindicar conformidade legal ou regulatória exclusivamente a partir de controles técnicos.

Em vez disso, a arquitetura fornece mecanismos capazes de dar suporte aos requisitos de privacidade, tornando o processamento de dados pessoais identificável, orientado por propósito, minimizado, controlado, rastreável e governável ao longo de todo o ciclo de vida dos dados.

O princípio governante é:

**Identificar Dados Pessoais → Definir Propósito → Minimizar Processamento → Controlar Acesso → Governar Ciclo de Vida → Preservar Evidências**

Os requisitos de privacidade se aplicam onde quer que dados pessoais sejam coletados, capturados, propagados, persistidos, transformados, consumidos, exportados, retidos, recuperados ou descartados.

### 10.1 Identificação de Dados Pessoais

Os dados pessoais devem ser identificáveis dentro do modelo de dados governado.

Uma informação pode constituir dado pessoal quando estiver relacionada a uma pessoa natural identificada ou identificável.

Exemplos podem incluir:

- nome;
- identificadores de documentos pessoais;
- endereço de e-mail;
- número de telefone;
- endereço residencial ou de entrega;
- identificadores de clientes associados a um indivíduo;
- combinações de atributos capazes de identificar um indivíduo.

A identificação deve ocorrer com antecedência suficiente para influenciar as decisões de processamento *downstream*.

A condição de dado pessoal é distinta do nível geral de classificação de segurança definido no Capítulo 9.

### 10.2 Dados Pessoais Sensíveis

Dados pessoais sensíveis exigem identificação separada quando aplicável.

A plataforma não deve classificar todo atributo de cliente como dado pessoal sensível apenas porque está relacionado a um indivíduo.

A determinação depende do significado da informação e dos requisitos de privacidade aplicáveis.

Quando existirem dados pessoais sensíveis, seu processamento, acesso, propagação, retenção, uso em evidências e uso analítico exigem considerações adicionais.

### 10.3 Propósito do Processamento

Os dados pessoais devem ser processados para um propósito identificável.

Propósitos relevantes podem incluir:

- processamento operacional de transações;
- atendimento de pedidos;
- suporte ao cliente;
- reconciliação financeira;
- relatórios analíticos;
- investigação de segurança;
- obrigações regulatórias ou legais, quando aplicáveis.

A existência de dados pessoais na origem não estabelece, de forma independente, um propósito analítico *downstream*.

O propósito deve orientar quais dados são propagados e quem pode acessá-los.

### 10.4 Limitação de Propósito

Dados pessoais coletados ou processados para um propósito não devem ser automaticamente reutilizados para propósitos não relacionados.

Um novo uso analítico ou operacional pode exigir a revisão de:

- atributos necessários;
- consumidores pretendidos;
- lógica de processamento;
- acesso;
- retenção;
- impacto à privacidade;
- requisitos organizacionais ou legais aplicáveis.

A disponibilidade técnica não estabelece um propósito válido de processamento.

### 10.5 Minimização de Dados

Somente os dados pessoais necessários para o propósito definido devem ser propagados, persistidos ou expostos.

Para cada atributo, a plataforma deve ser capaz de perguntar:

**Este atributo pessoal é necessário para o próximo propósito de processamento ou análise?**

Se não:

**Não o propague desnecessariamente.**

Se sim:

**Aplique a proteção e a governança necessárias ao seu uso.**

A minimização de dados reduz a exposição à privacidade em toda a plataforma.

### 10.6 Privacidade ao Longo do Pipeline de Dados

Os requisitos de privacidade se aplicam a todo o fluxo governado:

**Origem → CDC → Evento → Kafka → Bronze → Silver → Gold → Certified Gold → Consumidor**

Um atributo presente na origem não precisa automaticamente alcançar todas as etapas *downstream*.

Em cada limite relevante de transformação, os dados pessoais podem ser:

- preservados;
- removidos;
- mascarados;
- pseudonimizados;
- agregados;
- generalizados;
- substituídos por uma representação derivada.

A representação resultante deve permanecer apropriada ao próximo propósito de processamento.

### 10.7 Limite de Privacidade da Origem

O AtlasCommerce é a origem operacional e pode conter dados pessoais necessários aos processos transacionais de negócio.

O acesso *downstream* a essas informações deve ser justificado de forma independente.

A captura de alterações não deve ser interpretada como permissão para replicar todos os atributos da origem.

A configuração de CDC e o projeto dos eventos devem incluir somente as informações necessárias para o produto de dados governado.

### 10.8 Privacidade no Kafka e nos Eventos

Os eventos podem propagar dados pessoais além da origem operacional.

Os contratos de eventos devem, portanto, considerar:

- se o atributo é necessário;
- sua condição de dado pessoal;
- sua sensibilidade;
- consumidores pretendidos;
- retenção;
- propagação *downstream*.

A retenção do Kafka cria cópias persistentes dos dados dos eventos.

Dados pessoais no Kafka permanecem dados pessoais governados e não devem ser tratados como temporários apenas porque o Kafka é um componente de transporte.

### 10.9 Privacidade na Bronze

A Bronze preserva eventos históricos derivados da origem e pode conter atributos pessoais removidos das camadas posteriores.

A Bronze pode, portanto, representar um limite de maior exposição à privacidade do que os produtos analíticos *downstream*.

O acesso deve ser limitado às responsabilidades que exigem processamento histórico, recuperação, governança ou investigação autorizada.

O valor para *replay* não justifica acesso irrestrito aos dados pessoais.

### 10.10 Privacidade na Silver

A Silver fornece um limite controlado de transformação no qual atributos pessoais desnecessários podem ser removidos ou transformados.

O processamento orientado à privacidade pode incluir:

- remoção de atributos;
- normalização;
- mascaramento;
- pseudonimização;
- generalização;
- derivação controlada.

A Silver não se torna automaticamente não pessoal apenas porque ocorreu uma transformação.

Os dados resultantes devem ser avaliados de acordo com sua capacidade real de identificação e seu propósito.

### 10.11 Privacidade na Gold

As estruturas analíticas da Gold devem conter somente os dados pessoais necessários para propósitos analíticos ou de governança definidos.

Detalhes no nível de cliente podem continuar sendo necessários para algumas análises governadas, enquanto outros produtos podem exigir somente informações agregadas ou não identificáveis.

O modelo dimensional não deve se tornar um repositório de atributos pessoais apenas porque eles estão disponíveis *upstream*.

### 10.12 Privacidade na Certified Gold

A Certified Gold é o limite governado de consumo analítico.

A certificação não autoriza, de forma independente, a divulgação de dados pessoais.

Os produtos de dados publicados devem considerar:

- propósito analítico definido;
- atributos necessários;
- consumidores pretendidos;
- autorização;
- classificação;
- requisitos de privacidade.

Quando detalhes pessoais forem desnecessários, a Certified Gold deve priorizar representações reduzidas, agregadas, mascaradas, pseudonimizadas ou apropriadas de outra forma.

### 10.13 Identificadores Diretos e Indiretos

A análise de privacidade deve considerar tanto a identificação direta quanto a indireta.

Identificadores diretos podem incluir informações como:

- nome;
- número de documento pessoal;
- endereço de e-mail;
- número de telefone.

Identificadores indiretos podem identificar um indivíduo quando combinados com outras informações.

A remoção de um nome, portanto, não torna automaticamente um conjunto de dados anônimo.

A avaliação de privacidade deve considerar o conjunto de dados resultante como um todo.

### 10.14 Pseudonimização

A pseudonimização substitui informações diretamente identificáveis por outra representação, preservando alguma capacidade de relacionar registros quando necessário.

Um conjunto de dados pseudonimizado ainda pode constituir dado pessoal se a reidentificação permanecer razoavelmente possível.

A pseudonimização pode reduzir a exposição, mas não deve ser apresentada como equivalente à anonimização.

Qualquer mapeamento ou chave capaz de reverter ou associar o pseudônimo deve receber proteção apropriada.

### 10.15 Anonimização

A anonimização busca produzir informações que não identifiquem mais um indivíduo por meios razoavelmente aplicáveis.

A anonimização não deve ser reivindicada apenas porque identificadores diretos foram removidos.

A avaliação deve considerar:

- atributos restantes;
- combinações de atributos;
- informações externas razoavelmente disponíveis;
- possibilidade de associação ou inferência.

A Atlas Engineering deve reivindicar anonimização somente quando a transformação implementada e as evidências justificarem essa conclusão.

### 10.16 Mascaramento

O mascaramento altera a representação visível das informações para reduzir a exposição.

Ele pode ser útil para:

- interfaces de usuário;
- *views* analíticas;
- *troubleshooting*;
- suporte;
- evidências;
- uso em ambientes não produtivos.

O mascaramento não elimina necessariamente a condição subjacente de dado pessoal.

A eficácia do mascaramento depende do que permanece acessível por outros caminhos.

### 10.17 Privacidade e Controle de Acesso

O acesso a dados pessoais deve seguir propósito e responsabilidade definidos.

A autenticação ou o acesso geral a um conjunto de dados não justificam, de forma independente, o acesso a todos os atributos pessoais.

Quando apropriado, o acesso orientado à privacidade pode utilizar:

- *views* governadas;
- conjuntos de dados reduzidos;
- representações mascaradas;
- produtos específicos por função;
- controles no nível de coluna;
- interfaces separadas para consumidores.

Privacidade e privilégio mínimo devem operar em conjunto.

### 10.18 Privacidade e Observabilidade

*Logs*, métricas, *traces*, *dashboards* e alertas não devem se transformar em repositórios secundários desnecessários de dados pessoais.

A observabilidade deve priorizar:

- identificadores técnicos;
- identificadores de correlação;
- contagens;
- estado;
- metadados controlados de diagnóstico.

Valores pessoais completos não devem ser registrados apenas por conveniência de *troubleshooting*.

Quando dados pessoais forem realmente necessários para investigação, o acesso e a retenção devem permanecer controlados.

### 10.19 Privacidade e Linhagem

A linhagem deve permitir compreender de onde se originam os dados pessoais governados, como são transformados e onde são consumidos.

A linhagem relevante pode descrever:

**Atributo da Origem → Campo do Evento → Campo da Bronze → Campo da Silver → Atributo da Gold → Produto Certificado**

A linhagem deve dar suporte a perguntas como:

- de onde se origina este atributo pessoal?
- para onde ele se propaga?
- onde ele é transformado?
- quais produtos dependem dele?
- quais consumidores podem recebê-lo?

Os metadados de linhagem não devem reproduzir desnecessariamente os próprios valores pessoais.

### 10.20 Privacidade e Metadados

A governança de privacidade exige metadados capazes de descrever o tratamento dos dados pessoais.

Metadados relevantes podem incluir:

- indicador de dado pessoal;
- indicador de dado pessoal sensível, quando aplicável;
- propósito do processamento;
- classificação;
- responsável;
- transformação;
- requisito de retenção;
- consumidor permitido;
- linhagem;
- estado da revisão de privacidade.

Os metadados devem descrever as decisões de governança, em vez de duplicar os dados protegidos.

### 10.21 Exatidão e Correção dos Dados

A governança de privacidade pode exigir que informações pessoais incorretas sejam corrigidas de acordo com os requisitos aplicáveis e as responsabilidades da fonte autoritativa.

A plataforma analítica não deve redefinir silenciosamente os registros operacionais autoritativos.

Quando as informações da origem forem corrigidas, o processamento *downstream* deve ser capaz de refletir o estado governado corrigido de acordo com a arquitetura.

Os requisitos de preservação histórica devem ser considerados separadamente da correção da representação autoritativa atual.

### 10.22 Solicitações dos Titulares dos Dados

A arquitetura deve dar suporte à investigação de solicitações dos titulares dos dados, quando aplicável.

As solicitações potenciais podem envolver:

- confirmação do processamento;
- acesso;
- correção;
- exclusão ou anonimização;
- informações sobre uso ou compartilhamento;
- outros direitos aplicáveis ao contexto do processamento.

A arquitetura da plataforma, por si só, não determina se uma solicitação específica deve ser legalmente atendida nem como deve ser atendida.

Essas decisões exigem o processo organizacional e jurídico aplicável.

A arquitetura técnica deve tornar os locais relevantes dos dados, a linhagem, as transformações, os consumidores e os estados de retenção suficientemente identificáveis para dar suporte a esse processo.

### 10.23 Exclusão e Apagamento

A exclusão de dados pessoais deve ser avaliada em todas as cópias governadas, e não apenas na tabela analítica atual.

Os locais potenciais incluem:

- origem operacional;
- histórico de CDC;
- retenção do Kafka;
- Bronze;
- Silver;
- Gold;
- Certified Gold;
- quarentena;
- artefatos temporários;
- *backups*;
- exportações;
- evidências.

A ação apropriada pode variar de acordo com a tecnologia de armazenamento, propósito do processamento, obrigação de retenção e requisito legal ou organizacional.

A exclusão não deve ser apresentada como concluída até que o escopo definido e as cópias retidas aplicáveis tenham sido considerados.

### 10.24 Exclusão versus Integridade Histórica

Os requisitos de exclusão relacionados à privacidade podem interagir com requisitos legítimos históricos, contábeis, de auditoria, recuperação ou análise.

A arquitetura não deve resolver essa tensão por meio de exclusão técnica arbitrária.

Possíveis tratamentos técnicos podem incluir, quando apropriado:

- remoção;
- anonimização;
- pseudonimização;
- retenção restrita;
- exclusão do consumo ativo;
- descarte físico posterior de acordo com a retenção governada.

O tratamento correto depende do contexto do processamento e dos requisitos aplicáveis.

A capacidade técnica não determina, de forma independente, a permissibilidade legal.

### 10.25 Privacidade e Backups

Os *backups* podem conter cópias históricas de dados pessoais.

A governança de privacidade deve, portanto, considerar:

- retenção dos *backups*;
- comportamento da restauração;
- acesso;
- proteção;
- expiração ou descarte eventual.

Excluir informações da plataforma ativa não as remove automaticamente dos *backups* existentes.

Quando *backups* retidos preservarem legitimamente dados antigos, os procedimentos de recuperação devem evitar a reintrodução não intencional de informações pessoais obsoletas no estado governado ativo sem o processamento apropriado.

### 10.26 Privacidade e Replay

O *replay* pode reintroduzir dados pessoais históricos nas camadas *downstream*.

Os procedimentos de *replay* devem, portanto, respeitar:

- regras atuais de transformação;
- requisitos atuais de minimização;
- controles atuais de privacidade;
- estado aplicável de exclusão ou anonimização;
- regras atuais de certificação.

Dados históricos brutos não devem automaticamente se sobrepor a decisões posteriores de governança de privacidade.

### 10.27 Privacidade e Retenção de Dados

Dados pessoais não devem ser retidos indefinidamente apenas porque há armazenamento disponível.

A retenção deve considerar:

- propósito do processamento;
- requisito de negócio;
- requisito analítico;
- requisito de recuperação;
- requisito de privacidade;
- requisito legal ou regulatório aplicável;
- risco de segurança.

Diferentes camadas arquiteturais podem legitimamente possuir diferentes períodos de retenção.

A governança detalhada de retenção é definida no Capítulo 13.

### 10.28 Privacidade e Exportação de Dados

A exportação de dados pessoais cria outra cópia governada e, potencialmente, outro limite de exposição.

Antes da exportação, as considerações relevantes incluem:

- propósito;
- destinatário;
- atributos necessários;
- classificação;
- proteção;
- retenção;
- descarte;
- requisitos de privacidade aplicáveis.

A autorização para consultar dados pessoais não justifica automaticamente sua exportação irrestrita.

Quando o detalhamento completo for desnecessário, representações reduzidas ou transformadas devem ser priorizadas.

### 10.29 Considerações sobre Incidentes de Privacidade

Exposição, acesso, alteração, perda ou processamento inadequado e não autorizado de dados pessoais podem constituir um incidente relevante à privacidade.

A resposta técnica deve dar suporte a:

- detecção;
- contenção;
- identificação do escopo;
- identificação dos dados afetados;
- análise de linhagem;
- preservação de evidências;
- recuperação;
- revisão pós-incidente.

A determinação de se um evento gera obrigação legal de notificação ou outras obrigações regulatórias depende do contexto aplicável e não deve ser feita exclusivamente por este documento de arquitetura.

O tratamento de incidentes de segurança é detalhado no Capítulo 15.

### 10.30 Privacidade por Design

A privacidade deve ser considerada durante o projeto de novos fluxos de dados, conjuntos de dados, atributos, transformações e produtos analíticos.

As questões relevantes de projeto incluem:

- Os dados pessoais são necessários?
- Qual propósito os exige?
- Menos atributos podem atender a esse propósito?
- A agregação ou transformação pode reduzir a exposição?
- Quais identidades precisam de acesso?
- Por quanto tempo os dados são necessários?
- Para onde eles serão propagados?
- O que acontece durante *replay*, recuperação, exportação e descarte?

A revisão de privacidade é, portanto, parte da arquitetura e do projeto do produto de dados, e não uma atividade executada somente após a implementação.

### 10.31 Governança de Privacidade para Novos Produtos de Dados

Um novo produto de dados que processe dados pessoais deve definir, quando aplicável:

- propósito de negócio;
- atributos de dados pessoais;
- sensibilidade;
- transformações necessárias;
- consumidores pretendidos;
- requisitos de acesso;
- linhagem;
- retenção;
- expectativas de exportação;
- requisitos de evidências.

Um produto não deve herdar todos os atributos pessoais *upstream* apenas porque esses atributos estão tecnicamente disponíveis.

A representação governada mínima necessária para o produto deve ser priorizada.

### 10.32 Modelo de Privacidade do Laboratório

A Versão 1 utiliza dados sintéticos controlados do projeto, em vez de dados reais de clientes de produção.

O laboratório pode, portanto, validar o comportamento técnico de privacidade sem exigir informações pessoais reais.

Testes representativos podem demonstrar:

- identificação de dados pessoais;
- minimização;
- remoção de atributos;
- mascaramento;
- pseudonimização;
- restrições de acesso;
- linhagem;
- comportamento de retenção;
- comportamento de *replay*;
- evidências seguras em relação à privacidade.

Dados sintéticos reduzem a exposição do mundo real, mas não comprovam conformidade legal nem maturidade corporativa de privacidade.

### 10.33 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer a governança de privacidade por meio de capacidades como:

- catálogos de dados centralizados;
- inventários de privacidade;
- descoberta automatizada de dados pessoais;
- acesso baseado em políticas;
- gerenciamento de consentimento ou preferências, quando aplicável;
- fluxos formais de solicitações de titulares dos dados;
- aplicação automatizada da retenção;
- plataformas de mascaramento e *tokenization*;
- avaliações de impacto à privacidade;
- prevenção contra perda de dados;
- auditoria centralizada de privacidade.

Essas capacidades podem fortalecer a governança sem alterar os princípios arquiteturais de limitação de propósito, minimização, acesso controlado, rastreabilidade e gerenciamento do ciclo de vida.

### 10.34 Testes de Privacidade

Os controles de privacidade implementados devem ser validados sempre que possível.

Testes representativos incluem:

- atributos pessoais são identificados corretamente;
- atributos pessoais desnecessários não são propagados *downstream*;
- a transformação produz a representação reduzida esperada;
- consumidores não autorizados não conseguem acessar dados pessoais protegidos;
- valores pessoais não aparecem desnecessariamente em *logs* ou métricas;
- o *replay* respeita as regras atuais de privacidade;
- a exportação preserva os controles aplicáveis;
- as evidências não expõem desnecessariamente informações pessoais.

Dados sintéticos devem ser priorizados sempre que dados pessoais reais forem desnecessários para validar o comportamento.

A metodologia detalhada de validação é definida no Capítulo 17.

### 10.35 Evidências de Privacidade

As evidências de privacidade devem demonstrar o comportamento implementado sem reproduzir desnecessariamente informações pessoais.

Evidências relevantes podem identificar:

- identificador do teste;
- conjunto de dados ou atributo;
- condição de dado pessoal;
- propósito do processamento;
- transformação ou restrição esperada;
- resultado observado;
- linhagem;
- resultado do acesso;
- versão da implementação;
- conclusão.

As evidências devem utilizar representações sintéticas, mascaradas, ocultadas ou controladas de outra forma sempre que possível.

A evidência de um controle técnico de privacidade demonstra esse controle sob as condições testadas.

Ela não estabelece, de forma independente, conformidade legal.

### 10.36 Garantias de LGPD e Governança de Privacidade

O modelo de governança de privacidade da Atlas Engineering deve preservar as seguintes garantias:

1. os dados pessoais podem ser identificados dentro da arquitetura governada;
2. os dados pessoais sensíveis são distinguidos quando aplicável;
3. o processamento de dados pessoais possui um propósito identificável;
4. a disponibilidade técnica não justifica, de forma independente, um novo propósito de processamento;
5. a propagação desnecessária de dados pessoais é minimizada;
6. os requisitos de privacidade permanecem aplicáveis ao longo de todo o *pipeline* de dados;
7. a captura de alterações não justifica a replicação irrestrita de atributos da origem;
8. Kafka e Bronze permanecem locais governados para dados pessoais;
9. a Silver fornece um limite controlado para transformação orientada à privacidade;
10. Gold e Certified Gold expõem somente as informações pessoais necessárias para seus propósitos definidos;
11. a certificação não autoriza, de forma independente, a divulgação de dados pessoais;
12. tanto a identificação direta quanto a indireta são consideradas;
13. a pseudonimização não é apresentada como anonimização;
14. a anonimização é reivindicada somente quando a transformação implementada e as evidências a justificarem;
15. o mascaramento reduz a exposição, mas não elimina automaticamente a condição de dado pessoal;
16. o acesso a dados pessoais segue o propósito e o privilégio mínimo;
17. observabilidade, metadados, linhagem e evidências evitam a reprodução desnecessária de valores pessoais;
18. a correção respeita as responsabilidades da fonte autoritativa;
19. a arquitetura pode dar suporte à investigação de solicitações aplicáveis dos titulares dos dados;
20. a exclusão considera as cópias governadas ao longo de todo o ciclo de vida dos dados;
21. a exclusão relacionada à privacidade é conciliada com requisitos legítimos históricos e de retenção por meio de decisões governadas;
22. a recuperação de *backups* não reintroduz silenciosamente estados obsoletos de dados pessoais;
23. o *replay* respeita as regras atuais de governança de privacidade;
24. a retenção reflete o propósito e os requisitos aplicáveis, em vez da disponibilidade de armazenamento;
25. a exportação cria um novo limite governado de privacidade;
26. incidentes relevantes à privacidade dão suporte à investigação técnica e à preservação de evidências;
27. a privacidade é considerada durante o projeto de produtos de dados;
28. novos produtos não herdam automaticamente atributos pessoais *upstream* desnecessários;
29. a validação de privacidade no laboratório utiliza dados controlados ou sintéticos sempre que possível;
30. os controles técnicos não são apresentados como prova independente de conformidade legal ou regulatória.

---

## 11. Acesso aos Dados por Camada Arquitetural

A Atlas Engineering aplica controle de acesso de acordo com a responsabilidade arquitetural, em vez de conceder acesso uniforme em toda a plataforma.

Cada camada arquitetural existe para um propósito definido e, portanto, representa um limite de acesso distinto.

O princípio governante é:

**Responsabilidade Necessária → Camada Necessária → Operação Necessária → Acesso Mínimo**

O acesso a uma camada não implica automaticamente acesso a outra.

A conectividade técnica, a posse de credenciais válidas ou o acesso a um conjunto de dados *upstream* não estabelecem, de forma independente, autorização para utilizar outro recurso da plataforma.

### 11.1 Acesso à Origem Operacional

O AtlasCommerce é a origem operacional autoritativa.

O acesso direto deve ser limitado a identidades e serviços com responsabilidade operacional, administrativa, de captura, recuperação ou investigação autorizada definida.

O acesso representativo pode incluir:

**Aplicação Operacional**
→ executa operações transacionais autorizadas.

**Debezium**
→ lê as estruturas da origem necessárias para a captura de alterações.

**DBA / Administração de Banco de Dados**
→ executa administração de banco de dados explicitamente autorizada.

Consumidores analíticos comuns não devem exigir acesso direto ao AtlasCommerce.

A origem operacional não deve se tornar uma interface geral de consumo analítico apenas porque contém os dados originais de negócio.

### 11.2 Acesso ao CDC

As estruturas do SQL Server CDC dão suporte à captura controlada de alterações.

O acesso deve ser limitado às responsabilidades que exigem:

- captura de alterações;
- administração do CDC;
- *troubleshooting* autorizado;
- validação;
- recuperação, quando aplicável.

A identidade de captura do Debezium deve receber somente o acesso ao CDC e à origem necessário para sua responsabilidade.

Consumidores analíticos não exigem acesso ao CDC.

O CDC não deve se tornar um caminho analítico alternativo que contorne o processamento *downstream* governado.

### 11.3 Acesso do Debezium

O Debezium atravessa um limite crítico entre a origem operacional e a plataforma de eventos.

Seu acesso deve ser limitado aos recursos necessários para:

- ler as estruturas aprovadas da origem e do CDC;
- obter os metadados de captura necessários;
- interagir com o mecanismo de contratos de eventos, quando necessário;
- publicar eventos aprovados no Kafka.

O Debezium não exige automaticamente:

- acesso irrestrito ao SQL Server;
- privilégios de administração de banco de dados;
- acesso irrestrito aos tópicos do Kafka;
- autoridade administrativa sobre o Kafka;
- acesso à Bronze, Silver, Gold ou Certified Gold.

Sua identidade e suas credenciais devem permanecer específicas à responsabilidade de captura.

### 11.4 Acesso dos Produtores Kafka

Os produtores Kafka devem receber permissão somente para publicar nos tópicos necessários à sua responsabilidade definida.

Para o fluxo inicial de Sales:

**Debezium**
→ publica eventos aprovados derivados da origem nos tópicos de Sales necessários.

O acesso de produtor não implica automaticamente:

- administração de tópicos;
- acesso de consumidor;
- acesso a tópicos não relacionados;
- administração do Kafka em toda a plataforma.

A permissão de gravação deve permanecer delimitada aos contratos de eventos e caminhos de comunicação necessários.

### 11.5 Acesso dos Consumidores Kafka

Os consumidores Kafka devem receber acesso somente aos tópicos e às responsabilidades de consumo necessários ao seu propósito de processamento.

Por exemplo:

**Processador Bronze**
→ consome os eventos aprovados de Sales necessários para persistência na Bronze.

O acesso de consumidor não implica automaticamente:

- acesso de produtor;
- acesso a tópicos não relacionados;
- privilégios administrativos;
- permissão para modificar a configuração dos tópicos.

O acesso aos grupos de consumidores também deve permanecer delimitado quando o mecanismo de segurança do Kafka implementado oferecer suporte a esse controle.

### 11.6 Acesso Administrativo ao Kafka

A administração do Kafka é distinta da produção e do consumo de eventos.

As operações administrativas podem incluir:

- criação ou configuração de tópicos;
- alterações de retenção;
- alterações de controle de acesso;
- configuração de *brokers*;
- administração de grupos de consumidores;
- *troubleshooting* da plataforma.

Produtores e consumidores rotineiros não devem exigir privilégios administrativos no Kafka.

O acesso administrativo deve permanecer explícito, limitado e atribuível sempre que tecnicamente possível.

### 11.7 Acesso à Bronze

A Bronze é uma representação durável, histórica e passível de *replay* dos eventos derivados da origem.

O acesso de leitura deve normalmente ser limitado às responsabilidades que exigem:

- processamento da Silver;
- *replay*;
- recuperação;
- investigação de qualidade de dados;
- governança;
- *troubleshooting* autorizado.

A Bronze pode conter informações que são intencionalmente removidas ou transformadas *downstream*.

Ela não deve, portanto, se tornar uma camada geral de consumo analítico.

### 11.8 Acesso de Gravação à Bronze

O acesso de gravação à Bronze deve ser limitado à carga de trabalho responsável pela persistência na Bronze e às operações de recuperação ou manutenção explicitamente autorizadas.

O caminho normal é:

**Kafka → Processador Bronze → Bronze**

Outros serviços não devem gravar diretamente na Bronze apenas porque o *endpoint* de armazenamento está acessível.

A responsabilidade controlada pela gravação dá suporte a:

- persistência determinística;
- linhagem;
- *replay*;
- *troubleshooting*;
- integridade da camada histórica.

O acesso administrativo de gravação, quando necessário, deve permanecer distinto do processamento rotineiro.

### 11.9 Acesso à Silver

A Silver contém dados padronizados, normalizados, deduplicados e sensíveis aos contratos.

O acesso de leitura deve normalmente ser limitado às responsabilidades que exigem:

- processamento da Gold;
- validação de qualidade;
- reconciliação;
- governança;
- investigação autorizada;
- recuperação controlada.

A Silver é uma camada confiável de processamento, mas não é o limite padrão de consumo analítico.

Consumidores analíticos comuns devem normalmente utilizar a Certified Gold.

### 11.10 Acesso de Gravação à Silver

O acesso de gravação à Silver deve ser limitado à carga de trabalho responsável pela transformação da Silver e às operações de recuperação ou manutenção explicitamente autorizadas.

O caminho normal é:

**Bronze → Processador Silver → Silver**

Outros serviços não devem contornar a responsabilidade de transformação e gravar registros arbitrários diretamente na Silver.

A responsabilidade controlada pela gravação ajuda a preservar:

- consistência da transformação;
- aplicação dos contratos;
- comportamento de deduplicação;
- estado de qualidade;
- linhagem;
- reprodutibilidade.

### 11.11 Acesso à Gold

A Gold contém estruturas de processamento dimensional, modelos analíticos, estado de reconciliação e outras informações necessárias antes da publicação governada.

O acesso de leitura pode ser necessário para:

- validação;
- reconciliação;
- certificação;
- publicação;
- governança;
- investigação autorizada.

A Gold não é automaticamente equivalente à Certified Gold.

Um estado da Gold tecnicamente processado ainda pode não estar validado, reconciliado ou certificado.

### 11.12 Acesso às Candidatas da Gold

Uma candidata da Gold representa um estado analítico que foi produzido, mas ainda não atravessou o limite de certificação e publicação.

O acesso deve, portanto, permanecer limitado às responsabilidades que exigem:

- validação;
- reconciliação;
- certificação;
- *troubleshooting* controlado;
- preparação para publicação.

Consumidores analíticos comuns não devem depender das candidatas da Gold.

Isso impede que um estado incompleto ou não certificado se torne uma interface analítica não oficial.

### 11.13 Acesso à Certified Gold

A Certified Gold é o limite governado de consumo analítico.

O acesso representativo inclui:

**Power BI**
→ lê estruturas analíticas aprovadas.

**Consumidores Analíticos Autorizados**
→ leem o produto de dados governado necessário para seu propósito definido.

Consumidores comuns devem normalmente receber acesso somente de leitura.

O acesso à Certified Gold permanece sujeito a:

- classificação;
- propósito;
- privilégio mínimo;
- requisitos de privacidade;
- autorização específica do produto.

A certificação não implica acesso irrestrito.

### 11.14 Acesso de Gravação e Publicação na Certified Gold

O acesso de gravação e publicação na Certified Gold deve permanecer separado do consumo analítico comum.

A sequência pretendida é:

**Candidata da Gold → Validação → Reconciliação → Certificação → Publicação → Certified Gold**

Somente a responsabilidade de publicação explicitamente autorizada deve publicar o estado aprovado.

Consumidores analíticos não devem exigir permissão para:

- INSERT;
- UPDATE;
- DELETE;
- substituir estruturas certificadas;
- alterar o estado de certificação;
- publicar candidatas.

A Versão 1 pode consolidar a execução técnica da certificação e da publicação, mas o limite lógico de autorização deve permanecer explícito.

### 11.15 Acesso do Power BI

O Power BI deve consumir dados analíticos governados por meio da Certified Gold.

O caminho pretendido é:

**Power BI → Certified Gold**

A operação comum do Power BI não deve exigir acesso direto a:

- AtlasCommerce;
- estruturas de CDC;
- Debezium;
- Kafka;
- Bronze;
- Silver;
- candidatas da Gold;
- serviços internos de processamento.

Esse limite reduz o acoplamento e impede que a conveniência analítica contorne os controles de processamento, qualidade, reconciliação e certificação.

### 11.16 Acesso do Airflow

O Airflow coordena os *workflows* da plataforma e, portanto, exige somente o acesso necessário para executar suas responsabilidades de orquestração.

Dependendo da implementação, isso pode incluir permissão para:

- acionar cargas de trabalho;
- coordenar dependências;
- inspecionar o estado da execução;
- obter os metadados operacionais necessários;
- avaliar os resultados dos *workflows*.

O Airflow não exige automaticamente acesso irrestrito de leitura, gravação ou administração a todos os componentes que orquestra.

Quando uma carga de trabalho puder ser executada utilizando sua própria identidade de serviço, a orquestração não deve substituir essa identidade por uma credencial do Airflow com privilégios amplos.

### 11.17 Acesso à Observabilidade

Os componentes de observabilidade exigem acesso aos sinais operacionais, e não acesso irrestrito aos dados de negócio.

O acesso representativo pode incluir:

- métricas;
- *endpoints* de integridade;
- *logs* estruturados;
- estado da execução;
- alertas.

Prometheus e Grafana não devem exigir acesso amplo aos conjuntos de dados de negócio apenas para observar o comportamento da plataforma.

O acesso de observabilidade também deve respeitar as restrições relacionadas a:

- segredos;
- dados pessoais;
- informações sensíveis de negócio;
- informações sensíveis à segurança.

Monitorar um serviço não implica autoridade administrativa sobre esse serviço.

### 11.18 Acesso a Metadados e Linhagem

Metadados e linhagem dão suporte à governança, arquitetura, investigação, validação e análise de impacto.

O acesso pode, portanto, ser mais amplo do que o acesso aos valores de negócio subjacentes, mas ainda deve ser controlado.

Os metadados podem expor informações sensíveis indiretamente por meio de:

- definições de *schema*;
- classificações;
- linhagem;
- nomes de sistemas;
- relações de processamento;
- configuração de segurança;
- detalhes operacionais.

O acesso aos metadados não concede automaticamente acesso aos dados descritos por esses metadados.

Da mesma forma, o acesso aos dados de negócio não concede automaticamente permissão para modificar metadados de governança ou linhagem.

### 11.19 Acesso à Quarentena

A quarentena contém registros que exigem investigação, correção ou reprocessamento controlados.

O acesso deve ser limitado às responsabilidades que exigem:

- diagnóstico;
- investigação de qualidade;
- correção;
- governança;
- reprocessamento;
- suporte autorizado.

A quarentena não deve se tornar um caminho alternativo de consumo analítico que contorne os controles de qualidade ou certificação.

Os registros em quarentena permanecem governados de acordo com sua classificação e seus requisitos de privacidade.

### 11.20 Acesso aos Backups

Os *backups* podem conter cópias históricas completas das informações governadas da plataforma.

O acesso deve, portanto, ser limitado às responsabilidades que exigem:

- execução de *backup*;
- administração de *backup*;
- restauração;
- validação da recuperação;
- investigação autorizada.

O acesso a um conjunto de dados ativo não justifica automaticamente o acesso aos seus *backups*.

O acesso aos *backups* deve refletir a classificação e a sensibilidade das informações preservadas.

### 11.21 Acesso às Evidências

As evidências de validação podem conter:

- informações de configuração;
- resultados de testes;
- *logs*;
- capturas de tela;
- identificadores;
- detalhes arquiteturais;
- resultados relacionados à segurança.

O acesso às evidências deve refletir a sensibilidade de seu conteúdo.

Evidências públicas devem conter somente informações apropriadas para divulgação pública.

Evidências sensíveis não devem se tornar públicas apenas porque fazem parte da documentação do projeto.

O acesso às evidências não implica automaticamente acesso aos recursos de produção ou processamento representados por essas evidências.

### 11.22 Acesso entre Camadas

Algumas responsabilidades exigem legitimamente acesso a mais de uma camada arquitetural.

Exemplos incluem:

**Processador Silver**
→ lê a Bronze e grava na Silver.

**Processador Gold**
→ lê a Silver e grava candidatas na Gold.

**Certificação / Publicação**
→ avalia o estado da Gold e publica a Certified Gold aprovada.

O acesso entre camadas deve permanecer limitado à origem e ao destino específicos necessários à responsabilidade.

A necessidade de atravessar dois limites adjacentes não justifica acesso irrestrito a toda a plataforma.

### 11.23 Acesso Durante Replay e Recuperação

O *replay* e a recuperação podem exigir acesso temporariamente diferente daquele utilizado no processamento normal em estado estável.

Esse acesso deve permanecer:

- explícito;
- justificado;
- delimitado;
- atribuível;
- temporário, sempre que possível;
- auditável.

O *replay* deve utilizar caminhos de processamento governados, em vez de modificações diretas e não controladas do estado *downstream*.

A recuperação não deve silenciosamente:

- restaurar acessos revogados;
- reativar credenciais invalidadas;
- contornar a autorização atual;
- expor camadas restritas;
- publicar dados não certificados.

Após a recuperação, o acesso deve retornar ao modelo governado normal.

### 11.24 Acesso Durante Investigação

Investigações operacionais, de segurança, qualidade de dados ou privacidade podem exigir acesso temporário a informações normalmente indisponíveis ao investigador.

O acesso para investigação deve ser limitado de acordo com:

- escopo do incidente ou problema;
- conjuntos de dados necessários;
- operações necessárias;
- duração;
- sensibilidade;
- função responsável.

Sempre que possível, a investigação deve priorizar o mínimo de informações necessárias para estabelecer a causa e o impacto.

O acesso investigativo temporário não deve silenciosamente se tornar acesso rotineiro permanente.

### 11.25 Separação de Ambientes

O acesso deve ser delimitado por ambiente quando existirem múltiplos ambientes.

O acesso a:

**Desenvolvimento**

não implica automaticamente acesso a:

**Teste**

ou:

**Produção**

Da mesma forma, credenciais e identidades de serviço não devem ser reutilizadas entre ambientes sem justificativa explícita.

A separação de ambientes reduz o risco de que atividades de desenvolvimento, teste ou *troubleshooting* afetem recursos operacionais mais sensíveis.

A Versão 1 pode operar principalmente como um laboratório local, mas a separação de ambientes permanece parte do modelo corporativo de acesso.

### 11.26 Matriz de Acesso

A Atlas Engineering deve manter uma matriz de acesso que descreva a relação pretendida entre identidades ou funções e recursos protegidos.

Uma matriz representativa pode incluir:

| Identidade / Função | Origem | CDC | Kafka | Bronze | Silver | Gold | Certified Gold | Administração |
|---|---|---|---|---|---|---|---|---|
| Debezium | Leitura Necessária | Leitura Necessária | Produção | Não | Não | Não | Não | Não |
| Processador Bronze | Não | Não | Consumo | Gravação | Não | Não | Não | Não |
| Processador Silver | Não | Não | Não | Leitura | Gravação | Não | Não | Não |
| Processador Gold | Não | Não | Não | Não | Leitura | Gravação | Não | Não |
| Certificação / Publicação | Não | Não | Não | Não | Conforme Necessário | Leitura | Publicação | Limitada |
| Power BI | Não | Não | Não | Não | Não | Não | Leitura | Não |
| Administrador da Plataforma | Controlado | Controlado | Controlado | Controlado | Controlado | Controlado | Controlado | Explícita |
| Governança / Investigação | Conforme Necessário | Conforme Necessário | Conforme Necessário | Conforme Necessário | Conforme Necessário | Conforme Necessário | Conforme Necessário | Não por Padrão |

A matriz é uma linha de base arquitetural, e não um substituto para as definições de permissões específicas de cada tecnologia.

A implementação real deve traduzir esses requisitos lógicos para os mecanismos de autorização suportados por cada componente da plataforma.

### 11.27 Validação da Matriz de Acesso

A matriz de acesso deve ser validada em relação à implementação real sempre que possível.

A validação deve confirmar tanto:

**Acesso Necessário**
→ responsabilidades legítimas conseguem executar suas operações pretendidas.

quanto:

**Acesso Proibido**
→ identidades não conseguem executar operações fora de suas responsabilidades definidas.

Uma matriz documentada não é evidência de que as permissões estejam corretamente aplicadas.

A implementação e a validação devem demonstrar o alinhamento entre o acesso pretendido e o acesso observado.

### 11.28 Access Drift

*Access drift* ocorre quando as permissões reais divergem do modelo de acesso governado ao longo do tempo.

Exemplos incluem:

- privilégio temporário que nunca foi removido;
- credenciais de serviço reutilizadas para finalidades adicionais;
- acesso a um novo tópico concedido sem revisão;
- consumidor analítico recebendo acesso *upstream*;
- permissão administrativa mantida após *troubleshooting*;
- acesso ao ambiente expandido sem justificativa arquitetural.

O *access drift* deve ser detectável por meio de revisão, testes, comparação de configurações ou mecanismos equivalentes sempre que possível.

O *drift* detectado deve ser avaliado e corrigido, em vez de silenciosamente se tornar a nova linha de base.

### 11.29 Alterações nos Limites de Acesso

Alterações nos limites de acesso exigem revisão explícita.

Exemplos incluem:

- novo consumidor;
- novo serviço;
- nova camada arquitetural;
- novos atributos sensíveis;
- novo processamento entre camadas;
- novos requisitos administrativos;
- novos caminhos de exportação;
- novos procedimentos de recuperação.

Uma alteração deve avaliar:

- identidade necessária;
- recurso necessário;
- operação necessária;
- classificação;
- implicações de privacidade;
- impacto de segurança;
- observabilidade;
- requisitos de validação.

O acesso não deve ser ampliado apenas porque uma nova integração é tecnicamente conveniente.

### 11.30 Modelo de Acesso do Laboratório

A Versão 1 implementa limites de acesso dentro de um ambiente local controlado de treinamento.

O laboratório pode consolidar múltiplas responsabilidades humanas sob um único operador e utilizar identidades e credenciais gerenciadas localmente.

Ele ainda deve demonstrar, sempre que possível:

- responsabilidades de serviço distintas;
- credenciais delimitadas;
- separação entre leitura e gravação;
- limites das camadas de processamento;
- isolamento dos consumidores da Certified Gold;
- acesso administrativo controlado;
- negação de acessos proibidos;
- revogação de acesso;
- comportamento de segurança observável.

As restrições do laboratório podem simplificar a aplicação física dos controles, mas não devem redefinir a arquitetura lógica de acesso.

### 11.31 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer a governança de acesso por meio de capacidades como:

- provedores de identidade centralizados;
- identidades gerenciadas para cargas de trabalho;
- controle de acesso baseado em funções;
- controle de acesso baseado em atributos;
- gerenciamento de acessos privilegiados;
- provisionamento e desprovisionamento automatizados;
- identidades específicas por ambiente;
- *policy-as-code*;
- certificação periódica de acesso;
- auditoria centralizada de acesso.

Esses mecanismos fortalecem a aplicação dos controles sem alterar o princípio fundamental de que o acesso segue responsabilidade e propósito definidos.

### 11.32 Testes de Acesso às Camadas

Os controles de acesso às camadas devem ser testados por meio de cenários positivos e negativos sempre que possível.

Testes positivos representativos incluem:

- Debezium lê as estruturas necessárias da origem e do CDC;
- Processador Bronze consome o tópico Kafka necessário e grava na Bronze;
- Processador Silver lê a Bronze e grava na Silver;
- Processador Gold lê a Silver e grava candidatas na Gold;
- processo de publicação publica a Certified Gold aprovada;
- Power BI lê a Certified Gold.

Testes negativos representativos incluem:

- Power BI não consegue acessar Bronze ou Silver;
- Processador Bronze não consegue modificar a Silver;
- Processador Silver não consegue modificar a Certified Gold;
- consumidor Kafka não consegue administrar o Kafka;
- consumidor comum não consegue publicar na Certified Gold;
- identidade revogada ou não autorizada não consegue acessar a camada protegida.

O comportamento esperado deve ser definido antes da execução.

A metodologia detalhada de validação é definida no Capítulo 17.

### 11.33 Evidências de Acesso às Camadas

As evidências devem demonstrar que os limites de acesso implementados se comportam conforme projetado.

Evidências relevantes podem identificar:

- identificador do teste;
- identidade ou função;
- camada arquitetural;
- recurso solicitado;
- operação solicitada;
- resultado esperado;
- resultado observado;
- resultado da autorização;
- versão da implementação;
- conclusão.

As evidências devem incluir tanto acessos necessários bem-sucedidos quanto acessos proibidos rejeitados, quando aplicável.

Credenciais, segredos e informações sensíveis desnecessárias não devem aparecer nas evidências preservadas.

### 11.34 Garantias de Acesso aos Dados por Camada Arquitetural

O modelo de acesso por camada da Atlas Engineering deve preservar as seguintes garantias:

1. cada camada arquitetural representa um limite de acesso distinto;
2. o acesso segue responsabilidade e propósito definidos;
3. o acesso a uma camada não implica automaticamente acesso a outra;
4. a conectividade técnica não estabelece, de forma independente, autorização;
5. consumidores analíticos comuns não exigem acesso direto à origem operacional;
6. o CDC permanece um limite controlado de captura, e não uma interface analítica;
7. o acesso do Debezium permanece limitado às suas responsabilidades de captura e publicação;
8. os privilégios de produtor, consumidor e administrador do Kafka permanecem distinguíveis;
9. o acesso de gravação à Bronze e à Silver permanece limitado às respectivas cargas de trabalho responsáveis pelo processamento;
10. Bronze e Silver não se tornam camadas padrão de consumo analítico;
11. o estado das candidatas da Gold permanece distinto da Certified Gold;
12. a autoridade de publicação da Certified Gold permanece distinta do consumo analítico comum;
13. o Power BI consome a Certified Gold sem exigir acesso rotineiro *upstream*;
14. as responsabilidades de orquestração e observabilidade não recebem automaticamente acesso irrestrito aos dados ou acesso administrativo;
15. metadados, quarentena, *backups* e evidências permanecem limites de acesso governados;
16. o acesso legítimo entre camadas permanece delimitado à origem, ao destino e à operação necessários;
17. *replay*, recuperação e investigação não criam silenciosamente acesso elevado permanente;
18. o acesso aos ambientes permanece separável quando existem múltiplos ambientes;
19. a matriz de acesso governada pode ser comparada com a implementação real;
20. o *access drift* é tratado como uma condição de segurança e governança que exige avaliação;
21. alterações nos limites de acesso exigem revisão explícita;
22. os controles de acesso às camadas implementados podem ser testados por meio de comportamentos necessários e proibidos.

---

## 12. Governança de Schemas, Contratos e Metadados

A Atlas Engineering trata *schemas*, contratos, metadados, linhagem, definições de processamento, regras de qualidade, regras de reconciliação e informações de certificação como ativos governados da plataforma.

Esses ativos definem como os dados são interpretados, transformados, validados, publicados e consumidos.

Alterações nessas definições podem modificar o comportamento da plataforma ou o significado dos dados mesmo quando a infraestrutura subjacente permanece inalterada.

A governança deve, portanto, controlar não apenas a movimentação dos dados, mas também as definições que determinam o que os dados significam e como podem ser processados.

O ciclo de vida governante é:

**Definição → Responsabilidade → Versionamento → Revisão → Alteração → Validação → Publicação → Rastreabilidade**

### 12.1 Definições Governadas

As definições governadas podem incluir, quando aplicável:

- referências de *schema* da origem;
- definições de integração ao CDC;
- contratos de eventos;
- versões de *schema*;
- políticas de compatibilidade;
- definições de processamento da Silver;
- definições dimensionais da Gold;
- grãos de fatos;
- semântica das dimensões;
- definições de medidas;
- regras de qualidade;
- regras de reconciliação;
- critérios de certificação;
- contratos de consumo analítico;
- classificações de dados;
- regras de retenção;
- metadados de linhagem;
- políticas de acesso;
- versões de processamento.

Essas definições devem permanecer identificáveis, compreensíveis e atribuíveis à responsabilidade que governam.

### 12.2 Governança do Schema da Origem

O AtlasCommerce é responsável pelo *schema* da origem operacional.

Uma alteração no *schema* da origem não redefine automaticamente os contratos analíticos *downstream*.

Alterações em tabelas, colunas, tipos de dados, chaves ou semântica da origem devem ser avaliadas quanto ao impacto sobre:

- captura por CDC;
- Debezium;
- contratos de eventos;
- eventos Kafka;
- histórico da Bronze;
- transformações da Silver;
- estruturas da Gold;
- regras de qualidade;
- reconciliação;
- linhagem;
- privacidade;
- produtos analíticos.

A plataforma de Engenharia de Dados não deve interpretar silenciosamente uma alteração no *schema* da origem como autorização para alterar o significado *downstream*.

### 12.3 Governança de Contratos de Eventos

Os contratos de eventos definem a interface controlada entre a produção e o consumo de eventos.

Eles devem permanecer:

- versionados;
- sob responsabilidade definida;
- documentados;
- testáveis;
- rastreáveis;
- governados por expectativas de compatibilidade.

O Apicurio Registry fornece o registro técnico para versões de *schema* de eventos e políticas de compatibilidade na Versão 1.

A aceitação pelo registro, por si só, não estabelece aprovação semântica.

Uma alteração pode ser estruturalmente compatível e ainda assim exigir revisão de seu significado *downstream*.

### 12.4 Responsabilidade pelos Contratos

Cada contrato de evento governado deve possuir um responsável ou uma função responsável identificável.

A responsabilidade deve permitir determinar:

- quem aprova alterações;
- quem avalia compatibilidade;
- quem compreende o comportamento do produtor;
- quem avalia o impacto sobre os consumidores;
- quem coordena a migração de alterações incompatíveis;
- quem decide sobre descontinuação e remoção.

A Versão 1 pode consolidar essas responsabilidades sob um único operador, preservando sua distinção lógica.

### 12.5 Versionamento de Contratos

As versões dos contratos devem permanecer distinguíveis ao longo do tempo.

O versionamento dá suporte a:

- interpretação histórica;
- *replay*;
- migração;
- *debugging*;
- análise de impacto;
- compatibilidade dos consumidores;
- linhagem.

Uma nova versão não deve tornar os dados históricos governados da Bronze impossíveis de interpretar enquanto esse histórico permanecer sujeito a *replay* ou investigação.

### 12.6 Governança de Compatibilidade

A governança de compatibilidade deve proteger a relação suportada entre produtores e consumidores.

A avaliação deve distinguir:

**Compatibilidade Estrutural**
→ se a alteração do *schema* é tecnicamente aceitável de acordo com a política de compatibilidade configurada.

**Compatibilidade Semântica**
→ se o significado resultante permanece válido para os consumidores suportados.

Ambas devem ser consideradas antes do *deployment* normal.

A aceitação técnica pelo registro não estabelece, de forma independente, aprovação semântica.

### 12.7 Governança de Alterações Incompatíveis

Uma alteração incompatível exige um caminho explícito de migração.

A migração pode exigir:

- uma nova versão do contrato;
- alterações no produtor;
- alterações nos consumidores;
- suporte paralelo;
- *rollout* controlado;
- suporte à interpretação histórica;
- descontinuação da versão anterior;
- testes e documentação atualizados.

Alterações incompatíveis não devem ser introduzidas silenciosamente em um contrato existente que deva permanecer compatível.

### 12.8 Governança das Definições de Processamento

A lógica de transformação faz parte do produto de dados governado.

As definições de processamento podem incluir:

- *parsing*;
- normalização;
- deduplicação;
- aplicação de regras de negócio;
- mapeamento dimensional;
- tratamento histórico;
- tratamento de exclusões;
- avaliação de qualidade;
- reconciliação;
- preparação para certificação.

Uma alteração de código capaz de modificar o significado dos dados resultantes deve, portanto, ser tratada como uma alteração governada de processamento.

### 12.9 Versão de Processamento da Silver

O processamento da Silver deve permanecer atribuível a uma versão de processamento identificável quando necessário para reprodutibilidade, *replay*, investigação ou evidências.

A versão deve permitir que a plataforma determine qual lógica de transformação produziu um resultado governado da Silver.

Um *replay* utilizando uma versão de processamento mais recente pode legitimamente produzir um resultado diferente da execução original.

Essa diferença deve ser explicável, em vez de ser silenciosamente interpretada como corrupção.

### 12.10 Versão de Processamento da Gold

O processamento da Gold também deve permanecer atribuível à lógica de transformação que produziu seu estado analítico.

Alterações relevantes podem incluir:

- grão do fato;
- mapeamento dimensional;
- comportamento de SCD;
- lógica das medidas;
- tratamento de membros desconhecidos;
- semântica de exclusão;
- tratamento histórico;
- preparação para certificação.

Uma definição da Gold materialmente alterada deve permanecer distinguível da versão que substitui.

### 12.11 Governança das Regras de Qualidade

As regras de qualidade de dados são definições governadas.

Cada regra relevante deve identificar, quando aplicável:

- identificador da regra;
- escopo;
- propósito;
- severidade;
- comportamento esperado;
- tratamento de falhas;
- responsável;
- versão.

Uma alteração em uma regra de qualidade pode modificar quais dados são aceitos, colocados em quarentena, rejeitados ou certificados.

Essas alterações devem, portanto, ser revisáveis e rastreáveis.

### 12.12 Governança das Regras de Reconciliação

As regras de reconciliação definem como a plataforma determina se o processamento permanece quantitativa e semanticamente consistente entre os limites.

A reconciliação governada pode incluir:

- contagens de linhas;
- contagens de transações;
- totais financeiros;
- totais de controle;
- comparações entre origem e destino;
- expectativas de completude.

Alterações na lógica de reconciliação podem modificar os resultados da certificação e devem, portanto, permanecer explícitas e rastreáveis.

### 12.13 Governança da Certificação

Os critérios de certificação definem quando uma candidata da Gold pode se tornar visível aos consumidores por meio da Certified Gold.

A certificação deve se basear em requisitos explícitos, em vez de ser inferida a partir da conclusão bem-sucedida de um *job*.

Os critérios podem incluir:

- processamento bem-sucedido;
- resultados de qualidade;
- resultados de reconciliação;
- metadados necessários;
- linhagem esperada;
- informações de versão necessárias;
- ausência de falhas bloqueadoras.

A conclusão bem-sucedida de um *pipeline* não significa, de forma independente, que sua saída esteja certificada.

### 12.14 Governança do Contrato de Consumo Analítico

Os produtos analíticos certificados expõem um contrato governado de consumo aos consumidores *downstream*.

Esse contrato pode definir:

- conjuntos de dados disponíveis;
- dimensões;
- medidas;
- grãos;
- semântica;
- expectativas de atualização;
- classificações;
- campos suportados;
- expectativas de compatibilidade voltadas aos consumidores.

O contrato de consumo analítico é distinto do contrato de eventos *upstream*.

Um consumidor não deve precisar compreender a representação interna dos eventos para utilizar corretamente a Certified Gold.

### 12.15 Governança de Metadados

Os metadados fazem parte do estado governado da plataforma.

Eles devem permanecer suficientemente precisos para explicar:

- quais dados existem;
- o que significam;
- de onde se originaram;
- como foram processados;
- qual versão os produziu;
- quem é responsável por eles;
- como são classificados;
- quais controles se aplicam;
- se estão certificados.

Metadados que não refletem mais a implementação criam risco de governança mesmo quando o processamento continua sendo executado com sucesso.

### 12.16 Metadados Técnicos

Os metadados técnicos descrevem características de implementação e processamento.

Exemplos podem incluir:

- *schema*;
- tabela ou conjunto de dados;
- coluna ou campo;
- tipo de dado;
- versão do contrato;
- versão de processamento;
- posição na origem;
- identificador da execução;
- local de armazenamento;
- partição;
- *timestamps*;
- identificadores de linhagem.

Os metadados técnicos devem dar suporte à operação, *replay*, investigação, validação e reprodutibilidade.

### 12.17 Metadados de Negócio

Os metadados de negócio descrevem o significado e o uso pretendido das informações governadas.

Exemplos podem incluir:

- definição de negócio;
- responsável de negócio;
- grão do fato;
- significado da dimensão;
- definição da medida;
- propósito analítico;
- regras de interpretação;
- consumidor esperado.

A correção técnica não substitui o significado de negócio.

Um campo perfeitamente preenchido cuja semântica não esteja clara continua sendo um problema de governança.

### 12.18 Metadados de Governança e Metadados de Segurança

Os metadados de governança e segurança descrevem os controles relacionados aos ativos governados.

Exemplos podem incluir:

- classificação;
- condição de dado pessoal;
- política de retenção;
- responsável;
- política de acesso;
- estado de certificação;
- versão da regra de qualidade;
- versão da regra de reconciliação;
- estado de descontinuação;
- requisito de segurança.

Esses metadados podem, por si próprios, revelar informações arquiteturais ou de segurança sensíveis e devem ser protegidos de acordo com seu conteúdo.

### 12.19 Responsabilidade pelos Metadados

Os metadados governados exigem uma responsabilidade identificável.

A responsabilidade deve permitir determinar quem é responsável por:

- correção;
- manutenção;
- revisão;
- aprovação;
- ciclo de vida;
- sincronização com a implementação.

Diferentes categorias de metadados podem possuir diferentes responsáveis.

A Versão 1 pode consolidar operacionalmente a responsabilidade, preservando as responsabilidades lógicas.

### 12.20 Governança da Linhagem

A linhagem deve explicar as relações governadas por meio das quais os dados são produzidos.

Para o fluxo Sales, a linhagem pode descrever:

**AtlasCommerce → CDC → Contrato de Evento → Kafka → Bronze → Silver → Gold → Certified Gold**

Quando necessário, a linhagem também deve preservar as relações entre:

- objeto da origem;
- posição na origem;
- identidade do evento;
- versão do contrato;
- versão de processamento;
- resultado de qualidade;
- resultado de reconciliação;
- estado de certificação;
- produto analítico.

A linhagem deve explicar a proveniência dos dados sem reproduzir desnecessariamente valores sensíveis.

### 12.21 Relações entre Versões

A Atlas Engineering contém múltiplas dimensões independentes de versão.

Exemplos incluem:

- versão do *schema* da origem;
- versão do contrato de evento;
- versão de processamento da Silver;
- versão de processamento da Gold;
- versão da regra de qualidade;
- versão da regra de reconciliação;
- versão do produto analítico;
- versão da infraestrutura ou do *deployment*.

Essas versões não devem ser consolidadas em uma única versão ambígua da plataforma.

Quando necessário para rastreabilidade, suas relações devem permanecer identificáveis.

Por exemplo:

**Contrato V2 + Processamento Silver V4 + Processamento Gold V3 → Produto Certificado V5**

Isso permite que um estado publicado seja rastreado até as definições que o produziram.

### 12.22 Análise de Impacto das Alterações

Uma alteração governada deve ser avaliada quanto ao impacto *downstream* antes do *deployment* normal, sempre que possível.

A análise de impacto pode considerar:

- produtores;
- consumidores;
- contratos;
- dados históricos;
- *replay*;
- Silver;
- Gold;
- regras de qualidade;
- reconciliação;
- certificação;
- linhagem;
- privacidade;
- retenção;
- *dashboards*;
- evidências.

O escopo da revisão deve refletir a relevância da alteração.

Nem toda alteração exige o mesmo processo de governança, mas impactos materiais *downstream* não devem ser ignorados.

### 12.23 Aprovação de Alterações

Alterações em ativos governados devem possuir um caminho de aprovação identificável e apropriado à sua relevância.

Exemplos incluem alterações em:

- contratos de eventos;
- semânticas incompatíveis;
- grão da Gold;
- regras de qualidade;
- lógica de reconciliação;
- critérios de certificação;
- classificações;
- políticas de acesso;
- regras de retenção.

A Versão 1 pode consolidar a aprovação sob um único operador.

A arquitetura, entretanto, distingue a criação de uma alteração da aprovação de seu significado governado.

### 12.24 Architecture Decision Records

Decisões arquiteturais significativas devem ser preservadas por meio de Architecture Decision Records (ADRs), quando apropriado.

Um ADR deve explicar:

- contexto;
- decisão;
- alternativas relevantes;
- consequências;
- estado.

Os ADRs são particularmente úteis quando uma decisão seria difícil de reconstruir posteriormente apenas a partir da implementação.

Eles complementam a documentação de arquitetura, em vez de substituí-la.

### 12.25 Consistência da Documentação

A documentação governada deve permanecer sincronizada com a arquitetura e com a implementação validada.

A documentação relevante pode incluir:

- arquitetura;
- fluxo de dados;
- padrões;
- contratos;
- metadados;
- segurança e governança;
- ADRs;
- testes;
- procedimentos operacionais.

A documentação não deve permanecer conscientemente inconsistente com a implementação validada sem identificar claramente a divergência.

Quando a implementação se tornar a fonte técnica da verdade validada, a documentação deve ser atualizada de acordo.

### 12.26 Metadata Drift

*Metadata drift* ocorre quando os metadados governados deixam de representar a plataforma implementada.

Exemplos incluem:

- responsável incorreto;
- classificação obsoleta;
- definição de campo desatualizada;
- versão de processamento incorreta;
- linhagem desatualizada;
- local de armazenamento incorreto;
- metadados de retenção obsoletos.

O *metadata drift* deve ser tratado como um defeito de governança, e não como uma dívida inofensiva de documentação.

### 12.27 Contract Drift

*Contract drift* ocorre quando o comportamento do produtor ou consumidor diverge do contrato governado.

Exemplos incluem:

- produtor emite campos não documentados;
- produtor altera o significado de um campo sem versionamento;
- consumidor depende de premissas não documentadas;
- implementação aceita versões de contrato não suportadas;
- estado do registro difere da documentação aprovada do contrato.

O *contract drift* deve ser detectável por meio de validação sempre que possível.

### 12.28 Quality Rule Drift

*Quality-rule drift* ocorre quando a validação implementada deixa de corresponder à definição governada de qualidade.

Exemplos incluem:

- regra desabilitada sem documentação;
- limite alterado apenas no código;
- severidade alterada sem revisão de governança;
- comportamento de quarentena diferente da regra documentada.

Como os resultados de qualidade podem influenciar a certificação, o *quality-rule drift* pode alterar o limite de confiança visível aos consumidores.

### 12.29 Certified Product Drift

*Certified-product drift* ocorre quando o produto analítico visível aos consumidores deixa de corresponder à sua definição governada.

Exemplos incluem:

- alteração não documentada de medida;
- alteração de grão;
- dimensão ausente;
- atributo sensível adicional;
- comportamento de atualização alterado;
- alteração de *schema* não aprovada.

A Certified Gold não deve evoluir silenciosamente fora de seu contrato governado de consumo.

### 12.30 Governança do Ciclo de Vida

Os ativos governados exigem estados de ciclo de vida apropriados ao seu tipo.

Um ciclo de vida representativo é:

**Rascunho → Revisado → Aprovado → Ativo → Descontinuado → Removido**

Nem todo ativo exige exatamente esses rótulos, mas o estado do ciclo de vida deve permanecer identificável quando relevante.

Um ativo não deve passar de um estado experimental ou de rascunho para o uso governado normal apenas porque está tecnicamente disponível.

### 12.31 Descontinuação

A descontinuação indica que um ativo permanece temporariamente disponível, mas não deve mais ser selecionado para novos usos normais.

Um contrato ou conjunto de dados descontinuado deve identificar, quando aplicável:

- substituto;
- consumidores restantes;
- expectativa de migração;
- período de suporte;
- critérios de remoção.

A descontinuação deve permanecer visível.

Um ativo não deve ser efetivamente removido enquanto consumidores suportados ainda dependerem dele sem uma decisão explícita de migração.

### 12.32 Remoção

A remoção encerra o suporte normal a um ativo governado.

Antes da remoção, a governança deve avaliar:

- consumidores ativos;
- *replay* histórico;
- recuperação;
- linhagem;
- retenção;
- *backups*;
- auditoria;
- documentação.

Por exemplo, uma versão de contrato de evento pode ser removida do uso normal em produção enquanto dados históricos da Bronze ainda exigirem essa versão para interpretação.

Nesse caso, a capacidade de interpretação histórica deve permanecer disponível por meio de um mecanismo aprovado.

### 12.33 Governança Durante a Recuperação

A recuperação não suspende a governança.

*Replay*, *rebuild*, *backfill*, *rollback* e recuperação de desastre devem utilizar:

- contratos aprovados;
- versões de processamento identificáveis;
- regras de qualidade governadas;
- reconciliação governada;
- acesso controlado;
- execução rastreável.

A recuperação emergencial não deve introduzir silenciosamente comportamentos não documentados de *schema*, transformação, qualidade, reconciliação ou certificação.

### 12.34 Governança Durante a Experimentação

O laboratório pode incluir experimentos utilizados para avaliar alternativas arquiteturais.

Os artefatos experimentais devem permanecer distinguíveis do estado governado da plataforma.

Exemplos incluem:

- tópicos experimentais;
- transformações temporárias;
- conjuntos de dados para *benchmark*;
- protótipos de controles de segurança.

Um experimento não deve silenciosamente se tornar uma dependência arquitetural governada apenas porque funcionou com sucesso.

Quando um experimento se tornar parte da arquitetura aprovada, a decisão e a implementação resultantes devem entrar no ciclo de vida normal de governança.

### 12.35 Estrutura do Repositório de Governança

As definições governadas devem ser armazenadas em locais previsíveis do repositório, de acordo com seu propósito.

A organização do repositório deve permitir distinguir, por exemplo:

- arquitetura;
- padrões;
- contratos;
- implementação;
- testes;
- evidências;
- documentação de negócio;
- ADRs.

A estrutura exata pode evoluir, mas os ativos governados não devem ficar dispersos de maneira imprevisível, sem responsabilidade ou contexto.

### 12.36 Artefatos de Governança Públicos e Privados

Nem todo artefato de governança precisa ser público.

Artefatos públicos podem incluir:

- arquitetura;
- padrões;
- *schemas* aprovados;
- exemplos;
- evidências sanitizadas.

Artefatos privados ou restritos podem incluir:

- credenciais;
- detalhes de implementação sensíveis à segurança;
- material de investigação de privacidade;
- dados pessoais reais;
- evidências restritas;
- informações de incidentes.

As decisões de publicação devem seguir os requisitos de classificação, privacidade e segurança.

A existência de um artefato no projeto não justifica, de forma independente, sua publicação.

### 12.37 Testes de Governança

Os controles de governança devem ser testados quando a implementação permitir.

Testes representativos incluem:

- produtor está em conformidade com o contrato de evento aprovado;
- alteração incompatível de contrato é rejeitada;
- Silver interpreta corretamente as versões de contrato suportadas;
- saída da Gold reflete o grão documentado;
- implementação de qualidade corresponde à regra governada;
- implementação da reconciliação corresponde à sua definição governada;
- Certified Gold corresponde ao seu contrato documentado de consumo;
- ativos descontinuados permanecem identificáveis;
- ativos removidos não podem ser selecionados para novo processamento normal;
- metadados refletem corretamente a implementação atual;
- linhagem preserva as relações esperadas entre versões.

A metodologia detalhada de validação é definida no Capítulo 17.

### 12.38 Evidências de Governança

As evidências de governança podem identificar:

- ativo governado;
- responsável;
- versão atual;
- definição esperada;
- definição implementada;
- identificador do teste;
- comportamento esperado;
- comportamento observado;
- dependências afetadas;
- referência da decisão;
- *timestamp*;
- versão da implementação;
- conclusão.

As evidências devem demonstrar o comportamento de governança sem expor desnecessariamente informações Confidenciais ou Restritas.

Uma definição documentada, por si só, não comprova que a implementação esteja em conformidade com ela.

### 12.39 Garantias de Governança de Schemas, Contratos e Metadados

O modelo de governança da Atlas Engineering deve preservar as seguintes garantias:

1. *schemas*, contratos, metadados, definições de processamento, regras de qualidade, regras de reconciliação e critérios de certificação são ativos governados;
2. alterações no *schema* da origem não redefinem automaticamente os contratos *downstream*;
3. contratos de eventos permanecem versionados, sob responsabilidade definida, documentados, rastreáveis e testáveis;
4. compatibilidade estrutural e compatibilidade semântica permanecem distintas;
5. alterações incompatíveis exigem migração explícita;
6. a lógica de processamento da Silver e da Gold permanece identificável pela versão de processamento quando necessário;
7. as definições de qualidade e reconciliação permanecem governadas quando alterações podem afetar o processamento ou a certificação;
8. os critérios de certificação permanecem explícitos, em vez de serem inferidos a partir da execução bem-sucedida;
9. os contratos de consumo analítico permanecem distintos dos contratos de eventos;
10. os metadados incluem significado técnico e de negócio, quando aplicável;
11. os metadados de governança e segurança são protegidos de acordo com sua sensibilidade;
12. dimensões independentes de versão permanecem distinguíveis;
13. alterações governadas incluem análise de impacto *downstream* sempre que possível;
14. decisões arquiteturais significativas podem ser preservadas por meio de ADRs;
15. a documentação permanece parte do estado governado da plataforma;
16. *metadata drift*, *contract drift*, *quality-rule drift* e *certified-product drift* são defeitos de governança;
17. os ativos governados seguem comportamentos controlados de ciclo de vida e descontinuação;
18. a remoção considera consumidores ativos, *replay*, recuperação, linhagem, retenção e interpretação histórica;
19. a recuperação não contorna as definições governadas;
20. experimentos permanecem distinguíveis do estado aprovado da plataforma;
21. artefatos de governança públicos e privados são distinguidos de acordo com classificação e propósito;
22. o comportamento de governança implementado é testável e baseado em evidências;
23. as afirmações de governança permanecem limitadas ao comportamento efetivamente implementado e validado.

---

## 13. Retenção, Arquivamento e Descarte

Retenção, arquivamento e descarte governam por quanto tempo dados, metadados, estado de processamento, evidências e ativos de recuperação permanecem disponíveis na Atlas Engineering.

A plataforma não deve reter informações indefinidamente apenas porque há capacidade de armazenamento disponível.

As decisões de retenção devem equilibrar:

- propósito de negócio e analítico;
- requisitos de recuperação e *replay*;
- auditabilidade;
- linhagem;
- privacidade;
- segurança;
- requisitos legais ou organizacionais aplicáveis;
- custo de armazenamento.

Diferentes camadas arquiteturais podem exigir diferentes períodos de retenção porque atendem a responsabilidades distintas.

O ciclo de vida governante é:

**Criar → Utilizar → Reter → Arquivar Quando Necessário → Descartar de Acordo com a Política**

### 13.1 Princípios de Retenção

As decisões de retenção devem seguir diversos princípios arquiteturais:

- reter dados somente para um propósito aprovado;
- distinguir retenção operacional de retenção histórica;
- distinguir retenção *online* de retenção em arquivo;
- preservar histórico suficiente para atender aos requisitos aprovados de recuperação e *replay*;
- evitar retenção indefinida sem justificativa;
- considerar classificação e privacidade;
- preservar os metadados necessários para interpretar os dados retidos;
- coordenar a retenção com o ciclo de vida de *backups* e chaves criptográficas;
- descartar informações por meio de procedimentos controlados.

A retenção faz parte da arquitetura e da governança, e não apenas da configuração de armazenamento.

### 13.2 Retenção por Camada Arquitetural

Os requisitos de retenção diferem entre as camadas da plataforma.

Por exemplo:

**Kafka**
→ retenção limitada para transporte operacional e *replay*.

**Bronze**
→ retenção histórica durável que dá suporte a *replay* e reconstrução.

**Silver**
→ retenção de processamento padronizado de acordo com as necessidades de reconstrução e análise.

**Gold**
→ retenção analítica de acordo com os requisitos do produto.

**Certified Gold**
→ retenção da publicação governada e de versões históricas de acordo com requisitos dos consumidores, auditoria, *rollback* e recuperação.

Não se deve presumir que essas durações sejam idênticas.

### 13.3 Retenção do Kafka

A retenção do Kafka dá suporte a:

- armazenamento temporário assíncrono;
- interrupção temporária dos consumidores;
- *replay* operacional;
- investigação;
- recuperação normal a partir de *offsets* confirmados.

O Kafka não é o arquivo histórico permanente da plataforma analítica.

Seu período de retenção deve dar suporte aos cenários de indisponibilidade e recuperação que dependem do Kafka como primeira fonte de recuperação.

O valor final deve ser orientado por fatores medidos, como:

- volume de eventos;
- duração esperada da interrupção;
- tempo de recuperação do *backlog*;
- capacidade de armazenamento;
- requisitos de *replay*;
- comportamento de recuperação dos consumidores.

Se o histórico necessário estiver fora da retenção do Kafka, a recuperação deve utilizar outra fonte histórica aprovada.

### 13.4 Retenção do CDC

O histórico do SQL Server CDC também está sujeito à retenção.

O CDC deve reter as alterações confirmadas por tempo suficiente para que o caminho de captura possa consumi-las sob as condições esperadas de interrupção.

A plataforma deve considerar a relação entre:

- histórico disponível do CDC;
- progresso do Debezium;
- volume de alterações na origem;
- interrupção *downstream*.

Se o histórico necessário do CDC expirar antes que a captura seja concluída, a ingestão incremental normal poderá deixar de ser completa.

Essa condição deve ser detectável.

A recuperação deve então seguir um procedimento explícito de *backfill*, *rebuild* ou outro procedimento aprovado, em vez de ignorar silenciosamente o histórico ausente.

### 13.5 Retenção da Bronze

A Bronze é a principal base histórica de longo prazo para *replay* e reconstrução *downstream*.

A retenção deve considerar:

- requisitos de *rebuild* da Silver;
- requisitos de *rebuild* da Gold;
- necessidades analíticas históricas;
- suporte aos contratos de eventos;
- linhagem;
- auditabilidade;
- privacidade;
- capacidade de armazenamento;
- estratégia de *backup*.

A retenção da Bronze pode ser maior que a retenção do Kafka.

Entretanto:

**Base Histórica ≠ Reter para Sempre**

A retenção deve permanecer vinculada aos requisitos aprovados.

### 13.6 Retenção da Silver

A retenção da Silver depende de como a camada padronizada é utilizada.

A Silver pode dar suporte a:

- processamento incremental da Gold;
- *rebuild* da Gold;
- reconciliação;
- *troubleshooting*;
- reutilização analítica;
- reprocessamento controlado.

Se a Silver puder ser reconstruída a partir do histórico retido na Bronze, sua retenção pode legitimamente diferir da Bronze.

Dados derivados não devem ser retidos por mais tempo do que seu valor operacional ou analítico justifique.

### 13.7 Retenção da Gold

A retenção da Gold é determinada por requisitos analíticos e de negócio.

A Gold pode conter:

- fatos;
- dimensões;
- versões dimensionais históricas;
- estados candidatos;
- metadados de processamento.

A retenção deve considerar:

- histórico analítico;
- dimensões de alteração lenta;
- requisitos do produto;
- capacidade de *rebuild*;
- histórico de certificação;
- requisitos financeiros, legais ou organizacionais aplicáveis;
- custo de armazenamento.

O histórico analítico retido deve permanecer interpretável enquanto permanecer governado e disponível.

### 13.8 Retenção da Certified Gold

A Certified Gold pode exigir a retenção de:

- versão publicada atual;
- versões certificadas anteriores.

Versões anteriores podem dar suporte a:

- *rollback*;
- auditoria;
- investigação;
- comparação;
- reprodutibilidade;
- recuperação.

A quantidade ou a idade das versões certificadas retidas deve ser governada, em vez de crescer indefinidamente.

### 13.9 Retenção de Dados Candidatos

Dados candidatos com falha ou substituídos podem manter valor de diagnóstico ou governança no curto prazo.

A retenção deve considerar:

- investigação;
- evidências de qualidade;
- evidências de reconciliação;
- recuperação;
- sensibilidade;
- impacto no armazenamento.

Uma candidata com falha não exige automaticamente o mesmo período de retenção de uma versão certificada publicada.

Quando os dados candidatos forem removidos, ainda poderá ser necessário preservar evidências suficientes para explicar o resultado da certificação.

### 13.10 Retenção da Quarentena

Os registros em quarentena exigem um ciclo de vida explícito.

Eles não devem se acumular indefinidamente porque a responsabilidade ou a resolução não está clara.

Um registro em quarentena deve eventualmente alcançar um estado como:

**Remediado**

**Reprocessado**

**Rejeitado**

**Descartado**

A retenção deve refletir:

- janela de remediação;
- investigação;
- privacidade;
- segurança;
- necessidades de *replay*;
- disposição final.

### 13.11 Retenção de Artefatos Temporários

Artefatos temporários de processamento devem possuir ciclos de vida curtos e controlados.

Exemplos incluem:

- arquivos intermediários;
- saídas parciais;
- estruturas SQL temporárias;
- áreas de trabalho de recuperação;
- extrações de diagnóstico.

O processamento bem-sucedido deve remover os artefatos temporários que não sejam mais necessários.

O tratamento de falhas também deve incluir limpeza para que artefatos abandonados não se tornem armazenamento não gerenciado.

### 13.12 Retenção de Logs

Os *logs* dão suporte a:

- *troubleshooting*;
- observabilidade;
- investigação de incidentes;
- análise de segurança;
- evidências.

A retenção deve equilibrar:

- valor operacional;
- volume de armazenamento;
- relevância para segurança;
- privacidade;
- exposição de dados sensíveis;
- requisitos de evidências.

Uma retenção mais longa de *logs* não é automaticamente melhor.

As informações sensíveis devem primeiro ser minimizadas no projeto de *logging*, em vez de serem retidas indefinidamente sob proteção mais forte.

### 13.13 Retenção de Métricas

A retenção de métricas deve dar suporte a:

- análise de linha de base;
- avaliação de SLO;
- planejamento de capacidade;
- investigação de incidentes;
- análise de tendências;
- evidências de validação.

Diferentes resoluções podem ser apropriadas ao longo do tempo.

Métricas recentes altamente granulares podem posteriormente ser agregadas em resumos de longo prazo.

A retenção deve evoluir de acordo com as necessidades de observabilidade e a capacidade de armazenamento.

### 13.14 Retenção da Linhagem

A linhagem deve permanecer disponível para dados e versões certificadas que permaneçam governados, recuperáveis ou auditáveis.

Excluir a linhagem enquanto os dados correspondentes são retidos pode tornar esses dados impossíveis de explicar.

A retenção da linhagem deve, portanto, considerar:

- Bronze;
- Silver;
- Gold;
- Certified Gold;
- versões de contratos;
- versões de processamento;
- evidências de qualidade e certificação.

### 13.15 Retenção de Metadados

Os metadados necessários para compreender os dados retidos devem permanecer disponíveis pelo menos durante o período em que esses dados permanecerem governados e interpretáveis.

Metadados relevantes podem incluir:

- versões de *schema*;
- versões de contratos de eventos;
- versões de processamento;
- classificação;
- responsabilidade;
- definição de retenção;
- versões de regras de qualidade;
- definições analíticas.

*Bytes* retidos sem os metadados necessários para interpretá-los podem deixar de representar um ativo governado utilizável.

### 13.16 Retenção de Versões de Contratos

As definições históricas dos contratos devem permanecer disponíveis enquanto dados históricos retidos dependerem delas para interpretação, *replay* ou auditoria.

O ciclo de vida deve distinguir:

**Não Está Mais Ativo**

de:

**Não É Mais Necessário para Interpretação Histórica**

Esses momentos não são necessariamente os mesmos.

### 13.17 Retenção de Versões de Processamento

As definições de processamento ou informações suficientes para reprodutibilidade devem permanecer disponíveis quando uma saída histórica precisar continuar explicável ou reproduzível.

Isso pode se aplicar a:

- versões de processamento da Silver;
- versões de processamento da Gold;
- versões de regras de qualidade;
- definições de reconciliação;
- lógica de certificação.

Um identificador de versão sem acesso à definição governada que ele identifica pode ser insuficiente para um *replay* ou investigação significativos.

### 13.18 Retenção de Evidências

A retenção de evidências deve refletir a importância e o ciclo de vida da afirmação arquitetural à qual dá suporte.

As evidências podem dar suporte a:

- validação do caminho normal;
- recuperação;
- controles de segurança;
- controles de privacidade;
- comportamento de capacidade;
- validação de SLO;
- comportamento de certificação.

Evidências críticas não devem desaparecer enquanto a afirmação arquitetural associada continuar sendo utilizada como referência, a menos que tenham sido substituídas por meio de um ciclo governado de revalidação.

As evidências podem possuir um ciclo de vida diferente dos *logs* ou métricas brutos a partir dos quais foram criadas.

### 13.19 Retenção da Auditoria de Segurança

As informações de auditoria de segurança podem exigir retenção para:

- resposta a incidentes;
- investigação;
- revisão de acesso;
- requisitos organizacionais;
- requisitos contratuais;
- requisitos regulatórios aplicáveis.

Exemplos podem incluir:

- eventos de autenticação;
- falhas de autorização;
- alterações de privilégios;
- operações administrativas;
- alterações de configuração de segurança;
- acesso a recursos sensíveis.

A retenção da auditoria deve equilibrar o valor para investigação com privacidade, segurança e exposição de armazenamento.

### 13.20 Retenção de Backups

Os *backups* exigem sua própria política de retenção.

A retenção deve considerar:

- objetivos de recuperação;
- cobertura dos pontos de recuperação;
- requisitos de restauração histórica;
- capacidade de armazenamento;
- classificação dos dados;
- privacidade;
- disponibilidade das chaves de criptografia.

Manter *backups* por mais tempo do que os dados ativos cria uma cópia dessas informações com vida útil mais longa e deve ser justificado.

A retenção dos *backups* não deve ser definida independentemente do ciclo de vida dos dados e dos requisitos de privacidade.

### 13.21 Arquivamento

O arquivamento move dados do armazenamento ativo ou frequentemente acessado para um estado de retenção de menor custo ou de acesso menos imediato, preservando seu uso futuro aprovado.

O arquivamento pode dar suporte a:

- análise histórica;
- auditoria;
- requisitos legais aplicáveis;
- recuperação de longo prazo;
- evidências.

Dados arquivados continuam sendo dados governados.

O arquivamento não remove:

- classificação;
- requisitos de privacidade;
- controle de acesso;
- requisitos de criptografia;
- requisitos de retenção;
- responsabilidade pelo descarte.

### 13.22 Dados Online versus Dados Arquivados

A arquitetura distingue:

**Retenção Online**
→ dados prontamente disponíveis para o processamento ou consumo normal da plataforma.

**Retenção Arquivada**
→ dados preservados para propósitos históricos aprovados, mas não necessariamente disponíveis por meio dos caminhos normais de baixa latência.

Essa distinção pode reduzir o custo operacional e a exposição sem eliminar as informações históricas necessárias.

O mecanismo exato de arquivamento é uma decisão de implementação.

### 13.23 Arquivamento e Replay

Dados arquivados podem dar suporte a *replay* ou reconstrução somente quando o arquivo preserva as informações necessárias para sua interpretação correta.

Isso pode incluir:

- conteúdo dos dados;
- identidade do evento;
- *timestamps*;
- versão do contrato;
- metadados de processamento;
- informações de integridade.

Um arquivo que preserva *bytes*, mas não pode ser interpretado ou restaurado de maneira confiável, não atende a um requisito de *replay*.

### 13.24 Arquivamento e Criptografia

Dados criptografados arquivados podem permanecer retidos por longos períodos.

O ciclo de vida das chaves deve, portanto, permanecer compatível com a duração do arquivamento.

Destruir prematuramente a chave necessária pode tornar os dados retidos inutilizáveis.

Reter chaves indefinidamente sem proteção adequada pode enfraquecer a segurança.

O arquivamento e o ciclo de vida das chaves criptográficas devem, portanto, ser coordenados.

### 13.25 Retenção e Privacidade

A retenção de dados pessoais deve permanecer vinculada ao propósito aprovado e aos requisitos aplicáveis.

O valor de *replay* ou a utilidade analítica não justificam automaticamente a retenção indefinida de informações de identificação.

Quando o valor histórico permanecer, mas a identidade direta não for mais necessária, a governança pode avaliar abordagens como:

- remoção de atributos;
- pseudonimização;
- anonimização;
- agregação;
- arquivamento restrito.

O tratamento apropriado depende dos requisitos governados de privacidade e de negócio.

### 13.26 Retenção e Solicitações dos Titulares dos Dados

Solicitações de privacidade aprovadas podem afetar dados em múltiplos níveis de retenção.

A plataforma deve ser capaz de identificar locais relevantes, como:

- conjuntos de dados ativos;
- camadas históricas;
- quarentena;
- *backups*;
- exportações;
- arquivos.

A ação necessária depende do processo de privacidade e jurídico aplicável.

A arquitetura deve dar suporte à execução do resultado técnico aprovado sempre que viável.

### 13.27 Retenção e Risco de Replay

Uma retenção histórica longa aumenta a capacidade de *replay* e reconstrução.

Ela também aumenta:

- exposição de privacidade;
- exposição de segurança;
- custo de armazenamento;
- suporte a versões de contratos;
- requisitos de linhagem;
- responsabilidade por *backups*.

As decisões de retenção devem, portanto, equilibrar:

**Capacidade de Recuperação e Valor Histórico**

com:

**Exposição de Segurança + Exposição de Privacidade + Custo de Armazenamento**

A retenção máxima não é automaticamente a arquitetura mais segura.

### 13.28 Retenção e Certificação

Produtos analíticos certificados podem ser recalculados ou republicados ao longo de períodos históricos.

A retenção deve preservar os dados e as definições governadas necessárias para qualquer capacidade de reconstrução declarada.

Se os dados ou versões históricas necessários tiverem sido intencionalmente descartados, essa limitação deve ser documentada.

A plataforma não deve afirmar capacidade de reconstrução além do histórico retido.

### 13.29 Descarte

O descarte ocorre quando dados ou artefatos governados deixam de possuir um propósito aprovado de retenção.

Ele pode se aplicar a:

- dados ativos;
- dados temporários;
- dados arquivados;
- quarentena;
- *logs*;
- métricas;
- evidências;
- *backups*;
- metadados;
- credenciais;
- chaves criptográficas.

O mecanismo de descarte apropriado depende da tecnologia, do tipo de informação, da classificação e do requisito de retenção.

### 13.30 Exclusão Lógica

A exclusão lógica remove informações do uso ativo normal sem necessariamente remover imediatamente sua representação física.

Exemplos podem incluir:

- alterações de estado do ciclo de vida;
- remoção da publicação ativa;
- revogação de acesso;
- estado de exclusão no nível da aplicação.

A exclusão lógica não deve ser automaticamente representada como descarte físico.

A distinção deve permanecer explícita.

### 13.31 Descarte Físico

O descarte físico busca remover informações retidas de acordo com as capacidades da tecnologia de armazenamento.

O comportamento pode diferir entre:

- SQL Server;
- Kafka;
- MinIO;
- armazenamento em sistema de arquivos;
- *backups*;
- arquivos.

Informações excluídas podem permanecer temporariamente em:

- *logs*;
- *snapshots*;
- versões de objetos;
- *backups*;
- mecanismos internos de armazenamento.

Os requisitos de descarte devem, portanto, refletir o comportamento real da tecnologia, em vez de presumir que um DELETE lógico remova imediatamente todas as cópias físicas.

### 13.32 Descarte Criptográfico

Quando suportado e apropriado, a destruição das chaves de criptografia pode tornar os dados protegidos inacessíveis.

Não se deve presumir automaticamente que o descarte criptográfico seja efetivo.

Sua eficácia depende de fatores como:

- isolamento das chaves;
- ausência de cópias não criptografadas;
- ausência de chaves alternativas;
- comportamento dos *backups*;
- implementação da tecnologia.

O apagamento criptográfico deve ser validado antes de ser declarado como um mecanismo seguro de descarte.

### 13.33 Descarte e Backups

A remoção de informações do armazenamento ativo não as remove automaticamente dos *backups*.

A retenção de *backups* e os procedimentos de restauração devem, portanto, considerar dados que foram excluídos, transformados ou invalidados depois que o *backup* foi criado.

Um *backup* restaurado pode exigir reconciliação com o estado atual de:

- retenção;
- privacidade;
- segurança;
- classificação;
- governança;

antes de retornar ao serviço normal.

### 13.34 Descarte e Replay

Informações intencionalmente removidas ou invalidadas não devem reaparecer silenciosamente por meio de *replay*, restauração ou *rebuild*.

A recuperação deve considerar as decisões de governança tomadas após a criação da fonte de recuperação.

Isso é especialmente importante para:

- remoção orientada por privacidade;
- remoção orientada por segurança;
- credenciais invalidadas;
- dados Restritos descontinuados.

A regra governante é:

**A Recuperação Restaura o Estado Técnico — Ela Não Substitui Automaticamente Decisões de Governança Posteriores**

### 13.35 Metadados da Política de Retenção

Os ativos governados devem identificar sua política de retenção aplicável sempre que possível.

Os metadados podem incluir:

- ativo;
- responsável;
- propósito da retenção;
- retenção *online*;
- retenção arquivada;
- gatilho de descarte;
- considerações de privacidade;
- considerações de recuperação;
- referência ao requisito de negócio ou legal, quando aplicável;
- última revisão;
- estado do ciclo de vida.

Os metadados de retenção devem evoluir juntamente com o requisito que representam.

### 13.36 Responsabilidade pela Retenção

As decisões de retenção exigem responsabilidade identificável.

As funções relevantes podem incluir:

- Responsável pelos Dados de Negócio;
- Engenharia de Dados;
- DBA;
- Segurança;
- Governança de Dados;
- Privacidade / Jurídico;
- Plataforma / SRE;
- administração de *backups*.

A Versão 1 pode consolidar essas responsabilidades sob um único operador, preservando sua distinção lógica.

### 13.37 Revisão da Retenção

As políticas de retenção devem ser revisadas quando as condições mudarem.

Gatilhos relevantes incluem:

- novos conjuntos de dados;
- alterações de classificação;
- alterações nos requisitos de privacidade;
- alterações nos objetivos de recuperação;
- alterações materiais no custo de armazenamento;
- descontinuação de produtos;
- descontinuação de contratos;
- novos requisitos organizacionais ou regulatórios aplicáveis;
- evidências de que a retenção atual é insuficiente ou excessiva.

A retenção é, portanto, uma decisão de governança em evolução.

### 13.38 Retention Drift

*Retention drift* ocorre quando o comportamento implementado do ciclo de vida diverge da política governada.

Exemplos incluem:

- Kafka retendo menos histórico do que o necessário;
- dados da Bronze nunca expirando apesar da política;
- quarentena acumulando indefinidamente;
- *backups* retidos além dos períodos aprovados;
- *logs* expirando antes que as evidências necessárias possam ser criadas.

O *retention drift* deve ser detectável por meio de revisão operacional ou controles automatizados sempre que possível.

O *drift* detectado deve ser avaliado, em vez de silenciosamente se tornar a nova política.

### 13.39 Modelo de Retenção do Laboratório

Os valores de retenção da Versão 1 devem inicialmente ser tratados como premissas do laboratório até que a carga de trabalho medida e a validação forneçam evidências para seu refinamento.

O laboratório deve demonstrar, quando aplicável:

- comportamento de retenção do Kafka;
- implicações da retenção do CDC;
- retenção histórica da Bronze;
- limpeza de artefatos temporários;
- ciclo de vida da quarentena;
- retenção de *backups*;
- retenção de evidências;
- descarte controlado.

O laboratório não deve afirmar capacidade de retenção corporativa além dos cenários efetivamente testados.

### 13.40 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer a governança do ciclo de vida por meio de capacidades como:

- políticas automatizadas de ciclo de vida;
- *tiering* de armazenamento de objetos;
- classes de armazenamento para arquivamento;
- política centralizada de retenção;
- *legal hold*;
- exclusão automatizada;
- automação do ciclo de vida de *backups*;
- integração com *workflows* de privacidade;
- relatórios de retenção;
- detecção automatizada de *retention drift*;
- *policy-as-code*;
- integração com gerenciamento de registros.

Esses mecanismos fortalecem a aplicação dos controles, preservando os princípios lógicos do ciclo de vida.

### 13.41 Testes de Retenção e Descarte

Os controles de ciclo de vida implementados devem ser validados.

Testes representativos incluem:

- dados do Kafka expiram de acordo com a política configurada;
- a recuperação necessária permanece possível dentro da janela de retenção;
- artefatos temporários são limpos;
- a quarentena alcança um resultado explícito de ciclo de vida;
- dados arquivados permanecem legíveis quando necessário;
- dados descartados ficam indisponíveis por meio de seu caminho normal de acesso;
- material de segurança invalidado não é restaurado por meio da recuperação;
- *backups* restaurados recebem o tratamento de governança atual necessário;
- metadados de retenção correspondem ao comportamento implementado.

O resultado esperado deve ser definido antes da execução.

A metodologia detalhada de validação é definida no Capítulo 17.

### 13.42 Evidências de Retenção e Descarte

As evidências podem identificar:

- identificador do teste;
- ativo governado;
- regra de retenção aplicável;
- comportamento esperado do ciclo de vida;
- comportamento observado;
- estado de arquivamento, quando aplicável;
- estado de descarte;
- resultado da recuperação;
- métricas ou *logs* relevantes;
- versão da implementação;
- conclusão.

As evidências não devem reter desnecessariamente as próprias informações sensíveis cujo ciclo de vida o teste pretende controlar.

### 13.43 Garantias de Retenção, Arquivamento e Descarte

O modelo de ciclo de vida da Atlas Engineering deve preservar as seguintes garantias:

1. a retenção é governada, em vez de ser determinada exclusivamente pelos padrões das tecnologias;
2. diferentes camadas arquiteturais podem utilizar diferentes períodos de retenção;
3. Kafka e CDC fornecem histórico operacional limitado, e não armazenamento permanente de arquivo;
4. a retenção da Bronze dá suporte aos requisitos aprovados de *replay* histórico e reconstrução;
5. a retenção das camadas derivadas reflete o valor operacional e analítico, em vez de duplicação desnecessária;
6. a retenção de versões da Certified Gold dá suporte aos requisitos aprovados de *rollback*, auditoria e recuperação;
7. dados candidatos, em quarentena e temporários possuem expectativas explícitas de ciclo de vida;
8. *logs*, métricas, linhagem, metadados, contratos, versões de processamento e evidências possuem retenção apropriada ao seu propósito;
9. *backups* herdam os requisitos aplicáveis de classificação, privacidade, segurança e ciclo de vida;
10. o arquivamento preserva a governança, em vez de removê-la;
11. dados arquivados são considerados uma fonte válida de recuperação somente quando permanecem interpretáveis e restauráveis;
12. o ciclo de vida das chaves criptográficas permanece compatível com os dados criptografados retidos;
13. a retenção de dados pessoais permanece vinculada ao propósito aprovado e aos requisitos aplicáveis;
14. a retenção equilibra o valor de recuperação com a exposição de privacidade, segurança e armazenamento;
15. a capacidade de reconstrução não é afirmada além do histórico retido;
16. exclusão lógica e descarte físico permanecem distinguíveis;
17. o descarte criptográfico não é declarado sem validação de sua eficácia;
18. o descarte considera *backups*, arquivos, exportações, réplicas e fontes de recuperação;
19. a recuperação não restaura intencionalmente dados ou confiança que decisões posteriores de governança tenham invalidado;
20. as políticas de retenção possuem responsabilidade e metadados identificáveis;
21. o *retention drift* é tratado como uma questão de governança e operação;
22. as premissas de retenção do laboratório são refinadas por meio de evidências medidas;
23. o comportamento implementado do ciclo de vida é testável e baseado em evidências;
24. as afirmações sobre retenção, arquivamento e descarte permanecem limitadas ao comportamento efetivamente implementado e validado.

---

## 14. Auditabilidade e Observabilidade de Segurança

Auditabilidade e observabilidade de segurança fornecem as informações necessárias para compreender atividades relevantes para a segurança em toda a Atlas Engineering.

Os controles de segurança não devem operar como mecanismos invisíveis.

Quando tecnicamente suportado, a plataforma deve preservar informações suficientes para determinar:

- qual identidade executou ou tentou executar uma ação;
- qual recurso foi acessado;
- qual operação foi solicitada;
- se a autenticação foi bem-sucedida;
- se a autorização foi bem-sucedida;
- se houve envolvimento de privilégio elevado;
- se uma configuração sensível à segurança foi alterada;
- quando o evento ocorreu;
- qual componente o registrou;
- se o evento afetou dados, acesso, credenciais ou o comportamento da plataforma.

A auditabilidade dá suporte à responsabilização e à reconstrução.

A observabilidade de segurança dá suporte à detecção, ao monitoramento e à investigação.

O modelo governante é:

**Ação Relevante para a Segurança → Evento Estruturado → Correlação → Monitoramento → Investigação → Evidência**

### 14.1 Auditabilidade

Auditabilidade significa que atividades relevantes para a segurança podem ser atribuídas e reconstruídas de acordo com as capacidades da plataforma.

Ações relevantes podem incluir:

- tentativas de autenticação;
- decisões de autorização;
- alterações de privilégios;
- alterações de funções;
- operações do ciclo de vida de identidades;
- rotação ou revogação de credenciais;
- ações administrativas;
- alterações de configuração de segurança;
- acesso a recursos sensíveis;
- certificação e publicação;
- recuperação sensível à segurança.

Nem todo evento comum de processamento exige a mesma profundidade de auditoria.

O escopo da auditoria deve refletir risco, sensibilidade e valor operacional.

### 14.2 Observabilidade de Segurança

A observabilidade de segurança fornece visibilidade operacional sobre condições relacionadas à segurança.

Sinais relevantes podem incluir:

- falhas de autenticação;
- negações de autorização;
- acessos rejeitados repetidamente;
- atividade administrativa inesperada;
- risco de expiração de certificados;
- falhas de credenciais;
- comportamento incomum de serviços;
- falhas de controles de segurança;
- comunicação de rede inesperada;
- detecções de exposição de segredos.

A observabilidade de segurança deve integrar-se à observabilidade mais ampla da plataforma, em vez de operar como um sistema de monitoramento isolado.

### 14.3 Atribuição de Identidade

Quando tecnicamente suportado, os eventos de segurança devem identificar o responsável pela ação.

O responsável pode ser:

- uma identidade humana;
- uma identidade de serviço;
- uma identidade administrativa;
- uma identidade de orquestração;
- um consumidor analítico.

A atribuição específica deve ser preferida a identidades genéricas como:

**admin**

ou:

**service**

quando uma identidade mais precisa estiver disponível.

Contas humanas compartilhadas reduzem a qualidade da atribuição e devem ser evitadas sempre que possível.

### 14.4 Atribuição de Serviços

O processamento automatizado também deve permanecer atribuível.

A plataforma deve ser capaz de distinguir ações relevantes para a segurança executadas por serviços como:

- Debezium;
- processamento da Bronze;
- processamento da Silver;
- processamento da Gold;
- Airflow;
- Power BI;
- componentes de observabilidade.

Identidades de serviço separadas melhoram a atribuição e reduzem a ambiguidade durante investigações.

### 14.5 Eventos de Autenticação

Os eventos de autenticação devem ser observáveis quando suportados.

Resultados relevantes podem incluir:

- autenticação bem-sucedida;
- credencial inválida;
- credencial expirada;
- credencial revogada;
- identidade desabilitada;
- provedor de identidade indisponível;
- falha de certificado;
- falha na validação de *token*.

Falhas repetidas de autenticação podem representar defeitos de configuração, problemas no ciclo de vida das credenciais ou atividade não autorizada e devem ser interpretadas de acordo com o contexto.

### 14.6 Eventos de Autorização

A negação de autorização é um evento de segurança significativo.

Uma negação pode indicar:

- aplicação correta do privilégio mínimo;
- permissões incorretas;
- tentativa de acesso não autorizado;
- uso da identidade incorreta;
- *access drift*.

Quando suportado, os eventos de autorização devem identificar:

- identidade;
- recurso solicitado;
- operação solicitada;
- resultado;
- *timestamp*;
- componente.

Uma negação esperada representa aplicação bem-sucedida da segurança, e não necessariamente uma falha da plataforma.

### 14.7 Alterações de Privilégios

Alterações em funções, permissões, responsabilidades ou acesso administrativo devem ser auditáveis quando suportadas.

Eventos relevantes podem incluir:

- permissão concedida;
- permissão revogada;
- associação a função adicionada;
- associação a função removida;
- acesso elevado habilitado;
- acesso elevado removido.

Alterações de privilégios modificam o estado de segurança mesmo quando nenhum código da aplicação é alterado.

Elas devem, portanto, permanecer governadas e atribuíveis.

### 14.8 Operações Administrativas

Atividades administrativas exigem maior responsabilização do que o processamento rotineiro.

Operações relevantes podem incluir:

- alteração da configuração do Kafka;
- modificação de permissões do SQL Server;
- alteração de políticas do MinIO;
- alteração da configuração de segurança do Airflow;
- alteração de usuários ou fontes de dados do Grafana;
- modificação da exposição de rede;
- restauração de *backups*;
- alteração das configurações de retenção ou autenticação.

A atividade administrativa deve ser atribuível à identidade ou ao processo responsável.

### 14.9 Alterações de Configuração de Segurança

A configuração de segurança faz parte do estado governado da plataforma.

As alterações podem incluir:

- mecanismos de autenticação;
- políticas de autorização;
- regras de rede;
- configurações de TLS;
- confiança em certificados;
- referências a segredos;
- configuração de auditoria;
- funções de acesso.

Sempre que possível, essas alterações devem ser controladas por versão, atribuíveis, auditáveis ou rastreáveis por outro mecanismo.

### 14.10 Acesso a Recursos Sensíveis

O acesso a recursos Restritos ou de alta sensibilidade pode exigir auditabilidade reforçada.

Exemplos incluem:

- recursos de gerenciamento de segredos;
- chaves privadas;
- configuração de segurança;
- repositórios de *backup*;
- dados sensíveis em quarentena;
- interfaces administrativas privilegiadas;
- conjuntos de dados Restritos.

O projeto da auditoria deve considerar tanto acessos bem-sucedidos quanto negados sem registrar os valores protegidos propriamente ditos.

### 14.11 Auditabilidade da Certified Gold e da Publicação

Certificação e publicação são ações sensíveis à governança.

A auditabilidade deve permitir que a plataforma determine:

- qual candidata foi avaliada;
- quais resultados de qualidade e reconciliação foram aplicados;
- qual versão foi certificada;
- qual versão foi publicada;
- quando a publicação ocorreu;
- qual identidade ou processo executou a ação;
- se ocorreu *rollback*;
- qual versão se tornou visível aos consumidores.

Isso dá suporte à responsabilização pelas alterações no estado analítico governado.

### 14.12 Classificação dos Dados de Auditoria de Segurança

As informações de auditoria podem ser sensíveis.

Os *logs* de segurança podem revelar:

- nomes de usuários;
- identidades de serviço;
- nomes de *hosts*;
- nomes de recursos;
- padrões de acesso;
- falhas;
- atividade administrativa;
- arquitetura interna.

Os dados de auditoria devem, portanto, ser classificados e protegidos de acordo com seu conteúdo.

Evidências de segurança úteis não são automaticamente apropriadas para divulgação pública.

### 14.13 Segredos Não Devem Ser Auditados como Valores

A auditabilidade deve registrar atividades relacionadas a credenciais sem registrar valores reutilizáveis dessas credenciais.

Por exemplo:

**Rotação de Credencial Concluída**

é apropriado.

Registrar a nova senha, *token*, chave privada ou o valor completo do segredo não é.

Falhas de autenticação também devem evitar a preservação do material secreto fornecido.

### 14.14 Dados Pessoais em Logs de Segurança

Os *logs* de segurança devem minimizar dados pessoais.

A identidade do usuário pode ser necessária para responsabilização, mas *payloads* completos de negócio ou atributos de clientes não relacionados geralmente não são.

Quando informações de identidade humana forem retidas para fins de auditoria, o próprio sistema de auditoria passa a estar sujeito aos requisitos aplicáveis de privacidade e retenção.

### 14.15 Logging Estruturado de Segurança

Os *logs* relevantes para segurança devem utilizar campos estruturados quando suportado.

Campos úteis podem incluir:

- *timestamp*;
- componente;
- identidade;
- tipo de identidade;
- recurso;
- ação;
- resultado da autenticação;
- resultado da autorização;
- identificador de execução;
- identificador de correlação;
- severidade;
- categoria do evento;
- código de erro;
- referência à política ou função.

Eventos estruturados melhoram filtragem, correlação, alertas e preparação de evidências.

### 14.16 Correlação entre Componentes

Uma investigação de segurança pode exigir eventos de múltiplos sistemas.

Por exemplo:

**Falha de autenticação do Power BI**

pode exigir correlação com:

**Negação de autorização do SQL Server**

ou:

**Rotação de Credencial**

pode exigir correlação com:

**Falha de Autenticação do Serviço**

Sempre que possível, *timestamps*, identidades, IDs de execução ou identificadores de correlação comuns devem dar suporte à análise entre componentes.

### 14.17 Consistência Temporal

A investigação de auditoria depende de um sequenciamento confiável dos eventos.

Os componentes da plataforma devem utilizar sincronização de tempo consistente e apropriada ao ambiente.

Os *timestamps* armazenados devem permanecer inequívocos entre:

- componentes;
- fusos horários;
- *logs*;
- métricas;
- evidências.

Grandes diferenças de relógio sem explicação podem tornar a investigação não confiável.

### 14.18 Integridade da Auditoria

As informações de auditoria de segurança devem ser protegidas contra modificação ou exclusão não autorizada de acordo com sua importância.

Um responsável não deve ser capaz de executar uma ação sensível e remover trivialmente a única evidência dessa ação.

O laboratório pode utilizar controles de integridade mais simples do que uma implementação corporativa.

Ambientes corporativos podem fortalecer esse aspecto por meio de armazenamento de auditoria centralizado ou imutável.

### 14.19 Disponibilidade da Auditoria

As informações de auditoria devem permanecer disponíveis durante o período aprovado de investigação e evidências.

Registros de auditoria que expiram antes de poderem ser revisados podem fornecer valor operacional insuficiente.

A disponibilidade deve, portanto, estar alinhada a:

- requisitos de investigação;
- requisitos de evidências;
- privacidade;
- capacidade de armazenamento;
- sensibilidade.

Os requisitos detalhados de retenção são definidos no Capítulo 13.

### 14.20 Métricas de Segurança

As métricas de segurança podem resumir comportamentos sem expor desnecessariamente eventos sensíveis individuais.

Exemplos incluem:

- falhas de autenticação por período;
- negações de autorização por componente;
- quantidade de alterações de privilégios;
- uso de credenciais com falha;
- dias até a expiração de certificados;
- detecções da varredura de segredos;
- tentativas de acesso não autorizado;
- estado PASS/FAIL dos testes de segurança.

As métricas dão suporte à percepção operacional, enquanto eventos detalhados de auditoria dão suporte à investigação.

### 14.21 Dashboards de Segurança

O Grafana pode expor visões operacionais orientadas à segurança quando apropriado.

Perspectivas úteis podem incluir:

**Autenticação**
→ usuários e serviços estão se autenticando normalmente?

**Autorização**
→ as negações estão aumentando de forma inesperada?

**Credenciais**
→ estão ocorrendo problemas de expiração ou rotação?

**Segurança de Rede**
→ estão ocorrendo falhas de TLS ou comunicação?

**Atividade Privilegiada**
→ ocorreram alterações administrativas ou de permissões?

Os *dashboards* de segurança não devem expor valores secretos ou dados sensíveis desnecessários.

### 14.22 Alertas de Segurança

Os alertas de segurança devem se concentrar em condições acionáveis.

Cenários representativos incluem:

- falhas repetidas de autenticação;
- negações inesperadas de autorização;
- acesso privilegiado fora da operação esperada;
- risco de expiração de credenciais;
- risco de expiração de certificados;
- detecção por varredura de segredos;
- alteração inesperada da configuração de segurança;
- acesso repetido a recursos Restritos;
- comunicação não autorizada quando detectável.

Os limites dos alertas devem ser calibrados para evitar ruído excessivo sem possibilidade de ação.

### 14.23 Linha de Base do Comportamento de Segurança

A observabilidade de segurança se beneficia da compreensão do comportamento normal.

Exemplos incluem:

- padrões esperados de autenticação de serviços;
- volume normal de negações de autorização;
- atividade administrativa normal;
- origens de conexão esperadas;
- frequência esperada de erros de segurança.

Desvios inesperados podem dar suporte à investigação.

A Versão 1 pode começar com regras explícitas mais simples antes que exista histórico suficiente para estabelecer linhas de base comportamentais significativas.

### 14.24 Trilha de Auditoria para Alterações de Acesso

O provisionamento, a modificação e a revogação de acessos devem permanecer rastreáveis sempre que possível.

A plataforma deve ser capaz de identificar:

- qual acesso foi alterado;
- qual identidade foi afetada;
- quem ou o que executou a alteração;
- quando ela ocorreu;
- motivo associado ou referência da alteração, quando disponível.

Isso dá suporte à revisão de acessos e à investigação de *drift*.

### 14.25 Trilha de Auditoria para o Ciclo de Vida das Credenciais

Os eventos do ciclo de vida das credenciais devem ser rastreáveis sem expor seus valores.

Eventos relevantes podem incluir:

- credencial criada;
- credencial ativada;
- credencial rotacionada;
- credencial anterior revogada;
- credencial expirada;
- credencial desabilitada após comprometimento.

Isso permite que falhas de autenticação ou incidentes sejam correlacionados com o estado das credenciais.

### 14.26 Trilha de Auditoria para Recuperação

A recuperação pode envolver operações elevadas ou sensíveis à segurança.

Ações relevantes podem incluir:

- restauração de *backup*;
- elevação temporária de privilégios;
- início de *replay*;
- acesso ao ambiente de recuperação;
- substituição de credenciais;
- restauração da configuração de segurança;
- remoção dos privilégios de recuperação.

As evidências de recuperação devem demonstrar a restauração tanto do serviço técnico quanto dos limites de segurança pretendidos.

### 14.27 Investigação de Segurança

Uma investigação de segurança deve ser capaz de reconstruir a sequência relevante de eventos.

Perguntas típicas incluem:

1. O que aconteceu?
2. Quando começou?
3. Qual identidade esteve envolvida?
4. Qual recurso foi acessado?
5. A autenticação foi bem-sucedida?
6. A operação estava autorizada?
7. Os privilégios foram alterados?
8. Dados sensíveis foram afetados?
9. Quais sistemas *downstream* podem estar envolvidos?
10. Qual remediação foi necessária?

*Logs* de auditoria, observabilidade, linhagem, metadados de acesso e histórico de configuração podem contribuir para a resposta.

### 14.28 Evidências de Incidentes de Segurança

As evidências de um incidente de segurança controlado ou teste podem preservar:

- identificador do teste ou incidente;
- cenário;
- identidade afetada;
- recurso afetado;
- comportamento esperado;
- comportamento observado;
- resultado da autenticação;
- resultado da autorização;
- eventos de auditoria relevantes;
- métricas relevantes;
- remediação;
- estado final;
- *timestamp*;
- versão da implementação;
- conclusão.

As evidências devem ser sanitizadas antes da publicação pública.

### 14.29 Evidências Negativas de Segurança

Um teste de segurança com falha é uma evidência válida.

Por exemplo:

**Esperado**
→ acesso do Power BI ao AtlasCommerce negado.

**Observado**
→ Power BI acessou o AtlasCommerce com sucesso.

Resultado:

**TEST FAILED**

A resposta correta é:

**Resultado Inesperado → Investigar → Remediar → Revalidar**

A expectativa documentada não deve ser alterada apenas para converter um resultado inesperado em PASS.

Quando apropriado, evidências de falha devem ser retidas para preservar o histórico de melhoria.

### 14.30 Observabilidade de Segurança Durante Falhas

Falhas operacionais podem criar sintomas relevantes para a segurança.

Exemplos incluem:

- falhas de credenciais após rotação;
- negações de autorização após alteração de função;
- falhas de TLS após renovação de certificado;
- dependências de segurança indisponíveis;
- cargas de trabalho de recuperação solicitando acesso mais amplo do que o esperado.

Nem todo alerta de segurança indica atividade maliciosa.

Alguns representam defeitos de configuração ou do ciclo de vida que ainda exigem correção.

A observabilidade de segurança deve, portanto, permanecer correlacionada ao tratamento mais amplo de falhas da plataforma.

### 14.31 Auditabilidade e Privacidade

Auditabilidade e privacidade podem criar requisitos concorrentes.

Os sistemas de auditoria exigem contexto de identidade suficiente para fornecer responsabilização.

A privacidade exige que informações pessoais desnecessárias sejam minimizadas.

A plataforma deve preservar o mínimo de informações de identidade necessário para o propósito de auditoria aprovado.

A auditabilidade não deve se tornar justificativa para retenção não controlada de dados pessoais.

### 14.32 Auditabilidade e Retenção

A retenção da auditoria deve estar alinhada ao período durante o qual as informações permanecem necessárias para:

- investigação de segurança;
- *troubleshooting* operacional;
- revisão de acesso;
- evidências;
- processos organizacionais aplicáveis ou de suporte à conformidade.

A retenção deve permanecer explícita.

Manter informações de auditoria indefinidamente pode aumentar custos e exposição.

Excluí-las cedo demais pode comprometer a investigação.

Os requisitos detalhados do ciclo de vida são definidos no Capítulo 13.

### 14.33 Observabilidade de Segurança do Laboratório

A Versão 1 deve demonstrar observabilidade de segurança representativa utilizando as capacidades disponíveis nas tecnologias selecionadas.

O laboratório deve buscar capturar evidências de:

- autenticação bem-sucedida;
- falha de autenticação;
- acesso autorizado;
- acesso negado;
- identidade específica de serviço;
- rotação de credenciais;
- revogação de credenciais;
- atividade privilegiada ou administrativa;
- falha de rede ou TLS, quando implementado;
- resultados de testes de segurança.

Nem toda capacidade corporativa de SIEM ou auditoria centralizada precisa ser reproduzida localmente.

O laboratório deve distinguir claramente o que está implementado daquilo que permanece como evolução para o ambiente corporativo.

### 14.34 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer a auditabilidade e a observabilidade de segurança por meio de capacidades como:

- agregação centralizada de *logs*;
- Security Information and Event Management (SIEM);
- armazenamento de auditoria imutável ou protegido;
- auditoria centralizada de identidades;
- monitoramento de acessos privilegiados;
- detecção automatizada de ameaças;
- análise de segurança;
- monitoramento centralizado de certificados;
- auditoria centralizada de segredos;
- monitoramento de fluxo de rede;
- integração com resposta a incidentes;
- política automatizada de retenção;
- correlação de eventos de segurança.

Essas capacidades fortalecem a escala e a aplicação dos controles sem alterar os requisitos fundamentais de auditoria.

### 14.35 Testes de Auditabilidade

Os controles de auditoria implementados devem ser testados.

Testes representativos incluem:

- autenticação bem-sucedida gera o contexto de auditoria esperado;
- falha de autenticação é registrada;
- negação de autorização é registrada;
- alterações de privilégios são atribuíveis;
- rotação de credenciais gera evidências do ciclo de vida;
- credenciais revogadas falham na autenticação;
- valores sensíveis estão ausentes dos *logs* de auditoria;
- operações administrativas são rastreáveis;
- acesso privilegiado relacionado à recuperação é rastreável;
- correlação entre componentes funciona conforme esperado.

O comportamento esperado da auditoria deve ser definido antes da execução.

A metodologia detalhada de validação é definida no Capítulo 17.

### 14.36 Evidências de Auditabilidade

As evidências de auditabilidade podem incluir:

- identificador do teste;
- ação;
- identidade;
- recurso;
- evento de auditoria esperado;
- evento de auditoria observado;
- *timestamp*;
- informações de correlação;
- métrica de segurança relevante;
- versão da implementação;
- conclusão.

As evidências devem ser ocultadas ou sanitizadas quando necessário para impedir a divulgação de informações Restritas, segredos reutilizáveis ou dados pessoais desnecessários.

### 14.37 Garantias de Auditabilidade e Observabilidade de Segurança

O modelo de observabilidade de segurança da Atlas Engineering deve preservar as seguintes garantias:

1. ações relevantes para a segurança são atribuíveis quando tecnicamente suportado;
2. atividades humanas, de serviço e administrativas permanecem distinguíveis;
3. resultados de autenticação e autorização permanecem conceitualmente distintos;
4. uma negação esperada de autorização é reconhecida como aplicação bem-sucedida da segurança;
5. alterações de privilégios e de configuração de segurança são auditáveis quando suportadas;
6. o acesso a recursos sensíveis pode receber tratamento de auditoria mais rigoroso;
7. ações de certificação e publicação permanecem auditáveis;
8. as informações de auditoria são classificadas e protegidas de acordo com seu conteúdo;
9. a auditabilidade não exige o registro de valores secretos;
10. a exposição de dados pessoais na auditoria e na observabilidade é minimizada;
11. o *logging* estruturado dá suporte à investigação de segurança sempre que possível;
12. a correlação entre componentes é suportada por identificadores e *timestamps* úteis;
13. a consistência dos *timestamps* dá suporte ao sequenciamento confiável dos eventos;
14. as informações de auditoria de segurança recebem proteção apropriada de integridade e retenção;
15. métricas, *dashboards* e alertas fornecem visibilidade de segurança sem expor valores protegidos;
16. alterações no ciclo de vida de acessos e credenciais permanecem rastreáveis sempre que possível;
17. atividades de segurança relacionadas à recuperação permanecem auditáveis;
18. testes de segurança com falha permanecem como evidências válidas e direcionam a remediação;
19. a observabilidade de segurança permanece integrada à observabilidade mais ampla da plataforma;
20. privacidade e auditabilidade são equilibradas de acordo com o propósito definido;
21. a observabilidade de segurança do laboratório permanece distinguível da capacidade corporativa de SIEM;
22. os controles de auditoria implementados são testáveis e baseados em evidências;
23. as afirmações de segurança permanecem limitadas ao comportamento efetivamente implementado e validado.

---

## 15. Considerações sobre Incidentes de Segurança e Recuperação

Incidentes de segurança devem ser tratados como eventos operacionais controlados que preservam a integridade da plataforma, a proteção dos dados, as evidências e a capacidade de recuperação.

Um incidente de segurança pode envolver:

- comprometimento de credenciais;
- acesso não autorizado;
- privilégio excessivo;
- exposição de segredos;
- divulgação de dados;
- atividade administrativa inesperada;
- comprometimento de identidade de serviço;
- comprometimento de certificado ou chave;
- alteração não autorizada de configuração;
- comunicação de rede não autorizada;
- perda ou alteração de dados governados;
- falha de controle de segurança.

A recuperação de segurança deve restaurar mais do que a disponibilidade do serviço.

Quando afetados, a plataforma também deve restaurar:

- identidades confiáveis;
- credenciais válidas;
- autorização pretendida;
- comunicação segura;
- estado correto dos dados;
- estado governado de publicação;
- observabilidade;
- auditabilidade.

A progressão governante é:

**Detectar → Conter → Preservar Evidências → Revogar ou Isolar → Remediar → Recuperar → Validar → Restaurar a Confiança Normal**

### 15.1 Classificação de Incidentes de Segurança

Eventos de segurança devem ser avaliados de acordo com sua natureza e impacto potencial.

Categorias relevantes podem incluir:

- incidente de autenticação;
- incidente de autorização;
- comprometimento de credenciais;
- exposição de segredos;
- incidente de confidencialidade;
- incidente de integridade;
- incidente de disponibilidade com impacto de segurança;
- uso indevido administrativo;
- comprometimento de configuração;
- incidente de segurança de rede;
- incidente relacionado à privacidade.

A classificação dá suporte à contenção, investigação, recuperação e escalonamento apropriados.

Nem todo evento relevante para a segurança é necessariamente um incidente de segurança.

Por exemplo, uma falha de *login* causada por uma credencial de serviço expirada pode representar um problema operacional de configuração.

Falhas repetidas sem explicação ou o uso de credenciais sabidamente inválidas podem exigir investigação de segurança.

### 15.2 Detecção

Incidentes de segurança podem ser detectados por meio de:

- *logs* de autenticação;
- negações de autorização;
- registros de auditoria administrativa;
- detecções de varredura de segredos;
- atividade de rede inesperada;
- comportamento anormal de serviços;
- anomalias de acesso a dados;
- alertas de segurança;
- observabilidade da plataforma;
- investigação manual;
- notificação externa.

A detecção deve fornecer contexto suficiente para iniciar a investigação sem expor desnecessariamente informações sensíveis.

Os requisitos detalhados de auditabilidade e observabilidade de segurança são definidos no Capítulo 14.

### 15.3 Avaliação Inicial

A avaliação inicial deve identificar, quando possível:

- o que foi detectado;
- quando começou;
- identidade afetada;
- serviço afetado;
- recurso afetado;
- classificação dos dados;
- impacto potencial sobre dados pessoais;
- credenciais afetadas;
- sistemas afetados;
- se a atividade não autorizada permanece ativa;
- opções imediatas de contenção.

A avaliação pode evoluir à medida que novas evidências se tornam disponíveis.

Informações incompletas não devem impedir a contenção evidente de um risco de segurança ativo.

### 15.4 Contenção

A contenção limita a continuidade da exposição, da atividade não autorizada ou da propagação de um estado potencialmente comprometido.

Possíveis ações incluem:

- desabilitar uma identidade;
- revogar uma credencial;
- bloquear acesso de rede;
- isolar um serviço;
- pausar o processamento;
- suspender a publicação;
- restringir um conjunto de dados;
- remover privilégios excessivos.

A contenção deve ser proporcional ao incidente, priorizando a proteção do estado confiável.

A degradação temporária do serviço pode ser preferível à continuidade do comprometimento.

### 15.5 Comprometimento de Credenciais

Uma credencial cuja confidencialidade não possa mais ser razoavelmente considerada confiável deve ser tratada como comprometida.

A resposta deve considerar:

1. identificar a identidade e os recursos afetados;
2. revogar ou desabilitar a credencial;
3. conter o uso não autorizado;
4. criar uma credencial substituta;
5. atualizar com segurança as cargas de trabalho legítimas;
6. validar a autenticação com a credencial substituta;
7. confirmar a rejeição da credencial comprometida;
8. investigar as atividades executadas com a identidade afetada.

Excluir o valor exposto de um arquivo de configuração não restaura a confiança na credencial.

Os requisitos detalhados do ciclo de vida das credenciais são definidos no Capítulo 6.

### 15.6 Exposição de Segredos

A exposição de segredos pode ocorrer por meio de:

- controle de versão;
- *logs*;
- capturas de tela;
- documentação;
- evidências;
- exportações de configuração;
- *troubleshooting*;
- acesso não autorizado a arquivos.

A resposta governante é:

**Segredo Exposto → Tratar como Não Confiável → Revogar ou Substituir → Validar**

A limpeza do artefato reduz a continuidade da exposição.

Ela não restaura, de forma independente, a confidencialidade ou a confiança.

### 15.7 Acesso Não Autorizado

O acesso não autorizado exige investigação tanto de:

- como o caminho de acesso se tornou disponível;
- qual atividade ocorreu depois que o acesso foi obtido.

A investigação pode considerar:

- identidade;
- credencial;
- política de autorização;
- alterações de privilégios;
- recursos acessados;
- classificação dos dados;
- duração;
- impacto *downstream*;
- exportações ou dados copiados;
- evidências de auditoria.

A contenção deve remover o caminho de acesso não autorizado antes que a confiança normal seja restaurada.

### 15.8 Privilégio Excessivo

Um incidente pode revelar que uma identidade possui permissões mais amplas do que as exigidas por sua responsabilidade aprovada.

Exemplos incluem:

- identidade de serviço com privilégios administrativos;
- consumidor analítico com acesso à origem;
- identidade de observabilidade com permissão de gravação;
- privilégio temporário de *troubleshooting* que nunca foi removido.

A resposta deve incluir:

- reduzir o acesso ao escopo necessário;
- identificar como a permissão excessiva foi introduzida;
- revisar identidades semelhantes em busca de *drift* relacionado;
- validar o comportamento necessário e o comportamento proibido após a correção.

Privilégio excessivo é tanto um defeito de segurança quanto um defeito de governança de acesso.

### 15.9 Comprometimento de Identidade de Serviço

O comprometimento de uma identidade de serviço pode afetar o processamento automatizado ao longo de múltiplas execuções.

A resposta deve considerar:

- isolar ou interromper a carga de trabalho afetada;
- revogar suas credenciais;
- identificar a janela de processamento afetada;
- determinar quais dados ela leu, produziu ou modificou;
- identificar resultados *downstream* derivados de processamento potencialmente comprometido;
- substituir a identidade ou credencial;
- restaurar o escopo de acesso pretendido;
- validar o serviço antes de retomar o processamento normal.

Reiniciar um serviço com a mesma identidade comprometida não constitui recuperação de segurança.

### 15.10 Incidente de Confidencialidade dos Dados

Um incidente de confidencialidade ocorre quando dados governados podem ter sido acessados ou divulgados sem autorização.

A investigação deve considerar:

- classificação;
- condição de dado pessoal;
- escopo afetado;
- identidade;
- caminho de acesso;
- duração;
- possibilidade de exportação ou cópia externa;
- exposição *downstream*;
- evidências disponíveis.

A plataforma fornece evidências técnicas.

Decisões organizacionais, jurídicas, contratuais e relacionadas à resposta de privacidade permanecem fora da autoridade exclusiva da plataforma.

### 15.11 Incidente de Integridade dos Dados

Um incidente de segurança pode alterar dados governados ou as definições utilizadas para produzi-los.

Exemplos incluem modificação não autorizada de:

- dados da origem;
- eventos;
- Bronze;
- Silver;
- Gold;
- regras de qualidade;
- lógica de reconciliação;
- estado de certificação;
- estado de publicação.

A recuperação deve identificar a última entrada ou estado de processamento confiável e determinar quais resultados *downstream* foram derivados de informações potencialmente alteradas.

A linhagem é um mecanismo fundamental para a análise de impacto.

### 15.12 Recuperação de Integridade

A recuperação de integridade pode exigir:

- isolar os dados afetados;
- determinar a última origem ou camada confiável;
- executar *replay* a partir do Kafka;
- executar *rebuild* a partir da Bronze;
- executar *rebuild* da Gold a partir da Silver;
- restaurar a partir de *backup*;
- executar novamente qualidade e reconciliação;
- recertificar;
- republicar.

A fonte de recuperação deve ser selecionada de acordo com quais camadas permanecem confiáveis.

Um estado *downstream* comprometido não deve ser utilizado automaticamente como sua própria fonte de recuperação.

### 15.13 Incidente de Segurança na Certified Gold

Se houver suspeita de que a Certified Gold tenha sido modificada, exposta ou publicada de maneira inadequada, a plataforma deve proteger o limite governado dos consumidores.

Possíveis respostas incluem:

- bloquear novas publicações;
- reter a última versão certificada reconhecidamente confiável;
- restringir temporariamente o acesso dos consumidores;
- executar *rollback* para uma versão certificada confiável anterior;
- executar *rebuild* do estado afetado da Gold;
- executar novamente qualidade e reconciliação;
- recertificar e republicar.

Uma versão publicada não deve ser considerada confiável apenas porque possui um rótulo de certificação.

Os próprios metadados de certificação podem fazer parte do estado comprometido.

### 15.14 Último Estado Reconhecidamente Confiável

A recuperação de segurança exige identificar o estado mais recente que ainda possa ser considerado confiável.

Esse estado pode ser diferente do último estado tecnicamente bem-sucedido.

Por exemplo:

**Gold V12**
→ tecnicamente bem-sucedida  
→ produzida após o comprometimento da identidade de transformação

pode ser menos confiável do que:

**Certified Gold V11**
→ produzida antes do comprometimento

As decisões de recuperação devem, portanto, preferir:

**Último Estado Reconhecidamente Confiável**

em vez de:

**Última Execução Bem-Sucedida**

### 15.15 Recuperação de Segurança e Backup

*Backups* podem fornecer uma fonte de recuperação, mas também podem preservar:

- credenciais comprometidas;
- configuração vulnerável;
- permissões excessivas;
- alterações não autorizadas;
- estado de privacidade obsoleto.

Restaurar um *backup* não restaura automaticamente uma plataforma confiável.

Antes da retomada do serviço normal, o ambiente restaurado deve ser avaliado em relação ao estado atual de:

- credenciais;
- autorização;
- configuração de segurança;
- decisões de privacidade;
- decisões de retenção;
- estado de certificados ou chaves;
- descobertas conhecidas do incidente.

### 15.16 A Recuperação Não Deve Restaurar Confiança Invalidada

Uma regra fundamental da recuperação de segurança é:

**A Recuperação Pode Restaurar o Estado Técnico — Ela Não Deve Restaurar Confiança Invalidada**

A confiança invalidada pode incluir:

- senha comprometida;
- *token* vazado;
- certificado revogado;
- chave criptográfica comprometida;
- privilégio não autorizado;
- configuração vulnerável;
- identidade de serviço retirada de uso.

Se uma fonte de recuperação contiver esse estado, ele deverá ser substituído ou corrigido antes que a operação normal seja retomada.

### 15.17 Recuperação e Acesso Privilegiado

A recuperação de segurança pode exigir privilégios elevados.

Esse acesso deve permanecer:

- explícito;
- autorizado;
- limitado ao escopo necessário;
- atribuível;
- auditável;
- temporário, quando suportado.

Os privilégios de recuperação devem ser removidos ou reduzidos quando a atividade de recuperação terminar.

O acesso emergencial não deve se tornar silenciosamente um acesso normal.

### 15.18 Acesso Break-Glass

Ambientes corporativos podem utilizar acesso *break-glass* controlado quando os mecanismos administrativos normais estiverem indisponíveis.

Quando implementado, o acesso *break-glass* deve incluir controles como:

- responsabilidade restrita;
- ativação explícita;
- autenticação forte;
- escopo mínimo necessário;
- monitoramento;
- auditabilidade;
- revisão após o uso;
- rotação de credenciais após o uso, quando apropriado.

A Versão 1 não exige uma implementação corporativa de *break-glass*.

A arquitetura preserva o conceito para evolução futura.

### 15.19 Preservação de Evidências

A investigação pode exigir a preservação de evidências antes que a remediação altere o ambiente.

Evidências relevantes podem incluir:

- registros de auditoria;
- eventos de autenticação e autorização;
- estado da configuração;
- políticas de acesso;
- métricas de segurança;
- metadados dos objetos afetados;
- linhagem;
- metadados de versão;
- *timestamps*.

A preservação de evidências não deve justificar a duplicação desnecessária de conjuntos completos de dados sensíveis.

Deve-se preferir a quantidade mínima de informações necessária para investigar e demonstrar o incidente.

### 15.20 Integridade das Evidências

As evidências de incidentes devem permanecer distinguíveis de saídas comuns e mutáveis de *troubleshooting*.

Sempre que possível, as evidências devem preservar:

- origem;
- *timestamp*;
- contexto da coleta;
- identificador do incidente ou teste;
- características de integridade;
- investigador responsável ou processo de coleta.

Ambientes corporativos podem fortalecer esse aspecto por meio de repositórios de evidências protegidos ou imutáveis.

O laboratório deve preservar evidências de maneira controlada e documentada.

### 15.21 Correlação do Incidente

Incidentes de segurança podem atravessar diversos componentes da plataforma.

Por exemplo:

**Exposição de Credencial**
→ autenticação não autorizada no SQL Server  
→ acesso à origem  
→ atividade inesperada de eventos  
→ processamento *downstream*

A investigação pode, portanto, exigir correlação entre:

- *logs* de segurança;
- SQL Server;
- Debezium;
- Kafka;
- MinIO;
- *jobs* de processamento;
- Gold;
- Certified Gold;
- observações de rede.

Identidades, *timestamps*, identificadores de eventos, identificadores de processamento e linhagem devem ajudar a reconstruir a sequência.

### 15.22 Incidente e Linhagem

A linhagem dá suporte à análise do impacto de segurança.

Se dados ou processamento comprometidos entrarem na plataforma, a linhagem deve ajudar a determinar:

- quais dados da Silver foram afetados;
- quais estruturas da Gold foram derivadas;
- quais versões certificadas foram afetadas;
- quais consumidores podem ter recebido o resultado.

Isso permite que a remediação seja direcionada ao escopo afetado, em vez de reconstruir automaticamente dados não relacionados.

### 15.23 Incidente e Governança de Privacidade

Um incidente de segurança envolvendo dados pessoais também exige avaliação do impacto sobre a privacidade.

A plataforma deve fornecer informações técnicas como:

- categorias de dados pessoais afetadas;
- escopo aproximado, quando determinável;
- sistemas afetados;
- identidades relevantes;
- período;
- propagação *downstream*;
- contenção;
- remediação.

As responsabilidades de privacidade ou jurídicas determinam os requisitos organizacionais ou de notificação aplicáveis.

A arquitetura fornece evidências; ela não realiza de forma independente a determinação jurídica.

### 15.24 Incidente e Retenção

A resposta a incidentes pode exigir temporariamente a preservação de informações que, de outra forma, atingiriam o prazo normal de expiração da retenção.

Essa preservação deve ser explícita.

Um requisito de investigação não deve redefinir silenciosamente a retenção permanente de todos os dados da plataforma.

Ambientes corporativos podem utilizar mecanismos controlados de retenção por incidente ou *legal hold*, quando aplicável.

### 15.25 Validação da Recuperação de Segurança

Um incidente de segurança não é considerado recuperado apenas porque o serviço afetado voltou a funcionar.

A validação deve confirmar, quando aplicável:

- credencial comprometida rejeitada;
- credencial substituta operacional;
- acesso excessivo removido;
- acesso pretendido restaurado;
- comunicação não autorizada bloqueada;
- dados afetados corrigidos ou reconstruídos;
- qualidade e reconciliação aprovadas;
- Certified Gold restaurada a um estado confiável;
- acesso elevado de recuperação removido;
- auditabilidade restaurada;
- observabilidade de segurança funcionando.

A recuperação de segurança inclui a restauração tanto da operação técnica quanto do estado confiável.

### 15.26 Recuperação de Segurança no Nível do Serviço

Um serviço pode estar tecnicamente disponível enquanto ainda opera sob confiança reduzida.

Por exemplo:

**Serviço = UP**

enquanto:

- uma credencial emergencial permanece ativa;
- uma permissão excessiva permanece;
- a certificação ainda não foi revalidada;
- a auditabilidade está indisponível.

A recuperação normal de segurança não deve ser declarada concluída até que os controles necessários sejam restaurados ou o risco residual seja explicitamente aceito por meio do processo de governança apropriado.

### 15.27 Revisão Pós-Incidente

Um incidente significativo deve resultar em revisão de:

- causa raiz;
- efetividade da detecção;
- efetividade da contenção;
- projeto de credenciais ou acessos;
- fragilidades arquiteturais;
- comportamento da recuperação;
- qualidade das evidências;
- observabilidade ausente;
- lacunas de testes;
- lacunas de documentação.

A revisão pode resultar em:

- alterações de implementação;
- alterações de políticas de segurança;
- novos testes;
- novos alertas;
- atualizações de arquitetura;
- ADRs;
- procedimentos revisados.

Os incidentes devem melhorar a arquitetura, em vez de permanecerem como eventos operacionais isolados.

### 15.28 Cenários de Teste de Incidentes de Segurança

A Versão 1 deve utilizar cenários controlados para validar a recuperação de segurança sem criar comprometimento real.

Cenários representativos incluem:

**SEC-001 — Credencial de Serviço Exposta**

Comportamento esperado:

1. a exposição é detectada ou declarada;
2. a credencial é tratada como comprometida;
3. a credencial antiga é revogada;
4. uma credencial substituta é provisionada;
5. o serviço legítimo retoma a operação;
6. a credencial antiga é rejeitada;
7. as evidências de auditoria são preservadas.

**SEC-002 — Acesso Não Autorizado à Camada**

Comportamento esperado:

1. uma operação não autorizada é tentada;
2. o acesso é negado;
3. a negação é observável;
4. nenhum dado é modificado ou exposto;
5. as evidências confirmam a aplicação esperada dos controles.

**SEC-003 — Detecção de Permissão Excessiva**

Comportamento esperado:

1. a permissão implementada excede o modelo de acesso aprovado;
2. o *drift* é identificado;
3. o privilégio é reduzido;
4. a operação necessária continua sendo bem-sucedida;
5. a operação proibida é negada.

A metodologia detalhada de testes é definida no Capítulo 17.

### 15.29 Evidências de Incidentes de Segurança

As evidências de incidentes de segurança devem identificar:

- identificador do incidente ou teste;
- cenário;
- estado confiável inicial;
- identidade afetada;
- recurso afetado;
- classificação;
- detecção;
- contenção;
- evidências preservadas;
- remediação;
- alterações de credenciais ou acessos;
- ações de recuperação de dados, quando aplicável;
- resultados da validação;
- estado confiável final;
- risco residual, quando aplicável;
- *timestamp*;
- versão da implementação;
- conclusão.

As evidências devem ser sanitizadas antes da publicação pública.

### 15.30 Recuperação de Segurança no Laboratório

A Versão 1 não reproduz todas as capacidades corporativas de resposta a incidentes.

Seu propósito é demonstrar comportamentos técnicos representativos, como:

- revogação de credenciais;
- substituição de credenciais;
- correção de autorização;
- isolamento de serviços;
- recuperação do estado confiável;
- restauração dos limites de acesso;
- observabilidade de segurança;
- evidências controladas.

Cenários bem-sucedidos no laboratório não implicam maturidade corporativa de resposta a incidentes.

### 15.31 Evolução para o Ambiente Corporativo

Uma implementação corporativa pode fortalecer a resposta a incidentes por meio de capacidades como:

- processos formais de Security Operations Center;
- SIEM e SOAR;
- gerenciamento centralizado de incidentes;
- contenção automatizada;
- revogação corporativa de credenciais;
- detecção e resposta em *endpoints*;
- detecção e resposta de rede;
- coleta forense;
- *legal hold*;
- comunicação formal de incidentes;
- fluxos de trabalho para incidentes de privacidade;
- repositórios centralizados de evidências;
- coordenação de recuperação de desastre.

Essas capacidades fortalecem a resposta operacional sem alterar o princípio de que a recuperação de segurança restaura tanto a função técnica quanto o estado confiável.

### 15.32 Garantias para Incidentes de Segurança e Recuperação

O modelo de incidentes de segurança e recuperação da Atlas Engineering deve preservar as seguintes garantias:

1. incidentes de segurança são avaliados de acordo com sua natureza e impacto potencial;
2. a detecção fornece contexto suficiente para contenção e investigação quando tecnicamente possível;
3. um risco de segurança ativo pode ser contido antes que a investigação completa seja concluída;
4. credenciais expostas ou comprometidas são tratadas como não confiáveis;
5. a limpeza de artefatos não restaura, de forma independente, a confiança nas credenciais;
6. o acesso não autorizado é investigado tanto em relação ao caminho de acesso quanto à atividade afetada;
7. privilégio excessivo é tratado como um defeito de segurança e governança;
8. identidades de serviço comprometidas são remediadas, em vez de simplesmente reiniciadas;
9. incidentes de confidencialidade e integridade acionam análise de impacto apropriada aos dados afetados;
10. a linhagem dá suporte à identificação do impacto *downstream*;
11. a recuperação utiliza o último estado reconhecidamente confiável, e não apenas o último estado bem-sucedido;
12. a restauração de *backup* não restaura automaticamente um estado de segurança confiável;
13. a recuperação não restaura confiança comprometida, revogada, expirada ou de outra forma invalidada;
14. o acesso elevado para recuperação permanece explícito, limitado ao escopo necessário, atribuível e temporário quando suportado;
15. as evidências do incidente são preservadas sem duplicação desnecessária de dados sensíveis;
16. a recuperação de segurança restaura autenticação, autorização, integridade dos dados, observabilidade e auditabilidade quando afetadas;
17. a disponibilidade do serviço, por si só, não comprova a recuperação de segurança;
18. o impacto sobre a privacidade é avaliado quando dados pessoais podem estar envolvidos;
19. alterações de retenção relacionadas ao incidente permanecem explícitas;
20. a revisão pós-incidente pode resultar em melhorias de arquitetura, implementação, testes, monitoramento e documentação;
21. os cenários de laboratório permanecem controlados e não representam maturidade corporativa de resposta a incidentes;
22. o comportamento implementado de incidentes e recuperação é testável e baseado em evidências;
23. as afirmações sobre recuperação de segurança permanecem limitadas aos cenários e controles efetivamente implementados e validados.

---

## 16. Funções e Responsabilidades

A Atlas Engineering separa as responsabilidades arquiteturais de acordo com os aspectos que elas governam.

As funções descrevem responsabilidades, não representando necessariamente pessoas, equipes ou cargos individuais.

Em um ambiente pequeno, uma pessoa pode desempenhar várias funções.

Em um ambiente corporativo, as mesmas responsabilidades podem ser distribuídas entre equipes especializadas.

A arquitetura deve preservar esses limites lógicos independentemente do tamanho da organização.

O princípio governante é:

**Separação de Funções Define a Responsabilidade — Estrutura Organizacional Define Quem a Desempenha**

### 16.1 Modelo de Responsabilidades

O modelo de segurança e governança reconhece responsabilidades associadas a:

- Engenharia de Dados;
- Administração de Banco de Dados;
- Plataforma / SRE;
- Segurança;
- Governança de Dados;
- Privacidade / Jurídico;
- Responsabilidade pelos Dados de Negócio;
- Business Intelligence / Analytics;
- Consumo de Dados;
- Auditoria ou Investigação, quando aplicável.

Essas responsabilidades podem se sobrepor operacionalmente, mas devem permanecer conceitualmente distinguíveis.

Essa separação dá suporte a:

- responsabilidade;
- responsabilização;
- privilégio mínimo;
- governança de mudanças;
- resposta a incidentes;
- escalonamento;
- validação;
- evidências;
- evolução para o ambiente corporativo.

### 16.2 Engenharia de Dados

A Engenharia de Dados é responsável pelo projeto, implementação, operação e evolução do processamento governado de dados em toda a plataforma analítica.

As responsabilidades podem incluir:

- arquitetura de ingestão;
- integração com Debezium;
- processamento de eventos do Kafka;
- persistência na Bronze;
- transformação na Silver;
- processamento da Gold;
- orquestração;
- *replay*;
- *backfill*;
- implementação de qualidade de dados;
- implementação de reconciliação;
- linhagem;
- metadados de processamento;
- implementação de produtos de dados;
- documentação técnica;
- testes de processamento;
- validação da recuperação.

A Engenharia de Dados não define de forma independente todos os requisitos de negócio, privacidade, segurança ou jurídicos.

Ela implementa os requisitos aprovados dentro da plataforma de dados.

### 16.3 Engenharia de Dados e Responsabilidade pela Origem

A Engenharia de Dados consome informações governadas da origem, mas não é automaticamente responsável pelo *schema* da origem operacional.

O AtlasCommerce permanece responsável por seu domínio transacional e modelo de dados operacional.

A Engenharia de Dados deve avaliar alterações na origem quanto ao impacto *downstream*, em vez de presumir autoridade para reprojetar a origem exclusivamente por conveniência analítica.

Quando alterações na origem forem necessárias para dar suporte a uma integração confiável, elas devem ser coordenadas por meio do processo apropriado de responsabilidade pela origem.

### 16.4 Administração de Banco de Dados

A Administração de Banco de Dados é responsável pelos aspectos relacionados à plataforma de banco de dados, quando aplicável.

As responsabilidades podem incluir:

- instalação e configuração do SQL Server;
- disponibilidade do banco de dados;
- *backup* e restauração;
- segurança do banco de dados;
- identidades e permissões do banco de dados;
- armazenamento;
- desempenho;
- manutenção;
- configuração do CDC;
- observabilidade no nível do banco de dados;
- recuperação do banco de dados.

A responsabilidade do DBA não inclui automaticamente a responsabilidade pelas transformações analíticas *downstream* ou pelas definições de negócio.

Da mesma forma, o privilégio administrativo no banco de dados não justifica, de forma independente, o uso irrestrito dos dados de negócio.

### 16.5 DBA e CDC

O CDC cria um limite de responsabilidade compartilhada entre a Administração de Banco de Dados e a Engenharia de Dados.

A Administração de Banco de Dados pode ser responsável por:

- habilitar e manter o CDC;
- configuração do banco de dados de origem;
- retenção do CDC;
- permissões do banco de dados;
- *troubleshooting* no lado da origem.

A Engenharia de Dados pode ser responsável por:

- integração com Debezium;
- progresso da captura;
- produção de eventos;
- processamento *downstream*;
- detecção do impacto sobre a ingestão.

Alterações no comportamento do CDC devem, portanto, considerar tanto as consequências para o banco de dados de origem quanto para a plataforma de dados *downstream*.

### 16.6 Plataforma / SRE

Plataforma / SRE é responsável pelo ambiente de execução que dá suporte aos serviços da plataforma.

As responsabilidades podem incluir:

- ambiente de execução de *containers* ou computação;
- disponibilidade dos serviços;
- rede;
- infraestrutura de armazenamento;
- monitoramento da plataforma;
- capacidade;
- automação de *deployment*;
- configuração da infraestrutura;
- recuperação da plataforma.

A administração da infraestrutura não implica automaticamente acesso irrestrito aos dados de negócio processados pelos serviços.

O privilégio técnico deve permanecer limitado de acordo com a responsabilidade operacional quando a tecnologia permitir essa separação.

### 16.7 Responsabilidade pela Confiabilidade da Plataforma

A responsabilidade pela confiabilidade da plataforma concentra-se em manter as condições técnicas necessárias para que a plataforma de dados opere dentro das expectativas definidas.

Aspectos relevantes podem incluir:

- disponibilidade;
- capacidade de recursos;
- saúde dos serviços;
- saúde do armazenamento;
- conectividade de rede;
- monitoramento operacional;
- recuperação da infraestrutura;
- confiabilidade do *deployment*.

A confiabilidade da plataforma não determina, de forma independente, se os dados processados estão corretos, reconciliados, certificados ou apropriados para consumo analítico.

A saúde dos serviços e a confiança nos dados permanecem responsabilidades distintas.

### 16.8 Segurança

Segurança é responsável por definir, coordenar ou governar os requisitos de proteção de acordo com o modelo organizacional.

As responsabilidades podem incluir:

- arquitetura de segurança;
- requisitos de identidade;
- requisitos de autenticação;
- princípios de autorização;
- requisitos de gerenciamento de segredos;
- requisitos de criptografia;
- requisitos de segurança de rede;
- monitoramento de segurança;
- gerenciamento de vulnerabilidades;
- coordenação da resposta a incidentes;
- requisitos de validação de segurança.

A responsabilidade de Segurança não implica que uma única equipe de segurança implemente tecnicamente todos os controles.

A implementação pode permanecer distribuída entre as equipes responsáveis pelas tecnologias afetadas.

### 16.9 Segurança e Equipes Técnicas

Os requisitos de segurança e a implementação técnica devem permanecer conectados.

Por exemplo:

**Segurança**
→ define o requisito de isolamento de credenciais.

**Engenharia de Dados**
→ implementa credenciais de processamento separadas.

**DBA**
→ implementa permissões no banco de dados.

**Plataforma / SRE**
→ implementa controles de infraestrutura ou rede.

**Segurança / Validação**
→ verifica se o limite pretendido está sendo aplicado.

Essa separação permite que a política de segurança e a responsabilidade pela implementação permaneçam explícitas sem exigir que uma única equipe administre todas as tecnologias.

### 16.10 Governança de Dados

A Governança de Dados coordena o significado controlado, a responsabilidade, a classificação, o ciclo de vida e o uso dos ativos de dados governados.

As responsabilidades podem incluir:

- governança de metadados;
- classificação;
- requisitos de linhagem;
- responsabilidade;
- governança de produtos de dados;
- governança de retenção;
- governança de qualidade;
- governança de contratos;
- governança de certificação;
- expectativas de documentação.

A Governança de Dados não implementa automaticamente todos os controles técnicos.

Sua responsabilidade é garantir que os requisitos governados permaneçam definidos, tenham responsáveis, sejam revisáveis e rastreáveis.

### 16.11 Governança de Dados e Engenharia de Dados

A Governança de Dados e a Engenharia de Dados possuem responsabilidades complementares.

Uma relação representativa é:

**Governança de Dados**
→ define ou coordena o requisito governado.

**Engenharia de Dados**
→ implementa o requisito no processamento e nos produtos de dados.

Exemplos incluem:

**Classificação**
→ a Governança define ou coordena a classificação.  
→ a Engenharia de Dados implementa o tratamento necessário.

**Regra de Qualidade**
→ a Governança e a responsabilidade de negócio definem o requisito.  
→ a Engenharia de Dados implementa a validação.

**Linhagem**
→ a Governança define a rastreabilidade necessária.  
→ a Engenharia de Dados produz e mantém a linhagem técnica.

Governança e implementação devem permanecer sincronizadas.

### 16.12 Privacidade / Jurídico

Privacidade / Jurídico é responsável por determinar os requisitos aplicáveis de privacidade, jurídicos e regulatórios de acordo com o contexto organizacional.

As responsabilidades podem incluir:

- interpretação dos requisitos de privacidade;
- requisitos relacionados à finalidade do processamento;
- requisitos relacionados às solicitações dos titulares dos dados;
- restrições de retenção;
- obrigações relacionadas a incidentes de privacidade;
- *legal holds*;
- interpretação regulatória.

A plataforma de dados não deve chegar, de forma independente, a conclusões jurídicas apenas porque implementa controles técnicos de privacidade.

### 16.13 Privacidade e Engenharia de Dados

Os requisitos de privacidade devem ser traduzidos em controles implementáveis na plataforma de dados.

Por exemplo:

**Requisito de Privacidade**
→ minimizar dados pessoais desnecessários.

**Implementação pela Engenharia de Dados**
→ excluir, remover, mascarar, pseudonimizar, agregar ou transformar de outra forma os atributos de acordo com o requisito aprovado.

Da mesma forma:

**Solicitação de Privacidade Aprovada**
→ identifica o tratamento necessário.

**Engenharia de Dados**
→ executa a ação técnica aprovada nas camadas afetadas da plataforma, quando aplicável.

A implementação técnica dá suporte ao processo de privacidade, mas não determina de forma independente a aplicabilidade jurídica.

### 16.14 Responsável pelos Dados de Negócio

O Responsável pelos Dados de Negócio é responsável pelo significado de negócio governado e pelo uso aprovado de um domínio ou produto de dados.

As responsabilidades podem incluir:

- definições de negócio;
- regras de negócio;
- significado dos dados;
- finalidade analítica;
- expectativas aceitáveis de qualidade;
- decisões de responsabilidade;
- requisitos dos consumidores;
- aprovação de alterações semânticas relevantes.

A responsabilidade de negócio não implica automaticamente a administração técnica dos sistemas que armazenam ou processam os dados.

### 16.15 Responsabilidade de Negócio e Responsabilidade Técnica

A responsabilidade de negócio e a responsabilidade técnica devem permanecer distinguíveis.

Por exemplo:

**Responsável pelos Dados de Negócio**
→ define o significado de uma medida de Sales.

**Engenharia de Dados**
→ implementa a transformação.

**DBA**
→ administra a plataforma de banco de dados.

**Plataforma / SRE**
→ opera a infraestrutura de suporte.

Uma implementação tecnicamente correta ainda deve representar o significado de negócio aprovado.

Da mesma forma, a autoridade de negócio não concede automaticamente privilégios técnicos irrestritos.

### 16.16 Business Intelligence / Analytics

Business Intelligence / Analytics é responsável pelo consumo e pela apresentação analítica governados.

As responsabilidades podem incluir:

- modelos semânticos;
- relatórios;
- *dashboards*;
- cálculos analíticos apropriados à camada de consumo;
- visualização;
- documentação analítica voltada aos consumidores.

BI deve consumir produtos analíticos governados por meio da Certified Gold.

Ela não deve se tornar o local não controlado onde as principais transformações da plataforma de dados são recriadas independentemente do *pipeline* governado.

### 16.17 BI e Lógica de Negócio

Parte da lógica analítica pertence legitimamente à camada de BI.

Exemplos podem incluir:

- cálculos de apresentação;
- agregações visuais;
- medidas voltadas aos usuários;
- lógica específica de relatórios.

Definições fundamentais de negócio que devem permanecer consistentes entre múltiplos consumidores devem, preferencialmente, ser governadas *upstream* ou explicitamente definidas como parte do contrato de consumo analítico.

O limite deve minimizar lógica de negócio duplicada e contraditória.

### 16.18 Consumidor de Dados

Um Consumidor de Dados utiliza informações analíticas governadas para um propósito aprovado.

Os consumidores podem incluir:

- analistas;
- usuários de negócio;
- aplicações;
- relatórios;
- *dashboards*;
- sistemas analíticos *downstream*.

Os consumidores são responsáveis por utilizar os dados de acordo com:

- propósito definido;
- classificação;
- autorização de acesso;
- semântica analítica;
- requisitos de privacidade aplicáveis.

O acesso do consumidor não implica autoridade para modificar processamento, certificação ou publicação *upstream*.

### 16.19 Responsabilidade pelo Produto de Dados

Cada produto de dados governado deve possuir responsabilidades identificáveis.

A responsabilidade deve permitir determinar quem responde por:

- propósito;
- significado de negócio;
- implementação técnica;
- expectativas de qualidade;
- classificação;
- consumidores;
- ciclo de vida;
- certificação;
- documentação.

A responsabilidade pode envolver várias funções.

O requisito importante é que a responsabilidade não se torne ambígua apenas porque o produto atravessa múltiplas tecnologias ou equipes.

### 16.20 Responsabilidade pelo Contrato de Eventos

Os contratos de eventos exigem responsabilidade tanto pela compatibilidade técnica quanto pelo significado semântico.

As responsabilidades relevantes incluem:

- comportamento do produtor;
- definição do *schema*;
- política de compatibilidade;
- revisão semântica;
- versionamento;
- impacto sobre consumidores;
- migração;
- descontinuação.

A Engenharia de Dados pode implementar o contrato e a integração com o *registry*, enquanto os responsáveis pela origem e pelo negócio podem participar das decisões semânticas.

Nenhum *registry* técnico substitui a responsabilidade pelo contrato.

### 16.21 Responsabilidade pela Qualidade

A qualidade dos dados exige responsabilidade identificável por:

- definir a regra;
- implementar a regra;
- responder à falha;
- investigar os dados afetados;
- aprovar a remediação, quando necessário.

Diferentes regras de qualidade podem possuir diferentes responsáveis.

Por exemplo, a Engenharia de Dados pode implementar uma verificação de unicidade, enquanto o Responsável pelos Dados de Negócio determina se a condição violada representa um estado de negócio inválido.

Uma regra de qualidade com falha não deve existir sem uma responsabilidade de remediação identificável.

### 16.22 Responsabilidade pela Reconciliação

A reconciliação verifica se o processamento permanece quantitativa e semanticamente consistente entre os limites arquiteturais.

A responsabilidade pode incluir:

- definir expectativas de reconciliação;
- implementar comparações;
- investigar diferenças;
- determinar se uma divergência bloqueia a certificação;
- preservar evidências.

A Engenharia de Dados pode implementar o mecanismo, enquanto a responsabilidade de negócio ou a Governança pode definir a interpretação aceitável de diferenças relevantes.

### 16.23 Responsabilidade pela Certificação

A certificação determina se uma candidata à Gold satisfaz os requisitos necessários para a publicação governada.

A responsabilidade pela certificação deve avaliar os critérios definidos, incluindo, quando aplicável:

- conclusão do processamento;
- qualidade;
- reconciliação;
- metadados necessários;
- linhagem;
- informações de versão;
- ausência de falhas bloqueantes.

A autoridade para produzir dados não implica automaticamente autoridade para certificá-los.

A Versão 1 pode consolidar essas responsabilidades operacionalmente, mas sua distinção lógica deve permanecer explícita.

### 16.24 Responsabilidade pela Publicação

A publicação controla qual estado certificado se torna visível aos consumidores.

A responsabilidade inclui:

- publicar a Certified Gold aprovada;
- preservar a versão confiável anterior quando necessário;
- impedir que candidatas com falha se tornem visíveis;
- dar suporte a *rollback*;
- registrar o estado da publicação.

A autoridade de publicação deve permanecer distinta do acesso comum para consumo analítico.

### 16.25 Responsabilidade por Backup e Recuperação

As responsabilidades por *backup* e recuperação devem permanecer identificáveis para cada componente relevante da plataforma.

As responsabilidades podem incluir:

- definir o escopo do *backup*;
- operar procedimentos de *backup*;
- validar a capacidade de recuperação;
- executar a restauração;
- coordenar *replay* ou *rebuild*;
- validar o estado de segurança restaurado;
- validar o estado dos dados restaurados;
- preservar evidências de recuperação.

A recuperação pode envolver DBA, Engenharia de Dados, Plataforma / SRE, Segurança, Governança e outras funções, dependendo da falha.

Uma restauração bem-sucedida da infraestrutura não comprova, de forma independente, a recuperação completa da plataforma.

### 16.26 Responsabilidade por Incidentes

O tratamento de incidentes exige responsabilidade coordenada de acordo com o tipo de incidente.

Exemplos incluem:

**Incidente de processamento de dados**
→ Engenharia de Dados.

**Incidente de banco de dados**
→ DBA.

**Incidente de infraestrutura**
→ Plataforma / SRE.

**Incidente de segurança**
→ Segurança com os responsáveis técnicos afetados.

**Incidente relacionado à privacidade**
→ Privacidade / Jurídico com Segurança, Governança e os responsáveis técnicos afetados.

**Incidente de definição de negócio**
→ Responsável pelos Dados de Negócio com Governança e responsáveis pela implementação técnica.

Incidentes complexos podem abranger várias responsabilidades.

O processo de incidentes ainda deve identificar a autoridade de decisão e a responsabilidade pela remediação.

### 16.27 Responsabilidade por Mudanças

Uma alteração relevante pode exigir várias formas de autoridade.

A plataforma deve distinguir, quando aplicável:

- quem propõe a alteração;
- quem a implementa;
- quem avalia o impacto técnico;
- quem avalia o impacto de negócio;
- quem avalia o impacto de segurança ou privacidade;
- quem a aprova;
- quem a valida.

A mesma pessoa pode desempenhar várias dessas responsabilidades no laboratório.

Ainda assim, sua distinção lógica deve permanecer visível.

### 16.28 Responsabilidade pela Documentação

A documentação governada exige responsabilidade identificável.

A documentação relevante inclui:

- arquitetura;
- padrões;
- contratos;
- metadados;
- definições de produtos de dados;
- procedimentos operacionais;
- testes;
- evidências;
- ADRs.

O responsável deve manter a documentação alinhada à arquitetura e à implementação validadas.

A documentação não deve ficar sem responsável apenas porque está armazenada no controle de versão.

### 16.29 Responsabilidade pelas Evidências

As evidências exigem responsabilidade por:

- definir o que deve ser comprovado;
- executar ou automatizar a validação;
- coletar o resultado;
- sanitizar conteúdo sensível;
- preservar o artefato;
- interpretar PASS ou FAIL;
- associar a evidência à arquitetura ou ao controle relevante.

A função que implementa um controle também pode executar seu teste na Versão 1.

Quando maior independência for necessária, ambientes corporativos podem separar implementação e validação.

### 16.30 Separação de Responsabilidades

A separação de responsabilidades reduz o risco de que uma única responsabilidade possa criar, aprovar, publicar e ocultar uma alteração inadequada sem controle independente.

Separações relevantes podem incluir:

- implementação versus aprovação;
- processamento versus certificação;
- certificação versus consumo;
- operação rotineira versus administração;
- administração de segurança versus acesso comum das cargas de trabalho;
- implementação versus validação independente, quando necessário.

O grau de separação física depende do risco, do tamanho da organização e do ambiente de implantação.

A separação lógica permanece necessária mesmo quando a separação física não é prática.

### 16.31 Consolidação de Funções no Laboratório

A Versão 1 é implementada e operada em um laboratório de treinamento.

Um único operador pode, portanto, desempenhar responsabilidades que normalmente seriam distribuídas entre:

- Engenharia de Dados;
- DBA;
- Plataforma / SRE;
- Segurança;
- Governança;
- BI;
- testes;
- recuperação.

Essa consolidação é uma restrição de implementação do laboratório.

Ela não deve ser representada como o modelo operacional corporativo pretendido.

### 16.32 Separação Lógica no Laboratório

Mesmo quando uma única pessoa desempenha várias funções, o laboratório deve preservar a separação lógica por meio de mecanismos como:

- identidades de serviço distintas;
- permissões distintas;
- estágios de processamento separados;
- limites explícitos de certificação;
- responsabilidades documentadas;
- cenários de teste específicos por função;
- acessos administrativos e rotineiros separados, quando possível.

O objetivo não é simular artificialmente várias pessoas.

O objetivo é demonstrar que a arquitetura não depende de uma única identidade irrestrita ou de responsabilidades indefinidas.

### 16.33 Distribuição de Funções no Ambiente Corporativo

Uma implantação corporativa pode distribuir responsabilidades entre funções especializadas, como:

- Engenharia de Dados;
- DBA;
- Engenharia de Plataforma;
- SRE;
- Engenharia de Segurança;
- Operações de Segurança;
- Governança de Dados;
- Privacidade;
- Jurídico;
- Responsabilidade pelos Dados de Negócio;
- BI / Analytics;
- Auditoria Interna.

A estrutura organizacional exata pode variar.

A evolução para o ambiente corporativo deve mapear essas funções para as responsabilidades lógicas, em vez de redefinir a arquitetura em torno dos nomes atuais das equipes.

### 16.34 Matriz de Responsabilidades

A Atlas Engineering deve manter uma matriz de responsabilidades para capacidades significativas.

Uma matriz representativa pode incluir:

| Capacidade | Responsabilidade Principal | Responsabilidades de Suporte |
|---|---|---|
| Operação do banco de dados de origem | DBA / Responsável pela Origem | Plataforma / SRE |
| Configuração do CDC | DBA | Engenharia de Dados |
| Integração com Debezium | Engenharia de Dados | DBA, Plataforma / SRE |
| Operação da plataforma Kafka | Plataforma / SRE | Engenharia de Dados |
| Contrato de eventos | Engenharia de Dados | Responsável pela Origem, Governança |
| Processamento Bronze / Silver | Engenharia de Dados | Plataforma / SRE |
| Produto de dados Gold | Engenharia de Dados | Responsável pelos Dados de Negócio, Governança |
| Qualidade de dados | Engenharia de Dados | Governança, Responsável pelos Dados de Negócio |
| Reconciliação | Engenharia de Dados | Governança, Responsável pelos Dados de Negócio |
| Certificação | Responsabilidade de Certificação Governada | Engenharia de Dados, Governança, Responsável pelos Dados de Negócio |
| Publicação | Responsabilidade pela Publicação | Engenharia de Dados, Plataforma / SRE |
| Consumo da Certified Gold | BI / Consumidor de Dados | Engenharia de Dados |
| Requisitos de identidade e acesso | Segurança | Responsáveis Técnicos |
| Implementação técnica de acesso | Responsável Técnico | Segurança |
| Classificação | Governança de Dados | Segurança, Privacidade / Jurídico, Responsável pelos Dados de Negócio |
| Requisito de privacidade | Privacidade / Jurídico | Governança, Responsáveis Técnicos |
| Backup e recuperação | Responsável Técnico | DBA, Plataforma / SRE, Engenharia de Dados |
| Incidente de segurança | Segurança | Responsáveis Técnicos Afetados |
| Documentação | Função Responsável | Funções de Suporte |
| Evidências | Responsável pelo Controle / Teste | Governança, Segurança quando aplicável |

A matriz é uma linha de base arquitetural.

Ela não exige que cada responsabilidade seja desempenhada por uma pessoa diferente na Versão 1.

### 16.35 Lacunas de Responsabilidade

Uma lacuna de responsabilidade existe quando uma capacidade importante não possui um responsável identificável.

Exemplos incluem:

- regra de qualidade com falha sem responsável pela remediação;
- expiração de certificado sem função responsável;
- alteração de contrato sem autoridade de aprovação;
- *backup* sem responsável pela restauração;
- alerta de incidente sem caminho de escalonamento;
- produto de dados sem responsável de negócio.

Lacunas de responsabilidade representam riscos de governança e operacionais.

Elas devem ser resolvidas explicitamente, em vez de se presumir que pertencem a quem perceber o problema primeiro.

### 16.36 Sobreposição de Responsabilidades

Algumas responsabilidades se sobrepõem legitimamente.

A sobreposição torna-se um problema quando a autoridade de decisão fica indefinida.

Para controles significativos, a documentação deve distinguir, sempre que possível:

- quem define;
- quem implementa;
- quem aprova;
- quem opera;
- quem valida;
- quem consome.

Essa distinção pode evoluir posteriormente para um modelo RACI formal caso a complexidade organizacional assim exija.

### 16.37 Escalonamento

Os procedimentos operacionais devem identificar caminhos de escalonamento de acordo com a responsabilidade afetada.

Exemplos incluem:

**Problema no banco de dados de origem**
→ DBA.

**Problema de transformação no pipeline**
→ Engenharia de Dados.

**Problema de infraestrutura**
→ Plataforma / SRE.

**Acesso não autorizado**
→ Segurança.

**Questão relacionada a dados pessoais**
→ Privacidade / Jurídico e Governança de Dados.

**Conflito de definição de negócio**
→ Responsável pelos Dados de Negócio.

Incidentes complexos podem exigir várias funções simultaneamente.

O escalonamento identifica o caminho responsável; ele não elimina a colaboração entre diferentes funções.

### 16.38 Funções e Privilégio Mínimo

As responsabilidades devem orientar a autorização.

Uma função deve receber o acesso necessário para desempenhar suas responsabilidades, e não permissões associadas à senioridade organizacional ou à conveniência.

Por exemplo:

- o Responsável pelos Dados de Negócio não exige automaticamente administração de banco de dados;
- Segurança não exige automaticamente modificação irrestrita dos dados de negócio;
- Plataforma / SRE não exige automaticamente consumo de dados analíticos;
- BI não exige acesso à Bronze;
- Engenharia de Dados não exige automaticamente administração de segurança irrestrita.

Responsabilidade e privilégio técnico devem permanecer intencionalmente alinhados.

### 16.39 Funções e Evidências

As evidências devem tornar a responsabilidade visível quando relevante.

Um resultado de teste torna-se operacionalmente mais útil quando pode responder:

- qual capacidade foi testada;
- qual função é responsável pelo requisito;
- qual função implementou o controle;
- qual identidade executou o teste;
- quem ou o que validou o resultado.

Isso dá suporte à responsabilização, investigação e manutenção futura.

### 16.40 Revisão de Funções

As responsabilidades devem ser revisadas quando:

- a arquitetura mudar;
- um novo componente da plataforma for introduzido;
- um novo produto de dados for criado;
- a responsabilidade mudar;
- os requisitos de segurança mudarem;
- os requisitos de privacidade mudarem;
- incidentes operacionais revelarem ambiguidades;
- lacunas de responsabilidade ou sobreposições problemáticas forem descobertas.

As funções fazem parte da governança da arquitetura e podem evoluir juntamente com a plataforma.

### 16.41 Testes de Funções e Responsabilidades

Os limites das funções podem ser validados por meio de testes técnicos e procedurais.

Testes representativos incluem:

- identidades de serviço possuem apenas as permissões exigidas por suas responsabilidades;
- BI não pode modificar a Certified Gold;
- identidades de processamento da Engenharia de Dados não podem executar ações administrativas não relacionadas;
- a autoridade de publicação permanece distinta do acesso comum dos consumidores;
- ações sensíveis à segurança permanecem atribuíveis;
- existem metadados de responsabilidade para produtos e contratos governados;
- os procedimentos de recuperação identificam as funções responsáveis;
- uma certificação com falha possui um responsável identificável pela remediação.

Nem toda responsabilidade pode ser aplicada tecnicamente.

Quando a aplicação for procedural, a documentação e as evidências devem tornar essa distinção explícita.

### 16.42 Evidências de Funções e Responsabilidades

As evidências podem identificar:

- capacidade;
- função responsável;
- funções de suporte;
- identidade técnica, quando aplicável;
- responsabilidade esperada;
- controle implementado;
- resultado da validação;
- caminho de escalonamento;
- versão da implementação;
- conclusão.

As evidências devem demonstrar a responsabilidade sem sugerir uma separação organizacional que não existe no laboratório da Versão 1.

### 16.43 Garantias de Funções e Responsabilidades

O modelo de responsabilidades da Atlas Engineering deve preservar as seguintes garantias:

1. funções representam responsabilidades, e não necessariamente pessoas ou cargos individuais;
2. uma pessoa pode desempenhar várias funções sem eliminar sua separação conceitual;
3. a Engenharia de Dados é responsável pela implementação do processamento governado de dados, mas não define de forma independente todos os requisitos de negócio, segurança, privacidade ou jurídicos;
4. a responsabilidade pela origem operacional permanece distinta da responsabilidade analítica *downstream*;
5. o CDC representa um limite de responsabilidade compartilhada entre aspectos de banco de dados e de Engenharia de Dados;
6. a administração da infraestrutura não implica automaticamente acesso irrestrito aos dados de negócio;
7. Segurança define ou coordena os requisitos de proteção, enquanto a implementação pode permanecer distribuída entre os responsáveis técnicos;
8. a Governança de Dados coordena significado, classificação, ciclo de vida, responsabilidade e uso governado;
9. Privacidade / Jurídico determina os requisitos jurídicos e de privacidade aplicáveis, em vez de a plataforma de dados chegar de forma independente a conclusões jurídicas;
10. a Responsabilidade pelos Dados de Negócio permanece distinta da responsabilidade pela implementação técnica;
11. BI consome produtos analíticos governados, em vez de se tornar o local não controlado da lógica fundamental de transformação;
12. qualidade, reconciliação, certificação, publicação, recuperação e resposta a incidentes possuem responsabilidades identificáveis;
13. alterações significativas distinguem a autoridade de implementação da autoridade de negócio, segurança, privacidade ou governança, quando aplicável;
14. documentação e evidências possuem responsabilidade identificável;
15. a separação de responsabilidades é aplicada de acordo com o risco e a capacidade organizacional;
16. a Versão 1 pode consolidar funções humanas enquanto preserva limites lógicos técnicos e procedurais;
17. lacunas de responsabilidade são tratadas como riscos de governança e operacionais;
18. responsabilidades sobrepostas não eliminam a necessidade de uma autoridade de decisão clara;
19. o escalonamento segue a responsabilidade afetada pelo problema;
20. o privilégio técnico é alinhado à responsabilidade, e não à conveniência ou senioridade;
21. os limites de responsabilidade são revisáveis à medida que a arquitetura evolui;
22. os limites de funções implementados são testáveis quando tecnicamente aplicáveis;
23. controles procedurais permanecem distinguíveis da aplicação técnica;
24. as afirmações sobre responsabilidades refletem o contexto organizacional real do laboratório ou do ambiente corporativo.

---

## 17. Estratégia de Validação de Segurança

A validação de segurança demonstra se os controles implementados realmente aplicam os requisitos de segurança e governança definidos pela Atlas Engineering.

Um controle não é considerado comprovado apenas porque:

- existe uma configuração;
- existe uma identidade ou função;
- um certificado está instalado;
- uma senha está armazenada fora do controle de versão;
- uma regra de rede parece correta;
- a documentação descreve o comportamento esperado.

A validação deve demonstrar o comportamento do controle implementado sob condições controladas.

O ciclo de vida governante é:

**Requisito → Implementação → Teste → Observabilidade → Evidência → Conclusão**

A validação deve incluir tanto:

**Comportamento Autorizado → PERMITIDO**

quanto, quando aplicável:

**Comportamento Não Autorizado → NEGADO**

Uma operação negada representa um resultado de segurança bem-sucedido quando a negação é o comportamento esperado documentado.

### 17.1 Escopo da Validação

A validação de segurança pode abranger capacidades como:

- identidade;
- autenticação;
- autorização;
- segredos;
- ciclo de vida de credenciais;
- acesso à rede;
- proteção do transporte;
- proteção de dados;
- classificação;
- privacidade;
- acesso às camadas;
- controles de *schema* e governança;
- retenção;
- auditabilidade;
- resposta a incidentes;
- recuperação.

Nem todo controle exige o mesmo mecanismo de validação.

Alguns controles são validados tecnicamente.

Outros podem exigir:

- revisão de metadados;
- revisão de configuração;
- validação do estado de governança;
- evidências procedurais.

O método de validação deve corresponder ao controle que está sendo afirmado.

### 17.2 Testes Positivos de Segurança

Testes positivos confirmam que uma identidade ou processo autorizado pode executar a operação exigida por sua responsabilidade.

Exemplos representativos incluem:

- Debezium pode acessar as estruturas necessárias do SQL Server CDC;
- um produtor Kafka aprovado pode publicar em seu tópico autorizado;
- um consumidor Bronze pode consumir seu tópico atribuído;
- o processamento Bronze pode gravar em seu escopo de armazenamento aprovado;
- o processamento Silver pode ler a Bronze e gravar na Silver;
- o processamento Gold pode ler a Silver e produzir o estado Gold aprovado;
- Power BI pode ler seu produto Certified Gold aprovado;
- um administrador pode executar uma ação administrativa explicitamente autorizada.

Testes positivos demonstram que os controles de segurança permitem a operação legítima da plataforma.

### 17.3 Testes Negativos de Segurança

Testes negativos confirmam que as identidades não podem executar operações fora de suas responsabilidades autorizadas.

Exemplos representativos incluem:

- Power BI não pode consultar as tabelas operacionais do AtlasCommerce;
- um processador Bronze não pode modificar a Gold;
- um consumidor Kafka não pode administrar o *cluster*;
- um processador Silver não pode gravar no histórico da Bronze;
- uma identidade de observabilidade não pode modificar dados de negócio;
- uma credencial revogada não pode autenticar;
- um usuário comum não pode alterar a configuração de segurança.

Testes negativos são essenciais para limites de acesso importantes porque o acesso autorizado bem-sucedido, isoladamente, não demonstra privilégio mínimo.

### 17.4 Identificadores de Teste

Os testes de segurança devem utilizar identificadores estáveis.

Os identificadores permitem que arquitetura, implementação, evidências, procedimentos operacionais e futura documentação de FAQ façam referência ao mesmo comportamento validado.

As categorias sugeridas incluem:

- `IAM-*` — gerenciamento de identidades e acessos;
- `AUTH-*` — autenticação e autorização;
- `SEC-*` — controles gerais de segurança;
- `SECRET-*` — gerenciamento de segredos e credenciais;
- `NET-*` — controles de rede e comunicação;
- `TLS-*` — criptografia de transporte e validação de certificados;
- `DATA-*` — controles de proteção de dados;
- `CLASS-*` — controles de classificação;
- `PRIV-*` — controles de privacidade;
- `ACCESS-*` — limites de acesso às camadas;
- `GOV-*` — controles de governança;
- `RET-*` — retenção e descarte;
- `AUD-*` — auditabilidade;
- `INC-*` — incidentes e recuperação de segurança.

O catálogo pode evoluir à medida que a implementação crescer.

Identificadores estáveis não devem ser renumerados arbitrariamente depois que a documentação ou as evidências passarem a depender deles.

### 17.5 Definição do Teste

Cada teste de segurança deve definir o comportamento esperado antes da execução.

Uma definição de teste deve incluir, quando aplicável:

- ID do Teste;
- Propósito;
- Requisito Arquitetural;
- Estado Inicial;
- Identidade ou Função;
- Tipo de Credencial;
- Origem;
- Recurso de Destino;
- Operação Solicitada;
- Classificação dos Dados;
- Resultado Esperado;
- Observabilidade Relevante;
- Requisito de Limpeza.

Definir as expectativas antes da execução impede que o resultado seja reinterpretado apenas porque o comportamento observado foi inconveniente.

### 17.6 Critérios de PASS e FAIL

Os testes de segurança exigem critérios explícitos de PASS e FAIL.

Por exemplo:

**AUTH-001 — Power BI Lê a Certified Gold**

PASS:
→ a identidade aprovada do Power BI autentica com sucesso e lê somente a representação autorizada da Certified Gold.

FAIL:
→ o acesso necessário é inesperadamente negado, a autenticação falha ou um acesso mais amplo e não autorizado é necessário para que o teste seja bem-sucedido.

Para um teste negativo:

**AUTH-002 — Power BI Não Pode Ler o AtlasCommerce**

PASS:
→ o acesso é negado.

FAIL:
→ a consulta é bem-sucedida.

PASS, portanto, reflete o comportamento de segurança esperado, e não se a operação técnica solicitada simplesmente foi bem-sucedida.

### 17.7 Validação de Autenticação

Os testes de autenticação devem verificar comportamentos como:

- credencial válida aceita;
- credencial inválida rejeitada;
- credencial revogada rejeitada;
- credencial expirada rejeitada, quando aplicável;
- identidade desabilitada rejeitada;
- credencial substituta aceita após a rotação;
- confiança no certificado validada, quando aplicável.

As evidências não devem expor valores reais de segredos.

### 17.8 Validação de Autorização

Os testes de autorização devem confirmar tanto as operações necessárias quanto as proibidas.

Exemplos representativos incluem:

**AUTH-010**
→ Processador Gold lê a entrada Silver aprovada  
→ Esperado: PERMITIDO

**AUTH-011**
→ Processador Gold modifica dados operacionais do AtlasCommerce  
→ Esperado: NEGADO

**AUTH-012**
→ Power BI lê a Certified Gold  
→ Esperado: PERMITIDO

**AUTH-013**
→ Power BI modifica a Certified Gold  
→ Esperado: NEGADO

A validação de autorização deve ser derivada do modelo de acesso governado definido no Capítulo 11.

### 17.9 Isolamento de Identidades de Serviço

As identidades de serviço devem ser testadas quanto ao isolamento.

Uma credencial de serviço deve autenticar e autorizar com sucesso somente as responsabilidades atribuídas àquele serviço.

Por exemplo, uma identidade de Processador Bronze não deve obter automaticamente:

- administração da Gold;
- publicação da Certified Gold;
- administração do SQL Server;
- acesso a tópicos Kafka não relacionados.

Os testes de isolamento demonstram que o comprometimento de uma identidade de serviço não fornece automaticamente privilégios não relacionados.

### 17.10 Validação do Acesso Administrativo

Os testes de acesso administrativo devem demonstrar que:

- identidades administrativas autorizadas podem executar as operações administrativas necessárias;
- identidades de cargas de trabalho rotineiras não podem executar essas operações;
- atividades elevadas permanecem atribuíveis;
- acessos elevados temporários podem ser removidos;
- ações administrativas são auditáveis quando houver suporte.

Os testes não devem deixar acessos administrativos desnecessários habilitados após sua conclusão.

### 17.11 Validação da Rotação de Credenciais

A rotação de credenciais deve ser validada como uma sequência operacional.

Um cenário representativo é:

1. o serviço opera com a Credencial V1;
2. a Credencial V2 é criada;
3. a carga de trabalho legítima recebe a V2 de forma segura;
4. a autenticação com a V2 é bem-sucedida;
5. a V1 é revogada;
6. a autenticação utilizando a V1 falha;
7. o processamento normal continua utilizando a V2.

Um teste de rotação está incompleto se a credencial substituída permanecer válida indefinidamente.

### 17.12 Validação de Exposição de Segredos

Os controles de gerenciamento de segredos podem ser validados por meio de varredura controlada e revisão de artefatos.

Os testes podem confirmar que:

- credenciais em uso estão ausentes dos artefatos mantidos no controle de versão;
- arquivos locais de segredos estão excluídos do controle de versão;
- exemplos públicos contêm *placeholders*;
- *logs* não expõem valores de segredos testados;
- evidências não contêm credenciais reutilizáveis;
- credenciais expostas e revogadas falham na autenticação.

Uma credencial real não deve ser intencionalmente exposta publicamente para testar a detecção de exposição.

### 17.13 Validação de Acesso à Rede

Os testes de rede devem validar tanto a comunicação necessária quanto a proibida.

Exemplos representativos incluem:

- Debezium pode alcançar o *endpoint* necessário do SQL Server;
- o processamento Bronze pode alcançar Kafka e MinIO;
- Power BI pode alcançar a Certified Gold;
- portas desnecessárias do *host* não estão acessíveis externamente;
- um contexto não autorizado não pode utilizar uma interface administrativa;
- a recuperação do serviço após uma interrupção temporária de rede não exige o enfraquecimento dos controles de segurança.

A conectividade, isoladamente, não comprova autorização.

A validação de rede deve ser interpretada em conjunto com autenticação e autorização, quando aplicável.

### 17.14 Validação de TLS

Quando TLS estiver implementado, a validação deve testar mais do que a existência de uma conexão criptografada.

Testes relevantes podem incluir:

- conexão bem-sucedida utilizando material de certificado confiável;
- rejeição de certificados inválidos ou não confiáveis quando a validação for necessária;
- validação do nome do *host* ou *endpoint*, quando aplicável;
- visibilidade da expiração do certificado;
- uso correto de *endpoints* protegidos;
- ausência de *fallback* inseguro.

Uma conexão que somente é bem-sucedida após a verificação de confiança ser desabilitada não deve ser representada como uma validação de TLS bem-sucedida.

### 17.15 Validação da Proteção de Dados

Os testes de proteção de dados podem verificar:

- acesso não autorizado é negado;
- atributos sensíveis não se propagam além das camadas aprovadas;
- proteção em trânsito está ativa quando implementada;
- proteção em repouso está ativa quando implementada;
- artefatos temporários são governados;
- acesso à quarentena é restrito;
- acesso a *backups* é controlado;
- exportações preservam os requisitos de tratamento aplicáveis.

O teste deve demonstrar o mecanismo implementado, em vez de simplesmente repetir a documentação.

### 17.16 Validação da Classificação

Os testes de classificação devem verificar se a classificação altera efetivamente o tratamento.

Cenários representativos incluem:

**CLASS-001**
→ atributo classificado como Confidencial  
→ consumidor analítico não autorizado é impedido de acessá-lo.

**CLASS-002**
→ valor Restrito  
→ ausente dos *logs* comuns.

**CLASS-003**
→ atributo pessoal desnecessário na Certified Gold  
→ removido antes da publicação.

Um rótulo de classificação sem consequência comportamental não demonstra uma governança de classificação efetiva.

### 17.17 Validação de Privacidade

Os testes de privacidade devem utilizar identidades e dados controlados ou sintéticos sempre que possível.

Testes representativos podem incluir:

- atributo pessoal corretamente identificado;
- atributo pessoal desnecessário removido *downstream*;
- consumidor não autorizado tem o acesso negado;
- Certified Gold expõe somente os campos aprovados;
- dados pessoais ausentes das evidências públicas;
- correção se propaga de acordo com o projeto implementado;
- exclusão ou desidentificação aprovada se comporta conforme definido;
- *replay* não recria um estado inválido em relação à privacidade quando o modelo de governança implementado o impede.

A validação de privacidade demonstra comportamento técnico.

Ela não estabelece, de forma independente, conformidade legal.

### 17.18 Validação de Acesso às Camadas

Os testes de acesso às camadas devem ser derivados da matriz de acesso governada.

Para cada identidade importante:

**Acesso Necessário**
→ validar PERMITIDO.

**Acesso Não Necessário**
→ validar NEGADO.

Identidades representativas incluem:

- Debezium;
- Processador Bronze;
- Processador Silver;
- Processador Gold;
- Certificação / Publicação;
- Power BI;
- serviços de observabilidade;
- administradores.

A validação de acesso às camadas fornece evidência direta de privilégio mínimo.

### 17.19 Validação de Governança

Os testes de governança podem incluir:

- evolução compatível do contrato de eventos aceita;
- alteração incompatível do contrato rejeitada;
- versão histórica suportada do contrato permanece interpretável;
- saída Gold corresponde à granularidade documentada;
- implementação de qualidade corresponde à regra governada;
- implementação de reconciliação corresponde à sua definição aprovada;
- Certified Gold corresponde ao seu contrato de consumo;
- responsável pelos metadados está identificado;
- metadados de classificação correspondem ao tratamento implementado;
- ativos descontinuados permanecem identificáveis.

A validação de governança testa o alinhamento entre a intenção governada e o comportamento implementado.

### 17.20 Validação da Retenção

Os testes de retenção devem confirmar o comportamento real do ciclo de vida.

Testes representativos incluem:

- dados do Kafka expiram de acordo com a política configurada;
- a recuperação necessária a partir do Kafka permanece possível dentro da janela de retenção;
- artefatos temporários são removidos;
- a quarentena alcança um estado explícito de ciclo de vida;
- versões certificadas anteriores seguem a retenção configurada;
- *backup* restaurado recebe o tratamento de governança atual;
- dados intencionalmente descartados não reaparecem por meio do *replay* normal quando a implementação impede esse comportamento.

A validação da retenção deve refletir o comportamento real da tecnologia.

### 17.21 Validação da Auditabilidade

Os testes de auditoria devem confirmar que atividades relevantes para a segurança geram contexto suficiente.

Testes representativos incluem:

- sucesso de autenticação registrado;
- falha de autenticação registrada;
- negação de autorização registrada;
- alteração de privilégio atribuível;
- ação administrativa atribuível;
- rotação de credenciais rastreável;
- falha de credencial revogada observável;
- valores sensíveis ausentes dos *logs* de auditoria;
- evento de segurança correlacionável com a execução do teste.

A ausência das informações de auditoria necessárias é, por si só, uma falha de validação.

### 17.22 Validação de Incidentes

Testes controlados de incidentes de segurança podem incluir:

- simulação de comprometimento de credencial de serviço;
- tentativa de acesso não autorizado a uma camada;
- detecção de permissão excessiva;
- revogação de credenciais;
- recuperação do estado confiável;
- restauração dos limites normais de acesso;
- preservação de evidências.

Os testes de incidentes devem permanecer controlados e não devem expor informações sensíveis reais ou credenciais públicas reutilizáveis.

### 17.23 Validação da Segurança na Recuperação

Os testes de recuperação devem verificar se os controles de segurança sobrevivem à recuperação ou são corretamente restaurados depois dela.

Questões relevantes incluem:

- As identidades ainda estão corretamente limitadas aos seus escopos?
- As credenciais revogadas continuam revogadas?
- As credenciais substitutas estão válidas?
- A configuração restaurada reintroduziu acesso excessivo?
- A proteção do transporte continua ativa?
- A auditabilidade está funcionando?
- A Certified Gold continua governada?
- O acesso elevado temporário foi removido?

A recuperação dos dados com segurança degradada não representa um PASS completo.

### 17.24 Testes de Regressão de Segurança

O comportamento de segurança deve ser revalidado após alterações capazes de afetar os limites de segurança.

Alterações relevantes incluem:

- alterações de identidade;
- alterações de permissão;
- alterações no *schema* da origem que afetem dados sensíveis;
- novos serviços;
- novos caminhos de rede;
- alterações de certificados;
- alterações no gerenciamento de segredos;
- novos consumidores analíticos;
- alterações de classificação;
- alterações de retenção;
- mecanismos de recuperação.

Testes anteriormente aprovados podem se tornar testes de regressão para versões posteriores da plataforma.

Um PASS histórico não comprova que uma implementação modificada continue se comportando de forma idêntica.

### 17.25 Isolamento dos Testes

Os testes de segurança devem minimizar impactos não intencionais sobre comportamentos não relacionados da plataforma.

Sempre que possível, os testes devem utilizar:

- identidades de teste dedicadas;
- conjuntos de dados controlados;
- dados pessoais sintéticos;
- funções temporárias;
- recursos de teste isolados;
- alterações reversíveis.

Um teste não deve criar acesso excessivo de longa duração ou estado de segurança não gerenciado.

### 17.26 Limpeza dos Testes

O projeto dos testes de segurança deve incluir limpeza.

A limpeza pode incluir:

- remover funções temporárias;
- revogar credenciais temporárias;
- excluir identidades de teste;
- remover regras temporárias de rede;
- restaurar as permissões pretendidas;
- remover dados temporários;
- remover artefatos de teste desnecessários.

A própria limpeza pode exigir validação.

Um teste que obtém PASS, mas deixa o ambiente menos seguro, está incompleto.

### 17.27 Repetibilidade

Os testes de segurança devem ser repetíveis sempre que possível.

A repetibilidade demonstra que o comportamento de segurança faz parte da arquitetura implementada, em vez de representar um resultado manual isolado.

Condições equivalentes devem produzir o mesmo resultado de segurança esperado.

Quando um teste não puder ser automatizado com segurança, seu procedimento manual deve permanecer documentado.

### 17.28 Automação

Testes de segurança adequados podem ser integrados à validação automatizada sempre que possível.

Exemplos incluem:

- varredura de segredos no repositório;
- verificações de compatibilidade de contratos;
- validação de políticas de acesso;
- testes negativos de autorização;
- verificações de expiração de certificados;
- validação de metadados;
- verificações de políticas de configuração.

A automação melhora a consistência, mas não substitui a interpretação ou a revisão de governança.

### 17.29 Ambiente dos Testes de Segurança

Os testes de segurança devem identificar o ambiente no qual foram executados.

A Versão 1 é um laboratório, e não um ambiente corporativo de produção.

As evidências devem descrever, quando aplicável:

- topologia;
- versões relevantes dos componentes;
- controles implementados;
- dados de teste;
- limitações do ambiente.

Um teste de laboratório bem-sucedido demonstra comportamento somente dentro dessas condições documentadas.

### 17.30 Estrutura das Evidências de Segurança

Um registro de evidência de segurança deve incluir, quando aplicável:

- ID do Teste;
- Nome do Teste;
- Propósito;
- Requisito Arquitetural;
- Ambiente;
- Versão da Implementação;
- Data e Hora;
- Estado Inicial;
- Identidade / Função;
- Recurso de Destino;
- Operação Solicitada;
- Classificação dos Dados;
- Resultado Esperado;
- Resultado Observado;
- Logs Relevantes;
- Métricas Relevantes;
- Evento de Auditoria;
- Limpeza;
- Estado Final;
- PASS / FAIL;
- Interpretação.

As evidências devem permanecer suficientemente concisas para uma revisão prática, preservando contexto suficiente para interpretação independente.

### 17.31 Sanitização das Evidências

As evidências de segurança devem ser revisadas antes da publicação.

A sanitização pode exigir a remoção ou ocultação de:

- senhas;
- *tokens*;
- chaves privadas;
- *connection strings* contendo credenciais;
- dados pessoais reais;
- configurações Restritas;
- detalhes internos de segurança desnecessários.

A sanitização não deve alterar o significado do resultado.

Quando informações forem ocultadas, a evidência deve tornar essa ocultação explícita.

### 17.32 Evidências Negativas

Testes de segurança com falha devem ser preservados quando apropriado.

Por exemplo:

**AUTH-013**

Esperado:
→ Power BI não pode modificar a Certified Gold.

Observado:
→ UPDATE foi bem-sucedido.

Resultado:
→ FAIL.

A expectativa governada não deve ser reescrita apenas para fazer com que o comportamento inesperado pareça aceitável.

A sequência correta é:

**Resultado Inesperado → Investigar → Causa Raiz → Decisão → Remediação → Revalidação**

Evidências de falha podem fornecer comprovação valiosa de como um controle ou pressuposto arquitetural foi aprimorado.

### 17.33 Evidências e Decisões Arquiteturais

A validação pode revelar que um pressuposto arquitetural está incorreto, incompleto ou é impraticável.

Exemplos incluem:

- um mecanismo de autorização não consegue aplicar o escopo pretendido;
- TLS se comporta de forma diferente do modelo de confiança presumido;
- um serviço exige acesso mais amplo do que o esperado;
- uma regra de retenção impede a recuperação necessária;
- uma transformação de privacidade viola um requisito analítico aprovado.

A resposta apropriada pode ser:

- modificar a implementação;
- revisar a arquitetura;
- selecionar outro mecanismo;
- documentar uma limitação;
- criar um ADR.

As evidências devem poder provocar mudanças na arquitetura.

Elas não devem ser forçadas a sustentar uma conclusão predeterminada.

### 17.34 Linha de Base de Segurança

Depois que os controles da Versão 1 forem implementados e testados, o projeto deve estabelecer uma linha de base de segurança medida.

A linha de base deve identificar quais controles estão:

- implementados;
- testados;
- aprovados;
- parcialmente implementados;
- planejados para evolução no ambiente corporativo;
- não aplicáveis.

A linha de base não deve utilizar rótulos vagos como:

**Seguro**

sem identificar os controles e as evidências que sustentam essa afirmação.

### 17.35 Níveis das Afirmações de Segurança

As afirmações de segurança devem distinguir entre:

**Documentado**
→ a arquitetura define o requisito.

**Implementado**
→ o controle existe.

**Testado**
→ uma validação controlada foi executada.

**Observado**
→ o comportamento ficou visível por meio de *logs*, métricas, auditoria ou mecanismos equivalentes.

**Sustentado por Evidências**
→ o resultado é preservado com contexto suficiente para revisão posterior.

Esses níveis impedem que a simples existência de uma configuração seja confundida com um comportamento de segurança demonstrado.

### 17.36 Afirmações do Laboratório

A Versão 1 pode demonstrar capacidades como:

- comportamento de privilégio mínimo nos cenários testados;
- aplicação de autenticação e autorização;
- isolamento de identidades de serviço;
- rotação e revogação de credenciais;
- comportamento dos limites de rede;
- comportamento selecionado de TLS;
- comportamento de minimização de dados;
- isolamento de acesso;
- auditabilidade;
- recuperação controlada de segurança.

Ela não demonstra automaticamente:

- Zero Trust em toda a organização;
- maturidade corporativa de IAM;
- conformidade regulatória;
- capacidade corporativa de SOC;
- operações de segurança em larga escala;
- alta disponibilidade em nível de produção;
- resistência contra todos os modelos de ameaça.

As afirmações devem permanecer proporcionais às evidências produzidas.

### 17.37 Revisão da Validação de Segurança

Os resultados da validação de segurança devem ser revisados quando:

- os controles mudarem;
- novos componentes da plataforma forem introduzidos;
- novos produtos analíticos forem criados;
- surgirem novos dados sensíveis;
- a arquitetura mudar;
- ocorrerem incidentes de segurança;
- testes anteriormente aprovados falharem;
- a evolução para o ambiente corporativo alterar o mecanismo de aplicação.

Um teste histórico aprovado não comprova que uma implementação posterior continue se comportando de forma idêntica.

Controles anteriormente validados devem, portanto, ser reconsiderados quando seu contexto de implementação mudar.

### 17.38 Garantias da Validação de Segurança

O modelo de validação de segurança da Atlas Engineering deve preservar as seguintes garantias:

1. controles documentados não são tratados como comprovados sem implementação e validação;
2. a validação inclui comportamentos de segurança positivos e negativos, quando aplicável;
3. identificadores estáveis de teste conectam requisitos, testes e evidências;
4. o comportamento esperado é definido antes da execução;
5. os critérios de PASS e FAIL refletem a intenção de segurança, e não o simples sucesso técnico;
6. o método de validação corresponde ao controle que está sendo afirmado;
7. controles de autenticação, autorização, isolamento de serviços, ciclo de vida de credenciais, acesso à rede, TLS, proteção de dados, classificação, privacidade, governança, retenção, auditabilidade, incidentes e recuperação são testáveis quando implementados;
8. a validação de acesso é derivada do modelo de acesso aprovado;
9. credenciais revogadas são testadas quanto à rejeição, quando aplicável;
10. TLS não é considerado validado quando a verificação de confiança é intencionalmente ignorada;
11. testes de classificação e privacidade demonstram o comportamento real de tratamento;
12. a validação da recuperação inclui a restauração dos limites de segurança;
13. os testes evitam exposição desnecessária de segredos reais ou dados pessoais;
14. o isolamento e a limpeza dos testes impedem que a validação deixe a plataforma em um estado menos seguro;
15. testes repetíveis são preferidos sempre que possível;
16. a automação pode fortalecer a validação sem substituir a interpretação;
17. as evidências identificam o ambiente e a implementação sob teste;
18. as evidências são sanitizadas sem alterar o significado do resultado;
19. testes com falha permanecem evidências válidas e conduzem à investigação e à remediação;
20. as evidências podem provocar mudanças na implementação ou na arquitetura;
21. as linhas de base de segurança descrevem controles específicos validados, em vez de afirmações gerais sem sustentação;
22. os níveis das afirmações de segurança distinguem estados documentados, implementados, testados, observados e sustentados por evidências;
23. as afirmações do laboratório permanecem limitadas aos cenários e à topologia efetivamente testados;
24. a validação de segurança é revisada quando o contexto de implementação muda;
25. as afirmações de validação de segurança permanecem limitadas aos controles e comportamentos efetivamente implementados e comprovados por evidências.

---

## 18. Limites de Segurança do Laboratório e do Ambiente Corporativo

A Versão 1 da Atlas Engineering é implementada como um laboratório controlado de treinamento e validação.

Seu propósito é demonstrar o comportamento arquitetural, os limites de segurança, os controles de governança, o tratamento de falhas, a observabilidade e as evidências sob uma topologia local documentada.

A implementação física da Versão 1 não deve ser representada como equivalente a um ambiente de segurança corporativo.

A arquitetura, portanto, distingue entre:

**Arquitetura Lógica de Segurança**
→ as responsabilidades, os limites de confiança, as regras de acesso e as propriedades de segurança que devem permanecer válidos independentemente da escala da implantação.

e:

**Implementação Física de Segurança**
→ os mecanismos disponíveis no ambiente específico de laboratório ou corporativo.

O princípio governante é:

**Preservar a Propriedade de Segurança — Permitir que o Mecanismo de Implementação Evolua**

### 18.1 Propósito do Laboratório

O laboratório da Versão 1 existe para validar comportamentos representativos de segurança e governança.

Ele tem como objetivo demonstrar capacidades como:

- separação de identidades;
- autenticação;
- autorização;
- privilégio mínimo;
- credenciais específicas por serviço;
- comportamento dos limites de rede;
- exposição controlada;
- controles selecionados de criptografia;
- minimização de dados;
- tratamento de dados sensíveis;
- classificação;
- processamento consciente de privacidade;
- acesso baseado em camadas;
- auditabilidade;
- rotação e revogação de credenciais;
- recuperação controlada de segurança;
- validação sustentada por evidências.

O laboratório não tem como objetivo reproduzir todas as plataformas, topologias ou processos organizacionais de segurança corporativa.

### 18.2 Restrições Físicas do Laboratório

A Versão 1 pode operar com características como:

- uma única estação de trabalho física;
- SQL Server hospedado localmente;
- Kafka, MinIO, Airflow, Prometheus, Grafana e serviços relacionados executados em *containers*;
- segmentação física de rede limitada;
- credenciais gerenciadas localmente;
- menos operadores humanos;
- ausência de provedor corporativo de identidade;
- ausência de plataforma corporativa centralizada de segredos;
- ausência de SIEM corporativo;
- ausência de módulo de segurança de *hardware*;
- redundância limitada de infraestrutura.

Essas restrições afetam a robustez física, a escala ou a maturidade operacional de alguns controles.

Elas não eliminam os limites lógicos de segurança definidos pela arquitetura.

### 18.3 Preservação dos Limites Lógicos

Mesmo quando vários serviços são executados na mesma máquina física, o laboratório deve preservar a separação lógica sempre que possível.

Exemplos incluem:

- identidades de serviço separadas;
- credenciais separadas;
- permissões com escopo definido;
- autenticação explícita;
- acesso específico por camada;
- exposição controlada de rede;
- distinção entre acesso administrativo e acesso rotineiro;
- autoridade de publicação controlada;
- consumo analítico restrito.

A co-localização física não deve justificar uma única identidade, credencial, conjunto de permissões ou caminho de comunicação irrestrito em toda a plataforma.

### 18.4 Ambiente com Operador Único

Uma única pessoa pode desempenhar várias responsabilidades na Versão 1.

Isso pode incluir atuar como:

- Engenheiro de Dados;
- DBA;
- Platform / SRE;
- Segurança;
- Governança de Dados;
- Responsável pelos Dados de Negócio;
- Desenvolvedor de BI.

Essa concentração é aceitável para um laboratório de treinamento.

A arquitetura ainda deve preservar a distinção lógica entre essas responsabilidades.

Por exemplo, o mesmo operador pode configurar tanto uma identidade de serviço da Bronze quanto uma identidade consumidora do Power BI, enquanto essas identidades técnicas recebem permissões diferentes.

### 18.5 Limitações de Identidade do Laboratório

O laboratório pode utilizar mecanismos locais de autenticação em vez de identidade corporativa centralizada.

Capacidades como:

- *single sign-on* corporativo;
- ciclo de vida centralizado de identidades;
- autenticação multifator corporativa;
- identidade gerenciada para cargas de trabalho;
- processos automatizados de entrada, movimentação e saída de usuários;

podem, portanto, não estar disponíveis na Versão 1.

Sua ausência não deve ser interpretada como uma decisão arquitetural de que essas capacidades são desnecessárias.

O laboratório valida os limites de identidade e autorização utilizando os mecanismos disponíveis localmente.

### 18.6 Limitações de Segredos do Laboratório

A Versão 1 pode utilizar injeção de segredos protegidos localmente em vez de gerenciamento centralizado de segredos corporativos.

Mecanismos representativos podem incluir:

- arquivos locais protegidos;
- variáveis de ambiente;
- credenciais específicas por serviço;
- exclusões do controle de versão.

Esses mecanismos podem oferecer suporte à validação controlada no laboratório.

Eles não são representados como equivalentes a capacidades corporativas como:

- *vaults* centralizados;
- credenciais de curta duração;
- rotação automatizada;
- identidade gerenciada;
- auditoria centralizada do acesso a segredos.

### 18.7 Limitações de Rede do Laboratório

Uma única estação de trabalho não pode reproduzir todas as características de isolamento físico de rede de um ambiente corporativo distribuído.

A Versão 1 pode utilizar mecanismos como:

- redes de *containers*;
- regras de *firewall* do *host*;
- associação de interfaces;
- restrições de *localhost*;
- publicação controlada de portas.

O laboratório ainda deve demonstrar, sempre que possível, que:

- portas desnecessárias não estão expostas;
- os serviços se comunicam somente pelos caminhos necessários;
- interfaces administrativas permanecem controladas;
- consumidores analíticos não exigem conectividade com o processamento interno.

A implantação corporativa pode substituir esses mecanismos por uma segmentação de rede mais robusta.

### 18.8 Escopo de Criptografia do Laboratório

Nem todos os mecanismos de criptografia de nível corporativo precisam ser implementados na Versão 1.

Os controles de criptografia devem ser selecionados de acordo com:

- valor para o treinamento;
- viabilidade técnica;
- classificação dos dados;
- limites de confiança;
- capacidades dos componentes.

Quando TLS ou criptografia em repouso estiver implementado, o mecanismo deve ser validado.

Quando não estiver implementado, a limitação deve permanecer explícita, em vez de implicar uma proteção que não existe.

### 18.9 Dados do Laboratório

A Versão 1 deve utilizar dados sintéticos e controlados do projeto.

Dados reais de clientes em produção não são necessários para validar capacidades como:

- classificação;
- minimização;
- restrições de acesso;
- pseudonimização;
- processamento consciente de privacidade;
- comportamento de retenção;
- auditabilidade.

Dados sintéticos permitem validação representativa sem introduzir exposição desnecessária à privacidade de dados reais.

### 18.10 Afirmações de Privacidade do Laboratório

O laboratório pode demonstrar comportamentos técnicos que oferecem suporte à governança de privacidade.

Exemplos incluem:

- identificação de dados pessoais;
- classificação de atributos;
- controle de propagação;
- remoção de atributos desnecessários;
- acesso controlado;
- linhagem consciente de privacidade;
- comportamento representativo de correção ou exclusão.

Essa validação não estabelece, de forma independente, conformidade legal com a LGPD.

A conformidade legal depende de condições organizacionais, jurídicas, contratuais, operacionais e específicas do processamento que vão além do laboratório.

### 18.11 Auditabilidade do Laboratório

A Versão 1 deve preservar auditabilidade suficiente para oferecer suporte a testes e investigações representativos de segurança.

Isso pode utilizar:

- *logs* dos componentes;
- auditoria do SQL Server ou eventos de segurança, quando implementados;
- informações de segurança relacionadas ao Kafka;
- *logs* do MinIO;
- *logs* do Airflow;
- *logs* estruturados das aplicações;
- métricas do Prometheus;
- *dashboards* do Grafana;
- registros controlados de evidências.

O laboratório não precisa reproduzir uma arquitetura corporativa completa de SIEM.

### 18.12 Resposta a Incidentes no Laboratório

A Versão 1 deve validar comportamentos selecionados de incidentes por meio de cenários controlados.

Exemplos incluem:

- credencial de teste exposta;
- credencial revogada;
- tentativa de acesso não autorizado;
- permissão excessiva;
- isolamento de serviço;
- recuperação do estado confiável;
- restauração do acesso pretendido.

Esses cenários demonstram comportamento técnico de segurança.

Eles não representam um Security Operations Center corporativo completo nem uma organização formal de resposta a incidentes.

### 18.13 Disponibilidade e Redundância do Laboratório

A Versão 1 pode não incluir redundância de nível corporativo.

Os componentes podem ser executados como instâncias únicas, e a estação de trabalho local pode permanecer como um domínio físico de falha compartilhado.

A validação de segurança deve, portanto, distinguir entre:

**Comportamento dos Controles de Segurança**

e:

**Capacidade Corporativa de Disponibilidade ou Alta Disponibilidade**

Uma validação de segurança bem-sucedida não implica tolerância a falhas além da topologia testada.

### 18.14 Escala do Laboratório

O comportamento de segurança validado na escala do laboratório não demonstra automaticamente as mesmas características operacionais em escala corporativa.

Exemplos incluem:

- administração de políticas de acesso;
- volume de auditoria;
- retenção de auditoria;
- rotação de credenciais em grandes populações de serviços;
- gerenciamento de certificados;
- correlação de eventos em alto volume;
- certificação automatizada de acessos.

O laboratório valida comportamento arquitetural representativo, e não capacidade operacional em escala corporativa.

### 18.15 Evolução Corporativa de Identidade

A implantação corporativa pode fortalecer o gerenciamento de identidades por meio de capacidades como:

- provedores centralizados de identidade;
- integração com diretórios;
- *single sign-on*;
- autenticação multifator;
- identidades gerenciadas;
- identidades de cargas de trabalho;
- gerenciamento automatizado do ciclo de vida;
- gerenciamento de acessos privilegiados;
- acesso privilegiado temporário.

Esses mecanismos fortalecem a aplicação dos limites de identidade já definidos pela arquitetura.

### 18.16 Evolução Corporativa de Segredos

O gerenciamento corporativo de segredos pode introduzir:

- *vaults* centralizados;
- armazenamentos gerenciados de segredos em nuvem;
- rotação automatizada;
- credenciais de curta duração;
- proteção baseada em *hardware*;
- auditoria do acesso a segredos;
- automação de certificados;
- credenciais dinâmicas.

Esses mecanismos reduzem o risco operacional enquanto preservam os princípios de identidade específica por serviço e privilégio mínimo.

### 18.17 Evolução Corporativa de Rede

A rede corporativa pode fortalecer os limites de comunicação por meio de capacidades como:

- sub-redes privadas;
- *security groups*;
- *firewalls*;
- listas de controle de acesso à rede;
- *private endpoints*;
- controle de *ingress* e *egress*;
- *service meshes*;
- monitoramento de fluxo de rede;
- acesso à rede baseado em *zero trust*;
- capacidades de detecção de intrusão.

Esses controles fortalecem a aplicação dos limites de confiança validados logicamente no laboratório.

### 18.18 Evolução Corporativa de Criptografia

Ambientes corporativos podem fortalecer a criptografia por meio de:

- certificados TLS gerenciados;
- autoridades certificadoras privadas;
- ciclo de vida centralizado de certificados;
- criptografia gerenciada em repouso;
- serviços de gerenciamento de chaves;
- módulos de segurança de *hardware*;
- chaves gerenciadas pelo cliente, quando necessário;
- rotação automatizada de chaves.

O princípio arquitetural permanece:

**Proteger os Dados + Proteger as Chaves + Controlar o Acesso + Preservar a Capacidade de Recuperação**

### 18.19 Observabilidade Corporativa e Operações de Segurança

A observabilidade de segurança corporativa pode adicionar capacidades como:

- agregação centralizada de *logs*;
- SIEM;
- SOAR;
- detecção de ameaças;
- análise de identidades;
- monitoramento de acessos privilegiados;
- análise de segurança de rede;
- monitoramento centralizado de certificados;
- fluxos de incidentes de segurança;
- resposta automatizada.

Essas capacidades ampliam a base de observabilidade, em vez de substituir os requisitos de eventos estruturados de segurança da plataforma.

### 18.20 Evolução Corporativa da Governança de Dados

A governança corporativa pode introduzir capacidades como:

- catálogos centralizados de dados;
- classificação automatizada;
- acesso baseado em políticas;
- fluxos de *data stewardship*;
- plataformas de privacidade;
- linhagem automatizada;
- gerenciamento de registros;
- *legal hold*;
- retenção automatizada;
- prevenção corporativa contra perda de dados.

Esses mecanismos operacionalizam os mesmos princípios de governança em maior escala organizacional.

### 18.21 Separação Corporativa de Responsabilidades

Uma organização maior pode separar fisicamente responsabilidades que a Versão 1 consolida sob um único operador.

Por exemplo:

**Engenharia de Dados**
→ processamento governado.

**DBA**
→ administração de bancos de dados.

**Platform / SRE**
→ ambiente de execução e infraestrutura.

**Segurança**
→ arquitetura e garantia de segurança.

**IAM**
→ governança de identidades.

**Governança de Dados**
→ governança de metadados e ciclo de vida.

**Privacidade / Jurídico**
→ requisitos de privacidade e jurídicos.

**BI**
→ consumo analítico.

A separação organizacional pode fortalecer a responsabilização sem alterar as responsabilidades lógicas definidas pela arquitetura.

### 18.22 Separação de Ambientes Corporativos

Implantações corporativas normalmente devem distinguir ambientes como:

- desenvolvimento;
- teste;
- *staging*;
- produção.

Cada ambiente pode exigir:

- credenciais separadas;
- identidades separadas;
- políticas de acesso separadas;
- segredos separados;
- dados separados;
- limites de rede separados;
- certificados separados;
- controles de auditoria separados.

Credenciais de produção não devem ser reutilizadas indiscriminadamente em ambientes inferiores.

Da mesma forma, dados reais de produção não devem ser copiados para ambientes que não sejam de produção sem propósito e proteção aprovados.

### 18.23 Aplicação de Políticas no Ambiente Corporativo

Em maior escala, controles de segurança mantidos manualmente tornam-se cada vez mais difíceis de aplicar de forma consistente.

A evolução corporativa pode, portanto, introduzir:

- *policy-as-code*;
- validação de infraestrutura como código;
- testes de políticas de acesso;
- verificações de configuração que ofereçam suporte à conformidade;
- varredura automatizada de segredos;
- controles de segurança em CI/CD;
- verificações de certificados;
- detecção de desvios de configuração.

A automação fortalece a consistência.

Ela não elimina a responsabilidade arquitetural, a governança ou a revisão humana.

### 18.24 Alta Disponibilidade Corporativa

A implantação corporativa pode exigir alta disponibilidade para dependências de segurança como:

- provedores de identidade;
- gerenciamento de segredos;
- serviços de certificados;
- *pipelines* de auditoria;
- monitoramento de segurança;
- gerenciamento de chaves.

Um *pipeline* de dados altamente disponível ainda pode se tornar inutilizável se uma dependência de segurança necessária estiver indisponível.

As dependências de segurança, portanto, participam do projeto corporativo de confiabilidade.

### 18.25 Recuperação de Desastre Corporativa

A recuperação de desastre deve restaurar tanto os serviços de dados quanto as dependências de segurança necessárias.

Um plano corporativo de recuperação pode precisar restaurar:

- configuração de identidades;
- políticas de autorização;
- referências a segredos;
- certificados;
- chaves de criptografia;
- capacidade de auditoria;
- monitoramento de segurança;
- políticas de rede.

Uma recuperação que restaura os dados, mas perde a capacidade de autenticar, descriptografar, autorizar ou auditar permanece incompleta.

### 18.26 Governança Corporativa de Segurança

Os controles corporativos de segurança exigem governança de ciclo de vida.

Processos relevantes podem incluir:

- revisão periódica de acessos;
- política de rotação de credenciais;
- ciclo de vida de certificados;
- gerenciamento de vulnerabilidades;
- revisão da configuração de segurança;
- testes de penetração;
- resposta a incidentes;
- avaliação de riscos de segurança;
- gerenciamento de exceções.

A Versão 1 não precisa reproduzir todos os processos organizacionais.

Sua arquitetura deve permanecer compatível com esses controles quando a evolução corporativa os exigir.

### 18.27 Substituição de Controles de Segurança

A evolução corporativa pode substituir o mecanismo físico utilizado por um controle sem alterar o requisito arquitetural.

Por exemplo:

**Versão 1**
→ injeção de segredos protegidos localmente.

**Ambiente Corporativo**
→ *vault* gerenciado de segredos.

Ou:

**Versão 1**
→ isolamento por redes de *containers*.

**Ambiente Corporativo**
→ sub-redes privadas e políticas de *firewall*.

Os requisitos permanecem:

**Isolamento de Segredos**

e:

**Limite Controlado de Comunicação**

mesmo que os mecanismos de implementação mudem.

### 18.28 Fortalecimento dos Controles de Segurança

A evolução corporativa deve fortalecer a aplicação dos controles, em vez de enfraquecer os limites lógicos.

Por exemplo:

**Credenciais Locais de Serviço**
→ **Identidades Gerenciadas de Cargas de Trabalho**

deve preservar ou melhorar:

- separação de identidades;
- privilégio mínimo;
- auditabilidade;
- revogação;
- redução do raio de impacto.

A substituição da tecnologia deve ser avaliada em relação à propriedade de segurança que se pretende preservar.

### 18.29 Portabilidade da Arquitetura de Segurança

Os requisitos lógicos de segurança não devem depender de uma implementação local específica.

Por exemplo, a arquitetura não deve definir:

**Variável de Ambiente = Arquitetura de Segurança**

Em vez disso, ela define o requisito:

**Um segredo deve permanecer fora do controle de versão e ser acessível somente por cargas de trabalho autorizadas.**

Variáveis de ambiente podem atender a esse requisito em um cenário da Versão 1.

O gerenciamento corporativo de segredos pode atendê-lo por meio de outro mecanismo.

Essa distinção preserva a portabilidade arquitetural.

### 18.30 Limites das Evidências do Laboratório

As evidências produzidas pela Versão 1 devem identificar as condições sob as quais a validação ocorreu.

O contexto relevante pode incluir:

- topologia;
- versões dos componentes;
- mecanismo de identidade;
- mecanismo de acesso;
- estado da criptografia;
- pressupostos de rede;
- tipo de conjunto de dados;
- cenário de teste;
- limitações conhecidas.

Um PASS de laboratório demonstra o comportamento documentado sob essas condições.

Ele não deve ser automaticamente generalizado para além delas.

### 18.31 Afirmações do Laboratório versus Corporativas

As afirmações da Versão 1 devem permanecer proporcionais às evidências.

Afirmações apropriadas podem incluir:

**Validado**
→ Power BI não pode acessar diretamente o AtlasCommerce sob a configuração testada.

**Validado**
→ uma credencial de teste de serviço revogada é rejeitada.

**Validado**
→ a identidade de serviço da Bronze não pode modificar a Certified Gold sob o modelo de acesso testado.

Generalizações sem sustentação incluem afirmações como:

**A Atlas Engineering possui segurança de nível corporativo.**

**A Atlas Engineering está em conformidade com a LGPD.**

**A Atlas Engineering implementa Zero Trust corporativo.**

**A Atlas Engineering é segura contra todos os cenários de ataque.**

A arquitetura deve distinguir o comportamento validado de afirmações amplas sem sustentação.

### 18.32 Documentação das Lacunas Corporativas

Quando a Versão 1 não implementar um controle corporativo, a documentação deve identificar:

- a capacidade ausente;
- por que ela não é necessária ou prática no laboratório;
- o requisito arquitetural que ela fortaleceria;
- a evolução corporativa esperada, quando conhecida.

Uma lacuna não é automaticamente um defeito.

Uma lacuna não documentada é mais perigosa porque pode ser confundida com uma capacidade implementada.

### 18.33 Evitando Teatro de Segurança

Os controles de segurança não devem ser adicionados apenas para fazer a arquitetura parecer mais sofisticada.

Exemplos de teatro de segurança incluem:

- habilitar criptografia sem validar a confiança no certificado;
- criar muitas funções enquanto todos os serviços continuam utilizando uma credencial de administrador;
- classificar dados como Restritos sem alterar seu tratamento;
- instalar ferramentas de segurança cujas saídas nunca são revisadas;
- afirmar anonimização após remover apenas nomes diretos;
- criar *dashboards* sem sinais de segurança acionáveis.

Um conjunto menor de controles corretamente implementados, testados, observados e comprovados por evidências é preferível a um conjunto maior de afirmações não validadas.

### 18.34 Evolução Corporativa Orientada por Evidências

A evolução corporativa deve ser orientada pelas evidências do laboratório.

Por exemplo:

**Observado**
→ a rotação local de credenciais causa uma interrupção inaceitável do serviço.

Possível evolução corporativa:

→ rotação gerenciada ou identidade de carga de trabalho.

Outro exemplo:

**Observado**
→ registros locais de auditoria são difíceis de correlacionar entre serviços.

Possível evolução corporativa:

→ agregação centralizada de *logs* ou SIEM.

As evidências, portanto, ajudam a justificar futuras decisões de tecnologia e arquitetura, em vez de tratar a complexidade corporativa como um objetivo por si só.

### 18.35 Evolução Corporativa e ADRs

Mudanças importantes dos mecanismos de laboratório para mecanismos corporativos devem ser documentadas por meio de ADRs quando afetarem materialmente a arquitetura.

Exemplos incluem:

- seleção de provedor centralizado de identidade;
- gerenciamento corporativo de segredos;
- modelo corporativo de segurança do Kafka;
- arquitetura de gerenciamento de chaves;
- observabilidade centralizada de segurança;
- plataforma de catálogo de dados;
- plataforma de gerenciamento de privacidade.

O ADR deve preservar:

- contexto;
- alternativas;
- decisão;
- *trade-offs*;
- considerações de migração.

### 18.36 Validação no Laboratório e no Ambiente Corporativo

A Atlas Engineering deve distinguir:

**Validação no Laboratório**
→ comportamento demonstrado sob as condições da Versão 1.

de:

**Validação no Ambiente Corporativo**
→ comportamento demonstrado após a implantação sob as condições da implementação corporativa.

As evidências do laboratório podem orientar as expectativas corporativas.

Elas não eliminam a necessidade de validar novamente o controle quando seu mecanismo de implementação, topologia, escala ou contexto operacional mudar.

### 18.37 Garantias de Segurança do Laboratório e do Ambiente Corporativo

O modelo de segurança do laboratório e do ambiente corporativo da Atlas Engineering deve preservar as seguintes garantias:

1. a Versão 1 é um laboratório controlado de treinamento e validação, e não um ambiente corporativo de produção;
2. as restrições físicas do laboratório não redefinem os limites lógicos de segurança;
3. a co-localização física não justifica identidades, credenciais, permissões ou conectividade irrestritas;
4. a execução por um único operador não elimina a separação lógica de responsabilidades;
5. os mecanismos de identidade do laboratório permanecem distinguíveis das capacidades corporativas de identidade;
6. o tratamento de segredos no laboratório não é representado como equivalente ao gerenciamento centralizado de segredos corporativos;
7. a rede do laboratório preserva limites lógicos de comunicação mesmo quando a segmentação física completa não está disponível;
8. a criptografia é afirmada somente quando o mecanismo implementado tiver sido validado;
9. dados sintéticos são preferidos a dados reais de clientes em produção para a validação de privacidade no laboratório;
10. comportamentos técnicos que oferecem suporte à privacidade não são representados como conformidade legal;
11. a auditabilidade do laboratório permanece distinguível das capacidades corporativas de SIEM e Operações de Segurança;
12. testes controlados de incidentes não representam maturidade completa de resposta a incidentes corporativos;
13. a validação de segurança do laboratório não implica disponibilidade, redundância ou escala corporativas;
14. mecanismos corporativos podem fortalecer identidade, segredos, rede, criptografia, observabilidade, governança e separação de responsabilidades;
15. ambientes corporativos podem exigir maior separação entre ambientes e dependências de segurança;
16. os mecanismos de controle podem mudar enquanto o requisito lógico de segurança subjacente permanece estável;
17. a evolução corporativa deve fortalecer, e não contornar, os limites de segurança existentes;
18. a arquitetura de segurança permanece portável entre diferentes mecanismos de implementação;
19. as evidências do laboratório identificam as condições sob as quais o comportamento foi demonstrado;
20. as afirmações de segurança e governança permanecem proporcionais às evidências;
21. controles corporativos não implementados são documentados como lacunas explícitas ou pontos de evolução, em vez de serem silenciosamente presumidos;
22. o teatro de segurança é evitado em favor de controles significativos, implementados e validados;
23. as evidências do laboratório orientam, mas não substituem, a validação específica do ambiente corporativo;
24. evoluções corporativas significativas de segurança são documentadas por meio de decisões arquiteturais quando apropriado.

---

## 19. Garantias de Segurança e Governança

A Atlas Engineering define segurança e governança como propriedades arquiteturais que devem permanecer válidas entre sistemas de origem, ingestão, transporte de eventos, armazenamento, transformação, certificação, consumo analítico, operações, recuperação e evolução futura da plataforma.

As garantias detalhadas definidas ao longo deste documento permanecem autoritativas em seus respectivos domínios.

Este capítulo consolida as principais garantias no nível da plataforma sem substituir esses requisitos detalhados.

### 19.1 Identidade e Acesso

Identidades humanas, de serviço e administrativas devem permanecer distinguíveis quando tecnicamente suportado.

O acesso segue responsabilidade explícita, propósito, autorização e privilégio mínimo.

Uma autenticação bem-sucedida não implica acesso irrestrito.

### 19.2 Negar por Padrão

O acesso é negado, a menos que seja explicitamente concedido para uma responsabilidade definida.

Conectividade técnica, posse de credenciais ou acessibilidade da plataforma não estabelecem, de forma independente, autorização.

O acesso necessário deve ser bem-sucedido e o acesso proibido deve ser negado quando houver suporte à aplicação desses controles.

### 19.3 Isolamento de Serviços

Responsabilidades independentes da plataforma não devem depender de uma única identidade técnica compartilhada e irrestrita.

Identidades de serviço, credenciais, permissões e caminhos de comunicação devem permanecer isolados de acordo com a responsabilidade, sempre que possível.

O comprometimento de um serviço não deve conceder automaticamente privilégios não relacionados na plataforma.

### 19.4 Proteção de Segredos

Segredos reais devem permanecer fora das configurações comuns mantidas no controle de versão, da documentação, dos *logs* e das evidências públicas.

A exposição invalida a confiança na credencial afetada até que ocorra revogação, substituição ou remediação apropriada.

A disponibilidade histórica de uma credencial não restaura sua confiança.

### 19.5 Limites de Confiança Explícitos

A comunicação entre serviços, camadas, ambientes e consumidores atravessa limites de confiança explícitos.

Posicionamento interno, co-localização física ou implantação local não estabelecem automaticamente confiança.

Cada relação deve ser avaliada de acordo com seus requisitos de autenticação, autorização, exposição e proteção.

### 19.6 Exposição Controlada de Rede

Os serviços da plataforma expõem somente a conectividade necessária para suas responsabilidades.

Serviços fundamentais de processamento, armazenamento e administração não devem receber exposição externa desnecessária.

A comunicação administrativa permanece distinta do processamento rotineiro e do consumo analítico.

### 19.7 Proteção de Dados ao Longo do Ciclo de Vida

A proteção de dados se aplica desde a origem operacional, passando por ingestão, processamento, armazenamento, publicação, *backup*, arquivamento e recuperação, até o descarte.

A criptografia complementa, mas não substitui:

- autorização;
- privilégio mínimo;
- minimização;
- privacidade;
- governança de retenção;
- descarte seguro.

### 19.8 Minimização de Dados

A disponibilidade dos dados na origem não justifica sua propagação *downstream*.

Os dados devem ser processados, retidos e expostos somente quando necessários para um propósito definido.

Quando informações sensíveis forem desnecessárias, evitar sua propagação é preferível a proteger uma cópia desnecessária.

### 19.9 Classificação de Dados

O modelo inicial de classificação permanece:

1. Público
2. Interno
3. Confidencial
4. Restrito

A classificação deve influenciar o tratamento efetivo dos dados.

Informações não classificadas não devem ser automaticamente tratadas como Públicas.

### 19.10 Dados Pessoais e Privacidade

A condição de dado pessoal permanece distinta da classificação geral de segurança.

Os requisitos de privacidade se aplicam às camadas intermediárias, históricas e voltadas aos consumidores.

Controles técnicos de privacidade dão suporte aos requisitos aplicáveis, mas não estabelecem, de forma independente, conformidade legal com a LGPD.

### 19.11 Privacidade por Design

A privacidade deve ser avaliada quando novos eventos, conjuntos de dados, fluxos de processamento e produtos analíticos forem projetados.

Quando um propósito aprovado puder ser atendido com menos informações de identificação, a representação com menor capacidade de identificação deve ser preferida.

### 19.12 Acesso Baseado em Camadas

Origem, CDC, Kafka, Bronze, Silver, Gold, Certified Gold, observabilidade, quarentena, *backups* e recursos administrativos permanecem limites de acesso distintos.

Os consumidores devem utilizar a representação governada de menor risco que atenda ao seu propósito.

O consumo analítico comum ocorre por meio da Certified Gold, em vez de exigir acesso *upstream* desnecessário.

### 19.13 Separação entre Dados Candidatos e Certificados

O estado das candidatas da Gold permanece distinto da Certified Gold.

A conclusão do processamento não implica certificação.

Certificação, publicação e consumo analítico permanecem responsabilidades e limites de acesso separados.

### 19.14 Governança das Definições

*Schemas*, contratos, definições de processamento, regras de qualidade e reconciliação, classificações, metadados, políticas de retenção e contratos de consumo são ativos governados.

Alterações relevantes devem permanecer identificáveis, possuir responsáveis, ser revisáveis e rastreáveis.

### 19.15 Governança de Contratos

Os contratos de eventos permanecem distintos dos *schemas* físicos da origem.

A compatibilidade estrutural não estabelece, de forma independente, compatibilidade semântica.

Alterações incompatíveis exigem migração explícita, em vez da redefinição silenciosa do contrato.

### 19.16 Separação de Versões

Dimensões independentes de versão devem permanecer distinguíveis quando necessário para reprodutibilidade e linhagem.

Elas podem incluir:

- *schema* da origem;
- contrato de evento;
- processamento da Silver;
- processamento da Gold;
- regras de qualidade;
- produto certificado.

Uma única versão genérica não deve ocultar definições que evoluem independentemente.

### 19.17 Metadados e Linhagem

Metadados e linhagem são ativos governados da plataforma.

A plataforma deve permanecer capaz de explicar:

**Origem → Movimentação → Transformação → Versão → Certificação → Consumo**

Os metadados necessários para interpretação devem permanecer disponíveis enquanto os dados governados continuarem dependendo deles.

### 19.18 Governança da Qualidade e Certificação

O sucesso do processamento não implica correção dos dados nem certificação.

Validação de qualidade, reconciliação, certificação, publicação e disponibilidade aos consumidores permanecem estados distintos.

Candidatas que falhem em controles bloqueadores não devem substituir a última publicação governada reconhecidamente confiável.

### 19.19 Governança de Retenção

A retenção é governada pelo propósito e pelos requisitos aplicáveis, em vez dos padrões das tecnologias ou da capacidade disponível.

Diferentes camadas podem legitimamente reter informações por períodos distintos.

A preservação indefinida não é o padrão.

### 19.20 Governança de Arquivamento

Dados arquivados continuam sendo dados governados.

Responsabilidades de classificação, privacidade, acesso, criptografia, linhagem, retenção e descarte continuam aplicáveis após o arquivamento.

Um arquivo é uma fonte válida de recuperação somente quando permanece interpretável, protegido e restaurável.

### 19.21 Governança de Descarte

O descarte deve considerar todas as cópias governadas relevantes, incluindo armazenamento ativo, camadas históricas, *backups*, arquivos, exportações e fontes de recuperação.

A exclusão lógica e o descarte físico permanecem distintos.

Decisões posteriores de governança não devem ser silenciosamente revertidas por meio de recuperação ou *replay*.

### 19.22 Auditabilidade

Atividades relevantes para a segurança devem permanecer atribuíveis quando tecnicamente suportado.

A auditabilidade deve fornecer contexto suficiente para responsabilização sem expor desnecessariamente segredos ou informações pessoais.

### 19.23 Observabilidade de Segurança

O comportamento de segurança deve permanecer observável por meio de *logs*, métricas, eventos de auditoria, *dashboards*, alertas ou mecanismos equivalentes apropriados, quando implementados.

A observabilidade deve dar suporte à detecção e à investigação sem se tornar um repositório não controlado de dados sensíveis.

### 19.24 Tratamento de Incidentes de Segurança

Incidentes de segurança exigem:

**Detecção → Contenção → Investigação → Remediação → Recuperação → Validação**

Um comprometimento ativo pode exigir contenção antes que a investigação completa esteja disponível.

A recuperação deve restaurar a confiança, e não apenas a disponibilidade do serviço.

### 19.25 Último Estado Reconhecidamente Confiável

A recuperação de segurança distingue:

**Último Estado Bem-Sucedido**

de:

**Último Estado Reconhecidamente Confiável**

Um estado tecnicamente bem-sucedido produzido sob confiança comprometida ou invalidada não deve se tornar automaticamente a linha de base da recuperação.

### 19.26 A Recuperação Não Restaura Confiança Invalidada

A regra governante é:

**A Recuperação Pode Restaurar o Estado Técnico — Ela Não Deve Restaurar Confiança Invalidada**

Credenciais revogadas, chaves comprometidas, permissões inválidas, estados inválidos em relação à privacidade e configurações de segurança retiradas de uso não se tornam confiáveis novamente apenas porque existem em uma fonte histórica de recuperação.

### 19.27 A Recuperação Preserva a Governança

*Replay*, restauração, *rebuild*, *rollback* e recuperação de desastre permanecem sujeitos aos requisitos atuais de:

- autenticação;
- autorização;
- qualidade;
- reconciliação;
- certificação;
- privacidade;
- retenção;
- auditabilidade.

Privilégios temporários de recuperação não devem se tornar acessos rotineiros permanentes.

### 19.28 Funções e Responsabilidades

As responsabilidades de segurança e governança permanecem logicamente distinguíveis entre:

- Engenharia de Dados;
- DBA;
- Plataforma / SRE;
- Segurança;
- Governança de Dados;
- Privacidade / Jurídico;
- Responsabilidade pelos Dados de Negócio;
- BI / Analytics;
- Consumo de Dados.

A Versão 1 pode consolidar essas responsabilidades sob um único operador sem eliminar sua separação arquitetural.

### 19.29 Responsabilidade e Privilégio

O privilégio técnico segue a responsabilidade, e não senioridade, conveniência ou hábito de *troubleshooting*.

A importância organizacional não justifica automaticamente acesso irrestrito.

Lacunas de responsabilidade e autoridade de decisão pouco clara permanecem riscos de governança.

### 19.30 Validação

Os controles de segurança e governança devem ser validados de acordo com seus mecanismos reais de aplicação.

Quando aplicável:

**Comportamento Autorizado → PERMITIDO**

**Comportamento Proibido → NEGADO**

A simples existência da configuração não comprova o controle.

### 19.31 Evidências

Os controles validados devem produzir evidências suficientes para relacionar:

**Requisito → Implementação → Teste → Observação → Conclusão**

As evidências devem preservar o contexto sem expor as informações que o controle pretende proteger.

### 19.32 Evidências Negativas

Um teste com falha permanece uma evidência válida.

Comportamentos inesperados devem levar a:

**Investigação → Causa Raiz → Decisão → Remediação → Revalidação**

A expectativa governada não deve ser reescrita apenas para produzir artificialmente um PASS.

### 19.33 Drift

A divergência entre o estado pretendido e o estado implementado é uma questão de governança.

Formas relevantes incluem:

- *access drift*;
- *metadata drift*;
- *contract drift*;
- *quality-rule drift*;
- *retention drift*;
- *certified-product drift*;
- *security-configuration drift*.

Sempre que possível, o estado implementado deve permanecer comparável ao estado governado esperado.

### 19.34 Documentação

A documentação faz parte da arquitetura governada.

Arquitetura, padrões, contratos, metadados, implementação, testes e evidências não devem contradizer uns aos outros conscientemente.

Alterações relevantes exigem revisão da documentação afetada.

### 19.35 Limite do Laboratório

A Versão 1 é um laboratório de treinamento, validação e portfólio.

Ela demonstra comportamentos representativos de segurança e governança sob condições controladas.

As limitações do laboratório podem simplificar a aplicação física dos controles, mas não redefinem a arquitetura lógica.

### 19.36 Evolução para o Ambiente Corporativo

Implementações corporativas podem substituir ou fortalecer os mecanismos do laboratório por meio de capacidades como identidade centralizada, gerenciamento de segredos, acesso privilegiado, segmentação de rede, gerenciamento de chaves, SIEM, *policy-as-code*, governança automatizada e maior separação de responsabilidades.

Os mecanismos de implementação podem evoluir enquanto as propriedades subjacentes de segurança e governança permanecem estáveis.

### 19.37 Afirmações Limitadas pelas Evidências

A Atlas Engineering distingue controles que estão:

**Documentados**

**Implementados**

**Testados**

**Observados**

**Sustentados por Evidências**

Nenhuma afirmação sobre segurança, privacidade, governança, prontidão corporativa ou conformidade pode exceder a implementação e as evidências que a sustentam.

A prontidão do laboratório para evolução corporativa não deve ser representada como uma capacidade corporativa já implementada.

### 19.38 Princípio de Encerramento

Segurança e governança são bem-sucedidas quando a plataforma consegue demonstrar que:

- o processamento autorizado funciona;
- comportamentos não autorizados são restringidos;
- informações sensíveis são minimizadas e protegidas;
- alterações são governadas;
- ações são atribuíveis;
- dados retidos permanecem interpretáveis;
- a recuperação preserva a confiança atual;
- consumidores analíticos recebem dados governados;
- os controles podem ser validados;
- as afirmações são sustentadas por evidências.

O princípio governante da Atlas Engineering é:

**Proteger o que é Necessário → Expor Somente o que é Autorizado → Governar o que Muda → Preservar o que Deve Ser Explicado → Validar o que é Afirmado**