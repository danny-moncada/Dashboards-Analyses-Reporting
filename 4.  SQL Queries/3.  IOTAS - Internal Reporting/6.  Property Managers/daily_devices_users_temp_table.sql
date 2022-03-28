INSERT INTO "external_property_managers"."daily_devices_users_temp_table"

  with devices as (select b.id as building_id, count(*) as devices from device d, 
room r, unit u, building b 
where b.id = u.building_id 
and u.id = r.unit_id 
and r.id = d.room_id 
and d.physical_device_id is not null 
group by b.id),

users as (select u.building_id, sum(CASE WHEN a.password is not null THEN 1 ELSE 0 END) as registered_users, count(*) as users 
from account a, resident r, unit u 
where a.id = r.account_id 
and r.unit_id = u.id 
and r.suspended_at is null 
and a.email not like '%@iotas%' 
group by u.building_id)

SELECT DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
d.devices,
us.users, 
us.registered_users
FROM building b 
left join devices d on b.id = d.building_id 
left join users us on us.building_id = b.id 
ORDER BY building_id