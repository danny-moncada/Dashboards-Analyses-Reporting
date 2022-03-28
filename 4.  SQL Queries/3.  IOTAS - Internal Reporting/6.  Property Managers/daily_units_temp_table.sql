INSERT INTO "external_property_managers"."daily_units_temp_table"

with units AS
  (SELECT building_id,
          sum(CASE WHEN (CASE WHEN pd.device_count IS NULL THEN 0 ELSE pd.device_count END) > 0 THEN 1 ELSE 0 END) AS provisioned_units,
          count(*) AS units,
          sum(CASE WHEN r.occupied_unit IS NOT NULL THEN 1 ELSE 0 END) AS occupied_units,
          sum(CASE WHEN r.occupied_registered_unit IS NOT NULL
                  AND r.occupied_registered_unit THEN 1 ELSE 0 END) AS register_occupied_units,


          sum(CASE WHEN h.last_alive IS NOT NULL
                 AND h.last_alive >= (select DATEADD(MINUTE, -10, MAX(h.last_alive)) as max_time_alive from hub h) THEN 1 ELSE 0 END) AS online_hubs,
          sum(CASE WHEN h.last_alive IS NOT NULL
                 AND h.last_alive < (select DATEADD(MINUTE, -10, MAX(h.last_alive)) as max_time_alive from hub h) THEN 1 ELSE 0 END) AS offline_hubs,
          count(h.id) AS total_hubs,
          sum(CASE WHEN h.last_alive IS NOT NULL
                  AND DATE(h.last_alive) > DATE(DATEADD(DAY, -2, GETDATE()))
                  AND (r.occupied_registered_unit IS NOT NULL
                       AND r.occupied_registered_unit = TRUE) THEN 1 ELSE 0 END) AS registered_occupied_units_online
   FROM unit u
   LEFT JOIN
     (SELECT unit_id,
             CASE WHEN sum(CASE WHEN a.password IS NOT NULL THEN 1 ELSE 0 END) > 0 THEN TRUE ELSE FALSE END AS occupied_registered_unit,
                                                                    TRUE AS occupied_unit
      FROM account a,
                           resident r
      WHERE a.id = r.account_id
        AND r.suspended_at IS NULL
      GROUP BY r.unit_id) r ON u.id = r.unit_id
   LEFT JOIN hub h ON h.unit_id = u.id
   LEFT JOIN
     (SELECT hub_id,
             count(*) AS device_count
      FROM physical_device pd1
      WHERE hub_id IS NOT NULL
      GROUP BY hub_id) pd ON pd.hub_id = h.id
   WHERE h.unit_id = u.id
   GROUP BY u.building_id)

SELECT DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
un.units, 
un.provisioned_units, 
un.occupied_units, 
un.register_occupied_units, 
un.online_hubs, 
un.registered_occupied_units_online,
un.offline_hubs, 
un.total_hubs
FROM building b 
left join units un on un.building_id = b.id
ORDER BY building_id