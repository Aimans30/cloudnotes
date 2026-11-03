$ErrorActionPreference = "Stop"

Write-Host "Running CloudNotes CI tests..." -ForegroundColor Cyan

# Test 1: HTML content
if (-not (Test-Path "index.html")) {
    throw "index.html is missing"
}

$html = Get-Content "index.html" -Raw

if ($html -notmatch "<title>CloudNotes</title>") {
    throw "CloudNotes title not found"
}

if ($html -notmatch "<h1>CloudNotes</h1>") {
    throw "CloudNotes heading not found"
}

Write-Host "PASS: CloudNotes HTML content"

# Test 2: NGINX health endpoints
if (-not (Test-Path "nginx.conf")) {
    throw "nginx.conf is missing"
}

$nginx = Get-Content "nginx.conf" -Raw

if ($nginx -notmatch "location\s+=\s+/health") {
    throw "Liveness endpoint /health is missing"
}

if ($nginx -notmatch "location\s+=\s+/ready") {
    throw "Readiness endpoint /ready is missing"
}

Write-Host "PASS: NGINX health endpoints"

# Test 3: Dockerfile
if (-not (Test-Path "Dockerfile")) {
    throw "Dockerfile is missing"
}

$dockerfile = Get-Content "Dockerfile" -Raw

if ($dockerfile -notmatch "FROM nginx:alpine") {
    throw "Expected nginx:alpine base image"
}

if ($dockerfile -notmatch "COPY index.html") {
    throw "HTML copy instruction missing"
}

if ($dockerfile -notmatch "COPY nginx.conf") {
    throw "NGINX configuration copy instruction missing"
}

Write-Host "PASS: Dockerfile configuration"

Write-Host "`nAll CloudNotes CI tests passed." -ForegroundColor Green
