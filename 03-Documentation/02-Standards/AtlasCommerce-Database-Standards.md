# AtlasCommerce Database Standards

## 1. Purpose

This document defines the database design, naming, documentation, and deployment standards adopted by AtlasCommerce.

Its purpose is to ensure that database objects are created and maintained in a consistent, predictable, and traceable manner throughout the lifecycle of the platform.

These standards apply to database schemas, tables, columns, prefixes, keys, constraints, indexes, object documentation, and deployment scripts.

The standards defined in this document must be followed when creating new database objects or modifying existing ones.

## 2. Schema Organization

AtlasCommerce uses database schemas to organize objects according to their business domain or technical responsibility.

Each table must belong to the schema that best represents its primary business purpose. Schemas must not be used only as naming containers; they represent logical boundaries within the database.

The following schemas are currently defined:

| Schema | Purpose |
|---|---|
| catalog | Product catalog, classification, and product-related master data |
| customer | Customer-related transactional and master data |
| inventory | Inventory, stock position, and inventory movement data |
| metadata | Technical metadata and database governance information |
| reference | Shared reference data used across multiple business domains |
| sales | Sales transactions and sales-related business data |

New schemas may be introduced when a new business domain or technical responsibility cannot be appropriately represented by an existing schema.

A new schema must not be created solely to accommodate a single table when that table logically belongs to an existing domain.

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
| metadata | TablePrefix |
| reference | Address |
| reference | AdministrativeDivision |
| reference | AdministrativeDivisionType |
| reference | City |
| reference | Country |

The fully qualified table name must always be considered the canonical object name:

`schema.TableName`

Examples:

`metadata.TablePrefix`
`reference.Address`
`reference.AdministrativeDivision`
`reference.AdministrativeDivisionType`
`reference.City`
`reference.Country`

Tables representing the same conceptual entity must not be duplicated across schemas without an explicit architectural justification.

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
| metadata.TablePrefix | PFX | PFX_id |
| metadata.TablePrefix | PFX | PFX_schema_name |
| metadata.TablePrefix | PFX | PFX_table_name |
| reference.Country | CTR | CTR_id |
| reference.Country | CTR | CTR_name |
| reference.Country | CTR | CTR_is_active |
| reference.City | CTY | CTY_id |
| reference.City | CTY | CTY_name |

A column that references another table must preserve both the owning table prefix and the referenced table prefix according to the foreign key naming standard.

Example:

`ADV_ADT_id`

Where:

- `ADV` identifies the owning table (`AdministrativeDivision`).
- `ADT` identifies the referenced table (`AdministrativeDivisionType`).
- `id` identifies the referenced key.

Foreign key column naming is defined in detail in the Foreign Key Standards section.

## 5. Table Prefix Registry

AtlasCommerce maintains a centralized table prefix registry to guarantee that every table has a unique and permanently assigned prefix.

The registry is implemented through the `metadata.TablePrefix` table and acts as the authoritative source for table prefix assignments across the database.

Every table must have a registered prefix before its business columns are defined.

Once a prefix has been assigned to a table, it must never be reassigned to another table, even if the original table is later deactivated or removed.

Prefix records must not be physically deleted as part of normal database maintenance. Historical assignments must be preserved to prevent prefix reuse and to maintain traceability.

## 6. Prefix Naming Rules

Table prefixes must provide a short, recognizable, and unique identifier for each table in AtlasCommerce.

Prefixes must:

- Use uppercase letters only.
- Contain a maximum of five characters.
- Prefer three characters whenever a clear and meaningful abbreviation can be defined.
- Avoid two-character prefixes unless three or more characters cannot reasonably represent the table.
- Be unique across the entire database, regardless of schema.
- Be registered in `metadata.TablePrefix` before use.
- Never be reused after assignment, including prefixes associated with inactive or retired tables.
- Remain stable for the lifetime of the table unless an explicit architectural decision requires a change.

Prefix uniqueness applies globally across AtlasCommerce. Different schemas must not contain tables using the same prefix.

Examples:

| Schema | Table | Prefix |
|---|---|---|
| metadata | TablePrefix | PFX |
| reference | Address | ADR |
| reference | AdministrativeDivision | ADV |
| reference | AdministrativeDivisionType | ADT |
| reference | City | CTY |
| reference | Country | CTR |

When selecting a new prefix, existing assignments in `metadata.TablePrefix`, including inactive assignments, must be checked before the prefix is approved.

## 7. Primary Key Standards

Tables should have a primary key whenever a stable row identifier is required by the data model.

Primary keys are the default identification strategy for AtlasCommerce tables, but exceptions are allowed when the table semantics do not require an independent row identifier.

Primary key columns must:

- Follow the standard column naming convention.
- Use the registered prefix of the owning table.
- Use the suffix `_id`.
- Be defined as `NOT NULL`.
- Be created together with the table as part of its initial definition.
- Have a standardized object description identifying the column as the primary key of the table.

