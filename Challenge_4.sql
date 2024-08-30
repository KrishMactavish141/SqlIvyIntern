use ivyintership_db;

CREATE TABLE vehicle (
    ID INT PRIMARY KEY,
    Capacity INT);


INSERT INTO vehicle (ID, Capacity) VALUES
(1, 550),
(2, 650),
(3, 500),
(4, 600);


CREATE TABLE packages (
    ID INT PRIMARY KEY,
    Weight INT,
    vehicle_ID INT,
    FOREIGN KEY (vehicle_ID) REFERENCES vehicle(ID)
);


INSERT INTO packages (ID, Weight, vehicle_ID) VALUES
(1, 55, 1),
(2, 60, 1),
(3, 65, 2),
(4, 70, 2),
(5, 75, 3),
(6, 80, 3),
(7, 85, 4),
(8, 90, 4),
(9, 95, 1),
(10, 100, 2),
(11, 52, 3),
(12, 57, 4),
(13, 62, 1),
(14, 67, 2),
(15, 72, 3),
(16, 77, 4),
(17, 82, 1),
(18, 87, 2),
(19, 92, 3),
(20, 97, 4),
(21, 54, 1),
(22, 59, 2),
(23, 64, 3),
(24, 69, 4),
(25, 74, 1),
(26, 79, 2),
(27, 84, 3),
(28, 89, 4),
(29, 94, 1),
(30, 99, 2);

INSERT INTO vehicle (ID, Capacity) VALUES
(1, 550),
(2, 650),
(3, 500),
(4, 700);

INSERT INTO packages (ID, Weight, vehicle_ID) VALUES
(31, 84, 3);
INSERT INTO packages (ID, Weight, vehicle_ID) VALUES
(32, 57, 4);
INSERT INTO packages (ID, Weight, vehicle_ID) VALUES
(33, 92, 3);

/*Q: Write a query to find a comma separated list of all the packages that each vehicle can carry without exceeding its capacity.
The packages should be in ascending order of their weight.
Your result output should have the columns, vehicle_id, packages.
eg: Vehicle_id | Packages
         1                 4, 6, 8, 10*/


with pkg1 as (select vehicle_id, id, weight, 
sum(weight) over (partition by vehicle_id order by weight) cw 
from packages)
select vehicle_id, group_concat(id order by weight asc, id asc separator ',') packages
from pkg1
where cw <= (select capacity from vehicle where id = vehicle_id)
group by vehicle_id
order by vehicle_id asc;

with pkg1 as (select vehicle_id, id, weight, 
sum(weight) over (partition by vehicle_id order by weight, id) cw
from packages),
pkg2 as (select p1.vehicle_id, p1.id, p1.weight, p1.cw,
case when p1.weight = p2.weight then p1.id
else null end as smallest_id
from pkg1 p1 left join 
(select vehicle_id, weight, min(id) smallest_id from packages group by vehicle_id, weight) p2
on p1.vehicle_id = p2.vehicle_id and p1.weight = p2.weight)
select p.vehicle_id, group_concat(p.id order by p.weight asc, p.id asc separator ',') packages
from pkg2 p join vehicle v on p.vehicle_id = v.id
where p.cw <= v.capacity and (p.smallest_id is null or p.id = p.smallest_id)
group by p.vehicle_id
order by p.vehicle_id asc;

WITH CTE AS (
SELECT p.ID, p.Weight, p.vehicle_ID, v.Capacity, SUM(p.Weight) OVER (PARTITION BY p.vehicle_ID ORDER BY p.Weight) AS CumulativeWeight
FROM packages p INNER JOIN vehicle v ON p.vehicle_ID = v.ID
)
SELECT vehicle_ID, GROUP_CONCAT(ID ORDER BY weight ASC) AS packages
FROM CTE
WHERE CumulativeWeight <= Capacity
GROUP BY vehicle_ID
ORDER BY vehicle_ID;