
----------------------------     Q1    --------------------------------
-- Display the employee number, full employee name, job and hire date of all
-- employees hired in May or November of any year, with the most recently hired 
-- employees displayed first.

-- solutions:
SELECT 
        employee_id AS "Employee Number", 
        substr(last_name ||', '|| first_name, 1, 25) AS "Full Name", 
        job_id AS "Job", 
        to_char(last_day(hire_date), '[Mon Ddth "of" yyyy]') AS "Start Date"
    FROM employees
    WHERE extract(month FROM hire_date) IN (5,11)
        AND extract(year FROM hire_date) NOT IN (2015, 2016)
    ORDER BY hire_date DESC;
 

----------------------------     Q2    --------------------------------
-- List the employee number, full name, job and the modified salary for all employees 
-- whose monthly earning (without this increase) is outside the range $6,000 � $11,000 
-- and who are employed as Vice Presidents or Managers

-- solutions:
SELECT 
        'Emp# '|| employee_id ||' named ' || first_name||' '||last_name || ' who is ' || job_id ||
        ' will have a new salary of $' || round(
            CASE
                WHEN job_id LIKE '%_VP' THEN (salary*1.25)
                WHEN job_id LIKE '%_M%' THEN (salary*1.18)
                ELSE salary
            END
            ) AS "Employees with increased Pay"
    FROM employees
    WHERE (salary NOT BETWEEN 6000 AND 11000)
        AND (job_id LIKE '%_M%' OR job_id LIKE '%_VP')
    ORDER BY salary DESC;


----------------------------     Q3    --------------------------------
-- Display the employee last name, salary, job title and manager# of all employees not earning a commission OR if they 
-- work in the SALES department, but only  if their total monthly salary with $1000 included bonus and  commission (if  earned) 
-- is  greater  than  $15,000.  

-- solutions:
SELECT
       last_name AS "Last Name",
       salary AS "Salary",
       job_id AS "Job Title",
       nvl(to_char(manager_id), 'NONE') AS "Manager#",
       to_char((salary + 1000) * 12 * (1 + nvl(commission_pct, 0)), '$999,999.99')  AS "Total Income"
    FROM employees 
    WHERE 
        commission_pct IS NULL 
        OR (department_id IN(80) AND (salary + 1000) * (1 + NVL(commission_pct, 0)) > 15000 )
    ORDER BY salary DESC;


--prof
SELECT   last_name,salary, job_id,  
     decode(e.manager_id,NULL,'NONE', e.manager_id)  "Manager#",
                 to_char(12*(salary + 1000) +12*salary* NVL(commission_pct,0),'$999,999.00') 
                  "Total Income"
FROM    employees  e  JOIN  departments  d  USING (department_id)
 WHERE  (commission_pct is null or UPPER(department_name) ='SALES')
 AND     salary*(1+ NVL(commission_pct,0)) + 1000 > 15000
 ORDER BY 5 DESC;

----------------------------     Q4    --------------------------------
-- Display Department_id, Job_id and the Lowest salary for this combination under the alias Lowest Dept/Job Pay, but only if 
-- that Lowest Pay falls in the range $6000 - $17000. Exclude people who work as some kind of Representative job from this 
-- query and departments IT and SALES as well.

-- solutions:
SELECT department_id || ', ' || job_id || ', ' || to_char(min(salary), '$999,999.99') AS "Lowest Dept/Job Pay"
    FROM employees
    WHERE salary BETWEEN 6000 AND 17000  
        AND upper(job_id) NOT LIKE '%REP'
        AND upper(job_id) NOT LIKE 'SA%'
        AND upper(job_id) NOT LIKE 'IT%'
    GROUP BY department_id, job_id
    ORDER BY department_id, job_id;
 
-- prof 
SELECT department_id, job_id, MIN(salary) "Lowest Dept/Job Pay"
FROM employees JOIN  departments
USING (department_id)
WHERE UPPER(job_id) NOT LIKE '%REP%'
AND UPPER(department_name) NOT IN ('IT','SALES')
GROUP BY  department_id, job_id 
HAVING MIN(salary) BETWEEN 6000 AND 18000
ORDER BY  department_id, job_id;


