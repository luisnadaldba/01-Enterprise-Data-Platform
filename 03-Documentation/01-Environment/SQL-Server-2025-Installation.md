# SQL Server 2025 Developer Edition - Installation and Environment Setup

**Document ID:** ENV-SQL-001  
**Installation Date:** 2026-08-09  
**Environment:** Local Development  
**Server:** NADAL-0001  
**SQL Server Version:** SQL Server 2025  
**Edition:** Developer Edition (64-bit)  
**Product Version:** 17.0.1000.7  
**Product Level:** RTM  
**Instance:** MSSQLSERVER (Default Instance)  
**Status:** Installed and Validated

---

## 1. Purpose

This document describes the installation, initial configuration, and validation of the SQL Server 2025 development environment used by the Atlas Engineering Enterprise Data Platform.

The objective is not only to document the installation procedure, but also to establish a reproducible baseline for the SQL Server environment.

This baseline can later be used for:

- Environment reconstruction
- Troubleshooting
- Configuration comparison
- Server migration assessments
- Disaster recovery exercises
- Infrastructure documentation
- Validation of source and destination environments

---

## 2. Environment Overview

The SQL Server environment was installed locally on the workstation:

    Machine Name    : NADAL-0001
    Instance Name   : Default Instance
    Service Name    : MSSQLSERVER
    SQL Server      : 2025
    Edition         : Developer Edition (64-bit)
    Product Version : 17.0.1000.7
    Product Level   : RTM

SQL Server Management Studio 22 was installed as the primary administration and database development interface.

---

## 3. Installation Decisions

### 3.1 SQL Server Edition

SQL Server 2025 Developer Edition was selected.

Developer Edition provides the SQL Server Enterprise feature set for development and testing purposes without requiring a production Enterprise license.

This allows the project environment to develop and validate advanced SQL Server architectures and features while remaining a non-production environment.

---

### 3.2 Instance Configuration

A default SQL Server instance was selected.

    Instance Name : MSSQLSERVER

The default instance simplifies connectivity within the local development environment while preserving the ability to perform instance configuration, validation, and assessment activities.

---

### 3.3 Authentication

The SQL Server instance was configured to support SQL Server Authentication in addition to Windows Authentication.

Administrative access was validated using Windows Authentication.

The Windows account:

    NADAL-0001\luisn

was confirmed as a member of the SQL Server `sysadmin` fixed server role.

The `sa` login was also available in the local development environment for controlled administrative and testing scenarios.

For normal administrative activities, Windows Authentication should be preferred.

---

## 4. SQL Server Collation

The SQL Server instance was installed using the following collation:

    Latin1_General_CI_AS

The following system database collations were validated:

    master : Latin1_General_CI_AS
    tempdb : Latin1_General_CI_AS

Additional collation properties were collected:

    Code Page        : 1252
    Comparison Style : 196609

Functional comparison tests confirmed:

    'Atlas' = 'ATLAS' -> Equal
    'cafe'  = 'café'  -> Different

These results are consistent with a case-insensitive (`CI`) and accent-sensitive (`AS`) collation.

Collation is part of the environment baseline because differences between the SQL Server instance, `tempdb`, and user databases can affect:

- String comparisons
- Sorting
- Joins
- Temporary objects
- Application behavior
- Data integration
- Migration compatibility

Particular attention should be given to collation differences involving `tempdb`, because temporary objects may participate in comparisons with objects from user databases and can produce collation conflicts when incompatible collations are involved.

---

## 5. Server Resource Configuration

The initial SQL Server resource configuration was collected and recorded as part of the installation baseline.

These values describe the development environment at the time of validation and should not be interpreted as universal production recommendations.

### 5.1 Memory

The environment reported approximately:

    Physical Memory   : 16068 MB
    Max Server Memory : 10752 MB
    Min Server Memory : 0 MB

The `max server memory (MB)` configuration was intentionally limited to 10752 MB so that part of the physical memory remains available to Windows and other applications running on the development workstation.

The `min server memory (MB)` configuration remained at 0 MB.

A configured minimum value of 0 MB does not mean that SQL Server uses zero memory. It represents the configured lower memory target that SQL Server may attempt to retain after memory has been acquired and should not be interpreted as current SQL Server memory consumption.

No additional memory tuning was performed during the initial environment setup.

The recorded values establish the initial memory-configuration baseline for subsequent comparison and assessment.

---

### 5.2 CPU and Parallelism

The environment reported the following processor and SQL Server scheduling characteristics:

    Logical CPU Count   : 20
    Socket Count        : 1
    Cores per Socket    : 10
    NUMA Nodes          : 2
    Scheduler Count     : 20
    Max Worker Threads  : 768
    Soft-NUMA           : ON

