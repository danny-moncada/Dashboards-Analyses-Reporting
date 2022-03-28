INSERT INTO
  "iotas_account_mgmt"."building_alerts_daily"
SELECT
  DATE(DATEADD(DAY, -1, GETDATE())) as date,
  building_id,
  count(name) as all_alerts_last_30_days,
  SUM(
    CASE
      when display LIKE '%Low%' THEN 1
      ELSE 0
    END
  ) AS low_battery_last_30_days,
  SUM(
    CASE
      when display LIKE '%Water%' THEN 1
      ELSE 0
    END
  ) AS water_leak_last_30_days,
  SUM(
    CASE
      when display LIKE '%Temp%' THEN 1
      ELSE 0
    END
  ) AS temperature_last_30_days,
  SUM(
    CASE
      when display LIKE '%Humid%' THEN 1
      ELSE 0
    END
  ) AS humidity_last_30_days,
  SUM(
    CASE
      when display LIKE '%Technic%' THEN 1
      ELSE 0
    END
  ) AS technician_lock_event_last_30_days
FROM
  (
    SELECT
      b.id as building_id,
      u.name,
      m.created_at,
      ac.display,
      CASE
        WHEN m.archived_at is null THEN 'Active'
        ELSE 'Archived'
      END as status
    FROM
      message m
      join unit u on m.unit_id = u.id
      join building b on u.building_id = b.id
      join alert_category ac on ac.id = m.alert_category_id
      AND date(m.created_at) BETWEEN DATE(DATEADD(DAY, -30, GETDATE()))
      AND DATE(GETDATE())
    order by
      created_at
  ) b
GROUP BY
  building_id
ORDER BY
  building_id;