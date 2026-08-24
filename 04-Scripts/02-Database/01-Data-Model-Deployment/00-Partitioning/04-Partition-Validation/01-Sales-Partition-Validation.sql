    /*==============================================================================
        SALES PARTITION VALIDATION
    ==============================================================================*/

    DECLARE @SalesValidationErrors int = 0;

    DECLARE @SalesValidationFilegroupsStatus       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationDataFilesStatus        nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationFileConfigStatus       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationFunctionStatus         nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationBoundariesStatus       nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationSchemeStatus           nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationMappingStatus          nvarchar(20) = N'NOT VALIDATED';
    DECLARE @SalesValidationNextUsedStatus         nvarchar(20) = N'NOT VALIDATED';


    PRINT N'';
    PRINT N'    ● Sales partition validation';
    PRINT N'';


    /*==============================================================================
        EXPECTED FILEGROUP / DATA FILE DEFINITIONS
    ==============================================================================*/

    DECLARE @SalesValidationExpectedStorage TABLE
    (
        STG_id                 tinyint IDENTITY(1,1) NOT NULL,
        STG_filegroup_name     sysname               NOT NULL,
        STG_logical_file_name  sysname               NOT NULL,
        STG_physical_file_name nvarchar(4000)        NOT NULL
    );


    INSERT INTO @SalesValidationExpectedStorage
    (
        STG_filegroup_name,
        STG_logical_file_name,
        STG_physical_file_name
    )
    VALUES
    (
        N'FG_SALES_LEGACY',
        N'AtlasCommerce_Sales_Legacy',
        @SalesPartitionDataPath + N'AtlasCommerce_Sales_Legacy.ndf'
    );


    DECLARE @SalesValidationStorageSlot int = 1;

    WHILE @SalesValidationStorageSlot <= 37
    BEGIN

        INSERT INTO @SalesValidationExpectedStorage
        (
            STG_filegroup_name,
            STG_logical_file_name,
            STG_physical_file_name
        )
        VALUES
        (
            N'FG_SALES_PART_'
                + RIGHT
                (
                    N'00'
                    + CONVERT(nvarchar(2), @SalesValidationStorageSlot),
                    2
                ),

            N'AtlasCommerce_Sales_Part_'
                + RIGHT
                (
                    N'00'
                    + CONVERT(nvarchar(2), @SalesValidationStorageSlot),
                    2
                ),

            @SalesPartitionDataPath
                + N'AtlasCommerce_Sales_Part_'
                + RIGHT
                (
                    N'00'
                    + CONVERT(nvarchar(2), @SalesValidationStorageSlot),
                    2
                )
                + N'.ndf'
        );


        SET @SalesValidationStorageSlot =
            @SalesValidationStorageSlot + 1;

    END;


    INSERT INTO @SalesValidationExpectedStorage
    (
        STG_filegroup_name,
        STG_logical_file_name,
        STG_physical_file_name
    )
    VALUES
    (
        N'FG_SALES_FUTURE',
        N'AtlasCommerce_Sales_Future',
        @SalesPartitionDataPath + N'AtlasCommerce_Sales_Future.ndf'
    );


    /*==============================================================================
        FILEGROUP VALIDATION

        Expected:
            FG_SALES_LEGACY
            FG_SALES_PART_01 ... FG_SALES_PART_37
            FG_SALES_FUTURE
    ==============================================================================*/

    DECLARE @SalesValidationInvalidFilegroups int = 0;


    SELECT
        @SalesValidationInvalidFilegroups =
            COUNT(*)

    FROM @SalesValidationExpectedStorage AS expected

    LEFT JOIN sys.filegroups AS actual
        ON actual.name = expected.STG_filegroup_name

    WHERE actual.data_space_id IS NULL
    OR actual.type_desc <> N'ROWS_FILEGROUP';


    IF @SalesValidationInvalidFilegroups = 0
    BEGIN
        SET @SalesValidationFilegroupsStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationFilegroupsStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        DATA FILE VALIDATION

        Each partition filegroup must contain exactly one expected data file.
    ==============================================================================*/

    DECLARE @SalesValidationInvalidDataFiles int = 0;


    SELECT
        @SalesValidationInvalidDataFiles =
            COUNT(*)

    FROM @SalesValidationExpectedStorage AS expected

    LEFT JOIN sys.filegroups AS fg
        ON fg.name = expected.STG_filegroup_name

    LEFT JOIN sys.database_files AS df
        ON  df.data_space_id = fg.data_space_id
        AND df.name = expected.STG_logical_file_name

    WHERE df.file_id IS NULL
    OR df.physical_name COLLATE Latin1_General_100_BIN2
            <>
        expected.STG_physical_file_name COLLATE Latin1_General_100_BIN2;


    DECLARE @SalesValidationFilegroupWithWrongCount int = 0;


    SELECT
        @SalesValidationFilegroupWithWrongCount =
            COUNT(*)
    FROM
    (
        SELECT
            expected.STG_filegroup_name,
            COUNT(df.file_id) AS file_count

        FROM @SalesValidationExpectedStorage AS expected

        LEFT JOIN sys.filegroups AS fg
            ON fg.name = expected.STG_filegroup_name

        LEFT JOIN sys.database_files AS df
            ON df.data_space_id = fg.data_space_id

        GROUP BY
            expected.STG_filegroup_name

        HAVING COUNT(df.file_id) <> 1
    ) AS invalid_filegroups;


    IF @SalesValidationInvalidDataFiles = 0
    AND @SalesValidationFilegroupWithWrongCount = 0
    BEGIN
        SET @SalesValidationDataFilesStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationDataFilesStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        FILE CONFIGURATION VALIDATION

        Laboratory policy:
            Initial allocation : at least 8 MB
            Maximum size       : 256 MB
            Fixed growth       : 8 MB
            Percent growth     : disabled

        Current size is allowed to exceed 8 MB after data growth.
    ==============================================================================*/

    DECLARE @SalesValidationInvalidFileConfig int = 0;


    SELECT
        @SalesValidationInvalidFileConfig =
            COUNT(*)

    FROM @SalesValidationExpectedStorage AS expected

    INNER JOIN sys.filegroups AS fg
        ON fg.name = expected.STG_filegroup_name

    INNER JOIN sys.database_files AS df
        ON  df.data_space_id = fg.data_space_id
        AND df.name = expected.STG_logical_file_name

    WHERE
        CAST(df.size * 8.0 / 1024 AS decimal(18,2)) < 8.00

        OR CAST(df.max_size * 8.0 / 1024 AS decimal(18,2)) <> 256.00

        OR df.is_percent_growth <> 0

        OR CAST(df.growth * 8.0 / 1024 AS decimal(18,2)) <> 8.00;


    IF @SalesValidationInvalidFileConfig = 0
    BEGIN
        SET @SalesValidationFileConfigStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationFileConfigStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        PARTITION FUNCTION VALIDATION

        Expected:
            PF_SALES_MONTHLY
            datetime2(0)
            RANGE RIGHT
            fanout = 38
    ==============================================================================*/

    DECLARE @SalesValidationFunctionId int;
    DECLARE @SalesValidationFunctionFanout int;
    DECLARE @SalesValidationBoundaryOnRight bit;
    DECLARE @SalesValidationFunctionType sysname;
    DECLARE @SalesValidationFunctionScale tinyint;


    SELECT
        @SalesValidationFunctionId =
            pf.function_id,

        @SalesValidationFunctionFanout =
            pf.fanout,

        @SalesValidationBoundaryOnRight =
            pf.boundary_value_on_right,

        @SalesValidationFunctionType =
            TYPE_NAME(pp.user_type_id),

        @SalesValidationFunctionScale =
            pp.scale

    FROM sys.partition_functions AS pf

    INNER JOIN sys.partition_parameters AS pp
        ON pp.function_id = pf.function_id

    WHERE pf.name = N'PF_SALES_MONTHLY';


    IF @SalesValidationFunctionId IS NOT NULL
    AND @SalesValidationFunctionFanout = 38
    AND @SalesValidationBoundaryOnRight = 1
    AND @SalesValidationFunctionType = N'datetime2'
    AND @SalesValidationFunctionScale = 0
    BEGIN
        SET @SalesValidationFunctionStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationFunctionStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        PARTITION BOUNDARY VALIDATION

        Expected:
            37 monthly boundaries
            2025-01-01 through 2028-01-01
            no missing or unexpected month
    ==============================================================================*/

    DECLARE @SalesValidationExpectedBoundaries TABLE
    (
        BND_boundary_id    int          NOT NULL,
        BND_boundary_value datetime2(0) NOT NULL
    );


    DECLARE @SalesValidationBoundaryId int = 1;
    DECLARE @SalesValidationBoundaryDate datetime2(0) =
        CONVERT(datetime2(0), N'2025-01-01T00:00:00');


    WHILE @SalesValidationBoundaryId <= 37
    BEGIN

        INSERT INTO @SalesValidationExpectedBoundaries
        (
            BND_boundary_id,
            BND_boundary_value
        )
        VALUES
        (
            @SalesValidationBoundaryId,
            @SalesValidationBoundaryDate
        );


        SET @SalesValidationBoundaryId =
            @SalesValidationBoundaryId + 1;

        SET @SalesValidationBoundaryDate =
            DATEADD
            (
                MONTH,
                1,
                @SalesValidationBoundaryDate
            );

    END;


    DECLARE @SalesValidationBoundaryMismatch int = 0;


    SELECT
        @SalesValidationBoundaryMismatch =
            COUNT(*)

    FROM @SalesValidationExpectedBoundaries AS expected

    FULL OUTER JOIN
    (
        SELECT
            prv.boundary_id,
            CONVERT(datetime2(0), prv.value) AS boundary_value

        FROM sys.partition_range_values AS prv

        WHERE prv.function_id =
            @SalesValidationFunctionId

    ) AS actual

        ON actual.boundary_id =
            expected.BND_boundary_id

    WHERE expected.BND_boundary_id IS NULL
    OR actual.boundary_id IS NULL
    OR actual.boundary_value <> expected.BND_boundary_value;


    IF @SalesValidationBoundaryMismatch = 0
    BEGIN
        SET @SalesValidationBoundariesStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationBoundariesStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        PARTITION SCHEME VALIDATION
    ==============================================================================*/

    DECLARE @SalesValidationSchemeDataSpaceId int;
    DECLARE @SalesValidationSchemeFunctionId int;


    SELECT
        @SalesValidationSchemeDataSpaceId =
            ps.data_space_id,

        @SalesValidationSchemeFunctionId =
            ps.function_id

    FROM sys.partition_schemes AS ps

    WHERE ps.name = N'PS_SALES_MONTHLY';


    IF @SalesValidationSchemeDataSpaceId IS NOT NULL
    AND @SalesValidationSchemeFunctionId = @SalesValidationFunctionId
    BEGIN
        SET @SalesValidationSchemeStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationSchemeStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        EXPECTED PARTITION SCHEME MAPPING
    ==============================================================================*/

    DECLARE @SalesValidationExpectedMapping TABLE
    (
        MAP_destination_id int     NOT NULL,
        MAP_filegroup_name sysname NOT NULL
    );


    INSERT INTO @SalesValidationExpectedMapping
    (
        MAP_destination_id,
        MAP_filegroup_name
    )
    VALUES
    (
        1,
        N'FG_SALES_LEGACY'
    );


    DECLARE @SalesValidationMappingSlot int = 1;


    WHILE @SalesValidationMappingSlot <= 36
    BEGIN

        INSERT INTO @SalesValidationExpectedMapping
        (
            MAP_destination_id,
            MAP_filegroup_name
        )
        VALUES
        (
            @SalesValidationMappingSlot + 1,

            N'FG_SALES_PART_'
                + RIGHT
                (
                    N'00'
                    + CONVERT
                        (
                            nvarchar(2),
                            @SalesValidationMappingSlot
                        ),
                    2
                )
        );


        SET @SalesValidationMappingSlot =
            @SalesValidationMappingSlot + 1;

    END;


    INSERT INTO @SalesValidationExpectedMapping
    (
        MAP_destination_id,
        MAP_filegroup_name
    )
    VALUES
        (38, N'FG_SALES_FUTURE'),
        (39, N'FG_SALES_PART_37');


    /*==============================================================================
        PARTITION MAPPING VALIDATION

        Destinations 1-38 represent the current 38 logical partitions.
    ==============================================================================*/

    DECLARE @SalesValidationMappingMismatch int = 0;


    SELECT
        @SalesValidationMappingMismatch =
            COUNT(*)

    FROM @SalesValidationExpectedMapping AS expected

    FULL OUTER JOIN
    (
        SELECT
            dds.destination_id,
            fg.name AS filegroup_name

        FROM sys.destination_data_spaces AS dds

        INNER JOIN sys.filegroups AS fg
            ON fg.data_space_id = dds.data_space_id

        WHERE dds.partition_scheme_id =
            @SalesValidationSchemeDataSpaceId

    ) AS actual

        ON actual.destination_id =
            expected.MAP_destination_id

    WHERE expected.MAP_destination_id IS NULL
    OR actual.destination_id IS NULL
    OR actual.filegroup_name COLLATE Latin1_General_100_BIN2
            <>
        expected.MAP_filegroup_name COLLATE Latin1_General_100_BIN2;


    IF @SalesValidationMappingMismatch = 0
    BEGIN
        SET @SalesValidationMappingStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationMappingStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        NEXT USED VALIDATION

        The partition function currently exposes 38 logical partitions.

        Destination 39 is therefore the additional filegroup reserved for the
        next SPLIT operation.
    ==============================================================================*/

    IF EXISTS
    (
        SELECT 1
        FROM sys.destination_data_spaces AS dds

        INNER JOIN sys.filegroups AS fg
            ON fg.data_space_id = dds.data_space_id

        WHERE dds.partition_scheme_id =
                @SalesValidationSchemeDataSpaceId

        AND dds.destination_id =
                @SalesValidationFunctionFanout + 1

        AND fg.name =
                N'FG_SALES_PART_37'
    )
    BEGIN
        SET @SalesValidationNextUsedStatus = N'VALID';
    END
    ELSE
    BEGIN
        SET @SalesValidationNextUsedStatus = N'FAILED';
        SET @SalesValidationErrors = @SalesValidationErrors + 1;
    END;


    /*==============================================================================
        FINAL STATE
    ==============================================================================*/

    PRINT N'    PARTITION FINAL STATE';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'        Filegroups                     : '
        + @SalesValidationFilegroupsStatus;

    PRINT N'        Data Files                     : '
        + @SalesValidationDataFilesStatus;

    PRINT N'        File Configuration             : '
        + @SalesValidationFileConfigStatus;

    PRINT N'        Partition Function             : '
        + @SalesValidationFunctionStatus;

    PRINT N'        Boundary Sequence              : '
        + @SalesValidationBoundariesStatus;

    PRINT N'        Partition Scheme               : '
        + @SalesValidationSchemeStatus;

    PRINT N'        Partition Mapping              : '
        + @SalesValidationMappingStatus;

    PRINT N'        NEXT USED                      : '
        + @SalesValidationNextUsedStatus;


    PRINT N'';


    IF @SalesValidationErrors = 0
    BEGIN

        PRINT N'        Result                         : PASSED';

    END
    ELSE
    BEGIN

        PRINT N'        Result                         : FAILED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';


    /*==============================================================================
        PARTITION INFRASTRUCTURE GATE

        Partitioning executes outside the transactional data-model deployment.

        Any detected divergence must stop deployment before BEGIN TRANSACTION.
    ==============================================================================*/

    IF @SalesValidationErrors > 0
    BEGIN

        ;THROW 50020,
            N'Sales partition infrastructure validation failed.',
            1;

    END;