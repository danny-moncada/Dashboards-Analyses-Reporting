INSERT INTO "iotashome_prod_db"."freshdesk"."freshdesk_ticket_history"

SELECT * 
FROM "iotashome_prod_db"."freshdesk"."freshdesk_weekly_tickets"
WHERE "iotashome_prod_db"."freshdesk"."freshdesk_weekly_tickets"."created time" >= (SELECT max("created time") FROM "iotashome_prod_db"."freshdesk"."freshdesk_ticket_history");