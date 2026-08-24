    PRINT N'';
    PRINT N'    ● inventory.InventoryReservation';
    PRINT N'';


    /*==============================================================================
        RESERVATION TEMPORAL INTEGRITY: TR_INVRE_reservation_temporal_integrity

        Business Rules:
            1. ACTIVE reservations must not have a closing timestamp.

            2. CONSUMED, RELEASED and EXPIRED reservations must have a closing
            timestamp.

            3. An EXPIRED reservation cannot be closed before its configured
            expiration timestamp.

            4. InventoryReservation rows may use only the reservation lifecycle
            statuses currently defined by Atlas Commerce:
                ACTIVE
                CONSUMED
                RELEASED
                EXPIRED

            5. The ProductVariant stored in InventoryReservation must match the
            ProductVariant of the referenced sales.TransactionItem.

        Events:
            INSERT
            UPDATE

        Important:
            DELETE does not require validation because removing a reservation row
            cannot create an invalid lifecycle or ProductVariant relationship in
            another reservation.

            Status IDs are deliberately not hard-coded. Status meaning is resolved
            through inventory.InventoryReservationStatus.INVRS_name.
    ==============================================================================*/

    DECLARE @INVRE_TI_expected_name                 sysname;
    DECLARE @INVRE_TI_actual_name                   sysname;
    DECLARE @INVRE_TI_actual_parent                 nvarchar(517);
    DECLARE @INVRE_TI_actual_is_disabled            bit;
    DECLARE @INVRE_TI_actual_is_instead_of          bit;
    DECLARE @INVRE_TI_actual_definition             nvarchar(max);

    DECLARE @INVRE_TI_expected_definition           nvarchar(max);
    DECLARE @INVRE_TI_expected_normalized           nvarchar(max);
    DECLARE @INVRE_TI_actual_normalized             nvarchar(max);

    DECLARE @INVRE_TI_conflict_parent               nvarchar(517);

    DECLARE @INVRE_TI_invalid_id                    bigint;
    DECLARE @INVRE_TI_invalid_status                nvarchar(50);
    DECLARE @INVRE_TI_invalid_expires_at            datetime2(0);
    DECLARE @INVRE_TI_invalid_closed_at             datetime2(0);

    DECLARE @INVRE_TI_invalid_TRNIT_id              bigint;
    DECLARE @INVRE_TI_expected_PRDVA_id             int;
    DECLARE @INVRE_TI_actual_PRDVA_id               int;


    SET @INVRE_TI_expected_name =
        N'TR_INVRE_reservation_temporal_integrity';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryReservation', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity dependency missing : inventory.InventoryReservation';

        ;THROW 51040,
            N'Reservation temporal integrity cannot be deployed because inventory.InventoryReservation does not exist.',
            1;

    END;


    IF OBJECT_ID(N'inventory.InventoryReservationStatus', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity dependency missing : inventory.InventoryReservationStatus';

        ;THROW 51041,
            N'Reservation temporal integrity cannot be deployed because inventory.InventoryReservationStatus does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity dependency missing : sales.TransactionItem';

        ;THROW 51042,
            N'Reservation temporal integrity cannot be deployed because sales.TransactionItem does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_id') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_id') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_TRNIT_transaction_at') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_PRDVA_id') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_INVRS_id') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_expires_at') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservation', N'INVRE_closed_at') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity column dependency missing : inventory.InventoryReservation';

        ;THROW 51043,
            N'Reservation temporal integrity cannot be deployed because required InventoryReservation columns do not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryReservationStatus', N'INVRS_id') IS NULL
    OR COL_LENGTH(N'inventory.InventoryReservationStatus', N'INVRS_name') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity column dependency missing : inventory.InventoryReservationStatus';

        ;THROW 51044,
            N'Reservation temporal integrity cannot be deployed because required InventoryReservationStatus columns do not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_id') IS NULL
    OR COL_LENGTH(N'sales.TransactionItem', N'TRNIT_transaction_at') IS NULL
    OR COL_LENGTH(N'sales.TransactionItem', N'TRNIT_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Temporal integrity column dependency missing : sales.TransactionItem';

        ;THROW 51045,
            N'Reservation temporal integrity cannot be deployed because required TransactionItem columns do not exist.',
            1;

    END;


    PRINT N'        [✓] Reservation temporal integrity dependencies validated';


    /*==============================================================================
        PRE-DEPLOYMENT DATA VALIDATION
    ==============================================================================*/

    /*--------------------------------------------------------------------------
        VALIDATE RECOGNIZED RESERVATION STATUS
    --------------------------------------------------------------------------*/

    SET @INVRE_TI_invalid_id = NULL;
    SET @INVRE_TI_invalid_status = NULL;


    SELECT TOP (1)
        @INVRE_TI_invalid_id =
            R.INVRE_id,

        @INVRE_TI_invalid_status =
            S.INVRS_name

    FROM inventory.InventoryReservation AS R

    INNER JOIN inventory.InventoryReservationStatus AS S
        ON S.INVRS_id =
            R.INVRE_INVRS_id

    WHERE S.INVRS_name NOT IN
    (
        N'ACTIVE',
        N'CONSUMED',
        N'RELEASED',
        N'EXPIRED'
    )

    ORDER BY
        R.INVRE_id;


    IF @INVRE_TI_invalid_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing reservation status violation detected';
        PRINT N'            InventoryReservation             : '
            + CONVERT(nvarchar(20), @INVRE_TI_invalid_id);
        PRINT N'            Status                           : '
            + COALESCE(@INVRE_TI_invalid_status, N'<NULL>');
        PRINT N'            Rule                             : Reservation must use a recognized lifecycle status.';
        PRINT N'            Trigger was not created. Existing data must be corrected first.';


        ;THROW 51046,
            N'Reservation temporal integrity cannot be deployed because an existing reservation uses an unsupported lifecycle status.',
            1;

    END;


    /*--------------------------------------------------------------------------
        ACTIVE MUST REMAIN OPEN
    --------------------------------------------------------------------------*/

    SET @INVRE_TI_invalid_id = NULL;
    SET @INVRE_TI_invalid_closed_at = NULL;


    SELECT TOP (1)
        @INVRE_TI_invalid_id =
            R.INVRE_id,

        @INVRE_TI_invalid_closed_at =
            R.INVRE_closed_at

    FROM inventory.InventoryReservation AS R

    INNER JOIN inventory.InventoryReservationStatus AS S
        ON S.INVRS_id =
            R.INVRE_INVRS_id

    WHERE S.INVRS_name = N'ACTIVE'
    AND R.INVRE_closed_at IS NOT NULL

    ORDER BY
        R.INVRE_id;


    IF @INVRE_TI_invalid_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing ACTIVE reservation closure violation detected';
        PRINT N'            InventoryReservation             : '
            + CONVERT(nvarchar(20), @INVRE_TI_invalid_id);
        PRINT N'            Closed At                        : '
            + CONVERT(nvarchar(19), @INVRE_TI_invalid_closed_at, 120);
        PRINT N'            Rule                             : ACTIVE reservation must have INVRE_closed_at = NULL.';
        PRINT N'            Trigger was not created. Existing data must be corrected first.';


        ;THROW 51047,
            N'Reservation temporal integrity cannot be deployed because an ACTIVE reservation is already closed.',
            1;

    END;


    /*--------------------------------------------------------------------------
        TERMINAL STATUS MUST BE CLOSED
    --------------------------------------------------------------------------*/

    SET @INVRE_TI_invalid_id = NULL;
    SET @INVRE_TI_invalid_status = NULL;


    SELECT TOP (1)
        @INVRE_TI_invalid_id =
            R.INVRE_id,

        @INVRE_TI_invalid_status =
            S.INVRS_name

    FROM inventory.InventoryReservation AS R

    INNER JOIN inventory.InventoryReservationStatus AS S
        ON S.INVRS_id =
            R.INVRE_INVRS_id

    WHERE S.INVRS_name IN
    (
        N'CONSUMED',
        N'RELEASED',
        N'EXPIRED'
    )
    AND R.INVRE_closed_at IS NULL

    ORDER BY
        R.INVRE_id;


    IF @INVRE_TI_invalid_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing closed reservation timestamp violation detected';
        PRINT N'            InventoryReservation             : '
            + CONVERT(nvarchar(20), @INVRE_TI_invalid_id);
        PRINT N'            Status                           : '
            + COALESCE(@INVRE_TI_invalid_status, N'<NULL>');
        PRINT N'            Rule                             : Terminal reservation status requires INVRE_closed_at.';
        PRINT N'            Trigger was not created. Existing data must be corrected first.';


        ;THROW 51048,
            N'Reservation temporal integrity cannot be deployed because a terminal reservation does not have a closing timestamp.',
            1;

    END;


    /*--------------------------------------------------------------------------
        EXPIRED CANNOT CLOSE BEFORE EXPIRATION
    --------------------------------------------------------------------------*/

    SET @INVRE_TI_invalid_id = NULL;
    SET @INVRE_TI_invalid_expires_at = NULL;
    SET @INVRE_TI_invalid_closed_at = NULL;


    SELECT TOP (1)
        @INVRE_TI_invalid_id =
            R.INVRE_id,

        @INVRE_TI_invalid_expires_at =
            R.INVRE_expires_at,

        @INVRE_TI_invalid_closed_at =
            R.INVRE_closed_at

    FROM inventory.InventoryReservation AS R

    INNER JOIN inventory.InventoryReservationStatus AS S
        ON S.INVRS_id =
            R.INVRE_INVRS_id

    WHERE S.INVRS_name = N'EXPIRED'
    AND R.INVRE_closed_at < R.INVRE_expires_at

    ORDER BY
        R.INVRE_id;


    IF @INVRE_TI_invalid_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing reservation expiration violation detected';
        PRINT N'            InventoryReservation             : '
            + CONVERT(nvarchar(20), @INVRE_TI_invalid_id);
        PRINT N'            Expires At                       : '
            + CONVERT(nvarchar(19), @INVRE_TI_invalid_expires_at, 120);
        PRINT N'            Closed At                        : '
            + CONVERT(nvarchar(19), @INVRE_TI_invalid_closed_at, 120);
        PRINT N'            Rule                             : EXPIRED reservation cannot close before INVRE_expires_at.';
        PRINT N'            Trigger was not created. Existing data must be corrected first.';


        ;THROW 51049,
            N'Reservation temporal integrity cannot be deployed because an EXPIRED reservation was closed before its expiration timestamp.',
            1;

    END;


    /*--------------------------------------------------------------------------
        PRODUCT VARIANT MUST MATCH TRANSACTION ITEM
    --------------------------------------------------------------------------*/

    SET @INVRE_TI_invalid_id = NULL;
    SET @INVRE_TI_invalid_TRNIT_id = NULL;
    SET @INVRE_TI_expected_PRDVA_id = NULL;
    SET @INVRE_TI_actual_PRDVA_id = NULL;


    SELECT TOP (1)
        @INVRE_TI_invalid_id =
            R.INVRE_id,

        @INVRE_TI_invalid_TRNIT_id =
            R.INVRE_TRNIT_id,

        @INVRE_TI_expected_PRDVA_id =
            TI.TRNIT_PRDVA_id,

        @INVRE_TI_actual_PRDVA_id =
            R.INVRE_PRDVA_id

    FROM inventory.InventoryReservation AS R

    INNER JOIN sales.TransactionItem AS TI
        ON TI.TRNIT_id =
            R.INVRE_TRNIT_id

    AND TI.TRNIT_transaction_at =
            R.INVRE_TRNIT_transaction_at

    WHERE TI.TRNIT_PRDVA_id <>
            R.INVRE_PRDVA_id

    ORDER BY
        R.INVRE_id;


    IF @INVRE_TI_invalid_id IS NOT NULL
    BEGIN

        PRINT N'        [X] Existing reservation ProductVariant violation detected';
        PRINT N'            InventoryReservation             : '
            + CONVERT(nvarchar(20), @INVRE_TI_invalid_id);
        PRINT N'            TransactionItem                  : '
            + CONVERT(nvarchar(20), @INVRE_TI_invalid_TRNIT_id);
        PRINT N'            Expected ProductVariant          : '
            + CONVERT(nvarchar(20), @INVRE_TI_expected_PRDVA_id);
        PRINT N'            Actual ProductVariant            : '
            + CONVERT(nvarchar(20), @INVRE_TI_actual_PRDVA_id);
        PRINT N'            Rule                             : Reservation ProductVariant must match TransactionItem ProductVariant.';
        PRINT N'            Trigger was not created. Existing data must be corrected first.';


        ;THROW 51050,
            N'Reservation temporal integrity cannot be deployed because an existing reservation references a different ProductVariant than its TransactionItem.',
            1;

    END;


    PRINT N'        [✓] Existing reservation lifecycle data validated';
    PRINT N'        [✓] Existing reservation ProductVariant consistency validated';


    /*==============================================================================
        EXPECTED TRIGGER DEFINITION
    ==============================================================================*/

    SET @INVRE_TI_expected_definition =
    N'CREATE TRIGGER inventory.TR_INVRE_reservation_temporal_integrity
    ON inventory.InventoryReservation
    AFTER INSERT, UPDATE
    AS
    BEGIN

        SET NOCOUNT ON;

        /*
            ATLAS INVENTORY RESERVATION TEMPORAL INTEGRITY

            Rules:
            1. ACTIVE requires closed_at IS NULL.
            2. CONSUMED, RELEASED and EXPIRED require closed_at IS NOT NULL.
            3. EXPIRED requires closed_at >= expires_at.
            4. Only recognized reservation lifecycle statuses are allowed.
            5. Reservation ProductVariant must match TransactionItem ProductVariant.

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
            VALIDATE RECOGNIZED STATUS
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN inventory.InventoryReservationStatus AS S
                ON S.INVRS_id =
                    I.INVRE_INVRS_id

            WHERE S.INVRS_name NOT IN
            (
                N''ACTIVE'',
                N''CONSUMED'',
                N''RELEASED'',
                N''EXPIRED''
            )
        )
        BEGIN

            ;THROW 51051,
                N''InventoryReservation temporal integrity violation. Unsupported reservation lifecycle status.'',
                1;

        END;


        /*--------------------------------------------------------------------------
            ACTIVE RESERVATION MUST REMAIN OPEN
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN inventory.InventoryReservationStatus AS S
                ON S.INVRS_id =
                    I.INVRE_INVRS_id

            WHERE S.INVRS_name = N''ACTIVE''
            AND I.INVRE_closed_at IS NOT NULL
        )
        BEGIN

            ;THROW 51052,
                N''InventoryReservation temporal integrity violation. ACTIVE reservation must have INVRE_closed_at = NULL.'',
                1;

        END;


        /*--------------------------------------------------------------------------
            TERMINAL RESERVATION MUST BE CLOSED
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN inventory.InventoryReservationStatus AS S
                ON S.INVRS_id =
                    I.INVRE_INVRS_id

            WHERE S.INVRS_name IN
            (
                N''CONSUMED'',
                N''RELEASED'',
                N''EXPIRED''
            )
            AND I.INVRE_closed_at IS NULL
        )
        BEGIN

            ;THROW 51053,
                N''InventoryReservation temporal integrity violation. Terminal reservation status requires INVRE_closed_at.'',
                1;

        END;


        /*--------------------------------------------------------------------------
            EXPIRED RESERVATION CANNOT CLOSE BEFORE ITS EXPIRATION
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN inventory.InventoryReservationStatus AS S
                ON S.INVRS_id =
                    I.INVRE_INVRS_id

            WHERE S.INVRS_name = N''EXPIRED''
            AND I.INVRE_closed_at < I.INVRE_expires_at
        )
        BEGIN

            ;THROW 51054,
                N''InventoryReservation temporal integrity violation. EXPIRED reservation cannot close before INVRE_expires_at.'',
                1;

        END;


        /*--------------------------------------------------------------------------
            PRODUCT VARIANT MUST MATCH TRANSACTION ITEM
        --------------------------------------------------------------------------*/

        IF EXISTS
        (
            SELECT 1

            FROM inserted AS I

            INNER JOIN sales.TransactionItem AS TI
                ON TI.TRNIT_id =
                    I.INVRE_TRNIT_id

            AND TI.TRNIT_transaction_at =
                    I.INVRE_TRNIT_transaction_at

            WHERE TI.TRNIT_PRDVA_id <>
                    I.INVRE_PRDVA_id
        )
        BEGIN

            ;THROW 51055,
                N''InventoryReservation integrity violation. Reserved ProductVariant must match the ProductVariant of the referenced TransactionItem.'',
                1;

        END;

    END;';


    /*==============================================================================
        LOOK FOR EXPECTED TRIGGER
    ==============================================================================*/

    SELECT
        @INVRE_TI_actual_name =
            tr.name,

        @INVRE_TI_actual_parent =
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

        @INVRE_TI_actual_is_disabled =
            tr.is_disabled,

        @INVRE_TI_actual_is_instead_of =
            tr.is_instead_of_trigger,

        @INVRE_TI_actual_definition =
            OBJECT_DEFINITION
            (
                tr.object_id
            )

    FROM sys.triggers AS tr

    WHERE tr.parent_id =
            OBJECT_ID(N'inventory.InventoryReservation')

    AND tr.name =
            @INVRE_TI_expected_name;


    /*==============================================================================
        EXPECTED TRIGGER EXISTS
    ==============================================================================*/

    IF @INVRE_TI_actual_name IS NOT NULL
    BEGIN

        SET @INVRE_TI_expected_normalized =
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
                                @INVRE_TI_expected_definition,
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


        SET @INVRE_TI_actual_normalized =
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
                                @INVRE_TI_actual_definition,
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


        IF @INVRE_TI_actual_parent =
                N'[inventory].[InventoryReservation]'

        AND @INVRE_TI_actual_is_disabled = 0

        AND @INVRE_TI_actual_is_instead_of = 0

        AND @INVRE_TI_actual_normalized =
                @INVRE_TI_expected_normalized
        BEGIN

            PRINT N'        [•] Reservation temporal integrity validated : TR_INVRE_reservation_temporal_integrity';
            PRINT N'            Events                          : INSERT, UPDATE';
            PRINT N'            Rule 1                          : ACTIVE -> closed_at IS NULL';
            PRINT N'            Rule 2                          : Terminal -> closed_at IS NOT NULL';
            PRINT N'            Rule 3                          : EXPIRED -> closed_at >= expires_at';
            PRINT N'            Rule 4                          : Supported lifecycle statuses only';
            PRINT N'            Rule 5                          : Reservation ProductVariant = TransactionItem ProductVariant';
            PRINT N'            Status Resolution               : InventoryReservationStatus.INVRS_name';
            PRINT N'            Enabled                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Reservation temporal integrity mismatch : TR_INVRE_reservation_temporal_integrity';

            PRINT N'            Expected Parent                 : inventory.InventoryReservation';

            PRINT N'            Actual Parent                   : '
                + COALESCE
                (
                    @INVRE_TI_actual_parent,
                    N'<NULL>'
                );

            PRINT N'            Expected Trigger Type           : AFTER';

            PRINT N'            Actual Instead Of               : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVRE_TI_actual_is_instead_of
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
                        @INVRE_TI_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing trigger was preserved for review.';


            ;THROW 51056,
                N'Trigger TR_INVRE_reservation_temporal_integrity exists but does not match the expected temporal integrity definition.',
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
            N'inventory.TR_INVRE_reservation_temporal_integrity',
            N'TR'
        ) IS NOT NULL
        BEGIN

            SELECT
                @INVRE_TI_conflict_parent =
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
                        N'inventory.TR_INVRE_reservation_temporal_integrity',
                        N'TR'
                    );


            PRINT N'        [!] Reservation temporal integrity name conflict : TR_INVRE_reservation_temporal_integrity';

            PRINT N'            Expected Parent                 : inventory.InventoryReservation';

            PRINT N'            Existing Parent                 : '
                + COALESCE
                (
                    @INVRE_TI_conflict_parent,
                    N'<UNKNOWN>'
                );

            PRINT N'            Trigger was not created. Manual review is required.';


            ;THROW 51057,
                N'Reservation temporal integrity trigger name conflict prevents safe deployment.',
                1;

        END;


        /*==========================================================================
            CREATE RESERVATION TEMPORAL INTEGRITY TRIGGER
        ==========================================================================*/

        EXEC sys.sp_executesql
            @INVRE_TI_expected_definition;


        PRINT N'        [+] Reservation temporal integrity added : TR_INVRE_reservation_temporal_integrity';
        PRINT N'            Events                          : INSERT, UPDATE';
        PRINT N'            Rule 1                          : ACTIVE -> closed_at IS NULL';
        PRINT N'            Rule 2                          : Terminal -> closed_at IS NOT NULL';
        PRINT N'            Rule 3                          : EXPIRED -> closed_at >= expires_at';
        PRINT N'            Rule 4                          : Supported lifecycle statuses only';
        PRINT N'            Rule 5                          : Reservation ProductVariant = TransactionItem ProductVariant';
        PRINT N'            Status Resolution               : InventoryReservationStatus.INVRS_name';
        PRINT N'            Enabled                         : YES';

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';