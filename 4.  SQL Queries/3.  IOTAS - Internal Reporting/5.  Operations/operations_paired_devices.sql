TRUNCATE "iotas_operations"."paired_devices";
INSERT INTO "iotas_operations"."paired_devices"
SELECT b.name as building_name, b.sales_force_id, dt.name as device_type, count(distinct pd.id) as device_count
FROM building b
  JOIN unit u ON u.building_id = b.id
  JOIN hub h ON h.unit_id = u.id
  JOIN physical_device as pd ON pd.hub_id = h.id
  JOIN physical_device_description as pdd ON pdd.id = pd.physical_device_description_id
  JOIN device_type as dt ON dt.id = pdd.device_type_id
GROUP BY b.name, b.sales_force_id, dt.name
ORDER BY b.name, dt.name;