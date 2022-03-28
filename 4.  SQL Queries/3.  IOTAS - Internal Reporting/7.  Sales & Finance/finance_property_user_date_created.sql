TRUNCATE "iotas_sales_finance"."property_user_date_created";

INSERT INTO "iotas_sales_finance"."property_user_date_created"

With residents as
(SELECT b.name, b.status, b.sales_force_id, 
    a.id as account_id, a.first_name, a.last_name, a.email, r.unit_id, u.name as unit_name, 
    a.created_at, a.created_by, a.password_first_set_at, 
    CASE WHEN a.password IS NULL THEN 'Not Registered' ELSE 'Registered' END AS registration_status, r.tenant
FROM account as a
  join resident as r on r.account_id = a.id
  join unit as u on u.id = r.unit_id
  join building as b on b.id = u.building_id),

managers as (Select b.name, b.status, b.sales_force_id, a.id as account_id, a.first_name, a.last_name, a.email, a.created_at, a.password_first_set_at
  from 
account as a
  join manager as m on m.account_id = a.id
  join building as b on b.id = m.building_id)
  
SELECT distinct 
  CASE WHEN r.account_id is null THEN m.name ELSE r.name END as building_name,
  CASE WHEN r.status is null THEN m.status ELSE r.status END as status,
  CASE WHEN r.sales_force_id is null THEN m.sales_force_id ELSE r.sales_force_id END as sales_force_id,
  r.unit_name,
  r.unit_id,
  CASE WHEN r.account_id is null THEN m.account_id ELSE r.account_id END as account_id,
  CASE WHEN r.account_id is null THEN m.first_name ELSE r.first_name END as first_name,
  CASE WHEN r.account_id is null THEN m.last_name ELSE r.last_name END as last_name,
  CASE WHEN r.account_id is null THEN m.email ELSE r.email END as email,
  CASE WHEN r.account_id is null THEN m.created_at ELSE r.created_at END as created_at,  
  registration_status,
  CASE WHEN r.account_id is not null THEN 'yes' ELSE 'no' END as resident,
  CASE WHEN m.account_id is not null THEN 'yes' ELSE 'no' END as manager,
  CASE WHEN m.password_first_set_at is not null THEN m.password_first_set_at ELSE r.password_first_set_at END as password_first_set_at,
  NVL(r.tenant, 'false') AS tenant
--  ifnull(r.tenant, false) as tenant
FROM residents as r
  full join managers as m on m.account_id = r.account_id and m.name = r.name
ORDER BY building_name, created_at, first_name, email;