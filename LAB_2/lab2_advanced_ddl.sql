-- lab2_advanced_ddl.sql
-- PART 1:
--Task 1.1:
CREATE DATABASE university_main
    OWNER CURRENT_USER
    TEMPLATE template0
    ENCODING 'UTF8';

CREATE DATABASE university_archive
    CONNECTION LIMIT 50
    TEMPLATE template0;

CREATE DATABASE university_test
    IS_TEMPLATE true
    CONNECTION LIMIT 10;

--Task 1.2:
CREATE TABLESPACE student_data
    LOCATION '/data/students';

CREATE TABLESPACE course_data
    OWNER CURRENT_USER
    LOCATION '/data/courses';

CREATE DATABASE university_distributed
    TABLESPACE student_data
    ENCODING 'LATIN9';

-- PART 2:
--Task 2.1:
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    phone char(15),
    date_of_birth date,
    enrollment_date date,
    gpa decimal(3, 2),
    is_active boolean,
    graduation_year smallint
);

CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(100),
    office_number varchar(20),
    hire_date date,
    salary decimal(12, 2),
    is_tenured boolean,
    years_experience int
);

CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_code char(8),
    course_title varchar(100),
    description text,
    credits smallint,
    max_enrollment int,
    course_fee decimal(10, 2),
    is_online boolean,
    created_at timestamp
);

--Task 2.2:
CREATE TABLE class_schedule (
    schedule_id SERIAL PRIMARY KEY,
    course_id int,
    professor_id int,
    classroom varchar(20),
    class_date date,
    start_time time,
    end_time time,
    duration interval
);

CREATE TABLE student_records (
    record_id SERIAL PRIMARY KEY,
    student_id int,
    course_id int,
    semester varchar(20),
    year int,
    grade char(2),
    attendance_percentage decimal(5, 1),
    submission_timestamp timestamptz,
    last_updated timestamptz
);

--PART 3:
--Task 3.1:
ALTER TABLE students
    ADD COLUMN middle_name varchar(30),
    ADD COLUMN student_status varchar(20),
    ALTER COLUMN phone TYPE varchar(20),
    ALTER COLUMN student_status SET DEFAULT 'ACTIVE',
    ALTER COLUMN gpa SET DEFAULT 0.00;

ALTER TABLE professors
    ADD COLUMN department_code char(5),
    ADD COLUMN research_area text,
    ALTER COLUMN years_experience TYPE smallint,
    ALTER COLUMN is_tenured SET DEFAULT false,
    ADD COLUMN last_promotion_date date;

ALTER TABLE courses
    ADD COLUMN prerequisite_course_id int,
    ADD COLUMN difficulty_level smallint,
    ALTER COLUMN course_code TYPE varchar(10),
    ALTER COLUMN credits SET DEFAULT 3,
    ADD COLUMN lab_required boolean DEFAULT false;

--Task 3.2:
ALTER TABLE class_schedule
    ADD COLUMN room_capacity int,
    DROP COLUMN duration,
    ADD COLUMN session_type varchar(15),
    ALTER COLUMN classroom TYPE varchar(30),
    ADD COLUMN equipment_needed text;

ALTER TABLE student_records
    ADD COLUMN extra_credit_points decimal(3, 1),
    ALTER COLUMN grade TYPE varchar(5),
    ALTER COLUMN extra_credit_points SET DEFAULT 0.0,
    ADD COLUMN final_exam_date date,
    DROP COLUMN last_updated;

--PART 4:
--Task 4.1:
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name varchar(100),
    department_code char(5),
    building varchar(50),
    phone varchar(15),
    budget decimal(15, 2),
    established_year int
);

CREATE TABLE library_books (
    book_id SERIAL PRIMARY KEY,
    isbn char(13),
    title varchar(200),
    author varchar(100),
    publisher varchar(100),
    publication_date date,
    price decimal(10, 2),
    is_available boolean,
    acquisition_timestamp timestamp
);

CREATE TABLE student_book_loans (
    loan_id SERIAL PRIMARY KEY,
    student_id int,
    book_id int,
    loan_date date,
    due_date date,
    return_date date,
    fine_amount decimal(6, 2),
    loan_status varchar(20)
);

--Task 4.2:
ALTER TABLE professors
    ADD COLUMN department_id int;

ALTER TABLE students
    ADD COLUMN advisor_id int;

ALTER TABLE courses
    ADD COLUMN department_id int;

CREATE TABLE grade_scale (
    grade_id SERIAL PRIMARY KEY,
    letter_grade char(2),
    min_percentage decimal(4, 1),
    max_percentage decimal(4, 1),
    gpa_points decimal(3, 2)
);

CREATE TABLE semester_calendar (
    semester_id SERIAL PRIMARY KEY,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamptz,
    is_current boolean
);

--PART 5:
--Task 5.1:
DROP TABLE IF EXISTS student_book_loans;
DROP TABLE IF EXISTS library_books;
DROP TABLE IF EXISTS grade_scale;

CREATE TABLE grade_scale (
    grade_id SERIAL PRIMARY KEY,
    letter_grade char(2),
    min_percentage decimal(4, 1),
    max_percentage decimal(4, 1),
    gpa_points decimal(3, 2),
    description text
);

DROP TABLE IF EXISTS semester_calendar CASCADE;

CREATE TABLE semester_calendar (
    semester_id SERIAL PRIMARY KEY,
    semester_name varchar(20),
    academic_year int,
    start_date date,
    end_date date,
    registration_deadline timestamptz,
    is_current boolean
);

--Task 5.2:
DROP DATABASE IF EXISTS university_test;
DROP DATABASE IF EXISTS university_distributed;

CREATE DATABASE university_backup
    TEMPLATE university_main;
