INSERT INTO
  event_total_count
select
  b.id as building_id,
  u.id as unit_id,
  DATE_TRUNC('hour', e.datetime) as hour_utc,
  count(*) as event_count
FROM
  "logs_iot_events"."event" e,
  physical_feature pf,
  physical_device pd,
  hub h,
  unit u,
  building b
WHERE
  e.physical_feature_id = pf.id
  AND pd.id = pf.device_id
  AND pd.hub_id = h.id
  AND h.unit_id = u.id
  AND u.building_id = b.id
AND DATE(e.datetime) = DATE(DATEADD(DAY, -1, GETDATE()))
GROUP BY b.id, u.id, hour_utc
ORDER BY b.id, u.id, hour_utc;