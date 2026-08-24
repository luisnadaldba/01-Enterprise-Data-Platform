# SQL Server 2025 Developer Edition - Instalação e Configuração do Ambiente

**Document ID:** ENV-SQL-001  

**Data de Instalação:** 2026-08-09  

**Ambiente:** Desenvolvimento Local  

**Servidor:** NADAL-0001  

**Versão do SQL Server:** SQL Server 2025  

**Edição:** Developer Edition (64-bit)  

**Versão do Produto:** 17.0.1000.7  

**Nível do Produto:** RTM  

**Instância:** MSSQLSERVER (Instância Padrão)  

**Status:** Instalado e Validado

---

## 1. Objetivo

Este documento descreve a instalação, a configuração inicial e a validação do ambiente de desenvolvimento SQL Server 2025 utilizado pela Atlas Engineering Enterprise Data Platform.

O objetivo não é apenas documentar o procedimento de instalação, mas também estabelecer um *baseline* reproduzível para o ambiente SQL Server.

Esse *baseline* poderá ser utilizado posteriormente para:

- Reconstrução do ambiente
- Diagnóstico de problemas
- Comparação de configurações
- Avaliações de migração de servidores
- Exercícios de recuperação de desastres
- Documentação de infraestrutura
- Validação de ambientes de origem e destino

---

## 2. Visão Geral do Ambiente

O ambiente SQL Server foi instalado localmente na estação de trabalho:

    Nome da Máquina  : NADAL-0001
    Nome da Instância: Instância Padrão
    Nome do Serviço  : MSSQLSERVER
    SQL Server       : 2025
    Edição           : Developer Edition (64-bit)
    Versão do Produto: 17.0.1000.7
    Nível do Produto : RTM

O SQL Server Management Studio 22 foi instalado como a principal interface para administração e desenvolvimento de bancos de dados.

---

## 3. Decisões de Instalação

### 3.1 Edição do SQL Server

Foi selecionado o SQL Server 2025 Developer Edition.

A Developer Edition fornece o conjunto de funcionalidades do SQL Server Enterprise para fins de desenvolvimento e testes, sem exigir uma licença Enterprise de produção.

Isso permite que o ambiente do projeto desenvolva e valide arquiteturas e funcionalidades avançadas do SQL Server, permanecendo como um ambiente de não produção.

---

### 3.2 Configuração da Instância

Foi selecionada uma instância padrão do SQL Server.

    Nome da Instância: MSSQLSERVER

A instância padrão simplifica a conectividade no ambiente de desenvolvimento local, preservando a capacidade de realizar atividades de configuração, validação e avaliação da instância.

---

### 3.3 Autenticação

A instância SQL Server foi configurada para oferecer suporte à Autenticação do SQL Server além da Autenticação do Windows.

O acesso administrativo foi validado utilizando a Autenticação do Windows.

A conta do Windows:

    NADAL-0001\luisn

foi confirmada como membro da função fixa de servidor `sysadmin` do SQL Server.

O *login* `sa` também estava disponível no ambiente de desenvolvimento local para cenários controlados de administração e testes.

Para atividades administrativas normais, a Autenticação do Windows deve ser preferida.

---

## 4. Collation do SQL Server

A instância SQL Server foi instalada utilizando a seguinte *collation*:

    Latin1_General_CI_AS

As seguintes *collations* dos bancos de dados de sistema foram validadas:

    master : Latin1_General_CI_AS
    tempdb : Latin1_General_CI_AS

Propriedades adicionais da *collation* foram coletadas:

    Página de Código      : 1252
    Estilo de Comparação  : 196609

Testes funcionais de comparação confirmaram:

    'Atlas' = 'ATLAS' -> Igual
    'cafe'  = 'café'  -> Diferente

Esses resultados são consistentes com uma *collation* que não diferencia maiúsculas de minúsculas (`CI`) e diferencia acentos (`AS`).

A *collation* faz parte do *baseline* do ambiente porque diferenças entre a instância SQL Server, `tempdb` e os bancos de dados de usuário podem afetar:

- Comparações de *strings*
- Ordenação
- *Joins*
- Objetos temporários
- Comportamento das aplicações
- Integração de dados
- Compatibilidade de migração

Atenção especial deve ser dada às diferenças de *collation* envolvendo `tempdb`, pois objetos temporários podem participar de comparações com objetos de bancos de dados de usuário e produzir conflitos de *collation* quando *collations* incompatíveis estão envolvidas.

