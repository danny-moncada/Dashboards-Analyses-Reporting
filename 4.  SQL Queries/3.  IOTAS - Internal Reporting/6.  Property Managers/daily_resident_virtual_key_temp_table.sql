INSERT INTO "external_property_managers"."daily_resident_virtual_key_temp_table"
with resident_door_code_resets as (SELECT r.building_id, count(door_code_id) as daily_resident_door_code_resets
FROM
(
SELECT DISTINCT date(requesttime) as date, 
		b.id as building_id, b.name as building_name,
        ra.accountId AS api_account_id, r.account_id as resident_account_id,
         rm.unit_id AS resident_unit_id, u.id as unit_id, r.id AS resident_id, 
         dc.id AS door_code_id,
        ra.iotasClientPlatform as ios_android, userAgent 
FROM "logs_restapi_logs"."restapi_logs" ra
        JOIN door_code dc ON CAST(SPLIT_PART(ra.requestpath, '/', 6) AS INTEGER) = dc.id --JOIN on door code by getting it from requestPath
        JOIN device d ON dc.device_id = d.id
        JOIN room rm ON d.room_id = rm.id
        JOIN unit u on rm.unit_id = u.id
        JOIN resident r ON r.unit_id = u.id AND r.account_id = ra.accountid
        JOIN building b ON u.building_id = b.id

WHERE
ra.requestPath LIKE '%/v1/access_management/door_codes/%/details%'
AND ra.httpMethod LIKE '%PUT%'
AND DATE(ra.requestTime) = DATE(DATEADD(DAY, -1, GETDATE()))
ORDER by date, building_id, api_account_id
) r
GROUP BY r.building_id), 

virtual_key_count as (select b.id as building_id, date(vk.created_at) as date, count(*) as count 
from virtual_key vk 
join guest g on vk.guest_id = g.id 
join resident r on r.id = g.host_resident_id 
join unit u on u.id = r.unit_id 
join building b on b.id = u.building_id group by b.id, date)

SELECT DATE(dateadd(DAY, -1, GETDATE())) as date,
b.name as building_name,
b.status,
b.id as building_id,
rdcr.daily_resident_door_code_resets,
NVL2(vkc.count, vkc.count, 0) as virtual_keys_created
FROM building b 
left join resident_door_code_resets rdcr on rdcr.building_id = b.id
left join virtual_key_count vkc on vkc.building_id = b.id and vkc.date = date(dateadd(day, -1, GETDATE()))
ORDER BY building_id