/*
===============================================================================
 Project      : Atlas Engineering - Enterprise Data Platform
 Script       : Assess-SQL-Server-Environment-PT-BR.sql
 Version      : 1.0.0
 Categoria    : Diagnóstico / Avaliação de Ambiente
 Escopo       : Instância SQL Server

 Objetivo
 --------
 Coleta as principais informações da instância SQL Server, ambiente
 operacional, segurança, bancos de dados, armazenamento e configurações
 necessárias para avaliação técnica e comparação entre ambientes.

 Este script pode ser utilizado para:
   - Avaliação inicial do ambiente
   - Coleta de baseline do ambiente
   - Avaliação pré-migração
   - Comparação pós-migração
   - Diagnóstico de problemas
   - Comparação entre ambientes

 Comportamento
 -------------
 Este script é somente leitura.

 Ele não:
   - Altera configurações do SQL Server
   - Modifica objetos de banco de dados
   - Modifica dados de aplicações ou usuários

===============================================================================
*/


/* ============================================================================
   01 - Informações da Instância SQL Server
   ============================================================================ */

SELECT
    @@SERVERNAME AS ServerName,
    @@SERVICENAME AS ServiceName,
    SERVERPROPERTY('MachineName') AS MachineName,
    SERVERPROPERTY('InstanceName') AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel;

/*
Objetivo:
    Identifica a instância SQL Server e a versão instalada.

Interpretação:
    ServerName:
        Nome do SQL Server registrado para a instância atual.

    ServiceName:
        Nome do serviço SQL Server associado à instância atual.

    MachineName:
        Nome do computador do sistema operacional reportado pelo SQL Server.

    InstanceName:
        Nome da instância SQL Server.

        NULL normalmente indica uma instância padrão.

    Edition:
        Edição instalada do SQL Server.

    ProductVersion:
        Versão instalada do produto SQL Server.

    ProductLevel:
        Nível de atualização do produto reportado pelo SQL Server.

Relevância para a avaliação:
    Essas informações estabelecem a identidade e o baseline de software da
    instância SQL Server.

    São úteis na comparação entre ambientes de origem e destino e na avaliação
    de diferenças relacionadas a:
        - Edição do SQL Server
        - Versão do produto
        - Nomenclatura da instância
        - Nomenclatura do serviço
        - Identidade do host

    Diferenças de edição e versão podem afetar disponibilidade de
    funcionalidades, compatibilidade, licenciamento e planejamento de
    migração.
*/


/* ============================================================================
   02 - Autenticação e Acesso Administrativo
   ============================================================================ */

SELECT
    ORIGINAL_LOGIN() AS OriginalLogin,
    SUSER_SNAME() AS CurrentLogin,
    SYSTEM_USER AS SystemUser,
    IS_SRVROLEMEMBER('sysadmin') AS IsSysAdmin,
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS WindowsAuthenticationOnly;

/*
Objetivo:
    Identifica o login utilizado para estabelecer a sessão SQL Server, o
    contexto de segurança atual, a associação à função sysadmin e o modo de
    autenticação configurado para a instância SQL Server.

Interpretação:
    OriginalLogin:
        Login utilizado originalmente para estabelecer a sessão SQL Server.

        Esse valor permanece associado à identidade original da conexão mesmo
        quando o contexto de execução é alterado.

    CurrentLogin:
        Login associado ao contexto atual de segurança do SQL Server.

    SystemUser:
        Nome do login do contexto de execução atual reportado pelo SQL Server.

    IsSysAdmin:
        1 = O login atual é membro da função fixa de servidor sysadmin.
        0 = O login atual não é membro da função fixa de servidor sysadmin.
        NULL = As informações do login ou da função de servidor não puderam
               ser resolvidas.

    WindowsAuthenticationOnly:
        1 = Somente modo de Autenticação do Windows.
        0 = Modo Misto
            (Autenticação do Windows e Autenticação do SQL Server).

Relevância para a avaliação:
    O modo de autenticação e o acesso administrativo são componentes
    importantes do baseline de segurança do SQL Server.

    Essas informações são úteis para avaliar:
        - Configuração de autenticação
        - Acesso administrativo atual
        - Contexto de execução
        - Requisitos de acesso para migração
        - Validação administrativa pós-migração

    O acesso administrativo não deve depender exclusivamente da conta pessoal
    do Windows de um único indivíduo.

    O projeto do ambiente deve fornecer uma estratégia adequada de acesso
    administrativo de acordo com os requisitos organizacionais de segurança,
    operação, recuperação e auditoria.

Observações:
    Um valor 1 para IsSysAdmin confirma que o login atual pertence à função
    sysadmin. Isso não avalia se esse nível de privilégio é apropriado para a
    conta.

    Esta seção reporta o contexto atual de autenticação e execução.

    Ela não enumera todos os principais de servidor, associações a funções de
    servidor, permissões ou contas privilegiadas configuradas na instância.
*/


