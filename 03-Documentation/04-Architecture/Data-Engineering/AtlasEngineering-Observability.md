# Atlas Engineering — Observability

## Table of Contents

- [1. Purpose and Scope](#1-purpose-and-scope)

- [2. Observability Principles](#2-observability-principles)
  - [2.1 Observability Is Designed into the Platform](#21-observability-is-designed-into-the-platform)
  - [2.2 Evidence Must Support Diagnosis](#22-evidence-must-support-diagnosis)
  - [2.3 Observability Must Follow Processing Boundaries](#23-observability-must-follow-processing-boundaries)
  - [2.4 Correlation Must Preserve End-to-End Context](#24-correlation-must-preserve-end-to-end-context)
  - [2.5 Metrics Require Context](#25-metrics-require-context)
  - [2.6 Failure Visibility Must Be Explicit](#26-failure-visibility-must-be-explicit)
  - [2.7 Recovery Must Be Observable](#27-recovery-must-be-observable)
  - [2.8 Observability Must Support Evidence](#28-observability-must-support-evidence)
  - [2.9 Telemetry Must Be Proportionate](#29-telemetry-must-be-proportionate)
  - [2.10 Observability Must Not Change Processing Semantics](#210-observability-must-not-change-processing-semantics)

- [3. Observability Model](#3-observability-model)
  - [3.1 Operational Events](#31-operational-events)
  - [3.2 Logs](#32-logs)
  - [3.3 Metrics](#33-metrics)
  - [3.4 Execution State](#34-execution-state)
  - [3.5 Processing Progress](#35-processing-progress)
  - [3.6 Data Freshness and Latency](#36-data-freshness-and-latency)
  - [3.7 Backlog and Lag](#37-backlog-and-lag)
  - [3.8 Errors and Rejections](#38-errors-and-rejections)
  - [3.9 Recovery Activity](#39-recovery-activity)
  - [3.10 Combined Interpretation](#310-combined-interpretation)

- [4. Observability Across the Data Flow](#4-observability-across-the-data-flow)
  - [4.1 Source Ingestion](#41-source-ingestion)
  - [4.2 Kafka Transport](#42-kafka-transport)
  - [4.3 Bronze Processing](#43-bronze-processing)
  - [4.4 Silver Processing](#44-silver-processing)
  - [4.5 Gold Dimensional Processing](#45-gold-dimensional-processing)
  - [4.6 Certification and Validation](#46-certification-and-validation)
  - [4.7 Orchestration and Scheduled Execution](#47-orchestration-and-scheduled-execution)
  - [4.8 Downstream Availability](#48-downstream-availability)
  - [4.9 End-to-End Processing Visibility](#49-end-to-end-processing-visibility)

- [5. Correlation and Traceability](#5-correlation-and-traceability)
  - [5.1 Correlation Context](#51-correlation-context)
  - [5.2 Execution Identification](#52-execution-identification)
  - [5.3 Processing Scope](#53-processing-scope)
  - [5.4 Cross-Stage Correlation](#54-cross-stage-correlation)
  - [5.5 Time Correlation](#55-time-correlation)
  - [5.6 Kafka Correlation](#56-kafka-correlation)
  - [5.7 Recovery Correlation](#57-recovery-correlation)
  - [5.8 Failure Correlation](#58-failure-correlation)
  - [5.9 Correlation and Lineage](#59-correlation-and-lineage)
  - [5.10 Correlation Is Not an Independent Source of Truth](#510-correlation-is-not-an-independent-source-of-truth)

- [6. Metrics and Measurements](#6-metrics-and-measurements)
  - [6.1 Processing Metrics](#61-processing-metrics)
  - [6.2 Duration Metrics](#62-duration-metrics)
  - [6.3 Throughput](#63-throughput)
  - [6.4 Processing Latency](#64-processing-latency)
  - [6.5 Data Freshness](#65-data-freshness)
  - [6.6 Backlog and Consumer Lag](#66-backlog-and-consumer-lag)
  - [6.7 Error and Rejection Metrics](#67-error-and-rejection-metrics)
  - [6.8 Recovery Metrics](#68-recovery-metrics)
  - [6.9 Resource Metrics](#69-resource-metrics)
  - [6.10 Baselines](#610-baselines)
  - [6.11 Thresholds](#611-thresholds)
  - [6.12 Measurement Quality](#612-measurement-quality)

- [7. Logs and Operational Events](#7-logs-and-operational-events)
  - [7.1 Structured Logging](#71-structured-logging)
  - [7.2 Log Levels](#72-log-levels)
  - [7.3 Lifecycle Events](#73-lifecycle-events)
  - [7.4 Failure Events](#74-failure-events)
  - [7.5 Retry Events](#75-retry-events)
  - [7.6 Recovery Events](#76-recovery-events)
  - [7.7 Data-Level Rejection Events](#77-data-level-rejection-events)
  - [7.8 Sensitive Information](#78-sensitive-information)
  - [7.9 Log Volume](#79-log-volume)
  - [7.10 Log Retention](#710-log-retention)
  - [7.11 Log Availability During Failure](#711-log-availability-during-failure)
  - [7.12 Logs Are Evidence, Not Authority](#712-logs-are-evidence-not-authority)

- [8. Alerting and Operational Signals](#8-alerting-and-operational-signals)
  - [8.1 Alerting Principles](#81-alerting-principles)
  - [8.2 Actionable Alerts](#82-actionable-alerts)
  - [8.3 Symptom and Cause](#83-symptom-and-cause)
  - [8.4 Severity](#84-severity)
  - [8.5 Threshold-Based Alerts](#85-threshold-based-alerts)
  - [8.6 State-Based Alerts](#86-state-based-alerts)
  - [8.7 Composite Signals](#87-composite-signals)
  - [8.8 Missing Activity](#88-missing-activity)
  - [8.9 Alert Deduplication and Suppression](#89-alert-deduplication-and-suppression)
  - [8.10 Alert Lifecycle](#810-alert-lifecycle)
  - [8.11 Alert Routing](#811-alert-routing)
  - [8.12 Alert Fatigue](#812-alert-fatigue)
  - [8.13 Alerts Are Operational Signals](#813-alerts-are-operational-signals)

- [9. Dashboards and Operational Views](#9-dashboards-and-operational-views)
  - [9.1 Operational Overview](#91-operational-overview)
  - [9.2 Processing Progress Views](#92-processing-progress-views)
  - [9.3 Freshness and Latency Views](#93-freshness-and-latency-views)
  - [9.4 Backlog and Lag Views](#94-backlog-and-lag-views)
  - [9.5 Failure Views](#95-failure-views)
  - [9.6 Data Quality and Certification Views](#96-data-quality-and-certification-views)
  - [9.7 Recovery Views](#97-recovery-views)
  - [9.8 Historical Views](#98-historical-views)
  - [9.9 Drill-Down](#99-drill-down)
  - [9.10 Audience and Purpose](#910-audience-and-purpose)
  - [9.11 Dashboard Status Must Have Defined Semantics](#911-dashboard-status-must-have-defined-semantics)
  - [9.12 Dashboards Are Navigation, Not Diagnosis](#912-dashboards-are-navigation-not-diagnosis)

- [10. Observability of Recovery Operations](#10-observability-of-recovery-operations)
  - [10.1 Recovery Identification](#101-recovery-identification)
  - [10.2 Recovery Types](#102-recovery-types)
  - [10.3 Recovery Trigger](#103-recovery-trigger)
  - [10.4 Recovery Scope](#104-recovery-scope)
  - [10.5 Recovery Progress](#105-recovery-progress)
  - [10.6 Recovery and New Processing](#106-recovery-and-new-processing)
  - [10.7 Recovery Failures](#107-recovery-failures)
  - [10.8 Recovery Completion](#108-recovery-completion)
  - [10.9 Post-Recovery Validation](#109-post-recovery-validation)
  - [10.10 Recovery Duration and Objectives](#1010-recovery-duration-and-objectives)
  - [10.11 Recovery History](#1011-recovery-history)
  - [10.12 Recovery Evidence](#1012-recovery-evidence)

- [11. Retention, Evidence, and Validation](#11-retention-evidence-and-validation)
  - [11.1 Retention Categories](#111-retention-categories)
  - [11.2 Operational Retention](#112-operational-retention)
  - [11.3 Historical Retention](#113-historical-retention)
  - [11.4 Evidence Retention](#114-evidence-retention)
  - [11.5 Evidence Must Be Reproducible](#115-evidence-must-be-reproducible)
  - [11.6 Evidence Must Be Correlated](#116-evidence-must-be-correlated)
  - [11.7 Observability Validation](#117-observability-validation)
  - [11.8 Failure Injection and Controlled Scenarios](#118-failure-injection-and-controlled-scenarios)
  - [11.9 Expected Evidence](#119-expected-evidence)
  - [11.10 Evidence Completeness](#1110-evidence-completeness)
  - [11.11 Retention and Security](#1111-retention-and-security)
  - [11.12 Retention and Cost](#1112-retention-and-cost)
  - [11.13 Evidence as an Architectural Deliverable](#1113-evidence-as-an-architectural-deliverable)

- [12. Architectural Boundaries and Closing Principles](#12-architectural-boundaries-and-closing-principles)
  - [12.1 Processing Boundary](#121-processing-boundary)
  - [12.2 Reliability and Recovery Boundary](#122-reliability-and-recovery-boundary)
  - [12.3 Security and Governance Boundary](#123-security-and-governance-boundary)
  - [12.4 Testing and Evidence Boundary](#124-testing-and-evidence-boundary)
  - [12.5 Technology Boundary](#125-technology-boundary)
  - [12.6 Laboratory and Enterprise Boundary](#126-laboratory-and-enterprise-boundary)
  - [12.7 Closing Principles](#127-closing-principles)

---

## 1. Purpose and Scope

This document defines the observability architecture of the Atlas Engineering data platform.

Its purpose is to establish how the platform exposes sufficient operational evidence to understand its current state, processing behavior, failures, recovery activity, data movement, and overall health across the end-to-end data flow.

Observability is treated as an architectural capability rather than as a collection of isolated monitoring tools. The objective is not only to detect that a component has failed, but to provide enough context to determine what happened, where it happened, which processing scope was affected, and what evidence is available to support diagnosis and recovery.

The observability model therefore spans the major processing boundaries of the platform, including:

- source ingestion;
- Kafka transport;
- Bronze processing;
- Silver processing;
- Gold dimensional processing;
- certification and validation;
- orchestration and scheduled execution;
- replay, reprocessing, backfill, and rebuild operations;
- operational failures and recovery activity.

The architecture must make it possible to correlate relevant operational events across these boundaries without requiring every component to implement identical observability mechanisms.

This document defines the architectural principles and responsibilities for:

- logs and operational events;
- metrics and processing measurements;
- execution and processing state;
- correlation and traceability;
- failure visibility;
- data freshness and processing latency;
- backlog and processing progress;
- alerting and operational signals;
- dashboards and operational views;
- observability of recovery operations;
- retention of operational evidence;
- validation of observability behavior.

This document does not redefine the processing semantics established by **Data Flow and Processing**, the recovery guarantees established by **Reliability and Recovery**, or the security and governance controls established by **Security and Governance**.

Instead, it defines how those behaviors become visible and measurable enough to support operation, investigation, validation, and architectural evidence.

Observability does not by itself guarantee correctness, reliability, or recovery. It provides the evidence required to determine whether those guarantees are behaving as designed.

---

## 2. Observability Principles

The Atlas Engineering observability architecture is based on a set of principles that define how operational evidence must be produced, interpreted, and used across the platform.

### 2.1 Observability Is Designed into the Platform

Observability must be considered during the design of each processing component and workflow rather than added only after failures occur.

Each relevant processing stage must expose enough information to determine its execution state, processing scope, outcome, and relationship with upstream and downstream activity.

A component that performs work without producing sufficient operational evidence creates a blind spot in the platform.

### 2.2 Evidence Must Support Diagnosis

Operational signals must provide enough context to support investigation.

Knowing that a process failed is not sufficient when the platform cannot determine:

- which component failed;
- which execution was affected;
- when the failure occurred;
- which processing scope was involved;
- what stage had already been completed;
- what error or condition was observed;
- whether downstream processing was affected;
- whether recovery activity was initiated.

The objective is to reduce ambiguity during diagnosis rather than merely increase the volume of telemetry produced by the platform.

### 2.3 Observability Must Follow Processing Boundaries

Operational evidence must reflect the architectural boundaries defined by the platform.

Source ingestion, Kafka transport, Bronze, Silver, Gold, certification, and recovery operations represent distinct processing responsibilities and must remain distinguishable during investigation.

Observability must make it possible to identify where processing successfully completed and where progress stopped or became invalid.

### 2.4 Correlation Must Preserve End-to-End Context

Relevant operational events must be correlatable across components and processing stages.

Where applicable, executions must carry identifiers and contextual metadata that allow operators to relate upstream activity, downstream processing, failures, retries, replay, reprocessing, backfill, rebuild, and certification activity.

Correlation does not require every technology to expose identical telemetry. It requires sufficient shared context to reconstruct the relevant processing path.

### 2.5 Metrics Require Context

A metric alone does not constitute a diagnosis.

Processing duration, throughput, lag, error count, backlog size, resource consumption, or freshness may indicate abnormal behavior, but their meaning depends on workload, processing scope, historical behavior, architectural expectations, and related signals.

The observability architecture must therefore support correlation between measurements, execution state, logs, and processing context.

### 2.6 Failure Visibility Must Be Explicit

Failures must not disappear silently inside processing components.

Relevant failures must produce observable evidence that identifies the affected execution or processing scope and supports the recovery semantics defined by the platform.

A failed operation that leaves no reliable evidence is itself an observability failure.

### 2.7 Recovery Must Be Observable

Replay, reprocessing, backfill, rebuild, retry, and backlog recovery are operational activities and must be observable as such.

The platform must make it possible to distinguish normal processing from recovery activity and determine:

- what recovery operation was performed;
- why it was initiated;
- which processing scope was affected;
- when it started and completed;
- whether it succeeded;
- what resulting state was produced.

### 2.8 Observability Must Support Evidence

Operational information must support not only real-time investigation but also validation of architectural behavior.

Where evidence is required to demonstrate that processing, failure handling, recovery, certification, or other platform guarantees behave as designed, the observability architecture must provide information that can be retained and evaluated.

Observability therefore contributes directly to the evidence produced by laboratory validation and testing.

### 2.9 Telemetry Must Be Proportionate

Producing operational information has a cost.

Logs, metrics, retained execution history, and other telemetry consume storage, processing capacity, network resources, and operational attention.

The platform must collect enough information to support its operational and validation requirements without generating unnecessary telemetry or treating maximum collection volume as an observability objective.

### 2.10 Observability Must Not Change Processing Semantics

Observability mechanisms must not become the authoritative source of business or processing state when that responsibility belongs to another platform component.

Telemetry describes and exposes platform behavior. It does not replace durable processing state, checkpoints, certified data, or other authoritative mechanisms defined elsewhere in the architecture.

---

## 3. Observability Model

The Atlas Engineering observability model organizes operational evidence around the execution and processing behavior of the platform.

Rather than treating logs, metrics, alerts, and dashboards as independent concerns, the model combines them to answer progressively more specific operational questions:

- Is the platform operating?
- Is processing progressing as expected?
- Is data arriving and becoming available within the expected time?
- Did a processing stage succeed or fail?
- What execution or processing scope was affected?
- Where did processing stop?
- What evidence explains the observed behavior?
- Is recovery required or already in progress?
- Did recovery restore the expected state?

No single observability signal is expected to answer all of these questions.

### 3.1 Operational Events

Operational events describe relevant occurrences during platform execution.

Examples include:

- processing started;
- processing completed;
- processing failed;
- retry initiated;
- checkpoint advanced;
- certification completed;
- replay initiated;
- reprocessing initiated;
- backfill initiated;
- rebuild initiated;
- recovery completed.

Events must include enough contextual information to associate the occurrence with the relevant component, execution, processing scope, and time.

Operational events describe what occurred. They do not replace the authoritative state maintained by the processing architecture.

### 3.2 Logs

Logs provide contextual and diagnostic information about component behavior and execution.

Where applicable, log records should identify information such as:

- timestamp;
- component or service;
- execution identifier;
- processing stage;
- processing scope;
- severity;
- event or operation;
- outcome;
- error information;
- relevant correlation identifiers.

Logs must favor structured and consistently interpretable information over unstructured diagnostic text when practical.

Sensitive information must not be included merely because it may be useful during troubleshooting. Logging remains subject to the security, privacy, and governance requirements defined by the platform.

### 3.3 Metrics

Metrics provide quantitative measurements of platform behavior over time.

Relevant measurements may include:

- processing duration;
- processing throughput;
- records received;
- records processed;
- records rejected;
- records pending;
- error counts;
- retry counts;
- backlog size;
- consumer lag;
- data freshness;
- processing latency;
- recovery duration;
- resource utilization where operationally relevant.

Metrics must be interpreted in context. A value becoming larger or smaller does not independently establish that a failure or performance problem exists.

### 3.4 Execution State

Execution state describes the lifecycle of processing activity.

Where the architecture maintains durable execution or processing state, observability must expose enough information to determine whether an execution is:

- pending;
- running;
- completed;
- failed;
- awaiting recovery;
- being recovered;
- superseded or otherwise no longer authoritative, where applicable.

The exact state model may vary between components, but operational views must preserve the distinction between successful completion, incomplete processing, and failure.

Observability may expose authoritative execution state, but must not create an independent competing state model.

### 3.5 Processing Progress

The platform must expose evidence of processing progress across its major architectural boundaries.

Operators must be able to determine, within the capabilities of each component:

- what data has arrived;
- what data is waiting to be processed;
- what processing has started;
- what processing has completed;
- what processing has failed;
- how far downstream the relevant scope progressed.

This allows investigation to distinguish between absence of source data, transport delay, processing delay, processing failure, certification failure, and downstream availability problems.

### 3.6 Data Freshness and Latency

Observability must make delays in data availability measurable.

Two related concepts must remain distinguishable:

**Processing latency** describes the time required for data to move through a relevant processing stage or sequence of stages.

**Data freshness** describes how current the available data is relative to the source or expected business processing timeline.

A pipeline may execute successfully while still producing data later than expected. Successful execution therefore does not by itself establish acceptable freshness.

### 3.7 Backlog and Lag

Where asynchronous processing is used, observability must expose whether work is accumulating faster than it is being consumed.

Backlog or lag information must support distinguishing between:

- normal temporary accumulation;
- reduced processing throughput;
- stopped or failed consumers;
- downstream dependency problems;
- recovery after an interruption;
- sustained inability to keep pace with incoming workload.

A backlog is not automatically a failure. Its operational meaning depends on its size, duration, growth pattern, workload, and expected processing behavior.

### 3.8 Errors and Rejections

Operational failures and data-level rejections must remain distinguishable.

A processing component may remain operational while rejecting individual records because they violate expected contracts or quality requirements.

Conversely, a component-level failure may prevent processing regardless of individual record validity.

Observability must preserve enough context to identify the nature and scope of the problem without incorrectly treating every rejected record as a platform outage.

### 3.9 Recovery Activity

Recovery activity must be visible as part of the normal operational model.

Replay, reprocessing, backfill, rebuild, retry, and backlog recovery must produce sufficient evidence to determine their scope, progress, outcome, and relationship with the original processing activity.

Recovery telemetry must allow operators to distinguish newly arriving processing from work being repeated or reconstructed intentionally.

### 3.10 Combined Interpretation

Operational diagnosis must rely on the combined interpretation of relevant signals.

For example, increased consumer lag may be correlated with processing duration, error events, execution state, resource measurements, and downstream availability before determining the likely cause.

Similarly, a completed execution may still require investigation when freshness, record counts, certification results, or downstream state indicate unexpected behavior.

The observability model therefore treats logs, events, metrics, state, progress, and validation evidence as complementary views of platform behavior rather than independent sources of truth.

---

## 4. Observability Across the Data Flow

Observability must follow the end-to-end movement of data through the Atlas Engineering platform while preserving the responsibilities and boundaries of each processing stage.

The objective is to determine not only whether individual components are operational, but also whether data is progressing correctly from the source through transport, processing, certification, and downstream availability.

Each stage must expose evidence appropriate to its architectural responsibility.

### 4.1 Source Ingestion

Source ingestion observability must provide evidence that the platform is receiving the expected source data and that ingestion is progressing according to the configured processing model.

Relevant evidence may include:

- ingestion execution state;
- ingestion start and completion time;
- source processing scope;
- records or units of work received;
- records or units of work successfully ingested;
- failures encountered during ingestion;
- retries where applicable;
- source-to-ingestion latency;
- checkpoint or progress information exposed by the ingestion process.

The observability model must allow operators to distinguish between:

- no new source data being available;
- source connectivity or availability problems;
- ingestion not running;
- ingestion running but progressing slowly;
- ingestion failure;
- data successfully ingested but delayed downstream.

Source observability must not require unrestricted exposure of source data. Operational evidence remains subject to the platform security and governance model.

### 4.2 Kafka Transport

Kafka observability must provide evidence about the transport and consumption of events between producers and downstream consumers.

Relevant evidence may include:

- producer activity;
- message publication failures;
- topic and partition activity;
- consumer activity;
- consumer group state;
- consumer lag;
- offset progression;
- processing throughput;
- retry or repeated consumption behavior where applicable.

Consumer lag is an important operational signal but must not be interpreted in isolation.

Temporary lag may represent normal workload variation, recovery after interruption, or expected asynchronous processing. Sustained or growing lag may indicate insufficient processing throughput, stopped consumers, failures, or downstream constraints.

Kafka transport observability must therefore be correlated with downstream processing state and workload behavior.

### 4.3 Bronze Processing

Bronze observability must provide evidence that ingested source data is being durably captured according to the Bronze processing model.

Relevant evidence may include:

- Bronze execution state;
- processing scope;
- records received from transport;
- records persisted;
- processing duration;
- failures;
- retry or recovery activity;
- checkpoint progression;
- rejected or unprocessable records where applicable.

Operators must be able to determine whether data successfully reached Bronze and whether the expected processing scope was durably persisted.

Bronze observability must preserve enough context to support later replay, reprocessing, lineage investigation, and recovery without treating telemetry as the authoritative stored representation of source data.

### 4.4 Silver Processing

Silver observability must expose the behavior of validation, normalization, transformation, deduplication, and other processing responsibilities assigned to the Silver layer.

Relevant evidence may include:

- Silver execution state;
- input and output processing scope;
- records evaluated;
- records accepted;
- records rejected;
- records transformed;
- duplicate or otherwise excluded records where applicable;
- processing duration;
- validation failures;
- transformation failures;
- recovery activity.

The observability model must make data-level rejection distinguishable from execution-level failure.

A Silver process may complete successfully while rejecting records that do not satisfy the required contracts or quality rules. Those rejections must remain measurable and diagnosable without automatically classifying the entire execution as failed.

### 4.5 Gold Dimensional Processing

Gold observability must provide evidence that dimensional processing is progressing and producing the expected analytical structures.

Relevant evidence may include:

- Gold execution state;
- processing scope;
- dimensions processed;
- facts processed;
- input and output record counts;
- processing duration;
- transformation or loading failures;
- dependency state;
- recovery or rebuild activity.

Where Gold processing depends on previously completed or certified upstream state, observability must make those dependencies visible enough to distinguish an upstream readiness problem from a Gold processing failure.

Successful technical execution does not by itself establish that Gold data is ready for consumption. Certification remains a separate architectural responsibility.

### 4.6 Certification and Validation

Certification observability must expose whether the data required for downstream consumption has satisfied the defined validation and certification requirements.

Relevant evidence may include:

- certification execution state;
- processing scope being certified;
- validation checks executed;
- checks passed;
- checks failed;
- certification outcome;
- certification time;
- reasons for failed certification;
- relationship with the processing execution that produced the evaluated data.

The platform must distinguish between:

- processing completed and certification succeeded;
- processing completed but certification failed;
- processing completed but certification has not yet occurred;
- certification unable to execute because required upstream processing is incomplete.

This distinction prevents technical pipeline completion from being interpreted automatically as data readiness.

### 4.7 Orchestration and Scheduled Execution

Where processing is orchestrated or scheduled, observability must expose the operational state of those executions and their dependencies.

Relevant evidence may include:

- scheduled execution time;
- actual start time;
- completion time;
- execution status;
- dependency state;
- retry attempts;
- execution duration;
- missed or delayed execution;
- recovery execution where applicable.

Orchestration observability must support identifying whether processing failed inside a component or whether the component was never invoked because an upstream dependency, schedule, or orchestration condition prevented execution.

### 4.8 Downstream Availability

Observability must extend far enough to determine whether successfully processed and certified data became available to its intended downstream consumers.

The exact mechanism depends on the consuming architecture, but the platform must avoid assuming that successful Gold processing alone proves successful downstream availability.

Where applicable, operational evidence may include:

- publication or refresh completion;
- latest available certified processing scope;
- data freshness;
- downstream refresh failures;
- delay between certification and downstream availability.

This allows the platform to distinguish between successful data processing and successful delivery of usable analytical data.

### 4.9 End-to-End Processing Visibility

The combined observability model must make it possible to reconstruct the relevant progression of a processing scope across the platform.

For a given execution, batch, time window, or other applicable processing scope, operators should be able to determine, where supported:

1. whether source data was available;
2. whether ingestion occurred;
3. whether transport progressed;
4. whether Bronze persisted the data;
5. whether Silver processed and validated it;
6. whether Gold dimensional processing completed;
7. whether certification succeeded;
8. whether the certified result became available downstream.

The objective is not to create a single centralized state machine for every technology.

The objective is to preserve enough correlated evidence across architectural boundaries to determine where expected progress stopped, slowed, failed, or produced an invalid result.

---

## 5. Correlation and Traceability

End-to-end observability requires operational evidence produced by different components to remain correlatable.

The Atlas Engineering platform processes data through multiple technologies and architectural boundaries. A failure observed in one stage may originate from an earlier stage, affect a later stage, or occur during a recovery operation related to previous processing.

Correlation provides the contextual links required to reconstruct those relationships.

### 5.1 Correlation Context

Relevant operational evidence must carry enough context to identify the activity to which it belongs.

Depending on the component and processing model, correlation context may include:

- execution identifier;
- processing scope;
- source or domain;
- processing stage;
- component or service;
- topic and partition where applicable;
- offset or checkpoint information where applicable;
- batch, window, or equivalent processing boundary;
- recovery operation identifier where applicable;
- timestamps relevant to the observed activity.

Not every component requires every attribute.

The required context must reflect the architectural responsibility and processing semantics of the component producing the evidence.

### 5.2 Execution Identification

Where processing occurs as a distinct execution, that execution must be identifiable in operational evidence.

An execution identifier allows logs, metrics, state transitions, validation results, failures, and recovery activity associated with the same execution to be related during investigation.

Execution identifiers must identify operational activity rather than business entities.

A transaction identifier, customer identifier, product identifier, or similar business key must not be used as a substitute for an execution identifier merely for observability convenience.

### 5.3 Processing Scope

Correlation must identify not only which execution occurred but also what scope of data the execution intended to process.

Depending on the processing model, scope may represent:

- a source extraction boundary;
- a Kafka offset range;
- a time window;
- a batch;
- a partition;
- a dataset;
- a dimensional processing scope;
- another deterministic processing boundary defined by the architecture.

This distinction is important because an execution identifier answers **which execution**, while processing scope answers **which work or data that execution represented**.

### 5.4 Cross-Stage Correlation

Operational evidence must allow relevant activity to be related across processing stages.

Where supported by the processing architecture, investigation should be able to establish relationships such as:

source ingestion
→ Kafka transport
→ Bronze
→ Silver
→ Gold
→ certification
→ downstream availability.

This does not require a single identifier to be physically propagated unchanged through every technology.

Different components may use technology-specific identifiers, provided that sufficient contextual relationships exist to reconstruct the relevant processing path.

### 5.5 Time Correlation

Time is an important correlation dimension but must not be treated as the only correlation mechanism.

Operational evidence must use sufficiently consistent timestamps to support ordering and investigation across components.

Where different timestamps represent different meanings, those meanings must remain distinguishable.

Examples include:

- source event time;
- ingestion time;
- processing start time;
- processing completion time;
- persistence time;
- certification time;
- downstream availability time.

Using a single generic timestamp for semantically different events can make latency and failure analysis ambiguous.

### 5.6 Kafka Correlation

Kafka introduces transport-specific correlation information that may be relevant during investigation.

Depending on the processing context, useful information may include:

- topic;
- partition;
- offset;
- consumer group;
- producer or consumer execution context;
- event or message identifier where defined by the event contract.

Kafka-specific identifiers support transport investigation but do not replace higher-level processing context.

An offset can identify a position within a partition, for example, but does not independently describe the complete end-to-end processing state of the corresponding data.

### 5.7 Recovery Correlation

Recovery activity must remain related to the processing state or execution that caused the recovery to be required.

Replay, retry, reprocessing, backfill, rebuild, and backlog recovery must expose enough information to determine:

- which recovery operation occurred;
- which original processing scope it relates to;
- why recovery was initiated;
- what scope was repeated or reconstructed;
- whether multiple recovery attempts occurred;
- what outcome was produced.

A recovery execution must not become indistinguishable from normal first-time processing.

### 5.8 Failure Correlation

Failures must retain enough correlation context to determine their operational impact.

Where applicable, investigation must be able to associate a failure with:

- the affected component;
- the affected execution;
- the affected processing scope;
- the relevant upstream state;
- the expected downstream processing;
- retry or recovery activity;
- the eventual outcome.

This allows operators to distinguish an isolated failure from a failure that interrupted or invalidated a broader processing path.

### 5.9 Correlation and Lineage

Operational correlation and data lineage are related but distinct capabilities.

**Operational correlation** answers questions about processing activity, such as:

- Which execution processed this scope?
- Where did processing fail?
- Which recovery operation followed the failure?
- How long did the processing path take?

**Data lineage** answers questions about the origin and transformation of data, such as:

- Where did this data originate?
- Which processing stages transformed it?
- Which upstream datasets contributed to the resulting dataset?

Observability may use lineage information and lineage may use processing metadata, but neither capability replaces the other.

### 5.10 Correlation Is Not an Independent Source of Truth

Correlation metadata exists to connect operational evidence.

It must not become a competing authority for processing state, checkpoints, source data, certified data, or recovery state already owned by other architectural components.

If telemetry and authoritative processing state disagree, the discrepancy must be investigated rather than resolved by assuming that the observability representation is correct.

---

## 6. Metrics and Measurements

Metrics provide quantitative evidence about the behavior, progress, performance, and health of the Atlas Engineering platform.

The observability architecture must define measurements that help operators understand whether processing is occurring as expected and identify conditions that require investigation.

Metrics must represent meaningful platform behavior rather than being collected solely because a technology exposes them.

### 6.1 Processing Metrics

Processing metrics describe the amount of work performed by a component or processing stage.

Depending on the component, relevant measurements may include:

- records received;
- records processed;
- records persisted;
- records accepted;
- records rejected;
- records retried;
- records pending;
- processing throughput;
- executions started;
- executions completed;
- executions failed.

These measurements must preserve enough context to identify the component, processing stage, execution, or processing scope to which they apply.

Record counts from different stages must not be assumed to match automatically.

Validation, deduplication, filtering, transformation, aggregation, dimensional processing, and other legitimate processing behavior may change the number of records between stages.

### 6.2 Duration Metrics

The platform must measure the duration of relevant processing activity.

Depending on the processing model, this may include:

- execution duration;
- ingestion duration;
- Bronze processing duration;
- Silver processing duration;
- Gold processing duration;
- certification duration;
- recovery duration;
- downstream publication or refresh duration.

Duration measurements support comparison between executions and help identify changes in processing behavior.

An execution taking longer than a previous execution does not independently establish a performance problem. Processing scope, workload, resource availability, upstream behavior, and historical patterns must also be considered.

### 6.3 Throughput

Throughput describes the amount of work processed within a period of time.

It may be expressed using measurements such as:

- records per second;
- messages per second;
- batches per interval;
- processing scopes completed per interval;
- another unit appropriate to the component.

Throughput must be interpreted together with incoming workload and backlog.

High throughput does not necessarily indicate healthy processing if incoming work is accumulating faster than it can be processed.

Similarly, low throughput may be expected when little or no source activity exists.

### 6.4 Processing Latency

Processing latency measures the time required for data or work to progress through a defined processing boundary.

Latency may be measured for individual stages or across multiple stages where sufficient correlation information exists.

Examples include:

- source to ingestion;
- ingestion to Bronze persistence;
- Bronze to Silver completion;
- Silver to Gold completion;
- Gold completion to certification;
- certification to downstream availability;
- end-to-end source-to-availability latency.

The beginning and end of each latency measurement must be defined explicitly.

Without clear boundaries, latency values from different components or executions may represent different concepts and become misleading.

### 6.5 Data Freshness

Data freshness measures how current available data is relative to the relevant source or expected business timeline.

Freshness must remain distinguishable from processing duration.

A pipeline may execute quickly but process data that was already delayed before execution began.

Conversely, a long-running execution may still satisfy freshness expectations when the processing model and business requirements allow it.

Where freshness expectations are defined, observability must provide enough evidence to determine whether those expectations are being met.

### 6.6 Backlog and Consumer Lag

Asynchronous processing requires measurements that indicate whether work is accumulating.

Relevant measurements may include:

- pending work;
- backlog size;
- backlog age;
- Kafka consumer lag;
- rate of backlog growth or reduction;
- time required to recover accumulated work.

Backlog size alone is insufficient to determine operational severity.

A backlog that is large but rapidly decreasing may represent successful recovery, while a smaller backlog that continuously grows may indicate that processing cannot keep pace with incoming workload.

Backlog measurements must therefore be interpreted together with throughput, duration, workload, and processing state.

### 6.7 Error and Rejection Metrics

The platform must measure relevant operational failures and data-level rejections.

These measurements may include:

- failed executions;
- processing errors;
- retry attempts;
- exhausted retries;
- rejected records;
- validation failures;
- contract violations;
- poison-record occurrences where applicable;
- certification failures.

Absolute counts and rates may both be relevant.

For example, one hundred rejected records may represent a significant problem in a batch of one hundred and ten records but a very different condition in a processing scope containing several million records.

Metrics must therefore retain sufficient context for meaningful interpretation.

### 6.8 Recovery Metrics

Recovery operations must expose measurements that allow their behavior and effectiveness to be evaluated.

Relevant measurements may include:

- recovery operations started;
- recovery operations completed;
- recovery operations failed;
- recovery duration;
- records or processing scopes recovered;
- retry attempts;
- replayed scope;
- reprocessed scope;
- backlog reduction;
- time required to restore expected processing progress.

These measurements support both operational investigation and validation of the recovery behavior defined in **Reliability and Recovery**.

### 6.9 Resource Metrics

Infrastructure and component resource measurements may be collected where they provide useful operational context.

Depending on the technology and deployment model, these may include:

- CPU utilization;
- memory utilization;
- storage utilization;
- storage growth;
- network behavior;
- component-specific resource consumption.

Resource metrics must not automatically be interpreted as root cause.

High CPU utilization, for example, describes resource usage. Determining whether it represents healthy workload, insufficient capacity, inefficient processing, or another condition requires correlation with processing behavior and other evidence.

### 6.10 Baselines

Where useful, metrics should be evaluated against observed historical behavior rather than only against static limits.

A baseline provides context for understanding what is typical for a component, workload, processing scope, or period.

Baselines may help identify:

- unusual processing duration;
- unexpected throughput changes;
- abnormal backlog growth;
- changes in rejection rates;
- freshness degradation;
- resource behavior that differs from established patterns.

A baseline describes observed behavior. It does not automatically define acceptable behavior.

Business requirements, architectural expectations, service objectives, and known operational constraints remain necessary when determining whether a condition requires action.

### 6.11 Thresholds

Thresholds may be used to identify conditions that deserve operational attention.

Thresholds must be defined from meaningful operational or business expectations rather than selected arbitrarily.

Where appropriate, thresholds may be based on:

- explicit service objectives;
- freshness requirements;
- processing deadlines;
- capacity limits;
- established baseline behavior;
- sustained deviation from expected behavior;
- combinations of multiple signals.

Crossing a threshold does not necessarily establish root cause.

It indicates that the observed condition should be evaluated according to the operational context and alerting strategy.

### 6.12 Measurement Quality

Observability depends on the quality of its measurements.

Metrics must have sufficiently clear semantics to answer:

- what is being measured;
- where the measurement originates;
- what unit is used;
- what processing scope it represents;
- when it was measured;
- whether it is instantaneous, cumulative, or calculated over a period;
- whether it can reset or disappear;
- what limitations apply to its interpretation.

A metric whose meaning cannot be determined reliably may create more ambiguity than operational value.

---

## 7. Logs and Operational Events

Logs and operational events provide contextual evidence about the execution and behavior of Atlas Engineering components.

They complement metrics and durable processing state by describing relevant occurrences with enough detail to support investigation, correlation, recovery, and validation.

The objective is not to record every internal action performed by every component. Logging must capture information that contributes meaningful operational evidence.

### 7.1 Structured Logging

Where practical, operational logs should use structured fields rather than relying exclusively on free-form text.

Relevant fields may include:

- timestamp;
- severity;
- component;
- processing stage;
- execution identifier;
- processing scope;
- operation or event;
- outcome;
- correlation context;
- recovery context where applicable;
- error classification;
- error details appropriate for operational use.

Structured logging improves filtering, correlation, aggregation, and automated analysis while still allowing descriptive messages where additional human-readable context is useful.

The exact structure may vary between technologies, but common concepts should use consistent semantics across the platform.

### 7.2 Log Levels

Log severity must communicate the operational significance of an event rather than being selected arbitrarily by individual components.

The platform may use levels such as:

- **DEBUG** — detailed diagnostic information primarily useful during development or targeted investigation;
- **INFO** — expected operational activity and relevant lifecycle events;
- **WARN** — unexpected or degraded conditions that do not necessarily prevent processing;
- **ERROR** — failures that prevent an operation, execution, or processing scope from completing as expected;
- **FATAL** or equivalent — conditions where a component cannot continue operating, where supported by the technology.

Not every component must expose identical severity names, but equivalent meanings should remain understandable across the platform.

Excessive use of high-severity levels reduces their operational value.

### 7.3 Lifecycle Events

Relevant processing lifecycle transitions must produce observable evidence.

Depending on the component, these may include:

- execution started;
- execution completed;
- execution failed;
- processing scope identified;
- checkpoint advanced;
- validation completed;
- certification completed;
- retry initiated;
- retry exhausted;
- recovery initiated;
- recovery completed.

Lifecycle events allow operators to reconstruct the progression of an execution without requiring detailed internal logs for every processing action.

### 7.4 Failure Events

Failures must produce evidence sufficient to identify what failed and support subsequent investigation.

Where applicable, failure evidence should identify:

- timestamp;
- component;
- processing stage;
- execution;
- processing scope;
- failed operation;
- error classification;
- relevant error details;
- retry state;
- recovery state;
- correlation information.

Error information must preserve enough technical detail to support diagnosis without exposing sensitive data unnecessarily.

Failures must not be hidden only inside generic completion messages or represented exclusively by the absence of a success event.

### 7.5 Retry Events

Retries must remain observable.

When a failed operation is retried, operational evidence should make it possible to determine:

- which operation is being retried;
- which execution or processing scope is affected;
- why the retry occurred;
- which retry attempt is executing;
- whether the retry succeeded;
- whether retry attempts were exhausted.

Repeated retries without explicit visibility can make a component appear operational while processing is actually delayed or unable to progress.

### 7.6 Recovery Events

Replay, reprocessing, backfill, rebuild, and other recovery operations must produce explicit operational events.

Recovery evidence should identify, where applicable:

- recovery operation type;
- recovery identifier;
- initiating reason;
- original processing scope;
- recovered processing scope;
- start time;
- completion time;
- outcome;
- relationship with previous recovery attempts.

Recovery activity must not be represented as ordinary first-time processing when doing so would make operational interpretation ambiguous.

### 7.7 Data-Level Rejection Events

Individual record rejection must remain distinguishable from component or execution failure.

Where record-level evidence is required, logs or related operational mechanisms must provide enough information to understand:

- which validation or contract failed;
- which processing stage rejected the record;
- which execution or processing scope contained it;
- how the rejected record can be investigated through the appropriate controlled mechanism.

The observability architecture must avoid copying complete business records into logs merely to simplify troubleshooting.

Where detailed rejected data must be retained, it should be handled through an appropriate controlled data mechanism subject to security and governance requirements rather than unrestricted operational logging.

### 7.8 Sensitive Information

Logs must follow the security, privacy, and governance requirements of the platform.

Operational usefulness does not justify unrestricted logging of:

- credentials;
- secrets;
- access tokens;
- connection strings containing credentials;
- unnecessary personal data;
- sensitive business data;
- complete payloads when contextual identifiers are sufficient.

Where sensitive information is necessary for controlled investigation, access and retention must follow the appropriate governance model.

Masking, redaction, exclusion, or controlled references should be used where appropriate.

### 7.9 Log Volume

Logging must remain proportionate to operational value.

Excessive logging can:

- increase storage consumption;
- increase processing and transport cost;
- make relevant events harder to identify;
- create unnecessary security exposure;
- increase retention requirements;
- generate noise during investigation.

High-frequency processing paths should avoid producing repetitive informational events when aggregated metrics or summarized operational evidence provide sufficient visibility.

Detailed diagnostic logging may be enabled selectively when supported and operationally justified.

### 7.10 Log Retention

Operational logs must be retained for a period appropriate to their purpose, operational requirements, storage cost, security classification, and investigation needs.

Different categories of logs may require different retention periods.

Retention must consider whether the evidence is required for:

- immediate troubleshooting;
- historical comparison;
- recovery investigation;
- security investigation;
- auditability;
- laboratory validation;
- architectural evidence.

Retention periods must not be extended indefinitely merely because storage is technically available.

### 7.11 Log Availability During Failure

Observability evidence must remain useful when the component being investigated fails.

Where practical, critical operational evidence should not exist exclusively in transient local state that disappears when a process, container, service, or host terminates.

The architecture must consider how relevant logs and events remain accessible after the failure conditions they are intended to explain.

This requirement does not imply that every log entry requires independent durable storage. The required durability must be proportional to the operational importance of the evidence.

### 7.12 Logs Are Evidence, Not Authority

Logs describe what components reported during execution.

They are valuable evidence for reconstruction and diagnosis, but they do not replace authoritative processing state, checkpoints, source records, certified datasets, or recovery metadata.

A success message in a log does not override contradictory authoritative state.

Similarly, the absence of an expected log message does not independently prove that processing did not occur.

Operational conclusions must use logs together with the other evidence provided by the observability architecture.

---

## 8. Alerting and Operational Signals

Alerting converts selected observability signals into operational attention.

The objective of alerting is not to notify operators about every unusual event or metric variation. Alerts must identify conditions that may require investigation or action because they threaten processing progress, data availability, reliability, freshness, certification, recovery, or another defined operational expectation.

An alert that does not support a meaningful operational response creates noise rather than operational value.

### 8.1 Alerting Principles

Alerts must be based on conditions with clear operational significance.

Where practical, an alert should communicate:

- what condition was detected;
- which component or processing stage is affected;
- which execution or processing scope is involved;
- when the condition began or was detected;
- the severity of the condition;
- the evidence that triggered the alert;
- relevant correlation context;
- whether processing is still progressing;
- whether recovery is already occurring.

The alert itself does not need to contain every diagnostic detail, but it must provide enough context to begin investigation efficiently.

### 8.2 Actionable Alerts

Alerts should represent conditions for which an operator, automated recovery mechanism, or responsible team can reasonably determine a next step.

Examples may include:

- processing execution failed;
- expected processing did not start;
- processing exceeded an expected completion window;
- backlog continues to grow;
- consumer lag remains elevated beyond an acceptable period;
- data freshness exceeded an established expectation;
- certification failed;
- retries were exhausted;
- recovery failed;
- required downstream data did not become available;
- critical capacity approached an operational limit.

Conditions that are informational but do not require attention should remain available through metrics, logs, events, or dashboards without necessarily generating alerts.

### 8.3 Symptom and Cause

An alert may identify a symptom without identifying the root cause.

For example:

- growing Kafka consumer lag may indicate reduced downstream processing capacity;
- stale Gold data may result from an upstream ingestion problem;
- failed certification may result from unexpected source data rather than a failure of the certification mechanism;
- increased processing duration may reflect increased workload rather than degraded performance.

Alert descriptions must therefore avoid presenting inferred causes as established facts when the available evidence only identifies a condition.

Diagnosis remains an investigative activity based on correlated evidence.

### 8.4 Severity

Alert severity must represent operational impact and urgency rather than simply the magnitude of an individual metric.

Severity may consider factors such as:

- processing interruption;
- affected processing scope;
- duration;
- data freshness impact;
- downstream availability;
- recovery capability;
- certification state;
- continued backlog growth;
- business or analytical impact;
- risk of data loss or inability to meet recovery objectives.

The exact severity model may evolve with the operational maturity of the platform.

Severity definitions must remain sufficiently clear that different operators interpret equivalent conditions consistently.

### 8.5 Threshold-Based Alerts

Thresholds may trigger alerts when measurements cross defined operational boundaries.

Examples may include:

- backlog size;
- backlog age;
- consumer lag;
- processing duration;
- data freshness;
- storage utilization;
- error rate;
- rejection rate.

Thresholds must reflect meaningful operational expectations and must not be selected solely because a monitoring technology requires a numeric value.

Where appropriate, duration should be considered together with magnitude.

A temporary threshold crossing may represent normal workload variation, while a sustained condition may require investigation.

### 8.6 State-Based Alerts

Some operational conditions are better represented by state than by numeric thresholds.

Examples include:

- execution failed;
- certification failed;
- retry exhausted;
- expected execution missing;
- consumer stopped;
- recovery failed;
- required dependency unavailable.

State-based alerting must use sufficiently reliable evidence to avoid inferring failure solely from missing telemetry when authoritative processing or execution state is available.

### 8.7 Composite Signals

Where useful, alerts may combine multiple signals to improve operational relevance.

For example, growing consumer lag combined with reduced throughput and an active processing failure may provide a stronger operational signal than consumer lag alone.

Similarly, delayed data freshness combined with successful upstream processing may direct investigation toward downstream stages.

Composite alerting should reduce ambiguity and noise rather than create unnecessarily complex rules that operators cannot understand or validate.

### 8.8 Missing Activity

The absence of expected activity can itself be an important operational signal.

The platform may need to detect conditions such as:

- scheduled processing did not start;
- expected source data did not arrive;
- expected checkpoint progression stopped;
- certification did not occur;
- downstream refresh did not complete;
- expected telemetry stopped being produced.

Missing activity must be evaluated against explicit expectations.

The absence of events during a period in which no processing was expected must not be treated as a failure.

### 8.9 Alert Deduplication and Suppression

A single underlying problem may produce multiple related symptoms across the platform.

Where practical, alerting should avoid overwhelming operators with repeated notifications that represent the same continuing condition.

Mechanisms may include:

- deduplication;
- grouping;
- temporary suppression;
- dependency-aware alerting;
- state transition notifications;
- recovery notifications.

Suppression must not hide independent failures merely because they occur during an existing incident.

### 8.10 Alert Lifecycle

Operational alerts should have a meaningful lifecycle.

Where supported, it should be possible to distinguish between:

- newly detected condition;
- ongoing condition;
- acknowledged condition;
- recovering condition;
- resolved condition.

Resolution must be based on evidence that the relevant condition no longer exists rather than simply on the passage of time or manual dismissal.

Where recovery occurs automatically, the resulting operational evidence should make that recovery visible.

### 8.11 Alert Routing

Alerts must reach the team or operational responsibility capable of evaluating the condition.

Routing may depend on:

- component ownership;
- processing stage;
- severity;
- type of failure;
- security implications;
- recovery responsibility;
- business impact.

The detailed enterprise notification and escalation mechanism is deployment-specific and may evolve beyond the laboratory implementation.

The architecture defines the requirement for meaningful routing context without requiring the laboratory platform to reproduce a complete enterprise incident-management organization.

### 8.12 Alert Fatigue

Excessive, repetitive, or non-actionable alerts reduce the effectiveness of the observability system.

An alert that operators routinely ignore is evidence that the alerting strategy requires review.

Alert quality must therefore be evaluated over time using questions such as:

- Did the alert identify a condition that required attention?
- Was the severity appropriate?
- Was sufficient context available?
- Did multiple alerts represent the same underlying problem?
- Was the condition already recovering automatically?
- Did the alert lead to a meaningful investigation or action?

The objective is not to maximize the number of alerts generated.

The objective is to make important conditions difficult to miss.

### 8.13 Alerts Are Operational Signals

Alerts are derived operational signals.

They do not replace logs, metrics, processing state, checkpoints, certification state, or other authoritative evidence.

An alert indicates that a defined condition was detected.

Operators must use the underlying evidence and architectural context to determine the cause, impact, and appropriate response.

---

## 9. Dashboards and Operational Views

Dashboards and operational views provide consolidated representations of the observability evidence produced by the Atlas Engineering platform.

Their purpose is to help operators understand platform health, processing progress, failures, freshness, backlog, recovery activity, and other relevant operational conditions without requiring every investigation to begin directly from raw logs or individual metrics.

Dashboards summarize evidence. They do not replace the underlying observability data or authoritative processing state.

### 9.1 Operational Overview

The platform should provide an operational overview that communicates the current state of the major processing stages.

Where applicable, the overview may include:

- source ingestion state;
- Kafka transport and consumer state;
- Bronze processing state;
- Silver processing state;
- Gold processing state;
- certification state;
- downstream availability;
- active failures;
- active recovery operations;
- data freshness;
- significant backlog or lag conditions.

The objective is to provide a concise answer to the initial operational question:

**Is the platform processing data as expected?**

The overview should emphasize conditions requiring attention rather than presenting every available measurement with equal importance.

### 9.2 Processing Progress Views

Operational views should make processing progress visible across the major architectural boundaries.

Where supported, operators should be able to determine:

- what processing is currently active;
- what processing has completed;
- what processing is pending;
- what processing failed;
- what scope is affected;
- where progress stopped;
- whether recovery is occurring.

These views should preserve the processing boundaries defined by the architecture rather than collapsing the entire platform into a single generic status.

### 9.3 Freshness and Latency Views

Data freshness and processing latency must be visible enough to identify whether data is becoming available within expected timeframes.

Relevant views may include:

- latest source activity;
- latest successfully ingested scope;
- latest Bronze processing;
- latest Silver processing;
- latest Gold processing;
- latest successful certification;
- latest downstream availability;
- stage-specific latency;
- end-to-end latency where measurable.

A technically successful pipeline whose available data is unexpectedly stale must remain visible as an operational concern.

### 9.4 Backlog and Lag Views

Where asynchronous processing exists, dashboards should expose the accumulation and reduction of pending work.

Relevant information may include:

- current backlog;
- backlog age;
- Kafka consumer lag;
- backlog growth or reduction;
- processing throughput;
- estimated or observed recovery progress where meaningful.

Trend information is particularly important.

A point-in-time backlog value may provide limited context, while its evolution over time can show whether the platform is stable, falling behind, or recovering.

### 9.5 Failure Views

Operational views must make active and recent failures discoverable.

Relevant information may include:

- affected component;
- processing stage;
- execution;
- processing scope;
- failure time;
- error classification;
- retry state;
- recovery state;
- current outcome.

The dashboard does not need to reproduce complete diagnostic logs.

It should provide enough context to identify the affected activity and allow investigation to continue using the appropriate detailed evidence.

### 9.6 Data Quality and Certification Views

Observability must provide visibility into validation and certification outcomes where they affect downstream data readiness.

Relevant information may include:

- certification status;
- latest certified processing scope;
- failed validation checks;
- rejected record counts or rates;
- certification failures;
- pending certification;
- relationship between processing completion and certification state.

Data quality information must be presented with sufficient context to distinguish isolated record-level rejection from broader certification failure.

### 9.7 Recovery Views

Recovery operations must be visible in operational views.

Where applicable, operators should be able to identify:

- active recovery operations;
- recovery type;
- affected processing scope;
- initiating reason;
- start time;
- progress;
- retry or recovery attempt;
- completion state;
- recovery outcome.

A platform performing replay, reprocessing, backfill, rebuild, or backlog recovery must not appear indistinguishable from ordinary first-time processing.

### 9.8 Historical Views

Where retained evidence allows it, operational views should support comparison with historical behavior.

Historical views may help identify:

- changes in processing duration;
- throughput patterns;
- recurring failures;
- rejection trends;
- freshness degradation;
- backlog behavior;
- recovery duration;
- resource consumption patterns.

Historical information supports baseline analysis and investigation of gradual changes that may not be apparent from current-state monitoring alone.

### 9.9 Drill-Down

Operational views should support progressive investigation.

An operator may begin with a high-level indication that a processing stage is degraded and then move toward more detailed evidence such as:

1. affected processing stage;
2. affected execution or scope;
3. related metrics;
4. relevant operational events;
5. error or rejection information;
6. correlation context;
7. recovery activity;
8. detailed logs where required.

The objective is to allow investigation to move from summary to evidence without requiring the initial dashboard to contain every diagnostic detail.

### 9.10 Audience and Purpose

Different operational views may serve different audiences and purposes.

For example:

- platform operators may require detailed execution and failure information;
- data engineers may require processing, backlog, and transformation evidence;
- data consumers may require freshness and certification status;
- architectural validation may require historical execution and recovery evidence.

Not every audience requires access to every operational detail.

Dashboard design and access must remain consistent with the security and governance model of the platform.

### 9.11 Dashboard Status Must Have Defined Semantics

Visual states such as healthy, degraded, failed, delayed, recovering, or unavailable must have defined meanings.

A dashboard must not display a component as healthy merely because its process is running if:

- processing is no longer progressing;
- backlog is growing beyond expectations;
- required data is stale;
- certification has failed;
- downstream availability has not been achieved.

Similarly, a recovery operation may represent expected controlled behavior rather than a new failure.

Status must therefore reflect relevant operational expectations rather than component availability alone.

### 9.12 Dashboards Are Navigation, Not Diagnosis

A dashboard is an entry point into operational understanding.

It should help answer:

- Where should I look?
- What changed?
- What scope is affected?
- How severe does the condition appear?
- Is processing progressing or recovering?
- What evidence should I investigate next?

A dashboard should not create false confidence by reducing complex platform behavior to a single visual indicator without accessible supporting evidence.

Operational diagnosis remains based on correlated logs, metrics, events, execution state, processing context, and other authoritative evidence.

---

## 10. Observability of Recovery Operations

Recovery operations must be observable throughout their lifecycle.

The recovery semantics themselves are defined by **Reliability and Recovery**. The responsibility of observability is to expose sufficient evidence to determine when recovery is required, what operation is being performed, which processing scope is affected, how recovery is progressing, and whether the expected state was restored.

Recovery must not become a blind period in which normal processing visibility is lost.

### 10.1 Recovery Identification

Each relevant recovery operation must be identifiable in operational evidence.

Where applicable, recovery context should include:

- recovery operation identifier;
- recovery type;
- initiating reason;
- affected component or processing stage;
- original execution or processing scope;
- recovery processing scope;
- start time;
- current state;
- completion time;
- outcome.

This context must allow recovery activity to remain distinguishable from normal first-time processing.

### 10.2 Recovery Types

Observability must preserve the distinction between different recovery mechanisms defined by the platform.

These may include:

- retry;
- replay;
- reprocessing;
- backfill;
- rebuild;
- backlog recovery;
- other controlled recovery procedures defined by the architecture.

Different recovery mechanisms may produce similar processing activity while having different purposes, scopes, and operational implications.

Operational evidence must therefore identify the type of recovery being performed.

### 10.3 Recovery Trigger

Where determinable, observability must expose why a recovery operation was initiated.

Examples may include:

- transient processing failure;
- exhausted or repeated retry;
- component interruption;
- backlog accumulated during downtime;
- data quality correction;
- corrected processing logic;
- incomplete historical processing;
- controlled rebuild;
- operator-initiated recovery.

The initiating reason provides context for interpreting the recovery operation but does not replace the authoritative recovery decision or state.

### 10.4 Recovery Scope

Recovery evidence must identify the scope being recovered.

Depending on the processing model, this may include:

- execution;
- batch;
- time window;
- Kafka offset range;
- partition;
- dataset;
- dimensional processing scope;
- historical period;
- another deterministic recovery boundary.

Recovery scope must be sufficiently explicit to determine what work is intentionally being repeated, reconstructed, or completed.

### 10.5 Recovery Progress

Operators must be able to determine whether recovery is progressing.

Relevant evidence may include:

- recovery state;
- processing scope completed;
- processing scope remaining;
- records or units of work processed;
- backlog reduction;
- throughput;
- duration;
- retry attempts;
- checkpoint progression where applicable.

Progress information is particularly important during large replay, backfill, rebuild, or backlog-recovery operations that may remain active for extended periods.

A running recovery process that is no longer making progress must not appear healthy merely because the process itself remains active.

### 10.6 Recovery and New Processing

Where recovery and newly arriving processing occur concurrently, observability must make their behavior distinguishable.

Operators should be able to determine whether:

- new processing continues normally;
- recovery competes with normal processing for capacity;
- backlog is increasing or decreasing;
- recovery is delaying current data;
- recovery has priority over new processing;
- processing is intentionally paused according to the recovery procedure.

The observability architecture does not define scheduling or prioritization semantics. It exposes enough evidence to evaluate their operational effects.

### 10.7 Recovery Failures

A recovery operation may itself fail.

Recovery failures must produce explicit evidence that identifies:

- the recovery operation;
- affected scope;
- failed stage or operation;
- error information;
- attempt or retry state;
- remaining incomplete scope;
- resulting processing state.

A failed recovery must not be interpreted as successful merely because part of the intended scope was processed.

### 10.8 Recovery Completion

Recovery completion must be based on evidence that the intended recovery scope reached the expected state.

The end of a recovery process or job does not independently prove successful recovery.

Where applicable, completion evidence may include:

- recovery execution completed successfully;
- intended processing scope completed;
- checkpoints reached the expected state;
- backlog returned to the expected condition;
- downstream processing resumed;
- validation completed;
- certification succeeded;
- expected data became available.

The required completion evidence depends on the recovery mechanism and affected architectural boundary.

### 10.9 Post-Recovery Validation

Recovery must be followed by sufficient validation to determine whether the platform returned to an acceptable state.

Relevant questions may include:

- Was the intended scope recovered?
- Did processing resume from the correct position?
- Were duplicates or unintended omissions introduced?
- Did downstream stages process the recovered data?
- Did certification succeed?
- Is data freshness recovering or restored?
- Is backlog continuing to decrease?
- Are new failures occurring?

Observability provides the evidence required to answer these questions.

The validation rules themselves may be defined by the processing, reliability, data quality, or testing architecture.

### 10.10 Recovery Duration and Objectives

Recovery duration must be measurable where it contributes to evaluating the recovery objectives defined by the platform.

Observability should provide enough timing evidence to compare actual recovery behavior with relevant Recovery Time Objective (RTO) expectations where those expectations apply.

Similarly, evidence related to the recovered processing scope may contribute to evaluating Recovery Point Objective (RPO) behavior.

Observability measures and exposes the outcome.

The definition of RPO, RTO, recovery guarantees, and their architectural limitations remains the responsibility of **Reliability and Recovery**.

### 10.11 Recovery History

Relevant recovery evidence should be retained long enough to support:

- investigation;
- comparison between recovery events;
- recurring failure analysis;
- recovery performance analysis;
- validation of recovery procedures;
- laboratory resilience testing;
- architectural evidence.

Historical recovery information can reveal patterns that are difficult to identify from individual incidents, such as repeated recovery of the same processing stage or progressively increasing recovery duration.

### 10.12 Recovery Evidence

Recovery observability must support demonstrating that recovery mechanisms behave as designed.

Laboratory scenarios may intentionally introduce controlled failures and use retained observability evidence to demonstrate:

- failure detection;
- recovery initiation;
- correct recovery scope;
- recovery progression;
- successful completion;
- post-recovery validation;
- restoration of expected processing behavior.

This evidence connects the operational observability architecture with the resilience testing strategy of the platform.

Observability does not prove resilience merely because recovery telemetry exists.

Resilience is demonstrated when controlled tests, authoritative state, resulting data, and observability evidence together show that the expected recovery behavior occurred.

---

## 11. Retention, Evidence, and Validation

Observability information must remain available for a period appropriate to its operational, investigative, validation, security, and architectural purpose.

Not all telemetry requires the same retention period or durability.

The platform must preserve enough historical evidence to investigate relevant events, understand processing behavior over time, validate recovery and failure scenarios, and demonstrate that architectural guarantees behave as designed.

Retention must remain proportionate to the value, sensitivity, volume, and cost of the information being preserved.

### 11.1 Retention Categories

Different categories of observability information may require different retention strategies.

These categories may include:

- operational logs;
- structured events;
- metrics;
- execution history;
- alert history;
- failure evidence;
- rejection evidence;
- recovery history;
- certification results;
- validation evidence;
- infrastructure and resource measurements.

Retention requirements must reflect the purpose of each category rather than applying a single retention period to all observability data.

### 11.2 Operational Retention

Operational evidence must remain available long enough to support routine investigation and troubleshooting.

The required period depends on factors such as:

- processing frequency;
- failure detection delay;
- operational support practices;
- workload behavior;
- expected investigation window;
- storage volume;
- operational cost.

Evidence that disappears before an operational problem is normally investigated provides limited diagnostic value.

### 11.3 Historical Retention

Selected observability information may require longer retention to support historical analysis.

Historical evidence may be useful for:

- baseline development;
- trend analysis;
- recurring failure identification;
- capacity analysis;
- processing-duration comparison;
- freshness analysis;
- rejection-rate analysis;
- backlog behavior;
- recovery performance;
- architectural evolution.

Historical retention should focus on information that remains meaningful over time rather than preserving every available diagnostic detail indefinitely.

### 11.4 Evidence Retention

Evidence produced specifically to validate architectural behavior may have different retention requirements from routine operational telemetry.

Examples may include evidence demonstrating:

- successful processing;
- controlled failure behavior;
- failure isolation;
- checkpoint behavior;
- replay;
- reprocessing;
- backfill;
- rebuild;
- backlog recovery;
- certification;
- observability behavior itself.

Such evidence may be retained as part of laboratory validation artifacts even when the underlying high-volume telemetry is retained for a shorter period.

### 11.5 Evidence Must Be Reproducible

Architectural claims should be supported, where practical, by repeatable validation scenarios rather than isolated screenshots or manually selected observations.

Evidence should preserve enough context to understand:

- what scenario was executed;
- what behavior was expected;
- what conditions were introduced;
- what processing scope was involved;
- what observations were collected;
- what resulting state was produced;
- whether the expected behavior was demonstrated.

A screenshot may contribute to evidence, but visual output alone should not be treated as sufficient proof when the underlying state can be validated more directly.

### 11.6 Evidence Must Be Correlated

Validation evidence must be connected to the execution or scenario that produced it.

Where applicable, retained evidence should preserve:

- scenario or test identification;
- execution identifiers;
- processing scope;
- relevant timestamps;
- observed events;
- relevant metrics;
- failure information;
- recovery information;
- validation results;
- resulting authoritative state.

This allows evidence from different components to be evaluated as part of the same architectural scenario.

### 11.7 Observability Validation

The observability architecture itself must be tested.

It is not sufficient to verify only that processing and recovery mechanisms work.

Controlled validation should determine whether relevant operational evidence is produced when expected.

Examples include verifying that:

- execution start and completion are observable;
- failures produce explicit evidence;
- retries can be distinguished;
- recovery activity is identifiable;
- processing scope can be correlated;
- backlog and lag become visible;
- freshness degradation can be detected;
- certification failure is distinguishable from processing failure;
- relevant alerts are generated;
- resolution becomes visible after recovery.

An observability mechanism that works only during normal processing but fails to provide evidence during the failure conditions it is intended to diagnose does not satisfy its architectural purpose.

### 11.8 Failure Injection and Controlled Scenarios

Where safe and practical in the laboratory environment, controlled failures should be introduced to validate observability behavior.

Scenarios may include:

- interrupting a processing component;
- temporarily stopping a consumer;
- introducing controlled processing failures;
- producing invalid records;
- delaying downstream processing;
- creating backlog;
- forcing retry behavior;
- initiating replay or reprocessing;
- executing controlled backfill or rebuild scenarios.

The purpose of failure injection is not to simulate every possible enterprise incident.

It is to demonstrate that representative failure and recovery conditions produce the expected observable evidence.

### 11.9 Expected Evidence

Validation scenarios should define expected evidence before execution where practical.

For example, a controlled consumer interruption may be expected to produce:

1. reduced or stopped consumption;
2. increasing consumer lag;
3. visible processing delay;
4. an operational signal if the defined alert condition is reached;
5. resumed consumption after restoration;
6. decreasing backlog;
7. eventual restoration of expected freshness.

Defining expected evidence before the test reduces the risk of interpreting any observed telemetry after the fact as proof that the architecture behaved correctly.

### 11.10 Evidence Completeness

No single telemetry source should be assumed to provide complete architectural evidence.

Depending on the scenario, validation may require combining:

- authoritative processing state;
- logs;
- operational events;
- metrics;
- checkpoints;
- Kafka offsets or lag;
- persisted data;
- certification results;
- recovery metadata;
- downstream state.

Observability contributes evidence to the validation process but does not replace direct validation of the resulting platform state.

### 11.11 Retention and Security

Retained observability information remains subject to the platform security and governance model.

Retention must consider:

- sensitivity;
- access control;
- personal or business data exposure;
- audit requirements;
- deletion requirements;
- storage location;
- retention period;
- secure disposal.

Observability data must not become an uncontrolled secondary repository of sensitive source information.

Longer retention increases both analytical value and governance responsibility.

### 11.12 Retention and Cost

Observability retention consumes storage and may introduce additional processing, transport, indexing, and operational cost.

The architecture must balance:

- diagnostic value;
- historical value;
- validation requirements;
- security requirements;
- storage volume;
- processing cost;
- operational complexity.

High-volume detailed telemetry may be retained for shorter periods while summarized measurements or selected validation evidence remain available longer.

The exact retention periods are deployment decisions and may evolve as the platform workload and operational requirements become measurable.

### 11.13 Evidence as an Architectural Deliverable

For Atlas Engineering, selected observability evidence is part of the architectural validation of the platform.

Where the project claims that a relevant behavior has been implemented and validated, the supporting laboratory evidence should be preserved in a form that can be reviewed.

The objective is to distinguish between:

**designed behavior** — what the architecture says should happen;

**implemented behavior** — what the platform is capable of executing;

**validated behavior** — what controlled testing and resulting evidence demonstrate actually happened.

Observability provides an important part of the evidence connecting these three levels.

---

## 12. Architectural Boundaries and Closing Principles

Observability is a cross-cutting architectural capability of the Atlas Engineering platform.

It provides the operational evidence required to understand processing behavior, identify failures and delays, investigate unexpected conditions, observe recovery activity, evaluate data freshness, and validate whether relevant architectural behaviors operate as designed.

Observability does not replace the responsibilities of the processing, reliability, security, governance, or data quality architecture.

### 12.1 Processing Boundary

**Data Flow and Processing** defines how data moves and is transformed across the platform.

Observability exposes evidence about that behavior.

It may show:

- whether processing started;
- whether processing progressed;
- how long processing took;
- what scope was processed;
- where processing stopped;
- what outcome was observed.

It does not independently define processing order, transformation semantics, checkpoint behavior, or authoritative processing state.

### 12.2 Reliability and Recovery Boundary

**Reliability and Recovery** defines failure semantics, durable state, checkpoints, replay, reprocessing, backfill, rebuild, backlog recovery, and the recovery guarantees of the platform.

Observability makes those behaviors visible and measurable.

It provides evidence that supports questions such as:

- Was the failure detected?
- What processing scope was affected?
- Was recovery initiated?
- How did recovery progress?
- Did processing resume?
- Was the expected state restored?

Observability does not itself provide the recovery guarantee.

### 12.3 Security and Governance Boundary

**Security and Governance** defines the controls governing identity, access, secrets, sensitive information, retention, auditability, privacy, and related governance responsibilities.

Observability operates within those controls.

Logs, metrics, events, dashboards, retained evidence, and other telemetry must not bypass security or governance requirements merely because they are operational artifacts.

Observability data is itself governed data.

### 12.4 Testing and Evidence Boundary

Observability provides important evidence for architectural testing and validation.

The testing and evidence strategy defines how scenarios are designed, executed, evaluated, and preserved as proof of implemented behavior.

Observability contributes:

- execution evidence;
- failure evidence;
- recovery evidence;
- measurements;
- correlated operational events;
- historical behavior;
- alert and resolution evidence.

It does not independently determine whether an architectural test has passed.

Validation must consider the expected behavior, resulting authoritative state, resulting data, and the relevant supporting evidence together.

### 12.5 Technology Boundary

The observability architecture defines required capabilities and semantics rather than depending on a single monitoring product or implementation technology.

Different components may expose operational evidence through different mechanisms.

The implementation may evolve as the platform introduces or changes technologies, provided that the architectural requirements defined in this document remain satisfied.

A technology is therefore selected to implement observability responsibilities.

The architecture is not defined by the technology selected.

### 12.6 Laboratory and Enterprise Boundary

Atlas Engineering is a laboratory and portfolio platform designed to demonstrate production-oriented architectural principles.

The laboratory implementation must provide enough observability to validate the behaviors implemented by the project.

It is not required to reproduce every capability of a large enterprise observability environment.

Enterprise deployments may additionally require capabilities such as:

- centralized telemetry platforms;
- distributed tracing infrastructure;
- enterprise incident management;
- on-call escalation;
- service-level management;
- long-term telemetry retention;
- advanced anomaly detection;
- integration with security operations;
- organization-wide operational governance.

These capabilities may extend the implementation without changing the fundamental observability principles defined here.

### 12.7 Closing Principles

The Atlas Engineering observability architecture is governed by the following closing principles:

1. **Observable behavior must be designed, not assumed.**
2. **Operational evidence must support investigation, not merely indicate activity.**
3. **Metrics require context before they support conclusions.**
4. **Failures must be explicit and correlatable.**
5. **Processing progress must remain visible across architectural boundaries.**
6. **Data freshness is part of operational health.**
7. **Recovery must be observable from initiation through validated completion.**
8. **Alerts must represent meaningful operational conditions rather than maximize notification volume.**
9. **Dashboards summarize and navigate evidence; they do not replace diagnosis.**
10. **Telemetry must remain proportionate, secure, governed, and sufficiently durable for its purpose.**
11. **Observability evidence supports validation but does not replace authoritative state or resulting data.**
12. **Architectural claims should be supported by repeatable evidence wherever practical.**

The objective of observability in Atlas Engineering is therefore not simply to answer:

**“Is the platform running?”**

It is to provide enough reliable evidence to answer:

**“Is the platform processing the expected data, at the expected stage, with the expected outcome — and, when it is not, can we determine what happened and verify that recovery restored the expected state?”**