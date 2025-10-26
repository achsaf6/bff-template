# Multi-stage build for frontend and backend

# Stage 1: Build frontend with Vite
FROM node:18-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY frontend/package*.json ./
RUN npm ci

# Copy frontend source
COPY frontend/ ./
RUN npm run build

# Stage 2: Node.js runtime with Python for backend
FROM python:3.11-slim

WORKDIR /app

# Install Python and ffmpeg for backend
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Install uv for Python dependency management
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Copy Python dependencies
COPY pyproject.toml uv.lock ./

# Install Python dependencies (without dev dependencies)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy backend and CLI code
COPY backend/ backend/

# Create frontend directory structure that backend expects
RUN mkdir -p frontend

# Copy built frontend from first stage to the expected frontend directory (Vite outputs to dist/)
COPY --from=frontend-builder /app/dist frontend/build
COPY --from=frontend-builder /app/package.json frontend/package.json

# Set default port (Cloud Run will override this with PORT env var)
ENV PORT=3000

# Expose the port that the app runs on
EXPOSE $PORT

# Start the application
# CMD ["/app/start.sh"]
CMD ["sh", "-c", "uv run uvicorn backend.main:app --host 0.0.0.0 --port ${PORT}"]

