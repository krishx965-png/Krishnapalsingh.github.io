# Enrolment Power BI — Public Synthetic Demo

All cases, places, schools and values are synthetic. This is a portfolio demonstration, not program results.

Extract the entire folder. Open Enrolment_Status.pbip in standard Power BI Desktop and click Refresh. No external CSV paths, credentials or SQL server required. View > Page view > Fit to width: all sections are on one report page; scroll down.

1 page, 12 KPI cards, 8 charts, 6 detail tables and 39 DAX measures. Filters: district, block and enrolment year. Queue presence is distinct from BO approval and explicit CV completion. Blank quality flags are not failures. Exports overlap and must not be added as enrolment totals.

This demo has 111 union cases, 100 main enrolments, 90 fuzzy records and 11 queue records. Original fuzzy <70 =20; queued =10; outside queue =10. Quality Yes =70; incomplete SR =15. Counts change with filters.

The embedded snapshot is static. Refresh reloads the sample; it does not retrieve operational data. To change samples update data CSVs and run python src/build_project.py, then reopen and Refresh. Native Desktop execution of this public sample has not been tested here. Private counterpart opening and dashboard display were confirmed by the user. No native PBIX is included.
