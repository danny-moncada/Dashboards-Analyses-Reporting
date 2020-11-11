--MUST BE RUN SAME DAY AS SNAP PRIOR TO OVERNIGHT REFRESH OF D_UM_EMP
select count(*) from stg_dw.s_um_employees_snap where pay_prd_snap_dt='4/10/2019'; --754210
select count(*) from stg_dw.s_um_employees where src_updt_cd='I'; --754210

select count(*) from stg_dw.s_pay_check_snap where pay_prd_snap_dt='4/10/2019'; -- 6849180 in 361.133 seconds over 6 minutes
select count(*) from stg_dw.s_pay_check where src_updt_cd='I'; --6849180

select count(*) from dw_common.s_um_pay_calendar_snap where pay_prd_snap_dt='4/10/2019'; --2665
select count(*) from stg_dw.s_um_pay_calendar where src_updt_cd='I'; --2665

select * from dw_common.d_um_emp where row_curr_flag='Y' and ZDEPTID='Z0449'; --84
select * from dw_common.d_um_emp_snap where pay_prd_snap_dt='4/10/2019' and ZDEPTID='Z0449'; --84

select * from dw_common.d_um_emp where EMP_STS_CD in ('A','L','P','W') AND row_curr_flag='Y' and ZDEPTID='Z0449'; --48
select * from dw_common.d_um_emp_snap where EMP_STS_CD in ('A','L','P','W') AND pay_prd_snap_dt='4/10/2019' and ZDEPTID='Z0449'; --48

--STAGING
SELECT
A.*, TRUNC(A.CREAT_UPDT_TMSP)
FROM STG_DW.S_UM_EMPLOYEES A
WHERE A.UM_ZDEPTID = 'Z0449'
AND A.EMPL_STATUS in ('A','L','P','W')
AND A.STATUS_FLAG = 'C'
AND A.SRC_UPDT_CD = 'I'
ORDER BY A.DEPTID, A.LAST_NAME, A.FIRST_NAME;

--DIMENSION
SELECT A.*
FROM DW_COMMON.D_UM_EMP A
WHERE A.ZDEPTID = 'Z0449'
AND A.EMP_STS_CD in ('A','L','P','W')
AND A.ROW_CURR_FLAG='Y';

--SNAPSHOT
SELECT A.*
FROM DW_COMMON.D_UM_EMP_SNAP A
WHERE A.ZDEPTID = 'Z0449'
AND A.EMP_STS_CD in ('A','L','P','W')
AND A.ROW_CURR_FLAG='Y'
AND A.PAY_PRD_SNAP_DT='3/27/2019';

select * from dw_common.d_um_emp where row_curr_flag='Y' and EMP_STS_CD in ('A','L','P','W'); --48807 PRD
select * from dw_common.d_um_emp_snap where pay_prd_snap_dt='4/10/2019' and EMP_STS_CD in ('A','L','P','W'); --48807 PRD

