TRUNCATE "iotas_operations"."assigned_hubs";

INSERT INTO "iotas_operations"."assigned_hubs"
SELECT b.id as building_id, b.name as building_name, b.sales_force_id,
  u.id as unit_id, u.name as unit_name, 
  NVL(pd.device_count, 0) as device_count,
  NVL(r.resident_count, 0) as resident_count, 
  CASE WHEN h.last_alive IS NOT NULL AND h.last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN 'Online' ELSE 'Offline' END as hub_status, 
  h.id as hub_id,
  h.last_alive,
  h.uptime,
  h.ota_version,
  h.iotas_engine_version,
  h.cert_expiration_date,
  CASE WHEN r.resident_count is not null THEN 'Occupied' ELSE 'Vacant' END as occupancy,
  emails,
  h.mac_address,
h.serial_number,
NVL(e.event_count, 0) as events_last_3_days

FROM building as b
  JOIN unit as u ON u.building_id = b.id
  JOIN hub as h ON h.unit_id = u.id  
  Left JOIN (select unit_id,  sum(e.event_count) as event_count from event_total_count e 
  where date(hour_utc) > DATEADD(DAY, -3, GETDATE()) group by unit_id) e on u.id = e.unit_id
  LEFT JOIN (select unit_id, LISTAGG(distinct a.email, ', ') as emails, count(*) as resident_count 
  from resident r, account a WHERE r.suspended_at is  null and r.tenant = 'true' and a.email 
  not like '%iotashome%' and a.id = r.account_id group by unit_id) as r ON r.unit_id = u.id
  LEFT JOIN (select hub_id, count(*) as device_count from physical_device group by hub_id) as pd ON pd.hub_id = h.id


GROUP BY b.name, b.sales_force_id, u.name, h.last_alive, h.uptime, h.iotas_engine_version, h.ota_version, h.cert_expiration_date, u.id, b.id, pd.device_count, r.resident_count, r.emails, occupancy, mac_address, h.serial_number, e.event_count, h.id
ORDER BY b.name, u.name;