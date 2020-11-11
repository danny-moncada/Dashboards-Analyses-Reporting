--VALIDATE BY EMPLID
SELECT * FROM DW_COMMON.F_EMP_COMP_SNAP where emplid='2108529' and prm_all_job_cd='A' order by pay_prd_snap_dt desc; --eyeball test one row per snap date
SELECT * FROM DW_COMMON.D_UM_EMP_SNAP where emplid='2108529' and row_curr_unqk_flag='Y' order by pay_prd_snap_dt desc;


--VALIDATE TOHR
select count(distinct e.emplid)
from dw_common.F_EMP_COMP_SNAP f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and e.row_curr_flag='Y'
and f.curr_emplid is not null
and f.prm_all_job_cd = 'A'
--and d.cmp_cd='TXXX'
--and d.vp_adm_unt_cd='THRS'
and d.cllg_adm_unt_cd='TOHR'
--and d.zdeptid='Z0449'
--and d.deptid='12231'
and f.pay_prd_snap_dt='3/27/2019';

--VALIDATE TCLA
select count(distinct e.emplid)
from dw_common.F_EMP_COMP_snap f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and e.row_curr_flag='Y'
and f.curr_emplid is not null
and f.prm_all_job_cd = 'A'
and d.cllg_adm_unt_cd='TCLA'
--and f.prm_job_ind='Y'
and f.PAY_PRD_SNAP_DT='3/27/2019'

--VALIDATE Anthropology (Taussig has two empl_rcds in same deptid 9402 & 9360 1.18125 FTE overall)
select count(distinct e.emplid)
from dw_common.F_EMP_COMP_SNAP f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and e.row_curr_flag='Y'
and d.deptid='10950'
and CURR_EMPLID IS NOT NULL
and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and f.pay_prd_snap_dt='3/27/2019';

--VALIDATE FACT-DIMENSION-STAGING-SOURCE UM_EMPLOYEES 
select distinct e.emplid, e.empl_rcd
FROM HR_PS_UM_EMPLOYEES_PUB_VW E
where e.company='UMN'
and ((e.empl_status in ('A','L','P','W') and e.status_flag='C')
or (e.empl_status in ('A','L','P','W') and e.status_flag='F' and e.effdt=trunc(sysdate)))
and e.um_zdeptid <> 'Z0387'
and e.um_jobcode_group in ('AA','AP','FA','CS','LR','GA','PT')
and e.empl_class<>'TMP'
and e.job_indicator='P'
minus
select distinct e.emplid, e.empl_rcd
FROM HR_PS_UM_EMPLOYEES_PUB_VW E
where e.company='UMN'
and ((e.empl_status not in ('A','L','P','W') and e.status_flag='F' and e.effdt=trunc(sysdate))
or (e.empl_status in ('A','L','P','W') and e.empl_class='TMP' and e.status_flag='F' and e.effdt=trunc(sysdate)))
and e.um_zdeptid <> 'Z0387'
and e.um_jobcode_group in ('AA','AP','FA','CS','LR','GA','PT')
and e.job_indicator='P';

--VALIDATE DWEPRD ALL ROWS HEADCOUNT SYSTEMWIDE
select distinct e.emplid||e.empl_rcd
FROM HR_PS_UM_EMPLOYEES_PUB_VW E
where e.company='UMN'
and ((e.empl_status in ('A','L','P','W') and e.status_flag='C')
or (e.empl_status in ('A','L','P','W') and e.status_flag='F' and e.effdt=trunc(sysdate)))
and e.um_zdeptid <> 'Z0387'
and e.um_jobcode_group in ('AA','AP','FA','CS','LR','GA','PT')
and e.empl_class<>'TMP'
and e.job_indicator='P'
minus
select distinct e.emplid||empl_rcd
FROM HR_PS_UM_EMPLOYEES_PUB_VW E
where e.company='UMN'
and ((e.empl_status not in ('A','L','P','W') and e.status_flag='F' and e.effdt=trunc(sysdate))
or (e.empl_status in ('A','L','P','W') and e.empl_class='TMP' and e.status_flag='F' and e.effdt=trunc(sysdate)))
and e.um_zdeptid <> 'Z0387'
and e.um_jobcode_group in ('AA','AP','FA','CS','LR','GA','PT')
and e.job_indicator='P';

--VALIDATE DWEPRD DISTINCT HEADCOUNT SYSTEMWIDE
select distinct e.emplid
FROM HR_PS_UM_EMPLOYEES_PUB_VW E
where e.company='UMN'
and ((e.empl_status in ('A','L','P','W') and e.status_flag='C')
or (e.empl_status in ('A','L','P','W') and e.status_flag='F' and e.effdt=trunc(sysdate)))
and e.um_zdeptid <> 'Z0387'
and e.um_jobcode_group in ('AA','AP','FA','CS','LR','GA','PT')
and e.empl_class<>'TMP'
and e.job_indicator='P'
minus
select distinct e.emplid
FROM HR_PS_UM_EMPLOYEES_PUB_VW E
where e.company='UMN'
and ((e.empl_status not in ('A','L','P','W') and e.status_flag='F' and e.effdt=trunc(sysdate))
or (e.empl_status in ('A','L','P','W') and e.empl_class='TMP' and e.status_flag='F' and e.effdt=trunc(sysdate)))
and e.um_zdeptid <> 'Z0387'
and e.um_jobcode_group in ('AA','AP','FA','CS','LR','GA','PT')
and e.job_indicator='P';

