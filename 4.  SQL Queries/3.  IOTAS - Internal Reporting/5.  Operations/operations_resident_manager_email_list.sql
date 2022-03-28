TRUNCATE "iotas_operations"."resident_manager_email_list";
INSERT INTO "iotas_operations"."resident_manager_email_list"
With residents as
(SELECT b.name, b.status, b.sales_force_id, 
    a.id as account_id, a.first_name, a.last_name, a.email, r.unit_id, u.name as unit_name, 
    a.created_at, a.created_by, a.password_first_set_at, 
    CASE WHEN a.password IS NULL THEN 'Not Registered' ELSE 'Registered' END AS registration_status, r.tenant
FROM account as a
  join resident as r on r.account_id = a.id
  join unit as u on u.id = r.unit_id
  join building as b on b.id = u.building_id 
WHERE r.suspended_at is null
and a.email not like '%iotashome%'
and b.name not like 'Home Testers' 
and b.name not like '%expired%' 
and b.name not like '%Expired%' 
and b.name not like '%delete%' 
and b.name not like '%Delete%'),

managers as (Select b.name, b.status, b.sales_force_id, a.id as account_id, a.first_name, a.last_name, a.email, a.created_at, a.password_first_set_at
  from 
account as a
  join manager as m on m.account_id = a.id
  join building as b on b.id = m.building_id 
WHERE m.suspended = 'false' and b.name not like 'Home Testers' and b.name not like '%expired%' 
and b.name not like '%Expired%' and b.name not like '%delete%' and b.name not like '%Delete%'
  and a.email not like '%iotashome%' and a.password is not null)
  
SELECT distinct 
  CASE WHEN r.account_id IS NULL THEN m.name ELSE r.name END AS building_name,
  CASE WHEN r.status IS NULL THEN m.status ELSE r.status END AS status,
  CASE WHEN r.sales_force_id IS NULL THEN m.sales_force_id ELSE r.sales_force_id END AS sales_force_id,
  r.unit_name,
  r.unit_id,
  CASE WHEN r.account_id IS NULL THEN m.first_name ELSE r.first_name END AS first_name,
  CASE WHEN r.account_id IS NULL THEN m.last_name ELSE r.last_name END AS last_name,
  CASE WHEN r.account_id IS NULL THEN m.email ELSE r.email END AS email,
  CASE WHEN r.account_id IS NULL THEN m.created_at ELSE r.created_at END AS created_at,  
  registration_status,
  CASE WHEN r.account_id is not null THEN 'yes' ELSE 'no' END AS resident,
  CASE WHEN m.account_id is not null THEN 'yes' ELSE 'no' END AS manager,
  CASE WHEN m.password_first_set_at is not null THEN m.password_first_set_at ELSE r.password_first_set_at END AS password_first_set_at,
  r.tenant
FROM residents as r
  full join managers as m on m.account_id = r.account_id and m.name = r.name
ORDER BY building_name, first_name, email;