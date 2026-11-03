# CloudNotes readiness checklist (completed)

## Assessment header

| Field | Value |
| --- | --- |
| System | CloudNotes (static nginx frontend on Kubernetes) |
| Repository | `Aimans30/cloudnotes` |
| Reviewed base / source commit | `4876c5b` (`feature/cloudnotes-k8s-final` tip: CI + k8s probes/replicas) |
| Related infra commit (referenced, not merged to main) | `0b33ca9` (`feature/cloudnotes-full-infra`) |
| Assessment branch | `assessment/production-readiness` |
| Assessment date | 2026-11-03 |
| Assessor / owner | Aimans30 (repo owner) |
| Environment under review | **Local / simulated** — Docker Desktop Kubernetes (historical), GitHub Actions CI, zero-cost Terraform mocks |
| Intended release scope | Course local release of CloudNotes frontend manifests + CI; **not** multi-region production GCP |
| Workload / data assumptions | Stateless static HTML/nginx; **no** application database in the reviewed k8s release; no customer PII store in-scope |
| Target SLO | **GAP — not agreed / not documented** prior to this review |
| Target RTO | **GAP — not agreed / not documented** |
| Target RPO | **GAP — not agreed / not documented** |
| Scoring | PASS=2, PARTIAL=1, FAIL=0, UNVERIFIED=0 |

> Missing SLO/RTO/RPO targets are recorded as gaps. They are **not** invented to force a GO.

Core checks below are the Technical Aid set (4 per dimension). None marked N/A.

---

## Dimension 1 — Reliability

### R1 — Multi-replica availability (app tier not a single-pod SPOF)

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-K8S-01, EV-README-01 |
| Finding | Deployment sets `replicas: 3`. Surviving a live pod/node failure was **not** re-drilled on 2026-11-03 (API server unreachable). Config proves intent; HA behaviour is not freshly proven. |
| Owner | Aimans30 |
| Next action / retest | Start Docker Desktop Kubernetes; delete one pod; confirm Service still returns HTTP 200 via `scripts/verify.ps1`. Retest condition: screenshot/log of 2/3 Ready during disruption. |

### R2 — Health probes / self-healing controls (**GATE**)

| Field | Value |
| --- | --- |
| Status | **PASS** |
| Score | 2 |
| Evidence ID | EV-K8S-01, EV-NGINX-01, EV-CI-01, EV-CI-02 |
| Finding | Liveness `/health` and readiness `/ready` are defined on the container and implemented in nginx. `scripts/test.ps1` confirms endpoint blocks exist (re-run 2026-11-03: PASS). Live kubelet probe execution not revalidated (no cluster) — accepted as PASS for **control definition + static verification** within local scope; disclose live gap under limits of EV-KUBECTL-01. |
| Owner | Aimans30 |
| Next action / retest | With cluster up, `kubectl describe pod` shows successful probes; break `/ready` temporarily and confirm endpoints remove the pod. |

### R3 — Safe rolling update strategy

| Field | Value |
| --- | --- |
| Status | **PASS** |
| Score | 2 |
| Evidence ID | EV-K8S-01, EV-README-01 |
| Finding | `RollingUpdate` with `maxUnavailable: 0`, `maxSurge: 1` preserves capacity during rollouts in configuration. |
| Owner | Aimans30 |
| Next action / retest | Perform an image tag rollout on local cluster; capture `kubectl rollout status` with zero unavailable replicas. |

### R4 — Resource requests and limits

| Field | Value |
| --- | --- |
| Status | **PASS** |
| Score | 2 |
| Evidence ID | EV-K8S-01 |
| Finding | CPU/memory requests and limits are set on the CloudNotes container. |
| Owner | Aimans30 |
| Next action / retest | Compare actual usage (`kubectl top` / metrics) vs requests after 7 days local soak; adjust if saturated. |

**Reliability subtotal: 7 / 8**

---

## Dimension 2 — Observability

### O1 — Metrics and dashboards for user-visible health

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-OBS-01, EV-OBS-02, EV-OBS-03 |
| Finding | Prometheus scrape config, blackbox probe job, and Grafana dashboard JSON exist as **sanitized course artifacts** under `production-readiness/evidence/monitoring/`. They prove a monitoring design is defined. No capture shows the dashboard rendering live against the reviewed revision on 2026-11-03. |
| Owner | Aimans30 |
| Next action / retest | Bring up `docker-compose` observability stack; export PNG of CloudNotes dashboard with live series. |

