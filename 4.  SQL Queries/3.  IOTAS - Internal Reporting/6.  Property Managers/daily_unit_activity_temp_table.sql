INSERT INTO "external_property_managers"."daily_unit_activity_temp_table"
with
full_unit_activity as (select date, unit_id FROM
"full_unit_activity"
group by date, unit_id),

full_unit_activity_by_building as (select b.id as building_id, 
dau.unit_count as daily_active_units, 
mau.unit_count as monthly_active_units 
FROM building b 
left join (select building_id, count(*) as unit_count 
FROM full_unit_activity fua 
JOIN unit u on u.id = fua.unit_id 
where fua.date = DATE(dateadd(DAY, -1, GETDATE())) 
group by building_id) dau on b.id = dau.building_id 
left join (select building_id, count(*) as unit_count 
FROM (select distinct building_id, unit_id 
FROM full_unit_activity fua JOIN unit u on u.id = fua.unit_id 
WHERE date  > DATE(dateadd(DAY, -30, GETDATE()) ) ) group by building_id) as mau on mau.building_id = b.id)

select 
DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
fun.monthly_active_units as full_monthly_active_units, 
fun.daily_active_units as full_daily_active_units
FROM  building b
left join full_unit_activity_by_building fun on b.id = fun.building_id 
ORDER BY date, building_id;