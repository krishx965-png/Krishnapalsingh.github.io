WITH checks AS (
SELECT 'Main records' AS metric, (SELECT COUNT(*) FROM enrolments) AS actual, 100 AS expected
UNION ALL
SELECT 'Fuzzy records' AS metric, (SELECT COUNT(*) FROM fuzzy_matches) AS actual, 90 AS expected
UNION ALL
SELECT 'Queue records' AS metric, (SELECT COUNT(*) FROM verification_queue) AS actual, 11 AS expected
UNION ALL
SELECT 'Union cases' AS metric, (SELECT COUNT(*) FROM case_registry) AS actual, 111 AS expected
UNION ALL
SELECT 'Original low fuzzy' AS metric, (SELECT COUNT(*) FROM fuzzy_matches WHERE original_score<70) AS actual, 20 AS expected
UNION ALL
SELECT 'Low fuzzy in queue' AS metric, (SELECT COUNT(*) FROM fuzzy_matches f JOIN verification_queue q ON f.case_id=q.case_id WHERE f.original_score<70) AS actual, 10 AS expected
)
SELECT metric, actual, expected, CASE WHEN actual=expected THEN 'PASS' ELSE 'FAIL' END AS check_status FROM checks;
