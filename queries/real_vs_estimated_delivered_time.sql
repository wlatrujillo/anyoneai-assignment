-- TODO: 
-- This query will return a table with the differences between the real 
-- and estimated delivery times by month and year. 
-- It will have different columns: 
--      month_no, with the month numbers going FROM 01 to 12; 
--      month, with the 3 first letters of each month (e.g. Jan, Feb); 
--      Year2016_real_time, with the average delivery time per month of 2016 (NaN if it doesn't exist); 
--      Year2017_real_time, with the average delivery time per month of 2017 (NaN if it doesn't exist); 
--      Year2018_real_time, with the average delivery time per month of 2018 (NaN if it doesn't exist); 
--      Year2016_estimated_time, with the average estimated delivery time per month of 2016 (NaN if it doesn't exist); 
--      Year2017_estimated_time, with the average estimated delivery time per month of 2017 (NaN if it doesn't exist) and 
--      Year2018_estimated_time, with the average estimated delivery time per month of 2018 (NaN if it doesn't exist).

-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL
-- 3. Take distinct order_id.


select 
    STRFTIME('%m', oo.order_approved_at ) as month_no,
    avg(
        julianday(STRFTIME( oo.order_delivered_customer_date  )) - 
        julianday(STRFTIME( oo.order_purchase_timestamp ))
    ) as real_time,
    avg(
        julianday(STRFTIME( oo.order_estimated_delivery_date )) - 
        julianday(STRFTIME( oo.order_purchase_timestamp ))
    ) as estimated_time
from olist_orders oo 
where oo.order_status = 'delivered'
and oo.order_delivered_customer_date is not null
and oo.order_delivered_customer_date  >= '2016-01-01'
and oo.order_delivered_customer_date < '2017-01-01'
group by month_no

