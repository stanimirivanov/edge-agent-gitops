# GitOps engineering standards

## TL;DR

- Pin every artifact and external input; render and validate complete targets
  offline before merge.
- Give each resource one owner and one reconciler, with least-privilege Argo CD
  destinations and resource permissions.
- Commit secret references, never secret values, credentials, access artifacts,
  provider state, or machine-specific paths.
- Keep repository scripts small and cohesive; delegate manifest parsing,
  rendering, schema, policy, signature, and secret analysis to maintained tools.
- Test rejection, partial failure, recovery, and rollback as first-class paths.

## Immutable inputs

OCI artifacts MUST use digests in environment desired state. Container tags,
chart versions, Git revisions, actions, tool binaries, schemas, policy bundles,
and remote bases MUST resolve to immutable identifiers and be updated through
review. Release evidence binds a digest to the expected source, builder,
signature, provenance, and SBOM.

Generated output is reproducible from committed inputs and locked tools. CI
does not fetch unpinned scripts or execute content piped from a network source.

## Manifest composition

Choose Kustomize, Helm, or a narrow combination only when concrete manifests
exist. Prefer the smallest mechanism that:

- renders a complete environment deterministically;
- keeps common behavior visible without hiding environment differences;
- fails on missing and unknown configuration; and
- supports offline schema and policy validation.

Do not add empty overlays, placeholder resources, speculative charts, or a
general-purpose internal manifest framework. Provider differences belong at
capability boundaries; domain services must not be rebuilt per provider.

## Validation gates

Every environment change validates the fully rendered target before merge. As
soon as manifests exist, `make validate` and CI MUST include pinned maintained
tools for:

1. deterministic rendering;
2. Kubernetes and custom-resource schema validation;
3. admission and repository policy;
4. secret and credential detection;
5. immutable-image and release-evidence verification; and
6. focused tests for repository-specific composition or policy glue.

Small repository scripts may orchestrate these tools and validate local
contracts. They MUST NOT reimplement YAML parsing, Kubernetes schema logic,
policy engines, cryptography, signature verification, or general link crawling.
Each script has focused unit tests, bounded input, actionable diagnostics, and
no dependency on credentials or live infrastructure for default validation.

## Reconciliation and ownership

One environment has one declared Argo CD authority for each resource. Projects
restrict source repositories, destinations, namespaces, and resource kinds.
Applications declare sync, retry, pruning, and deletion behavior explicitly;
defaults are not treated as policy.

CI and contributor validation are offline and non-mutating. A bootstrap, sync,
manual apply, prune, deletion, namespace replacement, or provider operation is
a separate live action that requires an exact target, preflight evidence,
bounded timeout, recovery plan, and explicit authorization.

## Secrets and identity

Git stores only external secret identifiers and controller declarations.
Workloads use dedicated Kubernetes service accounts and federated workload
identity; static cloud credentials are prohibited. Permissions are bounded by
component, environment, broker subject, database role, object prefix,
namespace, and operation.

Validation output, rendered manifests, test snapshots, CI logs, and support
bundles MUST exclude secret values, kubeconfigs, tokens, private keys, and cloud
provider state. Examples use unmistakably synthetic values.

## Runtime and lifecycle contracts

A deployable is not manifested until its source repository defines:

- process model, command, port, protocol, and configuration schema;
- readiness, liveness, startup, graceful drain, and termination behavior;
- dependency and migration ordering;
- persistent and ephemeral storage semantics;
- identity, authorization, ingress, egress, and network policy;
- resource requests, limits, concurrency, and backpressure; and
- compatibility, rollout, rollback, backup, and restore requirements.

Retry is bounded and limited to classified transient failures. Stateful changes
use expand-migrate-contract sequencing and prove recovery; rollback never
assumes an incompatible schema can be reversed by changing an image.

## Testing and review evidence

Tests cover happy paths and important negative paths: invalid digests,
unverified artifacts, missing capability inputs, malformed configuration,
forbidden permissions, duplicate ownership, unavailable dependencies, failed
rollout, and incompatible rollback. Profile conformance also exercises restart,
restore, drift, identity, messaging, storage, telemetry, and synthetic
end-to-end research and dry-run execution.

A supported claim requires retained evidence from the exact Git revision,
artifact digests, toolchain, substrate revision, and target profile. A skipped
or unavailable required check is reported as not run and blocks the claim.
