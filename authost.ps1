# Verificar si el venv existe
if (-Not (Test-Path "venv")) {
    Write-Host "Error: El entorno virtual 'venv' no existe."
    Write-Host "Por favor, ejecuta 'setup.ps1' primero para configurarlo."
    exit 1
}

# Activar el venv
Write-Host "Activando el entorno virtual..."
.\venv\Scripts\Activate.ps1

# Hospedar la aplicación
Write-Host "Iniciando el servidor en http://0.0.0.0:8000..."
python -m uvicorn main:app --host 0.0.0.0 --port 8000