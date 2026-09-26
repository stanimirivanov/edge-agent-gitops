# Security policy

## TL;DR

- Report vulnerabilities privately; do not open a public issue containing
  exploit details, credentials, cluster identity, or sensitive configuration.
- Never commit credentials, kubeconfigs, Kubernetes Secret values,
  Terraform/OpenTofu state, generated plans, or decrypted material.
- Treat a writable GitOps source as a deployment authority and protect its
  branch, reviewers, automation identities, and Argo CD scope accordingly.
- Deployment identity is an attested `image@sha256:<digest>`, never a mutable
  tag.

## Reporting

Use GitHub private vulnerability reporting for
`stanimirivanov/edge-agent-gitops` when available. Otherwise contact the
repository owner through a private channel listed on the GitHub profile. Do not
include secrets in the initial report. Provide affected revisions, impact,
reproduction conditions, and a safe remediation suggestion where possible.

## Trust boundaries

This repository is authoritative for EdgeAgent environment desired state.
Write access can select executable artifacts, identities, network policy,
storage, and external secret references. Branch protection and required review
are therefore security controls.

The repository is not a secret store or infrastructure-state backend. Secret
values remain in an approved external system and enter workloads through
workload identity. Kubeconfigs, provider credentials, signing keys, registry
passwords, state, plans, and decrypted configuration remain outside Git and
must not appear in logs or fixtures.

Argo CD Projects must restrict source repositories, destination clusters,
namespaces, resource kinds, and roles. Access to the Argo CD namespace or
cluster-scoped resources is administrative and requires explicit review.

## Deployment integrity

- Verify release signatures, workflow identity, provenance, and required SBOM
  attestations before a digest becomes eligible for promotion.
- Pin images by SHA-256 digest and external charts, bases, policies, actions,
  and schemas by immutable revision.
- Render and validate desired state before reconciliation.
- Reject embedded secrets, privilege escalation, broad network access,
  ownership collisions, mutable inputs, and unsupported destinations.
- Preserve the EdgeAgent `dry_run` execution boundary through configuration,
  policy, identity, and egress controls.

## Response and recovery

If desired state or a promoted artifact is compromised, stop further
reconciliation, preserve non-secret audit evidence, identify affected commits
and digests, revoke the compromised identity through its owning system, and
promote a previously verified digest or reviewed corrective revision. Do not
rewrite shared Git history or move an old release tag as a recovery mechanism.

Credential rotation, cluster repair, source remediation, and GitOps rollback
remain separate operations owned by their respective repositories and systems.
