    PRINT N'    catalog.ProductVariantPrice';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        UNIQUE FILTERED INDEX: UX_PRDVP_open_period

        Business Rule:
            A ProductVariant may have historical closed price periods, but at most
            one open-ended price period.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : PRDVP_PRDVA_id ASC
            Included Columns  : NONE
            Filter            : PRDVP_valid_to IS NULL
            Filegroup         : FG_CORE

        Important:
            This index guarantees only one open-ended period per ProductVariant.
            It does not prevent overlap between closed temporal periods.
            Closed-period overlap is protected by the Temporal Integrity stage.
    ==============================================================================*/

    DECLARE @PRDVP_OP_expected_name                  sysname;
    DECLARE @PRDVP_OP_expected_exists                bit;
    DECLARE @PRDVP_OP_expected_is_equivalent         bit;

    DECLARE @PRDVP_OP_expected_type_desc             nvarchar(60);
    DECLARE @PRDVP_OP_expected_is_unique             bit;
    DECLARE @PRDVP_OP_expected_is_disabled           bit;
    DECLARE @PRDVP_OP_expected_has_filter            bit;
    DECLARE @PRDVP_OP_expected_filter_definition     nvarchar(4000);
    DECLARE @PRDVP_OP_expected_data_space_name       sysname;
    DECLARE @PRDVP_OP_expected_actual_keys           nvarchar(4000);
    DECLARE @PRDVP_OP_expected_actual_includes       nvarchar(4000);

    DECLARE @PRDVP_OP_equivalent_count               int;
    DECLARE @PRDVP_OP_equivalent_names               nvarchar(4000);
    DECLARE @PRDVP_OP_equivalent_details             nvarchar(4000);

    DECLARE @PRDVP_OP_actual_name                    sysname;
    DECLARE @PRDVP_OP_actual_is_disabled             bit;
    DECLARE @PRDVP_OP_actual_data_space_name         sysname;

    SET @PRDVP_OP_expected_name =
        N'UX_PRDVP_open_period';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantPrice', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Index dependency missing        : catalog.ProductVariantPrice';

        ;THROW 50510,
            N'Index UX_PRDVP_open_period cannot be deployed because catalog.ProductVariantPrice does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariantPrice', N'PRDVP_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : PRDVP_PRDVA_id';

        ;THROW 50511,
            N'Index UX_PRDVP_open_period cannot be deployed because PRDVP_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariantPrice', N'PRDVP_valid_to') IS NULL
    BEGIN

        PRINT N'        [X] Index filter column missing     : PRDVP_valid_to';

        ;THROW 50512,
            N'Index UX_PRDVP_open_period cannot be deployed because PRDVP_valid_to does not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Index filegroup missing         : FG_CORE';

        ;THROW 50513,
            N'Index UX_PRDVP_open_period cannot be deployed because FG_CORE does not exist.',
            1;

    END;


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES
    ==============================================================================*/

    DECLARE @PRDVP_OP_equivalent_indexes TABLE
    (
        index_name         sysname         NOT NULL,
        is_disabled       bit             NOT NULL,
        data_space_name   sysname         NULL,
        filter_definition nvarchar(4000)  NULL
    );


    INSERT INTO @PRDVP_OP_equivalent_indexes
    (
        index_name,
        is_disabled,
        data_space_name,
        filter_definition
    )
    SELECT
        i.name,
        i.is_disabled,
        ds.name,
        i.filter_definition

    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND i.type = 2
    AND i.is_unique = 1
    AND i.is_primary_key = 0
    AND i.is_unique_constraint = 0
    AND i.is_hypothetical = 0
    AND i.has_filter = 1

    AND
    (
        SELECT COUNT(*)
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal > 0
    ) = 1

    AND EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal = 1
        AND ic.is_descending_key = 0
        AND c.name = N'PRDVP_PRDVA_id'
    )

    AND NOT EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
    )

    AND LOWER
    (
        REPLACE
        (
            REPLACE
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE
                            (
                                i.filter_definition,
                                N'[',
                                N''
                            ),
                            N']',
                            N''
                        ),
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                ),
                N' ',
                N''
            ),
            NCHAR(9),
            N''
        )
    ) = N'prdvp_valid_toisnull';


    SELECT
        @PRDVP_OP_equivalent_count = COUNT(*)
    FROM @PRDVP_OP_equivalent_indexes;


    SELECT
        @PRDVP_OP_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @PRDVP_OP_equivalent_indexes;


    SELECT
        @PRDVP_OP_equivalent_details =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                    + N' ['
                    + COALESCE(data_space_name, N'<UNKNOWN>')
                    + N']'
                    + CASE
                        WHEN is_disabled = 1 THEN N' [DISABLED]'
                        ELSE N''
                      END
                ),
                N', '
            )
    FROM @PRDVP_OP_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @PRDVP_OP_expected_exists = 0;
    SET @PRDVP_OP_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_OP_expected_name
    )
    BEGIN

        SET @PRDVP_OP_expected_exists = 1;


        SELECT
            @PRDVP_OP_expected_type_desc = i.type_desc,
            @PRDVP_OP_expected_is_unique = i.is_unique,
            @PRDVP_OP_expected_is_disabled = i.is_disabled,
            @PRDVP_OP_expected_has_filter = i.has_filter,
            @PRDVP_OP_expected_filter_definition = i.filter_definition,
            @PRDVP_OP_expected_data_space_name = ds.name
        FROM sys.indexes AS i
        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_OP_expected_name;


        SELECT
            @PRDVP_OP_expected_actual_keys =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),
                        c.name
                        + CASE
                            WHEN ic.is_descending_key = 1 THEN N' DESC'
                            ELSE N' ASC'
                          END
                    ),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.indexes AS i
        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_OP_expected_name;


        SELECT
            @PRDVP_OP_expected_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.index_column_id)
        FROM sys.indexes AS i
        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_OP_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @PRDVP_OP_equivalent_indexes
            WHERE index_name = @PRDVP_OP_expected_name
        )
        BEGIN

            SET @PRDVP_OP_expected_is_equivalent = 1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @PRDVP_OP_expected_exists = 1
    AND @PRDVP_OP_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : UX_PRDVP_open_period';
        PRINT N'            Expected Type                   : NONCLUSTERED';
        PRINT N'            Actual Type                     : '
            + COALESCE(@PRDVP_OP_expected_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique                 : 1';
        PRINT N'            Actual Unique                   : '
            + COALESCE(CONVERT(nvarchar(1), @PRDVP_OP_expected_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns            : PRDVP_PRDVA_id ASC';
        PRINT N'            Actual Key Columns              : '
            + COALESCE(@PRDVP_OP_expected_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns       : NONE';
        PRINT N'            Actual Included Columns         : '
            + COALESCE(@PRDVP_OP_expected_actual_includes, N'NONE');
        PRINT N'            Expected Filter                 : PRDVP_valid_to IS NULL';
        PRINT N'            Actual Filter                   : '
            + COALESCE(@PRDVP_OP_expected_filter_definition, N'<NONE>');
        PRINT N'            Expected Filegroup              : FG_CORE';
        PRINT N'            Actual Data Space               : '
            + COALESCE(@PRDVP_OP_expected_data_space_name, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50514,
            N'Index UX_PRDVP_open_period exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @PRDVP_OP_expected_exists = 0
    AND @PRDVP_OP_equivalent_count = 0
    BEGIN

        IF EXISTS
        (
            SELECT
                PRDVP_PRDVA_id
            FROM catalog.ProductVariantPrice
            WHERE PRDVP_valid_to IS NULL
            GROUP BY PRDVP_PRDVA_id
            HAVING COUNT(*) > 1
        )
        BEGIN

            PRINT N'        [X] Existing data violates open price period uniqueness';
            PRINT N'            Rule                           : Maximum one open-ended price period per ProductVariant';
            PRINT N'            Filter                         : PRDVP_valid_to IS NULL';
            PRINT N'            Index was not created. Data correction is required.';

            ;THROW 50515,
                N'UX_PRDVP_open_period cannot be created because existing data contains multiple open-ended price periods for the same ProductVariant.',
                1;

        END;


        CREATE UNIQUE NONCLUSTERED INDEX UX_PRDVP_open_period
            ON catalog.ProductVariantPrice
            (
                PRDVP_PRDVA_id ASC
            )
            WHERE PRDVP_valid_to IS NULL
            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_PRDVP_open_period';
        PRINT N'            Key Columns                    : PRDVP_PRDVA_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : YES';
        PRINT N'            Filter                         : PRDVP_valid_to IS NULL';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @PRDVP_OP_equivalent_count = 1
    BEGIN

        SELECT
            @PRDVP_OP_actual_name = index_name,
            @PRDVP_OP_actual_is_disabled = is_disabled,
            @PRDVP_OP_actual_data_space_name = data_space_name
        FROM @PRDVP_OP_equivalent_indexes;


        IF @PRDVP_OP_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Unique filtered index disabled : '
                + @PRDVP_OP_actual_name;
            PRINT N'            Expected Name                  : UX_PRDVP_open_period';
            PRINT N'            Key Columns                    : PRDVP_PRDVA_id';
            PRINT N'            Filter                         : PRDVP_valid_to IS NULL';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PRDVP_OP_actual_name <> @PRDVP_OP_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';
            PRINT N'            Expected                       : UX_PRDVP_open_period';
            PRINT N'            Actual                         : ' + @PRDVP_OP_actual_name;
            PRINT N'            Action                         : Preserve existing index';

        END

        ELSE IF @PRDVP_OP_actual_data_space_name <> N'FG_CORE'
        BEGIN

            PRINT N'        [X] Index filegroup mismatch        : UX_PRDVP_open_period';
            PRINT N'            Expected Filegroup             : FG_CORE';
            PRINT N'            Actual Data Space              : '
                + COALESCE(@PRDVP_OP_actual_data_space_name, N'<UNKNOWN>');

            ;THROW 50516,
                N'Index UX_PRDVP_open_period is not stored on FG_CORE.',
                1;

        END

        ELSE
        BEGIN

            PRINT N'        [•] Unique filtered index validated: UX_PRDVP_open_period';
            PRINT N'            Key Columns                    : PRDVP_PRDVA_id';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : YES';
            PRINT N'            Filter                         : PRDVP_valid_to IS NULL';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @PRDVP_OP_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT(nvarchar(10), @PRDVP_OP_equivalent_count);
        PRINT N'            Expected Index                  : UX_PRDVP_open_period';
        PRINT N'            Equivalent Indexes              : '
            + COALESCE(@PRDVP_OP_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement              : '
            + COALESCE(@PRDVP_OP_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                          : Preserve all indexes for manual review';
        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    /*==============================================================================
        INDEX: IX_PRDVP_PRDVA_valid_from

        Purpose:
            Support temporal price lookup and historical navigation for a
            ProductVariant.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : PRDVP_PRDVA_id ASC,
                                PRDVP_valid_from DESC
            Included Columns  : PRDVP_valid_to,
                                PRDVP_price
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @PRDVP_HST_expected_name                sysname;
    DECLARE @PRDVP_HST_expected_exists              bit;
    DECLARE @PRDVP_HST_expected_is_equivalent       bit;

    DECLARE @PRDVP_HST_expected_type_desc           nvarchar(60);
    DECLARE @PRDVP_HST_expected_is_unique           bit;
    DECLARE @PRDVP_HST_expected_is_disabled         bit;
    DECLARE @PRDVP_HST_expected_has_filter          bit;
    DECLARE @PRDVP_HST_expected_data_space_name     sysname;
    DECLARE @PRDVP_HST_expected_actual_keys         nvarchar(4000);
    DECLARE @PRDVP_HST_expected_actual_includes     nvarchar(4000);

    DECLARE @PRDVP_HST_equivalent_count             int;
    DECLARE @PRDVP_HST_equivalent_names             nvarchar(4000);
    DECLARE @PRDVP_HST_equivalent_details           nvarchar(4000);

    DECLARE @PRDVP_HST_actual_name                  sysname;
    DECLARE @PRDVP_HST_actual_is_disabled           bit;
    DECLARE @PRDVP_HST_actual_data_space_name       sysname;


    SET @PRDVP_HST_expected_name =
        N'IX_PRDVP_PRDVA_valid_from';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF COL_LENGTH(N'catalog.ProductVariantPrice', N'PRDVP_valid_from') IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : PRDVP_valid_from';

        ;THROW 50520,
            N'Index IX_PRDVP_PRDVA_valid_from cannot be deployed because PRDVP_valid_from does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariantPrice', N'PRDVP_price') IS NULL
    OR COL_LENGTH(N'catalog.ProductVariantPrice', N'PRDVP_valid_to') IS NULL
    BEGIN

        PRINT N'        [X] Included index column missing   : PRDVP_price / PRDVP_valid_to';

        ;THROW 50521,
            N'Index IX_PRDVP_PRDVA_valid_from cannot be deployed because required INCLUDE columns do not exist.',
            1;

    END;


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES
    ==============================================================================*/

    DECLARE @PRDVP_HST_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @PRDVP_HST_equivalent_indexes
    (
        index_name,
        is_disabled,
        data_space_name
    )
    SELECT
        i.name,
        i.is_disabled,
        ds.name

    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND i.type = 2
    AND i.is_unique = 0
    AND i.is_primary_key = 0
    AND i.is_unique_constraint = 0
    AND i.is_hypothetical = 0
    AND i.has_filter = 0

    AND
    (
        SELECT COUNT(*)
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal > 0
    ) = 2

    AND EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal = 1
        AND ic.is_descending_key = 0
        AND c.name = N'PRDVP_PRDVA_id'
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal = 2
        AND ic.is_descending_key = 1
        AND c.name = N'PRDVP_valid_from'
    )

    AND
    (
        SELECT COUNT(*)
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
    ) = 2

    AND EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
        AND c.name = N'PRDVP_valid_to'
    )

    AND EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
        AND c.name = N'PRDVP_price'
    );


    SELECT
        @PRDVP_HST_equivalent_count = COUNT(*)
    FROM @PRDVP_HST_equivalent_indexes;


    SELECT
        @PRDVP_HST_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @PRDVP_HST_equivalent_indexes;


    SELECT
        @PRDVP_HST_equivalent_details =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                    + N' ['
                    + COALESCE(data_space_name, N'<UNKNOWN>')
                    + N']'
                    + CASE
                        WHEN is_disabled = 1 THEN N' [DISABLED]'
                        ELSE N''
                      END
                ),
                N', '
            )
    FROM @PRDVP_HST_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @PRDVP_HST_expected_exists = 0;
    SET @PRDVP_HST_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_HST_expected_name
    )
    BEGIN

        SET @PRDVP_HST_expected_exists = 1;


        SELECT
            @PRDVP_HST_expected_type_desc = i.type_desc,
            @PRDVP_HST_expected_is_unique = i.is_unique,
            @PRDVP_HST_expected_is_disabled = i.is_disabled,
            @PRDVP_HST_expected_has_filter = i.has_filter,
            @PRDVP_HST_expected_data_space_name = ds.name
        FROM sys.indexes AS i
        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_HST_expected_name;


        SELECT
            @PRDVP_HST_expected_actual_keys =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),
                        c.name
                        + CASE
                            WHEN ic.is_descending_key = 1 THEN N' DESC'
                            ELSE N' ASC'
                          END
                    ),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.indexes AS i
        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_HST_expected_name;


        SELECT
            @PRDVP_HST_expected_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP (ORDER BY c.name)
        FROM sys.indexes AS i
        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1
        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE i.object_id = OBJECT_ID(N'catalog.ProductVariantPrice')
        AND i.name = @PRDVP_HST_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @PRDVP_HST_equivalent_indexes
            WHERE index_name = @PRDVP_HST_expected_name
        )
        BEGIN

            SET @PRDVP_HST_expected_is_equivalent = 1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @PRDVP_HST_expected_exists = 1
    AND @PRDVP_HST_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : IX_PRDVP_PRDVA_valid_from';
        PRINT N'            Expected Type                   : NONCLUSTERED';
        PRINT N'            Actual Type                     : '
            + COALESCE(@PRDVP_HST_expected_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique                 : 0';
        PRINT N'            Actual Unique                   : '
            + COALESCE(CONVERT(nvarchar(1), @PRDVP_HST_expected_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns            : PRDVP_PRDVA_id ASC, PRDVP_valid_from DESC';
        PRINT N'            Actual Key Columns              : '
            + COALESCE(@PRDVP_HST_expected_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns       : PRDVP_price, PRDVP_valid_to';
        PRINT N'            Actual Included Columns         : '
            + COALESCE(@PRDVP_HST_expected_actual_includes, N'NONE');
        PRINT N'            Expected Filter                 : NONE';
        PRINT N'            Actual Has Filter               : '
            + COALESCE(CONVERT(nvarchar(1), @PRDVP_HST_expected_has_filter), N'<UNKNOWN>');
        PRINT N'            Expected Filegroup              : FG_CORE';
        PRINT N'            Actual Data Space               : '
            + COALESCE(@PRDVP_HST_expected_data_space_name, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50522,
            N'Index IX_PRDVP_PRDVA_valid_from exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @PRDVP_HST_expected_exists = 0
    AND @PRDVP_HST_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_PRDVP_PRDVA_valid_from
            ON catalog.ProductVariantPrice
            (
                PRDVP_PRDVA_id ASC,
                PRDVP_valid_from DESC
            )
            INCLUDE
            (
                PRDVP_valid_to,
                PRDVP_price
            )
            ON FG_CORE;


        PRINT N'        [+] Index added                    : IX_PRDVP_PRDVA_valid_from';
        PRINT N'            Key Columns                    : PRDVP_PRDVA_id ASC, PRDVP_valid_from DESC';
        PRINT N'            Included Columns               : PRDVP_valid_to, PRDVP_price';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @PRDVP_HST_equivalent_count = 1
    BEGIN

        SELECT
            @PRDVP_HST_actual_name = index_name,
            @PRDVP_HST_actual_is_disabled = is_disabled,
            @PRDVP_HST_actual_data_space_name = data_space_name
        FROM @PRDVP_HST_equivalent_indexes;


        IF @PRDVP_HST_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Index disabled                 : '
                + @PRDVP_HST_actual_name;
            PRINT N'            Expected Name                  : IX_PRDVP_PRDVA_valid_from';
            PRINT N'            Key Columns                    : PRDVP_PRDVA_id ASC, PRDVP_valid_from DESC';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PRDVP_HST_actual_name <> @PRDVP_HST_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';
            PRINT N'            Expected                       : IX_PRDVP_PRDVA_valid_from';
            PRINT N'            Actual                         : ' + @PRDVP_HST_actual_name;
            PRINT N'            Action                         : Preserve existing index';

        END

        ELSE IF @PRDVP_HST_actual_data_space_name <> N'FG_CORE'
        BEGIN

            PRINT N'        [X] Index filegroup mismatch        : IX_PRDVP_PRDVA_valid_from';
            PRINT N'            Expected Filegroup             : FG_CORE';
            PRINT N'            Actual Data Space              : '
                + COALESCE(@PRDVP_HST_actual_data_space_name, N'<UNKNOWN>');

            ;THROW 50523,
                N'Index IX_PRDVP_PRDVA_valid_from is not stored on FG_CORE.',
                1;

        END

        ELSE
        BEGIN

            PRINT N'        [•] Index validated                : IX_PRDVP_PRDVA_valid_from';
            PRINT N'            Key Columns                    : PRDVP_PRDVA_id ASC, PRDVP_valid_from DESC';
            PRINT N'            Included Columns               : PRDVP_valid_to, PRDVP_price';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @PRDVP_HST_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT(nvarchar(10), @PRDVP_HST_equivalent_count);
        PRINT N'            Expected Index                  : IX_PRDVP_PRDVA_valid_from';
        PRINT N'            Equivalent Indexes              : '
            + COALESCE(@PRDVP_HST_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement              : '
            + COALESCE(@PRDVP_HST_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                          : Preserve all indexes for manual review';
        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    PRINT N'';