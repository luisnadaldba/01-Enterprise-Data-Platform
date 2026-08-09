/*
===============================================================================
 Project      : Atlas Engineering - Enterprise Data Platform
 Script       : 20260809-Validate-SQL-Server-Environment.sql
 Category     : Diagnostics / Environment Validation
 Database     : SQL Server
 Created      : 2026-08-09

 Purpose
 -------
 Collect and validate the main SQL Server instance, operating environment,
 security, database, storage, and configuration information.

 This script can be used for:
   - Initial environment validation
   - Environment baseline collection
   - Pre-migration assessment
   - Post-migration validation
   - Troubleshooting
   - Environment comparison

 Notes
 -----
 This script is read-only.
 It does not change SQL Server configuration or database objects.

===============================================================================
*/

/* ============================================================================
   01 - SQL Server Instance Information
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
Purpose:
    Identifies the SQL Server instance and installed version.

Migration relevance:
    Used to confirm source and destination environments, SQL Server edition,
    product version, service name, and whether the instance is default or named.

Expected environment:
    ServerName     : NADAL-0001
    ServiceName    : MSSQLSERVER
    MachineName    : NADAL-0001
    InstanceName   : NULL (default instance)
    Edition        : Enterprise Developer Edition (64-bit)
    ProductVersion : 17.0.1000.7
    ProductLevel   : RTM
*/

/* ============================================================================
   02 - Authentication and Administrative Access
   ============================================================================ */

SELECT
    ORIGINAL_LOGIN() AS OriginalLogin,
    SUSER_SNAME() AS CurrentLogin,
    SYSTEM_USER AS SystemUser,
    IS_SRVROLEMEMBER('sysadmin') AS IsSysAdmin,
    SERVERPROPERTY('IsIntegratedSecurityOnly') AS WindowsAuthenticationOnly;

/*
Purpose:
    Identifies the login used to establish the SQL Server session, the current
    security context, sysadmin membership, and the authentication mode configured
    for the SQL Server instance.

Interpretation:
    IsSysAdmin:
        1 = Current login is a member of the sysadmin server role.
        0 = Current login is not a member of the sysadmin server role.
        NULL = Login or server role information could not be resolved.

    WindowsAuthenticationOnly:
        1 = Windows Authentication mode only.
        0 = Mixed Mode authentication (Windows and SQL Server Authentication).

Migration relevance:
    Helps identify administrative access requirements before a migration and
    validates that the destination environment has appropriate administrative
    access after migration.

    Administrative logins should be reviewed carefully. A SQL Server instance
    must not depend exclusively on the Windows account of a single employee,
    because account removal or deactivation can cause loss of administrative
    access.

Expected environment:
    Windows login:
        OriginalLogin              : NADAL-0001\luisn
        CurrentLogin               : NADAL-0001\luisn
        SystemUser                 : NADAL-0001\luisn
        IsSysAdmin                 : 1
        WindowsAuthenticationOnly  : 0

    SQL login (sa):
        OriginalLogin              : sa
        CurrentLogin               : sa
        SystemUser                 : sa
        IsSysAdmin                 : 1
        WindowsAuthenticationOnly  : 0
*/


/* ============================================================================
   03 - Collation
   ============================================================================ */

-- Validate server and system database collations
SELECT
    SERVERPROPERTY('Collation') AS ServerCollation,
    DATABASEPROPERTYEX('master', 'Collation') AS MasterCollation,
    DATABASEPROPERTYEX('tempdb', 'Collation') AS TempDBCollation;


-- Retrieve collation properties
SELECT
    SERVERPROPERTY('Collation') AS CollationName,
    COLLATIONPROPERTY(
        CONVERT(varchar(128), SERVERPROPERTY('Collation')),
        'CodePage'
    ) AS CodePage,
    COLLATIONPROPERTY(
        CONVERT(varchar(128), SERVERPROPERTY('Collation')),
        'ComparisonStyle'
    ) AS ComparisonStyle;


-- Validate collation comparison behavior
SELECT
    CASE
        WHEN 'Atlas' = 'ATLAS' THEN 'Equal'
        ELSE 'Different'
    END AS CaseComparison,

    CASE
        WHEN 'cafe' = 'café' THEN 'Equal'
        ELSE 'Different'
    END AS AccentComparison;

