# Contributing to edge-agent-gitops

## TL;DR

- Deliver one coherent, independently reviewable GitOps capability per issue
  and pull request.
- Use an existing issue when supplied; otherwise include a complete proposed
  issue in the completion report.
- Proceed only on local, reversible assumptions. Stop for choices affecting a
  live target, ownership, state, security, cost, compatibility, or deletion.
- Keep preview and validation offline. Reconciliation or other external writes
  require an exact target and explicit authorization.
- Run `make validate` and report every passed, failed, and unavailable check.
- Use the exact EdgeAgent milestone titles and name one milestone per issue.

## Policy language and sources of truth

- **MUST** and **MUST NOT** identify requirements. A deviation requires an
  explicit reviewer-approved exception.
- **SHOULD** and **SHOULD NOT** identify strong defaults. A deviation records
  its reason and trade-off.
- **MAY** identifies an optional choice.

Lowercase guidance does not create hidden normative requirements.

| Concern | Canonical source |
| --- | --- |
| Contributor workflow and completion | This document |
| Concise tool-facing policy | [AGENTS.md](AGENTS.md) |
| Repository ownership and artifact flow | [Ownership and promotion](docs/architecture/ownership-and-promotion.md) |
| GitOps engineering rules | [Engineering standards](docs/development/engineering-standards.md) |
| Durable decisions | [Architecture decisions](docs/decisions/README.md) |
| Planned outcomes | [Milestones](docs/roadmap/milestones.md) |
| Product semantics and releases | [`edge-agent`](https://github.com/stanimirivanov/edge-agent) |
| Substrate capability and lifecycle | [`k8s-infrastructure`](https://github.com/stanimirivanov/k8s-infrastructure) |

The narrower source governs its stated concern. Accepted ADRs remain binding
until superseded. Contributors MUST surface an unresolved conflict instead of
silently choosing one source.

## Before starting

A contributor MUST:

- inspect the working tree and preserve unrelated changes;
- identify one milestone and one observable outcome;
- identify affected environments, resources, artifact digests, identities,
  secrets, cost, compatibility, rollout, recovery, and rollback;
- inspect relevant manifests, tests, policies, documentation, decisions, and
  source contracts; and
- determine whether the work is offline preparation or an authorized live
  operation.

An ADR is required for a durable change to repository ownership, promotion,
secret handling, deployment topology, environment compatibility, foundational
tooling, or reconciliation authority.

## Ambiguity and escalation

A documented assumption is allowed only when it is local, reversible,
inexpensive, within scope, and does not change external state, security,
compatibility, cost, ownership, or acceptance.

Stop and request a decision when missing information can materially change:

- the target cluster, cloud account, region, namespace, or environment;
- resource ownership, replacement, deletion, state, or persistent data;
- credentials, identity, network exposure, policy, or authorization;
- billable resources or provider selection;
- artifact compatibility, release promotion, rollback, or migration; or
- the boundary between application, UI, GitOps, and substrate repositories.

State the evidence, viable options, consequences, and safe remaining work.

## Issue timing and structure

With an issue number, follow its accepted scope and milestone. Without one,
implement the smallest coherent requested change and print a proposed issue in
the completion report. Do not create issues, milestones, branches, commits,
pull requests, releases, registry artifacts, credentials, or infrastructure
unless explicitly requested.

Every implementation issue uses:

```markdown
**Repository:** edge-agent-gitops
**Milestone:** MNN - Outcome

## Goal

Describe the problem and observable result.

## Scope

- Included behavior and boundaries.

## Design decisions

- Assumptions, compatibility, identity, ownership, and ADR links.

## Security and operations

- Trust, secrets, cost, external effects, rollout, recovery, and rollback.

## Acceptance criteria

- [ ] Observable behavior and verification evidence.
- [ ] Relevant rejection, failure, and recovery behavior.
- [ ] Documentation and operational effects.

## Verification

- Offline checks and any explicitly authorized live acceptance.

## Out of scope

- Explicit exclusions and deferred work.
```

Acceptance criteria describe observable behavior and verifiable invariants,
not implementation activities.

## Pull-request-sized work

A pull request MUST deliver one coherent GitOps outcome, retain recoverability,
and include manifests, policies, tests, documentation, and recovery behavior
needed to review that outcome. Split unrelated dependency updates, provider
profiles, environment additions, promotion automation, and broad refactoring.

Do not add empty environment trees, placeholder manifests, speculative
abstractions, or configuration for runtime capabilities that do not exist.

## External operations

Validation and rendering are offline and non-mutating. A live sync, bootstrap,
secret operation, registry write, provider action, or cluster mutation requires
explicit authorization and MUST:

- name and verify the exact repository revision, environment, cluster context,
  namespace, and intended resource owner;
- use a dedicated kubeconfig and bounded timeout;
- avoid credentials in arguments, logs, generated manifests, or Git;
- preserve non-secret diagnostic evidence for partial failure; and
- define a safe retry or rollback before execution.

Deletion, pruning, state migration, namespace replacement, credential rotation,
and persistent-data changes require separate explicit review. A Git merge is
not implicit authorization to perform a manual cluster mutation.

## Verification and constrained environments

Run:

```text
uv sync --locked
make validate
```

`make validate` currently runs formatting, linting, type checking, unit tests,
and local documentation-link validation. The first manifests MUST add pinned
rendering, Kubernetes schema, policy, and secret-scanning checks to this command
and CI in the same pull request.

When a required check cannot run, report it as **not run**, including the exact
command, blocker, safe attempts, evidence that did run, residual risk, and where
the missing check must run. Never weaken a check or report an unexecuted check
as passed. A failing check remains **failed**, even if unrelated.

## Documentation and review

Long architecture, security, operational, migration, and end-to-end documents
MUST include a `## TL;DR` near the start. Public configuration, failure
semantics, rollout, rollback, and troubleshooting change with behavior.

A pull request states its issue and milestone, outcome, exclusions,
assumptions, identity and state effects, security and cost effects, verification,
rollout, recovery, rollback, external authorization, and limitations.

Reviewers verify:

- one repository and one reconciler own every resource;
- every deployed artifact and external input is immutable and verified;
- secrets, state, kubeconfigs, plans, credentials, and machine paths are absent;
- destination, namespace, resource-kind, network, and identity permissions are
  least privilege;
- important rejection and recovery behavior is tested; and
- documentation and validation agree with the rendered desired state.

## Completion report

After every work item, print:

1. repository and exact milestone;
2. proposed GitHub issue title;
3. complete issue body using the required structure;
4. assumptions, unresolved questions, and limitations;
5. verification classified as **passed**, **failed**, or **not run**; and
6. a suggested imperative `[#N]` commit subject.

This report does not publish an issue, milestone, commit, or pull request.
