INSERT INTO event_battery
SELECT e.*
FROM
feature_type ft,
physical_feature  pf,
physical_feature_description   pfd,
"logs_iot_events"."event" e 
WHERE ft.id = pfd.feature_type_id 
AND pfd.id = pf.physical_feature_description_id 
AND e.physical_feature_id = pf.id 
AND ft.name like '%Batter%' 
AND DATE(datetime) = DATE(DATEADD(DAY, -1, GETDATE()));