---

## 5. Configuração de Recursos do Servidor

A configuração inicial de recursos do SQL Server foi coletada e registrada como parte do *baseline* da instalação.

Esses valores descrevem o ambiente de desenvolvimento no momento da validação e não devem ser interpretados como recomendações universais para ambientes de produção.

### 5.1 Memória

O ambiente reportou aproximadamente:

    Memória Física     : 16068 MB
    Max Server Memory  : 10752 MB
    Min Server Memory  : 0 MB

A configuração `max server memory (MB)` foi intencionalmente limitada a 10752 MB para que parte da memória física permanecesse disponível para o Windows e outros aplicativos executados na estação de trabalho de desenvolvimento.

A configuração `min server memory (MB)` permaneceu em 0 MB.

Um valor mínimo configurado de 0 MB não significa que o SQL Server utiliza zero memória. Ele representa o limite inferior de memória configurado que o SQL Server pode tentar reter depois que a memória tiver sido adquirida e não deve ser interpretado como o consumo atual de memória do SQL Server.

Nenhum ajuste adicional de memória foi realizado durante a configuração inicial do ambiente.

Os valores registrados estabelecem o *baseline* inicial de configuração de memória para comparações e avaliações posteriores.

---

### 5.2 CPU e Paralelismo

O ambiente reportou as seguintes características de processadores e escalonamento do SQL Server:

    Quantidade de CPUs Lógicas : 20
    Quantidade de Sockets      : 1
    Núcleos por Socket         : 10
    Nós NUMA                   : 2
    Quantidade de Schedulers   : 20
    Máximo de Worker Threads   : 768
    Soft-NUMA                  : ON

A configuração inicial de paralelismo foi registrada como:

    MAXDOP                         : 4
    Cost Threshold for Parallelism : 5

Esses valores representam a topologia dos processadores, as características de escalonamento e a configuração de paralelismo observadas durante a validação inicial do ambiente.

`MAXDOP` foi configurado como 4 para o ambiente de desenvolvimento atual.

O valor de `cost threshold for parallelism` permaneceu em 5 e foi registrado como parte do *baseline* inicial de configuração. Esse valor não deve ser interpretado como uma recomendação geral para cargas de trabalho de produção.

Nenhum ajuste adicional de paralelismo foi realizado durante a configuração inicial do ambiente, pois ainda não havia sido estabelecido um comportamento representativo da carga de trabalho.

Alterações futuras na configuração de paralelismo devem ser baseadas nas características da carga de trabalho, topologia dos processadores, concorrência, medições de desempenho e avaliação técnica documentada.

---

## 6. Configuração do tempdb

A instalação do SQL Server criou oito arquivos de dados do `tempdb`.

No momento da validação inicial do ambiente, cada arquivo de dados estava configurado com:

    Tamanho Inicial : 128 MB
    Crescimento     : 128 MB

O arquivo de log de transações do `tempdb` estava configurado com:

    Tamanho Inicial : 256 MB
    Crescimento     : 128 MB

Os arquivos utilizam *autogrowth* de tamanho fixo em vez de crescimento baseado em percentual.

Os arquivos de dados do `tempdb` foram configurados com tamanhos iniciais iguais e incrementos de crescimento iguais, estabelecendo uma configuração inicial equilibrada dos arquivos para o ambiente de desenvolvimento.

Essa configuração é registrada como parte do *baseline* da instalação e não deve ser interpretada como uma recomendação universal para outros ambientes SQL Server.

O número, tamanho e configuração de crescimento apropriados para os arquivos do `tempdb` dependem de características como:

- Topologia dos processadores
- Comportamento da carga de trabalho
- Concorrência
- Arquitetura de armazenamento
- Capacidade de armazenamento disponível
- Uso observado do `tempdb`

O *autogrowth* de tamanho fixo fornece um comportamento de crescimento mais previsível do que o crescimento baseado em percentual.

O *autogrowth* deve ser tratado como um mecanismo de segurança, e não como a principal estratégia de gerenciamento de capacidade. Sempre que possível, o `tempdb` deve ser dimensionado proativamente de acordo com os requisitos da carga de trabalho e o armazenamento disponível.

Como o `tempdb` é recriado sempre que o SQL Server Database Engine é iniciado, sua configuração também deve ser considerada parte do *baseline* de configuração da instância SQL Server.

---

## 7. Configuração dos Arquivos de Banco de Dados

Os arquivos dos bancos de dados de sistema do SQL Server foram revisados como parte da validação inicial do ambiente.

A avaliação incluiu:

- Localizações físicas dos arquivos
- Tamanhos atualmente alocados
- Valores de *autogrowth*
- Tipos de *autogrowth*
- Tamanhos máximos configurados dos arquivos

Alguns arquivos dos bancos de dados de sistema mantiveram configurações de *autogrowth* baseadas em percentual provenientes da instalação inicial do SQL Server, enquanto outros utilizavam *autogrowth* de tamanho fixo.

Esses valores foram preservados e registrados como parte do *baseline* original da instalação.

O *autogrowth* de tamanho fixo fornece um comportamento de alocação mais previsível do que o crescimento baseado em percentual, pois a quantidade alocada durante cada evento de crescimento permanece constante, em vez de aumentar à medida que o arquivo se torna maior.

Entretanto, uma configuração apropriada de crescimento de arquivos depende de características como:

- Tamanho atual do banco de dados
- Taxa esperada de crescimento
- Comportamento da carga de trabalho
- Desempenho do armazenamento
- Capacidade de armazenamento disponível
- Requisitos de recuperação
- Requisitos operacionais

Diferentes bancos de dados e tipos de arquivos podem, portanto, exigir diferentes configurações de crescimento.

O *autogrowth* deve ser tratado como um mecanismo de segurança, e não como a principal estratégia de gerenciamento de capacidade. Os arquivos de banco de dados devem, preferencialmente, ser dimensionados proativamente de acordo com o crescimento esperado, o comportamento da carga de trabalho e o armazenamento disponível.

O crescimento do log de transações exige consideração adicional porque o crescimento do arquivo de log não recebe o mesmo benefício de Instant File Initialization que o crescimento dos arquivos de dados.

Nenhuma alteração foi realizada na configuração dos arquivos dos bancos de dados de sistema durante a configuração inicial do ambiente.

Os valores observados foram mantidos como o *baseline* original da instalação para avaliações e comparações posteriores.

---

## 8. Instant File Initialization

O Instant File Initialization (IFI) foi validado para o serviço SQL Server Database Engine.

A validação foi realizada utilizando:

    sys.dm_server_services

O ambiente reportou:

    SQL Server (MSSQLSERVER) : Enabled

O Instant File Initialization permite que o SQL Server aloque espaço para arquivos de dados sem primeiro zerar toda a região recém-alocada.

Isso pode reduzir significativamente o tempo necessário para operações que envolvem alocação de arquivos de dados, incluindo:

- Criação de bancos de dados
- Crescimento de arquivos de dados
- Operações de restauração de bancos de dados

O Instant File Initialization aplica-se aos arquivos de dados do SQL Server.

Os arquivos de log de transações ainda exigem inicialização e não recebem o mesmo benefício de desempenho do IFI.

O IFI é, portanto, relevante para o *baseline* do ambiente ao avaliar:

- Comportamento de criação de bancos de dados
- *Autogrowth* de arquivos de dados
- Duração de restaurações
- Preparação para migração
- Expectativas de recuperação
- Diferenças entre ambientes de origem e destino

O estado habilitado observado durante a validação inicial foi registrado como parte do *baseline* da instalação do SQL Server.

A configuração deve ser validada independentemente ao construir ou avaliar outro ambiente SQL Server, pois depende da conta de serviço do Database Engine e dos privilégios atribuídos no sistema operacional.

---

## 9. Serviços do SQL Server

Os serviços do SQL Server foram revisados como parte da validação inicial do ambiente.

Os seguintes serviços foram confirmados:

    SQL Server (MSSQLSERVER)

        Tipo de Inicialização : Automatic
        Status                : Running
        Conta                 : NT Service\MSSQLSERVER
        IFI                   : Enabled

    SQL Server Agent (MSSQLSERVER)

        Tipo de Inicialização : Automatic
        Status                : Running
        Conta                 : NT Service\SQLSERVERAGENT

Ambos os serviços foram confirmados como operacionais no momento da validação inicial do ambiente.

A configuração dos serviços faz parte do *baseline* operacional e de segurança porque pode afetar:

