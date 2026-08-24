# Atlas Engineering — Enterprise Data Platform

## Overview

Atlas Engineering is an end-to-end enterprise data platform project designed and implemented from the ground up as a technical engineering portfolio.

The platform follows the evolution of data from its operational source through data engineering, analytical modeling, and business intelligence, with an emphasis on architecture, data quality, reproducibility, maintainability, and technical documentation.

The first major platform layer is **AtlasCommerce**, a SQL Server transactional system that represents the operational data source for a beauty retail business.

AtlasCommerce includes a complete relational data model, deterministic sample data, rerunnable deployment scripts, business and database documentation, cross-domain integrity rules, temporal validation, and automated data certification.

The transactional database layer is complete and provides the certified source data for the next stage of the platform: **Data Engineering**.

---

## Platform Architecture

Atlas Engineering is designed as an end-to-end data platform in which operational data is progressively transformed into analytical information.

The platform follows the architecture below:

```text
┌──────────────────────────────┐
│        AtlasCommerce         │
│                              │
│   Operational SQL Server     │
│   Transactional Database     │
│                              │
│         COMPLETED            │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Data Engineering       │
│                              │
│   Ingestion · Processing     │
│   Transformation · Quality   │
│                              │
│          NEXT STAGE          │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│        Data Warehouse        │
│                              │
│    Analytical Data Model     │
│                              │
│           PLANNED            │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Analytics Layer        │
│                              │
│           Power BI           │
│                              │
│           PLANNED            │
└──────────────────────────────┘
```

The operational database provides the controlled source data for the platform. Each subsequent layer will be developed with the same principles of reproducibility, validation, documentation, and traceability established in AtlasCommerce.


---

## Current Project Status

| Platform Layer | Status | Description |
|---|---|---|
| Operational Database — AtlasCommerce | **Completed** | Transactional SQL Server source system, sample data deployment, validation, and certification |
| Data Engineering | **Next Stage** | Data ingestion, transformation, processing, and quality pipelines |
| Data Warehouse | **Planned** | Analytical data model and historical data structures |
| Analytics — Power BI | **Planned** | Analytical models, dashboards, and business insights |


---

## AtlasCommerce

**AtlasCommerce** is the operational transactional database of the Atlas Engineering platform.

Built on SQL Server, it models the core operations of a beauty retail business across eight business and supporting domains:

| Domain | Responsibility |
|---|---|
| `catalog` | brands, categories, products, variants, attributes, images, and pricing |
| `customer` | customers, documents, contacts, email addresses, and customer addresses |
| `inventory` | stock balances, reservations, movements, movement reasons, and operational notes |
| `payment` | payment methods, payment lifecycle, refunds, and refund reasons |
| `sales` | transactions, transaction items, channels, and transaction lifecycle |
| `shipping` | shipment methods, shipment lifecycle, delivery addresses, and tracking |
| `reference` | countries, administrative divisions, cities, addresses, and shared reference data |
| `metadata` | internal metadata and database object governance |

### Database Engineering

The AtlasCommerce database layer was designed around deterministic and reproducible deployment rather than a one-time database creation process.

Its implementation includes:

- rerunnable database, schema, data model, and sample data deployment;
- controlled object creation and structural validation;
- standardized table and column prefixes;
- primary, foreign, unique, check, and default constraints;
- explicit referential integrity and dependency validation;
- partition-aware physical design;
- standardized indexes and physical placement;
- temporal integrity rules;
- business-rule validation across database domains;
- deterministic sample data generation;
- cross-domain financial, inventory, sales, and shipping reconciliation;
- automated final data certification.

### Sample Dataset

The current certified dataset contains transactional activity from **January 1, 2025 through August 24, 2026**, within a fixed sample-data temporal boundary used for deterministic deployment and validation.

| Dataset | Records |
|---|---:|
| Transactions | 6,306 |
| Transaction Items | 13,769 |
| Inventory Reservations | 4,116 |
| Inventory Movements | 12,796 |
| Payments | 6,959 |
| Payment Refunds | 272 |
| Shipments | 2,841 |

The dataset contains both **STORE** and **ONLINE** transactions, multiple transaction and payment states, inventory reservations and movements, refunds, shipment lifecycles, customer returns, and other operational scenarios intended to provide meaningful source data for downstream engineering and analytics.

### Data Certification

AtlasCommerce includes an automated certification process executed after sample data deployment.

The certification validates referential integrity, domain-specific business rules, temporal consistency, and reconciliation across the operational model.

