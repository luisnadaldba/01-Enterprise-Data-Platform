# AtlasCommerce Domain Model

## 1. Purpose

This document defines the logical domain model of AtlasCommerce.

Its purpose is to describe the persistent entities that compose the AtlasCommerce transactional model, the responsibilities assigned to those entities, and the relationships that connect the business and technical domains of the database.

The Domain Model focuses on the meaning and structure of persisted data.

It describes:

- The primary entities implemented in each AtlasCommerce domain.
- The semantic responsibility of each entity.
- The relationships between entities within the same domain.
- Cross-domain relationships required by the transactional model.
- Lifecycle and historical-preservation responsibilities that affect entity meaning.
- The distinction between current-state entities and historical or event-oriented entities.
- The boundaries between implemented domain structures and future extensions.

This document does not define:

- Detailed business rules that belong to the AtlasCommerce Business Documentation.
- Database naming, prefix, constraint, index, ordering, deployment, or validation conventions governed by the AtlasCommerce Database Standards.
- Physical storage, partitioning, transactional deployment boundaries, or extraction architecture governed by the AtlasCommerce Architecture.
- Detailed deployment implementation contained in the AtlasCommerce SQL scripts.

The Domain Model must remain synchronized with the validated AtlasCommerce database implementation.

When an older domain assumption conflicts with the consolidated implemented model, the discrepancy must be investigated.

If the implemented database is confirmed to represent the current intended model, the Domain Model must be updated to describe that implementation rather than preserving an obsolete conceptual structure.

The objective of this document is therefore not to preserve the first conceptual version of AtlasCommerce.

Its objective is to describe the persistent domain model that AtlasCommerce actually implements and validates.

---

## 2. Domain Model Scope and Source of Truth

The AtlasCommerce Domain Model describes the persistent logical structure implemented by the transactional database.

Its scope is limited to entities, relationships, and persistent responsibilities that form part of the validated AtlasCommerce data model.

The model is organized according to the database domains represented by the following schemas:

- `metadata`
- `catalog`
- `customer`
- `inventory`
- `payment`
- `reference`
- `sales`
- `shipping`

These schemas provide logical responsibility boundaries within a single transactional database.

The Domain Model may describe relationships that cross schema boundaries when those relationships are required by the persistent operational model.

A schema boundary does not imply an independent database, isolated transactional system, or prohibition against cross-domain relationships.

---

### 2.1 Model Scope

The Domain Model describes persistent structures according to their semantic responsibility.

For each applicable domain, the model identifies:

- Implemented persistent entities.
- The primary responsibility of each entity.
- Relationships between entities.
- Cardinality where it is relevant to understanding the model.
- Controlled-domain entities used to represent persistent classifications or lifecycle states.
- Current-state structures.
- Historical, event, or lifecycle structures.
- Cross-domain dependencies.
- Persistent identity and ownership boundaries.

The model describes what the persisted structures represent.

Detailed physical implementation characteristics are documented by the artifacts responsible for those concerns.

For example, the existence and meaning of a relationship belong to the Domain Model, while the exact foreign key name and deployment-validation logic belong to the Database Standards and deployment implementation.

Likewise, the semantic role of a transactional entity belongs to this document, while its physical partitioning strategy belongs to the Architecture and implemented database definition.

---

### 2.2 Implemented Model

The primary subject of this document is the implemented AtlasCommerce domain model.

An entity is described as part of the implemented model when it forms part of the consolidated and validated database implementation.

Concepts considered during earlier modeling stages but not present in the current validated implementation must not be presented as though they remain implemented entities.

Likewise, an earlier conceptual name must not be preserved when the implemented model has adopted a different entity or responsibility.

This distinction is particularly important because the AtlasCommerce model has evolved during implementation.

The Domain Model must therefore describe the resulting consolidated model rather than preserve obsolete intermediate design assumptions.

---

### 2.3 Conceptual and Physical Representation

The Domain Model describes logical meaning without ignoring characteristics of the implemented database that materially affect that meaning.

A logical relationship may have a more detailed physical representation because of requirements such as:

- Partition-aware keys.
- Composite candidate keys.
- Historical preservation.
- Conditional uniqueness.
- Separation between current state and historical events.
- Controlled lifecycle representation.

When such characteristics affect how entities relate, they may be explained in this document at the level necessary to understand the domain model.

The Domain Model must not, however, duplicate the complete physical definition of keys, constraints, indexes, filegroups, partition schemes, or deployment scripts.

The objective is to explain the persistent relationship and its meaning, not reproduce its SQL implementation.

---

### 2.4 Source of Truth

The consolidated and validated AtlasCommerce database implementation is the technical source of truth for the implemented persistent model.

The Domain Model must remain synchronized with that implementation.

Other AtlasCommerce documentation provides complementary sources of meaning:

- Business Documentation defines business concepts, behavior, rules, and lifecycle semantics.
- Architecture Documentation defines architectural responsibilities, boundaries, and major technical design decisions.
- Database Standards define implementation conventions and database-governance rules.
- Deployment scripts define the implemented database objects and deployment behavior.
- Final Validation independently verifies the expected deployed state.

These sources must remain consistent, but they serve different responsibilities.

The Domain Model must not override a validated implementation merely because an older conceptual design described a different structure.

Likewise, an implementation divergence must not automatically be accepted as the intended model solely because it currently exists in a database.

A discrepancy requires controlled review.

---

### 2.5 Model Reconciliation

When the Domain Model, Business Documentation, Architecture, Database Standards, deployment implementation, or validated database state appear to disagree, the discrepancy must be investigated according to the responsibility of the affected information.

Possible causes include:

- An obsolete conceptual model.
- An obsolete implementation.
- A business rule that changed after the original model was created.
- A controlled architectural change.
- An incomplete documentation update.
- An incomplete migration.
- An unintended implementation divergence.

The objective of reconciliation is not to force one artifact to match another without analysis.

The objective is to establish the intended current state and synchronize all affected artifacts accordingly.

Once the intended state has been confirmed, obsolete representations must be updated or retired so that AtlasCommerce does not maintain competing definitions of the same persistent model.

---

### 2.6 Domain Ownership

Every persistent entity belongs to a primary AtlasCommerce domain.

Domain ownership identifies where responsibility for the entity's persisted state resides.

A relationship with an entity owned by another domain does not transfer ownership.

For example, when an entity in one schema references an entity in another schema:

- The referenced domain remains responsible for the referenced entity.
- The consuming domain owns the relationship from its side of the model.
- Referential integrity may protect the relationship.
- The referenced identity must not be duplicated merely to avoid a cross-domain dependency.

This principle allows AtlasCommerce to preserve clear responsibility boundaries while remaining a consistent relational transactional system.

---

### 2.7 Future Domain Extensions

Future entities or domain capabilities may be discussed when necessary to establish an explicit model boundary, but they must be clearly distinguished from implemented structures.

A future requirement must not be represented as part of the current model until its business responsibility, logical design, and implementation have been intentionally defined.

Likewise, the absence of an entity from the current model does not prohibit its future introduction.

Future extensions must be incorporated according to the same principles used by the existing model:

- Explicit domain responsibility.
- Clear persistent meaning.
- Controlled relationships.
- Appropriate historical behavior.
- Consistency with business semantics.
- Synchronization with Architecture and Database Standards.
- Validation through the implemented deployment process.

---

## 3. Domain Overview

AtlasCommerce is organized into explicit logical domains implemented through SQL Server schemas.

The current business and technical domains are:

| Schema | Primary Responsibility |
|---|---|
| `metadata` | Technical metadata and database governance |
| `catalog` | Product catalog, classification, variants, attributes, media, and pricing |
| `customer` | Customer identity, documents, contacts, email addresses, addresses, and customer-related master data |
| `inventory` | Inventory position, movements, movement context, and stock reservations |
| `payment` | Payment methods, payment execution, payment state, refunds, and refund reasons |
| `reference` | Shared geographic reference data and shared controlled classifications |
| `sales` | Commercial transactions, transaction items, channels, and transaction lifecycle |
| `shipping` | Shipment, delivery method, delivery state, tracking, and freight information |

These domains define responsibility boundaries inside a single relational transactional database.

A schema boundary identifies ownership.

It does not prohibit relationships between domains.

---

### 3.1 Metadata Domain

The `metadata` domain owns technical information used to govern the AtlasCommerce database itself.

Its current responsibility includes the controlled registry of table prefixes used by database objects.

Conceptually:

```text
metadata
│
└── TablePrefix
```

`metadata.TablePrefix` is technical metadata rather than retail business data.

It supports database governance and implementation consistency without participating directly in commercial processes.

---

### 3.2 Catalog Domain

The `catalog` domain owns the commercial definition and representation of products.

Its current responsibilities include:

- Brand.

- Category and category hierarchy.

- Product.

- Product-to-category relationships.

- Product images.

- Product variants.

- Product attributes.

- Controlled attribute values.

- Variant-to-attribute-value relationships.

- Product-variant pricing.

Conceptually:

```text

catalog

│

├── Brand

├── Category

├── Product

├── ProductCategory

├── ProductImage

├── ProductVariant

├── ProductAttribute

├── ProductAttributeValue

├── ProductVariantAttributeValue

└── ProductVariantPrice

```

The catalog defines what may be sold and how the sellable item is commercially represented.

Operational domains consume catalog identities without acquiring ownership of them.

---

### 3.3 Customer Domain

The `customer` domain owns registered customer identity and customer-specific master data.

Its current responsibilities include:

- Customer classification.
- Customer identity.
- Customer documents.
- Controlled customer-document types.
- Telephone contacts.
- Email addresses.
- Customer-address relationships.

Conceptually:

```text
customer
│
├── CustomerType
├── Customer
├── CustomerDocument
├── CustomerDocumentType
├── CustomerContact
├── CustomerEmail
└── CustomerAddress
```

CustomerContact consumes the shared `reference.ContactType` classification.

CustomerAddress consumes the shared `reference.Address` identity.

These cross-domain relationships do not transfer ownership of the referenced entities to the customer domain.

---

### 3.4 Inventory Domain

The `inventory` domain owns operational inventory state and the history required to explain inventory changes.

Its current responsibilities include:

- Current inventory position.
- Inventory movement history.
- Controlled movement reasons.
- Optional movement notes.
- Inventory reservations.
- Reservation lifecycle state.

Conceptually:

```text
inventory
│
├── Inventory
├── InventoryMovementReason
├── InventoryMovement
├── InventoryMovementNote
├── InventoryReservationStatus
└── InventoryReservation
```

Inventory operates against `catalog.ProductVariant` because stock responsibility belongs to the specific sellable variant rather than only to the conceptual Product.

Inventory reservations are associated with purchased transaction items when the applicable sales lifecycle requires stock to be reserved.

---

### 3.5 Payment Domain

The `payment` domain owns the financial execution associated with commercial Transactions.

Its current responsibilities include:

- Payment methods.
- Payment lifecycle state.
- Payment attempts and financial facts.
- Refund events.
- Controlled refund reasons.

Conceptually:

```text
payment
│
├── PaymentMethod
├── PaymentStatus
├── PaymentRefundReason
├── Payment
└── PaymentRefund
```

Payment references the applicable `sales.Transaction`.

Refund events preserve money returned against previously recorded Payments without rewriting the original Payment fact.

Payment state remains distinct from the commercial lifecycle state owned by `sales`.

---

### 3.6 Reference Domain

The `reference` domain owns shared reference identities and classifications whose meaning is not exclusive to a single business domain.

Its current responsibilities include:

- Country.
- AdministrativeDivision.
- City.
- Address.
- ContactType.

Conceptually:

```text
reference
│
├── Country
│      │
│      ▼
│   AdministrativeDivision
│      │
│      ▼
│     City
│      │
│      ▼
│   Address
│
└── ContactType
```

The geographic hierarchy provides authoritative shared location identities.

ContactType provides the controlled classification consumed by customer telephone contacts.

AtlasCommerce does not use `reference` as a generic container for every controlled value.

Domain-specific classifications remain with the domain that owns their business meaning.

---

### 3.7 Sales Domain

The `sales` domain owns the commercial transaction and the items purchased within that transaction.

Its current responsibilities include:

- Transaction.
- TransactionItem.
- TransactionChannel.
- TransactionStatus.

Conceptually:

```text
sales
│
├── TransactionChannel
├── TransactionStatus
├── Transaction
└── TransactionItem
```

Transaction represents the commercial purchase.

TransactionItem preserves the purchased ProductVariant, quantity, unit price, and unit discount applicable to that sale.

The sales domain preserves commercial facts independently from later catalog-price changes, payment events, inventory events, or shipment lifecycle changes.

---

### 3.8 Shipping Domain

The `shipping` domain owns the logistics process when a commercial Transaction requires physical delivery.

Its current responsibilities include:

- Shipment.
- ShipmentMethod.
- ShipmentStatus.

Conceptually:

```text
shipping
│
├── ShipmentMethod
├── ShipmentStatus
└── Shipment
```

A Shipment is conditional.

A Transaction completed directly at a physical store does not require a Shipment solely because the shipping domain exists.

Under the current model, a Transaction may have at most one Shipment.

The Shipment consumes the CustomerAddress selected for delivery without acquiring ownership of customer master data.

---

### 3.9 Domain Ownership

Each persisted entity has one primary owning domain.

Ownership determines which domain is responsible for:

- The entity's persistent meaning.
- Its lifecycle.
- Its domain-specific integrity.
- Its controlled classifications where applicable.
- Its evolution as part of the AtlasCommerce model.

A foreign key does not transfer ownership.

Conceptually:

```text
Owning Domain
     │
     └── persists authoritative entity
                │
                ▼
         Referencing Domain
                │
                └── consumes identity
```

For example:

- `catalog` owns ProductVariant; `sales` and `inventory` consume it.
- `customer` owns Customer; `sales` may consume it.
- `reference` owns Address; `customer` consumes it through CustomerAddress.
- `reference` owns ContactType; `customer` consumes it through CustomerContact.
- `customer` owns CustomerAddress; `shipping` consumes it.
- `sales` owns Transaction; `payment` and `shipping` consume it.
- `sales` owns TransactionItem; `inventory` may consume it for reservation and movement traceability.

Cross-domain relationships therefore integrate the operational model without duplicating authoritative identities.

---

### 3.10 Cross-Domain Model

The major implemented domain relationships can be represented conceptually as:

```text
                           metadata
                              │
                              │ technical governance
                              ▼

reference ───────────────► customer
   │                         │
   │                         │
   │                         ▼
   │                       sales ◄──────── catalog
   │                      /  │  \
   │                     /   │   \
   │                    ▼    ▼    ▼
   │              inventory payment shipping
   │                                    ▲
   └────────────────────────────────────┘
```

This diagram represents ownership and persistent interaction rather than execution order.

More specifically:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        └────────────────────────► shipping.Shipment

reference.ContactType
        │
        ▼
customer.CustomerContact


customer.Customer
        │
        ▼
sales.Transaction
        │
        ├─────────────────────────► payment.Payment
        │
        └─────────────────────────► shipping.Shipment
        │
        ▼
sales.TransactionItem
        │
        ├─────────────────────────► inventory.InventoryReservation
        └─────────────────────────► inventory.InventoryMovement

catalog.ProductVariant
        │
        ├─────────────────────────► sales.TransactionItem
        ├─────────────────────────► inventory.Inventory
        ├─────────────────────────► inventory.InventoryReservation
        └─────────────────────────► inventory.InventoryMovement
```

These relationships connect independently owned domain responsibilities while preserving a single relational operational model.

---

### 3.11 Domain Interaction Does Not Imply Universal Participation

A business process may involve several AtlasCommerce domains without requiring every domain to participate in every Transaction.

For example:

```text
Physical Store Transaction
        │
        ├── sales
        ├── payment
        ├── inventory
        └── no Shipment required
```

A transaction requiring delivery may additionally involve:

```text
Delivered Transaction
        │
        ├── sales
        ├── payment
        ├── inventory
        └── shipping
```

Likewise, a Transaction may exist without an associated registered Customer when the applicable business scenario permits an unidentified or guest buyer.

Domain existence therefore defines available responsibility, not mandatory participation in every commercial scenario.

---

### 3.12 Domain Model Principle

The AtlasCommerce domain structure follows these principles:

- Each entity has an explicit primary owning domain.
- Schemas represent logical responsibility boundaries.
- Cross-domain relationships are permitted when they represent legitimate persistent relationships.
- A foreign key does not transfer ownership.
- Authoritative identities must not be duplicated solely to avoid cross-domain relationships.
- Shared reference identities remain in `reference`.
- Domain-specific controlled classifications remain with their owning domains.
- ProductVariant is the principal catalog identity consumed by sales and inventory when the exact sellable item matters.
- Customer master data remains separate from commercial Transaction facts.
- Payment state remains separate from sales lifecycle state.
- Inventory state and history remain separate from commercial sale facts.
- Shipping participates only when the commercial Transaction requires physical delivery.
- A physical-store Transaction does not require Shipment.
- The current model permits at most one Shipment per Transaction.
- Domain interaction does not imply a mandatory execution sequence.
- Domain interaction does not imply that every domain participates in every Transaction.

The central principle is:

> **AtlasCommerce is one relational transactional model composed of explicitly owned domains whose relationships preserve operational integrity without obscuring responsibility.**

---

## 4. Metadata Domain

The `metadata` domain contains persistent technical metadata used to support AtlasCommerce database governance.

Unlike the business domains, `metadata` does not represent retail activity.

Its entities describe technical information about the database itself when that information must be explicitly governed, persisted, and validated as part of the AtlasCommerce implementation.

The current domain model is:

```text
metadata
│
└── TablePrefix
```

`metadata.TablePrefix` is the authoritative persistent registry of table-prefix assignments used by AtlasCommerce database objects.

---

### 4.1 TablePrefix

`metadata.TablePrefix` represents the registered prefix assigned to an AtlasCommerce table.

Table prefixes provide a stable technical identity used by database naming conventions, including column names and other database objects whose naming standards depend on the registered table prefix.

Conceptually, each registry entry associates:

```text
Schema
   +
Table
   +
Registered Prefix
   +
Lifecycle State
```

The registry allows prefix ownership to remain explicit and independently governed rather than being inferred from current object names.

---

### 4.2 Prefix Assignment

Each AtlasCommerce table governed by the prefix standard has one registered prefix assignment.

A prefix identifies the table for naming-governance purposes.

The relationship may be represented conceptually as:

```text
AtlasCommerce Table
        │
        │  governed by
        ▼
metadata.TablePrefix
        │
        ▼
Registered Prefix
```

The prefix is not a business identifier and does not participate in the business meaning of the entity represented by the table.

It is technical metadata used by the database-governance model.

Prefix assignment must remain deterministic and unambiguous.

A registered prefix must identify only the table to which that prefix has been assigned.

---

### 4.3 Schema and Table Identity

A TablePrefix entry identifies the table associated with the prefix through its schema and table identity.

This distinction is required because AtlasCommerce organizes entities across multiple schemas and table names must be interpreted within their owning schema.

Conceptually:

```text
Schema + Table
      │
      ▼
Registered Table Identity
      │
      ▼
Prefix Assignment
```

The registry therefore preserves the relationship between:

- Owning schema.
- Table name.
- Registered prefix.

The complete technical definition and validation rules governing these values are defined by the AtlasCommerce Database Standards and implemented deployment.

---

### 4.4 Prefix Lifecycle

Prefix assignments have historical significance.

A prefix that has been assigned to a table becomes part of the technical history of the AtlasCommerce database.

If an assignment is retired, its historical identity must remain distinguishable from active assignments.

The lifecycle may therefore be represented conceptually as:

```text
Registered Prefix
       │
       ├── Active
       │     └── Current table-prefix assignment
       │
       └── Inactive
             └── Historical or retired assignment
```

An inactive assignment remains part of the registry.

Retiring a prefix does not make that prefix available for reassignment to another table.

This prevents a technical identifier that historically represented one database object from later acquiring a different meaning.

---

### 4.5 Prefix Immutability

The identity represented by a registered prefix is historically stable.

Once a prefix has been assigned, its historical association must not be rewritten merely because:

- A table is no longer active.
- A database object is retired.
- A newer table is introduced.
- A different prefix would appear more convenient.
- Reordering or renaming would improve visual consistency.

If the model evolves in a way that requires a new technical identity, the change must preserve the historical meaning of previous assignments.

This principle allows database scripts, documentation, historical artifacts, and technical evidence to continue interpreting a prefix consistently over time.

---

### 4.6 Governance Responsibility

`metadata.TablePrefix` is authoritative for current and historical prefix assignments.

Other AtlasCommerce artifacts may consume or display prefix information, but they must not establish independent competing prefix registries.

This includes:

- Database object definitions.
- Deployment scripts.
- Validation scripts.
- Database Standards.
- Domain documentation.
- Technical inventories.

Those artifacts may reference registered prefixes when required by their responsibility.

The complete registry remains owned by `metadata.TablePrefix`.

This prevents documentation or deployment artifacts from becoming independent sources of prefix ownership that may later diverge from the implemented database.

---

### 4.7 Domain Boundary

The `metadata` domain must remain limited to technical metadata whose persistent governance belongs to the database model.

A business classification must not be placed in `metadata` merely because it contains controlled values.

Likewise, domain-specific statuses, types, reasons, or classifications remain within the business or reference domain responsible for their meaning.

The distinction is:

```text
Technical Database Governance
            │
            ▼
         metadata

Business or Shared Operational Meaning
            │
            ▼