/* ============================================================================
   03 - Collation
   ============================================================================ */

-- Coleta as collations da instância SQL Server e dos bancos de sistema
SELECT
    SERVERPROPERTY('Collation') AS ServerCollation,
    DATABASEPROPERTYEX('master', 'Collation') AS MasterCollation,
    DATABASEPROPERTYEX('tempdb', 'Collation') AS TempDBCollation,
    DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS CurrentDatabaseCollation;


-- Obtém as propriedades da collation da instância SQL Server
SELECT
    SERVERPROPERTY('Collation') AS CollationName,
    COLLATIONPROPERTY
    (
        CONVERT(varchar(128), SERVERPROPERTY('Collation')),
        'CodePage'
    ) AS CodePage,
    COLLATIONPROPERTY
    (
        CONVERT(varchar(128), SERVERPROPERTY('Collation')),
        'ComparisonStyle'
    ) AS ComparisonStyle;


/* ---------------------------------------------------------------------------
   Comportamento de Comparação do Banco de Dados Atual
   --------------------------------------------------------------------------- */

SELECT
    DB_NAME() AS DatabaseName,
    DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS DatabaseCollation,

    CASE
        WHEN
            CAST(N'Atlas' AS nvarchar(20)) COLLATE DATABASE_DEFAULT
            =
            CAST(N'ATLAS' AS nvarchar(20)) COLLATE DATABASE_DEFAULT
        THEN 'Equal'
        ELSE 'Different'
    END AS CaseComparison,

    CASE
        WHEN
            CAST(N'cafe' AS nvarchar(20)) COLLATE DATABASE_DEFAULT
            =
            CAST(N'café' AS nvarchar(20)) COLLATE DATABASE_DEFAULT
        THEN 'Equal'
        ELSE 'Different'
    END AS AccentComparison;

/*
Objetivo:
    Coleta a collation da instância SQL Server, as collations selecionadas dos
    bancos de sistema, a collation do banco de dados atual e propriedades da
    collation.

    Também avalia o comportamento de comparação entre maiúsculas/minúsculas e
    acentos utilizando a collation do banco de dados atual.

Interpretação:
    ServerCollation:
        Collation padrão configurada para a instância SQL Server.

    MasterCollation:
        Collation configurada para o banco de sistema master.

    TempDBCollation:
        Collation configurada para tempdb.

    CurrentDatabaseCollation:
        Collation configurada para o banco de dados no qual este script está
        sendo executado atualmente.

    CodePage:
        Página de código associada à collation da instância SQL Server para
        dados não Unicode dos tipos char e varchar.

    ComparisonStyle:
        Representação numérica das características de comparação associadas à
        collation da instância SQL Server.

    CaseComparison:
        Informa se a collation do banco de dados atual considera 'Atlas' e
        'ATLAS' iguais.

    AccentComparison:
        Informa se a collation do banco de dados atual considera 'cafe' e
        'café' iguais.

Relevância para a avaliação:
    Diferenças de collation podem afetar:
        - Comparação de strings
        - Ordenação
        - Joins
        - Objetos temporários
        - Comportamento de aplicações
        - Integração de dados
        - Compatibilidade de migração

    Atenção especial deve ser dada às diferenças entre:
        - Collation da instância SQL Server
        - Collation de tempdb
        - Collations dos bancos de dados de usuário

    Objetos temporários criados em tempdb podem participar de comparações com
    objetos de bancos de dados de usuário, podendo produzir conflitos de
    collation quando collations incompatíveis estão envolvidas.

Observações:
    Os testes de comparação de maiúsculas/minúsculas e acentos utilizam
    intencionalmente DATABASE_DEFAULT.

    Portanto, esses testes descrevem o comportamento da collation do banco de
    dados atual e não devem ser interpretados como testes comportamentais
    diretos da collation da instância SQL Server.

    A collation da instância SQL Server é coletada separadamente por meio de
    SERVERPROPERTY('Collation').
*/


/* ============================================================================
   04 - Memória e Paralelismo do SQL Server
   ============================================================================ */

SELECT
    name AS ConfigurationName,
    value AS ConfiguredValue,
    value_in_use AS ValueInUse,
    minimum AS MinimumValue,
    maximum AS MaximumValue,
    is_dynamic AS IsDynamic,
    is_advanced AS IsAdvanced
