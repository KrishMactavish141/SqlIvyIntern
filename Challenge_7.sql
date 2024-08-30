use ivyintership_db;
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255)
);


INSERT INTO Product (product_id, product_name) VALUES
(1, 'Mouse'),
(2, 'Keyboard'),
(3, 'Ram'),
(4, 'Processor'),
(5, 'Graphic Card');



CREATE TABLE DSales (
    product_id INT,
    period_start DATE,
    period_end DATE,
    average_daily_sales INT,
    PRIMARY KEY (product_id, period_start, period_end),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);

INSERT INTO dSales (product_id, period_start, period_end, average_daily_sales) VALUES
(1, '2018-11-15', '2019-01-15', 120),
(2, '2019-03-01', '2019-03-31', 80),
(5, '2020-01-01', '2020-12-31', 5),
(4, '2018-07-01', '2018-12-31', 70),
(3, '2019-06-15', '2020-01-15', 120),
(1, '2020-02-01', '2020-06-30', 120),
(2, '2020-07-01', '2020-12-31', 80),
(3, '2019-08-01', '2019-12-31', 45),
(4, '2019-01-01', '2019-06-30', 25),
(5, '2018-10-01', '2019-03-31', 15);

INSERT INTO dSales (product_id, period_start, period_end, average_daily_sales) VALUES
(2, '2019-04-01', '2019-04-27', 70);

delete from DSales
where product_id = 2 and average_daily_sales = 70;

/*Write an SQL query to report the Total sales amount of each item for each year,
with corresponding product name, product_id, product_name and report_year.
Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.*/


WITH spd AS (SELECT s.product_id, p.product_name, s.period_start,
LEAST(s.period_end, DATE(CONCAT(YEAR(s.period_start), '-12-31'))) AS period_end, s.average_daily_sales,
YEAR(s.period_start) AS report_year
FROM DSales s JOIN Product p ON s.product_id = p.product_id
WHERE s.period_start >= '2018-01-01' AND s.period_start <= '2020-12-31'
UNION ALL
SELECT s.product_id,p.product_name,
GREATEST(s.period_start, DATE(CONCAT(YEAR(s.period_end), '-01-01'))) AS period_start,
s.period_end, s.average_daily_sales, YEAR(s.period_end) AS report_year
FROM DSales s JOIN Product p ON s.product_id = p.product_id
WHERE s.period_end >= DATE(CONCAT(YEAR(s.period_start) + 1, '-01-01')))
SELECT product_id, product_name, report_year, 
SUM((DATEDIFF(period_end, period_start) + 1) * average_daily_sales) AS total_amount
FROM spd
GROUP BY product_id, product_name, report_year
ORDER BY product_id, report_year;



with spd as (select s.product_id, p.product_name, s.period_start,
least(s.period_end, date(concat(year(s.period_start), '-12-31'))) period_end,
s.average_daily_sales, year(s.period_start) report_year
from DSales s join product p on s.product_id = p.product_id
where s.period_start >= '2018-01-01' and s.period_start <= '2020-12-31'
union all
select s.product_id, p.product_name,
greatest(s.period_start, DATE(CONCAT(YEAR(s.period_end), '-01-01'))) period_start,
s.period_end, s.average_daily_sales, year(s.period_end) report_year
from DSales s join product p on s.product_id = p.product_id
where s.period_end >= date(concat(year(s.period_start) + 1, '-01-01')))
select product_id, product_name, report_year, period_start, period_end,
sum((datediff(period_end, period_start) + 1) * average_daily_sales) total_amount
from spd
group by product_id, product_name, report_year, period_start, period_end, average_daily_sales
order by product_id, report_year, period_start;