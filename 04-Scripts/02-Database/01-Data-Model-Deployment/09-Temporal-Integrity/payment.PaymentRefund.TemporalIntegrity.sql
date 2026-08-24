    PRINT N'';
    PRINT N'    ● payment.PaymentRefund';
    PRINT N'';


    /*==============================================================================
        REFUND INTEGRITY: TR_PAYRF_refund_integrity

        Business Rules:
            1. A refund cannot occur before the related payment attempt.

            2. The cumulative refunded amount for a Payment must never exceed the
               original Payment amount.

        Events:
            INSERT
            UPDATE

        Concurrency:
            Affected payment.Payment rows are read with UPDLOCK + HOLDLOCK.

            The Payment row acts as the serialization point shared by refund
            changes and Payment changes.

            This prevents concurrent sessions from independently validating
            incompatible refund/payment states.

            IX_PAYRF_PAY provides the access path used to aggregate refund history
            for affected Payments.

        Important:
            DELETE does not require validation because removing a refund cannot
            increase the cumulative refunded amount or create a refund-before-
            payment condition.

            The inverse integrity path is protected independently by
            payment.TR_PAY_refund_integrity. That trigger prevents later changes
            to PAY_amount or PAY_attempted_at from invalidating existing refunds.
    ==============================================================================*/

    DECLARE @PAYRF_RI_expected_name                 sysname;
    DECLARE @PAYRF_RI_actual_name                   sysname;
    DECLARE @PAYRF_RI_actual_parent                 nvarchar(517);
    DECLARE @PAYRF_RI_actual_is_disabled            bit;
    DECLARE @PAYRF_RI_actual_is_instead_of          bit;
    DECLARE @PAYRF_RI_actual_definition             nvarchar(max);

    DECLARE @PAYRF_RI_expected_definition           nvarchar(max);
    DECLARE @PAYRF_RI_expected_normalized           nvarchar(max);
    DECLARE @PAYRF_RI_actual_normalized             nvarchar(max);

    DECLARE @PAYRF_RI_conflict_parent               nvarchar(517);

    DECLARE @PAYRF_RI_invalid_payment_id            bigint;
    DECLARE @PAYRF_RI_payment_amount                decimal(19,2);
    DECLARE @PAYRF_RI_refunded_amount               decimal(38,2);

    DECLARE @PAYRF_RI_invalid_refund_id             bigint;
    DECLARE @PAYRF_RI_invalid_refunded_at           datetime2(0);
    DECLARE @PAYRF_RI_payment_attempted_at           datetime2(0);


    SET @PAYRF_RI_expected_name =
        N'TR_PAYRF_refund_integrity';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.PaymentRefund', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Refund integrity dependency missing : payment.PaymentRefund';

        ;THROW 51020,
            N'Refund integrity cannot be deployed because payment.PaymentRefund does not exist.',
            1;

    END;


    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Refund integrity dependency missing : payment.Payment';

        ;THROW 51021,
            N'Refund integrity cannot be deployed because payment.Payment does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_id') IS NULL
    OR COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_PAY_id') IS NULL
    OR COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_amount') IS NULL
    OR COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_refunded_at') IS NULL
    BEGIN

        PRINT N'        [X] Refund integrity column dependency missing : payment.PaymentRefund';

        ;THROW 51022,
            N'Refund integrity cannot be deployed because required PaymentRefund columns do not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_id') IS NULL
    OR COL_LENGTH(N'payment.Payment', N'PAY_amount') IS NULL
    OR COL_LENGTH(N'payment.Payment', N'PAY_attempted_at') IS NULL
    BEGIN

        PRINT N'        [X] Refund integrity column dependency missing : payment.Payment';

        ;THROW 51023,
            N'Refund integrity cannot be deployed because required Payment columns do not exist.',
            1;

    END;


    /*------------------------------------------------------------------------------
        INDEX DEPENDENCY

        The refund validation deliberately depends on IX_PAYRF_PAY.

        The trigger contains an explicit INDEX hint, therefore merely validating
        the index name is insufficient.

        Expected access path:
            Type              : NONCLUSTERED
            Unique            : NO
            Key 1             : PAYRF_PAY_id ASC
            Key 2             : PAYRF_refunded_at ASC
            Included Columns  : PAYRF_amount
            Filter            : NONE
            Filegroup         : FG_CORE
            Enabled           : YES
            Hypothetical      : NO
    ------------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.indexes AS i

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id =
                i.data_space_id

        WHERE i.object_id =
                OBJECT_ID(N'payment.PaymentRefund')

        AND i.name =
                N'IX_PAYRF_PAY'

        AND i.type = 2

        AND i.is_unique = 0

        AND i.is_primary_key = 0

        AND i.is_unique_constraint = 0

        AND i.is_disabled = 0

        AND i.is_hypothetical = 0

        AND i.has_filter = 0

        AND ds.name =
                N'FG_CORE'

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
                    N'PAYRF_PAY_id'
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
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.key_ordinal = 2

            AND ic.is_descending_key = 0

            AND c.name =
                    N'PAYRF_refunded_at'
        )

        AND
        (
            SELECT COUNT(*)

            FROM sys.index_columns AS ic

            WHERE ic.object_id =
                    i.object_id

            AND ic.index_id =
                    i.index_id

            AND ic.is_included_column = 1
        ) = 1

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

            AND ic.is_included_column = 1

            AND c.name =
                    N'PAYRF_amount'
        )
    )
    BEGIN

        PRINT N'        [X] Refund integrity index dependency invalid : IX_PAYRF_PAY';
        PRINT N'            Expected Type                   : NONCLUSTERED';
        PRINT N'            Expected Unique                 : NO';
        PRINT N'            Expected Key Columns            : PAYRF_PAY_id ASC, PAYRF_refunded_at ASC';
        PRINT N'            Expected Included Columns       : PAYRF_amount';
        PRINT N'            Expected Filter                 : NONE';
        PRINT N'            Expected Filegroup              : FG_CORE';
        PRINT N'            Expected Enabled                : YES';

        ;THROW 51024,
            N'Refund integrity requires valid enabled index IX_PAYRF_PAY with the expected structure.',
            1;

    END;


    PRINT N'        [✓] Refund integrity dependencies validated';


    /*==============================================================================
        PRE-DEPLOYMENT DATA VALIDATION
    ==============================================================================*/

    /*--------------------------------------------------------------------------
        EXISTING REFUND TIMESTAMP VALIDATION
    --------------------------------------------------------------------------*/

    SET @PAYRF_RI_invalid_refund_id = NULL;
    SET @PAYRF_RI_invalid_refunded_at = NULL;
    SET @PAYRF_RI_payment_attempted_at = NULL;


    SELECT TOP (1)

        @PAYRF_RI_invalid_refund_id =
            R.PAYRF_id,

        @PAYRF_RI_invalid_refunded_at =
            R.PAYRF_refunded_at,

        @PAYRF_RI_payment_attempted_at =
            P.PAY_attempted_at

    FROM payment.PaymentRefund AS R

    INNER JOIN payment.Payment AS P
        ON P.PAY_id =
            R.PAYRF_PAY_id

    WHERE R.PAYRF_refunded_at <
            P.PAY_attempted_at

    ORDER BY
        R.PAYRF_id;


    IF @PAYRF_RI_invalid_refund_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing refund timestamp violation detected';

        PRINT N'            PaymentRefund                   : '
            + CONVERT
            (
                nvarchar(20),
                @PAYRF_RI_invalid_refund_id
            );

        PRINT N'            Refunded At                     : '
            + CONVERT
            (
                nvarchar(19),
                @PAYRF_RI_invalid_refunded_at,
                120
            );

        PRINT N'            Payment Attempted At            : '
            + CONVERT
            (
                nvarchar(19),
                @PAYRF_RI_payment_attempted_at,
                120
            );

        PRINT N'            Rule                            : Refund timestamp cannot precede payment attempt.';
        PRINT N'            Triggers were not created. Existing data must be corrected first.';


        ;THROW 51025,
            N'Refund integrity cannot be deployed because an existing refund precedes its payment attempt.',
            1;

    END;


    /*--------------------------------------------------------------------------
        EXISTING CUMULATIVE REFUND VALIDATION
    --------------------------------------------------------------------------*/

    SET @PAYRF_RI_invalid_payment_id = NULL;
    SET @PAYRF_RI_payment_amount = NULL;
    SET @PAYRF_RI_refunded_amount = NULL;


    SELECT TOP (1)

        @PAYRF_RI_invalid_payment_id =
            P.PAY_id,

        @PAYRF_RI_payment_amount =
            P.PAY_amount,

        @PAYRF_RI_refunded_amount =
            SUM
            (
                CONVERT
                (
                    decimal(38,2),
                    R.PAYRF_amount
                )
            )

    FROM payment.Payment AS P

    INNER JOIN payment.PaymentRefund AS R
        ON R.PAYRF_PAY_id =
            P.PAY_id

    GROUP BY
        P.PAY_id,
        P.PAY_amount

    HAVING
        SUM
        (
            CONVERT
            (
                decimal(38,2),
                R.PAYRF_amount
            )
        )
        >
        CONVERT
        (
            decimal(38,2),
            P.PAY_amount
        )

    ORDER BY
        P.PAY_id;


    IF @PAYRF_RI_invalid_payment_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing cumulative refund violation detected';

        PRINT N'            Payment                         : '
            + CONVERT
            (
                nvarchar(20),
                @PAYRF_RI_invalid_payment_id
            );

        PRINT N'            Payment Amount                  : '
            + CONVERT
            (
                nvarchar(60),
                @PAYRF_RI_payment_amount
            );

        PRINT N'            Refunded Amount                 : '
            + CONVERT
            (
                nvarchar(60),
                @PAYRF_RI_refunded_amount
            );

        PRINT N'            Rule                            : Cumulative refund amount cannot exceed payment amount.';
        PRINT N'            Triggers were not created. Existing data must be corrected first.';


        ;THROW 51026,
            N'Refund integrity cannot be deployed because an existing payment is over-refunded.',
            1;

    END;


    PRINT N'        [✓] Existing refund data validated';


    /*==============================================================================
        EXPECTED TRIGGER DEFINITION
    ==============================================================================*/

    SET @PAYRF_RI_expected_definition =
    N'CREATE TRIGGER payment.TR_PAYRF_refund_integrity
    ON payment.PaymentRefund
    AFTER INSERT, UPDATE
    AS
    BEGIN

        SET NOCOUNT ON;

        /*
            ATLAS REFUND INTEGRITY

            Rules:
              1. Refund timestamp cannot precede payment attempt.
              2. Cumulative refund amount cannot exceed payment amount.

            Version: 2
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
            SERIALIZE REFUND MODIFICATIONS FOR AFFECTED PAYMENTS

            The Payment row is the common serialization point for both sides of
            refund integrity.

            UPDLOCK + HOLDLOCK ensures that refund modifications and concurrent
            Payment modifications affecting the same Payment cannot independently
            validate incompatible states.
        --------------------------------------------------------------------------*/

        DECLARE @PAYRF_payment_lock_count bigint;


        SELECT
            @PAYRF_payment_lock_count =
                COUNT_BIG(*)

        FROM payment.Payment AS P
            WITH
            (
                UPDLOCK,
                HOLDLOCK
            )

        INNER JOIN
        (
            SELECT DISTINCT
                I.PAYRF_PAY_id

            FROM inserted AS I
        ) AS AffectedPayment

            ON AffectedPayment.PAYRF_PAY_id =
                P.PAY_id;


        /*--------------------------------------------------------------------------
            VALIDATE REFUND TIMESTAMP
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN payment.Payment AS P
                ON P.PAY_id =
                    I.PAYRF_PAY_id

            WHERE I.PAYRF_refunded_at <
                    P.PAY_attempted_at
        )
        BEGIN

            ;THROW 51027,
                N''PaymentRefund integrity violation. Refund timestamp cannot precede payment attempt.'',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE CUMULATIVE REFUND AMOUNT

            IX_PAYRF_PAY supplies PAYRF_PAY_id as the leading key and PAYRF_amount
            as an included column.
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM
            (
                SELECT
                    R.PAYRF_PAY_id,

                    SUM
                    (
                        CONVERT
                        (
                            decimal(38,2),
                            R.PAYRF_amount
                        )
                    ) AS RefundedAmount

                FROM payment.PaymentRefund AS R
                    WITH
                    (
                        INDEX(IX_PAYRF_PAY)
                    )

                INNER JOIN
                (
                    SELECT DISTINCT
                        I.PAYRF_PAY_id

                    FROM inserted AS I
                ) AS AffectedPayment

                    ON AffectedPayment.PAYRF_PAY_id =
                        R.PAYRF_PAY_id

                GROUP BY
                    R.PAYRF_PAY_id
            ) AS RefundTotal

            INNER JOIN payment.Payment AS P
                ON P.PAY_id =
                    RefundTotal.PAYRF_PAY_id

            WHERE RefundTotal.RefundedAmount >
                    CONVERT
                    (
                        decimal(38,2),
                        P.PAY_amount
                    )
        )
        BEGIN

            ;THROW 51028,
                N''PaymentRefund integrity violation. Cumulative refund amount cannot exceed payment amount.'',
                1;

        END;

    END;';


    /*==============================================================================
        LOOK FOR EXPECTED TRIGGER
    ==============================================================================*/

    SELECT
        @PAYRF_RI_actual_name =
            tr.name,

        @PAYRF_RI_actual_parent =
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

        @PAYRF_RI_actual_is_disabled =
            tr.is_disabled,

        @PAYRF_RI_actual_is_instead_of =
            tr.is_instead_of_trigger,

        @PAYRF_RI_actual_definition =
            OBJECT_DEFINITION
            (
                tr.object_id
            )

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'payment.PaymentRefund')

    AND tr.name =
            @PAYRF_RI_expected_name;


    /*==============================================================================
        EXPECTED TRIGGER EXISTS
    ==============================================================================*/

    IF @PAYRF_RI_actual_name IS NOT NULL
    BEGIN

        SET @PAYRF_RI_expected_normalized =
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
                                @PAYRF_RI_expected_definition,
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


        SET @PAYRF_RI_actual_normalized =
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
                                @PAYRF_RI_actual_definition,
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


        IF @PAYRF_RI_actual_parent =
                N'[payment].[PaymentRefund]'

        AND @PAYRF_RI_actual_is_disabled = 0

        AND @PAYRF_RI_actual_is_instead_of = 0

        AND @PAYRF_RI_actual_normalized =
                @PAYRF_RI_expected_normalized
        BEGIN

            PRINT N'        [•] Refund integrity validated     : TR_PAYRF_refund_integrity';
            PRINT N'            Events                          : INSERT, UPDATE';
            PRINT N'            Rule 1                          : Refund timestamp >= payment attempt';
            PRINT N'            Rule 2                          : Cumulative refunds <= payment amount';
            PRINT N'            Concurrency Protection          : Payment row UPDLOCK + HOLDLOCK';
            PRINT N'            Aggregate Access Path           : IX_PAYRF_PAY';
            PRINT N'            Enabled                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Refund integrity mismatch      : TR_PAYRF_refund_integrity';

            PRINT N'            Expected Parent                 : payment.PaymentRefund';

            PRINT N'            Actual Parent                   : '
                + COALESCE
                (
                    @PAYRF_RI_actual_parent,
                    N'<NULL>'
                );

            PRINT N'            Expected Trigger Type           : AFTER';

            PRINT N'            Actual Instead Of               : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAYRF_RI_actual_is_instead_of
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
                        @PAYRF_RI_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing trigger was preserved for review.';


            ;THROW 51029,
                N'Trigger TR_PAYRF_refund_integrity exists but does not match the expected refund integrity definition.',
                1;

        END;

    END

    ELSE
    BEGIN

        /*==========================================================================
            VALIDATE EXPECTED NAME IS NOT USED ELSEWHERE
        ==========================================================================*/

        IF OBJECT_ID
        (
            N'payment.TR_PAYRF_refund_integrity',
            N'TR'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PAYRF_RI_conflict_parent =
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
                        N'payment.TR_PAYRF_refund_integrity',
                        N'TR'
                    );


            PRINT N'        [!] Refund integrity name conflict : TR_PAYRF_refund_integrity';

            PRINT N'            Expected Parent                 : payment.PaymentRefund';

            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PAYRF_RI_conflict_parent,
                    N'<UNKNOWN>'
                );

            PRINT N'            Trigger was not created. Manual review is required.';


            ;THROW 51030,
                N'Refund integrity trigger name conflict prevents safe deployment.',
                1;

        END;


        /*==========================================================================
            CREATE REFUND INTEGRITY TRIGGER
        ==========================================================================*/

        EXEC sys.sp_executesql
            @PAYRF_RI_expected_definition;


        PRINT N'        [+] Refund integrity added         : TR_PAYRF_refund_integrity';
        PRINT N'            Events                          : INSERT, UPDATE';
        PRINT N'            Rule 1                          : Refund timestamp >= payment attempt';
        PRINT N'            Rule 2                          : Cumulative refunds <= payment amount';
        PRINT N'            Concurrency Protection          : Payment row UPDLOCK + HOLDLOCK';
        PRINT N'            Aggregate Access Path           : IX_PAYRF_PAY';
        PRINT N'            Enabled                         : YES';

    END;


    PRINT N'';


    /*==============================================================================
        PAYMENT REFUND INVERSE INTEGRITY: TR_PAY_refund_integrity

        Business Rules:
            Existing refunds must remain valid when the parent Payment changes.

            1. PAY_attempted_at cannot be changed to a timestamp later than an
               existing refund timestamp.

            2. PAY_amount cannot be reduced below the cumulative amount already
               refunded.

        Event:
            UPDATE

        Concurrency:
            The Payment row itself is already modified and therefore constitutes
            the serialization point also used by TR_PAYRF_refund_integrity.

            A concurrent refund affecting the same Payment must acquire the
            corresponding Payment row through UPDLOCK + HOLDLOCK and therefore
            cannot independently validate against a Payment state being changed.

        Important:
            INSERT does not require inverse refund validation because a newly
            inserted Payment cannot already have dependent PaymentRefund rows.

            DELETE behavior remains governed by referential integrity.
    ==============================================================================*/

    DECLARE @PAY_RI_expected_name                   sysname;
    DECLARE @PAY_RI_actual_name                     sysname;
    DECLARE @PAY_RI_actual_parent                   nvarchar(517);
    DECLARE @PAY_RI_actual_is_disabled              bit;
    DECLARE @PAY_RI_actual_is_instead_of            bit;
    DECLARE @PAY_RI_actual_definition               nvarchar(max);

    DECLARE @PAY_RI_expected_definition             nvarchar(max);
    DECLARE @PAY_RI_expected_normalized             nvarchar(max);
    DECLARE @PAY_RI_actual_normalized               nvarchar(max);

    DECLARE @PAY_RI_conflict_parent                 nvarchar(517);


    SET @PAY_RI_expected_name =
        N'TR_PAY_refund_integrity';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'payment.Payment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Payment refund integrity dependency missing : payment.Payment';

        ;THROW 51031,
            N'Payment refund integrity cannot be deployed because payment.Payment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'payment.PaymentRefund', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Payment refund integrity dependency missing : payment.PaymentRefund';

        ;THROW 51032,
            N'Payment refund integrity cannot be deployed because payment.PaymentRefund does not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.Payment', N'PAY_id') IS NULL
    OR COL_LENGTH(N'payment.Payment', N'PAY_amount') IS NULL
    OR COL_LENGTH(N'payment.Payment', N'PAY_attempted_at') IS NULL
    BEGIN

        PRINT N'        [X] Payment refund integrity column dependency missing : payment.Payment';

        ;THROW 51033,
            N'Payment refund integrity cannot be deployed because required Payment columns do not exist.',
            1;

    END;


    IF COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_PAY_id') IS NULL
    OR COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_amount') IS NULL
    OR COL_LENGTH(N'payment.PaymentRefund', N'PAYRF_refunded_at') IS NULL
    BEGIN

        PRINT N'        [X] Payment refund integrity column dependency missing : payment.PaymentRefund';

        ;THROW 51034,
            N'Payment refund integrity cannot be deployed because required PaymentRefund columns do not exist.',
            1;

    END;


    /*
        IX_PAYRF_PAY was structurally validated immediately before deployment of
        TR_PAYRF_refund_integrity and is intentionally shared by both directions
        of refund integrity.
    */

    PRINT N'        [✓] Payment refund integrity dependencies validated';


    /*==============================================================================
        EXPECTED TRIGGER DEFINITION
    ==============================================================================*/

    SET @PAY_RI_expected_definition =
    N'CREATE TRIGGER payment.TR_PAY_refund_integrity
    ON payment.Payment
    AFTER UPDATE
    AS
    BEGIN

        SET NOCOUNT ON;

        /*
            ATLAS PAYMENT REFUND INTEGRITY

            Rules:
              1. Payment attempt timestamp cannot move beyond an existing refund.
              2. Payment amount cannot fall below cumulative existing refunds.

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


        /*
            Nothing related to refund integrity changed.

            Avoid refund-history access for unrelated Payment updates.
        */

        IF NOT UPDATE(PAY_amount)
        AND NOT UPDATE(PAY_attempted_at)
        BEGIN
            RETURN;
        END;


        /*--------------------------------------------------------------------------
            VALIDATE PAYMENT ATTEMPT TIMESTAMP AGAINST EXISTING REFUNDS
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN payment.PaymentRefund AS R
                WITH
                (
                    INDEX(IX_PAYRF_PAY)
                )

                ON R.PAYRF_PAY_id =
                    I.PAY_id

            WHERE R.PAYRF_refunded_at <
                    I.PAY_attempted_at
        )
        BEGIN

            ;THROW 51035,
                N''Payment refund integrity violation. PAY_attempted_at cannot be later than an existing refund timestamp.'',
                1;

        END;


        /*--------------------------------------------------------------------------
            VALIDATE PAYMENT AMOUNT AGAINST EXISTING CUMULATIVE REFUNDS
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN
            (
                SELECT
                    R.PAYRF_PAY_id,

                    SUM
                    (
                        CONVERT
                        (
                            decimal(38,2),
                            R.PAYRF_amount
                        )
                    ) AS RefundedAmount

                FROM payment.PaymentRefund AS R
                    WITH
                    (
                        INDEX(IX_PAYRF_PAY)
                    )

                INNER JOIN inserted AS AffectedPayment
                    ON AffectedPayment.PAY_id =
                        R.PAYRF_PAY_id

                GROUP BY
                    R.PAYRF_PAY_id
            ) AS RefundTotal

                ON RefundTotal.PAYRF_PAY_id =
                    I.PAY_id

            WHERE RefundTotal.RefundedAmount >
                    CONVERT
                    (
                        decimal(38,2),
                        I.PAY_amount
                    )
        )
        BEGIN

            ;THROW 51036,
                N''Payment refund integrity violation. PAY_amount cannot be lower than cumulative existing refunds.'',
                1;

        END;

    END;';


    /*==============================================================================
        LOOK FOR EXPECTED TRIGGER
    ==============================================================================*/

    SELECT
        @PAY_RI_actual_name =
            tr.name,

        @PAY_RI_actual_parent =
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

        @PAY_RI_actual_is_disabled =
            tr.is_disabled,

        @PAY_RI_actual_is_instead_of =
            tr.is_instead_of_trigger,

        @PAY_RI_actual_definition =
            OBJECT_DEFINITION
            (
                tr.object_id
            )

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'payment.Payment')

    AND tr.name =
            @PAY_RI_expected_name;


    /*==============================================================================
        EXPECTED TRIGGER EXISTS
    ==============================================================================*/

    IF @PAY_RI_actual_name IS NOT NULL
    BEGIN

        SET @PAY_RI_expected_normalized =
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
                                @PAY_RI_expected_definition,
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


        SET @PAY_RI_actual_normalized =
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
                                @PAY_RI_actual_definition,
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


        IF @PAY_RI_actual_parent =
                N'[payment].[Payment]'

        AND @PAY_RI_actual_is_disabled = 0

        AND @PAY_RI_actual_is_instead_of = 0

        AND @PAY_RI_actual_normalized =
                @PAY_RI_expected_normalized
        BEGIN

            PRINT N'        [•] Payment refund integrity validated : TR_PAY_refund_integrity';
            PRINT N'            Events                          : UPDATE';
            PRINT N'            Rule 1                          : PAY_attempted_at <= existing refund timestamps';
            PRINT N'            Rule 2                          : PAY_amount >= cumulative refunds';
            PRINT N'            Serialization Point             : Payment row';
            PRINT N'            Aggregate Access Path           : IX_PAYRF_PAY';
            PRINT N'            Enabled                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Payment refund integrity mismatch : TR_PAY_refund_integrity';

            PRINT N'            Expected Parent                 : payment.Payment';

            PRINT N'            Actual Parent                   : '
                + COALESCE
                (
                    @PAY_RI_actual_parent,
                    N'<NULL>'
                );

            PRINT N'            Expected Trigger Type           : AFTER';

            PRINT N'            Actual Instead Of               : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PAY_RI_actual_is_instead_of
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
                        @PAY_RI_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing trigger was preserved for review.';


            ;THROW 51037,
                N'Trigger TR_PAY_refund_integrity exists but does not match the expected payment refund integrity definition.',
                1;

        END;

    END

    ELSE
    BEGIN

        /*==========================================================================
            VALIDATE EXPECTED NAME IS NOT USED ELSEWHERE
        ==========================================================================*/

        IF OBJECT_ID
        (
            N'payment.TR_PAY_refund_integrity',
            N'TR'
        ) IS NOT NULL
        BEGIN

            SELECT
                @PAY_RI_conflict_parent =
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
                        N'payment.TR_PAY_refund_integrity',
                        N'TR'
                    );


            PRINT N'        [!] Payment refund integrity name conflict : TR_PAY_refund_integrity';

            PRINT N'            Expected Parent                 : payment.Payment';

            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @PAY_RI_conflict_parent,
                    N'<UNKNOWN>'
                );

            PRINT N'            Trigger was not created. Manual review is required.';


            ;THROW 51038,
                N'Payment refund integrity trigger name conflict prevents safe deployment.',
                1;

        END;


        /*==========================================================================
            CREATE PAYMENT REFUND INTEGRITY TRIGGER
        ==========================================================================*/

        EXEC sys.sp_executesql
            @PAY_RI_expected_definition;


        PRINT N'        [+] Payment refund integrity added : TR_PAY_refund_integrity';
        PRINT N'            Events                          : UPDATE';
        PRINT N'            Rule 1                          : PAY_attempted_at <= existing refund timestamps';
        PRINT N'            Rule 2                          : PAY_amount >= cumulative refunds';
        PRINT N'            Serialization Point             : Payment row';
        PRINT N'            Aggregate Access Path           : IX_PAYRF_PAY';
        PRINT N'            Enabled                         : YES';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';