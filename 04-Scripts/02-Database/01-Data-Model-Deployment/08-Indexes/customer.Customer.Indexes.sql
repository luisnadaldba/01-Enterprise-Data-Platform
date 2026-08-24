    PRINT N'';
    PRINT N'    ● customer.Customer';
    PRINT N'';


    /*==============================================================================
        NONCLUSTERED INDEX: IX_CST_name

        Purpose:
            Supports customer lookup and ordered access by customer name.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : CST_name ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @CST_IX_expected_name               sysname;
    DECLARE @CST_IX_expected_exists             bit;
    DECLARE @CST_IX_expected_is_equivalent      bit;

    DECLARE @CST_IX_actual_name                 sysname;
    DECLARE @CST_IX_actual_type_desc            nvarchar(60);
    DECLARE @CST_IX_actual_is_unique            bit;
    DECLARE @CST_IX_actual_is_disabled          bit;
    DECLARE @CST_IX_actual_data_space           sysname;
    DECLARE @CST_IX_actual_keys                 nvarchar(4000);
    DECLARE @CST_IX_actual_includes             nvarchar(4000);
    DECLARE @CST_IX_actual_has_filter           bit;
    DECLARE @CST_IX_actual_filter               nvarchar(4000);

    DECLARE @CST_IX_equivalent_count            int;
    DECLARE @CST_IX_equivalent_names            nvarchar(4000);
    DECLARE @CST_IX_equivalent_details          nvarchar(4000);


    SET @CST_IX_expected_name =
        N'IX_CST_name';


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES

        Structural equivalence means:
            - Nonclustered
            - Nonunique
            - Not PK
            - Not UNIQUE CONSTRAINT
            - Not hypothetical
            - Exactly one key column
            - Key 1 = CST_name ASC
            - No INCLUDE columns
            - No filter
    ==============================================================================*/

    DECLARE @CST_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @CST_IX_equivalent_indexes
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
        ON ds.data_space_id =
            i.data_space_id

    WHERE i.object_id =
            OBJECT_ID(N'customer.Customer')

    AND i.type = 2

    AND i.is_unique = 0

    AND i.is_primary_key = 0

    AND i.is_unique_constraint = 0

    AND i.is_hypothetical = 0

    AND i.has_filter = 0

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

    /* Key 1 = CST_name ASC */
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
                N'CST_name'
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
    );


    SELECT
        @CST_IX_equivalent_count =
            COUNT(*)

    FROM @CST_IX_equivalent_indexes;


    SELECT
        @CST_IX_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @CST_IX_equivalent_indexes;


    SELECT
        @CST_IX_equivalent_details =
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

    FROM @CST_IX_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @CST_IX_expected_exists =
        0;

    SET @CST_IX_expected_is_equivalent =
        0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'customer.Customer')

        AND i.name =
                @CST_IX_expected_name
    )
    BEGIN

        SET @CST_IX_expected_exists =
            1;


        SELECT
            @CST_IX_actual_name =
                i.name,

            @CST_IX_actual_type_desc =
                i.type_desc,

            @CST_IX_actual_is_unique =
                i.is_unique,

            @CST_IX_actual_is_disabled =
                i.is_disabled,

            @CST_IX_actual_data_space =
                ds.name,

            @CST_IX_actual_has_filter =
                i.has_filter,

            @CST_IX_actual_filter =
                i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'customer.Customer')

        AND i.name =
                @CST_IX_expected_name;


        SELECT
            @CST_IX_actual_keys =
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
                OBJECT_ID(N'customer.Customer')

        AND i.name =
                @CST_IX_expected_name;


        SELECT
            @CST_IX_actual_includes =
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
                OBJECT_ID(N'customer.Customer')

        AND i.name =
                @CST_IX_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @CST_IX_equivalent_indexes

            WHERE index_name =
                @CST_IX_expected_name
        )
        BEGIN

            SET @CST_IX_expected_is_equivalent =
                1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @CST_IX_expected_exists = 1

    AND @CST_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_CST_name';

        PRINT N'            Expected Type                 : NONCLUSTERED';

        PRINT N'            Actual Type                   : '
            + COALESCE
            (
                @CST_IX_actual_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique               : 0';

        PRINT N'            Actual Unique                 : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @CST_IX_actual_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns          : CST_name ASC';

        PRINT N'            Actual Key Columns            : '
            + COALESCE
            (
                @CST_IX_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns     : NONE';

        PRINT N'            Actual Included Columns       : '
            + COALESCE
            (
                @CST_IX_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter               : NONE';

        PRINT N'            Actual Filter                 : '
            + COALESCE
            (
                @CST_IX_actual_filter,
                N'NONE'
            );

        PRINT N'            Expected Filegroup            : FG_CORE';

        PRINT N'            Actual Filegroup              : '
            + COALESCE
            (
                @CST_IX_actual_data_space,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50390,
            N'Index IX_CST_name exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @CST_IX_expected_exists = 0

    AND @CST_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_CST_name
            ON customer.Customer
            (
                CST_name ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_CST_name';
        PRINT N'            Key Columns                    : CST_name';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @CST_IX_equivalent_count = 1
    BEGIN

        SELECT
            @CST_IX_actual_name =
                index_name,

            @CST_IX_actual_is_disabled =
                is_disabled,

            @CST_IX_actual_data_space =
                data_space_name

        FROM @CST_IX_equivalent_indexes;


        IF @CST_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @CST_IX_actual_name;

            PRINT N'            Expected Name                 : IX_CST_name';

            PRINT N'            Key Columns                   : CST_name';

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @CST_IX_actual_data_space <>
            N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';

            PRINT N'            Index                         : '
                + @CST_IX_actual_name;

            PRINT N'            Expected Filegroup            : FG_CORE';

            PRINT N'            Actual Filegroup              : '
                + COALESCE
                (
                    @CST_IX_actual_data_space,
                    N'<UNKNOWN>'
                );

            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @CST_IX_actual_name <>
            @CST_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';

            PRINT N'            Expected                     : IX_CST_name';

            PRINT N'            Actual                       : '
                + @CST_IX_actual_name;

            PRINT N'            Key Columns                   : CST_name';

            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_CST_name';
            PRINT N'            Key Columns                    : CST_name';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @CST_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT
            (
                nvarchar(10),
                @CST_IX_equivalent_count
            );

        PRINT N'            Expected Index                : IX_CST_name';

        PRINT N'            Equivalent Indexes            : '
            + COALESCE
            (
                @CST_IX_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement            : '
            + COALESCE
            (
                @CST_IX_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                        : Preserve all indexes for manual review';

        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';