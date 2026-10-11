# mysql version

Run 01_schema.sql, 02_seed.sql, 03_views.sql, then 04_queries.sql in a new empty database. Existing tables are never dropped by the scripts.
Requires MySQL 8.0.16+ for enforced CHECK constraints and window functions. Create a dedicated database with utf8mb4 and use it before running the scripts.

Validation: SQLite executes all queries in this package. Other engine dialects have not been run against native database servers in this environment.
