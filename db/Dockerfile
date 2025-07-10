FROM postgres:${POSTGRES_VERSION:-17-alpine}

# Set environment variables for PostgreSQL configuration
ENV POSTGRES_PASSWORD_ENCRYPTION=scram-sha-256
ENV POSTGRES_INITDB_ARGS="--auth-host=scram-sha-256 --auth-local=scram-sha-256 --encoding=UTF8 --locale=en_US.UTF-8"

# Install necessary packages
RUN apk add --no-cache tzdata

# Copy custom configuration
COPY postgresql.conf /etc/postgresql/postgresql.conf

# Use custom configuration
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

# Health check
HEALTHCHECK --interval=10s --timeout=5s --retries=3 \
  CMD pg_isready -U ${POSTGRES_USER:-postgres_admin} -d ${POSTGRES_DB:-postgres_ai} || exit 1
