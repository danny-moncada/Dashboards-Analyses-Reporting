## Bifurcated Faculty Salary

=======================================
select p.rrc, p.rrc_descr, p.jobcode, p.jobcode_descr, sum(p.cy_salary) as cy_salary, sum(p.py_salary) as
py_salary, count(p.emplid) as headcount, avg(p.pct_change) as pct_change,
(sum(p.cy_salary) - sum(p.py_salary))/ sum(p.py_salary) as pct_change2
from
    (select a.rrc, a.rrc_descr, a.jobcode, a.jobcode_descr, a.cy_salary, b.py_salary, a.emplid,
    (a.cy_salary - b.py_salary)/b.py_salary as pct_change
    from
    (select q.emplid, round((CASE WHEN q.ir_annual_contract='2' THEN q.ir_tot_salary*(9/11) ELSE
    q.ir_tot_salary END),0)  as cy_salary, q.rrc, q.rrc_descr, q.jobcode, q.jobcode_descr
    from ps_dweo_ir_hr_ipeds q
    where q.archive_dt='10/23/2019'             --CHANGE
    and q.ir_pct_cd='1'                         --only full-time
    and q.ir_eap_faculty_status='01'            --only tenured for current year
    and q.ir_job_category in ('01','02','03')   --Professors, Assoc. and Asst (excludes Deans/Chairs/VP's)
    ) a,
    (select q.emplid, round((CASE WHEN q.ir_annual_contract='2' THEN q.ir_tot_salary*(9/11) ELSE
    q.ir_tot_salary END),0)  as py_salary, q.rrc, q.rrc_descr, q.jobcode, q.jobcode_descr
    from ps_dweo_ir_hr_ipeds q
    where  q.archive_dt='10/24/2018'            --CHANGE
    and q.ir_pct_cd='1'                         --only full-time
    and q.ir_job_category in ('01','02','03')   --Professors, Assoc. and Asst (excludes Deans/Chairs/VP's)
    --and q.emplid not in (select emplid from irr.ps_dweo_ir_hr_ipeds_f17_dlcr)       --EXCLUDES UMNDL and UMNCR
    ) b
where a.emplid=b.emplid) p
group by  p.rrc, p.rrc_descr, p.jobcode, p.jobcode_descr
order by 1, 3
