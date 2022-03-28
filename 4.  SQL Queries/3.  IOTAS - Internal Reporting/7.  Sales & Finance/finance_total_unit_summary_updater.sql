TRUNCATE "iotas_sales_finance"."total_unit_summary";
INSERT INTO "iotas_sales_finance"."total_unit_summary"
SELECT
DATE(GETDATE()) as date,
b.name, 
b.status,
b.address,
u.building_id,
count(1) as total_provisioned_units,
count(case when u.id in (SELECT u.id from unit u where u.name not like '%Model%' and u.common = 'false') then 1 else null end) as provisioned_resident_units,
count(case when u.id in (SELECT u.id from unit u where u.name not like '%Model%' and u.common = 'false') and u.id in (select distinct h.unit_id from hub h where h.last_alive is not null and h.last_alive >= DATEADD(DAY, -1, GETDATE())) then 1 else null end) as provisioned_resident_units_online,
count(case when u.id in (SELECT u.id from unit u where u.name like '%Model%') then 1 else null end) as provisioned_model_units,
count(case when u.id in (SELECT u.id from unit u where u.name like '%Model%') and u.id in (SELECT distinct h.unit_id  FROM hub h, physical_device pd where pd.hub_id = h.id and h.last_alive is not null and h.last_alive >= DATEADD(DAY, -1, GETDATE())) then 1 else null end) as provisioned_model_units_online,
count(case when u.id in (SELECT r.unit_id  FROM resident r, account a where r.account_id = a.id and r.tenant = 'true' and r.suspended_at is null and a.email not like '%iotashome%' GROUP BY r.unit_id ) then 1 else null end) as occupied_units,
count(case when u.id in (SELECT r.unit_id  FROM resident r, account a where r.account_id = a.id and r.tenant = 'true' and r.suspended_at is null and a.email not like '%iotashome%' GROUP BY r.unit_id ) and u.id in (SELECT distinct h.unit_id  FROM hub h, physical_device pd where pd.hub_id = h.id and h.last_alive is not null and h.last_alive >= DATEADD(DAY, -1, GETDATE())) then 1 else null end) as occupied_units_online
FROM
unit u,
building b
WHERE u.building_id = b.id and b.name not like '%Home Test%' and b.name not like '%DELETE%' and b.name not like '%delete%' and b.name not like '%Decomm%'
and u.id in (select distinct h.unit_id from hub h, physical_device pd where pd.hub_id = h.id and h.unit_id is not null)
GROUP BY u.building_id, b.name, b.status, b.address
ORDER BY b.name;