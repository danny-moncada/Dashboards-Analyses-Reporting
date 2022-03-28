INSERT INTO unit_hub_history
select DATE(GETDATE()) as snap_shot_date, date(pd1.first_device_paired) as provisioned,
b.id as building_id, b.name as building_name, u.id as unit_id, u.name as unit_name, h.id as hub_id, 
h.serial_number as hub_serial
from 
physical_device pd,
physical_device_description pdd,
hub h,
unit u,
building  b,
 (SELECT hub_id, min(created_at) as first_device_paired 
 FROM physical_device pd 
 group by hub_id) pd1
 where pd.physical_device_description_id = pdd.id  
 and pd.hub_id = h.id 
 and h.unit_id = u.id 
 and u.building_id = b.id 
 and pd1.hub_id  = h.id
 group by b.id, b.name, u.id, u.name, h.id, h.serial_number, pd1.first_device_paired
 ORDER BY snap_shot_date, building_id, unit_id, hub_id;