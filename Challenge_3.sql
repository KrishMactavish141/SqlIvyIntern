use ivyintership_db;
/*Q: List the employees who have the second highest salary and the third lowest salary in their respective departments.     
Give the answers in a single table. The format of the table should be,
department_name | second_highest | third_lowest*/

with cte as (
select e.name, d.name dept, salary, dense_rank() over (partition by d.name order by salary desc) as rank_desc
from employee e inner join department d on e.department_id = d.id
group by 1,2,3),
cte2 as (select e.name, d.name dept, salary,
dense_rank() over (partition by d.name order by salary asc) as rank_asc
from employee e inner join department d on e.department_id = d.id
group by 1,2,3)
select c.dept department, c.name , d.name from Cte c inner join cte2 d on d.dept = c.dept
where rank_desc =2 and rank_asc =3;
