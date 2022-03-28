DROP TABLE "iotas_account_mgmt"."building_integrations";CREATE TABLE "iotas_account_mgmt"."building_integrations" AS WITH routines_played AS (
  SELECT
    building_id,
    count(distinct routine_event_id) as routines_played_last_30_days
  FROM
    (
      select
        b.id as building_id,
        u.name as unit_name,
        r.name AS routine_name,
        e.id as routine_event_id,
        date(e.timestamp) as date
      from
        routine_event e
        join unit u on u.id = e.unit_id
        join routine r on r.id = e.routine_id
        join feature_action fa on r.id = fa.routine_id
        join room ro on ro.unit_id = u.id
        join device d on ro.id = d.room_id
        join feature f on f.device_id = d.id
        join building b on b.id = u.building_id
      where
        fa.feature_id = f.id
        AND date(e.timestamp) BETWEEN DATE(DATEADD(DAY, -30, GETDATE()))
        AND DATE(GETDATE())
    )
  GROUP BY
    building_id
),
pmi_integrations AS (
  select
    pmim.building_id,
    LISTAGG(pmi.integration_type, '; ') as pmi_integrations
  from
    property_management_integration pmi,
    pmi_building_map pmim
  where
    pmi.id = pmim.property_management_integration_id
  group by
    building_id
),
energex AS (
  select
    building_id,
    'Energex' as thermostat_integrations
  FROM
    energex_account
),
salto AS (
  select
    building_id,
    'Salto SVN' as access_control_integrations
  FROM
    saltosvn_account
)
SELECT
  DATE(DATEADD(DAY, -1, GETDATE())) as date,
  b.id,
  rp.routines_played_last_30_days,
  pmi.pmi_integrations,
  eg.thermostat_integrations,
  s.access_control_integrations
FROM
  building b
  LEFT JOIN routines_played rp ON rp.building_id = b.id
  LEFT JOIN pmi_integrations pmi ON pmi.building_id = b.id
  LEFT JOIN energex eg ON eg.building_id = b.id
  LEFT JOIN salto s ON s.building_id = b.id
ORDER BY
  b.id;