FROM python:3.8.0

WORKDIR /opt/app

# Developer-only style install. Lambda is not Docker-deployed.
COPY requirements.txt setup.py ./
RUN pip install --no-cache-dir -r requirements.txt '.[development]'

COPY . ./
