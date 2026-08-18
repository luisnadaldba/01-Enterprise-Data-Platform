    PRINT N'    shipping.Shipment';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        UNIQUE FILTERED INDEX: UX_SHP_tracking_code

        Purpose:
            Prevents duplicate postal tracking codes while allowing shipments
            that have not yet received a tracking code.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : YES
            Key Columns       : SHP_tracking_code ASC
            Included Columns  : NONE
            Filter            : SHP_tracking_code IS NOT NULL
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @SHP_TRK_IX_expected_name          sysname = N'UX_SHP_tracking_code';
    DECLARE @SHP_TRK_IX_actual_type_desc       nvarchar(60);
    DECLARE @SHP_TRK_IX_actual_is_unique       bit;
    DECLARE @SHP_TRK_IX_actual_is_disabled     bit;
    DECLARE @SHP_TRK_IX_actual_data_space      sysname;
    DECLARE @SHP_TRK_IX_actual_keys            nvarchar(4000);
    DECLARE @SHP_TRK_IX_actual_includes        nvarchar(4000);
    DECLARE @SHP_TRK_IX_actual_has_filter      bit;
    DECLARE @SHP_TRK_IX_actual_filter          nvarchar(4000);
    DECLARE @SHP_TRK_IX_normalized_filter      nvarchar(4000);


    IF EXISTS
    (
        SELECT 1
        FROM sys.indexes AS i
        WHERE i.object_id = OBJECT_ID(N'shipping.Shipment')
        AND i.name = @SHP_TRK_IX_expected_name
    )
    BEGIN

        SELECT
            @SHP_TRK_IX_actual_type_desc   = i.type_desc,
            @SHP_TRK_IX_actual_is_unique   = i.is_unique,
            @SHP_TRK_IX_actual_is_disabled = i.is_disabled,
            @SHP_TRK_IX_actual_data_space  = ds.name,
            @SHP_TRK_IX_actual_has_filter  = i.has_filter,
            @SHP_TRK_IX_actual_filter      = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id = OBJECT_ID(N'shipping.Shipment')
        AND i.name = @SHP_TRK_IX_expected_name;


        SELECT
            @SHP_TRK_IX_actual_keys =
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

        WHERE i.object_id = OBJECT_ID(N'shipping.Shipment')
        AND i.name = @SHP_TRK_IX_expected_name;


        SELECT
            @SHP_TRK_IX_actual_includes =
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

        WHERE i.object_id = OBJECT_ID(N'shipping.Shipment')
        AND i.name = @SHP_TRK_IX_expected_name;


        SET @SHP_TRK_IX_normalized_filter =
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
                                COALESCE(@SHP_TRK_IX_actual_filter, N''),
                                N'[',
                                N''
                            ),
                            N']',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            );


        IF @SHP_TRK_IX_actual_type_desc = N'NONCLUSTERED'
        AND @SHP_TRK_IX_actual_is_unique = 1
        AND @SHP_TRK_IX_actual_is_disabled = 0
        AND @SHP_TRK_IX_actual_keys = N'SHP_tracking_code ASC'
        AND @SHP_TRK_IX_actual_includes IS NULL
        AND @SHP_TRK_IX_actual_has_filter = 1
        AND @SHP_TRK_IX_normalized_filter =
                N'shp_tracking_codeisnotnull'
        AND @SHP_TRK_IX_actual_data_space = N'FG_CORE'
        BEGIN

            PRINT N'        [•] Unique filtered index validated : UX_SHP_tracking_code';
            PRINT N'            Key Columns                    : SHP_tracking_code';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : YES';
            PRINT N'            Filter                         : SHP_tracking_code IS NOT NULL';
            PRINT N'            Filegroup                      : FG_CORE';

        END
        ELSE
        BEGIN

            PRINT N'        [X] Unique filtered index mismatch  : UX_SHP_tracking_code';
            PRINT N'            Expected Type                 : NONCLUSTERED';
            PRINT N'            Actual Type                   : '
                + COALESCE(@SHP_TRK_IX_actual_type_desc, N'<UNKNOWN>');
            PRINT N'            Expected Unique               : 1';
            PRINT N'            Actual Unique                 : '
                + COALESCE(CONVERT(nvarchar(1), @SHP_TRK_IX_actual_is_unique), N'<UNKNOWN>');
            PRINT N'            Expected Key Columns          : SHP_tracking_code ASC';
            PRINT N'            Actual Key Columns            : '
                + COALESCE(@SHP_TRK_IX_actual_keys, N'<NONE>');
            PRINT N'            Expected Included Columns     : NONE';
            PRINT N'            Actual Included Columns       : '
                + COALESCE(@SHP_TRK_IX_actual_includes, N'NONE');
            PRINT N'            Expected Filter               : SHP_tracking_code IS NOT NULL';
            PRINT N'            Actual Filter                 : '
                + COALESCE(@SHP_TRK_IX_actual_filter, N'NONE');
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@SHP_TRK_IX_actual_data_space, N'<UNKNOWN>');

            ;THROW 51250,
                N'Index UX_SHP_tracking_code exists but does not match the expected definition.',
                1;

        END;

    END
    ELSE
    BEGIN

        CREATE UNIQUE NONCLUSTERED INDEX UX_SHP_tracking_code
            ON shipping.Shipment
            (
                SHP_tracking_code ASC
            )
            WHERE SHP_tracking_code IS NOT NULL
            ON FG_CORE;


        PRINT N'        [+] Unique filtered index added    : UX_SHP_tracking_code';
        PRINT N'            Key Columns                    : SHP_tracking_code';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : YES';
        PRINT N'            Filter                         : SHP_tracking_code IS NOT NULL';
        PRINT N'            Filegroup                      : FG_CORE';

    END;


    /*==============================================================================
        NONCLUSTERED INDEX: IX_SHP_updated_at

        Purpose:
            Supports incremental extraction of shipment rows by most recent
            modification time.

        Expected definition:
            Type              : NONCLUSTERED
            Unique            : NO
            Key Columns       : SHP_updated_at ASC
            Included Columns  : NONE
            Filter            : NONE
            Filegroup         : FG_CORE
    ==============================================================================*/

    DECLARE @SHP_UPD_IX_expected_name               sysname;
    DECLARE @SHP_UPD_IX_expected_exists             bit;
    DECLARE @SHP_UPD_IX_expected_is_equivalent      bit;

    DECLARE @SHP_UPD_IX_actual_name                 sysname;
    DECLARE @SHP_UPD_IX_actual_type_desc            nvarchar(60);
    DECLARE @SHP_UPD_IX_actual_is_unique            bit;
    DECLARE @SHP_UPD_IX_actual_is_disabled          bit;
    DECLARE @SHP_UPD_IX_actual_data_space           sysname;
    DECLARE @SHP_UPD_IX_actual_keys                 nvarchar(4000);
    DECLARE @SHP_UPD_IX_actual_includes             nvarchar(4000);
    DECLARE @SHP_UPD_IX_actual_has_filter           bit;
    DECLARE @SHP_UPD_IX_actual_filter               nvarchar(4000);

    DECLARE @SHP_UPD_IX_equivalent_count            int;
    DECLARE @SHP_UPD_IX_equivalent_names            nvarchar(4000);
    DECLARE @SHP_UPD_IX_equivalent_details          nvarchar(4000);


    SET @SHP_UPD_IX_expected_name =
        N'IX_SHP_updated_at';


    DECLARE @SHP_UPD_IX_equivalent_indexes TABLE
    (
        index_name       sysname NOT NULL,
        is_disabled      bit     NOT NULL,
        data_space_name  sysname NULL
    );


    INSERT INTO @SHP_UPD_IX_equivalent_indexes
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
            OBJECT_ID(N'shipping.Shipment')

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
        AND c.name = N'SHP_updated_at'
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
        @SHP_UPD_IX_equivalent_count =
            COUNT(*)

    FROM @SHP_UPD_IX_equivalent_indexes;


    SELECT
        @SHP_UPD_IX_equivalent_names =
            STRING_AGG
            (
                CONVERT(nvarchar(max), index_name),
                N', '
            )

    FROM @SHP_UPD_IX_equivalent_indexes;


    SELECT
        @SHP_UPD_IX_equivalent_details =
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

    FROM @SHP_UPD_IX_equivalent_indexes;


    SET @SHP_UPD_IX_expected_exists = 0;
    SET @SHP_UPD_IX_expected_is_equivalent = 0;


    IF EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND i.name =
                @SHP_UPD_IX_expected_name
    )
    BEGIN

        SET @SHP_UPD_IX_expected_exists = 1;


        SELECT
            @SHP_UPD_IX_actual_name = i.name,
            @SHP_UPD_IX_actual_type_desc = i.type_desc,
            @SHP_UPD_IX_actual_is_unique = i.is_unique,
            @SHP_UPD_IX_actual_is_disabled = i.is_disabled,
            @SHP_UPD_IX_actual_data_space = ds.name,
            @SHP_UPD_IX_actual_has_filter = i.has_filter,
            @SHP_UPD_IX_actual_filter = i.filter_definition

        FROM sys.indexes AS i

        LEFT JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND i.name =
                @SHP_UPD_IX_expected_name;


        SELECT
            @SHP_UPD_IX_actual_keys =
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
                OBJECT_ID(N'shipping.Shipment')

        AND i.name =
                @SHP_UPD_IX_expected_name;


        SELECT
            @SHP_UPD_IX_actual_includes =
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
                OBJECT_ID(N'shipping.Shipment')

        AND i.name =
                @SHP_UPD_IX_expected_name;


        IF EXISTS
        (
            SELECT 1

            FROM @SHP_UPD_IX_equivalent_indexes

            WHERE index_name =
                @SHP_UPD_IX_expected_name
        )
        BEGIN

            SET @SHP_UPD_IX_expected_is_equivalent = 1;

        END;

    END;


    IF @SHP_UPD_IX_expected_exists = 1
    AND @SHP_UPD_IX_expected_is_equivalent = 0
    BEGIN

        PRINT N'        [X] Nonclustered index mismatch      : IX_SHP_updated_at';
        PRINT N'            Expected Type                 : NONCLUSTERED';
        PRINT N'            Actual Type                   : '
            + COALESCE(@SHP_UPD_IX_actual_type_desc, N'<UNKNOWN>');
        PRINT N'            Expected Unique               : 0';
        PRINT N'            Actual Unique                 : '
            + COALESCE(CONVERT(nvarchar(1), @SHP_UPD_IX_actual_is_unique), N'<UNKNOWN>');
        PRINT N'            Expected Key Columns          : SHP_updated_at ASC';
        PRINT N'            Actual Key Columns            : '
            + COALESCE(@SHP_UPD_IX_actual_keys, N'<NONE>');
        PRINT N'            Expected Included Columns     : NONE';
        PRINT N'            Actual Included Columns       : '
            + COALESCE(@SHP_UPD_IX_actual_includes, N'NONE');
        PRINT N'            Expected Filter               : NONE';
        PRINT N'            Actual Filter                 : '
            + COALESCE(@SHP_UPD_IX_actual_filter, N'NONE');
        PRINT N'            Expected Filegroup            : FG_CORE';
        PRINT N'            Actual Filegroup              : '
            + COALESCE(@SHP_UPD_IX_actual_data_space, N'<UNKNOWN>');
        PRINT N'            Existing index was preserved for review.';

        ;THROW 51251,
            N'Index IX_SHP_updated_at exists but does not match the expected definition.',
            1;

    END;


    IF @SHP_UPD_IX_expected_exists = 0
    AND @SHP_UPD_IX_equivalent_count = 0
    BEGIN

        CREATE NONCLUSTERED INDEX IX_SHP_updated_at
            ON shipping.Shipment
            (
                SHP_updated_at ASC
            )
            ON FG_CORE;


        PRINT N'        [+] Nonclustered index added       : IX_SHP_updated_at';
        PRINT N'            Key Columns                    : SHP_updated_at';
        PRINT N'            Included Columns               : NONE';
        PRINT N'            Unique                         : NO';
        PRINT N'            Filter                         : NONE';
        PRINT N'            Filegroup                      : FG_CORE';

    END

    ELSE IF @SHP_UPD_IX_equivalent_count = 1
    BEGIN

        SELECT
            @SHP_UPD_IX_actual_name = index_name,
            @SHP_UPD_IX_actual_is_disabled = is_disabled,
            @SHP_UPD_IX_actual_data_space = data_space_name

        FROM @SHP_UPD_IX_equivalent_indexes;


        IF @SHP_UPD_IX_actual_is_disabled = 1
        BEGIN

            PRINT N'        [!] Nonclustered index disabled    : '
                + @SHP_UPD_IX_actual_name;
            PRINT N'            Expected Name                 : IX_SHP_updated_at';
            PRINT N'            Key Columns                   : SHP_updated_at';
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @SHP_UPD_IX_actual_data_space <> N'FG_CORE'
        BEGIN

            PRINT N'        [!] Nonclustered index storage divergence';
            PRINT N'            Index                         : '
                + @SHP_UPD_IX_actual_name;
            PRINT N'            Expected Filegroup            : FG_CORE';
            PRINT N'            Actual Filegroup              : '
                + COALESCE(@SHP_UPD_IX_actual_data_space, N'<UNKNOWN>');
            PRINT N'            Existing index was preserved for review.';

        END

        ELSE IF @SHP_UPD_IX_actual_name <> @SHP_UPD_IX_expected_name
        BEGIN

            PRINT N'        [!] Nonclustered index naming divergence';
            PRINT N'            Expected                     : IX_SHP_updated_at';
            PRINT N'            Actual                       : '
                + @SHP_UPD_IX_actual_name;
            PRINT N'            Key Columns                   : SHP_updated_at';
            PRINT N'            Action                        : Preserve existing index';

        END

        ELSE
        BEGIN

            PRINT N'        [•] Nonclustered index validated   : IX_SHP_updated_at';
            PRINT N'            Key Columns                    : SHP_updated_at';
            PRINT N'            Included Columns               : NONE';
            PRINT N'            Unique                         : NO';
            PRINT N'            Filter                         : NONE';
            PRINT N'            Filegroup                      : FG_CORE';

        END;

    END

    ELSE IF @SHP_UPD_IX_equivalent_count > 1
    BEGIN

        PRINT N'        [!] Equivalent nonclustered indexes detected : '
            + CONVERT(nvarchar(10), @SHP_UPD_IX_equivalent_count);
        PRINT N'            Expected Index                : IX_SHP_updated_at';
        PRINT N'            Equivalent Indexes            : '
            + COALESCE(@SHP_UPD_IX_equivalent_names, N'<UNKNOWN>');
        PRINT N'            Physical Placement            : '
            + COALESCE(@SHP_UPD_IX_equivalent_details, N'<UNKNOWN>');
        PRINT N'            Action                        : Preserve all indexes for manual review';
        PRINT N'            Automatic removal             : NOT PERMITTED';

    END;


    PRINT N'';