The standard primary key naming format is:

`PFX_id`

Primary keys should normally use a surrogate numeric identifier. Natural business keys should generally be modeled as regular columns with appropriate unique constraints rather than being used as the primary key.

The primary key data type must be selected according to the expected cardinality and growth of the table, with sufficient capacity for future expansion.

A primary key may also act as a foreign key when the data model represents a one-to-one or identifying relationship. In such cases, the column remains the primary key of the owning table while also referencing the parent table.

Some tables may intentionally not define a primary key when the data model does not require an independent row identifier. Such cases must be explicitly justified in the table design and must not occur merely for convenience.

Primary keys are part of the fundamental table structure and must not be created later as part of the separate constraint deployment phase.

## 8. Foreign Key Standards

Foreign key columns must clearly identify both the table that owns the column and the table referenced by the relationship.

The standard foreign key column naming format is:

`OWN_REF_id`

Where:

- `OWN` is the registered prefix of the table that owns the foreign key column.
- `REF` is the registered prefix of the referenced table.
- `id` identifies the referenced key.

Example:

`ADV_ADT_id`

In this example:

- `ADV` identifies `reference.AdministrativeDivision`, which owns the column.
- `ADT` identifies `reference.AdministrativeDivisionType`, which is referenced by the relationship.
- `id` indicates that the relationship references `ADT_id`.

Foreign key columns must:

- Follow the standard column naming convention.
- Use the registered prefixes of both participating tables.
- Use the same data type as the referenced key.
- Be defined as `NOT NULL` when the relationship is mandatory.
- Allow `NULL` only when the relationship is explicitly optional in the data model.
- Have a standardized object description identifying the referenced table and column.

When a table contains multiple foreign keys referencing the same table, each relationship must include a descriptive qualifier when necessary to distinguish its business role.

The qualified foreign key naming format is:

`OWN_qualifier_REF_id`

Where:

- `OWN` is the registered prefix of the table that owns the foreign key column.
- `qualifier` describes the business role of the relationship.
- `REF` is the registered prefix of the referenced table.
- `id` identifies the referenced key.

Examples:

`CST_billing_ADR_id`
`CST_shipping_ADR_id`

The qualifier must use English, lowercase snake_case, and must appear between the owning table prefix and the referenced table prefix.

A qualifier must only be used when necessary to distinguish the business meaning of multiple relationships or when the relationship would otherwise be ambiguous.

Foreign key columns are part of the table structure and must be created together with the table. The foreign key constraint itself must be created separately during the constraint deployment phase.

A primary key may also act as a foreign key when required by a one-to-one or identifying relationship, as defined in the Primary Key Standards section.

## 9. Object Documentation Standards

Database tables and columns must include technical documentation that clearly explains why the object exists and its role within the AtlasCommerce data model.

Object documentation is part of the initial object definition and must be created together with the object whenever applicable.

Documentation must:

- Use English.
- Be concise and technically meaningful.
- Explain why the object exists and what it represents within the data model.
- Provide information beyond what can already be inferred from the object name.
- Use consistent terminology across the database.
- Be updated whenever the meaning or responsibility of the documented object changes.
- Avoid implementation details that may become obsolete unless they are essential to understanding the object.

### 9.1 Table Documentation

Every permanent table must have a description explaining why the table exists and its responsibility within the data model.

The description must provide sufficient context to understand the purpose of the table without requiring external documentation.

Example:

`metadata.TablePrefix`

Description:

`Maintains the authoritative registry of table prefixes used to enforce naming consistency, prevent prefix reuse, and preserve prefix assignment history across AtlasCommerce.`

### 9.2 Column Documentation

Every column of a permanent table must have a description.

Columns that are not primary keys or foreign keys must have a specific description explaining why the column exists and what information it represents.

A column description must not merely repeat or expand the column name.

Example:

`PFX_prefix`

Description:

`Stores the unique and permanently reserved prefix assigned to the registered table for use in its column naming convention.`

### 9.3 Primary Key Documentation

Primary key columns must use a standardized description.

Standard format:

`Primary key of <schema>.<TableName>.`

Example:

`PFX_id`

Description:

`Primary key of metadata.TablePrefix.`

When a primary key also acts as a foreign key, its documentation must identify both roles.

### 9.4 Foreign Key Documentation

Foreign key columns must use a standardized description identifying the referenced table and column.

Standard format:

`Foreign key referencing <schema>.<TableName>.<column>.`

Example:

`ADV_ADT_id`

Description:

`Foreign key referencing reference.AdministrativeDivisionType.ADT_id.`

When a foreign key includes a relationship qualifier, the description must also explain the business role represented by that relationship.

Example:

`CST_billing_ADR_id`

Description:

`Foreign key referencing reference.Address.ADR_id representing the customer's billing address.`

