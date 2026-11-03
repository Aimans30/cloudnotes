# CloudNotes on Kubernetes

CloudNotes is a static frontend served by nginx (`Dockerfile`, `index.html`), deployed with two manifests in `k8s/`:

- `k8s/deployment.yaml` - 3 replicas, image `cloudnotes:1.0`, named container port `http` (80), CPU/memory requests and limits, HTTP readiness probe on `/`.
- `k8s/service.yaml` - `ClusterIP` Service `cloudnotes`, selector `app=cloudnotes`, port `http` 80 -> named target port `http`.

## Run locally (Docker Desktop Kubernetes)

```powershell
docker build -t cloudnotes:1.0 .
kubectl config current-context
kubectl get nodes
kubectl apply -f k8s/
kubectl rollout status deployment/cloudnotes
kubectl get pods
kubectl get deployments
kubectl get svc cloudnotes
kubectl get endpoints cloudnotes
kubectl port-forward svc/cloudnotes 8080:80   # keep running
curl.exe -I http://localhost:8080/            # in a second terminal
```

## Self-healing and rolling updates

The Deployment uses a `RollingUpdate` strategy (`maxUnavailable: 0`, `maxSurge: 1`) so all replicas keep serving during an update, and a liveness probe so Kubernetes restarts a hung container.

## Verify the full chain

`.\scripts\verify.ps1` checks the node, the pods, that the Service selector (`app: cloudnotes`) matches the pod labels, that the endpoints are not empty, and that the app returns HTTP 200 through a port-forward.

## Production GKE mapping

The Kubernetes Deployment and Service manifests are portable to Google Kubernetes Engine. For a production GKE deployment, the CloudNotes container image would first be published to Google Artifact Registry or another registry accessible by the cluster, and the Deployment image reference would be updated accordingly. The current ClusterIP Service provides internal cluster access. For external access, a LoadBalancer Service or Kubernetes Ingress can be configured. This submission was tested on Docker Desktop Kubernetes locally and does not require a paid GKE cluster.

