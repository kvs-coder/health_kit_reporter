# health_kit_reporter — Architecture Documentation (arc42)

This set describes the architecture of the `health_kit_reporter` Flutter plugin following the [arc42](https://arc42.org) template.
It is derived from the code in `lib/`, `ios/`, `test/`, `example/` and `.github/workflows/`; where the code and
these pages disagree, the code wins and the page is a bug. The rules contributors follow live in `AGENTS.md`;
these pages explain the structure behind them.

| # | Chapter | Content |
| :--- | :--- | :--- |
| 1 | [Introduction and Goals](01-introduction-and-goals.md) | Purpose, quality goals, stakeholders |
| 2 | [Architecture Constraints](02-architecture-constraints.md) | Platform, distribution, contract and conventions |
| 3 | [Context and Scope](03-context-and-scope.md) | Business and technical context |
| 4 | [Solution Strategy](04-solution-strategy.md) | The few decisions that shape everything else |
| 5 | [Building Block View](05-building-block-view.md) | Dart API, models, channels, dispatcher, stream handlers, example |
| 6 | [Runtime View](06-runtime-view.md) | Method call, live query, save round trip, errors |
| 7 | [Deployment View](07-deployment-view.md) | pub.dev and SwiftPM distribution, CI and release |
| 8 | [Crosscutting Concepts](08-crosscutting-concepts.md) | JSON contract, timestamps, errors, threads, identity, availability, equality |
| 9 | [Architecture Decisions](09-architecture-decisions.md) | Index of the ADRs in `doc/adr/` |
| 10 | [Quality Requirements](10-quality-requirements.md) | Quality tree and scenarios |
| 11 | [Risks and Technical Debt](11-risks-and-technical-debt.md) | Known risks and debt |
| 12 | [Glossary](12-glossary.md) | Ubiquitous language |

Diagrams are Mermaid (C4-style flowcharts and sequence diagrams), so GitHub renders them inline.
