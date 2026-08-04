\# ADR-001 - Repository Structure



\## Status



Accepted



\## Date



2026-08-04



\## Context



The project was created from scratch to simulate the implementation of a real enterprise data platform.



Since the repository is expected to evolve over time with multiple technologies, environments, scripts, databases and technical documentation, it was necessary to define an initial directory structure before any source code was developed.



Establishing this structure early helps maintain consistency, improves discoverability of project assets and simplifies future maintenance.



\## Decision



Repository structure version 1.0 was established before any implementation activities.



A modular repository structure was adopted.



The repository is organized into independent top-level directories, each representing a specific responsibility within the project, including source code, database artifacts, documentation, scripts and tests.



Technical documentation is maintained separately from the source code and is further divided into dedicated sections such as environment, standards, architectural decisions, architecture and learning notes.



This organization will be preserved throughout the project's lifecycle.



\## Consequences



Positive



\- Clear separation of responsibilities.

\- Easier navigation.

\- Better scalability.

\- Documentation evolves independently from the implementation.

\- Simplifies onboarding of future contributors.



Negative



\- Requires discipline to keep the repository organized.

\- Slightly higher initial effort to define standards.



\## Alternatives Considered



A simpler repository structure with all files stored at the root level was considered.



Although this approach would reduce the initial setup effort, it was rejected because the repository is expected to grow significantly during the project and would become increasingly difficult to maintain over time.

