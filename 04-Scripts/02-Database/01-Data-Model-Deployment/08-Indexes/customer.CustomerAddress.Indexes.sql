    PRINT N'';
    PRINT N'    ● customer.CustomerAddress';
    PRINT N'';


    /*==============================================================================
        INDEX: UX_CSTAD_primary_active

        Purpose:
            Enforce that each customer has at most one active primary address.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : CSTAD_CST_id ASC
            Included Columns  : NONE
            Filter            : CSTAD_is_primary = 1 AND CSTAD_is_active = 1
            Filegroup         : FG_CORE

        Design Note:
            Multiple addresses may exist for the same customer.

            Multiple inactive addresses and multiple active non-primary addresses
            are valid.

            The filtered unique index therefore enforces uniqueness only for rows
            representing the customer's active primary address.
    ==============================================================================*/

    DECLARE @CSTAD_PA_expected_name                  sysname;
    DECLARE @CSTAD_PA_expected_exists                bit;
    DECLARE @CSTAD_PA_expected_is_equivalent         bit;

    DECLARE @CSTAD_PA_expected_type_desc             nvarchar(60);
    DECLARE @CSTAD_PA_expected_is_unique             bit;
    DECLARE @CSTAD_PA_expected_is_disabled           bit;
    DECLARE @CSTAD_PA_expected_has_filter            bit;
    DECLARE @CSTAD_PA_expected_filter_definition     nvarchar(4000);
    DECLARE @CSTAD_PA_expected_data_space_name       sysname;
    DECLARE @CSTAD_PA_expected_actual_keys           nvarchar(4000);
    DECLARE @CSTAD_PA_expected_actual_includes       nvarchar(4000);

    DECLARE @CSTAD_PA_equivalent_count               int;
    DECLARE @CSTAD_PA_equivalent_names               nvarchar(4000);
    DECLARE @CSTAD_PA_equivalent_details             nvarchar(4000);

    DECLARE @CSTAD_PA_actual_name                    sysname;
    DECLARE @CSTAD_PA_actual_is_disabled             bit;
    DECLARE @CSTAD_PA_actual_data_space_name         sysname;


    /*==============================================================================
        EXPECTED INDEX NAME
    ==============================================================================*/

    SET @CSTAD_PA_expected_name =
        N'UX_CSTAD_primary_active';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerAddress', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Index dependency missing        : customer.CustomerAddress';

        ;THROW 50490,
            N'Index UX_CSTAD_primary_active cannot be deployed because customer.CustomerAddress does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'customer.CustomerAddress',
        N'CSTAD_CST_id'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : CSTAD_CST_id';

        ;THROW 50491,
            N'Index UX_CSTAD_primary_active cannot be deployed because CSTAD_CST_id does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'customer.CustomerAddress',
        N'CSTAD_is_primary'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index filter column missing     : CSTAD_is_primary';

        ;THROW 50492,
            N'Index UX_CSTAD_primary_active cannot be deployed because CSTAD_is_primary does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'customer.CustomerAddress',
        N'CSTAD_is_active'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index filter column missing     : CSTAD_is_active';

        ;THROW 50493,
            N'Index UX_CSTAD_primary_active cannot be deployed because CSTAD_is_active does not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.filegroups

        WHERE name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Index filegroup missing         : FG_CORE';

        ;THROW 50494,
            N'Index UX_CSTAD_primary_active cannot be deployed because FG_CORE does not exist.',
            1;

    END;


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES

        Structural equivalence means:
            - Nonclustered
            - Unique
            - Not PK
            - Not UNIQUE CONSTRAINT
            - Not hypothetical
            - Exactly one key column
            - Key 1 = CSTAD_CST_id ASC
            - No INCLUDE columns
            - Filtered
            - Filter enforces:
                CSTAD_is_primary = 1
                CSTAD_is_active  = 1

        The order of the two AND predicates is considered functionally equivalent.

        Physical placement on FG_CORE is validated separately.
    ==============================================================================*/

    DECLARE @CSTAD_PA_equivalent_indexes TABLE
    (
        index_name         sysname         NOT NULL,
        is_disabled        bit             NOT NULL,
        data_space_name    sysname         NULL,
        filter_definition  nvarchar(4000)  NULL
    );


    INSERT INTO @CSTAD_PA_equivalent_indexes
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
            OBJECT_ID(N'customer.CustomerAddress')

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

    /* Key 1: CSTAD_CST_id ASC */
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
                N'CSTAD_CST_id'
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
    AND
    (
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
        N'cstad_is_primary=1andcstad_is_active=1'

        OR

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
        N'cstad_is_active=1andcstad_is_primary=1'
    );


    SELECT
        @CSTAD_PA_equivalent_count =
            COUNT(*)

    FROM @CSTAD_PA_equivalent_indexes;


    SELECT
        @CSTAD_PA_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @CSTAD_PA_equivalent_indexes;


    SELECT
        @CSTAD_PA_equivalent_details =
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

    FROM @CSTAD_PA_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @CSTAD_PA_expected_exists = 0;
    SET @CSTAD_PA_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND i.name =
                @CSTAD_PA_expected_name
    )
    BEGIN

        SET @CSTAD_PA_expected_exists = 1;


        SELECT
            @CSTAD_PA_expected_type_desc =
                i.type_desc,

            @CSTAD_PA_expected_is_unique =
                i.is_unique,

            @CSTAD_PA_expected_is_disabled =
                i.is_disabled,

            @CSTAD_PA_expected_has_filter =
                i.has_filter,

            @CSTAD_PA_expected_filter_definition =
                i.filter_definition,

            @CSTAD_PA_expected_data_space_name =
                ds.name

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND i.name =
                @CSTAD_PA_expected_name;


        SELECT
            @CSTAD_PA_expected_actual_keys =
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
                OBJECT_ID(N'customer.CustomerAddress')

        AND i.name =
                @CSTAD_PA_expected_name;


        SELECT
            @CSTAD_PA_expected_actual_includes =
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
                OBJECT_ID(N'customer.CustomerAddress')

        AND i.name =
                @CSTAD_PA_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @CSTAD_PA_equivalent_indexes

            WHERE index_name =
                    @CSTAD_PA_expected_name
        )
        BEGIN

            SET @CSTAD_PA_expected_is_equivalent = 1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @CSTAD_PA_expected_exists = 1
    AND @CSTAD_PA_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : UX_CSTAD_primary_active';

        PRINT N'            Expected Type                   : NONCLUSTERED';

        PRINT N'            Actual Type                     : '
            + COALESCE
            (
                @CSTAD_PA_expected_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique                 : 1';

        PRINT N'            Actual Unique                   : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @CSTAD_PA_expected_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns            : CSTAD_CST_id ASC';

        PRINT N'            Actual Key Columns              : '
            + COALESCE
            (
                @CSTAD_PA_expected_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns       : NONE';

        PRINT N'            Actual Included Columns         : '
            + COALESCE
            (
                @CSTAD_PA_expected_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter                 : CSTAD_is_primary = 1 AND CSTAD_is_active = 1';

        PRINT N'            Actual Filter                   : '
            + COALESCE
            (
                @CSTAD_PA_expected_filter_definition,
                N'<NONE>'
            );

        PRINT N'            Expected Filegroup              : FG_CORE';

        PRINT N'            Actual Data Space               : '
            + COALESCE
            (
                @CSTAD_PA_expected_data_space_name,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50495,
            N'Index UX_CSTAD_primary_active exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        EXPECTED INDEX DOES NOT EXIST AND NO EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    IF @CSTAD_PA_expected_exists = 0
    AND @CSTAD_PA_equivalent_count = 0
    BEGIN

        /*--------------------------------------------------------------------------
            PRE-DEPLOYMENT BUSINESS RULE VALIDATION

            Existing data must not already contain more than one active primary
            address for the same Customer.
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT
                CSTAD_CST_id

            FROM customer.CustomerAddress

            WHERE CSTAD_is_primary = 1
            AND CSTAD_is_active = 1

            GROUP BY
                CSTAD_CST_id

            HAVING COUNT(*) > 1
        )
        BEGIN

            PRINT N'        [X] Existing data violates active primary address uniqueness';
            PRINT N'            Rule                           : Maximum one active primary address per Customer';
            PRINT N'            Filter                         : CSTAD_is_primary = 1 AND CSTAD_is_active = 1';
            PRINT N'            Index was not created. Data correction is required.';


            ;THROW 50497,
                N'UX_CSTAD_primary_active cannot be created because existing data contains multiple active primary addresses for the same Customer.',
                1;

        END;


        CREATE UNIQUE NONCLUSTERED INDEX UX_CSTAD_primary_active
            ON customer.CustomerAddress
            (
                CSTAD_CST_id ASC
            )
            WHERE CSTAD_is_primary = 1
            AND CSTAD_is_active = 1
            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_CSTAD_primary_active';
        PRINT N'            Key Columns                    : CSTAD_CST_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : YES';
        PRINT N'            Filter                         : CSTAD_is_primary = 1 AND CSTAD_is_active = 1';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @CSTAD_PA_equivalent_count = 1
    BEGIN

        SELECT
            @CSTAD_PA_actual_name =
                index_name,

            @CSTAD_PA_actual_is_disabled =
                is_disabled,

            @CSTAD_PA_actual_data_space_name =
                data_space_name

        FROM @CSTAD_PA_equivalent_indexes;


        /*--------------------------------------------------------------------------
            EQUIVALENT INDEX IS DISABLED
        --------------------------------------------------------------------------*/

        IF @CSTAD_PA_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Unique filtered index disabled : '
                + @CSTAD_PA_actual_name;

            PRINT N'            Expected Name                  : UX_CSTAD_primary_active';

            PRINT N'            Key Columns                    : CSTAD_CST_id';

            PRINT N'            Filter                         : CSTAD_is_primary = 1 AND CSTAD_is_active = 1';

            PRINT N'            Existing index was preserved for review.';

        END


        /*--------------------------------------------------------------------------
            CORRECT STRUCTURE EXISTS WITH DIFFERENT NAME
        --------------------------------------------------------------------------*/

        ELSE IF @CSTAD_PA_actual_name <>
                @CSTAD_PA_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';

            PRINT N'            Expected                       : UX_CSTAD_primary_active';

            PRINT N'            Actual                         : '
                + @CSTAD_PA_actual_name;

            PRINT N'            Action                         : Preserve existing index';

        END


        /*--------------------------------------------------------------------------
            EXPECTED INDEX EXISTS BUT PHYSICAL PLACEMENT IS WRONG
        --------------------------------------------------------------------------*/

        ELSE IF @CSTAD_PA_actual_data_space_name <>
                N'FG_CORE'
        BEGIN

            PRINT N'        [X] Index filegroup mismatch        : UX_CSTAD_primary_active';

            PRINT N'            Expected Filegroup             : FG_CORE';

            PRINT N'            Actual Data Space              : '
                + COALESCE
                (
                    @CSTAD_PA_actual_data_space_name,
                    N'<UNKNOWN>'
                );


            ;THROW 50496,
                N'Index UX_CSTAD_primary_active is not stored on FG_CORE.',
                1;

        END


        /*--------------------------------------------------------------------------
            EXPECTED INDEX EXISTS AND IS VALID
        --------------------------------------------------------------------------*/

        ELSE
        BEGIN

            PRINT N'        [•] Unique filtered index validated: UX_CSTAD_primary_active';
            PRINT N'            Key Columns                    : CSTAD_CST_id';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : YES';
            PRINT N'            Filter                         : CSTAD_is_primary = 1 AND CSTAD_is_active = 1';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @CSTAD_PA_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT
            (
                nvarchar(10),
                @CSTAD_PA_equivalent_count
            );

        PRINT N'            Expected Index                  : UX_CSTAD_primary_active';

        PRINT N'            Equivalent Indexes              : '
            + COALESCE
            (
                @CSTAD_PA_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement              : '
            + COALESCE
            (
                @CSTAD_PA_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                          : Preserve all indexes for manual review';

        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';