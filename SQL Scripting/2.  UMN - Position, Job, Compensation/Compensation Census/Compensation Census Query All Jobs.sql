--Census Current Everybody Everything ALL JOBS;  --42464 rows 11/2/2020 (legacy 42424)
with total_fte as
(select emplid, sum(fte_cnt) as tot_fte from dw_common.f_emp_hc_fte where curr_emplid is not null group by emplid),
total_ibs as
(select d.emplid,
SUM(CASE WHEN F.PAY_CMPNT_CD = 'AAA' OR F.PAY_CMPNT_CD = 'FAA' THEN F.PAY_CMPNT_RT ELSE 0.0 END) as TOT_ADMIN_AUG,
SUM(CASE WHEN F.PAY_CMPNT_CD = 'BASE' OR F.PAY_CMPNT_CD = 'HRLY' THEN D.BASE_SAL_AMNT ELSE 0.0 END) as TOT_BASE_SAL,
SUM(CASE WHEN F.PAY_CMPNT_CD = 'INCR' THEN F.PAY_CMPNT_RT ELSE 0.0 END) as TOT_INCREMENT,
SUM(CASE WHEN F.PAY_CMPNT_CD = 'REGENT' THEN F.PAY_CMPNT_RT ELSE 0.0 END)as TOT_REGENT,
SUM(CASE WHEN F.PAY_CMPNT_CD = 'HRLY' OR F.PAY_CMPNT_CD = 'BASE' THEN D.BASE_SAL_AMNT
WHEN F.PAY_CMPNT_CD IN ('INCR','REGENT','FAA','AAA') THEN F.PAY_CMPNT_RT ELSE 0.0 END) as TOT_IBS
from dw_common.F_EMP_CMPNT_PAY f, dw_common.D_UM_EMP d
where d.um_emp_sid=f.um_emp_sid
and d.JOBCD_GRP_CD in ('CS','AA','AP','FA','LR','GA','PT','ST')
and d.ZDEPTID <> 'Z0387'
and d.EMP_STS_CD IN ('A','L','P','W')
and d.EMP_CLSS_CD<>'TMP'
and d.row_curr_flag='Y'
group by d.emplid),
paid as
(select emplid, pay_prd_snap_dt as most_recent_payroll
from dw_common.d_pay_check_snap
where pay_prd_snap_dt = (select max(pay_prd_snap_dt) from dw_common.d_pay_check_snap))
SELECT distinct
a.EMPLID,
a.DSPL_LST_NM,
a.DSPL_FST_NM,
b.JOB_TTL,
b.JOB_CD,
b.INST_EML_ADDR,
b.INTERNET_ID,
b.POS_NBR,
b.POS_ENTR_DT,
b.RPT_TO_POS AS reports_to_position,
b.RPT_TO_EMPLID,
d.DSPL_FULL_NM AS reports_to_name,
c.JOB_CD reports_to_jobcode,
b.RPT_TO_TTL reports_to_jobcode_descr,
c.INST_EML_ADDR supv_email,
b.ZDEPTID,
b.ZDEPTID_LD,
b.DEPTID,
b.DEPT_NM,
b.CLLG_ADM_UNT_LD,
b.CMP_CD,
fte.tot_fte, --replace with TOTAL IBS IN RPD / TOTAL FTE
--a.office1_phone, remove
b.JOBCD_GRP_CD,
b.JOBCD_GRP_DESC,
b.ORIG_HIRE_DT,
b.JOB_CD_STRT_DT,
b.SAL_ADMIN_PLAN_CD,
(CASE WHEN b.FLSA_STS_CD='Y' THEN 'Y' else ' ' end) as um_jobcd_vclass_sw,
b.SAL_GRD_CD,
--b.job_terminated,
b.EMP_REC_NBR,
(CASE WHEN b.TENURE_STS_CD in('TEN','HIR') THEN 'Y' else 'N' end) as tenure_flag, --TENURE_FLG
(CASE WHEN b.TENURE_STS_CD in('NTK','SCT') THEN 'Y' else 'N' end) as tenure_track_flag, --TENURE_TRK_FLG
b.TENURE_STS_CD,
b.TENURE_STS_DESC,
b.ROW_CURR_FLAG,
b.STND_HR_AMNT,
b.COMP_RT,
b.COMP_FREQ_CD,
--b.CALC_PERCENT,  F_EMP_HC_FTE.FTE_CNT
b.COMP_RT_CHG_AMNT,
b.COMP_RT_CHG_PCT,
b.EFF_DT,
b.WKFC_ACTN_RSN_LD,
b.EMP_STS_DESC,
b.FULL_PRT_TIME_CD,
b.FLSA_STS_DESC,
b.EMP_CLSS_CD,
b.EMP_CLSS_DESC,
b.PAY_GRP_CD,
b.TOTL_BASE_SAL_AMNT, i.TOT_BASE_SAL,
i.TOT_ADMIN_AUG, --b.TOTL_ADM_AUG_AMNT,
i.TOT_INCREMENT, --b.TOTL_INCR_AMNT,
i.TOT_REGENT, --b.TOTL_REGENTS_PROFSHP_PAY_AMNT,
--b.TOTL_MORSE_ALUMNI_AWD_PAY_AMNT,
i.TOT_IBS, --round((b.TOTL_BASE_SAL_AMNT+b.TOTL_ADM_AUG_AMNT+b.TOTL_INCR_AMNT+b.TOTL_REGENTS_PROFSHP_PAY_AMNT)) total_salary, --TOTAL_IBS in RPD
case when i.TOT_IBS > 0 and fte.TOT_FTE > 0 THEN round((i.TOT_BASE_SAL/fte.TOT_FTE)+i.TOT_ADMIN_AUG+i.TOT_INCREMENT+i.TOT_REGENT,2) end TOTAL_ANNL_SALARY,
--(case WHEN (b.TOTL_BASE_SAL_AMNT+b.TOTL_ADM_AUG_AMNT+b.TOTL_INCR_AMNT+b.TOTL_REGENTS_PROFSHP_PAY_AMNT) > 0 and e.tot_percent_add > 0
--THEN round((b.TOTL_BASE_SAL_AMNT/e.tot_percent_add)+b.TOTL_ADM_AUG_AMNT+b.TOTL_INCR_AMNT+b.TOTL_REGENTS_PROFSHP_PAY_AMNT) END) total_annl_salary,
b.MIN_RT_HRLY_AMNT,
case when b.MID_RATE_HRLY_AMNT=b.MIN_RT_HRLY_AMNT then 0 else b.MID_RATE_HRLY_AMNT end as MID_RATE_HRLY_AMNT,
b.MAX_RT_HRLY_AMNT,
b.MIN_RT_ANNL_AMNT,
case when b.MID_RT_ANNL_AMNT=b.MIN_RT_ANNL_AMNT then 0 else b.MID_RT_ANNL_AMNT end as mid_rt_annual,
b.MAX_RT_ANNL_AMNT,
p.most_recent_payroll, --Snapshot: F_EMP_HC_FTE.PAY_PRD_NBR
(CASE WHEN (p.most_recent_payroll is not null or b.EMP_STS_CD='L') THEN 'Y' else 'N' end) as PP_or_LOA_flag, --Snapshot: F_EMP_HC_FTE.PAY_IND
b.EMP_PYMNT_TP_CD,
b.ANNL_RT_AMNT,
b.HRLY_RT_AMNT,
b.ANNL_RT_AMNT as um_actual_salary,
b.BASE_SAL_AMNT,
b.JOB_IND,
f.JOB_FAM_GRP_DESC,
b.JOB_FAM_CD,
b.JOB_FAM_LD,
b.NRMLZD_HRLY_BASE_RT,
b.WRK_TTL,
b.BRGN_UNT_CD,
b.BRGN_UNT_DESC,
b.UNION_CD,
b.UNION_DESC,
b.REG_TEMP_CD
from dw_common.d_hr_cmm_pers a, dw_common.d_um_emp b, dw_common.d_um_emp c, dw_common.d_hr_cmm_pers d, R_JOB_FAM_GRP f, paid p, total_fte fte, total_ibs i
WHERE (b.JOBCD_GRP_CD in ('CS','AA','AP','FA','LR','GA','PT','ST')) -- added ST
and a.EMPLID=b.EMPLID
and b.RPT_TO_EMPLID=c.EMPLID(+)
and b.RPT_TO_EMPLID=d.EMPLID(+)
and b.JOB_FAM_CD=f.JOB_FAM_CD(+)
--and b.JOB_IND='P'
and b.ROW_CURR_FLAG='Y'
and c.ROW_CURR_FLAG(+)='Y'
and b.ZDEPTID <> 'Z0387'
and b.EMP_STS_CD IN ('A','L','P','W')
--and c.job_terminated(+)='N'
and b.EMP_CLSS_CD<>'TMP'
and b.RPT_TO_POS=c.POS_NBR(+)
and b.emplid=p.emplid(+)
and b.emplid=fte.emplid(+)
and b.emplid=i.emplid(+)
--and b.emplid in ('2101427','2108529')
--and b.totl_base_sal_amnt<>i.tot_base_sal
--and most_recent_payroll='10/21/2020' --faculty & staff PRIMARY headcount is 26,548 on 10/28/2020
order by a.DSPL_LST_NM, a.DSPL_FST_NM;