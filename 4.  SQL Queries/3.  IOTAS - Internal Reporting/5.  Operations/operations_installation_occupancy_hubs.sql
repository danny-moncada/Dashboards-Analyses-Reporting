TRUNCATE "iotas_operations"."installation_occupancy_hubs";
INSERT INTO "iotas_operations"."installation_occupancy_hubs"
select b.name as building_name, 0 as Deal_Number_of_Units, 
u.name as unit_name, u.id as unit_id, 
CASE WHEN h.id IS NULL THEN 'Unprovisioned' WHEN t.total_devices = t.paired_devices THEN 'Provisioned' ELSE 'Provisioning Incomplete' END as installation_status, 
CASE WHEN t.paired_devices is not null and t.paired_devices > 0 THEN true ELSE false END as depolyed, 
CASE WHEN r.count is null THEN 'Vacant' ELSE 'Occupied' END as occupancy_status, 
CASE WHEN h.last_alive > DATEADD(HOUR, -3, GETDATE()) THEN 'Online' ELSE 'Offline' END as hub_status, 
r.registered
  from 
  building b
  join unit u on u.building_id = b.id
  left join (select u.building_id, u.id as unit_id, count(*) as total_devices, sum(CASE WHEN d.physical_device_id is null THEN 0 ELSE 1 END) as paired_devices
  from 
  unit u
  join hub h on h.unit_id = u.id
  join room r on r.unit_id = u.id
  join device d on d.room_id = r.id group by u.id, u.building_id) t on t.unit_id = u.id
  left join hub h on h.unit_id = u.id
  left join (select unit_id, count(*) as count, BOOL_OR(a.password is not null) as registered from resident r, account a 
  where r.suspended_at is null and a.id = r.account_id group by unit_id) r on r.unit_id = u.id
  ORDER by building_name, unit_name;