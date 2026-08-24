/*
===============================================================================
 Project      : Atlas Engineering - Enterprise Data Platform
 Script       : Assess-SQL-Server-Environment.sql
 Version      : 1.0.0
 Category     : Diagnostics / Environment Assessment
 Scope        : SQL Server Instance

 Purpose
 -------
 Collects the main SQL Server instance, operating environment, security,
 database, storage, and configuration information required for technical
 assessment and environment comparison.

 This script can be used for:
   - Initial environment assessment
   - Environment baseline collection
   - Pre-migration assessment
   - Post-migration comparison
   - Troubleshooting
   - Environment comparison

 Behavior
 --------
 This script is read-only.

 It does not:
   - Change SQL Server configuration
   - Modify database objects
   - Modify application or user data

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

Interpretation:
    ServerName:
        SQL Server name registered for the current instance.

    ServiceName:
        SQL Server service name associated with the current instance.

    MachineName:
        Operating system computer name reported by SQL Server.

    InstanceName:
        SQL Server instance name.

        NULL normally indicates a default instance.

    Edition:
        Installed SQL Server edition.

    ProductVersion:
        Installed SQL Server product version.

    ProductLevel:
        Product servicing level reported by SQL Server.

Assessment relevance:
    This information establishes the identity and software baseline of the
    SQL Server instance.

    It is useful when comparing source and destination environments and when
    evaluating differences involving:
        - SQL Server edition
        - Product version
        - Instance naming
        - Service naming
        - Host identity

    Edition and version differences can affect feature availability,
    compatibility, licensing, and migration planning.
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
    OriginalLogin:
        Login originally used to establish the SQL Server session.

        This value remains associated with the original connection identity
        even when the execution context changes.

    CurrentLogin:
        Login associated with the current SQL Server security context.

    SystemUser:
        Current execution-context login name reported by SQL Server.

    IsSysAdmin:
        1 = Current login is a member of the sysadmin fixed server role.
        0 = Current login is not a member of the sysadmin fixed server role.
        NULL = Login or server role information could not be resolved.

    WindowsAuthenticationOnly:
        1 = Windows Authentication mode only.
        0 = Mixed Mode authentication
            (Windows Authentication and SQL Server Authentication).

Assessment relevance:
    Authentication mode and administrative access are important components of
    the SQL Server security baseline.

    This information is useful for evaluating:
        - Authentication configuration
        - Current administrative access
        - Execution context
        - Migration access requirements
        - Post-migration administrative validation

    Administrative access should not depend exclusively on the personal
    Windows account of a single individual.

    Environment design should provide an appropriate administrative access
    strategy according to organizational security, operational, recovery,
    and auditing requirements.

Notes:
    A value of 1 for IsSysAdmin confirms sysadmin membership for the current
    login. It does not evaluate whether that level of privilege is appropriate
    for the account.

    This section reports the current authentication and execution context.
    It does not enumerate all server principals, server-role memberships,
    permissions, or privileged accounts configured on the instance.
*/


/* ============================================================================
   03 - Collation
   ============================================================================ */

-- Collect SQL Server instance and system database collations
SELECT
    SERVERPROPERTY('Collation') AS ServerCollation,
    DATABASEPROPERTYEX('master', 'Collation') AS MasterCollation,
    DATABASEPROPERTYEX('tempdb', 'Collation') AS TempDBCollation,
    DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS CurrentDatabaseCollation;


-- Retrieve SQL Server instance collation properties
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
   Current Database Comparison Behavior
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
Purpose:
    Collects the SQL Server instance collation, selected system database
    collations, current database collation, and collation properties.

    It also evaluates case and accent comparison behavior using the collation
    of the current database.

Interpretation:
    ServerCollation:
        Default collation configured for the SQL Server instance.

    MasterCollation:
        Collation configured for the master system database.

    TempDBCollation:
        Collation configured for tempdb.

    CurrentDatabaseCollation:
        Collation configured for the database in which this script is
        currently executing.

    CodePage:
        Code page associated with the SQL Server instance collation for
        non-Unicode char and varchar data.

    ComparisonStyle:
        Numeric representation of comparison characteristics associated with
        the SQL Server instance collation.

    CaseComparison:
        Reports whether the current database collation treats 'Atlas' and
        'ATLAS' as equal.

    AccentComparison:
        Reports whether the current database collation treats 'cafe' and
        'café' as equal.

Assessment relevance:
    Collation differences can affect:
        - String comparison
        - Sorting
        - Joins
        - Temporary objects
        - Application behavior
        - Data integration
        - Migration compatibility

    Particular attention should be given to differences between:
        - SQL Server instance collation
        - tempdb collation
        - User database collations

    Temporary objects created in tempdb may participate in comparisons with
    objects from user databases, potentially producing collation conflicts
    when incompatible collations are involved.