- Disponibilidade do SQL Server
- Comportamento de inicialização dos serviços
- Operações administrativas
- *Jobs* agendados e automação
- Acesso ao sistema de arquivos e à rede
- Operações de backup e restauração
- Configurações de alta disponibilidade
- Instant File Initialization

O Instant File Initialization é operacionalmente relevante para o serviço SQL Server Database Engine e não deve ser interpretado da mesma maneira para outros serviços do SQL Server.

As contas de serviço são configurações específicas de cada ambiente e não devem ser copiadas automaticamente ao construir ou migrar para outro ambiente SQL Server.

As identidades e permissões dos serviços devem ser projetadas de acordo com:

- Requisitos de segurança
- Arquitetura de domínio
- Requisitos operacionais
- Requisitos de alta disponibilidade
- Requisitos de backup e restauração
- Requisitos de acesso ao sistema de arquivos e à rede
- Padrões organizacionais para contas de serviço

As contas de serviço utilizadas por este ambiente de desenvolvimento são contas de serviço virtuais locais e foram mantidas como parte da configuração inicial do ambiente.

A configuração das contas de serviço deve ser revisada independentemente ao projetar outro ambiente.

---

## 10. Configuração de Rede

A configuração de rede do SQL Server foi revisada utilizando o SQL Server Configuration Manager como parte da validação inicial do ambiente.

A seguinte configuração de protocolos foi registrada:

    Shared Memory : Enabled
    Named Pipes   : Disabled
    TCP/IP        : Disabled

Essa configuração reflete os requisitos iniciais de desenvolvimento exclusivamente local do ambiente Atlas Engineering.

O Shared Memory fornece conectividade local entre aplicações e a instância SQL Server executada no mesmo computador.

O TCP/IP foi intencionalmente mantido desabilitado porque a conectividade remota com o SQL Server não era necessária durante a configuração inicial do ambiente.

O Named Pipes também foi mantido desabilitado porque não era necessário para a arquitetura atual de desenvolvimento local.

A configuração dos protocolos não deve ser interpretada como uma recomendação geral para outros ambientes SQL Server.

Os requisitos de rede devem ser revisados sempre que a arquitetura introduzir componentes que exijam conectividade com a instância SQL Server a partir de fora do host local, como:

- Clientes remotos
- Serviços externos de ingestão
- *Containers*
- Máquinas virtuais
- Serviços de aplicação
- Componentes de integração de dados
- Serviços de monitoramento ou administração

Quando a conectividade remota se tornar necessária, os protocolos de rede exigidos pelo SQL Server, a configuração de escuta, as regras de *firewall*, os requisitos de autenticação e os controles de segurança deverão ser avaliados de acordo com a arquitetura de destino.

O estado dos protocolos registrado nesta seção representa o *baseline* inicial da configuração de rede e deve ser reavaliado à medida que a arquitetura do Atlas Engineering evoluir.

---

## 11. Baseline Inicial de Configuração

Valores selecionados de configuração no nível da instância SQL Server foram coletados e registrados como parte do *baseline* inicial do ambiente:

    Backup Compression Default      : 0
    Blocked Process Threshold (s)   : 0
    Cost Threshold for Parallelism  : 5
    MAXDOP                          : 4
    Max Server Memory (MB)          : 10752
    Optimize for Ad Hoc Workloads   : 0
    Remote Admin Connections        : 0

Esses valores representam a configuração da instância SQL Server registrada durante a validação inicial do ambiente.

Eles estabelecem um ponto de referência para comparações posteriores de configuração, diagnóstico de problemas, avaliação de migrações e análise de desempenho.

Os valores registrados não devem ser interpretados como recomendações universais nem como uma configuração final de produção.

Alguns valores podem refletir os padrões do SQL Server, enquanto outros podem representar decisões de configuração tomadas especificamente para o ambiente de desenvolvimento local.

Alterações futuras de configuração devem ser baseadas em:

- Características da carga de trabalho
- Medições de desempenho
- Hardware e ambiente operacional
- Requisitos de concorrência
- Requisitos de recuperação
- Requisitos de segurança
- Requisitos de arquitetura
- Decisões técnicas documentadas

Quando alterações de configuração forem introduzidas, o *baseline* original da instalação deve permanecer preservado para que a evolução do ambiente possa ser compreendida e comparada ao longo do tempo.

---

## 12. Validação do Ambiente

