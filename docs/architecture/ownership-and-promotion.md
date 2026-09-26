# EdgeAgent ownership and promotion contract

## TL;DR

- Each resource has one owning repository and one reconciler.
- `edge-agent-gitops` selects immutable, verified EdgeAgent artifacts and owns
  their consumer-side Kubernetes desired state.
- `edge-agent` builds and signs deployables; `edge-agent-ui` does the same for
  the browser artifact; `k8s-infrastructure` supplies a qualified substrate.
- Promotion changes Git. Argo CD reconciles the accepted revision. Rollback
  restores a previously verified digest through the same review path.
- No profile is supported until its rendered state and conformance evidence
  pass the published gates.

## Source-of-truth boundaries

| Repository | Owns | Does not own |
| --- | --- | --- |
| [`edge-agent`](https://github.com/stanimirivanov/edge-agent) | Rust source, domain and transport contracts, migrations, deployable images, release SBOMs, provenance, signatures, and runtime requirements | Environment selection, cluster lifecycle, Argo CD, or consumer dependency instances |
| [`edge-agent-ui`](https://github.com/stanimirivanov/edge-agent-ui) | UI source, generated-client consumption, browser artifact, release SBOM, provenance, and signature | Backend authority, deployment reconciliation, or infrastructure |
| `edge-agent-gitops` | Argo CD Projects and Applications, workload desired state, dependency instances, environment policy, exact image digests, promotion, rollback, drift, and deployment acceptance | Source builds, image publication, clusters, Argo CD installation, credential values, or provider state |
| [`k8s-infrastructure`](https://github.com/stanimirivanov/k8s-infrastructure) | Clusters, access delivery, Argo CD installation, provider controls, shared substrate capabilities, and substrate qualification | EdgeAgent workload releases, product configuration, or product dependency lifecycle |

The GitOps repository consumes substrate capabilities through documented
contracts. It does not copy infrastructure implementation details or assume
ownership of shared controllers. A resource MUST NOT be reconciled by both
infrastructure and product GitOps.

## Capability handoff

Before a profile can target a substrate, the infrastructure owner publishes
non-secret capability inputs such as:

- cluster identity and supported Kubernetes/API versions;
- Argo CD destination name and permitted namespaces;
- ingress, DNS, certificate, workload-identity, secret-store, storage-class,
  telemetry, and policy capabilities;
- availability, residency, quota, cost, backup, and recovery constraints; and
- the substrate qualification revision and evidence.

GitOps consumes these values through an explicit environment contract. Secret
values, kubeconfigs, provider credentials, Terraform/OpenTofu state, and
generated access artifacts never enter this repository.

## Release and promotion flow

1. A source repository builds each deployable once and publishes an OCI image
   plus SBOM, provenance, and signature. The release identifies the image by
   digest, not by a mutable tag.
2. A promotion pull request changes an allowlisted component to an exact digest
   and records its release evidence.
3. Offline validation verifies the signature and provenance policy, confirms
   the expected source and builder identity, inspects the SBOM policy, renders
   the complete target, and runs schema, policy, secret, and contract checks.
4. Review verifies compatibility, migration order, identity, network exposure,
   resources, state effects, rollout, recovery, and rollback.
5. Merge establishes desired state. The environment's single Argo CD
   reconciler applies it according to the declared sync and rollout policy.
6. Automated acceptance checks verify health, identity, messaging, storage,
   telemetry, migration, restart, and data-path behavior. Promotion is not
   complete until required evidence passes.

Release discovery MAY use a mutable channel outside desired state. A committed
environment MUST resolve every deployed artifact to an immutable digest.
Provider profiles MUST promote the same application digests; provider-specific
rebuilds are prohibited.

## Failure, recovery, and rollback

- A failed offline gate blocks merge and cannot affect a cluster.
- A reconciliation failure stops at the bounded rollout policy, preserves Argo
  diagnostics, and does not trigger an unreviewed imperative repair.
- A failing acceptance check marks the promotion unsuccessful even if
  Kubernetes reports resources healthy.
- Rollback selects the last compatible, previously verified digest and desired
  state revision. Stateful rollback follows the migration compatibility and
  restore contract; image reversal alone is never assumed safe.
- If Git and live state diverge, operators diagnose ownership and controller
  status before retrying. Manual drift is removed through reviewed desired
  state or an explicitly authorized emergency procedure, then reconciled back
  into Git.

## Identity and secret boundaries

Workloads use dedicated service accounts and workload identity. Namespaced
roles, broker subjects, database roles, storage paths, and secret references
are scoped per component and environment. Git stores only secret identifiers
and external-secret declarations. Rendered output, CI logs, test fixtures, and
diagnostic bundles MUST NOT contain secret values.

Argo CD source, destination, namespace, and resource-kind permissions are
least privilege. Production reconciliation authority is separate from source
build authority; neither source repository can deploy merely by publishing an
artifact.

## Profile qualification

The portable Kubernetes profile is the reference behavior. A profile is
claimed as supported only when it has:

- deterministic, pinned rendering and Kubernetes schema validation;
- admission-policy and secret-scanning results;
- explicit runtime, dependency, storage, identity, network, resource, and
  lifecycle contracts;
- install, upgrade, restart, rollback, restore, and drift evidence; and
- end-to-end synthetic research and dry-run execution acceptance results.

The repository intentionally has no workload manifests yet. Current EdgeAgent
binaries do not expose a long-running process, port, readiness, liveness,
graceful-drain, resource, or dependency contract. The first manifest pull
request MUST add those source-owned contracts and the maintained render,
schema, policy, and secret-scanning tools that validate them.
