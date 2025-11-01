CREATE DATABASE healthcare_db;
USE healthcare_db;

CREATE TABLE patients(
patient_id VARCHAR(10) PRIMARY KEY,
first_name VARCHAR(50),
last_name VARCHAR(50),
gender ENUM('Male', 'Female'),
age INT Check(age>= 0),
city VARCHAR(50),
registration_date VARCHAR(20)
);
SET SQL_SAFE_UPDATES = 0;
UPDATE patients
SET registration_date = STR_TO_DATE(registration_date, '%d-%m-%Y')
WHERE registration_date IS NOT NULL;
ALTER TABLE patients 
MODIFY COLUMN registration_date DATE;

CREATE TABLE doctors (
doctor_id VARCHAR(10) PRIMARY KEY,
doctor_name VARCHAR(100),
specialization VARCHAR(100),
department VARCHAR(100),
experience_years INT CHECK(experience_years > 0)
);

CREATE TABLE visits (
    visit_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    visit_date VARCHAR(20),
    diagnosis VARCHAR(100),
    treatment_cost DECIMAL(10,2),
    visit_charges DECIMAL(10,2),
    follow_up_required ENUM('Yes','No'),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
UPDATE visits
SET visit_date = STR_TO_DATE(visit_date, '%d-%m-%Y')
WHERE visit_date IS NOT NULL;
ALTER TABLE visits 
MODIFY COLUMN visit_date DATE;

CREATE TABLE labtests (
    test_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    test_type VARCHAR(100),
    test_date VARCHAR(20),
    result_status ENUM('Normal','Abnormal'),
    cost DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);
UPDATE labtests
SET test_date = STR_TO_DATE(test_date, '%d-%m-%Y')
WHERE test_date IS NOT NULL;
ALTER TABLE labtests
MODIFY COLUMN test_date DATE;

-- KPI Calculation
-- 1. Total Patients
SELECT COUNT(DISTINCT patient_id) AS Total_patients FROM patients;

-- 2. Total Doctors
SELECT COUNT(DISTINCT doctor_id) AS Total_doctors FROM doctors;

-- 3. Total Visits
SELECT COUNT(*) AS Total_visits FROM visits;

-- 4. Follow-Up Rate
SELECT ROUND(SUM(follow_up_required = 'Yes')*100/COUNT(*),2) AS Follow_Up_Rate
FROM visits;

-- 5. Total Collection
SELECT 
  ROUND(SUM(treatment_cost + visit_charges) + (SELECT SUM(cost) FROM labtests),2)
  AS Total_Collection
FROM visits;

-- 6. Average Treatment cost
SELECT ROUND(AVG(treatment_cost),2) AS Avg_Treatment_Cost
FROM visits;

-- 7. Total Lab tests conducted
SELECT COUNT(*) AS Total_Lab_Tests
FROM labtests;

-- 8 Average Lab Test Cost
SELECT ROUND(AVG(cost),2) AS Avg_Lab_Test_Cost
FROM labtests;




