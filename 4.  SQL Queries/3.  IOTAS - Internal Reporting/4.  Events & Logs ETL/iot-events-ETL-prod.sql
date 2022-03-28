INSERT INTO "logs_iot_events"."event"
SELECT * FROM "logs_iot_events"."event_data_load" edl
WHERE edl.event_key NOT IN (SELECT DISTINCT e.event_key FROM "logs_iot_events"."event" e
  WHERE e.datetime >= (SELECT min(datetime) FROM "logs_iot_events"."event_data_load") )
ORDER BY edl.datetime;

TRUNCATE "logs_iot_events"."event_data_load";