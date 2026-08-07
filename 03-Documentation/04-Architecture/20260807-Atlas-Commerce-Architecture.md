# Atlas Commerce - Initial Data Architecture

**Document:** Atlas Commerce Architecture  
**Version:** 1.0  
**Date:** 2026-08-07  
**Status:** Draft

## 1. Purpose

The purpose of this architecture is to provide a robust sales data platform that separates analytical workloads from the transactional system, ensuring that sales operations remain the primary workload while enabling users to securely access business information through analytical dashboards.

## 2. Architecture Principles

### 2.1 Transactional Workload Protection

The primary transactional database must be dedicated to operational workloads. Analytical queries, reporting processes, and dashboards must not compete with sales transactions for database resources.

### 2.2 Decoupled Data Extraction

Data extraction for analytical purposes must be decoupled from the primary transactional workload whenever possible. Data may be obtained from a dedicated read replica or through controlled ingestion mechanisms such as backups, transaction logs, or other replication/change-capture strategies.

The extraction mechanism will be selected according to the requirements and characteristics of each source system.

### 2.3 Controlled Data Extraction

Data extraction processes must operate within controlled and predictable ranges. Full-table scans against source databases should be avoided, including during initial loads.

Initial and incremental loads should be divided into manageable batches or time windows to reduce resource consumption, transaction-log pressure, locking risks, and impact on source systems.

## 3. Phase 1 Architecture

```text

SQL Server local
│
├── AtlasCommerce_OLTP
│   ├── Customer
│   ├── Product
│   ├── Sale
│   ├── Sale_Item
│   └── Payment
│
├── AtlasCommerce_Staging
│   ├── dados extraídos da origem
│   └── próximos do formato original
│
└── AtlasCommerce_DW
    ├── DIM_CUSTOMER
    ├── DIM_PRODUCT
    ├── DIM_DATE
    ├── DIM_LOCATION
    └── FACT_SALES
    │
    ▼
Power BI Desktop
