# Partition Filegroup Naming Strategy

## Status

Accepted

## Context

Atlas Commerce uses a time-based partitioning strategy designed to simulate the lifecycle of a large transactional database.

Partitioned data is organized so that the physical storage structure remains independent from the business period currently mapped to it.

An initial naming option considered for partition filegroups was to associate the filegroup name directly with the business period, for example:

- `FG_2024`
- `FG_2025`
- `FG_2026`

This approach provides excellent visual identification when the filegroups are initially created. However, it introduces a long-term lifecycle problem.

If a filegroup originally associated with 2024 is later reused to store data for another period, the name `FG_2024` would no longer accurately describe its current purpose.

For example:

    FG_2024 -> currently stores 2027 data

Although technically valid, this creates misleading metadata and increases the cognitive cost of database administration.

The physical storage identifier should therefore remain stable while the temporal meaning of the data is determined by the partitioning architecture.

## SQL Server Filegroup Renaming

SQL Server supports renaming an existing filegroup through `ALTER DATABASE`.

Example:

```sql
ALTER DATABASE [AtlasCommerce]
MODIFY FILEGROUP [FG_2024] NAME = [FG_2027];
```

Therefore, a period-based naming strategy could theoretically be maintained by renaming filegroups whenever their storage role changes.

However, renaming a filegroup does not automatically rename or update:

- logical database file names;
- physical MDF/NDF file names;
- external deployment scripts;
- maintenance scripts;
- monitoring configurations;
- SQL Server Agent jobs;
- documentation;
- other automation that may reference the previous filegroup name.

This could lead to technically valid but operationally confusing configurations such as:

```text
Filegroup     : FG_2027
Logical file  : AtlasCommerce_2024
Physical file : AtlasCommerce_2024.ndf
```

Maintaining temporal names would therefore introduce additional operational work without providing a corresponding architectural benefit.

## Decision

Partition filegroups will use neutral structural identifiers that describe their physical role without encoding the business period stored within them.

For the current `sales` partitioning architecture, the implemented filegroups are organized as:

- `FG_SALES_LEGACY`
- `FG_SALES_PART_01` through `FG_SALES_PART_37`
- `FG_SALES_FUTURE`

The numbered `FG_SALES_PART_*` filegroups represent physical storage slots rather than specific years or months.

`FG_SALES_LEGACY` and `FG_SALES_FUTURE` have explicit structural roles for data outside the currently defined partition boundaries.

The temporal relationship between data and storage is defined by the partition function and partition scheme:

- `PF_SALES_MONTHLY`
- `PS_SALES_MONTHLY`

Conceptually:

```text
Business period
     |
     v
PF_SALES_MONTHLY
     |
     v
PS_SALES_MONTHLY
     |
     v
FG_SALES_LEGACY
FG_SALES_PART_01 ... FG_SALES_PART_37
FG_SALES_FUTURE
```

This separates the physical storage lifecycle from the business calendar while keeping the filegroup naming stable as partition mappings evolve.

## Rationale

A filegroup is infrastructure.

A business period is temporal metadata.

Coupling the two creates a naming relationship that can become inaccurate when the physical storage structure is reused for another period.

Using neutral structural filegroup names allows the physical storage architecture to remain stable while the temporal mapping evolves independently through the partition function and partition scheme.

In the current `sales` partitioning architecture, names such as:

- `FG_SALES_PART_01`
- `FG_SALES_PART_02`
- `FG_SALES_PART_03`

identify physical storage slots without implying that those slots permanently belong to a specific year or month.

Similarly, `FG_SALES_LEGACY` and `FG_SALES_FUTURE` describe structural roles rather than fixed calendar periods.

The authoritative relationship between a business period and its physical storage location is therefore maintained by:

- `PF_SALES_MONTHLY`;
- `PS_SALES_MONTHLY`.

This keeps infrastructure naming stable, avoids unnecessary renaming as partition mappings evolve, and prevents temporary business-time meaning from becoming embedded in permanent physical identifiers.

## Alternatives Considered

### Period-based filegroups

Example:

```text
FG_2024
FG_2025
FG_2026
```

Advantages:

- Immediate visual identification of the business period initially associated with each filegroup
- Simple relationship between period and storage during initial deployment

Disadvantages:

- Names can become inaccurate when physical storage is reused
- Requires periodic filegroup renaming to preserve semantic accuracy
- Logical and physical file names may become inconsistent with the renamed filegroup
- External scripts, automation, monitoring, and operational documentation may retain obsolete names
- Couples physical infrastructure to business-time semantics

Decision: Rejected.

### Neutral structural filegroups

Current implementation:

```text
FG_SALES_LEGACY
FG_SALES_PART_01
FG_SALES_PART_02
...
FG_SALES_PART_37
FG_SALES_FUTURE
```

Advantages:

- Stable structural names throughout the database lifecycle
- Keeps physical storage independent from temporal business meaning
- Avoids periodic infrastructure renaming as partition mappings evolve
- Supports the current monthly partitioning architecture without embedding years or months in filegroup names
- Reduces operational ambiguity in long-lived environments

Disadvantages:

- The business period associated with a numbered filegroup is not immediately visible from the filegroup name alone
- Administrators must inspect the partition function and partition scheme to determine the current mapping

Decision: Accepted.

## Consequences

The partition function and partition scheme are the authoritative sources for determining how business periods map to physical filegroups.

For the current `sales` partitioning architecture, this responsibility belongs to:

- `PF_SALES_MONTHLY`;
- `PS_SALES_MONTHLY`.

The deployment validation already verifies the structural consistency of the partitioning architecture, including:

- required partition filegroups;
- database files associated with those filegroups;
- partition function configuration;
- expected boundary sequence;
- partition scheme configuration;
- destination-to-filegroup mapping;
- `NEXT USED` configuration.

Because numbered filegroup names intentionally do not encode a business period, administrators must use the partitioning metadata when they need to determine the current relationship between periods, partitions, and physical storage.

Additional operational diagnostic queries may expose information such as:

- partition number;
- boundary values;
- filegroup;
- row count;
- business period represented by each partition.

These diagnostics improve operational visibility without making temporary business-time meaning part of permanent infrastructure naming.