FROM sys.configurations
WHERE name IN
(
    'min server memory (MB)',
    'max server memory (MB)',
    'max degree of parallelism'
)
ORDER BY name;

/*
Objetivo:
    Coleta os principais valores de configuração de memória e paralelismo do
    SQL Server.

    São retornados tanto o valor configurado quanto o valor atualmente em uso.

Interpretação:
    ConfiguredValue:
        Valor armazenado na configuração do SQL Server.

    ValueInUse:
        Valor atualmente ativo na instância SQL Server.

    IsDynamic:
        1 = A configuração pode entrar em vigor sem reiniciar o SQL Server.
        0 = Uma reinicialização pode ser necessária para que a alteração entre
            em vigor.

    IsAdvanced:
        Indica se o SQL Server classifica a opção como uma configuração
        avançada.

    min server memory (MB):
        Define o limite inferior de memória que o SQL Server pode tentar reter
        depois que a memória tiver sido adquirida.

        Um valor configurado de 0 não significa que o SQL Server utiliza zero
        de memória.

    max server memory (MB):
        Define o limite superior de memória configurado e controlado por essa
        configuração do SQL Server.

        Esse valor deve ser avaliado em conjunto com a memória física total,
        requisitos do sistema operacional, outros serviços e características
        da carga de trabalho.

    max degree of parallelism:
        Limita o número de processadores que podem participar da execução de um
        único plano de consulta paralelo.

Relevância para a avaliação:
    Configurações de memória e paralelismo são componentes importantes do
    baseline de desempenho do SQL Server.

    Esses valores devem ser avaliados em conjunto com:
        - Memória física
        - Topologia de CPU
        - Número de processadores lógicos
        - Arquitetura NUMA
        - Características da carga de trabalho
        - Requisitos do sistema operacional
        - Outros serviços executados no host

    Ao comparar ambientes de origem e destino, valores de configuração não
    devem ser copiados automaticamente de um servidor para outro.

    O ambiente de destino pode exigir configurações diferentes devido a
    diferenças de hardware, carga de trabalho, concorrência e requisitos
    operacionais.

Observações:
    Esta seção apenas coleta valores de configuração.

    Ela não determina se os valores atuais são ideais ou recomendados para a
    carga de trabalho.

    Alterações de configuração relacionadas a desempenho devem ser baseadas em
    um baseline adequado, observação da carga de trabalho, medição e validação
    posterior.
*/


/* ============================================================================
   05 - Informações do Sistema Operacional e CPU
   ============================================================================ */

SELECT
    sql_memory_model_desc AS SqlMemoryModel,
    softnuma_configuration_desc AS SoftNumaConfiguration,
    socket_count AS SocketCount,
    cores_per_socket AS CoresPerSocket,
    cpu_count AS LogicalCpuCount,
    numa_node_count AS NumaNodeCount,
    physical_memory_kb / 1024 AS PhysicalMemoryMB,
    scheduler_count AS SchedulerCount,
    max_workers_count AS MaxWorkersCount,
    sqlserver_start_time AS SqlServerStartTime,
    virtual_machine_type_desc AS VirtualMachineType
FROM sys.dm_os_sys_info;

