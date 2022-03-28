INSERT INTO "external_property_managers"."daily_users_temp_table"
with active_accounts as (select date(requesttime)
as date_pacific, l.accountid as accountid, 
count(*) as count 
from "logs_restapi_logs"."restapi_logs" l, account a 
where a.email not like '%@iotas%' 
and a.id = l.accountid
group by date_pacific, accountid),

scene_plays as (select date(requesttime) as date_pacific, 
CAST(replace(regexp_replace(l.requestPath, '.*/scene/', ''), '/set', '') AS INTEGER) as scene_id, 
accountid as account_id
FROM "logs_restapi_logs"."restapi_logs" l 
WHERE l.httpMethod='POST' 
AND l.requestPath LIKE '%/scene/%/set%'),
routine_active_accounts as (SELECT date(re.timestamp) AS date, res.account_id,  COUNT(*) as count
FROM routine r, 
unit_routine ur, 
unit u, 
resident res, 
routine_event re
WHERE res.unit_id = u.id 
AND u.id = ur.unit_id 
AND r.id = ur.routine_id 
AND res.suspended_at is null 
AND re.routine_id = r.id 
GROUP BY res.account_id, date(re.timestamp)),

active_or_scene_routine_active_accounts as (select date, 
account_id, count(*) as count from ( (
    select raa.date, raa.account_id  
    from routine_active_accounts raa) 
    union all ( select aa.date_pacific as date, aa.accountid  from active_accounts aa ) 
    union all (select s.date_pacific, s.account_id from scene_plays s)) 
    group by date, account_id),

full_user_activity_by_building as (select building_id, 
sum(CASE WHEN mau.count is not null THEN 1 ELSE 0 END) as monthly_active_users, 
sum(CASE WHEN dau.count is not null THEN 1 ELSE 0 END) as daily_active_users 
from resident r 
left join (select account_id, count(*) as count from active_or_scene_routine_active_accounts 
where date = DATE(dateadd(DAY, -1, GETDATE())) group by account_id) dau on dau.account_id = r.account_id 
left join (select account_id, count(*) as count from active_or_scene_routine_active_accounts 
where date > DATE(dateadd(DAY, -30, GETDATE())) group by account_id) as mau on mau.account_id = r.account_id 
right join unit u on u.id = r.unit_id where r.unit_id = u.id and r.suspended_at is null group by building_id)

SELECT DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
0 as daily_active_users, 0 as monthly_active_users,
fu.daily_active_users as daily_active_users_with_routines, 
fu.monthly_active_users as monthly_active_users_with_routines, 
NVL2(fu.monthly_active_users, fu.monthly_active_users, 0) as full_monthly_active_users, 
NVL2(fu.daily_active_users, fu.daily_active_users, 0) as full_daily_active_users
FROM building b 
LEFT JOIN full_user_activity_by_building fu on fu.building_id = b.id