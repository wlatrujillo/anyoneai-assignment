-- TODO: 
-- This query will return a table with two columns: order_status and Amount. 
-- The first one will have the different order status classes 
-- and the second one the total amount of each.


select 
    oo.order_status as order_status, 
    count(1) as Amount
from olist_orders oo 
    group by oo.order_status; 