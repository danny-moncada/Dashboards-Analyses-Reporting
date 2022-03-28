INSERT INTO "iotas_engineering"."units_residents_active_routines"

select  DATE(GETDATE()) as active_routine_capture_date,
        'Routine' as iotasClient, 'Routine' as iotasClientPlatform,
        b.name as building_name, b.status, b.sales_force_id, res.account_id, res.unit_id, u.name as unit_name
from 
resident res
join unit u on res.unit_id = u.id
join building b on u.building_id = b.id
join account a on res.account_id = a.id
where res.tenant = 'true' and res.suspended_at IS NULL
and res.unit_id IN (
select ur.unit_id
from routine r 
join unit_routine ur on r.id = ur.routine_id
and r.active = 'true'
group by ur.unit_id)
and b.status != 'TEST_PROPERTY'
GROUP BY active_routine_capture_date, building_name, status, sales_force_id, account_id, unit_id, u.name
ORDER by active_routine_capture_date, building_name;