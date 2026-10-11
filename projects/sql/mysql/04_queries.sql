-- Q01 Source populations
-- Keep overlapping export counts separate.
SELECT COUNT(*) AS case_universe, SUM(in_main) AS main_records, SUM(in_fuzzy) AS fuzzy_records, SUM(in_queue) AS queue_records FROM v_case_status;

-- Q02 District status
-- Compare each district using the same definitions.
SELECT * FROM v_district_status ORDER BY district;

-- Q03 Quality and SR rates
-- Blank quality flags are not recorded, not failures.
SELECT district, main_enrolments, quality_yes, ROUND(100.0*quality_yes/NULLIF(main_enrolments,0),1) AS quality_flag_pct, incomplete_sr, ROUND(100.0*incomplete_sr/NULLIF(main_enrolments,0),1) AS incomplete_sr_pct FROM v_district_status ORDER BY district;

-- Q04 Low fuzzy queue coverage
-- Only low original-score IDs actually in queue belong in the numerator.
SELECT district, low_original, low_original_queued, low_original_not_queued, ROUND(100.0*low_original_queued/NULLIF(low_original,0),1) AS queue_coverage_pct FROM v_district_status ORDER BY district;

-- Q05 BO workflow status
-- Queue membership and approval are distinct from completed CV.
SELECT district, bo_status, COUNT(*) AS cases FROM v_case_status WHERE in_queue=1 GROUP BY district, bo_status ORDER BY district, bo_status;

-- Q06 Score distribution
-- Original fuzzy export population; missing scores retain their own category.
WITH bands AS (SELECT district, CASE WHEN fuzzy_original_score IS NULL THEN 'Missing' WHEN fuzzy_original_score<30 THEN '<30' WHEN fuzzy_original_score<70 THEN '30-69' WHEN fuzzy_original_score<100 THEN '70-99' ELSE '100' END AS score_band FROM v_case_status WHERE in_fuzzy=1) SELECT district, score_band, COUNT(*) AS cases FROM bands GROUP BY district, score_band ORDER BY district, score_band;

-- Q07 Original versus new scores
-- Different score methods, not a historical trend.
SELECT district, SUM(CASE WHEN fuzzy_original_score<70 THEN 1 ELSE 0 END) AS low_original, SUM(CASE WHEN fuzzy_new_score<70 THEN 1 ELSE 0 END) AS low_new, ROUND(AVG(fuzzy_original_score),1) AS avg_original, ROUND(AVG(fuzzy_new_score),1) AS avg_new FROM v_case_status WHERE in_fuzzy=1 GROUP BY district ORDER BY district;

-- Q08 Source intersections
-- Reconcile overlaps before building enrolment totals.
SELECT SUM(CASE WHEN in_main=1 AND in_fuzzy=1 THEN 1 ELSE 0 END) AS main_and_fuzzy, SUM(CASE WHEN in_main=1 AND in_fuzzy=0 THEN 1 ELSE 0 END) AS main_outside_fuzzy, SUM(CASE WHEN in_main=0 AND in_fuzzy=1 THEN 1 ELSE 0 END) AS fuzzy_outside_main, SUM(CASE WHEN in_main=1 AND in_queue=1 THEN 1 ELSE 0 END) AS queue_and_main, SUM(CASE WHEN in_main=0 AND in_queue=1 THEN 1 ELSE 0 END) AS queue_outside_main FROM v_case_status;

-- Q09 Low fuzzy outside queue
-- Anti-join pattern identifies follow-up cases.
SELECT c.case_id, l.district, l.block_name, l.cluster_name, f.original_score FROM fuzzy_matches f JOIN case_registry c ON c.case_id=f.case_id JOIN locations l ON l.location_key=c.location_key WHERE f.original_score<70 AND NOT EXISTS (SELECT 1 FROM verification_queue q WHERE q.case_id=f.case_id) ORDER BY l.district, l.block_name, c.case_id;

-- Q10 Quality missing by block
-- Missing quality flags need reconciliation, not automatic rejection.
SELECT district, block_name, COUNT(*) AS main_records, SUM(CASE WHEN quality_status='Not recorded' THEN 1 ELSE 0 END) AS quality_missing FROM v_case_status WHERE in_main=1 GROUP BY district, block_name ORDER BY district, block_name;

-- Q11 Rank follow-up blocks
-- DENSE_RANK preserves ties within each district.
WITH block_actions AS (SELECT district, block_name, COUNT(*) AS action_cases FROM v_priority_cases WHERE priority<3 GROUP BY district, block_name) SELECT district, block_name, action_cases, DENSE_RANK() OVER (PARTITION BY district ORDER BY action_cases DESC) AS priority_rank FROM block_actions ORDER BY district, priority_rank, block_name;

-- Q12 Private action list
-- Cases retain stable pseudonymous IDs for safe analysis.
SELECT * FROM v_priority_cases WHERE priority<3 ORDER BY priority, district, block_name, case_id;

-- Q13 Enrolment by admission month
-- Admission dates do not imply verification-completion progress.
SELECT district, admission_month, COUNT(*) AS main_enrolments FROM v_case_status WHERE in_main=1 GROUP BY district, admission_month ORDER BY district, admission_month;

-- Q14 Current-year quality proxy
-- The proxy is a reconciliation check; it does not overwrite the supplied flag.
SELECT district, COUNT(*) AS current_main, SUM(CASE WHEN quality_status='Yes' THEN 1 ELSE 0 END) AS quality_flag_yes, SUM(current_eligibility_proxy) AS eligibility_proxy FROM v_case_status WHERE in_main=1 AND enrolment_year='2026-2027' GROUP BY district ORDER BY district;

-- Q15 Eligibility flag mismatch
-- Find records meeting the available proxy but not marked Yes.
SELECT case_id, district, block_name, sr_status, quality_status FROM v_case_status WHERE in_main=1 AND current_eligibility_proxy=1 AND quality_status<>'Yes' ORDER BY district, case_id;

-- Q16 Explicit CV completion
-- Count only explicit Yes fields; no unknown status is treated as completion.
SELECT district, SUM(CASE WHEN in_main=1 AND main_cv_status='Yes' THEN 1 ELSE 0 END) AS completed_cv_main, SUM(CASE WHEN in_queue=1 AND queue_cv_status='Yes' THEN 1 ELSE 0 END) AS completed_cv_queue FROM v_case_status GROUP BY district ORDER BY district;

-- Q17 Duplicate source IDs
-- Primary keys reject duplicate inserts; this check should return no rows.
SELECT 'enrolments' AS source, case_id, COUNT(*) AS row_count FROM enrolments GROUP BY case_id HAVING COUNT(*)>1 UNION ALL SELECT 'fuzzy_matches', case_id, COUNT(*) FROM fuzzy_matches GROUP BY case_id HAVING COUNT(*)>1 UNION ALL SELECT 'verification_queue', case_id, COUNT(*) FROM verification_queue GROUP BY case_id HAVING COUNT(*)>1;

-- Q18 Missing case references
-- Foreign keys enforce this relationship; the audit should return no rows.
SELECT 'enrolments' AS source, e.case_id FROM enrolments e LEFT JOIN case_registry c ON e.case_id=c.case_id WHERE c.case_id IS NULL UNION ALL SELECT 'fuzzy_matches', f.case_id FROM fuzzy_matches f LEFT JOIN case_registry c ON f.case_id=c.case_id WHERE c.case_id IS NULL UNION ALL SELECT 'verification_queue', q.case_id FROM verification_queue q LEFT JOIN case_registry c ON q.case_id=c.case_id WHERE c.case_id IS NULL;