### O2 — Actionable alerting (**GATE**)

| Field | Value |
| --- | --- |
| Status | **UNVERIFIED** |
| Score | 0 |
| Evidence ID | EV-OBS-04; **missing:** alert-fire capture / notification channel proof |
| Finding | `CloudNotesEndpointDown` rule is defined (`probe_success == 0`). There is **no** evidence an alert fired, routed to a human, or was acknowledged. Definition ≠ operating alerting. **GATE fails.** |
| Owner | Aimans30 |
| Next action / retest | Stop the app container; capture Prometheus Alertmanager/`ALERTS` showing firing state and a delivery path (email/Slack webhook to a test sink). Closure: firing + resolve screenshots dated, linked as new evidence IDs. |

### O3 — Centralized / structured logging

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-OBS-05, EV-OBS-06, EV-NGINX-01 |
| Finding | Loki/Promtail configs exist in evidence. Reviewed `nginx.conf` on the assessment branch uses default/access logging without a committed structured JSON pipeline on this revision. No proof logs are queryable for an incident. |
| Owner | Aimans30 |
| Next action / retest | Commit structured access logs; ship to Loki; attach LogQL query result for a known request. |

### O4 — Verification path / operability aid

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-SCRIPT-01, EV-README-01, EV-KUBECTL-01 |
| Finding | `scripts/verify.ps1` and README document a local verification chain. On assessment date the cluster API was down, so verify could not be re-run successfully. |
| Owner | Aimans30 |
| Next action / retest | Re-run `.\scripts\verify.ps1` with cluster healthy; attach transcript as EV-SCRIPT-02. |

**Observability subtotal: 3 / 8**

---

## Dimension 3 — Security

### S1 — Secrets not in source; secret references externalized (**GATE**)

| Field | Value |
| --- | --- |
| Status | **PASS** |
| Score | 2 |
| Evidence ID | EV-SEC-01, EV-CI-01 |
| Finding | No `.env`, kubeconfig, or raw tokens committed in reviewed tree. CI references `secrets.DOCKERHUB_USERNAME` / `DOCKERHUB_TOKEN` (values not in git). Static app has no runtime DB secrets. `.gitignore` is minimal (gap for future secret file patterns) but does not negate S1 PASS for current tree. |
| Owner | Aimans30 |
| Next action / retest | Extend `.gitignore` for `.env`, `*.pem`, `kubeconfig`; confirm `git secrets`/`gitleaks` clean scan attached. |

### S2 — Access / network boundary controls (**GATE**)

| Field | Value |
| --- | --- |
| Status | **FAIL** |
| Score | 0 |
| Evidence ID | EV-K8S-02, EV-NET-01; **missing:** enforced TLS + default-deny policy for cloudnotes |
| Finding | Reviewed release exposes only ClusterIP Service — good default locality — but **no** NetworkPolicy on the reviewed manifests, **no** Ingress TLS, HTTP-only nginx listen 80. Draft `netpol` in evidence targets `app: db` / `app: api` labels that **do not match** the CloudNotes workload (`app: cloudnotes`), so it does not protect this release. **GATE fails.** |
| Owner | Aimans30 |
| Next action / retest | Add default-deny + allow probe/Service policy for `app=cloudnotes`; optional local TLS; prove with a denied test-client pod. |

### S3 — Workload / image hygiene

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-DOCKER-01, EV-CI-01 |
| Finding | Minimal `nginx:alpine` image. No vulnerability scan report (Trivy/Grype) attached. No explicit `securityContext` (non-root, read-only root FS) on the Deployment. |
| Owner | Aimans30 |
| Next action / retest | Attach CI scan SARIF/log with zero critical CVEs or documented exceptions. |

### S4 — Identity least privilege

| Field | Value |
| --- | --- |
| Status | **UNVERIFIED** |
| Score | 0 |
| Evidence ID | EV-IAM-01 |
| Finding | Terraform IAM module describes least-privilege bindings via `null_resource` mocks only (`0b33ca9`). Not applied to a real cloud project; does not prove runtime identity for the k8s release. |
| Owner | Aimans30 |
| Next action / retest | Replace mocks with real IAM (or Workload Identity) in a non-prod project; capture `gcloud` policy binding read-back. |

**Security subtotal: 3 / 8**

---

## Dimension 4 — Disaster recovery

### D1 — Backup strategy defined for in-scope data/config

