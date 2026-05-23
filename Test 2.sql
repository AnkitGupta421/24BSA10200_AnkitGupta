 SQL QUERY SOLUTIONS

-- 1. 
SELECT E.employee_name, D.dept_name, D.location_id
FROM Employees E
JOIN Departments D ON E.dept_id = D.dept_id;

-- 2. 
SELECT P.project_name, P.client_name, SUM(A.hours_worked) AS total_hours
FROM Projects P
JOIN Assignments A ON P.project_id = A.project_id
JOIN Departments D ON P.dept_id = D.dept_id
WHERE D.dept_name = 'Consulting'
GROUP BY P.project_id, P.project_name, P.client_name;

-- 3. 
SELECT E.employee_name, P.project_name
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
JOIN Projects P ON A.project_id = P.project_id
WHERE P.client_name = 'GlobalTech Solutions';

-- 4. 
SELECT D.dept_name
FROM Departments D
LEFT JOIN Employees E ON D.dept_id = E.dept_id
WHERE E.employee_id IS NULL;

-- 5. 
SELECT M.employee_name AS manager_name, D.dept_name, COUNT(E.employee_id) AS direct_reports
FROM Employees M
JOIN Employees E ON M.employee_id = E.manager_id
JOIN Departments D ON M.dept_id = D.dept_id
GROUP BY M.employee_id, M.employee_name, D.dept_name;

-- 6. 
SELECT E.employee_name, AVG(A.hours_worked) AS average_hours
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY E.employee_id, E.employee_name;

-- 7. 
SELECT D.dept_name
FROM Departments D
JOIN Employees E ON D.dept_id = E.dept_id
GROUP BY D.dept_id, D.dept_name
HAVING AVG(E.salary) > (SELECT AVG(salary) FROM Employees);

-- 8. 
SELECT P.client_name
FROM Projects P
JOIN Assignments A ON P.project_id = A.project_id
GROUP BY P.client_name
HAVING SUM(A.hours_worked) > 500;

-- 9. 
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

-- 10. 
SELECT P.project_name, COUNT(A.employee_id) AS employee_count
FROM Projects P
JOIN Assignments A ON P.project_id = A.project_id
GROUP BY P.project_id, P.project_name
HAVING COUNT(A.employee_id) > 5;

-- 11. 
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

-- 12.
SELECT DISTINCT D.dept_name
FROM Departments D
JOIN Employees E ON D.dept_id = E.dept_id
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY D.dept_id, D.dept_name, E.employee_id
HAVING COUNT(DISTINCT A.project_id) > 1;

-- 13.
SELECT E.employee_name, P.project_name
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
JOIN Projects P ON A.project_id = P.project_id
WHERE A.hours_worked < 10;

-- 14. 
SELECT P.project_name
FROM Projects P
LEFT JOIN Assignments A ON P.project_id = A.project_id
WHERE A.employee_id IS NULL;

-- 15. 
SELECT employee_name
FROM Employees E1
WHERE salary > (
    SELECT MAX(salary)
    FROM Employees E2
    WHERE E1.dept_id = E2.dept_id AND E1.employee_id != E2.employee_id
);

-- 16. 
SELECT E.employee_name, MIN(A.start_date) AS oldest_project_date
FROM Employees E
JOIN Assignments A ON E.employee_id = A.employee_id
GROUP BY E.employee_id, E.employee_name;

-- 17. 
SELECT project_name
FROM Projects
WHERE DATE_FORMAT(start_date, '%Y') = '2023';

-- 18.
SELECT employee_name, IFNULL(manager_id, 'CEO') AS manager_status
FROM Employees;

