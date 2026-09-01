/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 01-Validate-CDC-Prerequisites.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Validate the source environment before SQL Server CDC setup
    Rerunnable    : Yes
    Destructive   : No

    Reconstruction Status
    --------------------------------------------------------------------------
    Consolidated/reconstructed from the approved Atlas Engineering CDC
    implementation evidence for the pre-CDC baseline (M01.08).

    This script reproduces the validation intent of the original laboratory
    step. It must not be represented as a byte-for-byte recovery of the
    original M01.08 script.

    Validates
    --------------------------------------------------------------------------
    - Target database existence and accessibility
    - Database state, recovery model, compatibility level and CDC state
    - SQL Server / SQL Server Agent service state
    - Transaction log size, usage and log reuse wait
    - Source table existence
    - Source row counts
    - CDC schema presence
    - Existing CDC capture instances

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @DatabaseName sysname = N'AtlasCommerce';

PRINT N'';
PRINT N'ATLAS ENGINEERING - CDC PREREQUISITE VALIDATION';
PRINT N'============================================================';
PRINT N'';

IF DB_ID(@DatabaseName) IS NULL
BEGIN
    ;THROW 51000, N'Target database AtlasCommerce does not exist.', 1;
END;

USE [AtlasCommerce];

PRINT N'[1] DATABASE STATE';
PRINT N'------------------------------------------------------------';

SELECT
    d.name                                      AS database_name,
    d.state_desc                                AS state_desc,
    d.recovery_model_desc                       AS recovery_model_desc,
    d.compatibility_level                       AS compatibility_level,
    d.is_cdc_enabled                            AS is_cdc_enabled,
    d.log_reuse_wait_desc                       AS log_reuse_wait_desc
FROM sys.databases AS d
WHERE d.name = DB_NAME();

PRINT N'';
PRINT N'[2] SQL SERVER SERVICES';
PRINT N'------------------------------------------------------------';

SELECT
    servicename,
    startup_type_desc,
    status_desc,
    service_account,
    last_startup_time
FROM sys.dm_server_services
WHERE servicename LIKE N'SQL Server%'
ORDER BY servicename;

PRINT N'';
PRINT N'[3] TRANSACTION LOG';
PRINT N'------------------------------------------------------------';

SELECT
    DB_NAME()                                                       AS database_name,
    CAST(total_log_size_in_bytes / 1048576.0 AS decimal(19,2))      AS total_log_size_mb,
    CAST(used_log_space_in_bytes / 1048576.0 AS decimal(19,2))      AS used_log_space_mb,
    CAST(used_log_space_in_percent AS decimal(9,2))                 AS used_log_space_percent
FROM sys.dm_db_log_space_usage;

SELECT
    name                  AS database_name,
    log_reuse_wait_desc
FROM sys.databases
WHERE name = DB_NAME();

PRINT N'';
PRINT N'[4] SOURCE TABLES';
PRINT N'------------------------------------------------------------';

DECLARE @RequiredTables TABLE
(
    schema_name sysname NOT NULL,
    table_name  sysname NOT NULL
);

INSERT INTO @RequiredTables (schema_name, table_name)
VALUES
    (N'sales', N'Transaction'),
    (N'sales', N'TransactionItem'),
    (N'sales', N'TransactionChannel'),
    (N'sales', N'TransactionStatus');

SELECT
    r.schema_name,
    r.table_name,
    CASE
        WHEN OBJECT_ID(QUOTENAME(r.schema_name) + N'.' + QUOTENAME(r.table_name), N'U') IS NOT NULL
            THEN N'PRESENT'
        ELSE N'MISSING'
    END AS object_state
FROM @RequiredTables AS r
ORDER BY r.schema_name, r.table_name;

IF EXISTS
(
    SELECT 1
    FROM @RequiredTables AS r
    WHERE OBJECT_ID(QUOTENAME(r.schema_name) + N'.' + QUOTENAME(r.table_name), N'U') IS NULL
)
BEGIN
    ;THROW 51001, N'One or more required AtlasCommerce.sales tables are missing.', 1;
END;

PRINT N'';
PRINT N'[5] SOURCE ROW COUNTS';
PRINT N'------------------------------------------------------------';

SELECT N'sales.Transaction'        AS source_table, COUNT_BIG(*) AS row_count FROM sales.[Transaction]
UNION ALL
SELECT N'sales.TransactionItem',   COUNT_BIG(*) FROM sales.TransactionItem
UNION ALL
SELECT N'sales.TransactionChannel',COUNT_BIG(*) FROM sales.TransactionChannel
UNION ALL
SELECT N'sales.TransactionStatus', COUNT_BIG(*) FROM sales.TransactionStatus;

PRINT N'';
PRINT N'[6] INITIAL CDC STATE';
PRINT N'------------------------------------------------------------';

SELECT
    CASE
        WHEN SCHEMA_ID(N'cdc') IS NULL THEN N'NO'
        ELSE N'YES'
    END AS cdc_schema_present;

IF SCHEMA_ID(N'cdc') IS NOT NULL
BEGIN
    SELECT
        ct.capture_instance,
        OBJECT_SCHEMA_NAME(ct.source_object_id) AS source_schema,
        OBJECT_NAME(ct.source_object_id)        AS source_table,
        ct.start_lsn,
        ct.supports_net_changes
    FROM cdc.change_tables AS ct
    ORDER BY ct.capture_instance;
END
ELSE
BEGIN
    PRINT N'No CDC schema is present.';
END;

PRINT N'';
PRINT N'[✓] CDC prerequisite validation completed.';
PRINT N'';
