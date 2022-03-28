TRUNCATE "iotas_account_mgmt"."building_unit_device_summary";
INSERT INTO "iotas_account_mgmt"."building_unit_device_summary"

Select b.name as building_name, b.status, b.sales_force_id, u.name as unit_name, u.id as unit_id, pdd.name as device_name, 
pd.id as physical_device_id, CASE WHEN d.id is null THEN false ELSE true END as mapped, d.id as device_id, 
dt.name as device_type, ft.name as feature_type, pf.id as feature_id, pf.value, 
CASE WHEN h.last_alive IS NOT NULL AND h.last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN true ELSE false END as hub_online,
date(h.last_alive) as hub_last_date_alive,
--extract(TIME from h.last_alive AT TIME ZONE "UTC") as hub_last_time_alive_utc
TIMEZONE('UTC', h.last_alive) as hub_last_time_alive_utc

FROM building as b
   join unit as u on u.building_id = b.id
   left join hub as h on h.unit_id = u.id
  JOIN room as r ON r.unit_id = u.id
  JOIN device d on d.room_id = r.id
  LEFT JOIN physical_device pd on pd.id = d.physical_device_id
  LEFT JOIN physical_device_description pdd on pd.physical_device_description_id = pdd.id
  LEFT JOIN device_type as dt on dt.id = pdd.device_type_id 
  LEFT JOIN physical_feature as pf on pf.device_id = pd.id
  LEFT JOIN physical_feature_description as pfd on pfd.id = pf.physical_feature_description_id 
  LEFT JOIN feature_type as ft on ft.id = pfd.feature_type_id    
ORDER BY building_name, unit_name, device_id, feature_id;