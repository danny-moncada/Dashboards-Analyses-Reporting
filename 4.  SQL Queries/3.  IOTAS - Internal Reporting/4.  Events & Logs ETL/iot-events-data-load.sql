TRUNCATE "logs_iot_events"."event_data_load";

INSERT INTO "logs_iot_events"."event_data_load"
SELECT *, 
CAST(datetime AS VARCHAR) || CAST(physical_feature_id AS VARCHAR) || CAST(sequence_number AS VARCHAR) || CAST(feature_value AS VARCHAR) as event_key 
FROM
(
  SELECT
GETDATE() AS created_at,
CAST(json_extract_path_text(data, 'datetime') AS TIMESTAMP) AS datetime,
CAST(json_extract_path_text(data, 'featureId') AS INTEGER) as physical_feature_id,
CAST(json_extract_path_text(data, 'sequenceNumber') AS INTEGER) as sequence_number,
CAST(json_extract_path_text(data, 'featureValue') AS FLOAT) as feature_value

FROM "logs_iot_events"."event_data_staging"
  ) t1
ORDER BY t1.datetime;