/*
Objetivo:
    Coleta informações de hardware e do ambiente operacional do SQL Server
    visíveis ao Database Engine.

    O resultado fornece contexto para análises de configuração e desempenho
    envolvendo:
        - Memória
        - Topologia de CPU
        - Paralelismo
        - NUMA
        - Schedulers
        - Worker threads
        - Virtualização

Interpretação:
    SqlMemoryModel:
        Descreve o modelo de memória atualmente utilizado pelo SQL Server.

    SoftNumaConfiguration:
        Descreve a configuração Soft-NUMA do SQL Server reportada pelo
        Database Engine.

        O valor reportado deve ser interpretado juntamente com a topologia dos
        processadores e a versão do SQL Server, e não de forma isolada.

    SocketCount:
        Número de sockets de processador visíveis ao SQL Server.

    CoresPerSocket:
        Número de núcleos de processador por socket visíveis ao SQL Server.

    LogicalCpuCount:
        Número de processadores lógicos visíveis ao SQL Server.

    NumaNodeCount:
        Número de nós NUMA visíveis ao SQL Server.

        Esse valor representa a topologia exposta ao Database Engine e deve
        ser avaliado juntamente com informações de hardware e Soft-NUMA.

    PhysicalMemoryMB:
        Quantidade aproximada de memória física visível ao SQL Server.

    SchedulerCount:
        Número de schedulers do SQL Server reportados pelo Database Engine.

        A quantidade de schedulers deve ser interpretada juntamente com a
        visibilidade dos processadores lógicos e o comportamento de
        escalonamento do SQL Server.

    MaxWorkersCount:
        Número máximo de worker threads disponíveis de acordo com a
        configuração de threads de trabalho do SQL Server.

    SqlServerStartTime:
        Data e hora em que o SQL Server Database Engine foi iniciado pela
        última vez.

    VirtualMachineType:
        Descreve como o SQL Server identifica o ambiente de virtualização.

Relevância para a avaliação:
    As características do hardware e do ambiente operacional são fundamentais
    para a avaliação de configuração e desempenho do SQL Server.

    Essas informações são úteis para avaliar:
        - Configuração de memória
        - MAXDOP
        - Capacidade de CPU
        - Topologia NUMA
        - Disponibilidade de schedulers
        - Capacidade de worker threads
        - Diferenças de virtualização
        - Dimensionamento dos servidores de origem e destino

    Valores de configuração de um ambiente SQL Server não devem ser
    transferidos automaticamente para outro ambiente.

    Diferenças na topologia dos processadores, memória, virtualização,
    organização NUMA, concorrência da carga de trabalho e condições
    operacionais podem exigir decisões de configuração diferentes.

Observações:
    SqlServerStartTime é uma informação operacional dinâmica e não deve ser
    tratada como um valor fixo de baseline.

    VirtualMachineType reporta a classificação de virtualização visível ao
    SQL Server. Isoladamente, ela não deve ser considerada evidência
    suficiente para descrever toda a arquitetura de infraestrutura subjacente.

    Os valores retornados por sys.dm_os_sys_info descrevem os recursos e a
    topologia visíveis ao SQL Server e podem diferir da configuração física
    completa do hardware do host.
*/


/* ============================================================================
   06 - Instant File Initialization
   ============================================================================ */

SELECT
    servicename AS ServiceName,
    instant_file_initialization_enabled AS InstantFileInitializationEnabled
FROM sys.dm_server_services
WHERE servicename LIKE 'SQL Server (%';

/*
Objetivo:
    Coleta o estado de Instant File Initialization (IFI) reportado para o
    serviço SQL Server Database Engine.

Interpretação:
    InstantFileInitializationEnabled:

        Y = Instant File Initialization está habilitado.
        N = Instant File Initialization está desabilitado.

    IFI permite que o SQL Server aloque espaço para arquivos de dados sem
    primeiro zerar toda a região recém-alocada.

    Isso pode reduzir significativamente o tempo necessário para:
        - Criação de bancos de dados
        - Crescimento de arquivos de dados
        - Operações de restauração de bancos de dados

Importante:
    Instant File Initialization aplica-se aos arquivos de dados do SQL Server.

    Arquivos de log de transações ainda exigem inicialização e não recebem o
    mesmo benefício de desempenho do IFI.

Relevância para a avaliação:
    IFI é uma parte importante do baseline de armazenamento e recuperação do
    SQL Server.

    Deve ser revisado ao avaliar:
        - Comportamento de criação de bancos de dados
        - Autogrowth de arquivos de dados
        - Duração de restaurações
        - Preparação para migração
        - Expectativas de recuperação
        - Configuração do servidor de destino

    Diferenças na configuração de IFI entre ambientes de origem e destino
    podem afetar a duração de migrações e recuperações.

Observações:
    O estado de Instant File Initialization é coletado a partir de
    sys.dm_server_services.

    Esta seção apenas reporta o estado atual de IFI.

    Ela não altera políticas de segurança do Windows, privilégios da conta de
    serviço do SQL Server ou configurações do SQL Server.
*/


/* ============================================================================
   07 - Configuração do TempDB
   ============================================================================ */

SELECT
    mf.file_id AS FileId,
    mf.name AS LogicalName,
    mf.type_desc AS FileType,
    mf.physical_name AS PhysicalPath,
    CAST(mf.size * 8.0 / 1024 AS decimal(18,2)) AS SizeMB,
    CASE
        WHEN mf.is_percent_growth = 1
            THEN CAST(mf.growth AS decimal(18,2))
        ELSE
            CAST(mf.growth * 8.0 / 1024 AS decimal(18,2))
    END AS GrowthValue,
    CASE
        WHEN mf.is_percent_growth = 1 THEN 'PERCENT'
        ELSE 'MB'
    END AS GrowthType,
    CASE
        WHEN mf.max_size = -1 THEN 'UNLIMITED'
        ELSE CAST(
            CAST(mf.max_size * 8.0 / 1024 AS decimal(18,2))
            AS varchar(30)
        )
    END AS MaxSizeMB