select * from dw_common.d_um_emp a, dw_common.d_um_emp_snap b
where a.um_emp_sid=b.um_emp_sid
and a.um_emp_nk_sid=b.um_emp_nk_sid
and a.EMP_STS_CD in ('A','L','P','W') AND a.row_curr_flag='Y' --and a.ZDEPTID='Z0449'
and b.pay_prd_snap_dt='3/27/2019'
and (a.EMPLID<>b.EMPLID
or a.EMP_REC_NBR<>b.EMP_REC_NBR
or a.EFF_DT<>b.EFF_DT
or a.EFF_SEQ_NBR<>b.EFF_SEQ_NBR
or a.FST_NM_TXT<>b.FST_NM_TXT
or a.LST_NM_TXT<>b.LST_NM_TXT
or a.ORIG_HIRE_DT<>b.ORIG_HIRE_DT
or a.UNIV_STRT_DT<>b.UNIV_STRT_DT
or a.POS_NBR<>b.POS_NBR
or a.EMP_STS_CD<>b.EMP_STS_CD
or a.EMP_STS_DESC<>b.EMP_STS_DESC
or a.RPT_TO_EMPLID<>b.RPT_TO_EMPLID
or a.RPT_TO_FULL_NM_TXT<>b.RPT_TO_FULL_NM_TXT
or a.DEPTID<>b.DEPTID
or a.DEPT_NM<>b.DEPT_NM
or a.DEPT_ENTR_DT<>b.DEPT_ENTR_DT
or a.JOB_IND<>b.JOB_IND
or a.JOB_IND_DESC<>b.JOB_IND_DESC
or a.PAY_GRP_CD<>b.PAY_GRP_CD
or a.PAY_GRP_DESC<>b.PAY_GRP_DESC
or a.SAL_ADMIN_PLAN_CD<>b.SAL_ADMIN_PLAN_CD
or a.SAL_ADMIN_PLAN_SD<>b.SAL_ADMIN_PLAN_SD
or a.BASE_SAL_AMNT<>b.BASE_SAL_AMNT
or a.NRMLZD_ANNL_BASE_SAL<>b.NRMLZD_ANNL_BASE_SAL
or a.MIN_RT_ANNL_AMNT<>b.MIN_RT_ANNL_AMNT
or a.MID_RT_ANNL_AMNT<>b.MID_RT_ANNL_AMNT
or a.MAX_RT_ANNL_AMNT<>b.MAX_RT_ANNL_AMNT
or a.STND_HR_AMNT<>b.STND_HR_AMNT
or a.COMP_FREQ_CD<>b.COMP_FREQ_CD
or a.COMP_FREQ_DESC<>b.COMP_FREQ_DESC
or a.COMP_RT<>b.COMP_RT
or a.NRMLZD_HRLY_BASE_RT<>b.NRMLZD_HRLY_BASE_RT
or a.MID_RATE_HRLY_AMNT<>b.MID_RATE_HRLY_AMNT
or a.COMPA_RTIO<>b.COMPA_RTIO
or a.ANNL_RT_AMNT<>b.ANNL_RT_AMNT
or a.EMP_PYMNT_TP_CD<>b.EMP_PYMNT_TP_CD
or a.LST_WRK_DT<>b.LST_WRK_DT
or a.REG_TEMP_CD<>b.REG_TEMP_CD
or a.FLSA_STS_CD<>b.FLSA_STS_CD
or a.FULL_PRT_TIME_CD<>b.FULL_PRT_TIME_CD
or a.ADD_FTE_ACTL_IND<>b.ADD_FTE_ACTL_IND
or a.JOBCD_GRP_CD<>b.JOBCD_GRP_CD
or a.JOBCD_GRP_DESC<>b.JOBCD_GRP_DESC
or a.COMP_CD<>b.COMP_CD
or a.WKFC_ACTN_CD<>b.WKFC_ACTN_CD
or a.WKFC_ACTN_LD<>b.WKFC_ACTN_LD
or a.WKFC_ACTN_RSN_CD<>b.WKFC_ACTN_RSN_CD
or a.WKFC_ACTN_RSN_LD<>b.WKFC_ACTN_RSN_LD
or a.WKFC_ACTN_DT<>b.WKFC_ACTN_DT
or a.EMP_CLSS_CD<>b.EMP_CLSS_CD
or a.EMP_CLSS_DESC<>b.EMP_CLSS_DESC
or a.JOB_CD<>b.JOB_CD
or a.JOB_TTL<>b.JOB_TTL
or a.JOB_FUNC_CD<>b.JOB_FUNC_CD
or a.JOB_FUNC_DESC<>b.JOB_FUNC_DESC
or a.JOB_FAM_CD<>b.JOB_FAM_CD
or a.JOB_FAM_LD<>b.JOB_FAM_LD
or a.OPRTR_PPLSFT_LOGN_ID<>b.OPRTR_PPLSFT_LOGN_ID
or a.EMP_CNTR_BGN_DT<>b.EMP_CNTR_BGN_DT
or a.EMP_CNTR_END_DT<>b.EMP_CNTR_END_DT
or a.EMP_CNTR_PYMNT_BGN_DT<>b.EMP_CNTR_PYMNT_BGN_DT
or a.EMP_CNTR_PYMNT_END_DT<>b.EMP_CNTR_PYMNT_END_DT
or a.EMP_CNTR_TP_CD<>b.EMP_CNTR_TP_CD
or a.EMP_CNTR_TP_DESC<>b.EMP_CNTR_TP_DESC
or a.EMP_CNTR_ANNL_RNEW_NBR<>b.EMP_CNTR_ANNL_RNEW_NBR
or a.EMP_CNTR_ACTL_STRT_DT<>b.EMP_CNTR_ACTL_STRT_DT
or a.TENURE_STS_CD<>b.TENURE_STS_CD
or a.TENURE_STS_DESC<>b.TENURE_STS_DESC
or a.TENURE_HM_ZDEPTID_DESC<>b.TENURE_HM_ZDEPTID_DESC
or a.TENURE_FLG<>b.TENURE_FLG
or a.TENURE_TRK_FLG<>b.TENURE_TRK_FLG
or a.IPED_JOB_CATGY_CD<>b.IPED_JOB_CATGY_CD
or a.IPED_JOB_CATGY_DESC<>b.IPED_JOB_CATGY_DESC
or a.EEO_JOB_GRP_CD<>b.EEO_JOB_GRP_CD
or a.US_SOC_CD<>b.US_SOC_CD
or a.US_SOC_DESC<>b.US_SOC_DESC
or a.WKFC_CATGY_CD<>b.WKFC_CATGY_CD
or a.ADM_COST_BNMRK_SBGRP_CD<>b.ADM_COST_BNMRK_SBGRP_CD
or a.WKFC_TAXON_3_CD<>b.WKFC_TAXON_3_CD
or a.WKFC_CATGY_DESC<>b.WKFC_CATGY_DESC
or a.ADM_COST_BNMRK_CD<>b.ADM_COST_BNMRK_CD
or a.ADM_COST_BNMRK_DESC<>b.ADM_COST_BNMRK_DESC
or a.JOB_CATGY_DESC<>b.JOB_CATGY_DESC
or a.ZDEPTID<>b.ZDEPTID
or a.ZDEPTID_LD<>b.ZDEPTID_LD
or a.CLLG_ADM_UNT_CD<>b.CLLG_ADM_UNT_CD
or a.CLLG_ADM_UNT_LD<>b.CLLG_ADM_UNT_LD
or a.VP_ADM_UNT_CD<>b.VP_ADM_UNT_CD
or a.VP_ADM_UNT_LD<>b.VP_ADM_UNT_LD
or a.CMP_CD<>b.CMP_CD
or a.CMP_LD<>b.CMP_LD
or a.POS_ENTR_DT<>b.POS_ENTR_DT  --(Position Entry Date)
or a.BUSI_TTL<>b.BUSI_TTL --(Business Title)
or a.RPT_TO_POS<>b.RPT_TO_POS --(Reports To Position)
or a.RPT_TO_TTL<>b.RPT_TO_TTL  --(Reports To Title)
or a.UNION_CD<>b.UNION_CD --(Union Code)
or a.UNION_DESC<>b.UNION_DESC --(Union Code)
or a.BRGN_UNT_CD<>b.BRGN_UNT_CD --(Bargaining Unit)
or a.BRGN_UNT_DESC<>b.BRGN_UNT_DESC --(Bargaining Unit)
or a.FLSA_STS_DESC<>b.FLSA_STS_DESC --(FLSA Status)
or a.INST_EML_ADDR<>b.INST_EML_ADDR  --(Institutional Email Address)
or a.INTERNET_ID<>b.INTERNET_ID --(Internet ID)
or a.ANNL_RT_AMNT<>b.ANNL_RT_AMNT --d_um_emp.ANNL_RT_AMNT from s_um_employees.ANNUAL_RT to s_um_employees.UM_ACTUAL_SALARY
or a.ROW_EFF_DT<>b.ROW_EFF_DT
or a.ROW_EXPIR_DT<>b.ROW_EXPIR_DT
or a.ROW_CURR_FLAG<>b.ROW_CURR_FLAG
or a.ROW_CURR_UNQK_FLAG<>b.ROW_CURR_UNQK_FLAG
or a.FUTR_DT_IND<>b.FUTR_DT_IND
or a.SRC_UPDT_CD<>b.SRC_UPDT_CD
or a.STND_HSH_CD<>b.STND_HSH_CD
or a.WRKFLW_LOG_SID<>b.WRKFLW_LOG_SID
or a.CREAT_UPDT_BY<>b.CREAT_UPDT_BY
or a.CREAT_UPDT_TMSP<>b.CREAT_UPDT_TMSP);