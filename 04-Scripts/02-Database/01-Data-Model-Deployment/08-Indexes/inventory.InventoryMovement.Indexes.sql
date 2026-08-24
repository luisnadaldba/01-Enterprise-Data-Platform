    PRINT N'';
    PRINT N'    ● inventory.InventoryMovement';
    PRINT N'';


    /*==============================================================================
        NONCLUSTERED INDEX: IX_INVMV_PRDVA_movement_at

        Purpose:
            Supports inventory movement history lookup by product variant and
            movement date.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : INVMV_PRDVA_id ASC,
                                INVMV_movement_at ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @INVMV_IX_expected_name               sysname;
    DECLARE @INVMV_IX_expected_exists             bit;
    DECLARE @INVMV_IX_expected_is_equivalent      bit;

    DECLARE @INVMV_IX_actual_name                 sysname;
    DECLARE @INVMV_IX_actual_type_desc            nvarchar(60);
    DECLARE @INVMV_IX_actual_is_unique            bit;
    DECLARE @INVMV_IX_actual_is_disabled          bit;
    DECLARE @INVMV_IX_actual_data_space           sysname;
    DECLARE @INVMV_IX_actual_keys                 nvarchar(4000);
    DECLARE @INVMV_IX_actual_includes             nvarchar(4000);
    DECLARE @INVMV_IX_actual_has_filter           bit;
    DECLARE @INVMV_IX_actual_filter               nvarchar(4000);

    DECLARE @INVMV_IX_equivalent_count            int;
    DECLARE @INVMV_IX_equivalent_names            nvarchar(4000);
    DECLARE @INVMV_IX_equivalent_details          nvarchar(4000);


    SET @INVMV_IX_expected_name =
        N'IX_INVMV_PRDVA_movement_at';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Index dependency missing        : inventory.InventoryMovement';

        ;THROW 50390,
            N'Index IX_INVMV_PRDVA_movement_at cannot be deployed because inventory.InventoryMovement does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'inventory.InventoryMovement',
        N'INVMV_PRDVA_id'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : INVMV_PRDVA_id';

        ;THROW 50391,
            N'Index IX_INVMV_PRDVA_movement_at cannot be deployed because INVMV_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'inventory.InventoryMovement',
        N'INVMV_movement_at'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Index column missing            : INVMV_movement_at';

        ;THROW 50392,
            N'Index IX_INVMV_PRDVA_movement_at cannot be deployed because INVMV_movement_at does not exist.',
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

        ;THROW 50393,
            N'Index IX_INVMV_PRDVA_movement_at cannot be deployed because FG_CORE does not exist.',
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
            - Exactly two key columns
            - Key 1 = INVMV_PRDVA_id ASC
            - Key 2 = INVMV_movement_at ASC
            - No INCLUDE columns
            - No filter

        Physical placement on FG_CORE is validated separately.
    ==============================================================================*/

    DECLARE @INVMV_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @INVMV_IX_equivalent_indexes
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
            OBJECT_ID(N'inventory.InventoryMovement')

    AND i.type = 2

    AND i.is_unique = 0

    AND i.is_primary_key = 0

    AND i.is_unique_constraint = 0

    AND i.is_hypothetical = 0

    AND i.has_filter = 0

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

    /* Key 1 = INVMV_PRDVA_id ASC */
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
                N'INVMV_PRDVA_id'
    )

    /* Key 2 = INVMV_movement_at ASC */
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
                N'INVMV_movement_at'
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
        @INVMV_IX_equivalent_count =
            COUNT(*)

    FROM @INVMV_IX_equivalent_indexes;


    SELECT
        @INVMV_IX_equivalent_names =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                ),
                N', '
            )

    FROM @INVMV_IX_equivalent_indexes;


    SELECT
        @INVMV_IX_equivalent_details =
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

    FROM @INVMV_IX_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @INVMV_IX_expected_exists =
        0;

    SET @INVMV_IX_expected_is_equivalent =
        0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND i.name =
                @INVMV_IX_expected_name
    )
    BEGIN

        SET @INVMV_IX_expected_exists =
            1;


        SELECT
            @INVMV_IX_actual_name =
                i.name,

            @INVMV_IX_actual_type_desc =
                i.type_desc,

            @INVMV_IX_actual_is_unique =
                i.is_unique,

            @INVMV_IX_actual_is_disabled =
                i.is_disabled,

            @INVMV_IX_actual_data_space =
                ds.name,

            @INVMV_IX_actual_has_filter =
                i.has_filter,

            @INVMV_IX_actual_filter =
                i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND i.name =
                @INVMV_IX_expected_name;


        SELECT
            @INVMV_IX_actual_keys =
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
                OBJECT_ID(N'inventory.InventoryMovement')

        AND i.name =
                @INVMV_IX_expected_name;


        SELECT
            @INVMV_IX_actual_includes =
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
                OBJECT_ID(N'inventory.InventoryMovement')

        AND i.name =
                @INVMV_IX_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @INVMV_IX_equivalent_indexes

            WHERE index_name =
                    @INVMV_IX_expected_name
        )
        BEGIN

            SET @INVMV_IX_expected_is_equivalent =
                1;

        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @INVMV_IX_expected_exists = 1
    AND @INVMV_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_INVMV_PRDVA_movement_at';

        PRINT N'            Expected Type                   : NONCLUSTERED';

        PRINT N'            Actual Type                     : '
            + COALESCE
            (
                @INVMV_IX_actual_type_desc,
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Unique                 : 0';

        PRINT N'            Actual Unique                   : '
            + COALESCE
            (
                CONVERT
                (
                    nvarchar(1),
                    @INVMV_IX_actual_is_unique
                ),
                N'<UNKNOWN>'
            );

        PRINT N'            Expected Key Columns            : INVMV_PRDVA_id ASC, INVMV_movement_at ASC';

        PRINT N'            Actual Key Columns              : '
            + COALESCE
            (
                @INVMV_IX_actual_keys,
                N'<NONE>'
            );

        PRINT N'            Expected Included Columns       : NONE';

        PRINT N'            Actual Included Columns         : '
            + COALESCE
            (
                @INVMV_IX_actual_includes,
                N'NONE'
            );

        PRINT N'            Expected Filter                 : NONE';

        PRINT N'            Actual Filter                   : '
            + COALESCE
            (
                @INVMV_IX_actual_filter,
                N'NONE'
            );

        PRINT N'            Expected Filegroup              : FG_CORE';

        PRINT N'            Actual Filegroup                : '
            + COALESCE
            (
                @INVMV_IX_actual_data_space,
                N'<UNKNOWN>'
            );

        PRINT N'            Existing index was preserved for review.';


        ;THROW 50394,
            N'Index IX_INVMV_PRDVA_movement_at exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @INVMV_IX_expected_exists = 0
    AND @INVMV_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_INVMV_PRDVA_movement_at
            ON inventory.InventoryMovement
            (
                INVMV_PRDVA_id ASC,
                INVMV_movement_at ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_INVMV_PRDVA_movement_at';
        PRINT N'            Key Columns                    : INVMV_PRDVA_id, INVMV_movement_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
    ==============================================================================*/

    ELSE IF @INVMV_IX_equivalent_count = 1
    BEGIN

        SELECT
            @INVMV_IX_actual_name =
                index_name,

            @INVMV_IX_actual_is_disabled =
                is_disabled,

            @INVMV_IX_actual_data_space =
                data_space_name

        FROM @INVMV_IX_equivalent_indexes;


        /*--------------------------------------------------------------------------
            EQUIVALENT INDEX IS DISABLED
        --------------------------------------------------------------------------*/

        IF @INVMV_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @INVMV_IX_actual_name;

            PRINT N'            Expected Name                  : IX_INVMV_PRDVA_movement_at';

            PRINT N'            Key Columns                    : INVMV_PRDVA_id, INVMV_movement_at';

            PRINT N'            Existing index was preserved for review.';

        END


        /*--------------------------------------------------------------------------
            CORRECT STRUCTURE EXISTS WITH DIFFERENT PHYSICAL PLACEMENT
        --------------------------------------------------------------------------*/

        ELSE IF @INVMV_IX_actual_data_space <>
                N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';

            PRINT N'            Index                          : '
                + @INVMV_IX_actual_name;

            PRINT N'            Expected Filegroup             : FG_CORE';

            PRINT N'            Actual Filegroup               : '
                + COALESCE
                (
                    @INVMV_IX_actual_data_space,
                    N'<UNKNOWN>'
                );

            PRINT N'            Existing index was preserved for review.';

        END


        /*--------------------------------------------------------------------------
            CORRECT STRUCTURE EXISTS WITH DIFFERENT NAME
        --------------------------------------------------------------------------*/

        ELSE IF @INVMV_IX_actual_name <>
                @INVMV_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';

            PRINT N'            Expected                       : IX_INVMV_PRDVA_movement_at';

            PRINT N'            Actual                         : '
                + @INVMV_IX_actual_name;

            PRINT N'            Key Columns                    : INVMV_PRDVA_id, INVMV_movement_at';

            PRINT N'            Action                         : Preserve existing index';

        END


        /*--------------------------------------------------------------------------
            EXPECTED INDEX EXISTS AND IS VALID
        --------------------------------------------------------------------------*/

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_INVMV_PRDVA_movement_at';
            PRINT N'            Key Columns                    : INVMV_PRDVA_id, INVMV_movement_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    /*==============================================================================
        MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST
    ==============================================================================*/

    ELSE IF @INVMV_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT
            (
                nvarchar(10),
                @INVMV_IX_equivalent_count
            );

        PRINT N'            Expected Index                  : IX_INVMV_PRDVA_movement_at';

        PRINT N'            Equivalent Indexes              : '
            + COALESCE
            (
                @INVMV_IX_equivalent_names,
                N'<UNKNOWN>'
            );

        PRINT N'            Physical Placement              : '
            + COALESCE
            (
                @INVMV_IX_equivalent_details,
                N'<UNKNOWN>'
            );

        PRINT N'            Action                          : Preserve all indexes for manual review';

        PRINT N'            Automatic removal               : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';