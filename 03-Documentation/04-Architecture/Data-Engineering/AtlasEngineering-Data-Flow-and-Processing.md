# Atlas Engineering — Data Flow and Processing

## Table of Contents

[1. Purpose](#1-purpose)

[2. Processing Context](#2-processing-context)
   - [2.1 Processing Boundary](#21-processing-boundary)
   - [2.2 Asynchronous Processing Model](#22-asynchronous-processing-model)
   - [2.3 Processing States and Transitions](#23-processing-states-and-transitions)
   - [2.4 Cross-Cutting Processing Controls](#24-cross-cutting-processing-controls)

[3. Source Commit and Change Capture](#3-source-commit-and-change-capture)
   - [3.1 Source Transaction Commit](#31-source-transaction-commit)
   - [3.2 SQL Server Native CDC](#32-sql-server-native-cdc)
   - [3.3 Capture Position and Source Ordering](#33-capture-position-and-source-ordering)
   - [3.4 Transaction Boundaries](#34-transaction-boundaries)
   - [3.5 Capture Scope](#35-capture-scope)
   - [3.6 Capture Latency](#36-capture-latency)
   - [3.7 Failure and Recovery Considerations](#37-failure-and-recovery-considerations)
   - [3.8 Change-Capture Guarantees](#38-change-capture-guarantees)

[4. Event Creation and Technical Metadata](#4-event-creation-and-technical-metadata)
   - [4.1 Event Representation](#41-event-representation)
   - [4.2 Business Payload](#42-business-payload)
   - [4.3 Technical Metadata](#43-technical-metadata)
   - [4.4 Event Identity](#44-event-identity)
   - [4.5 Operation Semantics](#45-operation-semantics)
   - [4.6 Source Position and Event Identity](#46-source-position-and-event-identity)
   - [4.7 Schema and Contract Reference](#47-schema-and-contract-reference)
   - [4.8 Event Time and Processing Time](#48-event-time-and-processing-time)
   - [4.9 Correlation and Traceability](#49-correlation-and-traceability)
   - [4.10 Sensitive Data in Events](#410-sensitive-data-in-events)
   - [4.11 Event-Creation Guarantees](#411-event-creation-guarantees)

[5. Schema and Contract Governance](#5-schema-and-contract-governance)
   - [5.1 Event Contract](#51-event-contract)
   - [5.2 Producer and Consumer Responsibilities](#52-producer-and-consumer-responsibilities)
   - [5.3 Schema Registration](#53-schema-registration)
   - [5.4 Contract Evolution](#54-contract-evolution)
   - [5.5 Compatibility Policy](#55-compatibility-policy)
   - [5.6 Compatible Changes](#56-compatible-changes)
   - [5.7 Breaking Changes](#57-breaking-changes)
   - [5.8 Contract Version Identification](#58-contract-version-identification)
   - [5.9 Contract Evolution and Bronze History](#59-contract-evolution-and-bronze-history)
   - [5.10 Contract Validation and Testing](#510-contract-validation-and-testing)
   - [5.11 Contract Ownership and Documentation](#511-contract-ownership-and-documentation)
   - [5.12 Contract Lifecycle](#512-contract-lifecycle)
   - [5.13 Schema and Contract Governance Guarantees](#513-schema-and-contract-governance-guarantees)

[6. Kafka Transport, Partitioning, and Ordering](#6-kafka-transport-partitioning-and-ordering)
   - [6.1 Topics](#61-topics)
   - [6.2 Partitions](#62-partitions)
   - [6.3 Partition Key](#63-partition-key)
   - [6.4 Ordering Guarantees](#64-ordering-guarantees)
   - [6.5 Kafka Offset](#65-kafka-offset)
   - [6.6 Consumer Groups](#66-consumer-groups)
   - [6.7 Delivery Semantics](#67-delivery-semantics)
   - [6.8 Offset Management](#68-offset-management)
   - [6.9 Retention](#69-retention)
   - [6.10 Backlog and Consumer Lag](#610-backlog-and-consumer-lag)
   - [6.11 Backlog Recovery](#611-backlog-recovery)
   - [6.12 Rebalancing](#612-rebalancing)
   - [6.13 Kafka Failure and Recovery](#613-kafka-failure-and-recovery)
   - [6.14 Kafka Observability](#614-kafka-observability)
   - [6.15 Kafka Transport Guarantees](#615-kafka-transport-guarantees)

[7. Bronze Persistence and Offset Commit](#7-bronze-persistence-and-offset-commit)
   - [7.1 Bronze Persistence Boundary](#71-bronze-persistence-boundary)
   - [7.2 Bronze Record Content](#72-bronze-record-content)
   - [7.3 Immutable Historical Persistence](#73-immutable-historical-persistence)
   - [7.4 Temporary Write and Atomic Promotion](#74-temporary-write-and-atomic-promotion)
   - [7.5 Persistence Validation](#75-persistence-validation)
   - [7.6 Kafka Offset Commit](#76-kafka-offset-commit)
   - [7.7 Failure Before Bronze Persistence](#77-failure-before-bronze-persistence)
   - [7.8 Failure During Temporary Write](#78-failure-during-temporary-write)
   - [7.9 Failure After Bronze Promotion but Before Offset Commit](#79-failure-after-bronze-promotion-but-before-offset-commit)
   - [7.10 Failure After Offset Commit](#710-failure-after-offset-commit)
   - [7.11 Idempotent Bronze Processing](#711-idempotent-bronze-processing)
   - [7.12 File Granularity and Batching](#712-file-granularity-and-batching)
   - [7.13 Bronze Organization](#713-bronze-organization)
   - [7.14 Bronze Replay](#714-bronze-replay)
   - [7.15 Bronze Retention](#715-bronze-retention)
   - [7.16 Bronze Observability](#716-bronze-observability)
   - [7.17 Bronze Reconciliation](#717-bronze-reconciliation)
   - [7.18 Bronze Persistence Guarantees](#718-bronze-persistence-guarantees)

[8. Silver Processing, Standardization, and Deduplication](#8-silver-processing-standardization-and-deduplication)
   - [8.1 Silver Processing Boundary](#81-silver-processing-boundary)
   - [8.2 Bronze as the Historical Input](#82-bronze-as-the-historical-input)
   - [8.3 Contract-Aware Interpretation](#83-contract-aware-interpretation)
   - [8.4 Type Enforcement](#84-type-enforcement)
   - [8.5 Standardization](#85-standardization)
   - [8.6 Normalization](#86-normalization)
   - [8.7 Deduplication](#87-deduplication)
   - [8.8 Idempotent Silver Processing](#88-idempotent-silver-processing)
   - [8.9 Operation Semantics](#89-operation-semantics)
   - [8.10 Current State and Historical Events](#810-current-state-and-historical-events)
   - [8.11 Processing Version](#811-processing-version)
   - [8.12 Invalid Records and Quarantine](#812-invalid-records-and-quarantine)
   - [8.13 Silver Publication](#813-silver-publication)
   - [8.14 Incremental Processing](#814-incremental-processing)
   - [8.15 Reprocessing](#815-reprocessing)
   - [8.16 Backfill](#816-backfill)
   - [8.17 Silver Reconciliation](#817-silver-reconciliation)
   - [8.18 Silver Observability](#818-silver-observability)
   - [8.19 Silver Processing Guarantees](#819-silver-processing-guarantees)

[9. Gold Dimensional Processing](#9-gold-dimensional-processing)
   - [9.1 Gold Processing Boundary](#91-gold-processing-boundary)
   - [9.2 Dimensional Model](#92-dimensional-model)
   - [9.3 Fact Grain](#93-fact-grain)
   - [9.4 Business and Natural Keys](#94-business-and-natural-keys)
   - [9.5 Surrogate Keys](#95-surrogate-keys)
   - [9.6 Dimension Processing](#96-dimension-processing)
   - [9.7 Slowly Changing Dimensions](#97-slowly-changing-dimensions)
   - [9.8 Conformed Dimensions](#98-conformed-dimensions)
   - [9.9 Fact Processing](#99-fact-processing)
   - [9.10 Dimension Lookup and Unknown Members](#910-dimension-lookup-and-unknown-members)
   - [9.11 Temporal Consistency](#911-temporal-consistency)
   - [9.12 Incremental Gold Processing](#912-incremental-gold-processing)
   - [9.13 Idempotent Gold Processing](#913-idempotent-gold-processing)
   - [9.14 Gold Processing Version](#914-gold-processing-version)
   - [9.15 Gold Reprocessing](#915-gold-reprocessing)
   - [9.16 Gold Publication](#916-gold-publication)
   - [9.17 Gold Reconciliation](#917-gold-reconciliation)
   - [9.18 Gold Observability](#918-gold-observability)
   - [9.19 Gold Processing Guarantees](#919-gold-processing-guarantees)

[10. Quality Validation and Reconciliation](#10-quality-validation-and-reconciliation)
    - [10.1 Quality Validation Boundary](#101-quality-validation-boundary)
    - [10.2 Data Quality Dimensions](#102-data-quality-dimensions)
    - [10.3 Structural Quality](#103-structural-quality)
    - [10.4 Business Quality Rules](#104-business-quality-rules)
    - [10.5 Critical and Non-Critical Controls](#105-critical-and-non-critical-controls)
    - [10.6 Threshold-Based Controls](#106-threshold-based-controls)
    - [10.7 Source-to-Target Reconciliation](#107-source-to-target-reconciliation)
    - [10.8 Cross-Layer Reconciliation](#108-cross-layer-reconciliation)
    - [10.9 Reconciliation Windows](#109-reconciliation-windows)
    - [10.10 Late-Arriving Data](#1010-late-arriving-data)
    - [10.11 Quality Failure Handling](#1011-quality-failure-handling)
    - [10.12 Last Known-Good Version](#1012-last-known-good-version)
    - [10.13 Certification Decision](#1013-certification-decision)
    - [10.14 Atomic Certified Publication](#1014-atomic-certified-publication)
    - [10.15 End-to-End Freshness](#1015-end-to-end-freshness)
    - [10.16 Quality and Reconciliation Observability](#1016-quality-and-reconciliation-observability)
    - [10.17 Quality Rule Evolution](#1017-quality-rule-evolution)
    - [10.18 Quality and Reconciliation Guarantees](#1018-quality-and-reconciliation-guarantees)

[11. Certified Gold Publication and Analytical Consumption](#11-certified-gold-publication-and-analytical-consumption)
    - [11.1 Certified Gold Boundary](#111-certified-gold-boundary)
    - [11.2 Candidate and Published Versions](#112-candidate-and-published-versions)
    - [11.3 Successful Publication](#113-successful-publication)
    - [11.4 Failed Candidate Publication](#114-failed-candidate-publication)
    - [11.5 Atomic Publication](#115-atomic-publication)
    - [11.6 Publication Timestamp](#116-publication-timestamp)
    - [11.7 Analytical Consumption Contract](#117-analytical-consumption-contract)
    - [11.8 Power BI Consumption](#118-power-bi-consumption)
    - [11.9 Consumer Isolation from Processing](#119-consumer-isolation-from-processing)
    - [11.10 Publication Failure](#1110-publication-failure)
    - [11.11 Rollback](#1111-rollback)
    - [11.12 Consumer Freshness](#1112-consumer-freshness)
    - [11.13 Consumer Behavior During Staleness](#1113-consumer-behavior-during-staleness)
    - [11.14 Access Control](#1114-access-control)
    - [11.15 Certified Product Metadata](#1115-certified-product-metadata)
    - [11.16 Publication Observability](#1116-publication-observability)
    - [11.17 Analytical Consumption Guarantees](#1117-analytical-consumption-guarantees)

[12. Failure Handling, Replay, and Recovery](#12-failure-handling-replay-and-recovery)
    - [12.1 Failure Domains](#121-failure-domains)
    - [12.2 Failure Classification](#122-failure-classification)
    - [12.3 Retry](#123-retry)
    - [12.4 Processing Checkpoints](#124-processing-checkpoints)
    - [12.5 Recovery from Kafka](#125-recovery-from-kafka)
    - [12.6 Recovery from Bronze](#126-recovery-from-bronze)
    - [12.7 Recovery from Silver](#127-recovery-from-silver)
    - [12.8 Recovery from Backup](#128-recovery-from-backup)
    - [12.9 Recovery Source Selection](#129-recovery-source-selection)
    - [12.10 Replay](#1210-replay)
    - [12.11 Replay Safety](#1211-replay-safety)
    - [12.12 Reprocessing](#1212-reprocessing)
    - [12.13 Backfill](#1213-backfill)
    - [12.14 Rebuild](#1214-rebuild)
    - [12.15 Recovery and Contract Versions](#1215-recovery-and-contract-versions)
    - [12.16 Recovery and Processing Versions](#1216-recovery-and-processing-versions)
    - [12.17 Recovery and Certified Gold](#1217-recovery-and-certified-gold)
    - [12.18 Backlog Recovery](#1218-backlog-recovery)
    - [12.19 Recovery Point and Recovery Time](#1219-recovery-point-and-recovery-time)
    - [12.20 Partial Failure](#1220-partial-failure)
    - [12.21 Poison Records](#1221-poison-records)
    - [12.22 Recovery Validation](#1222-recovery-validation)
    - [12.23 Recovery Evidence](#1223-recovery-evidence)
    - [12.24 Recovery Observability](#1224-recovery-observability)
    - [12.25 Failure and Recovery Guarantees](#1225-failure-and-recovery-guarantees)

[13. End-to-End Traceability and Lineage](#13-end-to-end-traceability-and-lineage)
    - [13.1 Traceability and Lineage Boundary](#131-traceability-and-lineage-boundary)
    - [13.2 Source Traceability](#132-source-traceability)
    - [13.3 Event Identity](#133-event-identity)
    - [13.4 Kafka Traceability](#134-kafka-traceability)
    - [13.5 Bronze Lineage](#135-bronze-lineage)
    - [13.6 Silver Lineage](#136-silver-lineage)
    - [13.7 Gold Lineage](#137-gold-lineage)
    - [13.8 Dimensional Lineage](#138-dimensional-lineage)
    - [13.9 Certified Gold Lineage](#139-certified-gold-lineage)
    - [13.10 Analytical Product Lineage](#1310-analytical-product-lineage)
    - [13.11 Forward Impact Analysis](#1311-forward-impact-analysis)
    - [13.12 Backward Investigation](#1312-backward-investigation)
    - [13.13 Lineage Across Aggregation](#1313-lineage-across-aggregation)
    - [13.14 Lineage Across Replay and Reprocessing](#1314-lineage-across-replay-and-reprocessing)
    - [13.15 Lineage and Processing Versions](#1315-lineage-and-processing-versions)
    - [13.16 Correlation and Execution Identifiers](#1316-correlation-and-execution-identifiers)
    - [13.17 Traceability and Observability](#1317-traceability-and-observability)
    - [13.18 Lineage Metadata Management](#1318-lineage-metadata-management)
    - [13.19 Lineage Retention](#1319-lineage-retention)
    - [13.20 Lineage Validation](#1320-lineage-validation)
    - [13.21 Lineage Evidence](#1321-lineage-evidence)
    - [13.22 Traceability and Lineage Guarantees](#1322-traceability-and-lineage-guarantees)

[14. Observability and Operational Measurement](#14-observability-and-operational-measurement)
    - [14.1 Observability Dimensions](#141-observability-dimensions)
    - [14.2 Infrastructure Health](#142-infrastructure-health)
    - [14.3 Data-Flow Health](#143-data-flow-health)
    - [14.4 Throughput](#144-throughput)
    - [14.5 Stage Latency](#145-stage-latency)
    - [14.6 End-to-End Latency](#146-end-to-end-latency)
    - [14.7 Percentiles](#147-percentiles)
    - [14.8 Backlog](#148-backlog)
    - [14.9 Oldest Pending Work](#149-oldest-pending-work)
    - [14.10 No-Event Detection](#1410-no-event-detection)
    - [14.11 Processing Success and Failure](#1411-processing-success-and-failure)
    - [14.12 Error Classification](#1412-error-classification)
    - [14.13 Structured Logging](#1413-structured-logging)
    - [14.14 Correlation](#1414-correlation)
    - [14.15 Quality Observability](#1415-quality-observability)
    - [14.16 Reconciliation Observability](#1416-reconciliation-observability)
    - [14.17 Certification and Publication Observability](#1417-certification-and-publication-observability)
    - [14.18 Consumer Observability](#1418-consumer-observability)
    - [14.19 SLI and SLO](#1419-sli-and-slo)
    - [14.20 Alerting](#1420-alerting)
    - [14.21 Seasonal and Workload Baselines](#1421-seasonal-and-workload-baselines)
    - [14.22 Recovery Observability](#1422-recovery-observability)
    - [14.23 Capacity Observability](#1423-capacity-observability)
    - [14.24 Measured Baseline](#1424-measured-baseline)
    - [14.25 Dashboard Strategy](#1425-dashboard-strategy)
    - [14.26 Evidence from Observability](#1426-evidence-from-observability)
    - [14.27 OpenTelemetry Evolution](#1427-opentelemetry-evolution)
    - [14.28 Observability Guarantees](#1428-observability-guarantees)

[15. Processing Evidence and Validation Strategy](#15-processing-evidence-and-validation-strategy)
    - [15.1 Validation Scope](#151-validation-scope)
    - [15.2 Normal-Path Validation](#152-normal-path-validation)
    - [15.3 Failure Injection](#153-failure-injection)
    - [15.4 Idempotency Validation](#154-idempotency-validation)
    - [15.5 Offset and Durability Validation](#155-offset-and-durability-validation)
    - [15.6 Atomic Persistence Validation](#156-atomic-persistence-validation)
    - [15.7 Contract-Evolution Validation](#157-contract-evolution-validation)
    - [15.8 Transformation Validation](#158-transformation-validation)
    - [15.9 Quality-Gate Validation](#159-quality-gate-validation)
    - [15.10 Reconciliation Validation](#1510-reconciliation-validation)
    - [15.11 Certified Publication Validation](#1511-certified-publication-validation)
    - [15.12 Replay Validation](#1512-replay-validation)
    - [15.13 Backfill Validation](#1513-backfill-validation)
    - [15.14 Recovery Validation](#1514-recovery-validation)
    - [15.15 Backlog-Recovery Validation](#1515-backlog-recovery-validation)
    - [15.16 SLO Validation](#1516-slo-validation)
    - [15.17 Workload and Capacity Validation](#1517-workload-and-capacity-validation)
    - [15.18 Traceability Validation](#1518-traceability-validation)
    - [15.19 Evidence Structure](#1519-evidence-structure)
    - [15.20 Evidence Naming](#1520-evidence-naming)
    - [15.21 Evidence Quality](#1521-evidence-quality)
    - [15.22 Negative Evidence](#1522-negative-evidence)
    - [15.23 Evidence and Architecture Evolution](#1523-evidence-and-architecture-evolution)
    - [15.24 Laboratory Claims](#1524-laboratory-claims)
    - [15.25 Processing Validation Guarantees](#1525-processing-validation-guarantees)

---

## 1. Purpose

The purpose of this document is to describe the end-to-end data flow and processing behavior of the **Data Engineering layer** within the **Atlas Engineering — Enterprise Data Platform**.

While the **Architecture Overview** defines the high-level components, responsibilities, boundaries, and architectural principles of the platform, this document focuses on how data moves between those components and how each processing transition is expected to behave.

The document describes the complete path from a committed operational change in **AtlasCommerce** to its availability as certified analytical data, including change capture, event creation and transport, schema governance, historical persistence, transformation, dimensional processing, quality validation, reconciliation, certification, and analytical publication.

It also defines the processing guarantees and control mechanisms required across this path, including event identity, ordering, delivery semantics, idempotency, deduplication, atomic persistence, offset management, replay, backfill, traceability, failure handling, and recovery behavior.

The primary end-to-end processing path is:

**AtlasCommerce → SQL Server Native CDC → Debezium → Apache Kafka → Bronze → Silver → Gold → Quality and Reconciliation → Certified Gold → Analytical Consumption**

**Apicurio Registry** governs the schemas and compatibility of the event contracts used across the event-driven integration path and is therefore treated as a cross-cutting contract-governance capability rather than as a transport stage through which every event must pass.

The processing model described here represents the **Version 1 (V1)** target behavior. Implementation-specific procedures, configuration values, operational runbooks, and execution evidence are documented separately and must remain consistent with the processing guarantees defined in this document.

---

## 2. Processing Context

The Data Engineering processing flow begins after a business transaction has been successfully committed in **AtlasCommerce**.

The analytical platform does not participate in the operational transaction and must not become a synchronous dependency of the source workload. A transaction committed in AtlasCommerce remains operationally valid regardless of the immediate availability of downstream Data Engineering components.

After commit, the corresponding change becomes eligible for capture through **SQL Server Native CDC**. **Debezium** reads the captured change information and produces an event representation for asynchronous transport through **Apache Kafka**.

From that point forward, the event progresses through a sequence of controlled processing states:

**Committed Source Change → Captured Change → Published Event → Persisted Bronze Record → Standardized Silver Record → Modeled Gold Data → Validated and Reconciled Data → Certified Gold Publication → Analytical Consumption**

Each transition introduces a specific responsibility and must preserve the information required for traceability, recovery, reconciliation, and measurement.

The processing path is asynchronous by design. Temporary unavailability or reduced processing capacity in a downstream component may delay analytical freshness and create backlog, but it must not require the source transaction to wait for the analytical platform to complete processing.

This separation allows the operational and analytical workloads to evolve independently while maintaining a traceable relationship between the original committed change and its downstream analytical representation.

### 2.1 Processing Boundary

The processing boundary covered by this document begins with a committed change in AtlasCommerce and ends when the corresponding analytical representation has successfully completed the required quality, reconciliation, certification, and publication controls.

For governed analytical products, processing is not considered complete merely because data has reached **Gold**.

The end-to-end processing boundary is completed when the corresponding data becomes available through **Certified Gold** for governed analytical consumption.

This boundary is consistent with the V1 end-to-end freshness measurement defined by the architecture:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

### 2.2 Asynchronous Processing Model

The platform uses asynchronous processing to decouple operational transaction execution from downstream analytical processing.

This means that:

- AtlasCommerce commits business transactions independently of downstream analytical processing;
- CDC captures committed changes after the operational transaction boundary;
- Kafka provides asynchronous transport, buffering, and retention;
- downstream consumers process data according to their available capacity;
- temporary differences between event arrival rate and processing rate may create backlog;
- backlog must remain observable and recoverable;
- analytical freshness may degrade during downstream disruption without invalidating the already committed operational transaction.

The asynchronous model therefore provides temporal decoupling between the source workload and the analytical platform.

### 2.3 Processing States and Transitions

Data does not become certified analytical information through a single transformation.

It progresses through explicit processing states, each with a distinct meaning:

**Committed Source Change**  
The business transaction has been successfully committed in AtlasCommerce.

**Captured Change**  
SQL Server Native CDC has made the committed change available for downstream capture.

**Published Event**  
Debezium has represented the captured change as an event and made it available through Kafka.

**Persisted Bronze Record**  
The event has been durably persisted in the immutable historical layer together with the required technical metadata.

**Standardized Silver Record**  
The historical representation has been typed, standardized, normalized, and deduplicated according to the applicable processing rules.

**Modeled Gold Data**  
The standardized data has been transformed into business-oriented dimensional structures.

**Validated and Reconciled Data**  
The resulting analytical structures have successfully passed the required quality and source-to-target reconciliation controls.

**Certified Gold Publication**  
The validated analytical version has been atomically promoted to the governed publication state.

**Analytical Consumption**  
Certified data is available to authorized analytical consumers according to the corresponding data-product contract.

A transition between states must not imply that later guarantees have already been satisfied. For example, successful Bronze persistence does not imply successful Silver processing, and successful Gold transformation does not imply certification.

### 2.4 Cross-Cutting Processing Controls

Some controls apply across multiple processing states rather than belonging to a single transition.

These include:

- event identity and technical metadata;
- schema and contract governance;
- ordering controls;
- idempotency;
- deduplication;
- traceability and lineage;
- observability;
- security;
- quality controls;
- reconciliation;
- retry and recovery behavior;
- replay and backfill controls;
- versioning.

These controls must preserve their intended guarantees across retries, failures, reprocessing, and recovery operations.

Their detailed behavior is described in the corresponding sections of this document.

---

## 3. Source Commit and Change Capture

The end-to-end Data Engineering flow begins with a successfully committed business transaction in **AtlasCommerce**.

Only committed source changes are eligible to enter the analytical processing path. The Data Engineering platform does not participate in the source transaction and must preserve the operational transaction boundary established by AtlasCommerce.

Change capture is implemented through **SQL Server Native Change Data Capture (CDC)**, which provides the source-side foundation for identifying committed inserts, updates, and deletes that must be propagated downstream.

### 3.1 Source Transaction Commit

A source change becomes relevant to the Data Engineering platform only after the corresponding transaction has been successfully committed in AtlasCommerce.

The commit establishes the operational truth of the change.

Before commit, the change must not be treated as an analytical event because the source transaction may still fail or be rolled back.

After commit:

- AtlasCommerce remains the authoritative operational source;
- the committed change becomes eligible for CDC capture;
- the analytical platform may begin asynchronous downstream processing;
- downstream failure does not invalidate the committed source transaction.

The timestamp associated with the committed source change provides the initial temporal reference for end-to-end freshness measurement and is represented architecturally as `source_commit_ts`.

### 3.2 SQL Server Native CDC

**SQL Server Native CDC** captures committed data changes from the transaction log and makes change information available for downstream consumption.

CDC is responsible for the source-side capture of relevant changes without requiring recurring full-table extraction or application-level polling as the primary ingestion mechanism.

The captured change information must preserve sufficient source context to support downstream event creation, ordering, traceability, reconciliation, replay analysis, and latency measurement.

Depending on the source operation, captured changes may represent:

- inserted rows;
- updated rows;
- deleted rows.

The exact CDC representation of an operation is an implementation concern, but downstream processing must preserve the business meaning of the committed source change.

### 3.3 Capture Position and Source Ordering

The source transaction log provides an ordered record of committed database activity.

CDC exposes source-position information that allows downstream processing to identify where a captured change originated within that ordered history.

For the V1 architecture, the **Log Sequence Number (LSN)** is treated as important technical metadata for source traceability and processing control.

Source-position metadata may be used to support:

- identification of captured changes;
- relative source ordering;
- traceability to the source change;
- restart and recovery analysis;
- reconciliation;
- duplicate investigation;
- latency analysis.

An LSN is technical source metadata and must not be interpreted as a business identifier.

### 3.4 Transaction Boundaries

A single source transaction may affect more than one row and may affect more than one table.

The downstream event-processing model must therefore distinguish between:

- the identity of the source transaction;
- the identity of each captured change;
- the identity of the event created from that change;
- the business keys contained in the affected data.

These identifiers serve different purposes and must not be treated as interchangeable.

Where transaction metadata is available and required for processing or traceability, it should be preserved so that downstream analysis can relate individual changes back to their originating source transaction.

The event-driven architecture does not imply that an entire multi-row business transaction must always be represented as a single Kafka event. Event granularity is determined by the applicable event contract and processing requirements.

### 3.5 Capture Scope

CDC must be enabled only for source structures that are intentionally integrated into the Data Engineering platform.

The initial implementation scope is driven by the **Sales** domain and the source structures required to produce the **Daily Sales** analytical product.

As additional domains are incorporated, CDC scope must expand through controlled onboarding rather than by automatically capturing every table in AtlasCommerce.

For each newly captured source structure, the platform must evaluate:

- analytical requirement;
- expected change volume;
- source keys;
- operation semantics;
- ordering requirements;
- data sensitivity;
- event-contract requirements;
- reconciliation requirements;
- retention and recovery implications.

This controlled scope reduces unnecessary data movement and prevents the ingestion layer from becoming an indiscriminate copy of the operational database.

### 3.6 Capture Latency

The time between source commit and downstream availability of the captured change contributes to the end-to-end freshness objective.

Capture latency must therefore be observable independently from later processing stages.

Conceptually:

**CDC Capture Latency = cdc_capture_ts - source_commit_ts**

This measurement helps distinguish source-side capture delay from transport, persistence, transformation, certification, and publication delays.

The exact timestamp used to represent `cdc_capture_ts` must be defined consistently during implementation so that measurements remain comparable and reproducible.

### 3.7 Failure and Recovery Considerations

Temporary downstream unavailability must not require already committed source transactions to be repeated.

If Debezium or another downstream component is temporarily unable to consume captured changes, the architecture must preserve a recoverable position from which processing can resume without silently skipping eligible source changes.

Recovery behavior must account for:

- the last safely processed source position;
- the availability of required CDC history;
- duplicate delivery after restart;
- ordering implications;
- retention boundaries;
- observable gaps or discontinuities.

If required CDC history is no longer available, normal incremental recovery may no longer be possible. In that situation, recovery must follow an explicit rebuild or backfill procedure rather than silently continuing from an incomplete source history.

### 3.8 Change-Capture Guarantees

At the source-capture boundary, the architecture requires the following guarantees:

- only committed changes enter the downstream analytical path;
- the operational transaction does not depend synchronously on downstream processing;
- source-position metadata is preserved where required for traceability and recovery;
- captured changes remain attributable to their operational origin;
- temporary downstream failure must be recoverable while the required CDC history remains available;
- missing source history must be detected rather than silently ignored;
- capture behavior must be observable and measurable.

These guarantees establish the foundation upon which event creation and downstream delivery semantics are built.

---

## 4. Event Creation and Technical Metadata

After a committed source change becomes available through **SQL Server Native CDC**, **Debezium** converts the captured change into an event representation suitable for asynchronous transport through **Apache Kafka**.

The event must preserve the business information required by downstream processing while also carrying sufficient technical metadata to support identity, traceability, ordering, schema interpretation, idempotency, reconciliation, observability, replay, and recovery.

Business data and technical metadata serve different purposes and must remain distinguishable throughout the processing path.

The guarantees introduced in this section establish the common processing model of the platform and are expanded in the subsequent sections according to the architectural boundary in which each guarantee applies.

### 4.1 Event Representation

An event represents a captured source change made available to downstream consumers.

The event representation must provide enough information for an authorized consumer to understand:

- what source structure produced the change;
- what type of operation occurred;
- which source data was affected;
- when the source change was committed;
- where the change originated in the source change history;
- which event contract applies;
- how the event can be uniquely identified and traced.

The exact serialization format and physical message structure are implementation concerns, but they must preserve the architectural guarantees defined in this document.

### 4.2 Business Payload

The business payload contains the source information required for downstream analytical processing.

Its content is determined by the corresponding event contract and may vary according to:

- source entity;
- operation type;
- analytical requirement;
- source schema;
- data sensitivity;
- downstream processing requirements.

The payload must not be expanded indiscriminately simply because additional source columns are available.

Only information required by the applicable integration and analytical requirements should be propagated, particularly when personal or sensitive data is involved.

### 4.3 Technical Metadata

Events must preserve the technical metadata required to operate and validate the downstream processing path.

The initial metadata model includes, as applicable:

- `event_id`;
- `source_commit_ts`;
- source LSN or equivalent source-position metadata;
- source database;
- source schema;
- source table;
- operation type;
- event schema or contract version;
- event creation or ingestion timestamp;
- transaction metadata where available and required;
- trace or correlation identifier where applicable.

Additional metadata may be introduced when implementation evidence demonstrates a requirement for stronger traceability, recovery, observability, or processing control.

Technical metadata must remain interpretable independently from the business payload.

### 4.4 Event Identity

Each event must have a stable identity that allows downstream processing to distinguish one event from another and to recognize repeated delivery of the same logical event.

The architectural representation of this identity is `event_id`.

`event_id` is a technical processing identifier and must not be confused with:

- a source primary key;
- a business transaction identifier;
- a Kafka offset;
- a source LSN;
- a trace or correlation identifier.

These values may participate in traceability or processing controls, but they represent different concepts.

The exact mechanism used to derive or assign `event_id` must be deterministic or otherwise preserve stable identity across delivery retries where duplicate recognition is required.

### 4.5 Operation Semantics

The event must identify the source operation represented by the captured change.

At minimum, the processing model must distinguish the applicable semantics of:

- insert;
- update;
- delete.

Where the CDC representation exposes before and after values, downstream contracts must define which representations are propagated and how consumers interpret them.

A delete event must not become indistinguishable from missing data, and an update must preserve enough context for downstream processing to determine the resulting analytical state.

Operation semantics must remain explicit throughout the stages that require them for reconstruction, deduplication, reconciliation, or dimensional processing.

### 4.6 Source Position and Event Identity

Source position and event identity provide complementary guarantees.

The source LSN identifies where a captured change originated in the ordered source change history.

`event_id` identifies the event representation used by downstream processing.

Conceptually:

**Source Position → Where did the change originate?**

**Event Identity → Which event am I processing?**

Neither should be treated as a replacement for the other.

Preserving both allows downstream systems to investigate duplicate delivery, ordering behavior, replay, recovery, and lineage without depending on a single overloaded identifier.

### 4.7 Schema and Contract Reference

Each event must be interpretable according to an explicit event contract.

The event representation must therefore provide, directly or through the applicable serialization mechanism, sufficient information to identify the schema or contract version required to interpret the event correctly.

**Apicurio Registry** governs the registered event schemas and their compatibility policies.

Schema governance applies to the evolution of event contracts and does not require every event to synchronously query the registry during transport.

Consumers must be able to determine which contract applies to an event and must not silently interpret an incompatible event using assumptions from another schema version.

### 4.8 Event Time and Processing Time

The architecture distinguishes between the time associated with the source change and timestamps introduced as the event moves through the platform.

Examples include:

- `source_commit_ts` — when the operational change was committed;
- event creation timestamp — when the event representation was produced;
- Kafka availability timestamp — when the event became available for consumption;
- Bronze persistence timestamp — when the event was durably persisted in Bronze;
- downstream processing timestamps — when later transformations occurred;
- `certified_gold_publish_ts` — when the resulting analytical data became available through Certified Gold.

These timestamps serve different purposes and must not be treated as interchangeable.

`source_commit_ts` remains the primary starting reference for end-to-end analytical freshness.

Processing timestamps allow the platform to decompose that latency and identify where time is spent across the pipeline.

### 4.9 Correlation and Traceability

A single business operation may generate multiple captured changes and multiple downstream events.

Where cross-event correlation is required, the platform may preserve transaction, correlation, or trace metadata that allows related events to be investigated together.

Correlation does not replace event identity.

For example:

**one source transaction → multiple captured changes → multiple event identities → shared transaction or correlation context**

This distinction allows the platform to trace both individual processing units and their relationship to a broader operational action.

### 4.10 Sensitive Data in Events

Event creation must respect the platform's data-minimization and security principles.

Sensitive information must not be propagated solely because it exists in the source structure.

For each event contract, the required payload must be evaluated according to:

- analytical necessity;
- business purpose;
- sensitivity classification;
- downstream access requirements;
- retention implications;
- applicable privacy requirements.

Where appropriate, sensitive fields may be excluded, masked, hashed, tokenized, or otherwise protected according to the applicable security and governance controls.

Technical metadata must also be reviewed for unintended exposure of sensitive information.

### 4.11 Event-Creation Guarantees

At the event-creation boundary, the architecture requires the following guarantees:

- only captured committed source changes are represented as normal downstream events;
- each event remains attributable to its source origin;
- event identity is stable enough to support the required duplicate-recognition behavior;
- operation semantics remain explicit;
- applicable contract information remains identifiable;
- source-position metadata is preserved where required;
- business payload and technical metadata remain distinguishable;
- required timestamps support end-to-end latency decomposition;
- sensitive data is propagated only according to defined requirements;
- event creation remains observable and traceable.

These guarantees establish the event representation that Kafka transports and downstream consumers process.

---

## 5. Schema and Contract Governance

Event-driven integration requires producers and consumers to share an explicit understanding of the structure and semantics of the events exchanged between them.

Within the Atlas Engineering platform, this shared understanding is represented through versioned **event contracts** governed by **Apicurio Registry**.

An event contract defines the structure required to interpret an event and establishes the controlled interface between event production and downstream consumption.

Contract governance exists to allow event structures to evolve deliberately while preventing incompatible changes from propagating silently through the platform.

### 5.1 Event Contract

An event contract defines the expected representation of an event for a specific integration context.

Depending on the serialization and schema technology selected during implementation, the contract may define characteristics such as:

- field names;
- field data types;
- required and optional fields;
- nested structures;
- logical types;
- default values where applicable;
- allowed structural evolution;
- contract version.

The contract describes the event interface and must remain distinct from the physical definition of the source database table.

A source table may contain information that is intentionally excluded from an event contract, and an event contract may include technical metadata that does not exist as a business column in the source table.

### 5.2 Producer and Consumer Responsibilities

The producer is responsible for creating events that conform to the applicable event contract.

Consumers are responsible for interpreting events according to the contract version associated with those events.

Neither side should rely on undocumented structural assumptions.

A consumer must not assume that:

- fields will always remain unchanged unless the contract guarantees it;
- every source column is present in the event;
- field order carries business meaning unless explicitly defined;
- a newly introduced field is automatically meaningful to every consumer;
- an absent optional field represents the same condition as an explicitly populated value.

The contract therefore establishes a controlled boundary between event production and consumption.

### 5.3 Schema Registration

Event schemas are registered and versioned through **Apicurio Registry**.

The registry provides the governed reference for the schema versions associated with event contracts and allows compatibility policies to be applied when those contracts evolve.

Schema registration is a control over contract definition and evolution.

It must not be interpreted as a requirement for every individual event to synchronously query or physically pass through the registry during Kafka transport.

The serialization mechanism used during implementation must allow consumers to identify the applicable schema or contract version required to interpret an event correctly.

### 5.4 Contract Evolution

Event contracts are expected to evolve as source systems, analytical requirements, and platform capabilities change.

Evolution must be controlled.

Examples of potential contract evolution include:

- adding a new optional field;
- adding a field with an applicable default;
- changing whether a field is required;
- changing a field data type;
- renaming a field;
- removing a field;
- changing a nested structure;
- changing the semantic meaning of an existing field.

Not all structural changes have the same impact.

A change that appears technically small may still be semantically breaking if consumers interpret the affected field differently after the change.

Contract evolution must therefore consider both **structural compatibility** and **semantic compatibility**.

### 5.5 Compatibility Policy

Compatibility policies define which schema changes may be accepted without requiring an explicit breaking-version migration.

The exact compatibility mode used for each contract is an implementation decision that must be documented and validated against the selected serialization and schema technology.

The policy must protect existing consumers from incompatible evolution while allowing safe changes to proceed without unnecessary disruption.

A schema change accepted by a registry compatibility check does not automatically prove that the business meaning of the event remains compatible.

Technical compatibility and semantic compatibility must both be considered.

### 5.6 Compatible Changes

A compatible change is one that can be introduced according to the applicable contract policy without invalidating the supported interaction between producers and consumers.

Compatible evolution may allow different contract versions to coexist during a controlled transition.

Even when a change is technically compatible, the platform must evaluate whether:

- existing consumers can safely ignore new information;
- required analytical meaning remains unchanged;
- default or missing values are interpreted consistently;
- downstream transformations remain valid;
- quality and reconciliation rules remain correct;
- metadata and lineage remain accurate.

Compatibility therefore protects integration behavior, not merely schema syntax.

### 5.7 Breaking Changes

A breaking change alters the contract in a way that cannot safely preserve the supported producer-consumer interaction under the existing compatibility expectations.

Examples may include:

- removing a field required by existing consumers;
- introducing an incompatible data type;
- changing the meaning of an existing field;
- restructuring data in a way unsupported by existing consumers;
- changing required/optional behavior incompatibly.

Breaking changes require an explicit migration strategy.

Depending on the impact, the strategy may include:

- a new contract version;
- producer transition;
- consumer transition;
- temporary coexistence between versions;
- transformation changes;
- replay or rebuild requirements;
- validation criteria;
- rollback procedures;
- deprecation period;
- removal criteria.

Breaking changes must not be introduced silently under the assumption that downstream consumers will adapt automatically.

### 5.8 Contract Version Identification

Downstream processing must be able to determine which contract applies to an event.

Contract-version identification must remain sufficiently stable to support:

- correct deserialization;
- processing according to the applicable structure;
- historical interpretation;
- replay;
- debugging;
- lineage;
- migration between versions.

Historical events must remain interpretable according to the contract that applied when they were produced, even after newer contract versions are introduced.

This requirement is especially important for Bronze replay because immutable historical data may contain events produced under multiple contract versions.

### 5.9 Contract Evolution and Bronze History

Bronze preserves historical event representations.

As contracts evolve, Bronze may therefore contain multiple schema versions for the same logical event family.

Downstream processing must not assume that all historical Bronze records conform to the newest contract version.

Silver processing must explicitly handle the supported historical versions required for reconstruction or replay.

Where an older version is no longer supported directly, an explicit migration or normalization path must exist before the affected history can participate safely in downstream rebuilding.

Contract evolution must not make preserved historical data silently uninterpretable.

### 5.10 Contract Validation and Testing

Contract changes must be validated before they are introduced into the normal governed processing path.

Validation should include, as applicable:

- registry compatibility validation;
- producer serialization tests;
- consumer deserialization tests;
- supported-version tests;
- transformation tests;
- quality-rule validation;
- reconciliation validation;
- replay validation;
- migration tests for breaking changes.

Tests must verify the behavior that the contract is expected to preserve rather than relying only on successful schema registration.

Evidence from contract-evolution tests should be retained when the change affects critical processing guarantees or certified analytical products.

### 5.11 Contract Ownership and Documentation

Each governed event contract must have identifiable ownership.

Contract documentation should include, as applicable:

- contract purpose;
- producer;
- consumers;
- source;
- schema location or registry reference;
- compatibility policy;
- supported versions;
- sensitivity considerations;
- lifecycle state;
- related transformations;
- deprecation information.

Ownership ensures that contract evolution has an accountable decision point rather than occurring implicitly through source-schema changes.

A change in the AtlasCommerce source schema does not automatically authorize a corresponding breaking change in an event contract.

### 5.12 Contract Lifecycle

Event contracts must follow a controlled lifecycle.

The initial lifecycle is:

**Draft → Active → Deprecated → Removed**

**Draft**  
The contract is being designed or changed and is not yet authorized for normal governed processing.

**Active**  
The contract version is supported for normal event production and consumption.

**Deprecated**  
The contract remains temporarily supported but is scheduled for replacement or retirement.

**Removed**  
The contract version is no longer supported for normal processing.

Removal must consider historical replay and reconstruction requirements before support for an older contract version is eliminated.

### 5.13 Schema and Contract Governance Guarantees

At the contract-governance boundary, the architecture requires the following guarantees:

- events are interpreted through explicit and versioned contracts;
- schema evolution is governed rather than introduced silently;
- technical compatibility and semantic compatibility are treated as distinct concerns;
- breaking changes require explicit migration;
- consumers can identify the contract applicable to an event;
- historical events remain interpretable for the required replay and retention period;
- contract changes are validated beyond registry acceptance alone;
- contract ownership and lifecycle remain documented;
- source-schema evolution does not automatically redefine downstream event contracts.

These guarantees allow the event-driven integration path to evolve without sacrificing controlled producer-consumer compatibility.

---

## 6. Kafka Transport, Partitioning, and Ordering

**Apache Kafka** provides the event-transport layer between source change capture and downstream Data Engineering consumers.

Its primary responsibilities are to transport events asynchronously, buffer temporary differences between production and consumption rates, retain events for a controlled period, preserve ordering within defined boundaries, and provide positions from which consumers can resume processing.

Kafka is not the permanent historical system of record for the analytical platform. Its retention supports transport, operational recovery, and controlled replay, while **Bronze** provides the durable immutable historical foundation for downstream reconstruction.

### 6.1 Topics

Events are published to Kafka topics according to the integration and domain boundaries defined by the platform.

A topic represents a logical event stream and must have a clear purpose, ownership, applicable event contract, retention expectation, and consumer context.

Topic design must avoid both extremes:

- creating unnecessarily fragmented topics without an architectural reason;
- combining unrelated event families into a single stream merely to reduce the number of topics.

The initial topic strategy must be driven by the **Sales** implementation and refined through measured processing behavior before additional domains are incorporated.

Topic naming conventions and concrete topic definitions are implementation standards and are documented separately.

### 6.2 Partitions

A Kafka topic is divided into one or more partitions.

Partitions provide the primary unit of ordering and parallel consumption within a topic.

Events assigned to the same partition are maintained in an ordered sequence, while events assigned to different partitions may be processed independently and concurrently.

Partitioning therefore affects both:

- processing scalability;
- ordering guarantees.

Increasing the number of partitions may increase available consumer parallelism, but it also creates additional independent ordering boundaries.

Partition count must therefore be treated as an architectural and operational sizing decision rather than as an arbitrary configuration value.

### 6.3 Partition Key

When related events require ordered processing, the partitioning strategy must use a stable key that causes those events to be assigned consistently to the same partition.

The appropriate partition key depends on the ordering requirement of the corresponding event family.

Potential keys may include, depending on the domain and contract:

- business entity identifier;
- transaction identifier;
- aggregate identifier;
- another stable processing key.

The selected key must preserve the ordering boundary actually required by downstream processing.

A key must not be selected solely because it provides an even distribution if doing so breaks required event ordering.

Conversely, a key that concentrates excessive traffic into a small number of partitions may preserve ordering while limiting scalability.

Partition-key selection therefore requires an explicit balance between **ordering correctness** and **processing parallelism**.

### 6.4 Ordering Guarantees

Kafka ordering is guaranteed within a partition, not globally across all partitions of a topic.

Conceptually:

**Same Partition → Ordered Sequence**

**Different Partitions → No Global Processing Order Guarantee**

The architecture must therefore avoid assumptions that require a total ordering of unrelated events unless such ordering is explicitly designed and justified.

If two events must be processed in source-relative order, the partitioning strategy and event model must preserve the required relationship.

Where global ordering is not required, independent partitions should be allowed to progress concurrently.

Downstream processing must not reconstruct an artificial global order from Kafka offsets belonging to different partitions.

### 6.5 Kafka Offset

Within each partition, Kafka assigns an offset that identifies the position of a record in that partition.

An offset is a Kafka transport position.

It must not be confused with:

- `event_id`;
- source primary key;
- business transaction identifier;
- source LSN;
- event-contract version;
- trace or correlation identifier.

Conceptually:

**Source LSN → position in source change history**

**event_id → identity of the downstream event**

**Kafka partition + offset → position of the event within a Kafka partition**

Kafka offsets are meaningful within their corresponding partition and must not be interpreted as globally ordered identifiers across partitions.

### 6.6 Consumer Groups

Kafka consumer groups allow processing work to be distributed across multiple consumer instances.

Within a consumer group, a partition is processed by at most one active consumer instance at a time for that group.

This allows consumers to scale horizontally while preserving partition-level ordering.

The effective processing parallelism of a consumer group is therefore constrained by the number of partitions available to that group.

Adding consumer instances beyond the available partition count does not create additional partition-processing parallelism.

Consumer-group design must reflect:

- workload volume;
- required ordering boundaries;
- expected processing concurrency;
- failure and rebalance behavior;
- recovery objectives;
- resource availability.

### 6.7 Delivery Semantics

The V1 architecture uses **at-least-once delivery**.

Under this model, an event that has not been safely acknowledged as processed may be delivered again.

Duplicate delivery is therefore an expected processing condition rather than an exceptional architectural violation.

The platform must not depend on Kafka delivering each logical event exactly once to achieve correct analytical results.

Correctness is achieved through the combination of:

- stable event identity;
- controlled offset management;
- idempotent downstream processing;
- deduplication where required;
- reconciliation and quality controls.

The detailed relationship between persistence and offset acknowledgement is defined in the Bronze processing section of this document.

### 6.8 Offset Management

Consumer offsets represent the progress of a consumer group through each Kafka partition.

An offset must be advanced only when the processing stage protected by that acknowledgement has completed according to its required durability guarantees.

For the initial Bronze consumer, the architectural rule is:

**Persist Successfully to Bronze → Validate Persistence → Commit Kafka Offset**

The offset must not be committed merely because the event was received or transformation began.

If processing fails before the offset is safely committed, Kafka may deliver the event again after recovery.

This behavior is intentional and is one of the reasons downstream processing must be idempotent.

### 6.9 Retention

Kafka retains events according to configured retention policies.

Retention provides a bounded window for:

- temporary buffering;
- consumer recovery;
- operational replay;
- investigation;
- controlled reprocessing.

Kafka retention must not be treated as a substitute for Bronze historical retention.

The required Kafka retention period must be determined from measured and documented factors such as:

- expected workload;
- maximum tolerated consumer outage;
- recovery time;
- replay requirements;
- available storage;
- operational risk;
- downstream recovery strategy.

Retention values must be validated through implementation and failure testing rather than selected solely from arbitrary defaults.

### 6.10 Backlog and Consumer Lag

When events are produced faster than they are consumed, or when consumers are unavailable, unprocessed events accumulate.

This accumulation forms a processing backlog.

Kafka consumer lag provides an important measure of how far a consumer group is behind the latest available position in each partition.

However, event count alone does not fully describe the operational impact of backlog.

The platform must also observe the age of pending work, particularly the **oldest pending event**, because a relatively small backlog may still represent an unacceptable freshness delay.

Conceptually:

**Backlog Size → How much work is waiting?**

**Oldest Pending Event → How old is the work still waiting?**

Both measurements contribute to understanding analytical freshness and recovery behavior.

### 6.11 Backlog Recovery

After a disruption, a recovered consumer may need to process both:

- accumulated backlog;
- newly arriving events.

For backlog to decrease, sustained processing throughput must exceed the incoming event rate.

Conceptually:

**Recovery Capacity = Processing Rate - Incoming Rate**

If:

**Processing Rate ≤ Incoming Rate**

the consumer may be operational but the backlog will not decrease.

Recovery validation must therefore measure not only whether consumption resumes, but also whether the platform can return to its normal freshness objective within acceptable conditions.

Backlog-recovery tests should measure, as applicable:

- backlog accumulated during the disruption;
- oldest pending event;
- processing throughput after recovery;
- incoming event rate;
- backlog reduction rate;
- time required to return to normal latency;
- resource utilization during catch-up.

### 6.12 Rebalancing

Changes in consumer-group membership may cause Kafka to redistribute partition ownership among consumer instances.

This process is known as rebalancing.

Rebalancing may occur when, for example:

- a consumer starts;
- a consumer stops;
- a consumer fails;
- consumer-group membership changes;
- partition availability or assignment changes.

Downstream processing must tolerate rebalancing without assuming that a consumer instance permanently owns a specific partition.

Processing state that affects correctness must therefore not depend solely on ephemeral in-memory ownership of a partition.

Rebalancing behavior must be considered in offset management, idempotency, retries, and failure testing.

### 6.13 Kafka Failure and Recovery

Temporary Kafka or consumer unavailability may delay processing but must not silently change the meaning of already captured events.

Recovery must preserve the ability to determine:

- which partitions were affected;
- which offsets were safely committed;
- which events may be delivered again;
- whether required events remain within retention;
- whether ordering guarantees remain preserved;
- whether backlog has accumulated;
- whether the end-to-end SLO has been affected.

If required events are no longer available within Kafka retention, recovery must use the next appropriate recovery source defined by the architecture rather than silently skipping the missing range.

Kafka is therefore one recovery mechanism within the broader hierarchy:

**Kafka → Bronze → Silver → Backup**

### 6.14 Kafka Observability

The Kafka transport layer must expose sufficient information to observe both infrastructure health and processing behavior.

Initial observability should include, as applicable:

- broker availability;
- topic and partition availability;
- producer errors;
- consumer errors;
- consumer-group state;
- consumer lag by partition;
- total backlog;
- oldest pending event;
- event production rate;
- event consumption rate;
- processing throughput;
- rebalance activity;
- retention risk;
- transport latency.

Infrastructure health and data-flow health must be interpreted together.

A healthy Kafka process does not prove that consumers are current, and zero reported lag does not by itself prove that expected source events are arriving.

### 6.15 Kafka Transport Guarantees

At the Kafka transport boundary, the architecture requires the following guarantees:

- events are transported asynchronously between producers and consumers;
- ordering is preserved within the required partition boundary;
- no unsupported global ordering assumption is introduced across partitions;
- transport positions remain identifiable through partition and offset;
- at-least-once delivery is tolerated by downstream processing;
- offsets advance only after the protected processing stage satisfies its durability requirement;
- backlog and lag remain observable;
- retention provides a controlled recovery window;
- consumer rebalancing does not compromise processing correctness;
- missing retained history is detected rather than silently ignored;
- Kafka remains a transport and bounded-replay layer rather than the permanent historical foundation.

These guarantees establish the transport behavior upon which durable Bronze persistence depends.

---

## 7. Bronze Persistence and Offset Commit

The **Bronze layer** is the first durable historical persistence boundary of the Data Engineering platform.

Events consumed from **Apache Kafka** are persisted in Bronze as immutable historical records using **Parquet** with **Snappy compression** on **MinIO**.

Bronze persistence must preserve the event information and technical metadata required for historical reconstruction, traceability, replay, reconciliation, and downstream processing.

The relationship between Bronze persistence and Kafka offset acknowledgement is critical to the V1 **at-least-once** processing model.

The fundamental processing rule is:

**Consume Event → Prepare Bronze Object → Validate Persistence → Atomically Promote → Commit Kafka Offset**

A Kafka offset must not be committed until the corresponding Bronze persistence has successfully reached the durable state required by the architecture.

### 7.1 Bronze Persistence Boundary

Bronze represents the first downstream point at which an event becomes durably preserved outside the Kafka transport layer.

Successful receipt of an event by a consumer does not constitute durable Bronze persistence.

Similarly, beginning a file write or creating a temporary object does not mean that the event has been safely persisted.

An event is considered successfully persisted to Bronze only after:

- the required event content has been written;
- required technical metadata has been preserved;
- the resulting object has passed the applicable persistence validation;
- the object has been promoted to its final visible state;
- the final object is available at the expected Bronze location.

Only after these conditions are satisfied may the protected Kafka offset be acknowledged according to the applicable offset-management strategy.

### 7.2 Bronze Record Content

Bronze must preserve a representation sufficiently close to the original event to support historical interpretation and downstream reconstruction.

The persisted representation must include, as applicable:

- business payload;
- `event_id`;
- `source_commit_ts`;
- source-position metadata such as LSN;
- source database, schema, and table;
- operation type;
- event-contract or schema version;
- event creation or ingestion timestamp;
- Kafka topic;
- Kafka partition;
- Kafka offset;
- Bronze persistence timestamp;
- transaction, trace, or correlation metadata where required.

Bronze may introduce technical storage metadata required to operate the historical layer, but it must not silently redefine the business meaning of the original event.

### 7.3 Immutable Historical Persistence

Bronze is append-only and historically preserved.

Normal processing must not destructively overwrite an existing historical record merely because a newer event for the same business entity arrives.

For example:

**INSERT entity A → Bronze historical record 1**

**UPDATE entity A → Bronze historical record 2**

**DELETE entity A → Bronze historical record 3**

The historical sequence remains preserved.

Corrections to processing logic or downstream interpretation must be represented through controlled reprocessing, new derived versions, or explicit remediation procedures rather than by silently rewriting the original historical event representation.

### 7.4 Temporary Write and Atomic Promotion

Bronze persistence must prevent partially written objects from becoming visible as valid final data.

The V1 persistence pattern is:

**Temporary Object → Write → Validate → Atomic Promotion → Final Object**

The consumer first writes the output to a temporary or otherwise non-final location.

The write is then validated according to the applicable persistence controls.

Only after successful validation is the object promoted to its final Bronze location.

If processing fails before final promotion, the temporary or incomplete object must not be interpreted by downstream processing as successfully persisted Bronze data.

The exact MinIO operation used to implement final promotion must be validated during implementation because object-storage semantics may differ from traditional filesystem rename semantics.

The architecture requires atomic publication behavior; it does not assume a specific filesystem operation without implementation evidence.

### 7.5 Persistence Validation

Before final promotion, the consumer must perform the validation required to establish that the Bronze object is usable according to the persistence contract.

Validation may include, as applicable:

- successful object creation;
- expected file format;
- successful Parquet readability;
- required schema or metadata presence;
- expected record count;
- expected event identity;
- absence of incomplete output;
- object-size sanity checks;
- checksum or integrity validation where implemented.

The exact validation set may evolve through implementation evidence, but it must be sufficient to prevent an incomplete or invalid object from being acknowledged as successfully persisted.

### 7.6 Kafka Offset Commit

Kafka offset acknowledgement represents the consumer group's statement that the protected processing work has progressed beyond a specific Kafka position.

For the initial Bronze consumer, the architectural ordering is:

**Bronze Durability First → Kafka Offset Commit Second**

The offset must not be committed:

- immediately after receiving the event;
- merely after deserialization;
- when the Bronze write begins;
- while only a temporary object exists;
- before persistence validation succeeds;
- before final Bronze promotion succeeds.

This ordering reduces the risk of acknowledging an event that has not yet been durably preserved.

### 7.7 Failure Before Bronze Persistence

If processing fails before the event has been successfully persisted to Bronze and before its Kafka offset has been committed, the event remains eligible for redelivery.

Conceptually:

**Consume → Failure → No Bronze Persistence → No Offset Commit → Redelivery**

After recovery, the consumer processes the event again.

This is expected behavior under the at-least-once model.

The failure must remain observable, and repeated failures must not result in silent event skipping.

### 7.8 Failure During Temporary Write

If the consumer fails while writing the temporary Bronze object, the incomplete temporary object must not become visible as valid final Bronze data.

After recovery:

- Kafka may redeliver the event;
- incomplete temporary artifacts must be detected or safely isolated;
- the event may be processed again;
- final promotion occurs only after a complete and valid write.

Temporary-object cleanup must be operationally controlled so that abandoned artifacts do not accumulate indefinitely or become confused with valid final objects.

### 7.9 Failure After Bronze Promotion but Before Offset Commit

A critical at-least-once failure scenario occurs when:

1. the event is successfully persisted to Bronze;
2. the final Bronze object becomes valid and visible;
3. the consumer fails before committing the Kafka offset.

After recovery, Kafka may deliver the same event again.

Conceptually:

**Persisted Successfully → Failure → Offset Not Committed → Event Redelivered**

This scenario creates the possibility of duplicate processing.

It must not create a second logically distinct historical event merely because the same Kafka event was delivered again.

The platform must use stable event identity and idempotent processing controls to recognize the repeated delivery according to the applicable Bronze persistence strategy.

### 7.10 Failure After Offset Commit

If the Bronze object has been successfully persisted, validated, promoted, and the corresponding Kafka offset has been safely committed, the consumer may advance beyond that Kafka position.

A later consumer failure must not require the already acknowledged event to be treated as unprocessed merely because the consumer instance restarted.

The durable Bronze representation becomes the downstream historical foundation for later processing and recovery.

### 7.11 Idempotent Bronze Processing

Bronze processing must tolerate repeated delivery of the same logical event without producing an incorrect historical state.

Idempotency does not mean that legitimate subsequent changes to the same business entity are discarded.

The platform must distinguish:

**Same business entity + different event identity → legitimate historical changes**

from:

**Same event identity delivered again → repeated delivery of the same logical event**

For example:

**TRN_id = 100 / event_id = A → persist**

**TRN_id = 100 / event_id = B → persist**

**TRN_id = 100 / event_id = B again → recognize repeated delivery**

The exact idempotency mechanism may use deterministic object identity, event-level control metadata, persisted processing state, or another implementation validated during the laboratory phase.

The architectural requirement is the behavior: repeated delivery must not corrupt or falsely multiply the logical historical record.

### 7.12 File Granularity and Batching

Bronze persistence may group multiple events into a Parquet object for processing and storage efficiency.

The exact file granularity is an implementation and sizing decision.

Batching introduces an important acknowledgement boundary: if one Kafka offset commit protects multiple events persisted together, the platform must ensure that the complete protected batch has reached the required durable state before the corresponding offsets are advanced.

Batch sizing must consider:

- event volume;
- processing latency;
- file-size efficiency;
- memory usage;
- recovery granularity;
- retry cost;
- object count;
- downstream read efficiency;
- end-to-end SLO impact.

Larger batches may improve storage and processing efficiency while increasing the amount of work repeated after a failure.

Smaller batches may reduce retry granularity while increasing object count and operational overhead.

Batch sizing must therefore be measured rather than selected solely from an arbitrary default.

### 7.13 Bronze Organization

Bronze objects must be organized using deterministic storage conventions that support efficient discovery, replay, lifecycle management, and traceability.

The physical organization may consider dimensions such as:

- source system;
- domain;
- event family;
- source table;
- event date;
- ingestion date;
- contract version;
- processing version.

The exact path convention is an implementation standard and is documented separately.

Storage organization must not depend on information that cannot be reconstructed reliably during replay.

### 7.14 Bronze Replay

Bronze is the primary durable historical foundation for downstream reconstruction when the required history is available.

Replay from Bronze may be required when, for example:

- Silver processing logic changes;
- a downstream defect is corrected;
- Gold must be rebuilt;
- a quality rule requires historical re-evaluation;
- a new analytical requirement needs preserved historical information;
- Kafka retention no longer contains the required events.

Replay must preserve the distinction between:

- original event identity;
- original source timestamps;
- original contract version;
- replay execution time;
- processing version used during replay.

Replaying an event must not make the historical event appear to have originated at the replay time.

### 7.15 Bronze Retention

Bronze retention must be defined independently from Kafka retention.

Kafka provides bounded transport retention.

Bronze provides the durable historical foundation required for longer-term replay and reconstruction.

Bronze retention must consider:

- analytical reconstruction requirements;
- source-history requirements;
- regulatory or privacy obligations;
- storage capacity;
- contract-version support;
- lifecycle policies;
- backup strategy;
- downstream recovery requirements.

Retention must not be shortened without evaluating whether required replay or reconstruction capabilities would be lost.

### 7.16 Bronze Observability

Bronze processing must expose sufficient information to determine whether events are being persisted correctly and whether Kafka progress accurately reflects durable historical persistence.

Initial observability should include, as applicable:

- events consumed;
- events persisted;
- persistence failures;
- validation failures;
- temporary-object failures;
- promotion failures;
- duplicate deliveries detected;
- idempotent duplicate handling;
- Kafka offsets received;
- Kafka offsets committed;
- Bronze write latency;
- Bronze persistence throughput;
- object count;
- object size;
- abandoned temporary objects;
- processing retries;
- oldest unpersisted event;
- storage-capacity utilization.

Observability must allow the platform to distinguish between:

**consumer received the event**

and:

**event is durably available in Bronze**.

### 7.17 Bronze Reconciliation

Bronze persistence must support reconciliation between Kafka consumption and durable historical storage.

The platform must be able to investigate whether:

- expected Kafka events were persisted;
- persisted events retain their Kafka position metadata;
- repeated deliveries were handled according to the idempotency strategy;
- committed offsets do not advance beyond data that should have been durably protected;
- gaps exist between expected and persisted event ranges.

The exact reconciliation mechanism may vary according to batching and storage organization, but silent divergence between Kafka progress and Bronze durability is not acceptable.

### 7.18 Bronze Persistence Guarantees

At the Bronze persistence boundary, the architecture requires the following guarantees:

- consumed events are not acknowledged as safely processed before required Bronze durability is achieved;
- incomplete writes do not become visible as valid final Bronze data;
- final publication follows an atomic-promotion pattern;
- required business payload and technical metadata remain historically preserved;
- legitimate source changes remain append-only;
- repeated delivery is tolerated through idempotent processing;
- Kafka offsets are committed only after the protected persistence work succeeds;
- failure before offset commit may result in safe redelivery;
- batching does not weaken the durability-before-acknowledgement guarantee;
- Bronze remains replayable for the required retention period;
- replay preserves original event context;
- Kafka-to-Bronze progress remains observable and reconcilable.

These guarantees establish Bronze as the durable historical foundation from which standardized downstream processing can proceed.

---

## 8. Silver Processing, Standardization, and Deduplication

The **Silver layer** transforms immutable Bronze history into standardized, typed, normalized, deduplicated, and reusable analytical data.

Bronze preserves the historical representation of source events. Silver interprets those events according to their applicable contracts and processing rules, resolves supported structural differences, applies technical standardization, and produces a consistent foundation for downstream Gold processing.

Silver must remain reconstructable from the required Bronze history and must support controlled reprocessing when transformation logic, contract handling, or data-quality requirements evolve.

The fundamental processing model is:

**Bronze History → Contract Interpretation → Validation → Typing and Standardization → Deduplication → Normalization → Silver Publication**

Silver processing must be deterministic and idempotent for the same input history, processing rules, and processing version.

### 8.1 Silver Processing Boundary

Silver processing begins with valid historical data persisted in Bronze.

The Silver boundary is complete when the applicable Bronze input has been successfully interpreted, standardized, deduplicated, normalized, validated, and published according to the Silver processing contract.

Successful Bronze persistence does not imply successful Silver processing.

Similarly, successful Silver processing does not imply that business-oriented dimensional modeling, reconciliation, certification, or analytical publication has occurred.

Silver therefore represents a technical analytical transformation boundary between preserved historical events and business-oriented Gold structures.

### 8.2 Bronze as the Historical Input

Bronze is the authoritative historical input for normal Silver reconstruction.

Silver processing must preserve sufficient lineage to identify the Bronze data from which each Silver result was derived.

Depending on the processing strategy, lineage may reference information such as:

- source system;
- event family;
- Bronze object or object set;
- event identity;
- source position;
- event-contract version;
- processing execution;
- processing version.

Silver must not require destructive modification of Bronze history in order to correct downstream transformation logic.

When Silver logic changes, the affected Silver data should be rebuilt or reprocessed from preserved Bronze history where the required source history remains available.

### 8.3 Contract-Aware Interpretation

Bronze may contain events produced under multiple supported contract versions.

Silver processing must interpret each historical event according to the contract version that applies to that event.

The processing logic must not assume that all Bronze history conforms to the newest event contract.

Where multiple historical contract versions represent compatible forms of the same logical information, Silver may normalize them into a common standardized representation.

Conceptually:

**Contract V1 ─┐**

**Contract V2 ─┼→ Silver Standard Representation**

**Contract V3 ─┘**

This normalization must preserve semantic correctness.

If an older contract cannot be safely mapped to the current Silver representation, the platform must use an explicit migration rule, retain an appropriate versioned representation, or prevent unsafe processing rather than silently inventing missing semantics.

### 8.4 Type Enforcement

Silver introduces explicit analytical typing.

Values originating from event payloads must be interpreted and converted according to the applicable Silver data contract and transformation rules.

Type enforcement may include, as applicable:

- numeric types;
- decimal precision and scale;
- dates;
- timestamps;
- Boolean representations;
- identifiers;
- controlled textual values;
- nullability;
- logical types.

Type conversion failures must not be silently coerced into apparently valid values.

Invalid or incompatible values must follow the applicable quality, quarantine, rejection, or remediation behavior defined for the dataset.

Type enforcement must remain deterministic and testable.

### 8.5 Standardization

Silver standardizes technically equivalent representations into consistent analytical forms.

Standardization may include, as applicable:

- consistent naming;
- consistent date and timestamp representation;
- normalized Boolean values;
- controlled representation of nulls;
- consistent decimal precision;
- canonical textual representation;
- controlled code representation;
- standardized technical metadata;
- consistent handling of supported contract versions.

Standardization must not silently change business meaning.

A technical representation may be normalized only when the resulting value remains semantically equivalent to the source information or follows an explicitly documented analytical rule.

### 8.6 Normalization

Silver may normalize source or event representations to improve downstream reuse and consistency.

Normalization may include:

- resolving equivalent structural representations;
- separating technical metadata from analytical attributes;
- aligning supported historical contract versions;
- deriving stable technical fields required by downstream processing;
- applying documented canonical representations.

Normalization in Silver is not dimensional modeling.

Fact and dimension design, surrogate-key assignment, conformed dimensions, and business-oriented analytical structures remain responsibilities of Gold.

### 8.7 Deduplication

Silver processing must prevent repeated delivery or repeated processing of the same logical event from creating incorrect duplicate analytical records.

Deduplication must distinguish between:

**Repeated delivery of the same event**

and:

**Different legitimate events affecting the same business entity**

For example:

**TRN_id = 100 / event_id = A → legitimate event**

**TRN_id = 100 / event_id = B → legitimate subsequent event**

**TRN_id = 100 / event_id = B again → repeated delivery candidate**

A business key alone is therefore insufficient to identify event-level duplication.

The deduplication strategy must use the event identity and any additional processing context required by the applicable dataset.

Deduplication must not remove legitimate historical changes merely because multiple events reference the same business entity.

### 8.8 Idempotent Silver Processing

Silver transformations must be idempotent.

Reprocessing the same Bronze input using the same processing rules and processing version must not produce an incorrect multiplication of Silver results or otherwise corrupt the standardized state.

Conceptually:

**Same Input + Same Processing Version → Same Logical Silver Result**

Idempotency may be implemented through deterministic transformation, controlled replacement of derived partitions or datasets, merge logic, processing-state metadata, or another mechanism validated during implementation.

The architecture defines the required behavior rather than prescribing a single implementation mechanism before laboratory validation.

### 8.9 Operation Semantics

Silver processing must preserve or correctly interpret the source-operation semantics required to reconstruct analytical state.

Insert, update, and delete events may require different processing behavior.

For example:

- an insert may introduce a new entity state;
- an update may replace or evolve an existing state;
- a delete may represent explicit removal or closure rather than simple absence.

The exact interpretation depends on the dataset and downstream analytical requirements.

Silver must not discard operation semantics before all downstream processing that depends on those semantics has been completed.

### 8.10 Current State and Historical Events

Bronze preserves event history.

Silver may expose standardized historical events, reconstructed current state, or both, depending on the downstream requirement.

These representations must remain conceptually distinct.

For example:

**Historical Event View**
→ preserves the standardized sequence of changes.

**Current-State View**
→ represents the latest applicable state derived from those changes.

A current-state representation must not erase the historical foundation from which it was derived.

The required Silver representations must be defined per dataset according to Gold reconstruction, replay, reconciliation, and analytical requirements.

### 8.11 Processing Version

Silver outputs must remain attributable to the transformation logic that produced them.

Where transformation behavior may evolve, the platform must preserve sufficient processing-version information to determine which logic was applied to a Silver result.

Processing version is distinct from event-contract version:

**Event Contract Version**
→ describes the structure used to interpret the input event.

**Processing Version**
→ identifies the transformation logic used to produce the Silver representation.

This distinction supports reproducibility, debugging, controlled reprocessing, and comparison between transformation versions.

### 8.12 Invalid Records and Quarantine

A record that cannot be processed safely must not be silently converted into apparently valid Silver data.

Depending on the failure type and dataset policy, invalid records may require:

- rejection;
- quarantine;
- retry;
- remediation;
- explicit exception handling.

The handling mechanism must preserve sufficient context to determine:

- which record failed;
- which Bronze input produced it;
- why processing failed;
- which contract version applied;
- which processing version was used;
- whether the failure is retryable;
- whether downstream processing is affected.

Quarantined or rejected data must remain observable and must not disappear from operational awareness.

### 8.13 Silver Publication

Silver output must be published only after the corresponding processing unit has completed the required transformation and validation controls.

Partially written or incomplete Silver output must not become visible as a valid completed dataset.

Where file-based Silver storage is used, publication must follow an atomic or equivalent controlled-promotion pattern appropriate to the storage technology.

The exact physical mechanism is an implementation concern and must be validated during the laboratory phase.

The architectural requirement is that downstream Gold processing must not interpret incomplete Silver output as successfully published data.

### 8.14 Incremental Processing

Normal Silver processing should process newly available Bronze data incrementally where appropriate.

Incremental processing must preserve:

- input boundaries;
- processing progress;
- idempotency;
- contract-version interpretation;
- deduplication behavior;
- lineage;
- retry capability.

The incremental strategy must not make full reconstruction impossible.

Silver must remain rebuildable from the required Bronze history when a controlled full reprocessing is necessary.

### 8.15 Reprocessing

Silver reprocessing may be required when:

- transformation logic changes;
- a defect is corrected;
- contract-version handling changes;
- historical standardization rules evolve;
- a quality issue requires remediation;
- downstream reconstruction requires a clean Silver rebuild.

Reprocessing must define the affected input range, processing version, output scope, validation criteria, and replacement or coexistence behavior.

Reprocessing must not overwrite unrelated valid Silver data or make historical input appear to have originated at the reprocessing time.

### 8.16 Backfill

A backfill introduces or reconstructs data for a historical range that is missing, newly required, or intentionally being added to the normal processing scope.

Backfill is related to, but distinct from, replay.

Conceptually:

**Replay**
→ process preserved historical input again.

**Backfill**
→ populate a required historical range that is absent or newly introduced into the target processing scope.

A backfill may use Bronze history, another approved recovery source, or a controlled source extraction depending on the reason for the historical gap and the available data.

Backfill execution must preserve traceability between the historical source period and the time at which the backfill was performed.

### 8.17 Silver Reconciliation

Silver processing must support reconciliation against its Bronze input.

The platform must be able to determine, according to the applicable dataset semantics:

- whether expected Bronze input was processed;
- whether repeated events were handled correctly;
- whether records were rejected or quarantined;
- whether operation semantics were preserved;
- whether output counts and control totals are plausible;
- whether processing gaps exist;
- which processing version produced the output.

Simple row-count equality is not universally sufficient because one Bronze event does not necessarily correspond to exactly one Silver record.

Reconciliation rules must reflect the transformation semantics of the dataset.

### 8.18 Silver Observability

Silver processing must expose sufficient information to understand processing health, data behavior, and recovery status.

Initial observability should include, as applicable:

- Bronze input volume;
- Silver output volume;
- processing duration;
- processing throughput;
- type-conversion failures;
- validation failures;
- duplicate events detected;
- records rejected;
- records quarantined;
- retries;
- processing-version information;
- contract versions processed;
- incremental-processing position;
- reprocessing status;
- backfill status;
- Silver publication failures;
- oldest unprocessed Bronze input;
- Bronze-to-Silver processing latency.

Observability must allow the platform to distinguish between a technically running process and a process that is producing complete and valid Silver data.

### 8.19 Silver Processing Guarantees

At the Silver processing boundary, the architecture requires the following guarantees:

- Silver remains reconstructable from the required Bronze history;
- historical contract versions are interpreted according to their applicable contracts;
- supported structural differences are normalized explicitly;
- typing and standardization are deterministic;
- technical normalization does not silently redefine business semantics;
- repeated delivery does not create incorrect duplicate analytical records;
- legitimate historical changes are not removed as duplicates;
- processing is idempotent for the same input and processing version;
- invalid records are handled explicitly rather than silently coerced;
- incomplete Silver output is not published as valid;
- incremental processing does not eliminate full reconstruction capability;
- replay, reprocessing, and backfill remain traceable;
- Silver-to-Bronze lineage remains available;
- processing health and data-quality failures remain observable and reconcilable.

These guarantees establish Silver as the standardized and reusable analytical foundation from which business-oriented Gold structures can be built.

---

## 9. Gold Dimensional Processing

The **Gold layer** transforms standardized Silver data into business-oriented analytical structures designed for governed analytical use.

In the V1 architecture, Gold is implemented in **AtlasWarehouse** using **SQL Server** and follows dimensional modeling principles based on the **Kimball methodology**.

Gold introduces analytical structures such as facts, dimensions, surrogate keys, conformed dimensions, historical dimension behavior, and business-oriented transformation rules.

Silver provides standardized and reusable analytical input. Gold applies the dimensional and business semantics required to transform that input into structures optimized for analytical interpretation and consumption.

The fundamental processing model is:

**Silver → Business Transformation → Dimension Processing → Fact Processing → Gold Validation → Gold Publication**

Successful Gold processing does not by itself certify data for official analytical consumption. Gold must still pass the required quality, reconciliation, and certification controls before publication through **Certified Gold**.

### 9.1 Gold Processing Boundary

Gold processing begins with valid and published Silver data.

The Gold processing boundary is complete when the applicable Silver input has been transformed into the required dimensional structures and the resulting Gold processing unit has successfully completed its transformation-level validation.

Gold is responsible for business-oriented analytical modeling.

It is not responsible for:

- preserving the original immutable event representation;
- replacing Bronze historical persistence;
- performing source change capture;
- transporting events;
- governing event-contract compatibility;
- granting certification merely because transformation completed successfully.

The distinction between Gold processing and Certified Gold publication must remain explicit.

### 9.2 Dimensional Model

Gold organizes analytical data into dimensional structures designed to support understandable, reusable, and efficient analytical queries.

The V1 dimensional model follows the general pattern:

**Dimensions → descriptive business context**

**Facts → measurable business events or processes**

For the initial **Daily Sales** product, the exact fact grain, dimensions, measures, and dimensional relationships must be derived from the approved AtlasCommerce business semantics and the analytical requirements defined during implementation.

The dimensional model must not introduce business definitions that contradict the operational source documentation.

### 9.3 Fact Grain

Every fact structure must have an explicitly defined grain.

The grain describes what one fact row represents.

For example, a sales fact could theoretically represent:

- one transaction;
- one transaction item;
- one product per transaction;
- one daily aggregation by product;
- another explicitly defined analytical event.

The architecture does not select a grain solely from convenience or expected report layout.

The grain must be defined from the analytical requirement and must remain consistent with the measures and dimensions associated with the fact.

Measures with incompatible grains must not be combined into the same fact structure without an explicit modeling justification.

### 9.4 Business and Natural Keys

Source business identifiers may be required to relate Silver data to Gold dimensions and facts.

These identifiers preserve the relationship between the analytical model and the operational business entity.

A source or business key is distinct from a Gold surrogate key.

Conceptually:

**Business / Natural Key**
→ identifies the business entity according to the applicable source or business semantics.

**Surrogate Key**
→ identifies a dimensional record within the analytical model.

Both may be required because they serve different purposes.

### 9.5 Surrogate Keys

Gold dimensions may use surrogate keys to provide stable analytical identifiers independent from source-system physical keys.

Surrogate keys support dimensional modeling requirements such as:

- historical dimension versions;
- source-key independence;
- conformed dimensions;
- fact-to-dimension relationships;
- controlled handling of changing descriptive attributes.

A surrogate key must not replace the ability to trace the dimension member back to the applicable business or source identifier.

Surrogate-key generation must be deterministic in behavior and safe under incremental processing, retries, reprocessing, and concurrent execution.

The exact generation mechanism is an implementation decision that must be validated against the selected SQL Server dimensional-loading strategy.

### 9.6 Dimension Processing

Dimension processing transforms standardized Silver entities into descriptive analytical structures.

Depending on the dimension, processing may include:

- identifying existing members;
- inserting new members;
- updating applicable attributes;
- creating historical versions;
- assigning surrogate keys;
- preserving business keys;
- managing effective periods;
- resolving unknown or unresolved references;
- enforcing conformed semantics.

The behavior of each dimension must be explicitly defined according to its analytical purpose.

Not every attribute change requires historical versioning, and not every dimension requires the same change-management strategy.

### 9.7 Slowly Changing Dimensions

Where historical analytical interpretation requires changes in descriptive attributes to be preserved, Gold may implement **Slowly Changing Dimension (SCD)** behavior.

The applicable SCD strategy must be selected according to the business meaning of the dimension and attribute.

For example:

**Type 1**
→ replace the previous analytical attribute value when historical preservation of that change is not required.

**Type 2**
→ create a new dimensional version when historical interpretation must preserve both the previous and new states.

The architecture does not require every dimension or every attribute to use Type 2 history.

Historical behavior must be defined deliberately at the applicable attribute or dimension level.

Where Type 2 behavior is used, processing must preserve the effective period and allow facts to resolve to the appropriate dimensional version according to the defined business and temporal rules.

### 9.8 Conformed Dimensions

Business entities shared across multiple analytical domains should use conformed dimensions when they require consistent analytical interpretation.

A conformed dimension provides a reusable dimensional definition that allows facts from different domains to be analyzed through a common business context.

For example, future domains may need to evaluate whether entities such as:

- customer;
- product;
- date;
- channel;
- location;

should use an existing conformed dimension.

Conformance must be based on semantic compatibility, not merely on similar names or source columns.

When a new domain requires additional legitimate dimensional attributes, the existing dimension must be evaluated for controlled evolution rather than automatically duplicated or modified without impact analysis.

### 9.9 Fact Processing

Fact processing transforms Silver business events or states into measurable analytical structures at the defined fact grain.

Fact processing may include:

- resolving dimension surrogate keys;
- deriving documented measures;
- applying business transformation rules;
- preserving required degenerate dimensions or business identifiers;
- handling unknown dimension references;
- enforcing fact grain;
- applying temporal relationships;
- maintaining lineage to Silver input.

Facts must not silently change grain between processing executions.

A measure must be calculated consistently according to its documented business definition.

### 9.10 Dimension Lookup and Unknown Members

Fact processing may encounter a business key for which the corresponding dimension member is not yet available or cannot be resolved.

The platform must define explicit behavior for unresolved dimensional references.

Depending on the applicable analytical model, the strategy may include:

- delaying fact processing;
- retrying dimension resolution;
- assigning a controlled unknown member;
- quarantining the affected fact;
- following another explicitly documented remediation path.

A missing dimension reference must not be silently converted into an arbitrary valid dimension member.

Where an unknown member is used, its meaning must be explicit and distinguishable from a legitimately known business entity.

### 9.11 Temporal Consistency

Gold processing must preserve the temporal relationships required by the analytical model.

Where historical dimensions are used, fact processing must resolve the dimensional version applicable to the defined business timestamp.

Conceptually:

**Business Event Time → Applicable Dimension Version**

The applicable timestamp must be defined according to the analytical semantics of the fact and must not be selected arbitrarily from whichever processing timestamp is most convenient.

Processing time and business-effective time must remain distinguishable.

### 9.12 Incremental Gold Processing

Normal Gold processing should consume newly available Silver data incrementally where appropriate.

Incremental processing must preserve:

- fact grain;
- dimensional consistency;
- surrogate-key stability;
- historical dimension behavior;
- idempotency;
- lineage;
- processing progress;
- retry capability.

Incremental loading must not make controlled full reconstruction impossible.

Gold must remain rebuildable from the required Silver foundation when a complete or partial reconstruction is necessary.

### 9.13 Idempotent Gold Processing

Gold processing must be idempotent.

Reprocessing the same Silver input under the same transformation and dimensional rules must not create duplicate facts, duplicate dimensional versions, or inconsistent surrogate-key relationships.

Conceptually:

**Same Silver Input + Same Processing Version → Same Logical Gold Result**

Idempotency must account for both:

- fact processing;
- dimension processing.

The implementation mechanism may differ between facts and dimensions, but the resulting analytical state must remain correct under retries and controlled reprocessing.

### 9.14 Gold Processing Version

Gold outputs must remain attributable to the transformation and dimensional-model logic that produced them.

Where Gold logic evolves, sufficient version information must be preserved to support:

- reproducibility;
- debugging;
- reprocessing;
- impact analysis;
- comparison between versions;
- certification evidence.

Gold processing version is distinct from both:

- event-contract version;
- Silver processing version.

These versions describe different stages of the end-to-end processing path and must not be treated as interchangeable.

### 9.15 Gold Reprocessing

Gold reprocessing may be required when:

- business transformation logic changes;
- dimensional logic changes;
- a defect is corrected;
- an SCD rule changes;
- a measure definition changes;
- a conformed dimension evolves;
- historical data requires remediation;
- certification identifies a defect requiring rebuild.

Reprocessing must define:

- affected Silver input;
- affected Gold structures;
- processing version;
- dimensional impact;
- fact impact;
- historical range;
- validation criteria;
- replacement or coexistence behavior;
- rollback requirements.

A change to shared dimensions must include impact analysis for every dependent fact or analytical product.

### 9.16 Gold Publication

Gold output must not become available as a completed processing unit until the corresponding dimensional transformation has successfully completed.

Partial fact or dimension processing must not be presented as a complete Gold result.

Where a processing cycle updates multiple related Gold structures, publication behavior must prevent downstream certification from evaluating an internally inconsistent combination of old and new processing states.

The exact publication mechanism depends on the AtlasWarehouse implementation and must be validated during the laboratory phase.

Gold publication indicates successful dimensional processing.

It does not indicate analytical certification.

### 9.17 Gold Reconciliation

Gold must support reconciliation against its Silver input and, where required, against the operational source through the preserved lineage path.

Reconciliation may include, according to the analytical semantics:

- transaction counts;
- item counts;
- quantities;
- monetary totals;
- dimensional member counts;
- unresolved dimension references;
- rejected records;
- historical-version consistency;
- source-to-target control totals.

Reconciliation must account for differences in grain.

A Silver event count and a Gold fact-row count are not required to be equal unless the transformation semantics explicitly establish a one-to-one relationship.

Reconciliation rules must therefore validate business completeness and consistency rather than rely only on physical row-count equality.

### 9.18 Gold Observability

Gold processing must expose sufficient information to understand dimensional-processing health and analytical completeness.

Initial observability should include, as applicable:

- Silver input volume;
- fact rows processed;
- dimension members inserted;
- dimension members updated;
- historical dimension versions created;
- unresolved dimension references;
- unknown-member assignments;
- rejected or quarantined records;
- processing duration;
- processing throughput;
- retries;
- processing version;
- incremental-processing position;
- reprocessing status;
- publication failures;
- Silver-to-Gold latency;
- reconciliation status.

Observability must allow the platform to distinguish between successful job execution and correct dimensional processing.

### 9.19 Gold Processing Guarantees

At the Gold processing boundary, the architecture requires the following guarantees:

- Gold structures follow explicitly defined analytical grains;
- dimensional modeling remains aligned with documented business semantics;
- business keys and surrogate keys remain conceptually distinct;
- surrogate-key relationships remain traceable to source business entities;
- dimensional history is applied only where analytically required;
- conformed dimensions are based on semantic compatibility;
- fact processing preserves the defined grain and measure semantics;
- unresolved dimensional references follow explicit handling rules;
- temporal relationships use the appropriate business-effective context;
- incremental processing remains idempotent and reconstructable;
- retries and reprocessing do not create duplicate facts or invalid dimensional versions;
- shared-dimensional changes include downstream impact analysis;
- incomplete Gold processing is not presented as a complete result;
- Gold remains reconcilable with its Silver foundation and applicable source controls;
- successful Gold processing does not imply certification.

These guarantees establish Gold as the business-oriented dimensional layer from which governed certification can proceed.

---

## 10. Quality Validation and Reconciliation

Data that has successfully completed technical processing is not automatically eligible for governed analytical consumption.

Before a Gold result can be promoted to **Certified Gold**, it must pass the quality and reconciliation controls defined for the corresponding analytical product.

Quality validation evaluates whether the resulting data satisfies explicit expectations regarding structure, completeness, validity, consistency, uniqueness, referential behavior, freshness, and business rules.

Reconciliation evaluates whether the analytical result remains consistent with the authoritative upstream data and with the transformations applied across the processing path.

These controls establish the validation boundary between successfully processed **Gold** data and publishable **Certified Gold** data.

The fundamental certification path is:

**Gold → Quality Validation → Reconciliation → Certification Decision → Certified Gold**

A failed critical control must prevent promotion of the affected candidate version while preserving the last known-good certified version for consumers.

### 10.1 Quality Validation Boundary

Quality validation begins after the candidate Gold processing unit has completed the transformations required for the analytical product.

Validation must evaluate the candidate version before that version becomes the governed analytical publication.

The validation boundary must distinguish between:

- successful transformation execution;
- successful data-quality validation;
- successful reconciliation;
- successful certification.

These states must not be collapsed into a single generic job-success status.

A Gold processing execution may therefore complete successfully while the resulting candidate version remains uncertified.

### 10.2 Data Quality Dimensions

Quality rules must be defined according to the characteristics and business requirements of each dataset.

Applicable quality dimensions may include:

**Completeness**  
Required data is present according to the applicable analytical rules.

**Validity**  
Values conform to expected domains, ranges, formats, types, and controlled rules.

**Consistency**  
Related values do not contradict one another across the applicable analytical structures.

**Uniqueness**  
Records that are required to be unique according to the defined grain or business rule do not contain invalid duplication.

**Referential Integrity**  
Required analytical relationships resolve according to the dimensional model and its explicit unknown-member or exception strategy.

**Timeliness / Freshness**  
Data is available within the applicable freshness expectations and SLO.

**Business-Rule Conformance**  
The resulting data satisfies documented business semantics and analytical rules.

Not every dataset requires identical rules or thresholds.

Quality controls must reflect the analytical purpose and criticality of the corresponding data product.

### 10.3 Structural Quality

Structural quality verifies that the candidate analytical data conforms to the expected technical structure.

Controls may include:

- required columns;
- expected data types;
- nullability rules;
- expected precision and scale;
- dimensional-key structure;
- expected grain;
- uniqueness constraints;
- required metadata;
- processing-version information.

Structural validation must not be treated as sufficient proof of business correctness.

A dataset may be structurally valid while containing incorrect business values.

### 10.4 Business Quality Rules

Business quality rules validate expectations derived from documented business semantics and analytical definitions.

Examples may include, depending on the product:

- quantities must follow the applicable business rules;
- monetary measures must use the documented calculation semantics;
- transaction status must be valid for the analytical context;
- required relationships between transaction and item data must remain consistent;
- excluded operational states must not contribute to measures that explicitly exclude them;
- dimensional classification must follow the approved business definitions.

Business rules used for certification must be documented and traceable to their corresponding analytical or source-business definitions.

Data Engineering must not invent undocumented source semantics merely to make a quality rule pass.

### 10.5 Critical and Non-Critical Controls

Quality controls must be classified according to their impact on certification.

A **critical control** represents a condition whose failure makes the candidate analytical version unsuitable for governed publication.

A **non-critical control** represents a condition that may require warning, investigation, or remediation but does not necessarily prevent certification according to the applicable product policy.

The classification must be explicit.

A validation framework must not silently decide that a failed rule is non-critical merely because allowing publication is operationally convenient.

For each governed control, documentation should define, as applicable:

- control purpose;
- validation logic;
- expected result;
- threshold;
- severity;
- certification impact;
- ownership;
- remediation expectation.

### 10.6 Threshold-Based Controls

Not every quality control requires an absolute zero-error condition.

Some controls may use explicitly approved thresholds.

For example, a product could define a tolerance for a specific non-critical condition when the business impact is understood and accepted.

Thresholds must be:

- explicit;
- measurable;
- justified;
- versioned where necessary;
- observable;
- associated with a defined certification consequence.

A threshold must not be introduced after a failure merely to make the current execution pass.

Changes to certification thresholds are governed changes and require documented justification.

### 10.7 Source-to-Target Reconciliation

Reconciliation validates whether downstream analytical results remain consistent with the authoritative upstream information from which they were derived.

Depending on the transformation and grain, reconciliation may compare measures such as:

- transaction counts;
- transaction-item counts;
- quantities;
- gross amounts;
- discounts;
- net amounts;
- status distributions;
- date ranges;
- business-key coverage;
- control totals.

The appropriate reconciliation measure depends on the semantics of the transformation.

Physical row counts must not be assumed to match across layers when their grains differ.

For example:

**AtlasCommerce transaction items → Silver standardized events → Gold dimensional facts**

may involve different physical record counts while still preserving equivalent business totals.

Reconciliation must therefore validate meaningful business equivalence rather than require arbitrary one-to-one row correspondence.

### 10.8 Cross-Layer Reconciliation

Where required, reconciliation should allow the platform to trace and compare data across multiple processing boundaries.

Conceptually:

**AtlasCommerce → Bronze → Silver → Gold**

The platform should be able to investigate where an observed discrepancy was introduced.

For example:

**Source correct / Bronze incorrect**
→ investigate capture or persistence.

**Bronze correct / Silver incorrect**
→ investigate standardization, deduplication, or transformation.

**Silver correct / Gold incorrect**
→ investigate dimensional or business transformation.

This layered reconciliation approach reduces the diagnostic scope of data-quality incidents.

### 10.9 Reconciliation Windows

Reconciliation must compare equivalent processing and business windows.

Comparing a complete source day with a partially processed Gold day may produce an apparent discrepancy that reflects timing rather than data loss.

The reconciliation process must therefore define:

- source boundary;
- downstream processing boundary;
- applicable business period;
- late-arriving-data behavior;
- cutoff rules;
- timezone rules;
- completion criteria.

Window definitions must be deterministic and reproducible.

### 10.10 Late-Arriving Data

Data may legitimately arrive after the normal processing window because of upstream delay, recovery, backlog, replay, or business-process timing.

The platform must distinguish late-arriving valid data from missing data.

The applicable analytical product must define how late-arriving data affects:

- Gold processing;
- reconciliation;
- certification;
- previously published periods;
- reprocessing;
- analytical freshness.

Late arrival must not be silently discarded merely because a previous processing window has already completed.

Where late-arriving data changes a previously certified result, the affected analytical period must follow the applicable controlled reprocessing and recertification procedure.

### 10.11 Quality Failure Handling

When a quality or reconciliation control fails, the platform must preserve sufficient evidence to determine:

- which candidate version failed;
- which rule failed;
- observed result;
- expected result or threshold;
- affected data scope;
- processing version;
- source or upstream scope;
- failure timestamp;
- certification impact.

Critical failures must block promotion of the affected candidate version.

The failed candidate must remain distinguishable from the last known-good certified version.

Failure handling may include:

- investigation;
- quarantine;
- remediation;
- controlled reprocessing;
- replay;
- backfill;
- rejection of the candidate version.

A failed certification attempt must not require destructive modification of the previously certified version.

### 10.12 Last Known-Good Version

The platform must preserve the last successfully certified analytical version while a new candidate is being processed and validated.

Conceptually:

**Certified Version N → remains available**

while:

**Candidate Version N+1 → processing and validation**

If Candidate Version N+1 fails a critical control:

**Certified Version N → remains published**

**Candidate Version N+1 → not promoted**

This prevents a failed refresh from automatically replacing known-good analytical data with a known-bad candidate.

The published version may become stale during a prolonged failure, and that freshness degradation must remain observable.

Stale-but-certified data and current-but-uncertified data represent different operational states and must not be confused.

### 10.13 Certification Decision

Certification is an explicit governed decision based on the successful completion of the required controls.

A candidate Gold version may be certified only when:

- required Gold processing completed successfully;
- critical quality controls passed;
- required reconciliation controls passed;
- required metadata is available;
- applicable certification criteria are satisfied.

Certification must produce an auditable result identifying, as applicable:

- dataset or data product;
- candidate version;
- certification status;
- validation execution;
- control results;
- certification timestamp;
- processing version;
- applicable quality-rule version.

Certification is therefore a processing state with evidence, not merely a descriptive label attached to a table.

### 10.14 Atomic Certified Publication

After successful certification, the approved candidate version must be promoted so that consumers observe a complete certified state.

Consumers must not observe a partially published combination of old and new certified structures.

Conceptually:

**Build Candidate → Validate → Reconcile → Certify → Atomic Publish**

The exact publication mechanism depends on the serving implementation and must be validated during the laboratory phase.

The architecture requires the behavior:

**Consumers see either the previous certified version or the newly certified complete version, not an incomplete intermediate state.**

The timestamp at which the new certified version becomes available is represented architecturally as `certified_gold_publish_ts`.

### 10.15 End-to-End Freshness

Certification and publication are part of the end-to-end freshness path.

The V1 freshness measurement remains:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

This means that successful Gold transformation does not stop the freshness clock.

Time spent performing quality validation, reconciliation, certification, and publication contributes to the analytical freshness experienced by governed consumers.

The platform must therefore measure these stages rather than treat certification as operationally invisible overhead.

### 10.16 Quality and Reconciliation Observability

Quality and reconciliation must expose both current status and historical execution evidence.

Initial observability should include, as applicable:

- quality controls executed;
- controls passed;
- controls failed;
- critical failures;
- non-critical warnings;
- reconciliation results;
- reconciliation differences;
- thresholds applied;
- candidate version;
- certified version;
- rejected candidate versions;
- certification status;
- validation duration;
- reconciliation duration;
- certification duration;
- publication duration;
- last successful certification timestamp;
- age of the currently published certified version.

Monitoring must make it possible to distinguish:

**pipeline healthy**

from:

**data certified and current**.

### 10.17 Quality Rule Evolution

Quality and reconciliation rules may evolve as analytical products mature.

Rule changes must be controlled because they can alter whether the same data is considered certifiable.

Changes may include:

- new controls;
- removed controls;
- threshold changes;
- severity changes;
- business-rule changes;
- reconciliation changes.

Rule evolution must preserve sufficient versioning to determine which validation criteria were applied to a certified version.

A previously certified historical version must not be retrospectively represented as though it had passed a quality rule that did not exist when that version was certified.

Where new rules require historical re-evaluation, that activity must be represented as an explicit validation or recertification process.

### 10.18 Quality and Reconciliation Guarantees

At the quality and reconciliation boundary, the architecture requires the following guarantees:

- successful technical processing does not automatically imply analytical certification;
- governed Gold candidates are validated before Certified Gold publication;
- quality controls reflect explicit technical and business expectations;
- critical and non-critical controls remain distinguishable;
- thresholds are explicit and governed;
- reconciliation compares semantically equivalent data rather than arbitrary physical row counts;
- reconciliation windows are deterministic and reproducible;
- late-arriving data follows explicit processing and recertification behavior;
- failed critical controls block candidate promotion;
- the last known-good certified version remains available during failed refreshes;
- certification produces auditable evidence;
- Certified Gold publication is atomic from the consumer perspective;
- certification and publication latency contribute to the end-to-end SLO;
- quality-rule evolution remains versioned and traceable.

These guarantees establish the validation boundary between processed analytical data and governed analytical data authorized for consumption.

---

## 11. Certified Gold Publication and Analytical Consumption

**Certified Gold** is the governed publication boundary of the Data Engineering platform.

A Gold candidate becomes eligible for Certified Gold only after completing the required processing, quality validation, reconciliation, and certification controls.

Certified Gold represents the analytical state that the platform explicitly authorizes for governed consumption.

The fundamental publication path is:

**Gold Candidate → Quality Validation → Reconciliation → Certification → Atomic Publication → Certified Gold → Analytical Consumption**

Analytical consumers must use the certified publication boundary rather than depending directly on intermediate processing states when governed data is required.

In the V1 architecture, **Power BI** consumes the certified analytical structures published through **Certified Gold**.

### 11.1 Certified Gold Boundary

Certified Gold separates successfully processed analytical data from analytical data explicitly approved for governed consumption.

The distinction is:

**Gold**
→ business-oriented analytical data that has completed dimensional processing.

**Certified Gold**
→ Gold data that has additionally passed the required quality, reconciliation, certification, and publication controls.

A Gold candidate must not become visible through the governed Certified Gold interface merely because its transformation job completed successfully.

Certification status must remain explicit and auditable.

### 11.2 Candidate and Published Versions

The platform must distinguish between the version currently available to governed consumers and a new version being prepared for publication.

Conceptually:

**Certified Version N**
→ current governed publication.

**Candidate Version N+1**
→ new analytical version being processed and validated.

While Candidate Version N+1 is under evaluation, Certified Version N remains available to consumers.

The candidate must not partially replace the certified version during processing or validation.

### 11.3 Successful Publication

When the candidate version successfully completes all required certification controls, it becomes eligible for publication.

The publication sequence is:

**Candidate Complete → Quality Passed → Reconciliation Passed → Certification Approved → Publish**

Publication must expose the newly certified state as a complete analytical version.

After successful publication:

**Certified Version N+1**
→ becomes the current governed version.

The previously certified version may remain available according to the applicable retention, rollback, audit, or recovery policy.

### 11.4 Failed Candidate Publication

If a candidate version fails a critical quality, reconciliation, or certification control, it must not replace the current certified version.

Conceptually:

**Certified Version N → remains available**

**Candidate Version N+1 → certification failed → not published**

The failed candidate and its validation evidence must remain identifiable for investigation and remediation.

A failed refresh may cause the current certified version to become older than the desired freshness objective.

This condition must be observable.

The platform must distinguish between:

**Certified and Current**

**Certified but Stale**

**Candidate but Uncertified**

These states have different operational meanings and must not be represented as equivalent.

### 11.5 Atomic Publication

Certified publication must prevent consumers from observing a partially updated analytical state.

Where multiple structures participate in the same governed analytical product, consumers must not observe an inconsistent combination such as:

- new fact data with old required dimensions;
- partially refreshed partitions;
- incomplete aggregation results;
- a mixture of candidate and previously certified structures.

The architectural requirement is:

**Consumers observe either the previous complete certified version or the new complete certified version.**

The exact physical mechanism used to achieve atomic publication depends on the serving implementation and must be validated during the laboratory phase.

Possible implementation mechanisms must be evaluated according to their ability to provide the required consumer-visible publication semantics rather than selected solely from convenience.

### 11.6 Publication Timestamp

The timestamp at which a successfully certified version becomes available for governed consumption is represented as:

`certified_gold_publish_ts`

This timestamp marks the endpoint of the V1 end-to-end analytical freshness measurement:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

The timestamp must represent actual publication availability rather than merely:

- Gold processing completion;
- quality-validation completion;
- certification-decision time;
- beginning of publication.

This distinction ensures that the freshness measurement reflects when governed consumers could actually access the certified result.

### 11.7 Analytical Consumption Contract

A governed analytical product must expose a defined consumption contract.

The contract should identify, as applicable:

- product name;
- business purpose;
- analytical grain;
- dimensions;
- measures;
- business definitions;
- freshness expectation;
- certification status;
- ownership;
- sensitivity classification;
- access expectations;
- applicable quality guarantees.

The analytical consumption contract is distinct from the event contract used in the Kafka integration path.

Conceptually:

**Event Contract**
→ governs the structure exchanged between event producers and event consumers.

**Analytical Consumption Contract**
→ governs the meaning and expectations of the published analytical product.

Both are contracts, but they operate at different architectural boundaries.

### 11.8 Power BI Consumption

In V1, **Power BI** is the primary analytical consumer of Certified Gold.

Power BI must consume governed analytical structures exposed through the certified publication boundary rather than depend directly on:

- Kafka topics;
- Bronze objects;
- Silver datasets;
- uncertified Gold candidates.

This preserves the separation between processing layers and governed consumption.

The Power BI semantic model may introduce presentation-oriented calculations and relationships where appropriate, but business definitions that determine certified analytical meaning must remain governed and documented rather than existing only inside a report.

The dashboard must therefore be treated as a consumer of the governed analytical product, not as the location where missing upstream data semantics are silently invented.

### 11.9 Consumer Isolation from Processing

Analytical consumers should not require knowledge of the internal processing state of Bronze, Silver, or candidate Gold executions in order to query the current certified product.

Processing and consumption must remain decoupled.

For example, while a new candidate is being built:

**Power BI → Certified Version N**

while:

**Data Engineering → Candidate Version N+1**

Only after successful certification and publication does the consumer-visible state change.

This isolation prevents normal analytical queries from observing incomplete processing work.

### 11.10 Publication Failure

A failure may occur after certification controls succeed but before the new version becomes successfully available to consumers.

Certification success and publication success must therefore remain distinguishable.

Conceptually:

**Validation Passed → Certification Approved → Publication Failure**

In this scenario:

- the previous certified publication must remain available where technically possible;
- the new candidate must not be represented as successfully published;
- publication failure must be observable;
- retry behavior must preserve publication correctness;
- `certified_gold_publish_ts` must not be recorded as successful until publication actually completes.

A candidate is not the current Certified Gold version until the governed publication boundary has been successfully updated.

### 11.11 Rollback

The publication strategy must support controlled rollback when a newly published version is later determined to require withdrawal.

Rollback must identify:

- the currently published version;
- the previous eligible certified version;
- the reason for rollback;
- the affected product;
- rollback timestamp;
- validation status;
- required downstream refresh behavior.

Rollback must not silently rewrite certification history.

If a version was certified and published and is later withdrawn, the historical record must preserve that sequence of events.

Rollback capability must be validated during implementation rather than assumed from version retention alone.

### 11.12 Consumer Freshness

Consumers must be able to determine the freshness of the certified data they are using.

A successful query does not prove that the returned data satisfies the expected freshness objective.

The platform must therefore expose or make derivable information such as:

- current certified version;
- certification timestamp;
- `certified_gold_publish_ts`;
- latest applicable source period;
- freshness status;
- SLO compliance where applicable.

This allows the platform to distinguish:

**available data**

from:

**available and sufficiently current data**.

### 11.13 Consumer Behavior During Staleness

If the last known-good certified version remains available while new candidates fail certification or publication, consumers may continue to query that version.

The product policy must define how prolonged staleness is communicated.

Depending on the analytical use case, this may include:

- freshness indicators;
- warnings;
- monitoring alerts;
- dashboard status information;
- temporary consumption restrictions for critical products.

The architecture does not require stale certified data to be silently removed merely because the freshness SLO has been missed.

Availability, certification, and freshness are separate characteristics and must remain observable independently.

### 11.14 Access Control

Certified Gold must be exposed only to authorized consumers according to the applicable security and governance policies.

Access controls should operate at the appropriate serving boundary and follow least-privilege principles.

The fact that data has passed quality certification does not imply that every consumer is authorized to access it.

Publication must therefore preserve both:

- analytical certification;
- access governance.

Sensitive or restricted analytical attributes must remain protected according to their classification and authorized usage.

### 11.15 Certified Product Metadata

Certified analytical products must expose sufficient metadata to support discovery, interpretation, governance, and operational understanding.

Metadata should include, as applicable:

- product name;
- description;
- owner;
- current version;
- certification status;
- publication timestamp;
- processing version;
- quality-rule version;
- source domains;
- lineage reference;
- grain;
- measures;
- dimensions;
- freshness expectation;
- sensitivity classification;
- documentation reference.

Metadata must allow a consumer or operator to understand what is being consumed without requiring inspection of internal processing code.

### 11.16 Publication Observability

Certified Gold publication and analytical consumption must expose sufficient information to determine whether the governed product is available, current, and successfully consumed.

Initial observability should include, as applicable:

- candidate version;
- current certified version;
- certification result;
- publication status;
- publication failures;
- publication retries;
- publication duration;
- `certified_gold_publish_ts`;
- age of certified data;
- freshness SLO status;
- rollback events;
- consumer availability;
- Power BI refresh status where integrated;
- access failures.

Observability must distinguish between:

**Gold processing success**

**Certification success**

**Publication success**

**Consumer availability**

These are related but distinct operational states.

### 11.17 Analytical Consumption Guarantees

At the Certified Gold and analytical-consumption boundary, the architecture requires the following guarantees:

- governed consumers access certified analytical data rather than intermediate processing states;
- candidate and published versions remain distinct;
- failed candidates do not replace the last known-good certified version;
- publication is atomic from the consumer perspective;
- `certified_gold_publish_ts` represents actual governed availability;
- analytical consumption contracts remain distinct from event contracts;
- Power BI consumes the governed publication boundary;
- internal processing remains isolated from normal analytical consumption;
- certification success does not imply publication success;
- rollback remains controlled and auditable;
- consumers can determine certified-data freshness;
- stale certified data remains distinguishable from current certified data;
- certification does not bypass access-control requirements;
- certified-product metadata supports interpretation and governance;
- publication and consumer availability remain observable.

These guarantees complete the normal end-to-end processing path from committed operational change to governed analytical consumption.

---

## 12. Failure Handling, Replay, and Recovery

Failures are expected operating conditions in a distributed Data Engineering platform and must be handled through explicit, observable, and testable recovery behavior.

The architecture must not depend on every component remaining continuously available in order to preserve processing correctness.

A failure may delay analytical freshness, create backlog, require retry, trigger replay, or require controlled reconstruction. It must not silently cause eligible data to disappear, duplicate logically, become incorrectly reordered, or replace a known-good certified analytical version.

Recovery is based on the principle that processing should resume from the safest available durable state rather than automatically restart the entire end-to-end pipeline.

The V1 recovery hierarchy is:

**Kafka → Bronze → Silver → Backup**

The appropriate recovery source depends on the failure location, retained history, processing state, and reconstruction requirement.

### 12.1 Failure Domains

Failures may occur at different architectural boundaries and must be diagnosed according to the stage they affect.

Relevant failure domains include:

- source change capture;
- Debezium event production;
- schema or contract handling;
- Kafka transport;
- consumer processing;
- Bronze persistence;
- Silver transformation;
- Gold dimensional processing;
- quality validation;
- reconciliation;
- certification;
- Certified Gold publication;
- analytical consumption;
- orchestration;
- infrastructure dependencies.

A failure in one domain must not automatically be interpreted as failure of every downstream or upstream component.

The platform must preserve sufficient state and observability to identify the affected processing boundary.

### 12.2 Failure Classification

Failures should be classified according to whether normal retry can reasonably resolve them.

Conceptually, failures may be:

**Transient**
→ temporary conditions that may succeed when retried.

Examples may include temporary network interruption, temporary service unavailability, or short-lived resource contention.

**Persistent**
→ conditions that continue until configuration, code, infrastructure, or data is corrected.

Examples may include incompatible contracts, invalid transformation logic, unavailable required history, or persistent storage failure.

**Data-Related**
→ conditions caused by input that cannot safely satisfy the applicable processing or quality rules.

Examples may include invalid types, unresolved required relationships, or values outside governed business rules.

**Recovery-Critical**
→ conditions in which normal incremental continuation is no longer sufficient to guarantee completeness or correctness.

Examples may include required Kafka or CDC history no longer being available.

Classification determines the appropriate retry, quarantine, replay, rebuild, escalation, or remediation behavior.

### 12.3 Retry

Retry is appropriate when the same processing operation can be attempted again safely and the failure is expected to be temporary.

Retry behavior must preserve idempotency.

A retry must not create incorrect duplicate output merely because the same processing unit is executed more than once.

Retry policies should define, as applicable:

- retryable failure types;
- maximum attempts;
- delay or backoff behavior;
- escalation criteria;
- observability requirements;
- final failure state.

Infinite silent retry is not an acceptable recovery strategy.

A component that continuously retries without making progress must remain operationally visible.

### 12.4 Processing Checkpoints

Recovery requires knowledge of the last safely completed processing state.

Different stages use different forms of processing position or durable state.

Examples include:

- source LSN;
- Kafka partition and committed offset;
- persisted Bronze objects;
- Silver processing boundaries;
- Gold processing versions;
- candidate and certified publication versions.

A checkpoint is meaningful only when the work protected by that checkpoint has satisfied its required durability guarantee.

For example:

**Kafka offset committed**
must imply that the corresponding protected Bronze persistence has already succeeded.

Recovery must not advance from a checkpoint whose protected work is incomplete.

### 12.5 Recovery from Kafka

Kafka is the preferred recovery source when the required events remain available within retention and the consumer can safely resume from the applicable committed offsets.

This is the normal recovery path for temporary consumer disruption.

Conceptually:

**Consumer Failure → Restart → Resume from Committed Offset → Redelivery if Required → Continue Processing**

At-least-once delivery means that some events may be delivered again after recovery.

Downstream idempotency must make this safe.

Kafka recovery must verify:

- required offsets remain available;
- partition assignments are valid;
- consumer-group state is understood;
- redelivery is handled correctly;
- backlog is observable;
- ordering guarantees remain preserved;
- catch-up capacity is sufficient.

### 12.6 Recovery from Bronze

When the required Kafka history is no longer available, or when downstream layers require reconstruction independent of Kafka transport, Bronze becomes the primary durable historical recovery source.

Examples include:

- rebuilding Silver after transformation changes;
- reconstructing Silver after corruption or loss;
- rebuilding Gold from standardized history;
- reprocessing historical events beyond Kafka retention;
- applying corrected downstream logic.

Bronze replay must preserve:

- original event identity;
- original source timestamps;
- original source-position metadata where retained;
- original contract version;
- distinction between original ingestion and replay execution;
- lineage to the replay execution and processing version.

Recovery from Bronze must not make replayed events appear to be newly originated source changes.

### 12.7 Recovery from Silver

Silver may be used as a recovery source when Bronze reconstruction is unnecessary and the required standardized data remains valid for the recovery objective.

Examples may include:

- rebuilding Gold after dimensional logic changes;
- reconstructing Gold after AtlasWarehouse loss;
- rerunning quality and reconciliation against unchanged Silver data;
- regenerating an analytical product from an already validated standardized foundation.

Silver recovery is appropriate only when the required transformation change does not invalidate the Silver representation itself.

If Silver logic or contract interpretation is part of the defect, recovery must begin from Bronze or another earlier valid source.

### 12.8 Recovery from Backup

Backup is the final recovery source in the V1 hierarchy when the required online processing history is unavailable, corrupted, or insufficient for the recovery objective.

Backup recovery may apply to platform state, analytical structures, metadata, or historical data according to the implemented backup strategy.

Recovery from backup must not be treated as automatically equivalent to restoring the complete current platform state.

After restoration, the platform may still need to:

- identify the restored recovery point;
- determine the data gap after that point;
- replay retained events;
- reprocess downstream layers;
- reconcile restored and newly processed data;
- recertify affected analytical products.

Backup therefore provides a recovery foundation, not necessarily the final recovered analytical state.

### 12.9 Recovery Source Selection

The recovery process should begin from the latest trustworthy durable state that can satisfy the required reconstruction objective.

Conceptually:

**Can Kafka safely provide the required history?**
→ recover from Kafka.

**If not, can Bronze provide the required history?**
→ recover from Bronze.

**If Bronze reconstruction is unnecessary and Silver is valid for the objective**
→ recover from Silver.

**If required online history is unavailable**
→ recover from Backup.

The recovery source must not be selected solely because it is the easiest operational option.

It must provide the information required to restore correctness and completeness.

### 12.10 Replay

Replay means intentionally re-consuming previously retained events from an earlier processing position.

Replay is primarily associated with retained event history, such as Kafka, and defines how historical events are delivered again for downstream processing.

The processing of replayed events through downstream transformation logic may additionally constitute reprocessing according to the recovery objective.

Replay may be required for:

- recovery;
- defect correction;
- transformation changes;
- historical reconstruction;
- quality-rule re-evaluation;
- analytical-product rebuild.

Replay must define:

- source of replay;
- historical range;
- affected event families or datasets;
- target processing stages;
- processing version;
- expected output;
- validation criteria;
- impact on currently published data.

Replay must remain distinguishable from normal incremental processing.

### 12.11 Replay Safety

Replay must not corrupt valid existing state.

The replay mechanism must account for:

- idempotency;
- deduplication;
- processing versions;
- output replacement or coexistence;
- dimensional history;
- surrogate-key stability;
- fact duplication;
- certification state;
- publication boundaries.

A replay must not automatically publish its results merely because processing completed.

Where replay affects governed analytical products, the resulting candidate must pass the applicable quality, reconciliation, certification, and publication controls.

### 12.12 Reprocessing

Reprocessing means intentionally executing processing logic again for a defined historical input scope.

Reprocessing may use the same processing version or a different processing version depending on the recovery, correction, or reconstruction objective.

Examples include:

- processing a historical Bronze scope again through Silver logic;
- processing historical Silver data again after a transformation defect is corrected;
- recalculating Gold after a dimensional-model correction;
- recalculating a measure after a governed business-rule change;
- regenerating downstream state from a trusted historical processing boundary.

Reprocessing is distinct from retry.

**Retry**
→ repeats an operation because the previous attempt failed or produced an uncertain outcome.

**Reprocessing**
→ intentionally revisits a historical input scope through processing logic.

Reprocessing is also distinct from rebuild.

**Reprocessing**
→ describes the repeated execution of processing logic.

**Rebuild**
→ describes the reconstruction of a derived state.

A rebuild may use reprocessing as part of its implementation.

Reprocessing must define:

- input scope;
- processing boundary;
- processing version;
- expected resulting state;
- idempotency requirements;
- validation criteria;
- certification impact where applicable;
- lineage to the reprocessing execution.

### 12.13 Backfill

Backfill populates a historical range that is missing or newly required in the target processing scope.

Backfill may be necessary when:

- a new source structure is onboarded;
- a new domain is incorporated;
- historical data predating normal CDC ingestion is required;
- a previously unavailable historical range becomes recoverable;
- a new analytical product requires older source history.

Backfill must define:

- historical source;
- source period;
- extraction or replay method;
- contract or mapping rules;
- processing version;
- target layers;
- reconciliation criteria;
- certification impact.

Backfilled data must remain distinguishable operationally from newly arriving incremental data while preserving the original business-effective timestamps.

### 12.14 Rebuild

A rebuild reconstructs an entire dataset, layer, product, or defined historical scope from an earlier trusted foundation.

Examples include:

**Bronze → rebuild Silver**

**Silver → rebuild Gold**

**Bronze → rebuild Silver → rebuild Gold**

A rebuild may be required when incremental state can no longer be trusted or when a change affects a sufficiently broad historical range.

Rebuild procedures must define:

- trusted source;
- affected scope;
- processing versions;
- temporary output location;
- validation criteria;
- reconciliation criteria;
- publication behavior;
- rollback plan.

Existing certified output should remain protected until the rebuilt candidate has completed the required certification process.

### 12.15 Recovery and Contract Versions

Historical recovery may encounter multiple event-contract versions.

Replay and rebuild must interpret each historical event according to the contract that applied when the event was produced.

A recovery process must not assume that historical Bronze data conforms to the latest contract version.

If a required historical contract is no longer directly supported, an explicit migration or normalization path must exist.

Removing support for an old contract version must therefore consider the platform's recovery and reconstruction requirements.

### 12.16 Recovery and Processing Versions

Recovery may also involve multiple processing versions.

The platform must preserve the distinction between:

- the version that originally produced an output;
- the version used during recovery or rebuild.

For example:

**Original Silver Processing V1**

may later be reconstructed using:

**Silver Processing V2**

The resulting output must remain attributable to V2 rather than being represented as though it were produced by the historical V1 logic.

This distinction supports reproducibility and auditability.

### 12.17 Recovery and Certified Gold

Recovery activity must not bypass the Certified Gold boundary.

If recovery, replay, backfill, or rebuild changes a governed analytical product, the resulting output is a new candidate until it successfully completes the required controls.

Conceptually:

**Recovery Output → Candidate Gold → Quality → Reconciliation → Certification → Publication**

The currently certified version should remain available while the recovered candidate is being validated where technically possible.

Recovery success therefore does not automatically imply publication success.

### 12.18 Backlog Recovery

After a disruption, normal event arrival may continue while accumulated backlog is being processed.

The platform must verify that recovered processing capacity is sufficient to reduce backlog while also handling new arrivals.

Conceptually:

**Backlog Recovery Rate = Processing Rate - Incoming Rate**

For backlog to decrease:

**Processing Rate > Incoming Rate**

Recovery testing must measure not only whether processing restarted but whether the platform returned to the expected freshness state.

Relevant measurements include:

- backlog at recovery start;
- incoming rate;
- processing rate;
- oldest pending event;
- backlog reduction rate;
- recovery duration;
- resource utilization;
- end-to-end latency during recovery;
- time required to return within SLO.

### 12.19 Recovery Point and Recovery Time

Recovery must be evaluated using explicit recovery objectives.

The platform should measure, where applicable:

**Recovery Point**
→ how much processing or data state may need to be reconstructed after failure.

**Recovery Time**
→ how long the platform requires to restore the required processing or analytical capability.

These concepts may be formalized as **Recovery Point Objective (RPO)** and **Recovery Time Objective (RTO)** where the product or platform requires explicit targets.

V1 laboratory testing should measure observed recovery behavior before production-grade objectives are claimed.

### 12.20 Partial Failure

Distributed processing may fail partially.

For example:

- one Kafka partition may stop progressing while others continue;
- one Silver dataset may fail while unrelated datasets succeed;
- one Gold dimension may fail while another processing unit completes;
- one analytical product may fail certification while another remains healthy.

Recovery must identify the smallest safe affected scope.

The architecture should avoid rebuilding unrelated healthy data when a narrower recovery boundary can restore correctness safely.

However, minimizing recovery scope must not create an internally inconsistent analytical state.

### 12.21 Poison Records

A specific event or record may repeatedly fail processing while surrounding data is otherwise valid.

Such a record must not cause an infinite silent retry loop that prevents all subsequent recoverable work from progressing indefinitely.

The applicable processing stage must define explicit behavior for persistent record-level failure, which may include:

- quarantine;
- controlled dead-letter handling where implemented;
- manual remediation;
- corrected replay;
- escalation.

The failed record must remain traceable to its original input and failure reason.

Bypassing a poison record must not occur silently and must not be interpreted as successful complete processing.

### 12.22 Recovery Validation

A component restarting successfully does not prove that recovery succeeded.

Recovery must validate the resulting data state.

Depending on the failure, validation may include:

- expected event coverage;
- duplicate detection;
- source-position continuity;
- Kafka offset continuity;
- Bronze completeness;
- Silver reconciliation;
- Gold reconciliation;
- dimensional consistency;
- quality controls;
- certification status;
- end-to-end freshness.

Recovery is complete only when the required processing and data guarantees have been restored.

### 12.23 Recovery Evidence

Critical recovery scenarios must produce evidence.

Evidence should identify, as applicable:

- failure introduced;
- failure timestamp;
- affected component;
- processing state before failure;
- recovery source;
- recovery action;
- redelivery or replay behavior;
- duplicate-handling result;
- reconciliation result;
- backlog accumulated;
- recovery duration;
- final processing state;
- final certification state;
- SLO impact.

This evidence allows recovery claims to be demonstrated rather than merely described.

### 12.24 Recovery Observability

Recovery behavior must remain observable across the platform.

Initial recovery observability should include, as applicable:

- component failure state;
- retry attempts;
- last successful checkpoint;
- Kafka committed offsets;
- consumer lag;
- oldest pending event;
- replay executions;
- reprocessing executions;
- backfill executions;
- rebuild status;
- quarantined records;
- recovery source;
- recovery duration;
- backlog-reduction rate;
- reconciliation status;
- certification status;
- freshness degradation;
- return-to-SLO time.

Observability must make it possible to distinguish:

**component restarted**

from:

**processing recovered**

and from:

**data correctness restored**.

### 12.25 Failure and Recovery Guarantees

At the failure-handling and recovery boundary, the architecture requires the following guarantees:

- failures are explicit operating conditions rather than undefined exceptional states;
- recovery resumes from the safest appropriate durable state;
- retry behavior remains bounded, observable, and idempotent;
- processing checkpoints protect only work that has reached the required durable state;
- Kafka is preferred for normal retained-event recovery;
- Bronze provides the primary durable historical reconstruction foundation;
- Silver may be used when its standardized state remains valid for the recovery objective;
- Backup provides the final recovery foundation when required online history is unavailable;
- replay, reprocessing, backfill, and rebuild remain conceptually distinct and traceable;
- historical contract and processing versions remain interpretable during recovery;
- recovered analytical output does not bypass quality, reconciliation, certification, or publication controls;
- backlog recovery is measured by return to normal processing and freshness, not merely by component restart;
- persistent poison records do not disappear silently;
- partial failures are recovered at the smallest safe scope;
- recovery success includes validation of data correctness;
- critical recovery scenarios produce retained evidence.

These guarantees establish a recovery model in which the platform can fail, resume, reconstruct, and demonstrate restoration of correctness without depending on silent assumptions.

---

## 13. End-to-End Traceability and Lineage

The Data Engineering platform must preserve sufficient traceability and lineage to explain how governed analytical data was produced from operational source data.

Traceability allows the platform to identify and follow a specific event, record, processing execution, or analytical result across architectural boundaries.

Lineage describes the relationships between source data, transformations, derived datasets, analytical structures, and published data products.

Together, these capabilities must support operational investigation, data-quality analysis, recovery, auditing, impact analysis, debugging, and analytical trust.

The fundamental lineage path is:

**AtlasCommerce → CDC → Kafka → Bronze → Silver → Gold → Certified Gold → Analytical Consumption**

The platform must preserve sufficient metadata at each boundary to reconstruct the applicable processing path without depending solely on application logs or human memory.

### 13.1 Traceability and Lineage Boundary

Traceability begins at the operational-source boundary and continues through governed analytical publication.

Each processing stage must preserve or generate the identifiers and metadata required to relate its output to the applicable upstream input and processing execution.

Traceability must support both:

**Forward Traceability**
→ determine what downstream data and products were affected by a source event or processing change.

**Backward Traceability**
→ determine which source data, transformations, and processing versions contributed to a downstream analytical result.

The exact granularity may differ between layers, but the lineage chain must not be silently broken at a transformation boundary.

### 13.2 Source Traceability

The source-capture boundary must preserve sufficient information to identify the operational origin of a captured change.

Relevant metadata may include:

- source system;
- source database;
- source schema;
- source table;
- source primary or business key;
- source operation;
- source commit timestamp;
- source transaction metadata;
- source position such as LSN;
- applicable capture metadata.

This information establishes the relationship between an event and the committed operational change from which it originated.

Source traceability must not depend on querying the current source state alone because the source entity may have changed again after the original event was captured.

### 13.3 Event Identity

Each logical event must have a stable identity that allows the platform to distinguish:

- one event from another;
- legitimate subsequent changes to the same business entity;
- repeated delivery of the same logical event.

The event identity must remain traceable across the stages that require event-level lineage.

Conceptually:

**Source Change → Stable Event Identity → Kafka → Bronze → Downstream Traceability**

The exact event-identity generation mechanism must be defined and validated during implementation.

It must remain deterministic or otherwise stable according to the selected event architecture and must not generate a new logical identity merely because the same event is replayed or redelivered.

### 13.4 Kafka Traceability

Kafka transport metadata must support tracing an event through the event-streaming boundary.

Relevant metadata includes, as applicable:

- topic;
- partition;
- offset;
- event identity;
- event-contract version;
- source position;
- event timestamp;
- producer or connector metadata where required.

The combination of topic, partition, and offset identifies a physical Kafka record position.

This physical position is distinct from the logical event identity.

Conceptually:

**Logical Identity**
→ identifies the event.

**Kafka Position**
→ identifies where a delivery of that event exists in Kafka.

This distinction is important because replay or republishing may create a different transport position without changing the logical meaning of the original event.

### 13.5 Bronze Lineage

Bronze must preserve the metadata required to relate persisted historical records to their event and source origins.

Bronze lineage should include, as applicable:

- event identity;
- source system;
- source object;
- source business identifier;
- source operation;
- source commit timestamp;
- source position;
- event-contract version;
- Kafka topic;
- Kafka partition;
- Kafka offset;
- Bronze persistence timestamp;
- Bronze object identity or path;
- ingestion or persistence execution identifier.

Bronze must preserve original event context even when the data is later replayed.

Replay metadata must supplement the original lineage rather than replace it.

### 13.6 Silver Lineage

Silver output must remain traceable to the Bronze input and transformation logic from which it was derived.

Silver lineage should identify, as applicable:

- Bronze input scope;
- source event identity or identities;
- source object or object set;
- event-contract version;
- Silver processing version;
- processing execution identifier;
- transformation timestamp;
- standardization or normalization context;
- rejection or quarantine status where applicable.

Where multiple Bronze records contribute to a Silver result, the lineage model must support the applicable many-to-one relationship.

Where one Bronze record produces multiple Silver outputs, the lineage model must support the applicable one-to-many relationship.

Lineage must therefore reflect transformation semantics rather than assume permanent one-to-one correspondence between layers.

### 13.7 Gold Lineage

Gold structures must remain traceable to the Silver foundation and dimensional-processing logic that produced them.

Gold lineage should support identifying, as applicable:

- Silver input scope;
- Gold processing version;
- processing execution;
- fact grain;
- business identifiers;
- dimension-resolution behavior;
- surrogate-key relationships;
- applicable dimensional versions;
- measure derivation;
- transformation timestamp.

For derived measures, lineage must identify the governed business definition or transformation rule used to calculate the measure.

A consumer should not need to inspect undocumented SQL code to discover the intended meaning of a certified analytical measure.

### 13.8 Dimensional Lineage

Dimensional modeling introduces lineage relationships that may differ from source-system physical relationships.

For example, a source customer identifier may map to multiple historical surrogate keys under SCD Type 2 behavior.

Conceptually:

**Source Customer 157**

may correspond to:

**CustomerKey 845 → historical version 1**

**CustomerKey 932 → historical version 2**

Lineage must preserve the relationship between each analytical dimensional version and the source business entity it represents.

Fact lineage must also make it possible to determine why a specific dimensional version was selected according to the applicable temporal and business rules.

### 13.9 Certified Gold Lineage

A certified analytical version must remain attributable to the complete processing and validation context that authorized its publication.

Certified Gold lineage should identify, as applicable:

- analytical product;
- certified version;
- Gold candidate version;
- Gold processing version;
- Silver processing version;
- applicable event-contract versions;
- quality-rule version;
- reconciliation execution;
- certification result;
- certification timestamp;
- `certified_gold_publish_ts`;
- publication execution;
- source-period coverage.

Certification lineage must allow the platform to determine not only:

**what data was published**

but also:

**why that version was considered eligible for governed publication**.

### 13.10 Analytical Product Lineage

Analytical products must document their upstream dependencies.

For the initial **Daily Sales** product, lineage must ultimately identify the relevant dependencies between:

- AtlasCommerce source entities;
- captured event families;
- Bronze historical data;
- Silver standardized datasets;
- Gold facts and dimensions;
- quality and reconciliation controls;
- Certified Gold publication;
- Power BI semantic and reporting structures.

This dependency model supports both technical investigation and business interpretation.

As additional domains and analytical products are introduced, the lineage model must evolve to represent shared dependencies and conformed analytical structures.

### 13.11 Forward Impact Analysis

Lineage must support determining the potential downstream impact of an upstream change.

Examples include:

- source-column change;
- event-contract evolution;
- Silver transformation change;
- Gold measure-definition change;
- dimension change;
- quality-rule change;
- analytical-product change.

Conceptually:

**Change Upstream → Identify Downstream Dependencies → Evaluate Impact Before Deployment**

For example, a change to a conformed dimension may affect multiple facts and analytical products.

Impact analysis must therefore consider dependency relationships rather than only the component directly being modified.

### 13.12 Backward Investigation

Lineage must support investigating an analytical result from the consumer boundary back toward its operational origin.

For example, an investigation may begin with:

**Power BI value appears incorrect**

and proceed through:

**Certified Gold → Gold Measure → Gold Fact → Silver Input → Bronze Events → Source Changes**

The objective is not necessarily to represent every analytical aggregate as a direct pointer to a single source row.

Aggregated analytical results may depend on many upstream records.

The lineage model must instead preserve sufficient relationships and processing context to identify the applicable contributing scope.

### 13.13 Lineage Across Aggregation

Aggregation changes lineage granularity.

For example:

**1,000 transaction-item records**

may contribute to:

**50 Daily Sales Gold records**

which may contribute to:

**one Power BI visual total**.

The platform must not pretend that an aggregated result has a one-to-one source relationship.

Lineage across aggregation should identify the contributing dataset, processing scope, business period, grain, transformation logic, and applicable source coverage.

Where record-level lineage is operationally required, the implementation must preserve the necessary identifiers or reconciliation mechanisms to support that requirement.

### 13.14 Lineage Across Replay and Reprocessing

Replay, reprocessing, backfill, and rebuild must preserve lineage.

A reconstructed result must identify both:

- the original source or historical input context;
- the recovery or processing execution that produced the new derived result.

Conceptually:

**Original Event Time ≠ Replay Time**

and:

**Original Processing Version ≠ Recovery Processing Version**

when different logic is used.

Recovery activity must therefore extend lineage rather than replace historical provenance.

### 13.15 Lineage and Processing Versions

The platform may contain multiple independent version dimensions, including:

- event-contract version;
- Silver processing version;
- Gold processing version;
- quality-rule version;
- certified analytical-product version.

These versions describe different architectural concerns.

Lineage must preserve their relationships so that the platform can answer questions such as:

- which event contract was used;
- which Silver logic interpreted the event;
- which Gold logic produced the analytical structure;
- which quality rules validated it;
- which certified version exposed it to consumers.

Version identifiers must not be collapsed into one generic `version` field when doing so would make their meaning ambiguous.

### 13.16 Correlation and Execution Identifiers

Processing executions should use stable execution or correlation identifiers where required to connect logs, metrics, transformations, and resulting data.

Examples may include:

- ingestion execution ID;
- Silver processing execution ID;
- Gold processing execution ID;
- quality-validation execution ID;
- certification execution ID;
- publication execution ID;
- replay or recovery execution ID.

Execution identifiers support operational traceability.

They are distinct from business identifiers and event identity.

Conceptually:

**Business ID**
→ identifies the business entity.

**Event ID**
→ identifies the logical event.

**Execution ID**
→ identifies the processing activity.

These identifiers must not be treated as interchangeable.

### 13.17 Traceability and Observability

Traceability and observability are related but distinct.

**Observability**
→ explains the operational behavior and health of the platform.

**Traceability and Lineage**
→ explain the origin, transformation path, and dependencies of data.

For example:

**Consumer lag = 50,000**
is an observability fact.

**This certified Daily Sales result was produced from these Silver inputs using Gold Processing V3**
is a lineage fact.

The platform should correlate both where useful during investigation.

### 13.18 Lineage Metadata Management

Lineage metadata must be managed as platform information rather than exist only in temporary logs or individual developer knowledge.

The implementation may combine:

- persisted technical metadata;
- processing-control tables;
- dataset metadata;
- contract metadata;
- execution metadata;
- orchestration metadata;
- catalog or lineage tooling where introduced.

The architecture does not require every lineage capability to be implemented through a single product.

The requirement is that the necessary lineage relationships remain reconstructable, durable, and queryable according to the platform's operational and governance needs.

### 13.19 Lineage Retention

Lineage retention must be sufficient to support the historical data and certified analytical versions that remain governed or recoverable.

Deleting lineage metadata while retaining the corresponding historical analytical data may make that data impossible to explain or audit.

Retention policies must therefore consider relationships between:

- Bronze retention;
- Silver retention;
- Gold retention;
- certified-version retention;
- contract-version retention;
- processing-version retention;
- quality evidence;
- lineage metadata.

Lineage retention must be evaluated as part of the broader lifecycle and recovery strategy.

### 13.20 Lineage Validation

The existence of lineage metadata does not guarantee that the lineage is correct.

Critical lineage relationships should be validated during implementation and testing.

Validation may include:

- event identity preserved from Kafka to Bronze;
- Bronze input correctly associated with Silver output;
- Silver scope correctly associated with Gold processing;
- business keys correctly related to surrogate keys;
- processing versions correctly recorded;
- certification evidence correctly related to published versions;
- replay lineage preserving original source context.

Lineage failures must be observable because incorrect lineage can produce false confidence during investigation.

### 13.21 Lineage Evidence

The V1 implementation should produce practical evidence demonstrating end-to-end traceability.

At least one representative Sales flow should be traceable from operational source change through the analytical publication path.

Evidence should demonstrate, as applicable:

- source record or business entity;
- source change metadata;
- event identity;
- Kafka position;
- Bronze persistence;
- Silver transformation;
- Gold fact or dimension relationship;
- certification evidence;
- Certified Gold publication;
- analytical consumption.

A reverse investigation should also be demonstrated from a selected analytical result back toward its contributing source scope.

This evidence provides practical proof that lineage is operational rather than merely documented.

### 13.22 Traceability and Lineage Guarantees

At the traceability and lineage boundary, the architecture requires the following guarantees:

- operational changes remain traceable through the applicable downstream processing path;
- forward and backward traceability are supported according to the required granularity;
- event identity remains distinct from Kafka transport position;
- business identity, event identity, and processing execution identity remain conceptually distinct;
- Bronze preserves original source and transport context;
- Silver remains attributable to Bronze input and Silver processing logic;
- Gold remains attributable to Silver input and dimensional-processing logic;
- dimensional surrogate keys remain traceable to applicable business entities;
- Certified Gold remains attributable to its processing, quality, reconciliation, certification, and publication evidence;
- aggregation does not create false one-to-one lineage assumptions;
- replay and reprocessing extend lineage rather than overwrite original provenance;
- independent version dimensions remain distinguishable;
- lineage supports downstream impact analysis;
- lineage metadata remains durable beyond temporary execution logs;
- lineage retention is aligned with governed-data retention;
- critical lineage relationships are validated through implementation evidence.

These guarantees establish an explainable analytical chain from operational source change to governed analytical consumption.

---

## 14. Observability and Operational Measurement

Observability provides the operational visibility required to determine whether the Data Engineering platform is healthy, progressing, recovering, and meeting its expected service levels.

The V1 observability foundation uses **Prometheus**, **Grafana**, and structured logging.

Observability must cover both infrastructure health and data-flow behavior.

A component being available does not prove that data is flowing correctly, and successful processing does not prove that analytical data is complete, current, or certified.

The platform must therefore measure the complete processing path:

**Source Commit → CDC → Kafka → Bronze → Silver → Gold → Quality and Reconciliation → Certified Gold → Analytical Consumption**

The objective is to make processing behavior measurable, diagnosable, and verifiable rather than inferred from isolated component status.

### 14.1 Observability Dimensions

Operational visibility must cover, as applicable:

- availability;
- throughput;
- latency;
- backlog;
- error rate;
- processing success and failure;
- retry behavior;
- recovery behavior;
- data-quality status;
- reconciliation status;
- certification status;
- publication status;
- freshness;
- resource utilization;
- capacity behavior.

These dimensions must be interpreted together.

For example, high availability with growing backlog may still represent an unhealthy analytical service.

### 14.2 Infrastructure Health

Infrastructure monitoring must expose the operational state of the services required by the platform.

Depending on the component, relevant indicators may include:

- service availability;
- CPU utilization;
- memory utilization;
- storage utilization;
- network behavior;
- connection failures;
- process restarts;
- resource saturation;
- storage-capacity risk.

Infrastructure metrics provide important diagnostic context but must not be used as the sole indicator of data-platform health.

### 14.3 Data-Flow Health

The platform must determine whether data is actually moving through the expected processing path.

Data-flow health should include, as applicable:

- source changes observed;
- CDC changes captured;
- events produced;
- events available in Kafka;
- events consumed;
- Bronze records persisted;
- Silver records processed;
- Gold processing completed;
- quality controls executed;
- reconciliation completed;
- certification completed;
- Certified Gold published.

A gap between consecutive stages must be observable.

For example:

**CDC active → Kafka inactive**
requires a different investigation from:

**Kafka active → Bronze inactive**

or:

**Gold complete → certification blocked**.

### 14.4 Throughput

Throughput measures how much work the platform processes over time.

Relevant throughput measurements may include:

- source changes per second or minute;
- events produced per second;
- Kafka consumption rate;
- Bronze persistence rate;
- Silver processing rate;
- Gold processing rate;
- certification processing rate.

Throughput must be evaluated relative to the incoming workload.

A high processing rate is not sufficient if the incoming rate is consistently higher.

Conceptually:

**Processing Capacity Margin = Processing Rate - Incoming Rate**

A positive sustained margin allows backlog recovery.

A zero or negative margin indicates that backlog may remain stable or continue to grow.

### 14.5 Stage Latency

The platform must measure latency between significant processing boundaries.

Initial measurements include:

- source commit to CDC capture;
- CDC capture to Kafka availability;
- Kafka availability to Bronze persistence;
- Bronze persistence to Silver publication;
- Silver publication to Gold completion;
- Gold completion to Certified Gold publication.

These measurements allow the platform to identify which stage contributes most to end-to-end delay.

Stage latency should be measured using distributions rather than only averages where appropriate.

### 14.6 End-to-End Latency

The primary V1 analytical freshness measurement is:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

The initial formal objective is:

**P95 ≤ 15 minutes**

Under normal operating conditions, the platform initially targets analytical availability in approximately **3–5 minutes**.

The target operating range and formal SLO serve different purposes and must remain distinguishable.

End-to-end latency must include time spent in:

- capture;
- transport;
- buffering;
- persistence;
- transformation;
- backlog waiting;
- quality validation;
- reconciliation;
- certification;
- publication.

The freshness clock stops only when the certified analytical result becomes available for governed consumption.

### 14.7 Percentiles

Latency must not be evaluated using averages alone.

The platform should observe, as applicable:

- **P50**;
- **P95**;
- **P99**.

Conceptually:

**P50**
→ typical median behavior.

**P95**
→ V1 formal service-level objective.

**P99**
→ visibility into slower tail behavior.

Percentile trends help identify degradation that may remain hidden behind a stable average.

### 14.8 Backlog

Backlog represents work that has arrived but has not yet completed the applicable processing stage.

Backlog may exist in multiple locations, including:

- Kafka;
- Bronze awaiting Silver processing;
- Silver awaiting Gold processing;
- Gold candidates awaiting validation or certification.

The platform must not treat backlog as exclusively a Kafka concern.

Each processing boundary that can accumulate pending work should expose an appropriate backlog indicator.

### 14.9 Oldest Pending Work

Backlog size alone does not fully describe freshness impact.

The platform should also measure the age of the oldest pending work where applicable.

Conceptually:

**Backlog Size**
→ how much work is waiting.

**Oldest Pending Work**
→ how long the most delayed work has been waiting.

This distinction is particularly important for low-volume periods where a small backlog may still represent severe analytical staleness.

### 14.10 No-Event Detection

The absence of new events must not automatically be classified as healthy.

A period with no events may represent:

- legitimate business inactivity;
- source-capture failure;
- Debezium failure;
- Kafka producer failure;
- transport interruption;
- another upstream processing issue.

No-event detection must consider:

- expected workload patterns;
- historical event rates;
- business calendar;
- source activity;
- CDC health;
- producer health;
- downstream component state.

The platform should learn from measured workload behavior before defining static no-event alert thresholds.

### 14.11 Processing Success and Failure

Processing monitoring must distinguish between meaningful operational states.

Examples include:

- started;
- running;
- completed successfully;
- completed with warnings;
- failed;
- retrying;
- quarantined;
- blocked by quality;
- blocked by reconciliation;
- certification failed;
- publication failed.

A single generic `SUCCESS` or `FAILURE` state is insufficient for diagnosing the end-to-end pipeline.

### 14.12 Error Classification

Errors should be observable according to their processing context.

Useful classifications may include:

- transient infrastructure errors;
- persistent infrastructure errors;
- serialization or deserialization failures;
- contract incompatibility;
- type-conversion failures;
- data-validation failures;
- quality-rule failures;
- reconciliation failures;
- storage failures;
- publication failures;
- security or authorization failures.

Classification helps determine whether retry, quarantine, remediation, escalation, replay, or rebuild is appropriate.

### 14.13 Structured Logging

Application and processing logs must be structured so that operational events can be correlated across processing stages.

Where applicable, log records should include identifiers such as:

- timestamp;
- severity;
- component;
- event identity;
- source position;
- Kafka topic;
- Kafka partition;
- Kafka offset;
- processing execution identifier;
- dataset;
- processing version;
- contract version;
- error classification;
- retry attempt;
- correlation or trace identifier.

Structured logging must support machine-readable analysis rather than depend solely on free-form text messages.

Sensitive data must not be written to logs unnecessarily.

### 14.14 Correlation

Observability must allow related metrics and logs to be correlated across processing boundaries.

For example, an investigation should be able to relate:

**consumer lag increase**

to:

**Bronze persistence slowdown**

and then to:

**storage latency or failure**

where the evidence supports that relationship.

Correlation identifiers and shared timestamps should be preserved where they provide meaningful diagnostic value.

### 14.15 Quality Observability

Data quality must be observable as an operational state.

Relevant information includes:

- controls executed;
- controls passed;
- controls failed;
- critical failures;
- warnings;
- affected dataset;
- affected candidate version;
- quality-rule version;
- validation duration.

A technically healthy pipeline that repeatedly fails critical quality checks is not healthy from the perspective of governed analytical delivery.

### 14.16 Reconciliation Observability

Reconciliation monitoring must expose:

- reconciliation execution status;
- compared source and target scope;
- expected control values;
- observed control values;
- absolute and relative differences where applicable;
- thresholds;
- reconciliation duration;
- affected candidate version.

Reconciliation failures must remain visible independently from infrastructure failures.

### 14.17 Certification and Publication Observability

The platform must observe the complete certification and publication sequence.

Relevant indicators include:

- candidate version;
- certification status;
- certification duration;
- publication status;
- publication duration;
- publication failures;
- publication retries;
- current certified version;
- last successful certification;
- `certified_gold_publish_ts`;
- age of currently certified data.

This makes it possible to identify whether analytical staleness is caused by transformation, certification, or publication delay.

### 14.18 Consumer Observability

Governed analytical consumption should expose sufficient information to determine whether certified data is actually available to consumers.

Where integrated, monitoring may include:

- Certified Gold serving availability;
- analytical-query availability;
- Power BI refresh status;
- Power BI refresh duration;
- consumer access failures;
- freshness shown to consumers.

The V1 Data Engineering SLO ends when Certified Gold becomes available.

Power BI refresh behavior may be measured separately because BI refresh scheduling can introduce additional consumer-visible delay beyond the Data Engineering publication boundary.

### 14.19 SLI and SLO

A **Service Level Indicator (SLI)** is a measured value representing a relevant aspect of service behavior.

Examples include:

- end-to-end latency;
- successful publication rate;
- freshness;
- recovery duration.

A **Service Level Objective (SLO)** defines the target expected for the corresponding indicator.

For V1:

**SLI**
→ measured end-to-end analytical freshness.

**SLO**
→ **P95 ≤ 15 minutes**.

The platform may introduce additional SLIs and SLOs as implementation evidence and business requirements mature.

An SLO must be measurable through defined indicators and must not exist only as an undocumented expectation.

### 14.20 Alerting

Alerts should identify actionable conditions rather than reproduce every available metric.

Potential alert conditions include:

- component unavailable;
- CDC inactivity outside expected behavior;
- consumer lag increasing beyond expected levels;
- oldest pending work exceeding threshold;
- processing failure;
- repeated retry;
- quarantine growth;
- quality critical failure;
- reconciliation failure;
- certification failure;
- publication failure;
- freshness SLO violation;
- storage-capacity risk.

Alert thresholds must be calibrated using measured baseline behavior where possible.

Excessive non-actionable alerts reduce trust in the alerting system and should be avoided.

### 14.21 Seasonal and Workload Baselines

Expected workload behavior may vary according to:

- time of day;
- day of week;
- business calendar;
- promotional periods;
- operational events.

Static thresholds may therefore create false alerts or fail to detect anomalies.

The platform should initially collect and understand measured workload patterns before introducing more advanced seasonal or behavioral alerting.

V1 may begin with simpler thresholds while preserving the architecture for later baseline-aware monitoring.

### 14.22 Recovery Observability

Recovery must be observable as a process rather than only as a component state.

Relevant measurements include:

- failure start time;
- recovery start time;
- component restart time;
- processing resume time;
- backlog at recovery;
- recovery processing rate;
- incoming rate;
- backlog reduction rate;
- oldest pending event;
- time to restore correct processing;
- time to return within SLO;
- final reconciliation status;
- final certification status.

This preserves the distinction between:

**component recovered**

**processing recovered**

**data correctness recovered**

**service level recovered**.

### 14.23 Capacity Observability

The platform must collect measurements that support future capacity decisions.

Relevant measurements may include:

- event rate;
- event size;
- compression ratio;
- storage growth;
- object count;
- processing throughput;
- CPU utilization;
- memory utilization;
- storage utilization;
- network throughput;
- consumer parallelism;
- backlog recovery capacity.

Capacity analysis must correlate resource usage with actual workload behavior.

A component using high CPU is not automatically a problem if throughput and service levels remain healthy.

Likewise, low CPU does not prove that the platform has adequate capacity if the bottleneck exists elsewhere.

### 14.24 Measured Baseline

As implementation progresses, the platform must replace assumed behavior with measured baseline information.

Measurements should progressively establish:

- normal event rates;
- normal latency distribution;
- normal backlog behavior;
- normal processing duration;
- normal storage growth;
- expected resource utilization;
- expected failure and retry behavior.

This produces the transition:

**Assumed Baseline → Measured Baseline → Validated Capacity**

The measured baseline becomes the reference used to identify abnormal behavior and evaluate future scaling decisions.

### 14.25 Dashboard Strategy

Grafana dashboards should be organized around operational questions rather than merely around individual technologies.

Useful dashboard perspectives may include:

**Platform Health**
→ are required services available?

**Data Flow**
→ is data progressing through each stage?

**Freshness**
→ are analytical products within expected latency?

**Kafka and Backlog**
→ are consumers keeping up and recovering?

**Processing**
→ are Bronze, Silver, and Gold completing correctly?

**Quality and Certification**
→ are candidates passing governed controls?

**Recovery**
→ is the platform returning to normal after disruption?

**Capacity**
→ how is workload behavior consuming available resources?

Technology-specific dashboards may complement these views but should not replace end-to-end operational visibility.

### 14.26 Evidence from Observability

Metrics and logs are also sources of architectural evidence.

Controlled tests should preserve the relevant observability output required to demonstrate behaviors such as:

- normal processing latency;
- duplicate redelivery handling;
- backlog accumulation;
- backlog recovery;
- consumer outage;
- storage failure;
- quality failure;
- certification blocking;
- publication recovery;
- return to SLO.

Evidence must include enough context to explain the test conditions and should not consist only of isolated screenshots without interpretation.

### 14.27 OpenTelemetry Evolution

V1 begins with Prometheus, Grafana, and structured logging.

**OpenTelemetry** is reserved as a future evolution for broader telemetry correlation and distributed tracing.

Its introduction should be driven by an identified requirement for stronger cross-component tracing rather than by the assumption that every platform must adopt distributed tracing immediately.

The current architecture preserves identifiers and structured metadata that can support future telemetry correlation.

### 14.28 Observability Guarantees

At the observability boundary, the architecture requires the following guarantees:

- infrastructure health and data-flow health remain distinguishable;
- every critical processing boundary exposes meaningful progress information;
- throughput is interpreted relative to incoming workload;
- stage and end-to-end latency remain measurable;
- P50, P95, and P99 can be observed where applicable;
- backlog size and oldest pending work remain distinguishable;
- no-event conditions are evaluated against expected source behavior;
- processing states remain more expressive than generic success or failure;
- structured logs preserve useful correlation metadata;
- quality, reconciliation, certification, and publication remain observable independently;
- consumer availability remains distinct from Certified Gold publication;
- SLIs support measurable SLOs;
- alerts focus on actionable conditions;
- measured baselines replace assumptions over time;
- recovery observability measures return to correctness and service level rather than component restart alone;
- capacity decisions are supported by workload and resource measurements;
- observability output can be retained as architectural evidence.

These guarantees establish the operational measurement foundation required to understand, validate, and evolve the Data Engineering platform.

---

## 15. Processing Evidence and Validation Strategy

The processing guarantees defined in this document must be validated through controlled implementation and testing.

Documentation establishes the intended behavior of the Data Engineering platform.

Implementation provides the mechanism.

Testing exercises the expected and failure behaviors.

Observability exposes what occurred during execution.

Evidence records the result under documented conditions.

The validation chain is:

**Architecture Requirement → Implementation → Test → Observability → Evidence**

The purpose of this strategy is not to create evidence for every implementation detail.

It is to ensure that critical processing guarantees can be demonstrated rather than inferred solely from design documentation or successful normal execution.

### 15.1 Validation Scope

Validation must focus on the behaviors that materially affect data correctness, recoverability, freshness, traceability, certification, and analytical trust.

Critical validation areas include:

- committed-change capture;
- event identity;
- contract compatibility;
- Kafka ordering;
- at-least-once delivery;
- offset management;
- Bronze durability;
- atomic persistence;
- idempotency;
- duplicate handling;
- Silver standardization;
- Gold dimensional correctness;
- quality validation;
- reconciliation;
- Certified Gold publication;
- replay;
- reprocessing;
- backfill;
- rebuild;
- failure recovery;
- backlog recovery;
- end-to-end traceability;
- SLO measurement.

The exact test inventory may evolve as implementation exposes additional risks or processing behaviors.

### 15.2 Normal-Path Validation

The platform must first demonstrate correct end-to-end processing under controlled normal conditions.

For the initial **Sales** implementation, validation must demonstrate that a committed AtlasCommerce change can progress through:

**AtlasCommerce → CDC → Debezium → Kafka → Bronze → Silver → Gold → Quality and Reconciliation → Certified Gold → Analytical Consumption**

The normal-path test must preserve enough metadata to demonstrate:

- source change;
- event creation;
- Kafka position;
- Bronze persistence;
- Silver transformation;
- Gold result;
- quality and reconciliation result;
- certification;
- publication;
- end-to-end latency.

Normal-path success establishes the baseline against which failure scenarios can later be evaluated.

### 15.3 Failure Injection

Critical recovery behavior must be tested through controlled failure injection.

The laboratory should intentionally reproduce scenarios such as:

- consumer interruption;
- failure before Bronze persistence;
- failure during temporary Bronze write;
- failure after Bronze promotion but before offset commit;
- Kafka unavailability;
- object-storage unavailability;
- Silver processing failure;
- Gold processing failure;
- persistent invalid record;
- schema incompatibility;
- quality-rule failure;
- reconciliation failure;
- Certified Gold publication failure.

Failure injection must be controlled so that the starting state, failure point, and expected recovery behavior are known.

The objective is to observe platform behavior under failure, not merely to verify that a component can be restarted.

### 15.4 Idempotency Validation

Idempotency must be demonstrated explicitly.

Testing must include repeated processing of the same logical event or processing input.

The expected result is that repeated delivery or execution does not create incorrect duplicate business effects.

Validation should cover, as applicable:

- Bronze duplicate redelivery;
- Silver reprocessing;
- Gold fact reprocessing;
- dimension reprocessing;
- replay;
- publication retry.

The evidence must distinguish between:

**Repeated delivery of the same event**
and
**Legitimate different events affecting the same business entity**.

### 15.5 Offset and Durability Validation

The relationship between Kafka offset commit and Bronze durability must be tested directly.

At minimum, testing should demonstrate the behavior when failure occurs:

**before Bronze persistence**

and:

**after Bronze persistence but before Kafka offset commit**.

The expected result is that:

- unprotected work remains eligible for redelivery;
- safely persisted work is not lost;
- repeated delivery does not produce incorrect historical duplication;
- committed offsets do not advance beyond the durability boundary they protect.

This validation provides practical evidence for the V1 at-least-once processing model.

### 15.6 Atomic Persistence Validation

Bronze and other file-based publication boundaries must demonstrate that incomplete output does not become visible as valid completed data.

Testing should verify that:

- temporary output remains distinguishable from final output;
- interrupted writes do not appear as valid final objects;
- successful promotion exposes only validated output;
- downstream processing ignores incomplete artifacts.

The implementation-specific mechanism must be validated against actual object-storage behavior rather than assumed from traditional filesystem semantics.

### 15.7 Contract-Evolution Validation

Schema and event-contract evolution must be tested beyond successful registry registration.

Validation should include, as applicable:

- compatible schema evolution;
- incompatible schema change rejection;
- producer serialization;
- consumer interpretation;
- supported historical versions;
- Bronze replay across contract versions;
- Silver normalization across supported versions;
- explicit migration behavior for breaking changes.

The expected result is that event evolution does not silently break supported downstream processing.

### 15.8 Transformation Validation

Silver and Gold transformation logic must be tested independently from infrastructure availability.

Silver validation should include, as applicable:

- type enforcement;
- standardization;
- normalization;
- duplicate handling;
- operation semantics;
- contract-version handling;
- invalid-record behavior.

Gold validation should include, as applicable:

- fact grain;
- measure definitions;
- dimension resolution;
- surrogate-key behavior;
- historical dimension behavior;
- temporal consistency;
- conformed-dimension behavior;
- idempotent reprocessing.

Transformation correctness must not be inferred solely from successful job completion.

### 15.9 Quality-Gate Validation

Certification controls must be tested with both valid and intentionally invalid candidate data.

Testing should demonstrate that:

**Valid Candidate**
→ passes required controls and becomes eligible for publication.

**Invalid Critical Candidate**
→ fails certification and does not replace the current certified version.

The test must verify that the last known-good certified version remains available where technically possible.

Quality-gate validation should include the evidence required to identify which rule blocked certification and why.

### 15.10 Reconciliation Validation

Reconciliation must be validated using known source and downstream control values.

Testing should verify that the reconciliation logic correctly identifies both:

- expected equivalence;
- intentional discrepancy.

Reconciliation tests must reflect the actual transformation grain and business semantics.

A test that only compares row counts is insufficient where the source and target structures do not have one-to-one grain.

For the Sales implementation, representative reconciliation may include quantities, transaction counts, transaction-item counts, monetary totals, and other approved controls according to the final analytical model.

### 15.11 Certified Publication Validation

Certified Gold publication must demonstrate consumer-visible atomicity.

Testing should verify that:

- the previous certified version remains visible while a candidate is prepared;
- incomplete candidates are not exposed;
- failed candidates are not published;
- successful candidates become visible as complete certified versions;
- publication failure does not produce a false `certified_gold_publish_ts`;
- rollback can restore an eligible prior version where implemented.

The validation must focus on consumer-visible behavior rather than only internal publication commands.

### 15.12 Replay Validation

Replay must be demonstrated from preserved historical input.

A replay test should identify:

- replay source;
- historical range;
- original event identity;
- original timestamps;
- processing version;
- replay execution;
- resulting downstream state;
- duplicate-handling result;
- reconciliation result.

The test must demonstrate that replay does not rewrite the original event history or incorrectly multiply downstream analytical effects.

### 15.13 Backfill Validation

Where a backfill capability is implemented, testing must demonstrate that a historical range can be introduced or reconstructed without corrupting normal incremental processing.

Validation should verify:

- historical-period boundaries;
- original business-effective timestamps;
- processing-version attribution;
- overlap behavior with existing data;
- duplicate prevention;
- reconciliation;
- certification impact.

Backfill evidence must distinguish the historical business period from the execution time of the backfill.

### 15.14 Recovery Validation

Recovery testing must validate more than component restart.

A recovery scenario is considered successful only when the required processing and data guarantees have been restored.

Validation should include, as applicable:

- processing resumed from the correct durable position;
- required events remain complete;
- duplicate redelivery was handled safely;
- ordering remains correct;
- backlog decreases;
- Silver and Gold become reconcilable;
- certification succeeds;
- Certified Gold becomes current again;
- end-to-end freshness returns to the expected range.

This distinguishes:

**Component Restart**
from
**Processing Recovery**
from
**Data Correctness Recovery**
from
**Service-Level Recovery**.

### 15.15 Backlog-Recovery Validation

The laboratory must intentionally create backlog and measure recovery behavior.

A representative test should record:

- incoming event rate;
- processing rate;
- backlog at disruption;
- backlog at recovery start;
- oldest pending event;
- backlog reduction rate;
- resource utilization;
- end-to-end latency;
- time required to eliminate or normalize backlog;
- time required to return within SLO.

The expected condition for sustained backlog reduction is:

**Processing Rate > Incoming Rate**

The test must demonstrate catch-up behavior rather than only successful consumer restart.

### 15.16 SLO Validation

The V1 freshness SLO must be measured through actual end-to-end processing.

The primary measurement is:

**E2E Latency = certified_gold_publish_ts - source_commit_ts**

Validation must calculate the applicable latency distribution and determine:

- P50;
- P95;
- P99.

The formal V1 objective is:

**P95 ≤ 15 minutes**

The initial **3–5 minute** range represents the expected normal operating target and must remain distinct from the formal SLO boundary.

SLO evidence must identify the workload conditions under which the measurement was collected.

### 15.17 Workload and Capacity Validation

Performance tests must progressively evaluate the processing behavior under increasing workload.

The initial V1 validation reference includes:

- approximately **10 GB** initial operational data;
- approximately **250 MB/day** expected change volume;
- workload peaks of approximately **3× the baseline**.

These values are starting assumptions and laboratory targets rather than architectural capacity limits.

Testing should measure, as applicable:

- event throughput;
- processing throughput;
- backlog behavior;
- compression ratio;
- storage growth;
- CPU utilization;
- memory utilization;
- network utilization;
- stage latency;
- end-to-end latency;
- recovery capacity.

The resulting evidence supports the transition:

**Assumed Baseline → Measured Baseline → Validated Capacity**

### 15.18 Traceability Validation

At least one representative Sales flow must demonstrate end-to-end traceability.

Forward validation should trace a controlled operational change through:

**AtlasCommerce → CDC → Kafka → Bronze → Silver → Gold → Certified Gold → Analytical Consumption**

Backward validation should begin with a selected analytical result and identify its contributing processing and source scope.

Evidence should preserve, where applicable:

- source business identifier;
- source position;
- event identity;
- Kafka partition and offset;
- Bronze object;
- Silver processing execution;
- Gold processing execution;
- certification evidence;
- certified version;
- analytical product.

This test demonstrates that lineage can be used operationally rather than existing only as documentation.

### 15.19 Evidence Structure

Test evidence must contain sufficient context to remain meaningful after the execution has completed.

Evidence should identify, as applicable:

- test identifier;
- test purpose;
- architectural requirement;
- environment;
- implementation version;
- test date;
- initial state;
- test input;
- induced failure where applicable;
- expected behavior;
- observed behavior;
- relevant metrics;
- relevant logs;
- reconciliation result;
- quality result;
- recovery result;
- SLO impact;
- final state;
- conclusion.

Evidence should be reproducible whenever practical.

### 15.20 Evidence Naming

Critical laboratory scenarios should use stable identifiers so that architecture documentation, tests, and evidence can reference the same validation scenario.

For example:

**REL-001 — Consumer Outage and Recovery**

A stable identifier allows relationships such as:

**Architecture Requirement**
→ **REL-001 Test**
→ **REL-001 Evidence**

The exact identifier taxonomy is maintained as part of the testing and evidence standards rather than being defined exhaustively in this document.

### 15.21 Evidence Quality

Evidence must demonstrate behavior, not merely show that a command was executed.

For example, a screenshot showing a restarted consumer is insufficient proof of successful recovery.

Strong recovery evidence would instead demonstrate:

- consumer stopped;
- backlog accumulated;
- oldest pending event increased;
- consumer restarted;
- repeated delivery was handled safely;
- processing rate exceeded incoming rate;
- backlog decreased;
- reconciliation passed;
- certification recovered;
- SLO returned to the expected state.

Evidence should therefore preserve the sequence and interpretation required to support the corresponding architectural claim.

### 15.22 Negative Evidence

A failed test can provide valuable architectural evidence.

If a controlled test demonstrates that the platform does not satisfy an expected behavior, the result must not be hidden or rewritten as success.

The failure may identify:

- an implementation defect;
- an incorrect architectural assumption;
- an insufficient capacity margin;
- an invalid threshold;
- a recovery limitation;
- a required architectural refinement.

The failed result should be retained until the issue is understood and the resulting change is validated.

A subsequent successful test must not erase the historical evidence that led to the correction.

### 15.23 Evidence and Architecture Evolution

Implementation evidence may trigger controlled architectural change.

When evidence reveals a meaningful limitation, the platform should evaluate:

**Observed Behavior → Root Cause → Alternatives → Architectural Decision → Implementation Change → Revalidation**

Significant changes should be reflected in the applicable Architecture Decision Record and related documentation.

Evidence therefore provides input to architectural evolution rather than serving only as proof after implementation.

### 15.24 Laboratory Claims

Laboratory evidence must always be interpreted within the conditions under which it was produced.

A successful test may demonstrate:

- correctness under the tested scenario;
- measured throughput;
- measured latency;
- measured recovery behavior;
- validated capacity within the tested workload.

It must not automatically be presented as proof of:

- unlimited scalability;
- production readiness;
- enterprise-scale capacity;
- high availability beyond the tested topology;
- performance under untested workloads.

Claims must remain proportional to evidence.

### 15.25 Processing Validation Guarantees

At the processing-validation boundary, the architecture requires the following guarantees:

- critical processing guarantees are validated through controlled tests;
- normal-path behavior is demonstrated before failure scenarios are interpreted;
- failure injection is deliberate and reproducible where practical;
- idempotency is tested through repeated delivery or execution;
- offset and Bronze durability ordering is validated directly;
- incomplete persistence does not appear as valid final output;
- contract evolution is tested beyond registry acceptance;
- transformation correctness is tested independently from job completion;
- critical quality failures are proven to block certification;
- reconciliation detects intentional discrepancies;
- Certified Gold publication is validated from the consumer perspective;
- replay, backfill, reprocessing, and recovery preserve traceability and correctness;
- backlog recovery demonstrates actual catch-up capacity;
- SLO compliance is measured from source commit to Certified Gold publication;
- capacity claims remain bounded by tested conditions;
- at least one representative Sales flow demonstrates end-to-end lineage;
- evidence preserves enough context to support architectural claims;
- failed tests remain valid evidence and may drive architectural evolution.

These guarantees complete the processing model by connecting architectural intent to implementation, measurement, validation, and demonstrable evidence.