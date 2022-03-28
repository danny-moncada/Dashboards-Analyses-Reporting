TRUNCATE "iotas_operations"."units_residents_summary";

INSERT INTO "iotas_operations"."units_residents_summary"

select b.name as building_name, b.status, b.sales_force_id, u.name as unit_name, u.id as unit_id, 
a.first_name, a.last_name, a.email, a.created_at, a.created_by, a.password_first_set_at as registered_at,
  CASE WHEN h.last_alive IS NOT NULL AND h.last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN 'Online' ELSE 'Offline' END as hub_status,
  CASE WHEN activity.accountid is null THEN 'inactive' ELSE 'active' END as activity,
  CASE WHEN a.email is null THEN 'Vacant' ELSE 'Occupied' END as occupancy,
h.id as hub_id,
  h.last_alive,
  h.uptime,
  h.ota_version,
  h.iotas_engine_version,
  h.cert_expiration_date,
  h.mac_address,
h.serial_number
from
unit u
JOIN building b ON u.building_id = b.id
JOIN hub h ON h.unit_id = u.id

LEFT JOIN (select a.*, r.unit_id from resident r
 join account a on r.account_id = a.id where r.tenant = 'true' and suspended_at is null) a on a.unit_id = u.id

LEFT JOIN (select accountid from (select date(requestTime) as date_pacific, 
    l.accountid,
    count(*) as count
from "logs_restapi_logs"."restapi_logs" l, 
    account a 
where a.email not like '%@iotas%' and a.id = l.accountid group by date_pacific, accountid )
where date_pacific > DATEADD(DAY, -30, GETDATE()) group by accountid) activity on activity.accountid = a.id
ORDER BY building_name, unit_name;