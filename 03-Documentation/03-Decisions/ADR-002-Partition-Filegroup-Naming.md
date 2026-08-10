# ADR-002 - Partition Filegroup Naming Strategy

## Status

Accepted

## Context

Atlas Commerce uses a time-based partitioning strategy designed to simulate
the lifecycle of a large transactional database.

Partitioned data will be managed using a sliding-window approach in which
older data can be archived or removed and the underlying storage structure
can subsequently be reused for future periods.

An initial naming option considered for partition filegroups was to associate
the filegroup name directly with the business year:

- FG_2024
- FG_2025
- FG_2026

This approach provides excellent visual identification when the filegroups
are initially created. However, it introduces a long-term lifecycle problem.

If a filegroup originally associated with 2024 is later reused to store data
for 2027, the name FG_2024 would no longer accurately describe its current
purpose.

For example:

    FG_2024 -> currently stores 2027 data

Although technically valid, this creates misleading metadata and increases
the cognitive cost of database administration.

## SQL Server Filegroup Renaming

SQL Server supports renaming an existing filegroup through ALTER DATABASE.

Example:

    ALTER DATABASE [AtlasCommerce]
    MODIFY FILEGROUP [FG_2024] NAME = [FG_2027];

Therefore, a year-based naming strategy could theoretically be maintained by
renaming filegroups whenever their storage role changes.

However, renaming a filegroup does not automatically rename:

- Logical database file names
- Physical MDF/NDF file names
- External deployment scripts
- Maintenance scripts
- Monitoring configurations
- SQL Agent jobs
- Documentation
- Other automation that may reference the previous filegroup name

This could lead to technically valid but operationally confusing
configurations such as:

    Filegroup     : FG_2027
    Logical file  : AtlasCommerce_2024
    Physical file : AtlasCommerce_2024.ndf

Maintaining temporal names would therefore introduce additional operational
work without providing a corresponding architectural benefit.

## Decision

Partition filegroups will use neutral structural identifiers:

- FG_P01
- FG_P02
- FG_P03
- FG_P04

The filegroup name represents the physical storage slot rather than the
business period currently stored in that slot.

The temporal relationship between data and storage will instead be defined
by the partition function and partition scheme.

Conceptually:

    Business period
         |
         v
    Partition Function
         |
         v
    Partition Scheme
         |
         v
    FG_P01 / FG_P02 / FG_P03 / FG_P04

This separates the physical storage lifecycle from the business calendar.

## Rationale

A filegroup is infrastructure.

A year is business-time metadata.

Coupling the two creates a naming relationship that becomes incorrect when
the storage structure is reused.

Using neutral filegroup names allows the same physical structure to
participate in a sliding-window lifecycle without requiring periodic
renaming.

For example:

Initial lifecycle:

    FG_P01 -> oldest active period
    FG_P02 -> subsequent period
    FG_P03 -> current period
    FG_P04 -> future / available capacity

After archival and rotation, FG_P01 may later participate in a newer period
without its name becoming misleading.

## Alternatives Considered

### Year-based filegroups

Example:

    FG_2024
    FG_2025
    FG_2026

Advantages:

- Immediate visual identification
- Simple relationship between period and storage during initial deployment

Disadvantages:

- Names become inaccurate when storage is reused
- Requires periodic filegroup renaming to preserve semantic accuracy
- Logical and physical file names may become inconsistent
- External scripts and operational documentation may retain obsolete names
- Couples physical infrastructure to business-time semantics

Decision: Rejected.

### Neutral reusable filegroups

Example:

    FG_P01
    FG_P02
    FG_P03
    FG_P04

Advantages:

- Stable names throughout the database lifecycle
- Supports sliding-window partition maintenance
- Avoids periodic infrastructure renaming
- Keeps physical storage independent from temporal business meaning
- Reduces operational ambiguity over long-lived systems

Disadvantages:

- Current time-period association is not immediately visible from the
  filegroup name alone
- Administrators must inspect the partition function and partition scheme to
  determine the current mapping

Decision: Accepted.

## Consequences

The partition function and partition scheme become the authoritative source
for determining which business periods map to each filegroup.

Operational and diagnostic scripts should expose this mapping clearly so
administrators do not need to infer it manually.

The project should therefore include diagnostic queries capable of showing:

- Partition number
- Boundary values
- Filegroup
- Row count
- Current period represented by each partition

This preserves operational visibility without encoding temporary business
meaning into permanent infrastructure names.