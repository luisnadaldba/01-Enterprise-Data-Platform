    /*==============================================================================
        SALES PARTITION FUNCTION
    ==============================================================================*/

    DECLARE @SalesPartitionFunction sysname =
        N'PF_SALES_MONTHLY';

    DECLARE @SalesPartitionStartDate datetime2(0) =
        CONVERT(datetime2(0), N'2025-01-01T00:00:00');

    DECLARE @SalesPartitionEndDate datetime2(0) =
        CONVERT(datetime2(0), N'2028-01-01T00:00:00');

    DECLARE @SalesPartitionBoundary datetime2(0);

    DECLARE @SalesPartitionFunctionSql nvarchar(max);

    DECLARE @SalesPartitionBoundaryList nvarchar(max) =
        N'';


    PRINT N'    Sales partition function';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';


    /*==============================================================================
        PF_SALES_MONTHLY
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.partition_functions
        WHERE name = @SalesPartitionFunction
    )
    BEGIN

        SET @SalesPartitionBoundary =
            @SalesPartitionStartDate;


        WHILE @SalesPartitionBoundary <= @SalesPartitionEndDate
        BEGIN

            SET @SalesPartitionBoundaryList =
                @SalesPartitionBoundaryList
                + CASE
                    WHEN LEN(@SalesPartitionBoundaryList) > 0
                        THEN N', '
                    ELSE N''
                END
                + N''''
                + CONVERT
                (
                    nvarchar(19),
                    @SalesPartitionBoundary,
                    126
                )
                + N'''';


            SET @SalesPartitionBoundary =
                DATEADD
                (
                    MONTH,
                    1,
                    @SalesPartitionBoundary
                );

        END;


        SET @SalesPartitionFunctionSql =
            N'CREATE PARTITION FUNCTION '
            + QUOTENAME(@SalesPartitionFunction)
            + N' (datetime2(0))
    AS RANGE RIGHT
    FOR VALUES
    (
        '
            + @SalesPartitionBoundaryList
            + N'
    );';


        EXEC sys.sp_executesql
            @SalesPartitionFunctionSql;


        PRINT N'        [+] Partition function created     : '
            + @SalesPartitionFunction;

        PRINT N'            Data Type                      : datetime2(0)';
        PRINT N'            Range                          : RIGHT';
        PRINT N'            First Boundary                 : 2025-01-01 00:00:00';
        PRINT N'            Last Boundary                  : 2028-01-01 00:00:00';
        PRINT N'            Boundaries                     : 37';
        PRINT N'            Partitions                     : 38';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Partition function already exists : '
            + @SalesPartitionFunction;

    END;


    PRINT N'';