FROM sys.master_files AS mf
WHERE mf.database_id = DB_ID('tempdb')
ORDER BY
    mf.type_desc,
    mf.file_id;

/*
Objetivo:
    Coleta a configuração física dos arquivos de tempdb.

    A avaliação inclui:
        - Número de arquivos
        - Nomes lógicos dos arquivos
        - Tipos de arquivos
        - Localizações físicas
        - Tamanhos atualmente alocados
        - Valores de autogrowth
        - Tipos de autogrowth
        - Tamanhos máximos configurados dos arquivos

Interpretação:
    FileType:
        ROWS = Arquivo de dados de tempdb.
        LOG  = Arquivo de log de transações de tempdb.

    SizeMB:
        Tamanho atualmente alocado ao arquivo em MB.

    GrowthValue:
        Quantidade pela qual o arquivo cresce durante um evento de autogrowth.

    GrowthType:
        MB      = Autogrowth de tamanho fixo.
        PERCENT = Autogrowth baseado em percentual.

    MaxSizeMB:
        Tamanho máximo configurado do arquivo.

        UNLIMITED indica que o SQL Server não impõe um tamanho máximo
        configurado além da capacidade de armazenamento e dos limites do
        SQL Server.

Relevância para a avaliação:
    A configuração de tempdb é específica da instância e deve ser revisada
    como parte das avaliações de desempenho, armazenamento, migração e
    capacidade do SQL Server.

    Características importantes incluem:
        - Número de arquivos de dados
        - Dimensionamento relativo dos arquivos de dados
        - Configuração de autogrowth
        - Localização de armazenamento
        - Capacidade de armazenamento disponível
        - Topologia de CPU
        - Características da carga de trabalho

    Ao comparar ambientes, a configuração de tempdb de um servidor de origem
    não deve ser copiada automaticamente para um servidor de destino.

    O destino pode possuir topologia de processadores, arquitetura de
    armazenamento, memória, carga de trabalho e características de
    concorrência diferentes.

Observações:
    Os arquivos de dados de tempdb devem ser avaliados quanto ao equilíbrio de
    dimensionamento e configuração de crescimento.

    Autogrowth de tamanho fixo oferece comportamento de crescimento mais
    previsível do que crescimento baseado em percentual.

    Autogrowth deve ser tratado como um mecanismo de segurança, e não como a
    principal estratégia de gerenciamento de capacidade.

    Sempre que viável, tempdb deve ser dimensionado proativamente de acordo
    com a carga de trabalho e o armazenamento disponível.

    tempdb é recriado sempre que o SQL Server Database Engine é iniciado.

    Esta seção apenas coleta configurações e não determina o número ou tamanho
    ideal dos arquivos de tempdb para a carga de trabalho atual.
*/


/* ============================================================================
   08 - Bancos de Dados de Sistema
   ============================================================================ */

SELECT
    d.database_id AS DatabaseId,
    d.name AS DatabaseName,
    d.state_desc AS State,
    d.recovery_model_desc AS RecoveryModel,
    d.compatibility_level AS CompatibilityLevel,
    d.collation_name AS Collation,
    d.page_verify_option_desc AS PageVerify,
    d.is_auto_close_on AS AutoClose,
    d.is_auto_shrink_on AS AutoShrink,
    d.is_read_committed_snapshot_on AS ReadCommittedSnapshot
FROM sys.databases AS d
WHERE d.database_id <= 4
ORDER BY d.database_id;