The initial parallelism configuration was recorded as:

    MAXDOP                         : 4
    Cost Threshold for Parallelism : 5

These values represent the processor topology, scheduling characteristics, and parallelism configuration observed during the initial environment validation.

`MAXDOP` was configured as 4 for the current development environment.

The `cost threshold for parallelism` value remained at 5 and was recorded as part of the initial configuration baseline. This value should not be interpreted as a general recommendation for production workloads.

No additional parallelism tuning was performed during the initial environment setup because representative workload behavior had not yet been established.

Future changes to parallelism configuration should be based on workload characteristics, processor topology, concurrency, performance measurements, and documented technical evaluation.

---

## 6. tempdb Configuration

The SQL Server installation created eight `tempdb` data files.

At the time of the initial environment validation, each data file was configured with:

    Initial Size : 128 MB
    Growth       : 128 MB

The `tempdb` transaction log file was configured with:

    Initial Size : 256 MB
    Growth       : 128 MB

The files use fixed-size autogrowth rather than percentage-based growth.

The `tempdb` data files were configured with equal initial sizes and equal growth increments, establishing a balanced initial file configuration for the development environment.

This configuration is recorded as part of the installation baseline and should not be interpreted as a universal recommendation for other SQL Server environments.

The appropriate number, size, and growth configuration of `tempdb` files depends on characteristics such as:

- Processor topology
- Workload behavior
- Concurrency
- Storage architecture
- Available storage capacity
- Observed `tempdb` usage

Fixed-size autogrowth provides more predictable growth behavior than percentage-based growth.

Autogrowth should be treated as a safety mechanism rather than as the primary capacity-management strategy. Whenever practical, `tempdb` should be sized proactively according to workload requirements and available storage.

Because `tempdb` is recreated whenever the SQL Server Database Engine starts, its configuration should also be considered part of the SQL Server instance configuration baseline.

---

## 7. Database File Configuration

The SQL Server system database files were reviewed as part of the initial environment validation.

The assessment included:

- Physical file locations
- Current allocated sizes
- Autogrowth values
- Autogrowth types
- Maximum configured file sizes

Some system database files retained percentage-based autogrowth settings from the initial SQL Server installation, while others used fixed-size autogrowth.

These values were preserved and recorded as part of the original installation baseline.

Fixed-size autogrowth provides more predictable allocation behavior than percentage-based growth because the amount allocated during each growth event remains constant rather than increasing as the file becomes larger.

However, an appropriate file-growth configuration depends on characteristics such as:

- Current database size
- Expected growth rate
- Workload behavior
- Storage performance
- Available storage capacity
- Recovery requirements
- Operational requirements

Different databases and file types may therefore require different growth configurations.

Autogrowth should be treated as a safety mechanism rather than as the primary capacity-management strategy. Database files should preferably be sized proactively according to expected growth, workload behavior, and available storage.

Transaction log growth requires additional consideration because log file growth does not receive the same Instant File Initialization benefit as data file growth.

No changes were made to the system database file configuration during the initial environment setup.

The observed values were retained as the original installation baseline for subsequent assessment and comparison.

---

## 8. Instant File Initialization

Instant File Initialization (IFI) was validated for the SQL Server Database Engine service.

The validation was performed using:

    sys.dm_server_services

The environment reported:

    SQL Server (MSSQLSERVER) : Enabled

Instant File Initialization allows SQL Server to allocate space for data files without first zero-initializing the entire newly allocated region.

This can significantly reduce the time required for operations involving data-file allocation, including:

- Database creation
- Data file growth
- Database restore operations

Instant File Initialization applies to SQL Server data files.

Transaction log files still require initialization and do not receive the same performance benefit from IFI.

IFI is therefore relevant to the environment baseline when evaluating:

- Database creation behavior
- Data file autogrowth
- Restore duration
- Migration readiness
- Recovery expectations
- Source and destination environment differences

The enabled state observed during the initial validation was recorded as part of the SQL Server installation baseline.

The setting should be validated independently when building or assessing another SQL Server environment because it depends on the Database Engine service account and the privileges assigned in the operating system.

---

## 9. SQL Server Services

The SQL Server services were reviewed as part of the initial environment validation.

The following services were confirmed:

    SQL Server (MSSQLSERVER)
        Startup Type : Automatic
        Status       : Running
        Account      : NT Service\MSSQLSERVER
        IFI          : Enabled

    SQL Server Agent (MSSQLSERVER)
        Startup Type : Automatic
        Status       : Running
        Account      : NT Service\SQLSERVERAGENT

