    /*==============================================================================*
    * Script Name : 00-Sales-Partitioning-Config.sql
    * Version     : 1.0.0
    * Target      : AtlasCommerce
    * Purpose     : Define SQLCMD configuration used by Sales partitioning scripts
    * Rerunnable  : Yes
    *==============================================================================*/

    /*==============================================================================
        SALES PARTITIONING CONFIGURATION
    ==============================================================================*/

    DECLARE @SalesPartitionDataPath nvarchar(4000);
    DECLARE @SalesPrimaryPhysicalFile nvarchar(4000);

    SELECT
        @SalesPrimaryPhysicalFile = physical_name
    FROM sys.database_files
    WHERE file_id = 1;

    IF @SalesPrimaryPhysicalFile IS NULL
    BEGIN
        ;THROW 50010,
            N'Unable to determine the AtlasCommerce primary data file path.',
            1;
    END;

    SET @SalesPartitionDataPath =
        LEFT
        (
            @SalesPrimaryPhysicalFile,
            LEN(@SalesPrimaryPhysicalFile)
            - CHARINDEX
            (
                N'\',
                REVERSE(@SalesPrimaryPhysicalFile)
            )
            + 1
        );

    PRINT N'    Sales partition data path';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'        Path                         : ' + @SalesPartitionDataPath;
    PRINT N'';