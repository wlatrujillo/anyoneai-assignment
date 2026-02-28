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

WITH months AS (
	SELECT '01' AS month_no
	UNION ALL SELECT '02'
	UNION ALL SELECT '03'
	UNION ALL SELECT '04'
	UNION ALL SELECT '05'
	UNION ALL SELECT '06'
	UNION ALL SELECT '07'
	UNION ALL SELECT '08'
	UNION ALL SELECT '09'
	UNION ALL SELECT '10'
	UNION ALL SELECT '11'
	UNION ALL SELECT '12'
),
payments AS (
	SELECT
		order_id,
		MIN(payment_value) AS payment_value
	FROM olist_order_payments
	GROUP BY order_id
),
revenue_by_month AS (
	SELECT
		strftime('%m', oo.order_purchase_timestamp) AS month_no,
		strftime('%Y', oo.order_purchase_timestamp) AS year_no,
		SUM(p.payment_value) AS revenue
	FROM olist_orders oo
	INNER JOIN payments p
		ON oo.order_id = p.order_id
	WHERE oo.order_status = 'delivered'
	  AND oo.order_delivered_customer_date IS NOT NULL
	GROUP BY month_no, year_no
)
SELECT
	m.month_no,
	CASE m.month_no
		WHEN '01' THEN 'Jan'
		WHEN '02' THEN 'Feb'
		WHEN '03' THEN 'Mar'
		WHEN '04' THEN 'Apr'
		WHEN '05' THEN 'May'
		WHEN '06' THEN 'Jun'
		WHEN '07' THEN 'Jul'
		WHEN '08' THEN 'Aug'
		WHEN '09' THEN 'Sep'
		WHEN '10' THEN 'Oct'
		WHEN '11' THEN 'Nov'
		WHEN '12' THEN 'Dec'
	END AS month,
	COALESCE(SUM(CASE WHEN rbm.year_no = '2016' THEN rbm.revenue END), 0.00) AS Year2016,
	COALESCE(SUM(CASE WHEN rbm.year_no = '2017' THEN rbm.revenue END), 0.00) AS Year2017,
	COALESCE(SUM(CASE WHEN rbm.year_no = '2018' THEN rbm.revenue END), 0.00) AS Year2018
FROM months m
LEFT JOIN revenue_by_month rbm
	ON m.month_no = rbm.month_no
GROUP BY m.month_no
ORDER BY m.month_no;