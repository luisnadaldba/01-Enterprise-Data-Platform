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

Each variant has its own SKU and may have its own current commercial price.

Inventory is maintained separately by Product Variant and Warehouse.

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

Customer addresses are reusable immutable records that may be referenced by commercial operations.

A Shipment preserves its historical delivery address by referencing the exact CustomerAddress record selected at the time of fulfillment.

### Product and Product Variant

Product represents the commercial identity of an item.

Product Variant represents the specific sellable version of that product.

Each Product Variant has a mandatory internal SKU.

Variable characteristics such as color, size, volume, finish, or other product-specific properties are modeled separately through the product attribute model rather than as fixed Product Variant attributes.

Barcode management is outside the initial scope and should only be introduced when a concrete operational or integration requirement justifies its use.

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

Because CustomerAddress records are immutable, a Shipment may reference the exact CustomerAddress record selected for delivery. Later address changes create new CustomerAddress records and therefore do not alter the historical delivery address of an existing Shipment.

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

## 8. Product Domain Logical Model

The Product domain represents the commercial catalog structure used by Atlas Commerce.

The model separates the commercial identity of a product from its sellable variants and supports flexible product classification and characteristics without introducing unnecessary complexity into the initial implementation.

---

### Brand

Represents the commercial brand associated with a product.

Brand is maintained as a separate entity rather than as free text in Product in order to provide consistent classification and avoid multiple textual representations of the same brand.

A Brand may be associated with multiple Products.

Manufacturer and Supplier are considered separate business concepts and are not represented by Brand.

---

### Product

Represents the commercial identity of an item.

Examples:

- Batom Atlas Velvet
- Shampoo Atlas Professional
- Perfume Atlas Essence

Product does not represent the individual sellable variation of an item.

A Product may have multiple Product Variants.

Product maintains its own lifecycle status independently from the status of its Product Variants.

The current Product status must not be automatically changed when all associated Product Variants become inactive.

---

### Product Variant

Represents the specific sellable variation of a Product.

Examples:

- Batom Atlas Velvet - Rosa Aurora 217
- Batom Atlas Velvet - Vermelho Rubi
- Batom Atlas Velvet - Nude Elegance

Each Product Variant belongs to one Product.

SKU is the mandatory internal identifier of a Product Variant.

Barcode management is outside the initial scope and should only be introduced when an operational or integration requirement justifies its use.

Product Variant maintains the current commercial price.

Historical catalog price changes are not required by the initial business scope.

The price stored in Product Variant represents current state and may therefore be updated.

Historical selling prices must instead be preserved by Order Item as part of the transaction.

Inventory quantity does not belong to Product Variant and is maintained separately by Inventory and Warehouse.

Product Variant maintains its own lifecycle status independently from Product.

A Product Variant is commercially available only when both the Product and the Product Variant allow commercial use.

---

### Product Description

Represents the commercial textual description associated with a Product.

Product Description is maintained separately from Product because descriptions may contain large textual content and are normally required only when a specific product is consulted.

Separating the description prevents large textual data from being unnecessarily retrieved during general Product queries.

A Product may have multiple Product Description records in order to preserve description history.

Existing descriptions must not be overwritten when a new description becomes effective.

Only one Product Description should be active for a Product at a given time.

Multilanguage product descriptions are outside the initial scope because Atlas Commerce initially operates only in Brazil.

Internationalization may be introduced later if required by the business.

---

### Category

Represents a commercial catalog classification.

Categories support hierarchical relationships through a parent Category reference.

Example:

Cabelos
→ Shampoo

Maquiagem
→ Lábios
→ Batom

A Category may contain child Categories.

A Product may belong to multiple Categories.

Products should normally be associated with the most specific applicable Category.

Ancestor Categories are derived through the Category hierarchy and should not require redundant Product associations.

Characteristics describing the Product itself should not automatically be modeled as Categories.

For example, "Shampoo" may represent a Category while "Cabelos Cacheados" may be represented as a product characteristic when it describes the intended use or property of the Product rather than its catalog position.

---

### Product Category

Represents the many-to-many relationship between Product and Category.

A Product may be associated with multiple Categories.

A Category may contain multiple Products.

Independent category branches may therefore classify the same Product without duplicating the Product record.

---

### Product Attributes