### 9.5 Documentation Maintenance

Object documentation is part of the database definition and must be maintained with the same level of control as the object itself.

Changes that modify the semantic meaning or responsibility of a table or column must include the corresponding documentation update in the same deployment.

Missing required documentation must be treated as an incomplete object definition and must be identified during deployment validation.

## 10. Constraint Standards

Database constraints must be explicitly defined, consistently named, and independently validated during deployment.

Constraints must:

- Use explicit and deterministic names.
- Follow the AtlasCommerce constraint naming standards.
- Be validated before creation.
- Never be duplicated when a deployment script is rerun.
- Never be automatically dropped or replaced when an unexpected definition is found.
- Cause the deployment to report the divergence when an existing constraint does not match the expected definition.
- Be created separately from the table definition, except for primary keys.
- Be treated as data integrity rules rather than performance mechanisms.

Constraint deployment must be organized by constraint type to provide predictable validation, creation, and troubleshooting.

The standard deployment order is:

1. Primary keys — created as part of the initial table definition.
2. Default constraints.
3. Check constraints.
4. Unique constraints.
5. Foreign key constraints.

Indexes that are created specifically for performance or access optimization are not considered constraints and are governed separately by the Index Standards section.

### 10.1 Primary Keys

Primary key constraints define the primary row identifier of a table and, when present, are part of the table's fundamental structure.

Primary key constraints must:

- Be created together with the table as part of its initial definition.
- Use an explicit and deterministic constraint name.
- Follow the naming format `PK_<PFX>`, where `<PFX>` is the registered prefix of the owning table.
- Reference only columns belonging to the owning table.
- Use columns defined as `NOT NULL`.
- Be validated as part of the table deployment.
- Not be created, dropped, or replaced later by the separate constraint deployment phase.

Examples:

| Table | Prefix | Primary Key Constraint |
|---|---|---|
| metadata.TablePrefix | PFX | PK_PFX |
| reference.Address | ADR | PK_ADR |
| reference.AdministrativeDivision | ADV | PK_ADV |
| reference.AdministrativeDivisionType | ADT | PK_ADT |
| reference.City | CTY | PK_CTY |
| reference.Country | CTR | PK_CTR |

A table may use a composite primary key when the data model requires more than one column to uniquely identify a row.

Composite primary keys must use the same constraint naming format:

`PK_<PFX>`

The constraint name identifies the primary key of the table and must not include the individual column names.

Primary key columns may also participate in foreign key relationships when required by the data model. A column acting simultaneously as a primary key and a foreign key remains subject to both the Primary Key Standards and Foreign Key Standards.

Tables that intentionally do not require a primary key are permitted when justified by their technical or architectural purpose. The absence of a primary key must be an explicit design decision and must not occur accidentally or through an incomplete table definition.

Primary key constraints are the only constraints created as part of the initial table definition. Default, check, unique, and foreign key constraints are created and validated during their respective constraint deployment phases.

### 10.2 Default Constraints

Default constraints define a legitimate initial value that the database can assign when a value is not explicitly provided during row creation.

A default constraint must represent an intentional rule of the data model. It must not be used merely to avoid `NULL`, satisfy a `NOT NULL` definition, or hide missing information.

Default constraints must:

- Use an explicit and deterministic constraint name.
- Follow the naming format `DF_<PFX>_<column_name>`, where `<PFX>` is the registered prefix of the owning table and `<column_name>` is the column name without the table prefix.
- Be created separately from the initial table definition during the default constraint deployment phase.
- Be validated before creation.
- Not be duplicated when the deployment script is rerun.
- Not be automatically dropped or replaced when an existing definition differs from the expected definition.
- Cause the deployment to report the divergence when an existing default constraint does not match the expected definition.
- Be defined only when the default value represents a legitimate and intentional initial state for the column.

Examples:

| Column | Default Constraint |
|---|---|
| PFX_is_active | DF_PFX_is_active |
| CTR_is_active | DF_CTR_is_active |
| CTY_is_active | DF_CTY_is_active |

The table prefix must not be repeated in the column portion of the constraint name.

Example:

`PFX_is_active`

Valid:

`DF_PFX_is_active`

Invalid:

`DF_PFX_PFX_is_active`

A `NOT NULL` definition and a default constraint represent different data model decisions.

`NOT NULL` means that the column requires a value.

A default constraint means that the database knows which value should be assigned when no value is explicitly provided.

Therefore, a default constraint must not be created automatically simply because a column is defined as `NOT NULL`.

Defaults must not be used to manufacture placeholder values for unknown or unavailable information.

For example, an unknown postal code must not be represented by an empty string or artificial value solely to avoid `NULL`. When the data model permits the information to be unavailable, `NULL` must be used instead.

Example of an appropriate default:

`PFX_is_active bit NOT NULL`

Default constraint:

