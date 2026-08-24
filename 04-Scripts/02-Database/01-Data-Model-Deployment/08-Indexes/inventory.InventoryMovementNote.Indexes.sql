    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementNote';
    PRINT N'';


    /*==============================================================================
        NONCLUSTERED INDEX: IX_INVMN_INVMV

        Purpose:
            Supports lookup of all notes associated with an inventory movement.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : INVMN_INVMV_id ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @INVMN_IX_expected_name               sysname;
    DECLARE @INVMN_IX_expected_exists             bit;
    DECLARE @INVMN_IX_expected_is_equivalent      bit;

    DECLARE @INVMN_IX_actual_name                 sysname;
    DECLARE @INVMN_IX_actual_type_desc            nvarchar(60);
    DECLARE @INVMN_IX_actual_is_unique            bit;
    DECLARE @INVMN_IX_actual_is_disabled          bit;
    DECLARE @INVMN_IX_actual_data_space           sysname;
    DECLARE @INVMN_IX_actual_keys                 nvarchar(4000);
    DECLARE @INVMN_IX_actual_includes             nvarchar(4000);
    DECLARE @INVMN_IX_actual_has_filter           bit;
    DECLARE @INVMN_IX_actual_filter               nvarchar(4000);

    DECLARE @INVMN_IX_equivalent_count            int;
    DECLARE @INVMN_IX_equivalent_names            nvarchar(4000);
    DECLARE @INVMN_IX_equivalent_details          nvarchar(4000);


    SET @INVMN_IX_expected_name =
        N'IX_INVMN_INVMV';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovementNote', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Index dependency missing        : inventory.InventoryMovementNote';

        ;THROW 51026,
            N'Index IX_INVMN_INVMV cannot be deployed because inventory.InventoryMovementNote does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'inventory.InventoryMovementNote',
        N'INVMN_INVMV_id'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : INVMN_INVMV_id';

        ;THROW 51027,
            N'Index IX_INVMN_INVMV cannot be deployed because INVMN_INVMV_id does not exist.',
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

        ;THROW 51028,
            N'Index IX_INVMN_INVMV cannot be deployed because FG_CORE does not exist.',
            1;

    END;


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES

        Structural equivalence means:
            - Nonclustered
            - Nonunique
            - Not PK
            - Not UNIQUE CONSTRAINT
            - Not hypothetical
            - Exactly one key column
            - Key 1 = INVMN_INVMV_id ASC
            - No INCLUDE columns
            - No filter

        Physical placement on FG_CORE is validated separately.
    ==============================================================================*/

    DECLARE @INVMN_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @INVMN_IX_equivalent_indexes
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
            OBJECT_ID(N'inventory.InventoryMovementNote')

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

    /* Key 1 = INVMN_INVMV_id ASC */
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
                N'INVMN_INVMV_id'
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
        @INVMN_IX_equivalent_count =
            COUNT(*)

    FROM @INVMN_IX_equivalent_indexes;


    SELECT
        @INVMN_IX_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @INVMN_IX_equivalent_indexes;


    SELECT
        @INVMN_IX_equivalent_details =
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

    FROM @INVMN_IX_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @INVMN_IX_expected_exists =
        0;

    SET @INVMN_IX_expected_is_equivalent =
        0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND i.name =
                @INVMN_IX_expected_name
    )
    BEGIN

        SET @INVMN_IX_expected_exists =
            1;


        SELECT
            @INVMN_IX_actual_name =
                i.name,

            @INVMN_IX_actual_type_desc =
                i.type_desc,

            @INVMN_IX_actual_is_unique =
                i.is_unique,

            @INVMN_IX_actual_is_disabled =
                i.is_disabled,

            @INVMN_IX_actual_data_space =
                ds.name,

            @INVMN_IX_actual_has_filter =
                i.has_filter,

            @INVMN_IX_actual_filter =
                i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND i.name =
                @INVMN_IX_expected_name;


        SELECT
            @INVMN_IX_actual_keys =
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND i.name =
                @INVMN_IX_expected_name;


        SELECT
            @INVMN_IX_actual_includes =
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND i.name =
                @INVMN_IX_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @INVMN_IX_equivalent_indexes

            WHERE index_name =
                    @INVMN_IX_expected_name
        )
        BEGIN

            SET @INVMN_IX_expected_is_equivalent =
                1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @INVMN_IX_expected_exists = 1
    AND @INVMN_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_INVMN_INVMV';

        PRINT N'            Expected Type                   : NONCLUSTERED';

        PRINT N'            Actual Type                     : '
            + COALESCE
            (
                @INVMN_IX_actual_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique                 : 0';

        PRINT N'            Actual Unique                   : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @INVMN_IX_actual_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns            : INVMN_INVMV_id ASC';

        PRINT N'            Actual Key Columns              : '
            + COALESCE
            (
                @INVMN_IX_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns       : NONE';

        PRINT N'            Actual Included Columns         : '
            + COALESCE
            (
                @INVMN_IX_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter                 : NONE';

        PRINT N'            Actual Filter                   : '
            + COALESCE
            (
                @INVMN_IX_actual_filter,
                N'NONE'
            );

        PRINT N'            Expected Filegroup              : FG_CORE';

        PRINT N'            Actual Filegroup                : '
            + COALESCE
            (
                @INVMN_IX_actual_data_space,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 51030,
            N'Index IX_INVMN_INVMV exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @INVMN_IX_expected_exists = 0
    AND @INVMN_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_INVMN_INVMV
            ON inventory.InventoryMovementNote
            (
                INVMN_INVMV_id ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_INVMN_INVMV';
        PRINT N'            Key Columns                    : INVMN_INVMV_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @INVMN_IX_equivalent_count = 1
    BEGIN

        SELECT
            @INVMN_IX_actual_name =
                index_name,

            @INVMN_IX_actual_is_disabled =
                is_disabled,

            @INVMN_IX_actual_data_space =
                data_space_name

        FROM @INVMN_IX_equivalent_indexes;


        /*--------------------------------------------------------------------------
            EQUIVALENT INDEX IS DISABLED
        --------------------------------------------------------------------------*/

        IF @INVMN_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @INVMN_IX_actual_name;

            PRINT N'            Expected Name                  : IX_INVMN_INVMV';

            PRINT N'            Key Columns                    : INVMN_INVMV_id';

            PRINT N'            Existing index was preserved for review.';

        END


        /*--------------------------------------------------------------------------
            CORRECT STRUCTURE EXISTS WITH DIFFERENT PHYSICAL PLACEMENT
        --------------------------------------------------------------------------*/

        ELSE IF @INVMN_IX_actual_data_space <>
                N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';

            PRINT N'            Index                          : '
                + @INVMN_IX_actual_name;

            PRINT N'            Expected Filegroup             : FG_CORE';

            PRINT N'            Actual Filegroup               : '
                + COALESCE
                (
                    @INVMN_IX_actual_data_space,
                    N'<UNKNOWN>'
                );

            PRINT N'            Existing index was preserved for review.';

        END


        /*--------------------------------------------------------------------------
            CORRECT STRUCTURE EXISTS WITH DIFFERENT NAME
        --------------------------------------------------------------------------*/

        ELSE IF @INVMN_IX_actual_name <>
                @INVMN_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';

            PRINT N'            Expected                       : IX_INVMN_INVMV';

            PRINT N'            Actual                         : '
                + @INVMN_IX_actual_name;

            PRINT N'            Key Columns                    : INVMN_INVMV_id';

            PRINT N'            Action                         : Preserve existing index';

        END


        /*--------------------------------------------------------------------------
            EXPECTED INDEX EXISTS AND IS VALID
        --------------------------------------------------------------------------*/

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_INVMN_INVMV';
            PRINT N'            Key Columns                    : INVMN_INVMV_id';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @INVMN_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT
            (
                nvarchar(10),
                @INVMN_IX_equivalent_count
            );

        PRINT N'            Expected Index                  : IX_INVMN_INVMV';

        PRINT N'            Equivalent Indexes              : '
            + COALESCE
            (
                @INVMN_IX_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement              : '
            + COALESCE
            (
                @INVMN_IX_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                          : Preserve all indexes for manual review';

        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';