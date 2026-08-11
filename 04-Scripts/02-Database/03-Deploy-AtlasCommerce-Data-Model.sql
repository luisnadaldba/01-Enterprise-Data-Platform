/*==============================================================================
    Script Name : 03-Deploy-AtlasCommerce-Data-Model.sql
    Version     : 1.0.0
    Target      : AtlasCommerce
    Purpose     : Deploy and validate the AtlasCommerce relational data model
    Rerunnable  : Yes
==============================================================================*/

:setvar DataModelRoot "C:\Projects\Atlas Engineering\01-Enterprise-Data-Platform\04-Scripts\02-Database\01-Data-Model-Deployment"

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @ScriptVersion nvarchar(20) = N'1.0.0';
DECLARE @ScriptName    sysname      = N'03-Deploy-AtlasCommerce-Data-Model.sql';
DECLARE @DatabaseName  sysname      = N'AtlasCommerce';
DECLARE @StartTime     datetime2(0) = SYSDATETIME();

PRINT N'';
PRINT N'==============================================================================';
PRINT N' ATLAS COMMERCE - DATA MODEL DEPLOYMENT';
PRINT N'==============================================================================';
PRINT N' Script   : ' + @ScriptName;
PRINT N' Version  : ' + @ScriptVersion;
PRINT N' Database : ' + @DatabaseName;
PRINT N' Started  : ' + CONVERT(nvarchar(19), @StartTime, 120);
PRINT N'==============================================================================';
PRINT N'';

IF DB_NAME() <> @DatabaseName
BEGIN
    ;THROW 50001, N'Incorrect database context. Expected database: AtlasCommerce.', 1;
END;

BEGIN TRY

    /*==============================================================================
        PARTITIONING
    ==============================================================================*/

    PRINT N' PARTITIONING';
    PRINT N'';

    :r $(DataModelRoot)\00-Partitioning\01-Filegroups\00-Sales-Partitioning-Config.sql
    :r $(DataModelRoot)\00-Partitioning\01-Filegroups\01-Sales-Filegroups.sql

    :r $(DataModelRoot)\00-Partitioning\02-Partition-Functions\01-Sales-Partition-Function.sql

    :r $(DataModelRoot)\00-Partitioning\03-Partition-Schemes\01-Sales-Partition-Scheme.sql

    :r $(DataModelRoot)\00-Partitioning\04-Partition-Validation\01-Sales-Partition-Validation.sql

    /*==========================================================================
        TRANSACTIONAL DATA MODEL DEPLOYMENT
    ==========================================================================*/

    BEGIN TRANSACTION;

    /*==========================================================================
        TABLES
    ==========================================================================*/

    PRINT N' TABLES';
    PRINT N'';

    :r $(DataModelRoot)\01-Tables\metadata.TablePrefix.sql
    :r $(DataModelRoot)\01-Tables\sales.Transaction.sql

    /*==========================================================================
        OBJECT DOCUMENTATION
    ==========================================================================*/

    PRINT N' OBJECT DOCUMENTATION';
    PRINT N'';

    :r $(DataModelRoot)\02-Object-Documentation\metadata.TablePrefix.Documentation.sql

    /*==========================================================================
        SEED DATA
    ==========================================================================*/

    PRINT N' SEED DATA';
    PRINT N'';

    :r $(DataModelRoot)\03-Seed-Data\metadata.TablePrefix.Seed.sql

    /*==========================================================================
        DEFAULT CONSTRAINTS
    ==========================================================================*/

    PRINT N' DEFAULT CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\04-Default-Constraints\metadata.TablePrefix.Defaults.sql

    /*==========================================================================
        CHECK CONSTRAINTS
    ==========================================================================*/

    PRINT N' CHECK CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\05-Check-Constraints\metadata.TablePrefix.Checks.sql

    /*==========================================================================
        UNIQUE CONSTRAINTS
    ==========================================================================*/

    PRINT N' UNIQUE CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\06-Unique-Constraints\metadata.TablePrefix.Uniques.sql

    /*==========================================================================
        FOREIGN KEY CONSTRAINTS
    ==========================================================================*/

    PRINT N' FOREIGN KEY CONSTRAINTS';
    PRINT N'';


    /*==========================================================================
        INDEXES
    ==========================================================================*/

    PRINT N' INDEXES';
    PRINT N'';


    /*==========================================================================
        FINAL VALIDATION
    ==========================================================================*/

    PRINT N' FINAL VALIDATION';
    PRINT N'';

    :r $(DataModelRoot)\09-Final-Validation\metadata.TablePrefix.FinalValidation.sql

    COMMIT TRANSACTION;

    PRINT N'';
    PRINT N'==============================================================================';
    PRINT N' AtlasCommerce data model deployment completed successfully.';
    PRINT N'==============================================================================';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'';
    PRINT N'==============================================================================';
    PRINT N' AtlasCommerce data model deployment FAILED.';
    PRINT N'==============================================================================';
    PRINT N' Error Number    : ' + CONVERT(nvarchar(20), ERROR_NUMBER());
    PRINT N' Error Severity  : ' + CONVERT(nvarchar(20), ERROR_SEVERITY());
    PRINT N' Error State     : ' + CONVERT(nvarchar(20), ERROR_STATE());
    PRINT N' Error Line      : ' + CONVERT(nvarchar(20), ERROR_LINE());
    PRINT N' Error Procedure : ' + COALESCE(ERROR_PROCEDURE(), N'N/A');
    PRINT N' Error Message   : ' + ERROR_MESSAGE();
    PRINT N'==============================================================================';

    THROW;

END CATCH;