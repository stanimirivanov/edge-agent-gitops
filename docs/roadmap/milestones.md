# EdgeAgent GitOps milestones

## TL;DR

- This repository implements the deployment portions of the canonical
  [EdgeAgent milestones](https://github.com/stanimirivanov/edge-agent/blob/main/docs/roadmap/milestones.md).
- M09 establishes artifact promotion, a portable reference profile, Argo CD
  desired state, conformance, and one qualified managed profile.
- M10 adds operational evidence for drift, rollout, rollback, recovery, and
  emergency control.
- M11 promotes the UI artifact through the same immutable release path; it does
  not move backend or infrastructure authority into the browser.
- Later work may be explored early, but no profile is supported before its
  prerequisites and conformance gates pass.

## M09 - Multi-cloud deployment profiles

**Outcome:** Promote identical signed artifacts through portable and managed
profiles.

GitOps work is delivered in this order:

1. Establish repository ownership, contributor policy, architecture decisions,
   and a cross-platform validation harness.
2. Accept source-owned runtime contracts for every deployable and dependency.
3. Add one thin portable Kubernetes profile plus deterministic rendering,
   schema, policy, secret, signature, provenance, and SBOM gates.
4. Add least-privilege Argo CD Project and Application composition with explicit
   sync, prune, deletion, and recovery semantics.
5. Add immutable digest promotion and rollback for backend artifacts without
   rebuilding per environment.
6. Implement the shared profile-conformance contract for identity, messaging,
   storage, telemetry, migrations, restart, rollback, restore, and synthetic
   research and dry-run execution.
7. Qualify one managed-cloud profile against the same contract, including
   region, residency, availability, quota, egress, retention, recovery, and
   cost constraints.

Completion requires a tagged EdgeAgent release deployed to the portable
profile and one managed profile using identical signed image digests, with
retained automated conformance evidence.

## M10 - Operational readiness

**Outcome:** Operate, recover, limit, and stop the distributed system safely.

This repository owns the desired state and evidence for:

- drift detection and reviewed remediation;
- staged rollout, compatibility gates, bounded retry, and automatic stop;
- compatible digest rollback and state-aware recovery;
- backup, restore, retention, deletion, and projection-rebuild exercises;
- workload identity, least privilege, network policy, resource budgets, and
  kill-switch configuration; and
- operational dashboards, alerts, runbooks, and failure-injection acceptance.

Completion requires operators to diagnose and recover declared failures from
versioned procedures without manual database repair or undocumented cluster
mutation.

## M11 - Trusted user experience

**Outcome:** Promote the independently built UI without changing domain
authority.

After the UI repository publishes a signed, provenance-bound, SBOM-attested
artifact, this repository adds its exact digest, runtime configuration,
identity, ingress, content-security controls, rollout, rollback, and acceptance
checks. The browser reaches only gateway-owned public contracts. Argo CD,
infrastructure mutation, secret administration, replay, and emergency controls
remain outside the UI.

Completion requires the UI artifact to pass the same promotion discipline and
to demonstrate synthetic research and literal `dry_run` workflows against a
qualified backend profile.

## Planning rules

- GitHub owns live issue, assignee, label, and milestone state.
- Every issue names one exact canonical EdgeAgent milestone and one observable
  repository outcome.
- Work from a later milestone MAY begin as discovery when it clarifies a
  prerequisite; implementation MUST NOT bypass integrity, contract, or
  compatibility dependencies.
- A profile, deployment path, or recovery procedure is supported only after its
  automated acceptance evidence passes for the exact revision and artifacts.
- GCP, Azure, and AWS profiles are added incrementally after the portable
  contract and first managed profile expose the real variation points.
