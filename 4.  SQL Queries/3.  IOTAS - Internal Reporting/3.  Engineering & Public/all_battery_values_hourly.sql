TRUNCATE "iotas_engineering"."all_battery_values";

INSERT INTO "iotas_engineering"."all_battery_values"

SELECT distinct b.name as building_name, b.status, b.sales_force_id, u.name as unit_name, 
pdd.name as physical_device_name, pd.id as physical_device_id, h.uptime, h.last_alive
FROM hub as h 
  JOIN physical_device as pd ON pd.hub_id = h.id
  JOIN physical_device_description as pdd ON pdd.id = pd.physical_device_description_id 
  JOIN device_type as dt ON dt.id = pdd.device_type_id
  JOIN unit as u ON u.id = h.unit_id 
  JOIN building as b ON b.id = u.building_id 
WHERE dt.category like '%lock%'
ORDER BY b.name, b.status, b.sales_force_id, u.name, pd.id;