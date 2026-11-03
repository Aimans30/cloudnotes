# Evidence index

Each evidence ID below is traceable. **Unknown metadata is marked explicitly.**  
Rule applied: a config file proves a control is **defined**; it does **not** prove a drill passed.

## Applicability to reviewed revision

| Revision | Role |
| --- | --- |
| `4876c5b` | Primary reviewed application/CI tree (assessment branch base) |
| `0b33ca9` | Referenced Terraform mocks on `feature/cloudnotes-full-infra` — **not** merged into `main` at assessment start |
| Stash-derived monitoring/netpol | Course-local artifacts copied **into** `production-readiness/evidence/` on 2026-11-03 for review; historically **uncommitted** to `main`/`k8s-final`. Treat as design evidence only until merged and revalidated. |

If application manifests change after this assessment, revalidate EV-K8S-*, EV-NGINX-*, EV-CI-*, and any drill-based IDs.

---

## EV-K8S-01 — Deployment manifest (replicas, probes, resources, rollout)

| Field | Value |
| --- | --- |
| Path / URL | `k8s/deployment.yaml` (also snapshot `production-readiness/evidence/k8s/deployment.yaml`) |
| Description | CloudNotes Deployment: 3 replicas, RollingUpdate maxUnavailable 0, probes, requests/limits |
| Capture / test date | 2026-11-03 (file as of reviewed commit `4876c5b`) |
| Environment | Repository (config) |
| Source commit / version | `4876c5b` |
| Expected result | Controls for R1–R4 present in YAML |
| Observed result | Present as defined in file |
| Limits | Does not prove live probe success, pod-kill survival, or rollout drill |
| Checks supported | R1, R2, R3, R4, C1 |

## EV-K8S-02 — Service manifest

| Field | Value |
| --- | --- |
| Path / URL | `k8s/service.yaml` (snapshot `production-readiness/evidence/k8s/service.yaml`) |
| Description | ClusterIP Service `cloudnotes` |
| Capture / test date | 2026-11-03 |
| Environment | Repository (config) |
| Source commit / version | `4876c5b` |
| Expected result | Stable in-cluster access definition |
| Observed result | ClusterIP only; no LoadBalancer/Ingress on reviewed release |
| Limits | Not a TLS or NetworkPolicy control |
| Checks supported | S2 (context), O4 (access path) |

## EV-NGINX-01 — nginx health endpoints

| Field | Value |
| --- | --- |
| Path / URL | `nginx.conf` (snapshot `production-readiness/evidence/k8s/nginx.conf`) |
| Description | `/health` and `/ready` return 200 plain text |
| Capture / test date | 2026-11-03 |
| Environment | Repository (config) |
| Source commit / version | `4876c5b` |
| Expected result | Probe targets exist |
| Observed result | Locations defined; confirmed by EV-CI-02 |
| Limits | Does not prove kubelet probe timing in cluster |
| Checks supported | R2, O3 (partial — logging mostly default) |

## EV-CI-01 — GitHub Actions workflow

| Field | Value |
| --- | --- |
| Path / URL | `.github/workflows/ci.yml` (snapshot `production-readiness/evidence/ci/ci.yml`) |
| Description | On push: run tests; build/push image using Docker Hub **secret references** |
| Capture / test date | 2026-11-03 |
| Environment | Repository (config) |
| Source commit / version | `4876c5b` |
| Expected result | Automated test + image publish path defined; secrets not inlined |
| Observed result | Workflow present; uses `${{ secrets.* }}` |
| Limits | No authenticated fetch of Actions run conclusion URL during assessment (unknown whether latest push was green on GitHub) |
| Checks supported | S1, S3 (partial), X1 |

## EV-CI-02 — Local `scripts/test.ps1` run

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/ci/test-ps1-local-run.txt` (script: `scripts/test.ps1`) |
| Description | Static checks for HTML, nginx health locations, Dockerfile |
| Capture / test date | 2026-11-03 |
| Environment | Assessor workstation (Windows) |
| Source commit / version | Assessment branch at documentation time (content matches `4876c5b` scripts) |
| Expected result | All CloudNotes CI tests passed |
| Observed result | PASS for HTML, NGINX health endpoints, Dockerfile |
| Limits | Does not exercise Kubernetes or container runtime |
| Checks supported | R2, X1 |

## EV-KUBECTL-01 — Cluster availability at assessment

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/scripts/kubectl-context-note.txt` |
| Description | `kubectl get nodes` during assessment |
| Capture / test date | 2026-11-03 |
| Environment | Local kubectl client v1.36.1 |
| Source commit / version | N/A (runtime) |
| Expected result | Node Ready (if claiming live local verify) |
| Observed result | API connection refused to `127.0.0.1` — **no live cluster** |
| Limits | Blocks revalidation of verify.ps1 / live probes / HA drills on this date |
| Checks supported | Documents gaps for R1, R2 (live), O4, D2 |

