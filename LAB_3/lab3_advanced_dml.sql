--PART A:

CREATE DATABASE advanced_lab
    
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name varchar,
    last_name varchar,
    department varchar,
    salary int,
    hire_date date,
    status varchar DEFAULT 'ACTIVE'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name varchar,
    budget int,
    manager_id int
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name varchar,
    dept_id int,
    start_date date,
    end_date date,
    budget int
);


--PART B:

INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (DEFAULT, 'Timur', 'Kim', 'IT');

INSERT INTO employees (first_name, last_name, department, salary, status)
VALUES ('Vladislav', 'Lizko', 'IT', DEFAULT, DEFAULT);

INSERT INTO departments (dept_name, budget, manager_id)
VALUES
    ('Finance', '100000', NULL),
    ('Marketing', '150000', NULL),
    ('Engineeting', '200000', NULL);


INSERT INTO employees (first_name, last_name, department, salary, hire_date, status)
VALUES ('Talgat', 'Kozhakhmetov', 'IT', 500000 * 1,1, CURRENT_DATE);

CREATE TEMP TABLE temp_employees AS
SELECT *
FROM employees
WHERE department = 'IT';

--PART C:

UPDATE employees SET salary = salary * 1.1;

UPDATE employees SET status = 'Senior' WHERE salary > 60000 AND hire_date < DATE '2020-01-01';

UPDATE employees SET department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior'
END;

UPDATE employees SET department DEFAULT WHERE status = 'Inactive';

UPDATE departments d SET budget = (s.avg_salary * 1.2)::int
FROM (
    SELECT department AS dept_name, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)   s
WHERE d.dept_name = s.dept_name;

UPDATE employees SET
salary = salary * 1.15, 
status = 'Promoted'
WHERE department = 'Sales';

--PART D:

DELETE FROM employees WHERE status = 'Termimated';

DELETE FROM employees WHERE salary < 40000 AND hire_date > DATE '2023-01-01' AND department IS NULL;

DELETE FROM departments WHERE dept_id NOT IN (
    SELECT DISTINCT department::int
    FROM employees
    WHERE department IS NOT NULL
);

DELETE FROM projects WHERE end_date < '2023-01-01'
RETURNING *; 

--PART E:

INSERT INTO employees (first_name, last_name, salary, department)
VALUES ('Erdos', 'Erentalov', NULL, NULL);

UPDATE employees SET department = 'Unassigned' WHERE department IS NULL;

DELETE FROM employees WHERE salary IS NULL OR department IS NULL;

--PART F:

INSERT INTO employees (first_name, last_name, department, salary)
VALUES ('Emma', 'Wilson', 'HR', 45000)
RETURNING emp_id, (first_name, || ' ' || last_name) AS full_name;

UPDATE employees SET salary = salary + 5000 WHERE department = 'IT'
RETURNING emp_id, salary - 5000 AS old_salary, salary AS new_salary;

DELETE FROM employees WHERE hire_date < '2020-01-01'
RETURNING *;


--PART G:


INSERT INTO employees (first_name, last_name, department)
SELECT 'Liam', 'Green', 'IT'
WHERE NOT EXISTS (
    SELECT 1 FROM employees
    WHERE first_name = 'Liam' AND last_name = 'Green'
);

UPDATE employees e
SET salary = salary * CASE
    WHEN (SELECT d.budget FROM departments d
          WHERE d.dept_name = e.department) > 100000 THEN 1.10
    ELSE 1.05
END;

INSERT INTO employees (first_name, last_name, department, salary)
VALUES 
  ('Emp1','One','IT',45000),
  ('Emp2','Two','IT',46000),
  ('Emp3','Three','IT',47000),
  ('Emp4','Four','IT',48000),
  ('Emp5','Five','IT',49000);

UPDATE employees
SET salary = salary * 1.10
WHERE (first_name, last_name) IN (('Emp1','One'),('Emp2','Two'),('Emp3','Three'),('Emp4','Four'),('Emp5','Five'));

CREATE TABLE employee_archive AS
SELECT * FROM employees WHERE false;

INSERT INTO employee_archive
SELECT * FROM employees
WHERE status = 'Inactive';

DELETE FROM employees
WHERE status = 'Inactive';

UPDATE projects p
SET end_date = COALESCE(p.end_date, CURRENT_DATE) + INTERVAL '30 days'
WHERE p.budget > 50000
  AND EXISTS (
      SELECT 1
      FROM departments d
      JOIN employees e ON e.department = d.dept_name
      WHERE d.dept_id = p.dept_id
      GROUP BY d.dept_id
      HAVING COUNT(*) > 3
  );
