FROM python:3.11-slim

WORKDIR /app

# Copy dependencies first for better layer caching
COPY source-code/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY source-code/ .

# Run as non-root user for security
RUN useradd -m appuser
USER appuser

EXPOSE 5000

# Health check so Kubernetes probes have an endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')"

# Use gunicorn for production (not Flask dev server)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