## EV-SCRIPT-01 — Verify script definition

| Field | Value |
| --- | --- |
| Path / URL | `scripts/verify.ps1` (snapshot `production-readiness/evidence/scripts/verify.ps1`) |
| Description | End-to-end local chain: nodes, pods, selector, endpoints, HTTP 200 via port-forward |
| Capture / test date | Defined in `4876c5b`; **not successfully re-executed** 2026-11-03 |
| Environment | Intended: Docker Desktop Kubernetes |
| Source commit / version | `4876c5b` |
| Expected result | “All checks passed” |
| Observed result | **UNVERIFIED on assessment date** (see EV-KUBECTL-01) |
| Limits | Historical README success ≠ current revalidation |
| Checks supported | O4, R1/R2 (when re-run) |

## EV-README-01 — Scope and operability documentation

| Field | Value |
| --- | --- |
| Path / URL | `README.md` |
| Description | Local runbook, rolling update notes, explicit local Docker Desktop testing / no paid GKE required |
| Capture / test date | 2026-11-03 |
| Environment | Repository |
| Source commit / version | `4876c5b` |
| Expected result | Clear local scope statement |
| Observed result | Documents local verification; production GKE described as mapping only |
| Limits | Not evidence of production DR or cloud cost |
| Checks supported | O4, D4, C3, release-scope claims |

## EV-OBS-01 — Prometheus config

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/monitoring/prometheus.yml` |
| Description | Scrape jobs including blackbox `cloudnotes-probe` against `/health` |
| Capture / test date | 2026-11-03 (copied from local course stash into evidence) |
| Environment | Design artifact (local observability compose) |
| Source commit / version | **Unknown** prior commit — not on `4876c5b`; introduced to assessment branch as evidence |
| Expected result | Metrics pipeline defined |
| Observed result | File present with probe job |
| Limits | No live Prometheus targets-up proof |
| Checks supported | O1 |

## EV-OBS-02 — Grafana dashboard JSON

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/monitoring/cloudnotes-dashboard.json` |
| Description | CloudNotes Grafana dashboard model |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact |
| Source commit / version | Unknown prior; assessment-branch evidence copy |
| Expected result | Dashboard defined |
| Observed result | JSON present |
| Limits | Does not prove panels populate |
| Checks supported | O1 |

## EV-OBS-03 — Observability compose file

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/monitoring/docker-compose.observability.yml` |
| Description | Local compose wiring for observability components |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact |
| Source commit / version | Unknown prior; assessment-branch evidence copy |
| Expected result | Runnable local stack definition |
| Observed result | File present (sanitized; no credentials found) |
| Limits | Compose up not executed during assessment |
| Checks supported | O1, O3 (supporting) |

## EV-OBS-04 — Alert rule definition

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/monitoring/alerts.yml` |
| Description | `CloudNotesEndpointDown` on `probe_success == 0` |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact |
| Source commit / version | Unknown prior; assessment-branch evidence copy |
| Expected result | Symptom-oriented alert defined |
| Observed result | Rule present |
| Limits | **No firing, routing, or ack evidence** — insufficient for O2 PASS |
| Checks supported | O2 (definition only → UNVERIFIED overall) |

## EV-OBS-05 — Loki config

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/monitoring/loki-config.yml` |
| Description | Loki local config |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact |
| Source commit / version | Unknown prior |
| Expected result | Log store defined |
| Observed result | File present |
| Limits | No query proof |
| Checks supported | O3 |

## EV-OBS-06 — Promtail config

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/monitoring/promtail-config.yml` |
| Description | Log shipper config |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact |
| Source commit / version | Unknown prior |
| Expected result | Ship path defined |
| Observed result | File present |
| Limits | Not wired to reviewed nginx on `4876c5b` |
| Checks supported | O3 |

