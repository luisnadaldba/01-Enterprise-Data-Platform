    /*==============================================================================
        ATLAS COMMERCE - CATALOG.PRODUCTVARIANTATTRIBUTEVALUE
    ==============================================================================

        Object      : catalog.ProductVariantAttributeValue
        Type        : Associative Table
        Prefix      : PRDAV
        Database    : AtlasCommerce
        Filegroup   : FG_CORE

        Purpose
        --------------------------------------------------------------------------
        Associates sellable product variants with the controlled attribute values
        that define their catalog characteristics.

        Design Principles
        --------------------------------------------------------------------------
        - Represent the relationship between ProductVariant and
          ProductAttributeValue.
        - Use the two foreign key columns together as the natural primary key.
        - Do not introduce an artificial identity column.
        - Prevent the same attribute value from being assigned more than once
          to the same product variant.
        - Keep lifecycle and audit columns outside this purely associative entity.
        - Deploy foreign key constraints in the dedicated FK stage.
        - Store catalog relationship data in FG_CORE.
        - Do not partition this low-volume catalog table.

    ==============================================================================*/

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    PRINT N'';
    PRINT N'    ● catalog.ProductVariantAttributeValue';
    PRINT N'';


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

        ;THROW 50340,
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
        N'catalog.ProductVariantAttributeValue',
        N'U'
    ) IS NULL
    BEGIN

        CREATE TABLE catalog.ProductVariantAttributeValue
        (
            PRDAV_PRDVA_id    int NOT NULL,
            PRDAV_PATVL_id    int NOT NULL,

            CONSTRAINT PK_PRDAV
                PRIMARY KEY CLUSTERED
                (
                    PRDAV_PRDVA_id,
                    PRDAV_PATVL_id
                )
                ON FG_CORE
        )
        ON FG_CORE;


        PRINT N'        [+] Table created                   : catalog.ProductVariantAttributeValue';
        PRINT N'            Prefix                          : PRDAV';
        PRINT N'            Filegroup                       : FG_CORE';
        PRINT N'            Primary Key                     : PRDAV_PRDVA_id, PRDAV_PATVL_id';

    END

    ELSE
    BEGIN

        PRINT N'        [•] Table already exists            : catalog.ProductVariantAttributeValue';


        /*--------------------------------------------------------------------------
            COLUMN: PRDAV_PRDVA_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantAttributeValue',
            N'PRDAV_PRDVA_id'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantAttributeValue
                ADD PRDAV_PRDVA_id int NULL;


            PRINT N'            [+] Column added                  : PRDAV_PRDVA_id';
            PRINT N'            [!] Pending action                : Backfill PRDAV_PRDVA_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductVariantAttributeValue'
                    )

            AND c.name =
                    N'PRDAV_PRDVA_id'

            AND TYPE_NAME
            (
                c.user_type_id
            ) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDAV_PRDVA_id';


            ;THROW 50341,
                N'Column PRDAV_PRDVA_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductVariantAttributeValue'
                    )

            AND c.name =
                    N'PRDAV_PRDVA_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDAV_PRDVA_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDAV_PRDVA_id';

        END;


        /*--------------------------------------------------------------------------
            COLUMN: PRDAV_PATVL_id
        --------------------------------------------------------------------------*/

        IF COL_LENGTH
        (
            N'catalog.ProductVariantAttributeValue',
            N'PRDAV_PATVL_id'
        ) IS NULL
        BEGIN

            ALTER TABLE catalog.ProductVariantAttributeValue
                ADD PRDAV_PATVL_id int NULL;


            PRINT N'            [+] Column added                  : PRDAV_PATVL_id';
            PRINT N'            [!] Pending action                : Backfill PRDAV_PATVL_id before enforcing NOT NULL';

        END

        ELSE IF NOT EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductVariantAttributeValue'
                    )

            AND c.name =
                    N'PRDAV_PATVL_id'

            AND TYPE_NAME
            (
                c.user_type_id
            ) = N'int'
        )
        BEGIN

            PRINT N'            [X] Column definition mismatch    : PRDAV_PATVL_id';


            ;THROW 50342,
                N'Column PRDAV_PATVL_id does not match the expected data type int.',
                1;

        END

        ELSE IF EXISTS
        (
            SELECT 1

            FROM sys.columns AS c

            WHERE c.object_id =
                    OBJECT_ID
                    (
                        N'catalog.ProductVariantAttributeValue'
                    )

            AND c.name =
                    N'PRDAV_PATVL_id'

            AND c.is_nullable = 1
        )
        BEGIN

            PRINT N'            [!] Column nullable               : PRDAV_PATVL_id';
            PRINT N'            [!] Expected final definition     : int NOT NULL';
            PRINT N'            [!] Pending action                : Backfill and enforce NOT NULL';

        END

        ELSE
        BEGIN

            PRINT N'            [•] Column validated              : PRDAV_PATVL_id';

        END;


        /*--------------------------------------------------------------------------
            PRIMARY KEY: PK_PRDAV
        --------------------------------------------------------------------------*/

        DECLARE @PRDAV_ActualPrimaryKeyName sysname;


        SELECT
            @PRDAV_ActualPrimaryKeyName =
                kc.name

        FROM sys.key_constraints AS kc

        WHERE kc.parent_object_id =
                OBJECT_ID
                (
                    N'catalog.ProductVariantAttributeValue'
                )

        AND kc.type = N'PK';


        IF @PRDAV_ActualPrimaryKeyName IS NULL
        BEGIN

            PRINT N'            [X] Primary key missing            : PK_PRDAV';


            ;THROW 50343,
                N'Primary key for catalog.ProductVariantAttributeValue does not exist.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY DEFINITION

            Expected:
                CLUSTERED
                UNIQUE

                Key 1 : PRDAV_PRDVA_id ASC
                Key 2 : PRDAV_PATVL_id ASC
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
                        N'catalog.ProductVariantAttributeValue'
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
                        N'PRDAV_PRDVA_id'
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
                        N'PRDAV_PATVL_id'
            )
        )
        BEGIN

            PRINT N'            [X] Primary key definition mismatch : '
                + @PRDAV_ActualPrimaryKeyName;


            ;THROW 50344,
                N'Primary key does not match the expected composite definition PRDAV_PRDVA_id, PRDAV_PATVL_id.',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PRIMARY KEY NAME
        --------------------------------------------------------------------------*/

        IF @PRDAV_ActualPrimaryKeyName <>
            N'PK_PRDAV'
        BEGIN

            PRINT N'            [!] Primary key naming divergence :';

            PRINT N'                Expected                     : PK_PRDAV';

            PRINT N'                Actual                       : '
                + @PRDAV_ActualPrimaryKeyName;

            PRINT N'                Action                       : Preserve existing primary key';

        END
        ELSE
        BEGIN

            PRINT N'            [•] Primary key validated          : PK_PRDAV';

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
                    N'catalog.ProductVariantAttributeValue'
                )

        AND i.type = 1

        AND i.is_unique = 1

        AND ds.name =
                N'FG_CORE'
    )
    BEGIN

        PRINT N'        [X] Storage structure mismatch       : catalog.ProductVariantAttributeValue';


        ;THROW 50345,
            N'catalog.ProductVariantAttributeValue is not correctly stored on FG_CORE.',
            1;

    END
    ELSE
    BEGIN

        PRINT N'        [•] Storage structure validated      : catalog.ProductVariantAttributeValue';
        PRINT N'            Filegroup                        : FG_CORE';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';