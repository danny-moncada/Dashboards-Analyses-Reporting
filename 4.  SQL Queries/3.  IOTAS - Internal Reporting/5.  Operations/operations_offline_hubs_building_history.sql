TRUNCATE iotas_operations.offline_hubs_building_history;

INSERT INTO iotas_operations.offline_hubs_building_history

SELECT date(hsl.datetime) AS hub_log_date, EXTRACT(HOUR FROM hsl.datetime) AS hour,
 b.name AS building_name, b.sales_force_id,
    count(distinct (case when hsl.online = true then hub_id end)) AS hubs_online,
    count(distinct (case when hsl.online = false then hub_id end)) AS hubs_offline,
    count(distinct hub_id) as total_hub_count, 
    round(count(distinct (case when hsl.online = false then hub_id end)) *100.0 /  count(distinct hub_id), 5) AS offline_perc
FROM hub_status_log hsl
LEFT JOIN unit u ON hsl.unit_id = u.id
LEFT JOIN building b ON u.building_id = b.id
WHERE date(hsl.datetime) BETWEEN date('2021-01-01') AND DATE(GETDATE())
AND b.status NOT IN ('TEST_PROPERTY', 'DECOMISSIONED')
GROUP BY hub_log_date, hour, building_name, sales_force_id
ORDER BY building_name, hub_log_date, hour;