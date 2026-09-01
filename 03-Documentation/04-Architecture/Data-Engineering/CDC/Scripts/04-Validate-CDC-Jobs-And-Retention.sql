/*==============================================================================
    ATLAS ENGINEERING - SQL SERVER CDC
==============================================================================

    Script Name   : 04-Validate-CDC-Jobs-And-Retention.sql
    Version       : 1.0.1
    Target        : AtlasCommerce
    Purpose       : Inspect and validate SQL Server CDC jobs and retention
    Rerunnable    : Yes
    Destructive   : No
    Changes State : No

    Validation Scope
    --------------------------------------------------------------------------
    Expected capture job:
        maxtrans       = 10000
        maxscans       = 10
        continuous     = 1
        pollinginterval= 5

    Expected cleanup job:
        retention      = 21600 minutes (15 days)
        threshold      = 4999

    Important
    --------------------------------------------------------------------------
    v1.0.1 correction:
    msdb.dbo.cdc_jobs exposes maxtrans, maxscans and pollinginterval
    (without underscores).

    This is a validation/inspection script only.

    It does NOT:
    - enable or disable CDC;
    - start or stop SQL Server Agent jobs;
    - change CDC job configuration;
    - modify source data;
    - modify CDC Change Tables.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

USE [AtlasCommerce];

DECLARE
    @DatabaseId              int = DB_ID(),
    @ExpectedMaxTrans        int = 10000,
    @ExpectedMaxScans        int = 10,
    @ExpectedContinuous      bit = 1,
    @ExpectedPollingInterval bigint = 5,
    @ExpectedRetention       bigint = 21600,
    @ExpectedThreshold       bigint = 4999;

PRINT N'';
PRINT N'ATLAS ENGINEERING - VALIDATE CDC JOBS AND RETENTION';
PRINT N'============================================================';
PRINT N'';

PRINT N'[1] DATABASE CDC STATE';
PRINT N'------------------------------------------------------------';

SELECT
    d.name           AS database_name,
    d.state_desc,
    d.is_cdc_enabled
FROM sys.databases AS d
WHERE d.database_id = @DatabaseId;

IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE database_id = @DatabaseId
      AND state_desc = N'ONLINE'
      AND is_cdc_enabled = 1
)
BEGIN
    ;THROW 51040, N'AtlasCommerce must be ONLINE with database-level CDC enabled.', 1;
END;

PRINT N'[✓] AtlasCommerce is ONLINE and database-level CDC is enabled.';

PRINT N'';
PRINT N'[2] CDC JOB CONFIGURATION';
PRINT N'------------------------------------------------------------';

EXEC sys.sp_cdc_help_jobs;

PRINT N'';
PRINT N'[3] CAPTURE JOB VALIDATION';
PRINT N'------------------------------------------------------------';

DECLARE
    @CaptureMaxTrans        int,
    @CaptureMaxScans        int,
    @CaptureContinuous      bit,
    @CapturePollingInterval bigint;

SELECT
    @CaptureMaxTrans        = cj.maxtrans,
    @CaptureMaxScans        = cj.maxscans,
    @CaptureContinuous      = cj.continuous,
    @CapturePollingInterval = cj.pollinginterval
FROM msdb.dbo.cdc_jobs AS cj
WHERE cj.database_id = @DatabaseId
  AND cj.job_type = N'capture';

IF @CaptureMaxTrans IS NULL
BEGIN
    ;THROW 51041, N'CDC capture job configuration was not found for AtlasCommerce.', 1;
END;

SELECT
    @CaptureMaxTrans        AS maxtrans,
    @CaptureMaxScans        AS maxscans,
    @CaptureContinuous      AS continuous,
    @CapturePollingInterval AS pollinginterval;

IF @CaptureMaxTrans <> @ExpectedMaxTrans
BEGIN
    ;THROW 51042, N'CDC capture job maxtrans differs from the Atlas Engineering expected value 10000.', 1;
END;

IF @CaptureMaxScans <> @ExpectedMaxScans
BEGIN
    ;THROW 51043, N'CDC capture job maxscans differs from the Atlas Engineering expected value 10.', 1;
END;

IF @CaptureContinuous <> @ExpectedContinuous
BEGIN
    ;THROW 51044, N'CDC capture job continuous differs from the Atlas Engineering expected value 1.', 1;
END;

IF @CapturePollingInterval <> @ExpectedPollingInterval
BEGIN
    ;THROW 51045, N'CDC capture job pollinginterval differs from the Atlas Engineering expected value 5 seconds.', 1;
END;

PRINT N'[✓] Capture job configuration matches the Atlas Engineering baseline.';

PRINT N'';
PRINT N'[4] CLEANUP JOB VALIDATION';
PRINT N'------------------------------------------------------------';

DECLARE
    @CleanupRetention bigint,
    @CleanupThreshold bigint;

SELECT
    @CleanupRetention = cj.retention,
    @CleanupThreshold = cj.threshold
FROM msdb.dbo.cdc_jobs AS cj
WHERE cj.database_id = @DatabaseId
  AND cj.job_type = N'cleanup';

IF @CleanupRetention IS NULL
BEGIN
    ;THROW 51046, N'CDC cleanup job configuration was not found for AtlasCommerce.', 1;
END;

SELECT
    @CleanupRetention AS retention_minutes,
    CAST(@CleanupRetention / 1440.0 AS decimal(10,2)) AS retention_days,
    @CleanupThreshold AS threshold;

IF @CleanupRetention <> @ExpectedRetention
BEGIN
    ;THROW 51047, N'CDC cleanup retention differs from the Atlas Engineering expected value 21600 minutes.', 1;
END;

IF @CleanupThreshold <> @ExpectedThreshold
BEGIN
    ;THROW 51048, N'CDC cleanup threshold differs from the Atlas Engineering expected value 4999.', 1;
END;

PRINT N'[✓] Cleanup retention = 21600 minutes (15 days).';
PRINT N'[✓] Cleanup threshold = 4999.';

PRINT N'';
PRINT N'[5] SQL SERVER AGENT JOB STATE';
PRINT N'------------------------------------------------------------';

;WITH CurrentAgentSession AS
(
    SELECT MAX(session_id) AS session_id
    FROM msdb.dbo.syssessions
)
SELECT
    sj.name AS job_name,
    CASE
        WHEN sja.start_execution_date IS NOT NULL
         AND sja.stop_execution_date IS NULL
            THEN N'RUNNING'
        ELSE N'NOT RUNNING'
    END AS execution_state,
    sja.start_execution_date,
    sja.stop_execution_date
FROM msdb.dbo.cdc_jobs AS cj
INNER JOIN msdb.dbo.sysjobs AS sj
    ON sj.job_id = cj.job_id
LEFT JOIN msdb.dbo.sysjobactivity AS sja
    ON sja.job_id = sj.job_id
   AND sja.session_id = (SELECT session_id FROM CurrentAgentSession)
WHERE cj.database_id = @DatabaseId
ORDER BY cj.job_type;

PRINT N'';
PRINT N'[6] CDC ERROR INSPECTION';
PRINT N'------------------------------------------------------------';

SELECT
    session_id,
    phase_number,
    error_number,
    error_severity,
    error_state,
    error_message,
    start_lsn,
    begin_lsn,
    sequence_value,
    entry_time
FROM sys.dm_cdc_errors
ORDER BY entry_time DESC;

IF EXISTS (SELECT 1 FROM sys.dm_cdc_errors)
BEGIN
    PRINT N'[!] CDC errors are present in sys.dm_cdc_errors.';
    PRINT N'[!] Review the result set above before considering CDC operationally healthy.';
END
ELSE
BEGIN
    PRINT N'[✓] No CDC errors are currently reported by sys.dm_cdc_errors.';
END;

PRINT N'';
PRINT N'[✓] CDC jobs and retention validation completed.';
PRINT N'[✓] This script made no configuration changes.';
PRINT N'';
