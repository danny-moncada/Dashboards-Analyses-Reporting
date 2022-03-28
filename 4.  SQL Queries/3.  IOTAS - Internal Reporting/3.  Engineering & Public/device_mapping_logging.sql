INSERT INTO device_mapping_log

SELECT GETDATE() as log_date,
		d.changed_at AS change_date,
d.id AS device_id, 
d.physical_device_id, 
dml.physical_device_id AS old_physical_device_id, 
d.changed_by 
FROM device d, 
(SELECT dml.device_id, dml.physical_device_id, dml.change_date 
  FROM (SELECT device_id, max(change_date) AS change_date 
    FROM device_mapping_log
    GROUP BY device_id) mdml, 
  device_mapping_log dml 
  WHERE dml.device_id = mdml.device_id AND dml.change_date = mdml.change_date) dml  
WHERE d.id = dml.device_id AND d.physical_device_id != dml.physical_device_id