Business Domain / reference
```

This boundary prevents technical governance metadata from becoming a generic repository for controlled business data.

---

### 4.8 Metadata Domain Principle

The `metadata` domain exists to make technical database governance explicit and persistent where AtlasCommerce requires it.

For the current model:

- `TablePrefix` owns table-prefix registration.
- Prefix assignments identify technical database objects, not business entities.
- Schema and table identity determine prefix ownership.
- Prefixes remain historically stable.
- Retired assignments remain preserved.
- A retired prefix must not acquire a new table identity.
- Other artifacts consume the registry without becoming competing sources of prefix ownership.

The domain may evolve if future database-governance requirements justify additional persistent metadata entities.

Such entities must have a clear technical governance responsibility and must not be introduced merely because a controlled value requires storage.

---

## 5. Catalog Domain

The `catalog` domain owns the structures that define the commercial product catalog.

Its responsibilities include:

- brands;

- categories and category hierarchy;

- products;

- product classification;

- product media;

- product variants;

- product attributes;

- controlled attribute values;

- variant characteristics;

- commercial pricing.

The catalog defines **what can be sold and how it is commercially represented**.

It does not own transactional sales facts, inventory quantities, payment execution, or shipping execution.

---

### 5.1 Brand

`catalog.Brand` represents a commercial brand associated with products.

A brand provides a reusable business identity that can be referenced by multiple products.

Brand information belongs to the catalog because it describes the commercial identity of a product rather than a specific sale or inventory position.

---

### 5.2 Category

`catalog.Category` represents a catalog classification used to organize products.

Categories support hierarchical organization through a self-referencing relationship, allowing a category to have a parent category.

This structure supports classifications such as:

- Makeup

  - Face

  - Eyes

  - Lips

The hierarchy is part of the catalog model and does not depend on transactional activity.

---

### 5.3 Product

`catalog.Product` represents the conceptual commercial product.

A product identifies the item at the level shared by its sellable variants.

Examples of information owned at the product level include:

- brand association;

- product name;

- catalog identity;

- lifecycle status.

A Product is not necessarily the exact sellable unit.

The specific sellable representation is modeled by `catalog.ProductVariant`.

---

### 5.4 Product Category

`catalog.ProductCategory` represents the association between a Product and a Category.

The relationship is modeled separately because a product may participate in more than one catalog classification.

This avoids embedding classification directly into the Product entity and allows catalog organization to evolve independently from the product definition.

---

### 5.5 Product Image

`catalog.ProductImage` represents product media associated with the catalog.

Images are part of the commercial representation of a product and therefore belong to the `catalog` domain.

The entity allows media information to remain independent from the core Product definition while still being governed as part of the product catalog.

Product media does not represent transactional evidence and is not owned by sales, inventory, payment, or shipping.

---

### 5.6 Product Variant

`catalog.ProductVariant` represents a specific sellable variation of a Product.

A Product may have multiple variants representing commercially distinct combinations such as:

- color;

- shade;

- size;

- volume;

- other controlled characteristics.

The Product defines the common commercial identity.

The ProductVariant defines the specific item that can participate in operational processes such as sales and inventory.

For this reason, transactional and inventory structures reference ProductVariant rather than only Product.

---

### 5.7 Product Attribute

`catalog.ProductAttribute` defines a characteristic that may be used to distinguish or describe ProductVariants.

Examples include:

- COLOR;

- SHADE;

- SIZE;

- VOLUME.

An attribute defines the characteristic itself.

The allowed values for controlled attributes are represented separately by `catalog.ProductAttributeValue`.

---

### 5.8 Product Attribute Value

`catalog.ProductAttributeValue` represents a controlled value associated with a ProductAttribute.

Examples include:

- COLOR → RED;

- COLOR → BLACK;

- SIZE → SMALL;

- SIZE → MEDIUM.

Separating attributes from their controlled values provides a consistent catalog vocabulary and prevents arbitrary representations of the same commercial characteristic.

---

### 5.9 Product Variant Attribute Value

`catalog.ProductVariantAttributeValue` associates a ProductVariant with a controlled ProductAttributeValue.

This structure describes the characteristics that distinguish one variant from another.

For example, a ProductVariant may be associated with:

- COLOR → RED;

- SIZE → MEDIUM.

`ProductVariantAttributeValue` references the applicable `ProductAttributeValue`.

The corresponding `ProductAttribute` is determined through that controlled value rather than through a separate direct relationship from `ProductVariantAttributeValue`.

Conceptually:

```text
ProductVariant
      │
      ▼
ProductVariantAttributeValue
      │
      ▼
ProductAttributeValue
      │
      ▼
ProductAttribute
```

The relationship allows variant characteristics to remain normalized and reusable across the catalog.

---

### 5.10 Product Variant Price

`catalog.ProductVariantPrice` represents commercial pricing associated with a ProductVariant.

Pricing is maintained separately from the ProductVariant definition because commercial price is a distinct business concern and may evolve independently from the identity of the sellable variant.

The catalog owns the commercial price definition.

A completed sale does not depend on the current catalog price to preserve its financial history.

The price actually applied to a sale is persisted by the sales domain as part of the transaction item.

This separation ensures that future catalog price changes do not alter historical transactions.

---

### 5.11 Product and ProductVariant Boundary

The distinction between Product and ProductVariant is fundamental to the catalog model.

A Product represents the shared commercial concept.

A ProductVariant represents the specific sellable form of that product.

Operational domains therefore reference the variant when the exact commercial item matters.

For example:

- inventory is maintained for ProductVariant;

- sales TransactionItem references ProductVariant;

- variant characteristics describe ProductVariant;

- commercial pricing is associated with ProductVariant.

This prevents ambiguity when different variations of the same product have different inventory positions, characteristics, or prices.

---

### 5.12 Catalog Ownership Boundary

The `catalog` domain owns product definition and commercial representation.

It owns:

- Brand;

- Category;

- Product;

- ProductCategory;

- ProductImage;

- ProductVariant;

- ProductAttribute;

- ProductAttributeValue;

- ProductVariantAttributeValue;

- ProductVariantPrice.

It does not own:

- quantities currently available in inventory;

- inventory reservations;

- inventory movements;

- completed sales;

- prices historically applied to completed sales;

- payment execution;

- shipment execution.

Other domains may reference catalog entities without assuming ownership of catalog master data.

---

### 5.13 Cross-Domain Usage

The catalog provides master data consumed by operational domains.

The principal operational boundary is `catalog.ProductVariant`.

Conceptually:

```text
Product
   │
   ├── ProductImage
   │
   ├── ProductCategory ── Category
   │
   └── ProductVariant
          │
          ├── ProductVariantAttributeValue
          │        │
          │        └── ProductAttributeValue
          │                  │
          │                  └── ProductAttribute
          │
          └── ProductVariantPrice
```

Operational domains may then reference the sellable variant:

```text
catalog.ProductVariant
        │
        ├── sales.TransactionItem
        │
        └── inventory structures
```

These references do not transfer ownership of ProductVariant to those domains.

---

### 5.14 Catalog Domain Principle

The Catalog Domain follows one central principle:

> **The catalog defines what can be sold and how it is commercially represented; operational domains record what happens to those sellable items.**

`Brand`, `Category`, `Product`, `ProductCategory`, `ProductImage`, `ProductVariant`, `ProductAttribute`, `ProductAttributeValue`, `ProductVariantAttributeValue`, and `ProductVariantPrice` together describe the commercial catalog.

Operational facts remain outside that boundary.

Inventory determines quantities and movements.

Sales preserves what was actually sold, including the price applied at the time of the transaction.

Payment records financial execution.

Shipping records fulfillment.

This separation allows the catalog to evolve without rewriting historical operational facts.

---

## 6. Customer Domain

The `customer` domain owns the persistent identities and master data associated with AtlasCommerce customers.

The domain separates customer identity from documents, contacts, email addresses, customer addresses, and the controlled classifications owned by the customer domain.

Shared reference identities remain owned by the `reference` domain when their meaning is not exclusive to customer management.

The principal customer entities can be represented conceptually as:

```text
customer
│
├── CustomerType
│
├── Customer
│   ├── CustomerDocument
│   │       └── CustomerDocumentType
│   │
│   ├── CustomerContact
│   │       └── reference.ContactType
│   │
│   ├── CustomerEmail
│   │
│   └── CustomerAddress
│           └── reference.Address
│
└── Customer-owned controlled classifications
```

This separation allows each type of customer information to follow the lifecycle and integrity rules appropriate to its meaning without accumulating unrelated state in a single Customer entity.

---

### 6.1 CustomerType

`customer.CustomerType` represents the controlled classification of a Customer according to the type of customer identity represented by the model.

Conceptually:

```text
CustomerType
     │
     └── 1:N ──► Customer
```

A Customer belongs to the applicable CustomerType.

The controlled classification prevents customer type from being represented through unrestricted or inconsistent textual values.

The current controlled values distinguish the customer classifications supported by AtlasCommerce without requiring separate primary customer entities for each type.

---

### 6.2 Customer

`customer.Customer` represents the persistent identity of a registered customer in AtlasCommerce.

Customer is the central entity of the customer domain.

Conceptually:

```text
CustomerType
     │
     ▼
 Customer
     │
     ├── CustomerDocument
     ├── CustomerContact
     ├── CustomerEmail
     └── CustomerAddress
```

Customer contains the state that belongs directly to the registered customer identity.

Information with a distinct meaning or lifecycle is modeled separately rather than being accumulated in the Customer row.

This includes:

- Identification documents.
- Telephone contact values.
- Email addresses.
- Customer-address relationships.

A Customer may participate in commercial transactions through relationships owned by the applicable transactional domain.

The absence of a registered Customer relationship does not make a commercial transaction invalid when the business scenario permits an unidentified or guest buyer.

The `sales` domain therefore owns the commercial Transaction and may optionally associate that Transaction with a registered Customer.

---

### 6.3 CustomerDocument

`customer.CustomerDocument` represents an identification document associated with a Customer.

Conceptually:

```text
Customer
   │
   └── 1:N ──► CustomerDocument
                       │
                       └──► CustomerDocumentType
```

A Customer may have multiple associated documents.

CustomerDocument owns the individual document information associated with the Customer.

Document classification is represented through `customer.CustomerDocumentType` rather than unrestricted text.

The document relationship remains part of customer master data and must preserve the meaning of the identification information represented by the implemented model.

Whether a particular document is acceptable for a specific business operation may depend on business, regulatory, or process context and is not automatically equivalent to the persistent validity of the CustomerDocument entity.

---

### 6.4 CustomerDocumentType

`customer.CustomerDocumentType` represents the controlled classification of identification-document types supported by AtlasCommerce.

Conceptually:

```text
CustomerDocumentType
          │
          └── 1:N ──► CustomerDocument
```

The controlled classification prevents equivalent document types from being represented through inconsistent textual values.

The current implementation supports controlled document types appropriate to the AtlasCommerce customer model.

CustomerDocumentType owns the classification.

CustomerDocument owns the individual document associated with a Customer.

The existence of a controlled document type does not by itself determine whether that document may be accepted in every business or regulatory process.

---

### 6.5 CustomerContact

`customer.CustomerContact` represents a telephone contact value associated with a Customer.

Conceptually:

```text
customer.Customer
        │
        └── 1:N ──► customer.CustomerContact
                              │
                              └──► reference.ContactType
```

CustomerContact persists the contact value directly as part of the customer relationship.

The current model does not introduce an independent reusable `Contact` entity.

The contact type is represented by `reference.ContactType`, which provides the shared controlled classification required to interpret the stored contact value.

A Customer may have multiple CustomerContact records.

CustomerContact also preserves operational state indicating whether the contact is active and whether it is the primary active contact for the Customer.

The implemented integrity model allows at most one primary active CustomerContact for a Customer.

A primary contact must also be active.

Telephone-format validation belongs to the application layer rather than being encoded as a database format constraint.

---

### 6.6 CustomerEmail

`customer.CustomerEmail` represents an email address associated with a Customer.

Conceptually:

```text
customer.Customer
        │
        └── 1:N ──► customer.CustomerEmail
```

A Customer may have multiple email addresses.

CustomerEmail preserves whether an email relationship is active and whether it is the primary active email for the Customer.

The implemented integrity model allows at most one primary active CustomerEmail for a Customer.

A primary email must also be active.

Email values are not globally unique in AtlasCommerce.

The same email address may legitimately be associated with more than one Customer.

This supports legitimate business scenarios in which multiple customer identities use the same email address.

Email-format validation belongs to the application layer rather than being encoded as a database format constraint.

---

### 6.7 CustomerAddress

`customer.CustomerAddress` represents the relationship between a Customer and an address identity owned by the `reference` domain.

Conceptually:

```text
customer.Customer
        │
        ▼
customer.CustomerAddress
        │
        ▼
reference.Address
```

The customer domain owns the relationship between the Customer and the address.

The `reference` domain owns the shared Address identity and its geographic structure.

A Customer may have multiple CustomerAddress records.

CustomerAddress preserves the lifecycle of the customer's relationship with an address, including the operational state required by the implemented model.

The customer domain must not duplicate the authoritative geographic hierarchy merely because customer addresses consume it.

---

### 6.8 Customer and Reference Boundary

Customer master data consumes shared reference identities without acquiring ownership of them.

Conceptually:

```text
reference
│
├── Country
├── AdministrativeDivision
├── City
├── Address
└── ContactType
        │
        ▼
customer
```

Examples include:

- `customer.CustomerAddress` consuming `reference.Address`.
- `customer.CustomerContact` consuming `reference.ContactType`.

The `reference` domain remains responsible for the shared identity.

The `customer` domain remains responsible for the customer-specific relationship or value that consumes that identity.

This prevents shared reference data from being duplicated inside the customer domain.

---

### 6.9 Contact and Email Responsibilities

Telephone contacts and email addresses are represented by separate customer entities because they have different classification and operational requirements.

Conceptually:

```text
Customer
   │
   ├── CustomerContact
   │       └── ContactType
   │
   └── CustomerEmail
```

`CustomerContact` uses `reference.ContactType` to distinguish the supported telephone-contact classifications.

`CustomerEmail` does not require ContactType because email is represented by its own dedicated entity.

Both structures may contain multiple records for a Customer while independently enforcing the applicable primary-active relationship rule.

This separation avoids introducing a generic contact abstraction when the implemented customer model does not require one.

---

### 6.10 Customer and Sales

Customer identity and commercial transaction identity remain separate responsibilities.

Conceptually:

```text
customer.Customer
        │
        │ optional commercial relationship
        ▼
sales.Transaction
```

A registered Customer may participate in multiple Transactions.

A Transaction may reference a Customer when an identified registered customer is associated with the purchase.

However, the commercial model also permits scenarios in which no registered Customer is associated with the Transaction.

The absence of a Customer relationship must therefore not automatically be interpreted as invalid persisted state.

This is particularly relevant to scenarios such as:

- Guest transactions.
- Unidentified physical-store transactions.

`sales.Transaction` owns the commercial fact.

`customer.Customer` owns the registered customer identity.

The optional relationship between them preserves that distinction.

---

### 6.11 Customer and Shipping

When fulfillment requires a Shipment, the shipping domain consumes a customer-owned address relationship.

Conceptually:

```text
customer.Customer
        │
        ▼
customer.CustomerAddress
        │
        ▼
shipping.Shipment
```

The Shipment references the CustomerAddress applicable to that fulfillment operation.

The shipping domain does not become the owner of CustomerAddress merely because it consumes that identity.

The customer domain remains responsible for the customer-address relationship.

The reference domain remains responsible for the underlying shared Address identity.

This preserves the ownership boundary between:

- Customer identity.
- Customer-address relationship.
- Shared geographic/address identity.
- Shipment fulfillment.

---

### 6.12 Customer Relationship Lifecycle

Customer-related information may have a lifecycle independent from the Customer identity itself.

AtlasCommerce therefore represents lifecycle state at the structure responsible for that relationship.

Examples include:

```text
Customer
   │
   ├── CustomerContact
   │       ├── active / inactive
   │       └── primary / non-primary
   │
   ├── CustomerEmail
   │       ├── active / inactive
   │       └── primary / non-primary
   │
   └── CustomerAddress
           └── relationship lifecycle
```

Changing the operational status of one customer relationship does not require changing the identity of the Customer.

Likewise, deactivating one contact, email, or address relationship must not imply deletion of the Customer or unrelated customer master data.

Lifecycle state remains attached to the entity or relationship whose operational meaning it represents.

---

### 6.13 Customer Data Preservation

Customer master data contains information whose lifecycle may extend beyond its current active use.

AtlasCommerce distinguishes between:

- Registered customer identity.
- Identification documents.
- Telephone contact relationships.
- Email relationships.
- Address relationships.
- Shared reference identities.
- Commercial facts that consume customer-owned identities.

Where historical preservation is required by the implemented lifecycle, earlier customer relationships must not be physically removed merely because they are no longer current.

Operational lifecycle state allows current relationships to be distinguished from relationships retained for historical or traceability purposes.

Commercial and fulfillment facts that reference customer-owned identities must preserve their historical meaning independently from later changes to current customer master data.

---

### 6.14 Customer Domain Principle

The `customer` domain separates registered customer identity from the master-data structures and relationships associated with that identity.

For the current AtlasCommerce model:

- CustomerType provides controlled customer classification.
- Customer represents registered customer identity.
- CustomerDocument represents identification documents associated with a Customer.
- CustomerDocumentType provides controlled document classification.
- CustomerContact represents telephone contact information associated with a Customer.
- `reference.ContactType` provides the controlled classification used by CustomerContact.
- CustomerEmail represents email information associated with a Customer.
- CustomerAddress represents the Customer's relationship with a shared Address identity.
- `reference.Address` and its geographic hierarchy remain owned by the `reference` domain.
- The current model does not introduce an independent reusable Contact entity.
- Telephone and email format validation remain application responsibilities.
- A Customer may have multiple contacts, emails, addresses, and documents according to the applicable model rules.
- Primary-active integrity is enforced independently for CustomerContact and CustomerEmail.
- Email addresses are not globally unique across Customers.
- Commercial Transactions may reference a registered Customer without requiring every Transaction to have one.
- Shipping may consume a CustomerAddress without acquiring ownership of customer master data.
- Customer relationship lifecycle must remain distinguishable from Customer identity.

The customer domain may evolve as additional customer-related requirements are introduced, but new structures must preserve explicit ownership and lifecycle responsibility rather than expanding Customer into a single entity containing every form of customer information.

---

## 7. Inventory Domain

The `inventory` domain owns the persistent operational state required to represent stock position, stock movements, movement context, and inventory reservations within AtlasCommerce.

The domain separates current inventory state from the historical events that explain how that state was reached.

It also separates physical inventory from temporary commercial reservations.

The principal inventory entities can be represented conceptually as:

```text
inventory
│
├── Inventory
│
├── InventoryMovementReason
│
├── InventoryMovement
│   └── InventoryMovementNote
│
├── InventoryReservationStatus
│
└── InventoryReservation
```

The inventory domain consumes sellable product identities owned by `catalog` and, where applicable, commercial transaction-item identities owned by `sales`.

These relationships do not transfer ownership of those entities to `inventory`.

---

### 7.1 Inventory

`inventory.Inventory` represents the current operational stock position of a Product Variant.

Conceptually:

```text
catalog.ProductVariant
          │
          ▼
inventory.Inventory
```

Inventory is current-state operational data.

It exists so that AtlasCommerce can determine the physical stock position without reconstructing that state from the complete inventory-movement history for every operational request.

The implemented inventory state distinguishes between:

- Physical quantity on hand.
- Quantity currently reserved.

Conceptually:

```text
Quantity On Hand
       │
       ├── Reserved Quantity
       │
       └── Unreserved Quantity
```

The reserved quantity is part of the operational inventory state because reserved units remain physically present while temporarily unavailable for competing commercial operations.

The relationship between physical and reserved quantities must remain valid according to the integrity rules defined by the implemented database model.

---

### 7.2 Inventory Identity

Inventory is maintained for the sellable Product Variant represented by the catalog domain.

Conceptually:

```text
catalog.Product
      │
      ▼
catalog.ProductVariant
      │
      ▼
inventory.Inventory
```

Inventory does not belong directly to Product because Product represents commercial identity while ProductVariant represents the specific sellable item.

The inventory domain therefore consumes `catalog.ProductVariant` as the product identity relevant to stock control.

The same Product may consequently have multiple independently controlled inventory positions through its different Product Variants.

The catalog domain remains responsible for the Product Variant identity.

The inventory domain remains responsible for its stock state.

---

### 7.3 Current State and Movement History

AtlasCommerce intentionally separates current inventory state from inventory movement history.

Conceptually:

```text
InventoryMovement History
          │
          │ explains
          ▼
      Inventory
          │
          └── Current stock state
```

`Inventory` answers questions about the current operational stock position.

`InventoryMovement` preserves the historical facts that changed that position.

This controlled duplication serves different responsibilities:

- Current-state access supports operational efficiency.
- Movement history supports traceability and investigation.

The current quantity must not become an unexplained value disconnected from the movements responsible for inventory changes.

Operations that change physical inventory must preserve the corresponding historical movement according to the implemented business and transactional rules.

---

### 7.4 InventoryMovementReason

`inventory.InventoryMovementReason` represents the controlled reason for an inventory movement.

Conceptually:

```text
InventoryMovementReason
          │
          └── 1:N ──► InventoryMovement
```

Movement reasons provide semantic meaning to changes in physical inventory.

The implemented controlled domain distinguishes inventory events such as:

```text
PURCHASE_RECEIPT
SALE
CUSTOMER_RETURN
DAMAGED_IN_TRANSIT
DAMAGED_INTERNAL
LOSS_IN_TRANSIT
LOSS_INTERNAL
FOUND_INTERNAL
INVENTORY_ADJUSTMENT_IN
INVENTORY_ADJUSTMENT_OUT
```

These values represent controlled operational meanings and must not be replaced by unrestricted free-text descriptions.

Separating the movement reason from InventoryMovement allows movement semantics to remain consistent across the inventory history.

---

### 7.5 InventoryMovement

`inventory.InventoryMovement` represents a historical event that changes physical inventory.

Conceptually:

```text
InventoryMovementReason
          │
          ▼
