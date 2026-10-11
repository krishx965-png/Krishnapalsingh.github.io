# sqlite version

Run 01_schema.sql, 02_seed.sql, 03_views.sql, then 04_queries.sql in a new empty database. Existing tables are never dropped by the scripts.
SQLite 3.25+ is required for the window query. Enable PRAGMA foreign_keys=ON on each connection. Open the included .sqlite file directly or rebuild it with the scripts.

Validation: SQLite executes all queries in this package. Other engine dialects have not been run against native database servers in this environment.
