INSERT INTO "external_property_managers"."daily_events_temp_table"

with unit_event_count as (select u.building_id, u.id as unit_id, DATE(datetime) as request_date, count(*) as event_count
from
feature f,
device d,
room r,
unit u,
building b,
"logs_restapi_logs"."restapi_feature_updates" l
where b.id = u.building_id 
and r.unit_id = u.id 
and r.id = d.room_id 
and d.id = f.device_id 
and f.id = l.feature_id 
group by u.id, building_id, request_date),
  
event_count as (select b.id as building_id, date(e.datetime) as date, count(*) as events, 
sum(CASE WHEN pfd.settable = 'true' THEN 1 ELSE 0 END) as control_events 
from "logs_iot_events"."event" e, physical_feature pf, 
physical_feature_description pfd, 
physical_device pd, hub h, unit u, building b 
where e.physical_feature_id = pf.id 
and pf.device_id = pd.id 
and pd.hub_id = h.id 
and h.unit_id = u.id 
and u.building_id = b.id 
and pfd.id = pf.physical_feature_description_id 
group by b.id, date)

select 
DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
NVL2(ec.events, ec.events, 0) as events, 
NVL2(uec.event_count, uec.event_count, 0) as api_events,
NVL2(ec.control_events, ec.control_events, 0) as control_events
FROM  building b
left join (select uec.building_id, uec.request_date, sum(uec.event_count) as event_count from unit_event_count uec group by building_id, uec.request_date) uec on uec.building_id = b.id 
and uec.request_date = date(dateadd(day, -1, GETDATE()))
left join event_count ec on ec.building_id = b.id and ec.date = date(dateadd(day, -1, GETDATE()))
ORDER BY building_id