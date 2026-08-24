# Development Environment

## Purpose

This document describes the local development environment and the primary tools used to build, manage, validate, and document the Atlas Engineering Enterprise Data Platform.

Its purpose is to provide a clear reference for the development workstation and the software dependencies and supporting tools used to reproduce and maintain the project environment.

---

## Operating System

The local development environment runs on:

- Windows 11 Pro

The operating system provides the workstation platform for the development, administration, validation, documentation, and repository-management activities performed within Atlas Engineering.

---

## Development Tools

The Atlas Engineering local development environment currently uses the following primary tools.

### Git

Used for distributed version control and local repository management.

Git provides the underlying version-control functionality for tracking changes to project artifacts and maintaining the local repository history.

### GitHub Desktop

Used as the graphical interface for Git operations and synchronization between the local repository and the remote GitHub repository.

GitHub Desktop supports the current development workflow but does not replace Git as the underlying version-control system.

### Visual Studio Code

Used for repository navigation, documentation editing, script development, and general project file management.

It serves as the primary editor for versioned Atlas Engineering source files and documentation.

### SQL Server 2025 Developer Edition

Used as the local relational database platform for AtlasCommerce development, deployment, testing, and validation.

SQL Server Developer Edition provides the SQL Server feature set required to develop and validate the database platform in the local non-production environment.

### SQL Server Management Studio

Used for SQL Server administration, T-SQL development, deployment execution, database inspection, diagnostics, and validation.

It is the primary graphical administration and development interface used for the local SQL Server environment.

### Schemity Lite

Used to create and maintain the Entity-Relationship Diagram (ERD) for the AtlasCommerce relational data model.

The generated diagram provides a visual representation of the database structure and relationships and complements the versioned database scripts and architecture documentation maintained within the project.

---

## Remote Repository

GitHub is used as the remote repository hosting platform for Atlas Engineering.

The local Git repository is synchronized with the remote repository through GitHub Desktop, providing remote persistence of versioned project artifacts, repository history, and controlled synchronization between the local and remote environments.

GitHub complements the local development workflow by providing the remote version-control platform for the project.