# AtlasCommerce Database Standards

# Índice

- [1. Purpose](#1-purpose)

- [2. Schema Organization](#2-schema-organization)

- [3. Table Naming](#3-table-naming)

- [4. Column Naming](#4-column-naming)

- [5. Table Prefix Registry](#5-table-prefix-registry)

- [6. Prefix Naming Rules](#6-prefix-naming-rules)
  - [6.1 Preferred Prefix Length](#61-preferred-prefix-length)
  - [6.2 Independent Related Entities](#62-independent-related-entities)
  - [6.3 Prefix Selection](#63-prefix-selection)
  - [6.4 Prefix Reuse](#64-prefix-reuse)
  - [6.5 Prefixes in Relationships](#65-prefixes-in-relationships)

- [7. Primary Key Standards](#7-primary-key-standards)
  - [7.1 Surrogate Primary Keys](#71-surrogate-primary-keys)
  - [7.2 Primary Key Data Type](#72-primary-key-data-type)
  - [7.3 Identity](#73-identity)
  - [7.4 Clustered Primary Keys](#74-clustered-primary-keys)
  - [7.5 Composite Primary Keys](#75-composite-primary-keys)
  - [7.6 Primary Key and Foreign Key Roles](#76-primary-key-and-foreign-key-roles)
  - [7.7 Tables Without a Primary Key](#77-tables-without-a-primary-key)

- [8. Foreign Key Standards](#8-foreign-key-standards)
  - [8.1 Foreign Key Column Definition](#81-foreign-key-column-definition)
  - [8.2 Optional Relationships](#82-optional-relationships)
  - [8.3 Multiple Relationships to the Same Table](#83-multiple-relationships-to-the-same-table)
  - [8.4 Foreign Key Columns and Constraints](#84-foreign-key-columns-and-constraints)
  - [8.5 Composite Foreign Keys](#85-composite-foreign-keys)
  - [8.6 Relationship Semantics](#86-relationship-semantics)

- [9. Object Documentation Standards](#9-object-documentation-standards)
  - [9.1 Table Documentation](#91-table-documentation)
  - [9.2 Column Documentation](#92-column-documentation)
  - [9.3 Primary Key Documentation](#93-primary-key-documentation)
  - [9.4 Foreign Key Documentation](#94-foreign-key-documentation)
    - [Composite Foreign Keys](#composite-foreign-keys)
  - [9.5 Audit Column Documentation](#95-audit-column-documentation)
  - [9.6 Documentation Maintenance](#96-documentation-maintenance)
  - [9.7 Documentation Source of Truth](#97-documentation-source-of-truth)

- [10. Constraint Standards](#10-constraint-standards)
  - [10.1 Primary Keys](#101-primary-keys)
  - [10.2 Default Constraints](#102-default-constraints)
    - [NOT NULL and DEFAULT](#not-null-and-default)
  - [10.3 Check Constraints](#103-check-constraints)
    - [Appropriate Use of CHECK Constraints](#appropriate-use-of-check-constraints)
    - [Check Constraint Validation](#check-constraint-validation)
  - [10.4 Unique Constraints](#104-unique-constraints)
    - [Single-Column Unique Constraints](#single-column-unique-constraints)
    - [Composite Unique Constraints](#composite-unique-constraints)
    - [Natural Business Identifiers](#natural-business-identifiers)
    - [UQ, IX, and UX](#uq-ix-and-ux)
    - [Unique Constraint Validation](#unique-constraint-validation)
  - [10.5 Foreign Keys](#105-foreign-keys)
    - [Composite Foreign Keys](#composite-foreign-keys-1)
    - [Referenced Keys](#referenced-keys)
    - [Column Compatibility](#column-compatibility)
    - [Referential Actions](#referential-actions)
    - [Dependency Validation](#dependency-validation)
    - [Enabled and Trusted State](#enabled-and-trusted-state)
    - [Foreign Key Divergence](#foreign-key-divergence)

- [11. Index Standards](#11-index-standards)
  - [11.1 Index Design](#111-index-design)
  - [11.2 Composite Indexes](#112-composite-indexes)
  - [11.3 Included Columns](#113-included-columns)
  - [11.4 Unique Indexes](#114-unique-indexes)
    - [Filtered Unique Indexes](#filtered-unique-indexes)
  - [11.5 Index Validation](#115-index-validation)
  - [11.6 Partitioned Indexes](#116-partitioned-indexes)
  - [11.7 Overlapping Indexes](#117-overlapping-indexes)
  - [11.8 Index Lifecycle](#118-index-lifecycle)

- [12. Deployment Standards](#12-deployment-standards)
  - [12.1 Deployment Status Messages](#121-deployment-status-messages)
  - [12.2 Validation Before Modification](#122-validation-before-modification)
  - [12.3 Non-Destructive Deployment](#123-non-destructive-deployment)
  - [12.4 Explicit Migrations](#124-explicit-migrations)
  - [12.5 Dependency Validation](#125-dependency-validation)
  - [12.6 Data Deployment](#126-data-deployment)
  - [12.7 Deployment Phases](#127-deployment-phases)
  - [12.8 Final Validation](#128-final-validation)
  - [12.9 Transactional Deployment](#129-transactional-deployment)
  - [12.10 Rerun Validation](#1210-rerun-validation)

- [13. Object Ordering Standards](#13-object-ordering-standards)
  - [13.1 Schema Ordering](#131-schema-ordering)
  - [13.2 Table Ordering](#132-table-ordering)
  - [13.3 Technical Ordering Exceptions](#133-technical-ordering-exceptions)
  - [13.4 Logical Order and Dependency Order](#134-logical-order-and-dependency-order)
  - [13.5 Ordering Within Deployment Phases](#135-ordering-within-deployment-phases)
  - [13.6 TablePrefix Registry Ordering](#136-tableprefix-registry-ordering)
  - [13.7 Column Ordering](#137-column-ordering)
    - [New NOT NULL Columns](#new-not-null-columns)
  - [13.8 Constraint and Index Ordering](#138-constraint-and-index-ordering)
  - [13.9 Ordering Consistency](#139-ordering-consistency)

- [Closing Principle](#closing-principle)

---

## 1. Purpose

This document defines the database design, naming, documentation, integrity, indexing, ordering, and deployment standards adopted by AtlasCommerce.

Its purpose is to ensure that database objects are created and maintained in a consistent, predictable, traceable, and rerunnable manner throughout the lifecycle of the platform.

These standards apply to database schemas, tables, columns, prefixes, keys, constraints, indexes, object documentation, physical placement, object ordering, and deployment scripts.

The standards defined in this document must be followed when creating new database objects or modifying existing ones.

When a previously documented convention differs from the consolidated database implementation, the validated AtlasCommerce deployment is the technical source of truth. The documentation must be synchronized with the implemented standard rather than forcing established database objects to conform to obsolete documentation.

---

## 2. Schema Organization

AtlasCommerce uses database schemas to organize objects according to their business domain or technical responsibility.

Each table must belong to the schema that best represents its primary business purpose.

Schemas must not be used only as naming containers. They represent logical boundaries within the database.

The following schemas are currently defined:

| Schema | Purpose |
|---|---|
| `catalog` | Product catalog, classification, variants, attributes, media, and pricing data |
| `customer` | Customer identity, documents, contacts, addresses, and related master data |
| `inventory` | Inventory position, movements, movement context, and stock reservation data |
| `metadata` | Technical metadata and database governance information |
| `payment` | Payments, payment methods, payment status, refunds, and refund reasons |
| `reference` | Shared reference data used across multiple business domains |
| `sales` | Sales transactions, transaction items, channels, and transaction status |
| `shipping` | Shipment, delivery method, delivery status, tracking, and freight data |

New schemas may be introduced when a new business domain or technical responsibility cannot be appropriately represented by an existing schema.

A new schema must not be created solely to accommodate a single table when that table logically belongs to an existing domain.

---

## 3. Table Naming

Table names must clearly represent the business or technical entity stored by the table.

Table names must:

- Use English.
- Use PascalCase.
- Use the singular form.
- Be descriptive and unambiguous.
- Avoid abbreviations unless the abbreviation is an established project standard.
- Not include the schema name in the table name.
- Not include the table prefix in the table name.

Examples:

| Schema | Valid Table Name |
|---|---|
| `metadata` | `TablePrefix` |
| `catalog` | `ProductVariant` |
| `customer` | `CustomerAddress` |
| `inventory` | `InventoryReservation` |
| `payment` | `PaymentRefund` |
| `sales` | `TransactionItem` |
| `shipping` | `ShipmentMethod` |

The fully qualified table name must always be considered the canonical object name:

`schema.TableName`

Examples:

`metadata.TablePrefix`

`catalog.ProductVariant`

`customer.CustomerAddress`

`inventory.InventoryReservation`

`payment.PaymentRefund`

`sales.TransactionItem`

`shipping.ShipmentMethod`

Tables representing the same conceptual entity must not be duplicated across schemas without an explicit architectural justification.

---

## 4. Column Naming

Column names must clearly represent the information stored by the column and must follow the prefix assigned to their owning table.

Every column, without exception, must begin with the registered prefix of its owning table, followed by an underscore:

`PFX_column_name`

No column may be created without the prefix assigned to its owning table.

Column names must:

- Use English.
- Use the registered table prefix in uppercase.
- Separate the prefix from the column name with an underscore.
- Use lowercase snake_case after the prefix.
- Be descriptive and unambiguous.
- Avoid unnecessary abbreviations.
- Use consistent terminology across the database.

Examples:

| Table | Prefix | Column |
|---|---|---|
| `metadata.TablePrefix` | `PFX` | `PFX_schema_name` |
| `customer.Customer` | `CST` | `CST_name` |
| `sales.Transaction` | `TRN` | `TRN_gross_amount` |
| `shipping.Shipment` | `SHP` | `SHP_tracking_code` |

A column that references another table must preserve both the owning table prefix and the referenced table prefix according to the Foreign Key Standards.

Example:

`TRN_TRNST_id`

Where:

- `TRN` identifies the owning table, `sales.Transaction`.
- `TRNST` identifies the referenced table, `sales.TransactionStatus`.
- `id` identifies the referenced key.

Another cross-domain example is:

`SHP_CSTAD_id`

Where:

- `SHP` identifies the owning table, `shipping.Shipment`.
- `CSTAD` identifies the referenced table, `customer.CustomerAddress`.
- `id` identifies the referenced key.

Foreign key column naming is defined in detail in Section 8.

---

## 5. Table Prefix Registry

AtlasCommerce maintains a centralized table prefix registry to guarantee that every table has a unique and permanently assigned prefix.

The registry is implemented through `metadata.TablePrefix` and acts as the authoritative source for table prefix assignments across the database.

A table prefix is part of the stable technical identity of a table.

Prefixes are used not only in column names, but also throughout primary keys, foreign keys, constraints, indexes, validation scripts, deployment output, and technical documentation.

Every table must have an assigned AtlasCommerce prefix before its database definition is designed and deployed.

The prefix assignment is registered in `metadata.TablePrefix` during the deployment-managed seed phase and must match the prefix already used by the table definition.

Once a prefix has been assigned to a table, it must never be reassigned to another table, even if the original table is later deactivated or removed.

Prefix records must not be physically deleted as part of normal database maintenance.

Historical assignments must be preserved to:

- Prevent prefix reuse.
- Preserve traceability.
- Maintain historical consistency in scripts and documentation.
- Avoid ambiguity when reviewing retired or legacy database objects.

The registry is authoritative for prefix ownership.

A prefix appearing in a script or document does not supersede the assignment recorded in `metadata.TablePrefix`.

If a discrepancy is found between documentation and the validated registry, the discrepancy must be investigated and the obsolete artifact corrected rather than silently reassigning the prefix.

---

## 6. Prefix Naming Rules

Table prefixes must provide a short, recognizable, unique, and stable identifier for each table in AtlasCommerce.

Prefixes must:

- Use uppercase ASCII letters from `A` through `Z`.
- Contain between two and five characters.
- Comply with the implemented `metadata.TablePrefix` integrity rules, which enforce both the two-to-five-character length and the uppercase `A` through `Z` format.
- Be unique across the entire database, regardless of schema.
- Be registered in `metadata.TablePrefix` before use.
- Never be reused after assignment, including prefixes associated with inactive or retired tables.
- Remain stable for the lifetime of the table unless an explicit architectural decision requires a controlled change.

---

### 6.1 Preferred Prefix Length

Three characters are the preferred standard for root or independent entities when a clear and meaningful abbreviation can be defined.

Examples:

| Table | Prefix |
|---|---|
| `Transaction` | `TRN` |
| `Product` | `PRD` |
| `Customer` | `CST` |
| `Inventory` | `INV` |
| `Payment` | `PAY` |
| `Shipment` | `SHP` |

Closely related or dependent tables should normally preserve a recognizable root when that produces a clear and unique identifier.

Five characters are a preferred standard for many such tables, but are not mandatory.

Examples:

| Table | Prefix |
|---|---|
| `TransactionItem` | `TRNIT` |
| `CustomerAddress` | `CSTAD` |
| `InventoryReservation` | `INVRE` |
| `PaymentRefund` | `PAYRF` |
| `ShipmentMethod` | `SHPMT` |

Other prefix lengths within the five-character maximum are permitted when they produce a clearer identifier.

Prefix length must not be treated as a rigid representation of hierarchy.

---

### 6.2 Independent Related Entities

Tables with an independent classificatory or reusable identity do not need to inherit the prefix of a related entity.

Examples:

| Table | Prefix |
|---|---|
| `CustomerDocumentType` | `DTP` |
| `ContactType` | `CTP` |

The relationship between tables must be represented by the data model, not artificially encoded into every prefix.

---

### 6.3 Prefix Selection

When defining a new prefix, the following priorities apply:

1. Uniqueness across AtlasCommerce.
2. Stability over the lifetime of the table.
3. Clear recognition of the table or entity.
4. Consistency with related prefixes when useful.
5. Brevity.

Clarity and uniqueness take precedence over artificially forcing a prefix to contain exactly three or five characters.

A prefix must not be selected only because it is short if another prefix represents the table more clearly.

Likewise, a prefix must not be extended solely to satisfy a preferred character count when the shorter form is already clear and unique.

---

### 6.4 Prefix Reuse

Prefix reuse is prohibited.

When a table is retired, renamed through a controlled architectural change, or otherwise removed from the active model, its historical prefix assignment must remain reserved.

An inactive prefix must not become available for assignment to another table.

This rule preserves the historical meaning of:

- Column names.
- Constraint names.
- Index names.
- Deployment logs.
- Source-control history.
- Technical documentation.
- Operational evidence.

---

### 6.5 Prefixes in Relationships

Foreign key columns should preserve both the owning-table prefix and the referenced-table prefix.

Example:

`TRNIT_TRN_id`

Where:

- `TRNIT` identifies `sales.TransactionItem`.
- `TRN` identifies `sales.Transaction`.
- `id` identifies the referenced key.

This convention makes relationship ownership visible directly from the column name while preserving the stable technical identity of both participating tables.

---

## 7. Primary Key Standards

Tables should have a primary key whenever a stable row identifier is required by the data model.

Primary keys are the default identification strategy for AtlasCommerce tables, but exceptions are allowed when the table semantics do not require an independent row identifier.

Primary key columns must:

- Follow the applicable standard column naming convention.
- Use the registered prefix of the owning table.
- Be defined as `NOT NULL`.
- Be created together with the table as part of its initial definition.
- Have standardized object documentation identifying their role in the primary key.

When a primary key uses a surrogate identifier, that identifier must use the suffix `_id`.

A composite primary key may instead consist entirely of columns whose names reflect their own semantic or relationship roles.

Primary key constraints must:

- Use an explicit and deterministic name.
- Follow the naming convention `PK_<PFX>`.
- Be validated as part of table deployment.
- Not be created, dropped, or replaced later by the separate constraint deployment phases.

Examples:

| Table | Prefix | Primary Key Constraint |
|---|---|---|
| `metadata.TablePrefix` | `PFX` | `PK_PFX` |
| `customer.Customer` | `CST` | `PK_CST` |
| `catalog.ProductVariant` | `PRDVA` | `PK_PRDVA` |
| `inventory.InventoryReservation` | `INVRE` | `PK_INVRE` |
| `payment.Payment` | `PAY` | `PK_PAY` |
| `sales.Transaction` | `TRN` | `PK_TRN` |

---

### 7.1 Surrogate Primary Keys

Primary keys should normally use a surrogate numeric identifier when the table requires an independent row identity.

Natural business identifiers should generally be modeled as regular columns with appropriate unique constraints rather than used as the primary key.

This separates stable technical identity from business identifiers whose meaning, format, or lifecycle may evolve independently.

---

### 7.2 Primary Key Data Type

The primary key data type must be selected according to the nature, expected cardinality, and growth of the table.

AtlasCommerce does not require a single numeric type for every primary key.

The selected type must provide sufficient capacity for the expected lifetime of the table without introducing unnecessary storage overhead.

The choice of `TINYINT`, `SMALLINT`, `INT`, `BIGINT`, or another justified type must therefore be based on the characteristics of the object rather than a universal rule.

---

### 7.3 Identity

Numeric surrogate primary keys should normally use:

`IDENTITY(1,1)`

unless the table design requires a different key-generation strategy.

`IDENTITY(1,1)` is the AtlasCommerce default for numeric surrogate identifiers, not an unconditional requirement for every primary key.

Any alternative key-generation strategy must be explicitly justified by the data model or architecture.

---

### 7.4 Clustered Primary Keys

`PRIMARY KEY CLUSTERED` is the current AtlasCommerce default.

However, clustering is a physical design decision and must not be treated as an unconditional characteristic of every primary key.

A different clustering strategy may be used when explicitly justified by:

- Partitioning requirements.
- Access patterns.
- Physical data organization.
- Workload characteristics.
- Another documented architectural requirement.

The expected clustering definition is part of the primary key state and must be validated during deployment.

---

### 7.5 Composite Primary Keys

A table may use a composite primary key when required by the logical data model or physical database design.

Composite primary keys use the same constraint naming convention:

`PK_<PFX>`

The constraint name identifies the primary key of the table and must not concatenate the names of all participating columns.

The number, identity, and order of participating columns are part of the expected primary key definition.

Partitioned transactional tables may require a temporal or partitioning component in addition to the surrogate identifier.

When this occurs, the complete implemented key definition must be validated during deployment.

---

### 7.6 Primary Key and Foreign Key Roles

A primary key column may also participate in a foreign key relationship when required by a one-to-one or identifying relationship.

When a column performs both roles, its object documentation must describe both responsibilities.

---

### 7.7 Tables Without a Primary Key

Tables that intentionally do not require a primary key are permitted when justified by their technical or architectural purpose.

The absence of a primary key must be an explicit design decision rather than an accidental omission.

A table must not receive an artificial primary key solely to satisfy a convention when no independent row identity is required by the model.

---

## 8. Foreign Key Standards

Foreign key columns must clearly identify both the table that owns the column and the table referenced by the relationship.

The standard foreign key column naming format is:

`OWN_REF_id`

Where:

- `OWN` is the complete registered prefix of the owning table.
- `REF` is the complete registered prefix of the referenced table.
- `id` identifies the referenced key.

Example:

`TRN_TRNST_id`

Where:

- `TRN` identifies the owning table, `sales.Transaction`.
- `TRNST` identifies the referenced table, `sales.TransactionStatus`.
- `id` identifies `TRNST_id`.

Another cross-domain example is:

`SHP_CSTAD_id`

Where:

- `SHP` identifies the owning table, `shipping.Shipment`.
- `CSTAD` identifies the referenced table, `customer.CustomerAddress`.
- `id` identifies `CSTAD_id`.

---

### 8.1 Foreign Key Column Definition

Foreign key columns must:

- Follow the applicable standard column naming convention.
- Identify the referenced table through its registered prefix when the column represents the referenced identifier.
- Use a definition compatible with the corresponding referenced key column.
- Be `NOT NULL` when the relationship is mandatory.
- Allow `NULL` only when the relationship is explicitly optional in the data model.
- Have object documentation consistent with the implemented documentation standard.

The standard `OWN_REF_id` convention applies to the identifier component of a relationship.

Additional columns participating in a composite foreign key must preserve the naming convention appropriate to their own semantic role and are not required to use the `_REF_id` pattern.

Compatibility includes the relevant characteristics of the referenced key definition.

Depending on the data type, this may include:

- Data type.
- Length.
- Precision.
- Scale.

Foreign key column definitions must not rely on implicit conversions to compensate for incompatible definitions.

---

### 8.2 Optional Relationships

Nullability represents the optionality of the relationship.

A mandatory relationship uses a `NOT NULL` foreign key column.

An optional relationship may use a nullable foreign key column when the absence of the referenced entity is a valid state in the data model.

`NULL` must not be introduced merely to simplify deployment or application behavior.

---

### 8.3 Multiple Relationships to the Same Table

When a table contains multiple foreign keys referencing the same table, a descriptive qualifier may be used when necessary to distinguish the business role of each relationship.

Format:

`OWN_qualifier_REF_id`

The qualifier must:

- Use English.
- Use lowercase snake_case.
- Describe the semantic role of the relationship.
- Be used only when necessary to remove ambiguity.

Illustrative example:

`ABC_origin_ADR_id`

`ABC_destination_ADR_id`

These examples illustrate the naming rule and do not represent required AtlasCommerce objects.

A qualifier must not be added when the normal `OWN_REF_id` format already identifies the relationship unambiguously.

---

### 8.4 Foreign Key Columns and Constraints

Foreign key columns are part of the table structure and must be created together with the table.

The foreign key constraint itself is created separately during the Foreign Key Constraints deployment phase.

This separation allows tables to be created in predictable logical order while referential dependencies are validated and established later.

The foreign key constraint naming standard is defined in Section 10.5.

---

### 8.5 Composite Foreign Keys

A relationship may require more than one local and referenced column.

Composite foreign keys preserve the normal naming convention of each participating column.

The foreign key constraint represents the relationship between the two tables and must not concatenate every participating column into its name.

Examples in the implemented AtlasCommerce model include relationships from:

- `payment.Payment` to `sales.Transaction`.
- `inventory.InventoryReservation` to `sales.TransactionItem`.

In these relationships, the transaction timestamp participates in the foreign key in addition to the identifier.

For a composite foreign key, the following are part of the expected definition:

- Number of participating columns.
- Owning columns.
- Referenced columns.
- Correspondence between owning and referenced columns.
- Column order.
- Compatible column definitions.

A composite foreign key must not be considered equivalent merely because it contains the expected columns in a different order.

The `OWN_REF_id` convention applies to the identifier component when present.

Additional components, such as temporal columns required by a composite candidate key or partition-aware relationship, retain the naming convention appropriate to their semantic role.

---

### 8.6 Relationship Semantics

A foreign key must represent a relationship that belongs to the persistent data model.

Foreign keys must not be introduced solely to simplify a query or application implementation.

The existence of a foreign key also does not automatically imply that a corresponding performance index is required.

Referential integrity and indexing are separate design decisions:

- Foreign keys protect relationships.
- Indexes support access patterns.

Index requirements are defined separately in Section 11.

---

## 9. Object Documentation Standards

Database tables and columns must include technical documentation that explains why the object exists and its role within the AtlasCommerce data model.

Object documentation complements, but does not replace, business and architecture documentation.

Database object descriptions must remain focused on the technical role and semantic responsibility of the object within the data model.

Documentation must:

- Use English.
- Be concise and technically meaningful.
- Explain why the object exists and what it represents.
- Provide information beyond what can already be inferred from the object name.
- Use consistent terminology across the database.
- Be updated whenever the meaning or responsibility of the documented object changes.
- Avoid volatile implementation details unless they are essential to understanding the object.

Required object documentation is part of the expected database definition.

A permanent table or column without its required documentation is incomplete even when the physical object exists.

---

### 9.1 Table Documentation

Every permanent table must have a description explaining why the table exists and its responsibility within the data model.

A table description must provide enough context to understand the purpose of the table without requiring the reader to infer that purpose solely from its name.

Example:

`metadata.TablePrefix`

`Maintains the authoritative registry of table prefixes used to enforce naming consistency, prevent prefix reuse, and preserve prefix assignment history across AtlasCommerce.`

Table descriptions must focus on the responsibility of the table rather than enumerate implementation details that are already represented by its columns, constraints, or indexes.

---

### 9.2 Column Documentation

Every column of a permanent table must have a description.

A column description must explain the semantic responsibility of the column rather than merely repeat or expand the column name.

For example, a description such as:

`Stores the prefix.`

does not provide sufficient information for a column named `PFX_prefix`.

The description should instead explain the role of the value within the model.

Column documentation must remain consistent with:

- The owning table responsibility.
- The data represented by the column.
- Relationship semantics when the column participates in a foreign key.
- Lifecycle semantics when the column represents an audit timestamp.
- The implemented object definition.

---

### 9.3 Primary Key Documentation

A column whose sole key role is the primary key identifier uses the standardized description format:

`Primary key of <schema>.<TableName>.`

Example:

`PFX_id`

`Primary key of metadata.TablePrefix.`

The description identifies the technical role of the column without adding unnecessary narrative.

When a primary key column also participates in a foreign key or performs another semantic role, its documentation must describe the applicable responsibilities according to the implemented object-documentation standard rather than forcing the primary-key-only literal.

---

### 9.4 Foreign Key Documentation

Foreign key descriptions must follow the literal conventions implemented by the AtlasCommerce object-documentation scripts.

For simple foreign keys, the current implementation uses concise descriptions identifying the referenced table.

Examples:

`Foreign key of customer.CustomerType.`

`Foreign key of payment.Payment.`

The description must identify the semantic relationship represented by the column without unnecessarily reproducing implementation details already expressed by the foreign key constraint.

When a descriptive qualifier is required to distinguish multiple relationships to the same referenced table, the documentation must also make the business role of the relationship clear.

#### Composite Foreign Keys

When a foreign key contains multiple columns, each participating column must document its specific role in the composite relationship.

Identifier and temporal components must be distinguishable when applicable.

For example, a composite relationship may contain:

- An identifier component referencing the identifier portion of the candidate key.
- A transaction timestamp component referencing the temporal portion of the candidate key.

The exact description text used for implemented foreign key columns is defined by the object-documentation deployment scripts.

The object-documentation deployment scripts are the source of truth for expected description literals, and Final Validation must remain synchronized with those definitions.

---

### 9.5 Audit Column Documentation

Lifecycle audit timestamp columns use standardized descriptions whenever the generic lifecycle semantics apply.

For a standard `<PFX>_created_at` column, the default description is:

`Records the date and time when the row was initially created.`

For a standard `<PFX>_updated_at` column, the default description is:

`Records the date and time of the most recent meaningful modification to the row.`

A table may use a more specific lifecycle description when the semantic role of the row requires additional context.

The object-documentation deployment script remains the source of truth for the exact expected description.

The word `meaningful` is intentional.

`updated_at` represents the most recent meaningful modification to the persisted row and must not be interpreted as a requirement to change the timestamp for every technical operation regardless of semantic impact.

---

### 9.6 Documentation Maintenance

Object documentation is maintained with the same level of control as the database object itself.

The standard deployment behavior is:

| Current State | Deployment Behavior |
|---|---|
| Expected documentation is missing | Create the documentation when the documented object exists |
| Existing documentation matches | Validate without modification |
| Existing documentation diverges | Report the divergence and preserve the existing value |

The standard deployment must not automatically overwrite divergent documentation.

A divergence may represent:

- An obsolete database description.
- An obsolete expected definition.
- A deliberate manual change.
- A semantic change that has not yet been synchronized across the project.
- Another condition requiring human review.

The deployment does not have sufficient context to decide automatically which side of a documentation divergence is authoritative.

Expected and existing descriptions should therefore be reported when practical so the discrepancy can be reviewed.

Correction of divergent documentation requires an intentional and controlled change.

---

### 9.7 Documentation Source of Truth

Object documentation must remain synchronized across:

- Object-documentation deployment scripts.
- Final Validation.
- Database Standards.
- Architecture documentation where applicable.
- Business documentation where the same concept is described at the business level.

These artifacts serve different purposes and must not be treated as interchangeable.

The object-documentation deployment scripts define the exact technical descriptions expected in the database.

Final Validation independently verifies that the deployed descriptions match those expectations.

Database Standards define the conventions used to create and maintain those descriptions.

Business and architecture documentation provide broader context and must not be copied wholesale into database extended properties.

When an older documentation artifact conflicts with the validated consolidated database implementation, the implemented and validated database definition must be investigated first.

If the implementation is confirmed to represent the current AtlasCommerce standard, the obsolete documentation must be synchronized with it rather than modifying established database objects solely to preserve an outdated document.

---

## 10. Constraint Standards

Database constraints must be explicitly defined, consistently named, and independently validated during deployment.

Constraints must:

- Use explicit and deterministic names.
- Follow the AtlasCommerce constraint naming standards.
- Be validated before creation.
- Never be duplicated on rerun.
- Never be automatically dropped or replaced when an unexpected definition is found.
- Report divergences.
- Be created separately from the table definition, except for primary keys.
- Be treated as data-integrity rules rather than performance mechanisms.

Existence by name alone is not sufficient validation.

Validation must consider both object identity and the characteristics that form part of the expected definition.

A functionally equivalent constraint with an unexpected name must be reported as a naming divergence.

A naming divergence does not make the unexpected object the expected constraint.

Deployment may preserve the existing object for controlled review, but validation must continue to distinguish the expected constraint identity from a functionally equivalent object with a different name.

The standard deployment must not automatically rename, drop, or recreate the object solely to force its name to match the expected convention.

The standard constraint deployment order is:

1. Primary Keys — created and validated as part of table deployment.
2. Default Constraints.
3. Check Constraints.
4. Unique Constraints.
5. Foreign Key Constraints.

Performance-oriented indexes are governed separately by Section 11.

---

### 10.1 Primary Keys

Primary key constraint standards are defined in Section 7.

The standard primary key constraint naming format is:

`PK_<PFX>`

Examples:

- `PK_PFX`
- `PK_CST`
- `PK_PRDVA`
- `PK_PAY`
- `PK_INVRE`
- `PK_TRN`

Primary keys are created together with their owning tables and validated as part of table deployment.

They are not created by the later constraint deployment phases.

Primary key validation must consider the complete expected definition, including when applicable:

- Constraint name.
- Participating columns.
- Column order.
- Clustering.
- Partitioning-related components.
- Other explicitly standardized characteristics of the implemented primary key.

Composite primary keys use the same `PK_<PFX>` naming convention.

The constraint name identifies the primary key of the table and must not concatenate all participating column names.

---

### 10.2 Default Constraints

Default constraints define a legitimate initial value that the database can assign when a value is not explicitly provided during row creation.

A default constraint represents an intentional initial state.

It does not define automatic behavior for subsequent updates.

The standard naming format is:

`DF_<PFX>_<column_name>`

The table prefix must not be repeated in the column portion of the constraint name.

Example:

`PFX_is_active`

becomes:

`DF_PFX_is_active`

and not:

`DF_PFX_PFX_is_active`

Another implemented example is:

`TRNIT_unit_discount`

with:

`DF_TRNIT_unit_discount`

and an initial default value of:

`0.00`

Lifecycle audit timestamps may use:

`SYSDATETIME()`

as their standard initial default when defined by the applicable table design.

#### NOT NULL and DEFAULT

`NOT NULL` and DEFAULT represent different design decisions.

`NOT NULL` means:

> A value is required.

DEFAULT means:

> The database knows the semantically correct initial value when no value is explicitly supplied.

A mandatory column does not automatically require a default constraint.

Default constraints must not manufacture placeholder values solely to avoid `NULL` or satisfy a `NOT NULL` definition.

Examples of artificial values that must not be introduced without a legitimate business meaning include:

- Empty strings representing unknown text.
- Arbitrary numeric values representing unknown identifiers.
- Artificial historical dates representing unknown timestamps.
- Status values selected only to satisfy nullability.

Default constraints are created during their dedicated deployment phase.

Validation must verify:

- Owning table.
- Owning column.
- Expected constraint name.
- Expected default expression.

An existing divergent DEFAULT must be reported and preserved for controlled review.

Default-expression comparison must account for SQL Server metadata representation so that syntactic formatting differences do not by themselves create a false semantic divergence.

---

### 10.3 Check Constraints

Check constraints enforce permanent data-integrity rules that must remain true for valid stored data.

The standard naming format is:

`CK_<PFX>_<rule_name>`

The rule name must:

- Use English.
- Use lowercase snake_case.
- Describe the integrity rule.
- Avoid simply concatenating all participating column names.
- Avoid meaningless numeric suffixes.

Examples:

- `CK_PFX_prefix_format`
- `CK_PFX_prefix_length`
- `CK_PRDVP_valid_period`
- `CK_CSTAD_primary_active`
- `CK_TRN_discount_not_greater_than_gross_amount`

A check constraint may validate:

- A single column.
- A relationship among multiple columns of the same row.

The constraint name should describe the rule being protected.

For example:

`CK_TRN_discount_not_greater_than_gross_amount`

communicates the protected integrity rule more clearly than a name constructed only from the participating column names.

Numeric suffixes used solely to distinguish otherwise ambiguous rules are not permitted.

Examples such as:

`CK_PFX_prefix_1`

`CK_PFX_prefix_2`

must be replaced by meaningful rule names.

#### Appropriate Use of CHECK Constraints

CHECK constraints must protect invariant data rules.

A CHECK is appropriate when violating the rule would make the persisted data structurally or semantically invalid regardless of which application, interface, process, or deployment inserted the row.

CHECK constraints must not be used merely to duplicate:

- Temporary application behavior.
- User-interface validation.
- Process-specific rules.
- Validation whose semantics depend on external context not represented by the row.

#### Check Constraint Validation

Validation must verify:

- Owning table.
- Expected constraint name.
- Expected rule definition.
- Enabled state.
- Trusted state.

An AtlasCommerce CHECK constraint is fully valid only when it is enabled and trusted.

A newly created CHECK constraint must validate existing data so that the resulting constraint is trusted from its initial state.

An existing constraint with the expected name but a divergent definition must be reported and preserved rather than automatically dropped and recreated.

---

### 10.4 Unique Constraints

Unique constraints enforce uniqueness that is required by the data model.

The standard naming format is:

`UQ_<PFX>_<rule_name>`

The rule name must describe the uniqueness rule and must not unnecessarily repeat the table prefix.

Examples:

- `UQ_BRD_name`
- `UQ_PRDVA_sku`
- `UQ_PRD_brand_name`
- `UQ_CTG_parent_name`
- `UQ_TRNCH_code`

A unique constraint may contain one or multiple columns.

#### Single-Column Unique Constraints

When a single column clearly represents the uniqueness rule, the semantic portion of the column name may be used without repeating the table prefix.

Example:

`PRDVA_sku`

becomes:

`UQ_PRDVA_sku`

and not:

`UQ_PRDVA_PRDVA_sku`

#### Composite Unique Constraints

A composite unique constraint may contain multiple columns when the uniqueness rule applies to their combination.

The constraint name should describe the semantic rule rather than concatenate every participating column.

Examples:

`UQ_PRD_brand_name`

`UQ_CTG_parent_name`

The number, identity, and order of participating columns are part of the expected constraint definition.

A composite UQ must not be considered equivalent merely because it contains the expected columns in a different order.

#### Natural Business Identifiers

Natural business identifiers that are not used as primary keys should use a unique constraint when duplicate values would violate the data model.

For example:

`PRDVA_sku`

uses:

`UQ_PRDVA_sku`

The surrogate primary key provides stable technical row identity, while the unique constraint protects the business identifier.

#### UQ, IX, and UX

AtlasCommerce distinguishes data-integrity constraints from physical access structures.

| Prefix | Object | Primary Purpose |
|---|---|---|
| `UQ_` | Unique Constraint | Unconditional data-model uniqueness |
| `IX_` | Non-Unique Index | Performance and access |
| `UX_` | Unique Index | Index-based uniqueness, including conditional or filtered uniqueness when required by the model |

The ability of an object to prevent duplicate values does not by itself determine which object type must be used.

The primary question is:

> Why does the uniqueness requirement exist?

If duplicate values would represent an invalid state of the data model, the rule must normally be represented by a Unique Constraint:

`UQ_`

If uniqueness requires index-specific capabilities, such as a filtered predicate, the rule may be implemented as a Unique Index:

`UX_`

Non-unique performance-oriented access structures use:

`IX_`

A `UX_` must not be used as a substitute for a `UQ_` merely because SQL Server can enforce uniqueness through both mechanisms.

Unique indexes are governed in detail by Section 11.

#### Unique Constraint Validation

Validation must verify:

- Owning table.
- Expected constraint name.
- Participating columns.
- Column order.
- Enabled state.
- Expected physical placement, including filegroup when explicitly defined by the implementation.

AtlasCommerce Unique Constraints deployed on the standard structural storage are expected to be enabled and placed on `FG_CORE` unless another physical design is explicitly defined.

A unique index containing the same columns as an expected Unique Constraint remains a different object type.

Such a condition must be reported as an object-type mismatch rather than silently treated as a valid UQ.

When a functionally equivalent Unique Index exists in place of the expected Unique Constraint, the standard deployment must preserve the existing index and must not create a duplicate Unique Constraint automatically.

The condition must remain visible as an object-type mismatch for controlled review.

An existing divergent Unique Constraint must be preserved for controlled review.

---

### 10.5 Foreign Keys

Foreign key constraints enforce referential integrity for relationships explicitly defined by the AtlasCommerce data model.

The standard naming format is:

`FK_<OWN>_<REF>`

Where:

- `OWN` is the complete registered prefix of the owning table.
- `REF` is the complete registered prefix of the referenced table.

Examples:

- `FK_TRN_TRNST`
- `FK_PRDVA_PRD`
- `FK_SHP_CSTAD`
- `FK_PAY_TRN`
- `FK_INVRE_TRNIT`

When multiple relationships between the same pair of tables require a qualifier, the constraint naming format is:

`FK_<OWN>_<qualifier>_<REF>`

The qualifier must follow the same semantic principles defined for qualified foreign key columns in Section 8.

#### Composite Foreign Keys

Composite foreign keys use the same relationship-oriented naming convention.

The constraint name identifies the relationship between the owning and referenced tables and must not concatenate every participating column.

For example, a composite relationship from:

`payment.Payment`

to:

`sales.Transaction`

continues to use a concise relationship-oriented constraint name:

`FK_PAY_TRN`

The number, identity, correspondence, and order of participating columns are part of the expected foreign key definition.

#### Referenced Keys

A foreign key may reference:

- A primary key.
- Another candidate key whose uniqueness is explicitly guaranteed by the data model.

The referenced columns must therefore form an appropriate unique candidate key.

The existence of the referenced columns alone is not sufficient.

#### Column Compatibility

Participating foreign key columns must have compatible definitions.

Validation must consider relevant type characteristics, including when applicable:

- Data type.
- Length.
- Precision.
- Scale.

Foreign key relationships must not depend on implicit conversion between incompatible definitions.

#### Referential Actions

Referential actions must be explicitly evaluated for each relationship.

Cascading actions are not the default AtlasCommerce behavior.

Actions such as:

`ON DELETE CASCADE`

`ON UPDATE CASCADE`

`ON DELETE SET NULL`

or similar automatic behaviors may be used only when they accurately represent an intentional and documented lifecycle rule.

Cascade behavior must not be introduced solely to simplify application code or administrative operations.

When no automatic referential action is required, the relationship preserves the restrictive database-engine behavior.

The current AtlasCommerce foreign key implementation uses `NO ACTION` for both `ON DELETE` and `ON UPDATE` unless a relationship explicitly defines another documented lifecycle behavior.

#### Dependency Validation

Before creating a foreign key, deployment must validate the required dependencies.

Depending on the relationship, validation includes:

- Owning table.
- Owning columns.
- Referenced table.
- Referenced columns.
- Referenced primary or candidate key.
- Compatible column definitions.
- Number of participating columns.
- Correspondence between owning and referenced columns.
- Column order.
- Referential actions.

A foreign key must not be created when a required dependency is missing or incompatible.

#### Enabled and Trusted State

An AtlasCommerce foreign key is fully valid only when it is:

- Enabled.
- Trusted.

A foreign key that exists but is disabled or not trusted does not represent the expected final state.

New foreign keys must validate existing data so that the resulting constraint is trusted from its initial state.

#### Foreign Key Divergence

The existence of a foreign key with the expected name is not sufficient validation.

An existing FK may still diverge in:

- Owning columns.
- Referenced table.
- Referenced columns.
- Column correspondence.
- Column order.
- Referenced candidate key.
- Referential actions.
- Enabled state.
- Trusted state.

A foreign key that exists with the expected relationship but is disabled or not trusted is a divergent foreign key state and must not be reported as fully valid.

An existing foreign key with a divergent definition must be reported.

The standard deployment must not automatically drop and recreate the FK solely to force it into the expected state.

Correction requires an intentional and controlled change.

---

## 11. Index Standards

Indexes governed by this section are physical access structures created to support query performance, access patterns, or index-based uniqueness requirements that cannot be appropriately represented by a Unique Constraint.

Non-unique indexes are performance-oriented access structures.

Unique indexes may additionally enforce conditional or filtered uniqueness required by the data model.

Indexes must not be created merely because a column exists, because a column participates in a foreign key, or because a column appears in a query.

Every performance-oriented index must have an identified access pattern or technical justification.

AtlasCommerce uses two naming conventions for index objects:

`IX_<PFX>_<purpose>`

for non-unique indexes, and:

`UX_<PFX>_<purpose>`

for unique indexes used either as performance-oriented access structures with an index-level uniqueness requirement or to implement index-based uniqueness rules such as filtered uniqueness.

Where:

- `PFX` is the registered prefix of the owning table.
- `purpose` describes the access pattern or technical purpose supported by the index.

The purpose portion must use English and lowercase snake_case.

The index name should communicate why the index exists rather than automatically concatenate every participating column.

Indexes must:

- Use explicit and deterministic names.
- Follow the AtlasCommerce index naming standards.
- Be created separately during the index deployment phase.
- Be validated before creation.
- Never be duplicated on rerun.
- Never be automatically dropped, moved, or replaced when a divergent definition is found.
- Be justified by an access pattern, measurable technical requirement, or index-based uniqueness rule that cannot be appropriately represented by a Unique Constraint.
- Consider both read benefit and write/maintenance cost.
- Be reviewed when the workload that justified them changes.

The existence of a foreign key does not automatically require a corresponding index.

Foreign keys and indexes serve different purposes:

- Foreign keys protect referential integrity.
- Indexes support access patterns and performance.

An index must therefore be justified independently of the constraint or column that it may support.

---

### 11.1 Index Design

Index design must be based on the access pattern or index-based uniqueness rule the index is intended to support.

The following characteristics must be evaluated when applicable:

- Key columns.
- Key-column order.
- Sort direction.
- Included columns.
- Selectivity.
- Expected cardinality and growth.
- Join patterns.
- Filtering patterns.
- Ordering requirements.
- Read workload.
- Write workload.
- Existing overlapping indexes.
- Storage cost.
- Maintenance cost.
- Physical placement.
- Partitioning requirements.

A column must not automatically receive an index merely because it is frequently used in a query.

The complete workload and the existing physical design must be considered.

An index that improves one access pattern may increase the cost of:

- `INSERT`.
- `UPDATE`.
- `DELETE`.
- Storage.
- Memory usage.
- Index maintenance.

Index design must therefore balance read benefit against the cost introduced to the rest of the workload.

---

### 11.2 Composite Indexes

Composite indexes may contain multiple key columns when required by the access pattern.

The order of key columns is part of the index definition.

An index defined as:

`(A, B)`

must not automatically be considered equivalent to:

`(B, A)`

even when both indexes contain the same columns.

Sort direction is also part of the expected definition.

For example:

`A ASC, B DESC`

is not automatically equivalent to:

`A ASC, B ASC`

The index name should describe the supported access pattern rather than concatenate every key column.

This allows the name to remain meaningful even when the physical definition contains multiple columns.

Composite indexes must be designed according to the expected access pattern rather than according to the visual order of columns in the owning table.

---

### 11.3 Included Columns

Included columns may be used when they provide a justified performance benefit without unnecessarily expanding the index key.

Included columns are not part of the index key, but they are part of the expected AtlasCommerce index definition.

When an index uses included columns, deployment validation must verify the expected included-column set.

Included columns must not be added mechanically.

An index must not accumulate included columns solely to eliminate every possible lookup.

The benefit of covering an access pattern must be balanced against:

- Increased index size.
- Additional write cost.
- Additional maintenance cost.
- Additional storage requirements.
- Overlap with existing indexes.

The absence of a Key Lookup is not, by itself, sufficient justification for continuously expanding an index.

---

### 11.4 Unique Indexes

Unique indexes use the naming convention:

`UX_<PFX>_<purpose>`

A `UX_` may represent either:

- A performance-oriented access structure whose physical definition intentionally requires uniqueness.
- An index-based uniqueness rule, such as conditional or filtered uniqueness, that cannot be appropriately represented by a normal Unique Constraint.

A unique index remains an index.

It must not be used as a substitute for a Unique Constraint when uniqueness is fundamentally a required rule of the data model.

AtlasCommerce therefore distinguishes:

| Prefix | Object | Primary Purpose |
|---|---|---|
| `UQ_` | Unique Constraint | Unconditional data-model uniqueness |
| `IX_` | Non-Unique Index | Performance and access |
| `UX_` | Unique Index | Index-based uniqueness, including conditional or filtered uniqueness when required by the model |

The primary design question is not:

> Can this object prevent duplicate values?

The primary question is:

> Why must the uniqueness exist?

If duplicate values would represent an invalid state of the data model, the rule should normally be represented by:

`UQ_`

If uniqueness requires index-specific capabilities, such as a filtered predicate, the rule may be implemented as a Unique Index:

`UX_`

A performance-oriented index whose physical definition intentionally requires uniqueness may also use:

`UX_`

A `UX_` must not be used as a substitute for a `UQ_` merely because SQL Server can enforce unconditional uniqueness through both mechanisms.

#### Filtered Unique Indexes

A filtered unique index may be used when the required uniqueness depends on a predicate that cannot be represented by a normal Unique Constraint.

In that case, the object remains an index and is deployed during the index phase.

The filter predicate is part of the expected index definition.

The implemented `catalog.ProductImage` rules provide examples in which filtered unique indexes enforce conditional uniqueness associated with image roles.

These indexes must be validated as indexes and must not be treated as Unique Constraints solely because they enforce uniqueness.

---

### 11.5 Index Validation

Index validation must evaluate the characteristics that form part of the implemented expected definition.

Depending on the index, validation includes:

- Owning table.
- Expected index name.
- Index type.
- Enabled state.
- Key columns.
- Key-column order.
- Sort direction.
- Included columns.
- Uniqueness.
- Filter predicate.
- Relevant index options.
- Data space.
- Filegroup.
- Partition scheme.
- Partitioning column.
- Partition alignment.

Existence by name alone is not sufficient.

An index with the expected name but a different definition or an unexpected disabled state is a divergence.

Likewise, an index with an equivalent or similar definition but an unexpected name may represent a naming divergence.

The standard deployment must report these conditions and preserve the existing object for controlled review.

It must not automatically:

- Drop the index.
- Recreate the index.
- Rename the index.
- Move the index.
- Change its physical placement.
- Change its partitioning strategy.

Such changes require an intentional and controlled operation.

---

### 11.6 Partitioned Indexes

Indexes on partitioned tables must respect the physical partitioning strategy defined for the owning table.

When an index is expected to be partition-aligned, the following characteristics are part of its expected definition:

- Partition scheme.
- Data space.
- Partitioning column.
- Required alignment with the owning table.
- Other physical characteristics explicitly defined by the implemented index deployment.

An index must not be considered fully valid solely because its logical key and included columns match when its required physical placement differs.

Partition alignment is part of the physical architecture and must therefore be validated when applicable.

A physically divergent existing index must not be automatically moved, dropped, or recreated by the standard deployment.

Correction of physical-placement divergence requires a controlled change.

Non-partitioned indexes must likewise be validated against their expected physical placement when the deployment explicitly defines one.

---

### 11.7 Overlapping Indexes

Index design must consider indexes that already exist on the owning table.

A new index must not be created solely because its exact definition does not already exist.

Before introducing a new index, the design must evaluate whether an existing index already supports the required access pattern wholly or sufficiently.

Potential overlap includes:

- Identical key prefixes.
- Similar composite keys.
- Included-column coverage.
- Existing unique indexes.
- Existing constraint-backed indexes.
- Partitioned indexes supporting the same access path.

An overlapping index may still be justified when the workload demonstrates a meaningful benefit, but the duplication must be intentional.

The goal is not to minimize the number of indexes at all costs.

The goal is to avoid unnecessary physical structures whose maintenance cost is not justified by their benefit.

---

### 11.8 Index Lifecycle

An index must not be considered permanent solely because it was useful when originally introduced.

Workloads evolve.

An index may become:

- More important.
- Less important.
- Redundant.
- Ineffective.
- Unnecessarily expensive.
- Superseded by another access strategy.

Indexes should therefore be reviewed using workload evidence.

An index may be modified or retired when evidence shows that its original justification no longer applies.

Such changes must be intentional and controlled.

The standard deployment must not automatically remove an index merely because current deployment logic no longer expects it.

Operational index-maintenance policies such as rebuild or reorganize thresholds are outside the scope of this document and must be defined separately.

---

## 12. Deployment Standards

AtlasCommerce database deployment scripts must be rerunnable, predictable, traceable, and safe to execute against both new and existing environments.

A rerunnable deployment is not a self-healing deployment.

Rerunnable means that the same deployment can be executed again without blindly duplicating objects, data, constraints, indexes, or documentation.

It does not mean that the deployment is authorized to automatically force every existing object into the expected state.

The standard deployment behavior is:

| Current State | Deployment Behavior |
|---|---|
| Object does not exist | Create it when dependencies and safety conditions are satisfied |
| Object exists and matches the expected definition | Validate it without unnecessary modification |
| Object exists but diverges from the expected definition | Report the divergence and preserve the existing object for controlled review |
| A required dependency is missing or incompatible | Report the condition and prevent the affected unsafe operation |

The deployment must prefer explicit diagnosis over silent correction.

A technically possible automatic correction is not necessarily an appropriate deployment action.

---

### 12.1 Deployment Status Messages

Deployment output must use the consolidated AtlasCommerce message conventions implemented by the current deployment scripts.

Messages must clearly communicate the action performed or the state validated.

The current deployment uses semantic messages and visual status markers rather than relying on the obsolete generic conventions such as:

`[OK]`

or:

`[CREATE]`

The exact output vocabulary and symbols must remain synchronized with the implemented deployment scripts.

Examples of semantic deployment messages include states such as:

- Object created.
- Object already exists.
- Dependency validated.
- Column validated.
- Primary key validated.
- Constraint validated.
- Index validated.
- Documentation validated.
- Divergence detected.
- Validation failed.

The wording must identify the relevant object whenever practical.

Deployment output should remain predictable and visually consistent across schemas, tables, constraints, indexes, and validation phases.

Diagnostic information required to understand deployment behavior must be written to the SQL Server Messages stream.

Deployment diagnostics must not depend on result-set grids.

This allows the execution output to be captured and preserved as deployment evidence independently of the client interface used to execute the scripts.

---

### 12.2 Validation Before Modification

The current database state must be evaluated before any modification is performed.

Existence alone is not sufficient validation when additional characteristics form part of the expected object definition.

Validation must evaluate all characteristics defined by the applicable AtlasCommerce standard for the object being processed.

Depending on the object type, this may include:

- Schema.
- Object name.
- Object type.
- Column definition.
- Data type.
- Length.
- Precision.
- Scale.
- Nullability.
- Identity definition.
- Primary key definition.
- Constraint definition.
- Constraint enabled state.
- Constraint trusted state.
- Index enabled state.
- Column order.
- Sort direction.
- Included columns.
- Uniqueness.
- Filter predicates.
- Object documentation.
- Data space.
- Filegroup.
- Partition scheme.
- Partition alignment.
- Other explicitly standardized characteristics.

Object-specific standards define which characteristics form part of the expected state.

The deployment must validate those characteristics before deciding whether creation, validation, warning, or error behavior is appropriate.

---

### 12.3 Non-Destructive Deployment

The standard AtlasCommerce deployment is non-destructive by default.

It must not automatically:

- Drop tables.
- Drop columns.
- Drop existing constraints solely because they diverge.
- Drop existing indexes solely because they diverge.
- Rename divergent objects.
- Perform unsafe incompatible data-type changes.
- Reduce column length.
- Reduce numeric precision or scale.
- Change nullability when existing data may be affected.
- Move indexes automatically between physical storage structures.
- Change partitioning strategy automatically.
- Delete existing business data.
- Overwrite divergent object documentation.
- Rewrite existing deterministic data merely to force conformity without an explicit controlled change.

The deployment must not assume that the expected definition is automatically authorized to replace the existing definition.

A divergence may indicate:

- An obsolete environment.
- An obsolete deployment expectation.
- A controlled manual change.
- A previous migration.
- An incomplete deployment.
- A production-specific condition.
- Another state requiring investigation.

The deployment must report enough information to support that investigation.

The fact that a correction is technically possible does not make it appropriate for the standard deployment.

---

### 12.4 Explicit Migrations

Potentially destructive or state-transforming changes require an explicit controlled migration.

Examples include:

- Incompatible data-type changes.
- Column-length reductions.
- Precision or scale reductions.
- Changes from nullable to `NOT NULL` when data already exists.
- Replacement of divergent constraints.
- Replacement or physical movement of indexes.
- Changes to partitioning strategy.
- Data transformations required by a model change.
- Removal of obsolete database objects.
- Other operations that may affect existing persisted state.

A migration should document:

- Reason for the change.
- Objects affected.
- Expected previous state.
- Expected final state.
- Data impact.
- Dependencies.
- Required preconditions.
- Validation before the change.
- Validation after the change.
- Failure and recovery considerations when applicable.

A migration must be intentionally invoked.

The standard rerunnable deployment must not silently convert a detected divergence into an implicit migration.

---

### 12.5 Dependency Validation

An object must not be created when a required dependency is missing or incompatible.

Dependencies must be validated before the affected operation.

Depending on the object, dependencies may include:

- Database schema.
- Owning table.
- Referenced table.
- Required columns.
- Primary key.
- Candidate key.
- Constraint.
- Supporting index.
- Data space.
- Filegroup.
- Partition function.
- Partition scheme.
- Other physical or logical infrastructure.

Dependency validation must evaluate compatibility where compatibility forms part of the relationship.

The existence of an object with the expected name does not automatically mean that it satisfies the dependency.

For example, a foreign key dependency requires an appropriate referenced key, not merely the existence of the referenced columns.

Likewise, a partitioned object requires the expected physical partitioning infrastructure rather than merely an object with a matching name.

When a dependency cannot be safely validated, the affected operation must not continue as though the dependency were valid.

---

### 12.6 Data Deployment

This section governs deterministic deployment-managed data.

Examples include:

- Metadata.
- Reference data.
- Controlled lookup values.
- Seed data required by the database model.

Operational business-data ingestion is a separate concern and is not part of database object deployment.

Deployment-managed data must follow the same non-destructive principles used for database objects.

Deployment-managed data must have a deterministic identity that allows the deployment to distinguish an expected row from other existing data.

The standard behavior is:

| Current State | Deployment Behavior |
|---|---|
| Expected row does not exist | Insert it when dependencies and deterministic identity are valid |
| Existing row matches the expected deterministic definition | Validate it without modification |
| Existing row diverges | Report the divergence and preserve the existing row unless an explicit controlled change authorizes modification |

Seed deployment must not silently overwrite an existing divergent row merely because the deployment contains a different expected value.

The deployment must distinguish between:

- Deterministic values that define the expected row.
- Lifecycle values that legitimately differ after the row has been created.

Historical lifecycle timestamps must not be compared with newly generated timestamps as though they were deterministic seed values.

For example, an existing `created_at` value must not be considered divergent merely because a new deployment execution would generate a different current timestamp.

Changes to existing controlled data must be intentional and must preserve the historical and semantic meaning of the affected row.

---

### 12.7 Deployment Phases

AtlasCommerce deployment is organized into explicit phases.

The phase structure exists to:

- Make dependencies predictable.
- Separate object responsibilities.
- Support independent validation.
- Improve execution traceability.
- Preserve logical organization.
- Make rerun behavior easier to understand and diagnose.

The consolidated deployment follows a dependency-aware sequence that includes:

1. Schema and database prerequisites.
2. Partitioning infrastructure.
3. Tables and Primary Keys.
4. Object Documentation.
5. Seed, reference, and metadata data.
6. Default Constraints.
7. Check Constraints.
8. Unique Constraints.
9. Foreign Key Constraints.
10. Indexes.
11. Specialized temporal or integrity validation where applicable.
12. Final Validation.

The exact orchestration, script names, include order, and literal phase names are defined by the current SQLCMD deployment scripts.

Those scripts are the technical source of truth for the implemented deployment sequence.

The Standards document defines the architectural responsibility of the phases and must remain synchronized with the implementation.

An object must be deployed in the phase responsible for its object type or technical responsibility.

Logical alphabetical ordering must not move an object into an inappropriate deployment phase.

---

### 12.8 Final Validation

Every complete AtlasCommerce deployment must finish with an independent validation of the expected database state.

Final Validation is not merely a summary of messages emitted by earlier deployment phases.

It must independently query and evaluate the consolidated state of the database.

A previous phase reporting successful creation or validation does not eliminate the need for Final Validation.

Depending on the table and its applicable definitions, Final Validation evaluates categories such as:

- Table.
- Primary Key.
- Columns.
- Object Documentation.
- Seed Data.
- Default Constraints.
- Check Constraints.
- Unique Constraints.
- Foreign Key Constraints.
- Additional Indexes.
- Temporal Integrity.
- Other explicitly implemented validation categories.

A category that does not apply to a table must use the standardized non-applicable state defined by the implemented Final Validation scripts.

Final Validation must distinguish between:

- Valid expected state.
- Non-applicable state.
- Divergent state.
- Missing required state.
- Validation failure.

The exact output vocabulary must remain synchronized with the consolidated Final Validation implementation.

A deployment that finishes without a SQL runtime error is not automatically a successful deployment.

Deployment success requires that the expected AtlasCommerce state has been independently validated and that no unresolved condition prevents the environment from satisfying the required standards.

---

### 12.9 Transactional Deployment

The coordinated AtlasCommerce deployment must use an explicit transactional strategy.

Operations that form a single atomic deployment unit should not leave the database in a partially committed state after a fatal failure.

When the consolidated deployment is executed as a single transactional unit, a fatal failure must roll back that unit according to the implementation of the deployment coordinator.

The transactional strategy must consider:

- Atomicity.
- Duration of the transaction.
- Lock duration.
- Transaction-log impact.
- Failure recovery.
- Rerun behavior.
- Operational deployment window.
- Consequences of partial completion.

A long-running transaction may introduce operational cost, but dividing a deployment into independently committed phases also changes failure semantics.

If earlier phases are committed before a later phase fails, the deployment may leave the environment partially updated.

Therefore, transaction boundaries must be an explicit architectural decision rather than an optimization applied solely because the deployment takes time to execute.

Any future decision to divide the deployment into smaller committed units must document:

- Why the change is required.
- Which phases become independent transaction units.
- What happens when a later phase fails.
- How partial completion is detected.
- How rerun safely resumes or validates the previous state.
- Whether rollback across previously committed phases is still required or possible.

The transactional strategy must favor predictable recovery over convenience.

---

### 12.10 Rerun Validation

A successful first execution is not sufficient evidence that a deployment script satisfies AtlasCommerce deployment standards.

A complete deployment must also be safely rerunnable.

Validation of deployment behavior should therefore include, when applicable:

1. Execution against a clean environment.
2. Validation of the resulting database state.
3. Re-execution against the environment created by the first run.
4. Confirmation that existing valid objects are recognized and preserved.
5. Confirmation that deterministic data is not duplicated.
6. Confirmation that constraints and indexes are not duplicated.
7. Confirmation that object documentation is not unnecessarily rewritten.
8. Confirmation that existing valid deployment-managed data is recognized without unnecessary modification.
9. Final Validation after rerun.

A clean deployment validates creation behavior.

A second execution validates rerun behavior.

Both are required to demonstrate that the deployment behaves as designed.

Rerun safety must not depend on suppressing errors while leaving an unknown database state.

The second execution must positively validate the existing expected state.

---

## 13. Object Ordering Standards

AtlasCommerce database objects follow predictable logical ordering to improve readability, maintainability, reviewability, and deployment consistency.

Ordering is primarily intended to optimize human understanding.

Logical ordering must not override deployment safety, architectural requirements, or technical dependencies.

The general ordering precedence is:

`Safety and Dependencies → Deployment Phase → Schema Order → Object Order`

This means that:

1. Safety and required technical dependencies take precedence.
2. Objects must remain in the deployment phase responsible for their type or technical purpose.
3. Within a phase, schema ordering should be preserved whenever practical.
4. Within a schema, object ordering should be preserved whenever practical.

Alphabetical or visual consistency must never be achieved by violating a technical dependency or moving an object into an inappropriate deployment phase.

---

### 13.1 Schema Ordering

`metadata` is intentionally placed first because it contains technical metadata and governance objects used by the database deployment and standards.

All remaining AtlasCommerce schemas are ordered alphabetically.

The current logical schema order is:

1. `metadata`
2. `catalog`
3. `customer`
4. `inventory`
5. `payment`
6. `reference`
7. `sales`
8. `shipping`

`metadata` is therefore an intentional technical exception to the normal alphabetical ordering.

New schemas must be inserted into the appropriate alphabetical position after `metadata` unless an explicit technical or architectural dependency justifies a different position.

The existence of a dependency between objects in different schemas does not automatically justify changing the logical schema order.

Such dependencies should normally be resolved by the appropriate deployment phase.

---

### 13.2 Table Ordering

Within each schema, tables should be organized alphabetically by table name whenever practical.

Example:

| Schema | Table |
|---|---|
| `payment` | `Payment` |
| `payment` | `PaymentMethod` |
| `payment` | `PaymentRefund` |
| `payment` | `PaymentRefundReason` |
| `payment` | `PaymentStatus` |

This ordering is logical rather than dependency-driven.

For example, the fact that one table references another table through a foreign key does not require the referenced table to appear first in every documentation or deployment inventory.

Alphabetical table ordering should be preserved whenever practical in:

- Technical documentation.
- Prefix registries.
- Deployment definitions.
- Constraint definitions.
- Index definitions.
- Final Validation.
- Technical inventories.

A technical dependency may override this ordering when required for safe deployment.

---

### 13.3 Technical Ordering Exceptions

Technical ordering exceptions are permitted only when required by an explicit operational or architectural dependency.

Examples include:

- Governance objects that must exist before dependent metadata can be deployed.
- Physical infrastructure required before partitioned objects can be created.
- Supporting objects required before a specialized integrity mechanism can be deployed.

`metadata.TablePrefix` is an example of a governance object whose technical role may require it to be available before prefix registry data is deployed.

Partition functions, partition schemes, filegroups, and related physical infrastructure may likewise require deployment before the tables or indexes that depend on them.

Technical ordering exceptions must:

- Have a clear operational or architectural reason.
- Be explicitly identifiable.
- Be limited to the minimum ordering change required.
- Not be introduced solely for convenience.
- Not become an excuse to abandon predictable logical ordering elsewhere.

The existence of one technical exception does not redefine the normal ordering standard for unrelated objects.

---

### 13.4 Logical Order and Dependency Order

Logical order and dependency order are separate concerns.

Logical order exists primarily for:

- Human readability.
- Predictable documentation.
- Easier code review.
- Easier comparison between scripts.
- Consistent inventories.
- Easier navigation through the database definition.

Dependency order exists to ensure that an object is not created before the objects or infrastructure required by its definition are available.

A table should not be moved from its normal logical position solely because it references another table through a foreign key.

AtlasCommerce resolves this type of dependency by separating:

- Table and Primary Key creation.
- Foreign Key Constraint creation.

This allows tables to remain in predictable logical order while referential dependencies are established later during the appropriate deployment phase.

The same principle applies to other object types whenever deployment phases can safely separate logical organization from dependency creation.

---

### 13.5 Ordering Within Deployment Phases

Within a deployment phase, the preferred logical ordering is:

`Deployment Phase → Schema → Object`

For table-specific deployment phases, the preferred ordering is:

`Deployment Phase → Schema → Table`

For example, all Default Constraints belong to the Default Constraint phase before the deployment proceeds to the Check Constraint phase.

Within the Default Constraint phase, objects should then follow the standard schema and table ordering whenever technical dependencies permit.

Deployment-phase responsibility takes precedence over alphabetical ordering.

An object must not be moved into an earlier or later phase merely to make a script visually alphabetical.

Technical dependencies and safety requirements take precedence over both schema and object ordering.

---

### 13.6 TablePrefix Registry Ordering

The `metadata.TablePrefix` registry is logically ordered by:

`Schema → Table`

`metadata` follows its intentional technical precedence, and the remaining schemas follow the standard logical schema ordering.

Within each schema, prefix assignments should appear alphabetically by table name whenever practical.

The prefix registry is the authoritative source for current and historical prefix assignments.

The Database Standards document must not duplicate the complete prefix registry because doing so would create a second inventory that could become inconsistent with the implemented database.

Inactive or retired prefix assignments remain preserved.

They must not be:

- Deleted.
- Reordered solely to hide their historical position.
- Reassigned to another table.
- Removed merely to improve visual presentation.

Historical prefix preservation takes precedence over cosmetic ordering.

---

### 13.7 Column Ordering

Column ordering in the initial table definition should follow a predictable logical structure appropriate to the table.

When applicable, the preferred logical organization is:

1. Primary identifier.
2. Relationship keys.
3. Core business attributes.
4. Status or classification attributes.
5. Monetary, quantitative, temporal, or other domain-specific attributes.
6. Lifecycle and audit columns.

This ordering is a design guideline rather than a reason to perform destructive physical changes to an existing table.

A column added after the table already exists may physically appear at the end of the table even when its logical category would normally place it earlier.

AtlasCommerce must not rebuild an existing populated table solely to improve the physical ordinal position of a column.

Logical documentation may continue to describe the column according to its semantic category even when its physical ordinal position differs because of a later controlled change.

#### New NOT NULL Columns

Adding a new column whose final definition is `NOT NULL` requires special consideration when the table already contains data.

The deployment must not invent an artificial DEFAULT solely to make the column addition technically possible.

When necessary, a controlled migration may:

1. Introduce the column in a temporary state that permits existing rows to remain valid.
2. Populate or derive the required values.
3. Validate the resulting data.
4. Apply the final `NOT NULL` definition.

The migration strategy must preserve semantic correctness.

A technically convenient placeholder value is not an acceptable substitute for valid data.

---

### 13.8 Constraint and Index Ordering

The standard logical order for integrity constraints and performance indexes is:

1. Primary Keys.
2. Default Constraints.
3. Check Constraints.
4. Unique Constraints.
5. Foreign Key Constraints.
6. Performance Indexes.

Primary Keys are created together with their owning tables.

The remaining constraint types are deployed in their dedicated phases.

Performance indexes are deployed after integrity constraints.

AtlasCommerce distinguishes:

- `UQ_` — Unique Constraint.
- `IX_` — Non-Unique performance index.
- `UX_` — Unique performance index.

Both `IX_` and `UX_` belong to the Index deployment phase.

A `UX_` must not be placed in the Unique Constraint phase merely because it enforces uniqueness.

Likewise, a physical Unique Index must not be treated as interchangeable with a Unique Constraint during validation.

Specialized integrity objects that do not belong to the standard PK, DEFAULT, CHECK, UQ, or FK categories must follow their explicitly defined deployment phase and dependencies.

Their technical requirements take precedence over the normal visual ordering of standard constraints and indexes.

---

### 13.9 Ordering Consistency

The same ordering principles should be reflected consistently across AtlasCommerce technical artifacts.

This includes:

- Database Standards.
- Architecture documentation.
- Deployment scripts.
- Table definitions.
- Prefix registry.
- Object Documentation deployment.
- Seed and reference data deployment.
- Constraint definitions.
- Index definitions.
- Final Validation.
- Technical inventories.

A newly introduced object must be inserted into its correct logical position whenever practical.

It must not automatically be appended to the end of an existing structured list merely because it was created later.

For example:

- A new schema must be inserted into the correct schema position.
- A new table must be inserted into the appropriate alphabetical position within its schema.
- A new constraint must be placed in the deployment phase responsible for that constraint type.
- A new index must be placed in the Index phase.
- A new prefix must be registered according to the registry ordering standard.

When a technical dependency requires an exception, the exception must remain limited to the affected object or phase.

Ordering consistency must not be achieved at the expense of deployment correctness.

---

## Closing Principle

AtlasCommerce database standards favor explicit intent over implicit behavior.

Naming communicates ownership and purpose.

Constraints communicate data integrity.

Indexes communicate access strategy.

Object documentation communicates semantic responsibility.

Ordering provides predictability without overriding technical dependencies.

Deployment validates before modifying and preserves unexpected existing state for controlled review.

Rerunnable does not mean self-healing.

The consolidated and validated AtlasCommerce database implementation remains the technical source of truth.

These standards must evolve with that implementation so that documentation describes the database that AtlasCommerce actually builds and validates rather than preserving obsolete conventions from an earlier stage of the model.