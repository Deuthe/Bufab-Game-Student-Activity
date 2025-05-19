if (-Not (Test-Path "venv")) {
    Write-Host "Error: Virtual environment 'venv' does not exist."
    Write-Host "Please run 'setup.ps1' first to set it up."
    exit 1
}

Write-Host "Activating virtual environment..." -ForegroundColor Cyan
.\venv\Scripts\Activate.ps1

Write-Host "Searching for local IP address..." -ForegroundColor Cyan
$ipconfigOutput = ipconfig
$validIPs = @()

foreach ($line in $ipconfigOutput) {
    if ($line -match "IPv4.*?:\s*([\d\.]+)") {
        $ip = $Matches[1]
        if ($ip -ne "127.0.0.1" -and $ip -notmatch "^192\.168\.(216|238|137)\.") {
            $validIPs += $ip
        }
    }
}

if ($validIPs.Count -gt 0) {
    $LocalIP = $validIPs[0]
    Write-Host "Local IP found: $LocalIP" -ForegroundColor Green
} else {
    Write-Warning "No valid IPv4 address found. Using 0.0.0.0"
    $LocalIP = "0.0.0.0"
}

# Get hostname
$HostName = $env:COMPUTERNAME
Write-Host "Hostname: $HostName" -ForegroundColor Cyan

# Construct addresses
$HostAddressIP = "http://${LocalIP}:8000"
$HostAddressName = "http://${HostName}:8000"

# Output addresses
Write-Host "Starting server at:" -ForegroundColor Green
Write-Host " - $HostAddressIP" -ForegroundColor Cyan
Write-Host " - $HostAddressName" -ForegroundColor Cyan

# Display uvicorn command
Write-Host "Running: python -m uvicorn main:app --host 0.0.0.0 --port 8000" -ForegroundColor Yellow

# Start the server
& .\venv\Scripts\python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000