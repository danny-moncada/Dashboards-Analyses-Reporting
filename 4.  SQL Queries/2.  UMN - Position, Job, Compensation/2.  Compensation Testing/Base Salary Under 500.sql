## For data quality, looking at salaries less than $500.

with empcomp as  
(select distinct a.emplid  
, a.empl_rcd, a.empl_status, UM_EMPL_STAT_DESCR, a.effdt, a.jobcode, a.annual_rt, a.um_tot_base_salary,   
a.um_tot_admin_aug, a.um_total_increment, a.um_total_regent, a.annual_rt, a.comprate, a.fte, a.paygroup, b.comp_ratecd,   
b.comprate, b.erncd, b.source  
from hr_ps_um_employees_pub_vw a, hr_ps_um_emp_comp_vw b  
where a.emplid=b.emplid  
and a.empl_rcd=b.empl_rcd  
and a.effdt = b.effdt  
and a.effseq = b.effseq  
and a.empl_status in ('A','P','L','W')  
and a.status_flag='C'   
and b.status_flag='C'  
and b.comp_ratecd in ('AAA','FAA','INCR','REGENT')),  
base as (  
select a.emplid, a.empl_rcd, b.comp_ratecd, b.comprate, a.std_hours  
from hr_ps_um_employees_pub_vw a, hr_ps_um_emp_comp_vw b  
where a.emplid=b.emplid  
and a.empl_rcd=b.empl_rcd  
and a.effdt = b.effdt  
and a.effseq = b.effseq  
and a.empl_status in ('A','P','L','W')  
and a.status_flag='C'   
and b.status_flag='C'  
and b.comp_ratecd in ('BASE') 
and a.paygroup not in ('PLH','ZNP')   
and a.emplid not in (select emplid from empcomp)),  
allbase as  
(select emplid, sum(comprate*std_hours/40) allbase  
from base  
group by emplid)  
select b.emplid, a.empl_rcd, a.annual_rt, round(b.allbase), round(a.um_tot_base_salary),   
round(a.um_tot_base_salary)-round(b.allbase),  
round(b.allbase)-round(a.um_tot_base_salary)   
from hr_ps_um_employees_pub_vw a, allbase b  
where a.emplid=b.emplid  
and a.empl_status in ('A','L','P','W')  
and a.status_flag='C'  
and a.paygroup not in ('PLH','ZNP')  
and round(a.um_tot_base_salary)<>round(b.allbase)  
and (round(a.um_tot_base_salary)-round(b.allbase) < 500  
 or round(b.allbase)-round(a.um_tot_base_salary) < 500)  
and a.emplid not in (  
select a.emplid  
/*, a.empl_rcd, a.empl_status, UM_EMPL_STAT_DESCR, a.effdt, a.jobcode, a.annual_rt, a.um_tot_base_salary,   
a.um_tot_admin_aug, a.um_total_increment, a.um_total_regent, a.annual_rt, a.comprate, a.fte, a.paygroup, b.comp_ratecd,   
b.comprate, b.erncd, b.source*/  
from hr_ps_um_employees_pub_vw a, hr_ps_um_emp_comp_vw b  
where a.emplid=b.emplid  
and a.empl_rcd=b.empl_rcd  
and a.effdt = b.effdt  
and a.effseq = b.effseq  
and a.empl_status in ('A','P','L','W')  
and a.status_flag='C'   
and b.status_flag='C'  
and b.comp_ratecd='HRLY')  
order by 1