# Architecture decision records

Architecture decision records capture durable choices that constrain more than
one change. Accepted decisions are binding until a later ADR supersedes them.

## Index

| ADR | Status | Decision |
| --- | --- | --- |
| [ADR-0001](0001-own-edgeagent-consumer-desired-state.md) | Accepted | Own EdgeAgent consumer desired state in this repository |

## When to write an ADR

Write an ADR before changing repository ownership, reconciliation authority,
deployment topology, promotion or rollback semantics, secret handling,
environment compatibility, or foundational packaging and validation tooling.
Routine implementation inside an accepted boundary does not need a new ADR.

## Template

```markdown
# ADR-NNNN: Decision title

- Status: Proposed
- Date: YYYY-MM-DD
- Milestone: MNN - Exact title

## Context

State the forces, constraints, and decision that must be made.

## Decision

State the binding choice and its operational mechanics.

## Consequences

Describe benefits, costs, failure behavior, compatibility, and follow-up work.

## Alternatives considered

Describe viable alternatives and why they were not selected.
```
