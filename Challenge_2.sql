use ivyintership_db;
/*Q: Find out the names of the departments which has less than 2 employees. 
The final result table should have department_name and count_of_employees.*/
select d.name department_name, count(department_id) count_of_employees
from department d left join employee e on d.id = e.department_id
group by d.name
having count(department_id) <2;
