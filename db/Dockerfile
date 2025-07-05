FROM postgres:15-alpine

# Install additional extensions and tools
RUN apk add --no-cache \
    postgresql-contrib \
    curl \
    wget

# Copy initialization scripts
COPY init/ /docker-entrypoint-initdb.d/

# Set environment variables
ENV POSTGRES_INITDB_ARGS="--encoding=UTF-8 --lc-collate=en_US.UTF-8 --lc-ctype=en_US.UTF-8"

# Expose port
EXPOSE 5432

# Add health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB
