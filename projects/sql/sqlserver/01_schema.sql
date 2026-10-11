-- First-run script. Use a new empty database.
CREATE TABLE locations (location_key NVARCHAR(40) PRIMARY KEY, district NVARCHAR(160) NOT NULL, block_name NVARCHAR(160) NOT NULL, cluster_name NVARCHAR(160) NOT NULL, village_name NVARCHAR(160) NOT NULL, school_name NVARCHAR(250) NOT NULL);

CREATE TABLE case_registry (case_id NVARCHAR(40) PRIMARY KEY, location_key NVARCHAR(40) NOT NULL, enrolment_year NVARCHAR(20) NOT NULL, admission_month NVARCHAR(20) NOT NULL, FOREIGN KEY (location_key) REFERENCES locations(location_key));

CREATE TABLE enrolments (case_id NVARCHAR(40) PRIMARY KEY, sr_status NVARCHAR(160) NOT NULL, quality_status NVARCHAR(30) NOT NULL CHECK (quality_status IN ('Yes','No','Not recorded')), cv_status NVARCHAR(30) NOT NULL, original_score DECIMAL(5,2) NULL CHECK (original_score IS NULL OR original_score BETWEEN 0 AND 100), new_score DECIMAL(5,2) NULL CHECK (new_score IS NULL OR new_score BETWEEN 0 AND 100), operational_school INT NOT NULL CHECK (operational_school IN (0,1)), no_contact INT NOT NULL CHECK (no_contact IN (0,1)), age_gap3 INT NOT NULL CHECK (age_gap3 IN (0,1)), current_eligibility_proxy INT NOT NULL CHECK (current_eligibility_proxy IN (0,1)), FOREIGN KEY (case_id) REFERENCES case_registry(case_id));

CREATE TABLE fuzzy_matches (case_id NVARCHAR(40) PRIMARY KEY, original_score DECIMAL(5,2) NULL CHECK (original_score IS NULL OR original_score BETWEEN 0 AND 100), new_score DECIMAL(5,2) NULL CHECK (new_score IS NULL OR new_score BETWEEN 0 AND 100), FOREIGN KEY (case_id) REFERENCES case_registry(case_id));

CREATE TABLE verification_queue (case_id NVARCHAR(40) PRIMARY KEY, bo_status NVARCHAR(160) NOT NULL, io_status NVARCHAR(160) NOT NULL, cv_status NVARCHAR(30) NOT NULL, FOREIGN KEY (case_id) REFERENCES case_registry(case_id));

CREATE INDEX ix_cases_location ON case_registry(location_key);
CREATE INDEX ix_cases_year ON case_registry(enrolment_year);
CREATE INDEX ix_enrolments_status ON enrolments(sr_status);
CREATE INDEX ix_fuzzy_original ON fuzzy_matches(original_score);
CREATE INDEX ix_queue_bo ON verification_queue(bo_status);
