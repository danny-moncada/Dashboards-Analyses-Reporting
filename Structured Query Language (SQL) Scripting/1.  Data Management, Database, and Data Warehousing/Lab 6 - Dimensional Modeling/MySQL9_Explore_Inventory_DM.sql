-- Explore_01: Explore the difference between units ordered 
-- and units shipped by product category during 2028 for 
-- warehouses in the state of Washington
select product_category, sum(units_ordered) as total_units_ordered, sum(units_shipped) as total_units_shipped,   
sum(units_shipped) - sum(units_ordered) as diff_unit_order_shipp
from inventory_facts i
inner join date_dimension  d
on i.date_key = d.date_key
inner join product_dimension p
on i.product_key = p.product_key
inner join warehouse_dimension w
on i.warehouse_key = w.warehouse_key

where w.wa_state_province = 'WA'
and d.the_year = '2028'
group by product_category
order by product_category;

-- Explore_02: Examine the number of warehouse sales and average 
-- sales dollar volume by store country and state for food items 
-- broken by product department during 2028
select store_country, store_state, product_department, count(warehouse_sales) as num_warehouse_sales, round(avg(warehouse_sales), 2) as avg_warehouse_sales
from inventory_facts i
inner join date_dimension  d
on i.date_key = d.date_key
inner join product_dimension p
on i.product_key = p.product_key
inner join store_dimension s
on i.store_key = s.store_key
inner join warehouse_dimension w
on i.warehouse_key = w.warehouse_key

where product_family = 'Food'
and d.the_year = '2028'
group by store_country, store_state, product_department
order by store_country, store_state, product_department;

-- Explore_03: Examine total store invoices for beverages by 
-- store and month during 2028

select store_name, month_of_year, the_month, sum(store_invoice) as total_store_invoices
from inventory_facts i
inner join date_dimension  d
on i.date_key = d.date_key
inner join product_dimension p
on i.product_key = p.product_key
inner join store_dimension s
on i.store_key = s.store_key
inner join warehouse_dimension w
on i.warehouse_key = w.warehouse_key

where product_department = 'Beverages'
and d.the_year = '2028'
group by store_name, month_of_year, the_month
order by cast(substring(s.store_name, 7, 2) as int), month_of_year;