InventoryMovement
          │
          ├──► catalog.ProductVariant
          │
          ├──► sales.TransactionItem
          │        when applicable
          │
          └──► InventoryMovementNote
                   when applicable
```

An InventoryMovement identifies:

- The Product Variant affected.
- The reason for the movement.
- The quantity change.
- When the movement occurred.
- The related commercial transaction item when the movement originates from an applicable sales event.

InventoryMovement is historical operational evidence.

A movement that already occurred must not be destructively rewritten merely because a later event compensates for its effect.

When an inventory event must be reversed or compensated, the correction must preserve the original historical fact and represent the new inventory effect through the appropriate subsequent movement.

---

### 7.6 Movement Quantity Semantics

InventoryMovement uses signed quantity semantics to represent the direction of the physical inventory change.

Conceptually:

```text
Positive Quantity
      │
      └── Inventory enters physical stock

Negative Quantity
      │
      └── Inventory leaves physical stock
```

Examples include:

```text
PURCHASE_RECEIPT          +
CUSTOMER_RETURN           +
FOUND_INTERNAL            +
INVENTORY_ADJUSTMENT_IN   +

SALE                      -
DAMAGED_IN_TRANSIT        -
DAMAGED_INTERNAL          -
LOSS_IN_TRANSIT           -
LOSS_INTERNAL             -
INVENTORY_ADJUSTMENT_OUT  -
```

The movement reason communicates why the inventory changed.

The quantity sign communicates the direction of the physical change.

These responsibilities must remain semantically consistent.

---

### 7.7 InventoryMovement and Sales

An inventory movement may be associated with a `sales.TransactionItem` when the inventory event has a direct commercial origin.

Conceptually:

```text
sales.Transaction
       │
       ▼
sales.TransactionItem
       │
       ▼
inventory.InventoryMovement
```

This relationship provides traceability between the commercial fact and the corresponding inventory effect.

Not every inventory movement originates from a sale.

For example, inventory may change because of:

- Purchase receipt.
- Damage.
- Loss.
- Internal discovery.
- Inventory adjustment.

The TransactionItem relationship is therefore applicable only when the movement semantics require commercial traceability.

The absence of a TransactionItem relationship on a movement whose reason does not require one must not automatically be interpreted as missing data.

---

### 7.8 InventoryMovementNote

`inventory.InventoryMovementNote` represents optional descriptive context associated with an InventoryMovement.

Conceptually:

```text
InventoryMovement
       │
       └── 0..1 ──► InventoryMovementNote
```

The note is separated from the main InventoryMovement entity because descriptive text is not required for normal inventory processing.

This preserves a narrow high-volume movement structure while allowing additional context to be retained when an individual movement requires explanation.

InventoryMovementNote does not replace the controlled InventoryMovementReason.

The reason provides standardized operational classification.

The note provides optional contextual detail.

Conceptually:

```text
InventoryMovementReason
       │
       └── Why the movement occurred
           in controlled terms

InventoryMovementNote
       │
       └── Optional additional context
```

---

### 7.9 Inventory Reservation

`inventory.InventoryReservation` represents a temporary allocation of inventory to a specific `sales.TransactionItem`.

Conceptually:

```text
sales.TransactionItem
          │
          ▼
InventoryReservation
          │
          ├──► catalog.ProductVariant
          │
          └──► InventoryReservationStatus
```

A reservation protects inventory intended for an in-progress commercial transaction without representing a physical inventory movement.

This distinction is fundamental:

```text
Reservation
    │
    └── Changes inventory availability

InventoryMovement
    │
    └── Changes physical inventory
```

Reserved inventory remains physically present.

The reservation temporarily prevents the reserved quantity from being treated as available for competing operations according to the applicable business process.

---

### 7.10 InventoryReservationStatus

`inventory.InventoryReservationStatus` represents the controlled lifecycle state of an InventoryReservation.

Conceptually:

```text
InventoryReservationStatus
            │
            └── 1:N ──► InventoryReservation
```

The status communicates the current lifecycle state of the reservation rather than the state of the associated TransactionItem or Product Variant.

Reservation lifecycle responsibility belongs to the inventory domain.

A reservation may progress through the lifecycle defined by the implemented controlled values and business rules.

Closing, consuming, releasing, or expiring a reservation must not require the historical reservation record to be physically deleted.

The reservation remains evidence that inventory was allocated to a commercial operation during a particular period.

---

### 7.11 Reservation Time Boundary

An InventoryReservation has an explicit temporal lifecycle.

Conceptually:

```text
reserved_at
     │
     ▼
Reservation Active
     │
     ├────────► expires_at
     │
     └────────► closed_at
```

`reserved_at` identifies when the reservation began.

`expires_at` identifies the expiration boundary established for the reservation.

`closed_at`, when applicable, identifies when the reservation lifecycle was closed.

These values preserve different temporal facts and must not be treated as interchangeable.

The temporal relationships between them form part of the persisted integrity of the reservation.

---

### 7.12 Reservation and Physical Inventory

Reservation does not itself represent removal of physical inventory.

Conceptually:

```text
Physical Inventory
       │
       ├── Unreserved
       │
       └── Reserved
              │
              └── InventoryReservation
```

For example:

```text
Quantity on hand : 10
Quantity reserved:  3
----------------------
Unreserved        :  7
```

The three reserved units remain part of the physical quantity on hand.

A later business event may cause physical inventory to change and create the corresponding InventoryMovement.

Until such an event occurs, the reservation represents allocation rather than physical removal.

This distinction prevents AtlasCommerce from treating temporary reservation and completed stock consumption as the same inventory event.

---

### 7.13 Reservation and TransactionItem

InventoryReservation belongs to a specific commercial transaction item.

Conceptually:

```text
sales.Transaction
       │
       ▼
sales.TransactionItem
       │
       ▼
inventory.InventoryReservation
```

The relationship preserves which purchased item caused the inventory allocation.

Because the applicable sales structures participate in the partition-aware transactional architecture, the complete implemented relationship may include the temporal component required by the referenced TransactionItem key.

Conceptually:

```text
TransactionItem Identity
          +
Transaction Time Component
          │
          ▼
InventoryReservation
```

The temporal component supports the complete implemented relational and partition-aware definition.

It does not create a separate business identity for the reservation.

---

### 7.14 Reservation and ProductVariant

InventoryReservation also identifies the Product Variant whose inventory is being reserved.

Conceptually:

```text
sales.TransactionItem
        │
        └──► catalog.ProductVariant
                       │
                       ▼
             InventoryReservation
```

The reservation must remain semantically compatible with the Product Variant represented by the related commercial transaction item.

This relationship allows the inventory domain to make the reserved stock identity explicit while preserving traceability to the commercial operation responsible for the reservation.

The Product Variant remains owned by `catalog`.

The TransactionItem remains owned by `sales`.

The reservation remains owned by `inventory`.

---

### 7.15 Inventory Consistency

The inventory domain contains multiple representations that must remain mutually consistent.

Conceptually:

```text
                  Inventory
                 Current State
                 /           \
                /             \
               ▼               ▼
InventoryReservation     InventoryMovement
 Allocation State        Historical Change
```

These structures serve different responsibilities:

- `Inventory` represents current physical and reserved quantities.
- `InventoryReservation` represents temporary allocations and their lifecycle.
- `InventoryMovement` represents historical changes to physical inventory.

The existence of separate structures must not allow contradictory operational state.

For example:

- Reserved quantity must remain compatible with physical quantity.
- Reservation lifecycle changes must remain consistent with the current reserved state.
- Physical inventory changes must remain traceable through movement history.
- A reservation must not be interpreted as a physical movement merely because it affects availability.

Operations that modify multiple inventory responsibilities as one business event must preserve transactional consistency across the affected state.

---

### 7.16 Inventory History Preservation

Inventory history must remain available after the current operational state changes.

This applies to both:

```text
InventoryMovement
        │
        └── Historical physical inventory event

InventoryReservation
        │
        └── Historical allocation lifecycle
```

A completed, expired, released, or otherwise closed reservation must not be physically deleted merely because it no longer affects current availability.

Likewise, an inventory movement must not be deleted or rewritten merely because a later movement compensates for it.

The current state may change.

The historical facts explaining how that state evolved must remain distinguishable from the current state.

---

### 7.17 Inventory Domain Boundaries

The inventory domain owns stock state and stock-allocation responsibility.

It does not own:

- Product commercial identity.
- Sales transaction identity.
- Payment lifecycle.
- Shipping lifecycle.

Conceptually:

```text
catalog
   │
   └── ProductVariant
           │
           ▼
       inventory
       /       \
      /         \
     ▼           ▼
Inventory   InventoryReservation
                 │
                 └──► sales.TransactionItem

payment
   │
   └── Financial responsibility

shipping
   │
   └── Fulfillment responsibility
```

Events in other domains may cause inventory operations, but those events do not transfer ownership of inventory state.

For example, a commercial event may require inventory reservation or physical stock consumption.

A return may require inventory to re-enter stock.

A logistics loss may require inventory to leave the recognized physical position.

The inventory domain records the inventory consequence while the originating domain retains responsibility for the business event that caused it.

---

### 7.18 Inventory Domain Principle

The `inventory` domain separates current stock state, temporary allocation, and historical physical movement into explicit responsibilities.

For the current AtlasCommerce model:

- Inventory represents the current stock position of a Product Variant.
- Physical quantity and reserved quantity remain distinct concepts.
- InventoryMovement preserves historical changes to physical inventory.
- InventoryMovementReason provides controlled semantic classification for those movements.
- Signed movement quantities represent the direction of physical stock changes.
- InventoryMovementNote preserves optional descriptive context without widening the primary movement structure.
- InventoryReservation represents temporary allocation to a TransactionItem.
- InventoryReservationStatus owns the reservation lifecycle classification.
- Reservation changes availability without itself representing physical stock removal.
- Reservation history remains preserved after the reservation is closed.
- Physical inventory changes remain traceable through InventoryMovement.
- Commercial identities consumed by inventory remain owned by their respective domains.
- Inventory state, reservations, and movement history must remain transactionally and semantically consistent.

The inventory domain may evolve as additional stock-management requirements are introduced, but future structures must preserve the distinction between physical inventory, availability allocation, and the historical events that explain inventory change.

---

## 8. Payment Domain

The `payment` domain owns the persistent financial state associated with payments and refunds within AtlasCommerce.

The domain records how money is attempted, approved, cancelled, declined, and returned in relation to commercial transactions.

Payment responsibility is intentionally separated from the commercial lifecycle represented by `sales`.

A sales transaction establishes the commercial obligation.

The payment domain records the financial events associated with satisfying or reversing that obligation.

The principal payment entities can be represented conceptually as:

```text
payment
│
├── PaymentMethod
├── PaymentStatus
├── Payment
├── PaymentRefundReason
└── PaymentRefund
```

The payment domain consumes transaction identities owned by `sales`.

This relationship does not transfer ownership of the sales transaction to `payment`.

---

### 8.1 Payment

`payment.Payment` represents a financial payment attempt associated with a `sales.Transaction`.

Conceptually:

```text
sales.Transaction
       │
       └── 1:N ──► payment.Payment
```

A Transaction may have multiple Payment records.

This allows the financial model to represent scenarios such as:

- Multiple payment attempts.
- A declined attempt followed by an approved attempt.
- Split payments.
- Payments using different payment methods.
- Financial lifecycle changes that must remain historically distinguishable.

Payment records preserve the financial facts that actually occurred.

A previous payment attempt must not be destructively overwritten merely because a later attempt succeeds or because a later financial event changes the effective financial position of the transaction.

---

### 8.2 Payment and Transaction

Payment belongs to a commercial Transaction.

Conceptually:

```text
sales.Transaction
       │
       ▼
payment.Payment
```

The sales domain owns the commercial transaction.

The payment domain owns the financial payment state associated with that transaction.

These responsibilities must remain separate.

A Payment must not become the authoritative representation of the commercial lifecycle of a Transaction.

Likewise, the Transaction must not duplicate the detailed financial lifecycle already represented by Payment.

Because `sales.Transaction` participates in the partition-aware transactional architecture, the complete implemented relationship includes the temporal component required by the referenced Transaction key.

Conceptually:

```text
Transaction Identity
        +
Transaction Time Component
        │
        ▼
      Payment
```

The temporal component supports the complete implemented relational and partition-aware definition.

It does not represent an independent financial or business identity.

---

### 8.3 PaymentMethod

`payment.PaymentMethod` represents the controlled method through which a Payment is performed.

Conceptually:

```text
PaymentMethod
      │
      └── 1:N ──► Payment
```

The implemented controlled domain includes:

```text
PIX
CREDIT_CARD
DEBIT_CARD
CASH
```

Payment methods must use controlled values rather than unrestricted free-text descriptions.

This provides consistent financial classification and prevents semantically equivalent payment methods from being represented through different textual values.

PaymentMethod describes how the payment is performed.

It does not describe whether the payment succeeded.

That responsibility belongs to PaymentStatus.

---

### 8.4 PaymentStatus

`payment.PaymentStatus` represents the controlled financial lifecycle state of a Payment.

Conceptually:

```text
PaymentStatus
      │
      └── 1:N ──► Payment
```

The implemented controlled domain includes:

```text
PENDING
APPROVED
DECLINED
CANCELLED
PARTIALLY_REFUNDED
REFUNDED
```

These states belong specifically to the financial lifecycle of Payment.

They must not be interpreted as equivalent to the commercial lifecycle represented by the sales domain.

For example:

```text
Transaction Status
       │
       └── Commercial lifecycle

Payment Status
       │
       └── Financial lifecycle
```

The two lifecycle responsibilities may influence one another through business processes, but they remain separate persisted concepts.

---

### 8.5 Payment Amount

Payment preserves the monetary amount associated with the individual financial event.

Conceptually:

```text
Transaction
    │
    ├── Payment A
    │      └── Amount
    │
    ├── Payment B
    │      └── Amount
    │
    └── Payment N
           └── Amount
```

The Payment amount represents the amount associated with that Payment record.

AtlasCommerce must preserve the amount that actually participated in the financial event rather than rewriting historical payment information solely to make the accumulated payment state appear equal to a commercial total.

The commercial amount due and the financial events recorded against it are related but distinct facts.

Any financial correction must preserve the historical meaning of the original Payment.

---

### 8.6 Multiple Payments

A Transaction may have multiple Payment records.

Conceptually:

```text
sales.Transaction
       │
       ├──► Payment 1
       ├──► Payment 2
       └──► Payment N
```

This architecture allows AtlasCommerce to preserve multiple financial events independently.

For example:

```text
Transaction
│
├── Payment
│     Method : PIX
│     Status : DECLINED
│
└── Payment
      Method : CREDIT_CARD
      Status : APPROVED
```

The declined attempt remains part of the financial history.

It must not be overwritten by the later approved payment.

Multiple Payment records may also represent legitimate split-payment scenarios when the commercial process permits them.

The financial state of the Transaction must therefore be determined from the applicable Payment facts rather than from an assumption that one Transaction always has exactly one Payment.

---

### 8.7 Installment Information

Payment may preserve installment information when the selected payment method supports installment-based processing.

The implemented Payment model includes an optional installment count.

Conceptually:

```text
Payment
   │
   ├── PaymentMethod
   ├── Amount
   └── InstallmentCount
```

InstallmentCount describes how the Payment amount is commercially divided for the applicable payment operation.

It does not create independent installment entities in the current AtlasCommerce model.

Detailed installment lifecycle management is outside the current implemented scope.

A Payment method that does not use installments does not require an artificial installment value solely to populate the field.

---

### 8.8 Payment Temporal State

Payment preserves timestamps associated with meaningful financial lifecycle events.

The implemented model distinguishes temporal facts such as:

```text
attempted_at
     │
     ▼
Payment Attempt
     │
     ├────────► approved_at
     │
     └────────► cancelled_at
```

`attempted_at` identifies when the payment attempt occurred.

`approved_at`, when applicable, identifies when approval occurred.

`cancelled_at`, when applicable, identifies when cancellation occurred.

These values represent different financial facts and must not be treated as interchangeable.

The applicable temporal relationships form part of the expected persistent state of Payment.

Lifecycle timestamps must preserve what actually happened rather than being populated with artificial values merely to avoid `NULL`.

---

### 8.9 Payment Approval

Payment approval represents a financial event.

An approved Payment indicates that the applicable payment operation reached the approved financial state.

Conceptually:

```text
Payment
   │
   ▼
APPROVED
   │
   └── Financial fact established
```

Approval may cause business processes in other domains to continue.

For example, an approved financial state may permit subsequent sales, inventory, or fulfillment operations according to the applicable business rules.

Those downstream consequences remain responsibilities of their respective domains.

The payment domain records the financial fact.

It does not assume ownership of inventory consumption, commercial transaction completion, or shipment fulfillment merely because payment approval may trigger those processes.

---

### 8.10 Payment Cancellation and Decline

A declined Payment and a cancelled Payment represent different financial outcomes.

Conceptually:

```text
Payment Attempt
      │
      ├── DECLINED
      │      └── Approval was not obtained
      │
      └── CANCELLED
             └── Payment lifecycle was cancelled
```

These conditions must remain distinguishable because they represent different financial meanings.

A later successful Payment does not erase the earlier declined or cancelled financial event.

Historical financial facts must remain available for operational traceability and future analytical interpretation.

---

### 8.11 Payment Refund

`payment.PaymentRefund` represents money returned in relation to a previously recorded Payment.

Conceptually:

```text
Payment
   │
   └── 1:N ──► PaymentRefund
```

A refund is a separate financial event.

It must not be represented by:

- Deleting the original Payment.
- Reducing the original Payment amount.
- Rewriting an approved Payment as though the original financial event never occurred.
- Creating an artificial negative Payment solely to represent returned money.

Conceptually:

```text
Original Payment
       │
       └── Preserved financial fact
                │
                ▼
          PaymentRefund
                │
                └── Subsequent financial fact
```

This preserves the financial history of both the money originally received and the money subsequently returned.

---

### 8.12 Multiple Refunds

A Payment may have zero, one, or multiple PaymentRefund records.

Conceptually:

```text
Payment
   │
   ├──► PaymentRefund 1
   ├──► PaymentRefund 2
   └──► PaymentRefund N
```

This allows a Payment to be refunded incrementally when the business process requires it.

The financial history remains explicit rather than being collapsed into a single mutable refund amount.

The existence of multiple refunds also allows the Payment lifecycle to distinguish between partially refunded and fully refunded financial states.

Conceptually:

```text
APPROVED
    │
    ▼
PARTIALLY_REFUNDED
    │
    ▼
REFUNDED
```

The current PaymentStatus communicates the financial lifecycle state.

The PaymentRefund records preserve the individual financial events responsible for that state.

---

### 8.13 PaymentRefundReason

`payment.PaymentRefundReason` represents the controlled reason for returning money associated with a Payment.

Conceptually:

```text
PaymentRefundReason
         │
         └── 1:N ──► PaymentRefund
```

The implemented controlled domain includes:

```text
CUSTOMER_RETURN
DUPLICATE_CHARGE
FRAUD
OPERATIONAL_ERROR
ORDER_CANCELLATION
```

Refund reasons provide consistent financial classification for why money was returned.

They must not be replaced by unrestricted free-text descriptions as the authoritative refund classification.

A controlled refund reason may support:

- Operational investigation.
- Financial reconciliation.
- Auditability.
- Reporting.
- Future analytical classification.

The refund reason describes the financial reason for the return of money.

It does not by itself establish that another domain event occurred.

---

### 8.14 Refund and Other Domains

A PaymentRefund represents a financial event only.

It must not automatically be interpreted as evidence of:

- A physical product return.
- An inventory return.
- A transaction cancellation.
- A shipment return.
- Another non-financial lifecycle event.

Conceptually:

```text
Business Event
    │
    ├──► sales consequence
    ├──► inventory consequence
    ├──► shipping consequence
    └──► payment consequence
              │
              ▼
         PaymentRefund
```

One business situation may produce consequences in multiple domains, but each domain remains responsible for its own persisted facts.

For example, a customer return may eventually produce both:

```text
Inventory consequence
        │
        └── InventoryMovement

Financial consequence
        │
        └── PaymentRefund
```

The existence of one must not be used as a substitute for explicitly representing the other when both facts are required by the operational model.

---

### 8.15 Payment and Inventory

Payment and inventory are separate operational responsibilities.

Conceptually:

```text
sales.Transaction
      /       \
     /         \
    ▼           ▼
payment      inventory
```

A financial event may trigger an inventory process according to the applicable business workflow, but Payment does not directly represent stock state.

Likewise, Inventory does not represent whether money was successfully received.

This separation prevents financial state and stock state from becoming implicitly coupled through duplicated status values.

Cross-domain processes must coordinate the required state changes while preserving the authoritative responsibility of each domain.

---

### 8.16 Payment and Shipping

Payment and shipping also represent independent lifecycle responsibilities.

Conceptually:

```text
sales.Transaction
      /       \
     /         \
    ▼           ▼
payment       shipping
Financial     Fulfillment
Lifecycle     Lifecycle
```

Payment approval does not itself mean that a Shipment has been posted or delivered.

Likewise, a delivered Shipment does not replace the financial evidence represented by Payment.

Each domain preserves its own operational facts.

The business process may evaluate those facts together when determining the broader commercial state of a Transaction.

---

### 8.17 Financial History Preservation

Financial history must remain distinguishable from current financial state.

For the payment domain:

```text
Payment
   │
   └── Original financial event

PaymentRefund
   │
   └── Subsequent return-of-money event

PaymentStatus
   │
   └── Current financial lifecycle classification
```

A later financial event must not erase the evidence of an earlier event.

For example:

```text
Payment approved
      │
      ▼
