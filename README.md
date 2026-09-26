# edge-agent-gitops

## TL;DR

- This repository owns reviewed desired state and immutable release selection
  for EdgeAgent environments.
- It does not build EdgeAgent, provision clusters, install Argo CD, or contain
  credentials, kubeconfigs, provider state, or Secret values.
- The repository is at foundation stage and intentionally contains no workload
  manifests: current EdgeAgent binaries do not yet provide a long-running
  runtime or deployment health contract.
- `make validate` runs the locked, offline repository checks on Windows and
  Linux.
- M09 will add one thin, rendered, policy-checked portable Kubernetes profile
  before any managed-cloud profile is claimed as supported.

## Responsibility

`edge-agent-gitops` is the consumer-owned continuous-delivery boundary for
[EdgeAgent](https://github.com/stanimirivanov/edge-agent). It will own:

- Argo CD Projects, root and child Applications;
- workload namespaces, policies, service accounts, and configuration;
- exact verified backend and UI image digests;
- consumer instances of messaging, database, object storage, and telemetry;
- workload identity and external secret references; and
- promotion, rollback, drift, rendering, policy, and acceptance evidence.

[`k8s-infrastructure`](https://github.com/stanimirivanov/k8s-infrastructure)
owns project-neutral clusters, access delivery, Argo CD installation, shared
substrate capabilities, provider controls, and substrate qualification.
[`edge-agent-ui`](https://github.com/stanimirivanov/edge-agent-ui) will own the
browser artifact. Neither repository transfers credentials or infrastructure
state into this one.

The binding boundary is documented in
[ADR-0001](docs/decisions/0001-own-edgeagent-consumer-desired-state.md) and the
[ownership and promotion contract](docs/architecture/ownership-and-promotion.md).

## Status

The foundation establishes governance and cross-platform validation only. It
does not imply that an EdgeAgent deployment profile exists. A real profile
requires source-owned contracts for long-running process behavior, ports,
health, graceful termination, configuration, dependencies, storage, identity,
and resources.

No live cluster, Argo CD Application, namespace, registry artifact, credential,
or cloud resource is created or changed by this repository foundation.

## Planned layout

Directories are added only with exercised behavior:

```text
bootstrap/                 # consumer-owned AppProject and root Application
applications/              # independently reconciled dependency/workload apps
environments/
  local/                   # portable local profile
  managed-<provider>/      # one qualified managed profile at a time
policies/                  # promotion and rendered-resource policy
scripts/                   # small offline validation/orchestration helpers
tests/                     # deterministic harness and manifest tests
```

The first profile will establish whether Kustomize, Helm, or a composition of
both best expresses the concrete workload. This foundation does not select a
packaging tool before manifests exist.

## Development

Prerequisites:

- Python 3.13;
- [uv](https://docs.astral.sh/uv/) 0.12.18; and
- GNU Make for the convenience command surface.

Install and run all checks:

```text
uv sync --locked
make validate
```

See the [contributor workflow](CONTRIBUTING.md),
[engineering standards](docs/development/engineering-standards.md), and
[milestones](docs/roadmap/milestones.md) before proposing desired state.

## License

See [LICENSE](LICENSE).
