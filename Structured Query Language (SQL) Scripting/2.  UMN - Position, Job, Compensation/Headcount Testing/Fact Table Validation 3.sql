-- MATCH EACH SID BASED ON THE JOIN RULES USED TO POPULATE THE SID IN THE FACT

-- If the SID in the fact does not match the SID from the dim that we expect to be loaded, it will return rows.  
-- If no rows are returned, the SID values are correct.

SELECT F.F_EMP_HC_FTE_SID, F.EMPLID, F.EMP_EFF_DT, F.DEPTID,
D.ROW_EFF_DT, D.ROW_EXPIR_DT, D.DEPTID
FROM DW_COMMON.F_EMP_HC_FTE_SNAP F
JOIN DW_COMMON.D_UM_EMP_SNAP D
ON
  F.EMPLID = D.EMPLID
  AND F.EMP_EFF_DT = D.EFF_DT
  AND F.DEPTID = D.DEPTID
  AND F.ZDEPTID = D.ZDEPTID
  AND F.CLLG_ADM_UNT_CD = D.CLLG_ADM_UNT_CD
  AND F.VP_ADM_UNT_CD = D.VP_ADM_UNT_CD
  AND F.CMP_CD = D.CMP_CD                                                                                                                                                                                                     
and d.EMP_STS_CD in ('A','L','P','W')                                                                                                                                                                                                        
and d.ROW_CURR_unqk_FLAG='Y'   
and d.row_curr_flag='Y'
and d.job_ind='P'
and f.prm_job_ind='Y'
and F.PAY_PRD_SNAP_DT='3/13/2019'
and D.PAY_PRD_SNAP_DT='3/13/2019'
and d.EFF_SEQ_NBR = (                                                                                                                                                                                                        
select  max(ES.EFF_SEQ_NBR)                                                                                                                                                                                                        
from     DW_COMMON.D_UM_EMP_SNAP ES                                                                                                                                                                                                        
where    ES.um_emp_nk_sid = d.um_emp_nk_sid                                                                                                                                                                                                        
and SRC_UPDT_CD <> 'D'                                                                                                                                                                                                        
and     ES.EFF_DT = d.EFF_DT
and pay_prd_snap_dt='3/13/2019')  -- Pick a specific snapshot, this can be changed
and d.ZDEPTID <> 'Z0387'                                                                                                                                                                                                        
and d.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')                                                                                                                                                                                                        
and d.EMP_CLSS_CD<>'TMP'                                                                                                                                                                                                        
and d.SRC_UPDT_CD <> 'D'     
AND (sysdate BETWEEN D.ROW_EFF_DT AND D.ROW_EXPIR_DT
  OR sysdate < D.ROW_EFF_DT 
  AND D.ROW_EFF_DT = (SELECT MIN(D1.ROW_EFF_DT) FROM DW_COMMON.D_UM_EMP D1
                      WHERE D.EMPLID = D1.EMPLID
                      AND D.EMP_REC_NBR = D1.EMP_REC_NBR
                      AND D.EFF_DT = D1.EFF_DT
                      AND d.EFF_SEQ_NBR = D1.EFF_SEQ_NBR))
WHERE F.UM_EMP_SID <> D.UM_EMP_SID AND F.UM_EMP_SID <> 0
ORDER BY F.EMPLID;