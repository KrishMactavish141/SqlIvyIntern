Create database IvyIntership_DB;
use IvyIntership_DB;
CREATE TABLE Department (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    joining_date DATE NOT NULL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES Department(id)
);

INSERT INTO Department (id, name)
VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Marketing'),
(4, 'Sales'),
(5, 'IT'),
(6, 'Finance'),
(7, 'Graphic Designer'),
(8, 'Data Analyst');

INSERT INTO Employee (id, name, salary, joining_date, department_id)
VALUES
(1, 'Alice', 70000, '2020-01-15', 1),
(2, 'Bob', 85000, '2019-03-22', 2),
(3, 'Charlie', 60000, '2021-05-18', 1),
(4, 'David', 95000, '2018-07-11', 3),
(5, 'Eva', 80000, '2017-09-09', 2),
(6, 'Frank', 75000, '2016-11-14', 3),
(7, 'Grace', 90000, '2015-02-23', 1),
(8, 'Henry', 68000, '2021-04-30', 2),
(9, 'Irene', 72000, '2020-06-25', 1),
(10, 'Jack', 78000, '2019-08-19', 3),
(11, 'Karen', 83000, '2018-10-07', 4),
(12, 'Leo', 95000, '2017-12-13', 1),
(13, 'Mona', 87000, '2016-03-21', 2),
(14, 'Nick', 63000, '2015-05-29', 5),
(15, 'Olivia', 77000, '2014-07-15', 1),
(16, 'Peter', 82000, '2021-01-18', 2),
(17, 'Quinn', 91000, '2020-03-12', 6),
(18, 'Rachel', 88000, '2019-09-28', 1),
(19, 'Steve', 93000, '2018-11-06', 2),
(20, 'Tina', 76000, '2017-04-16', 3);

/* Based on the above information, find the total salary for each department. 
Your result table should have department_name and total_salary columns.*/
select d.name `Department Name`, ifnull(sum(e.salary),0) `Total Salary`
from Department d left join Employee e on d.id = e.department_id
group by d.name
order by `Total Salary` desc;