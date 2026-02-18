FROM python:3.10-slim

WORKDIR /app

RUN pip install poetry

 
ENV POETRY_VIRTUALENVS_CREATE=false

COPY pyproject.toml poetry.lock* ./
RUN poetry install --no-interaction --no-ansi --no-root



COPY src ./src
COPY tests ./tests


EXPOSE 5000


ENV FLASK_APP=src.app
CMD ["poetry", "run", "flask", "run", "--host=0.0.0.0"]