Um *script* de diagnóstico dedicado é mantido para avaliar e validar o ambiente SQL Server:

    04-Scripts/
        05-Diagnostics/
            Assess-SQL-Server-Environment.sql

O *script* fornece uma avaliação somente leitura de diversas características da instância SQL Server, incluindo:

- Identidade da instância
- Versão e edição do SQL Server
- Autenticação e acesso administrativo
- *Collations* da instância, dos bancos de dados de sistema e do banco de dados atual
- Comportamento de comparação da *collation*
- Configuração de memória
- Topologia de CPU e NUMA
- Opções de configuração do SQL Server
- Instant File Initialization
- Configuração do `tempdb`
- Configuração dos bancos de dados de sistema
- Arquivos de banco de dados e *autogrowth*
- Serviços do SQL Server

O *script* não modifica configurações do SQL Server, objetos de banco de dados, dados de aplicações ou dados de usuários.

Ele pode ser utilizado para:

- Avaliação inicial do ambiente
- Coleta do *baseline* do ambiente
- Avaliação pré-migração
- Comparação pós-migração
- Diagnóstico de problemas
- Comparação entre ambientes

O *script* de diagnóstico foi executado e validado com sucesso no ambiente de desenvolvimento local atual.

Ele é mantido como o mecanismo técnico reutilizável de avaliação do ambiente SQL Server e complementa o *baseline* de instalação documentado aqui.

---

## 13. Relevância para Migração

A avaliação do ambiente estabelecida durante a configuração inicial do SQL Server também fornece a base para um processo reutilizável de avaliação de migrações.

Antes de migrar um ambiente SQL Server, informações relevantes de configuração e do ambiente devem ser coletadas no ambiente de origem.

Depois que o ambiente de destino for construído, a mesma avaliação poderá ser realizada novamente para que os ambientes sejam comparados sistematicamente.

A comparação pode ajudar a identificar diferenças relacionadas a:

- Versão e edição do SQL Server
- Autenticação e acesso administrativo
- *Collation*
- Configuração de memória
- Topologia de CPU e NUMA
- Configuração de paralelismo
- Compatibilidade dos bancos de dados
- Configuração dos bancos de dados de sistema
- Organização dos arquivos de banco de dados
- Tamanho dos arquivos e configuração de *autogrowth*
- Configuração do `tempdb`
- Serviços do SQL Server
- Contas de serviço
- Instant File Initialization

Características adicionais específicas de migração, como configuração de rede, requisitos de conectividade, dependências de segurança e requisitos de integração com aplicações, devem ser avaliadas separadamente quando aplicável.

O *script* de diagnóstico `Assess-SQL-Server-Environment.sql` fornece um mecanismo reutilizável e somente leitura para coletar uma parcela significativa desse *baseline* técnico a partir do SQL Server.

As informações coletadas não devem ser utilizadas simplesmente para reproduzir a configuração de origem no servidor de destino.

Em vez disso, os resultados de origem e destino devem ser comparados para determinar quais diferenças são:

- Esperadas devido à arquitetura de destino
- Alterações intencionais de configuração
- Questões de compatibilidade
- Requisitos operacionais ou de segurança
- Itens que exigem validação técnica adicional

Essa abordagem fornece um processo repetível de avaliação entre origem e destino e reduz a dependência de inspeções manuais não documentadas.

---

## 14. Considerações de Segurança

O acesso administrativo a um ambiente SQL Server não deve depender exclusivamente da conta pessoal de um único indivíduo.

Uma estratégia apropriada de acesso administrativo deve considerar:

- Requisitos de acesso privilegiado
- Continuidade administrativa
- Recuperação do acesso administrativo
- Separação entre identidades pessoais e de serviço
- Requisitos de auditoria
- Políticas organizacionais de segurança

A Autenticação do Windows deve ser preferida para operações administrativas normais quando apropriada ao ambiente e ao modelo de segurança da organização.

O *login* `sa`, quando habilitado, deve ser tratado como uma conta altamente privilegiada.

Sua disponibilidade não deve substituir uma estratégia apropriada de acesso e recuperação administrativa, e seu uso deve ser restrito de acordo com os requisitos de segurança do ambiente.

As contas de serviço também devem ser tratadas como configurações de segurança específicas do ambiente.

Ao construir ou migrar um ambiente SQL Server, as identidades e os privilégios dos serviços devem ser revisados independentemente de acordo com:

