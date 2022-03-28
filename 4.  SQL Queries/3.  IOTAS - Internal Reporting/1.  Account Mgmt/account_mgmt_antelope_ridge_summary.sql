INSERT INTO
  "iotas_account_mgmt"."antelope_ridge_summary"
SELECT
  CURRENT_DATE as date,
  unit_name AS Unit_Number,
  Street_number,
  Street,
  serial_number as Hub_ID,
  Hub_Status,
  CASE
    WHEN years > 0 THEN years
    WHEN months > 0 THEN months
    ELSE days
  END as Length_of_Time,
  CASE
    WHEN years > 0 THEN 'years'
    WHEN months > 0 THEN 'Months'
    ELSE 'days'
  END as Time_Type
FROM
  (
    SELECT
      unit_name,
      street_number,
      address as street,
      ahd.serial_number,
      hub_status,
      DATEDIFF(DAY, last_alive, GETDATE()) as days,
      DATEDIFF(MONTH, last_alive, GETDATE()) as months,
      DATEDIFF(YEAR, last_alive, GETDATE()) as years
    FROM
      "iotas_account_mgmt"."antelope_ridge_status" ahd
      LEFT JOIN "iotas_account_mgmt"."antelope_ridge_street_address" ahs ON ahd.unit_name = ahs.yardi_unit_number
    WHERE
      ahd.date = DATE(GETDATE())
      AND hub_status = 'Offline'
    ORDER BY
      --address,
      years,
      months,
      days desc
  )
ORDER by
  time_type,
  length_of_time desc;