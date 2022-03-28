TRUNCATE "iotas_engineering"."devices_summary";

INSERT INTO "iotas_engineering"."devices_summary"

Select b.name as building_name, b.status, b.sales_force_id, u.name as unit_name, u.id as unit_id, pdd.name as device_name, 
pd.id as physical_device_id, CASE WHEN d.id is null THEN false ELSE true END as mapped, d.id as device_id, 
dt.name as device_type, ft.name as feature_type, pf.id as feature_id, pf.value,  
CASE WHEN h.last_alive IS NOT NULL AND h.last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN true ELSE false END as hub_online,
date(h.last_alive) as hub_last_date_alive,
--extract(TIME from h.last_alive AT TIME ZONE "UTC") as hub_last_time_alive_utc
TIMEZONE('UTC', h.last_alive) as hub

FROM building as b
  join unit as u on u.building_id = b.id
  join hub as h on h.unit_id = u.id
  join physical_device as pd on pd.hub_id = h.id
    join physical_device_description as pdd on pdd.id = pd.physical_device_description_id 
    join device_type as dt on dt.id = pdd.device_type_id 
  join physical_feature as pf on pf.device_id = pd.id
    join physical_feature_description as pfd on pfd.id = pf.physical_feature_description_id 
    join feature_type as ft on ft.id = pfd.feature_type_id 
    left join device d on d.physical_device_id = pd.id
ORDER BY building_name, unit_name, device_id, feature_id;