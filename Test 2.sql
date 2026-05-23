-- ==========================================
-- 1. SCHEMA CREATION AND DATA INSERTION
-- ==========================================

-- Create Departments Table
CREATE TABLE Departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL,
    location_id VARCHAR(50) NOT NULL
);

INSERT INTO Departments (dept_id, dept_name, location_id) VALUES
(10, 'Consulting', 'NYC'),
(20, 'Engineering', 'SF'),
(30, 'R&D', 'London'),
(40, 'Sales', 'NYC'),
(50, 'HR', 'SF'),
(60, 'Admin', 'London');

-- Create Employees Table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    manager_id INT,
    dept_id INT,
    salary DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Employees (employee_id, employee_name, manager_id, dept_id, salary) VALUES
(100, 'Alice Smith (CEO)', NULL, 10, 180000.00),
(101, 'Bob Johnson', 100, 20, 120000.00),
(102, 'Charlie Brown', 101, 20, 95000.00),
(103, 'Diana Prince', 100, 30, 110000.00),
(104, 'Evan Clark', 103, 30, 85000.00),
(105, 'Fiona Glen', 101, 20, 90000.00),
(106, 'George King', 100, 40, 75000.00),
(107, 'Hannah Lee', 103, 30, 88000.00),
(108, 'Ivan Rossi', 100, 50, 60000.00),
(109, 'Jane Doe', 101, 20, 125000.00),
(110, 'Kevin Blue', 104, 30, 86000.00);

-- Create Projects Table
CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50) NOT NULL,
    client_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    dept_id INT,
    FOREIGN KEY (dept_id) REFERENCES Departments(dept_id)
);

INSERT INTO Projects (project_id, project_name, client_name, start_date, dept_id) VALUES
(5001, 'Aurora Migration', 'GlobalTech Solutions', '2023-01-15', 20),
(5002, 'Synergy App Dev', 'Zenith Corp', '2023-05-20', 30),
(5003, 'Q4 Sales Strategy', 'Apex Industries', '2024-01-01', 40),
(5004, 'Global Expansion', 'GlobalTech Solutions', '2024-03-10', 10),
(5005, 'Internal HR Tool', 'Internal', '2024-02-01', 50),
(5006, 'Data Analytics', 'Zenith Corp', '2022-11-01', 20),
(5007, 'Future Tech R&D', 'R&D Dept', '2024-06-01', 30);

