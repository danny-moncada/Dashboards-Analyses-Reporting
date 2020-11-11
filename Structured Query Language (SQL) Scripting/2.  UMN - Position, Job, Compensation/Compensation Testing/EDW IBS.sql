--TOT COLUMNS SET TO 0 for PLH & ZNP
--Active ZNP with ASGN are waived comp but need job row for I-9

--DM’s query used to reconcile RPD/Dashboard
SELECT D_UM_EMP.EMPLID, D_UM_EMP.EMP_STS_CD, 
         D_UM_EMP.EMP_REC_NBR, 
         D_UM_EMP.EFF_DT, 
         D_UM_EMP.EFF_SEQ_NBR, 
         D_UM_EMP.STND_HR_AMNT, 
         D_UM_EMP.JOB_IND, 
         D_UM_EMP.ANNL_RT_AMNT, 
         D_UM_EMP.TOTL_BASE_SAL_AMNT, 
         D_UM_EMP.TOTL_ADM_AUG_AMNT, 
         D_UM_EMP.TOTL_INCR_AMNT, 
         D_UM_EMP.TOTL_REGENTS_PROFSHP_PAY_AMNT, 
         b.comp_effseq, b.comp_ratecd, b.comprate 
    FROM dw_common.D_UM_EMP, STG_DW.s_compensation b 
   WHERE     D_UM_EMP.ROW_CURR_UNQK_FLAG = 'Y' 
         AND D_UM_EMP.SRC_UPDT_CD <> 'D' 
         AND D_UM_EMP.EFF_SEQ_NBR = 
                 (SELECT MAX (ES.EFF_SEQ_NBR) 
                    FROM DW_COMMON.D_UM_EMP ES 
                   WHERE     ES.UM_EMP_NK_SID = D_UM_EMP.UM_EMP_NK_SID 
                         AND ES.SRC_UPDT_CD <> 'D' 
                         AND ES.EFF_DT = D_UM_EMP.EFF_DT)
         AND b.src_updt_cd = 'I' 
         and b.comp_ratecd in ('BASE', 'HRLY', 'AAA', 'FAA', 'INCR', 'REGENT') 
         AND D_UM_EMP.emplid = b.emplid 
         AND D_UM_EMP.EMP_REC_NBR = b.empl_rcd 
         AND D_UM_EMP.EFF_DT = b.effdt 
         AND D_UM_EMP.EFF_SEQ_NBR = b.effseq 
         AND D_UM_EMP.EMP_STS_CD in ('A','L','P','W') 
         AND D_UM_EMP.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT') 
--         AND D_UM_EMP.ZDEPTID<>'Z0387' --REMOVED 11/2/2018
         AND D_UM_EMP.EMP_CLSS_CD<>'TMP' 
--         and d_um_emp.emplid='1333368'
         and d_um_emp.pay_grp_cd not in ('PLH','ZNP') --ADDED 11/5/2018
/*         AND D_UM_EMP.emplid in ('2101427','2100366','2101027','4751725','1625068','1076229','2101424',         '0635916','0992370','2102836','2103437','2103684','2109740','2110440','2110531','3672675') */
        and D_UM_EMP.row_curr_flag='Y' 
ORDER BY D_UM_EMP.EMPLID ASC, 
         D_UM_EMP.EMP_REC_NBR ASC, 
         D_UM_EMP.EFF_DT DESC, 
         D_UM_EMP.EFF_SEQ_NBR,  
         b.COMP_EFFSEQ asc, 
         b.comp_ratecd;
         
-- F_EMP_CMPNT_PAY FACT
SELECT A.EMPLID,
         A.EMP_REC_NBR,
         A.EFF_DT,
         A.EFF_SEQ_NBR,
         A.JOB_IND,
         A.ANNL_RT_AMNT, 
        ( case   when A.JOB_IND = 'P' then A.ANNL_RT_AMNT else 0 END) ANNL_RT_AMNT_NEW, 
         A.TOTL_BASE_SAL_AMNT,
        ( case   when A.JOB_IND = 'P' then A.TOTL_BASE_SAL_AMNT else 0 END) TOTL_BASE_SAL_AMNT_NEW,
         A.TOTL_BASE_SAL_AMNT, 
         ( case   when A.JOB_IND = 'P' then A.BASE_SAL_AMNT else 0 END) BASE_SAL_AMNT_NEW,
         A.BASE_SAL_AMNT,
         b.comp_effseq, b.comp_ratecd, b.comprate