```text
ATLASCOMMERCE DATA CERTIFICATION — PASS

Referential Integrity       : PASS
Sales Integrity             : PASS
Inventory Integrity         : PASS
Payment Integrity           : PASS
Shipping Integrity          : PASS
Temporal Integrity          : PASS
Cross-Domain Reconciliation : PASS
```

The certified AtlasCommerce dataset is therefore ready to serve as the operational source for the Data Engineering layer.

---

## Engineering Highlights

AtlasCommerce was developed as a database engineering project rather than only as a source of sample records.

The implementation emphasizes controlled deployment, structural consistency, data integrity, and reproducibility throughout the database lifecycle.

### Rerunnable Deployment

Database deployment scripts support both clean installation and safe reexecution, validating and preserving compatible existing structures and data rather than relying on destructive recreation.

### Database Standards

AtlasCommerce follows documented standards for:

- schemas, tables, and columns;
- table and column prefixes;
- primary and foreign keys;
- constraints and indexes;
- object ordering and dependencies;
- physical placement;
- documentation;
- deterministic data deployment.

These conventions are documented as part of the project and applied consistently across the database implementation.

### Integrity by Design

Integrity is validated at multiple levels rather than relying exclusively on foreign keys.

The database validates:

- referential integrity;
- business rules;
- monetary reconciliation between transactions and transaction items;
- inventory reservations and stock balances;
- inventory movement balances;
- payments and refunds;
- transaction and shipment relationships;
- temporal consistency between related operational events.

### Deterministic Sample Data

The sample dataset is generated through controlled DML deployment scripts and uses a fixed temporal boundary.

This makes the dataset reproducible and allows the same business, financial, inventory, shipping, and temporal validations to be executed consistently across deployments.

### Certification Before Consumption

Sample data deployment and certification are separate stages, and the dataset is released for downstream processing only after the resulting database state passes the required integrity and reconciliation validations.

---

## Repository Structure

The repository is organized by platform responsibility, separating source-system assets, database structures, documentation, deployment scripts, and validation resources.

```text
01-Enterprise-Data-Platform/
│
├── 01-Source/
│   └── Operational source-system assets
│
├── 02-Database/
│   └── Database-related structures and assets
│
├── 03-Documentation/
│   └── Technical, architectural, and business documentation
│
├── 04-Scripts/
│   └── Database, data deployment, and certification scripts
│
├── 05-Tests/
│   └── Validation and testing resources
│
├── .gitignore
│
└── README.md
```

### Main Areas

**`01-Source`**  
Contains assets related to the operational source systems that provide data to the platform.

**`02-Database`**  
Contains database-related structures and assets used by the platform. Local SQL Server data and log files are excluded from version control.

**`03-Documentation`**  
Contains the technical, architectural, and business documentation of the platform, including AtlasCommerce database standards, domain definitions, business rules, and data-model documentation.

**`04-Scripts`**  
Contains the executable deployment structure for the platform, including SQL Server database creation, schema deployment, data model deployment, deterministic sample data deployment, and data certification.

**`05-Tests`**  
Contains validation and testing resources used to verify platform components and data behavior.

The repository structure will evolve as new Data Engineering, Data Warehouse, and Analytics components are introduced.

---

## Documentation

Documentation is treated as part of the engineering deliverable rather than as a separate or optional project artifact.

AtlasCommerce maintains technical and business documentation in both **English** and **Brazilian Portuguese (PT-BR)** where applicable.

### AtlasCommerce Documentation

The current documentation covers:

- **Architecture** — architectural decisions, database organization, domain boundaries, and design principles;
- **Business Documentation** — operational concepts, business rules, transaction lifecycle, inventory, payments, and shipping behavior;
- **Database Standards** — schemas, naming conventions, prefixes, keys, constraints, indexes, physical placement, deployment behavior, and deterministic data rules;
- **Domain Model** — representation of the operational entities and their relationships;
- **Data Dictionary** — documented database objects, columns, relationships, and technical definitions;
- **Entity-Relationship Diagram (ERD)** — visual representation of the AtlasCommerce relational data model.

The documentation is maintained alongside the implementation so that architectural decisions, business rules, and database behavior remain traceable to the deployed solution.

### Documentation Principles

Atlas Engineering documentation follows the same principles applied to the implementation:

- technical accuracy;
- consistent terminology;
- explicit architectural and business decisions;
- separation between business concepts and physical database implementation;
- bilingual documentation where appropriate;
- version-controlled evolution alongside the project.

---

## Technology Stack

Atlas Engineering combines database, data engineering, analytics, development, and infrastructure technologies as the platform evolves.

### Current Stack

The technologies currently used in the implemented platform include:

