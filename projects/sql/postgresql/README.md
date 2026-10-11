# postgresql version

Run 01_schema.sql, 02_seed.sql, 03_views.sql, then 04_queries.sql in a new empty database. Existing tables are never dropped by the scripts.
Designed for PostgreSQL 14+. Use a dedicated database/schema; run with psql or your SQL client.

Validation: SQLite executes all queries in this package. Other engine dialects have not been run against native database servers in this environment.
