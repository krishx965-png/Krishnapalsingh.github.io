-- First-run script. Use a new empty database.
CREATE TABLE locations (location_key VARCHAR(40) PRIMARY KEY, district VARCHAR(160) NOT NULL, block_name VARCHAR(160) NOT NULL, cluster_name VARCHAR(160) NOT NULL, village_name VARCHAR(160) NOT NULL, school_name VARCHAR(250) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE case_registry (case_id VARCHAR(40) PRIMARY KEY, location_key VARCHAR(40) NOT NULL, enrolment_year VARCHAR(20) NOT NULL, admission_month VARCHAR(20) NOT NULL, FOREIGN KEY (location_key) REFERENCES locations(location_key)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE enrolments (case_id VARCHAR(40) PRIMARY KEY, sr_status VARCHAR(160) NOT NULL, quality_status VARCHAR(30) NOT NULL CHECK (quality_status IN ('Yes','No','Not recorded')), cv_status VARCHAR(30) NOT NULL, original_score DECIMAL(5,2) NULL CHECK (original_score IS NULL OR original_score BETWEEN 0 AND 100), new_score DECIMAL(5,2) NULL CHECK (new_score IS NULL OR new_score BETWEEN 0 AND 100), operational_school INT NOT NULL CHECK (operational_school IN (0,1)), no_contact INT NOT NULL CHECK (no_contact IN (0,1)), age_gap3 INT NOT NULL CHECK (age_gap3 IN (0,1)), current_eligibility_proxy INT NOT NULL CHECK (current_eligibility_proxy IN (0,1)), FOREIGN KEY (case_id) REFERENCES case_registry(case_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE fuzzy_matches (case_id VARCHAR(40) PRIMARY KEY, original_score DECIMAL(5,2) NULL CHECK (original_score IS NULL OR original_score BETWEEN 0 AND 100), new_score DECIMAL(5,2) NULL CHECK (new_score IS NULL OR new_score BETWEEN 0 AND 100), FOREIGN KEY (case_id) REFERENCES case_registry(case_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE TABLE verification_queue (case_id VARCHAR(40) PRIMARY KEY, bo_status VARCHAR(160) NOT NULL, io_status VARCHAR(160) NOT NULL, cv_status VARCHAR(30) NOT NULL, FOREIGN KEY (case_id) REFERENCES case_registry(case_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

CREATE INDEX ix_cases_location ON case_registry(location_key);
CREATE INDEX ix_cases_year ON case_registry(enrolment_year);
CREATE INDEX ix_enrolments_status ON enrolments(sr_status);
CREATE INDEX ix_fuzzy_original ON fuzzy_matches(original_score);
CREATE INDEX ix_queue_bo ON verification_queue(bo_status);
