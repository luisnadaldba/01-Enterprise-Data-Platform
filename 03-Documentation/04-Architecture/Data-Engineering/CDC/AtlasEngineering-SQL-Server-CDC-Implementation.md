# Atlas Engineering — SQL Server CDC Implementation

**Project:** Atlas Engineering — Enterprise Data Platform  
**Source System:** AtlasCommerce  
**Initial Domain:** `AtlasCommerce.sales`  
**Document Version:** V1  
**Status:** Approved 

---

## Table of Contents

- [1. Purpose](#1-purpose)

- [2. Scope](#2-scope)
  - [2.1 Implementation Coverage](#21-implementation-coverage)
  - [2.2 Source Tables](#22-source-tables)
  - [2.3 Out of Scope](#23-out-of-scope)
  - [2.4 Evidence Boundary](#24-evidence-boundary)

- [3. Implementation Context](#3-implementation-context)
  - [3.1 Architectural Role of SQL Server CDC](#31-architectural-role-of-sql-server-cdc)
  - [3.2 Source Protection Principle](#32-source-protection-principle)
  - [3.3 Decision, Implementation, and Evidence](#33-decision-implementation-and-evidence)
  - [3.4 Laboratory Environment](#34-laboratory-environment)

- [4. Pre-CDC Baseline — M01.08](#4-pre-cdc-baseline--m0108)
  - [4.1 SQL Server Instance](#41-sql-server-instance)
  - [4.2 AtlasCommerce Database State](#42-atlascommerce-database-state)
  - [4.3 Transaction Log Baseline](#43-transaction-log-baseline)
  - [4.4 Source Row Counts](#44-source-row-counts)
  - [4.5 SQL Server Agent](#45-sql-server-agent)
  - [4.6 Initial CDC State](#46-initial-cdc-state)
  - [4.7 Observed Result](#47-observed-result)
  - [4.8 Conclusion](#48-conclusion)

- [5. Database-Level CDC Enablement — M01.09](#5-database-level-cdc-enablement--m0109)
  - [5.1 Objective](#51-objective)
  - [5.2 Implementation](#52-implementation)
  - [5.3 Objects Created by SQL Server](#53-objects-created-by-sql-server)
  - [5.4 Observed Result](#54-observed-result)
  - [5.5 Conclusion](#55-conclusion)

- [6. Enabling CDC on `sales.Transaction` — M01.10](#6-enabling-cdc-on-salestransaction--m0110)
  - [6.1 Pre-Enable State](#61-pre-enable-state)
  - [6.2 Capture Configuration](#62-capture-configuration)
  - [6.3 Capture Instance](#63-capture-instance)
  - [6.4 Captured Columns](#64-captured-columns)
  - [6.5 Generated CDC Objects](#65-generated-cdc-objects)
  - [6.6 Net Changes Configuration](#66-net-changes-configuration)
  - [6.7 Partition Switching Warning](#67-partition-switching-warning)
  - [6.8 Observed Result](#68-observed-result)
  - [6.9 Conclusion](#69-conclusion)

- [7. CDC Jobs and Operational Configuration](#7-cdc-jobs-and-operational-configuration)
  - [7.1 Capture Job](#71-capture-job)
  - [7.2 Cleanup Job](#72-cleanup-job)
  - [7.3 Capture Polling](#73-capture-polling)
  - [7.4 Initial Retention](#74-initial-retention)

- [8. Partition Switching and CDC](#8-partition-switching-and-cdc)
  - [8.1 SQL Server Restriction](#81-sql-server-restriction)
  - [8.2 AtlasCommerce Partitioning Context](#82-atlascommerce-partitioning-context)
  - [8.3 Repository Verification](#83-repository-verification)
  - [8.4 Architectural Decision](#84-architectural-decision)
  - [8.5 Operational Boundary](#85-operational-boundary)

- [9. Initial Backfill and CDC Cutover](#9-initial-backfill-and-cdc-cutover)
  - [9.1 Why CDC Does Not Replace Initial Backfill](#91-why-cdc-does-not-replace-initial-backfill)
  - [9.2 Historical Baseline](#92-historical-baseline)
  - [9.3 Cutover Principle](#93-cutover-principle)
  - [9.4 Controlled Overlap](#94-controlled-overlap)
  - [9.5 Historical Semantics](#95-historical-semantics)

- [10. CDC Retention — M01.10B](#10-cdc-retention--m0110b)
  - [10.1 Default Retention](#101-default-retention)
  - [10.2 Recovery Requirement](#102-recovery-requirement)
  - [10.3 V1 Retention Decision](#103-v1-retention-decision)
  - [10.4 Implementation](#104-implementation)
  - [10.5 Cleanup Job Operational Error](#105-cleanup-job-operational-error)
  - [10.6 Root Cause](#106-root-cause)
  - [10.7 Correction](#107-correction)
  - [10.8 Observed Result](#108-observed-result)
  - [10.9 Data Freshness vs Recovery Window](#109-data-freshness-vs-recovery-window)
  - [10.10 Conclusion](#1010-conclusion)

- [11. Change Table Anatomy — M01.11](#11-change-table-anatomy--m0111)
  - [11.1 Change Table](#111-change-table)
  - [11.2 CDC Metadata Columns](#112-cdc-metadata-columns)
  - [11.3 Captured Source Columns](#113-captured-source-columns)
  - [11.4 Physical Index](#114-physical-index)
  - [11.5 Source Nullability vs Change Table Nullability](#115-source-nullability-vs-change-table-nullability)
  - [11.6 Initial Change Table State](#116-initial-change-table-state)
  - [11.7 CDC Metadata Semantics](#117-cdc-metadata-semantics)
  - [11.8 Conclusion](#118-conclusion)

- [12. Controlled INSERT — M01.12](#12-controlled-insert--m0112)
  - [12.1 Objective](#121-objective)
  - [12.2 Test Transaction](#122-test-transaction)
  - [12.3 Expected Result](#123-expected-result)
  - [12.4 Immediate Post-Commit Observation](#124-immediate-post-commit-observation)
  - [12.5 Post-Capture Observation](#125-post-capture-observation)
  - [12.6 INSERT Representation](#126-insert-representation)
  - [12.7 Asynchronous Capture Evidence](#127-asynchronous-capture-evidence)
  - [12.8 Conclusion](#128-conclusion)

- [13. Controlled UPDATE — M01.13](#13-controlled-update--m0113)
  - [13.1 Objective](#131-objective)
  - [13.2 State Transition](#132-state-transition)
  - [13.3 UPDATE BEFORE and AFTER Images](#133-update-before-and-after-images)
  - [13.4 Update Mask](#134-update-mask)
  - [13.5 Observed Result](#135-observed-result)
  - [13.6 Conclusion](#136-conclusion)

- [14. Multiple UPDATE Commands in One Transaction — M01.14](#14-multiple-update-commands-in-one-transaction--m0114)
  - [14.1 Objective](#141-objective)
  - [14.2 Transaction Structure](#142-transaction-structure)
  - [14.3 Command Ordering](#143-command-ordering)
  - [14.4 Update Masks](#144-update-masks)
  - [14.5 Transaction Correlation](#145-transaction-correlation)
  - [14.6 Observed Result](#146-observed-result)
  - [14.7 Conclusion](#147-conclusion)

- [15. Controlled DELETE — M01.15](#15-controlled-delete--m0115)
  - [15.1 Objective](#151-objective)
  - [15.2 Source State Before DELETE](#152-source-state-before-delete)
  - [15.3 DELETE Execution](#153-delete-execution)
  - [15.4 CDC DELETE Representation](#154-cdc-delete-representation)
  - [15.5 Hard DELETE Detection](#155-hard-delete-detection)
  - [15.6 Observed Result](#156-observed-result)
  - [15.7 Conclusion](#157-conclusion)

- [16. Enabling CDC on `sales.TransactionItem` — M01.16](#16-enabling-cdc-on-salestransactionitem--m0116)
  - [16.1 Pre-Enable Validation — M01.16A](#161-pre-enable-validation--m0116a)
  - [16.2 Primary Key](#162-primary-key)
  - [16.3 Foreign Key and ON DELETE CASCADE](#163-foreign-key-and-on-delete-cascade)
  - [16.4 Partitioning](#164-partitioning)
  - [16.5 CDC Enablement — M01.16B](#165-cdc-enablement--m0116b)
  - [16.6 Capture Instance](#166-capture-instance)
  - [16.7 Generated CDC Objects](#167-generated-cdc-objects)
  - [16.8 Initial Change Table State](#168-initial-change-table-state)
  - [16.9 Initial Minimum LSN Observation](#169-initial-minimum-lsn-observation)
  - [16.10 Conclusion](#1610-conclusion)

- [17. Cross-Table CDC Preparation — M01.17A](#17-cross-table-cdc-preparation--m0117a)
  - [17.1 Objective](#171-objective)
  - [17.2 Capture Instance Validation](#172-capture-instance-validation)
  - [17.3 `sp_cdc_help_change_data_capture` Script Error](#173-sp_cdc_help_change_data_capture-script-error)
  - [17.4 Root Cause](#174-root-cause)
  - [17.5 Correction](#175-correction)
  - [17.6 LSN State](#176-lsn-state)
  - [17.7 Conclusion](#177-conclusion)

- [18. Cross-Table INSERT Transaction — M01.17B](#18-cross-table-insert-transaction--m0117b)
  - [18.1 Objective](#181-objective)
  - [18.2 Transaction Structure](#182-transaction-structure)
  - [18.3 Source Rows Created](#183-source-rows-created)
  - [18.4 Immediate CDC State](#184-immediate-cdc-state)
  - [18.5 Captured CDC State](#185-captured-cdc-state)
  - [18.6 Cross-Table Transaction Correlation](#186-cross-table-transaction-correlation)
  - [18.7 Command Ordering](#187-command-ordering)
  - [18.8 Evidence Boundary](#188-evidence-boundary)
  - [18.9 Conclusion](#189-conclusion)

- [19. Coordinated Cross-Table UPDATE — M01.18](#19-coordinated-cross-table-update--m0118)
  - [19.1 Objective](#191-objective)
  - [19.2 Transaction Structure](#192-transaction-structure)
  - [19.3 Final Source State](#193-final-source-state)
  - [19.4 Shared Transaction LSN](#194-shared-transaction-lsn)
  - [19.5 Command IDs and Sequence Values](#195-command-ids-and-sequence-values)
  - [19.6 Update Masks](#196-update-masks)
  - [19.7 UPDATE Pair Semantics](#197-update-pair-semantics)
  - [19.8 Conclusion](#198-conclusion)

- [20. Parent DELETE with ON DELETE CASCADE — M01.19](#20-parent-delete-with-on-delete-cascade--m0119)
  - [20.1 Objective](#201-objective)
  - [20.2 Source State Before DELETE](#202-source-state-before-delete)
  - [20.3 Explicit Parent DELETE](#203-explicit-parent-delete)
  - [20.4 Referential Cascade](#204-referential-cascade)
  - [20.5 CDC Representation](#205-cdc-representation)
  - [20.6 Shared Transaction LSN](#206-shared-transaction-lsn)
  - [20.7 Command Ordering](#207-command-ordering)
  - [20.8 Application Action vs Physical Changes](#208-application-action-vs-physical-changes)
  - [20.9 Observed Result](#209-observed-result)
  - [20.10 Conclusion](#2010-conclusion)

- [21. Consolidated CDC Transaction Model](#21-consolidated-cdc-transaction-model)
  - [21.1 Transaction LSN](#211-transaction-lsn)
  - [21.2 Command ID](#212-command-id)
  - [21.3 Sequence Value](#213-sequence-value)
  - [21.4 Operation](#214-operation)
  - [21.5 Update Mask](#215-update-mask)
  - [21.6 UPDATE Pair Model](#216-update-pair-model)
  - [21.7 Cross-Table Correlation](#217-cross-table-correlation)

- [22. Asynchronous Capture Model](#22-asynchronous-capture-model)
  - [22.1 Commit vs CDC Availability](#221-commit-vs-cdc-availability)
  - [22.2 Capture Job Polling](#222-capture-job-polling)
  - [22.3 Laboratory Observation](#223-laboratory-observation)

- [23. Time Semantics](#23-time-semantics)
  - [23.1 Business Event Time](#231-business-event-time)
  - [23.2 CDC Transaction Time](#232-cdc-transaction-time)
  - [23.3 Future Platform Ingestion Time](#233-future-platform-ingestion-time)

- [24. Implementation Errors and Corrections](#24-implementation-errors-and-corrections)
  - [24.1 Cleanup Job Stop Request](#241-cleanup-job-stop-request)
  - [24.2 `sp_cdc_help_change_data_capture` Parameter Error](#242-sp_cdc_help_change_data_capture-parameter-error)
  - [24.3 Transient Minimum LSN Observation](#243-transient-minimum-lsn-observation)
  - [24.4 Engineering Lessons](#244-engineering-lessons)

- [25. Evidence Summary](#25-evidence-summary)
  - [25.1 Behaviors Proven](#251-behaviors-proven)
  - [25.2 Behaviors Not Yet Proven](#252-behaviors-not-yet-proven)
  - [25.3 Laboratory vs Production Claims](#253-laboratory-vs-production-claims)

- [26. Implementation Status](#26-implementation-status)

- [27. Next Step — CDC Consumption](#27-next-step--cdc-consumption)
  - [27.1 M01.20 — CDC Consumption](#271-m0120--cdc-consumption)
  - [27.2 M01.20A — LSN Window Inspection](#272-m0120a--lsn-window-inspection)
  - [27.3 All-Changes Query Functions](#273-all-changes-query-functions)
  - [27.4 Row Filter Options](#274-row-filter-options)
  - [27.5 Checkpoint Questions](#275-checkpoint-questions)
  - [27.6 Transaction Context Must Be Preserved](#276-transaction-context-must-be-preserved)
  - [27.7 Retention Boundary](#277-retention-boundary)
  - [27.8 Evidence Required Before Completion](#278-evidence-required-before-completion)
  - [27.9 Current Engineering Checkpoint](#279-current-engineering-checkpoint)


---

## 1. Purpose

This document defines and records the implementation of SQL Server Change Data Capture (CDC) for the initial `AtlasCommerce.sales` domain of the Atlas Engineering platform.

Its purpose is to document not only the resulting CDC configuration, but also the engineering process used to establish and validate that configuration. This includes the source-system baseline, database- and table-level enablement, operational configuration, controlled change tests, observed CDC metadata, cross-table transaction behavior, implementation errors and corrections, and the evidence produced during the laboratory cycle.

The implementation documented here covers the controlled laboratory work performed from M01.08 through M01.19.

The document therefore serves as the implementation and evidence record for the SQL Server CDC portion of Capture Strategy V1. It complements the broader capture-strategy documentation, which defines why CDC was selected for the relevant source tables and how CDC fits within the overall Atlas Engineering capture architecture.

The next phase, beginning with CDC consumption, is intentionally excluded from the completed implementation documented here.

---

## 2. Scope

### 2.1 Implementation Coverage

This document covers the SQL Server CDC implementation and validation activities performed during the controlled laboratory cycle from M01.08 through M01.19.

The covered activities include:

- establishing the pre-CDC source baseline;
- enabling CDC at the `AtlasCommerce` database level;
- enabling CDC on the initial source tables;
- inspecting the generated CDC objects and metadata;
- configuring and validating CDC capture and cleanup jobs;
- defining the CDC retention window;
- examining the physical and logical structure of CDC change tables;
- validating controlled `INSERT`, `UPDATE`, and `DELETE` operations;
- validating multiple source commands executed within a single transaction;
- validating transaction correlation across multiple CDC-enabled tables;
- validating coordinated cross-table updates;
- validating a parent `DELETE` that produces child-row deletions through `ON DELETE CASCADE`;
- recording implementation errors, root causes, corrections, and resulting engineering lessons.

The scope is intentionally limited to behavior that was directly implemented or observed during the laboratory cycle.

### 2.2 Source Tables

The CDC implementation covered by this document applies to the following source tables:

- `sales.Transaction`
- `sales.TransactionItem`

These tables represent the initial high-change transactional scope selected for SQL Server CDC in Capture Strategy V1.

The implementation is evaluated both at the individual-table level and across the transactional relationship between the two tables.

### 2.3 Out of Scope

The following items are outside the implementation scope of this document:

- CDC consumption by the Atlas Engineering data platform;
- checkpoint persistence for CDC consumers;
- replay and recovery implementation on the consuming side;
- raw-zone ingestion;
- transformation or analytical processing;
- orchestration of downstream pipelines;
- production deployment;
- production-scale throughput or latency validation;
- production monitoring and alerting;
- CDC enablement for source tables outside the validated initial scope.

These concerns may depend on the CDC behavior established here, but they require separate implementation and evidence.

### 2.4 Evidence Boundary

The conclusions in this document are constrained by the evidence produced in the controlled Atlas Engineering laboratory environment.

A behavior is treated as validated only when it was directly observed through the implemented SQL Server CDC configuration and the corresponding controlled test.

Laboratory observations must not be generalized into unsupported production guarantees.

Where the implementation establishes SQL Server behavior but does not provide sufficient evidence for production-scale characteristics, the distinction is stated explicitly.

---

## 3. Implementation Context

### 3.1 Architectural Role of SQL Server CDC

SQL Server CDC is the Capture Strategy V1 mechanism selected for the high-change transactional tables in the initial `AtlasCommerce.sales` domain.

Within this scope, CDC provides a transaction-log-based mechanism for exposing committed source changes without requiring the Atlas Engineering platform to infer those changes from repeated full-table comparisons or from application-managed timestamps.

The implementation documented here focuses on establishing the source-side CDC capability and proving the change semantics required by the future consumer.

It does not define the complete downstream ingestion architecture.

### 3.2 Source Protection Principle

The `AtlasCommerce` database is treated as the authoritative OLTP source system.

CDC must therefore be implemented without transferring data-platform processing responsibilities into the transactional application layer.

The source system is responsible for its transactional workload and for exposing the change information provided by SQL Server CDC. Downstream processing, replay, checkpoint management, historical ingestion, transformations, and analytical workloads remain responsibilities of the data platform.

This boundary is a central implementation constraint: the capture mechanism must support the platform without turning the OLTP database into the processing engine of the data platform.

### 3.3 Decision, Implementation, and Evidence

Three different concerns are kept separate throughout this document:

**Architectural decision** defines what the platform intends to use and why.

**Implementation** records how SQL Server CDC was configured for the validated source scope.

**Evidence** records what was actually observed during controlled execution.

This distinction prevents an architectural expectation from being presented as an observed SQL Server behavior and prevents a laboratory observation from being promoted into a broader guarantee without supporting evidence.

### 3.4 Laboratory Environment

The implementation was performed against the Atlas Engineering `AtlasCommerce` source database in the controlled project laboratory environment.

The laboratory provides the environment required to inspect source state, configure SQL Server CDC, execute controlled transactions, inspect CDC metadata and change tables, and correlate observed source operations with captured change records.

The environment is used to establish implementation behavior and evidence under controlled conditions. It is not treated as a substitute for evidence from production workloads, scale, retention, latency, or operations.

---

## 4. Pre-CDC Baseline — M01.08

Before enabling Change Data Capture, a controlled baseline was established for the `AtlasCommerce` source environment.

The purpose of this baseline was to record the state of the SQL Server instance, the source database, the transaction log, the initial source tables, SQL Server Agent, and the existing CDC configuration before any CDC-related change was introduced.

This provided a known starting point against which the effects of the subsequent implementation steps could be evaluated.

### 4.1 SQL Server Instance

The CDC implementation laboratory was conducted in the following SQL Server environment:

```text
Instance:
Default Instance

Edition:
SQL Server Enterprise Developer Edition (64-bit)

Version:
17.0.1125.2

Release:
RTM
```

The environment provided the SQL Server capabilities required for the controlled CDC implementation and validation cycle documented here.

### 4.2 AtlasCommerce Database State

Before CDC enablement, the `AtlasCommerce` database was verified as:

```text
Database:
AtlasCommerce

State:
ONLINE

Recovery Model:
FULL

Compatibility Level:
170

CDC Enabled:
0
```

The value:

```text
is_cdc_enabled = 0
```

confirmed that database-level CDC had not yet been enabled.

This state was recorded before executing any CDC enablement procedure so that the transition introduced by M01.09 could be directly validated.

### 4.3 Transaction Log Baseline

The transaction log was inspected before CDC enablement.

The observed baseline was:

```text
Total Log Size:
255.99 MB

Used Log Space:
30.87 MB

Used Log Space:
12.06%

Log Reuse Wait:
NOTHING
```

The value:

```text
log_reuse_wait_desc = NOTHING
```

indicated that, at the time of the baseline inspection, SQL Server was not reporting a condition preventing transaction log reuse.

This measurement represents the state observed at that specific laboratory checkpoint. It must not be interpreted as a permanent characteristic of the database or as evidence of future CDC-related transaction log behavior.

### 4.4 Source Row Counts

The initial row counts for the `AtlasCommerce.sales` tables were recorded as:

| Source Table | Rows |
|---|---:|
| `sales.Transaction` | 6,306 |
| `sales.TransactionItem` | 13,769 |
| `sales.TransactionChannel` | 2 |
| `sales.TransactionStatus` | 5 |

These counts established the known source-state baseline before CDC was enabled.

They are particularly relevant to the subsequent validation of CDC behavior because they allow the implementation to distinguish between:

- rows that already existed before CDC enablement; and
- changes generated after the CDC capture boundary was established.

This distinction becomes important when validating whether SQL Server CDC automatically captures historical rows that existed before table-level enablement.

### 4.5 SQL Server Agent

SQL Server Agent was verified before CDC enablement.

The observed state was:

```text
State:
RUNNING

Start Mode:
Automatic
```

This validation was relevant because SQL Server CDC relies on SQL Server Agent jobs for capture and cleanup operations.

The baseline therefore established that the Agent infrastructure required by the subsequent CDC implementation was available before CDC was enabled.

### 4.6 Initial CDC State

At the beginning of the implementation cycle:

```text
Database CDC Enabled:
NO

CDC Schema Present:
NO

CDC Capture Instances:
NONE
```

No CDC schema or CDC capture structures existed in the database at this point.

The environment therefore represented a clean pre-CDC state for the controlled implementation.

### 4.7 Observed Result

The M01.08 baseline established the following starting state:

```text
AtlasCommerce
│
├── ONLINE
├── FULL recovery model
├── compatibility level 170
├── CDC disabled
│
├── SQL Server Agent
│   └── RUNNING / Automatic
│
├── Transaction Log
│   ├── total = 255.99 MB
│   ├── used = 30.87 MB
│   ├── used = 12.06%
│   └── log_reuse_wait_desc = NOTHING
│
└── Source Rows
    ├── Transaction = 6,306
    ├── TransactionItem = 13,769
    ├── TransactionChannel = 2
    └── TransactionStatus = 5
```

No CDC enablement or capture operation had yet been performed.

### 4.8 Conclusion

M01.08 established a controlled and documented pre-CDC baseline for the `AtlasCommerce` source environment.

The database was online and operating under the `FULL` recovery model. SQL Server Agent was running, no transaction log reuse wait was reported at the observation point, and CDC was not enabled.

The existing transactional rows were also quantified before capture began.

This baseline provided the reference point required for the subsequent implementation steps to demonstrate what changed as a direct result of enabling and configuring SQL Server CDC.

**M01.08 Status: PASS**

---

## 5. Database-Level CDC Enablement — M01.09

With the pre-CDC baseline established, the next implementation step was to enable Change Data Capture at the `AtlasCommerce` database level.

Database-level enablement establishes the CDC infrastructure required by SQL Server before individual source tables can be configured for change capture.

At this stage, no source table was automatically placed under CDC tracking.

### 5.1 Objective

The objective of M01.09 was to:

- enable SQL Server CDC for the `AtlasCommerce` database;
- verify the transition from the pre-CDC state;
- inspect the CDC infrastructure created by SQL Server;
- confirm that database-level enablement does not automatically enable CDC on source tables.

Before execution, the baseline established in M01.08 showed:

```text
is_cdc_enabled = 0
```

and no `cdc` schema was present.

### 5.2 Implementation

Database-level CDC was enabled using the SQL Server system stored procedure:

```sql
USE [AtlasCommerce];
GO

EXEC sys.sp_cdc_enable_db;
GO
```

The essential implementation action is the execution of:

```sql
EXEC sys.sp_cdc_enable_db;
```

This procedure enables CDC infrastructure for the current database.

The complete execution and validation logic is maintained in the corresponding M01.09 SQL script. The implementation document records the engineering purpose, relevant behavior, and observed evidence rather than duplicating the complete script.

### 5.3 Objects Created by SQL Server

After database-level CDC enablement, SQL Server created the CDC infrastructure required to manage capture metadata and subsequent table-level capture instances.

The observed infrastructure included the `cdc` schema and CDC metadata structures for areas such as:

- LSN-to-time mapping;
- registered change tables;
- captured-column metadata;
- DDL history;
- index-column metadata;
- internal CDC functions and procedures.

Among the metadata objects observed during validation were structures corresponding to:

```text
cdc.lsn_time_mapping
cdc.change_tables
cdc.captured_columns
cdc.ddl_history
cdc.index_columns
```

These objects belong to the CDC infrastructure managed by SQL Server.

Their creation represents database-level CDC initialization; it does not mean that a specific application table is already being captured.

### 5.4 Observed Result

After executing the database-level enablement procedure, the database state was validated again.

The resulting state was:

```text
Database:
AtlasCommerce

CDC Enabled:
1

CDC Schema:
Present

CDC Metadata Infrastructure:
Present
```

The transition:

```text
is_cdc_enabled = 0
        ↓
sys.sp_cdc_enable_db
        ↓
is_cdc_enabled = 1
```

confirmed that CDC had been successfully enabled at the database level.

The validation also confirmed an important implementation boundary:

```text
Database CDC Enabled
        ≠
Source Table Automatically Captured
```

No application table became CDC-enabled merely because `sys.sp_cdc_enable_db` was executed.

Table-level capture remained a separate and explicit implementation step.

### 5.5 Conclusion

M01.09 successfully enabled SQL Server CDC at the `AtlasCommerce` database level.

SQL Server created the CDC schema and supporting metadata infrastructure, and the database transitioned from:

```text
is_cdc_enabled = 0
```

to:

```text
is_cdc_enabled = 1
```

The implementation also confirmed that database-level CDC enablement establishes the required infrastructure but does not automatically configure individual source tables for capture.

This distinction is fundamental to the implementation sequence:

```text
Database-Level CDC Enablement
        ↓
CDC Infrastructure Available
        ↓
Explicit Table-Level Enablement
        ↓
Source Table Captured
```

The environment was therefore ready for the next controlled implementation step: enabling CDC on `sales.Transaction`.

**M01.09 Status: PASS**

---

## 6. Enabling CDC on `sales.Transaction` — M01.10

With CDC enabled at the `AtlasCommerce` database level, the next implementation step was to configure the first transactional source table for change capture.

`sales.Transaction` was selected as the first CDC-enabled table because it is part of the high-change transactional scope defined by Capture Strategy V1.

M01.10 established the first table-level capture instance and provided the foundation for the controlled `INSERT`, `UPDATE`, and `DELETE` tests performed in subsequent stages.

### 6.1 Pre-Enable State

Before table-level enablement, the implementation state was:

```text
AtlasCommerce database:
CDC enabled

sales.Transaction:
CDC not yet enabled

Existing source rows:
6,306
```

The existing rows were already present before the table entered the CDC capture boundary.

This distinction is important because enabling CDC on an existing table does not automatically create change records representing its historical rows.

The behavior was subsequently validated through inspection of the change table.

### 6.2 Capture Configuration

CDC was enabled for `sales.Transaction` using `sys.sp_cdc_enable_table`.

The relevant configuration was:

```text
Source schema:
sales

Source table:
Transaction

Role name:
NULL

Supports net changes:
0
```

The essential table-level implementation follows this configuration:

```sql
EXEC sys.sp_cdc_enable_table
    @source_schema        = N'sales',
    @source_name          = N'Transaction',
    @role_name            = NULL,
    @supports_net_changes = 0;
```

`@role_name = NULL` means that no dedicated gating role was specified through this CDC configuration.

`@supports_net_changes = 0` means that the capture instance was configured for all-changes access rather than net-changes support.

The complete execution and validation logic is maintained in the corresponding M01.10 SQL script.

### 6.3 Capture Instance

SQL Server created the following capture instance:

```text
sales_Transaction
```

The observed start LSN was:

```text
0x0000002C0000FCEC0067
```

The capture instance identifies the CDC metadata and objects associated with the source table.

The configured index used by the capture instance was:

```text
PK_TRN
```

The capture instance therefore established the CDC boundary from which subsequent changes to `sales.Transaction` could be captured by the CDC infrastructure.

### 6.4 Captured Columns

All nine source columns configured for the `sales.Transaction` capture instance were included in the captured-column metadata.

No reduced column subset was configured for this implementation.

The complete captured-column structure was later inspected through the CDC change table during M01.11, where the relationship between source columns and CDC metadata columns was examined in detail.

### 6.5 Generated CDC Objects

Table-level enablement resulted in SQL Server creating the CDC structures associated with the `sales_Transaction` capture instance.

The principal observed objects included:

```text
cdc.sales_Transaction_CT
cdc.fn_cdc_get_all_changes_sales_Transaction
```

The first object is the CDC change table used to store captured change records for the capture instance.

The second is the CDC query function used to retrieve all changes within an LSN interval.

Because the capture instance was configured with:

```text
supports_net_changes = 0
```

a corresponding net-changes query function was not created.

This distinction is intentional and becomes relevant when the CDC consumption model is evaluated in a later implementation stage.

### 6.6 Net Changes Configuration

The implementation deliberately used:

```text
supports_net_changes = 0
```

The CDC source layer therefore exposes the individual captured change records rather than relying on SQL Server to collapse an LSN interval into a net result for each source row.

At this implementation stage, the objective was to preserve and inspect the detailed change semantics produced by CDC, including individual operations and the before/after representation of updates.

The actual consumption strategy remains outside the evidence boundary of M01.10 and is not treated as already implemented.

### 6.7 Partition Switching Warning

`sales.Transaction` is partitioned.

During CDC enablement, SQL Server produced the partition-switching warning associated with a CDC-enabled partitioned table when partition switching remains allowed.

The resulting configuration retained:

```text
allow_partition_switch = 1
```

This warning was treated as an implementation constraint requiring explicit architectural evaluation rather than as a CDC enablement failure.

Repository verification found no implemented use of:

```sql
ALTER TABLE ... SWITCH
```

for the current `AtlasCommerce` source implementation.

The V1 decision was therefore to govern partition switching rather than block it solely because CDC had been enabled.

Under this boundary:

```text
SWITCH IN:
Not planned as a normal ingestion mechanism.

SWITCH OUT:
May be considered in the future only as a controlled operation.

CDC + partition switching:
Requires explicit operational governance.
```

The restriction is documented because partition switching can interact with CDC expectations and must not be treated as equivalent to ordinary captured DML activity.

The absence of `ALTER TABLE ... SWITCH` in the current repository establishes the state of the implemented AtlasCommerce codebase examined during this stage. It does not establish that partition switching is universally safe or that it could never be introduced later.

### 6.8 Observed Result

After M01.10, the implementation state was:

```text
AtlasCommerce
│
├── Database CDC
│   └── ENABLED
│
└── sales.Transaction
    ├── CDC enabled
    ├── capture_instance = sales_Transaction
    ├── index = PK_TRN
    ├── supports_net_changes = 0
    ├── captured columns = 9
    ├── start_lsn = 0x0000002C0000FCEC0067
    │
    ├── Change Table
    │   └── cdc.sales_Transaction_CT
    │
    └── All Changes Function
        └── cdc.fn_cdc_get_all_changes_sales_Transaction
```

The table-level CDC configuration was successfully established.

At this point, the existence of the capture instance and its generated objects demonstrated that `sales.Transaction` was included in the CDC implementation scope.

It did not yet prove the behavior of individual `INSERT`, `UPDATE`, or `DELETE` operations. Those behaviors required the controlled tests performed in subsequent stages.

### 6.9 Conclusion

M01.10 successfully enabled SQL Server CDC for `sales.Transaction`.

The `sales_Transaction` capture instance was created with all nine configured source columns, `PK_TRN` as the configured index, and net-changes support disabled.

SQL Server created the corresponding change table and all-changes query function.

The implementation also exposed the partition-switching constraint associated with the partitioned source table. Rather than treating the warning as an implementation failure, the project established an explicit operational boundary: partition switching remains governed and is not used as the normal ingestion mechanism for the table.

The table was now prepared for detailed inspection of its CDC infrastructure and for subsequent controlled change tests.

**M01.10 Status: PASS**

---

## 7. CDC Jobs and Operational Configuration

Enabling CDC for `sales.Transaction` also established the operational components responsible for moving committed transaction-log changes into CDC structures and for managing the lifecycle of captured data.

SQL Server CDC uses separate operational responsibilities for capture and cleanup. Understanding these responsibilities is important because successful table-level enablement alone does not describe how changes become available to consumers or how long captured data remains available.

### 7.1 Capture Job

The CDC capture job is responsible for processing eligible committed changes from the SQL Server transaction log and making them available through the CDC infrastructure.

The observed capture-job configuration was:

```text
maxtrans:
10000

maxscans:
10

continuous:
1

pollinginterval:
5 seconds
```

The configuration showed that the capture process was operating continuously and polling for additional work at a five-second interval.

The relevant parameters have distinct operational purposes:

- `maxtrans` limits the number of transactions processed during a scan cycle;
- `maxscans` limits the number of scan cycles performed before the configured polling interval applies;
- `continuous = 1` configures the capture process for continuous operation;
- `pollinginterval = 5` establishes a five-second polling interval for the observed configuration.

These values describe the configuration inspected in the Atlas Engineering laboratory. They must not be interpreted by themselves as a guaranteed five-second end-to-end data latency.

The actual delay between a source transaction commit and the availability of its CDC records depends on capture processing and runtime conditions.

This distinction was later demonstrated directly through the controlled CDC tests.

### 7.2 Cleanup Job

The CDC cleanup job manages the removal of change-table entries that have exceeded the configured CDC retention window.

The initial observed cleanup configuration included:

```text
retention:
4320 minutes

threshold:
4999
```

A retention value of:

```text
4320 minutes
```

corresponds to:

```text
3 days
```

This was the SQL Server CDC retention configuration observed before the Atlas Engineering recovery requirement was applied.

The cleanup job is operationally different from the capture job.

The capture process determines how committed changes are represented in CDC, while the cleanup process determines when previously captured changes become eligible for removal according to the configured retention policy.

This separation is important because capture availability and recovery-window duration represent different operational concerns.

### 7.3 Capture Polling

The observed capture configuration used:

```text
pollinginterval = 5
```

This value establishes the configured polling interval; it does not establish a five-second delivery guarantee.

CDC capture is asynchronous relative to the application transaction.

Conceptually, the implementation operates through the following sequence:

```text
Source transaction
        ↓
COMMIT
        ↓
Transaction log contains committed change
        ↓
CDC capture processing
        ↓
CDC change record becomes available
```

Therefore:

```text
COMMIT
   ≠
CDC record necessarily available immediately
```

This behavior is important for the future consumer because an empty CDC query immediately after a source commit cannot, by itself, be interpreted as evidence that the source transaction did not occur.

The asynchronous behavior was not merely assumed from the job configuration. It was subsequently observed through controlled laboratory transactions, where the source state was committed before the corresponding CDC records became visible.

Those experiments are documented in the later M01.12 through M01.19 sections.

### 7.4 Initial Retention

The initial CDC retention observed during implementation was:

```text
4320 minutes
=
72 hours
=
3 days
```

This value established the starting operational state but was not accepted as the Atlas Engineering V1 recovery window.

The project treats CDC retention primarily as an operational recovery buffer rather than as permanent historical storage.

The initial three-day window therefore required evaluation against the recovery needs of the future capture pipeline.

That evaluation resulted in a separate controlled configuration change during M01.10B, where the retention period was increased to:

```text
21600 minutes
=
360 hours
=
15 days
```

The rationale, implementation, operational issue encountered during the change, correction, and final validation are documented separately in the M01.10B retention section.

At this stage, the important distinction is:

```text
Capture Job
    → makes committed changes available to CDC

Cleanup Job
    → manages expiration of captured CDC data

Polling Interval
    → capture-process configuration

Retention
    → recovery-window configuration
```

These mechanisms operate together but solve different operational problems.

The CDC jobs and their initial configuration were successfully identified and documented as part of the source-side implementation baseline.

---

## 8. Partition Switching and CDC

The enablement of CDC on the partitioned `sales.Transaction` table introduced an important interaction between SQL Server CDC and table partition switching.

This interaction required explicit evaluation because partition switching is a metadata-based operation and must not be assumed to behave like ordinary row-level `INSERT`, `UPDATE`, or `DELETE` activity from the perspective of CDC.

The warning observed during M01.10 was therefore treated as an architectural and operational constraint rather than ignored as a routine enablement message.

### 8.1 SQL Server Restriction

When CDC was enabled on `sales.Transaction`, the resulting configuration retained:

```text
allow_partition_switch = 1
```

SQL Server warned about the use of partition switching on a CDC-enabled table.

The important implementation principle is that partition switching and ordinary captured DML do not have equivalent CDC semantics.

A partition can be moved through a metadata operation rather than through the individual row changes normally expected by a change-capture mechanism.

For that reason, the Atlas Engineering implementation must not assume that:

```text
Partition movement
=
Row-by-row CDC change capture
```

The warning therefore identifies a boundary that must be explicitly governed whenever CDC and partitioned tables coexist.

### 8.2 AtlasCommerce Partitioning Context

`sales.Transaction` was already partitioned before CDC was enabled.

CDC did not introduce the partitioning model.

The implementation therefore had to account for two existing characteristics simultaneously:

```text
sales.Transaction
│
├── Partitioned table
│
└── High-change transactional source
        ↓
      CDC
```

Disabling partition switching automatically would have changed the operational capabilities of an already partitioned source table.

Allowing it without governance, however, could create incorrect assumptions about what CDC would capture if a future partition-switch operation were introduced.

The implementation therefore required an explicit decision rather than treating either behavior as an automatic default.

### 8.3 Repository Verification

The AtlasCommerce repository was inspected for implemented partition-switch operations.

No current use of:

```sql
ALTER TABLE ... SWITCH
```

was found in the repository examined during this implementation stage.

This provided an important implementation fact:

```text
Partition switching capability:
Available

Partition switching implementation found in repository:
No
```

The result reduced the immediate operational risk because the current application implementation did not rely on partition switching as part of its normal data flow.

This evidence is intentionally limited to the repository state that was inspected.

It does not prove that partition switching could never be introduced through future code, administrative procedures, maintenance operations, or other operational mechanisms.

### 8.4 Architectural Decision

The V1 decision was to retain:

```text
allow_partition_switch = 1
```

while establishing an explicit governance boundary around partition-switch operations.

The decision can be summarized as:

```text
Do not disable an existing capability without a demonstrated requirement.

Do not treat the capability as safe for CDC without explicit control.
```

For the current architecture:

```text
SWITCH IN
    → Not planned as a normal ingestion mechanism.

SWITCH OUT
    → May be considered in the future as a controlled operation.

Ordinary transactional DML
    → Expected source-change path for CDC capture.

Partition switching
    → Exceptional operation requiring explicit evaluation.
```

In particular, `SWITCH IN` must not be introduced as a mechanism for moving new transactional data into `sales.Transaction` while assuming that CDC will expose the movement as equivalent row-level inserts.

The decision therefore preserves the existing partitioning capability without incorporating partition switching into the normal CDC capture contract.

### 8.5 Operational Boundary

The resulting V1 operational boundary is:

```text
sales.Transaction
│
├── Partitioned
├── CDC enabled
├── allow_partition_switch = 1
│
├── Normal source changes
│   └── INSERT / UPDATE / DELETE
│
└── ALTER TABLE ... SWITCH
    └── Controlled exception — not normal CDC ingestion
```

Any future introduction of partition switching must be evaluated against the CDC capture model before the operation is accepted into the normal source lifecycle.

The implementation documented here does not claim to have experimentally validated CDC behavior during a partition-switch operation.

What was established is narrower:

- `sales.Transaction` is partitioned;
- CDC was successfully enabled;
- `allow_partition_switch` remained enabled;
- SQL Server exposed the corresponding warning;
- no `ALTER TABLE ... SWITCH` implementation was found in the repository examined;
- V1 does not use `SWITCH IN` as the normal ingestion path;
- future partition-switch operations require explicit governance.

This distinction preserves the boundary between architectural decision and laboratory evidence.

The partition-switching warning therefore did not invalidate M01.10. It identified an operational constraint that was evaluated, documented, and incorporated into the V1 CDC implementation model.

---

## 9. Initial Backfill and CDC Cutover

Enabling CDC establishes a forward-looking change-capture boundary. It does not automatically transform rows that already existed in the source table into historical CDC events.

This creates an important implementation requirement for an existing transactional system such as `AtlasCommerce`: the platform must establish an initial historical baseline while also protecting changes that occur after the CDC boundary is created.

The resulting implementation model separates initial backfill from ongoing CDC capture.

### 9.1 Why CDC Does Not Replace Initial Backfill

Before CDC was enabled, the M01.08 baseline recorded:

```text
sales.Transaction:
6,306 rows

sales.TransactionItem:
13,769 rows
```

These rows existed before the corresponding tables entered their CDC capture boundaries.

CDC enablement does not retroactively reconstruct the historical sequence of operations that produced those rows.

Therefore:

```text
Existing source rows
        ≠
Historical CDC events
```

The initial source state and future change stream represent two different ingestion responsibilities.

The existing rows require an initial backfill, while changes occurring after the CDC boundary are handled through CDC.

This distinction also prevents the platform from inventing historical semantics that are not available in the source.

For example, the current status of an existing transaction does not provide sufficient evidence to reconstruct every previous status transition that occurred before CDC was enabled.

### 9.2 Historical Baseline

The initial backfill represents the known source state at the beginning of the Atlas Engineering capture lifecycle.

For the transactional scope established during M01.08, the baseline was:

| Source Table | Existing Rows |
|---|---:|
| `sales.Transaction` | 6,306 |
| `sales.TransactionItem` | 13,769 |

These rows form the initial current-state dataset that must eventually be incorporated into the data platform.

The baseline should therefore be interpreted as:

```text
What is known to exist at the initial ingestion point
```

rather than:

```text
A reconstruction of everything that happened before CDC
```

This distinction preserves the integrity of the historical model.

If pre-CDC event history was not captured by an authoritative source, Atlas Engineering must not manufacture that history from the current row state.

### 9.3 Cutover Principle

The V1 cutover principle is:

```text
Protect the future first, then load the past.
```

The sequence is intentionally designed to reduce the risk of creating a silent capture gap between the historical load and the beginning of incremental processing.

Conceptually:

```text
1. Establish the CDC boundary
        ↓
2. Protect future source changes
        ↓
3. Load the known current-state baseline
        ↓
4. Process CDC accumulated after the boundary
        ↓
5. Reconcile the overlap
        ↓
6. Enter normal incremental operation
```

This approach avoids relying on an assumption that the source will remain unchanged while the historical baseline is being loaded.

For an active OLTP system, such an assumption would create a period in which changes could occur without being represented in either the completed historical load or the incremental stream.

### 9.4 Controlled Overlap

The cutover model deliberately prefers a controlled overlap over a silent gap.

The two risks are fundamentally different:

```text
Controlled overlap
    → the same logical state may be encountered through
      both backfill and incremental processing;
    → can be detected and reconciled through deterministic
      processing and idempotency.

Silent gap
    → source changes may belong to neither ingestion path;
    → data can be permanently missed without an explicit
      recovery source.
```

For Atlas Engineering, the safer architectural direction is therefore:

```text
Known overlap
    >
Unknown missing data
```

This does not mean that end-to-end idempotency has already been implemented or validated.

At the current implementation stage, controlled overlap is the cutover principle. The downstream mechanisms required to reconcile that overlap belong to the CDC consumption and ingestion implementation stages and require their own evidence.

### 9.5 Historical Semantics

The initial backfill and CDC stream represent different historical semantics and should remain distinguishable downstream.

Candidate ingestion metadata for preserving this distinction includes:

```text
ingestion_mode = INITIAL_BACKFILL
```

for rows introduced through the initial historical baseline, and:

```text
ingestion_mode = CDC_STREAM
```

for changes introduced through ongoing CDC processing.

These values represent candidate platform metadata for the future ingestion model; they are not presented here as already implemented downstream fields.

The semantic boundary is the important requirement:

```text
INITIAL BACKFILL
    → known source state loaded from rows already present

CDC STREAM
    → captured changes occurring within the CDC lifecycle
```

This prevents the platform from falsely representing an initial current-state snapshot as if it were a sequence of historical source events.

The resulting model is:

```text
                    CDC boundary
                         │
                         │
Past                     │                     Future
─────────────────────────┼──────────────────────────────
                         │
Existing source state    │   New committed changes
        │                │            │
        ▼                │            ▼
Initial Backfill         │       CDC Capture
        │                │            │
        └──────────────┐ │ ┌──────────┘
                       ▼ ▼ ▼
                  Controlled
                    overlap
                       │
                       ▼
                  Reconciliation
                       │
                       ▼
                Normal incremental
                    operation
```

The implementation therefore establishes a clear separation between historical baseline loading and forward-looking change capture.

CDC captures eligible source changes from the established capture boundary onward. Initial backfill provides the known state that existed before that boundary. Neither mechanism should be used to invent source history that was never captured.

The actual execution of this cutover model, including checkpointing, overlap reconciliation, idempotency, and durable downstream persistence, remains outside the evidence established through M01.19 and requires validation during subsequent implementation stages.

---

## 10. CDC Retention — M01.10B

After the initial CDC operational configuration was inspected, the cleanup retention window required explicit evaluation.

The default observed retention was three days. For Atlas Engineering V1, this period was considered insufficient as an operational recovery buffer for interruptions that could span multiple days.

M01.10B therefore established and validated a longer CDC retention window.

### 10.1 Default Retention

The initial cleanup-job configuration observed during M01.10 was:

```text
retention:
4320 minutes

threshold:
4999
```

The retention value corresponds to:

```text
4320 minutes
=
72 hours
=
3 days
```

This value determines how long captured CDC data remains available before becoming eligible for cleanup according to the CDC cleanup process.

The three-day configuration was treated as the observed starting point rather than automatically accepted as the Atlas Engineering recovery requirement.

### 10.2 Recovery Requirement

CDC retention is treated in Atlas Engineering as an operational recovery buffer.

Its purpose is to provide sufficient time for the platform to recover from an interruption before required source changes become unavailable from the CDC change tables.

The V1 planning model considered a recovery scenario comprising approximately:

```text
Potential extended absence:
10 days

Diagnosis:
2 days

Repair and reprocessing:
3 days

Total recovery window:
15 days
```

The purpose of this calculation is not to predict that every incident will follow exactly this timeline.

It establishes a deliberate recovery margin substantially larger than the initial three-day configuration.

The resulting V1 requirement was:

```text
CDC Retention:
15 days
```

### 10.3 V1 Retention Decision

The selected retention value was:

```text
21600 minutes
=
360 hours
=
15 days
```

This decision establishes CDC as a temporary operational recovery source rather than a permanent historical repository.

The intended responsibility is:

```text
SQL Server CDC
    → temporary change availability
    → operational recovery buffer
```

The future durable data-platform layer is responsible for preserving captured data beyond the source CDC retention period.

Therefore:

```text
CDC retention
    ≠
Permanent historical retention
```

The fifteen-day window provides recovery capacity at the source boundary while avoiding the architectural mistake of treating SQL Server CDC change tables as the permanent history store for Atlas Engineering.

### 10.4 Implementation

The cleanup-job retention configuration was changed using:

```sql
EXEC sys.sp_cdc_change_job
    @job_type = N'cleanup',
    @retention = 21600;
```

The essential configuration change was:

```text
retention:
4320
    ↓
21600 minutes
```

After the change, the observed cleanup configuration was:

```text
retention:
21600 minutes

threshold:
4999
```

The threshold remained:

```text
4999
```

The complete execution and validation sequence is maintained in the corresponding M01.10B SQL script.

### 10.5 Cleanup Job Operational Error

During the operational procedure, an attempt was made to stop the CDC cleanup job.

SQL Server returned:

```text
Msg 22022

Request to stop job cdc.AtlasCommerce_cleanup refused
because the job is not currently running.
```

This message was initially encountered during the controlled retention-change procedure and required interpretation before continuing.

It was important not to classify the message automatically as a CDC implementation failure.

### 10.6 Root Cause

The cleanup job is periodic and is not necessarily executing at the exact moment an administrative script attempts to stop it.

The stop request therefore encountered a job that was already not running.

Conceptually:

```text
STOP requested
      │
      ▼
Is cleanup job currently running?
      │
      └── NO
           │
           ▼
SQL Server refuses stop request
because there is no running execution to stop
```

The error did not demonstrate a failure of CDC capture, cleanup configuration, or retention.

It demonstrated that the operational script made an assumption about the current execution state of the SQL Server Agent job.

The problem was therefore associated with operational control logic rather than with CDC itself.

### 10.7 Correction

The operational lesson from the failed stop request was that job-control scripts should verify execution state before issuing a stop command.

The safer control pattern is:

```text
Identify job
      ↓
Inspect current execution state
      ↓
Running?
  │          │
 YES         NO
  │          │
  ▼          ▼
STOP       Do not
job        request STOP
```

This avoids treating an already-stopped periodic job as an exceptional CDC condition.

The cleanup job was subsequently started as required by the controlled procedure, and the configured retention value was validated.

The correction therefore preserved the intended CDC configuration while improving the operational understanding of SQL Server Agent job control.

### 10.8 Observed Result

After the retention configuration was completed and validated, the observed cleanup-job state included:

```text
retention:
21600 minutes

threshold:
4999
```

The effective retention transition was:

```text
3 days
   ↓
15 days
```

The M01.10B implementation therefore established the intended V1 CDC recovery window.

The `Msg 22022` encountered during the procedure did not invalidate the result because its root cause was identified as an attempt to stop a job that was not running, rather than a failure to apply the retention configuration.

### 10.9 Data Freshness vs Recovery Window

CDC retention and data freshness solve different operational problems and must not be combined into a single requirement.

For Atlas Engineering V1:

```text
Data Freshness
    → how quickly committed source changes should
      become available downstream

Recovery Window
    → how long captured source changes remain
      available for recovery
```

The current architectural targets distinguish these dimensions:

```text
Typical data freshness:
approximately 3–5 minutes

Formal P95 freshness target:
≤ 15 minutes

CDC retention:
15 days
```

The fifteen-day retention value does not mean that data is expected to take fifteen days to reach the platform.

Similarly, a low-latency capture objective does not remove the need for a sufficiently large recovery window.

They represent different reliability dimensions:

```text
Freshness
    → minutes

Recovery capacity
    → days
```

The freshness values are architectural targets and must not be presented as production measurements established by the CDC laboratory.

The laboratory demonstrated asynchronous CDC behavior, but production end-to-end latency remains outside the evidence established through M01.19.

### 10.10 Conclusion

M01.10B changed the SQL Server CDC cleanup retention from the initial three-day configuration to the Atlas Engineering V1 recovery window of fifteen days:

```text
4320 minutes
      ↓
21600 minutes
```

The resulting configuration was validated with:

```text
retention = 21600
threshold = 4999
```

The implementation also exposed an operational scripting issue when a stop request was issued against a cleanup job that was not currently running.

The resulting `Msg 22022` was diagnosed as a job-state control issue rather than a CDC failure, establishing an important operational rule: scripts that control SQL Server Agent jobs should verify current execution state before requesting a stop.

Finally, the implementation preserves a strict distinction between CDC retention and data freshness.

CDC retention provides a temporary recovery buffer. It is not permanent historical storage, and its fifteen-day duration is independent of the platform's minute-scale data-freshness objective.

**M01.10B Status: PASS**

---

## 11. Change Table Anatomy — M01.11

With CDC enabled on `sales.Transaction`, the next step was to inspect the physical and logical structure created by SQL Server for captured changes.

M01.11 focused on `cdc.sales_Transaction_CT`, the change table associated with the `sales_Transaction` capture instance.

The objective was not yet to generate source changes, but to understand the structure into which subsequent `INSERT`, `UPDATE`, and `DELETE` events would be captured.

### 11.1 Change Table

The table-level CDC enablement performed in M01.10 created:

```text
cdc.sales_Transaction_CT
```

This table combines CDC metadata with the captured source-column values.

Conceptually:

```text
cdc.sales_Transaction_CT
│
├── CDC metadata columns
│
└── Captured source columns
```

The change table is a CDC-managed structure and must not be interpreted as a replica of the source table's physical design or constraint model.

Its purpose is to represent captured changes together with the metadata required to identify and interpret those changes.

### 11.2 CDC Metadata Columns

Inspection of `cdc.sales_Transaction_CT` identified the following CDC metadata columns:

```text
__$start_lsn
__$end_lsn
__$seqval
__$operation
__$update_mask
__$command_id
```

These columns provide the transaction and operation context required to interpret captured rows.

Their roles in the transaction model can be summarized as:

```text
__$start_lsn
    → transaction log context used to correlate
      changes belonging to the captured transaction

__$command_id
    → distinguishes commands observed within
      the same transaction

__$seqval
    → provides sequencing information for
      captured changes

__$operation
    → identifies the CDC row-image operation

__$update_mask
    → identifies the source columns declared
      as affected by an UPDATE

__$end_lsn
    → CDC metadata not used by Atlas Engineering
      as the primary basis for business ordering
      or transaction correlation
```

The detailed semantics of these fields were progressively validated through the controlled tests from M01.12 through M01.19.

M01.11 established their physical presence; later experiments provided the evidence required to interpret their behavior in actual transactions.

### 11.3 Captured Source Columns

In addition to the CDC metadata columns, the change table contained the nine source columns configured for the `sales.Transaction` capture instance.

The resulting structure can therefore be represented conceptually as:

```text
cdc.sales_Transaction_CT
│
├── __$start_lsn
├── __$end_lsn
├── __$seqval
├── __$operation
├── __$update_mask
│
├── captured sales.Transaction columns
│
└── __$command_id
```

The captured source values provide the row image associated with each CDC operation.

Their interpretation depends on `__$operation`.

For example, subsequent controlled tests demonstrated that an `UPDATE` can produce separate before and after row images, while an `INSERT` and a `DELETE` use different operation codes.

### 11.4 Physical Index

The change table contained a clustered unique index with the following key order:

```text
__$start_lsn
__$command_id
__$seqval
__$operation
```

Conceptually:

```text
Clustered Unique Index
        │
        ├── 1. __$start_lsn
        ├── 2. __$command_id
        ├── 3. __$seqval
        └── 4. __$operation
```

This physical structure is consistent with the need to distinguish multiple captured records by transaction context, command sequencing, and operation semantics.

However, the existence and key order of the physical index must not be treated as a substitute for the documented CDC semantics or for an explicit consumer ordering model.

The future consumer must use the CDC metadata deliberately rather than infer its business-processing contract solely from physical storage order.

### 11.5 Source Nullability vs Change Table Nullability

Inspection revealed an important structural difference between the source table and its CDC change table.

Columns defined as `NOT NULL` in `sales.Transaction` can appear as nullable in:

```text
cdc.sales_Transaction_CT
```

Therefore:

```text
Source constraint model
        ≠
CDC change-table constraint model
```

This does not mean that the original source column has become nullable.

The CDC change table is a capture structure designed to represent source changes. It is not intended to reproduce all source-table constraints.

A downstream consumer must therefore not infer source nullability rules solely from the physical nullability metadata of the CDC change table.

Source-schema semantics and CDC-storage semantics must remain distinct.

### 11.6 Initial Change Table State

Immediately after CDC was enabled on `sales.Transaction`, the change table contained:

```text
change_rows = 0
```

At the same time, the source baseline established:

```text
sales.Transaction rows = 6,306
```

The resulting observation was:

```text
Source:
6,306 existing rows

CDC change table:
0 rows
```

This provided direct evidence that enabling CDC did not automatically populate the change table with the rows that already existed in `sales.Transaction`.

Therefore:

```text
CDC enablement
        ≠
Automatic historical backfill
```

This observation supports the separation established in the initial backfill and cutover model:

```text
Existing source state
    → Initial Backfill

Changes after CDC boundary
    → CDC
```

### 11.7 CDC Metadata Semantics

The complete meaning of the CDC metadata could not be established from table anatomy alone.

The controlled experiments performed after M01.11 progressively demonstrated the following model:

```text
__$start_lsn
    → shared transaction context for changes
      observed from the same SQL transaction

__$command_id
    → distinguishes multiple commands within
      that transaction

__$seqval
    → contributes sequencing information for
      captured changes

__$operation
    → identifies the captured row-image type

__$update_mask
    → represents columns declared as affected
      by an UPDATE
```

The operation values observed and used throughout the laboratory were:

| `__$operation` | CDC Meaning |
|---:|---|
| `1` | `DELETE` |
| `2` | `INSERT` |
| `3` | `UPDATE_BEFORE` |
| `4` | `UPDATE_AFTER` |

For an `UPDATE`, the later experiments demonstrated a paired representation:

```text
UPDATE
  │
  ├── operation = 3
  │      UPDATE_BEFORE
  │
  └── operation = 4
         UPDATE_AFTER
```

The corresponding before and after images were observed with the same transaction and command context.

This behavior becomes particularly important when multiple commands and multiple CDC-enabled tables participate in the same SQL transaction.

Those cases are documented separately in M01.14 and M01.17 through M01.19.

Atlas Engineering does not build its transaction-correlation or business-ordering model around `__$end_lsn`.

The implementation instead focuses on the CDC metadata whose behavior was directly exercised and correlated during the controlled laboratory cycle.

### 11.8 Conclusion

M01.11 established the anatomy of the `sales.Transaction` CDC change table before controlled source changes were introduced.

The inspection confirmed that `cdc.sales_Transaction_CT` contains both CDC metadata and the nine captured source columns, with a clustered unique index ordered by:

```text
__$start_lsn
__$command_id
__$seqval
__$operation
```

The implementation also confirmed that the change table does not reproduce the source constraint model directly, including source-column nullability.

Most importantly, the change table contained zero captured rows despite `sales.Transaction` already containing 6,306 rows.

This provided direct evidence that SQL Server CDC does not automatically backfill the existing source state when capture is enabled.

M01.11 therefore established the structural foundation required to interpret the controlled `INSERT`, `UPDATE`, and `DELETE` experiments that followed.

**M01.11 Status: PASS**

---

## 12. Controlled INSERT — M01.12

After the CDC change-table structure had been inspected, the next stage was to generate the first controlled source change and observe how SQL Server CDC represented it.

M01.12 used a controlled `INSERT` into `sales.Transaction` to validate the first complete path from a committed source transaction to a captured CDC record.

The test also provided the first direct laboratory evidence that CDC capture is asynchronous relative to the source transaction commit.

### 12.1 Objective

The objective of M01.12 was to validate:

- that a newly committed `sales.Transaction` row was captured by CDC;
- how an `INSERT` was represented in `cdc.sales_Transaction_CT`;
- which CDC operation code represented the inserted row;
- the update-mask representation produced for the insert;
- the relationship between source commit and CDC availability;
- the distinction between source business-event time and CDC transaction time.

The test was intentionally controlled so that the resulting source row could be correlated directly with its CDC representation.

### 12.2 Test Transaction

The controlled transaction created:

```text
TRN_id:
6307

Status:
PENDING

Channel:
ONLINE

Gross Amount:
100

Discount Amount:
10
```

The transaction was committed to the source before the CDC change table was inspected.

The test therefore established a clear sequence:

```text
Controlled INSERT
        ↓
COMMIT
        ↓
Source row exists
        ↓
Inspect CDC
```

The purpose was not only to determine whether the row would eventually appear in CDC, but also to inspect its availability immediately after commit and again after allowing time for capture processing.

### 12.3 Expected Result

For a successfully captured source `INSERT`, the expected CDC representation was a new change-table record containing the inserted source values together with CDC metadata identifying the operation as an insert.

The expected logical model was:

```text
sales.Transaction
        │
        │ INSERT + COMMIT
        ▼
Transaction Log
        │
        ▼
CDC Capture
        │
        ▼
cdc.sales_Transaction_CT
        │
        └── INSERT row image
```

Because CDC capture operates asynchronously, the test did not assume that the CDC row had to be available at the exact moment the source transaction committed.

The immediate and delayed observations were therefore treated as separate checkpoints.

### 12.4 Immediate Post-Commit Observation

Immediately after the source transaction was committed, the inserted row existed in `sales.Transaction`.

However, the CDC inspection returned:

```text
matching_change_rows = 0
```

Therefore, at that observation point:

```text
Source transaction:
COMMITTED

Source row:
AVAILABLE

Matching CDC row:
NOT YET AVAILABLE
```

This result was not treated as a failed capture.

Instead, it established the first direct evidence that successful source commit and CDC-row availability are separate moments.

Conceptually:

```text
COMMIT
   │
   ├── Source state becomes committed
   │
   └── CDC record may still be pending capture
```

### 12.5 Post-Capture Observation

The controlled test allowed approximately six seconds for CDC capture processing before inspecting the change table again.

After that interval:

```text
matching_change_rows = 1
```

The inserted transaction was now represented in:

```text
cdc.sales_Transaction_CT
```

The observed sequence was therefore:

```text
INSERT
   ↓
COMMIT
   ↓
Immediate CDC inspection
   ↓
0 matching rows
   ↓
Approximately 6 seconds
   ↓
CDC inspection
   ↓
1 matching row
```

This observation was consistent with the previously inspected capture-job configuration:

```text
continuous = 1
pollinginterval = 5
```

However, the approximately six-second laboratory observation must not be interpreted as a guaranteed CDC latency.

The test demonstrated asynchronous capture behavior under the observed laboratory conditions, not a production latency service-level objective.

### 12.6 INSERT Representation

The captured row was represented with:

```text
__$operation = 2
```

Within the CDC operation model:

```text
1 = DELETE
2 = INSERT
3 = UPDATE_BEFORE
4 = UPDATE_AFTER
```

Therefore, the controlled transaction confirmed:

```text
Source INSERT
      ↓
CDC operation = 2
```

The captured record preserved the inserted source-row image together with its CDC metadata.

The observed update mask was:

```text
__$update_mask = 0x01FF
```

For this insert, the mask corresponded to the complete set of nine captured source columns.

The observed command identifier was:

```text
__$command_id = 1
```

These metadata values established the first concrete CDC record that could be used as the baseline for comparison with the more complex update and multi-command transactions tested later.

### 12.7 Asynchronous Capture Evidence

M01.12 established an important distinction between three different time concepts that will eventually coexist in the data platform.

The source transaction contained its own business timestamp:

```text
TRN_transaction_at
```

CDC provides a transaction-time mapping through the captured LSN, using mechanisms such as:

```text
sys.fn_cdc_map_lsn_to_time(...)
```

A future Atlas Engineering ingestion pipeline will also have its own platform ingestion time.

These concepts must remain distinct:

```text
Business Event Time
        │
        └── When the business event is represented
            as occurring in the source domain

CDC Transaction Time
        │
        └── Time associated with the captured
            transaction through CDC metadata

Platform Ingestion Time
        │
        └── When the future data platform
            receives or persists the change
```

Therefore:

```text
Business Event Time
        ≠
CDC Transaction Time
        ≠
Platform Ingestion Time
```

M01.12 directly observed the first two concepts.

The third remains part of the future ingestion implementation and must not be represented as already validated.

### 12.8 Conclusion

M01.12 successfully produced and captured the first controlled `INSERT` for `sales.Transaction`.

The test transaction created `TRN_id = 6307`, and the committed row was initially absent from the CDC change table:

```text
matching_change_rows = 0
```

After approximately six seconds, the corresponding CDC record was available:

```text
matching_change_rows = 1
```

The captured record was represented as:

```text
__$operation  = 2
__$update_mask = 0x01FF
__$command_id = 1
```

The experiment therefore established direct laboratory evidence for two fundamental CDC behaviors:

```text
Committed INSERT
    → captured as operation 2

Source COMMIT
    → does not require immediate CDC availability
```

The observed delay demonstrates asynchronous capture under the controlled laboratory conditions. It does not establish a fixed or guaranteed production capture latency.

M01.12 also established the need to preserve separate semantics for business-event time, CDC transaction time, and future platform ingestion time.

**M01.12 Status: PASS**

---

## 13. Controlled UPDATE — M01.13

After validating the first controlled `INSERT`, the next experiment examined how SQL Server CDC represents an `UPDATE`.

M01.13 updated the transaction created during M01.12 and inspected the resulting CDC records.

The experiment was particularly important because an update is not represented as a single replacement row in the configured all-changes CDC model. Instead, SQL Server preserves both the state before the change and the state after the change.

### 13.1 Objective

The objective of M01.13 was to validate:

- how an `UPDATE` is represented in the CDC change table;
- whether both the previous and resulting row images are preserved;
- the operation codes associated with those images;
- whether both images can be correlated to the same source command;
- how `__$update_mask` represents the columns affected by the update.

The controlled test reused:

```text
TRN_id = 6307
```

which had been inserted and captured during M01.12.

### 13.2 State Transition

The controlled update changed the transaction status from:

```text
PENDING
```

to:

```text
CONFIRMED
```

The update also affected the transaction update timestamp.

Conceptually, the source transition was:

```text
TRN_id = 6307

Before
│
├── Status = PENDING
└── Previous updated_at
        │
        │ UPDATE
        ▼
After
│
├── Status = CONFIRMED
└── New updated_at
```

The transaction was committed before the corresponding CDC records were evaluated.

### 13.3 UPDATE BEFORE and AFTER Images

CDC represented the source update using two change-table rows.

The first record used:

```text
__$operation = 3
```

and represented:

```text
UPDATE_BEFORE
```

The second used:

```text
__$operation = 4
```

and represented:

```text
UPDATE_AFTER
```

The resulting model was:

```text
Source UPDATE
      │
      ▼
┌────────────────────────────┐
│ CDC UPDATE_BEFORE          │
│ __$operation = 3           │
│ Status = PENDING           │
└────────────────────────────┘
              +
┌────────────────────────────┐
│ CDC UPDATE_AFTER           │
│ __$operation = 4           │
│ Status = CONFIRMED         │
└────────────────────────────┘
```

The two records therefore preserve the transition rather than only the final source state.

This is fundamentally different from reading the source table after the update, where only the resulting `CONFIRMED` state remains visible.

### 13.4 Update Mask

The observed update mask for the operation was:

```text
__$update_mask = 0x0108
```

The mask corresponded to the columns affected by the controlled update:

```text
TRN_TRNST_id
TRN_updated_at
```

The observation demonstrated that `__$update_mask` provides metadata about the captured columns declared as affected by the update operation.

Conceptually:

```text
UPDATE
│
├── TRN_TRNST_id
└── TRN_updated_at
        │
        ▼
__$update_mask = 0x0108
```

The mask should therefore be interpreted in relation to the captured-column ordinal mapping for the capture instance rather than as an independent business identifier.

### 13.5 Observed Result

The two CDC rows representing the update shared the same transaction and command context.

The observed relationship was:

```text
UPDATE_BEFORE
│
├── __$operation = 3
├── __$start_lsn = same
├── __$command_id = same
├── __$seqval = same
└── __$update_mask = 0x0108

UPDATE_AFTER
│
├── __$operation = 4
├── __$start_lsn = same
├── __$command_id = same
├── __$seqval = same
└── __$update_mask = 0x0108
```

The metadata that distinguished the paired row images was therefore the operation code:

```text
3 → state before UPDATE
4 → state after UPDATE
```

while the shared metadata allowed both records to be interpreted as two images of the same update operation.

For the controlled status transition:

```text
PENDING
   │
   │ UPDATE
   ▼
CONFIRMED
```

CDC preserved:

```text
PENDING      → operation 3
CONFIRMED    → operation 4
```

This provided direct evidence that the configured CDC all-changes model preserves both sides of the source state transition.

### 13.6 Conclusion

M01.13 successfully validated the CDC representation of a controlled `UPDATE` on `sales.Transaction`.

The status transition:

```text
PENDING
    ↓
CONFIRMED
```

produced two CDC records:

```text
operation 3 → UPDATE_BEFORE
operation 4 → UPDATE_AFTER
```

Both records shared the same:

```text
__$start_lsn
__$command_id
__$seqval
__$update_mask
```

and the observed update mask:

```text
0x0108
```

identified the affected captured columns:

```text
TRN_TRNST_id
TRN_updated_at
```

The experiment therefore established that a CDC update must be interpreted as a correlated before/after pair rather than as two independent business changes.

This transaction model becomes increasingly important when multiple update commands are executed within the same SQL transaction, which is the behavior evaluated in M01.14.

**M01.13 Status: PASS**

---

## 14. Multiple UPDATE Commands in One Transaction — M01.14

After validating the before-and-after representation of a single `UPDATE`, the next experiment increased the transactional complexity.

M01.14 executed multiple `UPDATE` commands against the same `sales.Transaction` row within a single SQL transaction.

The purpose was to determine how CDC distinguishes separate source commands while preserving their common transaction context.

### 14.1 Objective

The objective of M01.14 was to validate:

- whether multiple `UPDATE` commands executed within one SQL transaction share the same CDC transaction context;
- how separate commands within that transaction are distinguished;
- whether each update produces its own `UPDATE_BEFORE` and `UPDATE_AFTER` pair;
- how `__$command_id` behaves across multiple commands;
- how `__$update_mask` differs according to the columns affected by each command;
- how CDC metadata can be used to reconstruct the structure of a multi-command transaction.

The controlled experiment continued with:

```text
TRN_id = 6307
```

whose previous state had been established through M01.12 and M01.13.

### 14.2 Transaction Structure

Two separate `UPDATE` commands were executed inside one SQL transaction.

The first command changed the transaction status from:

```text
CONFIRMED
```

to:

```text
COMPLETED
```

and also affected the transaction update timestamp.

The second command changed the monetary values from:

```text
Gross Amount:
100

Discount Amount:
10
```

to:

```text
Gross Amount:
105

Discount Amount:
15
```

and also affected the transaction update timestamp.

Conceptually:

```text
BEGIN TRANSACTION
│
├── Command 1
│   └── UPDATE status + updated_at
│
├── Command 2
│   └── UPDATE gross amount + discount amount + updated_at
│
└── COMMIT
```

Although the commands were executed separately, they belonged to one committed SQL transaction.

### 14.3 Command Ordering

CDC preserved a common transaction context while distinguishing the two source commands.

The observed command identifiers were:

```text
Command 1
__$command_id = 1

Command 2
__$command_id = 2
```

Both commands belonged to the same transaction context represented by the shared:

```text
__$start_lsn
```

The resulting model was:

```text
One SQL Transaction
│
├── __$start_lsn = shared
│
├── Command 1
│   └── __$command_id = 1
│
└── Command 2
    └── __$command_id = 2
```

This demonstrated that transaction identity and command identity represent different levels of CDC metadata.

A consumer must therefore not treat every CDC row sharing the same transaction LSN as if it came from the same individual SQL command.

### 14.4 Update Masks

Each command affected a different set of captured source columns.

For the first update, the observed mask was:

```text
__$update_mask = 0x0108
```

corresponding to:

```text
TRN_TRNST_id
TRN_updated_at
```

For the second update, the observed mask was:

```text
__$update_mask = 0x0160
```

corresponding to:

```text
TRN_gross_amount
TRN_discount_amount
TRN_updated_at
```

Therefore:

```text
Command 1
│
├── Status
├── Updated At
└── Mask = 0x0108

Command 2
│
├── Gross Amount
├── Discount Amount
├── Updated At
└── Mask = 0x0160
```

The experiment demonstrated that `__$update_mask` is associated with the affected captured columns of each update command rather than with the transaction as a whole.

Two commands in the same transaction can therefore share a transaction LSN while carrying different update masks.

### 14.5 Transaction Correlation

Each update command produced its own before-and-after pair.

Conceptually, the CDC representation was:

```text
Shared __$start_lsn
│
├── Command 1 — __$command_id = 1
│   │
│   ├── operation = 3
│   │   UPDATE_BEFORE
│   │
│   └── operation = 4
│       UPDATE_AFTER
│
└── Command 2 — __$command_id = 2
    │
    ├── operation = 3
    │   UPDATE_BEFORE
    │
    └── operation = 4
        UPDATE_AFTER
```

Within each pair, the before and after images shared the corresponding:

```text
__$start_lsn
__$command_id
__$seqval
__$update_mask
```

while `__$operation` distinguished the two row images.

Across the two commands:

```text
__$start_lsn
    → remained shared

__$command_id
    → distinguished command 1 from command 2

__$update_mask
    → reflected the columns affected by each command
```

This established a more complete transaction model than could be derived from the single-update test alone.

### 14.6 Observed Result

After the transaction completed, the final source state for the controlled values was:

```text
Status:
COMPLETED

Gross Amount:
105

Discount Amount:
15
```

CDC preserved the intermediate command boundaries rather than exposing only this final source state.

The observed transaction structure can be summarized as:

```text
SQL Transaction
│
│  shared __$start_lsn
│
├── Command 1
│   ├── __$command_id = 1
│   ├── __$update_mask = 0x0108
│   ├── operation 3 → before
│   └── operation 4 → after
│
└── Command 2
    ├── __$command_id = 2
    ├── __$update_mask = 0x0160
    ├── operation 3 → before
    └── operation 4 → after
```

This demonstrated why CDC rows cannot be interpreted correctly as isolated records.

The meaning of an individual row depends on its surrounding transaction and command metadata.

### 14.7 Conclusion

M01.14 successfully validated the CDC representation of multiple `UPDATE` commands executed within one SQL transaction.

The experiment demonstrated that the two commands shared the same:

```text
__$start_lsn
```

while being distinguished by:

```text
__$command_id = 1
__$command_id = 2
```

Each command produced its own correlated:

```text
UPDATE_BEFORE
+
UPDATE_AFTER
```

pair.

The different update masks:

```text
Command 1:
0x0108

Command 2:
0x0160
```

also demonstrated that column-change metadata belongs to the individual update command rather than to the transaction as a whole.

M01.14 therefore established a central CDC interpretation principle for Atlas Engineering:

```text
CDC rows must be interpreted in transaction context.
```

A transaction can contain multiple commands, and each command can produce multiple CDC row images. Correct interpretation requires preserving the relationship between transaction LSN, command identifier, sequence value, operation, and update mask.

**M01.14 Status: PASS**

---

## 15. Controlled DELETE — M01.15

After validating `INSERT` and `UPDATE` behavior, the next experiment completed the basic DML validation cycle by testing a controlled hard `DELETE`.

M01.15 deleted the transaction created during M01.12 and subsequently modified during M01.13 and M01.14.

The experiment was designed to determine whether SQL Server CDC preserved evidence of a row after that row no longer existed in the source table.

This behavior is particularly important for capture-strategy design because a timestamp-based incremental mechanism can identify changed rows that remain present, but cannot inherently discover a row that has been physically removed from the source.

### 15.1 Objective

The objective of M01.15 was to validate:

- whether a committed hard `DELETE` was captured by CDC;
- how the deleted row was represented in the CDC change table;
- which CDC operation code represented the deletion;
- whether the last source-row image remained available through CDC after the source row itself had been removed;
- why hard-delete detection is an important capability of the capture mechanism selected for high-change transactional tables.

The controlled test used:

```text
TRN_id = 6307
```

Before the delete, the test transaction had no remaining child rows in `sales.TransactionItem`.

This allowed the experiment to isolate the direct deletion of the parent transaction without introducing referential cascade behavior.

Cascade behavior was evaluated separately during M01.19.

### 15.2 Source State Before DELETE

Before executing the controlled delete, the source state was validated.

The relevant state was:

```text
sales.Transaction
TRN_id = 6307
Rows = 1

sales.TransactionItem
Rows associated with TRN_id = 6307
Rows = 0
```

The test therefore began with:

```text
Parent transaction:
EXISTS

Child transaction items:
NONE
```

This baseline made the expected source transition unambiguous.

The only row expected to be physically removed by the controlled action was the `sales.Transaction` row itself.

### 15.3 DELETE Execution

The controlled action removed:

```text
TRN_id = 6307
```

from:

```text
sales.Transaction
```

After the delete was committed, source validation showed:

```text
sales.Transaction
TRN_id = 6307
Rows = 0
```

The source transition was therefore:

```text
Before DELETE
│
└── TRN_id 6307 exists
        │
        │ DELETE + COMMIT
        ▼
After DELETE
│
└── TRN_id 6307 no longer exists
```

At the source-table level, the row was no longer available for a future incremental query to rediscover.

### 15.4 CDC DELETE Representation

CDC preserved a change record representing the deleted transaction.

The observed operation was:

```text
__$operation = 1
```

Within the CDC operation model:

```text
1 = DELETE
2 = INSERT
3 = UPDATE_BEFORE
4 = UPDATE_AFTER
```

Therefore:

```text
Source DELETE
      ↓
CDC operation = 1
```

The CDC record preserved the last captured row image associated with the deleted source row.

The observed update mask was:

```text
__$update_mask = 0x01FF
```

representing the complete captured-column set for the deleted row.

Conceptually:

```text
sales.Transaction
│
│ DELETE TRN_id = 6307
▼
Source row removed
│
│
└──────────────► CDC
                 │
                 ├── __$operation = 1
                 ├── __$update_mask = 0x01FF
                 └── deleted row image preserved
```

This means that the disappearance of the row from the source did not eliminate the evidence required to identify the deletion within the CDC retention window.

### 15.5 Hard DELETE Detection

The controlled test demonstrated a critical difference between change capture and a simple timestamp-based incremental query.

Consider a model that retrieves only source rows satisfying a condition such as:

```sql
WHERE updated_at > @watermark
```

After a hard delete:

```text
Deleted row
    ↓
No longer exists in source
    ↓
Cannot satisfy a future source-table WHERE condition
```

The row has disappeared from the dataset being queried.

Without another deletion mechanism, the consumer cannot determine from the remaining source rows alone that the deleted record previously existed.

CDC provides explicit deletion evidence:

```text
Existing Row
    │
    │ DELETE
    ▼
No Source Row
    +
CDC operation = 1
```

This capability is one of the important reasons CDC is appropriate for the high-change transactional scope where hard-delete propagation is required.

The experiment does not imply that timestamp incremental strategies are universally unsuitable.

It establishes the narrower engineering conclusion that a timestamp watermark alone does not provide equivalent hard-delete detection for a physically removed row.

### 15.6 Observed Result

The final controlled state was:

```text
Source
│
└── TRN_id = 6307
    └── NOT PRESENT

CDC
│
└── TRN_id = 6307
    ├── __$operation = 1
    ├── __$update_mask = 0x01FF
    └── last row image preserved
```

The experiment therefore demonstrated:

```text
Hard DELETE
     │
     ├── removes row from source
     │
     └── produces explicit CDC DELETE evidence
```

The controlled test involved only the direct deletion of the transaction row because no child `sales.TransactionItem` records existed for `TRN_id = 6307`.

This distinction is important because M01.15 proves direct hard-delete capture, while M01.19 later evaluates the more complex case in which one explicit parent delete causes additional physical child deletions through `ON DELETE CASCADE`.

### 15.7 Conclusion

M01.15 successfully validated the CDC representation of a controlled hard `DELETE` on `sales.Transaction`.

The source row:

```text
TRN_id = 6307
```

was physically removed from `sales.Transaction`, while CDC preserved a corresponding change record represented by:

```text
__$operation = 1
__$update_mask = 0x01FF
```

The experiment therefore demonstrated that SQL Server CDC can provide explicit evidence of a hard deletion even after the deleted row is no longer present in the source table.

This establishes an important capture-strategy requirement for Atlas Engineering:

```text
If hard DELETE detection is required,
the capture mechanism must preserve deletion evidence.
```

A timestamp watermark applied only to rows that remain in the source cannot provide equivalent evidence of a physically deleted row.

With the basic `INSERT`, `UPDATE`, and `DELETE` behaviors validated for `sales.Transaction`, the next implementation stage extends CDC to `sales.TransactionItem` so that transaction behavior can be evaluated across related source tables.

**M01.15 Status: PASS**

---

## 16. Enabling CDC on `sales.TransactionItem` — M01.16

After completing the basic `INSERT`, `UPDATE`, and `DELETE` validation cycle for `sales.Transaction`, the implementation scope was expanded to `sales.TransactionItem`.

The purpose of M01.16 was not only to enable a second table for CDC, but also to prepare the environment for controlled cross-table transaction experiments.

Because `sales.TransactionItem` participates in the transactional relationship with `sales.Transaction`, its source structure and referential behavior were validated before CDC was enabled.

### 16.1 Pre-Enable Validation — M01.16A

Before modifying the table-level CDC configuration, the current state of `sales.TransactionItem` was inspected.

The observed state was:

```text
Source Table:
sales.TransactionItem

CDC Tracked:
No

Existing Rows:
13,769
```

Therefore:

```text
is_tracked_by_cdc = 0
```

confirmed that the table had not yet entered a CDC capture instance.

This provided the pre-enable baseline required to distinguish the existing source state from changes generated after the CDC boundary was established.

The validation also inspected the table's primary key, referential relationship with `sales.Transaction`, and partitioning model because these characteristics were directly relevant to the cross-table CDC experiments planned for subsequent stages.

### 16.2 Primary Key

The primary key identified for `sales.TransactionItem` was:

```text
PK_TRNIT
```

with the key structure:

```text
TRNIT_id
TRNIT_transaction_at
```

Conceptually:

```text
PK_TRNIT
│
├── TRNIT_id
└── TRNIT_transaction_at
```

This key was later used as the configured index for the CDC capture instance.

The composite-key structure is part of the source-table design and remains distinct from the CDC metadata used to identify transaction and command context.

### 16.3 Foreign Key and ON DELETE CASCADE

The relationship between `sales.TransactionItem` and its parent transaction was validated before CDC enablement.

The observed foreign key was:

```text
FK_TRNIT_TRN
```

with:

```text
ON DELETE CASCADE
```

Therefore, deleting a parent row from `sales.Transaction` can cause the related rows in `sales.TransactionItem` to be physically deleted by SQL Server through referential action.

Conceptually:

```text
sales.Transaction
        │
        │ DELETE parent
        ▼
FK_TRNIT_TRN
ON DELETE CASCADE
        │
        ▼
sales.TransactionItem
related child rows deleted
```

This behavior was important to establish before the cross-table delete experiment.

It creates a distinction between:

```text
Application action
```

and:

```text
Physical database changes
```

One explicit parent `DELETE` statement can result in multiple physical row deletions across related tables.

At this stage, the referential configuration was verified.

The actual CDC representation of the cascade was not yet considered proven and was validated separately during M01.19.

### 16.4 Partitioning

`sales.TransactionItem` was also confirmed to be partitioned.

Its partitioning followed the same monthly source-model context used by the related transactional data.

The relevant implementation state was therefore:

```text
sales.TransactionItem
│
├── Composite primary key
├── Parent foreign key
│   └── ON DELETE CASCADE
├── Partitioned
└── CDC not yet enabled
```

Because the table was partitioned, enabling CDC introduced the same class of partition-switching consideration previously evaluated for `sales.Transaction`.

The V1 governance principle remained unchanged: partition switching is not treated as the normal ingestion path and requires explicit control when used with CDC-enabled tables.

### 16.5 CDC Enablement — M01.16B

After the pre-enable validation was completed, CDC was enabled on `sales.TransactionItem`.

The resulting capture configuration included:

```text
Source Schema:
sales

Source Table:
TransactionItem

Capture Instance:
sales_TransactionItem

Index:
PK_TRNIT

Supports Net Changes:
0
```

The table was configured to capture all nine source columns.

As with `sales.Transaction`, net-changes support remained disabled:

```text
supports_net_changes = 0
```

This preserved the detailed all-changes model required for the controlled transaction experiments.

The essential table-level implementation followed the same CDC mechanism used for the first transactional table:

```sql
EXEC sys.sp_cdc_enable_table
    @source_schema        = N'sales',
    @source_name          = N'TransactionItem',
    @role_name            = NULL,
    @supports_net_changes = 0;
```

The complete execution and validation logic is maintained in the corresponding M01.16 SQL scripts.

### 16.6 Capture Instance

SQL Server created the capture instance:

```text
sales_TransactionItem
```

The observed start LSN was:

```text
0x0000002D00001044008A
```

The configured index was:

```text
PK_TRNIT
```

The resulting transactional CDC scope now contained two capture instances:

```text
AtlasCommerce
│
├── sales.Transaction
│   └── sales_Transaction
│
└── sales.TransactionItem
    └── sales_TransactionItem
```

This established the source-side infrastructure required for subsequent experiments involving one SQL transaction that modified both tables.

### 16.7 Generated CDC Objects

The table-level enablement created the CDC objects associated with the new capture instance.

The principal generated objects included:

```text
cdc.sales_TransactionItem_CT
cdc.fn_cdc_get_all_changes_sales_TransactionItem
```

Because:

```text
supports_net_changes = 0
```

the implementation did not create a corresponding net-changes query function for this capture instance.

The resulting CDC scope therefore provided separate change tables and all-changes functions for the parent and child transactional tables.

Conceptually:

```text
sales.Transaction
        │
        ▼
cdc.sales_Transaction_CT

sales.TransactionItem
        │
        ▼
cdc.sales_TransactionItem_CT
```

The separate physical capture structures made cross-table CDC correlation a metadata problem rather than a shared-table storage problem.

That behavior was evaluated during M01.17 through M01.19.

### 16.8 Initial Change Table State

Immediately after CDC enablement, the new change table contained:

```text
change_rows = 0
```

while the source table contained:

```text
sales.TransactionItem rows = 13,769
```

Therefore:

```text
Source:
13,769 existing rows

CDC change table:
0 rows
```

This reproduced the behavior previously observed for `sales.Transaction`.

Enabling CDC on an existing source table did not generate CDC records for rows that were already present.

The second capture instance therefore reinforced the previously established implementation principle:

```text
CDC enablement
        ≠
Historical backfill
```

The 13,769 existing `sales.TransactionItem` rows remained part of the initial backfill responsibility rather than becoming synthetic CDC events.

### 16.9 Initial Minimum LSN Observation

Immediately after enabling the new capture instance, an important transient state was observed.

The capture-instance metadata already contained the start LSN:

```text
0x0000002D00001044008A
```

while:

```text
sys.fn_cdc_get_min_lsn(...)
```

temporarily returned:

```text
NULL
```

At that observation point, the CDC capture process had not yet advanced sufficiently for the new capture instance's minimum queryable LSN to become available.

The state can be represented as:

```text
Capture instance created
        │
        ├── start_lsn established
        │
        └── minimum queryable LSN temporarily NULL
                         │
                         ▼
                  Capture advances
                         │
                         ▼
              minimum LSN becomes available
```

A later validation showed that the minimum LSN became:

```text
0x0000002D00001044008A
```

matching the capture-instance start LSN.

The transient `NULL` was therefore not treated as an enablement failure.

It demonstrated that capture-instance metadata creation and minimum LSN availability are not necessarily simultaneous.

This distinction becomes operationally important for scripts that enable a capture instance and immediately attempt to determine its queryable LSN range.

Such scripts must not automatically interpret an immediate `NULL` minimum LSN as evidence that table-level CDC enablement failed.

### 16.10 Conclusion

M01.16 successfully expanded the CDC implementation from `sales.Transaction` to `sales.TransactionItem`.

The pre-enable validation established:

```text
Existing rows = 13,769
CDC tracked = No
Primary key = PK_TRNIT
Foreign key = FK_TRNIT_TRN
Delete behavior = ON DELETE CASCADE
Partitioned = Yes
```

CDC was then enabled with:

```text
capture_instance = sales_TransactionItem
index = PK_TRNIT
supports_net_changes = 0
captured columns = 9
start_lsn = 0x0000002D00001044008A
```

SQL Server created the corresponding change table and all-changes function, while the initial change table remained empty despite the 13,769 rows already present in the source.

The implementation also captured an important transient behavior: immediately after enablement, the capture instance had an established start LSN while its minimum queryable LSN temporarily returned `NULL`. The minimum LSN subsequently became available and matched the capture-instance start LSN.

With both transactional tables now CDC-enabled, the source environment was prepared for controlled cross-table transaction validation.

**M01.16 Status: PASS**

---

## 17. Cross-Table CDC Preparation — M01.17A

With both `sales.Transaction` and `sales.TransactionItem` enabled for CDC, the next stage prepared the environment for controlled cross-table transaction validation.

Before generating a transaction that modified both source tables, M01.17A verified the active capture instances and inspected their current LSN state.

During this preparation, the validation script exposed an incorrect use of `sys.sp_cdc_help_change_data_capture`. The error was diagnosed and corrected before the cross-table experiment continued.

### 17.1 Objective

The objective of M01.17A was to:

- confirm that both transactional capture instances were active;
- inspect the CDC configuration before generating cross-table changes;
- establish the available LSN state for both capture instances;
- verify that the environment was ready for cross-table transaction testing;
- correct any validation-script issues before producing new evidence.

The expected capture instances were:

```text
sales_Transaction
sales_TransactionItem
```

This preparation step was intentionally separated from the transaction test so that configuration validation and change-generation evidence would not be mixed.

### 17.2 Capture Instance Validation

The environment was inspected to confirm that both source tables remained CDC-enabled.

The expected mapping was:

```text
sales.Transaction
        │
        └── capture_instance
            sales_Transaction

sales.TransactionItem
        │
        └── capture_instance
            sales_TransactionItem
```

Both capture instances were available.

This established the required source-side configuration for the next experiment, where one SQL transaction would insert rows into both source tables.

### 17.3 `sp_cdc_help_change_data_capture` Script Error

During the validation procedure, the script attempted to execute:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

SQL Server returned:

```text
Msg 22972
```

The error occurred because the procedure call supplied `@source_schema` without also supplying the corresponding source table name.

This was a validation-script error.

It was not evidence of:

```text
CDC capture failure
CDC metadata corruption
Capture instance failure
Cross-table CDC failure
```

No cross-table transaction had yet been executed as part of M01.17B.

The error therefore had to be corrected before continuing so that the preparation stage itself remained reliable.

### 17.4 Root Cause

`sys.sp_cdc_help_change_data_capture` does not support supplying only:

```text
@source_schema
```

The procedure requires the source schema and source name to be supplied together when requesting information for a specific source table, or neither parameter when requesting the available capture configuration.

The invalid pattern was:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

Conceptually:

```text
source_schema supplied
        +
source_name omitted
        ↓
Invalid parameter combination
        ↓
Msg 22972
```

The failure was therefore caused by the inspection script's parameter usage rather than by the CDC configuration itself.

This distinction is important to the evidence model:

```text
Script failure
    ≠
CDC failure
```

An implementation error must be diagnosed at the layer where it occurred before conclusions are drawn about the underlying platform behavior.

### 17.5 Correction

For the required validation, the procedure was corrected to list the configured CDC capture information without the invalid partial filter:

```sql
EXEC sys.sp_cdc_help_change_data_capture;
```

This allowed the active capture configuration to be inspected correctly.

When information for an individual source table is required, the schema and source name must instead be supplied together.

The corrected validation logic restored the preparation workflow without requiring a CDC reconfiguration.

No capture instance needed to be disabled, recreated, or repaired as a result of the original error.

### 17.6 LSN State

After the validation script was corrected, the LSN state of the two capture instances was inspected.

The observed minimum LSN for `sales_Transaction` was:

```text
0x0000002C0000FCEC0067
```

The observed minimum LSN for `sales_TransactionItem` was:

```text
0x0000002D00001044008A
```

These values corresponded to the respective capture-instance boundaries established when CDC was enabled on each source table.

The capture instances therefore did not have identical minimum LSN values:

```text
sales_Transaction
min_lsn =
0x0000002C0000FCEC0067

sales_TransactionItem
min_lsn =
0x0000002D00001044008A
```

This difference is expected in the implementation context because the two tables entered CDC at different stages.

At the observation point, both capture instances shared the same currently available maximum processed LSN.

Conceptually:

```text
CDC timeline
──────────────────────────────────────────────────────►

sales_Transaction
      │
      └── starts earlier
          min_lsn =
          0x0000002C0000FCEC0067
          │
          └──────────────────────────────┐
                                         │
                                         ▼
                                    current max LSN

sales_TransactionItem
                    │
                    └── starts later
                        min_lsn =
                        0x0000002D00001044008A
                        │
                        └────────────────┘
```

This established an important boundary for future cross-table consumption.

A consumer querying multiple capture instances cannot automatically assume that every capture instance has the same historical lower LSN boundary.

The actual incremental-consumption algorithm and checkpoint strategy had not yet been implemented and therefore remain outside the evidence established by M01.17A.

### 17.7 Conclusion

M01.17A successfully prepared the CDC environment for cross-table transaction testing.

Both capture instances were confirmed:

```text
sales_Transaction
sales_TransactionItem
```

and their minimum LSN values were observed as:

```text
sales_Transaction:
0x0000002C0000FCEC0067

sales_TransactionItem:
0x0000002D00001044008A
```

Both capture instances had reached the same currently available maximum processed LSN at the validation point.

The preparation stage also identified an error in the original validation script:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

which produced:

```text
Msg 22972
```

The root cause was the invalid partial parameter combination. The script was corrected to:

```sql
EXEC sys.sp_cdc_help_change_data_capture;
```

and CDC itself required no repair or reconfiguration.

M01.17A therefore established both the technical readiness of the two capture instances and an important engineering principle for the implementation record:

```text
A validation-script error must not be misclassified
as a failure of the technology being validated.
```

With the preparation complete, the environment was ready for M01.17B: the first controlled SQL transaction producing related changes across both CDC-enabled source tables.

**M01.17A Status: PASS WITH SCRIPT CORRECTION**

---

## 18. Cross-Table INSERT Transaction — M01.17B

With both capture instances validated, the next experiment introduced the first controlled transaction that modified both CDC-enabled source tables.

M01.17B inserted one parent row into `sales.Transaction` and two related child rows into `sales.TransactionItem` within a single SQL transaction.

The purpose was to determine whether CDC metadata could be used to correlate changes captured independently by two different capture instances back to the same source transaction.

### 18.1 Objective

The objective of M01.17B was to validate:

- whether changes to multiple CDC-enabled tables within one SQL transaction share a common transaction context;
- whether the parent and child inserts could be correlated through `__$start_lsn`;
- how `__$command_id` distinguished the individual source commands;
- whether command ordering remained observable across the two capture instances;
- whether CDC availability remained asynchronous for a cross-table transaction;
- what the source-side evidence did and did not prove about future downstream transaction handling.

The experiment was designed specifically to distinguish:

```text
One SQL transaction
```

from:

```text
Multiple independently stored CDC records
```

### 18.2 Transaction Structure

The controlled SQL transaction executed three insert commands:

```text
BEGIN TRANSACTION
│
├── Command 1
│   └── INSERT sales.Transaction
│
├── Command 2
│   └── INSERT sales.TransactionItem
│
├── Command 3
│   └── INSERT sales.TransactionItem
│
└── COMMIT
```

The parent insert created:

```text
TRN_id:
6308

Status:
PENDING

Channel:
ONLINE

Gross Amount:
150

Discount Amount:
15
```

Two related transaction items were created:

```text
Transaction Item:
13770

Product Variant:
1

Quantity:
1

Price:
100

Discount:
10
```

and:

```text
Transaction Item:
13771

Product Variant:
2

Quantity:
1

Price:
50

Discount:
5
```

The three source rows therefore belonged to one explicitly controlled SQL transaction.

### 18.3 Source Rows Created

After the transaction committed, the expected source state was present across both tables.

Conceptually:

```text
sales.Transaction
│
└── TRN_id = 6308
    ├── PENDING
    ├── ONLINE
    ├── Gross = 150
    └── Discount = 15
          │
          ├─────────────────────────┐
          │                         │
          ▼                         ▼
sales.TransactionItem       sales.TransactionItem
│                           │
└── TRNIT_id = 13770        └── TRNIT_id = 13771
    ├── ProductVariant = 1      ├── ProductVariant = 2
    ├── Quantity = 1            ├── Quantity = 1
    ├── Price = 100             ├── Price = 50
    └── Discount = 10           └── Discount = 5
```

The source database therefore contained the complete parent-child state immediately after commit.

The next question was whether the corresponding CDC records were already available.

### 18.4 Immediate CDC State

Immediately after the SQL transaction committed, the CDC inspection returned:

```text
sales_Transaction matching changes:
0

sales_TransactionItem matching changes:
0
```

Therefore:

```text
Source transaction:
COMMITTED

Parent source row:
AVAILABLE

Child source rows:
AVAILABLE

Parent CDC record:
NOT YET AVAILABLE

Child CDC records:
NOT YET AVAILABLE
```

This reproduced, across multiple capture instances, the asynchronous behavior previously observed during the first controlled `INSERT`.

The source transaction was complete before its corresponding CDC representations became visible.

### 18.5 Captured CDC State

After allowing time for CDC capture processing, the transaction was inspected again.

The resulting CDC state was:

```text
sales_Transaction:
1 captured INSERT

sales_TransactionItem:
2 captured INSERTs
```

The three CDC records represented the three source commands executed within the original SQL transaction.

All three records were captured with:

```text
__$operation = 2
__$update_mask = 0x01FF
```

The operation code confirmed that all three records represented inserts.

The complete captured structure was therefore:

```text
sales_Transaction
│
└── TRN_id = 6308
    ├── operation = 2
    └── update_mask = 0x01FF

sales_TransactionItem
│
├── TRNIT_id = 13770
│   ├── operation = 2
│   └── update_mask = 0x01FF
│
└── TRNIT_id = 13771
    ├── operation = 2
    └── update_mask = 0x01FF
```

The asynchronous transition observed in the experiment was:

```text
COMMIT
   ↓
Source rows available
   ↓
Immediate CDC inspection
   ↓
Transaction = 0
TransactionItem = 0
   ↓
CDC capture processing
   ↓
Transaction = 1
TransactionItem = 2
```

### 18.6 Cross-Table Transaction Correlation

The most important observation from M01.17B was that all three captured records shared the same:

```text
__$start_lsn =
0x0000002D00001A740028
```

Therefore:

```text
sales.Transaction
TRN_id = 6308
        │
        └── __$start_lsn
            0x0000002D00001A740028

sales.TransactionItem
TRNIT_id = 13770
        │
        └── __$start_lsn
            0x0000002D00001A740028

sales.TransactionItem
TRNIT_id = 13771
        │
        └── __$start_lsn
            0x0000002D00001A740028
```

The experiment therefore provided direct evidence that changes captured by different CDC capture instances can preserve a shared transaction LSN when they originate from the same SQL transaction.

This is a fundamental result for the future consumption model.

The CDC records are physically exposed through different capture-instance structures:

```text
cdc.sales_Transaction_CT

cdc.sales_TransactionItem_CT
```

but their transaction metadata allows the related source changes to be correlated.

Conceptually:

```text
                    SQL Transaction
                          │
             shared __$start_lsn
                          │
              ┌───────────┴───────────┐
              │                       │
              ▼                       ▼
sales_Transaction CDC       sales_TransactionItem CDC
      1 record                     2 records
```

### 18.7 Command Ordering

Although all three records shared the same transaction LSN, their command identifiers were different.

The observed command ordering was:

```text
Parent INSERT
TRN_id = 6308
__$command_id = 1

First Child INSERT
TRNIT_id = 13770
__$command_id = 2

Second Child INSERT
TRNIT_id = 13771
__$command_id = 3
```

This matched the controlled command sequence executed within the SQL transaction:

```text
Command 1
    → INSERT parent

Command 2
    → INSERT first child

Command 3
    → INSERT second child
```

The resulting metadata model was:

```text
__$start_lsn =
0x0000002D00001A740028
│
├── __$command_id = 1
│   └── sales.Transaction / 6308
│
├── __$command_id = 2
│   └── sales.TransactionItem / 13770
│
└── __$command_id = 3
    └── sales.TransactionItem / 13771
```

M01.17B therefore extended the transaction model previously observed within a single table.

`__$command_id` remained useful for distinguishing commands even when those commands affected different CDC-enabled source tables.

### 18.8 Evidence Boundary

The cross-table experiment established source-side SQL Server CDC behavior.

It proved that, under the controlled laboratory transaction:

```text
One SQL transaction
        ↓
Changes across two CDC-enabled tables
        ↓
Shared __$start_lsn
        +
Distinct __$command_id values
```

It did not prove how future downstream technologies will preserve or expose that relationship.

In particular, M01.17B does not establish that:

```text
Debezium
Kafka
Bronze ingestion
Future CDC consumer
```

will automatically deliver the three captured changes as one indivisible downstream package.

Those components had not yet been implemented or tested.

Therefore:

```text
SQL Server transaction correlation
        ≠
Proven downstream atomic delivery
```

The evidence supports a future design that can use CDC transaction metadata for correlation.

It does not permit the implementation document to claim end-to-end transactional atomicity before the downstream capture path has been validated.

### 18.9 Conclusion

M01.17B successfully validated the first controlled cross-table CDC transaction.

One SQL transaction inserted:

```text
1 sales.Transaction row
+
2 sales.TransactionItem rows
```

and all three captured CDC records shared:

```text
__$start_lsn =
0x0000002D00001A740028
```

while their command identifiers preserved the controlled source-command sequence:

```text
1 → parent INSERT
2 → first child INSERT
3 → second child INSERT
```

All three records were represented as:

```text
__$operation = 2
__$update_mask = 0x01FF
```

The experiment also reproduced the asynchronous capture model: the committed source rows were available before their CDC records appeared.

Most importantly, M01.17B established direct evidence that CDC metadata can correlate changes originating from the same SQL transaction across separate capture instances.

The evidence remains intentionally bounded to SQL Server CDC. Downstream transactional representation, delivery ordering, atomicity, and persistence had not yet been tested and therefore remain unproven.

**M01.17B Status: PASS**

---

## 19. Coordinated Cross-Table UPDATE — M01.18

After validating a cross-table `INSERT` transaction, the next experiment examined coordinated updates across the same parent-child structure.

M01.18 updated the `sales.Transaction` row and both related `sales.TransactionItem` rows created during M01.17B within a single SQL transaction.

The objective was to determine how SQL Server CDC represents multiple update commands across different capture instances while preserving transaction correlation, command boundaries, sequence information, before-and-after images, and column-change metadata.

### 19.1 Objective

The objective of M01.18 was to validate:

- whether coordinated updates across multiple CDC-enabled tables share the same `__$start_lsn`;
- whether separate update commands remain distinguishable through `__$command_id`;
- how `__$seqval` behaves across the captured commands;
- whether each update preserves its own `UPDATE_BEFORE` and `UPDATE_AFTER` pair;
- whether each update pair shares the same transaction, command, sequence, and update-mask metadata;
- whether different update commands produce masks corresponding to their respective affected columns.

The experiment reused the parent-child dataset established during M01.17B:

```text
sales.Transaction
TRN_id = 6308

sales.TransactionItem
TRNIT_id = 13770

sales.TransactionItem
TRNIT_id = 13771
```

### 19.2 Transaction Structure

One SQL transaction executed three coordinated update commands.

Conceptually:

```text
BEGIN TRANSACTION
│
├── Command 1
│   └── UPDATE sales.Transaction
│
├── Command 2
│   └── UPDATE sales.TransactionItem
│       TRNIT_id = 13770
│
├── Command 3
│   └── UPDATE sales.TransactionItem
│       TRNIT_id = 13771
│
└── COMMIT
```

The parent transaction was changed from its previous state to:

```text
TRN_id:
6308

Status:
CONFIRMED

Gross Amount:
200

Discount Amount:
20
```

The first child became:

```text
TRNIT_id:
13770

Quantity:
2

Price:
100

Discount:
15
```

The second child became:

```text
TRNIT_id:
13771

Quantity:
1

Price:
60

Discount:
5
```

All three updates were committed as part of the same SQL transaction.

### 19.3 Final Source State

After commit, the final source state was:

```text
sales.Transaction
│
└── TRN_id = 6308
    ├── Status = CONFIRMED
    ├── Gross = 200
    └── Discount = 20
          │
          ├───────────────────────────┐
          │                           │
          ▼                           ▼
sales.TransactionItem         sales.TransactionItem
│                             │
└── TRNIT_id = 13770          └── TRNIT_id = 13771
    ├── Quantity = 2              ├── Quantity = 1
    ├── Price = 100               ├── Price = 60
    └── Discount = 15             └── Discount = 5
```

The source table shows only the resulting state after commit.

CDC, however, preserved the transitions that produced that final state.

### 19.4 Shared Transaction LSN

All six CDC records generated by the three update commands shared:

```text
__$start_lsn =
0x0000002D00001CB9000E
```

The six records consisted of:

```text
Parent UPDATE:
2 CDC records

First Child UPDATE:
2 CDC records

Second Child UPDATE:
2 CDC records
```

Therefore:

```text
One SQL Transaction
        │
        │ shared __$start_lsn
        ▼
0x0000002D00001CB9000E
        │
        ├── Parent UPDATE_BEFORE
        ├── Parent UPDATE_AFTER
        ├── Child 13770 UPDATE_BEFORE
        ├── Child 13770 UPDATE_AFTER
        ├── Child 13771 UPDATE_BEFORE
        └── Child 13771 UPDATE_AFTER
```

This reproduced and extended the cross-table correlation behavior observed during M01.17B.

The experiment demonstrated that the shared transaction LSN remained available even when each source command generated two CDC row images rather than a single insert record.

### 19.5 Command IDs and Sequence Values

The three source commands were distinguished through `__$command_id`.

The observed structure was:

```text
Parent UPDATE
│
├── __$command_id = 1
└── __$seqval = ...0002

Child 13770 UPDATE
│
├── __$command_id = 2
└── __$seqval = ...0007

Child 13771 UPDATE
│
├── __$command_id = 3
└── __$seqval = ...000B
```

The complete sequence values differed across the three commands, while each before-and-after pair shared its corresponding sequence value.

Conceptually:

```text
Shared __$start_lsn
│
├── Command 1
│   ├── seqval ...0002
│   ├── operation 3
│   └── operation 4
│
├── Command 2
│   ├── seqval ...0007
│   ├── operation 3
│   └── operation 4
│
└── Command 3
    ├── seqval ...000B
    ├── operation 3
    └── operation 4
```

The experiment therefore provided evidence for distinct metadata responsibilities:

```text
__$start_lsn
    → common transaction context

__$command_id
    → command distinction within the transaction

__$seqval
    → sequencing information for captured changes

__$operation
    → before/after row-image semantics
```

The observed sequence values are evidence from this controlled transaction. They must not be generalized into an undocumented numeric increment rule.

### 19.6 Update Masks

Each update command produced an update mask corresponding to the captured columns affected by that command.

For the parent update:

```text
TRN_id:
6308

__$command_id:
1

__$update_mask:
0x0168
```

For the first child update:

```text
TRNIT_id:
13770

__$command_id:
2

__$update_mask:
0x0150
```

For the second child update:

```text
TRNIT_id:
13771

__$command_id:
3

__$update_mask:
0x0120
```

The resulting model was:

```text
Parent
Command 1
Mask 0x0168
        │
        └── columns affected by parent UPDATE

Child 13770
Command 2
Mask 0x0150
        │
        └── columns affected by first child UPDATE

Child 13771
Command 3
Mask 0x0120
        │
        └── columns affected by second child UPDATE
```

The different masks demonstrated that the change-column metadata remained associated with each individual update command even though all three commands belonged to the same transaction.

Therefore:

```text
Same transaction
    ≠
Same update mask
```

### 19.7 UPDATE Pair Semantics

Each of the three source update commands produced a CDC pair consisting of:

```text
__$operation = 3
UPDATE_BEFORE

__$operation = 4
UPDATE_AFTER
```

Within each pair, the observed metadata relationship was:

```text
same __$start_lsn
same __$command_id
same __$seqval
same __$update_mask
different __$operation
```

The complete transaction can therefore be represented as:

```text
Shared __$start_lsn
0x0000002D00001CB9000E
│
├── Command 1 — Parent
│   ├── seqval ...0002
│   ├── mask 0x0168
│   ├── op 3 → UPDATE_BEFORE
│   └── op 4 → UPDATE_AFTER
│
├── Command 2 — Child 13770
│   ├── seqval ...0007
│   ├── mask 0x0150
│   ├── op 3 → UPDATE_BEFORE
│   └── op 4 → UPDATE_AFTER
│
└── Command 3 — Child 13771
    ├── seqval ...000B
    ├── mask 0x0120
    ├── op 3 → UPDATE_BEFORE
    └── op 4 → UPDATE_AFTER
```

This establishes that the six physical CDC records must not be interpreted as six unrelated business changes.

They represent:

```text
1 SQL transaction
3 UPDATE commands
3 before/after pairs
6 CDC row images
```

Correct interpretation therefore requires multiple levels of correlation.

### 19.8 Conclusion

M01.18 successfully validated coordinated cross-table `UPDATE` behavior.

One SQL transaction updated:

```text
1 sales.Transaction row
+
2 sales.TransactionItem rows
```

and produced:

```text
3 UPDATE commands
6 CDC records
```

All six records shared:

```text
__$start_lsn =
0x0000002D00001CB9000E
```

while the commands were distinguished by:

```text
Parent:
__$command_id = 1
__$seqval = ...0002
__$update_mask = 0x0168

Child 13770:
__$command_id = 2
__$seqval = ...0007
__$update_mask = 0x0150

Child 13771:
__$command_id = 3
__$seqval = ...000B
__$update_mask = 0x0120
```

Each command produced a correlated:

```text
operation 3 → UPDATE_BEFORE
operation 4 → UPDATE_AFTER
```

pair sharing the same transaction LSN, command identifier, sequence value, and update mask.

M01.18 therefore strengthened the CDC transaction model established during the previous experiments:

```text
Transaction
    → __$start_lsn

Command
    → __$command_id

Change sequencing
    → __$seqval

Row-image semantics
    → __$operation

Affected captured columns
    → __$update_mask
```

The experiment demonstrated this model across separate CDC capture instances while maintaining the boundary between SQL Server CDC evidence and downstream behavior that has not yet been implemented or tested.

**M01.18 Status: PASS**

---

## 20. Parent DELETE with ON DELETE CASCADE — M01.19

After validating coordinated cross-table inserts and updates, the final source-side CDC experiment examined referential cascade behavior.

M01.19 deleted the parent `sales.Transaction` row created during M01.17B and updated during M01.18.

Because the relationship from `sales.TransactionItem` was configured with `ON DELETE CASCADE`, the experiment allowed the project to distinguish between the single explicit action issued by the test and the multiple physical row changes produced by SQL Server.

### 20.1 Objective

The objective of M01.19 was to validate:

- whether an explicit parent `DELETE` was captured by CDC;
- whether child rows removed through `ON DELETE CASCADE` were also captured;
- whether parent and child delete records shared the same transaction context;
- how `__$command_id` and `__$seqval` represented the resulting physical changes;
- whether CDC exposed the physical database effects of the transaction rather than only the explicit application statement;
- whether cross-table correlation remained available for referentially generated deletes.

The experiment reused:

```text
sales.Transaction
TRN_id = 6308

sales.TransactionItem
TRNIT_id = 13770

sales.TransactionItem
TRNIT_id = 13771
```

### 20.2 Source State Before DELETE

Before executing the controlled delete, the source state was validated.

The parent row existed:

```text
sales.Transaction

TRN_id:
6308

Rows:
1
```

and two related child rows existed:

```text
sales.TransactionItem

TRNIT_id:
13770

TRNIT_id:
13771

Rows:
2
```

The starting state was therefore:

```text
Parent:
1 row

Children:
2 rows
```

The foreign-key relationship had previously been validated as:

```text
FK_TRNIT_TRN
ON DELETE CASCADE
```

This established the expected referential behavior before the test action was executed.

### 20.3 Explicit Parent DELETE

The controlled test issued a `DELETE` only against the parent table.

Conceptually:

```sql
DELETE
FROM sales.Transaction
WHERE TRN_id = 6308;
```

No explicit `DELETE` statement was issued against:

```text
sales.TransactionItem
```

The application-level action was therefore:

```text
1 explicit DELETE statement
        │
        ▼
sales.Transaction
TRN_id = 6308
```

Because the parent-child foreign key used `ON DELETE CASCADE`, SQL Server was responsible for removing the related child rows as part of the same transactional operation.

### 20.4 Referential Cascade

After the parent delete committed, the source state was:

```text
sales.Transaction
TRN_id = 6308
Rows = 0

sales.TransactionItem
TRNIT_id IN (13770, 13771)
Rows = 0
```

The physical source transition was therefore:

```text
Before
│
├── Parent 6308
├── Child 13770
└── Child 13771
        │
        │ explicit parent DELETE
        ▼
ON DELETE CASCADE
        │
        ▼
After
│
├── Parent 6308 removed
├── Child 13770 removed
└── Child 13771 removed
```

One explicit statement therefore resulted in three physical row deletions.

This distinction is essential when interpreting the resulting CDC records.

### 20.5 CDC Representation

CDC captured:

```text
sales.Transaction:
1 DELETE

sales.TransactionItem:
2 DELETEs
```

All three records were represented with:

```text
__$operation = 1
```

The observed update mask for the delete records was:

```text
__$update_mask = 0x01FF
```

The resulting CDC representation was:

```text
Explicit parent DELETE
        │
        ▼
SQL Server referential processing
        │
        ├── Parent row deleted
        │       ↓
        │   CDC operation 1
        │
        ├── Child 13770 deleted
        │       ↓
        │   CDC operation 1
        │
        └── Child 13771 deleted
                ↓
            CDC operation 1
```

CDC therefore exposed the resulting physical row changes across both capture instances.

### 20.6 Shared Transaction LSN

All three delete records shared:

```text
__$start_lsn =
0x0000002D00001D000017
```

The common transaction context was therefore preserved across:

```text
sales.Transaction
```

and:

```text
sales.TransactionItem
```

Conceptually:

```text
__$start_lsn
0x0000002D00001D000017
│
├── Parent DELETE
│
├── Child 13770 DELETE
│
└── Child 13771 DELETE
```

The three records also mapped to the same observed CDC transaction time:

```text
2026-08-29 09:22:53.427
```

This provided additional evidence that the captured parent and cascade-generated child deletions belonged to the same source transaction context.

### 20.7 Command Ordering

The captured delete records were distinguished through `__$command_id` and `__$seqval`.

The observed metadata was:

```text
Parent 6308
│
├── __$command_id = 1
├── __$seqval = ...0009
└── __$operation = 1

Child 13770
│
├── __$command_id = 2
├── __$seqval = ...0011
└── __$operation = 1

Child 13771
│
├── __$command_id = 3
├── __$seqval = ...0016
└── __$operation = 1
```

All three records shared the same transaction LSN while preserving distinct command and sequence metadata.

The observed structure was:

```text
One SQL Transaction
│
│  __$start_lsn =
│  0x0000002D00001D000017
│
├── Command 1
│   └── Parent DELETE
│
├── Command 2
│   └── Child 13770 DELETE
│
└── Command 3
    └── Child 13771 DELETE
```

The sequence values are recorded as evidence from this controlled transaction and must not be generalized into an undocumented arithmetic or increment rule.

### 20.8 Application Action vs Physical Changes

M01.19 established an important semantic distinction.

At the application or test-script level:

```text
Explicit DELETE statements:
1
```

At the physical source-change level:

```text
Rows deleted:
3
```

At the CDC level:

```text
DELETE records:
3
```

Therefore:

```text
1 logical application action
        │
        ▼
1 explicit parent DELETE
        │
        ▼
Referential cascade
        │
        ▼
3 physical row deletions
        │
        ▼
3 CDC DELETE records
```

The presence of three CDC delete events must not be interpreted as evidence that the application issued three explicit `DELETE` statements.

CDC exposes captured database changes, including changes produced by referential actions.

This distinction is important for future downstream consumers because:

```text
Number of CDC records
    ≠
Number of explicit application statements
```

The transaction context must be preserved when interpreting related changes.

### 20.9 Observed Result

After capture processing, the accumulated CDC state for the controlled laboratory records showed:

```text
sales.Transaction

transaction_change_rows_after:
4

transaction_deletes:
1
```

and:

```text
sales.TransactionItem

item_change_rows_after:
8

item_deletes:
2
```

For the M01.19 transaction itself, the relevant delete evidence was:

```text
Parent 6308
│
├── operation = 1
├── command_id = 1
├── seqval = ...0009
├── update_mask = 0x01FF
└── start_lsn =
    0x0000002D00001D000017

Child 13770
│
├── operation = 1
├── command_id = 2
├── seqval = ...0011
├── update_mask = 0x01FF
└── start_lsn =
    0x0000002D00001D000017

Child 13771
│
├── operation = 1
├── command_id = 3
├── seqval = ...0016
├── update_mask = 0x01FF
└── start_lsn =
    0x0000002D00001D000017
```

The source state after the transaction contained neither the parent nor its two child rows.

CDC captured evidence of all three physical deletions.

### 20.10 Conclusion

M01.19 successfully validated CDC behavior for a parent `DELETE` combined with `ON DELETE CASCADE`.

The controlled test issued only:

```text
1 explicit DELETE
```

against:

```text
sales.Transaction
TRN_id = 6308
```

SQL Server then removed:

```text
1 parent row
+
2 child rows
=
3 physical deletions
```

CDC captured all three physical changes as:

```text
__$operation = 1
```

with the shared transaction context:

```text
__$start_lsn =
0x0000002D00001D000017
```

and command identifiers:

```text
1 → Parent 6308
2 → Child 13770
3 → Child 13771
```

The experiment therefore established that referential cascade effects are visible through CDC and can be correlated across the parent and child capture instances.

Most importantly, it established the distinction:

```text
Application action
    ≠
Number of physical database changes
    ≠
Number of CDC records interpreted as application statements
```

A downstream consumer must preserve transaction context rather than infer application behavior solely from the number of individual CDC records.

M01.19 completes the controlled source-side CDC behavior cycle for the initial `AtlasCommerce.sales` transactional scope.

The implementation has now validated individual-table and cross-table `INSERT`, `UPDATE`, and `DELETE` behavior, including multiple commands within one transaction and referential cascade effects.

**M01.19 Status: PASS**

---

## 21. Consolidated CDC Transaction Model

The controlled experiments from M01.12 through M01.19 progressively established how SQL Server CDC metadata represents changes within the validated `AtlasCommerce.sales` transactional scope.

Individual tests examined specific behaviors such as inserts, updates, multiple commands, cross-table transactions, and cascade-generated deletes.

This section consolidates those observations into a single transaction model.

The model is based on behavior directly observed during the controlled laboratory cycle. It is not intended to redefine SQL Server CDC internals beyond the evidence established by those experiments.

### 21.1 Transaction LSN

Across the multi-command and cross-table experiments, changes originating from the same committed SQL transaction shared:

```text
__$start_lsn
```

This behavior was observed in:

```text
M01.14
Multiple UPDATE commands within one transaction

M01.17B
Cross-table INSERT transaction

M01.18
Coordinated cross-table UPDATE

M01.19
Parent DELETE with ON DELETE CASCADE
```

The resulting correlation model is:

```text
SQL Transaction
      │
      ▼
shared __$start_lsn
      │
      ├── captured change
      ├── captured change
      ├── captured change
      └── ...
```

For cross-table transactions, the same transaction LSN was observed in records stored through different capture instances.

For example:

```text
sales.Transaction CDC
        │
        └──────────┐
                   │
                   ▼
            shared __$start_lsn
                   ▲
                   │
        ┌──────────┘
        │
sales.TransactionItem CDC
```

Within the validated source-side model, `__$start_lsn` therefore provides the primary CDC metadata used to correlate captured changes with their common SQL transaction context.

This does not mean that `__$start_lsn` alone provides the complete ordering or processing model. Additional metadata is required to distinguish commands and row images within the transaction.

### 21.2 Command ID

The controlled experiments demonstrated that a single SQL transaction can contain multiple source commands.

Within a shared transaction LSN, the observed:

```text
__$command_id
```

distinguished those commands.

For example, M01.17B produced:

```text
Shared __$start_lsn
│
├── command_id = 1
│   └── Parent INSERT
│
├── command_id = 2
│   └── First Child INSERT
│
└── command_id = 3
    └── Second Child INSERT
```

M01.18 and M01.19 reproduced the same general relationship for coordinated updates and cascade-related deletes.

The resulting hierarchy is:

```text
Transaction
│
└── __$start_lsn
    │
    ├── Command
    │   └── __$command_id
    │
    ├── Command
    │   └── __$command_id
    │
    └── Command
        └── __$command_id
```

Therefore:

```text
__$start_lsn
    → transaction context

__$command_id
    → command distinction within that context
```

This distinction prevents a consumer from incorrectly treating all CDC rows sharing one transaction LSN as representations of the same source command.

### 21.3 Sequence Value

The experiments also observed:

```text
__$seqval
```

as part of the sequencing metadata for captured changes.

During M01.18, for example:

```text
Parent UPDATE
seqval = ...0002

Child 13770 UPDATE
seqval = ...0007

Child 13771 UPDATE
seqval = ...000B
```

During M01.19:

```text
Parent DELETE
seqval = ...0009

Child 13770 DELETE
seqval = ...0011

Child 13771 DELETE
seqval = ...0016
```

For each controlled update, the `UPDATE_BEFORE` and `UPDATE_AFTER` records belonging to the same update command shared the same sequence value.

Therefore, the observed model was:

```text
UPDATE command
│
├── UPDATE_BEFORE
│   └── same __$seqval
│
└── UPDATE_AFTER
    └── same __$seqval
```

Across distinct commands, different sequence values were observed.

The sequence values are used as sequencing information within the CDC transaction model, but the exact hexadecimal values observed during the laboratory must not be interpreted as defining an arithmetic increment rule.

Atlas Engineering records the observed ordering relationship without inventing undocumented semantics from the numeric differences between values.

### 21.4 Operation

The `__$operation` metadata identifies the row-image semantics represented by an individual CDC record.

The controlled laboratory cycle observed:

| `__$operation` | Meaning |
|---:|---|
| `1` | `DELETE` |
| `2` | `INSERT` |
| `3` | `UPDATE_BEFORE` |
| `4` | `UPDATE_AFTER` |

The basic model is:

```text
INSERT
    ↓
operation = 2
```

```text
DELETE
    ↓
operation = 1
```

and:

```text
UPDATE
   │
   ├── operation = 3
   │   UPDATE_BEFORE
   │
   └── operation = 4
       UPDATE_AFTER
```

The operation code therefore cannot be interpreted independently of the surrounding transaction and command metadata.

In particular:

```text
operation 3
+
operation 4
```

with matching transaction, command, sequence, and update-mask context represent the before-and-after images of the same controlled update.

They are not two independent application updates.

### 21.5 Update Mask

The `__$update_mask` provides metadata about the captured columns declared as affected by an update operation.

Different controlled update commands produced different masks.

Examples observed during the laboratory included:

```text
0x0108
0x0160
0x0168
0x0150
0x0120
```

The values varied according to the captured columns affected by each controlled command.

Therefore:

```text
Same transaction
    ≠
Same update mask
```

For an update pair, however, the before and after images shared the same observed mask:

```text
UPDATE
│
├── operation 3
│   └── update_mask = X
│
└── operation 4
    └── update_mask = X
```

For the controlled inserts and deletes in this implementation, the observed mask was:

```text
0x01FF
```

corresponding to the complete nine-column captured set.

The mask must be interpreted relative to the captured-column metadata of the corresponding capture instance.

It is CDC change metadata, not a business-domain identifier.

### 21.6 UPDATE Pair Model

The experiments established a consistent model for the controlled updates:

```text
One source UPDATE command
        │
        ▼
Two CDC row images
        │
        ├── UPDATE_BEFORE
        │   operation = 3
        │
        └── UPDATE_AFTER
            operation = 4
```

Within the observed pair:

```text
__$start_lsn
    → same

__$command_id
    → same

__$seqval
    → same

__$update_mask
    → same

__$operation
    → different
```

Therefore, the correlation model is:

```text
UPDATE_BEFORE
│
├── transaction X
├── command Y
├── sequence Z
├── mask M
└── operation 3

        ↕

UPDATE_AFTER
│
├── transaction X
├── command Y
├── sequence Z
├── mask M
└── operation 4
```

This provides the structural basis for interpreting the two CDC rows as one source update transition.

A future CDC consumer must account for this paired representation rather than treating every physical change-table row as an independent logical source event.

The actual consumer algorithm remains outside the implementation evidence established through M01.19.

### 21.7 Cross-Table Correlation

The most important extension of the transaction model came from M01.17B through M01.19.

The experiments demonstrated that transaction metadata can be used to correlate changes across:

```text
cdc.sales_Transaction_CT
```

and:

```text
cdc.sales_TransactionItem_CT
```

when those changes originated from the same SQL transaction.

The consolidated model is:

```text
SQL Transaction
│
└── __$start_lsn
    │
    ├── Command 1
    │   ├── __$command_id
    │   ├── __$seqval
    │   ├── __$operation
    │   └── __$update_mask
    │
    ├── Command 2
    │   ├── __$command_id
    │   ├── __$seqval
    │   ├── __$operation
    │   └── __$update_mask
    │
    └── Command N
        ├── __$command_id
        ├── __$seqval
        ├── __$operation
        └── __$update_mask
```

where the commands may belong to different CDC capture instances.

The laboratory therefore established the following source-side interpretation model:

```text
Transaction
    → __$start_lsn

Command within transaction
    → __$command_id

Captured change sequencing
    → __$seqval

Row-image semantics
    → __$operation

Affected captured columns
    → __$update_mask
```

This model explains why CDC records must be interpreted in context.

For example:

```text
1 application action
```

can result in:

```text
multiple physical database changes
```

which can result in:

```text
multiple CDC records
```

across:

```text
multiple capture instances
```

while still belonging to:

```text
one source SQL transaction
```

The model is deliberately limited to SQL Server CDC behavior validated in the laboratory.

It does not establish that a future Debezium, Kafka, or Bronze implementation will automatically preserve these records as an indivisible transactional package.

That downstream behavior requires separate implementation and evidence.

The consolidated CDC transaction model therefore becomes the source-side foundation for the next engineering problem: designing a consumer that can process CDC incrementally without discarding the transaction context demonstrated by M01.12 through M01.19.

---

## 22. Asynchronous Capture Model

The controlled experiments demonstrated that SQL Server CDC capture is asynchronous relative to the source transaction commit.

A successful `COMMIT` establishes the committed source state, but it does not imply that the corresponding CDC records are already available for consumption at that exact moment.

This distinction was directly observed during the laboratory cycle and is fundamental to the design of the future CDC consumer.

### 22.1 Commit vs CDC Availability

The first direct evidence of asynchronous capture was produced during M01.12.

After the controlled `INSERT` of:

```text
TRN_id = 6307
```

the source transaction had successfully committed and the row was available in `sales.Transaction`.

An immediate CDC inspection, however, returned:

```text
matching_change_rows = 0
```

After approximately six seconds, the same inspection returned:

```text
matching_change_rows = 1
```

The observed sequence was therefore:

```text
Source DML
    ↓
COMMIT
    ↓
Source state available
    ↓
CDC record not necessarily available
    ↓
Capture processing
    ↓
CDC record available
```

The same general behavior was reproduced during the cross-table `INSERT` experiment in M01.17B.

Immediately after the transaction committed:

```text
sales.Transaction CDC matches:
0

sales.TransactionItem CDC matches:
0
```

After capture processing:

```text
sales.Transaction CDC matches:
1

sales.TransactionItem CDC matches:
2
```

The repeated observation established:

```text
COMMIT
    ≠
Immediate CDC availability
```

This does not mean that the source transaction is incomplete while CDC capture is pending.

The source transaction has already committed.

The delay exists between the committed source state and its subsequent availability through the CDC capture structures.

### 22.2 Capture Job Polling

The capture-job configuration inspected during the implementation included:

```text
continuous:
1

pollinginterval:
5 seconds

maxtrans:
10000

maxscans:
10
```

The observed configuration is consistent with a continuously operating capture process that periodically checks for additional work.

Conceptually:

```text
Transaction Log
      │
      │ committed changes
      ▼
CDC Capture Process
      │
      ├── scan
      ├── process eligible changes
      ├── additional scan cycles
      └── polling interval
              │
              ▼
CDC Change Tables
```

The configured:

```text
pollinginterval = 5
```

must not be interpreted as:

```text
CDC latency = exactly 5 seconds
```

or:

```text
CDC latency ≤ 5 seconds
```

The polling interval is an operational parameter of the capture process.

Actual availability depends on runtime conditions and capture processing.

Therefore:

```text
Polling configuration
    ≠
Latency guarantee
```

### 22.3 Laboratory Observation

The controlled laboratory scripts frequently allowed approximately six seconds before performing the post-capture inspection.

This timing was useful for the controlled experiments because the observed capture configuration used a five-second polling interval.

The resulting laboratory pattern was:

```text
COMMIT
    ↓
Immediate inspection
    ↓
CDC event may not yet exist
    ↓
WAIT approximately 6 seconds
    ↓
Second inspection
    ↓
CDC event observed
```

This pattern provided a practical mechanism for demonstrating the asynchronous boundary.

It must not be converted into a production implementation rule such as:

```text
Always wait six seconds before reading CDC.
```

Such a rule would confuse a laboratory observation technique with a production consumption strategy.

The experiments demonstrated that CDC records can become available after the source commit rather than simultaneously with it.

They do not prove that six seconds is universally sufficient, necessary, optimal, or guaranteed.

### 22.4 Production Evidence Boundary

The Atlas Engineering architecture distinguishes between the observed CDC laboratory behavior and the future production data-freshness objective.

The architectural target currently includes:

```text
Typical freshness:
approximately 3–5 minutes

Formal P95 target:
≤ 15 minutes
```

These values are platform objectives.

They were not measured as production end-to-end latency during M01.08 through M01.19.

The laboratory evidence establishes only the source-side asynchronous behavior:

```text
Source COMMIT
      │
      ▼
CDC capture occurs asynchronously
      │
      ▼
CDC record becomes available
```

The complete production path will contain additional stages:

```text
Source COMMIT
      ↓
SQL Server CDC
      ↓
CDC Consumption
      ↓
Transport / Integration
      ↓
Bronze Persistence
      ↓
Platform Availability
```

The latency of this complete path has not yet been implemented or measured.

Therefore:

```text
Observed CDC capture delay
    ≠
End-to-end platform latency

Configured polling interval
    ≠
Production freshness SLO

Laboratory WAITFOR duration
    ≠
Consumer polling contract
```

The future consumer must be designed around the fact that CDC availability is asynchronous rather than around a fixed assumption about how many seconds capture will require.

M01.12 and M01.17B provide direct laboratory evidence for this asynchronous model.

Production latency, backlog behavior, catch-up performance, and end-to-end freshness remain outside the evidence established through M01.19 and require validation in subsequent implementation stages.

---

## 23. Time Semantics

The CDC implementation exposed multiple notions of time that represent different stages of a change's lifecycle.

These timestamps must not be treated as interchangeable.

A business transaction can carry its own event timestamp, SQL Server CDC can associate the committed change with transaction time derived from its LSN, and the future data platform will introduce an additional ingestion timestamp when the event is persisted downstream.

The resulting model contains at least three distinct time domains:

```text
Business Event Time
        ↓
CDC Transaction Time
        ↓
Platform Ingestion Time
```

Each time domain answers a different question.

### 23.1 Business Event Time

Business event time is represented by timestamps stored in the source business data.

For `sales.Transaction`, the controlled experiments included:

```text
TRN_transaction_at
```

This value belongs to the source-domain model.

Conceptually, it answers:

```text
When does the source business record say
the transaction occurred?
```

It is part of the captured source payload and must not be confused with the time at which CDC processed the corresponding change.

For example:

```text
sales.Transaction
│
├── TRN_id
├── TRN_transaction_at
├── TRN_status
├── TRN_gross_amount
└── ...
```

When CDC captures the row, `TRN_transaction_at` remains a source column.

Its semantics originate from the transactional application and database model rather than from CDC itself.

Therefore:

```text
TRN_transaction_at
    =
Business-domain timestamp
```

It does not establish when SQL Server committed the CDC-visible transaction.

### 23.2 CDC Transaction Time

SQL Server CDC provides a separate mechanism for associating an LSN with transaction time.

During the controlled experiments, the transaction LSN could be mapped using:

```sql
sys.fn_cdc_map_lsn_to_time(...)
```

Conceptually:

```text
__$start_lsn
      │
      ▼
sys.fn_cdc_map_lsn_to_time(...)
      │
      ▼
CDC transaction time
```

This timestamp belongs to the CDC transaction context rather than to the business payload.

For example, M01.19 observed the parent and cascade-generated child delete records with the same:

```text
__$start_lsn =
0x0000002D00001D000017
```

and the same mapped CDC transaction time:

```text
2026-08-29 09:22:53.427
```

The relationship was:

```text
Parent DELETE
│
├── start_lsn = X
└── CDC transaction time = T

Child DELETE
│
├── start_lsn = X
└── CDC transaction time = T

Child DELETE
│
├── start_lsn = X
└── CDC transaction time = T
```

This reinforced the shared transaction context already established through the CDC metadata.

The CDC transaction time answers a different question from the source business timestamp:

```text
Business Event Time
    → time represented by the source business data

CDC Transaction Time
    → transaction time associated with the CDC LSN
```

Therefore:

```text
TRN_transaction_at
    ≠
sys.fn_cdc_map_lsn_to_time(__$start_lsn)
```

They may sometimes be close in value, but semantic equivalence must not be inferred from temporal proximity.

A future consumer must preserve this distinction if both values are carried into the platform.

### 23.3 Future Platform Ingestion Time

The future data platform will introduce another timestamp when CDC data is consumed and persisted downstream.

Conceptually:

```text
ingestion_time
```

would answer:

```text
When did the Atlas Engineering platform
receive or persist this change?
```

This timestamp does not yet belong to the SQL Server source or CDC capture tables.

It will be introduced by a later implementation stage.

The complete conceptual timeline is therefore:

```text
Business Event
      │
      │ TRN_transaction_at
      ▼
Source Transaction
      │
      │ COMMIT
      ▼
CDC Transaction Context
      │
      │ __$start_lsn
      │ mapped transaction time
      ▼
Asynchronous CDC Availability
      │
      ▼
Future CDC Consumer
      │
      ▼
Platform Persistence
      │
      │ ingestion_time
      ▼
Bronze
```

The three time domains answer different questions:

| Time Domain | Example | Meaning |
|---|---|---|
| Business Event Time | `TRN_transaction_at` | Time represented by the source business event |
| CDC Transaction Time | `sys.fn_cdc_map_lsn_to_time(__$start_lsn)` | Transaction time associated with the CDC LSN |
| Platform Ingestion Time | Future `ingestion_time` | Time the platform receives or persists the change |

The first two were available for inspection during the source-side CDC laboratory.

The third has not yet been implemented.

Therefore, no observed ingestion timestamp or end-to-end latency can be claimed from M01.08 through M01.19.

This distinction will become especially important when future platform components calculate:

```text
source-to-capture delay

capture-to-ingestion delay

end-to-end freshness
```

Those measurements require timestamps from different lifecycle boundaries.

The CDC implementation establishes the source-side semantics required for that future measurement, but it does not yet provide production evidence for the complete timing chain.

---

## 24. Implementation Errors and Corrections

The CDC implementation cycle included several situations in which unexpected results occurred during execution or validation.

These situations are part of the engineering evidence.

They are documented because a reliable implementation record must distinguish between:

```text
Platform failure
```

and:

```text
Script error
Operational state
Transient platform state
Incorrect interpretation
```

None of the incidents documented in this section invalidated the CDC behaviors proven through M01.19.

Instead, each incident produced an additional operational or implementation lesson that must be carried into future scripts and automation.

### 24.1 Cleanup Job Stop Request

During M01.10B, the CDC cleanup retention was changed from the original:

```text
4,320 minutes
```

to the V1 operational value:

```text
21,600 minutes
```

which corresponds to:

```text
15 days
```

As part of the operational procedure, the script attempted to stop the CDC cleanup job.

SQL Server Agent returned:

```text
Msg 22022
```

with the relevant condition indicating that the request to stop:

```text
cdc.AtlasCommerce_cleanup
```

was refused because the job was not currently running.

The important distinction was:

```text
STOP requested
        │
        ▼
Job already not running
        │
        ▼
Stop request refused
```

rather than:

```text
CDC cleanup job failed
```

The cleanup job is periodic and is not expected to remain continuously active.

Therefore, requesting a stop while the job is already idle is an operational-state condition rather than evidence of CDC malfunction.

The retention configuration was subsequently confirmed as:

```text
retention = 21600
threshold = 4999
```

and the cleanup job was later started successfully.

The incident did not invalidate the retention change.

The resulting scripting requirement is:

```text
Before requesting STOP
        │
        ▼
Inspect current SQL Server Agent job state
        │
        ├── Running
        │      ↓
        │    STOP
        │
        └── Not running
               ↓
             Do not issue unnecessary STOP
```

Future operational scripts should therefore verify job state before attempting to stop a CDC job.

### 24.2 `sp_cdc_help_change_data_capture` Parameter Error

During M01.17A, the validation script attempted:

```sql
EXEC sys.sp_cdc_help_change_data_capture
    @source_schema = N'sales';
```

SQL Server returned:

```text
Msg 22972
```

The initial call was invalid because `sys.sp_cdc_help_change_data_capture` does not support the intended inspection when only the source schema is supplied.

For a specific table, the required source-identification parameters must be supplied together.

For the required environment-wide inspection, the corrected execution was:

```sql
EXEC sys.sp_cdc_help_change_data_capture;
```

The failure classification was therefore:

```text
Validation script:
ERROR

CDC configuration:
NOT FAILED
```

No capture instance needed to be:

```text
disabled
recreated
repaired
```

The correction was limited to the inspection script.

This incident reinforces a general implementation principle:

```text
An error returned while inspecting a subsystem
does not automatically prove that the subsystem
being inspected is in error.
```

The failing command, its parameters, and the actual platform state must be separated during diagnosis.

### 24.3 Transient Minimum LSN Observation

A different class of unexpected state occurred during M01.16B after CDC was enabled on:

```text
sales.TransactionItem
```

The capture instance had already been created with:

```text
start_lsn =
0x0000002D00001044008A
```

but an immediate call to determine the minimum available LSN temporarily returned:

```text
NULL
```

At that moment, the observed state was:

```text
Capture instance:
Created

Start LSN:
Available

Minimum queryable LSN:
NULL
```

A later inspection returned:

```text
minimum_lsn =
0x0000002D00001044008A
```

matching the capture-instance start LSN.

The transition was therefore:

```text
Enable capture instance
        │
        ▼
start_lsn established
        │
        ▼
Immediate minimum-LSN inspection
        │
        ▼
NULL
        │
        ▼
Capture processing advances
        │
        ▼
minimum_lsn available
```

The initial `NULL` was not classified as:

```text
CDC enablement failure
```

because subsequent validation demonstrated that the capture instance became queryable from its expected lower boundary without requiring reconfiguration.

This behavior has direct implications for future automation.

A script that enables CDC and immediately requests the minimum LSN must account for the possibility that the queryable boundary is not yet available at that exact observation point.

Therefore:

```text
Immediate NULL min LSN
    ≠
Automatic proof of CDC failure
```

The correct response is to inspect the surrounding CDC state and allow for asynchronous initialization before declaring failure.

### 24.4 Engineering Lessons

The incidents observed during the implementation cycle fall into three distinct categories:

| Incident | Classification | CDC Failure |
|---|---|---|
| Cleanup job stop refused | Operational-state condition | No |
| `sp_cdc_help_change_data_capture` error | Validation-script error | No |
| Temporary `NULL` minimum LSN | Transient CDC state | No |

These incidents established several implementation rules for future Atlas Engineering automation.

First, scripts must validate operational state before issuing state-dependent commands.

```text
Inspect
    ↓
Determine current state
    ↓
Execute appropriate action
    ↓
Validate resulting state
```

Second, an error produced by a validation command must be diagnosed at the script and parameter level before being attributed to the underlying platform.

```text
Command fails
    ↓
Validate command syntax and parameters
    ↓
Inspect actual subsystem state
    ↓
Classify failure
```

Third, asynchronous components must not be validated under the assumption of immediate state convergence.

```text
Configuration accepted
    ≠
Every dependent runtime value immediately available
```

Fourth, remediation should target the layer that actually failed.

The observed incidents required:

```text
Cleanup stop condition
    → improve operational-state handling

Procedure parameter error
    → correct validation script

Transient minimum LSN
    → account for asynchronous state
```

They did not require:

```text
CDC disable/enable cycle
Database rebuild
Capture-instance recreation
Source-data modification
```

Finally, implementation evidence must retain failures and corrections rather than omit them from the final documentation.

A successful engineering cycle is not represented by pretending that every command succeeded on the first attempt.

The relevant record is:

```text
What happened
    ↓
Why it happened
    ↓
How it was classified
    ↓
What was corrected
    ↓
What was revalidated
    ↓
What conclusion the evidence supports
```

This approach prevents script defects, operational conditions, and transient states from being incorrectly promoted into architectural conclusions about SQL Server CDC.

It also provides concrete requirements for the future hardening of the M01 CDC scripts before they are treated as reusable operational artifacts.

---

## 25. Evidence Summary

The M01.08 through M01.19 laboratory cycle established the source-side SQL Server CDC foundation for the initial `AtlasCommerce.sales` transactional scope.

The experiments progressed from environment validation and CDC enablement to controlled single-table and cross-table data changes.

This section consolidates what the implementation evidence supports, what remains unproven, and where the boundary between laboratory observations and future production claims must be maintained.

### 25.1 Behaviors Proven

The implementation cycle produced direct evidence for the following SQL Server CDC behaviors within the controlled Atlas Engineering laboratory environment.

#### Database-Level CDC Enablement

M01.09 demonstrated that CDC could be enabled successfully for `AtlasCommerce`.

The implementation established:

```text
Database CDC state:
Disabled
    ↓
sys.sp_cdc_enable_db
    ↓
Enabled
```

The database-level operation created the CDC schema and supporting metadata infrastructure without automatically placing source tables under capture.

Therefore, database-level CDC enablement and table-level capture configuration were confirmed as separate implementation stages.

#### Table-Level Capture Instances

CDC was successfully enabled for:

```text
sales.Transaction
sales.TransactionItem
```

with the capture instances:

```text
sales_Transaction
sales_TransactionItem
```

Both capture instances were configured with:

```text
supports_net_changes = 0
```

and exposed their corresponding all-changes query functions.

The implementation therefore established two independently configured CDC capture structures for the initial transactional scope.

#### No Automatic Historical Backfill

Both tables contained existing source data before CDC was enabled.

The observed baselines included:

```text
sales.Transaction:
6,306 rows

sales.TransactionItem:
13,769 rows
```

After their respective capture instances were created, the initial change tables contained:

```text
0 captured rows
```

Therefore, the implementation directly demonstrated:

```text
Existing source rows
    ≠
Automatically generated CDC history
```

The laboratory demonstrated CDC capture for eligible source changes occurring after the configured capture boundary.

Existing source state requires a separate initial backfill strategy.

#### Asynchronous Capture

Controlled transactions demonstrated that committed source changes can exist before the corresponding CDC records become available.

The observed pattern was:

```text
COMMIT
    ↓
Source state available
    ↓
Immediate CDC inspection may return no record
    ↓
Capture processing
    ↓
CDC record available
```

This behavior was directly observed during both single-table and cross-table experiments.

#### INSERT Representation

Controlled inserts were represented with:

```text
__$operation = 2
```

The experiments validated inserts for:

```text
sales.Transaction
sales.TransactionItem
```

including inserts affecting both tables within one SQL transaction.

#### UPDATE Before-and-After Representation

Controlled updates generated:

```text
__$operation = 3
UPDATE_BEFORE

__$operation = 4
UPDATE_AFTER
```

The corresponding before-and-after images shared the observed:

```text
__$start_lsn
__$command_id
__$seqval
__$update_mask
```

while differing by:

```text
__$operation
```

This behavior was validated for both individual and coordinated cross-table updates.

#### DELETE Representation

Controlled hard deletes were represented with:

```text
__$operation = 1
```

The implementation validated both:

```text
Explicit source DELETE
```

and:

```text
DELETE caused by ON DELETE CASCADE
```

as captured physical changes.

#### Multiple Commands Within One Transaction

M01.14 demonstrated that multiple update commands executed within a single SQL transaction shared a common transaction context while remaining distinguishable through command metadata.

The model was subsequently reproduced during the cross-table experiments.

#### Cross-Table Transaction Correlation

M01.17B, M01.18, and M01.19 demonstrated that changes captured through separate capture instances can share:

```text
__$start_lsn
```

when they originate from the same SQL transaction.

The experiments covered:

```text
Cross-table INSERT

Cross-table UPDATE

Parent DELETE with child cascade
```

This established source-side transaction correlation across the two transactional capture instances.

#### Command Identification and Sequencing

Within the controlled multi-command transactions:

```text
__$command_id
```

distinguished the observed source commands.

Different commands also produced distinct observed:

```text
__$seqval
```

values, while each controlled `UPDATE_BEFORE` / `UPDATE_AFTER` pair shared its sequence value.

The implementation therefore established the practical transaction model:

```text
__$start_lsn
    → transaction context

__$command_id
    → command distinction

__$seqval
    → observed change sequencing metadata

__$operation
    → row-image semantics

__$update_mask
    → affected captured-column metadata
```

#### Update Masks

Controlled updates produced masks corresponding to their affected captured columns.

Observed examples included:

```text
0x0108
0x0160
0x0168
0x0150
0x0120
```

Controlled inserts and deletes in the tested capture instances produced:

```text
0x01FF
```

The implementation therefore validated practical inspection of CDC update-mask metadata for the configured nine-column capture sets.

#### Referential Cascade Capture

M01.19 demonstrated that one explicit parent `DELETE` could produce:

```text
1 parent DELETE
+
2 child DELETEs
```

through `ON DELETE CASCADE`.

CDC captured all three physical changes while preserving their common transaction context.

This established:

```text
Number of CDC records
    ≠
Number of explicit application statements
```

#### Configurable Cleanup Retention

The cleanup retention was successfully changed from:

```text
4,320 minutes
```

to:

```text
21,600 minutes
```

or:

```text
15 days
```

The implementation confirmed that CDC retention can be configured independently from the future platform freshness objective.

The 15-day value is an operational recovery buffer for the V1 design, not a permanent historical-storage strategy.

#### Partition Switching Restriction Identified

Both transactional tables were evaluated in the context of their partitioned source design.

The CDC implementation surfaced the partition-switching restriction associated with the configured CDC behavior.

Repository verification found no existing normal ingestion path based on:

```text
ALTER TABLE ... SWITCH
```

The resulting V1 decision was to govern partition switching explicitly rather than treat the restriction as an implementation failure.

This is an identified operational boundary, not evidence that arbitrary partition-switch operations have been validated with CDC.

### 25.2 Behaviors Not Yet Proven

The completion of the source-side CDC cycle does not mean that the complete change-data pipeline has been implemented.

The following behaviors remain outside the evidence established through M01.19.

#### Incremental CDC Consumption

A definitive consumer has not yet been implemented.

The project has not yet proven:

```text
How the next LSN window is selected

How each capture instance is queried incrementally

When a window is considered successfully processed

How the next checkpoint is calculated
```

These questions belong to the next implementation stage.

#### Checkpoint Strategy

No final persistent checkpoint mechanism has yet been validated.

The project has not proven:

```text
Checkpoint storage

Checkpoint commit semantics

Cross-table checkpoint coordination

Restart behavior from a stored checkpoint
```

A correct checkpoint design must be implemented and tested rather than inferred from the source-side CDC experiments.

#### Replay and Restart Behavior

Although the 15-day CDC retention provides an operational recovery window, the implementation has not yet demonstrated a consumer restart or replay cycle.

The following remain unproven:

```text
Consumer restart

Replay from a previous checkpoint

Duplicate handling during replay

Recovery after partial downstream failure
```

#### Debezium Behavior

No Debezium implementation was part of M01.08 through M01.19.

Therefore, the project has not yet demonstrated:

```text
Debezium transaction representation

Debezium ordering behavior

Connector restart behavior

Connector offset handling

How SQL Server CDC metadata is propagated downstream
```

SQL Server CDC transaction correlation must not be presented as evidence of Debezium behavior.

#### Kafka Delivery Semantics

Kafka was not part of the validated source-side cycle.

The project has therefore not yet proven:

```text
Kafka partitioning

Cross-table ordering in Kafka

Delivery behavior

Consumer-group behavior

Offset recovery

Transactional packaging
```

In particular:

```text
Shared SQL Server __$start_lsn
    ≠
Proven indivisible Kafka delivery
```

#### Bronze Persistence

The Bronze layer has not yet been implemented as part of this CDC cycle.

The project has not proven:

```text
Bronze CDC schema

Raw CDC persistence

Metadata preservation

Partitioning of CDC data

Historical durability beyond source CDC retention
```

The architectural role of Bronze may already be defined, but its runtime behavior is not evidence from M01.08 through M01.19.

#### End-to-End Idempotency

The controlled source experiments do not establish end-to-end idempotent processing.

The implementation has not yet demonstrated:

```text
Replay-safe writes

Duplicate-event handling

Checkpoint/write atomicity

Idempotent downstream persistence
```

#### Failure Recovery

Operational errors encountered while configuring and inspecting CDC were diagnosed successfully, but they are not equivalent to testing a complete pipeline failure-recovery model.

The project has not yet validated scenarios such as:

```text
Consumer outage

Extended capture backlog

Downstream storage outage

Partial batch failure

Checkpoint failure

Replay after downstream recovery
```

#### Backlog and Catch-Up Behavior

The laboratory did not generate production-scale CDC backlog.

Therefore, no evidence currently establishes:

```text
Catch-up throughput

Backlog drain rate

Behavior near retention boundaries

Maximum sustainable source-change rate
```

#### Scale and Performance

The controlled tests were designed to validate semantics rather than production-scale performance.

They do not establish:

```text
Production throughput

CPU overhead

I/O overhead

Transaction-log impact under sustained workload

Large CDC-window query performance

Consumer scalability
```

#### End-to-End Freshness SLO

The architecture currently defines freshness objectives, including:

```text
Typical:
approximately 3–5 minutes

Formal P95 target:
≤ 15 minutes
```

These are targets.

M01.08 through M01.19 did not implement or measure the complete end-to-end path required to validate them.

Therefore:

```text
Freshness target
    ≠
Observed production SLO
```

### 25.3 Laboratory vs Production Claims

The evidence generated through M01.19 comes from a controlled laboratory implementation.

The correct interpretation is:

```text
Observed in laboratory
        ↓
Valid implementation evidence
        ↓
Supports the next engineering decision
```

It must not automatically become:

```text
Observed in laboratory
        ↓
Assumed production behavior
```

For example:

```text
Approximately 6 seconds used during laboratory validation
```

does not establish:

```text
6-second production CDC latency
```

Similarly:

```text
Shared __$start_lsn across capture instances
```

does not establish:

```text
Atomic downstream delivery across all future components
```

And:

```text
15-day CDC retention configured successfully
```

does not establish:

```text
15 days of guaranteed recoverability for the complete platform
```

Complete recoverability also depends on future consumer behavior, checkpointing, downstream persistence, operational procedures, and retention management.

The evidence boundary can therefore be summarized as:

```text
PROVEN
│
├── SQL Server CDC source configuration
├── Capture-instance behavior
├── INSERT representation
├── UPDATE before/after representation
├── DELETE representation
├── Cross-table transaction correlation
├── Cascade-generated physical changes
├── Asynchronous capture behavior
├── CDC metadata semantics observed in tests
├── Configurable cleanup retention
└── Initial backfill requirement

NOT YET PROVEN
│
├── Definitive CDC consumption
├── Persistent checkpoint strategy
├── Consumer restart and replay
├── Debezium behavior
├── Kafka behavior
├── Bronze persistence
├── End-to-end idempotency
├── Failure recovery
├── Backlog and catch-up performance
├── Production-scale performance
└── End-to-end freshness SLO
```

The source-side CDC foundation is therefore sufficiently evidenced to proceed to the next implementation problem without overstating what the project has already demonstrated.

The next stage must convert the validated CDC source semantics into a controlled incremental-consumption model and generate new evidence for the behaviors that remain unproven.

---

## 26. Implementation Status

The SQL Server CDC source implementation for the initial `AtlasCommerce.sales` transactional scope completed its controlled validation cycle through M01.19.

The implementation progressed through:

```text
M01.08
Pre-CDC Baseline
        ↓
M01.09
Database-Level CDC Enablement
        ↓
M01.10
Enable CDC on sales.Transaction
        ↓
M01.10B
CDC Retention Configuration
        ↓
M01.11
Change Table Anatomy
        ↓
M01.12
Controlled INSERT
        ↓
M01.13
Controlled UPDATE
        ↓
M01.14
Multiple UPDATE Commands
in One Transaction
        ↓
M01.15
Controlled DELETE
        ↓
M01.16
Enable CDC on sales.TransactionItem
        ↓
M01.17A
Cross-Table CDC Preparation
        ↓
M01.17B
Cross-Table INSERT
        ↓
M01.18
Coordinated Cross-Table UPDATE
        ↓
M01.19
Parent DELETE with
ON DELETE CASCADE
```

The final status of the validated source-side cycle is:

```text
SQL Server CDC database enablement:
COMPLETE

sales.Transaction capture instance:
COMPLETE

sales.TransactionItem capture instance:
COMPLETE

CDC operational configuration:
COMPLETE FOR CURRENT V1 SOURCE SCOPE

Single-table change validation:
COMPLETE

Cross-table transaction validation:
COMPLETE

Referential cascade validation:
COMPLETE

Source-side CDC metadata investigation:
COMPLETE

CDC transaction-model consolidation:
COMPLETE
```

The implementation has established sufficient source-side evidence to move beyond the question:

```text
Can SQL Server CDC represent the
required transactional source changes?
```

For the tested scope, the answer is supported by the controlled laboratory evidence.

The project has demonstrated:

```text
INSERT
UPDATE
DELETE
UPDATE_BEFORE / UPDATE_AFTER
Multiple commands per transaction
Cross-table transaction correlation
Referential cascade capture
Asynchronous CDC availability
Transaction LSN correlation
Command identification
Sequence metadata
Update masks
Configurable retention
No automatic historical backfill
```

The current implementation boundary is:

```text
                    COMPLETED
                        │
                        ▼
┌─────────────────────────────────────────┐
│ SQL Server Source                      │
│                                        │
│ AtlasCommerce                          │
│                                        │
│ sales.Transaction                      │
│ sales.TransactionItem                  │
│                                        │
│ SQL Server CDC                         │
│                                        │
│ Source-side CDC behavior validated     │
└─────────────────────────────────────────┘
                        │
                        │
                        ▼
               NEXT IMPLEMENTATION
                        │
                        ▼
┌─────────────────────────────────────────┐
│ CDC Consumption                        │
│                                        │
│ LSN windows                            │
│ Incremental reads                      │
│ Checkpoint semantics                   │
│ Restart / replay behavior              │
│ Cross-table consumption considerations │
└─────────────────────────────────────────┘
```

This boundary is intentional.

The source-side CDC implementation should not be extended conceptually into downstream components before those components are implemented and tested.

Therefore, the following remain future implementation work:

```text
Definitive CDC consumer
Persistent checkpoint
Restart and replay
Downstream idempotency
Debezium integration
Kafka integration
Bronze persistence
Failure recovery
Backlog and catch-up validation
Production-scale performance
End-to-end freshness measurement
```

The status of this document is also distinct from the status of the implementation evidence.

The implementation cycle through M01.19 is complete and validated.

The documentation cycle must still complete its remaining editorial, structural, translation, and validation gates before the document itself can be considered fully approved and published.

Therefore:

```text
M01.08–M01.19 implementation:
COMPLETE

Source-side CDC validation:
PASS

English implementation document:
APPROVED

PT-BR implementation document:
PENDING FINAL DOCUMENTATION WORKFLOW

CDC Consumption:
NOT STARTED
```

No M01.20 implementation result is included in the current evidence set.

This preserves the implementation checkpoint:

```text
M01.19
    ↓
Source-side CDC cycle complete
    ↓
Documentation complete and validated
    ↓
M01.20
CDC Consumption
```

The project can proceed to M01.20 only after the current CDC documentation cycle is completed according to the Atlas Engineering documentation gates.

---
## 27. Next Step — CDC Consumption

The completion of M01.19 closed the controlled source-side CDC behavior cycle for the initial `AtlasCommerce.sales` transactional scope.

The next engineering problem is no longer whether SQL Server CDC can capture the required source changes.

That behavior has been validated.

The next problem is:

```text
How should Atlas Engineering consume those
changes incrementally, safely, and repeatably?
```

This marks the transition from:

```text
CDC Production
```

to:

```text
CDC Consumption
```

The implementation boundary is:

```text
AtlasCommerce
      │
      ▼
Transaction Log
      │
      ▼
SQL Server CDC
      │
      │
      │  validated through M01.19
      ▼
CDC Change Tables
      │
      │
      │  next engineering boundary
      ▼
Incremental CDC Consumer
```

The first step of this next cycle is M01.20.

### 27.1 M01.20 — CDC Consumption

M01.20 will begin the investigation of how a consumer can retrieve changes from the CDC capture instances without relying on assumptions that were not tested during the source-side cycle.

The initial capture instances are:

```text
sales_Transaction
sales_TransactionItem
```

Their all-changes functions are:

```text
cdc.fn_cdc_get_all_changes_sales_Transaction

cdc.fn_cdc_get_all_changes_sales_TransactionItem
```

The consumption investigation must preserve the transaction semantics established through M01.19 while introducing a reliable incremental-read boundary.

Conceptually:

```text
Previous processing position
        │
        ▼
Determine CDC LSN window
        │
        ▼
Read eligible changes
        │
        ▼
Interpret CDC metadata
        │
        ▼
Process successfully
        │
        ▼
Advance processing position
```

Each stage requires separate implementation evidence.

### 27.2 M01.20A — LSN Window Inspection

The first experiment will be:

```text
M01.20A — LSN Window Inspection
```

Its purpose is to inspect the CDC query boundaries before designing the definitive consumer.

The investigation will use:

```sql
sys.fn_cdc_get_min_lsn(...)
```

and:

```sql
sys.fn_cdc_get_max_lsn()
```

together with the all-changes functions for both capture instances.

The basic inspection model is:

```text
Capture Instance
      │
      ├── Minimum available LSN
      │
      └── Maximum available LSN
                │
                ▼
          Queryable Window
```

The experiment must determine what can actually be queried from the current CDC state before introducing persistent checkpoint semantics.

### 27.3 All-Changes Query Functions

The first consumption tests will use:

```sql
cdc.fn_cdc_get_all_changes_sales_Transaction
```

and:

```sql
cdc.fn_cdc_get_all_changes_sales_TransactionItem
```

The objective is to inspect how the validated change-table records are exposed through the supported CDC query interface.

This is intentionally different from treating the physical change tables as the final consumer contract.

The investigation will begin with the CDC functions provided for the configured capture instances.

Conceptually:

```text
CDC Change Table
        │
        ▼
CDC All-Changes Function
        │
        ▼
Defined LSN Window
        │
        ▼
Consumer Result Set
```

The behavior must be observed before a permanent consumption pattern is selected.

### 27.4 Row Filter Options

The initial investigation will compare:

```text
'all'
```

with:

```text
'all update old'
```

when querying the all-changes functions.

This comparison is important because the source-side experiments established that updates have meaningful before-and-after semantics.

The consumer investigation must determine how those semantics are exposed by the supported query function under each option.

Conceptually:

```text
CDC Query
│
├── 'all'
│
│   └── behavior to be inspected
│
└── 'all update old'
    └── behavior to be inspected
```

No result is assumed in advance.

The actual returned records will become the evidence for the consumption model.

### 27.5 Checkpoint Questions

M01.20A will inspect LSN windows, but it will not automatically establish the final checkpoint architecture.

The next implementation cycle must answer questions such as:

```text
What LSN represents completed processing?

When can that position safely advance?

Is the checkpoint shared across capture instances
or maintained independently?

What happens if processing succeeds for one
capture instance and fails for another?

How is restart performed?

How is replay requested?

How are duplicates handled after replay?

What happens if the stored checkpoint falls
outside CDC retention?
```

These questions cannot be answered solely from the M01.08–M01.19 evidence.

They require controlled consumer experiments.

### 27.6 Transaction Context Must Be Preserved

The source-side experiments demonstrated that changes from one SQL transaction can appear across multiple capture instances while sharing:

```text
__$start_lsn
```

The future consumption design must therefore avoid discarding transaction context prematurely.

For example:

```text
sales.Transaction
        │
        │ start_lsn = X
        ▼
Parent Change

sales.TransactionItem
        │
        │ start_lsn = X
        ▼
Child Change
```

The consumer must recognize that:

```text
Separate capture instances
    ≠
Necessarily unrelated source transactions
```

At the same time, the current evidence does not establish that every future processing stage must provide indivisible cross-table atomic delivery.

That architectural behavior must be designed and validated separately.

### 27.7 Retention Boundary

The configured CDC cleanup retention is:

```text
21,600 minutes
=
15 days
```

This introduces an operational boundary for future consumption.

Conceptually:

```text
Current CDC range
│
├── minimum available LSN
│
│
├── valid retained changes
│
│
└── current maximum LSN
```

A future checkpoint that falls behind the retained CDC boundary creates a recovery condition that cannot be resolved merely by requesting changes that SQL Server CDC has already removed.

Therefore, the consumer design must eventually account for:

```text
Checkpoint
    +
CDC minimum available LSN
    +
Retention window
    +
Recovery strategy
```

The 15-day retention provides an operational buffer.

It does not replace durable downstream persistence or a tested recovery strategy.

### 27.8 Evidence Required Before Completion

The CDC consumption stage must produce sufficient evidence before it can be considered complete.

At minimum, subsequent experiments must validate:

```text
LSN window construction

Incremental change retrieval

Boundary behavior

Checkpoint advancement

Restart from checkpoint

Replay behavior

Duplicate handling

Retention-boundary handling

Cross-table consumption behavior
```

Later implementation stages may extend this evidence to include:

```text
Debezium

Kafka

Bronze persistence

End-to-end idempotency

Failure recovery

Backlog and catch-up

Freshness measurement
```

Those stages must remain separate from the source-side evidence already established.

### 27.9 Current Engineering Checkpoint

The project currently stops at the following boundary:

```text
M01.08–M01.19
SQL Server CDC Source Foundation
        │
        ▼
COMPLETE AND VALIDATED
        │
        ▼
CDC Implementation Documentation
        │
        ▼
CURRENT WORK
        │
        ▼
M01.20A
LSN Window Inspection
        │
        ▼
NOT YET STARTED
```

This document does not claim any M01.20 results.

The next laboratory cycle begins only after the current CDC documentation completes the required validation and publication workflow.

The first technical objective after that checkpoint is:

```text
Inspect the valid CDC LSN window
        ↓
Query both capture instances
        ↓
Compare 'all' and 'all update old'
        ↓
Observe actual behavior
        ↓
Use the evidence to design the incremental consumption model
```

This preserves the Atlas Engineering implementation discipline:

```text
Understand
    ↓
Implement
    ↓
Observe
    ↓
Validate
    ↓
Document
    ↓
Only then advance
```

The SQL Server CDC source foundation is complete.

The next phase begins with controlled CDC consumption.