Money received
      │
      ▼
Partial refund
      │
      ▼
Additional refund
```

The final current state may be `REFUNDED`, but the database must still preserve the Payment and the individual refund events that explain how that state was reached.

This distinction supports operational investigation, reconciliation, auditability, and future analytical processing.

---

### 8.18 Payment Domain Boundaries

The payment domain owns financial payment and refund responsibility.

It does not own:

- Product identity.
- Customer identity.
- Commercial transaction identity.
- Inventory state.
- Inventory reservation lifecycle.
- Shipment lifecycle.
- Commercial fulfillment state.

Conceptually:

```text
                    sales
                 Transaction
                  /       \
                 /         \
                ▼           ▼
            payment       inventory
               │
               │
               └── Financial responsibility

                 Transaction
                      │
                      ▼
                   shipping
                      │
                      └── Fulfillment responsibility
```

The payment domain consumes the Transaction identity required to associate financial events with the commercial operation.

The sales domain remains responsible for that Transaction.

Financial consequences are recorded by `payment`.

Commercial consequences remain represented by `sales`.

Inventory consequences remain represented by `inventory`.

Fulfillment consequences remain represented by `shipping`.

---

### 8.19 Payment Domain Principle

The `payment` domain separates financial events from the commercial, inventory, and fulfillment lifecycles that may cause or respond to them.

For the current AtlasCommerce model:

- Payment represents an individual financial payment attempt associated with a Transaction.
- A Transaction may have multiple Payments.
- PaymentMethod provides controlled classification of how payment is performed.
- PaymentStatus represents the financial lifecycle of an individual Payment.
- Payment amount preserves the amount associated with the actual financial event.
- Installment information remains part of Payment when applicable.
- Payment lifecycle timestamps preserve distinct financial facts.
- Declined and cancelled Payments remain historically distinguishable.
- A later successful Payment does not overwrite earlier attempts.
- PaymentRefund represents money returned after a previously recorded Payment.
- A Payment may have multiple PaymentRefund events.
- PaymentRefundReason provides controlled classification of why money was returned.
- Refunds preserve the original Payment rather than rewriting it.
- Financial refunds do not automatically represent product, inventory, shipment, or commercial lifecycle events.
- Payment state must not be duplicated as Transaction, Inventory, or Shipment state.
- Cross-domain business processes may coordinate financial events with other operational consequences while preserving domain ownership.
- Financial history must remain traceable even after the current Payment state changes.

The payment domain may evolve as additional financial requirements are introduced, but future structures must preserve the distinction between the commercial obligation, the financial events used to satisfy it, and subsequent financial corrections or refunds.

---

## 9. Reference Domain

The `reference` domain owns shared reference identities and controlled classifications whose meaning is used across domain boundaries and is not exclusively owned by a single business domain.

The current Reference Domain contains:

- Country.
- AdministrativeDivision.
- City.
- Address.
- ContactType.

Conceptually:

```text
reference
│
├── Country
│      │
│      ▼
│   AdministrativeDivision
│      │
│      ▼
│     City
│      │
│      ▼
│   Address
│
└── ContactType
```

The Reference Domain provides authoritative shared identities.

A consuming domain may reference these identities without acquiring ownership of them.

Not every controlled value belongs in `reference`.

When a controlled classification has meaning and lifecycle owned exclusively by a specific business domain, it remains in that domain.

---

### 9.1 Geographic Reference Model

The geographic reference model is represented by:

```text
Country
   │
   ▼
AdministrativeDivision
   │
   ▼
City
   │
   ▼
Address
```

Each level has a distinct responsibility.

`reference.Country` represents a country.

`reference.AdministrativeDivision` represents an administrative subdivision belonging to a Country.

`reference.City` represents a city belonging to an AdministrativeDivision.

`reference.Address` represents a reusable address identity associated with a City.

The hierarchy allows geographic information to be represented once and consumed by business domains without duplicating the complete geographic structure in each consuming entity.

---

### 9.2 Country

`reference.Country` represents a country in the shared geographic model.

Conceptually:

```text
Country
   │
   └── 1:N ──► AdministrativeDivision
```

Country provides the highest geographic level represented by the current reference hierarchy.

The existence of a Country in the reference model does not by itself imply that AtlasCommerce currently supports commercial operation in that country.

Geographic representation and commercial scope are separate responsibilities.

---

### 9.3 AdministrativeDivision

`reference.AdministrativeDivision` represents an administrative subdivision of a Country.

Depending on the country, this concept may correspond to structures such as a state, province, or another applicable administrative division.

Conceptually:

```text
Country
   │
   ▼
AdministrativeDivision
   │
   └── 1:N ──► City
```

An AdministrativeDivision belongs to one Country.

The entity avoids embedding country-specific administrative terminology into consuming business domains.

---

### 9.4 City

`reference.City` represents a city associated with an AdministrativeDivision.

Conceptually:

```text
AdministrativeDivision
          │
          └── 1:N ──► City
```

City provides the geographic identity consumed by the Address model.

A City belongs to one AdministrativeDivision.

Country information is obtained through the geographic hierarchy rather than being redundantly represented as an independent relationship from every Address or consuming business entity.

---

### 9.5 Address

`reference.Address` represents a reusable address identity within the shared reference model.

Conceptually:

```text
Country
   │
   ▼
AdministrativeDivision
   │
   ▼
City
   │
   ▼
Address
```

Address owns the location information represented by the shared address identity.

Business domains that require an address consume this identity through their own relationships rather than duplicating the authoritative address representation.

For example:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        ▼
customer.Customer
```

The customer domain owns the relationship between Customer and Address.

The reference domain owns the Address itself.

This distinction allows the same reference structure to remain independent from the lifecycle of a specific customer-address relationship.

---

### 9.6 ContactType

`reference.ContactType` represents the controlled classification used to identify supported telephone-contact types.

The current customer contact model consumes ContactType through `customer.CustomerContact`.

Conceptually:

```text
reference.ContactType
          │
          └── 1:N ──► customer.CustomerContact
```

Examples of currently controlled contact classifications include:

- PHONE.
- MOBILE.

ContactType belongs to `reference` because it provides a controlled classification consumed outside the physical definition of the customer identity itself.

The contact value remains owned by `customer.CustomerContact`.

Conceptually:

```text
reference.ContactType
          │
          ▼
customer.CustomerContact
          │
          ▼
customer.Customer
```

The Reference Domain therefore owns the classification.

The Customer Domain owns the customer-specific contact information and its lifecycle.

Email does not use ContactType in the current model because email addresses are represented separately by `customer.CustomerEmail`.

---

### 9.7 Shared Reference Ownership

A relationship to a reference entity does not transfer ownership of that entity to the consuming domain.

Conceptually:

```text
reference
   │
   ├── Address ─────────► customer.CustomerAddress
   │
   └── ContactType ─────► customer.CustomerContact
```

The consuming domain owns its relationship or operational use.

The Reference Domain owns the shared identity or classification.

This prevents equivalent reference information from being independently reproduced across business domains.

---

### 9.8 Reference Data and Domain-Controlled Data

The existence of the `reference` domain does not mean that every controlled value belongs there.

AtlasCommerce distinguishes between:

```text
Shared Reference Responsibility
          │
          └── reference

Domain-Owned Classification
          │
          └── owning business domain
```

Examples of domain-owned controlled classifications include:

- `customer.CustomerType`.
- `customer.CustomerDocumentType`.
- `inventory.InventoryReservationStatus`.
- `inventory.InventoryMovementReason`.
- `payment.PaymentMethod`.
- `payment.PaymentStatus`.
- `payment.PaymentRefundReason`.
- `sales.TransactionChannel`.
- `sales.TransactionStatus`.
- `shipping.ShipmentMethod`.
- `shipping.ShipmentStatus`.

These values remain within their owning domains because their meaning and lifecycle belong to those domains.

The Reference Domain is therefore reserved for genuinely shared reference responsibilities rather than serving as a generic container for every lookup table.

---

### 9.9 Reference Data and Lifecycle

Reference entities may have lifecycle characteristics appropriate to their implemented responsibility.

Lifecycle state must remain attached to the entity whose operational availability it describes.

AtlasCommerce does not require a generic shared `reference.Status` entity to represent the lifecycle of unrelated domain entities.

Instead, lifecycle state is represented according to the semantics of the owning entity or domain.

This prevents unrelated lifecycle concepts from becoming artificially coupled through a universal status abstraction.

---

### 9.10 Geographic Capability vs. Commercial Scope

The geographic model may be capable of representing locations beyond the current AtlasCommerce commercial scope.

This capability must not be confused with authorization for commercial operation in every represented geography.

Conceptually:

```text
Geographic Representation
          │
          └── What locations can the reference model represent?

Commercial Scope
          │
          └── Where does AtlasCommerce currently operate?
```

These are separate concerns.

Expanding commercial operation to additional countries may require changes beyond geographic reference data, including:

- customer identification;
- document requirements;
- taxation;
- payment;
- currency;
- shipping;
- regulatory requirements;
- localization.

The ability to represent a Country therefore does not imply complete international-commerce support.

---

### 9.11 Reference Domain Principle

The `reference` domain provides authoritative shared identities and classifications that do not belong exclusively to one business domain.

For the current AtlasCommerce model:

- Country represents the highest geographic reference level.
- AdministrativeDivision represents subdivisions of a Country.
- City belongs to an AdministrativeDivision.
- Address belongs to the geographic hierarchy through City.
- ContactType provides controlled telephone-contact classification.
- `customer.CustomerAddress` consumes Address without acquiring ownership of it.
- `customer.CustomerContact` consumes ContactType without acquiring ownership of it.
- Email is represented independently by `customer.CustomerEmail` and does not consume ContactType.
- Domain-specific controlled classifications remain in their owning domains.
- AtlasCommerce does not use a generic `reference.Status` entity for unrelated lifecycle responsibilities.
- Geographic capability does not define commercial scope.
- Cross-domain consumption does not transfer ownership.

The central principle is:

> **Shared reference identities belong in `reference` when their meaning crosses domain boundaries; controlled values that belong to a specific business responsibility remain with the domain that owns that responsibility.**

---

## 10. Sales Domain

The `sales` domain owns the persistent commercial transaction state of AtlasCommerce.

It represents the commercial event in which sellable Product Variants are purchased, the channel through which the transaction originates, the current commercial lifecycle of that transaction, and the individual items that compose it.

The sales domain establishes the commercial facts that other operational domains may consume.

It does not own the financial, inventory-reservation, or fulfillment lifecycles that may result from those facts.

The principal sales entities can be represented conceptually as:

```text
sales
│
├── TransactionChannel
├── TransactionStatus
├── Transaction
└── TransactionItem
```

The sales domain consumes identities owned by other domains when required by the commercial model, including Customer and Product Variant.

Other domains may subsequently consume Transaction or TransactionItem identities to represent payment, inventory, or fulfillment consequences.

These relationships do not transfer ownership of the commercial transaction away from `sales`.

---

### 10.1 Transaction

`sales.Transaction` represents a commercial purchase transaction recorded by AtlasCommerce.

Conceptually:

```text
sales.Transaction
       │
       └── 1:N ──► sales.TransactionItem
```

A Transaction establishes the commercial context in which one or more Product Variants are purchased.

It preserves facts such as:

- When the transaction occurred.
- The applicable Customer when one is identified.
- The channel through which the transaction originated.
- The current high-level commercial lifecycle state.

A Transaction may exist without an identified registered Customer when the applicable sales scenario permits it.

This allows AtlasCommerce to represent legitimate commercial operations such as an unidentified physical-store purchase without manufacturing an artificial Customer identity.

The absence of a Customer relationship in such a scenario is therefore a valid business state rather than automatically missing data.

---

### 10.2 Transaction Identity

Transaction has a stable technical identity within the sales domain.

Because the implemented sales architecture uses time-based partitioning, the complete relational definition of Transaction also includes its transaction timestamp where required by the partition-aware key design.

Conceptually:

```text
Transaction
│
├── Transaction Identity
└── Transaction Time
        │
        ▼
Complete Partition-Aware Key
```

The technical Transaction identifier remains the principal row identity.

The temporal component participates in the implemented key architecture because of the physical partitioning design.

It must not be interpreted as a second independent business identity.

This distinction is important for downstream relationships that reference Transaction.

A consuming domain may therefore require both the Transaction identifier and its corresponding temporal component to establish the complete implemented foreign key relationship.

---

### 10.3 TransactionChannel

`sales.TransactionChannel` represents the controlled channel through which a Transaction originates.

Conceptually:

```text
TransactionChannel
        │
        └── 1:N ──► Transaction
```

The implemented controlled domain distinguishes the sales channels supported by AtlasCommerce.

The channel identifies the commercial origin of the transaction rather than its lifecycle state.

For example, AtlasCommerce may distinguish between transactions originating from:

```text
ONLINE
STORE
```

These values must remain controlled rather than being represented through unrestricted free-text descriptions.

TransactionChannel allows different sales scenarios to coexist within the same commercial transaction model without requiring separate Transaction entities for each channel.

---

### 10.4 Online and Store Transactions

Online and physical-store transactions share the same fundamental commercial transaction responsibility.

Conceptually:

```text
                    Transaction
                    /         \
                   /           \
                  ▼             ▼
              ONLINE           STORE
```

The channel may influence downstream business processes, but it does not change the fundamental identity of the commercial transaction.

An online transaction requires fulfillment through the shipping domain.

A physical-store transaction represents immediate product handoff at the store and therefore does not generate a Shipment.

Conceptually:

```text
ONLINE Transaction
       │
       └── Requires Shipment

STORE Transaction
       │
       └── Immediate product handoff
           without Shipment
```

The existence of a Transaction therefore does not universally imply the existence of a Shipment because fulfillment behavior depends on the TransactionChannel.

For the current AtlasCommerce model:

```text
ONLINE
   │
   └── exactly one Shipment

STORE
   │
   └── no Shipment
```

Viewed across all Transactions, the generic relationship remains:

```text
Transaction
    │
    └── 0..1 Shipment
```

This distinction allows online and physical-store sales to share the same commercial Transaction model while preserving the fulfillment rules applicable to each channel.

---

### 10.5 TransactionStatus

`sales.TransactionStatus` represents the controlled high-level commercial lifecycle state of a Transaction.

Conceptually:

```text
TransactionStatus
        │
        └── 1:N ──► Transaction
```

The Transaction status communicates the commercial state of the purchase.

It must remain distinct from specialized lifecycle states owned by other domains.

Conceptually:

```text
sales.TransactionStatus
        │
        └── Commercial lifecycle

payment.PaymentStatus
        │
        └── Financial lifecycle

inventory.InventoryReservationStatus
        │
        └── Reservation lifecycle

shipping.ShipmentStatus
        │
        └── Fulfillment lifecycle
```

These states may influence one another through business processes, but they are not interchangeable.

The Transaction status must not become a consolidated replacement for detailed payment, reservation, or shipment state.

Likewise, another domain's status must not replace the commercial lifecycle represented by TransactionStatus.

---

### 10.6 Commercial Lifecycle

The commercial lifecycle of a Transaction represents the high-level state of the purchase rather than every operational event that may occur after it is created.

The implemented lifecycle includes the following controlled states:

```text
PENDING

CONFIRMED

COMPLETED

CANCELLED

FAILED
```

These values communicate the commercial interpretation of the Transaction.

Their meaning must remain synchronized with the AtlasCommerce business documentation and implemented controlled data.

Conceptually:

```text
PENDING
   │
   ├────────► FAILED
   │
   ▼
CONFIRMED
   │
   ├────────► CANCELLED
   │
   ▼
COMPLETED
```

This diagram is conceptual and must not be interpreted as a complete mandatory state-transition engine.

The valid lifecycle behavior is defined by the applicable business rules.

`PENDING` represents a Transaction that has been created but whose commercial sale has not yet been confirmed.

`CONFIRMED` represents a Transaction whose commercial sale has been successfully established.

`COMPLETED` represents a Transaction whose applicable commercial lifecycle has been completed.

`CANCELLED` represents a Transaction whose commercial lifecycle was cancelled according to the applicable business rules.

`FAILED` represents a Transaction whose commercial processing failed before successful confirmation.

TransactionStatus records current commercial state.

It does not replace the detailed historical facts preserved by the domains responsible for the operational events that caused that state.

---

### 10.7 TransactionItem

`sales.TransactionItem` represents a Product Variant purchased as part of a Transaction.

Conceptually:

```text
Transaction
    │
    └── 1:N ──► TransactionItem
                     │
                     └──► catalog.ProductVariant
```

A Transaction may contain multiple TransactionItems.

Each TransactionItem preserves the commercial facts associated with the specific Product Variant purchased in that transaction.

The item identifies:

- The Product Variant sold.
- The quantity purchased.
- The unit price applied.
- The unit discount applied.

TransactionItem references ProductVariant rather than Product because ProductVariant represents the specific sellable catalog identity.

The catalog domain remains responsible for ProductVariant.

The sales domain remains responsible for the fact that the variant was sold under the commercial conditions preserved by TransactionItem.

---

### 10.8 TransactionItem Identity

TransactionItem has its own stable technical identity.

Like Transaction, its complete implemented relational definition participates in the time-based partitioning architecture.

Conceptually:

```text
TransactionItem
│
├── TransactionItem Identity
└── Transaction Time
        │
        ▼
Complete Partition-Aware Key
```

The temporal component preserves compatibility with the implemented partition-aware physical and relational design.

It does not represent a separate commercial identity for the item.

Domains that reference TransactionItem may therefore require the complete implemented key, including the applicable temporal component.

For example:

```text
sales.TransactionItem
          │
          ├──► inventory.InventoryReservation
          │
          └──► inventory.InventoryMovement
                   when applicable
```

The additional temporal key component exists because of the partitioning architecture rather than because the business requires two independent identities for a sold item.

---

### 10.9 TransactionItem Pricing

TransactionItem preserves the commercial pricing conditions applied when the Product Variant was sold.

Conceptually:

```text
TransactionItem
│
├── Quantity
├── UnitPrice
└── UnitDiscount
```

`UnitPrice` represents the applicable unit selling price preserved for the transaction.

`UnitDiscount` represents the unit-level discount applied to that item.

The resulting item value can be derived from these persisted commercial facts.

Conceptually:

```text
Quantity × (UnitPrice - UnitDiscount)
```

The derived total does not need to become a separate persisted fact when it can be deterministically reconstructed from the authoritative components.

This preserves the underlying commercial facts while avoiding unnecessary duplication of deterministic values.

---

### 10.10 Historical Selling Price

Catalog pricing history and the historical selling price preserved by TransactionItem serve different responsibilities.

Conceptually:

```text
catalog.ProductVariant
        │
        ▼
catalog.ProductVariantPrice
        │
        └── Catalog pricing history
            and temporal validity

sales.TransactionItem
        │
        └── Price actually applied
            to the sale
```

`catalog.ProductVariantPrice` preserves the catalog-pricing periods associated with a ProductVariant.

`sales.TransactionItem` preserves the unit price and unit discount actually applied to the specific commercial transaction.

A later catalog-price change must not change the financial conditions preserved by an existing TransactionItem.

For example:

```text
At purchase

Applicable catalog price : 50.00
TransactionItem UnitPrice: 50.00

Later catalog price

ProductVariantPrice      : 55.00
TransactionItem UnitPrice: 50.00
```

The TransactionItem continues to represent the conditions under which the commercial transaction actually occurred.

The price applied to a sale may also differ from the applicable catalog price because of commercial conditions represented by the transaction.

Catalog pricing history must therefore not be reconstructed solely from TransactionItem, and historical selling conditions must not be reconstructed solely from ProductVariantPrice.

This separation allows catalog pricing to evolve while preserving the exact financial facts recorded by sales.

---

### 10.11 Unit Discount

Discount applied to a TransactionItem is normalized to a unit-level value.

Conceptually:

```text
TransactionItem
│
├── Quantity      : 3
├── UnitPrice     : 20.00
└── UnitDiscount  : 2.00
```

The commercial value can therefore be reconstructed consistently from the quantity and unit-level financial components.

A zero discount is a legitimate initial state.

The implemented database may therefore define an explicit initial default of:

```text
0.00
```

for the applicable unit-discount column.

The sales domain persists the resulting commercial fact.

It does not require the database model to reproduce the promotional calculation logic that determined why a particular discount was granted.

Promotional eligibility and calculation belong to the applicable business or application responsibility unless explicitly introduced into the persistent AtlasCommerce model.

---

### 10.12 TransactionItem Immutability

Once the applicable commercial transaction has reached the state in which its commercial conditions are established, the historical facts preserved by TransactionItem must not be destructively rewritten to represent later operational events.

Conceptually:

```text
Original Sale
    │
    ▼
TransactionItem
    │
    ├── Quantity
    ├── UnitPrice
    └── UnitDiscount
          │
          └── Historical commercial facts
```

Later events such as:

- Inventory adjustments.
- Shipment problems.
- Returns.
- Refunds.
- Other post-sale operational events.

must be represented by the domains responsible for those events rather than by rewriting the original sale.

This preserves the distinction between:

```text
What was sold
      │
      └── sales.TransactionItem

What happened afterward
      │
      └── Responsible operational domain
```

The original commercial fact remains traceable even when later events alter the operational or financial outcome.

---

### 10.13 Sales and Customer

A Transaction may reference a Customer when the buyer is identified through the customer domain.

Conceptually:

```text
customer.Customer
        │
        └── 1:N ──► sales.Transaction
```

The customer domain owns Customer identity and customer-related master data.

The sales domain consumes that identity to establish who participated in the commercial transaction when applicable.

The relationship is optional because AtlasCommerce permits legitimate transactions without an identified registered Customer.

Conceptually:

```text
Transaction
    │
    ├── Identified Customer
    │
    └── Customer not identified
```

