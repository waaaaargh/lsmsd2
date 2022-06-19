#!/usr/bin/env bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "lsmsd" <<-EOSQL
    insert into items(
        name
    )
    select
        left(md5(i::text), 10)
    from generate_series(1, 10000) s(i)
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "lsmsd" <<-EOSQL
    \timing
    select count(*) from items;
    select count(*) from items where(is_user_allowed('waaaaargh', 'read', items.id) = true);
    select * from items where(is_user_allowed('waaaaargh', 'read', items.id) = true) LIMIT 100;
EOSQL
