/*==============================================================================
    Script Name : 04-Deploy-AtlasCommerce-Data.sql
    Version     : 1.0.0
    Target      : AtlasCommerce
    Purpose     : Deploy the AtlasCommerce operational and sample data
    Rerunnable  : Yes
==============================================================================*/

:setvar DataRoot "C:\Projects\Atlas Engineering\01-Enterprise-Data-Platform\04-Scripts\02-Database\02-Data-Deployment"

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @ScriptVersion nvarchar(20) = N'1.0.0';
DECLARE @ScriptName    sysname      = N'04-Deploy-AtlasCommerce-Data.sql';
DECLARE @DatabaseName  sysname      = N'AtlasCommerce';
DECLARE @StartTime     datetime2(3) = SYSDATETIME();

DECLARE @GroupStartTime datetime2(3);
DECLARE @GroupEndTime   datetime2(3);
DECLARE @GroupElapsedMs bigint;

PRINT N'';
PRINT N'==============================================================================';
PRINT N' ATLAS COMMERCE - DATA DEPLOYMENT';
PRINT N'==============================================================================';
PRINT N' Script   : ' + @ScriptName;
PRINT N' Version  : ' + @ScriptVersion;
PRINT N' Database : ' + @DatabaseName;
PRINT N' Started  : ' + CONVERT(nvarchar(19), @StartTime, 120);
PRINT N'==============================================================================';
PRINT N'';

IF DB_NAME() <> @DatabaseName
BEGIN
    ;THROW 50001, N'Incorrect database context. Expected database: AtlasCommerce.', 1;
END;

BEGIN TRY

    BEGIN TRANSACTION;

    /*==========================================================================
        DATA
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' DATA';
    PRINT N'';

    /*--------------------------------------------------------------------------
        Data execution order follows foreign-key dependencies.
        It is intentionally not alphabetical.
    --------------------------------------------------------------------------*/

    :r $(DataRoot)\01-Data\reference.Country.Data.sql
    :r $(DataRoot)\01-Data\reference.AdministrativeDivision.Data.sql
    :r $(DataRoot)\01-Data\reference.City.Data.sql
    :r $(DataRoot)\01-Data\reference.ContactType.Data.sql
    :r $(DataRoot)\01-Data\reference.Address.Data.sql

    :r $(DataRoot)\01-Data\catalog.Brand.Data.sql
    :r $(DataRoot)\01-Data\catalog.Category.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductAttribute.Data.sql
    :r $(DataRoot)\01-Data\catalog.Product.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductAttributeValue.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductCategory.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductImage.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductVariant.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductVariantAttributeValue.Data.sql
    :r $(DataRoot)\01-Data\catalog.ProductVariantPrice.Data.sql

    :r $(DataRoot)\01-Data\customer.Customer.Data.sql
    :r $(DataRoot)\01-Data\customer.CustomerDocument.Data.sql
    :r $(DataRoot)\01-Data\customer.CustomerEmail.Data.sql
    :r $(DataRoot)\01-Data\customer.CustomerContact.Data.sql
    :r $(DataRoot)\01-Data\customer.CustomerAddress.Data.sql

    :r $(DataRoot)\01-Data\sales.Transaction.Data.sql
    :r $(DataRoot)\01-Data\sales.TransactionItem.Data.sql

    :r $(DataRoot)\01-Data\inventory.Inventory.Data.sql
    :r $(DataRoot)\01-Data\inventory.InventoryReservation.Data.sql
    :r $(DataRoot)\01-Data\inventory.InventoryMovement.Data.sql
    :r $(DataRoot)\01-Data\inventory.InventoryMovementNote.Data.sql

    :r $(DataRoot)\01-Data\payment.Payment.Data.sql
    :r $(DataRoot)\01-Data\payment.PaymentRefund.Data.sql

    :r $(DataRoot)\01-Data\shipping.Shipment.Data.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● DATA TIME';
    PRINT N'';
    PRINT N'        Elapsed                         : '
        + CONVERT(nvarchar(20), @GroupElapsedMs)
        + N' ms ('
        + CONVERT
        (
            nvarchar(30),
            CONVERT(decimal(18,3), @GroupElapsedMs / 1000.0)
        )
        + N' s)';
    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    COMMIT TRANSACTION;

    /*==========================================================================
        DEPLOYMENT TIMING
    ==========================================================================*/

    DECLARE @EndTime datetime2(3) = SYSDATETIME();

    DECLARE @ElapsedMs bigint =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @StartTime,
            @EndTime
        );

    PRINT N'';
    PRINT N'==============================================================================';
    PRINT N' DEPLOYMENT TIMING';
    PRINT N'==============================================================================';
    PRINT N'';
    PRINT N'    ● TOTAL DEPLOYMENT TIME';
    PRINT N'';
    PRINT N'        Elapsed                         : '
        + CONVERT(nvarchar(20), @ElapsedMs)
        + N' ms ('
        + CONVERT
        (
            nvarchar(30),
            CONVERT(decimal(18,3), @ElapsedMs / 1000.0)
        )
        + N' s)';
    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';

    PRINT N'==============================================================================';
    PRINT N' AtlasCommerce data deployment completed successfully.';
    PRINT N'==============================================================================';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'';
    PRINT N'==============================================================================';
    PRINT N' AtlasCommerce data deployment FAILED.';
    PRINT N'==============================================================================';
    PRINT N' Error Number    : ' + CONVERT(nvarchar(20), ERROR_NUMBER());
    PRINT N' Error Severity  : ' + CONVERT(nvarchar(20), ERROR_SEVERITY());
    PRINT N' Error State     : ' + CONVERT(nvarchar(20), ERROR_STATE());
    PRINT N' Error Line      : ' + CONVERT(nvarchar(20), ERROR_LINE());
    PRINT N' Error Procedure : ' + COALESCE(ERROR_PROCEDURE(), N'N/A');
    PRINT N' Error Message   : ' + ERROR_MESSAGE();
    PRINT N'==============================================================================';

    THROW;

END CATCH;