/*==============================================================================
    ATLAS COMMERCE - DATA DEPLOYMENT
==============================================================================

    Object      : sales.TransactionItem
    Type        : Sales / Sample Data
    Prefix      : TRNIT
    Database    : AtlasCommerce

    Purpose
    --------------------------------------------------------------------------
    Populates the product items associated with the AtlasCommerce sample
    transactions.

    Deployment Behavior
    --------------------------------------------------------------------------
    - Generates TransactionItems from the existing sample Transactions.
    - Preserves the parent transaction timestamp for partition alignment.
    - Generates a deterministic, non-uniform number of distinct products per
      Transaction.
    - Most Transactions contain between 1 and 3 products.
    - Some Transactions contain between 4 and 6 products.
    - A small number of higher-value Transactions contain between 12 and 15
      products.
    - ProductVariant dependencies are resolved from active catalog variants.
    - The same ProductVariant is not repeated within the same generated
      Transaction.
    - Item gross values reconcile exactly to TRN_gross_amount.
    - Item discount values reconcile exactly to TRN_discount_amount.
    - Unit price and unit discount are preserved as transaction-level snapshots.
    - Inserts only generated TransactionItems that do not already exist.
    - Existing TransactionItems are preserved without modification.
    - No automatic UPDATE is performed.
    - Source data is validated before deployment.
    - Data is deployed using a generated set-based operation.
    - The script is safe to rerun without duplicating expected rows.

==============================================================================*/

SET NOCOUNT ON;
SET XACT_ABORT ON;

PRINT N'';
PRINT N'    ● sales.TransactionItem';
PRINT N'';


/*==============================================================================
    DATA
==============================================================================*/

DECLARE @TRNIT_rows_added     int;
DECLARE @TRNIT_rows_processed int;
DECLARE @TRNIT_variant_count  int;


/*==============================================================================
    PRODUCT VARIANT SOURCE
==============================================================================*/

DECLARE @TRNIT_variants TABLE
(
    VariantNumber  int NOT NULL PRIMARY KEY,
    PRDVA_id       int NOT NULL UNIQUE,
    PRDVA_sku      nvarchar(100) NOT NULL
);


INSERT INTO @TRNIT_variants
(
    VariantNumber,
    PRDVA_id,
    PRDVA_sku
)
SELECT
    ROW_NUMBER() OVER
    (
        ORDER BY
            V.PRDVA_sku,
            V.PRDVA_id
    ),
    V.PRDVA_id,
    V.PRDVA_sku
FROM catalog.ProductVariant AS V
WHERE V.PRDVA_is_active = 1;


SELECT
    @TRNIT_variant_count = COUNT(*)
FROM @TRNIT_variants;


IF @TRNIT_variant_count < 15
BEGIN

    ;THROW 50600,
        N'sales.TransactionItem data deployment requires at least 15 active ProductVariant records.',
        1;

END;


/*==============================================================================
    GENERATION SUPPORT
==============================================================================*/

DECLARE @TRNIT_slots TABLE
(
    SlotNumber tinyint NOT NULL PRIMARY KEY
);


INSERT INTO @TRNIT_slots
(
    SlotNumber
)
VALUES
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9),
    (10),
    (11),
    (12),
    (13),
    (14),
    (15);


/*==============================================================================
    SOURCE DATA
==============================================================================*/

DECLARE @TRNIT_source TABLE
(
    TRNIT_transaction_at  datetime2(0)    NOT NULL,
    TRNIT_TRN_id          bigint          NOT NULL,
    TRNIT_PRDVA_id        int             NOT NULL,
    TRNIT_quantity        int             NOT NULL,
    TRNIT_unit_price      decimal(19,2)   NOT NULL,
    TRNIT_unit_discount   decimal(19,2)   NOT NULL,
    TRNIT_created_at      datetime2(0)    NOT NULL,
    TRNIT_updated_at      datetime2(0)    NOT NULL
);


