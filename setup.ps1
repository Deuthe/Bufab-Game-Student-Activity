# Base URL of the GitHub repository
$githubBaseUrl = "https://github.com/Deuthe/Bufab-Game.git"

# Check if Git is installed
try {
    $gitVersionOutput = & git --version 2>&1
    if ($gitVersionOutput -match "git version") {
        Write-Host "Git found: $gitVersionOutput" -ForegroundColor Green
    } else {
        throw "Could not determine Git version."
    }
} catch {
    Write-Host "Error: Git is not installed or not in the PATH." -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/downloads and ensure it's added to your PATH." -ForegroundColor Yellow
    exit 1
}

# Check if Python is installed and meets the minimum version requirement (3.7)
try {
    $pythonVersionOutput = & python --version 2>&1
    if ($pythonVersionOutput -match "Python (\d+\.\d+\.\d+)") {
        $version = $matches[1]
        Write-Host "Python $version found." -ForegroundColor Green
        if ([version]$version -lt [version]"3.7") {
            Write-Host "Error: Python 3.7 or higher is required. Please install a compatible version from python.org." -ForegroundColor Red
            exit 1
        }
    } else {
        throw "Could not determine Python version."
    }
} catch {
    Write-Host "Error: Python is not installed or not in the PATH." -ForegroundColor Red
    Write-Host "Please install Python from https://www.python.org/downloads/ and ensure it's added to your PATH." -ForegroundColor Yellow
    exit 1
}

# Clone the entire repository from GitHub
$repoDir = "Bufab-Game"
if (-not (Test-Path $repoDir)) {
    Write-Host "Cloning the entire repository from $githubBaseUrl..." -ForegroundColor Cyan
    try {
        & git clone $githubBaseUrl
        Write-Host "Repository cloned successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error cloning repository: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Repository directory '$repoDir' already exists. Skipping clone." -ForegroundColor Yellow
}

# Change to the repository directory
Set-Location -Path $repoDir

# Create virtual environment if it doesn’t exist
$venvPath = ".\venv"
if (-not (Test-Path $venvPath)) {
    Write-Host "Creating virtual environment at '$venvPath'..." -ForegroundColor Cyan
    try {
        & python -m venv $venvPath
        Write-Host "Virtual environment created successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error creating virtual environment: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Virtual environment '$venvPath' already exists." -ForegroundColor Yellow
}

# Activate the virtual environment
$activateScript = ".\venv\Scripts\Activate.ps1"
if (Test-Path $activateScript) {
    Write-Host "Activating virtual environment..." -ForegroundColor Cyan
    try {
        & $activateScript
        Write-Host "Virtual environment activated." -ForegroundColor Green
    } catch {
        Write-Host "Error activating virtual environment: $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Error: Activation script not found at $activateScript." -ForegroundColor Red
    Write-Host "Attempting to recreate virtual environment..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $venvPath -ErrorAction SilentlyContinue
    & python -m venv $venvPath
    if (Test-Path $activateScript) {
        & $activateScript
        Write-Host "Virtual environment recreated and activated." -ForegroundColor Green
    } else {
        Write-Host "Error: Still unable to find or activate virtual environment." -ForegroundColor Red
        exit 1
    }
}

# Install dependencies from requirements.txt
Write-Host "Installing dependencies from requirements.txt..." -ForegroundColor Cyan
try {
    & pip install -r requirements.txt
    Write-Host "Dependencies installed successfully." -ForegroundColor Green
} catch {
    Write-Host "Error installing dependencies: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Final success message with instructions
Write-Host "`nSetup completed successfully!" -ForegroundColor Green
Write-Host "The entire Bufab-Game repository has been downloaded." -ForegroundColor Green
Write-Host "To host the application:" -ForegroundColor Yellow
Write-Host "  - Run: .\AutHost.ps1 (if available)" -ForegroundColor Yellow
Write-Host "  - Or manually: python -m uvicorn main:app --host 0.0.0.0 --port 8000" -ForegroundColor Yellow
Write-Host "To deactivate the virtual environment, use: deactivate" -ForegroundColor Yellow