| Technology | Role |
|---|---|
| **SQL Server** | AtlasCommerce operational relational database |
| **T-SQL** | Database deployment, validation, sample data generation, and certification |
| **SQL Server Management Studio (SSMS)** | Database development, administration, execution, and validation |
| **Git** | Source control and project history |
| **GitHub** | Repository hosting and project publication |
| **Visual Studio Code** | Repository, documentation, and source-file editing |
| **Markdown** | Version-controlled technical and business documentation |
| **Schemity Lite** | Entity-relationship diagram design and visualization |

### Technologies Under Consideration

As the platform evolves, additional technologies may be evaluated according to the architectural and engineering requirements of each subsequent stage.

Potential technologies include:

- **Python** for data engineering and automation;
- **PostgreSQL** for additional database and data-platform scenarios;
- **Docker** for reproducible development and service environments;
- **REST APIs** as external data sources and integration scenarios;
- **Cloud platforms** for infrastructure and managed data services;
- **Power BI** for analytical modeling, visualization, and business intelligence.

Technology choices for the Data Engineering and Data Warehouse layers will be made as their architectures are designed, rather than being treated as fixed implementation decisions in advance.

---

## Roadmap

Atlas Engineering is developed incrementally, with each platform layer becoming the validated foundation for the next stage.

| Stage | Status | Scope |
|---|---|---|
| **1. Operational Database — AtlasCommerce** | **Completed** | Transactional architecture, data model, deployment, deterministic sample data, validation, documentation, and certification |
| **2. Data Engineering** | **Next Stage** | Source ingestion, data processing, transformation, quality controls, and pipeline orchestration |
| **3. Data Warehouse** | **Planned** | Analytical architecture, dimensional modeling, historical data structures, and analytical data preparation |
| **4. Analytics — Power BI** | **Planned** | Semantic modeling, business metrics, dashboards, and analytical visualization |

The roadmap intentionally defines architectural stages without fixing implementation details before their technical requirements are evaluated.

---

## Reproducibility

Reproducibility is a core engineering principle of AtlasCommerce.

The database is deployed through an ordered set of SQL Server scripts that separates infrastructure creation, logical structure, data model deployment, sample data deployment, and final data certification.

### Deployment Flow

```text
01 — Database
     │
     ▼
02 — Schemas
     │
     ▼
03 — Data Model
     │
     ▼
04 — Sample Data
     │
     ▼
05 — Data Certification
     │
     ▼
Certified Operational Source
```

The main deployment sequence is:

| Step | Script | Responsibility |
|---|---|---|
| **1** | `01-Create-AtlasCommerce-Database.sql` | Creates and validates the AtlasCommerce database and its database-level physical configuration |
| **2** | `02-Create-AtlasCommerce-Schema.sql` | Creates and validates the required database schemas |
| **3** | `03-Deploy-AtlasCommerce-Data-Model.sql` | Deploys and validates the relational data model and supporting database objects |
| **4** | `04-Deploy-AtlasCommerce-Data.sql` | Deploys the deterministic AtlasCommerce sample dataset |
| **5** | `05-Certify-AtlasCommerce-Data.sql` | Independently validates the resulting dataset and certifies it for downstream use |

### Rerun-Safe Behavior

The deployment process is designed to be safely reexecuted.

Scripts inspect the existing database state before creating or inserting expected structures and data. Existing compatible objects and records are preserved, while structural or data inconsistencies are surfaced through explicit validation rather than silently overwritten.

This behavior allows the same deployment structure to support both a clean database installation and subsequent validation runs.

### Final Certification

The sample data deployment lifecycle is considered complete only after the certification stage returns:

```text
ATLASCOMMERCE DATA CERTIFICATION — PASS
```

A successful certification confirms that the deployed sample dataset satisfies the expected referential, business, financial, inventory, shipping, and temporal integrity rules required before downstream consumption.

This creates a reproducible boundary between the operational database and the next platform layer: Data Engineering.

---

## Project Purpose

Atlas Engineering is a long-term technical portfolio focused on the design and implementation of an enterprise data platform from its operational source to its analytical consumption layer.

The project is intended to demonstrate engineering decisions through working implementations rather than isolated examples or disconnected technology exercises.

Its development emphasizes:

- database and data architecture;
- reliable and reproducible deployment;
- data integrity and quality;
- technical and business documentation;
- traceability of architectural decisions;
- source control and software engineering practices;
- data engineering and analytical modeling;
- progressive integration of technologies according to architectural requirements.

Each platform stage is designed, implemented, validated, and documented before becoming the foundation for the next one.

As the platform evolves, this repository will preserve both the implemented solution and the engineering decisions that shaped it.