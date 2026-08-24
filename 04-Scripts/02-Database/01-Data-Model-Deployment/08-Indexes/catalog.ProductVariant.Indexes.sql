    PRINT N'';
    PRINT N'    ● catalog.ProductVariant';
    PRINT N'';


    /*==============================================================================
        INDEX: UX_PRDVA_barcode

        Purpose:
            Enforce barcode uniqueness only when a barcode is informed.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : PRDVA_barcode ASC
            Included Columns  : NONE
            Filter            : PRDVA_barcode IS NOT NULL
            Filegroup         : FG_CORE

        Design Note:
            PRDVA_barcode is nullable.

            A regular UNIQUE CONSTRAINT would not represent the intended business
            rule because multiple ProductVariant rows may legitimately have no
            barcode.

            The filtered unique index therefore enforces uniqueness only for rows
            where PRDVA_barcode IS NOT NULL.
    ==============================================================================*/

    DECLARE @PRDVA_BC_expected_name                  sysname;
    DECLARE @PRDVA_BC_expected_exists                bit;
    DECLARE @PRDVA_BC_expected_is_equivalent         bit;

    DECLARE @PRDVA_BC_expected_type_desc             nvarchar(60);
    DECLARE @PRDVA_BC_expected_is_unique             bit;
    DECLARE @PRDVA_BC_expected_is_disabled           bit;
    DECLARE @PRDVA_BC_expected_has_filter            bit;
    DECLARE @PRDVA_BC_expected_filter_definition     nvarchar(4000);
    DECLARE @PRDVA_BC_expected_normalized_filter     nvarchar(4000);
    DECLARE @PRDVA_BC_expected_data_space_name       sysname;
    DECLARE @PRDVA_BC_expected_actual_keys           nvarchar(4000);
    DECLARE @PRDVA_BC_expected_actual_includes       nvarchar(4000);

    DECLARE @PRDVA_BC_equivalent_count               int;
    DECLARE @PRDVA_BC_equivalent_names               nvarchar(4000);
    DECLARE @PRDVA_BC_equivalent_details             nvarchar(4000);

    DECLARE @PRDVA_BC_actual_name                    sysname;
    DECLARE @PRDVA_BC_actual_is_disabled             bit;
    DECLARE @PRDVA_BC_actual_data_space_name         sysname;

    DECLARE @PRDVA_BC_normalized_filter              nvarchar(4000);


    SET @PRDVA_BC_expected_name =
        N'UX_PRDVA_barcode';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Index dependency missing        : catalog.ProductVariant';

        ;THROW 50320,
            N'Index UX_PRDVA_barcode cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'catalog.ProductVariant',
        N'PRDVA_barcode'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : PRDVA_barcode';

        ;THROW 50321,
            N'Index UX_PRDVA_barcode cannot be deployed because PRDVA_barcode does not exist.',
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

        ;THROW 50322,
            N'Index UX_PRDVA_barcode cannot be deployed because FG_CORE does not exist.',
            1;

    END;


    /*==============================================================================
        EXPECTED FILTER NORMALIZATION

        SQL Server may store the filter with brackets and parentheses, for example:

            ([PRDVA_barcode] IS NOT NULL)

        The normalized representation used for comparison is:

            prdva_barcodeisnotnull
    ==============================================================================*/

    SET @PRDVA_BC_expected_normalized_filter =
        N'prdva_barcodeisnotnull';


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES

        Structural equivalence means:
            - Nonclustered
            - Unique
            - Not hypothetical
            - Exactly one key column
            - Key 1 = PRDVA_barcode ASC
            - No INCLUDE columns
            - Filtered
            - Filter = PRDVA_barcode IS NOT NULL

        Physical placement on FG_CORE is validated separately.
    ==============================================================================*/

    DECLARE @PRDVA_BC_equivalent_indexes TABLE
    (
        index_name        sysname         NOT NULL,
        is_disabled       bit             NOT NULL,
        data_space_name   sysname         NULL,
        filter_definition nvarchar(4000)  NULL
    );


    INSERT INTO @PRDVA_BC_equivalent_indexes
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
        ON ds.data_space_id =
            i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'catalog.ProductVariant')

    AND i.type = 2

    AND i.is_unique = 1

    AND i.is_hypothetical = 0

    AND i.has_filter = 1

    /* Exactly one key column */
    AND
    (
        SELECT COUNT(*)

        FROM sys.index_columns AS ic

        WHERE ic.object_id =
                i.object_id

        AND ic.index_id =
                i.index_id

        AND ic.key_ordinal > 0

    ) = 1

    /* Key 1: PRDVA_barcode ASC */
    AND EXISTS
    (
        SELECT 1

        FROM sys.index_columns AS ic

        INNER JOIN sys.columns AS c
            ON  c.object_id =
                    ic.object_id

            AND c.column_id =
                    ic.column_id

        WHERE ic.object_id =
                i.object_id

        AND ic.index_id =
                i.index_id

        AND ic.key_ordinal = 1

        AND ic.is_descending_key = 0

        AND c.name =
                N'PRDVA_barcode'
    )

    /* No INCLUDE columns */
    AND NOT EXISTS
    (
        SELECT 1

        FROM sys.index_columns AS ic

        WHERE ic.object_id =
                i.object_id

        AND ic.index_id =
                i.index_id

        AND ic.is_included_column = 1
    )

    /* Expected filter */
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
    )
    =
    @PRDVA_BC_expected_normalized_filter;


    SELECT
        @PRDVA_BC_equivalent_count =
            COUNT(*)

    FROM @PRDVA_BC_equivalent_indexes;


    SELECT
        @PRDVA_BC_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @PRDVA_BC_equivalent_indexes;


    SELECT
        @PRDVA_BC_equivalent_details =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),

                    index_name

                    + N' ['
                    + COALESCE
                    (
                        data_space_name,
                        N'<UNKNOWN>'
                    )
                    + N']'

                    + CASE
                        WHEN is_disabled = 1
                            THEN N' [DISABLED]'
                        ELSE N''
                    END
                ),
                N', '
            )

    FROM @PRDVA_BC_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @PRDVA_BC_expected_exists = 0;
    SET @PRDVA_BC_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND i.name =
                @PRDVA_BC_expected_name
    )
    BEGIN

        SET @PRDVA_BC_expected_exists = 1;


        SELECT
            @PRDVA_BC_expected_type_desc =
                i.type_desc,

            @PRDVA_BC_expected_is_unique =
                i.is_unique,

            @PRDVA_BC_expected_is_disabled =
                i.is_disabled,

            @PRDVA_BC_expected_has_filter =
                i.has_filter,

            @PRDVA_BC_expected_filter_definition =
                i.filter_definition,

            @PRDVA_BC_expected_data_space_name =
                ds.name

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND i.name =
                @PRDVA_BC_expected_name;


        SELECT
            @PRDVA_BC_expected_actual_keys =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),

                        c.name

                        + CASE
                            WHEN ic.is_descending_key = 1
                                THEN N' DESC'
                            ELSE N' ASC'
                        END
                    ),
                    N', '
                )
                WITHIN GROUP
                (
                    ORDER BY ic.key_ordinal
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id =
                    ic.object_id

            AND c.column_id =
                    ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND i.name =
                @PRDVA_BC_expected_name;


        SELECT
            @PRDVA_BC_expected_actual_includes =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),
                        c.name
                    ),
                    N', '
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id =
                    ic.object_id

            AND c.column_id =
                    ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND i.name =
                @PRDVA_BC_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @PRDVA_BC_equivalent_indexes

            WHERE index_name =
                    @PRDVA_BC_expected_name
        )
        BEGIN

            SET @PRDVA_BC_expected_is_equivalent = 1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @PRDVA_BC_expected_exists = 1
    AND @PRDVA_BC_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : UX_PRDVA_barcode';

        PRINT N'            Expected Type                   : NONCLUSTERED';
        PRINT N'            Actual Type                     : '
            + COALESCE
            (
                @PRDVA_BC_expected_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique                 : 1';
        PRINT N'            Actual Unique                   : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @PRDVA_BC_expected_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns            : PRDVA_barcode ASC';
        PRINT N'            Actual Key Columns              : '
            + COALESCE
            (
                @PRDVA_BC_expected_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns       : NONE';
        PRINT N'            Actual Included Columns         : '
            + COALESCE
            (
                @PRDVA_BC_expected_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter                 : PRDVA_barcode IS NOT NULL';
        PRINT N'            Actual Filter                   : '
            + COALESCE
            (
                @PRDVA_BC_expected_filter_definition,
                N'<NONE>'
            );

        PRINT N'            Expected Filegroup              : FG_CORE';
        PRINT N'            Actual Data Space               : '
            + COALESCE
            (
                @PRDVA_BC_expected_data_space_name,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50323,
            N'Index UX_PRDVA_barcode exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        EXPECTED INDEX DOES NOT EXIST AND NO EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    IF @PRDVA_BC_expected_exists = 0
    AND @PRDVA_BC_equivalent_count = 0
    BEGIN

        CREATE UNIQUE NONCLUSTERED INDEX UX_PRDVA_barcode
            ON catalog.ProductVariant
            (
                PRDVA_barcode ASC
            )
            WHERE PRDVA_barcode IS NOT NULL
            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_PRDVA_barcode';
        PRINT N'            Key Columns                    : PRDVA_barcode';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : YES';
        PRINT N'            Filter                         : PRDVA_barcode IS NOT NULL';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @PRDVA_BC_equivalent_count = 1
    BEGIN

        SELECT
            @PRDVA_BC_actual_name =
                index_name,

            @PRDVA_BC_actual_is_disabled =
                is_disabled,

            @PRDVA_BC_actual_data_space_name =
                data_space_name,

            @PRDVA_BC_normalized_filter =
                filter_definition

        FROM @PRDVA_BC_equivalent_indexes;


        /*--------------------------------------------------------------------------
            EQUIVALENT INDEX IS DISABLED
        --------------------------------------------------------------------------*/

        IF @PRDVA_BC_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Unique filtered index disabled : '
                + @PRDVA_BC_actual_name;

            PRINT N'            Expected Name                  : UX_PRDVA_barcode';
            PRINT N'            Key Columns                    : PRDVA_barcode';
            PRINT N'            Filter                         : PRDVA_barcode IS NOT NULL';
            PRINT N'            Existing index was preserved for review.';

        END


        /*--------------------------------------------------------------------------
            CORRECT STRUCTURE EXISTS WITH DIFFERENT NAME
        --------------------------------------------------------------------------*/

        ELSE IF @PRDVA_BC_actual_name <>
                @PRDVA_BC_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';
            PRINT N'            Expected                       : UX_PRDVA_barcode';
            PRINT N'            Actual                         : '
                + @PRDVA_BC_actual_name;
            PRINT N'            Action                         : Preserve existing index';

        END


        /*--------------------------------------------------------------------------
            EXPECTED INDEX EXISTS BUT PHYSICAL PLACEMENT IS WRONG
        --------------------------------------------------------------------------*/

        ELSE IF @PRDVA_BC_actual_data_space_name <>
                N'FG_CORE'
        BEGIN

            PRINT N'        [X] Index filegroup mismatch        : UX_PRDVA_barcode';
            PRINT N'            Expected Filegroup             : FG_CORE';
            PRINT N'            Actual Data Space              : '
                + COALESCE
                (
                    @PRDVA_BC_actual_data_space_name,
                    N'<UNKNOWN>'
                );

            ;THROW 50324,
                N'Index UX_PRDVA_barcode is not stored on FG_CORE.',
                1;

        END


        /*--------------------------------------------------------------------------
            EXPECTED INDEX EXISTS AND IS VALID
        --------------------------------------------------------------------------*/

        ELSE
        BEGIN

            PRINT N'        [•] Unique filtered index validated: UX_PRDVA_barcode';
            PRINT N'            Key Columns                    : PRDVA_barcode';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : YES';
            PRINT N'            Filter                         : PRDVA_barcode IS NOT NULL';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST

        Equivalent indexes are preserved for manual review.

        Automatic removal is not permitted because an index name may be referenced
        by application hints, operational scripts, Query Store plans, monitoring,
        documentation, or other external dependencies.
    ==============================================================================*/

    ELSE IF @PRDVA_BC_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT
            (
                nvarchar(10),
                @PRDVA_BC_equivalent_count
            );

        PRINT N'            Expected Index                  : UX_PRDVA_barcode';

        PRINT N'            Equivalent Indexes             : '
            + COALESCE
            (
                @PRDVA_BC_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement              : '
            + COALESCE
            (
                @PRDVA_BC_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                          : Preserve all indexes for manual review';
        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';