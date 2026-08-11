    /*==============================================================================
        SALES PARTITION SCHEME
    ==============================================================================*/

    DECLARE @SalesPartitionScheme sysname =
        N'PS_SALES_MONTHLY';

    DECLARE @SalesSchemePartitionFunction sysname =
        N'PF_SALES_MONTHLY';

    DECLARE @SalesSchemeSql nvarchar(max);
    DECLARE @SalesSchemeFilegroupList nvarchar(max);

    DECLARE @SalesSchemeSlot int = 1;
    DECLARE @SalesSchemeFilegroup sysname;


    PRINT N'    Sales partition scheme';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';


    /*==============================================================================
        PS_SALES_MONTHLY
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.partition_schemes
        WHERE name = @SalesPartitionScheme
    )
    BEGIN

        /*--------------------------------------------------------------------------
            BUILD FILEGROUP MAPPING

            Partition 01  -> FG_SALES_LEGACY
            Partition 02  -> FG_SALES_PART_01
            ...
            Partition 37  -> FG_SALES_PART_36
            Partition 38  -> FG_SALES_FUTURE

            Unassigned    -> FG_SALES_PART_37
                            Automatically becomes NEXT USED.
        --------------------------------------------------------------------------*/

        SET @SalesSchemeFilegroupList =
            QUOTENAME(N'FG_SALES_LEGACY');


        WHILE @SalesSchemeSlot <= 36
        BEGIN

            SET @SalesSchemeFilegroup =
                N'FG_SALES_PART_'
                + RIGHT
                (
                    N'00'
                    + CONVERT
                        (
                            nvarchar(2),
                            @SalesSchemeSlot
                        ),
                    2
                );


            SET @SalesSchemeFilegroupList =
                @SalesSchemeFilegroupList
                + N', '
                + QUOTENAME(@SalesSchemeFilegroup);


            SET @SalesSchemeSlot =
                @SalesSchemeSlot + 1;

        END;


        SET @SalesSchemeFilegroupList =
            @SalesSchemeFilegroupList
            + N', '
            + QUOTENAME(N'FG_SALES_FUTURE')
            + N', '
            + QUOTENAME(N'FG_SALES_PART_37');


        /*--------------------------------------------------------------------------
            CREATE PARTITION SCHEME
        --------------------------------------------------------------------------*/

        SET @SalesSchemeSql =
            N'CREATE PARTITION SCHEME '
            + QUOTENAME(@SalesPartitionScheme)
            + N'
    AS PARTITION '
            + QUOTENAME(@SalesSchemePartitionFunction)
            + N'
    TO
    (
        '
            + @SalesSchemeFilegroupList
            + N'
    );';


        EXEC sys.sp_executesql
            @SalesSchemeSql;


        PRINT N'        [+] Partition scheme created       : '
            + @SalesPartitionScheme;

        PRINT N'            Partition Function             : '
            + @SalesSchemePartitionFunction;

        PRINT N'            Partition 01                   : FG_SALES_LEGACY';

        PRINT N'            Monthly Partitions             : FG_SALES_PART_01 -> FG_SALES_PART_36';

        PRINT N'            Partition 38                   : FG_SALES_FUTURE';

        PRINT N'            NEXT USED                      : FG_SALES_PART_37';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Partition scheme already exists : '
            + @SalesPartitionScheme;

    END;


    PRINT N'';