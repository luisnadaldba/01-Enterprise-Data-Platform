# Atlas Engineering — Capture Strategy

**Project:** Atlas Engineering — Enterprise Data Platform  
**Source System:** AtlasCommerce  
**Initial Domain:** `AtlasCommerce.sales`  
**Document Version:** V1  
**Status:** Approved  

---

## Table of Contents

- [1. Purpose](#1-purpose)

- [2. Scope](#2-scope)
    - [2.1 Initial Domain](#21-initial-domain)
    - [2.2 Capture Mechanisms in Scope](#22-capture-mechanisms-in-scope)
        - [SQL Server Change Data Capture](#sql-server-change-data-capture)
        - [Timestamp Incremental Capture](#timestamp-incremental-capture)
        - [Snapshot + Diff](#snapshot--diff)
        - [Controlled Full Refresh](#controlled-full-refresh)
    - [2.3 Initial Backfill and Ongoing Capture](#23-initial-backfill-and-ongoing-capture)
    - [2.4 Operational Protection of the Source](#24-operational-protection-of-the-source)
    - [2.5 Out of Scope](#25-out-of-scope)
    - [2.6 Evidence Boundary](#26-evidence-boundary)

- [3. Capture Strategy Principles](#3-capture-strategy-principles)
    - [3.1 Source Characteristics Drive the Capture Mechanism](#31-source-characteristics-drive-the-capture-mechanism)
    - [3.2 Capture Changes Only When Change History Is Required](#32-capture-changes-only-when-change-history-is-required)
    - [3.3 DELETE Detection Must Be an Explicit Requirement](#33-delete-detection-must-be-an-explicit-requirement)
    - [3.4 A Watermark Must Be Reliable, Not Merely Present](#34-a-watermark-must-be-reliable-not-merely-present)
    - [3.5 Prefer the Simplest Mechanism That Satisfies the Requirement](#35-prefer-the-simplest-mechanism-that-satisfies-the-requirement)
    - [3.6 Protect the OLTP Source](#36-protect-the-oltp-source)
    - [3.7 Protect Future Changes Before Loading Historical Data](#37-protect-future-changes-before-loading-historical-data)
    - [3.8 Prefer Controlled Overlap to Silent Gaps](#38-prefer-controlled-overlap-to-silent-gaps)
    - [3.9 Capture Retention Is a Recovery Requirement](#39-capture-retention-is-a-recovery-requirement)
    - [3.10 Freshness and Recovery Window Are Different Requirements](#310-freshness-and-recovery-window-are-different-requirements)
    - [3.11 Source Physical Operations Must Preserve Data Semantics](#311-source-physical-operations-must-preserve-data-semantics)
    - [3.12 Do Not Invent Historical Events](#312-do-not-invent-historical-events)
    - [3.13 Capture Is Not Permanent Historical Storage](#313-capture-is-not-permanent-historical-storage)
    - [3.14 Evidence Overrides Initial Hypothesis](#314-evidence-overrides-initial-hypothesis)
    - [3.15 Capture Decisions Must Remain Explicit and Reviewable](#315-capture-decisions-must-remain-explicit-and-reviewable)

- [4. Source Change Classification](#4-source-change-classification)
    - [4.1 Why Source Classification Matters](#41-why-source-classification-matters)
    - [4.2 Classification Is Not the Capture Mechanism](#42-classification-is-not-the-capture-mechanism)
    - [4.3 Category A — High Change](#43-category-a--high-change)
    - [4.4 Category B — Occasional Change](#44-category-b--occasional-change)
    - [4.5 Category C — Reference](#45-category-c--reference)
    - [4.6 Category D — Low Change / No Watermark](#46-category-d--low-change--no-watermark)
    - [4.7 Current V1 Classification Matrix](#47-current-v1-classification-matrix)
    - [4.8 Classification Can Change](#48-classification-can-change)
    - [4.9 Classification Must Be Revalidated During Implementation](#49-classification-must-be-revalidated-during-implementation)
    - [4.10 Classification Summary](#410-classification-summary)

- [5. Capture Mechanism Selection Criteria](#5-capture-mechanism-selection-criteria)
    - [5.1 Change Frequency](#51-change-frequency)
    - [5.2 Latency Requirement](#52-latency-requirement)
    - [5.3 Data Volume](#53-data-volume)
    - [5.4 Tolerance to Missing Changes](#54-tolerance-to-missing-changes)
    - [5.5 Reliable Watermark Availability](#55-reliable-watermark-availability)
    - [5.6 DELETE Detection Requirement](#56-delete-detection-requirement)
    - [5.7 Operational Overhead](#57-operational-overhead)
    - [5.8 Criteria Are Interdependent](#58-criteria-are-interdependent)
    - [5.9 Selection Questions](#59-selection-questions)
    - [5.10 Mechanism Decision Model](#510-mechanism-decision-model)
    - [5.11 Mechanism Comparison](#511-mechanism-comparison)
    - [5.12 Selection Is Followed by Validation](#512-selection-is-followed-by-validation)
    - [5.13 Decision Record for Each Source](#513-decision-record-for-each-source)
    - [5.14 Selection Principle](#514-selection-principle)

- [6. CDC Strategy](#6-cdc-strategy)
    - [6.1 Applicable Tables](#61-applicable-tables)
    - [6.2 Rationale](#62-rationale)
        - [Change-Oriented Capture](#change-oriented-capture)
        - [OLTP Protection](#oltp-protection)
    - [6.3 SQL Server CDC Capture Model](#63-sql-server-cdc-capture-model)
    - [6.4 CDC Is Asynchronous](#64-cdc-is-asynchronous)
    - [6.5 LSN as a Capture Boundary Concept](#65-lsn-as-a-capture-boundary-concept)
    - [6.6 Transaction Context Matters](#66-transaction-context-matters)
    - [6.7 DELETE Detection](#67-delete-detection)
    - [6.8 Cascading DELETE Semantics](#68-cascading-delete-semantics)
    - [6.9 CDC Recovery Window](#69-cdc-recovery-window)
    - [6.10 CDC Retention Is Not Historical Storage](#610-cdc-retention-is-not-historical-storage)
    - [6.11 Freshness and CDC Retention](#611-freshness-and-cdc-retention)
    - [6.12 Cleanup Is Part of CDC Operations](#612-cleanup-is-part-of-cdc-operations)
    - [6.13 Partition Switch Governance](#613-partition-switch-governance)
    - [6.14 SWITCH IN Governance](#614-switch-in-governance)
    - [6.15 SWITCH OUT Governance](#615-switch-out-governance)
    - [6.16 Initial Backfill](#616-initial-backfill)
    - [6.17 CDC Cutover Strategy](#617-cdc-cutover-strategy)
    - [6.18 Do Not Manufacture Pre-CDC History](#618-do-not-manufacture-pre-cdc-history)
    - [6.19 CDC Strategy and Future Debezium Integration](#619-cdc-strategy-and-future-debezium-integration)
    - [6.20 Current Validation Boundary](#620-current-validation-boundary)
    - [6.21 CDC Strategy Summary](#621-cdc-strategy-summary)

- [7. Timestamp Incremental Strategy](#7-timestamp-incremental-strategy)
    - [7.1 Applicable Tables](#71-applicable-tables)
    - [7.2 Watermark Requirements](#72-watermark-requirements)
        - [7.2.1 Relevant Changes Must Update the Watermark](#721-relevant-changes-must-update-the-watermark)
        - [7.2.2 Watermark Precision Must Be Sufficient](#722-watermark-precision-must-be-sufficient)
        - [7.2.3 Multiple Rows May Share the Same Watermark](#723-multiple-rows-may-share-the-same-watermark)
        - [7.2.4 Watermark Values Must Not Move Backward Unexpectedly](#724-watermark-values-must-not-move-backward-unexpectedly)
    - [7.3 Commit Order and Timestamp Order](#73-commit-order-and-timestamp-order)
    - [7.4 `>` Versus `>=` Boundary Semantics](#74--versus--boundary-semantics)
    - [7.5 Watermark and Checkpoint Are Related but Different](#75-watermark-and-checkpoint-are-related-but-different)
    - [7.6 Rationale](#76-rationale)
    - [7.7 DELETE Limitation](#77-delete-limitation)
    - [7.8 Soft DELETE Consideration](#78-soft-delete-consideration)
    - [7.9 Created Timestamp Is Usually Not Enough for UPDATE Capture](#79-created-timestamp-is-usually-not-enough-for-update-capture)
    - [7.10 Application-Managed Timestamps Require Extra Caution](#710-application-managed-timestamps-require-extra-caution)
    - [7.11 Full Extraction Predicate Must Be Sargable Where Possible](#711-full-extraction-predicate-must-be-sargable-where-possible)
    - [7.12 Incremental Extraction Frequency](#712-incremental-extraction-frequency)
    - [7.13 Failed Extraction and Checkpoint Safety](#713-failed-extraction-and-checkpoint-safety)
    - [7.14 Late Visibility Must Be Investigated](#714-late-visibility-must-be-investigated)
    - [7.15 Lookback Windows as a Possible Mitigation](#715-lookback-windows-as-a-possible-mitigation)
    - [7.16 Timestamp Incremental Is State-Oriented Change Discovery](#716-timestamp-incremental-is-state-oriented-change-discovery)
    - [7.17 Intermediate Changes May Be Lost](#717-intermediate-changes-may-be-lost)
    - [7.18 Timestamp Incremental and Historical Backfill](#718-timestamp-incremental-and-historical-backfill)
    - [7.19 Candidate Validation Tests](#719-candidate-validation-tests)
    - [7.20 Current Validation State](#720-current-validation-state)
    - [7.21 Rationale Summary](#721-rationale-summary)

- [8. Snapshot and Diff Strategy](#8-snapshot-and-diff-strategy)
    - [8.1 Applicable Tables](#81-applicable-tables)
    - [8.2 Rationale](#82-rationale)
    - [8.3 Change Detection](#83-change-detection)
    - [8.4 Set-Based Mental Model](#84-set-based-mental-model)
    - [8.5 Snapshot Is State, Not Event History](#85-snapshot-is-state-not-event-history)
    - [8.6 Snapshot Frequency Determines Visibility](#86-snapshot-frequency-determines-visibility)
    - [8.7 Reliable Comparison Key](#87-reliable-comparison-key)
    - [8.8 Addition Detection](#88-addition-detection)
    - [8.9 Removal Detection](#89-removal-detection)
    - [8.10 Unchanged Rows](#810-unchanged-rows)
    - [8.11 Full Snapshot Must Be Complete](#811-full-snapshot-must-be-complete)
    - [8.12 Empty Snapshot Is a Dangerous State](#812-empty-snapshot-is-a-dangerous-state)
    - [8.13 Snapshot Validation](#813-snapshot-validation)
    - [8.14 Previous Snapshot Is Operational State](#814-previous-snapshot-is-operational-state)
    - [8.15 Snapshot Promotion](#815-snapshot-promotion)
    - [8.16 First Snapshot Has No Previous State](#816-first-snapshot-has-no-previous-state)
    - [8.17 Initial Baseline Versus Ongoing Diff](#817-initial-baseline-versus-ongoing-diff)
    - [8.18 Controlled Overlap and Reprocessing](#818-controlled-overlap-and-reprocessing)
    - [8.19 Snapshot Consistency](#819-snapshot-consistency)
    - [8.20 Snapshot Size and Source Cost](#820-snapshot-size-and-source-cost)
    - [8.21 Snapshot and Diff Versus Full Refresh](#821-snapshot-and-diff-versus-full-refresh)
    - [8.22 Snapshot and Diff Versus Timestamp Incremental](#822-snapshot-and-diff-versus-timestamp-incremental)
    - [8.23 Snapshot and Diff Versus CDC](#823-snapshot-and-diff-versus-cdc)
    - [8.24 Removal Does Not Equal Business Deletion](#824-removal-does-not-equal-business-deletion)
    - [8.25 Time Semantics](#825-time-semantics)
    - [8.26 Hash-Based Comparison as a Future Technique](#826-hash-based-comparison-as-a-future-technique)
    - [8.27 Schema Changes Must Be Governed](#827-schema-changes-must-be-governed)
    - [8.28 Candidate Implementation Flow](#828-candidate-implementation-flow)
    - [8.29 Candidate Validation Tests](#829-candidate-validation-tests)
    - [8.30 Current Validation State](#830-current-validation-state)
    - [8.31 Rationale Summary](#831-rationale-summary)

- [9. Controlled Full Refresh Strategy](#9-controlled-full-refresh-strategy)
    - [9.1 Applicable Tables](#91-applicable-tables)
    - [9.2 Rationale](#92-rationale)
    - [9.3 Current State Versus Change History](#93-current-state-versus-change-history)
    - [9.4 Why CDC Is Not Selected](#94-why-cdc-is-not-selected)
    - [9.5 Why Timestamp Incremental Is Not Preferred](#95-why-timestamp-incremental-is-not-preferred)
    - [9.6 Why Snapshot and Diff Is Not Required](#96-why-snapshot-and-diff-is-not-required)
    - [9.7 Complete Source Extraction](#97-complete-source-extraction)
    - [9.8 Full Refresh Does Not Mean Uncontrolled Replacement](#98-full-refresh-does-not-mean-uncontrolled-replacement)
    - [9.9 Candidate State and Accepted State](#99-candidate-state-and-accepted-state)
    - [9.10 Refresh Boundaries](#910-refresh-boundaries)
    - [9.11 Failed Refresh Must Preserve the Previous Good State](#911-failed-refresh-must-preserve-the-previous-good-state)
    - [9.12 Empty Result Protection](#912-empty-result-protection)
    - [9.13 Reference Validation](#913-reference-validation)
    - [9.14 Detecting Legitimate Reference Changes](#914-detecting-legitimate-reference-changes)
    - [9.15 Added Reference Values](#915-added-reference-values)
    - [9.16 Modified Reference Values](#916-modified-reference-values)
    - [9.17 Removed Reference Values](#917-removed-reference-values)
    - [9.18 Reference Integrity and Transactional History](#918-reference-integrity-and-transactional-history)
    - [9.19 Authoritative Current State](#919-authoritative-current-state)
    - [9.20 Refresh Frequency](#920-refresh-frequency)
    - [9.21 Full Refresh and the Platform Freshness SLO](#921-full-refresh-and-the-platform-freshness-slo)
    - [9.22 Full Refresh and Initial Load](#922-full-refresh-and-initial-load)
    - [9.23 No Historical Event Invention](#923-no-historical-event-invention)
    - [9.24 Controlled Promotion](#924-controlled-promotion)
    - [9.25 Refresh Idempotency](#925-refresh-idempotency)
    - [9.26 Failure and Retry Model](#926-failure-and-retry-model)
    - [9.27 Current-State Disappearance Versus Historical DELETE Event](#927-current-state-disappearance-versus-historical-delete-event)
    - [9.28 Schema Evolution](#928-schema-evolution)
    - [9.29 Controlled Full Refresh Is Not `SELECT *`](#929-controlled-full-refresh-is-not-select-)
    - [9.30 Candidate Validation Tests](#930-candidate-validation-tests)
    - [9.31 Current Validation State](#931-current-validation-state)
    - [9.32 Rationale Summary](#932-rationale-summary)

- [10. Initial Backfill and Cutover Strategy](#10-initial-backfill-and-cutover-strategy)
    - [10.1 Initial State](#101-initial-state)
        - [10.1.1 Backfill Represents Known State](#1011-backfill-represents-known-state)
        - [10.1.2 Existing Data Is Still Business History](#1012-existing-data-is-still-business-history)
        - [10.1.3 Candidate Ingestion Provenance](#1013-candidate-ingestion-provenance)
    - [10.2 Capture Boundary](#102-capture-boundary)
        - [10.2.1 CDC Boundary](#1021-cdc-boundary)
        - [10.2.2 Timestamp Incremental Boundary](#1022-timestamp-incremental-boundary)
        - [10.2.3 Snapshot and Diff Boundary](#1023-snapshot-and-diff-boundary)
        - [10.2.4 Controlled Full Refresh Boundary](#1024-controlled-full-refresh-boundary)
    - [10.3 Controlled Overlap](#103-controlled-overlap)
        - [10.3.1 Why Overlap Is Safer](#1031-why-overlap-is-safer)
        - [10.3.2 Overlap Must Be Deliberate](#1032-overlap-must-be-deliberate)
    - [10.4 Historical State Limitations](#104-historical-state-limitations)
        - [10.4.1 Current Historical Row Versus Historical Event](#1041-current-historical-row-versus-historical-event)
        - [10.4.2 Capture Boundary Creates an Evidence Boundary](#1042-capture-boundary-creates-an-evidence-boundary)
        - [10.4.3 Absence of Evidence Must Remain Absence of Evidence](#1043-absence-of-evidence-must-remain-absence-of-evidence)
    - [10.5 Protect the Future First](#105-protect-the-future-first)
    - [10.6 Example of an Unsafe Cutover](#106-example-of-an-unsafe-cutover)
    - [10.7 Example of the Preferred Cutover](#107-example-of-the-preferred-cutover)
    - [10.8 Backfill Is Not Required to Be Real-Time](#108-backfill-is-not-required-to-be-real-time)
    - [10.9 Backfill Must Protect the OLTP Source](#109-backfill-must-protect-the-oltp-source)
    - [10.10 Restored Copy as a Backfill Option](#1010-restored-copy-as-a-backfill-option)
    - [10.11 Backfill Ordering](#1011-backfill-ordering)
    - [10.12 Backfill Segmentation](#1012-backfill-segmentation)
    - [10.13 Backfill Checkpointing](#1013-backfill-checkpointing)
    - [10.14 Ongoing Capture During Backfill](#1014-ongoing-capture-during-backfill)
    - [10.15 Example of Controlled Overlap](#1015-example-of-controlled-overlap)
    - [10.16 Overlap Does Not Mean CDC Should Be Discarded](#1016-overlap-does-not-mean-cdc-should-be-discarded)
    - [10.17 Reconciliation](#1017-reconciliation)
    - [10.18 Counts Are Useful but Not Sufficient](#1018-counts-are-useful-but-not-sufficient)
    - [10.19 Business Aggregates as Reconciliation Evidence](#1019-business-aggregates-as-reconciliation-evidence)
    - [10.20 Cutover Completion Criteria](#1020-cutover-completion-criteria)
    - [10.21 Steady State](#1021-steady-state)
    - [10.22 Recovery During Cutover](#1022-recovery-during-cutover)
    - [10.23 CDC Cleanup During Backfill](#1023-cdc-cleanup-during-backfill)
    - [10.24 Capture Boundary Must Be Recorded](#1024-capture-boundary-must-be-recorded)
    - [10.25 Backfill Must Be Repeatable](#1025-backfill-must-be-repeatable)
    - [10.26 Backfill and Bronze](#1026-backfill-and-bronze)
    - [10.27 Backfill Does Not Extend CDC Backward](#1027-backfill-does-not-extend-cdc-backward)
    - [10.28 Mechanism-Specific Cutover Must Be Tested](#1028-mechanism-specific-cutover-must-be-tested)
    - [10.29 Candidate Cutover Validation Tests](#1029-candidate-cutover-validation-tests)
    - [10.30 Current Validation State](#1030-current-validation-state)
    - [10.31 Strategy Summary](#1031-strategy-summary)

- [11. Capture Strategy Matrix](#11-capture-strategy-matrix)
    - [11.1 V1 Capture Strategy Matrix](#111-v1-capture-strategy-matrix)
    - [11.2 Reading the Matrix Correctly](#112-reading-the-matrix-correctly)
    - [11.3 Mechanism Mental Model](#113-mechanism-mental-model)
    - [11.4 Transactional Sources](#114-transactional-sources)
    - [11.5 Descriptive Sources](#115-descriptive-sources)
    - [11.6 Relationship Source](#116-relationship-source)
    - [11.7 Reference Sources](#117-reference-sources)
    - [11.8 DELETE Semantics by Mechanism](#118-delete-semantics-by-mechanism)
        - [CDC](#cdc)
        - [Timestamp Incremental](#timestamp-incremental)
        - [Snapshot + Diff](#snapshot--diff-1)
        - [Controlled Full Refresh](#controlled-full-refresh-1)
    - [11.9 Watermark Dependency Matrix](#119-watermark-dependency-matrix)
    - [11.10 Change Fidelity Matrix](#1110-change-fidelity-matrix)
    - [11.11 Initial-State Behavior](#1111-initial-state-behavior)
    - [11.12 Recovery Considerations](#1112-recovery-considerations)
        - [CDC](#cdc-1)
        - [Timestamp Incremental](#timestamp-incremental-1)
        - [Snapshot + Diff](#snapshot--diff-2)
        - [Controlled Full Refresh](#controlled-full-refresh-2)
    - [11.13 Operational Complexity Comparison](#1113-operational-complexity-comparison)
    - [11.14 OLTP Protection View](#1114-oltp-protection-view)
    - [11.15 Validation Status Model](#1115-validation-status-model)
    - [11.16 End-to-End Boundary](#1116-end-to-end-boundary)
    - [11.17 Matrix Review Triggers](#1117-matrix-review-triggers)
    - [11.18 New Source Assessment](#1118-new-source-assessment)
    - [11.19 V1 Consolidated View](#1119-v1-consolidated-view)
    - [11.20 Matrix Summary](#1120-matrix-summary)

- [12. Trade-offs and Accepted Limitations](#12-trade-offs-and-accepted-limitations)
    - [12.1 Heterogeneous Capture Is Intentional](#121-heterogeneous-capture-is-intentional)
    - [12.2 CDC Retention Is Finite](#122-cdc-retention-is-finite)
    - [12.3 CDC Does Not Reconstruct Pre-Enable History](#123-cdc-does-not-reconstruct-pre-enable-history)
    - [12.4 Backfill Provides State, Not Complete Historical Evolution](#124-backfill-provides-state-not-complete-historical-evolution)
    - [12.5 Timestamp Incremental Depends on Source Semantics](#125-timestamp-incremental-depends-on-source-semantics)
    - [12.6 Timestamp Incremental Does Not Inherently Detect Hard DELETE](#126-timestamp-incremental-does-not-inherently-detect-hard-delete)
    - [12.7 Timestamp Incremental May Not Preserve Intermediate States](#127-timestamp-incremental-may-not-preserve-intermediate-states)
    - [12.8 Timestamp Boundaries Can Require Controlled Overlap](#128-timestamp-boundaries-can-require-controlled-overlap)
    - [12.9 Snapshot and Diff Captures Net State Difference](#129-snapshot-and-diff-captures-net-state-difference)
    - [12.10 Snapshot Frequency Limits Temporal Precision](#1210-snapshot-frequency-limits-temporal-precision)
    - [12.11 Snapshot Completeness Is Critical](#1211-snapshot-completeness-is-critical)
    - [12.12 Snapshot and Diff Requires Previous Accepted State](#1212-snapshot-and-diff-requires-previous-accepted-state)
    - [12.13 Controlled Full Refresh Does Not Preserve Source Event History](#1213-controlled-full-refresh-does-not-preserve-source-event-history)
    - [12.14 Full Refresh Can Temporarily Lag Source State](#1214-full-refresh-can-temporarily-lag-source-state)
    - [12.15 Full Refresh Simplicity Depends on Source Size](#1215-full-refresh-simplicity-depends-on-source-size)
    - [12.16 Current Row Counts Are Not Permanent Contracts](#1216-current-row-counts-are-not-permanent-contracts)
    - [12.17 CDC Transaction Context Does Not Prove Downstream Atomicity](#1217-cdc-transaction-context-does-not-prove-downstream-atomicity)
    - [12.18 Application Action Does Not Equal CDC Row Count](#1218-application-action-does-not-equal-cdc-row-count)
    - [12.19 Partition SWITCH Is Not Ordinary Row-Level CDC](#1219-partition-switch-is-not-ordinary-row-level-cdc)
    - [12.20 SWITCH OUT Is Not a Business DELETE](#1220-switch-out-is-not-a-business-delete)
    - [12.21 SWITCH IN Is Not the Normal Ingestion Path](#1221-switch-in-is-not-the-normal-ingestion-path)
    - [12.22 Asynchronous CDC Introduces Visibility Delay](#1222-asynchronous-cdc-introduces-visibility-delay)
    - [12.23 Laboratory Timing Is Not an SLO](#1223-laboratory-timing-is-not-an-slo)
    - [12.24 Recovery and Freshness Are Different Dimensions](#1224-recovery-and-freshness-are-different-dimensions)
    - [12.25 More Retention Means More Source-Side Storage](#1225-more-retention-means-more-source-side-storage)
    - [12.26 Downstream Idempotency Is Required but Not Yet Proven](#1226-downstream-idempotency-is-required-but-not-yet-proven)
    - [12.27 Exactly-Once Is Not Claimed](#1227-exactly-once-is-not-claimed)
    - [12.28 Source Capture Cannot Solve All Downstream Semantics](#1228-source-capture-cannot-solve-all-downstream-semantics)
    - [12.29 Capture Does Not Own Permanent Historical Storage](#1229-capture-does-not-own-permanent-historical-storage)
    - [12.30 Capture Cannot Guarantee Recovery Without Checkpoints](#1230-capture-cannot-guarantee-recovery-without-checkpoints)
    - [12.31 Capture Strategy Does Not Eliminate Reconciliation](#1231-capture-strategy-does-not-eliminate-reconciliation)
    - [12.32 Reconciliation May Need Multiple Evidence Types](#1232-reconciliation-may-need-multiple-evidence-types)
    - [12.33 Source Availability Remains a Dependency](#1233-source-availability-remains-a-dependency)
    - [12.34 Schema Evolution Can Break Capture Assumptions](#1234-schema-evolution-can-break-capture-assumptions)
    - [12.35 Mechanism Decisions Are Revisable](#1235-mechanism-decisions-are-revisable)
    - [12.36 Operational Simplicity Is a Requirement](#1236-operational-simplicity-is-a-requirement)
    - [12.37 Simplicity Must Not Override Correctness](#1237-simplicity-must-not-override-correctness)
    - [12.38 Accepted V1 Trade-off Summary](#1238-accepted-v1-trade-off-summary)
    - [12.39 What V1 Explicitly Does Not Claim](#1239-what-v1-explicitly-does-not-claim)
    - [12.40 Accepted Limitation Governance](#1240-accepted-limitation-governance)
    - [12.41 Trade-off Principle](#1241-trade-off-principle)

- [13. Strategy Boundaries](#13-strategy-boundaries)
    - [13.1 Included Responsibility](#131-included-responsibility)
    - [13.2 Source Acquisition Is the Boundary](#132-source-acquisition-is-the-boundary)
    - [13.3 CDC Capture Versus CDC Consumption](#133-cdc-capture-versus-cdc-consumption)
    - [13.4 CDC Functions Are Consumption Concerns](#134-cdc-functions-are-consumption-concerns)
    - [13.5 Checkpoint Implementation Is Outside This Strategy](#135-checkpoint-implementation-is-outside-this-strategy)
    - [13.6 Kafka Offset Is Not a Source Capture Boundary](#136-kafka-offset-is-not-a-source-capture-boundary)
    - [13.7 Debezium Is Outside the Source Capture Decision](#137-debezium-is-outside-the-source-capture-decision)
    - [13.8 Kafka Delivery Semantics Are Outside This Strategy](#138-kafka-delivery-semantics-are-outside-this-strategy)
    - [13.9 Source Transaction Context Does Not Define Kafka Atomicity](#139-source-transaction-context-does-not-define-kafka-atomicity)
    - [13.10 Bronze Persistence Is Outside This Strategy](#1310-bronze-persistence-is-outside-this-strategy)
    - [13.11 Capture Retention Is Not Bronze Retention](#1311-capture-retention-is-not-bronze-retention)
    - [13.12 Atomic Bronze Persistence Is Outside This Strategy](#1312-atomic-bronze-persistence-is-outside-this-strategy)
    - [13.13 Silver Responsibilities Are Outside This Strategy](#1313-silver-responsibilities-are-outside-this-strategy)
    - [13.14 End-to-End Idempotency Is Outside This Strategy](#1314-end-to-end-idempotency-is-outside-this-strategy)
    - [13.15 Exactly-Once Is Outside This Strategy](#1315-exactly-once-is-outside-this-strategy)
    - [13.16 Silver Business Semantics Are Outside This Strategy](#1316-silver-business-semantics-are-outside-this-strategy)
    - [13.17 Gold Modeling Is Outside This Strategy](#1317-gold-modeling-is-outside-this-strategy)
    - [13.18 Historical Dimension Management Is Outside This Strategy](#1318-historical-dimension-management-is-outside-this-strategy)
    - [13.19 Power BI Is Outside This Strategy](#1319-power-bi-is-outside-this-strategy)
    - [13.20 Airflow Orchestration Is Outside This Strategy](#1320-airflow-orchestration-is-outside-this-strategy)
    - [13.21 Observability Implementation Is Outside This Strategy](#1321-observability-implementation-is-outside-this-strategy)
    - [13.22 Data Catalog and Metadata Platform Are Outside This Strategy](#1322-data-catalog-and-metadata-platform-are-outside-this-strategy)
    - [13.23 Schema Registry Is Outside This Strategy](#1323-schema-registry-is-outside-this-strategy)
    - [13.24 Capture Strategy Does Not Define the Physical Message Path](#1324-capture-strategy-does-not-define-the-physical-message-path)
    - [13.25 Recovery Is Shared Across Architectural Layers](#1325-recovery-is-shared-across-architectural-layers)
    - [13.26 Replay Is Outside the Capture Strategy](#1326-replay-is-outside-the-capture-strategy)
    - [13.27 Reconciliation Extends Beyond Capture](#1327-reconciliation-extends-beyond-capture)
    - [13.28 Performance Beyond the Source Boundary Is Separate](#1328-performance-beyond-the-source-boundary-is-separate)
    - [13.29 Platform Freshness Is End-to-End](#1329-platform-freshness-is-end-to-end)
    - [13.30 Security Beyond Source Access Is Outside This Strategy](#1330-security-beyond-source-access-is-outside-this-strategy)
    - [13.31 Data Quality Is Broader Than Capture Correctness](#1331-data-quality-is-broader-than-capture-correctness)
    - [13.32 Source Defects Are Not Automatically Capture Defects](#1332-source-defects-are-not-automatically-capture-defects)
    - [13.33 Capture Strategy Ends Before Business Transformation](#1333-capture-strategy-ends-before-business-transformation)
    - [13.34 Boundary by Mechanism](#1334-boundary-by-mechanism)
    - [13.35 What This Document May Reference](#1335-what-this-document-may-reference)
    - [13.36 What This Document Must Not Claim](#1336-what-this-document-must-not-claim)
    - [13.37 Responsibility Handoff](#1337-responsibility-handoff)
    - [13.38 Current Atlas Engineering Boundary](#1338-current-atlas-engineering-boundary)
    - [13.39 Strategy Boundary Summary](#1339-strategy-boundary-summary)

- [14. Decision Summary](#14-decision-summary)
    - [14.1 Approved V1 Source Classification](#141-approved-v1-source-classification)
    - [14.2 Approved V1 Mechanism Selection](#142-approved-v1-mechanism-selection)
    - [14.3 CDC Decision](#143-cdc-decision)
    - [14.4 CDC Evidence Currently Available](#144-cdc-evidence-currently-available)
    - [14.5 CDC Recovery Window Decision](#145-cdc-recovery-window-decision)
    - [14.6 CDC Partition SWITCH Decision](#146-cdc-partition-switch-decision)
    - [14.7 Timestamp Incremental Decision](#147-timestamp-incremental-decision)
    - [14.8 Timestamp Incremental Validation Requirement](#148-timestamp-incremental-validation-requirement)
    - [14.9 Timestamp Incremental Fidelity Decision](#149-timestamp-incremental-fidelity-decision)
    - [14.10 Snapshot and Diff Decision](#1410-snapshot-and-diff-decision)
    - [14.11 Snapshot and Diff Evidence Semantics](#1411-snapshot-and-diff-evidence-semantics)
    - [14.12 Snapshot Safety Decision](#1412-snapshot-safety-decision)
    - [14.13 Controlled Full Refresh Decision](#1413-controlled-full-refresh-decision)
    - [14.14 Controlled Refresh Safety Decision](#1414-controlled-refresh-safety-decision)
    - [14.15 Initial Backfill Decision](#1415-initial-backfill-decision)
    - [14.16 Cutover Decision](#1416-cutover-decision)
    - [14.17 Historical Evidence Decision](#1417-historical-evidence-decision)
    - [14.18 Delivery Guarantee Decision](#1418-delivery-guarantee-decision)
    - [14.19 Source Protection Decision](#1419-source-protection-decision)
    - [14.20 Capture Evidence Model](#1420-capture-evidence-model)
    - [14.21 Approved V1 Matrix](#1421-approved-v1-matrix)
    - [14.22 Current Maturity State](#1422-current-maturity-state)
    - [14.23 Strategy Review Triggers](#1423-strategy-review-triggers)
    - [14.24 Decision Change Procedure](#1424-decision-change-procedure)
    - [14.25 Strategy Is Versioned, Not Permanent](#1425-strategy-is-versioned-not-permanent)
    - [14.26 Decision Versus Implementation Documentation](#1426-decision-versus-implementation-documentation)
    - [14.27 Next Implementation Boundary](#1427-next-implementation-boundary)
    - [14.28 Final V1 Decision](#1428-final-v1-decision)
    - [14.29 Final Principles](#1429-final-principles)

---

## 1. Purpose

This document defines the V1 capture strategy used by the Atlas Engineering Data Platform to identify and acquire changes from AtlasCommerce source tables.

The strategy determines which capture mechanism is appropriate for each source based on its change behavior, operational characteristics, data requirements, and the ability of the source to reliably expose changes.

The mechanisms considered in V1 are:

- SQL Server Change Data Capture (CDC);
- timestamp-based incremental capture;
- snapshot and diff;
- controlled full refresh.

The objective is not to apply a single ingestion pattern to every source table. Different source characteristics require different mechanisms.

For each source or source category, the strategy evaluates factors such as:

- frequency of change;
- expected data volume;
- latency requirements;
- need to detect `INSERT`, `UPDATE`, and `DELETE` operations;
- availability and reliability of a watermark;
- operational overhead;
- recovery requirements;
- impact on the AtlasCommerce OLTP workload.

The strategy follows a fundamental Atlas Engineering principle:

> **The health of the OLTP system takes priority over analytical convenience.**

AtlasCommerce is the operational system responsible for producing sales. Capture mechanisms must therefore acquire the data required by the Data Engineering Platform without introducing unnecessary workloads or operational risks to the source.

This document records architectural decisions and their rationale. It does not serve as evidence that every selected mechanism has already been implemented or validated.

Implementation procedures, laboratory observations, test evidence, configuration details, and PASS/FAIL results for SQL Server CDC are documented separately in:

`AtlasEngineering-SQL-Server-CDC-Implementation.md`

The distinction maintained throughout the project is:

```text
ARCHITECTURAL DECISION
        ↓
what was selected and why

IMPLEMENTATION
        ↓
what was actually configured

EVIDENCE
        ↓
what was actually tested and observed
```

A decision documented here must not be presented as implementation evidence unless it has been independently implemented and validated.

---

## 2. Scope

This document defines the source data capture strategy for the V1 implementation of the Atlas Engineering Data Platform.

Its scope begins at the operational source boundary, where data is created or modified in AtlasCommerce, and ends with the reliable identification and acquisition of the changes required by the Data Engineering Platform.

Conceptually:

```text
AtlasCommerce
     │
     │ source data changes
     ▼
CAPTURE STRATEGY
     │
     ├── CDC
     ├── Timestamp Incremental
     ├── Snapshot + Diff
     └── Controlled Full Refresh
     │
     ▼
Changes or current state acquired
for downstream ingestion
```

The capture strategy answers the following questions:

- which source tables are required by the initial Data Engineering domain;
- how those tables change;
- whether individual changes or only the current state must be identified;
- whether `INSERT`, `UPDATE`, and `DELETE` operations must be detectable;
- whether the source provides a reliable watermark;
- what latency characteristics are required;
- which capture mechanism is appropriate for each source;
- why that mechanism was selected;
- which limitations and trade-offs are accepted;
- how existing data is handled when capture begins;
- how the transition between historical loading and ongoing capture is controlled.

### 2.1 Initial Domain

The first implementation domain is:

```text
AtlasCommerce.sales
```

The primary transactional source tables are:

```text
sales.Transaction
sales.TransactionItem
```

The initial analytical dependency map also includes:

```text
sales.TransactionStatus
sales.TransactionChannel

catalog.ProductVariant
catalog.Product
catalog.Brand
catalog.ProductCategory
catalog.Category
```

These tables do not necessarily share the same change characteristics.

For that reason, inclusion in the same analytical domain does not imply that they must use the same capture mechanism.

The capture mechanism is selected according to the characteristics and requirements of each source.

### 2.2 Capture Mechanisms in Scope

Four source capture mechanisms are defined for V1:

#### SQL Server Change Data Capture

Used for sources where individual changes must be captured with greater fidelity and where detecting operations such as hard `DELETE` is important.

In the initial domain:

```text
sales.Transaction
sales.TransactionItem
```

are assigned to this strategy.

SQL Server CDC uses information derived from the SQL Server Transaction Log to expose captured changes through CDC structures.

The detailed implementation and experimentally observed behavior of this mechanism are documented separately.

#### Timestamp Incremental Capture

Used for sources with occasional changes where a reliable timestamp-based watermark can identify rows that have changed since the previous extraction.

The V1 capture hypothesis assigns:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

to this strategy, subject to validation of the required watermark behavior during implementation.

This distinction is important:

> The mechanism has been selected as the V1 implementation hypothesis, but its operational correctness must still be validated.

#### Snapshot + Diff

Used when the source changes infrequently but does not expose a reliable watermark that can identify changed rows.

In the initial domain:

```text
catalog.ProductCategory
```

is assigned to this strategy because it is a low-change relationship source that does not expose a reliable watermark for incremental capture.

The currently identified source structure contains:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

without timestamp columns.

Because the complete relationship state can be reacquired and compared with a previously accepted state, Snapshot + Diff provides a suitable V1 mechanism for identifying additions and removals without introducing CDC solely for this source.

#### Controlled Full Refresh

Used for small reference datasets where obtaining the complete current state is simpler and operationally acceptable compared with maintaining incremental change tracking.

In the initial domain:

```text
sales.TransactionStatus
sales.TransactionChannel
```

are assigned to this strategy.

The objective is to maintain an authoritative downstream representation of their current state without introducing unnecessary capture complexity into small reference datasets.

### 2.3 Initial Backfill and Ongoing Capture

The scope also includes the transition from pre-existing source data to ongoing capture.

CDC does not reconstruct changes that occurred before its capture boundary.

Therefore, existing rows and future changes represent two different ingestion concerns:

```text
EXISTING DATA
before capture boundary
        │
        ▼
Initial Backfill
        │
        └── known current state


FUTURE CHANGES
after capture boundary
        │
        ▼
Ongoing Capture
        │
        └── observable changes
```

The V1 strategy follows the principle:

> **Protect the future first, then load the past.**

The capture boundary is established before historical data is loaded so that new changes occurring during the backfill process are not silently lost.

A controlled overlap between backfill and ongoing capture is preferable to an uncontrolled gap because overlap can be reconciled through downstream idempotency, while a silent gap can result in unrecoverable missing data.

This document defines that architectural strategy.

The implementation and validation of the final overlap, checkpoint, replay, and deduplication mechanisms remain separate implementation concerns and must not be presented as proven until they are tested.

### 2.4 Operational Protection of the Source

All capture mechanisms are constrained by the operational role of AtlasCommerce.

AtlasCommerce is the system responsible for transactional business operations. The Data Engineering Platform is a downstream consumer of that data.

Therefore:

```text
OLTP availability and performance
            >
analytical ingestion convenience
```

Capture design must avoid unnecessary source workloads, particularly when an alternative mechanism can provide the required data without materially affecting the operational system.

This principle influences decisions such as:

- using transaction-log-based CDC for high-change transactional tables;
- avoiding unnecessarily expensive repeated scans;
- using simpler mechanisms for small or slowly changing sources;
- controlling historical backfills;
- separating analytical processing from the operational database.

### 2.5 Out of Scope

This document does not define the complete downstream ingestion or processing architecture.

The following concerns are outside the responsibility of the Capture Strategy:

- Debezium implementation and configuration;
- Kafka topic design;
- Kafka partitioning;
- Kafka consumer groups;
- Kafka offset management;
- event serialization;
- Schema Registry implementation;
- Bronze persistence;
- Parquet file organization;
- Bronze microlot boundaries;
- Silver transformations;
- downstream deduplication implementation;
- end-to-end idempotency implementation;
- Gold dimensional modeling;
- Certified Gold publication;
- Power BI consumption;
- Airflow orchestration;
- end-to-end observability implementation.

These components may depend on the output of the capture layer, but they solve different architectural problems.

The boundary can be represented as:

```text
SOURCE
  │
  ▼
┌──────────────────────────────┐
│       CAPTURE STRATEGY       │
│                              │
│ How do we reliably identify  │
│ and acquire source changes   │
│ or required current state?   │
└──────────────────────────────┘
  │
  │ acquired change/state
  ▼
────────────────────────────────  ← scope boundary
  │
  ▼
INGESTION / STREAMING
  │
  ▼
BRONZE
  │
  ▼
SILVER
  │
  ▼
GOLD
```

The Capture Strategy determines how the platform obtains the required source information.

It does not determine how every downstream component subsequently transports, persists, transforms, reconciles, or publishes that information.

### 2.6 Evidence Boundary

This document records architectural strategy.

Where implementation evidence already exists, it may be referenced to demonstrate that a selected strategy has begun to be validated. However, detailed laboratory results belong to the corresponding implementation documentation.

The following distinction must always be preserved:

```text
SELECTED
≠
IMPLEMENTED
≠
TESTED
≠
PROVEN END-TO-END
```

For example:

```text
sales.Transaction
→ CDC selected
→ CDC implemented in SQL Server
→ SQL Server CDC behavior tested through M01.19
→ downstream CDC consumption not yet validated
→ Debezium behavior not yet validated
→ Kafka delivery not yet validated
→ end-to-end behavior not yet proven
```

This prevents architectural intent from being incorrectly presented as implementation evidence.

---

## 3. Capture Strategy Principles

The Atlas Engineering Capture Strategy is based on a set of principles that guide how source data is acquired by the Data Engineering Platform.

These principles exist to prevent capture mechanisms from being selected only because a technology is available, familiar, or commonly used.

The decision must begin with the characteristics of the source and the requirements of the data product.

Conceptually:

```text
SOURCE BEHAVIOR
      +
DATA REQUIREMENTS
      +
OPERATIONAL CONSTRAINTS
      ↓
CAPTURE REQUIREMENTS
      ↓
MECHANISM SELECTION
```

Technology is selected after the capture problem is understood.

### 3.1 Source Characteristics Drive the Capture Mechanism

Different source tables can represent different types of information and exhibit very different change patterns.

For example:

```text
high-volume transactional table
            ≠
occasionally changing master data
            ≠
small reference table
            ≠
relationship table without watermark
```

Using the same capture mechanism for all of them would simplify the architecture superficially, but could introduce unnecessary complexity, overhead, or gaps in change detection.

Therefore:

> **The capture mechanism must follow the behavior and requirements of the source, not the other way around.**

The initial Atlas Engineering classification reflects this principle:

```text
High Change
→ CDC

Occasional Change
→ Timestamp Incremental

Low Change / No Reliable Watermark
→ Snapshot + Diff

Reference Data
→ Controlled Full Refresh
```

This classification is a starting point for mechanism selection, not a universal rule.

A table classified as low-change, for example, should not automatically use snapshot and diff if another requirement makes that mechanism inappropriate.

The complete decision must consider multiple factors together.

### 3.2 Capture Changes Only When Change History Is Required

Not every downstream dataset requires knowledge of every individual source operation.

There are two fundamentally different questions a capture strategy may need to answer:

```text
CHANGE-ORIENTED
What happened?

STATE-ORIENTED
What is the current state?
```

A change-oriented mechanism may need to distinguish:

```text
INSERT
UPDATE
DELETE
```

and potentially preserve information about the sequence in which those changes occurred.

A state-oriented mechanism may only need to determine:

```text
What rows exist now?
What values do they contain now?
```

This distinction directly affects capture complexity.

For high-change transactional sources such as:

```text
sales.Transaction
sales.TransactionItem
```

the V1 strategy requires change-oriented capture through CDC.

For small reference sources such as:

```text
sales.TransactionStatus
sales.TransactionChannel
```

the current state is sufficient for the selected V1 capture strategy, allowing controlled full refresh to remain simple and explicit.

Therefore:

> **Do not pay the operational and architectural cost of change tracking when the requirement only needs current state.**

Conversely:

> **Do not use a state-only mechanism when individual changes must be reliably detected.**

### 3.3 DELETE Detection Must Be an Explicit Requirement

`DELETE` deserves explicit treatment because not every incremental mechanism can detect it.

Consider a timestamp-based extraction:

```text
SELECT ...
FROM SourceTable
WHERE updated_at > @last_watermark;
```

This approach can identify rows that still exist and expose a qualifying timestamp.

After a hard `DELETE`, however:

```text
row exists
    ↓
DELETE
    ↓
row no longer exists
```

There may be no source row left for a later timestamp query to retrieve.

Therefore:

```text
reliable INSERT detection
+
reliable UPDATE detection
```

does not automatically imply:

```text
reliable DELETE detection
```

The capture decision must explicitly ask:

> **If a row disappears from the source, does the downstream platform need to know that it was deleted?**

For `sales.Transaction` and `sales.TransactionItem`, DELETE detection is one of the reasons CDC is appropriate.

The Atlas Engineering laboratory has already demonstrated that SQL Server CDC can expose hard DELETE operations for these CDC-enabled sources, including DELETEs produced as effects of referential actions such as `ON DELETE CASCADE`.

The detailed evidence belongs to the CDC implementation document.

### 3.4 A Watermark Must Be Reliable, Not Merely Present

The existence of a timestamp column does not automatically make a table suitable for timestamp-based incremental capture.

A watermark is useful only if its behavior reliably represents the changes the capture process needs to discover.

Conceptually:

```text
previous checkpoint
        ↓
last_watermark = T1
        ↓
source changes
        ↓
next extraction
        ↓
rows with watermark > T1
```

For this model to work correctly, the selected watermark must satisfy the assumptions required by the extraction strategy.

Questions that must be validated include:

- is the watermark updated whenever a relevant row changes?
- can a relevant change occur without modifying the watermark?
- can multiple rows share the same watermark value?
- what precision does the watermark provide?
- can late transactions or application behavior produce values that challenge simple `>` filtering?
- can the value move backward?
- how are boundary conditions handled between extraction windows?
- how are hard DELETEs detected, if they must be detected?

Therefore:

> **A timestamp column is a candidate watermark, not proof of a reliable incremental strategy.**

This is particularly important for the V1 tables currently classified for timestamp incremental capture:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

Their classification remains an implementation hypothesis until their watermark behavior is validated.

### 3.5 Prefer the Simplest Mechanism That Satisfies the Requirement

More sophisticated capture technology is not automatically better engineering.

A mechanism introduces costs such as:

- implementation complexity;
- operational dependencies;
- monitoring requirements;
- recovery procedures;
- storage requirements;
- troubleshooting complexity;
- source overhead;
- additional failure modes.

If two mechanisms satisfy the same requirements with comparable reliability, the simpler mechanism should normally be preferred.

For example:

```text
5-row reference table
        ↓
Does the platform need every historical transition?
        │
        └── NO
             ↓
Controlled Full Refresh
```

Introducing CDC for such a source could technically work, but technical feasibility alone does not justify the additional operational complexity.

The goal is therefore not:

```text
maximize technology usage
```

but:

```text
satisfy requirements
        +
preserve reliability
        +
control operational complexity
```

### 3.6 Protect the OLTP Source

AtlasCommerce exists to execute business transactions.

The Data Engineering Platform is downstream of that responsibility.

The priority relationship is:

```text
AtlasCommerce business workload
              >
Data Engineering convenience
```

Capture processes must therefore be designed to minimize unnecessary competition with the transactional workload.

This affects:

- capture mechanism selection;
- extraction frequency;
- query patterns;
- historical backfill strategy;
- scheduling;
- source scanning;
- recovery operations;
- future scalability decisions.

A mechanism that is convenient for analytics but creates unacceptable source pressure is not an acceptable capture strategy.

For high-change transactional tables, transaction-log-based CDC provides a mechanism for identifying changes without designing the analytical ingestion process around repeated full-table extraction.

For historical backfills, large reads must also be controlled so that reconstructing analytical history does not unnecessarily compete with live transactions.

Where appropriate, isolated restored copies may be considered for heavy historical extraction rather than placing avoidable pressure on the live OLTP source.

### 3.7 Protect Future Changes Before Loading Historical Data

When capture begins on a source that already contains data, two problems exist simultaneously:

```text
PAST
existing rows

FUTURE
new changes occurring from now on
```

Loading the historical state first without protecting future changes creates a potential gap:

```text
start historical load
        ↓
new source changes occur
        ↓
historical load continues
        ↓
capture enabled later
        ↓
changes between boundaries may be lost
```

Atlas Engineering therefore adopts the principle:

> **Protect the future first, then load the past.**

Conceptually:

```text
1. establish capture boundary
        ↓
2. protect future changes
        ↓
3. load existing source state
        ↓
4. process accumulated changes
        ↓
5. reconcile controlled overlap
        ↓
6. enter normal operation
```

This does not mean that the complete implementation of this process has already been proven.

It defines the strategy that subsequent implementation and testing must validate.

### 3.8 Prefer Controlled Overlap to Silent Gaps

During transitions such as initial backfill and ongoing capture, perfect non-overlapping boundaries may be difficult or unnecessarily risky to establish.

Two failure possibilities must be distinguished:

```text
OVERLAP
same logical data may be observed more than once

GAP
some logical data may never be observed
```

With an idempotent downstream design, overlap can be identified and reconciled.

A silent gap can represent permanent data loss if the missing source state or event is no longer recoverable.

Therefore:

> **Prefer controlled, detectable duplication to silent, unrecoverable loss.**

This principle is consistent with the broader Atlas Engineering delivery decision:

```text
At-Least-Once
+
Idempotency
```

The capture strategy establishes the preference for controlled overlap.

The implementation of downstream idempotency and end-to-end duplicate protection is outside the scope of this document and must be independently validated.

### 3.9 Capture Retention Is a Recovery Requirement

A capture mechanism that retains changes for a limited period creates an operational recovery window.

For SQL Server CDC, captured changes are not intended to serve as permanent historical storage.

The V1 decision is:

```text
CDC retention
=
15 days
=
21600 minutes
```

This window was selected to provide operational recovery time for situations such as:

- weekends;
- holidays;
- extended absences;
- incidents;
- detection delay;
- diagnosis;
- repair;
- reprocessing.

The reasoning used for the initial V1 decision is:

```text
~10 days possible absence
+
~2 days detection / analysis
+
~3 days repair / reprocessing
=
~15 days recovery window
```

The purpose of this retention is not to satisfy the platform's permanent historical requirements.

The long-term architectural direction is:

```text
SQL Server CDC
→ limited operational capture / recovery window

Kafka
→ downstream event transport with
retention and replay capabilities
to be defined and validated

Bronze
→ intended durable historical
ingestion layer
```

These downstream responsibilities remain subject to their own implementation, retention policies, recovery design, and validation.

### 3.10 Freshness and Recovery Window Are Different Requirements

Capture latency and retention answer different operational questions.

Freshness asks:

> **How quickly should a committed source change become available to the downstream data product?**

Recovery window asks:

> **How long can captured changes remain available while downstream processing is unavailable or recovering?**

They must not be treated as the same requirement.

Atlas Engineering currently defines:

```text
Typical freshness target
≈ 3–5 minutes

Formal V1 end-to-end freshness SLO
P95 ≤ 15 minutes

CDC recovery window
15 days
```

Therefore:

```text
minutes
→ freshness

days
→ recovery opportunity
```

Increasing CDC retention does not make the pipeline fresher.

Reducing capture polling latency does not provide a longer recovery window.

These dimensions must be designed, measured, and operated independently.

### 3.11 Source Physical Operations Must Preserve Data Semantics

Physical database operations do not always represent logical business events.

This distinction is especially important for partitioned CDC-enabled tables.

The current transactional tables:

```text
sales.Transaction
sales.TransactionItem
```

are partitioned.

SQL Server CDC was enabled while allowing partition switching.

A known restriction exists: partition `SWITCH` operations are not represented by CDC as ordinary row-level changes.

The Atlas Engineering strategy therefore distinguishes physical data management from business semantics.

For example:

```text
historical partition
        ↓
SWITCH OUT
        ↓
physical relocation / archival
```

must not automatically be interpreted as:

```text
business transaction deleted
```

because the sale may still be valid historical business data that must remain available to the analytical platform.

The V1 decision is therefore to govern partition switching rather than disable it preventively.

Normal sales ingestion must not use `SWITCH IN` as a substitute for ordinary transactional data creation.

Future `SWITCH OUT` operations, if introduced for physical archival, must be controlled so that physical movement in the OLTP database does not incorrectly alter analytical business history.

### 3.12 Do Not Invent Historical Events

Capture systems begin observing a source at a specific point in time.

Data that existed before that boundary may reveal current state but not necessarily the sequence of historical events that produced that state.

For example, if a transaction already exists with:

```text
status = COMPLETED
```

when CDC begins, the platform may know that the transaction is currently completed.

It cannot automatically conclude that the historical sequence was:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

unless those transitions were actually captured or another authoritative source provides them.

Therefore:

> **Known current state must not be transformed into invented historical events.**

Initial backfill preserves what can be established from the source at extraction time.

Ongoing capture records changes observable after the capture boundary.

This distinction protects the historical integrity of the analytical platform.

### 3.13 Capture Is Not Permanent Historical Storage

Capture and historical persistence solve related but different problems.

A source capture mechanism answers:

```text
How can the platform identify
the data or changes it needs?
```

A historical storage layer answers:

```text
How can the platform retain
what it acquired for durable
audit, replay, and reprocessing?
```

For Atlas Engineering:

```text
SOURCE CAPTURE
      ↓
temporary / operational acquisition mechanisms
      ↓
DOWNSTREAM INGESTION
      ↓
BRONZE
      ↓
durable historical ingestion
```

CDC retention must therefore not be increased indefinitely in an attempt to turn SQL Server CDC into the platform's historical archive.

The responsibility for durable history progressively moves away from the operational source and into the Data Engineering Platform.

### 3.14 Evidence Overrides Initial Hypothesis

Capture strategy begins with assumptions derived from source structure, known requirements, and architectural analysis.

Implementation may reveal behavior that contradicts those assumptions.

When that occurs:

```text
INITIAL HYPOTHESIS
        ↓
IMPLEMENTATION
        ↓
TEST
        ↓
OBSERVED EVIDENCE
        ↓
hypothesis confirmed?
        │
        ├── YES → retain decision
        │
        └── NO  → investigate and revise
```

The governing principle is:

> **Observed evidence takes precedence over an unvalidated implementation hypothesis.**

This does not mean that a single unexpected laboratory result should automatically become a production rule.

Unexpected behavior must be investigated considering:

- SQL Server version;
- configuration;
- source design;
- test conditions;
- reproducibility;
- official product documentation where applicable.

The objective is to allow the architecture to evolve from evidence without confusing laboratory observations with universal guarantees.

### 3.15 Capture Decisions Must Remain Explicit and Reviewable

Every source included in the platform should eventually have an explicit capture decision.

The decision should make it possible to answer:

```text
What source are we capturing?

How does it change?

What changes must we detect?

Is DELETE relevant?

Is a reliable watermark available?

What latency is required?

What mechanism was selected?

Why was it selected?

What are its limitations?

How is recovery handled?

What still needs validation?
```

This information must remain version-controlled and reviewable.

A capture mechanism should never become an undocumented assumption hidden inside implementation code.

The strategy therefore acts as a contract between:

```text
SOURCE UNDERSTANDING
        ↓
ARCHITECTURAL DECISION
        ↓
IMPLEMENTATION
        ↓
VALIDATION
```

As source behavior, business requirements, or implementation evidence changes, the strategy must be reviewed rather than silently diverging from the system that actually exists.

---

## 4. Source Change Classification

A capture strategy must begin with an understanding of how each source behaves.

Tables that belong to the same analytical domain can have significantly different change patterns, volumes, operational roles, and requirements for historical change detection.

For that reason, Atlas Engineering classifies source tables before selecting or implementing their capture mechanisms.

The V1 classification model is:

```text
A — High Change
B — Occasional Change
C — Reference
D — Low Change / No Watermark
```

The classification provides a structured starting point for capture decisions.

It does not mean:

```text
classification
      =
automatic technology selection
```

Instead:

```text
source behavior
      ↓
classification
      ↓
capture requirements
      ↓
mechanism evaluation
      ↓
capture decision
      ↓
implementation
      ↓
validation
```

The classification helps organize the problem.

The final capture mechanism must still satisfy the requirements of the source.

### 4.1 Why Source Classification Matters

Without source classification, a platform can easily fall into one of two undesirable patterns.

The first is technological uniformity:

```text
CDC is available
      ↓
use CDC everywhere
```

The second is extraction uniformity:

```text
incremental queries are simple
      ↓
use timestamp extraction everywhere
```

Both approaches optimize for implementation consistency rather than source requirements.

A better approach asks:

```text
How frequently does this source change?

How much data can change?

Do individual changes matter?

Must DELETE be detected?

Does the source expose a reliable watermark?

Is current state sufficient?

What latency is required?

What source workload is acceptable?
```

Only after these questions are understood should the capture mechanism be selected.

Classification therefore reduces accidental coupling between:

```text
what the source requires
```

and:

```text
what technology happens to be available
```

### 4.2 Classification Is Not the Capture Mechanism

The distinction between classification and capture mechanism must remain explicit.

For example:

```text
CLASSIFICATION
High Change

POSSIBLE REQUIREMENT
Individual changes must be observable

SELECTED V1 MECHANISM
CDC
```

The classification describes a characteristic of the source.

The mechanism describes how the platform intends to acquire the required information.

These concepts must not be collapsed into a universal rule such as:

```text
High Change = CDC
```

because another source classified as high-change could have different requirements, database capabilities, operational constraints, or acceptable latency.

The correct interpretation is:

```text
High Change
      +
change-level visibility required
      +
DELETE detection required
      +
SQL Server source capabilities
      +
OLTP protection requirements
      ↓
CDC is appropriate
for the current V1 sources
```

This distinction allows the capture strategy to remain valid as the platform expands to new domains and potentially new source technologies.

### 4.3 Category A — High Change

Category A represents source tables expected to participate heavily in the operational transaction flow.

The V1 tables classified as High Change are:

```text
sales.Transaction
sales.TransactionItem
```

These tables form the transactional core of the initial Sales Analytics domain.

Their relationship is:

```text
sales.Transaction
        │
        └── sales.TransactionItem
```

The analytical grain defined for the initial product is:

> **One row per `sales.TransactionItem` associated with a `sales.Transaction`.**

Because these tables represent operational sales activity, their changes are materially different from occasional catalog maintenance or small reference datasets.

The capture problem is not merely:

```text
What does the table look like now?
```

It also requires the ability to identify changes occurring after the capture boundary.

The V1 mechanism selected for both tables is:

```text
SQL Server Native CDC
```

The selection supports the need to observe source changes without designing the capture process around repeated analytical scans of the transactional tables.

It also provides a mechanism capable of exposing hard DELETE operations.

This capability is particularly relevant because:

```text
sales.TransactionItem
```

has a foreign key to:

```text
sales.Transaction
```

configured with:

```text
ON DELETE CASCADE
```

The implementation laboratory has already demonstrated that a DELETE against a parent `sales.Transaction` can produce captured DELETE changes for both the parent and the affected `sales.TransactionItem` rows.

That observation validates an important part of the selected CDC strategy, but the detailed implementation evidence remains outside this document.

Classification:

```text
sales.Transaction
Category: A — High Change
V1 Capture Mechanism: CDC

sales.TransactionItem
Category: A — High Change
V1 Capture Mechanism: CDC
```

### 4.4 Category B — Occasional Change

Category B represents sources that participate in the analytical model but are not currently expected to exhibit the same change intensity as transactional sales tables.

The V1 tables classified as Occasional Change are:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

These sources provide descriptive and structural information required to interpret the transactional sales data.

Conceptually:

```text
sales.TransactionItem
        │
        ▼
catalog.ProductVariant
        │
        ▼
catalog.Product
        │
        ├── catalog.Brand
        │
        └── catalog.ProductCategory
                    │
                    ▼
             catalog.Category
```

For the Category B tables, the V1 capture hypothesis is:

```text
Timestamp Incremental
```

The reasoning is that occasional changes may not justify the operational complexity of CDC if a reliable source watermark can identify the rows requiring extraction.

The intended model is conceptually:

```text
previous watermark
        ↓
query source
        ↓
identify rows changed
after previous boundary
        ↓
acquire changed rows
        ↓
advance checkpoint
```

However, this mechanism depends on a critical assumption:

> **The selected watermark must reliably expose every relevant change that the strategy expects it to detect.**

Therefore, the presence of a column such as:

```text
created_at
updated_at
modified_at
```

would not, by itself, be sufficient evidence that timestamp incremental capture is safe.

The implementation must validate the actual watermark behavior before this strategy is considered operationally proven.

Questions that remain relevant include:

```text
Is the timestamp updated for every relevant UPDATE?

Can application logic modify data without changing it?

What timestamp precision is available?

Can multiple changes share the same timestamp?

How will extraction boundaries handle equal values?

Can DELETE be detected?

If DELETE cannot be detected directly,
does the analytical requirement require it?

Can rows arrive or commit in ways that challenge
a simple timestamp > checkpoint predicate?
```

Consequently, the current state of this classification is:

```text
catalog.Product
Category: B — Occasional Change
V1 Capture Hypothesis: Timestamp Incremental
Validation: Pending

catalog.ProductVariant
Category: B — Occasional Change
V1 Capture Hypothesis: Timestamp Incremental
Validation: Pending

catalog.Brand
Category: B — Occasional Change
V1 Capture Hypothesis: Timestamp Incremental
Validation: Pending

catalog.Category
Category: B — Occasional Change
V1 Capture Hypothesis: Timestamp Incremental
Validation: Pending
```

The word `Pending` is important.

It does not mean that the architectural decision has no rationale.

It means that the implementation assumptions required by the mechanism have not yet been experimentally validated.

### 4.5 Category C — Reference

Category C represents small reference datasets whose primary downstream requirement is the authoritative current state rather than a detailed stream of every source transition.

The V1 tables classified as Reference are:

```text
sales.TransactionStatus
sales.TransactionChannel
```

The currently known values include:

```text
sales.TransactionStatus

1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

and:

```text
sales.TransactionChannel

1 ONLINE
2 STORE
```

These datasets are fundamentally different from the transactional tables.

For the current V1 requirement, the capture question is primarily:

```text
What is the authoritative current
set of reference values?
```

rather than:

```text
What was every individual operation
that produced the current reference state?
```

The selected V1 mechanism is therefore:

```text
Controlled Full Refresh
```

Conceptually:

```text
small reference source
        ↓
read complete authoritative state
        ↓
validate
        ↓
replace / reconcile downstream representation
```

The advantage is simplicity.

Instead of introducing change-level infrastructure for a very small source, the platform can deliberately retrieve the complete reference state.

Classification:

```text
sales.TransactionStatus
Category: C — Reference
V1 Capture Mechanism: Controlled Full Refresh

sales.TransactionChannel
Category: C — Reference
V1 Capture Mechanism: Controlled Full Refresh
```

This decision should be revisited if the business meaning of these tables changes.

For example, if future requirements demand preservation of every historical reference modification as a business event, a state-oriented full refresh may no longer be sufficient.

The mechanism is therefore appropriate for the current requirement, not permanently guaranteed for every future use case.

### 4.6 Category D — Low Change / No Watermark

Category D represents sources that change infrequently but do not expose the source metadata required for a reliable incremental watermark strategy.

The V1 table classified in this category is:

```text
catalog.ProductCategory
```

Its currently identified structure contains:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

without timestamp columns.

This table represents the relationship between:

```text
Product
   ↕
Category
```

The absence of a reliable watermark creates a specific problem.

Suppose the platform stores the current relationship:

```text
Product 100
→ Category 10
```

and later the source becomes:

```text
Product 100
→ Category 20
```

Without CDC or a reliable change watermark, a query such as:

```text
WHERE updated_at > @last_watermark
```

cannot be used when no suitable watermark exists.

Because this is a low-change relationship source whose complete state can be reacquired and compared safely, the V1 strategy selects:

```text
Snapshot + Diff
```

Conceptually:

```text
PREVIOUS KNOWN SNAPSHOT
        │
        │ compare
        ▼
CURRENT SOURCE SNAPSHOT
        │
        ▼
DIFF
        │
        ├── relationship added
        ├── relationship removed
        └── relationship unchanged
```

For a relationship table, disappearance is particularly important.

Consider:

```text
Previous Snapshot
Product 100 → Category 10

Current Snapshot
Product 100 → Category 20
```

A comparison can derive:

```text
REMOVED
Product 100 → Category 10

ADDED
Product 100 → Category 20
```

The source does not need to expose an explicit DELETE event for the comparison process to detect that a previously known relationship no longer exists.

This illustrates an important distinction:

```text
CDC
→ observes changes exposed by the capture mechanism

Timestamp Incremental
→ retrieves qualifying existing rows

Snapshot + Diff
→ derives change by comparing states
```

Classification:

```text
catalog.ProductCategory
Category: D — Low Change / No Watermark
V1 Capture Mechanism: Snapshot + Diff
```

The low expected change frequency makes this strategy more reasonable than it would be for a very large, rapidly changing transactional table.

### 4.7 Current V1 Classification Matrix

The initial classification can be summarized as follows:

| Source Table | Classification | V1 Capture Strategy | Current Validation State |
|---|---|---|---|
| `sales.Transaction` | A — High Change | CDC | CDC source behavior validated through M01.19 |
| `sales.TransactionItem` | A — High Change | CDC | CDC source behavior validated through M01.19 |
| `catalog.Product` | B — Occasional Change | Timestamp Incremental | Pending implementation validation |
| `catalog.ProductVariant` | B — Occasional Change | Timestamp Incremental | Pending implementation validation |
| `catalog.Brand` | B — Occasional Change | Timestamp Incremental | Pending implementation validation |
| `catalog.Category` | B — Occasional Change | Timestamp Incremental | Pending implementation validation |
| `sales.TransactionStatus` | C — Reference | Controlled Full Refresh | Pending implementation validation |
| `sales.TransactionChannel` | C — Reference | Controlled Full Refresh | Pending implementation validation |
| `catalog.ProductCategory` | D — Low Change / No Watermark | Snapshot + Diff | Pending implementation validation |

The validation state must not be interpreted as a statement that CDC is already proven end-to-end.

For:

```text
sales.Transaction
sales.TransactionItem
```

the current evidence establishes SQL Server CDC source-side behavior through the completed M01.19 laboratory tests.

It does not yet establish:

```text
CDC consumer implementation
Debezium behavior
Kafka transaction representation
Kafka ordering
Bronze persistence
end-to-end idempotency
end-to-end recovery
production-scale performance
```

Those concerns remain subject to later implementation and testing.

### 4.8 Classification Can Change

Source classification is not immutable.

A table may need to be reclassified when any of the following changes:

- business requirements;
- source volume;
- change frequency;
- source schema;
- watermark behavior;
- DELETE requirements;
- latency requirements;
- recovery requirements;
- operational constraints;
- downstream historical requirements.

For example:

```text
REFERENCE TABLE
small + state-oriented
        ↓
Controlled Full Refresh
```

could later become:

```text
REFERENCE TABLE
frequently changing
+
historical transitions required
        ↓
re-evaluate capture mechanism
```

Similarly:

```text
OCCASIONAL CHANGE
+
apparently reliable updated_at
        ↓
Timestamp Incremental
```

could become:

```text
watermark validation fails
        ↓
Timestamp Incremental rejected
        ↓
alternative strategy required
```

The architecture must respond to evidence rather than preserve an outdated classification merely because it was documented earlier.

### 4.9 Classification Must Be Revalidated During Implementation

Classification is an architectural hypothesis about source behavior.

Implementation is where that hypothesis meets the actual system.

The expected lifecycle is:

```text
SOURCE INVENTORY
        ↓
INITIAL CLASSIFICATION
        ↓
CAPTURE STRATEGY
        ↓
IMPLEMENTATION
        ↓
CONTROLLED TESTING
        ↓
OBSERVED EVIDENCE
        ↓
        ├── confirms assumptions
        │       ↓
        │   retain strategy
        │
        └── contradicts assumptions
                ↓
            investigate
                ↓
          revise if necessary
```

This is especially important for mechanisms whose correctness depends on source behavior rather than only database capability.

Timestamp incremental capture is a clear example.

A schema can suggest:

```text
updated_at exists
```

but only implementation testing can establish whether:

```text
updated_at behaves
as required by the capture strategy
```

The same discipline applies to snapshot comparison, controlled full refresh, and future capture mechanisms.

### 4.10 Classification Summary

The V1 classification is intentionally heterogeneous:

```text
TRANSACTIONAL
sales.Transaction
sales.TransactionItem
        ↓
A — High Change
        ↓
CDC


MASTER / DESCRIPTIVE
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
B — Occasional Change
        ↓
Timestamp Incremental
        ↓
watermark validation required


REFERENCE
sales.TransactionStatus
sales.TransactionChannel
        ↓
C — Reference
        ↓
Controlled Full Refresh


RELATIONSHIP
catalog.ProductCategory
        ↓
D — Low Change / No Watermark
        ↓
Snapshot + Diff
```

This heterogeneity is intentional.

The objective of Atlas Engineering is not to minimize the number of capture mechanisms at any cost.

The objective is to use the simplest reliable mechanism that satisfies the requirements of each source while protecting the operational system.

The resulting principle is:

> **One analytical domain does not require one capture mechanism.**

The domain defines which data must work together.

The capture strategy defines the most appropriate way to acquire each part of that data.

---

## 5. Capture Mechanism Selection Criteria

Selecting a capture mechanism is a requirements-driven decision.

Atlas Engineering does not select CDC, timestamp incremental capture, snapshot and diff, or controlled full refresh based only on table size, familiarity with a technology, or architectural uniformity.

The V1 selection process evaluates seven primary criteria:

```text
1. Change Frequency
2. Latency Requirement
3. Data Volume
4. Tolerance to Missing Changes
5. Reliable Watermark Availability
6. DELETE Detection Requirement
7. Operational Overhead
```

These criteria must be evaluated together.

No single criterion automatically determines the capture mechanism.

Conceptually:

```text
SOURCE
  │
  ▼
┌───────────────────────────────────┐
│       CAPTURE REQUIREMENTS        │
│                                   │
│ Change frequency                  │
│ Latency                           │
│ Volume                            │
│ Tolerance to missing changes      │
│ Watermark reliability             │
│ DELETE detection                  │
│ Operational overhead              │
└───────────────────────────────────┘
  │
  ▼
MECHANISM EVALUATION
  │
  ├── CDC
  ├── Timestamp Incremental
  ├── Snapshot + Diff
  └── Controlled Full Refresh
  │
  ▼
SELECTED STRATEGY
```

The purpose of the criteria is not to produce a mechanical score.

Their purpose is to make the reasoning behind a capture decision explicit, reviewable, and testable.

### 5.1 Change Frequency

The first criterion evaluates how frequently the source is expected to change.

A source may be:

```text
continuously changing
        ↓
frequently changing
        ↓
occasionally changing
        ↓
rarely changing
        ↓
effectively static for long periods
```

Change frequency matters because the cost and usefulness of different capture mechanisms vary with source behavior.

For example, repeatedly retrieving the complete state of a high-change transactional table can become unnecessarily expensive.

Conversely, maintaining change-level capture infrastructure for a tiny reference dataset that changes rarely may introduce complexity without providing corresponding value.

The initial Atlas Engineering classification uses:

```text
A — High Change

B — Occasional Change

C — Reference

D — Low Change / No Watermark
```

However, change frequency alone does not determine the mechanism.

For example:

```text
LOW CHANGE
+
reliable watermark
+
incremental state sufficient
```

could lead to a different decision than:

```text
LOW CHANGE
+
no watermark
+
relationship removal must be detected
```

Therefore:

> **Change frequency provides context for the decision; it does not make the decision by itself.**

### 5.2 Latency Requirement

The second criterion evaluates how quickly a source change must become available to downstream processing.

Latency requirements can differ substantially between sources.

Conceptually:

```text
source change
     │
     ▼
capture
     │
     ▼
downstream availability
```

The acceptable delay between these points influences which mechanisms are practical.

A source requiring changes to become available within minutes has different capture requirements from a small reference dataset whose state can be refreshed periodically.

The current Atlas Engineering platform has an initial typical freshness target of:

```text
3–5 minutes
```

and a formal V1 end-to-end freshness SLO of:

```text
P95 ≤ 15 minutes
```

These values describe the broader end-to-end platform objective.

They must not be interpreted as proof that every capture mechanism or every source has already achieved that latency.

For mechanism selection, the relevant question is:

> **How quickly must changes from this particular source become observable to the downstream platform?**

The answer can affect:

- extraction frequency;
- polling frequency;
- acceptable batch interval;
- source workload;
- operational complexity;
- suitability of state-oriented refresh mechanisms.

Latency must therefore be treated as a source requirement rather than assumed to be identical for every table.

### 5.3 Data Volume

The third criterion evaluates the amount of data involved in the capture process.

Volume has several dimensions.

It can mean:

```text
total source rows
```

but also:

```text
rows changed per interval
```

and:

```text
bytes generated by those changes
```

These are not equivalent.

Consider:

```text
TABLE A
100 million rows
100 changes per day
```

versus:

```text
TABLE B
1 million rows
500,000 changes per day
```

The first table is larger in total size.

The second produces a much larger change workload.

Capture strategy must therefore distinguish:

```text
SOURCE SIZE
≠
CHANGE VOLUME
```

A full refresh repeatedly processes the current dataset.

Timestamp incremental capture attempts to process qualifying changed rows.

CDC exposes captured changes.

Snapshot and diff requires enough source state to perform comparison.

Each mechanism therefore interacts differently with source size and change volume.

For Atlas Engineering, volume must be evaluated together with the primary operational rule:

> **The capture process must not create unnecessary pressure on AtlasCommerce.**

### 5.4 Tolerance to Missing Changes

The fourth criterion evaluates the consequence of failing to observe a source change.

This is one of the most important capture requirements.

Different data may have different consequences if a change is missed.

Conceptually:

```text
source change occurs
        ↓
capture misses it
        ↓
what happens?
```

Possible consequences include:

- no meaningful analytical impact;
- temporarily stale descriptive data;
- incorrect relationship state;
- incorrect transaction state;
- missing revenue-related data;
- incorrect reconciliation;
- inability to reconstruct source history.

The question is therefore not simply:

```text
Can this mechanism retrieve data?
```

It is:

```text
Can this mechanism reliably retrieve
the changes required by this use case?
```

For transactional sales data, silent loss is particularly undesirable.

This aligns with the broader Atlas Engineering delivery principle:

> **Prefer receiving data again over silently losing it.**

At the platform level, the V1 delivery decision is:

```text
At-Least-Once
+
Idempotency
```

The complete end-to-end behavior has not yet been implemented and proven.

However, the capture strategy should already avoid mechanisms that create unacceptable blind spots for required source changes.

### 5.5 Reliable Watermark Availability

The fifth criterion determines whether the source provides a value that can reliably define incremental extraction progress.

A watermark is a value used to establish a boundary such as:

```text
already processed
        │
        ▼
WATERMARK = T1
        │
        ▼
retrieve changes after T1
```

A common candidate is:

```text
updated_at
```

but the existence of such a column is insufficient.

The mechanism depends on its semantics.

A candidate watermark must be evaluated for questions such as:

```text
Does every relevant change modify it?

Can multiple rows have the same value?

What precision does it have?

Can its value move backward?

Can a transaction commit after another row
while carrying an earlier timestamp?

How are equal boundary values handled?

Can a hard DELETE be represented?
```

A naive implementation might use:

```sql
WHERE updated_at > @last_watermark
```

This appears simple but contains an important boundary problem.

Suppose the previous extraction ends with:

```text
last_watermark =
2026-08-29 10:00:00
```

and multiple source rows have:

```text
updated_at =
2026-08-29 10:00:00
```

If only some of those rows were safely processed before the checkpoint was advanced, the next query using:

```text
>
```

could exclude unprocessed rows sharing the same timestamp.

This does not mean timestamp incremental capture is invalid.

It means:

> **Watermark semantics and extraction boundaries must be designed and tested rather than assumed.**

Possible implementation techniques may later include additional boundary logic or deterministic tie-breaking, but this document does not select such an implementation before testing.

For the current V1 hypothesis:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

are candidates for timestamp incremental capture.

Their actual watermark behavior remains to be validated.

### 5.6 DELETE Detection Requirement

The sixth criterion asks whether the platform must detect that a source row has ceased to exist.

DELETE detection must be evaluated separately from INSERT and UPDATE detection.

Consider timestamp incremental extraction:

```text
row exists
updated_at = T1
        ↓
DELETE
        ↓
row no longer exists
```

A later query against the source cannot retrieve the deleted row merely by filtering its timestamp because the row is gone.

Therefore:

```text
timestamp incremental
```

does not inherently provide:

```text
hard DELETE detection
```

Other mechanisms can address disappearance differently.

CDC can expose captured DELETE operations for appropriately configured sources.

Snapshot and diff can infer disappearance by comparing:

```text
PREVIOUS STATE
      vs
CURRENT STATE
```

Controlled full refresh can establish authoritative current state, although whether downstream logic needs to interpret a missing row as a historical DELETE is a separate requirement.

The decision process must therefore ask:

```text
Does disappearance matter?

Must it be detected?

Must it be detected as an event?

Or is authoritative current state sufficient?
```

These are different requirements.

For example:

```text
sales.Transaction
sales.TransactionItem
```

require reliable hard DELETE visibility in the selected V1 strategy.

For:

```text
catalog.ProductCategory
```

snapshot comparison provides a way to identify relationships that existed previously but no longer exist in the current snapshot.

For other sources, DELETE requirements must not be invented before the analytical requirement is established.

### 5.7 Operational Overhead

The seventh criterion evaluates the operational cost introduced by a capture mechanism.

Operational overhead includes more than source CPU usage.

It can include:

- source I/O;
- storage growth;
- retention management;
- database jobs;
- extraction queries;
- full-table scans;
- network transfer;
- monitoring;
- alerting;
- recovery procedures;
- checkpoint management;
- troubleshooting;
- schema evolution handling;
- operational dependencies;
- failure modes.

A mechanism may be technically capable of capturing a source while still being operationally inappropriate.

For example:

```text
CDC
```

introduces concerns such as:

```text
capture processing
retention
cleanup
change tables
capture instances
jobs
recovery window
monitoring
```

Timestamp incremental capture introduces different concerns:

```text
watermark correctness
checkpoint persistence
boundary handling
source query performance
DELETE limitations
```

Snapshot and diff introduces:

```text
snapshot storage
comparison cost
state consistency
change derivation
```

Controlled full refresh introduces:

```text
complete source extraction
refresh frequency
replacement / reconciliation behavior
```

The correct question is therefore not:

```text
Which mechanism has no overhead?
```

because every mechanism has operational cost.

The question is:

> **Which mechanism provides the required correctness and latency with acceptable operational cost?**

### 5.8 Criteria Are Interdependent

The seven criteria must not be evaluated independently.

A mechanism that looks attractive under one criterion may become unsuitable when another is considered.

Example:

```text
SOURCE
Low change frequency
        ↓
Full Refresh looks attractive
```

But:

```text
SOURCE
Low change frequency
+
extremely large table
+
strict source workload constraints
        ↓
Full Refresh may no longer be attractive
```

Another example:

```text
SOURCE
Occasional changes
+
updated_at available
        ↓
Timestamp Incremental looks attractive
```

But:

```text
SOURCE
Occasional changes
+
updated_at available
+
hard DELETE must be detected
+
no separate deletion mechanism
        ↓
Timestamp Incremental alone may be insufficient
```

Therefore, mechanism selection must evaluate the combined requirement set.

Conceptually:

```text
             CHANGE
            FREQUENCY
                │
                │
     VOLUME ────┼──── LATENCY
                │
                ▼
        CAPTURE DECISION
                ▲
                │
 WATERMARK ─────┼──── DELETE
                │
                │
      MISSING CHANGE
         TOLERANCE
                │
                │
       OPERATIONAL
         OVERHEAD
```

The decision exists at the intersection of these concerns.

### 5.9 Selection Questions

For every new source considered by Atlas Engineering, the following questions should be answered before a capture mechanism is approved:

```text
01. What business or analytical role does the source provide?

02. How frequently does it change?

03. What is the expected source size?

04. What is the expected change volume?

05. How quickly must changes become available downstream?

06. Must INSERT be detected?

07. Must UPDATE be detected?

08. Must hard DELETE be detected?

09. Is individual change history required,
    or is authoritative current state sufficient?

10. Does the source expose a candidate watermark?

11. Has that watermark been proven reliable?

12. Can relevant changes occur without modifying it?

13. Can multiple rows share the same watermark?

14. What happens at extraction boundaries?

15. What happens if the capture process is unavailable?

16. How long must recovery remain possible?

17. What source workload does the mechanism introduce?

18. Can that workload interfere with the OLTP system?

19. How will existing rows be initially loaded?

20. How will future changes be protected during backfill?

21. How will DELETE or disappearance be represented?

22. What assumptions still require implementation testing?

23. What are the accepted limitations?

24. What evidence will be required before the mechanism
    is considered operationally validated?
```

These questions form a reusable capture assessment for future Atlas Engineering domains.

### 5.10 Mechanism Decision Model

The following model summarizes the V1 reasoning process.

It is a decision aid, not an automatic algorithm:

```text
START
  │
  ▼
Do individual source changes matter?
  │
  ├── YES
  │     │
  │     ▼
  │   Must hard DELETE be reliably detected?
  │     │
  │     ├── YES
  │     │     │
  │     │     ▼
  │     │   Is change-level capture available
  │     │   and operationally acceptable?
  │     │     │
  │     │     ├── YES → Evaluate CDC
  │     │     │
  │     │     └── NO  → Evaluate alternative
  │     │     │               change detection
  │     │     │
  │     │     └── validate requirements
  │     │
  │     └── NO
  │           │
  │           ▼
  │       Is a reliable watermark available?
  │           │
  │           ├── YES → Evaluate
  │           │         Timestamp Incremental
  │           │
  │           └── NO  → Evaluate
  │                     Snapshot + Diff
  │                     or another mechanism
  │
  └── NO
        │
        ▼
      Is authoritative current state sufficient?
        │
        ├── YES
        │     │
        │     ▼
        │   Is full source extraction
        │   operationally acceptable?
        │     │
        │     ├── YES → Evaluate
        │     │         Controlled Full Refresh
        │     │
        │     └── NO  → Evaluate
        │               incremental/state comparison
        │
        └── NO
              ↓
          Re-evaluate requirements
          and available mechanisms
```

The word `Evaluate` is intentional.

The diagram must not be interpreted as:

```text
question answered
        ↓
mechanism automatically approved
```

Instead:

```text
candidate mechanism identified
        ↓
evaluate all criteria
        ↓
document assumptions
        ↓
implement
        ↓
test
        ↓
observe
        ↓
validate or revise
```

### 5.11 Mechanism Comparison

At the current V1 strategy level, the four mechanisms can be compared conceptually as follows:

| Characteristic | CDC | Timestamp Incremental | Snapshot + Diff | Controlled Full Refresh |
|---|---|---|---|---|
| Change-oriented | Yes | Partially | Derived from state comparison | Primarily state-oriented |
| INSERT detection | Yes | Yes, when watermark semantics support it | Derived | Current state acquired |
| UPDATE detection | Yes | Yes, when watermark is reliable | Derived | Current state acquired |
| Hard DELETE detection | Yes, when captured by CDC | Not inherently | Derived from disappearance | Current state reflects disappearance |
| Requires source watermark | No timestamp watermark required | Yes | No | No |
| Requires previous state for comparison | No | Checkpoint required | Yes | Not inherently |
| Suitable for high-change transactional sources | Potentially, subject to source capabilities and overhead | Depends on requirements | Usually less attractive | Usually less attractive |
| Operational complexity | Higher | Moderate | Moderate | Lower for small sources |
| Historical change fidelity | Change-level capture after boundary | Limited to observable qualifying rows | Derived between snapshots | Current state unless additional history is created |
| Initial historical state still required | Yes | Yes | Yes | Full state is the refresh itself |

This table describes conceptual characteristics.

It does not claim that every mechanism has already been implemented or validated in Atlas Engineering.

### 5.12 Selection Is Followed by Validation

A capture mechanism is not operationally approved merely because architectural reasoning indicates that it should work.

Atlas Engineering follows:

```text
REQUIREMENT
    ↓
SOURCE ANALYSIS
    ↓
MECHANISM SELECTION
    ↓
IMPLEMENTATION
    ↓
CONTROLLED TEST
    ↓
OBSERVABILITY
    ↓
EVIDENCE
    ↓
VALIDATION
```

For CDC:

```text
architectural selection
        ↓
SQL Server CDC implementation
        ↓
controlled source tests
        ↓
M01.08–M01.19 evidence
```

has already begun validating the source-side strategy.

For:

```text
Timestamp Incremental
Snapshot + Diff
Controlled Full Refresh
```

implementation validation remains pending.

This distinction prevents the architecture from becoming a collection of untested assumptions.

### 5.13 Decision Record for Each Source

When a capture mechanism is finalized for a source, its decision record should be able to summarize:

```text
SOURCE
<schema.table>

ROLE
<why the platform needs it>

CHANGE PROFILE
<high / occasional / reference / low>

LATENCY REQUIREMENT
<required capture availability>

VOLUME
<known or expected characteristics>

INSERT REQUIREMENT
<yes / no / current-state only>

UPDATE REQUIREMENT
<yes / no / current-state only>

DELETE REQUIREMENT
<yes / no / disappearance only / pending>

WATERMARK
<available / unavailable / pending validation>

SELECTED MECHANISM
<CDC / Timestamp Incremental /
 Snapshot + Diff / Controlled Full Refresh>

RATIONALE
<why this mechanism fits>

ACCEPTED LIMITATIONS
<known trade-offs>

VALIDATION STATE
<hypothesis / implemented / tested>

EVIDENCE
<reference to implementation evidence when available>
```

This structure ensures that future capture decisions remain explainable without requiring readers to reconstruct the reasoning from implementation code.

### 5.14 Selection Principle

The selection process can be summarized by the following rule:

> **Choose the simplest mechanism that can reliably satisfy the required change visibility, latency, recovery, and source-protection requirements.**

Not:

```text
Choose the simplest mechanism.
```

And not:

```text
Choose the most sophisticated mechanism.
```

The operative word is:

```text
reliably
```

A simple mechanism that silently loses required changes is not simple engineering.

It is an incomplete solution.

Likewise, a complex mechanism that provides capabilities the source does not require is unnecessary operational burden.

The target is:

```text
REQUIRED CORRECTNESS
        +
REQUIRED LATENCY
        +
REQUIRED RECOVERY
        +
OLTP PROTECTION
        +
ACCEPTABLE COMPLEXITY
        ↓
APPROPRIATE CAPTURE MECHANISM
```

---

## 6. CDC Strategy

Change Data Capture (CDC) is the V1 capture mechanism selected for the high-change transactional sources at the core of the initial Sales Analytics domain.

The selected sources are:

```text
sales.Transaction
sales.TransactionItem
```

For these tables, the capture requirement extends beyond periodically obtaining their current state.

The Data Engineering Platform must be able to observe relevant changes occurring after the capture boundary, including:

```text
INSERT
UPDATE
DELETE
```

The strategy must also protect the AtlasCommerce OLTP workload from unnecessary analytical extraction patterns.

For the current SQL Server source, the selected mechanism is:

```text
SQL Server Native CDC
```

Conceptually:

```text
APPLICATION
     │
     │ DML
     ▼
AtlasCommerce
SQL Server
     │
     │ transaction activity
     ▼
Transaction Log
     │
     ▼
SQL Server Native CDC
     │
     ▼
CDC Change Data
     │
     ▼
downstream consumption boundary
```

CDC is therefore positioned at the source capture boundary.

It identifies changes produced by the operational database so that downstream components can subsequently consume and transport them.

This document defines why CDC is used and the architectural constraints surrounding that decision.

Detailed configuration, scripts, laboratory results, CDC metadata, controlled DML tests, and observed behavior belong to:

`AtlasEngineering-SQL-Server-CDC-Implementation.md`

### 6.1 Applicable Tables

The V1 CDC strategy applies to:

```text
sales.Transaction
sales.TransactionItem
```

These tables form the transactional core of the first Data Engineering domain.

Their relationship is:

```text
sales.Transaction
        │
        │ 1 : N
        ▼
sales.TransactionItem
```

The analytical grain defined for the initial Sales Analytics data product is:

> **One row per `sales.TransactionItem` associated with a `sales.Transaction`.**

This makes both sides of the relationship important.

Capturing only:

```text
sales.Transaction
```

would not provide the item-level detail required by the analytical grain.

Capturing only:

```text
sales.TransactionItem
```

would omit transaction-level attributes required to interpret those items.

The two sources therefore participate together in the capture boundary:

```text
Transaction
     +
TransactionItem
     ↓
transactional sales capture
```

Both are currently classified as:

```text
A — High Change
```

and both use:

```text
SQL Server Native CDC
```

in V1.

### 6.2 Rationale

The CDC decision is based on the combined requirements of the transactional sources rather than on a preference for CDC as a technology.

The primary considerations are:

- high-change transactional behavior;
- need for change-oriented capture;
- INSERT visibility;
- UPDATE visibility;
- hard DELETE visibility;
- preservation of source-side change context;
- reduced dependence on repeated analytical scans of transactional tables;
- protection of the OLTP workload;
- need for an operational recovery window;
- future integration with the streaming architecture.

The decision can be represented as:

```text
TRANSACTIONAL SOURCE
        +
HIGH CHANGE
        +
CHANGE-LEVEL VISIBILITY
        +
DELETE DETECTION
        +
SQL SERVER SOURCE
        +
OLTP PROTECTION
        ↓
SQL SERVER NATIVE CDC
```

CDC is not selected merely because SQL Server supports it.

It is selected because its capabilities align with the current capture requirements of these sources.

#### Change-Oriented Capture

For these transactional tables, the platform is interested in more than periodic state comparison.

The relevant question is:

```text
What changed after the capture boundary?
```

rather than only:

```text
What does the table contain now?
```

SQL Server CDC provides change-oriented information for captured source operations.

The current implementation evidence has demonstrated source-side representations for:

```text
INSERT

UPDATE
├── BEFORE
└── AFTER

DELETE
```

These observations validate important assumptions behind the architectural selection.

They do not yet prove downstream consumption or end-to-end event semantics.

#### OLTP Protection

AtlasCommerce is responsible for operational sales processing.

The capture mechanism must respect:

> **The health of the OLTP system takes priority over analytical convenience.**

A naive analytical capture design could repeatedly query transactional tables to discover what changed.

For example:

```text
Data Engineering process
        ↓
repeated source query
        ↓
scan / seek operational tables
        ↓
compete with business workload
```

The exact cost would depend on indexes, predicates, data distribution, frequency, volume, and query plans.

The architectural objective is not to claim that every incremental query would necessarily damage the OLTP system.

The objective is to avoid making repeated analytical source extraction the primary change-detection mechanism when SQL Server already provides a transaction-log-based CDC capability appropriate to the requirement.

### 6.3 SQL Server CDC Capture Model

SQL Server Native CDC derives captured change information from SQL Server transaction log activity.

The conceptual model used by Atlas Engineering is:

```text
DML
 ↓
SQL Server Transaction
 ↓
Transaction Log
 ↓
CDC Capture Processing
 ↓
CDC Change Tables
 ↓
CDC Consumption Functions
 ↓
Downstream Consumer
```

This distinction is important because CDC is not implemented as an application trigger-based capture mechanism in the Atlas Engineering design.

The application continues to perform normal transactional operations against AtlasCommerce.

CDC observes the corresponding database change information through SQL Server's CDC infrastructure.

This helps separate:

```text
BUSINESS TRANSACTION PROCESSING
```

from:

```text
ANALYTICAL CHANGE CAPTURE
```

CDC also has two distinct enablement boundaries in SQL Server:

```text
DATABASE
   ↓
CDC enabled for database
   ↓
TABLE
   ↓
specific source table enabled
```

Enabling CDC at database level does not automatically cause every table to become captured.

Each required source table must be deliberately selected.

This supports an important architectural principle:

> **Capture only what the platform requires; do not enable change capture indiscriminately.**

### 6.4 CDC Is Asynchronous

The source transaction and the appearance of its corresponding CDC records are not the same operation from the downstream observer's perspective.

Conceptually:

```text
APPLICATION TRANSACTION
        ↓
COMMIT
        ↓
source state is committed
        ↓
CDC capture processing
        ↓
change becomes available
```

Therefore:

```text
source COMMIT
≠
immediate CDC visibility
```

This characteristic matters when designing consumers and monitoring.

A consumer must not assume:

```text
COMMIT at 10:00:00
        ↓
CDC row necessarily queryable
at exactly 10:00:00
```

The current Atlas Engineering laboratory repeatedly observed this asynchronous behavior.

In the current configuration, the CDC capture job uses a polling interval of:

```text
5 seconds
```

and controlled laboratory tests commonly waited approximately:

```text
6 seconds
```

before rechecking CDC data.

However:

> **The observed laboratory delay is not a production freshness guarantee.**

The 5-second polling configuration and laboratory observations describe the current environment.

They do not establish the complete end-to-end SLO.

### 6.5 LSN as a Capture Boundary Concept

CDC uses Log Sequence Numbers (LSNs) as part of its change-tracking model.

An LSN should not be interpreted as a business timestamp.

Conceptually:

```text
LSN
→ position / ordering context associated with log activity
```

while:

```text
business event time
→ when the business event is represented as occurring
```

and:

```text
platform ingestion time
→ when the Data Engineering Platform receives or persists it
```

These concepts are different:

```text
Business Event Time
        ≠
CDC Transaction Time
        ≠
Platform Ingestion Time
```

Similarly:

```text
LSN
≠
timestamp
```

An LSN is useful for identifying and ordering CDC processing boundaries.

It is only conceptually comparable to mechanisms such as a Kafka offset in the limited sense that both can represent progress or position within their respective systems.

They are not equivalent identifiers and must not be treated as interchangeable.

The detailed consumption semantics of:

```text
minimum LSN
maximum LSN
from_lsn
to_lsn
increment_lsn
checkpoint
```

remain outside the currently validated strategy.

They will be investigated during CDC consumption implementation.

### 6.6 Transaction Context Matters

CDC change rows should not automatically be interpreted as unrelated independent business events.

The current laboratory evidence demonstrated that multiple changes generated within the same SQL transaction can share transaction-level CDC context.

Observed examples include:

```text
single SQL transaction
        │
        ├── INSERT Transaction
        ├── INSERT TransactionItem
        └── INSERT TransactionItem
```

and:

```text
single SQL transaction
        │
        ├── UPDATE Transaction
        ├── UPDATE TransactionItem
        └── UPDATE TransactionItem
```

as well as:

```text
single explicit parent DELETE
        │
        ├── DELETE Transaction
        ├── cascaded DELETE TransactionItem
        └── cascaded DELETE TransactionItem
```

The tests observed a common:

```text
__$start_lsn
```

for changes originating from the same SQL transaction across the CDC-enabled source tables.

Additional CDC metadata such as:

```text
__$command_id
__$seqval
__$operation
__$update_mask
```

provided further source-side change context in the laboratory.

This evidence is important because it demonstrates that:

> **A collection of CDC rows may represent multiple physical effects belonging to one transactional context.**

However, this must not be extended beyond the evidence.

In particular:

```text
shared SQL Server CDC transaction context
```

does not yet prove:

```text
Debezium will expose the transaction
as one indivisible consumer unit
```

and does not prove:

```text
Kafka will deliver related changes
atomically across topics
```

Those are separate downstream questions that require their own implementation and tests.

### 6.7 DELETE Detection

Hard DELETE detection is a major reason CDC was selected for the transactional sources.

A timestamp incremental mechanism normally discovers rows that continue to exist and satisfy a watermark condition.

For example:

```sql
SELECT ...
FROM sales.Transaction
WHERE TRN_updated_at > @last_watermark;
```

If a row is physically deleted:

```text
ROW EXISTS
    ↓
DELETE
    ↓
ROW DOES NOT EXIST
```

the later timestamp query has no row to retrieve.

CDC provides a different capture model because the DELETE can be represented in captured change data.

For the current V1 transactional sources, this capability is required.

The implementation laboratory has already validated source-side hard DELETE capture for:

```text
sales.Transaction
```

and:

```text
sales.TransactionItem
```

### 6.8 Cascading DELETE Semantics

The relationship between the two transactional tables contains an important referential rule:

```text
sales.TransactionItem
        │
        │ FK
        ▼
sales.Transaction

ON DELETE CASCADE
```

This means that an application can execute:

```text
DELETE parent Transaction
```

while SQL Server also removes the related child rows as a consequence of referential integrity.

Conceptually:

```text
APPLICATION
    │
    │ one explicit DELETE
    ▼
sales.Transaction
    │
    │ ON DELETE CASCADE
    ▼
sales.TransactionItem
```

At the physical data-change level:

```text
1 parent row deleted
+
N child rows deleted
```

The current CDC laboratory demonstrated this behavior with:

```text
1 explicit parent DELETE
        ↓
1 Transaction DELETE captured
+
2 TransactionItem DELETEs captured
```

This creates an important semantic rule:

> **The number of captured DELETE changes must not automatically be interpreted as the number of DELETE statements explicitly executed by the application.**

A single logical application action may produce multiple physical changes across related tables.

This distinction will become important when downstream consumers reconstruct business meaning from source changes.

### 6.9 CDC Recovery Window

SQL Server CDC retains captured changes for a finite operational period.

Atlas Engineering treats this retention as:

```text
RECOVERY WINDOW
```

not:

```text
PERMANENT HISTORY
```

The SQL Server default observed during implementation was:

```text
4320 minutes
=
3 days
```

The V1 decision changed this to:

```text
21600 minutes
=
15 days
```

The architectural reasoning is:

```text
~10 days possible absence
+
~2 days detection / analysis
+
~3 days repair / reprocessing
=
~15 days
```

This window provides additional operational tolerance for situations such as:

- weekends;
- holidays;
- extended absences;
- incidents;
- delayed detection;
- diagnosis;
- repair;
- reprocessing.

Conceptually:

```text
CHANGE CAPTURED
      │
      │ retained
      ▼
CDC RECOVERY WINDOW
      │
      ├── consumer healthy
      │      ↓
      │   process normally
      │
      └── consumer unavailable
             ↓
          recover before
          required CDC data
          is cleaned up
```

The recovery window does not guarantee recovery by itself.

Recovery also depends on:

- consumer checkpoint state;
- availability of the required CDC range;
- downstream correctness;
- replay behavior;
- operational procedures.

These mechanisms still require implementation and testing.

### 6.10 CDC Retention Is Not Historical Storage

Increasing CDC retention indefinitely would move a responsibility into the wrong architectural layer.

The intended model is:

```text
SQL Server CDC
        ↓
operational change capture
and recovery window

Kafka
        ↓
durable event streaming
and replay window

Bronze
        ↓
durable historical ingestion
and reprocessing source
```

Each layer has a different responsibility.

SQL Server CDC exists close to the OLTP source and must not become the permanent historical archive of the Data Engineering Platform.

Once data has been durably acquired downstream, long-term history should progressively become the responsibility of the platform rather than the source CDC structures.

Therefore:

> **CDC retention protects operational recoverability; Bronze protects durable historical ingestion.**

The Kafka and Bronze responsibilities shown here remain architectural decisions pending their own implementation evidence.

### 6.11 Freshness and CDC Retention

CDC polling and CDC retention must not be confused.

They answer different questions.

```text
CAPTURE / FRESHNESS
How quickly does a change become available?

RECOVERY WINDOW
How long does captured data remain recoverable?
```

Current V1 values include:

```text
Typical platform freshness target
≈ 3–5 minutes

Formal end-to-end SLO
P95 ≤ 15 minutes

CDC retention
15 days
```

These dimensions are independent.

For example:

```text
poll every 5 seconds
+
retain 15 days
```

does not mean:

```text
end-to-end data is guaranteed
within 5 seconds
```

because additional stages exist downstream.

Similarly:

```text
P95 ≤ 15 minutes
```

does not mean captured CDC data only needs to be retained for 15 minutes.

The first concerns data availability.

The second concerns recovery tolerance.

### 6.12 Cleanup Is Part of CDC Operations

Finite CDC retention requires cleanup.

Conceptually:

```text
CDC captures new changes
        ↓
Change Tables grow
        ↓
retention boundary advances
        ↓
eligible old capture data
        ↓
cleanup
```

Without cleanup, CDC storage could continue growing.

With excessively aggressive cleanup, downstream recovery could lose access to changes before they have been safely processed.

Retention therefore represents a balance between:

```text
RECOVERY CAPACITY
        ↕
SOURCE STORAGE / OPERATIONAL COST
```

The selected 15-day V1 window is an operational decision for the current architecture.

It must be monitored and may require future adjustment based on real:

- change volume;
- CDC storage growth;
- consumer availability;
- recovery experience;
- source capacity;
- operational requirements.

The implementation document records how the cleanup retention was configured and the operational error encountered while manipulating the cleanup job.

That error is evidence and belongs to implementation documentation rather than being hidden from the project history.

### 6.13 Partition Switch Governance

Both transactional CDC sources are partitioned:

```text
sales.Transaction
sales.TransactionItem
```

The current CDC configuration allows partition switching:

```text
allow_partition_switch = 1
```

SQL Server has an important CDC restriction associated with partition `SWITCH` operations:

> Partition switching is not represented through CDC as ordinary row-level changes in the same way as normal DML.

This creates a potential semantic conflict.

Consider:

```text
NORMAL BUSINESS DELETE
        ↓
sale is logically removed
        ↓
DELETE semantics may matter downstream
```

versus:

```text
PARTITION SWITCH OUT
        ↓
historical rows physically moved
for storage / archival management
        ↓
business sales may still remain valid
```

The second operation is physical data management.

It is not automatically a business deletion.

Therefore, Atlas Engineering does not attempt to force physical partition movement into row-level business DELETE semantics.

The V1 decision is:

> **Govern partition switching rather than disable it preventively.**

### 6.14 SWITCH IN Governance

Normal transactional sales ingestion must not use:

```text
ALTER TABLE ... SWITCH
```

as the standard mechanism for inserting new operational sales into the CDC-enabled transactional tables.

The normal business path is:

```text
application transaction
        ↓
normal SQL Server DML
        ↓
transaction log
        ↓
CDC
```

Using `SWITCH IN` for normal sales ingestion could move rows into a CDC-enabled table without producing the row-level CDC history expected by the downstream capture strategy.

Therefore:

```text
SWITCH IN
for normal sales ingestion
=
not planned / not allowed by strategy
```

If a future requirement proposes this pattern, the capture strategy must be reviewed before implementation.

### 6.15 SWITCH OUT Governance

`SWITCH OUT` may become useful in the future for physical historical archival or partition lifecycle management.

Conceptually:

```text
ACTIVE TRANSACTION TABLE
        ↓
historical partition
        ↓
SWITCH OUT
        ↓
archive / alternate storage structure
```

Such a physical operation must not automatically tell the analytical platform:

```text
these sales no longer happened
```

The business history may remain valid even though the OLTP storage location changes.

Therefore, future partition archival must preserve the distinction between:

```text
PHYSICAL DATA LOCATION
```

and:

```text
BUSINESS DATA EXISTENCE
```

Any future `SWITCH OUT` process must be designed together with the Data Engineering Platform so that downstream historical correctness is preserved.

### 6.16 Initial Backfill

CDC begins capturing changes from its established capture boundary.

It does not reconstruct the complete history of changes that occurred before CDC was enabled.

This creates two data populations:

```text
PRE-CDC DATA
existing source rows
        ↓
Initial Backfill
        ↓
known state at extraction


POST-BOUNDARY CHANGES
observable future changes
        ↓
CDC
        ↓
change-oriented capture
```

The initial AtlasCommerce baseline identified before CDC activation contained:

```text
sales.Transaction
6306 rows

sales.TransactionItem
13769 rows
```

Those existing rows do not automatically become historical CDC events merely because CDC is enabled.

This was independently observed for both capture instances: the source contained existing rows while the newly created CDC Change Tables initially contained no historical change rows.

Therefore:

> **CDC activation is not a historical backfill mechanism.**

### 6.17 CDC Cutover Strategy

The initial backfill and CDC activation must be coordinated to prevent a silent change gap.

Atlas Engineering follows:

> **Protect the future first, then load the past.**

Conceptually:

```text
1. establish CDC capture boundary
        ↓
2. future changes become observable
        ↓
3. extract existing source state
        ↓
4. CDC changes accumulate during backfill
        ↓
5. process backfill
        ↓
6. process accumulated CDC changes
        ↓
7. reconcile controlled overlap
        ↓
8. continue normal operation
```

This approach may produce overlap.

For example, a row may:

```text
exist in backfill snapshot
        +
change after CDC boundary
```

The platform may therefore observe:

```text
initial known state
        +
later captured change
```

This is expected and must be reconciled correctly.

The alternative risk is:

```text
load past first
        ↓
changes occur
        ↓
enable capture later
        ↓
unobserved gap
```

Atlas Engineering prefers:

```text
controlled overlap
```

to:

```text
silent gap
```

because controlled duplication can be addressed through idempotent downstream processing, whereas missing changes may be impossible to reconstruct.

The exact implementation of this reconciliation remains to be tested.

### 6.18 Do Not Manufacture Pre-CDC History

Backfill provides a known source state.

It does not provide events that were never captured.

Suppose a pre-existing transaction is found during backfill as:

```text
TRN_TRNST_id = COMPLETED
```

The platform can establish:

```text
known state at extraction
=
COMPLETED
```

It cannot automatically claim that CDC observed:

```text
PENDING
        ↓
CONFIRMED
        ↓
COMPLETED
```

Those transitions may be plausible.

They are not evidence.

Therefore:

```text
INITIAL_BACKFILL
→ known source state

CDC_STREAM
→ observable post-boundary changes
```

must remain semantically distinct.

Candidate ingestion metadata may later represent this distinction, for example:

```text
ingestion_mode = INITIAL_BACKFILL

ingestion_mode = CDC_STREAM
```

The final naming remains subject to implementation design.

### 6.19 CDC Strategy and Future Debezium Integration

The broader V1 architecture places Debezium downstream of SQL Server Native CDC:

```text
AtlasCommerce
SQL Server
        ↓
SQL Server Native CDC
        ↓
Debezium
        ↓
Kafka
```

In the Atlas Engineering model:

> **Debezium is not treated as a direct reader of the SQL Server `.ldf` file.**

SQL Server Native CDC is the source-side change capture mechanism.

Debezium will later consume the change information according to its SQL Server connector behavior and expose events to Kafka.

This distinction is important because different layers have different semantics:

```text
SQL Server transaction semantics
        ↓
SQL Server CDC representation
        ↓
Debezium event representation
        ↓
Kafka topic / partition representation
        ↓
consumer interpretation
```

Evidence at one layer must not automatically be projected onto the next.

For example:

```text
same __$start_lsn
across SQL Server CDC tables
```

does not prove:

```text
atomic multi-topic Kafka delivery
```

The Debezium and Kafka stages require independent implementation and testing.

### 6.20 Current Validation Boundary

The CDC strategy is no longer purely theoretical.

Source-side SQL Server CDC implementation has been tested through:

```text
M01.08
Pre-CDC Baseline

M01.09
Enable CDC Database

M01.10
Enable CDC — Transaction

M01.10B
CDC Retention

M01.11
Change Table Anatomy

M01.12
Controlled INSERT

M01.13
Controlled UPDATE

M01.14
Multiple UPDATE Commands

M01.15
Controlled DELETE

M01.16A
TransactionItem Pre-Enable Validation

M01.16B
Enable CDC — TransactionItem

M01.17A
Cross-Table Preparation

M01.17B
Cross-Table INSERT Transaction

M01.18
Cross-Table Coordinated UPDATE

M01.19
Parent DELETE + ON DELETE CASCADE
```

These tests provide evidence for:

```text
CDC database enablement
CDC table enablement
Change Table creation
asynchronous capture
INSERT capture
UPDATE BEFORE / AFTER
DELETE capture
multiple commands in one transaction
cross-table transaction correlation
cascade DELETE capture
CDC metadata behavior observed in laboratory
absence of automatic historical backfill
configurable retention
partition SWITCH restriction awareness
```

They do not yet provide evidence for:

```text
final incremental CDC consumption
checkpoint strategy
consumer restart
consumer replay
Debezium behavior
Debezium transaction representation
Kafka delivery
cross-topic ordering
Bronze persistence
end-to-end idempotency
end-to-end recovery
backlog catch-up
production-scale performance
observed end-to-end SLO
```

The distinction is intentional:

```text
SOURCE-SIDE CDC
partially implemented and tested
        ↓
CDC CONSUMPTION
next implementation stage
        ↓
DEBEZIUM
future validation
        ↓
KAFKA
future validation
        ↓
BRONZE
future validation
        ↓
END-TO-END
future validation
```

### 6.21 CDC Strategy Summary

The V1 CDC strategy can be summarized as:

```text
APPLICABLE SOURCES
sales.Transaction
sales.TransactionItem

WHY CDC?
High-change transactional data
+
change-oriented capture
+
hard DELETE visibility
+
source-side transaction context
+
OLTP protection

CAPTURE SOURCE
SQL Server Transaction Log
through SQL Server Native CDC

CAPTURE MODEL
asynchronous

RECOVERY WINDOW
15 days

PERMANENT HISTORY
not CDC responsibility

INITIAL HISTORY
Initial Backfill

FUTURE CHANGES
CDC

CUTOVER PRINCIPLE
Protect the future first,
then load the past

BOUNDARY PRINCIPLE
Prefer controlled overlap
to silent gaps

PARTITION SWITCH
allowed but governed

SWITCH IN
not normal sales ingestion

SWITCH OUT
future controlled physical archival possibility

CURRENT EVIDENCE
SQL Server CDC source behavior
validated through M01.19

NOT YET PROVEN
CDC consumption
Debezium
Kafka
Bronze
end-to-end semantics
```

The governing architectural principle is:

> **CDC is the operational source-change capture mechanism for high-change transactional sales data; it is not the permanent historical store, and source-side CDC evidence must not be extended to downstream systems that have not yet been tested.**

---

## 7. Timestamp Incremental Strategy

Timestamp Incremental Capture is the V1 capture hypothesis selected for source tables that change occasionally and expose a candidate timestamp-based watermark.

The initial sources assigned to this strategy are:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

These tables support the Sales Analytics domain by providing descriptive and structural context for transactional data.

The intended capture model is:

```text
previous checkpoint
        ↓
query source
        ↓
identify rows changed
after previous boundary
        ↓
acquire changed rows
        ↓
advance checkpoint
```

A simplified form might appear as:

```sql
SELECT ...
FROM SourceTable
WHERE updated_at > @last_watermark;
```

However, this apparent simplicity can be misleading.

A timestamp-based strategy is reliable only when the selected watermark behaves in a way that guarantees that all required changes can be discovered.

Therefore:

> **The presence of a timestamp column does not prove that timestamp incremental capture is safe.**

For Atlas Engineering, the mechanism remains a V1 implementation hypothesis until watermark behavior is explicitly validated.

### 7.1 Applicable Tables

The V1 Timestamp Incremental strategy currently applies to:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

These tables are classified as:

```text
B — Occasional Change
```

Their role is different from the high-change transactional sources:

```text
sales.Transaction
sales.TransactionItem
```

They are not expected to generate the same volume or frequency of operational changes.

Conceptually:

```text
TRANSACTIONAL CORE
sales.Transaction
sales.TransactionItem
        ↓
CDC


DESCRIPTIVE / MASTER DATA
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
Timestamp Incremental
        ↓
subject to watermark validation
```

The selection is based on the assumption that a reliable timestamp-based watermark can provide sufficient change detection with less operational complexity than CDC.

That assumption must still be tested.

### 7.2 Watermark Requirements

A watermark is a value used to identify the capture progress boundary.

Conceptually:

```text
SOURCE HISTORY
──────────────────────────────────────>

already acquired          not yet acquired
───────────────┬───────────────────────
               │
           WATERMARK
```

A timestamp watermark attempts to answer:

```text
Which rows indicate that
they changed after the
last successful extraction?
```

For example:

```text
last_watermark
=
2026-08-29 10:00:00
```

could lead to:

```sql
WHERE updated_at > '2026-08-29T10:00:00'
```

This only works safely if the source semantics satisfy the assumptions behind that predicate.

A reliable watermark must therefore be evaluated across several dimensions.

#### 7.2.1 Relevant Changes Must Update the Watermark

Every change that matters to the downstream platform must modify the selected watermark.

If the source permits:

```text
UPDATE business column
        ↓
updated_at unchanged
```

then:

```text
WHERE updated_at > last_watermark
```

can silently miss the change.

The required relationship is:

```text
RELEVANT SOURCE CHANGE
        ↓
WATERMARK ADVANCES
```

If that relationship cannot be trusted, the timestamp is not a reliable incremental boundary.

#### 7.2.2 Watermark Precision Must Be Sufficient

Timestamp precision matters because multiple rows may receive the same value.

For example:

```text
Row A → 10:00:00
Row B → 10:00:00
Row C → 10:00:00
```

If processing is interrupted after only:

```text
Row A
```

has been safely persisted, and the checkpoint is incorrectly advanced to:

```text
10:00:00
```

then a later predicate:

```sql
WHERE updated_at > '10:00:00'
```

could exclude:

```text
Row B
Row C
```

The issue is not that duplicate timestamp values are inherently invalid.

The issue is that the extraction boundary must account for them.

Therefore:

> **Timestamp equality at the boundary is a correctness problem that must be explicitly designed.**

#### 7.2.3 Multiple Rows May Share the Same Watermark

Even high-precision timestamps do not guarantee uniqueness.

Therefore:

```text
timestamp
≠
unique row position
```

A timestamp may identify a group of rows rather than one deterministic record.

A robust incremental design may therefore need an additional tie-breaking element.

Conceptually:

```text
(timestamp, deterministic key)
```

rather than:

```text
timestamp only
```

For example:

```text
2026-08-29 10:00:00, ProductId 100
2026-08-29 10:00:00, ProductId 101
2026-08-29 10:00:00, ProductId 102
```

could theoretically be ordered by:

```text
timestamp
+
primary key
```

However, Atlas Engineering has not yet selected or validated the final implementation of this boundary.

This remains an implementation concern.

#### 7.2.4 Watermark Values Must Not Move Backward Unexpectedly

The incremental model generally assumes progress.

Conceptually:

```text
T1
 ↓
T2
 ↓
T3
```

A source that can later produce:

```text
T0
```

for a newly relevant change may challenge a simple forward-only checkpoint.

Possible causes could include application behavior, manually supplied timestamps, synchronization logic, or source-side corrections.

The strategy must therefore determine whether the candidate watermark is:

```text
system controlled
application controlled
user controlled
derived
```

because those semantics affect reliability.

A timestamp generated automatically by trusted source logic may be more suitable than one freely supplied by application callers.

But this must be established from implementation evidence.

### 7.3 Commit Order and Timestamp Order

Timestamp order and transaction commit order are not necessarily the same concept.

Consider:

```text
Transaction A
sets updated_at = 10:00:00
        │
        │ remains open
        ▼

Transaction B
sets updated_at = 10:00:01
        │
        ▼
COMMITS

        ↓

capture query executes
        ↓
observes B
        ↓
checkpoint advances

        ↓

Transaction A finally COMMITS
```

Depending on source isolation and timestamp generation semantics, a later committed row could carry an earlier timestamp.

This creates a potential condition:

```text
commit later
+
watermark earlier
```

A naive forward-only query could miss that row after the checkpoint advances.

This does not prove that the current AtlasCommerce tables exhibit this behavior.

It identifies a condition that must be considered when validating the watermark model.

The implementation tests must determine what guarantees actually exist in the source.

### 7.4 `>` Versus `>=` Boundary Semantics

A common incremental decision is whether the next extraction uses:

```sql
WHERE updated_at > @last_watermark
```

or:

```sql
WHERE updated_at >= @last_watermark
```

The first reduces repeated boundary rows but can create risk when several rows share the checkpoint timestamp.

The second deliberately rereads the boundary.

Conceptually:

```text
>
→ lower overlap
→ greater risk if boundary is incomplete

>=
→ controlled overlap
→ requires deduplication / idempotency
```

This reflects a broader Atlas Engineering principle:

> **Prefer controlled overlap to silent gaps.**

However, using `>=` alone does not solve the entire problem.

If the same timestamp occurs across large numbers of rows, the implementation still needs a reliable checkpoint and reconciliation model.

The final predicate therefore must be tested rather than chosen only from theory.

### 7.5 Watermark and Checkpoint Are Related but Different

A watermark is a source value used to identify progress.

A checkpoint is the persisted platform state that records how far processing has safely completed.

Conceptually:

```text
SOURCE WATERMARK
updated_at

        ↓ used by

PLATFORM CHECKPOINT
last safely processed boundary
```

They are related, but not identical.

For example:

```text
maximum timestamp observed
```

must not automatically become:

```text
checkpoint
```

if the corresponding rows have not yet been safely persisted downstream.

The correct sequencing conceptually follows:

```text
read candidate rows
        ↓
process rows
        ↓
persist safely
        ↓
only then
advance checkpoint
```

Otherwise:

```text
checkpoint advances
        ↓
processing fails
        ↓
some rows never persisted
        ↓
next extraction starts after them
```

which can produce silent loss.

Therefore:

> **A checkpoint represents safely completed progress, not merely observed source progress.**

The exact checkpoint implementation for Timestamp Incremental capture remains pending.

### 7.6 Rationale

Timestamp Incremental is selected as the V1 hypothesis for the Category B sources because it may provide an effective balance between:

```text
change detection
+
simplicity
+
low operational overhead
+
OLTP protection
```

for sources that change occasionally.

Compared with CDC, Timestamp Incremental can avoid additional source-side CDC objects and operational concerns where change-level fidelity is unnecessary.

Compared with full refresh, it can reduce repeated transfer and processing of unchanged rows.

Compared with snapshot and diff, it can avoid full-state comparison when the source itself exposes reliable change metadata.

Conceptually:

```text
reliable watermark exists
        +
changes are occasional
        +
hard DELETE event not required
        +
incremental state sufficient
        ↓
Timestamp Incremental
may be appropriate
```

The word:

```text
may
```

is intentional.

The mechanism remains conditional on validation.

### 7.7 DELETE Limitation

Timestamp incremental capture does not inherently detect hard DELETE operations.

Consider:

```text
Product 100 exists
updated_at = T1

        ↓

DELETE Product 100

        ↓

Product 100 no longer exists
```

A later query:

```sql
WHERE updated_at > @last_watermark
```

cannot return:

```text
Product 100
```

because the row is no longer present.

Therefore:

```text
INSERT
→ potentially detectable

UPDATE
→ potentially detectable

DELETE
→ not inherently detectable
```

This limitation must be compared with the business requirement of each source.

The strategy must ask:

```text
Does downstream need to know
that the row was deleted?

Is current absence sufficient?

Must deletion be represented
as a historical event?
```

These questions have not yet been fully validated for the Category B sources.

Until they are, Timestamp Incremental remains a hypothesis rather than a proven final implementation.

### 7.8 Soft DELETE Consideration

A source may sometimes represent deletion logically rather than physically.

For example:

```text
is_active = 1
        ↓
is_active = 0
```

or:

```text
deleted_at = NULL
        ↓
deleted_at = timestamp
```

If such a change also updates the reliable watermark, Timestamp Incremental can potentially observe the logical deletion as an UPDATE.

Conceptually:

```text
SOFT DELETE
row remains
        +
watermark changes
        ↓
incremental extraction can observe it
```

This differs from:

```text
HARD DELETE
row disappears
        ↓
timestamp query cannot retrieve it
```

The current Capture Strategy does not assume that the Category B AtlasCommerce sources use soft DELETE semantics.

That behavior must be determined from the actual source implementation.

### 7.9 Created Timestamp Is Usually Not Enough for UPDATE Capture

A source may contain:

```text
created_at
```

without a reliable:

```text
updated_at
```

A creation timestamp can support:

```text
new row detection
```

but does not necessarily support:

```text
subsequent UPDATE detection
```

For example:

```text
row created
created_at = T1

        ↓

row updated later
created_at remains T1
```

Then:

```sql
WHERE created_at > @last_watermark
```

will not retrieve the updated row.

Therefore:

```text
creation watermark
≠
change watermark
```

unless source behavior explicitly guarantees otherwise.

### 7.10 Application-Managed Timestamps Require Extra Caution

If the application itself provides the timestamp value, the capture mechanism inherits assumptions about application correctness.

For example:

```text
application UPDATE
        ↓
must remember to set updated_at
```

If one code path fails to do so:

```text
row changes
        ↓
timestamp does not
        ↓
incremental capture misses row
```

A source-generated mechanism can reduce this dependency, but even source-generated timestamps must still be validated for their intended semantics.

Potential timestamp ownership models include:

```text
application-managed
database trigger
stored procedure convention
computed source logic
```

A database `DEFAULT` may initialize a timestamp during `INSERT`, but it does not by itself maintain a change watermark for subsequent `UPDATE` operations.

The exact model used by the candidate AtlasCommerce tables must be verified before final implementation approval.

### 7.11 Full Extraction Predicate Must Be Sargable Where Possible

Incremental capture protects the OLTP source only if the extraction query itself is operationally appropriate.

A predicate such as:

```sql
WHERE updated_at > @last_watermark
```

can potentially support efficient access if an appropriate index and data distribution exist.

However, transformations around the source column can make access less efficient.

For example:

```sql
WHERE CAST(updated_at AS date) > @last_date
```

may prevent the optimizer from using the source column as effectively as a direct range predicate.

Conceptually:

```text
good incremental design
        =
correct boundary
        +
efficient source access
```

Correctness without operational efficiency can still create source pressure.

Efficiency without correctness can silently lose data.

Both matter.

The exact indexing and execution-plan behavior of the AtlasCommerce candidate tables must be validated during implementation.

### 7.12 Incremental Extraction Frequency

Timestamp Incremental is generally executed periodically.

Conceptually:

```text
T0
│ extraction
│
T1
│ extraction
│
T2
│ extraction
│
T3
```

The interval affects:

- freshness;
- source query frequency;
- amount of data per extraction;
- recovery behavior;
- checkpoint granularity.

A shorter interval may improve freshness but execute source queries more frequently.

A longer interval reduces query frequency but increases the amount of change accumulated between runs.

The correct frequency must therefore balance:

```text
LATENCY REQUIREMENT
        ↕
SOURCE WORKLOAD
```

The final schedules for the Category B tables have not yet been implemented or validated.

### 7.13 Failed Extraction and Checkpoint Safety

Suppose an incremental extraction identifies:

```text
100 rows
```

between:

```text
T1
and
T2
```

If processing fails after only 70 rows are safely persisted, the platform must not record:

```text
checkpoint = T2
```

unless it has another mechanism guaranteeing recovery of the remaining 30 rows.

Conceptually:

```text
100 rows discovered
        ↓
70 safely persisted
        ↓
FAILURE
```

Unsafe behavior:

```text
checkpoint = T2
        ↓
remaining 30 skipped later
```

Safer principle:

```text
checkpoint advances only
after successful durable completion
of the governed extraction boundary
```

This is another expression of the broader Atlas Engineering rule:

> **Durability precedes progress acknowledgement.**

The detailed implementation will depend on the future ingestion component and is not yet proven.

### 7.14 Late Visibility Must Be Investigated

An incremental query sees what is visible according to the source transaction and isolation behavior at query time.

A row not visible during one extraction may become visible later.

If that row carries a watermark earlier than the already advanced checkpoint, a pure forward-only timestamp model could miss it.

Conceptually:

```text
Extraction 1
watermark range up to T2
        ↓
row not visible

checkpoint advances to T2
        ↓

row becomes visible later
but timestamp = T1
        ↓

Extraction 2
WHERE timestamp > T2
        ↓
row missed
```

This scenario must not be assumed to occur in AtlasCommerce.

It is one of the behaviors that watermark validation must either:

```text
prove impossible
```

or:

```text
design around
```

before the mechanism is considered reliable.

### 7.15 Lookback Windows as a Possible Mitigation

One possible incremental pattern is to deliberately reread a limited recent range.

Conceptually:

```text
checkpoint = T2

next extraction begins at:

T2 - lookback interval
```

This creates:

```text
controlled overlap
```

which can help protect against certain forms of delayed visibility or timestamp boundary behavior.

However:

```text
lookback
```

also introduces:

```text
reprocessing
+
deduplication requirements
```

and does not automatically solve every watermark defect.

Atlas Engineering has not yet selected a lookback strategy for the Category B tables.

It remains a candidate implementation technique to be evaluated experimentally.

### 7.16 Timestamp Incremental Is State-Oriented Change Discovery

Timestamp Incremental should not be confused with a true event log.

Suppose a row changes several times between extractions:

```text
T1
Product price = 100

T2
Product price = 110

T3
Product price = 120

T4
incremental extraction
```

If the source only stores the current row, the extraction may observe:

```text
Product price = 120
```

It may not recover the intermediate state:

```text
110
```

Therefore:

```text
Timestamp Incremental
→ which rows currently say they changed?

CDC
→ what captured changes occurred?
```

This is one of the most important conceptual differences between the mechanisms.

Timestamp Incremental is appropriate only when this level of fidelity satisfies the requirement.

### 7.17 Intermediate Changes May Be Lost

The previous example leads to an important limitation.

Consider:

```text
10:00
price 100 → 110

10:02
price 110 → 120

10:05
incremental extraction
```

The source row at extraction time may contain:

```text
price = 120
updated_at = 10:02
```

The extraction can learn:

```text
this row changed
```

and:

```text
its current state is 120
```

It cannot necessarily reconstruct:

```text
100 → 110 → 120
```

Therefore:

> **Timestamp Incremental captures changed current state, not necessarily every intermediate change event.**

This limitation is acceptable only where the analytical requirement does not require full event-level history.

### 7.18 Timestamp Incremental and Historical Backfill

Like CDC, Timestamp Incremental still requires an initial state strategy.

When capture begins, existing rows already present in the source must be acquired.

Conceptually:

```text
EXISTING SOURCE
        ↓
Initial Backfill
        ↓
known current state

then

ONGOING CHANGES
        ↓
Timestamp Incremental
```

The capture boundary must be controlled so that changes occurring during the backfill are not silently lost.

The same general Atlas Engineering principle applies:

> **Protect the future first, then load the past.**

However, the exact implementation differs from CDC because a timestamp watermark rather than an LSN-based CDC range defines incremental progress.

The final cutover procedure must therefore be tested specifically for this mechanism.

### 7.19 Candidate Validation Tests

Before Timestamp Incremental is considered operationally validated for a source, controlled tests should examine at least:

```text
01. INSERT
    Does the candidate watermark expose
    a newly created row?

02. UPDATE
    Does every relevant UPDATE advance
    the watermark?

03. MULTIPLE UPDATES
    What is visible if the same row changes
    repeatedly between extractions?

04. SAME TIMESTAMP
    Can multiple rows share the same
    watermark value?

05. TIMESTAMP PRECISION
    What precision is actually stored?

06. BOUNDARY
    What happens when multiple rows exist
    exactly at the checkpoint value?

07. HARD DELETE
    Can deletion be detected?
    If not, is that acceptable?

08. SOFT DELETE
    If supported, does it advance
    the watermark?

09. TRANSACTION VISIBILITY
    Can a later-visible row carry an older
    watermark than the checkpoint?

10. CHECKPOINT FAILURE
    What happens if extraction fails
    before the batch is durable?

11. RESTART
    Can processing safely resume?

12. CONTROLLED OVERLAP
    Can boundary rows be reread safely?

13. SOURCE PERFORMANCE
    Does the extraction predicate use
    an acceptable execution plan?

14. BACKFILL CUTOVER
    Can initial state and ongoing changes
    be reconciled without gaps?

15. RECONCILIATION
    Can the source and downstream state
    be compared to detect discrepancies?
```

These tests should be performed separately for each source where behavior may differ.

A successful watermark on one table does not automatically prove the same semantics for another.

### 7.20 Current Validation State

The current V1 state is:

```text
catalog.Product
→ Timestamp Incremental selected as hypothesis
→ watermark validation pending

catalog.ProductVariant
→ Timestamp Incremental selected as hypothesis
→ watermark validation pending

catalog.Brand
→ Timestamp Incremental selected as hypothesis
→ watermark validation pending

catalog.Category
→ Timestamp Incremental selected as hypothesis
→ watermark validation pending
```

Therefore:

```text
SELECTED
        ≠
VALIDATED
```

No detailed timestamp incremental implementation evidence is claimed by this document at this stage.

When the corresponding implementation module begins, the strategy must be tested against the actual source behavior.

### 7.21 Rationale Summary

The V1 hypothesis can be summarized as:

```text
APPLICABLE SOURCES
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category

CLASSIFICATION
B — Occasional Change

SELECTED HYPOTHESIS
Timestamp Incremental

WHY?
Occasional change
+
potentially reliable watermark
+
lower complexity than CDC
+
avoid unnecessary full refresh
+
protect OLTP source

PRIMARY DEPENDENCY
Reliable watermark behavior

PRIMARY LIMITATION
Hard DELETE not inherently detected

CHANGE FIDELITY
Changed current state
not necessarily every intermediate event

INITIAL DATA
Requires backfill

BOUNDARY
Must be explicitly designed

CHECKPOINT
Must represent safely completed progress

CURRENT STATE
Architecture hypothesis only

IMPLEMENTATION VALIDATION
Pending
```

The governing principle is:

> **Timestamp Incremental is appropriate only when the source can reliably tell the platform which current rows changed after a known boundary.**

And the most important validation rule remains:

> **A timestamp column is a candidate watermark, not proof of a reliable incremental strategy.**

---

## 8. Snapshot and Diff Strategy

Snapshot and Diff is the V1 capture mechanism selected for low-change sources that do not expose a reliable watermark capable of identifying incremental changes directly.

The initial source assigned to this strategy is:

```text
catalog.ProductCategory
```

This table represents the relationship between products and categories.

Its currently identified structure contains:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

without timestamp columns that could serve as a reliable incremental watermark.

For this source, the capture problem is therefore not:

```text
Which rows say they changed?
```

Instead, the strategy asks:

```text
What is different between
the previously accepted state
and the current source state?
```

The V1 mechanism is:

```text
Snapshot + Diff
```

Conceptually:

```text
PREVIOUS SNAPSHOT
        │
        │ compare
        ▼
CURRENT SNAPSHOT
        │
        ▼
DIFF
        │
        ├── ADDED
        ├── REMOVED
        └── UNCHANGED
```

This approach derives change from state comparison.

It does not depend on the source exposing a timestamp or explicit change event.

### 8.1 Applicable Tables

The V1 Snapshot and Diff strategy currently applies to:

```text
catalog.ProductCategory
```

This table is classified as:

```text
D — Low Change / No Watermark
```

Its role is to represent the relationship between:

```text
catalog.Product
        ↕
catalog.Category
```

Conceptually:

```text
Product
  │
  │ may belong to
  ▼
one or more Categories
```

The relationship itself is analytically important because product classification affects how sales can later be grouped and analyzed.

The currently identified source columns are:

```text
PRDCT_PRD_id
PRDCT_CTG_id
```

The table does not currently expose timestamp columns that would support a direct strategy such as:

```sql
WHERE updated_at > @last_watermark;
```

Therefore, Timestamp Incremental is not the selected V1 mechanism for this source.

### 8.2 Rationale

Snapshot and Diff is selected because it provides a way to detect relationship changes without requiring the source to expose explicit change metadata.

The decision combines:

```text
LOW CHANGE
        +
RELATIONSHIP TABLE
        +
NO RELIABLE WATERMARK
        +
CURRENT AND PREVIOUS STATE
CAN BE COMPARED
        ↓
Snapshot + Diff
```

The strategy is particularly suitable when:

- the dataset is operationally manageable to read as a complete snapshot;
- changes are relatively infrequent;
- no reliable incremental watermark exists;
- additions and removals must be detectable;
- maintaining CDC for the source would introduce unnecessary complexity for the current requirement.

The mechanism therefore derives change instead of receiving change directly.

This distinction is fundamental:

```text
CDC
→ source capture infrastructure exposes change

Timestamp Incremental
→ source row indicates that it changed

Snapshot + Diff
→ platform derives change by comparing states
```

### 8.3 Change Detection

The basic model compares:

```text
PREVIOUS KNOWN STATE
```

with:

```text
CURRENT SOURCE STATE
```

For a relationship table, each relationship can be represented by its key pair.

For example:

```text
(PRDCT_PRD_id, PRDCT_CTG_id)
```

Suppose the previous snapshot contains:

```text
Product 100 → Category 10
Product 100 → Category 20
Product 200 → Category 10
```

and the current source snapshot contains:

```text
Product 100 → Category 20
Product 100 → Category 30
Product 200 → Category 10
```

The comparison yields:

```text
REMOVED
Product 100 → Category 10

ADDED
Product 100 → Category 30

UNCHANGED
Product 100 → Category 20
Product 200 → Category 10
```

The important point is that the source did not need to expose:

```text
DELETE event
```

for:

```text
Product 100 → Category 10
```

The platform inferred the removal because:

```text
relationship existed before
        +
relationship does not exist now
        ↓
REMOVED
```

Likewise:

```text
relationship absent before
        +
relationship exists now
        ↓
ADDED
```

### 8.4 Set-Based Mental Model

Snapshot and Diff is naturally modeled using set operations.

Let:

```text
P = previous snapshot
C = current snapshot
```

Then:

```text
ADDED
=
C - P
```

```text
REMOVED
=
P - C
```

```text
UNCHANGED
=
P ∩ C
```

Conceptually:

```text
PREVIOUS                         CURRENT

A                                B
B                                C
C                                D

        ↓ comparison ↓

ADDED
D

REMOVED
A

UNCHANGED
B
C
```

For `catalog.ProductCategory`, the set element is the relationship key:

```text
(PRDCT_PRD_id, PRDCT_CTG_id)
```

This makes the mechanism especially intuitive for many-to-many relationship tables.

### 8.5 Snapshot Is State, Not Event History

A snapshot represents the source state at a point in time.

It does not automatically reveal every intermediate operation that occurred between two snapshots.

Consider:

```text
Snapshot T1

Product 100 → Category 10
```

Between snapshots:

```text
T2
relationship removed

T3
relationship added again
```

Then:

```text
Snapshot T4

Product 100 → Category 10
```

The comparison between T1 and T4 produces:

```text
UNCHANGED
```

because the final states are identical.

The intermediate sequence:

```text
REMOVE
        ↓
ADD
```

is not recoverable from those two snapshots alone.

Therefore:

> **Snapshot and Diff identifies net state differences between observations, not every intermediate source event.**

This is a fundamental limitation of the mechanism.

It is acceptable only when that level of fidelity satisfies the analytical requirement.

### 8.6 Snapshot Frequency Determines Visibility

Because change is derived between observations, snapshot frequency determines how much intermediate behavior may remain invisible.

Conceptually:

```text
Snapshot 1
    │
    │ source can change here
    │
    │ source can change again
    │
Snapshot 2
```

The platform can determine:

```text
difference between Snapshot 1
and Snapshot 2
```

but not necessarily:

```text
every operation between them
```

A shorter snapshot interval provides more frequent state observations.

A longer interval reduces source read frequency but increases the period during which intermediate changes may collapse into one net result.

Therefore:

```text
SNAPSHOT FREQUENCY
        ↕
CHANGE VISIBILITY
        ↕
SOURCE WORKLOAD
```

must be balanced.

The final execution frequency for `catalog.ProductCategory` has not yet been implemented or validated.

### 8.7 Reliable Comparison Key

Snapshot and Diff depends on a deterministic way to determine whether two rows represent the same logical entity or relationship.

For `catalog.ProductCategory`, the natural comparison identity is currently:

```text
PRDCT_PRD_id
+
PRDCT_CTG_id
```

Conceptually:

```text
(Product ID, Category ID)
```

If the same key pair exists in both snapshots:

```text
UNCHANGED
```

If it exists only in the current snapshot:

```text
ADDED
```

If it exists only in the previous snapshot:

```text
REMOVED
```

This requires the relationship identity to be stable.

If the source later changes its key semantics, the comparison strategy must be reviewed.

### 8.8 Addition Detection

An addition occurs when a relationship exists in the current source snapshot but not in the previous known snapshot.

Formally:

```text
ADDED
=
CURRENT - PREVIOUS
```

Example:

```text
Previous
Product 100 → Category 10

Current
Product 100 → Category 10
Product 100 → Category 20
```

Derived result:

```text
ADDED
Product 100 → Category 20
```

This is conceptually similar to detecting an INSERT.

However, the distinction must remain explicit:

```text
derived addition
≠
observed source INSERT event
```

The platform knows that the relationship is new relative to the previous snapshot.

It does not necessarily know how or exactly when the source created it.

### 8.9 Removal Detection

A removal occurs when a relationship exists in the previous snapshot but not in the current source state.

Formally:

```text
REMOVED
=
PREVIOUS - CURRENT
```

Example:

```text
Previous
Product 100 → Category 10
Product 100 → Category 20

Current
Product 100 → Category 20
```

Derived result:

```text
REMOVED
Product 100 → Category 10
```

This is particularly important because there is no timestamp watermark available to report that the row disappeared.

Snapshot comparison therefore provides a practical way to detect disappearance.

Again:

```text
derived removal
≠
captured DELETE event
```

The platform knows:

```text
relationship existed previously
and no longer exists
```

It does not automatically know:

```text
exact DELETE timestamp
application statement
transaction context
user action
```

unless another source provides that evidence.

### 8.10 Unchanged Rows

Rows existing in both snapshots are classified as unchanged relative to the comparison key.

Formally:

```text
UNCHANGED
=
PREVIOUS ∩ CURRENT
```

For a relationship table containing only identity columns, this is straightforward.

For wider tables, however, the same business key might exist while descriptive attributes change.

In such cases, a Snapshot and Diff strategy might require:

```text
key comparison
+
attribute comparison
```

or a deterministic row hash.

That additional complexity is not currently required by the identified `catalog.ProductCategory` structure.

It may become relevant if the table schema changes in the future.

### 8.11 Full Snapshot Must Be Complete

The current snapshot must represent a complete and trustworthy source state.

This is one of the most important correctness requirements.

Suppose the source actually contains:

```text
A
B
C
```

but an extraction problem produces an incomplete snapshot:

```text
A
B
```

A naive diff would derive:

```text
REMOVED
C
```

even though:

```text
C still exists in source
```

This would create a false deletion.

Therefore:

> **An incomplete snapshot can manufacture false removals.**

The platform must never treat a snapshot as authoritative merely because a query returned successfully.

The extraction process must establish that the snapshot is complete enough for governed comparison.

### 8.12 Empty Snapshot Is a Dangerous State

A particularly dangerous example is an unexpected empty extraction.

Suppose:

```text
Previous Snapshot
10,000 relationships
```

and the next extraction unexpectedly returns:

```text
0 relationships
```

A naive diff would conclude:

```text
10,000 REMOVED
```

This could be correct if the source was intentionally emptied.

It could also indicate:

```text
source connectivity problem
wrong database
wrong schema
permissions issue
query defect
transaction visibility issue
upstream incident
```

Therefore:

```text
EMPTY CURRENT SNAPSHOT
```

must not automatically become:

```text
DELETE EVERYTHING
```

without validation.

Snapshot-based capture requires guardrails around anomalous source-state changes.

### 8.13 Snapshot Validation

Before computing a diff, the current snapshot should be validated.

Candidate validations may include:

```text
row count
key uniqueness
required-column nullability
referential consistency
unexpected large variation
source availability
query success
schema compatibility
```

Conceptually:

```text
EXTRACT CURRENT SNAPSHOT
        ↓
VALIDATE SNAPSHOT
        │
        ├── VALID
        │      ↓
        │   COMPUTE DIFF
        │
        └── INVALID / SUSPICIOUS
               ↓
           DO NOT PROMOTE
           INVESTIGATE
```

The exact validation thresholds for `catalog.ProductCategory` remain to be defined during implementation.

### 8.14 Previous Snapshot Is Operational State

Snapshot and Diff requires access to the previously accepted source state.

Without it:

```text
CURRENT SNAPSHOT
```

cannot be compared against:

```text
PREVIOUS SNAPSHOT
```

The previous state is therefore part of the capture mechanism.

Conceptually:

```text
RUN N

previous accepted state
        +
new source snapshot
        ↓
diff
        ↓
validate / persist
        ↓
new snapshot becomes
accepted state for RUN N+1
```

This introduces an important sequencing requirement:

> **The new snapshot must not replace the previous accepted snapshot before the comparison and required persistence have completed safely.**

Otherwise, a failure could destroy the state needed for recovery.

### 8.15 Snapshot Promotion

The capture process conceptually has at least two snapshot states:

```text
CANDIDATE SNAPSHOT
```

and:

```text
ACCEPTED SNAPSHOT
```

A newly extracted state is initially a candidate.

Conceptually:

```text
CURRENT SOURCE
      ↓
extract
      ↓
CANDIDATE SNAPSHOT
      ↓
validate
      ↓
compare with PREVIOUS ACCEPTED SNAPSHOT
      ↓
persist required result
      ↓
successful completion
      ↓
PROMOTE CANDIDATE
to new ACCEPTED SNAPSHOT
```

If processing fails:

```text
candidate
        ↓
not promoted
```

and the prior accepted state remains available for retry.

This follows the same general Atlas Engineering principle used elsewhere:

```text
durability
before
progress acknowledgement
```

The exact storage mechanism for accepted snapshots remains an implementation decision.

### 8.16 First Snapshot Has No Previous State

The first execution is different from later executions because there is no previous snapshot.

Conceptually:

```text
FIRST RUN

PREVIOUS SNAPSHOT
does not exist

CURRENT SOURCE SNAPSHOT
        ↓
initial known state
```

The first snapshot therefore establishes the baseline.

It should not automatically produce historical claims such as:

```text
all current relationships
were just INSERTED
```

because they may have existed long before capture began.

The correct interpretation is:

```text
INITIAL SNAPSHOT
→ known current relationship state
```

not:

```text
observed historical INSERT events
```

This follows the broader rule:

> **Do not invent historical events that were never observed.**

### 8.17 Initial Baseline Versus Ongoing Diff

The strategy therefore separates:

```text
INITIAL BASELINE
        ↓
known current state
```

from:

```text
SUBSEQUENT SNAPSHOT
        ↓
compare with previous accepted state
        ↓
derive additions and removals
```

Conceptually:

```text
RUN 1
Current Source
     ↓
Initial Baseline


RUN 2
Previous Baseline
     +
Current Source
     ↓
Diff


RUN 3
Previous Accepted Snapshot
     +
Current Source
     ↓
Diff
```

This distinction prevents the first run from being misrepresented as historical change capture.

### 8.18 Controlled Overlap and Reprocessing

If a Snapshot and Diff run fails after producing part of its downstream output, the platform may need to execute the comparison again.

That can produce the same derived changes more than once.

For example:

```text
Previous Snapshot = A B

Current Snapshot = A C

Derived:
REMOVE B
ADD C
```

If downstream persistence succeeds partially and the job restarts, the same comparison may derive:

```text
REMOVE B
ADD C
```

again.

Therefore, the downstream architecture must tolerate reprocessing.

This aligns with the Atlas Engineering V1 delivery model:

```text
At-Least-Once
+
Idempotency
```

The exact idempotency implementation is outside this document and remains to be validated.

### 8.19 Snapshot Consistency

A snapshot is intended to represent one coherent source state.

If the source changes while the extraction is reading it, the resulting dataset could theoretically contain rows observed at different moments.

Conceptually:

```text
begin reading source
        ↓
read some rows
        ↓
source changes
        ↓
read remaining rows
```

Depending on the query, transaction isolation, and source behavior, the final extracted dataset may not correspond perfectly to one instantaneous logical point.

For a small low-change relationship table, this risk may be operationally manageable.

However, it must not be ignored.

The implementation should evaluate the appropriate consistency mechanism without introducing unnecessary blocking or pressure on the OLTP source.

The exact isolation approach has not yet been selected or tested for `catalog.ProductCategory`.

### 8.20 Snapshot Size and Source Cost

Snapshot and Diff requires reading the source state repeatedly.

Therefore, its suitability depends strongly on:

```text
source size
+
snapshot frequency
+
query cost
+
change frequency
```

For a small low-change relationship table, this can be operationally reasonable.

For a massive high-change transactional table, repeatedly reading the full state would usually be much less attractive.

Conceptually:

```text
SMALL / LOW CHANGE
        ↓
full snapshot may be acceptable

LARGE / HIGH CHANGE
        ↓
full snapshot may create
unnecessary source pressure
```

This explains why Snapshot and Diff is selected specifically for the current Category D source rather than applied universally.

### 8.21 Snapshot and Diff Versus Full Refresh

Snapshot and Diff and Controlled Full Refresh both read current source state, but they answer different questions.

Controlled Full Refresh primarily asks:

```text
What is the authoritative state now?
```

Snapshot and Diff additionally asks:

```text
What changed relative
to the state we previously knew?
```

Conceptually:

```text
FULL REFRESH

Current Source
     ↓
Current Downstream State
```

versus:

```text
SNAPSHOT + DIFF

Previous State
      +
Current State
      ↓
Derived Change
```

Snapshot and Diff therefore maintains comparison state and derives additions/removals.

Controlled Full Refresh may not need that historical comparison when authoritative current state is sufficient.

### 8.22 Snapshot and Diff Versus Timestamp Incremental

Timestamp Incremental relies on the source to expose change metadata.

Snapshot and Diff does not.

Conceptually:

```text
TIMESTAMP INCREMENTAL

source says:
"I changed after T1"
        ↓
retrieve row
```

versus:

```text
SNAPSHOT + DIFF

platform says:
"you are different
from what I saw before"
```

This produces different dependency models.

Timestamp Incremental depends heavily on:

```text
watermark reliability
```

Snapshot and Diff depends heavily on:

```text
snapshot completeness
+
comparison correctness
+
previous-state preservation
```

Neither mechanism is inherently superior.

They solve different source conditions.

### 8.23 Snapshot and Diff Versus CDC

CDC captures change-oriented data from source transaction activity.

Snapshot and Diff derives net change between observations.

Consider:

```text
T1
relationship exists

T2
relationship removed

T3
relationship recreated

T4
snapshot
```

CDC could potentially expose:

```text
DELETE
INSERT
```

if those operations occurred after CDC activation and were captured.

Snapshot comparison between T1 and T4 may produce:

```text
UNCHANGED
```

because the states match.

Therefore:

```text
CDC
→ stronger event/change fidelity

Snapshot + Diff
→ state-difference fidelity
```

The selected mechanism must match the required level of historical detail.

### 8.24 Removal Does Not Equal Business Deletion

A derived removal means:

```text
the relationship existed
in the previous accepted state

and

does not exist
in the current accepted state
```

It does not automatically explain why.

Possible causes could include:

```text
intentional relationship deletion
product recategorization
data correction
source maintenance
other business logic
```

Therefore:

> **Snapshot and Diff derives state transition, not business intent.**

Downstream semantic interpretation should not invent a cause that the source does not provide.

### 8.25 Time Semantics

Snapshot-derived changes have weaker event-time semantics than source event capture.

Suppose a relationship exists at:

```text
Snapshot T1 = 10:00
```

and is absent at:

```text
Snapshot T2 = 11:00
```

The platform can conclude:

```text
the relationship disappeared
sometime after T1
and no later than T2
```

It cannot automatically conclude:

```text
DELETE occurred exactly at 11:00
```

The second snapshot time is the time of observation, not necessarily the business event time.

Therefore, if the platform later records metadata such as:

```text
detected_at
snapshot_at
effective_from
effective_to
```

their semantics must be carefully defined.

The current strategy does not invent an exact deletion timestamp that the source cannot prove.

### 8.26 Hash-Based Comparison as a Future Technique

For wider tables, comparing every column can become more complex.

One possible technique is to compute a deterministic hash from relevant row attributes.

Conceptually:

```text
BUSINESS KEY
+
RELEVANT ATTRIBUTES
        ↓
HASH
```

Then:

```text
same key + same hash
→ unchanged

same key + different hash
→ modified
```

This technique is mentioned as a general Snapshot and Diff option.

It is not currently required for:

```text
catalog.ProductCategory
```

because the identified source is a relationship table whose key pair itself represents the relevant state.

Therefore, no hash-based implementation is selected by V1 at this stage.

### 8.27 Schema Changes Must Be Governed

Snapshot comparison assumes that the source structure and comparison semantics are understood.

If the table later receives new columns, the platform must ask:

```text
Does this new column affect
the meaning of the relationship?

Must changes to it be detected?

Does it alter the comparison identity?

Does the snapshot schema need to change?
```

A schema change must therefore not silently alter the meaning of the diff.

This is another reason the capture strategy must remain version-controlled and reviewable.

### 8.28 Candidate Implementation Flow

The future implementation can be represented conceptually as:

```text
START RUN
    │
    ▼
READ CURRENT SOURCE STATE
    │
    ▼
CREATE CANDIDATE SNAPSHOT
    │
    ▼
VALIDATE SNAPSHOT
    │
    ├── invalid
    │      ↓
    │   FAIL RUN
    │   preserve previous accepted state
    │
    └── valid
           │
           ▼
    PREVIOUS SNAPSHOT EXISTS?
           │
           ├── NO
           │     ↓
           │   establish initial baseline
           │
           └── YES
                 ↓
            COMPUTE DIFF
                 │
                 ├── added
                 ├── removed
                 └── unchanged
                 │
                 ▼
            PERSIST REQUIRED OUTPUT
                 │
                 ▼
            successful?
                 │
                 ├── NO
                 │     ↓
                 │   preserve old snapshot
                 │   retry safely
                 │
                 └── YES
                       ↓
                  PROMOTE CANDIDATE
                  AS NEW ACCEPTED SNAPSHOT
```

This diagram expresses the strategy.

The exact implementation technology, storage location, transaction boundaries, and orchestration remain to be defined and tested.

### 8.29 Candidate Validation Tests

Before Snapshot and Diff is considered operationally validated for `catalog.ProductCategory`, controlled tests should cover at least:

```text
01. INITIAL BASELINE
    Does the first snapshot establish
    current state without inventing INSERT history?

02. NO CHANGE
    Do identical consecutive snapshots
    produce zero derived changes?

03. ADD RELATIONSHIP
    Is a new key pair detected as ADDED?

04. REMOVE RELATIONSHIP
    Is a missing previous key pair
    detected as REMOVED?

05. ADD AND REMOVE TOGETHER
    Can both directions be derived
    in the same comparison?

06. MULTIPLE CHANGES BETWEEN SNAPSHOTS
    What net state is observable?

07. REMOVE AND RECREATE
    Is the limitation around invisible
    intermediate changes understood?

08. EMPTY SOURCE
    How is an unexpected zero-row snapshot handled?

09. LARGE ROW-COUNT VARIATION
    What validation prevents false mass removal?

10. DUPLICATE KEYS
    What happens if source uniqueness
    assumptions are violated?

11. FAILED DIFF PROCESSING
    Is the previous accepted snapshot preserved?

12. RESTART
    Can the same comparison be rerun safely?

13. SNAPSHOT CONSISTENCY
    Is the extraction sufficiently coherent?

14. SOURCE PERFORMANCE
    Is repeated full-state extraction acceptable?

15. SCHEMA CHANGE
    Does schema evolution fail safely
    instead of silently corrupting comparison?

16. RECONCILIATION
    Can the accepted snapshot be compared
    with the source to detect divergence?
```

These tests must provide implementation evidence before the mechanism is considered proven.

### 8.30 Current Validation State

The current V1 state is:

```text
catalog.ProductCategory

Classification
→ D — Low Change / No Watermark

Selected Mechanism
→ Snapshot + Diff

Architectural Rationale
→ defined

Implementation
→ pending

Controlled Testing
→ pending

Operational Validation
→ pending

End-to-End Validation
→ pending
```

Therefore:

```text
SELECTED
≠
IMPLEMENTED
≠
TESTED
≠
PROVEN
```

The mechanism is currently an architectural decision awaiting implementation evidence.

### 8.31 Rationale Summary

The V1 Snapshot and Diff strategy can be summarized as:

```text
APPLICABLE SOURCE
catalog.ProductCategory

CLASSIFICATION
D — Low Change / No Watermark

WHY NOT TIMESTAMP INCREMENTAL?
No reliable timestamp watermark identified

WHY SNAPSHOT + DIFF?
Low-change relationship source
+
complete state can be compared
+
additions must be identifiable
+
removals must be identifiable

CHANGE MODEL
Previous State
vs
Current State

ADDED
Current - Previous

REMOVED
Previous - Current

UNCHANGED
Previous ∩ Current

EVENT FIDELITY
Net state differences
not every intermediate event

INITIAL RUN
Establish baseline

REQUIRED OPERATIONAL STATE
Previous accepted snapshot

PRIMARY CORRECTNESS RISK
Incomplete snapshot
can create false removals

PRIMARY OPERATIONAL RISK
Repeated full-state extraction
must remain acceptable for the OLTP source

CURRENT VALIDATION
Architectural decision only

IMPLEMENTATION VALIDATION
Pending
```

The governing principle is:

> **When the source cannot reliably tell the platform what changed, the platform may derive change by comparing trustworthy states.**

The corresponding safety principle is:

> **A diff is only as trustworthy as the snapshots being compared.**

---

## 9. Controlled Full Refresh Strategy

Controlled Full Refresh is the V1 capture mechanism selected for small reference datasets whose primary downstream requirement is the authoritative current state.

The initial sources assigned to this strategy are:

```text
sales.TransactionStatus
sales.TransactionChannel
```

These tables provide reference values used to interpret transactional sales data.

Their current role is fundamentally different from:

```text
sales.Transaction
sales.TransactionItem
```

which require change-oriented CDC capture.

For the reference sources, the primary question is:

```text
What is the authoritative
current state of this reference?
```

rather than:

```text
What was every individual
source operation that produced it?
```

The V1 mechanism is therefore:

```text
Controlled Full Refresh
```

Conceptually:

```text
REFERENCE SOURCE
       ↓
read complete current state
       ↓
validate
       ↓
compare / reconcile if required
       ↓
publish authoritative
downstream current state
```

The strategy deliberately favors simplicity where detailed event-level capture is not currently required.

### 9.1 Applicable Tables

The V1 Controlled Full Refresh strategy currently applies to:

```text
sales.TransactionStatus
sales.TransactionChannel
```

These tables are classified as:

```text
C — Reference
```

Their currently known source values are:

```text
sales.TransactionStatus

1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

and:

```text
sales.TransactionChannel

1 ONLINE
2 STORE
```

These reference datasets participate in the interpretation of transactional rows.

For example:

```text
sales.Transaction
        │
        ├── status identifier
        │      ↓
        │   sales.TransactionStatus
        │
        └── channel identifier
               ↓
            sales.TransactionChannel
```

The reference tables allow downstream consumers to translate identifiers into meaningful business descriptions.

### 9.2 Rationale

Controlled Full Refresh is selected because the current V1 requirement does not justify introducing change-level capture complexity for these sources.

The decision combines:

```text
SMALL REFERENCE DATASET
        +
LOW OPERATIONAL EXTRACTION COST
        +
AUTHORITATIVE CURRENT STATE REQUIRED
        +
EVENT-LEVEL HISTORY NOT CURRENTLY REQUIRED
        ↓
Controlled Full Refresh
```

The mechanism deliberately retrieves the complete source state.

This avoids requiring:

```text
CDC capture instances
CDC retention
timestamp checkpointing
watermark validation
snapshot-diff change derivation
```

for sources where those capabilities would provide little additional value under the current requirement.

The design follows a core selection principle:

> **Use the simplest mechanism that reliably satisfies the requirement.**

### 9.3 Current State Versus Change History

Controlled Full Refresh is primarily state-oriented.

The mechanism answers:

```text
What rows should exist downstream now?
```

It does not inherently answer:

```text
When was a row originally inserted?

When was a description changed?

How many times was it changed?

What was the exact previous value?

Who changed it?

What transaction performed the change?
```

For example, suppose:

```text
TransactionStatus

3 COMPLETED
```

later becomes:

```text
3 CLOSED
```

A full refresh can establish:

```text
current authoritative value
=
3 CLOSED
```

but does not inherently preserve the historical transition:

```text
COMPLETED
→ CLOSED
```

unless the downstream architecture explicitly chooses to version or audit reference changes.

Therefore:

> **Controlled Full Refresh acquires authoritative state; it does not inherently provide source event history.**

### 9.4 Why CDC Is Not Selected

SQL Server CDC could technically be enabled for these tables.

Technical possibility, however, is not sufficient architectural justification.

Using CDC would introduce additional concerns such as:

```text
capture configuration
change tables
capture instances
retention
cleanup
consumer processing
checkpointing
replay
operational monitoring
```

For small reference datasets whose current state is sufficient, this would increase complexity without currently required business value.

Conceptually:

```text
5-row reference table
        +
current state sufficient
        ↓
CDC possible
        but
        ↓
unnecessary complexity
```

Therefore:

```text
technically possible
≠
architecturally appropriate
```

### 9.5 Why Timestamp Incremental Is Not Preferred

Timestamp Incremental could also be considered if a reliable watermark existed.

However, for extremely small reference datasets, incremental extraction may provide little operational benefit compared with retrieving the complete state.

Consider:

```text
5 source rows
```

versus maintaining:

```text
watermark
checkpoint
boundary logic
failure recovery
timestamp validation
```

The incremental mechanism could become more complex than the source itself.

The design principle is:

```text
optimization benefit
must justify
optimization complexity
```

For the current V1 reference sources, Controlled Full Refresh is simpler and sufficient.

### 9.6 Why Snapshot and Diff Is Not Required

Snapshot and Diff also works with complete source states.

However, its primary purpose is to derive additions and removals by comparing:

```text
previous state
vs
current state
```

For these reference tables, the current V1 requirement is primarily to maintain authoritative current state.

Therefore, preserving a previous capture snapshot solely to infer change is not required by the current strategy.

Conceptually:

```text
Snapshot + Diff
→ What changed between states?

Controlled Full Refresh
→ What should the state be now?
```

If future requirements demand explicit reference-change detection or historical transition tracking, Snapshot and Diff or another mechanism may become relevant.

### 9.7 Complete Source Extraction

A Controlled Full Refresh intentionally retrieves the complete reference dataset.

Conceptually:

```sql
SELECT ...
FROM sales.TransactionStatus;
```

and:

```sql
SELECT ...
FROM sales.TransactionChannel;
```

The actual implementation query must explicitly select the required columns rather than rely unnecessarily on:

```sql
SELECT *
```

because the capture contract should remain deliberate and reviewable.

Conceptually:

```text
SOURCE
all required reference rows
        ↓
EXTRACT
all required reference columns
        ↓
VALIDATE
        ↓
PROMOTE
```

Because the datasets are small, complete extraction is expected to remain operationally inexpensive under the current V1 assumptions.

This assumption must still be validated during implementation.

### 9.8 Full Refresh Does Not Mean Uncontrolled Replacement

The word:

```text
Full
```

describes the extraction scope.

The word:

```text
Controlled
```

describes how the refresh must be governed.

The mechanism must not be interpreted as:

```text
DELETE downstream table
        ↓
hope extraction succeeds
        ↓
INSERT new rows
```

because a failure between these operations could leave the downstream representation incomplete or empty.

Instead, the refresh should follow a controlled lifecycle.

Conceptually:

```text
EXTRACT CURRENT SOURCE
        ↓
CREATE CANDIDATE STATE
        ↓
VALIDATE
        ↓
candidate acceptable?
        │
        ├── NO
        │     ↓
        │   FAIL
        │   preserve previous
        │   accepted state
        │
        └── YES
              ↓
          PROMOTE
              ↓
       new authoritative state
```

The exact implementation mechanism remains to be defined.

### 9.9 Candidate State and Accepted State

A useful conceptual distinction is:

```text
CANDIDATE STATE
```

versus:

```text
ACCEPTED STATE
```

The latest extraction should initially be treated as a candidate.

Only after validation should it become the new authoritative downstream state.

Conceptually:

```text
SOURCE
   ↓
candidate
   ↓
validate
   │
   ├── invalid
   │      ↓
   │   discard / investigate
   │
   └── valid
          ↓
       promote
          ↓
    accepted state
```

This prevents a bad extraction from immediately replacing a known-good reference state.

### 9.10 Refresh Boundaries

A refresh has an operational boundary.

Conceptually:

```text
REFRESH N
        ↓
extract source state
        ↓
validate
        ↓
persist safely
        ↓
promote
        ↓
REFRESH N complete
```

The boundary should represent:

```text
the complete reference state
that was successfully accepted
```

rather than:

```text
the point at which extraction merely started
```

or:

```text
the point at which some rows were read
```

A refresh should therefore be treated as one governed unit of state replacement or reconciliation.

### 9.11 Failed Refresh Must Preserve the Previous Good State

Suppose the current downstream reference state is valid:

```text
PENDING
CONFIRMED
COMPLETED
CANCELLED
FAILED
```

A new refresh begins but fails after retrieving only:

```text
PENDING
CONFIRMED
```

The downstream platform must not conclude:

```text
COMPLETED removed
CANCELLED removed
FAILED removed
```

merely because the extraction failed.

The correct principle is:

> **A failed refresh must not destroy the previous accepted state.**

Conceptually:

```text
previous accepted state
        ↓
new extraction fails
        ↓
previous accepted state remains active
```

This makes refresh failure recoverable rather than destructive.

### 9.12 Empty Result Protection

An unexpected zero-row result is particularly dangerous in a full refresh.

Suppose:

```text
sales.TransactionStatus
expected reference data
```

suddenly produces:

```text
0 rows
```

Possible explanations include:

```text
legitimate source change
wrong database
wrong schema
permission problem
connection problem
query defect
upstream incident
source corruption
```

A controlled refresh must not automatically interpret:

```text
0 rows returned
```

as:

```text
authoritative state is empty
```

without validation.

Therefore:

> **An empty extraction must be treated as data requiring validation, not automatically as a valid business state.**

### 9.13 Reference Validation

Before promotion, the candidate reference state should be validated.

Possible validations include:

```text
query completed successfully
expected columns exist
keys are not null
keys are unique
required values are populated
row count is plausible
referential assumptions remain valid
schema is compatible
```

For the currently known sources, row-count expectations are particularly easy to observe because the baseline contains:

```text
TransactionStatus
5 rows

TransactionChannel
2 rows
```

However, these numbers must not automatically become permanent hard-coded business rules unless the source contract explicitly defines them as such.

For example:

```text
5 rows observed
```

does not necessarily mean:

```text
exactly 5 statuses forever
```

A future legitimate status may be added.

Therefore:

```text
OBSERVED BASELINE
≠
PERMANENT DOMAIN LIMIT
```

unless the business contract explicitly establishes that limit.

### 9.14 Detecting Legitimate Reference Changes

Controlled Full Refresh must allow legitimate source changes.

For example, a future source state could become:

```text
TransactionChannel

1 ONLINE
2 STORE
3 MARKETPLACE
```

A validation rule such as:

```text
row count must always equal 2
```

would incorrectly reject a valid business expansion.

The objective of validation is therefore not to freeze the reference dataset.

It is to distinguish:

```text
plausible controlled source change
```

from:

```text
failed or suspicious extraction
```

Validation should use context rather than brittle assumptions.

### 9.15 Added Reference Values

Suppose the accepted state is:

```text
1 ONLINE
2 STORE
```

and the new source state is:

```text
1 ONLINE
2 STORE
3 MARKETPLACE
```

The full refresh acquires:

```text
1 ONLINE
2 STORE
3 MARKETPLACE
```

and, once validated, this becomes the authoritative current state.

The mechanism does not need to model:

```text
INSERT event for MARKETPLACE
```

unless downstream history explicitly requires that event.

The important result for the current V1 requirement is:

```text
MARKETPLACE now exists
```

### 9.16 Modified Reference Values

Suppose:

```text
3 COMPLETED
```

becomes:

```text
3 CLOSED
```

A new full refresh should produce the current authoritative state:

```text
3 CLOSED
```

Again:

```text
current state acquired
```

does not inherently mean:

```text
historical transition preserved
```

If the analytical platform later needs to answer:

```text
When was COMPLETED renamed to CLOSED?
```

then the current mechanism alone is insufficient.

That would represent a new requirement and should trigger strategy review.

### 9.17 Removed Reference Values

Suppose:

```text
5 FAILED
```

exists in the previous accepted state but is absent from the current authoritative source state.

After successful validation and promotion, the downstream current-state representation should reflect that absence.

However, this does not automatically mean:

```text
historical transactions that used status 5
should lose their historical meaning
```

This distinction is critical.

Reference current state and historical analytical interpretation are separate concerns.

A historical transaction may legitimately continue to contain:

```text
TRNST_id = 5
```

even if status 5 is no longer available for new operational transactions.

Therefore:

> **Removing a value from the current reference source must not automatically rewrite historical business facts.**

The downstream dimensional strategy must preserve historical correctness according to its own modeling rules.

### 9.18 Reference Integrity and Transactional History

Reference tables describe values used by transactional data.

This creates a potential temporal issue.

Suppose historical transactions contain:

```text
TRNST_id = 5
```

while the current `TransactionStatus` refresh no longer contains:

```text
5 FAILED
```

The platform must not simply conclude:

```text
historical rows are invalid
```

without understanding the business semantics.

Possible realities include:

```text
status retired for future use
but historical references remain valid
```

or:

```text
source integrity problem
```

These cases require different responses.

Therefore, future reconciliation must distinguish:

```text
current reference membership
```

from:

```text
historical referential validity
```

Controlled Full Refresh only establishes the current source representation.

### 9.19 Authoritative Current State

For this strategy, the source reference table remains the authority for current state.

Conceptually:

```text
AtlasCommerce reference table
        ↓
authoritative current source
        ↓
Controlled Full Refresh
        ↓
downstream representation
```

The downstream platform must not independently invent new operational reference values.

If the analytical platform requires additional classifications, they should be represented as downstream analytical semantics rather than silently altering the captured source reference.

For example:

```text
SOURCE STATUS
COMPLETED
```

could later be analytically grouped under:

```text
ANALYTICAL GROUP
Successful
```

but:

```text
Successful
```

should not be presented as though it were a source `TransactionStatus` value if it does not exist in AtlasCommerce.

### 9.20 Refresh Frequency

Controlled Full Refresh runs periodically rather than continuously tracking every individual source operation.

Conceptually:

```text
T1
Full Refresh

        ↓

T2
Full Refresh

        ↓

T3
Full Refresh
```

The refresh interval influences how long downstream reference state can lag behind the source.

For example:

```text
source changes shortly after T1
        ↓
downstream remains on previous state
        ↓
T2 refresh
        ↓
new state becomes available
```

Therefore:

```text
REFRESH FREQUENCY
        ↕
REFERENCE FRESHNESS
        ↕
SOURCE QUERY FREQUENCY
```

must be balanced.

Because the source datasets are small, source workload is expected to be low.

The final refresh schedule remains an implementation decision and has not yet been validated.

### 9.21 Full Refresh and the Platform Freshness SLO

The broader Atlas Engineering platform currently defines:

```text
Typical freshness target
≈ 3–5 minutes

Formal end-to-end SLO
P95 ≤ 15 minutes
```

This does not automatically mean every reference table must be refreshed every three to five minutes.

The actual requirement must consider the characteristics of each source.

A rapidly changing sales transaction and a rarely changing status lookup do not necessarily require identical source capture frequency.

Therefore:

> **Platform freshness objectives must be interpreted according to source and data-product requirements rather than applied mechanically to every table.**

The final V1 frequency for these reference refreshes remains to be implemented.

### 9.22 Full Refresh and Initial Load

Controlled Full Refresh has a useful property:

```text
initial load
```

and:

```text
normal ongoing capture
```

use essentially the same source-state model.

The first run:

```text
read complete reference state
        ↓
validate
        ↓
establish accepted state
```

Subsequent runs:

```text
read complete reference state
        ↓
validate
        ↓
replace / reconcile accepted state
```

Unlike CDC:

```text
there is no separate
pre-capture event history
to reconstruct
```

because the mechanism is explicitly state-oriented.

The first refresh establishes:

```text
known current state
```

not historical source events.

### 9.23 No Historical Event Invention

Suppose the first refresh discovers:

```text
1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

The platform can establish:

```text
these values exist
at initial capture time
```

It cannot conclude:

```text
status 1 was inserted first
then status 2
then status 3
...
```

unless another authoritative source proves that sequence.

Therefore:

> **Initial full refresh establishes baseline state, not synthetic historical events.**

This maintains the same evidence discipline applied to all Atlas Engineering capture mechanisms.

### 9.24 Controlled Promotion

A future implementation should separate extraction from publication.

Conceptually:

```text
SOURCE
   ↓
EXTRACT
   ↓
CANDIDATE
   ↓
VALIDATE
   ↓
PROMOTE
   ↓
ACTIVE REFERENCE STATE
```

This avoids exposing a partially processed refresh to downstream consumers.

The exact technique could later involve database transactions, staging structures, file promotion, atomic replacement, or another controlled mechanism depending on where the refresh is materialized.

This document does not select that implementation prematurely.

### 9.25 Refresh Idempotency

The same source state may be processed more than once.

For example:

```text
Refresh N
source =
A B C

Refresh N retry
source =
A B C
```

A correct downstream implementation should converge to:

```text
A B C
```

rather than creating duplicate logical reference values.

Therefore, Controlled Full Refresh should naturally support idempotent state convergence.

Conceptually:

```text
same authoritative input
processed repeatedly
        ↓
same logical output
```

The exact implementation remains part of downstream processing and must be validated independently.

### 9.26 Failure and Retry Model

A refresh may fail during:

```text
source extraction
validation
transport
persistence
promotion
```

The strategy should allow a failed run to be retried without damaging the previous accepted state.

Conceptually:

```text
RUN N
previous state valid
        ↓
new refresh fails
        ↓
previous state remains active
        ↓
retry
        ↓
successful new candidate
        ↓
promote
```

This produces:

```text
temporary staleness
```

instead of:

```text
corrupted reference state
```

when a refresh fails.

For a small reference dataset, preserving a slightly older known-good state is generally preferable to exposing a partial or unvalidated state.

### 9.27 Current-State Disappearance Versus Historical DELETE Event

Suppose:

```text
Previous Refresh

1 ONLINE
2 STORE
```

and:

```text
Current Refresh

1 ONLINE
```

The platform can establish:

```text
STORE is no longer
in the current source state
```

It cannot necessarily establish:

```text
a DELETE occurred
at an exact timestamp
```

or:

```text
the business intended
historical STORE transactions
to disappear
```

This is another example of the difference between:

```text
STATE OBSERVATION
```

and:

```text
EVENT CAPTURE
```

Controlled Full Refresh is intentionally state-oriented.

### 9.28 Schema Evolution

Reference tables may evolve.

Potential changes include:

```text
new column
renamed column
removed column
data type change
new required attribute
```

A refresh implementation must detect incompatible schema changes rather than silently producing malformed downstream data.

Conceptually:

```text
SOURCE SCHEMA
        ↓
expected capture contract
        │
        ├── compatible
        │      ↓
        │   process
        │
        └── incompatible
               ↓
            fail safely
            investigate
```

The downstream schema contract implementation remains outside the current capture strategy, but the capture process must not ignore structural changes.

### 9.29 Controlled Full Refresh Is Not `SELECT *`

Because the complete dataset is refreshed, it can be tempting to interpret full refresh as:

```sql
SELECT *
```

That is not the intended design.

The capture contract should explicitly identify the required source columns.

Reasons include:

- source schema evolution should be deliberate;
- unnecessary columns should not silently enter the pipeline;
- downstream contracts should remain predictable;
- lineage should remain explicit;
- source changes should fail visibly when incompatible.

Therefore:

```text
FULL ROWSET
```

does not mean:

```text
UNCONTROLLED COLUMN CONTRACT
```

The mechanism refreshes the complete required state, not every column the source happens to expose forever.

### 9.30 Candidate Validation Tests

Before Controlled Full Refresh is considered operationally validated for the V1 reference sources, controlled tests should cover at least:

```text
01. INITIAL REFRESH
    Does the first run establish
    the authoritative current state?

02. NO CHANGE
    Does an identical refresh
    converge without duplicates?

03. ADD VALUE
    Is a legitimate new reference
    value propagated correctly?

04. MODIFY VALUE
    Is a changed description
    reflected correctly?

05. REMOVE VALUE
    Is absence represented in
    the current downstream state?

06. EMPTY RESULT
    Does an unexpected zero-row
    result fail safely?

07. PARTIAL EXTRACTION
    Can incomplete data be prevented
    from replacing the accepted state?

08. DUPLICATE KEY
    Is invalid reference uniqueness
    detected?

09. NULL REQUIRED VALUE
    Is invalid source state rejected
    or governed explicitly?

10. FAILURE BEFORE PROMOTION
    Does the previous accepted
    state remain available?

11. FAILURE DURING PROMOTION
    Can the process recover without
    exposing partial state?

12. RETRY
    Can the same refresh be rerun safely?

13. SCHEMA CHANGE
    Does incompatible evolution
    fail visibly?

14. SOURCE PERFORMANCE
    Is complete extraction operationally
    negligible as expected?

15. RECONCILIATION
    Does the accepted downstream state
    correspond to the authoritative source?
```

These tests should be performed independently for:

```text
sales.TransactionStatus
sales.TransactionChannel
```

even though both use the same capture strategy.

### 9.31 Current Validation State

The current V1 state is:

```text
sales.TransactionStatus

Classification
→ C — Reference

Selected Mechanism
→ Controlled Full Refresh

Architectural Rationale
→ defined

Implementation
→ pending

Controlled Testing
→ pending

Operational Validation
→ pending
```

and:

```text
sales.TransactionChannel

Classification
→ C — Reference

Selected Mechanism
→ Controlled Full Refresh

Architectural Rationale
→ defined

Implementation
→ pending

Controlled Testing
→ pending

Operational Validation
→ pending
```

Therefore:

```text
SELECTED
≠
IMPLEMENTED
≠
TESTED
≠
PROVEN
```

The current source row counts and values are known from source inventory and CDC baseline work.

That observation must not be confused with validation of the future Controlled Full Refresh implementation.

### 9.32 Rationale Summary

The V1 Controlled Full Refresh strategy can be summarized as:

```text
APPLICABLE SOURCES
sales.TransactionStatus
sales.TransactionChannel

CLASSIFICATION
C — Reference

WHY FULL REFRESH?
Small datasets
+
current authoritative state required
+
event-level change history
not currently required

WHY CONTROLLED?
A refresh must not expose
partial, failed, or invalid state

CAPTURE MODEL
Complete required current state

INITIAL RUN
Establish authoritative baseline

ONGOING RUNS
Refresh authoritative state

WATERMARK
Not required

PREVIOUS SNAPSHOT
Not inherently required
for capture

DELETE EVENT
Not inherently captured

DISAPPEARANCE
Reflected through current state

PRIMARY CORRECTNESS RISK
Invalid or incomplete refresh
replacing a valid state

PRIMARY SAFETY RULE
Preserve previous accepted state
until new candidate is validated

CURRENT VALIDATION
Architectural decision only

IMPLEMENTATION VALIDATION
Pending
```

The governing principle is:

> **When the requirement is authoritative current state and the source is operationally inexpensive to read in full, do not introduce incremental complexity without a corresponding requirement.**

The corresponding safety principle is:

> **Full refresh describes how much state is read; controlled describes how carefully that state is allowed to replace what is already trusted.**

---

## 10. Initial Backfill and Cutover Strategy

The Atlas Engineering Data Platform must ingest sources that already contain operational data before the capture mechanisms are activated.

This creates two distinct responsibilities:

```text
EXISTING DATA
already present in the source
        ↓
Initial Backfill
        ↓
known current state


ONGOING CHANGES
occurring after the capture boundary
        ↓
ongoing capture mechanism
        ↓
observable change or refreshed state
```

These responsibilities must be coordinated.

If historical loading and ongoing capture are treated independently, the transition between them can create:

```text
gaps
duplicates
inconsistent state
invented history
```

The V1 cutover strategy therefore follows a fundamental principle:

> **Protect the future first, then load the past.**

The objective is to establish a reliable future capture boundary before performing potentially lengthy historical loading.

This allows new changes to remain observable while existing data is being acquired.

### 10.1 Initial State

When capture begins, the source already contains valid business data.

For the initial high-change transactional sources, the pre-CDC baseline identified:

```text
sales.Transaction
6306 rows

sales.TransactionItem
13769 rows
```

These rows existed before CDC began capturing source changes.

Therefore:

```text
existing source rows
≠
CDC historical events
```

Enabling CDC does not reconstruct the sequence of operations that created the existing source state.

Conceptually:

```text
PAST
───────────────────────────────┬──────────── FUTURE
                               │
                        capture boundary
                               │
                               ▼
existing source state          CDC-visible changes
```

The rows to the left of the boundary may be loaded as known state.

Their pre-boundary change history is not automatically available.

#### 10.1.1 Backfill Represents Known State

Initial Backfill answers:

```text
What source state can we establish
at the beginning of platform ingestion?
```

It does not answer:

```text
What was every historical event
that produced that state?
```

For example, suppose the backfill finds:

```text
Transaction 5000
Status = COMPLETED
```

The platform can record:

```text
known state
=
COMPLETED
```

It cannot automatically reconstruct:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

unless an authoritative historical source provides evidence for those transitions.

Therefore:

> **Backfill establishes known state; it does not manufacture missing event history.**

#### 10.1.2 Existing Data Is Still Business History

The absence of pre-capture events does not make existing source rows analytically irrelevant.

For example, a completed transaction created months before platform implementation still represents valid historical sales data.

The analytical platform may therefore ingest it as:

```text
historical business state
```

while maintaining metadata that distinguishes its ingestion origin from future change capture.

Conceptually:

```text
BUSINESS HISTORY
        ↓
existing source state
        ↓
INITIAL_BACKFILL
```

versus:

```text
BUSINESS CHANGE
        ↓
observed after capture boundary
        ↓
ONGOING CAPTURE
```

These two paths may eventually converge into the same downstream analytical model while preserving different provenance.

#### 10.1.3 Candidate Ingestion Provenance

The platform may later benefit from metadata distinguishing how a record entered the ingestion layer.

Candidate semantics include:

```text
INITIAL_BACKFILL

CDC_STREAM

TIMESTAMP_INCREMENTAL

SNAPSHOT_DIFF

FULL_REFRESH
```

For example:

```text
ingestion_mode = INITIAL_BACKFILL
```

could indicate that a row originated from the initial historical source-state load.

A future CDC-derived record might use:

```text
ingestion_mode = CDC_STREAM
```

However:

> **The final metadata names have not yet been implemented or validated.**

They remain design candidates rather than current implementation evidence.

### 10.2 Capture Boundary

A capture boundary is the point after which the platform can rely on the selected ongoing mechanism to identify new changes or source state.

Different mechanisms may express this boundary differently.

Conceptually:

```text
CDC
→ LSN-based capture boundary

Timestamp Incremental
→ watermark boundary

Snapshot + Diff
→ accepted snapshot boundary

Controlled Full Refresh
→ accepted refresh state
```

The underlying principle is the same:

> **The platform must know what belongs to the initial state and what becomes observable through ongoing capture.**

#### 10.2.1 CDC Boundary

For SQL Server CDC:

```text
CDC enabled
        ↓
capture instance established
        ↓
start LSN
        ↓
future captured changes
```

The current implementation created separate CDC capture instances for:

```text
sales.Transaction
sales.TransactionItem
```

with their own start LSN values.

The important architectural meaning is:

```text
pre-boundary state
→ backfill concern

post-boundary captured change
→ CDC concern
```

The exact CDC consumption window semantics remain part of the next implementation stage.

#### 10.2.2 Timestamp Incremental Boundary

For Timestamp Incremental, the boundary will be represented by a validated source watermark and a safely persisted checkpoint.

Conceptually:

```text
initial state
        ↓
capture starting watermark
        ↓
incremental extraction
        ↓
future checkpoints
```

This mechanism requires additional care because timestamp values may not provide the same transaction-log ordering guarantees as CDC LSNs.

The actual cutover algorithm must therefore be proven independently when Timestamp Incremental is implemented.

#### 10.2.3 Snapshot and Diff Boundary

For Snapshot and Diff, the initial accepted snapshot establishes the baseline.

Conceptually:

```text
RUN 1
source snapshot
        ↓
accepted baseline
        ↓

RUN 2
new source snapshot
        +
previous accepted baseline
        ↓
diff
```

No change is inferred before the baseline exists.

The first snapshot therefore represents:

```text
known current state
```

not:

```text
historical INSERT events
```

#### 10.2.4 Controlled Full Refresh Boundary

Controlled Full Refresh is state-oriented.

The first successful validated refresh establishes the initial authoritative state.

Subsequent accepted refreshes replace or reconcile that state according to the future implementation.

There is no requirement to reconstruct an event stream between refreshes unless future business requirements introduce such a need.

### 10.3 Controlled Overlap

When Initial Backfill and ongoing capture overlap in time, the same logical entity may be represented through more than one ingestion path.

This is not automatically an error.

Consider:

```text
T0
CDC capture boundary established

T1
Backfill begins

T2
Transaction 9000 is updated

T3
Backfill reads Transaction 9000

T4
CDC exposes the UPDATE
```

The platform may receive:

```text
Backfill state for Transaction 9000
        +
CDC change for Transaction 9000
```

This is a controlled overlap.

The alternative would be:

```text
Backfill begins

        ↓

changes occur

        ↓

CDC enabled only after backfill

        ↓

changes disappear from observable history
```

which creates a gap.

Therefore:

> **Atlas Engineering prefers controlled overlap to silent gaps.**

#### 10.3.1 Why Overlap Is Safer

Overlap creates a reconciliation problem.

A gap creates a missing-data problem.

Conceptually:

```text
OVERLAP
        ↓
data may appear more than once
        ↓
can be detected
        ↓
can be reconciled
```

versus:

```text
GAP
        ↓
data never captured
        ↓
may be invisible
        ↓
may be unrecoverable
```

The broader platform architecture follows:

```text
At-Least-Once
+
Idempotency
```

which intentionally favors the ability to tolerate duplicate delivery rather than silently lose required information.

The end-to-end implementation of this principle is not yet proven.

#### 10.3.2 Overlap Must Be Deliberate

Controlled overlap does not mean:

```text
duplicate everything
and ignore correctness
```

The overlap window must have known boundaries.

The platform must eventually understand:

```text
what backfill covered
```

and:

```text
what ongoing capture covered
```

so that both paths can converge safely.

The exact reconciliation logic will depend on:

- business keys;
- source timestamps;
- CDC metadata;
- ingestion metadata;
- downstream idempotency;
- batch boundaries;
- checkpoint semantics.

These concerns require implementation evidence before being finalized.

### 10.4 Historical State Limitations

Initial Backfill provides historical source rows but not necessarily historical events.

This distinction must remain explicit throughout the platform.

#### 10.4.1 Current Historical Row Versus Historical Event

Suppose a transaction created before CDC activation currently contains:

```text
gross_amount = 150.00
status = COMPLETED
```

The platform can ingest:

```text
transaction exists historically
gross_amount = 150.00
current known pre-capture status = COMPLETED
```

It cannot automatically claim:

```text
transaction originally had gross_amount = 100.00

then changed to 120.00

then changed to 150.00
```

unless those states are supported by another authoritative source.

Likewise, it cannot invent status transitions that were not observed.

Therefore:

```text
historical row
≠
historical event sequence
```

#### 10.4.2 Capture Boundary Creates an Evidence Boundary

The capture boundary is also an evidence boundary.

Conceptually:

```text
BEFORE CAPTURE

known from current source state
        ↓
limited historical evidence


AFTER CAPTURE

observable through capture mechanism
        ↓
stronger change evidence
```

This does not mean post-boundary data is automatically correct end-to-end.

It means the platform has a defined mechanism capable of observing changes from that point forward.

#### 10.4.3 Absence of Evidence Must Remain Absence of Evidence

If pre-capture history is unknown:

```text
UNKNOWN
```

must remain:

```text
UNKNOWN
```

It must not become:

```text
inferred event
```

simply to make a downstream history appear complete.

The Atlas Engineering principle is:

> **Do not fill historical gaps with invented certainty.**

### 10.5 Protect the Future First

The preferred cutover order is:

```text
1. prepare ongoing capture
        ↓
2. establish capture boundary
        ↓
3. verify future changes can be observed
        ↓
4. start Initial Backfill
        ↓
5. allow ongoing changes to accumulate
        ↓
6. complete historical extraction
        ↓
7. process accumulated ongoing changes
        ↓
8. reconcile overlap
        ↓
9. validate consistency
        ↓
10. enter steady-state processing
```

The key decision is the order:

```text
CAPTURE FIRST
        ↓
BACKFILL SECOND
```

rather than:

```text
BACKFILL FIRST
        ↓
CAPTURE LATER
```

The former protects future changes.

### 10.6 Example of an Unsafe Cutover

An unsafe sequence might be:

```text
08:00
Backfill starts

08:30
Transaction 100 changes
but CDC is not active

09:00
Transaction 200 changes
but CDC is not active

10:00
Backfill ends

10:05
CDC enabled
```

The platform now faces a problem.

If the backfill read Transaction 100 before 08:30, its later change may not be present in the backfill.

CDC also cannot recover the change because CDC was not active.

Conceptually:

```text
BACKFILL
    │
    ├───────────────┐
                    │
                    ▼
            UNPROTECTED WINDOW
                    │
                    ▼
                  CDC
```

Changes inside that window can be lost.

This is the silent gap the V1 strategy avoids.

### 10.7 Example of the Preferred Cutover

The preferred model reverses the order:

```text
08:00
CDC boundary established

08:10
Backfill starts

08:30
Transaction 100 changes
→ CDC captures future change

09:00
Transaction 200 changes
→ CDC captures future change

10:00
Backfill ends

10:05
Process accumulated CDC changes

10:30
Reconcile overlap
```

Now:

```text
backfill
+
CDC
```

may overlap.

But the changes remain observable.

The reconciliation challenge is preferable to an unrecoverable gap.

### 10.8 Backfill Is Not Required to Be Real-Time

Initial Backfill has different latency characteristics from ongoing ingestion.

Ongoing transactional capture may target freshness measured in minutes.

Historical backfill may take substantially longer depending on:

- source volume;
- source workload;
- extraction method;
- network throughput;
- downstream persistence capacity;
- operational throttling.

Therefore:

```text
ONGOING FRESHNESS
≠
BACKFILL DURATION
```

The objective of backfill is not necessarily to ingest all historical rows at streaming speed.

The objective is:

```text
complete
controlled
reconcilable
source-safe
historical acquisition
```

### 10.9 Backfill Must Protect the OLTP Source

Historical extraction can become one of the heaviest workloads introduced by a Data Engineering Platform.

For example:

```text
large table
        ↓
full historical extraction
        ↓
large reads
        ↓
I/O
CPU
buffer pressure
network
```

The platform must not treat backfill as justification for overwhelming AtlasCommerce.

The V1 principle remains:

> **OLTP health takes priority over analytical convenience.**

Possible future implementation techniques may include:

- controlled batch sizes;
- key-range extraction;
- partition-aware extraction;
- execution during appropriate operational windows;
- throttling;
- restored database copies for heavy historical reads.

No specific technique should be considered implemented until it has been tested.

### 10.10 Restored Copy as a Backfill Option

For heavy historical extraction, a restored database copy may provide a way to reduce analytical pressure on the live OLTP system.

Conceptually:

```text
LIVE AtlasCommerce
        │
        ├── ongoing business
        │
        └── ongoing capture
              ↓

BACKUP / RESTORE
        ↓
isolated copy
        ↓
historical backfill
```

This can separate:

```text
historical scan workload
```

from:

```text
live business workload
```

However, the restored copy represents a state at a particular recovery point.

Its relationship with the live capture boundary must therefore be coordinated carefully.

This remains a potential implementation technique rather than a current V1 implementation decision.

### 10.11 Backfill Ordering

Historical rows do not necessarily need to be ingested in the same order as their original business creation.

For analytical state loading, a practical extraction may use:

```text
primary key range
partition range
business date
```

or another deterministic segmentation method.

However, ordering becomes relevant when:

```text
parent / child dependencies
```

or:

```text
downstream referential constraints
```

exist.

For the transactional sources:

```text
Transaction
        ↓
TransactionItem
```

the downstream implementation must ensure that processing order does not create invalid analytical states.

The exact loading sequence is a future implementation concern.

### 10.12 Backfill Segmentation

Large historical loads should be divisible into controlled units.

Conceptually:

```text
FULL HISTORY
        ↓
segment
        ↓
segment
        ↓
segment
```

Candidate segmentation criteria may include:

```text
date ranges
partition ranges
primary key ranges
```

The segmentation method should support:

- restart;
- progress tracking;
- reconciliation;
- controlled source load;
- predictable batch sizes.

A monolithic backfill that must restart from the beginning after failure is operationally weaker than a segmented process with durable progress.

The final segmentation strategy has not yet been implemented.

### 10.13 Backfill Checkpointing

Backfill progress should eventually be represented by durable checkpoint state.

Conceptually:

```text
Segment 1
processed safely

Segment 2
processed safely

Segment 3
fails
```

On restart:

```text
resume from Segment 3
```

rather than:

```text
restart entire historical load
```

However, the checkpoint must represent:

```text
safely persisted progress
```

not merely:

```text
rows read from source
```

This follows the same principle used by ongoing ingestion:

> **Progress is acknowledged only after the governed output is durable.**

The exact checkpoint design remains pending.

### 10.14 Ongoing Capture During Backfill

Once the future capture boundary is protected, ongoing changes can continue while backfill runs.

Conceptually:

```text
                    ┌── new INSERT
                    ├── new UPDATE
LIVE SOURCE ────────┼── new DELETE
                    │
                    ▼
              ongoing capture


LIVE / RESTORED STATE
        │
        ▼
historical backfill
```

This creates two simultaneous flows:

```text
historical state flow
+
future change flow
```

They must later converge.

The platform must therefore be designed to understand source provenance and ordering sufficiently to reconcile them safely.

### 10.15 Example of Controlled Overlap

Suppose:

```text
08:00
CDC starts

08:10
Backfill starts

08:30
Transaction 500 currently:
Status = CONFIRMED

08:40
Transaction 500 changes:
CONFIRMED → COMPLETED
```

Depending on when the backfill reads the row, two valid cases exist.

Case A:

```text
Backfill reads before 08:40

INITIAL_BACKFILL
Status = CONFIRMED

CDC
UPDATE
CONFIRMED → COMPLETED
```

This provides a natural progression.

Case B:

```text
Backfill reads after 08:40

INITIAL_BACKFILL
Status = COMPLETED

CDC
UPDATE
CONFIRMED → COMPLETED
```

Now the backfill already contains the final state represented by the CDC UPDATE.

If downstream processing naively applies every representation without understanding the overlap, duplicate or temporally inconsistent effects could occur.

Therefore, the cutover requires explicit reconciliation logic.

### 10.16 Overlap Does Not Mean CDC Should Be Discarded

In the previous Case B, it might be tempting to conclude:

```text
backfill already has COMPLETED
therefore discard CDC update
```

That rule would be unsafe as a general assumption.

The CDC event is real post-boundary evidence.

The backfill is a state observation.

They serve different semantic roles.

The reconciliation implementation must determine:

```text
whether the downstream target is state-oriented,
event-oriented,
or both
```

before deciding how overlapping information is handled.

No universal discard rule is defined by this strategy.

### 10.17 Reconciliation

Cutover is not complete merely because:

```text
backfill finished
```

and:

```text
capture is running
```

The two flows must be reconciled.

Conceptually:

```text
INITIAL BACKFILL
        │
        ├──────────┐
        │          │
        ▼          ▼
    historical   overlap
      state        zone
                   ▲
                   │
ONGOING CAPTURE ───┘
        │
        ▼
future changes
```

Reconciliation must eventually answer questions such as:

```text
Did all expected source rows arrive?

Were any changes lost?

Were overlapping records processed safely?

Does downstream state correspond to source state?

Can processing restart from the established checkpoint?
```

The exact reconciliation queries and procedures remain implementation concerns.

### 10.18 Counts Are Useful but Not Sufficient

Row counts provide useful evidence during backfill.

For example:

```text
Source Transaction rows
=
6306

Source TransactionItem rows
=
13769
```

A downstream count comparison can help identify missing or unexpected rows.

However:

```text
same row count
```

does not prove:

```text
same data
```

For example:

```text
Source
A B C

Downstream
A B D
```

Both contain:

```text
3 rows
```

but their content differs.

Therefore, reconciliation may require:

```text
row counts
+
key comparison
+
aggregate comparison
+
targeted data checks
+
potential hashes
```

depending on the implementation.

### 10.19 Business Aggregates as Reconciliation Evidence

For transactional data, business-level aggregates can complement technical row counts.

Possible future comparisons could include:

```text
transaction count by date
item count by date
gross amount totals
discount totals
status distribution
channel distribution
```

These checks can detect discrepancies that a single overall row count might not expose.

However, business reconciliation logic must respect the exact semantics of the source and downstream model.

The final reconciliation specification remains to be developed.

### 10.20 Cutover Completion Criteria

A backfill should not be considered complete solely because the extraction process ended successfully.

Conceptually, cutover completion should require evidence that:

```text
historical source state was acquired
        +
future capture remained protected
        +
accumulated changes were processed
        +
overlap was reconciled
        +
downstream state was validated
        +
checkpoint is safely established
```

Only then can the source transition to:

```text
STEADY STATE
```

### 10.21 Steady State

After successful cutover:

```text
Initial Backfill
```

becomes a completed historical operation.

The platform then relies primarily on the selected ongoing capture mechanism.

For the high-change transactional sources:

```text
CDC consumption
```

will become the primary future change path.

For other source categories:

```text
Timestamp Incremental

Snapshot + Diff

Controlled Full Refresh
```

will provide their respective steady-state acquisition patterns once implemented.

Conceptually:

```text
INITIAL PHASE

backfill
+
ongoing capture
        ↓
reconcile
        ↓

STEADY STATE

ongoing capture mechanism
```

### 10.22 Recovery During Cutover

Failures can occur while backfill and ongoing capture are running simultaneously.

For example:

```text
backfill fails
CDC continues
```

This is not necessarily catastrophic.

If the capture boundary remains protected and required changes remain within the recovery window:

```text
backfill can restart
+
CDC changes remain available
```

This is one reason CDC retention and cutover strategy are related.

The current V1 CDC recovery window is:

```text
15 days
```

which provides operational time for investigation, repair, and reprocessing.

However:

> **Retention provides recovery opportunity; it does not implement recovery automatically.**

The checkpoint, replay, overlap, and restart mechanisms still need to be implemented and tested.

### 10.23 CDC Cleanup During Backfill

Because CDC retention is finite, an excessively long backfill could theoretically allow early captured changes to approach the cleanup boundary before they are processed.

Conceptually:

```text
CDC boundary
        ↓
changes accumulate
        ↓
backfill continues for long period
        ↓
retention window advances
        ↓
old changes become eligible for cleanup
```

Therefore, cutover planning must consider:

```text
backfill duration
vs
capture retention
```

The current 15-day recovery window provides operational buffer but should not be treated as unlimited time.

A future backfill procedure must monitor its relationship with the available CDC range.

### 10.24 Capture Boundary Must Be Recorded

A cutover boundary that exists only in operator memory is operationally weak.

The implementation should record sufficient metadata to establish:

```text
when capture protection began

which source was involved

what capture mechanism was used

what initial boundary applied

what backfill range was processed

what checkpoint was accepted

when reconciliation completed
```

This information supports:

- restart;
- troubleshooting;
- audit;
- reconciliation;
- operational handoff.

The exact metadata schema remains to be designed.

### 10.25 Backfill Must Be Repeatable

A robust historical ingestion procedure should be repeatable.

This does not mean repeated executions should duplicate logical data.

It means:

```text
same governed historical range
        ↓
can be processed again
        ↓
without corrupting downstream state
```

Possible reasons for reprocessing include:

```text
pipeline correction
schema correction
transformation defect
storage incident
data-quality repair
reconciliation discrepancy
```

This requirement reinforces the importance of idempotent downstream behavior.

### 10.26 Backfill and Bronze

In the broader V1 architecture, Bronze is intended to become durable historical ingestion.

Conceptually:

```text
INITIAL_BACKFILL
        ↓
Bronze

ONGOING CAPTURE
        ↓
Bronze
```

Bronze can therefore become the convergence point where:

```text
historical source-state acquisition
```

and:

```text
future change acquisition
```

are durably retained with appropriate provenance.

This is an architectural direction.

Bronze persistence has not yet been implemented or proven.

### 10.27 Backfill Does Not Extend CDC Backward

Initial Backfill and CDC complement one another, but one does not alter the historical capability of the other.

Conceptually:

```text
BACKFILL
does not create historical CDC events
```

and:

```text
CDC
does not reconstruct pre-enable history
```

Together they provide:

```text
known pre-boundary state
+
observable post-boundary change
```

This is the intended V1 model.

### 10.28 Mechanism-Specific Cutover Must Be Tested

The general principle:

```text
protect future
then load past
```

applies across capture mechanisms.

However, the implementation is not identical.

For example:

```text
CDC
→ LSN boundary

Timestamp Incremental
→ timestamp / checkpoint boundary

Snapshot + Diff
→ initial accepted snapshot

Controlled Full Refresh
→ initial accepted current state
```

Therefore, successful CDC cutover behavior does not automatically prove Timestamp Incremental cutover correctness.

Each mechanism requires its own controlled tests.

### 10.29 Candidate Cutover Validation Tests

A future cutover implementation should validate at least:

```text
01. CAPTURE BOUNDARY
    Is future change protection
    established before backfill?

02. INITIAL SOURCE COUNT
    Is the historical extraction
    scope known?

03. BACKFILL INSERT
    Can existing source rows
    be acquired successfully?

04. CHANGE DURING BACKFILL
    Is a source UPDATE occurring
    during backfill still observable?

05. NEW ROW DURING BACKFILL
    Is a post-boundary INSERT
    protected?

06. DELETE DURING BACKFILL
    Is a post-boundary DELETE
    protected when required?

07. OVERLAP
    Can a row appearing in both
    paths be reconciled safely?

08. FAILURE
    Can backfill restart without
    losing capture continuity?

09. CHECKPOINT
    Is progress persisted only
    after durable completion?

10. RETENTION
    Does the required capture range
    remain available during cutover?

11. SOURCE PROTECTION
    Does backfill remain operationally
    acceptable to AtlasCommerce?

12. RECONCILIATION
    Do technical and business checks
    support downstream consistency?

13. RESTART
    Can a failed cutover resume
    without restarting unnecessarily?

14. COMPLETION
    Is there explicit evidence
    that steady state can begin?
```

These tests remain pending.

### 10.30 Current Validation State

The current V1 state is:

```text
ARCHITECTURAL PRINCIPLE
Protect the future first,
then load the past
→ Approved

CONTROLLED OVERLAP
preferred over silent gap
→ Approved

PRE-CDC HISTORY
must not be invented
→ Approved

CDC INITIAL STATE BEHAVIOR
existing rows are not
automatically backfilled into CDC
→ source-side evidence obtained

INITIAL BACKFILL IMPLEMENTATION
→ Pending

BACKFILL CHECKPOINT
→ Pending

BACKFILL RESTART
→ Pending

OVERLAP RECONCILIATION
→ Pending

END-TO-END CUTOVER
→ Pending
```

Therefore, the architecture has defined the cutover strategy, while the complete operational procedure remains to be implemented and validated.

### 10.31 Strategy Summary

The V1 Initial Backfill and Cutover Strategy can be summarized as:

```text
PROBLEM
Source already contains data
while future changes continue

INITIAL STATE
Load through Initial Backfill

FUTURE CHANGES
Protect through ongoing capture

PRIMARY RULE
Protect the future first,
then load the past

CAPTURE BOUNDARY
Must be established before
historical loading begins

PREFERRED FAILURE MODE
Controlled overlap
rather than silent gap

PRE-CAPTURE HISTORY
Do not invent events

BACKFILL MEANING
Known historical source state

ONGOING CAPTURE MEANING
Observable post-boundary change
or accepted new state

OLTP
Must remain protected

CHECKPOINT
Must represent durable progress

RECONCILIATION
Required before cutover completion

STEADY STATE
Begins only after backfill,
capture, overlap, and validation
have converged

CURRENT VALIDATION
Strategy defined
source-side CDC no-backfill behavior proven
full cutover implementation pending
```

The governing principle is:

> **A safe cutover accepts controlled duplication if necessary to avoid losing changes that can never be recovered.**

The evidence principle is:

> **Backfill tells us what was there; ongoing capture tells us what we observed changing after the boundary. Neither is allowed to invent the other.**

---

## 11. Capture Strategy Matrix

The Capture Strategy Matrix consolidates the V1 capture decisions for the source tables currently included in the initial Sales Analytics domain.

Its purpose is to provide a single reviewable view of:

```text
source
classification
capture mechanism
change requirement
DELETE requirement
watermark dependency
capture orientation
validation state
```

The matrix is a summary of architectural decisions.

It must not be interpreted as evidence that every mechanism has already been implemented or operationally proven.

The governing distinction remains:

```text
SELECTED
        ≠
IMPLEMENTED
        ≠
TESTED
        ≠
PROVEN END-TO-END
```

### 11.1 V1 Capture Strategy Matrix

| Source | Classification | Selected Mechanism | Primary Capture Question | INSERT | UPDATE | Hard DELETE | Watermark Dependency | Capture Orientation | Current Validation State |
|---|---|---|---|---|---|---|---|---|---|
| `sales.Transaction` | A — High Change | SQL Server Native CDC | What changed? | Required | Required | Required | No timestamp watermark required | Change-oriented | Source-side CDC behavior validated through M01.19 |
| `sales.TransactionItem` | A — High Change | SQL Server Native CDC | What changed? | Required | Required | Required | No timestamp watermark required | Change-oriented | Source-side CDC behavior validated through M01.19 |
| `catalog.Product` | B — Occasional Change | Timestamp Incremental | Which current rows indicate that they changed? | Expected to be required | Expected to be required | Not inherently provided by mechanism | Reliable watermark required | Changed current state | Pending implementation validation |
| `catalog.ProductVariant` | B — Occasional Change | Timestamp Incremental | Which current rows indicate that they changed? | Expected to be required | Expected to be required | Not inherently provided by mechanism | Reliable watermark required | Changed current state | Pending implementation validation |
| `catalog.Brand` | B — Occasional Change | Timestamp Incremental | Which current rows indicate that they changed? | Expected to be required | Expected to be required | Not inherently provided by mechanism | Reliable watermark required | Changed current state | Pending implementation validation |
| `catalog.Category` | B — Occasional Change | Timestamp Incremental | Which current rows indicate that they changed? | Expected to be required | Expected to be required | Not inherently provided by mechanism | Reliable watermark required | Changed current state | Pending implementation validation |
| `catalog.ProductCategory` | D — Low Change / No Watermark | Snapshot + Diff | What is different between previous and current state? | Derived as ADDED | Not currently modeled as row-level UPDATE | Derived as REMOVED | No | State comparison | Pending implementation validation |
| `sales.TransactionStatus` | C — Reference | Controlled Full Refresh | What is the authoritative current state? | Reflected in refreshed state | Reflected in refreshed state | Reflected as absence in current state, not as event | No | Current-state oriented | Pending implementation validation |
| `sales.TransactionChannel` | C — Reference | Controlled Full Refresh | What is the authoritative current state? | Reflected in refreshed state | Reflected in refreshed state | Reflected as absence in current state, not as event | No | Current-state oriented | Pending implementation validation |

### 11.2 Reading the Matrix Correctly

The matrix deliberately uses different wording for different mechanisms.

For CDC:

```text
INSERT
UPDATE
DELETE
```

represent captured source changes.

For Timestamp Incremental:

```text
INSERT
UPDATE
```

mean that newly created or modified current rows are expected to become discoverable through a validated watermark.

This is not equivalent to capturing every source event.

For Snapshot and Diff:

```text
ADDED
REMOVED
```

are derived by comparing accepted states.

They are not necessarily observed source INSERT and DELETE events.

For Controlled Full Refresh:

```text
added
changed
removed
```

are represented through the new authoritative current state.

The mechanism does not inherently preserve the individual operations that created that state.

Therefore:

> **Similar downstream outcomes do not imply identical source evidence.**

### 11.3 Mechanism Mental Model

The V1 matrix can be summarized by four questions:

```text
CDC
→ What happened?

Timestamp Incremental
→ Which rows say they changed?

Snapshot + Diff
→ What is different?

Controlled Full Refresh
→ What is the current state?
```

These questions describe the fundamental evidence model of each mechanism.

### 11.4 Transactional Sources

The transactional core uses:

```text
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC
```

The selection reflects the current requirement for:

```text
high-change capture
+
INSERT visibility
+
UPDATE visibility
+
hard DELETE visibility
+
source-side transactional context
+
OLTP protection
```

Source-side implementation evidence currently exists through:

```text
M01.19
```

This includes controlled evidence for:

```text
INSERT
UPDATE BEFORE / AFTER
multiple commands in one SQL transaction
hard DELETE
cross-table transactional context
ON DELETE CASCADE effects
```

This evidence validates important source-side CDC behavior.

It does not validate the complete downstream architecture.

### 11.5 Descriptive Sources

The following descriptive sources use the V1 Timestamp Incremental hypothesis:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

The selection assumes that a reliable watermark can expose required current-row changes without the additional operational complexity of CDC.

However, the following remain pending:

```text
actual watermark semantics
timestamp ownership
precision
boundary behavior
equal timestamp handling
commit visibility behavior
hard DELETE requirement
checkpoint implementation
restart behavior
source query performance
```

Therefore, the matrix intentionally describes them as:

```text
Pending implementation validation
```

rather than:

```text
Validated
```

### 11.6 Relationship Source

The relationship source:

```text
catalog.ProductCategory
```

uses:

```text
Snapshot + Diff
```

because no reliable timestamp watermark has been identified in the current structure.

Its comparison identity is currently based on:

```text
PRDCT_PRD_id
+
PRDCT_CTG_id
```

The mechanism derives:

```text
ADDED
=
Current - Previous
```

and:

```text
REMOVED
=
Previous - Current
```

The strategy does not claim that it observes the exact INSERT or DELETE events that produced those state differences.

Implementation validation remains pending.

### 11.7 Reference Sources

The reference sources:

```text
sales.TransactionStatus
sales.TransactionChannel
```

use:

```text
Controlled Full Refresh
```

because the current V1 requirement is authoritative current state rather than event-level history.

Their currently observed source state is:

```text
TransactionStatus
1 PENDING
2 CONFIRMED
3 COMPLETED
4 CANCELLED
5 FAILED
```

and:

```text
TransactionChannel
1 ONLINE
2 STORE
```

These values represent the current known source inventory.

They do not establish permanent row-count limits.

For example:

```text
2 channels observed today
```

does not mean:

```text
exactly 2 channels are allowed forever
```

A legitimate future source change must remain possible.

### 11.8 DELETE Semantics by Mechanism

DELETE behavior differs significantly across the four mechanisms.

#### CDC

```text
source hard DELETE
        ↓
captured DELETE change
```

For the transactional sources, this behavior has been demonstrated in controlled SQL Server CDC tests.

#### Timestamp Incremental

```text
row hard deleted
        ↓
row disappears
        ↓
timestamp query has no row to retrieve
```

Therefore:

```text
hard DELETE
```

is not inherently provided by Timestamp Incremental.

If DELETE visibility becomes mandatory for a Category B source, the strategy must be revisited or complemented.

#### Snapshot + Diff

```text
relationship existed before
        +
does not exist now
        ↓
REMOVED
```

This derives disappearance from state comparison.

It does not prove the exact source DELETE event.

#### Controlled Full Refresh

```text
value existed previously
        +
not present in new authoritative state
        ↓
current downstream state reflects absence
```

Again, this is state reconciliation rather than event capture.

### 11.9 Watermark Dependency Matrix

The mechanisms differ in how they represent capture progress.

| Mechanism | Primary Boundary Concept | Reliable Timestamp Required |
|---|---|---|
| SQL Server Native CDC | CDC LSN range | No |
| Timestamp Incremental | Source watermark + platform checkpoint | Yes |
| Snapshot + Diff | Previous accepted snapshot | No |
| Controlled Full Refresh | Previous accepted refresh state | No |

This distinction is important because:

```text
LSN
timestamp
snapshot
refresh state
```

are not interchangeable concepts.

Each mechanism requires its own progress and recovery semantics.

### 11.10 Change Fidelity Matrix

The mechanisms also differ in the amount of historical change detail they can provide.

| Mechanism | Change Fidelity |
|---|---|
| SQL Server Native CDC | Captured source changes after the CDC boundary |
| Timestamp Incremental | Current rows that indicate change after the watermark boundary |
| Snapshot + Diff | Net difference between two accepted states |
| Controlled Full Refresh | Authoritative current state at refresh time |

Conceptually:

```text
CDC

State A
  ↓
Change 1
  ↓
State B
  ↓
Change 2
  ↓
State C

Potentially observable:
Change 1
Change 2
```

versus:

```text
Timestamp Incremental

State A
  ↓
multiple source changes
  ↓
State C

Potentially observable:
current changed row = State C
```

versus:

```text
Snapshot + Diff

Snapshot A
  ↓
intermediate activity
  ↓
Snapshot C

Observable:
A vs C
```

versus:

```text
Full Refresh

Refresh A
  ↓
source activity
  ↓
Refresh C

Observable:
authoritative state C
```

Therefore:

> **Capture mechanism determines not only how data is acquired, but also what kind of historical evidence can exist.**

### 11.11 Initial-State Behavior

The mechanisms also differ in how they handle data that already exists when capture begins.

| Mechanism | Initial-State Treatment |
|---|---|
| SQL Server Native CDC | Separate Initial Backfill required; CDC does not retroactively capture existing rows |
| Timestamp Incremental | Initial source-state load required before steady-state incremental processing |
| Snapshot + Diff | First snapshot establishes baseline |
| Controlled Full Refresh | First validated refresh establishes authoritative state |

None of these mechanisms is allowed to invent historical events that were never observed.

### 11.12 Recovery Considerations

Each mechanism has a different recovery dependency.

#### CDC

Recovery depends on:

```text
available CDC range
+
consumer checkpoint
+
retention window
+
replay correctness
```

The V1 CDC retention decision is:

```text
15 days
```

#### Timestamp Incremental

Recovery will depend on:

```text
reliable persisted checkpoint
+
safe boundary semantics
+
ability to reread source
+
idempotent downstream processing
```

Implementation validation is pending.

#### Snapshot + Diff

Recovery depends on:

```text
previous accepted snapshot
+
candidate snapshot
+
safe retry
+
idempotent diff processing
```

Implementation validation is pending.

#### Controlled Full Refresh

Recovery primarily depends on:

```text
preserving previous accepted state
+
safe candidate refresh
+
controlled promotion
```

Implementation validation is pending.

### 11.13 Operational Complexity Comparison

The mechanisms deliberately have different operational footprints.

Conceptually:

```text
CDC
        ↓
higher capture infrastructure complexity

Timestamp Incremental
        ↓
watermark and checkpoint complexity

Snapshot + Diff
        ↓
state storage and comparison complexity

Controlled Full Refresh
        ↓
lowest capture complexity
for small reference datasets
```

This must not be interpreted as a universal ranking.

For example, Snapshot and Diff applied to an extremely large table could become operationally expensive.

Likewise, Controlled Full Refresh applied to a massive source could become inappropriate.

The current matrix reflects the characteristics and requirements of the current V1 sources.

### 11.14 OLTP Protection View

The selected mechanisms also reflect the principle:

> **The health of the OLTP system takes priority over analytical convenience.**

Conceptually:

```text
HIGH-CHANGE TRANSACTIONAL DATA
        ↓
avoid repeated analytical scans
        ↓
CDC
```

```text
OCCASIONAL DESCRIPTIVE CHANGE
        ↓
potentially targeted incremental reads
        ↓
Timestamp Incremental
```

```text
LOW-CHANGE SMALL RELATIONSHIP STATE
        ↓
manageable complete state comparison
        ↓
Snapshot + Diff
```

```text
TINY REFERENCE STATE
        ↓
complete extraction operationally reasonable
        ↓
Controlled Full Refresh
```

The exact source cost of the pending mechanisms must still be measured during implementation.

### 11.15 Validation Status Model

Atlas Engineering uses the following progression:

```text
HYPOTHESIS
        ↓
SELECTED
        ↓
IMPLEMENTED
        ↓
TESTED
        ↓
VALIDATED
        ↓
PROVEN END-TO-END
```

Not every source is currently at the same stage.

For the current V1 capture strategy:

```text
sales.Transaction
sales.TransactionItem

Selected
Implemented source-side
Tested source-side through M01.19
Not yet proven end-to-end
```

while:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category

Selected as Timestamp Incremental hypothesis
Implementation pending
```

and:

```text
catalog.ProductCategory

Selected as Snapshot + Diff
Implementation pending
```

and:

```text
sales.TransactionStatus
sales.TransactionChannel

Selected as Controlled Full Refresh
Implementation pending
```

This prevents the matrix from presenting architectural intention as operational fact.

### 11.16 End-to-End Boundary

None of the current capture rows should be marked as:

```text
Proven End-to-End
```

at this stage.

Even the CDC sources still require future validation for:

```text
CDC consumption
checkpointing
restart
replay
Debezium
Kafka
Bronze persistence
idempotency
reconciliation
recovery
scale
freshness SLO
```

Therefore:

```text
CDC SOURCE BEHAVIOR VALIDATED
```

must not be rewritten as:

```text
DATA ENGINEERING PIPELINE VALIDATED
```

The latter requires evidence from the complete downstream path.

### 11.17 Matrix Review Triggers

The Capture Strategy Matrix must be reviewed when any relevant source condition changes.

Examples include:

```text
source volume increases significantly

change frequency increases

latency requirement changes

hard DELETE becomes analytically important

reliable watermark proves unreliable

new source columns are introduced

source key semantics change

reference history becomes required

snapshot extraction becomes expensive

CDC operational overhead becomes unacceptable

new recovery requirements appear

downstream data product requirements change
```

A mechanism is not permanent simply because it was correct for V1.

### 11.18 New Source Assessment

Future sources should not be added to the matrix by copying the mechanism of a similar-looking table.

Each source must pass through the selection criteria defined in Chapter 5.

Conceptually:

```text
NEW SOURCE
    ↓
understand business role
    ↓
classify change behavior
    ↓
evaluate seven criteria
    ↓
identify candidate mechanism
    ↓
document assumptions
    ↓
implement
    ↓
test
    ↓
update matrix with evidence
```

Therefore:

> **The matrix is the result of analysis, not a substitute for analysis.**

### 11.19 V1 Consolidated View

The complete V1 source distribution is:

```text
A — HIGH CHANGE
────────────────────────────────────
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC


B — OCCASIONAL CHANGE
────────────────────────────────────
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
Timestamp Incremental
        ↓
watermark validation pending


C — REFERENCE
────────────────────────────────────
sales.TransactionStatus
sales.TransactionChannel
        ↓
Controlled Full Refresh


D — LOW CHANGE / NO WATERMARK
────────────────────────────────────
catalog.ProductCategory
        ↓
Snapshot + Diff
```

Or, from the mechanism perspective:

```text
SQL Server Native CDC
├── sales.Transaction
└── sales.TransactionItem


Timestamp Incremental
├── catalog.Product
├── catalog.ProductVariant
├── catalog.Brand
└── catalog.Category


Snapshot + Diff
└── catalog.ProductCategory


Controlled Full Refresh
├── sales.TransactionStatus
└── sales.TransactionChannel
```

### 11.20 Matrix Summary

The V1 matrix establishes:

```text
NO UNIVERSAL CAPTURE MECHANISM
```

Instead:

```text
source characteristics
+
analytical requirements
+
change fidelity requirement
+
DELETE requirement
+
watermark capability
+
latency
+
volume
+
OLTP protection
+
operational cost
        ↓
appropriate capture mechanism
```

The strategy deliberately produces a heterogeneous capture layer.

This is not architectural inconsistency.

It is the result of applying the same decision principles to sources with different behavior.

The governing principle is:

> **One analytical domain does not require one capture mechanism.**

And the evidence principle is:

> **The matrix records what has been selected and what has actually been validated; it must never collapse those two states into one.**

---

## 12. Trade-offs and Accepted Limitations

The V1 Capture Strategy intentionally accepts a number of limitations.

These limitations are not undocumented defects.

They are consequences of deliberate architectural choices made to balance:

```text
correctness
+
operational simplicity
+
source protection
+
recoverability
+
implementation scope
```

The objective of V1 is not to maximize capture fidelity for every source.

The objective is to use an appropriate mechanism for each source while making the consequences of that choice explicit.

This chapter records those consequences.

The governing principle is:

> **A limitation is acceptable only when it is understood, documented, and consistent with the current requirement.**

### 12.1 Heterogeneous Capture Is Intentional

Atlas Engineering does not use one universal capture mechanism.

The V1 strategy contains:

```text
SQL Server Native CDC
Timestamp Incremental
Snapshot + Diff
Controlled Full Refresh
```

This introduces architectural heterogeneity.

Different mechanisms require different:

```text
boundaries
checkpoints
recovery models
failure handling
testing procedures
operational monitoring
```

A more uniform architecture could appear simpler conceptually.

For example:

```text
CDC everywhere
```

would reduce the number of capture patterns.

However, it would also introduce CDC infrastructure where change-level capture is not currently required.

Likewise:

```text
Full Refresh everywhere
```

would reduce mechanism diversity but could create unnecessary source workloads and insufficient change fidelity for transactional tables.

Therefore, V1 accepts:

```text
more than one capture pattern
```

in exchange for:

```text
better alignment between
source behavior and mechanism
```

The accepted trade-off is:

> **Capture-layer uniformity is sacrificed when necessary to avoid unnecessary complexity or insufficient correctness.**

### 12.2 CDC Retention Is Finite

The V1 CDC recovery window is:

```text
15 days
21600 minutes
```

This means SQL Server CDC does not retain source changes indefinitely.

Captured data older than the configured retention window can become eligible for cleanup.

Therefore:

```text
CDC
≠
permanent historical storage
```

The accepted limitation is that recovery directly from SQL Server CDC is time-bounded.

If a downstream consumer remains unavailable beyond the recoverable CDC range before the relevant changes are durably acquired elsewhere, those changes may no longer be available from CDC.

The architecture mitigates this by planning for durable downstream layers such as:

```text
Kafka
Bronze
```

but these stages are not yet implemented and validated end-to-end.

Therefore:

> **The 15-day window provides recovery opportunity, not unlimited recovery.**

### 12.3 CDC Does Not Reconstruct Pre-Enable History

SQL Server CDC begins from its established capture boundary.

Existing rows are not retroactively transformed into historical CDC events.

The implementation evidence already demonstrated:

```text
source rows existed
+
new CDC Change Table contained no
automatic historical events
```

for both:

```text
sales.Transaction
sales.TransactionItem
```

Therefore, V1 accepts that:

```text
pre-CDC event history
```

cannot be reconstructed from CDC itself.

The platform will instead use:

```text
Initial Backfill
```

to establish known pre-boundary source state.

The accepted limitation is:

> **Historical business rows can be loaded, but historical event sequences that were never captured must not be invented.**

### 12.4 Backfill Provides State, Not Complete Historical Evolution

Initial Backfill can retrieve:

```text
what the row contains
at extraction time
```

It cannot necessarily determine:

```text
all values that row held
before extraction
```

For example:

```text
backfill state
Status = COMPLETED
```

does not prove:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

Likewise:

```text
backfill price = 150
```

does not prove that the price previously passed through:

```text
100
120
150
```

V1 therefore accepts incomplete event-level knowledge before the capture boundary.

This is an evidence limitation, not something the platform should attempt to conceal.

### 12.5 Timestamp Incremental Depends on Source Semantics

Timestamp Incremental is simpler operationally than CDC for the intended Category B sources, but this simplicity comes with strong assumptions.

The mechanism depends on a reliable watermark.

If:

```text
a relevant row changes
```

without:

```text
the watermark changing
```

then the incremental query may never retrieve that update.

The candidate sources are:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

Their watermark reliability remains pending implementation validation.

Therefore, the V1 strategy accepts the mechanism only conditionally.

If testing demonstrates that the watermark is unreliable, the strategy must change.

The accepted trade-off is:

```text
lower capture complexity
```

in exchange for:

```text
dependence on reliable source-maintained
change metadata
```

### 12.6 Timestamp Incremental Does Not Inherently Detect Hard DELETE

A hard-deleted row no longer exists in the source.

Therefore a later query such as:

```sql
WHERE updated_at > @last_watermark
```

cannot retrieve it.

Timestamp Incremental can potentially observe:

```text
INSERT
UPDATE
```

but does not inherently observe:

```text
hard DELETE
```

The V1 Category B strategy therefore accepts this limitation only if the business requirement permits it or if a complementary deletion mechanism is later introduced.

If DELETE visibility becomes mandatory, the mechanism must be reconsidered.

### 12.7 Timestamp Incremental May Not Preserve Intermediate States

Suppose a source row changes multiple times between incremental extractions:

```text
State A
  ↓
State B
  ↓
State C
  ↓
next extraction
```

The source may expose only:

```text
State C
```

when queried.

Timestamp Incremental may therefore establish:

```text
this row changed
and its current state is C
```

without recovering:

```text
A → B → C
```

as separate events.

This is an accepted consequence of using current-row watermark semantics instead of event-level change capture.

Therefore:

> **Timestamp Incremental provides changed-state fidelity, not guaranteed intermediate-event fidelity.**

### 12.8 Timestamp Boundaries Can Require Controlled Overlap

Multiple rows may share the same timestamp.

Commit visibility may also require boundary protection.

A simple predicate using:

```text
>
```

can reduce overlap but may create loss risk if a boundary is incomplete.

A strategy using:

```text
>=
```

or a lookback window can reduce gap risk but deliberately rereads data.

This introduces:

```text
duplicates
reprocessing
deduplication requirements
```

V1 accepts controlled overlap as preferable to silent loss.

However, the final timestamp boundary algorithm remains pending implementation testing.

### 12.9 Snapshot and Diff Captures Net State Difference

Snapshot and Diff compares:

```text
previous accepted state
```

with:

```text
current accepted state
```

It can derive:

```text
ADDED
REMOVED
UNCHANGED
```

but not necessarily every intermediate event.

For example:

```text
relationship exists
        ↓
removed
        ↓
recreated
        ↓
next snapshot
```

may result in:

```text
UNCHANGED
```

because the initial and final states are identical.

Therefore:

> **Snapshot and Diff provides state-transition visibility between observations, not complete event history between observations.**

This is accepted for `catalog.ProductCategory` because the V1 strategy prioritizes relationship state rather than event-level relationship history.

### 12.10 Snapshot Frequency Limits Temporal Precision

If snapshots occur periodically, a derived removal only establishes that the relationship disappeared between two observations.

For example:

```text
Snapshot A
10:00
relationship exists

Snapshot B
11:00
relationship absent
```

The platform can establish:

```text
removal occurred sometime
between 10:00 and 11:00
```

It cannot prove:

```text
DELETE occurred exactly at 11:00
```

unless another authoritative source provides that timestamp.

The accepted limitation is reduced event-time precision.

### 12.11 Snapshot Completeness Is Critical

Snapshot and Diff can produce false changes if the current snapshot is incomplete.

For example:

```text
previous snapshot
A B C
```

and an extraction failure produces:

```text
current snapshot
A B
```

A naive comparison derives:

```text
REMOVE C
```

even though C may still exist in the source.

Therefore, V1 accepts the operational requirement that:

```text
snapshot validation
```

must occur before:

```text
diff acceptance
```

This makes the mechanism slightly more operationally complex than a simple set comparison.

That complexity is necessary for correctness.

### 12.12 Snapshot and Diff Requires Previous Accepted State

Unlike stateless source queries, Snapshot and Diff requires preserving a previous accepted snapshot.

If that state is corrupted or lost, the next comparison cannot reliably determine:

```text
what was added
what was removed
```

The platform must therefore manage snapshot state as part of the capture mechanism.

This introduces:

```text
storage
promotion
recovery
versioning
retry
```

concerns.

The strategy accepts this overhead because no reliable watermark has been identified for the current source.

### 12.13 Controlled Full Refresh Does Not Preserve Source Event History

Controlled Full Refresh retrieves the authoritative current state.

Suppose:

```text
3 COMPLETED
```

becomes:

```text
3 CLOSED
```

The next accepted refresh can establish:

```text
3 CLOSED
```

but does not inherently preserve:

```text
when the change happened
how many intermediate changes occurred
which transaction performed it
```

This is accepted because the current V1 requirement for:

```text
sales.TransactionStatus
sales.TransactionChannel
```

is state-oriented.

If historical reference evolution later becomes analytically important, the capture strategy must be reviewed.

### 12.14 Full Refresh Can Temporarily Lag Source State

Controlled Full Refresh operates periodically.

A source change occurring immediately after a refresh remains absent downstream until the next successful refresh.

Therefore:

```text
source state
```

and:

```text
downstream reference state
```

may temporarily differ.

This lag is an accepted consequence of periodic state refresh.

The final acceptable schedule must be aligned with business requirements during implementation.

### 12.15 Full Refresh Simplicity Depends on Source Size

Controlled Full Refresh is operationally attractive because the current reference datasets are small.

This assumption may cease to hold if the source grows substantially.

For example:

```text
2 rows
```

or:

```text
5 rows
```

are trivial to retrieve in full.

A future reference dataset containing:

```text
millions of rows
```

could make the same strategy inappropriate.

Therefore, the accepted mechanism is conditional on the current source characteristics.

### 12.16 Current Row Counts Are Not Permanent Contracts

The currently observed baseline contains:

```text
TransactionStatus
5 rows

TransactionChannel
2 rows
```

These counts are useful evidence.

They must not automatically become permanent hard-coded limits.

A future legitimate change could introduce:

```text
new status
new channel
```

The strategy therefore accepts that validation must distinguish:

```text
unexpected extraction anomaly
```

from:

```text
legitimate business evolution
```

A validation rule that assumes:

```text
row count must never change
```

would be too brittle without an explicit business contract.

### 12.17 CDC Transaction Context Does Not Prove Downstream Atomicity

The source-side laboratory demonstrated that related changes can share:

```text
__$start_lsn
```

across CDC capture instances when generated by the same SQL transaction.

For example:

```text
Transaction INSERT
+
TransactionItem INSERT
+
TransactionItem INSERT
```

shared transaction-level CDC context.

Likewise, the M01.19 cascade DELETE demonstrated:

```text
parent DELETE
+
child DELETEs
```

within the same source transaction context.

This evidence is valuable.

However, V1 explicitly accepts that the following remain unknown until tested:

```text
Debezium representation
Kafka topic behavior
cross-topic ordering
consumer transaction reconstruction
atomic downstream processing
```

Therefore:

> **Source transactional context must not be mistaken for proven end-to-end atomic delivery.**

### 12.18 Application Action Does Not Equal CDC Row Count

A single logical application operation can produce multiple physical database changes.

The M01.19 evidence demonstrated:

```text
1 explicit parent DELETE
```

resulting in:

```text
1 Transaction DELETE
+
2 TransactionItem DELETEs
```

because of:

```text
ON DELETE CASCADE
```

Therefore, V1 accepts that CDC event interpretation requires context.

A downstream system must not assume:

```text
3 DELETE rows
=
3 explicit application DELETE statements
```

The capture layer preserves physical source changes.

Business interpretation belongs to later semantic processing.

### 12.19 Partition SWITCH Is Not Ordinary Row-Level CDC

The CDC-enabled transactional tables are partitioned.

The V1 CDC configuration currently allows:

```text
allow_partition_switch = 1
```

SQL Server partition `SWITCH` operations do not behave like ordinary row-level DML for CDC purposes.

Therefore, the strategy accepts that:

```text
physical partition movement
```

may not produce the same capture semantics as:

```text
INSERT
UPDATE
DELETE
```

Rather than disabling `SWITCH` preventively, V1 governs its use.

The accepted limitation is that any future partition movement must be coordinated explicitly with Data Engineering.

### 12.20 SWITCH OUT Is Not a Business DELETE

A future:

```text
SWITCH OUT
```

may physically remove rows from the active transactional table for archival purposes.

That does not necessarily mean:

```text
the sale no longer exists
```

From an analytical perspective, historical sales may remain valid indefinitely.

Therefore, V1 accepts a semantic distinction between:

```text
physical source storage movement
```

and:

```text
business deletion
```

The capture layer must not manufacture DELETE semantics simply because rows change physical storage location.

### 12.21 SWITCH IN Is Not the Normal Ingestion Path

The normal operational path remains:

```text
application DML
        ↓
SQL Server transaction
        ↓
Transaction Log
        ↓
CDC
```

Using `SWITCH IN` as a normal transactional ingestion mechanism could bypass the expected row-level CDC semantics.

Therefore, V1 does not support `SWITCH IN` as the normal sales ingestion path.

If such a requirement appears later, it becomes an explicit strategy review trigger.

### 12.22 Asynchronous CDC Introduces Visibility Delay

SQL Server CDC is asynchronous.

Therefore:

```text
source transaction COMMIT
```

does not mean:

```text
CDC row immediately queryable
```

The laboratory observed this behavior repeatedly.

The current capture job uses:

```text
polling interval = 5 seconds
```

and controlled tests often waited approximately:

```text
6 seconds
```

before inspecting captured changes.

V1 accepts this asynchronous visibility model.

The observed delay must not be interpreted as a production end-to-end guarantee.

### 12.23 Laboratory Timing Is Not an SLO

The current laboratory has observed changes appearing after short delays.

Those observations validate asynchronous CDC behavior.

They do not prove:

```text
P95 ≤ 15 minutes
```

for the complete Data Engineering Platform.

The formal freshness SLO includes future stages such as:

```text
CDC consumption
Debezium
Kafka
consumer
Bronze
```

Therefore, V1 accepts that source-side timing evidence and end-to-end freshness evidence are separate.

### 12.24 Recovery and Freshness Are Different Dimensions

The platform currently distinguishes:

```text
freshness
→ minutes
```

from:

```text
CDC recovery window
→ days
```

For example:

```text
Typical freshness target
≈ 3–5 minutes

Formal P95 SLO
≤ 15 minutes

CDC retention
15 days
```

The accepted trade-off is maintaining a much larger recovery window than normal delivery latency.

This consumes additional CDC storage but provides operational resilience.

### 12.25 More Retention Means More Source-Side Storage

Increasing CDC retention improves recovery opportunity but also retains more CDC data.

Conceptually:

```text
longer retention
        ↓
more recoverable history
        +
more CDC storage
```

The selected 15-day window therefore represents a balance.

It may require revision when real change volume and storage growth are observed.

V1 does not claim that 15 days is permanently optimal.

### 12.26 Downstream Idempotency Is Required but Not Yet Proven

Controlled overlap and At-Least-Once delivery rely on the future platform being able to process repeated information safely.

Conceptually:

```text
duplicate delivery
        ↓
same logical outcome
```

This requires idempotency.

The architectural strategy has selected:

```text
At-Least-Once
+
Idempotency
```

However, end-to-end idempotent processing has not yet been implemented or validated.

Therefore, V1 accepts a temporary architectural dependency on future implementation work.

The decision exists.

The proof does not yet exist.

### 12.27 Exactly-Once Is Not Claimed

Atlas Engineering does not currently claim:

```text
end-to-end Exactly-Once
```

The selected delivery philosophy intentionally favors:

```text
At-Least-Once
+
Idempotency
```

This means duplicate processing is considered an expected condition that must be governed.

The accepted trade-off is:

```text
possible duplicate delivery
```

instead of attempting to claim a stronger guarantee that has not been proven across all platform layers.

### 12.28 Source Capture Cannot Solve All Downstream Semantics

The capture layer can provide:

```text
source changes
changed rows
state differences
current state
```

depending on mechanism.

It cannot by itself guarantee:

```text
business semantic correctness
Silver deduplication
Gold dimensional correctness
Power BI metric correctness
```

For example, CDC can expose:

```text
status changed from 2 to 3
```

but the business interpretation of those values depends on reference data and downstream modeling.

Therefore:

> **Capture correctness is necessary but insufficient for analytical correctness.**

### 12.29 Capture Does Not Own Permanent Historical Storage

SQL Server CDC and source extraction mechanisms exist close to the OLTP system.

Permanent historical retention belongs downstream.

Conceptually:

```text
SOURCE CAPTURE
        ↓
temporary operational acquisition responsibility

BRONZE
        ↓
durable ingestion history
```

V1 accepts that source capture mechanisms may have finite history because permanent analytical history belongs elsewhere.

The downstream durability path remains pending implementation.

### 12.30 Capture Cannot Guarantee Recovery Without Checkpoints

Retention alone does not tell the platform:

```text
where processing stopped
```

Likewise, a source watermark alone does not establish:

```text
what was durably processed
```

Recovery requires persisted progress state.

Depending on mechanism, this may include:

```text
CDC LSN checkpoint

Timestamp watermark checkpoint

accepted snapshot state

accepted refresh state
```

These mechanisms remain partially or entirely pending.

Therefore:

> **Availability of source data does not equal recoverability unless processing progress is also known.**

### 12.31 Capture Strategy Does Not Eliminate Reconciliation

Even well-designed capture mechanisms can fail.

Potential causes include:

```text
software defects
checkpoint defects
unexpected source behavior
schema evolution
operational incidents
consumer failures
manual errors
```

Therefore, V1 accepts that reconciliation remains necessary.

Capture should reduce the probability of inconsistency.

It should not create the illusion that inconsistency is impossible.

### 12.32 Reconciliation May Need Multiple Evidence Types

A single metric is unlikely to prove full correctness.

For example:

```text
row count matches
```

does not prove:

```text
data matches
```

Future reconciliation may combine:

```text
row counts
key comparisons
aggregates
business totals
hashes
sampling
source-to-target checks
```

The exact controls remain outside the current implementation stage.

### 12.33 Source Availability Remains a Dependency

Every source-side capture mechanism ultimately depends on the source being operationally accessible in some form.

For example:

```text
Timestamp Incremental
Snapshot + Diff
Controlled Full Refresh
```

require querying the source.

CDC depends on SQL Server capture infrastructure remaining healthy and retained data remaining available.

The Data Engineering Platform cannot completely eliminate source dependencies at the initial acquisition boundary.

The architecture instead aims to reduce those dependencies after durable downstream persistence.

### 12.34 Schema Evolution Can Break Capture Assumptions

A source schema change may affect:

```text
capture columns
keys
watermarks
data types
relationship semantics
CDC captured-column configuration
snapshot comparison
full-refresh contracts
```

Therefore, V1 accepts that capture configuration and schema contracts must evolve together.

A source schema cannot be assumed permanently static.

### 12.35 Mechanism Decisions Are Revisable

A selected V1 mechanism is not permanent.

A source may outgrow its current strategy.

Examples include:

```text
Product changes become extremely frequent

Product DELETE becomes business-critical

ProductCategory grows dramatically

TransactionStatus requires full historical versioning

reference refresh latency becomes insufficient

CDC operational cost changes
```

Such changes may justify a new mechanism.

Therefore:

> **V1 approval means appropriate for current requirements, not immutable forever.**

### 12.36 Operational Simplicity Is a Requirement

A technically sophisticated solution can still be architecturally poor if its operational burden exceeds the value it provides.

For example, using CDC for every two-row reference table would increase:

```text
configuration
monitoring
storage
cleanup
consumer complexity
```

without necessarily improving the analytical result.

V1 explicitly accepts simpler state-based mechanisms when they satisfy the requirement.

This is a trade-off in favor of maintainability.

### 12.37 Simplicity Must Not Override Correctness

The inverse is also true.

A simple mechanism is not acceptable merely because it is easy to build.

For example:

```text
WHERE updated_at > @watermark
```

is operationally simple.

If the watermark is unreliable, it can silently lose data.

Likewise:

```text
replace downstream with current snapshot
```

is simple.

If the snapshot is incomplete, it can manufacture mass removals.

Therefore:

> **Simplicity is valuable only after correctness requirements are satisfied.**

### 12.38 Accepted V1 Trade-off Summary

The major V1 trade-offs can be consolidated as follows:

| Decision | Benefit | Accepted Limitation |
|---|---|---|
| Multiple capture mechanisms | Better source-mechanism fit | Higher architectural and operational heterogeneity |
| SQL Server CDC for transactional sources | Change-level visibility including hard DELETE | Additional CDC infrastructure and finite retention |
| 15-day CDC retention | Larger recovery opportunity | Greater CDC storage usage |
| Initial Backfill | Loads existing pre-boundary source state | Does not reconstruct historical event sequences |
| Timestamp Incremental | Lower complexity for occasional-change sources | Depends on reliable watermark; hard DELETE not inherent |
| Controlled overlap | Reduces risk of silent loss | Requires downstream idempotency and reconciliation |
| Snapshot + Diff | Detects state additions/removals without watermark | Intermediate events and precise event time may be lost |
| Controlled Full Refresh | Simple authoritative-state capture | Does not inherently preserve event history |
| `allow_partition_switch = 1` | Preserves future partition-management flexibility | `SWITCH` must be governed outside normal row-level CDC assumptions |
| At-Least-Once + Idempotency | Prefer recoverable duplicates over loss | Duplicate delivery must be handled correctly |
| Source-side evidence first | Prevents unproven downstream claims | Full platform validation takes additional implementation stages |

### 12.39 What V1 Explicitly Does Not Claim

At the current project stage, the Capture Strategy does not claim that the following have been proven:

```text
Timestamp Incremental correctness

Snapshot + Diff implementation correctness

Controlled Full Refresh implementation correctness

final CDC consumer checkpoint model

CDC restart and replay behavior

Debezium SQL Server behavior in Atlas Engineering

Debezium transaction metadata behavior

Kafka transaction correlation

cross-topic ordering

atomic multi-table delivery

Bronze persistence

Bronze replay

end-to-end idempotency

end-to-end recovery

production-scale throughput

production backlog catch-up

P95 end-to-end freshness achievement
```

These are future implementation and validation responsibilities.

### 12.40 Accepted Limitation Governance

Accepted limitations must remain visible.

They should be revisited when:

```text
requirements change
evidence contradicts assumptions
source behavior changes
failure experience exposes weakness
scale changes
operational cost changes
downstream architecture changes
```

The process is:

```text
accepted limitation
        ↓
monitor assumption
        ↓
new evidence
        │
        ├── assumption remains valid
        │      ↓
        │   retain strategy
        │
        └── assumption no longer valid
               ↓
            revise strategy
```

This prevents the phrase:

```text
accepted limitation
```

from becoming:

```text
ignore forever
```

### 12.41 Trade-off Principle

The V1 strategy can therefore be summarized as:

```text
DO NOT MAXIMIZE
capture fidelity
at any operational cost

DO NOT MINIMIZE
implementation complexity
at the cost of correctness

INSTEAD
balance
correctness
+
source protection
+
recovery
+
latency
+
operational simplicity
```

The governing principle is:

> **Atlas Engineering accepts known limitations deliberately; it does not accept unknown limitations accidentally.**

And the evidence principle remains:

> **When a limitation has not yet been tested, it must remain an explicit assumption rather than being silently promoted to fact.**

---

## 13. Strategy Boundaries

The Capture Strategy defines how source data and source changes are identified and acquired from AtlasCommerce.

Its responsibility ends when the platform has a reliable way to determine:

```text
what source state must be acquired
```

or:

```text
what source change became observable
```

according to the mechanism selected for each source.

The strategy therefore covers the source-side acquisition boundary.

It does not define the complete downstream processing architecture.

The governing boundary is:

> **Capture Strategy ends when required source changes or authoritative source state can be reliably identified and acquired.**

Everything that happens after that point belongs to another architectural or implementation concern.

For the Atlas Engineering V1 architecture, the broader responsibility flow is:

```text
AtlasCommerce
        ↓
Capture Mechanism
        ↓
identified / acquired source data
        ↓
────────────────────────────────
downstream ingestion / delivery
        ↓
persistence / processing
        ↓
analytical data products
```

The exact downstream path depends on the selected capture mechanism and its corresponding implementation.

The Capture Strategy is responsible only for the initial portion:

```text
AtlasCommerce
        ↓
Capture Mechanism
        ↓
identified / acquired source data
```

It does not claim ownership of the complete downstream path.

### 13.1 Included Responsibility

The Capture Strategy includes decisions about:

```text
which sources require capture

how source changes are classified

which capture mechanism is appropriate

whether DELETE visibility is required

whether a reliable watermark is necessary

whether current state is sufficient

whether state comparison is required

how initial source state is treated

how the transition to ongoing capture is governed

how source-side recovery opportunity is considered

what source-side limitations are accepted
```

For the current V1 domain, these decisions result in:

```text
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC


catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
        ↓
Timestamp Incremental


catalog.ProductCategory
        ↓
Snapshot + Diff


sales.TransactionStatus
sales.TransactionChannel
        ↓
Controlled Full Refresh
```

The strategy also defines the reasoning behind those selections.

### 13.2 Source Acquisition Is the Boundary

The key distinction is between:

```text
ACQUISITION
```

and:

```text
DELIVERY / PROCESSING
```

Capture answers:

```text
What must be acquired?
How can we identify it?
What evidence does the source provide?
```

Downstream processing answers:

```text
How is it transported?

How is progress persisted?

How is it retried?

How is it stored?

How is it transformed?

How is it deduplicated?

How is it modeled?

How is it served analytically?
```

These are related concerns, but they are not the same responsibility.

### 13.3 CDC Capture Versus CDC Consumption

The current CDC strategy covers source-side SQL Server CDC behavior.

This includes concepts such as:

```text
capture instance

Change Table

LSN

INSERT capture

UPDATE BEFORE / AFTER

DELETE capture

transaction context

retention

cleanup

partition SWITCH governance
```

It does not yet define the complete CDC consumption model.

For example:

```text
CDC Change Table
        ↓
which LSN range should be read?
        ↓
how should from_lsn be persisted?
        ↓
how should to_lsn be selected?
        ↓
what happens after restart?
        ↓
how is overlap handled?
```

These questions belong to:

```text
CDC Consumption
```

rather than the Capture Strategy.

This distinction becomes particularly important in the next implementation stage.

### 13.4 CDC Functions Are Consumption Concerns

SQL Server provides CDC consumption functions such as:

```text
cdc.fn_cdc_get_all_changes_<capture_instance>
```

and LSN-management functions used to construct capture windows.

These functions are relevant to the implementation of a CDC reader.

They do not determine why the source uses CDC.

Therefore:

```text
WHY CDC?
```

belongs here.

```text
HOW A CONSUMER READS CDC WINDOWS?
```

belongs to the CDC consumption implementation.

### 13.5 Checkpoint Implementation Is Outside This Strategy

The Capture Strategy identifies the need for progress boundaries.

Examples include:

```text
CDC
→ LSN-based boundary

Timestamp Incremental
→ watermark boundary

Snapshot + Diff
→ accepted snapshot

Controlled Full Refresh
→ accepted refresh state
```

However, the exact implementation of persisted checkpoints is not defined here.

For example:

```text
checkpoint table

checkpoint file

Kafka offset

database metadata

consumer state store
```

are implementation choices.

The Capture Strategy states:

> **Progress must represent safely completed acquisition or processing.**

It does not yet define the final storage or transaction model for that progress.

### 13.6 Kafka Offset Is Not a Source Capture Boundary

Kafka offsets will later represent position inside Kafka partitions.

They are not equivalent to SQL Server CDC LSNs.

Conceptually:

```text
SQL Server LSN
→ source transaction-log position

Kafka offset
→ position inside one Kafka partition
```

Both are progress concepts.

They exist in different systems and have different semantics.

Therefore:

```text
LSN
≠
Kafka offset
```

A future implementation may correlate them operationally.

This strategy does not treat them as interchangeable boundaries.

### 13.7 Debezium Is Outside the Source Capture Decision

Atlas Engineering V1 includes:

```text
SQL Server Native CDC
        ↓
Debezium
```

Debezium will consume SQL Server CDC and emit change events for downstream messaging.

However, the Capture Strategy decision is:

```text
sales.Transaction
sales.TransactionItem
        ↓
SQL Server Native CDC
```

not:

```text
Debezium directly reads the SQL Server transaction log
```

The source-side change mechanism remains SQL Server Native CDC.

Debezium belongs to the downstream CDC delivery architecture.

Therefore, concerns such as:

```text
Debezium connector configuration

Debezium offsets

transaction metadata

event envelopes

schema evolution behavior

connector restart

snapshot modes

heartbeat behavior
```

are outside the Capture Strategy.

They require separate implementation and validation.

### 13.8 Kafka Delivery Semantics Are Outside This Strategy

Kafka introduces responsibilities such as:

```text
topics

partitions

producer delivery

consumer groups

offsets

ordering

retention

replay

backlog

catch-up
```

These concerns begin after captured data is being delivered downstream.

The Capture Strategy does not define:

```text
topic layout

partition key

partition count

Kafka retention

consumer group strategy

offset commit mechanism

cross-topic ordering
```

Those belong to the messaging and consumption architecture.

### 13.9 Source Transaction Context Does Not Define Kafka Atomicity

SQL Server CDC has already demonstrated source transaction context.

For example:

```text
Transaction
+
TransactionItem
+
TransactionItem
```

created within the same SQL transaction shared source-side CDC transaction context.

This does not prove that future Kafka consumers will receive:

```text
one indivisible atomic package
```

across all related records.

Questions about:

```text
cross-topic atomicity

partition ordering

transaction correlation

consumer reconstruction
```

belong downstream.

The Capture Strategy preserves the source evidence.

It does not claim downstream guarantees that have not been tested.

### 13.10 Bronze Persistence Is Outside This Strategy

Bronze is intended to become the durable ingestion history for the platform.

The broader V1 architecture currently points toward:

```text
Python Consumer
+
PyArrow
        ↓
Parquet
        ↓
MinIO Bronze
```

Capture Strategy does not define:

```text
Parquet schema

file size

row-group size

partition layout

object naming

manifest structure

atomic upload protocol

Bronze metadata columns

object lifecycle policy
```

These belong to Bronze design and implementation.

The capture layer only provides the source information that Bronze will eventually persist.

### 13.11 Capture Retention Is Not Bronze Retention

SQL Server CDC retention and Bronze retention solve different problems.

Conceptually:

```text
CDC RETENTION
→ temporary source-side recovery window
```

versus:

```text
BRONZE RETENTION
→ durable platform ingestion history
```

The current CDC decision is:

```text
15 days
```

This must not be interpreted as:

```text
retain analytical history for 15 days
```

Permanent or long-term analytical retention belongs downstream.

### 13.12 Atomic Bronze Persistence Is Outside This Strategy

The broader architecture intends to follow a sequence similar to:

```text
consume
        ↓
process
        ↓
persist Bronze safely
        ↓
acknowledge progress
```

This principle supports At-Least-Once processing.

However, implementation details such as:

```text
temporary object

atomic rename / promotion

manifest

commit marker

offset commit coordination
```

are outside the Capture Strategy.

They belong to the consumer and Bronze persistence design.

### 13.13 Silver Responsibilities Are Outside This Strategy

Silver is expected to perform responsibilities such as:

```text
typing

normalization

validation

deduplication

idempotency

late-data handling

out-of-order handling

reconciliation

data-quality enforcement

backfill integration

replay handling
```

These activities operate on data that has already crossed the capture boundary.

Therefore, they do not belong to Capture Strategy.

For example:

```text
CDC UPDATE BEFORE
CDC UPDATE AFTER
```

are capture evidence.

How Silver chooses to represent:

```text
current state
```

or:

```text
change history
```

is a Silver modeling decision.

### 13.14 End-to-End Idempotency Is Outside This Strategy

The architecture selects:

```text
At-Least-Once
+
Idempotency
```

as the broader delivery philosophy.

The Capture Strategy supports this by preferring:

```text
controlled overlap
```

to:

```text
silent loss
```

However, the implementation of end-to-end idempotency belongs downstream.

It may eventually involve:

```text
business keys

source metadata

LSN

event identifiers

batch identifiers

object metadata

Silver deduplication logic
```

The final model has not yet been implemented or validated.

Therefore:

> **Capture Strategy may create conditions that require idempotency, but it does not implement end-to-end idempotency.**

### 13.15 Exactly-Once Is Outside This Strategy

The Capture Strategy does not claim:

```text
Exactly-Once
```

for the complete platform.

It also does not attempt to prove such a property at the source capture layer alone.

Exactly-once semantics would require coordinated evidence across:

```text
source capture

Debezium

Kafka

consumer

Bronze

checkpoint

retries

downstream processing
```

No such end-to-end proof currently exists.

The V1 architecture instead uses the more explicit model:

```text
At-Least-Once
+
Idempotency
```

### 13.16 Silver Business Semantics Are Outside This Strategy

Capture records physical or state-level source information.

It does not define final business semantics.

For example:

```text
TransactionStatus = 3
```

may correspond to:

```text
COMPLETED
```

in source reference data.

A later analytical model may group that status as:

```text
Successful
```

Capture Strategy does not own that semantic transformation.

Likewise:

```text
three CDC DELETE rows
```

caused by one cascading parent DELETE do not automatically become:

```text
three independent business deletion actions
```

That interpretation belongs to downstream semantic processing.

### 13.17 Gold Modeling Is Outside This Strategy

The initial Gold V1 scope is expected to support:

```text
Sales Analytics
```

with a fact grain based on:

```text
one row per TransactionItem
associated with its Transaction
```

However, Capture Strategy does not define:

```text
fact table structure

dimension structure

surrogate keys

SCD behavior

fact loading

dimension history

aggregations

certification rules
```

These belong to Warehouse / Gold architecture.

### 13.18 Historical Dimension Management Is Outside This Strategy

The capture mechanism can affect what historical evidence is available.

For example:

```text
CDC
```

may provide richer change evidence than:

```text
Controlled Full Refresh
```

But deciding whether a downstream dimension uses:

```text
Type 1

Type 2

another history model
```

is not a capture decision.

Capture provides evidence.

Dimensional modeling decides how that evidence is represented analytically.

### 13.19 Power BI Is Outside This Strategy

Power BI consumes certified analytical data.

Capture Strategy does not define:

```text
semantic model

measures

DAX

relationships

refresh configuration

row-level security

dashboard design

report layout
```

Those concerns exist after Gold and Certified Gold.

### 13.20 Airflow Orchestration Is Outside This Strategy

Airflow is part of the broader V1 orchestration direction.

It may later orchestrate activities such as:

```text
incremental extraction

snapshot execution

full refresh

backfill

reconciliation

data-quality checks

Gold loading
```

Capture Strategy defines what those operations must accomplish.

It does not define:

```text
DAG structure

task dependencies

retry configuration

scheduling

pools

sensors

Airflow metadata
```

Those belong to orchestration implementation.

### 13.21 Observability Implementation Is Outside This Strategy

The broader architecture includes:

```text
Prometheus
Grafana
```

and may later include:

```text
OpenTelemetry
```

Capture Strategy identifies conditions worth observing, such as:

```text
CDC lag

retention risk

source extraction failures

snapshot anomalies

refresh failures
```

It does not define:

```text
metric names

labels

dashboards

alerts

thresholds

telemetry pipelines
```

These belong to Observability design.

### 13.22 Data Catalog and Metadata Platform Are Outside This Strategy

Future Atlas Engineering architecture may include:

```text
OpenMetadata
```

or another metadata platform.

Capture Strategy provides information that can later contribute to:

```text
lineage

source ownership

capture mechanism

data contracts

operational metadata
```

It does not define the metadata platform implementation itself.

### 13.23 Schema Registry Is Outside This Strategy

The V1 architecture includes:

```text
Apicurio Schema Registry
```

as a transversal contract-governance capability.

Its role is not to define how source changes are captured.

Instead, it governs downstream event or message schemas.

Therefore, Capture Strategy does not define:

```text
subject naming

compatibility mode

schema versioning policy

serialization format

registry lifecycle
```

These belong to data-contract and messaging architecture.

### 13.24 Capture Strategy Does Not Define the Physical Message Path

Architectural diagrams may show:

```text
CDC
        ↓
Debezium
        ↓
Schema Registry
        ↓
Kafka
```

for conceptual clarity.

However, a schema registry is not necessarily a physical transport hop through which every message flows.

Its role is transversal contract governance.

Capture Strategy therefore avoids assigning physical message-routing semantics to components outside the source acquisition boundary.

### 13.25 Recovery Is Shared Across Architectural Layers

Capture has recovery responsibilities, but recovery is not exclusively a capture concern.

Examples:

```text
CDC
→ retained source changes

Kafka
→ retained messages

Bronze
→ durable ingestion history

checkpoint
→ known processing position

Silver
→ repeatable transformation

Gold
→ reloadable analytical state
```

Each layer contributes to recoverability.

Therefore:

> **End-to-end recovery is an architectural property produced by multiple layers, not by source capture alone.**

### 13.26 Replay Is Outside the Capture Strategy

Capture may make replay possible by preserving or exposing recoverable source information.

However:

```text
replaying Kafka

reprocessing Bronze

rerunning Silver

rebuilding Gold
```

are downstream operations.

The Capture Strategy does not define their implementation.

It only ensures that the source acquisition model does not unnecessarily prevent future recovery.

### 13.27 Reconciliation Extends Beyond Capture

Capture-level reconciliation may ask:

```text
did expected source data arrive?
```

Broader platform reconciliation may ask:

```text
does Bronze match ingestion?

does Silver reconcile with Bronze?

does Gold reconcile with Silver?

do business totals reconcile with source?
```

The Capture Strategy only owns the source acquisition portion of that chain.

### 13.28 Performance Beyond the Source Boundary Is Separate

Capture Strategy must protect AtlasCommerce.

Therefore, source-side concerns include:

```text
query cost

CDC overhead

snapshot cost

full-refresh cost

backfill pressure
```

But performance after acquisition belongs to other components.

Examples include:

```text
Kafka throughput

consumer throughput

Parquet write throughput

MinIO performance

Silver processing time

Gold load time

Power BI refresh time
```

These are outside this strategy.

### 13.29 Platform Freshness Is End-to-End

Capture contributes to freshness.

It does not own the complete freshness SLO.

The current architecture distinguishes:

```text
source change
        ↓
capture visibility
        ↓
delivery
        ↓
consumer processing
        ↓
Bronze persistence
```

The formal V1 platform freshness objective is broader than source capture alone.

Therefore:

```text
CDC appears after ~6 seconds in laboratory
```

does not prove:

```text
platform P95 ≤ 15 minutes
```

The latter requires end-to-end measurement.

### 13.30 Security Beyond Source Access Is Outside This Strategy

Capture implementation will require appropriate access to AtlasCommerce.

However, broader security concerns such as:

```text
Kafka ACLs

MinIO permissions

Airflow secrets

service identities

certificate management

Power BI access

data masking

row-level security
```

belong to their respective architectural layers.

### 13.31 Data Quality Is Broader Than Capture Correctness

Capture correctness asks:

```text
Did we acquire what the source exposed?
```

Data quality asks broader questions:

```text
Is the source value valid?

Is the business rule satisfied?

Is the relationship plausible?

Is the amount correct?

Is the analytical meaning consistent?
```

Capture Strategy does not attempt to solve all data-quality concerns.

It ensures that downstream layers receive trustworthy source evidence with known semantics.

### 13.32 Source Defects Are Not Automatically Capture Defects

If AtlasCommerce contains:

```text
incorrect business value
```

and the platform captures that value exactly, the capture mechanism may be functioning correctly.

Conceptually:

```text
bad source data
        ↓
correct capture
        ↓
bad value arrives downstream
```

This is different from:

```text
correct source data
        ↓
capture loses or corrupts it
```

The first is a source/data-quality issue.

The second is a capture correctness issue.

The distinction must remain explicit during troubleshooting.

### 13.33 Capture Strategy Ends Before Business Transformation

The formal boundary can therefore be represented as:

```text
┌──────────────────────────────────────────────┐
│              CAPTURE STRATEGY                │
│                                              │
│ AtlasCommerce                               │
│      ↓                                       │
│ classify source behavior                     │
│      ↓                                       │
│ select mechanism                             │
│      ↓                                       │
│ establish acquisition boundary               │
│      ↓                                       │
│ identify / acquire source data or changes    │
└──────────────────────┬───────────────────────┘
                       │
                       │ boundary
                       ▼
┌──────────────────────────────────────────────┐
│          DOWNSTREAM ARCHITECTURE             │
│                                              │
│ consume                                      │
│ deliver                                      │
│ persist                                      │
│ checkpoint                                   │
│ retry                                        │
│ deduplicate                                  │
│ reconcile                                    │
│ transform                                    │
│ model                                        │
│ serve                                        │
└──────────────────────────────────────────────┘
```

### 13.34 Boundary by Mechanism

The end of Capture Strategy can also be viewed separately for each mechanism.

```text
CDC

Source DML
   ↓
Transaction Log
   ↓
SQL Server Native CDC
   ↓
CDC change available
   │
   └── CAPTURE STRATEGY ENDS
```

```text
TIMESTAMP INCREMENTAL

Source current rows
   ↓
validated watermark predicate
   ↓
required changed rows identified
   │
   └── CAPTURE STRATEGY ENDS
```

```text
SNAPSHOT + DIFF

Previous accepted state
        +
Current source state
        ↓
state difference identified
        │
        └── CAPTURE STRATEGY ENDS
```

```text
CONTROLLED FULL REFRESH

Current source state
        ↓
validated authoritative state identified
        │
        └── CAPTURE STRATEGY ENDS
```

The exact downstream handoff representation may differ by implementation.

That representation is not defined by this strategy.

### 13.35 What This Document May Reference

The Capture Strategy may reference future components to explain architectural context.

For example:

```text
Bronze will become durable history.
```

or:

```text
Kafka will later provide downstream messaging.
```

Such references explain why a capture decision makes sense.

They do not transfer implementation ownership of those components into this document.

This distinction allows the strategy to remain architecturally connected without becoming an implementation specification for the entire platform.

### 13.36 What This Document Must Not Claim

The Capture Strategy must not claim implementation evidence for components that have not yet been tested.

At the current project stage, it must not claim:

```text
Debezium validated

Kafka validated

Bronze validated

Silver validated

Gold validated

checkpoint/restart validated

end-to-end idempotency validated

end-to-end recovery validated

production-scale performance validated
```

Likewise, it must not transform:

```text
planned architecture
```

into:

```text
observed behavior
```

### 13.37 Responsibility Handoff

The architectural responsibility handoff is:

```text
Capture Strategy
        ↓
defines source acquisition mechanism
        ↓
Capture Implementation
        ↓
proves source behavior
        ↓
Consumption
        ↓
reads acquired changes/state
        ↓
Messaging / Persistence
        ↓
delivers and stores
        ↓
Transformation
        ↓
creates analytical semantics
        ↓
Serving
        ↓
provides certified analytical data
```

Each layer should have its own:

```text
decisions
implementation
evidence
limitations
```

This separation prevents one successful test from being incorrectly generalized across the entire architecture.

### 13.38 Current Atlas Engineering Boundary

At the current project stage:

```text
Capture Strategy
→ V1 Approved

SQL Server CDC source implementation
→ validated through M01.19

CDC consumption
→ next implementation stage

Timestamp Incremental implementation
→ pending

Snapshot + Diff implementation
→ pending

Controlled Full Refresh implementation
→ pending

Debezium
→ pending

Kafka
→ pending

Bronze
→ pending

Silver
→ pending

Gold
→ pending

Power BI integration
→ pending
```

This is the correct current maturity boundary.

### 13.39 Strategy Boundary Summary

The V1 Capture Strategy owns:

```text
SOURCE UNDERSTANDING
        +
CHANGE CLASSIFICATION
        +
MECHANISM SELECTION
        +
SOURCE-SIDE CAPTURE REQUIREMENTS
        +
INITIAL-STATE STRATEGY
        +
CUTOVER PRINCIPLES
        +
SOURCE-SIDE RECOVERY CONSIDERATIONS
        +
KNOWN TRADE-OFFS
```

It does not own:

```text
Debezium connector implementation

Kafka topology

Kafka delivery guarantees

consumer implementation

checkpoint persistence

Bronze file design

Silver transformations

Gold modeling

Power BI semantics

Airflow DAGs

Prometheus metrics

Grafana dashboards

OpenTelemetry implementation

OpenMetadata implementation

end-to-end idempotency

end-to-end recovery
```

The governing boundary is:

> **Capture Strategy ends when the required source changes or authoritative source state have been reliably identified and acquired.**

The architectural discipline is:

> **A downstream capability may depend on capture, but that does not make it a capture responsibility.**

And the evidence principle is:

> **Source-side validation proves source-side behavior only; every downstream guarantee requires its own implementation evidence.**

---

## 14. Decision Summary

The Atlas Engineering V1 Capture Strategy defines how source changes and source state are identified and acquired from AtlasCommerce for the initial Sales Analytics domain.

The strategy does not use a universal capture mechanism.

Instead, each source is evaluated according to:

```text
change frequency
latency requirement
data volume
tolerance to missing changes
watermark reliability
DELETE visibility requirement
operational overhead
```

This results in four capture patterns:

```text
SQL Server Native CDC

Timestamp Incremental

Snapshot + Diff

Controlled Full Refresh
```

The strategy is considered:

```text
V1 — Approved
```

This approval means that the capture architecture and mechanism-selection rationale are accepted for the current V1 scope.

It does not mean that every mechanism has already been implemented or proven operationally.

The governing distinction remains:

```text
ARCHITECTURAL DECISION
        ≠
IMPLEMENTATION
        ≠
TEST EVIDENCE
        ≠
END-TO-END PROOF
```

### 14.1 Approved V1 Source Classification

The current V1 classification is:

```text
A — HIGH CHANGE
────────────────────────────────────
sales.Transaction
sales.TransactionItem


B — OCCASIONAL CHANGE
────────────────────────────────────
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category


C — REFERENCE
────────────────────────────────────
sales.TransactionStatus
sales.TransactionChannel


D — LOW CHANGE / NO WATERMARK
────────────────────────────────────
catalog.ProductCategory
```

This classification drives mechanism selection.

It is not merely descriptive metadata.

A change in source behavior may require a change in capture mechanism.

### 14.2 Approved V1 Mechanism Selection

The approved V1 source-to-mechanism mapping is:

```text
sales.Transaction
        ↓
SQL Server Native CDC


sales.TransactionItem
        ↓
SQL Server Native CDC
```

```text
catalog.Product
        ↓
Timestamp Incremental


catalog.ProductVariant
        ↓
Timestamp Incremental


catalog.Brand
        ↓
Timestamp Incremental


catalog.Category
        ↓
Timestamp Incremental
```

```text
catalog.ProductCategory
        ↓
Snapshot + Diff
```

```text
sales.TransactionStatus
        ↓
Controlled Full Refresh


sales.TransactionChannel
        ↓
Controlled Full Refresh
```

The architecture therefore intentionally uses:

```text
different mechanisms
for different source behaviors
```

rather than forcing every source through the same capture path.

### 14.3 CDC Decision

SQL Server Native CDC is the approved mechanism for:

```text
sales.Transaction
sales.TransactionItem
```

The decision is based on the transactional nature of these sources and the need for reliable visibility of:

```text
INSERT
UPDATE
DELETE
```

including hard DELETE behavior.

The V1 source-side CDC model is:

```text
Application DML
        ↓
SQL Server Transaction Log
        ↓
SQL Server Native CDC
        ↓
CDC Change Tables
```

Debezium belongs to the downstream delivery path.

It is not treated as a direct SQL Server transaction-log reader in this architecture.

### 14.4 CDC Evidence Currently Available

The SQL Server CDC implementation has already produced controlled source-side evidence through:

```text
M01.19
```

The validated behaviors include:

```text
database-level CDC enablement

table-level CDC enablement

capture-instance creation

Change Table creation

CDC metadata structure

no retroactive CDC backfill

asynchronous capture

INSERT capture

UPDATE BEFORE / AFTER capture

update-mask behavior

multiple SQL commands
within one transaction

cross-table source transaction context

hard DELETE capture

ON DELETE CASCADE capture behavior

CDC job inspection

retention configuration

partition SWITCH restriction awareness
```

Therefore:

```text
SQL Server Native CDC
```

is no longer only an architectural hypothesis for the two transactional tables.

Its source-side behavior has been materially validated.

However:

```text
CDC SOURCE-SIDE VALIDATED
```

does not mean:

```text
CDC PIPELINE END-TO-END VALIDATED
```

### 14.5 CDC Recovery Window Decision

The V1 CDC retention decision is:

```text
15 days
```

or:

```text
21600 minutes
```

The purpose is to provide operational recovery time for situations such as:

```text
weekends
holidays
incidents
consumer outages
investigation
repair
reprocessing
```

This retention is explicitly interpreted as:

```text
CDC RECOVERY BUFFER
```

not:

```text
PERMANENT HISTORICAL STORAGE
```

Long-term durable ingestion history belongs downstream.

### 14.6 CDC Partition SWITCH Decision

The transactional tables are partitioned.

CDC is configured with partition switching permitted.

The strategy therefore accepts:

```text
allow_partition_switch = 1
```

with explicit governance.

The key semantic rule is:

```text
partition movement
≠
ordinary row-level DML
```

Future:

```text
SWITCH IN
```

must not become the normal transactional ingestion path without architectural review.

Likewise:

```text
SWITCH OUT
```

must not automatically be interpreted as a business DELETE.

Partition maintenance must be coordinated with Data Engineering.

### 14.7 Timestamp Incremental Decision

Timestamp Incremental is the approved V1 hypothesis for:

```text
catalog.Product
catalog.ProductVariant
catalog.Brand
catalog.Category
```

The mechanism is selected because these sources are classified as occasional-change descriptive data.

The intended model is:

```text
reliable watermark
        ↓
incremental source query
        ↓
changed current rows
```

However, the critical word remains:

```text
reliable
```

The presence of a timestamp column alone is insufficient.

### 14.8 Timestamp Incremental Validation Requirement

Before Timestamp Incremental is considered proven for any Category B source, the implementation must validate:

```text
watermark ownership

watermark update behavior

INSERT behavior

UPDATE behavior

timestamp precision

same-timestamp rows

boundary equality

transaction visibility

possible backward movement

NULL behavior if applicable

hard DELETE requirements

source query performance

restart behavior

checkpoint behavior

controlled overlap
```

Therefore, the current status is:

```text
MECHANISM SELECTED
        ↓
IMPLEMENTATION VALIDATION PENDING
```

If the source watermark fails these requirements, the capture mechanism must be reconsidered.

### 14.9 Timestamp Incremental Fidelity Decision

Timestamp Incremental is accepted as:

```text
changed-current-state capture
```

rather than:

```text
complete source event history
```

Multiple source updates between extraction cycles may collapse into the latest visible row state.

Hard DELETE is not inherently discoverable.

These limitations are accepted only while they remain compatible with the analytical requirement.

### 14.10 Snapshot and Diff Decision

Snapshot + Diff is the approved V1 mechanism for:

```text
catalog.ProductCategory
```

The current source structure does not expose a reliable watermark suitable for Timestamp Incremental.

The mechanism therefore uses:

```text
previous accepted state
        +
current source state
        ↓
comparison
```

to derive:

```text
ADDED
REMOVED
UNCHANGED
```

The relationship identity is currently represented by:

```text
PRDCT_PRD_id
+
PRDCT_CTG_id
```

### 14.11 Snapshot and Diff Evidence Semantics

The mechanism produces:

```text
state-difference evidence
```

not necessarily:

```text
source-event evidence
```

For example:

```text
relationship existed before
+
relationship absent now
```

supports:

```text
REMOVED
```

It does not automatically prove:

```text
exact DELETE timestamp
```

or:

```text
specific application DELETE statement
```

The strategy explicitly preserves this distinction.

### 14.12 Snapshot Safety Decision

Snapshot completeness is a prerequisite for trustworthy comparison.

Therefore:

```text
extract
        ↓
validate snapshot
        ↓
compute diff
```

is the required conceptual order.

Not:

```text
extract
        ↓
immediately derive removals
```

An incomplete snapshot could otherwise manufacture false deletions.

The implementation must preserve the previous accepted snapshot until the candidate state has been safely validated and promoted.

### 14.13 Controlled Full Refresh Decision

Controlled Full Refresh is the approved V1 mechanism for:

```text
sales.TransactionStatus
sales.TransactionChannel
```

The current requirement is:

```text
authoritative current state
```

rather than:

```text
complete source event history
```

The mechanism therefore favors simplicity for these small reference datasets.

The current observed source baseline is:

```text
TransactionStatus
5 rows

TransactionChannel
2 rows
```

These are observations.

They are not permanent row-count contracts.

### 14.14 Controlled Refresh Safety Decision

A full refresh must not mean uncontrolled destructive replacement.

The required conceptual model is:

```text
extract complete required state
        ↓
create candidate state
        ↓
validate
        ↓
promote
        ↓
new accepted state
```

The previous accepted state must remain available if the candidate refresh fails.

This prevents partial or invalid refreshes from replacing trustworthy reference data.

### 14.15 Initial Backfill Decision

The V1 strategy distinguishes:

```text
existing source state
```

from:

```text
future captured change
```

Existing rows must be loaded through:

```text
Initial Backfill
```

while ongoing source changes are protected through the selected capture mechanism.

For the initial transactional baseline, source-side evidence identified:

```text
sales.Transaction
6306 existing rows

sales.TransactionItem
13769 existing rows
```

CDC did not retroactively populate those rows into its Change Tables.

This behavior has been proven.

### 14.16 Cutover Decision

The approved cutover principle is:

> **Protect the future first, then load the past.**

Conceptually:

```text
establish ongoing capture
        ↓
establish boundary
        ↓
verify future protection
        ↓
start Initial Backfill
        ↓
process accumulated changes
        ↓
reconcile overlap
        ↓
enter steady state
```

The strategy intentionally prefers:

```text
controlled overlap
```

to:

```text
silent gap
```

because overlap can potentially be reconciled, while an uncaptured gap may be unrecoverable.

### 14.17 Historical Evidence Decision

The platform must not manufacture pre-capture event history.

For existing data:

```text
known row state
```

may be loaded.

But an unobserved sequence such as:

```text
PENDING
→ CONFIRMED
→ COMPLETED
```

must not be reconstructed unless an authoritative source proves it.

The governing rule is:

> **Unknown historical events remain unknown.**

### 14.18 Delivery Guarantee Decision

The broader V1 architecture selects:

```text
At-Least-Once
+
Idempotency
```

rather than claiming:

```text
end-to-end Exactly-Once
```

The Capture Strategy supports this philosophy by accepting controlled overlap where necessary.

However, end-to-end idempotency remains a downstream implementation responsibility and has not yet been proven.

### 14.19 Source Protection Decision

AtlasCommerce remains the operational OLTP source.

Therefore:

> **OLTP health takes priority over analytical convenience.**

Capture and backfill mechanisms must be designed to avoid unnecessary source pressure.

This includes future validation of:

```text
incremental query plans

snapshot extraction cost

full-refresh cost

historical backfill workload

CDC operational overhead
```

No Data Engineering requirement justifies destabilizing the transactional system.

### 14.20 Capture Evidence Model

The four mechanisms provide different kinds of evidence.

```text
SQL Server Native CDC
→ captured source changes
```

```text
Timestamp Incremental
→ current rows indicating change
```

```text
Snapshot + Diff
→ differences between accepted states
```

```text
Controlled Full Refresh
→ authoritative current state
```

These evidence types must not be treated as interchangeable.

The capture mechanism determines what can later be claimed about history.

### 14.21 Approved V1 Matrix

The final V1 decision matrix is:

| Source | Classification | V1 Capture Mechanism | Current Status |
|---|---|---|---|
| `sales.Transaction` | A — High Change | SQL Server Native CDC | Selected, implemented source-side, tested through M01.19 |
| `sales.TransactionItem` | A — High Change | SQL Server Native CDC | Selected, implemented source-side, tested through M01.19 |
| `catalog.Product` | B — Occasional Change | Timestamp Incremental | Selected hypothesis; implementation validation pending |
| `catalog.ProductVariant` | B — Occasional Change | Timestamp Incremental | Selected hypothesis; implementation validation pending |
| `catalog.Brand` | B — Occasional Change | Timestamp Incremental | Selected hypothesis; implementation validation pending |
| `catalog.Category` | B — Occasional Change | Timestamp Incremental | Selected hypothesis; implementation validation pending |
| `catalog.ProductCategory` | D — Low Change / No Watermark | Snapshot + Diff | Selected; implementation validation pending |
| `sales.TransactionStatus` | C — Reference | Controlled Full Refresh | Selected; implementation validation pending |
| `sales.TransactionChannel` | C — Reference | Controlled Full Refresh | Selected; implementation validation pending |

This matrix represents the approved V1 strategy.

It does not imply equal implementation maturity across all rows.

### 14.22 Current Maturity State

The current Capture Strategy maturity can be summarized as:

```text
CAPTURE STRATEGY
→ V1 Approved


SQL SERVER CDC
Transaction
TransactionItem
→ source-side implementation validated
through M01.19


TIMESTAMP INCREMENTAL
Product
ProductVariant
Brand
Category
→ implementation pending


SNAPSHOT + DIFF
ProductCategory
→ implementation pending


CONTROLLED FULL REFRESH
TransactionStatus
TransactionChannel
→ implementation pending


INITIAL BACKFILL
→ strategy defined
implementation pending


CONTROLLED CUTOVER
→ strategy defined
end-to-end implementation pending
```

This is the correct current project state.

### 14.23 Strategy Review Triggers

The V1 Capture Strategy must be reviewed if evidence or requirements change materially.

Review triggers include:

```text
source change frequency increases

source volume changes materially

freshness requirement changes

hard DELETE becomes mandatory
for a source that cannot detect it

Timestamp Incremental watermark
proves unreliable

snapshot extraction becomes too expensive

reference sources require
historical event tracking

partition operations change

CDC retention proves insufficient

CDC storage impact becomes excessive

source schema changes affect
keys or watermark semantics

new analytical products require
different capture fidelity

source availability model changes

new recovery requirements appear
```

A review trigger does not automatically mean the current design is wrong.

It means the assumptions supporting the decision must be reevaluated.

### 14.24 Decision Change Procedure

When a capture decision is challenged by new evidence, the strategy should follow:

```text
NEW EVIDENCE / REQUIREMENT
        ↓
identify affected assumption
        ↓
re-evaluate source classification
        ↓
re-evaluate capture criteria
        ↓
compare candidate mechanisms
        ↓
record new decision
        ↓
implement
        ↓
test
        ↓
update evidence
        ↓
version strategy
```

This keeps architecture evidence-driven rather than static.

### 14.25 Strategy Is Versioned, Not Permanent

The status:

```text
V1 — Approved
```

means:

```text
approved for the current V1 scope
and current evidence
```

It does not mean:

```text
permanent architecture
```

Future versions may legitimately change:

```text
source classification

capture mechanisms

recovery windows

cutover procedures

operational constraints
```

Architecture evolves when evidence or requirements justify evolution.

### 14.26 Decision Versus Implementation Documentation

This document records:

```text
WHY
```

the capture strategy was selected.

The separate SQL Server CDC implementation documentation records:

```text
HOW
```

the current CDC decisions were materialized and:

```text
WHAT WAS OBSERVED
```

during controlled testing.

Therefore:

```text
Capture Strategy
→ architectural reasoning and decisions
```

while:

```text
SQL Server CDC Implementation
→ commands, configuration, tests,
observations, corrections, evidence
```

The distinction must remain preserved as the project grows.

### 14.27 Next Implementation Boundary

With Capture Strategy V1 documented, the next CDC implementation stage is:

```text
M01.20 — CDC Consumption
```

beginning with:

```text
M01.20A — LSN Window Inspection
```

This stage moves beyond:

```text
Can SQL Server capture the changes?
```

into:

```text
How should a consumer identify
and process a reliable CDC window?
```

The next questions include:

```text
minimum available LSN

maximum available LSN

from_lsn

to_lsn

window boundaries

all changes functions

UPDATE representation

checkpoint progression

restart

replay

controlled overlap

consumer semantics
```

These questions belong to CDC Consumption and must be answered experimentally.

### 14.28 Final V1 Decision

The final Atlas Engineering V1 Capture Strategy is:

```text
HIGH-CHANGE TRANSACTIONAL SOURCES
        ↓
SQL Server Native CDC


OCCASIONAL-CHANGE DESCRIPTIVE SOURCES
        ↓
Timestamp Incremental
        ↓
only when watermark reliability
is proven


LOW-CHANGE RELATIONSHIP
WITHOUT RELIABLE WATERMARK
        ↓
Snapshot + Diff


SMALL REFERENCE SOURCES
WHERE CURRENT STATE IS SUFFICIENT
        ↓
Controlled Full Refresh
```

Initial data is handled through:

```text
Initial Backfill
```

with the cutover principle:

```text
protect future first
then load past
```

and the failure preference:

```text
controlled overlap
over
silent gap
```

Source capture is treated as:

```text
an acquisition responsibility
```

not:

```text
permanent historical storage
```

and every mechanism remains subject to evidence-based review.

### 14.29 Final Principles

The Capture Strategy V1 is governed by the following consolidated principles:

```text
Use the mechanism that matches
the source behavior.

Do not force one capture mechanism
onto every source.

Protect the OLTP system.

Prefer controlled overlap
to silent loss.

Do not invent history
that was never observed.

Treat a watermark as a contract,
not merely as a timestamp column.

Treat snapshots as evidence
only after validating completeness.

Treat full refresh as controlled
state promotion, not destructive replacement.

Treat CDC retention as recovery time,
not permanent history.

Preserve the difference between
source physical changes
and business meaning.

Advance progress only after
safe durable processing.

Distinguish architectural decision,
implementation, evidence,
and end-to-end proof.

Revise the strategy when
new evidence invalidates an assumption.
```

The final architectural principle is:

> **Capture must provide the minimum required source fidelity without accepting silent data loss or unnecessary operational complexity.**

The final evidence principle is:

> **Atlas Engineering claims only what its current evidence can support.**

And the final governance principle is:

> **A capture decision remains valid only while the assumptions that justified it remain valid.**