/*
Purpose:
    Identifies the SQL Server collation and validates its comparison behavior.

    The validation checks:
        - Server collation
        - master database collation
        - tempdb database collation
        - Code page
        - Comparison style
        - Case sensitivity behavior
        - Accent sensitivity behavior

Interpretation:
    Latin1_General_CI_AS:
        CI = Case Insensitive
        AS = Accent Sensitive

    CodePage 1252:
        Windows-1252 code page used for non-Unicode varchar/char data.

    Case comparison:
        'Atlas' = 'ATLAS' should return Equal because the configured
        collation is case insensitive.

    Accent comparison:
        'cafe' = 'café' should return Different because the configured
        collation is accent sensitive.

Migration relevance:
    Collation differences between source and destination environments can
    change string comparison, sorting, joins, temporary table behavior,
    and application results.

    Special attention should be given to differences between the SQL Server
    instance collation and tempdb collation because temporary objects can
    participate in comparisons with user database objects.

Expected environment:
    ServerCollation : Latin1_General_CI_AS
    MasterCollation : Latin1_General_CI_AS
    TempDBCollation : Latin1_General_CI_AS
    CodePage        : 1252

    CaseComparison   : Equal
    AccentComparison : Different
*/


/* ============================================================================
   04 - SQL Server Memory and Parallelism
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
Purpose:
    Collects the main SQL Server memory and parallelism configuration values.

    Both the configured value and the value currently in use are returned.

Interpretation:
    ConfiguredValue:
        Value stored in the SQL Server configuration.

    ValueInUse:
        Value currently being used by the SQL Server instance.

    IsDynamic:
        1 = The configuration can be changed without restarting SQL Server.
        0 = A restart may be required for the change to take effect.

    IsAdvanced:
        Identifies options classified as advanced SQL Server configuration
        settings.

    min server memory (MB):
        Defines the lower memory target that SQL Server may attempt to retain
        after memory has been acquired.

        A configured value of 0 does not mean that SQL Server uses zero memory.

    max server memory (MB):
        Defines the upper memory limit available to the SQL Server buffer pool
        and related memory consumers governed by this configuration.

    max degree of parallelism:
        Limits the number of processors that can participate in the execution
        of a single parallel query plan.

Migration relevance:
    Memory and parallelism settings should be collected before a migration,
    but they should not automatically be copied to the destination server.

    The destination environment may have different:
        - Physical memory
        - CPU topology
        - Number of logical processors
        - NUMA architecture
        - Workload characteristics

    The source values should therefore be treated as baseline information
    used to evaluate the appropriate destination configuration.

Expected environment:
    max degree of parallelism:
        ConfiguredValue : 4
        ValueInUse      : 4

    max server memory (MB):
        ConfiguredValue : 10752
        ValueInUse      : 10752

    min server memory (MB):
        ConfiguredValue : 0

Notes:
    This development environment shares hardware resources with Windows and
    other applications.

    The max server memory value was intentionally limited instead of leaving
    SQL Server effectively unrestricted.

    MAXDOP was configured as 4 for the current laboratory environment.

    These values represent the initial environment baseline and are not
    universal production recommendations.
*/


