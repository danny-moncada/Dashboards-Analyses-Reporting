## VALIDATE FACT ROWS MATCH DIMENSION ROWS

SELECT 
  (SELECT count(*) FROM DW_COMMON.F_EMP_HC_FTE_SNAP where prm_all_job_cd = 'A' and pay_prd_snap_dt='3/13/2019') AS F_ROWS,
  (select count(*) from (select e.emplid, e.EMP_REC_NBR,                                                                                                                                                                                                        
e.JOB_IND, e.adm_cost_bnmrk_cd,  e.JOBCD_GRP_CD,  e.JOBCD_GRP_DESC,                                                                                                                                                                                                        
e.deptid, e.JOB_CD, e.eff_dt , e.EFF_SEQ_NBR,e.STND_HR_AMNT,e.PAY_GRP_CD ,                                                                                                                                                                                                        
e.EMP_CLSS_CD  ,                                                                                                                                                                                                        
e.JOBCD_GRP_CD                                                                                                                                                                                                        
FROM DW_COMMON.D_UM_EMP_SNAP E                                                                                                                                                                                                        
left  join DW_COMMON.D_UM_EMP_SNAP c2                                                                                                                                                                                                        
on e.um_emp_nk_sid = c2.um_emp_nk_sid                                                                                                                                                                                                        
and e.eff_dt < c2.eff_dt                                                                                                                                                                                                        
where e.COMP_CD='UMN'                                                                                                                                                                                                        
and e.EMP_STS_CD in ('A','L','P','W')                                                                                                                                                                                                        
and e.ROW_CURR_unqk_FLAG='Y'                                                                                                                                                                                                        
and e.EFF_SEQ_NBR = (                                                                                                                                                                                                        
select  max(ES.EFF_SEQ_NBR)                                                                                                                                                                                                        
from     DW_COMMON.D_UM_EMP_SNAP ES                                                                                                                                                                                                        
where    ES.um_emp_nk_sid = e.um_emp_nk_sid                                                                                                                                                                                                        
and SRC_UPDT_CD <> 'D'                                                                                                                                                                                                        
and     ES.EFF_DT = e.EFF_DT
and pay_prd_snap_dt='3/13/2019')                                                                                                                                                                                                        
and e.ZDEPTID <> 'Z0387'                                                                                                                                                                                                        
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')                                                                                                                                                                                                        
and e.EMP_CLSS_CD<>'TMP'                                                                                                                                                                                                        
and e.SRC_UPDT_CD <> 'D'      
and e.pay_prd_snap_dt='3/13/2019'
group by e.emplid, e.EMP_REC_NBR,                                                                                                                                                                                                        
e.JOB_IND, e.adm_cost_bnmrk_cd,  e.JOBCD_GRP_CD,  e.JOBCD_GRP_DESC,                                                                                                                                                                                                        
e.deptid, e.JOB_CD, e.eff_dt , e.EFF_SEQ_NBR,e.STND_HR_AMNT,e.PAY_GRP_CD ,                                                                                                                                                                                                        
e.EMP_CLSS_CD,                                                                                                                                                                                                        
e.JOBCD_GRP_CD                                                                                                                                                                                                        
order by e.emplid,e.EFF_SEQ_NBR, e.eff_dt)) AS D_ROWS
FROM DUAL;

