# Multi-stage build for frontend and backend

# Stage 1: Build frontend with Create React App
FROM node:18-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY frontend/package*.json ./
RUN npm install

# Copy frontend source
COPY frontend/ ./
RUN npm run build

# Stage 2: Node.js runtime with Python for backend
FROM python:3.11-slim

WORKDIR /app

# Install Python and ffmpeg for backend
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install Poetry for Python dependencies
ENV POETRY_VERSION=1.6.1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1 \
    POETRY_VIRTUALENVS_CREATE=false \
    POETRY_CACHE_DIR=/tmp/poetry_cache \
    PIP_BREAK_SYSTEM_PACKAGES=1

ENV PATH="$POETRY_HOME/bin:$PATH"

# Install poetry
RUN pip install --break-system-packages "poetry==$POETRY_VERSION"

# Copy Python dependencies
COPY pyproject.toml poetry.lock ./

# Install Python dependencies (without dev dependencies)
RUN --mount=type=cache,target=$POETRY_CACHE_DIR \
    poetry install --only main --no-root

# Copy backend and CLI code
COPY backend/ backend/

# Create frontend directory structure that backend expects
RUN mkdir -p frontend

# Copy built frontend from first stage to the expected frontend directory
COPY --from=frontend-builder /app/build frontend/build
COPY --from=frontend-builder /app/package.json frontend/package.json

# Set default port (Cloud Run will override this with PORT env var)
ENV PORT=3000

# Expose the port that the app runs on
EXPOSE $PORT

# Start the application
# CMD ["/app/start.sh"]
CMD ["sh", "-c", "poetry run uvicorn backend.main:app --host 0.0.0.0 --port ${PORT}"]