/* ============================================================================
   05 - Operating System and CPU Information
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
Purpose:
    Collects hardware and SQL Server operating environment information visible
    to the Database Engine.

    The result provides context for configuration decisions related to:
        - Memory
        - Parallelism
        - NUMA
        - Worker threads
        - CPU topology

Interpretation:
    SqlMemoryModel:
        Describes the memory model currently used by SQL Server.

    SoftNumaConfiguration:
        Indicates whether SQL Server Soft-NUMA configuration is enabled.

    SocketCount:
        Number of processor sockets visible to SQL Server.

    CoresPerSocket:
        Number of physical processor cores per socket.

    LogicalCpuCount:
        Number of logical CPUs visible to SQL Server.

    NumaNodeCount:
        Number of NUMA nodes visible to SQL Server.

    PhysicalMemoryMB:
        Approximate amount of physical memory visible to SQL Server.

    SchedulerCount:
        Number of SQL Server schedulers.

    MaxWorkersCount:
        Maximum number of worker threads configured internally by SQL Server.

    SqlServerStartTime:
        Date and time when the SQL Server Database Engine was last started.

    VirtualMachineType:
        Indicates how SQL Server identifies the virtualization environment.

Migration relevance:
    Hardware topology should always be collected before migration because
    configuration values from the source server may not be appropriate for
    the destination server.

    Differences in:
        - CPU count
        - Core count
        - NUMA topology
        - Memory
        - Virtualization
        - Scheduler count

    can affect decisions involving MAXDOP, memory allocation, workload
    concurrency, and performance expectations.

    A destination server should therefore be evaluated according to its own
    hardware characteristics instead of inheriting source settings blindly.

Expected environment:
    SqlMemoryModel       : CONVENTIONAL
    SoftNumaConfiguration: ON
    SocketCount          : 1
    CoresPerSocket       : 10
    LogicalCpuCount      : 20
    NumaNodeCount        : 2
    PhysicalMemoryMB     : approximately 16068 MB
    SchedulerCount       : 20
    MaxWorkersCount      : 768
    VirtualMachineType   : HYPERVISOR

Notes:
    SqlServerStartTime is dynamic and should not be treated as a fixed expected
    value.

    VirtualMachineType should be recorded as reported by SQL Server and should
    not, by itself, be interpreted as proof that the operating system is
    running inside a conventional virtual machine.
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
Purpose:
    Validates whether Instant File Initialization (IFI) is enabled for the
    SQL Server Database Engine service.

Interpretation:
    InstantFileInitializationEnabled:

        Y = Instant File Initialization is enabled.
        N = Instant File Initialization is disabled.

    IFI allows SQL Server to allocate space for data files without first
    zero-initializing the entire newly allocated region.

    This can significantly reduce the time required for:
        - Database creation
        - Data file growth
        - Database restore operations

Important:
    Instant File Initialization applies to SQL Server data files.

    Transaction log files still require initialization and do not receive the
    same performance benefit from IFI.

Migration relevance:
    IFI should be validated on the destination server before migration or
    production cutover.

    A destination server without IFI may experience longer:
        - Database creation times
        - Data file autogrowth events
        - Restore operations

    This may affect migration duration and recovery expectations.

Expected environment:
    ServiceName                         : SQL Server (MSSQLSERVER)
    InstantFileInitializationEnabled   : Y

Troubleshooting history:
    During the initial environment validation, IFI was incorrectly queried
    from sys.dm_os_sys_info using the column:

        instant_file_initialization_enabled

    SQL Server returned:

        Invalid column name 'instant_file_initialization_enabled'.

    The metadata of sys.dm_os_sys_info was then inspected and confirmed that
    the column does not exist in that DMV.

    The correct source for this information in the current environment is:

        sys.dm_server_services

    This validation script therefore queries IFI from sys.dm_server_services.
*/


/* ============================================================================
   07 - TempDB Configuration
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
ORDER BY mf.type_desc, mf.file_id;

/*
Purpose:
    Collects the physical file configuration of tempdb.

    The validation includes:
        - Number of files
        - Logical file names
        - File types
        - Physical locations
        - Initial/current sizes
        - Autogrowth values
        - Autogrowth types
        - Maximum file sizes

Interpretation:
    FileType:
        ROWS = tempdb data file.
        LOG  = tempdb transaction log file.

    SizeMB:
        Current allocated size of the file in MB.

    GrowthValue:
        Amount by which the file grows during an autogrowth event.

    GrowthType:
        MB      = Fixed-size autogrowth.
        PERCENT = Percentage-based autogrowth.

    MaxSizeMB:
        Maximum configured file size.
        UNLIMITED indicates that SQL Server does not impose a configured
        maximum size other than storage and SQL Server limits.

Migration relevance:
    tempdb configuration is instance-specific and must be reviewed when
    preparing a destination SQL Server.

    Important characteristics include:
        - Number of data files
        - Equal sizing of data files
        - Consistent autogrowth settings
        - Storage location
        - Available disk capacity
        - Workload characteristics

    The tempdb configuration from the source server should be collected for
    comparison, but it should not automatically be copied to the destination.

    The destination server may have different CPU, storage, memory, and
    workload characteristics.

Expected environment:
    Data files:
        Count       : 8
        Size        : 128 MB each
        GrowthValue : 128 MB
        GrowthType  : MB

    Log file:
        Count       : 1
        Size        : 256 MB
        GrowthValue : 128 MB
        GrowthType  : MB

Notes:
    The eight tempdb data files in the current laboratory environment were
    created with equal initial sizes and equal fixed-size autogrowth settings.

    Equal file sizing is important because SQL Server distributes tempdb
    allocations according to available free space.

    Autogrowth should be treated as a safety mechanism rather than as the
    primary capacity-management strategy.

    tempdb is recreated whenever the SQL Server Database Engine starts.
*/


