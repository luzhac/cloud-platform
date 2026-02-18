---

# 📦 Poetry Setup Guide

## 1️⃣ Install Poetry (if not installed)

```bash
curl -sSL https://install.python-poetry.org | python3 -
```

Verify:

```bash
poetry --version
```

---

# 🚀 2️⃣ Initialise Poetry Project

If starting from scratch:

```bash
poetry init
```

Follow interactive prompts.

Or initialise automatically:

```bash
poetry init --no-interaction
```

This creates:

```
pyproject.toml
```

---

# 📥 3️⃣ Add Required Dependencies (FastAPI Version)

```bash
poetry add fastapi uvicorn boto3 python-multipart pytest
```

If you previously had Flask, remove it:

```bash
poetry remove Flask flask-swagger-ui
```

---

# 🛠 4️⃣ Install Dependencies

If `pyproject.toml` already exists:

```bash
poetry install
```

This creates:

```
poetry.lock
```

---

# 🐍 5️⃣ Activate Poetry Shell

```bash
poetry shell
```

Now your virtual environment is active.

To exit:

```bash
exit
```

---

# ▶ 6️⃣ Run the FastAPI Application

Without activating shell:

```bash
poetry run uvicorn src.main:app --reload
```

Or inside poetry shell:

```bash
uvicorn src.main:app --reload
```

Open browser:

```
http://localhost:8000/docs
```

Swagger UI will appear automatically.

---

# 🧹 7️⃣ Update Lock File

After changing dependencies:

```bash
poetry lock
```

Or reinstall everything:

```bash
poetry install
```

---

# 📤 8️⃣ Export Requirements (Optional for Docker)

If your Dockerfile expects requirements.txt:

```bash
poetry export -f requirements.txt --output requirements.txt --without-hashes
```

---

# 🧪 9️⃣ Add Dev Dependencies (Optional)

For testing:

```bash
poetry add --group dev pytest
```

Run tests:

```bash
poetry run pytest
```

---

# 🔍 10️⃣ Show Installed Packages

```bash
poetry show
```

---

# 🧠 Project Structure Example

```
project-root/
│
├── src/
│   ├── main.py
│   ├── s3_service.py
│   └── dynamo_repository.py
│
├── pyproject.toml
├── poetry.lock
└── README.md
```

---

# 🎯 Recommended Python Version

Make sure your pyproject includes:

```toml
[tool.poetry.dependencies]
python = "^3.10"
```

---

