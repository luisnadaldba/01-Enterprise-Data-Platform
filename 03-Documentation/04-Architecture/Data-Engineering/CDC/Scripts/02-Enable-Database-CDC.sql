/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 02-Enable-Database-CDC.sql
    Version       : 1.0.0
    Target        : AtlasCommerce
    Purpose       : Enable and validate SQL Server CDC at database level
    Rerunnable    : Yes
    Destructive   : No

    Reconstruction Status
    --------------------------------------------------------------------------
    Consolidated/reconstructed from the approved Atlas Engineering CDC
    implementation evidence for database-level CDC enablement (M01.09).

    Verified historical behavior
    --------------------------------------------------------------------------
    - AtlasCommerce transitioned from is_cdc_enabled = 0 to 1
    - SQL Server created the cdc schema and CDC metadata infrastructure
    - No source table became CDC-enabled automatically

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

PRINT N'';
PRINT N'ATLAS ENGINEERING - ENABLE DATABASE CDC';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] PRE-VALIDATION';
PRINT N'------------------------------------------------------------';

DECLARE @DatabaseCDCEnabled bit;

SELECT
    @DatabaseCDCEnabled = is_cdc_enabled
FROM sys.databases
WHERE name = DB_NAME();

SELECT
    DB_NAME()             AS database_name,
    @DatabaseCDCEnabled   AS is_cdc_enabled,
    CASE WHEN SCHEMA_ID(N'cdc') IS NULL THEN N'NO' ELSE N'YES' END AS cdc_schema_present;

PRINT N'';
PRINT N'[2] ENABLE DATABASE CDC';
PRINT N'------------------------------------------------------------';

IF @DatabaseCDCEnabled = 0
BEGIN
    EXEC sys.sp_cdc_enable_db;
    PRINT N'[+] sys.sp_cdc_enable_db executed.';
END
ELSE
BEGIN
    PRINT N'[•] CDC is already enabled for AtlasCommerce. No change required.';
END;

PRINT N'';
PRINT N'[3] POST-VALIDATION';
PRINT N'------------------------------------------------------------';

SELECT
    d.name             AS database_name,
    d.is_cdc_enabled   AS is_cdc_enabled
FROM sys.databases AS d
WHERE d.name = DB_NAME();

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE name = DB_NAME()
      AND is_cdc_enabled = 1
)
BEGIN
    ;THROW 51010, N'CDC database-level enablement validation failed.', 1;
END;

IF SCHEMA_ID(N'cdc') IS NULL
BEGIN
    ;THROW 51011, N'CDC schema was not found after database-level enablement.', 1;
END;

PRINT N'';
PRINT N'[4] CDC INFRASTRUCTURE';
PRINT N'------------------------------------------------------------';

SELECT
    s.name AS cdc_schema
FROM sys.schemas AS s
WHERE s.name = N'cdc';

SELECT
    o.name,
    o.type_desc
FROM sys.objects AS o
WHERE o.schema_id = SCHEMA_ID(N'cdc')
  AND o.name IN
      (
          N'lsn_time_mapping',
          N'change_tables',
          N'captured_columns',
          N'ddl_history',
          N'index_columns'
      )
ORDER BY o.name;

PRINT N'';
PRINT N'[5] SOURCE TABLE CDC STATE';
PRINT N'------------------------------------------------------------';

SELECT
    s.name             AS source_schema,
    t.name             AS source_table,
    t.is_tracked_by_cdc
FROM sys.tables AS t
INNER JOIN sys.schemas AS s
    ON s.schema_id = t.schema_id
WHERE s.name = N'sales'
  AND t.name IN
      (
          N'Transaction',
          N'TransactionItem',
          N'TransactionChannel',
          N'TransactionStatus'
      )
ORDER BY t.name;

PRINT N'';
PRINT N'[✓] Database-level CDC enablement validated.';
PRINT N'';
