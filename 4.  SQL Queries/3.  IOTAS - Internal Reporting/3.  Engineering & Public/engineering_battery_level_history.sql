TRUNCATE "iotas_engineering"."battery_level_history";

INSERT INTO "iotas_engineering"."battery_level_history"

SELECT b.name as building_name, b.status, 
u.name as unit_name, 
r.name as room_name, pdd.name as device_type, d.name as device_name, h.last_alive,
e.feature_value as battery_level, e.datetime as reported_event_date, 
CASE WHEN h.last_alive > DATEADD(HOUR, -3, GETDATE()) THEN 'online' ELSE 'offline' END as hub_status,
NULL as devices

FROM
building b,
unit u,
physical_device pd,
hub h,
"logs_iot_events"."event" e,
physical_feature pf,
feature_type ft,
device d,
device_type dt,
room r,
physical_feature_description pfd,
physical_device_description pdd
WHERE b.id = u.building_id 
and u.id = h.unit_id 
and pd.hub_id = h.id 
and pd.id = pf.device_id
and dt.id = pdd.device_type_id 
and e.physical_feature_id = pf.id 
and ft.id = pfd.feature_type_id 
and pf.physical_feature_description_id = pfd.id 
and d.physical_device_id = pd.id and d.room_id = r.id
and pdd.id = pd.physical_device_description_id
and ft.name like '%attery%'
and dt.category not like '%thermo%'
ORDER BY building_name, u.name, pdd.name, reported_event_date desc;