#!/usr/bin/env bash
set -x
set -eo pipefail

if ! [ -x "$(command -v psql)" ]; then
    echo 'Error: psql is not installed.' >&2
    exit 1
fi

if ! [ -x "$(command -v sqlx)" ]; then
    echo 'Error: sqlx is not installed.' >&2
    echo 'Run `cargo install sqlx-cli --no-default-features --features rustls,postgres` to install it.'
    exit 1
fi

DB_USER=${DB_USER:=postgres}
DB_PASSWORD="${DB_PASSWORD:=password}"

DB_NAME="${DB_NAME:=newsletter}"

DB_PORT="${DB_PORT:=5432}"

DATABASE_URL="postgres://${DB_USER}:${DB_PASSWORD}@localhost:${DB_PORT}/${DB_NAME}"

if [[ -z "${SKIP_DOCKER}" ]]
then
    # Start the database
    docker run \
        -e POSTGRES_USER="${DB_USER}" \
        -e POSTGRES_PASSWORD="${DB_PASSWORD}" \
        -e POSTGRES_DB="${DB_NAME}" \
        -p "${DB_PORT}":5432 \
        -d postgres \
        postgres -N 1000
fi

export PGPASSWORD="${DB_PASSWORD}"
until psql -h localhost -U "${DB_USER}" -p "${DB_PORT}" -d "postgres" -c '\q'; do
    >&2 echo "Postgres is unavailable - sleeping"
    sleep 1
done

# Create the database with SQLx
export DATABASE_URL
sqlx database create
# Apply the migrations
sqlx migrate run

>&2 echo "Postgres is up and migrations have been applied."