-- Create Assignments Table
CREATE TABLE Assignments (
    assignment_id INT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    hours_worked INT NOT NULL,
    start_date DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

INSERT INTO Assignments (assignment_id, employee_id, project_id, hours_worked, start_date) VALUES
(1, 101, 5001, 150, '2023-01-15'),
(2, 102, 5001, 160, '2023-01-15'),
(3, 105, 5001, 140, '2023-02-01'),
(4, 103, 5002, 80, '2023-05-20'),
(5, 104, 5002, 70, '2023-06-01'),
(6, 106, 5003, 5, '2024-01-01'),
(7, 100, 5004, 20, '2024-03-10'),
(8, 107, 5002, 75, '2023-05-25'),
(9, 109, 5006, 200, '2022-11-01'),
(10, 101, 5006, 250, '2022-11-01'),
(11, 102, 5006, 180, '2022-12-01'),
(12, 110, 5007, 10, '2024-06-01');


-- ==========================================
-- 2. SQL QUERY SOLUTIONS
-- ==========================================

-- 1. List the Employee Name, their Department Name, and the Location Name for all employees.
SELECT E.employee_name, D.dept_name, D.location_id
FROM Employees E
JOIN Departments D ON E.dept_id = D.dept_id;

-- 2. Retrieve the Project Name, Client Name, and the Total Hours Worked on that project, but only for projects managed by the 'Consulting' department.
SELECT P.project_name, P.client_name, SUM(A.hours_worked) AS total_hours
FROM Projects P
JOIN Assignments A ON P.project_id = A.project_id
JOIN Departments D ON P.dept_id = D.dept_id
WHERE D.dept_name = 'Consulting'
GROUP BY P.project_id, P.project_name, P.client_name;

-- 3. Find the names of Employees who have worked on a project with Client Name 'GlobalTech Solutions'. List the Employee Name and Project Name.
SELECT E.employee_name, P.project_name
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
JOIN Projects P ON A.project_id = P.project_id
WHERE P.client_name = 'GlobalTech Solutions';

-- 4. List all Departments that have no Employees currently assigned to them.
SELECT D.dept_name
FROM Departments D
LEFT JOIN Employees E ON D.dept_id = E.dept_id
WHERE E.employee_id IS NULL;

-- 5. Show the Manager Name, the Department Name they manage, and the total number of direct reports they have.
SELECT M.employee_name AS manager_name, D.dept_name, COUNT(E.employee_id) AS direct_reports
FROM Employees M
JOIN Employees E ON M.employee_id = E.manager_id
JOIN Departments D ON M.dept_id = D.dept_id
GROUP BY M.employee_id, M.employee_name, D.dept_name;

-- 6. Calculate the Average Hours Worked per Employee across all projects. List the Employee Name and the average hours.
SELECT E.employee_name, AVG(A.hours_worked) AS average_hours
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY E.employee_id, E.employee_name;

-- 7. Find the Department Name(s) that have an average salary above the company-wide average salary.
SELECT D.dept_name
FROM Departments D
JOIN Employees E ON D.dept_id = E.dept_id
GROUP BY D.dept_id, D.dept_name
HAVING AVG(E.salary) > (SELECT AVG(salary) FROM Employees);

-- 8. Identify the Client Name(s) whose projects have a total combined hours worked exceeding 500 hours.
SELECT P.client_name
FROM Projects P
JOIN Assignments A ON P.project_id = A.project_id
GROUP BY P.client_name
HAVING SUM(A.hours_worked) > 500;

-- 9. For each Location, find the Department Name with the highest count of employees.
WITH DeptCounts AS (
    SELECT D.location_id, D.dept_name, COUNT(E.employee_id) AS emp_count,
           RANK() OVER(PARTITION BY D.location_id ORDER BY COUNT(E.employee_id) DESC) as rnk
    FROM Departments D
    LEFT JOIN Employees E ON D.dept_id = E.dept_id
    GROUP BY D.location_id, D.dept_name
)
SELECT location_id, dept_name
FROM DeptCounts
WHERE rnk = 1;

-- 10. Calculate the total number of employees assigned to each Project, but only include projects that have more than 5 employees assigned.
SELECT P.project_name, COUNT(A.employee_id) AS employee_count
FROM Projects P
JOIN Assignments A ON P.project_id = A.project_id
GROUP BY P.project_id, P.project_name
HAVING COUNT(A.employee_id) > 5;

-- 11. Find the Employee Name(s) who work on ALL projects managed by the 'R&D' department.
SELECT E.employee_name
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
JOIN Projects P ON A.project_id = P.project_id
JOIN Departments D ON P.dept_id = D.dept_id
WHERE D.dept_name = 'R&D'
GROUP BY E.employee_id, E.employee_name
HAVING COUNT(DISTINCT P.project_id) = (
    SELECT COUNT(project_id)
    FROM Projects P2
    JOIN Departments D2 ON P2.dept_id = D2.dept_id
    WHERE D2.dept_name = 'R&D'
);

-- 12. Retrieve the Department Name(s) that have employees assigned to more than one project.
SELECT DISTINCT D.dept_name
FROM Departments D
JOIN Employees E ON D.dept_id = E.dept_id
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY D.dept_id, D.dept_name, E.employee_id
HAVING COUNT(DISTINCT A.project_id) > 1;

-- 13. Write a query to list the Employee Name and Project Name for any employee who has worked less than 10 hours on a project.
SELECT E.employee_name, P.project_name
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
JOIN Projects P ON A.project_id = P.project_id
WHERE A.hours_worked < 10;

-- 14. Find the Project Name(s) that have no assigned employees.
SELECT P.project_name
FROM Projects P
LEFT JOIN Assignments A ON P.project_id = A.project_id
WHERE A.employee_id IS NULL;

-- 15. Select the Employee Name(s) whose salary is greater than the maximum salary in their own department.
SELECT employee_name
FROM Employees E1
WHERE salary > (
    SELECT MAX(salary)
    FROM Employees E2
    WHERE E1.dept_id = E2.dept_id AND E1.employee_id != E2.employee_id
);

-- 16. Assuming the Assignments table has a start_date column, find the Employee Name and their oldest project start date.
SELECT E.employee_name, MIN(A.start_date) AS oldest_project_date
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY E.employee_id, E.employee_name;

-- 17. Write a MySQL query using the DATE_FORMAT function to list all projects that were active in the year 2023.
SELECT project_name
FROM Projects
WHERE DATE_FORMAT(start_date, '%Y') = '2023';

-- 18. Use the MySQL-specific IFNULL function to list all Employee Names. If an employee has no manager, display "CEO" instead of NULL.
SELECT employee_name, IFNULL(manager_id, 'CEO') AS manager_status
FROM Employees;

-- 19. Find the top 3 Departments based on the total hours worked by all their employees across all projects.
SELECT D.dept_name, SUM(A.hours_worked) AS total_hours
FROM Departments D
JOIN Employees E ON D.dept_id = E.dept_id
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY D.dept_id, D.dept_name
ORDER BY total_hours DESC
LIMIT 3;

-- 20. Display the Project Name and a status ("High Activity" if total hours > 300, "Normal" otherwise) using the CASE statement.
SELECT P.project_name,
       CASE
           WHEN SUM(A.hours_worked) > 300 THEN 'High Activity'
           ELSE 'Normal'
       END AS activity_status
FROM Projects P
LEFT JOIN Assignments A ON P.project_id = A.project_id
GROUP BY P.project_id, P.project_name;

-- 21. List the Employee Name and their Manager's Name, even if the employee has no manager, or if a potential manager has no employees reporting to them.
SELECT E.employee_name AS employee, M.employee_name AS manager
FROM Employees E
LEFT JOIN Employees M ON E.manager_id = M.employee_id;

-- 22. Write a query using a Common Table Expression (CTE) to find the Project Name and the number of unique employees assigned to it.
WITH ProjectAssignments AS (
    SELECT project_id, COUNT(DISTINCT employee_id) AS unique_employees
    FROM Assignments
    GROUP BY project_id
)
SELECT P.project_name, PA.unique_employees
FROM Projects P
LEFT JOIN ProjectAssignments PA ON P.project_id = PA.project_id;

-- 23. Find the Employee Name(s) who are assigned to the same projects as Employee ID 101.
SELECT DISTINCT E.employee_name
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
WHERE A.project_id IN (
    SELECT project_id
    FROM Assignments
    WHERE employee_id = 101
) AND E.employee_id != 101;
