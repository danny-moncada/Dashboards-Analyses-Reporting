--## 09-09-2019 Results - Match
--PRIM_HC	PRIM_FTE	LEGAL_SEX
--14810	11786.6	F - Female
--12855	10042.354	M - Male
--3	1	U - Unknown
--27668	21829.954	

----PRIM_HC	PRIM_FTE	ETHN_INST_CALC
--27668	21829.954	
--19796	16041.07275	WHITE - White
--3433	2491.75625	ASIAN - Asian
--1824	1175.13125	NSPEC - Not Specified
--1397	1212.6625	BLACK - Black/African American
--871	635.30625	HISPA - Hispanic/Latino
--309	245.575	AMIND - American Indian/Alaska Native
--38	28.45	PACIF - Native Hawaiian/Oth Pac Island

=============================================
--Legal Sex Systemwide
select sum(f.PRM_HR_H_CNT) PRIM_HC, sum(f.PRM_FTE_CNT) PRIM_FTE, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc as legal_sex
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p 
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.emplid=p.emplid
and e.row_curr_flag='Y'
and prm_job_ind = 'Y'
and curr_emplid is not null
and f.job_catgy_desc in ('Faculty','Graduate Assistants','Labor Represented','Civil Service','Professionals-in-Training','P'||'&'||'A')
and e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and e.ROW_CURR_FLAG='Y'
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
group by ROLLUP(p.lgl_sx_cd || ' - ' || p.lgl_sx_desc)
order by prim_hc desc;

--Legal Sex Campus
select
d.CMP_LD campus,
p.lgl_sx_cd || ' - ' || p.lgl_sx_desc legal_sex,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.CMP_LD, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc
order by PRIM_HC desc;

--Legal Sex VP (HR)
select
d.vp_adm_unt_cd || ' - ' || d.vp_adm_unt_ld VP_HR,
p.lgl_sx_cd || ' - ' || p.lgl_sx_desc legal_sex,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.vp_adm_unt_cd || ' - ' || d.vp_adm_unt_ld, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc
order by PRIM_HC desc;

--Legal Sex College-AdminUnit
select
d.cllg_adm_unt_cd || ' - ' || d.cllg_adm_unt_ld College_Admin_Unit,
p.lgl_sx_cd || ' - ' || p.lgl_sx_desc legal_sex,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.cllg_adm_unt_cd || ' - ' || d.cllg_adm_unt_ld, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc
order by PRIM_HC desc;

--Legal Sex ZDeptID
select
d.zdeptid || ' - ' || d.zdeptid_ld ZDeptID,
p.lgl_sx_cd || ' - ' || p.lgl_sx_desc legal_sex,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.zdeptid || ' - ' || d.zdeptid_ld, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc
order by PRIM_HC desc;

-- Legal Sex Department
select
d.deptid || ' - ' || d.deptid_ld department,
p.lgl_sx_cd || ' - ' || p.lgl_sx_desc legal_sex,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.deptid || ' - ' || d.deptid_ld, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc
order by PRIM_HC desc;

-- Legal Sex Employee Detail Report - All Employees
select
e.emplid, e.emp_rec_nbr, e.lst_nm_txt, e.fst_nm_txt, p.lgl_sx_cd || ' - ' || p.lgl_sx_desc legal_sex, e.stnd_hr_amnt, f.prm_hr_h_cnt, f.prm_fte_cnt, f.scndry_hr_h_cnt, f.scndry_fte_cnt
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
order by emplid, emp_rec_nbr;

--Ethnicity (Institutional Calculation) Systemwide
select sum(f.PRM_HR_H_CNT) PRIM_HC, sum(f.PRM_FTE_CNT) PRIM_FTE, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p 
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.emplid=p.emplid
and e.row_curr_flag='Y'
and prm_job_ind = 'Y'
and curr_emplid is not null
and f.job_catgy_desc in ('Faculty','Graduate Assistants','Labor Represented','Civil Service','Professionals-in-Training','P'||'&'||'A')
and e.COMP_CD='UMN'
and e.EMP_STS_CD in ('A','L','P','W')
and e.ROW_CURR_FLAG='Y'
and e.ZDEPTID <> 'Z0387'
and e.JOBCD_GRP_CD in ('AA','AP','FA','CS','LR','GA','PT')
and e.EMP_CLSS_CD<>'TMP'
group by ROLLUP(p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC)
order by prim_hc desc;

--Ethnicity (Institutional Calculation) Campus
select
d.CMP_LD campus,
p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.CMP_LD, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC
order by PRIM_HC desc;

--Ethnicity (Institutional Calculation) VP (HR)
select
d.vp_adm_unt_cd || ' - ' || d.vp_adm_unt_ld VP_HR,
p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.vp_adm_unt_cd || ' - ' || d.vp_adm_unt_ld, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC
order by PRIM_HC desc;

--Ethnicity (Institutional Calculation) College-AdminUnit
select
d.cllg_adm_unt_cd || ' - ' || d.cllg_adm_unt_ld College_Admin_Unit,
p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.cllg_adm_unt_cd || ' - ' || d.cllg_adm_unt_ld, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC
order by PRIM_HC desc;

--Ethnicity (Institutional Calculation) ZDeptID
select
d.zdeptid || ' - ' || d.zdeptid_ld ZDeptID,
p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.zdeptid || ' - ' || d.zdeptid_ld, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC
order by PRIM_HC desc;

-- Ethnicity (Institutional Calculation) Department
select
d.deptid || ' - ' || d.deptid_ld department,
p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc,
count(distinct e.emplid) PRIM_HC, 
sum(prm_fte_cnt) PRIM_FTE
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
group by d.deptid || ' - ' || d.deptid_ld, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC
order by PRIM_HC desc;

-- Ethnicity (Institutional Calculation) Employee Detail Report - All Employees
select
e.emplid, e.emp_rec_nbr, e.lst_nm_txt, e.fst_nm_txt, p.INST_CALC_ETHN_CD || ' - ' || p.INST_CALC_ETHN_DESC as ethn_inst_calc, 
e.stnd_hr_amnt, f.prm_hr_h_cnt, f.prm_fte_cnt, f.scndry_hr_h_cnt, f.scndry_fte_cnt
from dw_common.F_EMP_HC_FTE f,
dw_common.d_hr_org d,
dw_common.d_um_emp e,
dw_common.d_hr_cmm_pers p
where f.hr_org_sid=d.hr_org_sid
and f.um_emp_sid=e.um_emp_sid
and f.um_emp_nk_sid=e.um_emp_nk_sid
and p.emplid = f.emplid
and e.row_curr_flag='Y'
and CURR_EMPLID IS NOT NULL
--and prm_all_job_cd = 'A'
and f.prm_job_ind='Y'
and e.emp_sts_cd in ('A','L','P','W')
and e.jobcd_grp_cd in ('AA','AP','FA','CS','LR','GA','PT')
and e.emp_clss_cd<>'TMP'
and e.zdeptid<>'Z0387'
order by emplid, emp_rec_nbr;