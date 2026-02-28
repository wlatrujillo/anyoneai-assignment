-- TODO: 
-- This query will return a table with the top 10 revenue categories
-- in English, the number of orders and their total revenue. 
-- It will have different columns:
--      Category, that will contain the top 10 revenue categories;
--      Num_order, with the total amount of orders of each category;
--      Revenue, with the total revenue of each category.

-- HINT: 
-- All orders should have a delivered status and the Category and actual delivery date should be not null.
-- For simplicity, if there are orders with multiple product categories, consider the full order's payment_value in the summation of revenue of each category

select 
category_english,
count(1) as Num_order
FROM  
(select 
	ooi.order_id, 
    p.category_english 
	from olist_orders oo
	join olist_order_items ooi 
	on oo.order_id = ooi.order_id 
	join (
		select 
		op.product_id as product_id,
		pcnt.product_category_name_english as category_english
		from olist_products op 
		join product_category_name_translation pcnt 
		on op.product_category_name = pcnt.product_category_name
	) p on ooi.product_id = p.product_id
	where oo.order_status = 'delivered'
	and oo.order_delivered_customer_date is not null
group by ooi.order_id 
)
group by category_english
order by count(1) desc
limit 10;
