# Architectural Decision Records (ADRs)

This directory contains Architectural Decision Records (ADRs) for Thriftwood, documenting important architectural decisions made during development.

## About ADRs

ADRs are documents that capture important architectural decisions along with their context and consequences. We use the [MADR (Markdown Architectural Decision Records)](https://adr.github.io/madr/) template format.

## Format

Each ADR follows this structure:

- **Title**: Short noun phrase describing the decision
- **Status**: proposed | rejected | accepted | deprecated | superseded
- **Deciders**: Who was involved in the decision
- **Date**: When the decision was made
- **Technical Story**: Link to related issues or context
- **Context and Problem Statement**: What problem are we solving?
- **Decision Drivers**: What factors influenced the decision?
- **Considered Options**: What alternatives were evaluated?
- **Decision Outcome**: What was chosen and why?
- **Pros and Cons**: Trade-offs of each option
- **More Information**: Implementation details and references

## Decision Log

| ADR                                                        | Title                                      | Status   | Date       |
| ---------------------------------------------------------- | ------------------------------------------ | -------- | ---------- |
| [0001](0001-single-navigationstack-per-coordinator.md)     | Single NavigationStack Per Coordinator     | accepted | 2025-10-05 |
| [0002](0002-use-swiftdata-over-coredata.md)                | Use SwiftData Over CoreData                | accepted | 2025-10-04 |
| [0003](0003-use-swinject-for-dependency-injection.md)      | Use Swinject for Dependency Injection      | accepted | 2025-10-04 |
| [0004](0004-use-asynchttpclient-over-custom-networking.md) | Use AsyncHTTPClient Over Custom Networking | accepted | 2025-10-04 |
| [0005](0005-use-mvvm-c-pattern.md)                         | Use MVVM-C Pattern                         | accepted | 2025-10-03 |

## Creating a New ADR

1. Copy the MADR template or use an existing ADR as reference
2. Number it sequentially (e.g., `0002-my-decision.md`)
3. Fill in all sections with relevant information
4. Add it to the Decision Log table above
5. Link related ADRs in the "Related Decisions" section

## References

- [MADR Template](https://adr.github.io/madr/)
- [Why document architecture decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- [ADR GitHub Organization](https://adr.github.io/)