Product characteristics must support different types of products without requiring a new physical column in Product Variant for every possible characteristic.

Examples of characteristics include:

- Color
- Volume
- Weight
- Finish
- Size
- SPF
- Hair Type

Free-text values should be avoided when the characteristic requires standardized comparison or filtering.

Controlled values should be used when appropriate.

Examples:

- COLOR: Rosa
- FINISH: Matte
- HAIR_TYPE: Cacheado

Numeric characteristics should use a standard unit defined for the corresponding attribute.

Examples:

- VOLUME: milliliters (mL)
- WEIGHT: grams (g)

The presentation layer may convert these values for display, but the transactional representation should remain standardized.

Commercially specific values may coexist with broader controlled classifications when required.

Example:

Commercial color: Rosa Aurora 217  
Color family: Rosa

This allows the exact commercial characteristic to be preserved while also supporting standardized analytical classification.

---

### Product Variant Attribute

Represents the association between a Product Variant and its characteristics.

A Product Variant may contain multiple attributes.

The attribute model should support controlled, standardized values while avoiding uncontrolled textual representations such as:

- ML
- ml
- Ml
- mL
- mililitros

Equivalent business values must have a single standardized representation.

---

### Product Pricing

Atlas Commerce does not initially require historical catalog price tracking.

The current Product Variant price represents the current commercial state and may be updated.

Order Item is responsible for preserving the actual financial conditions of a completed transaction.

Therefore:

- Product Variant answers: "What does this variant cost now?"
- Order Item answers: "For how much was this variant actually sold?"

Catalog price history should only be introduced if a future auditing, pricing, promotional, or analytical requirement justifies it.

---

### Product Media

Product image management is outside the initial scope.

The objective of the initial Atlas Commerce implementation is to simulate the complete data lifecycle from the transactional database through data engineering pipelines and analytical dashboards.

Product images do not currently contribute relevant transactional or analytical information to this objective and will therefore not be modeled in the initial version.

Media management may be introduced later if a concrete business or project requirement justifies it.

---

### Product Domain Principles

The initial Product domain follows these principles:

- Product represents commercial identity.
- Product Variant represents the sellable item.
- SKU is the mandatory internal variant identifier.
- Barcode is not implemented without a concrete requirement.
- Current catalog price is maintained in Product Variant.
- Historical selling price is preserved in Order Item.
- Inventory is maintained separately by Product Variant and Warehouse.
- Brand is controlled through a separate entity.
- Categories support hierarchical classification.
- Product and Category have a many-to-many relationship.
- Variable product characteristics are modeled through attributes rather than fixed Product Variant columns.
- Attribute values are standardized when comparison or aggregation is required.
- Large Product descriptions are separated from frequently accessed Product data.
- Product Description preserves historical versions.
- Product and Product Variant lifecycle statuses are independent.
- Product images and multilanguage descriptions are outside the initial scope.
- Future capabilities are introduced only when justified by concrete business, operational, integration, or analytical requirements.

## 9. Order, Inventory, Payment and Fulfillment Domain Logical Model

### Order

The `Order` entity represents a commercial purchase transaction.

An Order may optionally be associated with a registered Customer.

Initial structure:

- OrderId
- CustomerId
- OrderDate
- GrossAmount
- DiscountAmount
- ShippingAmount
- OrderStatusId
- Standard audit metadata

Business rules:

- One customer may have multiple orders.
- One order may contain multiple order items.
- `GrossAmount` represents the order amount before the order-level discount.
- `DiscountAmount` represents a discount applied to the order as a whole.
- `ShippingAmount` represents the shipping amount charged to the customer.
- `TotalAmount` will not be stored because it can be deterministically calculated from the persisted financial components.
- Product-level discounts must remain in `OrderItem` and must not be mixed with order-level discounts.
- `CustomerId` is optional.
- An Order may exist without an identified registered Customer, such as a physical store sale or guest checkout.
- A NULL `CustomerId` represents a legitimate unidentified or guest buyer and must not automatically be interpreted as missing or invalid data.
- `OrderStatusId` represents the high-level commercial lifecycle of the Order and must not duplicate payment, inventory reservation, shipment, or refund status.
- Initial conceptual Order statuses are `OPEN`, `CONFIRMED`, `CANCELLED`, and `COMPLETED`.
- `COMPLETED` means that all remaining commercial obligations represented by the Order have been satisfied.
- Delivery of a single Shipment does not necessarily complete an Order because one Order may generate multiple Shipments.
- Order completion must consider the quantities effectively fulfilled relative to the quantities originally purchased and any legitimate cancellations.
- A completed Order may be reopened when a later confirmed fulfillment issue creates a new outstanding commercial obligation.

