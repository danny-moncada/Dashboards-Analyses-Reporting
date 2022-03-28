INSERT INTO hub_status_log 
SELECT 
GETDATE() as datetime,
h.last_alive,
h.id as hub_id,
		h.unit_id,
        CASE WHEN h.last_alive IS NOT NULL AND h.last_alive > DATEADD(HOUR, -3, GETDATE()) THEN TRUE ELSE FALSE END as online 
FROM hub h
WHERE h.unit_id IS NOT NULL
ORDER BY GETDATE(), hub_id, h.unit_id;