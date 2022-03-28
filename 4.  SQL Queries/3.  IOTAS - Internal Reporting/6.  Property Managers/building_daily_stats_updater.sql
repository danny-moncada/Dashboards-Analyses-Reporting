INSERT INTO "external_property_managers"."building_daily_stats"
SELECT distinct dut.date, dut.building_name, dut.status, dut.users, dut.registered_users,
			un.units, un.provisioned_units, un.occupied_units, un.register_occupied_units,
            un.online_hubs, un.registered_occupied_units_online, ut.daily_active_users, ut.monthly_active_users,
            0 AS daily_active_units, 0 AS monthly_active_units,
            rst.scenes_created, rst.routines_created,
            et.events, et.api_events, dut.devices, rst.scenes, rst.routines, dut.building_id,
            rst.scenes_played, et.control_events, rkt.virtual_keys_created, ut.daily_active_users_with_routines,
            ut.monthly_active_users_with_routines, ut.full_monthly_active_users, ut.full_daily_active_users,
            uat.full_monthly_active_units, uat.full_daily_active_units, un.offline_hubs, un.total_hubs,
            rkt.daily_resident_door_code_resets
FROM "external_property_managers"."daily_devices_users_temp_table" dut
JOIN "external_property_managers"."daily_units_temp_table" un ON dut.building_id = un.building_id AND dut.date = un.date
JOIN "external_property_managers"."daily_users_temp_table" ut ON dut.building_id = ut.building_id AND dut.date = ut.date
JOIN "external_property_managers"."daily_unit_activity_temp_table" uat ON dut.building_id = uat.building_id AND dut.date = uat.date
JOIN "external_property_managers"."daily_routines_scenes_temp_table" rst ON dut.building_id = rst.building_id AND dut.date = rst.date
JOIN "external_property_managers"."daily_events_temp_table" et ON dut.building_id = et.building_id AND dut.date = et.date
JOIN "external_property_managers"."daily_resident_virtual_key_temp_table" rkt ON dut.building_id = rkt.building_id AND dut.date = rkt.date
WHERE dut.date = DATE(DATEADD(DAY, -1, GETDATE()))
ORDER BY building_id;