---

### OrderItem

The `OrderItem` entity represents a product variant sold within an order.

Initial structure:

- OrderItemId
- OrderId
- ProductVariantId
- Quantity
- UnitPrice
- UnitDiscount
- Standard audit metadata

Business rules:

- One order may contain multiple order items.
- The product price used at the moment of the sale must be persisted in `UnitPrice`.
- Discounts are always normalized to a unit-level discount.
- `ItemTotal` will not be persisted because it can be calculated from:
  - Quantity
  - UnitPrice
  - UnitDiscount
- Promotional rules belong to the business/application layer.
- The database persists the resulting commercial facts, not the promotional calculation logic.
- Once the Order is confirmed, the commercial attributes of an `OrderItem` must be treated as immutable.
- `Quantity` represents the quantity originally purchased and must not be overwritten to represent later cancellations, shipment shortages, losses, replacements, or other fulfillment events.
- `UnitPrice` and `UnitDiscount` represent the commercial conditions accepted for that item at the time of purchase.
- `OrderItem` does not require a general-purpose status to represent payment, inventory, cancellation, or shipment states.
- Operational events affecting only part of an `OrderItem` must be represented by the domain responsible for that event rather than by overwriting the original `OrderItem`.
- Partial cancellation must preserve the originally purchased quantity and must be represented separately through `OrderItemCancellation`.
- A replacement or complementary delivery caused by a fulfillment issue must not create a new `OrderItem`, because it does not represent a new sale.

---

### OrderItemCancellation

`OrderItemCancellation` represents the cancellation of all or part of the quantity originally purchased in an `OrderItem`.

Relationship:

`OrderItem 1:N OrderItemCancellation`

Initial structure:

- OrderItemCancellationId
- OrderItemId
- Quantity
- CancellationReasonId
- CancelledAt
- Standard audit metadata

Business rules:

- An `OrderItem` may have zero, one, or multiple cancellation records.
- `Quantity` represents the quantity cancelled by that specific cancellation event.
- Cancellation must never overwrite the original `OrderItem.Quantity`.
- The total valid cancelled quantity for an `OrderItem` must not exceed the quantity originally purchased.
- Cancellation records represent historical business facts and must not be physically deleted or overwritten to reverse a previous cancellation.
- Cancellation reasons must use a controlled domain suitable for operational analysis and reporting.
- Financial reimbursement resulting from a cancellation belongs to the financial domain and must not be represented by `OrderItemCancellation`.
- Inventory released because of a cancellation belongs to the inventory domain and must be represented through the appropriate reservation or inventory process.

---

### Payment

An order may be paid using one or more payment methods.

Relationship:

`Order 1:N Payment`

Initial structure:

- PaymentId
- OrderId
- PaymentMethodId
- Amount
- InstallmentCount
- PaymentStatusId
- PaymentDate
- Standard audit metadata

Examples of payment methods:

- CASH
- PIX
- CREDIT_CARD
- DEBIT_CARD

Business rules:

- Split payment is allowed.
- Example: part CASH and part CREDIT_CARD.
- `InstallmentCount` remains directly in `Payment`.
- Detailed installment tracking is outside the V1 scope.
- The order is considered fully paid only when the sum of approved payments reaches the amount due for the order.
- `PaidAmount` and `RemainingAmount` will not be persisted because they are derived values.
- Payment approval is the event that converts reserved inventory into sold inventory.
- `PaymentStatusId` represents the financial state of the Payment and must not be duplicated by `OrderStatusId`.
- Approved payments must preserve the amount that was actually received, even when the accumulated approved amount exceeds the amount due for the Order.
- An overpayment is a legitimate financial fact and must not be rejected or modified merely to force the accumulated Payment amount to match the Order amount.
- Financial corrections must preserve the original Payment record rather than deleting or rewriting the payment that actually occurred.
- Money returned to the buyer must be represented by a separate financial event or entity and must not be represented as a negative Payment.

