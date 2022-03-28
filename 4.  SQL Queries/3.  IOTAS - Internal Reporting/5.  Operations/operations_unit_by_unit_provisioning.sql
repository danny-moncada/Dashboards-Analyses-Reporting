TRUNCATE "iotas_operations"."unit_by_unit_provisioning";
INSERT INTO
  "iotas_operations"."unit_by_unit_provisioning"
SELECT
  b.name as building_name,
  b.id as building_id,
  b.sales_force_id,
  b.status,
  u.id as unit_id,
  pd_list.hub_serial,
  pd_list.hub_id,
  u.name as unit_name,
  d_list.device_count,
  d_list.device_list,
  d_list.unpaired_device_count,
  d_list.unpaired_device_list,
  NVL(pd_list.physical_device_count, 0) as physical_device_count,
  pd_list.physical_device_list,
  pd_list.unmapped_physical_device_count,
  pd_list.unmapped_physical_device_list,
  CONVERT_TIMEZONE('PST', pd_list.first_pairing) as first_pairing,
  CONVERT_TIMEZONE('PST', pd_list.last_pairing) as last_pairing,
  DATEDIFF(MINUTE, first_pairing, last_pairing) as pairing_time,
  NVL(installers, 'No installer information') as installers,
  ut.name as floor_plan_type
FROM
  unit u
  JOIN building b ON u.building_id = b.id
  JOIN unit_template ud ON ud.id = u.unit_template_id
  LEFT JOIN (
    SELECT
      u.id as unit_id,
      h.serial_number as hub_serial,
      h.id as hub_id,
      count(pd.id) as physical_device_count,
      LISTAGG(dt.name, ', ') as physical_device_list,
      count(
        case
          when d.id is null
          and pd.id is not null then 1
          else null
        end
      ) as unmapped_physical_device_count,
      LISTAGG(
        CASE
          WHEN d.id IS NULL
          and pd.id IS NOT NULL THEN dt.name
          ELSE NULL
        END,
        ', '
      ) AS unmapped_physical_device_list,
      min(pd.created_at) as first_pairing,
      max(pd.created_at) as last_pairing,
      hadl.installers
    FROM
      unit u
      LEFT JOIN hub h ON h.unit_id = u.id
      LEFT JOIN physical_device pd ON pd.hub_id = h.id
      LEFT JOIN physical_device_description pdd ON pdd.id = pd.physical_device_description_id
      LEFT JOIN device_type dt ON dt.id = pdd.device_type_id
      LEFT JOIN device d ON d.physical_device_id = pd.id
      LEFT JOIN (
        select
          hadl.hub_id,
          LISTAGG(distinct a.email, ', ') as installers
        from
          hub_add_device_log hadl
          LEFT JOIN account a on a.id = hadl.account_id
        group by
          hadl.hub_id
      ) as hadl on hadl.hub_id = h.id
    GROUP BY
      u.id,
      h.serial_number,
      h.id,
      installers
  ) pd_list ON pd_list.unit_id = u.id
  LEFT JOIN (
    SELECT
      u.id,
      count(d.id) as device_count,
      LISTAGG(NVL(dt.name, d.name), ', ') as device_list,
      count(
        case
          when d.physical_device_id is null then d.id
          else null
        end
      ) as unpaired_device_count,
      LISTAGG(
        case
          when d.physical_device_id is null then NVL(dt.name, d.name)
          else null
        end,
        ', '
      ) as unpaired_device_list
    FROM
      unit u
      LEFT JOIN room r ON u.id = r.unit_id
      LEFT JOIN device d ON d.room_id = r.id
      Left JOIN device_type dt on dt.id = d.device_type_id
    GROUP BY
      u.id
  ) as d_list ON d_list.id = u.id
  LEFT JOIN unit_template ut ON ut.id = u.unit_template_id
where
  b.name not like '%Test%'
ORDER BY
  building_name,
  unit_name;