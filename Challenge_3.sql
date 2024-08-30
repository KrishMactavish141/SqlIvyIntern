use ivyintership_db;
/*Q: List the employees who have the second highest salary and the third lowest salary in their respective departments.     
Give the answers in a single table. The format of the table should be,
department_name | second_highest | third_lowest*/

with emp1 as(
select d.name department_name, e.name employee_name, 
dense_rank() over (partition by e.department_id order by e.salary desc) rnk1,
dense_rank() over (partition by e.department_id order by e.salary asc) rnk2
from department d inner join employee e on d.id=e.department_id),
emp2 as(
select d.name department_name, count(e.name) as cnt
from department d inner join employee e on d.id=e.department_id
group by d.name)
select  e1.department_name, 
max(case when e1.rnk1= 2 and e2.cnt>1 then employee_name  when e2.cnt<2 then employee_name end) second_highest,
max(case when e1.rnk2=3  and e2.cnt>1 then employee_name  when e2.cnt<3 then employee_name end) third_lowest
from emp1 e1 inner join emp2 e2 on e1.department_name=e2.department_name
group by department_name;

WITH emp1 AS (
    SELECT d.name AS department_name, e.name AS employee_name, 
           DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS rnk1,
           DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary ASC) AS rnk2
    FROM department d 
    INNER JOIN employee e ON d.id = e.department_id
),
emp2 AS (
    SELECT d.name AS department_name, COUNT(e.name) AS cnt
    FROM department d 
    INNER JOIN employee e ON d.id = e.department_id
    GROUP BY d.name
)
SELECT  
    e1.department_name, 
    MAX(CASE 
            WHEN e1.rnk1 = 2 THEN e1.employee_name 
            WHEN e2.cnt = 1 THEN e1.employee_name 
        END) AS second_highest,
    MAX(CASE 
            WHEN e1.rnk2 = 3 THEN e1.employee_name 
            WHEN e2.cnt = 1 THEN e1.employee_name 
            WHEN e2.cnt = 2 AND e1.rnk2 = 2 THEN e1.employee_name 
        END) AS third_lowest
FROM emp1 e1 
INNER JOIN emp2 e2 ON e1.department_name = e2.department_name
GROUP BY e1.department_name, e2.cnt;