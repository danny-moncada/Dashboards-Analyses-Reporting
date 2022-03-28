INSERT INTO
  "iotas_account_mgmt"."antelope_ridge_status"
select
  current_date as date,
  b.name as building_name,
  b.city as city,
  b.ztate as state,
  b.zip_code as zip_code,
  u.id as unit_id,
  u.name as unit_name,
  device_count.count as device_count,
  CASE
    WHEN res_info.count is null THEN 0
    ELSE res_info.count
  END as resident_count,
  CASE
    WHEN h.last_alive IS NOT NULL
    AND h.last_alive >= DATEADD(DAY, -1, GETDATE()) THEN 'Online'
    ELSE 'Offline'
  END as hub_status,
  h.id as hub_id,
  h.last_alive,
  h.uptime,
  h.ota_version,
  iotas_engine_version,
  cert_expiration_date,
  CASE
    WHEN res_info.unit_status is null THEN 'Vacant'
    ELSE 'Occupied'
  END as occupancy,
  res_info.emails,
  h.mac_address,
  h.serial_number,
  0 as events_last_3_days
from
  hub h,
  building b,
  (
    select
      h.unit_id,
      count(*) as count
    from
      physical_device pd,
      hub h,
      device d
    where
      d.physical_device_id = pd.id
      and h.id = pd.hub_id
    group by
      h.unit_id
  ) device_count,
  unit u
  left join (
    select
      r.unit_id,
      count(*) as count,
      CASE
        WHEN count(a.email) > 0 THEN 'Occupied'
        ELSE 'Vacant'
      END as unit_status,
      LISTAGG(a.email, ', ') as emails
    from
      resident r,
      account a,
      unit u,
      building b
    where
      a.id = r.account_id
      and r.unit_id = u.id
      and u.building_id = b.id
      and r.suspended_at is not null
      and r.tenant = 'true'
      and b.name LIKE '%Ante%'
    group by
      unit_id
  ) res_info on res_info.unit_id = u.id
where
  device_count.unit_id = u.id
  and b.id = u.building_id
  and h.unit_id = u.id
  and b.name not like '%ome Test%'
  AND b.name LIKE '%Antel%'
order by
  b.id,
  u.name;