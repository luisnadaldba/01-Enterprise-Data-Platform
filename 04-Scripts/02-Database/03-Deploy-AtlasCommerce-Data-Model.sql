/*==============================================================================
    Script Name : 03-Deploy-AtlasCommerce-Data-Model.sql
    Version     : 1.0.0
    Target      : AtlasCommerce
    Purpose     : Deploy and validate the AtlasCommerce relational data model
    Rerunnable  : Yes
==============================================================================*/

:setvar DataModelRoot "C:\Projects\Atlas Engineering\01-Enterprise-Data-Platform\04-Scripts\02-Database\01-Data-Model-Deployment"

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @ScriptVersion nvarchar(20) = N'1.0.0';
DECLARE @ScriptName    sysname      = N'03-Deploy-AtlasCommerce-Data-Model.sql';
DECLARE @DatabaseName  sysname      = N'AtlasCommerce';
DECLARE @StartTime     datetime2(3) = SYSDATETIME();

DECLARE @GroupStartTime datetime2(3);
DECLARE @GroupEndTime   datetime2(3);
DECLARE @GroupElapsedMs bigint;

PRINT N'';
PRINT N'==============================================================================';
PRINT N' ATLAS COMMERCE - DATA MODEL DEPLOYMENT';
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

    /*==============================================================================
        PARTITIONING
    ==============================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' PARTITIONING';
    PRINT N'';

    :r $(DataModelRoot)\00-Partitioning\01-Filegroups\00-Sales-Partitioning-Config.sql
    :r $(DataModelRoot)\00-Partitioning\01-Filegroups\01-Sales-Filegroups.sql

    :r $(DataModelRoot)\00-Partitioning\02-Partition-Functions\01-Sales-Partition-Function.sql

    :r $(DataModelRoot)\00-Partitioning\03-Partition-Schemes\01-Sales-Partition-Scheme.sql

    :r $(DataModelRoot)\00-Partitioning\04-Partition-Validation\01-Sales-Partition-Validation.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● PARTITIONING TIME';
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

    /*==========================================================================
        TRANSACTIONAL DATA MODEL DEPLOYMENT
    ==========================================================================*/

    BEGIN TRANSACTION;

    /*==========================================================================
        TABLES
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' TABLES';
    PRINT N'';

    :r $(DataModelRoot)\01-Tables\metadata.TablePrefix.sql

    :r $(DataModelRoot)\01-Tables\catalog.Brand.sql
    :r $(DataModelRoot)\01-Tables\catalog.Category.sql
    :r $(DataModelRoot)\01-Tables\catalog.Product.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductAttribute.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductAttributeValue.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductCategory.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductImage.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductVariant.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductVariantAttributeValue.sql
    :r $(DataModelRoot)\01-Tables\catalog.ProductVariantPrice.sql

    :r $(DataModelRoot)\01-Tables\customer.Customer.sql
    :r $(DataModelRoot)\01-Tables\customer.CustomerAddress.sql
    :r $(DataModelRoot)\01-Tables\customer.CustomerContact.sql
    :r $(DataModelRoot)\01-Tables\customer.CustomerDocument.sql
    :r $(DataModelRoot)\01-Tables\customer.CustomerDocumentType.sql
    :r $(DataModelRoot)\01-Tables\customer.CustomerEmail.sql
    :r $(DataModelRoot)\01-Tables\customer.CustomerType.sql

    :r $(DataModelRoot)\01-Tables\inventory.Inventory.sql
    :r $(DataModelRoot)\01-Tables\inventory.InventoryMovement.sql
    :r $(DataModelRoot)\01-Tables\inventory.InventoryMovementNote.sql
    :r $(DataModelRoot)\01-Tables\inventory.InventoryMovementReason.sql
    :r $(DataModelRoot)\01-Tables\inventory.InventoryReservation.sql
    :r $(DataModelRoot)\01-Tables\inventory.InventoryReservationStatus.sql

    :r $(DataModelRoot)\01-Tables\payment.Payment.sql
    :r $(DataModelRoot)\01-Tables\payment.PaymentMethod.sql
    :r $(DataModelRoot)\01-Tables\payment.PaymentRefund.sql
    :r $(DataModelRoot)\01-Tables\payment.PaymentRefundReason.sql
    :r $(DataModelRoot)\01-Tables\payment.PaymentStatus.sql

    :r $(DataModelRoot)\01-Tables\reference.Address.sql
    :r $(DataModelRoot)\01-Tables\reference.AdministrativeDivision.sql
    :r $(DataModelRoot)\01-Tables\reference.City.sql
    :r $(DataModelRoot)\01-Tables\reference.ContactType.sql
    :r $(DataModelRoot)\01-Tables\reference.Country.sql

    :r $(DataModelRoot)\01-Tables\sales.Transaction.sql
    :r $(DataModelRoot)\01-Tables\sales.TransactionChannel.sql
    :r $(DataModelRoot)\01-Tables\sales.TransactionItem.sql
    :r $(DataModelRoot)\01-Tables\sales.TransactionStatus.sql

    :r $(DataModelRoot)\01-Tables\shipping.Shipment.sql
    :r $(DataModelRoot)\01-Tables\shipping.ShipmentMethod.sql
    :r $(DataModelRoot)\01-Tables\shipping.ShipmentStatus.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● TABLES TIME';
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

    /*==========================================================================
        OBJECT DOCUMENTATION
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' OBJECT DOCUMENTATION';
    PRINT N'';

    :r $(DataModelRoot)\02-Object-Documentation\metadata.TablePrefix.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\catalog.Brand.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.Category.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.Product.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductAttribute.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductAttributeValue.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductCategory.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductImage.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductVariant.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductVariantAttributeValue.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\catalog.ProductVariantPrice.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\customer.Customer.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\customer.CustomerAddress.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\customer.CustomerContact.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\customer.CustomerDocument.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\customer.CustomerDocumentType.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\customer.CustomerEmail.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\customer.CustomerType.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\inventory.Inventory.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\inventory.InventoryMovement.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\inventory.InventoryMovementNote.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\inventory.InventoryMovementReason.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\inventory.InventoryReservation.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\inventory.InventoryReservationStatus.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\payment.Payment.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\payment.PaymentMethod.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\payment.PaymentRefund.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\payment.PaymentRefundReason.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\payment.PaymentStatus.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\reference.Address.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\reference.AdministrativeDivision.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\reference.City.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\reference.ContactType.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\reference.Country.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\sales.Transaction.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\sales.TransactionChannel.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\sales.TransactionItem.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\sales.TransactionStatus.Documentation.sql

    :r $(DataModelRoot)\02-Object-Documentation\shipping.Shipment.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\shipping.ShipmentMethod.Documentation.sql
    :r $(DataModelRoot)\02-Object-Documentation\shipping.ShipmentStatus.Documentation.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● OBJECT DOCUMENTATION TIME';
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

    /*==========================================================================
        SEED DATA
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' SEED DATA';
    PRINT N'';

    :r $(DataModelRoot)\03-Seed-Data\metadata.TablePrefix.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\catalog.Brand.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.Category.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.Product.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductAttribute.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductAttributeValue.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductCategory.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductImage.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductVariant.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductVariantAttributeValue.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\catalog.ProductVariantPrice.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\customer.Customer.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\customer.CustomerAddress.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\customer.CustomerContact.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\customer.CustomerDocument.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\customer.CustomerDocumentType.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\customer.CustomerEmail.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\customer.CustomerType.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\inventory.Inventory.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\inventory.InventoryMovement.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\inventory.InventoryMovementNote.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\inventory.InventoryMovementReason.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\inventory.InventoryReservation.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\inventory.InventoryReservationStatus.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\payment.Payment.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\payment.PaymentMethod.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\payment.PaymentRefund.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\payment.PaymentRefundReason.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\payment.PaymentStatus.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\reference.Address.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\reference.AdministrativeDivision.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\reference.City.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\reference.ContactType.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\reference.Country.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\sales.Transaction.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\sales.TransactionChannel.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\sales.TransactionItem.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\sales.TransactionStatus.Seed.sql

    :r $(DataModelRoot)\03-Seed-Data\shipping.Shipment.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\shipping.ShipmentMethod.Seed.sql
    :r $(DataModelRoot)\03-Seed-Data\shipping.ShipmentStatus.Seed.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● SEED DATA TIME';
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

    /*==========================================================================
        DEFAULT CONSTRAINTS
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' DEFAULT CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\04-Default-Constraints\metadata.TablePrefix.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\catalog.Brand.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.Category.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.Product.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.ProductAttribute.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.ProductAttributeValue.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.ProductImage.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.ProductVariant.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\catalog.ProductVariantPrice.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\customer.Customer.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\customer.CustomerAddress.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\customer.CustomerContact.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\customer.CustomerDocument.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\customer.CustomerDocumentType.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\customer.CustomerEmail.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\customer.CustomerType.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\inventory.Inventory.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\inventory.InventoryMovement.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\inventory.InventoryMovementNote.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\inventory.InventoryMovementReason.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\inventory.InventoryReservation.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\inventory.InventoryReservationStatus.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\payment.Payment.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\payment.PaymentMethod.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\payment.PaymentRefund.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\payment.PaymentRefundReason.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\payment.PaymentStatus.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\reference.Address.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\reference.AdministrativeDivision.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\reference.City.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\reference.ContactType.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\reference.Country.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\sales.Transaction.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\sales.TransactionChannel.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\sales.TransactionItem.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\sales.TransactionStatus.Defaults.sql

    :r $(DataModelRoot)\04-Default-Constraints\shipping.Shipment.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\shipping.ShipmentMethod.Defaults.sql
    :r $(DataModelRoot)\04-Default-Constraints\shipping.ShipmentStatus.Defaults.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● DEFAULT CONSTRAINTS TIME';
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

    /*==========================================================================
        CHECK CONSTRAINTS
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' CHECK CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\05-Check-Constraints\metadata.TablePrefix.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\catalog.ProductImage.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\catalog.ProductVariantPrice.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\customer.Customer.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\customer.CustomerAddress.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\customer.CustomerContact.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\customer.CustomerEmail.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\inventory.Inventory.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\inventory.InventoryMovement.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\inventory.InventoryReservation.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\payment.Payment.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\payment.PaymentRefund.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\reference.Address.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\sales.Transaction.Checks.sql
    :r $(DataModelRoot)\05-Check-Constraints\sales.TransactionItem.Checks.sql

    :r $(DataModelRoot)\05-Check-Constraints\shipping.Shipment.Checks.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● CHECK CONSTRAINTS TIME';
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

    /*==========================================================================
        UNIQUE CONSTRAINTS
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' UNIQUE CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\06-Unique-Constraints\metadata.TablePrefix.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\catalog.Brand.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\catalog.Category.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\catalog.Product.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\catalog.ProductAttribute.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\catalog.ProductAttributeValue.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\catalog.ProductVariant.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\customer.CustomerDocument.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\customer.CustomerDocumentType.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\customer.CustomerType.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\inventory.Inventory.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\inventory.InventoryMovementReason.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\inventory.InventoryReservation.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\inventory.InventoryReservationStatus.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\payment.PaymentMethod.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\payment.PaymentRefundReason.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\payment.PaymentStatus.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\reference.Address.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\reference.AdministrativeDivision.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\reference.City.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\reference.ContactType.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\reference.Country.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\sales.TransactionChannel.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\sales.TransactionStatus.Uniques.sql

    :r $(DataModelRoot)\06-Unique-Constraints\shipping.Shipment.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\shipping.ShipmentMethod.Uniques.sql
    :r $(DataModelRoot)\06-Unique-Constraints\shipping.ShipmentStatus.Uniques.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● UNIQUE CONSTRAINTS TIME';
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

    /*==========================================================================
        FOREIGN KEY CONSTRAINTS
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' FOREIGN KEY CONSTRAINTS';
    PRINT N'';

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.Category.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.Product.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.ProductAttributeValue.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.ProductCategory.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.ProductImage.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.ProductVariant.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.ProductVariantAttributeValue.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\catalog.ProductVariantPrice.ForeignKeys.sql

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\customer.Customer.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\customer.CustomerAddress.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\customer.CustomerContact.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\customer.CustomerDocument.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\customer.CustomerEmail.ForeignKeys.sql

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\inventory.Inventory.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\inventory.InventoryMovement.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\inventory.InventoryMovementNote.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\inventory.InventoryReservation.ForeignKeys.sql

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\payment.Payment.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\payment.PaymentRefund.ForeignKeys.sql

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\reference.Address.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\reference.AdministrativeDivision.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\reference.City.ForeignKeys.sql

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\sales.Transaction.ForeignKeys.sql
    :r $(DataModelRoot)\07-Foreign-Key-Constraints\sales.TransactionItem.ForeignKeys.sql

    :r $(DataModelRoot)\07-Foreign-Key-Constraints\shipping.Shipment.ForeignKeys.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● FOREIGN KEY CONSTRAINTS TIME';
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

    /*==========================================================================
        INDEXES
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' INDEXES';
    PRINT N'';

    :r $(DataModelRoot)\08-Indexes\catalog.ProductImage.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\catalog.ProductVariant.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\catalog.ProductVariantPrice.Indexes.sql

    :r $(DataModelRoot)\08-Indexes\customer.Customer.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\customer.CustomerAddress.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\customer.CustomerContact.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\customer.CustomerEmail.Indexes.sql

    :r $(DataModelRoot)\08-Indexes\inventory.InventoryMovement.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\inventory.InventoryMovementNote.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\inventory.InventoryReservation.Indexes.sql

    :r $(DataModelRoot)\08-Indexes\payment.Payment.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\payment.PaymentRefund.Indexes.sql

    :r $(DataModelRoot)\08-Indexes\sales.Transaction.Indexes.sql
    :r $(DataModelRoot)\08-Indexes\sales.TransactionItem.Indexes.sql

    :r $(DataModelRoot)\08-Indexes\shipping.Shipment.Indexes.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● INDEXES TIME';
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

    /*==========================================================================
        TEMPORAL INTEGRITY
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' TEMPORAL INTEGRITY';
    PRINT N'';

    :r $(DataModelRoot)\09-Temporal-Integrity\catalog.ProductVariantPrice.TemporalIntegrity.sql

    :r $(DataModelRoot)\09-Temporal-Integrity\inventory.InventoryReservation.TemporalIntegrity.sql

    :r $(DataModelRoot)\09-Temporal-Integrity\payment.PaymentRefund.TemporalIntegrity.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● TEMPORAL INTEGRITY TIME';
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

    /*==========================================================================
        FINAL VALIDATION
    ==========================================================================*/

    SET @GroupStartTime = SYSDATETIME();

    PRINT N' FINAL VALIDATION';
    PRINT N'';

    :r $(DataModelRoot)\10-Final-Validation\metadata.TablePrefix.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\catalog.Brand.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.Category.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.Product.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductAttribute.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductAttributeValue.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductCategory.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductImage.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductVariant.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductVariantAttributeValue.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\catalog.ProductVariantPrice.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\customer.Customer.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\customer.CustomerAddress.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\customer.CustomerContact.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\customer.CustomerDocument.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\customer.CustomerDocumentType.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\customer.CustomerEmail.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\customer.CustomerType.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\inventory.Inventory.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\inventory.InventoryMovement.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\inventory.InventoryMovementNote.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\inventory.InventoryMovementReason.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\inventory.InventoryReservation.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\inventory.InventoryReservationStatus.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\payment.Payment.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\payment.PaymentMethod.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\payment.PaymentRefund.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\payment.PaymentRefundReason.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\payment.PaymentStatus.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\reference.Address.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\reference.AdministrativeDivision.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\reference.City.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\reference.ContactType.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\reference.Country.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\sales.Transaction.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\sales.TransactionChannel.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\sales.TransactionItem.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\sales.TransactionStatus.FinalValidation.sql

    :r $(DataModelRoot)\10-Final-Validation\shipping.Shipment.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\shipping.ShipmentMethod.FinalValidation.sql
    :r $(DataModelRoot)\10-Final-Validation\shipping.ShipmentStatus.FinalValidation.sql

    SET @GroupEndTime = SYSDATETIME();

    SET @GroupElapsedMs =
        DATEDIFF_BIG
        (
            MILLISECOND,
            @GroupStartTime,
            @GroupEndTime
        );

    PRINT N'';
    PRINT N'    ● FINAL VALIDATION TIME';
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
    PRINT N' AtlasCommerce data model deployment completed successfully.';
    PRINT N'==============================================================================';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRANSACTION;

    PRINT N'';
    PRINT N'==============================================================================';
    PRINT N' AtlasCommerce data model deployment FAILED.';
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