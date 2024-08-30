use ivyintership_db;
create table ropeway_stations
(
    id integer not null unique,
    name varchar(40) not null unique,
    altitude integer not null
);


insert into ropeway_stations values
(1, 'Girijesh', 1900),
(2, 'Gandhamadhan', 2100),
(3, 'Himadri', 1600),
(4, 'Indrakeel', 782),
(5, 'Nagaja', 1370);


create table stations
(
    point1 integer not null,
    point2 integer not null
);


insert into stations values
(1, 3),
(3, 2),
(3, 5),
(4, 5),
(1, 5);

/*A company has taken a project to build a road in the mountains. Now, the rocks that is being extracted from 
blasting the mountains will be used for another project by the same company, which is running simultaneously. 
So the company has planned to transport the rocks using a ropeway network that is already in use. 
You have been given a list of points where ropeway stations are present as well as their height. 
Another table shows you the connected points that are already in place. 
The transportation route needs a starting point, a middle point and and end point, where the starting point altitude is higher 
than the middle point which will be higher than the end point.

* Each entry in the table stations represents a direct connection between stations with IDs point1 and
point2. Note that all routes are bidirectional.
* Create a query that finds all triplets(startpt, middlept, endpt) representing the ropeway stations
that may be used for the transportations of the rocks.
* Output returned by the query can be ordered in any way.

Assume that:
 for every two stations there is at most one direct route connecting them;
 each point from table stations occurs in table ropeway_stations;*/



select r1.name startpt, r2.name middlept, r3.name endpt
from ropeway_stations r1 join stations s1 on (r1.id = s1.point1 or r1.id = s1.point2)
join ropeway_stations r2 on (r2.id = s1.point1 or r2.id = s1.point2) and r2.id <> r1.id
join stations s2 on (r2.id = s2.point1 or r2.id = s2.point2)
join ropeway_stations r3 on (r3.id = s2.point1 or r3.id = s2.point2) and r3.id <> r2.id
where r1.altitude > r2.altitude and r2.altitude > r3.altitude;
