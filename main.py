from fastapi import FastAPI, Form, HTTPException, Request
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
import csv
import os
from pydantic import BaseModel
from typing import Dict

app = FastAPI()

# Montar carpetas estáticas
app.mount("/static", StaticFiles(directory="static"), name="static")
app.mount("/images", StaticFiles(directory="images"), name="images")

# File to store guesses
CSV_FILE = "guesses.csv"

# In-memory store to track submissions (IP + ID)
submitted_entries: Dict[str, bool] = {}

# Initialize CSV file with headers if it doesn't exist
if not os.path.exists(CSV_FILE):
    with open(CSV_FILE, mode="w", newline="") as file:
        writer = csv.writer(file)
        writer.writerow(["Name", "IP", "ID", "Guess"])

# Model for validation
class Guess(BaseModel):
    name: str
    id: str
    guess: int

@app.get("/", response_class=HTMLResponse)
async def home():
    with open("static/index.html", "r") as f:
        return HTMLResponse(content=f.read())

@app.post("/submit")
async def submit_guess(request: Request, name: str = Form(...), id: str = Form(...), guess: int = Form(...)):
    # Obtener la IP del cliente
    client_ip = request.client.host

    # Crear una clave única combinando IP e ID
    unique_key = f"{client_ip}:{id}"

    # Validate uniqueness
    if unique_key in submitted_entries:
        raise HTTPException(status_code=400, detail="This device has already submitted a guess with this ID!")
    
    # Validate guess (positive number)
    if guess <= 0:
        raise HTTPException(status_code=400, detail="Guess must be a positive number!")
    
    # Store the guess in CSV
    with open(CSV_FILE, mode="a", newline="") as file:
        writer = csv.writer(file)
        writer.writerow([name, client_ip, id, guess])
    
    # Mark entry as used
    submitted_entries[unique_key] = True
    
    return {"message": f"Thank you, {name}! Your guess of {guess} bolts has been recorded."}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)