/*
Objetivo:
    Coleta as principais propriedades de configuração dos bancos de dados de
    sistema do SQL Server.

    Os bancos de dados de sistema avaliados são:
        - master
        - tempdb
        - model
        - msdb

Interpretação:
    State:
        Indica o estado operacional atual do banco de dados.

    RecoveryModel:
        Identifica o modelo de recuperação configurado.

        O modelo de recuperação deve ser interpretado de acordo com a
        finalidade e o comportamento de cada banco de dados de sistema.

    CompatibilityLevel:
        Determina o comportamento de compatibilidade do banco de dados
        associado a uma versão do SQL Server.

    Collation:
        Define as regras padrão de comparação e ordenação de strings para o
        banco de dados.

    PageVerify:
        Identifica o mecanismo utilizado pelo SQL Server para detectar páginas
        de banco de dados danificadas.

    AutoClose:
        Indica se o SQL Server fecha automaticamente o banco de dados depois
        que a última conexão de usuário é encerrada.

    AutoShrink:
        Indica se o SQL Server tenta periodicamente reduzir automaticamente os
        arquivos do banco de dados.

    ReadCommittedSnapshot:
        Indica se READ COMMITTED utiliza versionamento de linhas no banco de
        dados.

Relevância para a avaliação:
    A configuração dos bancos de dados de sistema faz parte do baseline da
    instância SQL Server e deve ser revisada ao avaliar:
        - Saúde da instância
        - Consistência de configuração
        - Preparação para migração
        - Diferenças entre origem e destino
        - Comportamento de recuperação
        - Compatibilidade de collation
        - Configurações de manutenção dos bancos de dados

    Atenção especial deve ser dada a:
        - Estado do banco de dados
        - Nível de compatibilidade
        - Collation
        - Modelo de recuperação
        - Verificação de páginas
        - AUTO_CLOSE
        - AUTO_SHRINK

    Não se deve assumir que os bancos de dados de sistema possuem
    configurações idênticas simplesmente por pertencerem à mesma instância
    SQL Server ou porque dois ambientes utilizam versões semelhantes do
    SQL Server.

Observações:
    Modelos de recuperação e outras propriedades podem legitimamente diferir
    entre os bancos de dados de sistema de acordo com sua finalidade.

    AUTO_CLOSE e AUTO_SHRINK devem ser revisados, em vez de considerados como
    possuindo um valor esperado universal.

    Bancos de dados de usuário são intencionalmente excluídos desta seção.

    Eles devem ser avaliados separadamente porque suas configurações dependem
    dos requisitos de aplicação, recuperação, desempenho, disponibilidade e
    carga de trabalho.

    Esta seção apenas coleta configurações e não modifica nenhuma configuração
    dos bancos de dados de sistema.
*/


/* ============================================================================
   09 - Configurações Avançadas do SQL Server
   ============================================================================ */

SELECT
    name AS ConfigurationName,
    value AS ConfiguredValue,
    value_in_use AS ValueInUse,
    is_dynamic AS IsDynamic,
    is_advanced AS IsAdvanced
FROM sys.configurations
WHERE name IN
(
    'backup compression default',
    'blocked process threshold (s)',
    'cost threshold for parallelism',
    'max degree of parallelism',
    'max server memory (MB)',
    'optimize for ad hoc workloads',
    'remote admin connections'
)
ORDER BY name;

/*
Objetivo:
    Coleta valores selecionados de configuração no nível da instância SQL
    Server relevantes para administração, desempenho, diagnóstico de problemas
    e avaliação do ambiente.

Interpretação:
    ConfiguredValue:
        Valor armazenado na configuração do SQL Server.

    ValueInUse:
        Valor atualmente ativo na instância SQL Server.

    IsDynamic:
        Indica se a configuração pode entrar em vigor dinamicamente.

    IsAdvanced:
        Indica se o SQL Server classifica a opção como uma configuração
        avançada.

    backup compression default:
        Define se o SQL Server utiliza compressão de backup por padrão quando
        um comando de backup não especifica explicitamente o comportamento de
        compressão.

    blocked process threshold (s):
        Define a duração de bloqueio, em segundos, após a qual o SQL Server
        pode gerar relatórios de processos bloqueados quando o mecanismo de
        monitoramento apropriado está configurado.

        Um valor 0 significa que o limite está desabilitado.

    cost threshold for parallelism:
        Define o limite de custo estimado da consulta utilizado quando o SQL
        Server considera planos de execução paralelos.

    max degree of parallelism:
        Limita o número de processadores que podem participar da execução de um
        único plano de consulta paralelo.

    max server memory (MB):
        Define o limite superior de memória configurado e controlado por essa
        configuração do SQL Server.

    optimize for ad hoc workloads:
        Controla como o SQL Server armazena inicialmente planos de execução
        para consultas ad hoc no cache de planos.

    remote admin connections:
        Controla se a Dedicated Administrator Connection (DAC) pode ser
        estabelecida remotamente.

Relevância para a avaliação:
    A configuração no nível da instância é uma parte importante do baseline
    operacional e de desempenho do SQL Server.

    Essas configurações devem ser revisadas ao avaliar:
        - Comportamento de desempenho
        - Uso de memória
        - Paralelismo
        - Comportamento de backups
        - Uso do cache de planos
        - Diagnóstico de bloqueios
        - Capacidade de diagnóstico de problemas
        - Conectividade administrativa
        - Preparação para migração
        - Diferenças entre origem e destino

    Valores de configuração de um ambiente de origem não devem ser copiados
    automaticamente para um ambiente de destino.

    Cada configuração deve ser avaliada de acordo com:
        - Características de hardware
        - Comportamento da carga de trabalho
        - Concorrência
        - Requisitos operacionais
        - Requisitos de recuperação
        - Requisitos de segurança

Observações:
    Esta seção apenas coleta valores de configuração.

    Ela não determina se as configurações atuais são ideais para a carga de
    trabalho.

    Alterações de configuração relacionadas a desempenho devem,
    preferencialmente, seguir um processo controlado como:

        Baseline
            -> Observação da carga de trabalho
            -> Medição
            -> Alteração da configuração
            -> Validação
            -> Nova medição

    Valores padrão não devem ser automaticamente interpretados como valores
    recomendados para ambientes de produção.

    Qualquer alteração de configuração deve ser avaliada e validada de acordo
    com as características do ambiente de destino.
*/


