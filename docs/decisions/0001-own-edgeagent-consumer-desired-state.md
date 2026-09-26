# ADR-0001: Own EdgeAgent consumer desired state in this repository

- Status: Accepted
- Date: 2026-09-26
- Milestone: M09 - Multi-cloud deployment profiles

## Context

EdgeAgent needs portable and managed Kubernetes profiles without coupling
product releases to cluster implementation. Application source, UI source,
consumer desired state, and shared substrate have different release cadence,
permissions, failure domains, and reviewers. Combining them would allow a
source or infrastructure change to mutate workload deployment implicitly and
would obscure which reconciler owns a resource.

The current application does not yet publish a deployable runtime contract.
Choosing concrete manifests or a packaging tool now would encode assumptions
about process lifetime, ports, health, dependencies, resources, identity, and
shutdown behavior.

## Decision

`edge-agent-gitops` owns EdgeAgent's consumer-side desired state:

- Argo CD Projects, root and child Applications;
- namespaces, workload manifests, policies, configuration, service accounts,
  and network controls;
- consumer instances of messaging, database, object storage, and telemetry;
- external secret references and workload-identity bindings;
- exact verified backend and UI image digests; and
- promotion, rollback, drift, rendering, policy, and acceptance evidence.

The repository does not own application or UI builds, clusters, cloud
accounts, Argo CD installation, shared substrate controllers, credential
values, kubeconfigs, or Terraform/OpenTofu state. `k8s-infrastructure`
publishes qualified capability inputs; this repository consumes them without
co-owning their implementation.

Each live resource has exactly one Git source and one reconciler. Merge changes
desired state; it does not authorize a separate imperative apply. Deployment
artifacts are selected by immutable digest and must satisfy signature,
provenance, SBOM, rendering, schema, and policy gates before promotion.

The first workload-manifest change will choose Kustomize, Helm, or a narrow
composition based on actual runtime contracts. This ADR deliberately defers
that choice.

## Consequences

- Product releases and infrastructure evolution remain independently
  reviewable while deployment promotion has a dedicated audit trail.
- The GitOps repository requires explicit contracts from both source and
  substrate repositories; it cannot infer missing runtime or provider details.
- Operators roll back through reviewed desired state to a previously verified,
  compatible digest. Stateful recovery also follows migration and restore
  policy.
- No credentials or infrastructure state move into this repository.
- There is no live-state transfer for this decision because no EdgeAgent
  resources are currently reconciled.
- The repository remains manifest-free until EdgeAgent publishes the minimum
  deployment contract and the manifest change adds maintained validation tools.

## Alternatives considered

### Keep desired state in `edge-agent`

This improves proximity to source but couples deployment authority and
environment review to application changes. It also makes independent UI and
dependency promotion awkward. Rejected because it weakens separation of
duties and the promotion audit boundary.

### Add EdgeAgent directly to `k8s-infrastructure`

This reuses an existing Argo CD repository but mixes product-specific
dependencies and release cadence with shared cluster substrate. Rejected
because resource ownership, reviewers, and rollback domains differ.

### Generate manifests in CI without storing desired state

This reduces files in Git but makes the deployed result depend on an ephemeral
generator invocation and weakens review and recovery. Rejected because GitOps
requires a reproducible, reviewable declaration of the reconciled state.
