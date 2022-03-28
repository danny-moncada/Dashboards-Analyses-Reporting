TRUNCATE "iotas_sales_finance"."buildings_provisioning_counts";
INSERT INTO "iotas_sales_finance"."buildings_provisioning_counts"

with 
/* Relavent buildings */
building_list as (
SELECT distinct b.name as building_name
  FROM building b JOIN unit as u ON u.building_id = b.id
WHERE b.name not like '%Home Testers%' and b.name not like 'Sample Building' and b.name not like 'test' and b.name not like '1737 NE Alberta' and b.name not like 'Jasco'
--WHERE b.status NOT IN ('DECOMMISSIONED', 'TEST_PROPERTY')
),
/* Makes a timeline day by day */
timeline as (
--SELECT * FROM UNNEST(GENERATE_DATE_ARRAY('2018-11-01',CURRENT_DATE, INTERVAL 1 DAY)) as date
SELECT date FROM iotashome_date_dimension
WHERE date <= GETDATE()

),
/* Makes a timeline for each building */
building_timeline as (
SELECT bl.building_name, t.date
FROM timeline as t
CROSS JOIN building_list as bl
),

provision_dates as (
SELECT b.name as building_name, cast(min(pd.created_at) as date) as provision_date, u.id as unit_id
FROM building b
JOIN unit u ON u.building_id = b.id
JOIN hub h ON h.unit_id = u.id
JOIN physical_device pd ON pd.hub_id = h.id
WHERE b.name in (select building_name from building_list)
  and u.common = 'false'
GROUP BY b.name, u.id
),

--SELECT * FROM building_timeline bt
--JOIN provision_dates pd ON bt.building_name = pd.building_name;
/* For tenants in provisioned units get unit id, move in date and move out date, provision date */
unit_tenant_info as (SELECT DISTINCT 
  pd.building_name,
  pd.unit_id,
  pd.provision_date,
--  IF(cast(r.date_from as date) < pd.provision_date, pd.provision_date, cast(r.date_from as date)) as move_in_date, /* Dont care about people moved in before provisioning */
  CASE WHEN r.date_from < pd.provision_date THEN pd.provision_date ELSE r.date_from END AS move_in_date,
--  IF(r.suspended_at is not null, cast(r.suspended_at as date), DATEADD(day, 1, GETDATE()) as move_out_date
  CASE WHEN r.suspended_at IS NOT NULL THEN r.suspended_at ELSE DATEADD(day, 1, GETDATE()) END as move_out_date
FROM provision_dates as pd
  LEFT JOIN resident as r ON r.unit_id = pd.unit_id
),
/* */
provisions_occupancy_to_date as (
SELECT 
  bt.building_name,
  bt.date,
  COUNT(DISTINCT CASE WHEN uti.provision_date <= bt.date THEN uti.unit_id ELSE NULL END) AS provisions_to_date,
  COUNT(DISTINCT CASE WHEN uti.move_in_date <= bt.date and uti.move_out_date >= bt.date THEN uti.unit_id ELSE NULL END) AS occupied_provisioned_units_to_date
FROM building_timeline bt
LEFT JOIN unit_tenant_info uti ON uti.building_name = bt.building_name
GROUP BY bt.date, bt.building_name
)

SELECT potd.building_name, DATE(potd.date) as date, potd.provisions_to_date, potd.occupied_provisioned_units_to_date, potd.provisions_to_date - potd.occupied_provisioned_units_to_date as vacant_provisioned_units_to_date
FROM provisions_occupancy_to_date  potd
ORDER BY potd.date, potd.building_name;