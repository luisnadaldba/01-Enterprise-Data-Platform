# Repository Structure

## Status

Accepted

## Context

Atlas Engineering was created from scratch to simulate the implementation and evolution of a real enterprise data platform.

The repository is expected to evolve over time as multiple technologies, environments, databases, scripts, documentation, tests, and other technical assets are introduced.

A defined repository structure is therefore necessary to maintain clear separation of responsibilities, provide predictable locations for project artifacts, and prevent the repository from becoming increasingly difficult to navigate as the platform grows.

Establishing and preserving this organization improves consistency, asset discoverability, maintainability, and the ability to evolve individual areas of the platform without losing the overall structure of the project.

## Decision

Atlas Engineering will use a modular and responsibility-oriented repository structure.

Project artifacts are organized hierarchically so that each directory has a clear technical purpose and related artifacts remain grouped within the area that owns them.

The version-controlled repository is rooted at:

```text
01-Enterprise-Data-Platform
```

Its current structure separates:

```text
01-Enterprise-Data-Platform
|
+-- 01-Source
+-- 02-Database
+-- 03-Documentation
+-- 04-Scripts
+-- 05-Tests
```

These directories represent distinct responsibilities:

- `01-Source` — application or platform source artifacts when required;
- `02-Database` — physical database data and log files used by the local environment;
- `03-Documentation` — technical, architectural, business, standards, decision, environment, and learning documentation;
- `04-Scripts` — executable technical scripts organized by responsibility;
- `05-Tests` — test artifacts associated with the platform.

Technical documentation is further organized by purpose:

```text
03-Documentation
|
+-- 01-Environment
+-- 02-Standards
+-- 03-Decisions
+-- 04-Architecture
+-- 05-Business
+-- 06-Learning
```

Executable scripts are similarly separated by technical responsibility. Within database deployment, numbered directories are used when sequence has operational meaning, while descriptive names are used for artifacts that do not require an execution order.

Supporting installers and development tools used to reproduce or prepare the local project environment are maintained outside the version-controlled repository. These local resources are not part of the platform implementation and are not committed to source control.

The repository structure may evolve as Atlas Engineering grows, but the principles of responsibility separation, predictable artifact placement, and meaningful sequencing will be preserved.

## Consequences

### Positive

- Clear separation of responsibilities across repository areas.
- Predictable locations for technical artifacts.
- Easier navigation and discovery as the project grows.
- Documentation can evolve independently while remaining organized alongside the implementation.
- Database deployment artifacts can be separated by technical responsibility and execution sequence.
- New technologies and platform components can be introduced without requiring unrelated areas of the repository to be reorganized.
- The structure provides a consistent foundation for future contributors and environments.

### Negative

- Requires discipline to keep artifacts in their intended locations.
- Structural conventions must be maintained as new areas are introduced.
- Additional hierarchy increases the number of directories compared with a simpler repository.
- Changes to established directory names or locations may require updates to scripts, documentation, automation, or other references.

## Alternatives Considered

### Flat repository structure

A simpler structure in which most project artifacts would be stored at or near the repository root was considered.

Advantages:

- Lower initial setup effort.
- Fewer directories to create and maintain.
- Simple navigation while the project contains only a small number of artifacts.

Disadvantages:

- Responsibilities become increasingly mixed as the repository grows.
- Documentation, scripts, database artifacts, tests, and future platform components become more difficult to locate and manage.
- Execution order and technical ownership are less visible.
- Growth in one area increases organizational complexity across the repository as a whole.
- Future restructuring becomes more disruptive after scripts, documentation, and automation begin depending on established paths.

Decision: Rejected.

### Modular responsibility-oriented structure

A hierarchical structure in which artifacts are grouped according to technical responsibility was considered.

Advantages:

- Clear separation between platform implementation, documentation, scripts, tests, and database artifacts.
- Predictable locations for related artifacts.
- Supports meaningful sequencing where execution order matters.
- Allows individual areas of Atlas Engineering to evolve without requiring unrelated areas to be reorganized.
- Provides a scalable organizational foundation as additional technologies and platform components are introduced.

Disadvantages:

- Requires more initial organization.
- Introduces additional directory hierarchy.
- Requires continued discipline to preserve structural consistency as the project evolves.

Decision: Accepted.