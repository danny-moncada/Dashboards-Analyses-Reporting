-- Primary and Secondary Headcount and FTE should match exactly (if no primary job data error related issues)

-- Possible Primary Job errors include:
-- No primary job, only Secondard Job(s)
-- Secondary Job should be the Primary Job but instead the incorrect empl_rcd is Primary and in an excluded Job Category (ST, NA,TMP)

SELECT e.cmp_cd, 
count(distinct e.um_emp_nk_sid), -- count(case when e.JOB_IND in ('P','S') then e.emplid end), 
count(case when e.JOB_IND='P' then e.emplid end), 
count(case when e.JOB_IND='S' then e.emplid end), 
COUNT(DISTINCT e.emplid||e.deptid), 
sum(case 
when e.job_ind='P' and e.PAY_GRP_CD='PLH' then 0 
when e.job_ind='P' and e.EMP_CLSS_CD='TMP' then 0 
when e.job_ind='P' and e.JOBCD_GRP_CD in ('ST','NA') then 0 
when e.job_ind='P' then STND_HR_AMNT/40 
end) as prm_fte, 
sum(case 
when e.job_ind='S' and e.PAY_GRP_CD='PLH' then 0 
when e.job_ind='S' and e.EMP_CLSS_CD='TMP' then 0 
when e.job_ind='S' and e.JOBCD_GRP_CD in ('ST','NA') then 0 
when e.job_ind='S' then STND_HR_AMNT/40 
end) as scndry_fte, 
sum(case 
when e.PAY_GRP_CD='PLH' then 0 
when e.EMP_CLSS_CD='TMP' then 0 
when e.JOBCD_GRP_CD in ('ST','NA') then 0 
else STND_HR_AMNT/40 
end) as all_fte, 
COUNT(DISTINCT e.emplid||e.deptid), 
COUNT(DISTINCT e.emplid||e.zdeptid), 
COUNT(DISTINCT e.emplid||e.cllg_adm_unt_cd), 
COUNT(DISTINCT e.emplid||e.vp_adm_unt_cd), 
COUNT(DISTINCT e.emplid||e.cmp_cd), 
COUNT(DISTINCT e.emplid) 
FROM DW_COMMON.D_UM_EMP_SNAP E 
where e.COMP_CD='UMN' 
and e.EMP_STS_CD in ('A','L','P','W') 
and ROW_CURR_FLAG='Y' 
and e.ZDEPTID <> 'Z0387' 
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT') 
and e.EMP_CLSS_CD<>'TMP' 
and pay_prd_snap_dt='3/27/2019'
and job_ind='P'
group by e.cmp_cd;