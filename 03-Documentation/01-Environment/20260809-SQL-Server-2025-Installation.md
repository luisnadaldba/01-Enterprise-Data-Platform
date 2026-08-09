# SQL Server 2025 Enterprise Developer - Installation and Environment Setup

**Document ID:** ENV-SQL-001  
**Date:** 2026-08-09  
**Environment:** Local Development  
**Server:** NADAL-0001  
**SQL Server Version:** SQL Server 2025  
**Edition:** Enterprise Developer Edition (64-bit)  
**Product Version:** 17.0.1000.7  
**Product Level:** RTM  
**Instance:** MSSQLSERVER (Default Instance)  
**Status:** Installed and Validated

---

## 1. Purpose

This document describes the installation, initial configuration, and
validation of the SQL Server 2025 development environment used by the
Atlas Enterprise Data Platform project.

The objective is not only to document the installation procedure, but
also to establish a reproducible baseline for the SQL Server environment.

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
    Edition         : Enterprise Developer Edition (64-bit)
    Product Version : 17.0.1000.7
    Product Level   : RTM

SQL Server Management Studio 22 was installed as the primary
administration and database development interface.

---

## 3. Installation Decisions

### 3.1 SQL Server Edition

SQL Server 2025 Enterprise Developer Edition was selected.

Developer Edition provides the SQL Server Enterprise feature set for
development and testing purposes without requiring a production
Enterprise license.

This allows the project environment to simulate advanced SQL Server
architectures and features while remaining a non-production environment.

---

### 3.2 Instance Configuration

A default SQL Server instance was selected.

    Instance Name : MSSQLSERVER

The default instance simplifies local development connectivity while
still allowing the environment to demonstrate instance discovery,
configuration validation, and migration assessment procedures.

---

### 3.3 Authentication

The SQL Server instance was configured to support SQL Server
authentication in addition to Windows authentication.

Administrative access was validated using Windows Authentication.

The Windows account:

    NADAL-0001\luisn

was confirmed as a member of the SQL Server `sysadmin` server role.

The `sa` login is also available for administrative recovery and
controlled testing scenarios.

For normal administrative activities, Windows Authentication should be
preferred.

---

## 4. SQL Server Collation

The SQL Server instance was installed using:

    Latin1_General_CI_AS

The following system databases were validated:

    master : Latin1_General_CI_AS
    tempdb : Latin1_General_CI_AS

Additional validation identified:

    Code Page        : 1252
    Comparison Style : 196609

Functional tests confirmed:

    'Atlas' = 'ATLAS' -> Equal
    'cafe'  = 'café'  -> Different

This confirms that the selected collation is case-insensitive (`CI`) and
accent-sensitive (`AS`).

Collation is considered part of the environment baseline because
differences between source and destination environments can affect
string comparisons, sorting behavior, temporary objects, joins, and
database migrations.

---

## 5. Server Resource Configuration

The initial SQL Server configuration was inspected after installation.

### 5.1 Memory

    Physical Memory                       : 16068 MB
    Max Server Memory                     : 10752 MB
    Min Server Memory                     : 0 MB configured
    ValueInUse observed during validation : 16 MB

The configured maximum SQL Server memory leaves part of the physical
memory available to Windows and other applications running on the
development workstation.

No additional memory tuning was performed during the initial
installation.

---

### 5.2 CPU and Parallelism

The environment reported:

    CPU Count             : 20 logical CPUs
    Socket Count          : 1
    Cores per Socket      : 10
    NUMA Nodes            : 2
    Scheduler Count       : 20
    Max Worker Threads    : 768
    Soft-NUMA             : ON

Initial parallelism configuration:

    MAXDOP                         : 4
    Cost Threshold for Parallelism : 5

These values were recorded as the installation baseline.

No tuning change was performed at this stage because workload behavior
has not yet been established.

---

## 6. tempdb Configuration

The SQL Server installation created eight tempdb data files.

Each data file was initially configured with:

    Initial Size : 128 MB
    Growth       : 128 MB

The tempdb log file was configured with:

    Initial Size : 256 MB
    Growth       : 128 MB

The files use fixed MB autogrowth rather than percentage-based growth.

The initial configuration is suitable for the current development
environment.

For environments with significant I/O activity, larger fixed growth
increments may be considered after workload analysis. A value such as
1024 MB may be appropriate in some high-I/O environments, but should
not be applied without evaluating workload, storage capacity, and growth
patterns.

---

## 7. Database File Configuration

System database files were reviewed after installation.

Some system database files retain percentage-based autogrowth
configuration.

Percentage-based file growth can become increasingly large as databases
grow and may introduce unpredictable storage allocation times.

For production environments, fixed MB growth values are generally
preferred and should be selected according to database size, workload,
storage performance, and expected growth.

No changes were made to the system databases during this installation.

The existing values were preserved as the original installation
baseline.

---

## 8. Instant File Initialization

