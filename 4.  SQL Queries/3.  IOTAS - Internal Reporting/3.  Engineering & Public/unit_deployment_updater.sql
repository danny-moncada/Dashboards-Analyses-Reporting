INSERT INTO unit_deployment
SELECT date(deployed_date), u.id
FROM unit u, 
hub h, 
(select pd.hub_id, min(pd.created_at) as deployed_date 
  from physical_device pd, 
  device d 
  WHERE d.physical_device_id = pd.id GROUP BY hub_id) pd 
WHERE u.id = h.unit_id AND pd.hub_id = h.id AND u.id NOT IN (SELECT unit_id FROM unit_deployment) AND lower(u.name) NOT LIKE '%kit%' 
ORDER BY deployed_date DESC;