- Privilégios necessários no sistema operacional
- Acesso ao sistema de arquivos
- Acesso à rede
- Requisitos de backup e restauração
- Requisitos de alta disponibilidade
- Arquitetura de domínio
- Padrões organizacionais para contas de serviço

As configurações administrativas e das contas de serviço não devem ser copiadas automaticamente de um ambiente de origem para um ambiente de destino.

A configuração de segurança deve ser avaliada de acordo com a arquitetura, os requisitos operacionais e as políticas de segurança do ambiente de destino.

---

## 15. Lições Aprendidas

O processo de instalação e validação reforçou que instalar o SQL Server é apenas uma parte do estabelecimento de um ambiente de banco de dados confiável.

Um ambiente reproduzível também exige compreender e documentar:

- O que foi instalado
- Como o ambiente foi configurado
- Por que as decisões de configuração foram tomadas
- Quais valores representam padrões da instalação
- Quais valores foram alterados intencionalmente
- Quais configurações dependem da carga de trabalho ou da arquitetura
- Como o ambiente pode ser avaliado e validado de forma independente

O processo de validação também demonstrou a importância de verificar os procedimentos de diagnóstico em relação aos metadados disponíveis na versão instalada do SQL Server.

Durante a avaliação inicial, `instant_file_initialization_enabled` foi consultado a partir de:

    sys.dm_os_sys_info

A informação necessária não estava disponível nessa DMV no ambiente instalado.

A inspeção dos metadados disponíveis no SQL Server identificou como fonte apropriada:

    sys.dm_server_services

O procedimento de diagnóstico foi então corrigido para obter as informações de Instant File Initialization a partir da DMV apropriada.

Essa experiência reforçou um importante princípio de diagnóstico:

> Não adapte o ambiente para fazer uma consulta de diagnóstico funcionar. Valide os metadados disponíveis na plataforma instalada e adapte o procedimento de diagnóstico ao ambiente real.

*Scripts* de diagnóstico devem, portanto, ser tratados como ferramentas técnicas sensíveis à versão, cujas premissas devem ser validadas em relação ao ambiente SQL Server no qual são executados.

---

## 16. Evolução do Ambiente

A instalação do SQL Server e a validação inicial do ambiente estabeleceram a plataforma local de banco de dados necessária para as etapas subsequentes do Atlas Engineering.

O ambiente destina-se a suportar o desenvolvimento e a evolução contínuos da plataforma, incluindo:

- Desenvolvimento de bancos de dados transacionais
- Implantação e validação do modelo de dados
- Implantação controlada de dados
- Ingestão e integração de dados
- Cargas de trabalho de engenharia de dados
- Estruturas de dados analíticas
- Monitoramento e diagnóstico
- Avaliação e ajuste de desempenho
- Evolução da segurança
- Validação do ambiente e da arquitetura

À medida que a plataforma evoluir, alterações na configuração do SQL Server poderão se tornar necessárias devido a novas cargas de trabalho, componentes arquiteturais, requisitos de conectividade, observações de desempenho ou requisitos operacionais.

Alterações introduzidas após a configuração inicial do ambiente devem ser documentadas separadamente deste *baseline* de instalação.

O *baseline* original deve permanecer preservado para que estados posteriores de configuração possam ser comparados com o ambiente conforme inicialmente instalado e validado.

Essa separação fornece uma referência histórica para compreender:

- Quais configurações pertenciam à instalação original
- Quais configurações foram alteradas posteriormente
- Por que cada alteração significativa foi introduzida
- Como o ambiente evoluiu juntamente com a arquitetura do Atlas Engineering

---

## 17. Documentação Relacionada

O seguinte *script* de diagnóstico fornece o mecanismo técnico reutilizável de avaliação associado ao ambiente SQL Server documentado aqui:

    04-Scripts/
        05-Diagnostics/
            Assess-SQL-Server-Environment.sql

O *script* complementa este *baseline* de instalação ao fornecer um mecanismo somente leitura para coletar e comparar informações da instância SQL Server, configurações, armazenamento, bancos de dados, contexto de segurança e serviços.

Este documento registra a instalação e o *baseline* inicial do ambiente, enquanto o *script* de diagnóstico fornece o mecanismo reutilizável para avaliar o ambiente ao longo do tempo.

---

## Status do Documento

**Status:** Concluído  

**Ambiente validado:** Sim  

**Data da validação inicial:** 2026-08-09