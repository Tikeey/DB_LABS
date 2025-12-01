Владислав, [26.11.2025 09:37]
CREATE TABLE doctors (
 doctor_id SERIAL PRIMARY KEY,
 full_name VARCHAR(100),
 specialization VARCHAR(50),
 phone VARCHAR(20),
 experience_years INTEGER,
 consultation_fee NUMERIC(10,2)
);
-- Insert sample data
INSERT INTO doctors (full_name, specialization, phone, experience_years, consultation_fee)
VALUES
('Д-р Асылхан Нұрғалиев', 'Cardiology', '+77011112233', 15, 25000),
('Д-р Айнұр Сапарова', 'Pediatrics', '+77012223344', 8, 18000),
('Д-р Ермек Токтарбаев', 'Neurology', '+77013334455', 12, 22000),
('Д-р Гүлмира Әбдіқадырова', 'Dermatology', '+77014445566', 6, 15000),
('Д-р Дәурен Мұхамедов', 'Orthopedics', '+77015556677', 20, 28000),
('Д-р Сәуле Байжанова', 'General Practice', '+77016667788', 10, 12000),
('Д-р Бауыржан Есенов', 'Surgery', '+77017778899', 18, 35000),
('Д-р Жанна Қуанышева', 'Ophthalmology', '+77018889900', 7, 16000);
-- Create patients table
CREATE TABLE patients (
 patient_id SERIAL PRIMARY KEY,
 full_name VARCHAR(100),
 birth_date DATE,
 blood_type VARCHAR(5),
 phone VARCHAR(20),
 address VARCHAR(200),
 registration_date DATE
);

INSERT INTO patients (full_name, birth_date, blood_type, phone, address, registration_date)
VALUES
('Алмас Қайратұлы', '1985-03-15', 'A+', '+77021234567', 'Almaty, Auezov district', '2023-01-10'),
('Меруерт Сейітқызы', '1992-07-22', 'O+', '+77022345678', 'Almaty, Medeu district', '2023-02-15'),
('Нұрлан Әміржанұлы', '1978-11-30', 'B+', '+77023456789', 'Astana, Esil district', '2022-11-20'),
('Айгерім Төлеуқызы', '2015-05-18', 'AB+', '+77024567890', 'Almaty, Bostandyk district',
'2023-04-05'),
('Ержан Бақытұлы', '1990-09-08', 'A-', '+77025678901', 'Shymkent, Abai district', '2023-03-12'),
('Динара Серікқызы', '1988-12-25', 'O-', '+77026789012', 'Almaty, Almaly district', '2023-05-20'),
('Қуаныш Мұратұлы', '1995-02-14', 'B+', '+77027890123', 'Karaganda, Oktyabr district',
'2023-06-18'),
('Гүлнәр Әбілқызы', '1982-08-03', 'A+', '+77028901234', 'Almaty, Turksib district', '2022-12-10');
-- Create appointments table
CREATE TABLE appointments (
 appointment_id SERIAL PRIMARY KEY,
 patient_id INTEGER REFERENCES patients(patient_id),
 doctor_id INTEGER REFERENCES doctors(doctor_id),
 appointment_date DATE,
 appointment_time TIME,
 status VARCHAR(20),
 diagnosis TEXT,
 notes TEXT
);
-- Insert sample data
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status,
diagnosis, notes) VALUES
(1, 1, '2024-11-15', '09:00', 'completed', 'Hypertension', 'Blood pressure monitoring required'),
(1, 1, '2024-11-22', '09:30', 'scheduled', NULL, 'Follow-up appointment'),
(2, 2, '2024-11-16', '10:00', 'completed', 'Common cold', 'Rest and fluids recommended'),
(3, 3, '2024-11-17', '14:00', 'completed', 'Migraine', 'Prescribed pain medication'),
(4, 2, '2024-11-18', '11:00', 'completed', 'Vaccination', 'Annual flu shot'),
(5, 5, '2024-11-19', '15:00', 'completed', 'Knee pain', 'Physical therapy recommended'),
(6, 6, '2024-11-20', '10:30', 'completed', 'Annual checkup', 'All tests normal'),
(7, 4, '2024-11-21', '13:00', 'cancelled', NULL, 'Patient cancelled'),
(8, 8, '2024-11-22', '16:00', 'scheduled', NULL, 'Vision test'),
(1, 6, '2024-11-10', '09:00', 'completed', 'Fever', 'Antibiotics prescribed'),
(2, 2, '2024-11-12', '10:30', 'completed', 'Cough', 'Cough syrup prescribed');


CREATE TABLE prescriptions (
 prescription_id SERIAL PRIMARY KEY,
 appointment_id INTEGER REFERENCES appointments(appointment_id),
 medication_name VARCHAR(100),
 dosage VARCHAR(50),
 duration_days INTEGER,
 instructions TEXT
);
-- Insert sample data
INSERT INTO prescriptions (appointment_id, medication_name, dosage, duration_days,
instructions) VALUES
(1, 'Enalapril', '10mg', 30, 'Take once daily in the morning'),
(2, NULL, NULL, NULL, NULL),
(3, 'Paracetamol', '500mg', 5, 'Take as needed for cold symptoms'),
(4, 'Sumatriptan', '50mg', 10, 'Take at onset of migraine'),
(6, 'Ibuprofen', '400mg', 14, 'Take twice daily after meals'),
(7, NULL, NULL, NULL, NULL),
(10, 'Amoxicillin', '500mg', 7, 'Take three times daily');
-- Create medical_tests table
CREATE TABLE medical_tests (
 test_id

Владислав, [26.11.2025 09:37]
SERIAL PRIMARY KEY,
 appointment_id INTEGER REFERENCES appointments(appointment_id),
 test_name VARCHAR(100),
 test_date DATE,
 result VARCHAR(50),
 cost NUMERIC(10,2)
);
-- Insert sample data
INSERT INTO medical_tests (appointment_id, test_name, test_date, result, cost) VALUES
(1, 'Blood Pressure', '2024-11-15', '140/90', 5000),
(1, 'ECG', '2024-11-15', 'Normal', 15000),
(3, 'Blood Test', '2024-11-16', 'Normal', 8000),
(4, 'CT Scan', '2024-11-17', 'No abnormalities', 45000),
(5, 'Blood Test', '2024-11-18', 'Normal', 8000),
(6, 'X-Ray', '2024-11-19', 'Mild arthritis', 12000),
(7, 'Blood Test', '2024-11-20', 'Normal', 8000),
(7, 'Cholesterol Test', '2024-11-20', 'Slightly elevated', 6000);

Владислав, [26.11.2025 09:37]
CREATE TABLE doctors (
 doctor_id SERIAL PRIMARY KEY,
 full_name VARCHAR(100),
 specialization VARCHAR(50),
 phone VARCHAR(20),
 experience_years INTEGER,
 consultation_fee NUMERIC(10,2)
);
-- Insert sample data
INSERT INTO doctors (full_name, specialization, phone, experience_years, consultation_fee)
VALUES
('Д-р Асылхан Нұрғалиев', 'Cardiology', '+77011112233', 15, 25000),
('Д-р Айнұр Сапарова', 'Pediatrics', '+77012223344', 8, 18000),
('Д-р Ермек Токтарбаев', 'Neurology', '+77013334455', 12, 22000),
('Д-р Гүлмира Әбдіқадырова', 'Dermatology', '+77014445566', 6, 15000),
('Д-р Дәурен Мұхамедов', 'Orthopedics', '+77015556677', 20, 28000),
('Д-р Сәуле Байжанова', 'General Practice', '+77016667788', 10, 12000),
('Д-р Бауыржан Есенов', 'Surgery', '+77017778899', 18, 35000),
('Д-р Жанна Қуанышева', 'Ophthalmology', '+77018889900', 7, 16000);
-- Create patients table
CREATE TABLE patients (
 patient_id SERIAL PRIMARY KEY,
 full_name VARCHAR(100),
 birth_date DATE,
 blood_type VARCHAR(5),
 phone VARCHAR(20),
 address VARCHAR(200),
 registration_date DATE
);

INSERT INTO patients (full_name, birth_date, blood_type, phone, address, registration_date)
VALUES
('Алмас Қайратұлы', '1985-03-15', 'A+', '+77021234567', 'Almaty, Auezov district', '2023-01-10'),
('Меруерт Сейітқызы', '1992-07-22', 'O+', '+77022345678', 'Almaty, Medeu district', '2023-02-15'),
('Нұрлан Әміржанұлы', '1978-11-30', 'B+', '+77023456789', 'Astana, Esil district', '2022-11-20'),
('Айгерім Төлеуқызы', '2015-05-18', 'AB+', '+77024567890', 'Almaty, Bostandyk district',
'2023-04-05'),
('Ержан Бақытұлы', '1990-09-08', 'A-', '+77025678901', 'Shymkent, Abai district', '2023-03-12'),
('Динара Серікқызы', '1988-12-25', 'O-', '+77026789012', 'Almaty, Almaly district', '2023-05-20'),
('Қуаныш Мұратұлы', '1995-02-14', 'B+', '+77027890123', 'Karaganda, Oktyabr district',
'2023-06-18'),
('Гүлнәр Әбілқызы', '1982-08-03', 'A+', '+77028901234', 'Almaty, Turksib district', '2022-12-10');
-- Create appointments table
CREATE TABLE appointments (
 appointment_id SERIAL PRIMARY KEY,
 patient_id INTEGER REFERENCES patients(patient_id),
 doctor_id INTEGER REFERENCES doctors(doctor_id),
 appointment_date DATE,
 appointment_time TIME,
 status VARCHAR(20),
 diagnosis TEXT,
 notes TEXT
);
-- Insert sample data
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_time, status,
diagnosis, notes) VALUES
(1, 1, '2024-11-15', '09:00', 'completed', 'Hypertension', 'Blood pressure monitoring required'),
(1, 1, '2024-11-22', '09:30', 'scheduled', NULL, 'Follow-up appointment'),
(2, 2, '2024-11-16', '10:00', 'completed', 'Common cold', 'Rest and fluids recommended'),
(3, 3, '2024-11-17', '14:00', 'completed', 'Migraine', 'Prescribed pain medication'),
(4, 2, '2024-11-18', '11:00', 'completed', 'Vaccination', 'Annual flu shot'),
(5, 5, '2024-11-19', '15:00', 'completed', 'Knee pain', 'Physical therapy recommended'),
(6, 6, '2024-11-20', '10:30', 'completed', 'Annual checkup', 'All tests normal'),
(7, 4, '2024-11-21', '13:00', 'cancelled', NULL, 'Patient cancelled'),
(8, 8, '2024-11-22', '16:00', 'scheduled', NULL, 'Vision test'),
(1, 6, '2024-11-10', '09:00', 'completed', 'Fever', 'Antibiotics prescribed'),
(2, 2, '2024-11-12', '10:30', 'completed', 'Cough', 'Cough syrup prescribed');


CREATE TABLE prescriptions (
 prescription_id SERIAL PRIMARY KEY,
 appointment_id INTEGER REFERENCES appointments(appointment_id),
 medication_name VARCHAR(100),
 dosage VARCHAR(50),
 duration_days INTEGER,
 instructions TEXT
);
-- Insert sample data
INSERT INTO prescriptions (appointment_id, medication_name, dosage, duration_days,
instructions) VALUES
(1, 'Enalapril', '10mg', 30, 'Take once daily in the morning'),
(2, NULL, NULL, NULL, NULL),
(3, 'Paracetamol', '500mg', 5, 'Take as needed for cold symptoms'),
(4, 'Sumatriptan', '50mg', 10, 'Take at onset of migraine'),
(6, 'Ibuprofen', '400mg', 14, 'Take twice daily after meals'),
(7, NULL, NULL, NULL, NULL),
(10, 'Amoxicillin', '500mg', 7, 'Take three times daily');
-- Create medical_tests table
CREATE TABLE medical_tests (
 test_id

Владислав, [26.11.2025 09:37]
SERIAL PRIMARY KEY,
 appointment_id INTEGER REFERENCES appointments(appointment_id),
 test_name VARCHAR(100),
 test_date DATE,
 result VARCHAR(50),
 cost NUMERIC(10,2)
);
-- Insert sample data
INSERT INTO medical_tests (appointment_id, test_name, test_date, result, cost) VALUES
(1, 'Blood Pressure', '2024-11-15', '140/90', 5000),
(1, 'ECG', '2024-11-15', 'Normal', 15000),
(3, 'Blood Test', '2024-11-16', 'Normal', 8000),
(4, 'CT Scan', '2024-11-17', 'No abnormalities', 45000),
(5, 'Blood Test', '2024-11-18', 'Normal', 8000),
(6, 'X-Ray', '2024-11-19', 'Mild arthritis', 12000),
(7, 'Blood Test', '2024-11-20', 'Normal', 8000),
(7, 'Cholesterol Test', '2024-11-20', 'Slightly elevated', 6000);
--Task 
--Ex 1.1
CREATE OR REPLACE FUNCTION calculate_discount(
    original_price NUMERIC,
    discount_price NUMERIC
)
RETURNS NUMERIC AS
$$
BEGIN 
    RETURN original_price - (original_price * discount_price / 100);
END;
$$ LANGUAGE plpgsql;

--Task 2
--Ex 2.1
CREATE OR REPLACE FUNCTION film_stats(
    p_rating VARCHAR,
    OUT total_films INTEGER,
    OUT avg_rental_rate NUMERIC
)
AS $$
BEGIN
    SELECT 
        COUNT(*), 
        AVG(rental_rate)
    INTO 
        total_films, 
        avg_rental_rate
    FROM film
    WHERE rating = p_rating;
END;
$$ LANGUAGE plpgsql;

--Task 3
--Ex 3.1
CREATE OR REPLACE FUNCTION get_customer_rentals(p_customer_id INTEGER)
RETURNS TABLE (
    rental_date DATE,
    film_title VARCHAR,
    return_date DATE
)
AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.rental_date,
        f.title,
        r.return_date
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    WHERE r.customer_id = p_customer_id;
END;
$$ LANGUAGE plpgsql;


--Task 4
--Ex 4.1
--Ver 1
CREATE OR REPLACE FUNCTION search_films(p_title_pattern VARCHAR)
RETURNS TABLE (
    title VARCHAR,
    release_year INTEGER
)
AS $$
BEGIN
    RETURN QUERY
    SELECT f.title, f.release_year
    FROM film f
    WHERE f.title ILIKE p_title_pattern;
END;
$$ LANGUAGE plpgsql;
--Ver 2
CREATE OR REPLACE FUNCTION search_films(p_title_pattern VARCHAR, p_rating VARCHAR)
RETURNS TABLE (
    title VARCHAR,
    release_year INTEGER,
    rating VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT f.title, f.release_year, f.rating
    FROM film f
    WHERE f.title ILIKE p_title_pattern
      AND f.rating = p_rating;
END;
$$ LANGUAGE plpgsql;



--Class Work
--Task 1
--Ex 1.2
CREATE OR REPLACE FUNCTION get_bmi_category(bmi NUMERIC)
RETURNS VARCHAR AS $$
BEGIN 
    IF bmi < 18.5 THEN RETURN 'Underweight';
    ELSIF bmi >= 18.5 AND bmi <= 24.9 THEN RETURN 'Normal';
    ELSIF bmi >= 25.0 AND bmi <= 29.9 THEN RETURN 'Overweight';
    ELSIF bmi = 30 RETURN 'Obese';
    END IF;
END;
$$ LANGUAGE plpgsql;

--Task 2
--Ex2.2
CREATE OR REPLACE FUNCTION doctor_performance(p_doctor_id INTEGER, 
    OUT total_appointments INTEGER, 
    OUT completed_appointments INTEGER,
    OUT completion_rate NUMERIC,
    OUT total_revenue NUMERIC)
AS $$
BEGIN
    SELECT COUNT(*)
    INTO total_appointments
    FROM appoinments
    WHERE doctor_id = p_doctor_id;

    SELECT COUNT (*)
    INTO completed_appointments
    FROM appoinments
    WHERE doctor_id = p_doctor_id AND status = 'Completed';

    IF total_appointments = 0 THEN completion_rate := 0;
    ELSE completion_rate := completed_appointments::NUMERIC / total_appointments * 100;
    END IF;

    SELECT COALESCE(SUM(a.consultation_fee), 0)
    INTO total_revenue
    FROM appoinments a
    WHERE a.doctor_id = p_doctor_id AND a.status = 'Completed';
END;
$$ LANGUAGE plpgsql;

--Ex 2.2
CREATE OR REPLACE FUNCTION patient_medical_summary(p_patient_id INTEGER, 
    OUT total_visits INTEGER, 
    OUT total_cost NUMERIC,
    OUT last_visit_date  DATE,
    OUT unique_doctors INTEGER)
AS $$
BEGIN
    SELECT COUNT(*)
    INTO total_visits
    FROM appoinments
    WHERE p_patient_id = p_patient_id AND status = 'Completed';

    SELECT COALESCE(SUM(a.consultation_fee) + SUM(mt.test_cost), 0)
    INTO total_cost
    FROM appoinments a
    LEFT JOIN mecal_tests mt ON mt.appoinment_id = a.appoinment_id
    WHERE a.patient_id = p_patient_id AND a.status = 'Completed';

    SELECT MAX(appintment_date)
    INTO last_visit_date
    FROM appoinments
    WHERE patient_id = p_patient_id;

    SELECT COUNT(DISTINCT doctor_id)
    INTO unique_doctors
    FROM appoinments
    WHERE patient_id = p_patient_id;
END;
$$ LANGUAGE plpgsql;

--Task 3
--EX 3.1
CREATE OT REPLACE FUNCTION apply_seior_discount(INOUT consultation_fee NUMERIC, IN patient_id)

--Task 4
--Ex 4.1
--Ver 1
CREATE OR REPLACE FUNCTION search_films(p_title_pattern VARCHAR)
RETURNS TABLE (
    title VARCHAR,
    release_year INTEGER
)
AS $$
BEGIN
    RETURN QUERY
    SELECT f.title, f.release_year
    FROM film f
    WHERE f.title ILIKE p_title_pattern;
END;
$$ LANGUAGE plpgsql;
--Ver 2
CREATE OR REPLACE FUNCTION search_films(p_title_pattern VARCHAR, p_rating VARCHAR)
RETURNS TABLE (
    title VARCHAR,
    release_year INTEGER,
    rating VARCHAR
)
AS $$
BEGIN
    RETURN QUERY
    SELECT f.title, f.release_year, f.rating
    FROM film f
    WHERE f.title ILIKE p_title_pattern
      AND f.rating = p_rating;
END;
$$ LANGUAGE plpgsql;