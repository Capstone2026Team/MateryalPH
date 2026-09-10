#!/usr/bin/env sh
set -eu

test_database="${POSTGRES_TEST_DB:-materyalph_test}"

if psql --username "$POSTGRES_USER" --dbname postgres --tuples-only --no-align \
  --command "SELECT 1 FROM pg_database WHERE datname = '$test_database'" | grep --quiet '^1$'; then
  exit 0
fi

createdb \
  --username "$POSTGRES_USER" \
  --owner "$POSTGRES_USER" \
  "$test_database"
