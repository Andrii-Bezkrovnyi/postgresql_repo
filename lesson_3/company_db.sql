-- Create a table for departments
CREATE TABLE IF NOT EXISTS departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50)
);

-- Create a table for employees
CREATE TABLE IF NOT EXISTS employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    department_id INT,
    salary INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert 5 departments
INSERT INTO departments (department_id, department_name) VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Marketing'),
(5, 'Logistics')  -- no employees in this department
ON CONFLICT (department_id) DO NOTHING;

-- Insert 10 employees, 3 employees are without a department
INSERT INTO employees (employee_id, employee_name, department_id, salary) VALUES
(1, 'Alice Johnson', 1, 4000),
(2, 'Bob Smith', 1, 4500),
(3, 'Charlie Brown', 2, 5000),
(4, 'David Wilson', 2, 5500),
(5, 'Emma Davis', 3, 6000),
(6, 'Frank Miller', 3, 4800),
(7, 'Grace Lee', 4, 5200),
-- 3 employees without a department
(8, 'Hannah White', NULL, 4100),
(9, 'Ian Black', NULL, 3900),
(10, 'Julia Green', NULL, 4300)
ON CONFLICT (department_id) DO NOTHING;

-- Query to find all departments with their employees
SELECT
    e.employee_id,
    e.employee_name,
    d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;

-- All employees with their department names,
SELECT
    e.employee_name,
    d.department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id;

-- All departments and their employees
SELECT
    d.department_name,
    e.employee_name
FROM employees e
RIGHT JOIN departments d
    ON e.department_id = d.department_id;

-- All employees and all departments, matching where possible
SELECT
    employee_name,
    department_name
FROM employees
FULL OUTER JOIN departments USING (department_id);

-- All possible combinations of employees and departments
SELECT
    employee_name,
    department_name
FROM employees
CROSS JOIN departments;

-- Department with the highest number of employees
SELECT
    d.department_id,
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY employee_count DESC
LIMIT 1;


-- Count of employees in each department
WITH dept_counts AS (
    SELECT d.department_id, d.department_name, COUNT(e.employee_id) AS employee_count
    FROM departments d
    LEFT JOIN employees e USING(department_id)
    GROUP BY d.department_id, d.department_name
    ORDER BY d.department_id ASC
)
-- Select department with the maximum employee count
SELECT department_id, department_name, employee_count
FROM dept_counts
WHERE employee_count = (SELECT MAX(employee_count) FROM dept_counts);