`DF_PFX_is_active DEFAULT (1)`

In this case, the default is valid because a newly registered table prefix is intentionally considered active unless explicitly defined otherwise.

Default constraints are data integrity and initialization rules. They must not be introduced solely for application convenience when the database cannot determine a semantically correct default value.

### 10.3 Check Constraints

Check constraints enforce data integrity rules that must remain true for valid data stored in a table.

A check constraint must represent a permanent rule of the data model and must not be used to enforce temporary application behavior, user interface rules, or business conditions that do not belong to the structural integrity of the stored data.

Check constraints must:

- Use an explicit and deterministic constraint name.
- Follow the naming format `CK_<PFX>_<rule_name>`, where `<PFX>` is the registered prefix of the owning table and `<rule_name>` is a concise semantic name describing the rule being enforced.
- Use English and lowercase snake_case for the rule name.
- Be created separately from the initial table definition during the check constraint deployment phase.
- Be validated before creation.
- Not be duplicated when the deployment script is rerun.
- Not be automatically dropped or replaced when an existing definition differs from the expected definition.
- Cause the deployment to report the divergence when an existing check constraint does not match the expected definition.
- Enforce a rule that is valid independently of the application, interface, or process inserting or updating the data.

Examples:

| Purpose | Check Constraint |
|---|---|
| Validate table prefix format | CK_PFX_prefix_format |
| Validate table prefix length | CK_PFX_prefix_length |
| Validate a promotion period | CK_PRM_valid_period |

The rule name must describe the integrity rule rather than merely reproduce the name of a column.

When multiple check constraints apply to the same column, each constraint must use a distinct semantic rule name.

Example:

`CK_PFX_prefix_format`
`CK_PFX_prefix_length`

Numeric suffixes or other non-semantic identifiers must not be used solely to distinguish multiple check constraints.

Invalid examples:

`CK_PFX_prefix_1`
`CK_PFX_prefix_2`

A check constraint may validate a single column or a relationship between multiple columns of the same row.

For rules involving multiple columns, the constraint name must describe the business or data integrity rule rather than concatenate all participating column names.

Example:

Given:

`PRM_start_at`
`PRM_end_at`

A rule requiring the end date and time to be equal to or later than the start date and time may use:

`CK_PRM_valid_period`

rather than:

`CK_PRM_start_at_end_at`

Check constraints must not be introduced for temporary operational restrictions or application-specific behavior that may change independently of the underlying data model.

A rule is an appropriate candidate for a check constraint when violating that rule would make the stored data structurally or semantically invalid regardless of how the data was inserted or updated.

### 10.4 Unique Constraints

Unique constraints enforce data integrity rules requiring a value or combination of values to be unique within a table.

A unique constraint must represent an intentional uniqueness rule of the data model. It must not be created solely to improve query performance or as a substitute for a performance-oriented index.

Unique constraints must:

- Use an explicit and deterministic constraint name.
- Follow the naming format `UQ_<PFX>_<rule_name>`, where `<PFX>` is the registered prefix of the owning table and `<rule_name>` is a concise semantic name describing the uniqueness rule.
- Use English and lowercase snake_case for the rule name.
- Be created separately from the initial table definition during the unique constraint deployment phase.
- Be validated before creation.
- Not be duplicated when the deployment script is rerun.
- Not be automatically dropped or replaced when an existing definition differs from the expected definition.
- Cause the deployment to report the divergence when an existing unique constraint does not match the expected definition.
- Be defined only when duplicate values would violate the intended data model.

Examples:

| Purpose | Unique Constraint |
|---|---|
| Country ISO alpha-2 code must be unique | UQ_CTR_iso_code_2 |
| Country ISO alpha-3 code must be unique | UQ_CTR_iso_code_3 |
| Administrative division code must be unique within a country | UQ_ADV_country_code |

A unique constraint may reference a single column or a combination of columns.

For a single-column uniqueness rule, the rule name may use the column name without the owning table prefix when that name clearly represents the uniqueness requirement.

Example:

Column:

`CTR_iso_code_2`

Constraint:

`UQ_CTR_iso_code_2`

The owning table prefix must not be repeated in the rule portion of the constraint name.

Invalid:

`UQ_CTR_CTR_iso_code_2`

For composite unique constraints, the rule name should describe the semantic uniqueness rule rather than automatically concatenate all participating column names.

Example:

Given:

`ADV_CTR_id`
`ADV_code`

If an administrative division code must be unique within a country, the constraint may be named:

`UQ_ADV_country_code`

rather than:

`UQ_ADV_CTR_id_ADV_code`

The order of columns in a composite unique constraint is part of its definition and must be validated during deployment.

A unique constraint must not be introduced solely because a query would benefit from a unique access path. Performance-oriented indexes are governed separately by the Index Standards section.

When uniqueness is required by the data model, the rule must be represented as a unique constraint even if the database engine internally implements that constraint using an index.