---

### Refund

`Refund` represents money returned to the buyer after a previously recorded Payment.

Relationship:

`Payment 1:N Refund`

Initial structure:

- RefundId
- PaymentId
- Amount
- RefundReasonId
- RefundStatusId
- RefundDate
- Standard audit metadata

Business rules:

- A Payment may have zero, one, or multiple Refund records.
- A Refund does not modify or delete the original Payment.
- `Amount` represents the amount actually returned through that Refund event.
- Refund reasons must use a controlled domain suitable for financial traceability and reporting.
- A Refund may result from partial cancellation, overpayment, duplicate payment, or another legitimate financial correction.
- Product return and inventory return are separate business events and must not be inferred solely from the existence of a Refund.
- Refund processing belongs to the financial domain and must not alter the original commercial facts preserved by `OrderItem`.

---

### Inventory Reservation

Inventory is reserved when the order is created but payment has not yet been fully approved.

Relationship:

`OrderItem 1:N InventoryReservation`

Initial structure:

- InventoryReservationId
- OrderItemId
- WarehouseId
- Quantity
- ReservationStatusId
- ExpiresAt
- Standard audit metadata

Business rules:

- Reserved units must not be visible as available stock to another customer.
- Reservation must have an expiration period.
- If payment expires or fails, the reservation is released.
- Inventory quantity is not reduced while the reservation remains pending.
- Inventory is reduced only after full payment approval.
- A single `OrderItem` may generate multiple inventory reservations when its quantity must be fulfilled from different Warehouses.
- `Quantity` represents the quantity reserved from the specific Warehouse for that reservation.
- `ExpiresAt` defines when a pending reservation is no longer guaranteed and may be released.
- Reservation expiration must be processed atomically to prevent released inventory from remaining unavailable or being consumed by an expired reservation.
- A consumed reservation must remain historically traceable and must not be physically deleted after payment approval.
- An expired or released reservation must remain historically traceable and must not be physically deleted.

Example:

Physical inventory:

`10`

Reserved:

`3`

Available to other customers:

`7`

After payment approval:

- Reservation becomes consumed.
- Inventory quantity is reduced.
- A `SALE` inventory movement is created.

---

### Inventory

`Inventory` represents the current stock position of a product variant in a warehouse.

Initial structure:

- ProductVariantId
- WarehouseId
- Quantity
- Standard audit metadata

Relationship:

`ProductVariant N:N Warehouse`, resolved through `Inventory`.

Business rules:

- Inventory quantity represents the current operational stock position.
- Although the quantity could theoretically be reconstructed from movement history, it is persisted for operational performance and concurrency requirements.
- Inventory movement history remains the source used to explain how the current stock position was reached.
- One Inventory record represents the current stock position of exactly one Product Variant in exactly one Warehouse.
- The combination of `ProductVariantId` and `WarehouseId` must be unique.
- `Quantity` represents physical stock and must not be reduced merely because units are temporarily reserved.
- Available inventory is derived from physical inventory minus active reservations and must not be persisted as a separate quantity in the initial model.
- Changes to `Quantity` caused by inventory business events must remain traceable through the corresponding `InventoryMovement`.

---

### InventoryMovement

`InventoryMovement` preserves the history of inventory changes.

Initial structure:

- InventoryMovementId
- ProductVariantId
- WarehouseId
- MovementTypeId
- Quantity
- MovementGroupId NULL
- OrderItemId NULL
- AdjustmentReasonId NULL
- OccurredAt
- Standard audit metadata

Initial movement types:

- RECEIPT
- SALE
- SALE_REVERSAL
- TRANSFER_OUT
- TRANSFER_IN
- ADJUSTMENT

Quantity sign convention:

- Incoming inventory uses positive quantities.
- Outgoing inventory uses negative quantities.

Examples:

`RECEIPT +100`

`SALE -5`

`TRANSFER_OUT -20`

`TRANSFER_IN +20`

`ADJUSTMENT -2`

Business rules:

