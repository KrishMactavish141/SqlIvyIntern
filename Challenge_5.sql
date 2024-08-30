use ivyintership_db;

alter table sales
add column p_date date;
set sql_safe_updates = 0;
update sales
set p_date = cast(trim(purchased_date) as date);
alter table sales
drop column  purchased_date;

alter table sales
add column cars text;
update sales
set cars = trim(make);
alter table sales
drop column  make;

/*Q: Find the total bonus received by each salesman in each quarter.
The final query should have the name of the salesperson in rows and quarters in columns.
Format : name| q1 | q2 | q3 | q4*/
with swb as (select s.salesman_id, sp.name,
case when s.cars = 'Honda' then 200 when s.cars = 'Ford' then 350
when s.cars = 'Audi' then 400 when s.cars = 'Nissan' then 120
when s.cars = 'Toyota' then 270 when s.cars = 'BMW' then 600
when s.cars = 'Mercedes' then 590
else 0 end as cars_bonus, s.cost_$,
case when month(s.p_date) in (1, 2, 3) then 'q1'
when month(s.p_date) in (4, 5, 6) then 'q2' 
when month(s.p_date) in (7, 8, 9) then 'q3'
when month(s.p_date) in (10, 11, 12) then 'q4' end as quarter
from Sales s join Salesman sp on s.salesman_id = sp.salesman_id),
Bn as (select name, quarter, sum(cost_$) total_sales, sum(cars_bonus) totalcars_bonus,
case when (quarter = 'q1' and sum(cost_$) >= 100000) or (quarter = 'q2' and sum(cost_$) >= 60000) or
(quarter = 'q3' and sum(cost_$) >= 1000000) or (quarter = 'q4' and sum(cost_$) >= 1000000)
then sum(cost_$) * 0.10 + sum(cars_bonus) else sum(cars_bonus) end as overall_bonus
from swb group by 1, 2)
select name, max(case when quarter = 'q1' then overall_bonus else 0 end) q1,
max(case when quarter = 'q2' then overall_bonus else 0 end) q2,
max(case when quarter = 'q3' then overall_bonus else 0 end) q3,
max(case when quarter = 'q4' then overall_bonus else 0 end) q4
from Bn group by 1;