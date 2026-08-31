# Atlas Engineering — Confiabilidade e Recuperação

## Índice

- [1. Propósito](#1-propósito)

- [2. Contexto de Confiabilidade e Recuperação](#2-contexto-de-confiabilidade-e-recuperação)
    - [2.1 Falha como Condição Esperada](#21-falha-como-condição-esperada)
    - [2.2 Confiabilidade](#22-confiabilidade)
    - [2.3 Recuperação](#23-recuperação)
    - [2.4 A Recuperação Considera o Estado](#24-a-recuperação-considera-o-estado)
    - [2.5 Propagação de Falhas](#25-propagação-de-falhas)
    - [2.6 Falha Parcial](#26-falha-parcial)
    - [2.7 Estado Durável](#27-estado-durável)
    - [2.8 Estado Derivado](#28-estado-derivado)
    - [2.9 Recuperação e Correção dos Dados](#29-recuperação-e-correção-dos-dados)
    - [2.10 Recuperação e Publicação Governada](#210-recuperação-e-publicação-governada)
    - [2.11 Recuperação e Interpretação Histórica](#211-recuperação-e-interpretação-histórica)
    - [2.12 Recuperação e Observabilidade](#212-recuperação-e-observabilidade)
    - [2.13 Recuperação e Segurança](#213-recuperação-e-segurança)
    - [2.14 Recuperação e Evidências](#214-recuperação-e-evidências)
    - [2.15 Princípio do Contexto de Confiabilidade](#215-princípio-do-contexto-de-confiabilidade)

- [3. Princípios de Confiabilidade](#3-princípios-de-confiabilidade)
    - [3.1 Falha É Esperada](#31-falha-é-esperada)
    - [3.2 Preservar Antes de Avançar](#32-preservar-antes-de-avançar)
    - [3.3 Capacidade de Reinicialização](#33-capacidade-de-reinicialização)
    - [3.4 Idempotência](#34-idempotência)
    - [3.5 A Entrega *At-Least-Once* Não É um Defeito](#35-a-entrega-at-least-once-não-é-um-defeito)
    - [3.6 Nenhuma Perda Silenciosa de Dados](#36-nenhuma-perda-silenciosa-de-dados)
    - [3.7 Nenhuma Corrupção Silenciosa](#37-nenhuma-corrupção-silenciosa)
    - [3.8 Estado Durável Antes do Estado Efêmero](#38-estado-durável-antes-do-estado-efêmero)
    - [3.9 A Recuperação Usa Progresso Explícito](#39-a-recuperação-usa-progresso-explícito)
    - [3.10 A Fonte de Recuperação Deve Ser Confiável](#310-a-fonte-de-recuperação-deve-ser-confiável)
    - [3.11 A Recuperação Deve Usar o Limite Apropriado](#311-a-recuperação-deve-usar-o-limite-apropriado)
    - [3.12 O Estado Derivado Deve Ser Reconstruível](#312-o-estado-derivado-deve-ser-reconstruível)
    - [3.13 Isolamento de Falhas](#313-isolamento-de-falhas)
    - [3.14 *Backpressure* É Preferível à Perda Não Controlada](#314-backpressure-é-preferível-à-perda-não-controlada)
    - [3.15 Novas Tentativas Devem Ser Limitadas e Observáveis](#315-novas-tentativas-devem-ser-limitadas-e-observáveis)
    - [3.16 A Recuperação Não Deve Ignorar a Governança](#316-a-recuperação-não-deve-ignorar-a-governança)
    - [3.17 A Publicação Deve Falhar com Segurança](#317-a-publicação-deve-falhar-com-segurança)
    - [3.18 A Recuperação Deve Ser Observável](#318-a-recuperação-deve-ser-observável)
    - [3.19 A Recuperação Deve Ser Validada](#319-a-recuperação-deve-ser-validada)
    - [3.20 A Recuperação Deve Ser Baseada em Evidências](#320-a-recuperação-deve-ser-baseada-em-evidências)
    - [3.21 Confiabilidade Não É Igual a Alta Disponibilidade](#321-confiabilidade-não-é-igual-a-alta-disponibilidade)
    - [3.22 Os Objetivos de Recuperação Devem Ser Medidos](#322-os-objetivos-de-recuperação-devem-ser-medidos)
    - [3.23 A Confiabilidade Evolui com as Evidências](#323-a-confiabilidade-evolui-com-as-evidências)
    - [3.24 Princípio de Confiabilidade](#324-princípio-de-confiabilidade)

- [4. Domínios de Falha e Classificação de Falhas](#4-domínios-de-falha-e-classificação-de-falhas)
    - [4.1 Domínio de Falha](#41-domínio-de-falha)
    - [4.2 Escopo da Falha](#42-escopo-da-falha)
    - [4.3 Falha Transitória](#43-falha-transitória)
    - [4.4 Falha Persistente](#44-falha-persistente)
    - [4.5 Falha Específica de Dados](#45-falha-específica-de-dados)
    - [4.6 Falha de Processamento](#46-falha-de-processamento)
    - [4.7 Falha de Dependência](#47-falha-de-dependência)
    - [4.8 Falha da Origem](#48-falha-da-origem)
    - [4.9 Falha do CDC](#49-falha-do-cdc)
    - [4.10 Falha do Debezium](#410-falha-do-debezium)
    - [4.11 Falha do Kafka](#411-falha-do-kafka)
    - [4.12 Falha da Bronze](#412-falha-da-bronze)
    - [4.13 Falha da Silver](#413-falha-da-silver)
    - [4.14 Falha da Gold](#414-falha-da-gold)
    - [4.15 Falha de Certificação](#415-falha-de-certificação)
    - [4.16 Falha de Publicação](#416-falha-de-publicação)
    - [4.17 Falha de Orquestração](#417-falha-de-orquestração)
    - [4.18 Falha de Armazenamento](#418-falha-de-armazenamento)
    - [4.19 Falha de Rede](#419-falha-de-rede)
    - [4.20 Falha de Credencial e Autenticação](#420-falha-de-credencial-e-autenticação)
    - [4.21 Esgotamento de Recursos](#421-esgotamento-de-recursos)
    - [4.22 Falha de Configuração](#422-falha-de-configuração)
    - [4.23 Falha de Implantação](#423-falha-de-implantação)
    - [4.24 Falha de Qualidade de Dados](#424-falha-de-qualidade-de-dados)
    - [4.25 Falha de Reconciliação](#425-falha-de-reconciliação)
    - [4.26 Falha de Observabilidade](#426-falha-de-observabilidade)
    - [4.27 Falha Composta](#427-falha-composta)
    - [4.28 Falha em Cascata](#428-falha-em-cascata)
    - [4.29 Risco de Perda de Dados](#429-risco-de-perda-de-dados)
    - [4.30 Falha de Atualização](#430-falha-de-atualização)
    - [4.31 Falha de Correção](#431-falha-de-correção)
    - [4.32 Falha de Disponibilidade](#432-falha-de-disponibilidade)
    - [4.33 Falha de Recuperabilidade](#433-falha-de-recuperabilidade)
    - [4.34 Severidade da Falha](#434-severidade-da-falha)
    - [4.35 Registro de Classificação da Falha](#435-registro-de-classificação-da-falha)
    - [4.36 Princípio de Classificação de Falhas](#436-princípio-de-classificação-de-falhas)

- [5. Estado Durável e Limites de Recuperação](#5-estado-durável-e-limites-de-recuperação)
    - [5.1 Estado Durável](#51-estado-durável)
    - [5.2 Estado Efêmero](#52-estado-efêmero)
    - [5.3 Estado Autoritativo e Derivado](#53-estado-autoritativo-e-derivado)
    - [5.4 Persistência Não Comprova Completude](#54-persistência-não-comprova-completude)
    - [5.5 Persistência Não Comprova Confiabilidade](#55-persistência-não-comprova-confiabilidade)
    - [5.6 Limite de Recuperação](#56-limite-de-recuperação)
    - [5.7 Limite do Banco de Dados de Origem](#57-limite-do-banco-de-dados-de-origem)
    - [5.8 Limite do CDC](#58-limite-do-cdc)
    - [5.9 Limite do Kafka](#59-limite-do-kafka)
    - [5.10 Limite da Bronze](#510-limite-da-bronze)
    - [5.11 Limite da Silver](#511-limite-da-silver)
    - [5.12 Limite da Gold](#512-limite-da-gold)
    - [5.13 Limite da Certified Gold](#513-limite-da-certified-gold)
    - [5.14 Estado de Checkpoint](#514-estado-de-checkpoint)
    - [5.15 Metadados de Processamento](#515-metadados-de-processamento)
    - [5.16 Metadados de Versão](#516-metadados-de-versão)
    - [5.17 Linhagem como Contexto de Recuperação](#517-linhagem-como-contexto-de-recuperação)
    - [5.18 Limite de Backup](#518-limite-de-backup)
    - [5.19 Limite de Arquivamento](#519-limite-de-arquivamento)
    - [5.20 Hierarquia de Fontes de Recuperação](#520-hierarquia-de-fontes-de-recuperação)
    - [5.21 Seleção da Fonte de Recuperação](#521-seleção-da-fonte-de-recuperação)
    - [5.22 Janela de Recuperação](#522-janela-de-recuperação)
    - [5.23 Esgotamento da Janela de Recuperação](#523-esgotamento-da-janela-de-recuperação)
    - [5.24 Escalonamento do Limite de Recuperação](#524-escalonamento-do-limite-de-recuperação)
    - [5.25 Independência dos Limites](#525-independência-dos-limites)
    - [5.26 Recuperação e Domínios de Falha Compartilhados](#526-recuperação-e-domínios-de-falha-compartilhados)
    - [5.27 Recuperação e Definições Históricas](#527-recuperação-e-definições-históricas)
    - [5.28 Recuperação e Governança Atual](#528-recuperação-e-governança-atual)
    - [5.29 Validação do Limite de Recuperação](#529-validação-do-limite-de-recuperação)
    - [5.30 Estado Durável e Evidências de Recuperação](#530-estado-durável-e-evidências-de-recuperação)
    - [5.31 Garantias de Estado Durável e Limites de Recuperação](#531-garantias-de-estado-durável-e-limites-de-recuperação)

- [6. Checkpoints, Progresso e Capacidade de Reinicialização](#6-checkpoints-progresso-e-capacidade-de-reinicialização)
    - [6.1 Progresso do Processamento](#61-progresso-do-processamento)
    - [6.2 Checkpoint](#62-checkpoint)
    - [6.3 Consistência entre Checkpoint e Saída](#63-consistência-entre-checkpoint-e-saída)
    - [6.4 Limite de Confirmação](#64-limite-de-confirmação)
    - [6.5 Atomicidade entre Saída e Progresso](#65-atomicidade-entre-saída-e-progresso)
    - [6.6 Capacidade de Reinicialização](#66-capacidade-de-reinicialização)
    - [6.7 Reinicialização Limpa](#67-reinicialização-limpa)
    - [6.8 Reinicialização Não Limpa](#68-reinicialização-não-limpa)
    - [6.9 Reinicialização Não é Replay](#69-reinicialização-não-é-replay)
    - [6.10 Reinicialização Não é Reprocessamento](#610-reinicialização-não-é-reprocessamento)
    - [6.11 Reinicialização Não é Rebuild](#611-reinicialização-não-é-rebuild)
    - [6.12 Progresso do Consumidor Kafka](#612-progresso-do-consumidor-kafka)
    - [6.13 Progresso Específico de Partição](#613-progresso-específico-de-partição)
    - [6.14 Progresso do CDC e Debezium](#614-progresso-do-cdc-e-debezium)
    - [6.15 Progresso da Bronze](#615-progresso-da-bronze)
    - [6.16 Progresso da Silver](#616-progresso-da-silver)
    - [6.17 Progresso da Gold](#617-progresso-da-gold)
    - [6.18 Progresso da Certificação](#618-progresso-da-certificação)
    - [6.19 Progresso da Orquestração](#619-progresso-da-orquestração)
    - [6.20 Interação entre Nova Tentativa e Checkpoint](#620-interação-entre-nova-tentativa-e-checkpoint)
    - [6.21 Interação entre Backlog e Checkpoint](#621-interação-entre-backlog-e-checkpoint)
    - [6.22 Corrupção ou Perda de Checkpoint](#622-corrupção-ou-perda-de-checkpoint)
    - [6.23 Redefinição de Checkpoint](#623-redefinição-de-checkpoint)
    - [6.24 Lacunas de Processamento](#624-lacunas-de-processamento)
    - [6.25 Processamento Duplicado](#625-processamento-duplicado)
    - [6.26 Monotonicidade do Progresso](#626-monotonicidade-do-progresso)
    - [6.27 Progresso Independente](#627-progresso-independente)
    - [6.28 Progresso e Atualidade](#628-progresso-e-atualidade)
    - [6.29 Validação da Reinicialização](#629-validação-da-reinicialização)
    - [6.30 Evidências de Reinicialização](#630-evidências-de-reinicialização)
    - [6.31 Garantias de Checkpoint e Capacidade de Reinicialização](#631-garantias-de-checkpoint-e-capacidade-de-reinicialização)

- [7. Novas Tentativas e Nova Entrega](#7-novas-tentativas-e-nova-entrega)
    - [7.1 Objetivo das Novas Tentativas](#71-objetivo-das-novas-tentativas)
    - [7.2 Falhas que Permitem e que Não Permitem Nova Tentativa](#72-falhas-que-permitem-e-que-não-permitem-nova-tentativa)
    - [7.3 Nova Tentativa Limitada](#73-nova-tentativa-limitada)
    - [7.4 Intervalo entre Novas Tentativas](#74-intervalo-entre-novas-tentativas)
    - [7.5 Backoff](#75-backoff)
    - [7.6 Jitter](#76-jitter)
    - [7.7 Tempestade de Novas Tentativas](#77-tempestade-de-novas-tentativas)
    - [7.8 Nova Tentativa e Idempotência](#78-nova-tentativa-e-idempotência)
    - [7.9 Nova Tentativa e Checkpoint](#79-nova-tentativa-e-checkpoint)
    - [7.10 Nova Entrega](#710-nova-entrega)
    - [7.11 Identificação de Nova Entrega](#711-identificação-de-nova-entrega)
    - [7.12 Entrega Duplicada e Efeito de Negócio Duplicado](#712-entrega-duplicada-e-efeito-de-negócio-duplicado)
    - [7.13 Esgotamento das Novas Tentativas](#713-esgotamento-das-novas-tentativas)
    - [7.14 Transição para Falha Persistente](#714-transição-para-falha-persistente)
    - [7.15 Interação com Registros Problemáticos](#715-interação-com-registros-problemáticos)
    - [7.16 Nova Tentativa e Progresso da Partição](#716-nova-tentativa-e-progresso-da-partição)
    - [7.17 Nova Tentativa e Isolamento de Falhas](#717-nova-tentativa-e-isolamento-de-falhas)
    - [7.18 Recuperação de Dependência](#718-recuperação-de-dependência)
    - [7.19 Comportamento de Circuit Breaking](#719-comportamento-de-circuit-breaking)
    - [7.20 Nova Tentativa e Backpressure](#720-nova-tentativa-e-backpressure)
    - [7.21 Nova Tentativa e Janelas de Retenção](#721-nova-tentativa-e-janelas-de-retenção)
    - [7.22 Nova Tentativa e Credenciais](#722-nova-tentativa-e-credenciais)
    - [7.23 Nova Tentativa e Limites de Taxa](#723-nova-tentativa-e-limites-de-taxa)
    - [7.24 Nova Tentativa e Orquestração](#724-nova-tentativa-e-orquestração)
    - [7.25 Nova Tentativa e Processamento em Lote](#725-nova-tentativa-e-processamento-em-lote)
    - [7.26 Nova Tentativa e Geração de Candidata](#726-nova-tentativa-e-geração-de-candidata)
    - [7.27 Nova Tentativa Manual](#727-nova-tentativa-manual)
    - [7.28 Nova Tentativa Após Correção](#728-nova-tentativa-após-correção)
    - [7.29 Nova Entrega Após Recuperação](#729-nova-entrega-após-recuperação)
    - [7.30 Observabilidade das Novas Tentativas](#730-observabilidade-das-novas-tentativas)
    - [7.31 Observabilidade das Novas Entregas](#731-observabilidade-das-novas-entregas)
    - [7.32 Alertas de Nova Tentativa](#732-alertas-de-nova-tentativa)
    - [7.33 Validação da Recuperação por Novas Tentativas](#733-validação-da-recuperação-por-novas-tentativas)
    - [7.34 Evidências de Novas Tentativas](#734-evidências-de-novas-tentativas)
    - [7.35 Garantias de Novas Tentativas e Novas Entregas](#735-garantias-de-novas-tentativas-e-novas-entregas)

- [8. Estratégia de Fontes de Recuperação](#8-estratégia-de-fontes-de-recuperação)
    - [8.1 Objetivos da Fonte de Recuperação](#81-objetivos-da-fonte-de-recuperação)
    - [8.2 Elegibilidade da Fonte de Recuperação](#82-elegibilidade-da-fonte-de-recuperação)
    - [8.3 Princípio da Fonte de Recuperação Preferencial](#83-princípio-da-fonte-de-recuperação-preferencial)
    - [8.4 Hierarquia das Fontes de Recuperação](#84-hierarquia-das-fontes-de-recuperação)
    - [8.5 Kafka como Fonte de Recuperação](#85-kafka-como-fonte-de-recuperação)
    - [8.6 Limitações da Recuperação pelo Kafka](#86-limitações-da-recuperação-pelo-kafka)
    - [8.7 Bronze como Fonte de Recuperação](#87-bronze-como-fonte-de-recuperação)
    - [8.8 Limitações da Recuperação pela Bronze](#88-limitações-da-recuperação-pela-bronze)
    - [8.9 Silver como Fonte de Recuperação](#89-silver-como-fonte-de-recuperação)
    - [8.10 Limitações da Recuperação pela Silver](#810-limitações-da-recuperação-pela-silver)
    - [8.11 Gold como Fonte de Recuperação](#811-gold-como-fonte-de-recuperação)
    - [8.12 Certified Gold como Fonte de Recuperação](#812-certified-gold-como-fonte-de-recuperação)
    - [8.13 AtlasCommerce como Fonte de Recuperação](#813-atlascommerce-como-fonte-de-recuperação)
    - [8.14 Estado Atual da Fonte versus Eventos Históricos](#814-estado-atual-da-fonte-versus-eventos-históricos)
    - [8.15 *Backfill* Controlado](#815-backfill-controlado)
    - [8.16 Backup como Fonte de Recuperação](#816-backup-como-fonte-de-recuperação)
    - [8.17 Backup não é Replay](#817-backup-não-é-replay)
    - [8.18 Arquivo como Fonte de Recuperação](#818-arquivo-como-fonte-de-recuperação)
    - [8.19 Independência da Fonte de Recuperação](#819-independência-da-fonte-de-recuperação)
    - [8.20 Confiabilidade da Fonte de Recuperação](#820-confiabilidade-da-fonte-de-recuperação)
    - [8.21 Último Estado Bem-Sucedido versus Último Estado Conhecido como Confiável](#821-último-estado-bem-sucedido-versus-último-estado-conhecido-como-confiável)
    - [8.22 Fonte de Recuperação e Localização do Defeito](#822-fonte-de-recuperação-e-localização-do-defeito)
    - [8.23 Fonte de Recuperação e Compatibilidade de Versão](#823-fonte-de-recuperação-e-compatibilidade-de-versão)
    - [8.24 Recuperação com Lógica Atual](#824-recuperação-com-lógica-atual)
    - [8.25 Recuperação com Lógica Histórica](#825-recuperação-com-lógica-histórica)
    - [8.26 Fonte de Recuperação e Classificação de Dados](#826-fonte-de-recuperação-e-classificação-de-dados)
    - [8.27 Fonte de Recuperação e Retenção](#827-fonte-de-recuperação-e-retenção)
    - [8.28 Fonte de Recuperação e RPO](#828-fonte-de-recuperação-e-rpo)
    - [8.29 Fonte de Recuperação e RTO](#829-fonte-de-recuperação-e-rto)
    - [8.30 Escalonamento da Fonte de Recuperação](#830-escalonamento-da-fonte-de-recuperação)
    - [8.31 Registro da Decisão sobre a Fonte de Recuperação](#831-registro-da-decisão-sobre-a-fonte-de-recuperação)
    - [8.32 Validação da Fonte de Recuperação](#832-validação-da-fonte-de-recuperação)
    - [8.33 Evidências da Fonte de Recuperação](#833-evidências-da-fonte-de-recuperação)
    - [8.34 Garantias da Estratégia de Fontes de Recuperação](#834-garantias-da-estratégia-de-fontes-de-recuperação)

- [9. Replay](#9-replay)
    - [9.1 Objetivo do Replay](#91-objetivo-do-replay)
    - [9.2 Fonte do Replay](#92-fonte-do-replay)
    - [9.3 Limite Inicial do Replay](#93-limite-inicial-do-replay)
    - [9.4 Limite Final do Replay](#94-limite-final-do-replay)
    - [9.5 Replay versus Reinicialização](#95-replay-versus-reinicialização)
    - [9.6 Replay versus Nova Tentativa](#96-replay-versus-nova-tentativa)
    - [9.7 Replay versus Reprocessamento](#97-replay-versus-reprocessamento)
    - [9.8 Replay versus Backfill](#98-replay-versus-backfill)
    - [9.9 Replay versus Rebuild](#99-replay-versus-rebuild)
    - [9.10 Replay e Processamento At-Least-Once](#910-replay-e-processamento-at-least-once)
    - [9.11 Replay e Idempotência](#911-replay-e-idempotência)
    - [9.12 Replay e Saída Existente](#912-replay-e-saída-existente)
    - [9.13 Replay e Offsets Kafka](#913-replay-e-offsets-kafka)
    - [9.14 Estratégia do Consumidor de Replay](#914-estratégia-do-consumidor-de-replay)
    - [9.15 Replay e Processamento em Tempo Real](#915-replay-e-processamento-em-tempo-real)
    - [9.16 Ordenação do Replay](#916-ordenação-do-replay)
    - [9.17 Escopo do Replay](#917-escopo-do-replay)
    - [9.18 Replay e Dependências](#918-replay-e-dependências)
    - [9.19 Replay e Contratos Históricos](#919-replay-e-contratos-históricos)
    - [9.20 Replay e Versões de Processamento](#920-replay-e-versões-de-processamento)
    - [9.21 Replay e Evolução de Schema](#921-replay-e-evolução-de-schema)
    - [9.22 Replay e Estado da Fonte Excluído ou Alterado](#922-replay-e-estado-da-fonte-excluído-ou-alterado)
    - [9.23 Replay e Bronze](#923-replay-e-bronze)
    - [9.24 Replay e Silver](#924-replay-e-silver)
    - [9.25 Replay e Gold](#925-replay-e-gold)
    - [9.26 Replay e Certified Gold](#926-replay-e-certified-gold)
    - [9.27 Replay e Checkpoints](#927-replay-e-checkpoints)
    - [9.28 Replay e Grupos de Consumidores](#928-replay-e-grupos-de-consumidores)
    - [9.29 Replay e Retenção](#929-replay-e-retenção)
    - [9.30 Esgotamento da Janela de Replay](#930-esgotamento-da-janela-de-replay)
    - [9.31 Replay e Backlog](#931-replay-e-backlog)
    - [9.32 Limitação de Velocidade do Replay](#932-limitação-de-velocidade-do-replay)
    - [9.33 Falha no Replay](#933-falha-no-replay)
    - [9.34 Cancelamento do Replay](#934-cancelamento-do-replay)
    - [9.35 Validação do Replay](#935-validação-do-replay)
    - [9.36 Evidências do Replay](#936-evidências-do-replay)
    - [9.37 Cenários de Teste de Replay](#937-cenários-de-teste-de-replay)
    - [9.38 Garantias do Replay](#938-garantias-do-replay)

- [10. Reprocessamento](#10-reprocessamento)
    - [10.1 Propósito do Reprocessamento](#101-propósito-do-reprocessamento)
    - [10.2 Reprocessamento versus Replay](#102-reprocessamento-versus-replay)
    - [10.3 Reprocessamento versus Reinicialização](#103-reprocessamento-versus-reinicialização)
    - [10.4 Reprocessamento versus Nova Tentativa](#104-reprocessamento-versus-nova-tentativa)
    - [10.5 Reprocessamento versus Backfill](#105-reprocessamento-versus-backfill)
    - [10.6 Reprocessamento versus Rebuild](#106-reprocessamento-versus-rebuild)
    - [10.7 Fonte de Reprocessamento](#107-fonte-de-reprocessamento)
    - [10.8 Escopo do Reprocessamento](#108-escopo-do-reprocessamento)
    - [10.9 Dependências do Escopo](#109-dependências-do-escopo)
    - [10.10 Reprocessamento com a Mesma Lógica](#1010-reprocessamento-com-a-mesma-lógica)
    - [10.11 Reprocessamento com Lógica Corrigida](#1011-reprocessamento-com-lógica-corrigida)
    - [10.12 Reprocessamento com Nova Lógica](#1012-reprocessamento-com-nova-lógica)
    - [10.13 Reprodução Histórica](#1013-reprodução-histórica)
    - [10.14 Reapresentação Histórica](#1014-reapresentação-histórica)
    - [10.15 Seleção da Versão de Reprocessamento](#1015-seleção-da-versão-de-reprocessamento)
    - [10.16 Reprocessamento e Determinismo](#1016-reprocessamento-e-determinismo)
    - [10.17 Reprocessamento e Tempo Atual](#1017-reprocessamento-e-tempo-atual)
    - [10.18 Reprocessamento e Dados de Referência](#1018-reprocessamento-e-dados-de-referência)
    - [10.19 Reprocessamento e Dimensões Lentamente Mutáveis](#1019-reprocessamento-e-dimensões-lentamente-mutáveis)
    - [10.20 Reprocessamento e Estado Existente](#1020-reprocessamento-e-estado-existente)
    - [10.21 Reprocessamento In-Place](#1021-reprocessamento-in-place)
    - [10.22 Reprocessamento Versionado](#1022-reprocessamento-versionado)
    - [10.23 Reprocessamento e Processamento Ativo](#1023-reprocessamento-e-processamento-ativo)
    - [10.24 Isolamento do Reprocessamento](#1024-isolamento-do-reprocessamento)
    - [10.25 Reprocessamento e Checkpoints](#1025-reprocessamento-e-checkpoints)
    - [10.26 Reprocessamento e Linhagem](#1026-reprocessamento-e-linhagem)
    - [10.27 Reprocessamento e Qualidade](#1027-reprocessamento-e-qualidade)
    - [10.28 Reprocessamento e Reconciliação](#1028-reprocessamento-e-reconciliação)
    - [10.29 Diferenças Esperadas](#1029-diferenças-esperadas)
    - [10.30 Reprocessamento e Certificação](#1030-reprocessamento-e-certificação)
    - [10.31 Falha de Reprocessamento](#1031-falha-de-reprocessamento)
    - [10.32 Falha Parcial de Reprocessamento](#1032-falha-parcial-de-reprocessamento)
    - [10.33 Cancelamento do Reprocessamento](#1033-cancelamento-do-reprocessamento)
    - [10.34 Impacto de Recursos do Reprocessamento](#1034-impacto-de-recursos-do-reprocessamento)
    - [10.35 Prioridade do Reprocessamento](#1035-prioridade-do-reprocessamento)
    - [10.36 Validação do Reprocessamento](#1036-validação-do-reprocessamento)
    - [10.37 Evidências de Reprocessamento](#1037-evidências-de-reprocessamento)
    - [10.38 Cenários de Teste de Reprocessamento](#1038-cenários-de-teste-de-reprocessamento)
    - [10.39 Garantias de Reprocessamento](#1039-garantias-de-reprocessamento)

- [11. Backfill](#11-backfill)
    - [11.1 Propósito do Backfill](#111-propósito-do-backfill)
    - [11.2 Backfill versus Replay](#112-backfill-versus-replay)
    - [11.3 Backfill versus Reprocessamento](#113-backfill-versus-reprocessamento)
    - [11.4 Backfill versus Rebuild](#114-backfill-versus-rebuild)
    - [11.5 Backfill versus Reinicialização e Nova Tentativa](#115-backfill-versus-reinicialização-e-nova-tentativa)
    - [11.6 Fonte de Backfill](#116-fonte-de-backfill)
    - [11.7 Backfill do AtlasCommerce](#117-backfill-do-atlascommerce)
    - [11.8 Backfill de Estado Atual](#118-backfill-de-estado-atual)
    - [11.9 Backfill Histórico](#119-backfill-histórico)
    - [11.10 Backfill de Snapshot](#1110-backfill-de-snapshot)
    - [11.11 Backfill de Eventos](#1111-backfill-de-eventos)
    - [11.12 Evento Original versus Evento Reconstruído](#1112-evento-original-versus-evento-reconstruído)
    - [11.13 Escopo do Backfill](#1113-escopo-do-backfill)
    - [11.14 Limite do Backfill](#1114-limite-do-backfill)
    - [11.15 Identificação da Lacuna](#1115-identificação-da-lacuna)
    - [11.16 Limites da Lacuna](#1116-limites-da-lacuna)
    - [11.17 Completude do Backfill](#1117-completude-do-backfill)
    - [11.18 Consistência do Backfill](#1118-consistência-do-backfill)
    - [11.19 Backfill e Alterações Concorrentes](#1119-backfill-e-alterações-concorrentes)
    - [11.20 Ponto de Corte do Backfill](#1120-ponto-de-corte-do-backfill)
    - [11.21 Backfill e Idempotência](#1121-backfill-e-idempotência)
    - [11.22 Backfill e Ordenação](#1122-backfill-e-ordenação)
    - [11.23 Backfill e Tempo do Evento](#1123-backfill-e-tempo-do-evento)
    - [11.24 Backfill e Schema](#1124-backfill-e-schema)
    - [11.25 Backfill e Versão de Contrato](#1125-backfill-e-versão-de-contrato)
    - [11.26 Proveniência do Backfill](#1126-proveniência-do-backfill)
    - [11.27 Backfill e Bronze](#1127-backfill-e-bronze)
    - [11.28 Backfill e Silver](#1128-backfill-e-silver)
    - [11.29 Backfill e Gold](#1129-backfill-e-gold)
    - [11.30 Backfill e Certified Gold](#1130-backfill-e-certified-gold)
    - [11.31 Backfill e Dimensões Históricas](#1131-backfill-e-dimensões-históricas)
    - [11.32 Backfill e Registros Excluídos](#1132-backfill-e-registros-excluídos)
    - [11.33 Backfill e Impacto na Origem](#1133-backfill-e-impacto-na-origem)
    - [11.34 Processamento do Backfill em Lotes](#1134-processamento-do-backfill-em-lotes)
    - [11.35 Capacidade de Reinicialização do Backfill](#1135-capacidade-de-reinicialização-do-backfill)
    - [11.36 Falha de Backfill](#1136-falha-de-backfill)
    - [11.37 Cancelamento de Backfill](#1137-cancelamento-de-backfill)
    - [11.38 Backfill e Segurança](#1138-backfill-e-segurança)
    - [11.39 Backfill e Retenção](#1139-backfill-e-retenção)
    - [11.40 Backfill e Linhagem](#1140-backfill-e-linhagem)
    - [11.41 Backfill e Reconciliação](#1141-backfill-e-reconciliação)
    - [11.42 Diferenças Esperadas do Backfill](#1142-diferenças-esperadas-do-backfill)
    - [11.43 Validação do Backfill](#1143-validação-do-backfill)
    - [11.44 Evidências de Backfill](#1144-evidências-de-backfill)
    - [11.45 Cenários de Teste de Backfill](#1145-cenários-de-teste-de-backfill)
    - [11.46 Garantias de Backfill](#1146-garantias-de-backfill)

- [12. Rebuild](#12-rebuild)
    - [12.1 Propósito do Rebuild](#121-propósito-do-rebuild)
    - [12.2 Rebuild versus Reinicialização](#122-rebuild-versus-reinicialização)
    - [12.3 Rebuild versus Nova Tentativa](#123-rebuild-versus-nova-tentativa)
    - [12.4 Rebuild versus Replay](#124-rebuild-versus-replay)
    - [12.5 Rebuild versus Reprocessamento](#125-rebuild-versus-reprocessamento)
    - [12.6 Rebuild versus Backfill](#126-rebuild-versus-backfill)
    - [12.7 Fonte do Rebuild](#127-fonte-do-rebuild)
    - [12.8 Escopo do Rebuild](#128-escopo-do-rebuild)
    - [12.9 Rebuild Completo](#129-rebuild-completo)
    - [12.10 Rebuild Parcial](#1210-rebuild-parcial)
    - [12.11 Análise de Dependências do Rebuild](#1211-análise-de-dependências-do-rebuild)
    - [12.12 Rebuild da Bronze](#1212-rebuild-da-bronze)
    - [12.13 Rebuild da Silver](#1213-rebuild-da-silver)
    - [12.14 Rebuild da Gold](#1214-rebuild-da-gold)
    - [12.15 Rebuild da Certified Gold](#1215-rebuild-da-certified-gold)
    - [12.16 Rebuild a Partir de Backup](#1216-rebuild-a-partir-de-backup)
    - [12.17 Rebuild e Versões Históricas](#1217-rebuild-e-versões-históricas)
    - [12.18 Reprodução Histórica Durante o Rebuild](#1218-reprodução-histórica-durante-o-rebuild)
    - [12.19 Restatement Histórico Durante o Rebuild](#1219-restatement-histórico-durante-o-rebuild)
    - [12.20 Estratégia de Destino do Rebuild](#1220-estratégia-de-destino-do-rebuild)
    - [12.21 Rebuild In-Place](#1221-rebuild-in-place)
    - [12.22 Shadow Rebuild](#1222-shadow-rebuild)
    - [12.23 Rebuild Versionado](#1223-rebuild-versionado)
    - [12.24 Rebuild e Processamento Ativo](#1224-rebuild-e-processamento-ativo)
    - [12.25 Ponto de Corte do Rebuild](#1225-ponto-de-corte-do-rebuild)
    - [12.26 Catch-Up do Rebuild](#1226-catch-up-do-rebuild)
    - [12.27 Rebuild e Idempotência](#1227-rebuild-e-idempotência)
    - [12.28 Progresso do Rebuild](#1228-progresso-do-rebuild)
    - [12.29 Capacidade de Reinicialização do Rebuild](#1229-capacidade-de-reinicialização-do-rebuild)
    - [12.30 Falha de Rebuild](#1230-falha-de-rebuild)
    - [12.31 Estado Parcial do Rebuild](#1231-estado-parcial-do-rebuild)
    - [12.32 Cancelamento de Rebuild](#1232-cancelamento-de-rebuild)
    - [12.33 Impacto do Rebuild sobre Recursos](#1233-impacto-do-rebuild-sobre-recursos)
    - [12.34 Controle de Taxa do Rebuild](#1234-controle-de-taxa-do-rebuild)
    - [12.35 Priorização do Rebuild](#1235-priorização-do-rebuild)
    - [12.36 Rebuild e Validação de Qualidade](#1236-rebuild-e-validação-de-qualidade)
    - [12.37 Rebuild e Reconciliação](#1237-rebuild-e-reconciliação)
    - [12.38 Rebuild e Certificação](#1238-rebuild-e-certificação)
    - [12.39 Rebuild e Rollback](#1239-rebuild-e-rollback)
    - [12.40 Rebuild e Linhagem](#1240-rebuild-e-linhagem)
    - [12.41 Rebuild e Metadados](#1241-rebuild-e-metadados)
    - [12.42 Rebuild e Segurança](#1242-rebuild-e-segurança)
    - [12.43 Rebuild e Retenção](#1243-rebuild-e-retenção)
    - [12.44 Rebuild e RPO](#1244-rebuild-e-rpo)
    - [12.45 Rebuild e RTO](#1245-rebuild-e-rto)
    - [12.46 Validação do Rebuild](#1246-validação-do-rebuild)
    - [12.47 Evidências de Rebuild](#1247-evidências-de-rebuild)
    - [12.48 Cenários de Teste de Rebuild](#1248-cenários-de-teste-de-rebuild)
    - [12.49 Garantias de Rebuild](#1249-garantias-de-rebuild)

- [13. Falha e Recuperação de Componentes](#13-falha-e-recuperação-de-componentes)
    - [13.1 Falha do AtlasCommerce](#131-falha-do-atlascommerce)
    - [13.2 Recuperação do AtlasCommerce](#132-recuperação-do-atlascommerce)
    - [13.3 Falha do CDC](#133-falha-do-cdc)
    - [13.4 Recuperação do CDC](#134-recuperação-do-cdc)
    - [13.5 Falha do Debezium](#135-falha-do-debezium)
    - [13.6 Recuperação do Debezium](#136-recuperação-do-debezium)
    - [13.7 Falha do Apicurio Registry](#137-falha-do-apicurio-registry)
    - [13.8 Recuperação do Apicurio Registry](#138-recuperação-do-apicurio-registry)
    - [13.9 Falha do Produtor Kafka](#139-falha-do-produtor-kafka)
    - [13.10 Falha do Broker Kafka](#1310-falha-do-broker-kafka)
    - [13.11 Recuperação do Kafka](#1311-recuperação-do-kafka)
    - [13.12 Falha de Consumidor Kafka](#1312-falha-de-consumidor-kafka)
    - [13.13 Recuperação de Consumidor Kafka](#1313-recuperação-de-consumidor-kafka)
    - [13.14 Falha do Processador Bronze](#1314-falha-do-processador-bronze)
    - [13.15 Recuperação do Processador Bronze](#1315-recuperação-do-processador-bronze)
    - [13.16 Falha do MinIO](#1316-falha-do-minio)
    - [13.17 Recuperação do MinIO](#1317-recuperação-do-minio)
    - [13.18 Perda do Armazenamento Bronze](#1318-perda-do-armazenamento-bronze)
    - [13.19 Falha do Processador Silver](#1319-falha-do-processador-silver)
    - [13.20 Recuperação do Processador Silver](#1320-recuperação-do-processador-silver)
    - [13.21 Perda do Armazenamento Silver](#1321-perda-do-armazenamento-silver)
    - [13.22 Falha do Processador Gold](#1322-falha-do-processador-gold)
    - [13.23 Recuperação do Processador Gold](#1323-recuperação-do-processador-gold)
    - [13.24 Falha do AtlasWarehouse](#1324-falha-do-atlaswarehouse)
    - [13.25 Recuperação do AtlasWarehouse](#1325-recuperação-do-atlaswarehouse)
    - [13.26 Falha de Controle de Qualidade](#1326-falha-de-controle-de-qualidade)
    - [13.27 Falha de Reconciliação](#1327-falha-de-reconciliação)
    - [13.28 Falha de Certificação](#1328-falha-de-certificação)
    - [13.29 Falha de Publicação](#1329-falha-de-publicação)
    - [13.30 Falha do Power BI](#1330-falha-do-power-bi)
    - [13.31 Recuperação do Power BI](#1331-recuperação-do-power-bi)
    - [13.32 Falha do Airflow](#1332-falha-do-airflow)
    - [13.33 Recuperação do Airflow](#1333-recuperação-do-airflow)
    - [13.34 Falha do Prometheus](#1334-falha-do-prometheus)
    - [13.35 Recuperação do Prometheus](#1335-recuperação-do-prometheus)
    - [13.36 Falha do Grafana](#1336-falha-do-grafana)
    - [13.37 Falha de Logging Estruturado](#1337-falha-de-logging-estruturado)
    - [13.38 Falha de Rede](#1338-falha-de-rede)
    - [13.39 Falha de Credencial](#1339-falha-de-credencial)
    - [13.40 Falha do Host](#1340-falha-do-host)
    - [13.41 Falha Completa do Laboratório](#1341-falha-completa-do-laboratório)
    - [13.42 Ordem das Dependências de Recuperação](#1342-ordem-das-dependências-de-recuperação)
    - [13.43 Cascata de Recuperação](#1343-cascata-de-recuperação)
    - [13.44 Validação da Recuperação de Componentes](#1344-validação-da-recuperação-de-componentes)
    - [13.45 Evidências de Recuperação de Componentes](#1345-evidências-de-recuperação-de-componentes)
    - [13.46 Garantias de Falha e Recuperação de Componentes](#1346-garantias-de-falha-e-recuperação-de-componentes)

- [14. Falha Parcial e Isolamento de Falhas](#14-falha-parcial-e-isolamento-de-falhas)
    - [14.1 Falha Parcial](#141-falha-parcial)
    - [14.2 Isolamento de Falhas](#142-isolamento-de-falhas)
    - [14.3 Isolamento e Análise de Dependências](#143-isolamento-e-análise-de-dependências)
    - [14.4 Isolamento no Nível de Registro](#144-isolamento-no-nível-de-registro)
    - [14.5 Isolamento no Nível de Evento](#145-isolamento-no-nível-de-evento)
    - [14.6 Isolamento no Nível de Partição](#146-isolamento-no-nível-de-partição)
    - [14.7 Isolamento no Nível de Entidade](#147-isolamento-no-nível-de-entidade)
    - [14.8 Isolamento no Nível de Lote](#148-isolamento-no-nível-de-lote)
    - [14.9 Isolamento no Nível de Conjunto de Dados](#149-isolamento-no-nível-de-conjunto-de-dados)
    - [14.10 Isolamento de Produto de Dados](#1410-isolamento-de-produto-de-dados)
    - [14.11 Falha de Dependência Compartilhada](#1411-falha-de-dependência-compartilhada)
    - [14.12 Falha de Dimensão Conformada](#1412-falha-de-dimensão-conformada)
    - [14.13 Falha de Dados de Referência](#1413-falha-de-dados-de-referência)
    - [14.14 Isolamento e Ordenação](#1414-isolamento-e-ordenação)
    - [14.15 Isolamento e Completude](#1415-isolamento-e-completude)
    - [14.16 Isolamento e Regras de Qualidade](#1416-isolamento-e-regras-de-qualidade)
    - [14.17 Isolamento e Reconciliação](#1417-isolamento-e-reconciliação)
    - [14.18 Isolamento e Certificação](#1418-isolamento-e-certificação)
    - [14.19 Publicação Fail-Safe](#1419-publicação-fail-safe)
    - [14.20 Disponibilidade Analítica Parcial](#1420-disponibilidade-analítica-parcial)
    - [14.21 Isolamento e Backlog](#1421-isolamento-e-backlog)
    - [14.22 Isolamento e Janela de Recuperação](#1422-isolamento-e-janela-de-recuperação)
    - [14.23 Isolamento e Consumo de Recursos](#1423-isolamento-e-consumo-de-recursos)
    - [14.24 Isolamento e Quarentena](#1424-isolamento-e-quarentena)
    - [14.25 Isolamento e Checkpoints](#1425-isolamento-e-checkpoints)
    - [14.26 Isolamento com Processamento Contínuo](#1426-isolamento-com-processamento-contínuo)
    - [14.27 Isolamento com Bloqueio de Processamento](#1427-isolamento-com-bloqueio-de-processamento)
    - [14.28 Contenção de Falhas](#1428-contenção-de-falhas)
    - [14.29 Raio de Impacto](#1429-raio-de-impacto)
    - [14.30 Isolamento e Causa Raiz](#1430-isolamento-e-causa-raiz)
    - [14.31 Recuperação do Isolamento](#1431-recuperação-do-isolamento)
    - [14.32 Retorno ao Processamento Normal](#1432-retorno-ao-processamento-normal)
    - [14.33 Isolamento e Linhagem](#1433-isolamento-e-linhagem)
    - [14.34 Isolamento e Evidências](#1434-isolamento-e-evidências)
    - [14.35 Cenários de Teste de Falha Parcial](#1435-cenários-de-teste-de-falha-parcial)
    - [14.36 Garantias de Falha Parcial e Isolamento](#1436-garantias-de-falha-parcial-e-isolamento)

- [15. Poison Records e Falhas Persistentes de Processamento](#15-poison-records-e-falhas-persistentes-de-processamento)
    - [15.1 Poison Record](#151-poison-record)
    - [15.2 Falha Persistente de Processamento](#152-falha-persistente-de-processamento)
    - [15.3 Poison Record versus Falha Transitória](#153-poison-record-versus-falha-transitória)
    - [15.4 Classificação de Falhas](#154-classificação-de-falhas)
    - [15.5 Esgotamento das Novas Tentativas](#155-esgotamento-das-novas-tentativas)
    - [15.6 Sem Novas Tentativas Infinitas](#156-sem-novas-tentativas-infinitas)
    - [15.7 Sem Descarte Silencioso](#157-sem-descarte-silencioso)
    - [15.8 Decisão de Isolamento da Falha](#158-decisão-de-isolamento-da-falha)
    - [15.9 Quarentena](#159-quarentena)
    - [15.10 Escopo da Quarentena](#1510-escopo-da-quarentena)
    - [15.11 Metadados da Quarentena](#1511-metadados-da-quarentena)
    - [15.12 Estado da Quarentena](#1512-estado-da-quarentena)
    - [15.13 Quarentena Não É um Destino Final](#1513-quarentena-não-é-um-destino-final)
    - [15.14 Quarentena e Ordenação do Kafka](#1514-quarentena-e-ordenação-do-kafka)
    - [15.15 Quarentena e Confirmação de Offset](#1515-quarentena-e-confirmação-de-offset)
    - [15.16 Quarentena e Ordenação da Entidade](#1516-quarentena-e-ordenação-da-entidade)
    - [15.17 Quarentena e Bronze](#1517-quarentena-e-bronze)
    - [15.18 Falha Problemática Antes da Bronze](#1518-falha-problemática-antes-da-bronze)
    - [15.19 Falha Problemática na Silver](#1519-falha-problemática-na-silver)
    - [15.20 Falha Problemática na Gold](#1520-falha-problemática-na-gold)
    - [15.21 Falha de Qualidade versus Falha de Processamento](#1521-falha-de-qualidade-versus-falha-de-processamento)
    - [15.22 Falha de Contrato](#1522-falha-de-contrato)
    - [15.23 Falha de Dados de Referência](#1523-falha-de-dados-de-referência)
    - [15.24 Defeito na Lógica de Processamento](#1524-defeito-na-lógica-de-processamento)
    - [15.25 Padrão de Falhas Repetidas](#1525-padrão-de-falhas-repetidas)
    - [15.26 Crescimento da Quarentena](#1526-crescimento-da-quarentena)
    - [15.27 Quarentena e Janelas de Recuperação](#1527-quarentena-e-janelas-de-recuperação)
    - [15.28 Quarentena e Backlog](#1528-quarentena-e-backlog)
    - [15.29 Quarentena e Completude](#1529-quarentena-e-completude)
    - [15.30 Quarentena e Reconciliação](#1530-quarentena-e-reconciliação)
    - [15.31 Quarentena e Certificação](#1531-quarentena-e-certificação)
    - [15.32 Quarentena e Atualidade](#1532-quarentena-e-atualidade)
    - [15.33 Remediação](#1533-remediação)
    - [15.34 Correção de Dados da Origem](#1534-correção-de-dados-da-origem)
    - [15.35 Correção Analítica](#1535-correção-analítica)
    - [15.36 Edição Manual de Dados](#1536-edição-manual-de-dados)
    - [15.37 Pronto para Reprocessamento](#1537-pronto-para-reprocessamento)
    - [15.38 Reprocessamento da Quarentena](#1538-reprocessamento-da-quarentena)
    - [15.39 Reintegração](#1539-reintegração)
    - [15.40 Encerramento da Quarentena](#1540-encerramento-da-quarentena)
    - [15.41 Nova Falha Após Remediação](#1541-nova-falha-após-remediação)
    - [15.42 Responsabilidade por Poison Records](#1542-responsabilidade-por-poison-records)
    - [15.43 Observabilidade de Poison Records](#1543-observabilidade-de-poison-records)
    - [15.44 Alertas de Poison Records](#1544-alertas-de-poison-records)
    - [15.45 Segurança de Poison Records](#1545-segurança-de-poison-records)
    - [15.46 Retenção de Poison Records](#1546-retenção-de-poison-records)
    - [15.47 Validação de Poison Records](#1547-validação-de-poison-records)
    - [15.48 Evidências de Poison Records](#1548-evidências-de-poison-records)
    - [15.49 Cenários de Teste de Poison Records](#1549-cenários-de-teste-de-poison-records)
    - [15.50 Garantias de Poison Records e Falhas Persistentes](#1550-garantias-de-poison-records-e-falhas-persistentes)

- [16. Recuperação de Backlog e Catch-Up](#16-recuperação-de-backlog-e-catch-up)
    - [16.1 Backlog](#161-backlog)
    - [16.2 Causas do Backlog](#162-causas-do-backlog)
    - [16.3 Catch-Up](#163-catch-up)
    - [16.4 Catch-Up Não É Replay](#164-catch-up-não-é-replay)
    - [16.5 Catch-Up Não É Reprocessamento](#165-catch-up-não-é-reprocessamento)
    - [16.6 Catch-Up e Checkpoints](#166-catch-up-e-checkpoints)
    - [16.7 Medição do Backlog](#167-medição-do-backlog)
    - [16.8 Idade do Item Pendente Mais Antigo](#168-idade-do-item-pendente-mais-antigo)
    - [16.9 Taxa de Crescimento do Backlog](#169-taxa-de-crescimento-do-backlog)
    - [16.10 Capacidade de Catch-Up](#1610-capacidade-de-catch-up)
    - [16.11 Razão de Catch-Up](#1611-razão-de-catch-up)
    - [16.12 Tempo de Catch-Up](#1612-tempo-de-catch-up)
    - [16.13 Backlog e Atualidade](#1613-backlog-e-atualidade)
    - [16.14 Recuperação da Atualidade](#1614-recuperação-da-atualidade)
    - [16.15 Catch-Up e Latência P95](#1615-catch-up-e-latência-p95)
    - [16.16 Catch-Up e Novos Eventos](#1616-catch-up-e-novos-eventos)
    - [16.17 Ordenação do Catch-Up](#1617-ordenação-do-catch-up)
    - [16.18 Catch-Up e Paralelismo](#1618-catch-up-e-paralelismo)
    - [16.19 Catch-Up e Partições Kafka](#1619-catch-up-e-partições-kafka)
    - [16.20 Desequilíbrio entre Partições](#1620-desequilíbrio-entre-partições)
    - [16.21 Catch-Up e Backpressure](#1621-catch-up-e-backpressure)
    - [16.22 Controle de Taxa do Catch-Up](#1622-controle-de-taxa-do-catch-up)
    - [16.23 Catch-Up e Folga de Recursos](#1623-catch-up-e-folga-de-recursos)
    - [16.24 Catch-Up e Carga de Pico](#1624-catch-up-e-carga-de-pico)
    - [16.25 Catch-Up e Carga de Novas Tentativas](#1625-catch-up-e-carga-de-novas-tentativas)
    - [16.26 Catch-Up e Quarentena](#1626-catch-up-e-quarentena)
    - [16.27 Catch-Up e Retenção](#1627-catch-up-e-retenção)
    - [16.28 Margem da Janela de Recuperação](#1628-margem-da-janela-de-recuperação)
    - [16.29 Catch-Up e CDC](#1629-catch-up-e-cdc)
    - [16.30 Catch-Up entre Camadas](#1630-catch-up-entre-camadas)
    - [16.31 Migração do Gargalo](#1631-migração-do-gargalo)
    - [16.32 Catch-Up e Silver](#1632-catch-up-e-silver)
    - [16.33 Catch-Up e Gold](#1633-catch-up-e-gold)
    - [16.34 Catch-Up e Certificação](#1634-catch-up-e-certificação)
    - [16.35 Catch-Up e Certified Gold](#1635-catch-up-e-certified-gold)
    - [16.36 Conclusão do Catch-Up](#1636-conclusão-do-catch-up)
    - [16.37 Faixa Operacional Normal](#1637-faixa-operacional-normal)
    - [16.38 Falha do Catch-Up](#1638-falha-do-catch-up)
    - [16.39 Cancelamento ou Pausa do Catch-Up](#1639-cancelamento-ou-pausa-do-catch-up)
    - [16.40 Prioridade do Catch-Up](#1640-prioridade-do-catch-up)
    - [16.41 Catch-Up e RTO](#1641-catch-up-e-rto)
    - [16.42 Catch-Up e Recuperação de SLO](#1642-catch-up-e-recuperação-de-slo)
    - [16.43 Observabilidade do Catch-Up](#1643-observabilidade-do-catch-up)
    - [16.44 Alertas do Catch-Up](#1644-alertas-do-catch-up)
    - [16.45 Validação do Catch-Up](#1645-validação-do-catch-up)
    - [16.46 Evidências do Catch-Up](#1646-evidências-do-catch-up)
    - [16.47 Cenários de Teste do Catch-Up](#1647-cenários-de-teste-do-catch-up)
    - [16.48 Garantias de Recuperação de Backlog e Catch-Up](#1648-garantias-de-recuperação-de-backlog-e-catch-up)

- [17. Disponibilidade da Certified Gold e Rollback](#17-disponibilidade-da-certified-gold-e-rollback)
    - [17.1 Certified Gold como Limite de Disponibilidade](#171-certified-gold-como-limite-de-disponibilidade)
    - [17.2 Versão Certificada Reconhecidamente Confiável](#172-versão-certificada-reconhecidamente-confiável)
    - [17.3 Certificação Não Garante Confiança Permanente](#173-certificação-não-garante-confiança-permanente)
    - [17.4 Isolamento da Candidata](#174-isolamento-da-candidata)
    - [17.5 Falha da Candidata](#175-falha-da-candidata)
    - [17.6 Degradação da Atualidade](#176-degradação-da-atualidade)
    - [17.7 Desatualização Visível aos Consumidores](#177-desatualização-visível-aos-consumidores)
    - [17.8 Elegibilidade para Publicação](#178-elegibilidade-para-publicação)
    - [17.9 Publicação Atômica](#179-publicação-atômica)
    - [17.10 Metadados de Publicação](#1710-metadados-de-publicação)
    - [17.11 Falha de Publicação](#1711-falha-de-publicação)
    - [17.12 Falha Parcial de Publicação](#1712-falha-parcial-de-publicação)
    - [17.13 Limite Transacional da Publicação](#1713-limite-transacional-da-publicação)
    - [17.14 Rollback](#1714-rollback)
    - [17.15 Fonte do Rollback](#1715-fonte-do-rollback)
    - [17.16 Elegibilidade para Rollback](#1716-elegibilidade-para-rollback)
    - [17.17 Rollback versus Rebuild](#1717-rollback-versus-rebuild)
    - [17.18 Rollback versus Restauração de Backup](#1718-rollback-versus-restauração-de-backup)
    - [17.19 Rollback e Atualidade](#1719-rollback-e-atualidade)
    - [17.20 Rollback e Compatibilidade com os Consumidores](#1720-rollback-e-compatibilidade-com-os-consumidores)
    - [17.21 Retenção de Versões para Rollback](#1721-retenção-de-versões-para-rollback)
    - [17.22 Imutabilidade da Versão Publicada](#1722-imutabilidade-da-versão-publicada)
    - [17.23 Histórico de Certificação](#1723-histórico-de-certificação)
    - [17.24 Histórico de Publicação](#1724-histórico-de-publicação)
    - [17.25 Validação Pós-Publicação](#1725-validação-pós-publicação)
    - [17.26 Defeito Pós-Publicação](#1726-defeito-pós-publicação)
    - [17.27 Incidente com Dados Publicados](#1727-incidente-com-dados-publicados)
    - [17.28 Nenhuma Versão Certified Gold Reconhecidamente Confiável](#1728-nenhuma-versão-certified-gold-reconhecidamente-confiável)
    - [17.29 Disponibilidade no Nível do Produto](#1729-disponibilidade-no-nível-do-produto)
    - [17.30 Estado de Recuperação no Nível do Produto](#1730-estado-de-recuperação-no-nível-do-produto)
    - [17.31 Certified Gold e Catch-Up Upstream](#1731-certified-gold-e-catch-up-upstream)
    - [17.32 Frequência de Publicação Durante a Recuperação](#1732-frequência-de-publicação-durante-a-recuperação)
    - [17.33 Roll-Forward](#1733-roll-forward)
    - [17.34 Validação do Roll-Forward](#1734-validação-do-roll-forward)
    - [17.35 Rollback e Linhagem](#1735-rollback-e-linhagem)
    - [17.36 Rollback e Metadados](#1736-rollback-e-metadados)
    - [17.37 Rollback e Segurança](#1737-rollback-e-segurança)
    - [17.38 Rollback e Retenção](#1738-rollback-e-retenção)
    - [17.39 Rollback e RPO](#1739-rollback-e-rpo)
    - [17.40 Rollback e RTO](#1740-rollback-e-rto)
    - [17.41 Congelamento da Publicação](#1741-congelamento-da-publicação)
    - [17.42 Recuperação do Congelamento da Publicação](#1742-recuperação-do-congelamento-da-publicação)
    - [17.43 Recuperação do Consumidor](#1743-recuperação-do-consumidor)
    - [17.44 Validação da Disponibilidade da Certified Gold](#1744-validação-da-disponibilidade-da-certified-gold)
    - [17.45 Validação do Rollback](#1745-validação-do-rollback)
    - [17.46 Evidências da Certified Gold](#1746-evidências-da-certified-gold)
    - [17.47 Cenários de Teste da Certified Gold](#1747-cenários-de-teste-da-certified-gold)
    - [17.48 Garantias de Disponibilidade e Rollback da Certified Gold](#1748-garantias-de-disponibilidade-e-rollback-da-certified-gold)

- [18. Recuperação e Versões Históricas](#18-recuperação-e-versões-históricas)
    - [18.1 Contexto de Versão Histórica](#181-contexto-de-versão-histórica)
    - [18.2 Identidade de Versão](#182-identidade-de-versão)
    - [18.3 Contratos Históricos de Eventos](#183-contratos-históricos-de-eventos)
    - [18.4 Evolução de Contrato](#184-evolução-de-contrato)
    - [18.5 Papel Histórico do Apicurio Registry](#185-papel-histórico-do-apicurio-registry)
    - [18.6 Evolução do Schema da Origem](#186-evolução-do-schema-da-origem)
    - [18.7 Evolução do Schema da Bronze](#187-evolução-do-schema-da-bronze)
    - [18.8 Evolução do Schema da Silver](#188-evolução-do-schema-da-silver)
    - [18.9 Evolução do Modelo da Gold](#189-evolução-do-modelo-da-gold)
    - [18.10 Definição de Processamento](#1810-definição-de-processamento)
    - [18.11 Versão de Processamento](#1811-versão-de-processamento)
    - [18.12 Versão de Configuração](#1812-versão-de-configuração)
    - [18.13 Versão de Infraestrutura](#1813-versão-de-infraestrutura)
    - [18.14 Reprodução Histórica](#1814-reprodução-histórica)
    - [18.15 Reapresentação Histórica](#1815-reapresentação-histórica)
    - [18.16 Reprodução versus Reapresentação](#1816-reprodução-versus-reapresentação)
    - [18.17 Lógica Histórica Corrigida](#1817-lógica-histórica-corrigida)
    - [18.18 Dados Históricos de Referência](#1818-dados-históricos-de-referência)
    - [18.19 Versionamento de Dados de Referência](#1819-versionamento-de-dados-de-referência)
    - [18.20 Regras Históricas de Negócio](#1820-regras-históricas-de-negócio)
    - [18.21 Versões das Regras de Qualidade](#1821-versões-das-regras-de-qualidade)
    - [18.22 Reprodução Histórica da Qualidade](#1822-reprodução-histórica-da-qualidade)
    - [18.23 Validação Atual da Qualidade de Dados Históricos](#1823-validação-atual-da-qualidade-de-dados-históricos)
    - [18.24 Versões das Regras de Reconciliação](#1824-versões-das-regras-de-reconciliação)
    - [18.25 Versões das Regras de Certificação](#1825-versões-das-regras-de-certificação)
    - [18.26 Evidências Históricas de Certificação](#1826-evidências-históricas-de-certificação)
    - [18.27 Linhagem Versionada](#1827-linhagem-versionada)
    - [18.28 Compatibilidade de Versões](#1828-compatibilidade-de-versões)
    - [18.29 Retenção de Artefatos Históricos de Processamento](#1829-retenção-de-artefatos-históricos-de-processamento)
    - [18.30 Git como Evidência Histórica](#1830-git-como-evidência-histórica)
    - [18.31 Identidade Imutável de Artefato](#1831-identidade-imutável-de-artefato)
    - [18.32 Segredos Históricos](#1832-segredos-históricos)
    - [18.33 Política Histórica de Segurança](#1833-política-histórica-de-segurança)
    - [18.34 Requisitos Históricos de Privacidade](#1834-requisitos-históricos-de-privacidade)
    - [18.35 Exclusão de Dados Históricos](#1835-exclusão-de-dados-históricos)
    - [18.36 Matriz de Dependências de Versão](#1836-matriz-de-dependências-de-versão)
    - [18.37 Seleção da Versão de Recuperação](#1837-seleção-da-versão-de-recuperação)
    - [18.38 Versão Histórica Não Suportada](#1838-versão-histórica-não-suportada)
    - [18.39 Migração de Versão](#1839-migração-de-versão)
    - [18.40 Recuperação entre Múltiplas Versões](#1840-recuperação-entre-múltiplas-versões)
    - [18.41 Detecção de Limites de Versão](#1841-detecção-de-limites-de-versão)
    - [18.42 Testes de Versões Históricas](#1842-testes-de-versões-históricas)
    - [18.43 Degradação da Capacidade de Recuperação](#1843-degradação-da-capacidade-de-recuperação)
    - [18.44 Janela Histórica de Recuperação](#1844-janela-histórica-de-recuperação)
    - [18.45 Alinhamento da Retenção de Versões](#1845-alinhamento-da-retenção-de-versões)
    - [18.46 Validação da Recuperação Histórica](#1846-validação-da-recuperação-histórica)
    - [18.47 Evidências de Versão Histórica](#1847-evidências-de-versão-histórica)
    - [18.48 Cenários de Teste de Versões Históricas](#1848-cenários-de-teste-de-versões-históricas)
    - [18.49 Garantias de Recuperação e Versões Históricas](#1849-garantias-de-recuperação-e-versões-históricas)

- [19. Validação e Evidências de Recuperação](#19-validação-e-evidências-de-recuperação)
    - [19.1 Validação da Recuperação](#191-validação-da-recuperação)
    - [19.2 Evidências de Recuperação](#192-evidências-de-recuperação)
    - [19.3 Evidências Antes da Recuperação](#193-evidências-antes-da-recuperação)
    - [19.4 Evidências Durante a Falha](#194-evidências-durante-a-falha)
    - [19.5 Evidências Antes da Remediação](#195-evidências-antes-da-remediação)
    - [19.6 Evidências da Ação de Recuperação](#196-evidências-da-ação-de-recuperação)
    - [19.7 Evidências da Fonte de Recuperação](#197-evidências-da-fonte-de-recuperação)
    - [19.8 Evidências do Limite de Recuperação](#198-evidências-do-limite-de-recuperação)
    - [19.9 Validação da Recuperação do Serviço](#199-validação-da-recuperação-do-serviço)
    - [19.10 Validação da Recuperação do Processamento](#1910-validação-da-recuperação-do-processamento)
    - [19.11 Validação da Recuperação dos Dados](#1911-validação-da-recuperação-dos-dados)
    - [19.12 Validação da Continuidade](#1912-validação-da-continuidade)
    - [19.13 Detecção de Lacunas](#1913-detecção-de-lacunas)
    - [19.14 Detecção de Sobreposição](#1914-detecção-de-sobreposição)
    - [19.15 Validação de Efeitos Duplicados](#1915-validação-de-efeitos-duplicados)
    - [19.16 Validação da Ordenação](#1916-validação-da-ordenação)
    - [19.17 Validação de Checkpoint](#1917-validação-de-checkpoint)
    - [19.18 Validação de Backlog](#1918-validação-de-backlog)
    - [19.19 Validação da Retenção](#1919-validação-da-retenção)
    - [19.20 Validação da Recuperação da Bronze](#1920-validação-da-recuperação-da-bronze)
    - [19.21 Validação da Recuperação da Silver](#1921-validação-da-recuperação-da-silver)
    - [19.22 Validação da Recuperação da Gold](#1922-validação-da-recuperação-da-gold)
    - [19.23 Validação da Recuperação da Certified Gold](#1923-validação-da-recuperação-da-certified-gold)
    - [19.24 Validação da Qualidade](#1924-validação-da-qualidade)
    - [19.25 Validação da Reconciliação](#1925-validação-da-reconciliação)
    - [19.26 Validação entre Camadas](#1926-validação-entre-camadas)
    - [19.27 Validação da Recuperação Ponta a Ponta](#1927-validação-da-recuperação-ponta-a-ponta)
    - [19.28 Validação do Consumidor](#1928-validação-do-consumidor)
    - [19.29 Validação da Atualidade](#1929-validação-da-atualidade)
    - [19.30 Validação do RPO](#1930-validação-do-rpo)
    - [19.31 Validação do RTO](#1931-validação-do-rto)
    - [19.32 Linha do Tempo da Recuperação](#1932-linha-do-tempo-da-recuperação)
    - [19.33 Tempo de Detecção](#1933-tempo-de-detecção)
    - [19.34 Tempo de Intervenção](#1934-tempo-de-intervenção)
    - [19.35 Tempo de Restauração Técnica](#1935-tempo-de-restauração-técnica)
    - [19.36 Tempo de Recuperação do Processamento](#1936-tempo-de-recuperação-do-processamento)
    - [19.37 Tempo de Recuperação do Consumidor](#1937-tempo-de-recuperação-do-consumidor)
    - [19.38 Tempo Total de Recuperação](#1938-tempo-total-de-recuperação)
    - [19.39 Coleta Automatizada de Evidências](#1939-coleta-automatizada-de-evidências)
    - [19.40 Evidências Manuais](#1940-evidências-manuais)
    - [19.41 Correlação de Evidências](#1941-correlação-de-evidências)
    - [19.42 Consistência Temporal](#1942-consistência-temporal)
    - [19.43 Integridade das Evidências](#1943-integridade-das-evidências)
    - [19.44 Evidências de Recuperação com Falha](#1944-evidências-de-recuperação-com-falha)
    - [19.45 Registro de Teste de Recuperação](#1945-registro-de-teste-de-recuperação)
    - [19.46 Comportamento Esperado versus Observado](#1946-comportamento-esperado-versus-observado)
    - [19.47 Critérios de PASS](#1947-critérios-de-pass)
    - [19.48 Critérios de FAIL](#1948-critérios-de-fail)
    - [19.49 Resultado Inconclusivo](#1949-resultado-inconclusivo)
    - [19.50 Evidências e Afirmações Arquiteturais](#1950-evidências-e-afirmações-arquiteturais)
    - [19.51 Evidências e Limitações da Versão 1](#1951-evidências-e-limitações-da-versão-1)
    - [19.52 Retenção das Evidências](#1952-retenção-das-evidências)
    - [19.53 Evidências na Documentação Pública](#1953-evidências-na-documentação-pública)
    - [19.54 Evidências de Recuperação e Observabilidade](#1954-evidências-de-recuperação-e-observabilidade)
    - [19.55 Evidências de Recuperação e Documentação](#1955-evidências-de-recuperação-e-documentação)
    - [19.56 Evidências de Recuperação e FAQ](#1956-evidências-de-recuperação-e-faq)
    - [19.57 Cenários de Teste de Validação da Recuperação](#1957-cenários-de-teste-de-validação-da-recuperação)
    - [19.58 Garantias de Validação e Evidências de Recuperação](#1958-garantias-de-validação-e-evidências-de-recuperação)

- [20. Estratégia de Testes de Recuperação](#20-estratégia-de-testes-de-recuperação)
    - [20.1 Objetivos dos Testes](#201-objetivos-dos-testes)
    - [20.2 Injeção Controlada de Falhas](#202-injeção-controlada-de-falhas)
    - [20.3 Escopo do Laboratório](#203-escopo-do-laboratório)
    - [20.4 Linha de Base do Teste](#204-linha-de-base-do-teste)
    - [20.5 Validação da Linha de Base](#205-validação-da-linha-de-base)
    - [20.6 Hipótese do Teste](#206-hipótese-do-teste)
    - [20.7 Impacto Esperado da Falha](#207-impacto-esperado-da-falha)
    - [20.8 Critérios de PASS](#208-critérios-de-pass)
    - [20.9 Critérios de FAIL](#209-critérios-de-fail)
    - [20.10 Critérios de Resultado Inconclusivo](#2010-critérios-de-resultado-inconclusivo)
    - [20.11 Limite da Injeção de Falha](#2011-limite-da-injeção-de-falha)
    - [20.12 Uma Falha por Vez](#2012-uma-falha-por-vez)
    - [20.13 Testes de Falhas Compostas](#2013-testes-de-falhas-compostas)
    - [20.14 Duração da Falha](#2014-duração-da-falha)
    - [20.15 Carga de Trabalho do Teste](#2015-carga-de-trabalho-do-teste)
    - [20.16 Dados Sintéticos de Teste](#2016-dados-sintéticos-de-teste)
    - [20.17 Identidade dos Dados de Teste](#2017-identidade-dos-dados-de-teste)
    - [20.18 Isolamento do Teste](#2018-isolamento-do-teste)
    - [20.19 Limpeza do Teste](#2019-limpeza-do-teste)
    - [20.20 Validação da Limpeza](#2020-validação-da-limpeza)
    - [20.21 Teste de Reinicialização](#2021-teste-de-reinicialização)
    - [20.22 Teste de Novas Tentativas](#2022-teste-de-novas-tentativas)
    - [20.23 Teste de Reentrega](#2023-teste-de-reentrega)
    - [20.24 Teste de Replay](#2024-teste-de-replay)
    - [20.25 Teste de Reprocessamento](#2025-teste-de-reprocessamento)
    - [20.26 Teste de Backfill](#2026-teste-de-backfill)
    - [20.27 Teste de Rebuild](#2027-teste-de-rebuild)
    - [20.28 Teste de Rebuild Interrompido](#2028-teste-de-rebuild-interrompido)
    - [20.29 Teste de Recuperação de Backlog](#2029-teste-de-recuperação-de-backlog)
    - [20.30 Teste de Registro Venenoso](#2030-teste-de-registro-venenoso)
    - [20.31 Teste de Isolamento de Partição](#2031-teste-de-isolamento-de-partição)
    - [20.32 Teste de Falha de Certificação](#2032-teste-de-falha-de-certificação)
    - [20.33 Teste de Falha de Publicação](#2033-teste-de-falha-de-publicação)
    - [20.34 Teste de Rollback](#2034-teste-de-rollback)
    - [20.35 Teste de Roll-Forward](#2035-teste-de-roll-forward)
    - [20.36 Teste do Limite de Retenção](#2036-teste-do-limite-de-retenção)
    - [20.37 Teste de Versão Histórica](#2037-teste-de-versão-histórica)
    - [20.38 Teste de Falha de Observabilidade](#2038-teste-de-falha-de-observabilidade)
    - [20.39 Teste de Falha Ponta a Ponta](#2039-teste-de-falha-ponta-a-ponta)
    - [20.40 Repetição dos Testes](#2040-repetição-dos-testes)
    - [20.41 Repetibilidade](#2041-repetibilidade)
    - [20.42 Automação dos Testes](#2042-automação-dos-testes)
    - [20.43 Testes Manuais](#2043-testes-manuais)
    - [20.44 Segurança dos Testes](#2044-segurança-dos-testes)
    - [20.45 Limite de Segurança da Injeção de Falha](#2045-limite-de-segurança-da-injeção-de-falha)
    - [20.46 Catálogo de Testes de Recuperação](#2046-catálogo-de-testes-de-recuperação)
    - [20.47 Nomenclatura dos Testes](#2047-nomenclatura-dos-testes)
    - [20.48 Registro do Teste](#2048-registro-do-teste)
    - [20.49 Evidências dos Testes](#2049-evidências-dos-testes)
    - [20.50 Resultado do Teste](#2050-resultado-do-teste)
    - [20.51 Fluxo de Teste com Falha](#2051-fluxo-de-teste-com-falha)
    - [20.52 Correção da Arquitetura](#2052-correção-da-arquitetura)
    - [20.53 Descobertas de Capacidade](#2053-descobertas-de-capacidade)
    - [20.54 Linha de Base de Confiabilidade](#2054-linha-de-base-de-confiabilidade)
    - [20.55 Revisão dos Testes de Recuperação](#2055-revisão-dos-testes-de-recuperação)
    - [20.56 Testes de Regressão de Recuperação](#2056-testes-de-regressão-de-recuperação)
    - [20.57 Laboratório versus Chaos Engineering](#2057-laboratório-versus-chaos-engineering)
    - [20.58 Garantias dos Testes de Recuperação](#2058-garantias-dos-testes-de-recuperação)

- [21. Observabilidade da Recuperação](#21-observabilidade-da-recuperação)
    - [21.1 Escopo da Observabilidade da Recuperação](#211-escopo-da-observabilidade-da-recuperação)
    - [21.2 Saúde do Serviço](#212-saúde-do-serviço)
    - [21.3 Saúde das Dependências](#213-saúde-das-dependências)
    - [21.4 Progresso do Processamento](#214-progresso-do-processamento)
    - [21.5 Observabilidade do Checkpoint](#215-observabilidade-do-checkpoint)
    - [21.6 Desatualização do Checkpoint](#216-desatualização-do-checkpoint)
    - [21.7 Lag do Consumidor Kafka](#217-lag-do-consumidor-kafka)
    - [21.8 Lag por Partição](#218-lag-por-partição)
    - [21.9 Profundidade do Backlog](#219-profundidade-do-backlog)
    - [21.10 Idade do Item Pendente Mais Antigo](#2110-idade-do-item-pendente-mais-antigo)
    - [21.11 Tendência do Backlog](#2111-tendência-do-backlog)
    - [21.12 Taxa de Entrada](#2112-taxa-de-entrada)
    - [21.13 Taxa de Processamento](#2113-taxa-de-processamento)
    - [21.14 Razão de Catch-Up](#2114-razão-de-catch-up)
    - [21.15 Progresso do Catch-Up](#2115-progresso-do-catch-up)
    - [21.16 Observabilidade das Novas Tentativas](#2116-observabilidade-das-novas-tentativas)
    - [21.17 Esgotamento das Novas Tentativas](#2117-esgotamento-das-novas-tentativas)
    - [21.18 Observabilidade de Falhas Persistentes](#2118-observabilidade-de-falhas-persistentes)
    - [21.19 Observabilidade da Quarentena](#2119-observabilidade-da-quarentena)
    - [21.20 Observabilidade de Lacunas de Processamento](#2120-observabilidade-de-lacunas-de-processamento)
    - [21.21 Observabilidade da Janela de Recuperação](#2121-observabilidade-da-janela-de-recuperação)
    - [21.22 Margem da Janela de Recuperação](#2122-margem-da-janela-de-recuperação)
    - [21.23 Sinais de Recuperação do CDC](#2123-sinais-de-recuperação-do-cdc)
    - [21.24 Sinais de Recuperação do Debezium](#2124-sinais-de-recuperação-do-debezium)
    - [21.25 Sinais de Recuperação do Kafka](#2125-sinais-de-recuperação-do-kafka)
    - [21.26 Sinais de Recuperação da Bronze](#2126-sinais-de-recuperação-da-bronze)
    - [21.27 Sinais de Recuperação da Silver](#2127-sinais-de-recuperação-da-silver)
    - [21.28 Sinais de Recuperação da Gold](#2128-sinais-de-recuperação-da-gold)
    - [21.29 Sinais de Certificação](#2129-sinais-de-certificação)
    - [21.30 Sinais de Publicação](#2130-sinais-de-publicação)
    - [21.31 Atualidade da Certified Gold](#2131-atualidade-da-certified-gold)
    - [21.32 Sinais de Disponibilidade para Consumidores](#2132-sinais-de-disponibilidade-para-consumidores)
    - [21.33 Estado da Recuperação](#2133-estado-da-recuperação)
    - [21.34 Linha do Tempo da Recuperação](#2134-linha-do-tempo-da-recuperação)
    - [21.35 Gargalo da Recuperação](#2135-gargalo-da-recuperação)
    - [21.36 Convergência da Recuperação](#2136-convergência-da-recuperação)
    - [21.37 Paralisação da Recuperação](#2137-paralisação-da-recuperação)
    - [21.38 Regressão da Recuperação](#2138-regressão-da-recuperação)
    - [21.39 Recuperação e SLOs](#2139-recuperação-e-slos)
    - [21.40 Recuperação e RPO](#2140-recuperação-e-rpo)
    - [21.41 Recuperação e RTO](#2141-recuperação-e-rto)
    - [21.42 Princípios de Alertas](#2142-princípios-de-alertas)
    - [21.43 Severidade dos Alertas](#2143-severidade-dos-alertas)
    - [21.44 Correlação de Alertas](#2144-correlação-de-alertas)
    - [21.45 Supressão de Alertas Durante a Recuperação](#2145-supressão-de-alertas-durante-a-recuperação)
    - [21.46 Dashboards de Recuperação](#2146-dashboards-de-recuperação)
    - [21.47 Logs de Recuperação](#2147-logs-de-recuperação)
    - [21.48 Métricas de Recuperação](#2148-métricas-de-recuperação)
    - [21.49 Traces e Correlação da Recuperação](#2149-traces-e-correlação-da-recuperação)
    - [21.50 Falha de Observabilidade Durante a Recuperação](#2150-falha-de-observabilidade-durante-a-recuperação)
    - [21.51 Validação da Observabilidade da Recuperação](#2151-validação-da-observabilidade-da-recuperação)
    - [21.52 Evidências da Observabilidade da Recuperação](#2152-evidências-da-observabilidade-da-recuperação)
    - [21.53 Garantias da Observabilidade da Recuperação](#2153-garantias-da-observabilidade-da-recuperação)

- [22. Objetivos de Recuperação e Expectativas de Nível de Serviço](#22-objetivos-de-recuperação-e-expectativas-de-nível-de-serviço)
    - [22.1 Objetivos de Recuperação](#221-objetivos-de-recuperação)
    - [22.2 Recovery Point Objective](#222-recovery-point-objective)
    - [22.3 RPO por Limite Arquitetural](#223-rpo-por-limite-arquitetural)
    - [22.4 Perda Zero de Dados](#224-perda-zero-de-dados)
    - [22.5 RPO Lógico versus Físico](#225-rpo-lógico-versus-físico)
    - [22.6 RPO Visível aos Consumidores](#226-rpo-visível-aos-consumidores)
    - [22.7 Recovery Time Objective](#227-recovery-time-objective)
    - [22.8 RTO do Componente](#228-rto-do-componente)
    - [22.9 RTO do Processamento](#229-rto-do-processamento)
    - [22.10 RTO do Produto de Dados](#2210-rto-do-produto-de-dados)
    - [22.11 RTO Ponta a Ponta](#2211-rto-ponta-a-ponta)
    - [22.12 Tempo de Detecção](#2212-tempo-de-detecção)
    - [22.13 Atraso de Intervenção](#2213-atraso-de-intervenção)
    - [22.14 Tempo de Restauração Técnica](#2214-tempo-de-restauração-técnica)
    - [22.15 Tempo de Catch-Up](#2215-tempo-de-catch-up)
    - [22.16 Tempo de Rebuild](#2216-tempo-de-rebuild)
    - [22.17 Tempo de Validação](#2217-tempo-de-validação)
    - [22.18 Tempo de Recuperação por Rollback](#2218-tempo-de-recuperação-por-rollback)
    - [22.19 Disponibilidade](#2219-disponibilidade)
    - [22.20 Confiabilidade versus Disponibilidade](#2220-confiabilidade-versus-disponibilidade)
    - [22.21 Alta Disponibilidade](#2221-alta-disponibilidade)
    - [22.22 Disponibilidade do Laboratório](#2222-disponibilidade-do-laboratório)
    - [22.23 Disponibilidade Analítica](#2223-disponibilidade-analítica)
    - [22.24 Atualidade](#2224-atualidade)
    - [22.25 Objetivo de Atualidade](#2225-objetivo-de-atualidade)
    - [22.26 Atualidade Durante uma Falha](#2226-atualidade-durante-uma-falha)
    - [22.27 Recuperação da Atualidade](#2227-recuperação-da-atualidade)
    - [22.28 Latência de Processamento](#2228-latência-de-processamento)
    - [22.29 Latência Ponta a Ponta](#2229-latência-ponta-a-ponta)
    - [22.30 Percentis de Latência](#2230-percentis-de-latência)
    - [22.31 Objetivo de Disponibilidade](#2231-objetivo-de-disponibilidade)
    - [22.32 Error Budget](#2232-error-budget)
    - [22.33 RPO e Retenção](#2233-rpo-e-retenção)
    - [22.34 RTO e Capacidade](#2234-rto-e-capacidade)
    - [22.35 RTO e Volume de Dados](#2235-rto-e-volume-de-dados)
    - [22.36 RTO e Carga de Trabalho](#2236-rto-e-carga-de-trabalho)
    - [22.37 RTO e Profundidade da Validação](#2237-rto-e-profundidade-da-validação)
    - [22.38 Trade-Offs dos Objetivos de Recuperação](#2238-trade-offs-dos-objetivos-de-recuperação)
    - [22.39 Hierarquia dos Objetivos de Recuperação](#2239-hierarquia-dos-objetivos-de-recuperação)
    - [22.40 Criticidade dos Dados](#2240-criticidade-dos-dados)
    - [22.41 Responsabilidade pelos Objetivos de Recuperação](#2241-responsabilidade-pelos-objetivos-de-recuperação)
    - [22.42 Medição em Laboratório](#2242-medição-em-laboratório)
    - [22.43 Observado versus Meta](#2243-observado-versus-meta)
    - [22.44 Linha de Base Medida de Recuperação](#2244-linha-de-base-medida-de-recuperação)
    - [22.45 Nenhuma Publicação com Placeholders](#2245-nenhuma-publicação-com-placeholders)
    - [22.46 Evolução dos Objetivos de Recuperação](#2246-evolução-dos-objetivos-de-recuperação)
    - [22.47 Regressão dos Objetivos](#2247-regressão-dos-objetivos)
    - [22.48 Validação dos Objetivos](#2248-validação-dos-objetivos)
    - [22.49 Evidências dos Objetivos](#2249-evidências-dos-objetivos)
    - [22.50 RPO e RTO Corporativos](#2250-rpo-e-rto-corporativos)
    - [22.51 Cenários de Teste dos Objetivos de Recuperação](#2251-cenários-de-teste-dos-objetivos-de-recuperação)
    - [22.52 Garantias dos Objetivos de Recuperação e Nível de Serviço](#2252-garantias-dos-objetivos-de-recuperação-e-nível-de-serviço)

- [23. Disponibilidade, Alta Disponibilidade e Recuperação de Desastre](#23-disponibilidade-alta-disponibilidade-e-recuperação-de-desastre)
    - [23.1 Disponibilidade](#231-disponibilidade)
    - [23.2 Disponibilidade do Componente](#232-disponibilidade-do-componente)
    - [23.3 Disponibilidade do Processamento](#233-disponibilidade-do-processamento)
    - [23.4 Disponibilidade Analítica](#234-disponibilidade-analítica)
    - [23.5 Disponibilidade e Atualidade](#235-disponibilidade-e-atualidade)
    - [23.6 Disponibilidade e Correção](#236-disponibilidade-e-correção)
    - [23.7 Disponibilidade e Falha Parcial](#237-disponibilidade-e-falha-parcial)
    - [23.8 Alta Disponibilidade](#238-alta-disponibilidade)
    - [23.9 Objetivo da Alta Disponibilidade](#239-objetivo-da-alta-disponibilidade)
    - [23.10 HA e Replicação de Estado](#2310-ha-e-replicação-de-estado)
    - [23.11 HA e Domínios de Falha](#2311-ha-e-domínios-de-falha)
    - [23.12 HA e Failover Automático](#2312-ha-e-failover-automático)
    - [23.13 HA e Kafka](#2313-ha-e-kafka)
    - [23.14 HA e SQL Server](#2314-ha-e-sql-server)
    - [23.15 HA e MinIO](#2315-ha-e-minio)
    - [23.16 HA e Workers de Processamento](#2316-ha-e-workers-de-processamento)
    - [23.17 HA e Airflow](#2317-ha-e-airflow)
    - [23.18 HA e Observabilidade](#2318-ha-e-observabilidade)
    - [23.19 HA e Dependências de Segurança](#2319-ha-e-dependências-de-segurança)
    - [23.20 Capacidade de Recuperação](#2320-capacidade-de-recuperação)
    - [23.21 Capacidade de Recuperação sem Redundância](#2321-capacidade-de-recuperação-sem-redundância)
    - [23.22 Desastre](#2322-desastre)
    - [23.23 Recuperação de Desastre](#2323-recuperação-de-desastre)
    - [23.24 Sequência de Recuperação de DR](#2324-sequência-de-recuperação-de-dr)
    - [23.25 DR e Backup](#2325-dr-e-backup)
    - [23.26 Validação da Restauração de Backup](#2326-validação-da-restauração-de-backup)
    - [23.27 DR e Catch-Up Histórico](#2327-dr-e-catch-up-histórico)
    - [23.28 DR e RPO](#2328-dr-e-rpo)
    - [23.29 DR e RTO](#2329-dr-e-rto)
    - [23.30 DR e Local de Recuperação](#2330-dr-e-local-de-recuperação)
    - [23.31 Backup Fora do Host](#2331-backup-fora-do-host)
    - [23.32 Recuperação de Desastre entre Regiões](#2332-recuperação-de-desastre-entre-regiões)
    - [23.33 DR e Certified Gold](#2333-dr-e-certified-gold)
    - [23.34 DR e Segurança](#2334-dr-e-segurança)
    - [23.35 DR e Chaves de Criptografia](#2335-dr-e-chaves-de-criptografia)
    - [23.36 DR e Configuração](#2336-dr-e-configuração)
    - [23.37 DR e Metadados](#2337-dr-e-metadados)
    - [23.38 DR e Observabilidade](#2338-dr-e-observabilidade)
    - [23.39 DR e Documentação](#2339-dr-e-documentação)
    - [23.40 Runbook de DR](#2340-runbook-de-dr)
    - [23.41 Testes de DR](#2341-testes-de-dr)
    - [23.42 Teste de Recuperação Completa do Laboratório](#2342-teste-de-recuperação-completa-do-laboratório)
    - [23.43 Limitação de Perda do Host](#2343-limitação-de-perda-do-host)
    - [23.44 Evolução Corporativa da HA](#2344-evolução-corporativa-da-ha)
    - [23.45 Evolução Corporativa da DR](#2345-evolução-corporativa-da-dr)
    - [23.46 Custo e Complexidade de HA/DR](#2346-custo-e-complexidade-de-hadr)
    - [23.47 Afirmações de Disponibilidade](#2347-afirmações-de-disponibilidade)
    - [23.48 Afirmações de DR](#2348-afirmações-de-dr)
    - [23.49 Validação de Disponibilidade e DR](#2349-validação-de-disponibilidade-e-dr)
    - [23.50 Evidências de Disponibilidade, HA e DR](#2350-evidências-de-disponibilidade-ha-e-dr)
    - [23.51 Garantias de Disponibilidade, Alta Disponibilidade e Recuperação de Desastre](#2351-garantias-de-disponibilidade-alta-disponibilidade-e-recuperação-de-desastre)

- [24. Limites de Confiabilidade do Laboratório e do Ambiente Corporativo](#24-limites-de-confiabilidade-do-laboratório-e-do-ambiente-corporativo)
    - [24.1 Propósito de Confiabilidade do Laboratório](#241-propósito-de-confiabilidade-do-laboratório)
    - [24.2 Topologia Física do Laboratório](#242-topologia-física-do-laboratório)
    - [24.3 Domínio de Falha de Host Único](#243-domínio-de-falha-de-host-único)
    - [24.4 Independência Lógica](#244-independência-lógica)
    - [24.5 Durabilidade do Laboratório](#245-durabilidade-do-laboratório)
    - [24.6 Capacidade de Reinicialização do Laboratório](#246-capacidade-de-reinicialização-do-laboratório)
    - [24.7 Novas Tentativas e Reentrega no Laboratório](#247-novas-tentativas-e-reentrega-no-laboratório)
    - [24.8 Replay no Laboratório](#248-replay-no-laboratório)
    - [24.9 Reprocessamento no Laboratório](#249-reprocessamento-no-laboratório)
    - [24.10 Backfill no Laboratório](#2410-backfill-no-laboratório)
    - [24.11 Rebuild no Laboratório](#2411-rebuild-no-laboratório)
    - [24.12 Recuperação de Backlog no Laboratório](#2412-recuperação-de-backlog-no-laboratório)
    - [24.13 Isolamento de Falhas no Laboratório](#2413-isolamento-de-falhas-no-laboratório)
    - [24.14 Tratamento de Poison Records no Laboratório](#2414-tratamento-de-poison-records-no-laboratório)
    - [24.15 Proteção da Certified Gold no Laboratório](#2415-proteção-da-certified-gold-no-laboratório)
    - [24.16 Atomicidade da Publicação no Laboratório](#2416-atomicidade-da-publicação-no-laboratório)
    - [24.17 Evidências de RPO do Laboratório](#2417-evidências-de-rpo-do-laboratório)
    - [24.18 Evidências de RTO do Laboratório](#2418-evidências-de-rto-do-laboratório)
    - [24.19 Disponibilidade do Laboratório](#2419-disponibilidade-do-laboratório)
    - [24.20 Limite de Alta Disponibilidade do Laboratório](#2420-limite-de-alta-disponibilidade-do-laboratório)
    - [24.21 Limite de Recuperação de Desastre do Laboratório](#2421-limite-de-recuperação-de-desastre-do-laboratório)
    - [24.22 Evolução da Recuperação Fora do Host](#2422-evolução-da-recuperação-fora-do-host)
    - [24.23 Distribuição Física Corporativa](#2423-distribuição-física-corporativa)
    - [24.24 Confiabilidade Corporativa do Kafka](#2424-confiabilidade-corporativa-do-kafka)
    - [24.25 Confiabilidade Corporativa do SQL Server](#2425-confiabilidade-corporativa-do-sql-server)
    - [24.26 Confiabilidade Corporativa do Armazenamento de Objetos](#2426-confiabilidade-corporativa-do-armazenamento-de-objetos)
    - [24.27 Confiabilidade Corporativa do Processamento](#2427-confiabilidade-corporativa-do-processamento)
    - [24.28 Confiabilidade Corporativa da Orquestração](#2428-confiabilidade-corporativa-da-orquestração)
    - [24.29 Confiabilidade Corporativa da Observabilidade](#2429-confiabilidade-corporativa-da-observabilidade)
    - [24.30 Estratégia Corporativa de Backup](#2430-estratégia-corporativa-de-backup)
    - [24.31 Automação Corporativa da Recuperação](#2431-automação-corporativa-da-recuperação)
    - [24.32 Folga de Capacidade Corporativa](#2432-folga-de-capacidade-corporativa)
    - [24.33 Objetivos Corporativos de Recuperação](#2433-objetivos-corporativos-de-recuperação)
    - [24.34 Substituição de Mecanismos](#2434-substituição-de-mecanismos)
    - [24.35 Fortalecimento dos Mecanismos](#2435-fortalecimento-dos-mecanismos)
    - [24.36 Portabilidade da Confiabilidade](#2436-portabilidade-da-confiabilidade)
    - [24.37 Limites das Evidências do Laboratório](#2437-limites-das-evidências-do-laboratório)
    - [24.38 Afirmações do Laboratório versus Corporativas](#2438-afirmações-do-laboratório-versus-corporativas)
    - [24.39 Documentação das Lacunas Corporativas](#2439-documentação-das-lacunas-corporativas)
    - [24.40 Evitando Teatro de Confiabilidade](#2440-evitando-teatro-de-confiabilidade)
    - [24.41 Evolução Corporativa Orientada por Evidências](#2441-evolução-corporativa-orientada-por-evidências)
    - [24.42 ADRs de Confiabilidade](#2442-adrs-de-confiabilidade)
    - [24.43 Validação do Laboratório para o Ambiente Corporativo](#2443-validação-do-laboratório-para-o-ambiente-corporativo)
    - [24.44 Progressão da Maturidade da Confiabilidade](#2444-progressão-da-maturidade-da-confiabilidade)
    - [24.45 Linha de Base de Confiabilidade da Versão 1](#2445-linha-de-base-de-confiabilidade-da-versão-1)
    - [24.46 Validação da Confiabilidade do Laboratório e do Ambiente Corporativo](#2446-validação-da-confiabilidade-do-laboratório-e-do-ambiente-corporativo)
    - [24.47 Evidências de Confiabilidade do Laboratório e do Ambiente Corporativo](#2447-evidências-de-confiabilidade-do-laboratório-e-do-ambiente-corporativo)
    - [24.48 Garantias de Confiabilidade do Laboratório e do Ambiente Corporativo](#2448-garantias-de-confiabilidade-do-laboratório-e-do-ambiente-corporativo)

- [25. Garantias de Confiabilidade e Recuperação](#25-garantias-de-confiabilidade-e-recuperação)
    - [25.1 A Falha É Esperada](#251-a-falha-é-esperada)
    - [25.2 Estado Durável Precede o Progresso](#252-estado-durável-precede-o-progresso)
    - [25.3 Capacidade de Reinicialização](#253-capacidade-de-reinicialização)
    - [25.4 Recuperação Idempotente](#254-recuperação-idempotente)
    - [25.5 Progresso Explícito do Processamento](#255-progresso-explícito-do-processamento)
    - [25.6 Classificação de Falhas](#256-classificação-de-falhas)
    - [25.7 Isolamento de Falhas](#257-isolamento-de-falhas)
    - [25.8 Nenhuma Perda Silenciosa](#258-nenhuma-perda-silenciosa)
    - [25.9 Nenhuma Corrupção Silenciosa](#259-nenhuma-corrupção-silenciosa)
    - [25.10 Novas Tentativas Limitadas](#2510-novas-tentativas-limitadas)
    - [25.11 Tratamento de Falhas Persistentes](#2511-tratamento-de-falhas-persistentes)
    - [25.12 Quarentena É Estado Governado](#2512-quarentena-é-estado-governado)
    - [25.13 Backpressure Antes da Perda](#2513-backpressure-antes-da-perda)
    - [25.14 Seleção da Fonte de Recuperação](#2514-seleção-da-fonte-de-recuperação)
    - [25.15 Limite Confiável Apropriado Mais Recente](#2515-limite-confiável-apropriado-mais-recente)
    - [25.16 Hierarquia das Fontes de Recuperação](#2516-hierarquia-das-fontes-de-recuperação)
    - [25.17 Replay](#2517-replay)
    - [25.18 Reprocessamento](#2518-reprocessamento)
    - [25.19 Backfill](#2519-backfill)
    - [25.20 Rebuild](#2520-rebuild)
    - [25.21 Capacidade de Recuperação Histórica](#2521-capacidade-de-recuperação-histórica)
    - [25.22 Reprodução e Reapresentação Históricas](#2522-reprodução-e-reapresentação-históricas)
    - [25.23 Recuperação e Governança Atual](#2523-recuperação-e-governança-atual)
    - [25.24 Recuperação de Backlog](#2524-recuperação-de-backlog)
    - [25.25 Capacidade de Recuperação](#2525-capacidade-de-recuperação)
    - [25.26 Proteção da Janela de Recuperação](#2526-proteção-da-janela-de-recuperação)
    - [25.27 Proteção da Certified Gold](#2527-proteção-da-certified-gold)
    - [25.28 Publicação Fail-Safe](#2528-publicação-fail-safe)
    - [25.29 Rollback](#2529-rollback)
    - [25.30 Nenhum Estado Reconhecidamente Confiável](#2530-nenhum-estado-reconhecidamente-confiável)
    - [25.31 A Recuperação É Multidimensional](#2531-a-recuperação-é-multidimensional)
    - [25.32 Validação da Recuperação](#2532-validação-da-recuperação)
    - [25.33 Evidências de Recuperação](#2533-evidências-de-recuperação)
    - [25.34 Testes de Recuperação](#2534-testes-de-recuperação)
    - [25.35 Evidências Podem Alterar a Arquitetura](#2535-evidências-podem-alterar-a-arquitetura)
    - [25.36 RPO](#2536-rpo)
    - [25.37 RTO](#2537-rto)
    - [25.38 Disponibilidade e Atualidade](#2538-disponibilidade-e-atualidade)
    - [25.39 Confiabilidade e Alta Disponibilidade](#2539-confiabilidade-e-alta-disponibilidade)
    - [25.40 Recuperação de Desastre](#2540-recuperação-de-desastre)
    - [25.41 Independência dos Domínios de Falha](#2541-independência-dos-domínios-de-falha)
    - [25.42 Observabilidade da Recuperação](#2542-observabilidade-da-recuperação)
    - [25.43 Convergência da Recuperação](#2543-convergência-da-recuperação)
    - [25.44 Afirmações de Confiabilidade](#2544-afirmações-de-confiabilidade)
    - [25.45 Limite do Laboratório](#2545-limite-do-laboratório)
    - [25.46 Evolução Corporativa](#2546-evolução-corporativa)
    - [25.47 Teatro de Confiabilidade É Rejeitado](#2547-teatro-de-confiabilidade-é-rejeitado)
    - [25.48 Princípio de Encerramento](#2548-princípio-de-encerramento)

---

## 1. Propósito

O propósito deste documento é definir a **arquitetura de confiabilidade e recuperação** da **camada de Engenharia de Dados** dentro da **Atlas Engineering — Enterprise Data Platform**.

Este documento estabelece como a plataforma detecta, contém, tolera e se recupera de falhas, preservando a integridade dos dados, a correção do processamento, a recuperabilidade e a disponibilidade analítica governada.

Ele define os princípios e as estratégias arquiteturais necessários para tratar:

- falhas de componentes e dependências;
- falhas de processamento transitórias e persistentes;
- novas tentativas e reentrega;
- capacidade de reinicialização idempotente;
- *checkpoints* e progresso do processamento;
- acúmulo de *backlog* e recuperação do atraso;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- seleção da fonte de recuperação;
- falhas parciais e isolamento de falhas;
- registros problemáticos (*poison records*);
- disponibilidade e *rollback* da Certified Gold;
- recuperação entre versões históricas;
- Objetivo de Ponto de Recuperação (*Recovery Point Objective — RPO*);
- Objetivo de Tempo de Recuperação (*Recovery Time Objective — RTO*);
- disponibilidade, alta disponibilidade e recuperação de desastre;
- observabilidade da recuperação;
- validação e evidências de recuperação.

O documento complementa a documentação mais ampla de **Arquitetura de Engenharia de Dados** e **Fluxo de Dados e Processamento**.

A **Arquitetura de Engenharia de Dados** define a estrutura de alto nível, as responsabilidades, os limites e o fluxo normal de ponta a ponta da plataforma.

**Fluxo de Dados e Processamento** define como os dados percorrem e são processados na plataforma, incluindo as semânticas de processamento necessárias para idempotência, capacidade de *replay*, certificação e *rebuild*.

Este documento concentra-se especificamente no comportamento da plataforma quando o processamento normal é interrompido, degradado, invalidado ou precisa ser reconstruído.

O princípio orientador é:

**Falha É Esperada → O Estado Durável Deve Ser Conhecido → A Recuperação Deve Ser Controlada → A Correção Deve Ser Revalidada**

O retorno de um componente a um estado operacional não demonstra, por si só, que o pipeline de dados foi recuperado corretamente.

A Atlas Engineering, portanto, distingue entre:

**Recuperação do Componente**  
→ a tecnologia ou o serviço afetado volta a operar.

**Recuperação do Processamento**  
→ o processamento interrompido ou acumulado é retomado e alcança um estado de processamento controlado.

**Recuperação dos Dados**  
→ os dados necessários são restaurados, reproduzidos por *replay*, reprocessados ou reconstruídos a partir de uma fonte de recuperação apropriada.

**Recuperação da Correção**  
→ qualidade, reconciliação, certificação, linhagem e outros controles aplicáveis demonstram que os dados recuperados são válidos para o uso pretendido.

A recuperação é considerada concluída somente quando o nível de recuperação exigido pela capacidade afetada tiver sido demonstrado.

O laboratório da Versão 1 foi projetado para validar comportamentos representativos de falha e recuperação sob condições controladas. Os resultados do laboratório devem permanecer limitados à topologia, à carga de trabalho, à retenção, à implementação e aos cenários de falha efetivamente testados e não devem ser apresentados como garantias de disponibilidade em nível de produção ou de recuperação de desastre sem evidências que as sustentem.

---

## 2. Contexto de Confiabilidade e Recuperação

A Atlas Engineering é uma plataforma de dados distribuída composta por tecnologias independentes, estágios de processamento, armazenamentos duráveis e limites de publicação governados.

Um fluxo normal de ponta a ponta pode depender de:

**AtlasCommerce → SQL Server CDC → Debezium → Kafka → Bronze → Silver → Gold → Certificação → Certified Gold → Power BI**

Cada limite introduz diferentes modos de falha, características de durabilidade, mecanismos de recuperação e dependências operacionais.

Uma falha pode, portanto, afetar:

- um componente;
- um estágio de processamento;
- uma partição de dados;
- uma execução;
- um evento ou grupo de eventos;
- um produto de dados;
- uma dependência;
- várias camadas *downstream*;
- todo o fluxo analítico.

A plataforma não deve assumir que as falhas ocorrem somente como indisponibilidades completas de serviços.

Um componente pode permanecer tecnicamente disponível enquanto:

- o processamento estiver interrompido;
- o processamento estiver atrasado;
- o atraso do consumidor estiver aumentando;
- uma dependência estiver indisponível;
- um subconjunto de registros falhar repetidamente;
- os *checkpoints* não avançarem mais;
- os dados *downstream* se tornarem desatualizados;
- uma versão candidata da Gold não puder ser certificada;
- os consumidores analíticos continuarem visualizando uma versão certificada anterior.

A confiabilidade deve, portanto, ser avaliada sob duas perspectivas:

**Perspectiva do Serviço**  
→ os componentes necessários da plataforma estão operacionais?

e:

**Perspectiva dos Dados**  
→ os dados governados continuam fluindo, permanecem recuperáveis e alcançam o estado confiável esperado?

### 2.1 Falha como Condição Esperada

A Atlas Engineering trata a falha como uma condição operacional esperada, e não como um evento arquitetural excepcional.

A plataforma deve ser projetada considerando que, em algum momento:

- um processo irá parar;
- uma dependência ficará indisponível;
- uma conexão falhará;
- uma credencial expirará ou se tornará inválida;
- um evento será entregue mais de uma vez;
- um registro falhará repetidamente;
- o processamento ficará atrasado;
- uma implantação interromperá uma execução;
- um defeito de transformação exigirá uma correção histórica;
- um estado *downstream* precisará ser reconstruído.

O objetivo não é projetar uma plataforma na qual falhas nunca ocorram.

O objetivo é garantir que uma falha não produza automaticamente perda de dados não controlada, corrupção, duplicação, publicação inconsistente ou um estado de processamento irreversível.

### 2.2 Confiabilidade

Confiabilidade é a capacidade da plataforma de continuar produzindo ou eventualmente restaurar um comportamento governado correto apesar de falhas e interrupções esperadas.

A confiabilidade inclui propriedades como:

- estado intermediário durável;
- capacidade de reinicialização;
- capacidade de novas tentativas;
- reentrega controlada;
- processamento idempotente;
- gerenciamento de *checkpoints*;
- isolamento de falhas;
- tolerância a *backlog*;
- capacidade de *replay*;
- capacidade de *rebuild*;
- publicação recuperável;
- progresso observável do processamento.

Confiabilidade não significa que todos os componentes devem permanecer continuamente disponíveis.

Uma plataforma pode tolerar uma interrupção temporária e ainda permanecer confiável se preservar estado suficiente para se recuperar corretamente posteriormente.

### 2.3 Recuperação

Recuperação é o processo controlado de restaurar a capacidade necessária da plataforma após uma falha, interrupção, invalidação ou perda de estado.

Dependendo da falha, a recuperação pode exigir:

- reiniciar um componente;
- reconectar a uma dependência;
- repetir uma operação;
- reentregar um evento;
- retomar a partir de um *checkpoint*;
- processar o *backlog* acumulado;
- executar *replay* dos eventos retidos;
- reprocessar dados históricos;
- executar um *backfill*;
- executar um *rebuild* de uma camada derivada;
- restaurar a partir de um *backup*;
- executar *rollback* de uma versão analítica publicada.

O mecanismo de recuperação deve ser selecionado de acordo com o estado afetado e o objetivo de recuperação.

Nem toda falha exige *replay*.

Nem toda correção de dados exige *rebuild*.

Nem toda reinicialização de componente constitui uma recuperação.

### 2.4 A Recuperação Considera o Estado

As decisões de recuperação devem ser baseadas no estado que permanece durável e confiável após a falha.

A plataforma deve determinar:

- qual estado foi persistido com sucesso;
- qual progresso de processamento foi confirmado;
- quais dados podem ser entregues novamente;
- quais dados podem não ter sido processados;
- quais saídas *downstream* foram produzidas;
- quais saídas permanecem confiáveis;
- quais fontes de recuperação permanecem disponíveis;
- quais definições históricas são necessárias para interpretar essas fontes.

A recuperação não deve depender de suposições sobre onde o processamento provavelmente foi interrompido.

O estado durável e o progresso observável devem fornecer a base para a decisão.

### 2.5 Propagação de Falhas

Uma falha em um componente pode propagar sintomas para estágios *downstream* sem que todos os componentes *downstream* falhem tecnicamente.

Por exemplo:

**Debezium indisponível**  
→ nenhum novo evento Kafka  
→ Bronze não recebe novos dados  
→ Silver deixa de avançar  
→ Gold permanece inalterada  
→ Certified Gold permanece disponível, mas progressivamente desatualizada.

Nesse cenário, o Power BI pode continuar operando normalmente enquanto a plataforma analítica deixa de estar atualizada.

Outro exemplo:

**Falha na transformação da Silver**  
→ Bronze continua recebendo dados  
→ Kafka continua operando  
→ captura na origem permanece saudável  
→ *checkpoint* da Silver deixa de avançar  
→ Gold não recebe novas entradas válidas.

A arquitetura deve, portanto, distinguir a **origem da falha** de seus **efeitos *downstream***.

### 2.6 Falha Parcial

O processamento distribuído permite que algumas partes da plataforma permaneçam saudáveis enquanto outra parte esteja degradada ou indisponível.

Exemplos incluem:

- uma partição Kafka acumulando atraso;
- uma entidade falhando na transformação enquanto outras continuam;
- um produto de dados Gold falhando na certificação;
- uma dependência ficando indisponível;
- um registro problemático (*poison record*) falhando repetidamente;
- um produto analítico permanecendo em sua versão certificada anterior.

Quando for seguro e tecnicamente suportado, a plataforma deve isolar as falhas em vez de interromper desnecessariamente o processamento não relacionado.

O isolamento não deve permitir que estados inválidos ou incompletos atravessem limites governados.

### 2.7 Estado Durável

A recuperação depende de conhecer quais estados da plataforma são duráveis.

Estados duráveis representativos podem incluir:

- dados da origem SQL Server;
- histórico do CDC enquanto retido;
- eventos Kafka enquanto retidos;
- dados históricos da Bronze;
- estado persistido da Silver;
- versões candidatas da Gold;
- versões da Certified Gold;
- *checkpoints* e metadados de processamento;
- *backups* e arquivos de retenção quando implementados.

Esses estados não possuem o mesmo valor para recuperação.

Sua adequação depende de:

- retenção;
- completude;
- integridade;
- interpretabilidade;
- objetivo do processamento;
- disponibilidade de versões históricas;
- confiabilidade.

A hierarquia das fontes de recuperação é definida posteriormente neste documento.

### 2.8 Estado Derivado

Silver, Gold e Certified Gold contêm estados derivados de entradas e definições de processamento anteriores da plataforma.

O estado derivado deve ser reproduzível quando os dados de origem necessários, as definições de processamento, os metadados e a interpretação histórica permanecerem disponíveis.

Isso não significa que todo estado derivado deva sempre ser reconstruído a partir da fonte mais antiga possível.

A recuperação deve utilizar a fonte confiável mais apropriada para o objetivo necessário.

A arquitetura deve preservar informações suficientes para explicar como um estado derivado recuperado foi produzido.

### 2.9 Recuperação e Correção dos Dados

A recuperação técnica e a correção dos dados são preocupações distintas.

Por exemplo:

**Consumidor Kafka Reiniciado**  
→ a recuperação do componente pode estar concluída.

Mas, se os eventos foram processados novamente:

→ o tratamento de duplicidades ainda deve estar correto.

Se o processamento foi interrompido:

→ a continuidade do *checkpoint* ainda deve ser validada.

Se os dados *downstream* foram alterados:

→ qualidade e reconciliação ainda podem ser necessárias.

Se foi executado um *rebuild* da Gold:

→ a certificação ainda deve ocorrer antes da publicação.

A plataforma deve, portanto, validar as consequências da recuperação, e não apenas o sucesso da própria operação de recuperação.

### 2.10 Recuperação e Publicação Governada

A Certified Gold fornece um limite controlado de disponibilidade analítica.

Uma falha no processamento *upstream* não exige automaticamente a remoção da última versão certificada conhecida como válida.

Quando apropriado:

**Falha no Processamento *Upstream***  
→ nova versão candidata indisponível ou inválida  
→ certificação não avança  
→ Certified Gold anterior permanece visível aos consumidores.

Isso permite que a plataforma distinga:

**Degradação da Atualidade**

de:

**Perda da Disponibilidade Analítica**

Um produto certificado desatualizado, mas conhecido como válido, pode ser preferível à publicação de um estado mais recente não validado.

### 2.11 Recuperação e Interpretação Histórica

A recuperação histórica pode exigir mais do que dados históricos.

O *rebuild* correto também pode depender de informações históricas como:

- contratos de eventos;
- *schemas*;
- lógica de transformação;
- regras de qualidade;
- definições de reconciliação;
- definições da Gold;
- metadados;
- contexto de certificação.

Reter os dados sem reter as informações necessárias para interpretá-los pode criar uma fonte de recuperação inutilizável.

A arquitetura de recuperação deve, portanto, permanecer alinhada ao versionamento, à linhagem e à governança de metadados.

### 2.12 Recuperação e Observabilidade

Uma plataforma recuperável deve tornar observável o estado relevante para a recuperação.

A plataforma deve ser capaz de determinar, quando aplicável:

- se um componente está disponível;
- se o processamento está avançando;
- o *checkpoint* ou progresso atual;
- o atraso do consumidor;
- o tamanho do *backlog*;
- a latência do processamento;
- a atividade de novas tentativas;
- falhas persistentes;
- o estado da execução da recuperação;
- o estado da certificação da versão candidata;
- a atualidade da Certified Gold.

A observabilidade não executa a recuperação.

Ela fornece as informações necessárias para detectar a falha, selecionar as ações de recuperação, acompanhar o progresso e validar o estado resultante.

Os requisitos detalhados de observabilidade são definidos no documento especializado de arquitetura **Observabilidade**.

### 2.13 Recuperação e Segurança

A recuperação deve preservar os controles de segurança e governança aplicáveis.

A atividade de recuperação não deve se tornar justificativa para:

- credenciais sem restrições;
- acesso elevado permanente;
- autorização ignorada;
- proteção de transporte desabilitada;
- exposição não controlada de dados sensíveis;
- restauração de credenciais revogadas;
- publicação sem a validação necessária.

Os requisitos específicos de recuperação relacionados à segurança são definidos em **Segurança e Governança**.

Este documento concentra-se na confiabilidade e na recuperação do processamento de dados, preservando esses limites de segurança.

### 2.14 Recuperação e Evidências

As afirmações de recuperação devem ser sustentadas por comportamento observado.

Evidências representativas podem demonstrar:

- estado inicial;
- falha injetada ou observada;
- limite de processamento afetado;
- estado durável preservado;
- fonte de recuperação selecionada;
- ação de recuperação;
- comportamento do *backlog*;
- progressão do *checkpoint*;
- estado resultante dos dados;
- resultados de qualidade e reconciliação;
- estado da certificação;
- estado final visível ao consumidor;
- tempo de recuperação decorrido.

As evidências permitem ao projeto distinguir entre:

**Recuperação Projetada**

e:

**Recuperação Demonstrada**

A Versão 1 deve priorizar o comportamento medido em laboratório em vez de premissas de nível de produção sem suporte.

### 2.15 Princípio do Contexto de Confiabilidade

O modelo de confiabilidade da Atlas Engineering baseia-se na seguinte progressão:

**Falha Ocorre**  
→ identificar o limite afetado  
→ determinar o estado durável preservado  
→ determinar a fonte de recuperação confiável  
→ selecionar o mecanismo de recuperação apropriado  
→ retomar ou reconstruir o processamento  
→ validar o estado resultante dos dados  
→ restaurar a disponibilidade governada  
→ preservar as evidências.

A plataforma deve, portanto, ser projetada não apenas para reiniciar após uma falha, mas para **recuperar de forma previsível, explicável e verificável**.

---

## 3. Princípios de Confiabilidade

A confiabilidade da Atlas Engineering baseia-se em propriedades arquiteturais que permitem à plataforma tolerar interrupções, preservar estado recuperável, retomar o processamento, reconstruir dados derivados e validar o estado resultante.

A confiabilidade não deve depender da premissa de que todos os componentes permanecem continuamente disponíveis ou de que toda execução é concluída com sucesso na primeira tentativa.

O modelo orientador é:

**Durabilidade → Capacidade de Reinicialização → Idempotência → Isolamento → Recuperabilidade → Validação**

### 3.1 Falha É Esperada

Falhas são esperadas durante a vida operacional da plataforma.

Possíveis causas incluem:

- interrupção de serviço;
- indisponibilidade de dependência;
- falha de rede;
- falha de credencial;
- esgotamento de recursos;
- interrupção de implantação;
- dados malformados ou inesperados;
- defeitos de processamento;
- falha de infraestrutura;
- erros de configuração.

A arquitetura deve, portanto, definir o comportamento diante de falhas, em vez de tratar a recuperação como uma atividade manual excepcional projetada somente após a ocorrência de um incidente.

### 3.2 Preservar Antes de Avançar

O progresso do processamento não deve avançar além do estado que a plataforma consegue recuperar com segurança.

Quando o processamento depender de persistência durável, o estado relevante deverá ser persistido com sucesso antes que o progresso seja considerado confirmado.

O princípio é:

**Persistir Estado Necessário → Confirmar Sucesso → Avançar Progresso**

Isso reduz o risco de confirmar trabalho que posteriormente não possa ser reconstruído.

O mecanismo exato de persistência e *checkpoint* pode variar conforme o componente e o estágio de processamento.

### 3.3 Capacidade de Reinicialização

Os componentes de processamento devem ser capazes de reiniciar sem exigir uma reconstrução manual não controlada.

Após uma interrupção, um componente deve ser capaz de determinar, quando aplicável:

- o último estado de processamento confirmado;
- qual trabalho permanece incompleto;
- qual entrada pode ser entregue novamente;
- qual saída pode já existir;
- de onde o processamento pode retomar com segurança.

A capacidade de reinicialização depende de estado durável e de regras determinísticas de recuperação, e não de suposições sobre a última operação executada em memória.

### 3.4 Idempotência

Quando novas tentativas, reentrega, *replay* ou reinicialização puderem fazer com que a mesma entrada lógica seja processada mais de uma vez, o processamento deverá ser projetado de forma que execuções repetidas não produzam resultados de negócio incorretos.

O princípio orientador é:

**Mesma Entrada Lógica + Mesma Definição de Processamento Aplicável → Mesmo Resultado de Negócio Esperado**

A idempotência pode ser implementada de maneiras diferentes entre as camadas.

Os mecanismos possíveis incluem:

- chaves de negócio estáveis;
- identificadores de eventos;
- lógica determinística de *merge*;
- deduplicação;
- processamento orientado à versão;
- sobrescrita controlada de estado derivado;
- persistência transacional quando suportada.

Idempotência não significa que uma operação seja executada fisicamente apenas uma vez.

Significa que execuções repetidas não criam um efeito adicional de negócio não intencional.

### 3.5 A Entrega *At-Least-Once* Não É um Defeito

A Atlas Engineering não exige que a arquitetura presuma que todo limite distribuído forneça entrega física *exactly-once*.

Um evento pode legitimamente ser entregue ou processado mais de uma vez devido a:

- novas tentativas;
- reinicialização do consumidor;
- recuperação de *offset*;
- *replay*;
- interrupção de rede;
- falha de confirmação.

O projeto *downstream* deve tolerar a semântica de entrega da tecnologia selecionada.

Quando a entrega puder ser repetida, a correção será alcançada por meio de progresso controlado e processamento idempotente, e não pela premissa de que uma entrega duplicada não pode ocorrer.

### 3.6 Nenhuma Perda Silenciosa de Dados

Uma falha não deve fazer com que dados desapareçam silenciosamente do fluxo de processamento governado.

Quando o processamento não puder continuar com sucesso, a plataforma deverá preservar informações suficientes para determinar:

- o que falhou;
- qual entrada foi afetada;
- se a entrada permanece recuperável;
- se o progresso do processamento avançou;
- qual estado *downstream* foi produzido;
- qual remediação é necessária.

Um registro que não possa ser processado atualmente deve entrar em um estado explícito de falha, quando suportado, em vez de ser descartado silenciosamente.

### 3.7 Nenhuma Corrupção Silenciosa

Uma execução técnica bem-sucedida não justifica aceitar um estado incorreto dos dados.

Os mecanismos de recuperação não devem, silenciosamente:

- duplicar efeitos de negócio;
- omitir registros necessários;
- misturar versões incompatíveis de processamento;
- ignorar controles de qualidade;
- ignorar reconciliação;
- publicar um estado incompleto;
- reinterpretar dados históricos usando uma definição incompatível sem governança explícita.

O resultado recuperado permanece sujeito aos controles de correção aplicáveis à camada afetada.

### 3.8 Estado Durável Antes do Estado Efêmero

A arquitetura de recuperação deve priorizar estado durável e interpretável em vez de estado transitório em memória.

Informações importantes para recuperação não devem existir somente em:

- memória do processo;
- contexto temporário de execução;
- saída do terminal;
- conhecimento de um operador.

Quando necessário para a recuperação, o estado deve ser persistido em um mecanismo durável apropriado.

Exemplos podem incluir:

- *offsets* Kafka;
- *checkpoints*;
- metadados de processamento;
- estado de execução;
- estado persistido das camadas;
- metadados de certificação.

### 3.9 A Recuperação Usa Progresso Explícito

O progresso do processamento deve ser explícito e observável quando necessário para uma recuperação segura.

Indicadores de progresso relevantes podem incluir:

- posição de captura do CDC;
- *offset* Kafka;
- *checkpoint* de processamento;
- identificador de lote ou execução;
- *watermark*;
- período de negócio processado;
- versão candidata;
- estado da certificação.

A plataforma não deve depender exclusivamente do tempo transcorrido ou da disponibilidade do serviço para inferir o progresso do processamento.

### 3.10 A Fonte de Recuperação Deve Ser Confiável

Uma fonte de recuperação tecnicamente disponível não é automaticamente uma fonte de recuperação apropriada.

A seleção deve considerar:

- completude;
- durabilidade;
- retenção;
- integridade;
- interpretabilidade;
- versão aplicável;
- estado de governança;
- confiabilidade.

O estado mais recente não é necessariamente o estado mais apropriado a partir do qual realizar a recuperação.

A estratégia de fontes de recuperação é definida posteriormente neste documento.

### 3.11 A Recuperação Deve Usar o Limite Apropriado

A recuperação deve começar a partir do limite confiável mais apropriado que possa atender ao objetivo de recuperação.

Por exemplo:

- uma falha transitória de processamento pode exigir apenas uma nova tentativa;
- uma interrupção do consumo pode ser retomada a partir de um *checkpoint*;
- o histórico retido no Kafka pode permitir *replay*;
- a Bronze pode permitir um *rebuild* histórico;
- uma Silver válida pode permitir o *rebuild* da Gold;
- um *backup* pode ser necessário quando o histórico online necessário não estiver mais disponível.

A recuperação a partir de um limite *upstream* ao necessário pode aumentar o custo e o tempo de recuperação.

A recuperação a partir de um limite *downstream* ao justificável pode preservar um estado inválido.

### 3.12 O Estado Derivado Deve Ser Reconstruível

Quando for praticável, o estado analítico derivado deve ser reconstruível a partir de um estado de origem governado e das definições de processamento aplicáveis.

Isso se aplica particularmente a:

- Silver;
- Gold;
- versões candidatas da Certified Gold.

A capacidade de reconstrução depende não apenas da retenção dos dados, mas também da retenção dos metadados, contratos, versões e definições de processamento necessários para interpretar esses dados corretamente.

Uma camada derivada não deve se tornar um estado irreversível e sem explicação simplesmente porque já foi calculada.

### 3.13 Isolamento de Falhas

Uma falha deve ser contida no menor escopo seguro, quando tecnicamente viável.

A plataforma deve evitar que uma falha localizada interrompa desnecessariamente o processamento não relacionado.

Os possíveis limites de isolamento podem incluir:

- registro;
- partição;
- entidade;
- estágio de processamento;
- produto de dados;
- dependência.

O isolamento não deve permitir que estados incompletos ou inválidos atravessem um limite governado.

A continuidade de processamento não relacionado é aceitável somente quando sua correção não depender do estado que apresentou falha.

### 3.14 *Backpressure* É Preferível à Perda Não Controlada

Quando o processamento *downstream* não puder acompanhar o ritmo de entrada dos dados, a arquitetura deve priorizar *backlog* controlado ou *backpressure* em vez de perda silenciosa de dados.

Um *backlog* crescente é uma condição operacional que pode ser observada e recuperada.

Uma entrada descartada ou sem rastreabilidade pode ser impossível de reconstruir.

A tolerância ao *backlog* permanece limitada por:

- retenção;
- armazenamento;
- capacidade de processamento;
- objetivos de recuperação;
- requisitos de atualidade dos dados *downstream*.

### 3.15 Novas Tentativas Devem Ser Limitadas e Observáveis

Novas tentativas são apropriadas para falhas que possam ser resolvidas sem alterar os dados ou a arquitetura subjacentes.

As novas tentativas não devem se transformar em ciclos infinitos e invisíveis.

Quando implementado, o comportamento de novas tentativas deve definir:

- condições de falha elegíveis;
- limite de novas tentativas ou política aplicável;
- atraso ou *backoff*, quando apropriado;
- observabilidade;
- comportamento diante de falha definitiva.

Uma falha persistente deve eventualmente se tornar um estado operacional explícito que exija investigação ou outro mecanismo de recuperação.

### 3.16 A Recuperação Não Deve Ignorar a Governança

As operações de recuperação permanecem sujeitas aos controles de governança aplicáveis ao processamento normal.

A recuperação não deve ignorar automaticamente:

- controle de acesso;
- classificação de dados;
- tratamento de privacidade;
- validação de qualidade;
- reconciliação;
- certificação;
- linhagem;
- retenção;
- auditabilidade.

A urgência altera a prioridade operacional.

Ela não elimina o requisito de restaurar um estado governado.

### 3.17 A Publicação Deve Falhar com Segurança

Uma falha no processamento ou na certificação de uma versão candidata não deve substituir automaticamente um estado conhecido como válido e visível aos consumidores.

O comportamento orientador é:

**Candidata Válida**  
→ certificar  
→ publicar.

**Candidata Inválida ou Incompleta**  
→ não publicar  
→ preservar a versão anterior conhecida como válida da Certified Gold, quando disponível.

Isso impede que uma falha de processamento se transforme automaticamente em uma falha de dados visível aos consumidores.

### 3.18 A Recuperação Deve Ser Observável

A recuperação deve expor informações suficientes para determinar:

- o que está sendo recuperado;
- qual fonte está sendo utilizada;
- de onde o processamento foi retomado;
- se o *backlog* está diminuindo;
- se as novas tentativas continuam;
- se os *checkpoints* avançam;
- se as falhas permanecem;
- se o estado *downstream* está atualizado;
- se a certificação foi retomada.

Um operador não deve precisar inferir a recuperação apenas pelo fato de um processo estar em execução.

### 3.19 A Recuperação Deve Ser Validada

A recuperação não está concluída quando o comando de recuperação é executado com sucesso.

O estado resultante deve ser validado de acordo com a capacidade afetada.

A validação pode incluir:

- progresso do processamento;
- contagens de registros esperadas;
- deduplicação;
- qualidade;
- reconciliação;
- linhagem;
- certificação;
- atualização visível ao consumidor;
- limites de acesso;
- estado de segurança.

A profundidade de validação necessária depende do cenário de recuperação.

### 3.20 A Recuperação Deve Ser Baseada em Evidências

Cenários representativos de recuperação devem produzir evidências que demonstrem:

- falha;
- estado preservado;
- mecanismo de recuperação selecionado;
- execução da recuperação;
- estado resultante;
- validação;
- tempo decorrido, quando relevante;
- conclusão.

Isso permite que as afirmações de confiabilidade sejam baseadas em comportamento observado, e não apenas na intenção arquitetural.

### 3.21 Confiabilidade Não É Igual a Alta Disponibilidade

Uma plataforma confiável não fornece necessariamente disponibilidade contínua.

Um componente pode ficar temporariamente indisponível enquanto a arquitetura ainda preserva:

- estado durável;
- capacidade de reinicialização;
- recuperabilidade;
- correção;
- disponibilidade analítica controlada.

Alta Disponibilidade (HA) trata da redução da interrupção de serviço por meio de redundância e *failover*.

Confiabilidade é mais abrangente e inclui o comportamento correto antes, durante e depois de uma falha.

A Versão 1 não deve representar capacidade de reinicialização ou recuperabilidade como equivalentes à Alta Disponibilidade corporativa.

### 3.22 Os Objetivos de Recuperação Devem Ser Medidos

O Objetivo de Ponto de Recuperação (RPO) e o Objetivo de Tempo de Recuperação (RTO) não devem ser inventados apenas para fazer a arquitetura parecer pronta para produção.

Quando objetivos formais forem necessários, eles devem ser baseados em:

- requisitos de negócio;
- capacidades técnicas;
- retenção;
- arquitetura;
- comportamento de recuperação medido.

A Versão 1 deve primeiro medir cenários representativos de recuperação e preservar os resultados como evidências.

O tempo de recuperação medido em laboratório não é automaticamente um compromisso de RTO corporativo.

### 3.23 A Confiabilidade Evolui com as Evidências

A arquitetura de confiabilidade pode evoluir quando os testes demonstrarem que uma premissa está incorreta ou é insuficiente.

Por exemplo:

**Observado**  
→ a recuperação do *backlog* é mais lenta do que o esperado.

As possíveis respostas podem incluir:

- aumentar a capacidade de processamento;
- alterar o particionamento;
- alterar a estratégia de *checkpoint*;
- alterar a retenção;
- melhorar o desempenho das transformações;
- revisar o procedimento de recuperação.

As evidências devem poder influenciar a arquitetura.

As afirmações de confiabilidade não devem ser protegidas contra resultados de testes contraditórios.

### 3.24 Princípio de Confiabilidade

O modelo de confiabilidade da Atlas Engineering pode ser resumido como:

**Preservar Estado Durável**  
→ **Avançar o Progresso Explicitamente**  
→ **Esperar Reentrega**  
→ **Processar de Forma Idempotente**  
→ **Isolar a Falha**  
→ **Recuperar a Partir de um Limite Confiável**  
→ **Revalidar a Correção**  
→ **Restaurar a Disponibilidade Governada**  
→ **Preservar as Evidências**

A confiabilidade é demonstrada quando a plataforma consegue falhar, se recuperar e explicar por que o estado resultante permanece confiável.

---

## 4. Domínios de Falha e Classificação de Falhas

A Atlas Engineering deve classificar as falhas de acordo com o limite arquitetural afetado e a consequência para o processamento, o estado dos dados, a recuperabilidade e a disponibilidade analítica governada.

Uma falha não deve ser classificada exclusivamente pela tecnologia que a reportou.

O mesmo sintoma técnico pode ter diferentes consequências arquiteturais dependendo de:

- componente afetado;
- estágio de processamento afetado;
- estado durável já preservado;
- progresso do processamento;
- *backlog*;
- dependências *downstream*;
- impacto sobre o produto de dados;
- estado visível ao consumidor;
- fontes de recuperação disponíveis.

O modelo orientador é:

**Localização da Falha → Estado Afetado → Impacto no Processamento → Impacto Downstream → Escopo da Recuperação**

A classificação permite decisões consistentes sobre:

- novas tentativas;
- reinicialização;
- isolamento;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- *rollback*;
- escalonamento;
- validação.

### 4.1 Domínio de Falha

Um domínio de falha é o menor limite arquitetural dentro do qual uma falha pode ocorrer e produzir um impacto significativo na confiabilidade.

Os domínios de falha representativos incluem:

- banco de dados de origem;
- CDC;
- Debezium;
- Kafka;
- Bronze;
- Silver;
- Gold;
- certificação;
- publicação da Certified Gold;
- orquestração;
- armazenamento;
- rede;
- credenciais e autenticação;
- dependências de observabilidade;
- infraestrutura.

Os domínios de falha ajudam a determinar tanto o raio de impacto quanto a responsabilidade pela recuperação.

Um componente físico pode participar de mais de um domínio de falha lógico.

### 4.2 Escopo da Falha

O escopo da falha descreve quanto da plataforma é afetado.

Os escopos representativos incluem:

**Registro**  
→ uma entrada lógica não pode ser processada.

**Partição**  
→ o processamento associado a uma partição Kafka ou unidade de processamento equivalente é afetado.

**Entidade**  
→ uma entidade de negócio ou conjunto de dados não pode avançar.

**Estágio de Processamento**  
→ uma camada arquitetural não consegue processar novos trabalhos.

**Produto de Dados**  
→ um produto Gold ou Certified Gold não pode avançar.

**Dependência**  
→ vários componentes são afetados por uma única dependência compartilhada indisponível.

**Plataforma**  
→ uma falha ampla impede a maior parte ou todo o processamento de dados.

A recuperação deve visar o menor escopo seguro capaz de restaurar o comportamento correto.

### 4.3 Falha Transitória

Uma falha transitória é esperada para ser resolvida sem alterar os dados de negócio subjacentes ou a definição de processamento.

Exemplos podem incluir:

- interrupção temporária de rede;
- indisponibilidade temporária de dependência;
- contenção temporária de recursos;
- indisponibilidade temporária do serviço de autenticação;
- ordem de inicialização de serviços;
- indisponibilidade temporária de armazenamento.

Falhas transitórias são candidatas típicas a novas tentativas controladas.

As novas tentativas devem permanecer limitadas e observáveis.

Uma falha que persiste além da política de novas tentativas definida deve passar para um estado explícito de falha persistente.

### 4.4 Falha Persistente

Uma falha persistente não é resolvida por novas tentativas comuns.

Exemplos podem incluir:

- dados malformados;
- *schema* incompatível;
- configuração inválida;
- credencial revogada ou incorreta;
- permissão insuficiente;
- versão histórica necessária indisponível;
- defeito de transformação;
- esgotamento da capacidade de armazenamento;
- falha de qualidade repetida.

Falhas persistentes exigem investigação, remediação, isolamento ou um mecanismo de recuperação diferente.

Continuar tentando indefinidamente não constitui recuperação.

### 4.5 Falha Específica de Dados

Uma falha específica de dados está associada a um registro, evento, entidade, partição ou subconjunto limitado de dados enquanto a capacidade de processamento ao redor pode permanecer saudável.

Exemplos incluem:

- valor de campo inválido;
- estrutura de evento não suportada;
- *payload* malformado;
- premissa de transformação violada;
- chave de negócio não resolvida;
- valor *null* inesperado;
- relacionamento de referência inválido.

Quando for seguro, os dados afetados devem ser isolados enquanto o processamento válido não relacionado continua.

Os dados que falharam devem permanecer rastreáveis e recuperáveis.

### 4.6 Falha de Processamento

Uma falha de processamento impede que uma transformação ou estágio de processamento avance corretamente.

Exemplos incluem:

- exceção da aplicação;
- transformação com falha;
- configuração de processamento inválida;
- falha de *checkpoint*;
- falha de dependência;
- versão de processamento incompatível;
- esgotamento de recursos.

Uma falha de processamento pode afetar uma execução ou um estágio inteiro.

A recuperação depende de a entrada necessária e o último progresso confirmado permanecerem disponíveis.

### 4.7 Falha de Dependência

Uma falha de dependência ocorre quando um componente permanece operacional, mas não consegue executar sua responsabilidade porque outro serviço ou recurso necessário está indisponível.

Exemplos incluem:

- Debezium incapaz de acessar o SQL Server;
- Bronze incapaz de acessar o Kafka;
- Silver incapaz de acessar o armazenamento da Bronze;
- Gold incapaz de acessar a Silver;
- Airflow incapaz de iniciar um trabalho de processamento necessário;
- Power BI incapaz de acessar a Certified Gold.

O componente que reporta o erro não é necessariamente a origem da falha.

A análise da causa-raiz deve distinguir:

**Componente Afetado**

de:

**Dependência que Falhou**

### 4.8 Falha da Origem

Uma falha da origem afeta o AtlasCommerce ou as capacidades do SQL Server necessárias para a captura de dados.

Possíveis exemplos incluem:

- SQL Server indisponível;
- banco de dados do AtlasCommerce indisponível;
- problema relacionado ao log de transações ou ao CDC;
- CDC desabilitado inesperadamente;
- objeto necessário do CDC indisponível;
- falha de permissão na origem;
- problema de armazenamento na origem.

Uma falha da origem pode impedir que novas alterações entrem no pipeline analítico enquanto os dados históricos *downstream* permanecem disponíveis.

A recuperação deve determinar se as alterações necessárias da origem permanecem capturáveis após a restauração do serviço.

### 4.9 Falha do CDC

Uma falha do CDC afeta a capacidade da plataforma de preservar o histórico ordenado das alterações da origem necessário ao Debezium.

Possíveis condições incluem:

- processo de captura indisponível;
- metadados do CDC indisponíveis;
- retenção removendo o histórico necessário antes da captura;
- divergência de configuração do CDC;
- aumento da latência de captura além dos limites seguros.

A falha do CDC é particularmente importante porque a perda do histórico de alterações necessário pode alterar o caminho de recuperação disponível.

Se o histórico ausente não puder mais ser capturado pelo CDC, a recuperação poderá exigir outra fonte governada, como *backfill* ou *rebuild* a partir de uma fonte histórica apropriada.

### 4.10 Falha do Debezium

Uma falha do Debezium pode interromper a transferência das alterações capturadas da origem para o Kafka.

Possíveis condições incluem:

- *connector* interrompido;
- falha de conectividade com o SQL Server;
- falha de conectividade com o Kafka;
- falha de autenticação;
- erro de configuração do *connector*;
- alteração incompatível na origem;
- falha interna do *connector*.

Quando o histórico necessário da origem permanece disponível, a recuperação do Debezium deve retomar a partir de seu progresso durável, em vez de exigir um *rebuild* completo do pipeline.

O procedimento de recuperação deve validar que nenhum intervalo necessário da origem foi perdido silenciosamente.

### 4.11 Falha do Kafka

As falhas do Kafka podem afetar:

- publicação de eventos;
- disponibilidade de eventos;
- progresso dos consumidores;
- liderança de partições;
- disponibilidade do *broker*;
- histórico de recuperação retido.

O impacto arquitetural depende de os eventos necessários permanecerem duráveis e disponíveis.

Uma interrupção temporária de um *broker* pode causar *backlog* sem perda de dados.

A perda do histórico necessário mantido pelo Kafka pode alterar a fonte de recuperação e aumentar o escopo da recuperação.

A disponibilidade do Kafka e sua recuperabilidade devem, portanto, ser avaliadas separadamente.

### 4.12 Falha da Bronze

Uma falha da Bronze pode impedir que eventos brutos governados sejam persistidos na fundação histórica analítica.

Possíveis condições incluem:

- falha do consumidor;
- falha de armazenamento;
- falha no tratamento do *schema*;
- falha de *checkpoint*;
- falha persistente de evento;
- defeito de processamento.

Quando o Kafka retiver os eventos necessários, a Bronze normalmente poderá ser recuperada por meio de retomada controlada ou *replay*.

A recuperação da Bronze deve preservar a fidelidade dos eventos brutos e não criar histórico de negócio duplicado de forma não intencional.

### 4.13 Falha da Silver

Uma falha da Silver afeta o processamento padronizado e conformado.

Possíveis condições incluem:

- defeito de transformação;
- tratamento inválido de *schema*;
- falha na resolução de referências;
- falha de *checkpoint*;
- falha de armazenamento;
- condição de dados inesperada.

A Bronze pode continuar acumulando entradas históricas válidas enquanto a Silver estiver indisponível.

A recuperação pode, portanto, envolver:

- reinicialização;
- nova tentativa;
- processamento do *backlog* acumulado;
- *replay* a partir da Bronze;
- reprocessamento;
- *rebuild* do estado afetado da Silver.

O mecanismo apropriado depende da falha e do estado já persistido.

### 4.14 Falha da Gold

Uma falha da Gold afeta a geração de produtos dimensionais ou analíticos.

Possíveis condições incluem:

- defeito de transformação;
- regra de negócio inválida;
- falha da dependência Silver;
- falha de qualidade;
- falha de reconciliação;
- falha de armazenamento;
- falha na geração da candidata.

A falha da Gold não invalida automaticamente a versão anterior da Certified Gold.

Quando a versão certificada anterior permanece confiável, o consumo analítico pode continuar enquanto a nova candidata é investigada ou reconstruída.

### 4.15 Falha de Certificação

Uma falha de certificação ocorre quando uma candidata Gold não satisfaz os controles necessários para a publicação governada.

Possíveis causas incluem:

- falha de qualidade bloqueante;
- falha de reconciliação;
- processamento incompleto;
- metadados obrigatórios ausentes;
- falha de linhagem;
- estado de versão inválido.

Uma falha de certificação não constitui necessariamente uma indisponibilidade da plataforma.

O comportamento correto geralmente é:

**Candidata Falha**  
→ não publicar  
→ preservar evidências  
→ investigar  
→ remediar  
→ revalidar.

A versão anterior conhecida como válida da Certified Gold deve permanecer disponível quando apropriado.

### 4.16 Falha de Publicação

Uma falha de publicação ocorre depois que uma candidata satisfez os requisitos de certificação, mas não consegue se tornar corretamente visível aos consumidores.

Possíveis causas incluem:

- falha do mecanismo de publicação;
- falha de armazenamento;
- falha de permissão;
- falha da troca atômica;
- falha na atualização de metadados.

A publicação deve falhar de forma segura.

Uma publicação com falha não deve deixar os consumidores observando uma mistura não controlada do estado certificado antigo e novo.

A última versão publicada conhecida como válida deve permanecer identificável.

### 4.17 Falha de Orquestração

O Airflow coordena a execução, mas não é o armazenamento autoritativo dos dados de negócio.

Uma falha de orquestração pode impedir que um processamento agendado ou dependente seja iniciado enquanto os dados subjacentes permanecem duráveis.

Possíveis condições incluem:

- falha do *scheduler*;
- falha do *worker*;
- falha de DAG;
- falha do banco de dados de metadados;
- erro no estado de uma dependência;
- tempo limite da tarefa.

A recuperação deve distinguir:

**Estado da Orquestração**

de:

**Estado do Processamento de Dados**

A execução novamente da orquestração não deve assumir que nenhum trabalho subjacente foi concluído antes da falha da orquestração.

### 4.18 Falha de Armazenamento

Uma falha de armazenamento pode afetar uma ou mais camadas duráveis da plataforma.

Possíveis condições incluem:

- MinIO indisponível;
- disco indisponível;
- capacidade esgotada;
- falha na gravação de objeto;
- corrupção de objeto;
- inconsistência de metadados.

A recuperação depende de:

- quais dados foram afetados;
- se a gravação foi confirmada;
- se existe outra fonte durável;
- se o estado afetado é derivado ou autoritativo;
- se há *backup* ou *rebuild* disponível.

Uma falha de armazenamento envolvendo uma fonte de recuperação autoritativa pode ter maior impacto do que a falha de uma camada totalmente reconstruível.

### 4.19 Falha de Rede

Uma falha de rede pode interromper a comunicação enquanto os serviços e os dados armazenados permanecem saudáveis.

Possíveis efeitos incluem:

- interrupção da captura na origem;
- falha na publicação no Kafka;
- interrupção do consumidor;
- falha de acesso ao armazenamento;
- falha de orquestração;
- interrupção do consumo analítico.

A recuperação da rede pode restaurar a conectividade sem restaurar automaticamente o progresso do processamento.

O *backlog*, o estado das novas tentativas, os *checkpoints* e a atualização dos dados *downstream* ainda devem ser avaliados.

### 4.20 Falha de Credencial e Autenticação

Uma falha de credencial ou autenticação pode interromper um serviço tecnicamente saudável.

Possíveis causas incluem:

- credencial expirada;
- credencial rotacionada não propagada;
- credencial revogada;
- segredo incorreto;
- falha de certificado;
- erro de configuração de identidade.

A recuperação da confiabilidade deve restaurar a operação legítima do serviço sem enfraquecer o limite de segurança.

A resposta específica de segurança a credenciais comprometidas permanece sob responsabilidade de **Segurança e Governança**.

### 4.21 Esgotamento de Recursos

O esgotamento de recursos pode causar degradação do processamento antes de uma falha completa do serviço.

Os recursos relevantes incluem:

- CPU;
- memória;
- disco;
- capacidade de armazenamento;
- *connection pools*;
- capacidade dos *workers*;
- capacidade do Kafka;
- largura de banda da rede.

Os sintomas podem incluir:

- aumento da latência;
- crescimento do *backlog*;
- *timeout* de tarefas;
- falhas de gravação;
- reinicializações repetidas;
- redução da vazão.

O esgotamento de recursos deve ser detectado antes que se transforme, quando possível, em perda irreversível de dados ou expiração da fonte de recuperação.

### 4.22 Falha de Configuração

Uma falha de configuração ocorre quando a configuração de execução implementada impede que a arquitetura pretendida opere corretamente.

Exemplos incluem:

- *endpoint* incorreto;
- configuração de tópico inválida;
- retenção incorreta;
- permissão incorreta;
- localização de *checkpoint* inválida;
- configuração de *schema* incorreta;
- configuração de serviço incompatível.

Falhas de configuração podem persistir após a reinicialização do serviço.

A recuperação, portanto, exige corrigir a configuração e validar o comportamento resultante, em vez de reiniciar repetidamente o componente afetado.

### 4.23 Falha de Implantação

Uma implantação pode introduzir interrupção, incompatibilidade ou estado parcialmente atualizado.

Possíveis cenários incluem:

- nova versão de processamento não inicia;
- apenas alguns componentes recebem a nova versão;
- versões de *schema* e processamento tornam-se incompatíveis;
- execução é interrompida durante a implantação;
- novo código produz saída inválida.

A recuperação da implantação pode exigir:

- *rollback*;
- reinicialização;
- *replay*;
- reprocessamento;
- restauração da versão anterior de processamento;
- *rebuild* do estado derivado afetado.

As informações de versão e linhagem devem permitir que a plataforma identifique quais saídas foram produzidas por qual implementação.

### 4.24 Falha de Qualidade de Dados

Uma falha de qualidade de dados significa que os dados não satisfazem uma regra de qualidade implementada.

Isso é diferente de uma falha técnica de processamento.

Por exemplo:

**Processamento**  
→ concluído com sucesso.

**Validação de Qualidade**  
→ falhou.

A resposta correta pode ser:

- quarentena;
- investigação;
- remediação;
- reprocessamento;
- certificação bloqueada.

Um pipeline tecnicamente bem-sucedido não deve transformar uma falha de qualidade em um *PASS* implícito.

### 4.25 Falha de Reconciliação

Uma falha de reconciliação indica que a consistência quantitativa ou semântica esperada não foi demonstrada entre um limite de processamento.

Exemplos podem incluir:

- registros ausentes;
- duplicidades inesperadas;
- divergência de contagem;
- divergência de valores;
- divergência inexplicada de agregações.

Uma falha de reconciliação pode indicar:

- defeito de processamento;
- recuperação incompleta;
- inconsistência da origem;
- transformação incorreta;
- falha no tratamento de duplicidades.

Quando a reconciliação for um controle bloqueante, a publicação não deve avançar até que a falha seja resolvida ou explicitamente governada.

### 4.26 Falha de Observabilidade

Uma falha de observabilidade reduz a capacidade da plataforma de detectar, diagnosticar, monitorar ou validar o comportamento de confiabilidade.

Exemplos incluem:

- métricas indisponíveis;
- *logs* indisponíveis;
- painéis indisponíveis;
- falha de alertas;
- telemetria de *checkpoint* ausente.

Uma falha de observabilidade não necessariamente interrompe o processamento de dados.

Entretanto, pode reduzir a confiança na determinação de que o processamento e a recuperação permanecem saudáveis.

Operações críticas de recuperação podem exigir validação adicional quando a observabilidade normal estiver indisponível.

### 4.27 Falha Composta

Múltiplas falhas podem ocorrer simultaneamente ou em sequência.

Por exemplo:

**Falha do Consumidor Kafka**  
→ *backlog* cresce  
→ armazenamento se aproxima da capacidade  
→ janela de retenção fica ameaçada.

Ou:

**Falha na Rotação de Credencial**  
→ Debezium para  
→ *backlog* do CDC cresce  
→ histórico necessário do CDC se aproxima da expiração.

Falhas compostas devem ser avaliadas de acordo com seu efeito combinado, e não como alertas isolados.

A prioridade da recuperação deve considerar se uma falha está reduzindo o tempo disponível para recuperar de outra.

### 4.28 Falha em Cascata

Uma falha em cascata ocorre quando uma falha provoca falhas ou degradação adicionais em outros componentes ou estágios de processamento.

Por exemplo:

**Armazenamento Indisponível**  
→ gravações na Bronze falham  
→ novas tentativas do consumidor aumentam  
→ *backlog* cresce  
→ risco de retenção do Kafka aumenta  
→ atualização dos dados *downstream* é degradada.

A arquitetura deve reduzir comportamentos de cascata desnecessários por meio de:

- novas tentativas limitadas;
- *backpressure*;
- isolamento;
- estado intermediário durável;
- transições controladas de falha.

### 4.29 Risco de Perda de Dados

Uma falha se torna um risco de perda de dados quando a plataforma pode perder acesso às informações necessárias antes que a recuperação seja concluída com sucesso.

Exemplos incluem:

- histórico do CDC aproximando-se da expiração da retenção;
- eventos Kafka aproximando-se da expiração da retenção;
- gravação com falha sem outra cópia durável;
- estado autoritativo corrompido sem *backup* recuperável.

O risco de perda de dados deve receber prioridade operacional maior do que uma degradação comum de atualização.

A plataforma deve expor, quando possível, a janela de recuperação restante.

### 4.30 Falha de Atualização

Uma falha de atualização ocorre quando os dados analíticos governados permanecem disponíveis, mas deixam de atender à atualidade esperada.

Por exemplo:

**Certified Gold**  
→ disponível e confiável  
→ não está mais atual porque o processamento *upstream* está atrasado.

A falha de atualização deve permanecer distinguível de:

- falha de correção dos dados;
- indisponibilidade analítica completa;
- perda dos dados da origem.

Essa distinção permite que a resposta operacional reflita o impacto real sobre os consumidores.

### 4.31 Falha de Correção

Uma falha de correção ocorre quando os dados disponíveis não podem ser considerados confiáveis para representar o resultado governado pretendido.

Possíveis causas incluem:

- duplicação;
- omissão;
- transformação incorreta;
- reconciliação inválida;
- versão de processamento incompatível;
- recuperação incorreta;
- interpretação histórica incorreta.

A falha de correção geralmente é mais grave do que uma degradação de atualização porque os consumidores podem receber informações enganosas.

Um resultado mais recente e incorreto não deve substituir automaticamente um resultado anterior conhecido como válido.

### 4.32 Falha de Disponibilidade

Uma falha de disponibilidade ocorre quando uma capacidade necessária não pode ser utilizada.

Exemplos incluem:

- origem indisponível;
- serviço de processamento indisponível;
- armazenamento indisponível;
- Certified Gold indisponível;
- *endpoint* analítico indisponível.

A disponibilidade deve ser avaliada no nível da capacidade, e não apenas no nível do processo.

Por exemplo, o processamento *upstream* pode estar indisponível enquanto a Certified Gold permanece disponível.

### 4.33 Falha de Recuperabilidade

Uma falha de recuperabilidade ocorre quando a plataforma não consegue restaurar o estado necessário utilizando os mecanismos de recuperação esperados.

Possíveis causas incluem:

- histórico necessário expirado;
- *backup* indisponível;
- *schema* histórico ausente;
- versão de processamento indisponível;
- fonte de recuperação corrompida;
- informações de *checkpoint* ausentes;
- linhagem insuficiente.

Uma falha de recuperabilidade pode existir mesmo antes da ocorrência de uma indisponibilidade ativa.

Por exemplo, um *backup* que nunca foi restaurado com sucesso representa uma recuperabilidade não comprovada.

### 4.34 Severidade da Falha

A severidade da falha deve refletir o impacto arquitetural, e não apenas o tipo de erro técnico.

Os fatores relevantes incluem:

- risco de perda de dados;
- risco de correção;
- risco de recuperabilidade;
- impacto sobre consumidores;
- classificação dos dados afetados;
- escopo afetado;
- duração;
- janela de recuperação restante;
- disponibilidade de fontes alternativas de recuperação.

A Versão 1 não exige um modelo corporativo de severidade de incidentes.

Os cenários de laboratório devem, contudo, registrar contexto suficiente para explicar por que uma falha exige maior urgência do que outra.

### 4.35 Registro de Classificação da Falha

Testes representativos de falha e eventos significativos de recuperação devem registrar, quando aplicável:

- identificador da falha;
- domínio da falha;
- escopo da falha;
- tipo de falha;
- componente afetado;
- dependência que falhou;
- dados afetados;
- progresso do processamento;
- impacto *downstream*;
- risco de perda de dados;
- risco de correção;
- risco de recuperabilidade;
- fontes de recuperação disponíveis;
- ação de recuperação selecionada;
- resultado final.

Essas informações apoiam análises de recuperação reproduzíveis e geração de evidências.

### 4.36 Princípio de Classificação de Falhas

A Atlas Engineering classifica as falhas de acordo com sua consequência arquitetural:

**Onde Falhou?**  
→ domínio da falha.

**Quanto Foi Afetado?**  
→ escopo da falha.

**É Temporária ou Persistente?**  
→ comportamento da falha.

**Qual Estado Está em Risco?**  
→ durabilidade e correção.

**O Que Continua Funcionando?**  
→ isolamento e disponibilidade.

**Por Quanto Tempo a Recuperação Pode Esperar?**  
→ janela de recuperação e risco de perda de dados.

**De Onde Podemos Recuperar?**  
→ fonte de recuperação confiável disponível.

**Como Sabemos que a Recuperação Foi Bem-Sucedida?**  
→ validação e evidências.

Uma classificação de falhas útil deve, portanto, descrever mais do que uma mensagem de erro.

Ela deve explicar o efeito da falha sobre **dados, processamento, consumidores e recuperabilidade**.

---

## 5. Estado Durável e Limites de Recuperação

A recuperação confiável depende da identificação de quais estados da plataforma permanecem disponíveis, interpretáveis e confiáveis após uma falha.

A Atlas Engineering contém múltiplos estados duráveis, mas eles não fornecem garantias de recuperação idênticas.

Um estado persistido pode ser:

- autoritativo para uma finalidade;
- derivado para outra;
- retido apenas temporariamente;
- incompleto para um objetivo específico de recuperação;
- dependente de definições históricas de processamento;
- não mais confiável após um defeito ou incidente.

A arquitetura deve, portanto, distinguir:

**Estado Durável**  
→ estado que sobrevive às condições de falha para as quais seu mecanismo de armazenamento foi projetado.

**Fonte de Recuperação**  
→ estado durável apropriado e confiável para um objetivo específico de recuperação.

**Limite de Recuperação**  
→ ponto arquitetural a partir do qual o processamento pode ser retomado com segurança ou submetido a *rebuild*.

O princípio orientador é:

**Persistido Não Significa Automaticamente Recuperável → Recuperável Não Significa Automaticamente Apropriado**

### 5.1 Estado Durável

Estado durável é a informação intencionalmente persistida além do tempo de vida de uma execução individual de processo.

Os estados duráveis representativos incluem:

- dados de origem do AtlasCommerce;
- histórico do CDC enquanto retido;
- eventos Kafka enquanto retidos;
- dados históricos da Bronze;
- estado persistido da Silver;
- estado candidato da Gold;
- versões da Certified Gold;
- *checkpoints*;
- metadados de processamento;
- metadados de versão;
- metadados de linhagem;
- *backups* e arquivos de arquivamento, quando implementados.

A durabilidade deve sempre ser interpretada de acordo com as garantias e o domínio de falha da tecnologia subjacente.

Um estado armazenado em disco não está automaticamente protegido contra todos os cenários de falha.

### 5.2 Estado Efêmero

Estado efêmero existe apenas durante o tempo de vida de uma execução, processo, contêiner, conexão ou operação temporária.

Exemplos podem incluir:

- estado de processamento em memória;
- transações não confirmadas;
- *buffers* temporários;
- variáveis locais;
- resultados intermediários não persistidos;
- estado transitório de novas tentativas;
- arquivos temporários que não sejam governados como artefatos de recuperação.

A recuperação não deve depender exclusivamente de estado efêmero.

Se uma informação for necessária para determinar o progresso seguro do processamento após uma reinicialização, ela deve ser persistida por meio de um mecanismo durável apropriado.

### 5.3 Estado Autoritativo e Derivado

A Atlas Engineering distingue entre o estado que representa uma entrada autoritativa para determinada responsabilidade e o estado derivado por meio do processamento.

Para o domínio de negócio operacional:

**AtlasCommerce**  
→ fonte transacional autoritativa.

Dentro da plataforma analítica:

**Kafka**  
→ histórico de eventos durável enquanto os eventos necessários permanecerem dentro da retenção.

**Bronze**  
→ principal fundação histórica analítica para *rebuild*.

**Silver**  
→ estado padronizado e conformado governado.

**Gold**  
→ estado dimensional ou analítico derivado.

**Certified Gold**  
→ estado analítico governado e visível ao consumidor.

A autoridade é contextual.

A Certified Gold é autoritativa para o consumo analítico governado, mas não é a fonte autoritativa a partir da qual o histórico operacional bruto deve normalmente ser submetido a *rebuild*.

### 5.4 Persistência Não Comprova Completude

Um conjunto de dados persistido com sucesso ainda pode ser incompleto para um objetivo de recuperação.

Por exemplo:

- o Kafka pode conter apenas eventos que ainda estejam dentro da retenção;
- a Bronze pode conter histórico apenas a partir do início da ingestão da plataforma;
- a Silver pode omitir intencionalmente atributos da origem;
- a Gold pode conter apenas projeções analíticas;
- a Certified Gold pode expor apenas o contrato governado para os consumidores;
- um *backup* pode representar apenas um ponto no tempo.

O planejamento da recuperação deve, portanto, avaliar se a fonte candidata contém todas as informações necessárias para o *rebuild* pretendido.

### 5.5 Persistência Não Comprova Confiabilidade

Um estado durável pode estar tecnicamente íntegro, mas ser inadequado para recuperação.

Exemplos incluem:

- saída produzida por uma lógica de transformação com defeito;
- dados criados usando uma versão incompatível do contrato;
- candidata Gold que falhou na reconciliação;
- versão produzida durante um incidente conhecido de integridade;
- *backup* contendo estado de segurança invalidado;
- dados incompletos persistidos antes da detecção da falha.

A seleção da fonte de recuperação deve considerar a confiabilidade, além da disponibilidade física.

### 5.6 Limite de Recuperação

Um limite de recuperação é um ponto arquitetural durável a partir do qual o processamento pode ser retomado com segurança ou submetido a *rebuild*.

Os limites representativos incluem:

- origem e CDC;
- Kafka;
- Bronze;
- Silver;
- versão Gold;
- versão Certified Gold;
- *backup* ou arquivo de arquivamento.

O limite apropriado depende de:

- localização da falha;
- estado afetado;
- objetivo da recuperação;
- histórico disponível;
- definições históricas;
- correção dos dados;
- tempo de recuperação;
- risco de recuperação.

A recuperação deve começar pelo limite confiável apropriado mais recente, e não automaticamente pelo estado disponível mais antigo ou mais recente.

### 5.7 Limite do Banco de Dados de Origem

O AtlasCommerce é a fonte transacional autoritativa para o estado de negócio sob sua responsabilidade.

Ele pode apoiar a recuperação quando:

- o estado atual da origem é suficiente;
- um *backfill* é necessário;
- o histórico retido do CDC é insuficiente;
- o histórico analítico pode ser submetido a *rebuild* a partir das informações da origem.

Entretanto, o estado transacional atual pode não reproduzir todos os eventos históricos ou valores anteriores que já existiram.

O banco de dados de origem, portanto, não deve ser considerado um substituto completo para a retenção histórica de eventos.

### 5.8 Limite do CDC

O SQL Server CDC preserva as alterações da origem por um período limitado, de acordo com sua retenção configurada e seu comportamento operacional.

Enquanto o histórico necessário permanecer disponível, o CDC fornece a fundação das alterações da origem consumidas pelo Debezium.

Seu valor para recuperação depende de:

- continuidade da captura;
- retenção;
- histórico necessário de logs/alterações;
- configuração;
- progresso do Debezium.

Se o histórico necessário do CDC expirar antes da captura ser concluída com sucesso, a retomada normal do *connector* poderá não ser mais suficiente.

Outro caminho de recuperação deverá então ser selecionado.

### 5.9 Limite do Kafka

O Kafka é a primeira fonte de recuperação preferencial para *replay* normal de eventos enquanto o histórico de eventos necessário permanecer retido e confiável.

O Kafka fornece:

- eventos duráveis e ordenados dentro das partições;
- retenção independente dos consumidores;
- *replay* a partir de *offsets* retidos;
- desacoplamento entre produção de eventos e processamento posterior.

A retenção do Kafka cria uma janela de recuperação on-line limitada.

Se os eventos necessários tiverem expirado, a recuperação deverá migrar para outro limite apropriado.

O Kafka é, portanto, um mecanismo de recuperação robusto, mas não um arquivo histórico permanente.

### 5.10 Limite da Bronze

A Bronze é a principal fundação histórica analítica para *rebuild*.

Ela preserva o histórico bruto governado dos eventos com metadados suficientes para suportar:

- *rebuild* independente de *replay*;
- reprocessamento;
- investigação histórica;
- *rebuild* de camadas posteriores;
- linhagem;
- interpretação orientada por versão.

A Bronze reduz a dependência da retenção do Kafka para recuperação analítica de longo prazo.

Seu valor para recuperação depende da preservação tanto dos dados históricos quanto dos metadados necessários para interpretar esses dados corretamente.

### 5.11 Limite da Silver

A Silver é o estado persistido padronizado e conformado.

Ela pode ser uma fonte de recuperação apropriada quando:

- o estado da Silver permanece confiável;
- o objetivo de recuperação não exige o *rebuild* da própria Silver;
- a definição histórica da Silver permanece compatível com o *rebuild* pretendido;
- as informações necessárias de linhagem e versão permanecem disponíveis.

Por exemplo, um defeito restrito à Gold pode permitir o *rebuild* da Gold a partir de uma Silver válida sem reproduzir o processamento da Bronze.

A Silver não deve ser usada como fonte de recuperação quando a falha ou o defeito puder ter comprometido a própria Silver.

### 5.12 Limite da Gold

A Gold representa o estado analítico derivado produzido para fins dimensionais ou analíticos.

Uma versão Gold pode apoiar operações limitadas de recuperação quando essa versão permanece:

- completa;
- validada;
- interpretável;
- apropriada ao objetivo de recuperação.

A Gold normalmente não deve substituir a Silver ou a Bronze como fundação geral para *rebuild* histórico.

Quando a própria lógica da Gold apresenta defeito, a recuperação deve começar a partir de um limite confiável anterior.

### 5.13 Limite da Certified Gold

A Certified Gold é o limite governado visível ao consumidor.

Seu principal valor para recuperação é a continuidade analítica e o *rollback*.

Quando uma nova candidata falha no processamento, na validação, na certificação ou na publicação:

**Certified Gold Anterior**  
→ pode permanecer disponível  
→ preserva o consumo analítico conhecido como válido.

A Certified Gold fornece, portanto, um limite de recuperação para a disponibilidade do consumidor.

Ela não substitui as fontes de recuperação anteriores necessárias para executar o *rebuild* de um estado analítico corrigido.

### 5.14 Estado de Checkpoint

Os *checkpoints* representam o progresso de processamento confirmado.

Dependendo do mecanismo de processamento, um *checkpoint* pode identificar:

- *offset* Kafka;
- *watermark*;
- lote;
- execução;
- intervalo de tempo processado;
- posição da origem;
- estado da versão.

O estado do *checkpoint* deve corresponder a um estado de processamento confirmado com sucesso.

A regra orientadora é:

**Saída Não Confirmada com Segurança**  
→ o progresso não deve ser tratado como confirmado com segurança.

Um *checkpoint* que avance além da saída durável pode causar omissão.

Um *checkpoint* que permaneça atrás da saída durável pode causar nova entrega.

A arquitetura prefere novas entregas seguras tratadas por meio de idempotência a omissões silenciosas.

### 5.15 Metadados de Processamento

Os metadados de processamento fornecem o contexto necessário para compreender e recuperar execuções.

Os metadados relevantes podem incluir:

- identificador da execução;
- horário de início e conclusão;
- limite de entrada;
- limite de saída;
- versão de processamento;
- *checkpoint*;
- contagens de registros;
- estado de falha;
- estado de novas tentativas;
- execução de recuperação;
- resultado de qualidade;
- resultado de reconciliação.

Os metadados de processamento fazem parte da recuperabilidade quando são necessários para determinar o que aconteceu e o que deve acontecer em seguida.

### 5.16 Metadados de Versão

A recuperação histórica pode depender do conhecimento sobre quais definições se aplicavam aos dados que estão sendo recuperados.

As dimensões de versão relevantes podem incluir:

- *schema* da origem;
- contrato de evento;
- interpretação da Bronze;
- processamento da Silver;
- processamento da Gold;
- regras de qualidade;
- regras de reconciliação;
- versão do produto certificado.

Dados sem contexto de versão suficiente podem permanecer fisicamente duráveis, mas tornar-se semanticamente difíceis ou impossíveis de submeter a *rebuild* corretamente.

### 5.17 Linhagem como Contexto de Recuperação

A linhagem ajuda a determinar a relação entre estados afetados e recuperáveis.

Para um cenário de recuperação, a linhagem pode ajudar a responder:

- qual origem ou quais eventos produziram os dados afetados;
- quais dados da Bronze contribuíram;
- qual estado da Silver foi utilizado;
- qual versão de processamento produziu a Gold;
- qual produto certificado foi publicado;
- quais consumidores posteriores podem ser afetados.

A linhagem não é, por si só, o dado de negócio recuperado.

Ela fornece o contexto necessário para selecionar e validar a recuperação corretamente.

### 5.18 Limite de Backup

O *backup* fornece uma fundação de recuperação quando o estado on-line necessário está indisponível, corrompido, perdido ou não é mais retido.

O *backup* pode ser necessário para cenários como:

- perda de armazenamento;
- perda do banco de dados;
- expiração do histórico on-line;
- recuperação de infraestrutura;
- recuperação de desastre mais ampla.

O *backup* não é automaticamente o primeiro mecanismo de recuperação para falhas comuns de processamento.

Quando Kafka, Bronze, Silver ou outro estado on-line governado puder atender ao objetivo com segurança, usar essas fontes pode proporcionar uma recuperação mais rápida e direcionada.

### 5.19 Limite de Arquivamento

Um estado arquivado pode apoiar a recuperação histórica quando permanece:

- completo para a finalidade pretendida;
- protegido;
- interpretável;
- governado;
- restaurável.

O arquivamento não garante recuperabilidade operacional imediata.

A recuperação a partir de um arquivo de arquivamento pode exigir tempo adicional de restauração antes que o processamento possa ser retomado.

O arquivamento, portanto, afeta tanto a capacidade de recuperação quanto o tempo de recuperação.

### 5.20 Hierarquia de Fontes de Recuperação

Para a recuperação analítica normal, a Atlas Engineering utiliza a seguinte preferência conceitual:

**Kafka**  
→ primeira fonte de recuperação enquanto o histórico de eventos necessário permanecer retido e confiável.

**Bronze**  
→ principal fundação histórica analítica para *rebuild* após a retenção do Kafka ou quando o processamento histórico posterior precisar ser reproduzido.

**Silver**  
→ fonte de recuperação válida para *rebuild* posterior quando a Silver permanecer confiável e apropriada.

**Backup / Arquivo de Arquivamento**  
→ fundação de recuperação quando o histórico on-line necessário estiver indisponível ou quando for necessária uma restauração de estado mais ampla.

Este é um modelo de preferência, não uma regra segundo a qual toda recuperação deve atravessar cada limite.

A fonte selecionada deve corresponder à falha real e ao objetivo da recuperação.

### 5.21 Seleção da Fonte de Recuperação

A seleção da fonte de recuperação deve avaliar:

1. O que falhou?
2. Qual estado pode estar inválido?
3. Qual estado permanece confiável?
4. Qual histórico é necessário?
5. Qual histórico permanece disponível?
6. Quais definições de processamento são necessárias?
7. Qual fonte de recuperação fornece o menor escopo seguro de *rebuild*?
8. Qual validação será necessária depois?

O estado disponível mais recente não é automaticamente o preferido.

O estado disponível mais antigo não é automaticamente mais seguro.

A fonte correta é o **estado confiável apropriado mais recente que pode satisfazer o objetivo da recuperação**.

### 5.22 Janela de Recuperação

Uma janela de recuperação é o período durante o qual determinada fonte de recuperação permanece utilizável para o mecanismo de recuperação pretendido.

Exemplos incluem:

- janela de retenção do CDC;
- janela de retenção do Kafka;
- retenção da Bronze;
- retenção de *backup*;
- disponibilidade do arquivo de arquivamento.

As janelas de recuperação podem se sobrepor.

Por exemplo:

**Janela de Recuperação do Kafka**  
→ *replay* on-line mais curto e rápido.

**Janela de Recuperação da Bronze**  
→ *rebuild* analítico mais longo.

**Janela de Backup / Arquivamento**  
→ recuperação potencialmente de mais longo prazo com maior custo de restauração.

A arquitetura deve compreender essas janelas antes que uma falha ocorra.

### 5.23 Esgotamento da Janela de Recuperação

Uma falha pode se tornar mais grave à medida que sua janela de recuperação disponível diminui.

Por exemplo:

**Debezium Parado**  
→ histórico do CDC ainda disponível  
→ recuperação normal possível.

Posteriormente:

**Debezium Continua Parado**  
→ histórico necessário do CDC se aproxima da expiração  
→ risco de perda de dados aumenta.

Após a expiração:

**Histórico Necessário do CDC Perdido**  
→ apenas reiniciar o *connector* não pode reconstruir o intervalo de alterações ausente.

A prioridade operacional deve, portanto, considerar não apenas o impacto atual da falha, mas também o **tempo restante antes que as opções de recuperação se deteriorem**.

### 5.24 Escalonamento do Limite de Recuperação

Quando um limite de recuperação preferencial não puder mais atender ao objetivo, a recuperação deverá avançar para um limite anterior ou mais amplo que seja confiável.

Por exemplo:

**Histórico Kafka disponível**  
→ *replay* a partir do Kafka.

Se não:

**Histórico Bronze disponível**  
→ executar o *rebuild* do processamento posterior a partir da Bronze.

Se a Bronze for insuficiente ou estiver indisponível:

**Origem / Backfill ou Backup / Arquivo de Arquivamento**  
→ selecionar de acordo com o estado histórico necessário e o cenário de falha.

O escalonamento deve ser explícito e observável.

Um limite de recuperação mais amplo geralmente aumenta:

- volume de processamento;
- tempo de recuperação;
- escopo de validação;
- complexidade operacional.

### 5.25 Independência dos Limites

A arquitetura de recuperação deve evitar dependência desnecessária de um único estado durável quando outro limite governado puder fornecer valor de recuperação independente.

Por exemplo, Kafka e Bronze possuem finalidades diferentes:

**Kafka**  
→ histórico de transporte retido e *replay* eficiente.

**Bronze**  
→ histórico analítico de maior duração e *rebuild*.

A Bronze não deve existir apenas como outra representação temporária do mesmo intervalo de retenção se sua finalidade arquitetural for o *rebuild* histórico.

Cada limite de recuperação deve justificar a propriedade de confiabilidade que fornece.

### 5.26 Recuperação e Domínios de Falha Compartilhados

Duas cópias persistidas não fornecem recuperação independente se compartilham o mesmo domínio de falha.

Por exemplo, duas cópias armazenadas no mesmo disco físico podem ser perdidas pela mesma falha de armazenamento.

Da mesma forma, um *backup* local no mesmo dispositivo que falhou pode oferecer pouca proteção contra a perda do dispositivo.

A arquitetura de recuperação deve, portanto, distinguir:

**Quantidade de Cópias Lógicas**

de:

**Independência do Domínio de Falha**

A Versão 1 pode intencionalmente conter domínios de falha físicos compartilhados.

Essas limitações devem permanecer explícitas.

### 5.27 Recuperação e Definições Históricas

Uma fonte de recuperação permanece útil apenas enquanto a plataforma consegue interpretá-la corretamente.

Se a Bronze contiver eventos históricos produzidos sob o Contrato V1, mas apenas o Contrato V3 permanecer compreensível, os dados poderão estar fisicamente presentes enquanto o *rebuild* confiável se torna impossível.

A plataforma deve, portanto, preservar as definições históricas por pelo menos o mesmo período durante o qual os dados governados retidos dependerem delas.

Isso se aplica a:

- *schemas*;
- contratos de eventos;
- lógica de transformação;
- definições de qualidade;
- definições de reconciliação;
- definições dimensionais;
- metadados relevantes.

### 5.28 Recuperação e Governança Atual

Dados históricos podem ser recuperados utilizando definições históricas e, ainda assim, permanecer sujeitos à governança atualmente aplicável.

Por exemplo, uma fonte histórica pode continuar tecnicamente reconstruível enquanto:

- uma credencial tiver sido revogada;
- a política de acesso tiver sido alterada;
- o tratamento de privacidade tiver sido alterado;
- a retenção tiver expirado;
- as regras de publicação tiverem sido alteradas.

A recuperação não deve restaurar silenciosamente um estado de governança obsoleto apenas porque ele existia quando os dados históricos foram originalmente produzidos.

### 5.29 Validação do Limite de Recuperação

Um limite de recuperação deve ser validado antes de ser utilizado como garantia de recuperação.

A validação representativa pode incluir:

- *replay* do Kafka a partir de um *offset* conhecido;
- *rebuild* da Silver a partir da Bronze;
- *rebuild* da Gold a partir da Silver;
- *rollback* para uma Certified Gold anterior;
- restauração de *backup*;
- restauração de arquivo de arquivamento, quando implementada;
- interpretação de versão histórica.

Uma fonte de recuperação documentada que nunca tenha sido exercitada com sucesso representa uma expectativa arquitetural, e não uma recuperabilidade demonstrada.

### 5.30 Estado Durável e Evidências de Recuperação

As evidências dos limites de recuperação podem identificar:

- fonte de recuperação;
- intervalo retido;
- domínio de falha;
- estado inicial;
- *checkpoint* de processamento;
- versão histórica;
- ação de recuperação;
- escopo submetido a *rebuild*;
- resultados da validação;
- tempo decorrido;
- estado final.

Essas evidências permitem ao projeto determinar quais limites de recuperação foram efetivamente demonstrados.

### 5.31 Garantias de Estado Durável e Limites de Recuperação

O modelo de estado durável da Atlas Engineering deve preservar as seguintes garantias:

1. a recuperação não depende exclusivamente de estado de execução efêmero;
2. estados duráveis não são considerados como tendo valor de recuperação idêntico;
3. a persistência, por si só, não comprova completude, confiabilidade ou recuperabilidade;
4. a recuperação começa a partir de um limite confiável apropriado;
5. o AtlasCommerce permanece como a fonte transacional autoritativa para seu domínio operacional;
6. o CDC fornece histórico limitado das alterações da origem de acordo com sua retenção implementada;
7. o Kafka é a fonte preferencial para o *replay* normal enquanto os eventos necessários permanecerem retidos e confiáveis;
8. a Bronze é a principal fundação histórica analítica para *rebuild*;
9. a Silver pode apoiar o *rebuild* posterior quando permanecer confiável e apropriada;
10. a Gold não substitui as fundações históricas de recuperação anteriores;
11. a Certified Gold fornece um limite de disponibilidade e *rollback* conhecido como válido para os consumidores;
12. os *checkpoints* correspondem ao progresso de processamento confirmado com segurança;
13. metadados de processamento, versão e linhagem apoiam a recuperabilidade;
14. *backups* e arquivos de arquivamento permanecem distintos dos mecanismos comuns de *replay* on-line;
15. as janelas de recuperação são explícitas e influenciam a prioridade operacional;
16. o esgotamento de uma janela de recuperação pode exigir escalonamento para outro limite;
17. múltiplas cópias não são consideradas como fornecendo recuperação independente quando compartilham o mesmo domínio de falha;
18. as definições históricas permanecem disponíveis enquanto os dados retidos dependerem delas;
19. o *rebuild* histórico permanece sujeito à governança atualmente aplicável;
20. os limites de recuperação são considerados demonstrados somente após validação controlada e produção de evidências.

---

## 6. Checkpoints, Progresso e Capacidade de Reinicialização

A Atlas Engineering deve preservar estado de processamento durável suficiente para determinar onde o trabalho pode ser retomado com segurança após uma interrupção.

A reinicialização de um processo não deve depender de suposições como:

- o último registro visível em um *log*;
- o horário em que o serviço foi interrompido;
- o último registro lido na memória;
- a última tarefa reportada como em execução;
- a lembrança do operador sobre o que provavelmente foi concluído.

A plataforma deve distinguir entre:

**Entrada Observada**  
→ a entrada tornou-se visível para o processador.

**Processamento Iniciado**  
→ o trabalho começou para aquela entrada.

**Saída Persistida**  
→ o estado resultante foi gravado de forma durável.

**Progresso Confirmado**  
→ a plataforma registrou que a entrada correspondente não requer mais processamento normal.

O princípio orientador é:

**A Saída Durável e o Progresso Confirmado Devem Permanecer Consistentes**

### 6.1 Progresso do Processamento

O progresso do processamento representa a posição durável alcançada por uma responsabilidade de processamento.

Dependendo do componente ou modelo de processamento, o progresso pode ser representado por:

- posição do CDC;
- *offset* Kafka;
- *offset* do grupo de consumidores;
- *checkpoint*;
- *watermark*;
- identificador do lote;
- identificador da execução;
- intervalo processado;
- versão candidata;
- estado da certificação.

Diferentes estágios podem utilizar diferentes mecanismos de progresso.

A arquitetura não exige uma representação universal de *checkpoint* em toda a plataforma.

Ela exige que cada limite de processamento recuperável tenha informações duráveis suficientes para determinar um comportamento seguro de reinicialização.

### 6.2 Checkpoint

Um *checkpoint* é uma representação durável do progresso de processamento confirmado.

Um *checkpoint* deve responder:

**Qual entrada foi incorporada com sucesso ao estado durável governado por este estágio de processamento?**

Um *checkpoint* não deve ser interpretado simplesmente como:

**Qual entrada o processo tentou ler por último?**

A distinção é essencial porque uma entrada observada pode ainda não ter produzido uma saída durável.

### 6.3 Consistência entre Checkpoint e Saída

O avanço do *checkpoint* deve permanecer consistente com a saída durável.

A condição insegura é:

**Checkpoint Avançado**  
→ **Saída Não Persistida com Segurança**

Isso pode fazer com que a plataforma pule a entrada após uma reinicialização e produza uma omissão silenciosa.

O cenário de falha mais seguro é:

**Saída Persistida**  
→ **Checkpoint Ainda Não Avançado**

Isso pode fazer com que a mesma entrada lógica seja entregue ou processada novamente.

A entrega repetida pode ser tratada por meio de idempotência.

Uma entrada ignorada pode ser impossível de detectar ou submeter a *rebuild* sem reconciliação adicional.

Portanto:

**Nova Entrega Segura é Preferível à Omissão Silenciosa**

### 6.4 Limite de Confirmação

Um limite de confirmação define o ponto em que uma unidade de processamento é considerada concluída de forma durável.

Dependendo da implementação, o limite pode incluir:

- um evento;
- um grupo de eventos;
- um microlote;
- um intervalo de partição;
- um intervalo de negócio;
- uma execução completa de processamento;
- uma versão candidata analítica.

O limite de confirmação deve ser explícito o suficiente para permitir um comportamento determinístico de reinicialização.

Limites de confirmação maiores podem reduzir a sobrecarga de *checkpoints*, mas aumentar a quantidade de trabalho repetido após uma falha.

Limites de confirmação menores podem reduzir o trabalho repetido, mas aumentar a sobrecarga operacional e de implementação.

O limite selecionado deve preservar a correção antes da otimização.

### 6.5 Atomicidade entre Saída e Progresso

Quando a tecnologia subjacente oferecer suporte à coordenação atômica entre a saída durável e o progresso, a implementação deve utilizá-la quando apropriado.

Quando a atomicidade completa não estiver disponível, a arquitetura deve tolerar explicitamente os possíveis estados intermediários.

Os cenários importantes são:

**Saída Falha**  
→ o progresso não deve avançar.

**Saída Bem-Sucedida + Progresso Falha**  
→ a entrada pode ser processada novamente.

O segundo cenário exige comportamento idempotente.

A arquitetura não deve afirmar que existe processamento *exactly-once* apenas porque a saída e o *checkpoint* normalmente avançam juntos.

### 6.6 Capacidade de Reinicialização

A capacidade de reinicialização é a capacidade de um componente de processamento retomar com segurança após uma interrupção utilizando estado durável.

Um componente com capacidade de reinicialização deve ser capaz de determinar:

- seu último progresso confirmado;
- qual entrada pode exigir processamento;
- qual entrada pode ser entregue novamente;
- qual saída pode já existir;
- se houve acúmulo de *backlog*;
- se é necessário um mecanismo de recuperação diferente.

A reinicialização não deve exigir edição manual de dados de negócio apenas para retomar o processamento normal.

### 6.7 Reinicialização Limpa

Uma reinicialização limpa ocorre quando:

- o componente foi interrompido sem invalidar o estado durável;
- a entrada necessária permanece disponível;
- o estado do *checkpoint* permanece válido;
- as definições de processamento permanecem compatíveis;
- nenhum *rebuild* mais amplo é necessário.

O comportamento esperado é:

**Reiniciar**  
→ restaurar o contexto de processamento  
→ retomar a partir do progresso confirmado  
→ processar a entrada restante  
→ validar o avanço.

Uma reinicialização limpa deve ser o caminho normal de recuperação para interrupções rotineiras de componentes.

### 6.8 Reinicialização Não Limpa

Uma reinicialização não limpa ocorre após uma interrupção na qual o processamento pode ter parado entre operações duráveis.

Exemplos incluem:

- encerramento do processo;
- falha do contêiner;
- interrupção do *host*;
- perda de conexão;
- falha do ambiente de execução;
- falha abrupta de uma dependência.

Após uma reinicialização não limpa, a plataforma deve assumir que alguma entrada pode ser entregue novamente, a menos que a implementação forneça garantias mais fortes comprovadas.

O processamento idempotente deve proteger a correção durante essa janela de incerteza.

### 6.9 Reinicialização Não é Replay

Reinicialização e *replay* são operações relacionadas, mas distintas.

**Reinicialização**  
→ restaura a execução de um componente e normalmente continua a partir de seu progresso confirmado.

**Replay**  
→ processa intencionalmente novamente uma entrada anteriormente retida a partir de uma posição ou intervalo histórico selecionado.

Uma reinicialização de componente pode provocar uma nova entrega limitada próxima ao último limite de confirmação.

Isso não transforma automaticamente a operação em um *replay* arquitetural.

O *replay* é definido separadamente mais adiante neste documento.

### 6.10 Reinicialização Não é Reprocessamento

A reinicialização retoma o processamento interrompido utilizando a definição de processamento aplicável.

O reprocessamento executa intencionalmente novamente uma entrada histórica que já foi processada, geralmente porque:

- a lógica de processamento mudou;
- um defeito foi corrigido;
- a saída histórica precisa ser regenerada;
- a interpretação governada foi alterada.

Uma reinicialização rotineira não deve ser descrita como reprocessamento apenas porque alguma entrada é entregue novamente.

### 6.11 Reinicialização Não é Rebuild

A reinicialização restaura uma execução interrompida.

O *rebuild* refaz um estado derivado a partir de um limite confiável anterior selecionado.

Se um serviço parar enquanto o estado válido permanecer íntegro, uma reinicialização poderá ser suficiente.

Se o próprio estado derivado for perdido, corrompido ou invalidado, apenas reiniciar poderá ser insuficiente e um *rebuild* poderá ser necessário.

### 6.12 Progresso do Consumidor Kafka

Para consumidores Kafka, *offsets* fornecem uma representação natural da posição de consumo.

A arquitetura deve distinguir:

**Registro Obtido**

de:

**Registro Incorporado com Segurança à Saída Governada**

O progresso do consumidor deve refletir o segundo, de acordo com a semântica de processamento implementada.

Confirmar um *offset* antes que a saída necessária seja persistida com segurança pode causar omissão após uma falha.

Confirmar depois da persistência pode produzir uma nova entrega se ocorrer uma falha entre a persistência e a confirmação do *offset*.

A implementação posterior deve tolerar essa nova entrega.

### 6.13 Progresso Específico de Partição

A ordenação e os *offsets* do Kafka são específicos de cada partição.

O progresso do processamento deve, portanto, preservar o contexto da partição quando o particionamento do Kafka for relevante.

Um consumidor pode estar atualizado em uma partição enquanto outra permanece atrasada ou com falha.

A plataforma não deve inferir o progresso completo de um tópico apenas a partir de um único *timestamp* global ou de um estado agregado.

*Lag* e progresso em nível de partição podem ser necessários para diagnóstico e recuperação.

### 6.14 Progresso do CDC e Debezium

A recuperação do CDC e do Debezium depende do progresso durável das alterações da origem e do *connector*.

Após uma interrupção, a recuperação deve determinar se:

- a posição de origem necessária pelo *connector* permanece disponível;
- o CDC ainda retém o histórico necessário;
- o progresso do *connector* permanece válido;
- a publicação no Kafka pode ser retomada sem um intervalo de origem ausente.

Um *connector* reiniciado reportando `RUNNING` não demonstra, por si só, continuidade da captura.

A validação da recuperação deve confirmar que o intervalo de alterações necessário permanece representado posteriormente no pipeline.

### 6.15 Progresso da Bronze

O progresso da Bronze deve representar a entrada Kafka incorporada de forma durável à Bronze.

Uma reinicialização da Bronze pode encontrar uma entrada já persistida antes que o *checkpoint* anterior fosse confirmado.

O processamento da Bronze deve, portanto, tolerar novas entregas sem criar uma representação histórica duplicada incorreta.

A implementação deve preservar metadados de origem suficientes para permitir a rastreabilidade até o evento Kafka de origem e a execução de processamento.

### 6.16 Progresso da Silver

O progresso da Silver deve representar a entrada Bronze ou o intervalo de processamento governado incorporado com sucesso ao estado persistido da Silver.

Dependendo da implementação, a Silver pode utilizar:

- *checkpoints*;
- partições processadas;
- *watermarks*;
- identificadores de lote;
- metadados de execução.

Uma reinicialização da Silver não deve inferir progresso apenas pela existência de alguns registros de saída.

O mecanismo de progresso deve refletir o limite de processamento utilizado pela implementação.

### 6.17 Progresso da Gold

O processamento da Gold pode operar por meio de execuções controladas de construção analítica em vez de *checkpoints* contínuos evento a evento.

O progresso pode, portanto, ser representado por:

- intervalo de processamento da origem;
- versão da Silver;
- identificador da construção;
- versão candidata da Gold;
- estado da execução.

Uma candidata Gold parcialmente produzida não deve ser automaticamente interpretada como uma versão analítica concluída com sucesso.

A conclusão deve permanecer distinguível da certificação e da publicação.

### 6.18 Progresso da Certificação

A certificação possui seu próprio estado governado.

Os estados representativos podem incluir:

- candidata criada;
- validação pendente;
- qualidade aprovada;
- reconciliação aprovada;
- certificação com falha;
- certificada;
- publicada.

O progresso da certificação não deve ser inferido apenas a partir da conclusão do processamento da Gold.

Uma candidata que exista fisicamente, mas não tenha concluído a certificação necessária, permanece não visível ao consumidor.

### 6.19 Progresso da Orquestração

O Airflow registra o estado da orquestração, mas o estado da orquestração não é automaticamente equivalente ao estado do processamento dos dados de negócio.

Por exemplo:

**Tarefa Reportada como Falha**  
→ a gravação subjacente pode já ter sido concluída.

Ou:

**Tarefa Reportada como Sucesso**  
→ a qualidade ou a certificação posterior ainda pode falhar.

As decisões de nova execução devem, portanto, considerar tanto:

- metadados da orquestração;
- estado do processamento durável.

O Airflow deve coordenar a recuperação, e não se tornar a única autoridade sobre se o processamento de negócio já ocorreu.

### 6.20 Interação entre Nova Tentativa e Checkpoint

A nova tentativa deve preservar a correção do *checkpoint*.

Uma operação com falha não deve avançar o progresso apenas porque sua política de novas tentativas foi esgotada.

Da mesma forma, uma nova tentativa bem-sucedida não deve criar um efeito de negócio adicional se uma tentativa anterior já tiver persistido a saída, mas falhado antes de registrar o progresso.

A interação entre novas tentativas e *checkpoint* depende, portanto, da idempotência.

O comportamento detalhado das novas tentativas é definido na próxima seção.

### 6.21 Interação entre Backlog e Checkpoint

Quando o processamento para enquanto a entrada anterior continua se acumulando:

**Checkpoint**  
→ permanece na última posição confirmada.

**Entrada Disponível**  
→ continua avançando.

A distância entre eles representa o *backlog* recuperável enquanto a entrada permanecer retida.

Após a reinicialização, o processamento deve avançar a partir do progresso confirmado, em vez de pular diretamente para a entrada mais recente.

A recuperação do *backlog* é abordada mais adiante neste documento.

### 6.22 Corrupção ou Perda de Checkpoint

O próprio estado do *checkpoint* pode falhar.

Possíveis cenários incluem:

- *checkpoint* indisponível;
- *checkpoint* corrompido;
- *checkpoint* inconsistente com a saída;
- *checkpoint* redefinido acidentalmente;
- metadados de progresso perdidos.

A recuperação não deve presumir uma nova posição de processamento apenas para retomar rapidamente.

As possíveis respostas podem incluir:

- executar o *rebuild* do progresso a partir de metadados duráveis;
- comparar a saída com os limites da origem;
- executar *replay* a partir de um ponto seguro anterior;
- executar o *rebuild* do estado derivado afetado.

Quando o progresso exato não puder ser comprovado, a arquitetura deve preferir um limite seguro e recuperável que possa repetir trabalho a um limite não verificado que possa omitir dados.

### 6.23 Redefinição de Checkpoint

A redefinição de *checkpoint* é uma ação de recuperação controlada, e não um atalho rotineiro para solução de problemas.

Antes de redefinir o progresso, o procedimento de recuperação deve determinar:

- por que a redefinição é necessária;
- qual entrada histórica será entregue novamente;
- se essa entrada permanece disponível;
- se o processamento é idempotente;
- quais saídas já existem;
- se o estado posterior precisa ser limpo ou submetido a *rebuild*;
- como o estado resultante será validado.

Uma redefinição de *checkpoint* não controlada pode criar duplicação, histórico inconsistente ou um *replay* de grande escala não intencional.

### 6.24 Lacunas de Processamento

Uma lacuna de processamento ocorre quando a entrada esperada entre duas posições de progresso conhecidas não está representada no estado durável resultante.

Possíveis causas incluem:

- avanço prematuro do *checkpoint*;
- histórico de origem ausente;
- intervalo de partição ignorado;
- falha de gravação;
- recuperação incorreta;
- defeito de processamento.

Lacunas de processamento não devem ser aceitas apenas porque o processamento posterior continua com sucesso.

Quando aplicável, reconciliação e linhagem devem ajudar a detectar intervalos ausentes ou efeitos de negócio ausentes.

### 6.25 Processamento Duplicado

O processamento duplicado ocorre quando a mesma entrada lógica é processada mais de uma vez.

A execução duplicada não é automaticamente uma falha de correção.

Ela se torna uma falha de correção quando a execução repetida cria um estado de negócio adicional não intencional.

A plataforma deve, portanto, distinguir:

**Entrega / Execução Duplicada**  
→ pode ser esperada.

**Efeito de Negócio Duplicado**  
→ deve ser impedido ou detectado.

Essa distinção é central para o modelo de processamento *at-least-once* da plataforma.

### 6.26 Monotonicidade do Progresso

O progresso confirmado normalmente deve avançar de acordo com o modelo de ordenação do limite de processamento.

Um retrocesso inesperado pode indicar:

- redefinição de *checkpoint*;
- *replay*;
- ação de recuperação;
- corrupção;
- erro de configuração.

Um retrocesso intencional deve ser explícito e atribuível.

A plataforma não deve mover silenciosamente o progresso do processamento para trás durante a operação normal.

### 6.27 Progresso Independente

Diferentes estágios de processamento mantêm progresso independente.

Por exemplo:

**Kafka**  
→ eventos disponíveis até o Offset X.

**Bronze**  
→ persistidos até o Offset W.

**Silver**  
→ processada até um limite correspondente anterior.

**Gold**  
→ construída a partir de uma versão concluída da Silver.

**Certified Gold**  
→ ainda pode expor a versão certificada anterior.

Essas diferenças são esperadas no processamento assíncrono.

A confiabilidade depende de torná-las observáveis, em vez de fingir que todo o pipeline compartilha uma única posição global instantânea.

### 6.28 Progresso e Atualidade

O progresso do processamento contribui para a atualização dos dados, mas não é idêntico à atualização.

Um *checkpoint* pode estar avançando enquanto o processamento permanece muito atrasado em relação à origem para satisfazer a atualidade analítica esperada.

Por outro lado, o processamento pode ser temporariamente interrompido enquanto a Certified Gold permanece dentro de sua expectativa aceitável de atualização.

A atualização exige, portanto, interpretação do progresso em relação a:

- atividade da origem;
- tempo decorrido;
- *backlog*;
- estado da publicação;
- expectativa do consumidor.

### 6.29 Validação da Reinicialização

Após uma reinicialização, a validação deve determinar, quando aplicável:

- o componente está operacional;
- a conectividade com as dependências necessárias foi restaurada;
- o progresso confirmado foi recuperado;
- o processamento foi retomado a partir do limite esperado;
- os *checkpoints* estão avançando;
- o *backlog* está diminuindo ou estável;
- não existe lacuna inexplicada;
- nenhum efeito de negócio duplicado foi criado;
- as camadas posteriores retomam adequadamente;
- a atualização dos dados começa a se recuperar.

Uma inicialização bem-sucedida do processo é apenas a primeira etapa da validação.

### 6.30 Evidências de Reinicialização

Testes representativos de reinicialização devem preservar evidências como:

- *checkpoint* anterior à falha;
- horário da falha;
- mecanismo da falha;
- última saída durável conhecida;
- horário da reinicialização;
- *checkpoint* recuperado;
- primeira entrada processada após a reinicialização;
- nova entrega observada;
- resultado do tratamento de duplicidades;
- *backlog* antes e depois da reinicialização;
- *checkpoint* final;
- resultado da validação;
- tempo decorrido de recuperação.

Essas evidências demonstram a capacidade real de reinicialização, e não apenas a intenção de configuração.

### 6.31 Garantias de Checkpoint e Capacidade de Reinicialização

O modelo de *checkpoint* e capacidade de reinicialização da Atlas Engineering deve preservar as seguintes garantias:

1. o progresso do processamento é representado por estado durável quando necessário para recuperação;
2. a observação da entrada é distinguível do processamento durável bem-sucedido;
3. os *checkpoints* representam progresso confirmado, e não apenas entrada tentada;
4. o progresso não avança com segurança além da saída durável necessária;
5. a nova entrega é preferida à omissão silenciosa quando a coordenação atômica não estiver disponível;
6. o processamento tolera novas entregas esperadas por meio de comportamento idempotente;
7. a reinicialização normalmente retoma a partir do progresso confirmado;
8. a reinicialização permanece distinta de *replay*, reprocessamento e *rebuild*;
9. o progresso do Kafka preserva o contexto da partição quando necessário;
10. a recuperação do CDC e do Debezium valida a continuidade da captura, e não apenas o estado do serviço;
11. Bronze, Silver, Gold e certificação utilizam representações de progresso apropriadas aos seus modelos de processamento;
12. o estado da orquestração não substitui o estado durável do processamento de negócio;
13. o esgotamento das novas tentativas não avança falsamente o progresso do processamento;
14. o *backlog* é processado a partir do progresso confirmado, e não ignorado;
15. *checkpoints* perdidos ou inconsistentes são recuperados a partir de um limite seguro comprovado, e não presumido;
16. a redefinição de *checkpoint* é controlada, atribuível e validada;
17. lacunas de processamento são tratadas como questões de correção mesmo quando o processamento posterior é bem-sucedido;
18. execução duplicada é distinguida de efeito de negócio duplicado;
19. retrocessos intencionais de progresso são explícitos;
20. estágios assíncronos podem legitimamente apresentar diferentes posições de progresso;
21. a validação da reinicialização verifica o comportamento do processamento de dados além da disponibilidade do componente;
22. as afirmações de capacidade de reinicialização são sustentadas por evidências controladas.

---

## 7. Novas Tentativas e Nova Entrega

A Atlas Engineering deve tolerar falhas transitórias e novas entregas esperadas sem convertê-las em perda de dados, duplicação descontrolada ou ciclos de processamento indefinidos.

Nova tentativa e nova entrega são comportamentos relacionados, mas distintos.

**Nova Tentativa**  
→ a mesma operação é executada novamente após uma falha.

**Nova Entrega**  
→ a mesma entrada lógica torna-se novamente disponível para processamento porque o processamento anterior não foi confirmado de forma conclusiva ou porque a entrada histórica está sendo revisitada intencionalmente.

Ambos os comportamentos podem fazer com que a mesma entrada lógica seja tratada mais de uma vez.

A arquitetura deve, portanto, combinar:

**Classificação da Falha → Nova Tentativa Limitada → Processamento Idempotente → Progresso Explícito → Tratamento de Falha Persistente**

### 7.1 Objetivo das Novas Tentativas

A nova tentativa é apropriada quando existe uma probabilidade razoável de que uma operação com falha seja bem-sucedida sem alterar o significado de negócio ou a definição de processamento subjacente.

Condições representativas que podem permitir nova tentativa incluem:

- interrupção temporária de rede;
- indisponibilidade temporária de uma dependência;
- falha transitória de armazenamento;
- tempo limite de conexão;
- contenção temporária de recursos;
- indisponibilidade de curta duração de um serviço;
- limitação temporária de capacidade (*throttling*).

A nova tentativa existe para absorver instabilidade temporária.

Ela não deve ser utilizada para ocultar defeitos persistentes.

### 7.2 Falhas que Permitem e que Não Permitem Nova Tentativa

As falhas devem ser classificadas antes da definição do comportamento de nova tentativa.

Uma **falha que permite nova tentativa** é aquela que pode potencialmente ser resolvida após uma espera ou depois que a dependência afetada se recuperar.

Uma **falha que não permite nova tentativa** requer outra ação antes que a operação possa ser executada corretamente.

Condições representativas que não permitem nova tentativa incluem:

- entrada malformada;
- esquema incompatível;
- configuração inválida;
- permissão necessária ausente;
- credencial revogada;
- versão de contrato não suportada;
- defeito determinístico de transformação;
- premissa de negócio violada.

Executar repetidamente uma falha determinística sem alterar sua causa normalmente reproduz o mesmo resultado.

### 7.3 Nova Tentativa Limitada

A nova tentativa deve ser limitada por uma política explícita.

A política pode definir:

- número máximo de tentativas;
- tempo máximo decorrido para novas tentativas;
- intervalo entre tentativas;
- comportamento de *backoff*;
- categorias de erro elegíveis;
- comportamento após a falha terminal.

Os valores exatos podem variar conforme o componente e o tipo de falha.

A V1 deve obter valores práticos por meio da implementação e da observação em laboratório, em vez de inventar configurações universais de nível de produção.

### 7.4 Intervalo entre Novas Tentativas

Repetir imediatamente uma operação que falhou pode agravar uma falha existente.

Quando apropriado, a nova tentativa deve introduzir um intervalo antes de uma nova execução.

O intervalo pode:

- permitir que uma dependência se recupere;
- reduzir a pressão repetida sobre conexões;
- reduzir o consumo desnecessário de recursos;
- impedir ciclos rápidos de falha;
- melhorar a observabilidade operacional.

O intervalo apropriado depende do comportamento esperado da falha.

### 7.5 Backoff

Falhas repetidas podem justificar o aumento progressivo do intervalo entre as tentativas.

Uma estratégia de *backoff* pode reduzir a pressão sobre uma dependência indisponível ou degradada.

As estratégias possíveis incluem:

- intervalo fixo;
- *backoff* linear;
- *backoff* exponencial;
- *backoff* exponencial limitado.

A arquitetura não exige um único algoritmo universal de *backoff*.

O mecanismo selecionado deve ser compatível com o componente, o modo de falha e o objetivo operacional.

### 7.6 Jitter

Quando vários *workers* ou serviços podem executar novas tentativas simultaneamente, intervalos determinísticos podem provocar cargas repetidas sincronizadas.

*Jitter* pode ser adicionado ao tempo das novas tentativas para reduzir esse comportamento simultâneo.

Isso é particularmente relevante quando várias unidades de processamento dependem do mesmo recurso temporariamente indisponível.

*Jitter* é um mecanismo de implementação, e não um requisito universal.

Seu uso deve ser justificado pelas características de concorrência e de falha do componente afetado.

### 7.7 Tempestade de Novas Tentativas

Uma tempestade de novas tentativas ocorre quando tentativas repetidas de recuperação geram carga suficiente para agravar ou prolongar a falha original.

Por exemplo:

**Dependência Indisponível**  
→ vários *workers* falham  
→ todos executam nova tentativa imediatamente  
→ a dependência começa a se recuperar  
→ novas tentativas simultâneas a sobrecarregam novamente.

As políticas de nova tentativa devem reduzir esse risco por meio de mecanismos como:

- número limitado de tentativas;
- intervalo;
- *backoff*;
- *jitter*;
- controle de concorrência;
- comportamento de *circuit breaking* quando apropriado.

A atividade de recuperação não deve se tornar uma nova fonte de falha.

### 7.8 Nova Tentativa e Idempotência

Uma nova tentativa pode ocorrer depois que a operação original produziu algum efeito durável, mas antes que o sucesso tenha sido confirmado de forma conclusiva.

Por exemplo:

**Gravação Bem-Sucedida**  
→ a resposta é perdida  
→ o processador interpreta a operação como falha  
→ uma nova tentativa ocorre.

A nova tentativa não deve criar um segundo efeito de negócio não intencional.

O processamento seguro para novas tentativas depende, portanto, de idempotência quando o resultado da execução puder estar incerto.

### 7.9 Nova Tentativa e Checkpoint

Uma operação com falha não deve avançar o progresso confirmado apenas porque o mecanismo de novas tentativas esgotou suas tentativas.

A relação esperada é:

**Processamento Bem-Sucedido**  
→ a saída necessária é persistida de forma durável  
→ o progresso pode avançar.

**Processamento Falha**  
→ o progresso permanece antes da unidade com falha  
→ uma nova tentativa ou outro caminho de recuperação é selecionado.

Se a saída foi persistida, mas o progresso não avançou, uma nova entrega posterior deve permanecer segura por meio do processamento idempotente.

### 7.10 Nova Entrega

A nova entrega ocorre quando a mesma entrada lógica é apresentada para processamento mais de uma vez.

Possíveis causas incluem:

- falha entre a persistência da saída e a confirmação do *checkpoint*;
- reinicialização do consumidor;
- recuperação de *offset*;
- interrupção de conexão;
- falha de confirmação;
- redistribuição de partição;
- *replay*;
- redefinição deliberada de *checkpoint*.

A nova entrega é uma propriedade esperada do processamento distribuído.

Ela não deve ser automaticamente tratada como corrupção de dados.

### 7.11 Identificação de Nova Entrega

Quando necessário para correção ou evidência, a plataforma deve preservar identidade suficiente para reconhecer a entrada lógica que está sendo processada.

Os identificadores relevantes podem incluir:

- identificador do evento;
- chave da origem;
- posição da alteração na origem;
- tópico Kafka;
- partição Kafka;
- *offset* Kafka;
- chave de negócio;
- identificador da execução de processamento.

A identidade apropriada depende da camada de processamento e da semântica de negócio.

### 7.12 Entrega Duplicada e Efeito de Negócio Duplicado

A Atlas Engineering distingue:

**Entrega Duplicada**  
→ a mesma entrada lógica é recebida mais de uma vez.

**Processamento Duplicado**  
→ a mesma entrada lógica é executada mais de uma vez.

**Efeito de Negócio Duplicado**  
→ a execução repetida cria um resultado lógico adicional não intencional.

Os dois primeiros podem ocorrer legitimamente sob o processamento *at-least-once*.

O terceiro deve ser impedido ou detectado.

### 7.13 Esgotamento das Novas Tentativas

O esgotamento das novas tentativas ocorre quando a política atinge seu limite definido sem que a operação seja concluída com sucesso.

Nesse momento, a falha deve passar de novas tentativas automáticas para um estado operacional explícito.

As possíveis respostas incluem:

- isolamento da falha;
- quarentena;
- falha da tarefa;
- pausa do processamento;
- alerta;
- investigação pelo operador;
- correção;
- seleção de outro mecanismo de recuperação.

O esgotamento das novas tentativas não deve descartar silenciosamente o trabalho afetado.

### 7.14 Transição para Falha Persistente

Uma falha deve passar para o tratamento de falha persistente quando não for mais esperado que novas tentativas continuadas restaurem o processamento correto.

A transição deve preservar, quando aplicável:

- entrada afetada;
- contexto do erro;
- quantidade de tentativas;
- horário da primeira falha;
- horário da falha mais recente;
- posição de processamento;
- versão relevante;
- estado da dependência;
- correção necessária.

Isso torna a falha acionável, em vez de apenas repetitiva.

### 7.15 Interação com Registros Problemáticos

Um registro problemático (*poison record*) é uma entrada que provoca repetidamente uma falha de processamento enquanto as entradas ao redor podem permanecer válidas.

Apenas novas tentativas não constituem uma estratégia adequada de longo prazo para registros problemáticos.

Após o esgotamento da política aplicável de novas tentativas, o registro deve entrar no caminho explícito de tratamento de falhas definido posteriormente neste documento.

A arquitetura deve impedir que um único registro problemático determinístico crie um ciclo infinito de processamento.

### 7.16 Nova Tentativa e Progresso da Partição

Quando o processamento ordenado é necessário dentro de uma partição Kafka, uma falha persistente pode impedir o avanço seguro além do registro afetado.

A plataforma não deve confirmar progresso além de uma entrada com falha quando isso violar a semântica de processamento ou criar omissão.

As estratégias possíveis dependem da implementação e podem incluir:

- pausar a partição afetada;
- isolar a entrada com falha por meio de um mecanismo governado;
- bloquear esse caminho de processamento;
- corrigir o problema e então retomar.

A estratégia selecionada deve preservar os requisitos de ordenação e correção.

### 7.17 Nova Tentativa e Isolamento de Falhas

A nova tentativa deve ocorrer no menor escopo seguro.

Uma falha que afete um:

- registro;
- partição;
- entidade;
- estágio de processamento;
- produto de dados;

não deve automaticamente fazer com que trabalhos saudáveis não relacionados sejam novamente executados ou reiniciados.

O isolamento reduz carga desnecessária e limita o raio de impacto de falhas persistentes.

### 7.18 Recuperação de Dependência

Quando uma nova tentativa é causada por falha de dependência, a recuperação deve considerar a saúde da dependência, e não apenas o intervalo decorrido desde a tentativa anterior.

Por exemplo:

**MinIO Indisponível**  
→ gravações repetidas falham.

Se a saúde da dependência continuar claramente indisponível, novas tentativas agressivas oferecem pouco valor.

Quando suportado, o estado de saúde da dependência pode orientar:

- ritmo das novas tentativas;
- pausa temporária do processamento;
- retomada;
- escalonamento.

### 7.19 Comportamento de Circuit Breaking

Algumas implementações podem se beneficiar da interrupção temporária das chamadas para uma dependência conhecida por estar falhando.

Conceitualmente:

**Falha Repetida da Dependência**  
→ interromper ou reduzir as requisições  
→ permitir um intervalo de recuperação  
→ testar a dependência  
→ retomar o tráfego controlado quando estiver saudável.

*Circuit breaking* não é obrigatório para todos os componentes da V1.

Quando implementado, deve permanecer observável e não impedir silenciosamente que o processamento seja retomado após a recuperação da dependência.

### 7.20 Nova Tentativa e Backpressure

A nova tentativa consome capacidade de processamento.

Durante uma degradação prolongada de dependência, atividade excessiva de novas tentativas pode competir com:

- processamento saudável;
- recuperação de *backlog*;
- operações de armazenamento;
- monitoramento.

A política de novas tentativas deve, portanto, interagir de forma segura com *backpressure* e controles de concorrência.

A plataforma não deve gastar a maior parte de sua capacidade executando repetidamente trabalhos que se sabe que não podem ser concluídos.

### 7.21 Nova Tentativa e Janelas de Retenção

Um estado prolongado de novas tentativas pode consumir tempo de uma janela de recuperação limitada.

Por exemplo:

**Debezium Não Consegue Publicar**  
→ novas tentativas continuam  
→ o histórico do CDC continua envelhecendo.

Ou:

**Bronze Não Consegue Persistir**  
→ o consumo não pode avançar com segurança  
→ o histórico Kafka continua envelhecendo.

A política de novas tentativas deve, portanto, considerar se esperar está reduzindo as opções futuras de recuperação.

Uma falha que se aproxima do esgotamento da janela de recuperação pode exigir escalonamento antes que os limites normais de novas tentativas sejam atingidos.

### 7.22 Nova Tentativa e Credenciais

Falhas de autenticação devem ser classificadas cuidadosamente.

Uma indisponibilidade temporária do serviço de identidade pode permitir novas tentativas.

Uma credencial inválida, revogada ou expirada pode exigir correção da credencial em vez de repetidas tentativas de autenticação.

O comportamento de novas tentativas não deve:

- enfraquecer a autenticação;
- ignorar a autorização;
- restaurar credenciais revogadas;
- expor valores de segredos por meio de registros repetidos.

Os requisitos de segurança específicos de credenciais permanecem sob a responsabilidade de **Segurança e Governança**.

### 7.23 Nova Tentativa e Limites de Taxa

Quando uma dependência impõe limites de taxa ou *throttling*, o comportamento de novas tentativas deve respeitar o mecanismo esperado de recuperação da dependência.

Solicitações repetidas imediatamente podem prolongar a limitação ou aumentar a falha.

Quando disponível, a nova tentativa pode considerar:

- orientação de nova tentativa fornecida pelo servidor;
- intervalo limitado;
- *backoff*;
- concorrência reduzida.

A implementação deve permanecer observável para que *throttling* não seja confundido com uma estagnação de processamento sem explicação.

### 7.24 Nova Tentativa e Orquestração

O Airflow pode executar novas tentativas de tarefas de orquestração com falha quando apropriado.

A nova tentativa em nível de tarefa não deve assumir que a operação subjacente não produziu nenhum efeito durável.

Antes que uma tarefa seja considerada seguramente repetível, seu comportamento de processamento deve tolerar execução repetida ou determinar se o trabalho anterior já foi concluído.

A nova tentativa do Airflow depende, portanto, da idempotência da operação orquestrada.

### 7.25 Nova Tentativa e Processamento em Lote

Um lote pode falhar depois de processar apenas parte de sua entrada prevista.

A recuperação deve conhecer a semântica de confirmação do lote.

Os modelos possíveis incluem:

**Lote Atômico**  
→ o estado governado do lote é confirmado ou não é confirmado.

**Lote Confirmado Incrementalmente**  
→ algumas unidades podem já estar duráveis antes da falha.

O comportamento de novas tentativas deve corresponder ao modelo implementado.

Repetir um lote confirmado incrementalmente exige tratamento idempotente das unidades já persistidas.

### 7.26 Nova Tentativa e Geração de Candidata

A geração de candidata Gold pode ser novamente executada quando a falha não invalidar a entrada subjacente ou a definição de processamento.

Uma execução de candidata com falha não deve se tornar Certified Gold apenas porque uma nova tentativa posterior da orquestração foi reportada como bem-sucedida.

A candidata resultante permanece sujeita a:

- validação de completude;
- qualidade;
- reconciliação;
- linhagem;
- certificação.

A nova tentativa restaura a oportunidade de processamento.

Ela não ignora a governança de publicação.

### 7.27 Nova Tentativa Manual

Uma nova tentativa manual pode ser apropriada após investigação ou correção.

Uma nova tentativa manual deve identificar:

- a falha afetada;
- o motivo pelo qual se espera que a nova tentativa seja bem-sucedida;
- o limite de processamento;
- o escopo da entrada;
- o *checkpoint* ou a posição inicial;
- o efeito esperado sobre as camadas posteriores;
- o requisito de validação.

A execução manual não deve se tornar um caminho de processamento alternativo não documentado.

### 7.28 Nova Tentativa Após Correção

Após a correção de uma falha persistente, o trabalho afetado pode retornar ao processamento.

Exemplos incluem:

- configuração corrigida;
- permissão restaurada;
- credencial substituída;
- transformação corrigida;
- esquema suportado implantado;
- dados de referência corrigidos.

A plataforma deve retomar a partir de um limite controlado que preserve, quando apropriado, o trabalho anteriormente concluído com sucesso.

A correção não exige automaticamente um *rebuild* completo.

### 7.29 Nova Entrega Após Recuperação

As operações de recuperação podem aumentar intencionalmente as novas entregas.

Exemplos incluem:

- reinicialização a partir de um *checkpoint* anterior;
- redefinição de *offset*;
- *replay*;
- *rebuild* de um intervalo de processamento.

O aumento esperado de entregas duplicadas deve ser distinguido de efeitos de negócio duplicados inesperados.

As evidências devem demonstrar que a idempotência preservou o resultado esperado.

### 7.30 Observabilidade das Novas Tentativas

O comportamento de novas tentativas deve expor, quando aplicável:

- quantidade de tentativas;
- operação afetada;
- categoria da falha;
- horário da primeira falha;
- horário da falha mais recente;
- próxima tentativa;
- intervalo da nova tentativa;
- dependência;
- limite de processamento afetado;
- estado de esgotamento.

Um componente executando repetidas novas tentativas não deve parecer indistinguível de um processamento saudável.

### 7.31 Observabilidade das Novas Entregas

Quando útil para validação ou diagnóstico, a plataforma deve ser capaz de identificar:

- entrada entregue novamente;
- identidade da entrada original;
- execução de processamento;
- contexto do *checkpoint*;
- saída resultante;
- comportamento de tratamento de duplicidade.

Nem toda entrega duplicada exige um alerta.

Efeitos de negócio duplicados inesperados exigem.

### 7.32 Alertas de Nova Tentativa

Os alertas devem se concentrar em condições de nova tentativa operacionalmente relevantes, e não em toda falha transitória isolada.

As condições relevantes podem incluir:

- esgotamento das novas tentativas;
- taxa de novas tentativas excepcionalmente alta;
- falha prolongada de dependência;
- falha repetida da mesma entrada;
- crescimento de *backlog* associado a novas tentativas;
- risco de janela de recuperação;
- transição de falha transitória para persistente.

O desenho detalhado dos alertas pertence à arquitetura especializada de **Observabilidade**.

### 7.33 Validação da Recuperação por Novas Tentativas

Após uma recuperação baseada em novas tentativas, a validação deve determinar, quando aplicável:

- a operação foi finalmente bem-sucedida;
- o progresso avançou corretamente;
- nenhuma lacuna de processamento foi introduzida;
- a execução repetida não criou efeitos de negócio duplicados;
- o *backlog* retornou em direção ao normal;
- o processamento posterior foi retomado;
- os controles de qualidade e reconciliação aplicáveis continuam aprovados.

O sucesso da nova tentativa, isoladamente, é insuficiente quando a correção do estado resultante permanece incerta.

### 7.34 Evidências de Novas Tentativas

Testes representativos de novas tentativas devem preservar evidências como:

- condição da falha;
- classificação como passível de nova tentativa;
- quantidade de tentativas;
- tempos das tentativas;
- *backoff* observado, quando implementado;
- progresso durável antes da falha;
- tentativa de recuperação bem-sucedida;
- avanço do *checkpoint*;
- comportamento de nova entrega;
- resultado do tratamento de duplicidade;
- estado final do processamento;
- tempo decorrido de recuperação.

Os testes de falha persistente devem demonstrar adicionalmente que as novas tentativas eventualmente são interrompidas e que o processamento transita para o estado explícito de falha definido.

### 7.35 Garantias de Novas Tentativas e Novas Entregas

O modelo de novas tentativas e novas entregas da Atlas Engineering deve preservar as seguintes garantias:

1. novas tentativas são utilizadas para falhas que possam razoavelmente ser resolvidas sem alterar o significado de negócio subjacente;
2. falhas persistentes determinísticas não são ocultadas por novas tentativas indefinidas;
3. o comportamento de novas tentativas é limitado e observável;
4. intervalos e *backoff* podem reduzir pressão desnecessária durante falhas transitórias;
5. comportamentos sincronizados de novas tentativas são controlados quando puderem prejudicar a recuperação da dependência;
6. novas tentativas não criam efeitos de negócio duplicados não intencionais;
7. trabalhos com falha não avançam falsamente o progresso de processamento confirmado;
8. a nova entrega é tratada como um comportamento esperado do processamento distribuído;
9. entrega duplicada e execução duplicada permanecem distintas do efeito de negócio duplicado;
10. o esgotamento das novas tentativas transita para um estado explícito de falha;
11. a entrada com falha permanece rastreável após o esgotamento das novas tentativas;
12. registros problemáticos não criam ciclos de processamento infinitos e descontrolados;
13. o processamento ordenado não ignora silenciosamente uma entrada com falha;
14. as novas tentativas ocorrem no menor escopo seguro quando tecnicamente viável;
15. o comportamento de novas tentativas considera a saúde das dependências e o *backpressure*;
16. novas tentativas prolongadas não ignoram o risco associado às janelas de recuperação limitadas;
17. falhas de credenciais são corrigidas sem enfraquecer os limites de segurança;
18. novas tentativas da orquestração dependem do processamento subjacente ser idempotente;
19. a conclusão parcial de lotes é tratada de acordo com semântica de confirmação explícita;
20. novas tentativas não ignoram os controles de certificação ou publicação da Gold;
21. novas tentativas manuais permanecem controladas e atribuíveis;
22. novas entregas provocadas pela recuperação permanecem seguras por meio do processamento idempotente;
23. o comportamento de novas tentativas e novas entregas é observável;
24. a recuperação baseada em novas tentativas é validada quanto ao processamento e à correção dos dados;
25. as garantias de novas tentativas são sustentadas por evidências controladas.

---

## 8. Estratégia de Fontes de Recuperação

A Atlas Engineering deve selecionar as fontes de recuperação de acordo com a falha que está sendo recuperada, o estado que permanece confiável, o histórico necessário e o objetivo da recuperação.

A seleção da fonte de recuperação não deve se basear exclusivamente em conveniência, disponibilidade física ou no estado persistido mais recente.

O princípio orientador é:

**Identificar o Estado Inválido → Preservar o Estado Confiável → Selecionar a Fonte de Recuperação Confiável Mais Recente e Apropriada → Recuperar → Revalidar**

A fonte de recuperação preferencial deve fornecer o menor escopo seguro de recuperação, preservando correção, interpretabilidade e governança.

### 8.1 Objetivos da Fonte de Recuperação

Uma fonte de recuperação pode ser necessária para diferentes objetivos.

Os objetivos representativos incluem:

- retomar um processamento interrompido;
- recuperar processamento *downstream* ausente;
- executar *replay* de eventos retidos;
- executar *rebuild* do estado padronizado;
- executar *rebuild* do estado analítico;
- corrigir processamento histórico;
- restaurar estado durável perdido;
- restaurar a disponibilidade visível aos consumidores;
- recuperar-se após o esgotamento de uma janela de retenção.

A mesma falha pode permitir mais de uma fonte de recuperação tecnicamente possível.

A arquitetura deve selecionar a fonte que atenda ao objetivo sem aumentar desnecessariamente o escopo da recuperação.

### 8.2 Elegibilidade da Fonte de Recuperação

Um estado durável é elegível como fonte de recuperação somente quando é apropriado para a recuperação pretendida.

A elegibilidade deve considerar:

- o histórico necessário está disponível;
- o estado está suficientemente completo;
- o estado permanece confiável;
- os metadados necessários existem;
- as definições históricas necessárias permanecem disponíveis;
- a integridade pode ser estabelecida;
- o acesso continua autorizado;
- a retenção permite seu uso contínuo;
- a recuperação pode ser validada.

A existência física, por si só, não estabelece elegibilidade.

### 8.3 Princípio da Fonte de Recuperação Preferencial

A Atlas Engineering deve normalmente recuperar a partir do limite confiável e apropriado mais recente.

Conceitualmente:

**Limite Confiável Mais Recente**  
→ menor escopo de *rebuild*  
→ potencialmente recuperação mais rápida.

**Limite Confiável Mais Antigo**  
→ maior escopo de *rebuild*  
→ potencialmente maior capacidade de *rebuild* histórico.

O limite mais recente não deve ser preferido quando a falha pode ter invalidado esse estado.

### 8.4 Hierarquia das Fontes de Recuperação

A hierarquia conceitual de fontes de recuperação para processamento analítico é:

**Kafka**  
→ preferencial para *replay* normal enquanto o histórico de eventos necessário permanecer retido e confiável.

**Bronze**  
→ principal base histórica analítica para *rebuild* e reprocessamento.

**Silver**  
→ apropriada para *rebuild downstream* quando a Silver permanecer válida para o objetivo da recuperação.

**AtlasCommerce / *Backfill* Controlado**  
→ apropriado quando o estado necessário precisa ser recuperado a partir da fonte operacional e o histórico retido nas camadas *downstream* for insuficiente.

**Backup / Arquivo**  
→ base mais ampla de recuperação quando o estado *online* necessário estiver indisponível, perdido, corrompido ou fora da retenção normal.

Essa hierarquia representa uma preferência de recuperação, e não uma sequência obrigatória que toda recuperação deva percorrer.

### 8.5 Kafka como Fonte de Recuperação

O Kafka deve ser a primeira fonte de recuperação para *replay* normal de eventos quando:

- os eventos necessários permanecem retidos;
- o histórico de eventos está completo para o intervalo necessário;
- os contratos de eventos continuam interpretáveis;
- o estado do Kafka permanece confiável;
- o processamento *downstream* afetado pode consumir novamente o histórico retido com segurança.

Cenários representativos incluem:

- interrupção do consumidor da Bronze;
- recuperação de *checkpoint*;
- redefinição controlada de *offset*;
- lacuna de processamento *downstream* enquanto o histórico Kafka permanece disponível.

O Kafka fornece *replay online* eficiente sem exigir *rebuild* a partir da fonte operacional.

### 8.6 Limitações da Recuperação pelo Kafka

O Kafka não deve ser tratado como um arquivo histórico permanente.

O Kafka pode se tornar inadequado quando:

- os eventos necessários expiraram;
- o histórico da partição necessária está incompleto;
- os eventos retidos foram produzidos sob um contrato indisponível ou não interpretável;
- o próprio estado do Kafka foi afetado pelo incidente;
- o objetivo da recuperação exige histórico que nunca foi publicado no Kafka.

Quando o Kafka não puder atender ao objetivo da recuperação, outro limite deverá ser selecionado.

### 8.7 Bronze como Fonte de Recuperação

A Bronze é a principal base histórica de recuperação analítica.

A Bronze deve suportar cenários como:

- *rebuild* após o vencimento da retenção do Kafka;
- reprocessamento da Silver;
- *rebuild downstream*;
- correção após defeitos de transformação;
- validação histórica;
- *rebuild* orientado por versão.

A Bronze fornece independência analítica em relação à janela de retenção de transporte, mais curta, do Kafka.

Sua utilidade depende da preservação da fidelidade dos eventos brutos e dos metadados necessários para a interpretação histórica.

### 8.8 Limitações da Recuperação pela Bronze

A Bronze não é apropriada quando:

- a entrada necessária nunca chegou à Bronze;
- o histórico da Bronze está incompleto para o intervalo afetado;
- a própria Bronze foi corrompida ou invalidada;
- a interpretação histórica necessária não está disponível;
- o objetivo da recuperação exige um estado da fonte que não esteja representado no histórico de eventos capturado.

Nesses cenários, a recuperação deve avançar para outro limite confiável.

### 8.9 Silver como Fonte de Recuperação

A Silver pode ser utilizada como fonte de recuperação *downstream* quando:

- a própria Silver permanece correta;
- o defeito ou a falha ocorreu em uma camada *downstream*;
- as informações analíticas necessárias já estão representadas na Silver;
- a versão aplicável da Silver permanece interpretável;
- a linhagem identifica o estado da Silver utilizado.

Um cenário representativo é:

**Defeito na Lógica da Gold**  
→ Silver permanece válida  
→ lógica corrigida da Gold implantada  
→ *rebuild* da Gold a partir da Silver.

Retornar à Bronze ou ao Kafka nesse caso pode não fornecer nenhuma correção adicional, enquanto aumenta o tempo e a complexidade da recuperação.

### 8.10 Limitações da Recuperação pela Silver

A Silver não deve ser selecionada simplesmente por estar mais próxima da Gold.

Ela é inadequada quando:

- a lógica de transformação da Silver apresentou defeito;
- o estado da Silver está incompleto;
- atributos necessários foram removidos intencionalmente;
- a semântica histórica da Silver não atende ao objetivo da recuperação;
- a linhagem ou o contexto de versão da Silver são insuficientes;
- a falha pode ter comprometido a integridade da Silver.

Nesses casos, a recuperação deve avançar para a Bronze ou para outra fonte apropriada.

### 8.11 Gold como Fonte de Recuperação

A Gold é principalmente um estado analítico derivado, e não a base geral de recuperação para processamento de camadas *upstream*.

Uma versão válida da Gold pode, ainda assim, apoiar cenários limitados de recuperação, como:

- restauração de um mecanismo de publicação;
- comparação com uma candidata que apresentou falha;
- preservação de um estado analítico conhecido;
- *rollback* da publicação visível aos consumidores quando a versão certificada correspondente permanecer válida.

A Gold não deve ser utilizada para executar *rebuild* da Silver ou do processamento histórico bruto.

### 8.12 Certified Gold como Fonte de Recuperação

A Certified Gold fornece o principal limite de recuperação para o consumo analítico governado.

Quando uma candidata mais recente ou sua publicação apresenta falha:

**Última Certified Gold Conhecida como Confiável**  
→ permanece ou volta a ficar visível aos consumidores.

Isso protege a disponibilidade analítica enquanto a correção ocorre nas camadas *upstream*.

O *rollback* da Certified Gold não corrige o defeito *upstream*.

Ele restaura um estado conhecido como confiável e visível aos consumidores enquanto o caminho de processamento subjacente é recuperado separadamente.

### 8.13 AtlasCommerce como Fonte de Recuperação

O AtlasCommerce pode fornecer uma fonte de recuperação quando os dados operacionais atuais ou históricos disponíveis na origem forem suficientes para atender ao objetivo da recuperação.

Cenários representativos podem incluir:

- *backfill* controlado;
- inicialização de atributos *downstream* que passaram a ser necessários;
- recuperação após ausência de histórico de eventos;
- *rebuild* quando o estado atual da fonte for suficiente.

O uso do AtlasCommerce deve respeitar o limite da fonte operacional.

A atividade de recuperação não deve impor carga analítica descontrolada ao sistema transacional.

### 8.14 Estado Atual da Fonte versus Eventos Históricos

O estado atual do AtlasCommerce não é equivalente ao histórico de alterações.

Por exemplo, se um valor mudou:

**A → B → C**

a fonte atual pode expor somente:

**C**

enquanto o processamento histórico de eventos pode exigir conhecimento de:

**A → B → C**

Uma fotografia do estado atual da fonte pode, portanto, recuperar o estado atual sem necessariamente recuperar a semântica dos eventos históricos.

O objetivo da recuperação deve determinar se o *rebuild* a partir do estado atual é suficiente.

### 8.15 *Backfill* Controlado

O *backfill* pode ser utilizado quando o estado *downstream* necessário não puder ser submetido a *rebuild* somente a partir do histórico de eventos retido.

Um *backfill* controlado deve definir:

- escopo da fonte;
- escopo de negócio;
- intervalo histórico;
- mecanismo de extração;
- comportamento esperado das camadas *downstream*;
- interação com o processamento em tempo real;
- requisitos de deduplicação ou reconciliação;
- validação;
- linhagem.

O *backfill* é definido em detalhes posteriormente neste documento.

Ele não deve se tornar um desvio não documentado do fluxo normal de ingestão governada.

### 8.16 Backup como Fonte de Recuperação

O *backup* torna-se importante quando:

- o estado *online* necessário é perdido;
- o armazenamento está corrompido;
- o estado do banco de dados precisa ser restaurado;
- o histórico retido necessário não está mais disponível;
- uma recuperação de infraestrutura mais ampla é necessária.

A recuperação por *backup* pode restaurar:

- o estado do banco de dados de origem;
- os metadados da plataforma;
- o estado do armazenamento;
- outros estados duráveis protegidos, de acordo com o escopo de *backup* implementado.

A capacidade exata depende do que é efetivamente submetido a *backup* e pode ser restaurado com sucesso.

### 8.17 Backup não é Replay

A restauração de *backup* e o *replay* resolvem problemas diferentes.

**Replay**  
→ processa novamente uma entrada histórica retida.

**Restauração de Backup**  
→ restaura um estado persistido a partir de uma cópia protegida anterior.

Um *backup* pode restaurar a base a partir da qual o *replay* ou o processamento *downstream* continua.

Ele não reproduz inerentemente todos os eventos ou ações de processamento ocorridos depois do ponto do *backup*.

### 8.18 Arquivo como Fonte de Recuperação

Um arquivo pode fornecer capacidade de recuperação de longo prazo para dados que não são mais mantidos no armazenamento *online* comum.

A recuperação a partir de arquivo pode exigir:

1. localizar o estado arquivado necessário;
2. validar sua integridade e seu estado de governança;
3. restaurá-lo em um ambiente de processamento acessível;
4. recuperar as definições históricas necessárias;
5. executar o *rebuild*;
6. validar o estado resultante.

O arquivo, portanto, geralmente fornece um caminho de recuperação mais lento do que um estado *online* retido.

### 8.19 Independência da Fonte de Recuperação

A estratégia de fontes de recuperação deve considerar se a fonte selecionada é independente da falha que está sendo recuperada.

Por exemplo:

**Falha de Armazenamento do MinIO**  
→ uma cópia de recuperação armazenada somente no mesmo armazenamento físico afetado pode não fornecer uma recuperação independente significativa.

Da mesma forma:

**Falha do Host**  
→ vários serviços locais e cópias locais podem falhar conjuntamente.

A V1 pode conter domínios físicos de falha compartilhados.

Essas limitações devem permanecer explícitas ao interpretar as garantias de recuperação.

### 8.20 Confiabilidade da Fonte de Recuperação

Uma fonte de recuperação pode perder sua confiabilidade devido a:

- corrupção;
- defeito de processamento;
- gravação incompleta;
- comprometimento de segurança;
- interpretação incompatível;
- reconciliação malsucedida;
- estado inválido em relação à privacidade;
- dados ausentes conhecidos.

Quando a confiabilidade é invalidada, a recuperação deve avançar para um limite anterior ao estado inválido ou que o exclua.

O estado mais recente não deve ser preferido apenas porque reduz o esforço de recuperação.

### 8.21 Último Estado Bem-Sucedido versus Último Estado Conhecido como Confiável

A Atlas Engineering distingue:

**Último Estado Bem-Sucedido**  
→ o estado mais recente produzido sem uma falha técnica de execução.

**Último Estado Conhecido como Confiável**  
→ o estado mais recente para o qual os controles aplicáveis de correção, governança e segurança permanecem válidos.

Eles podem ser diferentes.

Por exemplo:

**Candidata Gold Gerada com Sucesso**  
→ uma reconciliação posterior demonstra resultados incorretos.

A candidata foi tecnicamente bem-sucedida, mas não é confiável.

A recuperação deve, portanto, selecionar o último estado apropriado conhecido como confiável, e não o último estado tecnicamente bem-sucedido.

### 8.22 Fonte de Recuperação e Localização do Defeito

A recuperação deve normalmente começar *upstream* da origem do defeito que está sendo corrigido.

Por exemplo:

**Defeito na Gold**  
→ uma Silver válida pode ser utilizada.

**Defeito na Silver**  
→ uma Bronze válida pode ser utilizada.

**Defeito de Processamento na Bronze**  
→ o Kafka retido pode ser utilizado.

**Evento Kafka Ausente Causado por Falha na Captura da Origem**  
→ o Kafka não pode corrigir o evento ausente  
→ a fonte/*backfill* ou outra fonte histórica pode ser necessária.

Isso impede que o *rebuild* preserve o mesmo estado inválido que originou a necessidade de recuperação.

### 8.23 Fonte de Recuperação e Compatibilidade de Versão

Uma fonte de recuperação deve permanecer compatível com a definição de processamento utilizada para interpretá-la.

A recuperação pode exigir versões históricas de:

- definições de *schema*;
- contratos de eventos;
- versões das transformações;
- regras de negócio;
- regras de qualidade;
- definições dimensionais.

Se uma versão atual de processamento não puder interpretar corretamente uma entrada histórica, a estratégia de recuperação deve selecionar explicitamente ou migrar para a interpretação apropriada.

Dados históricos não devem ser submetidos silenciosamente a uma lógica atual incompatível.

### 8.24 Recuperação com Lógica Atual

Uma entrada histórica pode ser intencionalmente processada utilizando a lógica atual quando o objetivo da recuperação for corrigir ou reexpressar o resultado histórico.

Por exemplo:

**Bronze Histórica**  
→ Silver V2 corrigida  
→ Gold V3 corrigida.

Essa é uma decisão governada de reprocessamento.

A saída resultante deve preservar a linhagem que identifique:

- entrada histórica;
- definição de processamento atual;
- execução de recuperação;
- versão resultante.

Utilizar a lógica atual é, portanto, diferente de reproduzir exatamente o resultado histórico.

### 8.25 Recuperação com Lógica Histórica

Alguns objetivos de recuperação exigem a reprodução do estado que teria sido produzido sob a definição histórica.

Nesse caso, a plataforma pode exigir:

- código histórico de processamento;
- contrato histórico;
- *schema* histórico;
- definição histórica de qualidade;
- definição dimensional histórica.

A arquitetura deve distinguir:

**Reprodução Histórica**

de:

**Reexpressão Histórica com Lógica Atual**

Ambas podem ser válidas, mas respondem a perguntas de recuperação diferentes.

### 8.26 Fonte de Recuperação e Classificação de Dados

As fontes de recuperação continuam sujeitas à sua classificação de dados.

Uma operação de recuperação não deve reduzir os controles de tratamento apenas porque os dados estão sendo restaurados, reproduzidos ou submetidos a *rebuild*.

Isso se aplica a:

- extrações da fonte;
- histórico Kafka;
- Bronze;
- conjuntos de dados temporários de recuperação;
- *backups*;
- arquivos.

Cópias temporárias de recuperação devem permanecer governadas e não devem se tornar réplicas não gerenciadas de dados sensíveis.

### 8.27 Fonte de Recuperação e Retenção

A capacidade de recuperação depende da retenção.

Se o histórico necessário não for mais retido, esse caminho de recuperação deixa de existir.

As decisões de retenção devem, portanto, considerar seu efeito sobre:

- janela de *replay*;
- janela de reprocessamento;
- requisitos de *backfill*;
- capacidade de *rebuild*;
- auditabilidade;
- reprodutibilidade histórica.

Retenção e recuperação não podem ser projetadas de forma independente.

### 8.28 Fonte de Recuperação e RPO

A fonte de recuperação disponível influencia o RPO (*Recovery Point Objective*) alcançável.

Por exemplo:

- um histórico Kafka recente e retido pode permitir uma recuperação próxima do último evento confirmado;
- a Bronze pode preservar um histórico mais longo, mas refletir um limite de processamento diferente;
- um *backup* pode restaurar somente até o ponto de recuperação protegido mais recente.

O RPO formal deve, portanto, refletir os mecanismos reais de durabilidade e recuperação implementados.

O RPO é abordado em detalhes posteriormente neste documento.

### 8.29 Fonte de Recuperação e RTO

A fonte de recuperação selecionada também influencia o tempo de recuperação.

Em geral:

**Estado Online Retido**  
→ recuperação potencialmente mais rápida.

**Rebuild Histórico**  
→ exige mais processamento.

**Restauração de Backup**  
→ pode exigir restauração seguida de processamento de recuperação.

**Restauração de Arquivo**  
→ pode exigir tempo adicional para recuperação e restauração.

O caminho de recuperação mais rápido ainda deve preservar a correção.

O RTO não deve ser otimizado por meio da seleção de uma fonte de recuperação inválida.

### 8.30 Escalonamento da Fonte de Recuperação

A recuperação pode ser escalada quando a fonte preferencial se mostrar indisponível ou insuficiente.

Uma progressão representativa é:

**Kafka**  
→ histórico necessário indisponível.

**Bronze**  
→ histórico necessário disponível e confiável  
→ executar *rebuild* das camadas *downstream*.

Se a Bronze também for insuficiente:

**AtlasCommerce / *Backfill* Controlado**  
ou  
**Backup / Arquivo**  
→ selecionado de acordo com o estado ausente e o objetivo da recuperação.

O escalonamento deve ser deliberado, e não improvisado durante a falha.

### 8.31 Registro da Decisão sobre a Fonte de Recuperação

Ações de recuperação significativas devem registrar, quando aplicável:

- falha;
- estado afetado;
- estado invalidado;
- objetivo da recuperação;
- fontes de recuperação candidatas;
- fonte de recuperação selecionada;
- motivo da seleção;
- intervalo retido;
- versão de processamento aplicável;
- escopo esperado do *rebuild*;
- requisitos de validação.

Isso fornece rastreabilidade para explicar por que um limite de recuperação foi escolhido em vez de outro.

### 8.32 Validação da Fonte de Recuperação

A capacidade de uma fonte de recuperação deve ser demonstrada por meio de testes controlados.

Os testes representativos podem incluir:

- *replay* do Kafka enquanto o histórico retido estiver disponível;
- *rebuild* da Silver a partir da Bronze;
- *rebuild* da Gold a partir da Silver;
- *rollback* da Certified Gold;
- *backfill* controlado a partir da fonte;
- restauração de *backup*;
- restauração de arquivo, quando implementada.

Um teste bem-sucedido deve demonstrar não apenas que a fonte pode ser lida, mas que o estado governado pretendido pode ser recuperado a partir dela.

### 8.33 Evidências da Fonte de Recuperação

As evidências devem preservar, quando aplicável:

- fonte selecionada;
- motivo da seleção;
- estado de integridade da fonte;
- intervalo retido;
- contexto de versão;
- início da recuperação;
- escopo do *rebuild*;
- progresso resultante;
- resultados da validação;
- tempo decorrido de recuperação;
- estado governado final.

Isso permite que decisões arquiteturais futuras comparem mecanismos de recuperação utilizando comportamento observado.

### 8.34 Garantias da Estratégia de Fontes de Recuperação

A estratégia de fontes de recuperação da Atlas Engineering deve preservar as seguintes garantias:

1. as fontes de recuperação são selecionadas de acordo com a falha e o objetivo da recuperação;
2. a disponibilidade física, por si só, não estabelece a elegibilidade da fonte de recuperação;
3. o limite confiável e apropriado mais recente é preferido quando atende ao objetivo com segurança;
4. o Kafka é preferido para *replay* normal enquanto os eventos necessários permanecerem retidos e confiáveis;
5. o Kafka não é tratado como um arquivo histórico permanente;
6. a Bronze é a principal base histórica analítica para *rebuild*;
7. a Silver pode apoiar a recuperação *downstream* somente enquanto permanecer confiável e suficiente;
8. a Gold não substitui as fontes históricas de *rebuild* das camadas *upstream*;
9. a Certified Gold fornece um limite de disponibilidade analítica e *rollback* conhecido como confiável;
10. o AtlasCommerce pode apoiar *backfill* controlado sem se tornar uma dependência analítica não controlada;
11. o estado atual da fonte não é assumido como equivalente ao histórico de eventos;
12. a restauração de *backup* permanece distinta do *replay*;
13. o arquivo pode fornecer recuperação de longo prazo com custo adicional de restauração;
14. a independência da fonte de recuperação é avaliada em relação ao domínio de falha;
15. um estado invalidado não é selecionado apenas porque é mais recente ou mais fácil de recuperar;
16. o último estado bem-sucedido permanece distinto do último estado conhecido como confiável;
17. a recuperação normalmente começa *upstream* da origem do defeito que está sendo corrigido;
18. a compatibilidade das versões históricas é considerada antes do *rebuild*;
19. a reprodução histórica permanece distinta da reexpressão histórica utilizando a lógica atual;
20. as operações de recuperação preservam classificação, privacidade e governança de acesso;
21. as decisões de retenção afetam explicitamente os caminhos de recuperação disponíveis;
22. a seleção da fonte de recuperação influencia o RPO e o RTO alcançáveis;
23. o escalonamento da recuperação é deliberado quando uma fonte preferencial se torna indisponível ou insuficiente;
24. decisões significativas de seleção de fonte permanecem rastreáveis;
25. as capacidades das fontes de recuperação são consideradas demonstradas somente após validação e evidências controladas.

---

## 9. Replay

*Replay* é o reconsumo controlado de eventos anteriormente retidos a partir de uma posição de processamento anterior.

A Atlas Engineering utiliza *replay* quando o histórico de eventos necessário permanece disponível e confiável e uma responsabilidade de processamento *downstream* precisa consumir esse histórico novamente.

O modelo orientador é:

**Histórico de Eventos Retido → Selecionar Limite de Replay → Reconsumir Eventos → Processar com Idempotência → Validar Resultado**

O *replay* não recria eventos que não existem mais.

Ele utiliza eventos que permanecem disponíveis em uma fonte retida e governada, principalmente o Kafka para *replay* normal de eventos.

### 9.1 Objetivo do Replay

O *replay* pode ser utilizado para:

- recuperar processamento *downstream* interrompido;
- recuperar uma lacuna de processamento;
- reproduzir o estado *downstream* a partir de eventos retidos;
- validar o comportamento de reinicialização e idempotência;
- recuperar-se de problemas de *checkpoint* ou *offset*;
- executar *rebuild* da Bronze quando o histórico Kafka necessário permanecer disponível;
- revisitar intencionalmente um intervalo limitado de eventos históricos.

O *replay* é apropriado quando os eventos históricos necessários já existem e podem ser consumidos novamente.

### 9.2 Fonte do Replay

O Kafka é a fonte preferencial para *replay* normal enquanto o histórico de eventos necessário permanecer:

- retido;
- completo para o intervalo necessário;
- interpretável;
- confiável.

O Kafka fornece *replay* por meio do histórico de eventos retido, independentemente da posição atual do consumidor.

O *replay* a partir de outra representação histórica de eventos pode ser possível quando explicitamente projetado, mas deve preservar semântica governada equivalente.

### 9.3 Limite Inicial do Replay

Um *replay* deve definir onde o consumo histórico começa.

Dependendo da implementação, o limite pode ser identificado por:

- *topic*;
- partição;
- *offset*;
- *timestamp* convertido em *offsets*;
- identificador do evento;
- *checkpoint* de processamento conhecido;
- intervalo de eventos delimitado.

O limite inicial do *replay* deve ser explícito.

A plataforma não deve iniciar um *replay* histórico a partir de um ponto anterior arbitrário sem compreender o escopo de processamento resultante.

### 9.4 Limite Final do Replay

Um *replay* também deve definir quando o intervalo histórico de *replay* está concluído.

Os limites finais possíveis incluem:

- *offset* específico;
- *checkpoint* de processamento;
- limite derivado de *timestamp*;
- intervalo de eventos;
- transição para o processamento atual.

Um *replay* sem limite pode consumir inadvertidamente mais histórico do que o pretendido.

Quando existir um objetivo de recuperação delimitado, os limites inicial e final devem ser conhecidos.

### 9.5 Replay versus Reinicialização

Reinicialização retoma um componente a partir do seu progresso de processamento confirmado.

*Replay* move intencionalmente o processamento para uma posição de entrada retida anterior.

Conceitualmente:

**Reinicialização**  
→ continuar a partir do progresso confirmado.

**Replay**  
→ revisitar uma entrada anteriormente disponível.

Uma reinicialização pode naturalmente produzir uma reentrega limitada próxima ao limite de confirmação.

Isso não constitui automaticamente um *replay* intencional.

### 9.6 Replay versus Nova Tentativa

Nova tentativa repete uma operação que falhou.

*Replay* reconsome uma entrada histórica.

Por exemplo:

**Falha Temporária na Gravação da Bronze**  
→ repetir a gravação que falhou.

**Lacuna de Processamento da Bronze em *Offsets* Kafka Retidos**  
→ executar *replay* do intervalo Kafka afetado.

A nova tentativa normalmente trata uma operação que falhou ou uma tentativa de execução delimitada.

O *replay* trata o reconsumo de uma entrada histórica.

### 9.7 Replay versus Reprocessamento

*Replay* e reprocessamento podem ocorrer juntos, mas representam preocupações diferentes.

**Replay**  
→ como a entrada histórica é disponibilizada novamente.

**Reprocessamento**  
→ a entrada histórica é intencionalmente processada novamente para regenerar ou corrigir um estado derivado.

Por exemplo:

**Offsets Kafka 100–500 consumidos novamente**  
→ *replay*.

**Esses eventos executados por uma lógica Silver corrigida**  
→ reprocessamento.

A distinção permite que as evidências de recuperação expliquem tanto o mecanismo de entrada quanto o objetivo do processamento.

### 9.8 Replay versus Backfill

O *replay* utiliza eventos que já existem no histórico de eventos retido e governado.

O *backfill* introduz dados necessários no processamento *downstream* quando o estado histórico necessário não pode ser obtido por meio do *replay* normal dos eventos retidos.

Portanto:

**Eventos Kafka Necessários Disponíveis**  
→ *replay* pode ser apropriado.

**Eventos Kafka Necessários Nunca Existiram ou Não Existem Mais**  
→ somente *replay* não pode recuperá-los.

Um *backfill* controlado pode então ser necessário.

### 9.9 Replay versus Rebuild

O *replay* revisita uma entrada retida.

O *rebuild* refaz um estado derivado a partir de um limite de recuperação *upstream* apropriado e confiável.

Um *rebuild* pode utilizar *replay* como parte de seu mecanismo, mas os conceitos permanecem distintos.

Por exemplo:

**Executar Rebuild da Bronze a partir do Kafka**  
→ objetivo de *rebuild* + mecanismo de *replay* do Kafka.

**Executar Rebuild da Gold a partir da Silver**  
→ *rebuild* sem *replay* do Kafka.

### 9.10 Replay e Processamento At-Least-Once

O *replay* faz com que uma entrada lógica já processada seja processada novamente de forma intencional.

A plataforma deve, portanto, assumir entregas repetidas.

A correção depende de:

- identidade estável da entrada;
- escopo de processamento explícito;
- comportamento idempotente;
- progresso controlado;
- validação.

O *replay* não deve depender da suposição de que a entrada histórica será automaticamente reconhecida sem uma estratégia implementada de deduplicação ou idempotência.

### 9.11 Replay e Idempotência

Um *replay* pode encontrar um estado *downstream* já produzido pelo processamento original.

A implementação deve determinar qual comportamento é pretendido.

Dependendo da camada, o *replay* pode:

- detectar um evento lógico existente e evitar um efeito de negócio adicional;
- substituir deterministicamente um estado derivado equivalente;
- regenerar um destino isolado;
- preencher uma nova versão de processamento;
- executar *rebuild* de um estado de destino limpo.

O comportamento do *replay* deve ser explícito.

### 9.12 Replay e Saída Existente

Antes do início do *replay*, o procedimento de recuperação deve determinar o que acontecerá com a saída *downstream* existente quando a mesma entrada for processada novamente.

As estratégias possíveis incluem:

**Preservar a Saída Existente**  
→ o processamento de *replay* deve ser idempotente em relação a ela.

**Substituir Escopo Controlado**  
→ o estado derivado afetado é limpo ou substituído por meio de uma operação governada.

**Gravar Nova Versão**  
→ o *replay* produz uma candidata ou versão de processamento separada.

A estratégia depende da camada afetada e do objetivo da recuperação.

### 9.13 Replay e Offsets Kafka

Os *offsets* Kafka fornecem um limite de *replay* preciso e específico por partição.

Um procedimento de *replay* deve identificar:

- *topic*;
- partição;
- *offset* originalmente confirmado;
- *offset* inicial selecionado para o *replay*;
- limite final pretendido;
- identidade do consumidor ou mecanismo de *replay*.

Os *offsets* não devem ser redefinidos casualmente em um contexto de consumidor compartilhado.

Uma ação de *replay* pode afetar um processamento *downstream* substancial e deve permanecer controlada e rastreável.

### 9.14 Estratégia do Consumidor de Replay

O *replay* pode utilizar o consumidor de processamento normal ou uma execução dedicada e controlada de recuperação, dependendo da implementação.

Um contexto dedicado de *replay* pode oferecer vantagens como:

- isolamento do processamento em tempo real;
- limites históricos explícitos;
- progresso independente;
- validação mais segura;
- menor risco de alterar os *checkpoints* normais dos consumidores.

A implementação da V1 deve selecionar o mecanismo mais simples que preserve comportamento correto e observável.

### 9.15 Replay e Processamento em Tempo Real

O *replay* pode ocorrer enquanto novos eventos continuam chegando.

A arquitetura deve definir como o processamento histórico e o processamento em tempo real interagem.

As abordagens possíveis incluem:

- pausar o processamento em tempo real durante o *replay*;
- executar o *replay* em um contexto isolado e reconciliar antes da promoção;
- processar o histórico acumulado até que o consumidor alcance naturalmente os eventos atuais;
- criar uma nova versão derivada a partir do histórico reproduzido.

A abordagem selecionada deve impedir que uma intercalação não controlada produza um estado inconsistente.

### 9.16 Ordenação do Replay

O *replay* deve preservar as garantias de ordenação exigidas pela lógica de processamento afetada.

A ordenação do Kafka é definida dentro de uma partição.

O *replay* deve, portanto, respeitar:

- identidade da partição;
- ordem dos eventos dentro da partição;
- semânticas de negócio que dependem de sequência.

A arquitetura não deve assumir ordenação global entre partições Kafka independentes, a menos que um mecanismo explícito a forneça.

### 9.17 Escopo do Replay

O *replay* deve utilizar o menor escopo histórico que satisfaça com segurança o objetivo da recuperação.

Os escopos possíveis incluem:

- um registro, quando puder ser endereçado independentemente;
- um intervalo de uma partição;
- uma entidade;
- um intervalo de tempo;
- um *topic*;
- todo o histórico retido.

Um *replay* desnecessariamente amplo aumenta:

- custo de processamento;
- tempo de recuperação;
- exposição a duplicações;
- escopo da validação.

Um *replay* excessivamente restrito pode não executar corretamente o *rebuild* de um estado dependente.

### 9.18 Replay e Dependências

O escopo necessário do *replay* pode se estender além da entrada diretamente afetada quando a lógica *downstream* depende de contexto histórico ao redor dela.

Por exemplo, o processamento pode depender de:

- estado anterior da entidade;
- sequência de alterações;
- dados de referência válidos no momento;
- histórico dimensional;
- eventos anteriores.

Os limites do *replay* devem, portanto, refletir a semântica do processamento, e não apenas o evento individual que revelou o problema.

### 9.19 Replay e Contratos Históricos

Os eventos reproduzidos devem permanecer interpretáveis de acordo com seus contratos de eventos aplicáveis.

Se o histórico Kafka retido contiver múltiplas versões de contrato, o *replay* deve preservar a interpretação orientada por versão.

A plataforma não deve interpretar silenciosamente um evento antigo utilizando suposições atuais incompatíveis.

A compatibilidade dos contratos históricos faz parte da capacidade de recuperação por *replay*.

### 9.20 Replay e Versões de Processamento

O *replay* não determina, por si só, qual versão de processamento deve tratar os eventos históricos.

Os objetivos possíveis incluem:

**Reprodução Histórica**  
→ executar o *replay* utilizando a definição de processamento historicamente aplicável.

**Reexpressão Histórica**  
→ executar o *replay* utilizando uma definição de processamento corrigida ou atual.

A versão de processamento selecionada deve ser explícita e preservada na linhagem.

### 9.21 Replay e Evolução de Schema

A evolução de *schema* não deve tornar os eventos retidos inutilizáveis para *replay*.

Quando eventos históricos utilizarem *schemas* ou versões de contrato mais antigas, a plataforma deve preservar lógica de interpretação suficiente para processá-los de acordo com o objetivo de recuperação pretendido.

Uma alteração incompatível que torne o histórico retido de recuperação não interpretável reduz a recuperabilidade, mesmo que os eventos permaneçam fisicamente presentes.

### 9.22 Replay e Estado da Fonte Excluído ou Alterado

O *replay* utiliza o evento histórico conforme retido.

Ele não deve assumir que o estado atual do AtlasCommerce ainda corresponde ao estado representado quando o evento foi produzido.

Por exemplo, uma entidade pode ter:

- sido alterada;
- sido desativada;
- sido excluída;
- recebido atributos posteriormente.

O *replay* deve preservar a semântica do evento retido, a menos que o objetivo da recuperação defina explicitamente uma reexpressão histórica utilizando informações atuais.

### 9.23 Replay e Bronze

O *replay* do Kafka é particularmente importante para a recuperação da Bronze.

Quando o histórico Kafka necessário permanecer retido:

**Falha ou Lacuna na Bronze**  
→ selecionar o intervalo Kafka afetado  
→ executar *replay* dos eventos  
→ persistir corretamente na Bronze  
→ validar a continuidade.

A Bronze deve preservar a identidade e os metadados do evento de origem em quantidade suficiente para demonstrar a relação entre a entrada Kafka reproduzida e o estado histórico persistido.

### 9.24 Replay e Silver

A Silver pode ser submetida a *rebuild* a partir da Bronze sem exigir *replay* do Kafka.

Se o objetivo da recuperação estiver totalmente *downstream* de uma Bronze válida, executar *replay* do Kafka adicionará escopo desnecessário.

O *replay* do Kafka não deve, portanto, tornar-se a resposta padrão para todo problema na Silver.

O limite *upstream* confiável apropriado deve determinar o mecanismo de recuperação.

### 9.25 Replay e Gold

A recuperação da Gold normalmente utiliza uma Silver válida, e não *replay* do Kafka.

O *replay* do Kafka pode participar indiretamente de um *rebuild* mais amplo quando o estado *upstream* precisar ser recuperado primeiro.

Por exemplo:

**Bronze Inválida**  
→ executar *replay* do Kafka  
→ executar *rebuild* da Bronze  
→ reprocessar Silver  
→ executar *rebuild* da Gold.

Essa é uma sequência de recuperação composta, e não simplesmente um *replay* da Gold.

### 9.26 Replay e Certified Gold

A Certified Gold não deve ser submetida a *rebuild* diretamente por meio de *replay* de eventos não controlado.

O *replay* histórico pode produzir um novo estado candidato *downstream*.

Esse estado ainda deve passar por:

- conclusão do processamento;
- validação de qualidade;
- reconciliação;
- requisitos de linhagem;
- certificação;
- publicação controlada.

O *replay* nunca ignora a certificação.

### 9.27 Replay e Checkpoints

O *replay* revisita intencionalmente uma posição anterior ao progresso normalmente confirmado.

A plataforma deve distinguir:

**Checkpoint de Processamento Normal**

de:

**Posição de Processamento do Replay**

quando necessário.

Um *replay* não deve substituir acidentalmente o progresso normal de forma que provoque reprocessamento prolongado ou perda de eventos atuais.

### 9.28 Replay e Grupos de Consumidores

O estado dos grupos de consumidores Kafka deve ser tratado cuidadosamente durante o *replay*.

As abordagens de implementação possíveis incluem:

- redefinição controlada de *offset*;
- grupo de consumidores dedicado ao *replay*;
- consumidor de recuperação isolado;
- contexto temporário de processamento.

O mecanismo selecionado deve evitar interferência não intencional em consumidores não relacionados.

A arquitetura deve preferir isolamento explícito quando o comportamento do *replay* puder alterar o progresso normal dos consumidores.

### 9.29 Replay e Retenção

A capacidade de executar *replay* existe somente enquanto o histórico de eventos necessário permanecer retido.

A janela de *replay* é, portanto, limitada pela retenção do Kafka.

Uma solicitação de *replay* deve determinar se o intervalo completo necessário ainda existe antes do início da execução.

Se parte do intervalo tiver expirado, executar *replay* somente da parte restante pode produzir um estado *downstream* incompleto.

A estratégia de recuperação deve então avançar para outra fonte.

O *replay* não deve prosseguir silenciosamente com um intervalo incompleto apenas porque alguns eventos históricos ainda permanecem disponíveis.

### 9.30 Esgotamento da Janela de Replay

Quando o intervalo Kafka necessário não estiver mais completamente disponível:

**Replay Kafka**  
→ deixa de ser suficiente.

A próxima fonte de recuperação apropriada pode ser:

- Bronze;
- AtlasCommerce por meio de *backfill* controlado;
- *backup* ou arquivo;
- outra fonte histórica governada.

A escolha correta depende de qual estado está ausente e de qual camada precisa ser recuperada.

O *replay* não deve prosseguir silenciosamente com uma recuperação parcial quando o intervalo necessário estiver incompleto.

### 9.31 Replay e Backlog

O *replay* cria carga de processamento adicional ao processamento normal em tempo real.

Um *replay* grande pode, portanto, aumentar o *backlog* ou competir com as cargas atuais.

O planejamento do *replay* deve considerar:

- volume do *replay*;
- taxa atual de ingestão;
- capacidade de processamento disponível;
- janela de retenção;
- atualidade dos consumidores;
- capacidade dos recursos *downstream*.

A recuperação não deve criar inadvertidamente um segundo incidente operacional por meio de uma carga de *replay* não controlada.

### 9.32 Limitação de Velocidade do Replay

Operações grandes de *replay* podem exigir taxas de processamento controladas.

A limitação de velocidade pode ajudar a:

- proteger o armazenamento *downstream*;
- proteger dependências compartilhadas;
- preservar capacidade de processamento em tempo real;
- reduzir exaustão de recursos;
- manter a observabilidade.

A implementação deve equilibrar velocidade de recuperação e estabilidade da plataforma.

A maior velocidade possível de *replay* nem sempre é a velocidade de recuperação mais segura.

### 9.33 Falha no Replay

O próprio *replay* pode falhar.

As possíveis causas incluem:

- incompatibilidade de contrato histórico;
- defeito de processamento;
- falha de armazenamento;
- limite de *replay* inválido;
- exaustão de recursos;
- registro problemático (*poison record*);
- falha de dependência.

A recuperação de uma falha no *replay* deve seguir os mesmos princípios de confiabilidade do processamento normal.

Falhas repetidas de *replay* não devem levar à manipulação não controlada de *checkpoints* ou à repetição de *replay* amplo sem investigação.

### 9.34 Cancelamento do Replay

Um *replay* pode precisar ser interrompido quando:

- o limite selecionado estiver incorreto;
- efeitos *downstream* inesperados aparecerem;
- o impacto sobre os recursos se tornar inseguro;
- a validação identificar uma saída incorreta;
- uma fonte de recuperação mais apropriada for descoberta.

O cancelamento deve preservar estado suficiente para determinar:

- qual trabalho de *replay* foi concluído;
- qual saída foi produzida;
- o que precisa ser limpo ou invalidado;
- se o processamento normal foi afetado.

### 9.35 Validação do Replay

A validação do *replay* deve confirmar, quando aplicável:

- fonte correta do *replay*;
- intervalo necessário completo;
- limites inicial e final esperados;
- ordenação correta dos eventos;
- versão de processamento apropriada;
- ausência de lacuna de processamento não intencional;
- ausência de efeito de negócio duplicado não intencional;
- quantidades esperadas de registros nas camadas *downstream*;
- resultados de qualidade;
- resultados de reconciliação;
- integridade do *checkpoint*;
- linhagem;
- estado de certificação;
- atualidade final.

A conclusão bem-sucedida de um comando de *replay* não demonstra, por si só, a correção da recuperação.

### 9.36 Evidências do Replay

As evidências representativas de *replay* devem preservar:

- objetivo da recuperação;
- *topic*;
- partição ou partições;
- limite inicial do *replay*;
- limite final do *replay*;
- quantidade de eventos ou intervalo;
- posição de processamento original;
- identificador da execução de *replay*;
- versão de processamento;
- ocorrência observada de entrega duplicada;
- resultado do tratamento da duplicação;
- estado *downstream* antes do *replay*;
- estado *downstream* depois do *replay*;
- resultados da validação;
- tempo decorrido;
- conclusão final.

As evidências devem permitir que outro revisor compreenda exatamente qual histórico foi revisitado e por quê.

### 9.37 Cenários de Teste de Replay

A V1 deve validar cenários representativos de *replay*, como:

**Teste de Replay 1 — Interrupção do Consumidor**  
→ interromper o consumo da Bronze  
→ permitir que o *backlog* Kafka se acumule  
→ restaurar o consumidor  
→ verificar que o processamento retoma a partir do progresso confirmado.

**Teste de Replay 2 — Replay Histórico Controlado**  
→ selecionar um intervalo Kafka previamente processado  
→ executar intencionalmente o *replay*  
→ verificar o comportamento idempotente do processamento *downstream*.

**Teste de Replay 3 — Replay Específico de Partição**  
→ executar *replay* de um intervalo delimitado de uma partição  
→ verificar que as partições não afetadas permanecem corretas.

**Teste de Replay 4 — Limite de Retenção**  
→ demonstrar a relação entre o histórico Kafka retido e a janela de *replay* disponível sem destruir intencionalmente dados necessários ao projeto.

Os testes exatos devem ser implementados de acordo com a topologia final da V1.

### 9.38 Garantias do Replay

O modelo de *replay* da Atlas Engineering deve preservar as seguintes garantias:

1. *replay* é o reconsumo controlado de uma entrada anteriormente retida;
2. *replay* permanece distinto de reinicialização, nova tentativa, reprocessamento, *backfill* e *rebuild*;
3. o Kafka é a fonte preferencial de *replay* enquanto o histórico necessário permanecer retido e confiável;
4. os limites inicial e final do *replay* são explícitos quando existir um escopo de recuperação delimitado;
5. o *replay* não afirma recriar eventos que não estão mais disponíveis;
6. o *replay* pressupõe entregas repetidas e, portanto, depende de processamento idempotente;
7. a saída *downstream* existente é avaliada antes que a entrada histórica seja processada novamente;
8. o *replay* Kafka preserva as semânticas de ordenação específicas de cada partição;
9. o escopo do *replay* é o menor escopo seguro capaz de atender ao objetivo da recuperação;
10. as dependências históricas são consideradas na seleção dos limites do *replay*;
11. os contratos históricos de eventos permanecem interpretáveis;
12. a versão de processamento utilizada pelo *replay* é explícita;
13. a evolução de *schema* não invalida silenciosamente o histórico retido para *replay*;
14. o estado atual da fonte não substitui a semântica histórica dos eventos sem uma decisão explícita de reexpressão;
15. o *replay* Kafka é utilizado para recuperação da Bronze somente quando o intervalo de eventos necessário permanece completo;
16. um estado Bronze ou Silver válido é preferido ao *replay* desnecessário do Kafka para recuperações exclusivamente *downstream*;
17. o *replay* nunca ignora a certificação da Gold ou a publicação controlada;
18. o progresso do *replay* não corrompe inadvertidamente o progresso normal dos consumidores;
19. alterações nos grupos de consumidores utilizadas para *replay* são controladas e rastreáveis;
20. a capacidade de *replay* permanece limitada pela retenção;
21. intervalos retidos incompletos provocam escalonamento para outra fonte de recuperação, e não recuperação parcial silenciosa;
22. a carga do *replay* é controlada para evitar instabilidade no processamento normal;
23. falhas e cancelamentos de *replay* permanecem recuperáveis e observáveis;
24. os resultados do *replay* são validados quanto ao processamento e à correção dos dados;
25. o comportamento representativo de *replay* é demonstrado por meio de evidências controladas.

---

## 10. Reprocessamento

Reprocessamento é a execução controlada de entradas históricas por meio de uma definição de processamento após essas entradas já terem sido processadas anteriormente.

A Atlas Engineering utiliza reprocessamento quando um estado derivado existente precisa ser recalculado, corrigido, reapresentado ou validado utilizando entradas históricas governadas.

O modelo orientador é:

**Entrada Histórica Governada → Selecionar Definição de Processamento → Definir Escopo de Reprocessamento → Executar Novamente → Validar Estado Derivado → Preservar Linhagem**

O reprocessamento diz respeito à execução repetida da lógica de processamento.

Ele não define, por si só, como a entrada histórica é obtida.

A entrada histórica pode ser fornecida por meio de:

- *replay* do Kafka;
- dados históricos da Bronze;
- estado persistido da Silver;
- *backfill* controlado;
- outra fonte governada de recuperação apropriada ao objetivo.

### 10.1 Propósito do Reprocessamento

O reprocessamento pode ser necessário quando:

- um defeito de transformação é corrigido;
- uma regra de negócio é alterada;
- uma interpretação histórica precisa ser reapresentada;
- dados derivados estão incompletos;
- uma execução anterior de processamento produziu resultados incorretos;
- uma versão de processamento é alterada;
- qualidade ou reconciliação identifica inconsistência histórica;
- estado *downstream* precisa ser regenerado;
- um teste de recuperação valida intencionalmente a reprodutibilidade.

O reprocessamento deve possuir uma razão explícita e um objetivo limitado.

Ele não deve se tornar uma rotina não documentada para corrigir diferenças de dados não explicadas.

### 10.2 Reprocessamento versus Replay

*Replay* e reprocessamento descrevem partes diferentes de uma operação de recuperação.

**Replay**
→ a entrada histórica é entregue novamente a partir do histórico retido de eventos.

**Reprocessamento**
→ a entrada histórica é executada novamente por meio da lógica de processamento.

Por exemplo:

**Offsets do Kafka Reconsumidos**
→ *replay*.

**Eventos Submetidos a Replay Processados por Meio da Lógica Corrigida da Bronze ou Silver**
→ reprocessamento.

O reprocessamento pode, portanto, ocorrer com ou sem *replay* do Kafka.

### 10.3 Reprocessamento versus Reinicialização

A reinicialização retoma o processamento interrompido a partir do progresso confirmado.

O reprocessamento revisita intencionalmente entradas que já eram consideradas processadas.

Uma reinicialização pode causar uma reentrega limitada ao redor de um limite de confirmação.

Isso não constitui automaticamente um reprocessamento histórico governado.

### 10.4 Reprocessamento versus Nova Tentativa

Uma nova tentativa repete uma operação porque a tentativa anterior falhou ou produziu um resultado incerto.

O reprocessamento executa intencionalmente entradas históricas novamente, mesmo que o processamento anterior possa ter sido concluído.

Conceitualmente:

**Nova Tentativa**
→ tentar concluir a operação pretendida.

**Reprocessamento**
→ calcular intencionalmente o resultado histórico novamente.

### 10.5 Reprocessamento versus Backfill

O reprocessamento opera sobre entradas históricas que já estão disponíveis por meio de uma fonte governada de recuperação.

*Backfill* fornece os dados históricos necessários quando o histórico normal de processamento retido está indisponível ou é insuficiente.

Um *backfill* pode posteriormente ser reprocessado por meio da lógica *downstream*.

As duas operações devem permanecer identificáveis separadamente na linhagem e nas evidências.

### 10.6 Reprocessamento versus Rebuild

O reprocessamento executa entradas históricas novamente.

*Rebuild* reconstrói um estado derivado.

Um *rebuild* normalmente utiliza reprocessamento como parte de sua implementação.

Por exemplo:

**Histórico da Bronze**
→ reprocessar Silver  
→ reconstruir o estado completo da Silver.

O objetivo é um *rebuild* da Silver.

A execução repetida da Bronze por meio da lógica da Silver é reprocessamento.

### 10.7 Fonte de Reprocessamento

O reprocessamento deve começar a partir de uma fonte confiável apropriada.

Fontes representativas incluem:

- eventos retidos do Kafka;
- Bronze;
- Silver;
- *backfill* controlado da origem;
- *backup* ou arquivo restaurado.

A fonte correta depende de qual estágio de processamento está sendo recalculado.

A fonte de recuperação deve estar *upstream* do defeito ou estado inválido que está sendo corrigido.

### 10.8 Escopo do Reprocessamento

Toda operação de reprocessamento deve definir seu escopo pretendido.

Possíveis escopos incluem:

- um evento;
- uma entidade;
- uma partição;
- uma chave de negócio;
- um intervalo de data ou tempo;
- um conjunto de dados;
- uma versão de processamento;
- um produto de dados;
- todo o histórico retido.

O menor escopo seguro deve normalmente ser preferido.

O escopo ainda deve incluir todo o contexto histórico necessário para o processamento correto.

### 10.9 Dependências do Escopo

Um defeito observado em um registro não significa necessariamente que apenas esse registro possa ser reprocessado com segurança.

O processamento pode depender de:

- eventos precedentes;
- eventos posteriores;
- histórico da entidade;
- dados de referência;
- datas de vigência;
- histórico dimensional;
- janelas de agregação;
- entidades de negócio relacionadas.

O escopo do reprocessamento deve, portanto, ser baseado na semântica de processamento, e não apenas no sintoma visível.

### 10.10 Reprocessamento com a Mesma Lógica

Entradas históricas podem ser reprocessadas utilizando a mesma definição de processamento quando o objetivo for:

- recuperar saída derivada ausente;
- reproduzir um resultado anterior;
- validar comportamento determinístico;
- recuperar após perda de estado derivado;
- verificar idempotência.

O resultado lógico esperado deve permanecer equivalente quando:

- a entrada for equivalente;
- a definição de processamento for equivalente;
- as dependências necessárias forem equivalentes.

Diferenças inesperadas exigem investigação.

### 10.11 Reprocessamento com Lógica Corrigida

Entradas históricas podem ser intencionalmente reprocessadas após a correção de um defeito de processamento.

Conceitualmente:

**Entrada Histórica**
→ processamento defeituoso produziu estado inválido.

Então:

**Mesma Entrada Histórica**
→ definição de processamento corrigida  
→ estado derivado corrigido.

O estado resultante é um novo resultado governado de processamento.

Ele não deve ser representado como se tivesse sido produzido pela implementação defeituosa original.

### 10.12 Reprocessamento com Nova Lógica

O reprocessamento também pode aplicar intencionalmente uma nova definição de negócio ou analítica a entradas históricas.

Por exemplo:

**Bronze Histórica**
→ Silver V2  
→ dados históricos reapresentados de acordo com a nova definição padronizada.

Essa é uma reapresentação histórica.

Ela difere de uma recuperação destinada apenas a reproduzir o estado histórico original.

A razão para aplicar a nova lógica deve permanecer explícita.

### 10.13 Reprodução Histórica

A reprodução histórica tenta recriar o resultado que deveria ter existido sob a definição de processamento historicamente aplicável.

Ela pode exigir:

- *schema* histórico;
- contrato histórico;
- transformação histórica;
- estado histórico de referência;
- regras históricas de qualidade;
- lógica dimensional histórica.

O objetivo é:

**Entrada Histórica + Definição Histórica Aplicável → Resultado Histórico Esperado**

### 10.14 Reapresentação Histórica

A reapresentação histórica recalcula intencionalmente dados históricos utilizando uma definição mais recente ou corrigida.

O objetivo é:

**Entrada Histórica + Nova Definição Selecionada → Novo Resultado Histórico**

A reapresentação pode alterar legitimamente valores derivados anteriormente.

A plataforma deve preservar linhagem suficiente para explicar por que o resultado histórico foi alterado.

### 10.15 Seleção da Versão de Reprocessamento

Toda operação governada de reprocessamento deve saber qual definição de processamento está sendo aplicada.

O contexto relevante de versão pode incluir:

- contrato de evento;
- *schema* da origem;
- interpretação da Bronze;
- transformação da Silver;
- interpretação dos dados de referência;
- transformação da Gold;
- regras de qualidade;
- regras de reconciliação.

A seleção da versão deve ser deliberada.

A plataforma não deve aplicar silenciosamente qualquer implementação que esteja implantada no momento.

### 10.16 Reprocessamento e Determinismo

Quando a semântica de processamento for determinística, entradas equivalentes e definições de processamento equivalentes devem produzir resultados pretendidos equivalentes.

Conceitualmente:

**Mesma Entrada Governada**
+
**Mesma Definição de Processamento**
+
**Mesmo Contexto de Referência Necessário**
→ **Mesmo Resultado Pretendido**

Essa propriedade melhora:

- reprodutibilidade;
- validação da recuperação;
- investigação de defeitos;
- auditabilidade.

Comportamentos externos ou dependentes do tempo que possam alterar o resultado devem ser controlados ou capturados quando necessário.

### 10.17 Reprocessamento e Tempo Atual

A lógica de processamento deve evitar o uso de valores não controlados de tempo atual quando a correção histórica depender do tempo de negócio original.

Para reprocessamento histórico, a distinção entre:

- tempo do evento;
- tempo da transação na origem;
- tempo de ingestão;
- tempo de processamento;
- tempo de reprocessamento;

pode ser importante.

O reprocessamento não deve reinterpretar silenciosamente o estado histórico de negócio apenas porque a execução ocorre em uma data posterior.

### 10.18 Reprocessamento e Dados de Referência

Resultados históricos podem depender de dados de referência.

Se os valores de referência mudarem ao longo do tempo, o reprocessamento deve determinar se o objetivo exige:

**Estado Histórico de Referência**
→ reproduzir a interpretação histórica.

ou:

**Estado Atual de Referência**
→ reapresentar intencionalmente o histórico.

A escolha deve ser governada e rastreável.

Utilizar acidentalmente dados de referência atuais pode produzir um resultado histórico diferente sem qualquer alteração na entrada histórica principal.

### 10.19 Reprocessamento e Dimensões Lentamente Mutáveis

O processamento dimensional da Gold pode depender de intervalos históricos de validade.

O reprocessamento deve preservar a semântica temporal correta ao reconstruir:

- versões de dimensões;
- relacionamentos de chaves substitutas;
- datas de vigência;
- relacionamentos históricos de fatos.

O processamento de eventos históricos em uma ordem de execução diferente ou com contexto incompleto não deve colapsar ou distorcer silenciosamente o histórico dimensional.

### 10.20 Reprocessamento e Estado Existente

Antes do início do reprocessamento, o procedimento deve determinar como o estado derivado existente será tratado.

Possíveis estratégias incluem:

**Merge Idempotente**
→ o estado existente permanece e o processamento repetido converge para o resultado pretendido.

**Substituição Controlada**
→ o escopo afetado é substituído.

**Nova Versão**
→ o reprocessamento grava um estado candidato separado.

**Rebuild Completo**
→ o estado derivado de destino é reconstruído a partir de um limite limpo.

A estratégia selecionada depende da camada de processamento e do objetivo.

### 10.21 Reprocessamento In-Place

O reprocessamento *in-place* modifica ou substitui um estado derivado existente dentro de seu destino governado.

Ele pode ser apropriado quando:

- o escopo afetado é conhecido com precisão;
- o processamento é determinístico;
- *rollback* está disponível quando necessário;
- exposição parcial pode ser impedida;
- a validação pode comprovar a correção.

A correção *in-place* não deve expor consumidores a uma mistura descontrolada de estado antigo e novo.

### 10.22 Reprocessamento Versionado

O reprocessamento versionado produz uma versão derivada separada, em vez de modificar diretamente o estado atualmente governado.

Essa abordagem é particularmente útil para a Gold.

Conceitualmente:

**Certified Gold V1 Atual**
→ permanece visível aos consumidores.

Enquanto isso:

**Entrada Histórica**
→ processamento corrigido  
→ Candidata Gold V2  
→ validar  
→ certificar  
→ publicar.

O reprocessamento versionado reduz o risco de que o trabalho de recuperação danifique diretamente o último estado analítico reconhecidamente válido.

### 10.23 Reprocessamento e Processamento Ativo

O reprocessamento histórico pode ocorrer enquanto o processamento ativo continua.

A arquitetura deve definir como ambas as cargas de trabalho interagem.

Possíveis estratégias incluem:

- pausar o processamento ativo afetado;
- isolar o reprocessamento histórico;
- criar uma nova versão derivada;
- processar um escopo histórico limitado e reconciliar antes da retomada;
- realizar *rebuild* do estado afetado e executar uma transição controlada.

A estratégia selecionada deve impedir que a execução histórica e a ativa produzam estados sobrepostos inconsistentes.

### 10.24 Isolamento do Reprocessamento

O reprocessamento deve ser isolado do processamento não afetado quando praticável.

O isolamento pode ocorrer por:

- conjunto de dados;
- entidade;
- partição;
- versão de processamento;
- execução;
- caminho de destino;
- versão candidata.

O isolamento reduz o raio de impacto e simplifica a validação.

Ele não deve romper dependências necessárias para a reconstrução histórica correta.

### 10.25 Reprocessamento e Checkpoints

O reprocessamento histórico não deve corromper involuntariamente os *checkpoints* comuns do processamento ativo.

Quando o reprocessamento utiliza entradas históricas anteriores à posição normalmente confirmada, ele pode exigir:

- estado independente de *checkpoint*;
- metadados dedicados de execução;
- grupo de consumidores isolado;
- intervalo histórico explícito.

O progresso comum e o progresso do reprocessamento devem permanecer distinguíveis.

### 10.26 Reprocessamento e Linhagem

A saída reprocessada deve preservar linhagem suficiente para identificar:

- execução de recuperação ou reprocessamento;
- fonte de entrada;
- intervalo de entrada;
- versão da entrada;
- definição de processamento;
- versão da saída;
- motivo do reprocessamento;
- resultado da validação.

Para estado histórico corrigido, a linhagem deve permitir que um revisor diferencie o resultado original do resultado corrigido.

### 10.27 Reprocessamento e Qualidade

O estado reprocessado permanece sujeito aos controles de qualidade aplicáveis.

Uma execução bem-sucedida não implica que a saída corrigida seja aceitável.

A validação de qualidade pode precisar avaliar:

- completude;
- unicidade;
- validade;
- consistência;
- correção temporal;
- regras de domínio.

Uma operação de reprocessamento que reproduza o mesmo defeito de qualidade não restaurou um estado confiável.

### 10.28 Reprocessamento e Reconciliação

A reconciliação é especialmente importante quando o reprocessamento modifica histórico previamente derivado.

A plataforma deve determinar se o estado resultante reconcilia com o limite *upstream* apropriado.

Dependendo do objetivo da recuperação, a reconciliação pode comparar:

- contagens originais versus reprocessadas;
- contagens da origem versus derivadas;
- totais de negócio;
- populações de entidades;
- intervalos históricos afetados;
- resultados antigos versus novos.

Diferenças esperadas causadas pela lógica corrigida devem ser distinguíveis de diferenças não explicadas.

### 10.29 Diferenças Esperadas

Uma lógica corrigida ou nova pode alterar intencionalmente resultados históricos.

Uma diferença em relação à saída anterior não é, portanto, automaticamente uma falha.

O plano de reprocessamento deve identificar:

- o que se espera que mude;
- por que deve mudar;
- qual escopo deve permanecer inalterado;
- como a diferença esperada será validada.

Alterações inesperadas fora do escopo pretendido exigem investigação.

### 10.30 Reprocessamento e Certificação

O estado reprocessado da Gold deve passar pelo mesmo limite governado de certificação exigido para a publicação normal da Gold.

O fluxo permanece:

**Candidata Gold Reprocessada**
→ qualidade  
→ reconciliação  
→ validação de linhagem  
→ certificação  
→ publicação.

A correção histórica não justifica contornar a certificação.

### 10.31 Falha de Reprocessamento

O próprio reprocessamento pode falhar.

Possíveis causas incluem:

- entrada histórica incompleta;
- contrato histórico incompatível;
- seleção incorreta de versão;
- defeito de processamento;
- falha de dependência;
- esgotamento de recursos;
- contexto de referência inválido;
- dados venenosos.

A falha deve preservar estado suficiente para determinar:

- qual escopo foi concluído;
- qual saída foi produzida;
- o que permanece inválido;
- se uma nova tentativa é segura;
- se o destino deve ser descartado;
- se outra fonte de recuperação é necessária.

### 10.32 Falha Parcial de Reprocessamento

Uma operação de reprocessamento parcialmente concluída não deve se tornar silenciosamente o estado derivado aceito.

Quando a substituição atômica não estiver disponível, a implementação deve identificar a saída incompleta e impedir a publicação descontrolada.

Possíveis respostas incluem:

- invalidar a candidata;
- descartar o destino incompleto;
- retomar a partir de um *checkpoint* seguro;
- repetir o escopo afetado de forma idempotente;
- realizar *rebuild* do destino.

A resposta correta depende da semântica do destino.

### 10.33 Cancelamento do Reprocessamento

Uma execução de reprocessamento pode ser cancelada quando:

- o escopo selecionado estiver incorreto;
- surgir uma saída inesperada;
- o impacto sobre os recursos se tornar inseguro;
- a versão de processamento incorreta tiver sido selecionada;
- o contexto histórico necessário estiver ausente.

O cancelamento deve preservar metadados suficientes para determinar qual saída foi produzida e se limpeza ou invalidação é necessária.

### 10.34 Impacto de Recursos do Reprocessamento

O reprocessamento histórico pode consumir quantidade substancial de:

- CPU;
- memória;
- largura de banda do Kafka;
- largura de banda de armazenamento;
- operações de armazenamento de objetos;
- capacidade do banco de dados;
- capacidade de orquestração.

Operações de reprocessamento de grande porte devem, portanto, considerar seu impacto sobre as cargas de trabalho ativas.

Uma reconstrução histórica rápida não deve desestabilizar desnecessariamente o processamento atual.

### 10.35 Prioridade do Reprocessamento

A prioridade do reprocessamento deve refletir o impacto de negócio e de confiabilidade do estado que está sendo corrigido.

Fatores relevantes incluem:

- impacto sobre a correção;
- consumidor afetado;
- intervalo histórico afetado;
- classificação dos dados;
- estado da publicação;
- disponibilidade de uma Certified Gold reconhecidamente válida;
- restrições da janela de recuperação;
- requisitos de recursos.

Nem toda correção histórica exige processamento imediato de toda a plataforma.

### 10.36 Validação do Reprocessamento

A validação deve confirmar, quando aplicável:

- fonte correta de recuperação;
- escopo completo da entrada;
- versão correta de processamento;
- contexto histórico correto;
- escopo esperado da saída;
- ausência de efeitos de negócio duplicados não pretendidos;
- ausência de lacunas de processamento;
- alterações históricas esperadas;
- ausência de alterações não explicadas fora do escopo;
- resultados de qualidade;
- resultados de reconciliação;
- linhagem;
- integridade dos *checkpoints*;
- estado de certificação.

O reprocessamento está concluído somente quando o estado resultante demonstrar atender ao objetivo pretendido.

### 10.37 Evidências de Reprocessamento

Evidências representativas de reprocessamento devem preservar:

- motivo do reprocessamento;
- camada afetada;
- fonte de entrada;
- intervalo histórico;
- versão original de processamento;
- versão de processamento selecionada;
- diferenças esperadas;
- identificador da execução;
- versão da saída;
- contagens de registros;
- resultados de qualidade;
- resultados de reconciliação;
- diferenças observadas;
- tempo decorrido;
- estado final de certificação ou recuperação.

As evidências devem tornar a correção histórica reproduzível e explicável.

### 10.38 Cenários de Teste de Reprocessamento

A Versão 1 deve validar cenários representativos, como:

**Teste de Reprocessamento 1 — Mesma Lógica**
→ selecionar um intervalo histórico limitado da Bronze  
→ processá-lo novamente utilizando a mesma definição da Silver  
→ demonstrar resultado pretendido equivalente.

**Teste de Reprocessamento 2 — Lógica Corrigida**
→ introduzir ou simular um defeito conhecido de transformação  
→ preservar o resultado inválido como evidência  
→ corrigir a transformação  
→ reprocessar o histórico afetado  
→ demonstrar o resultado corrigido.

**Teste de Reprocessamento 3 — Isolamento de Escopo**
→ reprocessar uma entidade ou intervalo histórico limitado  
→ demonstrar que o estado não relacionado permanece inalterado.

**Teste de Reprocessamento 4 — Candidata Gold**
→ reprocessar uma Silver válida por meio de uma definição alterada da Gold  
→ gerar uma nova candidata  
→ validar e certificar antes da publicação.

Os cenários exatos devem refletir a implementação final da Versão 1.

### 10.39 Garantias de Reprocessamento

O modelo de reprocessamento da Atlas Engineering deve preservar as seguintes garantias:

1. reprocessamento é a execução repetida e intencional de entradas históricas governadas;
2. reprocessamento permanece distinto de reinicialização, nova tentativa, *replay*, *backfill* e *rebuild*;
3. entradas históricas podem ser obtidas de diferentes fontes confiáveis de recuperação;
4. toda operação de reprocessamento possui objetivo e escopo explícitos;
5. o reprocessamento começa a partir de um limite *upstream* do estado ou da lógica que está sendo corrigida;
6. as dependências de processamento determinam o menor escopo histórico seguro;
7. reprocessamento com a mesma entrada e a mesma definição deve produzir o mesmo resultado pretendido quando o processamento for determinístico;
8. lógica corrigida pode produzir intencionalmente um novo resultado histórico;
9. reprodução histórica permanece distinta de reapresentação histórica;
10. a seleção da versão de processamento é explícita;
11. comportamento não controlado de tempo atual não altera silenciosamente a semântica histórica;
12. o contexto histórico de referência é preservado ou intencionalmente substituído de acordo com o objetivo;
13. o histórico temporal e dimensional permanece correto durante a reconstrução;
14. o estado de destino existente é tratado por meio de uma estratégia explícita;
15. o reprocessamento versionado protege o estado reconhecidamente válido e visível aos consumidores quando apropriado;
16. a interação entre processamento histórico e ativo é controlada;
17. o progresso do reprocessamento não altera involuntariamente o progresso normal do processamento ativo;
18. a saída reprocessada preserva linhagem até sua entrada, definição de processamento e execução de recuperação;
19. controles de qualidade se aplicam ao estado reprocessado;
20. a reconciliação distingue correções esperadas de diferenças não explicadas;
21. a Gold reprocessada permanece sujeita à certificação;
22. reprocessamento parcial ou com falha não se torna silenciosamente um estado aceito;
23. reprocessamento cancelado permanece rastreável e recuperável;
24. o impacto sobre os recursos é considerado antes de grandes execuções históricas;
25. os resultados do reprocessamento são validados e sustentados por evidências controladas.

---

## 11. Backfill

*Backfill* é a introdução ou reconstrução controlada de dados históricos no fluxo de processamento analítico quando o estado necessário não pode ser obtido completamente por meio do *replay* normal dos eventos retidos.

A Atlas Engineering utiliza *backfill* quando informações operacionais históricas ou atuais precisam ser extraídas de uma fonte governada apropriada e incorporadas ao processamento *downstream* para preencher uma lacuna conhecida, inicializar o histórico necessário ou restaurar um estado que não está mais disponível pelo fluxo normal de eventos retidos.

O modelo orientador é:

**Identificar Estado Histórico Ausente ou Necessário → Selecionar Fonte Governada → Definir Escopo do Backfill → Extrair → Introduzir por Meio de Processamento Controlado → Reconciliar → Validar → Preservar Linhagem**

*Backfill* deve ser explícito, limitado, rastreável e governado.

Ele não deve se tornar um caminho alternativo e não documentado de ingestão.

### 11.1 Propósito do Backfill

*Backfill* pode ser necessário quando:

- o histórico necessário do Kafka tiver expirado;
- os eventos necessários nunca tiverem sido produzidos;
- uma lacuna de captura tiver impedido a entrada de dados na plataforma analítica;
- um conjunto de dados recém-introduzido exigir inicialização histórica;
- um novo atributo exigir população histórica;
- o histórico *downstream* retido estiver incompleto;
- o estado operacional atual puder restaurar um estado analítico necessário;
- um intervalo histórico limitado precisar ser recuperado de outra fonte governada.

*Backfill* deve atender a um requisito histórico definido.

Ele não deve ser utilizado apenas porque os procedimentos normais de recuperação são inconvenientes.

### 11.2 Backfill versus Replay

*Replay* consome eventos históricos que já existem em uma fonte de eventos retidos.

*Backfill* obtém os dados necessários de outra fonte governada porque o *replay* normal dos eventos retidos não consegue atender completamente ao objetivo da recuperação.

Conceitualmente:

**Histórico Necessário do Kafka Disponível**
→ *replay*.

**Histórico Necessário do Kafka Ausente ou Nunca Produzido**
→ avaliar *backfill*.

*Backfill* não deve ser descrito como *replay* quando o histórico original de eventos retidos não existe.

### 11.3 Backfill versus Reprocessamento

*Backfill* e reprocessamento descrevem responsabilidades diferentes.

**Backfill**
→ obtém e introduz os dados históricos necessários.

**Reprocessamento**
→ executa novamente os dados históricos por meio da lógica de processamento.

Um *backfill* pode posteriormente exigir reprocessamento por meio da Bronze, Silver, Gold ou de outro estágio governado.

A ação de recuperação da fonte e a ação de processamento *downstream* devem permanecer distinguíveis.

### 11.4 Backfill versus Rebuild

*Backfill* preenche um escopo de entrada histórica ausente ou necessário.

*Rebuild* reconstrói um estado derivado.

Um *rebuild* pode utilizar dados provenientes de *backfill* como parte de sua entrada.

Por exemplo:

**Estado Histórico da Origem Ausente**
→ realizar *backfill* a partir do AtlasCommerce  
→ persistir entrada histórica governada  
→ reprocessar a Silver  
→ realizar *rebuild* da Gold.

A recuperação completa contém múltiplos mecanismos com responsabilidades diferentes.

### 11.5 Backfill versus Reinicialização e Nova Tentativa

A reinicialização retoma uma execução interrompida.

Uma nova tentativa repete uma operação que falhou.

*Backfill* introduz estado histórico que a execução normal não consegue mais obter de forma suficiente a partir de seu fluxo normal retido.

Nem a reinicialização nem uma nova tentativa conseguem recriar entradas históricas que não estão mais disponíveis para o estágio de processamento afetado.

### 11.6 Fonte de Backfill

Um *backfill* deve utilizar uma fonte explicitamente governada.

Fontes representativas podem incluir:

- AtlasCommerce;
- *backup* restaurado da origem;
- extração histórica governada;
- arquivo;
- outra fonte autoritativa validada introduzida por uma arquitetura futura.

A fonte deve ser apropriada para os dados que estão sendo reconstruídos.

A disponibilidade conveniente não é suficiente.

### 11.7 Backfill do AtlasCommerce

O AtlasCommerce pode fornecer dados para *backfill* quando seu estado operacional puder atender ao objetivo da recuperação.

Um *backfill* controlado da origem deve minimizar o impacto sobre o sistema transacional.

A estratégia de extração deve considerar:

- escopo de negócio;
- colunas necessárias;
- custo da consulta;
- indexação;
- carga de trabalho da origem;
- intervalo de extração;
- consistência;
- isolamento;
- momento da execução.

*Backfill* não deve transformar o AtlasCommerce em uma plataforma rotineira de consultas analíticas.

### 11.8 Backfill de Estado Atual

Um *backfill* de estado atual reconstrói o estado *downstream* a partir do estado operacional existente no momento da extração.

Isso pode ser apropriado quando o objetivo da recuperação exigir a representação atual do negócio.

Por exemplo:

**Estado Atual do Cliente Ausente**
→ extrair o estado atual governado do cliente  
→ popular a representação *downstream* necessária.

O *backfill* de estado atual não reproduz alterações históricas que não estejam mais representadas na origem.

### 11.9 Backfill Histórico

O *backfill* histórico tenta recuperar informações de um intervalo passado ou de um estado de negócio anterior.

Ele exige uma fonte que realmente preserve as informações históricas necessárias.

Possíveis fontes podem incluir:

- tabelas de histórico da origem, quando implementadas;
- histórico operacional retido;
- *backup*;
- arquivo;
- outro conjunto de dados histórico governado.

A plataforma não deve inferir eventos históricos a partir do estado atual quando a semântica histórica necessária não puder ser estabelecida.

### 11.10 Backfill de Snapshot

Um *backfill* de *snapshot* captura o estado de uma entidade ou conjunto de dados em um ponto definido ou limite de extração.

O *backfill* de *snapshot* pode oferecer suporte a:

- população inicial da plataforma;
- integração de um novo conjunto de dados;
- reconstrução do estado atual;
- recuperação após perda de estado *downstream*.

Um *snapshot* representa estado.

Ele não representa automaticamente a sequência de alterações que produziu esse estado.

### 11.11 Backfill de Eventos

Quando existirem informações históricas de alterações suficientes fora da janela normal de retenção do Kafka, um *backfill* pode reconstruir entradas históricas semelhantes a eventos.

Essa reconstrução deve preservar, quando possível:

- identidade da origem;
- chave de negócio;
- ordenação histórica;
- tempo do evento ou da transação;
- semântica da operação;
- versão da origem;
- proveniência do *backfill*.

A reconstrução de eventos sintéticos não deve ser representada como eventos CDC originalmente capturados quando tiver sido produzida por meio de um mecanismo diferente.

### 11.12 Evento Original versus Evento Reconstruído

A Atlas Engineering deve distinguir:

**Evento Original Capturado**
→ produzido por meio do fluxo normal de CDC e Debezium.

**Evento Histórico Reconstruído**
→ gerado posteriormente a partir de outra fonte governada para recuperar informações históricas ausentes.

Ambos podem oferecer suporte ao processamento *downstream*.

Suas proveniências são diferentes e devem permanecer visíveis nos metadados e na linhagem.

### 11.13 Escopo do Backfill

Todo *backfill* deve definir seu escopo.

Dimensões relevantes podem incluir:

- entidade;
- chave de negócio;
- tabela de origem;
- intervalo de datas;
- intervalo de transações;
- escopo geográfico;
- produto de dados;
- atributo ausente;
- camada *downstream* afetada.

O menor escopo seguro deve normalmente ser preferido.

O escopo ainda deve conter todas as informações necessárias para restaurar corretamente o estado *downstream*.

### 11.14 Limite do Backfill

Um *backfill* deve definir limites inicial e final explícitos quando o objetivo da recuperação for baseado em intervalo.

Possíveis limites incluem:

- tempo da transação;
- data de negócio;
- intervalo de identificadores da origem;
- versão da origem;
- intervalo ausente conhecido;
- ponto do *snapshot*.

Uma extração sem limites não deve ser a resposta padrão para um problema de recuperação limitado.

### 11.15 Identificação da Lacuna

O *backfill* deve começar com evidências que identifiquem o estado ausente ou necessário.

As evidências da lacuna podem vir de:

- reconciliação;
- linhagem;
- análise de continuidade do CDC;
- análise de continuidade do Kafka;
- metadados de processamento;
- comparação entre origem e destino;
- controles de qualidade;
- requisitos conhecidos de integração histórica.

A plataforma não deve executar *backfill* histórico com base apenas em uma suposição não explicada de que dados possam estar ausentes.

### 11.16 Limites da Lacuna

Quando um intervalo ausente estiver sendo recuperado, a plataforma deve determinar, com a maior precisão possível:

- último estado reconhecidamente válido antes da lacuna;
- primeiro estado ausente;
- último estado ausente;
- primeiro estado reconhecidamente válido após a lacuna;
- entidades afetadas;
- saídas *downstream* afetadas.

Limites precisos reduzem extrações desnecessárias e simplificam a validação.

### 11.17 Completude do Backfill

Um *backfill* deve ser completo para seu objetivo de recuperação definido.

Disponibilidade histórica parcial não deve ser interpretada silenciosamente como recuperação completa.

Se apenas parte do intervalo necessário puder ser recuperada, o resultado deve permanecer explicitamente incompleto até que:

- outra fonte forneça o estado ausente;
- o objetivo da recuperação seja formalmente revisado;
- uma limitação aceita seja documentada e governada.

### 11.18 Consistência do Backfill

A extração da origem pode ocorrer enquanto o AtlasCommerce continua sendo alterado.

A estratégia de *backfill* deve, portanto, considerar se o objetivo de recuperação exige:

- consistência em um ponto no tempo;
- extração transacionalmente consistente;
- consistência de negócio limitada;
- aproximação do estado atual.

A consistência necessária depende do caso de uso.

A arquitetura não deve afirmar recuperação em um ponto no tempo quando o mecanismo de extração não a fornecer.

### 11.19 Backfill e Alterações Concorrentes

Um *backfill* pode se sobrepor a novas alterações ativas que entram por meio de CDC e Kafka.

Sem tratamento controlado, o mesmo estado de negócio pode chegar por ambos:

**Fluxo de Backfill**

e:

**Fluxo de Eventos Ativos**

A arquitetura deve impedir que essa sobreposição crie:

- efeitos de negócio duplicados;
- ordenação incorreta;
- estado mais antigo sobrescrevendo estado mais recente;
- transições ausentes.

### 11.20 Ponto de Corte do Backfill

Quando o *backfill* e o processamento ativo se sobrepõem, um ponto de corte explícito pode ser necessário.

Conceitualmente:

**Backfill Histórico**
→ processar o estado até um limite definido.

**Processamento CDC Ativo**
→ continuar a partir do limite subsequente correspondente.

O ponto de corte deve se basear em uma posição significativa da origem ou do processamento quando tecnicamente possível.

Uma aproximação baseada apenas no relógio pode ser insuficiente para uma recuperação precisa.

### 11.21 Backfill e Idempotência

Dados provenientes de *backfill* podem se sobrepor ao estado já presente *downstream*.

O processamento deve, portanto, tolerar representação lógica duplicada quando houver possibilidade de sobreposição.

Possíveis mecanismos incluem:

- chaves de negócio estáveis;
- identificadores da origem;
- lógica de *merge*;
- comparação de versões;
- substituição determinística;
- reconstrução controlada do destino.

*Backfill* não deve presumir que o destino *downstream* esteja vazio, a menos que essa condição seja explicitamente estabelecida.

### 11.22 Backfill e Ordenação

O processamento histórico pode depender da ordem das alterações.

Se a fonte de *backfill* preservar apenas o estado atual, a ordenação histórica não poderá ser reconstruída automaticamente.

Se alterações históricas estiverem disponíveis, o *backfill* deve preservar a semântica de ordenação exigida pelo processamento *downstream*.

Quando a ordenação não puder ser estabelecida, o objetivo da recuperação deve ser limitado de acordo.

### 11.23 Backfill e Tempo do Evento

Dados históricos provenientes de *backfill* devem preservar timestamps significativos de negócio e da origem quando disponíveis.

A plataforma deve distinguir:

- tempo original de negócio;
- tempo da transação na origem;
- tempo do evento reconstruído;
- tempo de extração do *backfill*;
- tempo de processamento do *backfill*.

O momento em que um *backfill* é executado não deve se tornar silenciosamente o tempo histórico de negócio.

### 11.24 Backfill e Schema

A extração de *backfill* deve definir o *schema* utilizado para representar os dados recuperados.

Quando o *schema* da origem for diferente do contrato histórico de eventos, o mapeamento deve ser explícito.

A plataforma não deve sugerir que um *backfill* extraído diretamente do AtlasCommerce seja estruturalmente idêntico a um evento original do Debezium, a menos que essa equivalência seja deliberadamente implementada e validada.

### 11.25 Backfill e Versão de Contrato

Se dados provenientes de *backfill* forem introduzidos em um fluxo de processamento orientado a eventos, o contrato aplicável deve ser explícito.

Possíveis abordagens incluem:

- mapear dados da origem para um contrato governado atual de *backfill*;
- reconstruir uma representação de evento historicamente aplicável quando existirem informações suficientes;
- processar o *backfill* por meio de um contrato dedicado e governado de ingestão.

A abordagem selecionada deve preservar proveniência e compatibilidade.

### 11.26 Proveniência do Backfill

Todo *backfill* governado deve preservar proveniência suficiente para identificar:

- fonte;
- mecanismo de extração;
- momento da extração;
- limite da origem;
- escopo de negócio;
- intervalo histórico;
- execução do *backfill*;
- contrato de processamento;
- estado *downstream* resultante.

Dados provenientes de *backfill* devem permanecer distinguíveis da ingestão ativa normal quando essa distinção for relevante para auditabilidade e recuperação.

### 11.27 Backfill e Bronze

Quando apropriado, dados provenientes de *backfill* devem entrar em um limite histórico governado que preserve proveniência bruta suficiente antes da transformação *downstream*.

A Bronze é a base histórica analítica natural quando o *backfill* se destina a participar da reconstrução *downstream* normal.

A implementação deve distinguir registros provenientes de *backfill* dos registros originais derivados de CDC quando suas proveniências forem diferentes.

### 11.28 Backfill e Silver

A Silver pode consumir estado da Bronze proveniente de *backfill* de acordo com a definição de transformação aplicável.

Se o *backfill* representar dados de estado atual em vez de eventos históricos, o processamento da Silver deve respeitar essa diferença semântica.

Um *snapshot* não deve ser tratado silenciosamente como uma sequência completa de eventos.

### 11.29 Backfill e Gold

Dados provenientes de *backfill* podem, em última instância, afetar a Gold.

Todo estado resultante da Gold permanece sujeito a:

- correção dimensional;
- qualidade;
- reconciliação;
- linhagem;
- certificação.

Um *backfill* bem-sucedido não autoriza automaticamente a publicação para consumidores.

### 11.30 Backfill e Certified Gold

A Certified Gold deve permanecer protegida enquanto o *backfill* histórico e a reconstrução *downstream* ocorrem.

Quando possível:

**Versão Certificada Atual**
→ permanece visível aos consumidores.

Enquanto isso:

**Backfill**
→ processamento *downstream*  
→ nova candidata Gold  
→ validação  
→ certificação  
→ publicação controlada.

Isso reduz a exposição dos consumidores a uma recuperação histórica incompleta.

### 11.31 Backfill e Dimensões Históricas

Um *backfill* que afete o estado dimensional histórico exige cuidado especial.

Um *snapshot* de estado atual pode ser insuficiente para reconstruir:

- versões anteriores de dimensões;
- intervalos históricos de vigência;
- relacionamentos históricos de chaves substitutas;
- relacionamentos de fatos em um ponto no tempo.

O objetivo da recuperação deve declarar explicitamente se o *backfill* restaura:

**Estado Analítico Atual**

ou:

**Estado Analítico Histórico**

Essas não são garantias equivalentes.

### 11.32 Backfill e Registros Excluídos

O estado atual da origem pode não conter registros que existiram historicamente e foram excluídos posteriormente.

Um *backfill* de estado atual, portanto, não consegue reconstruir automaticamente entidades históricas excluídas.

Uma recuperação histórica que exija estado excluído necessita de uma fonte que preserve esse histórico.

A ausência de um registro na origem atual não deve ser interpretada como prova de que o registro nunca existiu.

### 11.33 Backfill e Impacto na Origem

Uma extração de *backfill* de grande porte pode criar risco operacional para o AtlasCommerce.

Possíveis impactos incluem:

- aumento de I/O;
- consumo de CPU;
- consultas de longa duração;
- bloqueios;
- pressão sobre o log de transações;
- carga de rede.

O planejamento do *backfill* deve minimizar o impacto operacional por meio de:

- projeto adequado das consultas;
- indexação;
- processamento em lotes;
- agendamento;
- controle de taxa;
- redução de escopo.

O objetivo de recuperação analítica não deve desestabilizar desnecessariamente a origem transacional.

### 11.34 Processamento do Backfill em Lotes

*Backfills* de grande porte podem ser divididos em lotes controlados.

Os limites dos lotes podem utilizar:

- intervalos de chaves;
- datas;
- intervalos de transações;
- grupos de entidades.

O processamento em lotes pode melhorar:

- capacidade de reinicialização;
- observabilidade;
- proteção da origem;
- validação;
- controle de recursos.

Cada lote deve preservar metadados de progresso suficientes para permitir continuação segura após uma interrupção.

### 11.35 Capacidade de Reinicialização do Backfill

Um *backfill* pode falhar antes de sua conclusão.

A plataforma deve ser capaz de determinar:

- quais lotes de extração foram concluídos;
- quais lotes *downstream* foram confirmados;
- qual escopo permanece;
- se o trabalho concluído pode ser repetido com segurança;
- de onde o processamento pode ser retomado.

A capacidade de reinicialização do *backfill* deve seguir os mesmos princípios de progresso durável e idempotência utilizados no restante da plataforma.

### 11.36 Falha de Backfill

Possíveis falhas de *backfill* incluem:

- falha de conectividade com a origem;
- falha de consulta;
- inconsistência de extração;
- falha de armazenamento;
- falha de mapeamento;
- incompatibilidade de contrato;
- falha de processamento *downstream*;
- esgotamento de recursos.

Uma falha não deve converter um *backfill* parcialmente concluído em uma recuperação implicitamente completa.

O estado incompleto deve permanecer identificável.

### 11.37 Cancelamento de Backfill

Um *backfill* pode ser cancelado quando:

- o escopo selecionado estiver incorreto;
- o impacto sobre a origem se tornar inseguro;
- a fonte incorreta tiver sido selecionada;
- o mapeamento se mostrar inválido;
- surgir uma sobreposição inesperada com o processamento ativo;
- a validação *downstream* falhar.

O cancelamento deve preservar metadados suficientes para determinar:

- escopo concluído;
- escopo incompleto;
- estado *downstream* produzido;
- requisitos de limpeza ou invalidação.

### 11.38 Backfill e Segurança

*Backfill* pode criar cópias temporárias ou adicionais de dados operacionais.

Essas cópias permanecem sujeitas aos requisitos aplicáveis de:

- classificação;
- controle de acesso;
- privacidade;
- criptografia;
- retenção;
- auditabilidade.

A urgência da recuperação não justifica a exportação descontrolada de dados do AtlasCommerce.

Artefatos temporários de *backfill* devem ser governados e removidos de acordo com seu ciclo de vida pretendido.

### 11.39 Backfill e Retenção

Dados históricos provenientes de *backfill* devem entrar em um modelo de retenção apropriado.

Uma extração temporária de recuperação não deve se tornar automaticamente um arquivo permanente não gerenciado.

Por outro lado, dados necessários para uma futura reconstrução governada não devem ser excluídos apenas porque o *backfill* imediato foi concluído.

A retenção deve refletir o papel arquitetural do estado resultante.

### 11.40 Backfill e Linhagem

A linhagem deve distinguir o estado proveniente de *backfill* do histórico normalmente capturado quando relevante.

Um revisor deve ser capaz de determinar:

- por que o *backfill* ocorreu;
- qual fonte o forneceu;
- qual intervalo histórico foi afetado;
- quais camadas *downstream* foram regeneradas;
- quais versões de processamento foram utilizadas;
- quais produtos analíticos foram alterados.

Essa distinção é importante porque o estado histórico reconstruído pode possuir proveniência diferente do histórico originalmente capturado por CDC.

### 11.41 Backfill e Reconciliação

*Backfill* exige reconciliação rigorosa porque seu propósito frequentemente é restaurar um estado reconhecidamente ausente.

A reconciliação pode comparar:

- contagens de registros da origem e extraídos;
- chaves de negócio da origem e da Bronze;
- intervalos históricos afetados;
- populações ausentes antes e depois;
- totais de negócio;
- populações da Silver;
- medidas da Gold.

A validação deve demonstrar que a lacuna identificada foi efetivamente corrigida.

### 11.42 Diferenças Esperadas do Backfill

Um *backfill* pode alterar intencionalmente resultados *downstream*.

O plano deve identificar:

- quais registros devem aparecer;
- quais valores devem mudar;
- qual intervalo histórico é afetado;
- quais produtos *downstream* devem mudar;
- qual estado deve permanecer inalterado.

Alterações inesperadas fora do escopo pretendido exigem investigação.

### 11.43 Validação do Backfill

A validação do *backfill* deve confirmar, quando aplicável:

- fonte governada correta;
- escopo correto de extração;
- intervalo necessário completo;
- consistência apropriada da origem;
- ponto de corte correto com o processamento ativo;
- ausência de efeitos de negócio duplicados não pretendidos;
- ordenação correta quando necessária;
- timestamps de negócio preservados;
- contrato ou mapeamento correto;
- proveniência;
- persistência na Bronze;
- transformação *downstream*;
- qualidade;
- reconciliação;
- linhagem;
- certificação da Gold, quando aplicável.

Uma extração concluída, por si só, não comprova um *backfill* bem-sucedido.

### 11.44 Evidências de Backfill

Evidências representativas de *backfill* devem preservar:

- motivo do *backfill*;
- lacuna identificada;
- fonte;
- limite da origem;
- método de extração;
- escopo histórico;
- ponto de corte;
- identificador da execução;
- progresso dos lotes;
- contagens de registros;
- versão do mapeamento ou contrato;
- versão do processamento *downstream*;
- resultados da reconciliação;
- resultados de qualidade;
- tempo decorrido;
- estado governado final.

As evidências devem demonstrar tanto a necessidade do *backfill* quanto a correção da recuperação resultante.

### 11.45 Cenários de Teste de Backfill

A Versão 1 deve validar cenários representativos, como:

**Teste de Backfill 1 — Escopo Ausente Limitado**
→ identificar uma população *downstream* ausente de forma controlada  
→ extrair o escopo necessário do AtlasCommerce  
→ processá-lo por meio do fluxo governado  
→ demonstrar a restauração por meio de reconciliação.

**Teste de Backfill 2 — Sobreposição com Processamento Ativo**
→ realizar um *backfill* controlado enquanto novas alterações da origem continuam ocorrendo  
→ demonstrar que a sobreposição não cria efeitos de negócio duplicados nem estado final incorreto.

**Teste de Backfill 3 — Backfill Interrompido**
→ interromper um *backfill* de múltiplos lotes  
→ retomar a partir do progresso durável  
→ demonstrar o estado final correto sem duplicação descontrolada.

**Teste de Backfill 4 — Limitação do Estado Atual**
→ utilizar um exemplo controlado para demonstrar que um *snapshot* do estado atual não consegue reproduzir transições históricas que não estão mais presentes na origem.

Os cenários exatos devem refletir a implementação final da Versão 1 e evitar impacto desnecessário sobre o AtlasCommerce.

### 11.46 Garantias de Backfill

O modelo de *backfill* da Atlas Engineering deve preservar as seguintes garantias:

1. *backfill* é a introdução ou reconstrução controlada de dados históricos quando o *replay* normal dos dados retidos não consegue atender completamente ao objetivo;
2. *backfill* permanece distinto de reinicialização, nova tentativa, *replay*, reprocessamento e *rebuild*;
3. todo *backfill* possui motivo explícito, fonte governada e escopo limitado;
4. o AtlasCommerce pode oferecer suporte a *backfill* sem se tornar uma plataforma rotineira de consultas analíticas;
5. *backfill* de estado atual não é representado como reconstrução de eventos históricos;
6. *backfill* histórico exige uma fonte que realmente preserve o histórico necessário;
7. estado de *snapshot* permanece distinto do histórico de eventos;
8. eventos reconstruídos permanecem distinguíveis dos eventos originalmente capturados;
9. lacunas conhecidas são identificadas antes da seleção do escopo de recuperação;
10. disponibilidade histórica parcial não é representada como recuperação completa;
11. as garantias de consistência da origem são declaradas de acordo com o mecanismo de extração implementado;
12. a sobreposição entre *backfill* e processamento ativo é explicitamente controlada;
13. o ponto de corte do *backfill* é baseado em um limite significativo de processamento ou da origem quando possível;
14. a sobreposição não cria efeitos de negócio duplicados não pretendidos;
15. a ordenação histórica necessária e o tempo de negócio são preservados quando disponíveis;
16. os mapeamentos entre o *schema* da origem e o processamento, bem como os contratos, são explícitos;
17. a proveniência do *backfill* permanece rastreável;
18. dados provenientes de *backfill* entram em um limite histórico governado de processamento quando apropriado;
19. a semântica de *snapshot* não é tratada silenciosamente como semântica completa de eventos;
20. a Gold afetada por *backfill* permanece sujeita à certificação;
21. a Certified Gold atual pode permanecer disponível enquanto o estado candidato corrigido é produzido;
22. *backfill* de estado atual não afirma reconstruir estado histórico ou excluído que esteja indisponível;
23. a extração de *backfill* minimiza impacto desnecessário sobre o AtlasCommerce;
24. *backfills* de grande porte podem utilizar lotes controlados e reinicializáveis;
25. *backfills* interrompidos ou cancelados permanecem identificáveis e recuperáveis;
26. *backfill* não enfraquece os controles de segurança, privacidade ou retenção;
27. a linhagem distingue estado histórico reconstruído do histórico normalmente capturado quando relevante;
28. a reconciliação demonstra que o estado ausente pretendido foi restaurado;
29. alterações inesperadas fora do escopo do *backfill* exigem investigação;
30. a capacidade de *backfill* é considerada demonstrada somente após validação e evidências controladas.

---

## 12. Rebuild

*Rebuild* é a reconstrução controlada de um estado derivado da plataforma a partir de um limite de recuperação *upstream* apropriado e confiável.

A Atlas Engineering utiliza *rebuild* quando um estado derivado é perdido, corrompido, invalidado ou intencionalmente substituído e pode ser reconstruído a partir de dados *upstream* governados e das definições de processamento aplicáveis.

O modelo orientador é:

**Selecionar Limite Upstream Confiável → Definir Escopo do Rebuild → Reconstruir Estado Derivado → Validar → Certificar Quando Aplicável → Substituir ou Publicar por Meio de Transição Controlada**

*Rebuild* diz respeito à reconstrução de estado.

Ele pode utilizar:

- *replay*;
- reprocessamento;
- *backfill*;
- restauração de *backup*;

como parte da sequência de recuperação.

Esses mecanismos permanecem conceitualmente distintos.

### 12.1 Propósito do Rebuild

*Rebuild* pode ser necessário quando:

- o armazenamento derivado é perdido;
- o estado derivado é corrompido;
- um defeito de processamento invalida uma saída produzida anteriormente;
- uma lógica histórica precisa ser corrigida;
- uma nova definição de processamento exige reconstrução completa;
- um modelo dimensional muda de forma significativa;
- a reconciliação demonstra que o estado derivado existente não pode ser considerado confiável;
- uma migração exige a geração de uma nova versão governada;
- testes de recuperação validam intencionalmente a capacidade de reconstrução.

Um *rebuild* deve possuir motivo explícito e objetivo de recuperação definido.

### 12.2 Rebuild versus Reinicialização

A reinicialização restaura a execução de um componente a partir do estado de processamento confirmado.

*Rebuild* reconstrói o estado dos dados.

Por exemplo:

**Processador Silver Parou**
→ a reinicialização pode ser suficiente.

**Armazenamento Silver Perdido**
→ apenas a reinicialização não consegue recriar o estado persistido ausente da Silver  
→ *rebuild* é necessário.

A recuperação do componente e a reconstrução do estado dos dados são, portanto, responsabilidades distintas.

### 12.3 Rebuild versus Nova Tentativa

Uma nova tentativa repete uma operação que falhou.

*Rebuild* reconstrói um estado derivado a partir de um limite de recuperação selecionado.

Uma operação de *rebuild* que falhou pode, por sua vez, ser tentada novamente, mas uma nova tentativa não define o objetivo do *rebuild*.

### 12.4 Rebuild versus Replay

*Replay* reconsome eventos históricos retidos.

*Rebuild* reconstrói um estado derivado.

Por exemplo:

**Kafka → Replay de Eventos Históricos → Rebuild da Bronze**

Nesse caso:

- *replay* é o mecanismo de entrega da entrada;
- a reconstrução da Bronze é o objetivo do *rebuild*.

Um *rebuild* da Gold a partir de uma Silver válida pode não exigir nenhum *replay* do Kafka.

### 12.5 Rebuild versus Reprocessamento

Reprocessamento executa novamente entradas históricas por meio da lógica de processamento.

*Rebuild* reconstrói o estado de destino produzido por esse processamento.

Por exemplo:

**Bronze**
→ reprocessar entradas históricas por meio da lógica da Silver  
→ reconstruir a Silver.

A execução repetida é reprocessamento.

A reconstrução completa da Silver é o *rebuild*.

### 12.6 Rebuild versus Backfill

*Backfill* introduz entradas históricas necessárias que não estão disponíveis por meio do *replay* normal dos dados retidos.

*Rebuild* consome um estado *upstream* apropriado para reconstruir um destino derivado.

Um *rebuild* pode exigir *backfill* quando a fonte necessária para a reconstrução estiver incompleta.

Por exemplo:

**Entrada Histórica Ausente**
→ *backfill*  
→ reconstruir Bronze ou Silver  
→ realizar *rebuild* da Gold.

### 12.7 Fonte do Rebuild

Um *rebuild* deve utilizar um estado *upstream* que permaneça confiável para o destino que está sendo reconstruído.

Relacionamentos representativos entre fontes incluem:

**Kafka**
→ *rebuild* da Bronze.

**Bronze**
→ *rebuild* da Silver.

**Silver**
→ *rebuild* da Gold.

**Candidata Gold / Versão Certificada Anterior**
→ recuperação limitada de publicação ou *rollback*, quando apropriado.

**Backup / Arquivo**
→ restauração de uma base *upstream* necessária antes da reconstrução.

A fonte de recuperação deve estar *upstream* do estado que está sendo reconstruído.

### 12.8 Escopo do Rebuild

Um *rebuild* pode abranger:

- uma partição;
- uma entidade;
- um intervalo de datas;
- um conjunto de dados;
- uma tabela;
- uma área temática dimensional;
- um produto de dados;
- uma camada completa.

O menor escopo seguro deve normalmente ser preferido.

O escopo ainda deve incluir todas as dependências necessárias para um resultado correto.

### 12.9 Rebuild Completo

Um *rebuild* completo reconstrói todo o estado governado de destino a partir de um limite *upstream* confiável.

Exemplos incluem:

- reconstrução completa da Silver a partir do histórico retido da Bronze;
- reconstrução completa da Gold a partir de uma Silver válida;
- regeneração completa de um produto analítico.

Um *rebuild* completo pode ser apropriado quando:

- o estado de destino estiver amplamente inválido;
- o escopo exato afetado não puder ser estabelecido com confiança;
- o armazenamento de destino tiver sido perdido;
- a semântica de processamento tiver mudado globalmente;
- uma recuperação parcial aparentemente mais simples apresentar maior risco do que a reconstrução completa.

Um *rebuild* completo geralmente aumenta o tempo de recuperação e o consumo de recursos.

### 12.10 Rebuild Parcial

Um *rebuild* parcial reconstrói um subconjunto limitado do estado de destino.

Possíveis escopos incluem:

- intervalo de datas;
- entidade de negócio;
- partição;
- dimensão;
- intervalo de fatos;
- produto de dados.

Um *rebuild* parcial pode reduzir o tempo de recuperação e o impacto sobre a plataforma.

Ele é apropriado apenas quando a plataforma consegue determinar precisamente o escopo afetado e preservar corretamente as dependências fora desse escopo.

### 12.11 Análise de Dependências do Rebuild

Antes de reconstruir um escopo limitado, a plataforma deve identificar dependências que possam exigir uma reconstrução mais ampla.

As dependências podem incluir:

- intervalos históricos *upstream*;
- estado de referência;
- histórico dimensional;
- dimensões conformadas;
- agregações;
- medidas derivadas;
- produtos *downstream*;
- metadados de certificação.

Um sintoma local nem sempre implica um *rebuild* local.

### 12.12 Rebuild da Bronze

O *rebuild* da Bronze pode ser necessário quando o estado da Bronze estiver:

- perdido;
- incompleto;
- invalidado por defeitos de persistência;
- intencionalmente reconstruído para validação.

Quando o histórico necessário do Kafka permanecer retido e confiável:

**Kafka**
→ *replay* controlado  
→ persistência na Bronze  
→ validação de continuidade.

Se o histórico necessário do Kafka não existir mais, o *rebuild* da Bronze pode exigir:

- *backfill* controlado;
- outra fonte histórica;
- *backup* ou arquivo.

A Bronze deve preservar a proveniência que distingue eventos originalmente capturados de entradas históricas reconstruídas, quando aplicável.

### 12.13 Rebuild da Silver

O *rebuild* da Silver reconstrói o estado analítico padronizado a partir de um limite *upstream* confiável, normalmente a Bronze.

Um fluxo representativo é:

**Bronze Válida**
→ versão selecionada do processamento da Silver  
→ reconstrução completa ou parcial da Silver  
→ validação de qualidade  
→ validação de linhagem.

O *rebuild* da Silver pode ser apropriado quando:

- o armazenamento da Silver for perdido;
- a lógica de processamento da Silver estiver defeituosa;
- a semântica da Silver mudar;
- a consistência *downstream* não puder ser restaurada com segurança por meio de correção incremental.

### 12.14 Rebuild da Gold

O *rebuild* da Gold reconstrói o estado analítico dimensional a partir de entradas confiáveis da Silver.

Um fluxo representativo é:

**Silver Válida**
→ definição selecionada do processamento da Gold  
→ candidata Gold  
→ qualidade  
→ reconciliação  
→ certificação  
→ publicação controlada.

O *rebuild* da Gold deve normalmente produzir uma nova candidata em vez de sobrescrever diretamente o estado atual da Certified Gold.

### 12.15 Rebuild da Certified Gold

A Certified Gold não é reconstruída simplesmente gravando diretamente nas estruturas visíveis aos consumidores.

A recuperação correta segue:

**Estado Upstream Confiável**
→ realizar *rebuild* da candidata Gold  
→ validar  
→ reconciliar  
→ certificar  
→ publicar atomicamente.

A Certified Gold é um estado governado de publicação.

Sua reconstrução deve preservar o limite de certificação.

### 12.16 Rebuild a Partir de Backup

Um *rebuild* pode começar após a restauração de um *backup* quando a base de recuperação disponível *online* necessária tiver sido perdida.

Por exemplo:

**Armazenamento Bronze Perdido**
→ restaurar *backup* da Bronze  
→ validar histórico restaurado  
→ realizar *rebuild* da Silver  
→ realizar *rebuild* da Gold conforme necessário.

Ou:

**AtlasWarehouse Perdido**
→ restaurar infraestrutura ou estado do banco de dados  
→ reconstruir o estado analítico derivado a partir de uma Silver válida, quando apropriado.

Restauração de *backup* e *rebuild* são ações de recuperação distintas.

### 12.17 Rebuild e Versões Históricas

*Rebuild* exige a seleção explícita das definições utilizadas para interpretar entradas históricas.

Versões relevantes podem incluir:

- *schema*;
- contrato de eventos;
- processamento da Silver;
- processamento da Gold;
- dados de referência;
- regras de qualidade;
- regras de reconciliação.

Um *rebuild* não deve utilizar silenciosamente definições atuais incompatíveis simplesmente porque representam a implementação mais fácil disponível.

### 12.18 Reprodução Histórica Durante o Rebuild

Um *rebuild* pode buscar reproduzir o estado que deveria ter existido sob uma definição histórica.

O objetivo é:

**Estado Histórico Upstream**
+
**Lógica Histórica Aplicável**
→ **Estado Derivado Histórico Esperado**

Isso pode ser necessário para:

- auditoria;
- reprodutibilidade;
- comparação histórica;
- investigação.

### 12.19 Restatement Histórico Durante o Rebuild

Um *rebuild* pode reconstruir intencionalmente o estado histórico utilizando lógica corrigida ou atual.

Por exemplo:

**Silver Histórica**
→ Gold V3 corrigida  
→ *restatement* histórico completo da Gold.

O estado resultante é uma nova versão analítica governada.

Sua linhagem deve explicar que ele foi reconstruído utilizando uma definição de processamento diferente daquela utilizada no estado original.

### 12.20 Estratégia de Destino do Rebuild

Antes do início do *rebuild*, a arquitetura deve definir como o estado de destino será produzido.

Possíveis estratégias incluem:

**Reconstrução In-Place**
→ o destino existente é reconstruído dentro de seu armazenamento governado.

**Destino Shadow**
→ um destino separado é criado e validado antes da substituição.

**Destino Versionado**
→ uma nova versão do destino é criada.

Para recuperação da Gold sensível aos consumidores, abordagens *shadow* ou versionadas geralmente oferecem maior proteção ao último estado reconhecidamente válido.

### 12.21 Rebuild In-Place

Um *rebuild in-place* pode ser apropriado quando:

- o destino não estiver visível aos consumidores durante a reconstrução;
- o isolamento de falhas for suficiente;
- o estado parcial não puder vazar;
- a capacidade de reinicialização estiver definida;
- o escopo da recuperação estiver controlado.

A plataforma deve impedir que consumidores interpretem um estado parcialmente reconstruído como completo.

### 12.22 Shadow Rebuild

Um *shadow rebuild* reconstrói o estado separadamente do destino atualmente governado.

Conceitualmente:

**Estado Atual**
→ permanece inalterado.

Enquanto isso:

**Estado Upstream Confiável**
→ realizar *rebuild* do destino *shadow*  
→ validar  
→ reconciliar  
→ promover.

Esse padrão reduz a exposição ao estado de *rebuild* parcial.

### 12.23 Rebuild Versionado

Um *rebuild* versionado cria uma versão separada do destino.

Isso é particularmente útil para Gold e Certified Gold.

Exemplo:

**Certified Gold V5**
→ permanece disponível.

Enquanto isso:

**Silver Válida**
→ Candidata Gold V6  
→ validação  
→ certificação  
→ publicação atômica.

O *rebuild* versionado oferece suporte a:

- comparação;
- *rollback*;
- evidências;
- promoção controlada.

### 12.24 Rebuild e Processamento Ativo

O processamento ativo pode continuar enquanto um *rebuild* estiver em andamento.

A arquitetura deve definir como novas entradas interagem com a reconstrução.

Possíveis abordagens incluem:

- pausar o processamento ativo afetado;
- realizar *rebuild* até um ponto de corte definido e depois executar *catch-up*;
- isolar o *rebuild* em uma nova versão;
- continuar a ingestão ativa *upstream* enquanto ocorre a reconstrução *downstream*.

A estratégia escolhida deve impedir divergência descontrolada entre o estado histórico reconstruído e o processamento atual.

### 12.25 Ponto de Corte do Rebuild

Quando um *rebuild* precisar convergir com o processamento ativo, um ponto de corte explícito pode ser necessário.

Conceitualmente:

**Reconstrução Histórica**
→ realizar *rebuild* até o limite X.

Depois:

**Processamento Incremental**
→ continuar a partir de X+1 ou de um limite subsequente equivalente.

O ponto de corte deve utilizar um limite significativo de processamento ou da origem, em vez de um valor aproximado de relógio, sempre que possível.

### 12.26 Catch-Up do Rebuild

Depois que a reconstrução histórica atingir seu ponto de corte definido, novas entradas acumuladas ainda podem precisar ser processadas.

A sequência pode ser:

**Rebuild Histórico**
→ **Processamento de Catch-Up**
→ **Qualidade e Reconciliação**
→ **Certificação**
→ **Publicação**

O destino não deve ser considerado atual apenas porque a reconstrução histórica foi concluída.

### 12.27 Rebuild e Idempotência

Um *rebuild* pode repetir processamento já representado em parte do destino.

O processamento idempotente continua importante quando:

- um *rebuild* parcial é reiniciado;
- o escopo histórico se sobrepõe ao estado existente;
- o processamento de *catch-up* se sobrepõe ao estado reconstruído;
- a execução do *rebuild* é repetida.

Quando um *merge* idempotente não for apropriado, a substituição do destino ou o isolamento por versão deve fornecer proteção equivalente.

### 12.28 Progresso do Rebuild

*Rebuilds* de grande porte devem expor progresso durável.

O progresso pode incluir:

- partições reconstruídas;
- lotes concluídos;
- intervalos históricos processados;
- intervalos de entidades;
- versão atual do processamento;
- versão do destino;
- trabalho restante.

Um *rebuild* não deve depender exclusivamente de um único processo de longa duração permanecer ativo até sua conclusão.

### 12.29 Capacidade de Reinicialização do Rebuild

Um *rebuild* pode falhar antes de sua conclusão.

A plataforma deve ser capaz de determinar:

- qual escopo foi concluído;
- qual estado do destino é durável;
- qual trabalho permanece;
- se o trabalho concluído pode ser repetido com segurança;
- se o destino parcial deve ser mantido, retomado ou descartado.

A capacidade de reinicialização deve ser projetada antes que a capacidade de realizar grandes *rebuilds* seja declarada.

### 12.30 Falha de Rebuild

Possíveis falhas de *rebuild* incluem:

- indisponibilidade do histórico da fonte;
- versão histórica incompatível;
- falha de transformação;
- falha de armazenamento;
- esgotamento de recursos;
- falha de qualidade;
- falha de reconciliação;
- falha de dependência.

Um *rebuild* que falhou não deve se tornar o destino governado apenas porque uma grande parte foi concluída com sucesso.

### 12.31 Estado Parcial do Rebuild

O estado parcial de um *rebuild* deve permanecer distinguível do estado governado completo.

Possíveis formas de tratamento incluem:

- caminho temporário;
- estado do ciclo de vida da candidata;
- status explícito de incompleto;
- *schema* ou tabela isolada;
- prefixo de objeto separado;
- metadados de versão.

Uma saída incompleta de *rebuild* não deve atravessar o limite normal de publicação.

### 12.32 Cancelamento de Rebuild

Um *rebuild* pode ser cancelado quando:

- a seleção da fonte se mostrar incorreta;
- o escopo for insuficiente;
- a versão de processamento estiver incorreta;
- o impacto sobre os recursos se tornar inseguro;
- surgir uma saída inesperada;
- a validação falhar.

O cancelamento deve preservar metadados suficientes para determinar:

- trabalho concluído;
- estado parcial do destino;
- limpeza necessária;
- se o processamento ativo foi afetado;
- se outra estratégia de *rebuild* é necessária.

### 12.33 Impacto do Rebuild sobre Recursos

Um *rebuild* pode ser uma das operações de recuperação com maior consumo de recursos.

O impacto sobre recursos pode incluir:

- leituras da origem;
- vazão do armazenamento de objetos;
- CPU;
- memória;
- gravações no banco de dados;
- crescimento do log de transações;
- armazenamento temporário;
- capacidade de orquestração;
- uso de rede.

O projeto de recuperação deve considerar o impacto sobre as cargas de trabalho normais.

Um *rebuild* rápido não é útil se desestabilizar o restante da plataforma.

### 12.34 Controle de Taxa do Rebuild

Uma reconstrução de grande porte pode exigir vazão controlada.

O controle de taxa pode proteger:

- sistemas de origem;
- armazenamento de objetos;
- SQL Server;
- recursos computacionais compartilhados;
- capacidade de rede;
- processamento ativo.

A taxa apropriada deve ser determinada por meio de comportamento medido, e não por um valor máximo arbitrário.

### 12.35 Priorização do Rebuild

Quando múltiplos estados derivados exigirem reconstrução, a prioridade deve considerar:

- impacto sobre consumidores;
- risco de correção;
- atualidade;
- dependência de recuperação;
- risco de perda de dados;
- estado publicado reconhecidamente válido;
- requisitos de recursos;
- importância para o negócio.

Um *rebuild* de uma camada inferior que desbloqueie vários estados *downstream* pode ter prioridade sobre uma otimização *downstream* isolada.

### 12.36 Rebuild e Validação de Qualidade

O estado reconstruído permanece sujeito aos controles de qualidade aplicáveis.

A validação pode incluir:

- completude;
- unicidade;
- consistência referencial;
- valores aceitos;
- correção temporal;
- regras de domínio;
- populações esperadas.

O sucesso de um *rebuild* não é definido apenas pela conclusão da tarefa de transformação.

### 12.37 Rebuild e Reconciliação

A reconciliação deve demonstrar que o estado reconstruído é consistente com a fonte *upstream* apropriada e com o objetivo da recuperação.

Comparações relevantes podem incluir:

- contagens entre origem e destino;
- contagens entre Bronze e Silver;
- contagens entre Silver e Gold;
- totais de negócio;
- intervalos históricos;
- dimensões esperadas;
- populações esperadas de fatos.

Quando a lógica tiver sido alterada intencionalmente, a reconciliação deve distinguir diferenças esperadas de *restatement* de discrepâncias não explicadas.

### 12.38 Rebuild e Certificação

A Gold reconstruída a partir de estado histórico ou recuperado deve permanecer sujeita à certificação.

O fluxo necessário permanece:

**Candidata Gold Reconstruída**
→ processamento concluído  
→ qualidade aprovada  
→ reconciliação aprovada  
→ linhagem válida  
→ certificação  
→ publicação.

A recuperação não reduz o padrão de certificação.

### 12.39 Rebuild e Rollback

Estratégias de *rebuild* versionado ou *shadow* devem preservar *rollback* quando apropriado.

Se a versão recém-reconstruída falhar após a promoção ou surgir comportamento inesperado dos consumidores:

**Versão Certificada Anterior Reconhecidamente Válida**
→ deve permanecer identificável e recuperável de acordo com a estratégia de publicação configurada.

*Rollback* protege a disponibilidade analítica.

Ele não elimina a necessidade de investigar o estado reconstruído que falhou.

### 12.40 Rebuild e Linhagem

O estado reconstruído deve preservar linhagem suficiente para identificar:

- fonte de recuperação;
- intervalo da fonte;
- definição de processamento;
- execução do *rebuild*;
- versão do destino;
- lógica histórica ou atual;
- resultados de qualidade;
- resultados de reconciliação;
- estado de certificação.

Um conjunto de dados reconstruído deve permanecer distinguível do estado que ele substitui.

### 12.41 Rebuild e Metadados

Os metadados devem identificar, quando aplicável:

- motivo do *rebuild*;
- destino;
- fonte;
- escopo;
- horário de início;
- horário de conclusão;
- versão de processamento;
- versão do destino;
- estado do ciclo de vida;
- estado de validação;
- estado de publicação.

Isso transforma o *rebuild* em uma operação auditável da plataforma, em vez de um evento administrativo opaco.

### 12.42 Rebuild e Segurança

Um *rebuild* pode exigir privilégios elevados de armazenamento ou processamento.

Esse acesso deve permanecer:

- explícito;
- limitado;
- atribuível;
- temporário quando prático;
- removido após a recuperação.

Dados temporários de *rebuild* permanecem sujeitos aos requisitos de classificação e privacidade.

*Rebuild* não justifica ignorar controles de acesso nem publicar dados sensíveis não validados.

### 12.43 Rebuild e Retenção

A capacidade de *rebuild* depende da retenção de:

- dados *upstream* necessários;
- versões históricas;
- metadados;
- linhagem;
- definições de processamento.

Se o histórico necessário for intencionalmente descartado, a capacidade correspondente de reconstrução pode deixar de existir.

A plataforma não deve declarar capacidade completa de *rebuild* histórico além do histórico retido e interpretável.

### 12.44 Rebuild e RPO

Um *rebuild* pode restaurar o estado derivado sem alterar o ponto de recuperação da fonte durável *upstream*.

Por exemplo:

**Gold Perdida**
→ Silver válida permanece completa até o limite X  
→ Gold pode ser reconstruída até X.

O ponto de recuperação alcançável para a Gold depende, portanto, da atualidade e da completude do limite *upstream* selecionado.

O RPO deve ser avaliado de acordo com o estado efetivamente preservado.

### 12.45 Rebuild e RTO

O tempo de *rebuild* contribui diretamente para o tempo de recuperação.

Fatores relevantes incluem:

- volume histórico;
- vazão de processamento;
- tamanho do destino;
- disponibilidade de recursos;
- duração da validação;
- duração da reconciliação;
- certificação;
- *backlog* de *catch-up*.

A duração medida do *rebuild* fornece evidências para o planejamento de recuperação.

Ela não deve ser generalizada além da carga de trabalho testada.

### 12.46 Validação do Rebuild

A validação do *rebuild* deve confirmar, quando aplicável:

- fonte de recuperação correta;
- escopo correto;
- histórico necessário completo;
- versão de processamento apropriada;
- ponto de corte correto;
- capacidade de reinicialização;
- ausência de estado de destino ausente;
- ausência de efeitos de negócio duplicados não pretendidos;
- resultado histórico ou *restatement* esperado;
- qualidade;
- reconciliação;
- linhagem;
- metadados;
- certificação;
- publicação;
- atualidade final.

Um destino que simplesmente exista após a reconstrução não constitui evidência suficiente de um *rebuild* bem-sucedido.

### 12.47 Evidências de Rebuild

Evidências representativas de *rebuild* devem preservar:

- motivo do *rebuild*;
- destino afetado;
- fonte de recuperação selecionada;
- intervalo da fonte;
- escopo do *rebuild*;
- estratégia de destino;
- versão de processamento;
- versão do destino;
- estado inicial;
- progresso;
- interrupções, quando testadas;
- contagens de registros;
- resultados de qualidade;
- resultados de reconciliação;
- resultado da certificação;
- resultado da publicação;
- tempo decorrido da reconstrução;
- tempo de *catch-up*;
- tempo total de recuperação;
- estado final.

Essas evidências oferecem suporte tanto à validação da recuperação quanto a futuras análises de RTO e capacidade.

### 12.48 Cenários de Teste de Rebuild

A Versão 1 deve validar cenários representativos de *rebuild*, como:

**Teste de Rebuild 1 — Silver a Partir da Bronze**
→ preservar histórico válido da Bronze  
→ remover ou isolar um destino Silver controlado  
→ realizar *rebuild* da Silver  
→ validar equivalência e linhagem.

**Teste de Rebuild 2 — Gold a Partir da Silver**
→ preservar Silver válida  
→ realizar *rebuild* de uma candidata Gold a partir de um destino limpo  
→ validar qualidade e reconciliação  
→ certificar antes da publicação.

**Teste de Rebuild 3 — Rebuild Interrompido**
→ interromper uma reconstrução de múltiplos lotes  
→ reiniciar a partir do progresso durável  
→ demonstrar o estado final correto.

**Teste de Rebuild 4 — Processamento Corrigido**
→ preservar entrada histórica  
→ alterar uma regra de transformação de forma controlada  
→ realizar *rebuild* de um destino versionado  
→ demonstrar diferenças esperadas e publicação controlada.

**Teste de Rebuild 5 — Catch-Up**
→ permitir o acúmulo de novas entradas durante a reconstrução  
→ realizar *rebuild* até um ponto de corte definido  
→ executar *catch-up* do processamento restante  
→ demonstrar a restauração do estado governado atual.

Os cenários exatos devem refletir a implementação final da Versão 1.

### 12.49 Garantias de Rebuild

O modelo de *rebuild* da Atlas Engineering deve preservar as seguintes garantias:

1. *rebuild* é a reconstrução controlada de estado derivado a partir de um limite *upstream* confiável;
2. *rebuild* permanece distinto de reinicialização, nova tentativa, *replay*, reprocessamento e *backfill*;
3. *rebuild* pode utilizar *replay*, reprocessamento, *backfill* ou restauração de *backup* como mecanismos de apoio sem eliminar a distinção entre seus significados;
4. a fonte do *rebuild* permanece *upstream* do estado que está sendo reconstruído;
5. o escopo do *rebuild* é explícito e inclui as dependências necessárias;
6. *rebuild* completo e parcial permanecem distinguíveis;
7. a Bronze pode ser reconstruída a partir do histórico retido do Kafka somente enquanto o intervalo necessário permanecer completo e confiável;
8. a Silver é normalmente reconstruída a partir do histórico governado da Bronze;
9. a Gold é normalmente reconstruída a partir de estado confiável da Silver;
10. a reconstrução da Certified Gold preserva os limites de certificação e publicação controlada;
11. a restauração de *backup* permanece distinta do *rebuild downstream*;
12. a seleção da versão de processamento é explícita;
13. a reprodução histórica permanece distinta do *restatement* histórico;
14. a reconstrução do destino utiliza uma estratégia explícita *in-place*, *shadow* ou versionada;
15. o estado reconhecidamente válido e visível aos consumidores é protegido durante o *rebuild* quando apropriado;
16. a interação entre *rebuild* e processamento ativo é controlada;
17. o ponto de corte do *rebuild* e o comportamento de *catch-up* são explícitos quando o processamento atual continua;
18. execuções repetidas ou interrompidas de *rebuild* não criam efeitos de negócio duplicados não pretendidos;
19. *rebuilds* de grande porte expõem progresso durável e capacidade de reinicialização;
20. saídas de *rebuild* que falharam ou estão parciais não se tornam silenciosamente um estado governado completo;
21. *rebuilds* cancelados permanecem rastreáveis e recuperáveis;
22. o impacto do *rebuild* sobre recursos é controlado;
23. qualidade e reconciliação se aplicam ao estado reconstruído;
24. o *rebuild* da Gold permanece sujeito à certificação;
25. *rollback* permanece disponível quando exigido pela estratégia de publicação;
26. o estado reconstruído preserva linhagem e metadados;
27. privilégios e dados temporários de *rebuild* permanecem governados;
28. as afirmações sobre capacidade de *rebuild* permanecem limitadas ao histórico retido e interpretável;
29. o desempenho do *rebuild* contribui para o planejamento de recuperação medido, em vez de sustentar afirmações de RTO não comprovadas;
30. a capacidade de *rebuild* é considerada demonstrada somente após validação e evidências controladas.

---

## 13. Falha e Recuperação de Componentes

A Atlas Engineering contém múltiplos componentes independentes cujas falhas afetam diferentes partes do fluxo de dados.

A recuperação de componentes deve, portanto, ser avaliada de acordo com:

- responsabilidade arquitetural;
- estado durável;
- progresso do processamento;
- impacto *downstream*;
- fonte de recuperação disponível;
- mecanismo de recuperação necessário;
- requisitos de validação.

O modelo orientador é:

**Falha do Componente → Identificar Estado Preservado → Restaurar Capacidade do Componente → Retomar ou Reconstruir Processamento → Validar Estado Downstream**

O retorno de um componente ao estado operacional não demonstra, por si só, que sua responsabilidade de processamento de dados foi recuperada corretamente.

### 13.1 Falha do AtlasCommerce

O AtlasCommerce é a fonte operacional autoritativa.

Os cenários de falha podem incluir:

- instância do SQL Server indisponível;
- banco de dados indisponível;
- falha de armazenamento;
- problema no log de transações;
- falha de permissão;
- falha mais ampla do host.

Durante a indisponibilidade da origem:

- novas transações de negócio podem ficar indisponíveis para a aplicação;
- nenhuma nova alteração confirmada pode entrar no CDC;
- o processamento histórico *downstream* pode continuar utilizando dados já capturados;
- a Certified Gold pode permanecer disponível, mas se tornar progressivamente desatualizada.

A recuperação deve determinar:

- integridade do banco de dados de origem;
- disponibilidade das transações;
- estado do CDC;
- se as alterações necessárias da origem permanecem recuperáveis;
- se algum ponto de recuperação na origem criou uma lacuna de alterações.

Restaurar apenas o serviço do SQL Server não comprova a continuidade da captura analítica.

### 13.2 Recuperação do AtlasCommerce

A recuperação do AtlasCommerce pode envolver:

- reinicialização do serviço do SQL Server;
- recuperação do banco de dados;
- recuperação do armazenamento;
- restauração de *backup*;
- recuperação do log de transações;
- recuperação mais ampla da infraestrutura.

Após a recuperação da origem, a validação deve confirmar:

- o banco de dados está operacional;
- os dados de negócio necessários estão disponíveis;
- o CDC está habilitado e funcionando;
- o histórico necessário da origem permanece disponível;
- o Debezium consegue retomar a partir da posição correta na origem;
- nenhum intervalo de captura necessário está ausente sem explicação.

Se o histórico necessário de alterações da origem não estiver mais disponível, a recuperação *downstream* pode exigir *backfill* controlado ou outra fonte governada de recuperação.

### 13.3 Falha do CDC

Uma falha do CDC afeta o histórico de alterações da origem utilizado pelo Debezium.

Possíveis cenários incluem:

- processo de captura do CDC indisponível;
- instância de captura necessária indisponível;
- latência excessiva de captura;
- desvio de configuração do CDC;
- retenção removendo histórico necessário;
- falha de metadados ou permissão.

Uma falha do CDC pode existir enquanto o próprio AtlasCommerce permanece totalmente operacional.

As transações da origem podem, portanto, continuar enquanto a capacidade de recuperação analítica se degrada progressivamente.

### 13.4 Recuperação do CDC

A recuperação do CDC deve determinar:

- última posição da origem capturada com sucesso *downstream*;
- histórico mais antigo da origem ainda disponível;
- se todo o intervalo necessário permanece dentro da retenção do CDC;
- se a configuração de captura permanece válida.

Se o intervalo necessário permanecer disponível:

**Restaurar CDC**
→ **Restaurar Debezium**
→ **Retomar Captura**
→ **Validar Continuidade**

Se o histórico necessário tiver expirado:

**Apenas a Recuperação do CDC É Insuficiente**
→ outra fonte de recuperação ou estratégia de *backfill* é necessária.

### 13.5 Falha do Debezium

Uma falha do Debezium interrompe a conversão e a publicação das alterações da origem como eventos do Kafka.

Possíveis cenários incluem:

- conector parado;
- falha do conector;
- falha de conexão com o SQL Server;
- falha de conexão com o Kafka;
- falha de autenticação;
- defeito de configuração do conector;
- falha relacionada a *schema*.

Durante uma interrupção do Debezium:

- as transações da origem podem continuar;
- o histórico do CDC pode continuar se acumulando;
- o Kafka não recebe os novos eventos correspondentes;
- o processamento *downstream* pode eventualmente ficar ocioso;
- a Certified Gold pode permanecer disponível, porém desatualizada.

### 13.6 Recuperação do Debezium

O Debezium deve retomar a partir de sua posição durável de captura quando o histórico necessário do CDC permanecer disponível.

A validação da recuperação deve confirmar:

- o conector está em execução;
- a conectividade com a origem foi restaurada;
- a conectividade com o Kafka foi restaurada;
- a posição esperada da origem foi recuperada;
- os eventos começam a ser publicados novamente;
- nenhum intervalo necessário da origem está ausente;
- o *backlog downstream* começa a avançar.

Um status `RUNNING` do conector é necessário, mas não constitui evidência suficiente de recuperação da captura.

### 13.7 Falha do Apicurio Registry

O Apicurio Registry governa as versões e a compatibilidade dos contratos de eventos.

Uma falha pode afetar:

- registro de *schema*;
- consulta de *schema*;
- inicialização de produtores ou consumidores;
- validação de contratos;
- evolução de *schema*.

O impacto exato depende de produtores e consumidores exigirem ou não acesso ativo ao Registry para a operação executada.

Eventos previamente retidos no Kafka permanecem duráveis independentemente da disponibilidade do Registry.

### 13.8 Recuperação do Apicurio Registry

A recuperação do Registry deve restaurar:

- definições de *schema* necessárias;
- configuração de compatibilidade;
- acesso;
- histórico de versões;
- consulta de contratos necessária ao processamento.

A validação deve confirmar que:

- os contratos atualmente suportados permanecem disponíveis;
- versões históricas de contratos necessárias para *replay* permanecem interpretáveis;
- nenhuma evolução não autorizada de *schema* ocorreu durante a falha;
- produtores e consumidores retomam corretamente.

A disponibilidade do Registry sem as definições históricas necessárias representa recuperação incompleta.

### 13.9 Falha do Produtor Kafka

Uma falha de um produtor Kafka impede que um serviço publique os eventos necessários.

Para o fluxo inicial da origem, isso pode se manifestar como incapacidade do Debezium de publicar enquanto o histórico de captura da origem permanece disponível *upstream*.

Possíveis causas incluem:

- indisponibilidade do *broker*;
- interrupção de rede;
- falha de autenticação;
- falha de autorização;
- erro de configuração do produtor.

A recuperação deve determinar se o intervalo não publicado da origem permanece disponível *upstream*.

### 13.10 Falha do Broker Kafka

Uma falha de um *broker* Kafka pode afetar:

- publicação de eventos;
- consumo;
- disponibilidade de partições;
- progresso de grupos de consumidores;
- acesso aos eventos retidos.

O laboratório de nó único da Versão 1 pode sofrer indisponibilidade completa do Kafka devido à falha de um único *broker*.

Isso demonstra uma limitação física da topologia do laboratório, e não o modelo lógico de disponibilidade pretendido.

### 13.11 Recuperação do Kafka

A recuperação do Kafka deve estabelecer ambos:

**Recuperação do Serviço**
→ o *broker* e os tópicos necessários estão disponíveis.

e:

**Recuperação dos Eventos**
→ o histórico retido necessário permanece completo e legível.

A validação deve confirmar:

- disponibilidade do *broker*;
- disponibilidade dos tópicos;
- partições necessárias;
- estado dos grupos de consumidores;
- intervalo retido disponível para *replay*;
- publicação pelos produtores;
- retomada dos consumidores.

Se o histórico necessário do Kafka tiver sido perdido, a recuperação *downstream* deve utilizar outra fonte confiável.

### 13.12 Falha de Consumidor Kafka

Uma falha de consumidor Kafka pode interromper uma responsabilidade de processamento *downstream* enquanto o Kafka continua retendo os eventos recebidos.

Efeitos representativos incluem:

- aumento do *lag* do consumidor;
- crescimento do *backlog*;
- outros grupos de consumidores continuam normalmente;
- atividade dos produtores permanece saudável.

Essa é uma importante vantagem de confiabilidade do transporte desacoplado de eventos.

### 13.13 Recuperação de Consumidor Kafka

A recuperação do consumidor deve normalmente:

1. reinicializar o consumidor;
2. recuperar o progresso confirmado do consumidor;
3. retomar a partir dos *offsets* apropriados;
4. tolerar reentrega;
5. processar o *backlog* acumulado;
6. validar o avanço do *checkpoint*;
7. verificar ausência de lacunas de processamento ou efeitos de negócio duplicados.

Se os *offsets* necessários estiverem fora da retenção, a recuperação normal do consumidor será insuficiente.

Nesse caso, é necessário escalar a fonte de recuperação.

### 13.14 Falha do Processador Bronze

Uma falha no processamento da Bronze impede que novos eventos do Kafka passem a fazer parte do histórico analítico durável.

Possíveis causas incluem:

- falha do consumidor;
- defeito de transformação ou serialização;
- falha do MinIO;
- falha de *checkpoint*;
- falha persistente de evento;
- esgotamento de recursos.

O Kafka deve continuar retendo as entradas enquanto a janela de retenção configurada permanecer disponível.

### 13.15 Recuperação do Processador Bronze

Quando o histórico do Kafka permanecer completo:

**Restaurar Processador Bronze**
→ retomar a partir do progresso confirmado  
→ tolerar reentrega  
→ persistir histórico ausente na Bronze  
→ processar *backlog*  
→ validar continuidade.

Se já existir saída na Bronze para eventos reentregues, o tratamento idempotente deve impedir efeitos históricos duplicados não pretendidos.

Se o histórico do Kafka estiver incompleto, a recuperação da Bronze deve escalar para *backfill*, *backup*, arquivo ou outra fonte histórica governada.

### 13.16 Falha do MinIO

O MinIO fornece armazenamento durável para Bronze e Silver na Versão 1.

Os cenários de falha podem incluir:

- serviço indisponível;
- falha do host ou disco;
- esgotamento de capacidade;
- falha de gravação de objetos;
- corrupção de objetos;
- falha de permissão.

O impacto depende de qual camada armazenada foi afetada.

Uma falha do MinIO pode afetar simultaneamente Bronze e Silver porque ambas estão hospedadas no mesmo ambiente de armazenamento do laboratório.

### 13.17 Recuperação do MinIO

A recuperação deve determinar:

- disponibilidade do serviço;
- integridade do armazenamento;
- objetos afetados;
- completude da Bronze;
- completude da Silver;
- *backup* ou estado alternativo de recuperação, quando implementado.

Se apenas o serviço do MinIO tiver falhado, mas os objetos armazenados permanecerem intactos:

→ restaurar serviço  
→ validar objetos  
→ retomar processamento.

Se os dados da Bronze tiverem sido perdidos:

→ recuperar a partir do Kafka enquanto estiverem retidos, ou de outra fonte histórica de recuperação.

Se os dados da Silver tiverem sido perdidos enquanto a Bronze permanecer válida:

→ realizar *rebuild* da Silver a partir da Bronze.

O fluxo de recuperação depende do estado perdido, e não apenas do nome do serviço MinIO.

### 13.18 Perda do Armazenamento Bronze

A perda do armazenamento Bronze é significativa porque a Bronze é a principal base analítica de reconstrução de longo prazo.

A preferência de recuperação é:

**Histórico do Kafka Ainda Completo**
→ realizar *replay* do Kafka e *rebuild* da Bronze.

Se o histórico do Kafka não estiver mais completo:

→ utilizar outra fonte histórica governada, como *backfill*, *backup* ou arquivo, de acordo com o histórico necessário.

A perda tanto da Bronze quanto do histórico correspondente do Kafka representa uma condição de recuperação significativamente mais ampla.

### 13.19 Falha do Processador Silver

Uma falha no processamento da Silver pode ocorrer enquanto a ingestão na Bronze continua funcionando corretamente.

Os efeitos podem incluir:

- a Bronze continua se acumulando;
- o *checkpoint* da Silver para;
- a Gold não recebe novo estado Silver válido;
- a Certified Gold visível aos consumidores permanece inalterada e, eventualmente, desatualizada.

Possíveis causas incluem:

- defeito de transformação;
- incompatibilidade de *schema*;
- falha de armazenamento;
- falha de dependência;
- dados problemáticos (*poison data*);
- esgotamento de recursos.

### 13.20 Recuperação do Processador Silver

Se o estado da Silver permanecer válido e apenas o processamento tiver parado:

→ reinicializar  
→ retomar a partir do progresso confirmado  
→ processar o *backlog* da Bronze.

Se o estado da Silver estiver inválido ou a lógica de processamento tiver sido defeituosa:

→ selecionar escopo confiável da Bronze  
→ reprocessar  
→ realizar *rebuild* parcial ou completo da Silver  
→ validar qualidade e linhagem.

A recuperação da Silver não deve retornar automaticamente ao Kafka quando uma Bronze válida já fornecer o limite de recuperação apropriado.

### 13.21 Perda do Armazenamento Silver

Se o estado persistido da Silver for perdido enquanto a Bronze permanecer completa e confiável:

**Bronze**
→ *rebuild* da Silver.

A validação da recuperação deve confirmar:

- escopo necessário completo da Bronze;
- versão correta do processamento da Silver;
- completude da Silver reconstruída;
- qualidade;
- linhagem;
- compatibilidade *downstream*.

Posteriormente, um *rebuild* completo da Gold pode ser necessário, dependendo de qual estado da Gold permanecer válido.

### 13.22 Falha do Processador Gold

Uma falha no processamento da Gold afeta a geração do estado analítico dimensional.

Possíveis efeitos incluem:

- a Silver permanece atual;
- a geração da candidata Gold para;
- a Certified Gold existente permanece disponível;
- a atualidade se degrada.

Possíveis causas incluem:

- defeito de transformação;
- falha do SQL Server;
- falha na lógica dimensional;
- esgotamento de recursos;
- falha de qualidade ou reconciliação.

Falha técnica no processamento da Gold e falha de certificação devem permanecer distinguíveis.

### 13.23 Recuperação do Processador Gold

Se o estado existente da Gold permanecer confiável e apenas o processamento tiver parado:

→ restaurar processamento  
→ retomar a partir do limite apropriado da Silver  
→ gerar nova candidata.

Se a lógica ou o estado da Gold estiver inválido:

→ selecionar Silver confiável  
→ realizar *rebuild* da candidata Gold  
→ validar  
→ reconciliar  
→ certificar  
→ publicar.

A recuperação da Gold deve proteger o estado existente reconhecidamente válido da Certified Gold até que sua substituição seja validada.

### 13.24 Falha do AtlasWarehouse

O AtlasWarehouse hospeda as estruturas analíticas de disponibilização da Gold.

Os cenários de falha podem incluir:

- serviço do SQL Server indisponível;
- banco de dados indisponível;
- falha de armazenamento;
- estado analítico corrompido;
- falha de permissão;
- falha mais ampla do host.

O impacto depende de:

- o processamento da Gold estar indisponível;
- a Certified Gold estar indisponível;
- as versões analíticas armazenadas permanecerem intactas.

### 13.25 Recuperação do AtlasWarehouse

Possíveis fluxos de recuperação incluem:

**Falha do Serviço, Dados Intactos**
→ restaurar SQL Server  
→ validar Gold e Certified Gold  
→ retomar processamento.

**Estado Gold Perdido, Silver Válida**
→ restaurar a base do banco de dados, se necessário  
→ realizar *rebuild* da Gold a partir da Silver.

**Estado do Banco de Dados Restaurado a Partir de Backup**
→ validar versão restaurada  
→ determinar intervalo ausente  
→ realizar *rebuild* ou *catch-up* a partir da Silver  
→ recertificar quando necessário.

A disponibilidade restaurada do banco de dados não comprova, por si só, a correção analítica atual.

### 13.26 Falha de Controle de Qualidade

Uma falha de controle de qualidade pode resultar de:

- dados efetivamente inválidos;
- defeito na regra de qualidade;
- dependência de validação indisponível;
- configuração incorreta da regra.

A resposta correta depende de a falha representar uma condição dos dados ou um defeito do sistema de validação.

Uma falha de qualidade normalmente bloqueia a certificação quando a regra for bloqueante.

Ela não deve interromper automaticamente uma ingestão *upstream* não relacionada.

### 13.27 Falha de Reconciliação

Uma falha de reconciliação indica que a consistência esperada não foi demonstrada.

A plataforma deve preservar:

- estado da candidata;
- evidências da reconciliação;
- Certified Gold anterior.

A recuperação pode exigir:

- investigação;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- correção da lógica de reconciliação.

Uma reconciliação que falhou não deve ser ignorada simplesmente para restaurar a atualidade.

### 13.28 Falha de Certificação

Uma falha de certificação impede que uma candidata atravesse o limite governado de publicação.

O comportamento preferencial para os consumidores é:

**Candidata Falha na Certificação**
→ candidata permanece não publicada  
→ Certified Gold anterior permanece disponível quando possível.

A recuperação se concentra em identificar e corrigir a candidata ou o controle que falhou.

A certificação é tentada novamente somente depois que a condição subjacente tiver sido tratada, quando necessário.

### 13.29 Falha de Publicação

Uma falha de publicação ocorre quando uma candidata válida não pode ser promovida com segurança.

A recuperação deve preservar a visibilidade atômica para os consumidores.

O comportamento esperado é:

**Versão Certificada Anterior**
→ permanece visível.

**Nova Candidata**
→ permanece não confirmada ou não publicada até que a promoção segura seja concluída com sucesso.

Se a publicação tiver alterado parcialmente o estado de forma inesperada, a recuperação deve restaurar uma única versão reconhecidamente válida e visível aos consumidores antes de qualquer publicação adicional.

### 13.30 Falha do Power BI

Uma falha do Power BI afeta o consumo analítico, e não o processamento de dados *upstream*.

Possíveis cenários incluem:

- serviço ou Desktop do Power BI indisponível;
- falha de conectividade;
- falha de autenticação;
- falha do modelo semântico;
- falha de atualização.

O processamento *upstream* pode continuar normalmente enquanto os consumidores não conseguem acessar o produto analítico.

Essa é uma falha de disponibilidade do consumo analítico, e não uma falha de ingestão de dados.

### 13.31 Recuperação do Power BI

A recuperação deve determinar se o problema está em:

- Power BI;
- autenticação;
- conectividade de rede;
- Certified Gold;
- modelo semântico;
- configuração do relatório.

Após a recuperação, os consumidores devem acessar o estado atual aprovado da Certified Gold.

A recuperação do Power BI não deve contornar a Certified Gold conectando-se diretamente às camadas *upstream*.

### 13.32 Falha do Airflow

Uma falha do Airflow pode impedir que trabalhos agendados ou orientados por dependências sejam iniciados ou avancem.

Possíveis cenários incluem:

- *scheduler* indisponível;
- *worker* indisponível;
- erro de DAG;
- problema no estado de tarefa;
- falha do banco de dados de metadados.

O Kafka e as camadas duráveis de dados podem continuar operando de forma independente.

A ingestão por *streaming* não deve depender do Airflow como mecanismo autoritativo de transporte de eventos.

### 13.33 Recuperação do Airflow

A recuperação do Airflow deve restaurar a orquestração preservando o estado real do processamento.

Antes de executar novamente tarefas que falharam, a plataforma deve determinar:

- se a operação subjacente já produziu saída durável;
- se uma nova tentativa da tarefa é idempotente;
- qual *checkpoint* permanece confirmado;
- se um estágio *downstream* já avançou.

O estado das tarefas do Airflow não deve substituir a inspeção do estado durável do processamento.

### 13.34 Falha do Prometheus

Uma falha do Prometheus afeta a coleta de métricas e a disponibilidade de métricas históricas.

O processamento de dados pode continuar enquanto a visibilidade das métricas estiver reduzida ou indisponível.

Isso cria uma degradação da observabilidade que pode reduzir a capacidade de detectar:

- *backlog*;
- latência;
- comportamento de novas tentativas;
- progresso da recuperação;
- violações de SLO.

### 13.35 Recuperação do Prometheus

A recuperação deve restaurar a coleta de métricas e determinar se ocorreram lacunas de telemetria.

Uma lacuna de monitoramento deve permanecer distinguível de uma lacuna real de processamento.

Quando uma atividade crítica de recuperação tiver ocorrido enquanto o Prometheus estava indisponível, evidências adicionais podem ser necessárias a partir de:

- logs;
- *checkpoints*;
- metadados de processamento;
- reconciliação;
- outras telemetrias disponíveis.

### 13.36 Falha do Grafana

Uma falha do Grafana afeta a disponibilidade de painéis e visualizações.

As métricas subjacentes e o processamento podem permanecer saudáveis.

A recuperação deve restaurar o acesso aos painéis sem tratar a disponibilidade da visualização como equivalente à saúde da plataforma.

Alertas que dependam de funcionalidades específicas do Grafana devem ser avaliados de acordo com a implementação final.

### 13.37 Falha de Logging Estruturado

Uma falha de *logging* pode reduzir a qualidade do diagnóstico e das evidências enquanto o processamento continua.

Possíveis causas incluem:

- falha de gravação;
- esgotamento de armazenamento;
- defeito de configuração de *logging*;
- destino de logs indisponível.

O processamento crítico não deve depender silenciosamente de *logging* diagnóstico não essencial quando uma falha no destino de logs interromperia desnecessariamente o fluxo de dados.

Entretanto, metadados obrigatórios de auditoria ou recuperação ainda devem ser preservados por meio de seus mecanismos duráveis governados.

### 13.38 Falha de Rede

Uma interrupção de rede pode afetar um ou mais relacionamentos entre componentes.

Exemplos incluem:

- SQL Server ↔ Debezium;
- Debezium ↔ Kafka;
- Kafka ↔ Bronze;
- processamento ↔ MinIO;
- processamento ↔ AtlasWarehouse;
- Power BI ↔ Certified Gold.

A recuperação deve restaurar a conectividade e, em seguida, validar a continuidade do processamento.

Um teste de conexão bem-sucedido não comprova que o *backlog*, o *checkpoint* ou o estado dos dados foram recuperados.

### 13.39 Falha de Credencial

Uma falha de credencial pode tornar um serviço saudável operacionalmente indisponível.

A recuperação depende da classificação:

**Credencial Incorreta ou Expirada**
→ corrigir ou rotacionar a credencial.

**Credencial Comprometida**
→ revogar  
→ substituir  
→ validar a rejeição da confiança anterior.

A recuperação de confiabilidade deve preservar os requisitos de segurança definidos em **Segurança e Governança**.

### 13.40 Falha do Host

No laboratório da Versão 1, um único host físico pode conter múltiplos componentes.

Uma falha do host pode, portanto, afetar simultaneamente:

- Kafka;
- MinIO;
- Airflow;
- observabilidade;
- cargas de trabalho de processamento;
- armazenamento local.

Isso representa um amplo domínio físico compartilhado de falha.

As evidências de recuperação do laboratório devem distinguir claramente a resiliência lógica dos componentes da redundância física no nível do host.

### 13.41 Falha Completa do Laboratório

Uma falha completa do laboratório pode exigir a restauração de várias capacidades em ordem de dependência.

Uma sequência representativa pode incluir:

1. host e armazenamento;
2. origem SQL Server e AtlasWarehouse, quando afetados;
3. Kafka;
4. MinIO;
5. registro de *schemas*;
6. orquestração;
7. serviços de processamento;
8. observabilidade;
9. reconstrução *downstream* e *catch-up*;
10. certificação;
11. consumo analítico.

A ordem real deve refletir a topologia implementada e as dependências de recuperação.

Restaurar todos os processos dos serviços não restaura, por si só, o estado completo da plataforma.

### 13.42 Ordem das Dependências de Recuperação

A recuperação dos componentes deve considerar os relacionamentos de dependência.

Por exemplo:

**Processador Bronze**
depende de:
→ Kafka  
→ MinIO  
→ credenciais e rede válidas.

**Processador Silver**
depende de:
→ Bronze  
→ MinIO  
→ definições de processamento necessárias.

**Gold**
depende de:
→ Silver válida  
→ AtlasWarehouse.

Os procedimentos de recuperação devem restaurar ou validar as capacidades pré-requisito antes de tentar repetidamente o processamento dependente.

### 13.43 Cascata de Recuperação

Depois que um componente de uma camada inferior se recupera, as camadas *downstream* podem exigir *catch-up* em vez de recuperação sincronizada imediata.

Por exemplo:

**Debezium Restaurado**
→ Kafka começa a receber alterações acumuladas da origem  
→ *backlog* da Bronze cresce temporariamente  
→ Silver acompanha a Bronze  
→ Gold acompanha a Silver  
→ atualidade da Certified Gold é eventualmente restaurada.

A recuperação, portanto, se propaga ao longo do fluxo de dados ao longo do tempo.

A plataforma deve observar essa cascata de recuperação em vez de declarar sucesso no primeiro componente restaurado.

### 13.44 Validação da Recuperação de Componentes

A recuperação específica de componentes deve validar, quando aplicável:

- disponibilidade do serviço;
- conectividade das dependências;
- integridade do estado durável;
- continuidade do *checkpoint*;
- histórico de recuperação retido;
- comportamento do *backlog*;
- vazão retomada;
- correção do processamento;
- avanço *downstream*;
- qualidade;
- reconciliação;
- certificação;
- estado visível aos consumidores.

A profundidade da validação deve refletir a responsabilidade arquitetural do componente.

### 13.45 Evidências de Recuperação de Componentes

Evidências representativas de recuperação de componentes devem preservar:

- componente;
- cenário de falha;
- momento da falha;
- responsabilidade afetada;
- estado durável inicial;
- progresso inicial;
- impacto *downstream*;
- ação de recuperação;
- tempo de reinicialização ou restauração;
- progresso recuperado;
- *backlog*;
- resultado da validação;
- estado da recuperação *downstream*;
- tempo total decorrido da recuperação.

Essas evidências oferecem suporte tanto às afirmações de confiabilidade específicas dos componentes quanto ao planejamento futuro de recuperação.

### 13.46 Garantias de Falha e Recuperação de Componentes

O modelo de recuperação de componentes da Atlas Engineering deve preservar as seguintes garantias:

1. a falha de um componente é avaliada de acordo com sua responsabilidade arquitetural e seu estado durável;
2. a recuperação do serviço permanece distinta da recuperação do processamento e dos dados;
3. a recuperação do AtlasCommerce inclui a validação da continuidade da origem e do CDC;
4. a recuperação do CDC verifica se o histórico necessário de alterações da origem permanece disponível;
5. a recuperação do Debezium valida a continuidade da captura, e não apenas o status do conector;
6. a recuperação do registro de *schemas* preserva a interpretação dos contratos históricos necessária para *replay*;
7. a recuperação do Kafka valida o histórico retido de eventos, além da disponibilidade do *broker*;
8. uma falha de consumidor Kafka pode acumular *backlog* recuperável sem interromper produtores não relacionados;
9. a recuperação do consumidor retoma a partir do progresso confirmado e tolera reentrega;
10. a recuperação da Bronze prefere o histórico retido do Kafka enquanto ele permanecer completo e confiável;
11. a recuperação do MinIO é avaliada de acordo com quais camadas persistidas foram afetadas;
12. a perda da Silver pode ser recuperada a partir de uma Bronze válida quando o histórico necessário permanecer disponível;
13. a recuperação da Gold prefere uma Silver válida e protege a Certified Gold existente;
14. a recuperação do AtlasWarehouse distingue disponibilidade do banco de dados de correção analítica;
15. falhas de qualidade, reconciliação, certificação e publicação permanecem classes distintas de falha;
16. uma certificação que falhou não substitui a Certified Gold reconhecidamente válida;
17. uma falha de publicação preserva um único estado controlado e visível aos consumidores;
18. uma falha de consumo analítico não justifica contornar a Certified Gold;
19. o estado do Airflow não substitui o estado durável do processamento;
20. a falha de um componente de observabilidade permanece distinguível de uma falha de processamento de dados;
21. a recuperação de rede inclui validação da continuidade do processamento;
22. a recuperação de credenciais preserva os limites de segurança;
23. falhas no nível do host da Versão 1 permanecem reconhecidas como domínios físicos compartilhados de falha;
24. uma recuperação ampla segue uma ordem de restauração orientada por dependências;
25. a recuperação *downstream* pode ocorrer em cascata depois que o componente de origem da falha é restaurado;
26. a recuperação de um componente é considerada completa somente após a validação apropriada;
27. as afirmações de confiabilidade dos componentes são sustentadas por evidências controladas.

---

## 14. Falha Parcial e Isolamento de Falhas

A Atlas Engineering deve isolar falhas no menor escopo seguro, preservando correção, rastreabilidade e comportamento *downstream* governado.

Uma plataforma de dados distribuída pode continuar operando parcialmente quando um componente, partição, entidade, estágio de processamento, dependência ou produto de dados estiver degradado ou indisponível.

A disponibilidade parcial é aceitável somente quando o processamento não afetado permanecer independente do estado que falhou.

O princípio orientador é:

**Falha Local → Conter o Raio de Impacto → Preservar Processamento Válido → Bloquear Propagação Inválida → Recuperar o Escopo que Falhou → Revalidar**

O isolamento de falhas deve, portanto, equilibrar:

**Continuidade**
→ permitir que o processamento válido não relacionado continue.

com:

**Correção**
→ impedir que estados incompletos, inválidos ou ambíguos atravessem limites governados.

### 14.1 Falha Parcial

Uma falha parcial afeta apenas parte da plataforma enquanto outras responsabilidades permanecem operacionais.

Exemplos representativos incluem:

- uma partição do Kafka acumulando *lag* enquanto outras avançam;
- uma entidade de negócio falhando repetidamente na transformação;
- um conjunto de dados da Silver falhando enquanto outro permanece saudável;
- um produto de dados da Gold falhando na certificação;
- uma dependência indisponível apenas para um subconjunto de cargas de trabalho;
- um produto analítico permanecendo desatualizado enquanto outro permanece atual;
- um grupo de consumidores falhando enquanto os produtores continuam normalmente.

Falhas parciais são esperadas em arquiteturas distribuídas.

A plataforma não deve presumir que a saúde seja puramente binária.

### 14.2 Isolamento de Falhas

O isolamento de falhas limita o efeito de um problema ao menor escopo arquitetural que possa ser separado com segurança.

Possíveis limites de isolamento incluem:

- registro;
- evento;
- partição;
- entidade;
- lote;
- conjunto de dados;
- estágio de processamento;
- produto de dados;
- grupo de consumidores;
- dependência;
- ambiente.

O limite de isolamento deve refletir a semântica de processamento.

Um limite tecnicamente conveniente não é suficiente se a correção depender de um estado fora desse limite.

### 14.3 Isolamento e Análise de Dependências

Antes de isolar um escopo que falhou, a plataforma deve determinar se o processamento não afetado depende dele.

Por exemplo:

**Um Produto Falha**
→ outro produto independente pode continuar.

Mas:

**Dimensão Conformada Compartilhada Falha**
→ vários produtos da Gold podem depender desse estado.

As decisões de isolamento devem considerar:

- dependências diretas;
- dados de referência compartilhados;
- dimensões compartilhadas;
- ordem de processamento;
- dependências de certificação;
- linhagem;
- relacionamentos com consumidores.

O raio de impacto é definido pela dependência real, e não apenas pelo componente que emitiu o erro.

### 14.4 Isolamento no Nível de Registro

Um único registro pode falhar enquanto os registros ao seu redor permanecem válidos.

Quando o modelo de processamento permitir isolamento seguro, o registro que falhou pode entrar em um fluxo explícito de falha enquanto entradas não relacionadas continuam.

O isolamento no nível de registro é apropriado somente quando o processamento além do registro que falhou não viola:

- ordenação;
- estado da entidade;
- consistência referencial;
- correção das agregações;
- requisitos de completude *downstream*.

Um registro que falhou deve permanecer rastreável e recuperável.

### 14.5 Isolamento no Nível de Evento

Um evento pode ser isolado quando sua falha não tornar eventos posteriores inseguros para interpretação independente.

Considerações relevantes incluem:

- ordenação dos eventos;
- sequência da entidade;
- dependência de estado anterior;
- tipo de operação;
- semântica da transformação *downstream*.

Por exemplo, ignorar um evento inválido de atualização e, em seguida, processar um evento posterior da mesma entidade pode produzir um estado incorreto se o evento posterior presumir que a transição ausente ocorreu.

O isolamento deve, portanto, ser semântico, e não meramente técnico.

### 14.6 Isolamento no Nível de Partição

O particionamento do Kafka fornece um limite natural de isolamento de falhas quando a ordenação é exigida dentro de uma partição.

Uma falha persistente em uma partição pode permitir que outras partições continuem se forem semanticamente independentes.

A partição afetada pode ser:

- pausada;
- isolada;
- investigada;
- submetida a *replay*;
- recuperada separadamente.

A plataforma deve preservar seu progresso confirmado e não deve ignorar silenciosamente *offsets* que falharam apenas para manter a partição avançando.

### 14.7 Isolamento no Nível de Entidade

Algumas lógicas de processamento são naturalmente delimitadas por entidade de negócio.

Exemplos podem incluir:

- Customer;
- Product;
- Transaction;
- Shipment.

Se uma entidade contiver estado histórico inválido, a plataforma pode isolar essa entidade enquanto continua processando entidades não relacionadas quando o modelo de processamento permitir.

O isolamento no nível de entidade é útil quando a reconstrução pode posteriormente ser realizada utilizando todo o histórico relevante da entidade.

### 14.8 Isolamento no Nível de Lote

Um lote que falhou pode ser isolado de outros lotes concluídos com sucesso.

A plataforma deve conhecer a semântica de confirmação do lote.

Se os lotes forem independentes e estiverem confirmados de forma durável, um lote que falhou não deve invalidar automaticamente os lotes concluídos.

Se o lote depender de um estado compartilhado incompleto, uma recuperação mais ampla pode ser necessária.

O isolamento de lotes deve permanecer consistente com os *checkpoints* e os metadados de processamento.

### 14.9 Isolamento no Nível de Conjunto de Dados

Um conjunto de dados pode falhar independentemente de outro.

Por exemplo:

**Silver Sales**
→ falha de processamento.

**Silver Product**
→ pode continuar se não depender do estado de Sales que falhou.

O isolamento no nível de conjunto de dados pode reduzir interrupções em toda a plataforma.

Dependências compartilhadas ainda devem ser consideradas antes de declarar outro conjunto de dados como não afetado.

### 14.10 Isolamento de Produto de Dados

Uma falha em um produto analítico não deve impedir automaticamente que produtos não relacionados permaneçam disponíveis.

Por exemplo:

**Candidata Daily Sales**
→ falha na reconciliação.

Outro produto certificado independente pode continuar sua publicação normal.

A certificação e a publicação devem, portanto, operar em um escopo apropriado ao produto de dados, em vez de sempre funcionarem como um único estado binário para toda a plataforma.

### 14.11 Falha de Dependência Compartilhada

O isolamento torna-se mais difícil quando o estado que falhou é compartilhado.

Exemplos incluem:

- Kafka;
- MinIO;
- AtlasWarehouse;
- registro de *schemas*;
- dimensão conformada compartilhada;
- dependência de autenticação compartilhada;
- host compartilhado.

Uma falha de dependência compartilhada pode legitimamente afetar várias responsabilidades *downstream*.

A plataforma não deve declarar isolamento além do que o grafo de dependências realmente permite.

### 14.12 Falha de Dimensão Conformada

Uma dimensão conformada pode ser compartilhada por múltiplos fatos da Gold ou produtos analíticos.

Se seu estado se tornar inválido, os produtos *downstream* afetados podem precisar parar de avançar mesmo que seu processamento de fatos permaneça tecnicamente operacional.

A plataforma deve determinar:

- quais produtos dependem da dimensão;
- qual intervalo histórico foi afetado;
- se os produtos certificados anteriores permanecem confiáveis;
- se a continuação parcial *downstream* é segura.

Semânticas analíticas compartilhadas podem, portanto, ampliar o raio de impacto lógico de um defeito de processamento localizado.

### 14.13 Falha de Dados de Referência

Dados de referência podem dar suporte a múltiplos fluxos de processamento.

Se o estado de referência necessário estiver indisponível ou inválido:

- transformações dependentes podem precisar ser pausadas;
- transformações não relacionadas podem continuar;
- o reprocessamento histórico pode exigir a versão correta dos dados de referência.

A plataforma não deve substituir por valores atuais arbitrários apenas para manter o processamento avançando.

### 14.14 Isolamento e Ordenação

O isolamento de falhas deve preservar os requisitos de ordenação.

Quando entradas posteriores dependerem de uma entrada anterior que falhou, o processamento não poderá avançar com segurança além da falha apenas porque os dados posteriores são tecnicamente legíveis.

Por exemplo:

**Evento 100**
→ falha.

**Evento 101**
→ depende do estado resultante do Evento 100.

Processar o Evento 101 independentemente pode criar um estado incorreto.

Nesses casos, o limite seguro de isolamento pode precisar incluir toda a entidade ou partição.

### 14.15 Isolamento e Completude

Continuar o processamento parcial pode produzir um conjunto de dados incompleto.

A plataforma deve determinar se um estado incompleto é aceitável para o estágio afetado.

Exemplos:

**Bronze**
→ um evento isolado pode representar uma lacuna histórica e, portanto, exige remediação explícita.

**Candidata Gold**
→ dados obrigatórios ausentes podem tornar a candidata não certificável.

O processamento parcial não deve se tornar silenciosamente uma saída governada completa.

### 14.16 Isolamento e Regras de Qualidade

As regras de qualidade podem operar em diferentes escopos.

Uma falha de regra no nível de registro pode permitir o isolamento de um único registro.

Uma falha de regra no nível do conjunto de dados pode exigir o bloqueio de toda a candidata.

Exemplos incluem:

**Valor Individual Inválido**
→ possível quarentena do registro.

**Completude do Conjunto de Dados Abaixo do Limite**
→ bloqueio no nível da candidata.

O isolamento de falhas deve respeitar o escopo da regra de qualidade.

### 14.17 Isolamento e Reconciliação

A reconciliação pode revelar que uma falha supostamente isolada afeta uma correção mais ampla.

Por exemplo:

**Um Registro em Quarentena**
→ a contagem de transações *downstream* deixa de reconciliar.

O resultado pode ser aceitável somente se o comportamento esperado da reconciliação considerar explicitamente o estado em quarentena.

Caso contrário, a candidata afetada pode permanecer bloqueada.

O isolamento não elimina os requisitos de reconciliação.

### 14.18 Isolamento e Certificação

A certificação deve avaliar se falhas isoladas afetam os critérios de publicação do produto.

Possíveis resultados incluem:

**Falha Fora do Escopo do Produto**
→ certificação não afetada.

**Exceção Governada Não Bloqueante**
→ a certificação pode prosseguir de acordo com uma regra explícita.

**Estado Ausente ou Inválido Bloqueante**
→ certificação falha.

A decisão de certificação deve refletir o contrato governado do produto de dados, e não a pressão operacional para restaurar a atualidade.

### 14.19 Publicação Fail-Safe

O isolamento de falhas deve proteger a Certified Gold.

Uma falha parcial *upstream* não deve fazer com que dados parcialmente recuperados ou incompletos substituam uma versão certificada reconhecidamente válida.

O comportamento preferencial é:

**Candidata Afetada**
→ permanece bloqueada ou isolada.

**Certified Gold Anterior**
→ permanece visível aos consumidores enquanto continuar confiável.

Isso converte algumas falhas *upstream* em degradação de atualidade, em vez de falha de correção visível aos consumidores.

### 14.20 Disponibilidade Analítica Parcial

A plataforma pode permanecer parcialmente disponível para os consumidores.

Por exemplo:

**Daily Sales**
→ versão certificada anterior disponível, porém desatualizada.

**Outro Produto**
→ atual e totalmente disponível.

O estado operacional deve, portanto, ser capaz de expressar condições no nível do produto, em vez de apenas:

**Plataforma UP**

ou:

**Plataforma DOWN**

A arquitetura especializada de **Observabilidade** deve expor esses estados adequadamente.

### 14.21 Isolamento e Backlog

Quando um escopo de processamento é isolado, seu *backlog* pode continuar crescendo.

Exemplos incluem:

- partição do Kafka pausada;
- histórico de entidade que falhou;
- conjunto de dados bloqueado;
- candidata aguardando remediação.

A plataforma deve monitorar:

- tamanho do *backlog*;
- dado pendente mais antigo;
- janela de retenção restante;
- capacidade de recuperação.

Isolamento não equivale a resolução.

### 14.22 Isolamento e Janela de Recuperação

Uma falha isolada com segurança pode se tornar um risco de perda de dados se o histórico *upstream* necessário expirar antes da remediação.

Por exemplo:

**Partição Pausada**
→ Kafka continua retendo seus eventos.

Com o passar do tempo:

→ os eventos necessários se aproximam da expiração da retenção.

A prioridade operacional deve, portanto, considerar a janela de recuperação do trabalho isolado.

### 14.23 Isolamento e Consumo de Recursos

Trabalhos que falharam podem continuar consumindo recursos por meio de:

- novas tentativas;
- *logging*;
- armazenamento;
- quarentena;
- *backlog* retido;
- validações repetidas.

O isolamento deve impedir que um escopo que falhou consuma capacidade desproporcional necessária ao processamento saudável.

Novas tentativas limitadas e transições controladas de estado de falha apoiam esse objetivo.

### 14.24 Isolamento e Quarentena

A quarentena pode fornecer um destino controlado para falhas específicas de dados quando o processamento puder continuar com segurança sem a entrada afetada.

A quarentena deve preservar:

- identidade da entrada;
- motivo da falha;
- versão de processamento;
- metadados relevantes;
- estado de remediação;
- capacidade de reprocessamento.

O comportamento da quarentena é abordado com mais detalhes na próxima seção, para falhas problemáticas e persistentes de processamento.

### 14.25 Isolamento e Checkpoints

O comportamento dos *checkpoints* deve permanecer consistente com a estratégia de isolamento.

Se o modelo de processamento não puder confirmar com segurança o progresso além de uma falha isolada:

→ o progresso deve permanecer antes da entrada que falhou.

Se um mecanismo governado de quarentena permitir avanço seguro:

→ o avanço do *checkpoint* deve preservar evidências de que a entrada isolada permanece não resolvida e recuperável.

A arquitetura não deve criar uma lacuna oculta de processamento.

### 14.26 Isolamento com Processamento Contínuo

Quando a continuidade do processamento for segura, a plataforma deve preservar um estado explícito indicando que:

- um escopo está degradado;
- outro escopo continua;
- trabalho não resolvido permanece;
- a completude *downstream* pode ser diferente.

Isso impede que sucesso parcial seja confundido com recuperação completa.

### 14.27 Isolamento com Bloqueio de Processamento

Algumas falhas exigem o bloqueio do progresso.

Exemplos incluem:

- a ordenação necessária não pode ser preservada;
- uma dimensão compartilhada está inválida;
- uma incompatibilidade de contrato afeta todos os eventos subsequentes;
- o estado de destino *downstream* não pode ser atualizado com segurança;
- a fonte de recuperação é incerta.

Bloquear é preferível a avançar conscientemente um estado incorreto.

A disponibilidade não deve ser priorizada acima da correção quando ambas entrarem em conflito.

### 14.28 Contenção de Falhas

A contenção limita a capacidade de propagação de um estado inválido.

Possíveis ações incluem:

- pausar um consumidor;
- pausar uma partição;
- interromper um estágio de processamento;
- isolar um conjunto de dados;
- bloquear a certificação de uma candidata;
- bloquear a publicação;
- restringir o acesso dos consumidores;
- preservar a versão certificada anterior.

A contenção deve ser proporcional ao escopo afetado conhecido.

### 14.29 Raio de Impacto

Raio de impacto descreve a extensão do comportamento da plataforma afetada por uma falha.

Dimensões relevantes incluem:

- número de registros;
- partições;
- entidades;
- conjuntos de dados;
- produtos;
- consumidores;
- estágios de processamento;
- duração;
- intervalo histórico.

O isolamento de falhas deve reduzir o raio de impacto quando for técnica e semanticamente seguro.

O raio de impacto deve ser medido ou descrito, e não presumido.

### 14.30 Isolamento e Causa Raiz

O local onde a falha é observada pode ser diferente do local de sua causa raiz.

Por exemplo:

**Candidata Gold Falha**
→ a causa raiz pode ser:
- defeito na Silver;
- histórico ausente na Bronze;
- problema na origem;
- problema nos dados de referência.

O isolamento deve impedir propagação adicional enquanto a investigação rastreia o problema até seu limite de origem.

A linhagem e os metadados de processamento apoiam essa análise.

### 14.31 Recuperação do Isolamento

A recuperação de um escopo isolado deve seguir o mecanismo apropriado para a falha subjacente.

Possíveis ações incluem:

- nova tentativa;
- retomada;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- correção dos dados de referência;
- migração de contrato.

O escopo isolado deve retornar ao processamento normal somente depois que a validação necessária for concluída com sucesso.

### 14.32 Retorno ao Processamento Normal

Após a recuperação, o escopo anteriormente isolado deve retornar ao processamento normal de maneira controlada.

A validação deve determinar:

- *backlog* não resolvido processado;
- ordenação correta restaurada;
- *checkpoint* alinhado;
- ausência de lacunas não explicadas;
- ausência de efeitos de negócio duplicados;
- estado dependente consistente;
- qualidade aprovada;
- reconciliação aprovada;
- certificação restaurada quando aplicável.

A recuperação permanece incompleta enquanto o escopo isolado estiver logicamente divergente do estado governado da plataforma.

### 14.33 Isolamento e Linhagem

A linhagem deve preservar o efeito do isolamento de falhas quando ele alterar materialmente o processamento.

Metadados relevantes podem identificar:

- entrada isolada;
- motivo da falha;
- momento do isolamento;
- estado *downstream* afetado;
- execução da recuperação;
- reprocessamento;
- saída resultante.

Isso apoia a investigação de por que uma parte dos dados históricos seguiu um fluxo de recuperação diferente.

### 14.34 Isolamento e Evidências

Evidências representativas de falha parcial devem preservar:

- escopo da falha;
- escopo não afetado;
- análise de dependências;
- ação de isolamento;
- comportamento do *backlog*;
- estado do *checkpoint*;
- impacto sobre consumidores;
- estado da janela de recuperação;
- ação de recuperação;
- validação;
- resultado da reintegração.

As evidências devem demonstrar ambos:

**a falha foi contida**

e:

**o processamento não afetado permaneceu correto**.

### 14.35 Cenários de Teste de Falha Parcial

A Versão 1 deve validar cenários representativos, como:

**Teste de Falha Parcial 1 — Isolamento de Partição**
→ introduzir uma falha persistente controlada em uma partição do Kafka  
→ verificar se outras partições continuam quando for seguro  
→ recuperar a partição afetada  
→ validar ordenação e estado final.

**Teste de Falha Parcial 2 — Falha de Certificação de Produto**
→ fazer com que uma candidata Gold falhe em um controle bloqueante de qualidade ou reconciliação  
→ confirmar que a Certified Gold anterior permanece disponível  
→ confirmar que o comportamento de produtos não relacionados permanece não afetado quando apropriado.

**Teste de Falha Parcial 3 — Falha de Conjunto de Dados da Silver**
→ interromper um fluxo controlado de processamento da Silver  
→ permitir que o processamento independente continue  
→ recuperar o conjunto de dados afetado  
→ validar a consistência *downstream*.

**Teste de Falha Parcial 4 — Dependência Compartilhada**
→ interromper uma dependência compartilhada do laboratório  
→ identificar o raio de impacto real  
→ verificar se o escopo documentado da falha corresponde ao comportamento observado.

Os cenários exatos devem refletir o grafo de dependências implementado.

### 14.36 Garantias de Falha Parcial e Isolamento

O modelo de falha parcial da Atlas Engineering deve preservar as seguintes garantias:

1. falha parcial é tratada como uma condição esperada de uma plataforma distribuída;
2. as falhas são isoladas no menor escopo seguro quando prático;
3. o escopo de isolamento é baseado na semântica e nas dependências do processamento, e não apenas em conveniência técnica;
4. o isolamento de registro ou evento ocorre somente quando o processamento posterior permanece semanticamente seguro;
5. os limites das partições do Kafka podem oferecer suporte ao isolamento preservando a ordenação da partição;
6. isolamento de entidade, lote, conjunto de dados e produto de dados permanece disponível quando suas dependências permitirem;
7. dependências compartilhadas podem legitimamente ampliar o escopo da falha;
8. dimensões conformadas compartilhadas e dados de referência são considerados ao determinar o raio de impacto;
9. o isolamento não viola a ordenação necessária de eventos ou entidades;
10. o processamento parcial não se torna silenciosamente um estado governado completo;
11. o escopo das regras de qualidade influencia se o isolamento de registro, conjunto de dados ou candidata é apropriado;
12. a reconciliação permanece aplicável ao processamento isolado;
13. a certificação determina se falhas isoladas bloqueiam a publicação;
14. uma falha parcial *upstream* não substitui automaticamente uma Certified Gold reconhecidamente válida;
15. a disponibilidade analítica pode permanecer específica por produto durante uma falha parcial;
16. o *backlog* isolado e as janelas de recuperação restantes permanecem observáveis;
17. o isolamento impede que trabalhos que falharam consumam capacidade descontrolada da plataforma;
18. a quarentena não cria lacunas ocultas de processamento;
19. o comportamento dos *checkpoints* permanece consistente com a estratégia de isolamento selecionada;
20. um estado degradado explícito distingue continuação parcial de saúde completa;
21. a correção pode exigir o bloqueio do processamento mesmo quando a continuidade da execução for tecnicamente possível;
22. a contenção impede que estado inválido se propague além do limite afetado;
23. o raio de impacto é avaliado de acordo com o impacto *downstream* real;
24. a causa raiz permanece distinguível do local onde a falha é observada;
25. o escopo isolado retorna ao processamento normal somente após a validação necessária da recuperação;
26. linhagem e evidências preservam comportamentos significativos de isolamento de falhas;
27. o tratamento de falhas parciais é considerado demonstrado somente após testes e evidências controlados.

---

## 15. Poison Records e Falhas Persistentes de Processamento

A Atlas Engineering deve tratar explicitamente entradas que falham repetidamente durante processamento determinístico.

Um *poison record* é uma entrada que impede consistentemente o processamento bem-sucedido sob a definição de processamento aplicável e que dificilmente terá sucesso por meio de uma nova tentativa comum sem remediação.

Uma falha persistente de processamento é uma condição mais ampla na qual execuções repetidas não conseguem avançar com segurança porque a causa subjacente permanece não resolvida.

O modelo orientador é:

**Falha de Processamento → Classificar → Nova Tentativa Limitada → Esgotamento das Novas Tentativas → Isolar ou Bloquear com Segurança → Preservar Entrada que Falhou → Remediar → Reprocessar → Validar → Reintegrar**

A plataforma deve evitar ambos:

**Novas Tentativas Infinitas**
→ uma falha determinística consome repetidamente a capacidade de processamento.

e:

**Descarte Silencioso**
→ uma entrada que falhou desaparece do fluxo governado de processamento para que o progresso possa parecer saudável.

### 15.1 Poison Record

Um *poison record* é uma entrada cujo conteúdo, estrutura, estado ou relacionamento causa consistentemente uma falha de processamento.

Causas representativas podem incluir:

- *payload* malformado;
- versão de contrato não suportada;
- *schema* incompatível;
- valor obrigatório inválido;
- conversão de tipo impossível;
- premissa de processamento violada;
- referência obrigatória ausente;
- histórico inconsistente da entidade;
- defeito de transformação exposto por uma entrada específica.

O termo descreve o comportamento do processamento.

Ele não significa automaticamente que o próprio registro de negócio da origem seja inválido.

### 15.2 Falha Persistente de Processamento

Nem toda falha persistente é causada por um único *poison record*.

Uma falha persistente também pode resultar de:

- lógica de processamento defeituosa;
- *deployment* incompatível;
- configuração inválida;
- contexto histórico necessário indisponível;
- dados de referência ausentes;
- estado de destino corrompido;
- problema de permissão não resolvido;
- incompatibilidade de contrato afetando muitos registros.

A resposta de recuperação deve, portanto, identificar se a falha é:

**Específica dos Dados**

ou:

**Sistêmica**

antes de selecionar uma estratégia de isolamento.

### 15.3 Poison Record versus Falha Transitória

Uma falha transitória pode ter sucesso depois que a condição afetada for recuperada.

Por exemplo:

**Indisponibilidade Temporária do MinIO**
→ uma nova tentativa pode ter sucesso.

Um *poison record* normalmente falha de forma determinística até que algo seja alterado.

Por exemplo:

**Payload Não Pode Ser Interpretado pelo Contrato Aplicável**
→ aguardar dez segundos não altera o *payload*.

Novas tentativas repetidas sem remediação não fornecem nenhum valor de recuperação.

### 15.4 Classificação de Falhas

Antes do início do tratamento de falhas persistentes, a plataforma deve classificar a falha quando for prático.

Categorias representativas incluem:

- infraestrutura transitória;
- infraestrutura persistente;
- contrato;
- *schema*;
- qualidade de dados;
- dependência de dados de referência;
- defeito de processamento;
- autorização;
- estado corrompido;
- desconhecida.

A classificação apoia a decisão de:

- realizar nova tentativa;
- pausar;
- colocar em quarentena;
- escalar;
- executar *replay*;
- reprocessar;
- executar *backfill*;
- executar *rebuild*.

Falhas desconhecidas não devem ser automaticamente tratadas como seguras para isolamento de *poison records*.

### 15.5 Esgotamento das Novas Tentativas

Um fluxo de *poison record* começa somente depois que a política aplicável de novas tentativas limitadas determina que novas tentativas comuns não são mais apropriadas.

O esgotamento das novas tentativas deve preservar:

- identidade da entrada;
- posição de processamento;
- número de tentativas;
- momento da primeira falha;
- momento da falha mais recente;
- classificação do erro;
- versão de processamento;
- estado relevante das dependências.

A entrada que falhou deve permanecer recuperável depois que as novas tentativas forem interrompidas.

### 15.6 Sem Novas Tentativas Infinitas

A Atlas Engineering não deve deixar intencionalmente falhas determinísticas em novas tentativas infinitas e descontroladas.

Novas tentativas infinitas podem:

- consumir capacidade de processamento;
- gerar logs excessivos;
- ocultar a idade da falha não resolvida;
- aumentar o *backlog*;
- ameaçar janelas de retenção;
- criar fadiga de alertas;
- impedir um escalonamento significativo da recuperação.

O esgotamento das novas tentativas deve, portanto, fazer a transição da falha para um estado persistente explícito.

### 15.7 Sem Descarte Silencioso

Uma entrada que falhou não deve simplesmente ser ignorada para avançar o progresso do processamento, a menos que um mecanismo governado explícito estabeleça que esse avanço é seguro.

O descarte silencioso pode criar:

- lacunas históricas;
- estado incorreto da entidade;
- diferenças de reconciliação;
- produtos analíticos incompletos;
- perda de dados não rastreável.

Progresso operacional não é um motivo válido para descartar uma entrada não resolvida.

### 15.8 Decisão de Isolamento da Falha

Após o esgotamento das novas tentativas, a plataforma deve determinar se a entrada que falhou pode ser isolada com segurança.

A decisão deve considerar:

- requisitos de ordenação;
- dependências da entidade;
- semântica da partição;
- completude *downstream*;
- dependências de referência;
- impacto sobre agregações;
- regras de qualidade;
- requisitos de reconciliação.

O possível resultado é:

**Seguro para Isolar**
→ preservar separadamente a entrada que falhou e permitir que trabalhos independentes continuem.

ou:

**Inseguro para Isolar**
→ bloquear o escopo de processamento afetado até a remediação.

### 15.9 Quarentena

Quarentena é um estado governado de falha utilizado para preservar uma entrada que falhou fora do fluxo normal de processamento bem-sucedido quando o isolamento seguro for possível.

A quarentena deve preservar informações suficientes para oferecer suporte a:

- diagnóstico;
- remediação;
- reprocessamento;
- reconciliação;
- linhagem;
- auditabilidade.

Quarentena não é exclusão.

É a preservação durável de trabalho não resolvido.

### 15.10 Escopo da Quarentena

A quarentena pode operar em diferentes escopos, dependendo da semântica do processamento.

Possíveis escopos incluem:

- registro individual;
- evento;
- entidade;
- intervalo de partição;
- lote;
- fragmento de conjunto de dados.

O menor escopo seguro de quarentena deve normalmente ser preferido.

A plataforma não deve forçar quarentena no nível de registro quando a correção exigir o isolamento de um escopo mais amplo.

### 15.11 Metadados da Quarentena

Um item em quarentena deve preservar, quando aplicável:

- entrada original ou referência durável a ela;
- origem;
- identidade do evento;
- tópico;
- partição;
- *offset*;
- chave de negócio;
- momento do evento ou da transação;
- estágio de processamento;
- versão de processamento;
- classificação da falha;
- contexto do erro;
- número de novas tentativas;
- momento da primeira falha;
- momento de entrada em quarentena;
- estado de remediação;
- execução da recuperação.

Valores sensíveis devem permanecer sujeitos aos controles de segurança e privacidade.

### 15.12 Estado da Quarentena

A quarentena deve expor um ciclo de vida explícito.

Estados representativos podem incluir:

**FAILED**
→ o processamento falhou após as novas tentativas aplicáveis.

**QUARANTINED**
→ entrada preservada para investigação.

**REMEDIATION_REQUIRED**
→ uma ação corretiva foi identificada.

**READY_FOR_REPROCESSING**
→ a correção necessária foi concluída.

**REPROCESSING**
→ a execução da recuperação está em andamento.

**RESOLVED**
→ a entrada corrigida ou o processamento corrigido retornou com sucesso ao fluxo governado.

A implementação exata pode utilizar nomes de estados diferentes.

O requisito arquitetural é que falhas não resolvidas e resolvidas permaneçam distinguíveis.

### 15.13 Quarentena Não É um Destino Final

A quarentena deve possuir um fluxo de recuperação.

Um projeto que armazena indefinidamente entradas que falharam sem:

- responsabilidade;
- investigação;
- remediação;
- reprocessamento;
- encerramento;

apenas transfere a falha para outro lugar.

Cada item em quarentena deve permanecer atribuído a uma responsabilidade de processamento não resolvida até ser resolvido ou até que uma disposição governada determine explicitamente outro destino.

### 15.14 Quarentena e Ordenação do Kafka

A ordenação do Kafka é específica por partição.

Se um evento problemático afetar um estado necessário para eventos subsequentes na mesma partição, colocar esse evento em quarentena e confirmar o progresso além dele pode violar a semântica de ordenação.

Por exemplo:

**Offset 100**
→ atualização obrigatória da entidade falha.

**Offset 101**
→ depende do estado produzido pelo Offset 100.

Processar o 101 como se o 100 nunca tivesse existido pode criar um estado incorreto.

Nesse caso, o isolamento seguro pode exigir pausar a partição ou isolar um histórico mais amplo da entidade, em vez de simplesmente colocar um evento em quarentena.

### 15.15 Quarentena e Confirmação de Offset

O avanço do *offset* após a quarentena deve ser explicitamente justificado.

Existem dois modelos gerais:

**Modelo Bloqueante**
→ *offset* que falhou permanece não resolvido  
→ o progresso do consumidor não avança além do limite inseguro.

**Modelo de Isolamento Governado**
→ a entrada que falhou é preservada de forma durável em quarentena  
→ a arquitetura demonstra que entradas posteriores podem ser processadas independentemente  
→ o progresso normal pode avançar enquanto o trabalho não resolvido permanece explicitamente rastreado.

A plataforma não deve confirmar o progresso além de uma entrada que falhou apenas para reduzir o *lag* do consumidor.

### 15.16 Quarentena e Ordenação da Entidade

Mesmo quando o progresso da partição do Kafka puder tecnicamente avançar, a semântica da entidade pode tornar o processamento posterior inseguro.

Se o estado histórico de uma entidade estiver incompleto:

→ eventos posteriores dessa entidade também podem precisar ser isolados.

Outras entidades independentes podem continuar quando for seguro.

Isso pode criar um escopo de quarentena ou recuperação no nível da entidade, em vez de um escopo de registro individual.

### 15.17 Quarentena e Bronze

A Bronze deve preservar a fidelidade histórica bruta sempre que tecnicamente possível.

Se um evento puder ser representado de forma durável na Bronze mesmo que uma transformação posterior não consiga interpretá-lo com sucesso, a falha pode pertencer a um estágio de processamento *downstream*, em vez de impedir a preservação bruta.

Essa distinção é importante:

**Incapaz de Transformar**
não significa necessariamente
**Incapaz de Preservar a Entrada Bruta**.

Quando a preservação bruta for bem-sucedida, a Bronze permanece como evidência da entrada original mesmo enquanto o processamento *downstream* estiver bloqueado.

### 15.18 Falha Problemática Antes da Bronze

Uma falha antes da persistência na Bronze é mais significativa porque a base histórica analítica ainda não foi estabelecida.

A recuperação deve preservar a entrada do Kafka que falhou por meio de um mecanismo durável apropriado, garantindo que:

- o histórico necessário do Kafka não expire sem ser percebido;
- o evento permaneça recuperável;
- o progresso não o ignore silenciosamente;
- a completude *downstream* permaneça explícita.

Se a própria preservação bruta não puder ser realizada, a falha exige maior prioridade operacional.

### 15.19 Falha Problemática na Silver

Uma transformação da Silver pode falhar para uma entrada histórica enquanto a Bronze permanece completa.

O limite preferencial de recuperação permanece sendo a Bronze.

Dependendo da semântica do processamento:

- a entrada afetada pode ser colocada em quarentena;
- a entidade afetada pode ser isolada;
- o processamento pode ser pausado;
- dados não relacionados podem continuar.

Após a remediação:

**Histórico da Bronze**
→ processamento corrigido da Silver  
→ reprocessamento  
→ validação  
→ reintegração.

O *replay* do Kafka é desnecessário quando uma Bronze válida já contém o histórico necessário.

### 15.20 Falha Problemática na Gold

Uma falha no processamento da Gold pode ser causada por:

- estado inválido da Silver;
- inconsistência dimensional;
- defeito de transformação;
- valor analítico inesperado;
- relacionamento ausente.

A candidata Gold afetada deve permanecer não publicada.

A Certified Gold anterior deve permanecer visível aos consumidores quando for confiável.

O tratamento de falhas da Gold deve, portanto, priorizar o isolamento da candidata, em vez da modificação direta da Certified Gold.

### 15.21 Falha de Qualidade versus Falha de Processamento

Um registro pode ser processado tecnicamente enquanto falha em uma regra de qualidade.

Isso é diferente de uma exceção de processamento.

**Falha de Processamento**
→ a transformação não consegue ser concluída conforme pretendido.

**Falha de Qualidade**
→ o processamento foi concluído, mas o estado resultante viola uma expectativa de qualidade aplicável.

Ambas podem levar ao isolamento ou ao bloqueio da certificação, mas suas evidências e seus fluxos de remediação são diferentes.

### 15.22 Falha de Contrato

Um evento que não pode ser interpretado sob o contrato aplicável pode representar:

- contrato histórico não suportado;
- defeito do produtor;
- problema no Registry;
- evolução incompatível de *schema*;
- defeito do consumidor.

A plataforma deve preservar o evento original e a identidade do contrato antes de tentar a remediação.

Uma falha de contrato não deve ser "corrigida" convertendo silenciosamente uma estrutura histórica desconhecida para o *schema* atual.

### 15.23 Falha de Dados de Referência

O processamento pode falhar porque dados de referência necessários estão ausentes ou inválidos.

Possíveis formas de recuperação incluem:

- corrigir dados de referência;
- restaurar a versão histórica de referência;
- corrigir a lógica de processamento;
- reprocessar o escopo afetado.

A própria entrada pode ser válida.

Os metadados da quarentena devem, portanto, distinguir uma falha de dependência de referência de dados inválidos na origem.

### 15.24 Defeito na Lógica de Processamento

Um padrão de *poison records* pode revelar um defeito no código de processamento, em vez de um registro defeituoso.

Por exemplo:

**Valor Específico Válido**
→ aciona um fluxo de transformação não tratado.

Se vários registros falharem devido ao mesmo defeito lógico, tratar cada registro como um problema independente de qualidade de dados classificaria incorretamente o incidente.

A plataforma deve agrupar ou correlacionar falhas persistentes quando elas compartilharem uma provável causa sistêmica.

### 15.25 Padrão de Falhas Repetidas

Falhas persistentes repetidas com o mesmo:

- contrato;
- campo;
- versão de processamento;
- transformação;
- tipo de entidade;
- categoria de erro;

podem indicar um defeito mais amplo.

A observabilidade deve tornar esses padrões visíveis para que o tratamento da falha possa escalar da remediação no nível do registro para uma correção no nível do processamento.

### 15.26 Crescimento da Quarentena

A quarentena pode crescer enquanto o processamento normal continua.

A plataforma deve observar:

- número de registros não resolvidos;
- falha não resolvida mais antiga;
- taxa de crescimento;
- entidades afetadas;
- estágios de processamento afetados;
- janela de recuperação *upstream* retida;
- impacto sobre a completude *downstream*.

Uma quarentena crescente é uma condição de confiabilidade mesmo quando o *lag* do consumidor aparenta estar saudável.

### 15.27 Quarentena e Janelas de Recuperação

Entradas em quarentena podem depender de histórico *upstream* que permanece disponível apenas por um período limitado.

A plataforma não deve presumir que apenas metadados duráveis de quarentena preservem todas as dependências necessárias para recuperação posterior.

Quando a remediação exigir:

- eventos vizinhos;
- histórico completo da entidade;
- estado histórico de referência;

essas dependências devem permanecer recuperáveis.

O projeto da quarentena deve, portanto, considerar a retenção.

### 15.28 Quarentena e Backlog

Quarentena e *backlog* são diferentes.

**Backlog**
→ trabalho válido ou potencialmente válido aguardando processamento normal.

**Quarentena**
→ trabalho explicitamente removido do fluxo normal de sucesso porque uma falha persistente exige remediação.

Um sistema pode possuir:

- baixo *lag* do consumidor;
- nenhum *backlog* normal;
- quarentena significativa não resolvida.

A saúde operacional deve considerar ambos.

### 15.29 Quarentena e Completude

Permitir que o processamento continue após a quarentena pode tornar o estado *downstream* incompleto.

A plataforma deve representar isso explicitamente quando relevante.

Uma candidata *downstream* não deve ser certificada se entradas em quarentena não resolvidas violarem seus requisitos de completude.

A quarentena, portanto, interage diretamente com:

- qualidade;
- reconciliação;
- certificação;
- interpretação de atualidade.

### 15.30 Quarentena e Reconciliação

A reconciliação deve considerar explicitamente entradas em quarentena.

Por exemplo:

**Contagem da Origem / Bronze**
=
**Processados com Sucesso**
+
**Em Quarentena Governada**
+
**Outro Estado Explicitamente Classificado**

quando essa contabilização for apropriada.

O objetivo é impedir que dados não resolvidos desapareçam em uma diferença de reconciliação sem explicação.

### 15.31 Quarentena e Certificação

A política de certificação deve determinar se uma quarentena não resolvida é:

- irrelevante para determinado produto;
- uma exceção governada não bloqueante;
- uma condição bloqueante de completude ou correção.

A decisão deve ser explícita.

A pressão operacional não deve transformar uma falha bloqueante em não bloqueante sem governança.

### 15.32 Quarentena e Atualidade

Um produto pode aparentar processamento recente enquanto contém lacunas históricas não resolvidas causadas pela quarentena.

A atualidade, por si só, portanto, não comprova completude.

A plataforma deve distinguir:

**Momento Recente de Processamento**

de:

**Estado Completo e Governado dos Dados**.

Essa distinção é particularmente importante quando o processamento *downstream* puder continuar contornando falhas isoladas.

### 15.33 Remediação

A remediação altera a condição que causou a falha persistente.

Formas representativas de remediação podem incluir:

- corrigir a lógica de transformação;
- implantar suporte ao contrato;
- restaurar dados de referência;
- corrigir configuração;
- restaurar permissão;
- reparar estado corrompido;
- corrigir dados da origem por meio do processo de negócio apropriado quando legítimo.

A remediação deve tratar a causa raiz, em vez de apenas reinicializar os contadores de novas tentativas.

### 15.34 Correção de Dados da Origem

Se a causa raiz for um dado de negócio inválido no AtlasCommerce, a correção deve ocorrer por meio do processo operacional apropriado sempre que possível.

A plataforma analítica não deve reescrever silenciosamente o histórico autoritativo da origem apenas para fazer com que o processamento *downstream* seja bem-sucedido.

Após uma correção legítima na origem, a recuperação pode exigir:

- novo evento do CDC;
- *replay*;
- reprocessamento;
- *backfill*;

dependendo da falha original e do histórico disponível.

### 15.35 Correção Analítica

Se os dados da origem forem válidos, mas a interpretação analítica estiver incorreta, a correção pertence à definição de processamento analítico afetada.

Por exemplo:

**Evento Válido da Origem**
→ defeito de transformação na Silver.

A resposta correta é:

→ corrigir a lógica da Silver  
→ reprocessar o histórico afetado da Bronze.

A origem não deve ser modificada para compensar um defeito analítico.

### 15.36 Edição Manual de Dados

A edição manual direta de dados derivados não deve ser o mecanismo normal de remediação.

Alterações manuais podem:

- contornar a linhagem;
- comprometer a reprodutibilidade;
- ocultar a causa raiz;
- criar divergência em relação ao estado *upstream*;
- fazer com que *rebuilds* posteriores reintroduzam o defeito.

Quando uma intervenção manual excepcional for inevitável, ela deve ser explicitamente governada, atribuível e seguida por uma correção durável no fluxo normal de processamento.

### 15.37 Pronto para Reprocessamento

Um item em quarentena deve avançar para o reprocessamento somente depois que a remediação necessária estiver concluída.

Antes da liberação, a plataforma deve determinar:

- causa da falha tratada;
- versão correta de processamento disponível;
- contexto histórico necessário disponível;
- estado de referência necessário disponível;
- estado de destino preparado;
- escopo de reprocessamento definido.

Realizar novas tentativas sem essas condições pode simplesmente recriar a falha persistente.

### 15.38 Reprocessamento da Quarentena

A recuperação pode processar:

- o item individual;
- o histórico completo da entidade;
- o intervalo afetado da partição;
- o lote afetado;
- um escopo mais amplo do conjunto de dados.

O escopo de recuperação depende da semântica de ordenação e dependência.

O reprocessamento deve utilizar a fonte confiável apropriada, como a Bronze, em vez de depender apenas de uma representação transformada da quarentena quando o histórico governado original permanecer disponível.

### 15.39 Reintegração

Após o reprocessamento bem-sucedido, o escopo recuperado deve retornar ao estado governado normal.

A reintegração deve validar:

- entrada que falhou processada com sucesso;
- entradas subsequentes necessárias permanecem consistentes;
- ordenação restaurada;
- estado do *checkpoint* correto;
- ausência de efeitos de negócio duplicados;
- ausência de lacunas de processamento não resolvidas;
- qualidade *downstream*;
- reconciliação;
- certificação quando aplicável.

Alterar o estado da quarentena para `RESOLVED` é resultado da validação da recuperação, e não um substituto para ela.

### 15.40 Encerramento da Quarentena

Um item em quarentena pode ser encerrado somente quando sua disposição governada for conhecida.

Possíveis resultados incluem:

- reprocessado com sucesso;
- substituído por uma operação governada de recuperação;
- comprovadamente irrelevante para o produto *downstream* afetado;
- descartado de acordo com uma política explícita e aprovada de dados.

Encerramento não deve significar:

**paramos de olhar para isso**.

O motivo do encerramento deve permanecer atribuível.

### 15.41 Nova Falha Após Remediação

Se um item falhar novamente após a remediação, a plataforma deve preservar a nova falha como parte do mesmo histórico de recuperação, quando apropriado.

Falhas repetidas podem indicar:

- remediação incompleta;
- segundo defeito;
- análise incorreta da causa raiz;
- dependência histórica ausente.

A resposta deve retornar ao diagnóstico, em vez de alternar indefinidamente entre liberação e quarentena.

### 15.42 Responsabilidade por Poison Records

Falhas persistentes exigem responsabilidade operacional.

O domínio responsável depende da causa.

Exemplos incluem:

**Defeito nos Dados da Origem**
→ remediação na origem ou no negócio.

**Defeito de Contrato**
→ responsabilidade pela ingestão ou pelo contrato.

**Defeito na Lógica da Silver**
→ responsabilidade pela transformação.

**Defeito na Lógica da Gold**
→ responsabilidade pelo modelo analítico.

A arquitetura deve tornar a responsabilidade identificável mesmo que a Versão 1 seja operada por uma única pessoa.

### 15.43 Observabilidade de Poison Records

Falhas persistentes devem expor, quando aplicável:

- quantidade não resolvida;
- categoria da falha;
- estágio afetado;
- entidade afetada;
- momento da primeira falha;
- idade;
- número de novas tentativas;
- estado da quarentena;
- estado da remediação;
- risco para a janela de recuperação;
- impacto *downstream*.

Painéis detalhados e limites de alerta pertencem à **Observabilidade**.

Este documento define as informações de confiabilidade que devem estar disponíveis.

### 15.44 Alertas de Poison Records

Os alertas devem priorizar condições como:

- novo *poison record* bloqueante;
- esgotamento das novas tentativas;
- crescimento da quarentena;
- falha não resolvida mais antiga excedendo um intervalo esperado;
- partição bloqueada;
- janela de retenção em risco;
- certificação de produto bloqueada;
- falhas repetidas compartilhando um padrão comum.

Um único registro isolado, governado e não bloqueante pode exigir urgência diferente de uma falha que bloqueia toda uma partição de processamento.

### 15.45 Segurança de Poison Records

A quarentena pode conter dados brutos da origem ou contexto de erro.

Ela deve, portanto, preservar os controles aplicáveis de:

- acesso;
- classificação;
- privacidade;
- criptografia;
- retenção;
- auditabilidade.

Mensagens de erro não devem expor desnecessariamente:

- credenciais;
- segredos;
- valores sensíveis do *payload*.

A quarentena faz parte da plataforma governada, e não de uma área irrestrita de depuração.

### 15.46 Retenção de Poison Records

Dados em quarentena devem permanecer disponíveis por tempo suficiente para oferecer suporte a:

- investigação;
- remediação;
- reprocessamento;
- evidências;
- requisitos de auditoria aplicáveis.

A retenção não deve ser automaticamente indefinida.

Quarentenas resolvidas devem seguir um ciclo de vida explícito consistente com a classificação dos dados e os requisitos de recuperação.

### 15.47 Validação de Poison Records

A validação da recuperação deve confirmar, quando aplicável:

- falha corretamente classificada;
- novas tentativas esgotadas de acordo com a política;
- entrada que falhou preservada de forma durável;
- isolamento não criou lacunas ocultas;
- ordenação permaneceu válida;
- remediação tratou a causa raiz;
- escopo histórico correto foi reprocessado;
- nenhum efeito de negócio duplicado ocorreu;
- *checkpoints* estão consistentes;
- completude *downstream* restaurada;
- qualidade aprovada;
- reconciliação aprovada;
- certificação restaurada quando aplicável.

Um incidente de *poison record* não está resolvido apenas porque o *lag* normal do consumidor retornou a zero.

### 15.48 Evidências de Poison Records

Evidências representativas devem preservar:

- identidade da entrada;
- classificação da falha;
- versão original de processamento;
- novas tentativas;
- esgotamento das novas tentativas;
- ação de quarentena;
- comportamento do *checkpoint*;
- escopo afetado;
- impacto *downstream*;
- causa raiz;
- remediação;
- execução do reprocessamento;
- resultados da validação;
- disposição final;
- tempo decorrido até a recuperação.

Essas evidências demonstram que o tratamento de falhas persistentes preserva os dados, em vez de ocultá-los.

### 15.49 Cenários de Teste de Poison Records

A Versão 1 deve validar cenários representativos, como:

**Teste de Poison Record 1 — Falha Determinística de Transformação**
→ introduzir uma entrada controlada que falha repetidamente em uma transformação  
→ verificar novas tentativas limitadas  
→ verificar a transição para tratamento explícito de falha persistente  
→ corrigir a transformação  
→ reprocessar  
→ validar o estado final.

**Teste de Poison Record 2 — Isolamento Seguro**
→ introduzir uma falha controlada que possa ser isolada independentemente com segurança  
→ verificar se o processamento não relacionado continua  
→ verificar se a entrada que falhou permanece rastreável  
→ recuperá-la e reintegrá-la.

**Teste de Poison Record 3 — Isolamento Inseguro**
→ introduzir uma falha controlada de dependência ordenada  
→ verificar se o processamento não confirma silenciosamente o progresso além do limite inseguro  
→ remediar  
→ retomar na ordem correta.

**Teste de Poison Record 4 — Impacto na Certificação**
→ preservar uma falha não resolvida que torne uma candidata Gold incompleta  
→ verificar se a certificação permanece bloqueada  
→ resolver a falha  
→ realizar *rebuild* ou reprocessar o escopo afetado  
→ certificar somente após a validação.

Os cenários exatos devem refletir a implementação final da Versão 1.

### 15.50 Garantias de Poison Records e Falhas Persistentes

O modelo de *poison records* e falhas persistentes da Atlas Engineering deve preservar as seguintes garantias:

1. falhas persistentes determinísticas não permanecem em novas tentativas infinitas e descontroladas;
2. o esgotamento das novas tentativas transfere o trabalho para um estado explícito de falha;
3. entradas que falharam não são silenciosamente ignoradas apenas para avançar o processamento;
4. *poison records* permanecem distinguíveis de falhas transitórias e sistêmicas;
5. falhas persistentes são classificadas antes do isolamento quando prático;
6. o isolamento ocorre somente quando o processamento *downstream* pode permanecer semanticamente correto;
7. isolamento inseguro bloqueia o escopo de processamento afetado;
8. quarentena é preservação durável e governada, e não exclusão;
9. o escopo da quarentena reflete a semântica de ordenação e dependência;
10. entradas em quarentena preservam identidade, contexto e metadados de recuperação suficientes;
11. estados de quarentena resolvidos e não resolvidos permanecem distinguíveis;
12. a quarentena possui um fluxo explícito de remediação e recuperação;
13. o progresso do Kafka não avança além de uma entrada que falhou, a menos que o isolamento governado demonstre que isso é seguro;
14. a ordenação de entidades e partições permanece protegida;
15. preservação bruta permanece distinta de transformação *downstream* bem-sucedida;
16. falhas antes da persistência na Bronze recebem prioridade apropriada porque o histórico analítico ainda não foi estabelecido de forma durável;
17. uma Bronze válida permanece como limite preferencial de recuperação para falhas de transformação *downstream*;
18. falhas problemáticas da Gold não modificam diretamente a Certified Gold;
19. falhas de processamento permanecem distinguíveis de falhas de qualidade;
20. falhas de contrato e referência preservam sua classificação real de falha;
21. padrões repetidos de falha podem escalar do tratamento no nível de registro para investigação sistêmica;
22. o crescimento e a idade da quarentena permanecem observáveis;
23. a quarentena não oculta riscos relacionados à janela de recuperação ou ao *backlog*;
24. quarentenas não resolvidas permanecem visíveis aos controles de completude, reconciliação e certificação;
25. atualidade não é tratada como prova de completude;
26. a remediação trata a causa raiz, e não apenas reinicializa o estado das novas tentativas;
27. correção da origem e correção analítica permanecem responsabilidades distintas;
28. a edição manual direta de estado derivado não é o fluxo normal de remediação;
29. o reprocessamento começa somente depois que a remediação necessária e o contexto histórico estiverem disponíveis;
30. entradas recuperadas retornam ao processamento normal somente após validação;
31. o encerramento da quarentena exige uma disposição governada explícita;
32. uma nova falha após a remediação retorna ao diagnóstico, em vez de entrar em ciclos descontrolados;
33. falhas persistentes possuem responsabilidade identificável;
34. a quarentena preserva requisitos de segurança, privacidade e retenção;
35. a recuperação de *poison records* é validada quanto à ordenação, completude, correção do processamento e governança *downstream*;
36. o tratamento de falhas persistentes é considerado demonstrado somente após testes e evidências controlados.

---

## 16. Recuperação de Backlog e Catch-Up

A Atlas Engineering deve recuperar o *backlog* acumulado de forma controlada após uma interrupção, degradação ou desequilíbrio temporário de processamento.

Um *backlog* existe quando os dados *upstream* continuam se acumulando mais rapidamente do que um ou mais estágios *downstream* conseguem processá-los.

A recuperação de *backlog* é o processo de reduzir esse trabalho acumulado até que o estágio de processamento afetado retorne à sua faixa operacional esperada.

O modelo orientador é:

**Falha ou Degradação → Backlog se Acumula → Componente se Recupera → Processamento de Catch-Up → Backlog Diminui → Atualidade se Recupera → Estado Normal Governado é Restaurado**

O retorno de um componente ao estado operacional não implica que a recuperação do *backlog* esteja concluída.

### 16.1 Backlog

O *backlog* representa trabalho que permanece disponível para processamento, mas ainda não foi incorporado ao estado governado *downstream*.

Dependendo do estágio, o *backlog* pode ser representado por:

- *lag* do consumidor Kafka;
- partições ou arquivos da Bronze não processados;
- intervalos pendentes da Silver;
- entrada da Gold não processada;
- candidatas pendentes de certificação;
- trabalho de orquestração não resolvido.

O *backlog* deve permanecer distinguível de:

- quarentena;
- dados permanentemente ausentes;
- lacunas de processamento;
- estado derivado com falha.

O *backlog* é trabalho pendente recuperável, e não necessariamente trabalho inválido.

### 16.2 Causas do Backlog

O *backlog* pode se acumular por causa de:

- indisponibilidade de componente;
- falha de dependência;
- capacidade de processamento reduzida;
- pico temporário de carga de trabalho;
- controle de taxa;
- contenção de recursos;
- novas tentativas persistentes;
- partição pausada;
- manutenção controlada;
- carga de trabalho de *rebuild* ou *backfill* competindo com o processamento ativo.

O *backlog* pode, portanto, ocorrer mesmo quando nenhum componente está completamente indisponível.

### 16.3 Catch-Up

*Catch-up* é o processamento controlado do *backlog* acumulado depois que a capacidade afetada é restaurada ou capacidade adicional de processamento se torna disponível.

O objetivo é reduzir a diferença entre:

**Progresso Disponível Upstream**

e:

**Progresso Confirmado Downstream**

até que o estágio afetado retorne à sua condição operacional esperada.

O *catch-up* deve preservar as mesmas garantias de correção do processamento normal.

### 16.4 Catch-Up Não É Replay

O *catch-up* normalmente processa entradas que ainda não foram confirmadas pelo consumidor afetado.

*Replay* revisita intencionalmente entradas históricas que anteriormente eram consideradas processadas.

Por exemplo:

**Consumidor Parou no Offset 100**

→ eventos 101–500 se acumulam  
→ consumidor retoma a partir do 101  
→ *catch-up*.

Em contraste:

**Consumidor Já Havia Processado até 500**

→ redefinição intencional para 300  
→ *replay*.

A distinção deve permanecer explícita nas evidências operacionais.

### 16.5 Catch-Up Não É Reprocessamento

O *catch-up* processa trabalho comum pendente.

O reprocessamento processa intencionalmente entradas históricas novamente.

Um *backlog* pode conter dados que nunca foram processados pelo estágio afetado, enquanto o reprocessamento revisita dados que já produziram uma saída anterior.

### 16.6 Catch-Up e Checkpoints

O *catch-up* começa a partir do último progresso de processamento confirmado.

A plataforma não deve ignorar trabalho acumulado apenas para retornar rapidamente ao evento mais recente.

Conceitualmente:

**Progresso Confirmado**

→ início do *catch-up*.

**Entrada Disponível Mais Recente**

→ progresso-alvo.

A distância entre esses estados diminui à medida que o *catch-up* é bem-sucedido.

### 16.7 Medição do Backlog

O *backlog* deve ser mensurável de maneira que reflita o impacto real no processamento.

Medidas úteis podem incluir:

- contagem de registros ou eventos;
- *lag* do Kafka;
- bytes pendentes;
- número de partições pendentes;
- intervalos de processamento pendentes;
- idade da entrada não processada mais antiga;
- tempo estimado de processamento.

A contagem do *backlog*, isoladamente, pode ser insuficiente.

Mil eventos com dez segundos de idade podem representar menor impacto operacional do que dez eventos com várias horas de idade.

### 16.8 Idade do Item Pendente Mais Antigo

A idade do trabalho pendente mais antigo é uma métrica crítica de recuperação.

Conceitualmente:

**Profundidade do Backlog**

→ quanto trabalho permanece.

**Idade do Item Pendente Mais Antigo**

→ quão desatualizada se tornou a alteração de negócio mais antiga ainda não processada.

Juntas, essas métricas fornecem uma visão mais significativa da recuperação do que qualquer uma isoladamente.

### 16.9 Taxa de Crescimento do Backlog

O comportamento do *backlog* deve ser avaliado ao longo do tempo.

Três condições importantes são:

**Crescendo**

→ a entrada chega mais rapidamente do que a capacidade de processamento.

**Estável**

→ o processamento corresponde aproximadamente à taxa de entrada, mas não está reduzindo o trabalho acumulado.

**Diminuindo**

→ o processamento excede a taxa de entrada e o *catch-up* está ocorrendo.

Um componente recuperado que apenas estabiliza o *backlog* ainda não recuperou a atualidade histórica.

### 16.10 Capacidade de Catch-Up

Para reduzir o *backlog* enquanto novos dados continuam chegando, a vazão de processamento deve exceder a taxa de entrada.

Conceitualmente:

**Capacidade de Catch-Up**

=

**Vazão de Processamento - Vazão de Entrada**

Se:

**Vazão de Processamento ≤ Vazão de Entrada**

o *backlog* não pode diminuir enquanto novas entradas continuarem chegando.

Essa é uma restrição fundamental da capacidade de recuperação.

### 16.11 Razão de Catch-Up

A plataforma pode utilizar uma razão de *catch-up* para compreender a capacidade de recuperação.

Conceitualmente:

**Razão de Catch-Up = Vazão de Processamento / Vazão de Entrada**

Interpretação:

**Razão < 1**

→ o *backlog* cresce.

**Razão = 1**

→ o *backlog* permanece aproximadamente estável.

**Razão > 1**

→ o *backlog* pode diminuir.

A razão depende da carga de trabalho e deve ser medida, e não presumida.

### 16.12 Tempo de Catch-Up

O tempo estimado de *catch-up* depende de:

- tamanho do *backlog*;
- carga de trabalho de entrada;
- vazão efetiva de processamento;
- novas tentativas;
- contenção de recursos;
- dependências *downstream*.

Uma estimativa conceitual simplificada é:

**Tempo de Catch-Up ≈ Backlog / (Taxa de Processamento - Taxa de Entrada)**

quando a taxa de processamento é maior do que a taxa de entrada.

Essa estimativa é apenas um auxílio de planejamento.

O tempo real de recuperação deve ser medido porque o custo de processamento pode variar por registro, partição, estágio e carga de trabalho.

### 16.13 Backlog e Atualidade

O *backlog* afeta diretamente a atualidade analítica.

À medida que o *backlog* aumenta:

**Commit na Origem**

→ espera mais tempo antes do processamento *downstream*  
→ a latência ponta a ponta aumenta.

Uma plataforma pode permanecer totalmente disponível enquanto viola seu SLO de atualidade porque o *backlog* está crescendo.

A recuperação de *backlog*, portanto, participa diretamente da recuperação em nível de serviço.

### 16.14 Recuperação da Atualidade

A recuperação da atualidade ocorre progressivamente à medida que o trabalho acumulado é processado.

A plataforma deve distinguir:

**Componente Recuperado**

→ serviço opera.

**Backlog em Recuperação**

→ trabalho pendente está diminuindo.

**Atualidade Recuperada**

→ os dados novamente atendem à condição esperada de atualidade.

Esses estados podem ocorrer em momentos diferentes.

### 16.15 Catch-Up e Latência P95

Durante a recuperação, os percentis de latência ponta a ponta podem permanecer elevados mesmo depois que a vazão de processamento retornar ao normal.

Eventos históricos no *backlog* apresentam maior latência porque aguardaram durante a indisponibilidade.

A plataforma deve, portanto, esperar degradação temporária em:

- P50;
- P95;
- P99;

enquanto o *backlog* estiver sendo consumido.

A recuperação do SLO deve ser avaliada depois que a carga de trabalho afetada retornar à faixa operacional esperada.

### 16.16 Catch-Up e Novos Eventos

Novos eventos podem continuar chegando enquanto o *backlog* é processado.

A arquitetura deve preservar:

- requisitos de ordenação;
- justiça na distribuição do processamento;
- correção do negócio;
- segurança da retenção.

O sistema não deve priorizar arbitrariamente apenas novos eventos para fazer os *dashboards* parecerem atuais enquanto dados confirmados mais antigos permanecem não resolvidos.

### 16.17 Ordenação do Catch-Up

Quando a ordenação for importante, o *catch-up* deve preservar a mesma semântica de ordenação do processamento normal.

Para Kafka:

→ a ordenação da partição permanece aplicável.

Para processamento de estado de entidade:

→ a sequência histórica da entidade deve permanecer correta.

A velocidade do *catch-up* não deve ser aumentada violando a ordenação necessária.

### 16.18 Catch-Up e Paralelismo

Aumentar o paralelismo pode melhorar a vazão do *catch-up* quando a semântica do processamento permitir.

Possíveis abordagens incluem:

- mais instâncias de consumidores;
- mais *workers*;
- processamento paralelo de partições;
- processamento paralelo de arquivos;
- execução paralela de lotes.

O paralelismo deve respeitar:

- responsabilidade pelas partições do Kafka;
- ordenação;
- contenção de estado compartilhado;
- capacidade *downstream*;
- comportamento de escrita no banco de dados;
- idempotência.

Mais *workers* não produzem automaticamente melhoria linear e segura da vazão.

### 16.19 Catch-Up e Partições Kafka

O particionamento do Kafka define uma unidade natural de consumo paralelo.

A capacidade de *catch-up* pode, portanto, depender de:

- número de partições;
- distribuição das partições;
- quantidade de consumidores;
- desequilíbrio entre chaves de negócio;
- custo de processamento por partição.

Uma partição muito carregada pode permanecer atrasada enquanto outras já estão atualizadas.

O *lag* agregado dos consumidores pode ocultar esse desequilíbrio.

### 16.20 Desequilíbrio entre Partições

O desequilíbrio entre partições ocorre quando a carga de trabalho é distribuída de maneira desigual.

Uma partição pode conter significativamente mais eventos, ou eventos mais caros de processar, do que outras.

Durante a recuperação:

**Maioria das Partições**

→ realizou *catch-up*.

**Uma Partição**

→ permanece muito atrasada.

A plataforma deve, portanto, considerar o *backlog* específico por partição quando relevante.

O grupo completo de consumidores não deve ser considerado atualizado enquanto partições necessárias permanecerem materialmente atrasadas.

### 16.21 Catch-Up e Backpressure

O *catch-up* pode aumentar a pressão sobre dependências *downstream*.

Possíveis efeitos incluem:

- saturação de escrita no MinIO;
- contenção no processamento da Silver;
- pressão de escrita no AtlasWarehouse;
- crescimento do *log* de transações;
- esgotamento de CPU ou memória;
- saturação de rede.

O processo de recuperação não deve aumentar a vazão além da capacidade segura dos estágios *downstream*.

### 16.22 Controle de Taxa do Catch-Up

O *catch-up* pode exigir controle de taxa quando a velocidade máxima de processamento desestabilizaria a plataforma.

O controle de taxa pode preservar:

- estabilidade *downstream*;
- processamento ativo;
- observabilidade;
- capacidade de armazenamento;
- proteção do sistema transacional quando houver *backfill*.

O objetivo é:

**Recuperação Segura Mais Rápida**

e não:

**Maior Taxa de Processamento Possível**

### 16.23 Catch-Up e Folga de Recursos

Uma recuperação confiável exige folga de recursos suficiente para processar mais do que a carga de trabalho normal de entrada quando houver *backlog*.

Uma plataforma dimensionada apenas para sustentar sua carga média normal pode ser incapaz de recuperar o *backlog* acumulado sem:

- pausar novas entradas;
- aumentar temporariamente a capacidade;
- estender o tempo de recuperação;
- violar expectativas de atualidade.

A capacidade de recuperação deve, portanto, ser considerada no planejamento de capacidade.

### 16.24 Catch-Up e Carga de Pico

A recuperação do *backlog* pode coincidir com picos normais de carga.

Por exemplo:

**Recuperação Começa**

→ tráfego de entrada retorna  
→ carga de pico começa  
→ capacidade de *catch-up* diminui.

A Versão 1 deve validar o comportamento da recuperação sob uma carga representativa aumentada, e não apenas em condições ociosas.

### 16.25 Catch-Up e Carga de Novas Tentativas

A atividade de novas tentativas consome recursos durante o *catch-up*.

Se um subconjunto de registros continuar falhando:

→ as novas tentativas podem reduzir a capacidade disponível para processar o *backlog* saudável.

Falhas persistentes devem transicionar para tratamento governado de falhas, em vez de consumir indefinidamente a capacidade de *catch-up*.

### 16.26 Catch-Up e Quarentena

Entradas em quarentena não devem ser confundidas com *backlog* comum.

Um consumidor pode alcançar o último *offset* confirmado enquanto ainda existe quarentena não resolvida.

A recuperação operacional deve, portanto, avaliar tanto:

**Backlog Comum**

quanto:

**Falhas Persistentes Não Resolvidas**

antes de declarar correção completa do processamento.

### 16.27 Catch-Up e Retenção

O *backlog* deve permanecer dentro da janela de retenção da fonte de recuperação *upstream*.

Para Kafka:

**Evento Não Processado Necessário Mais Antigo**

deve permanecer retido até que a persistência *downstream* seja bem-sucedida.

Se a idade do *backlog* se aproximar da retenção do Kafka:

→ as opções de recuperação tornam-se progressivamente mais limitadas.

O risco de retenção pode exigir:

- aumento da capacidade de processamento;
- controle de taxa dos produtores, quando possível e apropriado;
- escalonamento da fonte de recuperação;
- priorização operacional.

### 16.28 Margem da Janela de Recuperação

A plataforma deve considerar a margem entre:

**Entrada Pendente Necessária Mais Antiga**

e:

**Expiração da Retenção**

quando mensurável.

Conceitualmente:

**Margem da Janela de Recuperação**

=

**Retenção Restante para a Entrada Necessária**

Uma margem em redução é um sinal de risco mais forte do que apenas o tamanho do *backlog*.

### 16.29 Catch-Up e CDC

Uma interrupção do Debezium pode criar *backlog upstream* no CDC, e não no Kafka.

Nesse caso, a recuperação deve considerar:

- última posição capturada da origem;
- histórico atual do CDC;
- retenção do CDC;
- taxa de *catch-up* do Debezium.

O Debezium deve realizar o *catch-up* antes que o histórico necessário do CDC expire.

Um *connector* operando normalmente, mas consumindo mais lentamente do que as alterações chegam à origem, ainda pode enfrentar risco crescente de recuperação.

### 16.30 Catch-Up entre Camadas

A recuperação pode se propagar por vários estágios assíncronos.

Por exemplo:

**Debezium**

→ realiza *catch-up* até a origem.

Enquanto isso:

**Bronze**

→ acumula *backlog* adicional no Kafka.

Em seguida:

**Silver**

→ acumula *backlog* da Bronze.

Depois:

**Gold**

→ aguarda uma Silver válida.

A plataforma pode, portanto, possuir múltiplas posições de *backlog* simultaneamente durante a recuperação.

Cada estágio deve expor seu próprio progresso.

### 16.31 Migração do Gargalo

Durante a recuperação, o gargalo pode migrar de um componente para outro.

Por exemplo:

1. Debezium é inicialmente o gargalo.
2. Debezium se recupera rapidamente.
3. O *backlog* do Kafka transfere a pressão para a Bronze.
4. Bronze realiza o *catch-up*.
5. Silver torna-se o estágio mais lento.
6. Gold posteriormente se torna o limite restante da recuperação.

A observabilidade deve ajudar a identificar o gargalo atual, em vez de presumir que a falha original continua sendo o fator limitante.

### 16.32 Catch-Up e Silver

Quando a Bronze continua operando durante uma indisponibilidade da Silver:

**Histórico da Bronze**

→ cresce normalmente.

Após a recuperação da Silver:

→ Silver processa o intervalo histórico governado pendente.

O *catch-up* da Silver deve preservar:

- ordenação da entrada, quando necessária;
- versão de processamento;
- continuidade do *checkpoint*;
- qualidade;
- linhagem *downstream*.

### 16.33 Catch-Up e Gold

A Gold pode acumular processamento pendente da Silver enquanto a Certified Gold permanece em uma versão anterior.

O *catch-up* da Gold pode envolver:

- processamento incremental;
- consolidação de lotes;
- *rebuild* da candidata;
- processamento histórico controlado.

Uma nova candidata deve ser criada somente a partir de um limite completo de processamento pretendido da Gold.

### 16.34 Catch-Up e Certificação

A certificação pode temporariamente se tornar o estágio mais lento mesmo depois que a transformação realizar o *catch-up*.

Por exemplo:

**Gold Atualizada**

→ reconciliação ainda em execução  
→ Certified Gold permanece na versão anterior.

O *catch-up*, portanto, não está concluído da perspectiva do consumidor até que o estado necessário de certificação e publicação também avance.

### 16.35 Catch-Up e Certified Gold

A Certified Gold pode permanecer disponível durante todo o *catch-up upstream*.

Isso cria uma distinção útil:

**Disponibilidade**

→ consumidor pode acessar dados reconhecidamente confiáveis.

**Atualidade**

→ consumidor aguarda um novo estado certificado.

A plataforma deve preservar a versão anterior reconhecidamente confiável, em vez de expor estado parcialmente recuperado.

### 16.36 Conclusão do Catch-Up

O *catch-up* deve ser considerado concluído somente quando o estágio afetado satisfizer suas condições definidas de recuperação.

Condições representativas podem incluir:

- *backlog* reduzido à faixa operacional esperada;
- idade do item pendente mais antigo dentro da faixa esperada;
- *checkpoints* avançando normalmente;
- nenhuma lacuna de processamento não resolvida;
- nenhuma falha persistente inesperada;
- estágios *downstream* avançando;
- atualidade restaurada;
- qualidade e reconciliação válidas;
- certificação atualizada, quando aplicável.

*Lag* zero do consumidor, isoladamente, pode não comprovar recuperação completa se o processamento derivado *downstream* continuar atrasado.

### 16.37 Faixa Operacional Normal

Uma plataforma não exige que o *backlog* permaneça matematicamente igual a zero a todo instante.

O processamento assíncrono normal pode conter uma pequena quantidade de trabalho pendente transitório.

A arquitetura deve distinguir:

**Backlog Operacional Normal**

→ trabalho transitório esperado dentro do comportamento validado de atualidade.

de:

**Backlog de Recuperação**

→ trabalho acumulado resultante de interrupção ou capacidade insuficiente de processamento.

O limite deve ser baseado no comportamento medido.

### 16.38 Falha do Catch-Up

O *catch-up* pode falhar se:

- a vazão de processamento permanecer abaixo da taxa de entrada;
- uma nova dependência falhar;
- ocorrer esgotamento de recursos;
- *poison records* bloquearem o progresso;
- o histórico retido expirar;
- defeitos de processamento aparecerem sob alto volume.

Uma falha durante o *catch-up* pode exigir:

- novo isolamento;
- aumento de capacidade;
- ajuste da política de novas tentativas;
- *replay*;
- *backfill*;
- *rebuild*;
- escalonamento da fonte de recuperação.

Um serviço que retorna repetidamente para `RUNNING`, mas nunca reduz o *backlog*, não alcançou recuperação de confiabilidade.

### 16.39 Cancelamento ou Pausa do Catch-Up

O *catch-up* pode ser intencionalmente pausado quando:

- a capacidade *downstream* se tornar insegura;
- a validação identificar processamento incorreto;
- a versão incorreta de processamento estiver ativa;
- outra ação de recuperação tiver prioridade maior;
- a continuidade da execução ameaçar a integridade da fonte de recuperação.

O estado de pausa deve preservar o progresso confirmado e o *backlog* restante.

A retomada deve continuar a partir de um limite seguro conhecido.

### 16.40 Prioridade do Catch-Up

Quando vários estágios ou produtos possuírem *backlog*, a prioridade de recuperação deve considerar:

- risco de expiração da retenção;
- risco de perda de dados;
- dependências de correção;
- impacto nos consumidores;
- impacto na atualidade;
- importância para o negócio;
- capacidade *downstream* compartilhada;
- relações de pré-requisito.

O produto mais visível não é automaticamente a primeira prioridade de recuperação.

Um *backlog* em uma camada inferior que ameace o único histórico retido de recuperação pode exigir ação mais rápida.

### 16.41 Catch-Up e RTO

O tempo de *catch-up* faz parte do tempo de recuperação.

Para uma interrupção de processamento:

**Tempo de Reinicialização do Serviço**

+

**Tempo de Catch-Up do Backlog**

+

**Tempo de Validação**

+

**Tempo de Certificação / Publicação, Quando Aplicável**

=

**Tempo de Recuperação Observado**

Medir apenas a reinicialização do serviço pode subestimar significativamente a recuperação real experimentada pelos consumidores analíticos.

### 16.42 Catch-Up e Recuperação de SLO

Após uma falha, a conformidade com o SLO pode permanecer degradada enquanto o *backlog* é processado.

As evidências da recuperação devem distinguir:

- momento em que o componente se tornou operacional;
- momento em que o *backlog* começou a diminuir;
- momento em que o processamento retornou à faixa operacional normal;
- momento em que a Certified Gold se tornou atual;
- momento em que os percentis de latência retornaram ao objetivo esperado.

Isso permite que a plataforma meça a confiabilidade ponta a ponta, e não apenas a reinicialização técnica.

### 16.43 Observabilidade do Catch-Up

A recuperação de *backlog* deve expor, quando aplicável:

- estágio;
- contagem do *backlog*;
- bytes do *backlog*;
- *lag*;
- idade do item pendente mais antigo;
- taxa de entrada;
- taxa de processamento;
- razão de *catch-up*;
- tempo estimado de recuperação, quando útil;
- desequilíbrio entre partições;
- atividade de novas tentativas;
- contagem de quarentena;
- margem de retenção;
- gargalo atual.

Nomes detalhados de métricas, *dashboards* e limites de alerta pertencem à **Observabilidade**.

### 16.44 Alertas do Catch-Up

Condições operacionalmente significativas podem incluir:

- *backlog* crescendo continuamente;
- razão de *catch-up* permanecendo menor ou igual a 1;
- idade do item pendente mais antigo aumentando;
- margem de retenção se aproximando de níveis inseguros;
- uma partição permanecendo materialmente atrasada;
- *backlog* migrando para outro estágio *downstream*;
- *catch-up* paralisado;
- atualidade da Certified Gold não se recuperando.

Os alertas devem distinguir o comportamento temporário esperado da recuperação de um processo de recuperação que deixou de convergir.

### 16.45 Validação do Catch-Up

A validação da recuperação de *backlog* deve confirmar, quando aplicável:

- limite correto de reinicialização;
- nenhuma entrada pendente ignorada;
- *backlog* diminuindo;
- taxa de processamento excedendo a taxa de entrada durante o *catch-up*, quando necessário;
- ordenação permanecendo válida;
- ausência de efeitos de negócio duplicados;
- progressão correta do *checkpoint*;
- falhas persistentes tratadas explicitamente;
- retenção permanecendo suficiente;
- estágios *downstream* se recuperando;
- qualidade e reconciliação aprovadas;
- atualidade da Certified Gold recuperada.

O objetivo da recuperação é a convergência para um estado operacional governado e correto.

### 16.46 Evidências do Catch-Up

Evidências representativas devem preservar:

- duração da falha;
- *backlog* no início da recuperação;
- idade do item pendente mais antigo;
- taxa de entrada;
- taxa de processamento;
- razão de *catch-up*;
- comportamento por partição, quando relevante;
- estado das novas tentativas e da quarentena;
- margem de retenção;
- tendência do *backlog*;
- mudanças de gargalo;
- momento em que o *backlog* retornou à faixa normal;
- momento em que a atualidade foi recuperada;
- estado final de qualidade e certificação.

Essas evidências fornecem entrada direta para futuras decisões de capacidade, SLO, RTO e escalabilidade.

### 16.47 Cenários de Teste do Catch-Up

A Versão 1 deve validar cenários representativos, como:

**Teste de Catch-Up 1 — Indisponibilidade do Consumidor**

→ interromper o consumo da Bronze por um intervalo controlado  
→ permitir o acúmulo de *backlog* no Kafka  
→ reinicializar o consumidor  
→ medir a redução do *backlog* e o tempo até a operação normal.

**Teste de Catch-Up 2 — Recuperação em Pico**

→ acumular *backlog* controlado  
→ recuperar enquanto novos eventos chegam em uma taxa elevada  
→ demonstrar se a capacidade de processamento converge.

**Teste de Catch-Up 3 — Desequilíbrio entre Partições**

→ criar uma carga de trabalho intencionalmente desigual  
→ observar a recuperação específica por partição  
→ verificar que métricas agregadas não ocultem a partição lenta.

**Teste de Catch-Up 4 — Recuperação entre Múltiplas Camadas**

→ interromper um estágio *downstream* enquanto a ingestão *upstream* continua  
→ restaurar o estágio  
→ observar a migração do *backlog* pelos estágios subsequentes até que a atualidade da Certified Gold seja restaurada.

A carga de trabalho exata deve permanecer limitada pelo ambiente de laboratório da Versão 1.

### 16.48 Garantias de Recuperação de Backlog e Catch-Up

O modelo de recuperação de *backlog* da Atlas Engineering deve preservar as seguintes garantias:

1. o *backlog* permanece distinguível de quarentena, dados ausentes e estado inválido;
2. o *catch-up* começa a partir do progresso confirmado do processamento;
3. trabalho pendente não é ignorado apenas para alcançar a entrada mais recente;
4. o *catch-up* permanece distinto de *replay* e reprocessamento;
5. o *backlog* é medido tanto por volume quanto por idade, quando útil;
6. a tendência do *backlog* distingue crescimento, estabilidade e recuperação;
7. o *backlog* só pode diminuir quando a capacidade efetiva de processamento excede a carga de entrada;
8. a capacidade de *catch-up* é medida, e não presumida;
9. o tempo estimado de *catch-up* não substitui o tempo observado de recuperação;
10. a recuperação de *backlog* preserva ordenação e correção do processamento;
11. o paralelismo é aumentado somente quando a semântica do processamento e a capacidade *downstream* permitirem;
12. o desequilíbrio entre partições permanece visível quando relevante;
13. o *catch-up* não sobrecarrega dependências *downstream*;
14. a recuperação prioriza a taxa segura mais rápida, e não a maior vazão descontrolada possível;
15. o planejamento de capacidade inclui folga para recuperação, e não apenas carga de trabalho em estado estável;
16. a carga de pico pode reduzir a capacidade de *catch-up* e é considerada na validação;
17. novas tentativas persistentes não consomem capacidade ilimitada de *catch-up*;
18. quarentena não resolvida permanece distinguível de *backlog* comum;
19. a recuperação de *backlog* permanece limitada pela retenção *upstream*;
20. a redução da margem da janela de recuperação aumenta a urgência operacional;
21. o *catch-up* do CDC e do Kafka é avaliado em relação às respectivas janelas de retenção;
22. camadas assíncronas mantêm estados independentes de *backlog* e progresso;
23. os gargalos de recuperação podem migrar entre estágios;
24. o *catch-up* da Gold e da certificação permanece distinto da recuperação do processamento *upstream*;
25. a Certified Gold protege a disponibilidade analítica reconhecidamente confiável durante o *catch-up*;
26. a conclusão do *catch-up* exige mais do que *lag* zero em um único estágio de processamento;
27. *backlog* transitório normal permanece distinguível de *backlog* de recuperação;
28. um serviço em execução que não consegue reduzir o *backlog* não é considerado totalmente recuperado;
29. a pausa ou o cancelamento do *catch-up* preserva progresso seguro;
30. a prioridade da recuperação reflete risco de perda de dados, dependências e impacto nos consumidores;
31. o tempo de *catch-up* do *backlog* contribui para o RTO efetivamente observado;
32. a recuperação do SLO é medida separadamente da reinicialização do componente;
33. o estado da recuperação de *backlog* é observável e acionável;
34. o *catch-up* é considerado demonstrado somente após validação controlada e evidências.

---

## 17. Disponibilidade da Certified Gold e Rollback

A Certified Gold é o limite analítico governado e visível aos consumidores da Atlas Engineering.

Seu objetivo de confiabilidade é preservar um estado analítico reconhecidamente confiável enquanto novas versões candidatas são processadas, validadas, certificadas e publicadas.

O modelo orientador é:

**Versão Certificada Atual → Construir Nova Candidata → Validar → Certificar → Publicar Atomicamente**

Se a nova candidata ou a publicação falhar:

**Preservar a Última Versão Certificada Reconhecidamente Confiável**

A Certified Gold, portanto, protege os consumidores contra estados analíticos incompletos, inválidos ou parcialmente publicados.

### 17.1 Certified Gold como Limite de Disponibilidade

A Certified Gold fornece disponibilidade analítica independentemente da saúde imediata de cada estágio de processamento *upstream*.

Por exemplo:

**Falha no Processamento da Silver**

→ nenhuma nova candidata Gold.

**Certified Gold**

→ versão anterior validada permanece disponível.

Isso permite que a plataforma distinga:

**Disponibilidade do Processamento Upstream**

de:

**Disponibilidade Analítica Governada**

A camada voltada aos consumidores não deve ficar indisponível apenas porque uma versão analítica mais recente ainda não pode ser produzida.

### 17.2 Versão Certificada Reconhecidamente Confiável

Uma versão reconhecidamente confiável da Certified Gold é um estado analítico publicado que satisfez os requisitos aplicáveis de:

- processamento;
- validação da qualidade;
- reconciliação;
- linhagem;
- critérios de certificação;
- controles de publicação.

A versão permanece visível aos consumidores até que uma candidata mais recente atravesse com sucesso todo o limite de publicação ou até que a própria versão seja explicitamente invalidada.

### 17.3 Certificação Não Garante Confiança Permanente

O fato de uma versão estar certificada significa que ela satisfez os controles aplicáveis no momento em que foi publicada.

Evidências posteriores podem invalidar essa confiança.

Possíveis causas incluem:

- defeito de transformação descoberto;
- regra de negócio incorreta;
- defeito de reconciliação;
- problema nos dados da origem;
- incidente de segurança;
- problema de privacidade;
- interpretação histórica incorreta.

Um rótulo de certificação não deve, portanto, impedir uma invalidação posterior quando as evidências demonstrarem que o estado publicado deixou de ser confiável.

### 17.4 Isolamento da Candidata

Um novo estado Gold deve permanecer isolado dos consumidores analíticos comuns até que a certificação seja bem-sucedida.

Uma candidata pode existir fisicamente enquanto está:

- incompleta;
- em validação;
- com falha;
- aguardando reconciliação;
- aguardando publicação.

Os consumidores não devem interpretar existência física como certificação.

A arquitetura deve preservar uma distinção explícita entre:

**Candidata Gold**

e:

**Certified Gold**.

### 17.5 Falha da Candidata

Uma candidata pode falhar por causa de:

- falha de processamento;
- entrada incompleta;
- falha de qualidade;
- falha de reconciliação;
- falha de linhagem;
- falha em regra de certificação;
- versão incorreta de processamento.

O comportamento esperado é:

**Candidata Falha**

→ não publicar  
→ preservar evidências da falha  
→ investigar  
→ remediar  
→ executar *rebuild* ou reprocessamento conforme necessário.

A versão certificada atual permanece inalterada, a menos que a falha demonstre que ela também é inválida.

### 17.6 Degradação da Atualidade

Quando uma nova candidata não pode ser certificada, a versão atual da Certified Gold pode ficar progressivamente desatualizada.

Isso é uma:

**Degradação da Atualidade**

e não automaticamente uma:

**Falha de Correção**

ou:

**Falha de Disponibilidade**.

A plataforma deve tornar esse estado observável.

Um conjunto de dados desatualizado, porém confiável, pode ser preferível a um conjunto mais recente não validado.

### 17.7 Desatualização Visível aos Consumidores

A Certified Gold deve expor metadados suficientes para determinar a idade do estado publicado.

Informações relevantes podem incluir:

- versão certificada;
- limite de processamento da origem;
- maior tempo de negócio ou de *commit* da origem;
- momento da certificação;
- momento da publicação;
- idade atual da atualidade.

Consumidores e operadores devem conseguir distinguir:

**Dados Disponíveis**

de:

**Dados Atuais**.

### 17.8 Elegibilidade para Publicação

Uma candidata Gold torna-se elegível para publicação somente depois que todos os requisitos bloqueantes forem aprovados.

Eles podem incluir:

- conclusão do processamento;
- regras de qualidade obrigatórias;
- reconciliação;
- atualidade;
- completude;
- linhagem;
- metadados obrigatórios;
- critérios de certificação.

A geração bem-sucedida de linhas ou tabelas, isoladamente, não estabelece elegibilidade para publicação.

### 17.9 Publicação Atômica

A publicação deve evitar expor estado parcial de transição.

O padrão orientador é:

**Preparar → Validar → Promover Atomicamente**

Os consumidores devem observar:

**Versão Certificada Anterior**

ou:

**Nova Versão Certificada**

mas não uma mistura descontrolada de ambas.

O mecanismo atômico exato depende da tecnologia de implementação.

### 17.10 Metadados de Publicação

O estado da publicação deve permanecer identificável por meio de metadados.

Informações relevantes podem incluir:

- versão da candidata;
- versão certificada;
- estado da publicação;
- *timestamp* da publicação;
- versão de processamento;
- resultado da certificação;
- versão anterior;
- elegibilidade para *rollback*.

Os metadados de publicação fazem parte da recuperação porque identificam qual estado analítico atualmente é autoritativo para consumo.

### 17.11 Falha de Publicação

Uma falha de publicação ocorre quando uma candidata foi aprovada na certificação, mas não consegue tornar-se visível aos consumidores com segurança.

Possíveis causas incluem:

- falha do SQL Server;
- falha de permissão;
- falha no mecanismo de troca atômica;
- falha na atualização dos metadados;
- falha de dependência;
- falha de transação.

O resultado preferencial é:

**Publicação Falha**

→ estado certificado anterior permanece visível  
→ candidata permanece não publicada.

Um mecanismo de publicação que deixa os consumidores em um estado misto indefinido não é considerado confiável.

### 17.12 Falha Parcial de Publicação

Uma publicação parcialmente concluída é uma condição de alto risco porque os consumidores podem observar estado inconsistente.

A recuperação deve determinar:

- quais operações de publicação foram concluídas;
- qual versão está efetivamente visível;
- se os metadados correspondem ao estado físico;
- se consultas dos consumidores podem observar versões misturadas.

O primeiro objetivo é restaurar um único estado claramente reconhecidamente confiável e visível aos consumidores.

Qualquer nova publicação deve aguardar até que esse estado esteja estabelecido.

### 17.13 Limite Transacional da Publicação

Quando suportado, as operações de publicação devem utilizar uma transação ou mecanismo equivalente de troca atômica que minimize estados intermediários visíveis aos consumidores.

O limite de publicação pode envolver:

- troca de *view*;
- troca de *synonym*;
- promoção de *schema*;
- *partition switch*;
- seleção de versão controlada por metadados;
- renomeação ou substituição coordenada transacionalmente.

A arquitetura define o requisito de atomicidade, e não um único mecanismo obrigatório do SQL Server.

### 17.14 Rollback

*Rollback* restaura uma versão anteriormente reconhecidamente confiável da Certified Gold como o estado ativo visível aos consumidores.

O *rollback* pode ser necessário quando:

- um estado recém-publicado é posteriormente considerado incorreto;
- a validação pós-publicação falha;
- o comportamento dos consumidores revela um defeito inesperado;
- os metadados da publicação tornam-se inconsistentes;
- preocupações de segurança ou governança invalidam a nova versão.

*Rollback* é um mecanismo de recuperação da publicação analítica.

Ele não corrige automaticamente o defeito de processamento que tornou o *rollback* necessário.

### 17.15 Fonte do Rollback

O *rollback* exige uma versão anterior retida da Certified Gold ou outro estado publicado equivalente e reconhecidamente confiável.

A plataforma deve, portanto, preservar estado certificado histórico suficiente de acordo com seus requisitos de *rollback* e retenção.

Uma afirmação de capacidade de *rollback* não é sustentada se a versão anterior não puder efetivamente ser restaurada ou reativada.

### 17.16 Elegibilidade para Rollback

Uma versão anterior pode ser utilizada para *rollback* somente quando permanecer confiável.

Uma versão não deve ser selecionada apenas por ser mais antiga.

A seleção deve considerar:

- estado da certificação;
- defeitos descobertos posteriormente;
- correção dos dados;
- estado de segurança;
- estado de privacidade;
- dependências retidas;
- compatibilidade com os consumidores.

O *rollback* deve selecionar a última versão apropriada reconhecidamente confiável.

### 17.17 Rollback versus Rebuild

*Rollback* e *rebuild* resolvem problemas diferentes.

**Rollback**

→ restaurar rapidamente um estado anterior visível aos consumidores.

**Rebuild**

→ reconstruir estado derivado corrigido a partir de um limite *upstream* confiável.

Uma sequência comum de recuperação é:

**Nova Versão Inválida**

→ *rollback* para a Certified Gold anterior  
→ corrigir lógica *upstream*  
→ executar *rebuild* da nova candidata  
→ validar  
→ certificar  
→ publicar versão corrigida.

O *rollback* restaura a disponibilidade enquanto o *rebuild* restaura a correção atual.

### 17.18 Rollback versus Restauração de Backup

O *rollback* normalmente utiliza versões analíticas retidas já disponíveis dentro da arquitetura de publicação.

A restauração de *backup* reconstrói infraestrutura persistida ou estado de dados a partir de armazenamento histórico protegido.

Utilizar um *backup* de banco de dados apenas para reverter uma publicação analítica pode ser mais abrangente do que o necessário quando uma versão certificada anterior válida já existe.

O menor escopo seguro de recuperação deve ser preferido.

### 17.19 Rollback e Atualidade

O *rollback* pode restaurar correção e disponibilidade enquanto aumenta a desatualização.

Por exemplo:

**Certified Gold V10**

→ incorreta.

*Rollback*:

**Certified Gold V9**

→ confiável, porém mais antiga.

O resultado pode, portanto, ser:

**Correção Restaurada**

+

**Disponibilidade Restaurada**

+

**Atualidade Degradada**

Essas dimensões de recuperação devem permanecer distinguíveis.

### 17.20 Rollback e Compatibilidade com os Consumidores

Um *rollback* deve considerar se os consumidores permanecem compatíveis com o contrato certificado anterior.

Se uma nova publicação alterou:

- *schema*;
- definição de medida;
- disponibilidade de campos;
- contrato semântico;

então reverter os dados sem considerar a compatibilidade dos consumidores pode criar outra falha.

A compatibilidade retroativa deve, portanto, ser considerada na estratégia de publicação.

### 17.21 Retenção de Versões para Rollback

A retenção da Certified Gold deve preservar versões anteriores suficientes para atender à estratégia definida de *rollback*.

A retenção deve considerar:

- janela de *rollback*;
- custo de armazenamento;
- requisitos de auditoria;
- investigação;
- reprodutibilidade;
- compatibilidade com os consumidores;
- requisitos de privacidade e retenção.

Não é necessário reter indefinidamente todas as versões certificadas, a menos que um requisito governado o justifique.

### 17.22 Imutabilidade da Versão Publicada

Uma versão certificada publicada deve permanecer estável o suficiente para oferecer suporte a:

- auditoria;
- comparação;
- *rollback*;
- reprodutibilidade.

Quando possível, correções devem produzir uma nova versão, em vez de alterar silenciosamente a versão certificada histórica.

Isso preserva a capacidade de explicar o que os consumidores realmente visualizaram em determinado momento.

### 17.23 Histórico de Certificação

A plataforma deve preservar histórico suficiente para determinar:

- quais candidatas foram criadas;
- quais falharam;
- quais foram aprovadas;
- quais foram publicadas;
- quais passaram por *rollback*;
- quais foram invalidadas posteriormente.

O histórico de certificação oferece suporte a:

- recuperação;
- auditabilidade;
- governança;
- análise de incidentes;
- evidências.

### 17.24 Histórico de Publicação

O histórico de publicação deve identificar a sequência de versões visíveis aos consumidores.

Conceitualmente:

**V1 Publicada**

→ **V2 Publicada**

→ **Rollback da V2**

→ **V1 Reativada**

→ **V3 Publicada**

Esse histórico deve permanecer atribuível a:

- momento;
- execução;
- certificação;
- motivo da recuperação;
- processo ou identidade responsável.

### 17.25 Validação Pós-Publicação

Algumas validações podem continuar após a publicação quando a implementação oferecer suporte.

Verificações pós-publicação podem detectar:

- problemas em consultas dos consumidores;
- comportamento inesperado de performance;
- problemas semânticos *downstream*;
- descobertas tardias de reconciliação;
- anomalias de observabilidade.

A validação pós-publicação não deve substituir os controles bloqueantes exigidos antes da certificação.

Ela fornece garantia adicional após a transição governada.

### 17.26 Defeito Pós-Publicação

Se um defeito for descoberto após a publicação, a plataforma deve classificar:

- impacto na correção;
- escopo afetado;
- impacto nos consumidores;
- intervalo histórico;
- se o *rollback* é seguro;
- se a versão anterior permanece compatível;
- se uma reconstrução *upstream* é necessária.

A resposta pode incluir:

- *rollback*;
- notificação aos consumidores por meio do processo operacional apropriado;
- reprocessamento;
- *rebuild*;
- nova certificação;
- publicação corretiva.

### 17.27 Incidente com Dados Publicados

Um incidente com dados publicados ocorre quando o estado analítico visível aos consumidores é suspeito ou comprovadamente incorreto, incompleto ou de outra forma inválido.

O objetivo imediato de confiabilidade é impedir a exposição contínua de estado não confiável.

Possíveis ações incluem:

- *rollback*;
- restrição temporária de acesso;
- congelamento da publicação;
- restauração de uma versão anterior;
- investigação.

A resposta selecionada depende de ainda existir ou não um estado reconhecidamente confiável para os consumidores.

### 17.28 Nenhuma Versão Certified Gold Reconhecidamente Confiável

Uma condição mais grave existe quando nenhuma versão disponível da Certified Gold pode ser considerada confiável.

Possíveis causas incluem:

- defeito afetando várias versões retidas;
- interpretação histórica invalidando todas as versões retidas;
- corrupção de armazenamento;
- incidente de segurança ou privacidade;
- retenção insuficiente de versões.

Nesse cenário, a plataforma pode precisar:

- suspender o produto afetado;
- restringir o acesso dos consumidores;
- executar *rebuild* a partir de um limite *upstream* confiável;
- recertificar antes de restaurar a disponibilidade.

Disponibilizar dados reconhecidamente inválidos apenas para preservar o tempo de atividade não é aceitável.

### 17.29 Disponibilidade no Nível do Produto

A disponibilidade da Certified Gold deve ser avaliada no nível do produto de dados.

Um produto pode estar:

- atual;
- desatualizado;
- em *rollback*;
- indisponível;
- em reconstrução;

enquanto outro permanece totalmente saudável.

A plataforma não deve representar todos os dados voltados aos consumidores como um único estado binário global de disponibilidade.

### 17.30 Estado de Recuperação no Nível do Produto

Estados representativos de recuperação do produto podem incluir:

**CURRENT**

→ o estado certificado pretendido mais recente está disponível.

**STALE**

→ um estado certificado reconhecidamente confiável está disponível, mas a meta de atualidade não é atendida.

**ROLLBACK_ACTIVE**

→ uma versão anterior reconhecidamente confiável foi restaurada intencionalmente.

**CERTIFICATION_BLOCKED**

→ uma candidata existe, mas não pode ser publicada.

**UNAVAILABLE**

→ nenhum estado aceitável visível aos consumidores existe.

**RECOVERING**

→ uma candidata corrigida está sendo reconstruída ou validada.

A implementação exata pode utilizar nomes de estados diferentes.

O requisito arquitetural é preservar distinções significativas.

### 17.31 Certified Gold e Catch-Up Upstream

A Certified Gold pode permanecer desatualizada enquanto as camadas *upstream* realizam *catch-up*.

O produto visível aos consumidores deve avançar somente depois que o limite de processamento pretendido tiver:

- alcançado a completude necessária;
- sido aprovado na qualidade;
- sido reconciliado;
- satisfeito a certificação.

Publicar cada estado intermediário parcialmente recuperado apenas para reduzir o *lag* aparente de atualidade pode enfraquecer o limite de certificação.

### 17.32 Frequência de Publicação Durante a Recuperação

Durante o *catch-up*, a plataforma pode optar por publicar:

- somente após a recuperação completa;
- em limites intermediários governados;
- de acordo com intervalos normais agendados de certificação.

O comportamento correto depende da semântica do produto e das regras de certificação.

Qualquer publicação intermediária ainda deve representar um estado certificado completo para o limite declarado.

### 17.33 Roll-Forward

Após o *rollback*, a recuperação preferencial de longo prazo geralmente é um *roll-forward* por meio de uma candidata corrigida.

Conceitualmente:

**Rollback para V5**

→ corrigir defeito *upstream*  
→ executar *rebuild* ou reprocessamento  
→ produzir candidata V7  
→ validar  
→ certificar  
→ publicar V7.

O objetivo não é permanecer indefinidamente na versão mais antiga.

O *rollback* fornece tempo de recuperação enquanto um estado atual corrigido é produzido.

### 17.34 Validação do Roll-Forward

Uma versão corrigida de *roll-forward* deve atender aos mesmos requisitos de certificação de uma publicação normal.

Validações adicionais podem comparar:

- versão de *rollback*;
- versão invalidada;
- versão corrigida;
- alterações históricas esperadas;
- medidas visíveis aos consumidores.

A nova versão não deve ser considerada confiável apenas porque foi produzida após a remediação.

### 17.35 Rollback e Linhagem

A linhagem deve preservar:

- versão publicada invalidada;
- destino do *rollback*;
- motivo do *rollback*;
- versões de processamento afetadas;
- execução da recuperação;
- candidata corrigida;
- versão final substituta.

Isso permite que um revisor compreenda tanto o histórico visível aos consumidores quanto o caminho técnico da recuperação.

### 17.36 Rollback e Metadados

Os metadados devem identificar, quando aplicável:

- versão certificada ativa;
- versão anterior;
- versão da candidata;
- versão invalidada;
- estado do *rollback*;
- momento do *rollback*;
- momento da publicação;
- versão de processamento;
- estado da certificação;
- motivo da recuperação.

Os metadados devem corresponder ao estado físico visível aos consumidores.

### 17.37 Rollback e Segurança

O *rollback* deve preservar os requisitos atuais de segurança e privacidade.

Uma versão analítica anterior não deve ser reativada se contiver estado que a governança atual invalidou explicitamente.

Exemplos incluem:

- dados restritos que não são mais autorizados para o produto;
- representação inválida do ponto de vista de privacidade;
- acesso revogado de consumidores;
- exposição reconhecidamente sensível do ponto de vista de segurança.

A correção histórica não se sobrepõe à governança posterior.

### 17.38 Rollback e Retenção

A capacidade de *rollback* existe somente enquanto a versão anterior necessária permanecer retida e utilizável.

A política de retenção deve, portanto, estar alinhada a:

- expectativa de *rollback*;
- criticidade do produto;
- frequência de publicação;
- custo de armazenamento;
- objetivos de recuperação.

A plataforma não deve afirmar uma janela de *rollback* maior do que o histórico certificado retido suporta.

### 17.39 Rollback e RPO

O *rollback* pode mover intencionalmente para trás o estado analítico visível aos consumidores.

Por exemplo:

**V10**

→ publicada às 14:00  
→ invalidada.

*Rollback*:

**V9**

→ publicada às 13:00.

O ponto efetivo de recuperação analítica pode, portanto, tornar-se mais antigo do que o estado mais recente processado da origem.

A interpretação do RPO deve distinguir:

- preservação dos dados *upstream*;
- ponto de recuperação certificado visível aos consumidores.

### 17.40 Rollback e RTO

O *rollback* pode oferecer recuperação mais rápida da disponibilidade para os consumidores do que um *rebuild* completo.

O tempo observado de recuperação pode incluir:

- detecção do defeito;
- decisão;
- execução do *rollback*;
- validação;
- restauração para os consumidores.

A reconstrução posterior por *roll-forward* constitui um intervalo de recuperação separado.

Essa distinção pode ser útil ao avaliar objetivos de disponibilidade analítica.

### 17.41 Congelamento da Publicação

Um congelamento da publicação impede temporariamente que novas candidatas se tornem visíveis aos consumidores enquanto uma investigação ou recuperação estiver em andamento.

Ele pode ser apropriado quando:

- candidatas estão falhando repetidamente;
- a lógica de certificação estiver sob suspeita;
- o mecanismo de publicação estiver instável;
- a correção visível aos consumidores estiver incerta.

A ingestão e o processamento *upstream* podem continuar quando for seguro.

O congelamento da publicação protege o limite do consumidor sem interromper desnecessariamente todo o *pipeline*.

### 17.42 Recuperação do Congelamento da Publicação

Antes de remover um congelamento da publicação, a validação deve confirmar:

- causa raiz compreendida ou controlada;
- mecanismo de publicação saudável;
- controles de certificação confiáveis;
- estado da candidata válido;
- versão atual visível aos consumidores compreendida;
- estado do *rollback* resolvido;
- linhagem e metadados consistentes.

O congelamento não deve ser removido apenas porque um componente foi reinicializado.

### 17.43 Recuperação do Consumidor

A recuperação do consumidor está concluída quando o consumidor analítico afetado consegue acessar um estado aceitável e governado da Certified Gold.

Dependendo do incidente, esse estado pode ser:

- versão certificada atual;
- versão anterior reconhecidamente confiável sob *rollback*;
- nova versão corrigida e publicada.

A recuperação do consumidor não significa necessariamente que o processamento *upstream* tenha realizado completamente o *catch-up*.

O estado da recuperação deve, portanto, permanecer visível.

### 17.44 Validação da Disponibilidade da Certified Gold

A validação deve confirmar, quando aplicável:

- versão certificada ativa atual;
- versão anterior reconhecidamente confiável;
- isolamento da candidata;
- estado da certificação;
- atomicidade da publicação;
- visibilidade para os consumidores;
- atualidade;
- comportamento do *rollback*;
- consistência dos metadados;
- linhagem;
- compatibilidade com os consumidores.

Um comando de publicação bem-sucedido, isoladamente, não comprova disponibilidade confiável da Certified Gold.

### 17.45 Validação do Rollback

A validação do *rollback* deve confirmar:

- destino do *rollback* permanece confiável;
- destino está completo;
- transição da publicação é atômica;
- versão inválida deixa de estar visível aos consumidores;
- consumidores conseguem acessar a versão de *rollback*;
- metadados identificam corretamente a versão ativa;
- impacto na atualidade é conhecido;
- remediação *upstream* pode continuar independentemente.

### 17.46 Evidências da Certified Gold

Evidências representativas devem preservar:

- produto;
- versão certificada anterior;
- versão candidata;
- resultado da certificação;
- tentativa de publicação;
- resultado da publicação;
- versão ativa;
- atualidade;
- decisão de *rollback*;
- destino do *rollback*;
- momento do *rollback*;
- resultado visível aos consumidores;
- candidata de *roll-forward*;
- versão final substituta;
- resultados de qualidade e reconciliação;
- tempo decorrido de recuperação para os consumidores.

Essas evidências demonstram o comportamento do limite analítico governado final durante a falha e a recuperação.

### 17.47 Cenários de Teste da Certified Gold

A Versão 1 deve validar cenários representativos, como:

**Teste da Certified Gold 1 — Falha da Candidata**

→ criar uma candidata Gold controlada que falha em uma validação bloqueante  
→ verificar que ela não é publicada  
→ verificar que a Certified Gold anterior permanece disponível.

**Teste da Certified Gold 2 — Falha de Publicação**

→ simular uma interrupção controlada da publicação  
→ verificar que os consumidores não observam estado misto  
→ restaurar uma única versão ativa reconhecidamente confiável.

**Teste da Certified Gold 3 — Rollback**

→ publicar uma nova versão certificada controlada  
→ invalidá-la intencionalmente por meio de um cenário de teste  
→ executar *rollback* para a versão anterior reconhecidamente confiável  
→ validar a visibilidade para os consumidores.

**Teste da Certified Gold 4 — Roll-Forward**

→ após o *rollback*, corrigir o defeito controlado  
→ executar *rebuild* de uma nova candidata  
→ certificar  
→ publicar  
→ verificar que o estado atual corrigido substitui a versão de *rollback*.

**Teste da Certified Gold 5 — Desatualizada, mas Disponível**

→ interromper o processamento *upstream*  
→ verificar que a Certified Gold permanece disponível  
→ observar o aumento da idade da atualidade  
→ recuperar o processamento *upstream*  
→ verificar que a atualidade eventualmente retorna.

Os cenários exatos devem preservar a integridade do laboratório da Versão 1.

### 17.48 Garantias de Disponibilidade e Rollback da Certified Gold

O modelo de confiabilidade da Certified Gold da Atlas Engineering deve preservar as seguintes garantias:

1. a Certified Gold é o limite governado de disponibilidade analítica visível aos consumidores;
2. falha de processamento *upstream* não remove automaticamente uma versão certificada confiável;
3. o estado da candidata permanece isolado até que a certificação necessária seja bem-sucedida;
4. a falha da candidata não afeta automaticamente a versão certificada anterior;
5. estado desatualizado, porém confiável, permanece distinguível de estado incorreto ou indisponível;
6. os consumidores conseguem determinar o contexto de atualidade do estado certificado ativo;
7. a elegibilidade para publicação exige todos os controles bloqueantes aplicáveis;
8. a publicação é atômica da perspectiva do consumidor;
9. os metadados de publicação identificam a versão governada ativa;
10. a falha de publicação preserva um estado claramente reconhecidamente confiável e visível aos consumidores quando possível;
11. publicação parcial não permanece como estado misto aceito;
12. o *rollback* restaura uma versão certificada anterior reconhecidamente confiável;
13. o *rollback* permanece distinto de *rebuild* e restauração de *backup*;
14. o destino do *rollback* é selecionado de acordo com confiança, e não apenas idade;
15. o *rollback* pode restaurar correção e disponibilidade enquanto a atualidade permanece degradada;
16. a compatibilidade com os consumidores é considerada antes do *rollback*;
17. a retenção das versões certificadas sustenta a estratégia real de *rollback*;
18. versões históricas publicadas permanecem suficientemente estáveis para auditoria, comparação e *rollback*;
19. o histórico de certificação e publicação permanece rastreável;
20. defeitos pós-publicação podem invalidar estado anteriormente certificado;
21. incidentes com dados publicados priorizam a remoção de estado não confiável visível aos consumidores;
22. se nenhuma versão certificada reconhecidamente confiável existir, o produto afetado pode ficar indisponível em vez de disponibilizar dados reconhecidamente inválidos;
23. disponibilidade analítica e estado da recuperação permanecem específicos por produto;
24. o *catch-up upstream* não ignora a certificação;
25. publicação intermediária durante a recuperação permanece sujeita à certificação completa para o limite declarado;
26. o *rollback* é seguido por *roll-forward* corrigido quando o estado atual precisar ser restaurado;
27. candidatas de *roll-forward* recebem validação completa;
28. *rollback* e *roll-forward* permanecem representados na linhagem e nos metadados;
29. o *rollback* preserva os requisitos atuais de segurança, privacidade e governança;
30. a capacidade de *rollback* permanece limitada pelo histórico certificado retido;
31. o ponto de recuperação visível aos consumidores permanece distinguível dos dados preservados *upstream*;
32. o *rollback* pode oferecer disponibilidade analítica mais rápida do que uma reconstrução completa;
33. o congelamento da publicação pode proteger os consumidores enquanto a investigação *upstream* continua;
34. a recuperação dos consumidores permanece distinguível do *catch-up upstream* completo;
35. o comportamento de disponibilidade e *rollback* da Certified Gold é considerado demonstrado somente após validação controlada e evidências.

---

## 18. Recuperação e Versões Históricas

A recuperação da Atlas Engineering depende não apenas da retenção de dados históricos, mas também da retenção de contexto histórico de interpretação suficiente para processar esses dados corretamente.

Um evento retido, registro da Bronze, estado da Silver ou versão da Gold não é completamente recuperável se a plataforma não souber mais como esse estado histórico era estruturado, interpretado, transformado, validado ou publicado.

O princípio orientador é:

**Dados Históricos + Contexto Histórico Aplicável = Estado Histórico Recuperável**

O contexto histórico pode incluir:

- *schema* da origem;
- contrato de eventos;
- definição de processamento;
- estado dos dados de referência;
- regras de qualidade;
- regras de reconciliação;
- semântica dimensional;
- metadados de certificação;
- metadados de publicação.

Retenção de dados sem capacidade de interpretação fornece apenas capacidade parcial de recuperação.

### 18.1 Contexto de Versão Histórica

O processamento histórico pode abranger múltiplas versões da plataforma.

Um registro histórico pode ter sido produzido sob uma versão diferente de:

- *schema* da origem;
- *schema* do evento;
- versão de contrato;
- versão de transformação;
- definição dimensional;
- versão dos dados de referência;
- regra de qualidade;
- regra de certificação.

A recuperação deve identificar o contexto aplicável ao escopo histórico que está sendo reconstruído.

### 18.2 Identidade de Versão

Artefatos da plataforma sensíveis a versão devem possuir uma versão identificável ou referência imutável equivalente quando necessário para recuperação.

A identidade de versão pode se aplicar a:

- contratos de eventos;
- código de processamento;
- configuração;
- definições de *schema*;
- modelos de dados;
- regras de qualidade;
- lógica de reconciliação;
- versões publicadas da Gold.

O mecanismo de implementação pode variar.

O requisito arquitetural é que a definição utilizada para produzir um resultado histórico recuperável possa ser identificada.

### 18.3 Contratos Históricos de Eventos

Eventos históricos retidos podem utilizar versões de contrato diferentes do contrato atual do produtor.

O *replay* exige que os consumidores interpretem o contrato associado a cada evento histórico.

A plataforma deve, portanto, preservar:

- identidade do contrato;
- versão do contrato;
- definição de *schema* necessária;
- informações de compatibilidade, quando aplicável.

A capacidade de *replay* histórico é enfraquecida se eventos antigos retidos não puderem mais ser interpretados.

### 18.4 Evolução de Contrato

A evolução de contratos deve considerar tanto o processamento futuro quanto a recuperação histórica.

Uma nova versão de contrato pode ser:

- compatível com versões anteriores;
- compatível com versões posteriores, quando suportado;
- totalmente compatível, quando necessário;
- intencionalmente incompatível.

Uma alteração incompatível de contrato pode exigir:

- nova lógica de consumidor;
- migração explícita;
- nova versão de processamento;
- adaptador histórico;
- política limitada de suporte.

A plataforma não deve presumir que o código atual dos consumidores conseguirá interpretar indefinidamente todos os contratos históricos.

### 18.5 Papel Histórico do Apicurio Registry

O Apicurio Registry oferece suporte à preservação e identificação de versões governadas de contratos de eventos.

Para recuperação, o Registry deve reter as definições necessárias para interpretar eventos históricos que permaneçam dentro da janela de recuperação suportada.

Excluir uma definição antiga de contrato enquanto os eventos retidos correspondentes ainda forem recuperáveis criaria uma lacuna evitável de interpretação.

A retenção do Registry e a estratégia de retenção de eventos devem, portanto, permanecer alinhadas.

### 18.6 Evolução do Schema da Origem

O AtlasCommerce pode evoluir ao longo do tempo.

As alterações podem incluir:

- novas colunas;
- *constraints* alteradas;
- novos valores de referência;
- novas tabelas;
- atributos descontinuados;
- reformulação estrutural.

A recuperação histórica deve determinar se a representação da origem aplicável ao intervalo histórico difere do modelo atual da origem.

O *schema* atual da origem não deve ser automaticamente projetado retroativamente sobre dados históricos.

### 18.7 Evolução do Schema da Bronze

A Bronze deve preservar informações brutas e metadados suficientes para oferecer suporte à interpretação histórica.

Quando a representação da Bronze evoluir, a plataforma deve preservar contexto suficiente para determinar:

- estrutura original do evento;
- versão do contrato;
- versão de ingestão;
- metadados relevantes da origem;
- tempo de processamento;
- proveniência.

A evolução da Bronze não deve destruir silenciosamente a capacidade de interpretar registros históricos retidos.

### 18.8 Evolução do Schema da Silver

A Silver representa semântica analítica padronizada.

Uma definição da Silver pode mudar por causa de:

- transformação corrigida;
- campos renomeados ou reestruturados;
- normalização alterada;
- nova interpretação de negócio;
- alterações nos dados de referência;
- evolução de contrato.

O estado histórico da Silver deve, portanto, permanecer associado à definição de processamento que o produziu.

Um *schema* mais recente da Silver não invalida automaticamente o estado anterior da Silver.

### 18.9 Evolução do Modelo da Gold

A Gold pode evoluir por meio de:

- alterações no modelo dimensional;
- novos fatos;
- novas dimensões;
- medidas alteradas;
- granularidade alterada;
- estratégia de chaves substitutas alterada;
- regras de negócio corrigidas.

Versões históricas da Gold devem permanecer distinguíveis quando suas semânticas analíticas forem diferentes.

Os consumidores não devem presumir que valores de diferentes versões da Gold sejam diretamente comparáveis quando as definições orientadoras tiverem mudado materialmente.

### 18.10 Definição de Processamento

Uma definição de processamento representa a lógica necessária para transformar uma entrada governada em um resultado derivado.

Ela pode incluir:

- código;
- configuração;
- mapeamentos;
- dependências de referência;
- expectativas de *schema*;
- comportamento de qualidade;
- parâmetros de processamento.

A recuperação deve identificar a definição de processamento utilizada para a saída reconstruída.

Um *commit* do repositório de código pode contribuir para essa identidade, mas pode não ser suficiente se a configuração de *runtime* também afetar o comportamento.

### 18.11 Versão de Processamento

Uma versão de processamento deve identificar uma definição de transformação materialmente significativa.

O versionamento pode ser implementado utilizando:

- *commit* do Git;
- identificador de versão;
- versão da imagem de contêiner;
- versão de artefato;
- versão de *deployment*;
- metadados explícitos de versão de processamento.

A implementação final pode combinar vários identificadores.

O objetivo é a reprodutibilidade, e não a numeração de versões por si só.

### 18.12 Versão de Configuração

O comportamento do processamento pode depender de configuração externa ao código da aplicação.

Exemplos incluem:

- mapeamentos de tópicos;
- mapeamentos de *schema*;
- parâmetros de processamento;
- limites de qualidade;
- mapeamentos de referência;
- *feature flags*;
- parâmetros de orquestração.

A recuperação deve preservar ou identificar a configuração que afeta materialmente a saída histórica.

Reutilizar código histórico com uma configuração atual incompatível pode não reproduzir o resultado histórico.

### 18.13 Versão de Infraestrutura

A versão da infraestrutura pode ser relevante quando o comportamento muda materialmente entre versões de tecnologia.

Exemplos incluem:

- SQL Server;
- Kafka;
- Debezium;
- Apicurio Registry;
- MinIO;
- Airflow;
- *runtime* de processamento.

A Atlas Engineering não precisa preservar indefinidamente todos os binários históricos de infraestrutura.

Entretanto, dependências materiais de compatibilidade que afetem a recuperação devem ser documentadas e validadas.

### 18.14 Reprodução Histórica

A reprodução histórica tenta reconstruir o que deveria ter sido produzido sob as definições historicamente aplicáveis.

O modelo orientador é:

**Entrada Histórica**
+
**Contrato Histórico**
+
**Definição Histórica de Processamento**
+
**Contexto Histórico Necessário**
→ **Resultado Histórico Esperado**

Esse modo é útil para:

- reprodutibilidade;
- auditoria;
- investigação;
- comparação;
- validação do comportamento histórico.

### 18.15 Reapresentação Histórica

A reapresentação histórica aplica intencionalmente uma definição corrigida ou mais recente à entrada histórica.

O modelo orientador é:

**Entrada Histórica**
+
**Nova Definição de Processamento Selecionada**
+
**Contexto Selecionado**
→ **Novo Resultado Histórico**

A reapresentação pode legitimamente alterar a saída analítica histórica.

Ela deve, portanto, criar nova linhagem identificável, em vez de substituir silenciosamente o histórico de interpretação.

### 18.16 Reprodução versus Reapresentação

O objetivo da recuperação deve distinguir explicitamente:

**Reprodução**
→ O que a plataforma deveria ter produzido utilizando a definição histórica aplicável?

de:

**Reapresentação**
→ Como os dados históricos devem se apresentar de acordo com a definição corrigida ou atual selecionada?

Ambas são válidas.

Elas respondem a perguntas diferentes.

Um procedimento de recuperação não deve executar acidentalmente uma enquanto afirma estar executando a outra.

### 18.17 Lógica Histórica Corrigida

Um defeito de processamento cria um caso especial.

A implementação historicamente implantada pode ter sido defeituosa.

Reproduzir exatamente a implementação defeituosa pode reproduzir o resultado incorreto.

O objetivo da recuperação pode exigir, em vez disso:

**Definição Histórica Pretendida**

em vez de:

**Defeito Histórico Executado**.

As evidências devem distinguir:

- qual código realmente foi executado;
- qual comportamento era pretendido;
- qual definição corrigida foi selecionada;
- por que o resultado reconstruído é diferente.

### 18.18 Dados Históricos de Referência

O processamento histórico pode depender de valores de referência válidos em determinado momento.

Exemplos podem incluir:

- status;
- classificações;
- mapeamentos;
- categorias de negócio;
- valores controlados de consulta.

A recuperação deve determinar se exige:

**Estado Histórico de Referência**

ou:

**Estado Atual de Referência**.

Utilizar dados atuais de referência durante uma reprodução histórica pode alterar silenciosamente o resultado.

### 18.19 Versionamento de Dados de Referência

Dados de referência que afetem materialmente a interpretação histórica devem preservar contexto temporal ou de versão suficiente quando necessário.

Possíveis abordagens incluem:

- histórico por data de vigência;
- *snapshots* versionados;
- versões imutáveis de referência;
- tabelas históricas governadas.

Nem toda consulta estática exige versionamento complexo.

O versionamento é necessário quando alterações poderiam tornar os resultados históricos irreproduzíveis ou ambíguos.

### 18.20 Regras Históricas de Negócio

As regras de negócio podem evoluir.

Exemplos incluem:

- classificação de transações;
- interpretação de status;
- segmentação de clientes;
- lógica de inventário;
- cálculo analítico;
- atribuição dimensional.

Um resultado histórico deve permanecer atribuível à definição de regra de negócio utilizada para produzi-lo.

A reapresentação histórica utilizando uma nova regra de negócio deve ser explícita.

### 18.21 Versões das Regras de Qualidade

As expectativas de qualidade podem evoluir ao longo do tempo.

Um conjunto de dados que passou pelos controles de qualidade sob um conjunto de regras pode falhar sob um conjunto posterior.

A recuperação deve distinguir:

**Este resultado histórico era válido sob as regras aplicáveis naquele momento?**

de:

**Este resultado histórico atenderia às regras atuais?**

Essas são perguntas de validação diferentes.

### 18.22 Reprodução Histórica da Qualidade

Ao reproduzir um estado histórico de processamento, as regras históricas de qualidade aplicáveis podem ser necessárias para compreender se a saída deveria ter sido aceita naquele momento.

Isso oferece suporte a:

- auditoria;
- análise de incidentes;
- reconstrução do histórico de certificação.

Isso não impede que a plataforma aplique adicionalmente os controles atuais para a governança do presente.

### 18.23 Validação Atual da Qualidade de Dados Históricos

Dados históricos reconstruídos atualmente também podem precisar atender aos controles atuais antes de se tornarem novamente visíveis aos consumidores.

Por exemplo:

**Reprodução Histórica**
→ reproduz o resultado histórico.

Mas:

**Nova Publicação Hoje**
→ ainda pode exigir controles atuais de certificação.

Correção histórica e elegibilidade atual para publicação são responsabilidades relacionadas, porém distintas.

### 18.24 Versões das Regras de Reconciliação

A lógica de reconciliação também pode evoluir.

A recuperação histórica deve preservar contexto suficiente para compreender:

- qual reconciliação foi originalmente executada;
- quais limites ou comparações eram aplicáveis;
- se a reconstrução atual utiliza uma definição mais recente de reconciliação.

Uma regra de reconciliação alterada não deve reescrever silenciosamente evidências históricas de certificação.

### 18.25 Versões das Regras de Certificação

Os critérios de certificação podem mudar ao longo do tempo.

Uma versão certificada sob critérios históricos permanece como evidência da decisão tomada sob esses critérios.

Se essa versão for republicada ou reconstruída atualmente, os requisitos atuais de certificação também podem ser aplicáveis.

A plataforma deve preservar ambos:

**Contexto Histórico de Certificação**

e:

**Decisão Atual de Publicação**

quando relevante.

### 18.26 Evidências Históricas de Certificação

A Certified Gold histórica deve reter evidências suficientes para determinar:

- versão da candidata;
- versão de processamento;
- resultado da qualidade;
- resultado da reconciliação;
- contexto das regras de certificação;
- momento da publicação;
- intervalo ativo;
- invalidação posterior ou *rollback*, quando aplicável.

Isso oferece suporte à reconstrução do que os consumidores estavam autorizados a visualizar em determinado momento.

### 18.27 Linhagem Versionada

A linhagem deve conectar a saída histórica às versões que materialmente a produziram.

Conceitualmente:

**Versão da Origem / Evento**
→ **Representação na Bronze**
→ **Versão de Processamento da Silver**
→ **Versão de Processamento da Gold**
→ **Contexto de Qualidade / Reconciliação**
→ **Versão Certificada**

A linhagem versionada permite que a saída histórica permaneça explicável depois que a plataforma evolui.

### 18.28 Compatibilidade de Versões

A recuperação pode exigir compatibilidade entre:

- dados retidos;
- *runtime* atual;
- contratos históricos;
- artefatos históricos de processamento;
- estruturas atuais de armazenamento.

A compatibilidade deve ser validada, e não presumida.

Um artefato histórico retido que não possa ser executado ou interpretado no ambiente atual pode exigir:

- migração;
- adaptador;
- camada de compatibilidade;
- reconstrução controlada utilizando uma definição equivalente.

### 18.29 Retenção de Artefatos Históricos de Processamento

Artefatos de processamento necessários para a janela de recuperação suportada devem permanecer identificáveis e recuperáveis.

Dependendo da implementação, isso pode incluir:

- código-fonte;
- artefato empacotado;
- imagem de contêiner;
- script SQL;
- configuração;
- definição de *schema*;
- manifesto de *deployment*.

A retenção deve estar alinhada aos requisitos reais de recuperação.

A plataforma não precisa preservar indefinidamente artefatos não utilizados sem uma razão governada.

### 18.30 Git como Evidência Histórica

O Git fornece evidências históricas importantes para:

- código-fonte;
- SQL;
- configuração submetida ao repositório;
- documentação de arquitetura;
- definições de processamento.

O histórico do Git pode ajudar a identificar a implementação pretendida em determinada versão.

Entretanto, o Git, por si só, não captura automaticamente:

- configuração de *runtime*;
- segredos;
- estado externo de referência;
- estado mutável da infraestrutura;
- identidade do artefato implantado.

As evidências de recuperação não devem, portanto, presumir que um *hash* de *commit*, por si só, reproduza completamente uma execução histórica.

### 18.31 Identidade Imutável de Artefato

Quando artefatos de processamento empacotados forem utilizados, uma identidade imutável fortalece a reprodutibilidade.

Exemplos incluem:

- *digest* imutável de imagem de contêiner;
- artefato imutável de versão;
- pacote versionado de *deployment* SQL.

Uma *tag* mutável como `latest` é insuficiente como identidade histórica.

A implementação deve preferir referências imutáveis para artefatos de processamento utilizados em recuperação governada.

### 18.32 Segredos Históricos

A recuperação não deve exigir a preservação de valores antigos de segredos apenas para reproduzir uma execução histórica.

Segredos são credenciais operacionais, e não semântica de processamento de negócio.

O processamento histórico deve utilizar credenciais atualmente autorizadas enquanto preserva a definição lógica histórica.

Credenciais expiradas ou revogadas não devem ser restauradas apenas por razões de reprodutibilidade.

### 18.33 Política Histórica de Segurança

A reprodução histórica não justifica restaurar permissões de segurança obsoletas.

Os controles atuais de segurança e privacidade permanecem aplicáveis durante a recuperação.

Por exemplo:

**Processo Histórico Possuía Acesso Amplo**
não implica
**Acesso Histórico Amplo Deve Ser Recriado Hoje**.

A reprodutibilidade lógica deve permanecer compatível com a governança atual.

### 18.34 Requisitos Históricos de Privacidade

Dados que estavam historicamente disponíveis podem posteriormente ficar sujeitos a:

- exclusão;
- anonimização;
- expiração de retenção;
- restrição de acesso.

A recuperação deve respeitar o estado atual, legal e governado dos dados.

A reprodutibilidade histórica não se sobrepõe às obrigações de privacidade.

Um valor excluído ou que não seja mais autorizado não deve ser restaurado apenas porque um artefato antigo de processamento espera encontrá-lo.

### 18.35 Exclusão de Dados Históricos

Quando uma política governada de retenção ou privacidade remove permanentemente dados históricos, parte da capacidade anterior de recuperação pode deixar de existir intencionalmente.

A plataforma deve reconhecer isso explicitamente.

A garantia de recuperação passa a ser limitada por:

- dados retidos;
- contexto de interpretação retido;
- governança atual.

A arquitetura não deve prometer reconstrução histórica indefinida quando uma política remove intencionalmente o histórico necessário.

### 18.36 Matriz de Dependências de Versão

Para versões significativas de processamento, a Atlas Engineering pode manter uma matriz de dependências de versão identificando relacionamentos como:

**Versão de Processamento**
→ versões suportadas do contrato de entrada  
→ contexto necessário dos dados de referência  
→ versão do *schema* de saída  
→ versão das regras de qualidade.

Isso pode simplificar:

- planejamento de *replay*;
- reprocessamento;
- *rebuild*;
- análise de compatibilidade.

A implementação exata pode permanecer leve na Versão 1.

### 18.37 Seleção da Versão de Recuperação

Antes do início da recuperação histórica, o contexto de versão selecionado deve responder:

- Qual versão da entrada está sendo recuperada?
- Qual definição de processamento irá interpretá-la?
- O objetivo é reprodução ou reapresentação?
- Qual estado de referência é necessário?
- Qual versão de saída será produzida?
- Quais regras de qualidade e reconciliação são aplicáveis?
- Quais regras de certificação se aplicam à publicação atualmente?

A seleção de versão faz parte do plano de recuperação.

### 18.38 Versão Histórica Não Suportada

Uma versão histórica retida pode eventualmente ficar fora da janela de recuperação suportada.

Possíveis razões incluem:

- tecnologia incompatível;
- artefatos intencionalmente expirados;
- dados excluídos;
- contrato descontinuado;
- dependência histórica indisponível.

A plataforma deve identificar explicitamente essas limitações.

Histórico não suportado não deve ser apresentado como completamente recuperável apenas porque alguns arquivos brutos ainda permanecem.

### 18.39 Migração de Versão

Dados históricos podem exigir migração antes de poderem ser processados pela plataforma atual.

A migração deve preservar:

- identidade da origem;
- proveniência;
- versão original;
- versão da migração;
- justificativa da transformação;
- contrato resultante.

A migração não deve apagar a distinção entre a representação histórica original e a representação migrada.

### 18.40 Recuperação entre Múltiplas Versões

Um único intervalo de recuperação pode abranger várias versões históricas.

Por exemplo:

**Intervalo A**
→ Contrato V1 + Silver V2.

**Intervalo B**
→ Contrato V2 + Silver V2.

**Intervalo C**
→ Contrato V2 + Silver V3.

A recuperação pode, portanto, precisar:

- segmentar o escopo histórico;
- aplicar interpretação específica por versão;
- normalizar resultados;
- reconciliar entre limites de versões.

Aplicar cegamente uma única definição de processamento a todo o intervalo pode produzir resultados incorretos.

### 18.41 Detecção de Limites de Versão

A recuperação deve conseguir identificar limites significativos de versão quando diferentes interpretações forem necessárias.

Os limites podem ser derivados de:

- metadados de eventos;
- metadados de *deployment*;
- identificadores de contrato;
- metadados de processamento;
- datas de vigência;
- histórico do Git ou de versões.

O limite deve ser baseado em evidências, em vez de ser inferido a partir de datas aproximadas.

### 18.42 Testes de Versões Históricas

A compatibilidade de versões deve ser testada utilizando dados históricos retidos representativos.

Os testes podem validar:

- interpretação de contratos antigos;
- compatibilidade de artefatos de processamento;
- migração de *schema*;
- reconstrução de dados de referência;
- consistência da saída;
- reprodução histórica;
- reapresentação histórica.

O fato de uma versão estar armazenada não constitui evidência de que ela continue utilizável.

### 18.43 Degradação da Capacidade de Recuperação

A degradação da capacidade de recuperação ocorre quando a plataforma retém dados históricos, mas perde gradualmente a capacidade prática de reconstruí-los porque:

- contratos desaparecem;
- artefatos deixam de estar disponíveis;
- dependências tornam-se incompatíveis;
- configurações mudam sem documentação;
- histórico de referência é perdido;
- testes deixam de cobrir versões históricas.

A capacidade de recuperação deve, portanto, ser mantida, e não apenas projetada uma única vez.

### 18.44 Janela Histórica de Recuperação

A janela histórica de recuperação suportada é limitada pela interseção de:

- retenção de dados;
- retenção de contratos;
- retenção de artefatos de processamento;
- retenção do histórico de referência;
- compatibilidade técnica;
- requisitos atuais de segurança e privacidade.

Conceitualmente:

**Janela Histórica de Recuperação**
=
**Ponto Mais Antigo para o Qual Todas as Dependências Necessárias de Recuperação Permanecem Disponíveis e Governadas**

A dependência necessária de menor duração pode determinar a janela efetiva.

### 18.45 Alinhamento da Retenção de Versões

As políticas de retenção devem evitar incompatibilidades evidentes, como:

**Eventos Kafka Retidos**
mas:
**Contrato Necessário Excluído**

ou:

**Bronze Retida**
mas:
**Definição Necessária de Processamento Indisponível**.

O alinhamento da retenção não exige que todos os artefatos compartilhem a mesma duração.

Ele exige que o conjunto completo de dependências de recuperação permaneça disponível para a capacidade de recuperação que está sendo declarada.

### 18.46 Validação da Recuperação Histórica

A validação da recuperação histórica deve confirmar, quando aplicável:

- versão da entrada identificada;
- contrato disponível;
- versão de processamento identificada;
- contexto de configuração disponível;
- contexto de referência apropriado;
- objetivo identificado como reprodução ou reapresentação;
- versão de saída explícita;
- regras de qualidade identificadas;
- regras de reconciliação identificadas;
- requisitos atuais de certificação aplicados quando houver publicação;
- linhagem preservada;
- requisitos de segurança e privacidade respeitados.

O processamento histórico não é considerado reproduzível apenas porque a execução é concluída.

### 18.47 Evidências de Versão Histórica

Evidências representativas devem preservar:

- intervalo de recuperação;
- versões de entrada;
- versões de contrato;
- versões de processamento;
- identificadores de artefato;
- contexto de configuração;
- contexto dos dados de referência;
- objetivo de reprodução ou reapresentação;
- versão de saída;
- versões de qualidade e reconciliação;
- contexto de certificação;
- problemas de compatibilidade observados;
- uso de migração ou adaptador;
- resultado final da validação.

Essas evidências demonstram que a recuperação histórica considera versões de forma explícita, em vez de ocorrer acidentalmente.

### 18.48 Cenários de Teste de Versões Históricas

A Versão 1 deve validar cenários representativos, como:

**Teste de Versão Histórica 1 — Contrato de Evento Anterior**
→ reter eventos utilizando uma versão anterior do contrato  
→ evoluir o contrato de forma compatível  
→ realizar *replay* dos eventos históricos  
→ demonstrar interpretação correta.

**Teste de Versão Histórica 2 — Versão de Processamento**
→ processar um intervalo histórico limitado utilizando uma versão de transformação  
→ preservar o resultado  
→ modificar a transformação  
→ reproduzir ou reapresentar o mesmo intervalo de acordo com o objetivo declarado  
→ demonstrar a diferença.

**Teste de Versão Histórica 3 — Alteração de Referência**
→ processar entrada histórica utilizando um estado de referência  
→ alterar o valor de referência  
→ reprocessar de acordo com os objetivos de reprodução histórica e reapresentação  
→ demonstrar por que as semânticas resultantes são diferentes.

**Teste de Versão Histórica 4 — Limite de Versão**
→ criar um intervalo histórico controlado abrangendo duas versões de processamento ou contrato  
→ recuperar o intervalo utilizando limites sensíveis a versão  
→ validar o resultado combinado.

Os cenários exatos devem refletir a implementação final da Versão 1.

### 18.49 Garantias de Recuperação e Versões Históricas

O modelo de recuperação de versões históricas da Atlas Engineering deve preservar as seguintes garantias:

1. dados retidos, por si só, não constituem capacidade completa de recuperação;
2. a recuperação histórica preserva contexto de interpretação suficiente;
3. artefatos sensíveis a versão permanecem identificáveis quando necessário;
4. contratos históricos de eventos permanecem disponíveis durante toda a janela de recuperação suportada;
5. a retenção de contratos permanece alinhada à capacidade de recuperação dos eventos retidos;
6. o *schema* atual da origem não é automaticamente projetado sobre estado histórico;
7. a Bronze preserva metadados suficientes para interpretação histórica;
8. estados históricos da Silver e da Gold permanecem atribuíveis às definições de processamento que os produziram;
9. semânticas materialmente diferentes da Gold permanecem distinguíveis entre versões;
10. a identidade de processamento inclui código e configuração materialmente relevantes;
11. identidade imutável de artefato é preferida quando artefatos empacotados são utilizados;
12. requisitos de compatibilidade da infraestrutura são documentados quando afetam a recuperação;
13. reprodução histórica permanece distinta de reapresentação histórica;
14. lógica histórica corrigida distingue o comportamento pretendido dos defeitos anteriormente executados;
15. contexto histórico de referência é preservado quando necessário para reprodutibilidade;
16. regras de negócio em evolução permanecem atribuíveis às saídas históricas;
17. validação histórica e atual da qualidade permanecem distinguíveis;
18. a evolução das regras de reconciliação e certificação não reescreve silenciosamente evidências históricas;
19. linhagem versionada conecta saídas às definições históricas materialmente relevantes;
20. a compatibilidade entre artefatos históricos e ambientes atuais de execução é validada;
21. artefatos de processamento exigidos pela janela de recuperação suportada permanecem recuperáveis;
22. o histórico do Git contribui para as evidências de recuperação, mas não é tratado, por si só, como reprodução completa do *runtime*;
23. a recuperação histórica não exige restauração de credenciais expiradas ou revogadas;
24. os requisitos atuais de segurança e privacidade permanecem autoritativos durante a recuperação histórica;
25. exclusão governada pode reduzir intencionalmente a capacidade histórica de recuperação;
26. a seleção da versão de recuperação é explícita antes do início do processamento histórico;
27. versões históricas não suportadas são identificadas, em vez de serem apresentadas como completamente recuperáveis;
28. a migração histórica preserva a proveniência original e a identidade da versão;
29. intervalos de recuperação que abrangem múltiplas versões utilizam limites de versão baseados em evidências;
30. a compatibilidade entre versões históricas é testada, e não inferida a partir da retenção de artefatos;
31. a degradação da capacidade de recuperação é tratada como risco de confiabilidade;
32. a janela histórica efetiva de recuperação é limitada pela dependência governada necessária de menor duração;
33. as políticas de retenção preservam o conjunto completo de dependências necessário para a capacidade de recuperação declarada;
34. a recuperação histórica é considerada demonstrada somente após validação e evidências sensíveis a versão.

---

## 19. Validação e Evidências de Recuperação

A Atlas Engineering deve validar a recuperação utilizando evidências observáveis e reproduzíveis.

Uma ação de recuperação não é considerada bem-sucedida apenas porque:

- um serviço foi reinicializado;
- uma conexão foi estabelecida com sucesso;
- uma tarefa retornou `SUCCESS`;
- um consumidor retomou;
- o *lag* do consumidor chegou a zero;
- uma tabela voltou a poder ser consultada;
- um *dashboard* voltou a estar disponível.

A validação da recuperação deve demonstrar que a responsabilidade afetada retornou a um estado governado correto.

O modelo orientador é:

**Estado Conhecido Antes da Falha → Falha → Estado de Recuperação Preservado → Ação de Recuperação → Estado Recuperado → Validação → Evidências → Encerramento da Recuperação**

A profundidade da validação deve refletir a responsabilidade arquitetural e o escopo da falha.

### 19.1 Validação da Recuperação

A validação da recuperação determina se a plataforma restaurou os requisitos necessários de:

- capacidade do serviço;
- estado durável;
- continuidade do processamento;
- completude dos dados;
- correção dos dados;
- consistência *downstream*;
- estado de certificação;
- disponibilidade para consumidores.

Nem todo incidente exige todas as dimensões de validação.

O escopo necessário da validação depende do que falhou e de qual mecanismo de recuperação foi utilizado.

### 19.2 Evidências de Recuperação

Evidências de recuperação são as informações retidas que sustentam a conclusão de que a recuperação foi bem-sucedida ou falhou.

As evidências podem incluir:

- *timestamps*;
- estado do serviço;
- *logs*;
- métricas;
- *offsets*;
- *checkpoints*;
- posições da origem;
- contagens de linhas;
- resultados da reconciliação;
- resultados da qualidade;
- linhagem;
- registros de certificação;
- metadados de publicação;
- resultados visíveis aos consumidores.

As evidências devem ser suficientes para reconstruir a sequência importante da recuperação após o encerramento do incidente ou teste de laboratório.

### 19.3 Evidências Antes da Recuperação

Quando disponível, a plataforma deve preservar o último estado conhecido antes do início da recuperação.

Informações relevantes podem incluir:

- última posição bem-sucedida da origem;
- *offsets* do Kafka;
- *checkpoints* dos consumidores;
- último limite da Bronze;
- último limite da Silver;
- candidata Gold mais recente;
- versão ativa da Certified Gold;
- *backlog*;
- atualidade;
- momento da falha.

Isso estabelece o ponto inicial contra o qual a recuperação pode ser avaliada.

### 19.4 Evidências Durante a Falha

As evidências da falha devem preservar contexto suficiente para determinar:

- o que falhou;
- quando falhou;
- como a falha foi detectada;
- qual componente ou escopo de processamento foi afetado;
- qual processamento *upstream* continuou;
- qual processamento *downstream* parou;
- qual estado durável permaneceu disponível;
- se houve acúmulo de *backlog*;
- se os consumidores permaneceram disponíveis.

O objetivo é identificar o raio de impacto real, em vez de inferi-lo posteriormente a partir de informações incompletas.

### 19.5 Evidências Antes da Remediação

Antes de alterar o estado durante a recuperação, a plataforma deve capturar, quando prático, a condição relevante da falha.

Isso pode incluir:

- *offset* que falhou;
- versão de processamento que falhou;
- categoria da exceção;
- estado corrompido ou ausente;
- candidata ativa;
- versão certificada atual;
- condição da dependência;
- estado do *backlog*.

Ações de recuperação podem destruir evidências úteis para diagnóstico.

O estado importante anterior à remediação deve, portanto, ser preservado antes de intervenções destrutivas ou que alterem estado, quando viável.

### 19.6 Evidências da Ação de Recuperação

As ações de recuperação devem permanecer atribuíveis.

Informações relevantes podem incluir:

- ação executada;
- momento da execução;
- componente de destino;
- fonte de recuperação;
- limite de processamento selecionado;
- intervalo histórico selecionado;
- versão de processamento;
- versão de configuração;
- identidade da execução;
- resultado.

Isso permite que análises posteriores distingam o que a plataforma recuperou automaticamente daquilo que exigiu intervenção explícita.

### 19.7 Evidências da Fonte de Recuperação

A fonte de recuperação deve ser identificável.

Exemplos incluem:

- CDC;
- Kafka;
- Bronze;
- Silver;
- *backup*;
- arquivo histórico;
- versão anterior da Certified Gold.

As evidências devem demonstrar por que a fonte selecionada foi considerada confiável para o escopo de recuperação afetado.

Uma execução bem-sucedida a partir de uma fonte não validada não comprova recuperação correta.

### 19.8 Evidências do Limite de Recuperação

A recuperação deve identificar o limite a partir do qual o processamento foi retomado ou a reconstrução começou.

Exemplos incluem:

- LSN do SQL Server ou posição equivalente da origem;
- tópico, partição e *offset* do Kafka;
- intervalo histórico da Bronze;
- *checkpoint* de processamento da Silver;
- limite de processamento da Gold;
- identificador da versão certificada.

O limite deve ser explícito o suficiente para oferecer suporte à investigação de:

- lacunas;
- sobreposição;
- *replay*;
- processamento duplicado;
- completude da recuperação.

### 19.9 Validação da Recuperação do Serviço

A recuperação do serviço confirma que a capacidade técnica necessária está operacional.

Verificações representativas podem incluir:

- processo em execução;
- *endpoint* acessível;
- conexão com dependência bem-sucedida;
- autenticação bem-sucedida;
- armazenamento necessário acessível;
- tópico ou banco de dados necessário disponível.

A recuperação do serviço normalmente é a primeira camada de validação.

Ela não é a conclusão final da recuperação.

### 19.10 Validação da Recuperação do Processamento

A recuperação do processamento confirma que o componente retomou sua responsabilidade arquitetural.

Verificações representativas podem incluir:

- posições da origem avançando;
- eventos sendo publicados;
- consumidores processando;
- *checkpoints* avançando;
- arquivos sendo persistidos;
- transformações sendo concluídas;
- candidatas Gold sendo geradas.

Um processo em execução sem progresso significativo não é considerado recuperado com sucesso.

### 19.11 Validação da Recuperação dos Dados

A recuperação dos dados confirma que o estado necessário dos dados está completo e correto para o limite de recuperação pretendido.

A validação pode incluir:

- presença esperada de registros;
- intervalo histórico esperado;
- contagens;
- cobertura de chaves de negócio;
- ordenação;
- detecção de duplicidades;
- consistência referencial;
- correção das transformações.

Os controles exatos dependem da camada recuperada.

### 19.12 Validação da Continuidade

A validação da continuidade determina se a recuperação preservou toda a sequência necessária entre:

**Último Progresso Reconhecidamente Válido**

e:

**Progresso Recuperado**.

Para processamento orientado a eventos, isso pode incluir:

- posições da origem;
- *offsets* do Kafka;
- sequências de partições;
- *checkpoints*.

O objetivo é demonstrar:

**Nenhuma Lacuna Não Explicada**

e:

**Nenhuma Sobreposição Descontrolada**.

Reentrega ou *replay* controlados são aceitáveis quando efeitos duplicados são impedidos.

### 19.13 Detecção de Lacunas

Uma lacuna de processamento existe quando uma entrada necessária não pode ser contabilizada entre limites conhecidos de progresso.

Possíveis evidências incluem:

- posições ausentes da origem;
- *offsets* ausentes;
- intervalos ausentes da Bronze;
- diferenças de contagem não explicadas;
- chaves de negócio ausentes;
- estado *downstream* incompleto.

Uma lacuna não deve ser ocultada pelo avanço do *checkpoint* de recuperação.

Se a lacuna não puder ser reconstruída a partir da fonte atual de recuperação, é necessário escalar a fonte de recuperação.

### 19.14 Detecção de Sobreposição

A recuperação pode revisitar intencionalmente entradas previamente processadas.

A sobreposição não é inerentemente incorreta.

A plataforma deve determinar se a sobreposição resultou de:

- nova tentativa;
- reentrega;
- *replay*;
- reprocessamento;
- *backfill*;
- seleção do limite de recuperação.

A validação deve demonstrar que a sobreposição não criou efeitos de negócio duplicados não pretendidos.

### 19.15 Validação de Efeitos Duplicados

Entrega duplicada pode ser esperada.

Efeitos de negócio duplicados não são.

A validação da recuperação deve determinar, quando aplicável, se o processamento repetido criou:

- registros duplicados na Bronze além da representação pretendida;
- estado duplicado na Silver;
- linhas de fatos duplicadas;
- efeitos repetidos de inventário;
- efeitos financeiros repetidos;
- versões dimensionais repetidas.

Afirmações de idempotência devem ser sustentadas pelo comportamento observado durante a recuperação.

### 19.16 Validação da Ordenação

Quando a ordenação for necessária, a recuperação deve demonstrar que a sequência relevante permanece válida.

Isso pode se aplicar a:

- ordenação de partições do Kafka;
- histórico de entidades;
- transições de estado de transações;
- movimentações de inventário;
- alterações dimensionais.

Um conjunto completo de registros processado na ordem incorreta ainda pode produzir um resultado incorreto.

### 19.17 Validação de Checkpoint

A validação do *checkpoint* deve confirmar:

- *checkpoint* esperado antes da falha;
- *checkpoint* utilizado para recuperação;
- progressão do *checkpoint* durante a recuperação;
- *checkpoint* final;
- relacionamento entre *checkpoint* e saída durável.

Um *checkpoint* não deve avançar além de dados que não tenham atingido seu estado durável necessário.

### 19.18 Validação de Backlog

Quando houver acúmulo de *backlog*, a validação deve capturar:

- *backlog* no momento da falha ou início da recuperação;
- idade da entrada pendente mais antiga;
- tendência do *backlog*;
- taxa de entrada;
- taxa de processamento;
- tempo até retornar à faixa operacional normal.

A recuperação não está completa apenas porque o serviço afetado foi reinicializado.

O *backlog* deve convergir de acordo com o comportamento esperado de recuperação.

### 19.19 Validação da Retenção

As evidências de recuperação devem confirmar que o histórico *upstream* necessário permaneceu dentro da janela de retenção aplicável.

Fontes relevantes podem incluir:

- CDC;
- Kafka;
- histórico retido da Bronze;
- *backups*;
- dados históricos arquivados.

Se o histórico necessário tiver expirado durante o incidente, as evidências de recuperação devem identificar a fonte alternativa utilizada.

### 19.20 Validação da Recuperação da Bronze

A validação da recuperação da Bronze deve confirmar, quando aplicável:

- a entrada necessária do Kafka foi representada;
- identidade da origem e do evento foi preservada;
- intervalo histórico esperado está completo;
- tratamento de duplicidades se comportou conforme projetado;
- fidelidade bruta foi preservada;
- metadados de linhagem estão disponíveis.

A recuperação da Bronze é particularmente importante porque a Bronze forma o principal limite analítico de reconstrução de longo prazo.

### 19.21 Validação da Recuperação da Silver

A validação da recuperação da Silver deve confirmar:

- escopo esperado da Bronze foi processado;
- versão correta de processamento foi utilizada;
- *checkpoint* está alinhado;
- padronização está completa;
- estado necessário da entidade está correto;
- controles de qualidade foram aprovados;
- linhagem foi preservada.

Se a Silver tiver passado por *rebuild*, a validação deve comparar o estado reconstruído com a definição governada esperada, em vez de apenas confirmar a criação de linhas.

### 19.22 Validação da Recuperação da Gold

A validação da recuperação da Gold deve confirmar:

- limite pretendido da Silver foi utilizado;
- processamento dimensional está completo;
- relacionamentos entre fatos e dimensões estão válidos;
- medidas de negócio esperadas foram produzidas;
- qualidade foi aprovada;
- reconciliação foi aprovada;
- estado da candidata está completo.

O sucesso do processamento da Gold, por si só, não autoriza a publicação para consumidores.

### 19.23 Validação da Recuperação da Certified Gold

A validação da recuperação da Certified Gold deve confirmar:

- versão certificada ativa;
- estado da candidata;
- resultado da certificação;
- resultado da publicação;
- visibilidade atômica para consumidores;
- atualidade;
- estado de *rollback*, quando aplicável;
- acesso dos consumidores.

A versão final visível aos consumidores deve estar de acordo com os metadados de certificação e publicação.

### 19.24 Validação da Qualidade

A recuperação deve reaplicar os controles de qualidade exigidos pelo limite de processamento recuperado.

A execução de recuperação não está isenta dos requisitos normais de qualidade.

Quando a reprodução histórica utilizar regras históricas de qualidade, o contexto das regras aplicáveis deve permanecer explícito.

Quando dados reconstruídos forem publicados atualmente, os requisitos atuais de certificação também podem ser aplicáveis.

### 19.25 Validação da Reconciliação

A reconciliação fornece evidências de que o estado recuperado é consistente com o limite *upstream* ou de negócio esperado.

Possíveis comparações incluem:

- origem versus eventos capturados;
- Kafka versus Bronze;
- Bronze versus Silver;
- Silver versus Gold;
- totais de negócio esperados versus totais analíticos.

Nem toda camada exige igualdade de contagem de linhas um para um.

A reconciliação deve refletir a semântica das transformações.

### 19.26 Validação entre Camadas

Para eventos significativos de recuperação, a validação deve atravessar mais de um limite arquitetural.

Por exemplo:

**Recuperação do Kafka**
não deve terminar em:
→ *broker* está em execução.

Ela pode continuar por:

→ eventos legíveis  
→ Bronze avança  
→ Silver avança  
→ Gold avança  
→ atualidade da Certified Gold é recuperada.

A profundidade necessária depende do escopo da falha e do objetivo da recuperação.

### 19.27 Validação da Recuperação Ponta a Ponta

Um teste de recuperação ponta a ponta valida todo o fluxo desde uma alteração na origem autoritativa até o estado certificado visível aos consumidores.

Uma validação representativa pode estabelecer:

**Commit no AtlasCommerce**
→ captura pelo CDC  
→ publicação pelo Debezium  
→ retenção no Kafka  
→ persistência na Bronze  
→ processamento da Silver  
→ candidata Gold  
→ qualidade  
→ reconciliação  
→ certificação  
→ publicação  
→ consumo pelo Power BI.

Isso fornece as evidências mais fortes para afirmações de recuperação no nível da plataforma.

### 19.28 Validação do Consumidor

A validação da recuperação do consumidor deve confirmar que o produto analítico pretendido está:

- acessível;
- consultável;
- governado;
- utilizando a versão esperada da Certified Gold;
- dentro do estado esperado de atualidade.

A disponibilidade para consumidores não deve ser validada contornando a Certified Gold e consultando diretamente uma camada *upstream*.

### 19.29 Validação da Atualidade

A validação da atualidade deve comparar o estado visível aos consumidores com o limite pretendido de processamento da origem.

Evidências úteis podem incluir:

- tempo máximo de confirmação da origem representado;
- tempo máximo de evento representado;
- momento da conclusão do processamento;
- momento da certificação;
- momento da publicação;
- idade atual da atualidade.

A atualidade deve ser medida de acordo com a semântica definida para o produto.

### 19.30 Validação do RPO

A validação do RPO determina o ponto efetivo de recuperação alcançado após a falha.

As evidências devem identificar:

- último estado da origem conhecido como existente;
- estado recuperável mais recente;
- estado reconstruído mais recente;
- estado certificado e visível aos consumidores mais recente;
- qualquer intervalo intencionalmente perdido ou indisponível.

O RPO deve ser demonstrado utilizando limites de dados reais, em vez de ser inferido apenas a partir de agendas de *backup* ou configurações de retenção.

### 19.31 Validação do RTO

A validação do RTO deve medir a recuperação experimentada pela responsabilidade avaliada.

Possíveis marcos incluem:

- falha detectada;
- recuperação iniciada;
- serviço restaurado;
- processamento retomado;
- *backlog* retornou à faixa normal;
- validação concluída;
- Certified Gold restaurada;
- atualidade para consumidores restaurada.

O ponto final correto depende do objetivo da recuperação.

O tempo de reinicialização do serviço, por si só, é insuficiente para o RTO analítico ponta a ponta.

### 19.32 Linha do Tempo da Recuperação

Uma linha do tempo da recuperação deve preservar a sequência dos eventos importantes.

Por exemplo:

**T0**
→ falha começa.

**T1**
→ falha detectada.

**T2**
→ ação de recuperação começa.

**T3**
→ componente operacional.

**T4**
→ processamento retomado.

**T5**
→ *backlog* retorna à faixa normal.

**T6**
→ validação *downstream* aprovada.

**T7**
→ Certified Gold atual.

Isso permite decompor o atraso da recuperação em estágios significativos.

### 19.33 Tempo de Detecção

A análise da recuperação deve distinguir tempo de detecção de tempo de reparo.

Conceitualmente:

**Tempo de Detecção**
=
**Detecção da Falha - Início da Falha**

Uma plataforma pode se recuperar rapidamente após a intervenção e ainda possuir baixa confiabilidade se as falhas permanecerem não detectadas por longos períodos.

As evidências de detecção fazem parte da história completa da recuperação.

### 19.34 Tempo de Intervenção

O tempo entre a detecção e a ação de recuperação pode refletir:

- roteamento de alertas;
- diagnóstico;
- decisão;
- disponibilidade do operador;
- automação.

Conceitualmente:

**Atraso de Intervenção**
=
**Início da Recuperação - Detecção da Falha**

Isso pode revelar fragilidades operacionais independentemente da velocidade técnica de recuperação.

### 19.35 Tempo de Restauração Técnica

A restauração técnica mede quanto tempo a capacidade afetada leva para se tornar operacional após o início da recuperação.

Conceitualmente:

**Tempo de Restauração Técnica**
=
**Serviço Restaurado - Início da Recuperação**

Essa métrica é útil, mas deve permanecer distinta da recuperação completa dos dados e dos consumidores.

### 19.36 Tempo de Recuperação do Processamento

A recuperação do processamento mede o intervalo necessário para restaurar o estado normal de processamento depois que a capacidade técnica retorna.

Ela pode incluir:

- *catch-up* do *backlog*;
- *replay*;
- reprocessamento;
- *rebuild*.

Conceitualmente:

**Tempo de Recuperação do Processamento**
=
**Processamento Normalizado - Serviço Restaurado**

### 19.37 Tempo de Recuperação do Consumidor

A recuperação do consumidor mede quando um estado analítico governado aceitável volta a estar disponível.

Dependendo do incidente, isso pode ser:

- Certified Gold anterior;
- versão de *rollback*;
- versão atual corrigida.

O tempo de recuperação do consumidor pode, portanto, diferir significativamente do tempo de recuperação completa *upstream*.

### 19.38 Tempo Total de Recuperação

A recuperação total deve ser definida de acordo com o objetivo de confiabilidade afetado.

Para um incidente analítico ponta a ponta, ela pode incluir:

**Detecção**
+
**Intervenção**
+
**Restauração Técnica**
+
**Recuperação do Processamento**
+
**Validação**
+
**Certificação / Publicação**

A definição utilizada em um teste ou incidente deve ser explícita.

### 19.39 Coleta Automatizada de Evidências

Quando prático, as evidências de recuperação devem ser coletadas automaticamente.

Exemplos incluem:

- *timestamps*;
- métricas;
- *offsets*;
- *checkpoints*;
- estados de tarefas;
- identificadores de versão;
- resultados de certificação.

A automação reduz:

- erros de transcrição;
- evidências ausentes;
- medições inconsistentes.

Evidências manuais ainda podem ser necessárias para investigação, decisões e interpretação contextual.

### 19.40 Evidências Manuais

Evidências manuais podem incluir:

- anotações do operador;
- decisão de recuperação;
- interpretação da causa raiz;
- capturas de tela quando úteis;
- observações de validação;
- ações excepcionais.

As evidências manuais devem complementar o estado gerado por máquina, em vez de substituir medições objetivas quando essas medições estiverem disponíveis.

### 19.41 Correlação de Evidências

Evidências de diferentes componentes devem poder ser correlacionadas quando prático.

Dimensões úteis de correlação podem incluir:

- identificador da execução;
- identidade do evento;
- posição da origem;
- tópico e *offset*;
- execução de processamento;
- versão do produto de dados;
- identificador do incidente de recuperação;
- *timestamp*.

A correlação oferece suporte à reconstrução de como uma falha se propagou e foi recuperada através de múltiplas camadas.

### 19.42 Consistência Temporal

As evidências de recuperação dependem fortemente de *timestamps*.

Os componentes da plataforma devem utilizar tratamento consistente de tempo suficiente para comparar eventos entre:

- SQL Server;
- Kafka;
- serviços de processamento;
- MinIO;
- Airflow;
- observabilidade;
- AtlasWarehouse.

Inconsistência de relógio pode distorcer:

- latência;
- duração da falha;
- duração da recuperação;
- interpretação da ordenação de eventos.

A sincronização de tempo é, portanto, uma dependência de confiabilidade.

### 19.43 Integridade das Evidências

As evidências de recuperação devem ser confiáveis o suficiente para sustentar afirmações arquiteturais.

As evidências não devem ser alteradas manualmente apenas para fazer um teste parecer bem-sucedido.

Quando prático, as evidências devem ser:

- geradas automaticamente;
- registradas com *timestamp*;
- atribuíveis;
- retidas;
- reproduzíveis.

Um teste que falhou é uma evidência válida de engenharia.

Ele identifica uma capacidade que ainda exige correção.

### 19.44 Evidências de Recuperação com Falha

Tentativas de recuperação que falharam devem ser preservadas quando úteis.

As evidências podem mostrar:

- fonte de recuperação insuficiente;
- nova tentativa ineficaz;
- *backlog* incapaz de convergir;
- limite de recuperação incorreto;
- contrato histórico indisponível;
- falha de validação;
- falha de *rollback*.

Descartar experimentos que falharam remove informações que podem melhorar a arquitetura e os procedimentos.

### 19.45 Registro de Teste de Recuperação

Cada teste controlado de recuperação deve produzir um registro conciso de teste.

Um registro representativo pode incluir:

- identificador do teste;
- objetivo;
- cenário;
- componente afetado;
- estado inicial;
- injeção de falha;
- comportamento esperado;
- comportamento observado;
- ação de recuperação;
- fonte de recuperação;
- limite de recuperação;
- validação;
- RPO medido;
- RTO medido;
- resultado;
- referências das evidências;
- observações.

Isso fornece uma estrutura repetível para as evidências de laboratório.

### 19.46 Comportamento Esperado versus Observado

Os testes de recuperação devem distinguir a expectativa arquitetural da observação em laboratório.

Por exemplo:

**Esperado**
→ consumidor retoma a partir do *offset* confirmado sem perda de dados.

**Observado**
→ consumidor retomou a partir do *offset* X, processou Y eventos retidos e não produziu nenhuma diferença de reconciliação não explicada.

Essa distinção impede que a documentação de arquitetura apresente uma garantia pretendida como se já tivesse sido demonstrada.

### 19.47 Critérios de PASS

Um teste de recuperação deve definir os critérios de PASS antes ou como parte do projeto do teste.

Critérios representativos podem incluir:

- nenhuma perda de dados não explicada;
- nenhum efeito de negócio duplicado não pretendido;
- limite de recuperação correto;
- ordenação esperada preservada;
- *backlog* converge;
- qualidade necessária aprovada;
- reconciliação aprovada;
- comportamento da Certified Gold corresponde à arquitetura;
- recuperação medida permanece dentro do objetivo do teste.

PASS deve ser baseado em evidências, e não em observação subjetiva.

### 19.48 Critérios de FAIL

Um teste de recuperação deve falhar quando o comportamento necessário não for demonstrado.

Condições representativas incluem:

- lacuna de dados não explicada;
- efeito de negócio duplicado;
- *checkpoint* incorreto;
- incapacidade de recuperar histórico retido;
- estado inválido publicado;
- *rollback* malsucedido;
- *backlog* não converge;
- qualidade ou reconciliação necessária falha.

Um resultado FAIL deve provocar investigação e trabalho corretivo, em vez de ajuste das evidências para se adequarem à arquitetura esperada.

### 19.49 Resultado Inconclusivo

Alguns testes podem ser inconclusivos.

Exemplos incluem:

- telemetria indisponível;
- injeção de falha não realizada;
- ambiente de teste alterado inesperadamente;
- carga de trabalho insuficiente;
- evidências ausentes.

Um teste inconclusivo não deve ser registrado como PASS.

Ele deve ser repetido depois que a limitação for corrigida.

### 19.50 Evidências e Afirmações Arquiteturais

A Atlas Engineering deve fazer afirmações de confiabilidade proporcionais às evidências disponíveis.

Conceitualmente:

**Projetado**
→ comportamento arquitetural documentado.

**Implementado**
→ capacidade existe.

**Testado**
→ cenário controlado executado.

**Demonstrado**
→ comportamento esperado sustentado por evidências retidas.

O projeto deve evitar descrever uma propriedade de confiabilidade como demonstrada quando ela existe apenas na documentação.

### 19.51 Evidências e Limitações da Versão 1

As evidências do laboratório da Versão 1 devem ser interpretadas dentro da topologia real.

Por exemplo, testes bem-sucedidos de recuperação lógica não comprovam:

- alta disponibilidade do Kafka com múltiplos nós;
- redundância de armazenamento entre múltiplos hosts;
- vazão em escala de produção;
- recuperação de desastre entre regiões.

As evidências devem sustentar apenas a afirmação efetivamente testada.

Essa distinção preserva a credibilidade da arquitetura.

### 19.52 Retenção das Evidências

As evidências de recuperação devem permanecer disponíveis por tempo suficiente para oferecer suporte a:

- validação da arquitetura;
- diagnóstico de problemas;
- comparação entre testes;
- planejamento de capacidade;
- demonstração no portfólio;
- futuras decisões de projeto.

A retenção das evidências deve permanecer compatível com:

- segurança;
- privacidade;
- armazenamento;
- política do repositório.

Informações operacionais sensíveis não devem ser publicadas apenas porque as evidências de recuperação são úteis.

### 19.53 Evidências na Documentação Pública

A documentação pública da Atlas Engineering pode incluir evidências selecionadas de recuperação demonstrando o comportamento arquitetural.

Exemplos podem incluir:

- métricas sanitizadas;
- linhas do tempo de testes;
- gráficos de *backlog*;
- resumos de reconciliação;
- resultados PASS/FAIL;
- observações de recuperação.

As evidências públicas não devem expor:

- segredos;
- credenciais;
- dados sensíveis;
- detalhes desnecessários de infraestrutura que criem risco de segurança.

O objetivo é demonstrar decisões de engenharia, e não expor informações operacionais protegidas.

### 19.54 Evidências de Recuperação e Observabilidade

A observabilidade fornece grande parte das evidências de *runtime* necessárias para a validação da recuperação.

Exemplos incluem:

- *lag*;
- vazão;
- taxas de erro;
- idade do *backlog*;
- saúde dos serviços;
- latência de processamento;
- atualidade;
- progresso da recuperação.

A arquitetura especializada de **Observabilidade** define como esses sinais são coletados, armazenados, visualizados e utilizados em alertas.

Este documento define por que esses sinais são importantes para a recuperação.

### 19.55 Evidências de Recuperação e Documentação

Comportamentos significativos de recuperação descobertos por meio de testes de laboratório devem retroalimentar a arquitetura e a documentação operacional.

Por exemplo:

**Recuperação Esperada**
→ teste executado  
→ gargalo inesperado descoberto  
→ premissa arquitetural corrigida  
→ documentação de recuperação atualizada.

A documentação deve representar o comportamento validado do sistema, em vez de permanecer permanentemente congelada na premissa original de projeto.

### 19.56 Evidências de Recuperação e FAQ

Perguntas respondidas por meio de testes de recuperação devem contribuir para o FAQ arquitetural quando representarem preocupações recorrentes ou importantes de projeto.

Exemplos incluem:

- O que acontece se o Kafka parar?
- A Bronze pode passar por *rebuild*?
- O que acontece se a retenção do Kafka expirar?
- A Silver pode passar por *rebuild* sem realizar *replay* do Kafka?
- Como um registro problemático (*poison record*) é tratado?
- O que o consumidor vê durante a recuperação da Gold?
- Quanto tempo leva o *catch-up* após uma indisponibilidade?
- O que acontece se a versão mais recente da Certified Gold for inválida?

Quando possível, as respostas do FAQ devem apontar para as evidências controladas correspondentes do laboratório.

### 19.57 Cenários de Teste de Validação da Recuperação

A Versão 1 deve incluir cenários representativos de validação, como:

**Teste de Validação da Recuperação 1 — Reinicialização de Consumidor Kafka**
→ registrar os *offsets* iniciais e o estado da Bronze  
→ interromper o consumidor  
→ gerar alterações controladas na origem  
→ reinicializar o consumidor  
→ validar continuidade dos *offsets*  
→ validar completude da Bronze  
→ validar progressão *downstream*.

**Teste de Validação da Recuperação 2 — Rebuild da Silver**
→ preservar um intervalo conhecido da Bronze  
→ remover ou isolar o estado correspondente da Silver no laboratório  
→ realizar *rebuild* da Silver  
→ comparar o estado reconstruído com os resultados esperados  
→ validar qualidade e linhagem.

**Teste de Validação da Recuperação 3 — Rollback da Gold**
→ publicar uma versão controlada da Certified Gold  
→ criar e publicar uma versão de teste que seja posteriormente invalidada  
→ executar *rollback*  
→ validar versão ativa e visibilidade para consumidores  
→ preservar toda a linha do tempo da publicação.

**Teste de Validação da Recuperação 4 — Catch-Up do Backlog**
→ interromper um consumidor controlado  
→ acumular *backlog*  
→ restaurar o processamento  
→ medir vazão, tendência do *backlog*, idade da entrada pendente mais antiga e tempo até a faixa operacional normal.

**Teste de Validação da Recuperação 5 — Recuperação Ponta a Ponta**
→ introduzir uma interrupção controlada  
→ preservar o estado anterior à falha  
→ recuperar o componente afetado  
→ acompanhar o progresso através de Bronze, Silver, Gold, certificação e publicação  
→ validar o estado final visível aos consumidores.

Os procedimentos exatos dos testes devem ser definidos depois que os componentes correspondentes da Versão 1 forem implementados.

### 19.58 Garantias de Validação e Evidências de Recuperação

O modelo de validação da recuperação da Atlas Engineering deve preservar as seguintes garantias:

1. a reinicialização de um serviço, por si só, não estabelece recuperação bem-sucedida;
2. a validação da recuperação reflete a responsabilidade arquitetural que falhou;
3. as evidências de recuperação preservam contexto suficiente para reconstruir comportamentos significativos da recuperação;
4. estados relevantes anteriores à falha e à remediação são preservados quando prático;
5. ações de recuperação permanecem atribuíveis;
6. fonte e limite de recuperação são explícitos;
7. recuperação de serviço, processamento, dados e consumidores permanecem distinguíveis;
8. a validação da continuidade identifica lacunas não explicadas e sobreposição descontrolada;
9. reentrega, *replay* ou reprocessamento controlados não criam efeitos de negócio duplicados não pretendidos;
10. a ordenação necessária permanece validada;
11. o estado do *checkpoint* permanece consistente com o estado durável do processamento;
12. a convergência do *backlog* faz parte da validação da recuperação quando houver acúmulo de *backlog*;
13. a retenção necessária permanece validada em relação ao intervalo de recuperação;
14. Bronze, Silver, Gold e Certified Gold utilizam validações apropriadas às suas responsabilidades;
15. a recuperação não contorna controles de qualidade, reconciliação, certificação ou publicação;
16. eventos significativos de recuperação validam consequências *downstream* quando apropriado;
17. testes ponta a ponta podem demonstrar recuperação desde uma alteração na origem até o estado certificado visível aos consumidores;
18. a recuperação da atualidade permanece distinguível da disponibilidade do serviço;
19. o RPO é demonstrado utilizando limites reais de dados;
20. o RTO reflete o objetivo de recuperação que está sendo medido, e não apenas a reinicialização de processos;
21. linhas do tempo de recuperação distinguem detecção, intervenção, restauração técnica, recuperação do processamento e recuperação do consumidor;
22. evidências objetivas são coletadas automaticamente quando prático;
23. evidências manuais complementam, em vez de substituir, medições objetivas disponíveis;
24. evidências entre componentes permanecem correlacionáveis quando prático;
25. tratamento consistente de tempo sustenta medições confiáveis da recuperação;
26. tentativas de recuperação que falharam permanecem evidências válidas de engenharia;
27. testes controlados produzem registros estruturados de recuperação;
28. arquitetura esperada e comportamento observado no laboratório permanecem explicitamente distinguíveis;
29. resultados PASS, FAIL e inconclusivos são baseados em evidências;
30. afirmações de confiabilidade permanecem proporcionais às evidências demonstradas;
31. as limitações do laboratório da Versão 1 permanecem explícitas;
32. a retenção das evidências respeita segurança, privacidade e política do repositório;
33. evidências sanitizadas selecionadas podem sustentar a documentação pública da arquitetura;
34. a observabilidade fornece evidências de *runtime* sem substituir a semântica da recuperação;
35. descobertas do laboratório retroalimentam a arquitetura e a documentação operacional;
36. perguntas recorrentes sobre recuperação podem ser incorporadas ao FAQ arquitetural com referências às evidências;
37. a capacidade de recuperação é considerada demonstrada somente após validação controlada e evidências retidas.

---

## 20. Estratégia de Testes de Recuperação

A Atlas Engineering deve validar a confiabilidade e a recuperação por meio de testes controlados em laboratório.

Os testes de recuperação destinam-se a demonstrar como a plataforma implementada se comporta quando componentes, dependências, fluxos de processamento ou estados governados selecionados são interrompidos ou invalidados.

O modelo orientador é:

**Definir Comportamento Esperado → Estabelecer Linha de Base → Injetar Falha Controlada → Observar Impacto → Executar Recuperação → Validar Resultado → Preservar Evidências → Melhorar Arquitetura**

Os testes de recuperação devem permanecer:

- intencionais;
- limitados;
- observáveis;
- repetíveis quando prático;
- reversíveis;
- baseados em evidências.

O objetivo não é criar interrupções descontroladas.

O objetivo é demonstrar se a arquitetura de recuperação implementada se comporta conforme projetado.

### 20.1 Objetivos dos Testes

Os testes de recuperação devem responder a perguntas como:

- O que acontece quando um componente para?
- Quais dados continuam permanecendo duráveis?
- Quais estágios *downstream* deixam de avançar?
- O *backlog* se acumula?
- O processamento pode ser retomado a partir do progresso confirmado?
- A reentrega permanece idempotente?
- O histórico retido pode passar por *replay*?
- O estado derivado pode ser reconstruído?
- A Certified Gold permanece disponível?
- Quanto tempo o *catch-up* exige?
- A recuperação preserva a qualidade e a reconciliação?
- Qual fonte de recuperação é realmente necessária?
- Quais premissas da arquitetura são refutadas pela observação?

Os testes devem se concentrar em comportamentos arquiteturais significativos, em vez de apenas demonstrar que um processo pode ser reinicializado.

### 20.2 Injeção Controlada de Falhas

A injeção de falhas é a criação deliberada de uma condição de falha limitada para fins de validação.

Mecanismos representativos podem incluir:

- interromper um serviço;
- pausar um consumidor;
- interromper a conectividade de rede;
- remover temporariamente uma permissão necessária;
- utilizar uma credencial de teste inválida;
- esgotar um recurso controlado;
- introduzir uma falha determinística de processamento para teste;
- isolar um destino derivado;
- criar uma candidata Gold com falha;
- interromper um *rebuild*.

A injeção de falhas não deve:

- expor segredos reais;
- destruir dados insubstituíveis do projeto;
- corromper estado não relacionado;
- ignorar a limpeza definida;
- criar impacto externo descontrolado.

### 20.3 Escopo do Laboratório

Os testes de recuperação da Versão 1 ocorrem em um laboratório controlado.

O laboratório pode incluir:

- uma estação de trabalho física;
- SQL Server local;
- Kafka em contêiner;
- Apicurio Registry;
- MinIO;
- Airflow;
- Prometheus;
- Grafana;
- cargas de processamento executadas localmente.

Os testes resultantes demonstram comportamento apenas sob a topologia e a carga de trabalho documentadas da Versão 1.

Eles não comprovam automaticamente:

- Alta Disponibilidade com múltiplos nós;
- *failover* entre *hosts*;
- recuperação em escala de produção;
- Recuperação de Desastre entre regiões;
- maturidade operacional corporativa.

### 20.4 Linha de Base do Teste

Todo teste significativo de recuperação deve começar a partir de uma linha de base conhecida.

A linha de base deve identificar, quando aplicável:

- estado do componente;
- versão de processamento;
- posição da origem;
- *offsets* do Kafka;
- estado da Bronze;
- *checkpoint* da Silver;
- versão da Gold;
- versão da Certified Gold;
- *backlog*;
- atualidade;
- estado da qualidade;
- estado da reconciliação;
- utilização relevante de recursos.

Sem uma linha de base, torna-se difícil demonstrar exatamente o que mudou em decorrência da falha e da recuperação.

### 20.5 Validação da Linha de Base

A própria linha de base deve ser válida antes da injeção da falha.

Um teste não deve começar a partir de um estado da plataforma que já contenha, sem explicação:

- *lag*;
- lacunas;
- regras de qualidade com falha;
- candidatas inválidas;
- quarentena não resolvida;
- *checkpoints* inconsistentes.

Se a linha de base não for confiável, o resultado da recuperação torna-se ambíguo.

### 20.6 Hipótese do Teste

Um teste de recuperação deve definir o comportamento arquitetural esperado antes da execução.

Por exemplo:

**Hipótese**

Se o consumidor da Bronze for interrompido enquanto o Kafka permanecer disponível:

- os eventos do Kafka continuam se acumulando;
- o *checkpoint* da Bronze permanece inalterado;
- nenhum dado é perdido;
- a Certified Gold eventualmente fica desatualizada;
- após a reinicialização, a Bronze retoma a partir do progresso confirmado;
- o *backlog* diminui;
- nenhum efeito de negócio duplicado ocorre;
- o processamento *downstream* eventualmente realiza o *catch-up*.

O teste deve tentar validar ou refutar essa hipótese.

### 20.7 Impacto Esperado da Falha

O raio de impacto esperado deve ser documentado antes da injeção da falha.

Por exemplo:

**Falha do Consumidor Kafka**

Impacto esperado:

- a origem continua;
- o Debezium continua;
- o Kafka acumula eventos retidos;
- a Bronze para;
- a Silver eventualmente para;
- a Gold deixa de avançar;
- a Certified Gold permanece disponível, mas desatualizada.

O comportamento observado deve posteriormente ser comparado com esse impacto esperado.

### 20.8 Critérios de PASS

Os critérios de PASS devem ser definidos de acordo com o comportamento arquitetural que está sendo testado.

Critérios representativos incluem:

- a falha esperada ocorre;
- nenhuma perda de dados não explicada;
- o estado durável necessário permanece disponível;
- o *checkpoint* permanece consistente;
- o *backlog* esperado se acumula;
- a recuperação começa a partir do limite pretendido;
- o *backlog* converge;
- a idempotência preserva a correção do negócio;
- a qualidade é aprovada;
- a reconciliação é aprovada;
- a certificação se comporta corretamente;
- o estado visível aos consumidores corresponde à arquitetura.

Um teste não deve ser considerado PASS apenas porque o componente que falhou foi iniciado novamente.

### 20.9 Critérios de FAIL

Condições representativas de FAIL incluem:

- a falha não pode ser reproduzida conforme pretendido;
- o histórico necessário é perdido inesperadamente;
- o *checkpoint* ignora entradas não processadas;
- surge um efeito de negócio duplicado;
- o *backlog* não consegue convergir;
- uma fonte de recuperação incorreta é necessária;
- um estado inválido torna-se Certified Gold;
- o *rollback* falha;
- a qualidade ou a reconciliação permanece inválida;
- o consumidor visualiza um estado misto de publicação;
- as evidências necessárias não estão disponíveis.

FAIL é um resultado de engenharia, não um problema de documentação.

Ele deve conduzir à investigação e à remediação.

### 20.10 Critérios de Resultado Inconclusivo

Um teste deve ser registrado como inconclusivo quando o comportamento pretendido não puder ser avaliado de forma confiável.

Possíveis razões incluem:

- falha de telemetria;
- linha de base inválida;
- falha não relacionada e descontrolada;
- carga de trabalho insuficiente;
- injeção de falha malsucedida;
- evidências ausentes;
- ambiente alterado durante a execução.

Um resultado inconclusivo não deve ser convertido em PASS.

### 20.11 Limite da Injeção de Falha

O teste deve identificar o limite exato que está sendo interrompido.

Exemplos incluem:

**Componente**
→ interromper o Debezium.

**Dependência**
→ impedir que a Bronze acesse o MinIO.

**Processamento**
→ introduzir uma falha controlada na transformação da Silver.

**Dados**
→ introduzir uma entrada venenosa controlada.

**Publicação**
→ interromper a publicação antes que a promoção seja concluída.

A definição precisa do limite melhora a interpretação do raio de impacto observado.

### 20.12 Uma Falha por Vez

Os testes iniciais de confiabilidade normalmente devem injetar uma falha primária por vez.

Isso ajuda a isolar:

- causa;
- efeito;
- comportamento da recuperação;
- métricas;
- evidências.

Os testes de falhas compostas devem ocorrer depois que o comportamento individual dos componentes for compreendido.

A Versão 1 deve preferir clareza e reprodutibilidade à complexidade artificial.

### 20.13 Testes de Falhas Compostas

Depois que as falhas isoladas forem compreendidas, cenários compostos selecionados podem ser úteis.

Exemplos incluem:

**Debezium Indisponível + Retenção do CDC Envelhecendo**

**Bronze Indisponível + Backlog do Kafka Crescendo**

**Rebuild em Execução + Carga Ativa Crescendo**

**Falha de Credencial + Tentativa de Recuperação**

Os testes compostos devem responder a uma pergunta arquitetural específica.

Eles não devem existir apenas para fazer o laboratório parecer mais sofisticado.

### 20.14 Duração da Falha

A duração da falha deve ser controlada.

Durações diferentes podem testar propriedades diferentes.

Por exemplo:

**Interrupção Curta**
→ capacidade de reinicialização e *backlog* transitório.

**Interrupção Mais Longa**
→ capacidade de *catch-up*.

**Cenário de Janela de Retenção**
→ risco da fonte de recuperação.

Os testes devem evitar permitir desnecessariamente que o histórico retido necessário expire, a menos que o próprio comportamento de expiração seja o objetivo controlado.

### 20.15 Carga de Trabalho do Teste

Os testes de recuperação devem utilizar uma carga de trabalho controlada.

A carga de trabalho deve ser suficiente para produzir comportamentos observáveis, como:

- *backlog*;
- *lag*;
- atividade de partições;
- progressão *downstream*;
- *catch-up* mensurável.

Um teste com dados insuficientes pode demonstrar a reinicialização de um processo sem testar significativamente a recuperação.

A carga de trabalho deve permanecer pequena o suficiente para preservar a segurança e a repetibilidade do laboratório.

### 20.16 Dados Sintéticos de Teste

Os testes de recuperação devem preferir dados sintéticos do projeto.

Dados sintéticos oferecem suporte a cenários envolvendo:

- registros venenosos;
- correções históricas;
- comportamento de privacidade;
- transações com falha;
- *backfill* controlado;
- *replay*;
- *rebuild*.

Os testes não exigem dados pessoais reais de produção.

### 20.17 Identidade dos Dados de Teste

Os dados de teste devem ser suficientemente identificáveis para oferecer suporte a:

- linhagem;
- comparação entre origem e destino;
- validação de *replay*;
- validação de efeitos duplicados;
- limpeza.

Identificadores dedicados de teste, intervalos de transações ou intervalos de chaves de negócio podem ajudar a isolar cenários de laboratório.

### 20.18 Isolamento do Teste

Um teste de recuperação deve minimizar efeitos não pretendidos sobre estados não relacionados do laboratório.

Possíveis estratégias de isolamento incluem:

- registros dedicados na origem;
- chaves dedicadas do Kafka;
- janelas de tempo limitadas;
- grupo de consumidores dedicado;
- versão de destino isolada;
- candidata Gold dedicada;
- conjunto de dados controlado para teste.

O isolamento simplifica a limpeza e a interpretação das evidências.

### 20.19 Limpeza do Teste

Cada teste de recuperação deve definir a limpeza quando necessária.

A limpeza pode incluir:

- restaurar a configuração do serviço;
- remover condições temporárias de falha;
- revogar credenciais temporárias;
- restaurar permissões;
- excluir objetos temporários de recuperação;
- resolver registros de teste em quarentena;
- restaurar grupos de consumidores normais;
- remover destinos exclusivos de teste.

O ambiente deve retornar a um estado governado conhecido após os testes.

### 20.20 Validação da Limpeza

A própria limpeza deve ser validada.

Um teste que demonstra recuperação, mas deixa:

- permissão excessiva;
- *checkpoint* inválido;
- credenciais de teste;
- dados temporários obsoletos;
- retenção alterada;
- consumidores órfãos;

não foi concluído corretamente.

### 20.21 Teste de Reinicialização

Os testes de reinicialização validam a capacidade normal de reinicialização dos componentes.

Um fluxo representativo é:

1. estabelecer a linha de base;
2. interromper o componente selecionado;
3. preservar as evidências da falha;
4. permitir o acúmulo controlado de trabalho pendente, quando aplicável;
5. reinicializar;
6. validar o progresso recuperado;
7. validar o comportamento *downstream*;
8. preservar as evidências da recuperação.

Os testes de reinicialização devem preceder cenários mais destrutivos de *rebuild*.

### 20.22 Teste de Novas Tentativas

Os testes de novas tentativas validam o tratamento limitado de falhas transitórias.

Um teste representativo pode:

1. criar uma falha temporária de dependência;
2. observar as novas tentativas;
3. confirmar o intervalo entre as novas tentativas;
4. restaurar a dependência;
5. confirmar que o processamento é concluído com sucesso;
6. confirmar que o progresso avança;
7. confirmar que nenhum efeito de negócio duplicado ocorre.

Um segundo cenário deve validar o esgotamento das novas tentativas e a transição para o tratamento explícito de falha persistente.

### 20.23 Teste de Reentrega

Os testes de reentrega validam a idempotência.

Um cenário representativo pode processar intencionalmente a mesma entrada lógica mais de uma vez.

A validação deve demonstrar:

- ocorreu entrega duplicada;
- o processamento repetido foi observável;
- o resultado final de negócio pretendido permaneceu correto;
- nenhum fato duplicado ou efeito de negócio não pretendido foi criado.

### 20.24 Teste de Replay

Os testes de *replay* devem validar:

- limite histórico explícito;
- disponibilidade do histórico retido;
- posição controlada do consumidor;
- ordenação;
- idempotência;
- reconstrução *downstream*;
- validação final.

Um teste de *replay* deve distinguir *replay* do *catch-up* normal após uma reinicialização.

### 20.25 Teste de Reprocessamento

Os testes de reprocessamento devem validar:

**Mesma Lógica**
→ resultado histórico equivalente.

e, quando prático:

**Lógica Corrigida**
→ diferença histórica controlada esperada.

O teste deve preservar a versão de processamento selecionada e a linhagem resultante.

### 20.26 Teste de Backfill

Os testes de *backfill* devem demonstrar:

- lacuna histórica ou requisito de inicialização identificado;
- extração governada da origem;
- escopo limitado;
- impacto sobre a origem;
- sobreposição com processamento ativo, quando aplicável;
- proveniência;
- processamento *downstream*;
- reconciliação.

Um teste de *backfill* deve demonstrar por que o *replay* normal do histórico retido foi insuficiente para o cenário.

### 20.27 Teste de Rebuild

Os testes de *rebuild* devem validar a capacidade de reconstrução do estado derivado.

Destinos representativos incluem:

- Silver a partir da Bronze;
- Gold a partir da Silver.

O teste deve demonstrar:

- estratégia de destino limpo;
- fonte *upstream* selecionada;
- versão de processamento;
- progresso;
- capacidade de reinicialização, quando aplicável;
- qualidade;
- reconciliação;
- estado final.

### 20.28 Teste de Rebuild Interrompido

Uma afirmação de capacidade de *rebuild* deve incluir o comportamento de interrupção quando prático.

Um teste representativo pode:

1. iniciar um *rebuild* de múltiplos lotes;
2. interrompê-lo deliberadamente;
3. preservar o progresso parcial;
4. reinicializar ou retomar;
5. concluir a reconstrução;
6. validar o resultado final.

Isso demonstra que a capacidade de *rebuild* não depende de uma única execução longa e ininterrupta.

### 20.29 Teste de Recuperação de Backlog

Os testes de *backlog* devem medir:

- duração da falha;
- *backlog* acumulado;
- idade do item pendente mais antigo;
- taxa de entrada;
- taxa de processamento da recuperação;
- razão de *catch-up*;
- tempo até a faixa operacional normal.

Esse teste fornece evidências diretas para análise de capacidade e RTO.

### 20.30 Teste de Registro Venenoso

Os testes de falha persistente devem demonstrar:

- novas tentativas limitadas;
- esgotamento das novas tentativas;
- estado explícito de falha;
- isolamento ou bloqueio seguro;
- entrada preservada;
- remediação;
- reprocessamento;
- reintegração;
- completude final.

O teste não deve apenas mostrar que o erro aparece em um *log*.

### 20.31 Teste de Isolamento de Partição

Quando o particionamento do Kafka for utilizado, a Versão 1 deve validar que uma falha controlada em uma partição não interrompa desnecessariamente partições independentes, preservando ao mesmo tempo a ordenação necessária.

As evidências devem incluir:

- partição afetada;
- progresso das partições não afetadas;
- estado do *checkpoint*;
- *backlog*;
- recuperação;
- ordenação e completude finais.

### 20.32 Teste de Falha de Certificação

Uma candidata Gold controlada deve falhar em uma condição bloqueante de qualidade ou reconciliação.

Comportamento esperado:

**Candidata**
→ permanece não publicada.

**Certified Gold Anterior**
→ permanece visível aos consumidores.

O teste valida o comportamento de publicação com falha segura, e não apenas a execução das regras de qualidade.

### 20.33 Teste de Falha de Publicação

Os testes de falha de publicação devem validar o requisito de atomicidade visível aos consumidores.

Uma falha controlada deve ocorrer ao redor do limite de publicação.

O teste deve demonstrar que os consumidores observam:

- versão anterior;

ou:

- nova versão completa;

mas não um estado misto descontrolado.

### 20.34 Teste de Rollback

Os testes de *rollback* devem demonstrar:

- nova versão certificada publicada;
- defeito controlado ou invalidação declarada;
- versão anterior permanece retida;
- *rollback* é executado;
- versão inválida deixa de estar ativa;
- consumidor pode acessar a versão de *rollback*;
- metadados correspondem ao estado físico.

### 20.35 Teste de Roll-Forward

Após o *rollback*, uma candidata corrigida deve ser produzida.

O teste deve demonstrar:

**Rollback**
→ remediação  
→ *rebuild* ou reprocessamento  
→ nova candidata  
→ certificação  
→ publicação  
→ estado atual restaurado.

Isso valida que o *rollback* é um limite temporário de recuperação, e não o mecanismo final de correção.

### 20.36 Teste do Limite de Retenção

Os testes relacionados à retenção devem demonstrar o efeito do histórico limitado.

A Versão 1 pode testar isso com segurança utilizando dados descartáveis de teste e retenção reduzida no laboratório, quando apropriado.

O objetivo pode ser demonstrar:

- histórico disponível dentro da retenção;
- *replay* possível;
- histórico indisponível após expiração controlada;
- a fonte de recuperação deve mudar.

Os dados necessários do projeto não devem ser intencionalmente destruídos apenas para demonstrar o conceito.

### 20.37 Teste de Versão Histórica

Os testes de versão histórica devem validar pelo menos um cenário envolvendo:

- contrato de evento anterior;
- versão anterior de processamento;
- contexto de referência alterado;
- reprodução versus reapresentação.

O teste deve demonstrar que a recuperação histórica considera versões de forma explícita.

### 20.38 Teste de Falha de Observabilidade

Uma falha controlada de observabilidade pode validar que:

- o processamento de dados permanece distinguível da disponibilidade do monitoramento;
- lacunas de telemetria são visíveis;
- a recuperação ainda pode utilizar outros estados, como *checkpoints* e *logs*;
- a ausência de observabilidade reduz a confiança, mas não implica automaticamente perda de dados.

O teste não deve desabilitar intencionalmente as evidências necessárias para avaliar um cenário destrutivo crítico.

### 20.39 Teste de Falha Ponta a Ponta

Depois que o comportamento individual dos componentes for validado, a Versão 1 deve executar pelo menos um cenário de recuperação ponta a ponta.

Um teste representativo pode:

1. estabelecer uma linha de base limpa da origem até a Certified Gold;
2. interromper um componente significativo de processamento;
3. continuar a atividade controlada na origem;
4. observar a degradação *downstream*;
5. recuperar o componente;
6. observar a cascata do *backlog*;
7. validar a Bronze;
8. validar a Silver;
9. validar a Gold;
10. validar a certificação;
11. validar a atualidade da Certified Gold;
12. preservar a linha do tempo completa da recuperação.

Isso fornece uma demonstração sólida da arquitetura no nível de portfólio.

### 20.40 Repetição dos Testes

Testes importantes de recuperação devem ser repetidos quando prático.

Um único PASS demonstra uma execução bem-sucedida.

Resultados PASS repetidos fornecem evidências mais fortes de comportamento previsível.

Testes envolvendo tempo devem ser repetidos o suficiente para identificar variações antes que qualquer estimativa representativa de recuperação seja apresentada.

### 20.41 Repetibilidade

Um teste repetível deve definir:

- estado inicial;
- carga de trabalho;
- injeção de falha;
- duração;
- ação de recuperação;
- consultas de validação;
- limpeza.

Outra execução sob condições equivalentes de laboratório deve ser capaz de reproduzir o cenário.

### 20.42 Automação dos Testes

Testes de recuperação adequados podem eventualmente ser automatizados.

Candidatos incluem:

- interrupção de serviço;
- geração de carga de trabalho de teste;
- captura de *offsets*;
- medição de *backlog*;
- validação da qualidade;
- reconciliação;
- avaliação de PASS/FAIL;
- coleta de evidências.

A automação deve ser introduzida somente depois que o comportamento manual da recuperação for compreendido.

Automatizar um procedimento pouco compreendido pode tornar um comportamento incorreto repetível, em vez de correto.

### 20.43 Testes Manuais

Alguns cenários de laboratório podem permanecer manuais porque exigem:

- diagnóstico;
- interpretação da arquitetura;
- ação destrutiva controlada;
- observação visual;
- seleção deliberada da fonte de recuperação.

Testes manuais permanecem válidos quando seus procedimentos e resultados esperados são documentados claramente.

### 20.44 Segurança dos Testes

Os testes de recuperação devem proteger o laboratório contra impactos destrutivos desnecessários.

Antes de um cenário destrutivo, o teste deve determinar:

- qual estado pode ser perdido;
- se esse estado é reproduzível;
- se existe *backup* quando necessário;
- se o cenário pode afetar trabalho não relacionado;
- como a limpeza será realizada.

Um teste não deve destruir intencionalmente a única cópia de dados necessária para a continuidade do desenvolvimento do projeto.

### 20.45 Limite de Segurança da Injeção de Falha

A injeção de falha deve ser interrompida quando um comportamento inesperado ameaçar:

- estado irrecuperável do projeto;
- dados de desenvolvimento não relacionados;
- estabilidade do *host*;
- integridade da origem;
- histórico necessário para recuperação.

A resposta correta é interromper o teste, preservar as evidências, compreender a condição inesperada e reprojetar o experimento.

### 20.46 Catálogo de Testes de Recuperação

A Atlas Engineering deve manter um catálogo de testes de recuperação.

Um catálogo representativo pode incluir:

| Categoria | Exemplo |
|---|---|
| Reinicialização | Reinicialização do consumidor da Bronze |
| Nova Tentativa | Falha temporária do MinIO |
| Reentrega | Entrega duplicada do Kafka |
| Replay | Replay controlado de intervalo do Kafka |
| Reprocessamento | Lógica corrigida da Silver |
| Backfill | Intervalo limitado ausente na origem |
| Rebuild | Silver a partir da Bronze |
| Catch-Up | Recuperação do backlog do Kafka |
| Registro Venenoso | Falha determinística de transformação |
| Isolamento | Falha específica de partição |
| Certificação | Falha bloqueante da candidata |
| Publicação | Interrupção da publicação atômica |
| Rollback | Restauração da Certified Gold anterior |
| Versão Histórica | Replay de contrato anterior |
| Ponta a Ponta | Recuperação da origem ao consumidor |

Cada entrada do catálogo deve referenciar sua definição formal de teste e suas evidências após a implementação.

### 20.47 Nomenclatura dos Testes

Identificadores estáveis devem ser utilizados para os testes de recuperação.

Uma convenção possível é:

- `REL-RST-*` — Reinicialização;
- `REL-RTY-*` — Nova Tentativa;
- `REL-RDL-*` — Reentrega;
- `REL-RPL-*` — Replay;
- `REL-RPR-*` — Reprocessamento;
- `REL-BFL-*` — Backfill;
- `REL-RBL-*` — Rebuild;
- `REL-BLG-*` — Backlog / Catch-Up;
- `REL-PSN-*` — Registros Venenosos;
- `REL-ISO-*` — Isolamento de Falhas;
- `REL-CFG-*` — Certified Gold / Publicação;
- `REL-HST-*` — Versões Históricas;
- `REL-E2E-*` — Recuperação Ponta a Ponta.

A convenção exata de nomenclatura pode ser refinada durante a implementação.

Os IDs estáveis devem permanecer consistentes depois que forem referenciados por evidências ou pela documentação do FAQ.

### 20.48 Registro do Teste

Cada teste de recuperação deve manter um registro estruturado contendo, quando aplicável:

- ID do Teste;
- Nome do Teste;
- Objetivo;
- Requisito da Arquitetura;
- Ambiente;
- Estado Inicial;
- Carga de Trabalho;
- Injeção de Falha;
- Impacto Esperado;
- Recuperação Esperada;
- Critérios de PASS;
- Critérios de FAIL;
- Fonte de Recuperação;
- Limite de Recuperação;
- Ação de Recuperação;
- Validação;
- Limpeza;
- Resultado;
- Observações;
- Referências das Evidências.

Essa estrutura oferece suporte à consistência entre os testes de laboratório.

### 20.49 Evidências dos Testes

As evidências podem incluir:

- *logs* estruturados;
- saída de consultas SQL;
- *offsets* do Kafka;
- *lag* dos consumidores;
- *checkpoints* de processamento;
- métricas do Prometheus;
- capturas do Grafana;
- resultados de qualidade;
- saída da reconciliação;
- metadados de certificação;
- histórico de publicação;
- consultas dos consumidores.

As evidências devem ser selecionadas de acordo com a afirmação arquitetural que está sendo demonstrada.

### 20.50 Resultado do Teste

Todo teste concluído deve possuir um resultado explícito:

**PASS**

**FAIL**

ou:

**INCONCLUSIVO**

Uma descrição como:

**“Funcionou na maior parte.”**

não é um estado final válido para o teste.

As observações podem explicar nuances, mas o resultado do teste deve permanecer explícito.

### 20.51 Fluxo de Teste com Falha

Um FAIL deve seguir:

**FAIL**
→ preservar evidências  
→ investigar  
→ identificar a causa raiz  
→ decidir se a implementação ou a arquitetura está incorreta  
→ remediar  
→ atualizar a documentação quando necessário  
→ executar o teste novamente.

As evidências originais da falha devem permanecer disponíveis quando úteis.

### 20.52 Correção da Arquitetura

Os testes de recuperação podem demonstrar que a arquitetura documentada está incorreta.

Por exemplo:

- o comportamento selecionado do *checkpoint* cria omissão;
- a retenção do Kafka é insuficiente;
- a capacidade de *catch-up* não consegue convergir;
- a Silver não pode ser reconstruída a partir da representação retida da Bronze;
- o mecanismo de *rollback* não é atômico.

A resposta correta é alterar a arquitetura ou a implementação.

O resultado esperado não deve ser reescrito apenas para preservar o projeto original.

### 20.53 Descobertas de Capacidade

Os testes de recuperação podem produzir evidências de capacidade, como:

- taxa sustentada de processamento;
- taxa máxima observada de *catch-up*;
- gargalo de CPU ou memória;
- vazão de armazenamento;
- assimetria de partições;
- gargalo de escrita no banco de dados.

Essas descobertas devem alimentar:

- ajuste de performance;
- planejamento de capacidade;
- avaliação futura de RTO;
- evolução corporativa.

### 20.54 Linha de Base de Confiabilidade

Depois que os principais testes da Versão 1 forem executados, a Atlas Engineering deve manter uma linha de base de confiabilidade descrevendo quais capacidades estão:

- projetadas;
- implementadas;
- testadas;
- demonstradas;
- parcialmente demonstradas;
- não implementadas;
- planejadas para evolução corporativa.

A linha de base deve ser específica.

Ela não deve resumir a plataforma utilizando um rótulo genérico sem sustentação, como:

**Altamente Disponível**

ou:

**Pronta para Produção**.

### 20.55 Revisão dos Testes de Recuperação

O catálogo de testes de recuperação deve ser revisado quando:

- a arquitetura mudar;
- a semântica do processamento mudar;
- a retenção mudar;
- novos componentes forem introduzidos;
- os produtos Gold mudarem;
- novos mecanismos de recuperação forem implementados;
- um defeito significativo for encontrado;
- a evolução corporativa alterar a topologia.

Testes anteriormente aprovados podem se tornar testes de regressão para versões posteriores.

### 20.56 Testes de Regressão de Recuperação

Comportamentos importantes de confiabilidade devem ser revalidados após alterações materiais.

Cenários representativos de regressão incluem:

- reinicialização de consumidor;
- entrega duplicada;
- *replay*;
- *rebuild* da Silver;
- *rollback* da Gold;
- *catch-up* do *backlog*.

Um PASS histórico não comprova que uma implementação posterior ainda se comporte da mesma forma.

### 20.57 Laboratório versus Chaos Engineering

Os testes de recuperação da Versão 1 não devem ser descritos como *chaos engineering* corporativo apenas porque falhas são injetadas intencionalmente.

O laboratório executa:

**Testes Controlados de Falhas**

com:

- cenários limitados;
- estado inicial conhecido;
- hipótese explícita;
- recuperação definida;
- evidências.

O *chaos engineering* corporativo pode envolver experimentação automatizada mais ampla, plataformas de resiliência, topologia semelhante à produção e testes contínuos de hipóteses.

Os conceitos são relacionados, mas as afirmações devem permanecer proporcionais à implementação.

### 20.58 Garantias dos Testes de Recuperação

O modelo de testes de recuperação da Atlas Engineering deve preservar as seguintes garantias:

1. o comportamento da recuperação é validado por meio de testes controlados de falhas;
2. os testes começam a partir de uma linha de base conhecida e confiável;
3. o comportamento esperado e o raio de impacto são definidos antes da injeção da falha;
4. os critérios de PASS, FAIL e INCONCLUSIVO são explícitos;
5. a injeção de falhas é limitada, reversível e segura para o laboratório;
6. os testes iniciais preferem uma falha primária por vez;
7. falhas compostas são testadas somente quando respondem a uma pergunta arquitetural definida;
8. a duração da falha é controlada de acordo com a propriedade que está sendo testada;
9. as cargas de trabalho são grandes o suficiente para produzir comportamento significativo de recuperação, mas permanecem seguras para a Versão 1;
10. dados sintéticos de teste são preferidos;
11. os dados de teste e o escopo do teste permanecem identificáveis;
12. o isolamento e a limpeza dos testes preservam o estado governado do laboratório;
13. comportamentos de reinicialização, nova tentativa, reentrega, *replay*, reprocessamento, *backfill*, *rebuild*, *catch-up*, registro venenoso, isolamento, certificação, publicação, *rollback* e versão histórica são testados de acordo com suas semânticas distintas;
14. cenários interrompidos de *rebuild* e recuperação validam a capacidade de reinicialização quando prático;
15. testes de *backlog* medem convergência, e não apenas disponibilidade do serviço;
16. testes de publicação validam a atomicidade visível aos consumidores;
17. o *rollback* é seguido por testes de *roll-forward* quando apropriado;
18. testes do limite de retenção não destroem desnecessariamente o histórico necessário do projeto;
19. testes de versões históricas validam o comportamento real de interpretação;
20. pelo menos um cenário significativo de recuperação ponta a ponta é executado depois que o comportamento dos componentes é compreendido;
21. testes importantes de recuperação são repetíveis quando prático;
22. a automação segue a compreensão, em vez de substituí-la;
23. testes destrutivos preservam um limite de segurança definido;
24. os testes de recuperação utilizam identificadores estáveis e registros estruturados de teste;
25. todo teste concluído possui um resultado explícito;
26. testes com falha conduzem à investigação, remediação e revalidação;
27. as evidências podem levar à alteração da arquitetura;
28. os testes de recuperação contribuem com descobertas de capacidade e performance;
29. a Versão 1 mantém uma linha de base de confiabilidade específica e baseada em evidências;
30. comportamentos importantes de confiabilidade tornam-se testes de regressão após alterações materiais;
31. testes controlados de falhas em laboratório não são apresentados incorretamente como *chaos engineering* corporativo;
32. as afirmações sobre testes de recuperação permanecem limitadas aos cenários efetivamente implementados, executados e sustentados por evidências.

---

## 21. Observabilidade da Recuperação

A recuperação da Atlas Engineering deve ser observável.

A plataforma deve fornecer informações de *runtime* suficientes para determinar:

- se um componente está operacional;
- se o processamento está avançando;
- se o *backlog* está se acumulando;
- se as novas tentativas estão sendo bem-sucedidas ou se esgotando;
- se os *checkpoints* permanecem consistentes;
- se as janelas de recuperação estão diminuindo;
- se a atualidade *downstream* está se degradando;
- se a recuperação está convergindo;
- se a Certified Gold permanece confiável e disponível.

O modelo orientador é:

**Detectar → Localizar → Medir → Recuperar → Observar Progresso → Validar → Confirmar Estado Normal**

A observabilidade não substitui a lógica de recuperação.

Ela fornece as informações necessárias para compreender quando a recuperação é necessária, se o mecanismo selecionado está funcionando e quando a capacidade afetada pode ser considerada restaurada.

### 21.1 Escopo da Observabilidade da Recuperação

A observabilidade da recuperação deve abranger, quando aplicável:

- saúde do serviço;
- saúde das dependências;
- progresso do processamento;
- *checkpoints*;
- *lag* dos consumidores;
- *backlog*;
- atividade de novas tentativas;
- falhas persistentes;
- quarentena;
- estado da janela de recuperação;
- vazão;
- latência de processamento;
- atualidade;
- qualidade;
- reconciliação;
- certificação;
- publicação;
- disponibilidade para consumidores.

O conjunto exato de sinais depende do componente e da responsabilidade de processamento.

### 21.2 Saúde do Serviço

A saúde do serviço indica se um componente está operacional do ponto de vista técnico.

Estados representativos podem incluir:

- em execução;
- interrompido;
- degradado;
- indisponível;
- reinicializando.

A saúde do serviço é útil, mas insuficiente por si só.

Um serviço pode reportar estado saudável enquanto:

- o processamento está paralisado;
- os *checkpoints* não estão avançando;
- o *backlog* está crescendo;
- os dados *downstream* estão desatualizados.

### 21.3 Saúde das Dependências

Um serviço pode estar saudável enquanto uma de suas dependências necessárias está indisponível.

A observabilidade da recuperação deve, portanto, distinguir:

**Saúde do Componente**

de:

**Saúde da Dependência**.

Dependências relevantes podem incluir:

- SQL Server;
- Kafka;
- MinIO;
- AtlasWarehouse;
- *schema registry*;
- autenticação;
- caminho de rede.

Essa distinção oferece suporte à identificação mais rápida da causa raiz.

### 21.4 Progresso do Processamento

O progresso do processamento deve ser observável quando necessário para recuperação.

Indicadores relevantes podem incluir:

- posição do CDC;
- *offset* do Kafka;
- *checkpoint* do consumidor;
- intervalo processado;
- identificador do lote;
- *watermark*;
- versão da candidata Gold;
- estado da certificação.

Um estágio de processamento saudável deve demonstrar progresso real, e não apenas tempo de atividade do processo.

### 21.5 Observabilidade do Checkpoint

O estado do *checkpoint* deve estar disponível para análise da recuperação.

Informações úteis podem incluir:

- *checkpoint* confirmado atual;
- *checkpoint* anterior;
- momento do último avanço;
- partição ou escopo afetado;
- versão de processamento.

Um *checkpoint* que não avançou por um intervalo incomum pode indicar:

- processamento bloqueado;
- falha de dependência;
- falha persistente de entrada;
- execução paralisada.

### 21.6 Desatualização do Checkpoint

A idade do *checkpoint* é um sinal importante de confiabilidade.

Conceitualmente:

**Idade do Checkpoint**
=
**Tempo Atual - Última Confirmação Bem-Sucedida de Progresso**

Um *checkpoint* antigo pode indicar processamento paralisado mesmo quando a saúde do serviço permanece verde.

A idade esperada depende da carga de trabalho e da cadência de processamento.

### 21.7 Lag do Consumidor Kafka

O *lag* do consumidor Kafka representa a diferença entre:

**Offset Disponível Mais Recente**

e:

**Offset Confirmado pelo Consumidor**

para um grupo de consumidores e uma partição.

O *lag* é um sinal primário de:

- *backlog*;
- interrupção do processamento;
- vazão insuficiente;
- progresso do *catch-up*.

O *lag* agregado não deve ocultar problemas específicos de partição.

### 21.8 Lag por Partição

O *lag* por partição deve permanecer visível quando o processamento do Kafka depender da ordenação das partições.

Uma partição pode permanecer significativamente atrasada enquanto o grupo de consumidores aparenta estar saudável de forma agregada.

Informações relevantes podem incluir:

- partição;
- *offset* atual;
- *offset* final;
- *lag*;
- idade do evento pendente mais antigo.

Isso ajuda a detectar assimetria e falha parcial.

### 21.9 Profundidade do Backlog

A profundidade do *backlog* mede quanto trabalho recuperável permanece pendente.

Possíveis medidas incluem:

- eventos;
- registros;
- arquivos;
- bytes;
- intervalos de processamento;
- lotes pendentes.

A profundidade do *backlog* deve ser interpretada em conjunto com a idade e a taxa de processamento, e não como um número isolado.

### 21.10 Idade do Item Pendente Mais Antigo

A idade do trabalho pendente mais antigo indica há quanto tempo os primeiros dados não processados estão aguardando.

Isso geralmente é mais significativo para a atualidade do que apenas a contagem do *backlog*.

Uma idade crescente do item pendente mais antigo indica que o processamento não está convergindo para o estado atual.

### 21.11 Tendência do Backlog

A observabilidade da recuperação deve distinguir:

**Crescendo**
→ o *backlog* aumenta.

**Estável**
→ o *backlog* permanece aproximadamente inalterado.

**Diminuindo**
→ o *catch-up* está ocorrendo.

A tendência fornece evidência direta de que a recuperação está ou não convergindo.

### 21.12 Taxa de Entrada

A taxa de entrada mede a velocidade com que novos trabalhos entram no limite de processamento afetado.

Exemplos incluem:

- alterações do CDC por segundo;
- eventos do Kafka por segundo;
- registros da Bronze por intervalo;
- volume de entrada da Silver.

A taxa de entrada fornece contexto para interpretar o *backlog* e o comportamento do *catch-up*.

### 21.13 Taxa de Processamento

A taxa de processamento mede a vazão efetiva do estágio de processamento afetado.

Exemplos incluem:

- eventos do Kafka processados por segundo;
- registros da Bronze persistidos por segundo;
- registros da Silver transformados por segundo;
- linhas ou lotes da Gold gerados por intervalo.

A taxa de processamento deve ser interpretada em conjunto com a taxa de entrada.

### 21.14 Razão de Catch-Up

A observabilidade da recuperação pode expor:

**Razão de Catch-Up = Taxa de Processamento / Taxa de Entrada**

Interpretação:

**< 1**
→ o *backlog* cresce.

**≈ 1**
→ o *backlog* permanece estável.

**> 1**
→ o *backlog* pode diminuir.

Essa razão é especialmente útil durante a recuperação do *backlog*.

### 21.15 Progresso do Catch-Up

O progresso do *catch-up* deve indicar se o estágio de processamento está convergindo para o limite *upstream* atual.

Sinais úteis podem incluir:

- *backlog* inicial;
- *backlog* atual;
- taxa de redução do *backlog*;
- idade do item pendente mais antigo;
- trabalho restante estimado;
- tempo decorrido de recuperação.

A conclusão estimada deve permanecer claramente distinguível da conclusão observada.

### 21.16 Observabilidade das Novas Tentativas

A atividade de novas tentativas deve expor, quando aplicável:

- contagem de novas tentativas;
- categoria do erro;
- operação afetada;
- momento da primeira falha;
- momento da falha mais recente;
- próxima nova tentativa;
- *backoff*;
- estado de esgotamento das novas tentativas.

Alta atividade de novas tentativas pode indicar um problema de dependência mesmo antes que ocorra uma falha completa de processamento.

### 21.17 Esgotamento das Novas Tentativas

O esgotamento das novas tentativas deve se tornar um estado observável explícito.

A plataforma deve conseguir identificar:

- entrada ou operação afetada;
- política de novas tentativas esgotada;
- classificação da falha;
- estado de falha persistente resultante;
- remediação necessária.

O esgotamento das novas tentativas não deve desaparecer em *logs* genéricos de erro.

### 21.18 Observabilidade de Falhas Persistentes

Falhas persistentes devem expor informações suficientes para determinar:

- estágio de processamento afetado;
- identidade ou escopo da entrada;
- categoria do erro;
- idade;
- histórico de novas tentativas;
- impacto *downstream*;
- estado da remediação.

Falhas repetidas que compartilhem características comuns devem poder ser correlacionadas quando prático.

### 21.19 Observabilidade da Quarentena

A quarentena deve expor, quando aplicável:

- contagem de itens não resolvidos;
- item em quarentena mais antigo;
- taxa de crescimento;
- categorias de falha;
- entidades afetadas;
- estágios de processamento afetados;
- estado da remediação;
- estado da recuperação.

Um *backlog* normal baixo não implica processamento saudável quando a quarentena continua crescendo.

### 21.20 Observabilidade de Lacunas de Processamento

Quando viável, a plataforma deve evidenciar suspeitas de lacunas de processamento.

Os sinais podem incluir:

- *offsets* ausentes;
- intervalos de processamento ausentes;
- diferenças de reconciliação;
- descontinuidade entre origem e destino;
- linhagem incompleta.

Uma lacuna é uma condição de correção e não deve ser reduzida a uma métrica comum de performance.

### 21.21 Observabilidade da Janela de Recuperação

Fontes de recuperação limitadas devem expor informações suficientes para compreender quanto tempo de recuperação permanece disponível.

Fontes relevantes incluem:

- CDC;
- Kafka;
- *backups*;
- arquivos históricos, quando aplicável.

A plataforma deve ser capaz de avaliar se o histórico necessário ainda não processado está se aproximando da expiração.

### 21.22 Margem da Janela de Recuperação

Quando prático, a plataforma pode expor:

**Margem da Janela de Recuperação**
→ tempo restante antes que o estado recuperável necessário mais antigo expire.

Uma margem em redução pode exigir prioridade operacional maior do que um *backlog* grande, porém estável, com amplo histórico retido.

### 21.23 Sinais de Recuperação do CDC

A observabilidade da confiabilidade do CDC pode incluir:

- estado da captura;
- última posição capturada da origem;
- latência da captura;
- janela de alterações retidas;
- progresso do Debezium em relação à origem;
- alteração necessária não capturada mais antiga.

O objetivo é detectar quando a capacidade de recuperação das alterações da origem está se degradando antes que o histórico expire.

### 21.24 Sinais de Recuperação do Debezium

Sinais relevantes do Debezium podem incluir:

- estado do *connector*;
- estado da tarefa;
- posição da origem;
- taxa de publicação de eventos;
- taxa de erros;
- contagem de reinicializações;
- falhas de autenticação;
- falhas de publicação no Kafka.

Um *connector* reportando `RUNNING` sem avançar sua posição na origem não deve ser considerado saudável.

### 21.25 Sinais de Recuperação do Kafka

Sinais de confiabilidade do Kafka podem incluir:

- disponibilidade do *broker*;
- disponibilidade das partições;
- taxa de erros do produtor;
- *lag* dos consumidores;
- idade do histórico retido;
- utilização de armazenamento;
- partições sub-replicadas em topologias corporativas;
- saúde dos grupos de consumidores.

A Versão 1 pode expor um subconjunto apropriado à sua topologia de laboratório com nó único.

### 21.26 Sinais de Recuperação da Bronze

A observabilidade da recuperação da Bronze pode incluir:

- *offsets* de entrada;
- contagem de registros persistidos;
- falhas de escrita;
- latência de armazenamento;
- *checkpoint*;
- *backlog*;
- estado do tratamento de duplicidades;
- versão de processamento;
- momento da última persistência bem-sucedida.

Esses sinais oferecem suporte à validação de que o histórico do Kafka está se tornando histórico analítico durável.

### 21.27 Sinais de Recuperação da Silver

A observabilidade da recuperação da Silver pode incluir:

- limite de entrada;
- *checkpoint*;
- taxa de processamento;
- intervalos pendentes da Bronze;
- falhas de transformação;
- quarentena;
- estado da qualidade;
- último limite bem-sucedido da Silver;
- versão de processamento.

A Silver não deve aparentar estar atualizada quando seu *checkpoint* permanecer materialmente atrás da Bronze.

### 21.28 Sinais de Recuperação da Gold

A observabilidade da recuperação da Gold pode incluir:

- último limite de entrada da Silver;
- estado da construção da candidata;
- versão de processamento;
- completude da candidata;
- resultado da qualidade;
- resultado da reconciliação;
- estado da certificação.

`BUILD SUCCESS` da Gold é apenas um estado dentro do ciclo mais amplo de recuperação analítica.

### 21.29 Sinais de Certificação

A observabilidade da certificação deve expor:

- versão da candidata;
- estado da validação bloqueante;
- estado da qualidade;
- estado da reconciliação;
- estado da linhagem;
- resultado da certificação;
- tempo aguardando certificação.

Isso permite que os operadores distingam:

**Processamento da Gold Concluído**

de:

**Produto Certificado Pronto**.

### 21.30 Sinais de Publicação

A observabilidade da publicação deve expor, quando aplicável:

- versão certificada ativa;
- versão da candidata;
- estado da publicação;
- momento da publicação;
- versão anterior;
- estado do *rollback*;
- falha de publicação.

Os metadados e o estado físico visível aos consumidores devem permanecer consistentes.

### 21.31 Atualidade da Certified Gold

A Certified Gold deve expor o contexto de atualidade.

Informações úteis podem incluir:

- versão ativa;
- último limite da origem representado;
- *timestamp* da certificação;
- *timestamp* da publicação;
- idade da atualidade;
- objetivo esperado de atualidade.

Um produto pode, portanto, ser classificado como disponível, porém desatualizado.

### 21.32 Sinais de Disponibilidade para Consumidores

A confiabilidade voltada aos consumidores deve distinguir:

- produto acessível;
- produto consultável;
- versão disponível;
- estado da atualidade;
- estado do *rollback*;
- certificação bloqueada;
- produto indisponível.

Isso oferece suporte à disponibilidade analítica no nível do produto, em vez de um único estado global da plataforma.

### 21.33 Estado da Recuperação

As operações de recuperação devem expor um estado explícito de recuperação quando útil.

Estados representativos podem incluir:

**DETECTADO**

**CONTIDO**

**EM RECUPERAÇÃO**

**REALIZANDO CATCH-UP**

**VALIDANDO**

**CERTIFICAÇÃO PENDENTE**

**RECUPERADO**

**FALHOU**

A implementação exata pode utilizar nomes diferentes.

O requisito arquitetural é tornar compreensível a progressão da recuperação.

### 21.34 Linha do Tempo da Recuperação

A observabilidade da recuperação deve oferecer suporte à reconstrução de marcos importantes, como:

- início da falha;
- detecção;
- início da recuperação;
- restauração do serviço;
- retomada do processamento;
- conclusão do *catch-up*;
- conclusão da validação;
- certificação;
- publicação;
- restauração da atualidade.

Essa linha do tempo oferece suporte tanto à análise de RTO quanto à revisão pós-incidente.

### 21.35 Gargalo da Recuperação

O gargalo atual da recuperação deve ser identificável quando prático.

Durante uma sequência de recuperação, o gargalo pode se mover por:

**Debezium**
→ **Bronze**
→ **Silver**
→ **Gold**
→ **Certificação**

Identificar o gargalo ativo ajuda a evitar que o esforço de otimização permaneça concentrado em um componente que já se recuperou.

### 21.36 Convergência da Recuperação

A recuperação está convergindo quando a plataforma está se movendo em direção ao seu estado governado esperado.

Sinais representativos de convergência incluem:

- *backlog* diminuindo;
- idade do item pendente mais antigo diminuindo;
- *checkpoints* avançando;
- novas tentativas diminuindo;
- quarentena estável ou sendo resolvida;
- camadas *downstream* avançando;
- atualidade melhorando.

Um serviço que permanece em execução enquanto esses sinais não melhoram pode não estar se recuperando.

### 21.37 Paralisação da Recuperação

Uma paralisação da recuperação ocorre quando o progresso cessa antes que o estado esperado seja restaurado.

Possíveis sinais incluem:

- *backlog* inalterado;
- *checkpoint* inalterado;
- esgotamento das novas tentativas;
- uma partição permanentemente atrasada;
- certificação aguardando indefinidamente;
- estágio *downstream* deixando de avançar.

A paralisação da recuperação deve passar do monitoramento normal para investigação ou escalonamento.

### 21.38 Regressão da Recuperação

A observabilidade da recuperação pode revelar que uma versão posterior da plataforma se recupera pior do que uma anterior.

Exemplos incluem:

- *catch-up* mais lento;
- aumento da taxa de novas tentativas;
- maior duração do *rebuild*;
- maior consumo de recursos;
- maior atraso de certificação.

A regressão deve ser avaliada em relação às evidências anteriores, em vez de ser ocultada por alterações em *dashboards* ou limites.

### 21.39 Recuperação e SLOs

A observabilidade da confiabilidade fornece as medições necessárias para avaliar objetivos de nível de serviço.

Dimensões relevantes podem incluir:

- atualidade;
- latência de processamento;
- disponibilidade;
- tempo de recuperação;
- idade do *backlog*.

As definições de SLO devem se basear no comportamento medido da plataforma.

*Dashboards* detalhados de SLO e políticas de alertas pertencem à **Observabilidade**.

### 21.40 Recuperação e RPO

A observabilidade da recuperação deve ajudar a identificar o estado mais recente que permanece:

- capturado;
- retido;
- processado;
- certificado.

Isso oferece suporte à determinação baseada em evidências do ponto de recuperação alcançado.

O RPO deve permanecer vinculado ao estado real dos dados, e não ao tempo de atividade genérico do serviço.

### 21.41 Recuperação e RTO

A observabilidade da recuperação deve oferecer suporte à medição de:

- tempo de detecção;
- atraso de intervenção;
- restauração técnica;
- recuperação do processamento;
- *catch-up*;
- validação;
- recuperação do consumidor.

Isso impede que o RTO seja incorretamente reduzido ao tempo de reinicialização do serviço.

### 21.42 Princípios de Alertas

Os alertas relacionados à recuperação devem se concentrar em condições que exigem ação ou atenção.

Condições representativas incluem:

- componente indisponível;
- progresso do processamento interrompido;
- *backlog* crescendo continuamente;
- esgotamento das novas tentativas;
- crescimento da quarentena;
- idade do item pendente mais antigo aumentando;
- margem de retenção diminuindo;
- uma partição materialmente atrasada;
- *catch-up* paralisado;
- certificação bloqueada;
- falha de publicação;
- atualidade da Certified Gold fora do esperado.

Os limites exatos pertencem à **Observabilidade**.

### 21.43 Severidade dos Alertas

A severidade dos alertas de recuperação deve refletir a consequência arquitetural.

Os fatores podem incluir:

- risco de perda de dados;
- risco da janela de recuperação;
- impacto na correção;
- impacto nos consumidores;
- duração;
- criticidade do produto;
- disponibilidade de um estado certificado reconhecidamente válido.

Um aviso de reinicialização de serviço e a perda iminente do histórico necessário do CDC não devem receber automaticamente prioridade operacional equivalente.

### 21.44 Correlação de Alertas

Múltiplos alertas podem descrever uma única falha subjacente.

Por exemplo:

**Falha do Debezium**
→ taxa de eventos do Kafka diminui  
→ entrada da Bronze para  
→ Silver para  
→ atualidade da Certified Gold aumenta.

A observabilidade deve ajudar a correlacionar sintomas *downstream* com a condição de origem quando prático.

O operador não deve tratar automaticamente cada alerta derivado como um incidente independente.

### 21.45 Supressão de Alertas Durante a Recuperação

Alguns alertas podem ser esperados durante uma operação conhecida de recuperação.

Por exemplo:

- *backlog* elevado;
- latência elevada;
- atualidade degradada.

A plataforma pode suprimir, anotar ou contextualizar alertas esperados da recuperação enquanto preserva a visibilidade sobre:

- condições em agravamento;
- convergência paralisada;
- novas falhas independentes.

A recuperação não deve se tornar uma justificativa genérica para silenciar todos os alertas.

### 21.46 Dashboards de Recuperação

Um *dashboard* orientado à recuperação pode apresentar perspectivas como:

**Origem e Captura**
→ progresso do CDC e do Debezium.

**Kafka**
→ *lag*, partições, risco de retenção.

**Bronze / Silver**
→ *checkpoints*, *backlog*, vazão, falhas.

**Gold**
→ estado da candidata e da qualidade.

**Certified Gold**
→ versão ativa, atualidade, certificação, *rollback*.

**Recuperação**
→ estágio atual, tempo decorrido, gargalo, convergência.

O projeto detalhado dos *dashboards* pertence ao documento especializado de **Observabilidade**.

### 21.47 Logs de Recuperação

Os *logs* devem fornecer detalhes contextuais para eventos de recuperação.

Informações úteis podem incluir:

- componente;
- identificador da execução;
- identificador da recuperação;
- *checkpoint*;
- versão de processamento;
- classificação da falha;
- estado das novas tentativas;
- ação de recuperação;
- resultado da validação.

Os *logs* devem permanecer estruturados quando prático.

Valores sensíveis não devem ser expostos desnecessariamente.

### 21.48 Métricas de Recuperação

As métricas fornecem evidências quantitativas do comportamento da recuperação.

Categorias representativas de métricas incluem:

- disponibilidade;
- *lag*;
- *backlog*;
- vazão;
- latência;
- novas tentativas;
- quarentena;
- margem de retenção;
- atualidade;
- duração da recuperação;
- estado da certificação.

Este documento define o significado dessas medições para a confiabilidade.

O documento especializado de **Observabilidade** define sua implementação concreta.

### 21.49 Traces e Correlação da Recuperação

Quando uma implementação futura oferecer suporte a *distributed tracing* ou correlação equivalente, a investigação da recuperação poderá se beneficiar do acompanhamento do processamento através dos limites dos componentes.

A Versão 1 não exige *distributed tracing* corporativo.

A arquitetura ainda deve preservar identificadores de correlação quando eles fornecerem valor significativo para recuperação e linhagem.

### 21.50 Falha de Observabilidade Durante a Recuperação

A própria observabilidade pode falhar enquanto a recuperação estiver em andamento.

Nesse caso, a plataforma deve utilizar evidências alternativas quando disponíveis, como:

- *checkpoints*;
- estado do banco de dados;
- *offsets* do Kafka;
- metadados de processamento;
- *logs* estruturados;
- reconciliação.

A observabilidade reduzida deve diminuir a confiança nas afirmações de recuperação.

Uma recuperação crítica não deve ser declarada demonstrada exclusivamente por meio de telemetria indisponível.

### 21.51 Validação da Observabilidade da Recuperação

A observabilidade da recuperação deve ser testada.

Uma validação representativa pode confirmar:

- componente interrompido torna-se visível;
- *checkpoint* paralisado é detectável;
- acúmulo de *backlog* é mensurável;
- tendência de *catch-up* é visível;
- esgotamento das novas tentativas é visível;
- crescimento da quarentena é visível;
- risco de retenção é detectável;
- falha de certificação é visível;
- degradação da atualidade da Certified Gold é observável;
- conclusão da recuperação é distinguível da reinicialização do serviço.

### 21.52 Evidências da Observabilidade da Recuperação

As evidências devem preservar comportamentos representativos da observabilidade, como:

- valores das métricas antes da falha;
- alerta disparado;
- crescimento do *backlog*;
- atividade de novas tentativas;
- paralisação do *checkpoint*;
- progressão da recuperação;
- migração do gargalo;
- recuperação da atualidade;
- resolução final do alerta.

Isso demonstra que a recuperação pode ser operada com base em estado observável, em vez de comportamento interno oculto.

### 21.53 Garantias da Observabilidade da Recuperação

O modelo de observabilidade da recuperação da Atlas Engineering deve preservar as seguintes garantias:

1. o estado da plataforma relevante para recuperação é observável quando tecnicamente viável;
2. a saúde do serviço permanece distinta da saúde do processamento;
3. falhas de dependência podem ser distinguidas de falhas de componentes quando possível;
4. o progresso do processamento é visível por meio de limites duráveis apropriados;
5. a desatualização do *checkpoint* pode revelar processamento paralisado;
6. o *lag* do Kafka permanece visível no nível da partição quando necessário;
7. a profundidade do *backlog* e a idade do item pendente mais antigo permanecem distinguíveis;
8. a tendência do *backlog* indica se a recuperação está convergindo;
9. as taxas de entrada e processamento fornecem contexto para o comportamento do *catch-up*;
10. a atividade e o esgotamento das novas tentativas permanecem visíveis;
11. falhas persistentes e quarentena permanecem observáveis;
12. lacunas de processamento são tratadas como sinais de correção, e não como condições comuns de performance;
13. o risco de janelas limitadas de recuperação é observável quando possível;
14. a observabilidade do CDC e do Debezium oferece suporte à proteção da capacidade de recuperação das alterações da origem;
15. Kafka, Bronze, Silver, Gold, certificação e publicação expõem estados de confiabilidade apropriados às suas responsabilidades;
16. a disponibilidade da Certified Gold permanece distinguível da atualidade;
17. o estado da recuperação analítica pode ser representado no escopo do produto de dados;
18. os marcos da recuperação oferecem suporte a linhas do tempo completas de recuperação;
19. o gargalo ativo da recuperação pode ser identificado quando prático;
20. convergência e recuperação paralisada permanecem distinguíveis;
21. regressões da recuperação podem ser comparadas com evidências anteriores;
22. a observabilidade da recuperação oferece suporte à análise de RPO e RTO baseada em evidências;
23. os alertas refletem a consequência arquitetural, e não apenas o erro do componente;
24. sintomas *downstream* podem ser correlacionados com as falhas de origem quando prático;
25. o comportamento esperado durante a recuperação não justifica a supressão generalizada de alertas;
26. *dashboards*, *logs*, métricas e correlação fornecem contextos complementares de recuperação;
27. falha de observabilidade permanece distinguível de falha de processamento;
28. afirmações de recuperação utilizam evidências alternativas quando a telemetria normal está indisponível;
29. a própria observabilidade da recuperação é testada e sustentada por evidências;
30. métricas, *dashboards* e limites concretos permanecem governados pela arquitetura especializada de **Observabilidade**.

---

## 22. Objetivos de Recuperação e Expectativas de Nível de Serviço

A Atlas Engineering define objetivos de recuperação e expectativas de nível de serviço de acordo com a capacidade arquitetural que está sendo protegida.

Os objetivos de recuperação devem refletir:

- necessidade de negócio;
- criticidade dos dados;
- semântica do processamento;
- disponibilidade da fonte de recuperação;
- retenção;
- mecanismo de recuperação;
- capacidade de processamento;
- requisitos de certificação;
- expectativas dos consumidores;
- comportamento medido da plataforma.

O princípio orientador é:

**Definir o Resultado Necessário → Identificar o Limite de Recuperação → Medir o Comportamento Real → Estabelecer um Objetivo Sustentado por Evidências**

A Versão 1 não deve atribuir compromissos de nível de produção para Recovery Point Objective (RPO), Recovery Time Objective (RTO), disponibilidade ou atualidade apenas porque esses conceitos aparecem na arquitetura.

As medições de laboratório estabelecem a capacidade observada sob condições controladas.

Elas não estabelecem automaticamente compromissos de serviço corporativos.

### 22.1 Objetivos de Recuperação

Os objetivos de recuperação descrevem qual estado a plataforma deve restaurar e quanto impacto sobre dados ou tempo é aceitável para a capacidade afetada.

As dimensões relevantes incluem:

- ponto de recuperação;
- tempo de recuperação;
- disponibilidade analítica;
- atualidade dos dados;
- completude do processamento;
- correção;
- capacidade de recuperação histórica.

Essas dimensões devem permanecer distinguíveis.

Um sistema pode recuperar uma dimensão enquanto outra permanece degradada.

### 22.2 Recovery Point Objective

Recovery Point Objective (RPO) expressa a quantidade máxima aceitável de estado dos dados que pode ficar indisponível ou irrecuperável após uma falha.

RPO é fundamentalmente um **objetivo de limite de dados**.

Ele deve responder:

**Até qual ponto o estado afetado deve ser recuperável?**

RPO não deve ser interpretado apenas como um intervalo de *backup*.

Diferentes camadas arquiteturais podem possuir características distintas de ponto de recuperação.

### 22.3 RPO por Limite Arquitetural

O RPO pode diferir de acordo com o estado que está sendo recuperado.

Exemplos incluem:

**Origem Operacional**
→ o ponto de recuperação da origem depende da durabilidade do SQL Server e da arquitetura de *backup*/recuperação.

**CDC**
→ a capacidade de recuperação depende do histórico retido de alterações da origem.

**Kafka**
→ a capacidade de *replay* depende do histórico retido de eventos.

**Bronze**
→ a recuperação analítica histórica depende do histórico bruto retido de forma durável.

**Silver / Gold**
→ o estado derivado pode passar por *rebuild* a partir de limites *upstream* confiáveis.

**Certified Gold**
→ o ponto de recuperação visível aos consumidores pode ser uma versão certificada anterior.

Um único RPO genérico para a plataforma pode, portanto, ocultar diferenças importantes.

### 22.4 Perda Zero de Dados

Uma afirmação de perda zero de dados é uma declaração arquitetural forte.

A Atlas Engineering não deve afirmar:

**RPO = 0**

a menos que o cenário de falha implementado demonstre que todos os dados confirmados necessários permanecem recuperáveis em todo o domínio de falha que está sendo reivindicado.

Por exemplo, eventos duráveis do Kafka podem oferecer suporte à ausência de perda de eventos para uma determinada interrupção de consumidor, enquanto isso não comprova perda zero de dados para:

- perda completa do *host*;
- perda do armazenamento do Kafka;
- recuperação da origem;
- todos os cenários de falha da plataforma.

As afirmações de RPO devem permanecer limitadas ao escopo demonstrado.

### 22.5 RPO Lógico versus Físico

Um caminho lógico de recuperação pode preservar os dados mesmo quando uma camada derivada é fisicamente perdida.

Por exemplo:

**Silver Perdida**
→ Bronze permanece completa  
→ Silver pode passar por *rebuild*.

Da perspectiva dos dados da Silver, o ponto efetivamente recuperável ainda pode alcançar o limite completo mais recente da Bronze.

Isso é diferente da restauração física dos próprios arquivos perdidos da Silver.

O RPO deve, portanto, descrever o estado governado recuperável, e não apenas se a cópia física original sobrevive.

### 22.6 RPO Visível aos Consumidores

O consumidor analítico pode experimentar um ponto de recuperação diferente daquele do processamento *upstream*.

Por exemplo:

**Origem e Bronze**
→ completas até 14:00.

**Candidata Gold**
→ inválida.

**Certified Gold**
→ última versão confiável representa 13:30.

O ponto de recuperação visível aos consumidores é, portanto, 13:30, embora o estado recuperável *upstream* seja mais recente.

O RPO da Certified Gold deve refletir o estado que é efetivamente seguro para publicação.

### 22.7 Recovery Time Objective

Recovery Time Objective (RTO) expressa o tempo máximo decorrido aceitável necessário para restaurar uma capacidade definida após uma falha.

O RTO deve sempre identificar:

**Qual capacidade é considerada recuperada?**

Possíveis pontos finais incluem:

- serviço operacional;
- processamento retomado;
- *backlog* normalizado;
- estado derivado reconstruído;
- Certified Gold disponível;
- atualidade restaurada.

Sem um ponto final explícito, o RTO é ambíguo.

### 22.8 RTO do Componente

O RTO do componente pode medir quanto tempo uma capacidade técnica específica leva para retornar.

Por exemplo:

**Falha do Broker Kafka**
→ tempo até que o serviço Kafka esteja disponível novamente.

Isso pode ser útil para análise de infraestrutura.

Ele não deve ser confundido com recuperação analítica ponta a ponta.

### 22.9 RTO do Processamento

O RTO do processamento mede quanto tempo a responsabilidade de processamento afetada leva para retornar ao seu estado operacional esperado.

Ele pode incluir:

- restauração do serviço;
- recuperação do *checkpoint*;
- *catch-up* do *backlog*;
- conclusão das novas tentativas;
- validação do processamento.

O RTO do processamento pode, portanto, ser significativamente maior do que o tempo de reinicialização do componente.

### 22.10 RTO do Produto de Dados

O RTO do produto de dados mede quanto tempo é necessário para restaurar um produto analítico governado aceitável.

Dependendo da falha, o estado aceitável pode ser:

- Certified Gold atual;
- Certified Gold anterior reconhecidamente válida por meio de *rollback*;
- estado certificado recém-reconstruído.

O ponto final deve ser definido de acordo com o requisito do produto de dados.

### 22.11 RTO Ponta a Ponta

O RTO analítico ponta a ponta pode incluir:

**Detecção da Falha**
→ **Intervenção**
→ **Restauração Técnica**
→ **Recuperação do Processamento**
→ **Catch-Up do Backlog**
→ **Validação**
→ **Certificação**
→ **Publicação**
→ **Disponibilidade para o Consumidor**

Essa é a perspectiva mais completa do tempo de recuperação.

A Versão 1 deve medir estágios representativos separadamente para que um tempo longo de recuperação possa ser decomposto em suas causas reais.

### 22.12 Tempo de Detecção

A detecção da falha contribui para a recuperação observada.

Uma plataforma que consegue se recuperar em dois minutos após a intervenção, mas leva uma hora para detectar a falha, não oferece uma experiência operacional de recuperação de dois minutos.

A linha do tempo da recuperação deve, portanto, distinguir:

**Início da Falha**

de:

**Detecção da Falha**.

### 22.13 Atraso de Intervenção

O atraso de intervenção é o tempo entre a detecção e o início da ação de recuperação.

Ele pode depender de:

- alertas;
- automação;
- diagnóstico;
- resposta do operador;
- autoridade para decisão.

A Versão 1 pode utilizar intervenção manual.

O tempo de intervenção observado em laboratório não deve ser apresentado como uma limitação inerente da tecnologia quando o atraso for principalmente operacional.

### 22.14 Tempo de Restauração Técnica

O tempo de restauração técnica mede o intervalo necessário para restaurar a capacidade técnica que falhou.

Exemplos incluem:

- reinicializar serviço;
- restaurar conectividade;
- substituir credencial;
- restaurar armazenamento;
- recuperar banco de dados.

Esse é um componente do tempo completo de recuperação.

### 22.15 Tempo de Catch-Up

O tempo de *catch-up* mede quanto tempo o trabalho acumulado leva para retornar à faixa operacional normal após a retomada do processamento.

O tempo de *catch-up* depende de:

- *backlog*;
- taxa de entrada;
- vazão de processamento;
- distribuição das partições;
- novas tentativas;
- capacidade de recursos.

Um componente pode ser restaurado rapidamente enquanto o *catch-up* domina o tempo total de recuperação.

### 22.16 Tempo de Rebuild

O tempo de *rebuild* mede a reconstrução de um estado derivado a partir de um limite *upstream* confiável.

Os estágios relevantes podem incluir:

- preparação da origem;
- reconstrução;
- validação da qualidade;
- reconciliação;
- certificação;
- *catch-up*;
- publicação.

O RTO de *rebuild* depende, portanto, fortemente do volume de dados e da capacidade de processamento.

### 22.17 Tempo de Validação

A validação da recuperação contribui para o tempo de recuperação.

Para uma saída analítica governada, a recuperação não pode ser considerada concluída antes que a validação necessária demonstre a correção.

O tempo de validação pode incluir:

- verificações de qualidade;
- reconciliação;
- validação da linhagem;
- comparação;
- certificação.

Remover a validação dos cálculos de RTO apenas para fazer a recuperação parecer mais rápida representaria incorretamente a recuperação governada real.

### 22.18 Tempo de Recuperação por Rollback

O *rollback* pode restaurar a disponibilidade para os consumidores mais rapidamente do que reconstruir um estado atual corrigido.

Uma linha do tempo de *rollback* pode incluir:

- detecção do defeito;
- decisão de invalidação;
- execução do *rollback*;
- validação;
- restauração para os consumidores.

O *roll-forward* corrigido posterior possui sua própria linha do tempo de recuperação.

Esses dois intervalos devem permanecer distinguíveis.

### 22.19 Disponibilidade

Disponibilidade descreve se uma capacidade necessária pode ser utilizada quando necessário.

A disponibilidade deve ser definida de acordo com a capacidade que está sendo medida.

Exemplos incluem:

- disponibilidade da origem;
- disponibilidade do transporte de eventos;
- disponibilidade do processamento;
- disponibilidade da Certified Gold;
- disponibilidade para o consumidor analítico.

A disponibilidade de um componente não implica que a plataforma de dados completa esteja disponível para todos os propósitos.

### 22.20 Confiabilidade versus Disponibilidade

Confiabilidade e disponibilidade são relacionadas, mas diferentes.

**Disponibilidade**
→ a capacidade pode ser utilizada agora?

**Confiabilidade**
→ a plataforma se comporta corretamente e se recupera de maneira previsível diante de condições de falha?

Um sistema pode ficar temporariamente indisponível e ainda permanecer confiável se:

- o estado permanecer durável;
- a recuperação for previsível;
- a correção for preservada.

Por outro lado, um sistema continuamente disponível que silenciosamente perde ou corrompe dados não é confiável.

### 22.21 Alta Disponibilidade

Alta Disponibilidade (HA) reduz a interrupção do serviço por meio de redundância, *failover* ou mecanismos equivalentes.

Mecanismos corporativos representativos podem incluir:

- múltiplos *brokers* Kafka;
- armazenamento replicado;
- tecnologias de disponibilidade do SQL Server;
- *workers* de processamento redundantes;
- infraestrutura redundante;
- *failover* automatizado.

A Versão 1 não fornece automaticamente HA corporativa apenas porque um serviço interrompido pode ser reinicializado.

**Capacidade de Reinicialização ≠ Alta Disponibilidade**

### 22.22 Disponibilidade do Laboratório

O laboratório da Versão 1 pode depender de instâncias únicas e infraestrutura física compartilhada.

Uma única falha da estação de trabalho ou do armazenamento local pode, portanto, afetar simultaneamente vários componentes da plataforma.

Os testes de laboratório podem demonstrar:

- comportamento de reinicialização;
- reconstrução;
- *replay*;
- *rollback*;
- recuperação lógica.

Eles não demonstram redundância física que não tenha sido implementada.

### 22.23 Disponibilidade Analítica

Disponibilidade analítica é a capacidade dos consumidores de acessar um estado analítico governado aceitável.

A Certified Gold permite que a disponibilidade analítica permaneça distinta da disponibilidade do processamento *upstream*.

Por exemplo:

**Processamento Upstream**
→ indisponível.

**Certified Gold**
→ versão confiável anterior ainda acessível.

O produto analítico está, portanto, disponível, mas pode ficar desatualizado.

### 22.24 Atualidade

Atualidade descreve quão atual é o estado analítico governado em relação ao seu limite definido de origem ou negócio.

A atualidade pode ser medida utilizando:

- momento da confirmação na origem;
- tempo do evento;
- tempo da transação;
- limite processado mais recente;
- momento da publicação.

A definição selecionada deve permanecer consistente para o produto.

### 22.25 Objetivo de Atualidade

Um objetivo de atualidade define a idade ou o atraso máximo esperado dos dados governados visíveis aos consumidores.

Ele deve refletir:

- uso de negócio;
- comportamento da origem;
- arquitetura do *pipeline*;
- cadência de processamento;
- certificação;
- latência medida em estado estável.

A Versão 1 deve medir o comportamento normal antes de atribuir um objetivo formal de atualidade.

### 22.26 Atualidade Durante uma Falha

A atualidade pode se degradar enquanto a disponibilidade e a correção permanecem preservadas.

Por exemplo:

**Certified Gold**
→ confiável e consultável  
→ *pipeline upstream* interrompido  
→ idade da atualidade aumenta.

Esse é um estado degradado válido.

A observabilidade deve expô-lo explicitamente.

### 22.27 Recuperação da Atualidade

A atualidade é restaurada somente depois que:

- o processamento *upstream* é retomado;
- o *backlog* realiza o *catch-up*;
- o processamento *downstream* é concluído;
- a certificação é bem-sucedida;
- o estado atual é publicado.

A reinicialização de um serviço não restaura a atualidade imediatamente.

### 22.28 Latência de Processamento

A latência de processamento mede o tempo decorrido através de um limite definido de processamento.

Possíveis dimensões de latência incluem:

- latência do CDC;
- latência da origem até o Kafka;
- latência do Kafka até a Bronze;
- latência da Bronze até a Silver;
- latência da Silver até a Gold;
- latência da Gold até a Certified Gold;
- latência ponta a ponta da origem até o consumidor.

Cada latência deve possuir limites inicial e final claramente definidos.

### 22.29 Latência Ponta a Ponta

A latência analítica ponta a ponta mede o tempo decorrido entre um evento de negócio autoritativo e sua disponibilidade analítica governada.

Conceitualmente:

**Confirmação na Origem**
→ CDC  
→ Kafka  
→ Bronze  
→ Silver  
→ Gold  
→ Certificação  
→ Publicação.

Essa métrica é particularmente relevante para as expectativas de atualidade.

### 22.30 Percentis de Latência

A latência média, isoladamente, pode ocultar comportamento degradado.

Quando houver carga de trabalho suficiente, a plataforma pode avaliar:

- P50;
- P95;
- P99.

Os percentis ajudam a identificar se uma minoria dos eventos experimenta um atraso materialmente pior do que o processamento típico.

A Versão 1 deve publicar afirmações de percentis somente quando a amostra de teste for grande o suficiente para torná-las significativas.

### 22.31 Objetivo de Disponibilidade

Um objetivo formal de disponibilidade deve identificar:

- capacidade;
- janela de medição;
- disponibilidade esperada;
- exclusões, quando governadas;
- cenários de falha incluídos.

A Versão 1 não deve inventar objetivos percentuais como:

**99,9%**

sem um requisito de negócio, topologia adequada e evidências que sustentem a afirmação.

### 22.32 Error Budget

A prática corporativa de SLO pode utilizar um *error budget* para representar a quantidade de falta de confiabilidade permitida dentro de um objetivo.

A Versão 1 não exige a implementação de um processo formal de *error budget*.

A arquitetura permanece compatível com seu uso futuro quando as operações corporativas o exigirem.

O laboratório deve primeiro estabelecer um comportamento significativo e medido de confiabilidade.

### 22.33 RPO e Retenção

O RPO depende da retenção e do estado durável de recuperação.

Por exemplo:

**Retenção do Kafka**
→ limita a disponibilidade normal de *replay*.

**Retenção da Bronze**
→ limita a reconstrução analítica de prazo mais longo.

**Retenção de Backup**
→ limita a restauração histórica protegida.

Um RPO necessário não pode ser sustentado por uma fonte de recuperação que não retenha mais o estado necessário.

### 22.34 RTO e Capacidade

O RTO depende da capacidade disponível para recuperação.

Os fatores relevantes incluem:

- velocidade de reinicialização;
- vazão de processamento;
- capacidade excedente para *catch-up*;
- velocidade de *rebuild*;
- capacidade de extração da origem;
- capacidade *downstream*;
- tempo de validação.

Um objetivo de recuperação deve ser viável com a capacidade efetivamente disponível durante a recuperação.

### 22.35 RTO e Volume de Dados

O tempo de recuperação pode aumentar à medida que cresce o volume histórico retido.

Um *rebuild* da Silver que leva dez minutos com um dia de dados não comprova que um ano de histórico retido possa ser reconstruído em dez minutos.

Os testes de recuperação devem registrar o volume de dados associado à duração medida.

### 22.36 RTO e Carga de Trabalho

A performance de *catch-up* e *rebuild* depende da carga de trabalho concorrente.

A recuperação medida enquanto a plataforma está ociosa pode diferir da recuperação enquanto:

- a ingestão ativa continua;
- a carga da origem está elevada;
- vários trabalhos *downstream* são executados;
- o armazenamento está ocupado.

O contexto do teste deve, portanto, acompanhar os tempos de recuperação observados.

### 22.37 RTO e Profundidade da Validação

Diferentes cenários de recuperação exigem diferentes profundidades de validação.

Por exemplo:

**Reinicialização Simples de Serviço**
→ uma validação limitada pode ser suficiente.

**Rebuild Histórico da Gold**
→ qualidade, reconciliação, certificação e validação da publicação podem dominar o tempo de recuperação.

A validação necessária não pode ser removida apenas para atender a uma meta arbitrária de RTO.

### 22.38 Trade-Offs dos Objetivos de Recuperação

Os objetivos de confiabilidade envolvem *trade-offs*.

Por exemplo:

**RPO Menor**
pode exigir:
- retenção mais longa;
- durabilidade mais forte;
- *backups* mais frequentes;
- replicação.

**RTO Menor**
pode exigir:
- capacidade adicional;
- redundância;
- automação;
- mecanismos de restauração mais rápidos;
- estado de recuperação pré-computado.

Essas melhorias podem aumentar:

- custo;
- complexidade;
- carga operacional.

Os objetivos devem, portanto, seguir os requisitos, e não prestígio.

### 22.39 Hierarquia dos Objetivos de Recuperação

Diferentes produtos e camadas podem legitimamente exigir objetivos diferentes.

Por exemplo:

**Produto Certificado de Vendas**
pode exigir expectativas mais fortes de atualidade e recuperação do que:

**Conjunto de Dados Histórico Experimental**.

A arquitetura deve evitar aplicar um único RPO ou RTO arbitrário a todas as capacidades da plataforma.

### 22.40 Criticidade dos Dados

Os objetivos de recuperação devem considerar a criticidade dos dados e da capacidade afetados.

Os fatores relevantes podem incluir:

- importância para o negócio;
- impacto financeiro;
- dependência dos consumidores;
- valor histórico;
- custo de reconstrução;
- classificação dos dados;
- consequência operacional.

A criticidade não deve ser inferida apenas a partir do tamanho técnico ou do volume de processamento.

### 22.41 Responsabilidade pelos Objetivos de Recuperação

Objetivos formais de recuperação exigem responsabilidades identificáveis.

As responsabilidades relevantes podem incluir:

- Business Data Owner;
- Engenharia de Dados;
- DBA;
- Plataforma / SRE;
- Governança;
- Segurança, quando aplicável.

As equipes técnicas podem medir a capacidade.

As responsabilidades de negócio e governança determinam qual nível de perda, atraso ou indisponibilidade é aceitável.

### 22.42 Medição em Laboratório

A Versão 1 deve estabelecer medições observadas de recuperação para cenários representativos.

As medições podem incluir:

- tempo de reinicialização do componente;
- tempo de detecção;
- acúmulo de *backlog*;
- taxa de *catch-up*;
- tempo de *catch-up*;
- duração do *replay*;
- duração do reprocessamento;
- duração do *rebuild*;
- duração do *rollback*;
- tempo de recuperação ponta a ponta;
- recuperação da atualidade.

Essas observações tornam-se a base de evidências para objetivos posteriores.

### 22.43 Observado versus Meta

A Atlas Engineering deve distinguir:

**Recuperação Observada**
→ o que aconteceu no cenário medido em laboratório.

de:

**Meta de Recuperação**
→ o objetivo necessário definido para um ambiente futuro ou governado.

Por exemplo:

**Observado**
→ o *catch-up* da Bronze foi concluído em 4 minutos para 50.000 eventos controlados.

Isso não estabelece automaticamente:

**RTO = 4 minutos**

para todas as cargas de trabalho ou para um *deployment* corporativo.

### 22.44 Linha de Base Medida de Recuperação

Após testes representativos, a Versão 1 deve manter uma linha de base medida de recuperação.

Uma linha de base pode identificar:

| Cenário | Carga de Trabalho | Fonte de Recuperação | RPO Observado | Tempo de Recuperação Observado | Resultado |
|---|---:|---|---|---|---|
| Reinicialização do Consumidor da Bronze | A ser medido | Kafka | A ser medido | A ser medido | Pendente |
| Rebuild da Silver | A ser medido | Bronze | A ser medido | A ser medido | Pendente |
| Rebuild da Gold | A ser medido | Silver | A ser medido | A ser medido | Pendente |
| Rollback da Certified Gold | A ser medido | Versão Certificada Anterior | A ser medido | A ser medido | Pendente |

Os resultados reais devem substituir os valores pendentes somente depois que os testes correspondentes forem executados e validados.

### 22.45 Nenhuma Publicação com Placeholders

O documento de arquitetura pode definir estruturas de medição antes da implementação.

Entretanto, a documentação publicada e commitada do projeto não deve manter *placeholders* editoriais não resolvidos como se fossem resultados concluídos.

Até que existam medições, o documento deve declarar que os objetivos permanecem **a ser estabelecidos a partir das evidências da Versão 1**, em vez de apresentar valores fictícios.

### 22.46 Evolução dos Objetivos de Recuperação

Os objetivos de recuperação podem evoluir depois que:

- a carga de trabalho medida mudar;
- o volume de dados aumentar;
- a arquitetura mudar;
- novos produtos forem introduzidos;
- a criticidade de negócio mudar;
- a topologia corporativa for implementada;
- novas evidências demonstrarem que os objetivos atuais são irrealistas ou desnecessariamente conservadores.

Os objetivos são decisões de engenharia governadas, e não constantes permanentes.

### 22.47 Regressão dos Objetivos

Uma versão posterior da plataforma pode deixar de atender a uma linha de base de recuperação demonstrada anteriormente.

Exemplos incluem:

- *catch-up* mais lento;
- *rebuild* mais longo;
- aumento do tempo de detecção;
- recuperação da publicação mais longa.

A regressão deve ser investigada, em vez de ocultada por meio da alteração da linha de base sem explicação.

Se o objetivo mudar legitimamente, a decisão deve ser explícita.

### 22.48 Validação dos Objetivos

Um objetivo formal de recuperação deve ser validado em um cenário representativo da afirmação.

Por exemplo, um RTO para recuperação de *backlog* não deve ser validado apenas medindo a reinicialização do serviço.

A validação deve abranger a capacidade completa representada pelo objetivo.

### 22.49 Evidências dos Objetivos

As evidências que sustentam os objetivos de recuperação devem preservar:

- cenário;
- escopo da falha;
- carga de trabalho;
- volume de dados;
- topologia;
- fonte de recuperação;
- versão de processamento;
- momento da falha;
- momento da detecção;
- início da recuperação;
- marcos da restauração;
- ponto de recuperação alcançado;
- tempo final de recuperação;
- resultado da atualidade;
- conclusão.

Isso permite que o objetivo permaneça vinculado às condições sob as quais foi demonstrado.

### 22.50 RPO e RTO Corporativos

RPO e RTO corporativos devem ser derivados dos requisitos de negócio e validados em relação à implementação corporativa.

As metas corporativas podem exigir mecanismos arquiteturais não implementados na Versão 1, como:

- Kafka replicado;
- SQL Server com Alta Disponibilidade;
- armazenamento redundante;
- *failover* automatizado;
- *deployment* entre *hosts*;
- arquitetura de *backup* mais robusta;
- capacidade adicional de processamento;
- infraestrutura de Recuperação de Desastre.

A Versão 1 fornece evidências para o projeto da arquitetura.

Ela não declara antecipadamente compromissos corporativos.

### 22.51 Cenários de Teste dos Objetivos de Recuperação

A Versão 1 deve utilizar cenários controlados para estabelecer o comportamento medido da recuperação.

Exemplos representativos incluem:

**Teste de Objetivo 1 — Reinicialização e Catch-Up**
→ interromper o processamento da Bronze  
→ acumular um *backlog* conhecido  
→ restaurar o processamento  
→ medir os tempos de reinicialização, *catch-up* e recuperação da atualidade.

**Teste de Objetivo 2 — Rebuild da Silver**
→ reconstruir um histórico controlado da Silver a partir da Bronze  
→ medir volume de dados, taxa de processamento, tempo de validação e duração total do *rebuild*.

**Teste de Objetivo 3 — Rollback da Gold**
→ invalidar uma versão publicada controlada  
→ executar *rollback* para a versão certificada anterior  
→ medir o tempo de recuperação da disponibilidade para o consumidor e o impacto resultante na atualidade.

**Teste de Objetivo 4 — Recuperação Ponta a Ponta**
→ injetar uma falha controlada  
→ medir desde a detecção até a restauração da Certified Gold atual  
→ preservar a linha do tempo completa da recuperação.

Essas medições devem posteriormente informar a linha de base de confiabilidade da Versão 1.

### 22.52 Garantias dos Objetivos de Recuperação e Nível de Serviço

O modelo de objetivos de recuperação da Atlas Engineering deve preservar as seguintes garantias:

1. os objetivos de recuperação são definidos de acordo com a capacidade que está sendo protegida;
2. RPO representa um limite de recuperação de dados, e não apenas um cronograma de *backup*;
3. RPO pode diferir entre as camadas de origem, eventos, processamento e visíveis aos consumidores;
4. afirmações de perda zero de dados permanecem limitadas aos cenários de falha efetivamente demonstrados;
5. a perda de estado derivado pode ser recuperável a partir de estado *upstream* sem preservar a cópia física original;
6. o ponto de recuperação visível aos consumidores permanece distinguível do estado recuperável *upstream*;
7. RTO identifica a capacidade e o ponto final considerados recuperados;
8. RTO de componente, processamento, produto de dados e ponta a ponta permanecem distinguíveis;
9. detecção e intervenção contribuem para o tempo operacional de recuperação;
10. restauração técnica permanece distinta de *backlog*, validação e recuperação para o consumidor;
11. o tempo de recuperação por *rollback* permanece distinguível da recuperação posterior por *roll-forward*;
12. disponibilidade é medida de acordo com uma capacidade definida;
13. confiabilidade permanece mais ampla do que disponibilidade;
14. capacidade de reinicialização não é apresentada como Alta Disponibilidade;
15. as limitações físicas da Versão 1 permanecem explícitas nas afirmações de disponibilidade;
16. Certified Gold permite que a disponibilidade analítica permaneça distinta da disponibilidade *upstream*;
17. atualidade permanece distinguível de disponibilidade e correção;
18. objetivos de atualidade são estabelecidos a partir da necessidade de negócio e do comportamento medido;
19. latência de processamento e ponta a ponta utilizam limites explícitos;
20. afirmações de percentis de latência exigem carga de trabalho medida suficiente;
21. percentuais de disponibilidade não são inventados sem requisitos e evidências;
22. a prática formal de *error budget* permanece uma evolução corporativa, e não uma afirmação não sustentada da Versão 1;
23. retenção restringe o RPO alcançável;
24. capacidade de processamento e volume de dados restringem o RTO alcançável;
25. o tempo de validação permanece parte da recuperação governada quando necessário;
26. os *trade-offs* de RPO e RTO são avaliados em relação a custo, complexidade e requisitos operacionais;
27. diferentes camadas e produtos podem utilizar diferentes objetivos de recuperação;
28. objetivos formais possuem responsabilidades técnicas e de negócio identificáveis;
29. a Versão 1 primeiro estabelece o comportamento observado da recuperação;
30. a recuperação observada em laboratório permanece distinguível dos compromissos de serviço pretendidos;
31. linhas de base medidas registram o contexto da carga de trabalho e da topologia;
32. a documentação publicada do projeto não apresenta medições fictícias de recuperação;
33. os objetivos de recuperação evoluem por meio de evidências governadas e mudanças nos requisitos;
34. regressões em relação ao comportamento anteriormente demonstrado são investigadas;
35. objetivos formais são validados em cenários que efetivamente representam a capacidade reivindicada;
36. RPO e RTO corporativos exigem requisitos corporativos e validação específica da implementação corporativa;
37. as afirmações sobre objetivos de recuperação permanecem proporcionais às evidências disponíveis.

---

## 23. Disponibilidade, Alta Disponibilidade e Recuperação de Desastre

A Atlas Engineering distingue disponibilidade, confiabilidade, Alta Disponibilidade, capacidade de recuperação e Recuperação de Desastre como preocupações arquiteturais relacionadas, porém separadas.

O modelo orientador é:

**Disponibilidade**
→ A capacidade necessária pode ser utilizada agora?

**Confiabilidade**
→ A plataforma se comporta corretamente e se recupera de maneira previsível quando ocorre uma falha?

**Alta Disponibilidade**
→ A redundância e o *failover* podem reduzir a interrupção da capacidade necessária?

**Capacidade de Recuperação**
→ O estado e o processamento necessários podem ser restaurados após uma falha?

**Recuperação de Desastre**
→ A plataforma pode ser restaurada após uma falha ampla que afete infraestrutura, dados ou um ambiente operacional inteiro?

Esses conceitos não devem ser condensados em uma única afirmação genérica, como:

**Altamente Disponível e Pronta para Recuperação de Desastre**

a menos que os mecanismos correspondentes tenham sido efetivamente implementados e validados.

### 23.1 Disponibilidade

Disponibilidade descreve se uma capacidade definida pode ser utilizada durante determinado período.

As capacidades relevantes podem incluir:

- AtlasCommerce;
- CDC;
- Kafka;
- ingestão da Bronze;
- processamento da Silver;
- processamento da Gold;
- Certified Gold;
- consumo pelo Power BI;
- observabilidade;
- dependências de recuperação.

A disponibilidade deve sempre identificar a capacidade que está sendo avaliada.

Uma plataforma pode estar parcialmente disponível.

### 23.2 Disponibilidade do Componente

Disponibilidade do componente descreve se um componente técnico está utilizável.

Por exemplo:

**Kafka**
→ disponível.

Isso não implica automaticamente que:

- eventos estejam fluindo;
- consumidores estejam atualizados;
- Bronze esteja avançando;
- Silver esteja avançando;
- Certified Gold esteja atualizada.

A disponibilidade do componente é, portanto, apenas uma camada da disponibilidade da plataforma.

### 23.3 Disponibilidade do Processamento

Disponibilidade do processamento descreve se uma responsabilidade de processamento consegue continuar executando seu trabalho pretendido.

Um processo pode estar em execução enquanto a disponibilidade do processamento está degradada porque:

- uma dependência necessária está indisponível;
- o *checkpoint* está paralisado;
- as novas tentativas foram esgotadas;
- a entrada não pode ser interpretada;
- a saída não pode ser persistida.

A disponibilidade do processamento deve, portanto, ser avaliada por meio do progresso, e não apenas pelo estado do processo.

### 23.4 Disponibilidade Analítica

Disponibilidade analítica descreve se os consumidores podem acessar um estado analítico governado aceitável.

A Certified Gold pode permanecer analiticamente disponível mesmo enquanto o processamento *upstream* está degradado.

Por exemplo:

**Silver**
→ indisponível.

**Certified Gold V12**
→ confiável e consultável.

Resultado:

**Disponibilidade Analítica = Disponível**
enquanto:
**Atualidade = Degradando**

Essa distinção é intencional.

### 23.5 Disponibilidade e Atualidade

Disponibilidade e atualidade devem permanecer separadas.

Um produto pode estar:

**Disponível e Atualizado**

**Disponível, mas Desatualizado**

**Indisponível**

Um produto desatualizado, porém confiável, pode ser aceitável para alguns usos de negócio.

Um produto mais recente, porém incorreto, não é preferível apenas porque melhora a atualidade aparente.

### 23.6 Disponibilidade e Correção

A disponibilidade nunca deve ser aumentada por meio da exposição consciente de dados incorretos ou não certificados.

A regra orientadora é:

**Correção Antes da Disponibilidade Artificial**

Se não existir um estado confiável visível aos consumidores, o produto afetado pode precisar ficar indisponível.

Disponibilizar dados reconhecidamente inválidos para preservar o tempo de atividade não é considerado disponibilidade confiável.

### 23.7 Disponibilidade e Falha Parcial

Diferentes capacidades podem possuir diferentes estados de disponibilidade simultaneamente.

Por exemplo:

**Kafka**
→ disponível.

**Bronze**
→ em recuperação.

**Silver**
→ desatualizada.

**Certified Gold**
→ disponível.

**Power BI**
→ disponível.

A plataforma deve, portanto, evitar uma única interpretação binária global de saúde.

### 23.8 Alta Disponibilidade

Alta Disponibilidade (HA) é o uso de redundância, *failover* ou mecanismos equivalentes para reduzir a interrupção do serviço quando um componente ou elemento da infraestrutura falha.

HA normalmente depende de:

- nós redundantes;
- estado replicado;
- múltiplos domínios de falha;
- *failover* automatizado ou controlado;
- balanceamento de carga;
- detecção de saúde;
- mecanismos de quórum ou consenso;
- rede ou armazenamento redundantes.

Reinicializar uma única instância que falhou é recuperação.

Não é Alta Disponibilidade.

### 23.9 Objetivo da Alta Disponibilidade

HA destina-se a reduzir interrupções.

Ela não garante automaticamente:

- perda zero de dados;
- processamento correto;
- *checkpoints* válidos;
- atualidade para os consumidores;
- Recuperação de Desastre;
- proteção contra corrupção lógica.

Um sistema altamente disponível e incorreto continua incorreto.

HA deve, portanto, complementar, e não substituir, os controles de confiabilidade dos dados.

### 23.10 HA e Replicação de Estado

HA com estado exige replicação suficiente do estado necessário após o *failover*.

Por exemplo:

**Serviço Replicado**
mas:
**Dados Necessários Armazenados em um Único Disco que Falhou**

não fornece Alta Disponibilidade significativa com estado.

A arquitetura deve distinguir:

**Redundância de Computação**

de:

**Redundância de Estado**.

### 23.11 HA e Domínios de Falha

Instâncias redundantes oferecem maior disponibilidade somente quando não compartilham o mesmo domínio de falha relevante.

Exemplos de domínios de falha incluem:

- processo;
- contêiner;
- *host*;
- disco;
- *rack*;
- zona de disponibilidade;
- região;
- dependência de identidade;
- caminho de rede.

Dois serviços na mesma estação de trabalho física não fornecem Alta Disponibilidade no nível do *host*.

### 23.12 HA e Failover Automático

HA corporativa pode utilizar *failover* automatizado.

O *failover* automático ainda deve preservar:

- consistência do estado;
- responsabilidade correta;
- autorização;
- progresso do processamento;
- idempotência;
- auditabilidade.

Um *failover* rápido não é desejável se criar *split-brain*, efeitos de negócio duplicados ou responsabilidade ambígua pelo processamento.

### 23.13 HA e Kafka

A HA corporativa do Kafka normalmente depende de:

- múltiplos *brokers*;
- partições replicadas;
- fator de replicação apropriado;
- eleição de líder;
- distribuição entre domínios de falha.

A Versão 1 pode utilizar um único *broker* Kafka.

Portanto:

**Capacidade de Reinicialização do Kafka**
pode ser demonstrada.

**HA Multi-Broker do Kafka**
não é demonstrada a menos que essa topologia seja efetivamente implementada e testada.

### 23.14 HA e SQL Server

A disponibilidade corporativa do SQL Server pode utilizar tecnologias como:

- Always On Availability Groups;
- Failover Cluster Instances;
- outras arquiteturas aprovadas de replicação ou *failover*.

A Versão 1 não exige HA corporativa do SQL Server para validar a arquitetura lógica de Engenharia de Dados.

Quando o SQL Server é executado como uma única instância, os testes de recuperação demonstram capacidade de recuperação, e não Alta Disponibilidade.

### 23.15 HA e MinIO

A disponibilidade corporativa do armazenamento de objetos pode exigir:

- armazenamento distribuído;
- replicação;
- *erasure coding*;
- múltiplos nós;
- armazenamento físico independente.

Uma instância local de nó único do MinIO fornece armazenamento durável apenas dentro das limitações dessa topologia física.

Ela não deve ser descrita como armazenamento altamente disponível apenas porque os objetos sobrevivem à reinicialização de um processo.

### 23.16 HA e Workers de Processamento

As cargas de processamento podem obter maior disponibilidade por meio de múltiplos *workers* quando o modelo de processamento permitir responsabilidade segura e comportamento correto de novas tentativas.

Entretanto, adicionar *workers* exige tratamento correto de:

- atribuição de partições;
- execução duplicada;
- estado compartilhado;
- concorrência;
- *checkpointing*;
- capacidade *downstream*.

A redundância de *workers* deve preservar a semântica do processamento.

### 23.17 HA e Airflow

A disponibilidade corporativa do Airflow pode exigir redundância de:

- *schedulers*;
- *workers*;
- banco de dados de metadados;
- infraestrutura de execução.

A Versão 1 pode operar com uma topologia mais simples.

Um *deployment* local reinicializável do Airflow não deve ser descrito como HA corporativa a menos que esses mecanismos sejam efetivamente implementados.

### 23.18 HA e Observabilidade

Os componentes de observabilidade também podem exigir HA em ambientes corporativos.

A perda do monitoramento não deve interromper automaticamente o processamento de dados, mas a indisponibilidade prolongada da observabilidade pode reduzir:

- detecção de incidentes;
- confiança na recuperação;
- monitoramento de segurança;
- medição de SLO.

A confiabilidade corporativa pode, portanto, exigir infraestrutura resiliente de observabilidade.

### 23.19 HA e Dependências de Segurança

Dependências de segurança também podem se tornar dependências de disponibilidade.

Exemplos incluem:

- provedor de identidade;
- gerenciador de segredos;
- autoridade certificadora;
- serviço de gerenciamento de chaves;
- serviço de autorização.

Um *pipeline* altamente disponível pode permanecer inutilizável se as cargas de trabalho não conseguirem se autenticar ou descriptografar os dados necessários.

O projeto corporativo de HA deve, portanto, incluir dependências críticas de segurança.

### 23.20 Capacidade de Recuperação

Capacidade de recuperação é a capacidade de restaurar o estado e o processamento necessários após uma falha.

A capacidade de recuperação pode existir sem Alta Disponibilidade.

Por exemplo:

**Armazenamento da Silver em Nó Único Perdido**
→ plataforma temporariamente indisponível  
→ Bronze permanece válida  
→ Silver reconstruída com sucesso.

Resultado:

**Alta Disponibilidade = Não Fornecida**

mas:

**Capacidade de Recuperação = Demonstrada**

Essa distinção é importante para a Versão 1.

### 23.21 Capacidade de Recuperação sem Redundância

Um componente pode ser recuperável por meio de:

- reinicialização;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- restauração de *backup*;
- *rollback*.

Esses mecanismos podem exigir indisponibilidade.

Eles, portanto, demonstram capacidade de recuperação, e não necessariamente HA.

### 23.22 Desastre

Um desastre é uma falha cujo escopo excede a recuperação comum de componentes e afeta materialmente o ambiente operacional ou o estado durável da plataforma.

Exemplos representativos podem incluir:

- perda completa do *host*;
- perda catastrófica de armazenamento;
- perda de múltiplos serviços da plataforma;
- perda grave de banco de dados;
- falha do *site*;
- falha regional em um *deployment* corporativo;
- incidente destrutivo que exija restauração ampla.

A definição organizacional exata de desastre pode variar.

A distinção arquitetural é que uma reinicialização comum ou um *replay* localizado são insuficientes.

### 23.23 Recuperação de Desastre

Recuperação de Desastre (DR) é a restauração coordenada das capacidades da plataforma após uma falha ampla.

DR pode exigir a restauração de:

- infraestrutura;
- armazenamento;
- bancos de dados;
- Kafka;
- armazenamento de objetos;
- serviços de processamento;
- metadados;
- contratos;
- identidades;
- credenciais;
- certificados;
- chaves de criptografia;
- observabilidade;
- *backups*;
- estado analítico derivado;
- Certified Gold;
- acesso dos consumidores.

DR, portanto, vai além da restauração de dados isoladamente.

### 23.24 Sequência de Recuperação de DR

Um procedimento de DR deve respeitar a ordem das dependências.

Uma sequência lógica representativa é:

1. restaurar a infraestrutura;
2. restaurar a rede e o armazenamento necessários;
3. restaurar identidades, credenciais, certificados e chaves;
4. restaurar o SQL Server e os bancos de dados necessários;
5. restaurar o Kafka e o registro de *schemas*;
6. restaurar o MinIO ou armazenamento histórico equivalente;
7. restaurar a orquestração e o *runtime* de processamento;
8. restaurar a observabilidade;
9. validar as fontes de recuperação;
10. retomar ou reconstruir a Bronze;
11. executar *rebuild* da Silver quando necessário;
12. executar *rebuild* da Gold;
13. validar qualidade e reconciliação;
14. certificar;
15. publicar a Certified Gold;
16. restaurar o consumo analítico;
17. validar o estado governado final.

A sequência exata depende da topologia implementada.

### 23.25 DR e Backup

*Backup* é um mecanismo dentro da Recuperação de Desastre.

Um *backup*, isoladamente, não constitui um plano de DR.

Uma capacidade completa de DR também exige:

- acessibilidade do *backup*;
- restauração documentada;
- credenciais e chaves necessárias;
- infraestrutura;
- configuração das aplicações;
- definições de processamento;
- ordem das dependências;
- validação;
- *catch-up*.

A plataforma deve conseguir utilizar o *backup* de maneira significativa.

### 23.26 Validação da Restauração de Backup

A capacidade de recuperação do *backup* deve ser testada.

Um *backup* que nunca foi restaurado com sucesso fornece evidências mais fracas do que um que tenha sido exercitado sob condições controladas.

A validação deve confirmar, quando aplicável:

- *backup* legível;
- estado esperado restaurado;
- versão necessária conhecida;
- estado de segurança revisado;
- processamento *downstream* pode continuar;
- governança atual reaplicada.

### 23.27 DR e Catch-Up Histórico

Um ambiente restaurado pode representar um ponto anterior ao estado atual da origem.

A recuperação pode, portanto, exigir:

**Restauração de Backup**
→ identificar o ponto restaurado  
→ recuperar alterações posteriores da origem  
→ executar *replay* ou *backfill*  
→ executar *rebuild* do estado *downstream*  
→ realizar *catch-up*  
→ validar.

O tempo total de recuperação de DR inclui tanto a restauração quanto a recuperação posterior dos dados.

### 23.28 DR e RPO

O RPO de DR depende das fontes de recuperação protegidas disponíveis após o desastre.

Possíveis fontes incluem:

- *backups* do SQL Server;
- estado replicado do Kafka;
- armazenamento de objetos replicado;
- *backups* fora do *host*;
- arquivos históricos;
- cópias entre regiões.

As cópias locais da Versão 1 podem compartilhar o mesmo domínio físico de falha.

Elas não devem ser apresentadas como recuperação independente de desastre, a menos que realmente sobrevivam ao escopo de falha testado.

### 23.29 DR e RTO

O RTO de DR é mais amplo do que a reinicialização de um componente ou a recuperação comum do *pipeline*.

Ele pode incluir:

- provisionamento da infraestrutura;
- restauração dos dados;
- configuração dos serviços;
- restauração das credenciais;
- validação de segurança;
- reconstrução do processamento;
- *catch-up*;
- qualidade e reconciliação;
- certificação;
- restauração para os consumidores.

Os objetivos corporativos de DR devem ser validados em relação à topologia corporativa real.

### 23.30 DR e Local de Recuperação

A DR corporativa pode restaurar o serviço:

- na mesma infraestrutura;
- em outro *host*;
- em outra zona de disponibilidade;
- em outra região;
- em outro ambiente.

O local de recuperação deve fornecer independência suficiente em relação ao desastre contra o qual se busca proteção.

Uma cópia no mesmo dispositivo que falhou não fornece independência significativa contra desastre.

### 23.31 Backup Fora do Host

Um *backup* fora do *host* melhora a proteção contra falhas no nível do *host*.

A Versão 1 pode eventualmente validar um cenário de recuperação no qual um *backup* ou artefato governado de recuperação exportado exista fora do domínio de falha da estação de trabalho principal.

Até que esse mecanismo seja implementado e testado, a DR para perda do *host* permanece uma evolução corporativa, e não uma capacidade demonstrada da Versão 1.

### 23.32 Recuperação de Desastre entre Regiões

DR entre regiões é uma preocupação de arquitetura corporativa que envolve mecanismos como:

- dados replicados;
- *backups* remotos;
- infraestrutura regional;
- *failover* de rede;
- disponibilidade de identidades e chaves;
- procedimentos de recuperação específicos por região.

A Versão 1 não precisa implementar DR entre regiões.

A arquitetura lógica deve permanecer compatível com essa evolução.

### 23.33 DR e Certified Gold

A Certified Gold pode ajudar a restaurar o consumo analítico enquanto uma reconstrução *upstream* mais ampla continua.

Se uma cópia certificada confiável sobreviver à falha em um local independente de recuperação:

→ a disponibilidade para os consumidores pode ser recuperada antes da reconstrução completa do *pipeline*.

Se nenhuma Certified Gold confiável sobreviver:

→ o produto deve ser reconstruído e certificado antes que o consumo normal seja retomado.

### 23.34 DR e Segurança

A Recuperação de Desastre deve preservar os limites de segurança.

A recuperação não deve:

- reutilizar credenciais comprometidas;
- restaurar identidades revogadas;
- desabilitar permanentemente a autenticação;
- ignorar a autorização;
- restaurar certificados inválidos;
- expor *backups* sensíveis sem proteção;
- restaurar estado de privacidade obsoleto.

Os requisitos de recuperação de segurança permanecem autoritativos durante a DR.

### 23.35 DR e Chaves de Criptografia

Dados criptografados podem ser irrecuperáveis se as chaves de criptografia necessárias estiverem indisponíveis após um desastre.

*Backup*, custódia, replicação ou controles corporativos equivalentes de chaves podem, portanto, fazer parte do projeto de DR.

O requisito orientador é:

**Dados Protegidos + Chave Irrecuperável = Dados Irrecuperáveis**

A recuperação das chaves deve preservar a segurança enquanto mantém a capacidade necessária de recuperação dos dados.

### 23.36 DR e Configuração

A recuperação exige mais do que dados das aplicações.

Configurações relevantes podem incluir:

- configuração dos tópicos Kafka;
- retenção;
- configuração dos consumidores;
- configuração do MinIO;
- DAGs do Airflow;
- parâmetros de processamento;
- objetos de banco de dados;
- política de acesso;
- metadados de certificação.

Infraestrutura como código e configurações sob controle de versão podem fortalecer a reprodutibilidade da DR quando apropriado.

### 23.37 DR e Metadados

Metadados de recuperação podem ser necessários para compreender o estado restaurado.

Metadados relevantes podem incluir:

- versões de processamento;
- *checkpoints*;
- linhagem;
- versões de contratos;
- histórico de certificação;
- versão ativa da Certified Gold;
- contexto de retenção.

Restaurar os dados sem os metadados necessários para interpretá-los pode produzir uma recuperação incompleta.

### 23.38 DR e Observabilidade

A observabilidade deve ser restaurada cedo o suficiente para oferecer suporte ao diagnóstico e à validação da recuperação.

O processo de recuperação precisa de visibilidade sobre:

- saúde dos serviços;
- progresso da restauração;
- progresso do processamento;
- *backlog*;
- erros;
- atualidade;
- certificação.

Entretanto, as dependências de observabilidade não devem impedir a restauração da infraestrutura fundamental quando esses próprios sistemas de monitoramento estiverem indisponíveis.

### 23.39 DR e Documentação

Uma capacidade utilizável de DR exige documentação atualizada.

As informações relevantes podem incluir:

- dependências;
- ordem de recuperação;
- fontes de recuperação;
- procedimentos de credenciais e chaves;
- instruções de restauração;
- validação;
- escalonamento;
- limitações esperadas.

A documentação deve evoluir quando a arquitetura mudar.

### 23.40 Runbook de DR

A implementação final pode manter *runbooks* operacionais para procedimentos específicos de DR.

O documento de arquitetura define:

- princípios de recuperação;
- dependências necessárias;
- limites de recuperação;
- expectativas de validação.

Um *runbook* define:

- comandos;
- sequência exata;
- etapas específicas da implementação.

Este documento não deve se tornar um *runbook* de implementação.

### 23.41 Testes de DR

A capacidade de Recuperação de Desastre deve ser testada em um escopo apropriado à afirmação.

A Versão 1 pode validar cenários representativos, como:

- reconstrução completa dos serviços locais;
- restauração do SQL Server;
- *rebuild* da Silver a partir da Bronze;
- *rebuild* da Gold a partir da Silver;
- restauração da publicação da Certified Gold;
- recuperação após um desligamento completo e controlado do laboratório.

Esses testes demonstram recuperação lógica.

Eles não comprovam DR entre *hosts* ou entre regiões, a menos que esses domínios de falha estejam efetivamente envolvidos.

### 23.42 Teste de Recuperação Completa do Laboratório

Um teste representativo de recuperação completa do laboratório da Versão 1 pode:

1. registrar o estado da linha de base;
2. interromper a plataforma do laboratório;
3. preservar ou restaurar o estado durável necessário;
4. iniciar os serviços na ordem das dependências;
5. validar o SQL Server;
6. validar o Kafka;
7. validar o MinIO;
8. validar os contratos;
9. restaurar o processamento;
10. recuperar o *backlog*;
11. validar a Silver;
12. validar a Gold;
13. validar a certificação;
14. validar a Certified Gold;
15. validar o acesso pelo Power BI;
16. preservar a linha do tempo completa.

Isso demonstra a recuperação coordenada da plataforma dentro do domínio de falha do laboratório.

### 23.43 Limitação de Perda do Host

Se todos os serviços e o estado durável de recuperação da Versão 1 permanecerem em uma única estação de trabalho, a perda completa dessa estação pode exceder a capacidade de recuperação demonstrada pelo laboratório.

Essa limitação deve permanecer explícita.

A arquitetura pode ser projetada para uma recuperação mais ampla enquanto a implementação física da Versão 1 permanece limitada.

### 23.44 Evolução Corporativa da HA

A implementação corporativa pode fortalecer a disponibilidade por meio de:

- Kafka com múltiplos nós;
- armazenamento de objetos replicado;
- HA do SQL Server;
- Airflow redundante;
- computação distribuída;
- balanceamento de carga;
- múltiplos *hosts*;
- rede redundante;
- *failover* automatizado;
- serviços resilientes de identidade e segredos.

Esses mecanismos fortalecem a disponibilidade sem alterar os princípios lógicos de processamento e recuperação.

### 23.45 Evolução Corporativa da DR

A DR corporativa pode fortalecer a recuperação por meio de:

- *backups* fora do *site*;
- replicação entre regiões;
- infraestrutura como código;
- provisionamento automatizado de ambiente;
- recuperação gerenciada de chaves;
- configuração centralizada;
- metadados replicados;
- ambientes de recuperação testados;
- exercícios formais de DR.

O projeto exato depende dos requisitos corporativos e dos objetivos de RPO/RTO.

### 23.46 Custo e Complexidade de HA/DR

HA e DR mais robustas geralmente aumentam:

- custo de infraestrutura;
- complexidade operacional;
- requisitos de testes;
- complexidade do monitoramento;
- gerenciamento do estado de *failover*;
- dependências de segurança.

A arquitetura deve introduzir mecanismos mais robustos porque os requisitos os justificam, e não porque a terminologia corporativa pareça desejável.

### 23.47 Afirmações de Disponibilidade

As afirmações de disponibilidade devem descrever o que foi efetivamente implementado.

Afirmações apropriadas para a Versão 1 podem incluir:

**Demonstrado**
→ o consumidor da Bronze reinicializa e realiza *catch-up* após uma interrupção controlada.

**Demonstrado**
→ a Certified Gold anterior permanece disponível durante uma falha *upstream* controlada.

Afirmações não sustentadas podem incluir:

**A Atlas Engineering fornece Alta Disponibilidade corporativa**

quando a topologia contém dependências de nó único sem *failover*.

### 23.48 Afirmações de DR

As afirmações de DR devem identificar o domínio de falha efetivamente testado.

Por exemplo:

**Validado**
→ reinicialização lógica completa da plataforma a partir do estado local preservado.

Isso é diferente de:

**Validado**
→ recuperação após perda total da estação de trabalho.

E muito diferente de:

**Validado**
→ Recuperação de Desastre entre regiões.

A afirmação deve permanecer limitada pelo cenário.

### 23.49 Validação de Disponibilidade e DR

A validação deve confirmar, de acordo com a capacidade testada:

- falha detectada;
- impacto no serviço compreendido;
- redundância esperada ou ausência de redundância observada;
- estado necessário permanece recuperável;
- *failover* ou restauração se comporta conforme projetado;
- processamento *downstream* é retomado;
- *backlog* realiza *catch-up*;
- comportamento da Certified Gold permanece correto;
- estado final para o consumidor é validado.

### 23.50 Evidências de Disponibilidade, HA e DR

Evidências representativas podem preservar:

- domínio de falha;
- topologia;
- redundância dos componentes;
- redundância do armazenamento;
- momento da falha;
- detecção;
- ação de *failover* ou restauração;
- fonte de recuperação;
- ponto de recuperação alcançado;
- tempo de restauração técnica;
- tempo de recuperação do processamento;
- tempo de recuperação para o consumidor;
- estado final;
- limitações.

As evidências devem deixar claro qual capacidade foi efetivamente demonstrada.

### 23.51 Garantias de Disponibilidade, Alta Disponibilidade e Recuperação de Desastre

O modelo de disponibilidade e Recuperação de Desastre da Atlas Engineering deve preservar as seguintes garantias:

1. disponibilidade, confiabilidade, Alta Disponibilidade, capacidade de recuperação e Recuperação de Desastre permanecem conceitos distintos;
2. as afirmações de disponibilidade identificam a capacidade que está sendo avaliada;
3. disponibilidade do componente não implica atualidade do processamento ou analítica;
4. a disponibilidade analítica pode permanecer preservada por meio da Certified Gold durante uma falha *upstream*;
5. atualidade permanece distinta de disponibilidade;
6. dados reconhecidamente inválidos não são disponibilizados apenas para preservar uma disponibilidade aparente;
7. a saúde da plataforma pode permanecer parcialmente disponível, em vez de globalmente binária;
8. Alta Disponibilidade exige redundância ou *failover*, e não simples capacidade de reinicialização;
9. HA não garante independentemente correção dos dados ou perda zero de dados;
10. HA com estado considera replicação de estado, além da redundância de computação;
11. instâncias redundantes são avaliadas em relação a domínios de falha independentes;
12. *failover* automatizado deve preservar a correção e a responsabilidade do processamento;
13. Kafka de nó único da Versão 1 não é apresentado como HA com múltiplos *brokers*;
14. recuperação de uma única instância do SQL Server não é apresentada como HA do SQL Server;
15. armazenamento de objetos local de nó único não é apresentado como HA corporativa;
16. redundância de *workers* preserva semânticas de ordenação, *checkpoint* e idempotência;
17. dependências críticas de observabilidade e segurança podem participar do projeto corporativo de HA;
18. capacidade de recuperação pode ser demonstrada sem Alta Disponibilidade;
19. reinicialização, *replay*, *rebuild*, restauração de *backup* e *rollback* podem fornecer recuperação enquanto ainda exigem indisponibilidade;
20. Recuperação de Desastre trata falhas mais amplas do que a recuperação comum de componentes;
21. DR restaura infraestrutura, dependências de segurança, processamento, dados governados e consumo analítico quando afetados;
22. a recuperação de DR segue uma restauração orientada pelas dependências;
23. *backup* permanece um mecanismo dentro da DR, e não a capacidade completa de DR;
24. a capacidade de recuperação do *backup* é validada por meio de testes de restauração;
25. estado histórico restaurado pode exigir *replay*, *backfill*, *rebuild* e *catch-up*;
26. o RPO de DR depende de fontes de recuperação que sobrevivam ao domínio de falha contra o qual se busca proteção;
27. o RTO de DR inclui restauração, reconstrução, validação e recuperação para os consumidores;
28. as cópias de recuperação devem ser independentes do desastre contra o qual se busca proteção;
29. a Versão 1 não afirma DR fora do *host* ou entre regiões, a menos que esses mecanismos sejam efetivamente implementados e testados;
30. a Certified Gold pode reduzir o tempo de recuperação analítica quando uma cópia independente confiável sobrevive;
31. DR preserva os requisitos atuais de segurança e privacidade;
32. a disponibilidade das chaves de criptografia faz parte da capacidade de recuperação dos dados criptografados;
33. configurações e metadados relevantes participam da DR;
34. *runbooks* operacionais permanecem distintos da documentação de arquitetura;
35. a Versão 1 pode validar recuperação lógica coordenada do laboratório sem implicar DR corporativa;
36. domínios de falha compartilhados da estação de trabalho permanecem explícitos;
37. mecanismos corporativos de HA e DR são introduzidos de acordo com requisitos e evidências;
38. HA e DR mais robustas são avaliadas em relação a custo e complexidade operacional;
39. afirmações de disponibilidade e DR permanecem limitadas pela topologia e pelos cenários de falha efetivamente demonstrados;
40. o comportamento de disponibilidade, HA e DR é considerado demonstrado somente após validação controlada e evidências.

---

## 24. Limites de Confiabilidade do Laboratório e do Ambiente Corporativo

A Versão 1 da Atlas Engineering é implementada como um laboratório controlado de confiabilidade e recuperação.

Seu propósito é demonstrar comportamentos arquiteturais como:

- preservação de estado durável;
- capacidade de reinicialização;
- novas tentativas;
- tolerância à reentrega;
- idempotência;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*;
- recuperação de *backlog*;
- isolamento de falhas;
- tratamento de *poison records*;
- proteção da Certified Gold;
- *rollback*;
- validação da recuperação;
- análise de confiabilidade baseada em evidências.

A implementação física da Versão 1 não deve ser apresentada como equivalente a um ambiente corporativo de Alta Disponibilidade ou Recuperação de Desastre.

O princípio orientador é:

**Preservar a Propriedade de Confiabilidade → Permitir que o Mecanismo Físico Evolua**

### 24.1 Propósito de Confiabilidade do Laboratório

O laboratório da Versão 1 existe para validar se a arquitetura se comporta de maneira previsível sob condições controladas de falha.

Ele deve demonstrar questões como:

- Qual estado sobrevive à falha?
- De onde o processamento é retomado?
- O que é reentregue?
- A idempotência preserva a correção?
- O histórico retido pode passar por *replay*?
- O estado derivado pode passar por *rebuild*?
- O *backlog* converge?
- A Certified Gold permanece protegida?
- O *rollback* consegue restaurar a disponibilidade analítica?
- Quais tempos de recuperação são efetivamente observados?

O laboratório é, portanto, um ambiente de implementação e evidências, e não apenas um diagrama do comportamento pretendido.

### 24.2 Topologia Física do Laboratório

A Versão 1 pode operar com características como:

- uma estação de trabalho física;
- instâncias locais do SQL Server;
- serviços em contêiner de nó único ou com quantidade limitada de nós;
- armazenamento local;
- recursos compartilhados do *host*;
- separação física limitada de rede;
- nenhum *datacenter* secundário;
- nenhuma infraestrutura entre regiões.

Essas características criam domínios físicos de falha compartilhados.

Os limites lógicos de confiabilidade devem permanecer distinguíveis da redundância física.

### 24.3 Domínio de Falha de Host Único

Quando vários serviços da plataforma são executados em uma única estação de trabalho, essa estação se torna um domínio físico de falha compartilhado.

Uma única falha do *host* pode afetar simultaneamente:

- Kafka;
- MinIO;
- Airflow;
- serviços de processamento;
- Prometheus;
- Grafana;
- configuração local;
- artefatos de recuperação armazenados localmente.

Isso limita as afirmações de disponibilidade física e DR que a Versão 1 pode fazer.

Isso não impede o teste do comportamento lógico de recuperação.

### 24.4 Independência Lógica

Os componentes podem permanecer logicamente independentes mesmo quando estão fisicamente no mesmo local.

Por exemplo:

- Kafka retém o histórico de transporte;
- Bronze preserva o histórico analítico;
- Silver permanece reconstruível;
- Gold permanece derivada;
- Certified Gold permanece como um estado separado de publicação.

Essa independência lógica é importante porque preserva a arquitetura necessária para futura distribuição física.

A co-localização física não deve fazer com que a implementação consolide responsabilidades distintas de recuperação em um único estado indiferenciado.

### 24.5 Durabilidade do Laboratório

A Versão 1 pode demonstrar durabilidade de acordo com os mecanismos de armazenamento efetivamente implementados.

Exemplos podem incluir:

- persistência do SQL Server;
- eventos retidos no Kafka;
- objetos no MinIO;
- estado persistido do AtlasWarehouse;
- metadados de processamento.

As afirmações de durabilidade devem permanecer limitadas ao domínio de falha testado.

Por exemplo:

**Sobrevive à Reinicialização do Contêiner**
não implica:
**Sobrevive à Perda Completa do Host**.

### 24.6 Capacidade de Reinicialização do Laboratório

A Versão 1 deve demonstrar capacidade de reinicialização para componentes representativos.

Exemplos incluem:

- Debezium;
- consumidores Kafka;
- processamento da Bronze;
- processamento da Silver;
- cargas de trabalho coordenadas pelo Airflow;
- componentes de observabilidade.

A capacidade de reinicialização deve demonstrar:

- recuperação do progresso durável;
- comportamento correto de reentrega;
- tratamento do *backlog*;
- recuperação *downstream*.

Reinicializar um processo com sucesso é uma capacidade significativa do laboratório, mas não é HA corporativa.

### 24.7 Novas Tentativas e Reentrega no Laboratório

A Versão 1 pode demonstrar:

- novas tentativas limitadas;
- esgotamento das novas tentativas;
- *backoff* quando implementado;
- entrega duplicada;
- processamento idempotente;
- transições explícitas para falha persistente.

Essas propriedades são logicamente portáveis para um *deployment* corporativo.

A escala corporativa pode exigir diferentes limites de novas tentativas, controles de concorrência e ferramentas operacionais.

### 24.8 Replay no Laboratório

A Versão 1 deve demonstrar *replay* controlado do Kafka enquanto o histórico necessário permanecer retido.

O laboratório pode validar:

- seleção de *offset*;
- limites de *replay*;
- ordenação das partições;
- tratamento de duplicidades;
- recuperação *downstream*;
- evidências.

Isso demonstra a semântica de *replay*.

Isso não demonstra, de forma independente, resiliência do Kafka com múltiplos *brokers*.

### 24.9 Reprocessamento no Laboratório

A Versão 1 pode demonstrar reprocessamento histórico a partir de estado governado retido.

Cenários representativos podem incluir:

- reprodução com a mesma lógica;
- reprocessamento com lógica corrigida;
- processamento consciente de versão;
- escopo histórico limitado.

Isso demonstra reprodutibilidade e correção histórica controlada.

A evolução corporativa pode adicionar execução em maior escala, computação distribuída ou *pipelines* históricos automatizados.

### 24.10 Backfill no Laboratório

A Versão 1 pode demonstrar *backfill* controlado a partir do AtlasCommerce ou de outra origem governada.

O laboratório deve validar:

- extração limitada;
- impacto sobre a origem;
- proveniência;
- sobreposição com processamento ativo;
- reconciliação;
- recuperação *downstream*.

Ambientes corporativos podem exigir controles mais robustos de taxa na origem, serviços de extração ou infraestrutura dedicada de recuperação.

### 24.11 Rebuild no Laboratório

A Versão 1 deve demonstrar a reconstrução de estado derivado.

Exemplos representativos incluem:

**Bronze → Silver**

e:

**Silver → Gold**

O laboratório pode medir:

- volume de processamento;
- vazão;
- comportamento durante interrupções;
- capacidade de reinicialização;
- validação;
- tempo total de *rebuild*.

O resultado medido permanece específico à carga de trabalho e ao hardware da Versão 1.

### 24.12 Recuperação de Backlog no Laboratório

A recuperação de *backlog* é uma das demonstrações mais valiosas de confiabilidade da Versão 1.

O laboratório deve medir:

- acúmulo de *backlog*;
- idade do item pendente mais antigo;
- taxa de processamento;
- taxa de entrada;
- razão de *catch-up*;
- tempo de *catch-up*;
- migração do gargalo.

Esses resultados fornecem evidências reais para decisões posteriores de capacidade e escalabilidade.

### 24.13 Isolamento de Falhas no Laboratório

A Versão 1 pode validar o isolamento lógico de falhas por meio de cenários como:

- uma partição Kafka;
- uma entidade;
- um estágio de processamento;
- uma candidata Gold;
- um produto de dados.

A co-localização física ainda pode causar falhas mais amplas em cenários no nível do *host*.

A arquitetura deve distinguir isolamento lógico de isolamento físico.

### 24.14 Tratamento de Poison Records no Laboratório

A Versão 1 pode demonstrar:

- novas tentativas limitadas;
- classificação de falha persistente;
- quarentena ou bloqueio seguro;
- remediação;
- reprocessamento;
- reintegração.

Essa capacidade não exige infraestrutura em escala corporativa.

Ela depende principalmente de uma semântica correta de processamento e de tratamento governado de falhas.

### 24.15 Proteção da Certified Gold no Laboratório

A Versão 1 deve demonstrar que:

- candidatas incompletas permanecem isoladas;
- falha na certificação bloqueia a publicação;
- a Certified Gold anterior permanece disponível quando ainda for confiável;
- o *rollback* pode restaurar uma versão anterior;
- um *roll-forward* corrigido pode substituir a versão de *rollback*.

Essa é uma propriedade lógica forte de confiabilidade que permanece válida em diferentes escalas de *deployment*.

### 24.16 Atomicidade da Publicação no Laboratório

A Versão 1 deve implementar e validar um mecanismo de publicação que impeça os consumidores de observar um estado certificado misto e não controlado.

O mecanismo exato do SQL Server pode permanecer local.

A propriedade arquitetural é:

**O Consumidor Vê Uma Versão Governada Completa**

A evolução corporativa pode utilizar diferentes tecnologias de publicação enquanto preserva a mesma propriedade.

### 24.17 Evidências de RPO do Laboratório

A Versão 1 pode demonstrar pontos de recuperação alcançados em cenários controlados de falha.

Por exemplo:

- interrupção do consumidor;
- reconstrução da Bronze;
- *rebuild* da Silver;
- *rollback* da Certified Gold.

Essas observações devem ser descritas como:

**Ponto de Recuperação Observado sob Condições de Teste**

em vez de compromissos universais de RPO da plataforma.

### 24.18 Evidências de RTO do Laboratório

A Versão 1 deve medir durações representativas de recuperação.

As medições podem incluir:

- tempo de reinicialização;
- tempo de *catch-up*;
- tempo de *replay*;
- tempo de reprocessamento;
- tempo de *rebuild*;
- tempo de *rollback*;
- tempo de validação;
- tempo de recuperação ponta a ponta.

Os tempos observados em laboratório devem incluir o contexto da carga de trabalho e da topologia.

### 24.19 Disponibilidade do Laboratório

A Versão 1 pode demonstrar o comportamento de disponibilidade em limites lógicos.

Por exemplo:

**Falha Upstream**
→ a Certified Gold anterior permanece disponível.

Ela não pode demonstrar mecanismos de disponibilidade física que não existem, como:

- *failover* de *host*;
- *failover* do Kafka com múltiplos nós;
- armazenamento redundante do MinIO;
- *failover* regional.

### 24.20 Limite de Alta Disponibilidade do Laboratório

A Versão 1 não deve afirmar Alta Disponibilidade corporativa a menos que a topologia redundante e o *failover* reais sejam implementados.

Capacidades como:

- reinicializar um contêiner;
- reinicializar automaticamente um processo;
- executar *replay* de eventos retidos;
- executar *rebuild* de estado;

demonstram capacidade de recuperação e automação.

Elas não constituem, por si mesmas, HA.

### 24.21 Limite de Recuperação de Desastre do Laboratório

A Versão 1 pode demonstrar a recuperação coordenada da plataforma local a partir de estado preservado.

Ela pode não demonstrar recuperação após a perda completa da estação de trabalho se todo o estado e todos os *backups* necessários permanecerem nessa estação.

As afirmações de DR devem, portanto, identificar o domínio de falha efetivamente testado.

### 24.22 Evolução da Recuperação Fora do Host

Uma melhoria futura do laboratório poderia fortalecer a recuperação após perda do *host* preservando artefatos de recuperação selecionados fora da estação de trabalho principal.

Exemplos podem incluir:

- *backup* do SQL Server fora do *host*;
- *backup* externo do armazenamento de objetos;
- arquivo protegido;
- estação de trabalho secundária de recuperação.

Essa melhoria deve ser tratada como capacidade implementada adicional somente após validação.

### 24.23 Distribuição Física Corporativa

A evolução corporativa pode distribuir componentes entre:

- múltiplos *hosts*;
- zonas de disponibilidade;
- *datacenters*;
- regiões de nuvem;
- sistemas independentes de armazenamento.

A distribuição física fortalece a independência dos domínios de falha.

Ela deve preservar os mesmos limites lógicos de recuperação validados na Versão 1.

### 24.24 Confiabilidade Corporativa do Kafka

O Kafka corporativo pode fortalecer a confiabilidade por meio de:

- múltiplos *brokers*;
- partições replicadas;
- metadados baseados em quórum;
- domínios de falha distribuídos;
- eleição automática de líder;
- retenção em escala de produção;
- armazenamento em camadas, quando aplicável.

Esses mecanismos fortalecem a disponibilidade do transporte.

Eles não eliminam a necessidade de:

- semântica de *replay*;
- consumidores idempotentes;
- correção dos *checkpoints*;
- recuperação de *backlog*.

### 24.25 Confiabilidade Corporativa do SQL Server

O SQL Server corporativo pode fortalecer a disponibilidade e a recuperação por meio de:

- Always On Availability Groups;
- Failover Cluster Instances;
- arquitetura de *backup*;
- *backups* de *log*;
- procedimentos de restauração testados;
- recuperação geograficamente separada quando necessário.

Esses mecanismos fortalecem o limite de confiabilidade da origem e do banco de dados analítico.

Eles não eliminam os requisitos de recuperação do processamento *downstream*.

### 24.26 Confiabilidade Corporativa do Armazenamento de Objetos

O armazenamento corporativo de objetos pode fortalecer a durabilidade da Bronze e da Silver por meio de:

- nós distribuídos;
- replicação;
- *erasure coding*;
- proteção imutável quando apropriado;
- cópias entre *sites*;
- *backup* gerenciado.

O requisito arquitetural permanece:

**O Estado Histórico Durável Deve Sobreviver ao Domínio de Falha Contra o Qual Deve Proteger**

### 24.27 Confiabilidade Corporativa do Processamento

O processamento corporativo pode fortalecer a confiabilidade por meio de:

- computação distribuída;
- múltiplos *workers*;
- escalabilidade automática;
- isolamento de cargas de trabalho;
- cotas de recursos;
- reinicialização automatizada;
- *frameworks* resilientes de execução.

A capacidade adicional de computação deve preservar:

- ordenação;
- idempotência;
- correção dos *checkpoints*;
- linhagem;
- versão de processamento.

A escalabilidade não deve enfraquecer a correção.

### 24.28 Confiabilidade Corporativa da Orquestração

O Airflow corporativo ou uma orquestração equivalente pode utilizar:

- *schedulers* redundantes;
- *workers* distribuídos;
- banco de dados de metadados altamente disponível;
- ambientes gerenciados de execução.

A regra lógica permanece:

**O Estado da Orquestração Não Substitui o Estado Durável do Processamento de Dados**.

### 24.29 Confiabilidade Corporativa da Observabilidade

A observabilidade corporativa pode utilizar:

- armazenamento replicado de métricas;
- agregação centralizada de *logs*;
- *dashboards* redundantes;
- alertas externos;
- retenção de métricas de longo prazo.

Essas capacidades melhoram a capacidade de detectar e operar a recuperação.

Elas não substituem o estado durável de recuperação da própria plataforma de dados.

### 24.30 Estratégia Corporativa de Backup

A estratégia corporativa de *backup* pode incluir:

- *backup full* agendado;
- *backup* diferencial;
- *backup* de *log* de transações;
- *backup* do armazenamento de objetos;
- *backup* de configuração;
- *backup* de metadados;
- cópias fora do *site*;
- cópias imutáveis;
- políticas de retenção.

O projeto de *backup* deve estar alinhado aos requisitos reais de RPO e DR.

### 24.31 Automação Corporativa da Recuperação

Ambientes corporativos podem automatizar partes da recuperação, como:

- *failover*;
- reinicialização de serviços;
- substituição de credenciais;
- provisionamento de ambiente;
- restauração de *backup*;
- retomada do *pipeline*;
- validação.

A automação deve seguir um modelo de recuperação validado.

Automatizar um processo incorreto de recuperação aumenta a velocidade da falha, e não a confiabilidade.

### 24.32 Folga de Capacidade Corporativa

A confiabilidade corporativa exige capacidade suficiente para recuperação.

O planejamento de capacidade deve considerar:

- carga de trabalho em estado estável;
- carga de pico;
- *catch-up* do *backlog*;
- reprocessamento histórico;
- *rebuild*;
- atividade simultânea de recuperação.

Uma plataforma que opera com segurança apenas na capacidade normal de estado estável pode apresentar comportamento fraco de recuperação após uma interrupção.

### 24.33 Objetivos Corporativos de Recuperação

RPO, RTO, disponibilidade e objetivos de atualidade corporativos devem ser derivados dos requisitos reais de negócio.

As evidências da Versão 1 podem ajudar a estimar:

- gargalos;
- taxas de recuperação;
- riscos arquiteturais;
- relações de escalabilidade.

Os objetivos corporativos ainda exigem validação em relação à topologia e à carga de trabalho corporativas.

### 24.34 Substituição de Mecanismos

A evolução corporativa pode substituir um mecanismo de recuperação do laboratório enquanto preserva a mesma propriedade lógica de confiabilidade.

Por exemplo:

**Versão 1**
→ reinicializar um único *broker* Kafka.

**Corporativo**
→ *failover* de *broker* dentro de um *cluster* Kafka replicado.

A propriedade permanece:

**O Estado Necessário do Transporte de Eventos Permanece Disponível ou Recuperável**.

Outro exemplo:

**Versão 1**
→ executar *rebuild* da Silver a partir da Bronze local.

**Corporativo**
→ executar *rebuild* da Silver a partir de armazenamento de objetos distribuído.

O princípio de reconstrução permanece inalterado.

### 24.35 Fortalecimento dos Mecanismos

A evolução corporativa deve fortalecer as propriedades de confiabilidade, e não contorná-las.

Por exemplo:

**Bronze Local**
→ Bronze distribuída e replicada.

O mecanismo mais robusto deve preservar ou melhorar:

- durabilidade;
- interpretabilidade;
- capacidade de *replay*;
- controle de acesso;
- linhagem;
- capacidade de *rebuild*.

A substituição de tecnologia deve ser avaliada em relação à propriedade que ela protege.

### 24.36 Portabilidade da Confiabilidade

A Atlas Engineering deve definir os requisitos de confiabilidade independentemente de uma implementação específica de produto.

A arquitetura não deve definir:

**Reinicialização do Docker = Confiabilidade**

ou:

**Kafka = Capacidade de Recuperação**.

Em vez disso, ela define propriedades como:

- histórico durável de eventos;
- processamento reinicializável;
- reentrega idempotente;
- estado derivado reconstruível;
- proteção da publicação certificada.

As tecnologias implementam essas propriedades.

Elas não são as propriedades em si.

### 24.37 Limites das Evidências do Laboratório

As evidências da Versão 1 devem identificar as condições sob as quais o resultado foi observado.

O contexto relevante pode incluir:

- *hardware*;
- topologia;
- versões dos componentes;
- volume de dados;
- quantidade de partições;
- carga de trabalho;
- duração da falha;
- retenção;
- fonte de recuperação;
- versão de processamento.

Um PASS de laboratório demonstra o comportamento sob essas condições.

Ele não deve ser automaticamente generalizado além delas.

### 24.38 Afirmações do Laboratório versus Corporativas

Afirmações apropriadas para a Versão 1 podem incluir:

**Demonstrado**
→ o consumidor da Bronze se recupera a partir do histórico retido no Kafka após uma interrupção controlada.

**Demonstrado**
→ a Silver pode passar por *rebuild* a partir do histórico governado da Bronze no conjunto de dados testado.

**Demonstrado**
→ a Certified Gold anterior permanece disponível enquanto uma candidata com falha é bloqueada.

Afirmações amplas não sustentadas incluem:

**A Atlas Engineering fornece HA corporativa.**

**A Atlas Engineering fornece DR com perda zero de dados.**

**A Atlas Engineering atende aos requisitos de RTO e RPO de produção.**

As afirmações devem permanecer proporcionais à implementação e às evidências.

### 24.39 Documentação das Lacunas Corporativas

Quando a Versão 1 não implementar uma capacidade corporativa de confiabilidade, a documentação deve identificar:

- capacidade física ausente;
- propriedade lógica já preservada;
- limitação do laboratório;
- mecanismo corporativo esperado, quando conhecido.

Exemplos incluem:

**Propriedade Lógica**
→ *replay* de eventos do Kafka.

**Limitação do Laboratório**
→ único *broker*.

**Evolução Corporativa**
→ Kafka replicado com múltiplos *brokers*.

Isso torna explícito o caminho de evolução sem fingir que o mecanismo futuro já existe.

### 24.40 Evitando Teatro de Confiabilidade

Mecanismos de confiabilidade não devem ser implementados apenas para fazer a arquitetura parecer sofisticada.

Exemplos de teatro de confiabilidade incluem:

- manter *backups* que nunca foram restaurados;
- configurar novas tentativas sem observar seu esgotamento;
- afirmar capacidade de *replay* sem testar *offsets* retidos;
- afirmar capacidade de *rebuild* sem excluir ou isolar o destino;
- afirmar RTO sem medir o *catch-up*;
- afirmar HA porque o Docker reinicializa um contêiner;
- afirmar DR porque arquivos são copiados para outro diretório no mesmo disco.

Um conjunto menor de capacidades testadas e sustentadas por evidências é mais valioso do que um conjunto maior de rótulos não validados.

### 24.41 Evolução Corporativa Orientada por Evidências

As evidências do laboratório devem ajudar a justificar a evolução corporativa.

Por exemplo:

**Observado**
→ o *rebuild* da Silver consome tempo excessivo.

Possível evolução:

→ maior capacidade de processamento  
→ melhoria do particionamento  
→ *layout* de armazenamento otimizado.

Outro exemplo:

**Observado**
→ uma falha do *host* removeria simultaneamente Kafka e Bronze.

Possível evolução:

→ armazenamento distribuído independente e Kafka com múltiplos *hosts*.

As evidências fornecem uma razão técnica para o investimento em arquitetura corporativa.

### 24.42 ADRs de Confiabilidade

Decisões corporativas importantes de confiabilidade devem ser documentadas por meio de ADRs quando alterarem materialmente a arquitetura.

Exemplos incluem:

- modelo de replicação do Kafka;
- tecnologia de HA do SQL Server;
- modelo de replicação do armazenamento de objetos;
- arquitetura de *backup*;
- DR entre regiões;
- automação da recuperação;
- estratégia de escalabilidade automática do processamento.

Os ADRs devem preservar:

- contexto;
- alternativas;
- decisão;
- *trade-offs*;
- efeito sobre a confiabilidade;
- considerações de migração.

### 24.43 Validação do Laboratório para o Ambiente Corporativo

Um controle validado na Versão 1 deve ser revalidado quando o mecanismo de implementação mudar materialmente.

Por exemplo:

**Versão 1**
→ *replay* testado em Kafka de nó único.

Posteriormente:

**Corporativo**
→ Kafka replicado com múltiplos *brokers*.

A semântica de *replay* pode permanecer conceitualmente equivalente, mas:

- comportamento de falha;
- vazão;
- *failover*;
- retenção;
- ferramentas operacionais;

mudaram.

A implementação corporativa, portanto, exige suas próprias evidências.

### 24.44 Progressão da Maturidade da Confiabilidade

A Atlas Engineering pode descrever a evolução da confiabilidade por meio de estados progressivamente mais robustos, como:

**Projetado**
→ comportamento de recuperação definido.

**Implementado**
→ mecanismo existe.

**Testado**
→ cenário controlado executado.

**Demonstrado**
→ evidências sustentam o comportamento esperado.

**Escalado**
→ comportamento validado sob carga de trabalho representativa maior.

**Altamente Disponível**
→ topologia redundante necessária e *failover* validados.

**Recuperável de Desastre**
→ ambiente independente de recuperação e procedimento necessários validados.

Esses termos devem ser utilizados somente quando existirem as evidências correspondentes.

### 24.45 Linha de Base de Confiabilidade da Versão 1

Ao final dos testes de confiabilidade da Versão 1, o projeto deve manter uma linha de base identificando quais capacidades foram:

- projetadas;
- implementadas;
- testadas;
- demonstradas;
- medidas;
- adiadas para evolução corporativa.

A linha de base deve incluir limitações.

Uma limitação não é uma falha da arquitetura quando é deliberada, documentada e adequadamente delimitada.

### 24.46 Validação da Confiabilidade do Laboratório e do Ambiente Corporativo

A validação deve confirmar que:

- as afirmações da Versão 1 correspondem à topologia implementada;
- os limites lógicos permanecem preservados apesar da co-localização física;
- as propriedades de recuperação testadas permanecem reproduzíveis;
- as limitações estão explícitas;
- os mecanismos corporativos preservam os mesmos requisitos lógicos de confiabilidade;
- as afirmações arquiteturais não excedem as evidências.

### 24.47 Evidências de Confiabilidade do Laboratório e do Ambiente Corporativo

Evidências representativas podem preservar:

- topologia do laboratório;
- domínios de falha compartilhados;
- mecanismos de recuperação implementados;
- cenários testados;
- RPO observado;
- tempos de recuperação observados;
- taxas de *rebuild*;
- taxas de *catch-up*;
- comportamento de *rollback*;
- limitações conhecidas;
- evolução corporativa proposta.

Isso fornece uma ponte factual entre o laboratório de treinamento e a futura arquitetura de produção.

### 24.48 Garantias de Confiabilidade do Laboratório e do Ambiente Corporativo

O modelo de confiabilidade do laboratório e do ambiente corporativo da Atlas Engineering deve preservar as seguintes garantias:

1. a Versão 1 é um laboratório controlado de confiabilidade e recuperação;
2. os testes de laboratório demonstram comportamento efetivamente implementado, e não apenas intenção arquitetural;
3. os domínios físicos de falha compartilhados permanecem explícitos;
4. a co-localização física não elimina os limites lógicos de recuperação;
5. as afirmações de durabilidade permanecem limitadas ao domínio de falha testado;
6. a capacidade de reinicialização é demonstrada sem ser apresentada incorretamente como Alta Disponibilidade;
7. novas tentativas, reentrega, *replay*, reprocessamento, *backfill*, *rebuild*, recuperação de *backlog*, isolamento e tratamento de *poison records* podem ser significativamente validados no laboratório;
8. proteção da Certified Gold e *rollback* permanecem propriedades lógicas portáveis de confiabilidade;
9. atomicidade da publicação é definida como uma propriedade visível aos consumidores, independentemente de um mecanismo específico de implementação;
10. resultados de RPO e RTO do laboratório permanecem observações, e não compromissos universais de serviço;
11. comportamento lógico de disponibilidade pode ser demonstrado sem afirmar redundância física não implementada;
12. as limitações de *host* único da Versão 1 permanecem explícitas;
13. a distribuição física corporativa fortalece a independência dos domínios de falha;
14. Kafka, SQL Server, armazenamento, processamento, orquestração e observabilidade corporativos podem utilizar mecanismos mais robustos enquanto preservam os mesmos princípios lógicos;
15. o projeto corporativo de *backup* está alinhado aos requisitos reais de RPO e DR;
16. a automação da recuperação segue uma semântica de recuperação validada;
17. o planejamento corporativo de capacidade inclui folga para recuperação;
18. os objetivos corporativos de recuperação exigem requisitos de negócio corporativos e validação específica do ambiente corporativo;
19. os mecanismos de implementação podem ser substituídos enquanto as propriedades de confiabilidade permanecem estáveis;
20. a evolução corporativa fortalece, em vez de contornar, os limites de confiabilidade testados;
21. os requisitos de confiabilidade permanecem portáveis entre tecnologias;
22. as evidências do laboratório registram topologia, carga de trabalho e contexto da falha;
23. as afirmações de confiabilidade permanecem proporcionais às evidências;
24. capacidades corporativas não implementadas são documentadas como lacunas explícitas ou pontos de evolução;
25. o teatro de confiabilidade é evitado em favor de comportamento testado;
26. as evidências do laboratório orientam investimentos em arquitetura corporativa;
27. evoluções importantes de confiabilidade são documentadas por meio de ADRs quando apropriado;
28. mecanismos corporativos materialmente alterados são revalidados;
29. a terminologia de maturidade da confiabilidade é utilizada somente quando sustentada por evidências;
30. a Versão 1 mantém uma linha de base explícita de confiabilidade com capacidades demonstradas e limitações;
31. o comportamento de confiabilidade do laboratório e do ambiente corporativo é considerado válido somente nos ambientes e cenários efetivamente testados.

---

## 25. Garantias de Confiabilidade e Recuperação

A Atlas Engineering define confiabilidade e recuperação como propriedades arquiteturais que devem permanecer válidas ao longo da ingestão, transporte, processamento, armazenamento, certificação, publicação, consumo analítico e futura evolução da plataforma.

Os requisitos detalhados definidos ao longo deste documento permanecem autoritativos em suas respectivas seções.

Este capítulo consolida as principais garantias no nível da plataforma.

### 25.1 A Falha É Esperada

Falhas são tratadas como condições operacionais normais.

A arquitetura deve preservar estado durável, progresso do processamento, metadados e contexto de recuperação suficientes para impedir que uma falha comum se transforme automaticamente em perda descontrolada de dados, corrupção, duplicação ou estado irreversível de processamento.

### 25.2 Estado Durável Precede o Progresso

O progresso do processamento não deve avançar além do estado que foi persistido com segurança.

A regra orientadora é:

**Persistir o Estado Necessário → Confirmar o Sucesso → Avançar o Progresso**

Quando a coordenação atômica não estiver disponível, a reentrega segura é preferível à omissão silenciosa.

### 25.3 Capacidade de Reinicialização

Os componentes de processamento devem retomar a partir de progresso durável explícito, e não de suposições sobre o que pode ter sido concluído antes da interrupção.

A reinicialização permanece distinta de:

- nova tentativa;
- *replay*;
- reprocessamento;
- *backfill*;
- *rebuild*.

### 25.4 Recuperação Idempotente

Novas tentativas, reentregas, *replays*, reinicializações e reconstruções esperadas não devem criar efeitos de negócio duplicados não pretendidos.

A Atlas Engineering aceita que a mesma entrada lógica possa ser processada mais de uma vez.

A correção é preservada por processamento idempotente, e não por suposições não sustentadas de *exactly-once*.

### 25.5 Progresso Explícito do Processamento

O progresso relevante para recuperação deve permanecer explícito e durável quando necessário.

Progresso representativo pode incluir:

- posição da origem;
- *offset* Kafka;
- *checkpoint*;
- *watermark*;
- lote;
- intervalo de processamento;
- versão candidata;
- estado de certificação.

O tempo de atividade do serviço não substitui evidências do progresso do processamento.

### 25.6 Classificação de Falhas

As falhas são classificadas de acordo com sua consequência arquitetural, e não apenas pela tecnologia que reportou o erro.

A classificação considera:

- domínio da falha;
- escopo da falha;
- estado afetado;
- impacto *downstream*;
- risco à correção;
- risco de perda de dados;
- risco à capacidade de recuperação;
- janela de recuperação disponível.

### 25.7 Isolamento de Falhas

As falhas devem ser contidas no menor escopo seguro quando praticável.

O processamento válido independente pode continuar quando não depender do estado que falhou.

O processamento deve ser bloqueado quando sua continuidade violar:

- ordenação;
- completude;
- integridade referencial;
- qualidade;
- reconciliação;
- certificação;
- correção para os consumidores.

### 25.8 Nenhuma Perda Silenciosa

Uma entrada que falhou não deve desaparecer do caminho de processamento governado.

Quando o processamento não puder continuar, a plataforma deve preservar informações suficientes para determinar:

- o que falhou;
- qual entrada foi afetada;
- se a entrada permanece recuperável;
- qual progresso foi confirmado;
- qual remediação é necessária.

### 25.9 Nenhuma Corrupção Silenciosa

O sucesso da execução técnica não comprova dados corretos.

A recuperação não deve silenciosamente:

- duplicar efeitos de negócio;
- omitir registros necessários;
- reinterpretar o histórico incorretamente;
- ignorar qualidade;
- ignorar reconciliação;
- publicar estado incompleto.

A saída recuperada permanece sujeita aos controles de correção aplicáveis à sua camada.

### 25.10 Novas Tentativas Limitadas

Novas tentativas destinam-se a falhas que possam razoavelmente ser resolvidas sem alterar o significado de negócio subjacente.

As novas tentativas devem permanecer:

- limitadas;
- observáveis;
- adequadamente espaçadas;
- seguras sob execução repetida.

O esgotamento das novas tentativas transfere o trabalho para tratamento explícito de falha persistente.

### 25.11 Tratamento de Falhas Persistentes

Falhas determinísticas não devem permanecer em novas tentativas infinitas e não controladas.

Entradas com falha persistente devem ser:

- isoladas com segurança;
- colocadas em quarentena;
- ou utilizadas para bloquear o escopo de processamento afetado.

O comportamento selecionado deve preservar ordenação, completude e capacidade de recuperação.

### 25.12 Quarentena É Estado Governado

A quarentena preserva trabalho não resolvido.

Ela não é exclusão, descarte ou um destino oculto para erros.

O estado em quarentena deve permanecer:

- atribuível;
- observável;
- seguro;
- recuperável;
- associado à remediação e ao encerramento.

### 25.13 Backpressure Antes da Perda

Quando o processamento *downstream* não consegue acompanhar os dados recebidos, um *backlog* controlado é preferível à perda silenciosa.

O *backlog* deve permanecer limitado por:

- retenção;
- armazenamento;
- capacidade de processamento;
- objetivos de recuperação;
- requisitos de atualidade.

### 25.14 Seleção da Fonte de Recuperação

Uma fonte de recuperação é selecionada de acordo com:

- local da falha;
- estado invalidado;
- objetivo de recuperação;
- histórico disponível;
- contexto de interpretação histórica;
- confiança.

A disponibilidade física, isoladamente, não torna um estado uma fonte apropriada de recuperação.

### 25.15 Limite Confiável Apropriado Mais Recente

A recuperação normalmente deve começar a partir do limite confiável apropriado mais recente capaz de atender ao objetivo de recuperação.

O estado mais recente não é automaticamente preferível.

O estado mais antigo não é automaticamente mais seguro.

O estado selecionado deve ser apropriado e confiável.

### 25.16 Hierarquia das Fontes de Recuperação

A preferência conceitual para recuperação analítica é:

**Kafka**
→ *replay* normal de eventos retidos.

**Bronze**
→ reconstrução analítica histórica primária.

**Silver**
→ reconstrução *downstream* quando a Silver permanecer válida.

**AtlasCommerce / Backfill Controlado**
→ restauração quando o histórico necessário estiver indisponível nos caminhos analíticos retidos.

**Backup / Arquivo**
→ restauração mais ampla quando as fontes de recuperação *online* forem insuficientes.

Esse é um modelo de preferência, e não uma sequência obrigatória.

### 25.17 Replay

*Replay* é o reconsumo controlado de entradas previamente retidas.

O *replay* exige:

- histórico retido necessário completo;
- limites explícitos;
- ordenação preservada;
- processamento idempotente;
- progresso controlado;
- validação.

O *replay* não recria eventos que não existem mais.

### 25.18 Reprocessamento

Reprocessamento é a execução repetida e intencional de entradas históricas governadas.

Ele pode ser utilizado para:

- reprodução histórica;
- lógica corrigida;
- reapresentação histórica;
- regeneração de estado derivado.

A versão de processamento selecionada e o contexto histórico devem permanecer explícitos.

### 25.19 Backfill

*Backfill* introduz ou reconstrói o estado histórico necessário quando o *replay* comum de dados retidos não consegue atender completamente ao objetivo.

O *backfill* deve preservar:

- origem governada;
- escopo limitado;
- proveniência;
- controle da sobreposição com processamento ativo;
- reconciliação;
- linhagem.

Um *backfill* de estado atual não deve ser apresentado como reconstrução histórica de eventos.

### 25.20 Rebuild

*Rebuild* reconstrói estado derivado a partir de um limite *upstream* confiável.

Relações representativas incluem:

**Kafka → Bronze**

**Bronze → Silver**

**Silver → Gold**

O *rebuild* permanece sujeito a:

- controle da versão de processamento;
- capacidade de reinicialização;
- qualidade;
- reconciliação;
- linhagem;
- certificação, quando aplicável.

### 25.21 Capacidade de Recuperação Histórica

A capacidade de recuperação histórica exige mais do que dados retidos.

A plataforma deve preservar contexto suficiente de interpretação histórica, incluindo, quando necessário:

- *schemas*;
- contratos de eventos;
- definições de processamento;
- estado de referência;
- regras de qualidade;
- regras de reconciliação;
- metadados;
- linhagem.

A janela efetiva de recuperação histórica é limitada pela dependência governada necessária com a menor janela disponível.

### 25.22 Reprodução e Reapresentação Históricas

A recuperação histórica distingue:

**Reprodução**
→ reconstruir o resultado esperado de acordo com a definição histórica aplicável.

**Reapresentação**
→ recalcular intencionalmente dados históricos utilizando uma definição corrigida ou uma definição mais recente selecionada.

Os dois objetivos devem permanecer explícitos na versão de processamento e na linhagem.

### 25.23 Recuperação e Governança Atual

A recuperação histórica não restaura automaticamente uma governança obsoleta.

Os controles atualmente aplicáveis permanecem autoritativos para:

- identidade;
- autorização;
- privacidade;
- classificação;
- retenção;
- certificação;
- publicação.

O estado técnico histórico não deve ressuscitar confiança invalidada ou estado de dados proibido.

### 25.24 Recuperação de Backlog

O retorno de um serviço à operação não estabelece recuperação completa quando ainda existe trabalho acumulado.

O *catch-up* deve demonstrar que:

- o processamento é retomado a partir do progresso confirmado;
- o *backlog* diminui;
- a idade do item pendente mais antigo melhora;
- os *checkpoints* avançam;
- os estágios *downstream* se recuperam;
- a atualidade retorna em direção à sua faixa esperada.

### 25.25 Capacidade de Recuperação

O *backlog* só pode diminuir quando a capacidade efetiva de processamento excede a carga de trabalho recebida.

O planejamento da recuperação deve, portanto, considerar:

- vazão em estado estável;
- carga de pico;
- folga de capacidade para *catch-up*;
- desequilíbrio entre partições;
- capacidade *downstream*;
- carga das novas tentativas;
- carga de trabalho de *rebuild*.

O planejamento de capacidade inclui capacidade de recuperação, e não apenas operação normal.

### 25.26 Proteção da Janela de Recuperação

Fontes de recuperação limitadas devem permanecer observáveis.

A prioridade operacional deve aumentar quando o histórico necessário se aproximar da expiração.

Uma falha pode evoluir de:

**Problema de Atualidade**

para:

**Risco à Capacidade de Recuperação**

e, eventualmente:

**Risco de Perda de Dados**

se as janelas de recuperação forem esgotadas.

### 25.27 Proteção da Certified Gold

O estado da candidata Gold permanece isolado dos consumidores até que a certificação seja bem-sucedida.

Quando um novo processamento falha:

**Certified Gold Anterior Reconhecidamente Confiável**
→ permanece visível aos consumidores enquanto continuar confiável.

Isso preserva a disponibilidade analítica enquanto protege a correção.

### 25.28 Publicação Fail-Safe

A publicação deve expor uma versão completa e governada da Certified Gold.

Os consumidores não devem observar misturas não controladas de:

- estado anterior;
- novo estado incompleto;
- estado parcialmente promovido.

Uma falha de publicação deve preservar ou restaurar uma única versão claramente reconhecida como confiável.

### 25.29 Rollback

*Rollback* restaura uma versão anterior reconhecidamente confiável da Certified Gold.

*Rollback* é distinto de:

- *rebuild*;
- *replay*;
- restauração de *backup*.

O *rollback* pode restaurar a disponibilidade e a correção para os consumidores enquanto a atualidade permanece degradada.

A recuperação preferencial de longo prazo é um *roll-forward* corrigido.

### 25.30 Nenhum Estado Reconhecidamente Confiável

Se nenhuma versão da Certified Gold visível aos consumidores permanecer confiável, o produto analítico afetado pode ficar indisponível.

Dados reconhecidamente inválidos não devem ser disponibilizados apenas para preservar o tempo de atividade.

A correção tem precedência sobre a disponibilidade artificial.

### 25.31 A Recuperação É Multidimensional

A Atlas Engineering distingue:

**Recuperação do Componente**

**Recuperação do Processamento**

**Recuperação dos Dados**

**Recuperação da Correção**

**Recuperação para o Consumidor**

Esses estados podem ocorrer em momentos diferentes.

O retorno de um componente para `UP` não comprova recuperação completa.

### 25.32 Validação da Recuperação

A recuperação deve ser validada de acordo com a responsabilidade afetada.

A validação pode incluir:

- continuidade;
- correção dos *checkpoints*;
- detecção de lacunas;
- detecção de efeitos duplicados;
- ordenação;
- convergência do *backlog*;
- qualidade;
- reconciliação;
- linhagem;
- certificação;
- atualidade para os consumidores.

A conclusão bem-sucedida de um comando de recuperação não é, por si só, comprovação suficiente.

### 25.33 Evidências de Recuperação

Comportamentos significativos de recuperação devem ser sustentados por evidências.

A relação orientadora é:

**Estado Conhecido → Falha → Ação de Recuperação → Estado Recuperado → Validação → Evidências**

As evidências podem incluir:

- *offsets*;
- *checkpoints*;
- *logs*;
- métricas;
- metadados de processamento;
- contagens de registros;
- resultados de qualidade;
- reconciliação;
- histórico de certificação;
- histórico de publicação;
- consultas dos consumidores.

### 25.34 Testes de Recuperação

A Versão 1 valida a recuperação por meio de testes controlados de falha.

Os testes devem definir:

- estado inicial;
- hipótese;
- injeção da falha;
- impacto esperado;
- recuperação esperada;
- critérios de PASS;
- critérios de FAIL;
- limpeza;
- evidências.

Testes que resultem em falha ou sejam inconclusivos permanecem resultados válidos de engenharia.

### 25.35 Evidências Podem Alterar a Arquitetura

Os testes de recuperação podem demonstrar que uma premissa arquitetural está incorreta.

Quando as evidências contradisserem o projeto:

**Investigar → Corrigir Arquitetura ou Implementação → Revalidar**

A expectativa do teste não deve ser reescrita apenas para fabricar um PASS.

### 25.36 RPO

Recovery Point Objective representa um limite recuperável de dados.

O RPO pode diferir entre:

- origem;
- CDC;
- Kafka;
- Bronze;
- camadas derivadas;
- Certified Gold.

RPO não é sinônimo de intervalo de *backup*.

Afirmações de perda zero de dados permanecem limitadas às condições de falha efetivamente demonstradas.

### 25.37 RTO

Recovery Time Objective deve identificar a capacidade e o ponto final considerados recuperados.

Possíveis tempos de recuperação incluem:

- restauração técnica;
- recuperação do processamento;
- *catch-up*;
- *rebuild*;
- validação;
- restauração da Certified Gold;
- recuperação da atualidade para os consumidores.

A reinicialização do serviço, isoladamente, não constitui um RTO analítico ponta a ponta.

### 25.38 Disponibilidade e Atualidade

Disponibilidade e atualidade permanecem distintas.

Um produto de dados pode estar:

**Disponível e Atualizado**

**Disponível, mas Desatualizado**

**Indisponível**

Um estado certificado reconhecidamente confiável, porém desatualizado, pode ser preferível a um estado mais recente não validado.

### 25.39 Confiabilidade e Alta Disponibilidade

Confiabilidade é mais ampla do que Alta Disponibilidade.

Alta Disponibilidade exige redundância real, domínios de falha independentes e mecanismos de *failover*.

**Capacidade de Reinicialização ≠ Alta Disponibilidade**

**Capacidade de Recuperação ≠ Alta Disponibilidade**

A Versão 1 não deve afirmar HA corporativa quando uma topologia redundante não tiver sido implementada e validada.

### 25.40 Recuperação de Desastre

Recuperação de Desastre trata falhas mais amplas do que a recuperação comum de componentes.

DR pode exigir a restauração de:

- infraestrutura;
- dados duráveis;
- dependências de segurança;
- contratos;
- configuração;
- processamento;
- metadados;
- observabilidade;
- certificação;
- acesso dos consumidores.

*Backup* é um mecanismo de DR.

Ele não constitui, isoladamente, uma capacidade completa de DR.

### 25.41 Independência dos Domínios de Falha

Múltiplas cópias fornecem uma recuperação mais robusta somente quando sobrevivem ao domínio de falha contra o qual se busca proteção.

A arquitetura distingue:

**Quantidade de Cópias Lógicas**

de:

**Independência dos Domínios de Falha**

Redundância local em uma única estação de trabalho não deve ser apresentada como DR independente do *host*.

### 25.42 Observabilidade da Recuperação

O estado da recuperação deve ser observável por meio de sinais apropriados para cada responsabilidade.

Sinais relevantes podem incluir:

- saúde;
- estado das dependências;
- idade do *checkpoint*;
- *lag*;
- *backlog*;
- idade do item pendente mais antigo;
- vazão;
- estado das novas tentativas;
- quarentena;
- margem de retenção;
- atualidade;
- certificação;
- publicação.

A observabilidade deve distinguir a saúde dos serviços da saúde do fluxo de dados.

### 25.43 Convergência da Recuperação

Um processo de recuperação deve demonstrar convergência.

Evidências representativas incluem:

- *backlog* diminuindo;
- idade do item pendente mais antigo diminuindo;
- *checkpoints* avançando;
- novas tentativas diminuindo;
- quarentena sendo resolvida;
- limites *downstream* avançando;
- atualidade melhorando.

Um processo em execução que não converge não está completamente recuperado.

### 25.44 Afirmações de Confiabilidade

As afirmações de confiabilidade da Atlas Engineering devem permanecer proporcionais à implementação e às evidências.

O projeto distingue:

**Projetado**

**Implementado**

**Testado**

**Demonstrado**

e, quando evidências futuras as sustentarem:

**Escalado**

**Altamente Disponível**

**Recuperável de Desastre**

Esses rótulos não devem ser utilizados além da capacidade efetivamente validada.

### 25.45 Limite do Laboratório

A Versão 1 é um laboratório controlado de confiabilidade e recuperação.

Ela pode demonstrar comportamentos lógicos significativos, como:

- *replay*;
- idempotência;
- *rebuild*;
- recuperação de *backlog*;
- *rollback*;
- isolamento controlado de falhas.

Ela não demonstra automaticamente:

- HA com múltiplos nós;
- redundância independente do *host*;
- recuperação em escala de produção;
- DR entre regiões.

### 25.46 Evolução Corporativa

A implementação corporativa pode fortalecer a Versão 1 por meio de mecanismos como:

- Kafka com múltiplos nós;
- HA do SQL Server;
- armazenamento de objetos distribuído;
- computação redundante;
- orquestração resiliente;
- arquitetura de *backup* mais robusta;
- recuperação fora do *host*;
- *failover* automatizado;
- DR entre regiões.

Esses mecanismos fortalecem a resiliência física enquanto preservam os mesmos princípios lógicos de recuperação.

### 25.47 Teatro de Confiabilidade É Rejeitado

A Atlas Engineering não deve tratar a presença de uma tecnologia ou configuração como comprovação de confiabilidade.

Exemplos incluem:

**Backup Existe**
≠ **Restauração Demonstrada**

**Novas Tentativas Configuradas**
≠ **Falha Persistente Controlada**

**Kafka Retém Dados**
≠ **Replay Demonstrado**

**Contêiner Reinicializa**
≠ **Alta Disponibilidade**

**Arquivo Copiado Localmente**
≠ **Recuperação de Desastre**

**RTO Documentado**
≠ **RTO Medido**

A confiabilidade é demonstrada por meio de comportamento e evidências.

### 25.48 Princípio de Encerramento

A confiabilidade e a recuperação da Atlas Engineering são bem-sucedidas quando a plataforma consegue demonstrar que:

- falhas não causam perda silenciosa de dados governados;
- processamento repetido não cria efeitos de negócio não pretendidos;
- progresso durável permite reinicialização segura;
- trabalho que falhou permanece rastreável;
- fontes de recuperação permanecem explícitas e confiáveis;
- estado histórico pode ser interpretado enquanto sua janela de recuperação estiver disponível;
- o *backlog* pode convergir após uma interrupção;
- estado derivado pode ser reconstruído;
- estado reconhecidamente confiável para os consumidores é protegido;
- estado inválido não atravessa os limites de certificação;
- a recuperação preserva a governança atual;
- os resultados da recuperação são validados;
- afirmações de RPO e RTO são baseadas em evidências;
- as limitações do laboratório permanecem explícitas;
- a evolução corporativa fortalece, em vez de substituir, as propriedades fundamentais de confiabilidade.

O princípio orientador da Atlas Engineering é:

**Esperar a Falha → Preservar o Estado → Recuperar a Partir da Confiança → Revalidar a Correção → Restaurar a Disponibilidade Governada → Comprovar o que Foi Recuperado**