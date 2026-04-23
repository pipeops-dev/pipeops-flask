# =============================================================================
# Stage 1: Build dependencies
# =============================================================================
FROM python:3.11-slim AS builder

WORKDIR /build

# Install pip-tools for better dependency management
RUN pip install --no-cache-dir pip-tools

# Copy only dependency file first for better layer caching
COPY requirements.txt .

# Compile dependencies into constraints file
RUN pip-compile --output-file constraints.txt requirements.txt

# Install dependencies into isolated environment
RUN pip install --no-cache-dir --prefix /install -r constraints.txt

# =============================================================================
# Stage 2: Production image
# =============================================================================
FROM python:3.11-slim AS production

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Create non-root user for security
RUN groupadd --gid 1000 appgroup && \
    useradd --uid 1000 --gid appgroup --shell /bin/bash --create-home appuser

# Copy installed dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application code
COPY --chown=appuser:appgroup main.py .

# Switch to non-root user
USER appuser

# Expose the port (Flask default or PORT env var)
EXPOSE 5000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/')" || exit 1

# Run with gunicorn for production (using multiple workers)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "4", "main:app"]