FROM DW_COMMON.D_UM_EMP A, STG_DW.s_compensation b
WHERE
  A.COMP_CD = 'UMN'
AND A.EMP_STS_CD IN ('A', 'L', 'P', 'W')
AND A.ROW_CURR_UNQK_FLAG = 'Y'
AND A.SRC_UPDT_CD <> 'D'
AND A.JOBCD_GRP_CD IN ('AA', 'AP', 'FA', 'CS', 'LR', 'GA', 'PT')
AND A.EMP_CLSS_CD <> 'TMP'
--AND A.ZDEPTID<>'Z0387'
and A.pay_grp_cd not in ('PLH','ZNP') 
--and a.emplid = '2103437'
---and a.emplid = '0635916'
--and a.job_ind='P'
--and a.row_curr_flag='Y'
AND A.EFF_SEQ_NBR = (
        SELECT  MAX(ES.EFF_SEQ_NBR)
        FROM     DW_COMMON.D_UM_EMP ES
        WHERE    ES.UM_EMP_NK_SID = A.UM_EMP_NK_SID
        AND ES.SRC_UPDT_CD <> 'D'
        AND     ES.EFF_DT = A.EFF_DT)
and b.src_updt_cd = 'I'
 and b.comp_ratecd in ('BASE', 'HRLY', 'AAA', 'FAA', 'INCR', 'REGENT')
         AND A.emplid = b.emplid
         AND A.EMP_REC_NBR = b.empl_rcd
         AND A.EFF_DT = b.effdt
         AND A.EFF_SEQ_NBR = b.effseq
order by a.emplid, a.emp_rec_nbr, a.eff_dt, a.eff_seq_nbr;

--27420 11/10/2018
--TOT COLUMNS SET TO 0 for PLH & ZNP
--Active ZNP with ASGN are waived comp but need job row for I-9
SELECT D_UM_EMP.EMPLID, D_UM_EMP.EMP_STS_CD, 
         D_UM_EMP.EMP_REC_NBR, 
         D_UM_EMP.EFF_DT, 
         D_UM_EMP.EFF_SEQ_NBR, 
         D_UM_EMP.STND_HR_AMNT, 
         D_UM_EMP.JOB_IND, 
         D_UM_EMP.ANNL_RT_AMNT, 
         D_UM_EMP.TOTL_BASE_SAL_AMNT, 
         D_UM_EMP.TOTL_ADM_AUG_AMNT, 
         D_UM_EMP.TOTL_INCR_AMNT, 
         D_UM_EMP.TOTL_REGENTS_PROFSHP_PAY_AMNT, 
         b.comp_effseq, b.comp_ratecd, b.comprate 
    FROM dw_common.D_UM_EMP, STG_DW.s_compensation b 
   WHERE     D_UM_EMP.ROW_CURR_UNQK_FLAG = 'Y' 
         AND D_UM_EMP.SRC_UPDT_CD <> 'D' 
         AND D_UM_EMP.EFF_SEQ_NBR = 
                 (SELECT MAX (ES.EFF_SEQ_NBR) 
                    FROM DW_COMMON.D_UM_EMP ES 
                   WHERE     ES.UM_EMP_NK_SID = D_UM_EMP.UM_EMP_NK_SID 
                         AND ES.SRC_UPDT_CD <> 'D' 
                         AND ES.EFF_DT = D_UM_EMP.EFF_DT)
         AND b.src_updt_cd = 'I' 
         and b.comp_ratecd in ('BASE', 'HRLY', 'AAA', 'FAA', 'INCR', 'REGENT') 
         AND D_UM_EMP.emplid = b.emplid 
         AND D_UM_EMP.EMP_REC_NBR = b.empl_rcd 
         AND D_UM_EMP.EFF_DT = b.effdt 
         AND D_UM_EMP.EFF_SEQ_NBR = b.effseq 
         AND D_UM_EMP.EMP_STS_CD in ('A','L','P','W') 
         AND D_UM_EMP.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT') 
         AND D_UM_EMP.ZDEPTID<>'Z0387' --REMOVED 11/2/2018
         AND D_UM_EMP.EMP_CLSS_CD<>'TMP' 
