select count(e.emplid)--, sum(PRM_HR_H_CNT) PRIM_HC, sum(PRM_FTE_CNT) PRIM_FTE, e.WKFC_CATGY_CD, e.WKFC_CATGY_DESC
from dw_common.F_EMP_HC_FTE_SNAP f,
dw_common.d_hr_org_snap d,
dw_common.d_um_emp_snap e
where f.hr_org_nk_sid=d.hr_org_nk_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and e.row_curr_flag='Y'
and prm_job_ind = 'Y'
and curr_emplid is not null
--and e.job_catgy_desc in ('Faculty','Graduate Assistants','Labor Represented','Civil Service','Professionals-in-Training','P'||'&'||'A')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and f.PAY_PRD_SNAP_DT='3/27/2019'
and e.pay_prd_snap_dt='3/27/2019'
and d.pay_prd_snap_dt='3/27/2019'
--group by e.WKFC_CATGY_CD, e.WKFC_CATGY_DESC
--order by e.WKFC_CATGY_CD, e.WKFC_CATGY_DESC
;

select sum(PRM_HR_H_CNT) PRIM_HC, sum(PRM_FTE_CNT) PRIM_FTE, e.WKFC_CATGY_CD, e.WKFC_CATGY_DESC
from dw_common.F_EMP_HC_FTE_SNAP f,
dw_common.d_hr_org_snap d,
dw_common.d_um_emp_snap e
where f.hr_org_nk_sid=d.hr_org_nk_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and e.row_curr_flag='Y'
and prm_job_ind = 'Y'
and curr_emplid is not null
--and e.job_catgy_desc in ('Faculty','Graduate Assistants','Labor Represented','Civil Service','Professionals-in-Training','P'||'&'||'A')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_sts_cd in ('A','L','P','W')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
and f.PAY_PRD_SNAP_DT='3/27/2019'
and d.PAY_PRD_SNAP_DT='3/27/2019'
and e.PAY_PRD_SNAP_DT='3/27/2019'
group by e.WKFC_CATGY_CD, e.WKFC_CATGY_DESC
order by e.WKFC_CATGY_CD, e.WKFC_CATGY_DESC;