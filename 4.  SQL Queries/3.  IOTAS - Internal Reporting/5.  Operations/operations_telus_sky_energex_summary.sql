TRUNCATE TABLE "iotas_operations"."telus_energex_status";

INSERT INTO "iotas_operations"."telus_energex_status"

SELECT GETDATE() as current_date_time, b.name, u.name as unit_name, u.id as unit_id, d.name as device_type, pdd.name as physical_device_name, f.name as feature_type,

CASE WHEN f.name LIKE 'Online' AND pf.value = 1 THEN 'True'
WHEN f.name LIKE 'Online' AND pf.value = 0 THEN 'False'
WHEN f.name LIKE 'FanMode' THEN SPLIT_PART(pf.valuez, ':', CAST(pf.value AS INTEGER) + 1)
WHEN f.name LIKE 'Humidity' THEN CAST(pf.value AS VARCHAR) || '%'
ELSE CAST(CAST(pf.value AS DECIMAL(3,1)) AS VARCHAR)  || '° C'
END AS value

FROM building b
JOIN unit u ON b.id = u.building_id
JOIN room r ON u.id = r.unit_id
JOIN device d ON r.id = d.room_id
JOIN feature f ON d.id = f.device_id
JOIN physical_feature pf ON pf.id = f.physical_feature_id
JOIN physical_device pd ON d.physical_device_id = pd.id
JOIN physical_device_description pdd ON pd.physical_device_description_id = pdd.id

WHERE b.name LIKE '%TELUS Sky%'
AND d.name LIKE '%Thermo%'
ORDER BY unit_name;