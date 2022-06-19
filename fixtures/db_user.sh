#!/usr/bin/env sh
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
	CREATE USER lsmsd;
	CREATE DATABASE lsmsd;
	GRANT ALL PRIVILEGES ON DATABASE lsmsd TO lsmsd;
EOSQL
