use ivyintership_db;

CREATE TABLE Batches (
    batch_id VARCHAR(10),
    quantity INT
);


INSERT INTO Batches (batch_id, quantity) VALUES ('BA', 10);
INSERT INTO Batches (batch_id, quantity) VALUES ('BB', 12);
INSERT INTO Batches (batch_id, quantity) VALUES ('BC', 10);
INSERT INTO Batches (batch_id, quantity) VALUES ('BD', 16);
INSERT INTO Batches (batch_id, quantity) VALUES ('BE', 15);
INSERT INTO Batches (batch_id, quantity) VALUES ('BF', 13);
INSERT INTO Batches (batch_id, quantity) VALUES ('BG', 19);
INSERT INTO Batches (batch_id, quantity) VALUES ('BH', 10);
INSERT INTO Batches (batch_id, quantity) VALUES ('BI', 14);
INSERT INTO Batches (batch_id, quantity) VALUES ('BJ', 16);


drop table orders;
CREATE TABLE Orders (
    Order_number VARCHAR(10),
    Quantity INT
);


INSERT INTO Orders (Order_number, Quantity) VALUES ('OA', 5);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OB', 4);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OC', 2);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OD', 8);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OE', 7);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OF', 10);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OG', 12);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OH', 6);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OI', 12);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OJ', 10);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OK', 8);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OL', 16);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OM', 8);
INSERT INTO Orders (Order_number, Quantity) VALUES ('ON', 5);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OO', 3);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OP', 4);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OQ', 12);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OR', 9);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OS', 6);
INSERT INTO Orders (Order_number, Quantity) VALUES ('OT', 10);

/*
A packaging comapany is in charge of packing the orders recieved from different clients from the batches of products sent by the parent company.
Now the products are taken systematically; starting from the first batch. Only after the contents of the batch is finished, 
does they open the second batch.
You have been given two tables, the first one containing the batch_id and the content quantity in it. 
The second one is the orders table containing the order_id and the order quantity.
Find out which order in what quantity was packaged from which batch.
For example:
batches:

batch_id | Quantity
  A               5
  B               8

Orders:

order_number | Quantity
   1                         2
   2                         4
   3                         5

Output:

order_number | batch_id | quantity
  1                             A             2
  2                             A             3
  2                             B             1
  3                             B             5
*/

with batch_cte as 
        (select *, row_number() over(order by batch_id) as rn
        from (
            with recursive batch_split as
                (select batch_id, 1 as quantity from batches
                union all
                select b.batch_id, (cte.quantity+1) as quantity
                from batch_split cte
                join batches b on b.batch_id = cte.batch_id and b.quantity > cte.quantity)
            select batch_id, 1 as quantity
            from batch_split) x),
    order_cte as
        (select *, row_number() over(order by order_number) as rn
        from (
            with recursive order_split as
                (select order_number, 1 as quantity from orders
                union all
                select o.order_number, (cte.quantity+1) as quantity
                from order_split cte
                join orders o on o.order_number = cte.order_number and o.quantity > cte.quantity)
            select order_number, 1 as quantity
            from order_split) x)
select o.order_number, b.batch_id, sum(o.quantity) as quantity
from order_cte o
left join batch_cte b on o.rn = b.rn
group by o.order_number, b.batch_id
order by o.order_number, b.batch_id;