TRUNCATE "iotas_account_mgmt"."unit_device_pairing_status";
INSERT INTO "iotas_account_mgmt"."unit_device_pairing_status"

SELECT b.name as building_name,
u.id,
u.name as unit_name,
ud.name as unit_template_name,
hub_id,
last_alive,
CASE WHEN last_alive IS NOT NULL AND last_alive >= DATEADD(HOUR, -3, GETDATE()) THEN 'Online' ELSE 'Offline' END as hub_status,
d_list.room_name,
d_list.device_count,
d_list.device_list,
d_list.device_slot_list,
d_list.unpaired_device_count,
d_list.unpaired_device_list,
d_list.new_device_slot_count,
(d_list.unpaired_device_count = 0) as is_fully_paired,
NVL(pd_list.physical_device_count, 0) as physical_device_count,
pd_list.physical_device_list,
pd_list.unmapped_physical_device_count,
pd_list.unmapped_physical_device_list,
pd_list.first_pairing,
pd_list.last_pairing,
d_list.paired_device_list,
installers,
property_alert_type

FROM unit u
JOIN building b ON u.building_id = b.id
LEFT JOIN unit_template ud ON ud.id = u.unit_template_id 
LEFT JOIN "iotas_account_mgmt"."device_list" d_list ON u.id = d_list.id
LEFT JOIN "iotas_account_mgmt"."physical_device_list" pd_list ON u.id = pd_list.unit_id

LEFT JOIN (select building_id, LISTAGG(distinct ac.display, ', ') as property_alert_type from building_routine br  
                join routine r on r.id = br.routine_id 
                join routine_event re on re.routine_id = r.id 
                left join alert_category ac on ac.id = br.alert_category_id 
                where br.alert_category_id is not null
                GROUP BY building_id
                order by building_id ) pa on b.id = pa.building_id
ORDER BY b.name, u.id;