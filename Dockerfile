# Python 3.12 is required by the pinned scientific stack (numpy 2.5, scipy 1.18,
# torch 2.15), which no longer ships wheels for Python 3.9.
FROM python:3.12-slim

WORKDIR /app

# Install dependencies first to keep the Docker layer cache warm.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Render sets PORT (default 10000); the dashboard's Docker Command overrides
# this CMD, but keep it correct so the image also runs standalone.
ENV PORT=10000
EXPOSE 10000

CMD ["sh", "-c", "gunicorn -w 2 -b 0.0.0.0:${PORT:-10000} main_app:server"]
