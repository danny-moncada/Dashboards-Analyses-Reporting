INSERT INTO "logs_restapi_logs"."restapi_feature_updates"
SELECT a.datetime, iotasclientplatform, 
   accountid, feature_id 
FROM 
(
  SELECT 
  CAST( replace (replace ( requestPath , '/api/v1/feature/', '' ), '/value','') as INTEGER) as feature_id, 
requesttime as datetime,
l.iotasclientplatform, 
  accountid as accountid
FROM "logs_restapi_logs"."restapi_logs" l 
  WHERE (httpMethod = 'PUT') and requestpath like '/api/v1/feature/%') a
WHERE DATE(datetime) = DATE(DATEADD(DAY, -1, GETDATE()));