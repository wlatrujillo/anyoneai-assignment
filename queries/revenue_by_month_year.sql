-- TODO: 
-- This query will return a table with the revenue by month and year. 
-- It will have different columns: 
--      month_no, with the month numbers going from 01 to 12; 
--      month, with the 3 first letters of each month (e.g. Jan, Feb); 
--      Year2016, with the revenue per month of 2016 (0.00 if it doesn't exist); 
--      Year2017, with the revenue per month of 2017 (0.00 if it doesn't exist) and 
--      Year2018, with the revenue per month of 2018 (0.00 if it doesn't exist).

-- HINTS:
-- 1. olist_order_payments has multiple entries for some order_id values. 
-- For this query, make sure to retain only the entry with minimal payment_value for each order_id.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL

select 
    STRFTIME('%m', oo.order_delivered_customer_date) as month_no,
    SUM(p.min_payment_value) as Revenue
from olist_orders oo
join (
    select 
        order_id,
        MIN(payment_value) as min_payment_value
    from olist_order_payments
    group by order_id
) p on p.order_id = oo.order_id
where oo.order_status = 'delivered'
  and oo.order_delivered_customer_date is not null
  and oo.order_delivered_customer_date  >= '2016-01-01'
  and oo.order_delivered_customer_date < '2017-01-01'
group by month_no;