    PRINT N'';
    PRINT N'    ● customer.CustomerEmail';
    PRINT N'';


    /*==============================================================================
        INDEX: UX_CSTEM_primary_active

        Purpose:
            Enforce that each customer has at most one active primary email.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : CSTEM_CST_id ASC
            Included Columns  : NONE
            Filter            : CSTEM_is_primary = 1 AND CSTEM_is_active = 1
            Filegroup         : FG_CORE

        Design Note:
            Multiple email addresses may exist for the same customer.

            The same email address may also be associated with multiple customers.

            Multiple inactive emails and multiple active non-primary emails
            are valid.

            The filtered unique index therefore enforces uniqueness only for rows
            representing the customer's active primary email.
    ==============================================================================*/

    DECLARE @CSTEM_PA_expected_name                  sysname;
    DECLARE @CSTEM_PA_expected_exists                bit;
    DECLARE @CSTEM_PA_expected_is_equivalent         bit;

    DECLARE @CSTEM_PA_expected_type_desc             nvarchar(60);
    DECLARE @CSTEM_PA_expected_is_unique             bit;
    DECLARE @CSTEM_PA_expected_is_disabled           bit;
    DECLARE @CSTEM_PA_expected_has_filter            bit;
    DECLARE @CSTEM_PA_expected_filter_definition     nvarchar(4000);
    DECLARE @CSTEM_PA_expected_data_space_name       sysname;
    DECLARE @CSTEM_PA_expected_actual_keys           nvarchar(4000);
    DECLARE @CSTEM_PA_expected_actual_includes       nvarchar(4000);

    DECLARE @CSTEM_PA_equivalent_count               int;
    DECLARE @CSTEM_PA_equivalent_names               nvarchar(4000);
    DECLARE @CSTEM_PA_equivalent_details             nvarchar(4000);

    DECLARE @CSTEM_PA_actual_name                    sysname;
    DECLARE @CSTEM_PA_actual_is_disabled             bit;
    DECLARE @CSTEM_PA_actual_data_space_name         sysname;


    /*==============================================================================
        EXPECTED INDEX NAME
    ==============================================================================*/

    SET @CSTEM_PA_expected_name =
        N'UX_CSTEM_primary_active';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerEmail', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Index dependency missing        : customer.CustomerEmail';

        ;THROW 50740,
            N'Index UX_CSTEM_primary_active cannot be deployed because customer.CustomerEmail does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'customer.CustomerEmail',
        N'CSTEM_CST_id'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : CSTEM_CST_id';

        ;THROW 50741,
            N'Index UX_CSTEM_primary_active cannot be deployed because CSTEM_CST_id does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'customer.CustomerEmail',
        N'CSTEM_is_primary'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index filter column missing     : CSTEM_is_primary';

        ;THROW 50742,
            N'Index UX_CSTEM_primary_active cannot be deployed because CSTEM_is_primary does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'customer.CustomerEmail',
        N'CSTEM_is_active'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index filter column missing     : CSTEM_is_active';

        ;THROW 50743,
            N'Index UX_CSTEM_primary_active cannot be deployed because CSTEM_is_active does not exist.',
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

        ;THROW 50744,
            N'Index UX_CSTEM_primary_active cannot be deployed because FG_CORE does not exist.',
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
            - Key 1 = CSTEM_CST_id ASC
            - No INCLUDE columns
            - Filtered
            - Filter =
                CSTEM_is_primary = 1
                AND CSTEM_is_active = 1

        The order of the two AND predicates is considered functionally equivalent.

        Physical placement on FG_CORE is validated separately.
    ==============================================================================*/

    DECLARE @CSTEM_PA_equivalent_indexes TABLE
    (
        index_name         sysname         NOT NULL,
        is_disabled        bit             NOT NULL,
        data_space_name    sysname         NULL,
        filter_definition  nvarchar(4000)  NULL
    );


    INSERT INTO @CSTEM_PA_equivalent_indexes
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
            OBJECT_ID(N'customer.CustomerEmail')

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

    /* Key 1 = CSTEM_CST_id ASC */
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
                N'CSTEM_CST_id'
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
        N'cstem_is_primary=1andcstem_is_active=1'

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
        N'cstem_is_active=1andcstem_is_primary=1'
    );


    SELECT
        @CSTEM_PA_equivalent_count =
            COUNT(*)

    FROM @CSTEM_PA_equivalent_indexes;


    SELECT
        @CSTEM_PA_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @CSTEM_PA_equivalent_indexes;


    SELECT
        @CSTEM_PA_equivalent_details =
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

    FROM @CSTEM_PA_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @CSTEM_PA_expected_exists = 0;
    SET @CSTEM_PA_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND i.name =
                @CSTEM_PA_expected_name
    )
    BEGIN

        SET @CSTEM_PA_expected_exists = 1;


        SELECT
            @CSTEM_PA_expected_type_desc =
                i.type_desc,

            @CSTEM_PA_expected_is_unique =
                i.is_unique,

            @CSTEM_PA_expected_is_disabled =
                i.is_disabled,

            @CSTEM_PA_expected_has_filter =
                i.has_filter,

            @CSTEM_PA_expected_filter_definition =
                i.filter_definition,

            @CSTEM_PA_expected_data_space_name =
                ds.name

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'customer.CustomerEmail')

        AND i.name =
                @CSTEM_PA_expected_name;


        SELECT
            @CSTEM_PA_expected_actual_keys =
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
                OBJECT_ID(N'customer.CustomerEmail')

        AND i.name =
                @CSTEM_PA_expected_name;


        SELECT
            @CSTEM_PA_expected_actual_includes =
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
                OBJECT_ID(N'customer.CustomerEmail')

        AND i.name =
                @CSTEM_PA_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @CSTEM_PA_equivalent_indexes

            WHERE index_name =
                    @CSTEM_PA_expected_name
        )
        BEGIN

            SET @CSTEM_PA_expected_is_equivalent = 1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @CSTEM_PA_expected_exists = 1
    AND @CSTEM_PA_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : UX_CSTEM_primary_active';

        PRINT N'            Expected Type                   : NONCLUSTERED';

        PRINT N'            Actual Type                     : '
            + COALESCE
            (
                @CSTEM_PA_expected_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique                 : 1';

        PRINT N'            Actual Unique                   : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @CSTEM_PA_expected_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns            : CSTEM_CST_id ASC';

        PRINT N'            Actual Key Columns              : '
            + COALESCE
            (
                @CSTEM_PA_expected_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns       : NONE';

        PRINT N'            Actual Included Columns         : '
            + COALESCE
            (
                @CSTEM_PA_expected_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter                 : CSTEM_is_primary = 1 AND CSTEM_is_active = 1';

        PRINT N'            Actual Filter                   : '
            + COALESCE
            (
                @CSTEM_PA_expected_filter_definition,
                N'<NONE>'
            );

        PRINT N'            Expected Filegroup              : FG_CORE';

        PRINT N'            Actual Data Space               : '
            + COALESCE
            (
                @CSTEM_PA_expected_data_space_name,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50745,
            N'Index UX_CSTEM_primary_active exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        EXPECTED INDEX DOES NOT EXIST AND NO EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    IF @CSTEM_PA_expected_exists = 0
    AND @CSTEM_PA_equivalent_count = 0
    BEGIN

        /*--------------------------------------------------------------------------
            PRE-DEPLOYMENT BUSINESS RULE VALIDATION

            Existing data must not already contain more than one active primary
            email for the same Customer.
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT
                CSTEM_CST_id

            FROM customer.CustomerEmail

            WHERE CSTEM_is_primary = 1
            AND CSTEM_is_active = 1

            GROUP BY
                CSTEM_CST_id

            HAVING COUNT(*) > 1
        )
        BEGIN

            PRINT N'        [X] Existing data violates active primary email uniqueness';
            PRINT N'            Rule                           : Maximum one active primary email per Customer';
            PRINT N'            Filter                         : CSTEM_is_primary = 1 AND CSTEM_is_active = 1';
            PRINT N'            Index was not created. Data correction is required.';


            ;THROW 50747,
                N'UX_CSTEM_primary_active cannot be created because existing data contains multiple active primary emails for the same Customer.',
                1;

        END;


        CREATE UNIQUE NONCLUSTERED INDEX UX_CSTEM_primary_active
            ON customer.CustomerEmail
            (
                CSTEM_CST_id ASC
            )
            WHERE CSTEM_is_primary = 1
            AND CSTEM_is_active = 1
            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_CSTEM_primary_active';
        PRINT N'            Key Columns                    : CSTEM_CST_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : YES';
        PRINT N'            Filter                         : CSTEM_is_primary = 1 AND CSTEM_is_active = 1';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @CSTEM_PA_equivalent_count = 1
    BEGIN

        SELECT
            @CSTEM_PA_actual_name =
                index_name,

            @CSTEM_PA_actual_is_disabled =
                is_disabled,

            @CSTEM_PA_actual_data_space_name =
                data_space_name

        FROM @CSTEM_PA_equivalent_indexes;


        IF @CSTEM_PA_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Unique filtered index disabled : '
                + @CSTEM_PA_actual_name;

            PRINT N'            Expected Name                  : UX_CSTEM_primary_active';

            PRINT N'            Key Columns                    : CSTEM_CST_id';

            PRINT N'            Filter                         : CSTEM_is_primary = 1 AND CSTEM_is_active = 1';

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @CSTEM_PA_actual_name <>
                @CSTEM_PA_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';

            PRINT N'            Expected                       : UX_CSTEM_primary_active';

            PRINT N'            Actual                         : '
                + @CSTEM_PA_actual_name;

            PRINT N'            Action                         : Preserve existing index';

        END

        ELSE IF @CSTEM_PA_actual_data_space_name <>
                N'FG_CORE'
        BEGIN

            PRINT N'        [X] Index filegroup mismatch        : UX_CSTEM_primary_active';

            PRINT N'            Expected Filegroup             : FG_CORE';

            PRINT N'            Actual Data Space              : '
                + COALESCE
                (
                    @CSTEM_PA_actual_data_space_name,
                    N'<UNKNOWN>'
                );


            ;THROW 50746,
                N'Index UX_CSTEM_primary_active is not stored on FG_CORE.',
                1;

        END

        ELSE
        BEGIN

            PRINT N'        [•] Unique filtered index validated: UX_CSTEM_primary_active';
            PRINT N'            Key Columns                    : CSTEM_CST_id';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : YES';
            PRINT N'            Filter                         : CSTEM_is_primary = 1 AND CSTEM_is_active = 1';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @CSTEM_PA_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT
            (
                nvarchar(10),
                @CSTEM_PA_equivalent_count
            );

        PRINT N'            Expected Index                  : UX_CSTEM_primary_active';

        PRINT N'            Equivalent Indexes              : '
            + COALESCE
            (
                @CSTEM_PA_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement              : '
            + COALESCE
            (
                @CSTEM_PA_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                          : Preserve all indexes for manual review';

        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';