- Sales movements must be traceable to the corresponding `OrderItem`.
- Optional foreign keys are acceptable when their semantic relationship is genuinely optional.
- Data must remain traceable and consistent.
- Transfers may initially use `MovementGroupId` to correlate related movements.
- No inventory history record should be deleted to represent a reversal.
- Reversals must generate a new compensating movement.
- `InventoryMovement` records are append-only historical facts and must not be updated to rewrite an inventory event that already occurred.
- Every movement that changes inventory must correspond to the same quantity change applied to the related `Inventory` current-state record.
- Changes to `Inventory` and creation of the corresponding `InventoryMovement` must occur atomically as part of the same business operation.
- `MovementGroupId` may correlate multiple movement records that together represent one logical inventory operation, such as a transfer between Warehouses.
- A transfer must preserve both sides of the operation: one `TRANSFER_OUT` movement from the source Warehouse and one `TRANSFER_IN` movement into the destination Warehouse.

Example:

`SALE -3`

followed by:

`SALE_REVERSAL +3`

---

### InventoryAdjustmentReason

Inventory adjustments must always have a controlled reason.

Initial examples:

- DAMAGE
- COUNT_CORRECTION
- LOSS
- FOUND

Business rules:

- Free-text adjustment reasons are not allowed.
- If `MovementType = ADJUSTMENT`, an adjustment reason is required.
- Adjustment reasons support both operational investigation and management reporting.

---

### InventoryMovementNote

Long or infrequently accessed textual information must not be stored directly in the high-volume `InventoryMovement` table.

Relationship:

`InventoryMovement 0..1 : 1 InventoryMovementNote`

Initial structure:

- InventoryMovementId — PK and FK
- Note
- Standard audit metadata

Business rationale:

- `InventoryMovement` may reach hundreds of millions of rows.
- Text columns increase row width and may increase I/O and memory usage.
- Operational queries should not carry descriptive text that is rarely required.
- Detailed notes are accessed only when investigating a specific movement.

---

### Warehouse

Initial structure:

- WarehouseId
- Name
- LocationId
- Status
- Standard audit metadata

Business rules:

- Warehouse stock is stored in `Inventory`, not directly in `Warehouse`.
- Deactivating a warehouse must not artificially set inventory to zero.
- Remaining inventory should be transferred to another warehouse before the warehouse becomes inactive.
- Historical relationships with previous movements and shipments must remain preserved.
- An inactive Warehouse must not be used for new inventory reservations, receipts, transfers into the Warehouse, or new shipment fulfillment, while its historical data remains available.

---

### Shipment

A `Shipment` represents one physical shipment originating from one warehouse for one order.

Relationship:

`Order 1:N Shipment`

Initial structure:

- ShipmentId
- OrderId
- CustomerAddressId
- WarehouseId
- CarrierId
- ShipmentStatusId
- ShippingCost
- Standard audit metadata

Business rules:

- One order may produce multiple shipments.
- One shipment has exactly one warehouse of origin.
- Separate warehouses generate separate shipments.
- Different shipments from the same order may use different carriers.
- `ShippingCost` represents the company's actual logistics cost for the shipment.
- `Order.ShippingAmount` represents the amount charged to the customer.
- These values must remain separate because the company may subsidize shipping.
- `ShipmentStatusId` represents the current logistics state of the Shipment and must not be duplicated by `OrderStatusId`.
- A new Shipment may be created for an existing Order when an additional physical fulfillment operation is required, including replacement or complementary delivery.
- Creating a replacement or complementary Shipment does not create a new `OrderItem`, because the original commercial transaction remains unchanged.
- A Shipment that is lost, failed, or otherwise unsuccessful must remain historically preserved even when a replacement Shipment is created.
- Completion of one Shipment does not by itself imply completion of the related Order.
- `CustomerAddressId` identifies the immutable CustomerAddress record selected as the delivery address for that Shipment.
- Later changes to the customer's address information must create a new CustomerAddress record and must not alter the address referenced by an existing Shipment.

Example:

Order 1001

Shipment 501:
- Warehouse SP
- Carrier A

Shipment 502:
- Warehouse MG
- Carrier B

---

### ShipmentItem

`ShipmentItem` represents the contents of a physical shipment.

Initial structure:

- ShipmentItemId
- ShipmentId
- OrderItemId
- Quantity

Relationship:

`Shipment 1:N ShipmentItem`

Business rules:

