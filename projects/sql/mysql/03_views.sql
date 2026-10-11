CREATE VIEW v_case_status AS
SELECT c.case_id, c.enrolment_year, c.admission_month, l.district, l.block_name, l.cluster_name, l.village_name, l.school_name,
 CASE WHEN e.case_id IS NOT NULL THEN 1 ELSE 0 END AS in_main,
 CASE WHEN f.case_id IS NOT NULL THEN 1 ELSE 0 END AS in_fuzzy,
 CASE WHEN q.case_id IS NOT NULL THEN 1 ELSE 0 END AS in_queue,
 e.sr_status, e.quality_status, e.cv_status AS main_cv_status,
 f.original_score AS fuzzy_original_score, f.new_score AS fuzzy_new_score,
 e.original_score AS main_original_score, e.new_score AS main_new_score,
 q.bo_status, q.io_status, q.cv_status AS queue_cv_status,
 e.operational_school, e.no_contact, e.age_gap3, e.current_eligibility_proxy
FROM case_registry c JOIN locations l ON c.location_key = l.location_key
LEFT JOIN enrolments e ON c.case_id=e.case_id
LEFT JOIN fuzzy_matches f ON c.case_id=f.case_id
LEFT JOIN verification_queue q ON c.case_id=q.case_id;

CREATE VIEW v_district_status AS
SELECT district, SUM(in_main) AS main_enrolments, SUM(in_fuzzy) AS fuzzy_cases, SUM(in_queue) AS queue_cases,
 SUM(CASE WHEN in_main=1 AND quality_status='Yes' THEN 1 ELSE 0 END) AS quality_yes,
 SUM(CASE WHEN in_main=1 AND sr_status='Incomplete SR' THEN 1 ELSE 0 END) AS incomplete_sr,
 SUM(CASE WHEN in_fuzzy=1 AND fuzzy_original_score<70 THEN 1 ELSE 0 END) AS low_original,
 SUM(CASE WHEN in_fuzzy=1 AND fuzzy_original_score<70 AND in_queue=1 THEN 1 ELSE 0 END) AS low_original_queued,
 SUM(CASE WHEN in_fuzzy=1 AND fuzzy_original_score<70 AND in_queue=0 THEN 1 ELSE 0 END) AS low_original_not_queued,
 SUM(CASE WHEN in_main=1 AND main_cv_status='Yes' THEN 1 ELSE 0 END) AS completed_cv_main
FROM v_case_status GROUP BY district;

CREATE VIEW v_priority_cases AS
SELECT case_id, district, block_name, cluster_name, enrolment_year,
 fuzzy_original_score, bo_status,
 CASE WHEN bo_status='Unmatch' THEN 'Reconcile BO unmatch'
 WHEN bo_status='Pending for Approval/Rejection' THEN 'BO approval pending'
 WHEN in_fuzzy=1 AND fuzzy_original_score<70 AND in_queue=0 THEN 'Low original score: not in queue'
 WHEN in_main=1 AND sr_status='Incomplete SR' THEN 'Complete SR'
 WHEN in_main=1 AND current_eligibility_proxy=1 AND quality_status<>'Yes' THEN 'Review eligibility flag'
 ELSE 'Routine review' END AS action,
 CASE WHEN bo_status IN ('Unmatch','Pending for Approval/Rejection') OR (in_fuzzy=1 AND fuzzy_original_score<70 AND in_queue=0) THEN 1
 WHEN in_main=1 AND (sr_status='Incomplete SR' OR (current_eligibility_proxy=1 AND quality_status<>'Yes')) THEN 2 ELSE 3 END AS priority
FROM v_case_status;
