# 🔩 Bufab Game
![Bufab Logo](https://www.bufabflos.com/wp-content/themes/renewmyid/img/logo-bufab-flos.svg)

A simple guessing game built with **FastAPI** where users can guess how many bolts are in the jar. One submission per device is allowed — no cheating! 😏

Based on the Flipper Zero Evil Portals

---

## 🚀 Features

- Fast and lightweight backend using **FastAPI**
- IP + ID based submission validation (one guess per user/device)
- Submissions stored in a **CSV** file
- Fun visual feedback for double submissions
- Easy setup script to install and configure everything

---

## 📁 Folder Structure

📦 Bufab-Game/

 ├── main.py # FastAPI app 

 ├── requirements.txt # Python dependencies

 ├── guesses.csv # Generated at runtime 

 ├── static/ 

 │ └── index.html # Main game page 

 ├── images/ 

 │ └── logo.png # Logo and warning image(s) 

 └── setup.ps1 # Powershell automation script


---

## ⚙️ Quick Setup (Windows + PowerShell)

Just open PowerShell and run:

```powershell
.\setup.ps1
```
This will:
  -Check your Python version (3.7+ required)
  -Download necessary files from GitHub
  -Set up a virtual environment
  -Install all dependencies
  -Prompt how to run the server


To host the app after setup:
  .\AutHost.ps1

Or run manually:

python -m uvicorn main:app --host 0.0.0.0 --port 8000

--- 

## 🛠 Manual Setup
If you want to do it manually:

git clone https://github.com/Deuthe/Bufab-Game.git
cd Bufab-Game
python -m venv venv
source venv/bin/activate   # Or .\venv\Scripts\activate on Windows
pip install -r requirements.txt
python -m uvicorn main:app --host 0.0.0.0 --port 8000

---

## 🌐 Access
Once the app is running, visit:

http://localhost:8000
The game will be served from static/index.html, and all static files (images, CSS) will be properly loaded from the /static and /images mounts.

---

## 📦 Dependencies
  Python 3.7+
  FastAPI
  Uvicorn
  Pydantic
Install with:

pip install -r requirements.txt

---

## 🤝 Contributing
If you're working in a team or plan to open this up:

Fork the repo

Create a new branch

Submit a pull request!

---

## 💡 Notes
Duplicate submissions are blocked using IP + ID.

Submissions are stored in guesses.csv in the project root.

All form validation is handled server-side.

Make sure to update the $githubBaseUrl in setup.ps1 if your repo URL changes.