----------------------------     Q5    --------------------------------
-- Display last_name, salary and job for all employees who earn more than all lowest paid employees per department outside the 
-- US locations. Exclude President and Vice Presidents from this query. Sort the output by job title ascending. You need to use 
-- a Subquery and Joining

-- solutions:
SELECT 
        last_name AS "Last Name", 
        to_char(salary, '$99,999.99') AS "Salary", 
        job_id AS "Job ID"
	FROM employees
	WHERE upper(job_id) NOT LIKE '%VP%' AND upper(job_id) NOT LIKE '%PRES%'
    	AND salary > ALL (
        	SELECT min(salary)
            	FROM employees
            	WHERE department_id IN (
                	SELECT department_id
                    	FROM locations JOIN departments USING (location_id)
                    	WHERE upper(country_id) NOT IN ('US')
                	)
            	GROUP BY department_id
    	)
	ORDER BY job_id;



----------------------------     Q6    --------------------------------
-- Who are the employees (show last_name, salary and job) who work either in IT or MARKETING department and earn more than the 
-- worst paid person in the ACCOUNTING department. Sort the output by the last name alphabetically. You need to use ONLY the 
-- Subquery method (NO joins allowed).

-- solutions:
SELECT 
        last_name AS "Last Name", 
        to_char(salary, '$99,999.99') AS Salary, 
        job_id AS "JOB"
	FROM employees
	WHERE department_id IN (
    	SELECT department_id
        	FROM departments
        	WHERE upper(department_name) IN ('IT','MARKETING')
	) AND salary > (
    	SELECT min(salary)
        	FROM employees
        	WHERE department_id = (
            	SELECT department_id
                	FROM departments
                	WHERE upper(department_name) = 'ACCOUNTING'
        	)
	)
	ORDER BY last_name;


----------------------------     Q7    --------------------------------
-- Display alphabetically the full name, job, salary (formatted as a currency amount incl. thousand separator, but no decimals) 
-- and department number for each employee who earns less than the best paid unionized employee (i.e. not the president nor any 
-- manager nor any VP), and who work in either SALES or MARKETING department.  

-- solutions:
SELECT 
        substr(first_name || ' ' || last_name, 0, 25) AS "Employee" , 
        job_id AS "Job ID", 
        lpad(to_char(salary, '$999,999'), 15, '=')  AS "Salary", 
        department_id AS "Department ID"
    FROM employees
    WHERE department_id IN (80,20)
        AND salary < (
            SELECT max(salary) AS salaryMax 
                FROM employees 
                WHERE job_id NOT LIKE('%VP') AND job_id NOT LIKE('%PRES')  
                    AND employee_id NOT IN(
                        SELECT nvl(manager_id, 0) 
                        FROM departments
                )
        ) 
        AND employee_id NOT IN(
            SELECT nvl(manager_id, 0) FROM departments
        )
    ORDER BY "Employee";


----------------------------     Q8    --------------------------------
-- Display department name, city and number of different jobs in each department. If city is null, you should print Not 
-- Assigned Yet.

-- solutions:
SELECT 
        department_name AS "Department Name", 
        substr(nvl(city, 'Not Assigned Yet'), 0, 24) AS "City", 
        count(DISTINCT(job_id)) AS "# of Jobs"
    FROM employees FULL JOIN departments USING (department_id)
        FULL JOIN locations USING (location_id)
    GROUP BY department_name, city
    ORDER BY "# of Jobs" DESC;

--prof
SELECT  d.department_name, 
    SUBSTR(NVL(l.city,'Not Assigned'),1,25) AS "City",
    COUNT(DISTINCT(job_id)) AS "# of Jobs"
FROM employees e LEFT OUTER JOIN departments d
ON e.department_id  = d.department_id
FULL OUTER JOIN locations l
ON d.location_id = l.location_id
GROUP BY d.department_name, l.city
ORDER  BY department_name;

----------------------------------------------------------------
-- END OF FILE
----------------------------------------------------------------