An unidentified buyer must not require an artificial generic Customer record solely to satisfy the relationship.

The absence of a Customer identity must remain distinguishable from a known Customer.

---

### 10.14 Sales and Catalog

TransactionItem consumes ProductVariant identity from the catalog domain.

Conceptually:

```text
catalog.Product
       │
       ▼
catalog.ProductVariant
       │
       ▼
sales.TransactionItem
```

The relationship identifies exactly which sellable variant participated in the commercial transaction.

The sales domain does not duplicate catalog ownership.

It preserves only the commercial facts that must remain historically stable even if current catalog state later changes.

This allows:

```text
Catalog
   │
   └── Current sellable definition

Sales
   │
   └── Historical commercial fact
```

to evolve according to their independent responsibilities.

---

### 10.15 Sales and Inventory

Sales and inventory represent related but separate responsibilities.

Conceptually:

```text
sales.TransactionItem
          │
          ▼
      inventory
       /      \
      ▼        ▼
Reservation  Movement
```

A TransactionItem may cause inventory to be reserved.

A later applicable business event may cause physical inventory to change.

The sales domain records what was commercially purchased.

The inventory domain records the allocation and physical stock consequences of that commercial fact.

TransactionItem must not contain inventory-reservation or inventory-movement state merely because those processes originate from a sale.

This preserves explicit domain ownership while maintaining traceability between the related operational facts.

---

### 10.16 Sales and Payment

Payment consumes Transaction identity to associate financial events with the commercial purchase.

Conceptually:

```text
sales.Transaction
       │
       └── 1:N ──► payment.Payment
```

The sales domain establishes the commercial obligation.

The payment domain records the financial events associated with that obligation.

These responsibilities must remain separate.

Conceptually:

```text
Transaction
    │
    └── What was commercially purchased

Payment
    │
    └── What happened financially
```

A confirmed commercial Transaction and an approved Payment represent related but distinct facts.

Likewise, a refund must not rewrite the original Transaction or TransactionItem merely because the financial outcome later changes.

---

### 10.17 Sales and Shipping

The shipping domain represents physical fulfillment for an ONLINE Transaction.

Conceptually:

```text
sales.Transaction
       │
       ├── ONLINE
       │      │
       │      └──► shipping.Shipment
       │
       └── STORE
              │
              └── no Shipment
```

Under the current AtlasCommerce business model, an ONLINE Transaction requires a Shipment.

A STORE Transaction represents immediate product handoff at the physical store and therefore does not generate a Shipment.

The generic Transaction-to-Shipment relationship remains:

```text
sales.Transaction
       │
       └── 0..1 ──► shipping.Shipment
```

because the Transaction model supports both channels.

The channel determines which cardinality applies to the individual commercial scenario:

```text
ONLINE → exactly 1 Shipment
STORE  → 0 Shipments
```

The absence of a Shipment is therefore valid for a STORE Transaction.

It is not the expected fulfillment state of an ONLINE Transaction.

Sales and shipping remain separate responsibilities.

The sales domain owns the commercial Transaction.

The shipping domain owns the logistics fulfillment required for an ONLINE Transaction.

Shipping state must not replace the commercial state represented by Transaction.

---

### 10.18 Commercial State and Operational State

The broader outcome of a commercial transaction may depend on facts owned by several domains.

Conceptually:

```text
                    Transaction
                   Commercial
                      State
                    /   |   \
                   /    |    \
                  ▼     ▼     ▼
             payment inventory shipping
             Financial  Stock  Fulfillment
               State    State     State
```

These states must not be collapsed into one universal status.

Each domain preserves the state for which it is responsible.

Business processes may evaluate those states together when deciding whether the commercial transaction should move to another high-level TransactionStatus.

This allows the sales domain to communicate the commercial lifecycle without duplicating the detailed lifecycle models of the operational domains involved.

---

### 10.19 Partitioned Sales Architecture

Transaction and TransactionItem are high-volume transactional structures and participate in the AtlasCommerce partitioning architecture.

Conceptually:

```text
sales.Transaction
       │
       ├── Transaction Identity
       └── Transaction Time
                 │
                 ▼
          Monthly Partitioning

sales.TransactionItem
       │
       ├── TransactionItem Identity
       └── Transaction Time
                 │
                 ▼
          Monthly Partitioning
```

The implemented physical architecture uses the common sales partitioning infrastructure defined for these transactional structures.

The time-based component therefore participates in key, relationship, and index definitions where required to preserve partition alignment and relational compatibility.

Partitioning remains a physical architecture responsibility.

It does not redefine the business meaning of Transaction or TransactionItem.

The detailed partition function, partition scheme, physical placement, and validation requirements are governed by the AtlasCommerce Architecture and Database Standards.

---

### 10.20 Transaction Time Consistency

Transaction and TransactionItem preserve the temporal component required by the partition-aware architecture.

The TransactionItem temporal value must remain semantically consistent with the owning Transaction.

Conceptually:

```text
Transaction
   │
   └── transaction_at
            │
            ▼
TransactionItem
   │
   └── transaction_at
```

The repeated temporal value is not intended to represent two independent moments.

It supports the complete partition-aware relational structure.

A TransactionItem belongs to the same commercial transaction represented by its owning Transaction and therefore participates in the corresponding transaction-time context.

This relationship must remain consistent as part of the implemented data-integrity architecture.

---

### 10.21 Sales History Preservation

The sales domain preserves commercial facts whose historical meaning must survive later changes elsewhere in AtlasCommerce.

Examples include:

```text
Transaction
   │
   └── Historical commercial transaction

TransactionItem
   │
   ├── Product Variant sold
   ├── Quantity sold
   ├── Unit price
   └── Unit discount
```

Later changes to:

- Customer master data.

- Product catalog data.

- ProductVariantPrice catalog-pricing history or current applicable price.

- Inventory state.

- Payment state.

- Shipment state.

must not silently rewrite the commercial facts that were established when the transaction occurred.

This allows the sales domain to remain the authoritative representation of what was commercially transacted even when the broader operational lifecycle continues afterward.

---

### 10.22 Sales Domain Boundaries

The sales domain owns commercial transaction responsibility.

It does not own:

- Customer master data.
- Product catalog identity.
- Inventory state.
- Inventory reservation lifecycle.
- Payment lifecycle.
- Refund events.
- Shipment lifecycle.
- Shared reference identities.

Conceptually:

```text
customer ──────►
                \
catalog ─────────► sales
                  /  |  \
                 /   |   \
                ▼    ▼    ▼
          inventory payment shipping
```

The arrows represent consumption and operational relationships rather than transfer of domain ownership.

The sales domain consumes Customer and ProductVariant identities to establish commercial facts.

Inventory consumes sales identities when representing stock consequences.

Payment consumes Transaction identity when representing financial consequences.

Shipping consumes the commercial transaction context when physical fulfillment is required.

Each domain remains authoritative for the persistent state it owns.

---

### 10.23 Sales Domain Principle

The `sales` domain represents the authoritative commercial transaction facts of AtlasCommerce.

For the current AtlasCommerce model:

- Transaction represents the commercial purchase.
- TransactionChannel identifies the controlled channel through which the purchase originates.
- Online and store transactions share the same fundamental Transaction model.
- A physical-store transaction does not require a Shipment when the customer receives the product directly.
- TransactionStatus represents the high-level commercial lifecycle and remains separate from specialized operational statuses.
- A Transaction may exist without an identified registered Customer when the commercial scenario permits it.
- TransactionItem represents the specific Product Variant purchased as part of a Transaction.
- TransactionItem preserves quantity, unit price, and unit discount as historical commercial facts.
- Current catalog pricing must not rewrite historical selling prices.
- Deterministically derived item totals need not be duplicated as persisted commercial facts.
- Post-sale operational events must not destructively rewrite the original TransactionItem.
- Transaction and TransactionItem participate in the partition-aware sales architecture.
- Temporal key components required by partitioning support the physical and relational implementation without creating new business identities.
- Sales consumes Customer and ProductVariant identities without assuming ownership of those entities.
- Inventory, payment, and shipping may consume sales identities while remaining responsible for their own operational states.
- Commercial, financial, inventory, and fulfillment lifecycles remain distinct.
- Sales history must remain stable even as related operational state changes elsewhere in AtlasCommerce.

The sales domain may evolve as additional commercial requirements are introduced, but future structures must preserve the distinction between the original commercial transaction and the financial, inventory, and fulfillment processes that occur around it.

---

## 11. Shipping Domain

The `shipping` domain owns the persistent fulfillment and delivery state of AtlasCommerce.

It represents the logistics process required when a commercial Transaction must be physically delivered to a Customer rather than completed through immediate product handoff at the point of sale.

The shipping domain is responsible for preserving:

- The Shipment associated with the commercial Transaction.
- The delivery address selected for that Shipment.
- The shipping method.
- The current shipment lifecycle state.
- The amount associated with shipping.
- Tracking information when available.
- Relevant fulfillment timestamps and delivery expectations.

The principal shipping entities can be represented conceptually as:

```text
shipping
│
├── ShipmentMethod
├── ShipmentStatus
└── Shipment
```

The shipping domain consumes identities and operational facts owned by other AtlasCommerce domains when required by fulfillment.

These relationships do not transfer ownership of those entities to `shipping`.

---

### 11.1 Shipment

`shipping.Shipment` represents the physical fulfillment record associated with a Transaction when logistical delivery is required.

Conceptually:

```text
sales.Transaction
       │
       └── 0..1 ──► shipping.Shipment
```

The generic relationship permits a Transaction to have no Shipment because the Transaction model supports both ONLINE and STORE channels.

Under the current AtlasCommerce business model:

```text
ONLINE Transaction
       │
       └── exactly one Shipment

STORE Transaction
       │
       └── no Shipment
```

A Transaction may therefore have at most one Shipment.

This reflects the current commercial rule:

```text
One ONLINE Transaction
      │
      └──► One delivery destination
                  │
                  └──► One Shipment
```

If a purchase must be delivered to multiple destinations, the commercial operation must be represented through multiple Transactions rather than multiple Shipments for the same Transaction.

The absence of a Shipment is valid for a STORE Transaction because the product is handed to the customer directly at the physical store.

---

### 11.2 Transactions Without Shipment

Not every AtlasCommerce Transaction requires participation from the shipping domain.

Under the current business model, the TransactionChannel determines whether a Shipment is required.

Conceptually:

```text
sales.Transaction
       │
       ├── ONLINE
       │      │
       │      └── exactly one Shipment
       │
       └── STORE
              │
              └── immediate product handoff
                  without Shipment
```

An ONLINE Transaction requires logistical fulfillment and therefore requires one Shipment.

A STORE Transaction represents a physical-store purchase in which the customer receives the purchased product directly at the store and therefore does not generate a Shipment.

The existence of the `shipping` domain must not cause AtlasCommerce to manufacture a Shipment for a STORE Transaction.

Likewise, the absence of a Shipment must not be treated as the expected fulfillment state of an ONLINE Transaction.

Across the complete Transaction model, the generic relationship remains `0..1` because both channels are represented by the same Transaction entity.

---

### 11.3 Shipment and Transaction Identity

Shipment consumes Transaction identity from the `sales` domain.

Because Transaction participates in the partition-aware sales architecture, the complete implemented relationship includes the applicable temporal component required by the referenced key.

Conceptually:

```text
sales.Transaction
│
├── Transaction Identity
└── Transaction Time
        │
        ▼
Complete Referenced Key
        │
        ▼
shipping.Shipment
```

The temporal component does not represent a separate logistics identity.

It participates in the relationship because the physical and relational architecture of the referenced Transaction requires the complete partition-aware key.

The sales domain remains authoritative for Transaction identity.

The shipping domain consumes that identity only to establish which commercial transaction the Shipment fulfills.

---

### 11.4 One Transaction, One Delivery

The current AtlasCommerce fulfillment model intentionally associates a Transaction with no more than one delivery destination and one Shipment.

Conceptually:

```text
Transaction
    │
    ▼
Delivery Requirement
    │
    ▼
Shipment
    │
    ▼
One Delivery Address
```

This simplifies the current operational model while preserving an explicit relationship between the commercial purchase and its fulfillment.

A Transaction must not be split across multiple delivery destinations.

When a customer requires products to be delivered to different destinations, those purchases must be represented as separate Transactions.

This rule belongs to the current AtlasCommerce business model and must remain synchronized with the applicable business documentation.

Future requirements may introduce a different fulfillment model, but such a change would represent an intentional evolution of both the business and persistent data models.

---

### 11.5 Delivery Address

A Shipment references the CustomerAddress selected as the destination for that fulfillment operation.

Conceptually:

```text
customer.Customer
       │
       ▼
customer.CustomerAddress
       │
       ▼
shipping.Shipment
```

The customer domain owns CustomerAddress.

The shipping domain consumes the selected address identity to establish where the Shipment must be delivered.

The referenced CustomerAddress represents the exact address record selected for the Shipment.

Because CustomerAddress history is preserved through the customer-domain lifecycle model, later changes to a customer's address information must not silently change the address associated with an existing Shipment.

Conceptually:

```text
Original CustomerAddress
          │
          └──► Existing Shipment

Later address change
          │
          ▼
New CustomerAddress
```

The existing Shipment continues to reference the original address record.

This preserves the historical meaning of the fulfillment operation without requiring the shipping domain to duplicate ownership of customer address data.

---

### 11.6 ShipmentMethod

`shipping.ShipmentMethod` represents the controlled method used to perform a Shipment.

Conceptually:

```text
ShipmentMethod
      │
      └── 1:N ──► Shipment
```

The current controlled domain includes implemented methods such as:

```text
PAC
SEDEX
```

Shipment methods must be represented through controlled deployment-managed data rather than unrestricted free-text values.

The method communicates how the Shipment is intended to be performed.

It does not represent the current lifecycle state of the Shipment.

ShipmentMethod and ShipmentStatus therefore serve independent responsibilities.

---

### 11.7 ShipmentStatus

`shipping.ShipmentStatus` represents the controlled current logistics state of a Shipment.

Conceptually:

```text
ShipmentStatus
      │
      └── 1:N ──► Shipment
```

The implemented controlled domain includes states such as:

```text
PENDING
POSTED
DELIVERED
CANCELLED
RETURNED
```

These values describe the fulfillment lifecycle of the Shipment.

They must not be confused with the commercial lifecycle represented by `sales.TransactionStatus`.

Conceptually:

```text
sales.TransactionStatus
        │
        └── Commercial lifecycle

shipping.ShipmentStatus
        │
        └── Logistics lifecycle
```

A Shipment becoming `DELIVERED` represents a logistics fact.

The corresponding Transaction lifecycle may respond to that fact according to the applicable business rules, but the two statuses remain independently owned.

---

### 11.8 Shipment Lifecycle

The Shipment lifecycle represents the current high-level logistics state of the fulfillment operation.

Conceptually:

```text
PENDING
   │
   ▼
POSTED
   │
   ├────────► DELIVERED
   │
   ├────────► RETURNED
   │
   └────────► CANCELLED
```

This representation is conceptual and must not be interpreted as a complete mandatory state-transition engine.

The applicable business rules define which transitions are legitimate under each operational scenario.

ShipmentStatus preserves current logistics state.

Other timestamps and operational facts provide additional context about the fulfillment lifecycle.

The shipping domain must not use TransactionStatus as a substitute for this logistics-specific state.

---

### 11.9 Shipping Amount

Shipment preserves the monetary amount associated with shipping according to the implemented AtlasCommerce commercial model.

Conceptually:

```text
Shipment
   │
   └── Shipping Amount
```

The amount must remain distinguishable from the value of the products sold.

A zero shipping amount is a legitimate commercial state.

For example, a Shipment may have no shipping charge because of:

- A commercial free-shipping policy.
- A promotion.
- Another legitimate commercial condition.

The absence of a charge must therefore be represented as a valid zero monetary amount rather than as missing information when a Shipment exists.

The shipping domain persists the resulting monetary fact.

It does not need to reproduce the commercial calculation logic that determined why the amount was charged or waived.

---

### 11.10 Delivery Estimate

Shipment preserves the applicable expected delivery date required by the current fulfillment model.

Conceptually:

```text
Transaction Time
      │
      ▼
Shipment
      │
      └── Estimated Delivery Date
```

The estimated delivery date represents an expectation rather than proof that delivery occurred.

It must therefore remain conceptually distinct from the actual delivery timestamp.

Conceptually:

```text
Estimated Delivery Date
        │
        └── Expected fulfillment

Delivered At
        │
        └── Actual fulfillment fact
```

The estimated delivery date must not precede the applicable Transaction date according to the implemented integrity rules.

A future requirement for historical tracking of multiple delivery estimates would require an explicit model evolution rather than silently changing the meaning of the current Shipment attribute.

---

### 11.11 Tracking Code

Shipment may preserve a tracking code when the applicable shipping process provides one.

Conceptually:

```text
Shipment
   │
   └── Tracking Code
```

Tracking information belongs to the fulfillment responsibility because it identifies the logistics operation rather than the commercial Transaction itself.

The absence of a tracking code may be legitimate during lifecycle stages in which tracking information has not yet been assigned.

TrackingCode must therefore not be interpreted independently from the Shipment lifecycle and applicable shipping method.

The current model preserves the tracking identifier required for operational fulfillment without introducing a separate logistics-event history that is not part of the implemented AtlasCommerce model.

---

### 11.12 Shipment Timestamps

Shipment preserves timestamps required to represent important logistics lifecycle facts.

The implemented model includes temporal information such as:

```text
Transaction Time
      │
      ▼
Shipment
│
├── Posted At
└── Delivered At
```

`posted_at` represents when the Shipment was posted into the applicable logistics process.

`delivered_at` represents when delivery was completed.

These values describe different lifecycle events and must remain temporally coherent.

Conceptually:

```text
Transaction
    │
    ▼
Posted
    │
    ▼
Delivered
```

When the corresponding values exist:

- `posted_at` must not precede the applicable Transaction time.
- `delivered_at` must not precede `posted_at`.

A missing future lifecycle timestamp is legitimate when the Shipment has not yet reached that event.

The database therefore distinguishes between an event that has not yet occurred and an invalid temporal sequence.

---

### 11.13 Shipping and Customer

The shipping domain consumes CustomerAddress identity from the customer domain.

It does not own Customer or CustomerAddress master data.

Conceptually:

```text
customer.Customer
       │
       ▼
customer.CustomerAddress
       │
       └──► shipping.Shipment
```

The relationship exists because fulfillment requires a delivery destination.

Ownership remains explicit:

```text
customer
   │
   └── Owns CustomerAddress

shipping
   │
   └── References the address selected
       for fulfillment
```

Changes to customer master data must not rewrite historical fulfillment facts.

Likewise, the shipping domain must not maintain an independent competing representation of the same CustomerAddress identity merely to avoid a cross-domain relationship.

---

### 11.14 Shipping and Sales

Shipping consumes the commercial Transaction context established by the `sales` domain.

Conceptually:

```text
sales.Transaction
       │
       └──► shipping.Shipment
                when required
```

The sales domain answers:

```text
What commercial purchase occurred?
```

The shipping domain answers:

```text
How is that purchase being physically fulfilled?
```

These responsibilities remain separate even when their lifecycle states influence one another.

A Shipment must not replace the Transaction as the representation of the commercial purchase.

Likewise, Transaction must not absorb detailed logistics state merely because fulfillment occurs as a consequence of the sale.

---

### 11.15 Shipping and Inventory

Shipping and inventory represent different operational responsibilities.

Conceptually:

```text
sales.Transaction
       │
       ├──► inventory
       │      └── Stock responsibility
       │
       └──► shipping
              └── Fulfillment responsibility
```

Inventory determines and preserves stock state and the applicable inventory consequences of commercial operations.

Shipping represents the logistics process required to deliver the commercial purchase.

A Shipment must not be treated as an inventory movement.

Likewise, an inventory movement must not be treated as evidence that physical delivery occurred.

The two domains may participate in the same broader fulfillment process while preserving distinct persistent facts.

---

### 11.16 Shipping and Payment

Shipping and payment represent independent operational consequences of a commercial Transaction.

Conceptually:

```text
                 sales.Transaction
                  /             \
                 ▼               ▼
         payment.Payment   shipping.Shipment
          Financial State   Logistics State
```

Payment answers financial questions about the commercial purchase.

Shipment answers logistics questions about fulfillment.

A successful payment does not itself establish that a Shipment has been posted or delivered.

Likewise, a logistics state does not replace the financial state represented by Payment.

Business processes may coordinate these domains, but their persistent responsibilities remain separate.

---

### 11.17 Fulfillment and Commercial Completion

A delivered Shipment represents successful completion of the logistics responsibility associated with that Shipment.

Conceptually:

```text
Shipment
   │
   ▼
DELIVERED
   │
   └── Logistics obligation satisfied
```

The broader commercial interpretation belongs to the sales lifecycle.

Under the current model, Shipment delivery may provide the business event required for the corresponding Transaction to reach `COMPLETED`.

Conceptually:

```text
ShipmentStatus.DELIVERED
        │
        └── Logistics fact
                │
                ▼
        may contribute to
                │
                ▼
TransactionStatus.COMPLETED
        │
        └── Commercial state
```

However:

```text
ShipmentStatus.DELIVERED
        ≠
TransactionStatus.COMPLETED
```

The two controlled states represent related but distinct persistent responsibilities.

`DELIVERED` belongs to the logistics lifecycle owned by `shipping`.

`COMPLETED` belongs to the commercial lifecycle owned by `sales`.

This prevents logistics state from being duplicated or ambiguously owned across domains.

---

### 11.18 Returned Shipments

A Shipment may enter a returned logistics state when the physical fulfillment process results in the shipment being returned.

Conceptually:

```text
Shipment
   │
   ▼
RETURNED
```

This state represents a logistics fact.

