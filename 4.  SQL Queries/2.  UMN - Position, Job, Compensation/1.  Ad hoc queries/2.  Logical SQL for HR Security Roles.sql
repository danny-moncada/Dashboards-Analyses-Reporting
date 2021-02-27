SELECT  t1.emplid, t1.first_name, t1.internet_id, t1.last_name, t1.campus_desc, t1.admn_unit, t1.vp_description, t1.zdeptid, 
t1.employee_status, t1.job_title,t2.group_member, t2.group_name, t2.deptid, t2.deptname, t2.fname, t2.lname, t2.location, t2.um_college, t2.um_college_descr, t1.job_indicator, t1.row_curr_flag
FROM (SELECT DISTINCT "Human Resources - Position, Job, Compensation"."Employee"."Emplid" emplid,
"Human Resources - Position, Job, Compensation"."Employee"."First Name" first_name,
   "Human Resources - Position, Job, Compensation"."Employee"."Internet Id" internet_id,
   "Human Resources - Position, Job, Compensation"."Employee"."Last Name" last_name,
   "Human Resources - Position, Job, Compensation"."HR Dept Hierarchy"."Campus Description" campus_desc,
   "Human Resources - Position, Job, Compensation"."HR Dept Hierarchy"."College/Admin Unit Code - College/Admin Unit Description" admn_unit,
   "Human Resources - Position, Job, Compensation"."HR Dept Hierarchy"."VP (HR) Code  - VP (HR) Description" vp_description,
   "Human Resources - Position, Job, Compensation"."HR Dept Hierarchy"."ZDeptID Code - ZDeptID Description" zdeptid,
   "Human Resources - Position, Job, Compensation"."Job"."Employee Status Description" employee_status,
   "Human Resources - Position, Job, Compensation"."Job"."Job Code - Job Title" job_title,
   "Human Resources - Position, Job, Compensation"."Job"."Job Indicator" job_indicator,
   "Human Resources - Position, Job, Compensation"."Employee Flags"."Row Current Flag" row_curr_flag
  FROM "Human Resources - Position, Job, Compensation"
)t1
INNER JOIN
     (SELECT DISTINCT "OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."G_MEMBER" group_member
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."G_NAME" group_name
,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."DEPTID" deptid
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."DEPTNAME" deptname
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."FIRST_NAME" fname
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."LAST_NAME" lname
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."LOCATION" location
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."UM_COLLEGE" um_college
            ,"OIT - OBIEE Security"."OBIEE_SECURITY_TBL"."UM_COLLEGE_DESCR" um_college_descr
 FROM "OIT - OBIEE Security"
 WHERE (
"OBIEE_SECURITY_TBL"."G_NAME" IN (
'HRPrivateConsumers'
,'HRPublicSensitiveConsumers'
,'HRPrivateAuthors'
)
)
 )t2

ON t1.internet_id = t2.group_member