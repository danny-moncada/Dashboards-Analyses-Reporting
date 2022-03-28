INSERT INTO "iotas_sales_finance"."onboarding_biweekly"

SELECT date, tus.name, status, address,
		building_id, total_provisioned_units,
        provisioned_resident_units, 
        provisioned_resident_units_online,
        ROUND(CASE WHEN provisioned_resident_units = 0 THEN 0 ELSE provisioned_resident_units_online * 1.0 / provisioned_resident_units END, 4) as percent_residents_units_online,
        provisioned_model_units,
        provisioned_model_units_online,
        ROUND(CASE WHEN provisioned_model_units = 0 THEN 0 ELSE provisioned_model_units_online * 1.0 / provisioned_model_units END, 4) AS percent_model_units_online,
        occupied_units,
        occupied_units_online,
        ROUND(CASE WHEN occupied_units = 0 THEN 0 ELSE occupied_units_online * 1.0 / occupied_units END, 4) AS percent_occupied_units_online,
        aru.total_added_users,
        aru.total_residents_added,
        aru.total_residents_registered,
        aru.percent_residents_registered,
        (select count(id) FROM account WHERE email NOT LIKE '%iotashome%') as total_users,
        (select count(id) FROM account WHERE email NOT LIKE '%iotashome%' AND password IS NOT NULL) as total_registered_users
FROM "iotas_sales_finance"."total_unit_summary" tus
JOIN "iotas_sales_finance"."added_registered_users" aru ON tus.building_id = aru.id
ORDER BY date, name;