Natural business identifiers that are not used as primary keys should use unique constraints when their values are required to be unique by the data model.

### 10.5 Foreign Keys

Foreign key constraints enforce referential integrity between related tables and ensure that referenced values correspond to valid rows in the parent table.

Foreign key constraints must represent explicit relationships defined by the data model.

Foreign key constraints must:

- Use an explicit and deterministic constraint name.
- Follow the naming format `FK_<OWN>_<REF>`, where `<OWN>` is the registered prefix of the owning table and `<REF>` is the registered prefix of the referenced table.
- Include the relationship qualifier in the constraint name when the foreign key column requires one.
- Be created separately from the initial table definition during the foreign key constraint deployment phase.
- Be validated before creation.
- Not be duplicated when the deployment script is rerun.
- Not be automatically dropped or replaced when an existing definition differs from the expected definition.
- Cause the deployment to report the divergence when an existing foreign key constraint does not match the expected definition.
- Reference columns with compatible data types.
- Enforce only relationships intentionally defined by the data model.

Examples:

| Foreign Key Column | Foreign Key Constraint |
|---|---|
| ADV_ADT_id | FK_ADV_ADT |
| CST_billing_ADR_id | FK_CST_billing_ADR |
| CST_shipping_ADR_id | FK_CST_shipping_ADR |

The foreign key constraint name must preserve the same relationship identification used by the foreign key column.

For a standard relationship:

`OWN_REF_id`

The corresponding foreign key constraint is:

`FK_OWN_REF`

For a qualified relationship:

`OWN_qualifier_REF_id`

The corresponding foreign key constraint is:

`FK_OWN_qualifier_REF`

The owning or referenced table names must not be included in the constraint name because their registered prefixes already identify the participating tables.

Foreign key columns must be created as part of the initial table structure, but the foreign key constraints themselves must be created only during the foreign key constraint deployment phase.

This separation allows all participating tables and columns to exist before referential integrity is applied and simplifies dependency ordering during deployment.

A foreign key may reference a primary key or another candidate key whose uniqueness is explicitly guaranteed by the data model.

### Referential Actions

Referential actions such as `ON DELETE` and `ON UPDATE` must be explicitly evaluated for each relationship.

Cascading actions must not be used as a default behavior.

`ON DELETE CASCADE`, `ON UPDATE CASCADE`, `ON DELETE SET NULL`, and other automatic referential actions may only be used when they accurately represent an intentional and documented lifecycle rule of the related entities.

When no automatic referential action is explicitly required by the data model, the relationship must preserve the database engine's restrictive default behavior.

A cascading action must not be introduced solely to simplify application code or data maintenance.

Before a cascading action is approved, its effect on dependent tables and the complete relationship chain must be evaluated to prevent unintended propagation of data changes or deletions.

### Foreign Key Validation

Foreign key deployment validation must verify at minimum:

- The owning table.
- The owning column or columns.
- The referenced table.
- The referenced column or columns.
- Column compatibility.
- Column order for composite foreign keys.
- The configured referential actions.

An existing foreign key with the expected name but a different relationship definition must be reported as a divergence and must not be automatically replaced.

## 11. Index Standards

Indexes governed by this section are physical access structures created to support query performance, data access patterns, joins, filtering, sorting, and other performance requirements.

Indexes must not be created merely because a column exists or because a column participates in a foreign key relationship. Every performance-oriented index must have an identified access pattern or technical justification.

Performance-oriented indexes must:

- Use an explicit and deterministic name.
- Follow the naming format `IX_<PFX>_<purpose>`, where `<PFX>` is the registered prefix of the owning table and `<purpose>` is a concise semantic description of the access pattern or purpose supported by the index.
- Use English and lowercase snake_case for the purpose.
- Be created separately from the initial table definition during the index deployment phase.
- Be validated before creation.
- Not be duplicated when the deployment script is rerun.
- Not be automatically dropped or replaced when an existing definition differs from the expected definition.
- Cause the deployment to report the divergence when an existing index does not match the expected definition.
- Be justified by an identified query pattern, relationship access pattern, or measurable performance requirement.
- Be reviewed when the workload or access pattern that justified the index changes.

Examples:

| Purpose | Index |
|---|---|
| Support customer lookup by email | IX_CST_email_lookup |
| Support sales access by creation date and time | IX_SAL_created_at |
| Support sale item access by product | IX_SLI_product_lookup |

The purpose portion of an index name should describe why the index exists rather than automatically concatenate every participating column name.

Index names must remain concise and understandable even when the index contains multiple key or included columns.

### 11.1 Index Design

Index design must consider the actual data access pattern supported by the index.

The following characteristics must be evaluated when applicable:

- Key columns.
- Key column order.
- Sort direction.
- Included columns.
- Selectivity.
- Expected table cardinality and growth.
- Read and write workload.
- Existing indexes with overlapping access patterns.
- Storage and maintenance cost.

