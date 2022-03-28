INSERT INTO event_motion 
select e.datetime, e.physical_feature_id, e.feature_value
from
physical_feature  pf,
physical_feature_description   pfd,
feature_type ft,
"logs_iot_events"."event" e 
WHERE pf.id = e.physical_feature_id 
AND ft.id = pfd.feature_type_id 
AND pf.physical_feature_description_id = pfd.id 
AND ft.name = 'Motion' 
AND date(datetime) = DATE(DATEADD(DAY, -1, GETDATE()));