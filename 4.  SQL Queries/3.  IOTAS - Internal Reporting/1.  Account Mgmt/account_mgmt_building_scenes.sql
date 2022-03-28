INSERT INTO "iotas_account_mgmt"."building_scene_plays_provisioning_residents_daily"


WITH temp_table_1 AS (select building_id, total_scenes_played_last_30_days, all_unit_actions_last_30_days
    FROM (
    SELECT building_id, NVL(sum(scenes_played),0) as total_scenes_played_last_30_days, NVL(sum(api_events), 0) as all_unit_actions_last_30_days
 FROM "external_property_managers"."building_daily_stats"
WHERE date BETWEEN DATEADD(DAY, -30, GETDATE()) AND GETDATE()
GROUP BY building_id
ORDER BY building_id)
), 

temp_table_2 AS (SELECT building_id,
SUM(CASE WHEN installation_status = 'Provisioned' THEN 1 ELSE 0 END) as provisioned_units,
SUM(CASE WHEN installation_status = 'Provisioning Incomplete' THEN 1 ELSE 0 END) as provisioning_incomplete,
SUM(CASE WHEN installation_status = 'Unprovisioned' THEN 1 ELSE 0 END) as unprovisioned_units
FROM 
(
select b.id as building_id,
CASE WHEN h.id is null THEN 'Unprovisioned' WHEN t.total_devices = t.paired_devices THEN 'Provisioned' ELSE 'Provisioning Incomplete' END as installation_status,
CASE WHEN h.last_alive IS NOT NULL AND h.last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN 'Online' ELSE 'Offline' END as hub_status
from 
  building b
  join unit u on u.building_id = b.id
  left join (select u.building_id, u.id as unit_id, count(*) as total_devices, sum(CASE WHEN d.physical_device_id is null THEN 0 ELSE 1 END) as paired_devices
  from 
  unit u
  join hub h on h.unit_id = u.id
  join room r on r.unit_id = u.id
  join device d on d.room_id = r.id group by u.id, u.building_id) t on t.unit_id = u.id
  left join hub h on h.unit_id = u.id
) 
GROUP BY building_id),

temp_table_3 AS (select 
building_id, round(count(CASE WHEN a.password is null THEN 'Unregistered' ELSE 'Registered' END) / count(distinct u.id), 2) as residents_per_occupied_unit
from
  building b
  join unit u on u.building_id = b.id
  left join resident r on u.id = r.unit_id 
  left join account a on a.id = r.account_id 
where r.suspended_at is null and a.email not like '%iotashome%' and r.tenant = 'true'
GROUP BY building_id)

SELECT DATE(DATEADD(DAY, -1, GETDATE())) as date, 
b.id, t1.total_scenes_played_last_30_days, t1.all_unit_actions_last_30_days,
t2.provisioned_units, t2.provisioning_incomplete, t2.unprovisioned_units, 
t3.residents_per_occupied_unit 
FROM building b
LEFT JOIN temp_table_1 t1 ON b.id = t1.building_id
LEFT JOIN temp_table_2 t2 ON t1.building_id = t2.building_id
LEFT JOIN temp_table_3 t3 ON t1.building_id = t3.building_id
ORDER BY b.id;