The existence of a foreign key does not automatically require a corresponding index.

A foreign key index should be created when the relationship participates in an access pattern that justifies the index.

Similarly, frequently filtered, joined, or sorted columns must not automatically receive indexes without considering the complete workload and existing index structures.

### 11.2 Composite Indexes

Composite indexes may contain multiple key columns when required by the access pattern.

The order of key columns is part of the index definition and must be intentionally selected and validated during deployment.

The index name should describe the supported access pattern rather than concatenate all key columns.

Example:

Given a sales access pattern using customer and creation date:

`SAL_CST_id`
`SAL_created_at`

A suitable index name may be:

`IX_SAL_customer_history`

rather than:

`IX_SAL_CST_id_SAL_created_at`

### 11.3 Included Columns

Included columns may be used when they provide a justified performance benefit without unnecessarily expanding the index key.

Included columns are part of the expected index definition and must be validated during deployment.

An index must not accumulate included columns solely to eliminate every possible lookup. The storage, write, and maintenance cost of the index must be considered.

### 11.4 Unique Indexes

A unique index must not be used as a substitute for a unique constraint when uniqueness is a required rule of the data model.

When uniqueness exists because duplicate data would be invalid, the rule belongs to the Unique Constraint Standards.

A unique performance-oriented index may be used only when its uniqueness is a property of the physical access strategy rather than the primary expression of a business or data integrity rule.

### 11.5 Index Validation and Maintenance

Index deployment validation must verify at minimum:

- The owning table.
- The index name.
- Key columns.
- Key column order.
- Sort direction.
- Included columns.
- Uniqueness.
- Relevant index options when explicitly standardized or required.

An existing index with the expected name but a different definition must be reported as a divergence and must not be automatically replaced.

Indexes must not be retained indefinitely solely because they were previously useful.

Indexes may be reviewed, modified, or retired when workload evidence demonstrates that the supported access pattern has changed or no longer exists.

Any modification or removal must be intentional, documented, and performed through a controlled deployment rather than automatic corrective behavior.

## 12. Deployment Standards

AtlasCommerce database deployment scripts must be rerunnable, predictable, traceable, and safe to execute against both new and existing environments.

A rerunnable deployment does not mean that the script must automatically force the database to match the expected definition.

Rerunnable means that the deployment can be executed repeatedly without unnecessarily recreating valid objects, duplicating definitions, or performing unintended destructive changes.

For every managed database object, the deployment must determine the current state before deciding whether an action is required.

The standard deployment behavior is:

| Current State | Deployment Behavior |
|---|---|
| Object does not exist | Create the object according to the expected definition |
| Object exists and matches the expected definition | Report successful validation and perform no change |
| Object exists but differs from the expected definition | Report the divergence and do not automatically replace or destructively modify the object |
| A required dependency or condition prevents safe deployment | Report an error and prevent the affected operation from continuing |

### 12.1 Deployment Status Messages

Deployment scripts must provide clear execution messages so that the result of each validation or action can be understood from the deployment output.

The standard status categories are:

`[OK]`

The object or definition already exists and matches the expected state. No modification is required.

`[CREATE]`

The expected object or definition does not exist and will be created.

`[WARNING]`

The object exists, but its current definition differs from the expected definition or another non-fatal condition requires review.

`[ERROR]`

A condition prevents the affected deployment operation from being safely completed.

Examples:

`[OK] Schema reference already exists.`

`[OK] Table reference.Country already exists and matches the expected definition.`

`[CREATE] Column CTR_is_active does not exist. Creating...`

`[WARNING] Column CTR_name exists with an unexpected data type.`

`[ERROR] Foreign key FK_ADV_ADT cannot be created because the referenced object is missing.`

Messages should identify the affected object and provide enough information to understand the deployment decision without requiring immediate inspection of the script.

### 12.2 Validation Before Modification

Deployment scripts must validate existing objects before attempting to create or modify them.

Validation must evaluate the characteristics required to determine whether the existing object corresponds to the expected AtlasCommerce definition.

Depending on the object type, validation may include:

- Schema.
- Object name.
- Column name.
- Data type.
- Length, precision, and scale.
- Nullability.
- Identity properties.
- Primary key definition.
- Default constraints.
- Check constraints.
- Unique constraints.
- Foreign key relationships.
- Referential actions.
- Index definitions.
- Object documentation.

The absence of an expected object may result in its creation when creation is safe and all required dependencies are available.

An existing object with an unexpected definition must not be assumed to be equivalent merely because its name matches the expected object name.

### 12.3 Non-Destructive Deployment

Standard deployment scripts must not perform destructive or potentially destructive corrective actions automatically.

This includes, unless explicitly implemented through an approved migration:

- Dropping existing tables.
- Dropping existing columns.
- Automatically changing incompatible column data types.
- Reducing column length, precision, or scale.
- Automatically changing column nullability when existing data may be affected.
- Dropping or replacing unexpected constraints.
- Dropping or replacing unexpected indexes.
- Deleting existing business or reference data.

When an existing definition differs from the expected definition, the standard deployment must report the divergence for review.

The existence of a technically possible automatic correction does not make that correction appropriate for a standard deployment.

### 12.4 Explicit Migrations

Changes that intentionally modify an existing database structure and may affect existing data, dependencies, or behavior must be implemented through an explicit and controlled migration.

A migration must clearly identify:

- The reason for the change.
- The affected objects.
- The expected previous state.
- The expected resulting state.
- Potential impact on existing data.
- Relevant dependencies.
- Required validation before the change.
- Required validation after the change.

Destructive or potentially destructive operations must never be hidden inside general object creation or validation logic.

A migration must fail safely when its required preconditions are not satisfied.

### 12.5 Dependency Validation

An object must not be created when a required dependency is unavailable or incompatible.

Deployment scripts must validate required dependencies before performing the affected operation.

Examples include:

- A foreign key requires the referenced table and key to exist.
- An index requires its table and participating columns to exist.
- A constraint requires its participating columns to exist.
- Object documentation requires the documented object to exist.

Missing or incompatible dependencies must produce an appropriate `[ERROR]` or `[WARNING]` according to whether safe continuation is possible.

A failure affecting one deployment operation must not be silently ignored.

### 12.6 Data Deployment

Required seed, reference, or metadata records must be deployed only after the table that stores them has been successfully created or validated.

Data deployment must be rerunnable.

A deployment must not create duplicate logical records when executed more than once.

Existing records must be validated using the appropriate stable business or technical identifier before a new record is inserted.

An existing record that conflicts with the expected definition must not be silently overwritten unless the deployment explicitly defines that update as an intentional and safe operation.

### 12.7 Deployment Phases

Database deployment must follow predictable phases so that dependencies are available before dependent objects are created.

The standard high-level deployment sequence is:

1. Schemas.
2. Tables and primary keys.
3. Table and column documentation.
4. Required seed, reference, and metadata data.
5. Default constraints.
6. Check constraints.
7. Unique constraints.
8. Foreign key constraints.
9. Performance-oriented indexes.
10. Final validation.

The detailed ordering of database objects within these phases is governed by the Object Ordering Standards section.

### 12.8 Final Validation

A deployment must finish with validation of the expected database state.

Final validation must identify unresolved warnings, errors, missing objects, unexpected definitions, and missing required documentation.

A deployment that executes without a SQL runtime error must not automatically be considered successful.

Deployment success requires that the expected AtlasCommerce definitions have been created or validated and that no unresolved condition prevents the environment from satisfying the required database standards.

Warnings must remain visible for review even when they do not prevent the deployment from completing.

Errors must clearly identify the operation or object that could not be safely deployed.

## 13. Object Ordering Standards

AtlasCommerce database objects must follow a predictable logical ordering to improve readability, maintainability, reviewability, and deployment consistency.

Object ordering is primarily intended to optimize human understanding of the database structure.

The logical ordering of objects does not necessarily represent their physical dependency or creation order. Dependencies must be handled by the appropriate deployment phase rather than by unnecessarily changing the documented logical order.

### 13.1 Schema Ordering

Schemas must be organized alphabetically by schema name, except when a technical object must exist earlier to support or govern the deployment process.

The standard AtlasCommerce schema ordering is:

1. `metadata`
2. `catalog`
3. `customer`
4. `inventory`
5. `reference`
6. `sales`

The `metadata` schema is intentionally placed first because it contains technical metadata and governance objects required by the database deployment process.

New schemas must be inserted into the appropriate alphabetical position unless an explicit technical dependency justifies a different position.

A non-alphabetical schema position must have a clear architectural or deployment reason.

### 13.2 Table Ordering

Within each schema, tables must be organized alphabetically by table name.

Example:

| Schema | Table |
|---|---|
| `reference` | `Address` |
| `reference` | `AdministrativeDivision` |
| `reference` | `AdministrativeDivisionType` |
| `reference` | `City` |
| `reference` | `Country` |

Alphabetical table ordering must be preserved in documentation, prefix registries, deployment definitions, and other structured representations of the database whenever practical.

The purpose of this rule is to make objects easier to locate visually and to reduce the risk of duplicate, misplaced, or overlooked definitions.

### 13.3 Technical Ordering Exceptions

A technical object may be placed before the normal alphabetical ordering when it must exist earlier to support or govern subsequent deployment operations.

The first defined AtlasCommerce exception is:

`metadata.TablePrefix`

`metadata.TablePrefix` must be created and validated before table prefix records for other database tables are deployed.

Technical ordering exceptions must:

- Have a clear operational or architectural reason.
- Be explicitly identifiable.
- Be limited to the minimum ordering change required.
- Not be introduced solely for convenience.

An ordering exception does not change the normal schema or table naming standards.

### 13.4 Logical Order and Dependency Order

Logical object ordering and dependency creation order are separate concerns.

Tables should not be moved from their standard logical order solely because a later foreign key relationship introduces a dependency between them.

For example, if one alphabetically earlier table references an alphabetically later table, both tables may still remain in their normal alphabetical positions.

This is possible because foreign key constraints are deployed separately from the initial table definitions.

Dependencies must be resolved during the deployment phase responsible for the dependent object.

The existence of a dependency therefore does not automatically justify changing the logical ordering of schemas or tables.

### 13.5 Ordering Within Deployment Phases

The deployment phase order defined by the Deployment Standards takes precedence over object-type ordering.

Within each applicable deployment phase, objects should follow the standard logical ordering whenever dependencies permit.

The standard hierarchy is:

`Deployment Phase → Schema → Object Name`

For table-related deployment operations, this becomes:

`Deployment Phase → Schema → Table`

Within the same schema and deployment phase, table names must be processed alphabetically unless a documented technical dependency requires otherwise.

### 13.6 TablePrefix Registry Ordering

Records in `metadata.TablePrefix` must follow the standard logical object ordering.

The registry must be organized by:

`Schema → Table`

Schema ordering must follow the AtlasCommerce schema ordering defined in this section.

Table names within each schema must be ordered alphabetically.

Example:

| Schema | Table | Prefix |
|---|---|---|
| `metadata` | `TablePrefix` | `PFX` |
| `reference` | `Address` | `ADR` |
| `reference` | `AdministrativeDivision` | `ADV` |
| `reference` | `AdministrativeDivisionType` | `ADT` |
| `reference` | `City` | `CTY` |
| `reference` | `Country` | `CTR` |

Registry ordering exists primarily for human readability and governance.

Prefix uniqueness must always be enforced independently of ordering.

Inactive or retired prefix assignments must remain preserved according to the Table Prefix Registry standards and must not be removed merely to maintain a visually compact registry.

### 13.7 Column Ordering

Columns within a table must follow a predictable structural order at the time of the initial table creation.

The standard column ordering is:

1. Primary key column, when present.
2. Foreign key columns.
3. Business data columns.
4. Status and lifecycle columns.
5. Audit and technical tracking columns.

Columns must be physically created in this order as part of the initial table definition.

Within each category, columns must follow the logical order of the information represented by the table. When no logical business order exists, columns must be ordered alphabetically by column name.

Primary key columns must appear first because they represent the identity of the row.

Foreign key columns must appear immediately after the primary key because they represent the structural relationships of the row.

Business data columns must follow the key columns and represent the primary information stored by the table.

Status and lifecycle columns must follow the business data columns.

Audit and technical tracking columns must appear last.

All columns remain subject to the Column Naming Standards and must use the registered prefix of their owning table.

The initial physical column ordering is part of the AtlasCommerce table definition and must be preserved consistently across creation scripts, documentation, and validation logic.

Columns added after the initial table creation must be physically added at the end of the existing table definition, regardless of the category to which the new column logically belongs.

An existing table must not be rebuilt, recreated, or otherwise structurally modified solely to reposition a subsequently added column according to the standard initial column ordering.

For columns introduced later through an approved migration, deployment safety and preservation of the existing table structure take precedence over physical column ordering.

The object description of a subsequently added column should identify that the column was introduced after the initial table definition when this information is relevant to explain its physical position or historical purpose.

The migration that introduces the column remains the authoritative record of when and why the structural change was made.

The physical position of a subsequently added column must therefore not be interpreted as representing its logical category within the table.

### 13.8 Constraint and Index Ordering

Constraints and indexes must first be organized according to their deployment phase and object type.

Within the same object type, definitions should follow the logical ordering of their owning tables and then their deterministic object names.

The deployment order for constraints remains:

1. Primary keys as part of the initial table definition.
2. Default constraints.
3. Check constraints.
4. Unique constraints.
5. Foreign key constraints.

Performance-oriented indexes are deployed after constraints according to the Deployment Standards.

Ordering must never override dependency validation or deployment safety requirements.

### 13.9 Ordering Consistency

The same logical ordering principles should be used consistently across:

- Database standards documentation.
- Architecture documentation.
- Deployment scripts.
- Table prefix registries.
- Constraint definitions.
- Index definitions.
- Validation scripts.
- Database object inventories.

Consistent ordering allows engineers to predict where an object should appear without searching the entire definition set.

When a new object is introduced, it must be inserted into its correct logical position rather than appended arbitrarily to the end of an existing definition list.

Ordering is therefore considered part of AtlasCommerce database maintainability and governance rather than a purely cosmetic convention.