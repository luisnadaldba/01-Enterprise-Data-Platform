# Atlas Commerce - Commerce Domain Model

## Document Information

- **Document ID:** ACM-DOM-001
- **Document Type:** Domain Model
- **Status:** Draft
- **Created:** 2026-08-08
- **System:** Atlas Commerce
- **Database Platform:** Microsoft SQL Server

## 1. Purpose

This document describes the initial business domain model for the Atlas Commerce transactional platform.

The objective is to identify the main business entities, their responsibilities, and their relationships before the physical database model is created.

## 2. Business Context

Atlas Commerce is a nationwide e-commerce company focused on beauty and personal care products.

The transactional database is considered mission-critical and must support continuous 24x7 operations, with only small, previously scheduled maintenance windows when required.

The platform is expected to grow significantly over time and must be designed with scalability, data consistency, availability, and maintainability in mind.

## 3. Main Business Flow

Customer → Catalog → Cart → Order → Payment → Inventory → Shipment → Delivery

## 4. Initial Domain Entities

### Customer
Represents a customer registered in the Atlas Commerce platform.

### Customer Address
Represents an address associated with a customer.

A customer may have multiple active addresses simultaneously.

Addresses may be activated or deactivated without being physically deleted.

### Customer Contact
Represents customer contact information.

### Product
Represents the commercial identity of a product.

Example:

Batom Atlas Velvet

### Product Variant
Represents a specific sellable variation of a product.

Examples:

- Batom Atlas Velvet - Vermelho
- Batom Atlas Velvet - Nude
- Batom Atlas Velvet - Rosa

Each variant may have its own SKU, barcode, price, and inventory.

### Order
Represents a purchase transaction created by a buyer.

An order may optionally be associated with a registered customer account.

### Order Item
Represents an individual product variant purchased as part of an order.

### Payment
Represents payment information associated with an order.

### Warehouse
Represents a physical distribution or inventory location.

### Inventory
Represents the stock position of a product variant at a specific warehouse.

### Shipment
Represents the physical fulfillment and transportation of an order.

### Shipment Item
Represents the allocation of an order item, or part of its quantity, to a specific shipment.

### Transaction Adjustment
Represents an exceptional financial adjustment applied to a transaction and preserves the business reason for that adjustment.

## 5. Initial Business Rules

- A customer may have multiple addresses.
- Multiple customer addresses may remain active simultaneously.
- A product may have multiple sellable variants.
- Each product variant has its own SKU.
- Inventory is controlled by product variant and warehouse.
- An order may contain multiple order items.
- Transactional data must preserve historical information even if master data changes later.

## 6. Modeling Decisions

### Customer and Guest Checkout

An order must always represent a buyer, but the buyer is not required to have a registered customer account.

Orders may therefore be associated with a registered customer when available, while preserving the buyer information required for the transaction.

### Customer Addresses

A customer may maintain multiple active addresses simultaneously.

Customer addresses represent reusable address records and must not be treated as the historical shipping address of an order.

Transactional shipping information must preserve the address actually used at the time of fulfillment.

### Product and Product Variant

Product represents the commercial identity of an item.

Product Variant represents the specific sellable version of that product and may define attributes such as SKU, barcode, color, size, or volume.

Order items reference Product Variant rather than Product directly.

### Order Item Pricing

Order items must preserve the financial conditions that were actually applied at the time of purchase.

Historical order pricing must not depend on the current product price.

The transaction should preserve the original amount, applied discount amount, and final amount required to reconstruct and audit the sale.

### Inventory

Inventory is maintained by Product Variant and Warehouse.

A single product variant may therefore have different inventory positions across multiple warehouses.

### Shipment Splitting

A single order may generate multiple shipments.

A single order item may also be split across multiple shipments when the requested quantity is fulfilled from different warehouses.

Shipment Item represents the relationship between a shipment and an order item and preserves the quantity included in each shipment.

### Transaction Adjustments

Exceptional financial adjustments must preserve both the financial impact and the business reason for the adjustment.

Structured reason codes should be preferred for reporting and analysis, with optional free-text descriptions used to preserve additional context.

## 7. Customer Domain Logical Model

### Customer

