# lsmsd2

## Design

This is a proposal for a new database schema for lsmsd2.

In order to simplify access management, we'll handle access control in this database - but only the authorization part. In a web app, we'll probably use some form of oauth to authenticate users.

### Items

Placeholder scheme for items, changes here are pretty much expected

### Policies

see [initdb.sql](initdb.sql) for documentation

## Performance

Load tests can be done by enabling [fixtures/stress_test.sh](fixtures/stress_test.sh) in `docker-compose.yaml`. This creates a sample dataset of 1000 items.

| # items | naive query (baseline) duration in ms | Policy-aware query duration in ms | policy-aware query with limit = 100 |
|---------|---------------------------------------|-----------------------------------|-------------------------------|
| 1000    | 2                                     | 50                                | 4                             |
| 10000   | 18                                    | 394                               | 4                             |
| 100000  | 14                                    | 3245                              | 4                             |
| 1000000 | 82                                    | 32691                             | 4                             |

This shows that policy-aware query duration scales roughly linear with the number of items, but the duration for the same query with a limit of 100, to the surprise of absolutely nobody, stays constant.