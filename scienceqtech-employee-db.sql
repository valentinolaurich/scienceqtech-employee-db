-- (Q1) Create a database named employee.
CREATE DATABASE employee;

USE employee;

SELECT * FROM emp_record_table;
SELECT * FROM data_science_team;
SELECT * FROM proj_table;


-- (Q3) Fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table. Make a list of employees and details of their department.
SELECT emp_id, first_name, last_name, gender, dept
FROM emp_record_table;


/*
(Q4) Fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: 
	1.	less than two
	2.	greater than four 
	3.	between two and four
*/
SELECT * FROM emp_record_table;

-- Less than 2
SELECT emp_id, first_name, last_name, gender, dept
FROM emp_record_table
WHERE emp_rating < 2;

-- Greater than 4
SELECT emp_id, first_name, last_name, gender, dept
FROM emp_record_table
WHERE emp_rating > 4;

-- Between 2 and 4
SELECT emp_id, first_name, last_name, gender, dept
FROM emp_record_table
WHERE emp_rating BETWEEN 2 AND 4;


-- (Q5) Concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
SELECT * FROM emp_record_table;

SELECT CONCAT(first_name, ' ', last_name) AS 'name', dept
FROM emp_record_table
WHERE dept = 'finance';


-- (Q6) List only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
SELECT * FROM emp_record_table;

SELECT emp_id, CONCAT(first_name,' ', last_name) AS 'employee_name', role as 'role', dept AS 'department'
FROM emp_record_table
WHERE manager_id IS NOT NULL
ORDER BY manager_id; 


-- (Q7) Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
SELECT * FROM emp_record_table;

SELECT emp_id, CONCAT(first_name,' ', last_name) AS 'employee_name', dept AS 'department'
FROM emp_record_table
WHERE dept = 'healthcare'
UNION
SELECT emp_id, CONCAT(first_name,' ', last_name) AS 'employee_name', dept AS 'department'
FROM emp_record_table
WHERE dept = 'finance';


-- (Q8) List down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
SELECT * FROM emp_record_table;

SELECT emp_id, first_name, last_name, role, dept AS 'department', emp_rating, MAX(emp_rating) OVER (PARTITION BY dept) AS 'max_rating'
FROM emp_record_table
ORDER BY dept;


-- (Q9) Calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
SELECT * FROM emp_record_table;

SELECT MIN(salary) AS 'min_salary', MAX(salary) AS 'max_salary'
FROM emp_record_table
GROUP BY role;


-- (Q10) Assign ranks to each employee based on their experience. Take data from the employee record table.
SELECT * FROM emp_record_table;

SELECT emp_id, CONCAT(first_name,' ', last_name) AS 'emp_name', dept AS 'department', exp, 
RANK() OVER (ORDER BY exp DESC) AS emp_exp_rank
FROM emp_record_table;


-- (Q11) Create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
SELECT * FROM emp_record_table;

CREATE VIEW vw_global_high_salary_employees AS 
SELECT emp_id, first_name, last_name, country, salary
FROM emp_record_table
WHERE salary > 6000
ORDER BY country;

-- Display view
SELECT * FROM vw_global_high_salary_employees;


-- (Q12) Build a nested query to find employees with experience of more than ten years. Take data from the employee record table.
SELECT * FROM emp_record_table;

SELECT emp_id, first_name, last_name, exp
FROM ( SELECT * FROM emp_record_table
	   WHERE exp > 10
) AS experience_greater_10_years
ORDER BY exp;


-- (Q13) Create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
SELECT * FROM emp_record_table;

DELIMITER //
CREATE PROCEDURE sp_employees_3_years_exp()
BEGIN
	SELECT * FROM employee.emp_record_table 
    WHERE exp > 3 
    ORDER BY exp;
END //
DELIMITER ;

-- Trigger
CALL sp_employees_3_years_exp();


/*
(Q14) Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science 
team matches the organization’s set standard.

The standard being:
	i.	For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
	ii.	For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',
	iii. For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',
	iv.	For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',
	v.	For an employee with the experience of 12 to 16 years assign 'MANAGER'.
*/

SELECT * FROM emp_record_table;
SELECT * FROM data_science_team;
SELECT * FROM proj_table;

DELIMITER //
CREATE FUNCTION fn_validate_ds_roles(exp INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE ds_role VARCHAR(50);
    IF exp <= 2 THEN 
        SET ds_role = "JUNIOR DATA SCIENTIST";
    ELSEIF exp > 2 AND exp <= 5 THEN 
        SET ds_role = "ASSOCIATE DATA SCIENTIST";
    ELSEIF exp > 5 AND exp <= 10 THEN 
        SET ds_role = "SENIOR DATA SCIENTIST";
    ELSEIF exp > 10 AND exp <= 12 THEN 
        SET ds_role = "LEAD DATA SCIENTIST";
    ELSEIF exp > 12 AND exp <= 16 THEN 
        SET ds_role = "MANAGER";
    END IF;
    RETURN ds_role;
END //
DELIMITER ;

-- Validate Data Science Team
SELECT emp_id, first_name, last_name, fn_validate_ds_roles(2) AS 'validated_emp_role' -- Insert # of years of experience with in parentheses.
FROM data_science_team
WHERE role != fn_validate_ds_roles(2); -- Insert # of years of experience with in parentheses.


-- Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
CREATE INDEX idx_first_name 
ON emp_record_table(first_name(25));

EXPLAIN SELECT * FROM emp_record_table
WHERE first_name = 'ERIC';


-- (Q16) Write a query to calculate the bonus for all the employees, based on their ratings and salaries Use the formula: 5% of salary * employee rating.
SELECT * FROM emp_record_table;

SELECT emp_id, CONCAT(first_name,' ',last_name) AS 'employee_name', emp_rating, salary, (salary*0.05)*emp_rating AS bonus
FROM emp_record_table;



-- (Q17) Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
SELECT * FROM emp_record_table;

SELECT continent, AVG(salary) 
FROM emp_record_table
GROUP BY continent
ORDER BY continent;