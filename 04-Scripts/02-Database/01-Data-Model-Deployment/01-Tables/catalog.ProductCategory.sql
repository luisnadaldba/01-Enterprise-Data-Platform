    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTCATEGORY
    ==============================================================================

        Object      : catalog.ProductCategory
        Type        : Associative Table
        Prefix      : PRDCT
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Associates products with the catalog categories in which they are
        classified.

        Design Principles
        --------------------------------------------------------------------------
        - Represent the many-to-many relationship between Product and Category.
        - Use the two foreign key columns together as the natural primary key.
        - Do not introduce an artificial identity column.
        - Prevent the same product from being associated with the same category
        more than once.
        - Keep lifecycle and audit columns outside this purely associative entity.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Store catalog relationship data in FG_CORE.
        - Do not partition this low-volume catalog table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    catalog.ProductCategory';
    PRINT N'    ------------------------------------------------------------';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.filegroups
        WHERE name = N'FG_CORE'
    )
    BEGIN

        ;THROW 50380,
            N'Required filegroup FG_CORE does not exist.',
            1;

    END;


    PRINT N'        [✓] Filegroup dependency validated  : FG_CORE';
    PRINT N'';


    /*==============================================================================
        CREATE TABLE
    ==============================================================================*/

    IF OBJECT_ID
    (
        N'catalog.ProductCategory',
        N'U'
    ) IS NULL
    BEGIN

        CREATE TABLE catalog.ProductCategory
        (
            PRDCT_PRD_id    int      NOT NULL,
            PRDCT_CTG_id    smallint NOT NULL,

            CONSTRAINT PK_PRDCT
                PRIMARY KEY CLUSTERED
                (
                    PRDCT_PRD_id,
                    PRDCT_CTG_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductCategory';
        PRINT N'            Prefix                          : PRDCT';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PRDCT_PRD_id, PRDCT_CTG_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductCategory';


        /*--------------------------------------------------------------------------
            COLUMN: PRDCT_PRD_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductCategory',
            N'PRDCT_PRD_id'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductCategory
                ADD PRDCT_PRD_id int NULL;


            PRINT N'            [+] Column added                  : PRDCT_PRD_id';
            PRINT N'            [!] Pending action                : Backfill PRDCT_PRD_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductCategory'
                    )

            AND c.name =
                    N'PRDCT_PRD_id'

            AND TYPE_NAME
            (
                c.user_type_id
            ) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDCT_PRD_id';


            ;THROW 50381,
                N'Column PRDCT_PRD_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductCategory'
                    )

            AND c.name =
                    N'PRDCT_PRD_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDCT_PRD_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDCT_PRD_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDCT_CTG_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductCategory',
            N'PRDCT_CTG_id'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductCategory
                ADD PRDCT_CTG_id smallint NULL;


            PRINT N'            [+] Column added                  : PRDCT_CTG_id';
            PRINT N'            [!] Pending action                : Backfill PRDCT_CTG_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductCategory'
                    )

            AND c.name =
                    N'PRDCT_CTG_id'

            AND TYPE_NAME
            (
                c.user_type_id
            ) = N'smallint'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDCT_CTG_id';


            ;THROW 50382,
                N'Column PRDCT_CTG_id does not match the expected data type smallint.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductCategory'
                    )

            AND c.name =
                    N'PRDCT_CTG_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDCT_CTG_id';
            PRINT N'            [!] Expected final definition     : smallint NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDCT_CTG_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PRDCT
        --------------------------------------------------------------------------*/

        DECLARE @PRDCT_ActualPrimaryKeyName sysname;


        SELECT
            @PRDCT_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        WHERE kc.parent_object_id =
                OBJECT_ID
                (
                    N'catalog.ProductCategory'
                )

        AND kc.type = N'PK';


        IF @PRDCT_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PRDCT';


            ;THROW 50383,
                N'Primary key for catalog.ProductCategory does not exist.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY DEFINITION

            Expected:
                CLUSTERED
                UNIQUE

                Key 1 : PRDCT_PRD_id ASC
                Key 2 : PRDCT_CTG_id ASC
        --------------------------------------------------------------------------*/

        IF NOT EXISTS
        (
            SELECT 1

            FROM sys.key_constraints AS kc

            INNER JOIN sys.indexes AS i
                ON  i.object_id =
                        kc.parent_object_id

                AND i.index_id =
                        kc.unique_index_id

            WHERE kc.parent_object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductCategory'
                    )

            AND kc.type = N'PK'

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

            ) = 2

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
                        kc.parent_object_id

                AND ic.index_id =
                        kc.unique_index_id

                AND ic.key_ordinal = 1

                AND ic.is_descending_key = 0

                AND c.name =
                        N'PRDCT_PRD_id'
            )

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
                        kc.parent_object_id

                AND ic.index_id =
                        kc.unique_index_id

                AND ic.key_ordinal = 2

                AND ic.is_descending_key = 0

                AND c.name =
                        N'PRDCT_CTG_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PRDCT_ActualPrimaryKeyName;


            ;THROW 50384,
                N'Primary key does not match the expected composite definition PRDCT_PRD_id, PRDCT_CTG_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PRDCT_ActualPrimaryKeyName <>
            N'PK_PRDCT'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';

            PRINT N'                Expected                     : PK_PRDCT';

            PRINT N'                Actual                       : '
                + @PRDCT_ActualPrimaryKeyName;

            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PRDCT';

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
            ON  kc.parent_object_id =
                    i.object_id

            AND kc.unique_index_id =
                    i.index_id

            AND kc.type =
                    N'PK'

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID
                (
                    N'catalog.ProductCategory'
                )

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductCategory';


        ;THROW 50385,
            N'catalog.ProductCategory is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductCategory';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';