Instant File Initialization was validated using:

    sys.dm_server_services

Result:

    SQL Server (MSSQLSERVER) : Enabled

Instant File Initialization reduces the time required for SQL Server to
allocate data files by avoiding zero initialization of the newly
allocated data-file space.

The setting is considered relevant for database creation, restoration,
file growth operations, and migration procedures.

---

## 9. SQL Server Services

The following services were validated:

    SQL Server (MSSQLSERVER)
        Startup Type : Automatic
        Status       : Running
        Account      : NT Service\MSSQLSERVER
        IFI          : Enabled

    SQL Server Agent (MSSQLSERVER)
        Startup Type : Automatic
        Status       : Running
        Account      : NT Service\SQLSERVERAGENT

Both primary SQL Server services were confirmed operational.

Service accounts are considered environment-specific configuration and
should not automatically be copied during server migrations.

---

## 10. Network Configuration

The initial SQL Server network configuration was inspected using
SQL Server Configuration Manager.

Initial state:

    Shared Memory : Enabled
    Named Pipes   : Disabled
    TCP/IP        : Disabled

This configuration is appropriate for the initial local-only development
environment.

TCP/IP was intentionally left disabled because remote SQL Server
connectivity is not currently required.

When distributed components, external ingestion services, containers,
virtual machines, or remote clients are introduced into the architecture,
TCP/IP configuration will be reviewed.

---

## 11. Initial Configuration Baseline

Additional server configuration values were recorded:

    Backup Compression Default      : 0
    Blocked Process Threshold       : 0
    Cost Threshold for Parallelism  : 5
    MAXDOP                          : 4
    Max Server Memory               : 10752 MB
    Optimize for Ad Hoc Workloads   : 0
    Remote Admin Connections        : 0

These values represent the initial environment baseline.

They should not be interpreted as final production recommendations.

Future configuration changes must be based on workload evidence,
performance measurements, architecture requirements, and documented
technical decisions.

---

## 12. Environment Validation

A dedicated diagnostic script was created to validate the SQL Server
environment:

    04-Scripts/
        05-Diagnostics/
            20260809-Validate-SQL-Server-Environment.sql

The script validates multiple aspects of the SQL Server instance,
including:

- Instance identity
- SQL Server version and edition
- Authentication and administrative access
- Collation
- Collation behavior
- Memory configuration
- CPU and NUMA topology
- SQL Server configuration options
- tempdb configuration
- Database configuration
- Database files and autogrowth
- SQL Server services
- Instant File Initialization

The script was executed successfully against the newly installed
environment on 2026-08-09.

---

## 13. Migration Relevance

The environment validation performed during this installation also
represents the beginning of a reusable migration assessment process.

Before migrating a SQL Server environment, the same information should
be collected from the source environment.

After building the destination environment, the validation can be
executed again.

The results can then be compared to identify differences in:

- SQL Server version and edition
- Authentication
- Collation
- Memory configuration
- CPU topology
- Parallelism
- Database compatibility
- Database configuration
- File layout
- File growth
- tempdb
- Services
- Service accounts
- Instant File Initialization
- Network configuration

This creates a repeatable source-to-destination validation procedure
instead of relying on manual inspection.

---

## 14. Security Considerations

Administrative access should not depend exclusively on an individual
employee account.

Production environments should maintain controlled administrative
recovery mechanisms and documented procedures for restoring privileged
access.

Windows Authentication should be preferred for normal administrative
operations where appropriate.

The `sa` account, when enabled, should be treated as a privileged
emergency or controlled administrative account and protected
accordingly.

Service accounts must also be reviewed independently when migrating
between environments.

---

## 15. Lessons Learned

The installation and validation exercise demonstrated that installing
SQL Server is only one part of establishing a database environment.

A reliable environment also requires understanding and documenting:

- What was installed
- How it was configured
- Why configuration decisions were made
- Which values are installation defaults
- Which values were intentionally changed
- Which configurations are workload-dependent
- How the environment can be independently validated

During validation, a version-specific difference was also identified
when `instant_file_initialization_enabled` was initially queried from
`sys.dm_os_sys_info`.

Inspection of the available metadata showed that the required
information should instead be obtained from:

    sys.dm_server_services

This reinforced an important diagnostic principle:

> Do not adapt the environment to make a diagnostic query work. Validate
> the metadata available in the installed version and adapt the
> diagnostic procedure to the actual platform.

---

## 16. Next Steps

The SQL Server installation is complete and the initial environment
baseline has been validated.

Future project stages will introduce application databases, schemas,
data sources, ingestion processes, security structures, monitoring, and
performance workloads.

Configuration changes introduced during those stages should be
documented separately so that the original installation baseline remains
preserved.

---

## 17. Related Documentation

    04-Scripts/
        05-Diagnostics/
            20260809-Validate-SQL-Server-Environment.sql

---

## Document Status

**Status:** Complete  
**Environment validated:** Yes  
**Validation date:** 2026-08-09