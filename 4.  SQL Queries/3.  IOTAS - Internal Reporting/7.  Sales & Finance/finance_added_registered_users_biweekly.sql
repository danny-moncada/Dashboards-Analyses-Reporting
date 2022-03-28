TRUNCATE "iotas_sales_finance"."added_registered_users";
INSERT INTO "iotas_sales_finance"."added_registered_users"
SELECT b.name, b.id,
		 NVL2(added_user.added_users, added_user.added_users, 0) AS total_added_users, 
			NVL2(res.added_users, res.added_users, 0) AS total_residents_added, 
			NVL2(res.registered_users, res.registered_users, 0) AS total_residents_registered,
			ROUND(CASE WHEN res.added_users = 0 THEN 0 ELSE (res.registered_users * 1.0 / res.added_users) END, 4) as percent_residents_registered

FROM building b
LEFT JOIN (
SELECT building_id, count(*) as added_users
FROM
((SELECT distinct a.id, u.building_id FROM account a, 
resident r, 
unit u WHERE a.id = r.account_id 
and r.unit_id = u.id 
and r.suspended_at is null 
and r.tenant = 'true' and a.email not like '%iotashome%')
union all 
(SELECT a.id, m.building_id
FROM account a, 
manager m 
WHERE a.id = m.account_id 
and m.suspended = 'false'
and a.email not like '%iotashome%'))
GROUP BY building_id
) as added_user on b.id = added_user.building_id

LEFT JOIN (SELECT building_id, count(*) as added_users, count(case when registered = 'true' then 1 else null end) as registered_users
FROM
(select distinct u.building_id, a.id, CASE WHEN a.password is not null THEN 'true' ELSE 'false' END as registered 
FROM account a, resident r, unit u 
where a.id = r.account_id 
and r.unit_id = u.id 
and r.suspended_at is  null 
and r.tenant = 'true' and a.email not like '%iotashome%')
GROUP BY building_id) res ON b.id = res.building_id
ORDER BY b.name;