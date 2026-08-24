    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
    PRINT N'';


    /*==============================================================================
        NONCLUSTERED INDEX: IX_PAYRF_PAY

        Purpose:
            Supports refund lookup by payment, chronological refund history and aggregate refund validation.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : PAYRF_PAY_id ASC, PAYRF_refunded_at ASC
            Included Columns  : PAYRF_amount
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @PAYRF_PAY_IX_expected_name               sysname;
    DECLARE @PAYRF_PAY_IX_expected_exists             bit;
    DECLARE @PAYRF_PAY_IX_expected_is_equivalent      bit;

    DECLARE @PAYRF_PAY_IX_actual_name                 sysname;
    DECLARE @PAYRF_PAY_IX_actual_type_desc            nvarchar(60);
    DECLARE @PAYRF_PAY_IX_actual_is_unique            bit;
    DECLARE @PAYRF_PAY_IX_actual_is_disabled          bit;
    DECLARE @PAYRF_PAY_IX_actual_data_space           sysname;
    DECLARE @PAYRF_PAY_IX_actual_keys                 nvarchar(4000);
    DECLARE @PAYRF_PAY_IX_actual_includes             nvarchar(4000);
    DECLARE @PAYRF_PAY_IX_actual_filter               nvarchar(4000);

    DECLARE @PAYRF_PAY_IX_equivalent_count            int;
    DECLARE @PAYRF_PAY_IX_equivalent_names            nvarchar(4000);
    DECLARE @PAYRF_PAY_IX_equivalent_details          nvarchar(4000);


    SET @PAYRF_PAY_IX_expected_name = N'IX_PAYRF_PAY';


    DECLARE @PAYRF_PAY_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @PAYRF_PAY_IX_equivalent_indexes
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

    WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
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
        AND c.name = N'PAYRF_PAY_id'
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
        AND c.name = N'PAYRF_refunded_at'
    )

    AND
    (
        SELECT COUNT(*)
        FROM sys.index_columns AS ic
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
    ) = 1

    AND EXISTS
    (
        SELECT 1
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.is_included_column = 1
        AND c.name = N'PAYRF_amount'
    );


    SELECT
        @PAYRF_PAY_IX_equivalent_count = COUNT(*)
    FROM @PAYRF_PAY_IX_equivalent_indexes;


    SELECT
        @PAYRF_PAY_IX_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @PAYRF_PAY_IX_equivalent_indexes;


    SELECT
        @PAYRF_PAY_IX_equivalent_details =
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
    FROM @PAYRF_PAY_IX_equivalent_indexes;


    SET @PAYRF_PAY_IX_expected_exists = 0;
    SET @PAYRF_PAY_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_PAY_IX_expected_name
    )
    BEGIN

        SET @PAYRF_PAY_IX_expected_exists = 1;


        SELECT
            @PAYRF_PAY_IX_actual_name = i.name,
            @PAYRF_PAY_IX_actual_type_desc = i.type_desc,
            @PAYRF_PAY_IX_actual_is_unique = i.is_unique,
            @PAYRF_PAY_IX_actual_is_disabled = i.is_disabled,
            @PAYRF_PAY_IX_actual_data_space = ds.name,
            @PAYRF_PAY_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_PAY_IX_expected_name;


        SELECT
            @PAYRF_PAY_IX_actual_keys =
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
            ON ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_PAY_IX_expected_name;


        SELECT
            @PAYRF_PAY_IX_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.index_column_id)

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_PAY_IX_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @PAYRF_PAY_IX_equivalent_indexes
            WHERE index_name = @PAYRF_PAY_IX_expected_name
        )
        BEGIN

            SET @PAYRF_PAY_IX_expected_is_equivalent = 1;

        END;

    END;


    IF @PAYRF_PAY_IX_expected_exists = 1
    AND @PAYRF_PAY_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_PAYRF_PAY';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@PAYRF_PAY_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @PAYRF_PAY_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : PAYRF_PAY_id ASC, PAYRF_refunded_at ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@PAYRF_PAY_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : PAYRF_amount';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@PAYRF_PAY_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@PAYRF_PAY_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@PAYRF_PAY_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 51010,
            N'Index IX_PAYRF_PAY exists but does not match the expected definition.',
            1;

    END;


    IF @PAYRF_PAY_IX_expected_exists = 0
    AND @PAYRF_PAY_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_PAYRF_PAY
            ON payment.PaymentRefund
            (
                PAYRF_PAY_id ASC,
                PAYRF_refunded_at ASC
            )
            INCLUDE
            (
                PAYRF_amount
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_PAYRF_PAY';
        PRINT N'            Key Columns                    : PAYRF_PAY_id, PAYRF_refunded_at';
        PRINT N'            Included Columns               : PAYRF_amount';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @PAYRF_PAY_IX_equivalent_count = 1
    BEGIN

        SELECT
            @PAYRF_PAY_IX_actual_name = index_name,
            @PAYRF_PAY_IX_actual_is_disabled = is_disabled,
            @PAYRF_PAY_IX_actual_data_space = data_space_name
        FROM @PAYRF_PAY_IX_equivalent_indexes;


        IF @PAYRF_PAY_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @PAYRF_PAY_IX_actual_name;
            PRINT N'            Expected Name                 : IX_PAYRF_PAY';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAYRF_PAY_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @PAYRF_PAY_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@PAYRF_PAY_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAYRF_PAY_IX_actual_name <> @PAYRF_PAY_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_PAYRF_PAY';
            PRINT N'            Actual                       : '
                + @PAYRF_PAY_IX_actual_name;
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_PAYRF_PAY';
            PRINT N'            Key Columns                    : PAYRF_PAY_id, PAYRF_refunded_at';
            PRINT N'            Included Columns               : PAYRF_amount';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @PAYRF_PAY_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @PAYRF_PAY_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_PAYRF_PAY';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@PAYRF_PAY_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@PAYRF_PAY_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    /*==============================================================================
        NONCLUSTERED INDEX: IX_PAYRF_updated_at

        Purpose:
            Supports incremental extraction of refund rows by most recent modification time.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : PAYRF_updated_at ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @PAYRF_UPD_IX_expected_name               sysname;
    DECLARE @PAYRF_UPD_IX_expected_exists             bit;
    DECLARE @PAYRF_UPD_IX_expected_is_equivalent      bit;

    DECLARE @PAYRF_UPD_IX_actual_name                 sysname;
    DECLARE @PAYRF_UPD_IX_actual_type_desc            nvarchar(60);
    DECLARE @PAYRF_UPD_IX_actual_is_unique            bit;
    DECLARE @PAYRF_UPD_IX_actual_is_disabled          bit;
    DECLARE @PAYRF_UPD_IX_actual_data_space           sysname;
    DECLARE @PAYRF_UPD_IX_actual_keys                 nvarchar(4000);
    DECLARE @PAYRF_UPD_IX_actual_includes             nvarchar(4000);
    DECLARE @PAYRF_UPD_IX_actual_filter               nvarchar(4000);

    DECLARE @PAYRF_UPD_IX_equivalent_count            int;
    DECLARE @PAYRF_UPD_IX_equivalent_names            nvarchar(4000);
    DECLARE @PAYRF_UPD_IX_equivalent_details          nvarchar(4000);


    SET @PAYRF_UPD_IX_expected_name = N'IX_PAYRF_updated_at';


    DECLARE @PAYRF_UPD_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @PAYRF_UPD_IX_equivalent_indexes
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

    WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
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
            ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id
        WHERE ic.object_id = i.object_id
        AND ic.index_id = i.index_id
        AND ic.key_ordinal = 1
        AND ic.is_descending_key = 0
        AND c.name = N'PAYRF_updated_at'
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
        @PAYRF_UPD_IX_equivalent_count = COUNT(*)
    FROM @PAYRF_UPD_IX_equivalent_indexes;


    SELECT
        @PAYRF_UPD_IX_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @PAYRF_UPD_IX_equivalent_indexes;


    SELECT
        @PAYRF_UPD_IX_equivalent_details =
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
    FROM @PAYRF_UPD_IX_equivalent_indexes;


    SET @PAYRF_UPD_IX_expected_exists = 0;
    SET @PAYRF_UPD_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_UPD_IX_expected_name
    )
    BEGIN

        SET @PAYRF_UPD_IX_expected_exists = 1;


        SELECT
            @PAYRF_UPD_IX_actual_name = i.name,
            @PAYRF_UPD_IX_actual_type_desc = i.type_desc,
            @PAYRF_UPD_IX_actual_is_unique = i.is_unique,
            @PAYRF_UPD_IX_actual_is_disabled = i.is_disabled,
            @PAYRF_UPD_IX_actual_data_space = ds.name,
            @PAYRF_UPD_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_UPD_IX_expected_name;


        SELECT
            @PAYRF_UPD_IX_actual_keys =
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
            ON ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_UPD_IX_expected_name;


        SELECT
            @PAYRF_UPD_IX_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.index_column_id)

        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'payment.PaymentRefund')
        AND i.name = @PAYRF_UPD_IX_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @PAYRF_UPD_IX_equivalent_indexes
            WHERE index_name = @PAYRF_UPD_IX_expected_name
        )
        BEGIN

            SET @PAYRF_UPD_IX_expected_is_equivalent = 1;

        END;

    END;


    IF @PAYRF_UPD_IX_expected_exists = 1
    AND @PAYRF_UPD_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_PAYRF_updated_at';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@PAYRF_UPD_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @PAYRF_UPD_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : PAYRF_updated_at ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@PAYRF_UPD_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : NONE';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@PAYRF_UPD_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@PAYRF_UPD_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@PAYRF_UPD_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 51011,
            N'Index IX_PAYRF_updated_at exists but does not match the expected definition.',
            1;

    END;


    IF @PAYRF_UPD_IX_expected_exists = 0
    AND @PAYRF_UPD_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_PAYRF_updated_at
            ON payment.PaymentRefund
            (
                PAYRF_updated_at ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_PAYRF_updated_at';
        PRINT N'            Key Columns                    : PAYRF_updated_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @PAYRF_UPD_IX_equivalent_count = 1
    BEGIN

        SELECT
            @PAYRF_UPD_IX_actual_name = index_name,
            @PAYRF_UPD_IX_actual_is_disabled = is_disabled,
            @PAYRF_UPD_IX_actual_data_space = data_space_name
        FROM @PAYRF_UPD_IX_equivalent_indexes;


        IF @PAYRF_UPD_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @PAYRF_UPD_IX_actual_name;
            PRINT N'            Expected Name                 : IX_PAYRF_updated_at';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAYRF_UPD_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @PAYRF_UPD_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@PAYRF_UPD_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @PAYRF_UPD_IX_actual_name <> @PAYRF_UPD_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_PAYRF_updated_at';
            PRINT N'            Actual                       : '
                + @PAYRF_UPD_IX_actual_name;
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_PAYRF_updated_at';
            PRINT N'            Key Columns                    : PAYRF_updated_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @PAYRF_UPD_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @PAYRF_UPD_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_PAYRF_updated_at';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@PAYRF_UPD_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@PAYRF_UPD_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';