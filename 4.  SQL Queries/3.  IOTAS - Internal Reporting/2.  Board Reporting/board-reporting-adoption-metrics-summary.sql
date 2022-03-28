INSERT INTO "board_reporting"."adoption_metrics_summary"

SELECT date, 0 as deployed_units, 
			occupied_units, occupied_units_online, current_residents,
            	registered_residents, added_users, registered_users

FROM "board_reporting"."onboarding_summary" os
WHERE EXTRACT(MONTH FROM os.date) IN (2, 4, 6, 8, 10, 12)
AND EXTRACT(DAY FROM os.date) = 1
AND EXTRACT(YEAR FROM os.date) = (SELECT EXTRACT(YEAR FROM max(date)) FROM "board_reporting"."onboarding_summary");