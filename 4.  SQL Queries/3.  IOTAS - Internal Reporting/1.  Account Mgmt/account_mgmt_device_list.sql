TRUNCATE "iotas_account_mgmt"."device_list";
INSERT INTO "iotas_account_mgmt"."device_list"
  SELECT u.id, r.name as room_name, 
  count(d.id) as device_count, 
  LISTAGG(dt.name, ', ') as device_list,
  LISTAGG(d.name, ', ') as device_slot_list,
  count(CASE WHEN d.physical_device_id is null THEN d.id ELSE null END) as unpaired_device_count,
  count(CASE WHEN d.device_template_id is null THEN d.id ELSE null END) as new_device_slot_count,
  sum(CASE WHEN dt.name = 'Thermostat' THEN 1 ELSE 0 END) as thermostats,
  sum(CASE WHEN dt.name = 'Door Sensor' THEN 1 ELSE 0 END) as door_sensors,
  sum(CASE WHEN dt.name like '%Lock%' THEN 1 ELSE 0 END) as locks,
  sum(CASE WHEN dt.name = 'Outlet' or dt.name = 'Dimmer' or dt.name = 'Switch' THEN 1 ELSE 0 END) as switches_and_outlets,
  LISTAGG(case when d.physical_device_id is null then dt.name else null end, ', ') as unpaired_device_list,
  LISTAGG(pdd.name, ', ') as paired_device_list
  FROM unit u
  LEFT JOIN room r ON u.id = r.unit_id 
  LEFT JOIN device d ON d.room_id = r.id
  Left JOIN  device_type dt on dt.id = d.device_type_id
  left join physical_device pd on pd.id = d.physical_device_id
  left join physical_device_description pdd on pd.physical_device_description_id = pdd.id
  GROUP BY u.id, r.name
  ORDER BY u.id, r.name;