It must not automatically be interpreted as every other business consequence that may result from the return.

For example, a returned Shipment does not by itself define:

- The financial refund outcome.
- The resulting inventory movement.
- The final commercial Transaction state.

Those consequences belong to the domains responsible for them and must be represented through the appropriate operational processes.

Conceptually:

```text
Returned Shipment
      │
      ├──► sales
      │      Commercial consequence
      │
      ├──► payment
      │      Financial consequence
      │
      └──► inventory
             Stock consequence
```

The logistics fact remains independently preserved by `shipping`.

---

### 11.19 Cancelled Shipments

A Shipment may be cancelled when the applicable logistics operation is terminated before successful delivery.

Conceptually:

```text
Shipment
   │
   ▼
CANCELLED
```

Shipment cancellation represents cancellation of the logistics operation.

It must not automatically be interpreted as cancellation of the commercial Transaction itself.

Conceptually:

```text
Shipment CANCELLED
        │
        └── Logistics state

Transaction CANCELLED
        │
        └── Commercial state
```

The business process determines whether a cancelled Shipment also requires a commercial cancellation, another fulfillment action, financial correction, inventory action, or another operational response.

The shipping domain preserves only the logistics state for which it is authoritative.

---

### 11.20 Historical Fulfillment Preservation

Shipping facts with historical relevance must remain stable after they have been established.

Examples include:

```text
Shipment
│
├── Related Transaction
├── Delivery Address
├── Shipment Method
├── Shipping Amount
├── Tracking Code
├── Posted At
└── Delivered At
```

Later changes to:

- Customer master data.

- Current customer addresses.

- Transaction state.

- Payment state.

- Inventory state.

- Shipping reference data.

must not silently rewrite historical facts associated with an existing Shipment.

Where the customer-domain lifecycle preserves a previously selected CustomerAddress record, Shipment should continue to reference the exact address identity selected for fulfillment.

Later address changes are represented according to the CustomerAddress lifecycle without changing the CustomerAddress identity already referenced by the existing Shipment.

This allows the shipping domain to preserve the historical delivery relationship without unnecessarily duplicating authoritative data owned by another domain.

---

### 11.21 Shipping Integrity

The shipping model requires persistent integrity between the commercial transaction, delivery destination, controlled shipping domains, and logistics lifecycle facts.

Conceptually:

```text
Shipment
│
├──► sales.Transaction
├──► customer.CustomerAddress
├──► shipping.ShipmentMethod
└──► shipping.ShipmentStatus
```

The database must protect relationships and invariants that are required for a valid persisted Shipment.

Applicable integrity includes:

- The referenced Transaction must exist.
- The referenced CustomerAddress must exist.
- The referenced ShipmentMethod must exist.
- The referenced ShipmentStatus must exist.
- A Transaction must not acquire multiple Shipments when the current model permits at most one.
- Shipping amount must represent a valid non-negative monetary value.
- Delivery estimates must respect the applicable temporal relationship with the Transaction.
- Posted and delivered timestamps must preserve valid temporal ordering when present.

Detailed physical constraint definitions remain governed by the AtlasCommerce Database Standards and implemented database model.

---

### 11.22 Shipping Domain Boundaries

The shipping domain owns fulfillment and shipment responsibility.

It does not own:

- Customer identity.
- Customer address master-data lifecycle.
- Product catalog identity.
- Commercial Transaction identity.
- TransactionItem commercial facts.
- Inventory position.
- Inventory movements.
- Inventory reservations.
- Payment lifecycle.
- Financial refunds.
- Shared geographic reference data.

Conceptually:

```text
customer ───────►
                  \
sales ─────────────► shipping
                  /
reference ───────►
```

The arrows represent consumption of identities and relationships rather than transfer of ownership.

The shipping domain consumes the commercial Transaction and delivery-address identities required to represent fulfillment.

Other domains may react to logistics outcomes while remaining authoritative for their own persistent state.

---

### 11.23 Shipping Domain Principle

The `shipping` domain represents the authoritative logistics and fulfillment state of AtlasCommerce.

For the current AtlasCommerce model:

- Shipment exists for an ONLINE Transaction because that channel requires logistical fulfillment.

- A physical-store STORE Transaction completes through immediate product handoff and does not generate a Shipment.

- Across the complete Transaction model, a Transaction may have at most one Shipment.

- Multiple delivery destinations require separate Transactions.

- Shipment references the CustomerAddress selected for delivery.

- Later customer-address changes must not alter the CustomerAddress identity associated with an existing Shipment.

- ShipmentMethod represents the controlled fulfillment method.

- ShipmentStatus represents the current logistics lifecycle and remains separate from TransactionStatus.

- `PAC` and `SEDEX` are controlled implemented shipping methods.

- `PENDING`, `POSTED`, `DELIVERED`, `CANCELLED`, and `RETURNED` represent the implemented ShipmentStatus domain.

- Shipping amount remains separate from the value of the products sold and may legitimately be zero.

- Estimated delivery represents an expectation and remains distinct from actual delivery.

- Tracking information belongs to the fulfillment responsibility.

- Posted and delivered timestamps preserve distinct logistics lifecycle facts.

- Returned or cancelled Shipment states do not automatically determine financial, inventory, or commercial consequences.

- Shipping consumes Transaction and CustomerAddress identities without assuming ownership of those entities.

- Logistics, commercial, financial, and inventory states remain independently represented.

- Historical fulfillment facts must not be silently rewritten by later changes elsewhere in AtlasCommerce.

- The complete Transaction relationship preserves the temporal component required by the partition-aware sales architecture.

The shipping domain may evolve when future fulfillment requirements justify additional logistics structures, but those structures must be introduced because of explicit business or operational requirements rather than by assuming complexity that the current AtlasCommerce model does not require.

---

## 12. Cross-Domain Relationships

AtlasCommerce is implemented as a single relational transactional database whose business and technical responsibilities are separated into explicit domains.

Those domain boundaries establish ownership.

They do not isolate entities from one another when the persistent operational model requires cross-domain relationships.

Cross-domain relationships allow one domain to consume the identity or state owned by another domain without duplicating that information or transferring ownership of the referenced entity.

The principal cross-domain relationships can be represented conceptually as:

```text
                         reference
                             │
                 ┌───────────┴───────────┐
                 │                       │
                 ▼                       ▼
             customer                 shared
                 │                   reference
                 │                     data
                 ▼
               sales ◄──────────── catalog
          ┌──────┼──────┐
          │      │      │
          ▼      ▼      ▼
     inventory payment shipping
```

This diagram represents persistent domain interaction.

It does not represent a mandatory execution order or complete business workflow.

---

### 12.1 Ownership and Consumption

Every persistent entity belongs to one primary AtlasCommerce domain.

A consuming domain may reference that entity when required by its own responsibility.

Conceptually:

```text
Owning Domain
     │
     └── Owns Entity Identity and Lifecycle
                  │
                  ▼
           Consuming Domain
                  │
                  └── Owns Relationship or
                      Dependent Operational Fact
```

Cross-domain consumption must preserve ownership boundaries.

For example:

- `catalog` owns ProductVariant.
- `sales` consumes ProductVariant when recording a TransactionItem.
- `inventory` consumes ProductVariant when maintaining stock state, movement history, or reservations.
- `customer` owns Customer and CustomerAddress.
- `sales` may consume Customer identity.
- `shipping` consumes CustomerAddress when a Shipment requires delivery.
- `reference` owns Address and ContactType.
- `customer` consumes Address through CustomerAddress.
- `customer` consumes ContactType through CustomerContact.
- `sales` owns Transaction and TransactionItem.
- `payment`, `inventory`, and `shipping` consume applicable sales identities without assuming ownership of them.

The existence of a relationship must not be interpreted as transfer of entity responsibility.

---

### 12.2 Customer and Sales

The customer and sales domains interact when a commercial Transaction is associated with an identified registered Customer.

Conceptually:

```text
customer.Customer
        │
        └── 1:N ──► sales.Transaction
```

The relationship is optional from the Transaction perspective.

A Transaction may legitimately exist without a registered Customer when the business scenario permits an unidentified or guest buyer.

The customer domain remains responsible for Customer identity and master data.

The sales domain remains responsible for the commercial Transaction.

Customer information must not be duplicated inside the sales domain merely to avoid the cross-domain relationship when the authoritative Customer identity is available.

Likewise, the absence of a Customer relationship must not require the creation of an artificial generic Customer.

---

### 12.3 Catalog and Sales

The catalog and sales domains interact through ProductVariant.

Conceptually:

```text
catalog.Product
       │
       ▼
catalog.ProductVariant
       │
       └── 1:N ──► sales.TransactionItem
```

ProductVariant represents the specific sellable catalog identity.

TransactionItem represents the historical commercial fact that the variant was sold.

The sales domain consumes ProductVariant identity but preserves its own transaction-specific facts such as quantity, unit price, and unit discount.

This distinction allows the catalog to evolve without changing historical sales facts.

Conceptually:

```text
catalog
   │
   └── Product identity,
       characteristics,
       media and pricing

sales
   │
   └── Historical commercial fact
```

A later ProductVariant, attribute, media, or catalog-pricing change must not rewrite the commercial conditions already preserved by TransactionItem.

---

### 12.4 Catalog and Inventory

The inventory domain consumes ProductVariant identity.

Conceptually:

```text
catalog.ProductVariant
          │
          ├──► inventory.Inventory
          │
          ├──► inventory.InventoryMovement
          │
          └──► inventory.InventoryReservation
```

These relationships exist because inventory responsibility applies to the specific sellable variant rather than only to the broader Product identity.

The catalog domain remains authoritative for ProductVariant.

The inventory domain remains authoritative for:

- Current inventory state.
- Inventory movement history.
- Inventory reservation state.

A change to catalog information must not rewrite historical inventory events.

Likewise, inventory state must not be stored in ProductVariant merely because inventory consumes that catalog identity.

---

### 12.5 Sales and Inventory

The sales and inventory domains interact when inventory activity must be associated with a commercial TransactionItem.

Conceptually:

```text
sales.TransactionItem
        │
        ├──► inventory.InventoryReservation
        │
        └──► inventory.InventoryMovement
             when applicable
```

InventoryReservation associates reserved stock with the TransactionItem for which the reservation exists.

The current implemented model permits at most one InventoryReservation for a TransactionItem.

InventoryMovement may reference TransactionItem when the inventory event is associated with that commercial item.

The relationship is optional when the movement has no applicable sales origin.

The sales domain remains responsible for the purchased item.

The inventory domain remains responsible for stock reservation and physical inventory movement.

A commercial fact must not be rewritten to represent an inventory event.

Likewise, an inventory movement must not be inferred solely from a change in Transaction state when a persistent inventory event is required.

---

### 12.6 Sales and Payment

The payment domain consumes Transaction identity when recording financial activity.

Conceptually:

```text
sales.Transaction
        │
        └── 1:N ──► payment.Payment
                         │
                         └── 1:N ──► payment.PaymentRefund
```

A Transaction may have multiple Payment records because payment attempts and financial events have their own lifecycle.

Payment preserves the financial fact associated with the Transaction.

PaymentRefund preserves money returned against a previously recorded Payment.

The sales domain remains responsible for the commercial Transaction.

The payment domain remains responsible for the financial lifecycle.

Financial state must not be represented solely by TransactionStatus.

Likewise, a refund must not rewrite the original Transaction or Payment fact merely to represent the resulting financial correction.

---

### 12.7 Sales and Shipping

The shipping domain consumes Transaction identity when the commercial scenario requires physical fulfillment.

Conceptually:

```text
sales.Transaction
        │
        └── 0..1 ──► shipping.Shipment
```

A Transaction does not necessarily require Shipment.

A physical-store Transaction may legitimately complete without a shipping record.

Under the current AtlasCommerce model, a Transaction may have at most one Shipment.

Multiple delivery destinations therefore require separate Transactions.

The sales domain remains responsible for the commercial Transaction.

The shipping domain remains responsible for the logistics lifecycle.

ShipmentStatus must not replace TransactionStatus, and TransactionStatus must not be used as a substitute for the detailed logistics state owned by shipping.

---

### 12.8 Customer and Shipping

The shipping domain consumes CustomerAddress when a Shipment requires a delivery destination.

Conceptually:

```text
customer.Customer
        │
        ▼
customer.CustomerAddress
        │
        └── 1:N ──► shipping.Shipment
```

CustomerAddress represents the customer-owned relationship with the shared Address identity selected for commercial use.

Shipment references the CustomerAddress selected for that fulfillment operation.

The customer domain remains responsible for CustomerAddress.

The shipping domain remains responsible for Shipment.

Later changes to the customer's current address relationships must not rewrite the historical delivery-address relationship already referenced by an existing Shipment.

---

### 12.9 Reference and Customer

The customer domain consumes shared identities and classifications owned by `reference`.

The principal implemented relationships are:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        ▼
customer.Customer
```

and:

```text
reference.ContactType
        │
        ▼
customer.CustomerContact
        │
        ▼
customer.Customer
```

`reference.Address` provides the shared address identity.

`customer.CustomerAddress` owns the customer-specific relationship with that address.

`reference.ContactType` provides the controlled telephone-contact classification.

`customer.CustomerContact` owns the contact value and its relationship with the Customer.

Email is represented independently by `customer.CustomerEmail` and does not consume ContactType.

The customer domain must not duplicate shared reference identities merely because it consumes them.

Likewise, the reference domain must not assume ownership of customer-specific lifecycle state.

---

### 12.10 Reference and Other Domains

The `reference` domain may be consumed by other domains when shared information is required.

The principle is:

```text
reference
   │
   └── Shared authoritative identity
                │
                ▼
          Consuming domain
```

The fact that multiple domains use a controlled value does not automatically make that value a reference-domain entity.

Domain-specific controlled classifications remain owned by their respective domains.

Examples include:

```text
customer.CustomerType
customer.CustomerDocumentType
sales.TransactionStatus
sales.TransactionChannel
payment.PaymentStatus
payment.PaymentMethod
payment.PaymentRefundReason
inventory.InventoryMovementReason
inventory.InventoryReservationStatus
shipping.ShipmentMethod
shipping.ShipmentStatus
```

These structures may behave like lookup tables physically, but their semantic ownership remains domain-specific.

AtlasCommerce therefore does not use `reference` as a generic container for every controlled value.

---

### 12.11 Partition-Aware Cross-Domain Relationships

Some cross-domain relationships reference sales entities that participate in the AtlasCommerce partition-aware architecture.

In those cases, the complete implemented relationship may require both the stable technical identifier and the corresponding time-based component.

Conceptually:

```text
Sales Entity Identity
        +
Time-Based Component
        │
        ▼
Complete Referenced Key
        │
        ▼
Cross-Domain Relationship
```

Examples include relationships from:

```text
payment.Payment
        │
        └──► sales.Transaction

inventory.InventoryReservation
        │
        └──► sales.TransactionItem

shipping.Shipment
        │
        └──► sales.Transaction
```

Where applicable, InventoryMovement may also preserve the complete TransactionItem relationship required by the implemented relational definition.

The temporal component exists to preserve compatibility with the complete partition-aware relational architecture.

It does not create a second independent business identity.

The logical relationship remains between the consuming entity and the corresponding sales entity.

---

### 12.12 Cross-Domain Referential Integrity

Cross-domain relationships that form part of the persistent operational model must preserve referential integrity where required by the implemented relational design.

Conceptually:

```text
Owning Entity
     │
     └── Foreign Key Relationship
                  │
                  ▼
          Referenced Entity
```

A schema boundary does not weaken the integrity requirement.

For example, a relationship from `payment.Payment` to `sales.Transaction` remains a persistent relational dependency even though the entities belong to different schemas.

Cross-domain referential integrity ensures that:

- Referenced identities exist.
- Relationships do not point to nonexistent entities.
- Mandatory relationships remain mandatory.
- Optional relationships remain explicitly optional.
- Composite partition-aware relationships preserve their complete referenced identity.
- Domain ownership remains traceable.

The detailed foreign key definitions are governed by the implemented database and AtlasCommerce Database Standards.

---

### 12.13 Cross-Domain Lifecycle Independence

Related entities may have independent lifecycle states.

A relationship between domains does not imply that their statuses must always move together.

Conceptually:

```text
                  sales.Transaction
                     Commercial
                       State
                      /  |  \
                     /   |   \
                    ▼    ▼    ▼
              payment inventory shipping
              Financial Stock  Logistics
               State   State    State
```

For example:

- A Payment may be `APPROVED` while Shipment remains `PENDING`.
- A Shipment may be `DELIVERED` while Payment history still contains earlier declined attempts.
- An InventoryReservation may be closed while the Transaction remains commercially active.
- A returned Shipment may create later payment or inventory consequences without rewriting the original logistics fact.

Each domain must preserve the lifecycle state for which it is responsible.

Business processes may evaluate multiple domain states together, but the persistent model must not collapse them into one universal status.

---

### 12.14 Cross-Domain Historical Preservation

Cross-domain relationships must preserve historical meaning when referenced master data or operational state changes later.

Conceptually:

```text
Historical Operational Fact
          │
          └── References stable identity
                    │
                    ▼
             Referenced Domain
```

Examples include:

- TransactionItem preserving the ProductVariant sold even after catalog changes.
- TransactionItem preserving the price and discount applied to the sale independently from later catalog-price changes.
- Shipment preserving the CustomerAddress selected for delivery even after later customer-address changes.
- InventoryMovement preserving its relationship to the applicable TransactionItem when the movement originated from a commercial event.
- Payment preserving its relationship to the original Transaction even after refunds occur.

Historical facts must not be rewritten merely because current state in another domain changes.

This is essential to preserving traceability across the transactional model.

---

### 12.15 Cross-Domain Event Consequences

One business event may produce persistent consequences in multiple domains.

Conceptually:

```text
Business Event
      │
      ├──► sales consequence
      ├──► inventory consequence
      ├──► payment consequence
      └──► shipping consequence
```

Those consequences remain separate facts.

For example, a customer return may produce:

```text
Commercial consequence
        │
        └── sales

Financial consequence
        │
        └── payment.PaymentRefund

Inventory consequence
        │
        └── inventory.InventoryMovement

Fulfillment consequence
        │
        └── shipping
             when applicable
```

The existence of one consequence must not be used as a substitute for another when both are required by the operational model.

Each domain records the fact it owns.

Cross-domain business processes coordinate those facts without destroying their semantic independence.

---

### 12.16 No Cross-Domain Duplication of Authority

Cross-domain relationships must not create competing authoritative copies of the same entity.

Conceptually:

```text
Authoritative Entity
       │
       ├──► Domain A consumes
       ├──► Domain B consumes
       └──► Domain C consumes
```

AtlasCommerce therefore favors relationships over duplication when a persistent authoritative identity already exists.

For example:

- ProductVariant remains in `catalog`.
- Customer remains in `customer`.
- CustomerAddress remains in `customer`.
- Address remains in `reference`.
- ContactType remains in `reference`.
- Transaction remains in `sales`.
- TransactionItem remains in `sales`.

Consuming domains may preserve transaction-specific or operational facts derived from those identities when required by their own responsibility, but they must not silently become competing master-data sources.

---

### 12.17 Relationship Ownership

A cross-domain relationship is owned from the perspective of the entity that requires the dependency.

Conceptually:

```text
Referenced Domain
      │
      └── Owns referenced entity

Consuming Domain
      │
      └── Owns dependent relationship
```

For example:

```text
catalog.ProductVariant
      │
      └── owned by catalog

sales.TransactionItem
      │
      └── owns its relationship
          to ProductVariant
```

Likewise:

```text
sales.Transaction
      │
      └── owned by sales

payment.Payment
      │
      └── owns its relationship
          to Transaction
```

And:

```text
reference.ContactType
      │
      └── owned by reference

customer.CustomerContact
      │
      └── owns its relationship
          to ContactType
```

This distinction prevents ambiguity when determining which domain is responsible for maintaining a relationship and which remains responsible for the referenced entity.

---

### 12.18 Cross-Domain Change Coordination

A change to an entity or relationship may affect consumers in other domains.

Such changes must be evaluated according to established domain contracts.

Examples include changes to:

- Persistent identity.
- Key composition.
- Lifecycle semantics.
- Historical-preservation behavior.
- Optionality.
- Referential relationships.
- Shared reference structures.

A change in one domain must not silently invalidate another domain's persistent relationships.

Conceptually:

```text
Domain Change
     │
     ▼
Relationship Impact Analysis
     │
     ├── No cross-domain impact
     │
     └── Cross-domain impact
              │
              ▼
        Coordinated Change
