# Repository working agreement

## TL;DR

- Read `CONTRIBUTING.md`; it is the canonical workflow policy.
- Preserve consumer ownership: this repository owns EdgeAgent desired state,
  not source builds, clusters, Argo CD installation, or application semantics.
- Promote verified immutable digests through review; never deploy mutable tags.
- Keep validation offline and mutation-free unless a named live target and
  explicit authorization are supplied.
- Commit external secret references, never credentials, kubeconfigs, Secret
  values, provider state, or generated plans.
- Do not add placeholder manifests for runtime contracts that do not exist.

[CONTRIBUTING.md](CONTRIBUTING.md) defines issue timing, escalation,
verification, and completion. Normative terms such as MUST, SHOULD, and MAY
have the meanings defined there.

## Before changing anything

1. Inspect the branch and working tree and preserve unrelated changes.
2. Read [CONTRIBUTING.md](CONTRIBUTING.md), the
   [ownership and promotion contract](docs/architecture/ownership-and-promotion.md),
   relevant [engineering standards](docs/development/engineering-standards.md),
   accepted [decisions](docs/decisions/README.md), and the applicable milestone.
3. Identify the exact environment, artifact identities, resource ownership,
   state effects, cost risk, rollout, recovery, and rollback.
4. Run repository-local validation and report unavailable checks honestly.

If documentation, manifests, live state, and accepted decisions conflict,
surface the conflict. Do not silently adopt a convenient owner or weaken a
guardrail.

## Repository responsibility

This repository owns EdgeAgent consumer desired state:

- Argo CD Projects, Applications, and environment composition;
- workload namespaces, policies, service accounts, configuration, and external
  secret references;
- exact signed backend and UI image digests selected per environment;
- consumer instances of messaging, database, object-storage, and telemetry
  capabilities; and
- promotion, rollback, rendering, policy, and product-acceptance evidence.

It does not own Rust or UI source builds, public API meaning, Kubernetes or
cloud substrate provisioning, Argo CD installation, provider credentials,
Terraform/OpenTofu state, schema migration implementation, or runtime secrets.

## GitOps integrity

- Desired state MUST be declarative, reproducible, reviewable, and renderable
  offline.
- Workload images MUST use `image@sha256:<digest>`; tags are discovery metadata
  and MUST NOT be deployment identity.
- Remote charts, bases, actions, policies, and schemas MUST be pinned to an
  immutable release or digest with an explicit update path.
- One reconciler owns each resource. Competing Argo CD Applications, Helm
  releases, imperative scripts, and provider stacks MUST NOT manage the same
  object.
- Secrets enter through workload identity and external secret references.
  Plaintext, encrypted payloads without a reviewed decryption boundary, and
  generated Secret values MUST NOT be committed.
- Render, schema, policy, signature, and conformance checks precede promotion.
- A failed or partial sync preserves diagnostic evidence and requires an
  explicit retry or rollback; it must not widen access or replace state.
- EdgeAgent currently has no long-running service contract. Do not invent
  Deployments, probes, ports, or resource claims before their source contracts
  and acceptance tests exist.

## Quality and completion

- Keep custom harness modules small and cohesive. Delegate Kubernetes schema,
  policy, workflow, signature, and manifest rendering to maintained tools when
  those capabilities are introduced.
- Test important refusal paths: mutable tags, unpinned sources, embedded
  secrets, ownership collisions, invalid destinations, and unsupported
  capabilities.
- A supported profile needs rendered desired state plus identity, messaging,
  storage, telemetry, restart, rollback, and restore conformance evidence.
- Documentation changes with public configuration, operational behavior,
  recovery, and troubleshooting.
- Finish each work item with the completion report defined in
  [CONTRIBUTING.md](CONTRIBUTING.md#completion-report).
