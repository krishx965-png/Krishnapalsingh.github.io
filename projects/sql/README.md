# SQL Enrolment Data Quality Project

Public portfolio case study by Krishnapal Singh Chauhan.

## Scope

One analytical project in four database dialects: SQLite, MySQL, PostgreSQL and SQL Server. It contains five related tables, three reporting views, five indexes and 18 queries.

The public dataset is wholly fictitious: 111 case-registry rows, 100 main-enrolment rows, 90 fuzzy-export rows and 11 verification-queue rows. District A/B, Demo Block/Cluster/Village/School and DEMO case IDs do not identify real people or institutions.

Original-score <70 cases: 20. Of these, ten are in the queue and ten are outside it. Synthetic completed-CV and approval values exist only to illustrate workflow states; they are not operational results.

## Questions answered

Source populations, district status, quality/SR rates, low-fuzzy queue coverage, BO workflow, score bands, original/new score comparison, source intersections, anti-join follow-ups, missing quality flags, block ranking, action cases, admission months, current-year proxy, flag mismatch, explicit CV completion, duplicates and orphan references.

## SQL skills demonstrated

Schema design, primary/foreign keys, CHECK constraints, indexes, LEFT JOIN, NOT EXISTS, UNION ALL, conditional aggregation, CTEs, DENSE_RANK, guarded division and reusable views.

## Run it

Choose a database dialect folder and a new empty database. Run 01_schema.sql → 02_seed.sql → 03_views.sql → 04_queries.sql → 05_validation.sql. Each folder README specifies versions and client requirements. SQL Server views contain GO batch separators and should be run through SSMS/sqlcmd.

The browser explorer displays saved results from actual SQLite execution. It does not run arbitrary SQL in the browser. Query code remains downloadable for local execution.

## Validation

All 18 queries were executed in SQLite, along with integrity, foreign-key and control-total checks. The three other dialects have not been executed against native servers. Private operational-data control checks are not published here.

## References

SQLite foreign keys: https://www.sqlite.org/foreignkeys.html
SQLite window functions: https://www.sqlite.org/windowfunctions.html
MySQL CTEs: https://dev.mysql.com/doc/refman/8.0/en/with.html
PostgreSQL views: https://www.postgresql.org/docs/14/sql-createview.html
SQL Server CREATE VIEW: https://learn.microsoft.com/en-us/sql/t-sql/statements/create-view-transact-sql