## EV-NET-01 — Draft NetworkPolicy (mismatch)

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/k8s/netpol.yaml` |
| Description | NetworkPolicy for `app: db` allowing `app: api` |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact (not in reviewed k8s release) |
| Source commit / version | Unknown prior; not on `4876c5b` release manifests |
| Expected result | Would need to protect CloudNotes labels to count for S2 |
| Observed result | Selectors **do not match** `app: cloudnotes` |
| Limits | Cannot be used to claim S2 PASS for this release |
| Checks supported | S2 (negative / gap evidence) |

## EV-SEC-01 — `.gitignore` snapshot

| Field | Value |
| --- | --- |
| Path / URL | `.gitignore` / `production-readiness/evidence/security/gitignore.txt` |
| Description | Ignore rules present in repo |
| Capture / test date | 2026-11-03 |
| Environment | Repository |
| Source commit / version | `4876c5b` |
| Expected result | Basic hygiene |
| Observed result | Only `.DS_Store` / `Thumbs.db` — weak for secrets patterns |
| Limits | Absence of ignored patterns ≠ secrets present; tree review found no committed secrets |
| Checks supported | S1 (supporting) |

## EV-DOCKER-01 — Dockerfile

| Field | Value |
| --- | --- |
| Path / URL | `Dockerfile` |
| Description | `FROM nginx:alpine`; copies HTML + nginx.conf |
| Capture / test date | 2026-11-03 |
| Environment | Repository |
| Source commit / version | `4876c5b` |
| Expected result | Minimal static image build |
| Observed result | Matches CI expectations (EV-CI-02) |
| Limits | No scan report |
| Checks supported | S3 |

## EV-IAM-01 — Terraform IAM mock module

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/infra/iam-main.tf` (source branch file `infra/modules/iam/main.tf` @ `0b33ca9`) |
| Description | null_resource stand-ins for SA + role bindings |
| Capture / test date | 2026-11-03 |
| Environment | IaC design / zero-cost mock |
| Source commit / version | `0b33ca9` |
| Expected result | Documents intended least-privilege roles |
| Observed result | Mock only — not applied to cloud IAM |
| Limits | Does not prove cloud identity enforcement |
| Checks supported | S4 |

## EV-TF-01 — Terraform zero-cost providers

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/infra/providers.tf` (@ `0b33ca9`) |
| Description | null + random providers for local validate/plan |
| Capture / test date | 2026-11-03 |
| Environment | Local IaC |
| Source commit / version | `0b33ca9` |
| Expected result | Zero-cost validation possible |
| Observed result | Provider file present |
| Limits | Not production provisioning evidence |
| Checks supported | X2, C2 (supports $0 local IaC assumption) |

## EV-COST-01 — Local cost estimate

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/cost/local-cost-estimate.md` |
| Description | Assumptions-scoped cost model for local/simulated release |
| Capture / test date | 2026-11-03 |
| Environment | Analytical |
| Source commit / version | Assessment commit (this PR) |
| Expected result | Estimate with assumptions; not labeled as actual bill |
| Observed result | Documented ~$0 cloud for declared scope |
| Limits | Not FinOps telemetry; hypothetical GKE numbers illustrative only |
| Checks supported | C2, C3 |

## EV-ING-01 — Draft Ingress (optional context)

| Field | Value |
| --- | --- |
| Path / URL | `production-readiness/evidence/k8s/ingress.yaml` |
| Description | Draft ingress manifest from local course work |
| Capture / test date | 2026-11-03 |
| Environment | Design artifact |
| Source commit / version | Unknown prior; not in `4876c5b` release |
| Expected result | External routing definition if adopted |
| Observed result | Present in evidence only |
| Limits | No TLS secret evidence; not applied |
| Checks supported | S2 (gap context) |

---

## Missing evidence register (explicit)

| Needed for | What is missing | Plan |
| --- | --- | --- |
| O2 PASS | Alert firing + notification delivery | Fail probe; capture Alertmanager; test webhook |
| D2 PASS | Restore drill transcript + integrity check | Restore to clean env; time it; hash `index.html` |
| D3 PASS | Agreed RTO/RPO + measured comparison | Stakeholder write-up then retest D2 |
| C4 | Budget alert | Create sandbox budget + test notification |
| R1 live | Pod disruption drill | Delete pod under load of verify.ps1 |
| S2 PASS | Matching NetworkPolicy + deny test | Author policy for `app=cloudnotes`; prove denial |
| S3 | Image CVE scan | Add Trivy in CI; attach report |
| S4 | Real IAM bindings | Apply non-prod IAM; capture read-back |
| Actions green URL | Workflow run link for `4876c5b` | Open Actions UI; link run in follow-up evidence |
