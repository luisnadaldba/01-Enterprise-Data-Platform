# Atlas Engineering — Security and Governance

## Table of Contents

[1. Purpose](#1-purpose)

[2. Security and Governance Context](#2-security-and-governance-context)

[3. Security Principles](#3-security-principles)
   - [3.1 Security by Design](#31-security-by-design)
   - [3.2 Deny by Default](#32-deny-by-default)
   - [3.3 Least Privilege](#33-least-privilege)
   - [3.4 Separation of Duties](#34-separation-of-duties)
   - [3.5 Explicit Trust Boundaries](#35-explicit-trust-boundaries)
   - [3.6 Defense in Depth](#36-defense-in-depth)
   - [3.7 Data Minimization](#37-data-minimization)
   - [3.8 Purpose-Limited Access](#38-purpose-limited-access)
   - [3.9 Secure Credential Handling](#39-secure-credential-handling)
   - [3.10 Encryption According to Risk and Boundary](#310-encryption-according-to-risk-and-boundary)
   - [3.11 Auditable Security Actions](#311-auditable-security-actions)
   - [3.12 Secure Failure and Recovery](#312-secure-failure-and-recovery)
   - [3.13 Security Controls Must Be Testable](#313-security-controls-must-be-testable)
   - [3.14 Security Claims Must Match Evidence](#314-security-claims-must-match-evidence)
   - [3.15 Security Must Evolve Without Breaking Architectural Boundaries](#315-security-must-evolve-without-breaking-architectural-boundaries)

[4. Identity and Access Management](#4-identity-and-access-management)
   - [4.1 Identity Types](#41-identity-types)
   - [4.2 Human Identities](#42-human-identities)
   - [4.3 Service Identities](#43-service-identities)
   - [4.4 Service Identity Separation](#44-service-identity-separation)
   - [4.5 Administrative Identities](#45-administrative-identities)
   - [4.6 Shared Accounts](#46-shared-accounts)
   - [4.7 Role-Based Access](#47-role-based-access)
   - [4.8 Access Scope](#48-access-scope)
   - [4.9 Layer-Based Access Boundaries](#49-layer-based-access-boundaries)
   - [4.10 Access Lifecycle](#410-access-lifecycle)
   - [4.11 Access Review](#411-access-review)
   - [4.12 Privilege Escalation](#412-privilege-escalation)
   - [4.13 Authentication Failure and Access Denial](#413-authentication-failure-and-access-denial)
   - [4.14 Identity and Access Metadata](#414-identity-and-access-metadata)
   - [4.15 Laboratory Identity Model](#415-laboratory-identity-model)
   - [4.16 Enterprise Evolution](#416-enterprise-evolution)
   - [4.17 Identity and Access Guarantees](#417-identity-and-access-guarantees)

[5. Authentication and Authorization](#5-authentication-and-authorization)
   - [5.1 Authentication](#51-authentication)
   - [5.2 Human Authentication](#52-human-authentication)
   - [5.3 Service Authentication](#53-service-authentication)
   - [5.4 Authentication Across Service Boundaries](#54-authentication-across-service-boundaries)
   - [5.5 Authorization](#55-authorization)
   - [5.6 Authentication Does Not Imply Authorization](#56-authentication-does-not-imply-authorization)
   - [5.7 Resource-Level Authorization](#57-resource-level-authorization)
   - [5.8 Read and Write Separation](#58-read-and-write-separation)
   - [5.9 Administrative Authorization](#59-administrative-authorization)
   - [5.10 Authorization at the Certified Gold Boundary](#510-authorization-at-the-certified-gold-boundary)
   - [5.11 Authorization and Sensitive Data](#511-authorization-and-sensitive-data)
   - [5.12 Authentication and Authorization Failures](#512-authentication-and-authorization-failures)
   - [5.13 Credential Rotation and Authentication Continuity](#513-credential-rotation-and-authentication-continuity)
   - [5.14 Revocation](#514-revocation)
   - [5.15 Authentication and Authorization Testing](#515-authentication-and-authorization-testing)
   - [5.16 Authentication and Authorization Evidence](#516-authentication-and-authorization-evidence)
   - [5.17 Laboratory and Enterprise Authentication](#517-laboratory-and-enterprise-authentication)
   - [5.18 Authentication and Authorization Guarantees](#518-authentication-and-authorization-guarantees)

[6. Secrets and Credential Management](#6-secrets-and-credential-management)
   - [6.1 Secret Classification](#61-secret-classification)
   - [6.2 Secrets Must Not Be Committed](#62-secrets-must-not-be-committed)
   - [6.3 Secret References](#63-secret-references)
   - [6.4 Environment Variables](#64-environment-variables)
   - [6.5 Secret Storage](#65-secret-storage)
   - [6.6 Service-Specific Credentials](#66-service-specific-credentials)
   - [6.7 Credential Scope](#67-credential-scope)
   - [6.8 Credential Rotation](#68-credential-rotation)
   - [6.9 Credential Revocation](#69-credential-revocation)
   - [6.10 Secret Exposure](#610-secret-exposure)
   - [6.11 Source-Control Exposure](#611-source-control-exposure)
   - [6.12 Secrets in Logs and Observability](#612-secrets-in-logs-and-observability)
   - [6.13 Secrets in Evidence](#613-secrets-in-evidence)
   - [6.14 Secrets in Documentation and Examples](#614-secrets-in-documentation-and-examples)
   - [6.15 Backup and Recovery of Secrets](#615-backup-and-recovery-of-secrets)
   - [6.16 Secret Recovery and Invalidated Trust](#616-secret-recovery-and-invalidated-trust)
   - [6.17 Secret Ownership](#617-secret-ownership)
   - [6.18 Secret Inventory and Metadata](#618-secret-inventory-and-metadata)
   - [6.19 Secret Lifecycle](#619-secret-lifecycle)
   - [6.20 Laboratory Secret Management](#620-laboratory-secret-management)
   - [6.21 Enterprise Evolution](#621-enterprise-evolution)
   - [6.22 Secret Scanning](#622-secret-scanning)
   - [6.23 Secrets and Credential Testing](#623-secrets-and-credential-testing)
   - [6.24 Secrets and Credential Evidence](#624-secrets-and-credential-evidence)
   - [6.25 Secrets and Credential Guarantees](#625-secrets-and-credential-guarantees)

[7. Network and Service Communication Security](#7-network-and-service-communication-security)
   - [7.1 Network Exposure](#71-network-exposure)
   - [7.2 Service Communication Paths](#72-service-communication-paths)
   - [7.3 Explicit Trust Boundaries](#73-explicit-trust-boundaries)
   - [7.4 Network Segmentation](#74-network-segmentation)
   - [7.5 East-West and North-South Communication](#75-east-west-and-north-south-communication)
   - [7.6 Public Exposure](#76-public-exposure)
   - [7.7 Administrative Interfaces](#77-administrative-interfaces)
   - [7.8 Encryption in Transit](#78-encryption-in-transit)
   - [7.9 TLS and Certificate Trust](#79-tls-and-certificate-trust)
   - [7.10 Mutual Authentication](#710-mutual-authentication)
   - [7.11 Credential Protection During Transport](#711-credential-protection-during-transport)
   - [7.12 DNS, Hostnames, and Endpoint Configuration](#712-dns-hostnames-and-endpoint-configuration)
   - [7.13 Orchestration Communication](#713-orchestration-communication)
   - [7.14 Observability Communication](#714-observability-communication)
   - [7.15 Analytical Consumer Communication](#715-analytical-consumer-communication)
   - [7.16 Network Failure Behavior](#716-network-failure-behavior)
   - [7.17 Network and Communication Observability](#717-network-and-communication-observability)
   - [7.18 Communication Inventory](#718-communication-inventory)
   - [7.19 Network Change Governance](#719-network-change-governance)
   - [7.20 Laboratory Network Model](#720-laboratory-network-model)
   - [7.21 Enterprise Evolution](#721-enterprise-evolution)
   - [7.22 Network and Communication Testing](#722-network-and-communication-testing)
   - [7.23 Network and Communication Evidence](#723-network-and-communication-evidence)
   - [7.24 Network and Service Communication Guarantees](#724-network-and-service-communication-guarantees)

[8. Data Protection and Encryption](#8-data-protection-and-encryption)
   - [8.1 Data Protection Scope](#81-data-protection-scope)
   - [8.2 Protection According to Data Classification](#82-protection-according-to-data-classification)
   - [8.3 Encryption in Transit](#83-encryption-in-transit)
   - [8.4 Encryption at Rest](#84-encryption-at-rest)
   - [8.5 Encryption Does Not Replace Authorization](#85-encryption-does-not-replace-authorization)
   - [8.6 Encryption Does Not Replace Data Minimization](#86-encryption-does-not-replace-data-minimization)
   - [8.7 Source Data Protection](#87-source-data-protection)
   - [8.8 Event and Kafka Data Protection](#88-event-and-kafka-data-protection)
   - [8.9 Bronze Data Protection](#89-bronze-data-protection)
   - [8.10 Silver Data Protection](#810-silver-data-protection)
   - [8.11 Gold Data Protection](#811-gold-data-protection)
   - [8.12 Certified Gold Protection](#812-certified-gold-protection)
   - [8.13 Temporary Data](#813-temporary-data)
   - [8.14 Quarantine Data](#814-quarantine-data)
   - [8.15 Backup Protection](#815-backup-protection)
   - [8.16 Encryption Key Management](#816-encryption-key-management)
   - [8.17 Key Rotation](#817-key-rotation)
   - [8.18 Key Recovery](#818-key-recovery)
   - [8.19 Key Compromise](#819-key-compromise)
   - [8.20 Logs and Sensitive Data](#820-logs-and-sensitive-data)
   - [8.21 Metrics and Sensitive Data](#821-metrics-and-sensitive-data)
   - [8.22 Evidence and Sensitive Data](#822-evidence-and-sensitive-data)
   - [8.23 Non-Production Data](#823-non-production-data)
   - [8.24 Data Export](#824-data-export)
   - [8.25 Data Protection During Recovery](#825-data-protection-during-recovery)
   - [8.26 Data Protection and Retention](#826-data-protection-and-retention)
   - [8.27 Secure Disposal](#827-secure-disposal)
   - [8.28 Laboratory Data Protection](#828-laboratory-data-protection)
   - [8.29 Enterprise Evolution](#829-enterprise-evolution)
   - [8.30 Data Protection Testing](#830-data-protection-testing)
   - [8.31 Data Protection Evidence](#831-data-protection-evidence)
   - [8.32 Data Protection and Encryption Guarantees](#832-data-protection-and-encryption-guarantees)

[9. Data Classification and Sensitive Data](#9-data-classification-and-sensitive-data)
   - [9.1 Classification Model](#91-classification-model)
   - [9.2 Public Data](#92-public-data)
   - [9.3 Internal Data](#93-internal-data)
   - [9.4 Confidential Data](#94-confidential-data)
   - [9.5 Restricted Data](#95-restricted-data)
   - [9.6 Classification Is Independent of Architectural Layer](#96-classification-is-independent-of-architectural-layer)
   - [9.7 Classification Inheritance](#97-classification-inheritance)
   - [9.8 Personal Data](#98-personal-data)
   - [9.9 Sensitive Personal Data](#99-sensitive-personal-data)
   - [9.10 Business-Sensitive Data](#910-business-sensitive-data)
   - [9.11 Security-Sensitive Data](#911-security-sensitive-data)
   - [9.12 Data Classification Metadata](#912-data-classification-metadata)
   - [9.13 Attribute-Level Classification](#913-attribute-level-classification)
   - [9.14 Classification and Data Minimization](#914-classification-and-data-minimization)
   - [9.15 Classification Across the Data Flow](#915-classification-across-the-data-flow)
   - [9.16 Bronze Classification](#916-bronze-classification)
   - [9.17 Silver Classification](#917-silver-classification)
   - [9.18 Gold Classification](#918-gold-classification)
   - [9.19 Certified Gold Classification](#919-certified-gold-classification)
   - [9.20 Classification and Observability](#920-classification-and-observability)
   - [9.21 Classification and Evidence](#921-classification-and-evidence)
   - [9.22 Classification and Analytical Consumption](#922-classification-and-analytical-consumption)
   - [9.23 Classification and Export](#923-classification-and-export)
   - [9.24 Classification and Retention](#924-classification-and-retention)
   - [9.25 Classification Review](#925-classification-review)
   - [9.26 Classification Ownership](#926-classification-ownership)
   - [9.27 Unknown Classification](#927-unknown-classification)
   - [9.28 Classification Changes](#928-classification-changes)
   - [9.29 Laboratory Classification Model](#929-laboratory-classification-model)
   - [9.30 Enterprise Evolution](#930-enterprise-evolution)
   - [9.31 Classification Testing](#931-classification-testing)
   - [9.32 Classification Evidence](#932-classification-evidence)
   - [9.33 Data Classification and Sensitive Data Guarantees](#933-data-classification-and-sensitive-data-guarantees)

[10. LGPD and Privacy Governance](#10-lgpd-and-privacy-governance)
    - [10.1 Personal Data Identification](#101-personal-data-identification)
    - [10.2 Sensitive Personal Data](#102-sensitive-personal-data)
    - [10.3 Processing Purpose](#103-processing-purpose)
    - [10.4 Purpose Limitation](#104-purpose-limitation)
    - [10.5 Data Minimization](#105-data-minimization)
    - [10.6 Privacy Across the Data Pipeline](#106-privacy-across-the-data-pipeline)
    - [10.7 Source Privacy Boundary](#107-source-privacy-boundary)
    - [10.8 Kafka and Event Privacy](#108-kafka-and-event-privacy)
    - [10.9 Bronze Privacy](#109-bronze-privacy)
    - [10.10 Silver Privacy](#1010-silver-privacy)
    - [10.11 Gold Privacy](#1011-gold-privacy)
    - [10.12 Certified Gold Privacy](#1012-certified-gold-privacy)
    - [10.13 Direct and Indirect Identifiers](#1013-direct-and-indirect-identifiers)
    - [10.14 Pseudonymization](#1014-pseudonymization)
    - [10.15 Anonymization](#1015-anonymization)
    - [10.16 Masking](#1016-masking)
    - [10.17 Privacy and Access Control](#1017-privacy-and-access-control)
    - [10.18 Privacy and Observability](#1018-privacy-and-observability)
    - [10.19 Privacy and Lineage](#1019-privacy-and-lineage)
    - [10.20 Privacy and Metadata](#1020-privacy-and-metadata)
    - [10.21 Data Accuracy and Correction](#1021-data-accuracy-and-correction)
    - [10.22 Data-Subject Requests](#1022-data-subject-requests)
    - [10.23 Deletion and Erasure](#1023-deletion-and-erasure)
    - [10.24 Deletion Versus Historical Integrity](#1024-deletion-versus-historical-integrity)
    - [10.25 Privacy and Backups](#1025-privacy-and-backups)
    - [10.26 Privacy and Replay](#1026-privacy-and-replay)
    - [10.27 Privacy and Data Retention](#1027-privacy-and-data-retention)
    - [10.28 Privacy and Data Export](#1028-privacy-and-data-export)
    - [10.29 Privacy Incident Considerations](#1029-privacy-incident-considerations)
    - [10.30 Privacy by Design](#1030-privacy-by-design)
    - [10.31 Privacy Governance for New Data Products](#1031-privacy-governance-for-new-data-products)
    - [10.32 Laboratory Privacy Model](#1032-laboratory-privacy-model)
    - [10.33 Enterprise Evolution](#1033-enterprise-evolution)
    - [10.34 Privacy Testing](#1034-privacy-testing)
    - [10.35 Privacy Evidence](#1035-privacy-evidence)
    - [10.36 LGPD and Privacy Governance Guarantees](#1036-lgpd-and-privacy-governance-guarantees)

[11. Data Access by Architectural Layer](#11-data-access-by-architectural-layer)
    - [11.1 Operational Source Access](#111-operational-source-access)
    - [11.2 CDC Access](#112-cdc-access)
    - [11.3 Debezium Access](#113-debezium-access)
    - [11.4 Kafka Producer Access](#114-kafka-producer-access)
    - [11.5 Kafka Consumer Access](#115-kafka-consumer-access)
    - [11.6 Kafka Administrative Access](#116-kafka-administrative-access)
    - [11.7 Bronze Access](#117-bronze-access)
    - [11.8 Bronze Write Access](#118-bronze-write-access)
    - [11.9 Silver Access](#119-silver-access)
    - [11.10 Silver Write Access](#1110-silver-write-access)
    - [11.11 Gold Access](#1111-gold-access)
    - [11.12 Gold Candidate Access](#1112-gold-candidate-access)
    - [11.13 Certified Gold Access](#1113-certified-gold-access)
    - [11.14 Certified Gold Write and Publication Access](#1114-certified-gold-write-and-publication-access)
    - [11.15 Power BI Access](#1115-power-bi-access)
    - [11.16 Airflow Access](#1116-airflow-access)
    - [11.17 Observability Access](#1117-observability-access)
    - [11.18 Metadata and Lineage Access](#1118-metadata-and-lineage-access)
    - [11.19 Quarantine Access](#1119-quarantine-access)
    - [11.20 Backup Access](#1120-backup-access)
    - [11.21 Evidence Access](#1121-evidence-access)
    - [11.22 Cross-Layer Access](#1122-cross-layer-access)
    - [11.23 Access During Replay and Recovery](#1123-access-during-replay-and-recovery)
    - [11.24 Access During Investigation](#1124-access-during-investigation)
    - [11.25 Environment Separation](#1125-environment-separation)
    - [11.26 Access Matrix](#1126-access-matrix)
    - [11.27 Access Matrix Validation](#1127-access-matrix-validation)
    - [11.28 Access Drift](#1128-access-drift)
    - [11.29 Access Boundary Changes](#1129-access-boundary-changes)
    - [11.30 Laboratory Access Model](#1130-laboratory-access-model)
    - [11.31 Enterprise Evolution](#1131-enterprise-evolution)
    - [11.32 Layer Access Testing](#1132-layer-access-testing)
    - [11.33 Layer Access Evidence](#1133-layer-access-evidence)
    - [11.34 Data Access by Architectural Layer Guarantees](#1134-data-access-by-architectural-layer-guarantees)

[12. Schema, Contract, and Metadata Governance](#12-schema-contract-and-metadata-governance)
    - [12.1 Governed Definitions](#121-governed-definitions)
    - [12.2 Source Schema Governance](#122-source-schema-governance)
    - [12.3 Event Contract Governance](#123-event-contract-governance)
    - [12.4 Contract Ownership](#124-contract-ownership)
    - [12.5 Contract Versioning](#125-contract-versioning)
    - [12.6 Compatibility Governance](#126-compatibility-governance)
    - [12.7 Breaking-Change Governance](#127-breaking-change-governance)
    - [12.8 Processing Definition Governance](#128-processing-definition-governance)
    - [12.9 Silver Processing Version](#129-silver-processing-version)
    - [12.10 Gold Processing Version](#1210-gold-processing-version)
    - [12.11 Quality Rule Governance](#1211-quality-rule-governance)
    - [12.12 Reconciliation Rule Governance](#1212-reconciliation-rule-governance)
    - [12.13 Certification Governance](#1213-certification-governance)
    - [12.14 Analytical Consumption Contract Governance](#1214-analytical-consumption-contract-governance)
    - [12.15 Metadata Governance](#1215-metadata-governance)
    - [12.16 Technical Metadata](#1216-technical-metadata)
    - [12.17 Business Metadata](#1217-business-metadata)
    - [12.18 Governance Metadata and Security Metadata](#1218-governance-metadata-and-security-metadata)
    - [12.19 Metadata Ownership](#1219-metadata-ownership)
    - [12.20 Lineage Governance](#1220-lineage-governance)
    - [12.21 Version Relationships](#1221-version-relationships)
    - [12.22 Change Impact Analysis](#1222-change-impact-analysis)
    - [12.23 Change Approval](#1223-change-approval)
    - [12.24 Architecture Decision Records](#1224-architecture-decision-records)
    - [12.25 Documentation Consistency](#1225-documentation-consistency)
    - [12.26 Metadata Drift](#1226-metadata-drift)
    - [12.27 Contract Drift](#1227-contract-drift)
    - [12.28 Quality Rule Drift](#1228-quality-rule-drift)
    - [12.29 Certified Product Drift](#1229-certified-product-drift)
    - [12.30 Lifecycle Governance](#1230-lifecycle-governance)
    - [12.31 Deprecation](#1231-deprecation)
    - [12.32 Removal](#1232-removal)
    - [12.33 Governance During Recovery](#1233-governance-during-recovery)
    - [12.34 Governance During Experimentation](#1234-governance-during-experimentation)
    - [12.35 Governance Repository Structure](#1235-governance-repository-structure)
    - [12.36 Public and Private Governance Artifacts](#1236-public-and-private-governance-artifacts)
    - [12.37 Governance Testing](#1237-governance-testing)
    - [12.38 Governance Evidence](#1238-governance-evidence)
    - [12.39 Schema, Contract, and Metadata Governance Guarantees](#1239-schema-contract-and-metadata-governance-guarantees)

[13. Retention, Archival, and Disposal](#13-retention-archival-and-disposal)
    - [13.1 Retention Principles](#131-retention-principles)
    - [13.2 Retention by Architectural Layer](#132-retention-by-architectural-layer)
    - [13.3 Kafka Retention](#133-kafka-retention)
    - [13.4 CDC Retention](#134-cdc-retention)
    - [13.5 Bronze Retention](#135-bronze-retention)
    - [13.6 Silver Retention](#136-silver-retention)
    - [13.7 Gold Retention](#137-gold-retention)
    - [13.8 Certified Gold Retention](#138-certified-gold-retention)
    - [13.9 Candidate Data Retention](#139-candidate-data-retention)
    - [13.10 Quarantine Retention](#1310-quarantine-retention)
    - [13.11 Temporary Artifact Retention](#1311-temporary-artifact-retention)
    - [13.12 Log Retention](#1312-log-retention)
    - [13.13 Metrics Retention](#1313-metrics-retention)
    - [13.14 Lineage Retention](#1314-lineage-retention)
    - [13.15 Metadata Retention](#1315-metadata-retention)
    - [13.16 Contract Version Retention](#1316-contract-version-retention)
    - [13.17 Processing Version Retention](#1317-processing-version-retention)
    - [13.18 Evidence Retention](#1318-evidence-retention)
    - [13.19 Security Audit Retention](#1319-security-audit-retention)
    - [13.20 Backup Retention](#1320-backup-retention)
    - [13.21 Archival](#1321-archival)
    - [13.22 Online Versus Archived Data](#1322-online-versus-archived-data)
    - [13.23 Archival and Replay](#1323-archival-and-replay)
    - [13.24 Archival and Encryption](#1324-archival-and-encryption)
    - [13.25 Retention and Privacy](#1325-retention-and-privacy)
    - [13.26 Retention and Data-Subject Requests](#1326-retention-and-data-subject-requests)
    - [13.27 Retention and Replay Risk](#1327-retention-and-replay-risk)
    - [13.28 Retention and Certification](#1328-retention-and-certification)
    - [13.29 Disposal](#1329-disposal)
    - [13.30 Logical Deletion](#1330-logical-deletion)
    - [13.31 Physical Disposal](#1331-physical-disposal)
    - [13.32 Cryptographic Disposal](#1332-cryptographic-disposal)
    - [13.33 Disposal and Backups](#1333-disposal-and-backups)
    - [13.34 Disposal and Replay](#1334-disposal-and-replay)
    - [13.35 Retention Policy Metadata](#1335-retention-policy-metadata)
    - [13.36 Retention Ownership](#1336-retention-ownership)
    - [13.37 Retention Review](#1337-retention-review)
    - [13.38 Retention Drift](#1338-retention-drift)
    - [13.39 Laboratory Retention Model](#1339-laboratory-retention-model)
    - [13.40 Enterprise Evolution](#1340-enterprise-evolution)
    - [13.41 Retention and Disposal Testing](#1341-retention-and-disposal-testing)
    - [13.42 Retention and Disposal Evidence](#1342-retention-and-disposal-evidence)
    - [13.43 Retention, Archival, and Disposal Guarantees](#1343-retention-archival-and-disposal-guarantees)

[14. Auditability and Security Observability](#14-auditability-and-security-observability)
    - [14.1 Auditability](#141-auditability)
    - [14.2 Security Observability](#142-security-observability)
    - [14.3 Identity Attribution](#143-identity-attribution)
    - [14.4 Service Attribution](#144-service-attribution)
    - [14.5 Authentication Events](#145-authentication-events)
    - [14.6 Authorization Events](#146-authorization-events)
    - [14.7 Privilege Changes](#147-privilege-changes)
    - [14.8 Administrative Operations](#148-administrative-operations)
    - [14.9 Security Configuration Changes](#149-security-configuration-changes)
    - [14.10 Sensitive Resource Access](#1410-sensitive-resource-access)
    - [14.11 Certified Gold and Publication Auditability](#1411-certified-gold-and-publication-auditability)
    - [14.12 Security Audit Data Classification](#1412-security-audit-data-classification)
    - [14.13 Secrets Must Not Be Audited as Values](#1413-secrets-must-not-be-audited-as-values)
    - [14.14 Personal Data in Security Logs](#1414-personal-data-in-security-logs)
    - [14.15 Structured Security Logging](#1415-structured-security-logging)
    - [14.16 Correlation Across Components](#1416-correlation-across-components)
    - [14.17 Time Consistency](#1417-time-consistency)
    - [14.18 Audit Integrity](#1418-audit-integrity)
    - [14.19 Audit Availability](#1419-audit-availability)
    - [14.20 Security Metrics](#1420-security-metrics)
    - [14.21 Security Dashboards](#1421-security-dashboards)
    - [14.22 Security Alerting](#1422-security-alerting)
    - [14.23 Baseline Security Behavior](#1423-baseline-security-behavior)
    - [14.24 Audit Trail for Access Changes](#1424-audit-trail-for-access-changes)
    - [14.25 Audit Trail for Credential Lifecycle](#1425-audit-trail-for-credential-lifecycle)
    - [14.26 Audit Trail for Recovery](#1426-audit-trail-for-recovery)
    - [14.27 Security Investigation](#1427-security-investigation)
    - [14.28 Security Incident Evidence](#1428-security-incident-evidence)
    - [14.29 Negative Security Evidence](#1429-negative-security-evidence)
    - [14.30 Security Observability During Failure](#1430-security-observability-during-failure)
    - [14.31 Auditability and Privacy](#1431-auditability-and-privacy)
    - [14.32 Auditability and Retention](#1432-auditability-and-retention)
    - [14.33 Laboratory Security Observability](#1433-laboratory-security-observability)
    - [14.34 Enterprise Evolution](#1434-enterprise-evolution)
    - [14.35 Auditability Testing](#1435-auditability-testing)
    - [14.36 Auditability Evidence](#1436-auditability-evidence)
    - [14.37 Auditability and Security Observability Guarantees](#1437-auditability-and-security-observability-guarantees)

[15. Security Incident and Recovery Considerations](#15-security-incident-and-recovery-considerations)
    - [15.1 Security Incident Classification](#151-security-incident-classification)
    - [15.2 Detection](#152-detection)
    - [15.3 Initial Assessment](#153-initial-assessment)
    - [15.4 Containment](#154-containment)
    - [15.5 Credential Compromise](#155-credential-compromise)
    - [15.6 Secret Exposure](#156-secret-exposure)
    - [15.7 Unauthorized Access](#157-unauthorized-access)
    - [15.8 Excessive Privilege](#158-excessive-privilege)
    - [15.9 Service Identity Compromise](#159-service-identity-compromise)
    - [15.10 Data Confidentiality Incident](#1510-data-confidentiality-incident)
    - [15.11 Data Integrity Incident](#1511-data-integrity-incident)
    - [15.12 Integrity Recovery](#1512-integrity-recovery)
    - [15.13 Certified Gold Security Incident](#1513-certified-gold-security-incident)
    - [15.14 Last Known-Trusted State](#1514-last-known-trusted-state)
    - [15.15 Security Recovery and Backup](#1515-security-recovery-and-backup)
    - [15.16 Recovery Must Not Restore Invalidated Trust](#1516-recovery-must-not-restore-invalidated-trust)
    - [15.17 Recovery and Privileged Access](#1517-recovery-and-privileged-access)
    - [15.18 Break-Glass Access](#1518-break-glass-access)
    - [15.19 Evidence Preservation](#1519-evidence-preservation)
    - [15.20 Evidence Integrity](#1520-evidence-integrity)
    - [15.21 Incident Correlation](#1521-incident-correlation)
    - [15.22 Incident and Lineage](#1522-incident-and-lineage)
    - [15.23 Incident and Privacy Governance](#1523-incident-and-privacy-governance)
    - [15.24 Incident and Retention](#1524-incident-and-retention)
    - [15.25 Security Recovery Validation](#1525-security-recovery-validation)
    - [15.26 Service-Level Security Recovery](#1526-service-level-security-recovery)
    - [15.27 Post-Incident Review](#1527-post-incident-review)
    - [15.28 Security Incident Test Scenarios](#1528-security-incident-test-scenarios)
    - [15.29 Security Incident Evidence](#1529-security-incident-evidence)
    - [15.30 Laboratory Security Recovery](#1530-laboratory-security-recovery)
    - [15.31 Enterprise Evolution](#1531-enterprise-evolution)
    - [15.32 Security Incident and Recovery Guarantees](#1532-security-incident-and-recovery-guarantees)

[16. Roles and Responsibilities](#16-roles-and-responsibilities)
    - [16.1 Responsibility Model](#161-responsibility-model)
    - [16.2 Data Engineering](#162-data-engineering)
    - [16.3 Data Engineering and Source Ownership](#163-data-engineering-and-source-ownership)
    - [16.4 Database Administration](#164-database-administration)
    - [16.5 DBA and CDC](#165-dba-and-cdc)
    - [16.6 Platform / SRE](#166-platform--sre)
    - [16.7 Platform Reliability Responsibility](#167-platform-reliability-responsibility)
    - [16.8 Security](#168-security)
    - [16.9 Security and Technical Teams](#169-security-and-technical-teams)
    - [16.10 Data Governance](#1610-data-governance)
    - [16.11 Data Governance and Data Engineering](#1611-data-governance-and-data-engineering)
    - [16.12 Privacy / Legal](#1612-privacy--legal)
    - [16.13 Privacy and Data Engineering](#1613-privacy-and-data-engineering)
    - [16.14 Business Data Owner](#1614-business-data-owner)
    - [16.15 Business Ownership and Technical Ownership](#1615-business-ownership-and-technical-ownership)
    - [16.16 Business Intelligence / Analytics](#1616-business-intelligence--analytics)
    - [16.17 BI and Business Logic](#1617-bi-and-business-logic)
    - [16.18 Data Consumer](#1618-data-consumer)
    - [16.19 Data Product Ownership](#1619-data-product-ownership)
    - [16.20 Event Contract Responsibility](#1620-event-contract-responsibility)
    - [16.21 Quality Responsibility](#1621-quality-responsibility)
    - [16.22 Reconciliation Responsibility](#1622-reconciliation-responsibility)
    - [16.23 Certification Responsibility](#1623-certification-responsibility)
    - [16.24 Publication Responsibility](#1624-publication-responsibility)
    - [16.25 Backup and Recovery Responsibility](#1625-backup-and-recovery-responsibility)
    - [16.26 Incident Responsibility](#1626-incident-responsibility)
    - [16.27 Change Responsibility](#1627-change-responsibility)
    - [16.28 Documentation Responsibility](#1628-documentation-responsibility)
    - [16.29 Evidence Responsibility](#1629-evidence-responsibility)
    - [16.30 Separation of Duties](#1630-separation-of-duties)
    - [16.31 Laboratory Role Consolidation](#1631-laboratory-role-consolidation)
    - [16.32 Logical Separation in the Laboratory](#1632-logical-separation-in-the-laboratory)
    - [16.33 Enterprise Role Distribution](#1633-enterprise-role-distribution)
    - [16.34 Responsibility Matrix](#1634-responsibility-matrix)
    - [16.35 Responsibility Gaps](#1635-responsibility-gaps)
    - [16.36 Responsibility Overlap](#1636-responsibility-overlap)
    - [16.37 Escalation](#1637-escalation)
    - [16.38 Roles and Least Privilege](#1638-roles-and-least-privilege)
    - [16.39 Roles and Evidence](#1639-roles-and-evidence)
    - [16.40 Role Review](#1640-role-review)
    - [16.41 Roles and Responsibilities Testing](#1641-roles-and-responsibilities-testing)
    - [16.42 Roles and Responsibilities Evidence](#1642-roles-and-responsibilities-evidence)
    - [16.43 Roles and Responsibilities Guarantees](#1643-roles-and-responsibilities-guarantees)

[17. Security Validation Strategy](#17-security-validation-strategy)
    - [17.1 Validation Scope](#171-validation-scope)
    - [17.2 Positive Security Tests](#172-positive-security-tests)
    - [17.3 Negative Security Tests](#173-negative-security-tests)
    - [17.4 Test Identifiers](#174-test-identifiers)
    - [17.5 Test Definition](#175-test-definition)
    - [17.6 PASS and FAIL Criteria](#176-pass-and-fail-criteria)
    - [17.7 Authentication Validation](#177-authentication-validation)
    - [17.8 Authorization Validation](#178-authorization-validation)
    - [17.9 Service Identity Isolation](#179-service-identity-isolation)
    - [17.10 Administrative Access Validation](#1710-administrative-access-validation)
    - [17.11 Credential Rotation Validation](#1711-credential-rotation-validation)
    - [17.12 Secret Exposure Validation](#1712-secret-exposure-validation)
    - [17.13 Network Access Validation](#1713-network-access-validation)
    - [17.14 TLS Validation](#1714-tls-validation)
    - [17.15 Data Protection Validation](#1715-data-protection-validation)
    - [17.16 Classification Validation](#1716-classification-validation)
    - [17.17 Privacy Validation](#1717-privacy-validation)
    - [17.18 Layer Access Validation](#1718-layer-access-validation)
    - [17.19 Governance Validation](#1719-governance-validation)
    - [17.20 Retention Validation](#1720-retention-validation)
    - [17.21 Auditability Validation](#1721-auditability-validation)
    - [17.22 Incident Validation](#1722-incident-validation)
    - [17.23 Recovery Security Validation](#1723-recovery-security-validation)
    - [17.24 Security Regression Testing](#1724-security-regression-testing)
    - [17.25 Test Isolation](#1725-test-isolation)
    - [17.26 Test Cleanup](#1726-test-cleanup)
    - [17.27 Repeatability](#1727-repeatability)
    - [17.28 Automation](#1728-automation)
    - [17.29 Security Test Environment](#1729-security-test-environment)
    - [17.30 Security Evidence Structure](#1730-security-evidence-structure)
    - [17.31 Evidence Sanitization](#1731-evidence-sanitization)
    - [17.32 Negative Evidence](#1732-negative-evidence)
    - [17.33 Evidence and Architecture Decisions](#1733-evidence-and-architecture-decisions)
    - [17.34 Security Baseline](#1734-security-baseline)
    - [17.35 Security Claim Levels](#1735-security-claim-levels)
    - [17.36 Laboratory Claims](#1736-laboratory-claims)
    - [17.37 Security Validation Review](#1737-security-validation-review)
    - [17.38 Security Validation Guarantees](#1738-security-validation-guarantees)

[18. Laboratory and Enterprise Security Boundaries](#18-laboratory-and-enterprise-security-boundaries)
    - [18.1 Laboratory Purpose](#181-laboratory-purpose)
    - [18.2 Laboratory Physical Constraints](#182-laboratory-physical-constraints)
    - [18.3 Logical Boundary Preservation](#183-logical-boundary-preservation)
    - [18.4 Single-Operator Environment](#184-single-operator-environment)
    - [18.5 Laboratory Identity Limitations](#185-laboratory-identity-limitations)
    - [18.6 Laboratory Secrets Limitations](#186-laboratory-secrets-limitations)
    - [18.7 Laboratory Network Limitations](#187-laboratory-network-limitations)
    - [18.8 Laboratory Encryption Scope](#188-laboratory-encryption-scope)
    - [18.9 Laboratory Data](#189-laboratory-data)
    - [18.10 Laboratory Privacy Claims](#1810-laboratory-privacy-claims)
    - [18.11 Laboratory Auditability](#1811-laboratory-auditability)
    - [18.12 Laboratory Incident Response](#1812-laboratory-incident-response)
    - [18.13 Laboratory Availability and Redundancy](#1813-laboratory-availability-and-redundancy)
    - [18.14 Laboratory Scale](#1814-laboratory-scale)
    - [18.15 Enterprise Identity Evolution](#1815-enterprise-identity-evolution)
    - [18.16 Enterprise Secrets Evolution](#1816-enterprise-secrets-evolution)
    - [18.17 Enterprise Network Evolution](#1817-enterprise-network-evolution)
    - [18.18 Enterprise Encryption Evolution](#1818-enterprise-encryption-evolution)
    - [18.19 Enterprise Observability and Security Operations](#1819-enterprise-observability-and-security-operations)
    - [18.20 Enterprise Data Governance Evolution](#1820-enterprise-data-governance-evolution)
    - [18.21 Enterprise Separation of Duties](#1821-enterprise-separation-of-duties)
    - [18.22 Enterprise Environment Separation](#1822-enterprise-environment-separation)
    - [18.23 Enterprise Policy Enforcement](#1823-enterprise-policy-enforcement)
    - [18.24 Enterprise High Availability](#1824-enterprise-high-availability)
    - [18.25 Enterprise Disaster Recovery](#1825-enterprise-disaster-recovery)
    - [18.26 Enterprise Security Governance](#1826-enterprise-security-governance)
    - [18.27 Security Control Substitution](#1827-security-control-substitution)
    - [18.28 Security Control Strengthening](#1828-security-control-strengthening)
    - [18.29 Portability of Security Architecture](#1829-portability-of-security-architecture)
    - [18.30 Laboratory Evidence Boundaries](#1830-laboratory-evidence-boundaries)
    - [18.31 Laboratory Versus Enterprise Claims](#1831-laboratory-versus-enterprise-claims)
    - [18.32 Documenting Enterprise Gaps](#1832-documenting-enterprise-gaps)
    - [18.33 Avoiding Security Theater](#1833-avoiding-security-theater)
    - [18.34 Evidence-Driven Enterprise Evolution](#1834-evidence-driven-enterprise-evolution)
    - [18.35 Enterprise Evolution and ADRs](#1835-enterprise-evolution-and-adrs)
    - [18.36 Laboratory and Enterprise Validation](#1836-laboratory-and-enterprise-validation)
    - [18.37 Laboratory and Enterprise Security Guarantees](#1837-laboratory-and-enterprise-security-guarantees)

[19. Security and Governance Guarantees](#19-security-and-governance-guarantees)
    - [19.1 Identity and Access](#191-identity-and-access)
    - [19.2 Deny by Default](#192-deny-by-default)
    - [19.3 Service Isolation](#193-service-isolation)
    - [19.4 Secret Protection](#194-secret-protection)
    - [19.5 Explicit Trust Boundaries](#195-explicit-trust-boundaries)
    - [19.6 Controlled Network Exposure](#196-controlled-network-exposure)
    - [19.7 Data Protection Throughout the Lifecycle](#197-data-protection-throughout-the-lifecycle)
    - [19.8 Data Minimization](#198-data-minimization)
    - [19.9 Data Classification](#199-data-classification)
    - [19.10 Personal Data and Privacy](#1910-personal-data-and-privacy)
    - [19.11 Privacy by Design](#1911-privacy-by-design)
    - [19.12 Layer-Based Access](#1912-layer-based-access)
    - [19.13 Candidate and Certified Data Separation](#1913-candidate-and-certified-data-separation)
    - [19.14 Governance of Definitions](#1914-governance-of-definitions)
    - [19.15 Contract Governance](#1915-contract-governance)
    - [19.16 Version Separation](#1916-version-separation)
    - [19.17 Metadata and Lineage](#1917-metadata-and-lineage)
    - [19.18 Quality and Certification Governance](#1918-quality-and-certification-governance)
    - [19.19 Retention Governance](#1919-retention-governance)
    - [19.20 Archival Governance](#1920-archival-governance)
    - [19.21 Disposal Governance](#1921-disposal-governance)
    - [19.22 Auditability](#1922-auditability)
    - [19.23 Security Observability](#1923-security-observability)
    - [19.24 Security Incident Handling](#1924-security-incident-handling)
    - [19.25 Last Known-Trusted State](#1925-last-known-trusted-state)
    - [19.26 Recovery Does Not Restore Invalidated Trust](#1926-recovery-does-not-restore-invalidated-trust)
    - [19.27 Recovery Preserves Governance](#1927-recovery-preserves-governance)
    - [19.28 Roles and Responsibilities](#1928-roles-and-responsibilities)
    - [19.29 Responsibility and Privilege](#1929-responsibility-and-privilege)
    - [19.30 Validation](#1930-validation)
    - [19.31 Evidence](#1931-evidence)
    - [19.32 Negative Evidence](#1932-negative-evidence)
    - [19.33 Drift](#1933-drift)
    - [19.34 Documentation](#1934-documentation)
    - [19.35 Laboratory Boundary](#1935-laboratory-boundary)
    - [19.36 Enterprise Evolution](#1936-enterprise-evolution)
    - [19.37 Evidence-Bounded Claims](#1937-evidence-bounded-claims)
    - [19.38 Closing Principle](#1938-closing-principle)

---

## 1. Purpose

This document defines the security and governance architecture of the Atlas Engineering data platform.

Its purpose is to establish how identities, access, credentials, data, metadata, contracts, privacy requirements, retention policies, auditability, and security responsibilities are governed across the platform.

While the Architecture Overview defines the platform structure and the Data Flow and Processing document defines how data moves and is processed, this document defines the controls that protect and govern those operations throughout their lifecycle.

The architecture is designed around the principle that security and governance are cross-cutting capabilities rather than isolated implementation steps. They apply from the operational source through ingestion, streaming, storage, transformation, certification, and analytical consumption.

The document defines the architectural requirements for:

- identity and access management;
- authentication and authorization;
- least-privilege access;
- secrets and credential management;
- secure communication between platform services;
- data protection in transit and at rest;
- classification and handling of sensitive data;
- privacy and LGPD-related controls;
- access boundaries across Bronze, Silver, Gold, and Certified Gold;
- schema, contract, and metadata governance;
- retention, archival, and controlled disposal;
- auditability and security observability;
- security-related incident and recovery considerations;
- separation of responsibilities between platform roles and teams;
- laboratory security controls and their enterprise evolution;
- validation and evidence of implemented security controls.

The document does not claim that a documented control is automatically implemented, tested, or compliant.

Security and governance requirements must progress through the same evidence-based lifecycle used throughout Atlas Engineering:

**Architecture Requirement → Implementation → Test → Observability → Evidence**

Where legal, regulatory, or organizational requirements apply, the architecture defines the technical and governance mechanisms that can support those requirements. Formal legal or regulatory compliance must not be inferred solely from the existence of architectural controls.

The Version 1 implementation focuses on the controls required to protect and govern the initial Sales data product and its supporting platform components.

The security and governance model is designed to extend to future data products without redefining its fundamental architectural boundaries.

---

## 2. Security and Governance Context

Atlas Engineering processes operational data across multiple architectural boundaries, technologies, storage layers, and processing stages.

Data originates in AtlasCommerce and moves through change capture, event creation, schema governance, Kafka transport, Bronze persistence, Silver transformation, Gold dimensional processing, certification, and analytical consumption.

Each transition introduces security and governance responsibilities.

The platform therefore cannot treat security as a control applied only at the infrastructure perimeter, nor governance as documentation applied only after data has been produced.

Security and governance must accompany the data throughout its lifecycle.

The architectural context includes:

- an operational SQL Server source containing business and potentially sensitive data;
- SQL Server CDC and Debezium for change capture and event creation;
- Apicurio Registry for event-contract governance;
- Kafka for asynchronous event transport;
- MinIO for durable Bronze and Silver storage;
- SQL Server for Gold dimensional processing and Certified Gold publication;
- Airflow for orchestration;
- Prometheus, Grafana, and structured logs for operational observability;
- Power BI as the initial analytical consumer;
- metadata, lineage, quality, reconciliation, certification, and evidence mechanisms that span multiple platform components.

These components have different responsibilities, trust boundaries, access requirements, and data-exposure characteristics.

Security is therefore applied according to the identity performing a defined responsibility and the resource that responsibility requires.

The intended access sequence is:

**Identity → Authentication → Authorization → Controlled Data Access → Auditable Activity**

Governance applies not only to business data but also, where applicable, to:

- event contracts and schema versions;
- processing versions;
- quality and reconciliation rules;
- metadata and lineage;
- certification state;
- retention policies;
- access policies;
- audit information;
- validation evidence.

Security and governance must also remain effective during failure and recovery.

Recovery must restore legitimate processing without silently bypassing authentication, authorization, data protection, auditability, or governed publication boundaries.

The Version 1 laboratory implements these principles within the constraints of a controlled local training environment.

Laboratory limitations may affect the physical strength, redundancy, or sophistication of individual controls, but they do not redefine the logical security and governance boundaries of the architecture.

---

## 3. Security Principles

Security and governance decisions in Atlas Engineering follow a consistent set of architectural principles.

These principles apply across infrastructure, services, processing workloads, storage layers, metadata, analytical products, operational procedures, and future platform evolution.

### 3.1 Security by Design

Security is considered during architecture and implementation design rather than added only after a component becomes operational.

New services, data flows, interfaces, storage locations, and analytical products must be evaluated for their security implications before becoming part of the governed platform.

Security requirements therefore evolve together with the architecture.

### 3.2 Deny by Default

Access is denied unless explicitly granted for a defined purpose.

Network connectivity, technical compatibility, or possession of valid credentials does not constitute authorization.

New identities, services, datasets, interfaces, and resources must not inherit broad access merely for operational convenience.

### 3.3 Least Privilege

Every human or service identity receives only the permissions required to perform its defined responsibilities.

Permissions should be limited according to:

- resource;
- operation;
- data scope;
- environment;
- duration;
- operational responsibility.

Administrative privileges must not be used for routine processing when narrower permissions satisfy the requirement.

### 3.4 Separation of Duties

Responsibilities that create conflicting levels of control should be separated where practical.

The architecture distinguishes responsibilities such as:

- platform administration;
- data engineering;
- data consumption;
- security administration;
- governance;
- certification;
- audit and investigation.

The Version 1 laboratory may combine several responsibilities under a single operator, but their logical separation remains part of the architecture.

### 3.5 Explicit Trust Boundaries

Trust is not implicitly extended across architectural components.

Communication between services, layers, environments, and consumers crosses explicit trust boundaries evaluated according to:

- identity;
- authentication;
- authorization;
- network exposure;
- data sensitivity;
- encryption requirements;
- auditability.

A service trusted for one responsibility is not automatically trusted for another.

### 3.6 Defense in Depth

No single security control is assumed to provide complete protection.

Where appropriate, protection combines controls such as:

- identity;
- authentication;
- authorization;
- network isolation;
- encryption;
- secrets management;
- data minimization;
- auditing;
- monitoring;
- recovery controls.

Failure or misconfiguration of one control should not automatically remove every protection surrounding an asset.

### 3.7 Data Minimization

The platform should process, propagate, persist, and expose only the data required for a defined technical or business purpose.

The presence of an attribute in the operational source does not automatically justify its presence in every downstream event, storage layer, dimensional model, or analytical product.

Sensitive data requires particular attention to necessity, exposure, retention, and downstream propagation.

### 3.8 Purpose-Limited Access

Access to data is granted according to an explicit operational, analytical, governance, or support purpose.

Technical ability to access a dataset does not establish a valid reason to access it.

Consumers should use the governed representation appropriate to their purpose rather than bypass architectural layers without justification.

### 3.9 Secure Credential Handling

Passwords, tokens, keys, certificates, credential-bearing connection strings, and equivalent secrets must not be treated as ordinary configuration data.

Secrets must not be intentionally embedded in source code, committed to the repository, exposed in documentation, or unnecessarily written to logs or evidence.

Credential lifecycle and storage mechanisms must be appropriate to the deployment environment.

### 3.10 Encryption According to Risk and Boundary

Protection in transit and at rest must be evaluated according to data sensitivity, trust boundaries, platform capabilities, deployment environment, and applicable requirements.

An internal network or local deployment does not eliminate the need to evaluate encryption.

Where the laboratory cannot reproduce an enterprise encryption model, that limitation must remain explicit.

### 3.11 Auditable Security Actions

Security-relevant actions must be observable and attributable where technically applicable.

This includes, where relevant:

- authentication and authorization events;
- privilege and security-configuration changes;
- administrative operations;
- credential lifecycle events;
- access to sensitive resources;
- certification and publication;
- security-related recovery.

Auditability must not require recording secrets or unnecessarily exposing sensitive data.

### 3.12 Secure Failure and Recovery

Failure handling, replay, reprocessing, backfill, rebuild, rollback, and recovery must preserve applicable security and governance controls.

Recovery must not depend on undocumented privilege escalation, shared credentials, uncontrolled access, or bypass of governed publication and certification boundaries.

Emergency elevated access, where required, must remain explicit, controlled, and auditable.

### 3.13 Security Controls Must Be Testable

A documented security requirement is not considered proven merely because a configuration or policy exists.

Where practical, controls must be validated through tests demonstrating both authorized and prohibited behavior.

Relevant results must be preserved as evidence when the control forms part of the validated architecture.

### 3.14 Security Claims Must Match Evidence

Atlas Engineering distinguishes between:

- documented security requirements;
- implemented controls;
- tested controls;
- observed behavior;
- validated evidence.

A control must not be described as proven, production-ready, compliant, or enterprise-grade beyond what implementation and evidence demonstrate.

Laboratory validation demonstrates behavior only under the documented topology, configuration, workload, and test conditions.

### 3.15 Security Must Evolve Without Breaking Architectural Boundaries

Security mechanisms may evolve as the platform grows.

For example:

**Local Credentials → Enterprise Secrets Management**

**Local Identities → Centralized Identity Management**

**Local Network Controls → Enterprise Network Segmentation**

The implementation mechanism may change while the underlying security requirement remains stable.

Enterprise evolution should strengthen security enforcement without invalidating the platform's fundamental architectural boundaries.

---

## 4. Identity and Access Management

Identity and Access Management defines how human and service identities are represented, separated, scoped, reviewed, and governed across Atlas Engineering.

The objective is to ensure that access corresponds to a defined responsibility and remains identifiable throughout its lifecycle.

The governing model is:

**Identity → Responsibility → Required Access → Controlled Lifecycle**

Authentication mechanisms and resource-level authorization behavior are detailed separately in the following chapter.

### 4.1 Identity Types

Atlas Engineering distinguishes between:

**Human Identities**
→ represent individual people performing administrative, engineering, governance, analytical, or support activities.

**Service Identities**
→ represent applications, platform components, processing workloads, or automated processes.

**Administrative Identities**
→ represent elevated access used for explicitly authorized administrative responsibilities.

These categories describe responsibility and privilege boundaries.

One person may operate more than one identity when different responsibilities require different privilege levels.

### 4.2 Human Identities

Human access should be individually attributable where technically supported.

Personal identities should be preferred over shared human accounts because individual attribution improves:

- accountability;
- access review;
- investigation;
- revocation;
- auditability.

Human access must correspond to a defined responsibility rather than broad technical convenience.

### 4.3 Service Identities

Automated platform components should use service identities appropriate to their responsibilities.

Representative service identities may include:

- Debezium;
- Kafka producers and consumers;
- Bronze processing;
- Silver processing;
- Gold processing;
- certification and publication;
- Airflow;
- observability components;
- Power BI or analytical-consumption services.

A service identity should exist because a workload requires identifiable technical access, not merely because a credential is needed.

### 4.4 Service Identity Separation

Independent platform responsibilities should not share one unrestricted service identity.

Where practical, separate workloads should receive separate identities and credentials so that access can be scoped, revoked, rotated, monitored, and investigated independently.

For example:

**Bronze Processor**
→ consumes approved Kafka events and writes Bronze data.

**Silver Processor**
→ reads Bronze and writes Silver.

**Gold Processor**
→ reads approved Silver inputs and produces Gold candidates.

**Publication Process**
→ controls publication of approved Certified Gold state.

Separation reduces blast radius and preserves accountability.

### 4.5 Administrative Identities

Administrative access must remain distinguishable from routine processing and consumption.

Administrative identities may require broader privileges for activities such as:

- platform configuration;
- database administration;
- security configuration;
- recovery;
- controlled troubleshooting.

Those privileges should not become the normal execution context for services or ordinary analytical activity.

Where practical, routine and elevated responsibilities should use distinguishable access paths or identities.

### 4.6 Shared Accounts

Shared human accounts should be avoided where individual attribution is feasible.

A shared account weakens:

- accountability;
- revocation;
- access review;
- incident investigation.

When a technology or laboratory constraint requires shared access, the limitation and compensating controls should be documented.

Shared technical identities may be acceptable only when they represent one clearly defined service responsibility rather than multiple unrelated workloads.

### 4.7 Role-Based Access

Permissions should be assigned according to defined responsibilities rather than individually accumulated without structure.

Representative logical roles may include:

- Data Engineering;
- DBA;
- Platform / SRE;
- Security;
- Data Governance;
- Privacy / Legal;
- Business Data Owner;
- BI / Analytics;
- Data Consumer.

Roles describe responsibility boundaries.

The same human operator may perform multiple roles in the Version 1 laboratory, but those responsibilities remain logically distinct.

### 4.8 Access Scope

Access should be scoped according to the minimum combination required for a responsibility.

Relevant dimensions include:

- resource;
- operation;
- dataset;
- architectural layer;
- environment;
- duration.

Read, write, administrative, publication, and security-management access must not be treated as equivalent privileges.

### 4.9 Layer-Based Access Boundaries

Architectural layers represent access boundaries as well as processing boundaries.

Access to one layer does not automatically imply access to another.

For example:

**Power BI**
→ requires governed analytical access to Certified Gold.

It does not therefore automatically require direct access to:

- AtlasCommerce;
- CDC structures;
- Kafka;
- Bronze;
- Silver;
- Gold processing structures.

The detailed access model for each architectural layer is defined in Chapter 11.

### 4.10 Access Lifecycle

Access must be governed throughout its lifecycle.

A representative lifecycle is:

**Request / Requirement → Approval → Provisioning → Use → Review → Modification or Revocation**

Access that was once justified must not be assumed to remain justified indefinitely.

Changes in responsibility, service architecture, environment, or operational purpose may require access to be modified or removed.

### 4.11 Access Review

Access should be reviewed when conditions capable of changing its justification occur.

Relevant triggers include:

- role changes;
- service changes;
- new data products;
- new sensitive data;
- architecture changes;
- security incidents;
- environment changes;
- privilege escalation;
- identified access drift.

Enterprise environments may also introduce periodic access-certification processes.

### 4.12 Privilege Escalation

Temporary elevated access may be required for administration, investigation, or recovery.

Such elevation should be:

- explicit;
- justified;
- limited to the required scope;
- temporary where practical;
- attributable;
- auditable;
- removed when no longer required.

Emergency access must not silently become permanent access.

### 4.13 Authentication Failure and Access Denial

Authentication failure and authorization denial are distinct security outcomes.

An identity may fail because it cannot prove who it is, or because an authenticated identity is not permitted to perform the requested action.

Both outcomes should remain observable where technically supported.

Detailed authentication and authorization behavior is defined in Chapter 5.

### 4.14 Identity and Access Metadata

Identity and access governance should preserve sufficient metadata to explain:

- what identity exists;
- whether it represents a human or service;
- its responsibility;
- its owner where applicable;
- its intended access scope;
- whether elevated privilege exists;
- its lifecycle state.

Metadata should support review and investigation without exposing credential values.

### 4.15 Laboratory Identity Model

Version 1 may use local identities and locally managed credentials because the platform operates as a controlled training laboratory.

The laboratory should still demonstrate:

- distinguishable human and service identities where practical;
- service-specific access;
- least privilege;
- controlled administrative access;
- revocation;
- access review;
- auditable security behavior.

Local implementation constraints do not eliminate the logical IAM model.

### 4.16 Enterprise Evolution

An enterprise implementation may strengthen IAM through capabilities such as:

- centralized identity providers;
- directory integration;
- single sign-on;
- multi-factor authentication;
- managed workload identities;
- privileged-access management;
- automated provisioning and deprovisioning;
- periodic access certification.

These mechanisms strengthen enforcement without changing the fundamental principle that identity and access follow responsibility.

### 4.17 Identity and Access Guarantees

The Atlas Engineering IAM model must preserve the following guarantees:

1. human and service identities remain distinguishable where technically practical;
2. administrative access remains distinguishable from routine processing and consumption;
3. independent service responsibilities do not rely on one unrestricted shared identity;
4. shared human accounts are avoided where individual attribution is feasible;
5. access follows defined responsibility;
6. permissions are scoped according to least privilege;
7. access to one architectural layer does not automatically imply access to another;
8. analytical consumption does not require unrestricted upstream access;
9. access has an explicit lifecycle and may be reviewed, modified, or revoked;
10. elevated access remains explicit and controlled;
11. authentication failure and authorization denial remain distinguishable;
12. identity and access metadata supports governance without exposing credentials;
13. laboratory constraints do not redefine logical identity boundaries;
14. enterprise IAM mechanisms may strengthen enforcement without changing the underlying responsibility model.

---

## 5. Authentication and Authorization

Authentication and authorization enforce the identity and access boundaries defined by Atlas Engineering.

Authentication answers:

**Who or what is requesting access?**

Authorization answers:

**What is that authenticated identity allowed to do?**

The governing sequence is:

**Identity → Authentication → Authorization → Resource Access → Auditable Activity**

Authentication and authorization are separate controls.

Successful authentication proves identity according to the implemented mechanism.

It does not independently grant permission to access a resource or perform an operation.

### 5.1 Authentication

Authentication verifies the identity of a human user, service, workload, or administrative actor before protected access is granted.

Authentication mechanisms depend on the technology and deployment environment.

They may include:

- passwords;
- service credentials;
- tokens;
- certificates;
- integrated identity mechanisms;
- managed identities in future enterprise environments.

Authentication credentials must be handled according to the secret-management requirements defined in Chapter 6.

### 5.2 Human Authentication

Human access should use individually attributable authentication where technically supported.

Authentication should preserve the distinction between:

- routine user access;
- administrative access;
- temporary elevated access.

Shared human authentication should be avoided where individual attribution is feasible.

Enterprise environments may strengthen human authentication through centralized identity, single sign-on, multi-factor authentication, and privileged-access mechanisms.

### 5.3 Service Authentication

Services must authenticate using mechanisms appropriate to their technical responsibilities.

Representative authenticated services may include:

- Debezium;
- Kafka producers and consumers;
- Bronze processing;
- Silver processing;
- Gold processing;
- certification and publication;
- Airflow;
- observability components;
- analytical-consumption services.

A service credential should identify a defined workload rather than provide generic platform-wide access.

### 5.4 Authentication Across Service Boundaries

Authentication must be evaluated at each protected service boundary.

Successful authentication to one platform component does not automatically establish authenticated or authorized access to another.

For example:

**Debezium → SQL Server**

and:

**Debezium → Kafka**

represent distinct service relationships and may require different authentication mechanisms or credentials.

Trust must not propagate implicitly across the platform.

### 5.5 Authorization

Authorization determines whether an authenticated identity may perform a requested operation against a specific resource.

Authorization should consider, where applicable:

- identity;
- role;
- resource;
- operation;
- architectural layer;
- dataset;
- environment;
- administrative responsibility.

The governing principle is:

**Authenticated ≠ Authorized**

### 5.6 Authentication Does Not Imply Authorization

An identity may authenticate successfully and still be denied access to a resource or operation.

For example:

**Power BI Authentication → SUCCESS**

does not imply:

**AtlasCommerce Direct Access → ALLOWED**

Likewise:

**Bronze Processor Authentication → SUCCESS**

does not imply:

**Certified Gold Modification → ALLOWED**

This distinction is fundamental to least-privilege enforcement.

### 5.7 Resource-Level Authorization

Authorization should be applied as close as practical to the protected resource.

Depending on the technology, authorization may control access to:

- databases;
- schemas;
- tables;
- views;
- Kafka topics;
- consumer groups;
- object-storage buckets or paths;
- orchestration resources;
- dashboards;
- metrics;
- metadata;
- administrative interfaces.

Broad platform access should not replace resource-specific authorization where narrower controls are available.

### 5.8 Read and Write Separation

Read and write permissions must be treated as distinct privileges.

A consumer that requires read access does not automatically require:

- INSERT;
- UPDATE;
- DELETE;
- DDL;
- publication;
- administrative operations.

Likewise, a processing workload should receive only the write privileges required for its output responsibility.

This distinction is particularly important at governed publication boundaries.

### 5.9 Administrative Authorization

Administrative operations require explicit elevated authorization.

Representative administrative actions include:

- changing security configuration;
- managing identities or permissions;
- modifying infrastructure configuration;
- managing Kafka administrative resources;
- changing database security;
- altering certificates or security-sensitive configuration;
- performing privileged recovery operations.

Administrative authorization should remain distinguishable from routine workload access.

### 5.10 Authorization at the Certified Gold Boundary

Certified Gold is a governed consumption boundary.

Ordinary analytical consumers should normally receive read access only.

Modification, replacement, certification, or publication of Certified Gold requires separate authority.

The intended model is:

**Gold Candidate**
→ validated and reconciled.

**Certification Authority**
→ determines whether publication criteria are satisfied.

**Publication Authority**
→ publishes the approved state.

**Analytical Consumer**
→ reads the certified state.

The same technical implementation may perform more than one responsibility in Version 1, but the authorization boundaries remain logically distinct.

### 5.11 Authorization and Sensitive Data

Authorization must consider data sensitivity as well as technical resource access.

Permission to access a dataset does not automatically justify access to every sensitive attribute it contains.

Where supported and required, access may be restricted through mechanisms such as:

- governed views;
- reduced datasets;
- column-level controls;
- masked representations;
- separate analytical products.

Classification and privacy requirements are defined in Chapters 9 and 10.

### 5.12 Authentication and Authorization Failures

Authentication and authorization failures are expected security outcomes when access is invalid or prohibited.

Representative conditions include:

- invalid credential;
- expired credential;
- revoked credential;
- disabled identity;
- unauthorized resource;
- unauthorized operation;
- insufficient privilege.

A denied prohibited operation is a successful enforcement result.

Failures should be observable where technically supported without exposing secret values.

### 5.13 Credential Rotation and Authentication Continuity

Credential rotation must preserve legitimate authentication while invalidating credentials that should no longer be trusted.

A representative lifecycle is:

**Credential V1 → Replacement V2 → Workload Transition → V1 Revocation**

After successful transition:

**V2 → ACCEPTED**

**V1 → REJECTED**

Rotation behavior must be validated where implemented.

Detailed credential lifecycle requirements are defined in Chapter 6.

### 5.14 Revocation

Revocation removes trust from an identity, credential, certificate, token, permission, or equivalent access mechanism.

Where applicable, revocation should take effect without requiring unrelated platform redesign.

Examples include:

- disabling a human identity;
- revoking a service credential;
- removing a permission;
- invalidating a certificate;
- removing temporary elevated access.

Recovery must not silently restore revoked trust.

### 5.15 Authentication and Authorization Testing

Authentication and authorization controls must be tested through both positive and negative scenarios where practical.

Representative positive tests include:

- valid identity authenticates successfully;
- authorized service accesses its required resource;
- approved analytical consumer reads Certified Gold.

Representative negative tests include:

- invalid or revoked credential is rejected;
- authenticated identity is denied an unauthorized resource;
- read-only consumer cannot modify data;
- service identity cannot cross an unauthorized layer boundary.

Detailed test design and evidence requirements are defined in Chapter 17.

### 5.16 Authentication and Authorization Evidence

Validation evidence should preserve enough context to demonstrate:

- identity or role tested;
- target resource;
- requested operation;
- expected result;
- observed result;
- relevant security event;
- PASS or FAIL.

Evidence must not expose reusable credentials or unnecessary sensitive information.

### 5.17 Laboratory and Enterprise Authentication

Version 1 may use local authentication mechanisms appropriate to a controlled laboratory.

The laboratory should still demonstrate the logical properties of:

- identifiable access;
- authentication;
- authorization;
- least privilege;
- denial of prohibited operations;
- credential rotation or revocation where implemented;
- auditability.

Enterprise environments may replace local mechanisms with centralized identity, managed workload identity, multi-factor authentication, privileged-access management, or equivalent controls.

The mechanism may evolve while the required authentication and authorization boundaries remain stable.

### 5.18 Authentication and Authorization Guarantees

The Atlas Engineering authentication and authorization model must preserve the following guarantees:

1. authentication and authorization remain distinct controls;
2. successful authentication does not imply unrestricted access;
3. human and service authentication remain attributable where technically practical;
4. trust does not propagate automatically across service boundaries;
5. authorization is scoped to required resources and operations;
6. read, write, administrative, certification, publication, and consumption privileges remain distinguishable;
7. administrative operations require explicit elevated authorization;
8. Certified Gold modification and publication remain distinct from ordinary analytical consumption;
9. data sensitivity may further restrict otherwise valid resource access;
10. invalid, expired, revoked, or unauthorized access is rejected where the implemented mechanism supports enforcement;
11. prohibited access denial is treated as successful security behavior;
12. credential rotation invalidates superseded trust where implemented;
13. revoked trust is not silently restored through recovery;
14. positive and negative authorization behavior can be validated;
15. evidence demonstrates results without exposing reusable credentials;
16. laboratory mechanisms may evolve without redefining the fundamental authentication and authorization boundaries.

---

## 6. Secrets and Credential Management

Secrets and credentials provide access to protected platform resources and therefore require controls throughout their lifecycle.

Atlas Engineering treats secret material as security-sensitive information rather than ordinary application configuration.

The governing lifecycle is:

**Creation → Protected Storage → Controlled Distribution → Use → Rotation → Revocation → Disposal**

A credential that has been exposed or invalidated must not regain trust merely because it remains available in source control, configuration history, backups, logs, or recovery artifacts.

### 6.1 Secret Classification

Secret material includes information that can authenticate an identity, establish privileged trust, decrypt protected information, or otherwise enable unauthorized access if disclosed.

Examples include:

- passwords;
- API tokens;
- access keys;
- private keys;
- client secrets;
- credential-bearing connection strings;
- certificate private-key material;
- equivalent authentication secrets.

Public identifiers, usernames, certificate public material, and non-sensitive configuration are not automatically secrets.

Classification depends on whether disclosure creates security risk.

### 6.2 Secrets Must Not Be Committed

Real secrets must not be intentionally committed to source control.

This applies to:

- source code;
- SQL scripts;
- orchestration definitions;
- infrastructure configuration;
- notebooks;
- documentation;
- test files;
- examples;
- exported configuration.

Repository history must also be considered because removing a secret from the current version does not remove previous exposure.

A committed working credential must be treated as potentially compromised.

### 6.3 Secret References

Source-controlled configuration should reference secrets rather than contain their real values.

For example:

`SQL_PASSWORD=<provided externally>`

`KAFKA_PASSWORD=<provided externally>`

`MINIO_SECRET_KEY=<provided externally>`

The repository may document:

- required secret names;
- expected purpose;
- responsible service;
- configuration structure;
- provisioning instructions.

It must not require publication of the real secret value.

### 6.4 Environment Variables

Environment variables may be used as a Version 1 secret-injection mechanism when appropriate to the local laboratory.

They separate runtime values from committed configuration, but they are not inherently secure merely because they are environment variables.

Their protection still depends on:

- host access;
- process isolation;
- logging behavior;
- orchestration configuration;
- operating-system controls.

Environment variables are therefore an implementation mechanism, not the security architecture itself.

### 6.5 Secret Storage

Secret storage must match the deployment environment and sensitivity of the protected resource.

Version 1 may use protected local mechanisms appropriate to a controlled laboratory.

Enterprise environments may use centralized secrets-management platforms.

Regardless of mechanism, secret storage should prevent unnecessary disclosure and restrict access to the identities that require the secret.

### 6.6 Service-Specific Credentials

Independent service responsibilities should use separate credentials where practical.

For example:

**Debezium Credential**
→ source capture responsibilities.

**Bronze Processor Credential**
→ Kafka consumption and Bronze persistence.

**Silver Processor Credential**
→ Bronze read and Silver write.

**Power BI Credential**
→ governed analytical consumption.

One unrestricted credential should not become the default authentication mechanism for unrelated platform services.

### 6.7 Credential Scope

Credentials should grant only the access required by the identity and responsibility they represent.

Scope may include:

- resource;
- operation;
- dataset;
- architectural layer;
- environment;
- validity period.

Credential possession must not imply broader authorization than the associated responsibility requires.

### 6.8 Credential Rotation

Credentials must be replaceable without redesigning the service that uses them.

A representative rotation lifecycle is:

**Credential V1 → Create V2 → Distribute V2 → Validate V2 → Revoke V1**

Where operationally practical, rotation should preserve legitimate service continuity while reducing the period during which superseded credentials remain valid.

### 6.9 Credential Revocation

Credentials must be revocable when trust should end.

Relevant conditions include:

- suspected exposure;
- confirmed compromise;
- service retirement;
- identity removal;
- privilege change;
- credential replacement;
- environment decommissioning.

Revocation must invalidate future use according to the capabilities of the implemented authentication mechanism.

### 6.10 Secret Exposure

A secret must be treated as exposed when confidentiality can no longer reasonably be assumed.

Response may require:

**Detect → Contain → Revoke → Replace → Investigate → Validate**

Changing the location of an exposed secret without invalidating it does not restore trust.

### 6.11 Source-Control Exposure

A working secret committed to source control must be treated as potentially compromised even if the repository is private or the file is later deleted.

Remediation should include, where applicable:

- revoking or rotating the secret;
- removing the secret from current files;
- evaluating repository history;
- identifying affected resources;
- validating replacement credentials.

Repository cleanup does not replace credential revocation.

### 6.12 Secrets in Logs and Observability

Logs, metrics, traces, dashboards, and alerts must not intentionally expose reusable secret values.

Applications and platform components should avoid recording:

- passwords;
- tokens;
- private keys;
- full credential-bearing connection strings;
- equivalent reusable authentication material.

Observability should describe security events without reproducing the secret involved.

### 6.13 Secrets in Evidence

Validation evidence must not contain reusable secrets.

Screenshots, terminal output, logs, configuration excerpts, and test artifacts must be reviewed before publication or long-term preservation.

Where redaction is required, the evidence should retain enough context to demonstrate the tested behavior without revealing the protected value.

### 6.14 Secrets in Documentation and Examples

Documentation and examples must use placeholders, synthetic values, or clearly invalid credentials.

For example:

`DB_PASSWORD=<SECRET>`

`KAFKA_USERNAME=<SERVICE_ACCOUNT>`

Examples must not encourage copying real credentials into source-controlled files.

### 6.15 Backup and Recovery of Secrets

Backup strategy must consider whether secret material is required for recovery.

Secrets should not be copied into ordinary backups merely for convenience.

Where protected credential or key material must be recoverable, its recovery mechanism must preserve appropriate confidentiality and access restrictions.

A backup containing security-sensitive material must itself be protected accordingly.

### 6.16 Secret Recovery and Invalidated Trust

Recovery must not restore trust in a credential that was revoked, compromised, expired, or otherwise invalidated after the recovery point was created.

The governing rule is:

**Recover Configuration ≠ Restore Historical Trust**

Current security state takes precedence over obsolete credential state preserved in backups or historical configuration.

### 6.17 Secret Ownership

Each operational secret should have an identifiable owner or responsible service where practical.

Ownership should make it possible to determine:

- what uses the secret;
- which resource it protects;
- who or what is responsible for rotation;
- when it can be revoked;
- what may be affected by replacement.

Unowned credentials create operational and security risk.

### 6.18 Secret Inventory and Metadata

The platform should maintain enough metadata to govern important credentials without recording their values.

Relevant metadata may include:

- secret identifier or logical name;
- responsible service;
- protected resource;
- environment;
- credential type;
- owner;
- lifecycle state;
- rotation requirement;
- expiration where applicable.

Secret inventory must describe secrets without becoming another secret repository.

### 6.19 Secret Lifecycle

Secret management covers the complete lifecycle:

**Create → Store → Distribute → Use → Review → Rotate → Revoke → Dispose**

Lifecycle controls should prevent obsolete credentials from remaining indefinitely valid or undocumented.

Credential state must remain consistent with the identity and access model it supports.

### 6.20 Laboratory Secret Management

Version 1 may use locally protected files, environment variables, service-specific credentials, source-control exclusions, and other mechanisms appropriate to a controlled laboratory.

The laboratory should demonstrate the architectural properties of:

- externalized secrets;
- service-specific credentials;
- scoped access;
- rotation;
- revocation;
- exposure response;
- secret-safe evidence.

The laboratory does not claim equivalence to enterprise secrets-management infrastructure.

### 6.21 Enterprise Evolution

Enterprise deployment may introduce capabilities such as:

- centralized secret vaults;
- managed cloud secret stores;
- short-lived credentials;
- dynamic credentials;
- managed workload identities;
- automated rotation;
- certificate lifecycle automation;
- hardware-backed key protection;
- centralized secret-access auditing.

These mechanisms strengthen implementation while preserving the same lifecycle and least-privilege requirements.

### 6.22 Secret Scanning

Source-controlled artifacts should be capable of being checked for accidental secret exposure.

Scanning may include:

- repository content;
- configuration files;
- scripts;
- documentation;
- generated artifacts.

Automated scanning is valuable but does not guarantee that no secret exists.

A detected working secret requires remediation of the credential itself, not only removal of the detected text.

### 6.23 Secrets and Credential Testing

Secret-management controls should be tested where practical.

Representative tests include:

- required service authenticates with its valid credential;
- unrelated service cannot use that credential outside its intended scope;
- replacement credential works after rotation;
- superseded credential fails after revocation;
- repository and evidence artifacts do not expose working secrets;
- recovery does not reactivate invalidated credentials.

Detailed security-test structure is defined in Chapter 17.

### 6.24 Secrets and Credential Evidence

Evidence should demonstrate the behavior of secret-management controls without revealing secret values.

Relevant evidence may include:

- successful authentication with a valid credential;
- failed authentication after revocation;
- rotation sequence;
- secret-scanning result;
- sanitized configuration;
- audit event;
- recovery validation.

Evidence must demonstrate the control rather than the credential itself.

### 6.25 Secrets and Credential Guarantees

The Atlas Engineering secrets and credential model must preserve the following guarantees:

1. real secrets are not intentionally committed to source control;
2. source-controlled configuration references secrets rather than publishing their values;
3. environment variables are treated as an injection mechanism rather than a complete security solution;
4. secret storage is appropriate to the deployment environment and protected resource;
5. independent service responsibilities use separate credentials where practical;
6. credentials remain scoped to their intended responsibility;
7. credentials can be rotated and revoked according to the implemented mechanism;
8. exposed credentials are treated as potentially compromised;
9. removing an exposed secret from a file does not independently restore trust;
10. logs, observability, documentation, and evidence do not intentionally expose reusable secrets;
11. backup and recovery preserve protection of required security material;
12. recovery does not restore invalidated credentials to trusted state;
13. important secrets have identifiable ownership and lifecycle metadata where practical;
14. secret inventory does not contain the secret values it governs;
15. laboratory mechanisms demonstrate the logical secret-management model without being represented as enterprise vaulting;
16. enterprise mechanisms may strengthen secret management without changing the fundamental lifecycle requirements;
17. secret scanning supports detection but does not replace credential remediation;
18. implemented secret controls can be tested and evidenced without exposing the protected values.

---

## 7. Network and Service Communication Security

Network and service communication security defines how Atlas Engineering components communicate across explicit trust boundaries.

The existence of network connectivity does not establish trust or authorization.

The governing model is:

**Required Communication → Controlled Exposure → Authenticated Endpoint → Authorized Interaction → Observable Result**

Communication paths should exist because an architectural responsibility requires them, not merely because components are technically capable of reaching one another.

### 7.1 Network Exposure

Platform components should expose only the network interfaces and ports required for their defined responsibilities.

Unnecessary exposure increases attack surface and weakens architectural boundaries.

Exposure decisions should consider:

- communicating service;
- required protocol;
- source and destination;
- administrative requirements;
- analytical consumption;
- observability;
- deployment environment.

A service being reachable does not imply that every reachable identity is authorized to use it.

### 7.2 Service Communication Paths

Required communication paths should be identifiable from the architecture.

Representative Version 1 paths include:

**AtlasCommerce / SQL Server → Debezium**
→ change capture.

**Debezium → Apicurio Registry**
→ event-contract interaction where required.

**Debezium → Kafka**
→ event publication.

**Kafka → Bronze Processing**
→ event consumption.

**Bronze Processing → MinIO Bronze**
→ durable raw persistence.

**MinIO Bronze → Silver Processing**
→ transformation input.

**Silver Processing → MinIO Silver**
→ trusted persistence.

**MinIO Silver → Gold Processing**
→ dimensional-processing input.

**Gold Processing → SQL Server Gold**
→ candidate production.

**Certification / Publication → Certified Gold**
→ governed analytical publication.

**Certified Gold → Power BI**
→ analytical consumption.

**Platform Components → Observability**
→ metrics, logs, and operational signals.

Communication outside documented paths requires explicit architectural justification.

### 7.3 Explicit Trust Boundaries

Each service relationship crosses a trust boundary that must be evaluated independently.

Relevant considerations include:

- identity;
- authentication;
- authorization;
- protocol;
- endpoint;
- network exposure;
- data classification;
- encryption;
- auditability.

Trust in one relationship must not automatically propagate to another.

For example:

**Debezium trusted to read required CDC data**

does not imply:

**Debezium trusted to administer SQL Server**

or:

**Debezium trusted to administer Kafka**.

### 7.4 Network Segmentation

Network segmentation should reduce unnecessary communication between components.

Version 1 may use logical mechanisms such as:

- container networks;
- host firewall rules;
- localhost binding;
- selective port publication.

Enterprise implementations may use stronger physical or virtual segmentation.

The architectural requirement remains:

**Only required communication paths should be available.**

### 7.5 East-West and North-South Communication

Atlas Engineering distinguishes conceptually between:

**East-West Communication**
→ communication among internal platform components.

**North-South Communication**
→ communication entering or leaving the platform boundary.

Examples of east-west communication include:

- Debezium → Kafka;
- processing services → MinIO;
- Airflow → processing services;
- platform components → observability services.

Examples of north-south communication may include:

- Power BI → Certified Gold;
- administrative access from an operator;
- approved external integrations.

Both directions require controlled trust boundaries.

Internal communication must not be considered inherently trusted merely because it remains inside the platform.

### 7.6 Public Exposure

Core processing and storage services should not be publicly exposed unless a documented requirement exists.

Components such as:

- Kafka;
- MinIO;
- internal processing services;
- orchestration internals;
- administrative database endpoints;

should normally remain within controlled network boundaries.

A service intended for internal platform use should not become externally reachable merely for convenience.

### 7.7 Administrative Interfaces

Administrative interfaces require stronger access consideration than ordinary service communication.

Examples may include:

- database administration;
- Kafka administration;
- object-storage administration;
- orchestration administration;
- observability administration;
- security configuration.

Administrative interfaces should be exposed only where required and protected by appropriate authentication and authorization.

Routine workloads should not require administrative network access.

### 7.8 Encryption in Transit

Encryption in transit protects data and credentials while crossing communication boundaries.

Its necessity should be evaluated according to:

- data sensitivity;
- trust boundary;
- network exposure;
- authentication mechanism;
- deployment environment;
- applicable requirements.

Local deployment does not automatically eliminate the need to evaluate transport protection.

Where transport encryption is not implemented in Version 1, the limitation must remain explicit.

### 7.9 TLS and Certificate Trust

Where TLS is implemented, security depends not only on encryption but also on appropriate certificate validation.

Relevant controls may include:

- trusted certificate authorities;
- certificate validity;
- hostname or endpoint validation;
- expiration monitoring;
- secure protocol configuration.

A connection that succeeds only because certificate validation is disabled must not be represented as fully validated TLS security.

### 7.10 Mutual Authentication

Some enterprise communication paths may require both endpoints to authenticate each other.

Mutual TLS or equivalent mechanisms may provide stronger service-to-service trust where appropriate.

Version 1 does not require mutual authentication for every internal communication path.

The architectural requirement is that authentication strength remains appropriate to the trust boundary and risk being protected.

### 7.11 Credential Protection During Transport

Authentication material must not be unnecessarily exposed during network communication.

Credentials should not be:

- transmitted through unprotected channels where protection is required;
- embedded unnecessarily in URLs;
- exposed in query strings;
- reproduced in logs;
- included in error messages.

Transport protection and secret management must work together.

Encryption protects credentials in transit; it does not correct poor credential handling at the endpoints.

### 7.12 DNS, Hostnames, and Endpoint Configuration

Service endpoints should be defined through controlled configuration rather than unnecessary hard-coded assumptions.

Endpoint configuration may include:

- hostname;
- port;
- protocol;
- service name;
- environment-specific address.

This supports environment evolution without changing the logical communication architecture.

Endpoint configuration must not contain secret material when a separate secret mechanism is appropriate.

### 7.13 Orchestration Communication

Airflow requires communication with the services or workloads it coordinates.

Orchestration access should be limited to the interfaces required to:

- trigger processing;
- inspect execution state;
- obtain required operational information;
- coordinate dependencies.

Airflow does not automatically require unrestricted administrative access to every component it orchestrates.

Orchestration responsibility and platform administration remain distinct.

### 7.14 Observability Communication

Metrics, logs, health information, and other operational signals require communication between platform components and observability services.

Observability paths should expose only the information required for monitoring and investigation.

They must not become an uncontrolled path for:

- secret disclosure;
- unnecessary personal data;
- business-data replication;
- administrative access.

Observability connectivity does not imply administrative authority over the monitored component.

### 7.15 Analytical Consumer Communication

Analytical consumers should communicate through governed consumption interfaces.

For Version 1:

**Power BI → Certified Gold**

is the intended analytical communication boundary.

Power BI should not require direct network access to Kafka, Bronze, Silver, or internal processing services for ordinary analytical consumption.

This reduces coupling and limits unnecessary platform exposure.

### 7.16 Network Failure Behavior

Network failure must be treated as an operational condition rather than a reason to bypass security controls.

Examples include:

- temporary SQL Server unavailability;
- Kafka connectivity loss;
- MinIO connectivity loss;
- registry unavailability;
- observability connectivity failure;
- Certified Gold connectivity failure.

Recovery should restore the intended communication path.

It should not rely on permanently opening broader network access, disabling authentication, or bypassing certificate validation merely to restore connectivity.

### 7.17 Network and Communication Observability

Communication failures and relevant security conditions should be observable where technically supported.

Useful signals may include:

- connection failures;
- authentication failures;
- TLS failures;
- certificate expiration;
- unreachable endpoints;
- repeated denied connections;
- unexpected exposure;
- abnormal communication patterns.

Detailed security observability requirements are defined in Chapter 14.

### 7.18 Communication Inventory

The platform should be capable of documenting significant communication relationships.

A communication inventory may record:

- source;
- destination;
- protocol;
- port;
- purpose;
- authentication mechanism;
- encryption state;
- responsible service;
- environment.

The inventory should describe required communication without exposing secret values.

It can later support architecture review, troubleshooting, security validation, and enterprise migration.

### 7.19 Network Change Governance

Changes that create or modify communication paths should be evaluated for security impact.

Examples include:

- exposing a new port;
- adding an external consumer;
- changing a protocol;
- disabling TLS;
- adding an administrative interface;
- changing network segmentation;
- introducing a new service dependency.

A technically successful connection is not sufficient justification for making the path permanent.

### 7.20 Laboratory Network Model

Version 1 may run several components on one physical workstation.

Logical boundaries may therefore rely on:

- container isolation;
- controlled host-port publication;
- local firewall behavior;
- service authentication;
- explicit endpoint configuration.

This topology cannot reproduce every enterprise network-security control.

It can still demonstrate the logical principles of controlled exposure, explicit communication paths, authentication, authorization, and observable failure.

### 7.21 Enterprise Evolution

Enterprise deployment may strengthen network and communication security through capabilities such as:

- private subnets;
- security groups;
- firewall policies;
- network access-control lists;
- private endpoints;
- controlled ingress and egress;
- service meshes;
- managed certificate infrastructure;
- network-flow monitoring;
- zero-trust network access.

These mechanisms may replace laboratory controls without changing the fundamental communication relationships defined by the architecture.

### 7.22 Network and Communication Testing

Network controls should be tested through required and prohibited communication scenarios where practical.

Representative tests include:

- required service reaches its approved endpoint;
- unnecessary port is not externally reachable;
- unauthorized identity cannot use a reachable service;
- protected TLS connection succeeds with valid trust;
- invalid certificate is rejected where validation is required;
- analytical consumer reaches Certified Gold without requiring upstream processing access;
- service recovers after temporary network interruption without weakening security controls.

Detailed validation methodology is defined in Chapter 17.

### 7.23 Network and Communication Evidence

Evidence should demonstrate communication behavior without exposing credentials or unnecessary sensitive configuration.

Relevant evidence may include:

- successful required connection;
- rejected prohibited connection;
- port-exposure state;
- TLS validation result;
- service log;
- network-related metric;
- recovery result;
- sanitized communication inventory.

Evidence must identify the tested boundary and expected behavior.

### 7.24 Network and Service Communication Guarantees

The Atlas Engineering network and service communication model must preserve the following guarantees:

1. communication paths exist for defined architectural responsibilities;
2. network reachability does not imply trust or authorization;
3. unnecessary service exposure is avoided;
4. trust is evaluated independently at each service boundary;
5. internal communication is not automatically considered trusted;
6. network segmentation limits unnecessary communication where technically practical;
7. core processing and storage services are not publicly exposed without documented justification;
8. administrative interfaces remain distinct from routine service communication;
9. transport encryption is evaluated according to risk and trust boundary;
10. TLS claims require appropriate certificate validation where implemented;
11. credential handling remains protected at both transport and endpoint boundaries;
12. endpoint configuration remains separable from secret values where appropriate;
13. orchestration access does not automatically imply unrestricted platform administration;
14. observability communication does not become an uncontrolled sensitive-data or administrative path;
15. analytical consumers use governed consumption boundaries rather than unnecessary upstream connectivity;
16. network failure does not justify permanently weakening security controls;
17. relevant communication and security failures remain observable where technically supported;
18. significant communication relationships can be documented without exposing secrets;
19. communication changes are subject to security review;
20. laboratory physical constraints do not redefine logical communication boundaries;
21. enterprise network mechanisms may strengthen enforcement without changing the fundamental architecture;
22. required and prohibited communication behavior can be tested and evidenced where practical.

---

## 8. Data Protection and Encryption

Data protection defines how Atlas Engineering protects information throughout its lifecycle.

Protection requirements apply while data is:

- captured;
- transmitted;
- persisted;
- transformed;
- consumed;
- backed up;
- exported;
- retained;
- recovered;
- disposed of.

Encryption is one protection mechanism within this broader model.

The governing principle is:

**Required Data → Classification → Appropriate Protection → Controlled Access → Governed Lifecycle**

Protection must reflect the sensitivity, purpose, location, exposure, and lifecycle of the data rather than relying on one universal control.

### 8.1 Data Protection Scope

Data protection applies wherever platform information exists or moves.

Relevant locations include:

- AtlasCommerce;
- CDC structures;
- events;
- Kafka;
- Bronze;
- Silver;
- Gold;
- Certified Gold;
- temporary artifacts;
- quarantine;
- backups;
- logs;
- metrics;
- metadata;
- validation evidence;
- exported data.

Protection requirements may differ between these locations.

A dataset does not automatically require identical controls at every stage of its lifecycle.

### 8.2 Protection According to Data Classification

Protection mechanisms must be selected according to the classification and purpose of the data.

Relevant factors may include:

- personal or sensitive content;
- confidential business information;
- security-sensitive information;
- analytical purpose;
- operational or historical use;
- recovery requirements;
- external exposure;
- applicable privacy, contractual, organizational, or regulatory requirements.

Classification must influence handling decisions rather than exist only as descriptive metadata.

The classification model is defined in Chapter 9.

### 8.3 Encryption in Transit

Data must be evaluated for protection while moving between platform components.

Relevant communication paths include:

- SQL Server → Debezium;
- Debezium → Kafka;
- Kafka → consumers;
- processing workloads → MinIO;
- processing workloads → SQL Server;
- orchestration communication;
- observability communication;
- Certified Gold → analytical consumers.

Where encryption in transit is required, the implementation must use protection appropriate to the protocol, trust boundary, data sensitivity, and deployment environment.

Transport protection applies to both data and credentials carried by the connection.

Detailed communication-security requirements are defined in Chapter 7.

### 8.4 Encryption at Rest

Persisted data must be evaluated for protection at rest.

Relevant persistence locations include:

- SQL Server data and log files;
- Kafka persisted records;
- MinIO objects;
- Bronze and Silver datasets;
- Gold and Certified Gold structures;
- backups;
- temporary artifacts;
- security-sensitive metadata.

Encryption at rest may be implemented at different layers, including:

- application or data level;
- database level;
- storage-service level;
- filesystem level;
- volume or disk level;
- infrastructure or cloud-service level.

The selected mechanism must reflect the deployment environment, threat model, classification, operational requirements, and technology capabilities.

### 8.5 Encryption Does Not Replace Authorization

Encryption and authorization address different risks.

Encrypted data may still be exposed if an identity has excessive permission to access it after decryption.

The security model therefore requires:

**Encryption + Authentication + Authorization + Least Privilege**

A broadly privileged identity does not become appropriately restricted merely because the underlying communication or storage is encrypted.

### 8.6 Encryption Does Not Replace Data Minimization

Encryption does not justify unnecessary collection, propagation, or retention.

For sensitive information, the preferred sequence is:

**Is the data required?**

If no:

**Do not propagate or persist it unnecessarily.**

If yes:

**Apply protection appropriate to its classification, purpose, and exposure.**

Reducing unnecessary data reduces both security risk and governance complexity.

### 8.7 Source Data Protection

AtlasCommerce is the authoritative operational source and may contain information that downstream analytical products do not require.

Source access must therefore remain independently controlled.

Change capture does not justify unrestricted access to the operational database.

The capture identity should access only the structures and operations required for its responsibility.

Sensitive attributes must be evaluated before downstream propagation.

### 8.8 Event and Kafka Data Protection

Events may contain business data and technical metadata derived from the operational source.

Event design must therefore evaluate whether each propagated attribute is required downstream.

Kafka protection must consider:

- producer and consumer authorization;
- topic scope;
- persisted event data;
- transport protection;
- retention;
- operational access;
- administrative access.

Kafka is not a security-neutral transport.

Data remains subject to protection requirements while retained in Kafka.

### 8.9 Bronze Data Protection

Bronze preserves historical source-derived events with minimal transformation.

Because Bronze may retain attributes later removed, generalized, masked, or otherwise transformed, it may contain more sensitive information than downstream analytical layers.

Bronze access should therefore remain restricted to responsibilities requiring historical, processing, recovery, governance, or authorized investigative access.

Its replay value does not justify unrestricted consumption.

### 8.10 Silver Data Protection

Silver contains standardized, normalized, deduplicated, and contract-aware data.

Transformation may reduce unnecessary exposure, but Silver remains a processing layer rather than the general analytical-consumption boundary.

Access should remain limited to workloads and roles with defined processing, validation, governance, or support responsibilities.

Sensitive attributes no longer required downstream should be removed or appropriately transformed according to the governed data design.

### 8.11 Gold Data Protection

Gold organizes data for governed analytical processing.

Not every Gold structure is necessarily appropriate for direct analytical consumption.

Internal dimensional structures, candidate states, processing metadata, reconciliation information, and certification mechanisms may require different access from the final published representation.

Gold processing and Certified Gold consumption therefore remain distinct protection boundaries.

### 8.12 Certified Gold Protection

Certified Gold is the governed analytical publication boundary.

Published datasets should expose only the attributes required for their defined analytical purpose.

Where sensitive information remains necessary, protection must consider:

- consumer purpose;
- classification;
- authorization;
- privacy requirements;
- analytical necessity.

Analytical consumers should receive the governed representation required for their purpose rather than unrestricted upstream access.

### 8.13 Temporary Data

Temporary data remains subject to protection requirements.

Examples include:

- intermediate files;
- temporary tables;
- staging objects;
- partial outputs;
- caches;
- extracted samples;
- diagnostic files.

Temporary artifacts must be considered for:

- access control;
- sensitive-data exposure;
- encryption where appropriate;
- cleanup;
- failure recovery.

Temporary status must not become an excuse for unmanaged long-term copies of governed information.

### 8.14 Quarantine Data

Quarantined records may contain the same sensitive information as successfully processed records.

Quarantine must therefore remain a governed area.

Access should be limited to responsibilities requiring:

- investigation;
- correction;
- reprocessing;
- governance;
- authorized support.

Retention and disposal requirements continue to apply.

### 8.15 Backup Protection

Backups inherit the sensitivity of the information they preserve.

Protection must consider:

- storage access;
- encryption;
- transport;
- credential protection;
- retention;
- duplication;
- restore authorization;
- secure disposal.

Where encrypted data requires cryptographic material for restoration, protection and recoverability of that material become part of the backup design.

### 8.16 Encryption Key Management

Cryptographic keys are security-sensitive assets.

Where encryption mechanisms require managed keys, their lifecycle must consider:

- generation;
- protected storage;
- authorized use;
- separation from protected data where appropriate;
- rotation;
- expiration;
- retirement;
- recovery where required;
- destruction.

The exact mechanism depends on the selected encryption technology and deployment environment.

Encryption is only as trustworthy as the protection of the keys on which it depends.

### 8.17 Key Rotation

Where supported or required, key rotation must preserve both security and legitimate data availability.

Rotation may need to consider:

- new writes;
- existing encrypted data;
- historical data;
- backups;
- recovery procedures;
- key-version identification;
- retirement of previous keys.

A key must not be destroyed while legitimately retained data still depends on it unless the data has been safely re-encrypted or is intentionally being made unrecoverable.

### 8.18 Key Recovery

Recovery planning must include required cryptographic dependencies.

A backup that cannot be decrypted because its required key is unavailable is not a usable recovery asset.

Key recovery must therefore balance:

- availability;
- confidentiality;
- integrity;
- authorization;
- separation of duties;
- auditability.

Recoverable copies of keys are themselves sensitive security assets.

### 8.19 Key Compromise

A key whose confidentiality can no longer reasonably be trusted must be treated as compromised.

Response may require:

**Contain → Replace → Re-encrypt Where Applicable → Retire or Revoke → Investigate → Validate**

Recovery must not silently restore trust in a compromised historical key.

### 8.20 Logs and Sensitive Data

Operational logs must not become uncontrolled replicas of business data.

Logging should preserve enough context for operation and investigation without unnecessarily recording complete sensitive payloads.

Where practical, diagnostic context should prefer:

- identifiers;
- correlation metadata;
- classifications;
- controlled summaries;
- protected representations.

Secrets must not be intentionally logged.

Detailed auditability requirements are defined in Chapter 14.

### 8.21 Metrics and Sensitive Data

Metrics should describe platform behavior rather than reproduce business records.

Representative metrics include:

- event counts;
- throughput;
- latency;
- error counts;
- backlog;
- quality results;
- certification status.

Labels and dimensions require particular care because record-specific or user-specific values may expose sensitive information or create unnecessary cardinality.

Personal data should not be introduced into metrics merely for troubleshooting convenience.

### 8.22 Evidence and Sensitive Data

Validation evidence must prove platform behavior without unnecessarily reproducing protected information.

Evidence may use:

- synthetic test data;
- identifiers;
- redacted values;
- sanitized logs;
- controlled screenshots;
- summarized results.

Public evidence requires particular care because repository publication changes the exposure boundary.

Evidence requirements are detailed in Chapter 17.

### 8.23 Non-Production Data

Non-production environments do not automatically require unrestricted copies of production data.

Where representative data is required for development, testing, or validation, the preferred options should be evaluated in this order where practical:

**Synthetic Data → Reduced or Transformed Data → Controlled Real Data When Justified**

Use of real sensitive data outside its operational environment requires explicit justification and appropriate protection.

The Version 1 laboratory should prefer controlled synthetic data wherever it can validate the required behavior.

### 8.24 Data Export

Exporting data creates a new copy and potentially a new protection boundary.

Exports may include:

- analytical extracts;
- CSV files;
- spreadsheets;
- troubleshooting samples;
- evidence;
- backups;
- data transfers.

Before export, the platform or responsible operator should consider:

- purpose;
- classification;
- recipient;
- required attributes;
- storage destination;
- protection;
- retention;
- disposal.

Authorization to query data does not automatically justify unrestricted export.

### 8.25 Data Protection During Recovery

Recovery operations must preserve applicable data-protection controls.

Recovery must not require permanently:

- disabling authorization;
- exposing protected storage;
- publishing sensitive data;
- restoring invalidated credentials or keys;
- bypassing governed analytical boundaries.

Temporary elevated access, where required, must remain explicit and controlled.

Restored data remains subject to the same applicable classification and protection requirements as the original governed state.

### 8.26 Data Protection and Retention

Protection responsibilities continue for as long as governed copies of the data remain retained.

Retention decisions must therefore consider:

- sensitivity;
- operational purpose;
- historical value;
- replay requirements;
- backup requirements;
- privacy requirements;
- security risk.

Longer retention increases the period during which protected information must remain governed.

Detailed retention rules are defined in Chapter 13.

### 8.27 Secure Disposal

Disposal must consider more than deletion of the active dataset.

Relevant copies may exist in:

- Kafka retention;
- Bronze history;
- backups;
- temporary artifacts;
- quarantine;
- exported files;
- evidence;
- archived storage.

The appropriate disposal mechanism depends on the storage technology, protection mechanism, retention requirement, and sensitivity of the data.

Disposal requirements are defined in greater detail in Chapter 13.

### 8.28 Laboratory Data Protection

Version 1 implements data-protection controls within the constraints of a controlled local training environment.

The laboratory should demonstrate, where applicable:

- controlled access;
- data minimization;
- separation of processing and consumption boundaries;
- protected credential handling;
- transport protection;
- at-rest protection;
- protected backups;
- controlled temporary and quarantine data;
- sensitive-data-safe logs, metrics, and evidence.

Not every enterprise encryption or key-management capability must exist locally for the architecture to be valid.

Any unimplemented control must remain explicitly distinguishable from an implemented and validated control.

### 8.29 Enterprise Evolution

Enterprise deployment may strengthen data protection through capabilities such as:

- managed encryption services;
- centralized key management;
- hardware-backed key protection;
- automated key rotation;
- managed certificate infrastructure;
- tokenization;
- pseudonymization;
- dynamic masking;
- data-loss prevention;
- enterprise backup protection;
- centralized policy enforcement.

These mechanisms may strengthen implementation without changing the fundamental data-protection boundaries.

### 8.30 Data Protection Testing

Implemented controls should be validated according to the mechanisms selected for Version 1.

Representative tests may verify:

- authorized and prohibited access to protected data;
- configured transport protection;
- at-rest protection where implemented;
- absence of unnecessary sensitive attributes downstream;
- protection of temporary and quarantine data;
- sensitive-data-safe logs and metrics;
- protected backup and restore behavior;
- controlled export;
- absence of sensitive information from public evidence.

Expected behavior must be defined before execution.

Detailed validation methodology is defined in Chapter 17.

### 8.31 Data Protection Evidence

Evidence should demonstrate the implemented protection behavior without unnecessarily reproducing the protected information.

Relevant evidence may identify:

- test identifier;
- classification;
- architectural layer;
- protection mechanism;
- expected behavior;
- observed behavior;
- access or encryption state;
- implementation version;
- conclusion.

Sensitive values should be redacted or replaced with controlled test data when their real values are unnecessary to prove the control.

### 8.32 Data Protection and Encryption Guarantees

The Atlas Engineering data-protection model must preserve the following guarantees:

1. data protection applies throughout the governed data lifecycle;
2. protection requirements reflect classification, purpose, exposure, and lifecycle;
3. encryption complements rather than replaces authentication, authorization, and least privilege;
4. encryption does not justify unnecessary propagation or retention;
5. source access remains independently controlled from downstream analytical access;
6. Kafka and Bronze remain protected persisted data locations;
7. processing layers remain distinct from the Certified Gold consumption boundary;
8. temporary and quarantine data remain governed;
9. backups inherit the protection requirements of the data they preserve;
10. cryptographic keys are protected as security-sensitive assets where applicable;
11. key lifecycle and recoverability remain consistent with encrypted-data retention;
12. compromised keys do not regain trust through recovery;
13. logs, metrics, and evidence do not intentionally become uncontrolled copies of sensitive data;
14. non-production use does not automatically justify unrestricted production data;
15. data export creates a new governed protection boundary;
16. recovery preserves applicable data-protection controls;
17. protection continues throughout the governed retention period;
18. disposal considers retained, exported, archived, and recoverable copies;
19. laboratory controls remain distinguishable from enterprise-equivalent mechanisms;
20. implemented protection controls are testable and evidence-based;
21. security claims remain limited to behavior actually implemented and validated.

---

## 9. Data Classification and Sensitive Data

Data classification defines how Atlas Engineering identifies the sensitivity of governed information and connects that sensitivity to actual handling requirements.

Classification is not merely descriptive metadata.

It must influence, where applicable:

- access;
- propagation;
- protection;
- observability;
- analytical exposure;
- retention;
- export;
- evidence;
- disposal.

The initial classification model is:

**Public → Internal → Confidential → Restricted**

Classification is evaluated according to the content, purpose, exposure, and risk of the information rather than solely according to the technology or architectural layer where it is stored.

Personal-data status, business sensitivity, and security sensitivity are related considerations but remain distinct concepts.

### 9.1 Classification Model

Atlas Engineering uses four initial security-classification levels:

1. **Public**
2. **Internal**
3. **Confidential**
4. **Restricted**

The levels represent increasing sensitivity and therefore potentially stronger handling requirements.

Classification must reflect the information itself and its intended use rather than merely its storage location.

Absence of a classification decision does not imply that data is Public.

### 9.2 Public Data

Public data is information intentionally approved for unrestricted external disclosure.

Examples may include:

- published technical documentation;
- public architecture descriptions;
- intentionally published synthetic examples;
- non-sensitive repository content.

Public classification must be explicit.

Information does not become Public merely because it exists in a demonstration or laboratory environment.

### 9.3 Internal Data

Internal data is intended for platform, engineering, operational, or organizational use but does not normally carry the same disclosure risk as Confidential or Restricted information.

Examples may include:

- non-sensitive operational metadata;
- internal processing state;
- technical configuration without credentials;
- non-sensitive quality statistics;
- non-sensitive observability information.

Internal data is not automatically appropriate for public disclosure.

Its use must still respect architectural purpose and access boundaries.

### 9.4 Confidential Data

Confidential data is information whose unauthorized disclosure may create business, privacy, operational, or security risk.

Examples may include:

- detailed business transactions;
- non-public commercial information;
- customer-related information;
- internal analytical datasets;
- detailed operational information;
- sensitive metadata.

Confidential data requires controlled access.

Technical reachability or successful authentication does not independently justify access.

### 9.5 Restricted Data

Restricted data represents the highest sensitivity level in the Atlas Engineering classification model.

Examples may include:

- authentication secrets;
- private cryptographic keys;
- security credentials;
- highly sensitive personal information where applicable;
- security-sensitive administrative information;
- information whose disclosure could directly compromise platform security.

Restricted data requires the strongest applicable handling controls.

Access must be limited to identities with an explicit operational, security, legal, or governance requirement.

Restricted values must not intentionally appear in public repositories, ordinary logs, dashboards, screenshots, or public evidence.

### 9.6 Classification Is Independent of Architectural Layer

Architectural layer and security classification are related but distinct concepts.

For example:

- Bronze may contain information at different classification levels depending on its source content;
- Silver may remove or transform sensitive attributes;
- Gold may contain Confidential analytical information;
- Certified Gold may remain Confidential despite being governed and certified for consumption.

Movement downstream does not automatically reduce sensitivity.

Classification changes only when the resulting information and its exposure characteristics justify reassessment.

### 9.7 Classification Inheritance

Derived data should retain protection appropriate to its source unless transformation demonstrably changes the sensitivity of the resulting information.

Operations such as:

- aggregation;
- masking;
- tokenization;
- pseudonymization;
- attribute removal;

may reduce exposure, but they do not automatically justify a lower classification.

Reassessment must consider what can still be identified, inferred, reconstructed, linked, or exposed.

### 9.8 Personal Data

Personal data must be identified independently from the general security-classification level.

Information may constitute personal data when it relates to an identified or identifiable natural person.

Examples may include:

- name;
- personal document identifiers;
- email address;
- telephone number;
- delivery or residential address;
- customer identifiers that can be linked to an individual;
- combinations of attributes capable of identifying an individual.

Personal-data status introduces privacy-governance requirements in addition to general security classification.

Detailed privacy requirements are defined in Chapter 10.

### 9.9 Sensitive Personal Data

Sensitive personal data must be identified separately where applicable.

The platform must not assume that every customer attribute is sensitive personal data.

The determination depends on the actual meaning of the information and applicable privacy requirements.

Where such data exists, its classification and handling must reflect the additional privacy impact associated with unauthorized processing or disclosure.

Detailed LGPD and privacy considerations are defined in Chapter 10.

### 9.10 Business-Sensitive Data

Sensitive information is not limited to personal data.

Business-sensitive information may include:

- non-public sales information;
- pricing strategies;
- detailed transaction history;
- internal performance indicators;
- unreleased analytical results;
- operational information whose disclosure could affect the organization.

Such data may require Confidential or Restricted handling even when it contains no personal information.

### 9.11 Security-Sensitive Data

Security-sensitive information is data whose disclosure may weaken platform security.

Examples include:

- credentials;
- private cryptographic material;
- security configuration;
- privileged-access information;
- vulnerability details;
- internal security investigation material;
- information that reveals sensitive defensive controls.

Security-sensitive information may require Restricted classification regardless of whether it contains personal or business data.

### 9.12 Data Classification Metadata

Classification decisions should be represented as governed metadata where practical.

Relevant metadata may include:

- dataset;
- attribute;
- classification level;
- classification rationale;
- personal-data indicator;
- sensitive-personal-data indicator where applicable;
- owner or responsible role;
- handling requirements;
- review state;
- effective version or date.

Classification metadata must describe the protected information without unnecessarily reproducing sensitive values.

### 9.13 Attribute-Level Classification

Dataset-level classification may be insufficient when individual attributes have materially different sensitivity.

For example, one dataset may contain:

- non-sensitive transaction date;
- Confidential transaction amount;
- personal customer identifier;
- Restricted security-related metadata.

Where necessary, classification should therefore be expressible at attribute level.

The effective protection of a dataset must consider its most sensitive relevant content and the controls available to separate or transform that content.

### 9.14 Classification and Data Minimization

Classification must inform decisions about whether information should propagate downstream.

For each attribute, the platform should be capable of asking:

**Is this attribute required for the next processing or analytical purpose?**

If not, unnecessary propagation should be avoided.

If yes, the required handling should reflect its classification.

Classification therefore supports minimization rather than merely documenting sensitivity after data has already spread through the platform.

### 9.15 Classification Across the Data Flow

Classification must remain meaningful as data moves through:

**Source → CDC → Event → Kafka → Bronze → Silver → Gold → Certified Gold → Consumer**

An attribute does not automatically require the same downstream representation at every stage.

Transformation may:

- preserve it;
- remove it;
- mask it;
- pseudonymize it;
- aggregate it;
- derive a less identifying representation.

Any material change in sensitivity should be evaluated rather than assumed.

### 9.16 Bronze Classification

Bronze preserves source-derived historical events with minimal transformation.

It may therefore retain information that is later removed or transformed downstream.

Bronze should be treated as a controlled historical and processing layer rather than a general analytical-consumption layer.

Its classification depends on the information it actually contains.

### 9.17 Silver Classification

Silver standardizes, normalizes, deduplicates, and validates data for downstream processing.

This layer provides an opportunity to remove or transform attributes that are no longer required.

Silver does not automatically become non-sensitive because transformation has occurred.

Its classification must reflect the resulting information after processing.

### 9.18 Gold Classification

Gold contains governed analytical structures.

Customer-level or transaction-level information may remain Confidential even when organized for analytics.

Aggregation does not automatically make a dataset Public.

Classification must consider both individual attributes and what may be inferred from their combination.

### 9.19 Certified Gold Classification

Certified Gold is a governed consumer boundary, not an unrestricted publication boundary.

Certification means that a data product has satisfied its defined processing, quality, reconciliation, and publication requirements.

It does not mean that the product is Public or non-sensitive.

Certified Gold access must continue to respect:

- classification;
- consumer purpose;
- authorization;
- privacy requirements;
- data minimization.

A certified analytical product may legitimately remain Confidential.

### 9.20 Classification and Observability

Logs, metrics, traces, dashboards, and alerts must respect data classification.

Observability should prefer operational metadata over complete business payloads.

Restricted values must not intentionally appear in ordinary observability output.

Confidential or personal information should appear only where explicitly required, justified, and appropriately protected.

Diagnostic convenience must not create an uncontrolled secondary sensitive-data repository.

Detailed observability requirements are defined in Chapter 14.

### 9.21 Classification and Evidence

Evidence artifacts inherit the sensitivity of the information they contain.

Moving information into an evidence directory does not change its classification.

Public evidence should prefer:

- synthetic data;
- redacted output;
- controlled identifiers;
- aggregate results;
- configuration without credentials;
- screenshots without sensitive values.

Evidence must prove the required behavior without unnecessarily exposing the protected information.

### 9.22 Classification and Analytical Consumption

Analytical consumers should receive only the information and classification appropriate to their defined purpose.

Different consumers of the same business domain may legitimately require different representations.

For example:

**Operational Investigation**
→ may require authorized customer-level detail.

**Sales Trend Dashboard**
→ may require only aggregated or non-identifying information.

The existence of a richer upstream dataset does not justify exposing that dataset to every analytical consumer.

### 9.23 Classification and Export

Exported data retains its classification.

For example:

**Confidential Dataset → CSV Export → Confidential Artifact**

**Restricted Value → Text Export → Restricted Artifact**

Export does not convert governed information into unmanaged non-sensitive information.

Exported artifacts remain subject to applicable:

- access controls;
- protection;
- retention;
- disposal;
- privacy requirements.

### 9.24 Classification and Retention

Classification informs retention but does not determine retention independently.

Retention decisions must consider:

**Purpose + Classification + Legal or Business Requirement + Recovery Requirement + Analytical Requirement**

Higher sensitivity may justify shorter retention when information is no longer required, while legitimate business, recovery, audit, analytical, or legal requirements may justify controlled retention.

Storage availability alone is not a valid reason for indefinite retention.

Detailed retention governance is defined in Chapter 13.

### 9.25 Classification Review

Classification must be reviewable when changes may affect sensitivity or permitted use.

Relevant triggers include:

- new datasets;
- new attributes;
- changed source semantics;
- new consumers;
- changed analytical purpose;
- new export destinations;
- changed privacy or security requirements;
- transformations that materially change sensitivity.

Classification is therefore part of change governance rather than a one-time documentation activity.

### 9.26 Classification Ownership

Classification decisions require identifiable responsibility.

Ownership must support decisions concerning:

- business meaning;
- sensitivity;
- personal-data status;
- analytical necessity;
- permitted consumers;
- retention;
- downstream propagation.

Enterprise responsibilities may involve data owners, data stewards, security, privacy or legal functions, Data Engineering, and Platform Engineering.

The Version 1 laboratory may consolidate these responsibilities under one operator while preserving their logical distinction.

### 9.27 Unknown Classification

Information whose sensitivity has not yet been determined must not automatically be treated as Public.

Where classification remains unresolved, a conservative handling approach should be applied until review is completed.

Unknown classification is a governance issue requiring resolution, not permission for unrestricted use.

### 9.28 Classification Changes

A classification change may require changes to technical or governance controls.

Potentially affected areas include:

- authorized consumers;
- storage protection;
- encryption;
- logging;
- retention;
- export;
- analytical exposure;
- evidence handling.

Changing classification metadata alone is insufficient when the new classification requires different controls.

Downstream impact must therefore be evaluated.

### 9.29 Laboratory Classification Model

Version 1 uses controlled and synthetic project data rather than real customer production data.

This reduces real-world exposure but does not eliminate the need to implement and validate classification behavior.

Representative synthetic data can demonstrate:

- classification;
- propagation decisions;
- access restrictions;
- minimization;
- observability handling;
- evidence handling.

The laboratory must not claim real-world privacy protection merely because synthetic data was used.

### 9.30 Enterprise Evolution

Enterprise implementation may strengthen classification governance through capabilities such as:

- centralized data catalogs;
- automated discovery;
- automated classification;
- sensitive-data scanning;
- lineage-integrated classification;
- policy-based access;
- data-loss-prevention controls;
- classification-based retention;
- classification-based masking;
- automated policy enforcement.

These mechanisms strengthen enforcement without changing the principle that classification must influence actual data handling.

### 9.31 Classification Testing

Implemented classification controls should be validated where practical.

Representative tests include:

- sensitive attribute receives the expected classification;
- minimized attribute does not appear in an unauthorized downstream representation;
- unauthorized consumer cannot access a classified dataset;
- Restricted values do not appear in ordinary logs;
- sensitive values are absent from public evidence;
- exported artifacts preserve applicable handling requirements;
- classification changes trigger review of affected controls.

Controlled or synthetic data should be used whenever real sensitive information is unnecessary.

Detailed validation methodology is defined in Chapter 17.

### 9.32 Classification Evidence

Evidence should demonstrate classification behavior without unnecessarily exposing the information being protected.

Relevant evidence may identify:

- dataset or attribute;
- classification level;
- rationale;
- personal-data indicator where applicable;
- expected handling;
- observed propagation;
- access result;
- downstream presence or absence;
- relevant metadata;
- implementation version;
- conclusion.

Evidence itself remains subject to classification according to its content.

### 9.33 Data Classification and Sensitive Data Guarantees

The Atlas Engineering classification model must preserve the following guarantees:

1. classification influences actual data handling;
2. absence of a classification label does not imply Public data;
3. architectural layer does not automatically determine classification;
4. derived data retains appropriate protection unless transformation justifies reassessment;
5. personal data, business-sensitive data, and security-sensitive data remain distinguishable concepts;
6. attribute-level classification is available where dataset-level classification is insufficient;
7. classification informs minimization and downstream propagation;
8. source attributes do not automatically traverse the complete data pipeline;
9. Bronze remains a controlled historical and processing layer;
10. Silver transformation may reduce but does not automatically eliminate sensitivity;
11. Gold and Certified Gold may remain Confidential;
12. certification does not imply public disclosure;
13. observability and evidence do not intentionally create uncontrolled copies of sensitive information;
14. exported information retains its classification;
15. retention considers classification together with purpose and applicable requirements;
16. unresolved classification does not imply unrestricted use;
17. classification changes trigger evaluation of affected controls;
18. classification decisions have identifiable ownership;
19. laboratory validation may use synthetic data without claiming equivalence to real production privacy conditions;
20. implemented classification behavior is testable and evidence-based.

---

## 10. LGPD and Privacy Governance

Atlas Engineering incorporates privacy governance into the architecture of the data platform.

The objective is not to claim legal or regulatory compliance solely from technical controls.

Instead, the architecture provides mechanisms that can support privacy requirements by making personal-data processing identifiable, purposeful, minimized, controlled, traceable, and governable throughout the data lifecycle.

The governing principle is:

**Identify Personal Data → Define Purpose → Minimize Processing → Control Access → Govern Lifecycle → Preserve Evidence**

Privacy requirements apply wherever personal data is collected, captured, propagated, persisted, transformed, consumed, exported, retained, recovered, or disposed of.

### 10.1 Personal Data Identification

Personal data must be identifiable within the governed data model.

Information may constitute personal data when it relates to an identified or identifiable natural person.

Examples may include:

- name;
- personal document identifiers;
- email address;
- telephone number;
- residential or delivery address;
- customer identifiers linked to an individual;
- combinations of attributes capable of identifying an individual.

Identification should occur early enough to influence downstream processing decisions.

Personal-data status is distinct from the general security-classification level defined in Chapter 9.

### 10.2 Sensitive Personal Data

Sensitive personal data requires separate identification where applicable.

The platform must not classify every customer attribute as sensitive personal data merely because it relates to an individual.

Determination depends on the meaning of the information and applicable privacy requirements.

Where sensitive personal data exists, processing, access, propagation, retention, evidence, and analytical use require additional consideration.

### 10.3 Processing Purpose

Personal data should be processed for an identifiable purpose.

Relevant purposes may include:

- operational transaction processing;
- fulfillment;
- customer support;
- financial reconciliation;
- analytical reporting;
- security investigation;
- regulatory or legal obligations where applicable.

The existence of personal data in the source does not independently establish a downstream analytical purpose.

Purpose must inform what data is propagated and who may access it.

### 10.4 Purpose Limitation

Personal data collected or processed for one purpose must not automatically be reused for unrelated purposes.

A new analytical or operational use may require review of:

- required attributes;
- intended consumers;
- processing logic;
- access;
- retention;
- privacy impact;
- applicable organizational or legal requirements.

Technical availability does not establish a valid processing purpose.

### 10.5 Data Minimization

Only personal data required for the defined purpose should be propagated, persisted, or exposed.

For each attribute, the platform should be capable of asking:

**Is this personal attribute required for the next processing or analytical purpose?**

If no:

**Do not propagate it unnecessarily.**

If yes:

**Apply the protection and governance required for its use.**

Data minimization reduces privacy exposure throughout the platform.

### 10.6 Privacy Across the Data Pipeline

Privacy requirements apply across the complete governed flow:

**Source → CDC → Event → Kafka → Bronze → Silver → Gold → Certified Gold → Consumer**

An attribute present at the source does not automatically need to reach every downstream stage.

At each relevant transformation boundary, personal data may be:

- preserved;
- removed;
- masked;
- pseudonymized;
- aggregated;
- generalized;
- replaced by a derived representation.

The resulting representation must remain appropriate to the next processing purpose.

### 10.7 Source Privacy Boundary

AtlasCommerce is the operational source and may contain personal data required for transactional business processes.

Downstream access to that information must be independently justified.

Change capture must not be interpreted as permission to replicate every source attribute.

CDC configuration and event design should include only the information required for the governed data product.

### 10.8 Kafka and Event Privacy

Events may propagate personal data beyond the operational source.

Event contracts must therefore consider:

- whether the attribute is required;
- its personal-data status;
- its sensitivity;
- intended consumers;
- retention;
- downstream propagation.

Kafka retention creates persistent copies of event data.

Personal data in Kafka remains governed personal data and must not be treated as temporary merely because Kafka is a transport component.

### 10.9 Bronze Privacy

Bronze preserves historical source-derived events and may contain personal attributes removed from later layers.

Bronze may therefore represent a higher privacy-exposure boundary than downstream analytical products.

Access should be limited to responsibilities requiring historical processing, recovery, governance, or authorized investigation.

Replay value does not justify unrestricted access to personal data.

### 10.10 Silver Privacy

Silver provides a controlled transformation boundary where unnecessary personal attributes may be removed or transformed.

Privacy-oriented processing may include:

- attribute removal;
- normalization;
- masking;
- pseudonymization;
- generalization;
- controlled derivation.

Silver does not automatically become non-personal simply because transformation has occurred.

The resulting data must be evaluated according to its actual identifiability and purpose.

### 10.11 Gold Privacy

Gold analytical structures should contain only personal data required for defined analytical or governance purposes.

Customer-level detail may remain necessary for some governed analyses, while other products may require only aggregated or non-identifying information.

The dimensional model must not become a repository for personal attributes merely because they are available upstream.

### 10.12 Certified Gold Privacy

Certified Gold is the governed analytical-consumption boundary.

Certification does not independently authorize disclosure of personal data.

Published data products must consider:

- defined analytical purpose;
- required attributes;
- intended consumers;
- authorization;
- classification;
- privacy requirements.

Where personal detail is unnecessary, Certified Gold should prefer reduced, aggregated, masked, pseudonymized, or otherwise appropriate representations.

### 10.13 Direct and Indirect Identifiers

Privacy analysis must consider both direct and indirect identification.

Direct identifiers may include information such as:

- name;
- personal document number;
- email address;
- telephone number.

Indirect identifiers may identify an individual when combined with other information.

Removing a name therefore does not automatically make a dataset anonymous.

Privacy evaluation must consider the resulting dataset as a whole.

### 10.14 Pseudonymization

Pseudonymization replaces direct identifying information with another representation while preserving some ability to relate records where required.

A pseudonymized dataset may still constitute personal data if re-identification remains reasonably possible.

Pseudonymization can reduce exposure but must not be represented as equivalent to anonymization.

Any mapping or key capable of reversing or linking the pseudonym must receive appropriate protection.

### 10.15 Anonymization

Anonymization aims to produce information that no longer identifies an individual through reasonably applicable means.

Anonymization must not be claimed merely because direct identifiers were removed.

Assessment must consider:

- remaining attributes;
- combinations of attributes;
- external information reasonably available;
- possibility of linkage or inference.

Atlas Engineering should claim anonymization only when the implemented transformation and evidence justify that conclusion.

### 10.16 Masking

Masking changes the visible representation of information to reduce exposure.

It may be useful for:

- user interfaces;
- analytical views;
- troubleshooting;
- support;
- evidence;
- non-production use.

Masking does not necessarily remove the underlying personal-data status.

The effectiveness of masking depends on what remains accessible through other paths.

### 10.17 Privacy and Access Control

Personal-data access must follow defined purpose and responsibility.

Authentication or general dataset access does not independently justify access to every personal attribute.

Where appropriate, privacy-oriented access may use:

- governed views;
- reduced datasets;
- masked representations;
- role-specific products;
- column-level controls;
- separate consumer interfaces.

Privacy and least privilege must operate together.

### 10.18 Privacy and Observability

Logs, metrics, traces, dashboards, and alerts must not become unnecessary secondary repositories of personal data.

Observability should prefer:

- technical identifiers;
- correlation identifiers;
- counts;
- status;
- controlled diagnostic metadata.

Complete personal values should not be recorded merely for troubleshooting convenience.

Where personal data is genuinely required for investigation, access and retention must remain controlled.

### 10.19 Privacy and Lineage

Lineage should make it possible to understand where governed personal data originates, how it is transformed, and where it is consumed.

Relevant lineage may describe:

**Source Attribute → Event Field → Bronze Field → Silver Field → Gold Attribute → Certified Product**

Lineage should support questions such as:

- where does this personal attribute originate?
- where does it propagate?
- where is it transformed?
- which products depend on it?
- which consumers may receive it?

Lineage metadata should not unnecessarily reproduce the personal values themselves.

### 10.20 Privacy and Metadata

Privacy governance requires metadata capable of describing personal-data handling.

Relevant metadata may include:

- personal-data indicator;
- sensitive-personal-data indicator where applicable;
- processing purpose;
- classification;
- owner;
- transformation;
- retention requirement;
- permitted consumer;
- lineage;
- privacy review state.

Metadata should describe governance decisions rather than duplicate the protected data.

### 10.21 Data Accuracy and Correction

Privacy governance may require inaccurate personal information to be corrected according to applicable requirements and source-of-truth responsibilities.

The analytical platform should not silently redefine authoritative operational records.

Where source information is corrected, downstream processing must be capable of reflecting the corrected governed state according to the architecture.

Historical preservation requirements must be considered separately from correction of the current authoritative representation.

### 10.22 Data-Subject Requests

The architecture should support investigation of data-subject requests where applicable.

Potential requests may involve:

- confirmation of processing;
- access;
- correction;
- deletion or anonymization;
- information about use or sharing;
- other rights applicable to the processing context.

The platform architecture alone does not determine whether a specific request must legally be fulfilled or how it must be fulfilled.

Those decisions require the applicable organizational and legal process.

The technical architecture should make relevant data locations, lineage, transformations, consumers, and retention states identifiable enough to support that process.

### 10.23 Deletion and Erasure

Deletion of personal data must be evaluated across all governed copies rather than only the current analytical table.

Potential locations include:

- operational source;
- CDC history;
- Kafka retention;
- Bronze;
- Silver;
- Gold;
- Certified Gold;
- quarantine;
- temporary artifacts;
- backups;
- exports;
- evidence.

The appropriate action may differ by storage technology, processing purpose, retention obligation, and legal or organizational requirement.

Deletion must not be represented as complete until the defined scope and applicable retained copies have been considered.

### 10.24 Deletion Versus Historical Integrity

Privacy deletion requirements may interact with legitimate historical, accounting, audit, recovery, or analytical requirements.

The architecture must not resolve this tension through arbitrary technical deletion.

Possible technical treatments may include, where appropriate:

- removal;
- anonymization;
- pseudonymization;
- restricted retention;
- exclusion from active consumption;
- delayed physical disposal according to governed retention.

The correct treatment depends on the processing context and applicable requirements.

Technical capability does not independently determine legal permissibility.

### 10.25 Privacy and Backups

Backups may contain historical copies of personal data.

Privacy governance must therefore consider:

- backup retention;
- restore behavior;
- access;
- protection;
- eventual expiration or disposal.

Deleting information from the active platform does not automatically remove it from existing backups.

Where retained backups legitimately preserve older data, recovery procedures must avoid unintentionally reintroducing obsolete personal information into active governed state without appropriate processing.

### 10.26 Privacy and Replay

Replay can reintroduce historical personal data into downstream layers.

Replay procedures must therefore respect:

- current transformation rules;
- current minimization requirements;
- current privacy controls;
- applicable deletion or anonymization state;
- current certification rules.

Historical raw data must not automatically override later privacy-governance decisions.

### 10.27 Privacy and Data Retention

Personal data should not be retained indefinitely merely because storage is available.

Retention must consider:

- processing purpose;
- business requirement;
- analytical requirement;
- recovery requirement;
- privacy requirement;
- applicable legal or regulatory requirement;
- security risk.

Different architectural layers may legitimately have different retention periods.

Detailed retention governance is defined in Chapter 13.

### 10.28 Privacy and Data Export

Exporting personal data creates another governed copy and potentially another exposure boundary.

Before export, relevant considerations include:

- purpose;
- recipient;
- required attributes;
- classification;
- protection;
- retention;
- disposal;
- applicable privacy requirements.

Authorization to query personal data does not automatically justify unrestricted export.

Where full detail is unnecessary, reduced or transformed representations should be preferred.

### 10.29 Privacy Incident Considerations

Unauthorized exposure, access, alteration, loss, or inappropriate processing of personal data may constitute a privacy-relevant incident.

The technical response should support:

- detection;
- containment;
- scope identification;
- affected-data identification;
- lineage analysis;
- evidence preservation;
- recovery;
- post-incident review.

Whether an event creates legal notification or other regulatory obligations depends on the applicable context and must not be determined solely by this architecture document.

Security incident handling is detailed in Chapter 15.

### 10.30 Privacy by Design

Privacy must be considered when new data flows, datasets, attributes, transformations, and analytical products are designed.

Relevant design questions include:

- Is personal data required?
- What purpose requires it?
- Can fewer attributes satisfy that purpose?
- Can aggregation or transformation reduce exposure?
- Which identities require access?
- How long is the data required?
- Where will it propagate?
- What happens during replay, recovery, export, and disposal?

Privacy review is therefore part of architecture and data-product design rather than an activity performed only after implementation.

### 10.31 Privacy Governance for New Data Products

A new data product that processes personal data should define, where applicable:

- business purpose;
- personal-data attributes;
- sensitivity;
- required transformations;
- intended consumers;
- access requirements;
- lineage;
- retention;
- export expectations;
- evidence requirements.

A product should not inherit every upstream personal attribute merely because those attributes are technically available.

The minimum governed representation required for the product should be preferred.

### 10.32 Laboratory Privacy Model

Version 1 uses controlled synthetic project data rather than real production customer data.

The laboratory can therefore validate technical privacy behavior without requiring real personal information.

Representative tests may demonstrate:

- personal-data identification;
- minimization;
- attribute removal;
- masking;
- pseudonymization;
- access restrictions;
- lineage;
- retention behavior;
- replay behavior;
- privacy-safe evidence.

Synthetic data reduces real-world exposure but does not prove legal compliance or enterprise privacy maturity.

### 10.33 Enterprise Evolution

Enterprise implementation may strengthen privacy governance through capabilities such as:

- centralized data catalogs;
- privacy inventories;
- automated personal-data discovery;
- policy-based access;
- consent or preference management where applicable;
- formal data-subject-request workflows;
- automated retention enforcement;
- masking and tokenization platforms;
- privacy-impact assessments;
- data-loss prevention;
- centralized privacy auditing.

These capabilities may strengthen governance without changing the architectural principles of purpose limitation, minimization, controlled access, traceability, and lifecycle management.

### 10.34 Privacy Testing

Implemented privacy controls should be validated where practical.

Representative tests include:

- personal attributes are correctly identified;
- unnecessary personal attributes do not propagate downstream;
- transformation produces the expected reduced representation;
- unauthorized consumers cannot access protected personal data;
- personal values do not appear unnecessarily in logs or metrics;
- replay respects current privacy rules;
- export preserves applicable controls;
- evidence does not unnecessarily expose personal information.

Synthetic data should be preferred whenever real personal data is unnecessary to validate the behavior.

Detailed validation methodology is defined in Chapter 17.

### 10.35 Privacy Evidence

Privacy evidence should demonstrate the implemented behavior without unnecessarily reproducing personal information.

Relevant evidence may identify:

- test identifier;
- dataset or attribute;
- personal-data status;
- processing purpose;
- expected transformation or restriction;
- observed result;
- lineage;
- access result;
- implementation version;
- conclusion.

Evidence should use synthetic, masked, redacted, or otherwise controlled representations where possible.

Evidence of a technical privacy control demonstrates that control under the tested conditions.

It does not independently establish legal compliance.

### 10.36 LGPD and Privacy Governance Guarantees

The Atlas Engineering privacy-governance model must preserve the following guarantees:

1. personal data can be identified within the governed architecture;
2. sensitive personal data is distinguished where applicable;
3. personal-data processing has an identifiable purpose;
4. technical availability does not independently justify a new processing purpose;
5. unnecessary personal-data propagation is minimized;
6. privacy requirements remain applicable throughout the data pipeline;
7. change capture does not justify unrestricted replication of source attributes;
8. Kafka and Bronze remain governed locations for personal data;
9. Silver provides a controlled boundary for privacy-oriented transformation;
10. Gold and Certified Gold expose only personal information required for their defined purposes;
11. certification does not independently authorize personal-data disclosure;
12. direct and indirect identification are both considered;
13. pseudonymization is not represented as anonymization;
14. anonymization is claimed only when the implemented transformation and evidence justify it;
15. masking reduces exposure but does not automatically remove personal-data status;
16. personal-data access follows purpose and least privilege;
17. observability, metadata, lineage, and evidence avoid unnecessary reproduction of personal values;
18. correction respects authoritative-source responsibilities;
19. the architecture can support investigation of applicable data-subject requests;
20. deletion considers governed copies across the data lifecycle;
21. privacy deletion is reconciled with legitimate historical and retention requirements through governed decisions;
22. backup recovery does not silently reintroduce obsolete personal-data state;
23. replay respects current privacy-governance rules;
24. retention reflects purpose and applicable requirements rather than storage availability;
25. export creates a new governed privacy boundary;
26. privacy-relevant incidents support technical investigation and evidence preservation;
27. privacy is considered during data-product design;
28. new products do not automatically inherit unnecessary upstream personal attributes;
29. laboratory privacy validation uses controlled or synthetic data where practical;
30. technical controls are not represented as independent proof of legal or regulatory compliance.

---

## 11. Data Access by Architectural Layer

Atlas Engineering applies access control according to architectural responsibility rather than granting uniform access across the platform.

Each architectural layer exists for a defined purpose and therefore represents a distinct access boundary.

The governing principle is:

**Required Responsibility → Required Layer → Required Operation → Minimum Access**

Access to one layer does not automatically imply access to another.

Technical connectivity, possession of valid credentials, or access to an upstream dataset does not independently establish authorization to use another platform resource.

### 11.1 Operational Source Access

AtlasCommerce is the authoritative operational source.

Direct access must be limited to identities and services with a defined operational, administrative, capture, recovery, or authorized investigative responsibility.

Representative access may include:

**Operational Application**
→ performs authorized transactional operations.

**Debezium**
→ reads the source structures required for change capture.

**DBA / Database Administration**
→ performs explicitly authorized database administration.

Ordinary analytical consumers should not require direct access to AtlasCommerce.

The operational source must not become a general analytical-consumption interface merely because it contains the original business data.

### 11.2 CDC Access

SQL Server CDC structures support controlled change capture.

Access should be limited to responsibilities requiring:

- change capture;
- CDC administration;
- authorized troubleshooting;
- validation;
- recovery where applicable.

The Debezium capture identity should receive only the CDC and source access required for its responsibility.

Analytical consumers do not require CDC access.

CDC must not become an alternative analytical path around governed downstream processing.

### 11.3 Debezium Access

Debezium crosses a critical boundary between the operational source and the event platform.

Its access should be limited to the resources required to:

- read approved source and CDC structures;
- obtain required capture metadata;
- interact with the event-contract mechanism where required;
- publish approved events to Kafka.

Debezium does not automatically require:

- unrestricted SQL Server access;
- database-administration privileges;
- unrestricted Kafka topic access;
- Kafka administrative authority;
- Bronze, Silver, Gold, or Certified Gold access.

Its identity and credentials should remain specific to the capture responsibility.

### 11.4 Kafka Producer Access

Kafka producers should receive permission only to publish to the topics required by their defined responsibility.

For the initial Sales flow:

**Debezium**
→ publishes approved source-derived events to the required Sales topics.

Producer access does not automatically imply:

- topic administration;
- consumer access;
- access to unrelated topics;
- platform-wide Kafka administration.

Write permission should remain scoped to the required event contracts and communication paths.

### 11.5 Kafka Consumer Access

Kafka consumers should receive access only to the topics and consumer responsibilities required for their processing purpose.

For example:

**Bronze Processor**
→ consumes approved Sales events required for Bronze persistence.

Consumer access does not automatically imply:

- producer access;
- access to unrelated topics;
- administrative privileges;
- permission to modify topic configuration.

Consumer-group access should also remain scoped where the implemented Kafka security mechanism supports it.

### 11.6 Kafka Administrative Access

Kafka administration is distinct from event production and consumption.

Administrative operations may include:

- topic creation or configuration;
- retention changes;
- access-control changes;
- broker configuration;
- consumer-group administration;
- platform troubleshooting.

Routine producers and consumers should not require Kafka administrative privileges.

Administrative access must remain explicit, limited, and attributable where technically practical.

### 11.7 Bronze Access

Bronze is a durable historical and replayable representation of source-derived events.

Read access should normally be limited to responsibilities requiring:

- Silver processing;
- replay;
- recovery;
- data-quality investigation;
- governance;
- authorized troubleshooting.

Bronze may contain information that is intentionally removed or transformed downstream.

It must therefore not become a general analytical-consumption layer.

### 11.8 Bronze Write Access

Write access to Bronze should be limited to the workload responsible for Bronze persistence and explicitly authorized recovery or maintenance operations.

The normal path is:

**Kafka → Bronze Processor → Bronze**

Other services should not write directly to Bronze merely because the storage endpoint is reachable.

Controlled write ownership supports:

- deterministic persistence;
- lineage;
- replay;
- troubleshooting;
- integrity of the historical layer.

Administrative write access, where required, must remain distinct from routine processing.

### 11.9 Silver Access

Silver contains standardized, normalized, deduplicated, and contract-aware data.

Read access should normally be limited to responsibilities requiring:

- Gold processing;
- quality validation;
- reconciliation;
- governance;
- authorized investigation;
- controlled recovery.

Silver is a trusted processing layer but is not the default analytical-consumption boundary.

Ordinary analytical consumers should normally use Certified Gold.

### 11.10 Silver Write Access

Write access to Silver should be limited to the workload responsible for Silver transformation and explicitly authorized recovery or maintenance operations.

The normal path is:

**Bronze → Silver Processor → Silver**

Other services should not bypass the transformation responsibility and write arbitrary records directly into Silver.

Controlled write ownership helps preserve:

- transformation consistency;
- contract enforcement;
- deduplication behavior;
- quality state;
- lineage;
- reproducibility.

### 11.11 Gold Access

Gold contains dimensional processing structures, analytical models, reconciliation state, and other information required before governed publication.

Read access may be required for:

- validation;
- reconciliation;
- certification;
- publication;
- governance;
- authorized investigation.

Gold is not automatically equivalent to Certified Gold.

A technically processed Gold state may still be unvalidated, unreconciled, or uncertified.

### 11.12 Gold Candidate Access

A Gold candidate represents analytical state that has been produced but has not yet crossed the certification and publication boundary.

Access should therefore remain limited to responsibilities requiring:

- validation;
- reconciliation;
- certification;
- controlled troubleshooting;
- publication preparation.

Ordinary analytical consumers should not depend on Gold candidates.

This prevents incomplete or uncertified state from becoming an unofficial analytical interface.

### 11.13 Certified Gold Access

Certified Gold is the governed analytical-consumption boundary.

Representative access includes:

**Power BI**
→ reads approved analytical structures.

**Authorized Analytical Consumers**
→ read the governed data product required for their defined purpose.

Ordinary consumers should normally receive read-only access.

Certified Gold access remains subject to:

- classification;
- purpose;
- least privilege;
- privacy requirements;
- product-specific authorization.

Certification does not imply unrestricted access.

### 11.14 Certified Gold Write and Publication Access

Write and publication access to Certified Gold must remain separate from ordinary analytical consumption.

The intended sequence is:

**Gold Candidate → Validation → Reconciliation → Certification → Publication → Certified Gold**

Only the explicitly authorized publication responsibility should publish approved state.

Analytical consumers must not require permission to:

- INSERT;
- UPDATE;
- DELETE;
- replace certified structures;
- alter certification state;
- publish candidates.

Version 1 may consolidate technical execution of certification and publication, but the logical authorization boundary must remain explicit.

### 11.15 Power BI Access

Power BI should consume governed analytical data through Certified Gold.

The intended path is:

**Power BI → Certified Gold**

Ordinary Power BI operation should not require direct access to:

- AtlasCommerce;
- CDC structures;
- Debezium;
- Kafka;
- Bronze;
- Silver;
- Gold candidates;
- internal processing services.

This boundary reduces coupling and prevents analytical convenience from bypassing processing, quality, reconciliation, and certification controls.

### 11.16 Airflow Access

Airflow coordinates platform workflows and therefore requires only the access necessary to perform orchestration responsibilities.

Depending on implementation, this may include permission to:

- trigger workloads;
- coordinate dependencies;
- inspect execution state;
- obtain required operational metadata;
- evaluate workflow outcomes.

Airflow does not automatically require unrestricted read, write, or administrative access to every component it orchestrates.

Where a workload can execute using its own service identity, orchestration should not replace that identity with a broadly privileged Airflow credential.

### 11.17 Observability Access

Observability components require access to operational signals rather than unrestricted business data.

Representative access may include:

- metrics;
- health endpoints;
- structured logs;
- execution state;
- alerts.

Prometheus and Grafana should not require broad access to business datasets merely to observe platform behavior.

Observability access must also respect restrictions concerning:

- secrets;
- personal data;
- sensitive business information;
- security-sensitive information.

Monitoring a service does not imply administrative authority over that service.

### 11.18 Metadata and Lineage Access

Metadata and lineage support governance, architecture, investigation, validation, and impact analysis.

Access may therefore be broader than access to the underlying business values, but it must still be controlled.

Metadata may expose sensitive information indirectly through:

- schema definitions;
- classifications;
- lineage;
- system names;
- processing relationships;
- security configuration;
- operational details.

Access to metadata does not automatically grant access to the data described by that metadata.

Likewise, access to business data does not automatically grant permission to modify governance metadata or lineage.

### 11.19 Quarantine Access

Quarantine contains records that require controlled investigation, correction, or reprocessing.

Access should be limited to responsibilities requiring:

- diagnosis;
- quality investigation;
- correction;
- governance;
- reprocessing;
- authorized support.

Quarantine must not become an alternative analytical-consumption path around quality or certification controls.

Records in quarantine remain governed according to their classification and privacy requirements.

### 11.20 Backup Access

Backups may contain complete historical copies of governed platform information.

Access should therefore be limited to responsibilities requiring:

- backup execution;
- backup administration;
- restore;
- recovery validation;
- authorized investigation.

Access to an active dataset does not automatically justify access to its backups.

Backup access must reflect the classification and sensitivity of the information preserved.

### 11.21 Evidence Access

Validation evidence may contain:

- configuration information;
- test results;
- logs;
- screenshots;
- identifiers;
- architectural details;
- security-related results.

Evidence access must reflect the sensitivity of its content.

Public evidence should contain only information appropriate for public disclosure.

Sensitive evidence must not become public merely because evidence is part of project documentation.

Access to evidence does not automatically imply access to the production or processing resources represented by that evidence.

### 11.22 Cross-Layer Access

Some responsibilities legitimately require access across more than one architectural layer.

Examples include:

**Silver Processor**
→ reads Bronze and writes Silver.

**Gold Processor**
→ reads Silver and writes Gold candidates.

**Certification / Publication**
→ evaluates Gold state and publishes approved Certified Gold.

Cross-layer access must remain limited to the specific source and destination required for the responsibility.

A requirement to cross two adjacent boundaries does not justify unrestricted access to the complete platform.

### 11.23 Access During Replay and Recovery

Replay and recovery may require access that differs temporarily from ordinary steady-state processing.

Such access must remain:

- explicit;
- justified;
- scoped;
- attributable;
- temporary where practical;
- auditable.

Replay should use governed processing paths rather than uncontrolled direct modification of downstream state.

Recovery must not silently:

- restore revoked access;
- reactivate invalidated credentials;
- bypass current authorization;
- expose restricted layers;
- publish uncertified data.

After recovery, access should return to the normal governed model.

### 11.24 Access During Investigation

Operational, security, data-quality, or privacy investigations may require temporary access to information not normally available to the investigator.

Investigation access should be limited according to:

- incident or problem scope;
- required datasets;
- required operations;
- duration;
- sensitivity;
- responsible role.

Where practical, investigation should prefer the minimum information necessary to establish cause and impact.

Temporary investigative access must not silently become permanent routine access.

### 11.25 Environment Separation

Access must be scoped by environment where multiple environments exist.

Access to:

**Development**

does not automatically imply access to:

**Test**

or:

**Production**

Likewise, credentials and service identities should not be reused across environments without explicit justification.

Environment separation reduces the risk that development, testing, or troubleshooting activities affect more sensitive operational resources.

Version 1 may operate primarily as a local laboratory, but environment separation remains part of the enterprise access model.

### 11.26 Access Matrix

Atlas Engineering should maintain an access matrix describing the intended relationship between identities or roles and protected resources.

A representative matrix may include:

| Identity / Role | Source | CDC | Kafka | Bronze | Silver | Gold | Certified Gold | Administration |
|---|---|---|---|---|---|---|---|---|
| Debezium | Required Read | Required Read | Produce | No | No | No | No | No |
| Bronze Processor | No | No | Consume | Write | No | No | No | No |
| Silver Processor | No | No | No | Read | Write | No | No | No |
| Gold Processor | No | No | No | No | Read | Write | No | No |
| Certification / Publication | No | No | No | No | As Required | Read | Publish | Limited |
| Power BI | No | No | No | No | No | No | Read | No |
| Platform Administrator | Controlled | Controlled | Controlled | Controlled | Controlled | Controlled | Controlled | Explicit |
| Governance / Investigation | As Required | As Required | As Required | As Required | As Required | As Required | As Required | No by Default |

The matrix is an architectural baseline rather than a substitute for technology-specific permission definitions.

Actual implementation must translate these logical requirements into the authorization mechanisms supported by each platform component.

### 11.27 Access Matrix Validation

The access matrix must be validated against actual implementation where practical.

Validation should confirm both:

**Required Access**
→ legitimate responsibilities can perform their intended operations.

and:

**Prohibited Access**
→ identities cannot perform operations outside their defined responsibilities.

A documented matrix is not evidence that permissions are correctly enforced.

Implementation and validation must demonstrate alignment between intended and observed access.

### 11.28 Access Drift

Access drift occurs when actual permissions diverge from the governed access model over time.

Examples include:

- temporary privilege that was never removed;
- service credentials reused for additional purposes;
- new topic access granted without review;
- analytical consumer receiving upstream access;
- administrative permission retained after troubleshooting;
- environment access expanded without architectural justification.

Access drift should be detectable through review, testing, configuration comparison, or equivalent mechanisms where practical.

Detected drift must be evaluated and corrected rather than silently becoming the new baseline.

### 11.29 Access Boundary Changes

Changes to access boundaries require explicit review.

Examples include:

- a new consumer;
- a new service;
- a new architectural layer;
- new sensitive attributes;
- new cross-layer processing;
- new administrative requirements;
- new export paths;
- new recovery procedures.

A change should evaluate:

- required identity;
- required resource;
- required operation;
- classification;
- privacy implications;
- security impact;
- observability;
- validation requirements.

Access should not expand merely because a new integration is technically convenient.

### 11.30 Laboratory Access Model

Version 1 implements access boundaries within a controlled local training environment.

The laboratory may consolidate multiple human responsibilities under one operator and may use locally managed identities and credentials.

It should still demonstrate, where practical:

- distinct service responsibilities;
- scoped credentials;
- read/write separation;
- processing-layer boundaries;
- Certified Gold consumer isolation;
- controlled administrative access;
- prohibited-access denial;
- access revocation;
- observable security behavior.

Laboratory constraints may simplify physical enforcement but must not redefine the logical access architecture.

### 11.31 Enterprise Evolution

Enterprise deployment may strengthen access governance through capabilities such as:

- centralized identity providers;
- managed workload identities;
- role-based access control;
- attribute-based access control;
- privileged-access management;
- automated provisioning and deprovisioning;
- environment-specific identities;
- policy-as-code;
- periodic access certification;
- centralized access auditing.

These mechanisms strengthen enforcement without changing the fundamental principle that access follows defined responsibility and purpose.

### 11.32 Layer Access Testing

Layer-access controls should be tested through positive and negative scenarios where practical.

Representative positive tests include:

- Debezium reads the required source and CDC structures;
- Bronze Processor consumes the required Kafka topic and writes Bronze;
- Silver Processor reads Bronze and writes Silver;
- Gold Processor reads Silver and writes Gold candidates;
- publication process publishes approved Certified Gold;
- Power BI reads Certified Gold.

Representative negative tests include:

- Power BI cannot access Bronze or Silver;
- Bronze Processor cannot modify Silver;
- Silver Processor cannot modify Certified Gold;
- Kafka consumer cannot administer Kafka;
- ordinary consumer cannot publish Certified Gold;
- revoked or unauthorized identity cannot access the protected layer.

Expected behavior must be defined before execution.

Detailed validation methodology is defined in Chapter 17.

### 11.33 Layer Access Evidence

Evidence should demonstrate that implemented access boundaries behave as designed.

Relevant evidence may identify:

- test identifier;
- identity or role;
- architectural layer;
- requested resource;
- requested operation;
- expected result;
- observed result;
- authorization outcome;
- implementation version;
- conclusion.

Evidence should include both successful required access and rejected prohibited access where applicable.

Credentials, secrets, and unnecessary sensitive information must not appear in preserved evidence.

### 11.34 Data Access by Architectural Layer Guarantees

The Atlas Engineering layer-access model must preserve the following guarantees:

1. each architectural layer represents a distinct access boundary;
2. access follows defined responsibility and purpose;
3. access to one layer does not automatically imply access to another;
4. technical connectivity does not independently establish authorization;
5. ordinary analytical consumers do not require direct operational-source access;
6. CDC remains a controlled capture boundary rather than an analytical interface;
7. Debezium access remains limited to its capture and publication responsibilities;
8. Kafka producer, consumer, and administrative privileges remain distinguishable;
9. Bronze and Silver write access remain limited to their responsible processing workloads;
10. Bronze and Silver do not become default analytical-consumption layers;
11. Gold candidate state remains distinct from Certified Gold;
12. Certified Gold publication authority remains distinct from ordinary analytical consumption;
13. Power BI consumes Certified Gold without requiring routine upstream access;
14. orchestration and observability responsibilities do not automatically receive unrestricted data or administrative access;
15. metadata, quarantine, backups, and evidence remain governed access boundaries;
16. legitimate cross-layer access remains scoped to the required source, destination, and operation;
17. replay, recovery, and investigation do not silently create permanent elevated access;
18. environment access remains separable where multiple environments exist;
19. the governed access matrix can be compared with actual implementation;
20. access drift is treated as a security and governance condition requiring evaluation;
21. changes to access boundaries require explicit review;
22. implemented layer-access controls can be tested through both required and prohibited behavior.

---

## 12. Schema, Contract, and Metadata Governance

Atlas Engineering treats schemas, contracts, metadata, lineage, processing definitions, quality rules, reconciliation rules, and certification information as governed platform assets.

These assets define how data is interpreted, transformed, validated, published, and consumed.

Changes to these definitions may alter platform behavior or data meaning even when the underlying infrastructure remains unchanged.

Governance must therefore control not only data movement but also the definitions that determine what the data means and how it may be processed.

The governing lifecycle is:

**Definition → Ownership → Versioning → Review → Change → Validation → Publication → Traceability**

### 12.1 Governed Definitions

Governed definitions may include, as applicable:

- source-schema references;
- CDC onboarding definitions;
- event contracts;
- schema versions;
- compatibility policies;
- Silver processing definitions;
- Gold dimensional definitions;
- fact grains;
- dimension semantics;
- measure definitions;
- quality rules;
- reconciliation rules;
- certification criteria;
- analytical consumption contracts;
- data classifications;
- retention rules;
- lineage metadata;
- access policies;
- processing versions.

These definitions must remain identifiable, understandable, and attributable to the responsibility they govern.

### 12.2 Source Schema Governance

AtlasCommerce owns the operational source schema.

A source-schema change does not automatically redefine downstream analytical contracts.

Changes to source tables, columns, data types, keys, or semantics must be evaluated for their impact on:

- CDC capture;
- Debezium;
- event contracts;
- Kafka events;
- Bronze history;
- Silver transformations;
- Gold structures;
- quality rules;
- reconciliation;
- lineage;
- privacy;
- analytical products.

The Data Engineering platform must not silently interpret a source-schema change as authorization to change downstream meaning.

### 12.3 Event Contract Governance

Event contracts define the controlled interface between event production and consumption.

They must remain:

- versioned;
- owned;
- documented;
- testable;
- traceable;
- governed through compatibility expectations.

Apicurio Registry provides the technical registry for event-schema versions and compatibility policies in Version 1.

Registry acceptance alone does not establish semantic approval.

A change may be structurally compatible while still requiring review of its downstream meaning.

### 12.4 Contract Ownership

Each governed event contract must have an identifiable owner or responsible role.

Ownership must make it possible to determine:

- who approves changes;
- who evaluates compatibility;
- who understands producer behavior;
- who evaluates consumer impact;
- who coordinates breaking-change migration;
- who decides deprecation and removal.

Version 1 may consolidate these responsibilities under one operator while preserving their logical distinction.

### 12.5 Contract Versioning

Contract versions must remain distinguishable over time.

Versioning supports:

- historical interpretation;
- replay;
- migration;
- debugging;
- impact analysis;
- consumer compatibility;
- lineage.

A new version must not make governed historical Bronze data uninterpretable while that history remains subject to replay or investigation.

### 12.6 Compatibility Governance

Compatibility governance must protect the supported producer-consumer relationship.

Evaluation must distinguish:

**Structural Compatibility**
→ whether the schema change is technically acceptable according to the configured compatibility policy.

**Semantic Compatibility**
→ whether the resulting meaning remains valid for supported consumers.

Both must be considered before normal deployment.

Technical acceptance by the registry does not independently establish semantic approval.

### 12.7 Breaking-Change Governance

A breaking change requires an explicit migration path.

The migration may require:

- a new contract version;
- producer changes;
- consumer changes;
- parallel support;
- controlled rollout;
- historical interpretation support;
- deprecation of the previous version;
- updated tests and documentation.

Breaking changes must not be introduced silently into an existing contract expected to remain compatible.

### 12.8 Processing Definition Governance

Transformation logic is part of the governed data product.

Processing definitions may include:

- parsing;
- normalization;
- deduplication;
- business-rule application;
- dimensional mapping;
- historical treatment;
- delete handling;
- quality evaluation;
- reconciliation;
- certification preparation.

A code change capable of altering the resulting data meaning must therefore be treated as a governed processing change.

### 12.9 Silver Processing Version

Silver processing must remain attributable to an identifiable processing version where required for reproducibility, replay, investigation, or evidence.

The version should allow the platform to determine which transformation logic produced a governed Silver result.

A replay using a newer processing version may legitimately produce a different result from the original execution.

That difference must be explainable rather than silently interpreted as corruption.

### 12.10 Gold Processing Version

Gold processing must likewise remain attributable to the transformation logic that produced its analytical state.

Relevant changes may include:

- fact grain;
- dimension mapping;
- SCD behavior;
- measure logic;
- unknown-member handling;
- delete semantics;
- historical treatment;
- certification preparation.

A materially changed Gold definition should remain distinguishable from the version it replaces.

### 12.11 Quality Rule Governance

Data-quality rules are governed definitions.

Each relevant rule should identify, where applicable:

- rule identifier;
- scope;
- purpose;
- severity;
- expected behavior;
- failure handling;
- owner;
- version.

A change to a quality rule may change which data is accepted, quarantined, rejected, or certified.

Such changes must therefore be reviewable and traceable.

### 12.12 Reconciliation Rule Governance

Reconciliation rules define how the platform determines whether processing remains quantitatively and semantically consistent across boundaries.

Governed reconciliation may include:

- row counts;
- transaction counts;
- financial totals;
- control totals;
- source-to-target comparisons;
- completeness expectations.

Changes to reconciliation logic may change certification outcomes and must therefore remain explicit and traceable.

### 12.13 Certification Governance

Certification criteria define when a Gold candidate may become consumer-visible through Certified Gold.

Certification must be based on explicit requirements rather than inferred from successful job completion.

Criteria may include:

- successful processing;
- quality results;
- reconciliation results;
- required metadata;
- expected lineage;
- required version information;
- absence of blocking failures.

A pipeline finishing successfully does not independently mean that its output is certified.

### 12.14 Analytical Consumption Contract Governance

Certified analytical products expose a governed consumption contract to downstream consumers.

That contract may define:

- available datasets;
- dimensions;
- measures;
- grains;
- semantics;
- refresh expectations;
- classifications;
- supported fields;
- consumer-facing compatibility expectations.

The analytical consumption contract is distinct from the upstream event contract.

A consumer should not need to understand the internal event representation in order to use Certified Gold correctly.

### 12.15 Metadata Governance

Metadata is part of the governed platform state.

It should remain sufficiently accurate to explain:

- what data exists;
- what it means;
- where it originated;
- how it was processed;
- which version produced it;
- who owns it;
- how it is classified;
- what controls apply;
- whether it is certified.

Metadata that no longer reflects implementation creates governance risk even when processing continues successfully.

### 12.16 Technical Metadata

Technical metadata describes implementation and processing characteristics.

Examples may include:

- schema;
- table or dataset;
- column or field;
- data type;
- contract version;
- processing version;
- source position;
- execution identifier;
- storage location;
- partition;
- timestamps;
- lineage identifiers.

Technical metadata should support operation, replay, investigation, validation, and reproducibility.

### 12.17 Business Metadata

Business metadata describes the meaning and intended use of governed information.

Examples may include:

- business definition;
- business owner;
- fact grain;
- dimension meaning;
- measure definition;
- analytical purpose;
- interpretation rules;
- expected consumer.

Technical correctness does not replace business meaning.

A perfectly populated field whose semantics are unclear remains a governance problem.

### 12.18 Governance Metadata and Security Metadata

Governance and security metadata describe the controls surrounding governed assets.

Examples may include:

- classification;
- personal-data status;
- retention policy;
- owner;
- access policy;
- certification state;
- quality-rule version;
- reconciliation-rule version;
- deprecation state;
- security requirement.

Such metadata may itself reveal sensitive architectural or security information and must be protected according to its content.

### 12.19 Metadata Ownership

Governed metadata requires identifiable responsibility.

Ownership should make it possible to determine who is responsible for:

- correctness;
- maintenance;
- review;
- approval;
- lifecycle;
- synchronization with implementation.

Different metadata categories may have different owners.

Version 1 may consolidate ownership operationally while preserving the logical responsibilities.

### 12.20 Lineage Governance

Lineage must explain the governed relationships through which data is produced.

For the Sales flow, lineage may describe:

**AtlasCommerce → CDC → Event Contract → Kafka → Bronze → Silver → Gold → Certified Gold**

Where required, lineage should also preserve relationships among:

- source object;
- source position;
- event identity;
- contract version;
- processing version;
- quality result;
- reconciliation result;
- certification state;
- analytical product.

Lineage should explain data provenance without unnecessarily reproducing sensitive values.

### 12.21 Version Relationships

Atlas Engineering contains multiple independent version dimensions.

Examples include:

- source-schema version;
- event-contract version;
- Silver processing version;
- Gold processing version;
- quality-rule version;
- reconciliation-rule version;
- analytical-product version;
- infrastructure or deployment version.

These versions must not be collapsed into one ambiguous platform version.

Where required for traceability, their relationships should remain identifiable.

For example:

**Contract V2 + Silver Processing V4 + Gold Processing V3 → Certified Product V5**

This allows a published state to be traced to the definitions that produced it.

### 12.22 Change Impact Analysis

A governed change should be evaluated for downstream impact before normal deployment where practical.

Impact analysis may consider:

- producers;
- consumers;
- contracts;
- historical data;
- replay;
- Silver;
- Gold;
- quality rules;
- reconciliation;
- certification;
- lineage;
- privacy;
- retention;
- dashboards;
- evidence.

The scope of review should reflect the significance of the change.

Not every change requires the same governance process, but material downstream impact must not be ignored.

### 12.23 Change Approval

Changes to governed assets should have an identifiable approval path appropriate to their significance.

Examples include changes to:

- event contracts;
- breaking semantics;
- Gold grain;
- quality rules;
- reconciliation logic;
- certification criteria;
- classifications;
- access policies;
- retention rules.

Version 1 may consolidate approval under one operator.

The architecture nevertheless distinguishes creation of a change from approval of its governed meaning.

### 12.24 Architecture Decision Records

Significant architectural decisions should be preserved through Architecture Decision Records where appropriate.

An ADR should explain:

- context;
- decision;
- relevant alternatives;
- consequences;
- status.

ADRs are particularly useful when a decision would otherwise be difficult to reconstruct later from implementation alone.

They complement architecture documentation rather than replace it.

### 12.25 Documentation Consistency

Governed documentation must remain synchronized with the architecture and validated implementation.

Relevant documentation may include:

- architecture;
- data flow;
- standards;
- contracts;
- metadata;
- security and governance;
- ADRs;
- tests;
- operational procedures.

Documentation must not remain knowingly inconsistent with validated implementation without clearly identifying the divergence.

Where implementation becomes the validated technical source of truth, documentation must be updated accordingly.

### 12.26 Metadata Drift

Metadata drift occurs when governed metadata no longer represents the implemented platform.

Examples include:

- incorrect owner;
- obsolete classification;
- outdated field definition;
- wrong processing version;
- stale lineage;
- incorrect storage location;
- obsolete retention metadata.

Metadata drift should be treated as a governance defect rather than harmless documentation debt.

### 12.27 Contract Drift

Contract drift occurs when producer or consumer behavior diverges from the governed contract.

Examples include:

- producer emits undocumented fields;
- producer changes field meaning without versioning;
- consumer relies on undocumented assumptions;
- implementation accepts unsupported contract versions;
- registry state differs from approved contract documentation.

Contract drift must be detectable through validation where practical.

### 12.28 Quality Rule Drift

Quality-rule drift occurs when implemented validation no longer matches the governed quality definition.

Examples include:

- rule disabled without documentation;
- threshold changed only in code;
- severity changed without governance review;
- quarantine behavior differs from the documented rule.

Because quality results may influence certification, quality-rule drift can alter the consumer-visible trust boundary.

### 12.29 Certified Product Drift

Certified-product drift occurs when the consumer-visible analytical product no longer matches its governed definition.

Examples include:

- undocumented measure change;
- changed grain;
- missing dimension;
- additional sensitive attribute;
- altered refresh behavior;
- unapproved schema change.

Certified Gold must not silently evolve outside its governed consumption contract.

### 12.30 Lifecycle Governance

Governed assets require lifecycle states appropriate to their type.

A representative lifecycle is:

**Draft → Reviewed → Approved → Active → Deprecated → Removed**

Not every asset requires these exact labels, but lifecycle state should remain identifiable where relevant.

An asset should not move from experimental or draft state into normal governed use merely because it is technically available.

### 12.31 Deprecation

Deprecation indicates that an asset remains available temporarily but should no longer be selected for new normal use.

A deprecated contract or dataset should identify, where applicable:

- replacement;
- remaining consumers;
- migration expectation;
- support period;
- removal criteria.

Deprecation must remain visible.

An asset must not effectively be removed while supported consumers still depend on it without an explicit migration decision.

### 12.32 Removal

Removal ends normal support for a governed asset.

Before removal, governance must evaluate:

- active consumers;
- historical replay;
- recovery;
- lineage;
- retention;
- backups;
- audit;
- documentation.

For example, an event-contract version may be removed from normal production use while historical Bronze data still requires that version for interpretation.

In that case, historical interpretation capability must remain available through an approved mechanism.

### 12.33 Governance During Recovery

Recovery does not suspend governance.

Replay, rebuild, backfill, rollback, and disaster recovery must use:

- approved contracts;
- identifiable processing versions;
- governed quality rules;
- governed reconciliation;
- controlled access;
- traceable execution.

Emergency recovery must not silently introduce undocumented schema, transformation, quality, reconciliation, or certification behavior.

### 12.34 Governance During Experimentation

The laboratory may include experiments used to evaluate architectural alternatives.

Experimental artifacts must remain distinguishable from governed platform state.

Examples include:

- experimental topics;
- temporary transformations;
- benchmark datasets;
- prototype security controls.

An experiment must not silently become a governed architectural dependency merely because it worked successfully.

When an experiment becomes part of the approved architecture, the resulting decision and implementation must enter the normal governance lifecycle.

### 12.35 Governance Repository Structure

Governed definitions should be stored in predictable repository locations according to their purpose.

Repository organization should make it possible to distinguish, for example:

- architecture;
- standards;
- contracts;
- implementation;
- tests;
- evidence;
- business documentation;
- ADRs.

The exact structure may evolve, but governed assets must not be scattered unpredictably without ownership or context.

### 12.36 Public and Private Governance Artifacts

Not every governance artifact must be public.

Public artifacts may include:

- architecture;
- standards;
- approved schemas;
- examples;
- sanitized evidence.

Private or restricted artifacts may include:

- credentials;
- security-sensitive implementation details;
- privacy investigation material;
- real personal data;
- restricted evidence;
- incident information.

Publication decisions must follow classification, privacy, and security requirements.

The existence of an artifact in the project does not independently justify its publication.

### 12.37 Governance Testing

Governance controls should be tested where implementation allows.

Representative tests include:

- producer conforms to the approved event contract;
- incompatible contract change is rejected;
- Silver correctly interprets supported contract versions;
- Gold output reflects the documented grain;
- quality implementation matches the governed rule;
- reconciliation implementation matches its governed definition;
- Certified Gold matches its documented consumption contract;
- deprecated assets remain identifiable;
- removed assets cannot be selected for normal new processing;
- metadata accurately reflects current implementation;
- lineage preserves expected version relationships.

Detailed validation methodology is defined in Chapter 17.

### 12.38 Governance Evidence

Governance evidence may identify:

- governed asset;
- owner;
- current version;
- expected definition;
- implemented definition;
- test identifier;
- expected behavior;
- observed behavior;
- affected dependencies;
- decision reference;
- timestamp;
- implementation version;
- conclusion.

Evidence should demonstrate governance behavior without unnecessarily exposing Confidential or Restricted information.

A documented definition alone does not prove that implementation conforms to it.

### 12.39 Schema, Contract, and Metadata Governance Guarantees

The Atlas Engineering governance model must preserve the following guarantees:

1. schemas, contracts, metadata, processing definitions, quality rules, reconciliation rules, and certification criteria are governed assets;
2. source-schema changes do not automatically redefine downstream contracts;
3. event contracts remain versioned, owned, documented, traceable, and testable;
4. structural compatibility and semantic compatibility remain distinct;
5. breaking changes require explicit migration;
6. Silver and Gold processing logic remain identifiable by processing version where required;
7. quality and reconciliation definitions remain governed when changes may affect processing or certification;
8. certification criteria remain explicit rather than inferred from successful execution;
9. analytical consumption contracts remain distinct from event contracts;
10. metadata includes technical and business meaning where applicable;
11. governance and security metadata are protected according to their sensitivity;
12. independent version dimensions remain distinguishable;
13. governed changes include downstream impact analysis where practical;
14. significant architectural decisions can be preserved through ADRs;
15. documentation remains part of the governed platform state;
16. metadata, contract, quality-rule, and certified-product drift are governance defects;
17. governed assets follow controlled lifecycle and deprecation behavior;
18. removal considers active consumers, replay, recovery, lineage, retention, and historical interpretation;
19. recovery does not bypass governed definitions;
20. experiments remain distinguishable from approved platform state;
21. public and private governance artifacts are distinguished according to classification and purpose;
22. implemented governance behavior is testable and evidence-based;
23. governance claims remain limited to behavior actually implemented and validated.

---

## 13. Retention, Archival, and Disposal

Retention, archival, and disposal govern how long data, metadata, processing state, evidence, and recovery assets remain available within Atlas Engineering.

The platform must not retain information indefinitely merely because storage capacity is available.

Retention decisions must balance:

- business and analytical purpose;
- recovery and replay requirements;
- auditability;
- lineage;
- privacy;
- security;
- applicable legal or organizational requirements;
- storage cost.

Different architectural layers may require different retention periods because they serve different responsibilities.

The governing lifecycle is:

**Create → Use → Retain → Archive Where Required → Dispose According to Policy**

### 13.1 Retention Principles

Retention decisions must follow several architectural principles:

- retain data only for an approved purpose;
- distinguish operational retention from historical retention;
- distinguish online retention from archival retention;
- preserve enough history to satisfy approved recovery and replay requirements;
- avoid indefinite retention without justification;
- consider classification and privacy;
- preserve metadata required to interpret retained data;
- coordinate retention with backup and cryptographic-key lifecycle;
- dispose of information through controlled procedures.

Retention is part of architecture and governance, not merely storage configuration.

### 13.2 Retention by Architectural Layer

Retention requirements differ across platform layers.

For example:

**Kafka**
→ bounded operational transport and replay retention.

**Bronze**
→ durable historical retention supporting replay and reconstruction.

**Silver**
→ standardized processing retention according to reconstruction and analytical needs.

**Gold**
→ analytical retention according to product requirements.

**Certified Gold**
→ governed publication and historical-version retention according to consumer, audit, rollback, and recovery requirements.

These durations must not be assumed to be identical.

### 13.3 Kafka Retention

Kafka retention supports:

- asynchronous buffering;
- temporary consumer disruption;
- operational replay;
- investigation;
- normal recovery from committed offsets.

Kafka is not the permanent historical archive of the analytical platform.

Its retention period must support the outage and recovery scenarios that depend on Kafka as the first recovery source.

The final value should be informed by measured factors such as:

- event volume;
- expected disruption duration;
- backlog recovery time;
- storage capacity;
- replay requirements;
- consumer recovery behavior.

If required history falls outside Kafka retention, recovery must use another approved historical source.

### 13.4 CDC Retention

SQL Server CDC history is also subject to retention.

CDC must retain committed changes long enough for the capture path to consume them under expected disruption conditions.

The platform must consider the relationship between:

- available CDC history;
- Debezium progress;
- source change volume;
- downstream interruption.

If required CDC history expires before capture completes, normal incremental ingestion may no longer be complete.

This condition must be detectable.

Recovery must then follow an explicit backfill, rebuild, or other approved procedure rather than silently ignore missing history.

### 13.5 Bronze Retention

Bronze is the primary long-term historical foundation for replay and downstream reconstruction.

Retention must consider:

- Silver rebuild requirements;
- Gold rebuild requirements;
- historical analytical needs;
- event-contract support;
- lineage;
- auditability;
- privacy;
- storage capacity;
- backup strategy.

Bronze retention may be longer than Kafka retention.

However:

**Historical Foundation ≠ Retain Forever**

Retention must remain tied to approved requirements.

### 13.6 Silver Retention

Silver retention depends on how the standardized layer is used.

Silver may support:

- incremental Gold processing;
- Gold rebuild;
- reconciliation;
- troubleshooting;
- analytical reuse;
- controlled reprocessing.

If Silver can be reconstructed from retained Bronze history, its retention may legitimately differ from Bronze.

Derived data should not be retained longer than its operational or analytical value justifies.

### 13.7 Gold Retention

Gold retention is determined by analytical and business requirements.

Gold may contain:

- facts;
- dimensions;
- historical dimensional versions;
- candidate states;
- processing metadata.

Retention must consider:

- analytical history;
- slowly changing dimensions;
- product requirements;
- rebuild capability;
- certification history;
- applicable financial, legal, or organizational requirements;
- storage cost.

Retained analytical history must remain interpretable for as long as it remains governed and available.

### 13.8 Certified Gold Retention

Certified Gold may require retention of:

- the current published version;
- previous certified versions.

Previous versions may support:

- rollback;
- audit;
- investigation;
- comparison;
- reproducibility;
- recovery.

The number or age of retained certified versions must be governed rather than allowed to grow indefinitely.

### 13.9 Candidate Data Retention

Failed or superseded candidate data may retain short-term diagnostic or governance value.

Retention should consider:

- investigation;
- quality evidence;
- reconciliation evidence;
- recovery;
- sensitivity;
- storage impact.

A failed candidate does not automatically require the same retention period as a published certified version.

Where candidate data is removed, sufficient evidence may still need to remain to explain the certification outcome.

### 13.10 Quarantine Retention

Quarantined records require an explicit lifecycle.

They must not accumulate indefinitely because ownership or resolution is unclear.

A quarantined record should eventually reach a state such as:

**Remediated**

**Reprocessed**

**Rejected**

**Disposed**

Retention must reflect:

- remediation window;
- investigation;
- privacy;
- security;
- replay needs;
- final disposition.

### 13.11 Temporary Artifact Retention

Temporary processing artifacts should have short and controlled lifecycles.

Examples include:

- intermediate files;
- partial outputs;
- temporary SQL structures;
- recovery work areas;
- diagnostic extracts.

Successful processing should remove temporary artifacts that are no longer required.

Failure handling must also include cleanup so that abandoned artifacts do not become unmanaged storage.

### 13.12 Log Retention

Logs support:

- troubleshooting;
- observability;
- incident investigation;
- security analysis;
- evidence.

Retention must balance:

- operational value;
- storage volume;
- security relevance;
- privacy;
- sensitive-data exposure;
- evidence requirements.

Longer log retention is not automatically better.

Sensitive information should first be minimized at logging design rather than retained indefinitely under stronger protection.

### 13.13 Metrics Retention

Metrics retention should support:

- baseline analysis;
- SLO evaluation;
- capacity planning;
- incident investigation;
- trend analysis;
- validation evidence.

Different resolutions may be appropriate over time.

Highly granular recent metrics may later be aggregated into longer-term summaries.

Retention should evolve according to observability needs and storage capacity.

### 13.14 Lineage Retention

Lineage must remain available for data and certified versions that remain governed, recoverable, or auditable.

Deleting lineage while retaining the corresponding data may make that data impossible to explain.

Lineage retention must therefore consider:

- Bronze;
- Silver;
- Gold;
- Certified Gold;
- contract versions;
- processing versions;
- quality and certification evidence.

### 13.15 Metadata Retention

Metadata required to understand retained data must remain available for at least the period during which that data remains governed and interpretable.

Relevant metadata may include:

- schema versions;
- event-contract versions;
- processing versions;
- classification;
- ownership;
- retention definition;
- quality-rule versions;
- analytical definitions.

Retained bytes without the metadata required to interpret them may no longer represent a usable governed asset.

### 13.16 Contract Version Retention

Historical contract definitions must remain available while retained historical data requires them for interpretation, replay, or audit.

The lifecycle must distinguish:

**No Longer Active**

from:

**No Longer Required for Historical Interpretation**

These are not necessarily the same point in time.

### 13.17 Processing Version Retention

Processing definitions or sufficient reproducibility information must remain available when historical output must remain explainable or reproducible.

This may apply to:

- Silver processing versions;
- Gold processing versions;
- quality-rule versions;
- reconciliation definitions;
- certification logic.

A version identifier without access to the governed definition it identifies may be insufficient for meaningful replay or investigation.

### 13.18 Evidence Retention

Evidence retention should reflect the importance and lifecycle of the architectural claim it supports.

Evidence may support:

- normal-path validation;
- recovery;
- security controls;
- privacy controls;
- capacity behavior;
- SLO validation;
- certification behavior.

Critical evidence should not disappear while the associated architectural claim remains relied upon unless it has been replaced through a governed revalidation cycle.

Evidence may have a different lifecycle from the raw logs or metrics from which it was created.

### 13.19 Security Audit Retention

Security audit information may require retention for:

- incident response;
- investigation;
- access review;
- organizational requirements;
- contractual requirements;
- applicable regulatory requirements.

Examples may include:

- authentication events;
- authorization failures;
- privilege changes;
- administrative operations;
- security-configuration changes;
- access to sensitive resources.

Audit retention must balance investigation value with privacy, security, and storage exposure.

### 13.20 Backup Retention

Backups require their own retention policy.

Retention must consider:

- recovery objectives;
- recovery-point coverage;
- historical restoration requirements;
- storage capacity;
- data classification;
- privacy;
- encryption-key availability.

Keeping backups longer than active data creates a longer-lived copy of that information and must be justified.

Backup retention must not be defined independently from data lifecycle and privacy requirements.

### 13.21 Archival

Archival moves data from active or frequently accessed storage into a lower-cost or less immediately accessible retention state while preserving approved future use.

Archival may support:

- historical analysis;
- audit;
- applicable legal requirements;
- long-term recovery;
- evidence.

Archived data remains governed data.

Archival does not remove:

- classification;
- privacy requirements;
- access control;
- encryption requirements;
- retention requirements;
- disposal responsibility.

### 13.22 Online Versus Archived Data

The architecture distinguishes:

**Online Retention**
→ data readily available to normal platform processing or consumption.

**Archived Retention**
→ data preserved for approved historical purposes but not necessarily available through normal low-latency paths.

This distinction can reduce operational cost and exposure without eliminating required historical information.

The exact archival mechanism is an implementation decision.

### 13.23 Archival and Replay

Archived data may support replay or reconstruction only when the archive preserves the information required for correct interpretation.

This may include:

- data content;
- event identity;
- timestamps;
- contract version;
- processing metadata;
- integrity information.

An archive that preserves bytes but cannot be interpreted or restored reliably does not satisfy a replay requirement.

### 13.24 Archival and Encryption

Archived encrypted data may remain retained for long periods.

Key lifecycle must therefore remain compatible with archival duration.

Destroying the required key prematurely may make retained data unusable.

Retaining keys indefinitely without appropriate protection may weaken security.

Archival and cryptographic-key lifecycle must therefore be coordinated.

### 13.25 Retention and Privacy

Personal-data retention must remain tied to approved purpose and applicable requirements.

Replay value or analytical usefulness does not automatically justify indefinite retention of identifying information.

Where historical value remains but direct identity is no longer required, governance may evaluate approaches such as:

- attribute removal;
- pseudonymization;
- anonymization;
- aggregation;
- restricted archival.

The appropriate treatment depends on the governed privacy and business requirement.

### 13.26 Retention and Data-Subject Requests

Approved privacy requests may affect data across multiple retention tiers.

The platform should be capable of identifying relevant locations such as:

- active datasets;
- historical layers;
- quarantine;
- backups;
- exports;
- archives.

The required action depends on the applicable privacy and legal process.

The architecture must support execution of the approved technical outcome where feasible.

### 13.27 Retention and Replay Risk

Long historical retention increases replay and reconstruction capability.

It also increases:

- privacy exposure;
- security exposure;
- storage cost;
- contract-version support;
- lineage requirements;
- backup responsibility.

Retention decisions must therefore balance:

**Recoverability and Historical Value**

against:

**Security Exposure + Privacy Exposure + Storage Cost**

Maximum retention is not automatically the safest architecture.

### 13.28 Retention and Certification

Certified analytical products may be recalculated or republished over historical periods.

Retention must preserve the data and governed definitions required for any claimed reconstruction capability.

If required historical data or versions have been intentionally disposed of, that limitation must be documented.

The platform must not claim reconstruction capability beyond retained history.

### 13.29 Disposal

Disposal occurs when data or governed artifacts no longer have an approved retention purpose.

It may apply to:

- active data;
- temporary data;
- archived data;
- quarantine;
- logs;
- metrics;
- evidence;
- backups;
- metadata;
- credentials;
- cryptographic keys.

The appropriate disposal mechanism depends on the technology, information type, classification, and retention requirement.

### 13.30 Logical Deletion

Logical deletion removes information from normal active use without necessarily removing its physical representation immediately.

Examples may include:

- lifecycle status changes;
- removal from active publication;
- access revocation;
- application-level deletion state.

Logical deletion must not automatically be represented as physical disposal.

The distinction must remain explicit.

### 13.31 Physical Disposal

Physical disposal aims to remove retained information according to the capabilities of the storage technology.

Behavior may differ across:

- SQL Server;
- Kafka;
- MinIO;
- filesystem storage;
- backups;
- archives.

Deleted information may remain temporarily in:

- logs;
- snapshots;
- object versions;
- backups;
- internal storage mechanisms.

Disposal requirements must therefore reflect actual technology behavior rather than assume that a logical DELETE removes every physical copy immediately.

### 13.32 Cryptographic Disposal

Where supported and appropriate, destruction of encryption keys may render protected data inaccessible.

Cryptographic disposal must not be assumed to be effective automatically.

Its effectiveness depends on factors such as:

- key isolation;
- absence of unencrypted copies;
- absence of alternate keys;
- backup behavior;
- technology implementation.

Cryptographic erasure must be validated before being claimed as a secure disposal mechanism.

### 13.33 Disposal and Backups

Removing information from active storage does not automatically remove it from backups.

Backup retention and restore procedures must therefore consider data that was deleted, transformed, or invalidated after the backup was created.

A restored backup may require reconciliation with current:

- retention;
- privacy;
- security;
- classification;
- governance state;

before being returned to normal service.

### 13.34 Disposal and Replay

Information intentionally removed or invalidated must not silently reappear through replay, restore, or rebuild.

Recovery must consider governance decisions made after the recovery source was created.

This is especially important for:

- privacy-driven removal;
- security-driven removal;
- invalidated credentials;
- retired Restricted data.

The governing rule is:

**Recovery Restores Technical State — It Does Not Automatically Override Later Governance Decisions**

### 13.35 Retention Policy Metadata

Governed assets should identify their applicable retention policy where practical.

Metadata may include:

- asset;
- owner;
- retention purpose;
- online retention;
- archival retention;
- disposal trigger;
- privacy considerations;
- recovery considerations;
- business or legal requirement reference where applicable;
- last review;
- lifecycle status.

Retention metadata must evolve with the requirement it represents.

### 13.36 Retention Ownership

Retention decisions require identifiable responsibility.

Relevant roles may include:

- Business Data Owner;
- Data Engineering;
- DBA;
- Security;
- Data Governance;
- Privacy / Legal;
- Platform / SRE;
- backup administration.

Version 1 may consolidate these responsibilities under one operator while preserving their logical distinction.

### 13.37 Retention Review

Retention policies should be reviewed when conditions change.

Relevant triggers include:

- new datasets;
- classification changes;
- privacy requirement changes;
- recovery-objective changes;
- material storage-cost changes;
- product deprecation;
- contract retirement;
- new organizational or applicable regulatory requirements;
- evidence showing current retention is insufficient or excessive.

Retention is therefore an evolving governance decision.

### 13.38 Retention Drift

Retention drift occurs when implemented lifecycle behavior diverges from governed policy.

Examples include:

- Kafka retaining less history than required;
- Bronze data never expiring despite policy;
- quarantine accumulating indefinitely;
- backups retained beyond approved periods;
- logs expiring before required evidence can be created.

Retention drift should be detectable through operational review or automated controls where practical.

Detected drift must be evaluated rather than silently becoming the new policy.

### 13.39 Laboratory Retention Model

Version 1 retention values should initially be treated as laboratory assumptions until measured workload and validation provide evidence for refinement.

The laboratory should demonstrate, where applicable:

- Kafka retention behavior;
- CDC retention implications;
- Bronze historical retention;
- temporary artifact cleanup;
- quarantine lifecycle;
- backup retention;
- evidence retention;
- controlled disposal.

The laboratory must not claim enterprise retention capability beyond the scenarios actually tested.

### 13.40 Enterprise Evolution

Enterprise implementation may strengthen lifecycle governance through capabilities such as:

- automated lifecycle policies;
- object-storage tiering;
- archival storage classes;
- centralized retention policy;
- legal hold;
- automated deletion;
- backup lifecycle automation;
- privacy workflow integration;
- retention reporting;
- automated detection of retention drift;
- policy-as-code;
- records-management integration.

These mechanisms strengthen enforcement while preserving the logical lifecycle principles.

### 13.41 Retention and Disposal Testing

Implemented lifecycle controls should be validated.

Representative tests include:

- Kafka data expires according to configured policy;
- required recovery remains possible within the retention window;
- temporary artifacts are cleaned up;
- quarantine reaches an explicit lifecycle outcome;
- archived data remains readable when required;
- disposed data is unavailable through its normal access path;
- invalidated security material is not restored through recovery;
- restored backups receive required current governance treatment;
- retention metadata matches implemented behavior.

The expected result must be defined before execution.

Detailed validation methodology is defined in Chapter 17.

### 13.42 Retention and Disposal Evidence

Evidence may identify:

- test identifier;
- governed asset;
- applicable retention rule;
- expected lifecycle behavior;
- observed behavior;
- archival state where applicable;
- disposal state;
- recovery result;
- relevant metrics or logs;
- implementation version;
- conclusion.

Evidence must not unnecessarily retain the very sensitive information whose lifecycle the test is intended to control.

### 13.43 Retention, Archival, and Disposal Guarantees

The Atlas Engineering lifecycle model must preserve the following guarantees:

1. retention is governed rather than determined solely by technology defaults;
2. different architectural layers may use different retention periods;
3. Kafka and CDC provide bounded operational history rather than permanent archival storage;
4. Bronze retention supports approved historical replay and reconstruction requirements;
5. derived-layer retention reflects operational and analytical value rather than unnecessary duplication;
6. Certified Gold version retention supports approved rollback, audit, and recovery requirements;
7. candidate, quarantine, and temporary data have explicit lifecycle expectations;
8. logs, metrics, lineage, metadata, contracts, processing versions, and evidence have retention appropriate to their purpose;
9. backups inherit applicable classification, privacy, security, and lifecycle requirements;
10. archival preserves governance rather than removing it;
11. archived data is considered a valid recovery source only when it remains interpretable and restorable;
12. cryptographic-key lifecycle remains compatible with retained encrypted data;
13. personal-data retention remains tied to approved purpose and applicable requirements;
14. retention balances recovery value against privacy, security, and storage exposure;
15. reconstruction capability is not claimed beyond retained history;
16. logical deletion and physical disposal remain distinguishable;
17. cryptographic disposal is not claimed without validating its effectiveness;
18. disposal considers backups, archives, exports, replicas, and recovery sources;
19. recovery does not intentionally restore data or trust that later governance decisions invalidated;
20. retention policies have identifiable ownership and metadata;
21. retention drift is treated as a governance and operational concern;
22. laboratory retention assumptions are refined through measured evidence;
23. implemented lifecycle behavior is testable and evidence-based;
24. retention, archival, and disposal claims remain limited to behavior actually implemented and validated.

---

## 14. Auditability and Security Observability

Auditability and security observability provide the information required to understand security-relevant activity across Atlas Engineering.

Security controls must not operate as invisible mechanisms.

Where technically supported, the platform should preserve enough information to determine:

- which identity performed or attempted an action;
- which resource was accessed;
- which operation was requested;
- whether authentication succeeded;
- whether authorization succeeded;
- whether elevated privilege was involved;
- whether security-sensitive configuration changed;
- when the event occurred;
- which component recorded it;
- whether the event affected data, access, credentials, or platform behavior.

Auditability supports accountability and reconstruction.

Security observability supports detection, monitoring, and investigation.

The governing model is:

**Security-Relevant Action → Structured Event → Correlation → Monitoring → Investigation → Evidence**

### 14.1 Auditability

Auditability means that security-relevant activity can be attributed and reconstructed according to the capabilities of the platform.

Relevant actions may include:

- authentication attempts;
- authorization decisions;
- privilege changes;
- role changes;
- identity lifecycle operations;
- credential rotation or revocation;
- administrative actions;
- security-configuration changes;
- access to sensitive resources;
- certification and publication;
- security-sensitive recovery.

Not every ordinary processing event requires the same audit depth.

Audit scope should reflect risk, sensitivity, and operational value.

### 14.2 Security Observability

Security observability provides operational visibility into security-related conditions.

Relevant signals may include:

- authentication failures;
- authorization denials;
- repeated rejected access;
- unexpected administrative activity;
- certificate expiration risk;
- credential failures;
- unusual service behavior;
- security-control failures;
- unexpected network communication;
- secret-exposure findings.

Security observability should integrate with broader platform observability rather than operate as an isolated monitoring system.

### 14.3 Identity Attribution

Where technically supported, security events must identify the actor responsible for the action.

The actor may be:

- a human identity;
- a service identity;
- an administrative identity;
- an orchestration identity;
- an analytical consumer.

Specific attribution should be preferred over generic identities such as:

**admin**

or:

**service**

when a more precise identity is available.

Shared human accounts reduce attribution quality and should be avoided where practical.

### 14.4 Service Attribution

Automated processing must also remain attributable.

The platform should be capable of distinguishing security-relevant actions performed by services such as:

- Debezium;
- Bronze processing;
- Silver processing;
- Gold processing;
- Airflow;
- Power BI;
- observability components.

Separate service identities improve attribution and reduce ambiguity during investigation.

### 14.5 Authentication Events

Authentication events should be observable where supported.

Relevant outcomes may include:

- successful authentication;
- invalid credential;
- expired credential;
- revoked credential;
- disabled identity;
- unavailable identity provider;
- certificate failure;
- token validation failure.

Repeated authentication failures may represent configuration defects, credential lifecycle problems, or unauthorized activity and must be interpreted in context.

### 14.6 Authorization Events

Authorization denial is a meaningful security event.

A denial may indicate:

- correctly enforced least privilege;
- incorrect permissions;
- attempted unauthorized access;
- use of the wrong identity;
- access drift.

Where supported, authorization events should identify:

- identity;
- requested resource;
- requested operation;
- result;
- timestamp;
- component.

An expected denial is successful security enforcement, not necessarily a platform failure.

### 14.7 Privilege Changes

Changes to roles, permissions, ownership, or administrative access should be auditable where supported.

Relevant events may include:

- permission granted;
- permission revoked;
- role membership added;
- role membership removed;
- elevated access enabled;
- elevated access removed.

Privilege changes alter the security state even when no application code changes.

They must therefore remain governed and attributable.

### 14.8 Administrative Operations

Administrative activity requires stronger accountability than routine processing.

Relevant operations may include:

- changing Kafka configuration;
- modifying SQL Server permissions;
- changing MinIO policies;
- changing Airflow security configuration;
- changing Grafana users or data sources;
- modifying network exposure;
- restoring backups;
- changing retention or authentication settings.

Administrative activity should be attributable to the responsible identity or process.

### 14.9 Security Configuration Changes

Security configuration is part of the governed platform state.

Changes may include:

- authentication mechanisms;
- authorization policies;
- network rules;
- TLS settings;
- certificate trust;
- secret references;
- audit configuration;
- access roles.

Where practical, such changes should be version-controlled, attributable, auditable, or otherwise traceable.

### 14.10 Sensitive Resource Access

Access to Restricted or otherwise high-sensitivity resources may require enhanced auditability.

Examples include:

- secret-management resources;
- private keys;
- security configuration;
- backup repositories;
- sensitive quarantine data;
- privileged administrative interfaces;
- Restricted datasets.

Audit design should consider both successful and denied access without recording the protected values themselves.

### 14.11 Certified Gold and Publication Auditability

Certification and publication are governance-sensitive actions.

Auditability should allow the platform to determine:

- which candidate was evaluated;
- which quality and reconciliation results applied;
- which version was certified;
- which version was published;
- when publication occurred;
- which identity or process performed the action;
- whether rollback occurred;
- which version became consumer-visible.

This supports accountability for changes to the governed analytical state.

### 14.12 Security Audit Data Classification

Audit information may itself be sensitive.

Security logs may reveal:

- usernames;
- service identities;
- hostnames;
- resource names;
- access patterns;
- failures;
- administrative activity;
- internal architecture.

Audit data must therefore be classified and protected according to its content.

Useful security evidence is not automatically appropriate for public disclosure.

### 14.13 Secrets Must Not Be Audited as Values

Auditability must record credential-related activity without recording reusable credential values.

For example:

**Credential Rotation Completed**

is appropriate.

Recording the new password, token, private key, or full secret value is not.

Authentication failures must likewise avoid preserving submitted secret material.

### 14.14 Personal Data in Security Logs

Security logs should minimize personal data.

User identity may be necessary for accountability, but complete business payloads or unrelated customer attributes usually are not.

Where human identity information is retained for audit purposes, the audit system itself becomes subject to applicable privacy and retention requirements.

### 14.15 Structured Security Logging

Security-relevant logs should use structured fields where supported.

Useful fields may include:

- timestamp;
- component;
- identity;
- identity type;
- resource;
- action;
- authentication result;
- authorization result;
- execution identifier;
- correlation identifier;
- severity;
- event category;
- error code;
- policy or role reference.

Structured events improve filtering, correlation, alerting, and evidence preparation.

### 14.16 Correlation Across Components

A security investigation may require events from multiple systems.

For example:

**Power BI authentication failure**
may need correlation with:

**SQL Server authorization denial**

or:

**Credential Rotation**
may need correlation with:

**Service Authentication Failure**

Where practical, common timestamps, identities, execution IDs, or correlation identifiers should support cross-component analysis.

### 14.17 Time Consistency

Audit investigation depends on reliable event sequencing.

Platform components should use consistent time synchronization appropriate to the environment.

Stored timestamps should remain unambiguous across:

- components;
- time zones;
- logs;
- metrics;
- evidence.

Large unexplained clock differences can make investigation unreliable.

### 14.18 Audit Integrity

Security audit information must be protected against unauthorized modification or deletion according to its importance.

An actor should not be able to perform a sensitive action and trivially remove the only evidence of it.

The laboratory may use simpler integrity controls than an enterprise implementation.

Enterprise environments may strengthen this through centralized or immutable audit storage.

### 14.19 Audit Availability

Audit information must remain available for its approved investigation and evidence period.

Audit records that expire before they can be reviewed may provide insufficient operational value.

Availability must therefore align with:

- investigation requirements;
- evidence requirements;
- privacy;
- storage capacity;
- sensitivity.

Detailed retention requirements are defined in Chapter 13.

### 14.20 Security Metrics

Security metrics may summarize behavior without exposing individual sensitive events unnecessarily.

Examples include:

- authentication failures per period;
- authorization denials per component;
- privilege-change count;
- failed credential usage;
- certificate expiration days;
- secret-scanning findings;
- unauthorized-access attempts;
- security-test pass/fail state.

Metrics support awareness while detailed audit events support investigation.

### 14.21 Security Dashboards

Grafana may expose security-oriented operational views where appropriate.

Useful perspectives may include:

**Authentication**
→ are users and services authenticating normally?

**Authorization**
→ are denials increasing unexpectedly?

**Credentials**
→ are expiration or rotation issues occurring?

**Network Security**
→ are TLS or communication failures occurring?

**Privileged Activity**
→ have administrative or permission changes occurred?

Security dashboards must not expose secret values or unnecessary sensitive data.

### 14.22 Security Alerting

Security alerts should focus on actionable conditions.

Representative scenarios include:

- repeated authentication failures;
- unexpected authorization denials;
- privileged access outside expected operation;
- credential expiration risk;
- certificate expiration risk;
- secret-scanning detection;
- unexpected security-configuration change;
- repeated access to Restricted resources;
- unauthorized communication where detectable.

Alert thresholds should be calibrated to avoid excessive non-actionable noise.

### 14.23 Baseline Security Behavior

Security observability benefits from understanding normal behavior.

Examples include:

- expected service authentication patterns;
- normal authorization-denial volume;
- normal administrative activity;
- expected connection sources;
- expected security-error frequency.

Unexpected deviation may support investigation.

Version 1 may begin with simpler explicit rules before enough history exists for meaningful behavioral baselines.

### 14.24 Audit Trail for Access Changes

Access provisioning, modification, and revocation should remain traceable where practical.

The platform should be able to identify:

- what access changed;
- which identity was affected;
- who or what performed the change;
- when it occurred;
- associated reason or change reference where available.

This supports access review and drift investigation.

### 14.25 Audit Trail for Credential Lifecycle

Credential lifecycle events should be traceable without exposing credential values.

Relevant events may include:

- credential created;
- credential activated;
- credential rotated;
- previous credential revoked;
- credential expired;
- credential disabled after compromise.

This allows authentication failures or incidents to be correlated with credential state.

### 14.26 Audit Trail for Recovery

Recovery may involve elevated or security-sensitive operations.

Relevant actions may include:

- backup restore;
- temporary privilege escalation;
- replay initiation;
- recovery-environment access;
- credential replacement;
- security-configuration restoration;
- removal of recovery privileges.

Recovery evidence should demonstrate restoration of both technical service and intended security boundaries.

### 14.27 Security Investigation

A security investigation should be capable of reconstructing the relevant sequence of events.

Typical questions include:

1. What happened?
2. When did it begin?
3. Which identity was involved?
4. Which resource was accessed?
5. Did authentication succeed?
6. Was the operation authorized?
7. Were privileges changed?
8. Was sensitive data affected?
9. Which downstream systems may be involved?
10. What remediation was required?

Audit logs, observability, lineage, access metadata, and configuration history may all contribute to the answer.

### 14.28 Security Incident Evidence

Evidence from a controlled security incident or test may preserve:

- test or incident identifier;
- scenario;
- affected identity;
- affected resource;
- expected behavior;
- observed behavior;
- authentication result;
- authorization result;
- relevant audit events;
- relevant metrics;
- remediation;
- final state;
- timestamp;
- implementation version;
- conclusion.

Evidence must be sanitized before public publication.

### 14.29 Negative Security Evidence

A failed security test is valid evidence.

For example:

**Expected**
→ Power BI denied access to AtlasCommerce.

**Observed**
→ Power BI successfully accessed AtlasCommerce.

Result:

**TEST FAILED**

The correct response is:

**Unexpected Result → Investigate → Remediate → Revalidate**

The documented expectation must not be changed merely to convert an unexpected result into a PASS.

Where appropriate, failed evidence should be retained to preserve the improvement history.

### 14.30 Security Observability During Failure

Operational failures may create security-relevant symptoms.

Examples include:

- credential failures after rotation;
- authorization denials after role change;
- TLS failures after certificate renewal;
- unavailable security dependencies;
- recovery workloads requesting broader access than expected.

Not every security alert indicates malicious activity.

Some represent configuration or lifecycle defects that still require correction.

Security observability must therefore remain correlated with broader platform failure handling.

### 14.31 Auditability and Privacy

Auditability and privacy may create competing requirements.

Audit systems require enough identity context to provide accountability.

Privacy requires unnecessary personal information to be minimized.

The platform must preserve the minimum identity information necessary for the approved audit purpose.

Auditability must not become justification for uncontrolled personal-data retention.

### 14.32 Auditability and Retention

Audit retention must align with the period during which information remains necessary for:

- security investigation;
- operational troubleshooting;
- access review;
- evidence;
- applicable organizational or compliance-supporting processes.

Retention must remain explicit.

Keeping audit information indefinitely can increase cost and exposure.

Deleting it too quickly can undermine investigation.

Detailed lifecycle requirements are defined in Chapter 13.

### 14.33 Laboratory Security Observability

Version 1 should demonstrate representative security observability using the capabilities available from the selected technologies.

The laboratory should aim to capture evidence for:

- successful authentication;
- failed authentication;
- authorized access;
- denied access;
- service-specific identity;
- credential rotation;
- credential revocation;
- privileged or administrative activity;
- network or TLS failure where implemented;
- security-test results.

Not every enterprise SIEM or centralized audit capability must be reproduced locally.

The laboratory must clearly distinguish what is implemented from what remains enterprise evolution.

### 14.34 Enterprise Evolution

Enterprise deployment may strengthen auditability and security observability through capabilities such as:

- centralized log aggregation;
- Security Information and Event Management (SIEM);
- immutable or protected audit storage;
- centralized identity audit;
- privileged-access monitoring;
- automated threat detection;
- security analytics;
- centralized certificate monitoring;
- centralized secrets audit;
- network-flow monitoring;
- incident-response integration;
- automated retention policy;
- security-event correlation.

These capabilities strengthen scale and enforcement without changing the fundamental audit requirements.

### 14.35 Auditability Testing

Implemented audit controls should be tested.

Representative tests include:

- successful authentication generates expected audit context;
- failed authentication is recorded;
- authorization denial is recorded;
- privilege changes are attributable;
- credential rotation generates lifecycle evidence;
- revoked credentials fail authentication;
- sensitive values are absent from audit logs;
- administrative operations are traceable;
- recovery-related privileged access is traceable;
- cross-component correlation works where expected.

Expected audit behavior must be defined before execution.

Detailed validation methodology is defined in Chapter 17.

### 14.36 Auditability Evidence

Auditability evidence may include:

- test identifier;
- action;
- identity;
- resource;
- expected audit event;
- observed audit event;
- timestamp;
- correlation information;
- relevant security metric;
- implementation version;
- conclusion.

Evidence must be redacted where necessary to prevent disclosure of Restricted information, reusable secrets, or unnecessary personal data.

### 14.37 Auditability and Security Observability Guarantees

The Atlas Engineering security-observability model must preserve the following guarantees:

1. security-relevant actions are attributable where technically supported;
2. human, service, and administrative activity remain distinguishable;
3. authentication and authorization outcomes remain conceptually distinct;
4. expected authorization denial is recognized as successful security enforcement;
5. privilege and security-configuration changes are auditable where supported;
6. access to sensitive resources may receive stronger audit treatment;
7. certification and publication actions remain auditable;
8. audit information is classified and protected according to its content;
9. auditability does not require recording secret values;
10. personal-data exposure in audit and observability is minimized;
11. structured logging supports security investigation where practical;
12. cross-component correlation is supported through useful identifiers and timestamps;
13. timestamp consistency supports reliable event sequencing;
14. security audit information receives appropriate integrity and retention protection;
15. metrics, dashboards, and alerts provide security visibility without exposing protected values;
16. access and credential lifecycle changes remain traceable where practical;
17. recovery-related security activity remains auditable;
18. failed security tests remain valid evidence and drive remediation;
19. security observability remains integrated with broader platform observability;
20. privacy and auditability are balanced according to defined purpose;
21. laboratory security observability remains distinguishable from enterprise SIEM capability;
22. implemented audit controls are testable and evidence-based;
23. security claims remain limited to the behavior actually implemented and validated.

---

## 15. Security Incident and Recovery Considerations

Security incidents must be handled as controlled operational events that preserve platform integrity, data protection, evidence, and recovery capability.

A security incident may involve:

- credential compromise;
- unauthorized access;
- excessive privilege;
- secret exposure;
- data disclosure;
- unexpected administrative activity;
- compromised service identity;
- certificate or key compromise;
- unauthorized configuration change;
- unauthorized network communication;
- loss or alteration of governed data;
- security-control failure.

Security recovery must restore more than service availability.

Where affected, the platform must also restore:

- trusted identities;
- valid credentials;
- intended authorization;
- secure communication;
- correct data state;
- governed publication state;
- observability;
- auditability.

The governing progression is:

**Detect → Contain → Preserve Evidence → Revoke or Isolate → Remediate → Recover → Validate → Restore Normal Trust**

### 15.1 Security Incident Classification

Security events must be evaluated according to their nature and potential impact.

Relevant categories may include:

- authentication incident;
- authorization incident;
- credential compromise;
- secret exposure;
- confidentiality incident;
- integrity incident;
- availability incident with security impact;
- administrative misuse;
- configuration compromise;
- network-security incident;
- privacy-related incident.

Classification supports appropriate containment, investigation, recovery, and escalation.

Not every security-relevant event is necessarily a security incident.

For example, a failed login caused by an expired service credential may represent an operational configuration problem.

Repeated unexplained failures or use of known-invalid credentials may require security investigation.

### 15.2 Detection

Security incidents may be detected through:

- authentication logs;
- authorization denials;
- administrative audit records;
- secret-scanning findings;
- unexpected network activity;
- abnormal service behavior;
- data-access anomalies;
- security alerts;
- platform observability;
- manual investigation;
- external notification.

Detection should provide enough context to begin investigation without unnecessarily exposing sensitive information.

Detailed auditability and security-observability requirements are defined in Chapter 14.

### 15.3 Initial Assessment

The initial assessment should identify, where possible:

- what was detected;
- when it began;
- affected identity;
- affected service;
- affected resource;
- data classification;
- potential personal-data impact;
- affected credentials;
- affected systems;
- whether unauthorized activity remains active;
- immediate containment options.

The assessment may evolve as evidence becomes available.

Incomplete information must not prevent obvious containment of an active security risk.

### 15.4 Containment

Containment limits continued exposure, unauthorized activity, or propagation of potentially compromised state.

Possible actions include:

- disabling an identity;
- revoking a credential;
- blocking network access;
- isolating a service;
- pausing processing;
- suspending publication;
- restricting a dataset;
- removing excessive privilege.

Containment should be proportional to the incident while prioritizing protection of trusted state.

Temporary service degradation may be preferable to continued compromise.

### 15.5 Credential Compromise

A credential whose confidentiality can no longer reasonably be trusted must be treated as compromised.

Response should consider:

1. identifying the affected identity and resources;
2. revoking or disabling the credential;
3. containing unauthorized use;
4. creating a replacement credential;
5. securely updating legitimate workloads;
6. validating authentication with the replacement;
7. confirming rejection of the compromised credential;
8. investigating activity performed with the affected identity.

Deleting the exposed value from a configuration file does not restore trust in the credential.

Detailed credential lifecycle requirements are defined in Chapter 6.

### 15.6 Secret Exposure

Secret exposure may occur through:

- source control;
- logs;
- screenshots;
- documentation;
- evidence;
- configuration exports;
- troubleshooting;
- unauthorized file access.

The governing response is:

**Exposed Secret → Treat as Untrusted → Revoke or Replace → Validate**

Artifact cleanup reduces continued disclosure.

It does not independently restore confidentiality or trust.

### 15.7 Unauthorized Access

Unauthorized access requires investigation of both:

- how the access path became available;
- what activity occurred after access was obtained.

Investigation may consider:

- identity;
- credential;
- authorization policy;
- privilege changes;
- accessed resources;
- data classification;
- duration;
- downstream impact;
- exports or copied data;
- audit evidence.

Containment must remove the unauthorized access path before normal trust is restored.

### 15.8 Excessive Privilege

An incident may reveal that an identity has broader permissions than its approved responsibility requires.

Examples include:

- service identity with administrative privileges;
- analytical consumer with source access;
- observability identity with write permission;
- temporary troubleshooting privilege never removed.

Response should include:

- reducing access to the required scope;
- identifying how the excessive permission was introduced;
- reviewing similar identities for related drift;
- validating required and prohibited behavior after correction.

Excessive privilege is both a security defect and an access-governance defect.

### 15.9 Service Identity Compromise

Compromise of a service identity may affect automated processing across multiple executions.

Response should consider:

- isolating or stopping the affected workload;
- revoking its credentials;
- identifying the affected processing window;
- determining what data it read, produced, or modified;
- identifying downstream outputs derived from potentially compromised processing;
- replacing the identity or credential;
- restoring the intended access scope;
- validating the service before resuming normal processing.

Restarting a service with the same compromised identity does not constitute security recovery.

### 15.10 Data Confidentiality Incident

A confidentiality incident occurs when governed data may have been accessed or disclosed without authorization.

Investigation should consider:

- classification;
- personal-data status;
- affected scope;
- identity;
- access path;
- duration;
- export or external-copy possibility;
- downstream exposure;
- available evidence.

The platform provides technical evidence.

Organizational, legal, contractual, and privacy-response decisions remain outside the platform's sole authority.

### 15.11 Data Integrity Incident

A security incident may alter governed data or the definitions used to produce it.

Examples include unauthorized modification of:

- source data;
- events;
- Bronze;
- Silver;
- Gold;
- quality rules;
- reconciliation logic;
- certification state;
- publication state.

Recovery must identify the last trusted input or processing state and determine which downstream outputs were derived from potentially altered information.

Lineage is a primary mechanism for impact analysis.

### 15.12 Integrity Recovery

Integrity recovery may require:

- isolating affected data;
- determining the last trusted source or layer;
- replaying from Kafka;
- rebuilding from Bronze;
- rebuilding Gold from Silver;
- restoring from backup;
- rerunning quality and reconciliation;
- recertifying;
- republishing.

The recovery source must be selected according to which layers remain trusted.

A compromised downstream state must not automatically be used as its own recovery source.

### 15.13 Certified Gold Security Incident

If Certified Gold is suspected to have been modified, exposed, or published improperly, the platform must protect the governed consumer boundary.

Possible responses include:

- blocking new publication;
- retaining the last known-good certified version;
- temporarily restricting consumer access;
- rolling back to a prior trusted certified version;
- rebuilding affected Gold state;
- rerunning quality and reconciliation;
- recertifying and republishing.

A published version must not be considered trusted solely because it carries a certification label.

Certification metadata itself may be part of the compromised state.

### 15.14 Last Known-Trusted State

Security recovery requires identifying the most recent state that can still be trusted.

This may differ from the last technically successful state.

For example:

**Gold V12**
→ technically successful  
→ produced after compromise of the transformation identity

may be less trustworthy than:

**Certified Gold V11**
→ produced before the compromise

Recovery decisions must therefore prefer:

**Last Known-Trusted State**

over:

**Last Successful Execution**

### 15.15 Security Recovery and Backup

Backups may provide a recovery source, but they may also preserve:

- compromised credentials;
- vulnerable configuration;
- excessive permissions;
- unauthorized changes;
- obsolete privacy state.

Restoring a backup does not automatically restore a trusted platform.

Before normal service resumes, the restored environment must be evaluated against current:

- credential state;
- authorization;
- security configuration;
- privacy decisions;
- retention decisions;
- certificate or key state;
- known incident findings.

### 15.16 Recovery Must Not Restore Invalidated Trust

A fundamental security-recovery rule is:

**Recovery May Restore Technical State — It Must Not Restore Invalidated Trust**

Invalidated trust may include:

- compromised password;
- leaked token;
- revoked certificate;
- compromised cryptographic key;
- unauthorized privilege;
- vulnerable configuration;
- retired service identity.

If a recovery source contains such state, it must be replaced or corrected before normal operation resumes.

### 15.17 Recovery and Privileged Access

Security recovery may require elevated privileges.

Such access must remain:

- explicit;
- authorized;
- scoped;
- attributable;
- auditable;
- temporary where supported.

Recovery privileges must be removed or reduced when the recovery activity ends.

Emergency access must not silently become normal access.

### 15.18 Break-Glass Access

Enterprise environments may use controlled break-glass access when normal administrative mechanisms are unavailable.

Where implemented, break-glass access should include controls such as:

- restricted ownership;
- explicit activation;
- strong authentication;
- minimum required scope;
- monitoring;
- auditability;
- post-use review;
- credential rotation after use where appropriate.

Version 1 does not require an enterprise break-glass implementation.

The architecture preserves the concept for future evolution.

### 15.19 Evidence Preservation

Investigation may require preserving evidence before remediation alters the environment.

Relevant evidence may include:

- audit records;
- authentication and authorization events;
- configuration state;
- access policies;
- security metrics;
- affected-object metadata;
- lineage;
- version metadata;
- timestamps.

Evidence preservation must not justify unnecessary duplication of complete sensitive datasets.

The minimum information required to investigate and demonstrate the incident should be preferred.

### 15.20 Evidence Integrity

Incident evidence must remain distinguishable from ordinary mutable troubleshooting output.

Where practical, evidence should preserve:

- source;
- timestamp;
- collection context;
- incident or test identifier;
- integrity characteristics;
- responsible investigator or collecting process.

Enterprise environments may strengthen this through protected or immutable evidence repositories.

The laboratory should preserve evidence in a controlled and documented manner.

### 15.21 Incident Correlation

Security incidents may cross several platform components.

For example:

**Credential Exposure**
→ unauthorized SQL Server authentication  
→ source access  
→ unexpected event activity  
→ downstream processing

Investigation may therefore require correlation across:

- security logs;
- SQL Server;
- Debezium;
- Kafka;
- MinIO;
- processing jobs;
- Gold;
- Certified Gold;
- network observations.

Identities, timestamps, event identifiers, processing identifiers, and lineage should help reconstruct the sequence.

### 15.22 Incident and Lineage

Lineage supports security impact analysis.

If compromised data or processing enters the platform, lineage should help determine:

- which Silver data was affected;
- which Gold structures were derived;
- which certified versions were affected;
- which consumers may have received the result.

This allows remediation to target the affected scope rather than automatically rebuilding unrelated data.

### 15.23 Incident and Privacy Governance

A security incident involving personal data also requires privacy impact evaluation.

The platform should provide technical information such as:

- affected personal-data categories;
- approximate scope where determinable;
- affected systems;
- relevant identities;
- timing;
- downstream propagation;
- containment;
- remediation.

Privacy or legal responsibilities determine applicable organizational or notification requirements.

The architecture provides evidence; it does not independently make the legal determination.

### 15.24 Incident and Retention

Incident response may temporarily require preserving information that would otherwise reach normal retention expiry.

Such preservation must be explicit.

An investigation requirement must not silently redefine permanent retention for all platform data.

Enterprise environments may use controlled incident-hold or legal-hold mechanisms where applicable.

### 15.25 Security Recovery Validation

A security incident is not considered recovered merely because the affected service is running again.

Validation should confirm, where applicable:

- compromised credential rejected;
- replacement credential operational;
- excessive access removed;
- intended access restored;
- unauthorized communication blocked;
- affected data corrected or rebuilt;
- quality and reconciliation passed;
- Certified Gold returned to trusted state;
- elevated recovery access removed;
- auditability restored;
- security observability functioning.

Security recovery includes restoration of both technical operation and trusted state.

### 15.26 Service-Level Security Recovery

A service may be technically available while still operating under reduced trust.

For example:

**Service = UP**

while:

- an emergency credential remains active;
- excessive permission remains;
- certification has not been revalidated;
- auditability is unavailable.

Normal security recovery must not be declared complete until required controls are restored or residual risk is explicitly accepted through the appropriate governance process.

### 15.27 Post-Incident Review

A meaningful incident should result in review of:

- root cause;
- detection effectiveness;
- containment effectiveness;
- credential or access design;
- architectural weaknesses;
- recovery behavior;
- evidence quality;
- missing observability;
- test gaps;
- documentation gaps.

The review may result in:

- implementation changes;
- security-policy changes;
- new tests;
- new alerts;
- architecture updates;
- ADRs;
- revised procedures.

Incidents should improve the architecture rather than remain isolated operational events.

### 15.28 Security Incident Test Scenarios

Version 1 should use controlled scenarios to validate security recovery without creating real compromise.

Representative scenarios include:

**SEC-001 — Exposed Service Credential**

Expected behavior:

1. exposure is detected or declared;
2. credential is treated as compromised;
3. old credential is revoked;
4. replacement credential is provisioned;
5. legitimate service resumes;
6. old credential is rejected;
7. audit evidence is preserved.

**SEC-002 — Unauthorized Layer Access**

Expected behavior:

1. unauthorized operation is attempted;
2. access is denied;
3. denial is observable;
4. no data is modified or exposed;
5. evidence confirms expected enforcement.

**SEC-003 — Excessive Permission Detection**

Expected behavior:

1. implemented permission exceeds the approved access model;
2. drift is identified;
3. privilege is reduced;
4. required operation still succeeds;
5. prohibited operation is denied.

Detailed test methodology is defined in Chapter 17.

### 15.29 Security Incident Evidence

Security incident evidence should identify:

- incident or test identifier;
- scenario;
- initial trusted state;
- affected identity;
- affected resource;
- classification;
- detection;
- containment;
- preserved evidence;
- remediation;
- credential or access changes;
- data-recovery actions where applicable;
- validation results;
- final trusted state;
- residual risk where applicable;
- timestamp;
- implementation version;
- conclusion.

Evidence must be sanitized before public publication.

### 15.30 Laboratory Security Recovery

Version 1 does not reproduce every enterprise incident-response capability.

Its purpose is to demonstrate representative technical behavior such as:

- credential revocation;
- credential replacement;
- authorization correction;
- service isolation;
- trusted-state recovery;
- access-boundary restoration;
- security observability;
- controlled evidence.

Successful laboratory scenarios do not imply enterprise incident-response maturity.

### 15.31 Enterprise Evolution

Enterprise implementation may strengthen incident response through capabilities such as:

- formal Security Operations Center processes;
- SIEM and SOAR;
- centralized incident management;
- automated containment;
- enterprise credential revocation;
- endpoint detection and response;
- network detection and response;
- forensic collection;
- legal hold;
- formal incident communication;
- privacy incident workflows;
- centralized evidence repositories;
- disaster-recovery coordination.

These capabilities strengthen operational response without changing the principle that security recovery restores both technical function and trusted state.

### 15.32 Security Incident and Recovery Guarantees

The Atlas Engineering security incident and recovery model must preserve the following guarantees:

1. security incidents are evaluated according to their nature and potential impact;
2. detection provides sufficient context for containment and investigation where technically possible;
3. active security risk may be contained before complete investigation is finished;
4. exposed or compromised credentials are treated as untrusted;
5. artifact cleanup does not independently restore credential trust;
6. unauthorized access is investigated for both access path and affected activity;
7. excessive privilege is treated as a security and governance defect;
8. compromised service identities are remediated rather than simply restarted;
9. confidentiality and integrity incidents trigger impact analysis appropriate to the affected data;
10. lineage supports identification of downstream impact;
11. recovery uses the last known-trusted state rather than merely the last successful state;
12. backup restore does not automatically restore a trusted security state;
13. recovery does not restore compromised, revoked, expired, or otherwise invalidated trust;
14. elevated recovery access remains explicit, scoped, attributable, and temporary where supported;
15. incident evidence is preserved without unnecessary sensitive-data duplication;
16. security recovery restores authentication, authorization, data integrity, observability, and auditability where affected;
17. service availability alone does not prove security recovery;
18. privacy impact is evaluated when personal data may be involved;
19. incident-related retention changes remain explicit;
20. post-incident review may result in architectural, implementation, testing, monitoring, and documentation improvements;
21. laboratory scenarios remain controlled and do not represent enterprise incident-response maturity;
22. implemented incident and recovery behavior is testable and evidence-based;
23. security recovery claims remain limited to scenarios and controls actually implemented and validated.

---

## 16. Roles and Responsibilities

Atlas Engineering separates architectural responsibilities according to the concerns they govern.

Roles describe responsibilities rather than necessarily representing individual people, teams, or job titles.

In a small environment, one person may perform several roles.

In an enterprise environment, the same responsibilities may be distributed across specialized teams.

The architecture must preserve these logical boundaries regardless of organizational size.

The governing principle is:

**Role Separation Defines Responsibility — Organizational Structure Defines Who Performs It**

### 16.1 Responsibility Model

The security and governance model recognizes responsibilities associated with:

- Data Engineering;
- Database Administration;
- Platform / SRE;
- Security;
- Data Governance;
- Privacy / Legal;
- Business Data Ownership;
- Business Intelligence / Analytics;
- Data Consumption;
- Audit or Investigation where applicable.

These responsibilities may overlap operationally but must remain distinguishishable conceptually.

This separation supports:

- ownership;
- accountability;
- least privilege;
- change governance;
- incident response;
- escalation;
- validation;
- evidence;
- enterprise evolution.

### 16.2 Data Engineering

Data Engineering is responsible for the design, implementation, operation, and evolution of governed data processing across the analytical platform.

Responsibilities may include:

- ingestion architecture;
- Debezium integration;
- Kafka event processing;
- Bronze persistence;
- Silver transformation;
- Gold processing;
- orchestration;
- replay;
- backfill;
- data-quality implementation;
- reconciliation implementation;
- lineage;
- processing metadata;
- data-product implementation;
- technical documentation;
- processing tests;
- recovery validation.

Data Engineering does not independently define every business, privacy, security, or legal requirement.

It implements approved requirements within the data platform.

### 16.3 Data Engineering and Source Ownership

Data Engineering consumes governed source information but does not automatically own the operational source schema.

AtlasCommerce remains responsible for its transactional domain and operational data model.

Data Engineering must evaluate source changes for downstream impact rather than assuming authority to redesign the source solely for analytical convenience.

Where source changes are required to support reliable integration, they should be coordinated through the appropriate source ownership process.

### 16.4 Database Administration

Database Administration is responsible for database-platform concerns where applicable.

Responsibilities may include:

- SQL Server installation and configuration;
- database availability;
- backup and restore;
- database security;
- database identities and permissions;
- storage;
- performance;
- maintenance;
- CDC configuration;
- database-level observability;
- database recovery.

DBA responsibility does not automatically include ownership of downstream analytical transformations or business definitions.

Likewise, administrative database privilege does not independently justify unrestricted business-data use.

### 16.5 DBA and CDC

CDC creates a shared responsibility boundary between Database Administration and Data Engineering.

Database Administration may be responsible for:

- enabling and maintaining CDC;
- source-database configuration;
- CDC retention;
- database permissions;
- source-side troubleshooting.

Data Engineering may be responsible for:

- Debezium integration;
- capture progress;
- event production;
- downstream processing;
- detecting ingestion impact.

Changes to CDC behavior should therefore consider both source-database and downstream data-platform consequences.

### 16.6 Platform / SRE

Platform / SRE is responsible for the runtime environment supporting platform services.

Responsibilities may include:

- container or compute runtime;
- service availability;
- networking;
- storage infrastructure;
- platform monitoring;
- capacity;
- deployment automation;
- infrastructure configuration;
- platform recovery.

Infrastructure administration does not automatically imply unrestricted access to the business data processed by the services.

Technical privilege should remain limited according to operational responsibility where the technology supports that separation.

### 16.7 Platform Reliability Responsibility

Platform reliability responsibility focuses on maintaining the technical conditions required for the data platform to operate within its defined expectations.

Relevant concerns may include:

- availability;
- resource capacity;
- service health;
- storage health;
- network connectivity;
- operational monitoring;
- infrastructure recovery;
- deployment reliability.

Platform reliability does not independently determine whether processed data is correct, reconciled, certified, or appropriate for analytical consumption.

Service health and data trust remain distinct responsibilities.

### 16.8 Security

Security is responsible for defining, coordinating, or governing protection requirements according to the organizational model.

Responsibilities may include:

- security architecture;
- identity requirements;
- authentication requirements;
- authorization principles;
- secrets-management requirements;
- encryption requirements;
- network-security requirements;
- security monitoring;
- vulnerability management;
- incident-response coordination;
- security validation requirements.

Security responsibility does not imply that one security team technically implements every control.

Implementation may remain distributed across the teams that own the affected technologies.

### 16.9 Security and Technical Teams

Security requirements and technical implementation must remain connected.

For example:

**Security**
→ defines the requirement for credential isolation.

**Data Engineering**
→ implements separate processing credentials.

**DBA**
→ implements database permissions.

**Platform / SRE**
→ implements infrastructure or network controls.

**Security / Validation**
→ verifies that the intended boundary is enforced.

This separation allows security policy and implementation ownership to remain explicit without requiring one team to administer every technology.

### 16.10 Data Governance

Data Governance coordinates the controlled meaning, ownership, classification, lifecycle, and use of governed data assets.

Responsibilities may include:

- metadata governance;
- classification;
- lineage requirements;
- ownership;
- data-product governance;
- retention governance;
- quality governance;
- contract governance;
- certification governance;
- documentation expectations.

Data Governance does not automatically implement every technical control.

Its responsibility is to ensure that governed requirements remain defined, owned, reviewable, and traceable.

### 16.11 Data Governance and Data Engineering

Data Governance and Data Engineering have complementary responsibilities.

A representative relationship is:

**Data Governance**
→ defines or coordinates the governed requirement.

**Data Engineering**
→ implements the requirement in processing and data products.

Examples include:

**Classification**
→ Governance defines or coordinates classification.
→ Data Engineering implements required handling.

**Quality Rule**
→ Governance and business ownership define the requirement.
→ Data Engineering implements the validation.

**Lineage**
→ Governance defines required traceability.
→ Data Engineering produces and maintains the technical lineage.

Governance and implementation must remain synchronized.

### 16.12 Privacy / Legal

Privacy / Legal is responsible for determining applicable privacy, legal, and regulatory requirements according to the organizational context.

Responsibilities may include:

- interpretation of privacy requirements;
- processing-purpose requirements;
- data-subject-request requirements;
- retention constraints;
- privacy-incident obligations;
- legal holds;
- regulatory interpretation.

The data platform must not independently make legal conclusions merely because it implements technical privacy controls.

### 16.13 Privacy and Data Engineering

Privacy requirements must be translated into implementable data-platform controls.

For example:

**Privacy Requirement**
→ minimize unnecessary personal data.

**Data Engineering Implementation**
→ exclude, remove, mask, pseudonymize, aggregate, or otherwise transform attributes according to the approved requirement.

Similarly:

**Approved Privacy Request**
→ identifies required treatment.

**Data Engineering**
→ executes the approved technical action across affected platform layers where applicable.

Technical implementation supports the privacy process but does not independently determine legal applicability.

### 16.14 Business Data Owner

The Business Data Owner is responsible for the governed business meaning and approved use of a data domain or product.

Responsibilities may include:

- business definitions;
- business rules;
- data meaning;
- analytical purpose;
- acceptable quality expectations;
- ownership decisions;
- consumer requirements;
- approval of material semantic changes.

Business ownership does not automatically imply technical administration of the systems storing or processing the data.

### 16.15 Business Ownership and Technical Ownership

Business ownership and technical ownership must remain distinguishable.

For example:

**Business Data Owner**
→ defines what a Sales measure means.

**Data Engineering**
→ implements the transformation.

**DBA**
→ administers the database platform.

**Platform / SRE**
→ operates the supporting infrastructure.

A technically correct implementation must still represent the approved business meaning.

Likewise, business authority does not automatically grant unrestricted technical privilege.

### 16.16 Business Intelligence / Analytics

Business Intelligence / Analytics is responsible for governed analytical consumption and presentation.

Responsibilities may include:

- semantic models;
- reports;
- dashboards;
- analytical calculations appropriate to the consumption layer;
- visualization;
- consumer-facing analytical documentation.

BI should consume governed analytical products through Certified Gold.

It should not become the uncontrolled location where core data-platform transformations are recreated independently from the governed pipeline.

### 16.17 BI and Business Logic

Some analytical logic legitimately belongs in the BI layer.

Examples may include:

- presentation calculations;
- visual aggregations;
- user-facing measures;
- report-specific logic.

Core business definitions that must remain consistent across multiple consumers should preferably be governed upstream or explicitly defined as part of the analytical consumption contract.

The boundary should minimize duplicated and contradictory business logic.

### 16.18 Data Consumer

A Data Consumer uses governed analytical information for an approved purpose.

Consumers may include:

- analysts;
- business users;
- applications;
- reports;
- dashboards;
- downstream analytical systems.

Consumers are responsible for using data according to:

- defined purpose;
- classification;
- access authorization;
- analytical semantics;
- applicable privacy requirements.

Consumer access does not imply authority to modify upstream processing, certification, or publication.

### 16.19 Data Product Ownership

Each governed data product should have identifiable ownership.

Ownership should make it possible to determine responsibility for:

- purpose;
- business meaning;
- technical implementation;
- quality expectations;
- classification;
- consumers;
- lifecycle;
- certification;
- documentation.

Ownership may involve several roles.

The important requirement is that responsibility must not become ambiguous merely because the product crosses multiple technologies or teams.

### 16.20 Event Contract Responsibility

Event contracts require responsibility for both technical compatibility and semantic meaning.

Relevant responsibilities include:

- producer behavior;
- schema definition;
- compatibility policy;
- semantic review;
- versioning;
- consumer impact;
- migration;
- deprecation.

Data Engineering may implement the contract and registry integration, while source ownership and business ownership may participate in semantic decisions.

No single technical registry replaces contract ownership.

### 16.21 Quality Responsibility

Data quality requires identifiable responsibility for:

- defining the rule;
- implementing the rule;
- responding to failure;
- investigating affected data;
- approving remediation where required.

Different quality rules may have different owners.

For example, Data Engineering may implement a uniqueness check while the Business Data Owner determines whether the violated condition represents an invalid business state.

A failed quality rule must not exist without an identifiable remediation responsibility.

### 16.22 Reconciliation Responsibility

Reconciliation verifies whether processing remains quantitatively and semantically consistent across architectural boundaries.

Responsibility may include:

- defining reconciliation expectations;
- implementing comparisons;
- investigating differences;
- determining whether divergence blocks certification;
- preserving evidence.

Data Engineering may implement the mechanism, while business ownership or governance may define the acceptable interpretation of material differences.

### 16.23 Certification Responsibility

Certification determines whether a Gold candidate satisfies the requirements necessary for governed publication.

Certification responsibility should evaluate the defined criteria, including where applicable:

- processing completion;
- quality;
- reconciliation;
- required metadata;
- lineage;
- version information;
- blocking failures.

Authority to produce data does not automatically imply authority to certify it.

Version 1 may consolidate these responsibilities operationally, but their logical distinction must remain explicit.

### 16.24 Publication Responsibility

Publication controls which certified state becomes consumer-visible.

The responsibility includes:

- publishing approved Certified Gold;
- preserving the previous trusted version where required;
- preventing failed candidates from becoming visible;
- supporting rollback;
- recording publication state.

Publication authority must remain distinct from ordinary analytical-consumption access.

### 16.25 Backup and Recovery Responsibility

Backup and recovery responsibilities must remain identifiable for each relevant platform component.

Responsibilities may include:

- defining backup scope;
- operating backup procedures;
- validating recoverability;
- performing restore;
- coordinating replay or rebuild;
- validating restored security state;
- validating restored data state;
- preserving recovery evidence.

Recovery may involve DBA, Data Engineering, Platform / SRE, Security, Governance, and other roles depending on the failure.

Successful infrastructure restore does not independently prove complete platform recovery.

### 16.26 Incident Responsibility

Incident handling requires coordinated responsibility according to incident type.

Examples include:

**Data-processing incident**
→ Data Engineering.

**Database incident**
→ DBA.

**Infrastructure incident**
→ Platform / SRE.

**Security incident**
→ Security with affected technical owners.

**Privacy-related incident**
→ Privacy / Legal with Security, Governance, and affected technical owners.

**Business-definition incident**
→ Business Data Owner with Governance and technical implementation owners.

Complex incidents may span several responsibilities.

The incident process must still identify decision authority and remediation ownership.

### 16.27 Change Responsibility

A material change may require several forms of authority.

The platform should distinguish, where applicable:

- who proposes the change;
- who implements it;
- who evaluates technical impact;
- who evaluates business impact;
- who evaluates security or privacy impact;
- who approves it;
- who validates it.

The same person may perform several of these responsibilities in the laboratory.

Their logical distinction must nevertheless remain visible.

### 16.28 Documentation Responsibility

Governed documentation requires identifiable ownership.

Relevant documentation includes:

- architecture;
- standards;
- contracts;
- metadata;
- data-product definitions;
- operational procedures;
- tests;
- evidence;
- ADRs.

The owner is responsible for keeping documentation aligned with the validated architecture and implementation.

Documentation must not become ownerless merely because it is stored in source control.

### 16.29 Evidence Responsibility

Evidence requires responsibility for:

- defining what must be proven;
- executing or automating the validation;
- collecting the result;
- sanitizing sensitive content;
- preserving the artifact;
- interpreting PASS or FAIL;
- associating evidence with the relevant architecture or control.

The role implementing a control may also execute its test in Version 1.

Where stronger independence is required, enterprise environments may separate implementation from validation.

### 16.30 Separation of Duties

Separation of duties reduces the risk that one responsibility can create, approve, publish, and conceal an inappropriate change without independent control.

Relevant separations may include:

- implementation versus approval;
- processing versus certification;
- certification versus consumption;
- routine operation versus administration;
- security administration versus ordinary workload access;
- implementation versus independent validation where required.

The degree of physical separation depends on risk, organizational size, and deployment environment.

Logical separation remains required even when physical separation is not practical.

### 16.31 Laboratory Role Consolidation

Version 1 is implemented and operated within a training laboratory.

One operator may therefore perform responsibilities that would normally be distributed among:

- Data Engineering;
- DBA;
- Platform / SRE;
- Security;
- Governance;
- BI;
- testing;
- recovery.

This consolidation is an implementation constraint of the laboratory.

It must not be represented as the intended enterprise operating model.

### 16.32 Logical Separation in the Laboratory

Even when one person performs several roles, the laboratory should preserve logical separation through mechanisms such as:

- distinct service identities;
- distinct permissions;
- separate processing stages;
- explicit certification boundaries;
- documented responsibilities;
- role-specific test scenarios;
- separate administrative and routine access where practical.

The objective is not to simulate multiple people artificially.

The objective is to demonstrate that the architecture does not depend on one unrestricted identity or undefined responsibility.

### 16.33 Enterprise Role Distribution

An enterprise deployment may distribute responsibilities across specialized functions such as:

- Data Engineering;
- DBA;
- Platform Engineering;
- SRE;
- Security Engineering;
- Security Operations;
- Data Governance;
- Privacy;
- Legal;
- Business Data Ownership;
- BI / Analytics;
- Internal Audit.

The exact organizational structure may vary.

Enterprise evolution should map these functions onto the logical responsibilities rather than redefine the architecture around current team names.

### 16.34 Responsibility Matrix

Atlas Engineering should maintain a responsibility matrix for significant capabilities.

A representative matrix may include:

| Capability | Primary Responsibility | Supporting Responsibilities |
|---|---|---|
| Source database operation | DBA / Source Owner | Platform / SRE |
| CDC configuration | DBA | Data Engineering |
| Debezium integration | Data Engineering | DBA, Platform / SRE |
| Kafka platform operation | Platform / SRE | Data Engineering |
| Event contract | Data Engineering | Source Owner, Governance |
| Bronze / Silver processing | Data Engineering | Platform / SRE |
| Gold data product | Data Engineering | Business Data Owner, Governance |
| Data quality | Data Engineering | Governance, Business Data Owner |
| Reconciliation | Data Engineering | Governance, Business Data Owner |
| Certification | Governed Certification Responsibility | Data Engineering, Governance, Business Data Owner |
| Publication | Publication Responsibility | Data Engineering, Platform / SRE |
| Certified Gold consumption | BI / Data Consumer | Data Engineering |
| Identity and access requirements | Security | Technical Owners |
| Technical access implementation | Technical Owner | Security |
| Classification | Data Governance | Security, Privacy / Legal, Business Data Owner |
| Privacy requirement | Privacy / Legal | Governance, Technical Owners |
| Backup and recovery | Technical Owner | DBA, Platform / SRE, Data Engineering |
| Security incident | Security | Affected Technical Owners |
| Documentation | Owning Role | Supporting Roles |
| Evidence | Control / Test Owner | Governance, Security where applicable |

The matrix is an architectural baseline.

It does not require every responsibility to be performed by a different person in Version 1.

### 16.35 Responsibility Gaps

A responsibility gap exists when an important capability has no identifiable owner.

Examples include:

- failed quality rule with no remediation owner;
- certificate expiration with no responsible role;
- contract change with no approval authority;
- backup with no restore owner;
- incident alert with no escalation path;
- data product with no business owner.

Responsibility gaps are governance and operational risks.

They should be resolved explicitly rather than assumed to belong to whoever notices the problem first.

### 16.36 Responsibility Overlap

Some responsibilities legitimately overlap.

Overlap becomes a problem when decision authority becomes unclear.

For significant controls, documentation should distinguish where practical:

- who defines;
- who implements;
- who approves;
- who operates;
- who validates;
- who consumes.

This distinction may later evolve into a formal RACI model if organizational complexity requires it.

### 16.37 Escalation

Operational procedures should identify escalation paths according to the affected responsibility.

Examples include:

**Source database issue**
→ DBA.

**Pipeline transformation issue**
→ Data Engineering.

**Infrastructure issue**
→ Platform / SRE.

**Unauthorized access**
→ Security.

**Personal-data concern**
→ Privacy / Legal and Data Governance.

**Business-definition conflict**
→ Business Data Owner.

Complex incidents may require several roles simultaneously.

Escalation identifies the responsible path; it does not eliminate cross-functional collaboration.

### 16.38 Roles and Least Privilege

Responsibilities must inform authorization.

A role should receive access required to perform its responsibilities rather than permissions associated with organizational seniority or convenience.

For example:

- Business Data Owner does not automatically require database administration;
- Security does not automatically require unrestricted business-data modification;
- Platform / SRE does not automatically require analytical-data consumption;
- BI does not require Bronze access;
- Data Engineering does not automatically require unrestricted security administration.

Responsibility and technical privilege must remain intentionally aligned.

### 16.39 Roles and Evidence

Evidence should make responsibility visible where relevant.

A test result becomes more operationally useful when it can answer:

- which capability was tested;
- which role owns the requirement;
- which role implemented the control;
- which identity executed the test;
- who or what validated the result.

This supports accountability, investigation, and future maintenance.

### 16.40 Role Review

Responsibilities should be reviewed when:

- architecture changes;
- a new platform component is introduced;
- a new data product is created;
- ownership changes;
- security requirements change;
- privacy requirements change;
- operational incidents reveal ambiguity;
- responsibility gaps or problematic overlaps are discovered.

Roles are part of architecture governance and may evolve with the platform.

### 16.41 Roles and Responsibilities Testing

Role boundaries can be validated through both technical and procedural tests.

Representative tests include:

- service identities possess only permissions required by their responsibilities;
- BI cannot modify Certified Gold;
- Data Engineering processing identities cannot perform unrelated administrative actions;
- publication authority remains distinct from ordinary consumer access;
- security-sensitive actions remain attributable;
- ownership metadata exists for governed products and contracts;
- recovery procedures identify responsible roles;
- failed certification has an identifiable remediation owner.

Not every responsibility can be enforced technically.

Where enforcement is procedural, documentation and evidence must make that distinction explicit.

### 16.42 Roles and Responsibilities Evidence

Evidence may identify:

- capability;
- responsible role;
- supporting roles;
- technical identity where applicable;
- expected responsibility;
- implemented control;
- validation result;
- escalation path;
- implementation version;
- conclusion.

Evidence must demonstrate responsibility without implying organizational separation that does not exist in the Version 1 laboratory.

### 16.43 Roles and Responsibilities Guarantees

The Atlas Engineering responsibility model must preserve the following guarantees:

1. roles represent responsibilities rather than necessarily individual people or job titles;
2. one person may perform multiple roles without eliminating their conceptual separation;
3. Data Engineering owns governed data-processing implementation but does not independently define every business, security, privacy, or legal requirement;
4. operational source ownership remains distinct from downstream analytical ownership;
5. CDC represents a shared responsibility boundary between database and Data Engineering concerns;
6. infrastructure administration does not automatically imply unrestricted business-data access;
7. Security defines or coordinates protection requirements while implementation may remain distributed across technical owners;
8. Data Governance coordinates meaning, classification, lifecycle, ownership, and governed usage;
9. Privacy / Legal determines applicable legal and privacy requirements rather than the data platform independently making legal conclusions;
10. Business Data Ownership remains distinct from technical implementation ownership;
11. BI consumes governed analytical products rather than becoming the uncontrolled location of core transformation logic;
12. quality, reconciliation, certification, publication, recovery, and incident response have identifiable responsibility;
13. significant changes distinguish implementation authority from business, security, privacy, or governance authority where applicable;
14. documentation and evidence have identifiable ownership;
15. separation of duties is applied according to risk and organizational capability;
16. Version 1 may consolidate human roles while preserving logical technical and procedural boundaries;
17. responsibility gaps are treated as governance and operational risks;
18. overlapping responsibilities do not eliminate the need for clear decision authority;
19. escalation follows the responsibility affected by the issue;
20. technical privilege is aligned with responsibility rather than convenience or seniority;
21. responsibility boundaries are reviewable as the architecture evolves;
22. implemented role boundaries are testable where technically enforceable;
23. procedural controls remain distinguishable from technical enforcement;
24. responsibility claims reflect the actual laboratory or enterprise organizational context.

---

## 17. Security Validation Strategy

Security validation demonstrates whether implemented controls actually enforce the security and governance requirements defined by Atlas Engineering.

A control is not considered proven merely because:

- a configuration exists;
- an identity or role exists;
- a certificate is installed;
- a password is stored outside source control;
- a network rule appears correct;
- documentation describes the expected behavior.

Validation must demonstrate the behavior of the implemented control under controlled conditions.

The governing lifecycle is:

**Requirement → Implementation → Test → Observability → Evidence → Conclusion**

Validation should include both:

**Authorized Behavior → ALLOWED**

and, where applicable:

**Unauthorized Behavior → DENIED**

A denied operation is a successful security result when denial is the documented expected behavior.

### 17.1 Validation Scope

Security validation may cover capabilities such as:

- identity;
- authentication;
- authorization;
- secrets;
- credential lifecycle;
- network access;
- transport protection;
- data protection;
- classification;
- privacy;
- layer access;
- schema and governance controls;
- retention;
- auditability;
- incident response;
- recovery.

Not every control requires the same validation mechanism.

Some controls are validated technically.

Others may require:

- metadata review;
- configuration review;
- governance-state validation;
- procedural evidence.

The validation method must match the control being claimed.

### 17.2 Positive Security Tests

Positive tests confirm that an authorized identity or process can perform the operation required by its responsibility.

Representative examples include:

- Debezium can access the required SQL Server CDC structures;
- an approved Kafka producer can publish to its authorized topic;
- a Bronze consumer can consume its assigned topic;
- Bronze processing can write to its approved storage scope;
- Silver processing can read Bronze and write Silver;
- Gold processing can read Silver and produce approved Gold state;
- Power BI can read its approved Certified Gold product;
- an administrator can perform an explicitly authorized administrative action.

Positive tests demonstrate that security controls permit legitimate platform operation.

### 17.3 Negative Security Tests

Negative tests confirm that identities cannot perform operations outside their authorized responsibilities.

Representative examples include:

- Power BI cannot query AtlasCommerce operational tables;
- a Bronze processor cannot modify Gold;
- a Kafka consumer cannot administer the cluster;
- a Silver processor cannot write Bronze history;
- an observability identity cannot modify business data;
- a revoked credential cannot authenticate;
- an ordinary user cannot change security configuration.

Negative tests are essential for important access boundaries because successful authorized access alone does not demonstrate least privilege.

### 17.4 Test Identifiers

Security tests should use stable identifiers.

Identifiers allow architecture, implementation, evidence, operational procedures, and future FAQ documentation to refer to the same validated behavior.

Suggested categories include:

- `IAM-*` — identity and access management;
- `AUTH-*` — authentication and authorization;
- `SEC-*` — general security controls;
- `SECRET-*` — secrets and credential management;
- `NET-*` — network and communication controls;
- `TLS-*` — transport encryption and certificate validation;
- `DATA-*` — data-protection controls;
- `CLASS-*` — classification controls;
- `PRIV-*` — privacy controls;
- `ACCESS-*` — layer-access boundaries;
- `GOV-*` — governance controls;
- `RET-*` — retention and disposal;
- `AUD-*` — auditability;
- `INC-*` — incident and security recovery.

The catalog may evolve as implementation grows.

Stable identifiers should not be renumbered casually after documentation or evidence depends on them.

### 17.5 Test Definition

Each security test should define expected behavior before execution.

A test definition should include, where applicable:

- Test ID;
- Purpose;
- Architectural Requirement;
- Initial State;
- Identity or Role;
- Credential Type;
- Source;
- Target Resource;
- Requested Operation;
- Data Classification;
- Expected Result;
- Relevant Observability;
- Cleanup Requirement.

Defining expectations before execution prevents the result from being reinterpreted merely because observed behavior was inconvenient.

### 17.6 PASS and FAIL Criteria

Security tests require explicit PASS and FAIL criteria.

For example:

**AUTH-001 — Power BI Reads Certified Gold**

PASS:
→ the approved Power BI identity authenticates successfully and reads only the authorized Certified Gold representation.

FAIL:
→ required access is unexpectedly denied, authentication fails, or broader unauthorized access is required for the test to succeed.

For a negative test:

**AUTH-002 — Power BI Cannot Read AtlasCommerce**

PASS:
→ access is denied.

FAIL:
→ the query succeeds.

PASS therefore reflects the expected security behavior, not whether the requested technical operation happened to succeed.

### 17.7 Authentication Validation

Authentication tests should verify behavior such as:

- valid credential accepted;
- invalid credential rejected;
- revoked credential rejected;
- expired credential rejected where applicable;
- disabled identity rejected;
- replacement credential accepted after rotation;
- certificate trust validated where applicable.

Evidence must not expose real secret values.

### 17.8 Authorization Validation

Authorization tests should confirm both required and prohibited operations.

Representative examples include:

**AUTH-010**
→ Gold Processor reads approved Silver input  
→ Expected: ALLOWED

**AUTH-011**
→ Gold Processor modifies AtlasCommerce operational data  
→ Expected: DENIED

**AUTH-012**
→ Power BI reads Certified Gold  
→ Expected: ALLOWED

**AUTH-013**
→ Power BI modifies Certified Gold  
→ Expected: DENIED

Authorization validation should be derived from the governed access model defined in Chapter 11.

### 17.9 Service Identity Isolation

Service identities should be tested for isolation.

A service credential should successfully authenticate and authorize only the responsibilities assigned to that service.

For example, a Bronze Processor identity should not automatically gain:

- Gold administration;
- Certified Gold publication;
- SQL Server administration;
- unrelated Kafka topic access.

Isolation testing demonstrates that compromise of one service identity does not automatically provide unrelated privileges.

### 17.10 Administrative Access Validation

Administrative access tests should demonstrate that:

- authorized administrative identities can perform required administrative operations;
- routine workload identities cannot perform those operations;
- elevated activity remains attributable;
- temporary elevated access can be removed;
- administrative actions are auditable where supported.

Testing must not leave unnecessary administrative access enabled after completion.

### 17.11 Credential Rotation Validation

Credential rotation should be validated as an operational sequence.

A representative scenario is:

1. service operates with Credential V1;
2. Credential V2 is created;
3. the legitimate workload receives V2 securely;
4. authentication succeeds using V2;
5. V1 is revoked;
6. authentication using V1 fails;
7. normal processing continues using V2.

A rotation test is incomplete if the superseded credential remains indefinitely valid.

### 17.12 Secret Exposure Validation

Secret-management controls may be validated through controlled scanning and artifact review.

Tests may confirm that:

- working credentials are absent from source-controlled artifacts;
- local secret files are excluded from source control;
- public examples contain placeholders;
- logs do not expose tested secret values;
- evidence contains no reusable credentials;
- revoked exposed credentials fail authentication.

A real credential must not be intentionally exposed publicly in order to test exposure detection.

### 17.13 Network Access Validation

Network tests should validate both required and prohibited communication.

Representative examples include:

- Debezium can reach the required SQL Server endpoint;
- Bronze processing can reach Kafka and MinIO;
- Power BI can reach Certified Gold;
- unnecessary host ports are not externally reachable;
- an unauthorized context cannot use an administrative interface;
- service recovery after temporary network interruption does not require weakening security controls.

Connectivity alone does not prove authorization.

Network validation should be interpreted together with authentication and authorization where applicable.

### 17.14 TLS Validation

Where TLS is implemented, validation must test more than the existence of an encrypted connection.

Relevant tests may include:

- successful connection using trusted certificate material;
- rejection of invalid or untrusted certificates where validation is required;
- hostname or endpoint validation where applicable;
- certificate-expiration visibility;
- correct use of protected endpoints;
- absence of insecure fallback.

A connection that succeeds only after trust verification is disabled must not be represented as successful TLS validation.

### 17.15 Data Protection Validation

Data-protection tests may verify:

- unauthorized access is denied;
- sensitive attributes do not propagate beyond approved layers;
- transport protection is active where implemented;
- at-rest protection is active where implemented;
- temporary artifacts are governed;
- quarantine access is restricted;
- backup access is controlled;
- exports preserve applicable handling requirements.

The test must demonstrate the implemented mechanism rather than merely restate documentation.

### 17.16 Classification Validation

Classification tests should verify that classification changes actual handling.

Representative scenarios include:

**CLASS-001**
→ attribute classified as Confidential  
→ unauthorized analytical consumer denied.

**CLASS-002**
→ Restricted value  
→ absent from ordinary logs.

**CLASS-003**
→ personal attribute unnecessary in Certified Gold  
→ removed before publication.

A classification label without behavioral consequence does not demonstrate effective classification governance.

### 17.17 Privacy Validation

Privacy tests should use controlled or synthetic identities and data whenever practical.

Representative tests may include:

- personal attribute correctly identified;
- unnecessary personal attribute removed downstream;
- unauthorized consumer denied access;
- Certified Gold exposes only approved fields;
- personal data absent from public evidence;
- correction propagates according to implemented design;
- approved deletion or de-identification behaves as defined;
- replay does not recreate a privacy-invalid state where the implemented governance model prevents it.

Privacy validation demonstrates technical behavior.

It does not independently establish legal compliance.

### 17.18 Layer Access Validation

Layer-access tests must be derived from the governed access matrix.

For each important identity:

**Required Access**
→ validate ALLOWED.

**Unrequired Access**
→ validate DENIED.

Representative identities include:

- Debezium;
- Bronze Processor;
- Silver Processor;
- Gold Processor;
- Certification / Publication;
- Power BI;
- observability services;
- administrators.

Layer-access validation provides direct evidence of least privilege.

### 17.19 Governance Validation

Governance tests may include:

- compatible event-contract evolution accepted;
- incompatible contract change rejected;
- supported historical contract version remains interpretable;
- Gold output matches documented grain;
- quality implementation matches the governed rule;
- reconciliation implementation matches its approved definition;
- Certified Gold matches its consumption contract;
- metadata owner is present;
- classification metadata matches implemented handling;
- deprecated assets remain identifiable.

Governance validation tests alignment between governed intent and implemented behavior.

### 17.20 Retention Validation

Retention tests should confirm actual lifecycle behavior.

Representative tests include:

- Kafka data expires according to configured policy;
- required Kafka recovery remains possible within the retention window;
- temporary artifacts are cleaned up;
- quarantine reaches an explicit lifecycle state;
- previous certified versions follow configured retention;
- restored backup receives current governance treatment;
- intentionally disposed data does not reappear through normal replay where the implementation prevents it.

Retention validation must reflect actual technology behavior.

### 17.21 Auditability Validation

Audit tests should confirm that security-relevant activity generates sufficient context.

Representative tests include:

- authentication success recorded;
- authentication failure recorded;
- authorization denial recorded;
- privilege change attributable;
- administrative action attributable;
- credential rotation traceable;
- revoked credential failure observable;
- sensitive values absent from audit logs;
- security event correlatable with the test execution.

Absence of required audit information is itself a validation failure.

### 17.22 Incident Validation

Controlled security-incident tests may include:

- service credential compromise simulation;
- unauthorized layer-access attempt;
- excessive-permission detection;
- credential revocation;
- trusted-state recovery;
- restoration of normal access boundaries;
- evidence preservation.

Incident tests must remain controlled and must not expose real sensitive information or reusable public credentials.

### 17.23 Recovery Security Validation

Recovery testing must verify that security controls survive or are correctly restored after recovery.

Relevant questions include:

- Are identities still correctly scoped?
- Are revoked credentials still revoked?
- Are replacement credentials valid?
- Did restored configuration reintroduce excessive access?
- Is transport protection still active?
- Is auditability functioning?
- Is Certified Gold still governed?
- Was temporary elevated access removed?

Data recovery with degraded security is not a complete PASS.

### 17.24 Security Regression Testing

Security behavior should be revalidated after changes capable of affecting security boundaries.

Relevant changes include:

- identity changes;
- permission changes;
- source-schema changes affecting sensitive data;
- new services;
- new network paths;
- certificate changes;
- secret-management changes;
- new analytical consumers;
- classification changes;
- retention changes;
- recovery mechanisms.

Previously passing tests may become regression tests for later platform versions.

A historical PASS does not prove that a modified implementation still behaves identically.

### 17.25 Test Isolation

Security tests must minimize unintended impact on unrelated platform behavior.

Where practical, tests should use:

- dedicated test identities;
- controlled datasets;
- synthetic personal data;
- temporary roles;
- isolated test resources;
- reversible changes.

A test must not create long-lived excessive access or unmanaged security state.

### 17.26 Test Cleanup

Security-test design must include cleanup.

Cleanup may include:

- removing temporary roles;
- revoking temporary credentials;
- deleting test identities;
- removing temporary network rules;
- restoring intended permissions;
- cleaning temporary data;
- removing unnecessary test artifacts.

Cleanup itself may require validation.

A test that passes but leaves the environment less secure is incomplete.

### 17.27 Repeatability

Security tests should be repeatable where practical.

Repeatability demonstrates that security behavior is part of the implemented architecture rather than an isolated manual result.

Equivalent conditions should produce the same expected security outcome.

Where a test cannot safely be automated, its manual procedure should remain documented.

### 17.28 Automation

Suitable security tests may be integrated into automated validation where practical.

Examples include:

- repository secret scanning;
- contract compatibility checks;
- access-policy validation;
- negative authorization tests;
- certificate-expiration checks;
- metadata validation;
- configuration-policy checks.

Automation improves consistency but does not replace interpretation or governance review.

### 17.29 Security Test Environment

Security tests must identify the environment in which they were executed.

Version 1 is a laboratory rather than an enterprise production environment.

Evidence should describe, where applicable:

- topology;
- relevant component versions;
- implemented controls;
- test data;
- environment limitations.

A successful laboratory test demonstrates behavior only within those documented conditions.

### 17.30 Security Evidence Structure

A security evidence record should include, where applicable:

- Test ID;
- Test Name;
- Purpose;
- Architectural Requirement;
- Environment;
- Implementation Version;
- Date and Time;
- Initial State;
- Identity / Role;
- Target Resource;
- Requested Operation;
- Data Classification;
- Expected Result;
- Observed Result;
- Relevant Logs;
- Relevant Metrics;
- Audit Event;
- Cleanup;
- Final State;
- PASS / FAIL;
- Interpretation.

Evidence should remain concise enough for practical review while preserving enough context for independent interpretation.

### 17.31 Evidence Sanitization

Security evidence must be reviewed before publication.

Sanitization may require removing or redacting:

- passwords;
- tokens;
- private keys;
- credential-bearing connection strings;
- real personal data;
- Restricted configuration;
- unnecessary internal security details.

Sanitization must not change the meaning of the result.

Where information is redacted, the evidence should make that redaction explicit.

### 17.32 Negative Evidence

Failed security tests must be preserved where appropriate.

For example:

**AUTH-013**

Expected:
→ Power BI cannot modify Certified Gold.

Observed:
→ UPDATE succeeded.

Result:
→ FAIL.

The governed expectation must not be rewritten merely to make the unexpected behavior appear acceptable.

The correct sequence is:

**Unexpected Result → Investigate → Root Cause → Decision → Remediation → Revalidation**

Failed evidence can provide valuable proof of how a control or architectural assumption was improved.

### 17.33 Evidence and Architecture Decisions

Validation may reveal that an architectural assumption is wrong, incomplete, or impractical.

Examples include:

- an authorization mechanism cannot enforce the intended scope;
- TLS behaves differently from the assumed trust model;
- a service requires broader access than expected;
- a retention rule prevents required recovery;
- a privacy transformation breaks an approved analytical requirement.

The appropriate response may be to:

- modify implementation;
- revise the architecture;
- select another mechanism;
- document a limitation;
- create an ADR.

Evidence must be allowed to change architecture.

It must not be forced to support a predetermined conclusion.

### 17.34 Security Baseline

After Version 1 controls are implemented and tested, the project should establish a measured security baseline.

The baseline should identify which controls are:

- implemented;
- tested;
- passing;
- partially implemented;
- planned for enterprise evolution;
- not applicable.

The baseline must not use vague labels such as:

**Secure**

without identifying the controls and evidence supporting the claim.

### 17.35 Security Claim Levels

Security claims should distinguish between:

**Documented**
→ the architecture defines the requirement.

**Implemented**
→ the control exists.

**Tested**
→ controlled validation was executed.

**Observed**
→ behavior was visible through logs, metrics, audit, or equivalent mechanisms.

**Evidence-Backed**
→ the result is preserved with enough context for later review.

These levels prevent configuration presence from being confused with demonstrated security behavior.

### 17.36 Laboratory Claims

Version 1 may demonstrate capabilities such as:

- least-privilege behavior under tested scenarios;
- authentication and authorization enforcement;
- service-identity isolation;
- credential rotation and revocation;
- network-boundary behavior;
- selected TLS behavior;
- data-minimization behavior;
- access isolation;
- auditability;
- controlled security recovery.

It does not automatically demonstrate:

- enterprise-wide Zero Trust;
- enterprise IAM maturity;
- regulatory compliance;
- enterprise SOC capability;
- large-scale security operations;
- production-grade high availability;
- resistance against every threat model.

Claims must remain proportional to the evidence produced.

### 17.37 Security Validation Review

Security-validation results should be reviewed when:

- controls change;
- new platform components are introduced;
- new analytical products are created;
- new sensitive data appears;
- architecture changes;
- security incidents occur;
- previous tests fail;
- enterprise evolution changes the enforcement mechanism.

A passing historical test does not prove that a later implementation still behaves identically.

Previously validated controls must therefore be reconsidered when their implementation context changes.

### 17.38 Security Validation Guarantees

The Atlas Engineering security-validation model must preserve the following guarantees:

1. documented controls are not treated as proven without implementation and validation;
2. validation includes positive and negative security behavior where applicable;
3. stable test identifiers connect requirements, tests, and evidence;
4. expected behavior is defined before execution;
5. PASS and FAIL criteria reflect security intent rather than simple technical success;
6. validation method matches the control being claimed;
7. authentication, authorization, service isolation, credential lifecycle, network access, TLS, data protection, classification, privacy, governance, retention, auditability, incident, and recovery controls are testable where implemented;
8. access validation is derived from the approved access model;
9. revoked credentials are tested for rejection where applicable;
10. TLS is not considered validated when trust verification is intentionally bypassed;
11. classification and privacy tests demonstrate actual handling behavior;
12. recovery validation includes restoration of security boundaries;
13. tests avoid unnecessary exposure of real secrets or personal data;
14. test isolation and cleanup prevent validation from leaving the platform in a weaker state;
15. repeatable tests are preferred where practical;
16. automation may strengthen validation without replacing interpretation;
17. evidence identifies the environment and implementation under test;
18. evidence is sanitized without changing the meaning of the result;
19. failed tests remain valid evidence and drive investigation and remediation;
20. evidence may cause implementation or architecture to change;
21. security baselines describe specific validated controls rather than unsupported general claims;
22. security claim levels distinguish documented, implemented, tested, observed, and evidence-backed states;
23. laboratory claims remain bounded by the scenarios and topology actually tested;
24. security validation is reviewed when implementation context changes;
25. security-validation claims remain limited to controls and behavior actually implemented and evidenced.

---

## 18. Laboratory and Enterprise Security Boundaries

Atlas Engineering Version 1 is implemented as a controlled training and validation laboratory.

Its purpose is to demonstrate architectural behavior, security boundaries, governance controls, failure handling, observability, and evidence under a documented local topology.

The physical implementation of Version 1 must not be represented as equivalent to an enterprise security environment.

The architecture therefore distinguishes between:

**Logical Security Architecture**
→ the responsibilities, trust boundaries, access rules, and security properties that should remain valid regardless of deployment scale.

and:

**Physical Security Implementation**
→ the mechanisms available in the specific laboratory or enterprise environment.

The governing principle is:

**Preserve the Security Property — Allow the Implementation Mechanism to Evolve**

### 18.1 Laboratory Purpose

The Version 1 laboratory exists to validate representative security and governance behavior.

It is intended to demonstrate capabilities such as:

- identity separation;
- authentication;
- authorization;
- least privilege;
- service-specific credentials;
- network-boundary behavior;
- controlled exposure;
- selected encryption controls;
- data minimization;
- sensitive-data handling;
- classification;
- privacy-aware processing;
- layer-based access;
- auditability;
- credential rotation and revocation;
- controlled security recovery;
- evidence-backed validation.

The laboratory is not intended to reproduce every enterprise security platform, topology, or organizational process.

### 18.2 Laboratory Physical Constraints

Version 1 may operate with characteristics such as:

- a single physical workstation;
- locally hosted SQL Server;
- containerized Kafka, MinIO, Airflow, Prometheus, Grafana, and related services;
- limited physical network segmentation;
- locally managed credentials;
- fewer human operators;
- no enterprise identity provider;
- no centralized enterprise secrets platform;
- no enterprise SIEM;
- no hardware security module;
- limited infrastructure redundancy.

These constraints affect the physical strength, scale, or operational maturity of some controls.

They do not eliminate the logical security boundaries defined by the architecture.

### 18.3 Logical Boundary Preservation

Even when several services run on the same physical machine, the laboratory should preserve logical separation where practical.

Examples include:

- separate service identities;
- separate credentials;
- scoped permissions;
- explicit authentication;
- layer-specific access;
- controlled network exposure;
- distinction between administrative and routine access;
- controlled publication authority;
- restricted analytical consumption.

Physical co-location must not justify one unrestricted identity, credential, permission set, or communication path across the platform.

### 18.4 Single-Operator Environment

A single person may perform several responsibilities in Version 1.

This may include acting as:

- Data Engineer;
- DBA;
- Platform / SRE;
- Security;
- Data Governance;
- Business Data Owner;
- BI Developer.

This concentration is acceptable for a training laboratory.

The architecture must still preserve the logical distinction between those responsibilities.

For example, the same operator may configure both a Bronze service identity and a Power BI consumer identity while those technical identities receive different permissions.

### 18.5 Laboratory Identity Limitations

The laboratory may use local authentication mechanisms rather than centralized enterprise identity.

Capabilities such as:

- corporate single sign-on;
- centralized identity lifecycle;
- enterprise multi-factor authentication;
- managed workload identity;
- automated joiner-mover-leaver processes;

may therefore be unavailable in Version 1.

Their absence must not be interpreted as an architectural decision that such capabilities are unnecessary.

The laboratory validates identity and authorization boundaries using the mechanisms available locally.

### 18.6 Laboratory Secrets Limitations

Version 1 may use locally protected secret injection rather than centralized enterprise secrets management.

Representative mechanisms may include:

- protected local files;
- environment variables;
- service-specific credentials;
- source-control exclusions.

These mechanisms may support controlled laboratory validation.

They are not represented as equivalent to enterprise capabilities such as:

- centralized vaulting;
- short-lived credentials;
- automated rotation;
- managed identity;
- centralized secret-access auditing.

### 18.7 Laboratory Network Limitations

A single workstation cannot reproduce every physical network-isolation characteristic of a distributed enterprise environment.

Version 1 may rely on mechanisms such as:

- container networks;
- host firewall rules;
- interface binding;
- localhost restrictions;
- controlled port publication.

The laboratory should still demonstrate, where practical:

- unnecessary ports are not exposed;
- services communicate only through required paths;
- administrative interfaces remain controlled;
- analytical consumers do not require internal processing connectivity.

Enterprise deployment may replace these mechanisms with stronger network segmentation.

### 18.8 Laboratory Encryption Scope

Not every enterprise-grade encryption mechanism needs to be implemented in Version 1.

Encryption controls should be selected according to:

- training value;
- technical feasibility;
- data classification;
- trust boundaries;
- component capabilities.

Where TLS or encryption at rest is implemented, it should be validated.

Where it is not implemented, the limitation must remain explicit rather than implying protection that does not exist.

### 18.9 Laboratory Data

Version 1 should use synthetic and controlled project data.

Real customer production data is not required to validate capabilities such as:

- classification;
- minimization;
- access restrictions;
- pseudonymization;
- privacy-aware processing;
- retention behavior;
- auditability.

Synthetic data allows representative validation without introducing unnecessary real privacy exposure.

### 18.10 Laboratory Privacy Claims

The laboratory may demonstrate technical behavior that supports privacy governance.

Examples include:

- personal-data identification;
- attribute classification;
- propagation control;
- removal of unnecessary attributes;
- controlled access;
- privacy-aware lineage;
- representative correction or deletion behavior.

Such validation does not independently establish legal LGPD compliance.

Legal compliance depends on organizational, legal, contractual, operational, and processing-specific conditions beyond the laboratory.

### 18.11 Laboratory Auditability

Version 1 should preserve enough auditability to support representative security testing and investigation.

This may rely on:

- component logs;
- SQL Server audit or security events where implemented;
- Kafka-related security information;
- MinIO logs;
- Airflow logs;
- structured application logs;
- Prometheus metrics;
- Grafana dashboards;
- controlled evidence records.

The laboratory is not required to reproduce a complete enterprise SIEM architecture.

### 18.12 Laboratory Incident Response

Version 1 should validate selected incident behaviors through controlled scenarios.

Examples include:

- exposed test credential;
- revoked credential;
- unauthorized access attempt;
- excessive permission;
- service isolation;
- trusted-state recovery;
- restoration of intended access.

These scenarios demonstrate technical security behavior.

They do not represent a complete enterprise Security Operations Center or formal incident-response organization.

### 18.13 Laboratory Availability and Redundancy

Version 1 may not include enterprise-grade redundancy.

Components may run as single instances, and the local workstation may remain a shared physical failure domain.

Security validation must therefore distinguish between:

**Security Control Behavior**

and:

**Enterprise Availability or High-Availability Capability**

Successful security validation does not imply fault tolerance beyond the tested topology.

### 18.14 Laboratory Scale

Security behavior validated at laboratory scale does not automatically demonstrate the same operational characteristics at enterprise scale.

Examples include:

- access-policy administration;
- audit volume;
- audit retention;
- credential rotation across large service populations;
- certificate management;
- high-volume event correlation;
- automated access certification.

The laboratory validates representative architectural behavior rather than enterprise-scale operational capacity.

### 18.15 Enterprise Identity Evolution

Enterprise deployment may strengthen identity management through capabilities such as:

- centralized identity providers;
- directory integration;
- single sign-on;
- multi-factor authentication;
- managed identities;
- workload identities;
- automated lifecycle management;
- privileged-access management;
- temporary privileged access.

These mechanisms strengthen enforcement of identity boundaries already defined by the architecture.

### 18.16 Enterprise Secrets Evolution

Enterprise secrets management may introduce:

- centralized vaults;
- managed cloud secret stores;
- automated rotation;
- short-lived credentials;
- hardware-backed protection;
- secret-access auditing;
- certificate automation;
- dynamic credentials.

These mechanisms reduce operational risk while preserving service-specific identity and least-privilege principles.

### 18.17 Enterprise Network Evolution

Enterprise networking may strengthen communication boundaries through capabilities such as:

- private subnets;
- security groups;
- firewalls;
- network access-control lists;
- private endpoints;
- controlled ingress and egress;
- service meshes;
- network-flow monitoring;
- zero-trust network access;
- intrusion-detection capabilities.

These controls strengthen enforcement of trust boundaries validated logically in the laboratory.

### 18.18 Enterprise Encryption Evolution

Enterprise environments may strengthen encryption through:

- managed TLS certificates;
- private certificate authorities;
- centralized certificate lifecycle;
- managed encryption at rest;
- key-management services;
- hardware security modules;
- customer-managed keys where required;
- automated key rotation.

The architectural principle remains:

**Protect Data + Protect Keys + Control Access + Preserve Recoverability**

### 18.19 Enterprise Observability and Security Operations

Enterprise security observability may add capabilities such as:

- centralized log aggregation;
- SIEM;
- SOAR;
- threat detection;
- identity analytics;
- privileged-access monitoring;
- network-security analytics;
- centralized certificate monitoring;
- security-incident workflows;
- automated response.

These capabilities extend the observability foundation rather than replace the platform's structured security-event requirements.

### 18.20 Enterprise Data Governance Evolution

Enterprise governance may introduce capabilities such as:

- centralized data catalogs;
- automated classification;
- policy-based access;
- data-stewardship workflows;
- privacy platforms;
- automated lineage;
- records management;
- legal hold;
- automated retention;
- enterprise data-loss prevention.

These mechanisms operationalize the same governance principles at greater organizational scale.

### 18.21 Enterprise Separation of Duties

A larger organization may physically separate responsibilities that Version 1 consolidates under one operator.

For example:

**Data Engineering**
→ governed processing.

**DBA**
→ database administration.

**Platform / SRE**
→ runtime and infrastructure.

**Security**
→ security architecture and assurance.

**IAM**
→ identity governance.

**Data Governance**
→ metadata and lifecycle governance.

**Privacy / Legal**
→ privacy and legal requirements.

**BI**
→ analytical consumption.

Organizational separation may strengthen accountability without changing the logical responsibilities defined by the architecture.

### 18.22 Enterprise Environment Separation

Enterprise deployments should normally distinguish environments such as:

- development;
- test;
- staging;
- production.

Each environment may require separate:

- credentials;
- identities;
- access policies;
- secrets;
- data;
- network boundaries;
- certificates;
- audit controls.

Production credentials should not be reused casually in lower environments.

Likewise, real production data should not be copied into non-production environments without approved purpose and protection.

### 18.23 Enterprise Policy Enforcement

At larger scale, manually maintained security controls become increasingly difficult to enforce consistently.

Enterprise evolution may therefore introduce:

- policy-as-code;
- infrastructure-as-code validation;
- access-policy testing;
- compliance-supporting configuration checks;
- automated secret scanning;
- security gates in CI/CD;
- certificate checks;
- configuration-drift detection.

Automation strengthens consistency.

It does not eliminate architectural ownership, governance, or human review.

### 18.24 Enterprise High Availability

Enterprise deployment may require high availability for security dependencies such as:

- identity providers;
- secrets management;
- certificate services;
- audit pipelines;
- security monitoring;
- key management.

A highly available data pipeline may still become unusable if a required security dependency is unavailable.

Security dependencies therefore participate in enterprise reliability design.

### 18.25 Enterprise Disaster Recovery

Disaster recovery must restore both data services and required security dependencies.

An enterprise recovery plan may need to restore:

- identity configuration;
- authorization policies;
- secret references;
- certificates;
- encryption keys;
- audit capability;
- security monitoring;
- network policies.

Recovery that restores data while losing the ability to authenticate, decrypt, authorize, or audit remains incomplete.

### 18.26 Enterprise Security Governance

Enterprise security controls require lifecycle governance.

Relevant processes may include:

- periodic access review;
- credential-rotation policy;
- certificate lifecycle;
- vulnerability management;
- security-configuration review;
- penetration testing;
- incident response;
- security-risk assessment;
- exception management.

Version 1 does not need to reproduce every organizational process.

Its architecture should remain compatible with such controls where enterprise evolution requires them.

### 18.27 Security Control Substitution

Enterprise evolution may replace the physical mechanism used by a control without changing the architectural requirement.

For example:

**Version 1**
→ locally protected secret injection.

**Enterprise**
→ managed secrets vault.

Or:

**Version 1**
→ container-network isolation.

**Enterprise**
→ private subnets and firewall policies.

The requirements remain:

**Secret Isolation**

and:

**Controlled Communication Boundary**

even though the implementation mechanisms change.

### 18.28 Security Control Strengthening

Enterprise evolution should strengthen enforcement rather than weaken logical boundaries.

For example:

**Local Service Credentials**
→ **Managed Workload Identities**

should preserve or improve:

- identity separation;
- least privilege;
- auditability;
- revocation;
- blast-radius reduction.

Technology replacement must be evaluated against the security property it is intended to preserve.

### 18.29 Portability of Security Architecture

Logical security requirements should not depend on one specific local implementation.

For example, the architecture should not define:

**Environment Variable = Security Architecture**

Instead, it defines the requirement:

**A secret must remain outside source control and be accessible only to authorized workloads.**

Environment variables may satisfy that requirement in one Version 1 scenario.

Enterprise secrets management may satisfy it through another mechanism.

This distinction preserves architectural portability.

### 18.30 Laboratory Evidence Boundaries

Evidence produced by Version 1 must identify the conditions under which validation occurred.

Relevant context may include:

- topology;
- component versions;
- identity mechanism;
- access mechanism;
- encryption state;
- network assumptions;
- dataset type;
- test scenario;
- known limitations.

A laboratory PASS demonstrates the documented behavior under those conditions.

It must not automatically be generalized beyond them.

### 18.31 Laboratory Versus Enterprise Claims

Version 1 claims must remain proportional to evidence.

Appropriate claims may include:

**Validated**
→ Power BI cannot directly access AtlasCommerce under the tested configuration.

**Validated**
→ a revoked test service credential is rejected.

**Validated**
→ the Bronze service identity cannot modify Certified Gold under the tested access model.

Unsupported generalizations include claims such as:

**Atlas Engineering is enterprise-secure.**

**Atlas Engineering is LGPD compliant.**

**Atlas Engineering implements enterprise Zero Trust.**

**Atlas Engineering is secure against all attack scenarios.**

The architecture must distinguish validated behavior from unsupported broad claims.

### 18.32 Documenting Enterprise Gaps

Where Version 1 does not implement an enterprise control, documentation should identify:

- the missing capability;
- why it is not required or practical in the laboratory;
- the architectural requirement it would strengthen;
- the expected enterprise evolution where known.

A gap is not automatically a defect.

An undocumented gap is more dangerous because it may be mistaken for implemented capability.

### 18.33 Avoiding Security Theater

Security controls must not be added solely to make the architecture appear more sophisticated.

Examples of security theater include:

- enabling encryption without validating certificate trust;
- creating many roles while every service still uses an administrator credential;
- classifying data as Restricted without changing its handling;
- installing security tools whose output is never reviewed;
- claiming anonymization after only removing direct names;
- creating dashboards without actionable security signals.

A smaller set of correctly implemented, tested, observed, and evidenced controls is preferable to a larger set of unvalidated claims.

### 18.34 Evidence-Driven Enterprise Evolution

Enterprise evolution should be informed by laboratory evidence.

For example:

**Observed**
→ local credential rotation causes unacceptable service interruption.

Possible enterprise evolution:

→ managed rotation or workload identity.

Another example:

**Observed**
→ local audit records are difficult to correlate across services.

Possible enterprise evolution:

→ centralized log aggregation or SIEM.

Evidence therefore helps justify future technology and architecture decisions instead of treating enterprise complexity as a goal by itself.

### 18.35 Enterprise Evolution and ADRs

Major changes from laboratory mechanisms to enterprise mechanisms should be documented through ADRs when they materially affect architecture.

Examples include:

- centralized identity-provider selection;
- enterprise secrets management;
- enterprise Kafka security model;
- key-management architecture;
- centralized security observability;
- data-catalog platform;
- privacy-management platform.

The ADR should preserve:

- context;
- alternatives;
- decision;
- trade-offs;
- migration considerations.

### 18.36 Laboratory and Enterprise Validation

Atlas Engineering must distinguish:

**Laboratory Validation**
→ behavior demonstrated under Version 1 conditions.

from:

**Enterprise Validation**
→ behavior demonstrated after deployment under enterprise implementation conditions.

Laboratory evidence may inform enterprise expectations.

It does not eliminate the need to validate the control again when its implementation mechanism, topology, scale, or operating context changes.

### 18.37 Laboratory and Enterprise Security Guarantees

The Atlas Engineering laboratory and enterprise security model must preserve the following guarantees:

1. Version 1 is a controlled training and validation laboratory rather than an enterprise production environment;
2. laboratory physical constraints do not redefine logical security boundaries;
3. physical co-location does not justify unrestricted identities, credentials, permissions, or connectivity;
4. single-operator execution does not eliminate logical role separation;
5. laboratory identity mechanisms remain distinguishable from enterprise identity capabilities;
6. laboratory secret handling is not represented as equivalent to centralized enterprise secrets management;
7. laboratory networking preserves logical communication boundaries even when full physical segmentation is unavailable;
8. encryption is claimed only where the implemented mechanism has been validated;
9. synthetic data is preferred over real production customer data for laboratory privacy validation;
10. privacy-supporting technical behavior is not represented as legal compliance;
11. laboratory auditability remains distinguishable from enterprise SIEM and Security Operations capability;
12. controlled incident tests do not represent full enterprise incident-response maturity;
13. laboratory security validation does not imply enterprise availability, redundancy, or scale;
14. enterprise mechanisms may strengthen identity, secrets, networking, encryption, observability, governance, and separation of duties;
15. enterprise environments may require stronger separation of environments and security dependencies;
16. control mechanisms may change while the underlying logical security requirement remains stable;
17. enterprise evolution should strengthen rather than bypass existing security boundaries;
18. the security architecture remains portable across implementation mechanisms;
19. laboratory evidence identifies the conditions under which behavior was demonstrated;
20. security and governance claims remain proportional to evidence;
21. unimplemented enterprise controls are documented as explicit gaps or evolution points rather than silently assumed;
22. security theater is avoided in favor of meaningful implemented and validated controls;
23. laboratory evidence informs but does not replace enterprise-specific validation;
24. significant enterprise security evolution is documented through architectural decisions where appropriate.

---

## 19. Security and Governance Guarantees

Atlas Engineering defines security and governance as architectural properties that must remain valid across source systems, ingestion, event transport, storage, transformation, certification, analytical consumption, operations, recovery, and future platform evolution.

The detailed guarantees defined throughout this document remain authoritative within their respective domains.

This chapter consolidates the principal platform-level guarantees without replacing those detailed requirements.

### 19.1 Identity and Access

Human, service, and administrative identities must remain distinguishable where technically supported.

Access follows explicit responsibility, purpose, authorization, and least privilege.

Successful authentication does not imply unrestricted access.

### 19.2 Deny by Default

Access is denied unless explicitly granted for a defined responsibility.

Technical connectivity, credential possession, or platform reachability does not independently establish authorization.

Required access must succeed and prohibited access must be denied where enforcement is supported.

### 19.3 Service Isolation

Independent platform responsibilities must not rely on one unrestricted shared technical identity.

Service identities, credentials, permissions, and communication paths should remain isolated according to responsibility where practical.

Compromise of one service must not automatically grant unrelated platform privileges.

### 19.4 Secret Protection

Real secrets must remain outside ordinary source-controlled configuration, documentation, logs, and public evidence.

Exposure invalidates confidence in the affected credential until appropriate revocation, replacement, or remediation occurs.

Historical availability of a credential does not restore its trust.

### 19.5 Explicit Trust Boundaries

Communication between services, layers, environments, and consumers crosses explicit trust boundaries.

Internal placement, physical co-location, or local deployment does not automatically establish trust.

Each relationship must be evaluated according to its authentication, authorization, exposure, and protection requirements.

### 19.6 Controlled Network Exposure

Platform services expose only the connectivity required for their responsibilities.

Core processing, storage, and administrative services must not receive unnecessary external exposure.

Administrative communication remains distinct from routine processing and analytical consumption.

### 19.7 Data Protection Throughout the Lifecycle

Data protection applies from the operational source through ingestion, processing, storage, publication, backup, archival, recovery, and disposal.

Encryption complements but does not replace:

- authorization;
- least privilege;
- minimization;
- privacy;
- retention governance;
- secure disposal.

### 19.8 Data Minimization

Source availability does not justify downstream propagation.

Data should be processed, retained, and exposed only when required for a defined purpose.

Where sensitive information is unnecessary, avoiding propagation is preferred to protecting an unnecessary copy.

### 19.9 Data Classification

The initial classification model remains:

1. Public
2. Internal
3. Confidential
4. Restricted

Classification must influence actual handling.

Unclassified information must not automatically be treated as Public.

### 19.10 Personal Data and Privacy

Personal-data status remains distinct from general security classification.

Privacy requirements apply across intermediate, historical, and consumer-facing layers.

Technical privacy controls support applicable requirements but do not independently establish legal LGPD compliance.

### 19.11 Privacy by Design

Privacy must be evaluated when new events, datasets, processing flows, and analytical products are designed.

Where an approved purpose can be satisfied with less identifying information, the less identifying representation should be preferred.

### 19.12 Layer-Based Access

Source, CDC, Kafka, Bronze, Silver, Gold, Certified Gold, observability, quarantine, backups, and administrative resources remain distinct access boundaries.

Consumers should use the lowest-risk governed representation that satisfies their purpose.

Ordinary analytical consumption occurs through Certified Gold rather than unnecessary upstream access.

### 19.13 Candidate and Certified Data Separation

Gold candidate state remains distinct from Certified Gold.

Processing completion does not imply certification.

Certification, publication, and analytical consumption remain separate responsibilities and access boundaries.

### 19.14 Governance of Definitions

Schemas, contracts, processing definitions, quality and reconciliation rules, classifications, metadata, retention policies, and consumption contracts are governed assets.

Material changes must remain identifiable, owned, reviewable, and traceable.

### 19.15 Contract Governance

Event contracts remain distinct from physical source schemas.

Structural compatibility does not independently establish semantic compatibility.

Breaking changes require explicit migration rather than silent contract redefinition.

### 19.16 Version Separation

Independent version dimensions must remain distinguishable where required for reproducibility and lineage.

These may include:

- source schema;
- event contract;
- Silver processing;
- Gold processing;
- quality rules;
- certified product.

One generic version must not obscure independently evolving definitions.

### 19.17 Metadata and Lineage

Metadata and lineage are governed platform assets.

The platform must remain capable of explaining:

**Origin → Movement → Transformation → Version → Certification → Consumption**

Interpretation metadata must remain available while the governed data still depends on it.

### 19.18 Quality and Certification Governance

Processing success does not imply data correctness or certification.

Quality validation, reconciliation, certification, publication, and consumer availability remain distinct states.

Candidates that fail blocking controls must not replace the last known-good governed publication.

### 19.19 Retention Governance

Retention is governed by purpose and applicable requirements rather than technology defaults or available capacity.

Different layers may legitimately retain information for different periods.

Indefinite preservation is not the default.

### 19.20 Archival Governance

Archived data remains governed data.

Classification, privacy, access, encryption, lineage, retention, and disposal responsibilities continue to apply after archival.

An archive is a valid recovery source only when it remains interpretable, protected, and restorable.

### 19.21 Disposal Governance

Disposal must consider all relevant governed copies, including active storage, historical layers, backups, archives, exports, and recovery sources.

Logical deletion and physical disposal remain distinct.

Later governance decisions must not be silently reversed through recovery or replay.

### 19.22 Auditability

Security-relevant activity must remain attributable where technically supported.

Auditability must provide enough context for accountability without unnecessarily exposing secrets or personal information.

### 19.23 Security Observability

Security behavior must remain observable through appropriate logs, metrics, audit events, dashboards, alerts, or equivalent mechanisms where implemented.

Observability must support detection and investigation without becoming an uncontrolled sensitive-data repository.

### 19.24 Security Incident Handling

Security incidents require controlled:

**Detection → Containment → Investigation → Remediation → Recovery → Validation**

Active compromise may require containment before complete investigation is available.

Recovery must restore trust, not merely service availability.

### 19.25 Last Known-Trusted State

Security recovery distinguishes:

**Last Successful State**

from:

**Last Known-Trusted State**

A technically successful state produced under compromised or invalidated trust must not automatically become the recovery baseline.

### 19.26 Recovery Does Not Restore Invalidated Trust

The governing rule is:

**Recovery May Restore Technical State — It Must Not Restore Invalidated Trust**

Revoked credentials, compromised keys, invalid permissions, privacy-invalid states, and retired security configuration do not become trusted again merely because they exist in a historical recovery source.

### 19.27 Recovery Preserves Governance

Replay, restore, rebuild, rollback, and disaster recovery remain subject to current:

- authentication;
- authorization;
- quality;
- reconciliation;
- certification;
- privacy;
- retention;
- auditability.

Temporary recovery privilege must not become permanent routine access.

### 19.28 Roles and Responsibilities

Security and governance responsibilities remain logically distinguishable across:

- Data Engineering;
- DBA;
- Platform / SRE;
- Security;
- Data Governance;
- Privacy / Legal;
- Business Data Ownership;
- BI / Analytics;
- Data Consumption.

Version 1 may consolidate these responsibilities under one operator without eliminating their architectural separation.

### 19.29 Responsibility and Privilege

Technical privilege follows responsibility rather than seniority, convenience, or troubleshooting habit.

Organizational importance does not automatically justify unrestricted access.

Responsibility gaps and unclear decision authority remain governance risks.

### 19.30 Validation

Security and governance controls must be validated according to their actual enforcement mechanisms.

Where applicable:

**Authorized Behavior → ALLOWED**

**Prohibited Behavior → DENIED**

Configuration presence alone does not prove the control.

### 19.31 Evidence

Validated controls should produce evidence sufficient to relate:

**Requirement → Implementation → Test → Observation → Conclusion**

Evidence must preserve context without exposing the information the control is intended to protect.

### 19.32 Negative Evidence

A failed test remains valid evidence.

Unexpected behavior must lead to:

**Investigation → Root Cause → Decision → Remediation → Revalidation**

The governed expectation must not be rewritten merely to manufacture a PASS.

### 19.33 Drift

Divergence between intended and implemented state is a governance concern.

Relevant forms include:

- access drift;
- metadata drift;
- contract drift;
- quality-rule drift;
- retention drift;
- certified-product drift;
- security-configuration drift.

Where practical, implemented state must remain comparable with governed expected state.

### 19.34 Documentation

Documentation is part of the governed architecture.

Architecture, standards, contracts, metadata, implementation, tests, and evidence must not knowingly contradict one another.

Material changes require review of affected documentation.

### 19.35 Laboratory Boundary

Version 1 is a training, validation, and portfolio laboratory.

It demonstrates representative security and governance behavior under controlled conditions.

Laboratory limitations may simplify physical enforcement but do not redefine the logical architecture.

### 19.36 Enterprise Evolution

Enterprise implementations may replace or strengthen laboratory mechanisms through capabilities such as centralized identity, secrets management, privileged access, network segmentation, key management, SIEM, policy-as-code, automated governance, and stronger separation of duties.

Implementation mechanisms may evolve while the underlying security and governance properties remain stable.

### 19.37 Evidence-Bounded Claims

Atlas Engineering distinguishes controls that are:

**Documented**

**Implemented**

**Tested**

**Observed**

**Evidence-Backed**

No security, privacy, governance, enterprise-readiness, or compliance claim may exceed the implementation and evidence supporting it.

Laboratory readiness for enterprise evolution must not be represented as already implemented enterprise capability.

### 19.38 Closing Principle

Security and governance are successful when the platform can demonstrate that:

- authorized processing works;
- unauthorized behavior is constrained;
- sensitive information is minimized and protected;
- changes are governed;
- actions are attributable;
- retained data remains interpretable;
- recovery preserves current trust;
- analytical consumers receive governed data;
- controls can be validated;
- claims are supported by evidence.

The governing principle of Atlas Engineering is:

**Protect What Is Required → Expose Only What Is Authorized → Govern What Changes → Preserve What Must Be Explained → Validate What Is Claimed**