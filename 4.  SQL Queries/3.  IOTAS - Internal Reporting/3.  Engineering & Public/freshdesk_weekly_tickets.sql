TRUNCATE iotashome_prod_db.freshdesk.freshdesk_weekly_tickets;

COPY iotashome_prod_db.freshdesk.freshdesk_weekly_tickets 
FROM 's3://iotas-redshift-freshdesk/' 
IAM_ROLE 'arn:aws:iam::903710382147:role/RedshiftS3prod' 
FORMAT AS CSV 
DELIMITER ',' 
QUOTE '"' 
REGION AS 'us-east-1'
IGNOREHEADER 1;