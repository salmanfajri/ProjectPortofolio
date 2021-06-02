-- subqueries IN nested inside WHERE
-- sunqueries in query embedded in a query // inner query / nested query
-- inner query / inner select
-- palced inside the parantheses

SELECT 
    *
FROM
    dept_manager;

-- select the first and last name from the employees table for the same employee numbers that can be found in the department managers table

SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm);

SELECT 
    dm.emp_no
FROM
    dept_manager dm;

-- Excercise
-- extract the infromation about all department managers who where hire between 1st januari 1990 and 1 st january 1995

SELECT 
    e.emp_no, e.first_name, e.last_name, e.gender, e.hire_date
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm
        WHERE
            e.hire_date BETWEEN '1990-01-01' AND '1995-01-01');


SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no IN (SELECT 
            emp_no
        FROM
            employees
        WHERE
            hire_date BETWEEN '1990-01-01' AND '1995-01-01');
-- EXISTS and NOT EXISTS

SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no)
ORDER BY emp_no;

-- EXCERCISE
-- select the entire information for all employees whose job title assitant enginer
SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no 
                AND title = 'Assistant Engineer')
ORDER BY e.emp_no;

## subqueries nested in SELECT and FROM
/* task
assign employee number 110022 as a manager to all employee from 10001 to 10020, and
employee number 110039 as a manager to all  employee from 10021 to 10040
*/
/* subset A = employee numner 10001 to 10020, and
subset B = employee number 10021 to 10040
*/
SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS Manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS Manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B;
    
    -- EXCERCISE
    drop table if exists emp_manager;
    CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);


SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS Employee_ID,
            MIN(de.dept_no) AS Dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS Manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A 
UNION SELECT 
    B.*
FROM
    (SELECT 
        e.emp_no AS Employee_ID,
            MIN(de.dept_no) AS Dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS Manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no > 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no
    LIMIT 20) AS B 
UNION SELECT 
    C.*
FROM
    (SELECT 
        e.emp_no AS Employee_ID,
            MIN(de.dept_no) AS Dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS Manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110022
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS C 
UNION SELECT 
    D.*
FROM
    (SELECT 
        e.emp_no AS Employee_ID,
            MIN(de.dept_no) AS Dept_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022)
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 110039
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS D;
    

