INSERT INTO "iotas_engineering"."resident_app_dau_mau_prod"

SELECT DATE(DATEADD(DAY, -1, GETDATE())) as date, 
    t1.iotasClient, t1.iotasClientPlatform, t1.building_name, t1.sales_force_id, t1.daily_active_users, t2.monthly_active_users
FROM 
(
SELECT iotasClient, iotasClientPlatform, building_name, sales_force_id, count(distinct account_id) as daily_active_users 
FROM "iotas_engineering"."app_usage_daily_prod"
WHERE DATE(app_usage_date) BETWEEN DATE(DATEADD(DAY, -1, GETDATE())) AND DATE(GETDATE())
GROUP BY iotasClient, iotasClientPlatform, building_name, sales_force_id) t1
JOIN
(SELECT iotasClient, iotasClientPlatform, building_name, sales_force_id, count(distinct account_id) as monthly_active_users 
FROM "iotas_engineering"."app_usage_daily_prod"
WHERE DATE(app_usage_date) BETWEEN DATE(DATEADD(DAY, -31, GETDATE())) AND DATE(DATEADD(DAY, -1, GETDATE()))
GROUP BY iotasClient, iotasClientPlatform, building_name, sales_force_id) t2
ON t1.iotasClient = t2.iotasClient
AND t1.iotasClientPlatform = t2.iotasClientPlatform
AND t1.building_name = t2.building_name
AND t1.sales_force_id = t2.sales_force_id;