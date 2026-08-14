    PRINT N'    catalog.ProductVariantPrice';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        TEMPORAL INTEGRITY: TR_PRDVP_no_overlap

        Business Rule:
            Price validity periods belonging to the same ProductVariant must never
            overlap.

        Interval Semantics:
            PRDVP_valid_from is inclusive.
            PRDVP_valid_to   is exclusive.
            NULL valid_to represents an open-ended interval.

            Therefore:

                [2026-08-14, 2026-08-20)
                [2026-08-20, 2026-08-30)

            are adjacent and valid.

        Overlap Rule:
            Two intervals A and B overlap when:

                (B.valid_to IS NULL OR A.valid_from < B.valid_to)

            AND

                (A.valid_to IS NULL OR B.valid_from < A.valid_to)

        Events:
            INSERT
            UPDATE

        Concurrency:
            The temporal history of affected ProductVariants is read using
            UPDLOCK + HOLDLOCK through IX_PRDVP_PRDVA_valid_from.

            This serializes competing temporal modifications for the same
            ProductVariant and prevents concurrent sessions from independently
            validating incompatible price periods.

        Important:
            DELETE does not require overlap validation because removing a period
            cannot introduce a new overlap.
    ==============================================================================*/

    DECLARE @PRDVP_TI_expected_name                 sysname;
    DECLARE @PRDVP_TI_actual_name                   sysname;
    DECLARE @PRDVP_TI_actual_parent                 nvarchar(517);
    DECLARE @PRDVP_TI_actual_is_disabled            bit;
    DECLARE @PRDVP_TI_actual_is_instead_of          bit;
    DECLARE @PRDVP_TI_actual_definition             nvarchar(max);

    DECLARE @PRDVP_TI_expected_definition           nvarchar(max);
    DECLARE @PRDVP_TI_expected_normalized           nvarchar(max);
    DECLARE @PRDVP_TI_actual_normalized             nvarchar(max);

    DECLARE @PRDVP_TI_conflict_parent               nvarchar(517);

    DECLARE @PRDVP_TI_overlap_variant               int;
    DECLARE @PRDVP_TI_overlap_first_id              bigint;
    DECLARE @PRDVP_TI_overlap_second_id             bigint;


    SET @PRDVP_TI_expected_name =
        N'TR_PRDVP_no_overlap';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantPrice', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity dependency missing : catalog.ProductVariantPrice';

        ;THROW 50530,
            N'Temporal integrity cannot be deployed because catalog.ProductVariantPrice does not exist.',
            1;

    END;


    IF COL_LENGTH
    (
        N'catalog.ProductVariantPrice',
        N'PRDVP_id'
    ) IS NULL
    OR COL_LENGTH
    (
        N'catalog.ProductVariantPrice',
        N'PRDVP_PRDVA_id'
    ) IS NULL
    OR COL_LENGTH
    (
        N'catalog.ProductVariantPrice',
        N'PRDVP_valid_from'
    ) IS NULL
    OR COL_LENGTH
    (
        N'catalog.ProductVariantPrice',
        N'PRDVP_valid_to'
    ) IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity column dependency missing';

        ;THROW 50531,
            N'Temporal integrity cannot be deployed because required ProductVariantPrice columns do not exist.',
            1;

    END;


    /*------------------------------------------------------------------------------
        INDEX DEPENDENCY

        The temporal validation deliberately depends on the historical access
        index because it is also used to serialize affected ProductVariant ranges.
    ------------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        WHERE i.object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND i.name =
                N'IX_PRDVP_PRDVA_valid_from'

        AND i.type = 2

        AND i.is_disabled = 0

        AND i.is_hypothetical = 0
    )
    BEGIN

        PRINT N'        [X] Temporal integrity index dependency missing : IX_PRDVP_PRDVA_valid_from';

        ;THROW 50532,
            N'Temporal integrity requires enabled index IX_PRDVP_PRDVA_valid_from.',
            1;

    END;


    PRINT N'        [✓] Temporal integrity dependencies validated';


    /*==============================================================================
        PRE-DEPLOYMENT DATA VALIDATION

        The trigger must not be deployed over data that already violates the
        temporal rule.

        Only one representative conflicting pair is reported because deployment
        stops immediately for manual data correction.
    ==============================================================================*/

    SELECT TOP (1)

        @PRDVP_TI_overlap_variant =
            A.PRDVP_PRDVA_id,

        @PRDVP_TI_overlap_first_id =
            A.PRDVP_id,

        @PRDVP_TI_overlap_second_id =
            B.PRDVP_id

    FROM catalog.ProductVariantPrice AS A

    INNER JOIN catalog.ProductVariantPrice AS B
        ON  B.PRDVP_PRDVA_id =
                A.PRDVP_PRDVA_id

        AND B.PRDVP_id >
                A.PRDVP_id

    WHERE
    (
        B.PRDVP_valid_to IS NULL
        OR A.PRDVP_valid_from < B.PRDVP_valid_to
    )

    AND
    (
        A.PRDVP_valid_to IS NULL
        OR B.PRDVP_valid_from < A.PRDVP_valid_to
    )

    ORDER BY
        A.PRDVP_PRDVA_id,
        A.PRDVP_id,
        B.PRDVP_id;


    IF @PRDVP_TI_overlap_variant IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing temporal overlap detected';

        PRINT N'            ProductVariant                  : '
            + CONVERT
            (
                nvarchar(20),
                @PRDVP_TI_overlap_variant
            );

        PRINT N'            First Price Row                 : '
            + CONVERT
            (
                nvarchar(20),
                @PRDVP_TI_overlap_first_id
            );

        PRINT N'            Second Price Row                : '
            + CONVERT
            (
                nvarchar(20),
                @PRDVP_TI_overlap_second_id
            );

        PRINT N'            Rule                            : Price validity periods for the same ProductVariant cannot overlap.';
        PRINT N'            Trigger was not created. Existing data must be corrected first.';


        ;THROW 50533,
            N'Temporal integrity cannot be deployed because existing ProductVariantPrice periods overlap.',
            1;

    END;


    PRINT N'        [✓] Existing temporal data validated';


    /*==============================================================================
        EXPECTED TRIGGER DEFINITION
    ==============================================================================*/

    SET @PRDVP_TI_expected_definition =
    N'CREATE TRIGGER catalog.TR_PRDVP_no_overlap
    ON catalog.ProductVariantPrice
    AFTER INSERT, UPDATE
    AS
    BEGIN

        SET NOCOUNT ON;

        /*
            ATLAS TEMPORAL INTEGRITY
            Rule: ProductVariantPrice validity periods must not overlap.
            Version: 1
        */

        IF NOT EXISTS
        (
            SELECT 1
            FROM inserted
        )
        BEGIN
            RETURN;
        END;


        /*--------------------------------------------------------------------------
            SERIALIZE TEMPORAL MODIFICATIONS FOR AFFECTED PRODUCT VARIANTS

            HOLDLOCK provides SERIALIZABLE semantics for the statement.

            UPDLOCK prevents concurrent temporal writers from independently
            validating the same ProductVariant history.

            The historical index provides an efficient access path for the
            affected ProductVariant ranges.
        --------------------------------------------------------------------------*/

        DECLARE @PRDVP_lock_count bigint;


        SELECT
            @PRDVP_lock_count =
                COUNT_BIG(*)

        FROM catalog.ProductVariantPrice AS P
            WITH
            (
                UPDLOCK,
                HOLDLOCK,
                INDEX(IX_PRDVP_PRDVA_valid_from)
            )

        INNER JOIN
        (
            SELECT DISTINCT
                I.PRDVP_PRDVA_id

            FROM inserted AS I
        ) AS AffectedVariant

            ON AffectedVariant.PRDVP_PRDVA_id =
                P.PRDVP_PRDVA_id;


        /*--------------------------------------------------------------------------
            VALIDATE RESULTING TEMPORAL STATE

            Only ProductVariants affected by the current DML operation need to be
            inspected.

            The validation compares every pair of price periods belonging to those
            variants.

            PRDVP_id ordering prevents each pair from being evaluated twice.
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM catalog.ProductVariantPrice AS A

            INNER JOIN catalog.ProductVariantPrice AS B
                ON  B.PRDVP_PRDVA_id =
                        A.PRDVP_PRDVA_id

                AND B.PRDVP_id >
                        A.PRDVP_id

            INNER JOIN
            (
                SELECT DISTINCT
                    I.PRDVP_PRDVA_id

                FROM inserted AS I
            ) AS AffectedVariant

                ON AffectedVariant.PRDVP_PRDVA_id =
                    A.PRDVP_PRDVA_id

            WHERE
            (
                B.PRDVP_valid_to IS NULL
                OR A.PRDVP_valid_from < B.PRDVP_valid_to
            )

            AND
            (
                A.PRDVP_valid_to IS NULL
                OR B.PRDVP_valid_from < A.PRDVP_valid_to
            )
        )
        BEGIN

            ;THROW 50534,
                N''ProductVariantPrice temporal overlap detected. Price validity periods for the same ProductVariant cannot overlap.'',
                1;

        END;

    END;';


    /*==============================================================================
        LOOK FOR EXPECTED TRIGGER
    ==============================================================================*/

    SELECT
        @PRDVP_TI_actual_name =
            tr.name,

        @PRDVP_TI_actual_parent =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME
                (
                    tr.parent_id
                )
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME
                (
                    tr.parent_id
                )
            ),

        @PRDVP_TI_actual_is_disabled =
            tr.is_disabled,

        @PRDVP_TI_actual_is_instead_of =
            tr.is_instead_of_trigger,

        @PRDVP_TI_actual_definition =
            OBJECT_DEFINITION
            (
                tr.object_id
            )

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND tr.name =
            @PRDVP_TI_expected_name;


    /*==============================================================================
        EXPECTED TRIGGER EXISTS
    ==============================================================================*/

    IF @PRDVP_TI_actual_name IS NOT NULL
    BEGIN

        /*--------------------------------------------------------------------------
            NORMALIZE DEFINITIONS

            Formatting differences are ignored.

            Structural SQL differences remain visible through comparison of the
            normalized definitions.
        --------------------------------------------------------------------------*/

        SET @PRDVP_TI_expected_normalized =
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
                                @PRDVP_TI_expected_definition,
                                N' ',
                                N''
                            ),
                            NCHAR(9),
                            N''
                        ),
                        NCHAR(13),
                        N''
                    ),
                    NCHAR(10),
                    N''
                )
            );


        SET @PRDVP_TI_actual_normalized =
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
                                @PRDVP_TI_actual_definition,
                                N' ',
                                N''
                            ),
                            NCHAR(9),
                            N''
                        ),
                        NCHAR(13),
                        N''
                    ),
                    NCHAR(10),
                    N''
                )
            );


        IF @PRDVP_TI_actual_parent =
                N'[catalog].[ProductVariantPrice]'

        AND @PRDVP_TI_actual_is_disabled = 0

        AND @PRDVP_TI_actual_is_instead_of = 0

        AND @PRDVP_TI_actual_normalized =
                @PRDVP_TI_expected_normalized
        BEGIN

            PRINT N'        [•] Temporal integrity validated   : TR_PRDVP_no_overlap';
            PRINT N'            Events                          : INSERT, UPDATE';
            PRINT N'            Rule                            : No overlapping price validity periods';
            PRINT N'            Interval Model                  : [valid_from, valid_to)';
            PRINT N'            Open End                        : PRDVP_valid_to IS NULL';
            PRINT N'            Concurrency Protection          : UPDLOCK + HOLDLOCK';
            PRINT N'            Enabled                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Temporal integrity mismatch    : TR_PRDVP_no_overlap';

            PRINT N'            Expected Parent                 : catalog.ProductVariantPrice';

            PRINT N'            Actual Parent                   : '
                + COALESCE
                (
                    @PRDVP_TI_actual_parent,
                    N'<NULL>'
                );

            PRINT N'            Expected Trigger Type           : AFTER';

            PRINT N'            Actual Instead Of               : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_TI_actual_is_instead_of
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';

            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_TI_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing trigger was preserved for review.';


            ;THROW 50535,
                N'Trigger TR_PRDVP_no_overlap exists but does not match the expected temporal integrity definition.',
                1;

        END;

    END

    ELSE
    BEGIN

        /*==============================================================================
            VALIDATE EXPECTED NAME IS NOT USED ELSEWHERE
        ==============================================================================*/

        IF OBJECT_ID
        (
            N'catalog.TR_PRDVP_no_overlap',
            N'TR'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PRDVP_TI_conflict_parent =
                    QUOTENAME
                    (
                        OBJECT_SCHEMA_NAME
                        (
                            tr.parent_id
                        )
                    )
                    + N'.'
                    + QUOTENAME
                    (
                        OBJECT_NAME
                        (
                            tr.parent_id
                        )
                    )

            FROM sys.triggers AS tr

            WHERE tr.object_id =
                    OBJECT_ID
                    (
                        N'catalog.TR_PRDVP_no_overlap',
                        N'TR'
                    );


            PRINT N'        [!] Temporal integrity name conflict : TR_PRDVP_no_overlap';

            PRINT N'            Expected Parent                 : catalog.ProductVariantPrice';

            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PRDVP_TI_conflict_parent,
                    N'<UNKNOWN>'
                );

            PRINT N'            Trigger was not created. Manual review is required.';


            ;THROW 50536,
                N'Temporal integrity trigger name conflict prevents safe deployment.',
                1;

        END;


        /*==============================================================================
            CREATE TEMPORAL INTEGRITY TRIGGER

            Dynamic SQL is required because CREATE TRIGGER must begin its batch.
        ==============================================================================*/

        EXEC sys.sp_executesql
            @PRDVP_TI_expected_definition;


        PRINT N'        [+] Temporal integrity added       : TR_PRDVP_no_overlap';
        PRINT N'            Events                          : INSERT, UPDATE';
        PRINT N'            Rule                            : No overlapping price validity periods';
        PRINT N'            Interval Model                  : [valid_from, valid_to)';
        PRINT N'            Open End                        : PRDVP_valid_to IS NULL';
        PRINT N'            Concurrency Protection          : UPDLOCK + HOLDLOCK';
        PRINT N'            Enabled                         : YES';

    END;


    PRINT N'';