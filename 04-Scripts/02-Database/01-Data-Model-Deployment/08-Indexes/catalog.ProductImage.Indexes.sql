    PRINT N'';
    PRINT N'    ● catalog.ProductImage';
    PRINT N'';


    /*==============================================================================
        UNIQUE FILTERED INDEX: UX_PRDIM_primary_product

        Business Rule:
            A Product may have many images, but at most one image may be identified
            as its primary catalog image.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : PRDIM_PRD_id ASC
            Included Columns  : NONE
            Filter            : PRDIM_is_primary = 1
            Filegroup         : FG_CORE

        Important:
            This rule intentionally does not require every Product to have a
            primary image. It only prevents more than one primary image from
            existing for the same Product.

            CK_PRDIM_primary_active independently guarantees that a primary image
            cannot be inactive.
    ==============================================================================*/

    DECLARE @PRDIM_UX_expected_name               sysname;
    DECLARE @PRDIM_UX_expected_exists             bit;
    DECLARE @PRDIM_UX_expected_is_equivalent      bit;

    DECLARE @PRDIM_UX_actual_name                 sysname;
    DECLARE @PRDIM_UX_actual_type_desc            nvarchar(60);
    DECLARE @PRDIM_UX_actual_is_unique            bit;
    DECLARE @PRDIM_UX_actual_is_disabled          bit;
    DECLARE @PRDIM_UX_actual_data_space           sysname;
    DECLARE @PRDIM_UX_actual_keys                 nvarchar(4000);
    DECLARE @PRDIM_UX_actual_includes             nvarchar(4000);
    DECLARE @PRDIM_UX_actual_filter               nvarchar(4000);
    DECLARE @PRDIM_UX_actual_filter_normalized    nvarchar(4000);

    DECLARE @PRDIM_UX_equivalent_count            int;
    DECLARE @PRDIM_UX_equivalent_names            nvarchar(4000);
    DECLARE @PRDIM_UX_equivalent_details          nvarchar(4000);

    DECLARE @PRDIM_UX_conflict_parent             nvarchar(517);


    SET @PRDIM_UX_expected_name =
        N'UX_PRDIM_primary_product';


    /*==============================================================================
        COLLECT FUNCTIONALLY EQUIVALENT FILTERED UNIQUE INDEXES
    ==============================================================================*/

    DECLARE @PRDIM_UX_equivalent_indexes TABLE
    (
        index_name        sysname         NOT NULL,
        is_disabled       bit             NOT NULL,
        data_space_name   sysname         NULL,
        filter_definition nvarchar(4000)  NULL
    );


    INSERT INTO @PRDIM_UX_equivalent_indexes
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
            OBJECT_ID(N'catalog.ProductImage')

    AND i.type = 2

    AND i.is_unique = 1

    AND i.is_primary_key = 0

    AND i.is_unique_constraint = 0

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

    /* Key 1 = PRDIM_PRD_id ASC */
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
                N'PRDIM_PRD_id'
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
                            i.filter_definition,
                            N'[',
                            N''
                        ),
                        N']',
                        N''
                    ),
                    N' ',
                    N''
                ),
                N'(',
                N''
            ),
            N')',
            N''
        )
    ) = N'prdim_is_primary=1';


    SELECT
        @PRDIM_UX_equivalent_count =
            COUNT(*)

    FROM @PRDIM_UX_equivalent_indexes;


    SELECT
        @PRDIM_UX_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @PRDIM_UX_equivalent_indexes;


    SELECT
        @PRDIM_UX_equivalent_details =
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

    FROM @PRDIM_UX_equivalent_indexes;


    /*==============================================================================
        IDENTIFY EXPECTED INDEX
    ==============================================================================*/

    SET @PRDIM_UX_expected_exists =
        0;

    SET @PRDIM_UX_expected_is_equivalent =
        0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_UX_expected_name
    )
    BEGIN

        SET @PRDIM_UX_expected_exists =
            1;


        SELECT
            @PRDIM_UX_actual_name =
                i.name,

            @PRDIM_UX_actual_type_desc =
                i.type_desc,

            @PRDIM_UX_actual_is_unique =
                i.is_unique,

            @PRDIM_UX_actual_is_disabled =
                i.is_disabled,

            @PRDIM_UX_actual_data_space =
                ds.name,

            @PRDIM_UX_actual_filter =
                i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_UX_expected_name;


        SELECT
            @PRDIM_UX_actual_keys =
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
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_UX_expected_name;


        SELECT
            @PRDIM_UX_actual_includes =
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
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_UX_expected_name;


        SET @PRDIM_UX_actual_filter_normalized =
            LOWER
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
                                    @PRDIM_UX_actual_filter,
                                    N'[',
                                    N''
                                ),
                                N']',
                                N''
                            ),
                            N' ',
                            N''
                        ),
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                )
            );


        IF EXISTS
        (
            SELECT 1

            FROM @PRDIM_UX_equivalent_indexes

            WHERE index_name =
                @PRDIM_UX_expected_name
        )
        BEGIN

            SET @PRDIM_UX_expected_is_equivalent =
                1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG DEFINITION
    ==============================================================================*/

    IF @PRDIM_UX_expected_exists = 1

    AND @PRDIM_UX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Unique filtered index mismatch : UX_PRDIM_primary_product';

        PRINT N'            Expected Type                 : NONCLUSTERED';

        PRINT N'            Actual Type                   : '
            + COALESCE
            (
                @PRDIM_UX_actual_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique               : 1';

        PRINT N'            Actual Unique                 : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @PRDIM_UX_actual_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns          : PRDIM_PRD_id ASC';

        PRINT N'            Actual Key Columns            : '
            + COALESCE
            (
                @PRDIM_UX_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns     : NONE';

        PRINT N'            Actual Included Columns       : '
            + COALESCE
            (
                @PRDIM_UX_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter               : PRDIM_is_primary = 1';

        PRINT N'            Actual Filter                 : '
            + COALESCE
            (
                @PRDIM_UX_actual_filter,
                N'<NONE>'
            );

        PRINT N'            Expected Filegroup            : FG_CORE';

        PRINT N'            Actual Filegroup              : '
            + COALESCE
            (
                @PRDIM_UX_actual_data_space,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50430,
            N'Index UX_PRDIM_primary_product exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        EXPECTED INDEX DOES NOT EXIST AND NO EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    IF @PRDIM_UX_expected_exists = 0

    AND @PRDIM_UX_equivalent_count = 0
    BEGIN

        /*--------------------------------------------------------------------------
            PRE-DEPLOYMENT BUSINESS RULE VALIDATION

            The index cannot be created safely if existing data already contains
            more than one primary image for the same Product.
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT
                PRDIM_PRD_id

            FROM catalog.ProductImage

            WHERE PRDIM_is_primary = 1

            GROUP BY
                PRDIM_PRD_id

            HAVING COUNT(*) > 1
        )
        BEGIN

            PRINT N'        [X] Existing data violates primary image uniqueness';
            PRINT N'            Rule                          : Maximum one primary image per Product';
            PRINT N'            Filter                        : PRDIM_is_primary = 1';
            PRINT N'            Index was not created. Data correction is required.';


            ;THROW 50431,
                N'UX_PRDIM_primary_product cannot be created because existing data contains multiple primary images for the same Product.',
                1;

        END;


        CREATE UNIQUE NONCLUSTERED INDEX UX_PRDIM_primary_product
            ON catalog.ProductImage
            (
                PRDIM_PRD_id ASC
            )
            WHERE PRDIM_is_primary = 1
            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_PRDIM_primary_product';
        PRINT N'            Key Columns                    : PRDIM_PRD_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : YES';
        PRINT N'            Filter                         : PRDIM_is_primary = 1';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @PRDIM_UX_equivalent_count = 1
    BEGIN

        SELECT
            @PRDIM_UX_actual_name =
                index_name,

            @PRDIM_UX_actual_is_disabled =
                is_disabled,

            @PRDIM_UX_actual_data_space =
                data_space_name,

            @PRDIM_UX_actual_filter =
                filter_definition

        FROM @PRDIM_UX_equivalent_indexes;


        IF @PRDIM_UX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Unique filtered index disabled : '
                + @PRDIM_UX_actual_name;

            PRINT N'            Expected Name                 : UX_PRDIM_primary_product';

            PRINT N'            Key Columns                   : PRDIM_PRD_id';

            PRINT N'            Filter                        : PRDIM_is_primary = 1';

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PRDIM_UX_actual_data_space <>
            N'FG_CORE'
        BEGIN

            PRINT N'        [!] Unique filtered index storage divergence';

            PRINT N'            Index                         : '
                + @PRDIM_UX_actual_name;

            PRINT N'            Expected Filegroup            : FG_CORE';

            PRINT N'            Actual Filegroup              : '
                + COALESCE
                (
                    @PRDIM_UX_actual_data_space,
                    N'<UNKNOWN>'
                );

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PRDIM_UX_actual_name <>
            @PRDIM_UX_expected_name
        BEGIN

            PRINT N'        [!] Unique filtered index naming divergence';

            PRINT N'            Expected                     : UX_PRDIM_primary_product';

            PRINT N'            Actual                       : '
                + @PRDIM_UX_actual_name;

            PRINT N'            Key Columns                   : PRDIM_PRD_id';

            PRINT N'            Filter                        : PRDIM_is_primary = 1';

            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Unique filtered index validated: UX_PRDIM_primary_product';
            PRINT N'            Key Columns                    : PRDIM_PRD_id';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : YES';
            PRINT N'            Filter                         : PRDIM_is_primary = 1';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE FUNCTIONALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @PRDIM_UX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent unique filtered indexes detected : '
            + CONVERT
            (
                nvarchar(10),
                @PRDIM_UX_equivalent_count
            );

        PRINT N'            Expected Index                : UX_PRDIM_primary_product';

        PRINT N'            Equivalent Indexes            : '
            + COALESCE
            (
                @PRDIM_UX_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement            : '
            + COALESCE
            (
                @PRDIM_UX_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                        : Preserve all indexes for manual review';

        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    /*==============================================================================
        UNIQUE FILTERED INDEX: UX_PRDIM_product_display_order_active

        Business Rule:
            Active images of the same Product must have distinct display positions.

            Inactive historical images do not participate in this uniqueness rule
            and therefore do not reserve presentation positions.

        Purpose:
            - Enforce deterministic gallery ordering for active Product images.
            - Support the natural gallery access pattern:

                WHERE PRDIM_PRD_id = @Product
                    AND PRDIM_is_active = 1
                ORDER BY PRDIM_display_order

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : PRDIM_PRD_id ASC,
                                PRDIM_display_order ASC
            Included Columns  : NONE
            Filter            : PRDIM_is_active = 1
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @PRDIM_DSP_expected_name                sysname;
    DECLARE @PRDIM_DSP_expected_exists              bit;
    DECLARE @PRDIM_DSP_expected_is_equivalent       bit;

    DECLARE @PRDIM_DSP_expected_type_desc           nvarchar(60);
    DECLARE @PRDIM_DSP_expected_is_unique           bit;
    DECLARE @PRDIM_DSP_expected_is_disabled         bit;
    DECLARE @PRDIM_DSP_expected_data_space_name     sysname;
    DECLARE @PRDIM_DSP_expected_actual_keys         nvarchar(4000);
    DECLARE @PRDIM_DSP_expected_actual_includes     nvarchar(4000);
    DECLARE @PRDIM_DSP_expected_actual_filter       nvarchar(4000);

    DECLARE @PRDIM_DSP_equivalent_count             int;
    DECLARE @PRDIM_DSP_equivalent_names             nvarchar(4000);
    DECLARE @PRDIM_DSP_equivalent_details           nvarchar(4000);

    DECLARE @PRDIM_DSP_actual_name                  sysname;
    DECLARE @PRDIM_DSP_actual_is_disabled           bit;
    DECLARE @PRDIM_DSP_actual_data_space_name       sysname;
    DECLARE @PRDIM_DSP_actual_filter                nvarchar(4000);

    DECLARE @PRDIM_DSP_conflict_parent              nvarchar(517);


    SET @PRDIM_DSP_expected_name =
        N'UX_PRDIM_product_display_order_active';


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES

        Structural equivalence means:
            - Nonclustered
            - Unique
            - Filtered
            - Not PK
            - Not UNIQUE CONSTRAINT
            - Not hypothetical
            - Exactly two key columns
            - Key 1 = PRDIM_PRD_id ASC
            - Key 2 = PRDIM_display_order ASC
            - No INCLUDE columns
            - Filter = PRDIM_is_active = 1
    ==============================================================================*/

    DECLARE @PRDIM_DSP_equivalent_indexes TABLE
    (
        index_name        sysname         NOT NULL,
        is_disabled       bit             NOT NULL,
        data_space_name   sysname         NULL,
        filter_definition nvarchar(4000)  NULL
    );


    INSERT INTO @PRDIM_DSP_equivalent_indexes
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
            OBJECT_ID(N'catalog.ProductImage')

    AND i.type = 2

    AND i.is_unique = 1

    AND i.is_primary_key = 0

    AND i.is_unique_constraint = 0

    AND i.is_hypothetical = 0

    AND i.has_filter = 1


    /* Exactly two key columns */
    AND
    (
        SELECT COUNT(*)

        FROM sys.index_columns AS ic

        WHERE ic.object_id =
                i.object_id

        AND ic.index_id =
                i.index_id

        AND ic.key_ordinal > 0

    ) = 2


    /* Key 1 = PRDIM_PRD_id ASC */
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
                N'PRDIM_PRD_id'
    )


    /* Key 2 = PRDIM_display_order ASC */
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

        AND ic.key_ordinal = 2

        AND ic.is_descending_key = 0

        AND c.name =
                N'PRDIM_display_order'
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
                            i.filter_definition,
                            N'[',
                            N''
                        ),
                        N']',
                        N''
                    ),
                    N' ',
                    N''
                ),
                N'(',
                N''
            ),
            N')',
            N''
        )
    ) = N'prdim_is_active=1';


    SELECT
        @PRDIM_DSP_equivalent_count =
            COUNT(*)

    FROM @PRDIM_DSP_equivalent_indexes;


    SELECT
        @PRDIM_DSP_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @PRDIM_DSP_equivalent_indexes;


    SELECT
        @PRDIM_DSP_equivalent_details =
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

    FROM @PRDIM_DSP_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @PRDIM_DSP_expected_exists =
        0;

    SET @PRDIM_DSP_expected_is_equivalent =
        0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_DSP_expected_name
    )
    BEGIN

        SET @PRDIM_DSP_expected_exists =
            1;


        SELECT
            @PRDIM_DSP_expected_type_desc =
                i.type_desc,

            @PRDIM_DSP_expected_is_unique =
                i.is_unique,

            @PRDIM_DSP_expected_is_disabled =
                i.is_disabled,

            @PRDIM_DSP_expected_data_space_name =
                ds.name,

            @PRDIM_DSP_expected_actual_filter =
                i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_DSP_expected_name;


        SELECT
            @PRDIM_DSP_expected_actual_keys =
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
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_DSP_expected_name;


        SELECT
            @PRDIM_DSP_expected_actual_includes =
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
                OBJECT_ID(N'catalog.ProductImage')

        AND i.name =
                @PRDIM_DSP_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @PRDIM_DSP_equivalent_indexes

            WHERE index_name =
                @PRDIM_DSP_expected_name
        )
        BEGIN

            SET @PRDIM_DSP_expected_is_equivalent =
                1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @PRDIM_DSP_expected_exists = 1

    AND @PRDIM_DSP_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Unique filtered index mismatch : UX_PRDIM_product_display_order_active';

        PRINT N'            Expected Type                 : NONCLUSTERED';

        PRINT N'            Actual Type                   : '
            + COALESCE
            (
                @PRDIM_DSP_expected_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique               : 1';

        PRINT N'            Actual Unique                 : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @PRDIM_DSP_expected_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns          : PRDIM_PRD_id ASC, PRDIM_display_order ASC';

        PRINT N'            Actual Key Columns            : '
            + COALESCE
            (
                @PRDIM_DSP_expected_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns     : NONE';

        PRINT N'            Actual Included Columns       : '
            + COALESCE
            (
                @PRDIM_DSP_expected_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter               : PRDIM_is_active = 1';

        PRINT N'            Actual Filter                 : '
            + COALESCE
            (
                @PRDIM_DSP_expected_actual_filter,
                N'<NONE>'
            );

        PRINT N'            Expected Filegroup            : FG_CORE';

        PRINT N'            Actual Filegroup              : '
            + COALESCE
            (
                @PRDIM_DSP_expected_data_space_name,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50450,
            N'Index UX_PRDIM_product_display_order_active exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @PRDIM_DSP_expected_exists = 0

    AND @PRDIM_DSP_equivalent_count = 0
    BEGIN

        /*--------------------------------------------------------------------------
            PRE-DEPLOYMENT DATA VALIDATION

            Existing active images must not already contain duplicate display
            positions within the same Product.
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT
                PRDIM_PRD_id,
                PRDIM_display_order

            FROM catalog.ProductImage

            WHERE PRDIM_is_active = 1

            GROUP BY
                PRDIM_PRD_id,
                PRDIM_display_order

            HAVING COUNT(*) > 1
        )
        BEGIN

            PRINT N'        [X] Existing data violates active image display order uniqueness';

            PRINT N'            Rule                          : Unique active display order per Product';

            PRINT N'            Filter                        : PRDIM_is_active = 1';

            PRINT N'            Index was not created. Data correction is required.';


            ;THROW 50451,
                N'UX_PRDIM_product_display_order_active cannot be created because active images contain duplicate display positions for the same Product.',
                1;

        END;


        CREATE UNIQUE NONCLUSTERED INDEX
            UX_PRDIM_product_display_order_active

            ON catalog.ProductImage
            (
                PRDIM_PRD_id ASC,
                PRDIM_display_order ASC
            )

            WHERE PRDIM_is_active = 1

            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_PRDIM_product_display_order_active';

        PRINT N'            Key Columns                    : PRDIM_PRD_id, PRDIM_display_order';

        PRINT N'            Included Columns               : NONE';

        PRINT N'            Unique                         : YES';

        PRINT N'            Filter                         : PRDIM_is_active = 1';

        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @PRDIM_DSP_equivalent_count = 1
    BEGIN

        SELECT
            @PRDIM_DSP_actual_name =
                index_name,

            @PRDIM_DSP_actual_is_disabled =
                is_disabled,

            @PRDIM_DSP_actual_data_space_name =
                data_space_name,

            @PRDIM_DSP_actual_filter =
                filter_definition

        FROM @PRDIM_DSP_equivalent_indexes;


        IF @PRDIM_DSP_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Unique filtered index disabled : '
                + @PRDIM_DSP_actual_name;

            PRINT N'            Expected Name                 : UX_PRDIM_product_display_order_active';

            PRINT N'            Key Columns                   : PRDIM_PRD_id, PRDIM_display_order';

            PRINT N'            Filter                        : PRDIM_is_active = 1';

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PRDIM_DSP_actual_data_space_name <>
                N'FG_CORE'
        BEGIN

            PRINT N'        [!] Unique filtered index storage divergence';

            PRINT N'            Index                         : '
                + @PRDIM_DSP_actual_name;

            PRINT N'            Expected Filegroup            : FG_CORE';

            PRINT N'            Actual Filegroup              : '
                + COALESCE
                (
                    @PRDIM_DSP_actual_data_space_name,
                    N'<UNKNOWN>'
                );

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PRDIM_DSP_actual_name <>
                @PRDIM_DSP_expected_name
        BEGIN

            PRINT N'        [!] Unique filtered index naming divergence';

            PRINT N'            Expected                     : UX_PRDIM_product_display_order_active';

            PRINT N'            Actual                       : '
                + @PRDIM_DSP_actual_name;

            PRINT N'            Key Columns                   : PRDIM_PRD_id, PRDIM_display_order';

            PRINT N'            Filter                        : PRDIM_is_active = 1';

            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Unique filtered index validated: UX_PRDIM_product_display_order_active';

            PRINT N'            Key Columns                    : PRDIM_PRD_id, PRDIM_display_order';

            PRINT N'            Included Columns               : NONE';

            PRINT N'            Unique                         : YES';

            PRINT N'            Filter                         : PRDIM_is_active = 1';

            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @PRDIM_DSP_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent unique filtered indexes detected : '
            + CONVERT
            (
                nvarchar(10),
                @PRDIM_DSP_equivalent_count
            );

        PRINT N'            Expected Index                : UX_PRDIM_product_display_order_active';

        PRINT N'            Equivalent Indexes            : '
            + COALESCE
            (
                @PRDIM_DSP_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement            : '
            + COALESCE
            (
                @PRDIM_DSP_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                        : Preserve all indexes for manual review';

        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';