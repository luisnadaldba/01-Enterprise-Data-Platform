# Atlas Engineering — Estratégia de Captura

**Projeto:** Atlas Engineering — Enterprise Data Platform  
**Sistema de Origem:** AtlasCommerce  
**Domínio Inicial:** `AtlasCommerce.sales`  
**Versão do Documento:** V1  
**Status:** Aprovado

---

- [1. Objetivo](#1-objetivo)

- [2. Escopo](#2-escopo)
    - [2.1 Domínio Inicial](#21-domínio-inicial)
    - [2.2 Mecanismos de Captura no Escopo](#22-mecanismos-de-captura-no-escopo)
        - [SQL Server Change Data Capture](#sql-server-change-data-capture)
        - [Captura Incremental Baseada em Timestamp](#captura-incremental-baseada-em-timestamp)
        - [Snapshot + Diff](#snapshot--diff)
        - [Full Refresh Controlado](#full-refresh-controlado)
    - [2.3 Backfill Inicial e Captura Contínua](#23-backfill-inicial-e-captura-contínua)
    - [2.4 Proteção Operacional da Origem](#24-proteção-operacional-da-origem)
    - [2.5 Fora do Escopo](#25-fora-do-escopo)
    - [2.6 Limite da Evidência](#26-limite-da-evidência)

- [3. Princípios da Estratégia de Captura](#3-princípios-da-estratégia-de-captura)
    - [3.1 As Características da Origem Determinam o Mecanismo de Captura](#31-as-características-da-origem-determinam-o-mecanismo-de-captura)
    - [3.2 Capture Alterações Apenas Quando o Histórico de Alterações For Necessário](#32-capture-alterações-apenas-quando-o-histórico-de-alterações-for-necessário)
    - [3.3 A Detecção de DELETE Deve Ser um Requisito Explícito](#33-a-detecção-de-delete-deve-ser-um-requisito-explícito)
    - [3.4 Uma Watermark Deve Ser Confiável, Não Apenas Existir](#34-uma-watermark-deve-ser-confiável-não-apenas-existir)
    - [3.5 Prefira o Mecanismo Mais Simples que Atenda ao Requisito](#35-prefira-o-mecanismo-mais-simples-que-atenda-ao-requisito)
    - [3.6 Proteja a Origem OLTP](#36-proteja-a-origem-oltp)
    - [3.7 Proteja Alterações Futuras Antes de Carregar Dados Históricos](#37-proteja-alterações-futuras-antes-de-carregar-dados-históricos)
    - [3.8 Prefira Sobreposição Controlada a Lacunas Silenciosas](#38-prefira-sobreposição-controlada-a-lacunas-silenciosas)
    - [3.9 A Retenção da Captura É um Requisito de Recuperação](#39-a-retenção-da-captura-é-um-requisito-de-recuperação)
    - [3.10 Latência dos Dados e Janela de Recuperação São Requisitos Diferentes](#310-latência-dos-dados-e-janela-de-recuperação-são-requisitos-diferentes)
    - [3.11 Operações Físicas na Origem Devem Preservar a Semântica dos Dados](#311-operações-físicas-na-origem-devem-preservar-a-semântica-dos-dados)
    - [3.12 Não Invente Eventos Históricos](#312-não-invente-eventos-históricos)
    - [3.13 Captura Não É Armazenamento Histórico Permanente](#313-captura-não-é-armazenamento-histórico-permanente)
    - [3.14 A Evidência Prevalece sobre a Hipótese Inicial](#314-a-evidência-prevalece-sobre-a-hipótese-inicial)
    - [3.15 As Decisões de Captura Devem Permanecer Explícitas e Revisáveis](#315-as-decisões-de-captura-devem-permanecer-explícitas-e-revisáveis)

- [4. Classificação das Alterações na Origem](#4-classificação-das-alterações-na-origem)
    - [4.1 Por Que a Classificação da Origem É Importante](#41-por-que-a-classificação-da-origem-é-importante)
    - [4.2 Classificação Não É o Mecanismo de Captura](#42-classificação-não-é-o-mecanismo-de-captura)
    - [4.3 Categoria A — Alto Volume de Alterações](#43-categoria-a--alto-volume-de-alterações)
    - [4.4 Categoria B — Alterações Ocasionais](#44-categoria-b--alterações-ocasionais)
    - [4.5 Categoria C — Referência](#45-categoria-c--referência)
    - [4.6 Categoria D — Baixo Volume de Alterações / Sem Watermark](#46-categoria-d--baixo-volume-de-alterações--sem-watermark)
    - [4.7 Matriz Atual de Classificação V1](#47-matriz-atual-de-classificação-v1)
    - [4.8 A Classificação Pode Mudar](#48-a-classificação-pode-mudar)
    - [4.9 A Classificação Deve Ser Revalidada Durante a Implementação](#49-a-classificação-deve-ser-revalidada-durante-a-implementação)
    - [4.10 Resumo da Classificação](#410-resumo-da-classificação)

- [5. Critérios de Seleção do Mecanismo de Captura](#5-critérios-de-seleção-do-mecanismo-de-captura)
    - [5.1 Frequência de Alterações](#51-frequência-de-alterações)
    - [5.2 Requisito de Latência](#52-requisito-de-latência)
    - [5.3 Volume de Dados](#53-volume-de-dados)
    - [5.4 Tolerância à Perda de Alterações](#54-tolerância-à-perda-de-alterações)
    - [5.5 Disponibilidade de Watermark Confiável](#55-disponibilidade-de-watermark-confiável)
    - [5.6 Requisito de Detecção de DELETE](#56-requisito-de-detecção-de-delete)
    - [5.7 Sobrecarga Operacional](#57-sobrecarga-operacional)
    - [5.8 Os Critérios São Interdependentes](#58-os-critérios-são-interdependentes)
    - [5.9 Perguntas para Seleção](#59-perguntas-para-seleção)
    - [5.10 Modelo de Decisão do Mecanismo](#510-modelo-de-decisão-do-mecanismo)
    - [5.11 Comparação dos Mecanismos](#511-comparação-dos-mecanismos)
    - [5.12 A Seleção É Seguida pela Validação](#512-a-seleção-é-seguida-pela-validação)
    - [5.13 Registro de Decisão para Cada Origem](#513-registro-de-decisão-para-cada-origem)
    - [5.14 Princípio de Seleção](#514-princípio-de-seleção)

- [6. Estratégia de CDC](#6-estratégia-de-cdc)
    - [6.1 Tabelas Aplicáveis](#61-tabelas-aplicáveis)
    - [6.2 Fundamentação](#62-fundamentação)
        - [Captura Orientada a Alterações](#captura-orientada-a-alterações)
        - [Proteção do OLTP](#proteção-do-oltp)
    - [6.3 Modelo de Captura do SQL Server CDC](#63-modelo-de-captura-do-sql-server-cdc)
    - [6.4 O CDC É Assíncrono](#64-o-cdc-é-assíncrono)
    - [6.5 LSN como Conceito de Limite de Captura](#65-lsn-como-conceito-de-limite-de-captura)
    - [6.6 O Contexto da Transação É Importante](#66-o-contexto-da-transação-é-importante)
    - [6.7 Detecção de DELETE](#67-detecção-de-delete)
    - [6.8 Semântica de DELETE em Cascata](#68-semântica-de-delete-em-cascata)
    - [6.9 Janela de Recuperação do CDC](#69-janela-de-recuperação-do-cdc)
    - [6.10 A Retenção do CDC Não É Armazenamento Histórico](#610-a-retenção-do-cdc-não-é-armazenamento-histórico)
    - [6.11 Latência dos Dados e Retenção do CDC](#611-latência-dos-dados-e-retenção-do-cdc)
    - [6.12 Limpeza Faz Parte das Operações do CDC](#612-limpeza-faz-parte-das-operações-do-cdc)
    - [6.13 Governança de Partition Switch](#613-governança-de-partition-switch)
    - [6.14 Governança de SWITCH IN](#614-governança-de-switch-in)
    - [6.15 Governança de SWITCH OUT](#615-governança-de-switch-out)
    - [6.16 Backfill Inicial](#616-backfill-inicial)
    - [6.17 Estratégia de Cutover do CDC](#617-estratégia-de-cutover-do-cdc)
    - [6.18 Não Criar Histórico Pré-CDC Artificialmente](#618-não-criar-histórico-pré-cdc-artificialmente)
    - [6.19 Estratégia de CDC e Futura Integração com Debezium](#619-estratégia-de-cdc-e-futura-integração-com-debezium)
    - [6.20 Limite Atual da Validação](#620-limite-atual-da-validação)
    - [6.21 Resumo da Estratégia de CDC](#621-resumo-da-estratégia-de-cdc)

- [7. Estratégia de Timestamp Incremental](#7-estratégia-de-timestamp-incremental)
    - [7.1 Tabelas Aplicáveis](#71-tabelas-aplicáveis)
    - [7.2 Requisitos da Watermark](#72-requisitos-da-watermark)
        - [7.2.1 Alterações Relevantes Devem Atualizar a Watermark](#721-alterações-relevantes-devem-atualizar-a-watermark)
        - [7.2.2 A Precisão da Watermark Deve Ser Suficiente](#722-a-precisão-da-watermark-deve-ser-suficiente)
        - [7.2.3 Várias Linhas Podem Compartilhar a Mesma Watermark](#723-várias-linhas-podem-compartilhar-a-mesma-watermark)
        - [7.2.4 Os Valores da Watermark Não Devem Retroceder Inesperadamente](#724-os-valores-da-watermark-não-devem-retroceder-inesperadamente)
    - [7.3 Ordem de Commit e Ordem de Timestamp](#73-ordem-de-commit-e-ordem-de-timestamp)
    - [7.4 Semântica de Limite com `>` Versus `>=`](#74-semântica-de-limite-com--versus-)
    - [7.5 Watermark e Checkpoint São Relacionados, mas Diferentes](#75-watermark-e-checkpoint-são-relacionados-mas-diferentes)
    - [7.6 Fundamentação](#76-fundamentação)
    - [7.7 Limitação de DELETE](#77-limitação-de-delete)
    - [7.8 Consideração sobre DELETE lógico](#78-consideração-sobre-delete-lógico)
    - [7.9 Timestamp de Criação Geralmente Não É Suficiente para Capturar UPDATE](#79-timestamp-de-criação-geralmente-não-é-suficiente-para-capturar-update)
    - [7.10 Timestamps Gerenciados pela Aplicação Exigem Cuidado Adicional](#710-timestamps-gerenciados-pela-aplicação-exigem-cuidado-adicional)
    - [7.11 O Predicado de Extração Deve Permitir Busca Eficiente Sempre que Possível](#711-o-predicado-de-extração-deve-permitir-busca-eficiente-sempre-que-possível)
    - [7.12 Frequência da Extração Incremental](#712-frequência-da-extração-incremental)
    - [7.13 Falha na Extração e Segurança do Checkpoint](#713-falha-na-extração-e-segurança-do-checkpoint)
    - [7.14 Visibilidade Tardia Deve Ser Investigada](#714-visibilidade-tardia-deve-ser-investigada)
    - [7.15 Janelas de Releitura como Possível Mitigação](#715-janelas-de-releitura-como-possível-mitigação)
    - [7.16 Timestamp Incremental É uma Descoberta de Alterações Orientada a Estado](#716-timestamp-incremental-é-uma-descoberta-de-alterações-orientada-a-estado)
    - [7.17 Alterações Intermediárias Podem Ser Perdidas](#717-alterações-intermediárias-podem-ser-perdidas)
    - [7.18 Timestamp Incremental e Backfill Histórico](#718-timestamp-incremental-e-backfill-histórico)
    - [7.19 Testes Candidatos de Validação](#719-testes-candidatos-de-validação)
    - [7.20 Estado Atual da Validação](#720-estado-atual-da-validação)
    - [7.21 Resumo da Fundamentação](#721-resumo-da-fundamentação)

- [8. Estratégia de Snapshot + Diff](#8-estratégia-de-snapshot--diff)
    - [8.1 Tabelas Aplicáveis](#81-tabelas-aplicáveis)
    - [8.2 Fundamentação](#82-fundamentação)
    - [8.3 Detecção de Alterações](#83-detecção-de-alterações)
    - [8.4 Modelo Mental Baseado em Conjuntos](#84-modelo-mental-baseado-em-conjuntos)
    - [8.5 Snapshot É Estado, Não Histórico de Eventos](#85-snapshot-é-estado-não-histórico-de-eventos)
    - [8.6 A Frequência dos Snapshots Determina a Visibilidade](#86-a-frequência-dos-snapshots-determina-a-visibilidade)
    - [8.7 Chave de Comparação Confiável](#87-chave-de-comparação-confiável)
    - [8.8 Detecção de Adição](#88-detecção-de-adição)
    - [8.9 Detecção de Remoção](#89-detecção-de-remoção)
    - [8.10 Linhas Inalteradas](#810-linhas-inalteradas)
    - [8.11 O Snapshot Deve Ser Completo](#811-o-snapshot-deve-ser-completo)
    - [8.12 Snapshot Vazio É um Estado Perigoso](#812-snapshot-vazio-é-um-estado-perigoso)
    - [8.13 Validação do Snapshot](#813-validação-do-snapshot)
    - [8.14 O Snapshot Anterior É Estado Operacional](#814-o-snapshot-anterior-é-estado-operacional)
    - [8.15 Promoção do Snapshot](#815-promoção-do-snapshot)
    - [8.16 O Primeiro Snapshot Não Possui Estado Anterior](#816-o-primeiro-snapshot-não-possui-estado-anterior)
    - [8.17 Baseline Inicial Versus Diff Contínuo](#817-baseline-inicial-versus-diff-contínuo)
    - [8.18 Sobreposição Controlada e Reprocessamento](#818-sobreposição-controlada-e-reprocessamento)
    - [8.19 Consistência do Snapshot](#819-consistência-do-snapshot)
    - [8.20 Tamanho do Snapshot e Custo na Origem](#820-tamanho-do-snapshot-e-custo-na-origem)
    - [8.21 Snapshot + Diff Versus Full Refresh Controlado](#821-snapshot--diff-versus-full-refresh-controlado)
    - [8.22 Snapshot + Diff Versus Timestamp Incremental](#822-snapshot--diff-versus-timestamp-incremental)
    - [8.23 Snapshot + Diff Versus CDC](#823-snapshot--diff-versus-cdc)
    - [8.24 Remoção Não Equivale a Exclusão de Negócio](#824-remoção-não-equivale-a-exclusão-de-negócio)
    - [8.25 Semântica Temporal](#825-semântica-temporal)
    - [8.26 Comparação Baseada em Hash como Técnica Futura](#826-comparação-baseada-em-hash-como-técnica-futura)
    - [8.27 Alterações de Schema Devem Ser Governadas](#827-alterações-de-schema-devem-ser-governadas)
    - [8.28 Fluxo Candidato de Implementação](#828-fluxo-candidato-de-implementação)
    - [8.29 Testes Candidatos de Validação](#829-testes-candidatos-de-validação)
    - [8.30 Estado Atual da Validação](#830-estado-atual-da-validação)
    - [8.31 Resumo da Fundamentação](#831-resumo-da-fundamentação)

- [9. Estratégia de Full Refresh Controlado](#9-estratégia-de-full-refresh-controlado)
    - [9.1 Tabelas Aplicáveis](#91-tabelas-aplicáveis)
    - [9.2 Fundamentação](#92-fundamentação)
    - [9.3 Estado Atual Versus Histórico de Alterações](#93-estado-atual-versus-histórico-de-alterações)
    - [9.4 Por Que CDC Não Foi Selecionado](#94-por-que-cdc-não-foi-selecionado)
    - [9.5 Por Que Timestamp Incremental Não É Preferido](#95-por-que-timestamp-incremental-não-é-preferido)
    - [9.6 Por Que Snapshot + Diff Não É Necessário](#96-por-que-snapshot--diff-não-é-necessário)
    - [9.7 Extração Completa da Origem](#97-extração-completa-da-origem)
    - [9.8 Full Refresh Não Significa Substituição Descontrolada](#98-full-refresh-não-significa-substituição-descontrolada)
    - [9.9 Estado Candidato e Estado Aceito](#99-estado-candidato-e-estado-aceito)
    - [9.10 Limites da Atualização](#910-limites-da-atualização)
    - [9.11 Uma Atualização com Falha Deve Preservar o Estado Válido Anterior](#911-uma-atualização-com-falha-deve-preservar-o-estado-válido-anterior)
    - [9.12 Proteção Contra Resultado Vazio](#912-proteção-contra-resultado-vazio)
    - [9.13 Validação da Referência](#913-validação-da-referência)
    - [9.14 Detecção de Alterações Legítimas nas Referências](#914-detecção-de-alterações-legítimas-nas-referências)
    - [9.15 Valores de Referência Adicionados](#915-valores-de-referência-adicionados)
    - [9.16 Valores de Referência Modificados](#916-valores-de-referência-modificados)
    - [9.17 Valores de Referência Removidos](#917-valores-de-referência-removidos)
    - [9.18 Integridade da Referência e Histórico Transacional](#918-integridade-da-referência-e-histórico-transacional)
    - [9.19 Estado Atual Autoritativo](#919-estado-atual-autoritativo)
    - [9.20 Frequência da Atualização](#920-frequência-da-atualização)
    - [9.21 Full Refresh e o SLO de Latência da Plataforma](#921-full-refresh-e-o-slo-de-latência-da-plataforma)
    - [9.22 Full Refresh e Carga Inicial](#922-full-refresh-e-carga-inicial)
    - [9.23 Nenhuma Invenção de Eventos Históricos](#923-nenhuma-invenção-de-eventos-históricos)
    - [9.24 Promoção Controlada](#924-promoção-controlada)
    - [9.25 Idempotência do Full Refresh](#925-idempotência-do-full-refresh)
    - [9.26 Modelo de Falha e Nova Tentativa](#926-modelo-de-falha-e-nova-tentativa)
    - [9.27 Desaparecimento do Estado Atual Versus Evento Histórico de DELETE](#927-desaparecimento-do-estado-atual-versus-evento-histórico-de-delete)
    - [9.28 Evolução de Schema](#928-evolução-de-schema)
    - [9.29 Full Refresh Controlado Não É `SELECT *`](#929-full-refresh-controlado-não-é-select-)
    - [9.30 Testes Candidatos de Validação](#930-testes-candidatos-de-validação)
    - [9.31 Estado Atual da Validação](#931-estado-atual-da-validação)
    - [9.32 Resumo da Fundamentação](#932-resumo-da-fundamentação)

- [10. Estratégia de Backfill Inicial e Cutover](#10-estratégia-de-backfill-inicial-e-cutover)
    - [10.1 Estado Inicial](#101-estado-inicial)
        - [10.1.1 Backfill Representa Estado Conhecido](#1011-backfill-representa-estado-conhecido)
        - [10.1.2 Dados Existentes Continuam Sendo Histórico de Negócio](#1012-dados-existentes-continuam-sendo-histórico-de-negócio)
        - [10.1.3 Proveniência Candidata da Ingestão](#1013-proveniência-candidata-da-ingestão)
    - [10.2 Limite de Captura](#102-limite-de-captura)
        - [10.2.1 Limite do CDC](#1021-limite-do-cdc)
        - [10.2.2 Limite do Timestamp Incremental](#1022-limite-do-timestamp-incremental)
        - [10.2.3 Limite do Snapshot + Diff](#1023-limite-do-snapshot--diff)
        - [10.2.4 Limite do Full Refresh Controlado](#1024-limite-do-full-refresh-controlado)
    - [10.3 Sobreposição Controlada](#103-sobreposição-controlada)
        - [10.3.1 Por Que a Sobreposição É Mais Segura](#1031-por-que-a-sobreposição-é-mais-segura)
        - [10.3.2 A Sobreposição Deve Ser Deliberada](#1032-a-sobreposição-deve-ser-deliberada)
    - [10.4 Limitações do Estado Histórico](#104-limitações-do-estado-histórico)
        - [10.4.1 Linha Histórica Atual Versus Evento Histórico](#1041-linha-histórica-atual-versus-evento-histórico)
        - [10.4.2 O Limite de Captura Cria um Limite de Evidência](#1042-o-limite-de-captura-cria-um-limite-de-evidência)
        - [10.4.3 Ausência de Evidência Deve Permanecer Ausência de Evidência](#1043-ausência-de-evidência-deve-permanecer-ausência-de-evidência)
    - [10.5 Proteja o Futuro Primeiro](#105-proteja-o-futuro-primeiro)
    - [10.6 Exemplo de Cutover Inseguro](#106-exemplo-de-cutover-inseguro)
    - [10.7 Exemplo do Cutover Preferido](#107-exemplo-do-cutover-preferido)
    - [10.8 Backfill Não Precisa Ser em Tempo Real](#108-backfill-não-precisa-ser-em-tempo-real)
    - [10.9 Backfill Deve Proteger a Origem OLTP](#109-backfill-deve-proteger-a-origem-oltp)
    - [10.10 Cópia Restaurada como Opção de Backfill](#1010-cópia-restaurada-como-opção-de-backfill)
    - [10.11 Ordenação do Backfill](#1011-ordenação-do-backfill)
    - [10.12 Segmentação do Backfill](#1012-segmentação-do-backfill)
    - [10.13 Checkpoint do Backfill](#1013-checkpoint-do-backfill)
    - [10.14 Captura Contínua Durante o Backfill](#1014-captura-contínua-durante-o-backfill)
    - [10.15 Exemplo de Sobreposição Controlada](#1015-exemplo-de-sobreposição-controlada)
    - [10.16 Sobreposição Não Significa que o CDC Deve Ser Descartado](#1016-sobreposição-não-significa-que-o-cdc-deve-ser-descartado)
    - [10.17 Reconciliação](#1017-reconciliação)
    - [10.18 Contagens São Úteis, mas Não Suficientes](#1018-contagens-são-úteis-mas-não-suficientes)
    - [10.19 Agregados de Negócio como Evidência de Reconciliação](#1019-agregados-de-negócio-como-evidência-de-reconciliação)
    - [10.20 Critérios de Conclusão do Cutover](#1020-critérios-de-conclusão-do-cutover)
    - [10.21 Estado Estável](#1021-estado-estável)
    - [10.22 Recuperação Durante o Cutover](#1022-recuperação-durante-o-cutover)
    - [10.23 Cleanup do CDC Durante o Backfill](#1023-cleanup-do-cdc-durante-o-backfill)
    - [10.24 O Limite de Captura Deve Ser Registrado](#1024-o-limite-de-captura-deve-ser-registrado)
    - [10.25 Backfill Deve Ser Repetível](#1025-backfill-deve-ser-repetível)
    - [10.26 Backfill e Bronze](#1026-backfill-e-bronze)
    - [10.27 Backfill Não Estende o CDC para o Passado](#1027-backfill-não-estende-o-cdc-para-o-passado)
    - [10.28 Cutover Específico de Cada Mecanismo Deve Ser Testado](#1028-cutover-específico-de-cada-mecanismo-deve-ser-testado)
    - [10.29 Testes Candidatos de Validação do Cutover](#1029-testes-candidatos-de-validação-do-cutover)
    - [10.30 Estado Atual da Validação](#1030-estado-atual-da-validação)
    - [10.31 Resumo da Estratégia](#1031-resumo-da-estratégia)

- [11. Matriz da Estratégia de Captura](#11-matriz-da-estratégia-de-captura)
    - [11.1 Matriz da Estratégia de Captura V1](#111-matriz-da-estratégia-de-captura-v1)
    - [11.2 Como Interpretar Corretamente a Matriz](#112-como-interpretar-corretamente-a-matriz)
    - [11.3 Modelo Mental dos Mecanismos](#113-modelo-mental-dos-mecanismos)
    - [11.4 Origens Transacionais](#114-origens-transacionais)
    - [11.5 Origens Descritivas](#115-origens-descritivas)
    - [11.6 Origem de Relacionamento](#116-origem-de-relacionamento)
    - [11.7 Origens de Referência](#117-origens-de-referência)
    - [11.8 Semântica de DELETE por Mecanismo](#118-semântica-de-delete-por-mecanismo)
        - [CDC](#cdc)
        - [Timestamp Incremental](#timestamp-incremental)
        - [Snapshot + Diff](#snapshot--diff-1)
        - [Full Refresh Controlado](#full-refresh-controlado-1)
    - [11.9 Matriz de Dependência de Watermark](#119-matriz-de-dependência-de-watermark)
    - [11.10 Matriz de Fidelidade das Alterações](#1110-matriz-de-fidelidade-das-alterações)
    - [11.11 Comportamento do Estado Inicial](#1111-comportamento-do-estado-inicial)
    - [11.12 Considerações de Recuperação](#1112-considerações-de-recuperação)
        - [CDC](#cdc-1)
        - [Timestamp Incremental](#timestamp-incremental-1)
        - [Snapshot + Diff](#snapshot--diff-2)
        - [Full Refresh Controlado](#full-refresh-controlado-2)
    - [11.13 Comparação da Complexidade Operacional](#1113-comparação-da-complexidade-operacional)
    - [11.14 Visão de Proteção do OLTP](#1114-visão-de-proteção-do-oltp)
    - [11.15 Modelo de Estado da Validação](#1115-modelo-de-estado-da-validação)
    - [11.16 Limite de Ponta a Ponta](#1116-limite-de-ponta-a-ponta)
    - [11.17 Gatilhos para Revisão da Matriz](#1117-gatilhos-para-revisão-da-matriz)
    - [11.18 Avaliação de Nova Origem](#1118-avaliação-de-nova-origem)
    - [11.19 Visão Consolidada da V1](#1119-visão-consolidada-da-v1)
    - [11.20 Resumo da Matriz](#1120-resumo-da-matriz)

- [12. Trade-offs e Limitações Aceitas](#12-trade-offs-e-limitações-aceitas)
    - [12.1 A Heterogeneidade da Captura É Intencional](#121-a-heterogeneidade-da-captura-é-intencional)
    - [12.2 A Retenção do CDC É Finita](#122-a-retenção-do-cdc-é-finita)
    - [12.3 O CDC Não Reconstrói o Histórico Anterior à Habilitação](#123-o-cdc-não-reconstrói-o-histórico-anterior-à-habilitação)
    - [12.4 O Backfill Fornece Estado, Não a Evolução Histórica Completa](#124-o-backfill-fornece-estado-não-a-evolução-histórica-completa)
    - [12.5 Timestamp Incremental Depende da Semântica da Origem](#125-timestamp-incremental-depende-da-semântica-da-origem)
    - [12.6 Timestamp Incremental Não Detecta Inerentemente DELETE Físico](#126-timestamp-incremental-não-detecta-inerentemente-delete-físico)
    - [12.7 Timestamp Incremental Pode Não Preservar Estados Intermediários](#127-timestamp-incremental-pode-não-preservar-estados-intermediários)
    - [12.8 Limites de Timestamp Podem Exigir Sobreposição Controlada](#128-limites-de-timestamp-podem-exigir-sobreposição-controlada)
    - [12.9 Snapshot + Diff Captura a Diferença Líquida de Estado](#129-snapshot--diff-captura-a-diferença-líquida-de-estado)
    - [12.10 A Frequência dos Snapshots Limita a Precisão Temporal](#1210-a-frequência-dos-snapshots-limita-a-precisão-temporal)
    - [12.11 A Completude do Snapshot É Crítica](#1211-a-completude-do-snapshot-é-crítica)
    - [12.12 Snapshot + Diff Exige o Estado Anterior Aceito](#1212-snapshot--diff-exige-o-estado-anterior-aceito)
    - [12.13 Full Refresh Controlado Não Preserva o Histórico de Eventos da Origem](#1213-full-refresh-controlado-não-preserva-o-histórico-de-eventos-da-origem)
    - [12.14 Full Refresh Pode Apresentar Defasagem Temporária em Relação ao Estado da Origem](#1214-full-refresh-pode-apresentar-defasagem-temporária-em-relação-ao-estado-da-origem)
    - [12.15 A Simplicidade do Full Refresh Depende do Tamanho da Origem](#1215-a-simplicidade-do-full-refresh-depende-do-tamanho-da-origem)
    - [12.16 As Contagens Atuais de Linhas Não São Contratos Permanentes](#1216-as-contagens-atuais-de-linhas-não-são-contratos-permanentes)
    - [12.17 O Contexto Transacional do CDC Não Comprova Atomicidade Downstream](#1217-o-contexto-transacional-do-cdc-não-comprova-atomicidade-downstream)
    - [12.18 Uma Ação da Aplicação Não Equivale à Quantidade de Linhas no CDC](#1218-uma-ação-da-aplicação-não-equivale-à-quantidade-de-linhas-no-cdc)
    - [12.19 Partition SWITCH Não É CDC Comum em Nível de Linha](#1219-partition-switch-não-é-cdc-comum-em-nível-de-linha)
    - [12.20 SWITCH OUT Não É um DELETE de Negócio](#1220-switch-out-não-é-um-delete-de-negócio)
    - [12.21 SWITCH IN Não É o Caminho Normal de Ingestão](#1221-switch-in-não-é-o-caminho-normal-de-ingestão)
    - [12.22 O CDC Assíncrono Introduz Atraso de Visibilidade](#1222-o-cdc-assíncrono-introduz-atraso-de-visibilidade)
    - [12.23 O Tempo Observado no Laboratório Não É um SLO](#1223-o-tempo-observado-no-laboratório-não-é-um-slo)
    - [12.24 Recuperação e Latência São Dimensões Diferentes](#1224-recuperação-e-latência-são-dimensões-diferentes)
    - [12.25 Maior Retenção Significa Maior Uso de Armazenamento no Lado da Origem](#1225-maior-retenção-significa-maior-uso-de-armazenamento-no-lado-da-origem)
    - [12.26 A Idempotência Downstream É Necessária, mas Ainda Não Foi Comprovada](#1226-a-idempotência-downstream-é-necessária-mas-ainda-não-foi-comprovada)
    - [12.27 Exactly-Once Não É Reivindicado](#1227-exactly-once-não-é-reivindicado)
    - [12.28 A Captura na Origem Não Resolve Toda a Semântica Downstream](#1228-a-captura-na-origem-não-resolve-toda-a-semântica-downstream)
    - [12.29 A Captura Não É Responsável pelo Armazenamento Histórico Permanente](#1229-a-captura-não-é-responsável-pelo-armazenamento-histórico-permanente)
    - [12.30 A Captura Não Pode Garantir Recuperação sem Checkpoints](#1230-a-captura-não-pode-garantir-recuperação-sem-checkpoints)
    - [12.31 A Estratégia de Captura Não Elimina a Reconciliação](#1231-a-estratégia-de-captura-não-elimina-a-reconciliação)
    - [12.32 A Reconciliação Pode Exigir Múltiplos Tipos de Evidência](#1232-a-reconciliação-pode-exigir-múltiplos-tipos-de-evidência)
    - [12.33 A Disponibilidade da Origem Continua Sendo uma Dependência](#1233-a-disponibilidade-da-origem-continua-sendo-uma-dependência)
    - [12.34 A Evolução de Schema Pode Invalidar Premissas de Captura](#1234-a-evolução-de-schema-pode-invalidar-premissas-de-captura)
    - [12.35 As Decisões de Mecanismo Podem Ser Revisadas](#1235-as-decisões-de-mecanismo-podem-ser-revisadas)
    - [12.36 A Simplicidade Operacional É um Requisito](#1236-a-simplicidade-operacional-é-um-requisito)
    - [12.37 A Simplicidade Não Deve Se Sobrepor à Correção](#1237-a-simplicidade-não-deve-se-sobrepor-à-correção)
    - [12.38 Resumo dos Trade-offs Aceitos na V1](#1238-resumo-dos-trade-offs-aceitos-na-v1)
    - [12.39 O Que a V1 Explicitamente Não Afirma](#1239-o-que-a-v1-explicitamente-não-afirma)
    - [12.40 Governança das Limitações Aceitas](#1240-governança-das-limitações-aceitas)
    - [12.41 Princípio dos Trade-offs](#1241-princípio-dos-trade-offs)

- [13. Limites da Estratégia](#13-limites-da-estratégia)
    - [13.1 Responsabilidades Incluídas](#131-responsabilidades-incluídas)
    - [13.2 A Aquisição na Origem É o Limite](#132-a-aquisição-na-origem-é-o-limite)
    - [13.3 Captura CDC Versus Consumo CDC](#133-captura-cdc-versus-consumo-cdc)
    - [13.4 As Funções do CDC São Responsabilidades de Consumo](#134-as-funções-do-cdc-são-responsabilidades-de-consumo)
    - [13.5 A Implementação do Checkpoint Está Fora Desta Estratégia](#135-a-implementação-do-checkpoint-está-fora-desta-estratégia)
    - [13.6 Offset do Kafka Não É um Limite de Captura da Origem](#136-offset-do-kafka-não-é-um-limite-de-captura-da-origem)
    - [13.7 Debezium Está Fora da Decisão de Captura na Origem](#137-debezium-está-fora-da-decisão-de-captura-na-origem)
    - [13.8 A Semântica de Entrega do Kafka Está Fora Desta Estratégia](#138-a-semântica-de-entrega-do-kafka-está-fora-desta-estratégia)
    - [13.9 O Contexto Transacional da Origem Não Define Atomicidade no Kafka](#139-o-contexto-transacional-da-origem-não-define-atomicidade-no-kafka)
    - [13.10 A Persistência em Bronze Está Fora Desta Estratégia](#1310-a-persistência-em-bronze-está-fora-desta-estratégia)
    - [13.11 A Retenção da Captura Não É a Retenção da Bronze](#1311-a-retenção-da-captura-não-é-a-retenção-da-bronze)
    - [13.12 A Persistência Atômica na Bronze Está Fora Desta Estratégia](#1312-a-persistência-atômica-na-bronze-está-fora-desta-estratégia)
    - [13.13 As Responsabilidades da Silver Estão Fora Desta Estratégia](#1313-as-responsabilidades-da-silver-estão-fora-desta-estratégia)
    - [13.14 A Idempotência de Ponta a Ponta Está Fora Desta Estratégia](#1314-a-idempotência-de-ponta-a-ponta-está-fora-desta-estratégia)
    - [13.15 Exactly-Once Está Fora Desta Estratégia](#1315-exactly-once-está-fora-desta-estratégia)
    - [13.16 A Semântica de Negócio da Silver Está Fora Desta Estratégia](#1316-a-semântica-de-negócio-da-silver-está-fora-desta-estratégia)
    - [13.17 A Modelagem Gold Está Fora Desta Estratégia](#1317-a-modelagem-gold-está-fora-desta-estratégia)
    - [13.18 O Gerenciamento do Histórico das Dimensões Está Fora Desta Estratégia](#1318-o-gerenciamento-do-histórico-das-dimensões-está-fora-desta-estratégia)
    - [13.19 Power BI Está Fora Desta Estratégia](#1319-power-bi-está-fora-desta-estratégia)
    - [13.20 A Orquestração com Airflow Está Fora Desta Estratégia](#1320-a-orquestração-com-airflow-está-fora-desta-estratégia)
    - [13.21 A Implementação da Observabilidade Está Fora Desta Estratégia](#1321-a-implementação-da-observabilidade-está-fora-desta-estratégia)
    - [13.22 O Catálogo de Dados e a Plataforma de Metadados Estão Fora Desta Estratégia](#1322-o-catálogo-de-dados-e-a-plataforma-de-metadados-estão-fora-desta-estratégia)
    - [13.23 Schema Registry Está Fora Desta Estratégia](#1323-schema-registry-está-fora-desta-estratégia)
    - [13.24 A Estratégia de Captura Não Define o Caminho Físico das Mensagens](#1324-a-estratégia-de-captura-não-define-o-caminho-físico-das-mensagens)
    - [13.25 A Recuperação É Compartilhada entre as Camadas Arquiteturais](#1325-a-recuperação-é-compartilhada-entre-as-camadas-arquiteturais)
    - [13.26 Replay Está Fora da Estratégia de Captura](#1326-replay-está-fora-da-estratégia-de-captura)
    - [13.27 A Reconciliação Se Estende Além da Captura](#1327-a-reconciliação-se-estende-além-da-captura)
    - [13.28 O Desempenho Além do Limite da Origem É uma Responsabilidade Separada](#1328-o-desempenho-além-do-limite-da-origem-é-uma-responsabilidade-separada)
    - [13.29 A Latência da Plataforma É de Ponta a Ponta](#1329-a-latência-da-plataforma-é-de-ponta-a-ponta)
    - [13.30 A Segurança Além do Acesso à Origem Está Fora Desta Estratégia](#1330-a-segurança-além-do-acesso-à-origem-está-fora-desta-estratégia)
    - [13.31 A Qualidade de Dados É Mais Ampla do que a Correção da Captura](#1331-a-qualidade-de-dados-é-mais-ampla-do-que-a-correção-da-captura)
    - [13.32 Defeitos na Origem Não São Automaticamente Defeitos de Captura](#1332-defeitos-na-origem-não-são-automaticamente-defeitos-de-captura)
    - [13.33 A Estratégia de Captura Termina Antes da Transformação de Negócio](#1333-a-estratégia-de-captura-termina-antes-da-transformação-de-negócio)
    - [13.34 Limite por Mecanismo](#1334-limite-por-mecanismo)
    - [13.35 O Que Este Documento Pode Referenciar](#1335-o-que-este-documento-pode-referenciar)
    - [13.36 O Que Este Documento Não Deve Afirmar](#1336-o-que-este-documento-não-deve-afirmar)
    - [13.37 Transferência de Responsabilidade](#1337-transferência-de-responsabilidade)
    - [13.38 Limite Atual do Atlas Engineering](#1338-limite-atual-do-atlas-engineering)
    - [13.39 Resumo dos Limites da Estratégia](#1339-resumo-dos-limites-da-estratégia)

- [14. Resumo das Decisões](#14-resumo-das-decisões)
    - [14.1 Classificação de Origens Aprovada para a V1](#141-classificação-de-origens-aprovada-para-a-v1)
    - [14.2 Seleção de Mecanismos Aprovada para a V1](#142-seleção-de-mecanismos-aprovada-para-a-v1)
    - [14.3 Decisão sobre CDC](#143-decisão-sobre-cdc)
    - [14.4 Evidências de CDC Atualmente Disponíveis](#144-evidências-de-cdc-atualmente-disponíveis)
    - [14.5 Decisão sobre a Janela de Recuperação do CDC](#145-decisão-sobre-a-janela-de-recuperação-do-cdc)
    - [14.6 Decisão sobre Partition SWITCH com CDC](#146-decisão-sobre-partition-switch-com-cdc)
    - [14.7 Decisão sobre Timestamp Incremental](#147-decisão-sobre-timestamp-incremental)
    - [14.8 Requisito de Validação do Timestamp Incremental](#148-requisito-de-validação-do-timestamp-incremental)
    - [14.9 Decisão sobre a Fidelidade do Timestamp Incremental](#149-decisão-sobre-a-fidelidade-do-timestamp-incremental)
    - [14.10 Decisão sobre Snapshot + Diff](#1410-decisão-sobre-snapshot--diff)
    - [14.11 Semântica das Evidências do Snapshot + Diff](#1411-semântica-das-evidências-do-snapshot--diff)
    - [14.12 Decisão sobre a Segurança do Snapshot](#1412-decisão-sobre-a-segurança-do-snapshot)
    - [14.13 Decisão sobre Full Refresh Controlado](#1413-decisão-sobre-full-refresh-controlado)
    - [14.14 Decisão sobre a Segurança do Full Refresh](#1414-decisão-sobre-a-segurança-do-full-refresh)
    - [14.15 Decisão sobre o Initial Backfill](#1415-decisão-sobre-o-initial-backfill)
    - [14.16 Decisão sobre o Cutover](#1416-decisão-sobre-o-cutover)
    - [14.17 Decisão sobre Evidências Históricas](#1417-decisão-sobre-evidências-históricas)
    - [14.18 Decisão sobre Garantia de Entrega](#1418-decisão-sobre-garantia-de-entrega)
    - [14.19 Decisão sobre Proteção da Origem](#1419-decisão-sobre-proteção-da-origem)
    - [14.20 Modelo de Evidências da Captura](#1420-modelo-de-evidências-da-captura)
    - [14.21 Matriz V1 Aprovada](#1421-matriz-v1-aprovada)
    - [14.22 Estado Atual de Maturidade](#1422-estado-atual-de-maturidade)
    - [14.23 Gatilhos para Revisão da Estratégia](#1423-gatilhos-para-revisão-da-estratégia)
    - [14.24 Procedimento para Alteração de uma Decisão](#1424-procedimento-para-alteração-de-uma-decisão)
    - [14.25 A Estratégia É Versionada, Não Permanente](#1425-a-estratégia-é-versionada-não-permanente)
    - [14.26 Decisão Versus Documentação da Implementação](#1426-decisão-versus-documentação-da-implementação)
    - [14.27 Próximo Limite de Implementação](#1427-próximo-limite-de-implementação)
    - [14.28 Decisão Final da V1](#1428-decisão-final-da-v1)
    - [14.29 Princípios Finais](#1429-princípios-finais)

---

## 1. Objetivo

Este documento define a estratégia de captura V1 utilizada pela Plataforma de Engenharia de Dados do Atlas Engineering para identificar e obter alterações das tabelas de origem do AtlasCommerce.

A estratégia determina qual mecanismo de captura é apropriado para cada origem com base em seu comportamento de alteração, características operacionais, requisitos de dados e capacidade da origem de expor alterações de forma confiável.

Os mecanismos considerados na V1 são:

- SQL Server Change Data Capture (CDC);
- captura incremental baseada em *timestamp*;
- *Snapshot* + *Diff*;
- *Full Refresh* Controlado.

O objetivo não é aplicar um único padrão de ingestão a todas as tabelas de origem. Diferentes características das origens exigem mecanismos distintos.

Para cada origem ou categoria de origem, a estratégia avalia fatores como:

- frequência de alteração;
- volume de dados esperado;
- requisitos de latência;
- necessidade de detectar operações `INSERT`, `UPDATE` e `DELETE`;
- disponibilidade e confiabilidade de uma *watermark*;
- sobrecarga operacional;
- requisitos de recuperação;
- impacto sobre a carga de trabalho OLTP do AtlasCommerce.

A estratégia segue um princípio fundamental do Atlas Engineering:

> **A saúde do sistema OLTP possui prioridade sobre a conveniência analítica.**

O AtlasCommerce é o sistema operacional responsável por produzir as vendas. Portanto, os mecanismos de captura devem obter os dados necessários à Plataforma de Engenharia de Dados sem introduzir cargas de trabalho desnecessárias ou riscos operacionais à origem.

Este documento registra decisões arquiteturais e seus respectivos fundamentos. Ele não constitui evidência de que todos os mecanismos selecionados já tenham sido implementados ou validados.

Os procedimentos de implementação, as observações de laboratório, as evidências de testes, os detalhes de configuração e os resultados PASS/FAIL do SQL Server CDC são documentados separadamente em:

`AtlasEngineering-SQL-Server-CDC-Implementation.md`

A distinção mantida ao longo de todo o projeto é:

```text
DECISÃO ARQUITETURAL
        ↓
o que foi selecionado e por quê

IMPLEMENTAÇÃO
        ↓
o que foi realmente configurado

EVIDÊNCIA
        ↓
o que foi realmente testado e observado
```

Uma decisão documentada aqui não deve ser apresentada como evidência de implementação, a menos que tenha sido implementada e validada de forma independente.

---

## 2. Escopo

Este documento define a estratégia de captura dos dados de origem para a implementação V1 da Plataforma de Engenharia de Dados do Atlas Engineering.

Seu escopo começa no limite da origem operacional, onde os dados são criados ou modificados no AtlasCommerce, e termina com a identificação e obtenção confiáveis das alterações necessárias à Plataforma de Engenharia de Dados.

Conceitualmente:

```text
AtlasCommerce
     │
     │ alterações nos dados de origem
     ▼
ESTRATÉGIA DE CAPTURA
     │
     ├── CDC
     ├── Timestamp Incremental
     ├── Snapshot + Diff
     └── Full Refresh Controlado
     │
     ▼
Alterações ou estado atual obtidos
para ingestão downstream
```

A estratégia de captura responde às seguintes perguntas:

- quais tabelas de origem são necessárias para o domínio inicial de Engenharia de Dados;
- como essas tabelas se alteram;
- se é necessário identificar alterações individuais ou apenas o estado atual;
- se as operações `INSERT`, `UPDATE` e `DELETE` precisam ser detectáveis;
- se a origem fornece uma *watermark* confiável;
- quais características de latência são necessárias;
- qual mecanismo de captura é apropriado para cada origem;
- por que esse mecanismo foi selecionado;
- quais limitações e *trade-offs* são aceitos;
- como os dados existentes são tratados quando a captura é iniciada;
- como é controlada a transição entre a carga histórica e a captura contínua.

### 2.1 Domínio Inicial

O primeiro domínio de implementação é:

```text
AtlasCommerce.sales
```

As principais tabelas de origem transacionais são:

```text
sales.Transaction
sales.TransactionItem
```

O mapa inicial de dependências analíticas também inclui:

```text
sales.TransactionStatus
sales.TransactionChannel

catalog.ProductVariant
catalog.Product
catalog.Brand
catalog.ProductCategory
catalog.Category
```

Essas tabelas não necessariamente compartilham as mesmas características de alteração.

Por esse motivo, fazer parte do mesmo domínio analítico não implica que elas devam utilizar o mesmo mecanismo de captura.

O mecanismo de captura é selecionado de acordo com as características e os requisitos de cada origem.

### 2.2 Mecanismos de Captura no Escopo

Quatro mecanismos de captura de origem são definidos para a V1:

#### SQL Server Change Data Capture

Utilizado para origens nas quais alterações individuais precisam ser capturadas com maior fidelidade e em que a detecção de operações como `DELETE` físico é importante.

No domínio inicial:

```text
sales.Transaction
sales.TransactionItem
```

são atribuídas a essa estratégia.

O SQL Server CDC utiliza informações derivadas do *Transaction Log* do SQL Server para disponibilizar as alterações capturadas por meio das estruturas do CDC.

A implementação detalhada e o comportamento desse mecanismo observado experimentalmente são documentados separadamente.

#### Captura Incremental Baseada em Timestamp

Utilizada para origens com alterações ocasionais nas quais uma *watermark* confiável baseada em *timestamp* pode identificar as linhas que foram alteradas desde a extração anterior.

A hipótese de captura V1 atribui:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

a essa estratégia, sujeita à validação do comportamento necessário da *watermark* durante a implementação.

Esta distinção é importante:

> O mecanismo foi selecionado como hipótese de implementação V1, mas sua correção operacional ainda precisa ser validada.

#### Snapshot + Diff

Utilizado quando a origem sofre alterações com pouca frequência, mas não disponibiliza uma *watermark* confiável capaz de identificar as linhas alteradas.

No domínio inicial:

```text
catalog.ProductCategory
```

é atribuída a essa estratégia por ser uma origem de relacionamento com baixo volume de alterações e que não disponibiliza uma *watermark* confiável para captura incremental.

A estrutura de origem atualmente identificada contém:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

sem colunas de *timestamp*.

Como o estado completo dos relacionamentos pode ser obtido novamente e comparado com um estado anteriormente aceito, *Snapshot* + *Diff* fornece um mecanismo V1 adequado para identificar inclusões e remoções sem introduzir CDC exclusivamente para essa origem.

#### Full Refresh Controlado

Utilizado para pequenos conjuntos de dados de referência nos quais obter o estado atual completo é mais simples e operacionalmente aceitável do que manter o rastreamento incremental de alterações.

No domínio inicial:

```text
sales.TransactionStatus
sales.TransactionChannel
```

são atribuídas a essa estratégia.

O objetivo é manter uma representação *downstream* autoritativa de seu estado atual sem introduzir complexidade de captura desnecessária em pequenos conjuntos de dados de referência.

### 2.3 Backfill Inicial e Captura Contínua

O escopo também inclui a transição dos dados de origem preexistentes para a captura contínua.

O CDC não reconstrói alterações ocorridas antes de seu limite de captura.

Portanto, as linhas existentes e as alterações futuras representam duas necessidades distintas de ingestão:

```text
DADOS EXISTENTES
antes do limite de captura
        │
        ▼
Backfill Inicial
        │
        └── estado atual conhecido


ALTERAÇÕES FUTURAS
após o limite de captura
        │
        ▼
Captura Contínua
        │
        └── alterações observáveis
```

A estratégia V1 segue o princípio:

> **Proteja o futuro primeiro; depois carregue o passado.**

O limite de captura é estabelecido antes da carga dos dados históricos para que novas alterações ocorridas durante o processo de *backfill* não sejam silenciosamente perdidas.

Uma sobreposição controlada entre o *backfill* e a captura contínua é preferível a uma lacuna não controlada, pois a sobreposição pode ser reconciliada por meio da idempotência *downstream*, enquanto uma lacuna silenciosa pode resultar em perda irrecuperável de dados.

Este documento define essa estratégia arquitetural.

A implementação e a validação dos mecanismos definitivos de sobreposição, *checkpoint*, *replay* e deduplicação permanecem como questões separadas de implementação e não devem ser apresentadas como comprovadas até que sejam testadas.

### 2.4 Proteção Operacional da Origem

Todos os mecanismos de captura estão sujeitos ao papel operacional do AtlasCommerce.

O AtlasCommerce é o sistema responsável pelas operações transacionais do negócio. A Plataforma de Engenharia de Dados é uma consumidora *downstream* desses dados.

Portanto:

```text
disponibilidade e desempenho do OLTP
            >
conveniência da ingestão analítica
```

O projeto de captura deve evitar cargas de trabalho desnecessárias na origem, especialmente quando um mecanismo alternativo puder fornecer os dados necessários sem afetar materialmente o sistema operacional.

Esse princípio influencia decisões como:

- utilizar CDC baseado no *Transaction Log* para tabelas transacionais com alto volume de alterações;
- evitar varreduras repetidas desnecessariamente dispendiosas;
- utilizar mecanismos mais simples para origens pequenas ou com alterações pouco frequentes;
- controlar *backfills* históricos;
- separar o processamento analítico do banco de dados operacional.

### 2.5 Fora do Escopo

Este documento não define a arquitetura completa de ingestão ou processamento *downstream*.

As seguintes questões estão fora da responsabilidade da Estratégia de Captura:

- implementação e configuração do Debezium;
- projeto de tópicos Kafka;
- particionamento do Kafka;
- grupos de consumidores Kafka;
- gerenciamento de *offsets* do Kafka;
- serialização de eventos;
- implementação do Schema Registry;
- persistência Bronze;
- organização dos arquivos Parquet;
- limites dos microlotes Bronze;
- transformações Silver;
- implementação da deduplicação *downstream*;
- implementação da idempotência de ponta a ponta;
- modelagem dimensional Gold;
- publicação da Certified Gold;
- consumo pelo Power BI;
- orquestração com Airflow;
- implementação da observabilidade de ponta a ponta.

Esses componentes podem depender da saída da camada de captura, mas resolvem problemas arquiteturais diferentes.

O limite pode ser representado como:

```text
ORIGEM
  │
  ▼
┌──────────────────────────────┐
│    ESTRATÉGIA DE CAPTURA     │
│                              │
│ Como identificar e obter     │
│ de forma confiável as        │
│ alterações na origem ou o    │
│ estado atual necessário?     │
└──────────────────────────────┘
  │
  │ alteração/estado obtido
  ▼
────────────────────────────────  ← limite do escopo
  │
  ▼
INGESTÃO / STREAMING
  │
  ▼
BRONZE
  │
  ▼
SILVER
  │
  ▼
GOLD
```

A Estratégia de Captura determina como a plataforma obtém as informações necessárias da origem.

Ela não determina como cada componente *downstream* posteriormente transporta, persiste, transforma, reconcilia ou publica essas informações.

### 2.6 Limite da Evidência

Este documento registra a estratégia arquitetural.

Quando já houver evidência de implementação, ela poderá ser referenciada para demonstrar que uma estratégia selecionada começou a ser validada. Entretanto, os resultados detalhados de laboratório pertencem à documentação de implementação correspondente.

A seguinte distinção deve ser sempre preservada:

```text
SELECIONADO
≠
IMPLEMENTADO
≠
TESTADO
≠
COMPROVADO DE PONTA A PONTA
```

Por exemplo:

```text
sales.Transaction
→ CDC selecionado
→ CDC implementado no SQL Server
→ comportamento do SQL Server CDC testado até M01.19
→ consumo downstream do CDC ainda não validado
→ comportamento do Debezium ainda não validado
→ entrega pelo Kafka ainda não validada
→ comportamento de ponta a ponta ainda não comprovado
```

Isso impede que a intenção arquitetural seja apresentada incorretamente como evidência de implementação.

---

## 3. Princípios da Estratégia de Captura

A Estratégia de Captura do Atlas Engineering é baseada em um conjunto de princípios que orientam como os dados de origem são obtidos pela Plataforma de Engenharia de Dados.

Esses princípios existem para evitar que mecanismos de captura sejam selecionados apenas porque uma tecnologia está disponível, é familiar ou é amplamente utilizada.

A decisão deve começar pelas características da origem e pelos requisitos do produto de dados.

Conceitualmente:

```text
COMPORTAMENTO DA ORIGEM
      +
REQUISITOS DE DADOS
      +
RESTRIÇÕES OPERACIONAIS
      ↓
REQUISITOS DE CAPTURA
      ↓
SELEÇÃO DO MECANISMO
```

A tecnologia é selecionada depois que o problema de captura é compreendido.

### 3.1 As Características da Origem Determinam o Mecanismo de Captura

Diferentes tabelas de origem podem representar diferentes tipos de informação e apresentar padrões de alteração muito distintos.

Por exemplo:

```text
tabela transacional de alto volume
            ≠
dados mestres com alterações ocasionais
            ≠
pequena tabela de referência
            ≠
tabela de relacionamento sem watermark
```

Utilizar o mesmo mecanismo de captura para todas elas simplificaria superficialmente a arquitetura, mas poderia introduzir complexidade desnecessária, sobrecarga operacional ou lacunas na detecção de alterações.

Portanto:

> **O mecanismo de captura deve seguir o comportamento e os requisitos da origem, e não o contrário.**

A classificação inicial do Atlas Engineering reflete esse princípio:

```text
Alto Volume de Alterações
→ CDC

Alterações Ocasionais
→ Timestamp Incremental

Baixo Volume de Alterações / Sem Watermark Confiável
→ Snapshot + Diff

Dados de Referência
→ Full Refresh Controlado
```

Essa classificação é um ponto de partida para a seleção do mecanismo, e não uma regra universal.

Uma tabela classificada como de baixo volume de alterações, por exemplo, não deve utilizar automaticamente *Snapshot* + *Diff* se outro requisito tornar esse mecanismo inadequado.

A decisão completa deve considerar vários fatores em conjunto.

### 3.2 Capture Alterações Apenas Quando o Histórico de Alterações For Necessário

Nem todo conjunto de dados *downstream* precisa conhecer cada operação individual ocorrida na origem.

Existem duas perguntas fundamentalmente diferentes que uma estratégia de captura pode precisar responder:

```text
ORIENTADO A ALTERAÇÕES
O que aconteceu?

ORIENTADO A ESTADO
Qual é o estado atual?
```

Um mecanismo orientado a alterações pode precisar distinguir:

```text
INSERT
UPDATE
DELETE
```

e, potencialmente, preservar informações sobre a sequência em que essas alterações ocorreram.

Um mecanismo orientado a estado pode precisar apenas determinar:

```text
Quais linhas existem agora?
Quais valores elas contêm agora?
```

Essa distinção afeta diretamente a complexidade da captura.

Para origens transacionais com alto volume de alterações, como:

```text
sales.Transaction
sales.TransactionItem
```

a estratégia V1 exige captura orientada a alterações por meio de CDC.

Para pequenas origens de referência, como:

```text
sales.TransactionStatus
sales.TransactionChannel
```

o estado atual é suficiente para a estratégia de captura V1 selecionada, permitindo que o *Full Refresh* Controlado permaneça simples e explícito.

Portanto:

> **Não assuma o custo operacional e arquitetural do rastreamento de alterações quando o requisito precisa apenas do estado atual.**

Por outro lado:

> **Não utilize um mecanismo baseado apenas em estado quando alterações individuais precisarem ser detectadas de forma confiável.**

### 3.3 A Detecção de DELETE Deve Ser um Requisito Explícito

`DELETE` exige tratamento explícito porque nem todo mecanismo incremental consegue detectá-lo.

Considere uma extração baseada em *timestamp*:

```text
SELECT ...
FROM SourceTable
WHERE updated_at > @last_watermark;
```

Essa abordagem pode identificar linhas que ainda existem e expõem um *timestamp* que atende ao critério.

Após um `DELETE` físico, entretanto:

```text
linha existe
    ↓
DELETE
    ↓
linha deixa de existir
```

Pode não haver mais uma linha na origem para que uma consulta posterior baseada em *timestamp* consiga recuperá-la.

Portanto:

```text
detecção confiável de INSERT
+
detecção confiável de UPDATE
```

não implica automaticamente:

```text
detecção confiável de DELETE
```

A decisão de captura deve perguntar explicitamente:

> **Se uma linha desaparecer da origem, a plataforma *downstream* precisa saber que ela foi excluída?**

Para `sales.Transaction` e `sales.TransactionItem`, a detecção de DELETE é um dos motivos pelos quais o CDC é apropriado.

O laboratório do Atlas Engineering já demonstrou que o SQL Server CDC consegue expor operações de `DELETE` físico para essas origens habilitadas para CDC, incluindo DELETEs produzidos como efeito de ações referenciais, como `ON DELETE CASCADE`.

A evidência detalhada pertence ao documento de implementação do CDC.

### 3.4 Uma Watermark Deve Ser Confiável, Não Apenas Existir

A existência de uma coluna de *timestamp* não torna automaticamente uma tabela adequada para captura incremental baseada em *timestamp*.

Uma *watermark* só é útil se seu comportamento representar de forma confiável as alterações que o processo de captura precisa descobrir.

Conceitualmente:

```text
checkpoint anterior
        ↓
last_watermark = T1
        ↓
alterações na origem
        ↓
próxima extração
        ↓
linhas com watermark > T1
```

Para que esse modelo funcione corretamente, a *watermark* selecionada deve satisfazer as premissas exigidas pela estratégia de extração.

As perguntas que precisam ser validadas incluem:

- a *watermark* é atualizada sempre que uma linha relevante é alterada?
- uma alteração relevante pode ocorrer sem modificar a *watermark*?
- várias linhas podem compartilhar o mesmo valor de *watermark*?
- qual precisão a *watermark* oferece?
- transações tardias ou o comportamento da aplicação podem produzir valores que desafiem um filtro simples com `>`?
- o valor pode retroceder?
- como as condições de limite entre janelas de extração são tratadas?
- como os DELETEs físicos são detectados, caso precisem ser detectados?

Portanto:

> **Uma coluna de *timestamp* é uma candidata a *watermark*, não uma prova de uma estratégia incremental confiável.**

Isso é particularmente importante para as tabelas V1 atualmente classificadas para captura incremental baseada em *timestamp*:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

Essa classificação permanece como hipótese de implementação até que o comportamento de suas *watermarks* seja validado.

### 3.5 Prefira o Mecanismo Mais Simples que Atenda ao Requisito

Uma tecnologia de captura mais sofisticada não representa automaticamente uma engenharia melhor.

Um mecanismo introduz custos como:

- complexidade de implementação;
- dependências operacionais;
- requisitos de monitoramento;
- procedimentos de recuperação;
- requisitos de armazenamento;
- complexidade de *troubleshooting*;
- sobrecarga na origem;
- modos adicionais de falha.

Se dois mecanismos atenderem aos mesmos requisitos com confiabilidade comparável, normalmente deve ser preferido o mecanismo mais simples.

Por exemplo:

```text
tabela de referência com 5 linhas
        ↓
A plataforma precisa de cada transição histórica?
        │
        └── NÃO
             ↓
Full Refresh Controlado
```

Introduzir CDC para uma origem desse tipo poderia funcionar tecnicamente, mas a viabilidade técnica, por si só, não justifica a complexidade operacional adicional.

Portanto, o objetivo não é:

```text
maximizar o uso de tecnologias
```

mas:

```text
atender aos requisitos
        +
preservar a confiabilidade
        +
controlar a complexidade operacional
```

### 3.6 Proteja a Origem OLTP

O AtlasCommerce existe para executar transações de negócio.

A Plataforma de Engenharia de Dados está *downstream* dessa responsabilidade.

A relação de prioridade é:

```text
carga de trabalho de negócio do AtlasCommerce
              >
conveniência da Engenharia de Dados
```

Os processos de captura devem, portanto, ser projetados para minimizar competição desnecessária com a carga de trabalho transacional.

Isso afeta:

- seleção do mecanismo de captura;
- frequência de extração;
- padrões de consulta;
- estratégia de *backfill* histórico;
- agendamento;
- varreduras na origem;
- operações de recuperação;
- futuras decisões de escalabilidade.

Um mecanismo conveniente para análise, mas que gere pressão inaceitável sobre a origem, não é uma estratégia de captura aceitável.

Para tabelas transacionais com alto volume de alterações, o CDC baseado no *Transaction Log* fornece um mecanismo para identificar alterações sem estruturar o processo de ingestão analítica em torno de extrações repetidas da tabela inteira.

Para *backfills* históricos, grandes volumes de leitura também devem ser controlados para que a reconstrução do histórico analítico não concorra desnecessariamente com transações em andamento.

Quando apropriado, cópias restauradas e isoladas podem ser consideradas para extrações históricas pesadas, em vez de exercer pressão evitável sobre a origem OLTP em produção.

### 3.7 Proteja Alterações Futuras Antes de Carregar Dados Históricos

Quando a captura começa em uma origem que já contém dados, existem dois problemas simultaneamente:

```text
PASSADO
linhas existentes

FUTURO
novas alterações ocorrendo a partir de agora
```

Carregar primeiro o estado histórico sem proteger alterações futuras cria uma possível lacuna:

```text
início da carga histórica
        ↓
novas alterações ocorrem na origem
        ↓
carga histórica continua
        ↓
captura habilitada posteriormente
        ↓
alterações entre os limites podem ser perdidas
```

O Atlas Engineering adota, portanto, o princípio:

> **Proteja o futuro primeiro; depois carregue o passado.**

Conceitualmente:

```text
1. estabelecer o limite de captura
        ↓
2. proteger alterações futuras
        ↓
3. carregar o estado existente da origem
        ↓
4. processar as alterações acumuladas
        ↓
5. reconciliar a sobreposição controlada
        ↓
6. entrar em operação normal
```

Isso não significa que a implementação completa desse processo já tenha sido comprovada.

Essa é a estratégia que deverá ser validada posteriormente por meio de implementação e testes.

### 3.8 Prefira Sobreposição Controlada a Lacunas Silenciosas

Durante transições como o *backfill* inicial e a captura contínua, estabelecer limites perfeitamente não sobrepostos pode ser difícil ou desnecessariamente arriscado.

Duas possibilidades de falha devem ser diferenciadas:

```text
SOBREPOSIÇÃO
os mesmos dados lógicos podem ser observados mais de uma vez

LACUNA
alguns dados lógicos podem nunca ser observados
```

Com um projeto *downstream* idempotente, a sobreposição pode ser identificada e reconciliada.

Uma lacuna silenciosa pode representar perda permanente de dados se o estado ou evento ausente da origem não puder mais ser recuperado.

Portanto:

> **Prefira duplicação controlada e detectável a perda silenciosa e irrecuperável.**

Esse princípio é consistente com a decisão mais ampla de entrega do Atlas Engineering:

```text
At-Least-Once
+
Idempotência
```

A estratégia de captura estabelece a preferência pela sobreposição controlada.

A implementação da idempotência *downstream* e da proteção contra duplicidades de ponta a ponta está fora do escopo deste documento e deve ser validada de forma independente.

### 3.9 A Retenção da Captura É um Requisito de Recuperação

Um mecanismo de captura que retém alterações por um período limitado cria uma janela operacional de recuperação.

No SQL Server CDC, as alterações capturadas não foram projetadas para servir como armazenamento histórico permanente.

A decisão V1 é:

```text
retenção do CDC
=
15 dias
=
21600 minutos
```

Essa janela foi selecionada para fornecer tempo de recuperação operacional em situações como:

- fins de semana;
- feriados;
- ausências prolongadas;
- incidentes;
- atraso na detecção;
- diagnóstico;
- reparo;
- reprocessamento.

O raciocínio utilizado para a decisão inicial da V1 é:

```text
~10 dias de possível ausência
+
~2 dias para detecção / análise
+
~3 dias para reparo / reprocessamento
=
~15 dias de janela de recuperação
```

O objetivo dessa retenção não é atender aos requisitos de histórico permanente da plataforma.

A direção arquitetural de longo prazo é:

```text
SQL Server CDC
→ janela operacional limitada de captura / recuperação

Kafka
→ transporte downstream de eventos com
recursos de retenção e replay
a serem definidos e validados

Bronze
→ camada pretendida para ingestão
histórica durável
```

Essas responsabilidades *downstream* permanecem sujeitas às suas próprias implementações, políticas de retenção, projetos de recuperação e validações.

### 3.10 Latência dos Dados e Janela de Recuperação São Requisitos Diferentes

A latência de captura e a retenção respondem a perguntas operacionais diferentes.

A latência dos dados responde:

> **Com que rapidez uma alteração confirmada na origem deve ficar disponível para o produto de dados *downstream*?**

A janela de recuperação responde:

> **Por quanto tempo as alterações capturadas podem permanecer disponíveis enquanto o processamento *downstream* está indisponível ou em recuperação?**

Elas não devem ser tratadas como o mesmo requisito.

O Atlas Engineering define atualmente:

```text
Meta típica de latência dos dados
≈ 3–5 minutos

SLO formal V1 de latência de ponta a ponta
P95 ≤ 15 minutos

Janela de recuperação do CDC
15 dias
```

Portanto:

```text
minutos
→ latência dos dados

dias
→ oportunidade de recuperação
```

Aumentar a retenção do CDC não reduz a latência do *pipeline*.

Reduzir a latência do *polling* de captura não fornece uma janela de recuperação maior.

Essas dimensões devem ser projetadas, medidas e operadas de forma independente.

### 3.11 Operações Físicas na Origem Devem Preservar a Semântica dos Dados

Operações físicas no banco de dados nem sempre representam eventos lógicos de negócio.

Essa distinção é especialmente importante para tabelas particionadas habilitadas para CDC.

As tabelas transacionais atuais:

```text
sales.Transaction
sales.TransactionItem
```

são particionadas.

O SQL Server CDC foi habilitado permitindo *partition switching*.

Existe uma restrição conhecida: operações `SWITCH` de partição não são representadas pelo CDC como alterações comuns em nível de linha.

A estratégia do Atlas Engineering, portanto, diferencia o gerenciamento físico dos dados da semântica de negócio.

Por exemplo:

```text
partição histórica
        ↓
SWITCH OUT
        ↓
realocação física / arquivamento
```

não deve ser interpretado automaticamente como:

```text
transação de negócio excluída
```

porque a venda pode continuar sendo um dado histórico de negócio válido que precisa permanecer disponível para a plataforma analítica.

A decisão V1 é, portanto, governar o *partition switching* em vez de desabilitá-lo preventivamente.

A ingestão normal de vendas não deve utilizar `SWITCH IN` como substituto da criação transacional normal de dados.

Operações futuras de `SWITCH OUT`, caso sejam introduzidas para arquivamento físico, devem ser controladas para que a movimentação física no banco OLTP não altere incorretamente o histórico analítico do negócio.

### 3.12 Não Invente Eventos Históricos

Sistemas de captura começam a observar uma origem em um ponto específico no tempo.

Dados que já existiam antes desse limite podem revelar o estado atual, mas não necessariamente a sequência de eventos históricos que produziu esse estado.

Por exemplo, se uma transação já existir com:

```text
status = COMPLETED
```

quando o CDC for iniciado, a plataforma poderá saber que a transação está atualmente concluída.

Ela não pode concluir automaticamente que a sequência histórica foi:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

a menos que essas transições tenham sido efetivamente capturadas ou outra fonte autoritativa as forneça.

Portanto:

> **O estado atual conhecido não deve ser transformado em eventos históricos inventados.**

O *backfill* inicial preserva aquilo que pode ser estabelecido a partir da origem no momento da extração.

A captura contínua registra alterações observáveis após o limite de captura.

Essa distinção protege a integridade histórica da plataforma analítica.

### 3.13 Captura Não É Armazenamento Histórico Permanente

Captura e persistência histórica resolvem problemas relacionados, porém diferentes.

Um mecanismo de captura da origem responde:

```text
Como a plataforma pode identificar
os dados ou alterações de que precisa?
```

Uma camada de armazenamento histórico responde:

```text
Como a plataforma pode reter
o que foi obtido para auditoria,
replay e reprocessamento duráveis?
```

Para o Atlas Engineering:

```text
CAPTURA DA ORIGEM
      ↓
mecanismos temporários / operacionais de aquisição
      ↓
INGESTÃO DOWNSTREAM
      ↓
BRONZE
      ↓
ingestão histórica durável
```

A retenção do CDC, portanto, não deve ser aumentada indefinidamente na tentativa de transformar o SQL Server CDC no arquivo histórico da plataforma.

A responsabilidade pelo histórico durável migra progressivamente da origem operacional para a Plataforma de Engenharia de Dados.

### 3.14 A Evidência Prevalece sobre a Hipótese Inicial

A estratégia de captura começa com premissas derivadas da estrutura da origem, dos requisitos conhecidos e da análise arquitetural.

A implementação pode revelar comportamentos que contradigam essas premissas.

Quando isso ocorrer:

```text
HIPÓTESE INICIAL
        ↓
IMPLEMENTAÇÃO
        ↓
TESTE
        ↓
EVIDÊNCIA OBSERVADA
        ↓
hipótese confirmada?
        │
        ├── SIM → manter decisão
        │
        └── NÃO → investigar e revisar
```

O princípio que governa essa decisão é:

> **A evidência observada prevalece sobre uma hipótese de implementação ainda não validada.**

Isso não significa que um único resultado inesperado de laboratório deva se tornar automaticamente uma regra de produção.

Comportamentos inesperados devem ser investigados considerando:

- versão do SQL Server;
- configuração;
- projeto da origem;
- condições de teste;
- reprodutibilidade;
- documentação oficial do produto, quando aplicável.

O objetivo é permitir que a arquitetura evolua a partir de evidências sem confundir observações de laboratório com garantias universais.

### 3.15 As Decisões de Captura Devem Permanecer Explícitas e Revisáveis

Toda origem incluída na plataforma deve, eventualmente, possuir uma decisão explícita de captura.

A decisão deve permitir responder:

```text
Qual origem estamos capturando?

Como ela se altera?

Quais alterações precisamos detectar?

DELETE é relevante?

Existe uma watermark confiável?

Qual latência é necessária?

Qual mecanismo foi selecionado?

Por que ele foi selecionado?

Quais são suas limitações?

Como a recuperação é tratada?

O que ainda precisa ser validado?
```

Essas informações devem permanecer versionadas e passíveis de revisão.

Um mecanismo de captura nunca deve se tornar uma premissa não documentada escondida no código de implementação.

A estratégia atua, portanto, como um contrato entre:

```text
ENTENDIMENTO DA ORIGEM
        ↓
DECISÃO ARQUITETURAL
        ↓
IMPLEMENTAÇÃO
        ↓
VALIDAÇÃO
```

À medida que o comportamento da origem, os requisitos de negócio ou as evidências de implementação se alterarem, a estratégia deve ser revisada em vez de divergir silenciosamente do sistema que realmente existe.

---

## 4. Classificação das Alterações na Origem

Uma estratégia de captura deve começar pela compreensão de como cada origem se comporta.

Tabelas pertencentes ao mesmo domínio analítico podem apresentar padrões de alteração, volumes, papéis operacionais e requisitos de detecção de alterações históricas significativamente diferentes.

Por esse motivo, o Atlas Engineering classifica as tabelas de origem antes de selecionar ou implementar seus mecanismos de captura.

O modelo de classificação V1 é:

```text
A — Alto Volume de Alterações
B — Alterações Ocasionais
C — Referência
D — Baixo Volume de Alterações / Sem Watermark
```

A classificação fornece um ponto de partida estruturado para as decisões de captura.

Ela não significa:

```text
classificação
      =
seleção automática de tecnologia
```

Em vez disso:

```text
comportamento da origem
      ↓
classificação
      ↓
requisitos de captura
      ↓
avaliação do mecanismo
      ↓
decisão de captura
      ↓
implementação
      ↓
validação
```

A classificação ajuda a organizar o problema.

O mecanismo de captura definitivo ainda precisa atender aos requisitos da origem.

### 4.1 Por Que a Classificação da Origem É Importante

Sem a classificação das origens, uma plataforma pode facilmente cair em um de dois padrões indesejáveis.

O primeiro é a uniformidade tecnológica:

```text
CDC está disponível
      ↓
usar CDC em tudo
```

O segundo é a uniformidade de extração:

```text
consultas incrementais são simples
      ↓
usar extração baseada em timestamp em tudo
```

Ambas as abordagens priorizam a consistência da implementação em vez dos requisitos da origem.

Uma abordagem melhor pergunta:

```text
Com que frequência esta origem se altera?

Quanto volume de dados pode ser alterado?

As alterações individuais são importantes?

DELETE precisa ser detectado?

A origem disponibiliza uma watermark confiável?

O estado atual é suficiente?

Qual latência é necessária?

Qual carga de trabalho na origem é aceitável?
```

Somente depois que essas questões forem compreendidas o mecanismo de captura deve ser selecionado.

A classificação, portanto, reduz o acoplamento acidental entre:

```text
o que a origem exige
```

e:

```text
qual tecnologia está disponível
```

### 4.2 Classificação Não É o Mecanismo de Captura

A distinção entre classificação e mecanismo de captura deve permanecer explícita.

Por exemplo:

```text
CLASSIFICAÇÃO
Alto Volume de Alterações

POSSÍVEL REQUISITO
Alterações individuais precisam ser observáveis

MECANISMO V1 SELECIONADO
CDC
```

A classificação descreve uma característica da origem.

O mecanismo descreve como a plataforma pretende obter as informações necessárias.

Esses conceitos não devem ser reduzidos a uma regra universal como:

```text
Alto Volume de Alterações = CDC
```

porque outra origem classificada como de alto volume de alterações pode possuir requisitos, recursos de banco de dados, restrições operacionais ou latência aceitável diferentes.

A interpretação correta é:

```text
Alto Volume de Alterações
      +
visibilidade em nível de alteração necessária
      +
detecção de DELETE necessária
      +
recursos disponíveis na origem SQL Server
      +
requisitos de proteção do OLTP
      ↓
CDC é apropriado
para as origens V1 atuais
```

Essa distinção permite que a estratégia de captura continue válida à medida que a plataforma se expanda para novos domínios e, potencialmente, novas tecnologias de origem.

### 4.3 Categoria A — Alto Volume de Alterações

A Categoria A representa tabelas de origem que devem participar intensamente do fluxo operacional de transações.

As tabelas V1 classificadas como de Alto Volume de Alterações são:

```text
sales.Transaction
sales.TransactionItem
```

Essas tabelas formam o núcleo transacional do domínio inicial de Sales Analytics.

A relação entre elas é:

```text
sales.Transaction
        │
        └── sales.TransactionItem
```

O grão analítico definido para o produto inicial é:

> **Uma linha por `sales.TransactionItem` associada a uma `sales.Transaction`.**

Como essas tabelas representam a atividade operacional de vendas, suas alterações são materialmente diferentes da manutenção ocasional do catálogo ou de pequenos conjuntos de dados de referência.

O problema de captura não é apenas:

```text
Qual é o estado atual da tabela?
```

Ele também exige a capacidade de identificar alterações ocorridas após o limite de captura.

O mecanismo V1 selecionado para ambas as tabelas é:

```text
SQL Server Native CDC
```

A seleção atende à necessidade de observar alterações na origem sem estruturar o processo de captura em torno de varreduras analíticas repetidas nas tabelas transacionais.

Ela também fornece um mecanismo capaz de expor operações de DELETE físico.

Essa capacidade é particularmente relevante porque:

```text
sales.TransactionItem
```

possui uma chave estrangeira para:

```text
sales.Transaction
```

configurada com:

```text
ON DELETE CASCADE
```

O laboratório de implementação já demonstrou que um DELETE executado contra uma `sales.Transaction` pai pode produzir alterações DELETE capturadas tanto para a linha pai quanto para as linhas afetadas de `sales.TransactionItem`.

Essa observação valida uma parte importante da estratégia de CDC selecionada, mas a evidência detalhada de implementação permanece fora deste documento.

Classificação:

```text
sales.Transaction
Categoria: A — Alto Volume de Alterações
Mecanismo de Captura V1: CDC

sales.TransactionItem
Categoria: A — Alto Volume de Alterações
Mecanismo de Captura V1: CDC
```

### 4.4 Categoria B — Alterações Ocasionais

A Categoria B representa origens que participam do modelo analítico, mas que atualmente não devem apresentar a mesma intensidade de alterações das tabelas transacionais de vendas.

As tabelas V1 classificadas como de Alterações Ocasionais são:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

Essas origens fornecem informações descritivas e estruturais necessárias para interpretar os dados transacionais de vendas.

Conceitualmente:

```text
sales.TransactionItem
        │
        ▼
catalog.ProductVariant
        │
        ▼
catalog.Product
        │
        ├── catalog.Brand
        │
        └── catalog.ProductCategory
                    │
                    ▼
             catalog.Category
```

Para as tabelas da Categoria B, a hipótese de captura V1 é:

```text
Timestamp Incremental
```

O raciocínio é que alterações ocasionais podem não justificar a complexidade operacional do CDC se uma *watermark* confiável na origem puder identificar as linhas que precisam ser extraídas.

O modelo pretendido é, conceitualmente:

```text
watermark anterior
        ↓
consultar origem
        ↓
identificar linhas alteradas
após o limite anterior
        ↓
obter linhas alteradas
        ↓
avançar checkpoint
```

Entretanto, esse mecanismo depende de uma premissa crítica:

> **A *watermark* selecionada deve expor de forma confiável todas as alterações relevantes que a estratégia espera detectar.**

Portanto, a presença de uma coluna como:

```text
created_at
updated_at
modified_at
```

não seria, por si só, evidência suficiente de que a captura incremental baseada em *timestamp* é segura.

A implementação deve validar o comportamento real da *watermark* antes que essa estratégia possa ser considerada operacionalmente comprovada.

Entre as perguntas que permanecem relevantes estão:

```text
O timestamp é atualizado em todo UPDATE relevante?

A lógica da aplicação pode modificar os dados sem atualizar esse *timestamp*?

Qual precisão de timestamp está disponível?

Várias alterações podem compartilhar o mesmo timestamp?

Como os limites de extração tratarão valores iguais?

DELETE pode ser detectado?

Se DELETE não puder ser detectado diretamente,
o requisito analítico exige sua detecção?

As linhas podem chegar ou ser confirmadas de formas que desafiem
um simples predicado timestamp > checkpoint?
```

Consequentemente, o estado atual dessa classificação é:

```text
catalog.Product
Categoria: B — Alterações Ocasionais
Hipótese de Captura V1: Timestamp Incremental
Validação: Pendente

catalog.ProductVariant
Categoria: B — Alterações Ocasionais
Hipótese de Captura V1: Timestamp Incremental
Validação: Pendente

catalog.Brand
Categoria: B — Alterações Ocasionais
Hipótese de Captura V1: Timestamp Incremental
Validação: Pendente

catalog.Category
Categoria: B — Alterações Ocasionais
Hipótese de Captura V1: Timestamp Incremental
Validação: Pendente
```

A palavra `Pendente` é importante.

Ela não significa que a decisão arquitetural não possua fundamento.

Significa que as premissas de implementação exigidas pelo mecanismo ainda não foram validadas experimentalmente.

### 4.5 Categoria C — Referência

A Categoria C representa pequenos conjuntos de dados de referência cujo principal requisito *downstream* é o estado atual autoritativo, e não um fluxo detalhado de cada transição ocorrida na origem.

As tabelas V1 classificadas como Referência são:

```text
sales.TransactionStatus
sales.TransactionChannel
```

Os valores atualmente conhecidos incluem:

```text
sales.TransactionStatus

1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

e:

```text
sales.TransactionChannel

1 ONLINE
2 STORE
```

Esses conjuntos de dados são fundamentalmente diferentes das tabelas transacionais.

Para o requisito V1 atual, a principal pergunta de captura é:

```text
Qual é o conjunto atual e autoritativo
de valores de referência?
```

em vez de:

```text
Qual foi cada operação individual
que produziu o estado atual da referência?
```

O mecanismo V1 selecionado é, portanto:

```text
Full Refresh Controlado
```

Conceitualmente:

```text
pequena origem de referência
        ↓
ler o estado autoritativo completo
        ↓
validar
        ↓
substituir / reconciliar representação downstream
```

A vantagem é a simplicidade.

Em vez de introduzir uma infraestrutura de captura em nível de alteração para uma origem muito pequena, a plataforma pode obter deliberadamente o estado completo da referência.

Classificação:

```text
sales.TransactionStatus
Categoria: C — Referência
Mecanismo de Captura V1: Full Refresh Controlado

sales.TransactionChannel
Categoria: C — Referência
Mecanismo de Captura V1: Full Refresh Controlado
```

Essa decisão deve ser revisitada caso o significado de negócio dessas tabelas se altere.

Por exemplo, se requisitos futuros exigirem a preservação de cada modificação histórica da referência como um evento de negócio, um *Full Refresh* Controlado orientado a estado poderá deixar de ser suficiente.

O mecanismo é, portanto, apropriado para o requisito atual e não uma garantia permanente para todos os casos de uso futuros.

### 4.6 Categoria D — Baixo Volume de Alterações / Sem Watermark

A Categoria D representa origens que se alteram com pouca frequência, mas não expõem os metadados necessários para uma estratégia incremental baseada em uma *watermark* confiável.

A tabela V1 classificada nesta categoria é:

```text
catalog.ProductCategory
```

Sua estrutura atualmente identificada contém:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

sem colunas de *timestamp*.

Essa tabela representa a relação entre:

```text
Product
   ↕
Category
```

A ausência de uma *watermark* confiável cria um problema específico.

Suponha que a plataforma armazene a relação atual:

```text
Product 100
→ Category 10
```

e, posteriormente, a origem passe a apresentar:

```text
Product 100
→ Category 20
```

Sem CDC ou uma *watermark* de alteração confiável, uma consulta como:

```text
WHERE updated_at > @last_watermark
```

não pode ser utilizada quando não existe uma *watermark* adequada.

Como essa é uma origem de relacionamento com baixo volume de alterações cujo estado completo pode ser obtido novamente e comparado com segurança, a estratégia V1 seleciona:

```text
Snapshot + Diff
```

Conceitualmente:

```text
SNAPSHOT ANTERIOR CONHECIDO
        │
        │ comparar
        ▼
SNAPSHOT ATUAL DA ORIGEM
        │
        ▼
DIFF
        │
        ├── relacionamento adicionado
        ├── relacionamento removido
        └── relacionamento inalterado
```

Para uma tabela de relacionamento, o desaparecimento é particularmente importante.

Considere:

```text
Snapshot Anterior
Product 100 → Category 10

Snapshot Atual
Product 100 → Category 20
```

Uma comparação pode derivar:

```text
REMOVIDO
Product 100 → Category 10

ADICIONADO
Product 100 → Category 20
```

A origem não precisa expor um evento DELETE explícito para que o processo de comparação detecte que uma relação anteriormente conhecida deixou de existir.

Isso ilustra uma distinção importante:

```text
CDC
→ observa alterações expostas pelo mecanismo de captura

Timestamp Incremental
→ recupera linhas existentes que atendem aos critérios

Snapshot + Diff
→ deriva alterações por meio da comparação entre estados
```

Classificação:

```text
catalog.ProductCategory
Categoria: D — Baixo Volume de Alterações / Sem Watermark
Mecanismo de Captura V1: Snapshot + Diff
```

A baixa frequência esperada de alterações torna essa estratégia mais razoável do que seria para uma tabela transacional muito grande e com alterações rápidas.

### 4.7 Matriz Atual de Classificação V1

A classificação inicial pode ser resumida da seguinte forma:

| Tabela de Origem | Classificação | Estratégia de Captura V1 | Estado Atual da Validação |
|---|---|---|---|
| `sales.Transaction` | A — Alto Volume de Alterações | CDC | Comportamento do CDC na origem validado até M01.19 |
| `sales.TransactionItem` | A — Alto Volume de Alterações | CDC | Comportamento do CDC na origem validado até M01.19 |
| `catalog.Product` | B — Alterações Ocasionais | *Timestamp* Incremental | Validação da implementação pendente |
| `catalog.ProductVariant` | B — Alterações Ocasionais | *Timestamp* Incremental | Validação da implementação pendente |
| `catalog.Brand` | B — Alterações Ocasionais | *Timestamp* Incremental | Validação da implementação pendente |
| `catalog.Category` | B — Alterações Ocasionais | *Timestamp* Incremental | Validação da implementação pendente |
| `sales.TransactionStatus` | C — Referência | *Full Refresh* Controlado | Validação da implementação pendente |
| `sales.TransactionChannel` | C — Referência | *Full Refresh* Controlado | Validação da implementação pendente |
| `catalog.ProductCategory` | D — Baixo Volume de Alterações / Sem *Watermark* | *Snapshot* + *Diff* | Validação da implementação pendente |

O estado da validação não deve ser interpretado como uma afirmação de que o CDC já foi comprovado de ponta a ponta.

Para:

```text
sales.Transaction
sales.TransactionItem
```

as evidências atuais estabelecem o comportamento do SQL Server CDC no lado da origem por meio dos testes de laboratório concluídos até M01.19.

Elas ainda não estabelecem:

```text
implementação do consumidor CDC
comportamento do Debezium
representação de transações no Kafka
ordenação no Kafka
persistência Bronze
idempotência de ponta a ponta
recuperação de ponta a ponta
desempenho em escala de produção
```

Essas questões permanecem sujeitas a implementação e testes posteriores.

### 4.8 A Classificação Pode Mudar

A classificação da origem não é imutável.

Uma tabela pode precisar ser reclassificada quando qualquer um dos seguintes aspectos se alterar:

- requisitos de negócio;
- volume da origem;
- frequência de alterações;
- *schema* da origem;
- comportamento da *watermark*;
- requisitos de DELETE;
- requisitos de latência;
- requisitos de recuperação;
- restrições operacionais;
- requisitos históricos *downstream*.

Por exemplo:

```text
TABELA DE REFERÊNCIA
pequena + orientada a estado
        ↓
Full Refresh Controlado
```

poderia posteriormente se tornar:

```text
TABELA DE REFERÊNCIA
alterações frequentes
+
transições históricas necessárias
        ↓
reavaliar mecanismo de captura
```

Da mesma forma:

```text
ALTERAÇÕES OCASIONAIS
+
updated_at aparentemente confiável
        ↓
Timestamp Incremental
```

poderia se tornar:

```text
validação da watermark falha
        ↓
Timestamp Incremental rejeitado
        ↓
estratégia alternativa necessária
```

A arquitetura deve responder às evidências em vez de preservar uma classificação desatualizada apenas porque ela foi documentada anteriormente.

### 4.9 A Classificação Deve Ser Revalidada Durante a Implementação

A classificação é uma hipótese arquitetural sobre o comportamento da origem.

A implementação é o momento em que essa hipótese encontra o sistema real.

O ciclo de vida esperado é:

```text
INVENTÁRIO DA ORIGEM
        ↓
CLASSIFICAÇÃO INICIAL
        ↓
ESTRATÉGIA DE CAPTURA
        ↓
IMPLEMENTAÇÃO
        ↓
TESTES CONTROLADOS
        ↓
EVIDÊNCIA OBSERVADA
        ↓
        ├── confirma as premissas
        │       ↓
        │   manter estratégia
        │
        └── contradiz as premissas
                ↓
            investigar
                ↓
          revisar se necessário
```

Isso é especialmente importante para mecanismos cuja correção depende do comportamento da origem, e não apenas da capacidade do banco de dados.

A captura incremental baseada em *timestamp* é um exemplo claro.

Um *schema* pode sugerir:

```text
updated_at existe
```

mas somente os testes de implementação podem estabelecer se:

```text
updated_at se comporta
conforme exigido pela estratégia de captura
```

A mesma disciplina se aplica à comparação de *snapshots*, ao *Full Refresh* Controlado e a futuros mecanismos de captura.

### 4.10 Resumo da Classificação

A classificação V1 é intencionalmente heterogênea:

```text
TRANSACIONAL
sales.Transaction
sales.TransactionItem
        ↓
A — Alto Volume de Alterações
        ↓
CDC


DADOS MESTRES / DESCRITIVOS
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
B — Alterações Ocasionais
        ↓
Timestamp Incremental
        ↓
validação da watermark necessária


REFERÊNCIA
sales.TransactionStatus
sales.TransactionChannel
        ↓
C — Referência
        ↓
Full Refresh Controlado


RELACIONAMENTO
catalog.ProductCategory
        ↓
D — Baixo Volume de Alterações / Sem Watermark
        ↓
Snapshot + Diff
```

Essa heterogeneidade é intencional.

O objetivo do Atlas Engineering não é minimizar a quantidade de mecanismos de captura a qualquer custo.

O objetivo é utilizar o mecanismo confiável mais simples que atenda aos requisitos de cada origem, protegendo ao mesmo tempo o sistema operacional.

O princípio resultante é:

> **Um domínio analítico não exige um único mecanismo de captura.**

O domínio define quais dados precisam funcionar em conjunto.

A estratégia de captura define a forma mais apropriada de obter cada parte desses dados.

---

## 5. Critérios de Seleção do Mecanismo de Captura

A seleção de um mecanismo de captura é uma decisão orientada por requisitos.

O Atlas Engineering não seleciona CDC, captura incremental baseada em *timestamp*, *Snapshot* + *Diff* ou *Full Refresh* Controlado apenas com base no tamanho da tabela, na familiaridade com uma tecnologia ou na uniformidade arquitetural.

O processo de seleção V1 avalia sete critérios principais:

```text
1. Frequência de Alterações
2. Requisito de Latência
3. Volume de Dados
4. Tolerância à Perda de Alterações
5. Disponibilidade de Watermark Confiável
6. Requisito de Detecção de DELETE
7. Sobrecarga Operacional
```

Esses critérios devem ser avaliados em conjunto.

Nenhum critério isolado determina automaticamente o mecanismo de captura.

Conceitualmente:

```text
ORIGEM
  │
  ▼
┌───────────────────────────────────┐
│       REQUISITOS DE CAPTURA       │
│                                   │
│ Frequência de alterações          │
│ Latência                          │
│ Volume                            │
│ Tolerância à perda de alterações  │
│ Confiabilidade da watermark       │
│ Detecção de DELETE                │
│ Sobrecarga operacional            │
└───────────────────────────────────┘
  │
  ▼
AVALIAÇÃO DO MECANISMO
  │
  ├── CDC
  ├── Timestamp Incremental
  ├── Snapshot + Diff
  └── Full Refresh Controlado
  │
  ▼
ESTRATÉGIA SELECIONADA
```

O objetivo dos critérios não é produzir uma pontuação mecânica.

Seu objetivo é tornar o raciocínio por trás de uma decisão de captura explícito, revisável e testável.

### 5.1 Frequência de Alterações

O primeiro critério avalia com que frequência se espera que a origem se altere.

Uma origem pode apresentar:

```text
alterações contínuas
        ↓
alterações frequentes
        ↓
alterações ocasionais
        ↓
alterações raras
        ↓
períodos longos praticamente sem alterações
```

A frequência de alterações é importante porque o custo e a utilidade dos diferentes mecanismos de captura variam de acordo com o comportamento da origem.

Por exemplo, obter repetidamente o estado completo de uma tabela transacional com alto volume de alterações pode se tornar desnecessariamente dispendioso.

Por outro lado, manter uma infraestrutura de captura em nível de alteração para um pequeno conjunto de dados de referência que raramente se altera pode introduzir complexidade sem fornecer valor correspondente.

A classificação inicial do Atlas Engineering utiliza:

```text
A — Alto Volume de Alterações

B — Alterações Ocasionais

C — Referência

D — Baixo Volume de Alterações / Sem Watermark
```

Entretanto, a frequência de alterações, por si só, não determina o mecanismo.

Por exemplo:

```text
BAIXO VOLUME DE ALTERAÇÕES
+
watermark confiável
+
estado incremental suficiente
```

pode levar a uma decisão diferente de:

```text
BAIXO VOLUME DE ALTERAÇÕES
+
sem watermark
+
remoção de relacionamento precisa ser detectada
```

Portanto:

> **A frequência de alterações fornece contexto para a decisão; ela não determina a decisão por si só.**

### 5.2 Requisito de Latência

O segundo critério avalia com que rapidez uma alteração na origem deve ficar disponível para o processamento *downstream*.

Os requisitos de latência podem variar significativamente entre as origens.

Conceitualmente:

```text
alteração na origem
     │
     ▼
captura
     │
     ▼
disponibilidade downstream
```

O atraso aceitável entre esses pontos influencia quais mecanismos são viáveis.

Uma origem cujas alterações precisam ficar disponíveis em minutos possui requisitos de captura diferentes dos de um pequeno conjunto de dados de referência cujo estado pode ser atualizado periodicamente.

A plataforma Atlas Engineering possui atualmente uma meta típica inicial de latência dos dados de:

```text
3–5 minutos
```

e um SLO formal V1 de latência de ponta a ponta de:

```text
P95 ≤ 15 minutos
```

Esses valores descrevem o objetivo mais amplo da plataforma de ponta a ponta.

Eles não devem ser interpretados como evidência de que todo mecanismo de captura ou toda origem já atingiu essa latência.

Para a seleção do mecanismo, a pergunta relevante é:

> **Com que rapidez as alterações desta origem específica precisam se tornar observáveis para a plataforma *downstream*?**

A resposta pode afetar:

- frequência de extração;
- frequência de *polling*;
- intervalo aceitável de lote;
- carga de trabalho na origem;
- complexidade operacional;
- adequação de mecanismos de atualização orientados a estado.

A latência deve, portanto, ser tratada como um requisito da origem, em vez de se presumir que seja idêntica para todas as tabelas.

### 5.3 Volume de Dados

O terceiro critério avalia a quantidade de dados envolvida no processo de captura.

O volume possui várias dimensões.

Ele pode significar:

```text
total de linhas na origem
```

mas também:

```text
linhas alteradas por intervalo
```

e:

```text
bytes gerados por essas alterações
```

Essas medidas não são equivalentes.

Considere:

```text
TABELA A
100 milhões de linhas
100 alterações por dia
```

em comparação com:

```text
TABELA B
1 milhão de linhas
500.000 alterações por dia
```

A primeira tabela é maior em tamanho total.

A segunda produz um volume de alterações muito maior.

A estratégia de captura deve, portanto, distinguir:

```text
TAMANHO DA ORIGEM
≠
VOLUME DE ALTERAÇÕES
```

Um *Full Refresh* processa repetidamente o conjunto de dados atual.

A captura incremental baseada em *timestamp* procura processar as linhas alteradas que atendem aos critérios.

O CDC expõe as alterações capturadas.

*Snapshot* + *Diff* exige uma quantidade suficiente do estado da origem para realizar a comparação.

Cada mecanismo, portanto, interage de maneira diferente com o tamanho da origem e o volume de alterações.

Para o Atlas Engineering, o volume deve ser avaliado em conjunto com a principal regra operacional:

> **O processo de captura não deve criar pressão desnecessária sobre o AtlasCommerce.**

### 5.4 Tolerância à Perda de Alterações

O quarto critério avalia a consequência de não observar uma alteração na origem.

Esse é um dos requisitos de captura mais importantes.

Dados diferentes podem produzir consequências distintas caso uma alteração seja perdida.

Conceitualmente:

```text
alteração ocorre na origem
        ↓
captura não a observa
        ↓
o que acontece?
```

As possíveis consequências incluem:

- ausência de impacto analítico significativo;
- dados descritivos temporariamente defasados;
- estado incorreto de relacionamento;
- estado incorreto da transação;
- ausência de dados relacionados à receita;
- reconciliação incorreta;
- incapacidade de reconstruir o histórico da origem.

Portanto, a pergunta não é simplesmente:

```text
Este mecanismo consegue recuperar dados?
```

É:

```text
Este mecanismo consegue recuperar de forma confiável
as alterações exigidas por este caso de uso?
```

Para dados transacionais de vendas, a perda silenciosa é particularmente indesejável.

Isso está alinhado ao princípio mais amplo de entrega do Atlas Engineering:

> **Prefira receber os dados novamente a perdê-los silenciosamente.**

No nível da plataforma, a decisão de entrega V1 é:

```text
At-Least-Once
+
Idempotência
```

O comportamento completo de ponta a ponta ainda não foi implementado nem comprovado.

Entretanto, a estratégia de captura já deve evitar mecanismos que criem pontos cegos inaceitáveis para alterações obrigatórias na origem.

### 5.5 Disponibilidade de Watermark Confiável

O quinto critério determina se a origem fornece um valor capaz de definir de forma confiável o progresso da extração incremental.

Uma *watermark* é um valor utilizado para estabelecer um limite como:

```text
já processado
        │
        ▼
WATERMARK = T1
        │
        ▼
recuperar alterações após T1
```

Uma candidata comum é:

```text
updated_at
```

mas a existência dessa coluna é insuficiente.

O mecanismo depende de sua semântica.

Uma *watermark* candidata deve ser avaliada em relação a questões como:

```text
Toda alteração relevante a modifica?

Várias linhas podem possuir o mesmo valor?

Qual é sua precisão?

Seu valor pode retroceder?

Uma transação pode ser confirmada depois de outra linha
mesmo carregando um timestamp anterior?

Como valores iguais nos limites são tratados?

Um DELETE físico pode ser representado?
```

Uma implementação ingênua poderia utilizar:

```sql
WHERE updated_at > @last_watermark
```

Isso parece simples, mas contém um problema importante de limite.

Suponha que a extração anterior termine com:

```text
last_watermark =
2026-08-29 10:00:00
```

e várias linhas da origem possuam:

```text
updated_at =
2026-08-29 10:00:00
```

Se apenas algumas dessas linhas tiverem sido processadas com segurança antes do avanço do *checkpoint*, a próxima consulta utilizando:

```text
>
```

poderá excluir linhas ainda não processadas que compartilham o mesmo *timestamp*.

Isso não significa que a captura incremental baseada em *timestamp* seja inválida.

Significa que:

> **A semântica da *watermark* e os limites de extração devem ser projetados e testados, e não presumidos.**

Possíveis técnicas de implementação poderão incluir posteriormente lógica adicional de limite ou critérios determinísticos de desempate, mas este documento não seleciona uma implementação desse tipo antes dos testes.

Para a hipótese V1 atual:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

são candidatas à captura incremental baseada em *timestamp*.

O comportamento real de suas *watermarks* ainda precisa ser validado.

### 5.6 Requisito de Detecção de DELETE

O sexto critério pergunta se a plataforma precisa detectar que uma linha da origem deixou de existir.

A detecção de DELETE deve ser avaliada separadamente da detecção de INSERT e UPDATE.

Considere uma extração incremental baseada em *timestamp*:

```text
linha existe
updated_at = T1
        ↓
DELETE
        ↓
linha deixa de existir
```

Uma consulta posterior à origem não consegue recuperar a linha excluída apenas filtrando seu *timestamp*, pois a linha não existe mais.

Portanto:

```text
Timestamp Incremental
```

não fornece inerentemente:

```text
detecção de DELETE físico
```

Outros mecanismos podem tratar o desaparecimento de maneiras diferentes.

O CDC pode expor operações DELETE capturadas para origens configuradas adequadamente.

*Snapshot* + *Diff* pode inferir o desaparecimento comparando:

```text
ESTADO ANTERIOR
      vs
ESTADO ATUAL
```

O *Full Refresh* Controlado pode estabelecer o estado atual autoritativo, embora a necessidade de a lógica *downstream* interpretar uma linha ausente como um DELETE histórico seja um requisito separado.

O processo de decisão deve, portanto, perguntar:

```text
O desaparecimento é relevante?

Ele precisa ser detectado?

Precisa ser detectado como um evento?

Ou o estado atual autoritativo é suficiente?
```

Esses são requisitos diferentes.

Por exemplo:

```text
sales.Transaction
sales.TransactionItem
```

exigem visibilidade confiável de DELETE físico na estratégia V1 selecionada.

Para:

```text
catalog.ProductCategory
```

a comparação entre *snapshots* fornece uma forma de identificar relacionamentos que existiam anteriormente, mas não existem mais no *snapshot* atual.

Para outras origens, os requisitos de DELETE não devem ser inventados antes que o requisito analítico seja estabelecido.

### 5.7 Sobrecarga Operacional

O sétimo critério avalia o custo operacional introduzido por um mecanismo de captura.

A sobrecarga operacional inclui mais do que o uso de CPU na origem.

Ela pode incluir:

- I/O na origem;
- crescimento de armazenamento;
- gerenciamento de retenção;
- *jobs* do banco de dados;
- consultas de extração;
- varreduras completas de tabelas;
- transferência pela rede;
- monitoramento;
- alertas;
- procedimentos de recuperação;
- gerenciamento de *checkpoints*;
- *troubleshooting*;
- tratamento da evolução de *schema*;
- dependências operacionais;
- modos de falha.

Um mecanismo pode ser tecnicamente capaz de capturar uma origem e, ainda assim, ser operacionalmente inadequado.

Por exemplo:

```text
CDC
```

introduz questões como:

```text
processamento de captura
retenção
limpeza
tabelas de alterações
instâncias de captura
jobs
janela de recuperação
monitoramento
```

A captura incremental baseada em *timestamp* introduz questões diferentes:

```text
correção da watermark
persistência do checkpoint
tratamento de limites
desempenho das consultas na origem
limitações de DELETE
```

*Snapshot* + *Diff* introduz:

```text
armazenamento de snapshot
custo de comparação
consistência do estado
derivação de alterações
```

O *Full Refresh* Controlado introduz:

```text
extração completa da origem
frequência de atualização
comportamento de substituição / reconciliação
```

A pergunta correta, portanto, não é:

```text
Qual mecanismo não possui sobrecarga?
```

porque todo mecanismo possui custo operacional.

A pergunta é:

> **Qual mecanismo fornece a correção e a latência exigidas com custo operacional aceitável?**

### 5.8 Os Critérios São Interdependentes

Os sete critérios não devem ser avaliados de forma independente.

Um mecanismo que pareça atraente sob um critério pode se tornar inadequado quando outro for considerado.

Exemplo:

```text
ORIGEM
Baixa frequência de alterações
        ↓
Full Refresh parece atraente
```

Mas:

```text
ORIGEM
Baixa frequência de alterações
+
tabela extremamente grande
+
restrições rigorosas de carga na origem
        ↓
Full Refresh pode deixar de ser atraente
```

Outro exemplo:

```text
ORIGEM
Alterações ocasionais
+
updated_at disponível
        ↓
Timestamp Incremental parece atraente
```

Mas:

```text
ORIGEM
Alterações ocasionais
+
updated_at disponível
+
DELETE físico precisa ser detectado
+
nenhum mecanismo separado de exclusão
        ↓
Timestamp Incremental isoladamente pode ser insuficiente
```

Portanto, a seleção do mecanismo deve avaliar o conjunto combinado de requisitos.

Conceitualmente:

```text
             FREQUÊNCIA
            DE ALTERAÇÕES
                │
                │
     VOLUME ────┼──── LATÊNCIA
                │
                ▼
        DECISÃO DE CAPTURA
                ▲
                │
 WATERMARK ─────┼──── DELETE
                │
                │
      TOLERÂNCIA À PERDA
        DE ALTERAÇÕES
                │
                │
       SOBRECARGA
       OPERACIONAL
```

A decisão existe na interseção dessas questões.

### 5.9 Perguntas para Seleção

Para cada nova origem considerada pelo Atlas Engineering, as seguintes perguntas devem ser respondidas antes da aprovação de um mecanismo de captura:

```text
01. Qual papel de negócio ou analítico a origem desempenha?

02. Com que frequência ela se altera?

03. Qual é o tamanho esperado da origem?

04. Qual é o volume esperado de alterações?

05. Com que rapidez as alterações precisam ficar disponíveis downstream?

06. INSERT precisa ser detectado?

07. UPDATE precisa ser detectado?

08. DELETE físico precisa ser detectado?

09. O histórico de alterações individuais é necessário,
    ou o estado atual autoritativo é suficiente?

10. A origem disponibiliza uma watermark candidata?

11. Essa watermark já foi comprovada como confiável?

12. Alterações relevantes podem ocorrer sem modificá-la?

13. Várias linhas podem compartilhar a mesma watermark?

14. O que acontece nos limites de extração?

15. O que acontece se o processo de captura ficar indisponível?

16. Por quanto tempo a recuperação deve continuar possível?

17. Qual carga de trabalho na origem o mecanismo introduz?

18. Essa carga pode interferir no sistema OLTP?

19. Como as linhas existentes serão carregadas inicialmente?

20. Como as alterações futuras serão protegidas durante o backfill?

21. Como DELETE ou desaparecimento serão representados?

22. Quais premissas ainda exigem testes de implementação?

23. Quais são as limitações aceitas?

24. Quais evidências serão exigidas antes que o mecanismo
    seja considerado operacionalmente validado?
```

Essas perguntas formam uma avaliação de captura reutilizável para futuros domínios do Atlas Engineering.

### 5.10 Modelo de Decisão do Mecanismo

O modelo a seguir resume o processo de raciocínio V1.

Ele é um auxílio à decisão, não um algoritmo automático:

```text
INÍCIO
  │
  ▼
As alterações individuais na origem são importantes?
  │
  ├── SIM
  │     │
  │     ▼
  │   DELETE físico precisa ser detectado de forma confiável?
  │     │
  │     ├── SIM
  │     │     │
  │     │     ▼
  │     │   A captura em nível de alteração está disponível
  │     │   e é operacionalmente aceitável?
  │     │     │
  │     │     ├── SIM → Avaliar CDC
  │     │     │
  │     │     └── NÃO → Avaliar mecanismo alternativo
  │     │     │                de detecção de alterações
  │     │     │
  │     │     └── validar requisitos
  │     │
  │     └── NÃO
  │           │
  │           ▼
  │       Existe uma watermark confiável?
  │           │
  │           ├── SIM → Avaliar
  │           │         Timestamp Incremental
  │           │
  │           └── NÃO → Avaliar
  │                     Snapshot + Diff
  │                     ou outro mecanismo
  │
  └── NÃO
        │
        ▼
      O estado atual autoritativo é suficiente?
        │
        ├── SIM
        │     │
        │     ▼
        │   A extração completa da origem
        │   é operacionalmente aceitável?
        │     │
        │     ├── SIM → Avaliar
        │     │         Full Refresh Controlado
        │     │
        │     └── NÃO → Avaliar
        │               mecanismo incremental /
        │               comparação de estados
        │
        └── NÃO
              ↓
          Reavaliar requisitos
          e mecanismos disponíveis
```

A palavra `Avaliar` é intencional.

O diagrama não deve ser interpretado como:

```text
pergunta respondida
        ↓
mecanismo aprovado automaticamente
```

Em vez disso:

```text
mecanismo candidato identificado
        ↓
avaliar todos os critérios
        ↓
documentar premissas
        ↓
implementar
        ↓
testar
        ↓
observar
        ↓
validar ou revisar
```

### 5.11 Comparação dos Mecanismos

No nível atual da estratégia V1, os quatro mecanismos podem ser comparados conceitualmente da seguinte forma:

| Característica | CDC | *Timestamp* Incremental | *Snapshot* + *Diff* | *Full Refresh* Controlado |
|---|---|---|---|---|
| Orientado a alterações | Sim | Parcialmente | Derivado da comparação de estados | Principalmente orientado a estado |
| Detecção de INSERT | Sim | Sim, quando a semântica da *watermark* permite | Derivada | Estado atual obtido |
| Detecção de UPDATE | Sim | Sim, quando a *watermark* é confiável | Derivada | Estado atual obtido |
| Detecção de DELETE físico | Sim, quando capturado pelo CDC | Não inerentemente | Derivada do desaparecimento | O estado atual reflete o desaparecimento |
| Exige watermark na origem | Não exige watermark baseada em *timestamp* | Sim | Não | Não |
| Exige estado anterior para comparação | Não | *Checkpoint* necessário | Sim | Não inerentemente |
| Adequado para origens transacionais com alto volume de alterações | Potencialmente, sujeito aos recursos da origem e à sobrecarga | Depende dos requisitos | Geralmente menos atraente | Geralmente menos atraente |
| Complexidade operacional | Maior | Moderada | Moderada | Menor para origens pequenas |
| Fidelidade das alterações históricas | Captura em nível de alteração após o limite | Limitada às linhas qualificadas observáveis | Derivada entre snapshots | Estado atual, a menos que histórico adicional seja criado |
| Estado histórico inicial ainda necessário | Sim | Sim | Sim | O estado completo é a própria atualização |

Esta tabela descreve características conceituais.

Ela não afirma que todos os mecanismos já tenham sido implementados ou validados no Atlas Engineering.

### 5.12 A Seleção É Seguida pela Validação

Um mecanismo de captura não é aprovado operacionalmente apenas porque o raciocínio arquitetural indica que ele deve funcionar.

O Atlas Engineering segue:

```text
REQUISITO
    ↓
ANÁLISE DA ORIGEM
    ↓
SELEÇÃO DO MECANISMO
    ↓
IMPLEMENTAÇÃO
    ↓
TESTE CONTROLADO
    ↓
OBSERVABILIDADE
    ↓
EVIDÊNCIA
    ↓
VALIDAÇÃO
```

Para o CDC:

```text
seleção arquitetural
        ↓
implementação do SQL Server CDC
        ↓
testes controlados na origem
        ↓
evidências M01.08–M01.19
```

já começaram a validar a estratégia no lado da origem.

Para:

```text
Timestamp Incremental
Snapshot + Diff
Full Refresh Controlado
```

a validação da implementação permanece pendente.

Essa distinção impede que a arquitetura se transforme em uma coleção de premissas não testadas.

### 5.13 Registro de Decisão para Cada Origem

Quando um mecanismo de captura for finalizado para uma origem, seu registro de decisão deve ser capaz de resumir:

```text
ORIGEM
<schema.table>

PAPEL
<por que a plataforma precisa dela>

PERFIL DE ALTERAÇÃO
<alto / ocasional / referência / baixo>

REQUISITO DE LATÊNCIA
<disponibilidade de captura exigida>

VOLUME
<características conhecidas ou esperadas>

REQUISITO DE INSERT
<sim / não / somente estado atual>

REQUISITO DE UPDATE
<sim / não / somente estado atual>

REQUISITO DE DELETE
<sim / não / apenas desaparecimento / pendente>

WATERMARK
<disponível / indisponível / validação pendente>

MECANISMO SELECIONADO
<CDC / Timestamp Incremental / Snapshot + Diff / Full Refresh Controlado>

FUNDAMENTO
<por que este mecanismo é adequado>

LIMITAÇÕES ACEITAS
<trade-offs conhecidos>

ESTADO DA VALIDAÇÃO
<hipótese / implementado / testado>

EVIDÊNCIA
<referência à evidência de implementação quando disponível>
```

Essa estrutura garante que futuras decisões de captura permaneçam explicáveis sem exigir que os leitores reconstruam o raciocínio a partir do código de implementação.

### 5.14 Princípio de Seleção

O processo de seleção pode ser resumido pela seguinte regra:

> **Escolha o mecanismo mais simples que consiga atender de forma confiável aos requisitos de visibilidade das alterações, latência, recuperação e proteção da origem.**

Não:

```text
Escolha o mecanismo mais simples.
```

E também não:

```text
Escolha o mecanismo mais sofisticado.
```

A palavra determinante é:

```text
de forma confiável
```

Um mecanismo simples que perde silenciosamente alterações obrigatórias não é engenharia simples.

É uma solução incompleta.

Da mesma forma, um mecanismo complexo que fornece capacidades de que a origem não necessita representa uma sobrecarga operacional desnecessária.

O objetivo é:

```text
CORREÇÃO NECESSÁRIA
        +
LATÊNCIA NECESSÁRIA
        +
RECUPERAÇÃO NECESSÁRIA
        +
PROTEÇÃO DO OLTP
        +
COMPLEXIDADE ACEITÁVEL
        ↓
MECANISMO DE CAPTURA APROPRIADO
```

---

## 6. Estratégia de CDC

O Change Data Capture (CDC) é o mecanismo de captura V1 selecionado para as origens transacionais com alto volume de alterações que formam o núcleo do domínio inicial de Sales Analytics.

As origens selecionadas são:

```text
sales.Transaction
sales.TransactionItem
```

Para essas tabelas, o requisito de captura vai além da obtenção periódica de seu estado atual.

A Plataforma de Engenharia de Dados deve ser capaz de observar alterações relevantes que ocorram após o limite de captura, incluindo:

```text
INSERT
UPDATE
DELETE
```

A estratégia também deve proteger a carga de trabalho OLTP do AtlasCommerce contra padrões desnecessários de extração analítica.

Para a origem atual em SQL Server, o mecanismo selecionado é:

```text
SQL Server Native CDC
```

Conceitualmente:

```text
APLICAÇÃO
     │
     │ DML
     ▼
AtlasCommerce
SQL Server
     │
     │ atividade transacional
     ▼
Transaction Log
     │
     ▼
SQL Server Native CDC
     │
     ▼
Dados de Alteração do CDC
     │
     ▼
limite de consumo downstream
```

O CDC está, portanto, posicionado no limite de captura da origem.

Ele identifica as alterações produzidas pelo banco de dados operacional para que os componentes *downstream* possam posteriormente consumi-las e transportá-las.

Este documento define por que o CDC é utilizado e as restrições arquiteturais que envolvem essa decisão.

Configuração detalhada, *scripts*, resultados de laboratório, metadados do CDC, testes DML controlados e comportamento observado pertencem a:

`AtlasEngineering-SQL-Server-CDC-Implementation.md`

### 6.1 Tabelas Aplicáveis

A estratégia de CDC V1 aplica-se a:

```text
sales.Transaction
sales.TransactionItem
```

Essas tabelas formam o núcleo transacional do primeiro domínio de Engenharia de Dados.

A relação entre elas é:

```text
sales.Transaction
        │
        │ 1 : N
        ▼
sales.TransactionItem
```

O grão analítico definido para o produto de dados inicial de Sales Analytics é:

> **Uma linha por `sales.TransactionItem` associada a uma `sales.Transaction`.**

Isso torna importantes os dois lados da relação.

Capturar apenas:

```text
sales.Transaction
```

não forneceria o nível de detalhe por item exigido pelo grão analítico.

Capturar apenas:

```text
sales.TransactionItem
```

omitiria atributos no nível da transação necessários para interpretar esses itens.

As duas origens, portanto, participam conjuntamente do limite de captura:

```text
Transaction
     +
TransactionItem
     ↓
captura transacional de vendas
```

Ambas estão atualmente classificadas como:

```text
A — Alto Volume de Alterações
```

e ambas utilizam:

```text
SQL Server Native CDC
```

na V1.

### 6.2 Fundamentação

A decisão pelo CDC baseia-se no conjunto de requisitos das origens transacionais, e não em uma preferência pelo CDC como tecnologia.

As principais considerações são:

- comportamento transacional com alto volume de alterações;
- necessidade de captura orientada a alterações;
- visibilidade de INSERT;
- visibilidade de UPDATE;
- visibilidade de DELETE físico;
- preservação do contexto das alterações no lado da origem;
- menor dependência de varreduras analíticas repetidas nas tabelas transacionais;
- proteção da carga de trabalho OLTP;
- necessidade de uma janela operacional de recuperação;
- futura integração com a arquitetura de *streaming*.

A decisão pode ser representada como:

```text
ORIGEM TRANSACIONAL
        +
ALTO VOLUME DE ALTERAÇÕES
        +
VISIBILIDADE EM NÍVEL DE ALTERAÇÃO
        +
DETECÇÃO DE DELETE
        +
ORIGEM SQL SERVER
        +
PROTEÇÃO DO OLTP
        ↓
SQL SERVER NATIVE CDC
```

O CDC não é selecionado apenas porque o SQL Server oferece suporte a ele.

Ele é selecionado porque suas capacidades estão alinhadas aos requisitos atuais de captura dessas origens.

#### Captura Orientada a Alterações

Para essas tabelas transacionais, a plataforma está interessada em mais do que comparações periódicas de estado.

A pergunta relevante é:

```text
O que mudou após o limite de captura?
```

e não apenas:

```text
O que a tabela contém agora?
```

O SQL Server CDC fornece informações orientadas a alterações para as operações capturadas na origem.

As evidências atuais de implementação demonstraram representações no lado da origem para:

```text
INSERT

UPDATE
├── BEFORE
└── AFTER

DELETE
```

Essas observações validam premissas importantes por trás da seleção arquitetural.

Elas ainda não comprovam o consumo *downstream* nem a semântica de eventos de ponta a ponta.

#### Proteção do OLTP

O AtlasCommerce é responsável pelo processamento operacional das vendas.

O mecanismo de captura deve respeitar:

> **A saúde do sistema OLTP possui prioridade sobre a conveniência analítica.**

Um projeto ingênuo de captura analítica poderia consultar repetidamente as tabelas transacionais para descobrir o que mudou.

Por exemplo:

```text
processo de Engenharia de Dados
        ↓
consulta repetida à origem
        ↓
scan / seek nas tabelas operacionais
        ↓
competição com a carga de trabalho de negócio
```

O custo exato dependeria de índices, predicados, distribuição dos dados, frequência, volume e planos de execução.

O objetivo arquitetural não é afirmar que toda consulta incremental necessariamente prejudicaria o sistema OLTP.

O objetivo é evitar que a extração analítica repetida na origem seja utilizada como o principal mecanismo de detecção de alterações quando o SQL Server já oferece uma capacidade de CDC baseada no *Transaction Log* adequada ao requisito.

### 6.3 Modelo de Captura do SQL Server CDC

O SQL Server Native CDC deriva as informações das alterações capturadas a partir da atividade do *Transaction Log* do SQL Server.

O modelo conceitual utilizado pelo Atlas Engineering é:

```text
DML
 ↓
Transação do SQL Server
 ↓
Transaction Log
 ↓
Processamento de Captura do CDC
 ↓
Tabelas de Alterações do CDC
 ↓
Funções de Consumo do CDC
 ↓
Consumidor Downstream
```

Essa distinção é importante porque, no projeto do Atlas Engineering, o CDC não é implementado como um mecanismo de captura baseado em *triggers* da aplicação.

A aplicação continua executando operações transacionais normais no AtlasCommerce.

O CDC observa as informações correspondentes às alterações no banco de dados por meio da infraestrutura de CDC do SQL Server.

Isso ajuda a separar:

```text
PROCESSAMENTO DAS TRANSAÇÕES DE NEGÓCIO
```

de:

```text
CAPTURA ANALÍTICA DE ALTERAÇÕES
```

O CDC também possui dois limites distintos de habilitação no SQL Server:

```text
BANCO DE DADOS
   ↓
CDC habilitado para o banco de dados
   ↓
TABELA
   ↓
tabela de origem específica habilitada
```

Habilitar o CDC no nível do banco de dados não faz com que todas as tabelas sejam automaticamente capturadas.

Cada tabela de origem necessária deve ser selecionada deliberadamente.

Isso sustenta um importante princípio arquitetural:

> **Capture apenas o que a plataforma exige; não habilite a captura de alterações indiscriminadamente.**

### 6.4 O CDC É Assíncrono

A transação na origem e o aparecimento dos registros correspondentes no CDC não são a mesma operação sob a perspectiva do observador *downstream*.

Conceitualmente:

```text
TRANSAÇÃO DA APLICAÇÃO
        ↓
COMMIT
        ↓
estado da origem confirmado
        ↓
processamento de captura do CDC
        ↓
alteração fica disponível
```

Portanto:

```text
COMMIT na origem
≠
visibilidade imediata no CDC
```

Essa característica é importante no projeto dos consumidores e do monitoramento.

Um consumidor não deve presumir:

```text
COMMIT às 10:00:00
        ↓
linha do CDC necessariamente consultável
exatamente às 10:00:00
```

O laboratório atual do Atlas Engineering observou repetidamente esse comportamento assíncrono.

Na configuração atual, o *job* de captura do CDC utiliza um intervalo de *polling* de:

```text
5 segundos
```

e os testes controlados de laboratório normalmente aguardaram aproximadamente:

```text
6 segundos
```

antes de consultar novamente os dados do CDC.

Entretanto:

> **O atraso observado em laboratório não constitui uma garantia de latência dos dados em produção.**

A configuração de *polling* de 5 segundos e as observações de laboratório descrevem o ambiente atual.

Elas não estabelecem o SLO completo de ponta a ponta.

### 6.5 LSN como Conceito de Limite de Captura

O CDC utiliza Log Sequence Numbers (LSNs) como parte de seu modelo de rastreamento de alterações.

Um LSN não deve ser interpretado como um *timestamp* de negócio.

Conceitualmente:

```text
LSN
→ posição / contexto de ordenação associado à atividade do log
```

enquanto:

```text
horário do evento de negócio
→ quando o evento de negócio é representado como ocorrido
```

e:

```text
horário de ingestão da plataforma
→ quando a Plataforma de Engenharia de Dados o recebe ou persiste
```

Esses conceitos são diferentes:

```text
Horário do Evento de Negócio
        ≠
Horário da Transação do CDC
        ≠
Horário de Ingestão da Plataforma
```

Da mesma forma:

```text
LSN
≠
timestamp
```

Um LSN é útil para identificar e ordenar limites de processamento do CDC.

Ele é conceitualmente comparável a mecanismos como um *offset* do Kafka apenas no sentido limitado de que ambos podem representar progresso ou posição em seus respectivos sistemas.

Eles não são identificadores equivalentes e não devem ser tratados como intercambiáveis.

A semântica detalhada de consumo de:

```text
minimum LSN
maximum LSN
from_lsn
to_lsn
increment_lsn
checkpoint
```

permanece fora da estratégia atualmente validada.

Ela será investigada durante a implementação do consumo do CDC.

### 6.6 O Contexto da Transação É Importante

As linhas de alteração do CDC não devem ser automaticamente interpretadas como eventos de negócio independentes e não relacionados.

As evidências atuais de laboratório demonstraram que múltiplas alterações geradas dentro da mesma transação SQL podem compartilhar contexto transacional do CDC.

Os exemplos observados incluem:

```text
uma única transação SQL
        │
        ├── INSERT Transaction
        ├── INSERT TransactionItem
        └── INSERT TransactionItem
```

e:

```text
uma única transação SQL
        │
        ├── UPDATE Transaction
        ├── UPDATE TransactionItem
        └── UPDATE TransactionItem
```

assim como:

```text
um único DELETE explícito no pai
        │
        ├── DELETE Transaction
        ├── DELETE TransactionItem em cascata
        └── DELETE TransactionItem em cascata
```

Os testes observaram um:

```text
__$start_lsn
```

comum para alterações originadas da mesma transação SQL entre as tabelas de origem habilitadas para CDC.

Metadados adicionais do CDC, como:

```text
__$command_id
__$seqval
__$operation
__$update_mask
```

forneceram contexto adicional das alterações no lado da origem durante o laboratório.

Essa evidência é importante porque demonstra que:

> **Um conjunto de linhas do CDC pode representar múltiplos efeitos físicos pertencentes a um único contexto transacional.**

Entretanto, isso não deve ser extrapolado além das evidências.

Em particular:

```text
contexto transacional compartilhado
no CDC do SQL Server
```

ainda não comprova que:

```text
Debezium exporá a transação
como uma única unidade indivisível para o consumidor
```

e não comprova que:

```text
Kafka entregará alterações relacionadas
atomicamente entre tópicos
```

Essas são questões *downstream* distintas que exigem implementação e testes próprios.

### 6.7 Detecção de DELETE

A detecção de DELETE físico é um dos principais motivos pelos quais o CDC foi selecionado para as origens transacionais.

Um mecanismo incremental baseado em *timestamp* normalmente descobre linhas que continuam existindo e atendem a uma condição de *watermark*.

Por exemplo:

```sql
SELECT ...
FROM sales.Transaction
WHERE TRN_updated_at > @last_watermark;
```

Se uma linha for fisicamente excluída:

```text
LINHA EXISTE
    ↓
DELETE
    ↓
LINHA NÃO EXISTE
```

a consulta posterior baseada em *timestamp* não terá uma linha para recuperar.

O CDC fornece um modelo de captura diferente porque o DELETE pode ser representado nos dados de alteração capturados.

Para as origens transacionais V1 atuais, essa capacidade é necessária.

O laboratório de implementação já validou a captura de DELETE físico no lado da origem para:

```text
sales.Transaction
```

e:

```text
sales.TransactionItem
```

### 6.8 Semântica de DELETE em Cascata

A relação entre as duas tabelas transacionais contém uma importante regra de integridade referencial:

```text
sales.TransactionItem
        │
        │ FK
        ▼
sales.Transaction

ON DELETE CASCADE
```

Isso significa que uma aplicação pode executar:

```text
DELETE da Transaction pai
```

enquanto o SQL Server também remove as linhas filhas relacionadas como consequência da integridade referencial.

Conceitualmente:

```text
APLICAÇÃO
    │
    │ um DELETE explícito
    ▼
sales.Transaction
    │
    │ ON DELETE CASCADE
    ▼
sales.TransactionItem
```

No nível das alterações físicas dos dados:

```text
1 linha pai excluída
+
N linhas filhas excluídas
```

O laboratório atual de CDC demonstrou esse comportamento com:

```text
1 DELETE explícito no pai
        ↓
1 DELETE de Transaction capturado
+
2 DELETEs de TransactionItem capturados
```

Isso estabelece uma importante regra semântica:

> **O número de alterações DELETE capturadas não deve ser automaticamente interpretado como o número de instruções DELETE executadas explicitamente pela aplicação.**

Uma única ação lógica da aplicação pode produzir múltiplas alterações físicas entre tabelas relacionadas.

Essa distinção se tornará importante quando os consumidores *downstream* reconstruírem o significado de negócio a partir das alterações na origem.

### 6.9 Janela de Recuperação do CDC

O SQL Server CDC retém as alterações capturadas por um período operacional finito.

O Atlas Engineering trata essa retenção como:

```text
JANELA DE RECUPERAÇÃO
```

e não como:

```text
HISTÓRICO PERMANENTE
```

O valor padrão do SQL Server observado durante a implementação foi:

```text
4320 minutos
=
3 dias
```

A decisão V1 alterou esse valor para:

```text
21600 minutos
=
15 dias
```

O raciocínio arquitetural é:

```text
~10 dias de possível ausência
+
~2 dias para detecção / análise
+
~3 dias para reparo / reprocessamento
=
~15 dias
```

Essa janela fornece tolerância operacional adicional para situações como:

- fins de semana;
- feriados;
- ausências prolongadas;
- incidentes;
- detecção tardia;
- diagnóstico;
- reparo;
- reprocessamento.

Conceitualmente:

```text
ALTERAÇÃO CAPTURADA
      │
      │ retida
      ▼
JANELA DE RECUPERAÇÃO DO CDC
      │
      ├── consumidor saudável
      │      ↓
      │   processar normalmente
      │
      └── consumidor indisponível
             ↓
          recuperar antes que
          os dados necessários do CDC
          sejam removidos pelo cleanup
```

A janela de recuperação não garante a recuperação por si só.

A recuperação também depende de:

- estado do *checkpoint* do consumidor;
- disponibilidade do intervalo necessário do CDC;
- correção *downstream*;
- comportamento de *replay*;
- procedimentos operacionais.

Esses mecanismos ainda exigem implementação e testes.

### 6.10 A Retenção do CDC Não É Armazenamento Histórico

Aumentar indefinidamente a retenção do CDC transferiria uma responsabilidade para a camada arquitetural errada.

O modelo pretendido é:

```text
SQL Server CDC
        ↓
captura operacional de alterações
e janela de recuperação

Kafka
        ↓
streaming durável de eventos
e janela de replay

Bronze
        ↓
ingestão histórica durável
e fonte de reprocessamento
```

Cada camada possui uma responsabilidade diferente.

O SQL Server CDC existe próximo à origem OLTP e não deve se tornar o arquivo histórico permanente da Plataforma de Engenharia de Dados.

Depois que os dados tiverem sido adquiridos e persistidos com garantia de durabilidade *downstream*, o histórico de longo prazo deve progressivamente se tornar responsabilidade da plataforma, em vez das estruturas de CDC da origem.

Portanto:

> **A retenção do CDC protege a capacidade operacional de recuperação; a Bronze protege a ingestão histórica durável.**

As responsabilidades do Kafka e da Bronze apresentadas aqui permanecem como decisões arquiteturais pendentes de suas próprias evidências de implementação.

### 6.11 Latência dos Dados e Retenção do CDC

O *polling* do CDC e a retenção do CDC não devem ser confundidos.

Eles respondem a perguntas diferentes.

```text
CAPTURA / LATÊNCIA DOS DADOS
Com que rapidez uma alteração fica disponível?

JANELA DE RECUPERAÇÃO
Por quanto tempo os dados capturados permanecem recuperáveis?
```

Os valores V1 atuais incluem:

```text
Meta típica de latência da plataforma
≈ 3–5 minutos

SLO formal de ponta a ponta
P95 ≤ 15 minutos

Retenção do CDC
15 dias
```

Essas dimensões são independentes.

Por exemplo:

```text
polling a cada 5 segundos
+
retenção de 15 dias
```

não significa:

```text
dados de ponta a ponta garantidos
em até 5 segundos
```

porque existem estágios adicionais *downstream*.

Da mesma forma:

```text
P95 ≤ 15 minutos
```

não significa que os dados capturados pelo CDC precisem ser retidos por apenas 15 minutos.

O primeiro diz respeito à disponibilidade dos dados.

O segundo diz respeito à tolerância para recuperação.

### 6.12 Limpeza Faz Parte das Operações do CDC

A retenção finita do CDC exige limpeza.

Conceitualmente:

```text
CDC captura novas alterações
        ↓
Tabelas de Alterações crescem
        ↓
limite de retenção avança
        ↓
dados de captura antigos elegíveis
        ↓
limpeza
```

Sem limpeza, o armazenamento do CDC poderia continuar crescendo.

Com uma limpeza excessivamente agressiva, a recuperação *downstream* poderia perder acesso às alterações antes que elas fossem processadas com segurança.

A retenção representa, portanto, um equilíbrio entre:

```text
CAPACIDADE DE RECUPERAÇÃO
        ↕
ARMAZENAMENTO NA ORIGEM / CUSTO OPERACIONAL
```

A janela V1 selecionada de 15 dias é uma decisão operacional para a arquitetura atual.

Ela deve ser monitorada e poderá exigir ajustes futuros com base em valores reais de:

- volume de alterações;
- crescimento do armazenamento do CDC;
- disponibilidade do consumidor;
- experiência de recuperação;
- capacidade da origem;
- requisitos operacionais.

O documento de implementação registra como a retenção da limpeza foi configurada e o erro operacional encontrado durante a manipulação do *job* de limpeza.

Esse erro constitui evidência e pertence à documentação de implementação, em vez de ser ocultado do histórico do projeto.

### 6.13 Governança de Partition Switch

As duas origens transacionais com CDC são particionadas:

```text
sales.Transaction
sales.TransactionItem
```

A configuração atual do CDC permite *partition switching*:

```text
allow_partition_switch = 1
```

O SQL Server possui uma importante restrição do CDC associada às operações `SWITCH` de partição:

> As operações de *partition switching* não são representadas pelo CDC como alterações comuns em nível de linha da mesma forma que operações DML normais.

Isso cria um possível conflito semântico.

Considere:

```text
DELETE NORMAL DE NEGÓCIO
        ↓
venda é logicamente removida
        ↓
semântica de DELETE pode ser relevante downstream
```

em comparação com:

```text
PARTITION SWITCH OUT
        ↓
linhas históricas movidas fisicamente
para gerenciamento de armazenamento / arquivamento
        ↓
vendas de negócio ainda podem permanecer válidas
```

A segunda operação representa gerenciamento físico dos dados.

Ela não constitui automaticamente uma exclusão de negócio.

Portanto, o Atlas Engineering não tenta converter o movimento físico de partições em semântica de DELETE de negócio em nível de linha.

A decisão V1 é:

> **Governar o *partition switching* em vez de desabilitá-lo preventivamente.**

### 6.14 Governança de SWITCH IN

A ingestão transacional normal de vendas não deve utilizar:

```text
ALTER TABLE ... SWITCH
```

como mecanismo padrão para inserir novas vendas operacionais nas tabelas transacionais habilitadas para CDC.

O fluxo normal de negócio é:

```text
transação da aplicação
        ↓
DML normal do SQL Server
        ↓
Transaction Log
        ↓
CDC
```

O uso de `SWITCH IN` para a ingestão normal de vendas poderia mover linhas para uma tabela habilitada para CDC sem produzir o histórico de CDC em nível de linha esperado pela estratégia de captura *downstream*.

Portanto:

```text
SWITCH IN
para ingestão normal de vendas
=
não planejado / não permitido pela estratégia
```

Se um requisito futuro propuser esse padrão, a estratégia de captura deverá ser revisada antes da implementação.

### 6.15 Governança de SWITCH OUT

`SWITCH OUT` poderá se tornar útil no futuro para arquivamento físico de dados históricos ou gerenciamento do ciclo de vida das partições.

Conceitualmente:

```text
TABELA TRANSACIONAL ATIVA
        ↓
partição histórica
        ↓
SWITCH OUT
        ↓
arquivo / estrutura alternativa de armazenamento
```

Uma operação física desse tipo não deve informar automaticamente à plataforma analítica:

```text
essas vendas deixaram de existir
```

O histórico de negócio pode continuar válido mesmo que a localização de armazenamento no OLTP seja alterada.

Portanto, o arquivamento futuro de partições deve preservar a distinção entre:

```text
LOCALIZAÇÃO FÍSICA DOS DADOS
```

e:

```text
EXISTÊNCIA DOS DADOS DE NEGÓCIO
```

Qualquer processo futuro de `SWITCH OUT` deve ser projetado em conjunto com a Plataforma de Engenharia de Dados para que a correção histórica *downstream* seja preservada.

### 6.16 Backfill Inicial

O CDC começa a capturar alterações a partir do limite de captura estabelecido.

Ele não reconstrói o histórico completo das alterações ocorridas antes da habilitação do CDC.

Isso cria duas populações de dados:

```text
DADOS PRÉ-CDC
linhas existentes na origem
        ↓
Backfill Inicial
        ↓
estado conhecido no momento da extração


ALTERAÇÕES PÓS-LIMITE
alterações futuras observáveis
        ↓
CDC
        ↓
captura orientada a alterações
```

A linha de base inicial do AtlasCommerce identificada antes da ativação do CDC continha:

```text
sales.Transaction
6306 linhas

sales.TransactionItem
13769 linhas
```

Essas linhas existentes não se tornam automaticamente eventos históricos do CDC apenas porque o CDC foi habilitado.

Isso foi observado independentemente para ambas as instâncias de captura: a origem continha linhas existentes, enquanto as Tabelas de Alterações do CDC recém-criadas inicialmente não continham linhas de alterações históricas.

Portanto:

> **A ativação do CDC não é um mecanismo de *backfill* histórico.**

### 6.17 Estratégia de Cutover do CDC

O *backfill* inicial e a ativação do CDC devem ser coordenados para evitar uma lacuna silenciosa de alterações.

O Atlas Engineering segue:

> **Proteja o futuro primeiro e, depois, carregue o passado.**

Conceitualmente:

```text
1. estabelecer o limite de captura do CDC
        ↓
2. alterações futuras tornam-se observáveis
        ↓
3. extrair o estado existente da origem
        ↓
4. alterações do CDC acumulam durante o backfill
        ↓
5. processar o backfill
        ↓
6. processar as alterações acumuladas do CDC
        ↓
7. reconciliar a sobreposição controlada
        ↓
8. continuar a operação normal
```

Essa abordagem pode produzir sobreposição.

Por exemplo, uma linha pode:

```text
existir no snapshot do backfill
        +
ser alterada após o limite do CDC
```

A plataforma poderá, portanto, observar:

```text
estado inicial conhecido
        +
alteração capturada posteriormente
```

Isso é esperado e deve ser reconciliado corretamente.

O risco alternativo é:

```text
carregar o passado primeiro
        ↓
alterações ocorrem
        ↓
habilitar a captura posteriormente
        ↓
lacuna não observada
```

O Atlas Engineering prefere:

```text
sobreposição controlada
```

a:

```text
lacuna silenciosa
```

porque a duplicação controlada pode ser tratada por meio de processamento *downstream* idempotente, enquanto alterações ausentes podem ser impossíveis de reconstruir.

A implementação exata dessa reconciliação ainda precisa ser testada.

### 6.18 Não Criar Histórico Pré-CDC Artificialmente

O *backfill* fornece um estado conhecido da origem.

Ele não fornece eventos que nunca foram capturados.

Suponha que uma transação preexistente seja encontrada durante o *backfill* como:

```text
TRN_TRNST_id = COMPLETED
```

A plataforma pode estabelecer:

```text
estado conhecido no momento da extração
=
COMPLETED
```

Ela não pode afirmar automaticamente que o CDC observou:

```text
PENDING
        ↓
CONFIRMED
        ↓
COMPLETED
```

Essas transições podem ser plausíveis.

Elas não constituem evidência.

Portanto:

```text
INITIAL_BACKFILL
→ estado conhecido da origem

CDC_STREAM
→ alterações observáveis após o limite
```

devem permanecer semanticamente distintos.

Metadados candidatos de ingestão poderão posteriormente representar essa distinção, por exemplo:

```text
ingestion_mode = INITIAL_BACKFILL

ingestion_mode = CDC_STREAM
```

A nomenclatura final permanece sujeita ao projeto de implementação.

### 6.19 Estratégia de CDC e Futura Integração com Debezium

A arquitetura V1 mais ampla posiciona o Debezium *downstream* do SQL Server Native CDC:

```text
AtlasCommerce
SQL Server
        ↓
SQL Server Native CDC
        ↓
Debezium
        ↓
Kafka
```

No modelo do Atlas Engineering:

> **O Debezium não é tratado como um leitor direto do arquivo `.ldf` do SQL Server.**

O SQL Server Native CDC é o mecanismo de captura de alterações no lado da origem.

Posteriormente, o Debezium consumirá as informações de alteração de acordo com o comportamento de seu *connector* para SQL Server e exporá eventos ao Kafka.

Essa distinção é importante porque diferentes camadas possuem semânticas diferentes:

```text
semântica de transação do SQL Server
        ↓
representação do SQL Server CDC
        ↓
representação de eventos do Debezium
        ↓
representação de tópico / partição do Kafka
        ↓
interpretação do consumidor
```

A evidência em uma camada não deve ser automaticamente projetada sobre a camada seguinte.

Por exemplo:

```text
mesmo __$start_lsn
entre tabelas do SQL Server CDC
```

não comprova:

```text
entrega atômica entre múltiplos tópicos do Kafka
```

As etapas do Debezium e do Kafka exigem implementação e testes independentes.

### 6.20 Limite Atual da Validação

A estratégia de CDC deixou de ser puramente teórica.

A implementação do SQL Server CDC no lado da origem foi testada até:

```text
M01.08
Linha de Base Pré-CDC

M01.09
Habilitação do CDC no Banco de Dados

M01.10
Habilitação do CDC — Transaction

M01.10B
Retenção do CDC

M01.11
Anatomia da Change Table

M01.12
INSERT Controlado

M01.13
UPDATE Controlado

M01.14
Múltiplos Comandos UPDATE

M01.15
DELETE Controlado

M01.16A
Validação Pré-Habilitação de TransactionItem

M01.16B
Habilitação do CDC — TransactionItem

M01.17A
Preparação para Teste Entre Tabelas

M01.17B
Transação de INSERT Entre Tabelas

M01.18
UPDATE Coordenado Entre Tabelas

M01.19
DELETE no Pai + ON DELETE CASCADE
```

Esses testes fornecem evidências de:

```text
habilitação do CDC no banco de dados
habilitação do CDC nas tabelas
criação das Change Tables
captura assíncrona
captura de INSERT
UPDATE BEFORE / AFTER
captura de DELETE
múltiplos comandos em uma única transação
correlação transacional entre tabelas
captura de DELETE em cascata
comportamento dos metadados do CDC observado em laboratório
ausência de backfill histórico automático
retenção configurável
conhecimento da restrição de partition SWITCH
```

Eles ainda não fornecem evidências de:

```text
consumo incremental final do CDC
estratégia de checkpoint
reinicialização do consumidor
replay do consumidor
comportamento do Debezium
representação de transações pelo Debezium
entrega pelo Kafka
ordenação entre tópicos
persistência na Bronze
idempotência de ponta a ponta
recuperação de ponta a ponta
catch-up do backlog
desempenho em escala de produção
SLO de ponta a ponta observado
```

A distinção é intencional:

```text
CDC NO LADO DA ORIGEM
parcialmente implementado e testado
        ↓
CONSUMO DO CDC
próxima etapa de implementação
        ↓
DEBEZIUM
validação futura
        ↓
KAFKA
validação futura
        ↓
BRONZE
validação futura
        ↓
PONTA A PONTA
validação futura
```

### 6.21 Resumo da Estratégia de CDC

A estratégia de CDC V1 pode ser resumida como:

```text
ORIGENS APLICÁVEIS
sales.Transaction
sales.TransactionItem

POR QUE CDC?
Dados transacionais com alto volume de alterações
+
captura orientada a alterações
+
visibilidade de DELETE físico
+
contexto transacional no lado da origem
+
proteção do OLTP

FONTE DA CAPTURA
Transaction Log do SQL Server
por meio do SQL Server Native CDC

MODELO DE CAPTURA
assíncrono

JANELA DE RECUPERAÇÃO
15 dias

HISTÓRICO PERMANENTE
não é responsabilidade do CDC

HISTÓRICO INICIAL
Backfill Inicial

ALTERAÇÕES FUTURAS
CDC

PRINCÍPIO DE CUTOVER
Proteja o futuro primeiro
e, depois, carregue o passado

PRINCÍPIO DE LIMITE
Prefira sobreposição controlada
a lacunas silenciosas

PARTITION SWITCH
permitido, mas governado

SWITCH IN
não utilizado na ingestão normal de vendas

SWITCH OUT
possibilidade futura de arquivamento físico controlado

EVIDÊNCIA ATUAL
comportamento do SQL Server CDC no lado da origem
validado até M01.19

AINDA NÃO COMPROVADO
consumo do CDC
Debezium
Kafka
Bronze
semântica de ponta a ponta
```

O princípio arquitetural que rege essa estratégia é:

> **O CDC é o mecanismo operacional de captura de alterações na origem para dados transacionais de vendas com alto volume de alterações; ele não é o armazenamento histórico permanente, e as evidências do CDC no lado da origem não devem ser estendidas a sistemas *downstream* que ainda não tenham sido testados.**

---

## 7. Estratégia de Timestamp Incremental

A captura por *Timestamp* Incremental é a hipótese de captura V1 selecionada para tabelas de origem que sofrem alterações ocasionais e expõem uma *watermark* candidata baseada em *timestamp*.

As origens inicialmente atribuídas a essa estratégia são:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

Essas tabelas dão suporte ao domínio de Sales Analytics, fornecendo contexto descritivo e estrutural para os dados transacionais.

O modelo de captura pretendido é:

```text
checkpoint anterior
        ↓
consultar a origem
        ↓
identificar linhas alteradas
após o limite anterior
        ↓
obter as linhas alteradas
        ↓
avançar o checkpoint
```

Uma forma simplificada poderia ser:

```sql
SELECT ...
FROM SourceTable
WHERE updated_at > @last_watermark;
```

Entretanto, essa aparente simplicidade pode ser enganosa.

Uma estratégia baseada em *timestamp* só é confiável quando a *watermark* selecionada se comporta de maneira que garanta que todas as alterações necessárias possam ser identificadas.

Portanto:

> **A presença de uma coluna de *timestamp* não comprova que a captura por *Timestamp* Incremental seja segura.**

Para o Atlas Engineering, o mecanismo permanece como uma hipótese de implementação V1 até que o comportamento da *watermark* seja explicitamente validado.

### 7.1 Tabelas Aplicáveis

A estratégia V1 de *Timestamp* Incremental aplica-se atualmente a:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

Essas tabelas estão classificadas como:

```text
B — Alterações Ocasionais
```

Seu papel é diferente daquele das origens transacionais com alto volume de alterações:

```text
sales.Transaction
sales.TransactionItem
```

Não se espera que elas gerem o mesmo volume ou frequência de alterações operacionais.

Conceitualmente:

```text
NÚCLEO TRANSACIONAL
sales.Transaction
sales.TransactionItem
        ↓
CDC


DADOS DESCRITIVOS / MESTRES
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
Timestamp Incremental
        ↓
sujeito à validação da watermark
```

A seleção baseia-se na premissa de que uma *watermark* confiável baseada em *timestamp* pode fornecer detecção suficiente das alterações com menor complexidade operacional do que o CDC.

Essa premissa ainda precisa ser testada.

### 7.2 Requisitos da Watermark

Uma *watermark* é um valor utilizado para identificar o limite do progresso da captura.

Conceitualmente:

```text
HISTÓRICO DA ORIGEM
──────────────────────────────────────>

já adquirido              ainda não adquirido
───────────────┬───────────────────────
               │
           WATERMARK
```

Uma *watermark* baseada em *timestamp* procura responder:

```text
Quais linhas indicam que
foram alteradas após a
última extração bem-sucedida?
```

Por exemplo:

```text
last_watermark
=
2026-08-29 10:00:00
```

poderia resultar em:

```sql
WHERE updated_at > '2026-08-29T10:00:00'
```

Isso só funciona com segurança se a semântica da origem atender às premissas por trás desse predicado.

Uma *watermark* confiável deve, portanto, ser avaliada em várias dimensões.

#### 7.2.1 Alterações Relevantes Devem Atualizar a Watermark

Toda alteração relevante para a plataforma *downstream* deve modificar a *watermark* selecionada.

Se a origem permitir:

```text
UPDATE em coluna de negócio
        ↓
updated_at permanece inalterado
```

então:

```text
WHERE updated_at > last_watermark
```

pode deixar de identificar silenciosamente a alteração.

A relação necessária é:

```text
ALTERAÇÃO RELEVANTE NA ORIGEM
        ↓
WATERMARK AVANÇA
```

Se não for possível confiar nessa relação, o *timestamp* não constitui um limite incremental confiável.

#### 7.2.2 A Precisão da Watermark Deve Ser Suficiente

A precisão do *timestamp* é importante porque várias linhas podem receber o mesmo valor.

Por exemplo:

```text
Linha A → 10:00:00
Linha B → 10:00:00
Linha C → 10:00:00
```

Se o processamento for interrompido depois que apenas:

```text
Linha A
```

tiver sido persistida com segurança, e o *checkpoint* for incorretamente avançado para:

```text
10:00:00
```

então um predicado posterior:

```sql
WHERE updated_at > '10:00:00'
```

poderá excluir:

```text
Linha B
Linha C
```

O problema não é que valores de *timestamp* duplicados sejam inerentemente inválidos.

O problema é que o limite de extração deve considerá-los.

Portanto:

> **A igualdade de *timestamps* no limite é um problema de correção que deve ser explicitamente tratado no projeto.**

#### 7.2.3 Várias Linhas Podem Compartilhar a Mesma Watermark

Mesmo *timestamps* de alta precisão não garantem unicidade.

Portanto:

```text
timestamp
≠
posição única da linha
```

Um *timestamp* pode identificar um grupo de linhas em vez de um único registro determinístico.

Um projeto incremental robusto pode, portanto, precisar de um elemento adicional de desempate.

Conceitualmente:

```text
(timestamp, chave determinística)
```

em vez de:

```text
apenas timestamp
```

Por exemplo:

```text
2026-08-29 10:00:00, ProductId 100
2026-08-29 10:00:00, ProductId 101
2026-08-29 10:00:00, ProductId 102
```

poderia, teoricamente, ser ordenado por:

```text
timestamp
+
chave primária
```

Entretanto, o Atlas Engineering ainda não selecionou nem validou a implementação final desse limite.

Isso permanece como uma questão de implementação.

#### 7.2.4 Os Valores da Watermark Não Devem Retroceder Inesperadamente

O modelo incremental geralmente pressupõe progresso.

Conceitualmente:

```text
T1
 ↓
T2
 ↓
T3
```

Uma origem que posteriormente possa produzir:

```text
T0
```

para uma nova alteração relevante pode comprometer um *checkpoint* simples que avance apenas para frente.

Possíveis causas podem incluir comportamento da aplicação, *timestamps* fornecidos manualmente, lógica de sincronização ou correções no lado da origem.

A estratégia deve, portanto, determinar se a *watermark* candidata é:

```text
controlada pelo sistema
controlada pela aplicação
controlada pelo usuário
derivada
```

porque essa semântica afeta sua confiabilidade.

Um *timestamp* gerado automaticamente por uma lógica confiável da origem pode ser mais adequado do que um valor fornecido livremente pelos chamadores da aplicação.

Mas isso deve ser estabelecido por evidências de implementação.

### 7.3 Ordem de Commit e Ordem de Timestamp

A ordem dos *timestamps* e a ordem de confirmação das transações não representam necessariamente o mesmo conceito.

Considere:

```text
Transação A
define updated_at = 10:00:00
        │
        │ permanece aberta
        ▼

Transação B
define updated_at = 10:00:01
        │
        ▼
COMMIT

        ↓

consulta de captura é executada
        ↓
observa B
        ↓
checkpoint avança

        ↓

Transação A finalmente executa COMMIT
```

Dependendo do isolamento da origem e da semântica de geração do *timestamp*, uma linha confirmada posteriormente poderia carregar um *timestamp* anterior.

Isso cria uma condição potencial:

```text
confirmação posterior
+
watermark anterior
```

Uma consulta ingênua que avance apenas para frente poderia deixar de capturar essa linha após o avanço do *checkpoint*.

Isso não comprova que as tabelas atuais do AtlasCommerce apresentem esse comportamento.

Apenas identifica uma condição que deve ser considerada durante a validação do modelo de *watermark*.

Os testes de implementação devem determinar quais garantias realmente existem na origem.

### 7.4 Semântica de Limite com `>` Versus `>=`

Uma decisão comum na captura incremental é determinar se a próxima extração utilizará:

```sql
WHERE updated_at > @last_watermark
```

ou:

```sql
WHERE updated_at >= @last_watermark
```

A primeira opção reduz a repetição de linhas no limite, mas pode criar risco quando várias linhas compartilham o *timestamp* do *checkpoint*.

A segunda relê deliberadamente o limite.

Conceitualmente:

```text
>
→ menor sobreposição
→ maior risco se o limite estiver incompleto

>=
→ sobreposição controlada
→ exige deduplicação / idempotência
```

Isso reflete um princípio mais amplo do Atlas Engineering:

> **Prefira sobreposição controlada a lacunas silenciosas.**

Entretanto, utilizar `>=` isoladamente não resolve todo o problema.

Se o mesmo *timestamp* ocorrer em um grande número de linhas, a implementação ainda precisará de um modelo confiável de *checkpoint* e reconciliação.

O predicado final deve, portanto, ser testado em vez de ser escolhido apenas com base na teoria.

### 7.5 Watermark e Checkpoint São Relacionados, mas Diferentes

Uma *watermark* é um valor da origem utilizado para identificar o progresso.

Um *checkpoint* é o estado persistido da plataforma que registra até onde o processamento foi concluído com segurança.

Conceitualmente:

```text
WATERMARK DA ORIGEM
updated_at

        ↓ utilizada pelo

CHECKPOINT DA PLATAFORMA
último limite processado com segurança
```

Eles são relacionados, mas não são idênticos.

Por exemplo:

```text
timestamp máximo observado
```

não deve se tornar automaticamente:

```text
checkpoint
```

se as linhas correspondentes ainda não tiverem sido persistidas com segurança *downstream*.

A sequência correta segue, conceitualmente:

```text
ler linhas candidatas
        ↓
processar linhas
        ↓
persistir com segurança
        ↓
somente então
avançar o checkpoint
```

Caso contrário:

```text
checkpoint avança
        ↓
processamento falha
        ↓
algumas linhas nunca são persistidas
        ↓
próxima extração começa depois delas
```

o que pode produzir perda silenciosa.

Portanto:

> **Um *checkpoint* representa progresso concluído com segurança, e não apenas progresso observado na origem.**

A implementação exata do *checkpoint* para *Timestamp* Incremental permanece pendente.

### 7.6 Fundamentação

*Timestamp* Incremental foi selecionado como hipótese V1 para as origens da Categoria B porque pode fornecer um equilíbrio eficaz entre:

```text
detecção de alterações
+
simplicidade
+
baixa sobrecarga operacional
+
proteção do OLTP
```

para origens que sofrem alterações ocasionais.

Em comparação com o CDC, *Timestamp* Incremental pode evitar objetos adicionais de CDC no lado da origem e preocupações operacionais associadas quando a fidelidade em nível de alteração não é necessária.

Em comparação com o *Full Refresh* Controlado, pode reduzir a transferência e o processamento repetidos de linhas inalteradas.

Em comparação com *Snapshot* + *Diff*, pode evitar a comparação completa de estados quando a própria origem expõe metadados confiáveis de alteração.

Conceitualmente:

```text
watermark confiável disponível
        +
alterações são ocasionais
        +
evento de DELETE físico não é necessário
        +
estado incremental é suficiente
        ↓
Timestamp Incremental
pode ser apropriado
```

A expressão:

```text
pode ser
```

é intencional.

O mecanismo permanece condicionado à validação.

### 7.7 Limitação de DELETE

A captura incremental baseada em *timestamp* não detecta inerentemente operações de DELETE físico.

Considere:

```text
Product 100 existe
updated_at = T1

        ↓

DELETE Product 100

        ↓

Product 100 deixa de existir
```

Uma consulta posterior:

```sql
WHERE updated_at > @last_watermark
```

não pode retornar:

```text
Product 100
```

porque a linha não está mais presente.

Portanto:

```text
INSERT
→ potencialmente detectável

UPDATE
→ potencialmente detectável

DELETE
→ não inerentemente detectável
```

Essa limitação deve ser comparada com o requisito de negócio de cada origem.

A estratégia deve perguntar:

```text
O downstream precisa saber
que a linha foi excluída?

A ausência atual é suficiente?

A exclusão deve ser representada
como um evento histórico?
```

Essas questões ainda não foram totalmente validadas para as origens da Categoria B.

Até que sejam, *Timestamp* Incremental permanece uma hipótese, e não uma implementação final comprovada.

### 7.8 Consideração sobre DELETE lógico

Uma origem pode, em alguns casos, representar uma exclusão de forma lógica em vez de física.

Por exemplo:

```text
is_active = 1
        ↓
is_active = 0
```

ou:

```text
deleted_at = NULL
        ↓
deleted_at = timestamp
```

Se essa alteração também atualizar a *watermark* confiável, *Timestamp* Incremental poderá potencialmente observar a exclusão lógica como um UPDATE.

Conceitualmente:

```text
DELETE lógico linha permanece
        +
watermark é alterada
        ↓
extração incremental pode observá-la
```

Isso é diferente de:

```text
DELETE físico linha desaparece
        ↓
consulta por timestamp não consegue recuperá-la
```

A Estratégia de Captura atual não presume que as origens da Categoria B do AtlasCommerce utilizem semântica de DELETE lógico.

Esse comportamento deve ser determinado a partir da implementação real da origem.

### 7.9 Timestamp de Criação Geralmente Não É Suficiente para Capturar UPDATE

Uma origem pode conter:

```text
created_at
```

sem possuir um:

```text
updated_at
```

confiável.

Um *timestamp* de criação pode permitir:

```text
detecção de novas linhas
```

mas não necessariamente:

```text
detecção de UPDATEs posteriores
```

Por exemplo:

```text
linha criada
created_at = T1

        ↓

linha atualizada posteriormente
created_at permanece T1
```

Nesse caso:

```sql
WHERE created_at > @last_watermark
```

não recuperará a linha atualizada.

Portanto:

```text
watermark de criação
≠
watermark de alteração
```

a menos que o comportamento da origem garanta explicitamente o contrário.

### 7.10 Timestamps Gerenciados pela Aplicação Exigem Cuidado Adicional

Se a própria aplicação fornecer o valor do *timestamp*, o mecanismo de captura herdará premissas sobre a correção da aplicação.

Por exemplo:

```text
UPDATE da aplicação
        ↓
deve se lembrar de definir updated_at
```

Se um fluxo de código deixar de fazer isso:

```text
linha é alterada
        ↓
timestamp não é alterado
        ↓
captura incremental não identifica a linha
```

Um mecanismo gerado pela própria origem pode reduzir essa dependência, mas mesmo *timestamps* gerados na origem ainda precisam ser validados quanto à semântica pretendida.

Possíveis modelos de responsabilidade pelo *timestamp* incluem:

```text
gerenciado pela aplicação
trigger do banco de dados
convenção de stored procedure
lógica derivada da origem
```

Um `DEFAULT` do banco de dados pode inicializar um *timestamp* durante um `INSERT`, mas, por si só, não mantém uma *watermark* de alteração para operações `UPDATE` posteriores.

O modelo exato utilizado pelas tabelas candidatas do AtlasCommerce deve ser verificado antes da aprovação final da implementação.

### 7.11 O Predicado de Extração Deve Permitir Busca Eficiente Sempre que Possível

A captura incremental protege a origem OLTP somente se a própria consulta de extração for operacionalmente adequada.

Um predicado como:

```sql
WHERE updated_at > @last_watermark
```

pode potencialmente permitir acesso eficiente se houver um índice apropriado e uma distribuição de dados adequada.

Entretanto, transformações aplicadas à coluna da origem podem tornar o acesso menos eficiente.

Por exemplo:

```sql
WHERE CAST(updated_at AS date) > @last_date
```

pode impedir que o otimizador utilize a coluna da origem com a mesma eficiência de um predicado direto por intervalo.

Conceitualmente:

```text
bom projeto incremental
        =
limite correto
        +
acesso eficiente à origem
```

Correção sem eficiência operacional ainda pode gerar pressão sobre a origem.

Eficiência sem correção pode causar perda silenciosa de dados.

Ambas são importantes.

O comportamento exato de indexação e dos planos de execução das tabelas candidatas do AtlasCommerce deve ser validado durante a implementação.

### 7.12 Frequência da Extração Incremental

*Timestamp* Incremental geralmente é executado periodicamente.

Conceitualmente:

```text
T0
│ extração
│
T1
│ extração
│
T2
│ extração
│
T3
```

O intervalo afeta:

- latência dos dados;
- frequência das consultas à origem;
- quantidade de dados por extração;
- comportamento de recuperação;
- granularidade do *checkpoint*.

Um intervalo menor pode melhorar a latência dos dados, mas executará consultas à origem com maior frequência.

Um intervalo maior reduz a frequência das consultas, mas aumenta a quantidade de alterações acumuladas entre execuções.

A frequência correta deve, portanto, equilibrar:

```text
REQUISITO DE LATÊNCIA
        ↕
CARGA DE TRABALHO NA ORIGEM
```

Os agendamentos finais para as tabelas da Categoria B ainda não foram implementados nem validados.

### 7.13 Falha na Extração e Segurança do Checkpoint

Suponha que uma extração incremental identifique:

```text
100 linhas
```

entre:

```text
T1
e
T2
```

Se o processamento falhar depois que apenas 70 linhas tiverem sido persistidas com segurança, a plataforma não deverá registrar:

```text
checkpoint = T2
```

a menos que possua outro mecanismo que garanta a recuperação das 30 linhas restantes.

Conceitualmente:

```text
100 linhas identificadas
        ↓
70 persistidas com segurança
        ↓
FALHA
```

Comportamento inseguro:

```text
checkpoint = T2
        ↓
30 restantes ignoradas posteriormente
```

Princípio mais seguro:

```text
checkpoint avança somente
após a conclusão durável e bem-sucedida
do limite de extração governado
```

Essa é outra expressão da regra mais ampla do Atlas Engineering:

> **A durabilidade precede a confirmação do progresso.**

A implementação detalhada dependerá do futuro componente de ingestão e ainda não foi comprovada.

### 7.14 Visibilidade Tardia Deve Ser Investigada

Uma consulta incremental enxerga o que está visível de acordo com o comportamento transacional e de isolamento da origem no momento da consulta.

Uma linha que não esteja visível durante uma extração pode se tornar visível posteriormente.

Se essa linha carregar uma *watermark* anterior ao *checkpoint* já avançado, um modelo baseado exclusivamente em *timestamp* e que avance apenas para frente poderá deixar de capturá-la.

Conceitualmente:

```text
Extração 1
intervalo da watermark até T2
        ↓
linha não está visível

checkpoint avança para T2
        ↓

linha torna-se visível posteriormente
mas timestamp = T1
        ↓

Extração 2
WHERE timestamp > T2
        ↓
linha não capturada
```

Não se deve presumir que esse cenário ocorra no AtlasCommerce.

Ele representa um dos comportamentos que a validação da *watermark* deve:

```text
comprovar ser impossível
```

ou:

```text
tratar no projeto
```

antes que o mecanismo seja considerado confiável.

### 7.15 Janelas de Releitura como Possível Mitigação

Um possível padrão incremental consiste em reler deliberadamente um intervalo recente limitado.

Conceitualmente:

```text
checkpoint = T2

próxima extração começa em:

T2 - intervalo de releitura
```

Isso cria:

```text
sobreposição controlada
```

que pode ajudar a proteger contra determinadas formas de visibilidade tardia ou comportamento do limite de *timestamp*.

Entretanto:

```text
releitura
```

também introduz:

```text
reprocessamento
+
requisitos de deduplicação
```

e não resolve automaticamente todos os possíveis defeitos da *watermark*.

O Atlas Engineering ainda não selecionou uma estratégia de releitura para as tabelas da Categoria B.

Ela permanece como uma técnica candidata de implementação a ser avaliada experimentalmente.

### 7.16 Timestamp Incremental É uma Descoberta de Alterações Orientada a Estado

*Timestamp* Incremental não deve ser confundido com um verdadeiro *log* de eventos.

Suponha que uma linha seja alterada várias vezes entre extrações:

```text
T1
preço do Product = 100

T2
preço do Product = 110

T3
preço do Product = 120

T4
extração incremental
```

Se a origem armazenar apenas a linha atual, a extração poderá observar:

```text
preço do Product = 120
```

Ela poderá não recuperar o estado intermediário:

```text
110
```

Portanto:

```text
Timestamp Incremental
→ quais linhas atualmente indicam que foram alteradas?

CDC
→ quais alterações capturadas ocorreram?
```

Essa é uma das diferenças conceituais mais importantes entre os mecanismos.

*Timestamp* Incremental é apropriado apenas quando esse nível de fidelidade atende ao requisito.

### 7.17 Alterações Intermediárias Podem Ser Perdidas

O exemplo anterior leva a uma limitação importante.

Considere:

```text
10:00
preço 100 → 110

10:02
preço 110 → 120

10:05
extração incremental
```

A linha da origem no momento da extração pode conter:

```text
price = 120
updated_at = 10:02
```

A extração pode identificar que:

```text
essa linha foi alterada
```

e que:

```text
seu estado atual é 120
```

Ela não consegue necessariamente reconstruir:

```text
100 → 110 → 120
```

Portanto:

> ***Timestamp* Incremental captura o estado atual alterado, e não necessariamente cada evento intermediário de alteração.**

Essa limitação é aceitável apenas quando o requisito analítico não exige o histórico completo em nível de evento.

### 7.18 Timestamp Incremental e Backfill Histórico

Assim como o CDC, *Timestamp* Incremental ainda exige uma estratégia de estado inicial.

Quando a captura começa, as linhas já existentes na origem precisam ser adquiridas.

Conceitualmente:

```text
ORIGEM EXISTENTE
        ↓
Backfill Inicial
        ↓
estado atual conhecido

depois

ALTERAÇÕES CONTÍNUAS
        ↓
Timestamp Incremental
```

O limite de captura deve ser controlado para que alterações ocorridas durante o *backfill* não sejam silenciosamente perdidas.

Aplica-se o mesmo princípio geral do Atlas Engineering:

> **Proteja o futuro primeiro e, depois, carregue o passado.**

Entretanto, a implementação exata é diferente daquela do CDC, pois o progresso incremental é definido por uma *watermark* baseada em *timestamp*, e não por um intervalo de CDC baseado em LSN.

O procedimento final de *cutover* deve, portanto, ser testado especificamente para esse mecanismo.

### 7.19 Testes Candidatos de Validação

Antes que *Timestamp* Incremental seja considerado operacionalmente validado para uma origem, testes controlados devem examinar pelo menos:

```text
01. INSERT
    A watermark candidata expõe uma linha recém-criada?

02. UPDATE
    Todo UPDATE relevante faz a watermark avançar?

03. MÚLTIPLOS UPDATES
    O que fica visível se a mesma linha for alterada repetidamente entre as extrações?

04. MESMO TIMESTAMP
    Várias linhas podem compartilhar o mesmo valor de watermark?

05. PRECISÃO DO TIMESTAMP
    Qual precisão é realmente armazenada?

06. LIMITE
    O que acontece quando várias linhas existem exatamente no valor do checkpoint?

07. DELETE FÍSICO
    A exclusão pode ser detectada? Caso contrário, isso é aceitável?

08. DELETE LÓGICO
    Se houver suporte, ele faz a watermark avançar?

09. VISIBILIDADE DA TRANSAÇÃO
    Uma linha que se torna visível posteriormente pode carregar uma watermark anterior ao checkpoint?

10. FALHA DO CHECKPOINT
    O que acontece se a extração falhar antes que o lote esteja durável?

11. REINICIALIZAÇÃO
    O processamento pode ser retomado com segurança?

12. SOBREPOSIÇÃO CONTROLADA
    As linhas do limite podem ser relidas com segurança?

13. DESEMPENHO NA ORIGEM
    O predicado de extração utiliza um plano de execução aceitável?

14. CUTOVER DO BACKFILL
    O estado inicial e as alterações contínuas podem ser reconciliados sem lacunas?

15. RECONCILIAÇÃO
    O estado da origem e o estado downstream podem ser comparados para detectar divergências?
```

Esses testes devem ser executados separadamente para cada origem cujo comportamento possa ser diferente.

Uma *watermark* validada com sucesso em uma tabela não comprova automaticamente a mesma semântica para outra.

### 7.20 Estado Atual da Validação

O estado atual da V1 é:

```text
catalog.Product
→ Timestamp Incremental selecionado como hipótese
→ validação da watermark pendente

catalog.ProductVariant
→ Timestamp Incremental selecionado como hipótese
→ validação da watermark pendente

catalog.Brand
→ Timestamp Incremental selecionado como hipótese
→ validação da watermark pendente

catalog.Category
→ Timestamp Incremental selecionado como hipótese
→ validação da watermark pendente
```

Portanto:

```text
SELECIONADO
        ≠
VALIDADO
```

Este documento não afirma, neste estágio, que existam evidências detalhadas de implementação de *Timestamp* Incremental.

Quando o módulo de implementação correspondente for iniciado, a estratégia deverá ser testada em relação ao comportamento real da origem.

### 7.21 Resumo da Fundamentação

A hipótese V1 pode ser resumida como:

```text
ORIGENS APLICÁVEIS
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category

CLASSIFICAÇÃO
B — Alterações Ocasionais

HIPÓTESE SELECIONADA
Timestamp Incremental

POR QUÊ?
Alterações ocasionais
+
watermark potencialmente confiável
+
menor complexidade que CDC
+
evitar Full Refresh desnecessário
+
proteger a origem OLTP

DEPENDÊNCIA PRINCIPAL
Comportamento confiável da watermark

LIMITAÇÃO PRINCIPAL
DELETE físico não detectado inerentemente

FIDELIDADE DAS ALTERAÇÕES
Estado atual alterado
não necessariamente todos os eventos intermediários

DADOS INICIAIS
Exigem backfill

LIMITE
Deve ser explicitamente projetado

CHECKPOINT
Deve representar progresso concluído com segurança

ESTADO ATUAL
Apenas hipótese arquitetural

VALIDAÇÃO DA IMPLEMENTAÇÃO
Pendente
```

O princípio que rege essa estratégia é:

> ***Timestamp* Incremental é apropriado apenas quando a origem consegue informar de forma confiável à plataforma quais linhas atuais foram alteradas após um limite conhecido.**

E a regra de validação mais importante permanece:

> **Uma coluna de *timestamp* é uma *watermark* candidata, e não uma comprovação de uma estratégia incremental confiável.**

---

## 8. Estratégia de Snapshot + Diff

*Snapshot* + *Diff* é o mecanismo de captura V1 selecionado para origens com baixo volume de alterações que não expõem uma *watermark* confiável capaz de identificar diretamente as alterações incrementais.

A origem inicialmente atribuída a essa estratégia é:

```text
catalog.ProductCategory
```

Essa tabela representa o relacionamento entre produtos e categorias.

Sua estrutura atualmente identificada contém:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

sem colunas de *timestamp* que possam servir como uma *watermark* incremental confiável.

Para essa origem, o problema de captura, portanto, não é:

```text
Quais linhas indicam que foram alteradas?
```

Em vez disso, a estratégia pergunta:

```text
O que é diferente entre
o estado anteriormente aceito
e o estado atual da origem?
```

O mecanismo V1 é:

```text
Snapshot + Diff
```

Conceitualmente:

```text
SNAPSHOT ANTERIOR
        │
        │ comparar
        ▼
SNAPSHOT ATUAL
        │
        ▼
DIFF
        │
        ├── ADICIONADO
        ├── REMOVIDO
        └── INALTERADO
```

Essa abordagem deriva a alteração a partir da comparação de estados.

Ela não depende de a origem expor um *timestamp* ou um evento explícito de alteração.

### 8.1 Tabelas Aplicáveis

A estratégia V1 de *Snapshot* + *Diff* aplica-se atualmente a:

```text
catalog.ProductCategory
```

Essa tabela está classificada como:

```text
D — Baixo Volume de Alterações / Sem Watermark
```

Seu papel é representar o relacionamento entre:

```text
catalog.Product
        ↕
catalog.Category
```

Conceitualmente:

```text
Product
  │
  │ pode pertencer a
  ▼
uma ou mais Categories
```

O relacionamento em si é analiticamente importante porque a classificação dos produtos afeta a forma como as vendas poderão posteriormente ser agrupadas e analisadas.

As colunas de origem atualmente identificadas são:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

Atualmente, a tabela não expõe colunas de *timestamp* que permitiriam uma estratégia direta como:

```sql
WHERE updated_at > @last_watermark;
```

Portanto, *Timestamp* Incremental não é o mecanismo V1 selecionado para essa origem.

### 8.2 Fundamentação

*Snapshot* + *Diff* foi selecionado porque fornece uma maneira de detectar alterações nos relacionamentos sem exigir que a origem exponha metadados explícitos de alteração.

A decisão combina:

```text
BAIXO VOLUME DE ALTERAÇÕES
        +
TABELA DE RELACIONAMENTO
        +
SEM WATERMARK CONFIÁVEL
        +
ESTADOS ATUAL E ANTERIOR
PODEM SER COMPARADOS
        ↓
Snapshot + Diff
```

A estratégia é particularmente adequada quando:

- o conjunto de dados é operacionalmente viável de ser lido como um *snapshot* completo;
- as alterações são relativamente pouco frequentes;
- não existe uma *watermark* incremental confiável;
- adições e remoções precisam ser detectáveis;
- manter CDC para a origem introduziria complexidade desnecessária para o requisito atual.

O mecanismo, portanto, deriva a alteração em vez de recebê-la diretamente.

Essa distinção é fundamental:

```text
CDC
→ infraestrutura de captura da origem expõe a alteração

Timestamp Incremental
→ linha da origem indica que foi alterada

Snapshot + Diff
→ plataforma deriva a alteração comparando estados
```

### 8.3 Detecção de Alterações

O modelo básico compara:

```text
ESTADO CONHECIDO ANTERIOR
```

com:

```text
ESTADO ATUAL DA ORIGEM
```

Para uma tabela de relacionamento, cada relacionamento pode ser representado por seu par de chaves.

Por exemplo:

```text
(PRDCT_PRD_id, PRDCT_CTG_id)
```

Suponha que o *snapshot* anterior contenha:

```text
Product 100 → Category 10
Product 100 → Category 20
Product 200 → Category 10
```

e o *snapshot* atual da origem contenha:

```text
Product 100 → Category 20
Product 100 → Category 30
Product 200 → Category 10
```

A comparação resulta em:

```text
REMOVIDO
Product 100 → Category 10

ADICIONADO
Product 100 → Category 30

INALTERADO
Product 100 → Category 20
Product 200 → Category 10
```

O ponto importante é que a origem não precisou expor:

```text
evento DELETE
```

para:

```text
Product 100 → Category 10
```

A plataforma inferiu a remoção porque:

```text
relacionamento existia anteriormente
        +
relacionamento não existe atualmente
        ↓
REMOVIDO
```

Da mesma forma:

```text
relacionamento não existia anteriormente
        +
relacionamento existe atualmente
        ↓
ADICIONADO
```

### 8.4 Modelo Mental Baseado em Conjuntos

*Snapshot* + *Diff* é naturalmente modelado por meio de operações de conjuntos.

Considere:

```text
P = snapshot anterior
C = snapshot atual
```

Então:

```text
ADICIONADO
=
C - P
```

```text
REMOVIDO
=
P - C
```

```text
INALTERADO
=
P ∩ C
```

Conceitualmente:

```text
ANTERIOR                          ATUAL

A                                B
B                                C
C                                D

        ↓ comparação ↓

ADICIONADO
D

REMOVIDO
A

INALTERADO
B
C
```

Para `catalog.ProductCategory`, o elemento do conjunto é a chave do relacionamento:

```text
(PRDCT_PRD_id, PRDCT_CTG_id)
```

Isso torna o mecanismo especialmente intuitivo para tabelas de relacionamento muitos-para-muitos.

### 8.5 Snapshot É Estado, Não Histórico de Eventos

Um *snapshot* representa o estado da origem em determinado momento.

Ele não revela automaticamente todas as operações intermediárias que ocorreram entre dois *snapshots*.

Considere:

```text
Snapshot T1

Product 100 → Category 10
```

Entre os *snapshots*:

```text
T2
relacionamento removido

T3
relacionamento adicionado novamente
```

Então:

```text
Snapshot T4

Product 100 → Category 10
```

A comparação entre T1 e T4 resulta em:

```text
INALTERADO
```

porque os estados finais são idênticos.

A sequência intermediária:

```text
REMOVER
        ↓
ADICIONAR
```

não pode ser recuperada apenas a partir desses dois *snapshots*.

Portanto:

> ***Snapshot* + *Diff* identifica diferenças líquidas de estado entre observações, e não todos os eventos intermediários da origem.**

Essa é uma limitação fundamental do mecanismo.

Ela é aceitável somente quando esse nível de fidelidade atende ao requisito analítico.

### 8.6 A Frequência dos Snapshots Determina a Visibilidade

Como a alteração é derivada entre observações, a frequência dos *snapshots* determina quanto do comportamento intermediário pode permanecer invisível.

Conceitualmente:

```text
Snapshot 1
    │
    │ origem pode mudar aqui
    │
    │ origem pode mudar novamente
    │
Snapshot 2
```

A plataforma consegue determinar:

```text
diferença entre Snapshot 1
e Snapshot 2
```

mas não necessariamente:

```text
todas as operações entre eles
```

Um intervalo menor entre *snapshots* fornece observações de estado mais frequentes.

Um intervalo maior reduz a frequência de leitura da origem, mas aumenta o período durante o qual alterações intermediárias podem se consolidar em um único resultado líquido.

Portanto:

```text
FREQUÊNCIA DO SNAPSHOT
        ↕
VISIBILIDADE DAS ALTERAÇÕES
        ↕
CARGA DE TRABALHO NA ORIGEM
```

deve ser equilibrada.

A frequência final de execução para `catalog.ProductCategory` ainda não foi implementada nem validada.

### 8.7 Chave de Comparação Confiável

*Snapshot* + *Diff* depende de uma forma determinística de estabelecer se duas linhas representam a mesma entidade lógica ou o mesmo relacionamento.

Para `catalog.ProductCategory`, a identidade natural de comparação atualmente é:

```text
PRDCT_PRD_id
+
PRDCT_CTG_id
```

Conceitualmente:

```text
(Product ID, Category ID)
```

Se o mesmo par de chaves existir nos dois *snapshots*:

```text
INALTERADO
```

Se existir apenas no *snapshot* atual:

```text
ADICIONADO
```

Se existir apenas no *snapshot* anterior:

```text
REMOVIDO
```

Isso exige que a identidade do relacionamento seja estável.

Se a origem alterar posteriormente a semântica de suas chaves, a estratégia de comparação deverá ser revisada.

### 8.8 Detecção de Adição

Uma adição ocorre quando um relacionamento existe no *snapshot* atual da origem, mas não no *snapshot* conhecido anterior.

Formalmente:

```text
ADICIONADO
=
ATUAL - ANTERIOR
```

Exemplo:

```text
Anterior
Product 100 → Category 10

Atual
Product 100 → Category 10
Product 100 → Category 20
```

Resultado derivado:

```text
ADICIONADO
Product 100 → Category 20
```

Isso é conceitualmente semelhante à detecção de um INSERT.

Entretanto, a distinção deve permanecer explícita:

```text
adição derivada
≠
evento INSERT observado na origem
```

A plataforma sabe que o relacionamento é novo em relação ao *snapshot* anterior.

Ela não sabe necessariamente como ou exatamente quando a origem o criou.

### 8.9 Detecção de Remoção

Uma remoção ocorre quando um relacionamento existe no *snapshot* anterior, mas não no estado atual da origem.

Formalmente:

```text
REMOVIDO
=
ANTERIOR - ATUAL
```

Exemplo:

```text
Anterior
Product 100 → Category 10
Product 100 → Category 20

Atual
Product 100 → Category 20
```

Resultado derivado:

```text
REMOVIDO
Product 100 → Category 10
```

Isso é particularmente importante porque não há uma *watermark* de *timestamp* disponível para informar que a linha desapareceu.

A comparação entre *snapshots*, portanto, fornece uma forma prática de detectar o desaparecimento.

Novamente:

```text
remoção derivada
≠
evento DELETE capturado
```

A plataforma sabe que:

```text
o relacionamento existia anteriormente
e não existe mais
```

Ela não sabe automaticamente:

```text
timestamp exato do DELETE
comando da aplicação
contexto da transação
ação do usuário
```

a menos que outra origem forneça essa evidência.

### 8.10 Linhas Inalteradas

As linhas existentes nos dois *snapshots* são classificadas como inalteradas em relação à chave de comparação.

Formalmente:

```text
INALTERADO
=
ANTERIOR ∩ ATUAL
```

Para uma tabela de relacionamento contendo apenas colunas de identidade, isso é direto.

Para tabelas mais amplas, entretanto, a mesma chave de negócio pode existir enquanto atributos descritivos são alterados.

Nesses casos, uma estratégia de *Snapshot* + *Diff* pode exigir:

```text
comparação de chaves
+
comparação de atributos
```

ou um *hash* determinístico da linha.

Essa complexidade adicional não é exigida atualmente pela estrutura identificada de `catalog.ProductCategory`.

Ela poderá se tornar relevante se o *schema* da tabela mudar no futuro.

### 8.11 O Snapshot Deve Ser Completo

O *snapshot* atual deve representar um estado completo e confiável da origem.

Esse é um dos requisitos de correção mais importantes.

Suponha que a origem realmente contenha:

```text
A
B
C
```

mas um problema de extração produza um *snapshot* incompleto:

```text
A
B
```

Um *diff* ingênuo derivaria:

```text
REMOVIDO
C
```

mesmo que:

```text
C ainda exista na origem
```

Isso criaria uma exclusão falsa.

Portanto:

> **Um *snapshot* incompleto pode produzir remoções falsas.**

A plataforma nunca deve tratar um *snapshot* como autoritativo apenas porque uma consulta foi executada com sucesso.

O processo de extração deve estabelecer que o *snapshot* esteja suficientemente completo para uma comparação governada.

### 8.12 Snapshot Vazio É um Estado Perigoso

Um exemplo particularmente perigoso é uma extração inesperadamente vazia.

Suponha:

```text
Snapshot Anterior
10.000 relacionamentos
```

e que a próxima extração retorne inesperadamente:

```text
0 relacionamentos
```

Um *diff* ingênuo concluiria:

```text
10.000 REMOVIDOS
```

Isso poderia estar correto se a origem tivesse sido intencionalmente esvaziada.

Também poderia indicar:

```text
problema de conectividade com a origem
banco de dados incorreto
schema incorreto
problema de permissões
defeito na consulta
problema de visibilidade transacional
incidente upstream
```

Portanto:

```text
SNAPSHOT ATUAL VAZIO
```

não deve se transformar automaticamente em:

```text
EXCLUIR TUDO
```

sem validação.

A captura baseada em *snapshot* exige mecanismos de proteção contra alterações anômalas no estado da origem.

### 8.13 Validação do Snapshot

Antes de calcular um *diff*, o *snapshot* atual deve ser validado.

As validações candidatas podem incluir:

```text
contagem de linhas
unicidade das chaves
nulabilidade das colunas obrigatórias
consistência referencial
variação elevada inesperada
disponibilidade da origem
sucesso da consulta
compatibilidade de schema
```

Conceitualmente:

```text
EXTRAIR SNAPSHOT ATUAL
        ↓
VALIDAR SNAPSHOT
        │
        ├── VÁLIDO
        │      ↓
        │   CALCULAR DIFF
        │
        └── INVÁLIDO / SUSPEITO
               ↓
           NÃO PROMOVER
           INVESTIGAR
```

Os limites exatos de validação para `catalog.ProductCategory` ainda serão definidos durante a implementação.

### 8.14 O Snapshot Anterior É Estado Operacional

*Snapshot* + *Diff* exige acesso ao estado da origem anteriormente aceito.

Sem ele:

```text
SNAPSHOT ATUAL
```

não pode ser comparado com:

```text
SNAPSHOT ANTERIOR
```

O estado anterior, portanto, faz parte do mecanismo de captura.

Conceitualmente:

```text
EXECUÇÃO N

estado anteriormente aceito
        +
novo snapshot da origem
        ↓
diff
        ↓
validar / persistir
        ↓
novo snapshot torna-se
o estado aceito para a EXECUÇÃO N+1
```

Isso introduz um requisito importante de sequenciamento:

> **O novo *snapshot* não deve substituir o *snapshot* anteriormente aceito antes que a comparação e a persistência necessária tenham sido concluídas com segurança.**

Caso contrário, uma falha poderia destruir o estado necessário para a recuperação.

### 8.15 Promoção do Snapshot

O processo de captura possui conceitualmente pelo menos dois estados de *snapshot*:

```text
SNAPSHOT CANDIDATO
```

e:

```text
SNAPSHOT ACEITO
```

Um estado recém-extraído é inicialmente um candidato.

Conceitualmente:

```text
ORIGEM ATUAL
      ↓
extrair
      ↓
SNAPSHOT CANDIDATO
      ↓
validar
      ↓
comparar com SNAPSHOT ANTERIOR ACEITO
      ↓
persistir resultado necessário
      ↓
conclusão bem-sucedida
      ↓
PROMOVER CANDIDATO
a novo SNAPSHOT ACEITO
```

Se o processamento falhar:

```text
candidato
        ↓
não promovido
```

e o estado anteriormente aceito permanece disponível para uma nova tentativa.

Isso segue o mesmo princípio geral do Atlas Engineering utilizado em outros pontos:

```text
durabilidade
antes da
confirmação do progresso
```

O mecanismo exato de armazenamento dos *snapshots* aceitos permanece como uma decisão de implementação.

### 8.16 O Primeiro Snapshot Não Possui Estado Anterior

A primeira execução é diferente das execuções posteriores porque não existe um *snapshot* anterior.

Conceitualmente:

```text
PRIMEIRA EXECUÇÃO

SNAPSHOT ANTERIOR
não existe

SNAPSHOT ATUAL DA ORIGEM
        ↓
estado inicial conhecido
```

O primeiro *snapshot*, portanto, estabelece a referência inicial.

Ele não deve produzir automaticamente afirmações históricas como:

```text
todos os relacionamentos atuais
acabaram de ser INSERIDOS
```

porque eles podem existir desde muito antes do início da captura.

A interpretação correta é:

```text
SNAPSHOT INICIAL
→ estado atual conhecido dos relacionamentos
```

e não:

```text
eventos INSERT históricos observados
```

Isso segue a regra mais ampla:

> **Não invente eventos históricos que nunca foram observados.**

### 8.17 Baseline Inicial Versus Diff Contínuo

A estratégia, portanto, separa:

```text
BASELINE INICIAL
        ↓
estado atual conhecido
```

de:

```text
SNAPSHOT SUBSEQUENTE
        ↓
comparar com estado anteriormente aceito
        ↓
derivar adições e remoções
```

Conceitualmente:

```text
EXECUÇÃO 1
Origem Atual
     ↓
Baseline Inicial


EXECUÇÃO 2
Baseline Anterior
     +
Origem Atual
     ↓
Diff


EXECUÇÃO 3
Snapshot Anterior Aceito
     +
Origem Atual
     ↓
Diff
```

Essa distinção impede que a primeira execução seja apresentada incorretamente como captura de alterações históricas.

### 8.18 Sobreposição Controlada e Reprocessamento

Se uma execução de *Snapshot* + *Diff* falhar depois de produzir parte de sua saída *downstream*, a plataforma poderá precisar executar a comparação novamente.

Isso pode produzir as mesmas alterações derivadas mais de uma vez.

Por exemplo:

```text
Snapshot Anterior = A B

Snapshot Atual = A C

Derivado:
REMOVER B
ADICIONAR C
```

Se a persistência *downstream* for concluída apenas parcialmente e o *job* for reinicializado, a mesma comparação poderá derivar:

```text
REMOVER B
ADICIONAR C
```

novamente.

Portanto, a arquitetura *downstream* deve tolerar reprocessamento.

Isso está alinhado ao modelo de entrega V1 do Atlas Engineering:

```text
At-Least-Once
+
Idempotência
```

A implementação exata da idempotência está fora do escopo deste documento e ainda deverá ser validada.

### 8.19 Consistência do Snapshot

Um *snapshot* deve representar um estado coerente da origem.

Se a origem mudar enquanto a extração estiver realizando a leitura, o conjunto de dados resultante poderá, teoricamente, conter linhas observadas em momentos diferentes.

Conceitualmente:

```text
iniciar leitura da origem
        ↓
ler algumas linhas
        ↓
origem é alterada
        ↓
ler as linhas restantes
```

Dependendo da consulta, do isolamento da transação e do comportamento da origem, o conjunto de dados final extraído pode não corresponder perfeitamente a um único ponto lógico instantâneo.

Para uma tabela de relacionamento pequena e com baixo volume de alterações, esse risco pode ser operacionalmente administrável.

Entretanto, ele não deve ser ignorado.

A implementação deve avaliar o mecanismo de consistência adequado sem introduzir bloqueios ou pressão desnecessários sobre a origem OLTP.

A abordagem exata de isolamento ainda não foi selecionada nem testada para `catalog.ProductCategory`.

### 8.20 Tamanho do Snapshot e Custo na Origem

*Snapshot* + *Diff* exige a leitura repetida do estado da origem.

Portanto, sua adequação depende fortemente de:

```text
tamanho da origem
+
frequência do snapshot
+
custo da consulta
+
frequência das alterações
```

Para uma tabela de relacionamento pequena e com baixo volume de alterações, isso pode ser operacionalmente razoável.

Para uma tabela transacional de grande porte e com alto volume de alterações, a leitura repetida de todo o estado normalmente seria muito menos atraente.

Conceitualmente:

```text
PEQUENA / BAIXO VOLUME DE ALTERAÇÕES
        ↓
snapshot completo pode ser aceitável

GRANDE / ALTO VOLUME DE ALTERAÇÕES
        ↓
snapshot completo pode gerar
pressão desnecessária sobre a origem
```

Isso explica por que *Snapshot* + *Diff* foi selecionado especificamente para a origem atual da Categoria D, em vez de ser aplicado universalmente.

### 8.21 Snapshot + Diff Versus Full Refresh Controlado

*Snapshot* + *Diff* e *Full Refresh* Controlado leem o estado atual da origem, mas respondem a perguntas diferentes.

*Full Refresh* Controlado pergunta principalmente:

```text
Qual é o estado autoritativo agora?
```

*Snapshot* + *Diff* pergunta adicionalmente:

```text
O que mudou em relação
ao estado que conhecíamos anteriormente?
```

Conceitualmente:

```text
FULL REFRESH CONTROLADO

Origem Atual
     ↓
Estado Downstream Atual
```

versus:

```text
SNAPSHOT + DIFF

Estado Anterior
      +
Estado Atual
      ↓
Alteração Derivada
```

*Snapshot* + *Diff*, portanto, mantém o estado de comparação e deriva adições e remoções.

*Full Refresh* Controlado pode não precisar dessa comparação histórica quando o estado atual autoritativo for suficiente.

### 8.22 Snapshot + Diff Versus Timestamp Incremental

*Timestamp* Incremental depende de a origem expor metadados de alteração.

*Snapshot* + *Diff* não depende disso.

Conceitualmente:

```text
TIMESTAMP INCREMENTAL

origem informa:
"Fui alterado após T1"
        ↓
recuperar linha
```

versus:

```text
SNAPSHOT + DIFF

plataforma informa:
"você está diferente
do que observei anteriormente"
```

Isso produz modelos de dependência diferentes.

*Timestamp* Incremental depende fortemente de:

```text
confiabilidade da watermark
```

*Snapshot* + *Diff* depende fortemente de:

```text
completude do snapshot
+
correção da comparação
+
preservação do estado anterior
```

Nenhum dos mecanismos é inerentemente superior.

Eles resolvem condições diferentes das origens.

### 8.23 Snapshot + Diff Versus CDC

CDC captura dados orientados a alterações a partir da atividade transacional da origem.

*Snapshot* + *Diff* deriva a alteração líquida entre observações.

Considere:

```text
T1
relacionamento existe

T2
relacionamento removido

T3
relacionamento recriado

T4
snapshot
```

CDC poderia potencialmente expor:

```text
DELETE
INSERT
```

se essas operações ocorressem após a ativação do CDC e fossem capturadas.

A comparação de *snapshots* entre T1 e T4 pode resultar em:

```text
INALTERADO
```

porque os estados são iguais.

Portanto:

```text
CDC
→ maior fidelidade de eventos/alterações

Snapshot + Diff
→ fidelidade das diferenças de estado
```

O mecanismo selecionado deve corresponder ao nível necessário de detalhe histórico.

### 8.24 Remoção Não Equivale a Exclusão de Negócio

Uma remoção derivada significa:

```text
o relacionamento existia
no estado anteriormente aceito

e

não existe
no estado atualmente aceito
```

Ela não explica automaticamente o motivo.

Possíveis causas podem incluir:

```text
exclusão intencional do relacionamento
recategorização do produto
correção de dados
manutenção da origem
outra lógica de negócio
```

Portanto:

> ***Snapshot* + *Diff* deriva a transição de estado, e não a intenção de negócio.**

A interpretação semântica *downstream* não deve inventar uma causa que a origem não forneça.

### 8.25 Semântica Temporal

Alterações derivadas de *snapshots* possuem uma semântica de tempo do evento mais fraca do que a captura de eventos da origem.

Suponha que um relacionamento exista em:

```text
Snapshot T1 = 10:00
```

e esteja ausente em:

```text
Snapshot T2 = 11:00
```

A plataforma pode concluir:

```text
o relacionamento desapareceu
em algum momento após T1
e não depois de T2
```

Ela não pode concluir automaticamente:

```text
DELETE ocorreu exatamente às 11:00
```

O horário do segundo *snapshot* é o momento da observação, e não necessariamente o horário do evento de negócio.

Portanto, se posteriormente a plataforma registrar metadados como:

```text
detected_at
snapshot_at
effective_from
effective_to
```

a semântica desses campos deverá ser cuidadosamente definida.

A estratégia atual não inventa um *timestamp* exato de exclusão que a origem não possa comprovar.

### 8.26 Comparação Baseada em Hash como Técnica Futura

Para tabelas mais amplas, comparar todas as colunas pode se tornar mais complexo.

Uma possível técnica consiste em calcular um *hash* determinístico a partir dos atributos relevantes da linha.

Conceitualmente:

```text
CHAVE DE NEGÓCIO
+
ATRIBUTOS RELEVANTES
        ↓
HASH
```

Então:

```text
mesma chave + mesmo hash
→ inalterado

mesma chave + hash diferente
→ modificado
```

Essa técnica é mencionada como uma opção geral de *Snapshot* + *Diff*.

Ela não é exigida atualmente para:

```text
catalog.ProductCategory
```

porque a origem identificada é uma tabela de relacionamento cujo próprio par de chaves representa o estado relevante.

Portanto, nenhuma implementação baseada em *hash* foi selecionada pela V1 neste estágio.

### 8.27 Alterações de Schema Devem Ser Governadas

A comparação de *snapshots* pressupõe que a estrutura da origem e a semântica da comparação sejam compreendidas.

Se a tabela receber novas colunas posteriormente, a plataforma deverá perguntar:

```text
Esta nova coluna afeta
o significado do relacionamento?

As alterações nela devem ser detectadas?

Ela altera a identidade da comparação?

O schema do Snapshot precisa mudar?
```

Uma alteração de *schema*, portanto, não deve modificar silenciosamente o significado do *diff*.

Esse é outro motivo pelo qual a estratégia de captura deve permanecer versionada e passível de revisão.

### 8.28 Fluxo Candidato de Implementação

A implementação futura pode ser representada conceitualmente como:

```text
INICIAR EXECUÇÃO
    │
    ▼
LER ESTADO ATUAL DA ORIGEM
    │
    ▼
CRIAR SNAPSHOT CANDIDATO
    │
    ▼
VALIDAR SNAPSHOT
    │
    ├── inválido
    │      ↓
    │   FALHAR EXECUÇÃO
    │   preservar estado anteriormente aceito
    │
    └── válido
           │
           ▼
    SNAPSHOT ANTERIOR EXISTE?
           │
           ├── NÃO
           │     ↓
           │   estabelecer baseline inicial
           │
           └── SIM
                 ↓
            CALCULAR DIFF
                 │
                 ├── adicionado
                 ├── removido
                 └── inalterado
                 │
                 ▼
            PERSISTIR SAÍDA NECESSÁRIA
                 │
                 ▼
            bem-sucedido?
                 │
                 ├── NÃO
                 │     ↓
                 │   preservar snapshot anterior
                 │   realizar nova tentativa com segurança
                 │
                 └── SIM
                       ↓
                  PROMOVER CANDIDATO
                  A NOVO SNAPSHOT ACEITO
```

Esse diagrama expressa a estratégia.

A tecnologia exata de implementação, o local de armazenamento, os limites de transação e a orquestração ainda serão definidos e testados.

### 8.29 Testes Candidatos de Validação

Antes que *Snapshot* + *Diff* seja considerado operacionalmente validado para `catalog.ProductCategory`, testes controlados devem abranger pelo menos:

```text
01. BASELINE INICIAL
    O primeiro snapshot estabelece
    o estado atual sem inventar histórico de INSERT?

02. SEM ALTERAÇÃO
    Snapshots consecutivos idênticos
    produzem zero alterações derivadas?

03. ADICIONAR RELACIONAMENTO
    Um novo par de chaves é detectado como ADICIONADO?

04. REMOVER RELACIONAMENTO
    Um par de chaves anteriormente existente e agora ausente
    é detectado como REMOVIDO?

05. ADICIONAR E REMOVER SIMULTANEAMENTE
    As duas direções podem ser derivadas
    na mesma comparação?

06. MÚLTIPLAS ALTERAÇÕES ENTRE SNAPSHOTS
    Qual estado líquido pode ser observado?

07. REMOVER E RECRIAR
    A limitação relacionada a alterações
    intermediárias invisíveis é compreendida?

08. ORIGEM VAZIA
    Como um snapshot inesperado com zero linhas é tratado?

09. GRANDE VARIAÇÃO NA CONTAGEM DE LINHAS
    Qual validação impede uma falsa remoção em massa?

10. CHAVES DUPLICADAS
    O que acontece se as premissas de unicidade
    da origem forem violadas?

11. FALHA NO PROCESSAMENTO DO DIFF
    O snapshot anteriormente aceito é preservado?

12. REINICIALIZAÇÃO
    A mesma comparação pode ser executada novamente com segurança?

13. CONSISTÊNCIA DO SNAPSHOT
    A extração é suficientemente coerente?

14. DESEMPENHO NA ORIGEM
    A extração repetida do estado completo é aceitável?

15. ALTERAÇÃO DE SCHEMA
    A evolução do schema falha de forma segura
    em vez de corromper silenciosamente a comparação?

16. RECONCILIAÇÃO
    O snapshot aceito pode ser comparado
    com a origem para detectar divergências?
```

Esses testes devem fornecer evidências de implementação antes que o mecanismo seja considerado comprovado.

### 8.30 Estado Atual da Validação

O estado atual da V1 é:

```text
catalog.ProductCategory

Classificação
→ D — Baixo Volume de Alterações / Sem Watermark

Mecanismo Selecionado
→ Snapshot + Diff

Fundamentação Arquitetural
→ definida

Implementação
→ pendente

Testes Controlados
→ pendentes

Validação Operacional
→ pendente

Validação de Ponta a Ponta
→ pendente
```

Portanto:

```text
SELECIONADO
≠
IMPLEMENTADO
≠
TESTADO
≠
COMPROVADO
```

O mecanismo é atualmente uma decisão arquitetural que aguarda evidências de implementação.

### 8.31 Resumo da Fundamentação

A estratégia V1 de *Snapshot* + *Diff* pode ser resumida como:

```text
ORIGEM APLICÁVEL
catalog.ProductCategory

CLASSIFICAÇÃO
D — Baixo Volume de Alterações / Sem Watermark

POR QUE NÃO TIMESTAMP INCREMENTAL?
Nenhuma watermark confiável baseada em timestamp foi identificada

POR QUE SNAPSHOT + DIFF?
Origem de relacionamento com baixo volume de alterações
+
estado completo pode ser comparado
+
adições precisam ser identificáveis
+
remoções precisam ser identificáveis

MODELO DE ALTERAÇÃO
Estado Anterior
vs
Estado Atual

ADICIONADO
Atual - Anterior

REMOVIDO
Anterior - Atual

INALTERADO
Anterior ∩ Atual

FIDELIDADE DE EVENTOS
Diferenças líquidas de estado
não todos os eventos intermediários

EXECUÇÃO INICIAL
Estabelecer baseline

ESTADO OPERACIONAL NECESSÁRIO
Snapshot anteriormente aceito

PRINCIPAL RISCO DE CORREÇÃO
Snapshot incompleto
pode criar remoções falsas

PRINCIPAL RISCO OPERACIONAL
Extração repetida do estado completo
deve permanecer aceitável para a origem OLTP

VALIDAÇÃO ATUAL
Apenas decisão arquitetural

VALIDAÇÃO DA IMPLEMENTAÇÃO
Pendente
```

O princípio que rege essa estratégia é:

> **Quando a origem não consegue informar de forma confiável à plataforma o que mudou, a plataforma pode derivar a alteração comparando estados confiáveis.**

O princípio de segurança correspondente é:

> **Um *diff* é tão confiável quanto os *snapshots* que estão sendo comparados.**

---

## 9. Estratégia de Full Refresh Controlado

*Full Refresh* Controlado é o mecanismo de captura V1 selecionado para pequenos conjuntos de dados de referência cujo principal requisito *downstream* é o estado atual autoritativo.

As origens inicialmente atribuídas a essa estratégia são:

```text
sales.TransactionStatus
sales.TransactionChannel
```

Essas tabelas fornecem valores de referência utilizados para interpretar os dados transacionais de vendas.

Seu papel atual é fundamentalmente diferente de:

```text
sales.Transaction
sales.TransactionItem
```

que exigem captura orientada a alterações por CDC.

Para as origens de referência, a principal pergunta é:

```text
Qual é o estado atual
autoritativo desta referência?
```

em vez de:

```text
Quais foram todas as operações
individuais na origem que
produziram esse estado?
```

O mecanismo V1 é, portanto:

```text
Full Refresh Controlado
```

Conceitualmente:

```text
ORIGEM DE REFERÊNCIA
       ↓
ler estado atual completo
       ↓
validar
       ↓
comparar / reconciliar se necessário
       ↓
publicar estado atual
autoritativo downstream
```

A estratégia favorece deliberadamente a simplicidade quando a captura detalhada em nível de evento não é exigida atualmente.

### 9.1 Tabelas Aplicáveis

A estratégia V1 de *Full Refresh* Controlado aplica-se atualmente a:

```text
sales.TransactionStatus
sales.TransactionChannel
```

Essas tabelas estão classificadas como:

```text
C — Referência
```

Seus valores de origem atualmente conhecidos são:

```text
sales.TransactionStatus

1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

e:

```text
sales.TransactionChannel

1 ONLINE
2 STORE
```

Esses conjuntos de dados de referência participam da interpretação das linhas transacionais.

Por exemplo:

```text
sales.Transaction
        │
        ├── identificador de status
        │      ↓
        │   sales.TransactionStatus
        │
        └── identificador de canal
               ↓
            sales.TransactionChannel
```

As tabelas de referência permitem que consumidores *downstream* traduzam identificadores em descrições de negócio significativas.

### 9.2 Fundamentação

*Full Refresh* Controlado foi selecionado porque o requisito atual da V1 não justifica introduzir complexidade de captura em nível de alteração para essas origens.

A decisão combina:

```text
PEQUENO CONJUNTO DE DADOS DE REFERÊNCIA
        +
BAIXO CUSTO OPERACIONAL DE EXTRAÇÃO
        +
ESTADO ATUAL AUTORITATIVO NECESSÁRIO
        +
HISTÓRICO EM NÍVEL DE EVENTO
NÃO EXIGIDO ATUALMENTE
        ↓
Full Refresh Controlado
```

O mecanismo recupera deliberadamente o estado completo da origem.

Isso evita exigir:

```text
instâncias de captura CDC
retenção do CDC
controle de checkpoint baseado em timestamp
validação de watermark
derivação de alterações por Snapshot + Diff
```

para origens nas quais essas capacidades forneceriam pouco valor adicional diante do requisito atual.

O projeto segue um princípio central de seleção:

> **Utilize o mecanismo mais simples que atenda ao requisito de forma confiável.**

### 9.3 Estado Atual Versus Histórico de Alterações

*Full Refresh* Controlado é principalmente orientado a estado.

O mecanismo responde:

```text
Quais linhas devem existir
downstream agora?
```

Ele não responde inerentemente:

```text
Quando uma linha foi originalmente inserida?

Quando uma descrição foi alterada?

Quantas vezes ela foi alterada?

Qual era o valor anterior exato?

Quem a alterou?

Qual transação realizou a alteração?
```

Por exemplo, suponha que:

```text
TransactionStatus

3 COMPLETED
```

posteriormente se torne:

```text
3 CLOSED
```

Um *Full Refresh* Controlado pode estabelecer:

```text
valor atual autoritativo
=
3 CLOSED
```

mas não preserva inerentemente a transição histórica:

```text
COMPLETED
→ CLOSED
```

a menos que a arquitetura *downstream* escolha explicitamente versionar ou auditar alterações nas referências.

Portanto:

> ***Full Refresh* Controlado obtém o estado autoritativo; ele não fornece inerentemente o histórico de eventos da origem.**

### 9.4 Por Que CDC Não Foi Selecionado

O SQL Server CDC poderia, tecnicamente, ser habilitado para essas tabelas.

Possibilidade técnica, entretanto, não é justificativa arquitetural suficiente.

Utilizar CDC introduziria preocupações adicionais como:

```text
configuração de captura
tabelas de alteração
instâncias de captura
retenção
limpeza
processamento pelo consumidor
controle de checkpoint
replay
monitoramento operacional
```

Para pequenos conjuntos de dados de referência cujo estado atual é suficiente, isso aumentaria a complexidade sem agregar valor de negócio atualmente necessário.

Conceitualmente:

```text
tabela de referência com 5 linhas
        +
estado atual suficiente
        ↓
CDC possível
        mas
        ↓
complexidade desnecessária
```

Portanto:

```text
tecnicamente possível
≠
arquiteturalmente apropriado
```

### 9.5 Por Que Timestamp Incremental Não É Preferido

*Timestamp* Incremental também poderia ser considerado se existisse uma *watermark* confiável.

Entretanto, para conjuntos de dados de referência extremamente pequenos, a extração incremental pode oferecer pouco benefício operacional em comparação com a recuperação do estado completo.

Considere:

```text
5 linhas na origem
```

em comparação com a manutenção de:

```text
watermark
checkpoint
lógica de limite
recuperação de falhas
validação de timestamp
```

O mecanismo incremental poderia se tornar mais complexo do que a própria origem.

O princípio de projeto é:

```text
benefício da otimização
deve justificar
a complexidade da otimização
```

Para as origens de referência atuais da V1, *Full Refresh* Controlado é mais simples e suficiente.

### 9.6 Por Que Snapshot + Diff Não É Necessário

*Snapshot* + *Diff* também trabalha com estados completos da origem.

Entretanto, seu principal objetivo é derivar adições e remoções comparando:

```text
estado anterior
versus
estado atual
```

Para essas tabelas de referência, o requisito atual da V1 consiste principalmente em manter o estado atual autoritativo.

Portanto, preservar um estado anterior de captura apenas para inferir alterações não é exigido pela estratégia atual.

Conceitualmente:

```text
Snapshot + Diff
→ O que mudou entre os estados?

Full Refresh Controlado
→ Qual deve ser o estado agora?
```

Se requisitos futuros exigirem detecção explícita de alterações nas referências ou rastreamento histórico de transições, *Snapshot* + *Diff* ou outro mecanismo poderá se tornar relevante.

### 9.7 Extração Completa da Origem

Um *Full Refresh* Controlado recupera intencionalmente o conjunto de dados de referência completo.

Conceitualmente:

```sql
SELECT ...
FROM sales.TransactionStatus;
```

e:

```sql
SELECT ...
FROM sales.TransactionChannel;
```

A consulta real de implementação deve selecionar explicitamente as colunas necessárias, em vez de depender desnecessariamente de:

```sql
SELECT *
```

porque o contrato de captura deve permanecer deliberado e passível de revisão.

Conceitualmente:

```text
ORIGEM
todas as linhas de referência necessárias
        ↓
EXTRAIR
todas as colunas de referência necessárias
        ↓
VALIDAR
        ↓
PROMOVER
```

Como os conjuntos de dados são pequenos, espera-se que a extração completa permaneça operacionalmente pouco custosa sob as premissas atuais da V1.

Essa premissa ainda deve ser validada durante a implementação.

### 9.8 Full Refresh Não Significa Substituição Descontrolada

A palavra:

```text
Full
```

descreve o escopo da extração.

A palavra:

```text
Controlado
```

descreve como a atualização deve ser governada.

O mecanismo não deve ser interpretado como:

```text
DELETE na tabela downstream
        ↓
esperar que a extração funcione
        ↓
INSERT das novas linhas
```

porque uma falha entre essas operações poderia deixar a representação *downstream* incompleta ou vazia.

Em vez disso, a atualização deve seguir um ciclo de vida controlado.

Conceitualmente:

```text
EXTRAIR ESTADO ATUAL DA ORIGEM
        ↓
CRIAR ESTADO CANDIDATO
        ↓
VALIDAR
        ↓
candidato aceitável?
        │
        ├── NÃO
        │     ↓
        │   FALHAR
        │   preservar estado
        │   anteriormente aceito
        │
        └── SIM
              ↓
          PROMOVER
              ↓
       novo estado autoritativo
```

O mecanismo exato de implementação ainda será definido.

### 9.9 Estado Candidato e Estado Aceito

Uma distinção conceitual útil é:

```text
ESTADO CANDIDATO
```

versus:

```text
ESTADO ACEITO
```

A extração mais recente deve ser inicialmente tratada como candidata.

Somente após a validação ela deve se tornar o novo estado autoritativo *downstream*.

Conceitualmente:

```text
ORIGEM
   ↓
candidato
   ↓
validar
   │
   ├── inválido
   │      ↓
   │   descartar / investigar
   │
   └── válido
          ↓
       promover
          ↓
      estado aceito
```

Isso impede que uma extração incorreta substitua imediatamente um estado de referência conhecido e válido.

### 9.10 Limites da Atualização

Uma atualização possui um limite operacional.

Conceitualmente:

```text
ATUALIZAÇÃO N
        ↓
extrair estado da origem
        ↓
validar
        ↓
persistir com segurança
        ↓
promover
        ↓
ATUALIZAÇÃO N concluída
```

O limite deve representar:

```text
o estado completo da referência
que foi aceito com sucesso
```

em vez de:

```text
o ponto em que a extração apenas começou
```

ou:

```text
o ponto em que algumas linhas foram lidas
```

Uma atualização deve, portanto, ser tratada como uma unidade governada de substituição ou reconciliação de estado.

### 9.11 Uma Atualização com Falha Deve Preservar o Estado Válido Anterior

Suponha que o estado atual da referência *downstream* seja válido:

```text
PENDING
CONFIRMED
COMPLETED
CANCELLED
FAILED
```

Uma nova atualização começa, mas falha após recuperar apenas:

```text
PENDING
CONFIRMED
```

A plataforma *downstream* não deve concluir:

```text
COMPLETED removido
CANCELLED removido
FAILED removido
```

apenas porque a extração falhou.

O princípio correto é:

> **Uma atualização com falha não deve destruir o estado anteriormente aceito.**

Conceitualmente:

```text
estado anteriormente aceito
        ↓
nova extração falha
        ↓
estado anteriormente aceito permanece ativo
```

Isso torna a falha da atualização recuperável, em vez de destrutiva.

### 9.12 Proteção Contra Resultado Vazio

Um resultado inesperado com zero linhas é particularmente perigoso em um *Full Refresh* Controlado.

Suponha que:

```text
sales.TransactionStatus
dados de referência esperados
```

repentinamente produza:

```text
0 linhas
```

Possíveis explicações incluem:

```text
alteração legítima na origem
banco de dados incorreto
schema incorreto
problema de permissão
problema de conexão
defeito na consulta
incidente upstream
corrupção na origem
```

Uma atualização controlada não deve interpretar automaticamente:

```text
0 linhas retornadas
```

como:

```text
o estado autoritativo está vazio
```

sem validação.

Portanto:

> **Uma extração vazia deve ser tratada como um dado que exige validação, e não automaticamente como um estado de negócio válido.**

### 9.13 Validação da Referência

Antes da promoção, o estado candidato da referência deve ser validado.

Possíveis validações incluem:

```text
consulta concluída com sucesso
colunas esperadas existem
chaves não são nulas
chaves são únicas
valores obrigatórios estão preenchidos
contagem de linhas é plausível
premissas referenciais permanecem válidas
schema é compatível
```

Para as origens atualmente conhecidas, as expectativas de contagem de linhas são particularmente fáceis de observar porque a referência inicial contém:

```text
TransactionStatus
5 linhas

TransactionChannel
2 linhas
```

Entretanto, esses números não devem se transformar automaticamente em regras de negócio permanentes codificadas de forma rígida, a menos que o contrato da origem os defina explicitamente dessa forma.

Por exemplo:

```text
5 linhas observadas
```

não significa necessariamente:

```text
exatamente 5 status para sempre
```

Um novo status legítimo poderá ser adicionado no futuro.

Portanto:

```text
REFERÊNCIA OBSERVADA
≠
LIMITE PERMANENTE DO DOMÍNIO
```

a menos que o contrato de negócio estabeleça explicitamente esse limite.

### 9.14 Detecção de Alterações Legítimas nas Referências

*Full Refresh* Controlado deve permitir alterações legítimas na origem.

Por exemplo, um futuro estado da origem poderia se tornar:

```text
TransactionChannel

1 ONLINE
2 STORE
3 MARKETPLACE
```

Uma regra de validação como:

```text
contagem de linhas deve ser sempre igual a 2
```

rejeitaria incorretamente uma expansão legítima do negócio.

O objetivo da validação, portanto, não é congelar o conjunto de dados de referência.

É distinguir:

```text
alteração plausível e controlada na origem
```

de:

```text
extração com falha ou suspeita
```

A validação deve utilizar contexto em vez de premissas frágeis.

### 9.15 Valores de Referência Adicionados

Suponha que o estado aceito seja:

```text
1 ONLINE
2 STORE
```

e o novo estado da origem seja:

```text
1 ONLINE
2 STORE
3 MARKETPLACE
```

O *Full Refresh* Controlado obtém:

```text
1 ONLINE
2 STORE
3 MARKETPLACE
```

e, após a validação, esse conjunto se torna o estado atual autoritativo.

O mecanismo não precisa modelar:

```text
evento INSERT para MARKETPLACE
```

a menos que o histórico *downstream* exija explicitamente esse evento.

O resultado importante para o requisito atual da V1 é:

```text
MARKETPLACE existe agora
```

### 9.16 Valores de Referência Modificados

Suponha que:

```text
3 COMPLETED
```

se torne:

```text
3 CLOSED
```

Um novo *Full Refresh* Controlado deve produzir o estado atual autoritativo:

```text
3 CLOSED
```

Novamente:

```text
estado atual obtido
```

não significa inerentemente:

```text
transição histórica preservada
```

Se posteriormente a plataforma analítica precisar responder:

```text
Quando COMPLETED foi renomeado para CLOSED?
```

então o mecanismo atual, isoladamente, será insuficiente.

Isso representaria um novo requisito e deveria provocar uma revisão da estratégia.

### 9.17 Valores de Referência Removidos

Suponha que:

```text
5 FAILED
```

exista no estado anteriormente aceito, mas esteja ausente do estado atual autoritativo da origem.

Após validação e promoção bem-sucedidas, a representação *downstream* do estado atual deve refletir essa ausência.

Entretanto, isso não significa automaticamente que:

```text
transações históricas que utilizaram o status 5
devam perder seu significado histórico
```

Essa distinção é crítica.

O estado atual da referência e a interpretação analítica histórica são questões distintas.

Uma transação histórica pode legitimamente continuar contendo:

```text
TRNST_id = 5
```

mesmo que o status 5 não esteja mais disponível para novas transações operacionais.

Portanto:

> **Remover um valor da origem de referência atual não deve reescrever automaticamente fatos históricos de negócio.**

A estratégia dimensional *downstream* deve preservar a correção histórica de acordo com suas próprias regras de modelagem.

### 9.18 Integridade da Referência e Histórico Transacional

Tabelas de referência descrevem valores utilizados por dados transacionais.

Isso cria uma possível questão temporal.

Suponha que transações históricas contenham:

```text
TRNST_id = 5
```

enquanto a atualização atual de `TransactionStatus` não contenha mais:

```text
5 FAILED
```

A plataforma não deve simplesmente concluir:

```text
linhas históricas são inválidas
```

sem compreender a semântica de negócio.

Possíveis realidades incluem:

```text
status descontinuado para uso futuro
mas referências históricas permanecem válidas
```

ou:

```text
problema de integridade na origem
```

Esses casos exigem respostas diferentes.

Portanto, a reconciliação futura deve distinguir:

```text
participação atual na referência
```

de:

```text
validade referencial histórica
```

*Full Refresh* Controlado estabelece apenas a representação atual da origem.

### 9.19 Estado Atual Autoritativo

Para essa estratégia, a tabela de referência da origem permanece sendo a autoridade sobre o estado atual.

Conceitualmente:

```text
tabela de referência do AtlasCommerce
        ↓
origem atual autoritativa
        ↓
Full Refresh Controlado
        ↓
representação downstream
```

A plataforma *downstream* não deve inventar independentemente novos valores operacionais de referência.

Se a plataforma analítica exigir classificações adicionais, elas devem ser representadas como semântica analítica *downstream*, em vez de alterar silenciosamente a referência capturada da origem.

Por exemplo:

```text
STATUS DA ORIGEM
COMPLETED
```

poderia posteriormente ser agrupado analiticamente em:

```text
GRUPO ANALÍTICO
Successful
```

mas:

```text
Successful
```

não deve ser apresentado como se fosse um valor de `TransactionStatus` da origem caso não exista no AtlasCommerce.

### 9.20 Frequência da Atualização

*Full Refresh* Controlado é executado periodicamente, em vez de acompanhar continuamente cada operação individual da origem.

Conceitualmente:

```text
T1
Full Refresh

        ↓

T2
Full Refresh

        ↓

T3
Full Refresh
```

O intervalo entre atualizações influencia por quanto tempo o estado de referência *downstream* pode permanecer defasado em relação à origem.

Por exemplo:

```text
origem muda logo após T1
        ↓
downstream permanece no estado anterior
        ↓
atualização T2
        ↓
novo estado torna-se disponível
```

Portanto:

```text
FREQUÊNCIA DA ATUALIZAÇÃO
        ↕
DEFASAGEM DA REFERÊNCIA
        ↕
FREQUÊNCIA DAS CONSULTAS À ORIGEM
```

deve ser equilibrada.

Como os conjuntos de dados da origem são pequenos, espera-se que a carga de trabalho na origem seja baixa.

O agendamento final das atualizações permanece uma decisão de implementação e ainda não foi validado.

### 9.21 Full Refresh e o SLO de Latência da Plataforma

A plataforma mais ampla do Atlas Engineering define atualmente:

```text
Meta típica de latência dos dados
≈ 3–5 minutos

SLO formal de ponta a ponta
P95 ≤ 15 minutos
```

Isso não significa automaticamente que toda tabela de referência deva ser atualizada a cada três a cinco minutos.

O requisito real deve considerar as características de cada origem.

Uma transação de venda que muda rapidamente e uma referência de status que raramente muda não exigem necessariamente a mesma frequência de captura na origem.

Portanto:

> **Os objetivos de latência da plataforma devem ser interpretados de acordo com os requisitos da origem e do produto de dados, em vez de serem aplicados mecanicamente a todas as tabelas.**

A frequência final da V1 para essas atualizações de referência ainda será implementada.

### 9.22 Full Refresh e Carga Inicial

*Full Refresh* Controlado possui uma propriedade útil:

```text
carga inicial
```

e:

```text
captura contínua normal
```

utilizam essencialmente o mesmo modelo de estado da origem.

A primeira execução:

```text
ler estado completo da referência
        ↓
validar
        ↓
estabelecer estado aceito
```

Execuções posteriores:

```text
ler estado completo da referência
        ↓
validar
        ↓
substituir / reconciliar estado aceito
```

Diferentemente do CDC:

```text
não há histórico de eventos
anterior à captura
a ser reconstruído
```

porque o mecanismo é explicitamente orientado a estado.

A primeira atualização estabelece:

```text
estado atual conhecido
```

e não eventos históricos da origem.

### 9.23 Nenhuma Invenção de Eventos Históricos

Suponha que a primeira atualização identifique:

```text
1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

A plataforma pode estabelecer:

```text
esses valores existem
no momento da captura inicial
```

Ela não pode concluir:

```text
o status 1 foi inserido primeiro
depois o status 2
depois o status 3
...
```

a menos que outra origem autoritativa comprove essa sequência.

Portanto:

> **O *Full Refresh* inicial estabelece o estado de referência inicial, e não eventos históricos sintéticos.**

Isso mantém a mesma disciplina de evidências aplicada a todos os mecanismos de captura do Atlas Engineering.

### 9.24 Promoção Controlada

Uma implementação futura deve separar a extração da publicação.

Conceitualmente:

```text
ORIGEM
   ↓
EXTRAIR
   ↓
CANDIDATO
   ↓
VALIDAR
   ↓
PROMOVER
   ↓
ESTADO ATIVO DA REFERÊNCIA
```

Isso evita expor uma atualização parcialmente processada aos consumidores *downstream*.

A técnica exata poderá posteriormente envolver transações de banco de dados, estruturas de *staging*, promoção de arquivos, substituição atômica ou outro mecanismo controlado, dependendo de onde a atualização for materializada.

Este documento não seleciona prematuramente essa implementação.

### 9.25 Idempotência do Full Refresh

O mesmo estado da origem pode ser processado mais de uma vez.

Por exemplo:

```text
Atualização N
origem =
A B C

Nova tentativa da Atualização N
origem =
A B C
```

Uma implementação *downstream* correta deve convergir para:

```text
A B C
```

em vez de criar valores lógicos de referência duplicados.

Portanto, *Full Refresh* Controlado deve naturalmente oferecer suporte à convergência idempotente de estado.

Conceitualmente:

```text
mesma entrada autoritativa
processada repetidamente
        ↓
mesma saída lógica
```

A implementação exata continua fazendo parte do processamento *downstream* e deve ser validada de forma independente.

### 9.26 Modelo de Falha e Nova Tentativa

Uma atualização pode falhar durante:

```text
extração da origem
validação
transporte
persistência
promoção
```

A estratégia deve permitir que uma execução com falha seja realizada novamente sem danificar o estado anteriormente aceito.

Conceitualmente:

```text
EXECUÇÃO N
estado anterior válido
        ↓
nova atualização falha
        ↓
estado anterior permanece ativo
        ↓
nova tentativa
        ↓
novo candidato bem-sucedido
        ↓
promover
```

Isso produz:

```text
defasagem temporária
```

em vez de:

```text
estado de referência corrompido
```

quando uma atualização falha.

Para um pequeno conjunto de dados de referência, preservar um estado válido conhecido um pouco mais antigo geralmente é preferível a expor um estado parcial ou não validado.

### 9.27 Desaparecimento do Estado Atual Versus Evento Histórico de DELETE

Suponha:

```text
Atualização Anterior

1 ONLINE
2 STORE
```

e:

```text
Atualização Atual

1 ONLINE
```

A plataforma pode estabelecer:

```text
STORE não está mais
no estado atual da origem
```

Ela não pode necessariamente estabelecer:

```text
um DELETE ocorreu
em um timestamp exato
```

ou:

```text
o negócio pretendia
que transações históricas STORE
desaparecessem
```

Esse é outro exemplo da diferença entre:

```text
OBSERVAÇÃO DE ESTADO
```

e:

```text
CAPTURA DE EVENTO
```

*Full Refresh* Controlado é intencionalmente orientado a estado.

### 9.28 Evolução de Schema

Tabelas de referência podem evoluir.

Possíveis alterações incluem:

```text
nova coluna
coluna renomeada
coluna removida
alteração de tipo de dado
novo atributo obrigatório
```

Uma implementação de atualização deve detectar alterações incompatíveis de *schema* em vez de produzir silenciosamente dados *downstream* malformados.

Conceitualmente:

```text
SCHEMA DA ORIGEM
        ↓
contrato de captura esperado
        │
        ├── compatível
        │      ↓
        │   processar
        │
        └── incompatível
               ↓
            falhar com segurança
            investigar
```

A implementação do contrato de *schema* *downstream* permanece fora do escopo da estratégia de captura atual, mas o processo de captura não deve ignorar alterações estruturais.

### 9.29 Full Refresh Controlado Não É `SELECT *`

Como o conjunto de dados completo é atualizado, pode ser tentador interpretar *Full Refresh* como:

```sql
SELECT *
```

Esse não é o projeto pretendido.

O contrato de captura deve identificar explicitamente as colunas necessárias da origem.

Os motivos incluem:

- a evolução do *schema* da origem deve ser deliberada;
- colunas desnecessárias não devem entrar silenciosamente no *pipeline*;
- contratos *downstream* devem permanecer previsíveis;
- a linhagem deve permanecer explícita;
- alterações incompatíveis na origem devem falhar de forma visível.

Portanto:

```text
CONJUNTO COMPLETO DE LINHAS
```

não significa:

```text
CONTRATO DE COLUNAS DESCONTROLADO
```

O mecanismo atualiza o estado completo necessário, e não todas as colunas que a origem eventualmente exponha para sempre.

### 9.30 Testes Candidatos de Validação

Antes que *Full Refresh* Controlado seja considerado operacionalmente validado para as origens de referência da V1, testes controlados devem abranger pelo menos:

```text
01. ATUALIZAÇÃO INICIAL
    A primeira execução estabelece
    o estado atual autoritativo?

02. SEM ALTERAÇÃO
    Uma atualização idêntica
    converge sem duplicidades?

03. ADICIONAR VALOR
    Um novo valor legítimo de referência
    é propagado corretamente?

04. MODIFICAR VALOR
    Uma descrição alterada
    é refletida corretamente?

05. REMOVER VALOR
    A ausência é representada no
    estado atual downstream?

06. RESULTADO VAZIO
    Um resultado inesperado com zero linhas
    falha com segurança?

07. EXTRAÇÃO PARCIAL
    Dados incompletos podem ser impedidos
    de substituir o estado aceito?

08. CHAVE DUPLICADA
    Uma violação da unicidade da referência
    é detectada?

09. VALOR OBRIGATÓRIO NULO
    Um estado inválido da origem é rejeitado
    ou explicitamente governado?

10. FALHA ANTES DA PROMOÇÃO
    O estado anteriormente aceito
    permanece disponível?

11. FALHA DURANTE A PROMOÇÃO
    O processo consegue se recuperar sem
    expor estado parcial?

12. NOVA TENTATIVA
    A mesma atualização pode ser executada novamente com segurança?

13. ALTERAÇÃO DE SCHEMA
    Uma evolução incompatível
    falha de forma visível?

14. DESEMPENHO NA ORIGEM
    A extração completa é operacionalmente
    desprezível como esperado?

15. RECONCILIAÇÃO
    O estado downstream aceito
    corresponde à origem autoritativa?
```

Esses testes devem ser executados de forma independente para:

```text
sales.TransactionStatus
sales.TransactionChannel
```

embora ambas utilizem a mesma estratégia de captura.

### 9.31 Estado Atual da Validação

O estado atual da V1 é:

```text
sales.TransactionStatus

Classificação
→ C — Referência

Mecanismo Selecionado
→ Full Refresh Controlado

Fundamentação Arquitetural
→ definida

Implementação
→ pendente

Testes Controlados
→ pendentes

Validação Operacional
→ pendente
```

e:

```text
sales.TransactionChannel

Classificação
→ C — Referência

Mecanismo Selecionado
→ Full Refresh Controlado

Fundamentação Arquitetural
→ definida

Implementação
→ pendente

Testes Controlados
→ pendentes

Validação Operacional
→ pendente
```

Portanto:

```text
SELECIONADO
≠
IMPLEMENTADO
≠
TESTADO
≠
COMPROVADO
```

As contagens atuais de linhas e os valores da origem são conhecidos a partir do inventário da origem e do trabalho de referência do CDC.

Essa observação não deve ser confundida com a validação da futura implementação de *Full Refresh* Controlado.

### 9.32 Resumo da Fundamentação

A estratégia V1 de *Full Refresh* Controlado pode ser resumida como:

```text
ORIGENS APLICÁVEIS
sales.TransactionStatus
sales.TransactionChannel

CLASSIFICAÇÃO
C — Referência

POR QUE FULL REFRESH?
Pequenos conjuntos de dados
+
estado atual autoritativo necessário
+
histórico de alterações em nível de evento
não exigido atualmente

POR QUE CONTROLADO?
Uma atualização não deve expor
estado parcial, com falha ou inválido

MODELO DE CAPTURA
Estado atual completo necessário

EXECUÇÃO INICIAL
Estabelecer referência autoritativa inicial

EXECUÇÕES CONTÍNUAS
Atualizar estado autoritativo

WATERMARK
Não necessária

SNAPSHOT ANTERIOR
Não exigido inerentemente
para a captura

EVENTO DELETE
Não capturado inerentemente

DESAPARECIMENTO
Refletido por meio do estado atual

PRINCIPAL RISCO DE CORREÇÃO
Atualização inválida ou incompleta
substituindo um estado válido

PRINCIPAL REGRA DE SEGURANÇA
Preservar estado anteriormente aceito
até que o novo candidato seja validado

VALIDAÇÃO ATUAL
Apenas decisão arquitetural

VALIDAÇÃO DA IMPLEMENTAÇÃO
Pendente
```

O princípio que rege essa estratégia é:

> **Quando o requisito é o estado atual autoritativo e a leitura completa da origem possui baixo custo operacional, não introduza complexidade incremental sem um requisito correspondente.**

O princípio de segurança correspondente é:

> ***Full Refresh* descreve quanto estado é lido; controlado descreve com que cuidado esse estado pode substituir aquilo em que já se confia.**

---

## 10. Estratégia de Backfill Inicial e Cutover

A Plataforma de Engenharia de Dados do Atlas Engineering deve ingerir origens que já contêm dados operacionais antes que os mecanismos de captura sejam ativados.

Isso cria duas responsabilidades distintas:

```text
DADOS EXISTENTES
já presentes na origem
        ↓
Backfill Inicial
        ↓
estado atual conhecido


ALTERAÇÕES CONTÍNUAS
ocorrendo após o limite de captura
        ↓
mecanismo de captura contínua
        ↓
alteração observável ou estado atualizado
```

Essas responsabilidades devem ser coordenadas.

Se a carga histórica e a captura contínua forem tratadas de forma independente, a transição entre elas poderá criar:

```text
lacunas
duplicidades
estado inconsistente
histórico inventado
```

A estratégia V1 de *cutover*, portanto, segue um princípio fundamental:

> **Proteja o futuro primeiro e, depois, carregue o passado.**

O objetivo é estabelecer um limite confiável para a captura futura antes de realizar uma carga histórica potencialmente demorada.

Isso permite que novas alterações permaneçam observáveis enquanto os dados existentes são adquiridos.

### 10.1 Estado Inicial

Quando a captura começa, a origem já contém dados de negócio válidos.

Para as origens transacionais iniciais com alto volume de alterações, a referência anterior à ativação do CDC identificou:

```text
sales.Transaction
6306 linhas

sales.TransactionItem
13769 linhas
```

Essas linhas já existiam antes que o CDC começasse a capturar alterações na origem.

Portanto:

```text
linhas existentes na origem
≠
eventos históricos do CDC
```

Habilitar o CDC não reconstrói a sequência de operações que produziu o estado existente na origem.

Conceitualmente:

```text
PASSADO
───────────────────────────────┬──────────── FUTURO
                               │
                       limite de captura
                               │
                               ▼
estado existente na origem     alterações visíveis pelo CDC
```

As linhas à esquerda do limite podem ser carregadas como estado conhecido.

Seu histórico de alterações anterior ao limite não está automaticamente disponível.

#### 10.1.1 Backfill Representa Estado Conhecido

O *Backfill* Inicial responde:

```text
Qual estado da origem podemos estabelecer
no início da ingestão da plataforma?
```

Ele não responde:

```text
Quais foram todos os eventos históricos
que produziram esse estado?
```

Por exemplo, suponha que o *backfill* encontre:

```text
Transaction 5000
Status = COMPLETED
```

A plataforma pode registrar:

```text
estado conhecido
=
COMPLETED
```

Ela não pode reconstruir automaticamente:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

a menos que uma origem histórica autoritativa forneça evidências dessas transições.

Portanto:

> **O *backfill* estabelece o estado conhecido; ele não cria um histórico de eventos inexistente.**

#### 10.1.2 Dados Existentes Continuam Sendo Histórico de Negócio

A ausência de eventos anteriores à captura não torna as linhas existentes na origem analiticamente irrelevantes.

Por exemplo, uma transação concluída meses antes da implementação da plataforma ainda representa dados históricos de vendas válidos.

A plataforma analítica pode, portanto, ingeri-la como:

```text
estado histórico de negócio
```

mantendo metadados que diferenciem sua origem de ingestão da futura captura de alterações.

Conceitualmente:

```text
HISTÓRICO DE NEGÓCIO
        ↓
estado existente na origem
        ↓
INITIAL_BACKFILL
```

versus:

```text
ALTERAÇÃO DE NEGÓCIO
        ↓
observada após o limite de captura
        ↓
CAPTURA CONTÍNUA
```

Esses dois caminhos poderão, posteriormente, convergir para o mesmo modelo analítico *downstream*, preservando proveniências diferentes.

#### 10.1.3 Proveniência Candidata da Ingestão

A plataforma poderá se beneficiar futuramente de metadados que diferenciem como um registro entrou na camada de ingestão.

Semânticas candidatas incluem:

```text
INITIAL_BACKFILL

CDC_STREAM

TIMESTAMP_INCREMENTAL

SNAPSHOT_DIFF

FULL_REFRESH
```

Por exemplo:

```text
ingestion_mode = INITIAL_BACKFILL
```

poderia indicar que uma linha se originou da carga inicial do estado histórico da origem.

Um futuro registro derivado do CDC poderia utilizar:

```text
ingestion_mode = CDC_STREAM
```

Entretanto:

> **Os nomes finais dos metadados ainda não foram implementados nem validados.**

Eles permanecem como candidatos de projeto, e não como evidência da implementação atual.

### 10.2 Limite de Captura

Um limite de captura é o ponto após o qual a plataforma pode confiar no mecanismo contínuo selecionado para identificar novas alterações ou o estado da origem.

Diferentes mecanismos podem representar esse limite de formas distintas.

Conceitualmente:

```text
CDC
→ limite de captura baseado em LSN

Timestamp Incremental
→ limite de watermark

Snapshot + Diff
→ limite do snapshot aceito

Full Refresh Controlado
→ estado aceito da atualização
```

O princípio subjacente é o mesmo:

> **A plataforma deve saber o que pertence ao estado inicial e o que passa a ser observável por meio da captura contínua.**

#### 10.2.1 Limite do CDC

Para o SQL Server CDC:

```text
CDC habilitado
        ↓
instância de captura estabelecida
        ↓
LSN inicial
        ↓
alterações futuras capturadas
```

A implementação atual criou instâncias de captura CDC separadas para:

```text
sales.Transaction
sales.TransactionItem
```

com seus próprios valores de LSN inicial.

O significado arquitetural importante é:

```text
estado anterior ao limite
→ responsabilidade do backfill

alteração capturada após o limite
→ responsabilidade do CDC
```

A semântica exata da janela de consumo do CDC permanece como parte da próxima etapa de implementação.

#### 10.2.2 Limite do Timestamp Incremental

Para *Timestamp* Incremental, o limite será representado por uma *watermark* validada da origem e por um *checkpoint* persistido com segurança.

Conceitualmente:

```text
estado inicial
        ↓
watermark inicial de captura
        ↓
extração incremental
        ↓
checkpoints futuros
```

Esse mecanismo exige cuidado adicional porque valores de *timestamp* podem não fornecer as mesmas garantias de ordenação do *Transaction Log* oferecidas pelos LSNs do CDC.

O algoritmo real de *cutover* deve, portanto, ser comprovado de forma independente quando *Timestamp* Incremental for implementado.

#### 10.2.3 Limite do Snapshot + Diff

Para *Snapshot* + *Diff*, o *snapshot* inicial aceito estabelece a referência inicial.

Conceitualmente:

```text
EXECUÇÃO 1
snapshot da origem
        ↓
baseline aceito
        ↓

EXECUÇÃO 2
novo snapshot da origem
        +
baseline anterior aceito
        ↓
diff
```

Nenhuma alteração é inferida antes que a referência inicial exista.

O primeiro *snapshot*, portanto, representa:

```text
estado atual conhecido
```

e não:

```text
eventos INSERT históricos
```

#### 10.2.4 Limite do Full Refresh Controlado

*Full Refresh* Controlado é orientado a estado.

A primeira atualização validada e concluída com sucesso estabelece o estado autoritativo inicial.

Atualizações aceitas posteriormente substituem ou reconciliam esse estado de acordo com a futura implementação.

Não há requisito para reconstruir um fluxo de eventos entre atualizações, a menos que requisitos futuros de negócio introduzam essa necessidade.

### 10.3 Sobreposição Controlada

Quando o *Backfill* Inicial e a captura contínua se sobrepõem no tempo, a mesma entidade lógica pode ser representada por mais de um caminho de ingestão.

Isso não constitui automaticamente um erro.

Considere:

```text
T0
limite de captura do CDC estabelecido

T1
backfill começa

T2
Transaction 9000 é atualizada

T3
backfill lê Transaction 9000

T4
CDC expõe o UPDATE
```

A plataforma pode receber:

```text
estado do backfill para Transaction 9000
        +
alteração do CDC para Transaction 9000
```

Essa é uma sobreposição controlada.

A alternativa seria:

```text
backfill começa

        ↓

alterações ocorrem

        ↓

CDC habilitado somente após o backfill

        ↓

alterações desaparecem do histórico observável
```

o que cria uma lacuna.

Portanto:

> **O Atlas Engineering prefere sobreposição controlada a lacunas silenciosas.**

#### 10.3.1 Por Que a Sobreposição É Mais Segura

A sobreposição cria um problema de reconciliação.

Uma lacuna cria um problema de dados ausentes.

Conceitualmente:

```text
SOBREPOSIÇÃO
        ↓
dados podem aparecer mais de uma vez
        ↓
podem ser detectados
        ↓
podem ser reconciliados
```

versus:

```text
LACUNA
        ↓
dados nunca são capturados
        ↓
podem permanecer invisíveis
        ↓
podem ser irrecuperáveis
```

A arquitetura mais ampla da plataforma segue:

```text
At-Least-Once
+
Idempotência
```

o que favorece intencionalmente a capacidade de tolerar entregas duplicadas em vez de perder silenciosamente informações necessárias.

A implementação de ponta a ponta desse princípio ainda não foi comprovada.

#### 10.3.2 A Sobreposição Deve Ser Deliberada

Sobreposição controlada não significa:

```text
duplicar tudo
e ignorar a correção
```

A janela de sobreposição deve possuir limites conhecidos.

A plataforma deve, posteriormente, compreender:

```text
o que o backfill abrangeu
```

e:

```text
o que a captura contínua abrangeu
```

para que os dois caminhos possam convergir com segurança.

A lógica exata de reconciliação dependerá de:

- chaves de negócio;
- *timestamps* da origem;
- metadados do CDC;
- metadados de ingestão;
- idempotência *downstream*;
- limites de lote;
- semântica de *checkpoint*.

Essas questões exigem evidências de implementação antes de serem finalizadas.

### 10.4 Limitações do Estado Histórico

O *Backfill* Inicial fornece linhas históricas da origem, mas não necessariamente eventos históricos.

Essa distinção deve permanecer explícita em toda a plataforma.

#### 10.4.1 Linha Histórica Atual Versus Evento Histórico

Suponha que uma transação criada antes da ativação do CDC contenha atualmente:

```text
gross_amount = 150.00
status = COMPLETED
```

A plataforma pode ingerir:

```text
a transação existe historicamente
gross_amount = 150.00
status conhecido atual anterior à captura = COMPLETED
```

Ela não pode afirmar automaticamente:

```text
a transação originalmente tinha gross_amount = 100.00

depois mudou para 120.00

depois mudou para 150.00
```

a menos que esses estados sejam sustentados por outra origem autoritativa.

Da mesma forma, ela não pode inventar transições de status que não foram observadas.

Portanto:

```text
linha histórica
≠
sequência histórica de eventos
```

#### 10.4.2 O Limite de Captura Cria um Limite de Evidência

O limite de captura também é um limite de evidência.

Conceitualmente:

```text
ANTES DA CAPTURA

conhecido a partir do estado atual da origem
        ↓
evidência histórica limitada


APÓS A CAPTURA

observável por meio do mecanismo de captura
        ↓
evidência mais forte das alterações
```

Isso não significa que os dados posteriores ao limite estejam automaticamente corretos de ponta a ponta.

Significa que a plataforma possui um mecanismo definido capaz de observar alterações a partir desse ponto.

#### 10.4.3 Ausência de Evidência Deve Permanecer Ausência de Evidência

Se o histórico anterior à captura for desconhecido:

```text
DESCONHECIDO
```

deve permanecer:

```text
DESCONHECIDO
```

Ele não deve se tornar:

```text
evento inferido
```

apenas para fazer com que um histórico *downstream* pareça completo.

O princípio do Atlas Engineering é:

> **Não preencha lacunas históricas com certezas inventadas.**

### 10.5 Proteja o Futuro Primeiro

A ordem de *cutover* preferida é:

```text
1. preparar a captura contínua
        ↓
2. estabelecer o limite de captura
        ↓
3. verificar se alterações futuras podem ser observadas
        ↓
4. iniciar o Backfill Inicial
        ↓
5. permitir o acúmulo das alterações contínuas
        ↓
6. concluir a extração histórica
        ↓
7. processar as alterações contínuas acumuladas
        ↓
8. reconciliar a sobreposição
        ↓
9. validar a consistência
        ↓
10. entrar no processamento em estado estável
```

A decisão fundamental é a ordem:

```text
CAPTURA PRIMEIRO
        ↓
BACKFILL DEPOIS
```

em vez de:

```text
BACKFILL PRIMEIRO
        ↓
CAPTURA DEPOIS
```

A primeira opção protege as alterações futuras.

### 10.6 Exemplo de Cutover Inseguro

Uma sequência insegura poderia ser:

```text
08:00
backfill começa

08:30
Transaction 100 é alterada
mas o CDC não está ativo

09:00
Transaction 200 é alterada
mas o CDC não está ativo

10:00
backfill termina

10:05
CDC habilitado
```

Agora a plataforma enfrenta um problema.

Se o *backfill* tiver lido a Transaction 100 antes das 08:30, sua alteração posterior poderá não estar presente no *backfill*.

O CDC também não consegue recuperar a alteração porque ainda não estava ativo.

Conceitualmente:

```text
BACKFILL
    │
    ├───────────────┐
                    │
                    ▼
             JANELA DESPROTEGIDA
                    │
                    ▼
                   CDC
```

Alterações dentro dessa janela podem ser perdidas.

Essa é a lacuna silenciosa que a estratégia V1 evita.

### 10.7 Exemplo do Cutover Preferido

O modelo preferido inverte a ordem:

```text
08:00
limite do CDC estabelecido

08:10
backfill começa

08:30
Transaction 100 é alterada
→ CDC captura a alteração futura

09:00
Transaction 200 é alterada
→ CDC captura a alteração futura

10:00
backfill termina

10:05
processar alterações acumuladas no CDC

10:30
reconciliar sobreposição
```

Agora:

```text
backfill
+
CDC
```

podem se sobrepor.

Mas as alterações permanecem observáveis.

O desafio de reconciliação é preferível a uma lacuna irrecuperável.

### 10.8 Backfill Não Precisa Ser em Tempo Real

O *Backfill* Inicial possui características de latência diferentes da ingestão contínua.

A captura transacional contínua pode ter como meta uma latência dos dados medida em minutos.

O *backfill* histórico pode levar consideravelmente mais tempo, dependendo de:

- volume da origem;
- carga de trabalho na origem;
- método de extração;
- *throughput* da rede;
- capacidade de persistência *downstream*;
- controle operacional da taxa de processamento.

Portanto:

```text
LATÊNCIA DOS DADOS NA CAPTURA CONTÍNUA
≠
DURAÇÃO DO BACKFILL
```

O objetivo do *backfill* não é necessariamente ingerir todas as linhas históricas na velocidade de *streaming*.

O objetivo é:

```text
aquisição histórica
completa
controlada
reconciliável
segura para a origem
```

### 10.9 Backfill Deve Proteger a Origem OLTP

A extração histórica pode se tornar uma das cargas de trabalho mais pesadas introduzidas por uma Plataforma de Engenharia de Dados.

Por exemplo:

```text
tabela grande
        ↓
extração histórica completa
        ↓
grande volume de leituras
        ↓
I/O
CPU
pressão de buffer
rede
```

A plataforma não deve tratar o *backfill* como justificativa para sobrecarregar o AtlasCommerce.

O princípio da V1 permanece:

> **A saúde do OLTP possui prioridade sobre a conveniência analítica.**

Possíveis técnicas futuras de implementação podem incluir:

- tamanhos de lote controlados;
- extração por intervalos de chave;
- extração orientada a partições;
- execução em janelas operacionais apropriadas;
- controle da taxa de processamento;
- cópias restauradas do banco de dados para leituras históricas pesadas.

Nenhuma técnica específica deve ser considerada implementada antes de ser testada.

### 10.10 Cópia Restaurada como Opção de Backfill

Para extrações históricas pesadas, uma cópia restaurada do banco de dados pode oferecer uma forma de reduzir a pressão analítica sobre o sistema OLTP ativo.

Conceitualmente:

```text
AtlasCommerce ATIVO
        │
        ├── operação contínua do negócio
        │
        └── captura contínua
              ↓

BACKUP / RESTORE
        ↓
cópia isolada
        ↓
backfill histórico
```

Isso pode separar:

```text
carga de trabalho da varredura histórica
```

de:

```text
carga de trabalho do negócio em produção
```

Entretanto, a cópia restaurada representa um estado em um ponto específico de recuperação.

Sua relação com o limite de captura ativo deve, portanto, ser cuidadosamente coordenada.

Isso permanece como uma possível técnica de implementação, e não como uma decisão atual de implementação da V1.

### 10.11 Ordenação do Backfill

As linhas históricas não precisam necessariamente ser ingeridas na mesma ordem de sua criação original no negócio.

Para a carga de estado analítico, uma extração prática pode utilizar:

```text
intervalo de chave primária
intervalo de partição
data de negócio
```

ou outro método determinístico de segmentação.

Entretanto, a ordenação se torna relevante quando existem:

```text
dependências entre pai / filho
```

ou:

```text
restrições referenciais downstream
```

Para as origens transacionais:

```text
Transaction
        ↓
TransactionItem
```

a implementação *downstream* deve garantir que a ordem de processamento não crie estados analíticos inválidos.

A sequência exata de carga é uma questão de implementação futura.

### 10.12 Segmentação do Backfill

Grandes cargas históricas devem poder ser divididas em unidades controladas.

Conceitualmente:

```text
HISTÓRICO COMPLETO
        ↓
segmento
        ↓
segmento
        ↓
segmento
```

Critérios candidatos de segmentação podem incluir:

```text
intervalos de datas
intervalos de partições
intervalos de chaves primárias
```

O método de segmentação deve oferecer suporte a:

- reinicialização;
- acompanhamento do progresso;
- reconciliação;
- carga controlada na origem;
- tamanhos de lote previsíveis.

Um *backfill* monolítico que precise ser reiniciado desde o início após uma falha é operacionalmente mais fraco do que um processo segmentado com progresso durável.

A estratégia final de segmentação ainda não foi implementada.

### 10.13 Checkpoint do Backfill

O progresso do *backfill* deverá, futuramente, ser representado por um estado durável de *checkpoint*.

Conceitualmente:

```text
Segmento 1
processado com segurança

Segmento 2
processado com segurança

Segmento 3
falha
```

Na reinicialização:

```text
retomar a partir do Segmento 3
```

em vez de:

```text
reiniciar toda a carga histórica
```

Entretanto, o *checkpoint* deve representar:

```text
progresso persistido com segurança
```

e não apenas:

```text
linhas lidas da origem
```

Isso segue o mesmo princípio utilizado pela ingestão contínua:

> **O progresso é confirmado somente depois que a saída governada estiver persistida com garantia de durabilidade.**

O projeto exato do *checkpoint* permanece pendente.

### 10.14 Captura Contínua Durante o Backfill

Depois que o limite de captura futura estiver protegido, as alterações contínuas poderão prosseguir enquanto o *backfill* estiver em execução.

Conceitualmente:

```text
                    ┌── novo INSERT
                    ├── novo UPDATE
ORIGEM ATIVA ───────┼── novo DELETE
                    │
                    ▼
              captura contínua


ESTADO ATIVO / RESTAURADO
        │
        ▼
backfill histórico
```

Isso cria dois fluxos simultâneos:

```text
fluxo do estado histórico
+
fluxo de alterações futuras
```

Posteriormente, eles devem convergir.

A plataforma deve, portanto, ser projetada para compreender a proveniência e a ordenação da origem em nível suficiente para reconciliá-los com segurança.

### 10.15 Exemplo de Sobreposição Controlada

Suponha:

```text
08:00
CDC começa

08:10
backfill começa

08:30
Transaction 500 atualmente:
Status = CONFIRMED

08:40
Transaction 500 muda:
CONFIRMED → COMPLETED
```

Dependendo do momento em que o *backfill* lê a linha, existem dois casos válidos.

Caso A:

```text
Backfill lê antes das 08:40

INITIAL_BACKFILL
Status = CONFIRMED

CDC
UPDATE
CONFIRMED → COMPLETED
```

Isso fornece uma progressão natural.

Caso B:

```text
Backfill lê após as 08:40

INITIAL_BACKFILL
Status = COMPLETED

CDC
UPDATE
CONFIRMED → COMPLETED
```

Agora o *backfill* já contém o estado final representado pelo UPDATE do CDC.

Se o processamento *downstream* aplicar ingenuamente todas as representações sem compreender a sobreposição, poderão ocorrer efeitos duplicados ou temporalmente inconsistentes.

Portanto, o *cutover* exige lógica explícita de reconciliação.

### 10.16 Sobreposição Não Significa que o CDC Deve Ser Descartado

No Caso B anterior, poderia ser tentador concluir:

```text
backfill já contém COMPLETED
portanto descartar o UPDATE do CDC
```

Essa regra seria insegura como premissa geral.

O evento do CDC é uma evidência real posterior ao limite.

O *backfill* é uma observação de estado.

Eles desempenham papéis semânticos diferentes.

A implementação da reconciliação deve determinar:

```text
se o destino downstream é orientado a estado,
orientado a eventos,
ou ambos
```

antes de decidir como as informações sobrepostas serão tratadas.

Nenhuma regra universal de descarte é definida por esta estratégia.

### 10.17 Reconciliação

O *cutover* não está concluído apenas porque:

```text
backfill terminou
```

e:

```text
captura está em execução
```

Os dois fluxos devem ser reconciliados.

Conceitualmente:

```text
BACKFILL INICIAL
        │
        ├──────────┐
        │          │
        ▼          ▼
     estado      zona de
    histórico   sobreposição
                   ▲
                   │
CAPTURA CONTÍNUA ──┘
        │
        ▼
alterações futuras
```

A reconciliação deverá, posteriormente, responder a perguntas como:

```text
Todas as linhas esperadas da origem chegaram?

Alguma alteração foi perdida?

Os registros sobrepostos foram processados com segurança?

O estado downstream corresponde ao estado da origem?

O processamento pode ser reinicializado a partir do checkpoint estabelecido?
```

As consultas e os procedimentos exatos de reconciliação permanecem como questões de implementação.

### 10.18 Contagens São Úteis, mas Não Suficientes

Contagens de linhas fornecem evidências úteis durante o *backfill*.

Por exemplo:

```text
Linhas de Transaction na origem
=
6306

Linhas de TransactionItem na origem
=
13769
```

Uma comparação de contagens *downstream* pode ajudar a identificar linhas ausentes ou inesperadas.

Entretanto:

```text
mesma contagem de linhas
```

não comprova:

```text
mesmos dados
```

Por exemplo:

```text
Origem
A B C

Downstream
A B D
```

Ambos contêm:

```text
3 linhas
```

mas seu conteúdo é diferente.

Portanto, a reconciliação poderá exigir:

```text
contagem de linhas
+
comparação de chaves
+
comparação de agregados
+
verificações direcionadas dos dados
+
hashes potenciais
```

dependendo da implementação.

### 10.19 Agregados de Negócio como Evidência de Reconciliação

Para dados transacionais, agregados em nível de negócio podem complementar as contagens técnicas de linhas.

Possíveis comparações futuras podem incluir:

```text
contagem de transações por data
contagem de itens por data
totais de valor bruto
totais de descontos
distribuição por status
distribuição por canal
```

Essas verificações podem detectar divergências que uma única contagem geral de linhas talvez não exponha.

Entretanto, a lógica de reconciliação de negócio deve respeitar a semântica exata da origem e do modelo *downstream*.

A especificação final de reconciliação ainda será desenvolvida.

### 10.20 Critérios de Conclusão do Cutover

Um *backfill* não deve ser considerado concluído apenas porque o processo de extração terminou com sucesso.

Conceitualmente, a conclusão do *cutover* deve exigir evidências de que:

```text
o estado histórico da origem foi adquirido
        +
a captura futura permaneceu protegida
        +
as alterações acumuladas foram processadas
        +
a sobreposição foi reconciliada
        +
o estado downstream foi validado
        +
o checkpoint foi estabelecido com segurança
```

Somente então a origem poderá passar para:

```text
ESTADO ESTÁVEL
```

### 10.21 Estado Estável

Após um *cutover* bem-sucedido:

```text
Backfill Inicial
```

torna-se uma operação histórica concluída.

A plataforma passa então a depender principalmente do mecanismo de captura contínua selecionado.

Para as origens transacionais com alto volume de alterações:

```text
consumo do CDC
```

se tornará o principal caminho para alterações futuras.

Para as demais categorias de origem:

```text
Timestamp Incremental

Snapshot + Diff

Full Refresh Controlado
```

fornecerão seus respectivos padrões de aquisição em estado estável quando forem implementados.

Conceitualmente:

```text
FASE INICIAL

backfill
+
captura contínua
        ↓
reconciliar
        ↓

ESTADO ESTÁVEL

mecanismo de captura contínua
```

### 10.22 Recuperação Durante o Cutover

Falhas podem ocorrer enquanto o *backfill* e a captura contínua estiverem sendo executados simultaneamente.

Por exemplo:

```text
backfill falha
CDC continua
```

Isso não é necessariamente catastrófico.

Se o limite de captura permanecer protegido e as alterações necessárias continuarem dentro da janela de recuperação:

```text
backfill pode ser reinicializado
+
alterações do CDC permanecem disponíveis
```

Esse é um dos motivos pelos quais a retenção do CDC e a estratégia de *cutover* estão relacionadas.

A janela atual de recuperação do CDC na V1 é:

```text
15 dias
```

o que fornece tempo operacional para investigação, correção e reprocessamento.

Entretanto:

> **A retenção fornece uma oportunidade de recuperação; ela não implementa a recuperação automaticamente.**

Os mecanismos de *checkpoint*, *replay*, sobreposição e reinicialização ainda precisam ser implementados e testados.

### 10.23 Cleanup do CDC Durante o Backfill

Como a retenção do CDC é finita, um *backfill* excessivamente longo poderia, teoricamente, fazer com que alterações capturadas no início se aproximassem do limite de *cleanup* antes de serem processadas.

Conceitualmente:

```text
limite do CDC
        ↓
alterações se acumulam
        ↓
backfill continua por um longo período
        ↓
janela de retenção avança
        ↓
alterações antigas tornam-se elegíveis para limpeza
```

Portanto, o planejamento do *cutover* deve considerar:

```text
duração do backfill
versus
retenção da captura
```

A janela atual de recuperação de 15 dias fornece margem operacional, mas não deve ser tratada como tempo ilimitado.

Um futuro procedimento de *backfill* deve monitorar sua relação com o intervalo disponível do CDC.

### 10.24 O Limite de Captura Deve Ser Registrado

Um limite de *cutover* que exista apenas na memória do operador é operacionalmente frágil.

A implementação deve registrar metadados suficientes para estabelecer:

```text
quando a proteção da captura começou

qual origem estava envolvida

qual mecanismo de captura foi utilizado

qual limite inicial foi aplicado

qual intervalo de backfill foi processado

qual checkpoint foi aceito

quando a reconciliação foi concluída
```

Essas informações oferecem suporte a:

- reinicialização;
- *troubleshooting*;
- auditoria;
- reconciliação;
- transferência operacional.

O *schema* exato dos metadados ainda será projetado.

### 10.25 Backfill Deve Ser Repetível

Um procedimento robusto de ingestão histórica deve ser repetível.

Isso não significa que execuções repetidas devam duplicar dados lógicos.

Significa:

```text
mesmo intervalo histórico governado
        ↓
pode ser processado novamente
        ↓
sem corromper o estado downstream
```

Possíveis motivos para reprocessamento incluem:

```text
correção de pipeline
correção de schema
defeito de transformação
incidente de armazenamento
correção de qualidade de dados
divergência na reconciliação
```

Esse requisito reforça a importância de um comportamento *downstream* idempotente.

### 10.26 Backfill e Bronze

Na arquitetura V1 mais ampla, Bronze deverá se tornar a ingestão histórica durável.

Conceitualmente:

```text
INITIAL_BACKFILL
        ↓
Bronze

CAPTURA CONTÍNUA
        ↓
Bronze
```

Bronze poderá, portanto, tornar-se o ponto de convergência no qual:

```text
aquisição do estado histórico da origem
```

e:

```text
aquisição de alterações futuras
```

sejam retidas de forma durável com a proveniência apropriada.

Essa é uma direção arquitetural.

A persistência em Bronze ainda não foi implementada nem comprovada.

### 10.27 Backfill Não Estende o CDC para o Passado

*Backfill* Inicial e CDC se complementam, mas um não altera a capacidade histórica do outro.

Conceitualmente:

```text
BACKFILL
não cria eventos históricos do CDC
```

e:

```text
CDC
não reconstrói o histórico anterior à habilitação
```

Juntos, eles fornecem:

```text
estado conhecido anterior ao limite
+
alteração observável posterior ao limite
```

Esse é o modelo pretendido para a V1.

### 10.28 Cutover Específico de Cada Mecanismo Deve Ser Testado

O princípio geral:

```text
proteger o futuro
depois carregar o passado
```

aplica-se aos diferentes mecanismos de captura.

Entretanto, a implementação não é idêntica.

Por exemplo:

```text
CDC
→ limite por LSN

Timestamp Incremental
→ limite por timestamp / checkpoint

Snapshot + Diff
→ snapshot inicial aceito

Full Refresh Controlado
→ estado atual inicial aceito
```

Portanto, o comportamento bem-sucedido do *cutover* com CDC não comprova automaticamente a correção do *cutover* com *Timestamp* Incremental.

Cada mecanismo exige seus próprios testes controlados.

### 10.29 Testes Candidatos de Validação do Cutover

Uma futura implementação de *cutover* deve validar pelo menos:

```text
01. LIMITE DE CAPTURA
    A proteção das alterações futuras
    é estabelecida antes do backfill?

02. CONTAGEM INICIAL DA ORIGEM
    O escopo da extração histórica
    é conhecido?

03. INSERT NO BACKFILL
    As linhas existentes na origem
    podem ser adquiridas com sucesso?

04. ALTERAÇÃO DURANTE O BACKFILL
    Um UPDATE na origem ocorrido
    durante o backfill continua observável?

05. NOVA LINHA DURANTE O BACKFILL
    Um INSERT posterior ao limite
    está protegido?

06. DELETE DURANTE O BACKFILL
    Um DELETE posterior ao limite
    está protegido quando necessário?

07. SOBREPOSIÇÃO
    Uma linha que aparece nos dois
    caminhos pode ser reconciliada com segurança?

08. FALHA
    O backfill pode ser reinicializado sem
    perder a continuidade da captura?

09. CHECKPOINT
    O progresso é persistido somente
    após a conclusão durável?

10. RETENÇÃO
    O intervalo de captura necessário
    permanece disponível durante o cutover?

11. PROTEÇÃO DA ORIGEM
    O backfill permanece operacionalmente
    aceitável para o AtlasCommerce?

12. RECONCILIAÇÃO
    As verificações técnicas e de negócio
    sustentam a consistência downstream?

13. REINICIALIZAÇÃO
    Um cutover com falha pode ser retomado
    sem reinicializações desnecessárias?

14. CONCLUSÃO
    Existe evidência explícita
    de que o estado estável pode começar?
```

Esses testes permanecem pendentes.

### 10.30 Estado Atual da Validação

O estado atual da V1 é:

```text
PRINCÍPIO ARQUITETURAL
Proteja o futuro primeiro
e, depois, carregue o passado
→ Aprovado

SOBREPOSIÇÃO CONTROLADA
preferida a uma lacuna silenciosa
→ Aprovado

HISTÓRICO ANTERIOR AO CDC
não deve ser inventado
→ Aprovado

COMPORTAMENTO DO ESTADO INICIAL DO CDC
linhas existentes não são
automaticamente carregadas no CDC
→ evidência obtida no lado da origem

IMPLEMENTAÇÃO DO BACKFILL INICIAL
→ Pendente

CHECKPOINT DO BACKFILL
→ Pendente

REINICIALIZAÇÃO DO BACKFILL
→ Pendente

RECONCILIAÇÃO DA SOBREPOSIÇÃO
→ Pendente

CUTOVER DE PONTA A PONTA
→ Pendente
```

Portanto, a arquitetura definiu a estratégia de *cutover*, enquanto o procedimento operacional completo ainda precisa ser implementado e validado.

### 10.31 Resumo da Estratégia

A Estratégia V1 de *Backfill* Inicial e *Cutover* pode ser resumida como:

```text
PROBLEMA
Origem já contém dados
enquanto alterações futuras continuam

ESTADO INICIAL
Carregar por meio do Backfill Inicial

ALTERAÇÕES FUTURAS
Proteger por meio da captura contínua

REGRA PRINCIPAL
Proteja o futuro primeiro
e, depois, carregue o passado

LIMITE DE CAPTURA
Deve ser estabelecido antes
do início da carga histórica

MODO DE FALHA PREFERIDO
Sobreposição controlada
em vez de lacuna silenciosa

HISTÓRICO ANTERIOR À CAPTURA
Não inventar eventos

SIGNIFICADO DO BACKFILL
Estado histórico conhecido da origem

SIGNIFICADO DA CAPTURA CONTÍNUA
Alteração observável posterior ao limite
ou novo estado aceito

OLTP
Deve permanecer protegido

CHECKPOINT
Deve representar progresso durável

RECONCILIAÇÃO
Obrigatória antes da conclusão do cutover

ESTADO ESTÁVEL
Começa somente depois que backfill,
captura, sobreposição e validação
tiverem convergido

VALIDAÇÃO ATUAL
Estratégia definida
comportamento do CDC no lado da origem
quanto à ausência de backfill comprovado
implementação completa do cutover pendente
```

O princípio que rege essa estratégia é:

> **Um *cutover* seguro aceita duplicação controlada quando necessário para evitar a perda de alterações que nunca poderão ser recuperadas.**

O princípio de evidência é:

> **O *backfill* nos informa o que estava presente; a captura contínua nos informa o que observamos mudar após o limite. Nenhum dos dois pode inventar o outro.**

---

## 11. Matriz da Estratégia de Captura

A Matriz da Estratégia de Captura consolida as decisões de captura da V1 para as tabelas de origem atualmente incluídas no domínio inicial de Sales Analytics.

Seu objetivo é fornecer uma visão única e passível de revisão de:

```text
origem
classificação
mecanismo de captura
requisito de alteração
requisito de DELETE
dependência de watermark
orientação da captura
estado da validação
```

A matriz é um resumo das decisões arquiteturais.

Ela não deve ser interpretada como evidência de que todos os mecanismos já tenham sido implementados ou comprovados operacionalmente.

A distinção que rege essa interpretação permanece:

```text
SELECIONADO
        ≠
IMPLEMENTADO
        ≠
TESTADO
        ≠
COMPROVADO DE PONTA A PONTA
```

### 11.1 Matriz da Estratégia de Captura V1

| Origem | Classificação | Mecanismo Selecionado | Principal Pergunta de Captura | INSERT | UPDATE | DELETE Físico | Dependência de Watermark | Orientação da Captura | Estado Atual da Validação |
|---|---|---|---|---|---|---|---|---|---|
| `sales.Transaction` | A — Alto Volume de Alterações | SQL Server Native CDC | O que mudou? | Obrigatório | Obrigatório | Obrigatório | Nenhuma *watermark* de *timestamp* necessária | Orientada a alterações | Comportamento do CDC no lado da origem validado até M01.19 |
| `sales.TransactionItem` | A — Alto Volume de Alterações | SQL Server Native CDC | O que mudou? | Obrigatório | Obrigatório | Obrigatório | Nenhuma *watermark* de *timestamp* necessária | Orientada a alterações | Comportamento do CDC no lado da origem validado até M01.19 |
| `catalog.Product` | B — Alterações Ocasionais | *Timestamp* Incremental | Quais linhas atuais indicam que foram alteradas? | Esperado como obrigatório | Esperado como obrigatório | Não fornecido inerentemente pelo mecanismo | *Watermark* confiável necessária | Estado atual alterado | Validação da implementação pendente |
| `catalog.ProductVariant` | B — Alterações Ocasionais | *Timestamp* Incremental | Quais linhas atuais indicam que foram alteradas? | Esperado como obrigatório | Esperado como obrigatório | Não fornecido inerentemente pelo mecanismo | *Watermark* confiável necessária | Estado atual alterado | Validação da implementação pendente |
| `catalog.Brand` | B — Alterações Ocasionais | *Timestamp* Incremental | Quais linhas atuais indicam que foram alteradas? | Esperado como obrigatório | Esperado como obrigatório | Não fornecido inerentemente pelo mecanismo | *Watermark* confiável necessária | Estado atual alterado | Validação da implementação pendente |
| `catalog.Category` | B — Alterações Ocasionais | *Timestamp* Incremental | Quais linhas atuais indicam que foram alteradas? | Esperado como obrigatório | Esperado como obrigatório | Não fornecido inerentemente pelo mecanismo | *Watermark* confiável necessária | Estado atual alterado | Validação da implementação pendente |
| `catalog.ProductCategory` | D — Baixo Volume de Alterações / Sem Watermark | *Snapshot* + *Diff* | O que é diferente entre o estado anterior e o atual? | Derivado como ADICIONADO | Atualmente não modelado como UPDATE em nível de linha | Derivado como REMOVIDO | Não | Comparação de estados | Validação da implementação pendente |
| `sales.TransactionStatus` | C — Referência | *Full Refresh* Controlado | Qual é o estado atual autoritativo? | Refletido no estado atualizado | Refletido no estado atualizado | Refletido como ausência no estado atual, e não como evento | Não | Orientada ao estado atual | Validação da implementação pendente |
| `sales.TransactionChannel` | C — Referência | *Full Refresh* Controlado | Qual é o estado atual autoritativo? | Refletido no estado atualizado | Refletido no estado atualizado | Refletido como ausência no estado atual, e não como evento | Não | Orientada ao estado atual | Validação da implementação pendente |

### 11.2 Como Interpretar Corretamente a Matriz

A matriz utiliza deliberadamente terminologia diferente para mecanismos diferentes.

Para CDC:

```text
INSERT
UPDATE
DELETE
```

representam alterações capturadas na origem.

Para *Timestamp* Incremental:

```text
INSERT
UPDATE
```

significam que se espera que linhas atuais recém-criadas ou modificadas se tornem detectáveis por meio de uma *watermark* validada.

Isso não equivale à captura de todos os eventos da origem.

Para *Snapshot* + *Diff*:

```text
ADICIONADO
REMOVIDO
```

são derivados pela comparação de estados aceitos.

Eles não representam necessariamente eventos INSERT e DELETE observados na origem.

Para *Full Refresh* Controlado:

```text
adicionado
alterado
removido
```

são representados por meio do novo estado atual autoritativo.

O mecanismo não preserva inerentemente as operações individuais que produziram esse estado.

Portanto:

> **Resultados *downstream* semelhantes não implicam evidências idênticas na origem.**

### 11.3 Modelo Mental dos Mecanismos

A matriz V1 pode ser resumida por quatro perguntas:

```text
CDC
→ O que aconteceu?

Timestamp Incremental
→ Quais linhas indicam que foram alteradas?

Snapshot + Diff
→ O que é diferente?

Full Refresh Controlado
→ Qual é o estado atual?
```

Essas perguntas descrevem o modelo fundamental de evidência de cada mecanismo.

### 11.4 Origens Transacionais

O núcleo transacional utiliza:

```text
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC
```

A seleção reflete o requisito atual de:

```text
captura de alto volume de alterações
+
visibilidade de INSERT
+
visibilidade de UPDATE
+
visibilidade de DELETE físico
+
contexto transacional no lado da origem
+
proteção do OLTP
```

Atualmente, existem evidências de implementação no lado da origem até:

```text
M01.19
```

Isso inclui evidências controladas de:

```text
INSERT
UPDATE BEFORE / AFTER
múltiplos comandos em uma única transação SQL
DELETE físico
contexto transacional entre tabelas
efeitos de ON DELETE CASCADE
```

Essas evidências validam comportamentos importantes do CDC no lado da origem.

Elas não validam a arquitetura *downstream* completa.

### 11.5 Origens Descritivas

As seguintes origens descritivas utilizam a hipótese V1 de *Timestamp* Incremental:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

A seleção pressupõe que uma *watermark* confiável possa expor as alterações necessárias no estado atual das linhas sem a complexidade operacional adicional do CDC.

Entretanto, os seguintes pontos permanecem pendentes:

```text
semântica real da watermark
responsabilidade pelo timestamp
precisão
comportamento dos limites
tratamento de timestamps iguais
comportamento da visibilidade após COMMIT
requisito de DELETE físico
implementação do checkpoint
comportamento da reinicialização
desempenho da consulta na origem
```

Portanto, a matriz os descreve intencionalmente como:

```text
Validação da implementação pendente
```

em vez de:

```text
Validado
```

### 11.6 Origem de Relacionamento

A origem de relacionamento:

```text
catalog.ProductCategory
```

utiliza:

```text
Snapshot + Diff
```

porque nenhuma *watermark* de *timestamp* confiável foi identificada na estrutura atual.

Sua identidade de comparação baseia-se atualmente em:

```text
PRDCT_PRD_id
+
PRDCT_CTG_id
```

O mecanismo deriva:

```text
ADICIONADO
=
Atual - Anterior
```

e:

```text
REMOVIDO
=
Anterior - Atual
```

A estratégia não afirma que observa os eventos INSERT ou DELETE exatos que produziram essas diferenças de estado.

A validação da implementação permanece pendente.

### 11.7 Origens de Referência

As origens de referência:

```text
sales.TransactionStatus
sales.TransactionChannel
```

utilizam:

```text
Full Refresh Controlado
```

porque o requisito atual da V1 é o estado atual autoritativo, e não o histórico em nível de evento.

O estado atualmente observado na origem é:

```text
TransactionStatus
1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

e:

```text
TransactionChannel
1 ONLINE
2 STORE
```

Esses valores representam o inventário atualmente conhecido da origem.

Eles não estabelecem limites permanentes para a quantidade de linhas.

Por exemplo:

```text
2 canais observados atualmente
```

não significa:

```text
exatamente 2 canais são permitidos para sempre
```

Uma alteração futura legítima na origem deve continuar sendo possível.

### 11.8 Semântica de DELETE por Mecanismo

O comportamento de DELETE difere significativamente entre os quatro mecanismos.

#### CDC

```text
DELETE físico na origem
        ↓
alteração DELETE capturada
```

Para as origens transacionais, esse comportamento foi demonstrado em testes controlados do SQL Server CDC.

#### Timestamp Incremental

```text
linha excluída fisicamente
        ↓
linha desaparece
        ↓
consulta por timestamp não possui
linha para recuperar
```

Portanto:

```text
DELETE físico
```

não é fornecido inerentemente por *Timestamp* Incremental.

Se a visibilidade de DELETE se tornar obrigatória para uma origem da Categoria B, a estratégia deverá ser revisada ou complementada.

#### Snapshot + Diff

```text
relacionamento existia anteriormente
        +
não existe atualmente
        ↓
REMOVIDO
```

Isso deriva o desaparecimento por meio da comparação de estados.

Não comprova o evento DELETE exato ocorrido na origem.

#### Full Refresh Controlado

```text
valor existia anteriormente
        +
não está presente no novo estado autoritativo
        ↓
estado atual downstream reflete a ausência
```

Novamente, trata-se de reconciliação de estado, e não de captura de evento.

### 11.9 Matriz de Dependência de Watermark

Os mecanismos diferem na forma como representam o progresso da captura.

| Mecanismo | Conceito Principal de Limite | Timestamp Confiável Necessário |
|---|---|---|
| SQL Server Native CDC | Intervalo de LSN do CDC | Não |
| *Timestamp* Incremental | *Watermark* da origem + *checkpoint* da plataforma | Sim |
| *Snapshot* + *Diff* | *Snapshot* anteriormente aceito | Não |
| *Full Refresh* Controlado | Estado da atualização anteriormente aceita | Não |

Essa distinção é importante porque:

```text
LSN
timestamp
snapshot
estado da atualização
```

não são conceitos intercambiáveis.

Cada mecanismo exige sua própria semântica de progresso e recuperação.

### 11.10 Matriz de Fidelidade das Alterações

Os mecanismos também diferem na quantidade de detalhes históricos sobre alterações que podem fornecer.

| Mecanismo | Fidelidade das Alterações |
|---|---|
| SQL Server Native CDC | Alterações capturadas na origem após o limite do CDC |
| *Timestamp* Incremental | Linhas atuais que indicam alteração após o limite da *watermark* |
| *Snapshot* + *Diff* | Diferença líquida entre dois estados aceitos |
| *Full Refresh* Controlado | Estado atual autoritativo no momento da atualização |

Conceitualmente:

```text
CDC

Estado A
  ↓
Alteração 1
  ↓
Estado B
  ↓
Alteração 2
  ↓
Estado C

Potencialmente observável:
Alteração 1
Alteração 2
```

versus:

```text
Timestamp Incremental

Estado A
  ↓
múltiplas alterações na origem
  ↓
Estado C

Potencialmente observável:
linha atual alterada = Estado C
```

versus:

```text
Snapshot + Diff

Snapshot A
  ↓
atividade intermediária
  ↓
Snapshot C

Observável:
A vs C
```

versus:

```text
Full Refresh

Atualização A
  ↓
atividade na origem
  ↓
Atualização C

Observável:
estado autoritativo C
```

Portanto:

> **O mecanismo de captura determina não apenas como os dados são adquiridos, mas também que tipo de evidência histórica pode existir.**

### 11.11 Comportamento do Estado Inicial

Os mecanismos também diferem na forma como tratam os dados que já existem quando a captura começa.

| Mecanismo | Tratamento do Estado Inicial |
|---|---|
| SQL Server Native CDC | *Backfill* Inicial separado é necessário; o CDC não captura retroativamente as linhas existentes |
| *Timestamp* Incremental | Carga inicial do estado da origem necessária antes do processamento incremental em estado estável |
| *Snapshot* + *Diff* | Primeiro *snapshot* estabelece a referência inicial |
| *Full Refresh* Controlado | Primeira atualização validada estabelece o estado autoritativo |

Nenhum desses mecanismos pode inventar eventos históricos que nunca foram observados.

### 11.12 Considerações de Recuperação

Cada mecanismo possui uma dependência de recuperação diferente.

#### CDC

A recuperação depende de:

```text
intervalo disponível do CDC
+
checkpoint do consumidor
+
janela de retenção
+
correção do replay
```

A decisão de retenção do CDC na V1 é:

```text
15 dias
```

#### Timestamp Incremental

A recuperação dependerá de:

```text
checkpoint confiável e persistido
+
semântica segura dos limites
+
capacidade de reler a origem
+
processamento downstream idempotente
```

A validação da implementação está pendente.

#### Snapshot + Diff

A recuperação depende de:

```text
snapshot anteriormente aceito
+
snapshot candidato
+
nova tentativa segura
+
processamento idempotente do diff
```

A validação da implementação está pendente.

#### Full Refresh Controlado

A recuperação depende principalmente de:

```text
preservação do estado anteriormente aceito
+
atualização candidata segura
+
promoção controlada
```

A validação da implementação está pendente.

### 11.13 Comparação da Complexidade Operacional

Os mecanismos possuem deliberadamente diferentes níveis de complexidade operacional.

Conceitualmente:

```text
CDC
        ↓
maior complexidade da infraestrutura de captura

Timestamp Incremental
        ↓
complexidade de watermark e checkpoint

Snapshot + Diff
        ↓
complexidade de armazenamento
e comparação de estados

Full Refresh Controlado
        ↓
menor complexidade de captura
para pequenos conjuntos de dados de referência
```

Isso não deve ser interpretado como uma classificação universal.

Por exemplo, *Snapshot* + *Diff* aplicado a uma tabela extremamente grande poderia se tornar operacionalmente caro.

Da mesma forma, *Full Refresh* Controlado aplicado a uma origem de grande porte poderia se tornar inadequado.

A matriz atual reflete as características e os requisitos das origens atuais da V1.

### 11.14 Visão de Proteção do OLTP

Os mecanismos selecionados também refletem o princípio:

> **A saúde do sistema OLTP possui prioridade sobre a conveniência analítica.**

Conceitualmente:

```text
DADOS TRANSACIONAIS COM
ALTO VOLUME DE ALTERAÇÕES
        ↓
evitar varreduras analíticas repetidas
        ↓
CDC
```

```text
ALTERAÇÕES DESCRITIVAS OCASIONAIS
        ↓
leituras incrementais potencialmente direcionadas
        ↓
Timestamp Incremental
```

```text
PEQUENO ESTADO DE RELACIONAMENTO
COM BAIXO VOLUME DE ALTERAÇÕES
        ↓
comparação viável do estado completo
        ↓
Snapshot + Diff
```

```text
ESTADO DE REFERÊNCIA MUITO PEQUENO
        ↓
extração completa operacionalmente razoável
        ↓
Full Refresh Controlado
```

O custo exato na origem dos mecanismos pendentes ainda deve ser medido durante a implementação.

### 11.15 Modelo de Estado da Validação

O Atlas Engineering utiliza a seguinte progressão:

```text
HIPÓTESE
        ↓
SELECIONADO
        ↓
IMPLEMENTADO
        ↓
TESTADO
        ↓
VALIDADO
        ↓
COMPROVADO DE PONTA A PONTA
```

Nem todas as origens estão atualmente no mesmo estágio.

Para a estratégia de captura V1 atual:

```text
sales.Transaction
sales.TransactionItem

Selecionado
Implementado no lado da origem
Testado no lado da origem até M01.19
Ainda não comprovado de ponta a ponta
```

enquanto:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category

Selecionado como hipótese de Timestamp Incremental
Implementação pendente
```

e:

```text
catalog.ProductCategory

Selecionado como Snapshot + Diff
Implementação pendente
```

e:

```text
sales.TransactionStatus
sales.TransactionChannel

Selecionado como Full Refresh Controlado
Implementação pendente
```

Isso impede que a matriz apresente intenção arquitetural como fato operacional.

### 11.16 Limite de Ponta a Ponta

Nenhuma das origens de captura atuais deve ser marcada como:

```text
Comprovada de Ponta a Ponta
```

neste estágio.

Mesmo as origens com CDC ainda exigem validação futura de:

```text
consumo do CDC
checkpoint
reinicialização
replay
Debezium
Kafka
persistência em Bronze
idempotência
reconciliação
recuperação
escala
SLO de latência dos dados
```

Portanto:

```text
COMPORTAMENTO DO CDC
NA ORIGEM VALIDADO
```

não deve ser reescrito como:

```text
PIPELINE DE ENGENHARIA
DE DADOS VALIDADO
```

Este último exige evidências de todo o caminho *downstream*.

### 11.17 Gatilhos para Revisão da Matriz

A Matriz da Estratégia de Captura deve ser revisada quando qualquer condição relevante da origem mudar.

Exemplos incluem:

```text
volume da origem aumenta significativamente

frequência de alterações aumenta

requisito de latência muda

DELETE físico torna-se analiticamente importante

watermark considerada confiável
demonstra não ser confiável

novas colunas são introduzidas na origem

semântica das chaves da origem muda

histórico das referências passa a ser necessário

extração de snapshot torna-se cara

sobrecarga operacional do CDC torna-se inaceitável

surgem novos requisitos de recuperação

requisitos do produto de dados downstream mudam
```

Um mecanismo não é permanente simplesmente porque era adequado para a V1.

### 11.18 Avaliação de Nova Origem

Origens futuras não devem ser adicionadas à matriz simplesmente copiando o mecanismo de uma tabela aparentemente semelhante.

Cada origem deve passar pelos critérios de seleção definidos no Capítulo 5.

Conceitualmente:

```text
NOVA ORIGEM
    ↓
compreender o papel de negócio
    ↓
classificar o comportamento das alterações
    ↓
avaliar os sete critérios
    ↓
identificar mecanismo candidato
    ↓
documentar premissas
    ↓
implementar
    ↓
testar
    ↓
atualizar matriz com evidências
```

Portanto:

> **A matriz é o resultado da análise, e não um substituto para a análise.**

### 11.19 Visão Consolidada da V1

A distribuição completa das origens na V1 é:

```text
A — ALTO VOLUME DE ALTERAÇÕES
────────────────────────────────────
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC


B — ALTERAÇÕES OCASIONAIS
────────────────────────────────────
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
Timestamp Incremental
        ↓
validação da watermark pendente


C — REFERÊNCIA
────────────────────────────────────
sales.TransactionStatus
sales.TransactionChannel
        ↓
Full Refresh Controlado


D — BAIXO VOLUME DE ALTERAÇÕES / SEM WATERMARK
────────────────────────────────────
catalog.ProductCategory
        ↓
Snapshot + Diff
```

Ou, sob a perspectiva dos mecanismos:

```text
SQL Server Native CDC
├── sales.Transaction
└── sales.TransactionItem


Timestamp Incremental
├── catalog.Product
├── catalog.ProductVariant
├── catalog.Brand
└── catalog.Category


Snapshot + Diff
└── catalog.ProductCategory


Full Refresh Controlado
├── sales.TransactionStatus
└── sales.TransactionChannel
```

### 11.20 Resumo da Matriz

A matriz V1 estabelece:

```text
NÃO EXISTE UM MECANISMO
DE CAPTURA UNIVERSAL
```

Em vez disso:

```text
características da origem
+
requisitos analíticos
+
requisito de fidelidade das alterações
+
requisito de DELETE
+
capacidade de watermark
+
latência
+
volume
+
proteção do OLTP
+
custo operacional
        ↓
mecanismo de captura apropriado
```

A estratégia produz deliberadamente uma camada de captura heterogênea.

Isso não representa inconsistência arquitetural.

É o resultado da aplicação dos mesmos princípios de decisão a origens com comportamentos diferentes.

O princípio que rege essa abordagem é:

> **Um único domínio analítico não exige um único mecanismo de captura.**

E o princípio de evidência é:

> **A matriz registra o que foi selecionado e o que foi efetivamente validado; ela nunca deve reduzir esses dois estados a um só.**

---

## 12. Trade-offs e Limitações Aceitas

A Estratégia de Captura V1 aceita intencionalmente uma série de limitações.

Essas limitações não são defeitos não documentados.

Elas são consequências de decisões arquiteturais deliberadas, tomadas para equilibrar:

```text
correção
+
simplicidade operacional
+
proteção da origem
+
capacidade de recuperação
+
escopo da implementação
```

O objetivo da V1 não é maximizar a fidelidade da captura para todas as origens.

O objetivo é utilizar um mecanismo apropriado para cada origem, tornando explícitas as consequências dessa escolha.

Este capítulo registra essas consequências.

O princípio que rege essa abordagem é:

> **Uma limitação é aceitável somente quando é compreendida, documentada e consistente com o requisito atual.**

### 12.1 A Heterogeneidade da Captura É Intencional

O Atlas Engineering não utiliza um único mecanismo de captura universal.

A estratégia V1 contém:

```text
SQL Server Native CDC
Timestamp Incremental
Snapshot + Diff
Full Refresh Controlado
```

Isso introduz heterogeneidade arquitetural.

Diferentes mecanismos exigem diferentes:

```text
limites
checkpoints
modelos de recuperação
tratamento de falhas
procedimentos de teste
monitoramento operacional
```

Uma arquitetura mais uniforme poderia parecer conceitualmente mais simples.

Por exemplo:

```text
CDC em todos os lugares
```

reduziria a quantidade de padrões de captura.

Entretanto, também introduziria infraestrutura de CDC onde a captura em nível de alteração não é atualmente necessária.

Da mesma forma:

```text
Full Refresh em todos os lugares
```

reduziria a diversidade de mecanismos, mas poderia criar cargas desnecessárias sobre a origem e fornecer fidelidade insuficiente das alterações para tabelas transacionais.

Portanto, a V1 aceita:

```text
mais de um padrão de captura
```

em troca de:

```text
melhor alinhamento entre
o comportamento da origem e o mecanismo
```

O *trade-off* aceito é:

> **A uniformidade da camada de captura é sacrificada quando necessário para evitar complexidade desnecessária ou correção insuficiente.**

### 12.2 A Retenção do CDC É Finita

A janela de recuperação do CDC na V1 é:

```text
15 dias
21600 minutos
```

Isso significa que o SQL Server CDC não retém indefinidamente as alterações da origem.

Dados capturados mais antigos do que a janela de retenção configurada podem se tornar elegíveis para *cleanup*.

Portanto:

```text
CDC
≠
armazenamento histórico permanente
```

A limitação aceita é que a recuperação diretamente a partir do SQL Server CDC possui um limite de tempo.

Se um consumidor *downstream* permanecer indisponível além do intervalo recuperável do CDC antes que as alterações relevantes sejam adquiridas de forma durável em outro local, essas alterações poderão deixar de estar disponíveis no CDC.

A arquitetura mitiga esse risco planejando camadas *downstream* duráveis, como:

```text
Kafka
Bronze
```

mas essas etapas ainda não foram implementadas e validadas de ponta a ponta.

Portanto:

> **A janela de 15 dias oferece uma oportunidade de recuperação, e não recuperação ilimitada.**

### 12.3 O CDC Não Reconstrói o Histórico Anterior à Habilitação

O SQL Server CDC começa a partir de seu limite de captura estabelecido.

As linhas existentes não são transformadas retroativamente em eventos históricos do CDC.

As evidências de implementação já demonstraram:

```text
linhas existiam na origem
+
a nova Change Table do CDC
não continha eventos históricos automáticos
```

para:

```text
sales.Transaction
sales.TransactionItem
```

Portanto, a V1 aceita que:

```text
histórico de eventos anterior ao CDC
```

não pode ser reconstruído a partir do próprio CDC.

Em vez disso, a plataforma utilizará:

```text
Backfill Inicial
```

para estabelecer o estado conhecido da origem anterior ao limite.

A limitação aceita é:

> **Linhas históricas de negócio podem ser carregadas, mas sequências históricas de eventos que nunca foram capturadas não devem ser inventadas.**

### 12.4 O Backfill Fornece Estado, Não a Evolução Histórica Completa

O *Backfill* Inicial pode recuperar:

```text
o conteúdo da linha
no momento da extração
```

Ele não consegue necessariamente determinar:

```text
todos os valores que essa linha possuía
antes da extração
```

Por exemplo:

```text
estado do backfill
Status = COMPLETED
```

não comprova:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

Da mesma forma:

```text
preço no backfill = 150
```

não comprova que o preço tenha passado anteriormente por:

```text
100
120
150
```

A V1, portanto, aceita conhecimento incompleto em nível de evento antes do limite de captura.

Essa é uma limitação das evidências, e não algo que a plataforma deva tentar ocultar.

### 12.5 Timestamp Incremental Depende da Semântica da Origem

*Timestamp* Incremental é operacionalmente mais simples do que CDC para as origens pretendidas da Categoria B, mas essa simplicidade depende de premissas importantes.

O mecanismo depende de uma *watermark* confiável.

Se:

```text
uma linha relevante for alterada
```

sem que:

```text
a watermark seja alterada
```

a consulta incremental poderá nunca recuperar essa atualização.

As origens candidatas são:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

A confiabilidade de suas *watermarks* permanece pendente de validação da implementação.

Portanto, a estratégia V1 aceita o mecanismo apenas condicionalmente.

Se os testes demonstrarem que a *watermark* não é confiável, a estratégia deverá mudar.

O *trade-off* aceito é:

```text
menor complexidade de captura
```

em troca de:

```text
dependência de metadados de alteração
mantidos de forma confiável pela origem
```

### 12.6 Timestamp Incremental Não Detecta Inerentemente DELETE Físico

Uma linha excluída fisicamente deixa de existir na origem.

Portanto, uma consulta posterior como:

```sql
WHERE updated_at > @last_watermark
```

não consegue recuperá-la.

*Timestamp* Incremental pode potencialmente observar:

```text
INSERT
UPDATE
```

mas não observa inerentemente:

```text
DELETE físico
```

A estratégia V1 para a Categoria B aceita essa limitação somente se o requisito de negócio permitir ou se um mecanismo complementar de detecção de exclusões for introduzido posteriormente.

Se a visibilidade de DELETE se tornar obrigatória, o mecanismo deverá ser reconsiderado.

### 12.7 Timestamp Incremental Pode Não Preservar Estados Intermediários

Suponha que uma linha da origem seja alterada várias vezes entre extrações incrementais:

```text
Estado A
  ↓
Estado B
  ↓
Estado C
  ↓
próxima extração
```

A origem pode expor apenas:

```text
Estado C
```

quando consultada.

*Timestamp* Incremental pode, portanto, estabelecer:

```text
esta linha foi alterada
e seu estado atual é C
```

sem recuperar:

```text
A → B → C
```

como eventos separados.

Essa é uma consequência aceita do uso da semântica de *watermark* da linha atual em vez de captura de alterações em nível de evento.

Portanto:

> ***Timestamp* Incremental fornece fidelidade do estado alterado, e não fidelidade garantida dos eventos intermediários.**

### 12.8 Limites de Timestamp Podem Exigir Sobreposição Controlada

Várias linhas podem compartilhar o mesmo *timestamp*.

A visibilidade após o COMMIT também pode exigir proteção do limite.

Um predicado simples utilizando:

```text
>
```

pode reduzir a sobreposição, mas pode criar risco de perda caso o limite esteja incompleto.

Uma estratégia utilizando:

```text
>=
```

ou uma janela de releitura pode reduzir o risco de lacunas, mas relê dados deliberadamente.

Isso introduz:

```text
duplicidades
reprocessamento
requisitos de deduplicação
```

A V1 aceita a sobreposição controlada como preferível à perda silenciosa.

Entretanto, o algoritmo final para os limites baseados em *timestamp* permanece pendente de testes de implementação.

### 12.9 Snapshot + Diff Captura a Diferença Líquida de Estado

*Snapshot* + *Diff* compara:

```text
estado anteriormente aceito
```

com:

```text
estado atual aceito
```

Ele pode derivar:

```text
ADICIONADO
REMOVIDO
INALTERADO
```

mas não necessariamente todos os eventos intermediários.

Por exemplo:

```text
relacionamento existe
        ↓
removido
        ↓
recriado
        ↓
próximo snapshot
```

pode resultar em:

```text
INALTERADO
```

porque os estados inicial e final são idênticos.

Portanto:

> ***Snapshot* + *Diff* fornece visibilidade da transição de estado entre observações, e não o histórico completo de eventos entre essas observações.**

Isso é aceito para `catalog.ProductCategory` porque a estratégia V1 prioriza o estado do relacionamento, e não seu histórico em nível de evento.

### 12.10 A Frequência dos Snapshots Limita a Precisão Temporal

Se os *snapshots* ocorrerem periodicamente, uma remoção derivada estabelece apenas que o relacionamento desapareceu entre duas observações.

Por exemplo:

```text
Snapshot A
10:00
relacionamento existe

Snapshot B
11:00
relacionamento ausente
```

A plataforma pode estabelecer:

```text
a remoção ocorreu em algum momento
entre 10:00 e 11:00
```

Ela não pode comprovar:

```text
DELETE ocorreu exatamente às 11:00
```

a menos que outra fonte autoritativa forneça esse *timestamp*.

A limitação aceita é a menor precisão do tempo do evento.

### 12.11 A Completude do Snapshot É Crítica

*Snapshot* + *Diff* pode produzir alterações falsas se o *snapshot* atual estiver incompleto.

Por exemplo:

```text
snapshot anterior
A B C
```

e uma falha de extração produz:

```text
snapshot atual
A B
```

Uma comparação ingênua deriva:

```text
REMOVER C
```

mesmo que C ainda exista na origem.

Portanto, a V1 aceita o requisito operacional de que:

```text
validação do snapshot
```

deve ocorrer antes de:

```text
aceitação do diff
```

Isso torna o mecanismo ligeiramente mais complexo operacionalmente do que uma simples comparação de conjuntos.

Essa complexidade é necessária para garantir a correção.

### 12.12 Snapshot + Diff Exige o Estado Anterior Aceito

Diferentemente de consultas à origem sem estado, *Snapshot* + *Diff* exige a preservação de um *snapshot* anteriormente aceito.

Se esse estado for corrompido ou perdido, a próxima comparação não poderá determinar de forma confiável:

```text
o que foi adicionado
o que foi removido
```

A plataforma deve, portanto, gerenciar o estado do *snapshot* como parte do mecanismo de captura.

Isso introduz preocupações relacionadas a:

```text
armazenamento
promoção
recuperação
versionamento
nova tentativa
```

A estratégia aceita essa sobrecarga porque nenhuma *watermark* confiável foi identificada para a origem atual.

### 12.13 Full Refresh Controlado Não Preserva o Histórico de Eventos da Origem

*Full Refresh* Controlado recupera o estado atual autoritativo.

Suponha que:

```text
3 COMPLETED
```

se torne:

```text
3 CLOSED
```

A próxima atualização aceita pode estabelecer:

```text
3 CLOSED
```

mas não preserva inerentemente:

```text
quando a alteração ocorreu
quantas alterações intermediárias ocorreram
qual transação realizou a alteração
```

Isso é aceito porque o requisito atual da V1 para:

```text
sales.TransactionStatus
sales.TransactionChannel
```

é orientado a estado.

Se a evolução histórica das referências se tornar analiticamente importante no futuro, a estratégia de captura deverá ser revisada.

### 12.14 Full Refresh Pode Apresentar Defasagem Temporária em Relação ao Estado da Origem

*Full Refresh* Controlado é executado periodicamente.

Uma alteração na origem que ocorra imediatamente após uma atualização permanecerá ausente no ambiente *downstream* até a próxima atualização bem-sucedida.

Portanto:

```text
estado da origem
```

e:

```text
estado da referência downstream
```

podem diferir temporariamente.

Essa defasagem é uma consequência aceita da atualização periódica de estado.

A frequência final aceitável deve ser alinhada aos requisitos de negócio durante a implementação.

### 12.15 A Simplicidade do Full Refresh Depende do Tamanho da Origem

*Full Refresh* Controlado é operacionalmente atraente porque os conjuntos de dados de referência atuais são pequenos.

Essa premissa pode deixar de ser válida se a origem crescer substancialmente.

Por exemplo:

```text
2 linhas
```

ou:

```text
5 linhas
```

são triviais de recuperar por completo.

Um conjunto de dados de referência futuro contendo:

```text
milhões de linhas
```

poderia tornar a mesma estratégia inadequada.

Portanto, o mecanismo aceito está condicionado às características atuais da origem.

### 12.16 As Contagens Atuais de Linhas Não São Contratos Permanentes

A referência atualmente observada contém:

```text
TransactionStatus
5 linhas

TransactionChannel
2 linhas
```

Essas contagens são evidências úteis.

Elas não devem se tornar automaticamente limites permanentes codificados de forma rígida.

Uma alteração futura legítima poderia introduzir:

```text
novo status
novo canal
```

A estratégia aceita, portanto, que a validação deve distinguir:

```text
anomalia inesperada de extração
```

de:

```text
evolução legítima do negócio
```

Uma regra de validação que pressuponha:

```text
a quantidade de linhas nunca pode mudar
```

seria excessivamente rígida sem um contrato de negócio explícito.

### 12.17 O Contexto Transacional do CDC Não Comprova Atomicidade Downstream

O laboratório no lado da origem demonstrou que alterações relacionadas podem compartilhar:

```text
__$start_lsn
```

entre instâncias de captura do CDC quando geradas pela mesma transação SQL.

Por exemplo:

```text
INSERT em Transaction
+
INSERT em TransactionItem
+
INSERT em TransactionItem
```

compartilharam contexto transacional no CDC.

Da mesma forma, o DELETE em cascata do M01.19 demonstrou:

```text
DELETE do registro pai
+
DELETEs dos registros filhos
```

dentro do mesmo contexto transacional na origem.

Essa evidência é valiosa.

Entretanto, a V1 aceita explicitamente que os seguintes aspectos permanecem desconhecidos até que sejam testados:

```text
representação no Debezium
comportamento dos tópicos do Kafka
ordenação entre tópicos
reconstrução da transação pelo consumidor
processamento downstream atômico
```

Portanto:

> **O contexto transacional da origem não deve ser confundido com entrega atômica de ponta a ponta comprovada.**

### 12.18 Uma Ação da Aplicação Não Equivale à Quantidade de Linhas no CDC

Uma única operação lógica da aplicação pode produzir várias alterações físicas no banco de dados.

As evidências do M01.19 demonstraram:

```text
1 DELETE explícito no registro pai
```

resultando em:

```text
1 DELETE em Transaction
+
2 DELETEs em TransactionItem
```

devido a:

```text
ON DELETE CASCADE
```

Portanto, a V1 aceita que a interpretação dos eventos do CDC exige contexto.

Um sistema *downstream* não deve pressupor:

```text
3 linhas DELETE
=
3 comandos DELETE explícitos da aplicação
```

A camada de captura preserva as alterações físicas da origem.

A interpretação de negócio pertence ao processamento semântico posterior.

### 12.19 Partition SWITCH Não É CDC Comum em Nível de Linha

As tabelas transacionais habilitadas para CDC são particionadas.

A configuração atual do CDC na V1 permite:

```text
allow_partition_switch = 1
```

As operações `SWITCH` de partição do SQL Server não se comportam como DML comum em nível de linha para fins de CDC.

Portanto, a estratégia aceita que:

```text
movimentação física de partições
```

pode não produzir a mesma semântica de captura que:

```text
INSERT
UPDATE
DELETE
```

Em vez de desabilitar `SWITCH` preventivamente, a V1 governa seu uso.

A limitação aceita é que qualquer movimentação futura de partições deve ser coordenada explicitamente com a Engenharia de Dados.

### 12.20 SWITCH OUT Não É um DELETE de Negócio

Um futuro:

```text
SWITCH OUT
```

pode remover fisicamente linhas da tabela transacional ativa para fins de arquivamento.

Isso não significa necessariamente:

```text
a venda deixou de existir
```

Sob a perspectiva analítica, vendas históricas podem permanecer válidas indefinidamente.

Portanto, a V1 aceita uma distinção semântica entre:

```text
movimentação física do armazenamento na origem
```

e:

```text
exclusão de negócio
```

A camada de captura não deve criar uma semântica de DELETE simplesmente porque as linhas mudaram de localização física de armazenamento.

### 12.21 SWITCH IN Não É o Caminho Normal de Ingestão

O caminho operacional normal permanece:

```text
DML da aplicação
        ↓
transação SQL Server
        ↓
Transaction Log
        ↓
CDC
```

Utilizar `SWITCH IN` como mecanismo normal de ingestão transacional poderia contornar a semântica esperada do CDC em nível de linha.

Portanto, a V1 não oferece suporte a `SWITCH IN` como caminho normal de ingestão de vendas.

Se esse requisito surgir futuramente, ele se tornará um gatilho explícito para revisão da estratégia.

### 12.22 O CDC Assíncrono Introduz Atraso de Visibilidade

O SQL Server CDC é assíncrono.

Portanto:

```text
COMMIT da transação na origem
```

não significa:

```text
linha do CDC imediatamente disponível para consulta
```

O laboratório observou esse comportamento repetidamente.

O *job* de captura atual utiliza:

```text
intervalo de polling = 5 segundos
```

e os testes controlados frequentemente aguardaram aproximadamente:

```text
6 segundos
```

antes de inspecionar as alterações capturadas.

A V1 aceita esse modelo de visibilidade assíncrona.

O atraso observado não deve ser interpretado como uma garantia de produção de ponta a ponta.

### 12.23 O Tempo Observado no Laboratório Não É um SLO

O laboratório atual observou alterações aparecendo após pequenos atrasos.

Essas observações validam o comportamento assíncrono do CDC.

Elas não comprovam:

```text
P95 ≤ 15 minutos
```

para a Plataforma de Engenharia de Dados completa.

O SLO formal de latência dos dados inclui etapas futuras, como:

```text
consumo do CDC
Debezium
Kafka
consumidor
Bronze
```

Portanto, a V1 aceita que as evidências de tempo no lado da origem e as evidências de latência de ponta a ponta são distintas.

### 12.24 Recuperação e Latência São Dimensões Diferentes

Atualmente, a plataforma distingue:

```text
latência dos dados
→ minutos
```

de:

```text
janela de recuperação do CDC
→ dias
```

Por exemplo:

```text
Meta típica de latência
≈ 3–5 minutos

SLO formal P95
≤ 15 minutos

Retenção do CDC
15 dias
```

O *trade-off* aceito é manter uma janela de recuperação muito maior do que a latência normal de entrega.

Isso consome armazenamento adicional do CDC, mas oferece resiliência operacional.

### 12.25 Maior Retenção Significa Maior Uso de Armazenamento no Lado da Origem

Aumentar a retenção do CDC amplia a oportunidade de recuperação, mas também mantém mais dados do CDC armazenados.

Conceitualmente:

```text
maior retenção
        ↓
mais histórico recuperável
        +
mais armazenamento do CDC
```

A janela selecionada de 15 dias representa, portanto, um equilíbrio.

Ela poderá precisar ser revisada quando o volume real de alterações e o crescimento do armazenamento forem observados.

A V1 não afirma que 15 dias sejam permanentemente ideais.

### 12.26 A Idempotência Downstream É Necessária, mas Ainda Não Foi Comprovada

A sobreposição controlada e a entrega *At-Least-Once* dependem de a futura plataforma conseguir processar informações repetidas com segurança.

Conceitualmente:

```text
entrega duplicada
        ↓
mesmo resultado lógico
```

Isso exige idempotência.

A estratégia arquitetural selecionou:

```text
At-Least-Once
+
Idempotência
```

Entretanto, o processamento idempotente de ponta a ponta ainda não foi implementado nem validado.

Portanto, a V1 aceita uma dependência arquitetural temporária de trabalhos futuros de implementação.

A decisão existe.

A comprovação ainda não existe.

### 12.27 Exactly-Once Não É Reivindicado

O Atlas Engineering atualmente não reivindica:

```text
Exactly-Once de ponta a ponta
```

A filosofia de entrega selecionada favorece intencionalmente:

```text
At-Least-Once
+
Idempotência
```

Isso significa que o processamento duplicado é considerado uma condição esperada que deve ser governada.

O *trade-off* aceito é:

```text
possível entrega duplicada
```

em vez de tentar reivindicar uma garantia mais forte que ainda não foi comprovada em todas as camadas da plataforma.

### 12.28 A Captura na Origem Não Resolve Toda a Semântica Downstream

A camada de captura pode fornecer:

```text
alterações da origem
linhas alteradas
diferenças de estado
estado atual
```

dependendo do mecanismo.

Ela não pode, por si só, garantir:

```text
correção semântica de negócio
deduplicação na Silver
correção dimensional na Gold
correção das métricas no Power BI
```

Por exemplo, o CDC pode expor:

```text
status alterado de 2 para 3
```

mas a interpretação de negócio desses valores depende dos dados de referência e da modelagem *downstream*.

Portanto:

> **A correção da captura é necessária, mas insuficiente para garantir a correção analítica.**

### 12.29 A Captura Não É Responsável pelo Armazenamento Histórico Permanente

O SQL Server CDC e os mecanismos de extração da origem existem próximos ao sistema OLTP.

A retenção histórica permanente pertence ao ambiente *downstream*.

Conceitualmente:

```text
CAPTURA NA ORIGEM
        ↓
responsabilidade temporária
pela aquisição operacional

BRONZE
        ↓
histórico de ingestão durável
```

A V1 aceita que os mecanismos de captura na origem possam possuir histórico finito porque o histórico analítico permanente pertence a outra camada.

O caminho de durabilidade *downstream* permanece pendente de implementação.

### 12.30 A Captura Não Pode Garantir Recuperação sem Checkpoints

A retenção, isoladamente, não informa à plataforma:

```text
onde o processamento parou
```

Da mesma forma, uma *watermark* da origem, isoladamente, não estabelece:

```text
o que foi processado de forma durável
```

A recuperação exige um estado de progresso persistido.

Dependendo do mecanismo, isso pode incluir:

```text
checkpoint de LSN do CDC

checkpoint de watermark de timestamp

estado do snapshot aceito

estado da atualização aceita
```

Esses mecanismos permanecem parcial ou totalmente pendentes.

Portanto:

> **A disponibilidade dos dados na origem não equivale à capacidade de recuperação, a menos que o progresso do processamento também seja conhecido.**

### 12.31 A Estratégia de Captura Não Elimina a Reconciliação

Mesmo mecanismos de captura bem projetados podem falhar.

As possíveis causas incluem:

```text
defeitos de software
defeitos de checkpoint
comportamento inesperado da origem
evolução de schema
incidentes operacionais
falhas do consumidor
erros manuais
```

Portanto, a V1 aceita que a reconciliação continue sendo necessária.

A captura deve reduzir a probabilidade de inconsistência.

Ela não deve criar a ilusão de que a inconsistência é impossível.

### 12.32 A Reconciliação Pode Exigir Múltiplos Tipos de Evidência

É improvável que uma única métrica comprove a correção completa.

Por exemplo:

```text
contagem de linhas corresponde
```

não comprova:

```text
dados correspondem
```

A reconciliação futura pode combinar:

```text
contagens de linhas
comparações de chaves
agregações
totais de negócio
hashes
amostragem
verificações entre origem e destino
```

Os controles exatos permanecem fora do estágio atual de implementação.

### 12.33 A Disponibilidade da Origem Continua Sendo uma Dependência

Todo mecanismo de captura no lado da origem depende, em última instância, de a origem estar operacionalmente acessível de alguma forma.

Por exemplo:

```text
Timestamp Incremental
Snapshot + Diff
Full Refresh Controlado
```

exigem consultas à origem.

O CDC depende de a infraestrutura de captura do SQL Server permanecer saudável e de os dados retidos continuarem disponíveis.

A Plataforma de Engenharia de Dados não consegue eliminar completamente as dependências da origem no limite inicial de aquisição.

A arquitetura busca, em vez disso, reduzir essas dependências após a persistência durável no ambiente *downstream*.

### 12.34 A Evolução de Schema Pode Invalidar Premissas de Captura

Uma alteração no *schema* da origem pode afetar:

```text
colunas de captura
chaves
watermarks
tipos de dados
semântica dos relacionamentos
configuração das colunas capturadas pelo CDC
comparação de snapshots
contratos de full refresh
```

Portanto, a V1 aceita que a configuração de captura e os contratos de *schema* devem evoluir em conjunto.

Não se pode presumir que um *schema* de origem permanecerá estático para sempre.

### 12.35 As Decisões de Mecanismo Podem Ser Revisadas

Um mecanismo selecionado para a V1 não é permanente.

Uma origem pode deixar de ser adequada à estratégia atual.

Exemplos incluem:

```text
alterações em Product tornam-se extremamente frequentes

DELETE de Product torna-se crítico para o negócio

ProductCategory cresce significativamente

TransactionStatus passa a exigir
versionamento histórico completo

latência da atualização das referências
torna-se insuficiente

custo operacional do CDC muda
```

Essas mudanças podem justificar um novo mecanismo.

Portanto:

> **A aprovação na V1 significa que o mecanismo é apropriado para os requisitos atuais, e não que seja imutável para sempre.**

### 12.36 A Simplicidade Operacional É um Requisito

Uma solução tecnicamente sofisticada ainda pode ser arquiteturalmente inadequada se sua sobrecarga operacional exceder o valor que fornece.

Por exemplo, utilizar CDC para todas as tabelas de referência com duas linhas aumentaria:

```text
configuração
monitoramento
armazenamento
cleanup
complexidade do consumidor
```

sem necessariamente melhorar o resultado analítico.

A V1 aceita explicitamente mecanismos mais simples e orientados a estado quando eles satisfazem o requisito.

Esse é um *trade-off* em favor da manutenibilidade.

### 12.37 A Simplicidade Não Deve Se Sobrepor à Correção

O inverso também é verdadeiro.

Um mecanismo simples não é aceitável apenas porque é fácil de construir.

Por exemplo:

```text
WHERE updated_at > @watermark
```

é operacionalmente simples.

Se a *watermark* não for confiável, ele pode perder dados silenciosamente.

Da mesma forma:

```text
substituir o estado downstream
pelo snapshot atual
```

é simples.

Se o *snapshot* estiver incompleto, ele pode produzir remoções em massa falsas.

Portanto:

> **A simplicidade é valiosa somente depois que os requisitos de correção são atendidos.**

### 12.38 Resumo dos Trade-offs Aceitos na V1

| Decisão | Benefício | Limitação Aceita |
|---|---|---|
| Múltiplos mecanismos de captura | Melhor adequação entre origem e mecanismo | Maior heterogeneidade arquitetural e operacional |
| SQL Server CDC para origens transacionais | Visibilidade em nível de alteração, incluindo DELETE físico | Infraestrutura adicional de CDC e retenção finita |
| Retenção de 15 dias do CDC | Maior oportunidade de recuperação | Maior uso de armazenamento pelo CDC |
| *Backfill* Inicial | Carrega o estado existente na origem antes do limite | Não reconstrói sequências históricas de eventos |
| *Timestamp* Incremental | Menor complexidade para origens com alterações ocasionais | Depende de *watermark* confiável; DELETE físico não é inerente |
| Sobreposição controlada | Reduz o risco de perda silenciosa | Exige idempotência e reconciliação *downstream* |
| *Snapshot* + *Diff* | Detecta adições/remoções de estado sem *watermark* | Eventos intermediários e o tempo preciso do evento podem ser perdidos |
| *Full Refresh* Controlado | Captura simples do estado autoritativo | Não preserva inerentemente o histórico de eventos |
| `allow_partition_switch = 1` | Preserva flexibilidade futura para gerenciamento de partições | `SWITCH` deve ser governado fora das premissas normais do CDC em nível de linha |
| *At-Least-Once* + Idempotência | Prefere duplicidades recuperáveis à perda | Entregas duplicadas devem ser tratadas corretamente |
| Evidência primeiro no lado da origem | Evita afirmações *downstream* não comprovadas | A validação completa da plataforma exige etapas adicionais de implementação |

### 12.39 O Que a V1 Explicitamente Não Afirma

No estágio atual do projeto, a Estratégia de Captura não afirma que os seguintes aspectos tenham sido comprovados:

```text
correção do Timestamp Incremental

correção da implementação de Snapshot + Diff

correção da implementação de Full Refresh Controlado

modelo final de checkpoint do consumidor CDC

comportamento de reinicialização e replay do CDC

comportamento do Debezium com SQL Server
no Atlas Engineering

comportamento dos metadados
transacionais do Debezium

correlação de transações no Kafka

ordenação entre tópicos

entrega atômica entre múltiplas tabelas

persistência em Bronze

replay a partir da Bronze

idempotência de ponta a ponta

recuperação de ponta a ponta

capacidade de processamento em escala de produção

catch-up do backlog em produção

cumprimento do SLO P95
de latência de ponta a ponta
```

Essas são responsabilidades futuras de implementação e validação.

### 12.40 Governança das Limitações Aceitas

As limitações aceitas devem permanecer visíveis.

Elas devem ser revisitadas quando:

```text
requisitos mudarem
evidências contradisserem premissas
comportamento da origem mudar
experiência com falhas revelar fragilidades
escala mudar
custo operacional mudar
arquitetura downstream mudar
```

O processo é:

```text
limitação aceita
        ↓
monitorar premissa
        ↓
nova evidência
        │
        ├── premissa continua válida
        │      ↓
        │   manter estratégia
        │
        └── premissa deixou de ser válida
               ↓
            revisar estratégia
```

Isso impede que a expressão:

```text
limitação aceita
```

se transforme em:

```text
ignorar para sempre
```

### 12.41 Princípio dos Trade-offs

A estratégia V1 pode, portanto, ser resumida como:

```text
NÃO MAXIMIZAR
a fidelidade da captura
a qualquer custo operacional

NÃO MINIMIZAR
a complexidade da implementação
às custas da correção

EM VEZ DISSO
equilibrar
correção
+
proteção da origem
+
recuperação
+
latência
+
simplicidade operacional
```

O princípio que rege essa abordagem é:

> **O Atlas Engineering aceita deliberadamente limitações conhecidas; ele não aceita acidentalmente limitações desconhecidas.**

E o princípio de evidência permanece:

> **Quando uma limitação ainda não foi testada, ela deve permanecer como uma premissa explícita, em vez de ser silenciosamente promovida a fato.**

---

## 13. Limites da Estratégia

A Estratégia de Captura define como os dados e as alterações da origem são identificados e adquiridos a partir do AtlasCommerce.

Sua responsabilidade termina quando a plataforma dispõe de uma forma confiável de determinar:

```text
qual estado da origem deve ser adquirido
```

ou:

```text
qual alteração da origem se tornou observável
```

de acordo com o mecanismo selecionado para cada origem.

A estratégia, portanto, abrange o limite de aquisição no lado da origem.

Ela não define toda a arquitetura de processamento *downstream*.

O limite que rege essa responsabilidade é:

> **A Estratégia de Captura termina quando as alterações necessárias da origem ou seu estado autoritativo podem ser identificados e adquiridos de forma confiável.**

Tudo o que ocorre depois desse ponto pertence a outra responsabilidade arquitetural ou de implementação.

Para a arquitetura V1 do Atlas Engineering, o fluxo mais amplo de responsabilidades é:

```text
AtlasCommerce
        ↓
Mecanismo de Captura
        ↓
dados da origem identificados / adquiridos
        ↓
────────────────────────────────
ingestão / entrega downstream
        ↓
persistência / processamento
        ↓
produtos de dados analíticos
```

O caminho *downstream* exato depende do mecanismo de captura selecionado e de sua respectiva implementação.

A Estratégia de Captura é responsável apenas pela parte inicial:

```text
AtlasCommerce
        ↓
Mecanismo de Captura
        ↓
dados da origem identificados / adquiridos
```

Ela não reivindica responsabilidade sobre todo o caminho *downstream*.

### 13.1 Responsabilidades Incluídas

A Estratégia de Captura inclui decisões sobre:

```text
quais origens exigem captura

como as alterações da origem são classificadas

qual mecanismo de captura é apropriado

se a visibilidade de DELETE é necessária

se uma watermark confiável é necessária

se o estado atual é suficiente

se a comparação de estados é necessária

como o estado inicial da origem é tratado

como a transição para a captura contínua é governada

como a oportunidade de recuperação
no lado da origem é considerada

quais limitações no lado da origem são aceitas
```

Para o domínio V1 atual, essas decisões resultam em:

```text
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC


catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
Timestamp Incremental


catalog.ProductCategory
        ↓
Snapshot + Diff


sales.TransactionStatus
sales.TransactionChannel
        ↓
Full Refresh Controlado
```

A estratégia também define a fundamentação dessas escolhas.

### 13.2 A Aquisição na Origem É o Limite

A principal distinção ocorre entre:

```text
AQUISIÇÃO
```

e:

```text
ENTREGA / PROCESSAMENTO
```

A captura responde:

```text
O que deve ser adquirido?
Como podemos identificá-lo?
Quais evidências a origem fornece?
```

O processamento *downstream* responde:

```text
Como os dados são transportados?

Como o progresso é persistido?

Como são realizadas novas tentativas?

Como os dados são armazenados?

Como são transformados?

Como são deduplicados?

Como são modelados?

Como são disponibilizados para consumo analítico?
```

Essas responsabilidades estão relacionadas, mas não são a mesma responsabilidade.

### 13.3 Captura CDC Versus Consumo CDC

A estratégia atual de CDC abrange o comportamento do SQL Server CDC no lado da origem.

Isso inclui conceitos como:

```text
instância de captura

Change Table

LSN

captura de INSERT

UPDATE BEFORE / AFTER

captura de DELETE

contexto transacional

retenção

cleanup

governança de partition SWITCH
```

Ela ainda não define o modelo completo de consumo do CDC.

Por exemplo:

```text
Change Table do CDC
        ↓
qual intervalo de LSN deve ser lido?
        ↓
como from_lsn deve ser persistido?
        ↓
como to_lsn deve ser selecionado?
        ↓
o que acontece após uma reinicialização?
        ↓
como a sobreposição é tratada?
```

Essas questões pertencem ao:

```text
Consumo CDC
```

e não à Estratégia de Captura.

Essa distinção torna-se particularmente importante na próxima etapa de implementação.

### 13.4 As Funções do CDC São Responsabilidades de Consumo

O SQL Server fornece funções de consumo do CDC, como:

```text
cdc.fn_cdc_get_all_changes_<capture_instance>
```

e funções de gerenciamento de LSN utilizadas para construir janelas de captura.

Essas funções são relevantes para a implementação de um leitor de CDC.

Elas não determinam por que a origem utiliza CDC.

Portanto:

```text
POR QUE CDC?
```

pertence a este documento.

```text
COMO UM CONSUMIDOR LÊ
AS JANELAS DO CDC?
```

pertence à implementação do consumo CDC.

### 13.5 A Implementação do Checkpoint Está Fora Desta Estratégia

A Estratégia de Captura identifica a necessidade de limites de progresso.

Exemplos incluem:

```text
CDC
→ limite baseado em LSN

Timestamp Incremental
→ limite de watermark

Snapshot + Diff
→ snapshot aceito

Full Refresh Controlado
→ estado aceito da atualização
```

Entretanto, a implementação exata dos *checkpoints* persistidos não é definida aqui.

Por exemplo:

```text
tabela de checkpoint

arquivo de checkpoint

offset do Kafka

metadados de banco de dados

armazenamento de estado do consumidor
```

são escolhas de implementação.

A Estratégia de Captura estabelece:

> **O progresso deve representar aquisição ou processamento concluído com segurança.**

Ela ainda não define o modelo final de armazenamento ou de transação desse progresso.

### 13.6 Offset do Kafka Não É um Limite de Captura da Origem

Os *offsets* do Kafka representarão posteriormente uma posição dentro das partições do Kafka.

Eles não são equivalentes aos LSNs do SQL Server CDC.

Conceitualmente:

```text
LSN do SQL Server
→ posição no Transaction Log da origem

offset do Kafka
→ posição dentro de uma partição do Kafka
```

Ambos são conceitos relacionados a progresso.

Eles existem em sistemas diferentes e possuem semânticas diferentes.

Portanto:

```text
LSN
≠
offset do Kafka
```

Uma implementação futura poderá correlacioná-los operacionalmente.

Esta estratégia não os trata como limites intercambiáveis.

### 13.7 Debezium Está Fora da Decisão de Captura na Origem

A V1 do Atlas Engineering inclui:

```text
SQL Server Native CDC
        ↓
Debezium
```

O Debezium consumirá o SQL Server CDC e emitirá eventos de alteração para mensageria *downstream*.

Entretanto, a decisão da Estratégia de Captura é:

```text
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC
```

e não:

```text
Debezium lê diretamente
o Transaction Log do SQL Server
```

O mecanismo de alteração no lado da origem continua sendo o SQL Server Native CDC.

O Debezium pertence à arquitetura *downstream* de entrega do CDC.

Portanto, responsabilidades como:

```text
configuração do connector do Debezium

offsets do Debezium

metadados de transação

envelopes de eventos

comportamento de evolução de schema

reinicialização do connector

modos de snapshot

comportamento de heartbeat
```

estão fora da Estratégia de Captura.

Elas exigem implementação e validação separadas.

### 13.8 A Semântica de Entrega do Kafka Está Fora Desta Estratégia

O Kafka introduz responsabilidades como:

```text
tópicos

partições

entrega pelo produtor

grupos de consumidores

offsets

ordenação

retenção

replay

backlog

catch-up
```

Essas responsabilidades começam depois que os dados capturados passam a ser entregues ao ambiente *downstream*.

A Estratégia de Captura não define:

```text
organização dos tópicos

chave de particionamento

quantidade de partições

retenção do Kafka

estratégia de grupos de consumidores

mecanismo de commit de offset

ordenação entre tópicos
```

Esses aspectos pertencem à arquitetura de mensageria e consumo.

### 13.9 O Contexto Transacional da Origem Não Define Atomicidade no Kafka

O SQL Server CDC já demonstrou contexto transacional na origem.

Por exemplo:

```text
Transaction
+
TransactionItem
+
TransactionItem
```

criados dentro da mesma transação SQL compartilharam contexto transacional do CDC no lado da origem.

Isso não comprova que futuros consumidores do Kafka receberão:

```text
um único pacote atômico indivisível
```

abrangendo todos os registros relacionados.

Questões relacionadas a:

```text
atomicidade entre tópicos

ordenação nas partições

correlação de transações

reconstrução pelo consumidor
```

pertencem ao ambiente *downstream*.

A Estratégia de Captura preserva as evidências da origem.

Ela não reivindica garantias *downstream* que ainda não tenham sido testadas.

### 13.10 A Persistência em Bronze Está Fora Desta Estratégia

A Bronze deverá se tornar o histórico durável de ingestão da plataforma.

A arquitetura V1 mais ampla atualmente aponta para:

```text
Python Consumer
+
PyArrow
        ↓
Parquet
        ↓
MinIO Bronze
```

A Estratégia de Captura não define:

```text
schema do Parquet

tamanho dos arquivos

tamanho dos row groups

organização das partições

nomenclatura dos objetos

estrutura do manifest

protocolo de upload atômico

colunas de metadados da Bronze

política de ciclo de vida dos objetos
```

Esses aspectos pertencem ao projeto e à implementação da Bronze.

A camada de captura fornece apenas as informações da origem que a Bronze posteriormente persistirá.

### 13.11 A Retenção da Captura Não É a Retenção da Bronze

A retenção do SQL Server CDC e a retenção da Bronze resolvem problemas diferentes.

Conceitualmente:

```text
RETENÇÃO DO CDC
→ janela temporária de recuperação
no lado da origem
```

em comparação com:

```text
RETENÇÃO DA BRONZE
→ histórico durável de ingestão
da plataforma
```

A decisão atual para o CDC é:

```text
15 dias
```

Isso não deve ser interpretado como:

```text
reter o histórico analítico
por 15 dias
```

A retenção analítica permanente ou de longo prazo pertence ao ambiente *downstream*.

### 13.12 A Persistência Atômica na Bronze Está Fora Desta Estratégia

A arquitetura mais ampla pretende seguir uma sequência semelhante a:

```text
consumir
        ↓
processar
        ↓
persistir na Bronze com segurança
        ↓
confirmar progresso
```

Esse princípio oferece suporte ao processamento *At-Least-Once*.

Entretanto, detalhes de implementação como:

```text
objeto temporário

renomeação / promoção atômica

manifest

marcador de commit

coordenação do commit de offset
```

estão fora da Estratégia de Captura.

Eles pertencem ao projeto do consumidor e da persistência na Bronze.

### 13.13 As Responsabilidades da Silver Estão Fora Desta Estratégia

Espera-se que a Silver execute responsabilidades como:

```text
tipagem

normalização

validação

deduplicação

idempotência

tratamento de dados atrasados

tratamento de dados fora de ordem

reconciliação

aplicação de qualidade de dados

integração de backfill

tratamento de replay
```

Essas atividades operam sobre dados que já atravessaram o limite de captura.

Portanto, elas não pertencem à Estratégia de Captura.

Por exemplo:

```text
CDC UPDATE BEFORE
CDC UPDATE AFTER
```

são evidências de captura.

A forma como a Silver decide representar:

```text
estado atual
```

ou:

```text
histórico de alterações
```

é uma decisão de modelagem da Silver.

### 13.14 A Idempotência de Ponta a Ponta Está Fora Desta Estratégia

A arquitetura seleciona:

```text
At-Least-Once
+
Idempotência
```

como filosofia mais ampla de entrega.

A Estratégia de Captura oferece suporte a essa abordagem ao preferir:

```text
sobreposição controlada
```

em vez de:

```text
perda silenciosa
```

Entretanto, a implementação da idempotência de ponta a ponta pertence ao ambiente *downstream*.

Ela poderá futuramente envolver:

```text
chaves de negócio

metadados da origem

LSN

identificadores de eventos

identificadores de lote

metadados de objetos

lógica de deduplicação da Silver
```

O modelo final ainda não foi implementado nem validado.

Portanto:

> **A Estratégia de Captura pode criar condições que exijam idempotência, mas não implementa a idempotência de ponta a ponta.**

### 13.15 Exactly-Once Está Fora Desta Estratégia

A Estratégia de Captura não reivindica:

```text
Exactly-Once
```

para a plataforma completa.

Ela também não tenta comprovar essa propriedade apenas na camada de captura da origem.

A semântica *Exactly-Once* exigiria evidências coordenadas entre:

```text
captura na origem

Debezium

Kafka

consumidor

Bronze

checkpoint

novas tentativas

processamento downstream
```

Atualmente, não existe tal comprovação de ponta a ponta.

A arquitetura V1 utiliza, em vez disso, o modelo mais explícito:

```text
At-Least-Once
+
Idempotência
```

### 13.16 A Semântica de Negócio da Silver Está Fora Desta Estratégia

A captura registra informações físicas ou de estado da origem.

Ela não define a semântica final de negócio.

Por exemplo:

```text
TransactionStatus = 3
```

pode corresponder a:

```text
COMPLETED
```

nos dados de referência da origem.

Um modelo analítico posterior poderá agrupar esse status como:

```text
Successful
```

A Estratégia de Captura não é responsável por essa transformação semântica.

Da mesma forma:

```text
três linhas DELETE no CDC
```

causadas por um único DELETE em cascata no registro pai não se tornam automaticamente:

```text
três ações independentes
de exclusão de negócio
```

Essa interpretação pertence ao processamento semântico *downstream*.

### 13.17 A Modelagem Gold Está Fora Desta Estratégia

Espera-se que o escopo inicial da Gold V1 ofereça suporte à:

```text
Análise de Vendas
```

com um grão do fato baseado em:

```text
uma linha por TransactionItem
associada à sua Transaction
```

Entretanto, a Estratégia de Captura não define:

```text
estrutura da tabela fato

estrutura das dimensões

chaves substitutas

comportamento SCD

carga do fato

histórico das dimensões

agregações

regras de certificação
```

Esses aspectos pertencem à arquitetura do Warehouse / Gold.

### 13.18 O Gerenciamento do Histórico das Dimensões Está Fora Desta Estratégia

O mecanismo de captura pode afetar quais evidências históricas estão disponíveis.

Por exemplo:

```text
CDC
```

pode fornecer evidências de alteração mais detalhadas do que:

```text
Full Refresh Controlado
```

Entretanto, decidir se uma dimensão *downstream* utiliza:

```text
Tipo 1

Tipo 2

outro modelo histórico
```

não é uma decisão de captura.

A captura fornece evidências.

A modelagem dimensional decide como essas evidências serão representadas analiticamente.

### 13.19 Power BI Está Fora Desta Estratégia

O Power BI consome dados analíticos certificados.

A Estratégia de Captura não define:

```text
modelo semântico

medidas

DAX

relacionamentos

configuração de atualização

segurança em nível de linha

design de dashboards

layout dos relatórios
```

Essas responsabilidades existem após a Gold e a Certified Gold.

### 13.20 A Orquestração com Airflow Está Fora Desta Estratégia

O Airflow faz parte do direcionamento mais amplo de orquestração da V1.

Posteriormente, ele poderá orquestrar atividades como:

```text
extração incremental

execução de snapshot

full refresh

backfill

reconciliação

verificações de qualidade de dados

carga da Gold
```

A Estratégia de Captura define o que essas operações devem realizar.

Ela não define:

```text
estrutura das DAGs

dependências entre tarefas

configuração de novas tentativas

agendamento

pools

sensors

metadados do Airflow
```

Esses aspectos pertencem à implementação da orquestração.

### 13.21 A Implementação da Observabilidade Está Fora Desta Estratégia

A arquitetura mais ampla inclui:

```text
Prometheus
Grafana
```

e poderá incluir posteriormente:

```text
OpenTelemetry
```

A Estratégia de Captura identifica condições que merecem ser observadas, como:

```text
lag do CDC

risco relacionado à retenção

falhas na extração da origem

anomalias de snapshot

falhas de full refresh
```

Ela não define:

```text
nomes das métricas

labels

dashboards

alertas

limites

pipelines de telemetria
```

Esses aspectos pertencem ao projeto de Observabilidade.

### 13.22 O Catálogo de Dados e a Plataforma de Metadados Estão Fora Desta Estratégia

A arquitetura futura do Atlas Engineering poderá incluir:

```text
OpenMetadata
```

ou outra plataforma de metadados.

A Estratégia de Captura fornece informações que poderão posteriormente contribuir para:

```text
linhagem

responsabilidade pela origem

mecanismo de captura

contratos de dados

metadados operacionais
```

Ela não define a implementação da própria plataforma de metadados.

### 13.23 Schema Registry Está Fora Desta Estratégia

A arquitetura V1 inclui:

```text
Apicurio Schema Registry
```

como uma capacidade transversal de governança de contratos.

Sua função não é definir como as alterações da origem são capturadas.

Em vez disso, ele governa os *schemas* de eventos ou mensagens *downstream*.

Portanto, a Estratégia de Captura não define:

```text
nomenclatura dos subjects

modo de compatibilidade

política de versionamento de schema

formato de serialização

ciclo de vida do registry
```

Esses aspectos pertencem à arquitetura de contratos de dados e mensageria.

### 13.24 A Estratégia de Captura Não Define o Caminho Físico das Mensagens

Diagramas arquiteturais podem apresentar:

```text
CDC
        ↓
Debezium
        ↓
Schema Registry
        ↓
Kafka
```

para facilitar a compreensão conceitual.

Entretanto, um *schema registry* não é necessariamente uma etapa física de transporte pela qual cada mensagem passa.

Sua função é a governança transversal de contratos.

A Estratégia de Captura evita, portanto, atribuir semântica de roteamento físico de mensagens a componentes que estão fora do limite de aquisição na origem.

### 13.25 A Recuperação É Compartilhada entre as Camadas Arquiteturais

A captura possui responsabilidades de recuperação, mas a recuperação não é exclusivamente uma responsabilidade da captura.

Exemplos:

```text
CDC
→ alterações retidas na origem

Kafka
→ mensagens retidas

Bronze
→ histórico durável de ingestão

checkpoint
→ posição conhecida de processamento

Silver
→ transformação repetível

Gold
→ estado analítico recarregável
```

Cada camada contribui para a capacidade de recuperação.

Portanto:

> **A recuperação de ponta a ponta é uma propriedade arquitetural produzida por múltiplas camadas, e não apenas pela captura na origem.**

### 13.26 Replay Está Fora da Estratégia de Captura

A captura pode tornar o *replay* possível ao preservar ou expor informações recuperáveis da origem.

Entretanto:

```text
replay do Kafka

reprocessamento da Bronze

nova execução da Silver

rebuild da Gold
```

são operações *downstream*.

A Estratégia de Captura não define sua implementação.

Ela apenas garante que o modelo de aquisição na origem não impeça desnecessariamente uma recuperação futura.

### 13.27 A Reconciliação Se Estende Além da Captura

A reconciliação no nível da captura pode perguntar:

```text
os dados esperados da origem chegaram?
```

Uma reconciliação mais ampla da plataforma pode perguntar:

```text
a Bronze corresponde à ingestão?

a Silver está reconciliada com a Bronze?

a Gold está reconciliada com a Silver?

os totais de negócio estão reconciliados
com a origem?
```

A Estratégia de Captura é responsável apenas pela parte dessa cadeia relacionada à aquisição na origem.

### 13.28 O Desempenho Além do Limite da Origem É uma Responsabilidade Separada

A Estratégia de Captura deve proteger o AtlasCommerce.

Portanto, as preocupações no lado da origem incluem:

```text
custo das consultas

sobrecarga do CDC

custo do snapshot

custo do full refresh

pressão causada pelo backfill
```

Entretanto, o desempenho após a aquisição pertence a outros componentes.

Exemplos incluem:

```text
throughput do Kafka

throughput do consumidor

throughput de gravação do Parquet

desempenho do MinIO

tempo de processamento da Silver

tempo de carga da Gold

tempo de atualização do Power BI
```

Esses aspectos estão fora desta estratégia.

### 13.29 A Latência da Plataforma É de Ponta a Ponta

A captura contribui para a latência dos dados.

Ela não é responsável por todo o SLO de latência.

A arquitetura atual distingue:

```text
alteração na origem
        ↓
visibilidade na captura
        ↓
entrega
        ↓
processamento pelo consumidor
        ↓
persistência na Bronze
```

O objetivo formal de latência da plataforma V1 é mais amplo do que apenas a captura na origem.

Portanto:

```text
CDC aparece após ~6 segundos
no laboratório
```

não comprova:

```text
P95 da plataforma ≤ 15 minutos
```

Este último exige medição de ponta a ponta.

### 13.30 A Segurança Além do Acesso à Origem Está Fora Desta Estratégia

A implementação da captura exigirá acesso apropriado ao AtlasCommerce.

Entretanto, preocupações mais amplas de segurança, como:

```text
ACLs do Kafka

permissões do MinIO

secrets do Airflow

identidades de serviço

gerenciamento de certificados

acesso ao Power BI

mascaramento de dados

segurança em nível de linha
```

pertencem às suas respectivas camadas arquiteturais.

### 13.31 A Qualidade de Dados É Mais Ampla do que a Correção da Captura

A correção da captura pergunta:

```text
Adquirimos aquilo que a origem expôs?
```

A qualidade de dados faz perguntas mais amplas:

```text
O valor da origem é válido?

A regra de negócio é atendida?

O relacionamento é plausível?

O valor monetário está correto?

O significado analítico é consistente?
```

A Estratégia de Captura não tenta resolver todas as questões de qualidade de dados.

Ela garante que as camadas *downstream* recebam evidências confiáveis da origem, com semântica conhecida.

### 13.32 Defeitos na Origem Não São Automaticamente Defeitos de Captura

Se o AtlasCommerce contiver:

```text
valor de negócio incorreto
```

e a plataforma capturar esse valor exatamente, o mecanismo de captura pode estar funcionando corretamente.

Conceitualmente:

```text
dado incorreto na origem
        ↓
captura correta
        ↓
valor incorreto chega ao downstream
```

Isso é diferente de:

```text
dado correto na origem
        ↓
captura perde ou corrompe o dado
```

O primeiro caso é um problema da origem ou de qualidade de dados.

O segundo é um problema de correção da captura.

A distinção deve permanecer explícita durante o *troubleshooting*.

### 13.33 A Estratégia de Captura Termina Antes da Transformação de Negócio

O limite formal pode, portanto, ser representado como:

```text
┌──────────────────────────────────────────────┐
│              ESTRATÉGIA DE CAPTURA           │
│                                              │
│ AtlasCommerce                                │
│      ↓                                       │
│ classificar comportamento da origem          │
│      ↓                                       │
│ selecionar mecanismo                         │
│      ↓                                       │
│ estabelecer limite de aquisição              │
│      ↓                                       │
│ identificar / adquirir dados ou alterações   │
│ da origem                                    │
└──────────────────────┬───────────────────────┘
                       │
                       │ limite
                       ▼
┌──────────────────────────────────────────────┐
│          ARQUITETURA DOWNSTREAM              │
│                                              │
│ consumir                                     │
│ entregar                                     │
│ persistir                                    │
│ registrar checkpoint                         │
│ realizar nova tentativa                      │
│ deduplicar                                   │
│ reconciliar                                  │
│ transformar                                  │
│ modelar                                      │
│ disponibilizar                               │
└──────────────────────────────────────────────┘
```

### 13.34 Limite por Mecanismo

O término da Estratégia de Captura também pode ser analisado separadamente para cada mecanismo.

```text
CDC

DML na origem
   ↓
Transaction Log
   ↓
SQL Server Native CDC
   ↓
alteração disponível no CDC
   │
   └── FIM DA ESTRATÉGIA DE CAPTURA
```

```text
TIMESTAMP INCREMENTAL

linhas atuais da origem
   ↓
predicado validado de watermark
   ↓
linhas alteradas necessárias identificadas
   │
   └── FIM DA ESTRATÉGIA DE CAPTURA
```

```text
SNAPSHOT + DIFF

estado anterior aceito
        +
estado atual da origem
        ↓
diferença de estado identificada
        │
        └── FIM DA ESTRATÉGIA DE CAPTURA
```

```text
FULL REFRESH CONTROLADO

estado atual da origem
        ↓
estado autoritativo validado e identificado
        │
        └── FIM DA ESTRATÉGIA DE CAPTURA
```

A representação exata da transferência para o ambiente *downstream* poderá variar conforme a implementação.

Essa representação não é definida por esta estratégia.

### 13.35 O Que Este Documento Pode Referenciar

A Estratégia de Captura pode mencionar componentes futuros para explicar o contexto arquitetural.

Por exemplo:

```text
A Bronze se tornará o histórico durável.
```

ou:

```text
O Kafka fornecerá posteriormente mensageria downstream.
```

Essas referências explicam por que uma decisão de captura faz sentido.

Elas não transferem para este documento a responsabilidade pela implementação desses componentes.

Essa distinção permite que a estratégia permaneça conectada à arquitetura sem se transformar em uma especificação de implementação de toda a plataforma.

### 13.36 O Que Este Documento Não Deve Afirmar

A Estratégia de Captura não deve reivindicar evidências de implementação para componentes que ainda não tenham sido testados.

No estágio atual do projeto, ela não deve afirmar:

```text
Debezium validado

Kafka validado

Bronze validada

Silver validada

Gold validada

checkpoint/reinicialização validados

idempotência de ponta a ponta validada

recuperação de ponta a ponta validada

desempenho em escala de produção validado
```

Da mesma forma, ela não deve transformar:

```text
arquitetura planejada
```

em:

```text
comportamento observado
```

### 13.37 Transferência de Responsabilidade

A transferência de responsabilidade arquitetural é:

```text
Estratégia de Captura
        ↓
define o mecanismo de aquisição na origem
        ↓
Implementação da Captura
        ↓
comprova o comportamento da origem
        ↓
Consumo
        ↓
lê as alterações / o estado adquiridos
        ↓
Mensageria / Persistência
        ↓
entrega e armazena
        ↓
Transformação
        ↓
cria a semântica analítica
        ↓
Disponibilização
        ↓
fornece dados analíticos certificados
```

Cada camada deve possuir suas próprias:

```text
decisões
implementação
evidências
limitações
```

Essa separação impede que um teste bem-sucedido seja generalizado incorretamente para toda a arquitetura.

### 13.38 Limite Atual do Atlas Engineering

No estágio atual do projeto:

```text
Estratégia de Captura
→ V1 Aprovada

implementação do SQL Server CDC
no lado da origem
→ validada até M01.19

consumo CDC
→ próxima etapa de implementação

implementação do Timestamp Incremental
→ pendente

implementação de Snapshot + Diff
→ pendente

implementação de Full Refresh Controlado
→ pendente

Debezium
→ pendente

Kafka
→ pendente

Bronze
→ pendente

Silver
→ pendente

Gold
→ pendente

integração com Power BI
→ pendente
```

Esse é o limite correto de maturidade atual.

### 13.39 Resumo dos Limites da Estratégia

A Estratégia de Captura V1 é responsável por:

```text
COMPREENSÃO DA ORIGEM
        +
CLASSIFICAÇÃO DAS ALTERAÇÕES
        +
SELEÇÃO DO MECANISMO
        +
REQUISITOS DE CAPTURA
NO LADO DA ORIGEM
        +
ESTRATÉGIA PARA O ESTADO INICIAL
        +
PRINCÍPIOS DE CUTOVER
        +
CONSIDERAÇÕES DE RECUPERAÇÃO
NO LADO DA ORIGEM
        +
TRADE-OFFS CONHECIDOS
```

Ela não é responsável por:

```text
implementação do connector do Debezium

topologia do Kafka

garantias de entrega do Kafka

implementação do consumidor

persistência de checkpoints

design dos arquivos da Bronze

transformações da Silver

modelagem da Gold

semântica do Power BI

DAGs do Airflow

métricas do Prometheus

dashboards do Grafana

implementação do OpenTelemetry

implementação do OpenMetadata

idempotência de ponta a ponta

recuperação de ponta a ponta
```

O limite que rege essa responsabilidade é:

> **A Estratégia de Captura termina quando as alterações necessárias da origem ou seu estado autoritativo tiverem sido identificados e adquiridos de forma confiável.**

A disciplina arquitetural é:

> **Uma capacidade *downstream* pode depender da captura, mas isso não a torna uma responsabilidade da captura.**

E o princípio de evidência é:

> **A validação no lado da origem comprova apenas o comportamento no lado da origem; toda garantia *downstream* exige suas próprias evidências de implementação.**

---

## 14. Resumo das Decisões

A Estratégia de Captura V1 do Atlas Engineering define como as alterações e o estado das origens são identificados e adquiridos a partir do AtlasCommerce para o domínio inicial de Sales Analytics.

A estratégia não utiliza um mecanismo universal de captura.

Em vez disso, cada origem é avaliada de acordo com:

```text
frequência de alteração
requisito de latência
volume de dados
tolerância à perda de alterações
confiabilidade da watermark
requisito de visibilidade de DELETE
sobrecarga operacional
```

Isso resulta em quatro padrões de captura:

```text
SQL Server Native CDC

Timestamp Incremental

Snapshot + Diff

Full Refresh Controlado
```

A estratégia é considerada:

```text
V1 — Aprovada
```

Essa aprovação significa que a arquitetura de captura e a fundamentação para a seleção dos mecanismos foram aceitas para o escopo atual da V1.

Isso não significa que todos os mecanismos já tenham sido implementados ou comprovados operacionalmente.

A distinção que rege a estratégia permanece:

```text
DECISÃO ARQUITETURAL
        ≠
IMPLEMENTAÇÃO
        ≠
EVIDÊNCIA DE TESTE
        ≠
COMPROVAÇÃO DE PONTA A PONTA
```

### 14.1 Classificação de Origens Aprovada para a V1

A classificação atual da V1 é:

```text
A — ALTO VOLUME DE ALTERAÇÕES
────────────────────────────────────
sales.Transaction
sales.TransactionItem


B — ALTERAÇÕES OCASIONAIS
────────────────────────────────────
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category


C — REFERÊNCIA
────────────────────────────────────
sales.TransactionStatus
sales.TransactionChannel


D — BAIXO VOLUME DE ALTERAÇÕES / SEM WATERMARK
────────────────────────────────────
catalog.ProductCategory
```

Essa classificação orienta a seleção do mecanismo.

Ela não é apenas um metadado descritivo.

Uma mudança no comportamento da origem pode exigir uma mudança no mecanismo de captura.

### 14.2 Seleção de Mecanismos Aprovada para a V1

O mapeamento aprovado entre origens e mecanismos na V1 é:

```text
sales.Transaction
        ↓
SQL Server Native CDC


sales.TransactionItem
        ↓
SQL Server Native CDC
```

```text
catalog.Product
        ↓
Timestamp Incremental


catalog.ProductVariant
        ↓
Timestamp Incremental


catalog.Brand
        ↓
Timestamp Incremental


catalog.Category
        ↓
Timestamp Incremental
```

```text
catalog.ProductCategory
        ↓
Snapshot + Diff
```

```text
sales.TransactionStatus
        ↓
Full Refresh Controlado


sales.TransactionChannel
        ↓
Full Refresh Controlado
```

A arquitetura, portanto, utiliza intencionalmente:

```text
mecanismos diferentes
para comportamentos diferentes das origens
```

em vez de forçar todas as origens a utilizar o mesmo caminho de captura.

### 14.3 Decisão sobre CDC

SQL Server Native CDC é o mecanismo aprovado para:

```text
sales.Transaction
sales.TransactionItem
```

A decisão baseia-se na natureza transacional dessas origens e na necessidade de visibilidade confiável de:

```text
INSERT
UPDATE
DELETE
```

incluindo o comportamento de `DELETE` físico.

O modelo V1 do CDC no lado da origem é:

```text
DML da Aplicação
        ↓
Transaction Log do SQL Server
        ↓
SQL Server Native CDC
        ↓
Change Tables do CDC
```

O Debezium pertence ao caminho de entrega *downstream*.

Ele não é tratado nesta arquitetura como um leitor direto do *Transaction Log* do SQL Server.

### 14.4 Evidências de CDC Atualmente Disponíveis

A implementação do SQL Server CDC já produziu evidências controladas no lado da origem até:

```text
M01.19
```

Os comportamentos validados incluem:

```text
habilitação do CDC no banco de dados

habilitação do CDC no nível da tabela

criação da instância de captura

criação da Change Table

estrutura dos metadados do CDC

ausência de backfill retroativo pelo CDC

captura assíncrona

captura de INSERT

captura de UPDATE BEFORE / AFTER

comportamento da update mask

múltiplos comandos SQL
dentro de uma transação

contexto transacional entre tabelas
no lado da origem

captura de DELETE físico

comportamento da captura com ON DELETE CASCADE

inspeção dos jobs do CDC

configuração de retenção

conhecimento da restrição relacionada
ao partition SWITCH
```

Portanto:

```text
SQL Server Native CDC
```

já não é apenas uma hipótese arquitetural para as duas tabelas transacionais.

Seu comportamento no lado da origem foi materialmente validado.

Entretanto:

```text
CDC VALIDADO NO LADO DA ORIGEM
```

não significa:

```text
PIPELINE CDC VALIDADO
DE PONTA A PONTA
```

### 14.5 Decisão sobre a Janela de Recuperação do CDC

A decisão de retenção do CDC na V1 é:

```text
15 dias
```

ou:

```text
21600 minutos
```

O objetivo é fornecer tempo operacional para recuperação em situações como:

```text
finais de semana
feriados
incidentes
indisponibilidade de consumidores
investigação
reparo
reprocessamento
```

Essa retenção é explicitamente interpretada como:

```text
BUFFER DE RECUPERAÇÃO DO CDC
```

e não como:

```text
ARMAZENAMENTO HISTÓRICO PERMANENTE
```

O histórico durável de ingestão de longo prazo pertence ao ambiente *downstream*.

### 14.6 Decisão sobre Partition SWITCH com CDC

As tabelas transacionais são particionadas.

O CDC está configurado permitindo *partition switching*.

A estratégia, portanto, aceita:

```text
allow_partition_switch = 1
```

com governança explícita.

A principal regra semântica é:

```text
movimentação de partição
≠
DML comum no nível da linha
```

Um futuro:

```text
SWITCH IN
```

não deve se tornar o caminho normal de ingestão transacional sem revisão arquitetural.

Da mesma forma:

```text
SWITCH OUT
```

não deve ser automaticamente interpretado como um `DELETE` de negócio.

A manutenção de partições deve ser coordenada com Engenharia de Dados.

### 14.7 Decisão sobre Timestamp Incremental

*Timestamp* Incremental é a hipótese V1 aprovada para:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

O mecanismo foi selecionado porque essas origens são classificadas como dados descritivos com alterações ocasionais.

O modelo pretendido é:

```text
watermark confiável
        ↓
consulta incremental na origem
        ↓
linhas atuais alteradas
```

Entretanto, a palavra crítica permanece:

```text
confiável
```

A simples existência de uma coluna de *timestamp* é insuficiente.

### 14.8 Requisito de Validação do Timestamp Incremental

Antes que *Timestamp* Incremental seja considerado comprovado para qualquer origem da Categoria B, a implementação deve validar:

```text
responsabilidade pela watermark

comportamento de atualização da watermark

comportamento de INSERT

comportamento de UPDATE

precisão do timestamp

linhas com o mesmo timestamp

igualdade no limite

visibilidade da transação

possível retrocesso

comportamento de NULL, se aplicável

requisitos de DELETE físico

desempenho da consulta na origem

comportamento de reinicialização

comportamento do checkpoint

sobreposição controlada
```

Portanto, o status atual é:

```text
MECANISMO SELECIONADO
        ↓
VALIDAÇÃO DA IMPLEMENTAÇÃO PENDENTE
```

Se a *watermark* da origem não atender a esses requisitos, o mecanismo de captura deverá ser reconsiderado.

### 14.9 Decisão sobre a Fidelidade do Timestamp Incremental

*Timestamp* Incremental é aceito como:

```text
captura do estado atual alterado
```

e não como:

```text
histórico completo de eventos da origem
```

Múltiplas atualizações na origem entre ciclos de extração podem ser consolidadas no estado mais recente da linha que estiver visível.

O `DELETE` físico não é inerentemente detectável.

Essas limitações são aceitas apenas enquanto permanecerem compatíveis com o requisito analítico.

### 14.10 Decisão sobre Snapshot + Diff

*Snapshot* + *Diff* é o mecanismo V1 aprovado para:

```text
catalog.ProductCategory
```

A estrutura atual da origem não expõe uma *watermark* confiável adequada para *Timestamp* Incremental.

O mecanismo utiliza, portanto:

```text
estado anterior aceito
        +
estado atual da origem
        ↓
comparação
```

para derivar:

```text
ADDED
REMOVED
UNCHANGED
```

A identidade do relacionamento é atualmente representada por:

```text
PRDCT_PRD_id
+
PRDCT_CTG_id
```

### 14.11 Semântica das Evidências do Snapshot + Diff

O mecanismo produz:

```text
evidência de diferença entre estados
```

e não necessariamente:

```text
evidência de eventos da origem
```

Por exemplo:

```text
relacionamento existia anteriormente
+
relacionamento ausente agora
```

sustenta:

```text
REMOVED
```

Isso não comprova automaticamente:

```text
timestamp exato do DELETE
```

ou:

```text
comando DELETE específico
da aplicação
```

A estratégia preserva explicitamente essa distinção.

### 14.12 Decisão sobre a Segurança do Snapshot

A completude do *snapshot* é um pré-requisito para uma comparação confiável.

Portanto:

```text
extrair
        ↓
validar snapshot
        ↓
calcular diff
```

é a ordem conceitual exigida.

E não:

```text
extrair
        ↓
derivar remoções imediatamente
```

Caso contrário, um *snapshot* incompleto poderia gerar exclusões falsas.

A implementação deve preservar o *snapshot* anterior aceito até que o estado candidato tenha sido validado e promovido com segurança.

### 14.13 Decisão sobre Full Refresh Controlado

*Full Refresh* Controlado é o mecanismo V1 aprovado para:

```text
sales.TransactionStatus
sales.TransactionChannel
```

O requisito atual é:

```text
estado atual autoritativo
```

e não:

```text
histórico completo de eventos da origem
```

O mecanismo, portanto, favorece a simplicidade para esses pequenos conjuntos de dados de referência.

A linha de base atualmente observada na origem é:

```text
TransactionStatus
5 linhas

TransactionChannel
2 linhas
```

Esses valores são observações.

Eles não são contratos permanentes de quantidade de linhas.

### 14.14 Decisão sobre a Segurança do Full Refresh

Um *full refresh* não deve significar uma substituição destrutiva sem controle.

O modelo conceitual exigido é:

```text
extrair todo o estado necessário
        ↓
criar estado candidato
        ↓
validar
        ↓
promover
        ↓
novo estado aceito
```

O estado anterior aceito deve permanecer disponível caso a atualização candidata falhe.

Isso impede que atualizações parciais ou inválidas substituam dados de referência confiáveis.

### 14.15 Decisão sobre o Initial Backfill

A estratégia V1 distingue:

```text
estado existente na origem
```

de:

```text
alteração futura capturada
```

As linhas existentes devem ser carregadas por meio do:

```text
Initial Backfill
```

enquanto as alterações contínuas na origem são protegidas pelo mecanismo de captura selecionado.

Para a linha de base transacional inicial, as evidências no lado da origem identificaram:

```text
sales.Transaction
6306 linhas existentes

sales.TransactionItem
13769 linhas existentes
```

O CDC não carregou retroativamente essas linhas em suas *Change Tables*.

Esse comportamento foi comprovado.

### 14.16 Decisão sobre o Cutover

O princípio aprovado de *cutover* é:

> **Proteja o futuro primeiro e, depois, carregue o passado.**

Conceitualmente:

```text
estabelecer captura contínua
        ↓
estabelecer limite
        ↓
verificar a proteção das alterações futuras
        ↓
iniciar Initial Backfill
        ↓
processar alterações acumuladas
        ↓
reconciliar sobreposição
        ↓
entrar em estado estável
```

A estratégia prefere intencionalmente:

```text
sobreposição controlada
```

a:

```text
lacuna silenciosa
```

porque a sobreposição pode ser reconciliada, enquanto uma lacuna não capturada pode ser irrecuperável.

### 14.17 Decisão sobre Evidências Históricas

A plataforma não deve fabricar histórico de eventos anterior à captura.

Para os dados existentes:

```text
estado conhecido da linha
```

pode ser carregado.

Entretanto, uma sequência não observada como:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

não deve ser reconstruída, a menos que uma fonte autoritativa a comprove.

A regra que rege essa decisão é:

> **Eventos históricos desconhecidos permanecem desconhecidos.**

### 14.18 Decisão sobre Garantia de Entrega

A arquitetura V1 mais ampla seleciona:

```text
At-Least-Once
+
Idempotência
```

em vez de reivindicar:

```text
Exactly-Once de ponta a ponta
```

A Estratégia de Captura oferece suporte a essa filosofia ao aceitar sobreposição controlada quando necessário.

Entretanto, a idempotência de ponta a ponta continua sendo uma responsabilidade de implementação *downstream* e ainda não foi comprovada.

### 14.19 Decisão sobre Proteção da Origem

O AtlasCommerce permanece como a origem OLTP operacional.

Portanto:

> **A saúde do sistema OLTP possui prioridade sobre a conveniência analítica.**

Os mecanismos de captura e *backfill* devem ser projetados para evitar pressão desnecessária sobre a origem.

Isso inclui a validação futura de:

```text
planos das consultas incrementais

custo da extração de snapshots

custo do full refresh

carga do backfill histórico

sobrecarga operacional do CDC
```

Nenhum requisito de Engenharia de Dados justifica desestabilizar o sistema transacional.

### 14.20 Modelo de Evidências da Captura

Os quatro mecanismos fornecem diferentes tipos de evidência.

```text
SQL Server Native CDC
→ alterações capturadas na origem
```

```text
Timestamp Incremental
→ linhas atuais que indicam alteração
```

```text
Snapshot + Diff
→ diferenças entre estados aceitos
```

```text
Full Refresh Controlado
→ estado atual autoritativo
```

Esses tipos de evidência não devem ser tratados como intercambiáveis.

O mecanismo de captura determina o que poderá posteriormente ser afirmado sobre o histórico.

### 14.21 Matriz V1 Aprovada

A matriz final de decisões da V1 é:

| Origem | Classificação | Mecanismo de Captura V1 | Status Atual |
|---|---|---|---|
| `sales.Transaction` | A — Alto Volume de Alterações | SQL Server Native CDC | Selecionado, implementado no lado da origem, testado até M01.19 |
| `sales.TransactionItem` | A — Alto Volume de Alterações | SQL Server Native CDC | Selecionado, implementado no lado da origem, testado até M01.19 |
| `catalog.Product` | B — Alterações Ocasionais | *Timestamp* Incremental | Hipótese selecionada; validação da implementação pendente |
| `catalog.ProductVariant` | B — Alterações Ocasionais | *Timestamp* Incremental | Hipótese selecionada; validação da implementação pendente |
| `catalog.Brand` | B — Alterações Ocasionais | *Timestamp* Incremental | Hipótese selecionada; validação da implementação pendente |
| `catalog.Category` | B — Alterações Ocasionais | *Timestamp* Incremental | Hipótese selecionada; validação da implementação pendente |
| `catalog.ProductCategory` | D — Baixo Volume de Alterações / Sem Watermark | *Snapshot* + *Diff* | Selecionado; validação da implementação pendente |
| `sales.TransactionStatus` | C — Referência | *Full Refresh* Controlado | Selecionado; validação da implementação pendente |
| `sales.TransactionChannel` | C — Referência | *Full Refresh* Controlado | Selecionado; validação da implementação pendente |

Essa matriz representa a estratégia V1 aprovada.

Ela não implica o mesmo nível de maturidade de implementação para todas as linhas.

### 14.22 Estado Atual de Maturidade

A maturidade atual da Estratégia de Captura pode ser resumida como:

```text
ESTRATÉGIA DE CAPTURA
→ V1 Aprovada


SQL SERVER CDC
Transaction
TransactionItem
→ implementação no lado da origem
validada até M01.19


TIMESTAMP INCREMENTAL
Product
ProductVariant
Brand
Category
→ implementação pendente


SNAPSHOT + DIFF
ProductCategory
→ implementação pendente


FULL REFRESH CONTROLADO
TransactionStatus
TransactionChannel
→ implementação pendente


INITIAL BACKFILL
→ estratégia definida 
implementação pendente


CUTOVER CONTROLADO
→ estratégia definida 
implementação de ponta a ponta pendente
```

Esse é o estado atual correto do projeto.

### 14.23 Gatilhos para Revisão da Estratégia

A Estratégia de Captura V1 deve ser revisada caso as evidências ou os requisitos mudem de forma relevante.

Os gatilhos para revisão incluem:

```text
a frequência de alterações da origem aumenta

o volume da origem muda de forma significativa

o requisito de latência muda

DELETE físico torna-se obrigatório para uma origem que não consegue detectá-lo

a watermark do Timestamp Incremental mostra-se não confiável

a extração de snapshots torna-se excessivamente custosa

as origens de referência passam a exigir rastreamento histórico de eventos

as operações de partição mudam

a retenção do CDC mostra-se insuficiente

o impacto do armazenamento do CDC torna-se excessivo

alterações no schema da origem afetam chaves ou a semântica da watermark

novos produtos de dados analíticos exigem um nível diferente de fidelidade de captura

o modelo de disponibilidade da origem muda

surgem novos requisitos de recuperação
```

Um gatilho de revisão não significa automaticamente que o projeto atual esteja errado.

Significa que as premissas que sustentam a decisão devem ser reavaliadas.

### 14.24 Procedimento para Alteração de uma Decisão

Quando uma decisão de captura for questionada por novas evidências, a estratégia deve seguir:

```text
NOVA EVIDÊNCIA / REQUISITO
        ↓
identificar a premissa afetada
        ↓
reavaliar a classificação da origem
        ↓
reavaliar os critérios de captura
        ↓
comparar mecanismos candidatos
        ↓
registrar nova decisão
        ↓
implementar
        ↓
testar
        ↓
atualizar as evidências
        ↓
versionar a estratégia
```

Isso mantém a arquitetura orientada por evidências, em vez de estática.

### 14.25 A Estratégia É Versionada, Não Permanente

O status:

```text
V1 — Aprovada
```

significa:

```text
aprovada para o escopo atual da V1 e para as evidências atuais
```

Não significa:

```text
arquitetura permanente
```

Versões futuras podem legitimamente alterar:

```text
classificação das origens

mecanismos de captura

janelas de recuperação

procedimentos de cutover

restrições operacionais
```

A arquitetura evolui quando evidências ou requisitos justificam essa evolução.

### 14.26 Decisão Versus Documentação da Implementação

Este documento registra:

```text
POR QUÊ
```

a estratégia de captura foi selecionada.

A documentação separada da implementação do SQL Server CDC registra:

```text
COMO
```

as decisões atuais de CDC foram materializadas e:

```text
O QUE FOI OBSERVADO
```

durante os testes controlados.

Portanto:

```text
Estratégia de Captura
→ fundamentação e decisões arquiteturais
```

enquanto:

```text
Implementação do SQL Server CDC 
→ comandos, configuração, testes, observações, correções e evidências
```

Essa distinção deve ser preservada à medida que o projeto evolui.

### 14.27 Próximo Limite de Implementação

Com a Estratégia de Captura V1 documentada, a próxima etapa de implementação do CDC é:

```text
M01.20 — Consumo CDC
```

começando por:

```text
M01.20A — Inspeção da Janela de LSN
```

Essa etapa avança além de:

```text
O SQL Server consegue capturar as alterações?
```

para:

```text
Como um consumidor deve identificar e processar uma janela confiável do CDC?
```

As próximas questões incluem:

```text
LSN mínimo disponível

LSN máximo disponível

from_lsn

to_lsn

limites da janela

funções de todas as alterações

representação de UPDATE

progressão do checkpoint

reinicialização

replay

sobreposição controlada

semântica do consumidor
```

Essas questões pertencem ao Consumo CDC e devem ser respondidas experimentalmente.

### 14.28 Decisão Final da V1

A Estratégia de Captura V1 final do Atlas Engineering é:

```text
ORIGENS TRANSACIONAIS COM ALTO VOLUME DE ALTERAÇÕES
        ↓
SQL Server Native CDC


ORIGENS DESCRITIVAS COM ALTERAÇÕES OCASIONAIS
        ↓
Timestamp Incremental
        ↓
somente quando a confiabilidade da watermark for comprovada


RELACIONAMENTO COM BAIXO VOLUME DE ALTERAÇÕES E SEM WATERMARK CONFIÁVEL
        ↓
Snapshot + Diff


PEQUENAS ORIGENS DE REFERÊNCIA NAS QUAIS O ESTADO ATUAL É SUFICIENTE
        ↓
Full Refresh Controlado
```

Os dados iniciais são tratados por meio de:

```text
Initial Backfill
```

com o princípio de *cutover*:

```text
proteger o futuro primeiro depois carregar o passado
```

e a preferência, em caso de falha, por:

```text
sobreposição controlada em vez de lacuna silenciosa
```

A captura na origem é tratada como:

```text
uma responsabilidade de aquisição
```

e não como:

```text
armazenamento histórico permanente
```

e cada mecanismo permanece sujeito a revisão baseada em evidências.

### 14.29 Princípios Finais

A Estratégia de Captura V1 é regida pelos seguintes princípios consolidados:

```text
Utilize o mecanismo compatível com o comportamento da origem.

Não imponha um único mecanismo de captura a todas as origens.

Proteja o sistema OLTP.

Prefira sobreposição controlada à perda silenciosa.

Não invente um histórico que nunca foi observado.

Trate uma watermark como um contrato, não apenas como uma coluna de timestamp.

Trate snapshots como evidência somente após validar sua completude.

Trate full refresh como promoção controlada de estado, e não como substituição destrutiva.

Trate a retenção do CDC como tempo para recuperação, e não como histórico permanente.

Preserve a diferença entre alterações físicas na origem e significado de negócio.

Avance o progresso somente após processamento seguro e durável.

Diferencie decisão arquitetural, implementação, evidência e comprovação de ponta a ponta.

Revise a estratégia quando novas evidências invalidarem uma premissa.
```

O princípio arquitetural final é:

> **A captura deve fornecer a fidelidade mínima necessária da origem sem aceitar perda silenciosa de dados nem complexidade operacional desnecessária.**

O princípio final de evidência é:

> **O Atlas Engineering afirma apenas aquilo que suas evidências atuais conseguem sustentar.**

E o princípio final de governança é:

> **Uma decisão de captura permanece válida apenas enquanto as premissas que a justificaram permanecerem válidas.**