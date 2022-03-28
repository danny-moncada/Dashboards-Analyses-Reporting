TRUNCATE "iotas_engineering"."current_temperature_reading";
INSERT INTO "iotas_engineering"."current_temperature_reading"

select t.building_name, t.building_id, t.unit_name, 
t.unit_id, t.paired_time,t.device_name, t.feature_name,
t.physical_device_id, t.physical_feature_id, t.uptime, t.last_alive, t.hub_status, 
t.current_value, t.last_event_with_value, t.feature_value, t.count, t.event_order 
from (
select b.name as building_name, b.id as building_id, u.name as unit_name, u.id AS unit_id, 
pd.created_at as paired_time,pdd.name as device_name, ft.name as feature_name, 
pd.id as physical_device_id, pf.id as physical_feature_id, h.uptime, 
h.last_alive, 
  CASE WHEN h.last_alive IS NOT NULL AND h.last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN 'Online' ELSE 'Offline' END AS hub_status,
pf.value as current_value, max(e.datetime) as last_event_with_value, e.feature_value, 
count(*) as count, 
  ROW_NUMBER() OVER (PARTITION BY pf.id ORDER BY max(e.datetime) DESC) AS event_order
from feature_type ft,
 physical_feature_description  pfd,
 physical_device pd,
 physical_device_description pdd,
 device_type dt,
 hub h,
 unit u,
 building  b,
 physical_feature pf left outer join
 "logs_iot_events"."event" e on e.physical_feature_id = pf.id 
 where ft.id = pfd.feature_type_id 
 and pfd.id = pf.physical_feature_description_id 
 and pf.device_id = pd.id 
 and pd.physical_device_description_id = pdd.id 
 and dt.id = pdd.device_type_id 
 and pd.hub_id = h.id 
 and h.unit_id = u.id 
 and u.building_id = b.id 
 and dt.category like '%thermostat%' 
 and datediff(DAY, pf.changed_at, h.last_alive) > 1 AND datediff(DAY, h.last_alive, GETDATE()) < 31 
group by b.name, b.id,u.name,u.id, pd.created_at, pdd.name, ft.name,pd.id,h.uptime, h.last_alive, pf.id, pf.value, e.feature_value 
order by b.name asc, u.name asc, feature_name asc, last_event_with_value desc) t where t.event_order < 3 and t.feature_name like 'CurrentTemperature'
order by building_name asc, unit_name asc, feature_name asc, event_order desc;