Both services were confirmed operational at the time of the initial environment validation.

Service configuration is part of the operational and security baseline because it can affect:

- SQL Server availability
- Service startup behavior
- Administrative operations
- Scheduled jobs and automation
- File-system and network access
- Backup and restore operations
- High availability configurations
- Instant File Initialization

Instant File Initialization is operationally relevant to the SQL Server Database Engine service and should not be interpreted in the same way for other SQL Server services.

Service accounts are environment-specific configuration and should not automatically be copied when building or migrating to another SQL Server environment.

Service identities and permissions should be designed according to:

- Security requirements
- Domain architecture
- Operational requirements
- High availability requirements
- Backup and restore requirements
- File-system and network access requirements
- Organizational service-account standards

The service accounts used by this development environment are local virtual service accounts and were retained as part of the initial environment configuration.

Service-account configuration should be reviewed independently when designing another environment.

---

## 10. Network Configuration

The SQL Server network configuration was reviewed using SQL Server Configuration Manager as part of the initial environment validation.

The following protocol configuration was recorded:

    Shared Memory : Enabled
    Named Pipes   : Disabled
    TCP/IP        : Disabled

This configuration reflects the initial local-only development requirements of the Atlas Engineering environment.

Shared Memory provides local connectivity between applications and the SQL Server instance running on the same computer.

TCP/IP was intentionally left disabled because remote SQL Server connectivity was not required during the initial environment setup.

Named Pipes was also left disabled because it was not required by the current local development architecture.

The protocol configuration should not be interpreted as a general recommendation for other SQL Server environments.

Network requirements should be reviewed whenever the architecture introduces components that require connectivity to the SQL Server instance from outside the local host, such as:

- Remote clients
- External ingestion services
- Containers
- Virtual machines
- Application services
- Data integration components
- Monitoring or administration services

When remote connectivity becomes necessary, the required SQL Server network protocols, listening configuration, firewall rules, authentication requirements, and security controls should be evaluated according to the target architecture.

The protocol state recorded in this section represents the initial network-configuration baseline and should be reassessed as the Atlas Engineering architecture evolves.

---

## 11. Initial Configuration Baseline

Selected SQL Server instance-level configuration values were collected and recorded as part of the initial environment baseline:

    Backup Compression Default      : 0
    Blocked Process Threshold (s)   : 0
    Cost Threshold for Parallelism  : 5
    MAXDOP                          : 4
    Max Server Memory (MB)          : 10752
    Optimize for Ad Hoc Workloads   : 0
    Remote Admin Connections        : 0

These values represent the SQL Server instance configuration recorded during the initial environment validation.

They establish a reference point for subsequent configuration comparison, troubleshooting, migration assessment, and performance analysis.

The recorded values should not be interpreted as universal recommendations or as final production configuration.

Some values may reflect SQL Server defaults, while others may represent configuration decisions made specifically for the local development environment.

Future configuration changes should be based on:

- Workload characteristics
- Performance measurements
- Hardware and operating environment
- Concurrency requirements
- Recovery requirements
- Security requirements
- Architecture requirements
- Documented technical decisions

When configuration changes are introduced, the original installation baseline should remain preserved so that the evolution of the environment can be understood and compared over time.

---

## 12. Environment Validation

A dedicated diagnostic script is maintained to assess and validate the SQL Server environment:

    04-Scripts/
        05-Diagnostics/
            Assess-SQL-Server-Environment.sql

The script provides a read-only assessment of multiple characteristics of the SQL Server instance, including:

- Instance identity
- SQL Server version and edition
- Authentication and administrative access
- Instance, system database, and current database collations
- Collation comparison behavior
- Memory configuration
- CPU and NUMA topology
- SQL Server configuration options
- Instant File Initialization
- `tempdb` configuration
- System database configuration
- Database files and autogrowth
- SQL Server services

The script does not modify SQL Server configuration, database objects, application data, or user data.

It can be used for:

- Initial environment assessment
- Environment baseline collection
- Pre-migration assessment
- Post-migration comparison
- Troubleshooting
- Environment comparison

The diagnostic script was successfully executed and validated against the current local development environment.

It is maintained as the reusable technical assessment mechanism for the SQL Server environment and complements the installation baseline documented here.

---

## 13. Migration Relevance

The environment assessment established during the initial SQL Server setup also provides the foundation for a reusable migration assessment process.

Before migrating a SQL Server environment, relevant configuration and environment information should be collected from the source environment.

After the destination environment is built, the same assessment can be performed again so that the environments can be compared systematically.

The comparison can help identify differences involving:

