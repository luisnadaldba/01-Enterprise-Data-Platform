        PRINT N'    sales.TransactionItem';
        PRINT N'    --------------------------------------------------------------------------';


        /*==============================================================================
            INDEX: IX_TRNIT_TRN_transaction_at
        ==============================================================================*/

        DECLARE @TRNIT_index_expected_name                sysname;
        DECLARE @TRNIT_index_expected_exists              bit;
        DECLARE @TRNIT_index_expected_is_equivalent       bit;
        DECLARE @TRNIT_index_expected_type_desc           nvarchar(60);
        DECLARE @TRNIT_index_expected_is_unique           bit;
        DECLARE @TRNIT_index_expected_is_disabled         bit;
        DECLARE @TRNIT_index_expected_data_space_name     sysname;
        DECLARE @TRNIT_index_expected_actual_keys         nvarchar(4000);
        DECLARE @TRNIT_index_expected_actual_includes     nvarchar(4000);

        DECLARE @TRNIT_index_equivalent_count             int;
        DECLARE @TRNIT_index_equivalent_names             nvarchar(4000);
        DECLARE @TRNIT_index_equivalent_details           nvarchar(4000);

        DECLARE @TRNIT_index_actual_name                  sysname;
        DECLARE @TRNIT_index_actual_is_disabled           bit;
        DECLARE @TRNIT_index_actual_data_space_name       sysname;

        DECLARE @TRNIT_index_authoritative_name           sysname;
        DECLARE @TRNIT_index_authoritative_data_space     sysname;

        SET @TRNIT_index_expected_name = N'IX_TRNIT_TRN_transaction_at';


        /*==============================================================================
            COLLECT STRUCTURALLY EQUIVALENT INDEXES

            Structural equivalence means:
                - Nonclustered
                - Nonunique
                - Not hypothetical
                - Exactly two key columns
                - Key 1 = TRNIT_TRN_id ASC
                - Key 2 = TRNIT_transaction_at ASC
                - No INCLUDE columns

            Partition alignment is validated separately.
        ==============================================================================*/

        DECLARE @TRNIT_equivalent_indexes TABLE
        (
            index_name       sysname NOT NULL,
            is_disabled      bit     NOT NULL,
            data_space_name  sysname NULL
        );


        INSERT INTO @TRNIT_equivalent_indexes
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

        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.type = 2
        AND i.is_unique = 0
        AND i.is_hypothetical = 0

        /* Exactly two key columns */
        AND
        (
            SELECT COUNT(*)
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.key_ordinal > 0
        ) = 2

        /* Key 1: TRNIT_TRN_id ASC */
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
                AND c.name = N'TRNIT_TRN_id'
        )

        /* Key 2: TRNIT_transaction_at ASC */
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
                AND c.name = N'TRNIT_transaction_at'
        )

        /* No INCLUDE columns */
        AND NOT EXISTS
        (
            SELECT 1
            FROM sys.index_columns AS ic
            WHERE ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.is_included_column = 1
        );


        SELECT
            @TRNIT_index_equivalent_count = COUNT(*)
        FROM @TRNIT_equivalent_indexes;


        SELECT
            @TRNIT_index_equivalent_names =
                STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
        FROM @TRNIT_equivalent_indexes;


        SELECT
            @TRNIT_index_equivalent_details =
                STRING_AGG
                (
                    CONVERT
                    (
                        nvarchar(max),
                        index_name
                        + N' [' + COALESCE(data_space_name, N'<UNKNOWN>') + N']'
                        + CASE
                            WHEN is_disabled = 1
                                THEN N' [DISABLED]'
                            ELSE N''
                        END
                    ),
                    N', '
                )
        FROM @TRNIT_equivalent_indexes;


        /*==============================================================================
            IDENTIFY INDEX WITH EXPECTED NAME
        ==============================================================================*/

        SET @TRNIT_index_expected_exists = 0;
        SET @TRNIT_index_expected_is_equivalent = 0;


        IF EXISTS
        (
            SELECT 1
            FROM sys.indexes AS i
            WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
            AND i.name = @TRNIT_index_expected_name
        )
        BEGIN

            SET @TRNIT_index_expected_exists = 1;


            SELECT
                @TRNIT_index_expected_type_desc       = i.type_desc,
                @TRNIT_index_expected_is_unique       = i.is_unique,
                @TRNIT_index_expected_is_disabled     = i.is_disabled,
                @TRNIT_index_expected_data_space_name = ds.name
            FROM sys.indexes AS i

            LEFT JOIN sys.data_spaces AS ds
                ON ds.data_space_id = i.data_space_id

            WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
            AND i.name = @TRNIT_index_expected_name;


            SELECT
                @TRNIT_index_expected_actual_keys =
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
                    WITHIN GROUP (ORDER BY ic.key_ordinal)
            FROM sys.indexes AS i

            INNER JOIN sys.index_columns AS ic
                ON  ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.key_ordinal > 0

            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
            AND i.name = @TRNIT_index_expected_name;


            SELECT
                @TRNIT_index_expected_actual_includes =
                    STRING_AGG
                    (
                        CONVERT(nvarchar(max), c.name),
                        N', '
                    )
                    WITHIN GROUP (ORDER BY ic.index_column_id)
            FROM sys.indexes AS i

            INNER JOIN sys.index_columns AS ic
                ON  ic.object_id = i.object_id
                AND ic.index_id = i.index_id
                AND ic.is_included_column = 1

            INNER JOIN sys.columns AS c
                ON  c.object_id = ic.object_id
                AND c.column_id = ic.column_id

            WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
            AND i.name = @TRNIT_index_expected_name;


            IF EXISTS
            (
                SELECT 1
                FROM @TRNIT_equivalent_indexes
                WHERE index_name = @TRNIT_index_expected_name
            )
            BEGIN
                SET @TRNIT_index_expected_is_equivalent = 1;
            END;

        END;


        /*==============================================================================
            EXPECTED NAME EXISTS WITH WRONG STRUCTURE

            This is different from a naming divergence.

            The deterministic name exists, but it represents a different physical
            index definition. The deployment must preserve the existing index and
            stop rather than attempting to recreate or replace it automatically.
        ==============================================================================*/

        IF @TRNIT_index_expected_exists = 1
        AND @TRNIT_index_expected_is_equivalent = 0
        BEGIN

            PRINT N'        [X] Index definition mismatch        : IX_TRNIT_TRN_transaction_at';
            PRINT N'            Expected Type                   : NONCLUSTERED';
            PRINT N'            Actual Type                     : '
                + COALESCE(@TRNIT_index_expected_type_desc, N'<UNKNOWN>');
            PRINT N'            Expected Unique                 : 0';
            PRINT N'            Actual Unique                   : '
                + COALESCE(CONVERT(nvarchar(1), @TRNIT_index_expected_is_unique), N'<UNKNOWN>');
            PRINT N'            Expected Key Columns            : TRNIT_TRN_id ASC, TRNIT_transaction_at ASC';
            PRINT N'            Actual Key Columns              : '
                + COALESCE(@TRNIT_index_expected_actual_keys, N'<NONE>');
            PRINT N'            Expected Included Columns       : NONE';
            PRINT N'            Actual Included Columns         : '
                + COALESCE(@TRNIT_index_expected_actual_includes, N'NONE');
            PRINT N'            Existing index was preserved for review.';

            ;THROW 50072,
                N'Index IX_TRNIT_TRN_transaction_at exists but does not match the expected definition.',
                1;

        END;


        /*==============================================================================
            EXPECTED INDEX DOES NOT EXIST AND NO EQUIVALENT INDEX EXISTS
        ==============================================================================*/

        IF @TRNIT_index_expected_exists = 0
        AND @TRNIT_index_equivalent_count = 0
        BEGIN

            CREATE NONCLUSTERED INDEX IX_TRNIT_TRN_transaction_at
                ON sales.TransactionItem
                (
                    TRNIT_TRN_id,
                    TRNIT_transaction_at
                )
                ON PS_SALES_MONTHLY(TRNIT_transaction_at);


            PRINT N'        [+] Index added                    : IX_TRNIT_TRN_transaction_at';
            PRINT N'            Key Columns                    : TRNIT_TRN_id, TRNIT_transaction_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Partition Scheme               : PS_SALES_MONTHLY';
            PRINT N'            Partition Column               : TRNIT_transaction_at';


            SET @TRNIT_index_authoritative_name = N'IX_TRNIT_TRN_transaction_at';
            SET @TRNIT_index_authoritative_data_space = N'PS_SALES_MONTHLY';

        END;


        /*==============================================================================
            EXACTLY ONE STRUCTURALLY EQUIVALENT INDEX EXISTS
        ==============================================================================*/

        ELSE IF @TRNIT_index_equivalent_count = 1
        BEGIN

            SELECT
                @TRNIT_index_actual_name            = index_name,
                @TRNIT_index_actual_is_disabled     = is_disabled,
                @TRNIT_index_actual_data_space_name = data_space_name
            FROM @TRNIT_equivalent_indexes;


            SET @TRNIT_index_authoritative_name = @TRNIT_index_actual_name;
            SET @TRNIT_index_authoritative_data_space = @TRNIT_index_actual_data_space_name;


            /*--------------------------------------------------------------------------
                EQUIVALENT INDEX IS DISABLED
            --------------------------------------------------------------------------*/

            IF @TRNIT_index_actual_is_disabled = 1
            BEGIN

                PRINT N'        [!] Index disabled                 : '
                    + @TRNIT_index_actual_name;
                PRINT N'            Expected Name                  : IX_TRNIT_TRN_transaction_at';
                PRINT N'            Key Columns                    : TRNIT_TRN_id, TRNIT_transaction_at';
                PRINT N'            Existing index was preserved for review.';

            END


            /*--------------------------------------------------------------------------
                CORRECT STRUCTURE EXISTS WITH DIFFERENT NAME
            --------------------------------------------------------------------------*/

            ELSE IF @TRNIT_index_actual_name <> @TRNIT_index_expected_name
            BEGIN

                PRINT N'        [!] Index naming divergence        :';
                PRINT N'            Expected                       : IX_TRNIT_TRN_transaction_at';
                PRINT N'            Actual                         : '
                    + @TRNIT_index_actual_name;
                PRINT N'            Action                         : Preserve existing index';

            END


            /*--------------------------------------------------------------------------
                EXPECTED INDEX EXISTS AND IS VALID
            --------------------------------------------------------------------------*/

            ELSE
            BEGIN

                PRINT N'        [•] Index validated                : IX_TRNIT_TRN_transaction_at';
                PRINT N'            Key Columns                    : TRNIT_TRN_id, TRNIT_transaction_at';
                PRINT N'            Included Columns               : NONE';

            END;

        END;


        /*==============================================================================
            MULTIPLE STRUCTURALLY EQUIVALENT INDEXES EXIST

            Duplicate equivalent indexes are never removed automatically.

            Even when definitions are identical, an index name may be referenced by
            application hints, operational scripts, Query Store plans, documentation,
            or other external dependencies.

            Redundancy is reported for manual review.
        ==============================================================================*/

        ELSE IF @TRNIT_index_equivalent_count > 1
        BEGIN

            PRINT N'        [!] Equivalent indexes detected     : '
                + CONVERT(nvarchar(10), @TRNIT_index_equivalent_count);
            PRINT N'            Expected Index                  : IX_TRNIT_TRN_transaction_at';
            PRINT N'            Equivalent Indexes              : '
                + COALESCE(@TRNIT_index_equivalent_names, N'<UNKNOWN>');
            PRINT N'            Physical Placement              : '
                + COALESCE(@TRNIT_index_equivalent_details, N'<UNKNOWN>');
            PRINT N'            Action                          : Preserve all indexes for manual review';
            PRINT N'            Automatic removal               : NOT PERMITTED';


            /*----------------------------------------------------------------------
                REPORT EQUIVALENT INDEXES WITH PARTITION DIVERGENCE

                Equivalent indexes are preserved even when physically placed
                outside the expected partition scheme. The deterministic expected
                index remains authoritative when present.

                Physical divergence is reported explicitly for manual review.
            ----------------------------------------------------------------------*/

            DECLARE @TRNIT_divergent_index_name       sysname;
            DECLARE @TRNIT_divergent_data_space_name sysname;


            DECLARE TRN_partition_divergence_cursor CURSOR LOCAL FAST_FORWARD
            FOR
                SELECT
                    index_name,
                    data_space_name
                FROM @TRNIT_equivalent_indexes
                WHERE ISNULL(data_space_name, N'') <> N'PS_SALES_MONTHLY'
                ORDER BY index_name;


            OPEN TRN_partition_divergence_cursor;

            FETCH NEXT FROM TRN_partition_divergence_cursor
            INTO
                @TRNIT_divergent_index_name,
                @TRNIT_divergent_data_space_name;


            WHILE @@FETCH_STATUS = 0
            BEGIN

                PRINT N'';
                PRINT N'        [!] Equivalent index partition divergence';
                PRINT N'            Index                           : '
                    + @TRNIT_divergent_index_name;
                PRINT N'            Expected Partition Scheme       : PS_SALES_MONTHLY';
                PRINT N'            Actual Data Space               : '
                    + COALESCE(@TRNIT_divergent_data_space_name, N'<UNKNOWN>');
                PRINT N'            Action                          : Preserve index for manual review';

                FETCH NEXT FROM TRN_partition_divergence_cursor
                INTO
                    @TRNIT_divergent_index_name,
                    @TRNIT_divergent_data_space_name;

            END;


            CLOSE TRN_partition_divergence_cursor;
            DEALLOCATE TRN_partition_divergence_cursor;


            /*
                If the expected deterministic index exists among the equivalent
                indexes, it remains the authoritative object for partition validation.
            */

            IF EXISTS
            (
                SELECT 1
                FROM @TRNIT_equivalent_indexes
                WHERE index_name = @TRNIT_index_expected_name
            )
            BEGIN

                SELECT
                    @TRNIT_index_authoritative_name       = index_name,
                    @TRNIT_index_authoritative_data_space = data_space_name
                FROM @TRNIT_equivalent_indexes
                WHERE index_name = @TRNIT_index_expected_name;

            END;

        END;


        /*==============================================================================
            PARTITION ALIGNMENT VALIDATION
        ==============================================================================*/

        /*
            When an authoritative index can be identified, validate that exact object.
        */

        IF @TRNIT_index_authoritative_name IS NOT NULL
        BEGIN

            IF @TRNIT_index_authoritative_data_space <> N'PS_SALES_MONTHLY'
            BEGIN

                PRINT N'        [X] Index partition mismatch       : '
                    + @TRNIT_index_authoritative_name;
                PRINT N'            Expected Partition Scheme      : PS_SALES_MONTHLY';
                PRINT N'            Actual Data Space              : '
                    + COALESCE(@TRNIT_index_authoritative_data_space, N'<NULL>');

                ;THROW 50073,
                    N'Customer transaction history index is not aligned with PS_SALES_MONTHLY.',
                    1;

            END;

        END;


        /*
            When multiple equivalent indexes exist but the deterministic expected
            index does not exist, no single object is automatically selected as
            authoritative.

            At least one equivalent index must still be aligned with the expected
            partition scheme. The duplicates remain preserved for manual review.
        */

        ELSE IF @TRNIT_index_equivalent_count > 1
        BEGIN

            IF NOT EXISTS
            (
                SELECT 1
                FROM @TRNIT_equivalent_indexes
                WHERE data_space_name = N'PS_SALES_MONTHLY'
            )
            BEGIN

                PRINT N'        [X] Equivalent indexes are not aligned with expected partition scheme';
                PRINT N'            Expected Partition Scheme      : PS_SALES_MONTHLY';
                PRINT N'            Existing Indexes               : '
                    + COALESCE(@TRNIT_index_equivalent_details, N'<UNKNOWN>');

                ;THROW 50073,
                    N'No structurally equivalent customer transaction history index is aligned with PS_SALES_MONTHLY.',
                    1;

            END;

        END;


        PRINT N'';

        /*==============================================================================
        INDEX: IX_TRNIT_PRDVA

        Purpose:
            ProductVariant relationship support and product-variant transaction lookup.

        Expected definition:
            Key Columns       : TRNIT_PRDVA_id ASC
            Included Columns  : NONE
            Partition Scheme  : PS_SALES_MONTHLY
            Partition Column  : TRNIT_transaction_at

        Note:
            SQL Server automatically adds TRNIT_transaction_at as the partition
            column of this aligned nonclustered index. It is represented in
            sys.index_columns with:

                key_ordinal        = 0
                is_included_column = 0
                partition_ordinal  = 1

            Therefore, TRNIT_transaction_at is not treated as a user INCLUDE column.
    ==============================================================================*/

    DECLARE @TRNIT_PRDVA_expected_name                sysname;
    DECLARE @TRNIT_PRDVA_expected_exists              bit;
    DECLARE @TRNIT_PRDVA_expected_is_equivalent       bit;
    DECLARE @TRNIT_PRDVA_expected_type_desc           nvarchar(60);
    DECLARE @TRNIT_PRDVA_expected_is_unique           bit;
    DECLARE @TRNIT_PRDVA_expected_actual_keys         nvarchar(4000);
    DECLARE @TRNIT_PRDVA_expected_actual_includes     nvarchar(4000);

    DECLARE @TRNIT_PRDVA_equivalent_count             int;
    DECLARE @TRNIT_PRDVA_equivalent_names             nvarchar(4000);
    DECLARE @TRNIT_PRDVA_equivalent_details           nvarchar(4000);

    DECLARE @TRNIT_PRDVA_actual_name                  sysname;
    DECLARE @TRNIT_PRDVA_actual_is_disabled           bit;
    DECLARE @TRNIT_PRDVA_actual_data_space_name       sysname;
    DECLARE @TRNIT_PRDVA_actual_partition_column      sysname;

    DECLARE @TRNIT_PRDVA_authoritative_name           sysname;
    DECLARE @TRNIT_PRDVA_authoritative_data_space     sysname;
    DECLARE @TRNIT_PRDVA_authoritative_partition_col  sysname;

    SET @TRNIT_PRDVA_expected_name = N'IX_TRNIT_PRDVA';


    DECLARE @TRNIT_PRDVA_equivalent_indexes TABLE
    (
        index_name        sysname NOT NULL,
        is_disabled       bit     NOT NULL,
        data_space_name   sysname NULL,
        partition_column  sysname NULL
    );


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES
    ==============================================================================*/

    INSERT INTO @TRNIT_PRDVA_equivalent_indexes
    (
        index_name,
        is_disabled,
        data_space_name,
        partition_column
    )
    SELECT
        i.name,
        i.is_disabled,
        ds.name,
        pc.name
    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    LEFT JOIN sys.index_columns AS pic
        ON  pic.object_id = i.object_id
        AND pic.index_id = i.index_id
        AND pic.partition_ordinal = 1

    LEFT JOIN sys.columns AS pc
        ON  pc.object_id = pic.object_id
        AND pc.column_id = pic.column_id

    WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
    AND i.type = 2
    AND i.is_unique = 0
    AND i.is_hypothetical = 0

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
            AND c.name = N'TRNIT_PRDVA_id'
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
        @TRNIT_PRDVA_equivalent_count = COUNT(*)
    FROM @TRNIT_PRDVA_equivalent_indexes;


    SELECT
        @TRNIT_PRDVA_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @TRNIT_PRDVA_equivalent_indexes;


    SELECT
        @TRNIT_PRDVA_equivalent_details =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                    + N' [' + COALESCE(data_space_name, N'<UNKNOWN>') + N']'
                    + N' [Partition: '
                    + COALESCE(partition_column, N'<NONE>') + N']'
                    + CASE
                        WHEN is_disabled = 1
                            THEN N' [DISABLED]'
                        ELSE N''
                    END
                ),
                N', '
            )
    FROM @TRNIT_PRDVA_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @TRNIT_PRDVA_expected_exists = 0;
    SET @TRNIT_PRDVA_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE object_id = OBJECT_ID(N'sales.TransactionItem')
        AND name = @TRNIT_PRDVA_expected_name
    )
    BEGIN

        SET @TRNIT_PRDVA_expected_exists = 1;


        SELECT
            @TRNIT_PRDVA_expected_type_desc = i.type_desc,
            @TRNIT_PRDVA_expected_is_unique = i.is_unique
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.name = @TRNIT_PRDVA_expected_name;


        SELECT
            @TRNIT_PRDVA_expected_actual_keys =
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
                WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.name = @TRNIT_PRDVA_expected_name;


        SELECT
            @TRNIT_PRDVA_expected_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.index_column_id)
        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.name = @TRNIT_PRDVA_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @TRNIT_PRDVA_equivalent_indexes
            WHERE index_name = @TRNIT_PRDVA_expected_name
        )
        BEGIN
            SET @TRNIT_PRDVA_expected_is_equivalent = 1;
        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @TRNIT_PRDVA_expected_exists = 1
    AND @TRNIT_PRDVA_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : IX_TRNIT_PRDVA';
        PRINT N'            Expected Type                   : NONCLUSTERED';
        PRINT N'            Actual Type                     : '
            + COALESCE(@TRNIT_PRDVA_expected_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique                 : 0';
        PRINT N'            Actual Unique                   : '
            + COALESCE(CONVERT(nvarchar(1), @TRNIT_PRDVA_expected_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns            : TRNIT_PRDVA_id ASC';
        PRINT N'            Actual Key Columns              : '
            + COALESCE(@TRNIT_PRDVA_expected_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns       : NONE';
        PRINT N'            Actual Included Columns         : '
            + COALESCE(@TRNIT_PRDVA_expected_actual_includes, N'NONE');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50074,
            N'Index IX_TRNIT_PRDVA exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @TRNIT_PRDVA_expected_exists = 0
    AND @TRNIT_PRDVA_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_TRNIT_PRDVA
            ON sales.TransactionItem
            (
                TRNIT_PRDVA_id ASC
            )
            ON PS_SALES_MONTHLY(TRNIT_transaction_at);


        PRINT N'        [+] Index added                    : IX_TRNIT_PRDVA';
        PRINT N'            Key Columns                    : TRNIT_PRDVA_id';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Partition Scheme               : PS_SALES_MONTHLY';
        PRINT N'            Partition Column               : TRNIT_transaction_at';


        SET @TRNIT_PRDVA_authoritative_name = N'IX_TRNIT_PRDVA';
        SET @TRNIT_PRDVA_authoritative_data_space = N'PS_SALES_MONTHLY';
        SET @TRNIT_PRDVA_authoritative_partition_col = N'TRNIT_transaction_at';

    END


    /*==============================================================================
        EXACTLY ONE EQUIVALENT INDEX
    ==============================================================================*/

    ELSE IF @TRNIT_PRDVA_equivalent_count = 1
    BEGIN

        SELECT
            @TRNIT_PRDVA_actual_name             = index_name,
            @TRNIT_PRDVA_actual_is_disabled      = is_disabled,
            @TRNIT_PRDVA_actual_data_space_name  = data_space_name,
            @TRNIT_PRDVA_actual_partition_column = partition_column
        FROM @TRNIT_PRDVA_equivalent_indexes;


        SET @TRNIT_PRDVA_authoritative_name =
            @TRNIT_PRDVA_actual_name;

        SET @TRNIT_PRDVA_authoritative_data_space =
            @TRNIT_PRDVA_actual_data_space_name;

        SET @TRNIT_PRDVA_authoritative_partition_col =
            @TRNIT_PRDVA_actual_partition_column;


        IF @TRNIT_PRDVA_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Index disabled                 : '
                + @TRNIT_PRDVA_actual_name;
            PRINT N'            Expected Name                  : IX_TRNIT_PRDVA';
            PRINT N'            Key Columns                    : TRNIT_PRDVA_id';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @TRNIT_PRDVA_actual_name <> @TRNIT_PRDVA_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';
            PRINT N'            Expected                       : IX_TRNIT_PRDVA';
            PRINT N'            Actual                         : '
                + @TRNIT_PRDVA_actual_name;
            PRINT N'            Action                         : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Index validated                : IX_TRNIT_PRDVA';
            PRINT N'            Key Columns                    : TRNIT_PRDVA_id';
            PRINT N'            Included Columns               : NONE';

        END;

    END


    /*==============================================================================
        MULTIPLE EQUIVALENT INDEXES
    ==============================================================================*/

    ELSE IF @TRNIT_PRDVA_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT(nvarchar(10), @TRNIT_PRDVA_equivalent_count);
        PRINT N'            Expected Index                  : IX_TRNIT_PRDVA';
        PRINT N'            Equivalent Indexes              : '
            + COALESCE(@TRNIT_PRDVA_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement              : '
            + COALESCE(@TRNIT_PRDVA_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                          : Preserve all indexes for manual review';
        PRINT N'            Automatic removal               : NOT PERMITTED';


        IF EXISTS
        (
            SELECT 1
            FROM @TRNIT_PRDVA_equivalent_indexes
            WHERE index_name = @TRNIT_PRDVA_expected_name
        )
        BEGIN

            SELECT
                @TRNIT_PRDVA_authoritative_name          = index_name,
                @TRNIT_PRDVA_authoritative_data_space    = data_space_name,
                @TRNIT_PRDVA_authoritative_partition_col = partition_column
            FROM @TRNIT_PRDVA_equivalent_indexes
            WHERE index_name = @TRNIT_PRDVA_expected_name;

        END;

    END;


    /*==============================================================================
        PARTITION ALIGNMENT VALIDATION
    ==============================================================================*/

    IF @TRNIT_PRDVA_authoritative_name IS NOT NULL
    BEGIN

        IF @TRNIT_PRDVA_authoritative_data_space <> N'PS_SALES_MONTHLY'
        OR ISNULL(@TRNIT_PRDVA_authoritative_partition_col, N'')
                <> N'TRNIT_transaction_at'
        BEGIN

            PRINT N'        [X] Index partition mismatch       : '
                + @TRNIT_PRDVA_authoritative_name;
            PRINT N'            Expected Partition Scheme      : PS_SALES_MONTHLY';
            PRINT N'            Actual Data Space              : '
                + COALESCE(@TRNIT_PRDVA_authoritative_data_space, N'<NULL>');
            PRINT N'            Expected Partition Column      : TRNIT_transaction_at';
            PRINT N'            Actual Partition Column        : '
                + COALESCE(@TRNIT_PRDVA_authoritative_partition_col, N'<NULL>');

            ;THROW 50075,
                N'Index IX_TRNIT_PRDVA is not correctly aligned with PS_SALES_MONTHLY using TRNIT_transaction_at.',
                1;

        END;

    END;


    PRINT N'';

    /*==============================================================================
        INDEX: IX_TRNIT_updated_at

        Purpose:
            Incremental data pipeline extraction using TRNIT_updated_at windows.

        Expected definition:
            Key Columns       : TRNIT_updated_at ASC
            Included Columns  : NONE
            Partition Scheme  : PS_SALES_MONTHLY
            Partition Column  : TRNIT_transaction_at

        Note:
            SQL Server automatically adds TRNIT_transaction_at as the partition
            column of this aligned nonclustered index. It is represented in
            sys.index_columns with:

                key_ordinal        = 0
                is_included_column = 0
                partition_ordinal  = 1

            Therefore, TRNIT_transaction_at is not treated as a user INCLUDE column.
    ==============================================================================*/

    DECLARE @TRNIT_UPD_expected_name                sysname;
    DECLARE @TRNIT_UPD_expected_exists              bit;
    DECLARE @TRNIT_UPD_expected_is_equivalent       bit;
    DECLARE @TRNIT_UPD_expected_type_desc           nvarchar(60);
    DECLARE @TRNIT_UPD_expected_is_unique           bit;
    DECLARE @TRNIT_UPD_expected_actual_keys         nvarchar(4000);
    DECLARE @TRNIT_UPD_expected_actual_includes     nvarchar(4000);

    DECLARE @TRNIT_UPD_equivalent_count             int;
    DECLARE @TRNIT_UPD_equivalent_names             nvarchar(4000);
    DECLARE @TRNIT_UPD_equivalent_details           nvarchar(4000);

    DECLARE @TRNIT_UPD_actual_name                  sysname;
    DECLARE @TRNIT_UPD_actual_is_disabled           bit;
    DECLARE @TRNIT_UPD_actual_data_space_name       sysname;
    DECLARE @TRNIT_UPD_actual_partition_column      sysname;

    DECLARE @TRNIT_UPD_authoritative_name           sysname;
    DECLARE @TRNIT_UPD_authoritative_data_space     sysname;
    DECLARE @TRNIT_UPD_authoritative_partition_col  sysname;

    SET @TRNIT_UPD_expected_name = N'IX_TRNIT_updated_at';


    DECLARE @TRNIT_UPD_equivalent_indexes TABLE
    (
        index_name        sysname NOT NULL,
        is_disabled       bit     NOT NULL,
        data_space_name   sysname NULL,
        partition_column  sysname NULL
    );


    /*==============================================================================
        COLLECT STRUCTURALLY EQUIVALENT INDEXES
    ==============================================================================*/

    INSERT INTO @TRNIT_UPD_equivalent_indexes
    (
        index_name,
        is_disabled,
        data_space_name,
        partition_column
    )
    SELECT
        i.name,
        i.is_disabled,
        ds.name,
        pc.name
    FROM sys.indexes AS i

    INNER JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id

    LEFT JOIN sys.index_columns AS pic
        ON  pic.object_id = i.object_id
        AND pic.index_id = i.index_id
        AND pic.partition_ordinal = 1

    LEFT JOIN sys.columns AS pc
        ON  pc.object_id = pic.object_id
        AND pc.column_id = pic.column_id

    WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
    AND i.type = 2
    AND i.is_unique = 0
    AND i.is_hypothetical = 0

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
            AND c.name = N'TRNIT_updated_at'
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
        @TRNIT_UPD_equivalent_count = COUNT(*)
    FROM @TRNIT_UPD_equivalent_indexes;


    SELECT
        @TRNIT_UPD_equivalent_names =
            STRING_AGG(CONVERT(nvarchar(max), index_name), N', ')
    FROM @TRNIT_UPD_equivalent_indexes;


    SELECT
        @TRNIT_UPD_equivalent_details =
            STRING_AGG
            (
                CONVERT
                (
                    nvarchar(max),
                    index_name
                    + N' [' + COALESCE(data_space_name, N'<UNKNOWN>') + N']'
                    + N' [Partition: '
                    + COALESCE(partition_column, N'<NONE>') + N']'
                    + CASE
                        WHEN is_disabled = 1
                            THEN N' [DISABLED]'
                        ELSE N''
                    END
                ),
                N', '
            )
    FROM @TRNIT_UPD_equivalent_indexes;


    /*==============================================================================
        IDENTIFY INDEX WITH EXPECTED NAME
    ==============================================================================*/

    SET @TRNIT_UPD_expected_exists = 0;
    SET @TRNIT_UPD_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes
        WHERE object_id = OBJECT_ID(N'sales.TransactionItem')
        AND name = @TRNIT_UPD_expected_name
    )
    BEGIN

        SET @TRNIT_UPD_expected_exists = 1;


        SELECT
            @TRNIT_UPD_expected_type_desc = i.type_desc,
            @TRNIT_UPD_expected_is_unique = i.is_unique
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.name = @TRNIT_UPD_expected_name;


        SELECT
            @TRNIT_UPD_expected_actual_keys =
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
                WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.key_ordinal > 0

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.name = @TRNIT_UPD_expected_name;


        SELECT
            @TRNIT_UPD_expected_actual_includes =
                STRING_AGG
                (
                    CONVERT(nvarchar(max), c.name),
                    N', '
                )
                WITHIN GROUP (ORDER BY ic.index_column_id)
        FROM sys.indexes AS i

        INNER JOIN sys.index_columns AS ic
            ON  ic.object_id = i.object_id
            AND ic.index_id = i.index_id
            AND ic.is_included_column = 1

        INNER JOIN sys.columns AS c
            ON  c.object_id = ic.object_id
            AND c.column_id = ic.column_id

        WHERE i.object_id = OBJECT_ID(N'sales.TransactionItem')
        AND i.name = @TRNIT_UPD_expected_name;


        IF EXISTS
        (
            SELECT 1
            FROM @TRNIT_UPD_equivalent_indexes
            WHERE index_name = @TRNIT_UPD_expected_name
        )
        BEGIN
            SET @TRNIT_UPD_expected_is_equivalent = 1;
        END;

    END;


    /*==============================================================================
        EXPECTED NAME EXISTS WITH WRONG STRUCTURE
    ==============================================================================*/

    IF @TRNIT_UPD_expected_exists = 1
    AND @TRNIT_UPD_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Index definition mismatch        : IX_TRNIT_updated_at';
        PRINT N'            Expected Type                   : NONCLUSTERED';
        PRINT N'            Actual Type                     : '
            + COALESCE(@TRNIT_UPD_expected_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique                 : 0';
        PRINT N'            Actual Unique                   : '
            + COALESCE(CONVERT(nvarchar(1), @TRNIT_UPD_expected_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns            : TRNIT_updated_at ASC';
        PRINT N'            Actual Key Columns              : '
            + COALESCE(@TRNIT_UPD_expected_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns       : NONE';
        PRINT N'            Actual Included Columns         : '
            + COALESCE(@TRNIT_UPD_expected_actual_includes, N'NONE');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 50076,
            N'Index IX_TRNIT_updated_at exists but does not match the expected definition.',
            1;

    END;


    /*==============================================================================
        INDEX DOES NOT EXIST
    ==============================================================================*/

    IF @TRNIT_UPD_expected_exists = 0
    AND @TRNIT_UPD_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_TRNIT_updated_at
            ON sales.TransactionItem
            (
                TRNIT_updated_at ASC
            )
            ON PS_SALES_MONTHLY(TRNIT_transaction_at);


        PRINT N'        [+] Index added                    : IX_TRNIT_updated_at';
        PRINT N'            Key Columns                    : TRNIT_updated_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Partition Scheme               : PS_SALES_MONTHLY';
        PRINT N'            Partition Column               : TRNIT_transaction_at';


        SET @TRNIT_UPD_authoritative_name = N'IX_TRNIT_updated_at';
        SET @TRNIT_UPD_authoritative_data_space = N'PS_SALES_MONTHLY';
        SET @TRNIT_UPD_authoritative_partition_col = N'TRNIT_transaction_at';

    END


    /*==============================================================================
        EXACTLY ONE EQUIVALENT INDEX
    ==============================================================================*/

    ELSE IF @TRNIT_UPD_equivalent_count = 1
    BEGIN

        SELECT
            @TRNIT_UPD_actual_name             = index_name,
            @TRNIT_UPD_actual_is_disabled      = is_disabled,
            @TRNIT_UPD_actual_data_space_name  = data_space_name,
            @TRNIT_UPD_actual_partition_column = partition_column
        FROM @TRNIT_UPD_equivalent_indexes;


        SET @TRNIT_UPD_authoritative_name =
            @TRNIT_UPD_actual_name;

        SET @TRNIT_UPD_authoritative_data_space =
            @TRNIT_UPD_actual_data_space_name;

        SET @TRNIT_UPD_authoritative_partition_col =
            @TRNIT_UPD_actual_partition_column;


        IF @TRNIT_UPD_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Index disabled                 : '
                + @TRNIT_UPD_actual_name;
            PRINT N'            Expected Name                  : IX_TRNIT_updated_at';
            PRINT N'            Key Columns                    : TRNIT_updated_at';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @TRNIT_UPD_actual_name <> @TRNIT_UPD_expected_name
        BEGIN

            PRINT N'        [!] Index naming divergence        :';
            PRINT N'            Expected                       : IX_TRNIT_updated_at';
            PRINT N'            Actual                         : '
                + @TRNIT_UPD_actual_name;
            PRINT N'            Action                         : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Index validated                : IX_TRNIT_updated_at';
            PRINT N'            Key Columns                    : TRNIT_updated_at';
            PRINT N'            Included Columns               : NONE';

        END;

    END


    /*==============================================================================
        MULTIPLE EQUIVALENT INDEXES
    ==============================================================================*/

    ELSE IF @TRNIT_UPD_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent indexes detected     : '
            + CONVERT(nvarchar(10), @TRNIT_UPD_equivalent_count);
        PRINT N'            Expected Index                  : IX_TRNIT_updated_at';
        PRINT N'            Equivalent Indexes              : '
            + COALESCE(@TRNIT_UPD_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement              : '
            + COALESCE(@TRNIT_UPD_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                          : Preserve all indexes for manual review';
        PRINT N'            Automatic removal               : NOT PERMITTED';


        IF EXISTS
        (
            SELECT 1
            FROM @TRNIT_UPD_equivalent_indexes
            WHERE index_name = @TRNIT_UPD_expected_name
        )
        BEGIN

            SELECT
                @TRNIT_UPD_authoritative_name          = index_name,
                @TRNIT_UPD_authoritative_data_space    = data_space_name,
                @TRNIT_UPD_authoritative_partition_col = partition_column
            FROM @TRNIT_UPD_equivalent_indexes
            WHERE index_name = @TRNIT_UPD_expected_name;

        END;

    END;


    /*==============================================================================
        PARTITION ALIGNMENT VALIDATION
    ==============================================================================*/

    IF @TRNIT_UPD_authoritative_name IS NOT NULL
    BEGIN

        IF @TRNIT_UPD_authoritative_data_space <> N'PS_SALES_MONTHLY'
        OR ISNULL(@TRNIT_UPD_authoritative_partition_col, N'')
                <> N'TRNIT_transaction_at'
        BEGIN

            PRINT N'        [X] Index partition mismatch       : '
                + @TRNIT_UPD_authoritative_name;
            PRINT N'            Expected Partition Scheme      : PS_SALES_MONTHLY';
            PRINT N'            Actual Data Space              : '
                + COALESCE(@TRNIT_UPD_authoritative_data_space, N'<NULL>');
            PRINT N'            Expected Partition Column      : TRNIT_transaction_at';
            PRINT N'            Actual Partition Column        : '
                + COALESCE(@TRNIT_UPD_authoritative_partition_col, N'<NULL>');

            ;THROW 50077,
                N'Index IX_TRNIT_updated_at is not correctly aligned with PS_SALES_MONTHLY using TRNIT_transaction_at.',
                1;

        END;

    END;


    PRINT N'';