- One `OrderItem` may be split across multiple shipments.
- Shipment item quantities preserve the physical allocation of the order across warehouses.
- `Quantity` represents the quantity of the referenced `OrderItem` physically allocated to that specific Shipment.
- A ShipmentItem must reference an OrderItem belonging to the same Order as its parent Shipment.
- ShipmentItem records must preserve the physical fulfillment history and must not be overwritten merely because a later replacement or complementary Shipment is created.
- The same OrderItem may legitimately appear in multiple Shipments, including replacement or complementary fulfillment operations.
- Shipment fulfillment quantities must be evaluated together with legitimate OrderItem cancellations when determining whether the commercial obligation of the Order has been satisfied.

Example:

OrderItem:

`Batom Rosa | Quantity 11`

Shipment SP:

`Batom Rosa | Quantity 10`

Shipment MG:

`Batom Rosa | Quantity 1`

---

### Carrier

Carrier information must use a controlled entity instead of free-text values.

Initial structure:

- CarrierId
- Name
- Status
- Standard audit metadata

---

### ShipmentEvent

Shipment tracking must preserve a chronological event history.

Relationship:

`Shipment 1:N ShipmentEvent`

Initial structure:

- ShipmentEventId
- ShipmentId
- ShipmentEventTypeId
- OccurredAt
- LocationId NULL
- Standard audit metadata

Examples:

- PREPARING
- IN_TRANSIT
- AT_DISTRIBUTION_CENTER
- OUT_FOR_DELIVERY
- DELIVERED
- DELIVERY_ATTEMPT_FAILED

Business rules:

- Shipment events are append-only historical facts.
- Events allow both customer-facing tracking and internal logistics analysis.
- Event history must not be overwritten when the shipment changes status.
- `OccurredAt` represents when the logistics event actually occurred and must not be inferred from the record creation timestamp.
- `ShipmentStatusId` represents the current operational state of the Shipment, while `ShipmentEvent` preserves the historical sequence of logistics facts that led to that state.

Example timeline:

`10/08 08:15 — PREPARING`

`10/08 17:40 — AT_DISTRIBUTION_CENTER`

`11/08 07:20 — OUT_FOR_DELIVERY`

`11/08 14:32 — DELIVERED`

---

### ShipmentEventNote

Optional descriptive information related to a shipment event must remain outside the main event table.

Relationship:

`ShipmentEvent 0..1 : 1 ShipmentEventNote`

Initial structure:

- ShipmentEventId — PK and FK
- Note
- Standard audit metadata

This follows the same architectural principle used for `InventoryMovementNote`: high-volume operational tables remain narrow while infrequently accessed text remains separately stored.

---

### ShipmentDeliveryEstimate

Delivery estimates must preserve history instead of overwriting previous promises.

Relationship:

`Shipment 1:N ShipmentDeliveryEstimate`

Initial structure:

- ShipmentDeliveryEstimateId
- ShipmentId
- EstimatedDeliveryDate
- Standard audit metadata

Business rules:

- A new delivery estimate creates a new row.
- Previous estimates are never overwritten.
- The system must preserve the original delivery promise.
- The latest estimate represents the current expected delivery date.
- `CreatedAt` from the standard audit metadata represents when the delivery estimate became known to the Atlas Commerce platform.

Example:

`10/08 → Estimated delivery: 13/08`

`11/08 → Estimated delivery: 14/08`

`13/08 → Estimated delivery: 15/08`

`15/08 → Delivered`

This history will allow future analytics such as:

- Original promise vs. actual delivery.
- Number of delivery estimate changes.
- Average delivery delay.
- Delay by carrier.
- Delay by distribution center.
- Internal preparation time vs. carrier transportation time.

---

### Architectural Principle — Facts vs. Predictions

Operational facts and predictions must remain conceptually separate.

`ShipmentEvent`
represents what actually happened.

`ShipmentDeliveryEstimate`
represents what was expected or promised to happen.

Historical information must not be overwritten merely to represent the current state.

---

### Architectural Principle — Current State vs. History

For high-volume operational domains, the architecture may intentionally preserve both:

- Current state optimized for operational access.
- Append-only history optimized for traceability, investigation and analytics.

Examples:

`Inventory`
= current stock position.

`InventoryMovement`
= history explaining how the stock reached that position.

`Shipment`
= current shipment entity.

`ShipmentEvent`
= historical logistics timeline.

This controlled duplication is acceptable when it has a clear operational purpose and the authoritative historical facts remain traceable.