/* ============================================================================
   10 - Arquivos de Banco de Dados e Autogrowth
   ============================================================================ */

SELECT
    DB_NAME(mf.database_id) AS DatabaseName,
    mf.name AS LogicalName,
    mf.type_desc AS FileType,
    mf.physical_name AS PhysicalPath,
    CAST(mf.size * 8.0 / 1024 AS decimal(18,2)) AS SizeMB,
    CASE
        WHEN mf.is_percent_growth = 1
            THEN CAST(mf.growth AS decimal(18,2))
        ELSE
            CAST(mf.growth * 8.0 / 1024 AS decimal(18,2))
    END AS GrowthValue,
    CASE
        WHEN mf.is_percent_growth = 1 THEN 'PERCENT'
        ELSE 'MB'
    END AS GrowthType,
    CASE
        WHEN mf.max_size = -1 THEN 'UNLIMITED'
        ELSE CAST(
            CAST(mf.max_size * 8.0 / 1024 AS decimal(18,2))
            AS varchar(30)
        )
    END AS MaxSizeMB
FROM sys.master_files AS mf
ORDER BY
    mf.database_id,
    mf.type_desc,
    mf.file_id;

/*
Objetivo:
    Coleta informações de configuração dos arquivos dos bancos de dados SQL
    Server para todos os bancos visíveis ao contexto de execução atual.

    A avaliação inclui:
        - Nome do banco de dados
        - Nome lógico do arquivo
        - Tipo de arquivo
        - Localização física do arquivo
        - Tamanho atualmente alocado
        - Valor de autogrowth
        - Tipo de autogrowth
        - Tamanho máximo configurado do arquivo

Interpretação:
    FileType:
        ROWS = Arquivo de dados do banco.
        LOG  = Arquivo de log de transações.

    PhysicalPath:
        Localização do arquivo do banco de dados no sistema operacional.

    SizeMB:
        Tamanho atualmente alocado ao arquivo em MB.

    GrowthValue:
        Quantidade pela qual o arquivo cresce durante um evento de autogrowth.

    GrowthType:
        MB      = Autogrowth de tamanho fixo.
        PERCENT = Autogrowth baseado em percentual.

    MaxSizeMB:
        Tamanho máximo configurado do arquivo.

        UNLIMITED indica que o SQL Server não impõe um tamanho máximo
        configurado além da capacidade de armazenamento e dos limites do
        SQL Server.

Relevância para a avaliação:
    A configuração dos arquivos de banco de dados é uma parte importante das
    avaliações de armazenamento, capacidade, desempenho, recuperação e
    migração.

    As informações coletadas podem ser utilizadas para avaliar:
        - Alocação atual dos bancos de dados
        - Capacidade de armazenamento necessária
        - Localização dos arquivos de dados e log de transações
        - Distribuição dos arquivos
        - Configuração de autogrowth
        - Tamanhos máximos dos arquivos
        - Projeto de armazenamento do ambiente de destino
        - Requisitos de gerenciamento de capacidade

    Caminhos físicos de um ambiente de origem não devem ser reutilizados
    automaticamente em um ambiente de destino.

    O destino pode utilizar uma arquitetura de armazenamento diferente, com
    localizações separadas ou dedicadas para:
        - Arquivos de dados
        - Arquivos de log de transações
        - tempdb
        - Backups

Considerações sobre autogrowth:
    Autogrowth de tamanho fixo oferece comportamento de alocação mais
    previsível do que crescimento baseado em percentual.

    Com autogrowth baseado em percentual, a quantidade alocada durante cada
    evento de crescimento aumenta à medida que o arquivo se torna maior.

    O tamanho apropriado dos arquivos e sua configuração de crescimento
    dependem de:
        - Tamanho atual do banco de dados
        - Taxa esperada de crescimento
        - Características da carga de trabalho
        - Desempenho do armazenamento
        - Capacidade de armazenamento disponível
        - Requisitos de recuperação
        - Requisitos operacionais

    Bancos de dados e tipos de arquivos diferentes podem exigir configurações
    de crescimento diferentes.

Importante:
    Autogrowth deve ser tratado como um mecanismo de segurança, e não como a
    principal estratégia de gerenciamento de capacidade.

    Os arquivos de banco de dados devem, preferencialmente, ser dimensionados
    de forma proativa de acordo com o crescimento esperado, o comportamento da
    carga de trabalho e o armazenamento disponível.

    O crescimento do log de transações exige consideração adicional porque o
    crescimento do arquivo de log não recebe o mesmo benefício de Instant File
    Initialization que o crescimento de arquivos de dados.

Observações:
    Esta seção reporta a alocação configurada dos arquivos e suas
    configurações de autogrowth.

    Ela não reporta o espaço efetivamente utilizado dentro de cada arquivo de
    dados, a capacidade disponível no volume do sistema operacional, o
    histórico de frequência de crescimento ou requisitos futuros de
    capacidade.

    Essas características exigem avaliação adicional quando capacidade de
    armazenamento ou previsão de crescimento fazem parte da análise.

    Esta seção não modifica tamanho, localização, autogrowth ou tamanho máximo
    dos arquivos do banco de dados.
*/