Notes:
    The case and accent comparison tests intentionally use DATABASE_DEFAULT.

    Therefore, those tests describe the behavior of the current database
    collation and must not be interpreted as direct behavioral tests of the
    SQL Server instance collation.

    The SQL Server instance collation is collected separately through
    SERVERPROPERTY('Collation').
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
        Value currently active in the SQL Server instance.

    IsDynamic:
        1 = The configuration can take effect without restarting SQL Server.
        0 = A restart may be required for the change to take effect.

    IsAdvanced:
        Indicates whether SQL Server classifies the option as an advanced
        configuration setting.

    min server memory (MB):
        Defines the lower memory target that SQL Server may attempt to retain
        after memory has been acquired.

        A configured value of 0 does not mean that SQL Server uses zero memory.

    max server memory (MB):
        Defines the configured upper memory limit governed by this SQL Server
        setting.

        This value should be evaluated together with total physical memory,
        operating system requirements, other services, and workload
        characteristics.

    max degree of parallelism:
        Limits the number of processors that can participate in the execution
        of a single parallel query plan.

Assessment relevance:
    Memory and parallelism settings are important components of the SQL Server
    performance baseline.

    These values should be evaluated together with:
        - Physical memory
        - CPU topology
        - Number of logical processors
        - NUMA architecture
        - Workload characteristics
        - Operating system requirements
        - Other services running on the host

    When comparing source and destination environments, configuration values
    should not automatically be copied from one server to another.

    The destination environment may require different settings because of
    differences in hardware, workload, concurrency, and operational
    requirements.

Notes:
    This section collects configuration values only.

    It does not determine whether the current values are optimal or
    recommended for the workload.

    Performance-related configuration changes should be based on an
    appropriate baseline, workload observation, measurement, and subsequent
    validation.
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

    The result provides context for configuration and performance analysis
    involving:
        - Memory
        - CPU topology
        - Parallelism
        - NUMA
        - Schedulers
        - Worker threads
        - Virtualization

Interpretation:
    SqlMemoryModel:
        Describes the memory model currently used by SQL Server.

    SoftNumaConfiguration:
        Describes the SQL Server Soft-NUMA configuration reported by the
        Database Engine.

        The reported value should be interpreted together with processor
        topology and SQL Server version rather than treated independently.

    SocketCount:
        Number of processor sockets visible to SQL Server.

    CoresPerSocket:
        Number of processor cores per socket visible to SQL Server.

    LogicalCpuCount:
        Number of logical processors visible to SQL Server.

    NumaNodeCount:
        Number of NUMA nodes visible to SQL Server.

        This value reflects the topology exposed to the Database Engine and
        should be evaluated together with hardware and Soft-NUMA information.

    PhysicalMemoryMB:
        Approximate amount of physical memory visible to SQL Server.

    SchedulerCount:
        Number of SQL Server schedulers reported by the Database Engine.

        Scheduler count should be interpreted together with logical processor
        visibility and SQL Server scheduling behavior.

    MaxWorkersCount:
        Maximum number of worker threads available according to the SQL Server
        worker-thread configuration.

    SqlServerStartTime:
        Date and time when the SQL Server Database Engine was last started.

    VirtualMachineType:
        Describes how SQL Server identifies the virtualization environment.

Assessment relevance:
    Hardware and operating environment characteristics are fundamental to
    SQL Server configuration and performance assessment.

    This information is useful when evaluating:
        - Memory configuration
        - MAXDOP
        - CPU capacity
        - NUMA topology
        - Scheduler availability
        - Worker-thread capacity
        - Virtualization differences
        - Source and destination server sizing

    Configuration values from one SQL Server environment should not
    automatically be transferred to another environment.

    Differences in processor topology, memory, virtualization, NUMA layout,
    workload concurrency, and operating conditions can require different
    configuration decisions.

Notes:
    SqlServerStartTime is dynamic operational information and should not be
    treated as a fixed baseline value.

    VirtualMachineType reports the virtualization classification visible to
    SQL Server. It should not, by itself, be treated as sufficient evidence
    to describe the complete underlying infrastructure architecture.

    Values returned by sys.dm_os_sys_info describe the resources and topology
    visible to SQL Server and may differ from the complete physical hardware
    configuration of the host.
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
    Collects the Instant File Initialization (IFI) status reported for the
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