/* ============================================================================
   08 - System Databases
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
Purpose:
    Collects the main configuration properties of the SQL Server system
    databases.

    The system databases evaluated are:
        - master
        - tempdb
        - model
        - msdb

Interpretation:
    State:
        Indicates whether the database is ONLINE or in another operational
        state.

    RecoveryModel:
        Identifies the configured recovery model.

    CompatibilityLevel:
        Determines database compatibility behavior associated with a SQL
        Server version.

    Collation:
        Defines the default string comparison and sorting rules for the
        database.

    PageVerify:
        Identifies the mechanism used by SQL Server to detect damaged
        database pages.

        CHECKSUM is the expected configuration in the current environment.

    AutoClose:
        When enabled, SQL Server closes the database after the last user
        connection exits.

    AutoShrink:
        When enabled, SQL Server periodically attempts to shrink database
        files automatically.

    ReadCommittedSnapshot:
        Indicates whether READ COMMITTED uses row versioning for the database.

Migration relevance:
    System database configuration should be collected during assessment to
    identify differences between source and destination SQL Server instances.

    Particular attention should be given to:
        - Database state
        - Compatibility level
        - Collation
        - Recovery model
        - Page verification
        - AUTO_CLOSE
        - AUTO_SHRINK

    System databases should not be assumed to have identical configuration
    simply because the SQL Server versions are similar.

Expected environment:
    System databases:
        master
        tempdb
        model
        msdb

    State:
        ONLINE

    CompatibilityLevel:
        170

    Collation:
        Latin1_General_CI_AS

    PageVerify:
        CHECKSUM

    AutoClose:
        0

    AutoShrink:
        0

Notes:
    Recovery models differ according to the purpose of each system database
    and should be interpreted individually rather than expected to have one
    common value.

    AUTO_CLOSE and AUTO_SHRINK are disabled in the current environment.

    User databases are intentionally not included in this section.
    They can be assessed separately when the Atlas Engineering transactional
    databases are created.
*/


/* ============================================================================
   09 - SQL Server Advanced Configuration
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
Purpose:
    Collects selected SQL Server instance-level configuration values that are
    relevant to administration, performance, troubleshooting, and migration
    assessment.

Interpretation:
    ConfiguredValue:
        Value stored in the SQL Server configuration.

    ValueInUse:
        Value currently active in the SQL Server instance.

    IsDynamic:
        Indicates whether the configuration can take effect dynamically.

    IsAdvanced:
        Indicates whether SQL Server classifies the option as an advanced
        configuration setting.

    backup compression default:
        Defines whether SQL Server uses backup compression by default when a
        backup command does not explicitly specify compression behavior.

    blocked process threshold (s):
        Defines the blocking duration, in seconds, after which SQL Server can
        generate blocked process reports when the appropriate monitoring
        mechanism is configured.

        0 means the threshold is disabled.

    cost threshold for parallelism:
        Defines the estimated query cost threshold used when SQL Server
        considers parallel execution plans.

    max degree of parallelism:
        Limits the number of processors that can participate in the execution
        of a single parallel query plan.

    max server memory (MB):
        Defines the configured upper memory limit governed by this SQL Server
        setting.

    optimize for ad hoc workloads:
        Controls how SQL Server initially stores execution plans for ad hoc
        queries in the plan cache.

    remote admin connections:
        Controls whether the Dedicated Administrator Connection (DAC) can be
        established remotely.

Migration relevance:
    Instance-level configuration should be collected before migration and
    compared with the destination environment.

    Differences may affect:
        - Performance
        - Memory consumption
        - Parallelism
        - Backup behavior
        - Plan cache usage
        - Troubleshooting capabilities
        - Administrative connectivity

    Source configuration values should not automatically be copied to the
    destination server.

    Each setting must be evaluated according to the destination hardware,
    workload, operational requirements, and security requirements.

Expected environment:
    backup compression default         : 0
    blocked process threshold (s)      : 0
    cost threshold for parallelism     : 5
    max degree of parallelism          : 4
    max server memory (MB)             : 10752
    optimize for ad hoc workloads      : 0
    remote admin connections           : 0

Notes:
    These values represent the initial environment baseline.

    They must not be interpreted as universal production recommendations.

    In particular, the default cost threshold for parallelism value of 5
    should be treated as an observed configuration, not as a recommended
    value for every workload.

    Performance-related configuration changes should preferably follow:

        Baseline
            -> Workload observation
            -> Measurement
            -> Configuration change
            -> Validation
            -> New measurement

    The diagnostic script is read-only and intentionally does not modify any
    of these settings.
*/