--VALIDATE HEADCOUNT SYSTEMWIDE -- counts should match -- if different identify primary job errors
select 'All Jobs' headcount, count(distinct emplid)
from DW_COMMON.D_UM_EMP_SNAP e
where row_curr_flag='Y'
and e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
and job_ind in ('P','S')
and e.pay_prd_snap_dt='3/27/2019'
union
select 'Primary Job' headcount, count(distinct emplid)
from DW_COMMON.D_UM_EMP_SNAP e
where row_curr_flag='Y'
and e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
and job_ind='P'
and e.pay_prd_snap_dt='3/27/2019';

select emplid
from DW_COMMON.D_UM_EMP e
where row_curr_flag='Y'
and e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT') --JOBCD_GRP_CD
and e.EMP_CLSS_CD<>'TMP'
and job_ind in ('P','S')
minus
select emplid --*
from DW_COMMON.D_UM_EMP e
where e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
and e.row_curr_flag='Y'
and job_ind='P';

--Verify if Primary Job (run at 1pm following day) fix or if already corrected by WFDM via Daily Primary Job Audit Query
select emplid, empl_rcd, j.jobcode, job_indicator, annual_rt, std_hours, comprate, effdt, action_dt, jc.um_jobcode_group, j.empl_class
from ps_job j, ps_um_jc_cat_flat jc
where empl_status in ('A','L','P','W')
and j.jobcode=jc.jobcode
and emplid in ('5201177')
and J.EFFDT = (SELECT MAX(J_ED.EFFDT) FROM PS_JOB J_ED
WHERE J_ED.EMPLID = J.EMPLID
AND J_ED.EMPL_RCD = J.EMPL_RCD
AND J_ED.EFFDT <= sysdate)
AND J.EFFSEQ = (SELECT MAX(J_ES.EFFSEQ) FROM PS_JOB J_ES
WHERE J_ES.EMPLID = J.EMPLID
AND J_ES.EMPL_RCD = J.EMPL_RCD
AND J_ES.EFFDT = J.EFFDT)
order by emplid, empl_rcd, effdt desc;

--WFDM Data Correction
select emplid, empl_rcd, jobcode, job_indicator, annual_rt, std_hours, comprate, effdt, action_dt, empl_status, status_flag
from hr_ps_um_employees_pub_vw where empl_status in ('A','L','P','W') and status_flag in ('C','F')
and emplid in ('4249865')
order by emplid, empl_rcd, effdt desc;

--Systemwide Headcount & FTE - HC should match exactly - should match OBIEE dashboard
select 'All Jobs', count(distinct e.emplid) as headcount,
sum(case
when e.PAY_GRP_CD='PLH' then 0 --academic temp casual TMP and less than 9 month
when e.EMP_CLSS_CD='TMP' then 0 --temp/casual
when e.JOBCD_GRP_CD in ('ST','NA') then 0 --student workers and NA
else STND_HR_AMNT/40
end) as fte
FROM DW_COMMON.D_UM_EMP_SNAP E
where e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and ROW_CURR_FLAG='Y'
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
and e.pay_prd_snap_dt='3/27/2019'
union
select 'Primary Job', count(distinct e.emplid) as headcount,
sum(case
when e.PAY_GRP_CD='PLH' then 0 --academic temp casual TMP and less than 9 month
when e.EMP_CLSS_CD='TMP' then 0 --temp/casual
when e.JOBCD_GRP_CD in ('ST','NA') then 0 --student workers and NA
else STND_HR_AMNT/40
end) as fte
FROM DW_COMMON.D_UM_EMP_SNAP E
where e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and ROW_CURR_FLAG='Y'
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
and e.job_ind='P'
and e.pay_prd_snap_dt='3/27/2019';


--Rework - add JOB_CD and JOB_FAMILY_GRP
select distinct job_cd, job_ttl, job_fam_grp_desc from dw_common.f_emp_comp_snap where pay_prd_snap_dt='3/27/2019' order by 1,2;

select distinct f.job_cd, f.job_ttl, f.job_fam_grp_desc, r.job_fam_grp_desc
from dw_common.f_emp_comp_snap f, dw_common.r_job_fam_grp r
where f.JOB_FAM_GRP_DESC=r.JOB_FAM_GRP_DESC(+)
and pay_prd_snap_dt='3/27/2019'
order by 3;