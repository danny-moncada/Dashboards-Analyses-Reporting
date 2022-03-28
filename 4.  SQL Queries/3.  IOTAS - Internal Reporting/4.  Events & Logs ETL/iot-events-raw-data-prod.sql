TRUNCATE "logs_iot_events"."event_data_staging";

COPY "logs_iot_events"."event_data_staging" 
FROM 's3://iotas-redshift-prod-iot-events/2022/' 
IAM_ROLE 'arn:aws:iam::903710382147:role/RedshiftS3prod'
JSON 's3://iotas-redshift-prod-iot-events/prod_iot_event.json'
ACCEPTINVCHARS ' '
TRUNCATECOLUMNS
TRIMBLANKS
REGION 'us-east-1';