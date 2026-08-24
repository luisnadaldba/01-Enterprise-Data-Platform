    PRINT N'';
    PRINT N'    ● metadata.TablePrefix';
    PRINT N'';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.filegroups

        WHERE name =
                N'PRIMARY'
    )
    BEGIN

        ;THROW 50001,
            N'Required filegroup PRIMARY does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : PRIMARY';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID(N'metadata.TablePrefix', N'U') IS NULL
    BEGIN

        CREATE TABLE metadata.TablePrefix
        (
            PFX_id           smallint IDENTITY(1,1) NOT NULL,
            PFX_schema_name  sysname                NOT NULL,
            PFX_table_name   sysname                NOT NULL,
            PFX_prefix       nvarchar(5)            NOT NULL,
            PFX_is_active    bit                    NOT NULL,
            PFX_created_at   datetime2(0)           NOT NULL,
            PFX_updated_at   datetime2(0)           NOT NULL,

            CONSTRAINT PK_PFX
                PRIMARY KEY CLUSTERED
                (
                    PFX_id
                )
                ON [PRIMARY]
        )
        ON [PRIMARY];


        PRINT N'        [+] Table created                   : metadata.TablePrefix';
        PRINT N'            Prefix                          : PFX';
        PRINT N'            Filegroup                       : PRIMARY';
        PRINT N'            Primary Key                     : PFX_id';

    END
    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : metadata.TablePrefix';


        /*--------------------------------------------------------------------------
            PRIMARY KEY COLUMN: PFX_id
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            INNER JOIN sys.identity_columns AS ic
                ON  ic.object_id = c.object_id
                AND ic.column_id = c.column_id

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_id'

            AND TYPE_NAME(c.user_type_id) =
                    N'smallint'

            AND c.is_nullable = 0
            AND c.is_identity = 1

            AND CONVERT(bigint, ic.seed_value) = 1
            AND CONVERT(bigint, ic.increment_value) = 1
        )
        BEGIN

            PRINT N'            [X] Primary key column mismatch : PFX_id';

            ;THROW 50002,
                N'Column PFX_id does not match the expected definition smallint IDENTITY(1,1) NOT NULL.',
                1;

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key column validated : PFX_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PFX
        --------------------------------------------------------------------------*/

        DECLARE @PFX_ActualPrimaryKeyName sysname;


        SELECT
            @PFX_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND kc.type =
                N'PK';


        IF @PFX_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PFX';

            ;THROW 50003,
                N'Primary key for metadata.TablePrefix does not exist.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY DEFINITION
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.key_constraints AS kc

            INNER JOIN sys.indexes AS i
                ON  i.object_id = kc.parent_object_id
                AND i.index_id = kc.unique_index_id

            WHERE kc.parent_object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND kc.type =
                    N'PK'

            AND i.type = 1
            AND i.is_unique = 1

            AND
            (
                SELECT COUNT(*)

                FROM sys.index_columns AS ic

                WHERE ic.object_id =
                        kc.parent_object_id

                AND ic.index_id =
                        kc.unique_index_id

                AND ic.key_ordinal > 0
            ) = 1

            AND EXISTS
            (
                SELECT 1

                FROM sys.index_columns AS ic

                INNER JOIN sys.columns AS c
                    ON  c.object_id = ic.object_id
                    AND c.column_id = ic.column_id

                WHERE ic.object_id =
                        kc.parent_object_id

                AND ic.index_id =
                        kc.unique_index_id

                AND ic.key_ordinal = 1

                AND c.name =
                        N'PFX_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PFX_ActualPrimaryKeyName;

            ;THROW 50004,
                N'Primary key does not match the expected clustered definition PFX_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PFX_ActualPrimaryKeyName <>
                N'PK_PFX'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';
            PRINT N'                Expected                     : PK_PFX';
            PRINT N'                Actual                       : '
                + @PFX_ActualPrimaryKeyName;
            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PFX';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PFX_schema_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'metadata.TablePrefix',
            N'PFX_schema_name'
        ) IS NULL
        BEGIN

            ALTER TABLE metadata.TablePrefix
                ADD PFX_schema_name sysname NULL;


            PRINT N'            [+] Column added                  : PFX_schema_name';
            PRINT N'            [!] Pending action                : Backfill PFX_schema_name before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_schema_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'sysname'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PFX_schema_name';

            ;THROW 50005,
                N'Column PFX_schema_name exists but does not match the expected data type sysname.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_schema_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PFX_schema_name';
            PRINT N'            [!] Expected final definition     : sysname NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PFX_schema_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PFX_table_name
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'metadata.TablePrefix',
            N'PFX_table_name'
        ) IS NULL
        BEGIN

            ALTER TABLE metadata.TablePrefix
                ADD PFX_table_name sysname NULL;


            PRINT N'            [+] Column added                  : PFX_table_name';
            PRINT N'            [!] Pending action                : Backfill PFX_table_name before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_table_name'

            AND TYPE_NAME(c.user_type_id) =
                    N'sysname'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PFX_table_name';

            ;THROW 50006,
                N'Column PFX_table_name exists but does not match the expected data type sysname.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_table_name'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PFX_table_name';
            PRINT N'            [!] Expected final definition     : sysname NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PFX_table_name';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PFX_prefix
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'metadata.TablePrefix',
            N'PFX_prefix'
        ) IS NULL
        BEGIN

            ALTER TABLE metadata.TablePrefix
                ADD PFX_prefix nvarchar(5) NULL;


            PRINT N'            [+] Column added                  : PFX_prefix';
            PRINT N'            [!] Pending action                : Backfill PFX_prefix before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_prefix'

            AND TYPE_NAME(c.user_type_id) =
                    N'nvarchar'

            AND c.max_length = 10
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PFX_prefix';

            ;THROW 50007,
                N'Column PFX_prefix exists but does not match the expected data type nvarchar(5).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_prefix'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PFX_prefix';
            PRINT N'            [!] Expected final definition     : nvarchar(5) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PFX_prefix';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PFX_is_active
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'metadata.TablePrefix',
            N'PFX_is_active'
        ) IS NULL
        BEGIN

            ALTER TABLE metadata.TablePrefix
                ADD PFX_is_active bit NULL;


            PRINT N'            [+] Column added                  : PFX_is_active';
            PRINT N'            [!] Pending action                : Backfill PFX_is_active before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_is_active'

            AND TYPE_NAME(c.user_type_id) =
                    N'bit'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PFX_is_active';

            ;THROW 50008,
                N'Column PFX_is_active exists but does not match the expected data type bit.',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_is_active'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PFX_is_active';
            PRINT N'            [!] Expected final definition     : bit NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PFX_is_active';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PFX_created_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'metadata.TablePrefix',
            N'PFX_created_at'
        ) IS NULL
        BEGIN

            ALTER TABLE metadata.TablePrefix
                ADD PFX_created_at datetime2(0) NULL;


            PRINT N'            [+] Column added                  : PFX_created_at';
            PRINT N'            [!] Pending action                : Backfill PFX_created_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_created_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PFX_created_at';

            ;THROW 50009,
                N'Column PFX_created_at exists but does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_created_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PFX_created_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PFX_created_at';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PFX_updated_at
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'metadata.TablePrefix',
            N'PFX_updated_at'
        ) IS NULL
        BEGIN

            ALTER TABLE metadata.TablePrefix
                ADD PFX_updated_at datetime2(0) NULL;


            PRINT N'            [+] Column added                  : PFX_updated_at';
            PRINT N'            [!] Pending action                : Backfill PFX_updated_at before enforcing NOT NULL';

        END
        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_updated_at'

            AND TYPE_NAME(c.user_type_id) =
                    N'datetime2'

            AND c.scale = 0
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PFX_updated_at';

            ;THROW 50010,
                N'Column PFX_updated_at exists but does not match the expected data type datetime2(0).',
                1;

        END
        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID(N'metadata.TablePrefix')

            AND c.name =
                    N'PFX_updated_at'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PFX_updated_at';
            PRINT N'            [!] Expected final definition     : datetime2(0) NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PFX_updated_at';

        END;

    END;


    /*==============================================================================
        STORAGE STRUCTURE VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.key_constraints AS kc
            ON  kc.parent_object_id = i.object_id
            AND kc.unique_index_id = i.index_id
            AND kc.type = N'PK'

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'PRIMARY'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : metadata.TablePrefix';

        ;THROW 50011,
            N'metadata.TablePrefix is not correctly stored on PRIMARY.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : metadata.TablePrefix';
        PRINT N'            Filegroup                        : PRIMARY';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';