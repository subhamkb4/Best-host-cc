# Use an official Python runtime as a base image
FROM python:3.11-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV TOKEN="8209469146:AAEUMcuSBfC8NYxChFK0dQL-cnPVrqLdX1I"
ENV OWNER_ID=7896890222
ENV CHANNEL_USERNAME="@wiz_x_chk"

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Create and set permissions for database
RUN touch users.db && \
    chmod 666 users.db

# Create a non-root user (optional but recommended for security)
RUN useradd -m -r botuser && \
    chown -R botuser:botuser /app
USER botuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import sqlite3; conn = sqlite3.connect('users.db'); conn.close(); print('DB healthy')" || exit 1

# Run the bot
CMD ["python", "subham.py"]