;WITH TransactionSource AS
(
    SELECT
        T.TRN_id,
        T.TRN_transaction_at,
        T.TRN_gross_amount,
        T.TRN_discount_amount,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    T.TRN_id,
                    T.TRN_transaction_at,
                    101
                )
            )
        ) % 100 AS BasketBucket,

        ABS
        (
            CONVERT
            (
                bigint,
                CHECKSUM
                (
                    T.TRN_id,
                    T.TRN_transaction_at,
                    211
                )
            )
        ) AS BasketSeed

    FROM sales.[Transaction] AS T
),
BasketSource AS
(
    SELECT
        T.TRN_id,
        T.TRN_transaction_at,
        T.TRN_gross_amount,
        T.TRN_discount_amount,

        CASE
            WHEN T.TRN_gross_amount >= 350.00
             AND T.BasketBucket < 4
                THEN 12 + CONVERT(int, T.BasketSeed % 4)

            WHEN T.TRN_gross_amount >= 200.00
             AND T.BasketBucket < 16
                THEN 4 + CONVERT(int, T.BasketSeed % 3)

            WHEN T.BasketBucket < 55
                THEN 1

            WHEN T.BasketBucket < 82
                THEN 2

            ELSE 3
        END AS ItemCount

    FROM TransactionSource AS T
),
ExpandedSource AS
(
    SELECT
        B.TRN_id,
        B.TRN_transaction_at,
        B.TRN_gross_amount,
        B.TRN_discount_amount,
        B.ItemCount,
        CONVERT(int, S.SlotNumber) AS SlotNumber,

        1
            + (
                (
                    CONVERT(bigint, B.TRN_id) * 5
                    + CONVERT(bigint, S.SlotNumber - 1) * 7
                ) % @TRNIT_variant_count
            ) AS VariantNumber,

        CONVERT
        (
            bigint,
            ROUND(B.TRN_gross_amount * 100.00, 0)
        ) AS GrossCents,

        CONVERT
        (
            bigint,
            ROUND(B.TRN_discount_amount * 100.00, 0)
        ) AS DiscountCents

    FROM BasketSource AS B

    INNER JOIN @TRNIT_slots AS S
        ON S.SlotNumber <= B.ItemCount
),
AllocatedSource AS
(
    SELECT
        E.TRN_id,
        E.TRN_transaction_at,
        E.ItemCount,
        E.SlotNumber,
        E.VariantNumber,

        (
            E.GrossCents / E.ItemCount
        )
        +
        CASE
            WHEN E.SlotNumber <=
                    (E.GrossCents % E.ItemCount)
                THEN 1
            ELSE 0
        END AS ItemGrossCents,

        (
            E.DiscountCents / E.ItemCount
        )
        +
        CASE
            WHEN E.SlotNumber <=
                    (E.DiscountCents % E.ItemCount)
                THEN 1
            ELSE 0
        END AS ItemDiscountCents

    FROM ExpandedSource AS E
)
INSERT INTO @TRNIT_source
(
    TRNIT_transaction_at,
    TRNIT_TRN_id,
    TRNIT_PRDVA_id,
    TRNIT_quantity,
    TRNIT_unit_price,
    TRNIT_unit_discount,
    TRNIT_created_at,
    TRNIT_updated_at
)
SELECT
    A.TRN_transaction_at,
    A.TRN_id,
    V.PRDVA_id,
    1,
    CONVERT(decimal(19,2), A.ItemGrossCents / 100.00),
    CONVERT(decimal(19,2), A.ItemDiscountCents / 100.00),
    A.TRN_transaction_at,
    A.TRN_transaction_at
FROM AllocatedSource AS A

INNER JOIN @TRNIT_variants AS V
    ON V.VariantNumber = A.VariantNumber;


/*==============================================================================
    SOURCE VALIDATION
==============================================================================*/

SELECT
    @TRNIT_rows_processed = COUNT(*)
FROM @TRNIT_source;


IF @TRNIT_rows_processed = 0
BEGIN

    ;THROW 50601,
        N'sales.TransactionItem source data did not generate any rows.',
        1;

END;


