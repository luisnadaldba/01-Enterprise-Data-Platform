    PRINT N'    payment.Payment';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        NONCLUSTERED INDEX: IX_PAY_TRN

        Purpose:
            Supports payment lookup by originating sales transaction.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : PAY_TRN_id ASC, PAY_transaction_at ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @PAY_TRN_IX_expected_name               sysname;
    DECLARE @PAY_TRN_IX_expected_exists             bit;
    DECLARE @PAY_TRN_IX_expected_is_equivalent      bit;

    DECLARE @PAY_TRN_IX_actual_name                 sysname;
    DECLARE @PAY_TRN_IX_actual_type_desc            nvarchar(60);
    DECLARE @PAY_TRN_IX_actual_is_unique            bit;
    DECLARE @PAY_TRN_IX_actual_is_disabled          bit;
    DECLARE @PAY_TRN_IX_actual_data_space           sysname;
    DECLARE @PAY_TRN_IX_actual_keys                 nvarchar(4000);
    DECLARE @PAY_TRN_IX_actual_includes             nvarchar(4000);
    DECLARE @PAY_TRN_IX_actual_has_filter           bit;
    DECLARE @PAY_TRN_IX_actual_filter               nvarchar(4000);

    DECLARE @PAY_TRN_IX_equivalent_count            int;
    DECLARE @PAY_TRN_IX_equivalent_names            nvarchar(4000);
    DECLARE @PAY_TRN_IX_equivalent_details          nvarchar(4000);


    SET @PAY_TRN_IX_expected_name =
        N'IX_PAY_TRN';


    DECLARE @PAY_TRN_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @PAY_TRN_IX_equivalent_indexes
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
            OBJECT_ID(N'payment.Payment')

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
        AND c.name = N'PAY_TRN_id'
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
        AND c.name = N'PAY_transaction_at'
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
        @PAY_TRN_IX_equivalent_count =
            COUNT(*)

    FROM @PAY_TRN_IX_equivalent_indexes;


    SELECT
        @PAY_TRN_IX_equivalent_names =
            STRING_AGG
            (
                CONVERT(nvarchar(max), index_name),
                N', '
            )

    FROM @PAY_TRN_IX_equivalent_indexes;


    SELECT
        @PAY_TRN_IX_equivalent_details =
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
                        WHEN is_disabled = 1
                            THEN N' [DISABLED]'
                        ELSE N''
                    END
                ),
                N', '
            )

    FROM @PAY_TRN_IX_equivalent_indexes;


    SET @PAY_TRN_IX_expected_exists = 0;
    SET @PAY_TRN_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_TRN_IX_expected_name
    )
    BEGIN

        SET @PAY_TRN_IX_expected_exists = 1;


        SELECT
            @PAY_TRN_IX_actual_name = i.name,
            @PAY_TRN_IX_actual_type_desc = i.type_desc,
            @PAY_TRN_IX_actual_is_unique = i.is_unique,
            @PAY_TRN_IX_actual_is_disabled = i.is_disabled,
            @PAY_TRN_IX_actual_data_space = ds.name,
            @PAY_TRN_IX_actual_has_filter = i.has_filter,
            @PAY_TRN_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_TRN_IX_expected_name;


        SELECT
            @PAY_TRN_IX_actual_keys =
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
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_TRN_IX_expected_name;


        SELECT
            @PAY_TRN_IX_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_TRN_IX_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @PAY_TRN_IX_equivalent_indexes

            WHERE index_name =
                @PAY_TRN_IX_expected_name
        )
        BEGIN

            SET @PAY_TRN_IX_expected_is_equivalent = 1;

        END;

    END;


    IF @PAY_TRN_IX_expected_exists = 1
    AND @PAY_TRN_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_PAY_TRN';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@PAY_TRN_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @PAY_TRN_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : PAY_TRN_id ASC, PAY_transaction_at ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@PAY_TRN_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : NONE';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@PAY_TRN_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@PAY_TRN_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@PAY_TRN_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50980,
            N'Index IX_PAY_TRN exists but does not match the expected definition.',
            1;

    END;


    IF @PAY_TRN_IX_expected_exists = 0
    AND @PAY_TRN_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_PAY_TRN
            ON payment.Payment
            (
                PAY_TRN_id ASC,
                PAY_transaction_at ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_PAY_TRN';
        PRINT N'            Key Columns                    : PAY_TRN_id, PAY_transaction_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    ELSE IF @PAY_TRN_IX_equivalent_count = 1
    BEGIN

        SELECT
            @PAY_TRN_IX_actual_name = index_name,
            @PAY_TRN_IX_actual_is_disabled = is_disabled,
            @PAY_TRN_IX_actual_data_space = data_space_name

        FROM @PAY_TRN_IX_equivalent_indexes;


        IF @PAY_TRN_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @PAY_TRN_IX_actual_name;
            PRINT N'            Expected Name                 : IX_PAY_TRN';
            PRINT N'            Key Columns                   : PAY_TRN_id, PAY_transaction_at';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAY_TRN_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @PAY_TRN_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@PAY_TRN_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAY_TRN_IX_actual_name <> @PAY_TRN_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_PAY_TRN';
            PRINT N'            Actual                       : '
                + @PAY_TRN_IX_actual_name;
            PRINT N'            Key Columns                   : PAY_TRN_id, PAY_transaction_at';
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_PAY_TRN';
            PRINT N'            Key Columns                    : PAY_TRN_id, PAY_transaction_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    ELSE IF @PAY_TRN_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @PAY_TRN_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_PAY_TRN';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@PAY_TRN_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@PAY_TRN_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    /*==============================================================================
        NONCLUSTERED INDEX: IX_PAY_updated_at

        Purpose:
            Supports incremental extraction of payment rows by most recent modification time.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : PAY_updated_at ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @PAY_UPD_IX_expected_name               sysname;
    DECLARE @PAY_UPD_IX_expected_exists             bit;
    DECLARE @PAY_UPD_IX_expected_is_equivalent      bit;

    DECLARE @PAY_UPD_IX_actual_name                 sysname;
    DECLARE @PAY_UPD_IX_actual_type_desc            nvarchar(60);
    DECLARE @PAY_UPD_IX_actual_is_unique            bit;
    DECLARE @PAY_UPD_IX_actual_is_disabled          bit;
    DECLARE @PAY_UPD_IX_actual_data_space           sysname;
    DECLARE @PAY_UPD_IX_actual_keys                 nvarchar(4000);
    DECLARE @PAY_UPD_IX_actual_includes             nvarchar(4000);
    DECLARE @PAY_UPD_IX_actual_has_filter           bit;
    DECLARE @PAY_UPD_IX_actual_filter               nvarchar(4000);

    DECLARE @PAY_UPD_IX_equivalent_count            int;
    DECLARE @PAY_UPD_IX_equivalent_names            nvarchar(4000);
    DECLARE @PAY_UPD_IX_equivalent_details          nvarchar(4000);


    SET @PAY_UPD_IX_expected_name =
        N'IX_PAY_updated_at';


    DECLARE @PAY_UPD_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @PAY_UPD_IX_equivalent_indexes
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
            OBJECT_ID(N'payment.Payment')

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
        AND c.name = N'PAY_updated_at'
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
        @PAY_UPD_IX_equivalent_count =
            COUNT(*)

    FROM @PAY_UPD_IX_equivalent_indexes;


    SELECT
        @PAY_UPD_IX_equivalent_names =
            STRING_AGG
            (
                CONVERT(nvarchar(max), index_name),
                N', '
            )

    FROM @PAY_UPD_IX_equivalent_indexes;


    SELECT
        @PAY_UPD_IX_equivalent_details =
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
                        WHEN is_disabled = 1
                            THEN N' [DISABLED]'
                        ELSE N''
                    END
                ),
                N', '
            )

    FROM @PAY_UPD_IX_equivalent_indexes;


    SET @PAY_UPD_IX_expected_exists = 0;
    SET @PAY_UPD_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_UPD_IX_expected_name
    )
    BEGIN

        SET @PAY_UPD_IX_expected_exists = 1;


        SELECT
            @PAY_UPD_IX_actual_name = i.name,
            @PAY_UPD_IX_actual_type_desc = i.type_desc,
            @PAY_UPD_IX_actual_is_unique = i.is_unique,
            @PAY_UPD_IX_actual_is_disabled = i.is_disabled,
            @PAY_UPD_IX_actual_data_space = ds.name,
            @PAY_UPD_IX_actual_has_filter = i.has_filter,
            @PAY_UPD_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_UPD_IX_expected_name;


        SELECT
            @PAY_UPD_IX_actual_keys =
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
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_UPD_IX_expected_name;


        SELECT
            @PAY_UPD_IX_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP
                (
                    ORDER BY ic.index_column_id
                )

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.Payment')

        AND i.name =
                @PAY_UPD_IX_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @PAY_UPD_IX_equivalent_indexes

            WHERE index_name =
                @PAY_UPD_IX_expected_name
        )
        BEGIN

            SET @PAY_UPD_IX_expected_is_equivalent = 1;

        END;

    END;


    IF @PAY_UPD_IX_expected_exists = 1
    AND @PAY_UPD_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_PAY_updated_at';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@PAY_UPD_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @PAY_UPD_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : PAY_updated_at ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@PAY_UPD_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : NONE';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@PAY_UPD_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@PAY_UPD_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@PAY_UPD_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50981,
            N'Index IX_PAY_updated_at exists but does not match the expected definition.',
            1;

    END;


    IF @PAY_UPD_IX_expected_exists = 0
    AND @PAY_UPD_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_PAY_updated_at
            ON payment.Payment
            (
                PAY_updated_at ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_PAY_updated_at';
        PRINT N'            Key Columns                    : PAY_updated_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    ELSE IF @PAY_UPD_IX_equivalent_count = 1
    BEGIN

        SELECT
            @PAY_UPD_IX_actual_name = index_name,
            @PAY_UPD_IX_actual_is_disabled = is_disabled,
            @PAY_UPD_IX_actual_data_space = data_space_name

        FROM @PAY_UPD_IX_equivalent_indexes;


        IF @PAY_UPD_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @PAY_UPD_IX_actual_name;
            PRINT N'            Expected Name                 : IX_PAY_updated_at';
            PRINT N'            Key Columns                   : PAY_updated_at';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAY_UPD_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @PAY_UPD_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@PAY_UPD_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAY_UPD_IX_actual_name <> @PAY_UPD_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_PAY_updated_at';
            PRINT N'            Actual                       : '
                + @PAY_UPD_IX_actual_name;
            PRINT N'            Key Columns                   : PAY_updated_at';
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_PAY_updated_at';
            PRINT N'            Key Columns                    : PAY_updated_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END;


    ELSE IF @PAY_UPD_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @PAY_UPD_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_PAY_updated_at';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@PAY_UPD_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@PAY_UPD_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    PRINT N'';