/* ============================================================================
   10 - Database Files and Autogrowth
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
Purpose:
    Collects SQL Server database file configuration information.

    The validation includes:
        - Database name
        - Logical file name
        - File type
        - Physical file location
        - Current allocated size
        - Autogrowth value
        - Autogrowth type
        - Maximum configured size

Interpretation:
    FileType:
        ROWS = Database data file.
        LOG  = Transaction log file.

    PhysicalPath:
        Operating system location of the database file.

    SizeMB:
        Current allocated size of the file.

    GrowthValue:
        Amount used during an autogrowth event.

    GrowthType:
        MB      = Fixed-size autogrowth.
        PERCENT = Percentage-based autogrowth.

    MaxSizeMB:
        Maximum configured size of the file.
        UNLIMITED means SQL Server does not impose a configured maximum other
        than storage capacity and SQL Server limits.

Migration relevance:
    Database file configuration is critical during migration assessment.

    The information can be used to evaluate:
        - Required storage capacity
        - Data and log file locations
        - File distribution
        - Current database sizes
        - Autogrowth configuration
        - Maximum file sizes
        - Destination storage design

    Physical paths from the source server should not automatically be reused
    on the destination server.

    The destination may use a different storage architecture with dedicated
    locations for:
        - Data files
        - Transaction log files
        - tempdb
        - Backups

Autogrowth considerations:
    Fixed-size autogrowth in MB is generally preferred over percentage-based
    growth because it provides more predictable allocation behavior.

    Percentage-based growth causes the amount allocated during each growth
    event to increase as the database file becomes larger.

    The appropriate fixed growth value depends on:
        - Current database size
        - Growth rate
        - Workload
        - Storage performance
        - Available disk capacity
        - Operational requirements

    Larger databases with significant activity may use larger fixed growth
    increments, such as 1024 MB, when appropriate for the environment.

    Small system databases should not automatically receive the same growth
    increment used by large transactional databases.

Important:
    Autogrowth should be treated as a safety mechanism, not as the primary
    capacity-management strategy.

    Database files should preferably be sized proactively according to
    expected growth and available storage.

    Transaction log growth requires additional consideration because log
    growth does not receive the same Instant File Initialization benefit as
    data file growth.

Expected environment:
    Current system database files are located under the SQL Server installation
    data directory.

    tempdb:
        Data files:
            Size       : 128 MB each
            Growth     : 128 MB
            GrowthType : MB

        Log file:
            Size       : 256 MB
            Growth     : 128 MB
            GrowthType : MB

    master and msdb:
        Some files currently use percentage-based autogrowth.

    model:
        Files currently use fixed-size autogrowth.

Notes:
    Percentage-based growth found in the initial environment is recorded as
    baseline information.

    The diagnostic script intentionally does not change these settings.

    Production-like databases created by the Atlas Engineering project will
    use explicitly defined file sizes and fixed-size autogrowth according to
    their expected workload and storage requirements.
*/


/* ============================================================================
   11 - SQL Server Services
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
Purpose:
    Collects SQL Server service configuration and current operational status.

    The validation includes:
        - Service name
        - Startup type
        - Current status
        - Service account
        - Last startup time
        - Instant File Initialization status

Interpretation:
    StartupType:
        Indicates how the Windows service is configured to start.

    Status:
        Indicates the current operational state of the service.

    ServiceAccount:
        Windows account used to run the SQL Server service.

    LastStartupTime:
        Reports the last startup time when available for the service.

    IFI:
        Indicates whether Instant File Initialization is enabled for the
        service.

        Y = Enabled
        N = Disabled or not applicable to the service.

Migration relevance:
    SQL Server service configuration should be reviewed before and after a
    migration.

    Important considerations include:
        - Required SQL Server services
        - Startup configuration
        - Service status
        - Service accounts
        - Service account permissions
        - Instant File Initialization

    Service accounts should not automatically be copied from the source
    environment.

    Destination service identities and permissions should follow the security
    and operational requirements of the destination environment.

Expected environment:
    SQL Server (MSSQLSERVER):
        StartupType    : Automatic
        Status         : Running
        ServiceAccount : NT Service\MSSQLSERVER
        IFI            : Y

    SQL Server Agent (MSSQLSERVER):
        StartupType    : Automatic
        Status         : Running
        ServiceAccount : NT Service\SQLSERVERAGENT

Notes:
    Instant File Initialization is relevant to the SQL Server Database Engine.

    An IFI value of N for SQL Server Agent does not indicate a configuration
    problem.

    LastStartupTime is operational information and should not be treated as a
    fixed expected value.

    Service accounts used in this development environment are local virtual
    service accounts.

    Production environments may use different service identities according to
    security, domain, high availability, and infrastructure requirements.
*/