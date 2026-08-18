    PRINT N'    inventory.InventoryReservation';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        NONCLUSTERED INDEX: IX_INVRE_PRDVA_INVRS

        Purpose:
            Supports inventory reservation lookup by product variant and
            reservation status.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : INVRE_PRDVA_id ASC, INVRE_INVRS_id ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @INVRE_PRDVA_IX_expected_name               sysname;
    DECLARE @INVRE_PRDVA_IX_expected_exists             bit;
    DECLARE @INVRE_PRDVA_IX_expected_is_equivalent      bit;

    DECLARE @INVRE_PRDVA_IX_actual_name                 sysname;
    DECLARE @INVRE_PRDVA_IX_actual_type_desc            nvarchar(60);
    DECLARE @INVRE_PRDVA_IX_actual_is_unique            bit;
    DECLARE @INVRE_PRDVA_IX_actual_is_disabled          bit;
    DECLARE @INVRE_PRDVA_IX_actual_data_space           sysname;
    DECLARE @INVRE_PRDVA_IX_actual_keys                 nvarchar(4000);
    DECLARE @INVRE_PRDVA_IX_actual_includes             nvarchar(4000);
    DECLARE @INVRE_PRDVA_IX_actual_filter               nvarchar(4000);

    DECLARE @INVRE_PRDVA_IX_equivalent_count            int;
    DECLARE @INVRE_PRDVA_IX_equivalent_names            nvarchar(4000);
    DECLARE @INVRE_PRDVA_IX_equivalent_details          nvarchar(4000);


    SET @INVRE_PRDVA_IX_expected_name =
        N'IX_INVRE_PRDVA_INVRS';


    DECLARE @INVRE_PRDVA_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @INVRE_PRDVA_IX_equivalent_indexes
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
            OBJECT_ID(N'inventory.InventoryReservation')

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
        AND c.name = N'INVRE_PRDVA_id'
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
        AND ic.is_descending_key = 0
        AND c.name = N'INVRE_INVRS_id'
    )

    AND NOT EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
    );


    SELECT
        @INVRE_PRDVA_IX_equivalent_count = COUNT(*)
    FROM @INVRE_PRDVA_IX_equivalent_indexes;


    SELECT
        @INVRE_PRDVA_IX_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @INVRE_PRDVA_IX_equivalent_indexes;


    SELECT
        @INVRE_PRDVA_IX_equivalent_details =
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
    FROM @INVRE_PRDVA_IX_equivalent_indexes;


    SET @INVRE_PRDVA_IX_expected_exists = 0;
    SET @INVRE_PRDVA_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND name = @INVRE_PRDVA_IX_expected_name
    )
    BEGIN

        SET @INVRE_PRDVA_IX_expected_exists = 1;


        SELECT
            @INVRE_PRDVA_IX_actual_name = i.name,
            @INVRE_PRDVA_IX_actual_type_desc = i.type_desc,
            @INVRE_PRDVA_IX_actual_is_unique = i.is_unique,
            @INVRE_PRDVA_IX_actual_is_disabled = i.is_disabled,
            @INVRE_PRDVA_IX_actual_data_space = ds.name,
            @INVRE_PRDVA_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name =
                @INVRE_PRDVA_IX_expected_name;


        SELECT
            @INVRE_PRDVA_IX_actual_keys =
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
            ON ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name =
                @INVRE_PRDVA_IX_expected_name;


        SELECT
            @INVRE_PRDVA_IX_actual_includes =
                STRING_AGG(CONVERT(nvarchar(max), c.name), N', ')
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name =
                @INVRE_PRDVA_IX_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @INVRE_PRDVA_IX_equivalent_indexes
            WHERE index_name =
                    @INVRE_PRDVA_IX_expected_name
        )
        BEGIN
            SET @INVRE_PRDVA_IX_expected_is_equivalent = 1;
        END;

    END;


    IF @INVRE_PRDVA_IX_expected_exists = 1
    AND @INVRE_PRDVA_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_INVRE_PRDVA_INVRS';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@INVRE_PRDVA_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @INVRE_PRDVA_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : INVRE_PRDVA_id ASC, INVRE_INVRS_id ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@INVRE_PRDVA_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : NONE';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@INVRE_PRDVA_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@INVRE_PRDVA_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@INVRE_PRDVA_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50990,
            N'Index IX_INVRE_PRDVA_INVRS exists but does not match the expected definition.',
            1;

    END;


    IF @INVRE_PRDVA_IX_expected_exists = 0
    AND @INVRE_PRDVA_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_INVRE_PRDVA_INVRS
            ON inventory.InventoryReservation
            (
                INVRE_PRDVA_id ASC,
                INVRE_INVRS_id ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_INVRE_PRDVA_INVRS';
        PRINT N'            Key Columns                    : INVRE_PRDVA_id, INVRE_INVRS_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @INVRE_PRDVA_IX_equivalent_count = 1
    BEGIN

        SELECT
            @INVRE_PRDVA_IX_actual_name = index_name,
            @INVRE_PRDVA_IX_actual_is_disabled = is_disabled,
            @INVRE_PRDVA_IX_actual_data_space = data_space_name

        FROM @INVRE_PRDVA_IX_equivalent_indexes;


        IF @INVRE_PRDVA_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @INVRE_PRDVA_IX_actual_name;
            PRINT N'            Expected Name                 : IX_INVRE_PRDVA_INVRS';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @INVRE_PRDVA_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @INVRE_PRDVA_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@INVRE_PRDVA_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @INVRE_PRDVA_IX_actual_name <>
                @INVRE_PRDVA_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_INVRE_PRDVA_INVRS';
            PRINT N'            Actual                       : '
                + @INVRE_PRDVA_IX_actual_name;
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_INVRE_PRDVA_INVRS';
            PRINT N'            Key Columns                    : INVRE_PRDVA_id, INVRE_INVRS_id';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @INVRE_PRDVA_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @INVRE_PRDVA_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_INVRE_PRDVA_INVRS';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@INVRE_PRDVA_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@INVRE_PRDVA_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    /*==============================================================================
        NONCLUSTERED INDEX: IX_INVRE_INVRS_expires_at

        Purpose:
            Supports operational lookup of reservations by status and expiration
            time, especially reservations that are due to expire.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : INVRE_INVRS_id ASC, INVRE_expires_at ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @INVRE_EXP_IX_expected_name               sysname;
    DECLARE @INVRE_EXP_IX_expected_exists             bit;
    DECLARE @INVRE_EXP_IX_expected_is_equivalent      bit;

    DECLARE @INVRE_EXP_IX_actual_name                 sysname;
    DECLARE @INVRE_EXP_IX_actual_type_desc            nvarchar(60);
    DECLARE @INVRE_EXP_IX_actual_is_unique            bit;
    DECLARE @INVRE_EXP_IX_actual_is_disabled          bit;
    DECLARE @INVRE_EXP_IX_actual_data_space           sysname;
    DECLARE @INVRE_EXP_IX_actual_keys                 nvarchar(4000);
    DECLARE @INVRE_EXP_IX_actual_includes             nvarchar(4000);
    DECLARE @INVRE_EXP_IX_actual_filter               nvarchar(4000);

    DECLARE @INVRE_EXP_IX_equivalent_count            int;
    DECLARE @INVRE_EXP_IX_equivalent_names            nvarchar(4000);
    DECLARE @INVRE_EXP_IX_equivalent_details          nvarchar(4000);


    SET @INVRE_EXP_IX_expected_name =
        N'IX_INVRE_INVRS_expires_at';


    DECLARE @INVRE_EXP_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @INVRE_EXP_IX_equivalent_indexes
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
            OBJECT_ID(N'inventory.InventoryReservation')

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
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id

        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal = 1
        AND ic.is_descending_key = 0
        AND c.name = N'INVRE_INVRS_id'
    )

    AND EXISTS
    (
        SELECT 1

        FROM sys.index_columns AS ic

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id

        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal = 2
        AND ic.is_descending_key = 0
        AND c.name = N'INVRE_expires_at'
    )

    AND NOT EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
    );


    SELECT
        @INVRE_EXP_IX_equivalent_count = COUNT(*)
    FROM @INVRE_EXP_IX_equivalent_indexes;


    SELECT
        @INVRE_EXP_IX_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @INVRE_EXP_IX_equivalent_indexes;


    SELECT
        @INVRE_EXP_IX_equivalent_details =
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
    FROM @INVRE_EXP_IX_equivalent_indexes;


    SET @INVRE_EXP_IX_expected_exists = 0;
    SET @INVRE_EXP_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND name =
                @INVRE_EXP_IX_expected_name
    )
    BEGIN

        SET @INVRE_EXP_IX_expected_exists = 1;


        SELECT
            @INVRE_EXP_IX_actual_name = i.name,
            @INVRE_EXP_IX_actual_type_desc = i.type_desc,
            @INVRE_EXP_IX_actual_is_unique = i.is_unique,
            @INVRE_EXP_IX_actual_is_disabled = i.is_disabled,
            @INVRE_EXP_IX_actual_data_space = ds.name,
            @INVRE_EXP_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name =
                @INVRE_EXP_IX_expected_name;


        SELECT
            @INVRE_EXP_IX_actual_keys =
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
            ON ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name =
                @INVRE_EXP_IX_expected_name;


        SELECT
            @INVRE_EXP_IX_actual_includes =
                STRING_AGG(CONVERT(nvarchar(max), c.name), N', ')
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
        AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'inventory.InventoryReservation')
        AND i.name =
                @INVRE_EXP_IX_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @INVRE_EXP_IX_equivalent_indexes
            WHERE index_name =
                    @INVRE_EXP_IX_expected_name
        )
        BEGIN
            SET @INVRE_EXP_IX_expected_is_equivalent = 1;
        END;

    END;


    IF @INVRE_EXP_IX_expected_exists = 1
    AND @INVRE_EXP_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_INVRE_INVRS_expires_at';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@INVRE_EXP_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @INVRE_EXP_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : INVRE_INVRS_id ASC, INVRE_expires_at ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@INVRE_EXP_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : NONE';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@INVRE_EXP_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@INVRE_EXP_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@INVRE_EXP_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50991,
            N'Index IX_INVRE_INVRS_expires_at exists but does not match the expected definition.',
            1;

    END;


    IF @INVRE_EXP_IX_expected_exists = 0
    AND @INVRE_EXP_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_INVRE_INVRS_expires_at
            ON inventory.InventoryReservation
            (
                INVRE_INVRS_id ASC,
                INVRE_expires_at ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_INVRE_INVRS_expires_at';
        PRINT N'            Key Columns                    : INVRE_INVRS_id, INVRE_expires_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @INVRE_EXP_IX_equivalent_count = 1
    BEGIN

        SELECT
            @INVRE_EXP_IX_actual_name = index_name,
            @INVRE_EXP_IX_actual_is_disabled = is_disabled,
            @INVRE_EXP_IX_actual_data_space = data_space_name
        FROM @INVRE_EXP_IX_equivalent_indexes;


        IF @INVRE_EXP_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @INVRE_EXP_IX_actual_name;
            PRINT N'            Expected Name                 : IX_INVRE_INVRS_expires_at';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @INVRE_EXP_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @INVRE_EXP_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@INVRE_EXP_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @INVRE_EXP_IX_actual_name <>
                @INVRE_EXP_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_INVRE_INVRS_expires_at';
            PRINT N'            Actual                       : '
                + @INVRE_EXP_IX_actual_name;
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_INVRE_INVRS_expires_at';
            PRINT N'            Key Columns                    : INVRE_INVRS_id, INVRE_expires_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @INVRE_EXP_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @INVRE_EXP_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_INVRE_INVRS_expires_at';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@INVRE_EXP_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@INVRE_EXP_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    PRINT N'';