| Field | Value |
| --- | --- |
| Status | **FAIL** |
| Score | 0 |
| Evidence ID | **missing-evidence:** no backup job / snapshot policy |
| Finding | Git hosts source (not a tested backup system). No volume/database/object-storage backup job for any stateful dependency. Reviewed workload is stateless, but release config/cluster state still lacks a backup control. |
| Owner | Aimans30 |
| Next action / retest | Document and automate backup of manifests + any future state store; schedule weekly. |

### D2 — Restore drill with integrity proof (**GATE**)

| Field | Value |
| --- | --- |
| Status | **UNVERIFIED** |
| Score | 0 |
| Evidence ID | **missing-evidence:** restore transcript + integrity check |
| Finding | No restore drill artifact exists. Local pod reschedule is **not** a database/regional restore. **GATE fails.** |
| Owner | Aimans30 |
| Next action / retest | Perform restore into a clean namespace/cluster; verify HTTP 200 and content hash of `index.html`; record duration. |

### D3 — RTO/RPO targets declared and compared to drill (**GATE**)

| Field | Value |
| --- | --- |
| Status | **FAIL** |
| Score | 0 |
| Evidence ID | **missing-evidence:** agreed RTO/RPO; this checklist header records the gap |
| Finding | No pre-agreed RTO/RPO. Cannot compare drill timing/data-loss bounds to targets. Missing targets block a defensible GO. **GATE fails.** |
| Owner | Aimans30 (to propose); stakeholder to accept |
| Next action / retest | Publish targets (e.g., RTO ≤ 30m, RPO ≤ 0 for static git-backed content); re-run D2 and record measured values vs targets. |

### D4 — DR / failover beyond local self-healing

| Field | Value |
| --- | --- |
| Status | **FAIL** |
| Score | 0 |
| Evidence ID | EV-README-01 (explicitly local-only) |
| Finding | README states testing on Docker Desktop and does not require paid GKE. No multi-zone/region failover runbook or evidence. |
| Owner | Aimans30 |
| Next action / retest | Document DR pattern (e.g., redeploy from git to second cluster); execute tabletop + one technical failover test. |

**Disaster recovery subtotal: 0 / 8**

---

## Dimension 5 — Cost

### C1 — Rightsizing / resource governance as cost control

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-K8S-01 |
| Finding | Requests/limits cap waste on paper; no usage-based rightsizing evidence. |
| Owner | Aimans30 |
| Next action / retest | Attach 7-day usage vs request chart. |

### C2 — Cost estimate with explicit assumptions and scope

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-COST-01 |
| Finding | Written estimate for **local/simulated** scope (~$0 cloud) with assumptions. Explicitly **not** an actual bill or savings claim. Hypothetical prod mapping is out of GO scope. |
| Owner | Aimans30 |
| Next action / retest | If promoting to GKE, replace with calculator export + billing account labels. |

### C3 — Idle / waste hygiene for the declared environment

| Field | Value |
| --- | --- |
| Status | **PARTIAL** |
| Score | 1 |
| Evidence ID | EV-COST-01, EV-README-01 |
| Finding | Declared local scope avoids always-on cloud nodes. No automated idle-shutdown for any cloud sandbox. |
| Owner | Aimans30 |
| Next action / retest | If any cloud project is used, add TTL labels / budget-based shutdown runbook. |

### C4 — Budget or spend anomaly visibility

| Field | Value |
| --- | --- |
| Status | **UNVERIFIED** |
| Score | 0 |
| Evidence ID | **missing-evidence:** budget alert config / notification |
| Finding | No GCP Budget, AWS Budget, or equivalent alert artifact. |
| Owner | Aimans30 |
| Next action / retest | Create a $0–$10 sandbox budget alert; attach notification test. |

**Cost subtotal: 3 / 8**

---

## Extra checks (optional, non-scoring aids)

### X1 — CI gate exists for basic regressions

| Field | Value |
| --- | --- |
| Status | PARTIAL |
| Evidence ID | EV-CI-01, EV-CI-02 |
| Finding | GitHub Actions runs `scripts/test.ps1` then builds/pushes. No evidence attached of a green Actions run URL for `4876c5b` (Actions API not queried with auth during assessment). Local re-run of tests PASS on 2026-11-03. |

### X2 — IaC present but mock-scoped

| Field | Value |
| --- | --- |
| Status | PARTIAL |
| Evidence ID | EV-TF-01, EV-IAM-01 |
| Finding | Full module layout exists on `feature/cloudnotes-full-infra` with null/random providers — useful design evidence, not production provision proof. |