--         and d_um_emp.emplid='1333368'
--         and d_um_emp.pay_grp_cd not in ('PLH','ZNP') --ADDED 11/5/2018
/*         AND D_UM_EMP.emplid in ('2101427','2100366','2101027','4751725','1625068','1076229','2101424',     '0635916','0992370','1076229','2101424','2102468','2102836','2103437','2103684','2109740','2110440','2110531','3672675') */
        and D_UM_EMP.row_curr_flag='Y' 
        and D_UM_EMP.job_ind='P'
ORDER BY D_UM_EMP.EMPLID ASC, 
         D_UM_EMP.EMP_REC_NBR ASC, 
         D_UM_EMP.EFF_DT DESC, 
         D_UM_EMP.EFF_SEQ_NBR,  
         b.COMP_EFFSEQ asc, 
         b.comp_ratecd;
         
 --MATCHES HC/FTE DASHBOARD 27757 11/10/2018 WITH S_COMPENSATION REMOVED        
 SELECT D_UM_EMP.EMPLID, D_UM_EMP.EMP_STS_CD, 
         D_UM_EMP.EMP_REC_NBR, 
         D_UM_EMP.EFF_DT, 
         D_UM_EMP.EFF_SEQ_NBR, 
         D_UM_EMP.STND_HR_AMNT, 
         D_UM_EMP.JOB_IND, 
         D_UM_EMP.ANNL_RT_AMNT, 
         D_UM_EMP.TOTL_BASE_SAL_AMNT, 
         D_UM_EMP.TOTL_ADM_AUG_AMNT, 
         D_UM_EMP.TOTL_INCR_AMNT, 
         D_UM_EMP.TOTL_REGENTS_PROFSHP_PAY_AMNT
    FROM dw_common.D_UM_EMP
   WHERE     D_UM_EMP.ROW_CURR_UNQK_FLAG = 'Y' 
         AND D_UM_EMP.SRC_UPDT_CD <> 'D' 
         AND D_UM_EMP.EFF_SEQ_NBR = 
                 (SELECT MAX (ES.EFF_SEQ_NBR) 
                    FROM DW_COMMON.D_UM_EMP ES 
                   WHERE     ES.UM_EMP_NK_SID = D_UM_EMP.UM_EMP_NK_SID 
                         AND ES.SRC_UPDT_CD <> 'D' 
                         AND ES.EFF_DT = D_UM_EMP.EFF_DT)
         AND D_UM_EMP.EMP_STS_CD in ('A','L','P','W') 
         AND D_UM_EMP.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT') 
         AND D_UM_EMP.ZDEPTID<>'Z0387' --REMOVED 11/2/2018
         AND D_UM_EMP.EMP_CLSS_CD<>'TMP' 
--         and d_um_emp.emplid='1333368'
--         and d_um_emp.pay_grp_cd not in ('PLH','ZNP') --ADDED 11/5/2018
/*         AND D_UM_EMP.emplid in ('2101427','2100366','2101027','4751725','1625068','1076229','2101424', 
        '0635916','0992370','1076229','2101424','2102468','2102836','2103437','2103684','2109740','2110440','2110531','3672675') */
        and D_UM_EMP.row_curr_flag='Y' 
        and D_UM_EMP.job_ind='P'
ORDER BY D_UM_EMP.EMPLID ASC, 
         D_UM_EMP.EMP_REC_NBR ASC, 
         D_UM_EMP.EFF_DT DESC, 
         D_UM_EMP.EFF_SEQ_NBR     




