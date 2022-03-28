TRUNCATE TABLE "iotas_account_mgmt"."antelope_ridge_all_hubs_status";
INSERT INTO
  "iotas_account_mgmt"."antelope_ridge_all_hubs_status"
SELECT
  b.name,
  ahs.street_number,
  ahs.address,
  b.city,
  b.ztate,
  b.zip_code,
  u.name as unit_name,
  h.id as hub_id,
  h.serial_number,
  h.last_alive,
  CASE
    WHEN h.last_alive >= DATEADD('hour', -3, GETDATE()) THEN 'Online'
    ELSE 'Offline'
  END AS hub_status,
  GETDATE() as query_refresh_date_time
FROM
  building b
  JOIN unit u ON b.id = u.building_id
  JOIN hub h ON u.id = h.unit_id
  LEFT JOIN "iotas_account_mgmt"."antelope_ridge_street_address" ahs ON u.name = ahs.yardi_unit_number
WHERE
  b.name LIKE '%Ante%'
ORDER by
  u.name;