# Verifies the full CloudNotes chain on the current Kubernetes context.
# Usage: .\scripts\verify.ps1   (starts and stops its own port-forward on 8080)
$ErrorActionPreference = "Stop"
function Step($msg) { Write-Host "`n== $msg" -ForegroundColor Cyan }

Step "Context and nodes"
kubectl config current-context
kubectl get nodes

Step "Pods (expect 1/1 Running)"
kubectl get pods -l app=cloudnotes

Step "Service selector vs pod labels"
$selector = kubectl get svc cloudnotes -o jsonpath='{.spec.selector.app}'
$podApps  = kubectl get pods -l app=cloudnotes -o jsonpath='{.items[*].metadata.labels.app}'
Write-Host "Service selector app=$selector ; pod labels app=$podApps"
if (-not $podApps -or ($podApps -split ' ' | Where-Object { $_ -ne $selector })) { throw "Selector does not match pod labels" }

Step "Endpoints (must not be empty)"
$ips = kubectl get endpoints cloudnotes -o jsonpath='{.subsets[*].addresses[*].ip}'
if (-not $ips) { throw "Service has no endpoints" }
kubectl get endpoints cloudnotes

Step "HTTP check through port-forward"
$pf = Start-Process kubectl -ArgumentList 'port-forward','svc/cloudnotes','8080:80' -PassThru -WindowStyle Hidden
try {
    $code = '000'
    for ($i = 0; $i -lt 15 -and $code -ne '200'; $i++) {
        Start-Sleep -Seconds 1
        $code = curl.exe -s -o NUL -w '%{http_code}' http://localhost:8080/
    }
    Write-Host "HTTP status: $code"
    if ($code -ne "200") { throw "Expected HTTP 200, got $code" }
} finally { Stop-Process -Id $pf.Id -ErrorAction SilentlyContinue }

Write-Host "`nAll checks passed." -ForegroundColor Green

