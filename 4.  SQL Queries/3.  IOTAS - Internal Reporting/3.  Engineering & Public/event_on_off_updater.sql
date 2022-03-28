TRUNCATE event_on_off;

INSERT INTO event_on_off
SELECT
	e1.datetime,
	e1.physical_feature_id,
	e1.feature_value,
	DATEDIFF(MINUTE, e1.datetime, e3.datetime)/60.0 as duration_hour
FROM (
	SELECT
		e.physical_feature_id,
		e.feature_value,
		e.datetime,
		RANK() OVER (PARTITION BY e.physical_feature_id ORDER BY datetime) AS rank
	FROM
		"logs_iot_events"."event" e) e1,
	(
		SELECT
			e.physical_feature_id,
			e.feature_value,
			e.datetime,
			RANK() OVER (PARTITION BY e.physical_feature_id ORDER BY datetime) AS rank
		FROM
			"logs_iot_events"."event" e) e2,
	(
		SELECT
			e.physical_feature_id,
			e.feature_value,
			e.datetime,
			RANK() OVER (PARTITION BY e.physical_feature_id ORDER BY datetime) AS rank
		FROM
			"logs_iot_events"."event" e) e3,
	physical_feature pf,
	physical_feature_description pfd,
	feature_type ft
WHERE
	pf.id = e1.physical_feature_id
	AND pfd.id = pf.physical_feature_description_id
	AND pfd.feature_type_id = ft.id
	AND(ft.category = 'light'
		OR ft.category = 'outlet')
	AND e1.rank = e2.rank + 1
	AND e1.physical_feature_id = e2.physical_feature_id
	AND e1.feature_value != e2.feature_value
	AND(e1.feature_value = 0
		OR e2.feature_value = 0)
	AND e1.rank + 1 = e3.rank
	AND e1.physical_feature_id = e3.physical_feature_id
	AND e1.feature_value != e3.feature_value
	AND(e1.feature_value = 0
		OR e3.feature_value = 0);