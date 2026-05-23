-- SQL Query Solutions
-- 1. 
SELECT e.name, j.job_title, d.dept_name
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
JOIN Departments d ON e.dept_id = d.dept_id;

-- 2.
SELECT name, salary
FROM Employees
WHERE salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE dept_id = (SELECT dept_id FROM Departments WHERE dept_name = 'IT')
);

-- 3. 
SELECT d.dept_name, SUM(e.salary) AS total_expenditure
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 4. 
SELECT d.dept_name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > 2 AND AVG(e.salary) > 70000;

-- 5. 
SELECT e.name AS employee_name, m.name AS manager_name
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.emp_id;

-- 6.
SELECT name, salary
FROM Employees
ORDER BY salary DESC
LIMIT 3;

-- 7. 
SELECT e.name
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
JOIN Departments d ON e.dept_id = d.dept_id
WHERE j.job_title = 'Developer' AND d.location = 'San Francisco';

-- 8. 
SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, COUNT(emp_id) AS num_employees
FROM Employees
GROUP BY EXTRACT(YEAR FROM hire_date);

-- 9. 
SELECT j.job_title
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
GROUP BY j.job_title
HAVING MAX(e.salary) < 100000;

-- 10..
SELECT name
FROM Employees
WHERE dept_id = (SELECT dept_id FROM Employees WHERE name = 'David')
AND name != 'David';

-- 11.
FROM Departments d
LEFT JOIN Employees e ON d.dept_id = e.dept_id;

-- 12. 
SELECT name
FROM Employees
WHERE hire_date BETWEEN '2018-01-01' AND '2020-12-31'
AND salary > 60000;

-- 13. 
SELECT e.name, e.salary
FROM Employees e
WHERE e.salary > (
    SELECT AVG(salary)
    FROM Employees
    WHERE dept_id = e.dept_id
);

-- 14. 
SELECT j.job_title, e.salary
FROM Employees e
JOIN Jobs j ON e.job_id = j.job_id
WHERE e.emp_id = 504;


-- 15.
SELECT dept_name
FROM Departments
WHERE dept_id NOT IN (
    SELECT e.dept_id
    FROM Employees e
    JOIN Jobs j ON e.job_id = j.job_id
    WHERE j.job_title = 'Analyst'
);

-- 16. 
SELECT MAX(salary) - MIN(salary) AS salary_difference
FROM Employees;

-- 17. 
SELECT e.name, e.hire_date
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name ASC, e.salary DESC;


-- 18.
SELECT name, salary
FROM Employees
WHERE salary = (
    SELECT DISTINCT salary
    FROM Employees
    ORDER BY salary DESC
    LIMIT 1 OFFSET 2
);

-- 19. 
SELECT e.name
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
WHERE d.dept_name = 'Finance' AND e.name LIKE '%i%';

-- 20. 
SELECT d.dept_name, SUM(e.salary * 0.10) AS total_bonus
FROM Employees e
JOIN Departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name;




