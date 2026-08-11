    /*==============================================================================
        SALES PARTITION FILEGROUPS
    ==============================================================================*/

    DECLARE @SalesLegacyFilegroup sysname =
        N'FG_SALES_LEGACY';

    DECLARE @SalesLegacyLogicalFile sysname =
        N'AtlasCommerce_Sales_Legacy';

    DECLARE @SalesLegacyPhysicalFile nvarchar(4000) =
        @SalesPartitionDataPath
        + N'AtlasCommerce_Sales_Legacy.ndf';

    DECLARE @SalesFilegroupSql nvarchar(max);


    PRINT N'    Sales partition filegroups';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    /*==============================================================================
        FG_SALES_LEGACY
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = @SalesLegacyFilegroup
    )
    BEGIN

        SET @SalesFilegroupSql =
            N'ALTER DATABASE '
            + QUOTENAME(DB_NAME())
            + N' ADD FILEGROUP '
            + QUOTENAME(@SalesLegacyFilegroup)
            + N';';


        EXEC sys.sp_executesql
            @SalesFilegroupSql;


        PRINT N'        [+] Filegroup created              : '
            + @SalesLegacyFilegroup;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Filegroup already exists       : '
            + @SalesLegacyFilegroup;

    END;


    /*------------------------------------------------------------------------------
        DATA FILE
    ------------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.database_files
        WHERE name = @SalesLegacyLogicalFile
    )
    BEGIN

        /*
            Before creating the file, ensure that the expected physical path is not
            already registered under another logical file name.
        */

        IF EXISTS
        (
            SELECT 1
            FROM sys.database_files
            WHERE physical_name = @SalesLegacyPhysicalFile
        )
        BEGIN

            ;THROW 50011,
                N'The expected Sales legacy physical file path is already registered under another logical file.',
                1;

        END;


        SET @SalesFilegroupSql =
            N'ALTER DATABASE '
            + QUOTENAME(DB_NAME())
            + N'
    ADD FILE
    (
        NAME = '
            + QUOTENAME(@SalesLegacyLogicalFile, '''')
            + N',
        FILENAME = '
            + QUOTENAME(@SalesLegacyPhysicalFile, '''')
            + N',
        SIZE = 8MB,
        MAXSIZE = 256MB,
        FILEGROWTH = 8MB
    )
    TO FILEGROUP '
            + QUOTENAME(@SalesLegacyFilegroup)
            + N';';


        EXEC sys.sp_executesql
            @SalesFilegroupSql;


        PRINT N'        [+] Data file created              : '
            + @SalesLegacyLogicalFile;

        PRINT N'            Filegroup                      : '
            + @SalesLegacyFilegroup;

        PRINT N'            Physical File                  : '
            + @SalesLegacyPhysicalFile;

        PRINT N'            Initial Size                   : 8 MB';
        PRINT N'            Maximum Size                   : 256 MB';
        PRINT N'            File Growth                    : 8 MB';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Data file already exists       : '
            + @SalesLegacyLogicalFile;

    END;


    /*==============================================================================
        MONTHLY PARTITION FILEGROUPS
    ==============================================================================*/

    DECLARE @SalesPartitionSlot int = 1;

    DECLARE @SalesPartitionFilegroup sysname;
    DECLARE @SalesPartitionLogicalFile sysname;
    DECLARE @SalesPartitionPhysicalFile nvarchar(4000);

    PRINT N'';
    PRINT N'    Monthly partition filegroups';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';


    WHILE @SalesPartitionSlot <= 37
    BEGIN

        SET @SalesPartitionFilegroup =
            N'FG_SALES_PART_'
            + RIGHT(N'00' + CONVERT(nvarchar(2), @SalesPartitionSlot), 2);

        SET @SalesPartitionLogicalFile =
            N'AtlasCommerce_Sales_Part_'
            + RIGHT(N'00' + CONVERT(nvarchar(2), @SalesPartitionSlot), 2);

        SET @SalesPartitionPhysicalFile =
            @SalesPartitionDataPath
            + @SalesPartitionLogicalFile
            + N'.ndf';


        /*--------------------------------------------------------------------------
            FILEGROUP
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.filegroups
            WHERE name = @SalesPartitionFilegroup
        )
        BEGIN

            SET @SalesFilegroupSql =
                N'ALTER DATABASE '
                + QUOTENAME(DB_NAME())
                + N' ADD FILEGROUP '
                + QUOTENAME(@SalesPartitionFilegroup)
                + N';';


            EXEC sys.sp_executesql
                @SalesFilegroupSql;


            PRINT N'        [+] Filegroup created              : '
                + @SalesPartitionFilegroup;

        END
        ELSE
        BEGIN

            PRINT N'        [•] Filegroup already exists       : '
                + @SalesPartitionFilegroup;

        END;


        /*--------------------------------------------------------------------------
            DATA FILE
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.database_files
            WHERE name = @SalesPartitionLogicalFile
        )
        BEGIN

            /*
                Ensure that the expected physical path is not already registered
                under another logical file name.
            */

            IF EXISTS
            (
                SELECT 1
                FROM sys.database_files
                WHERE physical_name = @SalesPartitionPhysicalFile
            )
            BEGIN

                ;THROW 50012,
                    N'The expected Sales partition physical file path is already registered under another logical file.',
                    1;

            END;


            SET @SalesFilegroupSql =
                N'ALTER DATABASE '
                + QUOTENAME(DB_NAME())
                + N'
    ADD FILE
    (
        NAME = '
                + QUOTENAME(@SalesPartitionLogicalFile, '''')
                + N',
        FILENAME = '
                + QUOTENAME(@SalesPartitionPhysicalFile, '''')
                + N',
        SIZE = 8MB,
        MAXSIZE = 256MB,
        FILEGROWTH = 8MB
    )
    TO FILEGROUP '
                + QUOTENAME(@SalesPartitionFilegroup)
                + N';';


            EXEC sys.sp_executesql
                @SalesFilegroupSql;


            PRINT N'        [+] Data file created              : '
                + @SalesPartitionLogicalFile;

            PRINT N'            Filegroup                      : '
                + @SalesPartitionFilegroup;

            PRINT N'            Physical File                  : '
                + @SalesPartitionPhysicalFile;

            PRINT N'            Initial Size                   : 8 MB';
            PRINT N'            Maximum Size                   : 256 MB';
            PRINT N'            File Growth                    : 8 MB';

        END
        ELSE
        BEGIN

            PRINT N'        [•] Data file already exists       : '
                + @SalesPartitionLogicalFile;

        END;


        SET @SalesPartitionSlot += 1;

    END;

    /*==============================================================================
        FG_SALES_FUTURE
    ==============================================================================*/

    DECLARE @SalesFutureFilegroup sysname =
        N'FG_SALES_FUTURE';

    DECLARE @SalesFutureLogicalFile sysname =
        N'AtlasCommerce_Sales_Future';

    DECLARE @SalesFuturePhysicalFile nvarchar(4000) =
        @SalesPartitionDataPath
        + N'AtlasCommerce_Sales_Future.ndf';


    PRINT N'';
    PRINT N'    Future partition filegroup';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';


    /*------------------------------------------------------------------------------
        FILEGROUP
    ------------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = @SalesFutureFilegroup
    )
    BEGIN

        SET @SalesFilegroupSql =
            N'ALTER DATABASE '
            + QUOTENAME(DB_NAME())
            + N' ADD FILEGROUP '
            + QUOTENAME(@SalesFutureFilegroup)
            + N';';


        EXEC sys.sp_executesql
            @SalesFilegroupSql;


        PRINT N'        [+] Filegroup created              : '
            + @SalesFutureFilegroup;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Filegroup already exists       : '
            + @SalesFutureFilegroup;

    END;


    /*------------------------------------------------------------------------------
        DATA FILE
    ------------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.database_files
        WHERE name = @SalesFutureLogicalFile
    )
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM sys.database_files
            WHERE physical_name = @SalesFuturePhysicalFile
        )
        BEGIN

            ;THROW 50013,
                N'The expected Sales future physical file path is already registered under another logical file.',
                1;

        END;


        SET @SalesFilegroupSql =
            N'ALTER DATABASE '
            + QUOTENAME(DB_NAME())
            + N'
    ADD FILE
    (
        NAME = '
            + QUOTENAME(@SalesFutureLogicalFile, '''')
            + N',
        FILENAME = '
            + QUOTENAME(@SalesFuturePhysicalFile, '''')
            + N',
        SIZE = 8MB,
        MAXSIZE = 256MB,
        FILEGROWTH = 8MB
    )
    TO FILEGROUP '
            + QUOTENAME(@SalesFutureFilegroup)
            + N';';


        EXEC sys.sp_executesql
            @SalesFilegroupSql;


        PRINT N'        [+] Data file created              : '
            + @SalesFutureLogicalFile;

        PRINT N'            Filegroup                      : '
            + @SalesFutureFilegroup;

        PRINT N'            Physical File                  : '
            + @SalesFuturePhysicalFile;

        PRINT N'            Initial Size                   : 8 MB';
        PRINT N'            Maximum Size                   : 256 MB';
        PRINT N'            File Growth                    : 8 MB';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Data file already exists       : '
            + @SalesFutureLogicalFile;

    END;


    PRINT N'';

    PRINT N'';