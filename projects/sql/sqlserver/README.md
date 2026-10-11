# sqlserver version

Run 01_schema.sql, 02_seed.sql, 03_views.sql, then 04_queries.sql in a new empty database. Existing tables are never dropped by the scripts.
Designed for SQL Server 2019+. Run views through SSMS/sqlcmd: GO separates each CREATE VIEW batch. GO is a client batch separator, not an SQL statement.

Validation: SQLite executes all queries in this package. Other engine dialects have not been run against native database servers in this environment.
