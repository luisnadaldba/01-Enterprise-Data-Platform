# Atlas Engineering — Reliability and Recovery

## Table of Contents

[1. Purpose](#1-purpose)

[2. Reliability and Recovery Context](#2-reliability-and-recovery-context)
   - [2.1 Failure as an Expected Condition](#21-failure-as-an-expected-condition)
   - [2.2 Reliability](#22-reliability)
   - [2.3 Recovery](#23-recovery)
   - [2.4 Recovery Is State-Aware](#24-recovery-is-state-aware)
   - [2.5 Failure Propagation](#25-failure-propagation)
   - [2.6 Partial Failure](#26-partial-failure)
   - [2.7 Durable State](#27-durable-state)
   - [2.8 Derived State](#28-derived-state)
   - [2.9 Recovery and Data Correctness](#29-recovery-and-data-correctness)
   - [2.10 Recovery and Governed Publication](#210-recovery-and-governed-publication)
   - [2.11 Recovery and Historical Interpretation](#211-recovery-and-historical-interpretation)
   - [2.12 Recovery and Observability](#212-recovery-and-observability)
   - [2.13 Recovery and Security](#213-recovery-and-security)
   - [2.14 Recovery and Evidence](#214-recovery-and-evidence)
   - [2.15 Reliability Context Principle](#215-reliability-context-principle)

[3. Reliability Principles](#3-reliability-principles)
   - [3.1 Failure Is Expected](#31-failure-is-expected)
   - [3.2 Preserve Before Advancing](#32-preserve-before-advancing)
   - [3.3 Restartability](#33-restartability)
   - [3.4 Idempotency](#34-idempotency)
   - [3.5 At-Least-Once Delivery Is Not a Defect](#35-at-least-once-delivery-is-not-a-defect)
   - [3.6 No Silent Data Loss](#36-no-silent-data-loss)
   - [3.7 No Silent Corruption](#37-no-silent-corruption)
   - [3.8 Durable State Before Ephemeral State](#38-durable-state-before-ephemeral-state)
   - [3.9 Recovery Uses Explicit Progress](#39-recovery-uses-explicit-progress)
   - [3.10 Recovery Source Must Be Trustworthy](#310-recovery-source-must-be-trustworthy)
   - [3.11 Recovery Should Use the Appropriate Boundary](#311-recovery-should-use-the-appropriate-boundary)
   - [3.12 Derived State Should Be Reconstructible](#312-derived-state-should-be-reconstructible)
   - [3.13 Failure Isolation](#313-failure-isolation)
   - [3.14 Backpressure Is Preferable to Uncontrolled Loss](#314-backpressure-is-preferable-to-uncontrolled-loss)
   - [3.15 Retry Must Be Bounded and Observable](#315-retry-must-be-bounded-and-observable)
   - [3.16 Recovery Must Not Bypass Governance](#316-recovery-must-not-bypass-governance)
   - [3.17 Publication Must Fail Safe](#317-publication-must-fail-safe)
   - [3.18 Recovery Must Be Observable](#318-recovery-must-be-observable)
   - [3.19 Recovery Must Be Validated](#319-recovery-must-be-validated)
   - [3.20 Recovery Must Be Evidence-Based](#320-recovery-must-be-evidence-based)
   - [3.21 Reliability Does Not Equal High Availability](#321-reliability-does-not-equal-high-availability)
   - [3.22 Recovery Objectives Must Be Measured](#322-recovery-objectives-must-be-measured)
   - [3.23 Reliability Evolves With Evidence](#323-reliability-evolves-with-evidence)
   - [3.24 Reliability Principle](#324-reliability-principle)

[4. Failure Domains and Failure Classification](#4-failure-domains-and-failure-classification)
   - [4.1 Failure Domain](#41-failure-domain)
   - [4.2 Failure Scope](#42-failure-scope)
   - [4.3 Transient Failure](#43-transient-failure)
   - [4.4 Persistent Failure](#44-persistent-failure)
   - [4.5 Data-Specific Failure](#45-data-specific-failure)
   - [4.6 Processing Failure](#46-processing-failure)
   - [4.7 Dependency Failure](#47-dependency-failure)
   - [4.8 Source Failure](#48-source-failure)
   - [4.9 CDC Failure](#49-cdc-failure)
   - [4.10 Debezium Failure](#410-debezium-failure)
   - [4.11 Kafka Failure](#411-kafka-failure)
   - [4.12 Bronze Failure](#412-bronze-failure)
   - [4.13 Silver Failure](#413-silver-failure)
   - [4.14 Gold Failure](#414-gold-failure)
   - [4.15 Certification Failure](#415-certification-failure)
   - [4.16 Publication Failure](#416-publication-failure)
   - [4.17 Orchestration Failure](#417-orchestration-failure)
   - [4.18 Storage Failure](#418-storage-failure)
   - [4.19 Network Failure](#419-network-failure)
   - [4.20 Credential and Authentication Failure](#420-credential-and-authentication-failure)
   - [4.21 Resource Exhaustion](#421-resource-exhaustion)
   - [4.22 Configuration Failure](#422-configuration-failure)
   - [4.23 Deployment Failure](#423-deployment-failure)
   - [4.24 Data Quality Failure](#424-data-quality-failure)
   - [4.25 Reconciliation Failure](#425-reconciliation-failure)
   - [4.26 Observability Failure](#426-observability-failure)
   - [4.27 Compound Failure](#427-compound-failure)
   - [4.28 Cascading Failure](#428-cascading-failure)
   - [4.29 Data Loss Risk](#429-data-loss-risk)
   - [4.30 Freshness Failure](#430-freshness-failure)
   - [4.31 Correctness Failure](#431-correctness-failure)
   - [4.32 Availability Failure](#432-availability-failure)
   - [4.33 Recoverability Failure](#433-recoverability-failure)
   - [4.34 Failure Severity](#434-failure-severity)
   - [4.35 Failure Classification Record](#435-failure-classification-record)
   - [4.36 Failure Classification Principle](#436-failure-classification-principle)

[5. Durable State and Recovery Boundaries](#5-durable-state-and-recovery-boundaries)
   - [5.1 Durable State](#51-durable-state)
   - [5.2 Ephemeral State](#52-ephemeral-state)
   - [5.3 Authoritative and Derived State](#53-authoritative-and-derived-state)
   - [5.4 Persistence Does Not Prove Completeness](#54-persistence-does-not-prove-completeness)
   - [5.5 Persistence Does Not Prove Trust](#55-persistence-does-not-prove-trust)
   - [5.6 Recovery Boundary](#56-recovery-boundary)
   - [5.7 Source Database Boundary](#57-source-database-boundary)
   - [5.8 CDC Boundary](#58-cdc-boundary)
   - [5.9 Kafka Boundary](#59-kafka-boundary)
   - [5.10 Bronze Boundary](#510-bronze-boundary)
   - [5.11 Silver Boundary](#511-silver-boundary)
   - [5.12 Gold Boundary](#512-gold-boundary)
   - [5.13 Certified Gold Boundary](#513-certified-gold-boundary)
   - [5.14 Checkpoint State](#514-checkpoint-state)
   - [5.15 Processing Metadata](#515-processing-metadata)
   - [5.16 Version Metadata](#516-version-metadata)
   - [5.17 Lineage as Recovery Context](#517-lineage-as-recovery-context)
   - [5.18 Backup Boundary](#518-backup-boundary)
   - [5.19 Archive Boundary](#519-archive-boundary)
   - [5.20 Recovery Source Hierarchy](#520-recovery-source-hierarchy)
   - [5.21 Recovery Source Selection](#521-recovery-source-selection)
   - [5.22 Recovery Window](#522-recovery-window)
   - [5.23 Recovery Window Exhaustion](#523-recovery-window-exhaustion)
   - [5.24 Recovery Boundary Escalation](#524-recovery-boundary-escalation)
   - [5.25 Boundary Independence](#525-boundary-independence)
   - [5.26 Recovery and Shared Failure Domains](#526-recovery-and-shared-failure-domains)
   - [5.27 Recovery and Historical Definitions](#527-recovery-and-historical-definitions)
   - [5.28 Recovery and Current Governance](#528-recovery-and-current-governance)
   - [5.29 Recovery Boundary Validation](#529-recovery-boundary-validation)
   - [5.30 Durable State and Recovery Evidence](#530-durable-state-and-recovery-evidence)
   - [5.31 Durable State and Recovery Boundary Guarantees](#531-durable-state-and-recovery-boundary-guarantees)

[6. Checkpoints, Progress, and Restartability](#6-checkpoints-progress-and-restartability)
   - [6.1 Processing Progress](#61-processing-progress)
   - [6.2 Checkpoint](#62-checkpoint)
   - [6.3 Checkpoint and Output Consistency](#63-checkpoint-and-output-consistency)
   - [6.4 Commit Boundary](#64-commit-boundary)
   - [6.5 Atomicity Between Output and Progress](#65-atomicity-between-output-and-progress)
   - [6.6 Restartability](#66-restartability)
   - [6.7 Clean Restart](#67-clean-restart)
   - [6.8 Unclean Restart](#68-unclean-restart)
   - [6.9 Restart Is Not Replay](#69-restart-is-not-replay)
   - [6.10 Restart Is Not Reprocessing](#610-restart-is-not-reprocessing)
   - [6.11 Restart Is Not Rebuild](#611-restart-is-not-rebuild)
   - [6.12 Kafka Consumer Progress](#612-kafka-consumer-progress)
   - [6.13 Partition-Specific Progress](#613-partition-specific-progress)
   - [6.14 CDC and Debezium Progress](#614-cdc-and-debezium-progress)
   - [6.15 Bronze Progress](#615-bronze-progress)
   - [6.16 Silver Progress](#616-silver-progress)
   - [6.17 Gold Progress](#617-gold-progress)
   - [6.18 Certification Progress](#618-certification-progress)
   - [6.19 Orchestration Progress](#619-orchestration-progress)
   - [6.20 Retry and Checkpoint Interaction](#620-retry-and-checkpoint-interaction)
   - [6.21 Backlog and Checkpoint Interaction](#621-backlog-and-checkpoint-interaction)
   - [6.22 Checkpoint Corruption or Loss](#622-checkpoint-corruption-or-loss)
   - [6.23 Checkpoint Reset](#623-checkpoint-reset)
   - [6.24 Processing Gaps](#624-processing-gaps)
   - [6.25 Duplicate Processing](#625-duplicate-processing)
   - [6.26 Progress Monotonicity](#626-progress-monotonicity)
   - [6.27 Independent Progress](#627-independent-progress)
   - [6.28 Progress and Freshness](#628-progress-and-freshness)
   - [6.29 Restart Validation](#629-restart-validation)
   - [6.30 Restart Evidence](#630-restart-evidence)
   - [6.31 Checkpoint and Restartability Guarantees](#631-checkpoint-and-restartability-guarantees)

[7. Retry and Redelivery](#7-retry-and-redelivery)
   - [7.1 Retry Purpose](#71-retry-purpose)
   - [7.2 Retryable and Non-Retryable Failures](#72-retryable-and-non-retryable-failures)
   - [7.3 Bounded Retry](#73-bounded-retry)
   - [7.4 Retry Delay](#74-retry-delay)
   - [7.5 Backoff](#75-backoff)
   - [7.6 Jitter](#76-jitter)
   - [7.7 Retry Storm](#77-retry-storm)
   - [7.8 Retry and Idempotency](#78-retry-and-idempotency)
   - [7.9 Retry and Checkpoint](#79-retry-and-checkpoint)
   - [7.10 Redelivery](#710-redelivery)
   - [7.11 Redelivery Identification](#711-redelivery-identification)
   - [7.12 Duplicate Delivery and Duplicate Business Effect](#712-duplicate-delivery-and-duplicate-business-effect)
   - [7.13 Retry Exhaustion](#713-retry-exhaustion)
   - [7.14 Persistent Failure Transition](#714-persistent-failure-transition)
   - [7.15 Poison Record Interaction](#715-poison-record-interaction)
   - [7.16 Retry and Partition Progress](#716-retry-and-partition-progress)
   - [7.17 Retry and Failure Isolation](#717-retry-and-failure-isolation)
   - [7.18 Dependency Recovery](#718-dependency-recovery)
   - [7.19 Circuit-Breaking Behavior](#719-circuit-breaking-behavior)
   - [7.20 Retry and Backpressure](#720-retry-and-backpressure)
   - [7.21 Retry and Retention Windows](#721-retry-and-retention-windows)
   - [7.22 Retry and Credentials](#722-retry-and-credentials)
   - [7.23 Retry and Rate Limits](#723-retry-and-rate-limits)
   - [7.24 Retry and Orchestration](#724-retry-and-orchestration)
   - [7.25 Retry and Batch Processing](#725-retry-and-batch-processing)
   - [7.26 Retry and Candidate Generation](#726-retry-and-candidate-generation)
   - [7.27 Manual Retry](#727-manual-retry)
   - [7.28 Retry After Remediation](#728-retry-after-remediation)
   - [7.29 Redelivery After Recovery](#729-redelivery-after-recovery)
   - [7.30 Retry Observability](#730-retry-observability)
   - [7.31 Redelivery Observability](#731-redelivery-observability)
   - [7.32 Retry Alerts](#732-retry-alerts)
   - [7.33 Retry Recovery Validation](#733-retry-recovery-validation)
   - [7.34 Retry Evidence](#734-retry-evidence)
   - [7.35 Retry and Redelivery Guarantees](#735-retry-and-redelivery-guarantees)

[8. Recovery Source Strategy](#8-recovery-source-strategy)
   - [8.1 Recovery Source Objectives](#81-recovery-source-objectives)
   - [8.2 Recovery Source Eligibility](#82-recovery-source-eligibility)
   - [8.3 Preferred Recovery Principle](#83-preferred-recovery-principle)
   - [8.4 Recovery Source Hierarchy](#84-recovery-source-hierarchy)
   - [8.5 Kafka as Recovery Source](#85-kafka-as-recovery-source)
   - [8.6 Kafka Recovery Limitations](#86-kafka-recovery-limitations)
   - [8.7 Bronze as Recovery Source](#87-bronze-as-recovery-source)
   - [8.8 Bronze Recovery Limitations](#88-bronze-recovery-limitations)
   - [8.9 Silver as Recovery Source](#89-silver-as-recovery-source)
   - [8.10 Silver Recovery Limitations](#810-silver-recovery-limitations)
   - [8.11 Gold as Recovery Source](#811-gold-as-recovery-source)
   - [8.12 Certified Gold as Recovery Source](#812-certified-gold-as-recovery-source)
   - [8.13 AtlasCommerce as Recovery Source](#813-atlascommerce-as-recovery-source)
   - [8.14 Current Source State Versus Historical Events](#814-current-source-state-versus-historical-events)
   - [8.15 Controlled Backfill](#815-controlled-backfill)
   - [8.16 Backup as Recovery Source](#816-backup-as-recovery-source)
   - [8.17 Backup Is Not Replay](#817-backup-is-not-replay)
   - [8.18 Archive as Recovery Source](#818-archive-as-recovery-source)
   - [8.19 Recovery Source Independence](#819-recovery-source-independence)
   - [8.20 Recovery Source Trust](#820-recovery-source-trust)
   - [8.21 Last Successful Versus Last Trustworthy State](#821-last-successful-versus-last-trustworthy-state)
   - [8.22 Recovery Source and Defect Location](#822-recovery-source-and-defect-location)
   - [8.23 Recovery Source and Version Compatibility](#823-recovery-source-and-version-compatibility)
   - [8.24 Recovery With Current Logic](#824-recovery-with-current-logic)
   - [8.25 Recovery With Historical Logic](#825-recovery-with-historical-logic)
   - [8.26 Recovery Source and Data Classification](#826-recovery-source-and-data-classification)
   - [8.27 Recovery Source and Retention](#827-recovery-source-and-retention)
   - [8.28 Recovery Source and RPO](#828-recovery-source-and-rpo)
   - [8.29 Recovery Source and RTO](#829-recovery-source-and-rto)
   - [8.30 Recovery Source Escalation](#830-recovery-source-escalation)
   - [8.31 Recovery Source Decision Record](#831-recovery-source-decision-record)
   - [8.32 Recovery Source Validation](#832-recovery-source-validation)
   - [8.33 Recovery Source Evidence](#833-recovery-source-evidence)
   - [8.34 Recovery Source Strategy Guarantees](#834-recovery-source-strategy-guarantees)

[9. Replay](#9-replay)
   - [9.1 Replay Purpose](#91-replay-purpose)
   - [9.2 Replay Source](#92-replay-source)
   - [9.3 Replay Boundary](#93-replay-boundary)
   - [9.4 Replay End Boundary](#94-replay-end-boundary)
   - [9.5 Replay Versus Restart](#95-replay-versus-restart)
   - [9.6 Replay Versus Retry](#96-replay-versus-retry)
   - [9.7 Replay Versus Reprocessing](#97-replay-versus-reprocessing)
   - [9.8 Replay Versus Backfill](#98-replay-versus-backfill)
   - [9.9 Replay Versus Rebuild](#99-replay-versus-rebuild)
   - [9.10 Replay and At-Least-Once Processing](#910-replay-and-at-least-once-processing)
   - [9.11 Replay and Idempotency](#911-replay-and-idempotency)
   - [9.12 Replay and Existing Output](#912-replay-and-existing-output)
   - [9.13 Replay and Kafka Offsets](#913-replay-and-kafka-offsets)
   - [9.14 Replay Consumer Strategy](#914-replay-consumer-strategy)
   - [9.15 Replay and Live Processing](#915-replay-and-live-processing)
   - [9.16 Replay Ordering](#916-replay-ordering)
   - [9.17 Replay Scope](#917-replay-scope)
   - [9.18 Replay and Dependencies](#918-replay-and-dependencies)
   - [9.19 Replay and Historical Contracts](#919-replay-and-historical-contracts)
   - [9.20 Replay and Processing Versions](#920-replay-and-processing-versions)
   - [9.21 Replay and Schema Evolution](#921-replay-and-schema-evolution)
   - [9.22 Replay and Deleted or Changed Source State](#922-replay-and-deleted-or-changed-source-state)
   - [9.23 Replay and Bronze](#923-replay-and-bronze)
   - [9.24 Replay and Silver](#924-replay-and-silver)
   - [9.25 Replay and Gold](#925-replay-and-gold)
   - [9.26 Replay and Certified Gold](#926-replay-and-certified-gold)
   - [9.27 Replay and Checkpoints](#927-replay-and-checkpoints)
   - [9.28 Replay and Consumer Groups](#928-replay-and-consumer-groups)
   - [9.29 Replay and Retention](#929-replay-and-retention)
   - [9.30 Replay Window Exhaustion](#930-replay-window-exhaustion)
   - [9.31 Replay and Backlog](#931-replay-and-backlog)
   - [9.32 Replay Throttling](#932-replay-throttling)
   - [9.33 Replay Failure](#933-replay-failure)
   - [9.34 Replay Cancellation](#934-replay-cancellation)
   - [9.35 Replay Validation](#935-replay-validation)
   - [9.36 Replay Evidence](#936-replay-evidence)
   - [9.37 Replay Test Scenarios](#937-replay-test-scenarios)
   - [9.38 Replay Guarantees](#938-replay-guarantees)

[10. Reprocessing](#10-reprocessing)
    - [10.1 Reprocessing Purpose](#101-reprocessing-purpose)
    - [10.2 Reprocessing Versus Replay](#102-reprocessing-versus-replay)
    - [10.3 Reprocessing Versus Restart](#103-reprocessing-versus-restart)
    - [10.4 Reprocessing Versus Retry](#104-reprocessing-versus-retry)
    - [10.5 Reprocessing Versus Backfill](#105-reprocessing-versus-backfill)
    - [10.6 Reprocessing Versus Rebuild](#106-reprocessing-versus-rebuild)
    - [10.7 Reprocessing Source](#107-reprocessing-source)
    - [10.8 Reprocessing Scope](#108-reprocessing-scope)
    - [10.9 Scope Dependencies](#109-scope-dependencies)
    - [10.10 Reprocessing With the Same Logic](#1010-reprocessing-with-the-same-logic)
    - [10.11 Reprocessing With Corrected Logic](#1011-reprocessing-with-corrected-logic)
    - [10.12 Reprocessing With New Logic](#1012-reprocessing-with-new-logic)
    - [10.13 Historical Reproduction](#1013-historical-reproduction)
    - [10.14 Historical Restatement](#1014-historical-restatement)
    - [10.15 Reprocessing Version Selection](#1015-reprocessing-version-selection)
    - [10.16 Reprocessing and Determinism](#1016-reprocessing-and-determinism)
    - [10.17 Reprocessing and Current Time](#1017-reprocessing-and-current-time)
    - [10.18 Reprocessing and Reference Data](#1018-reprocessing-and-reference-data)
    - [10.19 Reprocessing and Slowly Changing Dimensions](#1019-reprocessing-and-slowly-changing-dimensions)
    - [10.20 Reprocessing and Existing State](#1020-reprocessing-and-existing-state)
    - [10.21 In-Place Reprocessing](#1021-in-place-reprocessing)
    - [10.22 Versioned Reprocessing](#1022-versioned-reprocessing)
    - [10.23 Reprocessing and Live Processing](#1023-reprocessing-and-live-processing)
    - [10.24 Reprocessing Isolation](#1024-reprocessing-isolation)
    - [10.25 Reprocessing and Checkpoints](#1025-reprocessing-and-checkpoints)
    - [10.26 Reprocessing and Lineage](#1026-reprocessing-and-lineage)
    - [10.27 Reprocessing and Quality](#1027-reprocessing-and-quality)
    - [10.28 Reprocessing and Reconciliation](#1028-reprocessing-and-reconciliation)
    - [10.29 Expected Differences](#1029-expected-differences)
    - [10.30 Reprocessing and Certification](#1030-reprocessing-and-certification)
    - [10.31 Reprocessing Failure](#1031-reprocessing-failure)
    - [10.32 Partial Reprocessing Failure](#1032-partial-reprocessing-failure)
    - [10.33 Reprocessing Cancellation](#1033-reprocessing-cancellation)
    - [10.34 Reprocessing Resource Impact](#1034-reprocessing-resource-impact)
    - [10.35 Reprocessing Priority](#1035-reprocessing-priority)
    - [10.36 Reprocessing Validation](#1036-reprocessing-validation)
    - [10.37 Reprocessing Evidence](#1037-reprocessing-evidence)
    - [10.38 Reprocessing Test Scenarios](#1038-reprocessing-test-scenarios)
    - [10.39 Reprocessing Guarantees](#1039-reprocessing-guarantees)

[11. Backfill](#11-backfill)
    - [11.1 Backfill Purpose](#111-backfill-purpose)
    - [11.2 Backfill Versus Replay](#112-backfill-versus-replay)
    - [11.3 Backfill Versus Reprocessing](#113-backfill-versus-reprocessing)
    - [11.4 Backfill Versus Rebuild](#114-backfill-versus-rebuild)
    - [11.5 Backfill Versus Restart and Retry](#115-backfill-versus-restart-and-retry)
    - [11.6 Backfill Source](#116-backfill-source)
    - [11.7 AtlasCommerce Backfill](#117-atlascommerce-backfill)
    - [11.8 Current-State Backfill](#118-current-state-backfill)
    - [11.9 Historical Backfill](#119-historical-backfill)
    - [11.10 Snapshot Backfill](#1110-snapshot-backfill)
    - [11.11 Event Backfill](#1111-event-backfill)
    - [11.12 Original Event Versus Reconstructed Event](#1112-original-event-versus-reconstructed-event)
    - [11.13 Backfill Scope](#1113-backfill-scope)
    - [11.14 Backfill Boundary](#1114-backfill-boundary)
    - [11.15 Gap Identification](#1115-gap-identification)
    - [11.16 Gap Boundaries](#1116-gap-boundaries)
    - [11.17 Backfill Completeness](#1117-backfill-completeness)
    - [11.18 Backfill Consistency](#1118-backfill-consistency)
    - [11.19 Backfill and Concurrent Changes](#1119-backfill-and-concurrent-changes)
    - [11.20 Backfill Cutoff](#1120-backfill-cutoff)
    - [11.21 Backfill and Idempotency](#1121-backfill-and-idempotency)
    - [11.22 Backfill and Ordering](#1122-backfill-and-ordering)
    - [11.23 Backfill and Event Time](#1123-backfill-and-event-time)
    - [11.24 Backfill and Schema](#1124-backfill-and-schema)
    - [11.25 Backfill and Contract Version](#1125-backfill-and-contract-version)
    - [11.26 Backfill Provenance](#1126-backfill-provenance)
    - [11.27 Backfill and Bronze](#1127-backfill-and-bronze)
    - [11.28 Backfill and Silver](#1128-backfill-and-silver)
    - [11.29 Backfill and Gold](#1129-backfill-and-gold)
    - [11.30 Backfill and Certified Gold](#1130-backfill-and-certified-gold)
    - [11.31 Backfill and Historical Dimensions](#1131-backfill-and-historical-dimensions)
    - [11.32 Backfill and Deleted Records](#1132-backfill-and-deleted-records)
    - [11.33 Backfill and Source Impact](#1133-backfill-and-source-impact)
    - [11.34 Backfill Batching](#1134-backfill-batching)
    - [11.35 Backfill Restartability](#1135-backfill-restartability)
    - [11.36 Backfill Failure](#1136-backfill-failure)
    - [11.37 Backfill Cancellation](#1137-backfill-cancellation)
    - [11.38 Backfill and Security](#1138-backfill-and-security)
    - [11.39 Backfill and Retention](#1139-backfill-and-retention)
    - [11.40 Backfill and Lineage](#1140-backfill-and-lineage)
    - [11.41 Backfill and Reconciliation](#1141-backfill-and-reconciliation)
    - [11.42 Expected Backfill Differences](#1142-expected-backfill-differences)
    - [11.43 Backfill Validation](#1143-backfill-validation)
    - [11.44 Backfill Evidence](#1144-backfill-evidence)
    - [11.45 Backfill Test Scenarios](#1145-backfill-test-scenarios)
    - [11.46 Backfill Guarantees](#1146-backfill-guarantees)

[12. Rebuild](#12-rebuild)
    - [12.1 Rebuild Purpose](#121-rebuild-purpose)
    - [12.2 Rebuild Versus Restart](#122-rebuild-versus-restart)
    - [12.3 Rebuild Versus Retry](#123-rebuild-versus-retry)
    - [12.4 Rebuild Versus Replay](#124-rebuild-versus-replay)
    - [12.5 Rebuild Versus Reprocessing](#125-rebuild-versus-reprocessing)
    - [12.6 Rebuild Versus Backfill](#126-rebuild-versus-backfill)
    - [12.7 Rebuild Source](#127-rebuild-source)
    - [12.8 Rebuild Scope](#128-rebuild-scope)
    - [12.9 Full Rebuild](#129-full-rebuild)
    - [12.10 Partial Rebuild](#1210-partial-rebuild)
    - [12.11 Rebuild Dependency Analysis](#1211-rebuild-dependency-analysis)
    - [12.12 Bronze Rebuild](#1212-bronze-rebuild)
    - [12.13 Silver Rebuild](#1213-silver-rebuild)
    - [12.14 Gold Rebuild](#1214-gold-rebuild)
    - [12.15 Certified Gold Rebuild](#1215-certified-gold-rebuild)
    - [12.16 Rebuild From Backup](#1216-rebuild-from-backup)
    - [12.17 Rebuild and Historical Versions](#1217-rebuild-and-historical-versions)
    - [12.18 Historical Reproduction During Rebuild](#1218-historical-reproduction-during-rebuild)
    - [12.19 Historical Restatement During Rebuild](#1219-historical-restatement-during-rebuild)
    - [12.20 Rebuild Target Strategy](#1220-rebuild-target-strategy)
    - [12.21 In-Place Rebuild](#1221-in-place-rebuild)
    - [12.22 Shadow Rebuild](#1222-shadow-rebuild)
    - [12.23 Versioned Rebuild](#1223-versioned-rebuild)
    - [12.24 Rebuild and Live Processing](#1224-rebuild-and-live-processing)
    - [12.25 Rebuild Cutoff](#1225-rebuild-cutoff)
    - [12.26 Rebuild Catch-Up](#1226-rebuild-catch-up)
    - [12.27 Rebuild and Idempotency](#1227-rebuild-and-idempotency)
    - [12.28 Rebuild Progress](#1228-rebuild-progress)
    - [12.29 Rebuild Restartability](#1229-rebuild-restartability)
    - [12.30 Rebuild Failure](#1230-rebuild-failure)
    - [12.31 Partial Rebuild State](#1231-partial-rebuild-state)
    - [12.32 Rebuild Cancellation](#1232-rebuild-cancellation)
    - [12.33 Rebuild Resource Impact](#1233-rebuild-resource-impact)
    - [12.34 Rebuild Throttling](#1234-rebuild-throttling)
    - [12.35 Rebuild Prioritization](#1235-rebuild-prioritization)
    - [12.36 Rebuild and Quality Validation](#1236-rebuild-and-quality-validation)
    - [12.37 Rebuild and Reconciliation](#1237-rebuild-and-reconciliation)
    - [12.38 Rebuild and Certification](#1238-rebuild-and-certification)
    - [12.39 Rebuild and Rollback](#1239-rebuild-and-rollback)
    - [12.40 Rebuild and Lineage](#1240-rebuild-and-lineage)
    - [12.41 Rebuild and Metadata](#1241-rebuild-and-metadata)
    - [12.42 Rebuild and Security](#1242-rebuild-and-security)
    - [12.43 Rebuild and Retention](#1243-rebuild-and-retention)
    - [12.44 Rebuild and RPO](#1244-rebuild-and-rpo)
    - [12.45 Rebuild and RTO](#1245-rebuild-and-rto)
    - [12.46 Rebuild Validation](#1246-rebuild-validation)
    - [12.47 Rebuild Evidence](#1247-rebuild-evidence)
    - [12.48 Rebuild Test Scenarios](#1248-rebuild-test-scenarios)
    - [12.49 Rebuild Guarantees](#1249-rebuild-guarantees)

[13. Component Failure and Recovery](#13-component-failure-and-recovery)
    - [13.1 AtlasCommerce Failure](#131-atlascommerce-failure)
    - [13.2 AtlasCommerce Recovery](#132-atlascommerce-recovery)
    - [13.3 CDC Failure](#133-cdc-failure)
    - [13.4 CDC Recovery](#134-cdc-recovery)
    - [13.5 Debezium Failure](#135-debezium-failure)
    - [13.6 Debezium Recovery](#136-debezium-recovery)
    - [13.7 Apicurio Registry Failure](#137-apicurio-registry-failure)
    - [13.8 Apicurio Registry Recovery](#138-apicurio-registry-recovery)
    - [13.9 Kafka Producer Failure](#139-kafka-producer-failure)
    - [13.10 Kafka Broker Failure](#1310-kafka-broker-failure)
    - [13.11 Kafka Recovery](#1311-kafka-recovery)
    - [13.12 Kafka Consumer Failure](#1312-kafka-consumer-failure)
    - [13.13 Kafka Consumer Recovery](#1313-kafka-consumer-recovery)
    - [13.14 Bronze Processor Failure](#1314-bronze-processor-failure)
    - [13.15 Bronze Processor Recovery](#1315-bronze-processor-recovery)
    - [13.16 MinIO Failure](#1316-minio-failure)
    - [13.17 MinIO Recovery](#1317-minio-recovery)
    - [13.18 Bronze Storage Loss](#1318-bronze-storage-loss)
    - [13.19 Silver Processor Failure](#1319-silver-processor-failure)
    - [13.20 Silver Processor Recovery](#1320-silver-processor-recovery)
    - [13.21 Silver Storage Loss](#1321-silver-storage-loss)
    - [13.22 Gold Processor Failure](#1322-gold-processor-failure)
    - [13.23 Gold Processor Recovery](#1323-gold-processor-recovery)
    - [13.24 AtlasWarehouse Failure](#1324-atlaswarehouse-failure)
    - [13.25 AtlasWarehouse Recovery](#1325-atlaswarehouse-recovery)
    - [13.26 Quality-Control Failure](#1326-quality-control-failure)
    - [13.27 Reconciliation Failure](#1327-reconciliation-failure)
    - [13.28 Certification Failure](#1328-certification-failure)
    - [13.29 Publication Failure](#1329-publication-failure)
    - [13.30 Power BI Failure](#1330-power-bi-failure)
    - [13.31 Power BI Recovery](#1331-power-bi-recovery)
    - [13.32 Airflow Failure](#1332-airflow-failure)
    - [13.33 Airflow Recovery](#1333-airflow-recovery)
    - [13.34 Prometheus Failure](#1334-prometheus-failure)
    - [13.35 Prometheus Recovery](#1335-prometheus-recovery)
    - [13.36 Grafana Failure](#1336-grafana-failure)
    - [13.37 Structured Logging Failure](#1337-structured-logging-failure)
    - [13.38 Network Failure](#1338-network-failure)
    - [13.39 Credential Failure](#1339-credential-failure)
    - [13.40 Host Failure](#1340-host-failure)
    - [13.41 Complete Laboratory Failure](#1341-complete-laboratory-failure)
    - [13.42 Recovery Dependency Order](#1342-recovery-dependency-order)
    - [13.43 Recovery Cascade](#1343-recovery-cascade)
    - [13.44 Component Recovery Validation](#1344-component-recovery-validation)
    - [13.45 Component Recovery Evidence](#1345-component-recovery-evidence)
    - [13.46 Component Failure and Recovery Guarantees](#1346-component-failure-and-recovery-guarantees)

[14. Partial Failure and Failure Isolation](#14-partial-failure-and-failure-isolation)
    - [14.1 Partial Failure](#141-partial-failure)
    - [14.2 Failure Isolation](#142-failure-isolation)
    - [14.3 Isolation and Dependency Analysis](#143-isolation-and-dependency-analysis)
    - [14.4 Record-Level Isolation](#144-record-level-isolation)
    - [14.5 Event-Level Isolation](#145-event-level-isolation)
    - [14.6 Partition-Level Isolation](#146-partition-level-isolation)
    - [14.7 Entity-Level Isolation](#147-entity-level-isolation)
    - [14.8 Batch-Level Isolation](#148-batch-level-isolation)
    - [14.9 Dataset-Level Isolation](#149-dataset-level-isolation)
    - [14.10 Data Product Isolation](#1410-data-product-isolation)
    - [14.11 Shared Dependency Failure](#1411-shared-dependency-failure)
    - [14.12 Conformed Dimension Failure](#1412-conformed-dimension-failure)
    - [14.13 Reference Data Failure](#1413-reference-data-failure)
    - [14.14 Isolation and Ordering](#1414-isolation-and-ordering)
    - [14.15 Isolation and Completeness](#1415-isolation-and-completeness)
    - [14.16 Isolation and Quality Rules](#1416-isolation-and-quality-rules)
    - [14.17 Isolation and Reconciliation](#1417-isolation-and-reconciliation)
    - [14.18 Isolation and Certification](#1418-isolation-and-certification)
    - [14.19 Fail-Safe Publication](#1419-fail-safe-publication)
    - [14.20 Partial Analytical Availability](#1420-partial-analytical-availability)
    - [14.21 Isolation and Backlog](#1421-isolation-and-backlog)
    - [14.22 Isolation and Recovery Window](#1422-isolation-and-recovery-window)
    - [14.23 Isolation and Resource Consumption](#1423-isolation-and-resource-consumption)
    - [14.24 Isolation and Quarantine](#1424-isolation-and-quarantine)
    - [14.25 Isolation and Checkpoints](#1425-isolation-and-checkpoints)
    - [14.26 Isolation With Continued Processing](#1426-isolation-with-continued-processing)
    - [14.27 Isolation With Processing Block](#1427-isolation-with-processing-block)
    - [14.28 Failure Containment](#1428-failure-containment)
    - [14.29 Blast Radius](#1429-blast-radius)
    - [14.30 Isolation and Root Cause](#1430-isolation-and-root-cause)
    - [14.31 Isolation Recovery](#1431-isolation-recovery)
    - [14.32 Rejoining Normal Processing](#1432-rejoining-normal-processing)
    - [14.33 Isolation and Lineage](#1433-isolation-and-lineage)
    - [14.34 Isolation and Evidence](#1434-isolation-and-evidence)
    - [14.35 Partial Failure Test Scenarios](#1435-partial-failure-test-scenarios)
    - [14.36 Partial Failure and Isolation Guarantees](#1436-partial-failure-and-isolation-guarantees)

[15. Poison Records and Persistent Processing Failures](#15-poison-records-and-persistent-processing-failures)
    - [15.1 Poison Record](#151-poison-record)
    - [15.2 Persistent Processing Failure](#152-persistent-processing-failure)
    - [15.3 Poison Record Versus Transient Failure](#153-poison-record-versus-transient-failure)
    - [15.4 Failure Classification](#154-failure-classification)
    - [15.5 Retry Exhaustion](#155-retry-exhaustion)
    - [15.6 No Infinite Retry](#156-no-infinite-retry)
    - [15.7 No Silent Skip](#157-no-silent-skip)
    - [15.8 Failure Isolation Decision](#158-failure-isolation-decision)
    - [15.9 Quarantine](#159-quarantine)
    - [15.10 Quarantine Scope](#1510-quarantine-scope)
    - [15.11 Quarantine Metadata](#1511-quarantine-metadata)
    - [15.12 Quarantine State](#1512-quarantine-state)
    - [15.13 Quarantine Is Not a Dead End](#1513-quarantine-is-not-a-dead-end)
    - [15.14 Quarantine and Kafka Ordering](#1514-quarantine-and-kafka-ordering)
    - [15.15 Quarantine and Offset Commit](#1515-quarantine-and-offset-commit)
    - [15.16 Quarantine and Entity Ordering](#1516-quarantine-and-entity-ordering)
    - [15.17 Quarantine and Bronze](#1517-quarantine-and-bronze)
    - [15.18 Bronze Poison Failure](#1518-bronze-poison-failure)
    - [15.19 Silver Poison Failure](#1519-silver-poison-failure)
    - [15.20 Gold Poison Failure](#1520-gold-poison-failure)
    - [15.21 Quality Failure Versus Processing Failure](#1521-quality-failure-versus-processing-failure)
    - [15.22 Contract Failure](#1522-contract-failure)
    - [15.23 Reference-Data Failure](#1523-reference-data-failure)
    - [15.24 Processing-Logic Defect](#1524-processing-logic-defect)
    - [15.25 Repeated Failure Pattern](#1525-repeated-failure-pattern)
    - [15.26 Quarantine Growth](#1526-quarantine-growth)
    - [15.27 Quarantine and Recovery Windows](#1527-quarantine-and-recovery-windows)
    - [15.28 Quarantine and Backlog](#1528-quarantine-and-backlog)
    - [15.29 Quarantine and Completeness](#1529-quarantine-and-completeness)
    - [15.30 Quarantine and Reconciliation](#1530-quarantine-and-reconciliation)
    - [15.31 Quarantine and Certification](#1531-quarantine-and-certification)
    - [15.32 Quarantine and Freshness](#1532-quarantine-and-freshness)
    - [15.33 Remediation](#1533-remediation)
    - [15.34 Source Data Correction](#1534-source-data-correction)
    - [15.35 Analytical Correction](#1535-analytical-correction)
    - [15.36 Manual Data Editing](#1536-manual-data-editing)
    - [15.37 Ready for Reprocessing](#1537-ready-for-reprocessing)
    - [15.38 Quarantine Reprocessing](#1538-quarantine-reprocessing)
    - [15.39 Reprocessing Failure](#1539-reprocessing-failure)
    - [15.40 Successful Reintegration](#1540-successful-reintegration)
    - [15.41 Historical Evidence](#1541-historical-evidence)
    - [15.42 Poison Record Ownership](#1542-poison-record-ownership)
    - [15.43 Persistent Failure Escalation](#1543-persistent-failure-escalation)
    - [15.44 Persistent Failure Observability](#1544-persistent-failure-observability)
    - [15.45 Persistent Failure Alerts](#1545-persistent-failure-alerts)
    - [15.46 Persistent Failure Recovery Validation](#1546-persistent-failure-recovery-validation)
    - [15.47 Poison Record Evidence](#1547-poison-record-evidence)
    - [15.48 Poison Record Test Scenarios](#1548-poison-record-test-scenarios)
    - [15.49 Persistent Failure Test Scenarios](#1549-persistent-failure-test-scenarios)
    - [15.50 Poison Records and Persistent Failure Guarantees](#1550-poison-records-and-persistent-failure-guarantees)

[16. Backlog Recovery and Catch-Up](#16-backlog-recovery-and-catch-up)
    - [16.1 Backlog](#161-backlog)
    - [16.2 Backlog Causes](#162-backlog-causes)
    - [16.3 Catch-Up](#163-catch-up)
    - [16.4 Catch-Up Is Not Replay](#164-catch-up-is-not-replay)
    - [16.5 Catch-Up Is Not Reprocessing](#165-catch-up-is-not-reprocessing)
    - [16.6 Catch-Up and Checkpoints](#166-catch-up-and-checkpoints)
    - [16.7 Backlog Measurement](#167-backlog-measurement)
    - [16.8 Oldest Pending Age](#168-oldest-pending-age)
    - [16.9 Backlog Growth Rate](#169-backlog-growth-rate)
    - [16.10 Catch-Up Capacity](#1610-catch-up-capacity)
    - [16.11 Catch-Up Ratio](#1611-catch-up-ratio)
    - [16.12 Catch-Up Time](#1612-catch-up-time)
    - [16.13 Backlog and Freshness](#1613-backlog-and-freshness)
    - [16.14 Freshness Recovery](#1614-freshness-recovery)
    - [16.15 Catch-Up and P95 Latency](#1615-catch-up-and-p95-latency)
    - [16.16 Catch-Up and New Events](#1616-catch-up-and-new-events)
    - [16.17 Catch-Up Ordering](#1617-catch-up-ordering)
    - [16.18 Catch-Up and Parallelism](#1618-catch-up-and-parallelism)
    - [16.19 Catch-Up and Kafka Partitions](#1619-catch-up-and-kafka-partitions)
    - [16.20 Partition Skew](#1620-partition-skew)
    - [16.21 Catch-Up and Backpressure](#1621-catch-up-and-backpressure)
    - [16.22 Catch-Up Throttling](#1622-catch-up-throttling)
    - [16.23 Catch-Up and Resource Headroom](#1623-catch-up-and-resource-headroom)
    - [16.24 Catch-Up and Peak Workload](#1624-catch-up-and-peak-workload)
    - [16.25 Catch-Up and Retry Load](#1625-catch-up-and-retry-load)
    - [16.26 Catch-Up and Quarantine](#1626-catch-up-and-quarantine)
    - [16.27 Catch-Up and Retention](#1627-catch-up-and-retention)
    - [16.28 Recovery Window Margin](#1628-recovery-window-margin)
    - [16.29 Catch-Up and CDC](#1629-catch-up-and-cdc)
    - [16.30 Catch-Up Across Layers](#1630-catch-up-across-layers)
    - [16.31 Bottleneck Migration](#1631-bottleneck-migration)
    - [16.32 Catch-Up and Silver](#1632-catch-up-and-silver)
    - [16.33 Catch-Up and Gold](#1633-catch-up-and-gold)
    - [16.34 Catch-Up and Certification](#1634-catch-up-and-certification)
    - [16.35 Catch-Up and Certified Gold](#1635-catch-up-and-certified-gold)
    - [16.36 Catch-Up Completion](#1636-catch-up-completion)
    - [16.37 Normal Operating Range](#1637-normal-operating-range)
    - [16.38 Catch-Up Failure](#1638-catch-up-failure)
    - [16.39 Catch-Up Cancellation or Pause](#1639-catch-up-cancellation-or-pause)
    - [16.40 Catch-Up Priority](#1640-catch-up-priority)
    - [16.41 Catch-Up and RTO](#1641-catch-up-and-rto)
    - [16.42 Catch-Up and SLO Recovery](#1642-catch-up-and-slo-recovery)
    - [16.43 Catch-Up Observability](#1643-catch-up-observability)
    - [16.44 Catch-Up Alerting](#1644-catch-up-alerting)
    - [16.45 Catch-Up Validation](#1645-catch-up-validation)
    - [16.46 Catch-Up Evidence](#1646-catch-up-evidence)
    - [16.47 Catch-Up Test Scenarios](#1647-catch-up-test-scenarios)
    - [16.48 Backlog Recovery and Catch-Up Guarantees](#1648-backlog-recovery-and-catch-up-guarantees)

[17. Certified Gold Availability and Rollback](#17-certified-gold-availability-and-rollback)
    - [17.1 Certified Gold as an Availability Boundary](#171-certified-gold-as-an-availability-boundary)
    - [17.2 Known-Good Certified Version](#172-known-good-certified-version)
    - [17.3 Certification Does Not Guarantee Permanent Trust](#173-certification-does-not-guarantee-permanent-trust)
    - [17.4 Candidate Isolation](#174-candidate-isolation)
    - [17.5 Candidate Failure](#175-candidate-failure)
    - [17.6 Freshness Degradation](#176-freshness-degradation)
    - [17.7 Consumer-Visible Staleness](#177-consumer-visible-staleness)
    - [17.8 Publication Eligibility](#178-publication-eligibility)
    - [17.9 Atomic Publication](#179-atomic-publication)
    - [17.10 Publication Metadata](#1710-publication-metadata)
    - [17.11 Publication Failure](#1711-publication-failure)
    - [17.12 Partial Publication Failure](#1712-partial-publication-failure)
    - [17.13 Publication Transaction Boundary](#1713-publication-transaction-boundary)
    - [17.14 Rollback](#1714-rollback)
    - [17.15 Rollback Source](#1715-rollback-source)
    - [17.16 Rollback Eligibility](#1716-rollback-eligibility)
    - [17.17 Rollback Versus Rebuild](#1717-rollback-versus-rebuild)
    - [17.18 Rollback Versus Backup Restore](#1718-rollback-versus-backup-restore)
    - [17.19 Rollback and Freshness](#1719-rollback-and-freshness)
    - [17.20 Rollback and Consumer Compatibility](#1720-rollback-and-consumer-compatibility)
    - [17.21 Version Retention for Rollback](#1721-version-retention-for-rollback)
    - [17.22 Published-Version Immutability](#1722-published-version-immutability)
    - [17.23 Certification History](#1723-certification-history)
    - [17.24 Publication History](#1724-publication-history)
    - [17.25 Post-Publication Validation](#1725-post-publication-validation)
    - [17.26 Post-Publication Defect](#1726-post-publication-defect)
    - [17.27 Published Data Incident](#1727-published-data-incident)
    - [17.28 No Known-Good Certified Version](#1728-no-known-good-certified-version)
    - [17.29 Product-Level Availability](#1729-product-level-availability)
    - [17.30 Product-Level Recovery State](#1730-product-level-recovery-state)
    - [17.31 Certified Gold and Upstream Catch-Up](#1731-certified-gold-and-upstream-catch-up)
    - [17.32 Publication Frequency During Recovery](#1732-publication-frequency-during-recovery)
    - [17.33 Roll-Forward](#1733-roll-forward)
    - [17.34 Roll-Forward Validation](#1734-roll-forward-validation)
    - [17.35 Rollback and Lineage](#1735-rollback-and-lineage)
    - [17.36 Rollback and Metadata](#1736-rollback-and-metadata)
    - [17.37 Rollback and Security](#1737-rollback-and-security)
    - [17.38 Rollback and Retention](#1738-rollback-and-retention)
    - [17.39 Rollback and RPO](#1739-rollback-and-rpo)
    - [17.40 Rollback and RTO](#1740-rollback-and-rto)
    - [17.41 Publication Freeze](#1741-publication-freeze)
    - [17.42 Publication Freeze Recovery](#1742-publication-freeze-recovery)
    - [17.43 Consumer Recovery](#1743-consumer-recovery)
    - [17.44 Certified Gold Availability Validation](#1744-certified-gold-availability-validation)
    - [17.45 Rollback Validation](#1745-rollback-validation)
    - [17.46 Certified Gold Evidence](#1746-certified-gold-evidence)
    - [17.47 Certified Gold Test Scenarios](#1747-certified-gold-test-scenarios)
    - [17.48 Certified Gold Availability and Rollback Guarantees](#1748-certified-gold-availability-and-rollback-guarantees)

[18. Recovery and Historical Versions](#18-recovery-and-historical-versions)
    - [18.1 Historical Version Context](#181-historical-version-context)
    - [18.2 Version Identity](#182-version-identity)
    - [18.3 Historical Event Contracts](#183-historical-event-contracts)
    - [18.4 Contract Evolution](#184-contract-evolution)
    - [18.5 Apicurio Registry Historical Role](#185-apicurio-registry-historical-role)
    - [18.6 Source Schema Evolution](#186-source-schema-evolution)
    - [18.7 Bronze Schema Evolution](#187-bronze-schema-evolution)
    - [18.8 Silver Schema Evolution](#188-silver-schema-evolution)
    - [18.9 Gold Model Evolution](#189-gold-model-evolution)
    - [18.10 Processing Definition](#1810-processing-definition)
    - [18.11 Processing Version](#1811-processing-version)
    - [18.12 Configuration Version](#1812-configuration-version)
    - [18.13 Infrastructure Version](#1813-infrastructure-version)
    - [18.14 Historical Reproduction](#1814-historical-reproduction)
    - [18.15 Historical Restatement](#1815-historical-restatement)
    - [18.16 Reproduction Versus Restatement](#1816-reproduction-versus-restatement)
    - [18.17 Corrected Historical Logic](#1817-corrected-historical-logic)
    - [18.18 Historical Reference Data](#1818-historical-reference-data)
    - [18.19 Reference-Data Versioning](#1819-reference-data-versioning)
    - [18.20 Historical Business Rules](#1820-historical-business-rules)
    - [18.21 Quality Rule Versions](#1821-quality-rule-versions)
    - [18.22 Historical Quality Reproduction](#1822-historical-quality-reproduction)
    - [18.23 Current Quality Validation of Historical Data](#1823-current-quality-validation-of-historical-data)
    - [18.24 Reconciliation Rule Versions](#1824-reconciliation-rule-versions)
    - [18.25 Certification Rule Versions](#1825-certification-rule-versions)
    - [18.26 Historical Certification Evidence](#1826-historical-certification-evidence)
    - [18.27 Versioned Lineage](#1827-versioned-lineage)
    - [18.28 Version Compatibility](#1828-version-compatibility)
    - [18.29 Historical Processing Artifact Retention](#1829-historical-processing-artifact-retention)
    - [18.30 Git as Historical Evidence](#1830-git-as-historical-evidence)
    - [18.31 Immutable Artifact Identity](#1831-immutable-artifact-identity)
    - [18.32 Historical Secrets](#1832-historical-secrets)
    - [18.33 Historical Security Policy](#1833-historical-security-policy)
    - [18.34 Historical Privacy Requirements](#1834-historical-privacy-requirements)
    - [18.35 Historical Data Deletion](#1835-historical-data-deletion)
    - [18.36 Version Dependency Matrix](#1836-version-dependency-matrix)
    - [18.37 Recovery Version Selection](#1837-recovery-version-selection)
    - [18.38 Unsupported Historical Version](#1838-unsupported-historical-version)
    - [18.39 Version Migration](#1839-version-migration)
    - [18.40 Recovery Across Multiple Versions](#1840-recovery-across-multiple-versions)
    - [18.41 Version Boundary Detection](#1841-version-boundary-detection)
    - [18.42 Historical Version Testing](#1842-historical-version-testing)
    - [18.43 Recovery Drift](#1843-recovery-drift)
    - [18.44 Historical Recovery Window](#1844-historical-recovery-window)
    - [18.45 Version Retention Alignment](#1845-version-retention-alignment)
    - [18.46 Historical Recovery Validation](#1846-historical-recovery-validation)
    - [18.47 Historical Version Evidence](#1847-historical-version-evidence)
    - [18.48 Historical Version Test Scenarios](#1848-historical-version-test-scenarios)
    - [18.49 Recovery and Historical Version Guarantees](#1849-recovery-and-historical-version-guarantees)

[19. Recovery Validation and Evidence](#19-recovery-validation-and-evidence)
    - [19.1 Recovery Validation](#191-recovery-validation)
    - [19.2 Recovery Evidence](#192-recovery-evidence)
    - [19.3 Evidence Before Recovery](#193-evidence-before-recovery)
    - [19.4 Evidence During Failure](#194-evidence-during-failure)
    - [19.5 Evidence Before Remediation](#195-evidence-before-remediation)
    - [19.6 Recovery Action Evidence](#196-recovery-action-evidence)
    - [19.7 Recovery Source Evidence](#197-recovery-source-evidence)
    - [19.8 Recovery Boundary Evidence](#198-recovery-boundary-evidence)
    - [19.9 Service Recovery Validation](#199-service-recovery-validation)
    - [19.10 Processing Recovery Validation](#1910-processing-recovery-validation)
    - [19.11 Data Recovery Validation](#1911-data-recovery-validation)
    - [19.12 Continuity Validation](#1912-continuity-validation)
    - [19.13 Gap Detection](#1913-gap-detection)
    - [19.14 Overlap Detection](#1914-overlap-detection)
    - [19.15 Duplicate-Effect Validation](#1915-duplicate-effect-validation)
    - [19.16 Ordering Validation](#1916-ordering-validation)
    - [19.17 Checkpoint Validation](#1917-checkpoint-validation)
    - [19.18 Backlog Validation](#1918-backlog-validation)
    - [19.19 Retention Validation](#1919-retention-validation)
    - [19.20 Bronze Recovery Validation](#1920-bronze-recovery-validation)
    - [19.21 Silver Recovery Validation](#1921-silver-recovery-validation)
    - [19.22 Gold Recovery Validation](#1922-gold-recovery-validation)
    - [19.23 Certified Gold Recovery Validation](#1923-certified-gold-recovery-validation)
    - [19.24 Quality Validation](#1924-quality-validation)
    - [19.25 Reconciliation Validation](#1925-reconciliation-validation)
    - [19.26 Cross-Layer Validation](#1926-cross-layer-validation)
    - [19.27 End-to-End Recovery Validation](#1927-end-to-end-recovery-validation)
    - [19.28 Consumer Validation](#1928-consumer-validation)
    - [19.29 Freshness Validation](#1929-freshness-validation)
    - [19.30 RPO Validation](#1930-rpo-validation)
    - [19.31 RTO Validation](#1931-rto-validation)
    - [19.32 Recovery Timeline](#1932-recovery-timeline)
    - [19.33 Detection Time](#1933-detection-time)
    - [19.34 Intervention Time](#1934-intervention-time)
    - [19.35 Technical Restoration Time](#1935-technical-restoration-time)
    - [19.36 Processing Recovery Time](#1936-processing-recovery-time)
    - [19.37 Consumer Recovery Time](#1937-consumer-recovery-time)
    - [19.38 Full Recovery Time](#1938-full-recovery-time)
    - [19.39 Automated Evidence Collection](#1939-automated-evidence-collection)
    - [19.40 Manual Evidence](#1940-manual-evidence)
    - [19.41 Evidence Correlation](#1941-evidence-correlation)
    - [19.42 Time Consistency](#1942-time-consistency)
    - [19.43 Evidence Integrity](#1943-evidence-integrity)
    - [19.44 Failed Recovery Evidence](#1944-failed-recovery-evidence)
    - [19.45 Recovery Test Record](#1945-recovery-test-record)
    - [19.46 Expected Versus Observed Behavior](#1946-expected-versus-observed-behavior)
    - [19.47 PASS Criteria](#1947-pass-criteria)
    - [19.48 FAIL Criteria](#1948-fail-criteria)
    - [19.49 Inconclusive Result](#1949-inconclusive-result)
    - [19.50 Evidence and Architectural Claims](#1950-evidence-and-architectural-claims)
    - [19.51 Evidence and Version 1 Limitations](#1951-evidence-and-version-1-limitations)
    - [19.52 Evidence Retention](#1952-evidence-retention)
    - [19.53 Evidence in Public Documentation](#1953-evidence-in-public-documentation)
    - [19.54 Recovery Evidence and Observability](#1954-recovery-evidence-and-observability)
    - [19.55 Recovery Evidence and Documentation](#1955-recovery-evidence-and-documentation)
    - [19.56 Recovery Evidence and FAQ](#1956-recovery-evidence-and-faq)
    - [19.57 Recovery Validation Test Scenarios](#1957-recovery-validation-test-scenarios)
    - [19.58 Recovery Validation and Evidence Guarantees](#1958-recovery-validation-and-evidence-guarantees)

[20. Recovery Testing Strategy](#20-recovery-testing-strategy)
    - [20.1 Testing Objectives](#201-testing-objectives)
    - [20.2 Controlled Failure Injection](#202-controlled-failure-injection)
    - [20.3 Laboratory Scope](#203-laboratory-scope)
    - [20.4 Test Baseline](#204-test-baseline)
    - [20.5 Baseline Validation](#205-baseline-validation)
    - [20.6 Test Hypothesis](#206-test-hypothesis)
    - [20.7 Expected Failure Impact](#207-expected-failure-impact)
    - [20.8 PASS Criteria](#208-pass-criteria)
    - [20.9 FAIL Criteria](#209-fail-criteria)
    - [20.10 Inconclusive Criteria](#2010-inconclusive-criteria)
    - [20.11 Failure Injection Boundary](#2011-failure-injection-boundary)
    - [20.12 One Failure at a Time](#2012-one-failure-at-a-time)
    - [20.13 Compound Failure Testing](#2013-compound-failure-testing)
    - [20.14 Failure Duration](#2014-failure-duration)
    - [20.15 Test Workload](#2015-test-workload)
    - [20.16 Synthetic Test Data](#2016-synthetic-test-data)
    - [20.17 Test Data Identity](#2017-test-data-identity)
    - [20.18 Test Isolation](#2018-test-isolation)
    - [20.19 Test Cleanup](#2019-test-cleanup)
    - [20.20 Cleanup Validation](#2020-cleanup-validation)
    - [20.21 Restart Test](#2021-restart-test)
    - [20.22 Retry Test](#2022-retry-test)
    - [20.23 Redelivery Test](#2023-redelivery-test)
    - [20.24 Replay Test](#2024-replay-test)
    - [20.25 Reprocessing Test](#2025-reprocessing-test)
    - [20.26 Backfill Test](#2026-backfill-test)
    - [20.27 Rebuild Test](#2027-rebuild-test)
    - [20.28 Interrupted Rebuild Test](#2028-interrupted-rebuild-test)
    - [20.29 Backlog Recovery Test](#2029-backlog-recovery-test)
    - [20.30 Poison Record Test](#2030-poison-record-test)
    - [20.31 Partition Isolation Test](#2031-partition-isolation-test)
    - [20.32 Certification Failure Test](#2032-certification-failure-test)
    - [20.33 Publication Failure Test](#2033-publication-failure-test)
    - [20.34 Rollback Test](#2034-rollback-test)
    - [20.35 Roll-Forward Test](#2035-roll-forward-test)
    - [20.36 Retention Boundary Test](#2036-retention-boundary-test)
    - [20.37 Historical Version Test](#2037-historical-version-test)
    - [20.38 Observability Failure Test](#2038-observability-failure-test)
    - [20.39 End-to-End Failure Test](#2039-end-to-end-failure-test)
    - [20.40 Test Repetition](#2040-test-repetition)
    - [20.41 Repeatability](#2041-repeatability)
    - [20.42 Test Automation](#2042-test-automation)
    - [20.43 Manual Tests](#2043-manual-tests)
    - [20.44 Test Safety](#2044-test-safety)
    - [20.45 Failure Injection Safety Boundary](#2045-failure-injection-safety-boundary)
    - [20.46 Recovery Test Catalog](#2046-recovery-test-catalog)
    - [20.47 Test Naming](#2047-test-naming)
    - [20.48 Test Record](#2048-test-record)
    - [20.49 Test Evidence](#2049-test-evidence)
    - [20.50 Test Result](#2050-test-result)
    - [20.51 Failed Test Workflow](#2051-failed-test-workflow)
    - [20.52 Architecture Correction](#2052-architecture-correction)
    - [20.53 Capacity Findings](#2053-capacity-findings)
    - [20.54 Reliability Baseline](#2054-reliability-baseline)
    - [20.55 Recovery Test Review](#2055-recovery-test-review)
    - [20.56 Recovery Regression Testing](#2056-recovery-regression-testing)
    - [20.57 Laboratory Versus Chaos Engineering](#2057-laboratory-versus-chaos-engineering)
    - [20.58 Recovery Testing Guarantees](#2058-recovery-testing-guarantees)

[21. Recovery Observability](#21-recovery-observability)
    - [21.1 Recovery Observability Scope](#211-recovery-observability-scope)
    - [21.2 Service Health](#212-service-health)
    - [21.3 Dependency Health](#213-dependency-health)
    - [21.4 Processing Progress](#214-processing-progress)
    - [21.5 Checkpoint Observability](#215-checkpoint-observability)
    - [21.6 Checkpoint Staleness](#216-checkpoint-staleness)
    - [21.7 Kafka Consumer Lag](#217-kafka-consumer-lag)
    - [21.8 Partition-Level Lag](#218-partition-level-lag)
    - [21.9 Backlog Depth](#219-backlog-depth)
    - [21.10 Oldest Pending Age](#2110-oldest-pending-age)
    - [21.11 Backlog Trend](#2111-backlog-trend)
    - [21.12 Incoming Rate](#2112-incoming-rate)
    - [21.13 Processing Rate](#2113-processing-rate)
    - [21.14 Catch-Up Ratio](#2114-catch-up-ratio)
    - [21.15 Catch-Up Progress](#2115-catch-up-progress)
    - [21.16 Retry Observability](#2116-retry-observability)
    - [21.17 Retry Exhaustion](#2117-retry-exhaustion)
    - [21.18 Persistent Failure Observability](#2118-persistent-failure-observability)
    - [21.19 Quarantine Observability](#2119-quarantine-observability)
    - [21.20 Processing Gap Observability](#2120-processing-gap-observability)
    - [21.21 Recovery Window Observability](#2121-recovery-window-observability)
    - [21.22 Recovery Window Margin](#2122-recovery-window-margin)
    - [21.23 CDC Recovery Signals](#2123-cdc-recovery-signals)
    - [21.24 Debezium Recovery Signals](#2124-debezium-recovery-signals)
    - [21.25 Kafka Recovery Signals](#2125-kafka-recovery-signals)
    - [21.26 Bronze Recovery Signals](#2126-bronze-recovery-signals)
    - [21.27 Silver Recovery Signals](#2127-silver-recovery-signals)
    - [21.28 Gold Recovery Signals](#2128-gold-recovery-signals)
    - [21.29 Certification Signals](#2129-certification-signals)
    - [21.30 Publication Signals](#2130-publication-signals)
    - [21.31 Certified Gold Freshness](#2131-certified-gold-freshness)
    - [21.32 Consumer Availability Signals](#2132-consumer-availability-signals)
    - [21.33 Recovery State](#2133-recovery-state)
    - [21.34 Recovery Timeline](#2134-recovery-timeline)
    - [21.35 Recovery Bottleneck](#2135-recovery-bottleneck)
    - [21.36 Recovery Convergence](#2136-recovery-convergence)
    - [21.37 Recovery Stall](#2137-recovery-stall)
    - [21.38 Recovery Regression](#2138-recovery-regression)
    - [21.39 Recovery and SLOs](#2139-recovery-and-slos)
    - [21.40 Recovery and RPO](#2140-recovery-and-rpo)
    - [21.41 Recovery and RTO](#2141-recovery-and-rto)
    - [21.42 Alerting Principles](#2142-alerting-principles)
    - [21.43 Alert Severity](#2143-alert-severity)
    - [21.44 Alert Correlation](#2144-alert-correlation)
    - [21.45 Alert Suppression During Recovery](#2145-alert-suppression-during-recovery)
    - [21.46 Recovery Dashboards](#2146-recovery-dashboards)
    - [21.47 Recovery Logs](#2147-recovery-logs)
    - [21.48 Recovery Metrics](#2148-recovery-metrics)
    - [21.49 Recovery Traces and Correlation](#2149-recovery-traces-and-correlation)
    - [21.50 Observability Failure During Recovery](#2150-observability-failure-during-recovery)
    - [21.51 Recovery Observability Validation](#2151-recovery-observability-validation)
    - [21.52 Recovery Observability Evidence](#2152-recovery-observability-evidence)
    - [21.53 Recovery Observability Guarantees](#2153-recovery-observability-guarantees)

[22. Recovery Objectives and Service-Level Expectations](#22-recovery-objectives-and-service-level-expectations)
    - [22.1 Recovery Objectives](#221-recovery-objectives)
    - [22.2 Recovery Point Objective](#222-recovery-point-objective)
    - [22.3 RPO by Architectural Boundary](#223-rpo-by-architectural-boundary)
    - [22.4 Zero Data Loss](#224-zero-data-loss)
    - [22.5 Logical Versus Physical RPO](#225-logical-versus-physical-rpo)
    - [22.6 Consumer-Visible RPO](#226-consumer-visible-rpo)
    - [22.7 Recovery Time Objective](#227-recovery-time-objective)
    - [22.8 Component RTO](#228-component-rto)
    - [22.9 Processing RTO](#229-processing-rto)
    - [22.10 Data Product RTO](#2210-data-product-rto)
    - [22.11 End-to-End RTO](#2211-end-to-end-rto)
    - [22.12 Detection Time](#2212-detection-time)
    - [22.13 Intervention Delay](#2213-intervention-delay)
    - [22.14 Technical Restoration Time](#2214-technical-restoration-time)
    - [22.15 Catch-Up Time](#2215-catch-up-time)
    - [22.16 Rebuild Time](#2216-rebuild-time)
    - [22.17 Validation Time](#2217-validation-time)
    - [22.18 Rollback Recovery Time](#2218-rollback-recovery-time)
    - [22.19 Availability](#2219-availability)
    - [22.20 Reliability Versus Availability](#2220-reliability-versus-availability)
    - [22.21 High Availability](#2221-high-availability)
    - [22.22 Laboratory Availability](#2222-laboratory-availability)
    - [22.23 Analytical Availability](#2223-analytical-availability)
    - [22.24 Freshness](#2224-freshness)
    - [22.25 Freshness Objective](#2225-freshness-objective)
    - [22.26 Freshness During Failure](#2226-freshness-during-failure)
    - [22.27 Freshness Recovery](#2227-freshness-recovery)
    - [22.28 Processing Latency](#2228-processing-latency)
    - [22.29 End-to-End Latency](#2229-end-to-end-latency)
    - [22.30 Latency Percentiles](#2230-latency-percentiles)
    - [22.31 Availability Objective](#2231-availability-objective)
    - [22.32 Error Budget](#2232-error-budget)
    - [22.33 RPO and Retention](#2233-rpo-and-retention)
    - [22.34 RTO and Capacity](#2234-rto-and-capacity)
    - [22.35 RTO and Data Volume](#2235-rto-and-data-volume)
    - [22.36 RTO and Workload](#2236-rto-and-workload)
    - [22.37 RTO and Validation Depth](#2237-rto-and-validation-depth)
    - [22.38 Recovery Objective Trade-Offs](#2238-recovery-objective-trade-offs)
    - [22.39 Recovery Objective Hierarchy](#2239-recovery-objective-hierarchy)
    - [22.40 Data Criticality](#2240-data-criticality)
    - [22.41 Recovery Objective Ownership](#2241-recovery-objective-ownership)
    - [22.42 Laboratory Measurement](#2242-laboratory-measurement)
    - [22.43 Observed Versus Target](#2243-observed-versus-target)
    - [22.44 Measured Recovery Baseline](#2244-measured-recovery-baseline)
    - [22.45 No Placeholder Publication](#2245-no-placeholder-publication)
    - [22.46 Recovery Objective Evolution](#2246-recovery-objective-evolution)
    - [22.47 Objective Regression](#2247-objective-regression)
    - [22.48 Objective Validation](#2248-objective-validation)
    - [22.49 Objective Evidence](#2249-objective-evidence)
    - [22.50 Enterprise RPO and RTO](#2250-enterprise-rpo-and-rto)
    - [22.51 Recovery Objective Test Scenarios](#2251-recovery-objective-test-scenarios)
    - [22.52 Recovery Objectives and Service-Level Guarantees](#2252-recovery-objectives-and-service-level-guarantees)

[23. Availability, High Availability, and Disaster Recovery](#23-availability-high-availability-and-disaster-recovery)
    - [23.1 Availability](#231-availability)
    - [23.2 Component Availability](#232-component-availability)
    - [23.3 Processing Availability](#233-processing-availability)
    - [23.4 Analytical Availability](#234-analytical-availability)
    - [23.5 Availability and Freshness](#235-availability-and-freshness)
    - [23.6 Availability and Correctness](#236-availability-and-correctness)
    - [23.7 Availability and Partial Failure](#237-availability-and-partial-failure)
    - [23.8 High Availability](#238-high-availability)
    - [23.9 High Availability Objective](#239-high-availability-objective)
    - [23.10 HA and State Replication](#2310-ha-and-state-replication)
    - [23.11 HA and Failure Domains](#2311-ha-and-failure-domains)
    - [23.12 HA and Automatic Failover](#2312-ha-and-automatic-failover)
    - [23.13 HA and Kafka](#2313-ha-and-kafka)
    - [23.14 HA and SQL Server](#2314-ha-and-sql-server)
    - [23.15 HA and MinIO](#2315-ha-and-minio)
    - [23.16 HA and Processing Workers](#2316-ha-and-processing-workers)
    - [23.17 HA and Airflow](#2317-ha-and-airflow)
    - [23.18 HA and Observability](#2318-ha-and-observability)
    - [23.19 HA and Security Dependencies](#2319-ha-and-security-dependencies)
    - [23.20 Recoverability](#2320-recoverability)
    - [23.21 Recoverability Without Redundancy](#2321-recoverability-without-redundancy)
    - [23.22 Disaster](#2322-disaster)
    - [23.23 Disaster Recovery](#2323-disaster-recovery)
    - [23.24 DR Recovery Sequence](#2324-dr-recovery-sequence)
    - [23.25 DR and Backup](#2325-dr-and-backup)
    - [23.26 Backup Restore Validation](#2326-backup-restore-validation)
    - [23.27 DR and Historical Catch-Up](#2327-dr-and-historical-catch-up)
    - [23.28 DR and RPO](#2328-dr-and-rpo)
    - [23.29 DR and RTO](#2329-dr-and-rto)
    - [23.30 DR and Recovery Location](#2330-dr-and-recovery-location)
    - [23.31 Off-Host Backup](#2331-off-host-backup)
    - [23.32 Cross-Region Disaster Recovery](#2332-cross-region-disaster-recovery)
    - [23.33 DR and Certified Gold](#2333-dr-and-certified-gold)
    - [23.34 DR and Security](#2334-dr-and-security)
    - [23.35 DR and Encryption Keys](#2335-dr-and-encryption-keys)
    - [23.36 DR and Configuration](#2336-dr-and-configuration)
    - [23.37 DR and Metadata](#2337-dr-and-metadata)
    - [23.38 DR and Observability](#2338-dr-and-observability)
    - [23.39 DR and Documentation](#2339-dr-and-documentation)
    - [23.40 DR Runbook](#2340-dr-runbook)
    - [23.41 DR Testing](#2341-dr-testing)
    - [23.42 Full Laboratory Recovery Test](#2342-full-laboratory-recovery-test)
    - [23.43 Host-Loss Limitation](#2343-host-loss-limitation)
    - [23.44 Enterprise HA Evolution](#2344-enterprise-ha-evolution)
    - [23.45 Enterprise DR Evolution](#2345-enterprise-dr-evolution)
    - [23.46 HA/DR Cost and Complexity](#2346-hadr-cost-and-complexity)
    - [23.47 Availability Claims](#2347-availability-claims)
    - [23.48 DR Claims](#2348-dr-claims)
    - [23.49 Availability and DR Validation](#2349-availability-and-dr-validation)
    - [23.50 Availability, HA, and DR Evidence](#2350-availability-ha-and-dr-evidence)
    - [23.51 Availability, High Availability, and Disaster Recovery Guarantees](#2351-availability-high-availability-and-disaster-recovery-guarantees)

[24. Laboratory and Enterprise Reliability Boundaries](#24-laboratory-and-enterprise-reliability-boundaries)
    - [24.1 Laboratory Reliability Purpose](#241-laboratory-reliability-purpose)
    - [24.2 Laboratory Physical Topology](#242-laboratory-physical-topology)
    - [24.3 Single-Host Failure Domain](#243-single-host-failure-domain)
    - [24.4 Logical Independence](#244-logical-independence)
    - [24.5 Laboratory Durability](#245-laboratory-durability)
    - [24.6 Laboratory Restartability](#246-laboratory-restartability)
    - [24.7 Laboratory Retry and Redelivery](#247-laboratory-retry-and-redelivery)
    - [24.8 Laboratory Replay](#248-laboratory-replay)
    - [24.9 Laboratory Reprocessing](#249-laboratory-reprocessing)
    - [24.10 Laboratory Backfill](#2410-laboratory-backfill)
    - [24.11 Laboratory Rebuild](#2411-laboratory-rebuild)
    - [24.12 Laboratory Backlog Recovery](#2412-laboratory-backlog-recovery)
    - [24.13 Laboratory Failure Isolation](#2413-laboratory-failure-isolation)
    - [24.14 Laboratory Poison-Record Handling](#2414-laboratory-poison-record-handling)
    - [24.15 Laboratory Certified Gold Protection](#2415-laboratory-certified-gold-protection)
    - [24.16 Laboratory Publication Atomicity](#2416-laboratory-publication-atomicity)
    - [24.17 Laboratory RPO Evidence](#2417-laboratory-rpo-evidence)
    - [24.18 Laboratory RTO Evidence](#2418-laboratory-rto-evidence)
    - [24.19 Laboratory Availability](#2419-laboratory-availability)
    - [24.20 Laboratory High Availability Boundary](#2420-laboratory-high-availability-boundary)
    - [24.21 Laboratory Disaster Recovery Boundary](#2421-laboratory-disaster-recovery-boundary)
    - [24.22 Off-Host Recovery Evolution](#2422-off-host-recovery-evolution)
    - [24.23 Enterprise Physical Distribution](#2423-enterprise-physical-distribution)
    - [24.24 Enterprise Kafka Reliability](#2424-enterprise-kafka-reliability)
    - [24.25 Enterprise SQL Server Reliability](#2425-enterprise-sql-server-reliability)
    - [24.26 Enterprise Object-Storage Reliability](#2426-enterprise-object-storage-reliability)
    - [24.27 Enterprise Processing Reliability](#2427-enterprise-processing-reliability)
    - [24.28 Enterprise Orchestration Reliability](#2428-enterprise-orchestration-reliability)
    - [24.29 Enterprise Observability Reliability](#2429-enterprise-observability-reliability)
    - [24.30 Enterprise Backup Strategy](#2430-enterprise-backup-strategy)
    - [24.31 Enterprise Recovery Automation](#2431-enterprise-recovery-automation)
    - [24.32 Enterprise Capacity Headroom](#2432-enterprise-capacity-headroom)
    - [24.33 Enterprise Recovery Objectives](#2433-enterprise-recovery-objectives)
    - [24.34 Mechanism Substitution](#2434-mechanism-substitution)
    - [24.35 Mechanism Strengthening](#2435-mechanism-strengthening)
    - [24.36 Reliability Portability](#2436-reliability-portability)
    - [24.37 Laboratory Evidence Boundaries](#2437-laboratory-evidence-boundaries)
    - [24.38 Laboratory Versus Enterprise Claims](#2438-laboratory-versus-enterprise-claims)
    - [24.39 Enterprise Gap Documentation](#2439-enterprise-gap-documentation)
    - [24.40 Avoiding Reliability Theater](#2440-avoiding-reliability-theater)
    - [24.41 Evidence-Driven Enterprise Evolution](#2441-evidence-driven-enterprise-evolution)
    - [24.42 Reliability ADRs](#2442-reliability-adrs)
    - [24.43 Laboratory-to-Enterprise Validation](#2443-laboratory-to-enterprise-validation)
    - [24.44 Reliability Maturity Progression](#2444-reliability-maturity-progression)
    - [24.45 Version 1 Reliability Baseline](#2445-version-1-reliability-baseline)
    - [24.46 Laboratory and Enterprise Reliability Validation](#2446-laboratory-and-enterprise-reliability-validation)
    - [24.47 Laboratory and Enterprise Reliability Evidence](#2447-laboratory-and-enterprise-reliability-evidence)
    - [24.48 Laboratory and Enterprise Reliability Guarantees](#2448-laboratory-and-enterprise-reliability-guarantees)

[25. Reliability and Recovery Guarantees](#25-reliability-and-recovery-guarantees)
    - [25.1 Failure Is Expected](#251-failure-is-expected)
    - [25.2 Durable State Precedes Progress](#252-durable-state-precedes-progress)
    - [25.3 Restartability](#253-restartability)
    - [25.4 Idempotent Recovery](#254-idempotent-recovery)
    - [25.5 Explicit Processing Progress](#255-explicit-processing-progress)
    - [25.6 Failure Classification](#256-failure-classification)
    - [25.7 Failure Isolation](#257-failure-isolation)
    - [25.8 No Silent Loss](#258-no-silent-loss)
    - [25.9 No Silent Corruption](#259-no-silent-corruption)
    - [25.10 Bounded Retry](#2510-bounded-retry)
    - [25.11 Persistent Failure Handling](#2511-persistent-failure-handling)
    - [25.12 Quarantine Is Governed State](#2512-quarantine-is-governed-state)
    - [25.13 Backpressure Before Loss](#2513-backpressure-before-loss)
    - [25.14 Recovery Source Selection](#2514-recovery-source-selection)
    - [25.15 Latest Appropriate Trustworthy Boundary](#2515-latest-appropriate-trustworthy-boundary)
    - [25.16 Recovery Source Hierarchy](#2516-recovery-source-hierarchy)
    - [25.17 Replay](#2517-replay)
    - [25.18 Reprocessing](#2518-reprocessing)
    - [25.19 Backfill](#2519-backfill)
    - [25.20 Rebuild](#2520-rebuild)
    - [25.21 Historical Recoverability](#2521-historical-recoverability)
    - [25.22 Historical Reproduction and Restatement](#2522-historical-reproduction-and-restatement)
    - [25.23 Recovery and Current Governance](#2523-recovery-and-current-governance)
    - [25.24 Backlog Recovery](#2524-backlog-recovery)
    - [25.25 Recovery Capacity](#2525-recovery-capacity)
    - [25.26 Recovery Window Protection](#2526-recovery-window-protection)
    - [25.27 Certified Gold Protection](#2527-certified-gold-protection)
    - [25.28 Fail-Safe Publication](#2528-fail-safe-publication)
    - [25.29 Rollback](#2529-rollback)
    - [25.30 No Known-Good State](#2530-no-known-good-state)
    - [25.31 Recovery Is Multi-Dimensional](#2531-recovery-is-multi-dimensional)
    - [25.32 Recovery Validation](#2532-recovery-validation)
    - [25.33 Recovery Evidence](#2533-recovery-evidence)
    - [25.34 Recovery Testing](#2534-recovery-testing)
    - [25.35 Evidence Can Change Architecture](#2535-evidence-can-change-architecture)
    - [25.36 RPO](#2536-rpo)
    - [25.37 RTO](#2537-rto)
    - [25.38 Availability and Freshness](#2538-availability-and-freshness)
    - [25.39 Reliability and High Availability](#2539-reliability-and-high-availability)
    - [25.40 Disaster Recovery](#2540-disaster-recovery)
    - [25.41 Failure-Domain Independence](#2541-failure-domain-independence)
    - [25.42 Recovery Observability](#2542-recovery-observability)
    - [25.43 Recovery Convergence](#2543-recovery-convergence)
    - [25.44 Reliability Claims](#2544-reliability-claims)
    - [25.45 Laboratory Boundary](#2545-laboratory-boundary)
    - [25.46 Enterprise Evolution](#2546-enterprise-evolution)
    - [25.47 Reliability Theater Is Rejected](#2547-reliability-theater-is-rejected)
    - [25.48 Closing Principle](#2548-closing-principle)

---

## 1. Purpose

The purpose of this document is to define the **reliability and recovery architecture** of the **Data Engineering layer** within the **Atlas Engineering — Enterprise Data Platform**.

This document establishes how the platform detects, contains, tolerates, and recovers from failures while preserving data integrity, processing correctness, recoverability, and governed analytical availability.

It defines the architectural principles and strategies required to address:

- component and dependency failures;
- transient and persistent processing failures;
- retries and redelivery;
- idempotent restartability;
- checkpoints and processing progress;
- backlog accumulation and catch-up;
- replay;
- reprocessing;
- backfill;
- rebuild;
- recovery-source selection;
- partial failure and failure isolation;
- poison records;
- Certified Gold availability and rollback;
- recovery across historical versions;
- Recovery Point Objective (RPO);
- Recovery Time Objective (RTO);
- availability, high availability, and disaster recovery;
- recovery observability;
- recovery validation and evidence.

The document complements the broader **Data Engineering Architecture** and **Data Flow and Processing** documentation.

The **Data Engineering Architecture** defines the platform's high-level structure, responsibilities, boundaries, and normal end-to-end flow.

**Data Flow and Processing** defines how data moves and is processed across the platform, including the processing semantics required for idempotency, replayability, certification, and reconstruction.

This document focuses specifically on the behavior of the platform when normal processing is interrupted, degraded, invalidated, or must be reconstructed.

The governing principle is:

**Failure Is Expected → Durable State Must Be Known → Recovery Must Be Controlled → Correctness Must Be Revalidated**

A component returning to an operational state does not by itself demonstrate that the data pipeline has recovered correctly.

Atlas Engineering therefore distinguishes between:

**Component Recovery**
→ the affected technology or service becomes operational again.

**Processing Recovery**
→ interrupted or accumulated processing resumes and reaches a controlled processing state.

**Data Recovery**
→ required data is restored, replayed, reprocessed, or rebuilt from an appropriate recovery source.

**Correctness Recovery**
→ quality, reconciliation, certification, lineage, and other applicable controls demonstrate that the recovered data is valid for its intended use.

Recovery is considered complete only when the level of recovery required by the affected capability has been demonstrated.

The Version 1 laboratory is designed to validate representative failure and recovery behavior under controlled conditions. Laboratory results must remain bounded by the topology, workload, retention, implementation, and failure scenarios actually tested and must not be represented as production-grade availability or disaster-recovery guarantees without supporting evidence.

---

## 2. Reliability and Recovery Context

Atlas Engineering is a distributed data platform composed of independent technologies, processing stages, durable stores, and governed publication boundaries.

A normal end-to-end flow may depend on:

**AtlasCommerce → SQL Server CDC → Debezium → Kafka → Bronze → Silver → Gold → Certification → Certified Gold → Power BI**

Each boundary introduces different failure modes, durability characteristics, recovery mechanisms, and operational dependencies.

A failure may therefore affect:

- one component;
- one processing stage;
- one data partition;
- one execution;
- one event or group of events;
- one data product;
- one dependency;
- several downstream layers;
- the entire analytical flow.

The platform must not assume that failures occur only as complete service outages.

A component may remain technically available while:

- processing has stopped;
- processing is delayed;
- consumer lag is increasing;
- a dependency is unavailable;
- a subset of records repeatedly fails;
- checkpoints no longer advance;
- downstream data becomes stale;
- a candidate Gold version cannot be certified;
- analytical consumers continue seeing an older certified version.

Reliability must therefore be evaluated from both:

**Service Perspective**
→ are the required platform components operational?

and:

**Data Perspective**
→ is governed data continuing to move, remain recoverable, and reach the expected trustworthy state?

### 2.1 Failure as an Expected Condition

Atlas Engineering treats failure as an expected operational condition rather than an exceptional architectural event.

The platform must be designed with the assumption that, at some point:

- a process will stop;
- a dependency will become unavailable;
- a connection will fail;
- a credential will expire or become invalid;
- an event will be delivered more than once;
- a record will fail repeatedly;
- processing will fall behind;
- a deployment will interrupt execution;
- a transformation defect will require historical correction;
- a downstream state will need to be rebuilt.

The objective is not to design a platform in which failure never occurs.

The objective is to ensure that failure does not automatically produce uncontrolled data loss, corruption, duplication, inconsistent publication, or irreversible processing state.

### 2.2 Reliability

Reliability is the ability of the platform to continue producing or eventually restore correct governed behavior despite expected failures and interruptions.

Reliability includes properties such as:

- durable intermediate state;
- restartability;
- retry capability;
- controlled redelivery;
- idempotent processing;
- checkpoint management;
- failure isolation;
- backlog tolerance;
- replayability;
- rebuild capability;
- recoverable publication;
- observable processing progress.

Reliability does not mean that every component must remain continuously available.

A platform may tolerate temporary interruption while still remaining reliable if it preserves sufficient state to recover correctly afterward.

### 2.3 Recovery

Recovery is the controlled process of restoring the required platform capability after failure, interruption, invalidation, or loss of state.

Depending on the failure, recovery may require:

- restarting a component;
- reconnecting to a dependency;
- retrying an operation;
- redelivering an event;
- resuming from a checkpoint;
- processing accumulated backlog;
- replaying retained events;
- reprocessing historical data;
- executing a backfill;
- rebuilding a derived layer;
- restoring from backup;
- rolling back a published analytical version.

The recovery mechanism must be selected according to the affected state and the recovery objective.

Not every failure requires replay.

Not every data correction requires rebuild.

Not every component restart constitutes recovery.

### 2.4 Recovery Is State-Aware

Recovery decisions must be based on the state that remains durable and trustworthy after the failure.

The platform must determine:

- what state was successfully persisted;
- what processing progress was committed;
- what data may be delivered again;
- what data may not have been processed;
- which downstream outputs were produced;
- which outputs remain trustworthy;
- which recovery sources remain available;
- which historical definitions are required to interpret those sources.

Recovery must not depend on assumptions about where processing probably stopped.

Durable state and observable progress must provide the basis for the decision.

### 2.5 Failure Propagation

A failure in one component may propagate into downstream symptoms without every downstream component failing technically.

For example:

**Debezium unavailable**
→ no new Kafka events  
→ Bronze receives no new data  
→ Silver stops advancing  
→ Gold remains unchanged  
→ Certified Gold remains available but increasingly stale.

In this scenario, Power BI may continue operating successfully while the analytical platform is no longer current.

Another example:

**Silver transformation failure**
→ Bronze continues ingesting  
→ Kafka continues operating  
→ source capture remains healthy  
→ Silver checkpoint stops advancing  
→ Gold receives no new valid input.

The architecture must therefore distinguish the **origin of failure** from its **downstream effects**.

### 2.6 Partial Failure

Distributed processing allows some parts of the platform to remain healthy while another part is degraded or unavailable.

Examples include:

- one Kafka partition accumulating lag;
- one entity failing transformation while others continue;
- one Gold data product failing certification;
- one dependency becoming unavailable;
- one poison record repeatedly failing;
- one analytical product remaining on its previous certified version.

Where safe and technically supported, the platform should isolate failures rather than unnecessarily stop unrelated processing.

Isolation must not allow invalid or incomplete state to cross governed boundaries.

### 2.7 Durable State

Recovery depends on knowing which platform states are durable.

Representative durable states may include:

- SQL Server source data;
- CDC history while retained;
- Kafka events while retained;
- Bronze historical data;
- Silver persisted state;
- Gold candidate versions;
- Certified Gold versions;
- checkpoints and processing metadata;
- backups and archives where implemented.

These states do not have identical recovery value.

Their suitability depends on:

- retention;
- completeness;
- integrity;
- interpretability;
- processing objective;
- historical version availability;
- trust.

The recovery-source hierarchy is defined later in this document.

### 2.8 Derived State

Silver, Gold, and Certified Gold contain states derived from earlier platform inputs and processing definitions.

Derived state should be reproducible where the required source data, processing definitions, metadata, and historical interpretation remain available.

This does not mean every derived state must always be rebuilt from the earliest possible source.

Recovery should use the most appropriate trustworthy source for the required objective.

The architecture must preserve enough information to explain how a recovered derived state was produced.

### 2.9 Recovery and Data Correctness

Technical recovery and data correctness are separate concerns.

For example:

**Kafka Consumer Restarted**
→ component recovery may be complete.

But if events were processed again:

→ duplicate handling must still be correct.

If processing was interrupted:

→ checkpoint continuity must still be validated.

If downstream data changed:

→ quality and reconciliation may still be required.

If Gold was rebuilt:

→ certification must still occur before publication.

The platform must therefore validate the consequences of recovery, not only the success of the recovery operation itself.

### 2.10 Recovery and Governed Publication

Certified Gold provides a controlled analytical availability boundary.

A failure in upstream processing does not automatically require removal of the last known-good certified version.

Where appropriate:

**Upstream Processing Failure**
→ new candidate unavailable or invalid  
→ certification does not advance  
→ previous Certified Gold remains consumer-visible.

This allows the platform to distinguish:

**Freshness Degradation**

from:

**Loss of Analytical Availability**

A stale but known-good certified product may be preferable to publishing a newer unvalidated state.

### 2.11 Recovery and Historical Interpretation

Historical recovery may require more than historical data.

Correct reconstruction may also depend on historical:

- event contracts;
- schemas;
- transformation logic;
- quality rules;
- reconciliation definitions;
- Gold definitions;
- metadata;
- certification context.

Retaining data without retaining the information required to interpret it may create an unusable recovery source.

Recovery architecture must therefore remain aligned with versioning, lineage, and metadata governance.

### 2.12 Recovery and Observability

A recoverable platform must make recovery-relevant state observable.

The platform should be capable of determining, where applicable:

- whether a component is available;
- whether processing is advancing;
- current checkpoint or progress;
- consumer lag;
- backlog size;
- processing latency;
- retry activity;
- persistent failures;
- recovery execution state;
- candidate certification state;
- Certified Gold freshness.

Observability does not perform recovery.

It provides the information required to detect failure, select recovery actions, monitor progress, and validate the resulting state.

Detailed observability requirements are defined in the specialized **Observability** architecture document.

### 2.13 Recovery and Security

Recovery must preserve applicable security and governance controls.

Recovery activity must not become justification for:

- unrestricted credentials;
- permanent elevated access;
- bypassed authorization;
- disabled transport protection;
- uncontrolled sensitive-data exposure;
- restoration of revoked credentials;
- publication without required validation.

Security-specific recovery requirements are defined in **Security and Governance**.

This document focuses on reliability and data-processing recovery while preserving those security boundaries.

### 2.14 Recovery and Evidence

Recovery claims must be supported by observed behavior.

Representative evidence may demonstrate:

- initial state;
- injected or observed failure;
- affected processing boundary;
- preserved durable state;
- selected recovery source;
- recovery action;
- backlog behavior;
- checkpoint progression;
- resulting data state;
- quality and reconciliation results;
- certification state;
- final consumer-visible state;
- elapsed recovery time.

Evidence allows the project to distinguish between:

**Recovery Designed**

and:

**Recovery Demonstrated**

Version 1 should prefer measured laboratory behavior over unsupported production-grade assumptions.

### 2.15 Reliability Context Principle

The Atlas Engineering reliability model is based on the following progression:

**Failure Occurs**
→ identify the affected boundary  
→ determine preserved durable state  
→ determine trustworthy recovery source  
→ select the appropriate recovery mechanism  
→ resume or reconstruct processing  
→ validate resulting data state  
→ restore governed availability  
→ preserve evidence.

The platform must therefore be designed not merely to restart after failure, but to **recover predictably, explainably, and verifiably**.

---

## 3. Reliability Principles

Atlas Engineering reliability is based on architectural properties that allow the platform to tolerate interruption, preserve recoverable state, resume processing, reconstruct derived data, and validate the resulting state.

Reliability must not depend on the assumption that every component remains continuously available or that every execution completes successfully on the first attempt.

The governing model is:

**Durability → Restartability → Idempotency → Isolation → Recoverability → Validation**

### 3.1 Failure Is Expected

Failures are expected during the operational life of the platform.

Possible causes include:

- service interruption;
- dependency unavailability;
- network failure;
- credential failure;
- resource exhaustion;
- deployment interruption;
- malformed or unexpected data;
- processing defects;
- infrastructure failure;
- configuration errors.

The architecture must therefore define behavior for failure rather than treating recovery as an exceptional manual activity designed only after an incident occurs.

### 3.2 Preserve Before Advancing

Processing progress must not advance beyond the state that the platform can safely recover.

Where processing depends on durable persistence, the relevant state must be successfully persisted before progress is considered committed.

The principle is:

**Persist Required State → Confirm Success → Advance Progress**

This reduces the risk of acknowledging work that cannot later be reconstructed.

The exact persistence and checkpoint mechanism may vary by component and processing stage.

### 3.3 Restartability

Processing components should be capable of restarting without requiring uncontrolled manual reconstruction.

After interruption, a component should be able to determine, where applicable:

- the last committed processing state;
- which work remains incomplete;
- which input may be delivered again;
- which output may already exist;
- where processing can safely resume.

Restartability depends on durable state and deterministic recovery rules rather than assumptions about the last operation executed in memory.

### 3.4 Idempotency

Where retries, redelivery, replay, or restart can cause the same logical input to be processed more than once, processing must be designed so that repeated execution does not create incorrect business results.

The governing principle is:

**Same Logical Input + Same Applicable Processing Definition → Same Intended Business Result**

Idempotency may be implemented differently across layers.

Possible mechanisms include:

- stable business keys;
- event identifiers;
- deterministic merge logic;
- deduplication;
- version-aware processing;
- controlled overwrite of derived state;
- transactional persistence where supported.

Idempotency does not mean that an operation physically executes only once.

It means repeated execution does not create an unintended additional business effect.

### 3.5 At-Least-Once Delivery Is Not a Defect

Atlas Engineering does not require the architecture to pretend that every distributed boundary provides exactly-once physical delivery.

An event may legitimately be delivered or processed more than once because of:

- retry;
- consumer restart;
- offset recovery;
- replay;
- network interruption;
- acknowledgment failure.

The downstream design must tolerate the delivery semantics of the selected technology.

Where delivery may be repeated, correctness is achieved through controlled progress and idempotent processing rather than by assuming duplicate delivery cannot occur.

### 3.6 No Silent Data Loss

A failure must not cause data to disappear silently from the governed processing path.

When processing cannot continue successfully, the platform should preserve enough information to determine:

- what failed;
- which input was affected;
- whether the input remains recoverable;
- whether processing progress advanced;
- what downstream state was produced;
- what remediation is required.

A record that cannot currently be processed should enter an explicit failure state where supported rather than being silently discarded.

### 3.7 No Silent Corruption

Successful technical execution does not justify accepting an incorrect data state.

Recovery mechanisms must not silently:

- duplicate business effects;
- omit required records;
- mix incompatible processing versions;
- bypass quality controls;
- bypass reconciliation;
- publish incomplete state;
- reinterpret historical data using an incompatible definition without explicit governance.

The recovered result remains subject to the correctness controls applicable to the affected layer.

### 3.8 Durable State Before Ephemeral State

Recovery architecture should prefer durable, interpretable state over transient in-memory state.

Important recovery information should not exist only in:

- process memory;
- temporary execution context;
- terminal output;
- an operator's knowledge.

Where required for recovery, state should be persisted in an appropriate durable mechanism.

Examples may include:

- Kafka offsets;
- checkpoints;
- processing metadata;
- execution state;
- persisted layer state;
- certification metadata.

### 3.9 Recovery Uses Explicit Progress

Processing progress should be explicit and observable where required for safe recovery.

Relevant progress indicators may include:

- CDC capture position;
- Kafka offset;
- processing checkpoint;
- batch or execution identifier;
- watermark;
- processed business period;
- candidate version;
- certification state.

The platform should not rely solely on wall-clock time or service uptime to infer processing progress.

### 3.10 Recovery Source Must Be Trustworthy

A technically available recovery source is not automatically an appropriate recovery source.

Selection must consider:

- completeness;
- durability;
- retention;
- integrity;
- interpretability;
- applicable version;
- governance state;
- trust.

The most recent state is not necessarily the most appropriate state from which to recover.

Recovery-source strategy is defined later in this document.

### 3.11 Recovery Should Use the Appropriate Boundary

Recovery should begin from the most appropriate trustworthy boundary that can satisfy the recovery objective.

For example:

- a transient processing failure may require only retry;
- interrupted consumption may resume from a checkpoint;
- retained Kafka history may support replay;
- Bronze may support historical reconstruction;
- valid Silver may support a Gold rebuild;
- backup may be required when the necessary online history no longer exists.

Recovery from an earlier boundary than necessary may increase cost and recovery time.

Recovery from a later boundary than justified may preserve invalid state.

### 3.12 Derived State Should Be Reconstructible

Where practical, derived analytical state should be reconstructible from governed upstream state and the applicable processing definitions.

This applies particularly to:

- Silver;
- Gold;
- Certified Gold candidates.

Reconstructibility depends not only on retaining data but also on retaining the metadata, contracts, versions, and processing definitions required to interpret that data correctly.

A derived layer should not become an unexplained irreversible state merely because it has already been computed.

### 3.13 Failure Isolation

A failure should be contained to the smallest safe scope where technically practical.

The platform should avoid allowing one localized failure to unnecessarily stop unrelated processing.

Possible isolation boundaries may include:

- record;
- partition;
- entity;
- processing stage;
- data product;
- dependency.

Isolation must not allow incomplete or invalid state to cross a governed boundary.

Continuing unrelated processing is acceptable only when its correctness does not depend on the failed state.

### 3.14 Backpressure Is Preferable to Uncontrolled Loss

When downstream processing cannot keep pace with incoming data, the architecture should prefer controlled backlog or backpressure over silent data loss.

A growing backlog is an operational condition that can be observed and recovered.

Discarded or untraceable input may be impossible to reconstruct.

Backlog tolerance remains bounded by:

- retention;
- storage;
- processing capacity;
- recovery objectives;
- downstream freshness requirements.

### 3.15 Retry Must Be Bounded and Observable

Retry is appropriate for failures that may succeed without changing the underlying data or architecture.

Retries must not become infinite invisible loops.

Where implemented, retry behavior should define:

- eligible failure conditions;
- retry limit or governing policy;
- delay or backoff where appropriate;
- observability;
- terminal failure behavior.

Persistent failure must eventually become an explicit operational state requiring investigation or another recovery mechanism.

### 3.16 Recovery Must Not Bypass Governance

Recovery operations remain subject to the governance controls applicable to normal processing.

Recovery must not automatically bypass:

- access control;
- data classification;
- privacy handling;
- quality validation;
- reconciliation;
- certification;
- lineage;
- retention;
- auditability.

Urgency changes operational priority.

It does not eliminate the requirement to restore a governed state.

### 3.17 Publication Must Fail Safe

Failure in candidate processing or certification must not automatically replace a known-good consumer-visible state.

The governing behavior is:

**Candidate Valid**
→ certify  
→ publish.

**Candidate Invalid or Incomplete**
→ do not publish  
→ preserve the previous known-good Certified Gold version where available.

This prevents processing failure from automatically becoming consumer-visible data failure.

### 3.18 Recovery Must Be Observable

Recovery must expose enough information to determine:

- what is being recovered;
- which source is being used;
- where processing resumed;
- whether backlog is decreasing;
- whether retries continue;
- whether checkpoints advance;
- whether failures remain;
- whether downstream state is current;
- whether certification has resumed.

An operator should not need to infer recovery solely from the fact that a process is running.

### 3.19 Recovery Must Be Validated

Recovery is not complete when the recovery command succeeds.

The resulting state must be validated according to the affected capability.

Validation may include:

- processing progress;
- expected record counts;
- deduplication;
- quality;
- reconciliation;
- lineage;
- certification;
- consumer-visible freshness;
- access boundaries;
- security state.

The required validation depth depends on the recovery scenario.

### 3.20 Recovery Must Be Evidence-Based

Representative recovery scenarios should produce evidence demonstrating:

- failure;
- preserved state;
- selected recovery mechanism;
- recovery execution;
- resulting state;
- validation;
- elapsed time where relevant;
- conclusion.

This allows reliability claims to be based on observed behavior rather than architectural intention alone.

### 3.21 Reliability Does Not Equal High Availability

A reliable platform does not necessarily provide continuous availability.

A component may be temporarily unavailable while the architecture still preserves:

- durable state;
- restartability;
- recoverability;
- correctness;
- controlled analytical availability.

High Availability (HA) addresses reduction of service interruption through redundancy and failover.

Reliability is broader and includes correct behavior before, during, and after failure.

Version 1 must not represent restartability or recoverability as equivalent to enterprise High Availability.

### 3.22 Recovery Objectives Must Be Measured

Recovery Point Objective (RPO) and Recovery Time Objective (RTO) must not be invented solely to make the architecture appear production-ready.

Where formal objectives are required, they should be based on:

- business requirements;
- technical capabilities;
- retention;
- architecture;
- measured recovery behavior.

Version 1 should first measure representative recovery scenarios and preserve the results as evidence.

Measured laboratory recovery time is not automatically an enterprise RTO commitment.

### 3.23 Reliability Evolves With Evidence

Reliability architecture may evolve when testing demonstrates that an assumption is incorrect or insufficient.

For example:

**Observed**
→ backlog recovery is slower than expected.

Possible responses may include:

- increasing processing capacity;
- changing partitioning;
- changing checkpoint strategy;
- changing retention;
- improving transformation performance;
- revising the recovery procedure.

Evidence must be allowed to influence architecture.

Reliability claims must not be protected from contradictory test results.

### 3.24 Reliability Principle

The Atlas Engineering reliability model can be summarized as:

**Preserve Durable State**
→ **Advance Progress Explicitly**
→ **Expect Redelivery**
→ **Process Idempotently**
→ **Isolate Failure**
→ **Recover From a Trustworthy Boundary**
→ **Revalidate Correctness**
→ **Restore Governed Availability**
→ **Preserve Evidence**

Reliability is demonstrated when the platform can fail, recover, and explain why the resulting state remains trustworthy.

---

## 4. Failure Domains and Failure Classification

Atlas Engineering must classify failures according to the architectural boundary affected and the consequence for processing, data state, recoverability, and governed analytical availability.

A failure should not be classified solely by the technology that reported it.

The same technical symptom may have different architectural consequences depending on:

- affected component;
- affected processing stage;
- durable state already preserved;
- processing progress;
- backlog;
- downstream dependencies;
- data-product impact;
- consumer-visible state;
- available recovery sources.

The governing model is:

**Failure Location → Affected State → Processing Impact → Downstream Impact → Recovery Scope**

Classification supports consistent decisions about:

- retry;
- restart;
- isolation;
- replay;
- reprocessing;
- backfill;
- rebuild;
- rollback;
- escalation;
- validation.

### 4.1 Failure Domain

A failure domain is the smallest architectural boundary within which a failure can occur and produce a meaningful reliability impact.

Representative failure domains include:

- source database;
- CDC;
- Debezium;
- Kafka;
- Bronze;
- Silver;
- Gold;
- certification;
- Certified Gold publication;
- orchestration;
- storage;
- network;
- credentials and authentication;
- observability dependencies;
- infrastructure.

Failure domains help determine both blast radius and recovery responsibility.

A physical component may participate in more than one logical failure domain.

### 4.2 Failure Scope

Failure scope describes how much of the platform is affected.

Representative scopes include:

**Record**
→ one logical input cannot be processed.

**Partition**
→ processing associated with one Kafka partition or equivalent processing unit is affected.

**Entity**
→ one business entity or dataset cannot advance.

**Processing Stage**
→ one architectural layer cannot process new work.

**Data Product**
→ one Gold or Certified Gold product cannot advance.

**Dependency**
→ several components are affected by one unavailable shared dependency.

**Platform**
→ a broad failure prevents most or all data processing.

Recovery should target the smallest safe scope capable of restoring correct behavior.

### 4.3 Transient Failure

A transient failure is expected to resolve without changing the underlying business data or processing definition.

Examples may include:

- temporary network interruption;
- temporary dependency unavailability;
- short-lived resource contention;
- temporary authentication-service unavailability;
- service startup ordering;
- temporary storage unavailability.

Transient failures are typical candidates for controlled retry.

Retry must remain bounded and observable.

A failure that continues beyond the defined retry policy must transition into an explicit persistent failure state.

### 4.4 Persistent Failure

A persistent failure does not resolve through ordinary retry.

Examples may include:

- malformed data;
- incompatible schema;
- invalid configuration;
- revoked or incorrect credential;
- insufficient permission;
- unavailable required historical version;
- transformation defect;
- storage-capacity exhaustion;
- repeated quality failure.

Persistent failures require investigation, remediation, isolation, or a different recovery mechanism.

Continuing to retry indefinitely does not constitute recovery.

### 4.5 Data-Specific Failure

A data-specific failure is associated with one record, event, entity, partition, or bounded subset of data while the surrounding processing capability may remain healthy.

Examples include:

- invalid field value;
- unsupported event structure;
- malformed payload;
- violated transformation assumption;
- unresolved business key;
- unexpected null;
- invalid reference relationship.

Where safe, the affected data should be isolated while unrelated valid processing continues.

The failed data must remain traceable and recoverable.

### 4.6 Processing Failure

A processing failure prevents a transformation or processing stage from advancing correctly.

Examples include:

- application exception;
- failed transformation;
- invalid processing configuration;
- checkpoint failure;
- dependency failure;
- incompatible processing version;
- resource exhaustion.

A processing failure may affect one execution or an entire stage.

Recovery depends on whether the required input and last committed progress remain available.

### 4.7 Dependency Failure

A dependency failure occurs when a component remains operational but cannot perform its responsibility because another required service or resource is unavailable.

Examples include:

- Debezium unable to reach SQL Server;
- Bronze unable to reach Kafka;
- Silver unable to access Bronze storage;
- Gold unable to access Silver;
- Airflow unable to invoke a required processing job;
- Power BI unable to reach Certified Gold.

The component reporting the error is not necessarily the origin of the failure.

Root-cause analysis must distinguish:

**Affected Component**

from:

**Failed Dependency**

### 4.8 Source Failure

A source failure affects AtlasCommerce or the SQL Server capabilities required for data capture.

Possible examples include:

- SQL Server unavailable;
- AtlasCommerce database unavailable;
- transaction log or CDC-related issue;
- CDC disabled unexpectedly;
- required CDC object unavailable;
- source permission failure;
- source storage problem.

A source failure may prevent new changes from entering the analytical pipeline while downstream historical data remains available.

Recovery must determine whether the required source changes remain capturable after service restoration.

### 4.9 CDC Failure

CDC failure affects the platform's ability to preserve the ordered source-change history required by Debezium.

Possible conditions include:

- capture process unavailable;
- CDC metadata unavailable;
- retention removing required history before capture;
- CDC configuration drift;
- capture latency increasing beyond safe limits.

CDC failure is particularly important because loss of required change history may alter the available recovery path.

If the missing history can no longer be captured from CDC, recovery may require another governed source such as backfill or reconstruction from an appropriate historical source.

### 4.10 Debezium Failure

Debezium failure may interrupt the transfer of captured source changes into Kafka.

Possible conditions include:

- connector stopped;
- SQL Server connectivity failure;
- Kafka connectivity failure;
- authentication failure;
- connector configuration error;
- incompatible source change;
- connector internal failure.

When the required source history remains available, Debezium recovery should resume from its durable progress rather than require full pipeline reconstruction.

The recovery procedure must validate that no required source interval was silently lost.

### 4.11 Kafka Failure

Kafka failures may affect:

- event publication;
- event availability;
- consumer progress;
- partition leadership;
- broker availability;
- retained recovery history.

The architectural impact depends on whether the required events remain durable and available.

A temporary broker interruption may cause backlog without data loss.

Loss of required retained history may change the recovery source and increase recovery scope.

Kafka availability and Kafka recoverability must therefore be evaluated separately.

### 4.12 Bronze Failure

Bronze failure may prevent raw governed events from being persisted into the historical analytical foundation.

Possible conditions include:

- consumer failure;
- storage failure;
- schema-handling failure;
- checkpoint failure;
- persistent event failure;
- processing defect.

Where Kafka retains the required events, Bronze may normally recover through controlled resumption or replay.

Bronze recovery must preserve raw event fidelity and must not create unintended duplicate business history.

### 4.13 Silver Failure

Silver failure affects standardized and conformed processing.

Possible conditions include:

- transformation defect;
- invalid schema handling;
- reference-resolution failure;
- checkpoint failure;
- storage failure;
- unexpected data condition.

Bronze may continue accumulating valid historical input while Silver is unavailable.

Recovery may therefore involve:

- restart;
- retry;
- processing accumulated backlog;
- replay from Bronze;
- reprocessing;
- rebuild of affected Silver state.

The appropriate mechanism depends on the failure and the state already persisted.

### 4.14 Gold Failure

Gold failure affects dimensional or analytical product generation.

Possible conditions include:

- transformation defect;
- invalid business rule;
- Silver dependency failure;
- quality failure;
- reconciliation failure;
- storage failure;
- candidate-generation failure.

Gold failure does not automatically invalidate the previous Certified Gold version.

Where the previous certified version remains trustworthy, analytical consumption may continue while the new candidate is investigated or rebuilt.

### 4.15 Certification Failure

Certification failure occurs when a Gold candidate does not satisfy the controls required for governed publication.

Possible causes include:

- blocking quality failure;
- reconciliation failure;
- incomplete processing;
- missing required metadata;
- lineage failure;
- invalid version state.

Certification failure is not necessarily a platform outage.

The correct behavior is generally:

**Candidate Fails**
→ do not publish  
→ preserve evidence  
→ investigate  
→ remediate  
→ revalidate.

The previous known-good Certified Gold version should remain available where appropriate.

### 4.16 Publication Failure

Publication failure occurs after a candidate has satisfied certification requirements but cannot become consumer-visible correctly.

Possible causes include:

- publication mechanism failure;
- storage failure;
- permission failure;
- atomic-switch failure;
- metadata update failure.

Publication must fail safely.

A failed publication must not leave consumers observing an uncontrolled mixture of old and new certified state.

The last known-good published version should remain identifiable.

### 4.17 Orchestration Failure

Airflow coordinates execution but is not the authoritative store of business data.

An orchestration failure may prevent scheduled or dependent processing from starting even while underlying data remains durable.

Possible conditions include:

- scheduler failure;
- worker failure;
- DAG failure;
- metadata database failure;
- dependency-state error;
- task timeout.

Recovery should distinguish:

**Orchestration State**

from:

**Data Processing State**

Rerunning orchestration must not assume that no underlying work was completed before the orchestration failure.

### 4.18 Storage Failure

Storage failure may affect one or more durable platform layers.

Possible conditions include:

- MinIO unavailable;
- disk unavailable;
- capacity exhausted;
- object write failure;
- object corruption;
- metadata inconsistency.

Recovery depends on:

- which data was affected;
- whether the write was committed;
- whether another durable source exists;
- whether the affected state is derived or authoritative;
- whether backup or reconstruction is available.

Storage failure involving an authoritative recovery source may have greater impact than failure of a fully reconstructible derived layer.

### 4.19 Network Failure

Network failure may interrupt communication while services and stored data remain otherwise healthy.

Possible effects include:

- source capture interruption;
- Kafka publication failure;
- consumer interruption;
- storage access failure;
- orchestration failure;
- analytical-consumption interruption.

Network recovery may restore connectivity without automatically restoring processing progress.

Backlog, retry state, checkpoints, and downstream freshness must still be evaluated.

### 4.20 Credential and Authentication Failure

Credential or authentication failure may interrupt a technically healthy service.

Possible causes include:

- expired credential;
- rotated credential not propagated;
- revoked credential;
- incorrect secret;
- certificate failure;
- identity configuration error.

Reliability recovery must restore legitimate service operation without weakening the security boundary.

Security-specific response to compromised credentials remains governed by **Security and Governance**.

### 4.21 Resource Exhaustion

Resource exhaustion may cause degraded processing before complete service failure.

Relevant resources include:

- CPU;
- memory;
- disk;
- storage capacity;
- connection pools;
- worker capacity;
- Kafka capacity;
- network bandwidth.

Symptoms may include:

- increasing latency;
- growing backlog;
- task timeout;
- failed writes;
- repeated restarts;
- reduced throughput.

Resource exhaustion should be detected before it becomes irreversible data loss or recovery-source expiration where practical.

### 4.22 Configuration Failure

Configuration failure occurs when implemented runtime configuration prevents the intended architecture from operating correctly.

Examples include:

- incorrect endpoint;
- invalid topic configuration;
- incorrect retention;
- wrong permission;
- invalid checkpoint location;
- incorrect schema setting;
- incompatible service configuration.

Configuration failures may survive service restart.

Recovery therefore requires correcting the configuration and validating the resulting behavior rather than repeatedly restarting the affected component.

### 4.23 Deployment Failure

A deployment may introduce interruption, incompatibility, or partially updated state.

Possible scenarios include:

- new processing version fails to start;
- only some components receive the new version;
- schema and processing versions become incompatible;
- execution stops during deployment;
- new code produces invalid output.

Deployment recovery may require:

- rollback;
- restart;
- replay;
- reprocessing;
- restoration of the previous processing version;
- rebuilding affected derived state.

Version and lineage information must allow the platform to identify which outputs were produced by which implementation.

### 4.24 Data Quality Failure

A data quality failure means the data does not satisfy an implemented quality rule.

This is distinct from a technical processing failure.

For example:

**Processing**
→ completed successfully.

**Quality Validation**
→ failed.

The correct response may be:

- quarantine;
- investigation;
- remediation;
- reprocessing;
- blocked certification.

A technically successful pipeline must not convert a quality failure into an implicit PASS.

### 4.25 Reconciliation Failure

A reconciliation failure indicates that expected quantitative or semantic consistency was not demonstrated across a processing boundary.

Examples may include:

- missing records;
- unexpected duplicates;
- count mismatch;
- amount mismatch;
- unexplained aggregate divergence.

Reconciliation failure may indicate:

- processing defect;
- incomplete recovery;
- source inconsistency;
- incorrect transformation;
- duplicate handling failure.

Where reconciliation is a blocking control, publication must not advance until the failure is resolved or explicitly governed.

### 4.26 Observability Failure

Observability failure reduces the platform's ability to detect, diagnose, monitor, or validate reliability behavior.

Examples include:

- metrics unavailable;
- logs unavailable;
- dashboards unavailable;
- alerting failure;
- missing checkpoint telemetry.

An observability failure does not necessarily stop data processing.

However, it may reduce confidence in determining whether processing and recovery remain healthy.

Critical recovery operations may require additional validation when normal observability is unavailable.

### 4.27 Compound Failure

Multiple failures may occur simultaneously or sequentially.

For example:

**Kafka Consumer Failure**
→ backlog grows  
→ storage approaches capacity  
→ retention window becomes threatened.

Or:

**Credential Rotation Failure**
→ Debezium stops  
→ CDC backlog grows  
→ required CDC history approaches expiration.

Compound failures must be evaluated according to their combined effect rather than as isolated alerts.

Recovery priority should consider whether one failure is reducing the time available to recover from another.

### 4.28 Cascading Failure

A cascading failure occurs when one failure causes additional components or processing stages to fail or degrade.

For example:

**Storage Unavailable**
→ Bronze writes fail  
→ consumer retries increase  
→ backlog grows  
→ Kafka retention risk increases  
→ downstream freshness degrades.

The architecture should reduce unnecessary cascading behavior through:

- bounded retries;
- backpressure;
- isolation;
- durable intermediate state;
- controlled failure transitions.

### 4.29 Data Loss Risk

A failure becomes a data-loss risk when the platform may lose access to required information before successful recovery.

Examples include:

- CDC history approaching retention expiration;
- Kafka events approaching retention expiration;
- failed write without another durable copy;
- corrupted authoritative state without recoverable backup.

Data-loss risk should receive higher operational priority than ordinary freshness degradation.

The platform should expose the remaining recovery window where practical.

### 4.30 Freshness Failure

A freshness failure occurs when governed analytical data remains available but no longer meets the expected recency.

For example:

**Certified Gold**
→ available and trustworthy  
→ no longer current because upstream processing is delayed.

Freshness failure must remain distinguishable from:

- data correctness failure;
- complete analytical unavailability;
- source data loss.

This distinction allows operational response to reflect actual consumer impact.

### 4.31 Correctness Failure

A correctness failure occurs when available data cannot be trusted to represent the intended governed result.

Possible causes include:

- duplication;
- omission;
- incorrect transformation;
- invalid reconciliation;
- incompatible processing version;
- failed recovery;
- incorrect historical interpretation.

Correctness failure is generally more severe than freshness degradation because consumers may receive misleading information.

A newer incorrect result must not automatically replace an older known-good result.

### 4.32 Availability Failure

Availability failure occurs when a required capability cannot be used.

Examples include:

- source unavailable;
- processing service unavailable;
- storage unavailable;
- Certified Gold unavailable;
- analytical endpoint unavailable.

Availability must be evaluated at the capability level rather than only at the process level.

For example, upstream processing may be unavailable while Certified Gold remains available.

### 4.33 Recoverability Failure

Recoverability failure occurs when the platform cannot restore the required state using the expected recovery mechanisms.

Possible causes include:

- required history expired;
- backup unavailable;
- historical schema missing;
- processing version unavailable;
- corrupted recovery source;
- missing checkpoint information;
- insufficient lineage.

Recoverability failure may exist even before an active outage occurs.

For example, a backup that has never been successfully restored represents unproven recoverability.

### 4.34 Failure Severity

Failure severity should reflect architectural impact rather than only technical error type.

Relevant factors include:

- data-loss risk;
- correctness risk;
- recoverability risk;
- consumer impact;
- affected data classification;
- affected scope;
- duration;
- remaining recovery window;
- availability of alternate recovery sources.

Version 1 does not require an enterprise incident-severity framework.

Laboratory scenarios should nevertheless record enough context to explain why one failure requires greater urgency than another.

### 4.35 Failure Classification Record

Representative failure tests and significant recovery events should record, where applicable:

- failure identifier;
- failure domain;
- failure scope;
- failure type;
- affected component;
- failed dependency;
- affected data;
- processing progress;
- downstream impact;
- data-loss risk;
- correctness risk;
- recoverability risk;
- available recovery sources;
- selected recovery action;
- final result.

This information supports repeatable recovery analysis and evidence.

### 4.36 Failure Classification Principle

Atlas Engineering classifies failure according to its architectural consequence:

**Where Did It Fail?**
→ failure domain.

**How Much Is Affected?**
→ failure scope.

**Is It Temporary or Persistent?**
→ failure behavior.

**What State Is at Risk?**
→ durability and correctness.

**What Continues to Work?**
→ isolation and availability.

**How Long Can Recovery Wait?**
→ recovery-window and data-loss risk.

**From Where Can We Recover?**
→ available trustworthy recovery source.

**How Do We Know Recovery Succeeded?**
→ validation and evidence.

A useful failure classification must therefore describe more than an error message.

It must explain the effect of the failure on **data, processing, consumers, and recoverability**.

---

## 5. Durable State and Recovery Boundaries

Reliable recovery depends on identifying which platform states remain available, interpretable, and trustworthy after failure.

Atlas Engineering contains multiple durable states, but they do not provide identical recovery guarantees.

A persisted state may be:

- authoritative for one purpose;
- derived for another;
- retained only temporarily;
- incomplete for a specific recovery objective;
- dependent on historical processing definitions;
- no longer trustworthy after a defect or incident.

The architecture must therefore distinguish:

**Durable State**
→ state that survives the failure conditions for which its storage mechanism is designed.

**Recovery Source**
→ durable state that is appropriate and trustworthy for a specific recovery objective.

**Recovery Boundary**
→ the architectural point from which processing can safely resume or be reconstructed.

The governing principle is:

**Persisted Does Not Automatically Mean Recoverable → Recoverable Does Not Automatically Mean Appropriate**

### 5.1 Durable State

Durable state is information intentionally persisted beyond the lifetime of an individual process execution.

Representative durable states include:

- AtlasCommerce source data;
- SQL Server CDC history while retained;
- Kafka events while retained;
- Bronze historical data;
- Silver persisted state;
- Gold candidate state;
- Certified Gold versions;
- checkpoints;
- processing metadata;
- version metadata;
- lineage metadata;
- backups and archives where implemented.

Durability must always be interpreted according to the guarantees and failure domain of the underlying technology.

A state stored on disk is not automatically protected against every failure scenario.

### 5.2 Ephemeral State

Ephemeral state exists only for the duration of an execution, process, container, connection, or temporary operation.

Examples may include:

- in-memory processing state;
- uncommitted transactions;
- temporary buffers;
- local variables;
- unpersisted intermediate results;
- transient retry state;
- temporary files not governed as recovery artifacts.

Recovery must not depend exclusively on ephemeral state.

If information is required to determine safe processing progress after restart, it must be persisted through an appropriate durable mechanism.

### 5.3 Authoritative and Derived State

Atlas Engineering distinguishes between state that represents an authoritative input for a given responsibility and state derived through processing.

For the operational business domain:

**AtlasCommerce**
→ authoritative transactional source.

Within the analytical platform:

**Kafka**
→ durable event history while the required events remain within retention.

**Bronze**
→ primary historical analytical foundation for reconstruction.

**Silver**
→ governed standardized and conformed state.

**Gold**
→ derived dimensional or analytical state.

**Certified Gold**
→ governed consumer-visible analytical state.

Authority is contextual.

Certified Gold is authoritative for governed analytical consumption, but it is not the authoritative source from which raw operational history should normally be reconstructed.

### 5.4 Persistence Does Not Prove Completeness

A successfully persisted dataset may still be incomplete for a recovery objective.

For example:

- Kafka may contain only events still inside retention;
- Bronze may contain history only from the beginning of platform ingestion;
- Silver may intentionally omit source attributes;
- Gold may contain only analytical projections;
- Certified Gold may expose only the governed consumer contract;
- a backup may represent only one point in time.

Recovery planning must therefore evaluate whether the candidate source contains the complete information required for the intended reconstruction.

### 5.5 Persistence Does Not Prove Trust

A durable state may be technically intact but unsuitable for recovery.

Examples include:

- output produced by defective transformation logic;
- data created using an incompatible contract version;
- a Gold candidate that failed reconciliation;
- a version produced during a known integrity incident;
- a backup containing invalidated security state;
- incomplete data persisted before failure detection.

Recovery-source selection must consider trust in addition to physical availability.

### 5.6 Recovery Boundary

A recovery boundary is a durable architectural point from which processing can safely resume or be reconstructed.

Representative boundaries include:

- source and CDC;
- Kafka;
- Bronze;
- Silver;
- Gold version;
- Certified Gold version;
- backup or archive.

The appropriate boundary depends on:

- failure location;
- affected state;
- recovery objective;
- available history;
- historical definitions;
- data correctness;
- recovery time;
- recovery risk.

Recovery should begin from the latest appropriate trustworthy boundary, not automatically from the earliest or latest available state.

### 5.7 Source Database Boundary

AtlasCommerce is the authoritative transactional source for the business state it owns.

It may support recovery when:

- current source state is sufficient;
- a backfill is required;
- retained CDC history is insufficient;
- analytical history can be reconstructed from source information.

However, the current transactional state may not reproduce every historical event or prior value that once existed.

The source database must therefore not be assumed to be a complete substitute for historical event retention.

### 5.8 CDC Boundary

SQL Server CDC preserves source changes for a bounded period according to its configured retention and operational behavior.

While the required history remains available, CDC provides the source-change foundation consumed by Debezium.

Its recovery value depends on:

- capture continuity;
- retention;
- required log/change history;
- configuration;
- Debezium progress.

If required CDC history expires before successful capture, ordinary connector resumption may no longer be sufficient.

Another recovery path must then be selected.

### 5.9 Kafka Boundary

Kafka is the first preferred recovery source for normal event replay while the required event history remains retained and trustworthy.

Kafka provides:

- durable ordered events within partitions;
- consumer-independent retention;
- replay from retained offsets;
- decoupling between event production and downstream processing.

Kafka retention creates a bounded online recovery window.

If required events have expired, recovery must move to another appropriate boundary.

Kafka is therefore a strong recovery mechanism, but not an indefinite historical archive.

### 5.10 Bronze Boundary

Bronze is the primary historical analytical foundation for reconstruction.

It preserves governed raw event history with sufficient metadata to support:

- replay-independent reconstruction;
- reprocessing;
- historical investigation;
- downstream rebuild;
- lineage;
- version-aware interpretation.

Bronze reduces dependence on Kafka retention for long-term analytical recovery.

Its recovery value depends on preserving both the historical data and the metadata required to interpret that data correctly.

### 5.11 Silver Boundary

Silver is persisted standardized and conformed state.

It may be an appropriate recovery source when:

- the Silver state remains trustworthy;
- the required recovery objective does not require reconstruction of Silver itself;
- the historical Silver definition remains compatible with the intended rebuild;
- required lineage and version information remain available.

For example, a Gold-only defect may allow Gold to be rebuilt from valid Silver without replaying Bronze.

Silver should not be used as the recovery source when the failure or defect may have compromised Silver itself.

### 5.12 Gold Boundary

Gold represents derived analytical state produced for dimensional or analytical purposes.

A Gold version may support limited recovery operations when that version remains:

- complete;
- validated;
- interpretable;
- appropriate to the recovery objective.

Gold should not normally replace Silver or Bronze as the general historical reconstruction foundation.

When Gold logic is itself defective, recovery must begin from an upstream trustworthy boundary.

### 5.13 Certified Gold Boundary

Certified Gold is the governed consumer-visible boundary.

Its principal recovery value is analytical continuity and rollback.

Where a new candidate fails processing, validation, certification, or publication:

**Previous Certified Gold**
→ may remain available  
→ preserves known-good analytical consumption.

Certified Gold therefore provides a recovery boundary for consumer availability.

It does not replace upstream recovery sources required to reconstruct corrected analytical state.

### 5.14 Checkpoint State

Checkpoints represent committed processing progress.

Depending on the processing mechanism, a checkpoint may identify:

- Kafka offset;
- watermark;
- batch;
- execution;
- processed time interval;
- source position;
- version state.

Checkpoint state must correspond to successfully committed processing state.

The governing rule is:

**Output Not Safely Committed**
→ progress must not be treated as safely committed.

A checkpoint that advances beyond durable output may create omission.

A checkpoint that remains behind durable output may cause redelivery.

The architecture prefers safe redelivery handled through idempotency over silent omission.

### 5.15 Processing Metadata

Processing metadata provides context required to understand and recover executions.

Relevant metadata may include:

- execution identifier;
- start and completion time;
- input boundary;
- output boundary;
- processing version;
- checkpoint;
- record counts;
- failure state;
- retry state;
- recovery execution;
- quality result;
- reconciliation result.

Processing metadata is part of recoverability where it is required to determine what happened and what must happen next.

### 5.16 Version Metadata

Historical recovery may depend on knowing which definitions applied to the data being recovered.

Relevant version dimensions may include:

- source schema;
- event contract;
- Bronze interpretation;
- Silver processing;
- Gold processing;
- quality rules;
- reconciliation rules;
- certified product version.

Data without sufficient version context may remain physically durable but become semantically difficult or impossible to reconstruct correctly.

### 5.17 Lineage as Recovery Context

Lineage helps determine the relationship between affected and recoverable states.

For a recovery scenario, lineage may help answer:

- which source or events produced the affected data;
- which Bronze data contributed;
- which Silver state was used;
- which processing version produced Gold;
- which certified product was published;
- which downstream consumers may be affected.

Lineage is not itself the recovered business data.

It provides the context required to select and validate recovery correctly.

### 5.18 Backup Boundary

Backup provides a recovery foundation when the required online state is unavailable, corrupted, lost, or no longer retained.

Backup may be required for scenarios such as:

- storage loss;
- database loss;
- expired online history;
- infrastructure recovery;
- broader disaster recovery.

Backup is not automatically the first recovery mechanism for ordinary processing failures.

Where Kafka, Bronze, Silver, or another governed online state can safely satisfy the objective, using those sources may provide faster and more targeted recovery.

### 5.19 Archive Boundary

Archived state may support historical recovery when it remains:

- complete for the intended purpose;
- protected;
- interpretable;
- governed;
- restorable.

Archival does not guarantee immediate operational recoverability.

Recovery from archive may require additional restoration time before processing can resume.

Archive therefore affects both recovery capability and recovery time.

### 5.20 Recovery Source Hierarchy

For normal analytical recovery, Atlas Engineering uses the following conceptual preference:

**Kafka**
→ first recovery source while the required event history remains retained and trustworthy.

**Bronze**
→ primary historical analytical foundation for reconstruction after Kafka retention or when downstream historical processing must be reproduced.

**Silver**
→ valid recovery source for downstream reconstruction when Silver itself remains trustworthy and appropriate.

**Backup / Archive**
→ recovery foundation when required online history is unavailable or broader state restoration is necessary.

This is a preference model, not a rule that every recovery must traverse each boundary.

The selected source must match the actual failure and recovery objective.

### 5.21 Recovery Source Selection

Recovery-source selection should evaluate:

1. What failed?
2. Which state may be invalid?
3. What state remains trustworthy?
4. What history is required?
5. Which history remains available?
6. Which processing definitions are required?
7. Which recovery source provides the smallest safe reconstruction scope?
8. What validation is required afterward?

The newest available state is not automatically preferred.

The oldest available state is not automatically safer.

The correct source is the **latest appropriate trustworthy state that can satisfy the recovery objective**.

### 5.22 Recovery Window

A recovery window is the period during which a particular recovery source remains usable for the intended recovery mechanism.

Examples include:

- CDC retention window;
- Kafka retention window;
- Bronze retention;
- backup retention;
- archive availability.

Recovery windows may overlap.

For example:

**Kafka Recovery Window**
→ shorter, fast online replay.

**Bronze Recovery Window**
→ longer analytical reconstruction.

**Backup / Archive Window**
→ potentially longer-term recovery with higher restoration cost.

The architecture should understand these windows before a failure occurs.

### 5.23 Recovery Window Exhaustion

A failure may become more severe as its available recovery window decreases.

For example:

**Debezium Stopped**
→ CDC history still available  
→ ordinary recovery possible.

Later:

**Debezium Still Stopped**
→ required CDC history approaching expiration  
→ data-loss risk increasing.

After expiration:

**Required CDC History Lost**
→ connector restart alone cannot reconstruct the missing change interval.

Operational priority must therefore consider not only current failure impact but also **time remaining before recovery options degrade**.

### 5.24 Recovery Boundary Escalation

When a preferred recovery boundary can no longer satisfy the objective, recovery must escalate to an earlier or broader trustworthy boundary.

For example:

**Kafka history available**
→ replay from Kafka.

If not:

**Bronze history available**
→ reconstruct downstream processing from Bronze.

If Bronze is insufficient or unavailable:

**Source / Backfill or Backup / Archive**
→ select according to the required historical state and failure scenario.

Escalation should be explicit and observable.

A broader recovery boundary generally increases:

- processing volume;
- recovery time;
- validation scope;
- operational complexity.

### 5.25 Boundary Independence

Recovery architecture should avoid unnecessary dependence on a single durable state when another governed boundary can provide independent recovery value.

For example:

Kafka and Bronze serve different purposes:

**Kafka**
→ retained transport history and efficient replay.

**Bronze**
→ longer-lived analytical history and reconstruction.

Bronze should not merely exist as another temporary representation of the same retention window if its architectural purpose is historical reconstruction.

Each recovery boundary should justify the reliability property it provides.

### 5.26 Recovery and Shared Failure Domains

Two persisted copies do not provide independent recovery if they share the same failure domain.

For example, two copies stored on the same physical disk may both be lost through one storage failure.

Similarly, a local backup on the same failed device may provide little protection against device loss.

Recovery architecture must therefore distinguish:

**Logical Copy Count**

from:

**Failure-Domain Independence**

Version 1 may intentionally contain shared physical failure domains.

Those limitations must remain explicit.

### 5.27 Recovery and Historical Definitions

A recovery source remains useful only while the platform can correctly interpret it.

If Bronze contains historical events produced under Contract V1, but only Contract V3 remains understandable, the data may be physically present while reliable reconstruction becomes impossible.

The platform must therefore preserve historical definitions for at least as long as governed retained data depends on them.

This applies to:

- schemas;
- event contracts;
- transformation logic;
- quality definitions;
- reconciliation definitions;
- dimensional definitions;
- relevant metadata.

### 5.28 Recovery and Current Governance

Historical data may be recovered using historical definitions while still being subject to current applicable governance.

For example, a historical source may remain technically reconstructible while:

- a credential has since been revoked;
- access policy has changed;
- privacy treatment has changed;
- retention has expired;
- publication rules have changed.

Recovery must not silently restore obsolete governance state merely because it existed when the historical data was originally produced.

### 5.29 Recovery Boundary Validation

A recovery boundary should be validated before it is relied upon as a recovery guarantee.

Representative validation may include:

- Kafka replay from a known offset;
- Bronze reconstruction of Silver;
- Silver reconstruction of Gold;
- rollback to previous Certified Gold;
- backup restore;
- archive restoration where implemented;
- historical-version interpretation.

A documented recovery source that has never been successfully exercised represents an architectural expectation rather than demonstrated recoverability.

### 5.30 Durable State and Recovery Evidence

Evidence for recovery boundaries may identify:

- recovery source;
- retained interval;
- failure domain;
- initial state;
- processing checkpoint;
- historical version;
- recovery action;
- reconstructed scope;
- validation results;
- elapsed time;
- final state.

This evidence allows the project to determine which recovery boundaries have actually been demonstrated.

### 5.31 Durable State and Recovery Boundary Guarantees

The Atlas Engineering durable-state model must preserve the following guarantees:

1. recovery does not depend exclusively on ephemeral execution state;
2. durable states are not assumed to provide identical recovery value;
3. persistence alone does not prove completeness, trust, or recoverability;
4. recovery begins from an appropriate trustworthy boundary;
5. AtlasCommerce remains the authoritative transactional source for its operational domain;
6. CDC provides bounded source-change history according to its implemented retention;
7. Kafka is the preferred source for normal replay while required events remain retained and trustworthy;
8. Bronze is the primary historical analytical foundation for reconstruction;
9. Silver may support downstream reconstruction when it remains trustworthy and appropriate;
10. Gold does not replace upstream historical recovery foundations;
11. Certified Gold provides a known-good consumer availability and rollback boundary;
12. checkpoints correspond to safely committed processing progress;
13. processing, version, and lineage metadata support recoverability;
14. backup and archive remain distinct from ordinary online replay mechanisms;
15. recovery windows are explicit and influence operational priority;
16. exhaustion of one recovery window may require escalation to another boundary;
17. multiple copies are not assumed to provide independent recovery when they share the same failure domain;
18. historical definitions remain available while retained data depends on them;
19. historical reconstruction remains subject to current applicable governance;
20. recovery boundaries are considered demonstrated only after controlled validation and evidence.

---

## 6. Checkpoints, Progress, and Restartability

Atlas Engineering must preserve enough durable processing state to determine where work can safely resume after interruption.

A process restart must not depend on assumptions such as:

- the last record visible in a log;
- the time at which the service stopped;
- the last record read into memory;
- the last task reported as running;
- operator recollection of what probably completed.

The platform must distinguish between:

**Input Observed**
→ input became visible to the processor.

**Processing Started**
→ work began for that input.

**Output Persisted**
→ the resulting state was durably written.

**Progress Committed**
→ the platform recorded that the corresponding input no longer requires ordinary processing.

The governing principle is:

**Durable Output and Committed Progress Must Remain Consistent**

### 6.1 Processing Progress

Processing progress represents the durable position reached by a processing responsibility.

Depending on the component or processing model, progress may be represented by:

- CDC position;
- Kafka offset;
- consumer-group offset;
- checkpoint;
- watermark;
- batch identifier;
- execution identifier;
- processed interval;
- candidate version;
- certification state.

Different stages may use different progress mechanisms.

The architecture does not require one universal checkpoint representation across the platform.

It requires each recoverable processing boundary to have sufficient durable information to determine safe restart behavior.

### 6.2 Checkpoint

A checkpoint is a durable representation of committed processing progress.

A checkpoint should answer:

**What input has been successfully incorporated into the durable state governed by this processing stage?**

A checkpoint must not be interpreted merely as:

**What input did the process last attempt to read?**

The distinction is essential because observed input may not yet have produced durable output.

### 6.3 Checkpoint and Output Consistency

Checkpoint advancement must remain consistent with durable output.

The unsafe condition is:

**Checkpoint Advanced**
→ **Output Not Safely Persisted**

This may cause the platform to skip input after restart and create silent omission.

The safer failure mode is:

**Output Persisted**
→ **Checkpoint Not Yet Advanced**

This may cause the same logical input to be delivered or processed again.

Repeated delivery can be handled through idempotency.

Skipped input may be impossible to detect or reconstruct without additional reconciliation.

Therefore:

**Safe Redelivery Is Preferred to Silent Omission**

### 6.4 Commit Boundary

A commit boundary defines the point at which a unit of processing is considered durably complete.

Depending on the implementation, the boundary may include:

- one event;
- a group of events;
- a micro-batch;
- a partition interval;
- a business interval;
- a complete processing execution;
- a candidate analytical version.

The commit boundary should be explicit enough to support deterministic restart behavior.

Larger commit boundaries may reduce checkpoint overhead but increase the amount of work repeated after failure.

Smaller commit boundaries may reduce repeated work but increase operational and implementation overhead.

The selected boundary must preserve correctness before optimization.

### 6.5 Atomicity Between Output and Progress

Where the underlying technology supports atomic coordination between durable output and progress, the implementation should use it when appropriate.

Where full atomicity is unavailable, the architecture must explicitly tolerate the possible intermediate states.

The important scenarios are:

**Output Fails**
→ progress must not advance.

**Output Succeeds + Progress Fails**
→ input may be processed again.

The second scenario requires idempotent behavior.

The architecture must not claim exactly-once processing merely because output and checkpoint normally advance together.

### 6.6 Restartability

Restartability is the ability of a processing component to resume safely after interruption using durable state.

A restartable component should be able to determine:

- its last committed progress;
- which input may require processing;
- which input may be redelivered;
- which output may already exist;
- whether backlog accumulated;
- whether a different recovery mechanism is required.

Restartability should not require manual editing of business data merely to resume normal processing.

### 6.7 Clean Restart

A clean restart occurs when:

- the component stopped without invalidating durable state;
- required input remains available;
- checkpoint state remains valid;
- processing definitions remain compatible;
- no broader reconstruction is required.

The expected behavior is:

**Restart**
→ restore processing context  
→ resume from committed progress  
→ process remaining input  
→ validate advancement.

A clean restart should be the ordinary recovery path for routine component interruption.

### 6.8 Unclean Restart

An unclean restart follows an interruption in which processing may have stopped between durable operations.

Examples include:

- process termination;
- container crash;
- host interruption;
- connection loss;
- runtime failure;
- abrupt dependency failure.

After an unclean restart, the platform must assume that some input may be redelivered unless the implementation provides stronger proven guarantees.

Idempotent processing must protect correctness across this uncertainty window.

### 6.9 Restart Is Not Replay

Restart and replay are related but distinct operations.

**Restart**
→ restores execution of a component and normally continues from its committed progress.

**Replay**
→ intentionally processes previously retained input again from a selected historical position or interval.

A component restart may cause limited redelivery around the last commit boundary.

That does not automatically make the operation an architectural replay.

Replay is defined separately later in this document.

### 6.10 Restart Is Not Reprocessing

Restart resumes interrupted processing using the applicable processing definition.

Reprocessing intentionally executes already processed historical input again, generally because:

- processing logic changed;
- a defect was corrected;
- historical output must be regenerated;
- governed interpretation changed.

Routine restart should not be described as reprocessing merely because some input is delivered again.

### 6.11 Restart Is Not Rebuild

Restart restores interrupted execution.

Rebuild reconstructs a derived state from a selected trustworthy upstream boundary.

If a service stops while valid state remains intact, restart may be sufficient.

If the derived state itself is lost, corrupted, or invalidated, restart alone may be insufficient and rebuild may be required.

### 6.12 Kafka Consumer Progress

For Kafka consumers, offsets provide a natural representation of consumption position.

The architecture must distinguish:

**Record Fetched**

from:

**Record Safely Incorporated Into Governed Output**

Consumer progress should reflect the latter according to the implemented processing semantics.

Committing an offset before the required output is safely persisted can create omission after failure.

Committing after persistence may produce redelivery if failure occurs between persistence and offset commit.

The downstream implementation must tolerate that redelivery.

### 6.13 Partition-Specific Progress

Kafka ordering and offsets are partition-specific.

Processing progress must therefore preserve partition context where Kafka partitioning is relevant.

A consumer may be current on one partition while another remains behind or failed.

The platform must not infer complete topic progress solely from one global timestamp or aggregate status.

Partition-level lag and progress may be required for diagnosis and recovery.

### 6.14 CDC and Debezium Progress

CDC and Debezium recovery depend on durable source-change and connector progress.

After interruption, recovery must determine whether:

- the connector's required source position remains available;
- CDC still retains the required history;
- connector progress remains valid;
- publication to Kafka can resume without a missing source interval.

A restarted connector reporting `RUNNING` does not independently demonstrate capture continuity.

Recovery validation must confirm that the required change interval remains represented downstream.

### 6.15 Bronze Progress

Bronze progress should represent the Kafka input durably incorporated into Bronze.

A Bronze restart may encounter input already persisted before the previous checkpoint was committed.

Bronze processing must therefore tolerate redelivery without creating incorrect duplicate historical representation.

The implementation should preserve sufficient source metadata to support traceability to the originating Kafka event and processing execution.

### 6.16 Silver Progress

Silver progress should represent the Bronze input or governed processing interval successfully incorporated into persisted Silver state.

Depending on implementation, Silver may use:

- checkpoints;
- processed partitions;
- watermarks;
- batch identifiers;
- execution metadata.

A Silver restart must not infer progress solely from the existence of some output records.

The progress mechanism must reflect the processing boundary used by the implementation.

### 6.17 Gold Progress

Gold processing may operate through controlled analytical build executions rather than continuous event-by-event checkpoints.

Progress may therefore be represented by:

- source processing interval;
- Silver version;
- build identifier;
- Gold candidate version;
- execution state.

A partially produced Gold candidate must not automatically be interpreted as a successfully completed analytical version.

Completion must remain distinguishable from certification and publication.

### 6.18 Certification Progress

Certification has its own governed state.

Representative states may include:

- candidate created;
- validation pending;
- quality passed;
- reconciliation passed;
- certification failed;
- certified;
- published.

Certification progress must not be inferred solely from Gold processing completion.

A candidate that exists physically but has not completed required certification remains non-consumer-visible.

### 6.19 Orchestration Progress

Airflow records orchestration state, but orchestration state is not automatically equivalent to business-data processing state.

For example:

**Task Reported Failed**
→ underlying write may already have completed.

Or:

**Task Reported Successful**
→ downstream quality or certification may still fail.

Rerun decisions must therefore consider both:

- orchestration metadata;
- durable processing state.

Airflow must coordinate recovery rather than become the sole authority for whether business processing has already occurred.

### 6.20 Retry and Checkpoint Interaction

Retry must preserve checkpoint correctness.

A failed operation must not advance progress merely because its retry policy has been exhausted.

Likewise, successful retry must not create an additional business effect if an earlier attempt already persisted output but failed before progress was recorded.

The interaction between retry and checkpoint therefore depends on idempotency.

Detailed retry behavior is defined in the next section.

### 6.21 Backlog and Checkpoint Interaction

When processing stops while upstream input continues to accumulate:

**Checkpoint**
→ remains at the last committed position.

**Available Input**
→ continues advancing.

The distance between them represents recoverable backlog where the input remains retained.

After restart, processing should advance from committed progress rather than skip directly to the newest input.

Backlog recovery is addressed later in this document.

### 6.22 Checkpoint Corruption or Loss

Checkpoint state may itself fail.

Possible scenarios include:

- checkpoint unavailable;
- checkpoint corrupted;
- checkpoint inconsistent with output;
- checkpoint accidentally reset;
- progress metadata lost.

Recovery must not guess a new processing position solely to resume quickly.

Possible responses may include:

- reconstructing progress from durable metadata;
- comparing output with source boundaries;
- replaying from an earlier safe point;
- rebuilding the affected derived state.

When exact progress cannot be proven, the architecture should prefer a safe recoverable boundary that may repeat work over an unverified boundary that may omit data.

### 6.23 Checkpoint Reset

Checkpoint reset is a controlled recovery action, not a routine troubleshooting shortcut.

Before resetting progress, the recovery procedure should determine:

- why reset is required;
- which historical input will be delivered again;
- whether that input remains available;
- whether processing is idempotent;
- which outputs already exist;
- whether downstream state must be cleared or rebuilt;
- how the resulting state will be validated.

An uncontrolled checkpoint reset can create duplication, inconsistent history, or unintended large-scale replay.

### 6.24 Processing Gaps

A processing gap occurs when expected input between two known progress positions is not represented in the resulting durable state.

Possible causes include:

- premature checkpoint advancement;
- missing source history;
- skipped partition interval;
- failed write;
- incorrect recovery;
- processing defect.

Processing gaps must not be accepted merely because later progress continues successfully.

Where applicable, reconciliation and lineage should help detect missing intervals or missing business effects.

### 6.25 Duplicate Processing

Duplicate processing occurs when the same logical input is processed more than once.

Duplicate execution is not automatically a correctness failure.

It becomes a correctness failure when repeated execution creates unintended additional business state.

The platform should therefore distinguish:

**Duplicate Delivery / Execution**
→ may be expected.

**Duplicate Business Effect**
→ must be prevented or detected.

This distinction is central to the platform's at-least-once processing model.

### 6.26 Progress Monotonicity

Committed progress should normally move forward according to the ordering model of the processing boundary.

Unexpected backward movement may indicate:

- checkpoint reset;
- replay;
- recovery action;
- corruption;
- configuration error.

Intentional backward movement must be explicit and attributable.

The platform should not silently move processing progress backward during ordinary operation.

### 6.27 Independent Progress

Different processing stages maintain independent progress.

For example:

**Kafka**
→ events available through Offset X.

**Bronze**
→ persisted through Offset W.

**Silver**
→ processed through a corresponding earlier boundary.

**Gold**
→ built from a completed Silver version.

**Certified Gold**
→ may still expose the previous certified version.

These differences are expected in asynchronous processing.

Reliability depends on making them observable rather than pretending that the entire pipeline shares one instantaneous global position.

### 6.28 Progress and Freshness

Processing progress contributes to freshness but is not identical to freshness.

A checkpoint may be advancing while processing remains too far behind the source to satisfy the expected analytical recency.

Conversely, processing may temporarily stop while Certified Gold remains within its acceptable freshness expectation.

Freshness therefore requires interpretation of progress relative to:

- source activity;
- elapsed time;
- backlog;
- publication state;
- consumer expectation.

### 6.29 Restart Validation

After restart, validation should determine, where applicable:

- component is operational;
- required dependency connectivity is restored;
- committed progress was recovered;
- processing resumed from the expected boundary;
- checkpoints are advancing;
- backlog is decreasing or stable;
- no unexplained gap exists;
- duplicate business effects were not created;
- downstream layers resume appropriately;
- freshness begins recovering.

A successful process start is only the first validation step.

### 6.30 Restart Evidence

Representative restart tests should preserve evidence such as:

- pre-failure checkpoint;
- failure time;
- failure mechanism;
- last known durable output;
- restart time;
- recovered checkpoint;
- first input processed after restart;
- observed redelivery;
- duplicate-handling result;
- backlog before and after restart;
- final checkpoint;
- validation result;
- elapsed recovery time.

This evidence demonstrates actual restartability rather than configuration intent.

### 6.31 Checkpoint and Restartability Guarantees

The Atlas Engineering checkpoint and restartability model must preserve the following guarantees:

1. processing progress is represented through durable state where required for recovery;
2. input observation is distinguishable from successful durable processing;
3. checkpoints represent committed progress rather than merely attempted input;
4. progress does not safely advance beyond required durable output;
5. redelivery is preferred to silent omission when atomic coordination is unavailable;
6. processing tolerates expected redelivery through idempotent behavior;
7. restart normally resumes from committed progress;
8. restart remains distinct from replay, reprocessing, and rebuild;
9. Kafka progress preserves partition context where required;
10. CDC and Debezium recovery validates capture continuity rather than only service status;
11. Bronze, Silver, Gold, and certification use progress representations appropriate to their processing models;
12. orchestration state does not replace durable business-processing state;
13. exhausted retry does not falsely advance processing progress;
14. backlog is processed from committed progress rather than skipped;
15. lost or inconsistent checkpoints are recovered from a safe proven boundary rather than guessed;
16. checkpoint reset is controlled, attributable, and validated;
17. processing gaps are treated as correctness concerns even when later processing succeeds;
18. duplicate execution is distinguished from duplicate business effect;
19. intentional backward progress is explicit;
20. asynchronous stages may legitimately expose different progress positions;
21. restart validation verifies data-processing behavior in addition to component availability;
22. restartability claims are supported by controlled evidence.

---

## 7. Retry and Redelivery

Atlas Engineering must tolerate transient failures and expected redelivery without converting them into data loss, uncontrolled duplication, or indefinite processing loops.

Retry and redelivery are related but distinct behaviors.

**Retry**
→ the same operation is attempted again after a failure.

**Redelivery**
→ the same logical input becomes available for processing again because previous processing was not conclusively committed or because historical input is intentionally revisited.

Both behaviors may cause the same logical input to be handled more than once.

The architecture must therefore combine:

**Failure Classification → Bounded Retry → Idempotent Processing → Explicit Progress → Persistent Failure Handling**

### 7.1 Retry Purpose

Retry is appropriate when a failed operation has a reasonable probability of succeeding without changing the underlying business meaning or processing definition.

Representative retryable conditions may include:

- temporary network interruption;
- temporary dependency unavailability;
- transient storage failure;
- connection timeout;
- temporary resource contention;
- short-lived service unavailability;
- temporary throttling.

Retry exists to absorb temporary instability.

It must not be used to hide persistent defects.

### 7.2 Retryable and Non-Retryable Failures

Failures should be classified before determining retry behavior.

A **retryable failure** is expected to potentially succeed after waiting or after the affected dependency recovers.

A **non-retryable failure** requires another action before the operation can succeed correctly.

Representative non-retryable conditions may include:

- malformed input;
- incompatible schema;
- invalid configuration;
- missing required permission;
- revoked credential;
- unsupported contract version;
- deterministic transformation defect;
- violated business assumption.

Retrying a deterministic failure without changing its cause normally reproduces the same result.

### 7.3 Bounded Retry

Retry must be bounded by an explicit policy.

The policy may define:

- maximum attempts;
- maximum elapsed retry time;
- delay between attempts;
- backoff behavior;
- eligible error categories;
- terminal failure behavior.

The exact values may differ by component and failure type.

Version 1 should derive practical values through implementation and laboratory observation rather than inventing universal production-grade settings.

### 7.4 Retry Delay

Immediate repeated retry may worsen an existing failure.

Where appropriate, retry should introduce delay before another attempt.

Delay can:

- allow a dependency to recover;
- reduce repeated connection pressure;
- reduce unnecessary resource consumption;
- prevent tight failure loops;
- improve operational observability.

The appropriate delay depends on the expected failure behavior.

### 7.5 Backoff

Repeated failures may justify progressively increasing the interval between attempts.

A backoff strategy can reduce pressure on an unavailable or degraded dependency.

Possible strategies include:

- fixed delay;
- linear backoff;
- exponential backoff;
- bounded exponential backoff.

The architecture does not require one universal backoff algorithm.

The selected mechanism should match the component, failure mode, and operational objective.

### 7.6 Jitter

Where many workers or services may retry simultaneously, deterministic retry intervals can cause synchronized repeated load.

Jitter may be added to retry timing to reduce simultaneous retry behavior.

This is particularly relevant when multiple processing units depend on the same temporarily unavailable resource.

Jitter is an implementation mechanism rather than a universal requirement.

Its use should be justified by the concurrency and failure characteristics of the affected component.

### 7.7 Retry Storm

A retry storm occurs when repeated recovery attempts generate enough additional load to worsen or prolong the original failure.

For example:

**Dependency Unavailable**
→ many workers fail  
→ all retry immediately  
→ dependency begins recovering  
→ simultaneous retries overload it again.

Retry policies should reduce this risk through mechanisms such as:

- bounded attempts;
- delay;
- backoff;
- jitter;
- concurrency control;
- circuit-breaking behavior where appropriate.

Recovery activity must not become a new failure source.

### 7.8 Retry and Idempotency

A retry may occur after the original operation produced some durable effect but before success was conclusively recorded.

For example:

**Write Succeeds**
→ response is lost  
→ processor interprets the operation as failed  
→ retry occurs.

The retry must not create an unintended second business effect.

Retry-safe processing therefore depends on idempotency where execution outcome may be uncertain.

### 7.9 Retry and Checkpoint

A failed operation must not advance committed processing progress merely because the retry mechanism has exhausted its attempts.

The expected relationship is:

**Processing Succeeds**
→ required output is durably persisted  
→ progress may advance.

**Processing Fails**
→ progress remains before the failed unit  
→ retry or another recovery path is selected.

If output succeeded but progress did not advance, later redelivery must remain safe through idempotent processing.

### 7.10 Redelivery

Redelivery occurs when the same logical input is presented for processing more than once.

Possible causes include:

- failure between output persistence and checkpoint commit;
- consumer restart;
- offset recovery;
- connection interruption;
- acknowledgment failure;
- partition reassignment;
- replay;
- deliberate checkpoint reset.

Redelivery is an expected property of distributed processing.

It must not automatically be treated as data corruption.

### 7.11 Redelivery Identification

Where required for correctness or evidence, the platform should preserve enough identity to recognize the logical input being processed.

Relevant identifiers may include:

- event identifier;
- source key;
- source change position;
- Kafka topic;
- Kafka partition;
- Kafka offset;
- business key;
- processing execution identifier.

The appropriate identity depends on the processing layer and business semantics.

### 7.12 Duplicate Delivery and Duplicate Business Effect

Atlas Engineering distinguishes:

**Duplicate Delivery**
→ the same logical input is received more than once.

**Duplicate Processing**
→ the same logical input is executed more than once.

**Duplicate Business Effect**
→ repeated execution creates an unintended additional logical result.

The first two may occur legitimately under at-least-once processing.

The third must be prevented or detected.

### 7.13 Retry Exhaustion

Retry exhaustion occurs when the retry policy reaches its defined boundary without successful completion.

At that point, the failure must transition from automatic retry into an explicit operational state.

Possible responses include:

- failure isolation;
- quarantine;
- task failure;
- processing pause;
- alert;
- operator investigation;
- remediation;
- selection of another recovery mechanism.

Retry exhaustion must not silently discard the affected work.

### 7.14 Persistent Failure Transition

A failure should transition into persistent-failure handling when continued retry is no longer expected to restore correct processing.

The transition should preserve, where applicable:

- affected input;
- error context;
- attempt count;
- first failure time;
- latest failure time;
- processing position;
- relevant version;
- dependency state;
- required remediation.

This makes the failure actionable rather than merely repetitive.

### 7.15 Poison Record Interaction

A poison record is an input that repeatedly causes processing failure while surrounding input may otherwise be valid.

Retry alone is not an adequate long-term strategy for poison records.

After the applicable retry policy is exhausted, the record should enter the explicit failure-handling path defined later in this document.

The architecture must avoid allowing one deterministic poison record to create an infinite processing loop.

### 7.16 Retry and Partition Progress

Where ordered processing is required within a Kafka partition, one persistent failure may prevent safe progress beyond the affected record.

The platform must not commit progress beyond a failed input when doing so would violate the processing semantics or create omission.

Possible strategies depend on the implementation and may include:

- pausing the affected partition;
- isolating the failed input through a governed mechanism;
- blocking that processing path;
- remediation followed by resume.

The selected strategy must preserve ordering and correctness requirements.

### 7.17 Retry and Failure Isolation

Retry should occur at the smallest safe scope.

A failure affecting one:

- record;
- partition;
- entity;
- processing stage;
- data product;

should not automatically cause unrelated healthy work to retry or restart.

Isolation reduces unnecessary load and limits the blast radius of persistent failures.

### 7.18 Dependency Recovery

When retry is caused by dependency failure, recovery should consider the health of the dependency rather than only the elapsed retry interval.

For example:

**MinIO Unavailable**
→ repeated writes fail.

If dependency health remains clearly unavailable, aggressive retries provide little value.

Where supported, dependency-health information may inform:

- retry pacing;
- temporary processing pause;
- resumption;
- escalation.

### 7.19 Circuit-Breaking Behavior

Some implementations may benefit from temporarily stopping calls to a dependency that is known to be failing.

Conceptually:

**Repeated Dependency Failure**
→ stop or reduce requests  
→ allow recovery interval  
→ probe dependency  
→ resume controlled traffic when healthy.

Circuit breaking is not mandatory for every Version 1 component.

Where implemented, it must remain observable and must not silently prevent processing from resuming after dependency recovery.

### 7.20 Retry and Backpressure

Retry consumes processing capacity.

During prolonged dependency degradation, excessive retry activity may compete with:

- healthy processing;
- backlog recovery;
- storage operations;
- monitoring.

Retry policy must therefore interact safely with backpressure and concurrency controls.

The platform should not spend most of its capacity repeatedly executing work that is known to be unable to succeed.

### 7.21 Retry and Retention Windows

A prolonged retry state may consume time from a bounded recovery window.

For example:

**Debezium Cannot Publish**
→ retries continue  
→ CDC history continues aging.

Or:

**Bronze Cannot Persist**
→ consumption cannot advance safely  
→ Kafka history continues aging.

Retry policy must therefore consider whether waiting reduces future recovery options.

A failure approaching recovery-window exhaustion may require escalation before ordinary retry limits would otherwise be reached.

### 7.22 Retry and Credentials

Authentication failure must be classified carefully.

A temporary identity-service outage may be retryable.

An invalid, revoked, or expired credential may require credential remediation rather than repeated authentication attempts.

Retry behavior must not:

- weaken authentication;
- bypass authorization;
- restore revoked credentials;
- expose secret values through repeated logging.

Credential-specific security requirements remain governed by **Security and Governance**.

### 7.23 Retry and Rate Limits

Where a dependency imposes rate limits or throttling, retry behavior should respect the dependency's expected recovery mechanism.

Immediate repeated requests may extend throttling or increase failure.

Where available, retry may consider:

- server-provided retry guidance;
- bounded delay;
- backoff;
- reduced concurrency.

The implementation must remain observable so that throttling is not mistaken for unexplained processing stagnation.

### 7.24 Retry and Orchestration

Airflow may retry failed orchestration tasks where appropriate.

Task-level retry must not assume that the underlying operation produced no durable effect.

Before a task is considered safely retryable, its processing behavior must tolerate repeated execution or determine whether previous work already completed.

Airflow retry therefore depends on the idempotency of the operation being orchestrated.

### 7.25 Retry and Batch Processing

A batch may fail after processing only part of its intended input.

Recovery must know the batch commit semantics.

Possible models include:

**Atomic Batch**
→ either the governed batch state is committed or it is not.

**Incrementally Committed Batch**
→ some units may already be durable before failure.

Retry behavior must match the implemented model.

Repeating an incrementally committed batch requires idempotent handling of already persisted units.

### 7.26 Retry and Candidate Generation

Gold candidate generation may be retried when failure does not invalidate the underlying input or processing definition.

A failed candidate execution must not become Certified Gold merely because a later orchestration retry reports success.

The resulting candidate remains subject to:

- completeness validation;
- quality;
- reconciliation;
- lineage;
- certification.

Retry restores processing opportunity.

It does not bypass publication governance.

### 7.27 Manual Retry

Manual retry may be appropriate after investigation or remediation.

A manual retry should identify:

- affected failure;
- reason retry is now expected to succeed;
- processing boundary;
- input scope;
- checkpoint or starting position;
- expected downstream effect;
- validation requirement.

Manual execution must not become an undocumented alternative processing path.

### 7.28 Retry After Remediation

After a persistent failure is remediated, the affected work may return to processing.

Examples include:

- corrected configuration;
- restored permission;
- replacement credential;
- corrected transformation;
- supported schema deployed;
- corrected reference data.

The platform should resume from a controlled boundary that preserves previously successful work where appropriate.

Remediation does not automatically require full rebuild.

### 7.29 Redelivery After Recovery

Recovery operations may intentionally increase redelivery.

Examples include:

- restart from an earlier checkpoint;
- offset reset;
- replay;
- reconstructed processing interval.

The expected increase in duplicate delivery should be distinguished from unexpected duplicate business effects.

Evidence should demonstrate that idempotency preserved the intended result.

### 7.30 Retry Observability

Retry behavior should expose, where applicable:

- retry count;
- affected operation;
- failure category;
- first failure time;
- latest failure time;
- next retry;
- retry delay;
- dependency;
- affected processing boundary;
- exhaustion state.

A component repeatedly retrying must not appear indistinguishable from healthy processing.

### 7.31 Redelivery Observability

Where useful for validation or diagnosis, the platform should be able to identify:

- redelivered input;
- original input identity;
- processing execution;
- checkpoint context;
- resulting output;
- duplicate-handling behavior.

Not every duplicate delivery requires an alert.

Unexpected duplicate business effects do.

### 7.32 Retry Alerts

Alerting should focus on operationally meaningful retry conditions rather than every isolated transient failure.

Relevant conditions may include:

- retry exhaustion;
- unusually high retry rate;
- prolonged dependency failure;
- repeated failure of the same input;
- growing backlog associated with retry;
- recovery-window risk;
- failure transition from transient to persistent.

Detailed alert design belongs to the specialized **Observability** architecture.

### 7.33 Retry Recovery Validation

After retry-based recovery, validation should determine, where applicable:

- operation eventually succeeded;
- progress advanced correctly;
- no processing gap was introduced;
- repeated execution did not create duplicate business effects;
- backlog returned toward normal;
- downstream processing resumed;
- applicable quality and reconciliation controls still pass.

Retry success alone is insufficient if resulting data correctness is uncertain.

### 7.34 Retry Evidence

Representative retry tests should preserve evidence such as:

- failure condition;
- retryable classification;
- attempt count;
- retry timing;
- observed backoff where implemented;
- durable progress before failure;
- successful recovery attempt;
- checkpoint progression;
- redelivery behavior;
- duplicate-handling result;
- final processing state;
- elapsed recovery time.

Persistent-failure tests should additionally demonstrate that retry eventually stops and transitions into the intended explicit failure state.

### 7.35 Retry and Redelivery Guarantees

The Atlas Engineering retry and redelivery model must preserve the following guarantees:

1. retry is used for failures that may reasonably succeed without changing the underlying business meaning;
2. deterministic persistent failures are not hidden behind indefinite retry;
3. retry behavior is bounded and observable;
4. delay and backoff may reduce unnecessary pressure during transient failure;
5. synchronized retry behavior is controlled where it could worsen dependency recovery;
6. retries do not create unintended duplicate business effects;
7. failed work does not falsely advance committed processing progress;
8. redelivery is treated as an expected distributed-processing behavior;
9. duplicate delivery and duplicate execution remain distinct from duplicate business effect;
10. retry exhaustion transitions into an explicit failure state;
11. failed input remains traceable after retry exhaustion;
12. poison records do not create uncontrolled infinite processing loops;
13. ordered processing does not silently skip failed input;
14. retry occurs at the smallest safe failure scope where practical;
15. retry behavior considers dependency health and backpressure;
16. prolonged retry does not ignore bounded recovery-window risk;
17. credential failures are remediated without weakening security boundaries;
18. orchestration retry depends on idempotent underlying processing;
19. partial batch completion is handled according to explicit commit semantics;
20. retry does not bypass Gold certification or publication controls;
21. manual retry remains controlled and attributable;
22. recovery-induced redelivery remains safe through idempotent processing;
23. retry and redelivery behavior is observable;
24. retry-based recovery is validated for processing and data correctness;
25. retry guarantees are supported by controlled evidence.

---

## 8. Recovery Source Strategy

Atlas Engineering must select recovery sources according to the failure being recovered, the state that remains trustworthy, the history required, and the recovery objective.

Recovery-source selection must not be based solely on convenience, physical availability, or the newest persisted state.

The governing principle is:

**Identify the Invalid State → Preserve the Trusted State → Select the Latest Appropriate Trustworthy Recovery Source → Recover → Revalidate**

The preferred recovery source should provide the smallest safe recovery scope while preserving correctness, interpretability, and governance.

### 8.1 Recovery Source Objectives

A recovery source may be required to support different objectives.

Representative objectives include:

- resume interrupted processing;
- recover missing downstream processing;
- replay retained events;
- reconstruct standardized state;
- rebuild analytical state;
- correct historical processing;
- restore lost durable state;
- restore consumer-visible availability;
- recover after retention-window exhaustion.

The same failure may permit more than one technically possible recovery source.

The architecture should select the source that satisfies the objective without unnecessarily increasing recovery scope.

### 8.2 Recovery Source Eligibility

A durable state is eligible as a recovery source only when it is appropriate for the intended recovery.

Eligibility should consider:

- required history is available;
- state is sufficiently complete;
- state remains trustworthy;
- required metadata exists;
- required historical definitions remain available;
- integrity can be established;
- access remains authorized;
- retention permits continued use;
- recovery can be validated.

Physical existence alone does not establish eligibility.

### 8.3 Preferred Recovery Principle

Atlas Engineering should normally recover from the latest appropriate trustworthy boundary.

Conceptually:

**Later Trustworthy Boundary**
→ smaller reconstruction scope  
→ potentially faster recovery.

**Earlier Trustworthy Boundary**
→ broader reconstruction scope  
→ potentially greater historical reconstruction capability.

The latest boundary must not be preferred when the failure may have invalidated that state.

### 8.4 Recovery Source Hierarchy

The conceptual recovery-source hierarchy for analytical processing is:

**Kafka**
→ preferred for normal replay while the required event history remains retained and trustworthy.

**Bronze**
→ primary historical analytical foundation for reconstruction and reprocessing.

**Silver**
→ appropriate for downstream reconstruction when Silver remains valid for the recovery objective.

**AtlasCommerce / Controlled Backfill**
→ appropriate when required state must be recovered from the operational source and downstream retained history is insufficient.

**Backup / Archive**
→ broader recovery foundation when required online state is unavailable, lost, corrupted, or outside normal retention.

This hierarchy represents recovery preference, not a mandatory traversal sequence.

### 8.5 Kafka as Recovery Source

Kafka should be the first recovery source for normal event replay when:

- required events remain retained;
- event history is complete for the required interval;
- event contracts remain interpretable;
- Kafka state remains trustworthy;
- the affected downstream processing can safely consume the retained history again.

Representative scenarios include:

- Bronze consumer interruption;
- checkpoint recovery;
- controlled offset reset;
- downstream processing gap while Kafka history remains available.

Kafka provides efficient online replay without requiring reconstruction from the operational source.

### 8.6 Kafka Recovery Limitations

Kafka should not be treated as an indefinite historical archive.

Kafka may become unsuitable when:

- required events have expired;
- required partition history is incomplete;
- retained events were produced under an unavailable or uninterpretable contract;
- Kafka state itself is affected by the incident;
- the recovery objective requires history never published to Kafka.

When Kafka cannot satisfy the recovery objective, another boundary must be selected.

### 8.7 Bronze as Recovery Source

Bronze is the primary historical analytical recovery foundation.

Bronze should support scenarios such as:

- reconstruction after Kafka retention expires;
- Silver reprocessing;
- downstream rebuild;
- correction after transformation defects;
- historical validation;
- version-aware reconstruction.

Bronze provides analytical independence from Kafka's shorter transport-retention window.

Its usefulness depends on preservation of raw event fidelity and the metadata required for historical interpretation.

### 8.8 Bronze Recovery Limitations

Bronze is not appropriate when:

- the required input never reached Bronze;
- Bronze history is incomplete for the affected interval;
- Bronze itself was corrupted or invalidated;
- required historical interpretation is unavailable;
- the recovery objective requires source state not represented by the captured event history.

In such scenarios, recovery must move to another trustworthy boundary.

### 8.9 Silver as Recovery Source

Silver may be used as a downstream recovery source when:

- Silver itself remains correct;
- the defect or failure occurred downstream;
- the required analytical information is already represented in Silver;
- the applicable Silver version remains interpretable;
- lineage identifies the Silver state used.

A representative scenario is:

**Gold Logic Defect**
→ Silver remains valid  
→ corrected Gold logic deployed  
→ Gold rebuilt from Silver.

Returning to Bronze or Kafka in this case may provide no additional correctness while increasing recovery time and complexity.

### 8.10 Silver Recovery Limitations

Silver must not be selected merely because it is closer to Gold.

It is unsuitable when:

- Silver transformation logic was defective;
- Silver state is incomplete;
- required attributes were intentionally removed;
- historical Silver semantics do not satisfy the recovery objective;
- Silver lineage or version context is insufficient;
- the failure may have compromised Silver integrity.

In those cases, recovery should move upstream to Bronze or another appropriate source.

### 8.11 Gold as Recovery Source

Gold is primarily derived analytical state rather than the general recovery foundation for upstream processing.

A valid Gold version may nevertheless support limited recovery scenarios such as:

- restoration of a publication mechanism;
- comparison with a failed candidate;
- preservation of a known analytical state;
- rollback of consumer-visible publication where the corresponding certified version remains valid.

Gold should not be used to reconstruct Silver or raw historical processing.

### 8.12 Certified Gold as Recovery Source

Certified Gold provides the principal recovery boundary for governed analytical consumption.

When a newer candidate or publication fails:

**Last Known-Good Certified Gold**
→ remains or becomes consumer-visible.

This protects analytical availability while upstream remediation occurs.

Certified Gold rollback does not repair the upstream defect.

It restores a known-good consumer-visible state while the underlying processing path is recovered separately.

### 8.13 AtlasCommerce as Recovery Source

AtlasCommerce may provide a recovery source when current or historical operational data available from the source can satisfy the recovery objective.

Representative scenarios may include:

- controlled backfill;
- initialization of newly required downstream attributes;
- recovery after missing event history;
- reconstruction where current source state is sufficient.

Use of AtlasCommerce must respect the operational-source boundary.

Recovery activity must not impose uncontrolled analytical workload on the transactional system.

### 8.14 Current Source State Versus Historical Events

Current AtlasCommerce state is not equivalent to historical change history.

For example, if a value changed:

**A → B → C**

the current source may expose only:

**C**

while historical event processing may require knowledge of:

**A → B → C**

A source snapshot can therefore recover current state without necessarily recovering historical event semantics.

The recovery objective must determine whether current-state reconstruction is sufficient.

### 8.15 Controlled Backfill

Backfill may be used when required downstream state cannot be reconstructed solely from retained event history.

A controlled backfill should define:

- source scope;
- business scope;
- historical interval;
- extraction mechanism;
- expected downstream behavior;
- interaction with live processing;
- deduplication or reconciliation requirements;
- validation;
- lineage.

Backfill is defined in detail later in this document.

It must not become an undocumented bypass around the normal governed ingestion path.

### 8.16 Backup as Recovery Source

Backup becomes important when:

- required online state is lost;
- storage is corrupted;
- database state must be restored;
- required retained history is no longer available;
- broader infrastructure recovery is necessary.

Backup recovery may restore:

- source database state;
- platform metadata;
- storage state;
- other protected durable state according to implemented backup scope.

The exact capability depends on what is actually backed up and successfully restorable.

### 8.17 Backup Is Not Replay

Backup restoration and event replay solve different problems.

**Replay**
→ processes retained historical input again.

**Backup Restore**
→ restores a persisted state from an earlier protected copy.

A backup may restore the foundation from which replay or subsequent processing continues.

It does not inherently reproduce every event or processing action that occurred after the backup point.

### 8.18 Archive as Recovery Source

Archive may provide longer-term recovery capability for data that is no longer maintained in ordinary online storage.

Archive recovery may require:

1. locate the required archived state;
2. validate its integrity and governance status;
3. restore it to an accessible processing environment;
4. recover required historical definitions;
5. execute reconstruction;
6. validate the resulting state.

Archive therefore generally provides a slower recovery path than online retained state.

### 8.19 Recovery Source Independence

Recovery-source strategy must consider whether the selected source is independent from the failure being recovered.

For example:

**MinIO Storage Failure**
→ a recovery copy stored only on the same failed physical storage may not provide meaningful independent recovery.

Similarly:

**Host Failure**
→ multiple local services and local copies may fail together.

Version 1 may contain shared physical failure domains.

Such limitations must remain explicit when interpreting recovery claims.

### 8.20 Recovery Source Trust

A recovery source may lose trust because of:

- corruption;
- processing defect;
- incomplete write;
- security compromise;
- incompatible interpretation;
- failed reconciliation;
- privacy-invalid state;
- known missing data.

When trust is invalidated, recovery must move to a boundary that predates or excludes the invalid state.

The newest state must not be preferred merely because it minimizes recovery effort.

### 8.21 Last Successful Versus Last Trustworthy State

Atlas Engineering distinguishes:

**Last Successful State**
→ the latest state produced without a technical execution failure.

**Last Known-Trustworthy State**
→ the latest state for which applicable correctness, governance, and security assumptions remain valid.

These may differ.

For example:

**Gold Candidate Generated Successfully**
→ later reconciliation demonstrates incorrect results.

The candidate was technically successful but is not trustworthy.

Recovery must therefore select the last appropriate trustworthy state rather than the last technically successful state.

### 8.22 Recovery Source and Defect Location

Recovery should normally begin upstream of the defect being corrected.

For example:

**Gold Defect**
→ valid Silver may be used.

**Silver Defect**
→ valid Bronze may be used.

**Bronze Processing Defect**
→ retained Kafka may be used.

**Missing Kafka Event Caused by Upstream Capture Gap**
→ Kafka cannot repair the missing event  
→ source/backfill or another historical source may be required.

This prevents reconstruction from preserving the same invalid state that caused the recovery requirement.

### 8.23 Recovery Source and Version Compatibility

A recovery source must remain compatible with the processing definition used to interpret it.

Recovery may require historical:

- schema definitions;
- event contracts;
- transformation versions;
- business rules;
- quality rules;
- dimensional definitions.

If a current processing version cannot correctly interpret historical input, the recovery strategy must explicitly select or migrate the appropriate interpretation.

Historical data must not be silently forced through incompatible current logic.

### 8.24 Recovery With Current Logic

Historical input may intentionally be processed using current logic when the recovery objective is to correct or restate historical output.

For example:

**Historical Bronze**
→ corrected Silver V2  
→ corrected Gold V3.

This is a governed reprocessing decision.

The resulting output must preserve lineage identifying:

- historical input;
- current processing definition;
- recovery execution;
- resulting version.

Using current logic is therefore different from reproducing the historical result exactly.

### 8.25 Recovery With Historical Logic

Some recovery objectives require reproduction of the state that would have been produced under the historical definition.

In such cases, the platform may require:

- historical processing code;
- historical contract;
- historical schema;
- historical quality definition;
- historical dimensional definition.

The architecture must distinguish:

**Historical Reproduction**

from:

**Historical Restatement Using Current Logic**

Both may be valid, but they answer different recovery questions.

### 8.26 Recovery Source and Data Classification

Recovery sources remain subject to their data classification.

A recovery operation must not weaken handling merely because the data is being restored, replayed, or rebuilt.

This applies to:

- source extracts;
- Kafka history;
- Bronze;
- temporary recovery datasets;
- backups;
- archives.

Temporary recovery copies must remain governed and must not become unmanaged sensitive-data replicas.

### 8.27 Recovery Source and Retention

Recovery capability depends on retention.

If the required history is no longer retained, that recovery path no longer exists.

Retention decisions must therefore consider their effect on:

- replay window;
- reprocessing window;
- backfill requirements;
- rebuild capability;
- auditability;
- historical reproducibility.

Retention and recovery cannot be designed independently.

### 8.28 Recovery Source and RPO

The available recovery source influences achievable Recovery Point Objective.

For example:

- recent retained Kafka history may permit recovery close to the last committed event;
- Bronze may preserve longer history but reflect a different processing boundary;
- backup may restore only to the most recent protected recovery point.

Formal RPO must therefore reflect the actual durability and recovery mechanisms implemented.

RPO is addressed in detail later in this document.

### 8.29 Recovery Source and RTO

The selected recovery source also influences recovery time.

In general:

**Online Retained State**
→ potentially faster recovery.

**Historical Reconstruction**
→ more processing required.

**Backup Restore**
→ restoration plus subsequent catch-up may be required.

**Archive Restore**
→ additional retrieval and restoration time may be required.

The fastest recovery path must still preserve correctness.

RTO must not be optimized by selecting an invalid recovery source.

### 8.30 Recovery Source Escalation

Recovery may escalate when the preferred source proves unavailable or insufficient.

A representative progression is:

**Kafka**
→ required history unavailable.

**Bronze**
→ required history available and trustworthy  
→ reconstruct downstream.

If Bronze is also insufficient:

**AtlasCommerce / Controlled Backfill**
or
**Backup / Archive**
→ selected according to the missing state and recovery objective.

Escalation should be deliberate rather than improvised during failure.

### 8.31 Recovery Source Decision Record

Significant recovery actions should record, where applicable:

- failure;
- affected state;
- invalidated state;
- recovery objective;
- candidate recovery sources;
- selected recovery source;
- reason for selection;
- retained interval;
- applicable processing version;
- expected reconstruction scope;
- validation requirements.

This provides traceability for why one recovery boundary was chosen over another.

### 8.32 Recovery Source Validation

Recovery-source capability should be demonstrated through controlled tests.

Representative tests may include:

- Kafka replay while retained history exists;
- Bronze-based Silver reconstruction;
- Silver-based Gold rebuild;
- Certified Gold rollback;
- controlled source backfill;
- backup restoration;
- archive restoration where implemented.

A successful test should demonstrate not only that the source can be read, but that the intended governed state can be recovered from it.

### 8.33 Recovery Source Evidence

Evidence should preserve, where applicable:

- source selected;
- reason for selection;
- source integrity state;
- retained interval;
- version context;
- recovery start;
- reconstruction scope;
- resulting progress;
- validation results;
- elapsed recovery time;
- final governed state.

This allows future architecture decisions to compare recovery mechanisms using observed behavior.

### 8.34 Recovery Source Strategy Guarantees

The Atlas Engineering recovery-source strategy must preserve the following guarantees:

1. recovery sources are selected according to the failure and recovery objective;
2. physical availability alone does not establish recovery-source eligibility;
3. the latest appropriate trustworthy boundary is preferred when it safely satisfies the objective;
4. Kafka is preferred for normal replay while required events remain retained and trustworthy;
5. Kafka is not treated as an indefinite historical archive;
6. Bronze is the primary historical analytical foundation for reconstruction;
7. Silver may support downstream recovery only while Silver remains trustworthy and sufficient;
8. Gold does not replace upstream historical reconstruction sources;
9. Certified Gold provides a known-good analytical availability and rollback boundary;
10. AtlasCommerce may support controlled backfill without becoming an uncontrolled analytical processing dependency;
11. current source state is not assumed to reproduce historical event history;
12. backup restoration remains distinct from replay;
13. archive may provide longer-term recovery with additional restoration cost;
14. recovery-source independence is evaluated against the failure domain;
15. invalidated state is not selected merely because it is newer or easier to recover;
16. last successful state remains distinguishable from last known-trustworthy state;
17. recovery normally begins upstream of the defect being corrected;
18. historical version compatibility is considered before reconstruction;
19. historical reproduction remains distinct from historical restatement using current logic;
20. recovery operations preserve classification, privacy, and access governance;
21. retention decisions explicitly affect available recovery paths;
22. recovery-source selection influences achievable RPO and RTO;
23. recovery escalation is deliberate when a preferred source becomes unavailable or insufficient;
24. significant source-selection decisions remain traceable;
25. recovery-source capabilities are considered demonstrated only after controlled validation and evidence.

---

## 9. Replay

Replay is the controlled re-consumption of previously retained events from an earlier processing position.

Atlas Engineering uses replay when the required event history remains available and trustworthy and a downstream processing responsibility must consume that history again.

The governing model is:

**Retained Event History → Select Replay Boundary → Re-consume Events → Process Idempotently → Validate Result**

Replay does not recreate events that no longer exist.

It uses events that remain available in a governed retained source, primarily Kafka for normal event replay.

### 9.1 Replay Purpose

Replay may be used to:

- recover interrupted downstream processing;
- recover a processing gap;
- reproduce downstream state from retained events;
- validate restart and idempotency behavior;
- recover after checkpoint or offset problems;
- reconstruct Bronze when required Kafka history remains available;
- intentionally revisit a bounded historical event interval.

Replay is appropriate when the required historical events already exist and can be consumed again.

### 9.2 Replay Source

Kafka is the preferred source for normal replay while the required event history remains:

- retained;
- complete for the required interval;
- interpretable;
- trustworthy.

Kafka provides replay through retained event history independently of the current consumer position.

Replay from another historical event representation may be possible where explicitly designed, but it must preserve equivalent governed semantics.

### 9.3 Replay Boundary

A replay must define where historical consumption begins.

Depending on the implementation, the boundary may be identified by:

- topic;
- partition;
- offset;
- timestamp mapped to offsets;
- event identifier;
- known processing checkpoint;
- bounded event interval.

The replay boundary must be explicit.

The platform must not begin historical replay from an arbitrary earlier point without understanding the resulting processing scope.

### 9.4 Replay End Boundary

A replay should also define when the historical replay interval is complete.

Possible end boundaries include:

- specific offset;
- processing checkpoint;
- timestamp-derived boundary;
- event interval;
- transition to current processing.

An unbounded replay may unintentionally consume more history than intended.

Where a bounded recovery objective exists, both the start and end boundaries should be known.

### 9.5 Replay Versus Restart

Restart resumes a component from its committed processing progress.

Replay intentionally moves processing to an earlier retained input position.

Conceptually:

**Restart**
→ continue from committed progress.

**Replay**
→ revisit previously available input.

A restart may naturally produce limited redelivery around a commit boundary.

That does not automatically constitute an intentional replay.

### 9.6 Replay Versus Retry

Retry repeats a failed operation.

Replay re-consumes historical input.

For example:

**Temporary Bronze Write Failure**
→ retry the failed write.

**Bronze Processing Gap Across Retained Kafka Offsets**
→ replay the affected Kafka interval.

Retry normally addresses one failed operation or bounded execution attempt.

Replay addresses historical input consumption.

### 9.7 Replay Versus Reprocessing

Replay and reprocessing may occur together, but they describe different concerns.

**Replay**
→ how historical input is delivered again.

**Reprocessing**
→ historical input is intentionally processed again to regenerate or correct derived state.

For example:

**Kafka offsets 100–500 consumed again**
→ replay.

**Those events executed through corrected Silver logic**
→ reprocessing.

The distinction allows recovery evidence to explain both the input mechanism and the processing objective.

### 9.8 Replay Versus Backfill

Replay uses events that already exist in the governed retained event history.

Backfill introduces required data into downstream processing when the necessary historical state cannot be obtained through ordinary retained event replay.

Therefore:

**Required Kafka Events Available**
→ replay may be appropriate.

**Required Kafka Events Never Existed or No Longer Exist**
→ replay alone cannot recover them.

A controlled backfill may then be required.

### 9.9 Replay Versus Rebuild

Replay revisits retained input.

Rebuild reconstructs a derived state from an appropriate upstream recovery boundary.

A rebuild may use replay as part of its mechanism, but the concepts remain distinct.

For example:

**Rebuild Bronze from Kafka**
→ rebuild objective + Kafka replay mechanism.

**Rebuild Gold from Silver**
→ rebuild without Kafka replay.

### 9.10 Replay and At-Least-Once Processing

Replay intentionally causes previously seen logical input to be processed again.

The platform must therefore assume repeated delivery.

Correctness depends on:

- stable input identity;
- explicit processing scope;
- idempotent behavior;
- controlled progress;
- validation.

Replay must not rely on the assumption that historical input will somehow be recognized automatically without an implemented deduplication or idempotency strategy.

### 9.11 Replay and Idempotency

A replay may encounter downstream state already produced by the original processing.

The implementation must determine the intended behavior.

Depending on the layer, replay may:

- detect an existing logical event and avoid an additional business effect;
- deterministically overwrite equivalent derived state;
- regenerate an isolated target;
- populate a new processing version;
- rebuild a clean target state.

The replay design must make this behavior explicit.

### 9.12 Replay and Existing Output

Before replay begins, the recovery procedure should determine what existing downstream output will happen when the same input is processed again.

Possible strategies include:

**Preserve Existing Output**
→ replay processing must be idempotent against it.

**Replace Controlled Scope**
→ affected derived state is cleared or replaced through a governed operation.

**Write New Version**
→ replay produces a separate candidate or processing version.

The strategy depends on the affected layer and recovery objective.

### 9.13 Replay and Kafka Offsets

Kafka offsets provide a precise partition-specific replay boundary.

A replay procedure should identify:

- topic;
- partition;
- original committed offset;
- selected replay start offset;
- intended end boundary;
- consumer identity or replay mechanism.

Offsets must not be reset casually in a shared consumer context.

A replay action can affect substantial downstream processing and must remain controlled and attributable.

### 9.14 Replay Consumer Strategy

Replay may use the ordinary processing consumer or a dedicated controlled recovery execution depending on implementation.

A dedicated replay context may provide advantages such as:

- isolation from live processing;
- explicit historical boundaries;
- independent progress;
- safer validation;
- reduced risk of altering ordinary consumer checkpoints.

The Version 1 implementation should select the simplest mechanism that preserves correct and observable behavior.

### 9.15 Replay and Live Processing

Replay may occur while new events continue to arrive.

The architecture must define how historical and live processing interact.

Possible approaches include:

- pause live processing during replay;
- replay through an isolated execution and reconcile before promotion;
- process historical backlog until the consumer catches up naturally;
- create a new derived version from replayed history.

The selected approach must prevent uncontrolled interleaving from producing inconsistent state.

### 9.16 Replay Ordering

Replay must preserve the ordering guarantees required by the affected processing logic.

Kafka ordering is defined within a partition.

Replay must therefore respect:

- partition identity;
- event order within the partition;
- business semantics that depend on sequence.

The architecture must not assume global ordering across independent Kafka partitions unless an explicit mechanism provides it.

### 9.17 Replay Scope

Replay should use the smallest historical scope that safely satisfies the recovery objective.

Possible scopes include:

- one record where independently addressable;
- one partition interval;
- one entity;
- one time interval;
- one topic;
- complete retained history.

Unnecessarily broad replay increases:

- processing cost;
- recovery time;
- duplicate exposure;
- validation scope.

An overly narrow replay may fail to reconstruct dependent state correctly.

### 9.18 Replay and Dependencies

The required replay scope may extend beyond the directly failed input when downstream logic depends on surrounding historical context.

For example, processing may depend on:

- previous entity state;
- sequence of changes;
- reference data valid at the time;
- dimensional history;
- preceding events.

Replay boundaries must therefore reflect processing semantics rather than only the single event that exposed the problem.

### 9.19 Replay and Historical Contracts

Replayed events must remain interpretable according to their applicable event contracts.

If retained Kafka history contains multiple contract versions, replay must preserve version-aware interpretation.

The platform must not silently interpret an older event using incompatible current assumptions.

Historical contract compatibility is part of replay recoverability.

### 9.20 Replay and Processing Versions

Replay does not by itself determine which processing version should handle the historical events.

Possible objectives include:

**Historical Reproduction**
→ replay through the historically applicable processing definition.

**Historical Restatement**
→ replay through a corrected or current processing definition.

The selected processing version must be explicit and preserved in lineage.

### 9.21 Replay and Schema Evolution

Schema evolution must not make retained events unusable for replay.

Where historical events use older schemas or contract versions, the platform must preserve enough interpretation logic to process them according to the intended recovery objective.

A breaking change that makes retained recovery history uninterpretable reduces recoverability even if the events remain physically present.

### 9.22 Replay and Deleted or Changed Source State

Replay uses the historical event as retained.

It must not assume that current AtlasCommerce state still matches the state represented when the event was produced.

For example, an entity may have:

- changed;
- been deactivated;
- been deleted;
- received later attributes.

Replay must preserve the semantics of the retained event unless the recovery objective explicitly defines historical restatement using current information.

### 9.23 Replay and Bronze

Kafka replay is particularly important for Bronze recovery.

Where the required Kafka history remains retained:

**Bronze Failure or Gap**
→ select affected Kafka interval  
→ replay events  
→ persist Bronze correctly  
→ validate continuity.

Bronze should preserve source-event identity and metadata sufficient to demonstrate the relationship between replayed Kafka input and persisted historical state.

### 9.24 Replay and Silver

Silver may be reconstructed from Bronze without requiring Kafka replay.

If the recovery objective is entirely downstream of valid Bronze, replaying Kafka adds unnecessary scope.

Kafka replay should therefore not become the default response to every Silver problem.

The appropriate upstream trustworthy boundary should determine the recovery mechanism.

### 9.25 Replay and Gold

Gold recovery normally uses valid Silver rather than Kafka replay.

Kafka replay may indirectly participate in a broader reconstruction when upstream state must first be recovered.

For example:

**Bronze Invalid**
→ replay Kafka  
→ reconstruct Bronze  
→ reprocess Silver  
→ rebuild Gold.

This is a compound recovery sequence, not simply a Gold replay.

### 9.26 Replay and Certified Gold

Certified Gold should not be directly reconstructed through uncontrolled event replay.

Historical replay may produce new downstream candidate state.

That state must still pass:

- processing completion;
- quality validation;
- reconciliation;
- lineage requirements;
- certification;
- controlled publication.

Replay never bypasses certification.

### 9.27 Replay and Checkpoints

Replay intentionally revisits progress earlier than the ordinary committed position.

The platform must distinguish:

**Normal Processing Checkpoint**

from:

**Replay Processing Position**

where necessary.

A replay must not accidentally overwrite ordinary progress in a way that causes unintended long-term reprocessing or skipped live input.

### 9.28 Replay and Consumer Groups

Kafka consumer-group state must be handled carefully during replay.

Possible implementation approaches may include:

- controlled offset reset;
- dedicated replay consumer group;
- isolated recovery consumer;
- temporary processing context.

The selected mechanism must avoid unintended interference with unrelated consumers.

The architecture should prefer explicit isolation when replay behavior could alter normal consumer progress.

### 9.29 Replay and Retention

Replay capability exists only while the required event history remains retained.

The replay window is therefore bounded by Kafka retention.

A replay request must determine whether the complete required interval still exists before execution begins.

If part of the interval has expired, replaying only the remaining portion may produce incomplete downstream state.

The recovery strategy must then escalate to another source.

### 9.30 Replay Window Exhaustion

When the required Kafka interval is no longer fully available:

**Kafka Replay**
→ no longer sufficient.

The next appropriate recovery source may be:

- Bronze;
- AtlasCommerce through controlled backfill;
- backup or archive;
- another governed historical source.

The correct choice depends on which state is missing and which layer must be recovered.

Replay must not silently proceed with an incomplete interval merely because some historical events remain.

### 9.31 Replay and Backlog

Replay creates processing workload in addition to ordinary live processing.

A large replay may therefore increase backlog or compete with current workloads.

Replay planning should consider:

- replay volume;
- current ingestion rate;
- available processing capacity;
- retention window;
- consumer freshness;
- downstream resource capacity.

Recovery must not unintentionally create a second operational incident through uncontrolled replay load.

### 9.32 Replay Throttling

Large replay operations may require controlled processing rates.

Throttling may help:

- protect downstream storage;
- protect shared dependencies;
- preserve live-processing capacity;
- reduce resource exhaustion;
- maintain observability.

The implementation should balance recovery speed against platform stability.

Maximum replay speed is not always the safest recovery speed.

### 9.33 Replay Failure

Replay itself may fail.

Possible causes include:

- historical contract incompatibility;
- processing defect;
- storage failure;
- invalid replay boundary;
- resource exhaustion;
- poison record;
- dependency failure.

Replay recovery must follow the same reliability principles as ordinary processing.

Repeated replay failure must not lead to uncontrolled checkpoint manipulation or repeated broad replay without investigation.

### 9.34 Replay Cancellation

A replay may need to be stopped when:

- the selected boundary is wrong;
- unexpected downstream effects appear;
- resource impact becomes unsafe;
- validation identifies incorrect output;
- a more appropriate recovery source is discovered.

Cancellation must preserve enough state to determine:

- what replay work completed;
- what output was produced;
- what must be cleaned up or invalidated;
- whether ordinary processing was affected.

### 9.35 Replay Validation

Replay validation should confirm, where applicable:

- correct replay source;
- complete required interval;
- expected start and end boundaries;
- correct event ordering;
- appropriate processing version;
- no unintended processing gap;
- no unintended duplicate business effect;
- expected downstream record counts;
- quality results;
- reconciliation results;
- checkpoint integrity;
- lineage;
- certification state;
- final freshness.

A replay command completing successfully does not prove recovery correctness.

### 9.36 Replay Evidence

Representative replay evidence should preserve:

- recovery objective;
- topic;
- partition or partitions;
- replay start boundary;
- replay end boundary;
- event count or interval;
- original processing position;
- replay execution identifier;
- processing version;
- observed duplicate delivery;
- duplicate-handling result;
- downstream state before replay;
- downstream state after replay;
- validation results;
- elapsed time;
- final conclusion.

Evidence should allow another reviewer to understand exactly what history was revisited and why.

### 9.37 Replay Test Scenarios

Version 1 should validate representative replay scenarios such as:

**Replay Test 1 — Consumer Interruption**
→ stop Bronze consumption  
→ allow Kafka backlog to accumulate  
→ restore consumer  
→ verify processing resumes from committed progress.

**Replay Test 2 — Controlled Historical Replay**
→ select a previously processed Kafka interval  
→ replay it intentionally  
→ verify idempotent downstream behavior.

**Replay Test 3 — Partition-Specific Replay**
→ replay a bounded interval from one partition  
→ verify unaffected partitions remain correct.

**Replay Test 4 — Retention Boundary**
→ demonstrate the relationship between retained Kafka history and the available replay window without intentionally destroying required project data.

The exact tests should be implemented according to the final Version 1 topology.

### 9.38 Replay Guarantees

The Atlas Engineering replay model must preserve the following guarantees:

1. replay is the controlled re-consumption of previously retained input;
2. replay remains distinct from restart, retry, reprocessing, backfill, and rebuild;
3. Kafka is the preferred replay source while the required history remains retained and trustworthy;
4. replay start and end boundaries are explicit where a bounded recovery scope exists;
5. replay does not claim to recreate events that are no longer available;
6. replay assumes repeated delivery and therefore depends on idempotent processing;
7. existing downstream output is evaluated before historical input is processed again;
8. Kafka replay preserves partition-specific ordering semantics;
9. replay scope is the smallest safe scope capable of satisfying the recovery objective;
10. historical dependencies are considered when selecting replay boundaries;
11. historical event contracts remain interpretable;
12. the processing version used for replay is explicit;
13. schema evolution does not silently invalidate retained replay history;
14. current source state is not substituted for historical event semantics without an explicit restatement decision;
15. Kafka replay is used for Bronze recovery only when the required event interval remains complete;
16. valid Bronze or Silver state is preferred over unnecessary Kafka replay for downstream-only recovery;
17. replay never bypasses Gold certification or controlled publication;
18. replay progress does not unintentionally corrupt ordinary consumer progress;
19. consumer-group changes used for replay are controlled and attributable;
20. replay capability remains bounded by retention;
21. incomplete retained intervals trigger recovery-source escalation rather than partial silent recovery;
22. replay workload is controlled to avoid destabilizing normal processing;
23. replay failures and cancellation remain recoverable and observable;
24. replay results are validated for processing and data correctness;
25. representative replay behavior is demonstrated through controlled evidence.

---

## 10. Reprocessing

Reprocessing is the controlled execution of historical input through a processing definition after that input has already been processed previously.

Atlas Engineering uses reprocessing when an existing derived state must be recalculated, corrected, restated, or validated using historical governed input.

The governing model is:

**Historical Governed Input → Select Processing Definition → Define Reprocessing Scope → Execute Again → Validate Derived State → Preserve Lineage**

Reprocessing is concerned with the repeated execution of processing logic.

It does not by itself define how historical input is obtained.

Historical input may be supplied through:

- Kafka replay;
- Bronze historical data;
- Silver persisted state;
- controlled backfill;
- another governed recovery source appropriate to the objective.

### 10.1 Reprocessing Purpose

Reprocessing may be required when:

- a transformation defect is corrected;
- a business rule changes;
- a historical interpretation must be restated;
- derived data is incomplete;
- a previous processing execution produced incorrect results;
- a processing version changes;
- quality or reconciliation identifies historical inconsistency;
- downstream state must be regenerated;
- a recovery test intentionally validates reproducibility.

Reprocessing should have an explicit reason and bounded objective.

It must not become an undocumented routine for correcting unexplained data differences.

### 10.2 Reprocessing Versus Replay

Replay and reprocessing describe different parts of a recovery operation.

**Replay**
→ historical input is delivered again from retained event history.

**Reprocessing**
→ historical input is executed again through processing logic.

For example:

**Kafka Offsets Re-consumed**
→ replay.

**Replayed Events Processed Through Corrected Bronze or Silver Logic**
→ reprocessing.

Reprocessing may therefore occur with or without Kafka replay.

### 10.3 Reprocessing Versus Restart

Restart resumes interrupted processing from committed progress.

Reprocessing intentionally revisits input that was already considered processed.

A restart may cause limited redelivery around a commit boundary.

That does not automatically constitute governed historical reprocessing.

### 10.4 Reprocessing Versus Retry

Retry repeats an operation because the previous attempt failed or produced an uncertain outcome.

Reprocessing intentionally executes historical input again even though previous processing may have completed.

Conceptually:

**Retry**
→ try to complete the intended operation.

**Reprocessing**
→ intentionally calculate the historical result again.

### 10.5 Reprocessing Versus Backfill

Reprocessing operates on historical input that is already available through a governed recovery source.

Backfill provides required historical data when the normal retained processing history is unavailable or insufficient.

A backfill may subsequently be reprocessed through downstream logic.

The two operations must remain separately identifiable in lineage and evidence.

### 10.6 Reprocessing Versus Rebuild

Reprocessing executes historical input again.

Rebuild reconstructs a derived state.

A rebuild commonly uses reprocessing as part of its implementation.

For example:

**Bronze History**
→ reprocess Silver  
→ reconstruct complete Silver state.

The objective is a Silver rebuild.

The repeated execution of Bronze through Silver logic is reprocessing.

### 10.7 Reprocessing Source

Reprocessing must begin from an appropriate trustworthy source.

Representative sources include:

- retained Kafka events;
- Bronze;
- Silver;
- controlled source backfill;
- restored backup or archive.

The correct source depends on which processing stage is being recalculated.

The recovery source must be upstream of the defect or invalid state being corrected.

### 10.8 Reprocessing Scope

Every reprocessing operation should define its intended scope.

Possible scopes include:

- one event;
- one entity;
- one partition;
- one business key;
- one date or time interval;
- one dataset;
- one processing version;
- one data product;
- complete retained history.

The smallest safe scope should normally be preferred.

The scope must still include all historical context required for correct processing.

### 10.9 Scope Dependencies

A defect observed in one record does not necessarily mean that only that record can safely be reprocessed.

Processing may depend on:

- preceding events;
- later events;
- entity history;
- reference data;
- effective dates;
- dimensional history;
- aggregation windows;
- related business entities.

The reprocessing scope must therefore be based on processing semantics rather than only on the visible symptom.

### 10.10 Reprocessing With the Same Logic

Historical input may be reprocessed using the same processing definition when the objective is to:

- recover missing derived output;
- reproduce a previous result;
- validate deterministic behavior;
- recover after derived-state loss;
- verify idempotency.

The expected logical result should remain equivalent when:

- input is equivalent;
- processing definition is equivalent;
- required dependencies are equivalent.

Unexpected differences require investigation.

### 10.11 Reprocessing With Corrected Logic

Historical input may be intentionally reprocessed after a processing defect is corrected.

Conceptually:

**Historical Input**
→ defective processing produced invalid state.

Then:

**Same Historical Input**
→ corrected processing definition  
→ corrected derived state.

The resulting state is a new governed processing result.

It must not be represented as though it were produced by the original defective implementation.

### 10.12 Reprocessing With New Logic

Reprocessing may also intentionally apply a new business or analytical definition to historical input.

For example:

**Historical Bronze**
→ Silver V2  
→ historical data restated according to the new standardized definition.

This is a historical restatement.

It differs from recovery intended merely to reproduce the original historical state.

The reason for applying new logic must remain explicit.

### 10.13 Historical Reproduction

Historical reproduction attempts to recreate the result that should have existed under the historically applicable processing definition.

It may require:

- historical schema;
- historical contract;
- historical transformation;
- historical reference state;
- historical quality rules;
- historical dimensional logic.

The objective is:

**Historical Input + Historical Applicable Definition → Historical Expected Result**

### 10.14 Historical Restatement

Historical restatement intentionally recalculates historical data using a newer or corrected definition.

The objective is:

**Historical Input + Selected New Definition → New Historical Result**

Restatement may legitimately change previously derived values.

The platform must preserve enough lineage to explain why the historical result changed.

### 10.15 Reprocessing Version Selection

Every governed reprocessing operation must know which processing definition is being applied.

Relevant version context may include:

- event contract;
- source schema;
- Bronze interpretation;
- Silver transformation;
- reference-data interpretation;
- Gold transformation;
- quality rules;
- reconciliation rules.

Version selection must be deliberate.

The platform must not silently apply whichever implementation happens to be deployed at the time.

### 10.16 Reprocessing and Determinism

Where the processing semantics are deterministic, equivalent input and equivalent processing definitions should produce equivalent intended results.

Conceptually:

**Same Governed Input**
+
**Same Processing Definition**
+
**Same Required Reference Context**
→ **Same Intended Result**

This property improves:

- reproducibility;
- recovery validation;
- defect investigation;
- auditability.

External or time-dependent behavior that can alter the result should be controlled or captured where required.

### 10.17 Reprocessing and Current Time

Processing logic should avoid using uncontrolled current-time values when historical correctness depends on the original business time.

For historical reprocessing, the distinction between:

- event time;
- source transaction time;
- ingestion time;
- processing time;
- reprocessing time;

may be important.

Reprocessing must not silently reinterpret historical business state merely because execution occurs at a later date.

### 10.18 Reprocessing and Reference Data

Historical results may depend on reference data.

If reference values change over time, reprocessing must determine whether the objective requires:

**Historical Reference State**
→ reproduce historical interpretation.

or:

**Current Reference State**
→ intentionally restate history.

The choice must be governed and traceable.

Using current reference data accidentally can produce a different historical result without any change to the primary historical input.

### 10.19 Reprocessing and Slowly Changing Dimensions

Gold dimensional processing may depend on historical validity intervals.

Reprocessing must preserve correct temporal semantics when reconstructing:

- dimension versions;
- surrogate-key relationships;
- effective dates;
- historical fact relationships.

Processing historical events in a different execution order or with incomplete context must not silently collapse or distort dimensional history.

### 10.20 Reprocessing and Existing State

Before reprocessing begins, the procedure must determine how existing derived state will be handled.

Possible strategies include:

**Idempotent Merge**
→ existing state remains and repeated processing converges to the intended result.

**Controlled Replacement**
→ affected scope is replaced.

**New Version**
→ reprocessing writes a separate candidate state.

**Complete Rebuild**
→ target derived state is reconstructed from a clean boundary.

The selected strategy depends on the processing layer and objective.

### 10.21 In-Place Reprocessing

In-place reprocessing modifies or replaces an existing derived state within its governed target.

It may be appropriate when:

- the affected scope is precisely known;
- processing is deterministic;
- rollback is available where required;
- partial exposure can be prevented;
- validation can prove correctness.

In-place correction must not expose consumers to an uncontrolled mixture of old and new state.

### 10.22 Versioned Reprocessing

Versioned reprocessing produces a separate derived version rather than modifying the currently governed state directly.

This approach is particularly useful for Gold.

Conceptually:

**Current Certified Gold V1**
→ remains consumer-visible.

Meanwhile:

**Historical Input**
→ corrected processing  
→ Gold Candidate V2  
→ validate  
→ certify  
→ publish.

Versioned reprocessing reduces the risk that recovery work directly damages the last known-good analytical state.

### 10.23 Reprocessing and Live Processing

Historical reprocessing may occur while live processing continues.

The architecture must define how both workloads interact.

Possible strategies include:

- pause affected live processing;
- isolate historical reprocessing;
- create a new derived version;
- process a bounded historical scope and reconcile before resuming;
- rebuild the affected state and perform controlled cutover.

The selected strategy must prevent historical and live execution from producing inconsistent overlapping state.

### 10.24 Reprocessing Isolation

Reprocessing should be isolated from unaffected processing where practical.

Isolation may occur by:

- dataset;
- entity;
- partition;
- processing version;
- execution;
- target path;
- candidate version.

Isolation reduces blast radius and simplifies validation.

It must not break dependencies required for correct historical reconstruction.

### 10.25 Reprocessing and Checkpoints

Historical reprocessing should not unintentionally corrupt ordinary live-processing checkpoints.

Where reprocessing uses historical input behind the normal committed position, it may require:

- independent checkpoint state;
- dedicated execution metadata;
- isolated consumer group;
- explicit historical interval.

Ordinary progress and reprocessing progress should remain distinguishable.

### 10.26 Reprocessing and Lineage

Reprocessed output must preserve lineage sufficient to identify:

- recovery or reprocessing execution;
- input source;
- input interval;
- input version;
- processing definition;
- output version;
- reason for reprocessing;
- validation result.

For corrected historical state, lineage should allow a reviewer to distinguish the original result from the corrected result.

### 10.27 Reprocessing and Quality

Reprocessed state remains subject to applicable quality controls.

Successful execution does not imply that the corrected output is acceptable.

Quality validation may need to evaluate:

- completeness;
- uniqueness;
- validity;
- consistency;
- temporal correctness;
- domain rules.

A reprocessing operation that reproduces the same quality defect has not restored trustworthy state.

### 10.28 Reprocessing and Reconciliation

Reconciliation is especially important when reprocessing modifies previously derived history.

The platform should determine whether the resulting state reconciles with the appropriate upstream boundary.

Depending on the recovery objective, reconciliation may compare:

- original versus reprocessed counts;
- source versus derived counts;
- business totals;
- entity populations;
- affected historical intervals;
- old versus new results.

Expected differences caused by corrected logic must be distinguishable from unexplained differences.

### 10.29 Expected Differences

Corrected or new logic may intentionally change historical results.

A difference from the previous output is therefore not automatically a failure.

The reprocessing plan should identify:

- what is expected to change;
- why it should change;
- which scope should remain unchanged;
- how the expected difference will be validated.

Unexpected changes outside the intended scope require investigation.

### 10.30 Reprocessing and Certification

Reprocessed Gold state must pass the same governed certification boundary required for ordinary Gold publication.

The flow remains:

**Reprocessed Gold Candidate**
→ quality  
→ reconciliation  
→ lineage validation  
→ certification  
→ publication.

Historical correction does not justify bypassing certification.

### 10.31 Reprocessing Failure

Reprocessing may itself fail.

Possible causes include:

- incomplete historical input;
- incompatible historical contract;
- incorrect version selection;
- processing defect;
- dependency failure;
- resource exhaustion;
- invalid reference context;
- poison data.

Failure must preserve enough state to determine:

- what scope completed;
- what output was produced;
- what remains invalid;
- whether retry is safe;
- whether the target must be discarded;
- whether another recovery source is required.

### 10.32 Partial Reprocessing Failure

A partially completed reprocessing operation must not silently become the accepted derived state.

Where atomic replacement is unavailable, the implementation must identify incomplete output and prevent uncontrolled publication.

Possible responses include:

- invalidate the candidate;
- discard the incomplete target;
- resume from a safe checkpoint;
- repeat the affected scope idempotently;
- rebuild the target.

The correct response depends on target semantics.

### 10.33 Reprocessing Cancellation

A reprocessing execution may be cancelled when:

- the selected scope is incorrect;
- unexpected output appears;
- resource impact becomes unsafe;
- the wrong processing version was selected;
- required historical context is missing.

Cancellation must preserve enough metadata to determine which output was produced and whether cleanup or invalidation is required.

### 10.34 Reprocessing Resource Impact

Historical reprocessing may consume substantial:

- CPU;
- memory;
- Kafka bandwidth;
- storage bandwidth;
- object-storage operations;
- database capacity;
- orchestration capacity.

Large reprocessing operations should therefore consider their impact on live workloads.

Fast historical reconstruction must not unnecessarily destabilize current processing.

### 10.35 Reprocessing Priority

Reprocessing priority should reflect the business and reliability impact of the state being corrected.

Relevant factors include:

- correctness impact;
- affected consumer;
- affected historical interval;
- data classification;
- publication state;
- availability of known-good Certified Gold;
- recovery-window constraints;
- resource requirements.

Not every historical correction requires immediate full-platform processing.

### 10.36 Reprocessing Validation

Validation should confirm, where applicable:

- correct recovery source;
- complete input scope;
- correct processing version;
- correct historical context;
- expected output scope;
- no unintended duplicate business effects;
- no processing gaps;
- expected historical changes;
- no unexplained changes outside scope;
- quality results;
- reconciliation results;
- lineage;
- checkpoint integrity;
- certification state.

Reprocessing is complete only when the resulting state is demonstrated to satisfy its intended objective.

### 10.37 Reprocessing Evidence

Representative reprocessing evidence should preserve:

- reason for reprocessing;
- affected layer;
- input source;
- historical interval;
- original processing version;
- selected processing version;
- expected differences;
- execution identifier;
- output version;
- record counts;
- quality results;
- reconciliation results;
- observed differences;
- elapsed time;
- final certification or recovery state.

Evidence should make the historical correction reproducible and explainable.

### 10.38 Reprocessing Test Scenarios

Version 1 should validate representative scenarios such as:

**Reprocessing Test 1 — Same Logic**
→ select a bounded historical Bronze interval  
→ process it again using the same Silver definition  
→ demonstrate equivalent intended result.

**Reprocessing Test 2 — Corrected Logic**
→ introduce or simulate a known transformation defect  
→ preserve the invalid result as evidence  
→ correct the transformation  
→ reprocess the affected history  
→ demonstrate the corrected result.

**Reprocessing Test 3 — Scope Isolation**
→ reprocess one bounded entity or historical interval  
→ demonstrate that unrelated state remains unchanged.

**Reprocessing Test 4 — Gold Candidate**
→ reprocess valid Silver through a changed Gold definition  
→ generate a new candidate  
→ validate and certify before publication.

The exact scenarios should reflect the final Version 1 implementation.

### 10.39 Reprocessing Guarantees

The Atlas Engineering reprocessing model must preserve the following guarantees:

1. reprocessing is the intentional repeated execution of historical governed input;
2. reprocessing remains distinct from restart, retry, replay, backfill, and rebuild;
3. historical input may be obtained from different trustworthy recovery sources;
4. every reprocessing operation has an explicit objective and scope;
5. reprocessing begins from a boundary upstream of the state or logic being corrected;
6. processing dependencies determine the minimum safe historical scope;
7. same-input and same-definition reprocessing should produce the same intended result where processing is deterministic;
8. corrected logic may intentionally produce a new historical result;
9. historical reproduction remains distinct from historical restatement;
10. processing-version selection is explicit;
11. uncontrolled current-time behavior does not silently alter historical semantics;
12. historical reference context is preserved or intentionally replaced according to the objective;
13. temporal and dimensional history remains correct during reconstruction;
14. existing target state is handled through an explicit strategy;
15. versioned reprocessing protects known-good consumer-visible state where appropriate;
16. historical and live processing interaction is controlled;
17. reprocessing progress does not unintentionally alter ordinary live-processing progress;
18. reprocessed output preserves lineage to its input, processing definition, and recovery execution;
19. quality controls apply to reprocessed state;
20. reconciliation distinguishes expected corrections from unexplained differences;
21. reprocessed Gold remains subject to certification;
22. partial or failed reprocessing does not silently become accepted state;
23. cancelled reprocessing remains traceable and recoverable;
24. resource impact is considered before large historical executions;
25. reprocessing results are validated and supported by controlled evidence.

---

## 11. Backfill

Backfill is the controlled introduction or reconstruction of historical data into the analytical processing path when the required state cannot be obtained completely through ordinary retained event replay.

Atlas Engineering uses backfill when historical or current operational information must be extracted from an appropriate governed source and incorporated into downstream processing to fill a known gap, initialize required history, or restore state that is no longer available through the normal retained event path.

The governing model is:

**Identify Missing or Required Historical State → Select Governed Source → Define Backfill Scope → Extract → Introduce Through Controlled Processing → Reconcile → Validate → Preserve Lineage**

Backfill must be explicit, bounded, traceable, and governed.

It must not become an undocumented alternative ingestion path.

### 11.1 Backfill Purpose

Backfill may be required when:

- required Kafka history has expired;
- required events were never produced;
- a capture gap prevented data from entering the analytical platform;
- a newly introduced dataset requires historical initialization;
- a new attribute requires historical population;
- retained downstream history is incomplete;
- current operational state can restore a required analytical state;
- a bounded historical interval must be recovered from another governed source.

Backfill should address a defined historical requirement.

It must not be used merely because ordinary recovery procedures are inconvenient.

### 11.2 Backfill Versus Replay

Replay consumes historical events that already exist in a retained event source.

Backfill obtains required data from another governed source because ordinary retained event replay cannot completely satisfy the recovery objective.

Conceptually:

**Required Kafka History Available**
→ replay.

**Required Kafka History Missing or Never Produced**
→ evaluate backfill.

Backfill must not be described as replay when the original retained event history does not exist.

### 11.3 Backfill Versus Reprocessing

Backfill and reprocessing describe different responsibilities.

**Backfill**
→ obtains and introduces required historical data.

**Reprocessing**
→ executes historical data through processing logic again.

A backfill may subsequently require reprocessing through Bronze, Silver, Gold, or another governed stage.

The source-recovery action and the downstream processing action must remain distinguishable.

### 11.4 Backfill Versus Rebuild

Backfill fills a missing or required historical input scope.

Rebuild reconstructs a derived state.

A rebuild may use backfilled data as part of its input.

For example:

**Missing Historical Source State**
→ backfill from AtlasCommerce  
→ persist governed historical input  
→ reprocess Silver  
→ rebuild Gold.

The complete recovery contains multiple mechanisms with different responsibilities.

### 11.5 Backfill Versus Restart and Retry

Restart resumes interrupted execution.

Retry repeats a failed operation.

Backfill introduces historical state that ordinary execution can no longer obtain sufficiently from its normal retained path.

Neither restart nor retry can recreate historical input that is no longer available to the affected processing stage.

### 11.6 Backfill Source

A backfill must use an explicitly governed source.

Representative sources may include:

- AtlasCommerce;
- restored source backup;
- governed historical extract;
- archive;
- another validated authoritative source introduced by future architecture.

The source must be appropriate for the data being reconstructed.

Convenient availability is not sufficient.

### 11.7 AtlasCommerce Backfill

AtlasCommerce may provide backfill data when its operational state can satisfy the recovery objective.

A controlled source backfill should minimize impact on the transactional system.

The extraction strategy should consider:

- business scope;
- required columns;
- query cost;
- indexing;
- source workload;
- extraction interval;
- consistency;
- isolation;
- execution timing.

Backfill must not transform AtlasCommerce into a routine analytical query platform.

### 11.8 Current-State Backfill

A current-state backfill reconstructs downstream state from the operational state that exists at extraction time.

This may be appropriate when the recovery objective requires the current business representation.

For example:

**Missing Current Customer State**
→ extract current governed customer state  
→ populate required downstream representation.

Current-state backfill does not reproduce historical changes that are no longer represented in the source.

### 11.9 Historical Backfill

Historical backfill attempts to recover information for a past interval or past business state.

It requires a source that actually preserves the required historical information.

Possible sources may include:

- source history tables where implemented;
- retained operational history;
- backup;
- archive;
- another governed historical dataset.

The platform must not infer historical events from current state when the required historical semantics cannot be established.

### 11.10 Snapshot Backfill

A snapshot backfill captures the state of an entity or dataset at a defined point or extraction boundary.

Snapshot backfill may support:

- initial platform population;
- new dataset onboarding;
- current-state reconstruction;
- recovery after loss of downstream state.

A snapshot represents state.

It does not automatically represent the sequence of changes that produced that state.

### 11.11 Event Backfill

Where sufficient historical change information exists outside the ordinary Kafka retention window, a backfill may reconstruct event-like historical input.

Such reconstruction must preserve, where possible:

- source identity;
- business key;
- historical ordering;
- event or transaction time;
- operation semantics;
- source version;
- backfill provenance.

Synthetic event reconstruction must not be represented as original captured CDC events when it was produced through a different mechanism.

### 11.12 Original Event Versus Reconstructed Event

Atlas Engineering must distinguish:

**Original Captured Event**
→ produced through the normal CDC and Debezium path.

**Reconstructed Historical Event**
→ generated later from another governed source to recover missing historical information.

Both may support downstream processing.

Their provenance is different and must remain visible in metadata and lineage.

### 11.13 Backfill Scope

Every backfill must define its scope.

Relevant dimensions may include:

- entity;
- business key;
- source table;
- date interval;
- transaction interval;
- geographic scope;
- data product;
- missing attribute;
- affected downstream layer.

The smallest safe scope should normally be preferred.

The scope must still contain all information required to restore correct downstream state.

### 11.14 Backfill Boundary

A backfill should define explicit start and end boundaries where the recovery objective is interval-based.

Possible boundaries include:

- transaction time;
- business date;
- source identifier range;
- source version;
- known missing interval;
- snapshot point.

Unbounded extraction should not be the default response to a bounded recovery problem.

### 11.15 Gap Identification

Backfill should begin with evidence that identifies the missing or required state.

Gap evidence may come from:

- reconciliation;
- lineage;
- CDC continuity analysis;
- Kafka continuity analysis;
- processing metadata;
- source-versus-target comparison;
- quality controls;
- known historical onboarding requirements.

The platform should not execute historical backfill based only on an unexplained assumption that data may be missing.

### 11.16 Gap Boundaries

Where a missing interval is being recovered, the platform should determine as precisely as practical:

- last known-good state before the gap;
- first missing state;
- last missing state;
- first known-good state after the gap;
- affected entities;
- affected downstream outputs.

Precise boundaries reduce unnecessary extraction and simplify validation.

### 11.17 Backfill Completeness

A backfill must be complete for its defined recovery objective.

Partial historical availability must not silently be interpreted as complete recovery.

If only part of the required interval can be recovered, the result must remain explicitly incomplete until:

- another source supplies the missing state;
- the recovery objective is formally revised;
- an accepted limitation is documented and governed.

### 11.18 Backfill Consistency

Source extraction may occur while AtlasCommerce continues changing.

The backfill strategy must therefore consider whether the required recovery objective needs:

- point-in-time consistency;
- transactionally consistent extraction;
- bounded business consistency;
- current-state approximation.

The required consistency depends on the use case.

The architecture must not claim point-in-time recovery when the extraction mechanism does not provide it.

### 11.19 Backfill and Concurrent Changes

A backfill may overlap with new live changes entering through CDC and Kafka.

Without controlled handling, the same business state may arrive through both:

**Backfill Path**

and:

**Live Event Path**

The architecture must prevent this overlap from creating:

- duplicate business effects;
- incorrect ordering;
- older state overwriting newer state;
- missing transitions.

### 11.20 Backfill Cutoff

Where backfill and live processing overlap, an explicit cutoff may be required.

Conceptually:

**Historical Backfill**
→ process state up to defined boundary.

**Live CDC Processing**
→ continue from the corresponding subsequent boundary.

The cutoff must be based on a meaningful source or processing position where technically possible.

Wall-clock approximation alone may be insufficient for precise recovery.

### 11.21 Backfill and Idempotency

Backfilled data may overlap with state already present downstream.

Processing must therefore tolerate duplicate logical representation where overlap is possible.

Possible mechanisms include:

- stable business keys;
- source identifiers;
- merge logic;
- version comparison;
- deterministic replacement;
- controlled target reconstruction.

Backfill must not assume that the downstream target is empty unless that condition is explicitly established.

### 11.22 Backfill and Ordering

Historical processing may depend on change order.

If the backfill source preserves only current state, historical ordering cannot be reconstructed automatically.

If historical changes are available, the backfill should preserve the ordering semantics required by downstream processing.

Where ordering cannot be established, the recovery objective must be limited accordingly.

### 11.23 Backfill and Event Time

Backfilled historical data should preserve meaningful business and source timestamps where available.

The platform must distinguish:

- original business time;
- source transaction time;
- reconstructed event time;
- backfill extraction time;
- backfill processing time.

The time at which a backfill executes must not silently become the historical business time.

### 11.24 Backfill and Schema

Backfill extraction must define the schema used to represent the recovered data.

Where the source schema differs from the historical event contract, the mapping must be explicit.

The platform must not imply that a backfill extracted directly from AtlasCommerce is structurally identical to an original Debezium event unless that equivalence is deliberately implemented and validated.

### 11.25 Backfill and Contract Version

If backfilled data is introduced into an event-oriented processing path, the applicable contract must be explicit.

Possible approaches include:

- map source data into a current governed backfill contract;
- reconstruct a historically applicable event representation where sufficient information exists;
- process the backfill through a dedicated governed ingestion contract.

The selected approach must preserve provenance and compatibility.

### 11.26 Backfill Provenance

Every governed backfill should preserve enough provenance to identify:

- source;
- extraction mechanism;
- extraction time;
- source boundary;
- business scope;
- historical interval;
- backfill execution;
- processing contract;
- resulting downstream state.

Backfilled data must remain distinguishable from ordinary live ingestion where that distinction matters for auditability and recovery.

### 11.27 Backfill and Bronze

Where appropriate, backfilled data should enter a governed historical boundary that preserves sufficient raw provenance before downstream transformation.

Bronze is the natural analytical historical foundation when the backfill is intended to participate in normal downstream reconstruction.

The implementation must distinguish backfilled records from original CDC-derived records where their provenance differs.

### 11.28 Backfill and Silver

Silver may consume backfilled Bronze state according to the applicable transformation definition.

If the backfill represents current-state data rather than historical events, Silver processing must respect that semantic difference.

A snapshot must not silently be treated as a complete event sequence.

### 11.29 Backfill and Gold

Backfilled data may ultimately affect Gold.

Any resulting Gold state remains subject to:

- dimensional correctness;
- quality;
- reconciliation;
- lineage;
- certification.

A successful backfill does not automatically authorize consumer publication.

### 11.30 Backfill and Certified Gold

Certified Gold should remain protected while historical backfill and downstream reconstruction occur.

Where possible:

**Current Certified Version**
→ remains consumer-visible.

Meanwhile:

**Backfill**
→ downstream processing  
→ new Gold candidate  
→ validation  
→ certification  
→ controlled publication.

This reduces consumer exposure to incomplete historical recovery.

### 11.31 Backfill and Historical Dimensions

Backfill affecting historical dimensional state requires special care.

A current-state snapshot may be insufficient to reconstruct:

- previous dimension versions;
- historical effective intervals;
- historical surrogate-key relationships;
- point-in-time fact relationships.

The recovery objective must explicitly state whether the backfill restores:

**Current Analytical State**

or:

**Historical Analytical State**

These are not equivalent guarantees.

### 11.32 Backfill and Deleted Records

Current source state may not contain records that existed historically and were later deleted.

A current-state backfill therefore cannot automatically reconstruct deleted historical entities.

Historical recovery requiring deleted state needs a source that preserves that history.

The absence of a record in the current source must not be interpreted as proof that the record never existed.

### 11.33 Backfill and Source Impact

Large backfill extraction can create operational risk for AtlasCommerce.

Potential impacts include:

- increased I/O;
- CPU consumption;
- long-running queries;
- blocking;
- transaction-log pressure;
- network load.

Backfill planning should minimize operational impact through appropriate:

- query design;
- indexing;
- batching;
- scheduling;
- throttling;
- scope reduction.

The analytical recovery objective must not unnecessarily destabilize the transactional source.

### 11.34 Backfill Batching

Large backfills may be divided into controlled batches.

Batch boundaries may use:

- key ranges;
- dates;
- transaction intervals;
- entity groups.

Batching can improve:

- restartability;
- observability;
- source protection;
- validation;
- resource control.

Each batch should preserve sufficient progress metadata to support safe continuation after interruption.

### 11.35 Backfill Restartability

A backfill may itself fail before completion.

The platform should be able to determine:

- which extraction batches completed;
- which downstream batches were committed;
- which scope remains;
- whether completed work may be safely repeated;
- where processing can resume.

Backfill restartability must follow the same durable-progress and idempotency principles used elsewhere in the platform.

### 11.36 Backfill Failure

Possible backfill failures include:

- source connectivity failure;
- query failure;
- extraction inconsistency;
- storage failure;
- mapping failure;
- contract incompatibility;
- downstream processing failure;
- resource exhaustion.

Failure must not convert a partially completed backfill into an implicitly complete recovery.

Incomplete state must remain identifiable.

### 11.37 Backfill Cancellation

A backfill may be cancelled when:

- the selected scope is incorrect;
- source impact becomes unsafe;
- the wrong source was selected;
- mapping proves invalid;
- unexpected overlap with live processing appears;
- downstream validation fails.

Cancellation must preserve enough metadata to determine:

- completed scope;
- incomplete scope;
- produced downstream state;
- cleanup or invalidation requirements.

### 11.38 Backfill and Security

Backfill may create temporary or additional copies of operational data.

These copies remain subject to applicable:

- classification;
- access control;
- privacy;
- encryption;
- retention;
- auditability.

Recovery urgency does not justify uncontrolled export of AtlasCommerce data.

Temporary backfill artifacts should be governed and removed according to their intended lifecycle.

### 11.39 Backfill and Retention

Backfilled historical data must enter an appropriate retention model.

A temporary recovery extract should not automatically become a permanent unmanaged archive.

Conversely, data required for future governed reconstruction should not be deleted merely because the immediate backfill completed.

Retention must reflect the architectural role of the resulting state.

### 11.40 Backfill and Lineage

Lineage must distinguish backfilled state from ordinary captured history where relevant.

A reviewer should be able to determine:

- why the backfill occurred;
- which source supplied it;
- which historical interval was affected;
- which downstream layers were regenerated;
- which processing versions were used;
- which analytical products changed.

This distinction is important because reconstructed historical state may have different provenance from original CDC-captured history.

### 11.41 Backfill and Reconciliation

Backfill requires strong reconciliation because its purpose is often to restore known missing state.

Reconciliation may compare:

- source and extracted record counts;
- source and Bronze business keys;
- affected historical intervals;
- before-and-after missing populations;
- business totals;
- Silver populations;
- Gold measures.

The validation should demonstrate that the identified gap was actually addressed.

### 11.42 Expected Backfill Differences

A backfill may intentionally change downstream results.

The plan should identify:

- which records should appear;
- which values should change;
- which historical interval is affected;
- which downstream products should change;
- which state should remain unchanged.

Unexpected changes outside the intended scope require investigation.

### 11.43 Backfill Validation

Backfill validation should confirm, where applicable:

- correct governed source;
- correct extraction scope;
- complete required interval;
- appropriate source consistency;
- correct cutoff with live processing;
- no unintended duplicate business effects;
- correct ordering where required;
- preserved business timestamps;
- correct contract or mapping;
- provenance;
- Bronze persistence;
- downstream transformation;
- quality;
- reconciliation;
- lineage;
- Gold certification where applicable.

A completed extraction alone does not prove successful backfill.

### 11.44 Backfill Evidence

Representative backfill evidence should preserve:

- reason for backfill;
- identified gap;
- source;
- source boundary;
- extraction method;
- historical scope;
- cutoff;
- execution identifier;
- batch progress;
- record counts;
- mapping or contract version;
- downstream processing version;
- reconciliation results;
- quality results;
- elapsed time;
- final governed state.

Evidence should demonstrate both the need for the backfill and the correctness of the resulting recovery.

### 11.45 Backfill Test Scenarios

Version 1 should validate representative scenarios such as:

**Backfill Test 1 — Bounded Missing Scope**
→ identify a controlled missing downstream population  
→ extract the required scope from AtlasCommerce  
→ process it through the governed path  
→ demonstrate restoration through reconciliation.

**Backfill Test 2 — Live Overlap**
→ perform a controlled backfill while new source changes continue  
→ demonstrate that overlap does not create duplicate business effects or incorrect final state.

**Backfill Test 3 — Interrupted Backfill**
→ interrupt a multi-batch backfill  
→ resume from durable progress  
→ demonstrate correct final state without uncontrolled duplication.

**Backfill Test 4 — Current State Limitation**
→ use a controlled example to demonstrate that a current-state snapshot cannot reproduce historical transitions that are no longer present in the source.

The exact scenarios should reflect the final Version 1 implementation and must avoid unnecessary impact on AtlasCommerce.

### 11.46 Backfill Guarantees

The Atlas Engineering backfill model must preserve the following guarantees:

1. backfill is controlled introduction or reconstruction of historical data when ordinary retained replay cannot completely satisfy the objective;
2. backfill remains distinct from restart, retry, replay, reprocessing, and rebuild;
3. every backfill has an explicit reason, governed source, and bounded scope;
4. AtlasCommerce may support backfill without becoming a routine analytical query platform;
5. current-state backfill is not represented as historical event reconstruction;
6. historical backfill requires a source that actually preserves the required history;
7. snapshot state remains distinct from event history;
8. reconstructed events remain distinguishable from original captured events;
9. known gaps are identified before recovery scope is selected;
10. partial historical availability is not represented as complete recovery;
11. source consistency guarantees are stated according to the implemented extraction mechanism;
12. overlap between backfill and live processing is explicitly controlled;
13. backfill cutoff is based on a meaningful processing or source boundary where possible;
14. overlap does not create unintended duplicate business effects;
15. required historical ordering and business time are preserved where available;
16. source-to-processing schema and contract mappings are explicit;
17. backfill provenance remains traceable;
18. backfilled data enters a governed historical processing boundary where appropriate;
19. snapshot semantics are not silently treated as complete event semantics;
20. Gold affected by backfill remains subject to certification;
21. current Certified Gold may remain available while corrected candidate state is produced;
22. current-state backfill does not claim to reconstruct unavailable deleted or historical state;
23. backfill extraction minimizes unnecessary impact on AtlasCommerce;
24. large backfills may use restartable controlled batches;
25. interrupted or cancelled backfills remain identifiable and recoverable;
26. backfill does not weaken security, privacy, or retention controls;
27. lineage distinguishes reconstructed historical state from ordinary captured history where relevant;
28. reconciliation demonstrates that the intended missing state was restored;
29. unexpected changes outside the backfill scope require investigation;
30. backfill capability is considered demonstrated only after controlled validation and evidence.

---

## 12. Rebuild

Rebuild is the controlled reconstruction of a derived platform state from an appropriate trustworthy upstream recovery boundary.

Atlas Engineering uses rebuild when a derived state is lost, corrupted, invalidated, or intentionally replaced and can be reconstructed from governed upstream data and the applicable processing definitions.

The governing model is:

**Select Trustworthy Upstream Boundary → Define Rebuild Scope → Reconstruct Derived State → Validate → Certify Where Applicable → Replace or Publish Through Controlled Transition**

Rebuild is concerned with the reconstruction of state.

It may use:

- replay;
- reprocessing;
- backfill;
- backup restoration;

as part of the recovery sequence.

These mechanisms remain conceptually distinct.

### 12.1 Rebuild Purpose

Rebuild may be required when:

- derived storage is lost;
- derived state is corrupted;
- a processing defect invalidates previously produced output;
- historical logic must be corrected;
- a new processing definition requires full reconstruction;
- a dimensional model changes materially;
- reconciliation demonstrates that existing derived state cannot be trusted;
- a migration requires generation of a new governed version;
- recovery testing intentionally validates reconstructibility.

A rebuild must have an explicit reason and defined recovery objective.

### 12.2 Rebuild Versus Restart

Restart restores execution of a component from committed processing state.

Rebuild reconstructs data state.

For example:

**Silver Processor Stopped**
→ restart may be sufficient.

**Silver Storage Lost**
→ restart alone cannot recreate the missing persisted Silver state  
→ rebuild is required.

Component recovery and data-state reconstruction are therefore separate concerns.

### 12.3 Rebuild Versus Retry

Retry repeats a failed operation.

Rebuild reconstructs a derived state from a selected recovery boundary.

A failed rebuild operation may itself be retried, but retry does not define the rebuild objective.

### 12.4 Rebuild Versus Replay

Replay re-consumes retained historical events.

Rebuild reconstructs a derived state.

For example:

**Kafka → Replay Historical Events → Rebuild Bronze**

Here:

- replay is the input-delivery mechanism;
- Bronze reconstruction is the rebuild objective.

A Gold rebuild from valid Silver may require no Kafka replay at all.

### 12.5 Rebuild Versus Reprocessing

Reprocessing executes historical input through processing logic again.

Rebuild reconstructs the target state produced by that processing.

For example:

**Bronze**
→ reprocess historical input through Silver logic  
→ reconstruct Silver.

The repeated execution is reprocessing.

The complete reconstruction of Silver is the rebuild.

### 12.6 Rebuild Versus Backfill

Backfill introduces required historical input that is unavailable through ordinary retained replay.

Rebuild consumes an appropriate upstream state to reconstruct a derived target.

A rebuild may require backfill when the source needed for reconstruction is incomplete.

For example:

**Missing Historical Input**
→ backfill  
→ reconstruct Bronze or Silver  
→ rebuild Gold.

### 12.7 Rebuild Source

A rebuild must use an upstream state that remains trustworthy for the target being reconstructed.

Representative source relationships include:

**Kafka**
→ Bronze rebuild.

**Bronze**
→ Silver rebuild.

**Silver**
→ Gold rebuild.

**Gold Candidate / Previous Certified Version**
→ limited publication or rollback recovery where appropriate.

**Backup / Archive**
→ restoration of a required upstream foundation before reconstruction.

The recovery source must be upstream of the state being rebuilt.

### 12.8 Rebuild Scope

A rebuild may cover:

- one partition;
- one entity;
- one date interval;
- one dataset;
- one table;
- one dimensional subject area;
- one data product;
- one complete layer.

The smallest safe scope should normally be preferred.

The scope must still include all dependencies required for a correct result.

### 12.9 Full Rebuild

A full rebuild reconstructs the complete governed target state from a trusted upstream boundary.

Examples include:

- complete Silver reconstruction from retained Bronze history;
- complete Gold reconstruction from valid Silver;
- complete analytical product regeneration.

Full rebuild may be appropriate when:

- target state is broadly invalid;
- exact affected scope cannot be established confidently;
- target storage was lost;
- processing semantics changed globally;
- simpler partial recovery would be riskier than complete reconstruction.

Full rebuild generally increases recovery time and resource consumption.

### 12.10 Partial Rebuild

A partial rebuild reconstructs a bounded subset of the target state.

Possible scopes include:

- date range;
- business entity;
- partition;
- dimension;
- fact interval;
- data product.

Partial rebuild may reduce recovery time and platform impact.

It is appropriate only when the platform can determine the affected scope precisely and preserve correct dependencies outside that scope.

### 12.11 Rebuild Dependency Analysis

Before rebuilding a bounded scope, the platform must identify dependencies that may require broader reconstruction.

Dependencies may include:

- upstream historical intervals;
- reference state;
- dimensional history;
- conformed dimensions;
- aggregates;
- derived measures;
- downstream products;
- certification metadata.

A local symptom does not always imply a local rebuild.

### 12.12 Bronze Rebuild

Bronze rebuild may be required when Bronze state is:

- lost;
- incomplete;
- invalidated by persistence defects;
- intentionally reconstructed for validation.

Where the required Kafka history remains retained and trustworthy:

**Kafka**
→ controlled replay  
→ Bronze persistence  
→ continuity validation.

If required Kafka history no longer exists, Bronze rebuild may require:

- controlled backfill;
- another historical source;
- backup or archive.

Bronze must preserve provenance distinguishing original captured events from reconstructed historical input where applicable.

### 12.13 Silver Rebuild

Silver rebuild reconstructs standardized analytical state from a trustworthy upstream boundary, normally Bronze.

A representative flow is:

**Valid Bronze**
→ selected Silver processing version  
→ complete or partial Silver reconstruction  
→ quality validation  
→ lineage validation.

Silver rebuild may be appropriate when:

- Silver storage is lost;
- Silver processing logic was defective;
- Silver semantics change;
- downstream consistency cannot be restored safely through incremental correction.

### 12.14 Gold Rebuild

Gold rebuild reconstructs analytical dimensional state from trustworthy Silver input.

A representative flow is:

**Valid Silver**
→ selected Gold processing definition  
→ Gold candidate  
→ quality  
→ reconciliation  
→ certification  
→ controlled publication.

Gold rebuild should normally produce a new candidate rather than directly overwrite the current Certified Gold state.

### 12.15 Certified Gold Rebuild

Certified Gold is not rebuilt merely by writing directly to the consumer-visible structures.

Correct recovery follows:

**Trustworthy Upstream State**
→ rebuild Gold candidate  
→ validate  
→ reconcile  
→ certify  
→ publish atomically.

Certified Gold is a governed publication state.

Its reconstruction must preserve the certification boundary.

### 12.16 Rebuild From Backup

A rebuild may begin after backup restoration when the required online recovery foundation was lost.

For example:

**Bronze Storage Lost**
→ restore Bronze backup  
→ validate restored history  
→ rebuild Silver  
→ rebuild Gold as required.

Or:

**AtlasWarehouse Lost**
→ restore infrastructure or database state  
→ rebuild derived analytical state from valid Silver where appropriate.

Backup restore and rebuild are separate recovery actions.

### 12.17 Rebuild and Historical Versions

Rebuild requires explicit selection of the definitions used to interpret historical input.

Relevant versions may include:

- schema;
- event contract;
- Silver processing;
- Gold processing;
- reference data;
- quality rules;
- reconciliation rules.

A rebuild must not silently use incompatible current definitions simply because they are the easiest implementation available.

### 12.18 Historical Reproduction During Rebuild

A rebuild may seek to reproduce the state that should have existed under a historical definition.

The objective is:

**Historical Upstream State**
+
**Historical Applicable Logic**
→ **Historical Expected Derived State**

This may be required for:

- audit;
- reproducibility;
- historical comparison;
- investigation.

### 12.19 Historical Restatement During Rebuild

A rebuild may intentionally reconstruct historical state using corrected or current logic.

For example:

**Historical Silver**
→ corrected Gold V3  
→ complete historical Gold restatement.

The resulting state is a new governed analytical version.

Its lineage must explain that it was reconstructed using a different processing definition from the original state.

### 12.20 Rebuild Target Strategy

Before rebuild begins, the architecture must define how the target state will be produced.

Possible strategies include:

**In-Place Reconstruction**
→ existing target is rebuilt within its governed storage.

**Shadow Target**
→ a separate target is created and validated before replacement.

**Versioned Target**
→ a new target version is created.

For consumer-sensitive Gold recovery, shadow or versioned approaches generally provide stronger protection of the last known-good state.

### 12.21 In-Place Rebuild

In-place rebuild may be appropriate when:

- the target is not consumer-visible during reconstruction;
- failure isolation is sufficient;
- partial state cannot leak;
- restartability is defined;
- recovery scope is controlled.

The platform must prevent consumers from interpreting partially reconstructed state as complete.

### 12.22 Shadow Rebuild

A shadow rebuild reconstructs state separately from the currently governed target.

Conceptually:

**Current State**
→ remains unchanged.

Meanwhile:

**Upstream Trusted State**
→ rebuild shadow target  
→ validate  
→ reconcile  
→ promote.

This pattern reduces exposure to partial rebuild state.

### 12.23 Versioned Rebuild

A versioned rebuild creates a separate target version.

This is particularly useful for Gold and Certified Gold.

Example:

**Certified Gold V5**
→ remains available.

Meanwhile:

**Valid Silver**
→ Gold Candidate V6  
→ validation  
→ certification  
→ atomic publication.

Versioned rebuild supports:

- comparison;
- rollback;
- evidence;
- controlled promotion.

### 12.24 Rebuild and Live Processing

Live processing may continue while a rebuild is underway.

The architecture must define how new input interacts with the reconstruction.

Possible approaches include:

- pause affected live processing;
- rebuild to a defined cutoff and then catch up;
- isolate rebuild in a new version;
- continue live ingestion upstream while downstream reconstruction occurs.

The chosen strategy must prevent uncontrolled divergence between rebuilt historical state and current processing.

### 12.25 Rebuild Cutoff

Where a rebuild must converge with live processing, an explicit cutoff may be required.

Conceptually:

**Historical Reconstruction**
→ rebuild through boundary X.

Then:

**Incremental Processing**
→ continue from X+1 or equivalent subsequent boundary.

The cutoff should use a meaningful processing or source boundary rather than an approximate wall-clock value whenever possible.

### 12.26 Rebuild Catch-Up

After historical reconstruction reaches its defined cutoff, new accumulated input may still need to be processed.

The sequence may be:

**Historical Rebuild**
→ **Catch-Up Processing**
→ **Quality and Reconciliation**
→ **Certification**
→ **Publication**

The target must not be considered current merely because the historical reconstruction completed.

### 12.27 Rebuild and Idempotency

A rebuild may repeat processing already represented in part of the target.

Idempotent processing remains important when:

- partial rebuild restarts;
- historical scope overlaps existing state;
- catch-up processing overlaps reconstructed state;
- build execution is repeated.

Where idempotent merge is not appropriate, target replacement or version isolation should provide equivalent protection.

### 12.28 Rebuild Progress

Large rebuilds must expose durable progress.

Progress may include:

- reconstructed partitions;
- completed batches;
- processed historical intervals;
- entity ranges;
- current processing version;
- target version;
- remaining work.

A rebuild must not depend solely on one long-running process remaining alive until completion.

### 12.29 Rebuild Restartability

A rebuild may fail before completion.

The platform should be able to determine:

- which scope completed;
- which target state is durable;
- which work remains;
- whether completed work can be safely repeated;
- whether the partial target should be retained, resumed, or discarded.

Restartability should be designed before large rebuild capability is claimed.

### 12.30 Rebuild Failure

Possible rebuild failures include:

- source-history unavailable;
- incompatible historical version;
- transformation failure;
- storage failure;
- resource exhaustion;
- quality failure;
- reconciliation failure;
- dependency failure.

A failed rebuild must not become the governed target merely because a large portion completed successfully.

### 12.31 Partial Rebuild State

Partial rebuild state must remain distinguishable from complete governed state.

Possible handling includes:

- temporary path;
- candidate lifecycle state;
- explicit incomplete status;
- isolated schema or table;
- separate object prefix;
- version metadata.

Incomplete rebuild output must not cross the normal publication boundary.

### 12.32 Rebuild Cancellation

A rebuild may be cancelled when:

- source selection proves wrong;
- scope is insufficient;
- processing version is incorrect;
- resource impact becomes unsafe;
- unexpected output appears;
- validation fails.

Cancellation must preserve enough metadata to determine:

- completed work;
- partial target state;
- required cleanup;
- whether live processing was affected;
- whether another rebuild strategy is required.

### 12.33 Rebuild Resource Impact

A rebuild may be one of the most resource-intensive recovery operations.

Resource impact may include:

- source reads;
- object-storage throughput;
- CPU;
- memory;
- database writes;
- transaction-log growth;
- temporary storage;
- orchestration capacity;
- network usage.

Recovery design should consider the impact on normal workloads.

Fast rebuild is not useful if it destabilizes the rest of the platform.

### 12.34 Rebuild Throttling

Large reconstruction may require controlled throughput.

Throttling can protect:

- source systems;
- object storage;
- SQL Server;
- shared compute;
- network capacity;
- live processing.

The appropriate rate should be determined through measured behavior rather than an arbitrary maximum.

### 12.35 Rebuild Prioritization

When multiple derived states require reconstruction, priority should consider:

- consumer impact;
- correctness risk;
- freshness;
- recovery dependency;
- data-loss risk;
- known-good published state;
- resource requirements;
- business importance.

A lower-layer rebuild that unlocks several downstream states may have priority over an isolated downstream optimization.

### 12.36 Rebuild and Quality Validation

Reconstructed state remains subject to applicable quality controls.

Validation may include:

- completeness;
- uniqueness;
- referential consistency;
- accepted values;
- temporal correctness;
- domain rules;
- expected populations.

Rebuild success is not defined only by completion of the transformation job.

### 12.37 Rebuild and Reconciliation

Reconciliation should demonstrate that reconstructed state is consistent with the appropriate upstream source and recovery objective.

Relevant comparisons may include:

- source-to-target counts;
- Bronze-to-Silver counts;
- Silver-to-Gold counts;
- business totals;
- historical intervals;
- expected dimensions;
- expected fact populations.

Where logic intentionally changed, reconciliation must distinguish expected restatement differences from unexplained discrepancies.

### 12.38 Rebuild and Certification

Gold rebuilt from historical or recovered state must remain subject to certification.

The required path remains:

**Rebuilt Gold Candidate**
→ processing complete  
→ quality passed  
→ reconciliation passed  
→ lineage valid  
→ certification  
→ publication.

Recovery does not lower the certification standard.

### 12.39 Rebuild and Rollback

Versioned or shadow rebuild strategies should preserve rollback where appropriate.

If the newly rebuilt version fails after promotion or unexpected consumer behavior appears:

**Previous Known-Good Certified Version**
→ should remain identifiable and recoverable according to the configured publication strategy.

Rollback protects analytical availability.

It does not remove the need to investigate the failed rebuilt state.

### 12.40 Rebuild and Lineage

Rebuilt state must preserve lineage sufficient to identify:

- recovery source;
- source interval;
- processing definition;
- rebuild execution;
- target version;
- historical or current logic;
- quality results;
- reconciliation results;
- certification state.

A rebuilt dataset must remain distinguishable from the state it replaces.

### 12.41 Rebuild and Metadata

Metadata should identify, where applicable:

- rebuild reason;
- target;
- source;
- scope;
- start time;
- completion time;
- processing version;
- target version;
- lifecycle state;
- validation state;
- publication state.

This makes rebuild an auditable platform operation rather than an opaque administrative event.

### 12.42 Rebuild and Security

Rebuild may require elevated storage or processing privileges.

Such access must remain:

- explicit;
- limited;
- attributable;
- temporary where practical;
- removed after recovery.

Temporary rebuild data remains subject to classification and privacy requirements.

Rebuild does not justify bypassing access controls or publishing unvalidated sensitive data.

### 12.43 Rebuild and Retention

Rebuild capability depends on retaining:

- required upstream data;
- historical versions;
- metadata;
- lineage;
- processing definitions.

If required history is intentionally disposed of, the corresponding reconstruction capability may no longer exist.

The platform must not claim complete historical rebuild capability beyond retained and interpretable history.

### 12.44 Rebuild and RPO

A rebuild may restore derived state without changing the recovery point of the upstream durable source.

For example:

**Gold Lost**
→ valid Silver remains complete through boundary X  
→ Gold can be rebuilt through X.

The achievable recovery point for Gold therefore depends on the freshness and completeness of the selected upstream boundary.

RPO must be evaluated according to the state actually preserved.

### 12.45 Rebuild and RTO

Rebuild time contributes directly to recovery time.

Relevant factors include:

- historical volume;
- processing throughput;
- target size;
- resource availability;
- validation duration;
- reconciliation duration;
- certification;
- catch-up backlog.

Measured rebuild duration provides evidence for recovery planning.

It must not be generalized beyond the tested workload.

### 12.46 Rebuild Validation

Rebuild validation should confirm, where applicable:

- correct recovery source;
- correct scope;
- complete required history;
- appropriate processing version;
- correct cutoff;
- restartability;
- no missing target state;
- no unintended duplicate business effects;
- expected historical result or restatement;
- quality;
- reconciliation;
- lineage;
- metadata;
- certification;
- publication;
- final freshness.

A target that merely exists after reconstruction is not sufficient evidence of successful rebuild.

### 12.47 Rebuild Evidence

Representative rebuild evidence should preserve:

- rebuild reason;
- affected target;
- selected recovery source;
- source interval;
- rebuild scope;
- target strategy;
- processing version;
- target version;
- initial state;
- progress;
- interruptions where tested;
- record counts;
- quality results;
- reconciliation results;
- certification result;
- publication result;
- elapsed reconstruction time;
- catch-up time;
- total recovery time;
- final state.

This evidence supports both recovery validation and future RTO/capacity analysis.

### 12.48 Rebuild Test Scenarios

Version 1 should validate representative rebuild scenarios such as:

**Rebuild Test 1 — Silver From Bronze**
→ preserve valid Bronze history  
→ remove or isolate a controlled Silver target  
→ rebuild Silver  
→ validate equivalence and lineage.

**Rebuild Test 2 — Gold From Silver**
→ preserve valid Silver  
→ rebuild a Gold candidate from a clean target  
→ validate quality and reconciliation  
→ certify before publication.

**Rebuild Test 3 — Interrupted Rebuild**
→ interrupt a multi-batch reconstruction  
→ restart from durable progress  
→ demonstrate correct final state.

**Rebuild Test 4 — Corrected Processing**
→ preserve historical input  
→ change a controlled transformation rule  
→ rebuild a versioned target  
→ demonstrate expected differences and controlled publication.

**Rebuild Test 5 — Catch-Up**
→ allow new input to accumulate during reconstruction  
→ rebuild through a defined cutoff  
→ catch up remaining processing  
→ demonstrate restoration of current governed state.

The exact scenarios should reflect the final Version 1 implementation.

### 12.49 Rebuild Guarantees

The Atlas Engineering rebuild model must preserve the following guarantees:

1. rebuild is the controlled reconstruction of derived state from a trustworthy upstream boundary;
2. rebuild remains distinct from restart, retry, replay, reprocessing, and backfill;
3. rebuild may use replay, reprocessing, backfill, or backup restoration as supporting mechanisms without collapsing their meanings;
4. rebuild source remains upstream of the state being reconstructed;
5. rebuild scope is explicit and includes required dependencies;
6. full and partial rebuild remain distinguishable;
7. Bronze can be rebuilt from retained Kafka history only while the required interval remains complete and trustworthy;
8. Silver is normally rebuilt from governed Bronze history;
9. Gold is normally rebuilt from trustworthy Silver state;
10. Certified Gold reconstruction preserves certification and controlled publication boundaries;
11. backup restore remains distinct from downstream rebuild;
12. processing-version selection is explicit;
13. historical reproduction remains distinct from historical restatement;
14. target reconstruction uses an explicit in-place, shadow, or versioned strategy;
15. consumer-visible known-good state is protected during rebuild where appropriate;
16. interaction between rebuild and live processing is controlled;
17. rebuild cutoff and catch-up behavior are explicit where current processing continues;
18. repeated or interrupted rebuild execution does not create unintended duplicate business effects;
19. large rebuilds expose durable progress and restartability;
20. failed or partial rebuild output does not silently become governed complete state;
21. cancelled rebuilds remain traceable and recoverable;
22. rebuild resource impact is controlled;
23. quality and reconciliation apply to rebuilt state;
24. Gold rebuild remains subject to certification;
25. rollback remains available where the publication strategy requires it;
26. rebuilt state preserves lineage and metadata;
27. temporary rebuild privileges and data remain governed;
28. rebuild claims remain bounded by retained and interpretable history;
29. rebuild performance contributes to measured recovery planning rather than unsupported RTO claims;
30. rebuild capability is considered demonstrated only after controlled validation and evidence.

---

## 13. Component Failure and Recovery

Atlas Engineering contains multiple independent components whose failures affect different parts of the data path.

Component recovery must therefore be evaluated according to:

- architectural responsibility;
- durable state;
- processing progress;
- downstream impact;
- available recovery source;
- required recovery mechanism;
- validation requirements.

The governing model is:

**Component Failure → Identify Preserved State → Restore Component Capability → Resume or Reconstruct Processing → Validate Downstream State**

A component returning to an operational state does not independently demonstrate that its data-processing responsibility has recovered correctly.

### 13.1 AtlasCommerce Failure

AtlasCommerce is the authoritative operational source.

Failure scenarios may include:

- SQL Server instance unavailable;
- database unavailable;
- storage failure;
- transaction-log issue;
- permission failure;
- broader host failure.

During source unavailability:

- new business transactions may be unavailable to the application;
- no new committed changes can enter CDC;
- downstream historical processing may continue using already captured data;
- Certified Gold may remain available but become progressively stale.

Recovery should determine:

- source database integrity;
- transaction availability;
- CDC state;
- whether required source changes remain recoverable;
- whether any source-side recovery point created a change gap.

Restoring SQL Server service alone does not prove analytical capture continuity.

### 13.2 AtlasCommerce Recovery

AtlasCommerce recovery may involve:

- SQL Server service restart;
- database recovery;
- storage recovery;
- backup restore;
- transaction-log recovery;
- broader infrastructure recovery.

After source recovery, validation should confirm:

- database is operational;
- required business data is available;
- CDC is enabled and functioning;
- required source history remains available;
- Debezium can resume from the correct source position;
- no unexplained capture interval is missing.

If the required source-change history is no longer available, downstream recovery may require controlled backfill or another governed recovery source.

### 13.3 CDC Failure

CDC failure affects the source-change history used by Debezium.

Possible scenarios include:

- CDC capture process unavailable;
- required capture instance unavailable;
- capture latency excessive;
- CDC configuration drift;
- retention removes required history;
- metadata or permission failure.

CDC failure may exist while AtlasCommerce itself remains fully operational.

Source transactions can therefore continue while analytical recoverability progressively degrades.

### 13.4 CDC Recovery

CDC recovery should determine:

- last source position successfully captured downstream;
- earliest source history still available;
- whether the complete required interval remains inside CDC retention;
- whether capture configuration remains valid.

If the required interval remains available:

**Restore CDC**
→ **Restore Debezium**
→ **Resume Capture**
→ **Validate Continuity**

If required history has expired:

**CDC Recovery Alone Is Insufficient**
→ another recovery source or backfill strategy is required.

### 13.5 Debezium Failure

Debezium failure interrupts the conversion and publication of source changes into Kafka events.

Possible scenarios include:

- connector stopped;
- connector crash;
- SQL Server connection failure;
- Kafka connection failure;
- authentication failure;
- connector configuration defect;
- schema-related failure.

During Debezium interruption:

- source transactions may continue;
- CDC history may continue accumulating;
- Kafka receives no corresponding new events;
- downstream processing may eventually become idle;
- Certified Gold may remain available but stale.

### 13.6 Debezium Recovery

Debezium should resume from its durable capture position when the required CDC history remains available.

Recovery validation should confirm:

- connector is running;
- source connectivity restored;
- Kafka connectivity restored;
- expected source position recovered;
- events begin publishing again;
- no required source interval is missing;
- downstream backlog begins advancing.

A connector status of `RUNNING` is necessary but not sufficient evidence of capture recovery.

### 13.7 Apicurio Registry Failure

Apicurio Registry governs event-contract versions and compatibility.

Failure may affect:

- schema registration;
- schema lookup;
- producer or consumer startup;
- contract validation;
- schema evolution.

The exact impact depends on whether producers and consumers require live registry access for the operation being performed.

Previously retained Kafka events remain durable independently of registry availability.

### 13.8 Apicurio Registry Recovery

Registry recovery should restore:

- required schema definitions;
- compatibility configuration;
- access;
- version history;
- contract lookup required by processing.

Validation should confirm that:

- currently supported contracts remain available;
- historical contract versions required for replay remain interpretable;
- no unauthorized schema evolution occurred during failure;
- producers and consumers resume correctly.

Registry availability without required historical definitions represents incomplete recovery.

### 13.9 Kafka Producer Failure

A Kafka producer failure prevents a service from publishing required events.

For the initial source flow, this may appear as Debezium being unable to publish while source capture history remains available upstream.

Possible causes include:

- broker unavailability;
- network interruption;
- authentication failure;
- authorization failure;
- producer configuration error.

Recovery must determine whether the unpublished source interval remains available upstream.

### 13.10 Kafka Broker Failure

Kafka broker failure may affect:

- event publication;
- consumption;
- partition availability;
- consumer-group progress;
- retained event access.

The Version 1 single-node laboratory may experience complete Kafka unavailability from one broker failure.

This demonstrates a physical limitation of the laboratory topology, not the logical target availability model.

### 13.11 Kafka Recovery

Kafka recovery must establish both:

**Service Recovery**
→ broker and required topics are available.

and:

**Event Recovery**
→ required retained history remains complete and readable.

Validation should confirm:

- broker availability;
- topic availability;
- required partitions;
- consumer-group state;
- retained replay interval;
- producer publication;
- consumer resumption.

If required Kafka history was lost, downstream recovery must use another trustworthy source.

### 13.12 Kafka Consumer Failure

A Kafka consumer failure may stop one downstream processing responsibility while Kafka continues retaining incoming events.

Representative effects include:

- consumer lag increases;
- backlog grows;
- other consumer groups continue normally;
- producer activity remains healthy.

This is a key reliability advantage of decoupled event transport.

### 13.13 Kafka Consumer Recovery

Consumer recovery should normally:

1. restart the consumer;
2. recover committed consumer progress;
3. resume from the appropriate offsets;
4. tolerate redelivery;
5. process accumulated backlog;
6. validate checkpoint advancement;
7. verify no processing gaps or duplicate business effects.

If required offsets are outside retention, normal consumer recovery is insufficient.

Recovery-source escalation is then required.

### 13.14 Bronze Processor Failure

Bronze processing failure prevents new Kafka events from becoming part of the durable analytical history.

Possible causes include:

- consumer failure;
- transformation or serialization defect;
- MinIO failure;
- checkpoint failure;
- persistent event failure;
- resource exhaustion.

Kafka should continue retaining input while the configured retention window remains available.

### 13.15 Bronze Processor Recovery

Where Kafka history remains complete:

**Restore Bronze Processor**
→ resume from committed progress  
→ tolerate redelivery  
→ persist missing Bronze history  
→ process backlog  
→ validate continuity.

If Bronze output already exists for redelivered events, idempotent handling must prevent unintended duplicate historical effects.

If Kafka history is incomplete, Bronze recovery must escalate to backfill, backup, archive, or another governed historical source.

### 13.16 MinIO Failure

MinIO provides durable storage for Bronze and Silver in Version 1.

Failure scenarios may include:

- service unavailable;
- host or disk failure;
- capacity exhaustion;
- object-write failure;
- object corruption;
- permission failure.

The impact depends on which stored layer is affected.

A MinIO failure may simultaneously affect Bronze and Silver because both are hosted in the same laboratory storage environment.

### 13.17 MinIO Recovery

Recovery must determine:

- service availability;
- storage integrity;
- affected objects;
- completeness of Bronze;
- completeness of Silver;
- backup or alternate recovery state where implemented.

If MinIO service alone failed but stored objects remain intact:

→ restore service  
→ validate objects  
→ resume processing.

If Bronze data was lost:

→ recover from Kafka while retained, or another historical recovery source.

If Silver data was lost while Bronze remains valid:

→ rebuild Silver from Bronze.

The recovery path depends on the state lost, not merely on the MinIO service name.

### 13.18 Bronze Storage Loss

Bronze storage loss is significant because Bronze is the primary long-term analytical reconstruction foundation.

Recovery preference is:

**Kafka History Still Complete**
→ replay Kafka and rebuild Bronze.

If Kafka history is no longer complete:

→ use another governed historical source such as backfill, backup, or archive according to the required history.

Loss of both Bronze and the corresponding Kafka history represents a materially broader recovery condition.

### 13.19 Silver Processor Failure

Silver processing failure may occur while Bronze ingestion continues successfully.

Effects may include:

- Bronze continues accumulating;
- Silver checkpoint stops;
- Gold receives no new valid Silver state;
- consumer-visible Certified Gold remains unchanged and eventually stale.

Possible causes include:

- transformation defect;
- schema incompatibility;
- storage failure;
- dependency failure;
- poison data;
- resource exhaustion.

### 13.20 Silver Processor Recovery

If Silver state remains valid and processing merely stopped:

→ restart  
→ resume from committed progress  
→ process Bronze backlog.

If Silver state is invalid or processing logic was defective:

→ select trustworthy Bronze scope  
→ reprocess  
→ partially or fully rebuild Silver  
→ validate quality and lineage.

Silver recovery should not automatically return to Kafka when valid Bronze already provides the appropriate recovery boundary.

### 13.21 Silver Storage Loss

If persisted Silver state is lost while Bronze remains complete and trustworthy:

**Bronze**
→ Silver rebuild.

Recovery validation should confirm:

- complete required Bronze scope;
- correct Silver processing version;
- reconstructed Silver completeness;
- quality;
- lineage;
- downstream compatibility.

A complete Gold rebuild may subsequently be required depending on which Gold state remains valid.

### 13.22 Gold Processor Failure

Gold processing failure affects analytical dimensional-state generation.

Possible effects include:

- Silver remains current;
- Gold candidate generation stops;
- existing Certified Gold remains available;
- freshness degrades.

Possible causes include:

- transformation defect;
- SQL Server failure;
- dimensional logic failure;
- resource exhaustion;
- quality or reconciliation failure.

Technical Gold-processing failure and certification failure must remain distinguishable.

### 13.23 Gold Processor Recovery

If existing Gold state remains trustworthy and only processing stopped:

→ restore processing  
→ resume from the appropriate Silver boundary  
→ generate new candidate.

If Gold logic or state is invalid:

→ select trustworthy Silver  
→ rebuild Gold candidate  
→ validate  
→ reconcile  
→ certify  
→ publish.

Gold recovery should protect the existing known-good Certified Gold state until replacement is validated.

### 13.24 AtlasWarehouse Failure

AtlasWarehouse hosts the Gold analytical serving structures.

Failure scenarios may include:

- SQL Server service unavailable;
- database unavailable;
- storage failure;
- corrupted analytical state;
- permission failure;
- broader host failure.

The impact depends on whether:

- Gold processing is unavailable;
- Certified Gold is unavailable;
- stored analytical versions remain intact.

### 13.25 AtlasWarehouse Recovery

Possible recovery paths include:

**Service Failure, Data Intact**
→ restore SQL Server  
→ validate Gold and Certified Gold  
→ resume processing.

**Gold State Lost, Silver Valid**
→ restore database foundation if required  
→ rebuild Gold from Silver.

**Database State Restored From Backup**
→ validate restored version  
→ determine missing interval  
→ rebuild or catch up from Silver  
→ recertify where necessary.

Restored database availability does not independently prove current analytical correctness.

### 13.26 Quality-Control Failure

A quality-control failure may result from:

- actual invalid data;
- quality-rule defect;
- unavailable validation dependency;
- incorrect rule configuration.

The correct response depends on whether the failure represents a data condition or validation-system defect.

Quality failure normally blocks certification where the rule is blocking.

It should not automatically stop unrelated upstream ingestion.

### 13.27 Reconciliation Failure

Reconciliation failure indicates that expected consistency has not been demonstrated.

The platform should preserve:

- candidate state;
- reconciliation evidence;
- previous Certified Gold.

Recovery may require:

- investigation;
- replay;
- reprocessing;
- backfill;
- rebuild;
- correction of reconciliation logic.

A failed reconciliation must not be bypassed simply to restore freshness.

### 13.28 Certification Failure

Certification failure prevents a candidate from crossing the governed publication boundary.

The preferred consumer behavior is:

**Candidate Fails Certification**
→ candidate remains unpublished  
→ previous Certified Gold remains available where possible.

Recovery focuses on identifying and correcting the candidate or the control that failed.

Certification is retried only after the underlying condition has been addressed where necessary.

### 13.29 Publication Failure

A publication failure occurs when a valid candidate cannot be promoted safely.

Recovery must preserve atomic consumer visibility.

The expected behavior is:

**Previous Certified Version**
→ remains visible.

**New Candidate**
→ remains uncommitted or unpublished until safe promotion succeeds.

If publication partially changed state unexpectedly, recovery must restore a single known-good consumer-visible version before further publication.

### 13.30 Power BI Failure

Power BI failure affects analytical consumption rather than upstream data processing.

Possible scenarios include:

- Power BI service or desktop unavailable;
- connectivity failure;
- authentication failure;
- semantic-model failure;
- refresh failure.

Upstream processing may continue normally while consumers cannot access the analytical product.

This is an analytical-consumption availability failure rather than a data-ingestion failure.

### 13.31 Power BI Recovery

Recovery should determine whether the problem lies in:

- Power BI;
- authentication;
- network connectivity;
- Certified Gold;
- semantic model;
- report configuration.

After recovery, consumers should access the current approved Certified Gold state.

Power BI recovery must not bypass Certified Gold by connecting directly to upstream layers.

### 13.32 Airflow Failure

Airflow failure may prevent scheduled or dependency-driven work from starting or advancing.

Possible scenarios include:

- scheduler unavailable;
- worker unavailable;
- DAG error;
- task-state problem;
- metadata database failure.

Kafka and durable data layers may continue operating independently.

Streaming ingestion must not rely on Airflow as the authoritative event transport mechanism.

### 13.33 Airflow Recovery

Airflow recovery should restore orchestration while preserving actual processing state.

Before rerunning failed tasks, the platform should determine:

- whether the underlying operation already produced durable output;
- whether task retry is idempotent;
- what checkpoint remains committed;
- whether a downstream stage already advanced.

Airflow task state must not replace inspection of durable processing state.

### 13.34 Prometheus Failure

Prometheus failure affects metrics collection and historical metric availability.

Data processing may continue while metric visibility is reduced or unavailable.

This creates an observability degradation that may reduce the ability to detect:

- backlog;
- latency;
- retry behavior;
- recovery progress;
- SLO violations.

### 13.35 Prometheus Recovery

Recovery should restore metrics collection and determine whether telemetry gaps occurred.

A monitoring gap must remain distinguishable from an actual processing gap.

Where critical recovery activity occurred while Prometheus was unavailable, additional evidence may be required from:

- logs;
- checkpoints;
- processing metadata;
- reconciliation;
- other available telemetry.

### 13.36 Grafana Failure

Grafana failure affects dashboard and visualization availability.

Underlying metrics and processing may remain healthy.

Recovery should restore dashboard access without treating visualization availability as equivalent to platform health.

Alerts that depend on Grafana-specific functionality must be evaluated according to the final implementation.

### 13.37 Structured Logging Failure

Logging failure may reduce diagnosis and evidence quality while processing continues.

Possible causes include:

- write failure;
- storage exhaustion;
- logging configuration defect;
- unavailable log destination.

Critical processing should not silently depend on non-essential diagnostic logging when failure of the logging sink would unnecessarily stop data flow.

However, required audit or recovery metadata must still be preserved through its governed durable mechanisms.

### 13.38 Network Failure

Network interruption may affect one or more component relationships.

Examples include:

- SQL Server ↔ Debezium;
- Debezium ↔ Kafka;
- Kafka ↔ Bronze;
- processing ↔ MinIO;
- processing ↔ AtlasWarehouse;
- Power BI ↔ Certified Gold.

Recovery must restore connectivity and then validate processing continuity.

A successful connection test does not prove that backlog, checkpoint, or data state has recovered.

### 13.39 Credential Failure

Credential failure may make a healthy service operationally unavailable.

Recovery depends on classification:

**Incorrect or Expired Credential**
→ correct or rotate credential.

**Compromised Credential**
→ revoke  
→ replace  
→ validate rejection of old trust.

Reliability recovery must preserve the security requirements defined in **Security and Governance**.

### 13.40 Host Failure

In the Version 1 laboratory, one physical host may contain multiple components.

A host failure can therefore simultaneously affect:

- Kafka;
- MinIO;
- Airflow;
- observability;
- processing workloads;
- local storage.

This represents a broad shared physical failure domain.

Recovery evidence from the laboratory must clearly distinguish logical component resilience from host-level physical redundancy.

### 13.41 Complete Laboratory Failure

A complete laboratory failure may require restoration of several capabilities in dependency order.

A representative sequence may include:

1. host and storage;
2. SQL Server source and AtlasWarehouse where affected;
3. Kafka;
4. MinIO;
5. schema registry;
6. orchestration;
7. processing services;
8. observability;
9. downstream reconstruction and catch-up;
10. certification;
11. analytical consumption.

The actual order must reflect the implemented topology and recovery dependencies.

Restoring every service process does not independently restore complete platform state.

### 13.42 Recovery Dependency Order

Component recovery must consider dependency relationships.

For example:

**Bronze Processor**
depends on:
→ Kafka  
→ MinIO  
→ valid credentials and network.

**Silver Processor**
depends on:
→ Bronze  
→ MinIO  
→ required processing definitions.

**Gold**
depends on:
→ valid Silver  
→ AtlasWarehouse.

Recovery procedures should restore or validate prerequisite capabilities before repeatedly attempting dependent processing.

### 13.43 Recovery Cascade

After a lower-layer component recovers, downstream layers may require catch-up rather than immediate synchronized recovery.

For example:

**Debezium Restored**
→ Kafka begins receiving accumulated source changes  
→ Bronze backlog grows temporarily  
→ Silver follows Bronze  
→ Gold follows Silver  
→ Certified Gold freshness eventually returns.

Recovery therefore propagates through the data path over time.

The platform must observe this recovery cascade rather than declare success at the first restored component.

### 13.44 Component Recovery Validation

Component-specific recovery should validate, where applicable:

- service availability;
- dependency connectivity;
- durable-state integrity;
- checkpoint continuity;
- retained recovery history;
- backlog behavior;
- resumed throughput;
- processing correctness;
- downstream advancement;
- quality;
- reconciliation;
- certification;
- consumer-visible state.

Validation depth must reflect the component's architectural responsibility.

### 13.45 Component Recovery Evidence

Representative component-recovery evidence should preserve:

- component;
- failure scenario;
- failure time;
- affected responsibility;
- initial durable state;
- initial progress;
- downstream impact;
- recovery action;
- restart or restore time;
- recovered progress;
- backlog;
- validation result;
- downstream recovery state;
- total elapsed recovery time.

This evidence supports both component-specific reliability claims and future recovery planning.

### 13.46 Component Failure and Recovery Guarantees

The Atlas Engineering component-recovery model must preserve the following guarantees:

1. component failure is evaluated according to architectural responsibility and durable state;
2. service recovery remains distinct from processing and data recovery;
3. AtlasCommerce recovery includes validation of source and CDC continuity;
4. CDC recovery verifies whether required source-change history remains available;
5. Debezium recovery validates capture continuity rather than only connector status;
6. schema-registry recovery preserves historical contract interpretation required for replay;
7. Kafka recovery validates retained event history as well as broker availability;
8. Kafka consumer failure may accumulate recoverable backlog without stopping unrelated producers;
9. consumer recovery resumes from committed progress and tolerates redelivery;
10. Bronze recovery prefers retained Kafka history while complete and trustworthy;
11. MinIO recovery is evaluated according to which persisted layers were affected;
12. loss of Silver can be recovered from valid Bronze where required history remains available;
13. Gold recovery prefers valid Silver and protects existing Certified Gold;
14. AtlasWarehouse recovery distinguishes database availability from analytical correctness;
15. quality, reconciliation, certification, and publication failures remain separate failure classes;
16. failed certification does not replace known-good Certified Gold;
17. publication failure preserves a single controlled consumer-visible state;
18. analytical-consumption failure does not justify bypassing Certified Gold;
19. Airflow state does not replace durable processing state;
20. observability-component failure remains distinguishable from data-processing failure;
21. network recovery includes validation of processing continuity;
22. credential recovery preserves security boundaries;
23. Version 1 host-level failures remain acknowledged as shared physical failure domains;
24. broad recovery follows dependency-aware restoration order;
25. downstream recovery may cascade after the originating component is restored;
26. component recovery is considered complete only after appropriate validation;
27. component-reliability claims are supported by controlled evidence.

---

## 14. Partial Failure and Failure Isolation

Atlas Engineering must isolate failures to the smallest safe scope while preserving correctness, traceability, and governed downstream behavior.

A distributed data platform may continue operating partially when one component, partition, entity, processing stage, dependency, or data product is degraded or unavailable.

Partial availability is acceptable only when the unaffected processing remains independent from the failed state.

The governing principle is:

**Local Failure → Contain the Blast Radius → Preserve Valid Processing → Block Invalid Propagation → Recover the Failed Scope → Revalidate**

Failure isolation must therefore balance:

**Continuity**
→ allow unrelated valid processing to continue.

with:

**Correctness**
→ prevent incomplete, invalid, or ambiguous state from crossing governed boundaries.

### 14.1 Partial Failure

A partial failure affects only part of the platform while other responsibilities remain operational.

Representative examples include:

- one Kafka partition lagging while others advance;
- one business entity repeatedly failing transformation;
- one Silver dataset failing while another remains healthy;
- one Gold data product failing certification;
- one dependency unavailable only to a subset of workloads;
- one analytical product remaining stale while another remains current;
- one consumer group failing while producers continue normally.

Partial failure is expected in distributed architectures.

The platform must not assume that health is purely binary.

### 14.2 Failure Isolation

Failure isolation limits the effect of a problem to the smallest architectural scope that can be separated safely.

Possible isolation boundaries include:

- record;
- event;
- partition;
- entity;
- batch;
- dataset;
- processing stage;
- data product;
- consumer group;
- dependency;
- environment.

The isolation boundary must reflect processing semantics.

A technically convenient boundary is not sufficient if correctness depends on state outside that boundary.

### 14.3 Isolation and Dependency Analysis

Before isolating a failed scope, the platform must determine whether unaffected processing depends on it.

For example:

**One Product Fails**
→ another independent product may continue.

But:

**Shared Conformed Dimension Fails**
→ several Gold products may depend on that state.

Isolation decisions must consider:

- direct dependencies;
- shared reference data;
- shared dimensions;
- processing order;
- certification dependencies;
- lineage;
- consumer relationships.

The blast radius is defined by actual dependency, not only by the component that emitted the error.

### 14.4 Record-Level Isolation

A single record may fail while surrounding records remain valid.

Where the processing model allows safe isolation, the failed record may enter an explicit failure path while unrelated input continues.

Record-level isolation is appropriate only when processing beyond the failed record does not violate:

- ordering;
- entity state;
- referential consistency;
- aggregation correctness;
- downstream completeness requirements.

A failed record must remain traceable and recoverable.

### 14.5 Event-Level Isolation

An event may be isolated when its failure does not make later events unsafe to interpret independently.

Relevant considerations include:

- event ordering;
- entity sequence;
- dependency on previous state;
- operation type;
- downstream transformation semantics.

For example, skipping an invalid update event and then processing a later event for the same entity may produce an incorrect state if the later event assumes the missing transition occurred.

Isolation must therefore be semantic, not merely technical.

### 14.6 Partition-Level Isolation

Kafka partitioning provides a natural failure-isolation boundary where ordering is required within a partition.

A persistent failure in one partition may allow other partitions to continue if they are semantically independent.

The affected partition may be:

- paused;
- isolated;
- investigated;
- replayed;
- recovered separately.

The platform must preserve its committed progress and must not silently skip failed offsets merely to keep the partition moving.

### 14.7 Entity-Level Isolation

Some processing logic is naturally scoped by business entity.

Examples may include:

- Customer;
- Product;
- Transaction;
- Shipment.

If one entity contains invalid historical state, the platform may isolate that entity while continuing unrelated entities where the processing model supports it.

Entity-level isolation is useful when reconstruction can later be performed using the entity's complete relevant history.

### 14.8 Batch-Level Isolation

A failed batch may be isolated from other successfully completed batches.

The platform must know the batch commit semantics.

If batches are independent and durably committed, one failed batch should not invalidate completed batches automatically.

If the batch depends on a shared incomplete state, broader recovery may be required.

Batch isolation must remain consistent with checkpoints and processing metadata.

### 14.9 Dataset-Level Isolation

One dataset may fail independently from another.

For example:

**Silver Sales**
→ processing failure.

**Silver Product**
→ may continue if it does not depend on the failed Sales state.

Dataset-level isolation can reduce platform-wide disruption.

Shared dependencies must still be considered before declaring another dataset unaffected.

### 14.10 Data Product Isolation

A failure in one analytical product should not automatically prevent unrelated products from remaining available.

For example:

**Daily Sales Candidate**
→ fails reconciliation.

Another independent certified product may continue normal publication.

Certification and publication should therefore operate at a scope appropriate to the data product rather than always as one platform-wide binary state.

### 14.11 Shared Dependency Failure

Isolation becomes more difficult when the failed state is shared.

Examples include:

- Kafka;
- MinIO;
- AtlasWarehouse;
- schema registry;
- shared conformed dimension;
- shared authentication dependency;
- shared host.

A shared dependency failure may legitimately affect several downstream responsibilities.

The platform must not claim isolation beyond what the dependency graph actually allows.

### 14.12 Conformed Dimension Failure

A conformed dimension may be shared by multiple Gold facts or analytical products.

If its state becomes invalid, affected downstream products may need to stop advancing even if their fact processing remains technically operational.

The platform must determine:

- which products depend on the dimension;
- which historical interval is affected;
- whether the previous certified products remain trustworthy;
- whether partial downstream continuation is safe.

Shared analytical semantics can therefore expand the logical blast radius of a localized processing defect.

### 14.13 Reference Data Failure

Reference data may support multiple processing paths.

If required reference state is unavailable or invalid:

- dependent transformations may need to pause;
- unrelated transformations may continue;
- historical reprocessing may require the correct reference version.

The platform must not substitute arbitrary current values merely to keep processing moving.

### 14.14 Isolation and Ordering

Failure isolation must preserve ordering requirements.

Where later input depends on earlier failed input, processing cannot safely move beyond the failure simply because the later data is technically readable.

For example:

**Event 100**
→ fails.

**Event 101**
→ depends on the state resulting from Event 100.

Processing Event 101 independently may create incorrect state.

In such cases, the safe isolation boundary may need to include the complete entity or partition.

### 14.15 Isolation and Completeness

Continuing partial processing may produce an incomplete dataset.

The platform must determine whether incomplete state is acceptable for the affected stage.

Examples:

**Bronze**
→ one isolated event may represent a historical gap and therefore requires explicit remediation.

**Gold Candidate**
→ missing required data may make the candidate uncertifiable.

Partial processing must not silently become complete governed output.

### 14.16 Isolation and Quality Rules

Quality rules may operate at different scopes.

A failed record-level rule may allow isolation of one record.

A failed dataset-level rule may require blocking the entire candidate.

Examples include:

**Invalid individual value**
→ possible record quarantine.

**Dataset completeness below threshold**
→ candidate-level block.

Failure isolation must respect the scope of the quality rule.

### 14.17 Isolation and Reconciliation

Reconciliation may reveal that a supposedly isolated failure affects broader correctness.

For example:

**One record quarantined**
→ downstream transaction count no longer reconciles.

The result may be acceptable only if the expected reconciliation behavior explicitly accounts for quarantined state.

Otherwise the affected candidate may remain blocked.

Isolation does not eliminate reconciliation requirements.

### 14.18 Isolation and Certification

Certification must evaluate whether isolated failures affect the product's publication criteria.

Possible outcomes include:

**Failure Outside Product Scope**
→ certification unaffected.

**Non-Blocking Governed Exception**
→ certification may proceed according to explicit rule.

**Blocking Missing or Invalid State**
→ certification fails.

The certification decision must reflect the governed data-product contract rather than operational pressure to restore freshness.

### 14.19 Fail-Safe Publication

Failure isolation must protect Certified Gold.

An upstream partial failure should not cause partially recovered or incomplete data to replace a known-good certified version.

The preferred behavior is:

**Affected Candidate**
→ remains blocked or isolated.

**Previous Certified Gold**
→ remains consumer-visible where still trustworthy.

This converts some upstream failures into freshness degradation rather than consumer-visible correctness failure.

### 14.20 Partial Analytical Availability

The platform may remain partially available to consumers.

For example:

**Daily Sales**
→ previous certified version available but stale.

**Another Product**
→ current and fully available.

Operational status should therefore be capable of expressing product-level conditions rather than only:

**Platform UP**

or:

**Platform DOWN**

The specialized **Observability** architecture should expose these states appropriately.

### 14.21 Isolation and Backlog

When one processing scope is isolated, its backlog may continue growing.

Examples include:

- paused Kafka partition;
- failed entity history;
- blocked dataset;
- candidate awaiting remediation.

The platform must monitor:

- backlog size;
- oldest pending data;
- remaining retention window;
- recovery capacity.

Isolation is not equivalent to resolution.

### 14.22 Isolation and Recovery Window

A safely isolated failure can become a data-loss risk if the required upstream history expires before remediation.

For example:

**Partition Paused**
→ Kafka continues retaining its events.

As time passes:

→ required events approach retention expiration.

Operational priority must therefore consider the recovery window of isolated work.

### 14.23 Isolation and Resource Consumption

Failed work may continue consuming resources through:

- retries;
- logging;
- storage;
- quarantine;
- retained backlog;
- repeated validation.

Isolation should prevent one failed scope from consuming disproportionate capacity needed by healthy processing.

Bounded retry and controlled failure-state transitions support this objective.

### 14.24 Isolation and Quarantine

Quarantine may provide a controlled destination for data-specific failures when processing can safely continue without the affected input.

Quarantine must preserve:

- input identity;
- failure reason;
- processing version;
- relevant metadata;
- remediation state;
- reprocessing capability.

Quarantine behavior is addressed in greater detail in the next section for poison and persistent processing failures.

### 14.25 Isolation and Checkpoints

Checkpoint behavior must remain consistent with the isolation strategy.

If the processing model cannot safely commit beyond an isolated failure:

→ progress must remain before the failed input.

If a governed quarantine mechanism allows safe progression:

→ checkpoint advancement must preserve evidence that the isolated input remains unresolved and recoverable.

The architecture must not create a hidden processing gap.

### 14.26 Isolation With Continued Processing

When continued processing is safe, the platform should preserve explicit state indicating that:

- one scope is degraded;
- another scope continues;
- unresolved work remains;
- downstream completeness may differ.

This prevents partial success from being mistaken for complete recovery.

### 14.27 Isolation With Processing Block

Some failures require blocking progress.

Examples include:

- required ordering cannot be preserved;
- shared dimension is invalid;
- contract incompatibility affects all subsequent events;
- downstream target state cannot be safely updated;
- recovery source is uncertain.

Blocking is preferable to knowingly advancing incorrect state.

Availability must not be prioritized above correctness when the two conflict.

### 14.28 Failure Containment

Containment limits the ability of invalid state to propagate.

Possible actions include:

- pause a consumer;
- pause a partition;
- stop a processing stage;
- isolate a dataset;
- block candidate certification;
- block publication;
- restrict consumer access;
- preserve the previous certified version.

Containment should be proportional to the known affected scope.

### 14.29 Blast Radius

Blast radius describes the extent of platform behavior affected by a failure.

Relevant dimensions include:

- number of records;
- partitions;
- entities;
- datasets;
- products;
- consumers;
- processing stages;
- duration;
- historical interval.

Failure isolation should reduce blast radius where technically and semantically safe.

Blast radius should be measured or described rather than assumed.

### 14.30 Isolation and Root Cause

The location at which failure is observed may differ from the location of root cause.

For example:

**Gold Candidate Fails**
→ root cause may be:
- Silver defect;
- missing Bronze history;
- source issue;
- reference-data issue.

Isolation should prevent further propagation while investigation traces the problem to its originating boundary.

Lineage and processing metadata support this analysis.

### 14.31 Isolation Recovery

Recovery of an isolated scope should follow the appropriate mechanism for the underlying failure.

Possible actions include:

- retry;
- resume;
- replay;
- reprocessing;
- backfill;
- rebuild;
- correction of reference data;
- contract migration.

The isolated scope should rejoin normal processing only after required validation succeeds.

### 14.32 Rejoining Normal Processing

After recovery, the previously isolated scope must rejoin normal processing in a controlled manner.

Validation should determine:

- unresolved backlog processed;
- correct ordering restored;
- checkpoint aligned;
- no unexplained gaps;
- no duplicate business effects;
- dependent state consistent;
- quality passed;
- reconciliation passed;
- certification restored where applicable.

Recovery is incomplete while the isolated scope remains logically divergent from the governed platform state.

### 14.33 Isolation and Lineage

Lineage should preserve the effect of failure isolation where it materially changes processing.

Relevant metadata may identify:

- isolated input;
- failure reason;
- isolation time;
- affected downstream state;
- recovery execution;
- reprocessing;
- resulting output.

This supports investigation of why one portion of historical data followed a different recovery path.

### 14.34 Isolation and Evidence

Representative partial-failure evidence should preserve:

- failure scope;
- unaffected scope;
- dependency analysis;
- isolation action;
- backlog behavior;
- checkpoint state;
- consumer impact;
- recovery-window state;
- recovery action;
- validation;
- reintegration result.

Evidence should demonstrate both:

**the failure was contained**

and:

**unaffected processing remained correct**.

### 14.35 Partial Failure Test Scenarios

Version 1 should validate representative scenarios such as:

**Partial Failure Test 1 — Partition Isolation**
→ introduce a controlled persistent failure in one Kafka partition  
→ verify other partitions continue where safe  
→ recover the affected partition  
→ validate ordering and final state.

**Partial Failure Test 2 — Product Certification Failure**
→ cause one Gold candidate to fail a blocking quality or reconciliation control  
→ confirm previous Certified Gold remains available  
→ confirm unrelated product behavior remains unaffected where appropriate.

**Partial Failure Test 3 — Silver Dataset Failure**
→ interrupt one controlled Silver processing path  
→ allow independent processing to continue  
→ recover the affected dataset  
→ validate downstream consistency.

**Partial Failure Test 4 — Shared Dependency**
→ interrupt a shared laboratory dependency  
→ identify the actual blast radius  
→ verify that the documented failure scope matches observed behavior.

The exact scenarios should reflect the implemented dependency graph.

### 14.36 Partial Failure and Isolation Guarantees

The Atlas Engineering partial-failure model must preserve the following guarantees:

1. partial failure is treated as an expected distributed-platform condition;
2. failures are isolated to the smallest safe scope where practical;
3. isolation scope is based on processing semantics and dependencies rather than technical convenience alone;
4. record or event isolation occurs only when later processing remains semantically safe;
5. Kafka partition boundaries may support isolation while preserving partition ordering;
6. entity, batch, dataset, and data-product isolation remain available where their dependencies permit it;
7. shared dependencies may legitimately expand failure scope;
8. shared conformed dimensions and reference data are considered when determining blast radius;
9. isolation does not violate required event or entity ordering;
10. partial processing does not silently become complete governed state;
11. quality-rule scope influences whether record, dataset, or candidate isolation is appropriate;
12. reconciliation remains applicable to isolated processing;
13. certification determines whether isolated failures block publication;
14. upstream partial failure does not automatically replace known-good Certified Gold;
15. analytical availability may remain product-specific during partial failure;
16. isolated backlog and remaining recovery windows remain observable;
17. isolation prevents failed work from consuming uncontrolled platform capacity;
18. quarantine does not create hidden processing gaps;
19. checkpoint behavior remains consistent with the selected isolation strategy;
20. explicit degraded state distinguishes partial continuation from complete health;
21. correctness may require blocking processing even when continued execution is technically possible;
22. containment prevents invalid state from propagating beyond the affected boundary;
23. blast radius is evaluated according to actual downstream impact;
24. root cause remains distinguishable from the location where failure is observed;
25. isolated scope rejoins normal processing only after required recovery validation;
26. lineage and evidence preserve significant failure-isolation behavior;
27. partial-failure handling is considered demonstrated only after controlled testing and evidence.

---

## 15. Poison Records and Persistent Processing Failures

Atlas Engineering must explicitly handle input that repeatedly fails deterministic processing.

A poison record is an input that consistently prevents successful processing under the applicable processing definition and is unlikely to succeed through ordinary retry without remediation.

A persistent processing failure is a broader condition in which repeated execution cannot safely progress because the underlying cause remains unresolved.

The governing model is:

**Processing Failure → Classify → Bounded Retry → Retry Exhaustion → Isolate or Block Safely → Preserve Failed Input → Remediate → Reprocess → Validate → Reintegrate**

The platform must avoid both:

**Infinite Retry**
→ one deterministic failure repeatedly consumes processing capacity.

and:

**Silent Skip**
→ failed input disappears from the governed processing path so that progress can appear healthy.

### 15.1 Poison Record

A poison record is input whose content, structure, state, or relationship consistently causes processing failure.

Representative causes may include:

- malformed payload;
- unsupported contract version;
- incompatible schema;
- invalid required value;
- impossible type conversion;
- violated processing assumption;
- missing required reference;
- inconsistent entity history;
- transformation defect exposed by a specific input.

The term describes processing behavior.

It does not automatically mean that the source business record itself is invalid.

### 15.2 Persistent Processing Failure

Not every persistent failure is caused by one poison record.

Persistent failure may also result from:

- defective processing logic;
- incompatible deployment;
- invalid configuration;
- unavailable required historical context;
- missing reference data;
- corrupted target state;
- unresolved permission problem;
- contract incompatibility affecting many records.

The recovery response must therefore identify whether the failure is:

**Data-Specific**

or:

**Systemic**

before selecting an isolation strategy.

### 15.3 Poison Record Versus Transient Failure

A transient failure may succeed after the affected condition recovers.

For example:

**Temporary MinIO Unavailability**
→ retry may succeed.

A poison record normally fails deterministically until something changes.

For example:

**Payload Cannot Be Interpreted by the Applicable Contract**
→ waiting ten seconds does not change the payload.

Repeated retry without remediation provides no recovery value.

### 15.4 Failure Classification

Before persistent-failure handling begins, the platform should classify the failure where practical.

Representative categories include:

- transient infrastructure;
- persistent infrastructure;
- contract;
- schema;
- data quality;
- reference-data dependency;
- processing defect;
- authorization;
- corrupted state;
- unknown.

Classification supports the decision to:

- retry;
- pause;
- quarantine;
- escalate;
- replay;
- reprocess;
- backfill;
- rebuild.

Unknown failures should not automatically be treated as safe poison-record isolation.

### 15.5 Retry Exhaustion

A poison-record path begins only after the applicable bounded retry policy determines that ordinary retry is no longer appropriate.

Retry exhaustion should preserve:

- input identity;
- processing position;
- attempt count;
- first failure time;
- latest failure time;
- error classification;
- processing version;
- relevant dependency state.

The failed input must remain recoverable after retry stops.

### 15.6 No Infinite Retry

Atlas Engineering must not intentionally leave deterministic failures in uncontrolled infinite retry.

Infinite retry can:

- consume processing capacity;
- generate excessive logs;
- hide the age of the unresolved failure;
- increase backlog;
- threaten retention windows;
- create alert fatigue;
- prevent meaningful recovery escalation.

Retry exhaustion must therefore transition the failure into an explicit persistent state.

### 15.7 No Silent Skip

A failed input must not simply be skipped to advance processing progress unless an explicit governed mechanism establishes that progression is safe.

Silent skipping may create:

- historical gaps;
- incorrect entity state;
- reconciliation differences;
- incomplete analytical products;
- untraceable data loss.

Operational progress is not a valid reason to discard unresolved input.

### 15.8 Failure Isolation Decision

After retry exhaustion, the platform must determine whether the failed input can be isolated safely.

The decision should consider:

- ordering requirements;
- entity dependencies;
- partition semantics;
- downstream completeness;
- reference dependencies;
- aggregation impact;
- quality rules;
- reconciliation requirements.

The possible result is:

**Safe to Isolate**
→ preserve failed input separately and allow independent work to continue.

or:

**Unsafe to Isolate**
→ block the affected processing scope until remediation.

### 15.9 Quarantine

Quarantine is a governed failure state used to preserve failed input outside the ordinary successful processing path when safe isolation is possible.

Quarantine should preserve enough information to support:

- diagnosis;
- remediation;
- reprocessing;
- reconciliation;
- lineage;
- auditability.

Quarantine is not deletion.

It is durable preservation of unresolved work.

### 15.10 Quarantine Scope

Quarantine may operate at different scopes depending on processing semantics.

Possible scopes include:

- individual record;
- event;
- entity;
- partition interval;
- batch;
- dataset fragment.

The smallest safe quarantine scope should normally be preferred.

The platform must not force record-level quarantine when correctness requires isolating a broader scope.

### 15.11 Quarantine Metadata

A quarantined item should preserve, where applicable:

- original input or durable reference to it;
- source;
- event identity;
- topic;
- partition;
- offset;
- business key;
- event or transaction time;
- processing stage;
- processing version;
- failure classification;
- error context;
- retry count;
- first failure time;
- quarantine time;
- remediation status;
- recovery execution.

Sensitive values must remain subject to security and privacy controls.

### 15.12 Quarantine State

Quarantine should expose an explicit lifecycle.

Representative states may include:

**FAILED**
→ processing failed after applicable retry.

**QUARANTINED**
→ input preserved for investigation.

**REMEDIATION_REQUIRED**
→ a corrective action has been identified.

**READY_FOR_REPROCESSING**
→ required correction has been completed.

**REPROCESSING**
→ recovery execution is underway.

**RESOLVED**
→ corrected input or processing has successfully rejoined the governed path.

The exact implementation may use different state names.

The architectural requirement is that unresolved and resolved failures remain distinguishable.

### 15.13 Quarantine Is Not a Dead End

Quarantine must have a recovery path.

A design that stores failed input indefinitely without:

- ownership;
- investigation;
- remediation;
- reprocessing;
- closure;

merely moves the failure elsewhere.

Every quarantined item should remain attributable to an unresolved processing responsibility until it is resolved or governed disposition explicitly determines otherwise.

### 15.14 Quarantine and Kafka Ordering

Kafka ordering is partition-specific.

If a poison event affects state required by subsequent events in the same partition, quarantining that event and committing beyond it may violate ordering semantics.

For example:

**Offset 100**
→ required entity update fails.

**Offset 101**
→ depends on the state produced by Offset 100.

Processing 101 as though 100 never existed may create incorrect state.

In this case, safe isolation may require pausing the partition or isolating a broader entity history rather than merely quarantining one event.

### 15.15 Quarantine and Offset Commit

Offset advancement after quarantine must be explicitly justified.

Two broad models exist:

**Blocking Model**
→ failed offset remains unresolved  
→ consumer progress does not advance beyond the unsafe boundary.

**Governed Isolation Model**
→ failed input is durably preserved in quarantine  
→ architecture proves later input can be processed independently  
→ ordinary progress may advance while unresolved work remains explicitly tracked.

The platform must not commit beyond failed input merely to reduce consumer lag.

### 15.16 Quarantine and Entity Ordering

Even when Kafka partition progress could technically advance, entity semantics may make later processing unsafe.

If historical state for one entity is incomplete:

→ later events for that entity may also need isolation.

Other independent entities may continue where safe.

This may create an entity-level quarantine or recovery scope rather than a single-record scope.

### 15.17 Quarantine and Bronze

Bronze should preserve raw historical fidelity wherever technically possible.

If an event can be durably represented in Bronze even though later transformation cannot interpret it successfully, the failure may belong to a downstream processing stage rather than preventing raw preservation.

This distinction is important:

**Unable to Transform**
does not necessarily mean
**Unable to Preserve Raw Input**.

Where raw preservation succeeds, Bronze remains evidence of the original input even while downstream processing is blocked.

### 15.18 Bronze Poison Failure

A failure before Bronze persistence is more significant because the analytical historical foundation has not yet been established.

Recovery must preserve the failed Kafka input through an appropriate durable mechanism while ensuring that:

- required Kafka history does not expire unnoticed;
- the event remains recoverable;
- progress does not silently skip it;
- downstream completeness remains explicit.

If raw preservation itself cannot be achieved, the failure requires higher operational priority.

### 15.19 Silver Poison Failure

A Silver transformation may fail for one historical input while Bronze remains complete.

The preferred recovery boundary remains Bronze.

Depending on processing semantics:

- affected input may be quarantined;
- affected entity may be isolated;
- processing may pause;
- unrelated data may continue.

After remediation:

**Bronze History**
→ corrected Silver processing  
→ reprocessing  
→ validation  
→ reintegration.

Kafka replay is unnecessary when valid Bronze already contains the required history.

### 15.20 Gold Poison Failure

A Gold-processing failure may be caused by:

- invalid Silver state;
- dimensional inconsistency;
- transformation defect;
- unexpected analytical value;
- missing relationship.

The affected Gold candidate should remain unpublished.

The previous Certified Gold should remain consumer-visible where trustworthy.

Gold failure handling should therefore prioritize candidate isolation rather than direct modification of Certified Gold.

### 15.21 Quality Failure Versus Processing Failure

A record may process technically while failing a quality rule.

This differs from a processing exception.

**Processing Failure**
→ the transformation cannot complete as intended.

**Quality Failure**
→ processing completed, but the resulting state violates an applicable quality expectation.

Both may lead to isolation or certification block, but their evidence and remediation paths differ.

### 15.22 Contract Failure

An event that cannot be interpreted under the applicable contract may represent:

- unsupported historical contract;
- producer defect;
- registry problem;
- incompatible schema evolution;
- consumer defect.

The platform should preserve the original event and contract identity before attempting remediation.

Contract failure must not be "fixed" by silently coercing unknown historical structure into the current schema.

### 15.23 Reference-Data Failure

Processing may fail because required reference data is missing or invalid.

Possible recovery includes:

- correcting reference data;
- restoring historical reference version;
- fixing processing logic;
- reprocessing the affected scope.

The input itself may be valid.

Quarantine metadata should therefore distinguish a reference dependency failure from invalid source data.

### 15.24 Processing-Logic Defect

A poison-record pattern may reveal a defect in processing code rather than a defective record.

For example:

**Specific Valid Value**
→ triggers an unhandled transformation path.

If several records fail for the same logic defect, treating every record as an independent data-quality problem would misclassify the incident.

The platform should group or correlate persistent failures where they share a likely systemic cause.

### 15.25 Repeated Failure Pattern

Repeated persistent failures with the same:

- contract;
- field;
- processing version;
- transformation;
- entity type;
- error category;

may indicate a broader defect.

Observability should make such patterns visible so that failure handling can escalate from individual-record remediation to processing-level correction.

### 15.26 Quarantine Growth

Quarantine can grow while ordinary processing continues.

The platform should observe:

- unresolved record count;
- oldest unresolved failure;
- growth rate;
- affected entities;
- affected processing stages;
- retained upstream recovery window;
- downstream completeness impact.

A growing quarantine is a reliability condition even when consumer lag appears healthy.

### 15.27 Quarantine and Recovery Windows

Quarantined input may depend on upstream history that remains available only for a bounded period.

The platform must not assume that durable quarantine metadata alone preserves every dependency needed for later recovery.

Where remediation requires:

- neighboring events;
- complete entity history;
- historical reference state;

those dependencies must remain recoverable.

Quarantine design must therefore consider retention.

### 15.28 Quarantine and Backlog

Quarantine and backlog are different.

**Backlog**
→ valid or potentially valid work waiting for ordinary processing.

**Quarantine**
→ work explicitly removed from ordinary successful progression because a persistent failure requires remediation.

A system may have:

- low consumer lag;
- no ordinary backlog;
- significant unresolved quarantine.

Operational health must account for both.

### 15.29 Quarantine and Completeness

Allowing processing to continue after quarantine may make downstream state incomplete.

The platform must explicitly represent this where relevant.

A downstream candidate must not be certified if unresolved quarantined input violates its completeness requirements.

Quarantine therefore interacts directly with:

- quality;
- reconciliation;
- certification;
- freshness interpretation.

### 15.30 Quarantine and Reconciliation

Reconciliation should account for quarantined input explicitly.

For example:

**Source / Bronze Count**
=
**Successfully Processed**
+
**Governed Quarantined**
+
**Other Explicitly Classified State**

where such accounting is appropriate.

The objective is to prevent unresolved data from disappearing into an unexplained reconciliation difference.

### 15.31 Quarantine and Certification

Certification policy must determine whether unresolved quarantine is:

- irrelevant to a particular product;
- a governed non-blocking exception;
- a blocking completeness or correctness condition.

The decision must be explicit.

Operational pressure must not convert a blocking failure into a non-blocking one without governance.

### 15.32 Quarantine and Freshness

A product may appear recently processed while containing unresolved historical gaps caused by quarantine.

Freshness alone therefore does not prove completeness.

The platform must distinguish:

**Recent Processing Time**

from:

**Complete Governed Data State**.

This distinction is particularly important when downstream processing is allowed to continue around isolated failures.

### 15.33 Remediation

Remediation changes the condition that caused persistent failure.

Representative remediation may include:

- correcting transformation logic;
- deploying contract support;
- restoring reference data;
- correcting configuration;
- restoring permission;
- repairing corrupted state;
- correcting source data through the appropriate business process where legitimate.

Remediation must address root cause rather than merely reset retry counters.

### 15.34 Source Data Correction

If the root cause is invalid AtlasCommerce business data, correction should occur through the appropriate operational process whenever possible.

The analytical platform must not silently rewrite authoritative source history merely to make downstream processing succeed.

After legitimate source correction, recovery may require:

- new CDC event;
- replay;
- reprocessing;
- backfill;

depending on the original failure and available history.

### 15.35 Analytical Correction

If the source data is valid but the analytical interpretation is wrong, correction belongs in the affected analytical processing definition.

For example:

**Valid Source Event**
→ Silver transformation defect.

The correct response is:

→ correct Silver logic  
→ reprocess affected Bronze history.

The source must not be modified to compensate for an analytical defect.

### 15.36 Manual Data Editing

Direct manual editing of derived data should not be the ordinary remediation mechanism.

Manual changes can:

- bypass lineage;
- break reproducibility;
- hide root cause;
- create divergence from upstream state;
- make later rebuilds reintroduce the defect.

Where exceptional manual intervention is unavoidable, it must be explicitly governed, attributable, and followed by a durable correction to the normal processing path.

### 15.37 Ready for Reprocessing

A quarantined item should move toward reprocessing only after the required remediation is complete.

Before release, the platform should determine:

- failure cause addressed;
- correct processing version available;
- required historical context available;
- required reference state available;
- target state prepared;
- reprocessing scope defined.

Retrying without these conditions may simply recreate the persistent failure.

### 15.38 Quarantine Reprocessing

Recovery may process:

- the individual item;
- complete entity history;
- affected partition interval;
- affected batch;
- broader dataset scope.

The recovery scope depends on ordering and dependency semantics.

Reprocessing should use the appropriate trustworthy source, such as Bronze, rather than relying only on a transformed quarantine representation where the original governed history remains available.

### 15.39 Reintegration

After successful reprocessing, the recovered scope must rejoin normal governed state.

Reintegration should validate:

- failed input processed successfully;
- required subsequent input remains consistent;
- ordering restored;
- checkpoint state correct;
- no duplicate business effects;
- no unresolved processing gap;
- downstream quality;
- reconciliation;
- certification where applicable.

Changing quarantine status to `RESOLVED` is the result of recovery validation, not a substitute for it.

### 15.40 Quarantine Closure

A quarantined item may be closed only when its governed disposition is known.

Possible outcomes include:

- successfully reprocessed;
- superseded by a governed recovery operation;
- proven irrelevant to the affected downstream product;
- disposed according to an explicit approved data policy.

Closure must not mean:

**we stopped looking at it**.

The reason for closure should remain attributable.

### 15.41 Repeated Quarantine After Remediation

If an item fails again after remediation, the platform should preserve the new failure as part of the same recovery history where appropriate.

Repeated failure may indicate:

- incomplete remediation;
- second defect;
- incorrect root-cause analysis;
- missing historical dependency.

The response should return to diagnosis rather than indefinitely alternate between release and quarantine.

### 15.42 Poison Record Ownership

Persistent failures require operational ownership.

The responsible domain depends on the cause.

Examples include:

**Source Data Defect**
→ source/business remediation.

**Contract Defect**
→ ingestion or contract responsibility.

**Silver Logic Defect**
→ transformation responsibility.

**Gold Logic Defect**
→ analytical-model responsibility.

The architecture should make ownership identifiable even if Version 1 is operated by one person.

### 15.43 Poison Record Observability

Persistent failures should expose, where applicable:

- unresolved count;
- failure category;
- affected stage;
- affected entity;
- first failure time;
- age;
- retry count;
- quarantine state;
- remediation state;
- recovery-window risk;
- downstream impact.

Detailed dashboards and alert thresholds belong to **Observability**.

This document defines the reliability information that must be available.

### 15.44 Poison Record Alerting

Alerts should prioritize conditions such as:

- new blocking poison record;
- retry exhaustion;
- growing quarantine;
- oldest unresolved failure exceeding an expected interval;
- partition blocked;
- retention window at risk;
- product certification blocked;
- repeated failures sharing a common pattern.

One isolated governed non-blocking record may require different urgency from a failure blocking an entire processing partition.

### 15.45 Poison Record Security

Quarantine may contain raw source data or error context.

It must therefore preserve applicable:

- access control;
- classification;
- privacy;
- encryption;
- retention;
- auditability.

Error messages must not unnecessarily expose:

- credentials;
- secrets;
- sensitive payload values.

Quarantine is part of the governed platform, not an unrestricted debugging area.

### 15.46 Poison Record Retention

Quarantined data should remain available long enough to support:

- investigation;
- remediation;
- reprocessing;
- evidence;
- applicable audit requirements.

Retention should not automatically be indefinite.

Resolved quarantine should follow an explicit lifecycle consistent with the data's classification and recovery requirements.

### 15.47 Poison Record Validation

Recovery validation should confirm, where applicable:

- failure correctly classified;
- retry exhausted according to policy;
- failed input durably preserved;
- isolation did not create hidden gaps;
- ordering remained valid;
- remediation addressed root cause;
- correct historical scope was reprocessed;
- no duplicate business effects occurred;
- checkpoints are consistent;
- downstream completeness restored;
- quality passed;
- reconciliation passed;
- certification restored where applicable.

A poison-record incident is not resolved merely because ordinary consumer lag returned to zero.

### 15.48 Poison Record Evidence

Representative evidence should preserve:

- input identity;
- failure classification;
- original processing version;
- retry attempts;
- retry exhaustion;
- quarantine action;
- checkpoint behavior;
- affected scope;
- downstream impact;
- root cause;
- remediation;
- reprocessing execution;
- validation results;
- final disposition;
- elapsed time to recovery.

This evidence demonstrates that persistent failure handling preserves data rather than hiding it.

### 15.49 Poison Record Test Scenarios

Version 1 should validate representative scenarios such as:

**Poison Test 1 — Deterministic Transformation Failure**
→ introduce a controlled input that repeatedly fails a transformation  
→ verify bounded retry  
→ verify transition to explicit persistent-failure handling  
→ correct the transformation  
→ reprocess  
→ validate final state.

**Poison Test 2 — Safe Isolation**
→ introduce one controlled independently isolatable failure  
→ verify unrelated processing continues  
→ verify failed input remains traceable  
→ recover and reintegrate it.

**Poison Test 3 — Unsafe Isolation**
→ introduce a controlled ordered dependency failure  
→ verify processing does not silently commit beyond the unsafe boundary  
→ remediate  
→ resume in correct order.

**Poison Test 4 — Certification Impact**
→ preserve an unresolved failure that makes a Gold candidate incomplete  
→ verify certification remains blocked  
→ resolve the failure  
→ rebuild or reprocess the affected scope  
→ certify only after validation.

The exact scenarios should reflect the final Version 1 implementation.

### 15.50 Poison Records and Persistent Failure Guarantees

The Atlas Engineering poison-record and persistent-failure model must preserve the following guarantees:

1. deterministic persistent failures do not remain in uncontrolled infinite retry;
2. retry exhaustion transitions work into an explicit failure state;
3. failed input is not silently skipped merely to advance processing;
4. poison records remain distinguishable from transient and systemic failures;
5. persistent failures are classified before isolation where practical;
6. isolation occurs only when downstream processing can remain semantically correct;
7. unsafe isolation blocks the affected processing scope;
8. quarantine is durable governed preservation rather than deletion;
9. quarantine scope reflects ordering and dependency semantics;
10. quarantined input preserves sufficient identity, context, and recovery metadata;
11. unresolved and resolved quarantine states remain distinguishable;
12. quarantine has an explicit remediation and recovery path;
13. Kafka progress does not advance beyond failed input unless governed isolation proves it safe;
14. entity and partition ordering remain protected;
15. raw preservation is distinguished from successful downstream transformation;
16. failures before Bronze persistence receive appropriate priority because analytical history has not yet been durably established;
17. valid Bronze remains the preferred recovery boundary for downstream transformation failures;
18. Gold poison failures do not directly modify Certified Gold;
19. processing failures remain distinguishable from quality failures;
20. contract and reference failures preserve their actual failure classification;
21. repeated failure patterns can escalate from record-level handling to systemic investigation;
22. quarantine growth and age remain observable;
23. quarantine does not hide recovery-window or backlog risk;
24. unresolved quarantine remains visible to completeness, reconciliation, and certification controls;
25. freshness is not treated as proof of completeness;
26. remediation addresses root cause rather than only resetting retry state;
27. source correction and analytical correction remain separate responsibilities;
28. direct manual editing of derived state is not the ordinary remediation path;
29. reprocessing begins only after required remediation and historical context are available;
30. recovered input rejoins normal processing only after validation;
31. quarantine closure requires an explicit governed disposition;
32. repeated post-remediation failure returns to diagnosis rather than uncontrolled cycling;
33. persistent failures have identifiable ownership;
34. quarantine preserves security, privacy, and retention requirements;
35. poison-record recovery is validated for ordering, completeness, processing correctness, and downstream governance;
36. persistent-failure handling is considered demonstrated only after controlled testing and evidence.

---

## 16. Backlog Recovery and Catch-Up

Atlas Engineering must recover accumulated backlog in a controlled manner after an interruption, degradation, or temporary processing imbalance.

A backlog exists when upstream data continues to accumulate faster than one or more downstream stages can process it.

Backlog recovery is the process of reducing that accumulated work until the affected processing stage returns to its expected operating range.

The governing model is:

**Failure or Degradation → Backlog Accumulates → Component Recovers → Catch-Up Processing → Backlog Decreases → Freshness Recovers → Governed Normal State Restored**

A component returning to an operational state does not imply that backlog recovery is complete.

### 16.1 Backlog

Backlog represents work that remains available for processing but has not yet been incorporated into the downstream governed state.

Depending on the stage, backlog may be represented by:

- Kafka consumer lag;
- unprocessed Bronze partitions or files;
- pending Silver intervals;
- unprocessed Gold input;
- pending certification candidates;
- unresolved orchestration work.

Backlog must remain distinguishable from:

- quarantine;
- permanently missing data;
- processing gaps;
- failed derived state.

Backlog is recoverable pending work, not necessarily invalid work.

### 16.2 Backlog Causes

Backlog may accumulate because of:

- component outage;
- dependency failure;
- reduced processing capacity;
- temporary workload spike;
- throttling;
- resource contention;
- persistent retry;
- paused partition;
- controlled maintenance;
- rebuild or backfill workload competing with live processing.

Backlog may therefore occur even when no component is completely unavailable.

### 16.3 Catch-Up

Catch-up is the controlled processing of accumulated backlog after the affected capability is restored or additional processing capacity becomes available.

The objective is to reduce the difference between:

**Upstream Available Progress**

and:

**Downstream Committed Progress**

until the affected stage returns to its expected operating condition.

Catch-up must preserve the same correctness guarantees as ordinary processing.

### 16.4 Catch-Up Is Not Replay

Catch-up normally processes input that has not yet been committed by the affected consumer.

Replay intentionally revisits historical input that was previously considered processed.

For example:

**Consumer Stopped at Offset 100**
→ events 101–500 accumulate  
→ consumer resumes from 101  
→ catch-up.

By contrast:

**Consumer Had Already Processed Through 500**
→ intentionally reset to 300  
→ replay.

The distinction should remain explicit in operational evidence.

### 16.5 Catch-Up Is Not Reprocessing

Catch-up processes pending ordinary work.

Reprocessing intentionally processes historical input again.

A backlog may contain data that has never been processed by the affected stage, while reprocessing revisits data that already produced prior output.

### 16.6 Catch-Up and Checkpoints

Catch-up begins from the last committed processing progress.

The platform must not skip accumulated work merely to return quickly to the newest event.

Conceptually:

**Committed Progress**
→ start catch-up.

**Newest Available Input**
→ target progress.

The distance between these states decreases as catch-up succeeds.

### 16.7 Backlog Measurement

Backlog must be measurable in a way that reflects actual processing impact.

Useful measures may include:

- record or event count;
- Kafka lag;
- bytes pending;
- number of pending partitions;
- pending processing intervals;
- age of the oldest unprocessed input;
- estimated processing time.

Backlog count alone may be insufficient.

One thousand events that are ten seconds old may represent less operational impact than ten events that are several hours old.

### 16.8 Oldest Pending Age

The age of the oldest pending work is a critical recovery metric.

Conceptually:

**Backlog Depth**
→ how much work remains.

**Oldest Pending Age**
→ how stale the oldest unprocessed business change has become.

Together these metrics provide a more meaningful view of recovery than either one alone.

### 16.9 Backlog Growth Rate

Backlog behavior should be evaluated over time.

Three important conditions are:

**Growing**
→ input arrives faster than processing capacity.

**Stable**
→ processing approximately matches incoming rate but is not reducing accumulated work.

**Decreasing**
→ processing exceeds incoming rate and catch-up is occurring.

A recovered component that only stabilizes backlog has not yet recovered historical freshness.

### 16.10 Catch-Up Capacity

To reduce backlog while new data continues to arrive, processing throughput must exceed the incoming rate.

Conceptually:

**Catch-Up Capacity**
=
**Processing Throughput - Incoming Throughput**

If:

**Processing Throughput ≤ Incoming Throughput**

the backlog cannot shrink while new input continues.

This is a fundamental recovery-capacity constraint.

### 16.11 Catch-Up Ratio

The platform may use a catch-up ratio to understand recovery capability.

Conceptually:

**Catch-Up Ratio = Processing Throughput / Incoming Throughput**

Interpretation:

**Ratio < 1**
→ backlog grows.

**Ratio = 1**
→ backlog remains approximately stable.

**Ratio > 1**
→ backlog can decrease.

The ratio is workload-dependent and must be measured rather than assumed.

### 16.12 Catch-Up Time

Estimated catch-up time depends on:

- backlog size;
- incoming workload;
- effective processing throughput;
- retries;
- resource contention;
- downstream dependencies.

A simplified conceptual estimate is:

**Catch-Up Time ≈ Backlog / (Processing Rate - Incoming Rate)**

when processing rate is greater than incoming rate.

This estimate is only a planning aid.

Actual recovery time must be measured because processing cost may vary by record, partition, stage, and workload.

### 16.13 Backlog and Freshness

Backlog directly affects analytical freshness.

As backlog increases:

**Source Commit**
→ waits longer before downstream processing  
→ end-to-end latency increases.

A platform may remain fully available while violating its freshness SLO because backlog is growing.

Backlog recovery therefore participates directly in service-level recovery.

### 16.14 Freshness Recovery

Freshness recovery occurs progressively as accumulated work is processed.

The platform should distinguish:

**Component Recovered**
→ service operates.

**Backlog Recovering**
→ pending work is decreasing.

**Freshness Recovered**
→ data again satisfies the expected freshness condition.

These states may occur at different times.

### 16.15 Catch-Up and P95 Latency

During recovery, end-to-end latency percentiles may remain elevated even after processing throughput returns to normal.

Historical backlog events carry larger latency because they waited during the outage.

The platform should therefore expect temporary degradation in:

- P50;
- P95;
- P99;

while backlog is being consumed.

SLO recovery should be evaluated after the affected workload returns to the expected operating range.

### 16.16 Catch-Up and New Events

New events may continue arriving while backlog is processed.

The architecture must preserve:

- ordering requirements;
- fairness;
- business correctness;
- retention safety.

The system must not arbitrarily prioritize only new events to make dashboards appear fresh while older committed data remains unresolved.

### 16.17 Catch-Up Ordering

Where ordering matters, catch-up must preserve the same ordering semantics as ordinary processing.

For Kafka:

→ partition ordering remains applicable.

For entity-state processing:

→ historical entity sequence must remain correct.

Catch-up speed must not be increased by violating required ordering.

### 16.18 Catch-Up and Parallelism

Increasing parallelism may improve catch-up throughput where processing semantics allow it.

Possible approaches include:

- more consumer instances;
- more workers;
- parallel partition processing;
- parallel file processing;
- parallel batch execution.

Parallelism must respect:

- Kafka partition ownership;
- ordering;
- shared-state contention;
- downstream capacity;
- database write behavior;
- idempotency.

More workers do not automatically produce safe linear throughput improvement.

### 16.19 Catch-Up and Kafka Partitions

Kafka partitioning defines a natural unit of parallel consumption.

Catch-up capacity may therefore depend on:

- number of partitions;
- partition distribution;
- consumer count;
- skew between business keys;
- processing cost per partition.

A heavily loaded partition may remain behind while other partitions are already current.

Aggregate consumer lag can hide this imbalance.

### 16.20 Partition Skew

Partition skew occurs when workload is distributed unevenly.

One partition may contain significantly more or more expensive events than others.

During recovery:

**Most Partitions**
→ caught up.

**One Partition**
→ remains far behind.

The platform must therefore consider partition-specific backlog where relevant.

The complete consumer group should not be considered current while required partitions remain materially behind.

### 16.21 Catch-Up and Backpressure

Catch-up may increase pressure on downstream dependencies.

Possible effects include:

- MinIO write saturation;
- Silver processing contention;
- AtlasWarehouse write pressure;
- transaction-log growth;
- CPU or memory exhaustion;
- network saturation.

The recovery process must not increase throughput beyond the safe capacity of downstream stages.

### 16.22 Catch-Up Throttling

Catch-up may require throttling when maximum processing speed would destabilize the platform.

Controlled throttling can preserve:

- downstream stability;
- live processing;
- observability;
- storage capacity;
- transactional-system protection where backfill is involved.

The objective is:

**Fastest Safe Recovery**

not:

**Maximum Possible Processing Rate**

### 16.23 Catch-Up and Resource Headroom

Reliable recovery requires sufficient resource headroom to process more than the normal incoming workload when backlog exists.

A platform sized only to sustain its average normal workload may be unable to recover accumulated backlog without:

- pausing new input;
- temporarily increasing capacity;
- extending recovery time;
- violating freshness expectations.

Recovery capacity must therefore be considered in capacity planning.

### 16.24 Catch-Up and Peak Workload

Backlog recovery may overlap with normal workload peaks.

For example:

**Recovery Starts**
→ incoming traffic returns  
→ peak workload begins  
→ catch-up capacity decreases.

Version 1 should validate recovery behavior under representative increased workload rather than only under idle conditions.

### 16.25 Catch-Up and Retry Load

Retry activity consumes resources during catch-up.

If a subset of records continues failing:

→ retries may reduce capacity available for healthy backlog processing.

Persistent failures should transition into governed failure handling rather than indefinitely consuming catch-up capacity.

### 16.26 Catch-Up and Quarantine

Quarantined input should not be mistaken for ordinary backlog.

A consumer may reach the latest committed offset while unresolved quarantine still exists.

Operational recovery should therefore evaluate both:

**Ordinary Backlog**

and:

**Unresolved Persistent Failures**

before declaring complete processing correctness.

### 16.27 Catch-Up and Retention

Backlog must remain within the retention window of the upstream recovery source.

For Kafka:

**Oldest Required Unprocessed Event**
must remain retained until successful downstream persistence.

If backlog age approaches Kafka retention:

→ recovery options become increasingly constrained.

Retention risk may require:

- increased processing capacity;
- controlled throttling of producers where possible and appropriate;
- recovery-source escalation;
- operational prioritization.

### 16.28 Recovery Window Margin

The platform should consider the margin between:

**Oldest Required Pending Input**

and:

**Retention Expiration**

where measurable.

Conceptually:

**Recovery Window Margin**
=
**Retention Remaining for Required Input**

A shrinking margin is a stronger risk signal than backlog size alone.

### 16.29 Catch-Up and CDC

Debezium interruption may create backlog upstream in CDC rather than Kafka.

In this case, recovery must consider:

- last captured source position;
- current CDC history;
- CDC retention;
- Debezium catch-up rate.

Debezium must catch up before required CDC history expires.

A connector running normally but consuming slower than source changes arrive may still face increasing recovery risk.

### 16.30 Catch-Up Across Layers

Recovery may cascade across several asynchronous stages.

For example:

**Debezium**
→ catches up to source.

Meanwhile:

**Bronze**
→ accumulates additional Kafka backlog.

Then:

**Silver**
→ accumulates Bronze backlog.

Then:

**Gold**
→ waits for valid Silver.

The platform may therefore have multiple simultaneous backlog positions during recovery.

Each stage should expose its own progress.

### 16.31 Bottleneck Migration

During recovery, the bottleneck may move from one component to another.

For example:

1. Debezium is initially the bottleneck.
2. Debezium recovers rapidly.
3. Kafka backlog shifts pressure to Bronze.
4. Bronze catches up.
5. Silver becomes the slowest stage.
6. Gold later becomes the remaining recovery boundary.

Observability must help identify the current bottleneck rather than assume the original failure remains the limiting factor.

### 16.32 Catch-Up and Silver

When Bronze continues during a Silver outage:

**Bronze History**
→ grows normally.

After Silver recovery:

→ Silver processes the pending governed historical interval.

Silver catch-up should preserve:

- input ordering where required;
- processing version;
- checkpoint continuity;
- quality;
- downstream lineage.

### 16.33 Catch-Up and Gold

Gold may accumulate pending Silver processing while Certified Gold remains on a previous version.

Gold catch-up may involve:

- incremental processing;
- batch consolidation;
- candidate rebuild;
- controlled historical processing.

A new candidate should be created only from a complete intended Gold processing boundary.

### 16.34 Catch-Up and Certification

Certification may temporarily become the slowest stage even after transformation catches up.

For example:

**Gold Current**
→ reconciliation still running  
→ Certified Gold remains previous version.

Catch-up is therefore not complete from the consumer perspective until the required certification and publication state also advances.

### 16.35 Catch-Up and Certified Gold

Certified Gold may remain available throughout upstream catch-up.

This creates a useful distinction:

**Availability**
→ consumer can access known-good data.

**Freshness**
→ consumer is waiting for new certified state.

The platform should preserve the previous known-good version rather than expose partially caught-up state.

### 16.36 Catch-Up Completion

Catch-up should be considered complete only when the affected stage satisfies its defined recovery conditions.

Representative conditions may include:

- backlog reduced to expected operating range;
- oldest pending age within expected range;
- checkpoints advancing normally;
- no unresolved processing gap;
- no unexpected persistent failures;
- downstream stages advancing;
- freshness restored;
- quality and reconciliation valid;
- certification current where applicable.

Zero consumer lag alone may not prove complete recovery if downstream derived processing remains behind.

### 16.37 Normal Operating Range

A platform does not require backlog to remain mathematically zero at every instant.

Normal asynchronous processing may contain a small amount of transient pending work.

The architecture should distinguish:

**Normal Operating Backlog**
→ expected transient work within validated freshness behavior.

from:

**Recovery Backlog**
→ accumulated work resulting from interruption or insufficient processing capacity.

The boundary should be based on measured behavior.

### 16.38 Catch-Up Failure

Catch-up may fail if:

- processing throughput remains below incoming rate;
- a new dependency fails;
- resource exhaustion occurs;
- poison records block progress;
- retention history expires;
- processing defects appear under high volume.

Failure during catch-up may require:

- renewed isolation;
- increased capacity;
- retry-policy adjustment;
- replay;
- backfill;
- rebuild;
- recovery-source escalation.

A service that repeatedly returns to `RUNNING` but never reduces backlog has not achieved reliability recovery.

### 16.39 Catch-Up Cancellation or Pause

Catch-up may be intentionally paused when:

- downstream capacity becomes unsafe;
- validation identifies incorrect processing;
- the wrong processing version is active;
- another recovery action has higher priority;
- continued execution threatens recovery-source integrity.

Pause state must preserve committed progress and remaining backlog.

Resumption must continue from a known safe boundary.

### 16.40 Catch-Up Priority

When several stages or products have backlog, recovery priority should consider:

- risk of retention expiration;
- data-loss risk;
- correctness dependencies;
- consumer impact;
- freshness impact;
- business importance;
- shared downstream capacity;
- prerequisite relationships.

The most visible product is not automatically the first recovery priority.

A lower-layer backlog threatening the only retained recovery history may require earlier action.

### 16.41 Catch-Up and RTO

Catch-up time is part of recovery time.

For a processing interruption:

**Service Restart Time**
+
**Backlog Catch-Up Time**
+
**Validation Time**
+
**Certification / Publication Time Where Applicable**
=
**Observed Recovery Time**

Measuring only service restart can significantly understate the actual recovery experienced by analytical consumers.

### 16.42 Catch-Up and SLO Recovery

After a failure, SLO compliance may remain degraded while backlog is processed.

Recovery evidence should distinguish:

- time component became operational;
- time backlog began decreasing;
- time processing returned to normal operating range;
- time Certified Gold became current;
- time latency percentiles returned within the expected objective.

This allows the platform to measure end-to-end reliability rather than only technical restart.

### 16.43 Catch-Up Observability

Backlog recovery should expose, where applicable:

- stage;
- backlog count;
- backlog bytes;
- lag;
- oldest pending age;
- incoming rate;
- processing rate;
- catch-up ratio;
- estimated recovery time where useful;
- partition skew;
- retry activity;
- quarantine count;
- retention margin;
- current bottleneck.

Detailed metric names, dashboards, and alert thresholds belong to **Observability**.

### 16.44 Catch-Up Alerting

Operationally meaningful conditions may include:

- backlog continuously growing;
- catch-up ratio remaining below or equal to 1;
- oldest pending age increasing;
- retention margin approaching unsafe levels;
- one partition remaining materially behind;
- backlog moving to another downstream stage;
- catch-up stalled;
- Certified Gold freshness not recovering.

Alerting should distinguish expected temporary recovery behavior from a recovery process that is no longer converging.

### 16.45 Catch-Up Validation

Backlog-recovery validation should confirm, where applicable:

- correct restart boundary;
- no skipped pending input;
- backlog decreases;
- processing rate exceeds incoming rate during catch-up where required;
- ordering remains valid;
- no duplicate business effects;
- checkpoint progression remains correct;
- persistent failures are explicitly handled;
- retention remains sufficient;
- downstream stages recover;
- quality and reconciliation pass;
- Certified Gold freshness recovers.

The recovery objective is convergence to a correct governed operating state.

### 16.46 Catch-Up Evidence

Representative evidence should preserve:

- failure duration;
- backlog at recovery start;
- oldest pending age;
- incoming rate;
- processing rate;
- catch-up ratio;
- partition-level behavior where relevant;
- retry and quarantine state;
- retention margin;
- backlog trend;
- bottleneck changes;
- time backlog returned to normal range;
- time freshness recovered;
- final quality and certification state.

This evidence provides direct input for future capacity, SLO, RTO, and scaling decisions.

### 16.47 Catch-Up Test Scenarios

Version 1 should validate representative scenarios such as:

**Catch-Up Test 1 — Consumer Outage**
→ stop Bronze consumption for a controlled interval  
→ allow Kafka backlog to accumulate  
→ restart the consumer  
→ measure backlog reduction and time to normal operation.

**Catch-Up Test 2 — Peak Recovery**
→ accumulate controlled backlog  
→ recover while new events arrive at an elevated rate  
→ demonstrate whether processing capacity converges.

**Catch-Up Test 3 — Partition Skew**
→ create an intentionally uneven workload  
→ observe partition-specific recovery  
→ verify aggregate metrics do not hide the slow partition.

**Catch-Up Test 4 — Multi-Layer Recovery**
→ interrupt one downstream stage while upstream ingestion continues  
→ restore the stage  
→ observe backlog migration through subsequent layers until Certified Gold freshness is restored.

The exact workload must remain bounded by the Version 1 laboratory environment.

### 16.48 Backlog Recovery and Catch-Up Guarantees

The Atlas Engineering backlog-recovery model must preserve the following guarantees:

1. backlog remains distinguishable from quarantine, missing data, and invalid state;
2. catch-up begins from committed processing progress;
3. pending work is not skipped merely to reach the newest input;
4. catch-up remains distinct from replay and reprocessing;
5. backlog is measured by both volume and age where useful;
6. backlog trend distinguishes growth, stability, and recovery;
7. backlog can decrease only when effective processing capacity exceeds incoming workload;
8. catch-up capacity is measured rather than assumed;
9. estimated catch-up time does not replace observed recovery time;
10. backlog recovery preserves ordering and processing correctness;
11. parallelism is increased only where processing semantics and downstream capacity permit it;
12. partition skew remains visible where relevant;
13. catch-up does not overload downstream dependencies;
14. recovery prioritizes the fastest safe rate rather than maximum uncontrolled throughput;
15. capacity planning includes recovery headroom rather than only steady-state workload;
16. peak workload may reduce catch-up capacity and is considered in validation;
17. persistent retry does not consume unlimited catch-up capacity;
18. unresolved quarantine remains distinguishable from ordinary backlog;
19. backlog recovery remains bounded by upstream retention;
20. shrinking recovery-window margin increases operational urgency;
21. CDC and Kafka catch-up are evaluated against their respective retention windows;
22. asynchronous layers maintain independent backlog and progress state;
23. recovery bottlenecks may migrate between stages;
24. Gold and certification catch-up remain distinct from upstream processing recovery;
25. Certified Gold protects known-good analytical availability during catch-up;
26. catch-up completion requires more than zero lag at one processing stage;
27. normal transient backlog remains distinguishable from recovery backlog;
28. a running service that cannot reduce backlog is not considered fully recovered;
29. catch-up pause or cancellation preserves safe progress;
30. recovery priority reflects data-loss risk, dependency, and consumer impact;
31. backlog catch-up time contributes to actual observed RTO;
32. SLO recovery is measured separately from component restart;
33. backlog-recovery state is observable and actionable;
34. catch-up is considered demonstrated only after controlled validation and evidence.

---

## 17. Certified Gold Availability and Rollback

Certified Gold is the governed consumer-visible analytical boundary of Atlas Engineering.

Its reliability objective is to preserve a known-good analytical state while new candidate versions are processed, validated, certified, and published.

The governing model is:

**Current Certified Version → Build New Candidate → Validate → Certify → Publish Atomically**

If the new candidate or publication fails:

**Preserve Last Known-Good Certified Version**

Certified Gold therefore protects consumers from incomplete, invalid, or partially published analytical state.

### 17.1 Certified Gold as an Availability Boundary

Certified Gold provides analytical availability independently from the immediate health of every upstream processing stage.

For example:

**Silver Processing Failure**
→ no new Gold candidate.

**Certified Gold**
→ previous validated version remains available.

This allows the platform to distinguish:

**Upstream Processing Availability**

from:

**Governed Analytical Availability**

The consumer-facing layer should not become unavailable merely because a newer analytical version cannot yet be produced.

### 17.2 Known-Good Certified Version

A known-good Certified Gold version is a published analytical state that has satisfied the applicable:

- processing requirements;
- quality validation;
- reconciliation;
- lineage requirements;
- certification criteria;
- publication controls.

The version remains consumer-visible until a newer candidate successfully crosses the complete publication boundary or the version itself is explicitly invalidated.

### 17.3 Certification Does Not Guarantee Permanent Trust

A version being certified means it satisfied the applicable controls when it was published.

Later evidence may invalidate that trust.

Possible causes include:

- discovered transformation defect;
- incorrect business rule;
- reconciliation defect;
- source-data issue;
- security incident;
- privacy issue;
- incorrect historical interpretation.

A certification label must therefore not prevent later invalidation when evidence demonstrates that the published state is no longer trustworthy.

### 17.4 Candidate Isolation

New Gold state must remain isolated from ordinary analytical consumers until certification succeeds.

A candidate may exist physically while being:

- incomplete;
- under validation;
- failed;
- awaiting reconciliation;
- awaiting publication.

Consumers must not interpret physical existence as certification.

The architecture must preserve an explicit distinction between:

**Gold Candidate**

and:

**Certified Gold**.

### 17.5 Candidate Failure

A candidate may fail because of:

- processing failure;
- incomplete input;
- quality failure;
- reconciliation failure;
- lineage failure;
- certification-rule failure;
- incorrect processing version.

The expected behavior is:

**Candidate Fails**
→ do not publish  
→ preserve failure evidence  
→ investigate  
→ remediate  
→ rebuild or reprocess as required.

The current certified version remains unaffected unless the failure demonstrates that it is also invalid.

### 17.6 Freshness Degradation

When a new candidate cannot be certified, the current Certified Gold version may become progressively stale.

This is a:

**Freshness Degradation**

rather than automatically a:

**Correctness Failure**

or:

**Availability Failure**.

The platform must make this state observable.

A stale but trustworthy dataset may be preferable to a newer unvalidated dataset.

### 17.7 Consumer-Visible Staleness

Certified Gold should expose enough metadata to determine the age of the published state.

Relevant information may include:

- certified version;
- source processing boundary;
- source maximum business or commit time;
- certification time;
- publication time;
- current freshness age.

Consumers and operators should be able to distinguish:

**Data Available**

from:

**Data Current**.

### 17.8 Publication Eligibility

A Gold candidate becomes eligible for publication only after all blocking requirements have passed.

These may include:

- processing completion;
- required quality rules;
- reconciliation;
- freshness;
- completeness;
- lineage;
- required metadata;
- certification criteria.

Successful generation of rows or tables alone does not establish publication eligibility.

### 17.9 Atomic Publication

Publication must avoid exposing partial transition state.

The governing pattern is:

**Prepare → Validate → Atomic Promote**

Consumers must observe either:

**Previous Certified Version**

or:

**New Certified Version**

but not an uncontrolled mixture of both.

The exact atomic mechanism depends on the implementation technology.

### 17.10 Publication Metadata

Publication state should remain identifiable through metadata.

Relevant information may include:

- candidate version;
- certified version;
- publication status;
- publication timestamp;
- processing version;
- certification result;
- previous version;
- rollback eligibility.

Publication metadata is part of recovery because it identifies which analytical state is currently authoritative for consumption.

### 17.11 Publication Failure

Publication failure occurs when a candidate has passed certification but cannot safely become consumer-visible.

Possible causes include:

- SQL Server failure;
- permission failure;
- atomic-switch failure;
- metadata update failure;
- dependency failure;
- transaction failure.

The preferred result is:

**Publication Fails**
→ previous certified state remains visible  
→ candidate remains unpublished.

A publication mechanism that leaves consumers on an undefined mixed state is not considered reliable.

### 17.12 Partial Publication Failure

A partially completed publication is a high-risk condition because consumers may observe inconsistent state.

Recovery must determine:

- which publication operations completed;
- which version is actually visible;
- whether metadata agrees with physical state;
- whether consumer queries can observe mixed versions.

The first objective is to restore one clear known-good consumer-visible state.

Further publication must wait until that state is established.

### 17.13 Publication Transaction Boundary

Where supported, publication operations should use a transaction or equivalent atomic switch that minimizes intermediate consumer-visible states.

The publication boundary may involve:

- view switch;
- synonym switch;
- schema promotion;
- partition switch;
- metadata-controlled version selection;
- transactionally coordinated rename or replacement.

The architecture defines the atomicity requirement rather than one mandatory SQL Server mechanism.

### 17.14 Rollback

Rollback restores a previously known-good Certified Gold version as the active consumer-visible state.

Rollback may be required when:

- newly published state is later found incorrect;
- post-publication validation fails;
- consumer behavior exposes an unexpected defect;
- publication metadata becomes inconsistent;
- security or governance concerns invalidate the new version.

Rollback is an analytical publication recovery mechanism.

It does not automatically repair the processing defect that caused the need for rollback.

### 17.15 Rollback Source

Rollback requires a retained previous Certified Gold version or another equivalent known-good published state.

The platform should therefore preserve sufficient historical certified state according to its rollback and retention requirements.

A rollback claim is unsupported if the previous version cannot actually be restored or reactivated.

### 17.16 Rollback Eligibility

A previous version may be used for rollback only when it remains trustworthy.

A version must not be selected merely because it is older.

Selection should consider:

- certification state;
- later defect findings;
- data correctness;
- security state;
- privacy state;
- retained dependencies;
- consumer compatibility.

Rollback must select the last appropriate known-good version.

### 17.17 Rollback Versus Rebuild

Rollback and rebuild solve different problems.

**Rollback**
→ restore a previous consumer-visible state quickly.

**Rebuild**
→ reconstruct corrected derived state from a trustworthy upstream boundary.

A common recovery sequence is:

**New Version Invalid**
→ rollback to previous Certified Gold  
→ correct upstream logic  
→ rebuild new candidate  
→ validate  
→ certify  
→ publish corrected version.

Rollback restores availability while rebuild restores current correctness.

### 17.18 Rollback Versus Backup Restore

Rollback normally uses retained analytical versions already available within the publication architecture.

Backup restore reconstructs persisted infrastructure or data state from protected historical storage.

Using a database backup solely to revert one analytical publication may be broader than necessary when a valid previous certified version already exists.

The smallest safe recovery scope should be preferred.

### 17.19 Rollback and Freshness

Rollback may restore correctness and availability while increasing staleness.

For example:

**Certified Gold V10**
→ incorrect.

Rollback:

**Certified Gold V9**
→ trustworthy but older.

The result may therefore be:

**Correctness Restored**
+
**Availability Restored**
+
**Freshness Degraded**

These recovery dimensions must remain distinguishable.

### 17.20 Rollback and Consumer Compatibility

A rollback must consider whether consumers remain compatible with the previous certified contract.

If a new publication changed:

- schema;
- measure definition;
- field availability;
- semantic contract;

then reverting data without considering consumer compatibility may create another failure.

Backward compatibility should therefore be considered in the publication strategy.

### 17.21 Version Retention for Rollback

Certified Gold retention should preserve enough prior versions to satisfy the defined rollback strategy.

Retention should consider:

- rollback window;
- storage cost;
- audit requirements;
- investigation;
- reproducibility;
- consumer compatibility;
- privacy and retention requirements.

Retaining every certified version indefinitely is not required unless a governed requirement justifies it.

### 17.22 Published-Version Immutability

A published certified version should remain stable enough to support:

- audit;
- comparison;
- rollback;
- reproducibility.

Where possible, corrections should produce a new version rather than silently mutate the historical certified version.

This preserves the ability to explain what consumers actually saw at a given time.

### 17.23 Certification History

The platform should preserve enough history to determine:

- which candidates were created;
- which failed;
- which passed;
- which were published;
- which were rolled back;
- which became invalidated later.

Certification history supports:

- recovery;
- auditability;
- governance;
- incident analysis;
- evidence.

### 17.24 Publication History

Publication history should identify the sequence of consumer-visible versions.

Conceptually:

**V1 Published**
→ **V2 Published**
→ **V2 Rolled Back**
→ **V1 Re-Activated**
→ **V3 Published**

This history should remain attributable to:

- time;
- execution;
- certification;
- recovery reason;
- responsible process or identity.

### 17.25 Post-Publication Validation

Some validation may continue after publication where the implementation supports it.

Post-publication checks may detect:

- consumer-query issues;
- unexpected performance behavior;
- downstream semantic issues;
- delayed reconciliation findings;
- observability anomalies.

Post-publication validation must not replace the blocking controls required before certification.

It provides additional assurance after the governed transition.

### 17.26 Post-Publication Defect

If a defect is discovered after publication, the platform should classify:

- correctness impact;
- affected scope;
- consumer impact;
- historical interval;
- whether rollback is safe;
- whether the previous version remains compatible;
- whether upstream reconstruction is required.

The response may include:

- rollback;
- consumer notification through the appropriate operational process;
- reprocessing;
- rebuild;
- new certification;
- corrective publication.

### 17.27 Published Data Incident

A published-data incident occurs when consumer-visible analytical state is suspected or proven incorrect, incomplete, or otherwise invalid.

The immediate reliability objective is to prevent continued exposure of untrusted state.

Possible actions include:

- rollback;
- temporary access restriction;
- publication freeze;
- restoration of a previous version;
- investigation.

The selected response depends on whether a known-good consumer state remains available.

### 17.28 No Known-Good Certified Version

A more severe condition exists when no available Certified Gold version can be trusted.

Possible causes include:

- defect affects several retained versions;
- historical interpretation invalidates all retained versions;
- storage corruption;
- security or privacy incident;
- insufficient version retention.

In this scenario, the platform may need to:

- suspend the affected product;
- restrict consumer access;
- rebuild from a trustworthy upstream boundary;
- recertify before restoring availability.

Serving known-invalid data merely to preserve uptime is not acceptable.

### 17.29 Product-Level Availability

Certified Gold availability should be evaluated at the data-product level.

One product may be:

- current;
- stale;
- rolled back;
- unavailable;
- under reconstruction.

while another remains fully healthy.

The platform should not represent all consumer-facing data as one global binary availability state.

### 17.30 Product-Level Recovery State

Representative product recovery states may include:

**CURRENT**
→ latest intended certified state is available.

**STALE**
→ known-good certified state is available but freshness target is not met.

**ROLLBACK_ACTIVE**
→ previous known-good version restored intentionally.

**CERTIFICATION_BLOCKED**
→ candidate exists but cannot be published.

**UNAVAILABLE**
→ no acceptable consumer-visible state exists.

**RECOVERING**
→ corrected candidate is being reconstructed or validated.

The exact implementation may use different state names.

The architectural requirement is to preserve meaningful distinctions.

### 17.31 Certified Gold and Upstream Catch-Up

Certified Gold may remain stale while upstream layers catch up.

The consumer-visible product should advance only after the intended processing boundary has:

- reached required completeness;
- passed quality;
- reconciled;
- satisfied certification.

Publishing each partially recovered intermediate state merely to reduce apparent freshness lag can weaken the certification boundary.

### 17.32 Publication Frequency During Recovery

During catch-up, the platform may choose to publish:

- only after complete recovery;
- at governed intermediate boundaries;
- according to normal scheduled certification intervals.

The correct behavior depends on product semantics and certification rules.

Any intermediate publication must still represent a complete certified state for its declared boundary.

### 17.33 Roll-Forward

After rollback, the preferred long-term recovery is generally roll-forward through a corrected candidate.

Conceptually:

**Rollback to V5**
→ correct upstream defect  
→ rebuild or reprocess  
→ produce V7 candidate  
→ validate  
→ certify  
→ publish V7.

The objective is not to remain indefinitely on the older version.

Rollback provides recovery time while a corrected current state is produced.

### 17.34 Roll-Forward Validation

A corrected roll-forward version must pass the same certification requirements as normal publication.

Additional validation may compare:

- rolled-back version;
- invalidated version;
- corrected version;
- expected historical changes;
- consumer-visible measures.

The new version must not be trusted merely because it was produced after remediation.

### 17.35 Rollback and Lineage

Lineage should preserve:

- invalidated published version;
- rollback target;
- rollback reason;
- affected processing versions;
- recovery execution;
- corrected candidate;
- final replacement version.

This allows a reviewer to understand both the consumer-visible history and the technical recovery path.

### 17.36 Rollback and Metadata

Metadata should identify, where applicable:

- active certified version;
- previous version;
- candidate version;
- invalidated version;
- rollback status;
- rollback time;
- publication time;
- processing version;
- certification state;
- recovery reason.

Metadata must agree with the physical consumer-visible state.

### 17.37 Rollback and Security

Rollback must preserve current security and privacy requirements.

A previous analytical version must not be reactivated if it contains state that current governance explicitly invalidated.

Examples include:

- Restricted data no longer authorized for the product;
- privacy-invalid representation;
- revoked consumer access;
- known security-sensitive exposure.

Historical correctness does not override later governance.

### 17.38 Rollback and Retention

Rollback capability exists only while the required previous version remains retained and usable.

Retention policy must therefore align with:

- rollback expectation;
- product criticality;
- publication frequency;
- storage cost;
- recovery objectives.

The platform must not claim a rollback window longer than retained certified history supports.

### 17.39 Rollback and RPO

Rollback may intentionally move the consumer-visible analytical state backward.

For example:

**V10**
→ published at 14:00  
→ invalidated.

Rollback:

**V9**
→ published at 13:00.

The effective analytical recovery point may therefore become older than the latest processed source state.

RPO interpretation must distinguish:

- upstream data preservation;
- consumer-visible certified recovery point.

### 17.40 Rollback and RTO

Rollback may provide a faster consumer-availability recovery than a complete rebuild.

Observed recovery time may include:

- defect detection;
- decision;
- rollback execution;
- validation;
- consumer restoration.

Later roll-forward reconstruction is a separate recovery interval.

This distinction can be useful when evaluating analytical availability objectives.

### 17.41 Publication Freeze

A publication freeze temporarily prevents new candidates from becoming consumer-visible while investigation or recovery occurs.

It may be appropriate when:

- repeated candidates are failing;
- certification logic is suspect;
- publication mechanism is unstable;
- consumer-visible correctness is uncertain.

Upstream ingestion and processing may continue where safe.

Publication freeze protects the consumer boundary without unnecessarily stopping the entire pipeline.

### 17.42 Publication Freeze Recovery

Before lifting a publication freeze, validation should confirm:

- root cause understood or controlled;
- publication mechanism healthy;
- certification controls trusted;
- candidate state valid;
- current consumer-visible version understood;
- rollback state resolved;
- lineage and metadata consistent.

The freeze should not be removed merely because a component restarted.

### 17.43 Consumer Recovery

Consumer recovery is complete when the affected analytical consumer can access an acceptable governed Certified Gold state.

Depending on the incident, this may be:

- current certified version;
- previous known-good version under rollback;
- corrected newly published version.

Consumer recovery does not necessarily mean upstream processing has fully caught up.

The recovery state must therefore remain visible.

### 17.44 Certified Gold Availability Validation

Validation should confirm, where applicable:

- current active certified version;
- previous known-good version;
- candidate isolation;
- certification status;
- publication atomicity;
- consumer visibility;
- freshness;
- rollback behavior;
- metadata consistency;
- lineage;
- consumer compatibility.

A successful publication command alone does not prove reliable Certified Gold availability.

### 17.45 Rollback Validation

Rollback validation should confirm:

- rollback target remains trustworthy;
- target is complete;
- publication transition is atomic;
- invalid version is no longer consumer-visible;
- consumers can access the rollback version;
- metadata identifies the active version correctly;
- freshness impact is known;
- upstream remediation can continue independently.

### 17.46 Certified Gold Evidence

Representative evidence should preserve:

- product;
- previous certified version;
- candidate version;
- certification result;
- publication attempt;
- publication result;
- active version;
- freshness;
- rollback decision;
- rollback target;
- rollback time;
- consumer-visible result;
- roll-forward candidate;
- final replacement version;
- quality and reconciliation results;
- elapsed consumer recovery time.

This evidence demonstrates the behavior of the final governed analytical boundary during failure and recovery.

### 17.47 Certified Gold Test Scenarios

Version 1 should validate representative scenarios such as:

**Certified Gold Test 1 — Candidate Failure**
→ create a controlled Gold candidate that fails a blocking validation  
→ verify it is not published  
→ verify previous Certified Gold remains available.

**Certified Gold Test 2 — Publication Failure**
→ simulate a controlled publication interruption  
→ verify consumers do not observe mixed state  
→ restore one known-good active version.

**Certified Gold Test 3 — Rollback**
→ publish a controlled new certified version  
→ intentionally invalidate it through a test scenario  
→ rollback to the previous known-good version  
→ validate consumer visibility.

**Certified Gold Test 4 — Roll-Forward**
→ after rollback, correct the controlled defect  
→ rebuild a new candidate  
→ certify  
→ publish  
→ verify the corrected current state replaces the rollback version.

**Certified Gold Test 5 — Stale but Available**
→ interrupt upstream processing  
→ verify Certified Gold remains available  
→ observe increasing freshness age  
→ recover upstream processing  
→ verify freshness eventually returns.

The exact scenarios must preserve the integrity of the Version 1 laboratory.

### 17.48 Certified Gold Availability and Rollback Guarantees

The Atlas Engineering Certified Gold reliability model must preserve the following guarantees:

1. Certified Gold is the governed consumer-visible analytical availability boundary;
2. upstream processing failure does not automatically remove a trustworthy certified version;
3. candidate state remains isolated until required certification succeeds;
4. candidate failure does not automatically affect the previous certified version;
5. stale but trustworthy state remains distinguishable from incorrect or unavailable state;
6. consumers can determine the freshness context of the active certified state;
7. publication eligibility requires all applicable blocking controls;
8. publication is atomic from the consumer perspective;
9. publication metadata identifies the active governed version;
10. publication failure preserves a clear known-good consumer-visible state where possible;
11. partial publication does not remain as an accepted mixed state;
12. rollback restores a previous known-good certified version;
13. rollback remains distinct from rebuild and backup restoration;
14. rollback target is selected according to trust rather than age alone;
15. rollback may restore correctness and availability while freshness remains degraded;
16. consumer compatibility is considered before rollback;
17. certified-version retention supports the actual rollback strategy;
18. historical published versions remain sufficiently stable for audit, comparison, and rollback;
19. certification and publication history remain traceable;
20. post-publication defects can invalidate previously certified state;
21. published-data incidents prioritize removal of untrusted consumer-visible state;
22. if no known-good certified version exists, the affected product may become unavailable rather than serve known-invalid data;
23. analytical availability and recovery state remain product-specific;
24. upstream catch-up does not bypass certification;
25. intermediate recovery publication remains subject to complete certification for its declared boundary;
26. rollback is followed by corrected roll-forward when current state must be restored;
27. roll-forward candidates receive full validation;
28. rollback and roll-forward remain represented in lineage and metadata;
29. rollback preserves current security, privacy, and governance requirements;
30. rollback capability remains bounded by retained certified history;
31. consumer-visible recovery point remains distinguishable from upstream preserved data;
32. rollback may provide faster analytical availability than complete reconstruction;
33. publication freeze can protect consumers while upstream investigation continues;
34. consumer recovery remains distinguishable from complete upstream catch-up;
35. Certified Gold availability and rollback behavior is considered demonstrated only after controlled validation and evidence.

---

## 18. Recovery and Historical Versions

Atlas Engineering recovery depends not only on retaining historical data but also on retaining enough historical interpretation context to process that data correctly.

A retained event, Bronze record, Silver state, or Gold version is not fully recoverable if the platform no longer knows how that historical state was structured, interpreted, transformed, validated, or published.

The governing principle is:

**Historical Data + Applicable Historical Context = Recoverable Historical State**

Historical context may include:

- source schema;
- event contract;
- processing definition;
- reference-data state;
- quality rules;
- reconciliation rules;
- dimensional semantics;
- certification metadata;
- publication metadata.

Data retention without interpretation capability provides only partial recoverability.

### 18.1 Historical Version Context

Historical processing may span multiple versions of the platform.

A historical record may have been produced under a different:

- source schema;
- event schema;
- contract version;
- transformation version;
- dimensional definition;
- reference-data version;
- quality rule;
- certification rule.

Recovery must identify the context applicable to the historical scope being reconstructed.

### 18.2 Version Identity

Version-sensitive platform artifacts should have an identifiable version or equivalent immutable reference where required for recovery.

Version identity may apply to:

- event contracts;
- processing code;
- configuration;
- schema definitions;
- data models;
- quality rules;
- reconciliation logic;
- published Gold versions.

The implementation mechanism may vary.

The architectural requirement is that the definition used for a recoverable historical result can be identified.

### 18.3 Historical Event Contracts

Retained historical events may use contract versions different from the current producer contract.

Replay requires consumers to interpret the contract associated with each historical event.

The platform must therefore preserve:

- contract identity;
- contract version;
- required schema definition;
- compatibility information where applicable.

Historical replay capability is weakened if older retained events can no longer be interpreted.

### 18.4 Contract Evolution

Contract evolution must consider both future processing and historical recovery.

A new contract version may be:

- backward compatible;
- forward compatible where supported;
- fully compatible where required;
- intentionally breaking.

A breaking contract change may require:

- new consumer logic;
- explicit migration;
- new processing version;
- historical adapter;
- bounded support policy.

The platform must not assume that current consumer code can interpret every historical contract indefinitely.

### 18.5 Apicurio Registry Historical Role

Apicurio Registry supports the preservation and identification of governed event-contract versions.

For recovery, the registry must retain the definitions required to interpret historical events that remain inside the supported recovery window.

Deleting an old contract definition while corresponding retained events remain recoverable would create an avoidable interpretation gap.

Registry retention and event-retention strategy must therefore remain aligned.

### 18.6 Source Schema Evolution

AtlasCommerce may evolve over time.

Changes may include:

- new columns;
- changed constraints;
- new reference values;
- new tables;
- deprecated attributes;
- structural redesign.

Historical recovery must determine whether the source representation applicable to the historical interval differs from the current source model.

Current source schema must not automatically be projected backward onto historical data.

### 18.7 Bronze Schema Evolution

Bronze should preserve sufficient raw information and metadata to support historical interpretation.

Where Bronze representation evolves, the platform should preserve enough context to determine:

- original event structure;
- contract version;
- ingestion version;
- relevant source metadata;
- processing time;
- provenance.

Bronze evolution must not silently destroy the ability to interpret retained historical records.

### 18.8 Silver Schema Evolution

Silver represents standardized analytical semantics.

A Silver definition may change because of:

- corrected transformation;
- renamed or restructured fields;
- changed normalization;
- new business interpretation;
- reference-data changes;
- contract evolution.

Historical Silver state should therefore remain associated with the processing definition that produced it.

A newer Silver schema does not automatically invalidate older Silver state.

### 18.9 Gold Model Evolution

Gold may evolve through:

- dimensional-model changes;
- new facts;
- new dimensions;
- changed measures;
- changed grain;
- changed surrogate-key strategy;
- corrected business rules.

Historical Gold versions must remain distinguishable when their analytical semantics differ.

Consumers must not assume that values from different Gold versions are directly comparable when the governing definitions changed materially.

### 18.10 Processing Definition

A processing definition represents the logic required to transform governed input into a derived result.

It may include:

- code;
- configuration;
- mappings;
- reference dependencies;
- schema expectations;
- quality behavior;
- processing parameters.

Recovery should identify the processing definition used for the reconstructed output.

A code repository commit may contribute to this identity but may not be sufficient if runtime configuration also affects behavior.

### 18.11 Processing Version

A processing version should identify a materially meaningful transformation definition.

Versioning may be implemented using:

- Git commit;
- release identifier;
- container image version;
- artifact version;
- deployment version;
- explicit processing version metadata.

The final implementation may combine several identifiers.

The objective is reproducibility rather than version numbering for its own sake.

### 18.12 Configuration Version

Processing behavior may depend on configuration outside application code.

Examples include:

- topic mappings;
- schema mappings;
- processing parameters;
- quality thresholds;
- reference mappings;
- feature flags;
- orchestration parameters.

Recovery must preserve or identify configuration that materially affects historical output.

Reusing historical code with incompatible current configuration may not reproduce the historical result.

### 18.13 Infrastructure Version

Infrastructure version may matter when behavior changes materially between technology versions.

Examples include:

- SQL Server;
- Kafka;
- Debezium;
- Apicurio Registry;
- MinIO;
- Airflow;
- processing runtime.

Atlas Engineering does not need to preserve every historical infrastructure binary indefinitely.

However, material compatibility dependencies that affect recovery must be documented and validated.

### 18.14 Historical Reproduction

Historical reproduction attempts to reconstruct what should have been produced under the historically applicable definitions.

The governing model is:

**Historical Input**
+
**Historical Contract**
+
**Historical Processing Definition**
+
**Historical Required Context**
→ **Historical Expected Result**

This mode is useful for:

- reproducibility;
- audit;
- investigation;
- comparison;
- validation of historical behavior.

### 18.15 Historical Restatement

Historical restatement intentionally applies a corrected or newer definition to historical input.

The governing model is:

**Historical Input**
+
**Selected New Processing Definition**
+
**Selected Context**
→ **New Historical Result**

Restatement may legitimately change historical analytical output.

It must therefore create identifiable new lineage rather than silently replacing the interpretation history.

### 18.16 Reproduction Versus Restatement

The recovery objective must explicitly distinguish:

**Reproduction**
→ What should the platform have produced using the applicable historical definition?

from:

**Restatement**
→ What should historical data look like according to the selected corrected or current definition?

Both are valid.

They answer different questions.

A recovery procedure must not accidentally perform one while claiming the other.

### 18.17 Corrected Historical Logic

A processing defect creates a special case.

The historically deployed implementation may have been defective.

Reproducing the defective implementation exactly may reproduce the wrong result.

The recovery objective may instead require:

**Historical Intended Definition**
rather than:
**Historical Executed Defect**.

Evidence should distinguish:

- what code actually ran;
- what behavior was intended;
- what corrected definition was selected;
- why the reconstructed result differs.

### 18.18 Historical Reference Data

Historical processing may depend on reference values valid at a particular time.

Examples may include:

- statuses;
- classifications;
- mappings;
- business categories;
- controlled lookup values.

Recovery must determine whether it requires:

**Historical Reference State**

or:

**Current Reference State**.

Using current reference data during historical reproduction may silently change the result.

### 18.19 Reference-Data Versioning

Reference data that materially affects historical interpretation should preserve sufficient temporal or version context where required.

Possible approaches include:

- effective-date history;
- versioned snapshots;
- immutable reference versions;
- governed historical tables.

Not every static lookup requires complex versioning.

Versioning is required when changes would otherwise make historical results irreproducible or ambiguous.

### 18.20 Historical Business Rules

Business rules may evolve.

Examples include:

- transaction classification;
- status interpretation;
- customer segmentation;
- inventory logic;
- analytical calculation;
- dimensional assignment.

A historical result should remain attributable to the business-rule definition used to produce it.

Historical restatement using a new business rule must be explicit.

### 18.21 Quality Rule Versions

Quality expectations may evolve over time.

A dataset that passed quality controls under one rule set might fail under a later rule set.

Recovery must distinguish:

**Was this historical result valid under the rules applicable at the time?**

from:

**Would this historical result satisfy today's rules?**

These are different validation questions.

### 18.22 Historical Quality Reproduction

When reproducing a historical processing state, the applicable historical quality rules may be required to understand whether the output should have been accepted at that time.

This supports:

- audit;
- incident analysis;
- certification-history reconstruction.

It does not prevent the platform from applying current controls additionally for present-day governance.

### 18.23 Current Quality Validation of Historical Data

Historical data reconstructed today may also need to satisfy current controls before becoming newly consumer-visible.

For example:

**Historical Reproduction**
→ reproduces historical result.

But:

**New Publication Today**
→ may still require current certification controls.

Historical correctness and current publication eligibility are related but separate concerns.

### 18.24 Reconciliation Rule Versions

Reconciliation logic may also evolve.

Historical recovery should preserve enough context to understand:

- which reconciliation was originally performed;
- what thresholds or comparisons applied;
- whether current reconstruction uses a newer reconciliation definition.

A changed reconciliation rule must not silently rewrite historical certification evidence.

### 18.25 Certification Rule Versions

Certification criteria may change over time.

A version certified under historical criteria remains evidence of the decision made under those criteria.

If that version is republished or reconstructed today, current certification requirements may also apply.

The platform must preserve both:

**Historical Certification Context**

and:

**Current Publication Decision**

where relevant.

### 18.26 Historical Certification Evidence

Historical Certified Gold should retain enough evidence to determine:

- candidate version;
- processing version;
- quality result;
- reconciliation result;
- certification rule context;
- publication time;
- active interval;
- later invalidation or rollback where applicable.

This supports reconstruction of what consumers were authorized to see at a given time.

### 18.27 Versioned Lineage

Lineage should connect historical output to the versions that materially produced it.

Conceptually:

**Source / Event Version**
→ **Bronze Representation**
→ **Silver Processing Version**
→ **Gold Processing Version**
→ **Quality / Reconciliation Context**
→ **Certified Version**

Versioned lineage allows historical output to remain explainable after the platform evolves.

### 18.28 Version Compatibility

Recovery may require compatibility between:

- retained data;
- current runtime;
- historical contracts;
- historical processing artifacts;
- current storage structures.

Compatibility must be validated rather than assumed.

A retained historical artifact that cannot execute or be interpreted in the current environment may require:

- migration;
- adapter;
- compatibility layer;
- controlled reconstruction using an equivalent definition.

### 18.29 Historical Processing Artifact Retention

Processing artifacts required for the supported recovery window should remain identifiable and retrievable.

Depending on implementation, this may include:

- source code;
- packaged artifact;
- container image;
- SQL script;
- configuration;
- schema definition;
- deployment manifest.

Retention should be aligned with actual recovery requirements.

The platform does not need to preserve unused artifacts indefinitely without a governed reason.

### 18.30 Git as Historical Evidence

Git provides important historical evidence for:

- source code;
- SQL;
- configuration committed to the repository;
- architecture documentation;
- processing definitions.

Git history can help identify the intended implementation at a given version.

However, Git alone does not automatically capture:

- runtime configuration;
- secrets;
- external reference state;
- mutable infrastructure state;
- deployed artifact identity.

Recovery evidence must therefore not assume that a commit hash alone fully reproduces a historical execution.

### 18.31 Immutable Artifact Identity

Where packaged processing artifacts are used, immutable identity strengthens reproducibility.

Examples include:

- immutable container image digest;
- immutable release artifact;
- versioned SQL deployment package.

A mutable tag such as `latest` is insufficient historical identity.

The implementation should prefer immutable references for processing artifacts used in governed recovery.

### 18.32 Historical Secrets

Recovery must not require preservation of old secret values merely to reproduce a historical execution.

Secrets are operational credentials, not business-processing semantics.

Historical processing should use currently authorized credentials while preserving the historical logical definition.

Expired or revoked credentials must not be restored simply for reproducibility.

### 18.33 Historical Security Policy

Historical reproduction does not justify restoring obsolete security permissions.

Current security and privacy controls remain applicable during recovery.

For example:

**Historical Process Had Broad Access**
does not imply
**Broad Historical Access Must Be Recreated Today**.

Logical reproducibility must remain compatible with current governance.

### 18.34 Historical Privacy Requirements

Data that was historically available may later become subject to:

- deletion;
- anonymization;
- retention expiration;
- access restriction.

Recovery must respect the current lawful and governed data state.

Historical reproducibility does not override privacy obligations.

A deleted or no-longer-authorized value must not be resurrected merely because an old processing artifact expects it.

### 18.35 Historical Data Deletion

When governed retention or privacy policy permanently removes historical data, some previous recovery capability may intentionally cease to exist.

The platform should acknowledge this explicitly.

The recovery guarantee becomes bounded by:

- retained data;
- retained interpretation context;
- current governance.

The architecture must not promise indefinite historical reconstruction where policy intentionally removes required history.

### 18.36 Version Dependency Matrix

For significant processing versions, Atlas Engineering may maintain a version dependency matrix identifying relationships such as:

**Processing Version**
→ supported input contract versions  
→ required reference-data context  
→ output schema version  
→ quality-rule version.

This can simplify:

- replay planning;
- reprocessing;
- rebuild;
- compatibility analysis.

The exact implementation may remain lightweight in Version 1.

### 18.37 Recovery Version Selection

Before historical recovery begins, the selected version context should answer:

- What input version is being recovered?
- What processing definition will interpret it?
- Is the objective reproduction or restatement?
- What reference state is required?
- What output version will be produced?
- What quality and reconciliation rules apply?
- What certification rules apply to publication today?

Version selection is part of the recovery plan.

### 18.38 Unsupported Historical Version

A retained historical version may eventually fall outside the supported recovery window.

Possible reasons include:

- incompatible technology;
- intentionally expired artifacts;
- deleted data;
- retired contract;
- unavailable historical dependency.

The platform should identify such limitations explicitly.

Unsupported history must not be presented as fully recoverable merely because some raw files remain.

### 18.39 Version Migration

Historical data may require migration before it can be processed by the current platform.

Migration must preserve:

- source identity;
- provenance;
- original version;
- migration version;
- transformation rationale;
- resulting contract.

Migration should not erase the distinction between original historical representation and migrated representation.

### 18.40 Recovery Across Multiple Versions

A single recovery interval may span several historical versions.

For example:

**Interval A**
→ Contract V1 + Silver V2.

**Interval B**
→ Contract V2 + Silver V2.

**Interval C**
→ Contract V2 + Silver V3.

Recovery may therefore need to:

- segment historical scope;
- apply version-specific interpretation;
- normalize results;
- reconcile across version boundaries.

Applying one processing definition blindly to the complete interval may produce incorrect results.

### 18.41 Version Boundary Detection

Recovery must be able to identify meaningful version boundaries where different interpretation is required.

Boundaries may be derived from:

- event metadata;
- deployment metadata;
- contract identifiers;
- processing metadata;
- effective dates;
- Git or release history.

The boundary must be evidence-based rather than guessed from approximate dates.

### 18.42 Historical Version Testing

Version compatibility should be tested using representative retained historical data.

Tests may validate:

- old contract interpretation;
- processing artifact compatibility;
- schema migration;
- reference-data reconstruction;
- output consistency;
- historical reproduction;
- historical restatement.

A version being stored is not evidence that it remains usable.

### 18.43 Recovery Drift

Recovery drift occurs when the platform retains historical data but gradually loses the practical ability to reconstruct it because:

- contracts disappear;
- artifacts become unavailable;
- dependencies become incompatible;
- undocumented configuration changes;
- reference history is lost;
- tests no longer cover historical versions.

Recovery capability must therefore be maintained, not merely designed once.

### 18.44 Historical Recovery Window

The supported historical recovery window is bounded by the intersection of:

- data retention;
- contract retention;
- processing-artifact retention;
- reference-history retention;
- technical compatibility;
- current security and privacy requirements.

Conceptually:

**Historical Recovery Window**
=
**Oldest Point for Which All Required Recovery Dependencies Remain Available and Governed**

The shortest required dependency may determine the effective window.

### 18.45 Version Retention Alignment

Retention policies should avoid obvious mismatches such as:

**Kafka Events Retained**
but:
**Required Contract Deleted**

or:

**Bronze Retained**
but:
**Required Processing Definition Unavailable**.

Retention alignment does not require every artifact to share the same duration.

It requires the complete recovery dependency set to remain available for the recovery capability being claimed.

### 18.46 Historical Recovery Validation

Historical recovery validation should confirm, where applicable:

- input version identified;
- contract available;
- processing version identified;
- configuration context available;
- reference context appropriate;
- objective identified as reproduction or restatement;
- output version explicit;
- quality rules identified;
- reconciliation rules identified;
- current certification requirements applied where publication occurs;
- lineage preserved;
- security and privacy requirements respected.

Historical processing is not considered reproducible merely because execution completes.

### 18.47 Historical Version Evidence

Representative evidence should preserve:

- recovery interval;
- input versions;
- contract versions;
- processing versions;
- artifact identifiers;
- configuration context;
- reference-data context;
- reproduction or restatement objective;
- output version;
- quality and reconciliation versions;
- certification context;
- observed compatibility issues;
- migration or adapter usage;
- final validation result.

This evidence demonstrates that historical recovery is version-aware rather than accidental.

### 18.48 Historical Version Test Scenarios

Version 1 should validate representative scenarios such as:

**Historical Version Test 1 — Older Event Contract**
→ retain events using an earlier contract version  
→ evolve the contract compatibly  
→ replay historical events  
→ demonstrate correct interpretation.

**Historical Version Test 2 — Processing Version**
→ process a bounded historical interval using one transformation version  
→ preserve the result  
→ modify the transformation  
→ reproduce or restate the same interval according to the declared objective  
→ demonstrate the difference.

**Historical Version Test 3 — Reference Change**
→ process historical input using one reference state  
→ change the reference value  
→ reprocess according to historical reproduction and restatement objectives  
→ demonstrate why the resulting semantics differ.

**Historical Version Test 4 — Version Boundary**
→ create a controlled historical interval spanning two processing or contract versions  
→ recover the interval using version-aware boundaries  
→ validate the combined result.

The exact scenarios should reflect the final Version 1 implementation.

### 18.49 Recovery and Historical Version Guarantees

The Atlas Engineering historical-version recovery model must preserve the following guarantees:

1. retained data alone does not constitute complete recoverability;
2. historical recovery preserves sufficient interpretation context;
3. version-sensitive artifacts remain identifiable where required;
4. historical event contracts remain available throughout their supported recovery window;
5. contract retention remains aligned with retained event recoverability;
6. current source schema is not automatically projected onto historical state;
7. Bronze preserves sufficient metadata for historical interpretation;
8. Silver and Gold historical state remain attributable to the processing definitions that produced them;
9. materially different Gold semantics remain distinguishable across versions;
10. processing identity includes materially relevant code and configuration;
11. immutable artifact identity is preferred where packaged artifacts are used;
12. infrastructure compatibility requirements are documented where they affect recovery;
13. historical reproduction remains distinct from historical restatement;
14. corrected historical logic distinguishes intended behavior from previously executed defects;
15. historical reference context is preserved where required for reproducibility;
16. evolving business rules remain attributable to historical outputs;
17. historical and current quality validation remain distinguishable;
18. reconciliation and certification rule evolution does not silently rewrite historical evidence;
19. versioned lineage connects outputs to materially relevant historical definitions;
20. compatibility between historical artifacts and current execution environments is validated;
21. processing artifacts required by the supported recovery window remain retrievable;
22. Git history contributes to recovery evidence but is not treated as complete runtime reproduction by itself;
23. historical recovery does not require restoration of expired or revoked credentials;
24. current security and privacy requirements remain authoritative during historical recovery;
25. governed deletion may intentionally reduce historical recoverability;
26. recovery version selection is explicit before historical processing begins;
27. unsupported historical versions are identified rather than represented as fully recoverable;
28. historical migration preserves original provenance and version identity;
29. recovery intervals spanning multiple versions use evidence-based version boundaries;
30. historical-version compatibility is tested rather than inferred from artifact retention;
31. recovery drift is treated as a reliability risk;
32. the effective historical recovery window is bounded by the shortest required governed dependency;
33. retention policies preserve the complete dependency set required for the recovery capability being claimed;
34. historical recovery is considered demonstrated only after version-aware validation and evidence.

---

## 19. Recovery Validation and Evidence

Atlas Engineering must validate recovery using observable and reproducible evidence.

A recovery action is not considered successful merely because:

- a service restarted;
- a connection succeeded;
- a task returned `SUCCESS`;
- a consumer resumed;
- consumer lag reached zero;
- a table became queryable;
- a dashboard became available.

Recovery validation must demonstrate that the affected responsibility returned to a correct governed state.

The governing model is:

**Known Pre-Failure State → Failure → Preserved Recovery State → Recovery Action → Recovered State → Validation → Evidence → Recovery Closure**

The depth of validation must reflect the architectural responsibility and failure scope.

### 19.1 Recovery Validation

Recovery validation determines whether the platform has restored the required:

- service capability;
- durable state;
- processing continuity;
- data completeness;
- data correctness;
- downstream consistency;
- certification state;
- consumer availability.

Not every incident requires every validation dimension.

The required validation scope depends on what failed and what recovery mechanism was used.

### 19.2 Recovery Evidence

Recovery evidence is the retained information that supports the conclusion that recovery succeeded or failed.

Evidence may include:

- timestamps;
- service state;
- logs;
- metrics;
- offsets;
- checkpoints;
- source positions;
- row counts;
- reconciliation results;
- quality results;
- lineage;
- certification records;
- publication metadata;
- consumer-visible results.

Evidence should be sufficient to reconstruct the important recovery sequence after the incident or laboratory test has ended.

### 19.3 Evidence Before Recovery

Where available, the platform should preserve the last known state before recovery begins.

Relevant information may include:

- last successful source position;
- Kafka offsets;
- consumer checkpoints;
- latest Bronze boundary;
- latest Silver boundary;
- latest Gold candidate;
- active Certified Gold version;
- backlog;
- freshness;
- failure time.

This establishes the starting point against which recovery can be evaluated.

### 19.4 Evidence During Failure

Failure evidence should preserve enough context to determine:

- what failed;
- when it failed;
- how the failure was detected;
- which component or processing scope was affected;
- which upstream processing continued;
- which downstream processing stopped;
- what durable state remained available;
- whether backlog accumulated;
- whether consumers remained available.

The objective is to identify the actual blast radius rather than infer it later from incomplete information.

### 19.5 Evidence Before Remediation

Before changing state during recovery, the platform should capture the relevant failure condition where practical.

This may include:

- failed offset;
- failed processing version;
- exception category;
- corrupted or missing state;
- active candidate;
- current certified version;
- dependency condition;
- backlog state.

Recovery actions can destroy useful diagnostic evidence.

Important pre-remediation state should therefore be preserved before destructive or state-changing intervention where feasible.

### 19.6 Recovery Action Evidence

Recovery actions should remain attributable.

Relevant information may include:

- action performed;
- execution time;
- target component;
- recovery source;
- selected processing boundary;
- selected historical interval;
- processing version;
- configuration version;
- execution identity;
- result.

This allows later analysis to distinguish what the platform recovered automatically from what required explicit intervention.

### 19.7 Recovery Source Evidence

The recovery source must be identifiable.

Examples include:

- CDC;
- Kafka;
- Bronze;
- Silver;
- backup;
- historical archive;
- previous Certified Gold version.

Evidence should demonstrate why the selected source was considered trustworthy for the affected recovery scope.

A successful execution from an unvalidated source does not prove correct recovery.

### 19.8 Recovery Boundary Evidence

Recovery must identify the boundary from which processing resumed or reconstruction began.

Examples include:

- SQL Server LSN or equivalent source position;
- Kafka topic, partition, and offset;
- Bronze historical interval;
- Silver processing checkpoint;
- Gold processing boundary;
- certified-version identifier.

The boundary should be explicit enough to support investigation of:

- gaps;
- overlap;
- replay;
- duplicate processing;
- recovery completeness.

### 19.9 Service Recovery Validation

Service recovery confirms that the required technical capability is operational.

Representative checks may include:

- process running;
- endpoint reachable;
- dependency connection successful;
- authentication successful;
- required storage accessible;
- required topic or database available.

Service recovery is normally the first validation layer.

It is not the final recovery conclusion.

### 19.10 Processing Recovery Validation

Processing recovery confirms that the component has resumed its architectural responsibility.

Representative checks may include:

- source positions advancing;
- events publishing;
- consumers processing;
- checkpoints advancing;
- files being persisted;
- transformations completing;
- Gold candidates being generated.

A running process with no meaningful progress is not considered successfully recovered.

### 19.11 Data Recovery Validation

Data recovery confirms that the required data state is complete and correct for the intended recovery boundary.

Validation may include:

- expected record presence;
- expected historical interval;
- counts;
- business-key coverage;
- ordering;
- duplicate detection;
- referential consistency;
- transformation correctness.

The exact controls depend on the recovered layer.

### 19.12 Continuity Validation

Continuity validation determines whether recovery preserved the complete required sequence between:

**Last Known-Good Progress**

and:

**Recovered Progress**.

For event-driven processing, this may include:

- source positions;
- Kafka offsets;
- partition sequences;
- checkpoints.

The objective is to demonstrate:

**No Unexplained Gap**

and:

**No Uncontrolled Overlap**.

Controlled redelivery or replay is acceptable when duplicate effects are prevented.

### 19.13 Gap Detection

A processing gap exists when required input cannot be accounted for between known progress boundaries.

Possible evidence includes:

- missing source positions;
- missing offsets;
- missing Bronze intervals;
- unexplained count differences;
- missing business keys;
- incomplete downstream state.

A gap must not be hidden by advancing the recovery checkpoint.

If the gap cannot be reconstructed from the current recovery source, recovery-source escalation is required.

### 19.14 Overlap Detection

Recovery may intentionally revisit previously processed input.

Overlap is not inherently incorrect.

The platform must determine whether overlap resulted from:

- retry;
- redelivery;
- replay;
- reprocessing;
- backfill;
- recovery-boundary selection.

Validation should demonstrate that overlap did not create unintended duplicate business effects.

### 19.15 Duplicate-Effect Validation

Duplicate delivery may be expected.

Duplicate business effects are not.

Recovery validation should determine, where applicable, whether repeated processing created:

- duplicate Bronze records beyond the intended representation;
- duplicate Silver state;
- duplicate fact rows;
- repeated inventory effects;
- repeated financial effects;
- repeated dimensional versions.

Idempotency claims should be supported by observed recovery behavior.

### 19.16 Ordering Validation

Where ordering is required, recovery must demonstrate that the relevant sequence remains valid.

This may apply to:

- Kafka partition order;
- entity history;
- transaction state transitions;
- inventory movement;
- dimensional changes.

A complete set of records in the wrong processing order may still produce an incorrect result.

### 19.17 Checkpoint Validation

Checkpoint validation should confirm:

- expected checkpoint before failure;
- checkpoint used for recovery;
- checkpoint progression during recovery;
- final checkpoint;
- relationship between checkpoint and durable output.

A checkpoint must not advance beyond data that has not reached its required durable state.

### 19.18 Backlog Validation

When backlog accumulated, validation should capture:

- backlog at failure or recovery start;
- oldest pending age;
- backlog trend;
- incoming rate;
- processing rate;
- time to normal operating range.

Recovery is not complete merely because the affected service restarted.

Backlog must converge according to the expected recovery behavior.

### 19.19 Retention Validation

Recovery evidence should confirm that required upstream history remained inside the applicable retention window.

Relevant sources may include:

- CDC;
- Kafka;
- retained Bronze history;
- backups;
- archived historical data.

If required history expired during the incident, the recovery evidence must identify the alternative recovery source used.

### 19.20 Bronze Recovery Validation

Bronze recovery validation should confirm, where applicable:

- required Kafka input was represented;
- source and event identity preserved;
- expected historical interval complete;
- duplicate handling behaved as designed;
- raw fidelity preserved;
- lineage metadata available.

Bronze recovery is particularly important because Bronze forms the primary long-term analytical reconstruction boundary.

### 19.21 Silver Recovery Validation

Silver recovery validation should confirm:

- expected Bronze scope processed;
- correct processing version used;
- checkpoint aligned;
- standardization complete;
- required entity state correct;
- quality controls passed;
- lineage preserved.

If Silver was rebuilt, validation should compare the reconstructed state with the expected governed definition rather than merely confirm row creation.

### 19.22 Gold Recovery Validation

Gold recovery validation should confirm:

- intended Silver boundary used;
- dimensional processing complete;
- fact and dimension relationships valid;
- expected business measures produced;
- quality passed;
- reconciliation passed;
- candidate state complete.

Gold processing success does not itself authorize consumer publication.

### 19.23 Certified Gold Recovery Validation

Certified Gold recovery validation should confirm:

- active certified version;
- candidate state;
- certification result;
- publication result;
- atomic consumer visibility;
- freshness;
- rollback state where applicable;
- consumer access.

The final consumer-visible version must agree with certification and publication metadata.

### 19.24 Quality Validation

Recovery must reapply the quality controls required by the recovered processing boundary.

Recovery execution is not exempt from normal quality requirements.

Where historical reproduction uses historical quality rules, the applicable rule context must remain explicit.

Where reconstructed data is published today, current certification requirements may also apply.

### 19.25 Reconciliation Validation

Reconciliation provides evidence that recovered state is consistent with the expected upstream or business boundary.

Possible comparisons include:

- source versus captured events;
- Kafka versus Bronze;
- Bronze versus Silver;
- Silver versus Gold;
- expected business totals versus analytical totals.

Not every layer requires one-to-one row-count equality.

Reconciliation must reflect the transformation semantics.

### 19.26 Cross-Layer Validation

For significant recovery events, validation should cross more than one architectural boundary.

For example:

**Kafka Recovery**
should not end with:
→ broker is running.

It may continue through:

→ events readable  
→ Bronze advances  
→ Silver advances  
→ Gold advances  
→ Certified Gold freshness recovers.

The required depth depends on the failure scope and recovery objective.

### 19.27 End-to-End Recovery Validation

An end-to-end recovery test validates the complete path from authoritative source change to consumer-visible certified state.

A representative validation may establish:

**AtlasCommerce Commit**
→ CDC capture  
→ Debezium publication  
→ Kafka retention  
→ Bronze persistence  
→ Silver processing  
→ Gold candidate  
→ quality  
→ reconciliation  
→ certification  
→ publication  
→ Power BI consumption.

This provides the strongest evidence for platform-level recovery claims.

### 19.28 Consumer Validation

Consumer recovery validation should confirm that the intended analytical product is:

- reachable;
- queryable;
- governed;
- using the expected Certified Gold version;
- within the expected freshness state.

Consumer availability must not be validated by bypassing Certified Gold and querying an upstream layer directly.

### 19.29 Freshness Validation

Freshness validation should compare the consumer-visible state with the intended source-processing boundary.

Useful evidence may include:

- maximum source commit time represented;
- maximum event time represented;
- processing completion time;
- certification time;
- publication time;
- current freshness age.

Freshness should be measured according to the semantics defined for the product.

### 19.30 RPO Validation

RPO validation determines the effective recovery point achieved after failure.

Evidence should identify:

- last source state known to exist;
- latest recoverable state;
- latest reconstructed state;
- latest certified consumer-visible state;
- any intentionally lost or unavailable interval.

RPO must be demonstrated using data boundaries rather than inferred solely from backup schedules or retention configuration.

### 19.31 RTO Validation

RTO validation should measure the recovery experienced by the responsibility being evaluated.

Possible milestones include:

- failure detected;
- recovery started;
- service restored;
- processing resumed;
- backlog returned to normal range;
- validation completed;
- Certified Gold restored;
- consumer freshness restored.

The correct endpoint depends on the recovery objective.

Service restart time alone is insufficient for end-to-end analytical RTO.

### 19.32 Recovery Timeline

A recovery timeline should preserve the sequence of important events.

For example:

**T0**
→ failure begins.

**T1**
→ failure detected.

**T2**
→ recovery action begins.

**T3**
→ component operational.

**T4**
→ processing resumes.

**T5**
→ backlog returns to normal range.

**T6**
→ downstream validation passes.

**T7**
→ Certified Gold current.

This allows recovery delay to be decomposed into meaningful stages.

### 19.33 Detection Time

Recovery analysis should distinguish detection time from repair time.

Conceptually:

**Detection Time**
=
**Failure Detection - Failure Start**

A platform may recover quickly after intervention but still have poor reliability if failures remain undetected for long periods.

Detection evidence belongs to the complete recovery story.

### 19.34 Intervention Time

The time between detection and recovery action may reflect:

- alert routing;
- diagnosis;
- decision;
- operator availability;
- automation.

Conceptually:

**Intervention Delay**
=
**Recovery Start - Failure Detection**

This can reveal operational weaknesses independently from technical recovery speed.

### 19.35 Technical Restoration Time

Technical restoration measures how long the affected capability takes to become operational after recovery begins.

Conceptually:

**Technical Restoration Time**
=
**Service Restored - Recovery Start**

This metric is useful but must remain distinct from complete data and consumer recovery.

### 19.36 Processing Recovery Time

Processing recovery measures the interval required to restore normal processing state after technical capability returns.

It may include:

- backlog catch-up;
- replay;
- reprocessing;
- rebuild.

Conceptually:

**Processing Recovery Time**
=
**Processing Normalized - Service Restored**

### 19.37 Consumer Recovery Time

Consumer recovery measures when an acceptable governed analytical state becomes available again.

Depending on the incident, this may be:

- previous Certified Gold;
- rollback version;
- corrected current version.

Consumer recovery time can therefore differ significantly from complete upstream recovery time.

### 19.38 Full Recovery Time

Full recovery should be defined according to the affected reliability objective.

For an end-to-end analytical incident, it may include:

**Detection**
+
**Intervention**
+
**Technical Restoration**
+
**Processing Recovery**
+
**Validation**
+
**Certification / Publication**

The definition used in a test or incident must be explicit.

### 19.39 Automated Evidence Collection

Where practical, recovery evidence should be collected automatically.

Examples include:

- timestamps;
- metrics;
- offsets;
- checkpoints;
- task states;
- version identifiers;
- certification results.

Automation reduces:

- transcription errors;
- missing evidence;
- inconsistent measurements.

Manual evidence may still be required for investigation, decisions, and contextual interpretation.

### 19.40 Manual Evidence

Manual evidence may include:

- operator notes;
- recovery decision;
- root-cause interpretation;
- screenshots where useful;
- validation observations;
- exceptional actions.

Manual evidence should complement machine-generated state rather than replace objective measurements where those measurements are available.

### 19.41 Evidence Correlation

Evidence from different components should be correlatable where practical.

Useful correlation dimensions may include:

- execution identifier;
- event identity;
- source position;
- topic and offset;
- processing run;
- data-product version;
- recovery incident identifier;
- timestamp.

Correlation supports reconstruction of how one failure propagated and recovered across multiple layers.

### 19.42 Time Consistency

Recovery evidence depends heavily on timestamps.

Platform components should use consistent time handling sufficient to compare events across:

- SQL Server;
- Kafka;
- processing services;
- MinIO;
- Airflow;
- observability;
- AtlasWarehouse.

Clock inconsistency can distort:

- latency;
- failure duration;
- recovery duration;
- event ordering interpretation.

Time synchronization is therefore a reliability dependency.

### 19.43 Evidence Integrity

Recovery evidence must be trustworthy enough to support architectural claims.

Evidence should not be manually altered merely to make a test appear successful.

Where practical, evidence should be:

- generated automatically;
- timestamped;
- attributable;
- retained;
- reproducible.

A failed test is valid engineering evidence.

It identifies a capability that still requires correction.

### 19.44 Failed Recovery Evidence

Failed recovery attempts should be preserved where useful.

Evidence may show:

- recovery source insufficient;
- retry ineffective;
- backlog unable to converge;
- wrong recovery boundary;
- historical contract unavailable;
- validation failure;
- rollback failure.

Discarding failed experiments removes information that can improve architecture and procedures.

### 19.45 Recovery Test Record

Each controlled recovery test should produce a concise test record.

A representative record may include:

- test identifier;
- objective;
- scenario;
- affected component;
- initial state;
- failure injection;
- expected behavior;
- observed behavior;
- recovery action;
- recovery source;
- recovery boundary;
- validation;
- measured RPO;
- measured RTO;
- result;
- evidence references;
- observations.

This provides a repeatable structure for laboratory evidence.

### 19.46 Expected Versus Observed Behavior

Recovery testing must distinguish architectural expectation from laboratory observation.

For example:

**Expected**
→ consumer resumes from committed offset without data loss.

**Observed**
→ consumer resumed from offset X, processed Y retained events, and produced no unexplained reconciliation difference.

This distinction prevents architecture documentation from presenting an intended guarantee as though it had already been demonstrated.

### 19.47 PASS Criteria

A recovery test should define PASS criteria before or as part of test design.

Representative criteria may include:

- no unexplained data loss;
- no unintended duplicate business effect;
- correct recovery boundary;
- expected ordering preserved;
- backlog converges;
- required quality passes;
- reconciliation passes;
- Certified Gold behavior matches architecture;
- measured recovery remains within the test objective.

PASS must be based on evidence rather than subjective observation.

### 19.48 FAIL Criteria

A recovery test should fail when required behavior is not demonstrated.

Representative conditions include:

- unexplained data gap;
- duplicate business effect;
- incorrect checkpoint;
- inability to recover retained history;
- invalid state published;
- rollback unsuccessful;
- backlog does not converge;
- required quality or reconciliation fails.

A FAIL result should trigger investigation and corrective work rather than adjustment of the evidence to fit the expected architecture.

### 19.49 Inconclusive Result

Some tests may be inconclusive.

Examples include:

- telemetry unavailable;
- failure injection not achieved;
- test environment changed unexpectedly;
- insufficient workload;
- missing evidence.

An inconclusive test must not be recorded as PASS.

It should be repeated after the limitation is corrected.

### 19.50 Evidence and Architectural Claims

Atlas Engineering should make reliability claims proportional to the available evidence.

Conceptually:

**Designed**
→ architectural behavior documented.

**Implemented**
→ capability exists.

**Tested**
→ controlled scenario executed.

**Demonstrated**
→ expected behavior supported by retained evidence.

The project should avoid describing a reliability property as demonstrated when it exists only in documentation.

### 19.51 Evidence and Version 1 Limitations

Version 1 laboratory evidence must be interpreted within the actual topology.

For example, successful logical recovery tests do not prove:

- multi-node Kafka high availability;
- multi-host storage redundancy;
- production-scale throughput;
- cross-region disaster recovery.

Evidence must support only the claim actually tested.

This distinction preserves the credibility of the architecture.

### 19.52 Evidence Retention

Recovery evidence should remain available long enough to support:

- architecture validation;
- troubleshooting;
- comparison between tests;
- capacity planning;
- portfolio demonstration;
- future design decisions.

Evidence retention should remain compatible with:

- security;
- privacy;
- storage;
- repository policy.

Sensitive operational information should not be published merely because recovery evidence is useful.

### 19.53 Evidence in Public Documentation

Public Atlas Engineering documentation may include selected recovery evidence demonstrating architectural behavior.

Examples may include:

- sanitized metrics;
- test timelines;
- backlog graphs;
- reconciliation summaries;
- PASS/FAIL results;
- recovery observations.

Public evidence must not expose:

- secrets;
- credentials;
- sensitive data;
- unnecessary infrastructure details that create security risk.

The objective is to demonstrate engineering decisions, not expose protected operational information.

### 19.54 Recovery Evidence and Observability

Observability provides much of the runtime evidence required for recovery validation.

Examples include:

- lag;
- throughput;
- error rates;
- backlog age;
- service health;
- processing latency;
- freshness;
- recovery progress.

The specialized **Observability** architecture defines how these signals are collected, stored, visualized, and alerted.

This document defines why those signals matter to recovery.

### 19.55 Recovery Evidence and Documentation

Significant recovery behavior discovered through laboratory testing should feed back into architecture and operational documentation.

For example:

**Expected Recovery**
→ test performed  
→ unexpected bottleneck discovered  
→ architecture assumption corrected  
→ recovery documentation updated.

Documentation should represent validated system behavior rather than remain permanently frozen at the original design assumption.

### 19.56 Recovery Evidence and FAQ

Questions answered through recovery testing should contribute to the architectural FAQ where they represent recurring or important design concerns.

Examples include:

- What happens if Kafka stops?
- Can Bronze be rebuilt?
- What happens if Kafka retention expires?
- Can Silver be rebuilt without replaying Kafka?
- How is a poison record handled?
- What does the consumer see during Gold recovery?
- How long does catch-up take after an outage?
- What happens if the latest Certified Gold version is invalid?

Where possible, FAQ answers should reference the relevant controlled laboratory evidence.

### 19.57 Recovery Validation Test Scenarios

Version 1 should include representative validation scenarios such as:

**Recovery Validation Test 1 — Kafka Consumer Restart**
→ record initial offsets and Bronze state  
→ stop the consumer  
→ generate controlled source changes  
→ restart the consumer  
→ validate offset continuity  
→ validate Bronze completeness  
→ validate downstream progression.

**Recovery Validation Test 2 — Silver Rebuild**
→ preserve a known Bronze interval  
→ remove or isolate the corresponding Silver state in the laboratory  
→ rebuild Silver  
→ compare reconstructed state with expected results  
→ validate quality and lineage.

**Recovery Validation Test 3 — Gold Rollback**
→ publish a controlled Certified Gold version  
→ create and publish a test version that is subsequently invalidated  
→ rollback  
→ validate active version and consumer visibility  
→ preserve the complete publication timeline.

**Recovery Validation Test 4 — Backlog Catch-Up**
→ stop a controlled consumer  
→ accumulate backlog  
→ restore processing  
→ measure throughput, backlog trend, oldest pending age, and time to normal operating range.

**Recovery Validation Test 5 — End-to-End Recovery**
→ introduce a controlled interruption  
→ preserve pre-failure state  
→ recover the affected component  
→ follow progress through Bronze, Silver, Gold, certification, and publication  
→ validate the final consumer-visible state.

The exact test procedures should be defined after the corresponding Version 1 components are implemented.

### 19.58 Recovery Validation and Evidence Guarantees

The Atlas Engineering recovery-validation model must preserve the following guarantees:

1. service restart alone does not establish successful recovery;
2. recovery validation reflects the architectural responsibility that failed;
3. recovery evidence preserves enough context to reconstruct significant recovery behavior;
4. relevant pre-failure and pre-remediation state is preserved where practical;
5. recovery actions remain attributable;
6. recovery source and recovery boundary are explicit;
7. service, processing, data, and consumer recovery remain distinguishable;
8. continuity validation identifies unexplained gaps and uncontrolled overlap;
9. controlled redelivery, replay, or reprocessing does not create unintended duplicate business effects;
10. required ordering remains validated;
11. checkpoint state remains consistent with durable processing state;
12. backlog convergence is part of recovery validation where backlog accumulated;
13. required retention remains validated against the recovery interval;
14. Bronze, Silver, Gold, and Certified Gold use validation appropriate to their responsibilities;
15. recovery does not bypass quality, reconciliation, certification, or publication controls;
16. significant recovery events validate downstream consequences where appropriate;
17. end-to-end testing can demonstrate recovery from source change to consumer-visible certified state;
18. freshness recovery remains distinguishable from service availability;
19. RPO is demonstrated using actual data boundaries;
20. RTO reflects the recovery objective being measured rather than only process restart;
21. recovery timelines distinguish detection, intervention, technical restoration, processing recovery, and consumer recovery;
22. objective evidence is collected automatically where practical;
23. manual evidence complements rather than replaces available objective measurements;
24. evidence across components remains correlatable where practical;
25. consistent time handling supports trustworthy recovery measurements;
26. failed recovery attempts remain valid engineering evidence;
27. controlled tests produce structured recovery records;
28. expected architecture and observed laboratory behavior remain explicitly distinguishable;
29. PASS, FAIL, and inconclusive results are evidence-based;
30. reliability claims remain proportional to demonstrated evidence;
31. Version 1 laboratory limitations remain explicit;
32. evidence retention respects security, privacy, and repository policy;
33. selected sanitized evidence may support public architecture documentation;
34. observability supplies runtime evidence without replacing recovery semantics;
35. laboratory findings feed back into architecture and operational documentation;
36. recurring recovery questions can be incorporated into the architectural FAQ with evidence references;
37. recovery capability is considered demonstrated only after controlled validation and retained evidence.

---

## 20. Recovery Testing Strategy

Atlas Engineering must validate reliability and recovery through controlled laboratory testing.

Recovery testing is intended to demonstrate how the implemented platform behaves when selected components, dependencies, processing paths, or governed states are interrupted or invalidated.

The governing model is:

**Define Expected Behavior → Establish Baseline → Inject Controlled Failure → Observe Impact → Execute Recovery → Validate Result → Preserve Evidence → Improve Architecture**

Recovery testing must remain:

- intentional;
- bounded;
- observable;
- repeatable where practical;
- reversible;
- evidence-based.

The purpose is not to create uncontrolled disruption.

The purpose is to demonstrate whether the implemented recovery architecture behaves as designed.

### 20.1 Testing Objectives

Recovery tests should answer questions such as:

- What happens when a component stops?
- Which data continues to remain durable?
- Which downstream stages stop advancing?
- Does backlog accumulate?
- Can processing resume from committed progress?
- Does redelivery remain idempotent?
- Can retained history be replayed?
- Can derived state be reconstructed?
- Does Certified Gold remain available?
- How long does catch-up require?
- Does recovery preserve quality and reconciliation?
- Which recovery source is actually required?
- Which architecture assumptions are disproven by observation?

Testing should focus on meaningful architectural behavior rather than merely demonstrating that a process can be restarted.

### 20.2 Controlled Failure Injection

Failure injection is the deliberate creation of a bounded failure condition for validation purposes.

Representative mechanisms may include:

- stopping a service;
- pausing a consumer;
- interrupting network connectivity;
- temporarily removing a required permission;
- using an invalid test credential;
- exhausting a controlled resource;
- introducing a deterministic test processing failure;
- isolating a derived target;
- creating a failing Gold candidate;
- interrupting a rebuild.

Failure injection must not:

- expose real secrets;
- destroy irreplaceable project data;
- corrupt unrelated state;
- bypass defined cleanup;
- create uncontrolled external impact.

### 20.3 Laboratory Scope

Version 1 recovery testing occurs in a controlled laboratory.

The laboratory may include:

- one physical workstation;
- local SQL Server;
- containerized Kafka;
- Apicurio Registry;
- MinIO;
- Airflow;
- Prometheus;
- Grafana;
- locally executed processing workloads.

The resulting tests demonstrate behavior only under the documented Version 1 topology and workload.

They do not automatically prove:

- multi-node High Availability;
- cross-host failover;
- production-scale recovery;
- cross-region Disaster Recovery;
- enterprise operational maturity.

### 20.4 Test Baseline

Every meaningful recovery test should begin from a known baseline.

The baseline should identify, where applicable:

- component state;
- processing version;
- source position;
- Kafka offsets;
- Bronze state;
- Silver checkpoint;
- Gold version;
- Certified Gold version;
- backlog;
- freshness;
- quality state;
- reconciliation state;
- relevant resource utilization.

Without a baseline, it becomes difficult to demonstrate exactly what changed because of the failure and recovery.

### 20.5 Baseline Validation

The baseline itself must be valid before failure injection.

A test should not begin from a platform state that already contains unexplained:

- lag;
- gaps;
- failed quality rules;
- invalid candidates;
- unresolved quarantine;
- inconsistent checkpoints.

If the baseline is not trustworthy, the recovery result becomes ambiguous.

### 20.6 Test Hypothesis

A recovery test should define the expected architectural behavior before execution.

For example:

**Hypothesis**

If the Bronze consumer is stopped while Kafka remains available:

- Kafka events continue accumulating;
- Bronze checkpoint remains unchanged;
- no data is lost;
- Certified Gold eventually becomes stale;
- after restart, Bronze resumes from committed progress;
- backlog decreases;
- no duplicate business effect occurs;
- downstream processing eventually catches up.

The test should attempt to validate or disprove this hypothesis.

### 20.7 Expected Failure Impact

The expected blast radius should be documented before failure injection.

For example:

**Kafka Consumer Failure**

Expected impact:

- source continues;
- Debezium continues;
- Kafka accumulates retained events;
- Bronze stops;
- Silver eventually stops;
- Gold stops advancing;
- Certified Gold remains available but stale.

Observed behavior should later be compared with this expected impact.

### 20.8 PASS Criteria

PASS criteria must be defined according to the architectural behavior being tested.

Representative criteria include:

- expected failure occurs;
- no unexplained data loss;
- required durable state remains available;
- checkpoint remains consistent;
- expected backlog accumulates;
- recovery begins from the intended boundary;
- backlog converges;
- idempotency preserves business correctness;
- quality passes;
- reconciliation passes;
- certification behaves correctly;
- consumer-visible state matches the architecture.

A test must not be considered PASS merely because the failed component started again.

### 20.9 FAIL Criteria

Representative FAIL conditions include:

- failure cannot be reproduced as intended;
- required history is lost unexpectedly;
- checkpoint skips unprocessed input;
- duplicate business effect appears;
- backlog cannot converge;
- incorrect recovery source is required;
- invalid state becomes Certified Gold;
- rollback fails;
- quality or reconciliation remains invalid;
- consumer sees mixed publication state;
- required evidence is unavailable.

FAIL is an engineering result, not a documentation problem.

It should drive investigation and remediation.

### 20.10 Inconclusive Criteria

A test should be recorded as inconclusive when the intended behavior cannot be evaluated reliably.

Possible reasons include:

- telemetry failure;
- invalid baseline;
- uncontrolled unrelated failure;
- insufficient workload;
- failure injection unsuccessful;
- missing evidence;
- environment changed during execution.

An inconclusive result must not be converted into PASS.

### 20.11 Failure Injection Boundary

The test must identify the exact boundary being disrupted.

Examples include:

**Component**
→ stop Debezium.

**Dependency**
→ prevent Bronze from reaching MinIO.

**Processing**
→ introduce controlled Silver transformation failure.

**Data**
→ introduce a controlled poison input.

**Publication**
→ interrupt publication before promotion completes.

Precise boundary definition improves interpretation of observed blast radius.

### 20.12 One Failure at a Time

Initial reliability tests should normally inject one primary failure at a time.

This helps isolate:

- cause;
- effect;
- recovery behavior;
- metrics;
- evidence.

Compound-failure testing should occur after individual component behavior is understood.

Version 1 should prefer clarity and reproducibility over artificial complexity.

### 20.13 Compound Failure Testing

After isolated failures are understood, selected compound scenarios may be useful.

Examples include:

**Debezium Down + CDC Retention Aging**

**Bronze Down + Kafka Backlog Growing**

**Rebuild Running + Live Workload Increasing**

**Credential Failure + Recovery Attempt**

Compound tests should answer a specific architectural question.

They should not exist merely to make the laboratory appear more sophisticated.

### 20.14 Failure Duration

Failure duration must be controlled.

Different durations may test different properties.

For example:

**Short Interruption**
→ restartability and transient backlog.

**Longer Interruption**
→ catch-up capacity.

**Retention-Window Scenario**
→ recovery-source risk.

Tests must avoid unnecessarily allowing required retained history to expire unless the expiration behavior itself is the controlled objective.

### 20.15 Test Workload

Recovery tests should use a controlled workload.

The workload should be sufficient to produce observable behavior such as:

- backlog;
- lag;
- partition activity;
- downstream progression;
- measurable catch-up.

A test with insufficient data may demonstrate process restart without meaningfully testing recovery.

The workload should remain small enough to preserve laboratory safety and repeatability.

### 20.16 Synthetic Test Data

Recovery testing should prefer synthetic project data.

Synthetic data supports scenarios involving:

- poison records;
- historical corrections;
- privacy behavior;
- failed transactions;
- controlled backfill;
- replay;
- rebuild.

Tests do not require real production personal data.

### 20.17 Test Data Identity

Test data should be identifiable enough to support:

- lineage;
- source-to-target comparison;
- replay validation;
- duplicate-effect validation;
- cleanup.

Dedicated test identifiers, transaction ranges, or business-key ranges may help isolate laboratory scenarios.

### 20.18 Test Isolation

A recovery test should minimize unintended effect on unrelated laboratory state.

Possible isolation strategies include:

- dedicated source records;
- dedicated Kafka keys;
- bounded time windows;
- dedicated consumer group;
- isolated target version;
- dedicated Gold candidate;
- controlled test dataset.

Isolation simplifies cleanup and evidence interpretation.

### 20.19 Test Cleanup

Each recovery test must define cleanup where required.

Cleanup may include:

- restoring service configuration;
- removing temporary failure conditions;
- revoking temporary credentials;
- restoring permissions;
- deleting temporary recovery objects;
- resolving test quarantine records;
- restoring ordinary consumer groups;
- removing test-only targets.

The environment should return to a known governed state after testing.

### 20.20 Cleanup Validation

Cleanup itself should be validated.

A test that demonstrates recovery but leaves:

- excessive permission;
- invalid checkpoint;
- test credentials;
- stale temporary data;
- altered retention;
- orphaned consumers;

has not been completed correctly.

### 20.21 Restart Test

Restart testing validates ordinary component restartability.

A representative flow is:

1. establish baseline;
2. stop the selected component;
3. preserve failure evidence;
4. allow controlled pending work to accumulate where applicable;
5. restart;
6. validate recovered progress;
7. validate downstream behavior;
8. preserve recovery evidence.

Restart tests should precede more destructive rebuild scenarios.

### 20.22 Retry Test

Retry testing validates bounded transient-failure handling.

A representative test may:

1. create temporary dependency failure;
2. observe retries;
3. confirm retry timing;
4. restore dependency;
5. confirm processing succeeds;
6. confirm progress advances;
7. confirm no duplicate business effect.

A second scenario should validate retry exhaustion and transition to explicit persistent-failure handling.

### 20.23 Redelivery Test

Redelivery testing validates idempotency.

A representative scenario may intentionally process the same logical input more than once.

Validation should demonstrate:

- duplicate delivery occurred;
- repeated processing was observable;
- final intended business result remained correct;
- no unintended duplicate fact or business effect was created.

### 20.24 Replay Test

Replay testing should validate:

- explicit historical boundary;
- retained history availability;
- controlled consumer position;
- ordering;
- idempotency;
- downstream reconstruction;
- final validation.

A replay test should distinguish replay from ordinary restart catch-up.

### 20.25 Reprocessing Test

Reprocessing testing should validate both:

**Same Logic**
→ equivalent historical result.

and, where practical:

**Corrected Logic**
→ expected controlled historical difference.

The test should preserve the selected processing version and resulting lineage.

### 20.26 Backfill Test

Backfill testing should demonstrate:

- identified historical gap or initialization requirement;
- governed source extraction;
- bounded scope;
- source impact;
- live-processing overlap where applicable;
- provenance;
- downstream processing;
- reconciliation.

A backfill test should demonstrate why ordinary retained replay was insufficient for the scenario.

### 20.27 Rebuild Test

Rebuild testing should validate reconstructibility of derived state.

Representative targets include:

- Silver from Bronze;
- Gold from Silver.

The test should demonstrate:

- clean target strategy;
- selected upstream source;
- processing version;
- progress;
- restartability where applicable;
- quality;
- reconciliation;
- final state.

### 20.28 Interrupted Rebuild Test

A rebuild claim should include interruption behavior where practical.

A representative test may:

1. begin a multi-batch rebuild;
2. stop it deliberately;
3. preserve partial progress;
4. restart or resume;
5. complete reconstruction;
6. validate final result.

This demonstrates that rebuild capability does not depend on one uninterrupted long-running execution.

### 20.29 Backlog Recovery Test

Backlog testing should measure:

- failure duration;
- backlog accumulated;
- oldest pending age;
- incoming rate;
- recovery processing rate;
- catch-up ratio;
- time to normal operating range.

This test provides direct evidence for capacity and RTO analysis.

### 20.30 Poison Record Test

Persistent-failure testing should demonstrate:

- bounded retry;
- retry exhaustion;
- explicit failure state;
- safe isolation or blocking;
- preserved input;
- remediation;
- reprocessing;
- reintegration;
- final completeness.

The test must not merely show that the error appears in a log.

### 20.31 Partition Isolation Test

Where Kafka partitioning is used, Version 1 should validate that a controlled failure in one partition does not unnecessarily stop independent partitions while preserving required ordering.

Evidence should include:

- affected partition;
- unaffected partition progress;
- checkpoint state;
- backlog;
- recovery;
- final ordering and completeness.

### 20.32 Certification Failure Test

A controlled Gold candidate should fail a blocking quality or reconciliation condition.

Expected behavior:

**Candidate**
→ remains unpublished.

**Previous Certified Gold**
→ remains consumer-visible.

The test validates fail-safe publication behavior rather than only quality-rule execution.

### 20.33 Publication Failure Test

Publication failure testing should validate the consumer-visible atomicity requirement.

A controlled failure should occur around the publication boundary.

The test should demonstrate that consumers observe:

- previous version;

or:

- new complete version;

but not an uncontrolled mixed state.

### 20.34 Rollback Test

Rollback testing should demonstrate:

- new certified version published;
- controlled defect or invalidation declared;
- previous version remains retained;
- rollback executes;
- invalid version is no longer active;
- consumer can access rollback version;
- metadata matches physical state.

### 20.35 Roll-Forward Test

After rollback, a corrected candidate should be produced.

The test should demonstrate:

**Rollback**
→ remediation  
→ rebuild or reprocessing  
→ new candidate  
→ certification  
→ publication  
→ current state restored.

This validates that rollback is a temporary recovery boundary rather than the final correction mechanism.

### 20.36 Retention Boundary Test

Retention-related tests should demonstrate the effect of bounded history.

Version 1 may test this safely using disposable test data and shortened laboratory retention where appropriate.

The objective may be to demonstrate:

- history available within retention;
- replay possible;
- history unavailable after controlled expiration;
- recovery source must change.

Required project data must not be intentionally destroyed merely to demonstrate the concept.

### 20.37 Historical Version Test

Historical-version testing should validate at least one scenario involving:

- older event contract;
- older processing version;
- changed reference context;
- reproduction versus restatement.

The test should demonstrate that historical recovery is version-aware.

### 20.38 Observability Failure Test

A controlled observability failure may validate that:

- data processing remains distinguishable from monitoring availability;
- telemetry gaps are visible;
- recovery can still use other state such as checkpoints and logs;
- missing observability reduces confidence but does not automatically imply data loss.

The test should not intentionally disable evidence required to evaluate a critical destructive scenario.

### 20.39 End-to-End Failure Test

After individual component behavior is validated, Version 1 should execute at least one end-to-end recovery scenario.

A representative test may:

1. establish a clean source-to-Certified-Gold baseline;
2. interrupt one meaningful processing component;
3. continue controlled source activity;
4. observe downstream degradation;
5. recover the component;
6. observe backlog cascade;
7. validate Bronze;
8. validate Silver;
9. validate Gold;
10. validate certification;
11. validate Certified Gold freshness;
12. preserve the complete recovery timeline.

This provides a strong portfolio-level demonstration of the architecture.

### 20.40 Test Repetition

Important recovery tests should be repeated where practical.

A single PASS demonstrates one successful execution.

Repeated PASS results provide stronger evidence of predictable behavior.

Tests involving timing should be repeated enough to identify variation before any representative recovery estimate is presented.

### 20.41 Repeatability

A repeatable test should define:

- initial state;
- workload;
- failure injection;
- duration;
- recovery action;
- validation queries;
- cleanup.

Another execution under equivalent laboratory conditions should be capable of reproducing the scenario.

### 20.42 Test Automation

Suitable recovery tests may eventually be automated.

Candidates include:

- service interruption;
- test workload generation;
- offset capture;
- backlog measurement;
- quality validation;
- reconciliation;
- PASS/FAIL evaluation;
- evidence collection.

Automation should be introduced only after the manual recovery behavior is understood.

Automating an unclear procedure can make incorrect behavior repeatable rather than correct.

### 20.43 Manual Tests

Some laboratory scenarios may remain manual because they require:

- diagnosis;
- architecture interpretation;
- controlled destructive action;
- visual observation;
- deliberate selection of recovery source.

Manual tests remain valid when their procedures and expected results are documented clearly.

### 20.44 Test Safety

Recovery tests must protect the laboratory from unnecessary destructive impact.

Before a destructive scenario, the test should determine:

- what state may be lost;
- whether that state is reproducible;
- whether backup exists where required;
- whether the scenario can affect unrelated work;
- how cleanup will occur.

A test must not intentionally destroy the only copy of data required for continued project development.

### 20.45 Failure Injection Safety Boundary

Failure injection should stop when unexpected behavior threatens:

- unrecoverable project state;
- unrelated development data;
- host stability;
- source integrity;
- required recovery history.

The correct response is to stop the test, preserve evidence, understand the unexpected condition, and redesign the experiment.

### 20.46 Recovery Test Catalog

Atlas Engineering should maintain a recovery test catalog.

A representative catalog may include:

| Category | Example |
|---|---|
| Restart | Bronze consumer restart |
| Retry | Temporary MinIO failure |
| Redelivery | Duplicate Kafka delivery |
| Replay | Controlled Kafka interval replay |
| Reprocessing | Corrected Silver logic |
| Backfill | Missing bounded source interval |
| Rebuild | Silver from Bronze |
| Catch-Up | Kafka backlog recovery |
| Poison Record | Deterministic transformation failure |
| Isolation | Partition-specific failure |
| Certification | Blocking candidate failure |
| Publication | Atomic publication interruption |
| Rollback | Previous Certified Gold restoration |
| Historical Version | Older contract replay |
| End-to-End | Source-to-consumer recovery |

Each catalog entry should reference its formal test definition and evidence after implementation.

### 20.47 Test Naming

Stable identifiers should be used for recovery tests.

A possible convention is:

- `REL-RST-*` — Restart;
- `REL-RTY-*` — Retry;
- `REL-RDL-*` — Redelivery;
- `REL-RPL-*` — Replay;
- `REL-RPR-*` — Reprocessing;
- `REL-BFL-*` — Backfill;
- `REL-RBL-*` — Rebuild;
- `REL-BLG-*` — Backlog / Catch-Up;
- `REL-PSN-*` — Poison Records;
- `REL-ISO-*` — Failure Isolation;
- `REL-CFG-*` — Certified Gold / Publication;
- `REL-HST-*` — Historical Versions;
- `REL-E2E-*` — End-to-End Recovery.

The exact naming convention may be refined during implementation.

Stable IDs should remain consistent once referenced by evidence or FAQ documentation.

### 20.48 Test Record

Each recovery test should maintain a structured record containing, where applicable:

- Test ID;
- Test Name;
- Objective;
- Architecture Requirement;
- Environment;
- Initial State;
- Workload;
- Failure Injection;
- Expected Impact;
- Expected Recovery;
- PASS Criteria;
- FAIL Criteria;
- Recovery Source;
- Recovery Boundary;
- Recovery Action;
- Validation;
- Cleanup;
- Result;
- Observations;
- Evidence References.

This structure supports consistency across laboratory tests.

### 20.49 Test Evidence

Evidence may include:

- structured logs;
- SQL query output;
- Kafka offsets;
- consumer lag;
- processing checkpoints;
- Prometheus metrics;
- Grafana captures;
- quality results;
- reconciliation output;
- certification metadata;
- publication history;
- consumer queries.

Evidence should be selected according to the architectural claim being demonstrated.

### 20.50 Test Result

Every completed test must have one explicit result:

**PASS**

**FAIL**

or:

**INCONCLUSIVE**

A narrative such as:

**“It mostly worked.”**

is not a valid final test state.

Observations may explain nuance, but the test result must remain explicit.

### 20.51 Failed Test Workflow

A FAIL should follow:

**FAIL**
→ preserve evidence  
→ investigate  
→ identify root cause  
→ decide whether implementation or architecture is incorrect  
→ remediate  
→ update documentation where required  
→ execute the test again.

The original failed evidence should remain available where useful.

### 20.52 Architecture Correction

Recovery testing may demonstrate that the documented architecture is wrong.

For example:

- selected checkpoint behavior creates omission;
- Kafka retention is insufficient;
- catch-up capacity cannot converge;
- Silver cannot be reconstructed from the retained Bronze representation;
- rollback mechanism is not atomic.

The correct response is to change the architecture or implementation.

The expected result must not be rewritten merely to preserve the original design.

### 20.53 Capacity Findings

Recovery testing may produce capacity evidence such as:

- sustained processing rate;
- maximum observed catch-up rate;
- CPU or memory bottleneck;
- storage throughput;
- partition skew;
- database write bottleneck.

These findings should feed into:

- performance tuning;
- capacity planning;
- future RTO evaluation;
- enterprise evolution.

### 20.54 Reliability Baseline

After the principal Version 1 tests are executed, Atlas Engineering should maintain a reliability baseline describing which capabilities are:

- designed;
- implemented;
- tested;
- demonstrated;
- partially demonstrated;
- not implemented;
- planned for enterprise evolution.

The baseline should be specific.

It should not summarize the platform using an unsupported generic label such as:

**Highly Available**

or:

**Production Ready**.

### 20.55 Recovery Test Review

The recovery test catalog should be reviewed when:

- architecture changes;
- processing semantics change;
- retention changes;
- new components are introduced;
- Gold products change;
- new recovery mechanisms are implemented;
- a significant defect is found;
- enterprise evolution changes the topology.

Previously passing tests may become regression tests for later versions.

### 20.56 Recovery Regression Testing

Important reliability behavior should be revalidated after material changes.

Representative regression scenarios include:

- consumer restart;
- duplicate delivery;
- replay;
- Silver rebuild;
- Gold rollback;
- backlog catch-up.

A historical PASS does not prove that a later implementation still behaves the same way.

### 20.57 Laboratory Versus Chaos Engineering

Version 1 recovery testing should not be described as enterprise chaos engineering merely because failures are injected intentionally.

The laboratory performs:

**Controlled Failure Testing**

with:

- bounded scenarios;
- known initial state;
- explicit hypothesis;
- defined recovery;
- evidence.

Enterprise chaos engineering may involve broader automated experimentation, resilience platforms, production-like topology, and continuous hypothesis testing.

The concepts are related, but the claims must remain proportional to implementation.

### 20.58 Recovery Testing Guarantees

The Atlas Engineering recovery-testing model must preserve the following guarantees:

1. recovery behavior is validated through controlled failure testing;
2. tests begin from a known trustworthy baseline;
3. expected behavior and blast radius are defined before failure injection;
4. PASS, FAIL, and INCONCLUSIVE criteria are explicit;
5. failure injection is bounded, reversible, and safe for the laboratory;
6. initial tests prefer one primary failure at a time;
7. compound failures are tested only when they answer a defined architectural question;
8. failure duration is controlled according to the property being tested;
9. workloads are large enough to produce meaningful recovery behavior but remain safe for Version 1;
10. synthetic test data is preferred;
11. test data and test scope remain identifiable;
12. test isolation and cleanup preserve the laboratory's governed state;
13. restart, retry, redelivery, replay, reprocessing, backfill, rebuild, catch-up, poison-record, isolation, certification, publication, rollback, and historical-version behaviors are tested according to their distinct semantics;
14. interrupted rebuild and recovery scenarios validate restartability where practical;
15. backlog tests measure convergence rather than only service availability;
16. publication tests validate consumer-visible atomicity;
17. rollback is followed by roll-forward testing where appropriate;
18. retention-boundary testing does not unnecessarily destroy required project history;
19. historical-version testing validates real interpretation behavior;
20. at least one meaningful end-to-end recovery scenario is executed after component behavior is understood;
21. important recovery tests are repeatable where practical;
22. automation follows understanding rather than replacing it;
23. destructive tests preserve a defined safety boundary;
24. recovery tests use stable identifiers and structured test records;
25. every completed test has an explicit result;
26. failed tests drive investigation, remediation, and revalidation;
27. evidence is allowed to change architecture;
28. recovery tests contribute capacity and performance findings;
29. Version 1 maintains a specific evidence-based reliability baseline;
30. important reliability behavior becomes regression testing after material changes;
31. controlled laboratory failure testing is not misrepresented as enterprise chaos engineering;
32. recovery-testing claims remain limited to scenarios actually implemented, executed, and evidenced.

---

## 21. Recovery Observability

Atlas Engineering recovery must be observable.

The platform must provide enough runtime information to determine:

- whether a component is operational;
- whether processing is advancing;
- whether backlog is accumulating;
- whether retries are succeeding or exhausting;
- whether checkpoints remain consistent;
- whether recovery windows are shrinking;
- whether downstream freshness is degrading;
- whether recovery is converging;
- whether Certified Gold remains trustworthy and available.

The governing model is:

**Detect → Localize → Measure → Recover → Observe Progress → Validate → Confirm Normal State**

Observability does not replace recovery logic.

It provides the information required to understand when recovery is needed, whether the selected mechanism is working, and when the affected capability can be considered restored.

### 21.1 Recovery Observability Scope

Recovery observability should cover, where applicable:

- service health;
- dependency health;
- processing progress;
- checkpoints;
- consumer lag;
- backlog;
- retry activity;
- persistent failures;
- quarantine;
- recovery-window state;
- throughput;
- processing latency;
- freshness;
- quality;
- reconciliation;
- certification;
- publication;
- consumer availability.

The exact signal set depends on the component and processing responsibility.

### 21.2 Service Health

Service health indicates whether a component is operational from a technical perspective.

Representative states may include:

- running;
- stopped;
- degraded;
- unavailable;
- restarting.

Service health is useful but insufficient by itself.

A service may report healthy while:

- processing is stalled;
- checkpoints are not advancing;
- backlog is growing;
- downstream data is stale.

### 21.3 Dependency Health

A service may be healthy while one of its required dependencies is unavailable.

Recovery observability should therefore distinguish:

**Component Health**

from:

**Dependency Health**.

Relevant dependencies may include:

- SQL Server;
- Kafka;
- MinIO;
- AtlasWarehouse;
- schema registry;
- authentication;
- network path.

This distinction supports faster root-cause identification.

### 21.4 Processing Progress

Processing progress must be observable where required for recovery.

Relevant indicators may include:

- CDC position;
- Kafka offset;
- consumer checkpoint;
- processed interval;
- batch identifier;
- watermark;
- Gold candidate version;
- certification state.

A healthy processing stage should demonstrate actual progress, not merely process uptime.

### 21.5 Checkpoint Observability

Checkpoint state should be available for recovery analysis.

Useful information may include:

- current committed checkpoint;
- previous checkpoint;
- time of last advancement;
- affected partition or scope;
- processing version.

A checkpoint that has not advanced for an unusual interval may indicate:

- blocked processing;
- dependency failure;
- persistent input failure;
- stalled execution.

### 21.6 Checkpoint Staleness

Checkpoint age is an important reliability signal.

Conceptually:

**Checkpoint Age**
=
**Current Time - Last Successful Progress Commit**

An old checkpoint may indicate stalled processing even when service health remains green.

The expected age depends on workload and processing cadence.

### 21.7 Kafka Consumer Lag

Kafka consumer lag represents the difference between:

**Latest Available Offset**

and:

**Consumer Committed Offset**

for a consumer group and partition.

Lag is a primary signal for:

- backlog;
- processing interruption;
- insufficient throughput;
- catch-up progress.

Aggregate lag should not hide partition-specific problems.

### 21.8 Partition-Level Lag

Partition-level lag should remain visible where Kafka processing depends on partition ordering.

One partition may remain significantly behind while the consumer group appears healthy in aggregate.

Relevant information may include:

- partition;
- current offset;
- end offset;
- lag;
- oldest pending event age.

This helps detect skew and partial failure.

### 21.9 Backlog Depth

Backlog depth measures how much recoverable work remains pending.

Possible measures include:

- events;
- records;
- files;
- bytes;
- processing intervals;
- pending batches.

Backlog depth should be interpreted with age and processing rate rather than as an isolated number.

### 21.10 Oldest Pending Age

The age of the oldest pending work indicates how long the earliest unprocessed data has been waiting.

This is often more meaningful for freshness than backlog count alone.

A growing oldest-pending age indicates that processing is not converging toward current state.

### 21.11 Backlog Trend

Recovery observability should distinguish:

**Growing**
→ backlog increases.

**Stable**
→ backlog remains approximately unchanged.

**Decreasing**
→ catch-up is occurring.

The trend provides direct evidence of whether recovery is converging.

### 21.12 Incoming Rate

Incoming rate measures how quickly new work enters the affected processing boundary.

Examples include:

- CDC changes per second;
- Kafka events per second;
- Bronze records per interval;
- Silver input volume.

Incoming rate provides context for interpreting backlog and catch-up behavior.

### 21.13 Processing Rate

Processing rate measures the effective throughput of the affected processing stage.

Examples include:

- Kafka events processed per second;
- Bronze records persisted per second;
- Silver records transformed per second;
- Gold rows or batches generated per interval.

Processing rate should be interpreted together with incoming rate.

### 21.14 Catch-Up Ratio

Recovery observability may expose:

**Catch-Up Ratio = Processing Rate / Incoming Rate**

Interpretation:

**< 1**
→ backlog grows.

**≈ 1**
→ backlog remains stable.

**> 1**
→ backlog can decrease.

This ratio is especially useful during backlog recovery.

### 21.15 Catch-Up Progress

Catch-up progress should indicate whether the processing stage is converging toward the current upstream boundary.

Useful signals may include:

- initial backlog;
- current backlog;
- backlog reduction rate;
- oldest pending age;
- estimated remaining work;
- elapsed recovery time.

Estimated completion should remain clearly distinguishable from observed completion.

### 21.16 Retry Observability

Retry activity should expose, where applicable:

- retry count;
- error category;
- affected operation;
- first failure time;
- latest failure time;
- next retry;
- backoff;
- retry exhaustion state.

High retry activity may indicate a dependency problem even before full processing failure occurs.

### 21.17 Retry Exhaustion

Retry exhaustion should become an explicit observable state.

The platform should be able to identify:

- affected input or operation;
- exhausted retry policy;
- failure classification;
- resulting persistent-failure state;
- required remediation.

Retry exhaustion must not disappear into generic error logging.

### 21.18 Persistent Failure Observability

Persistent failures should expose enough information to determine:

- affected processing stage;
- input identity or scope;
- error category;
- age;
- retry history;
- downstream impact;
- remediation status.

Repeated failures sharing common characteristics should be correlatable where practical.

### 21.19 Quarantine Observability

Quarantine should expose, where applicable:

- unresolved item count;
- oldest quarantined item;
- growth rate;
- failure categories;
- affected entities;
- affected processing stages;
- remediation state;
- recovery status.

A low ordinary backlog does not imply healthy processing when quarantine continues growing.

### 21.20 Processing Gap Observability

Where feasible, the platform should surface evidence of suspected processing gaps.

Signals may include:

- missing offsets;
- missing processing intervals;
- reconciliation differences;
- source-to-target discontinuity;
- incomplete lineage.

A gap is a correctness condition and should not be reduced to an ordinary performance metric.

### 21.21 Recovery Window Observability

Bounded recovery sources should expose enough information to understand how much recovery time remains.

Relevant sources include:

- CDC;
- Kafka;
- backups;
- archives where applicable.

The platform should be capable of evaluating whether required unprocessed history is approaching expiration.

### 21.22 Recovery Window Margin

Where practical, the platform may expose:

**Recovery Window Margin**
→ time remaining before the oldest required recoverable state expires.

A shrinking margin may require higher operational priority than a large but stable backlog with ample retained history.

### 21.23 CDC Recovery Signals

CDC reliability observability may include:

- capture status;
- last captured source position;
- capture latency;
- retained change window;
- Debezium progress relative to source;
- oldest required uncaptured change.

The objective is to detect when source-change recoverability is degrading before history expires.

### 21.24 Debezium Recovery Signals

Relevant Debezium signals may include:

- connector state;
- task state;
- source position;
- event publication rate;
- error rate;
- restart count;
- authentication failures;
- Kafka publication failures.

A connector reporting `RUNNING` without advancing its source position should not be considered healthy.

### 21.25 Kafka Recovery Signals

Kafka reliability signals may include:

- broker availability;
- partition availability;
- producer error rate;
- consumer lag;
- retained-history age;
- storage utilization;
- under-replicated partitions in enterprise topologies;
- consumer-group health.

Version 1 may expose a subset appropriate to its single-node laboratory topology.

### 21.26 Bronze Recovery Signals

Bronze recovery observability may include:

- input offsets;
- persisted record count;
- write failures;
- storage latency;
- checkpoint;
- backlog;
- duplicate-handling state;
- processing version;
- last successful persistence time.

These signals support validation that Kafka history is becoming durable analytical history.

### 21.27 Silver Recovery Signals

Silver recovery observability may include:

- input boundary;
- checkpoint;
- processing rate;
- pending Bronze intervals;
- transformation failures;
- quarantine;
- quality state;
- latest successful Silver boundary;
- processing version.

Silver should not appear current when its checkpoint remains materially behind Bronze.

### 21.28 Gold Recovery Signals

Gold recovery observability may include:

- latest Silver input boundary;
- candidate build state;
- processing version;
- candidate completeness;
- quality result;
- reconciliation result;
- certification status.

Gold `BUILD SUCCESS` is only one state within the broader analytical recovery lifecycle.

### 21.29 Certification Signals

Certification observability should expose:

- candidate version;
- blocking validation state;
- quality status;
- reconciliation status;
- lineage status;
- certification result;
- time waiting for certification.

This allows operators to distinguish:

**Gold Processing Complete**

from:

**Certified Product Ready**.

### 21.30 Publication Signals

Publication observability should expose, where applicable:

- active certified version;
- candidate version;
- publication state;
- publication time;
- previous version;
- rollback state;
- publication failure.

Metadata and physical consumer-visible state should remain consistent.

### 21.31 Certified Gold Freshness

Certified Gold should expose freshness context.

Useful information may include:

- active version;
- latest source boundary represented;
- certification timestamp;
- publication timestamp;
- freshness age;
- expected freshness objective.

A product can therefore be classified as available but stale.

### 21.32 Consumer Availability Signals

Consumer-facing reliability should distinguish:

- product reachable;
- product queryable;
- version available;
- freshness state;
- rollback state;
- certification blocked;
- product unavailable.

This supports product-level analytical availability rather than one global platform status.

### 21.33 Recovery State

Recovery operations should expose an explicit recovery state where useful.

Representative states may include:

**DETECTED**

**CONTAINED**

**RECOVERING**

**CATCHING_UP**

**VALIDATING**

**CERTIFICATION_PENDING**

**RECOVERED**

**FAILED**

The exact implementation may use different names.

The architectural requirement is to make recovery progression understandable.

### 21.34 Recovery Timeline

Recovery observability should support reconstruction of key milestones such as:

- failure start;
- detection;
- recovery start;
- service restoration;
- processing resumption;
- catch-up completion;
- validation completion;
- certification;
- publication;
- freshness restoration.

This timeline supports both RTO analysis and post-incident review.

### 21.35 Recovery Bottleneck

The current recovery bottleneck should be identifiable where practical.

During one recovery sequence, the bottleneck may move through:

**Debezium**
→ **Bronze**
→ **Silver**
→ **Gold**
→ **Certification**

Identifying the active bottleneck helps prevent optimization effort from remaining focused on a component that has already recovered.

### 21.36 Recovery Convergence

Recovery is converging when the platform is moving toward its expected governed state.

Representative convergence signals include:

- backlog decreasing;
- oldest pending age decreasing;
- checkpoints advancing;
- retries reducing;
- quarantine stable or resolving;
- downstream layers advancing;
- freshness improving.

A service that remains running while these signals do not improve may not be recovering.

### 21.37 Recovery Stall

A recovery stall occurs when progress ceases before the expected state is restored.

Possible signs include:

- backlog unchanged;
- checkpoint unchanged;
- retry exhaustion;
- one partition permanently behind;
- certification waiting indefinitely;
- downstream stage no longer advancing.

Recovery stall should transition from ordinary monitoring into investigation or escalation.

### 21.38 Recovery Regression

Recovery observability may reveal that a later platform version recovers more poorly than an earlier one.

Examples include:

- slower catch-up;
- increased retry rate;
- longer rebuild duration;
- larger resource consumption;
- longer certification delay.

Regression should be evaluated against prior evidence rather than hidden by changed dashboards or thresholds.

### 21.39 Recovery and SLOs

Reliability observability provides the measurements required to evaluate service-level objectives.

Relevant dimensions may include:

- freshness;
- processing latency;
- availability;
- recovery time;
- backlog age.

SLO definitions should rely on measured platform behavior.

Detailed SLO dashboards and alert policy belong to **Observability**.

### 21.40 Recovery and RPO

Recovery observability should help identify the latest state that remains:

- captured;
- retained;
- processed;
- certified.

This supports evidence-based determination of the achieved recovery point.

RPO must remain tied to actual data state rather than generic service uptime.

### 21.41 Recovery and RTO

Recovery observability should support measurement of:

- detection time;
- intervention delay;
- technical restoration;
- processing recovery;
- catch-up;
- validation;
- consumer recovery.

This prevents RTO from being reduced incorrectly to service restart time.

### 21.42 Alerting Principles

Recovery-related alerts should focus on conditions requiring action or attention.

Representative conditions include:

- component unavailable;
- processing progress stopped;
- backlog continuously growing;
- retry exhaustion;
- quarantine growth;
- oldest pending age increasing;
- retention margin shrinking;
- one partition materially behind;
- catch-up stalled;
- certification blocked;
- publication failure;
- Certified Gold freshness outside expectation.

Exact thresholds belong to **Observability**.

### 21.43 Alert Severity

Recovery alert severity should reflect architectural consequence.

Factors may include:

- data-loss risk;
- recovery-window risk;
- correctness impact;
- consumer impact;
- duration;
- product criticality;
- availability of a known-good certified state.

A service restart warning and imminent loss of required CDC history should not automatically receive equivalent operational priority.

### 21.44 Alert Correlation

Multiple alerts may describe one underlying failure.

For example:

**Debezium Failure**
→ Kafka event rate drops  
→ Bronze input stops  
→ Silver stops  
→ Certified Gold freshness increases.

Observability should help correlate downstream symptoms with the originating condition where practical.

The operator should not treat every derived alert as an independent incident automatically.

### 21.45 Alert Suppression During Recovery

Some alerts may be expected during a known recovery operation.

For example:

- backlog elevated;
- latency elevated;
- freshness degraded.

The platform may suppress, annotate, or contextualize expected recovery alerts while preserving visibility into:

- worsening conditions;
- stalled convergence;
- new independent failures.

Recovery must not become a blanket reason to silence all alerts.

### 21.46 Recovery Dashboards

A recovery-oriented dashboard may present perspectives such as:

**Source and Capture**
→ CDC and Debezium progress.

**Kafka**
→ lag, partitions, retention risk.

**Bronze / Silver**
→ checkpoints, backlog, throughput, failures.

**Gold**
→ candidate and quality state.

**Certified Gold**
→ active version, freshness, certification, rollback.

**Recovery**
→ current stage, elapsed time, bottleneck, convergence.

Detailed dashboard design belongs to the specialized **Observability** document.

### 21.47 Recovery Logs

Logs should provide contextual detail for recovery events.

Useful information may include:

- component;
- execution identifier;
- recovery identifier;
- checkpoint;
- processing version;
- failure classification;
- retry state;
- recovery action;
- validation result.

Logs should remain structured where practical.

Sensitive values must not be exposed unnecessarily.

### 21.48 Recovery Metrics

Metrics provide quantitative evidence for recovery behavior.

Representative metric categories include:

- availability;
- lag;
- backlog;
- throughput;
- latency;
- retry;
- quarantine;
- retention margin;
- freshness;
- recovery duration;
- certification state.

This document defines the reliability meaning of those measurements.

The specialized **Observability** document defines their concrete implementation.

### 21.49 Recovery Traces and Correlation

Where future implementation supports distributed tracing or equivalent correlation, recovery investigation may benefit from following processing across component boundaries.

Version 1 does not require enterprise distributed tracing.

The architecture should still preserve correlation identifiers where they provide meaningful recovery and lineage value.

### 21.50 Observability Failure During Recovery

Observability itself may fail while recovery is underway.

In that case, the platform should use alternative evidence where available, such as:

- checkpoints;
- database state;
- Kafka offsets;
- processing metadata;
- structured logs;
- reconciliation.

Reduced observability should lower confidence in recovery claims.

A critical recovery must not be declared demonstrated solely through unavailable telemetry.

### 21.51 Recovery Observability Validation

Recovery observability should be tested.

Representative validation may confirm:

- stopped component becomes visible;
- stalled checkpoint is detectable;
- backlog accumulation is measurable;
- catch-up trend is visible;
- retry exhaustion is visible;
- quarantine growth is visible;
- retention risk is detectable;
- certification failure is visible;
- Certified Gold freshness degradation is observable;
- recovery completion is distinguishable from service restart.

### 21.52 Recovery Observability Evidence

Evidence should preserve representative observability behavior such as:

- metric values before failure;
- alert triggered;
- backlog growth;
- retry activity;
- checkpoint stall;
- recovery progression;
- bottleneck migration;
- freshness recovery;
- final alert resolution.

This demonstrates that recovery can be operated based on observable state rather than hidden internal behavior.

### 21.53 Recovery Observability Guarantees

The Atlas Engineering recovery-observability model must preserve the following guarantees:

1. recovery-relevant platform state is observable where technically practical;
2. service health remains distinct from processing health;
3. dependency failures can be distinguished from component failures where possible;
4. processing progress is visible through appropriate durable boundaries;
5. checkpoint staleness can reveal stalled processing;
6. Kafka lag remains visible at partition level where required;
7. backlog depth and oldest pending age remain distinguishable;
8. backlog trend indicates whether recovery is converging;
9. incoming and processing rates provide context for catch-up behavior;
10. retry activity and retry exhaustion remain visible;
11. persistent failures and quarantine remain observable;
12. processing gaps are treated as correctness signals rather than ordinary performance conditions;
13. bounded recovery-window risk is observable where possible;
14. CDC and Debezium observability supports protection of source-change recoverability;
15. Kafka, Bronze, Silver, Gold, certification, and publication expose reliability state appropriate to their responsibilities;
16. Certified Gold availability remains distinguishable from freshness;
17. analytical recovery state can be represented at data-product scope;
18. recovery milestones support complete recovery timelines;
19. the active recovery bottleneck can be identified where practical;
20. convergence and stalled recovery remain distinguishable;
21. recovery regressions can be compared against prior evidence;
22. recovery observability supports evidence-based RPO and RTO analysis;
23. alerts reflect architectural consequence rather than only component error;
24. downstream symptoms can be correlated with originating failures where practical;
25. expected recovery behavior does not justify blanket alert suppression;
26. dashboards, logs, metrics, and correlation provide complementary recovery context;
27. observability failure remains distinguishable from processing failure;
28. recovery claims use alternative evidence when normal telemetry is unavailable;
29. recovery observability is itself tested and evidenced;
30. concrete metrics, dashboards, and thresholds remain governed by the specialized Observability architecture.

---

## 22. Recovery Objectives and Service-Level Expectations

Atlas Engineering defines recovery objectives and service-level expectations according to the architectural capability being protected.

Recovery objectives must reflect:

- business need;
- data criticality;
- processing semantics;
- recovery-source availability;
- retention;
- recovery mechanism;
- processing capacity;
- certification requirements;
- consumer expectations;
- measured platform behavior.

The governing principle is:

**Define the Required Outcome → Identify the Recovery Boundary → Measure Actual Behavior → Establish an Evidence-Supported Objective**

Version 1 must not assign production-grade Recovery Point Objective (RPO), Recovery Time Objective (RTO), availability, or freshness commitments solely because those concepts appear in the architecture.

Laboratory measurements establish observed capability under controlled conditions.

They do not automatically establish enterprise service commitments.

### 22.1 Recovery Objectives

Recovery objectives describe what state the platform must restore and how much data or time impact is acceptable for the affected capability.

Relevant dimensions include:

- recovery point;
- recovery time;
- analytical availability;
- data freshness;
- processing completeness;
- correctness;
- historical recoverability.

These dimensions must remain distinguishable.

A system may recover one dimension while another remains degraded.

### 22.2 Recovery Point Objective

Recovery Point Objective (RPO) expresses the maximum acceptable amount of data state that may be unavailable or unrecoverable after a failure.

RPO is fundamentally a **data-boundary objective**.

It should answer:

**To what point must the affected state be recoverable?**

RPO must not be interpreted only as a backup interval.

Different architectural layers may have different recovery-point characteristics.

### 22.3 RPO by Architectural Boundary

RPO may differ according to the state being recovered.

Examples include:

**Operational Source**
→ source recovery point depends on SQL Server durability and backup/recovery architecture.

**CDC**
→ recoverability depends on retained source-change history.

**Kafka**
→ replay capability depends on retained event history.

**Bronze**
→ historical analytical recovery depends on durable retained raw history.

**Silver / Gold**
→ derived state may be rebuilt from trustworthy upstream boundaries.

**Certified Gold**
→ consumer-visible recovery point may be a previously certified version.

One generic platform RPO may therefore obscure important differences.

### 22.4 Zero Data Loss

A claim of zero data loss is a strong architectural statement.

Atlas Engineering must not claim:

**RPO = 0**

unless the implemented failure scenario demonstrates that all required committed data remains recoverable across the failure domain being claimed.

For example, durable Kafka events may support no event loss for a particular consumer interruption while that does not prove zero data loss for:

- complete host loss;
- Kafka storage loss;
- source recovery;
- all platform failure scenarios.

RPO claims must remain scoped.

### 22.5 Logical Versus Physical RPO

A logical recovery path may preserve data even when a derived layer is physically lost.

For example:

**Silver Lost**
→ Bronze remains complete  
→ Silver can be rebuilt.

From the Silver-data perspective, the effective recoverable point may still reach the latest complete Bronze boundary.

This is different from physical restoration of the lost Silver files themselves.

RPO should therefore describe the recoverable governed state rather than only whether the original physical copy survives.

### 22.6 Consumer-Visible RPO

The analytical consumer may experience a different recovery point from upstream processing.

For example:

**Source and Bronze**
→ complete through 14:00.

**Gold Candidate**
→ invalid.

**Certified Gold**
→ last trusted version represents 13:30.

The consumer-visible recovery point is therefore 13:30 even though upstream recoverable state is newer.

Certified Gold RPO must reflect the state actually safe for publication.

### 22.7 Recovery Time Objective

Recovery Time Objective (RTO) expresses the maximum acceptable elapsed time required to restore a defined capability after failure.

RTO must always identify:

**What capability is considered recovered?**

Possible endpoints include:

- service operational;
- processing resumed;
- backlog normalized;
- derived state reconstructed;
- Certified Gold available;
- freshness restored.

Without an explicit endpoint, RTO is ambiguous.

### 22.8 Component RTO

Component RTO may measure how long a specific technical capability takes to return.

For example:

**Kafka Broker Failure**
→ time until Kafka service is available again.

This can be useful for infrastructure analysis.

It must not be confused with end-to-end analytical recovery.

### 22.9 Processing RTO

Processing RTO measures how long the affected processing responsibility takes to return to its expected operating state.

It may include:

- service restoration;
- checkpoint recovery;
- backlog catch-up;
- retry completion;
- processing validation.

Processing RTO can therefore be significantly longer than component restart time.

### 22.10 Data Product RTO

Data-product RTO measures how long it takes to restore an acceptable governed analytical product.

Depending on the failure, the acceptable state may be:

- current Certified Gold;
- previous known-good Certified Gold through rollback;
- newly reconstructed certified state.

The endpoint must be defined according to the data-product requirement.

### 22.11 End-to-End RTO

End-to-end analytical RTO may include:

**Failure Detection**
→ **Intervention**
→ **Technical Restoration**
→ **Processing Recovery**
→ **Backlog Catch-Up**
→ **Validation**
→ **Certification**
→ **Publication**
→ **Consumer Availability**

This is the most complete recovery-time perspective.

Version 1 should measure representative stages separately so that one long recovery time can be decomposed into its actual causes.

### 22.12 Detection Time

Failure detection contributes to observed recovery.

A platform that can recover in two minutes after intervention but takes one hour to detect failure does not provide a two-minute operational recovery experience.

The recovery timeline should therefore distinguish:

**Failure Start**

from:

**Failure Detection**.

### 22.13 Intervention Delay

Intervention delay is the time between detection and the beginning of recovery action.

It may depend on:

- alerting;
- automation;
- diagnosis;
- operator response;
- decision authority.

Version 1 may use manual intervention.

Observed laboratory intervention time must not be represented as an inherent technology limitation when the delay is primarily operational.

### 22.14 Technical Restoration Time

Technical restoration time measures the interval required to restore the failed technical capability.

Examples include:

- restart service;
- restore connectivity;
- replace credential;
- restore storage;
- recover database.

This is one component of complete recovery time.

### 22.15 Catch-Up Time

Catch-up time measures how long accumulated work takes to return to the normal operating range after processing resumes.

Catch-up time depends on:

- backlog;
- incoming rate;
- processing throughput;
- partition distribution;
- retries;
- resource capacity.

A component may restore quickly while catch-up dominates total recovery time.

### 22.16 Rebuild Time

Rebuild time measures reconstruction of a derived state from a trustworthy upstream boundary.

Relevant stages may include:

- source preparation;
- reconstruction;
- quality validation;
- reconciliation;
- certification;
- catch-up;
- publication.

Rebuild RTO therefore depends strongly on data volume and processing capacity.

### 22.17 Validation Time

Recovery validation contributes to recovery time.

For governed analytical output, recovery cannot be considered complete before required validation demonstrates correctness.

Validation time may include:

- quality checks;
- reconciliation;
- lineage validation;
- comparison;
- certification.

Removing validation from RTO calculations solely to make recovery appear faster would misrepresent actual governed recovery.

### 22.18 Rollback Recovery Time

Rollback may restore consumer availability faster than rebuilding a corrected current state.

A rollback timeline may include:

- defect detection;
- invalidation decision;
- rollback execution;
- validation;
- consumer restoration.

The later corrected roll-forward has its own recovery timeline.

These two intervals should remain distinguishable.

### 22.19 Availability

Availability describes whether a required capability can be used when needed.

Availability must be defined according to the capability being measured.

Examples include:

- source availability;
- event-transport availability;
- processing availability;
- Certified Gold availability;
- analytical-consumer availability.

One component being available does not imply the complete data platform is available for every purpose.

### 22.20 Reliability Versus Availability

Reliability and availability are related but different.

**Availability**
→ can the capability be used now?

**Reliability**
→ does the platform behave correctly and recover predictably across failure conditions?

A system may temporarily be unavailable yet remain reliable if:

- state remains durable;
- recovery is predictable;
- correctness is preserved.

Conversely, a continuously available system that silently loses or corrupts data is not reliable.

### 22.21 High Availability

High Availability (HA) reduces service interruption through redundancy, failover, or equivalent mechanisms.

Representative enterprise mechanisms may include:

- multiple Kafka brokers;
- replicated storage;
- SQL Server availability technologies;
- redundant processing workers;
- redundant infrastructure;
- automated failover.

Version 1 does not automatically provide enterprise HA merely because a stopped service can be restarted.

**Restartability ≠ High Availability**

### 22.22 Laboratory Availability

The Version 1 laboratory may rely on single instances and shared physical infrastructure.

A single workstation or local storage failure may therefore affect several platform components simultaneously.

Laboratory testing can demonstrate:

- restart behavior;
- reconstruction;
- replay;
- rollback;
- logical recovery.

It does not demonstrate physical redundancy that is not implemented.

### 22.23 Analytical Availability

Analytical availability is the ability of consumers to access an acceptable governed analytical state.

Certified Gold enables analytical availability to remain distinct from upstream processing availability.

For example:

**Upstream Processing**
→ unavailable.

**Certified Gold**
→ previous trusted version still accessible.

The analytical product is therefore available but may become stale.

### 22.24 Freshness

Freshness describes how current the governed analytical state is relative to its defined source or business boundary.

Freshness may be measured using:

- source commit time;
- event time;
- transaction time;
- latest processed boundary;
- publication time.

The selected definition must remain consistent for the product.

### 22.25 Freshness Objective

A freshness objective defines the expected maximum age or delay of consumer-visible governed data.

It should reflect:

- business use;
- source behavior;
- pipeline architecture;
- processing cadence;
- certification;
- measured steady-state latency.

Version 1 should measure normal behavior before assigning a formal freshness objective.

### 22.26 Freshness During Failure

Freshness may degrade while availability and correctness remain preserved.

For example:

**Certified Gold**
→ trustworthy and queryable  
→ upstream pipeline interrupted  
→ freshness age increases.

This is a valid degraded state.

Observability should expose it explicitly.

### 22.27 Freshness Recovery

Freshness is restored only after:

- upstream processing resumes;
- backlog catches up;
- downstream processing completes;
- certification succeeds;
- current state is published.

A service restart does not restore freshness immediately.

### 22.28 Processing Latency

Processing latency measures elapsed time across a defined processing boundary.

Possible latency dimensions include:

- CDC latency;
- source-to-Kafka latency;
- Kafka-to-Bronze latency;
- Bronze-to-Silver latency;
- Silver-to-Gold latency;
- Gold-to-Certified-Gold latency;
- end-to-end source-to-consumer latency.

Each latency should have a clearly defined start and end boundary.

### 22.29 End-to-End Latency

End-to-end analytical latency measures the elapsed time between an authoritative business event and its governed analytical availability.

Conceptually:

**Source Commit**
→ CDC  
→ Kafka  
→ Bronze  
→ Silver  
→ Gold  
→ Certification  
→ Publication.

This metric is particularly relevant to freshness expectations.

### 22.30 Latency Percentiles

Average latency alone may hide degraded behavior.

Where sufficient workload exists, the platform may evaluate:

- P50;
- P95;
- P99.

Percentiles help identify whether a minority of events experience materially worse delay than typical processing.

Version 1 should only publish percentile claims when the test sample is large enough to make them meaningful.

### 22.31 Availability Objective

A formal availability objective should identify:

- capability;
- measurement window;
- expected availability;
- exclusions where governed;
- failure scenarios included.

Version 1 should not invent percentage objectives such as:

**99.9%**

without a business requirement, suitable topology, and evidence supporting the claim.

### 22.32 Error Budget

Enterprise SLO practice may use an error budget to represent the amount of allowed unreliability within an objective.

Version 1 does not require implementation of a formal error-budget process.

The architecture remains compatible with future use where enterprise operations require it.

The laboratory should first establish meaningful measured reliability behavior.

### 22.33 RPO and Retention

RPO depends on retention and durable recovery state.

For example:

**Kafka Retention**
→ bounds normal replay availability.

**Bronze Retention**
→ bounds longer analytical reconstruction.

**Backup Retention**
→ bounds protected historical restoration.

A required RPO cannot be supported by a recovery source that no longer retains the required state.

### 22.34 RTO and Capacity

RTO depends on available recovery capacity.

Relevant factors include:

- restart speed;
- processing throughput;
- catch-up headroom;
- rebuild speed;
- source extraction capacity;
- downstream capacity;
- validation time.

A recovery objective must be feasible under the capacity actually available during recovery.

### 22.35 RTO and Data Volume

Recovery time may increase as retained historical volume grows.

A Silver rebuild that takes ten minutes with one day's data does not prove that one year of retained history can be rebuilt in ten minutes.

Recovery tests must record the data volume associated with measured duration.

### 22.36 RTO and Workload

Catch-up and rebuild performance depend on concurrent workload.

Recovery measured while the platform is otherwise idle may differ from recovery while:

- live ingestion continues;
- source workload is high;
- multiple downstream jobs run;
- storage is busy.

Test context must therefore accompany observed recovery times.

### 22.37 RTO and Validation Depth

Different recovery scenarios require different validation depths.

For example:

**Simple Service Restart**
→ limited validation may be sufficient.

**Historical Gold Rebuild**
→ quality, reconciliation, certification, and publication validation may dominate recovery time.

The required validation cannot be removed solely to meet an arbitrary RTO target.

### 22.38 Recovery Objective Trade-Offs

Reliability objectives involve trade-offs.

For example:

**Lower RPO**
may require:
- longer retention;
- stronger durability;
- more frequent backups;
- replication.

**Lower RTO**
may require:
- additional capacity;
- redundancy;
- automation;
- faster restore mechanisms;
- precomputed recovery state.

These improvements may increase:

- cost;
- complexity;
- operational burden.

Objectives should therefore follow requirements rather than prestige.

### 22.39 Recovery Objective Hierarchy

Different products and layers may legitimately require different objectives.

For example:

**Certified Sales Product**
may require stronger freshness and recovery expectations than:

**Historical Experimental Dataset**.

The architecture should avoid applying one arbitrary RPO or RTO to every platform capability.

### 22.40 Data Criticality

Recovery objectives should consider the criticality of the affected data and capability.

Relevant factors may include:

- business importance;
- financial impact;
- consumer dependency;
- historical value;
- reconstruction cost;
- data classification;
- operational consequence.

Criticality must not be inferred solely from technical size or processing volume.

### 22.41 Recovery Objective Ownership

Formal recovery objectives require identifiable ownership.

Relevant responsibilities may include:

- Business Data Owner;
- Data Engineering;
- DBA;
- Platform / SRE;
- Governance;
- Security where applicable.

Technical teams can measure capability.

Business and governance responsibilities determine what level of loss, delay, or unavailability is acceptable.

### 22.42 Laboratory Measurement

Version 1 should establish observed recovery measurements for representative scenarios.

Measurements may include:

- component restart time;
- detection time;
- backlog accumulation;
- catch-up rate;
- catch-up time;
- replay duration;
- reprocessing duration;
- rebuild duration;
- rollback duration;
- end-to-end recovery time;
- freshness recovery.

These observations become the evidence base for later objectives.

### 22.43 Observed Versus Target

Atlas Engineering must distinguish:

**Observed Recovery**
→ what happened in the measured laboratory scenario.

from:

**Target Recovery**
→ the required objective defined for a future or governed environment.

For example:

**Observed**
→ Bronze catch-up completed in 4 minutes for 50,000 controlled events.

This does not automatically establish:

**RTO = 4 minutes**

for all workloads or enterprise deployment.

### 22.44 Measured Recovery Baseline

After representative tests, Version 1 should maintain a measured recovery baseline.

A baseline may identify:

| Scenario | Workload | Recovery Source | Observed RPO | Observed Recovery Time | Result |
|---|---:|---|---|---|---|
| Bronze Consumer Restart | To be measured | Kafka | To be measured | To be measured | Pending |
| Silver Rebuild | To be measured | Bronze | To be measured | To be measured | Pending |
| Gold Rebuild | To be measured | Silver | To be measured | To be measured | Pending |
| Certified Gold Rollback | To be measured | Previous Certified Version | To be measured | To be measured | Pending |

Actual results must replace placeholders only after the corresponding tests are executed and validated.

### 22.45 No Placeholder Publication

The architecture document may define measurement structures before implementation.

However, the published and committed project documentation must not retain unresolved editorial placeholders as though they were completed results.

Until measurements exist, the document should state that objectives remain **to be established from Version 1 evidence** rather than present fictional values.

### 22.46 Recovery Objective Evolution

Recovery objectives may evolve after:

- measured workload changes;
- data volume increases;
- architecture changes;
- new products are introduced;
- business criticality changes;
- enterprise topology is implemented;
- new evidence demonstrates current objectives are unrealistic or unnecessarily conservative.

Objectives are governed engineering decisions rather than permanent constants.

### 22.47 Objective Regression

A later platform version may fail to meet a previously demonstrated recovery baseline.

Examples include:

- slower catch-up;
- longer rebuild;
- increased detection time;
- longer publication recovery.

Regression should be investigated rather than hidden by changing the baseline without explanation.

If the objective legitimately changes, the decision should be explicit.

### 22.48 Objective Validation

A formal recovery objective should be validated under a scenario representative of the claim.

For example, an RTO for backlog recovery should not be validated only by measuring service restart.

Validation should cover the complete capability represented by the objective.

### 22.49 Objective Evidence

Evidence supporting recovery objectives should preserve:

- scenario;
- failure scope;
- workload;
- data volume;
- topology;
- recovery source;
- processing version;
- failure time;
- detection time;
- recovery start;
- restoration milestones;
- achieved recovery point;
- final recovery time;
- freshness result;
- conclusion.

This allows the objective to remain tied to the conditions under which it was demonstrated.

### 22.50 Enterprise RPO and RTO

Enterprise RPO and RTO must be derived from business requirements and validated against the enterprise implementation.

Enterprise targets may require architectural mechanisms not implemented in Version 1, such as:

- replicated Kafka;
- highly available SQL Server;
- redundant storage;
- automated failover;
- cross-host deployment;
- stronger backup architecture;
- additional processing capacity;
- disaster-recovery infrastructure.

Version 1 provides evidence for architecture design.

It does not pre-declare enterprise commitments.

### 22.51 Recovery Objective Test Scenarios

Version 1 should use controlled scenarios to establish measured recovery behavior.

Representative examples include:

**Objective Test 1 — Restart and Catch-Up**
→ stop Bronze processing  
→ accumulate known backlog  
→ restore processing  
→ measure restart, catch-up, and freshness-recovery time.

**Objective Test 2 — Silver Rebuild**
→ reconstruct controlled Silver history from Bronze  
→ measure data volume, processing rate, validation time, and total rebuild duration.

**Objective Test 3 — Gold Rollback**
→ invalidate a controlled published version  
→ rollback to the previous certified version  
→ measure consumer-availability recovery time and resulting freshness impact.

**Objective Test 4 — End-to-End Recovery**
→ inject a controlled failure  
→ measure detection through restoration of current Certified Gold  
→ preserve the complete recovery timeline.

These measurements should later inform the Version 1 reliability baseline.

### 22.52 Recovery Objectives and Service-Level Guarantees

The Atlas Engineering recovery-objective model must preserve the following guarantees:

1. recovery objectives are defined according to the capability being protected;
2. RPO represents a data recovery boundary rather than merely a backup schedule;
3. RPO may differ across source, event, processing, and consumer-visible layers;
4. zero-data-loss claims remain scoped to failure scenarios actually demonstrated;
5. derived-state loss may be recoverable from upstream state without preserving the original physical copy;
6. consumer-visible recovery point remains distinguishable from upstream recoverable state;
7. RTO identifies the capability and endpoint considered recovered;
8. component, processing, data-product, and end-to-end RTO remain distinguishable;
9. detection and intervention contribute to operational recovery time;
10. technical restoration remains distinct from backlog, validation, and consumer recovery;
11. rollback recovery time remains distinguishable from later roll-forward recovery;
12. availability is measured according to a defined capability;
13. reliability remains broader than availability;
14. restartability is not represented as High Availability;
15. Version 1 physical constraints remain explicit in availability claims;
16. Certified Gold allows analytical availability to remain distinct from upstream availability;
17. freshness remains distinguishable from availability and correctness;
18. freshness objectives are established from business need and measured behavior;
19. processing and end-to-end latency use explicit boundaries;
20. percentile latency claims require sufficient measured workload;
21. availability percentages are not invented without requirements and evidence;
22. formal error-budget practice remains an enterprise evolution rather than an unsupported Version 1 claim;
23. retention constrains achievable RPO;
24. processing capacity and data volume constrain achievable RTO;
25. validation time remains part of governed recovery where required;
26. RPO and RTO trade-offs are evaluated against cost, complexity, and operational requirements;
27. different layers and products may use different recovery objectives;
28. formal objectives have identifiable business and technical ownership;
29. Version 1 first establishes observed recovery behavior;
30. observed laboratory recovery remains distinguishable from target service commitments;
31. measured baselines record workload and topology context;
32. published project documentation does not present fictional recovery measurements;
33. recovery objectives evolve through governed evidence and changing requirements;
34. regressions against prior demonstrated behavior are investigated;
35. formal objectives are validated against scenarios that actually represent the claimed capability;
36. enterprise RPO and RTO require enterprise requirements and enterprise-specific validation;
37. recovery-objective claims remain proportional to the evidence available.

---

## 23. Availability, High Availability, and Disaster Recovery

Atlas Engineering distinguishes availability, reliability, High Availability, recoverability, and Disaster Recovery as related but separate architectural concerns.

The governing model is:

**Availability**
→ Can the required capability be used now?

**Reliability**
→ Does the platform behave correctly and recover predictably when failure occurs?

**High Availability**
→ Can redundancy and failover reduce interruption of the required capability?

**Recoverability**
→ Can required state and processing be restored after failure?

**Disaster Recovery**
→ Can the platform be restored after a broad failure affecting infrastructure, data, or an entire operating environment?

These concepts must not be collapsed into one generic claim such as:

**Highly Available and Disaster-Recovery Ready**

unless the corresponding mechanisms have actually been implemented and validated.

### 23.1 Availability

Availability describes whether a defined capability is usable during a particular period.

Relevant capabilities may include:

- AtlasCommerce;
- CDC;
- Kafka;
- Bronze ingestion;
- Silver processing;
- Gold processing;
- Certified Gold;
- Power BI consumption;
- observability;
- recovery dependencies.

Availability must always identify the capability being evaluated.

A platform may be partially available.

### 23.2 Component Availability

Component availability describes whether one technical component is usable.

For example:

**Kafka**
→ available.

This does not automatically imply:

- events are flowing;
- consumers are current;
- Bronze is advancing;
- Silver is advancing;
- Certified Gold is current.

Component availability is therefore only one layer of platform availability.

### 23.3 Processing Availability

Processing availability describes whether a processing responsibility can continue performing its intended work.

A process may be running while processing availability is degraded because:

- required dependency is unavailable;
- checkpoint is stalled;
- retry is exhausted;
- input cannot be interpreted;
- output cannot be persisted.

Processing availability must therefore be evaluated through progress, not only process status.

### 23.4 Analytical Availability

Analytical availability describes whether consumers can access an acceptable governed analytical state.

Certified Gold may remain analytically available even while upstream processing is degraded.

For example:

**Silver**
→ unavailable.

**Certified Gold V12**
→ trustworthy and queryable.

Result:

**Analytical Availability = Available**
while:
**Freshness = Degrading**

This distinction is intentional.

### 23.5 Availability and Freshness

Availability and freshness must remain separate.

A product may be:

**Available and Current**

**Available but Stale**

**Unavailable**

A stale but trustworthy product may be acceptable for some business uses.

A newer but incorrect product is not preferable merely because it improves apparent freshness.

### 23.6 Availability and Correctness

Availability must never be increased by knowingly exposing incorrect or uncertified data.

The governing rule is:

**Correctness Before Artificial Availability**

If no trustworthy consumer-visible state exists, the affected product may need to become unavailable.

Serving known-invalid data to preserve uptime is not considered reliable availability.

### 23.7 Availability and Partial Failure

Different capabilities may have different availability states simultaneously.

For example:

**Kafka**
→ available.

**Bronze**
→ recovering.

**Silver**
→ stale.

**Certified Gold**
→ available.

**Power BI**
→ available.

The platform must therefore avoid one global binary interpretation of health.

### 23.8 High Availability

High Availability (HA) is the use of redundancy, failover, or equivalent mechanisms to reduce service interruption when a component or infrastructure element fails.

HA commonly relies on:

- redundant nodes;
- replicated state;
- multiple failure domains;
- automated or controlled failover;
- load balancing;
- health detection;
- quorum or consensus mechanisms;
- redundant networking or storage.

Restarting a failed single instance is recovery.

It is not High Availability.

### 23.9 High Availability Objective

HA is intended to reduce interruption.

It does not automatically guarantee:

- zero data loss;
- correct processing;
- valid checkpoints;
- consumer freshness;
- disaster recovery;
- protection from logical corruption.

A highly available incorrect system remains incorrect.

HA must therefore complement rather than replace data reliability controls.

### 23.10 HA and State Replication

Stateful HA requires sufficient replication of the state needed after failover.

For example:

**Service Replicated**
but:
**Required Data Stored on One Failed Disk**

does not provide meaningful stateful High Availability.

The architecture must distinguish:

**Compute Redundancy**

from:

**State Redundancy**.

### 23.11 HA and Failure Domains

Redundant instances provide stronger availability only when they do not share the same relevant failure domain.

Examples of failure domains include:

- process;
- container;
- host;
- disk;
- rack;
- availability zone;
- region;
- identity dependency;
- network path.

Two services on the same physical workstation do not provide host-level High Availability.

### 23.12 HA and Automatic Failover

Enterprise HA may use automated failover.

Automatic failover must still preserve:

- state consistency;
- correct ownership;
- authorization;
- processing progress;
- idempotency;
- auditability.

Fast failover is not desirable if it creates split-brain, duplicate business effects, or ambiguous processing ownership.

### 23.13 HA and Kafka

Enterprise Kafka HA normally relies on:

- multiple brokers;
- replicated partitions;
- appropriate replication factor;
- leader election;
- failure-domain distribution.

Version 1 may use a single Kafka broker.

Therefore:

**Kafka Restartability**
may be demonstrated.

**Kafka Multi-Broker HA**
is not demonstrated unless that topology is actually implemented and tested.

### 23.14 HA and SQL Server

Enterprise SQL Server availability may use technologies such as:

- Always On Availability Groups;
- Failover Cluster Instances;
- other approved replication or failover architectures.

Version 1 does not require enterprise SQL Server HA to validate the logical Data Engineering architecture.

Where SQL Server runs as a single instance, recovery testing demonstrates recoverability rather than High Availability.

### 23.15 HA and MinIO

Enterprise object-storage availability may require:

- distributed storage;
- replication;
- erasure coding;
- multiple nodes;
- independent physical storage.

A local single-node MinIO instance provides durable storage only within the limitations of that physical topology.

It must not be described as highly available storage merely because objects survive a process restart.

### 23.16 HA and Processing Workers

Processing workloads may gain availability through multiple workers where the processing model allows safe ownership and retry behavior.

However, adding workers requires correct handling of:

- partition assignment;
- duplicate execution;
- shared state;
- concurrency;
- checkpointing;
- downstream capacity.

Worker redundancy must preserve processing semantics.

### 23.17 HA and Airflow

Enterprise Airflow availability may require redundant:

- schedulers;
- workers;
- metadata database;
- execution infrastructure.

Version 1 may operate with a simpler topology.

A restartable local Airflow deployment must not be described as enterprise HA unless those mechanisms are actually implemented.

### 23.18 HA and Observability

Observability components may themselves require HA in enterprise environments.

Loss of monitoring should not automatically stop data processing, but prolonged observability unavailability may reduce:

- incident detection;
- recovery confidence;
- security monitoring;
- SLO measurement.

Enterprise reliability may therefore require resilient observability infrastructure.

### 23.19 HA and Security Dependencies

Security dependencies may also become availability dependencies.

Examples include:

- identity provider;
- secrets manager;
- certificate authority;
- key-management service;
- authorization service.

A highly available pipeline may remain unusable if workloads cannot authenticate or decrypt required data.

Enterprise HA design must therefore include critical security dependencies.

### 23.20 Recoverability

Recoverability is the ability to restore required state and processing after failure.

Recoverability may exist without High Availability.

For example:

**Single-Node Silver Storage Lost**
→ platform unavailable temporarily  
→ Bronze remains valid  
→ Silver rebuilt successfully.

Result:

**High Availability = Not Provided**

but:

**Recoverability = Demonstrated**

This distinction is important for Version 1.

### 23.21 Recoverability Without Redundancy

A component may be recoverable through:

- restart;
- replay;
- reprocessing;
- backfill;
- rebuild;
- backup restore;
- rollback.

These mechanisms may require downtime.

They therefore demonstrate recoverability rather than necessarily HA.

### 23.22 Disaster

A disaster is a failure whose scope exceeds ordinary component recovery and materially affects the platform's operating environment or durable state.

Representative examples may include:

- complete host loss;
- catastrophic storage loss;
- loss of multiple platform services;
- severe database loss;
- site failure;
- regional failure in enterprise deployment;
- destructive incident requiring broad restoration.

The exact organizational definition of disaster may vary.

The architectural distinction is that ordinary restart or localized replay is insufficient.

### 23.23 Disaster Recovery

Disaster Recovery (DR) is the coordinated restoration of platform capabilities after a broad failure.

DR may require restoration of:

- infrastructure;
- storage;
- databases;
- Kafka;
- object storage;
- processing services;
- metadata;
- contracts;
- identities;
- credentials;
- certificates;
- encryption keys;
- observability;
- backups;
- derived analytical state;
- Certified Gold;
- consumer access.

DR therefore extends beyond data restore alone.

### 23.24 DR Recovery Sequence

A DR procedure must respect dependency order.

A representative logical sequence is:

1. restore infrastructure;
2. restore required networking and storage;
3. restore identity, credentials, certificates, and keys;
4. restore SQL Server and required databases;
5. restore Kafka and registry;
6. restore MinIO or equivalent historical storage;
7. restore orchestration and processing runtime;
8. restore observability;
9. validate recovery sources;
10. resume or reconstruct Bronze;
11. rebuild Silver where required;
12. rebuild Gold;
13. validate quality and reconciliation;
14. certify;
15. publish Certified Gold;
16. restore analytical consumption;
17. validate final governed state.

The exact sequence depends on the implemented topology.

### 23.25 DR and Backup

Backup is one mechanism within Disaster Recovery.

A backup alone does not constitute a DR plan.

A complete DR capability also requires:

- backup accessibility;
- documented restoration;
- required credentials and keys;
- infrastructure;
- application configuration;
- processing definitions;
- dependency order;
- validation;
- catch-up.

The platform must be able to use the backup meaningfully.

### 23.26 Backup Restore Validation

Backup recoverability must be tested.

A backup that has never been successfully restored provides weaker evidence than one that has been exercised under controlled conditions.

Validation should confirm, where applicable:

- backup readable;
- expected state restored;
- required version known;
- security state reviewed;
- downstream processing can continue;
- current governance reapplied.

### 23.27 DR and Historical Catch-Up

A restored environment may represent an earlier point than current source state.

Recovery may therefore require:

**Backup Restore**
→ identify restored point  
→ recover later source changes  
→ replay or backfill  
→ rebuild downstream state  
→ catch up  
→ validate.

The total DR recovery time includes both restoration and subsequent data recovery.

### 23.28 DR and RPO

DR RPO depends on the protected recovery sources available after the disaster.

Possible sources include:

- SQL Server backups;
- replicated Kafka state;
- replicated object storage;
- off-host backups;
- archives;
- cross-region copies.

Version 1 local copies may share the same physical failure domain.

They must not be represented as disaster-independent recovery unless they truly survive the tested failure scope.

### 23.29 DR and RTO

DR RTO is broader than component restart or ordinary pipeline recovery.

It may include:

- infrastructure provisioning;
- data restore;
- service configuration;
- credential restoration;
- security validation;
- processing reconstruction;
- catch-up;
- quality and reconciliation;
- certification;
- consumer restoration.

Enterprise DR objectives must be validated against the actual enterprise topology.

### 23.30 DR and Recovery Location

Enterprise DR may restore service:

- on the same infrastructure;
- on another host;
- in another availability zone;
- in another region;
- in another environment.

The recovery location must provide sufficient independence from the disaster being protected against.

A copy on the same failed device does not provide meaningful disaster independence.

### 23.31 Off-Host Backup

Off-host backup improves protection against host-level failure.

Version 1 may eventually validate a recovery scenario where a backup or exported governed recovery artifact exists outside the primary workstation failure domain.

Until such a mechanism is implemented and tested, host-loss DR remains an enterprise evolution rather than a demonstrated Version 1 capability.

### 23.32 Cross-Region Disaster Recovery

Cross-region DR is an enterprise architecture concern involving mechanisms such as:

- replicated data;
- remote backups;
- regional infrastructure;
- network failover;
- identity and key availability;
- region-specific recovery procedures.

Version 1 does not need to implement cross-region DR.

The logical architecture should remain compatible with such evolution.

### 23.33 DR and Certified Gold

Certified Gold may help restore analytical consumption while broader upstream reconstruction continues.

If a trusted certified copy survives the failure in an independent recovery location:

→ consumer availability may recover before full pipeline reconstruction.

If no trusted Certified Gold survives:

→ the product must be reconstructed and certified before normal consumption resumes.

### 23.34 DR and Security

Disaster recovery must preserve security boundaries.

Recovery must not:

- reuse compromised credentials;
- restore revoked identities;
- disable authentication permanently;
- bypass authorization;
- restore invalid certificates;
- expose sensitive backups without protection;
- restore obsolete privacy state.

Security recovery requirements remain authoritative during DR.

### 23.35 DR and Encryption Keys

Encrypted data may be unrecoverable if the required encryption keys are unavailable after disaster.

Key backup, escrow, replication, or equivalent enterprise controls may therefore be part of DR design.

The governing requirement is:

**Protected Data + Unrecoverable Key = Unrecoverable Data**

Key recovery must preserve security while maintaining required data recoverability.

### 23.36 DR and Configuration

Recovery requires more than application data.

Material configuration may include:

- Kafka topic configuration;
- retention;
- consumer configuration;
- MinIO configuration;
- Airflow DAGs;
- processing parameters;
- database objects;
- access policy;
- certification metadata.

Infrastructure-as-code and source-controlled configuration can strengthen DR reproducibility where appropriate.

### 23.37 DR and Metadata

Recovery metadata may be required to understand restored state.

Relevant metadata may include:

- processing versions;
- checkpoints;
- lineage;
- contract versions;
- certification history;
- active Certified Gold version;
- retention context.

Restoring data without the metadata required to interpret it may produce incomplete recovery.

### 23.38 DR and Observability

Observability should be restored early enough to support recovery diagnosis and validation.

The recovery process needs visibility into:

- service health;
- restore progress;
- processing progress;
- backlog;
- errors;
- freshness;
- certification.

However, observability dependencies must not prevent restoration of foundational infrastructure when those monitoring systems are themselves unavailable.

### 23.39 DR and Documentation

A usable DR capability requires current documentation.

Relevant information may include:

- dependencies;
- recovery order;
- recovery sources;
- credentials and key procedures;
- restore instructions;
- validation;
- escalation;
- expected limitations.

Documentation must evolve when architecture changes.

### 23.40 DR Runbook

The final implementation may maintain operational runbooks for specific DR procedures.

The architecture document defines:

- recovery principles;
- required dependencies;
- recovery boundaries;
- validation expectations.

A runbook defines:

- commands;
- exact sequence;
- implementation-specific steps.

This document must not become an implementation runbook.

### 23.41 DR Testing

Disaster Recovery capability must be tested at a scope appropriate to the claim.

Version 1 may validate representative scenarios such as:

- full local service reconstruction;
- SQL Server restore;
- rebuilding Silver from Bronze;
- rebuilding Gold from Silver;
- restoring Certified Gold publication;
- recovering from a complete controlled laboratory shutdown.

These tests demonstrate logical recovery.

They do not prove cross-host or cross-region DR unless those failure domains are actually involved.

### 23.42 Full Laboratory Recovery Test

A representative Version 1 full-laboratory recovery test may:

1. record baseline state;
2. stop the laboratory platform;
3. preserve or restore required durable state;
4. start services in dependency order;
5. validate SQL Server;
6. validate Kafka;
7. validate MinIO;
8. validate contracts;
9. restore processing;
10. recover backlog;
11. validate Silver;
12. validate Gold;
13. validate certification;
14. validate Certified Gold;
15. validate Power BI access;
16. preserve the complete timeline.

This demonstrates coordinated platform recovery within the laboratory failure domain.

### 23.43 Host-Loss Limitation

If all Version 1 services and durable recovery state remain on one workstation, complete workstation loss may exceed the recoverability demonstrated by the laboratory.

This limitation must remain explicit.

The architecture may be designed for broader recovery while the physical Version 1 implementation remains constrained.

### 23.44 Enterprise HA Evolution

Enterprise implementation may strengthen availability through:

- multi-node Kafka;
- replicated object storage;
- SQL Server HA;
- redundant Airflow;
- distributed compute;
- load balancing;
- multiple hosts;
- redundant networking;
- automated failover;
- resilient identity and secret services.

These mechanisms strengthen availability without changing the logical processing and recovery principles.

### 23.45 Enterprise DR Evolution

Enterprise DR may strengthen recovery through:

- off-site backups;
- cross-region replication;
- infrastructure-as-code;
- automated environment provisioning;
- managed key recovery;
- centralized configuration;
- replicated metadata;
- tested recovery environments;
- formal DR exercises.

The exact design depends on enterprise requirements and RPO/RTO objectives.

### 23.46 HA/DR Cost and Complexity

Stronger HA and DR generally increase:

- infrastructure cost;
- operational complexity;
- testing requirements;
- monitoring complexity;
- failover-state management;
- security dependencies.

The architecture should introduce stronger mechanisms because requirements justify them, not because enterprise terminology appears desirable.

### 23.47 Availability Claims

Availability claims must describe what has actually been implemented.

Appropriate Version 1 claims may include:

**Demonstrated**
→ Bronze consumer restarts and catches up after controlled interruption.

**Demonstrated**
→ previous Certified Gold remains available during controlled upstream failure.

Unsupported claims may include:

**Atlas Engineering provides enterprise High Availability**

when the topology contains single-node dependencies without failover.

### 23.48 DR Claims

DR claims must identify the failure domain actually tested.

For example:

**Validated**
→ complete logical platform restart from preserved local state.

This is different from:

**Validated**
→ recovery after total workstation loss.

And very different from:

**Validated**
→ cross-region Disaster Recovery.

The claim must remain bounded by the scenario.

### 23.49 Availability and DR Validation

Validation should confirm, according to the tested capability:

- failure detected;
- service impact understood;
- expected redundancy or lack of redundancy observed;
- required state remains recoverable;
- failover or restoration behaves as designed;
- downstream processing resumes;
- backlog catches up;
- Certified Gold behavior remains correct;
- final consumer state is validated.

### 23.50 Availability, HA, and DR Evidence

Representative evidence may preserve:

- failure domain;
- topology;
- component redundancy;
- storage redundancy;
- failure time;
- detection;
- failover or restore action;
- recovery source;
- achieved recovery point;
- technical restoration time;
- processing recovery time;
- consumer recovery time;
- final state;
- limitations.

Evidence should make clear which capability was actually demonstrated.

### 23.51 Availability, High Availability, and Disaster Recovery Guarantees

The Atlas Engineering availability and disaster-recovery model must preserve the following guarantees:

1. availability, reliability, High Availability, recoverability, and Disaster Recovery remain distinct concepts;
2. availability claims identify the capability being evaluated;
3. component availability does not imply processing or analytical freshness;
4. analytical availability can remain preserved through Certified Gold during upstream failure;
5. freshness remains distinct from availability;
6. known-invalid data is not served merely to preserve apparent availability;
7. platform health may remain partially available rather than globally binary;
8. High Availability requires redundancy or failover rather than simple restartability;
9. HA does not independently guarantee data correctness or zero data loss;
10. stateful HA considers state replication as well as compute redundancy;
11. redundant instances are evaluated against independent failure domains;
12. automated failover must preserve processing correctness and ownership;
13. single-node Version 1 Kafka is not represented as multi-broker HA;
14. single-instance SQL Server recovery is not represented as SQL Server HA;
15. local single-node object storage is not represented as enterprise HA;
16. worker redundancy preserves ordering, checkpoint, and idempotency semantics;
17. critical observability and security dependencies may participate in enterprise HA design;
18. recoverability can be demonstrated without High Availability;
19. restart, replay, rebuild, backup restore, and rollback may provide recovery while still requiring downtime;
20. Disaster Recovery addresses failures broader than ordinary component recovery;
21. DR restores infrastructure, security dependencies, processing, governed data, and analytical consumption where affected;
22. DR recovery follows dependency-aware restoration;
23. backup remains one mechanism within DR rather than the complete DR capability;
24. backup recoverability is validated through restore testing;
25. restored historical state may require replay, backfill, rebuild, and catch-up;
26. DR RPO depends on recovery sources that survive the protected failure domain;
27. DR RTO includes restoration, reconstruction, validation, and consumer recovery;
28. recovery copies must be independent from the disaster being protected against;
29. Version 1 does not claim off-host or cross-region DR unless such mechanisms are actually implemented and tested;
30. Certified Gold may shorten analytical recovery when a trustworthy independent copy survives;
31. DR preserves current security and privacy requirements;
32. encryption-key availability is part of encrypted-data recoverability;
33. material configuration and metadata participate in DR;
34. operational runbooks remain distinct from architecture documentation;
35. Version 1 may validate coordinated logical laboratory recovery without implying enterprise DR;
36. shared workstation failure domains remain explicit;
37. enterprise HA and DR mechanisms are introduced according to requirements and evidence;
38. stronger HA and DR are evaluated against cost and operational complexity;
39. availability and DR claims remain bounded by the topology and failure scenarios actually demonstrated;
40. availability, HA, and DR behavior is considered demonstrated only after controlled validation and evidence.

---

## 24. Laboratory and Enterprise Reliability Boundaries

Atlas Engineering Version 1 is implemented as a controlled reliability and recovery laboratory.

Its purpose is to demonstrate architectural behavior such as:

- durable-state preservation;
- restartability;
- retry;
- redelivery tolerance;
- idempotency;
- replay;
- reprocessing;
- backfill;
- rebuild;
- backlog recovery;
- failure isolation;
- poison-record handling;
- Certified Gold protection;
- rollback;
- recovery validation;
- evidence-based reliability analysis.

The physical implementation of Version 1 must not be represented as equivalent to an enterprise High Availability or Disaster Recovery environment.

The governing principle is:

**Preserve the Reliability Property → Allow the Physical Mechanism to Evolve**

### 24.1 Laboratory Reliability Purpose

The Version 1 laboratory exists to validate whether the architecture behaves predictably under controlled failure conditions.

It should demonstrate questions such as:

- What state survives failure?
- Where does processing resume?
- What gets redelivered?
- Does idempotency preserve correctness?
- Can retained history be replayed?
- Can derived state be rebuilt?
- Does backlog converge?
- Does Certified Gold remain protected?
- Can rollback restore analytical availability?
- What recovery times are actually observed?

The laboratory is therefore an implementation and evidence environment, not merely a diagram of intended behavior.

### 24.2 Laboratory Physical Topology

Version 1 may operate with characteristics such as:

- one physical workstation;
- local SQL Server instances;
- single-node or limited-node containerized services;
- local storage;
- shared host resources;
- limited physical network separation;
- no secondary datacenter;
- no cross-region infrastructure.

These characteristics create shared physical failure domains.

Logical reliability boundaries must remain distinguishable from physical redundancy.

### 24.3 Single-Host Failure Domain

When several platform services run on one workstation, that workstation becomes a shared physical failure domain.

A single host failure may simultaneously affect:

- Kafka;
- MinIO;
- Airflow;
- processing services;
- Prometheus;
- Grafana;
- local configuration;
- locally stored recovery artifacts.

This limits the physical availability and DR claims that Version 1 can make.

It does not prevent testing of logical recovery behavior.

### 24.4 Logical Independence

Components may remain logically independent even when physically co-located.

For example:

- Kafka retains transport history;
- Bronze preserves analytical history;
- Silver remains reconstructible;
- Gold remains derived;
- Certified Gold remains a separate publication state.

This logical independence is important because it preserves the architecture required for future physical distribution.

Physical co-location must not cause the implementation to collapse distinct recovery responsibilities into one undifferentiated state.

### 24.5 Laboratory Durability

Version 1 can demonstrate durability according to the storage mechanisms actually implemented.

Examples may include:

- SQL Server persistence;
- Kafka retained events;
- MinIO objects;
- AtlasWarehouse persisted state;
- processing metadata.

Durability claims must remain bounded by the failure domain tested.

For example:

**Survives Container Restart**
does not imply:
**Survives Complete Host Loss**.

### 24.6 Laboratory Restartability

Version 1 should demonstrate restartability for representative components.

Examples include:

- Debezium;
- Kafka consumers;
- Bronze processing;
- Silver processing;
- Airflow-coordinated workloads;
- observability components.

Restartability should demonstrate:

- recovery of durable progress;
- correct redelivery behavior;
- backlog handling;
- downstream recovery.

Restarting a process successfully is a meaningful laboratory capability, but it is not enterprise HA.

### 24.7 Laboratory Retry and Redelivery

Version 1 can demonstrate:

- bounded retry;
- retry exhaustion;
- backoff where implemented;
- duplicate delivery;
- idempotent processing;
- explicit persistent-failure transitions.

These properties are logically portable to enterprise deployment.

Enterprise scale may require different retry limits, concurrency controls, and operational tooling.

### 24.8 Laboratory Replay

Version 1 should demonstrate controlled Kafka replay while required history remains retained.

The laboratory can validate:

- offset selection;
- replay boundaries;
- partition ordering;
- duplicate handling;
- downstream recovery;
- evidence.

This demonstrates replay semantics.

It does not independently demonstrate multi-broker Kafka resilience.

### 24.9 Laboratory Reprocessing

Version 1 can demonstrate historical reprocessing from governed retained state.

Representative scenarios may include:

- same-logic reproduction;
- corrected-logic reprocessing;
- version-aware processing;
- bounded historical scope.

This demonstrates reproducibility and controlled historical correction.

Enterprise evolution may add larger-scale execution, distributed compute, or automated historical pipelines.

### 24.10 Laboratory Backfill

Version 1 can demonstrate controlled backfill from AtlasCommerce or another governed source.

The laboratory should validate:

- bounded extraction;
- source impact;
- provenance;
- overlap with live processing;
- reconciliation;
- downstream recovery.

Enterprise environments may require stronger source throttling, extraction services, or dedicated recovery infrastructure.

### 24.11 Laboratory Rebuild

Version 1 should demonstrate reconstruction of derived state.

Representative examples include:

**Bronze → Silver**

and:

**Silver → Gold**

The laboratory can measure:

- processing volume;
- throughput;
- interruption behavior;
- restartability;
- validation;
- total rebuild time.

The measured result remains specific to the Version 1 workload and hardware.

### 24.12 Laboratory Backlog Recovery

Backlog recovery is one of the most valuable Version 1 reliability demonstrations.

The laboratory should measure:

- backlog accumulation;
- oldest pending age;
- processing rate;
- incoming rate;
- catch-up ratio;
- catch-up time;
- bottleneck migration.

These results provide real evidence for later capacity and scaling decisions.

### 24.13 Laboratory Failure Isolation

Version 1 can validate logical failure isolation through scenarios such as:

- one Kafka partition;
- one entity;
- one processing stage;
- one Gold candidate;
- one data product.

Physical co-location may still cause broader failure in host-level scenarios.

The architecture must distinguish logical isolation from physical isolation.

### 24.14 Laboratory Poison-Record Handling

Version 1 can demonstrate:

- bounded retry;
- persistent-failure classification;
- quarantine or safe blocking;
- remediation;
- reprocessing;
- reintegration.

This capability does not require enterprise-scale infrastructure.

It depends primarily on correct processing semantics and governed failure handling.

### 24.15 Laboratory Certified Gold Protection

Version 1 should demonstrate that:

- incomplete candidates remain isolated;
- failed certification blocks publication;
- previous Certified Gold remains available where trustworthy;
- rollback can restore a previous version;
- corrected roll-forward can replace the rollback version.

This is a strong logical reliability property that remains valid across deployment scales.

### 24.16 Laboratory Publication Atomicity

Version 1 should implement and validate a publication mechanism that prevents consumers from observing uncontrolled mixed certified state.

The exact SQL Server mechanism may remain local.

The architectural property is:

**Consumer Sees One Complete Governed Version**

Enterprise evolution may use different publication technologies while preserving the same property.

### 24.17 Laboratory RPO Evidence

Version 1 may demonstrate achieved recovery points for controlled failure scenarios.

For example:

- consumer interruption;
- Bronze reconstruction;
- Silver rebuild;
- Certified Gold rollback.

These observations should be described as:

**Observed Recovery Point Under Test Conditions**

rather than universal platform RPO commitments.

### 24.18 Laboratory RTO Evidence

Version 1 should measure representative recovery durations.

Measurements may include:

- restart time;
- catch-up time;
- replay time;
- reprocessing time;
- rebuild time;
- rollback time;
- validation time;
- end-to-end recovery time.

Observed laboratory timing must include workload and topology context.

### 24.19 Laboratory Availability

Version 1 can demonstrate availability behavior at logical boundaries.

For example:

**Upstream Failure**
→ previous Certified Gold remains available.

It cannot demonstrate physical availability mechanisms that do not exist, such as:

- host failover;
- multi-node Kafka failover;
- redundant MinIO storage;
- regional failover.

### 24.20 Laboratory High Availability Boundary

Version 1 should not claim enterprise High Availability unless actual redundant topology and failover are implemented.

Capabilities such as:

- restarting a container;
- automatically restarting a process;
- replaying retained events;
- rebuilding state;

demonstrate recoverability and automation.

They do not by themselves constitute HA.

### 24.21 Laboratory Disaster Recovery Boundary

Version 1 may demonstrate coordinated recovery of the local platform from preserved state.

It may not demonstrate recovery from complete workstation loss if all required state and backups remain on that workstation.

DR claims must therefore identify the actual failure domain tested.

### 24.22 Off-Host Recovery Evolution

A future laboratory enhancement could strengthen host-loss recovery by preserving selected recovery artifacts outside the primary workstation.

Examples may include:

- off-host SQL Server backup;
- external object-storage backup;
- protected archive;
- secondary recovery workstation.

Such enhancement should be treated as additional implemented capability only after validation.

### 24.23 Enterprise Physical Distribution

Enterprise evolution may distribute components across:

- multiple hosts;
- availability zones;
- datacenters;
- cloud regions;
- independent storage systems.

Physical distribution strengthens failure-domain independence.

It should preserve the same logical recovery boundaries validated in Version 1.

### 24.24 Enterprise Kafka Reliability

Enterprise Kafka may strengthen reliability through:

- multiple brokers;
- replicated partitions;
- quorum-based metadata;
- distributed failure domains;
- automated leader election;
- production-scale retention;
- tiered storage where applicable.

These mechanisms strengthen transport availability.

They do not remove the need for:

- replay semantics;
- idempotent consumers;
- checkpoint correctness;
- backlog recovery.

### 24.25 Enterprise SQL Server Reliability

Enterprise SQL Server may strengthen availability and recovery through:

- Always On Availability Groups;
- Failover Cluster Instances;
- backup architecture;
- log backups;
- tested restore procedures;
- geographically separated recovery where required.

These mechanisms strengthen the source and analytical-database reliability boundary.

They do not remove downstream processing recovery requirements.

### 24.26 Enterprise Object-Storage Reliability

Enterprise object storage may strengthen Bronze and Silver durability through:

- distributed nodes;
- replication;
- erasure coding;
- immutable protection where appropriate;
- cross-site copies;
- managed backup.

The architectural requirement remains:

**Durable Historical State Must Survive the Failure Domain It Is Intended to Protect Against**

### 24.27 Enterprise Processing Reliability

Enterprise processing may strengthen reliability through:

- distributed compute;
- multiple workers;
- autoscaling;
- workload isolation;
- resource quotas;
- automated restart;
- resilient execution frameworks.

Additional compute must preserve:

- ordering;
- idempotency;
- checkpoint correctness;
- lineage;
- processing version.

Scaling must not weaken correctness.

### 24.28 Enterprise Orchestration Reliability

Enterprise Airflow or equivalent orchestration may use:

- redundant schedulers;
- distributed workers;
- highly available metadata database;
- managed execution environments.

The logical rule remains:

**Orchestration State Does Not Replace Durable Data-Processing State**.

### 24.29 Enterprise Observability Reliability

Enterprise observability may use:

- replicated metric storage;
- centralized log aggregation;
- redundant dashboards;
- external alerting;
- long-term metric retention.

These capabilities improve the ability to detect and operate recovery.

They do not replace the data platform's own durable recovery state.

### 24.30 Enterprise Backup Strategy

Enterprise backup strategy may include:

- scheduled full backup;
- differential backup;
- transaction-log backup;
- object-storage backup;
- configuration backup;
- metadata backup;
- off-site copies;
- immutable copies;
- retention policies.

Backup design must align with actual RPO and DR requirements.

### 24.31 Enterprise Recovery Automation

Enterprise environments may automate parts of recovery such as:

- failover;
- service restart;
- credential replacement;
- environment provisioning;
- backup restore;
- pipeline resumption;
- validation.

Automation should follow a validated recovery model.

Automating an incorrect recovery process increases failure speed rather than reliability.

### 24.32 Enterprise Capacity Headroom

Enterprise reliability requires sufficient recovery capacity.

Capacity planning should consider:

- steady-state workload;
- peak workload;
- backlog catch-up;
- historical reprocessing;
- rebuild;
- concurrent recovery activity.

A platform that operates safely only at normal steady-state capacity may have weak recovery behavior after interruption.

### 24.33 Enterprise Recovery Objectives

Enterprise RPO, RTO, availability, and freshness objectives must be derived from actual business requirements.

Version 1 evidence may help estimate:

- bottlenecks;
- recovery rates;
- architectural risks;
- scaling relationships.

Enterprise objectives still require validation against the enterprise topology and workload.

### 24.34 Mechanism Substitution

Enterprise evolution may replace a laboratory recovery mechanism while preserving the same logical reliability property.

For example:

**Version 1**
→ restart single Kafka broker.

**Enterprise**
→ broker failover within a replicated Kafka cluster.

The property remains:

**Required Event Transport State Remains Available or Recoverable**.

Another example:

**Version 1**
→ rebuild Silver from local Bronze.

**Enterprise**
→ rebuild Silver from distributed object storage.

The reconstruction principle remains unchanged.

### 24.35 Mechanism Strengthening

Enterprise evolution should strengthen reliability properties rather than bypass them.

For example:

**Local Bronze**
→ distributed replicated Bronze.

The stronger mechanism should preserve or improve:

- durability;
- interpretability;
- replayability;
- access control;
- lineage;
- rebuild capability.

Technology substitution must be evaluated against the property it protects.

### 24.36 Reliability Portability

Atlas Engineering should define reliability requirements independently from one specific product implementation.

The architecture should not define:

**Docker Restart = Reliability**

or:

**Kafka = Recoverability**.

Instead it defines properties such as:

- durable event history;
- restartable processing;
- idempotent redelivery;
- reconstructible derived state;
- certified publication protection.

Technologies implement these properties.

They are not the properties themselves.

### 24.37 Laboratory Evidence Boundaries

Version 1 evidence must identify the conditions under which the result was observed.

Relevant context may include:

- hardware;
- topology;
- component versions;
- data volume;
- partition count;
- workload;
- failure duration;
- retention;
- recovery source;
- processing version.

A laboratory PASS demonstrates behavior under those conditions.

It must not automatically be generalized beyond them.

### 24.38 Laboratory Versus Enterprise Claims

Appropriate Version 1 claims may include:

**Demonstrated**
→ Bronze consumer recovers from retained Kafka history after controlled interruption.

**Demonstrated**
→ Silver can be rebuilt from governed Bronze history in the tested dataset.

**Demonstrated**
→ previous Certified Gold remains available while a failing candidate is blocked.

Unsupported broad claims include:

**Atlas Engineering provides enterprise HA.**

**Atlas Engineering provides zero-data-loss DR.**

**Atlas Engineering meets production RTO and RPO requirements.**

Claims must remain proportional to implementation and evidence.

### 24.39 Enterprise Gap Documentation

Where Version 1 does not implement an enterprise reliability capability, documentation should identify:

- missing physical capability;
- logical property already preserved;
- laboratory limitation;
- expected enterprise mechanism where known.

Examples include:

**Logical Property**
→ Kafka event replay.

**Laboratory Limitation**
→ single broker.

**Enterprise Evolution**
→ replicated multi-broker Kafka.

This makes the evolution path explicit without pretending the future mechanism already exists.

### 24.40 Avoiding Reliability Theater

Reliability mechanisms must not be implemented merely to make the architecture appear sophisticated.

Examples of reliability theater include:

- keeping backups that have never been restored;
- configuring retries without observing exhaustion;
- claiming replay without testing retained offsets;
- claiming rebuild without deleting or isolating the target;
- claiming RTO without measuring catch-up;
- claiming HA because Docker restarts a container;
- claiming DR because files are copied to another directory on the same disk.

A smaller set of tested and evidenced capabilities is more valuable than a larger set of unvalidated labels.

### 24.41 Evidence-Driven Enterprise Evolution

Laboratory evidence should help justify enterprise evolution.

For example:

**Observed**
→ Silver rebuild consumes excessive time.

Possible evolution:

→ more processing capacity  
→ partitioning improvement  
→ optimized storage layout.

Another example:

**Observed**
→ host failure would remove Kafka and Bronze simultaneously.

Possible evolution:

→ independent distributed storage and multi-host Kafka.

Evidence provides a technical reason for enterprise architecture investment.

### 24.42 Reliability ADRs

Major enterprise reliability decisions should be documented through ADRs when they materially change architecture.

Examples include:

- Kafka replication model;
- SQL Server HA technology;
- object-storage replication model;
- backup architecture;
- cross-region DR;
- recovery automation;
- processing autoscaling strategy.

ADRs should preserve:

- context;
- alternatives;
- decision;
- trade-offs;
- reliability effect;
- migration considerations.

### 24.43 Laboratory-to-Enterprise Validation

A control validated in Version 1 must be revalidated when the implementation mechanism changes materially.

For example:

**Version 1**
→ replay tested on single-node Kafka.

Later:

**Enterprise**
→ replicated multi-broker Kafka.

Replay semantics may remain conceptually equivalent, but:

- failure behavior;
- throughput;
- failover;
- retention;
- operational tooling;

have changed.

Enterprise implementation therefore requires its own evidence.

### 24.44 Reliability Maturity Progression

Atlas Engineering may describe reliability evolution through progressively stronger states such as:

**Designed**
→ recovery behavior defined.

**Implemented**
→ mechanism exists.

**Tested**
→ controlled scenario executed.

**Demonstrated**
→ evidence supports expected behavior.

**Scaled**
→ behavior validated under larger representative workload.

**Highly Available**
→ required redundant topology and failover validated.

**Disaster-Recoverable**
→ required independent recovery environment and procedure validated.

These terms must be used only when their corresponding evidence exists.

### 24.45 Version 1 Reliability Baseline

At completion of Version 1 reliability testing, the project should maintain a baseline identifying which capabilities have been:

- designed;
- implemented;
- tested;
- demonstrated;
- measured;
- deferred to enterprise evolution.

The baseline should include limitations.

A limitation is not a failure of the architecture when it is deliberate, documented, and appropriately scoped.

### 24.46 Laboratory and Enterprise Reliability Validation

Validation should confirm that:

- Version 1 claims match the implemented topology;
- logical boundaries remain preserved despite physical co-location;
- tested recovery properties remain reproducible;
- limitations are explicit;
- enterprise mechanisms preserve the same logical reliability requirements;
- architectural claims do not exceed evidence.

### 24.47 Laboratory and Enterprise Reliability Evidence

Representative evidence may preserve:

- laboratory topology;
- shared failure domains;
- implemented recovery mechanisms;
- tested scenarios;
- observed RPO;
- observed recovery times;
- rebuild rates;
- catch-up rates;
- rollback behavior;
- known limitations;
- proposed enterprise evolution.

This provides a factual bridge between the training laboratory and future production architecture.

### 24.48 Laboratory and Enterprise Reliability Guarantees

The Atlas Engineering laboratory and enterprise reliability model must preserve the following guarantees:

1. Version 1 is a controlled reliability and recovery laboratory;
2. laboratory testing demonstrates actual implemented behavior rather than only architectural intention;
3. shared physical failure domains remain explicit;
4. physical co-location does not eliminate logical recovery boundaries;
5. durability claims remain bounded by the failure domain tested;
6. restartability is demonstrated without being misrepresented as High Availability;
7. retry, redelivery, replay, reprocessing, backfill, rebuild, backlog recovery, isolation, and poison handling can be meaningfully validated in the laboratory;
8. Certified Gold protection and rollback remain portable logical reliability properties;
9. publication atomicity is defined as a consumer-visible property independent of one implementation mechanism;
10. laboratory RPO and RTO results remain observations rather than universal service commitments;
11. logical availability behavior can be demonstrated without claiming unimplemented physical redundancy;
12. single-host Version 1 limitations remain explicit;
13. enterprise physical distribution strengthens failure-domain independence;
14. enterprise Kafka, SQL Server, storage, processing, orchestration, and observability may use stronger mechanisms while preserving the same logical principles;
15. enterprise backup design aligns with actual RPO and DR requirements;
16. recovery automation follows validated recovery semantics;
17. enterprise capacity planning includes recovery headroom;
18. enterprise recovery objectives require enterprise business requirements and enterprise-specific validation;
19. implementation mechanisms may be substituted while reliability properties remain stable;
20. enterprise evolution strengthens rather than bypasses tested reliability boundaries;
21. reliability requirements remain portable across technologies;
22. laboratory evidence records topology, workload, and failure context;
23. reliability claims remain proportional to evidence;
24. unimplemented enterprise capabilities are documented as explicit gaps or evolution points;
25. reliability theater is avoided in favor of tested behavior;
26. laboratory evidence informs enterprise architecture investment;
27. major reliability evolution is documented through ADRs where appropriate;
28. materially changed enterprise mechanisms are revalidated;
29. reliability maturity terminology is used only when supported by evidence;
30. Version 1 maintains an explicit reliability baseline with both demonstrated capabilities and limitations;
31. laboratory and enterprise reliability behavior is considered valid only within the environments and scenarios actually tested.

---

## 25. Reliability and Recovery Guarantees

Atlas Engineering defines reliability and recovery as architectural properties that must remain valid across ingestion, transport, processing, storage, certification, publication, analytical consumption, and future platform evolution.

The detailed requirements defined throughout this document remain authoritative within their respective sections.

This chapter consolidates the principal platform-level guarantees.

### 25.1 Failure Is Expected

Failures are treated as normal operational conditions.

The architecture must preserve enough durable state, processing progress, metadata, and recovery context to prevent ordinary failure from automatically becoming uncontrolled data loss, corruption, duplication, or irreversible processing state.

### 25.2 Durable State Precedes Progress

Processing progress must not advance beyond the state that has been safely persisted.

The governing rule is:

**Persist Required State → Confirm Success → Advance Progress**

Where atomic coordination is unavailable, safe redelivery is preferred to silent omission.

### 25.3 Restartability

Processing components must resume from explicit durable progress rather than assumptions about what may have completed before interruption.

Restart remains distinct from:

- retry;
- replay;
- reprocessing;
- backfill;
- rebuild.

### 25.4 Idempotent Recovery

Expected retry, redelivery, replay, restart, and reconstruction must not create unintended duplicate business effects.

Atlas Engineering accepts that the same logical input may be processed more than once.

Correctness is preserved by idempotent processing rather than unsupported exactly-once assumptions.

### 25.5 Explicit Processing Progress

Recovery-relevant progress must remain explicit and durable where required.

Representative progress may include:

- source position;
- Kafka offset;
- checkpoint;
- watermark;
- batch;
- processing interval;
- candidate version;
- certification state.

Service uptime does not replace processing-progress evidence.

### 25.6 Failure Classification

Failures are classified according to their architectural consequence rather than only the technology that reported the error.

Classification considers:

- failure domain;
- failure scope;
- affected state;
- downstream impact;
- correctness risk;
- data-loss risk;
- recoverability risk;
- available recovery window.

### 25.7 Failure Isolation

Failures should be contained to the smallest safe scope where practical.

Independent valid processing may continue when it does not depend on the failed state.

Processing must block when continuing would violate:

- ordering;
- completeness;
- reference integrity;
- quality;
- reconciliation;
- certification;
- consumer correctness.

### 25.8 No Silent Loss

Failed input must not disappear from the governed processing path.

When processing cannot continue, the platform must preserve enough information to determine:

- what failed;
- what input was affected;
- whether the input remains recoverable;
- what progress was committed;
- what remediation is required.

### 25.9 No Silent Corruption

Technical execution success does not prove correct data.

Recovery must not silently:

- duplicate business effects;
- omit required records;
- reinterpret history incorrectly;
- bypass quality;
- bypass reconciliation;
- publish incomplete state.

Recovered output remains subject to the correctness controls applicable to its layer.

### 25.10 Bounded Retry

Retry is intended for failures that may reasonably succeed without changing underlying business meaning.

Retry must remain:

- bounded;
- observable;
- appropriately delayed;
- safe under repeated execution.

Retry exhaustion transitions work into explicit persistent-failure handling.

### 25.11 Persistent Failure Handling

Deterministic failures must not remain in uncontrolled infinite retry.

Persistent failed input must be either:

- safely isolated;
- quarantined;
- or used to block the affected processing scope.

The selected behavior must preserve ordering, completeness, and recoverability.

### 25.12 Quarantine Is Governed State

Quarantine preserves unresolved work.

It is not deletion, disposal, or a hidden error sink.

Quarantined state must remain:

- attributable;
- observable;
- secure;
- recoverable;
- associated with remediation and closure.

### 25.13 Backpressure Before Loss

When downstream processing cannot keep pace with incoming data, controlled backlog is preferable to silent loss.

Backlog must remain bounded by:

- retention;
- storage;
- processing capacity;
- recovery objectives;
- freshness requirements.

### 25.14 Recovery Source Selection

A recovery source is selected according to:

- failure location;
- invalidated state;
- recovery objective;
- available history;
- historical interpretation context;
- trust.

Physical availability alone does not make a state an appropriate recovery source.

### 25.15 Latest Appropriate Trustworthy Boundary

Recovery should normally begin from the latest appropriate trustworthy boundary capable of satisfying the recovery objective.

The newest state is not automatically preferred.

The oldest state is not automatically safer.

The selected state must be both appropriate and trustworthy.

### 25.16 Recovery Source Hierarchy

The conceptual preference for analytical recovery is:

**Kafka**
→ normal retained event replay.

**Bronze**
→ primary historical analytical reconstruction.

**Silver**
→ downstream reconstruction when Silver remains valid.

**AtlasCommerce / Controlled Backfill**
→ restoration when required history is unavailable from retained analytical paths.

**Backup / Archive**
→ broader restoration when online recovery sources are insufficient.

This is a preference model, not a mandatory sequence.

### 25.17 Replay

Replay is the controlled re-consumption of previously retained input.

Replay requires:

- complete required retained history;
- explicit boundaries;
- preserved ordering;
- idempotent processing;
- controlled progress;
- validation.

Replay does not recreate events that no longer exist.

### 25.18 Reprocessing

Reprocessing is the intentional repeated execution of historical governed input.

It may be used for:

- historical reproduction;
- corrected logic;
- historical restatement;
- derived-state regeneration.

The selected processing version and historical context must remain explicit.

### 25.19 Backfill

Backfill introduces or reconstructs required historical state when ordinary retained replay cannot fully satisfy the objective.

Backfill must preserve:

- governed source;
- bounded scope;
- provenance;
- live-processing overlap control;
- reconciliation;
- lineage.

Current-state backfill must not be represented as historical event reconstruction.

### 25.20 Rebuild

Rebuild reconstructs derived state from a trustworthy upstream boundary.

Representative relationships include:

**Kafka → Bronze**

**Bronze → Silver**

**Silver → Gold**

Rebuild remains subject to:

- processing-version control;
- restartability;
- quality;
- reconciliation;
- lineage;
- certification where applicable.

### 25.21 Historical Recoverability

Historical recoverability requires more than retained data.

The platform must preserve sufficient historical interpretation context, including where required:

- schemas;
- event contracts;
- processing definitions;
- reference state;
- quality rules;
- reconciliation rules;
- metadata;
- lineage.

The effective historical recovery window is bounded by the shortest required governed dependency.

### 25.22 Historical Reproduction and Restatement

Historical recovery distinguishes:

**Reproduction**
→ reconstruct the expected result according to the applicable historical definition.

**Restatement**
→ intentionally recalculate historical data using a corrected or selected newer definition.

The two objectives must remain explicit in processing version and lineage.

### 25.23 Recovery and Current Governance

Historical recovery does not restore obsolete governance automatically.

Current applicable controls remain authoritative for:

- identity;
- authorization;
- privacy;
- classification;
- retention;
- certification;
- publication.

Historical technical state must not resurrect invalidated trust or prohibited data state.

### 25.24 Backlog Recovery

A service returning to operation does not establish complete recovery when accumulated work remains.

Catch-up must demonstrate that:

- processing resumes from committed progress;
- backlog decreases;
- oldest pending age improves;
- checkpoints advance;
- downstream stages recover;
- freshness returns toward its expected range.

### 25.25 Recovery Capacity

Backlog can decrease only when effective processing capacity exceeds incoming workload.

Recovery planning must therefore consider:

- steady-state throughput;
- peak workload;
- catch-up headroom;
- partition skew;
- downstream capacity;
- retry load;
- rebuild workload.

Capacity planning includes recovery capacity, not only normal operation.

### 25.26 Recovery Window Protection

Bounded recovery sources must remain observable.

Operational priority must increase when required history approaches expiration.

A failure may evolve from:

**Freshness Problem**

to:

**Recoverability Risk**

and eventually:

**Data-Loss Risk**

if recovery windows are exhausted.

### 25.27 Certified Gold Protection

Gold candidate state remains isolated from consumers until certification succeeds.

When new processing fails:

**Previous Known-Good Certified Gold**
→ remains consumer-visible where still trustworthy.

This preserves analytical availability while protecting correctness.

### 25.28 Fail-Safe Publication

Publication must expose one complete governed Certified Gold version.

Consumers must not observe uncontrolled mixtures of:

- previous state;
- incomplete new state;
- partially promoted state.

Publication failure should preserve or restore one clear known-good version.

### 25.29 Rollback

Rollback restores a previous known-good Certified Gold version.

Rollback is distinct from:

- rebuild;
- replay;
- backup restore.

Rollback may restore consumer availability and correctness while freshness remains degraded.

The preferred long-term recovery is corrected roll-forward.

### 25.30 No Known-Good State

If no consumer-visible Certified Gold version remains trustworthy, the affected analytical product may become unavailable.

Known-invalid data must not be served merely to preserve uptime.

Correctness takes precedence over artificial availability.

### 25.31 Recovery Is Multi-Dimensional

Atlas Engineering distinguishes:

**Component Recovery**

**Processing Recovery**

**Data Recovery**

**Correctness Recovery**

**Consumer Recovery**

These states may occur at different times.

A component returning to `UP` does not prove complete recovery.

### 25.32 Recovery Validation

Recovery must be validated according to the responsibility affected.

Validation may include:

- continuity;
- checkpoint correctness;
- gap detection;
- duplicate-effect detection;
- ordering;
- backlog convergence;
- quality;
- reconciliation;
- lineage;
- certification;
- consumer freshness.

A recovery command completing successfully is not itself sufficient proof.

### 25.33 Recovery Evidence

Significant recovery behavior must be supported by evidence.

The governing relationship is:

**Known State → Failure → Recovery Action → Recovered State → Validation → Evidence**

Evidence may include:

- offsets;
- checkpoints;
- logs;
- metrics;
- processing metadata;
- record counts;
- quality results;
- reconciliation;
- certification history;
- publication history;
- consumer queries.

### 25.34 Recovery Testing

Version 1 validates recovery through controlled failure testing.

Tests must define:

- initial state;
- hypothesis;
- failure injection;
- expected impact;
- expected recovery;
- PASS criteria;
- FAIL criteria;
- cleanup;
- evidence.

Failed and inconclusive tests remain valid engineering results.

### 25.35 Evidence Can Change Architecture

Recovery testing may demonstrate that an architectural assumption is incorrect.

When evidence contradicts design:

**Investigate → Correct Architecture or Implementation → Revalidate**

The test expectation must not be rewritten merely to manufacture a PASS.

### 25.36 RPO

Recovery Point Objective represents a recoverable data boundary.

RPO may differ across:

- source;
- CDC;
- Kafka;
- Bronze;
- derived layers;
- Certified Gold.

RPO is not synonymous with backup interval.

Zero-data-loss claims remain scoped to the failure conditions actually demonstrated.

### 25.37 RTO

Recovery Time Objective must identify the capability and endpoint considered recovered.

Possible recovery times include:

- technical restoration;
- processing recovery;
- catch-up;
- rebuild;
- validation;
- Certified Gold restoration;
- consumer freshness recovery.

Service restart alone is not an end-to-end analytical RTO.

### 25.38 Availability and Freshness

Availability and freshness remain distinct.

A data product may be:

**Available and Current**

**Available but Stale**

**Unavailable**

A stale known-good certified state may be preferable to a newer unvalidated state.

### 25.39 Reliability and High Availability

Reliability is broader than High Availability.

High Availability requires actual redundancy, independent failure domains, and failover mechanisms.

**Restartability ≠ High Availability**

**Recoverability ≠ High Availability**

Version 1 must not claim enterprise HA where redundant topology has not been implemented and validated.

### 25.40 Disaster Recovery

Disaster Recovery addresses failures broader than ordinary component recovery.

DR may require restoration of:

- infrastructure;
- durable data;
- security dependencies;
- contracts;
- configuration;
- processing;
- metadata;
- observability;
- certification;
- consumer access.

Backup is one DR mechanism.

It is not a complete DR capability by itself.

### 25.41 Failure-Domain Independence

Multiple copies provide stronger recovery only when they survive the failure domain being protected against.

The architecture distinguishes:

**Logical Copy Count**

from:

**Failure-Domain Independence**

Local redundancy on one workstation must not be represented as host-independent DR.

### 25.42 Recovery Observability

Recovery state must be observable through signals appropriate to each responsibility.

Relevant signals may include:

- health;
- dependency state;
- checkpoint age;
- lag;
- backlog;
- oldest pending age;
- throughput;
- retry state;
- quarantine;
- retention margin;
- freshness;
- certification;
- publication.

Observability must distinguish service health from data-flow health.

### 25.43 Recovery Convergence

A recovery process must demonstrate convergence.

Representative evidence includes:

- backlog decreasing;
- oldest pending age decreasing;
- checkpoints advancing;
- retries reducing;
- quarantine resolving;
- downstream boundaries advancing;
- freshness improving.

A running process that does not converge is not fully recovered.

### 25.44 Reliability Claims

Atlas Engineering reliability claims must remain proportional to implementation and evidence.

The project distinguishes:

**Designed**

**Implemented**

**Tested**

**Demonstrated**

and, where future evidence supports them:

**Scaled**

**Highly Available**

**Disaster-Recoverable**

These labels must not be used beyond the capability actually validated.

### 25.45 Laboratory Boundary

Version 1 is a controlled reliability and recovery laboratory.

It can demonstrate meaningful logical behavior such as:

- replay;
- idempotency;
- rebuild;
- backlog recovery;
- rollback;
- controlled failure isolation.

It does not automatically demonstrate:

- multi-node HA;
- host-independent redundancy;
- production-scale recovery;
- cross-region DR.

### 25.46 Enterprise Evolution

Enterprise implementation may strengthen Version 1 through mechanisms such as:

- multi-node Kafka;
- SQL Server HA;
- distributed object storage;
- redundant compute;
- resilient orchestration;
- stronger backup architecture;
- off-host recovery;
- automated failover;
- cross-region DR.

These mechanisms strengthen physical resilience while preserving the same logical recovery principles.

### 25.47 Reliability Theater Is Rejected

Atlas Engineering must not treat the presence of a technology or configuration as proof of reliability.

Examples include:

**Backup Exists**
≠ **Restore Demonstrated**

**Retry Configured**
≠ **Persistent Failure Controlled**

**Kafka Retains Data**
≠ **Replay Demonstrated**

**Container Restarts**
≠ **High Availability**

**File Copied Locally**
≠ **Disaster Recovery**

**RTO Documented**
≠ **RTO Measured**

Reliability is demonstrated through behavior and evidence.

### 25.48 Closing Principle

Atlas Engineering reliability and recovery are successful when the platform can demonstrate that:

- failure does not silently lose governed data;
- repeated processing does not create unintended business effects;
- durable progress allows safe restart;
- failed work remains traceable;
- recovery sources remain explicit and trustworthy;
- historical state can be interpreted while its recovery window is supported;
- backlog can converge after interruption;
- derived state can be reconstructed;
- known-good consumer state is protected;
- invalid state does not cross certification boundaries;
- recovery preserves current governance;
- recovery results are validated;
- RPO and RTO claims are evidence-based;
- laboratory limitations remain explicit;
- enterprise evolution strengthens rather than replaces the underlying reliability properties.

The governing principle of Atlas Engineering is:

**Expect Failure → Preserve State → Recover From Trust → Revalidate Correctness → Restore Governed Availability → Prove What Was Recovered**