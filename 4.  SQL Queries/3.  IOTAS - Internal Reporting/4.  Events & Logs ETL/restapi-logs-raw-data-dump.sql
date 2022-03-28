TRUNCATE "logs_restapi_logs"."restapi_logs_data_prod";

COPY "logs_restapi_logs"."restapi_logs_data_prod" 
FROM 's3://iotas-redshift-prod-restapi-logs/2022/' 
IAM_ROLE 'arn:aws:iam::903710382147:role/RedshiftS3prod'
JSON 's3://iotas-redshift-prod-restapi-logs/prod_restapi_logs.json'
GZIP
ACCEPTINVCHARS ' '
TRUNCATECOLUMNS
TRIMBLANKS;