```

Where implementation changes are required, they must follow the controlled migration and deployment principles defined by the AtlasCommerce Architecture and Database Standards.

---

### 12.19 Cross-Domain Relationship Summary

The principal implemented cross-domain relationships can be summarized as:

| Owning Entity | Referenced Entity | Relationship Meaning |
|---|---|---|
| `sales.Transaction` | `customer.Customer` | Identified registered Customer associated with the commercial Transaction when applicable |
| `sales.TransactionItem` | `catalog.ProductVariant` | Sellable variant purchased in the Transaction |
| `inventory.Inventory` | `catalog.ProductVariant` | Current inventory state of the sellable variant |
| `inventory.InventoryMovement` | `catalog.ProductVariant` | ProductVariant affected by the inventory movement |
| `inventory.InventoryMovement` | `sales.TransactionItem` | Commercial item associated with the movement when applicable |
| `inventory.InventoryReservation` | `sales.TransactionItem` | Commercial item for which inventory is reserved |
| `inventory.InventoryReservation` | `catalog.ProductVariant` | Sellable variant whose inventory is reserved |
| `payment.Payment` | `sales.Transaction` | Financial Payment associated with the commercial Transaction |
| `shipping.Shipment` | `sales.Transaction` | Fulfillment record associated with the Transaction when shipping is required |
| `shipping.Shipment` | `customer.CustomerAddress` | Customer address relationship selected for delivery |
| `customer.CustomerAddress` | `reference.Address` | Shared Address identity associated with the Customer |
| `customer.CustomerContact` | `reference.ContactType` | Controlled telephone-contact classification used by the CustomerContact |
| `reference.AdministrativeDivision` | `reference.Country` | Country containing the administrative division |
| `reference.City` | `reference.AdministrativeDivision` | Administrative division containing the City |
| `reference.Address` | `reference.City` | City associated with the Address |

This table is a logical summary.

It does not replace the implemented foreign key inventory or reproduce every controlled-domain relationship.

---

### 12.20 Cross-Domain Relationship Principle

AtlasCommerce uses cross-domain relationships to preserve a single authoritative relational model while maintaining explicit domain ownership.

For the current model:

- Domain boundaries define responsibility rather than isolation.
- Referencing an entity does not transfer ownership of that entity.
- Authoritative identities must not be duplicated solely to avoid cross-domain relationships.
- Customer may be consumed by sales without making every Transaction require an identified registered Customer.
- ProductVariant is consumed by sales and inventory while remaining owned by catalog.
- Address is consumed through CustomerAddress while remaining owned by reference.
- ContactType is consumed by CustomerContact while remaining owned by reference.
- CustomerAddress is consumed by shipping while remaining owned by customer.
- Transaction and TransactionItem are consumed by other operational domains while remaining owned by sales.
- Payment, inventory, shipping, and sales lifecycle states remain independent.
- Cross-domain historical facts must preserve their original meaning when current state changes elsewhere.
- Partition-aware relationships preserve the complete relational key required by the implemented physical architecture without changing semantic identity.
- A business event may create consequences in multiple domains, but each consequence remains owned by the domain responsible for that fact.
- Changes affecting cross-domain contracts require coordinated evaluation.
- Referential integrity protects persistent cross-domain relationships where required by the implemented model.

The central principle is:

> **AtlasCommerce integrates its domains through explicit relationships while preserving one authoritative owner for every persistent identity and responsibility.**

---

## 13. Historical and Lifecycle Principles

AtlasCommerce distinguishes current operational state from historical business facts.

Not every change to operational data has the same lifecycle meaning.

Some entities represent current state and may legitimately be updated as that state changes.

Other entities represent events, transactions, historical relationships, or versions whose original meaning must remain preserved after they are created.

The appropriate lifecycle behavior depends on the responsibility of the entity.

Conceptually:

```text
Persisted Operational Data
          │
          ├── Current State
          │       └── May evolve according to
          │           the entity lifecycle
          │
          └── Historical Fact
                  └── Preserved according to
                      historical semantics
```

AtlasCommerce does not apply append-only behavior universally.

Likewise, it does not treat all persisted data as freely mutable.

The lifecycle strategy must preserve the meaning of the data represented by each entity.

---

### 13.1 Current State and Historical Facts

Current-state entities represent the operational state that is valid now.

Historical entities represent facts that occurred or versions that were valid at a particular point in the business lifecycle.

Examples of current-state responsibilities include:

- Current Product lifecycle state.
- Current ProductVariant lifecycle state.
- Current inventory position.
- Current Payment lifecycle state.
- Current InventoryReservation lifecycle state.
- Current Shipment lifecycle state.
- Current active or primary customer contact relationships.

Examples of historical facts include:

- A completed commercial Transaction.
- The ProductVariant sold in a TransactionItem.
- The quantity and financial conditions recorded in a TransactionItem.
- An InventoryMovement.
- A Payment attempt or recorded financial event.
- A PaymentRefund.
- A historical ProductVariantPrice version.
- A Shipment associated with a Transaction.

The fact that a current-state entity changes does not authorize historical facts that referenced or resulted from its previous state to be rewritten.

---

### 13.2 Commercial Transaction Preservation

A confirmed commercial Transaction represents a historical business fact.

The commercial conditions recorded by its TransactionItems must remain interpretable independently from later changes elsewhere in AtlasCommerce.

Conceptually:

```text
catalog.ProductVariant
          │
          ▼
sales.TransactionItem
          │
          ├── Quantity
          ├── Unit Price
          └── Unit Discount
```

TransactionItem preserves the commercial facts applicable to the sale.

Later changes to:

- Product information.
- ProductVariant information.
- Product attributes.
- Product media.
- Catalog pricing.
- Inventory state.

must not rewrite the commercial conditions already persisted by the TransactionItem.

This separation allows the catalog to represent current and historical catalog information while sales preserves what actually occurred in the commercial transaction.

---

### 13.3 Catalog Price History

AtlasCommerce preserves ProductVariant price history through `catalog.ProductVariantPrice`.

Conceptually:

```text
catalog.ProductVariant
          │
          └── 1:N ──► catalog.ProductVariantPrice
```

ProductVariantPrice represents the lifecycle of catalog pricing for a ProductVariant.

A new price period is represented according to the implemented temporal pricing model rather than by treating the current ProductVariant row as the historical record of every price that has existed.

This allows AtlasCommerce to distinguish:

```text
Catalog Pricing History
          │
          └── ProductVariantPrice

Actual Selling Condition
          │
          └── sales.TransactionItem
```

These responsibilities are related but not interchangeable.

ProductVariantPrice answers questions about the catalog price applicable according to the pricing lifecycle.

TransactionItem preserves the price and discount actually applied to a specific commercial transaction.

A historical catalog price must not be inferred solely from TransactionItem because the price actually charged may differ from the applicable catalog price.

Likewise, changing catalog pricing must not alter historical TransactionItems.

---

### 13.4 Catalog Media Lifecycle

Catalog media follows the lifecycle defined by the implemented `catalog.ProductImage` model.

`ProductImage` is separate from Product because media content has a responsibility distinct from the core Product identity.

Conceptually:

```text
catalog.Product
      │
      └── ProductImage
```

This separation prevents product-media information from being treated as an intrinsic identity attribute of Product.

Historical behavior must follow the lifecycle actually implemented by `ProductImage`.

The existence of a separate table does not automatically mean that every media change must create an append-only historical version.

Likewise, lifecycle state must not be invented in the Domain Model when the implemented structure does not define such state.

---

### 13.5 Customer Relationship Lifecycle

Customer identity and customer-related information have independent lifecycle responsibilities.

Conceptually:

```text
customer.Customer
        │
        ├── CustomerDocument
        ├── CustomerContact
        ├── CustomerEmail
        └── CustomerAddress
```

Changing one customer-related relationship does not require replacing the Customer identity.

CustomerContact and CustomerEmail preserve their own operational lifecycle, including active and primary state where applicable.

CustomerAddress preserves the lifecycle of the relationship between a Customer and a shared `reference.Address` identity.

CustomerDocument preserves identification information associated with the Customer according to the implemented document model.

Historical preservation must occur where required by the lifecycle semantics of the applicable entity or relationship.

AtlasCommerce must not create artificial historical versions of Customer merely because one associated contact, email, document, or address relationship changes.

---

### 13.6 Address Historical Meaning

The geographic Address identity and the customer relationship with that Address have separate ownership.

Conceptually:

```text
reference.Address
        │
        ▼
customer.CustomerAddress
        │
        ▼
shipping.Shipment
```

`reference.Address` owns the shared address identity.

`customer.CustomerAddress` owns the relationship between a Customer and that Address.

`shipping.Shipment` consumes the CustomerAddress selected for the fulfillment operation.

Once a Shipment references the applicable CustomerAddress, later changes to the Customer's current address relationships must not silently change the historical meaning of the existing Shipment.

Historical fulfillment must remain traceable to the customer-address relationship used by that Shipment.

---

### 13.7 Inventory Current State and Movement History

Inventory intentionally separates current operational state from movement history.

Conceptually:

```text
inventory.Inventory
        │
        └── Current stock state

inventory.InventoryMovement
        │
        └── Historical inventory event
```

Inventory provides the state required for efficient operational stock management.

InventoryMovement explains the inventory events that affected that state.

A movement that has already occurred must not be rewritten merely because a later event reverses or compensates for its effect.

When the business model requires a compensating inventory event, the later event must be represented independently so that the original movement remains historically understandable.

InventoryMovementNote extends the contextual information of an InventoryMovement without changing the meaning of the movement itself.

The current Inventory state and movement history must remain consistent according to the inventory operations that produce them.

---

### 13.8 Inventory Reservation Lifecycle

InventoryReservation represents temporary allocation of stock to a TransactionItem.

Its lifecycle is distinct from both current physical inventory and permanent inventory movement history.

Conceptually:

```text
sales.TransactionItem
        │
        ▼
inventory.InventoryReservation
        │
        ├── reservation created
        ├── reservation active
        └── reservation closed
```

The reservation lifecycle must remain distinguishable from the physical movement of inventory.

Creating a reservation does not by itself represent the same business fact as an InventoryMovement.

Closing a reservation likewise does not erase the fact that the reservation existed.

Reservation state must therefore evolve according to the implemented reservation lifecycle while preserving the historical relationship with the TransactionItem for which the stock was reserved.

---

### 13.9 Payment History and Financial Corrections

Payment records preserve financial events associated with a Transaction.

Conceptually:

```text
sales.Transaction
        │
        ▼
payment.Payment
        │
        └── payment.PaymentRefund
```

A Payment may move through the lifecycle represented by PaymentStatus.

However, a later financial correction must not erase the fact that the original Payment occurred.

PaymentRefund therefore represents money returned against a Payment as a separate financial fact.

Conceptually:

```text
Original Payment
      │
      └── preserved
             │
             ▼
       PaymentRefund
             │
             └── later financial fact
```

A refund must not be represented by deleting the Payment, rewriting the Payment amount to hide the original transaction, or creating an artificial negative Payment when the implemented model provides a dedicated refund entity.

This preserves financial traceability.

---

### 13.10 Shipment Lifecycle

Shipment represents the fulfillment responsibility associated with a Transaction when physical delivery is required.

Conceptually:

```text
sales.Transaction
        │
        └── 0..1 ──► shipping.Shipment
```

The Shipment lifecycle is represented independently from the commercial lifecycle of the Transaction.

ShipmentStatus represents the logistics state owned by the shipping domain.

A change in ShipmentStatus must not rewrite the original commercial facts recorded by sales.

Likewise, a TransactionStatus change must not replace the logistics state maintained by Shipment.

Under the current model, a Transaction may have at most one Shipment.

The Shipment remains the persistent fulfillment entity for that Transaction when shipping is required.

Transactions completed directly at a physical store do not require an artificial Shipment solely to represent completion.

---

### 13.11 Independent Domain Lifecycles

A single business process may create related entities whose lifecycle states evolve independently.

Conceptually:

```text
                  sales.Transaction
                         │
             ┌───────────┼───────────┐
             │           │           │
             ▼           ▼           ▼
         inventory    payment     shipping
             │           │           │
             ▼           ▼           ▼
        Stock State  Financial   Logistics
                       State       State
```

For example, at a particular moment:

- A Transaction may be commercially confirmed.
- Its Payment may be approved.
- Its InventoryReservation may already be closed.
- The resulting inventory movement may already have occurred.
- Its Shipment may still be pending.

These states are not contradictory.

They represent different responsibilities in the same broader business process.

AtlasCommerce must therefore not introduce a universal status intended to replace the lifecycle state owned by each domain.

---

### 13.12 Controlled Values and Lifecycle Meaning

Controlled domain values frequently describe lifecycle state, but the meaning of those values remains local to the owning domain.

Examples include:

```text
sales.TransactionStatus
payment.PaymentStatus
inventory.InventoryReservationStatus
shipping.ShipmentStatus
```

These structures must not be interpreted as interchangeable merely because each contains status-like values.

For example:

```text
CONFIRMED
```

in a commercial lifecycle does not necessarily have the same meaning as an approved financial state or a completed logistics state.

Lifecycle semantics belong to the domain that owns the controlled classification.

This is why AtlasCommerce does not require a universal `reference.Status` abstraction for unrelated domain lifecycles.

---

### 13.13 Temporal Data Does Not Automatically Mean History

AtlasCommerce contains temporal values for multiple purposes.

A timestamp may represent:

- Creation time.
- Last-update time.
- Transaction time.
- Payment attempt time.
- Approval time.
- Cancellation time.
- Reservation time.
- Reservation expiration.
- Reservation closure.
- Inventory movement time.
- Shipment posting time.
- Shipment delivery time.
- Catalog-price validity.
- Another implemented lifecycle event.

The existence of a timestamp does not automatically make an entity an append-only historical table.

Likewise, `created_at` and `updated_at` metadata do not constitute a complete historical audit trail.

Temporal semantics must be interpreted according to the responsibility of the specific column and entity.

---

### 13.14 Audit Metadata and Business History

Standard creation and last-update metadata provide technical traceability of persisted records.

Conceptually:

```text
created_at
updated_at
```

These values answer technical lifecycle questions about the row.

They do not automatically answer business-history questions such as:

- What price was valid before the current price?
- Which inventory event changed the stock?
- Which Payment was refunded?
- Which customer address relationship was used by a Shipment?
- Which commercial conditions were applied to a TransactionItem?

Those questions require the applicable business entities and relationships.

AtlasCommerce therefore distinguishes technical row metadata from business history.

---

### 13.15 Historical Preservation and Referential Integrity

Historical preservation depends on stable relational meaning.

When a historical fact references another entity, later lifecycle changes must not cause that relationship to become semantically misleading.

Conceptually:

```text
Historical Fact
      │
      └──► Referenced Identity
```

The referenced identity may later change its current operational state without invalidating the historical relationship.

Examples include:

- TransactionItem referencing the ProductVariant that was sold.
- InventoryMovement referencing the ProductVariant affected by the movement.
- InventoryMovement referencing the applicable TransactionItem when required.
- Payment referencing the Transaction to which the financial event belongs.
- PaymentRefund referencing the Payment being refunded.
- Shipment referencing the Transaction it fulfills.
- Shipment referencing the CustomerAddress selected for delivery.

Referential integrity and lifecycle design must therefore operate together to preserve historical interpretation.

---

### 13.16 Corrections and Compensating Facts

When a historical business fact has already occurred, a later correction should normally preserve the original fact and represent the corrective event separately when the implemented domain model provides that mechanism.

Conceptually:

```text
Original Fact
      │
      └── preserved
             │
             ▼
      Corrective Fact
```

Examples include:

- InventoryMovement followed by a compensating inventory movement.
- Payment followed by PaymentRefund.
- A later catalog price period following an earlier ProductVariantPrice period.

This principle does not mean that every data correction requires a compensating row.

Incorrect technical data that never represented a legitimate business fact may require controlled correction.

The distinction depends on whether the persisted information represents an actual historical event or merely erroneous state.

Corrections affecting persisted production data must follow the applicable operational and migration controls.

---

### 13.17 Deletion and Historical Responsibility

Physical deletion must be evaluated according to the lifecycle and historical responsibility of the entity.

AtlasCommerce does not impose a universal rule that no row may ever be deleted.

However, data representing historical business facts or required relationships must not be physically deleted merely because it is no longer current.

Before deletion is considered, the model must determine whether the row represents:

- Current replaceable state.
- A historical business fact.
- A referenced identity.
- A lifecycle relationship.
- Deployment-managed controlled data.
- Technical metadata.
- Another persisted responsibility with retention requirements.

Deletion behavior must preserve referential integrity, historical interpretation, and applicable business requirements.

---

### 13.18 Operational History vs. Analytical History

AtlasCommerce preserves history required by the operational business model.

It does not manufacture every form of history that may later be useful analytically.

Conceptually:

```text
Operational History
      │
      └── Required by source-system semantics

Analytical History
      │
      └── Required by downstream analysis
```

Operational examples may include:

- Transaction and TransactionItem facts.
- ProductVariantPrice history.
- InventoryMovement history.
- Payment and PaymentRefund history.
- Historical customer relationships required by the operational model.

Future analytical requirements may additionally require:

- Periodic snapshots.
- Dimensional history.
- Slowly changing dimensions.
- Derived events.
- Analytical status transitions.
- Historical aggregations.
- Cross-source historical integration.

Those structures belong to the downstream data-engineering and analytical architecture unless their semantics are also required by the transactional source.

---

### 13.19 Lifecycle Changes Across Domains

A lifecycle change in one domain may create consequences in another domain without transferring ownership of either lifecycle.

Conceptually:

```text
Lifecycle Event
      │
      ├──► Owning-domain state change
      │
      └──► Cross-domain consequence
```

For example, a commercial, payment, inventory, or fulfillment event may require another domain to record a related fact.

The resulting records must remain semantically independent.

A payment event does not become an inventory event.

An inventory event does not become a commercial status.

A shipment event does not become a payment state.

The business process coordinates these responsibilities while each domain preserves the state and history it owns.

---

### 13.20 Historical and Lifecycle Principle

AtlasCommerce preserves the distinction between current operational state and historical business fact.

For the current model:

- Current-state entities may evolve according to their implemented lifecycle.

- Historical commercial facts must remain interpretable after later master-data changes.

- TransactionItem preserves the financial conditions actually applied to a sale.

- ProductVariantPrice preserves catalog-pricing history.

- Catalog price history and actual selling price are separate responsibilities.

- ProductImage follows the lifecycle defined by its implemented structure and must not be assumed to be append-only merely because it is represented separately from Product.

- Customer identity remains separate from the lifecycle of contacts, emails, documents, and address relationships.

- CustomerContact and CustomerEmail preserve their own active and primary state.

- Inventory preserves current stock state.

- InventoryMovement preserves inventory-event history.

- InventoryReservation preserves its lifecycle independently from physical inventory movement.

- Payment preserves financial events.

- PaymentRefund preserves subsequent money-return events without rewriting the original Payment.

- Shipment preserves fulfillment responsibility independently from Transaction lifecycle.

- A Transaction may have at most one Shipment under the current implemented model.

- Physical-store Transactions do not require artificial Shipment records.

- Domain-specific statuses preserve independent lifecycle meanings.

- Technical audit timestamps do not replace business history.

- Temporal columns must be interpreted according to their specific business or technical semantics.

- Corrections to legitimate historical facts should preserve the original fact when the implemented model provides a compensating mechanism.

- Operational history belongs in AtlasCommerce when required by source-system semantics.

- Analytical history belongs downstream when it exists solely for analytical requirements.

The central principle is:

> **Current state may evolve, but a business fact that must explain what actually happened must retain its historical meaning.**

---

## 14. Implemented Model vs Future Extensions

The AtlasCommerce Domain Model distinguishes explicitly between capabilities represented by the current validated database model and capabilities that may be introduced in future versions.

The existence of a business concept, technical possibility, or anticipated requirement does not mean that the corresponding structure belongs in the current implementation.

Likewise, a capability that has already become part of the validated AtlasCommerce model must no longer be described as a future extension.

Conceptually:

```text
AtlasCommerce Domain Model
          │
          ├── Implemented Model
          │       └── Current validated
          │           persistent structure
          │
          └── Future Extension
                  └── Introduced only when
                      justified by requirements