Represents a customer registered in the Atlas Commerce platform.

Customer information must remain available regardless of purchasing activity.
Customer activity or inactivity must not be inferred from an arbitrary customer status based only on the date of the last purchase.

Customer data includes:

- Name
- Birth date
- Standard audit metadata

Documents, addresses, and contacts are modeled separately.

---

### CustomerDocument

Represents an identification document associated with a customer.

A customer may have more than one document.

CustomerDocument includes:

- Customer
- DocumentType
- DocumentTypeDescription (optional; used for unsupported document types)
- DocumentNumber
- IssuingCountry
- ExpirationDate (optional)
- Standard audit metadata

Document types must be selected from a controlled domain.

An OTHER document type may be used when the document type is not yet supported by the platform. The free-text description is an operational exception and does not automatically create a new official document type.

ExpirationDate represents a fact about the document. Rules determining whether an expired document can be accepted belong to business or regulatory rules.

---

### DocumentType

Represents the controlled domain of identification document types.

This prevents equivalent document types from being stored with inconsistent descriptions.

Examples:

- CPF
- PASSPORT
- OTHER

---

### Geographic Model

Geographic information follows the hierarchy:

Country → State → City

A City belongs to one State.
A State belongs to one Country.

CustomerAddress references City only. State and Country are derived through the geographic hierarchy, avoiding redundant geographic relationships.

The initial commercial scope of Atlas Commerce supports sales and deliveries only within Brazilian territory.

The geographic model may support additional countries without implying international commercial operation.

---

### CustomerAddress

Represents an address registered by a customer for possible use in commercial operations.

A customer may maintain multiple addresses.

CustomerAddress includes:

- Customer
- Street
- Number (optional)
- Complement (optional)
- Neighborhood
- PostalCode
- City
- Status
- Standard audit metadata

Absence of a street number is stored as NULL. Presentation values such as "S/N" are application concerns and must not be persisted as substitutes for missing data.

Customer addresses are immutable with respect to address information.

Changing an address creates a new CustomerAddress record and marks the previous relationship/address as inactive.

Historical address records must not be physically deleted.

An address registered by a customer does not represent the historical delivery address of a transaction. Orders/shipments must preserve their own address snapshot.

---

### ContactType

Represents the controlled domain of supported contact types.

Examples:

- LANDLINE
- EMAIL
- MOBILE

Contact types must not be represented by unrestricted free-text values.

---

### Contact

Represents a contact value independently from the customer relationship.

Contact includes:

- ContactType
- ContactValue
- Standard audit metadata

The same contact may be associated with multiple customers.

Contact values are immutable. A change to a contact value creates a new Contact record rather than modifying the existing value.

---

### CustomerContact

Represents the relationship between a Customer and a Contact.

The relationship is many-to-many:

Customer N ↔ N Contact

CustomerContact includes:

- Customer
- Contact
- Status
- Standard audit metadata

A contact may be shared by multiple customers.

A customer may have multiple contacts.

Changing a customer's contact does not modify the existing Contact. A new Contact is created and the previous CustomerContact relationship is marked inactive.

Historical relationships must not be physically deleted.

The same active customer/contact relationship must not be duplicated.

The physical mechanism used to enforce active relationship uniqueness will be defined during physical database design.

---

### Standard Audit Metadata

Business entities use standard creation and last-update metadata:

- CreatedAt
- CreatedByActor
- UpdatedAt
- UpdatedByActor

CreatedAt and CreatedByActor are immutable.

UpdatedAt and UpdatedByActor represent the latest modification.

At record creation:

CreatedAt = UpdatedAt  
CreatedByActor = UpdatedByActor

These attributes provide current-state traceability and do not replace a complete audit history.

---

### Actor

Represents the identity responsible for an operation in the platform.

An Actor may represent:

- Customer
- Employee
- System process
- Integration
- Other authorized source

Audit metadata references Actor rather than directly referencing multiple possible source entities.

---

### Data Preservation Principle

Business data with historical relevance must not be destructively overwritten or physically deleted merely because the current value has changed.

Where historical preservation is required, changes are represented by new records and previous records are retained with the appropriate lifecycle status.

Exceptions must be explicitly justified by business or technical requirements.