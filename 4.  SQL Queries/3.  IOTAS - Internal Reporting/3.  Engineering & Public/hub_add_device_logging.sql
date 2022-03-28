INSERT INTO hub_add_device_log 

select requesttime as datetime_utc,
b.id as building_id, u.id as unit_id, hub_id,  
a.id as account_id
FROM 
(select accountId,
  requesttime, 
  requestpath,
  CAST(REPLACE(REPLACE(requestpath, '/api/v1/hub/', ''), '/add_device', '') AS INTEGER) as hub_id
FROM "logs_restapi_logs"."restapi_logs" 
WHERE (httpMethod = 'POST') and requestPath like '/api/v1/hub/%/add_device') l
JOIN account a ON l.accountId = a.id
JOIN hub h ON l.hub_id = h.id
JOIN unit u ON h.unit_id = u.id
JOIN building b ON b.id = u.building_id
WHERE requesttime > DATEADD(HOUR, -3, GETDATE())
ORDER BY requesttime, building_id, unit_id, hub_id, account_id;