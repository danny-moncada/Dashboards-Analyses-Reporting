TRUNCATE "iotas_account_mgmt"."physical_device_list";
INSERT INTO "iotas_account_mgmt"."physical_device_list"

  SELECT u.id as unit_id, h.id as hub_id, h.last_alive,
    count(pd.id) as physical_device_count, 
    LISTAGG(dt.name, ', ') as physical_device_list, 
    count(case when d.id is null then 1 else null end) as unmapped_physical_device_count,
    LISTAGG(case when d.id is null then dt.name else null end, ', ') as unmapped_physical_device_list, 
    min(pd.created_at) as first_pairing, 
    max(pd.created_at) as last_pairing,
    installers
  FROM unit u
    LEFT JOIN hub h ON h.unit_id = u.id
    LEFT JOIN physical_device pd ON pd.hub_id = h.id
    LEFT JOIN physical_device_description  pdd ON pdd.id = pd.physical_device_description_id	
    LEFT JOIN device_type dt ON dt.id = pdd.device_type_id 	
    LEFT JOIN device d ON d.physical_device_id = pd.id
    LEFT JOIN (select hadl.hub_id, LISTAGG(distinct a.email, ', ') as installers from hub_add_device_log hadl
    LEFT JOIN account a on a.id = hadl.account_id group by hadl.hub_id) as hadl on hadl.hub_id = h.id
  GROUP BY u.id, h.id, h.last_alive, installers
  ORDER BY u.id, h.id;