```

The distinction protects the current model from speculative complexity while preserving a clear path for controlled evolution.

---

### 14.1 Implemented Model

The implemented model represents the persistent structures currently established and validated as part of AtlasCommerce.

At the domain level, the implemented model includes:

```text
metadata
catalog
customer
inventory
payment
reference
sales
shipping
```

These domains collectively represent the current transactional source-system model.

The implemented model includes the entities, relationships, controlled domains, lifecycle structures, integrity rules, and applicable physical characteristics represented by the validated AtlasCommerce database.

Documentation describing implemented capabilities must remain synchronized with that validated implementation.

---

### 14.2 Implemented Catalog Capabilities

The current Catalog Domain includes the persistent structures required to represent:

- Brand.

- Product.

- ProductVariant.

- Category hierarchy.

- Product-to-category relationships.

- Product images.

- Product attributes.

- Controlled product-attribute values.

- ProductVariant-to-attribute-value relationships.

- ProductVariant pricing history.

Conceptually:

```text
catalog
│
├── Brand
├── Category
├── Product
├── ProductCategory
├── ProductImage
├── ProductVariant
├── ProductAttribute
├── ProductAttributeValue
├── ProductVariantAttributeValue
└── ProductVariantPrice
```

Capabilities represented by these entities are part of the current model and must not be described as merely planned future functionality.

In particular:

- Product images are part of the implemented catalog model.

- ProductVariant price history is part of the implemented catalog model.

- Variable ProductVariant characteristics are represented through the implemented attribute model.

- `ProductVariantAttributeValue` associates ProductVariant with controlled `ProductAttributeValue` records.

Future catalog capabilities must therefore extend this existing structure rather than being described as though these responsibilities were still absent.

---

### 14.3 Implemented Customer Capabilities

The current Customer Domain includes:

- CustomerType.
- Customer.
- CustomerDocument.
- CustomerDocumentType.
- CustomerContact.
- CustomerEmail.
- CustomerAddress.

Conceptually:

```text
customer
│
├── CustomerType
├── Customer
├── CustomerDocument
├── CustomerDocumentType
├── CustomerContact
├── CustomerEmail
└── CustomerAddress
```

The current model does not use an independent reusable Contact entity.

Telephone contact information is represented by CustomerContact.

Email information is represented independently by CustomerEmail.

CustomerContact consumes `reference.ContactType`.

CustomerAddress consumes `reference.Address`.

These structures represent the current implemented customer model and must not be replaced in documentation by earlier conceptual alternatives.

---

### 14.4 Implemented Reference Capabilities

The current Reference Domain includes:

- Country.
- AdministrativeDivision.
- City.
- Address.
- ContactType.

Conceptually:

```text
reference
│
├── Country
│      │
│      ▼
│   AdministrativeDivision
│      │
│      ▼
│     City
│      │
│      ▼
│   Address
│
└── ContactType
```

The current model does not require a generic `reference.Status` entity for unrelated lifecycle responsibilities.

Domain-specific lifecycle classifications remain within the domain that owns their meaning.

The geographic model may technically represent locations beyond the current commercial scope without implying that international commerce is currently implemented.

---

### 14.5 Implemented Sales Capabilities

The current Sales Domain includes:

- Transaction.
- TransactionItem.
- TransactionChannel.
- TransactionStatus.

Conceptually:

```text
sales
│
├── TransactionChannel
├── TransactionStatus
├── Transaction
└── TransactionItem
```

Transaction represents the commercial purchase.

TransactionItem represents the ProductVariant, quantity, unit price, and unit discount associated with the purchased item.

The current model permits a Transaction without an identified registered Customer when the applicable business scenario allows it.

The current sales model must not be documented using obsolete conceptual structures such as Order, OrderItem, or OrderItemCancellation when those entities are not part of the implemented AtlasCommerce database.

Future requirements involving additional commercial events must be evaluated against the implemented Transaction and TransactionItem model rather than automatically restoring earlier conceptual entities.

---

### 14.6 Implemented Inventory Capabilities

The current Inventory Domain includes:

- Inventory.
- InventoryMovementReason.
- InventoryMovement.
- InventoryMovementNote.
- InventoryReservationStatus.
- InventoryReservation.

Conceptually:

```text
inventory
│
├── Inventory
├── InventoryMovementReason
├── InventoryMovement
├── InventoryMovementNote
├── InventoryReservationStatus
└── InventoryReservation
```

The implemented model distinguishes:

- Current inventory state.
- Inventory movement history.
- Inventory movement context.
- Temporary inventory reservation state.

Inventory operates directly against ProductVariant.

Where applicable, inventory reservations and movements preserve relationships to TransactionItem according to the implemented relational model.

The current implementation does not require a Warehouse entity to represent inventory state.

A future requirement for multiple physical inventory locations must therefore be treated as an architectural extension rather than assumed to exist in the current model.

---

### 14.7 Implemented Payment Capabilities

The current Payment Domain includes:

- PaymentMethod.
- PaymentStatus.
- PaymentRefundReason.
- Payment.
- PaymentRefund.

Conceptually:

```text
payment
│
├── PaymentMethod
├── PaymentStatus
├── PaymentRefundReason
├── Payment
└── PaymentRefund
```

Payment represents financial activity associated with a Transaction.

PaymentRefund represents money returned against a previously recorded Payment.

The current model therefore already supports explicit refund persistence.

Refund functionality must not be described as a future capability when referring to the current validated AtlasCommerce model.

Future financial capabilities must extend the existing Payment and PaymentRefund responsibilities rather than replacing them with obsolete conceptual structures.

---

### 14.8 Implemented Shipping Capabilities

The current Shipping Domain includes:

- ShipmentMethod.
- ShipmentStatus.
- Shipment.

Conceptually:

```text
shipping
│
├── ShipmentMethod
├── ShipmentStatus
└── Shipment
```

Shipment represents physical fulfillment when a Transaction requires delivery.

The current model permits at most one Shipment per Transaction.

A Transaction completed directly at a physical store does not require a Shipment.

The current model does not implement:

- ShipmentItem.
- ShipmentEvent.
- ShipmentEventNote.
- ShipmentDeliveryEstimate.
- Carrier as an independent entity.
- Multiple Shipments for a single Transaction.
- Warehouse-based shipment splitting.

These concepts must therefore not be described as current AtlasCommerce capabilities.

If future fulfillment requirements justify them, they must be introduced through controlled model evolution.

---

### 14.9 Concepts Removed from the Current Model

Some concepts may have appeared during earlier modeling stages without becoming part of the final implemented model.

Such concepts must not remain documented as though they were current entities.

Examples include:

- Order.
- OrderItem.
- OrderItemCancellation.
- Warehouse.
- ShipmentItem.
- ShipmentEvent.
- ShipmentEventNote.
- ShipmentDeliveryEstimate.
- Independent reusable Contact.
- Generic shared Status.
- Earlier fulfillment models allowing multiple Shipments per commercial transaction.

These concepts remain useful as evidence of design exploration, but they do not define the current AtlasCommerce persistent model.

Documentation intended to describe the current system must use the implemented terminology and relationships.

Conceptually:

```text
Earlier Design Exploration
          │
          └── Does not automatically become
              current architecture

Validated Implementation
          │
          └── Defines the current model
```

A removed concept must not be reintroduced merely because it existed in an earlier draft.

Its reintroduction requires a current requirement and a new design decision.

---

### 14.10 Future Extensions Are Requirement-Driven

AtlasCommerce may evolve to support additional business and technical capabilities.

Potential future extensions may include requirements involving:

- Multiple inventory locations.
- Warehouse management.
- More complex fulfillment.
- Split shipments.
- Multiple delivery destinations.
- Carrier integration.
- Detailed logistics event history.
- Delivery-estimate history.
- Additional payment methods.
- Additional refund workflows.
- Additional customer classifications.
- Additional document types.
- Additional contact classifications.
- International commercial operation.
- Additional catalog capabilities.
- Additional pricing requirements.
- Additional operational history.
- Additional source-system integrations.

This list represents possible areas of evolution.

It is not a committed implementation roadmap.

A future capability must be introduced only when a concrete business, operational, integration, compliance, scalability, or analytical requirement justifies its addition to the transactional model.

---

### 14.11 Future Warehouse and Multi-Location Inventory

The current Inventory model does not introduce Warehouse as part of the implemented inventory identity.

If AtlasCommerce later requires independent inventory positions across multiple physical locations, the model may need to evolve.

Conceptually, a future requirement could introduce responsibilities such as:

```text
ProductVariant
      │
      ▼
Inventory Location
      │
      ▼
Location-Specific Inventory
```

However, the final design must be evaluated when the requirement exists.

The current model must not be prematurely designed around an unimplemented Warehouse abstraction.

Introducing multiple inventory locations could affect:

- Inventory identity.
- InventoryMovement.
- InventoryReservation.
- Fulfillment.
- Transfers.
- Referential relationships.
- Uniqueness.
- Indexing.
- Data migration.
- Downstream analytical semantics.

Such a change would therefore require coordinated architectural and data-model evolution.

---

### 14.12 Future Fulfillment Complexity

The current fulfillment model supports at most one Shipment per Transaction.

If future requirements introduce:

- Multiple origin locations.
- Partial fulfillment.
- Split shipments.
- Replacement shipments.
- Complementary shipments.
- Multiple delivery destinations.
- Shipment-level item allocation.

the current shipping model may require extension.

Conceptually:

```text
Current Model

Transaction
    │
    └── 0..1 Shipment


Possible Future Requirement

Transaction
    │
    ├── Shipment
    ├── Shipment
    └── Shipment
          │
          └── Item Allocation
```

This possible future structure is not part of the current model.

Its implementation would require explicit decisions regarding:

- Shipment identity.
- Transaction-to-Shipment cardinality.
- Item allocation.
- Inventory responsibility.
- Fulfillment completion.
- Shipping cost.
- Address relationships.
- Replacement fulfillment.
- Historical preservation.

The current model must not carry this complexity before the requirement exists.

---

### 14.13 Future Internationalization

The current geographic reference model can represent Country, AdministrativeDivision, City, and Address.

This does not mean that AtlasCommerce currently implements international commerce.

Expanding commercial operation beyond the current scope could require changes involving:

- Customer documents.
- Address requirements.
- Postal codes.
- Administrative divisions.
- Currency.
- Taxation.
- Payment methods.
- Payment processing.
- Shipping.
- Pricing.
- Localization.
- Regulatory requirements.

Conceptually:

```text
Geographic Capability
        ≠
International Commerce Capability
```

International operation must therefore be treated as a broader business and architectural extension rather than inferred from the existence of Country in the reference model.

---

### 14.14 Future Analytical Requirements

Future analytical requirements must not automatically expand the AtlasCommerce transactional model.

The downstream Atlas Engineering platform may require:

- Historical dimensions.
- Snapshots.
- Derived events.
- Analytical classifications.
- Aggregations.
- Data-quality structures.
- Cross-source identities.
- Analytical pricing interpretations.
- Customer segmentation.
- Fulfillment metrics.
- Inventory analytics.

These requirements belong downstream when they exist solely to support analytical consumption.

Conceptually:

```text
Operational Requirement
        │
        └── May justify AtlasCommerce change

Analytical Requirement
        │
        └── Normally implemented downstream
            unless source semantics require it
```

The transactional model should be extended for analytics only when the required information also represents a legitimate operational source-system responsibility.

---

### 14.15 Future Extraction and Integration Capabilities

AtlasCommerce is the transactional source system.

The mechanisms used to extract its data into downstream Atlas Engineering components are not defined by the Domain Model.

Future data-engineering phases may introduce:

- Incremental ingestion.
- Full or initial loads.
- Change-based extraction.
- Replicas or dedicated readable copies.
- Transaction-log-based mechanisms.
- Orchestration.
- Restartable ingestion boundaries.
- Data-quality validation.
- Observability.
- Additional source-system integration.

These capabilities belong to the data-engineering architecture.

They may impose source-consumption requirements, but they must not redefine the AtlasCommerce transactional model solely for implementation convenience.

---

### 14.16 Evolution of Implemented Capabilities

A future extension becomes part of the implemented model only after it has been:

```text
Required
   │
   ▼
Designed
   │
   ▼
Reviewed
   │
   ▼
Implemented
   │
   ▼
Validated
   │
   ▼
Documented as Implemented
```

Until that process is complete, the capability remains future direction rather than current AtlasCommerce behavior.

Once implemented and validated, documentation must be updated so that the capability is no longer described as merely future.

This prevents documentation from drifting in either direction:

- Describing nonexistent capabilities as implemented.
- Describing implemented capabilities as future work.

---

### 14.17 Model Simplification Principle

AtlasCommerce intentionally avoids speculative structures.

A possible future requirement is not sufficient reason to introduce an entity, relationship, column, status, or physical structure today.

Conceptually:

```text
Possible Future Need
        │
        ▼
Do not model automatically
        │
        ▼
Wait for concrete requirement
        │
        ▼
Design with evidence
```

This principle reduces:

- Unused entities.
- Unnecessary relationships.
- Artificial lifecycle states.
- Premature abstractions.
- Deployment complexity.
- Integrity complexity.
- Documentation burden.
- Migration burden caused by incorrect assumptions.

The objective is not to make the model minimal at any cost.

The objective is to make every implemented structure justifiable.

---

### 14.18 Compatibility with Future Evolution

Avoiding speculative design does not mean ignoring future evolution.

Current structures should preserve reasonable extensibility when that can be achieved without introducing unnecessary complexity.

For example:

- Domain ownership remains explicit.
- Controlled values use dedicated domain structures where justified.
- Shared geographic identities remain separated from consuming domains.
- Product characteristics use an extensible attribute model.
- Catalog pricing uses a dedicated temporal structure.
- PaymentRefund is separated from Payment.
- Inventory current state is separated from movement history.
- Shipping remains a distinct domain from sales.

These decisions allow future evolution without requiring the current model to implement every possible future capability in advance.

---

### 14.19 Documentation Evolution

As the model evolves, documentation must evolve with it.

When a future capability becomes implemented:

- The Domain Model must describe it as current.
- Architecture documentation must reflect any affected boundaries.
- Business Documentation must reflect applicable business behavior.
- Database Standards must be updated if new implementation conventions are introduced.
- Deployment must implement the required structures.
- Final Validation must validate the resulting expected state.

When an earlier proposed capability is abandoned, current documentation must not continue presenting it as planned merely because it appeared in an older design artifact.

Documentation must represent intentional current direction rather than preserve every historical design possibility.

---

### 14.20 Implemented Model vs Future Extensions Principle

AtlasCommerce distinguishes validated implementation from possible future evolution.

For the current model:

- The implemented database defines the current persistent structure after validation.

- Catalog includes ProductImage and ProductVariantPrice.

- Catalog pricing history is implemented.

- ProductVariant characteristics are associated through ProductVariantAttributeValue.

- CustomerEmail is implemented.

- CustomerContact exists without an independent reusable Contact entity.

- ContactType belongs to `reference`.

- A generic `reference.Status` entity is not part of the current model.

- PaymentRefund is implemented.

- InventoryReservation is implemented.

- InventoryMovement and InventoryMovementNote are implemented.

- Warehouse is not part of the current model.

- Inventory is not currently modeled per Warehouse.

- A Transaction may have at most one Shipment.

- Physical-store Transactions may legitimately have no Shipment.

- ShipmentItem and detailed shipment-event structures are not part of the current model.

- Earlier conceptual entities do not define current architecture merely because they appeared during design exploration.

- Possible future capabilities are not commitments.

- New transactional structures require concrete justification.

- Analytical requirements remain downstream unless they also represent operational source-system responsibilities.

- Once a future capability is implemented and validated, documentation must promote it from future direction to implemented model.

- Obsolete conceptual alternatives must not remain mixed with current implementation documentation.

The central principle is:

> **AtlasCommerce implements what the current operational model requires, preserves room for justified evolution, and does not turn hypothetical future requirements into present-day complexity.**

---

## Closing Principle

AtlasCommerce is the transactional source system of the Atlas Engineering platform.

Its Domain Model represents the persistent operational structure required to support the current retail business model while preserving explicit ownership, relational integrity, historical meaning, and controlled evolution.

The implemented model is organized into the following domains:

```text
AtlasCommerce
│
├── metadata
├── catalog
├── customer
├── inventory
├── payment
├── reference
├── sales
└── shipping
```

Each domain owns a distinct operational or technical responsibility.

Schemas establish ownership boundaries within one relational transactional database.

Those boundaries do not prevent cross-domain relationships when the persistent business model requires them.

---

### Domain Responsibility

The current AtlasCommerce model assigns responsibility according to the meaning and lifecycle of persisted data.

```text
metadata
    └── Technical database governance

catalog
    └── Product identity, classification,
        characteristics, media, and pricing

customer
    └── Customer identity and
        customer-specific master data

inventory
    └── Inventory state, movement history,
        movement context, and reservations

payment
    └── Payment execution, financial state,
        and refunds

reference
    └── Shared reference identities
        and classifications

sales
    └── Commercial Transactions
        and purchased items

shipping
    └── Physical fulfillment when
        delivery is required
```

An entity belongs to the domain responsible for its persistent meaning.

A relationship to an entity owned by another domain does not transfer ownership.

This allows AtlasCommerce to preserve a single authoritative representation of operational identities without sacrificing relational consistency.

---

### Commercial Truth

`sales.Transaction` and `sales.TransactionItem` preserve the commercial facts of a purchase.

Transaction represents the commercial operation.

TransactionItem preserves the ProductVariant, quantity, unit price, and unit discount applicable to the purchased item.

The commercial transaction remains distinct from:

- Customer master data.
- Current catalog state.
- Catalog pricing history.
- Inventory state.
- Inventory movement.
- Inventory reservation.
- Payment state.
- Refund events.
- Shipment state.

Related domains may record consequences of the same broader business process, but those consequences do not replace the original commercial facts.

A later change in another domain must not rewrite what was actually purchased.

---

### Operational Identity and Shared Responsibility

AtlasCommerce separates authoritative identity from its operational consumption.

Examples include:

```text
catalog.ProductVariant
        │
        ├──► sales.TransactionItem
        └──► inventory

customer.Customer
        │
        └──► sales.Transaction

reference.Address
        │
        └──► customer.CustomerAddress
                    │
                    └──► shipping.Shipment

reference.ContactType
        │
        └──► customer.CustomerContact

sales.Transaction
        │
        ├──► payment.Payment
        └──► shipping.Shipment
```

The referenced domain owns the identity.

The consuming domain owns the relationship or operational fact that depends on that identity.

AtlasCommerce therefore favors explicit relationships over duplicated authoritative data.

---

### Current State and History

The model distinguishes current operational state from historical business facts.

Current state may evolve when the lifecycle of the entity requires it.

Historical facts must preserve the meaning of what actually occurred.

Examples include:

```text
Inventory
    = current inventory state

InventoryMovement
    = inventory-event history


ProductVariantPrice
    = catalog-pricing history

TransactionItem
    = financial conditions actually
      applied to a sale


Payment
    = recorded financial event

PaymentRefund
    = subsequent money-return event
```

These structures serve different responsibilities and must not be treated as interchangeable merely because they describe related business processes.

Technical creation and update timestamps provide row-level traceability but do not replace business history.

---

### Independent Lifecycles

AtlasCommerce does not collapse unrelated operational lifecycles into a universal status.

Commercial, financial, inventory, reservation, customer-relationship, and logistics states remain owned by their respective domains.

Conceptually:

```text
                   Transaction
                       │
            ┌──────────┼──────────┐
            │          │          │
            ▼          ▼          ▼
        Inventory    Payment    Shipment
           State       State      State
```

These states may evolve at different times without creating an inconsistency.

A Payment may be approved while a Shipment remains pending.

An InventoryReservation may be closed while the commercial Transaction remains active.

A Shipment may be delivered while historical Payment attempts remain preserved.

The broader business process coordinates these states without requiring them to become one persisted lifecycle.

---

### Fulfillment Is Conditional

Shipping is an explicit but conditional AtlasCommerce responsibility.

Conceptually:

```text
Transaction
    │
    ├── ONLINE
    │      └── Exactly one Shipment
    │
    └── STORE
           └── Immediate product handoff
               without Shipment
```

Shipping participation is conditional at the Transaction-model level because AtlasCommerce supports both ONLINE and STORE channels.

Under the current implemented business model:

- An ONLINE Transaction requires exactly one Shipment.

- A STORE Transaction completes through immediate product handoff and does not generate a Shipment.

Across all Transactions, the generic relationship therefore remains:

```text
Transaction
    │
    └── 0..1 Shipment
```

Under the current implemented model, a Transaction may have at most one Shipment.

Multiple delivery destinations therefore require separate Transactions.

More complex fulfillment structures must not be assumed until a concrete requirement justifies extending the current model.

---

### Integrity and Historical Meaning

Persistent relationships must preserve both structural validity and business meaning.

Referential integrity protects the relationships required by the implemented relational model.

Historical preservation protects the interpretation of those relationships over time.

Where the partition-aware Sales architecture requires a time-based component as part of a complete referenced key, that component forms part of the implemented relational definition without becoming a second independent business identity.

Logical meaning and physical implementation therefore remain coordinated without being confused.

---

### Implemented Model and Future Evolution

The current Domain Model describes the validated AtlasCommerce implementation.

It must not be replaced by earlier conceptual structures merely because those structures appeared during design exploration.

Likewise, possible future capabilities must not be represented as current functionality before they are required, designed, implemented, and validated.

Conceptually:

```text
Requirement
    │
    ▼
Design
    │
    ▼
Implementation
    │
    ▼
Validation
    │
    ▼
Implemented Model
```

Possible future requirements may justify new entities, relationships, lifecycle structures, physical designs, or domain capabilities.

Those changes must be introduced because evidence or requirements justify them, not because the database is technically capable of supporting them.

The current model must remain understandable without carrying speculative complexity for hypothetical future scenarios.

---

### Source-System Boundary

AtlasCommerce defines operational truth for the transactional retail system.

It does not define the final analytical representation of that truth.

Conceptually:

```text
AtlasCommerce
Operational Truth
      │
      ▼
Controlled Extraction
      │
      ▼
Data Engineering
      │
      ▼
Analytical Platform
      │
      ▼
Analytical Consumption
```

Downstream platforms may reorganize, transform, enrich, historize, aggregate, or combine AtlasCommerce data according to analytical requirements.

Those transformations must preserve understandable lineage to the operational meaning represented by the source.

AtlasCommerce must not be redesigned solely to become an analytical presentation model.

Likewise, downstream analytical structures must not be assumed to reproduce the physical transactional model directly.

---

### Final Domain Model Principle

The AtlasCommerce Domain Model is governed by the following principles:

- AtlasCommerce is one relational transactional database organized into explicit domains.
- Each persistent entity has one primary owning domain.
- Schema boundaries establish responsibility rather than isolation.
- Cross-domain relationships preserve operational integration without transferring ownership.
- Shared authoritative identities must not be duplicated merely to avoid cross-domain relationships.
- ProductVariant represents the sellable catalog identity consumed by sales and inventory.
- ProductVariantPrice preserves catalog-pricing history.
- TransactionItem preserves the commercial conditions actually applied to a sale.
- Customer identity remains separate from documents, contacts, emails, and address relationships.
- ContactType is shared through the `reference` domain.
- CustomerContact and CustomerEmail are distinct customer responsibilities.
- Address remains a shared reference identity consumed through CustomerAddress.
- Inventory current state remains distinct from InventoryMovement history.
- InventoryReservation has its own lifecycle and does not replace physical inventory movement.
- Payment preserves financial events.
- PaymentRefund preserves money returned without rewriting the original Payment.
- Shipping participates in ONLINE Transactions, which require logistical fulfillment.
- A STORE Transaction completes through immediate product handoff and does not generate a Shipment.
- Across the complete Transaction model, a Transaction may have at most one Shipment.
- Commercial, financial, inventory, reservation, customer, and logistics lifecycles remain independently represented.
- Historical business facts must preserve their original meaning.
- Technical audit metadata does not replace business history.
- Partition-aware relational components support the physical architecture without redefining semantic identity.
- The implemented model takes precedence over obsolete conceptual drafts once the intended implementation has been validated.
- Future capabilities are introduced only when concrete requirements justify them.
- Analytical requirements remain downstream unless they also represent legitimate operational source-system responsibilities.
- Documentation must evolve together with the validated implementation.

The central principle is:

> **AtlasCommerce preserves operational truth through explicit ownership, relational integrity, independent domain lifecycles, historical meaning, and a model that implements current requirements without turning hypothetical future needs into present-day complexity.**