--Systemwide ecount and total IBS
with totalibs as
(select count(e.emplid) ecount,
case when pay_cmpnt_cd in ('BASE','HRLY') then sum(base_sal_amnt)
when pay_cmpnt_cd in ('AAA','FAA','INCR','REGENT') then sum(pay_cmpnt_rt) end TOTAL_IBS,
F.PAY_CMPNT_CD
--,sum(annl_rt_amnt) 
from dw_common.F_EMP_CMPNT_PAY f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and e.row_curr_flag='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and d.zdeptid<>'Z0387'
and f.PAY_CMPNT_CD in ('BASE','HRLY','AAA','FAA','INCR','REGENT')
and e.pay_grp_cd not in ('PLH','ZNP')
and trunc(sysdate) between f.emp_eff_dt and f.emp_eff_expir_dt 
--and d.cmp_cd='TXXX'
--and d.vp_adm_unt_cd='THRS'
--and d.cllg_adm_unt_cd='TOHR'
--and d.zdeptid='Z0449'
--and d.deptid='12231'
group by f.PAY_CMPNT_CD
)
select sum(ecount), sum(round(total_ibs)) from totalibs;

--DM's sql Systemwide ecount and total IBS
with totalibs as
(select count(e.emplid) ecount,--created this metric from d_um_emp, non distinct
case when pay_cmpnt_cd in ('BASE','HRLY') then sum(base_sal_amnt) --removed the rounding()
when pay_cmpnt_cd in ('AAA','FAA','INCR','REGENT') then sum(pay_cmpnt_rt) end TOTAL_IBS,
F.PAY_CMPNT_CD
from dw_common.F_EMP_CMPNT_PAY f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_nk_sid=d.hr_org_nk_sid --joined on nk_sid
and f.um_emp_sid=e.um_emp_sid
and e.row_curr_flag='Y'--added to the adhoc counterpart this same filter
and d.row_curr_flag='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and d.zdeptid<>'Z0387'
and f.PAY_CMPNT_CD in ('BASE','HRLY','AAA','FAA','INCR','REGENT')
and e.pay_grp_cd not in ('PLH','ZNP')
and trunc(sysdate) between f.emp_eff_dt and f.emp_eff_expir_dt --added this to restrict to current date and avoid future rows
group by f.PAY_CMPNT_CD
)
select sum(ecount) headcount, to_number(to_char(sum(total_ibs),'0000000000.00')) --rounded on the result to avoid an unnecessary mismatch
totalibs from totalibs;


--?? Different result with NHBR fact
with ecount as 
(select count(e.emplid) ecount
from dw_common.F_EMP_COMP f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and e.row_curr_flag='Y'
and f.curr_emplid is not null
and f.prm_all_job_cd = 'A'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
and e.pay_grp_cd not in ('PLH','ZNP')
and trunc(sysdate) between f.wkfc_actn_eff_dt and f.wkfc_actn_expir_dt 
--and d.cmp_cd='TXXX'
--and d.vp_adm_unt_cd='THRS'
--and d.cllg_adm_unt_cd='TOHR'
--and d.zdeptid='Z0449'
--and d.deptid='12231'
),
tot_annlrt as
(select (case when e.pay_grp_cd not in ('PLH','ZNP') then sum(e.annl_rt_amnt) end) tot_annl_rt
from dw_common.F_EMP_COMP f,
dw_common.d_hr_org d,
dw_common.d_um_emp e
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and e.row_curr_flag='Y'
and f.curr_emplid is not null
and f.prm_all_job_cd = 'A'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
and trunc(sysdate) between f.wkfc_actn_eff_dt and f.wkfc_actn_expir_dt 
--and d.cmp_cd='TXXX'
--and d.vp_adm_unt_cd='THRS'
--and d.cllg_adm_unt_cd='TOHR'
--and d.zdeptid='Z0449'
--and d.deptid='12231'
group by e.pay_grp_cd)
select ecount from ecount
union 
select sum(tot_annl_rt) from tot_annlrt;
;