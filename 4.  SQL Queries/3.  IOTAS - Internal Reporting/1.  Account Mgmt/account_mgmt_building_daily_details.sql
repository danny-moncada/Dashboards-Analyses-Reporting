INSERT INTO
  "iotas_account_mgmt"."building_daily_details"
select
  bds.date,
  b.id as building_id,
  b.name as building_name,
  b.*,
  bds.occupied_units,
  bds.units - bds.occupied_units as vacant_units,
  NVL(ps.residents_per_occupied_unit, 0) as residents_per_occupied_unit,
  bds.online_hubs as hubs_online,
  bds.offline_hubs as hubs_offline,
  bds.full_monthly_active_users as active_residents_in_last_30_days,
  bds.full_daily_active_users as average_daily_active_residents,
  bds.full_daily_active_units as average_daily_active_units,
  bds.full_monthly_active_units as average_monthly_active_units,
  bds.scenes_created as daily_scenes_created,
  bds.scenes_played as daily_scenes_played,
  bds.routines_created as daily_routines_created,
  bds.api_events as daily_unit_actions,
  bds.scenes as total_scenes_created,
  bds.routines as daily_current_active_routines,
  bi.routines_played_last_30_days,
  al.all_alerts_last_30_days,
  al.low_battery_last_30_days,
  al.water_leak_last_30_days,
  al.temperature_last_30_days,
  al.humidity_last_30_days,
  al.technician_lock_event_last_30_days,
  ps.provisioned_units,
  ps.unprovisioned_units,
  ps.provisioning_incomplete,
  bds.units as total_units,
  bc.package_management = 'true' AS package_management_bool,
  bc.data_insights = 'true' data_insights_bool,
  ps.total_scenes_played_last_30_days,
  ps.all_unit_actions_last_30_days,
  bc.maintenance_tickets = 'true' t3_bool,
  bc.prospect_tour = 'true' t4_bool,
  bc.alexa_for_residential = 'true' t5_bool,
  bc.guest_access = 'true' t6_bool,
  bi.pmi_integrations as pmi_integrations,
  bi.thermostat_integrations,
  bi.access_control_integrations,
  NVL(bds.registered_users, 0) as registered_residents,
  NVL(bds.users - bds.registered_users, 0) as unregistered_residents
FROM
  building b
  JOIN "external_property_managers"."building_daily_stats" bds ON b.id = bds.building_id
  LEFT JOIN building_configuration bc on bc.building_id = b.id
  LEFT JOIN "iotas_account_mgmt"."building_alerts_daily" al ON al.building_id = bds.building_id
  AND bds.date = al.date
  LEFT JOIN "iotas_account_mgmt"."building_scene_plays_provisioning_residents_daily" ps ON ps.id = bds.building_id
  AND ps.date = bds.date
  LEFT JOIN "iotas_account_mgmt"."building_integrations" bi ON bi.id = bds.building_id
  AND bi.date = bds.date
WHERE
  bds.date = DATE(DATEADD(DAY, -1, GETDATE()))
ORDER BY
  date,
  b.id;