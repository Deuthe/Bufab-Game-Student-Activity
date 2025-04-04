# URL base del repositorio de GitHub (cámbialo por tu enlace real)
$githubBaseUrl = "https://raw.githubusercontent.com/tu-usuario/tu-repositorio/main"

# Archivos a descargar
$filesToDownload = @{
    "main.py" = "$githubBaseUrl/main.py"
    "static/index.html" = "$githubBaseUrl/static/index.html"
    "images/logo.png" = "$githubBaseUrl/images/logo.png"
    "requirements.txt" = "$githubBaseUrl/requirements.txt"
}

# Verificar si Python está instalado y su versión
try {
    $pythonVersion = & python --version 2>&1
    if ($pythonVersion -match "Python (\d+\.\d+\.\d+)") {
        $version = $matches[1]
        Write-Host "Python $version encontrado."
        if ([version]$version -lt [version]"3.7") {
            Write-Host "Error: Se requiere Python 3.7 o superior. Por favor, instala una versión compatible desde python.org."
            exit 1
        }
    } else {
        throw "No se pudo determinar la versión de Python."
    }
} catch {
    Write-Host "Error: Python no está instalado o no está en el PATH."
    Write-Host "Por favor, instala Python desde https://www.python.org/downloads/ y asegúrate de agregar Python al PATH."
    exit 1
}

# Crear directorios si no existen
if (-Not (Test-Path "static")) { New-Item -ItemType Directory -Path "static" | Out-Null }
if (-Not (Test-Path "images")) { New-Item -ItemType Directory -Path "images" | Out-Null }

# Descargar archivos desde GitHub
foreach ($file in $filesToDownload.Keys) {
    $url = $filesToDownload[$file]
    Write-Host "Descargando $file desde $url..."
    try {
        Invoke-WebRequest -Uri $url -OutFile $file -ErrorAction Stop
    } catch {
        Write-Host "Error al descargar $file : $_"
        exit 1
    }
}

# Crear el venv si no existe
if (-Not (Test-Path "venv")) {
    Write-Host "Creando entorno virtual 'venv'..."
    python -m venv venv
} else {
    Write-Host "El entorno virtual 'venv' ya existe."
}

# Activar el venv
Write-Host "Activando el entorno virtual..."
.\venv\Scripts\Activate.ps1

# Instalar dependencias
Write-Host "Instalando dependencias desde requirements.txt..."
pip install -r requirements.txt

# Mensaje final
Write-Host "Entorno virtual creado y configurado exitosamente."
Write-Host "Los archivos se han descargado desde GitHub."
Write-Host "Para hospedar la aplicación, ejecuta: .\AutHost.ps1"
Write-Host "O manualmente: python -m uvicorn main:app --host 0.0.0.0 --port 8000"
Write-Host "Para desactivar el entorno virtual, usa: deactivate"