IF EXISTS
(
    SELECT
        S.TRNIT_TRN_id,
        S.TRNIT_transaction_at,
        S.TRNIT_PRDVA_id
    FROM @TRNIT_source AS S
    GROUP BY
        S.TRNIT_TRN_id,
        S.TRNIT_transaction_at,
        S.TRNIT_PRDVA_id
    HAVING COUNT(*) > 1
)
BEGIN

    ;THROW 50602,
        N'sales.TransactionItem source data contains duplicate ProductVariant rows within the same Transaction.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @TRNIT_source AS S
    WHERE S.TRNIT_quantity <= 0
)
BEGIN

    ;THROW 50603,
        N'sales.TransactionItem source data contains an invalid quantity.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM @TRNIT_source AS S
    WHERE S.TRNIT_unit_price < 0.00
       OR S.TRNIT_unit_discount < 0.00
       OR S.TRNIT_unit_discount > S.TRNIT_unit_price
)
BEGIN

    ;THROW 50604,
        N'sales.TransactionItem source data contains an invalid unit price or unit discount.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM sales.[Transaction] AS T

    LEFT JOIN
    (
        SELECT
            S.TRNIT_TRN_id,
            S.TRNIT_transaction_at,

            SUM
            (
                CONVERT
                (
                    decimal(19,2),
                    S.TRNIT_quantity * S.TRNIT_unit_price
                )
            ) AS ItemGrossAmount,

            SUM
            (
                CONVERT
                (
                    decimal(19,2),
                    S.TRNIT_quantity * S.TRNIT_unit_discount
                )
            ) AS ItemDiscountAmount

        FROM @TRNIT_source AS S

        GROUP BY
            S.TRNIT_TRN_id,
            S.TRNIT_transaction_at
    ) AS I
        ON  I.TRNIT_TRN_id = T.TRN_id
        AND I.TRNIT_transaction_at = T.TRN_transaction_at

    WHERE I.TRNIT_TRN_id IS NULL
       OR I.ItemGrossAmount <> T.TRN_gross_amount
       OR I.ItemDiscountAmount <> T.TRN_discount_amount
)
BEGIN

    ;THROW 50605,
        N'sales.TransactionItem source data does not reconcile with Transaction gross and discount amounts.',
        1;

END;


IF EXISTS
(
    SELECT 1
    FROM
    (
        SELECT
            S.TRNIT_TRN_id,
            COUNT(*) AS ItemCount
        FROM @TRNIT_source AS S
        GROUP BY
            S.TRNIT_TRN_id
    ) AS X
    WHERE X.ItemCount < 1
       OR X.ItemCount > 15
)
BEGIN

    ;THROW 50606,
        N'sales.TransactionItem source data contains an invalid product count for a Transaction.',
        1;

END;


/*==============================================================================
    DATA DEPLOYMENT
==============================================================================*/

INSERT INTO sales.TransactionItem
(
    TRNIT_transaction_at,
    TRNIT_TRN_id,
    TRNIT_PRDVA_id,
    TRNIT_quantity,
    TRNIT_unit_price,
    TRNIT_unit_discount,
    TRNIT_created_at,
    TRNIT_updated_at
)
SELECT
    S.TRNIT_transaction_at,
    S.TRNIT_TRN_id,
    S.TRNIT_PRDVA_id,
    S.TRNIT_quantity,
    S.TRNIT_unit_price,
    S.TRNIT_unit_discount,
    S.TRNIT_created_at,
    S.TRNIT_updated_at
FROM @TRNIT_source AS S

WHERE NOT EXISTS
(
    SELECT 1
    FROM sales.TransactionItem AS I
    WHERE I.TRNIT_TRN_id = S.TRNIT_TRN_id
      AND I.TRNIT_transaction_at = S.TRNIT_transaction_at
      AND I.TRNIT_PRDVA_id = S.TRNIT_PRDVA_id
);


SET @TRNIT_rows_added = @@ROWCOUNT;


/*==============================================================================
    RESULT
==============================================================================*/

PRINT N'        [+] Rows added                       : '
    + CONVERT(nvarchar(20), @TRNIT_rows_added);

PRINT N'        [•] Rows already existing            : '
    + CONVERT(nvarchar(20), @TRNIT_rows_processed - @TRNIT_rows_added);

PRINT N'        [•] Rows processed                   : '
    + CONVERT(nvarchar(20), @TRNIT_rows_processed);


PRINT N'';
PRINT N'    --------------------------------------------------------------------------';
PRINT N'';