INSERT INTO "iotas_engineering"."app_usage_daily_prod"
select requesttime as app_usage_date,
        CASE WHEN ral.iotasClient LIKE '%uilding%' THEN 'mobileSdk-BuildingLink'ELSE ral.iotasClient END AS iotasClient,
        ral.iotasClientPlatform,
        b.name as building_name, b.status, b.sales_force_id, r.account_id, r.unit_id, u.name as unit_name
FROM "logs_restapi_logs"."restapi_logs" ral
    JOIN resident r on r.account_id = ral.accountid
    JOIN unit u on r.unit_id = u.id
    JOIN account a on a.id = ral.accountid
    JOIN building b on u.building_id = b.id
WHERE
DATE(requesttime) BETWEEN DATE(DATEADD(DAY, -1, GETDATE())) AND DATE(GETDATE())
AND ((httpMethod = 'POST' OR httpMethod = 'PUT' OR httpMethod = 'GET'))
AND iotasClient IN ('Alexa', 'GoogleHome', 'buildinglink', 'mobileSdk-BuildinglLink-Android', 'mobileSdk-IotasResident', 
                                    'mobileSdk-CoxResident',  'mobileSdk-WestbankResident')
AND b.status != 'TEST_PROPERTY'
GROUP BY app_usage_date, ral.iotasClient, ral.iotasClientPlatform, building_name, b.status, sales_force_id, account_id, unit_id, u.name
ORDER BY app_usage_date, account_id, iotasClient, building_name;