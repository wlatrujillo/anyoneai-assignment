-- TODO: 
-- This query will return a table with two columns: State and Delivery_Difference. 
-- The first one will have the letters that identify the states, 
-- and the second one the average difference between the estimated delivery date 
-- and the date when the items were actually delivered to the customer.

-- HINTS:
-- 1. You can use the julianday function to convert a date to a number.
-- 2. You can use the CAST function to convert a number to an integer.
-- 3. You can use the STRFTIME function to convert a order_delivered_customer_date to a string removing hours, minutes and seconds.
-- 4. order_status == 'delivered' AND order_delivered_customer_date IS NOT NULL

select 
    oc.customer_state as State, 
    cast(
        avg(
            julianday(STRFTIME('%Y-%m-%d', oo.order_estimated_delivery_date)) - 
            julianday(STRFTIME('%Y-%m-%d', oo.order_delivered_customer_date))
        ) as integer
    ) as Delivery_Difference
from olist_customers oc 
inner join olist_orders oo 
    on oc.customer_id = oo.customer_id 
where oo.order_status = 'delivered'
    and oo.order_delivered_customer_date IS NOT NULL
group by oc.customer_state;