/* ============================================================================
   11 - Serviços do SQL Server
   ============================================================================ */

SELECT
    servicename AS ServiceName,
    startup_type_desc AS StartupType,
    status_desc AS Status,
    service_account AS ServiceAccount,
    last_startup_time AS LastStartupTime,
    instant_file_initialization_enabled AS IFI
FROM sys.dm_server_services
ORDER BY servicename;

/*
Objetivo:
    Coleta a configuração dos serviços SQL Server e seu estado operacional
    atual.

    A avaliação inclui:
        - Nome do serviço
        - Tipo de inicialização
        - Estado atual
        - Conta de serviço
        - Última inicialização
        - Estado de Instant File Initialization

Interpretação:
    StartupType:
        Indica como o serviço do sistema operacional está configurado para
        iniciar.

    Status:
        Indica o estado operacional atual do serviço.

    ServiceAccount:
        Conta do sistema operacional utilizada para executar o serviço
        SQL Server.

    LastStartupTime:
        Reporta o horário mais recente de inicialização do serviço, quando
        disponível.

    IFI:
        Reporta o valor de Instant File Initialization exposto por
        sys.dm_server_services.

        Instant File Initialization é operacionalmente relevante para o
        serviço SQL Server Database Engine.

        Para outros serviços SQL Server, o valor reportado não deve ser
        interpretado como evidência de um problema de configuração.

Relevância para a avaliação:
    A configuração dos serviços SQL Server faz parte do baseline operacional,
    de segurança, disponibilidade e migração.

    Características importantes incluem:
        - Serviços SQL Server necessários
        - Configuração de inicialização
        - Estado atual dos serviços
        - Identidades dos serviços
        - Privilégios das contas de serviço
        - Último horário de inicialização
        - Instant File Initialization para o Database Engine

    Ao comparar ambientes de origem e destino, contas de serviço não devem ser
    copiadas automaticamente de um ambiente para outro.

    As identidades e permissões dos serviços no destino devem ser projetadas
    de acordo com:
        - Requisitos de segurança
        - Arquitetura de domínio
        - Requisitos operacionais
        - Requisitos de alta disponibilidade
        - Requisitos de backup e restauração
        - Requisitos de acesso ao sistema de arquivos e à rede
        - Padrões organizacionais para contas de serviço

Observações:
    LastStartupTime é uma informação operacional dinâmica e não deve ser
    tratada como um valor fixo esperado.

    Nomes de contas de serviço podem expor informações sobre infraestrutura,
    projeto de segurança ou configuração de domínio e, portanto, devem ser
    tratados adequadamente quando os resultados da avaliação forem
    compartilhados.

    Instant File Initialization deve ser interpretado principalmente para o
    serviço SQL Server Database Engine.

    Esta seção apenas reporta a configuração atual dos serviços.

    Ela não inicia, interrompe, reinicia, reconfigura ou modifica nenhum
    serviço SQL Server ou conta de serviço.
*/