- SQL Server version and edition
- Authentication and administrative access
- Collation
- Memory configuration
- CPU and NUMA topology
- Parallelism configuration
- Database compatibility
- System database configuration
- Database file layout
- File size and autogrowth configuration
- `tempdb` configuration
- SQL Server services
- Service accounts
- Instant File Initialization

Additional migration-specific characteristics, such as network configuration, connectivity requirements, security dependencies, and application integration requirements, should be assessed separately when applicable.

The `Assess-SQL-Server-Environment.sql` diagnostic script provides a reusable read-only mechanism for collecting a significant portion of this technical baseline from SQL Server.

The collected information should not be used simply to reproduce the source configuration on the destination server.

Instead, source and destination results should be compared to determine which differences are:

- Expected because of the destination architecture
- Intentional configuration changes
- Compatibility concerns
- Security or operational requirements
- Items requiring additional technical validation

This approach provides a repeatable source-to-destination assessment process and reduces reliance on undocumented manual inspection.

---

## 14. Security Considerations

Administrative access to a SQL Server environment should not depend exclusively on the personal account of a single individual.

An appropriate administrative access strategy should consider:

- Privileged access requirements
- Administrative continuity
- Recovery of administrative access
- Separation between personal and service identities
- Auditing requirements
- Organizational security policies

Windows Authentication should be preferred for normal administrative operations when appropriate for the environment and organizational security model.

The `sa` login, when enabled, should be treated as a highly privileged account.

Its availability should not replace an appropriate administrative access and recovery strategy, and its use should be restricted according to the security requirements of the environment.

Service accounts should also be treated as environment-specific security configuration.

When building or migrating a SQL Server environment, service identities and privileges should be reviewed independently according to:

- Required operating system privileges
- File-system access
- Network access
- Backup and restore requirements
- High availability requirements
- Domain architecture
- Organizational service-account standards

Administrative and service-account configuration should not be copied automatically from a source environment to a destination environment.

Security configuration should be evaluated according to the architecture, operational requirements, and security policies of the target environment.

---

## 15. Lessons Learned

The installation and validation process reinforced that installing SQL Server is only one part of establishing a reliable database environment.

A reproducible environment also requires understanding and documenting:

- What was installed
- How the environment was configured
- Why configuration decisions were made
- Which values represent installation defaults
- Which values were intentionally changed
- Which configurations depend on workload or architecture
- How the environment can be independently assessed and validated

The validation process also demonstrated the importance of verifying diagnostic procedures against the metadata available in the installed SQL Server version.

During the initial assessment, `instant_file_initialization_enabled` was queried from:

    sys.dm_os_sys_info

The required information was not available from that DMV in the installed environment.

Inspection of the available SQL Server metadata identified the appropriate source as:

    sys.dm_server_services

The diagnostic procedure was then corrected to retrieve Instant File Initialization information from the appropriate DMV.

This experience reinforced an important diagnostic principle:

> Do not adapt the environment to make a diagnostic query work. Validate the metadata available in the installed platform and adapt the diagnostic procedure to the actual environment.

Diagnostic scripts should therefore be treated as version-aware technical tools whose assumptions must be validated against the SQL Server environment in which they are executed.

---

## 16. Environment Evolution

The SQL Server installation and initial environment validation established the local database platform required for the subsequent stages of Atlas Engineering.

The environment is intended to support the continued development and evolution of the platform, including:

- Transactional database development
- Data model deployment and validation
- Controlled data deployment
- Data ingestion and integration
- Data engineering workloads
- Analytical data structures
- Monitoring and diagnostics
- Performance assessment and tuning
- Security evolution
- Environment and architecture validation

As the platform evolves, SQL Server configuration changes may become necessary because of new workloads, architectural components, connectivity requirements, performance observations, or operational requirements.

Changes introduced after the initial environment setup should be documented separately from this installation baseline.

The original baseline should remain preserved so that subsequent configuration states can be compared with the environment as initially installed and validated.

This separation provides a historical reference for understanding:

- Which configuration belonged to the original installation
- Which settings were changed later
- Why each significant change was introduced
- How the environment evolved with the Atlas Engineering architecture

---

## 17. Related Documentation

The following diagnostic script provides the reusable technical assessment mechanism associated with the SQL Server environment documented here:

    04-Scripts/
        05-Diagnostics/
            Assess-SQL-Server-Environment.sql

The script complements this installation baseline by providing a read-only mechanism for collecting and comparing SQL Server instance, configuration, storage, database, security-context, and service information.

This document records the installation and initial environment baseline, while the diagnostic script provides the reusable mechanism for assessing the environment over time.

---

## Document Status

**Status:** Complete  
**Environment validated:** Yes  
**Initial validation date:** 2026-08-09