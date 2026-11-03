# CloudNotes cost estimate (assumptions-only — NOT an actual bill)

| Field | Value |
| --- | --- |
| Evidence ID | EV-COST-01 |
| Capture date | 2026-11-03 |
| Environment | Local / simulated (Docker Desktop Kubernetes + null/random Terraform providers) |
| Scope | Intended local course release only — not production GKE/GCP spend |
| Source | Analytical estimate by assessor; no cloud billing export attached |

## Assumptions

1. Workload is a static nginx frontend (`cloudnotes`), 3 replicas, requests `100m CPU / 64Mi`, limits `500m / 128Mi`.
2. No managed database, load balancer, NAT gateway, or multi-region networking in the **declared local scope**.
3. Terraform under `feature/cloudnotes-full-infra` uses `null`/`random` providers — **$0** provider/API cost for validate/plan; apply was not performed.
4. Observability stack (Prometheus/Grafana/Loki) considered only as optional local Docker Compose — not a paid SaaS.
5. Image registry: public Docker Hub tags already used in course work; no Artifact Registry pricing modeled.
6. Currency USD; prices illustrative list-price order-of-magnitude for a **hypothetical** single small GKE autopilot/zonal mapping — labeled estimate only.

## Hypothetical production mapping (out of scope for GO)

If the same 3-replica frontend were moved to a small zonal GKE cluster with ClusterIP only (no LB), rough monthly order-of-magnitude might be tens of USD for control plane/node overhead — **not measured**. This is **not** an actual invoice or realized savings claim.

## Local / simulated scoped cost

| Item | Estimated monthly cost | Notes |
| --- | --- | --- |
| Local Kubernetes (Docker Desktop) | $0 incremental cloud | Uses local machine |
| Terraform null/random plan | $0 | No apply |
| Course CI (GitHub Actions) | Within free/student minutes if available | Not metered here |
| **Scoped total** | **~$0 cloud bill** | Matches local/simulated release |

## Limits

- Does **not** prove production FinOps maturity.
- Does **not** include egress, LB, Cloud SQL, snapshots, or log retention.
- Must not be cited as “actual savings” or “actual GCP bill.”
