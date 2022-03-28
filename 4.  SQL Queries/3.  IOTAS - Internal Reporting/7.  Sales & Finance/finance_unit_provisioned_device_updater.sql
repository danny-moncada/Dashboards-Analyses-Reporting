TRUNCATE TABLE "iotas_sales_finance"."unit_provisioned_device_prod";
INSERT INTO "iotas_sales_finance"."unit_provisioned_device_prod"
select b.id as building_id, b.name as building_name, b.status, b.sales_force_id, u.id as unit_id, u.name as unit_name, h.id as hub_id, 
h.serial_number as hub_serial, pd1.first_device_paired as first_mapped_device, 
u.provisionedat as unit_provisioned, pdd.name as device_type, count(*) as count, pdd.model, pdd.manufacturer 
from 
 physical_device pd,
 physical_device_description pdd,
 hub h,
 unit u,
room r,
device d,
building  b,
 (SELECT hub_id, min(created_at) as first_device_paired FROM physical_device pd group by hub_id) pd1
 where pd.physical_device_description_id = pdd.id
and h.unit_id = u.id 
and u.building_id = b.id 
and pd1.hub_id  = h.id 
and u.id = r.unit_id 
and r.id = d.room_id 
and d.physical_device_id = pd.id 
 group by b.id, b.name, b.status, b.sales_force_id, 
 u.id, u.name, h.id, h.serial_number, 
 pdd.name, pd1.first_device_paired, u.provisionedat, pdd.model, pdd.manufacturer
order by b.name;