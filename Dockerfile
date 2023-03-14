FROM python:3.8-slim

ENV PYTHON_VENV=/app/.venv

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get -qq update \
    && apt-get -qq install --no-install-recommends \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# RUN python3 -m venv $PYTHON_VENV \
#     && $PYTHON_VENV/bin/pip install -U pip setuptools \
#     && $PYTHON_VENV/bin/pip install poetry

RUN python3 -m venv $PYTHON_VENV 

ENV PATH="${PATH}:${PYTHON_VENV}/bin"

WORKDIR /app

COPY . /app

RUN $PYTHON_VENV/bin/pip install -r requirements.txt

#RUN poetry config virtualenvs.in-project true
#RUN poetry install

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:9000", "--workers", "1", "--timeout", "0", "app.webservice:app", "-k", "uvicorn.workers.UvicornWorker"]