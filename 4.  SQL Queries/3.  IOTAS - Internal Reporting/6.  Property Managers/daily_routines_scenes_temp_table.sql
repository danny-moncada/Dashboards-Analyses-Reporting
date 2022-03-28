INSERT INTO "external_property_managers"."daily_routines_scenes_temp_table"

with routines as (select building_id, count(*) as routines 
from routine r, unit_routine ur, unit u 
where r.active = 'true' 
and ur.unit_id = u.id 
and ur.routine_id = r.id 
group by u.building_id ),

routines_created as (select u.building_id, 
date(r.created_at) as date, 
count(*) as routines_created 
from routine r, unit u, unit_routine ur, building b 
where u.id  = ur.unit_id 
and ur.routine_id = r.id 
and b.id = u.building_id 
group by u.building_id, date),

scenes as (select building_id, count(*) as scenes 
from scene s, unit u 
where s.unit_id = u.id 
group by u.building_id),

scenes_played as (select u.building_id, l.date_pacific, count(*) as scenes_played 
from (
  select date(requestTime) as date_pacific, requestpath,
  CAST(replace (replace ( requestPath , '/api/v1/scene/', '' ), '/set','') AS INTEGER) as resource_id 
FROM "logs_restapi_logs"."restapi_logs" l 
WHERE requestPath like '%scene/%/set' and l.httpMethod = 'POST') l, 
scene s, unit u where s.id = l.resource_id 
and u.id = s.unit_id 
group by u.building_id, l.date_pacific),

scenes_created as (select u.building_id, date(r.created_at) as date, count(*) as scenes_created 
from scene r, unit u, building b 
where u.id  = r.unit_id 
and b.id = u.building_id 
group by u.building_id, date)


SELECT DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
NVL2(r.routines, r.routines, 0) as routines,
NVL2(rc.routines_created, rc.routines_created, 0) as routines_created,
NVL2(s.scenes, s.scenes, 0) as scenes, 
NVL2(sp.scenes_played, sp.scenes_played, 0) as scenes_played, 
NVL2(sc.scenes_created, sc.scenes_created, 0) as scenes_created
FROM building b 
left join routines r on r.building_id = b.id
left join routines_created rc on rc.building_id  = b.id and rc.date = date(dateadd(day, -1, GETDATE()))
left join scenes s on s.building_id = b.id
left join scenes_played sp on sp.building_id = b.id and sp.date_pacific = date(dateadd(day, -1, GETDATE()))
left join scenes_created sc on sc.building_id = b.id and sc.date = date(dateadd(day, -1, GETDATE()))
ORDER BY building_id