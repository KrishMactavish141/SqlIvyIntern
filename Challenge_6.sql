use ivyintership_db;
create table salary(
    employee_id int,
    name varchar(100),
    salary_per_hour_$ float
);

INSERT INTO salary(employee_id, name, salary_per_hour_$) VALUES
(1, 'Jeremy', 16.78),
(2, 'Nicole', 25.87),
(3, 'Naomi', 22.45),
(4, 'Lyanne', 19.27);

CREATE TABLE swipe (
    employee_id INT,
    activity_type VARCHAR(10),
    activity_time DATETIME
);

INSERT INTO swipe (employee_id, activity_type, activity_time) VALUES
(1, 'login', '2024-07-23 08:00:00'),
(1, 'logout', '2024-07-23 12:00:00'),
(1, 'login', '2024-07-23 13:00:00'),
(1, 'logout', '2024-07-23 17:00:00'),
(2, 'login', '2024-07-23 09:00:00'),
(2, 'logout', '2024-07-23 11:00:00'),
(2, 'login', '2024-07-23 12:00:00'),
(2, 'logout', '2024-07-23 15:00:00'),
(1, 'login', '2024-07-24 08:30:00'),
(1, 'logout', '2024-07-24 12:30:00'),
(2, 'login', '2024-07-24 09:30:00'),
(2, 'logout', '2024-07-24 10:30:00'),
(3, 'login', '2024-07-24 09:00:00'),
(3, 'logout', '2024-07-24 13:45:00'),
(3, 'login', '2024-07-24 14:30:00'),
(3, 'logout', '2024-07-24 17:30:00'),
(4, 'login', '2024-07-23 10:30:00'),
(4, 'logout', '2024-07-23 15:00:00'),
(4, 'login', '2024-07-23 16:30:00'),
(4, 'logout', '2024-07-23 19:00:00'); 

/*Q: Find the total salary of each employee on a daily basis. 
The format should be : NAME | ACTIVITY_DATE | SALARY*/



with hw as (
select employee_id, activity_date,
round(SUM(timestampdiff(minute, login_time, logout_time))/60,2) total_hours
from (select employee_id, activity_type, date(activity_time) activity_date, activity_time login_time,
lead(activity_time) over (partition by employee_id, date(activity_time) order by activity_time) logout_time
from swipe) s where activity_type = 'login'
group by employee_id, s.activity_date)
select sa.name, h.activity_date,
round(h.total_hours * sa.salary_per_hour_$,2) salary
from hw h
join salary sa on h.employee_id = sa.employee_id
order by sa.name, h.activity_date;



SELECT employee_id, activity_date,
round(SUM(TIMESTAMPDIFF(minute, login_time, logout_time))/60,2) AS total_hours
FROM (SELECT employee_id, activity_type, DATE(activity_time) AS activity_date, activity_time AS login_time,
LEAD(activity_time) OVER (PARTITION BY employee_id, DATE(activity_time) ORDER BY activity_time) AS logout_time
FROM swipe) s where activity_type = 'login'
GROUP BY employee_id, s.activity_date