Assessment relevance:
    IFI is an important part of the SQL Server storage and recovery baseline.

    It should be reviewed when assessing:
        - Database creation behavior
        - Data file autogrowth
        - Restore duration
        - Migration readiness
        - Recovery expectations
        - Destination server configuration

    Differences in IFI configuration between source and destination
    environments can affect migration and recovery duration.

Notes:
    Instant File Initialization status is collected from
    sys.dm_server_services.

    This section reports the current IFI state only.

    It does not change Windows security policy, SQL Server service-account
    privileges, or SQL Server configuration.
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
ORDER BY
    mf.type_desc,
    mf.file_id;

/*
Purpose:
    Collects the physical file configuration of tempdb.

    The assessment includes:
        - Number of files
        - Logical file names
        - File types
        - Physical locations
        - Current allocated sizes
        - Autogrowth values
        - Autogrowth types
        - Maximum configured file sizes

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
        maximum size other than storage capacity and SQL Server limits.

Assessment relevance:
    tempdb configuration is instance-specific and should be reviewed as part
    of SQL Server performance, storage, migration, and capacity assessment.

    Important characteristics include:
        - Number of data files
        - Relative sizing of data files
        - Autogrowth configuration
        - Storage location
        - Available storage capacity
        - CPU topology
        - Workload characteristics

    When comparing environments, tempdb configuration from a source server
    should not automatically be copied to a destination server.

    The destination may have different processor topology, storage
    architecture, memory, workload, and concurrency characteristics.

Notes:
    tempdb data files should be evaluated for balanced sizing and growth
    configuration.

    Fixed-size autogrowth provides more predictable growth behavior than
    percentage-based growth.

    Autogrowth should be treated as a safety mechanism rather than as the
    primary capacity-management strategy.

    tempdb should be sized proactively according to workload and available
    storage whenever practical.

    tempdb is recreated whenever the SQL Server Database Engine starts.

    This section collects configuration only and does not determine the ideal
    number or size of tempdb files for the current workload.
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
        Indicates the current operational state of the database.

    RecoveryModel:
        Identifies the configured recovery model.

        Recovery model should be interpreted according to the purpose and
        behavior of each system database.

    CompatibilityLevel:
        Determines database compatibility behavior associated with a SQL
        Server version.

    Collation:
        Defines the default string comparison and sorting rules for the
        database.

    PageVerify:
        Identifies the mechanism used by SQL Server to detect damaged database
        pages.

    AutoClose:
        Indicates whether SQL Server automatically closes the database after
        the last user connection exits.

    AutoShrink:
        Indicates whether SQL Server periodically attempts to shrink database
        files automatically.

    ReadCommittedSnapshot:
        Indicates whether READ COMMITTED uses row versioning for the database.

Assessment relevance:
    System database configuration is part of the SQL Server instance baseline
    and should be reviewed when assessing:
        - Instance health
        - Configuration consistency
        - Migration readiness
        - Source and destination differences
        - Recovery behavior
        - Collation compatibility
        - Database maintenance settings

    Particular attention should be given to:
        - Database state
        - Compatibility level
        - Collation
        - Recovery model
        - Page verification
        - AUTO_CLOSE
        - AUTO_SHRINK

    System databases should not be assumed to have identical configuration
    simply because they belong to the same SQL Server instance or because two
    environments use similar SQL Server versions.

Notes:
    Recovery models and other properties may legitimately differ between
    system databases according to their purpose.

    AUTO_CLOSE and AUTO_SHRINK should be reviewed rather than assumed to have
    a universal expected value.

    User databases are intentionally excluded from this section.

    They should be assessed separately because their configuration depends on
    application, recovery, performance, availability, and workload
    requirements.

    This section collects configuration only and does not modify any system
    database setting.
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
    Collects selected SQL Server instance-level configuration values relevant
    to administration, performance, troubleshooting, and environment
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

        A value of 0 means the threshold is disabled.

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

Assessment relevance:
    Instance-level configuration is an important part of the SQL Server
    operational and performance baseline.

    These settings should be reviewed when evaluating:
        - Performance behavior
        - Memory usage
        - Parallelism
        - Backup behavior
        - Plan cache usage
        - Blocking diagnostics
        - Troubleshooting capabilities
        - Administrative connectivity
        - Migration readiness
        - Source and destination differences

    Configuration values from a source environment should not automatically be
    copied to a destination environment.

    Each setting should be evaluated according to:
        - Hardware characteristics
        - Workload behavior
        - Concurrency
        - Operational requirements
        - Recovery requirements
        - Security requirements

Notes:
    This section collects configuration values only.

    It does not determine whether the current settings are optimal for the
    workload.

    Performance-related configuration changes should preferably follow a
    controlled process such as:

        Baseline
            -> Workload observation
            -> Measurement
            -> Configuration change
            -> Validation
            -> New measurement

    Default values should not automatically be interpreted as recommended
    production values.

    Any configuration change should be evaluated and validated according to
    the characteristics of the target environment.
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
    Collects SQL Server database file configuration information for all
    databases visible to the current execution context.

    The assessment includes:
        - Database name
        - Logical file name
        - File type
        - Physical file location
        - Current allocated size
        - Autogrowth value
        - Autogrowth type
        - Maximum configured file size

Interpretation:
    FileType:
        ROWS = Database data file.
        LOG  = Transaction log file.

    PhysicalPath:
        Operating system location of the database file.

    SizeMB:
        Current allocated size of the file in MB.

    GrowthValue:
        Amount by which the file grows during an autogrowth event.

    GrowthType:
        MB      = Fixed-size autogrowth.
        PERCENT = Percentage-based autogrowth.

    MaxSizeMB:
        Maximum configured size of the file.

        UNLIMITED indicates that SQL Server does not impose a configured
        maximum size other than storage capacity and SQL Server limits.

Assessment relevance:
    Database file configuration is an important part of storage, capacity,
    performance, recovery, and migration assessment.

    The collected information can be used to evaluate:
        - Current database allocation
        - Required storage capacity
        - Data and transaction log file locations
        - File distribution
        - Autogrowth configuration
        - Maximum file sizes
        - Destination storage design
        - Capacity-management requirements

    Physical paths from a source environment should not automatically be
    reused in a destination environment.

    The destination may use a different storage architecture with separate or
    dedicated locations for:
        - Data files
        - Transaction log files
        - tempdb
        - Backups

Autogrowth considerations:
    Fixed-size autogrowth provides more predictable allocation behavior than
    percentage-based growth.

    With percentage-based autogrowth, the amount allocated during each growth
    event increases as the file becomes larger.

    Appropriate file size and growth configuration depend on:
        - Current database size
        - Expected growth rate
        - Workload characteristics
        - Storage performance
        - Available storage capacity
        - Recovery requirements
        - Operational requirements

    Different databases and file types may require different growth
    configurations.

Important:
    Autogrowth should be treated as a safety mechanism rather than as the
    primary capacity-management strategy.

    Database files should preferably be sized proactively according to
    expected growth, workload behavior, and available storage.

    Transaction log growth requires additional consideration because log file
    growth does not receive the same Instant File Initialization benefit as
    data file growth.

Notes:
    This section reports configured file allocation and autogrowth settings.

    It does not report actual used space inside each data file, available
    operating system volume capacity, historical growth frequency, or future
    capacity requirements.

    Those characteristics require additional assessment when storage capacity
    or growth forecasting is part of the analysis.

    This section does not modify database file size, location, autogrowth, or
    maximum-size configuration.
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

    The assessment includes:
        - Service name
        - Startup type
        - Current status
        - Service account
        - Last startup time
        - Instant File Initialization status

Interpretation:
    StartupType:
        Indicates how the operating system service is configured to start.

    Status:
        Indicates the current operational state of the service.

    ServiceAccount:
        Operating system account used to run the SQL Server service.

    LastStartupTime:
        Reports the most recent service startup time when available.

    IFI:
        Reports the Instant File Initialization value exposed by
        sys.dm_server_services.

        Instant File Initialization is operationally relevant to the SQL
        Server Database Engine service.

        For other SQL Server services, the reported value should not be
        interpreted as evidence of a configuration problem.

Assessment relevance:
    SQL Server service configuration is part of the operational, security,
    availability, and migration baseline.

    Important characteristics include:
        - Required SQL Server services
        - Startup configuration
        - Current service status
        - Service identities
        - Service-account privileges
        - Last startup time
        - Instant File Initialization for the Database Engine

    When comparing source and destination environments, service accounts
    should not automatically be copied from one environment to another.

    Destination service identities and permissions should be designed
    according to:
        - Security requirements
        - Domain architecture
        - Operational requirements
        - High availability requirements
        - Backup and restore requirements
        - File-system and network access requirements
        - Organizational service-account standards

Notes:
    LastStartupTime is dynamic operational information and should not be
    treated as a fixed expected value.

    Service-account names may expose information about infrastructure,
    security design, or domain configuration and should therefore be handled
    appropriately when assessment results are shared.

    Instant File Initialization should be interpreted primarily for the SQL
    Server Database Engine service.

    This section reports current service configuration only.

    It does not start, stop, restart, reconfigure, or modify any SQL Server
    service or service account.
*/