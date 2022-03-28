INSERT INTO "logs_restapi_logs"."restapi_logs"

SELECT
  json_extract_path_text(log_events_message, 'requestId') as requestId,
  json_extract_path_text(log_events_message, 'ip') as ip,
  REPLACE(
    json_extract_path_text(log_events_message, 'caller'),
    '-',
    NULL
  ) as caller,
  json_extract_path_text(log_events_message, 'domainName') as domainName,
  REPLACE(
    json_extract_path_text(log_events_message, 'user'),
    '-',
    NULL
  ) as user,
  json_extract_path_text(log_events_message, 'userAgent') as userAgent,
  CAST(
    json_extract_path_text(log_events_message, 'requestTime') AS TIMESTAMP
  ) as requestTime,
  json_extract_path_text(log_events_message, 'httpMethod') as httpMethod,
  json_extract_path_text(log_events_message, 'resourcePath') as resourcePath,
  json_extract_path_text(log_events_message, 'requestPath') as requestPath,
  CAST(
    json_extract_path_text(log_events_message, 'status') AS INTEGER
  ) as status,
  json_extract_path_text(log_events_message, 'protocol') as protocol,
  CAST(
    json_extract_path_text(log_events_message, 'responseLength') AS INTEGER
  ) as responseLength,
  CASE WHEN json_extract_path_text(log_events_message, 'appId') = '-' THEN NULL ELSE CAST(json_extract_path_text(log_events_message, 'appId') AS INTEGER) END as appId,
  
  CASE WHEN json_extract_path_text(log_events_message, 'iotasClient') = '-' THEN NULL ELSE json_extract_path_text(log_events_message, 'iotasClient') END as iotasClient,
  CASE WHEN json_extract_path_text(log_events_message, 'iotasClientPlatform') = '-' THEN NULL ELSE json_extract_path_text(log_events_message, 'iotasClientPlatform') END as iotasClientPlatform,
  CASE WHEN json_extract_path_text(log_events_message, 'iotasClientVersion') = '-' THEN NULL ELSE json_extract_path_text(log_events_message, 'iotasClientVersion') END as iotasClientVersion,
  CASE WHEN json_extract_path_text(log_events_message, 'accountId') = '-' THEN NULL ELSE CAST(json_extract_path_text(log_events_message, 'accountId') AS INTEGER) END as accountId,
  CASE WHEN json_extract_path_text(log_events_message, 'role') = '-' THEN NULL ELSE json_extract_path_text(log_events_message, 'role') END as role,
  CAST(
    json_extract_path_text(log_events_message, 'responseLatency') AS INTEGER
  ) as responseLatency
FROM
  "logs_restapi_logs"."restapi_logs_data_prod"

WHERE CAST(json_extract_path_text(log_events_message, 'requestTime') AS TIMESTAMP) > (SELECT max(requesttime) FROM "logs_restapi_logs"."restapi_logs");

TRUNCATE "logs_restapi_logs"."restapi_logs_data_prod";