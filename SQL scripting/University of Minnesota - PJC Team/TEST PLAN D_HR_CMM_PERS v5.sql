-- D_HR_CMM_PERS TEST PLAN
--ONLY RUN IN EDWQAT OR EDWPRD. DATA FROM D_CMM_PERS IS PRODUCTION DATA

--RUNS IN ~ 6 MINUTES

SET SERVEROUTPUT ON;

DECLARE DB_NAME varchar2(20);

--TEST 1 INITIAL LOAD TIMING NA  
--TEST 2A DAILY LOAD VALIDATION  
  LOAD_DT TIMESTAMP;
--TEST 2B TOP ROW VALIDATION
  BAD_TOP_ROWS NUMBER;
--TEST 3A - ROW COUNT COMPARED TO SOURCE
  S_CMM_PERS_ROWS NUMBER;
  DIM_ROW_COUNT NUMBER;  
--TEST 3B MISSING EMPLIDS CHECK  
  MISSING_IDS NUMBER;
--TEST 4 - SID VALIDATION
  BAD_SIDS NUMBER;
--TEST 5-6 NK_SID  NA  
--TEST 7 ZERO SID
  ZERO_SID NUMBER;
--TEST 8-9 SRC_UPDT_CD 8 = NO U'S, 9 = NO D'S
  BAD_SRC_UPDT_CD NUMBER;
--TEST 10  ONE ROW PER EMPLID
  DUPLICATES NUMBER;
--TEST 11-16 CURRENT ROW FLAGS, ROW EFFECTIVE DATE, ROW EXPIRATION DATE - NA  
--TEST 17 DEFAULT REPLACEMENT VALUES
  NULL_FIELDS NUMBER;
--TEST 18-21 FUTURE DATE INDICATOR/CURRENT ROW UNIQUE KEY FLAG NA  
----------------------------------------------------------------------
--DIMENSION SPECIFIC-COLUMNS
----------------------------------------------------------------------
--TEST 22 LEGAL SEX
  BAD_LEGAL_SEX NUMBER;
--TEST 23  NAMES
  BAD_PRM_NAMES NUMBER;
  BAD_DSPL_NAMES NUMBER;
--TEST 24 ETHNICITY
  BAD_INST_CALC_ETHN NUMBER;
  BAD_INST_CALC_NRESA NUMBER;
  BAD_EOAA_ETHN NUMBER;
  BAD_IPEDS_ETHN NUMBER;

BEGIN

-- Record execution time, database name
    DBMS_OUTPUT.PUT_LINE('TEST PLAN D_HR_CMM_PERS');
    DBMS_OUTPUT.PUT_LINE('-----');
    
    DBMS_OUTPUT.PUT_LINE('EXECUTION TIME:');
    DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    DBMS_OUTPUT.PUT_LINE('EXECUTION ENVIRONMENT:');
    SELECT sys_context('USERENV','DB_NAME') INTO DB_NAME FROM dual;
    DBMS_OUTPUT.PUT_LINE(UPPER(DB_NAME));
    DBMS_OUTPUT.PUT_LINE('-----');
    
-- TEST 1 INITIAL LOAD TIMING
    DBMS_OUTPUT.PUT_LINE('TEST 1 INITIAL LOAD TIMING - NA');  
    
-- TEST 2A VALIDATE DAILY LOAD
    SELECT MAX(CREAT_UPDT_TMSP) INTO LOAD_DT
    FROM DW_COMMON.D_HR_CMM_PERS;
    
    DBMS_OUTPUT.PUT_LINE('TEST 2A DAILY LOAD');
    
    IF TRUNC(LOAD_DT) = TRUNC(SYSDATE)
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('LOAD_DT: ', LOAD_DT));
    DBMS_OUTPUT.PUT_LINE('-----');   

-- TEST 2B TOP ROW VALIDATION -
-- Verify getting current data and data is
-- same as D_CMM_PERS

  SELECT COUNT (*)
  INTO BAD_TOP_ROWS
  FROM (SELECT a.*, b.*
          FROM dw_common.d_hr_cmm_pers a, dw_common.d_cmm_pers b
         WHERE     a.emplid = b.emplid
               AND (   a.lgl_sx_cd <> b.lgl_sx_cd
                    OR a.lgl_sx_desc <> b.lgl_sx_desc
                    OR a.INST_CALC_ETHN_CD <> b.INST_CALC_ETHN_CD
                    OR a.INST_CALC_ETHN_DESC <> b.INST_CALC_ETHN_DESC
                    OR a.INST_CALC_NRESA_ETHN_CD <> b.INST_CALC_NRESA_ETHN_CD
                    OR a.INST_CALC_NRESA_ETHN_DESC <>
                       b.INST_CALC_NRESA_ETHN_DESC
                    OR a.EOAA_ETHN_CD <> b.EOAA_ETHN_CD
                    OR a.EOAA_ETHN_DESC <> b.EOAA_ETHN_DESC
                    OR a.IPEDS_ETHN_CD <> b.IPEDS_ETHN_CD
                    OR a.IPEDS_ETHN_DESC <> b.IPEDS_ETHN_DESC
                    OR a.PRM_FST_NM <> b.PRM_FST_NM
                    OR a.PRM_LST_NM <> b.PRM_LST_NM
                    OR a.PRM_MI_NM <> b.PRM_MI_NM
                    OR a.src_updt_cd <> b.src_updt_cd));
                    
    DBMS_OUTPUT.PUT_LINE('TEST 2B TOP ROW VALIDATION');
    
    IF BAD_TOP_ROWS = 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_TOP_ROWS: ', BAD_TOP_ROWS));
    DBMS_OUTPUT.PUT_LINE('-----');  
    
-- TEST 3A ROW COUNT COMPARED TO STAGING
SELECT COUNT (*)
  INTO S_CMM_PERS_ROWS
  FROM DW_COMMON.D_CMM_PERS S
 WHERE    S.EMPLID IN (SELECT DISTINCT EMPLID
                         FROM STG_DW.S_UM_EMPLOYEES
                        WHERE SRC_UPDT_CD = 'I')
       OR S.CMM_PERS_SID = 0;

SELECT COUNT (*) INTO DIM_ROW_COUNT FROM DW_COMMON.D_HR_CMM_PERS;
    
    DBMS_OUTPUT.PUT_LINE('TEST 3A ROW COUNT COMPARED TO STAGING');
    IF S_CMM_PERS_ROWS = DIM_ROW_COUNT
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    DBMS_OUTPUT.PUT_LINE(CONCAT('S_CMM_PERS_ROWS I ROWS: ', S_CMM_PERS_ROWS));
    DBMS_OUTPUT.PUT_LINE(CONCAT('DIM_ROW_COUNT ALL ROWS: ', DIM_ROW_COUNT));
    DBMS_OUTPUT.PUT_LINE('-----');  
    
-- TEST 3B MISSING EMPLIDS COMPARED TO PS STAGING
    SELECT COUNT(*) INTO MISSING_IDS
    FROM STG_DW.S_PERS_DATA_EFFDT P
    WHERE 1=1
    AND P.EMPLID IN ( SELECT DISTINCT EMPLID FROM STG_DW.S_UM_EMPLOYEES WHERE SRC_UPDT_CD='I' and effdt <= SYSDATE)
    AND P.SRC_UPDT_CD = 'I'
    AND NOT EXISTS (SELECT * FROM DW_COMMON.D_HR_CMM_PERS CP
                      WHERE P.EMPLID = CP.EMPLID);
    DBMS_OUTPUT.PUT_LINE('TEST 3B MISSING IDS');
    
    IF MISSING_IDS= 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('MISSING_IDS: ', MISSING_IDS));
    DBMS_OUTPUT.PUT_LINE('-----'); 

-- TEST 4 SID VALIDATION - ONE UNIQUE SID VALUE PER ROW IN DIMENSION
    SELECT COUNT(*) INTO BAD_SIDS
    FROM (
    SELECT CMM_PERS_SID, COUNT(*)
    FROM DW_COMMON.D_HR_CMM_PERS
    GROUP BY CMM_PERS_SID
    HAVING COUNT(*) > 1
    );
    DBMS_OUTPUT.PUT_LINE('TEST 4 SID VALIDATION');
    IF BAD_SIDS = 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;

    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_SIDS: ', BAD_SIDS));
    DBMS_OUTPUT.PUT_LINE('-----');  
     
-- TEST 5-6 NK_SID NA
    DBMS_OUTPUT.PUT_LINE('TEST 5-6 NK_SID - NA');
    DBMS_OUTPUT.PUT_LINE('-----');  

-- TEST 7 CHECK FOR PRESENCE OF ZERO SID
    SELECT COUNT(*) INTO ZERO_SID
    FROM DW_COMMON.D_HR_CMM_PERS
    WHERE CMM_PERS_SID = 0;
    
    DBMS_OUTPUT.PUT_LINE('TEST 7 CHECK FOR PRESENCE OF ZERO SID');
    IF ZERO_SID = 1
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;

    DBMS_OUTPUT.PUT_LINE(CONCAT('ZERO_SID: ', ZERO_SID));
    DBMS_OUTPUT.PUT_LINE('-----');

-- TEST 8-9 SRC_UPDT_CD - ONLY I VALUES (CURRENT/CORRECTED, NO D'S AND NO UPDATES)
    SELECT COUNT(*) INTO BAD_SRC_UPDT_CD
    FROM DW_COMMON.D_HR_CMM_PERS
    WHERE SRC_UPDT_CD <> 'I';
    
    DBMS_OUTPUT.PUT_LINE('TEST 8-9 SRC_UPDT_CD');
    IF BAD_SRC_UPDT_CD = 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;

    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_SRC_UPDT_CD: ', BAD_SRC_UPDT_CD));
    DBMS_OUTPUT.PUT_LINE('-----');      
  
-- TEST 10 - DUPLICATES - ONLY ONE ROW PER EMPLID
    SELECT COUNT(*) INTO DUPLICATES
    FROM (
          SELECT EMPLID, COUNT(*)
          FROM DW_COMMON.D_HR_CMM_PERS
          GROUP BY EMPLID
          HAVING COUNT(*) > 1
          );
    DBMS_OUTPUT.PUT_LINE('TEST 10 DUPLICATES');
    
    IF DUPLICATES= 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('DUPLICATES: ', DUPLICATES));
    DBMS_OUTPUT.PUT_LINE('-----');  

-- TEST 11-16 CURRENT ROW FLAGS, ROW EFFECTIVE DATE, ROW EXPIRATION DATE - NA
    DBMS_OUTPUT.PUT_LINE('TEST 11-16 CURRENT ROW FLAGS, ROW EFFECTIVE DATE, ROW EXPIRATION DATE - NA');
    DBMS_OUTPUT.PUT_LINE('-----');      

-- TEST 17 DEFAULT REPLACEMENT VALUES NOTE: STANDARD DEFAULT VALUES SHOULD NOT BE USED FOR ANY NAME COLUMNS.  
---IF IT IS A SPACE IN STAGING, IT SHOULD BE A SPACE IN THE DIMENSION, IF IT IS NULL IN STAGING, IT SHOULD BE NULL IN THE DIMENSION - NO DASHES
    SELECT COUNT(*) INTO NULL_FIELDS
    FROM DW_COMMON.D_HR_CMM_PERS
    WHERE 1=1
    AND CMM_PERS_SID <>0
      AND (
      CMM_PERS_SID IS NULL
      OR EMPLID IS NULL OR EMPLID = ' '
      OR LGL_SX_CD IS NULL OR LGL_SX_CD = ' '
      OR LGL_SX_DESC IS NULL OR LGL_SX_DESC = ' '
      OR INST_CALC_ETHN_CD IS NULL OR INST_CALC_ETHN_CD = ' '
      OR INST_CALC_ETHN_DESC IS NULL OR INST_CALC_ETHN_DESC = ' '
      OR INST_CALC_NRESA_ETHN_CD IS NULL OR INST_CALC_NRESA_ETHN_CD = ' '
      OR INST_CALC_NRESA_ETHN_DESC IS NULL OR INST_CALC_NRESA_ETHN_DESC = ' '
      OR EOAA_ETHN_CD IS NULL OR EOAA_ETHN_CD = ' '
      OR EOAA_ETHN_DESC IS NULL OR EOAA_ETHN_DESC = ' '
      OR IPEDS_ETHN_CD IS NULL OR IPEDS_ETHN_CD = ' '
      OR IPEDS_ETHN_DESC IS NULL OR IPEDS_ETHN_DESC = ' '
      OR PRM_FST_NM = '-'
      OR PRM_MI_NM = '-' 
      OR PRM_LST_NM = '-'
      ) ;
        DBMS_OUTPUT.PUT_LINE('TEST 17 DEFAULT REPLACEMENT VALUES');
    
    IF NULL_FIELDS= 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('NULL_FIELDS: ', NULL_FIELDS));
    DBMS_OUTPUT.PUT_LINE('-----');    

-- TEST 18-21 FUTURE DATE INDICATOR/CURRENT ROW UNIQUE KEY FLAG NA
    DBMS_OUTPUT.PUT_LINE('TEST 18-21 FUTURE DATE INDICATOR/CURRENT ROW UNIQUE KEY FLAG - NA');
    DBMS_OUTPUT.PUT_LINE('-----');    
-----------------------------------------------------------------------------------
--DIMENSION-SPECIFIC COLUMNS
-----------------------------------------------------------------------------------     
-- TEST 22 - LEGAL SEX CODES AND VALUES.  VALUES SHOULD MATCH CALCULATED VALUES
    SELECT count(*) INTO BAD_LEGAL_SEX 
    FROM 
    (SELECT R.CMM_PERS_SID, R.EMPLID, CP.LGL_SX_CD, NVL(S.SEX, 'U') AS CALC_SX_CD, CP.LGL_SX_DESC,
    NVL(X.XLATLONGNAME, 'Unknown') AS CALC_SEX_DESC
    FROM DW_COMMON.D_HR_CMM_PERS R
    LEFT JOIN (SELECT EMPLID, SEX
                FROM STG_DW.S_PERS_DATA_EFFDT S
                WHERE SRC_UPDT_CD = 'I'
                AND S.EFFDT = (SELECT MAX(S_ED.EFFDT) FROM STG_DW.S_PERS_DATA_EFFDT S_ED
                               WHERE S.EMPLID = S_ED.EMPLID
                               AND S_ED.SRC_UPDT_CD = 'I'
                               AND S_ED.EFFDT <= SYSDATE) )S
    ON R.EMPLID = S.EMPLID 
    LEFT JOIN 
              (SELECT FIELDNAME, FIELDVALUE, XLATLONGNAME
              FROM STG_DW.S_XLATITEM_CS A
              WHERE A.FIELDNAME = 'SEX'
              AND A.SRC_UPDT_CD = 'I'
              AND A.EFFDT = (SELECT MAX(A_ED.EFFDT) FROM STG_DW.S_XLATITEM_CS A_ED
                              WHERE A.FIELDNAME = A_ED.FIELDNAME
                              AND A.FIELDVALUE = A_ED.FIELDVALUE
                              AND A_ED.SRC_UPDT_CD = 'I'
                              AND A_ED.EFFDT <= SYSDATE)) X
    ON S.SEX = X.FIELDVALUE                    
    LEFT JOIN DW_COMMON.D_HR_CMM_PERS CP
    ON R.EMPLID = CP.EMPLID )
    WHERE (LGL_SX_CD <> CALC_SX_CD
    OR LGL_SX_DESC <> CALC_SEX_DESC)
    and CMM_PERS_SID <> 0
    ;
    
    DBMS_OUTPUT.PUT_LINE('TEST 5 LEGAL SEX');
    
    IF BAD_LEGAL_SEX = 0
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_LEGAL_SEX: ', BAD_LEGAL_SEX));
    DBMS_OUTPUT.PUT_LINE('-----');
    
    
 -- TEST 23 - NAMES VALUES SHOULD MATCH CALCULATED VALUES
     SELECT COUNT(*) INTO BAD_PRM_NAMES
     FROM 
     (
        SELECT R.EMPLID, N.NAME AS CALC_PRM_FULL_NM, R.PRM_FST_NM, N.FIRST_NAME AS CALC_PRM_FST_NM, 
        R.PRM_MI_NM, N.MIDDLE_NAME AS CALC_PRM_MI_NM, R.PRM_LST_NM, N.LAST_NAME AS CALC_PRM_LST_NM    
        FROM DW_COMMON.D_HR_CMM_PERS R
        LEFT JOIN 
            (SELECT * FROM STG_DW.S_NAMES N
            WHERE 1=1
            AND N.EFF_STATUS = 'A'
            AND N.SRC_UPDT_CD = 'I'
            AND N.NAME_TYPE = 'PRI'
            AND N.EFFDT = (SELECT MAX(N_ED.EFFDT) FROM STG_DW.S_NAMES N_ED
                              WHERE N.EMPLID = N_ED.EMPLID
                              AND N.NAME_TYPE = N_ED.NAME_TYPE
                              AND N_ED.SRC_UPDT_CD = 'I'
                              AND N_ED.EFFDT <= SYSDATE)
            ) N
        ON R.EMPLID = N.EMPLID        
        )
    WHERE (
     PRM_FST_NM <> CALC_PRM_FST_NM
    OR PRM_MI_NM <> CALC_PRM_MI_NM
    OR PRM_LST_NM <> CALC_PRM_LST_NM
    )
    ; 
SELECT COUNT(*) INTO BAD_DSPL_NAMES 
    FROM
        (SELECT R.EMPLID, CP.DSPL_FULL_NM, 
        CASE WHEN P.EMPLID IS NOT NULL THEN P.NAME ELSE N.NAME END AS CALC_DSPL_FULL_NM,
        CP.DSPL_FST_NM,
        CASE WHEN P.EMPLID IS NOT NULL THEN P.FIRST_NAME 
             WHEN P.EMPLID IS NULL THEN N.FIRST_NAME END AS CALC_DSPL_FST_NM,
        CP.DSPL_MI_NM,
        CASE WHEN P.EMPLID IS NOT NULL THEN P.MIDDLE_NAME
             WHEN P.EMPLID IS NULL THEN N.MIDDLE_NAME END AS CALC_DSPL_MI_NM,
        CP.DSPL_LST_NM,
        CASE WHEN P.EMPLID IS NOT NULL THEN P.LAST_NAME 
             WHEN P.EMPLID IS NULL THEN N.LAST_NAME END AS CALC_DSPL_LST_NM         
        FROM DW_COMMON.D_HR_CMM_PERS R --HR EMPLIDS
        LEFT JOIN 
            (SELECT * FROM STG_DW.S_NAMES N
            WHERE 1=1
            AND N.EFF_STATUS = 'A'
            AND N.SRC_UPDT_CD = 'I'
            AND N.NAME_TYPE = 'PRI'
            AND N.EFFDT = (SELECT MAX(N_ED.EFFDT) FROM STG_DW.S_NAMES N_ED
                              WHERE N.EMPLID = N_ED.EMPLID
                              AND N.NAME_TYPE = N_ED.NAME_TYPE
                              AND SRC_UPDT_CD = 'I'
                              AND N_ED.EFFDT <= sysdate)
            ) N
        ON R.EMPLID = N.EMPLID    
        LEFT JOIN DW_COMMON.D_HR_CMM_PERS CP
        ON R.EMPLID = CP.EMPLID              
        LEFT JOIN
          (SELECT *
            FROM STG_DW.S_NAMES N
            WHERE 1=1
            AND EFF_STATUS = 'A'
            AND SRC_UPDT_CD = 'I'
            AND NAME_TYPE = 'PRF'                        
            AND N.EFFDT = (SELECT MAX(N_ED.EFFDT) FROM STG_DW.S_NAMES N_ED
                              WHERE N.EMPLID = N_ED.EMPLID
                              AND N.NAME_TYPE = N_ED.NAME_TYPE
                              AND SRC_UPDT_CD = 'I'
                              AND N_ED.EFFDT <= sysdate)
          ) P
        ON R.EMPLID = P.EMPLID                
        )
    WHERE (DSPL_FULL_NM <> CALC_DSPL_FULL_NM
    OR DSPL_FST_NM <> CALC_DSPL_FST_NM
    OR DSPL_MI_NM <> CALC_DSPL_MI_NM
    OR DSPL_LST_NM <> CALC_DSPL_LST_NM)
    ;
    DBMS_OUTPUT.PUT_LINE('TEST 23 NAMES');
    
    IF (BAD_PRM_NAMES = 0 AND BAD_DSPL_NAMES = 0)
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_PRM_NAMES: ', BAD_PRM_NAMES));
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_DSPL_NAMES: ', BAD_DSPL_NAMES)); 
    DBMS_OUTPUT.PUT_LINE('-----');

-- TEST 24 EHTNICITY - VALUES SHOULD MATCH CALCULATED VALUES
    WITH ETH
    AS
        (SELECT DISTINCT
          R.CMM_PERS_SID, R.EMPLID, NVL(E.ETHNIC_GRP_CD, 'NSPEC') AS CALC_ICE_CD, NVL(T.DESCR50, 'Not Specified') AS CALC_ICE_DESC,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               ELSE NVL(E.ETHNIC_GRP_CD, 'NSPEC') END AS CALC_INST_NRESA,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'  
               ELSE NVL(T.DESCR50, 'Not Specified') END AS CALC_INST_NRESA_DESC,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_EOAA_CD,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'    
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_EOAA_DESC,     
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_IPEDS_CD,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'  
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_IPEDS_DESC,       
          CASE WHEN E.PRIMARY_INDICATOR = 'Y' THEN 1
             WHEN E.ETHNIC_GRP_CD = 'PACIF' THEN 2
             WHEN E.ETHNIC_GRP_CD = 'AMIND' THEN 3
             WHEN E.ETHNIC_GRP_CD = 'HISPA' THEN 4
             WHEN E.ETHNIC_GRP_CD = 'BLACK' THEN 5  
             WHEN E.ETHNIC_GRP_CD = 'ASIAN' THEN 6
             WHEN E.ETHNIC_GRP_CD = 'WHITE' THEN 7
             WHEN (E.ETHNIC_GRP_CD = 'NSPEC' OR E.ETHNIC_GRP_CD IS NULL) THEN 8
             ELSE 99 END AS PRIMARY_RANK ,
             E.PRIMARY_INDICATOR,
             C.CITIZENSHIP_STATUS  
          
          FROM DW_COMMON.D_HR_CMM_PERS R--HR EMPLIDS
          LEFT JOIN 
                    (SELECT EMPLID, SETID, PRIMARY_INDICATOR,
                    CASE WHEN ETHNIC_GRP_CD IN ('HISP/LAT', 'CHIC/MEX') THEN 'HISPA'
                         ELSE ETHNIC_GRP_CD END AS ETHNIC_GRP_CD
                    FROM  STG_DW.S_DIVERS_ETHNIC E
                    WHERE SRC_UPDT_CD = 'I'
                    AND SETID = 'UMNHR') E
          ON R.EMPLID = E.EMPLID
          
          LEFT JOIN STG_DW.S_ETHNIC_GRP_TBL T
          ON E.SETID = T.SETID
          AND E.ETHNIC_GRP_CD = T.ETHNIC_GRP_CD
          AND T.SRC_UPDT_CD = 'I'
          AND T.EFFDT = (SELECT MAX(T_ED.EFFDT) FROM STG_DW.S_ETHNIC_GRP_TBL T_ED
                          WHERE T.SETID = T_ED.SETID
                          AND T.ETHNIC_GRP_CD = T_ED.ETHNIC_GRP_CD
                          AND T_ED.SRC_UPDT_CD = 'I'
                          AND T_ED.EFFDT <= SYSDATE)
                          
          LEFT JOIN STG_DW.S_CITIZENSHIP C
          ON R.EMPLID = C.EMPLID
          AND C.COUNTRY = 'USA'
          AND C.SRC_UPDT_CD = 'I'
        
          LEFT JOIN
                  (SELECT EMPLID, LISTAGG(ETHNIC_GRP_CD, ',') WITHIN GROUP (ORDER BY EMPLID, ETHNIC_GRP_CD) AS ETHNIC_GROUPS
                    FROM STG_DW.S_DIVERS_ETHNIC
                    WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                    GROUP BY EMPLID) G
          ON R.EMPLID = G.EMPLID
          
          LEFT JOIN
                  (SELECT EMPLID, COUNT(*)
                  FROM STG_DW.S_DIVERS_ETHNIC
                  WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                  AND ETHNIC_GRP_CD NOT IN ('HISPA', 'HISP/LAT', 'CHIC/MEX')
                  GROUP BY EMPLID
                  HAVING COUNT(*) > 1) M
          ON R.EMPLID = M.EMPLID )

    SELECT COUNT(*) INTO BAD_INST_CALC_ETHN
    FROM 
        (SELECT A.CMM_PERS_SID, A.EMPLID, 
        CP.INST_CALC_ETHN_CD, 
        A.CALC_ICE_CD, 
        CP.INST_CALC_ETHN_DESC, 
        A.CALC_ICE_DESC, 
        CP.INST_CALC_NRESA_ETHN_CD, 
        A.CALC_INST_NRESA, 
        CP.INST_CALC_NRESA_ETHN_DESC, 
        A.CALC_INST_NRESA_DESC,
        CP.EOAA_ETHN_CD, 
        A.CALC_EOAA_CD, 
        CP.EOAA_ETHN_DESC, 
        A.CALC_EOAA_DESC, 
        CP.IPEDS_ETHN_CD, 
        A.CALC_IPEDS_CD, 
        CP.IPEDS_ETHN_DESC, 
        A.CALC_IPEDS_DESC,
        A.PRIMARY_INDICATOR,
        PRIMARY_RANK, 
        CITIZENSHIP_STATUS
        FROM ETH A
        JOIN DW_COMMON.D_HR_CMM_PERS CP
        ON A.EMPLID = CP.EMPLID
        WHERE 1=1
        AND A.PRIMARY_RANK = (SELECT MIN(A1.PRIMARY_RANK) FROM ETH A1
                                WHERE A.EMPLID = A1.EMPLID)
        AND A.CMM_PERS_SID <> 0
        )                    
    WHERE (INST_CALC_ETHN_CD <> CALC_ICE_CD
    OR INST_CALC_ETHN_DESC <> CALC_ICE_DESC);
--------------------------------------------------------------------------------------------------------------
--INST_CALC_NRESA_CD
--------------------------------------------------------------------------------------------------------------
    WITH ETH
    AS
        (SELECT DISTINCT
          R.CMM_PERS_SID, R.EMPLID, NVL(E.ETHNIC_GRP_CD, 'NSPEC') AS CALC_ICE_CD, NVL(T.DESCR50, 'Not Specified') AS CALC_ICE_DESC,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               ELSE NVL(E.ETHNIC_GRP_CD, 'NSPEC') END AS CALC_INST_NRESA,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'  
               ELSE NVL(T.DESCR50, 'Not Specified') END AS CALC_INST_NRESA_DESC,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_EOAA_CD,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'    
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_EOAA_DESC,     
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_IPEDS_CD,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'  
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_IPEDS_DESC,       
          CASE WHEN E.PRIMARY_INDICATOR = 'Y' THEN 1
             WHEN E.ETHNIC_GRP_CD = 'PACIF' THEN 2
             WHEN E.ETHNIC_GRP_CD = 'AMIND' THEN 3
             WHEN E.ETHNIC_GRP_CD = 'HISPA' THEN 4
             WHEN E.ETHNIC_GRP_CD = 'BLACK' THEN 5  
             WHEN E.ETHNIC_GRP_CD = 'ASIAN' THEN 6
             WHEN E.ETHNIC_GRP_CD = 'WHITE' THEN 7
             WHEN (E.ETHNIC_GRP_CD = 'NSPEC' OR E.ETHNIC_GRP_CD IS NULL) THEN 8
             ELSE 99 END AS PRIMARY_RANK ,
           E.PRIMARY_INDICATOR,
           C.CITIZENSHIP_STATUS  
          
          FROM DW_COMMON.D_HR_CMM_PERS R--HR EMPLIDS
          LEFT JOIN 
                    (SELECT EMPLID, SETID, PRIMARY_INDICATOR,
                    CASE WHEN ETHNIC_GRP_CD IN ('HISP/LAT', 'CHIC/MEX') THEN 'HISPA'
                         ELSE ETHNIC_GRP_CD END AS ETHNIC_GRP_CD
                    FROM  STG_DW.S_DIVERS_ETHNIC E
                    WHERE SRC_UPDT_CD = 'I'
                    AND SETID = 'UMNHR') E
          ON R.EMPLID = E.EMPLID
          
          LEFT JOIN STG_DW.S_ETHNIC_GRP_TBL T
          ON E.SETID = T.SETID
          AND E.ETHNIC_GRP_CD = T.ETHNIC_GRP_CD
          AND T.SRC_UPDT_CD = 'I'
          AND T.EFFDT = (SELECT MAX(T_ED.EFFDT) FROM STG_DW.S_ETHNIC_GRP_TBL T_ED
                          WHERE T.SETID = T_ED.SETID
                          AND T.ETHNIC_GRP_CD = T_ED.ETHNIC_GRP_CD
                           AND T_ED.SRC_UPDT_CD = 'I'
                          AND T_ED.EFFDT <= SYSDATE)
                          
          LEFT JOIN STG_DW.S_CITIZENSHIP C
          ON R.EMPLID = C.EMPLID
          AND C.COUNTRY = 'USA'
          AND C.SRC_UPDT_CD = 'I'
        
          LEFT JOIN
                  (SELECT EMPLID, LISTAGG(ETHNIC_GRP_CD, ',') WITHIN GROUP (ORDER BY EMPLID, ETHNIC_GRP_CD) AS ETHNIC_GROUPS
                    FROM STG_DW.S_DIVERS_ETHNIC
                    WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                    GROUP BY EMPLID) G
          ON R.EMPLID = G.EMPLID
          
          LEFT JOIN
                  (SELECT EMPLID, COUNT(*)
                  FROM STG_DW.S_DIVERS_ETHNIC
                  WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                  AND ETHNIC_GRP_CD NOT IN ('HISPA', 'HISP/LAT', 'CHIC/MEX')
                  GROUP BY EMPLID
                  HAVING COUNT(*) > 1) M
          ON R.EMPLID = M.EMPLID )

    SELECT COUNT(*) INTO BAD_INST_CALC_NRESA
    FROM 
        (SELECT A.CMM_PERS_SID, A.EMPLID, 
        CP.INST_CALC_ETHN_CD, 
        A.CALC_ICE_CD, 
        CP.INST_CALC_ETHN_DESC, 
        A.CALC_ICE_DESC, 
        CP.INST_CALC_NRESA_ETHN_CD, 
        A.CALC_INST_NRESA, 
        CP.INST_CALC_NRESA_ETHN_DESC, 
        A.CALC_INST_NRESA_DESC,
        CP.EOAA_ETHN_CD, 
        A.CALC_EOAA_CD, 
        CP.EOAA_ETHN_DESC, 
        A.CALC_EOAA_DESC, 
        CP.IPEDS_ETHN_CD, 
        A.CALC_IPEDS_CD, 
        CP.IPEDS_ETHN_DESC, 
        A.CALC_IPEDS_DESC,
        A.PRIMARY_INDICATOR,
        PRIMARY_RANK, 
        CITIZENSHIP_STATUS
        FROM ETH A
        JOIN DW_COMMON.D_HR_CMM_PERS CP
        ON A.EMPLID = CP.EMPLID
        WHERE 1=1
        AND A.PRIMARY_RANK = (SELECT MIN(A1.PRIMARY_RANK) FROM ETH A1
                                WHERE A.EMPLID = A1.EMPLID)
        AND A.CMM_PERS_SID <> 0
        )   
    WHERE (INST_CALC_NRESA_ETHN_CD <> CALC_INST_NRESA
    OR INST_CALC_NRESA_ETHN_DESC <> CALC_INST_NRESA_DESC);    
------------------------------------------------------------------------------------------------------------
--EOAA_ETHN_CD
------------------------------------------------------------------------------------------------------------
    WITH ETH
    AS
        (SELECT DISTINCT
          R.CMM_PERS_SID, R.EMPLID, NVL(E.ETHNIC_GRP_CD, 'NSPEC') AS CALC_ICE_CD, NVL(T.DESCR50, 'Not Specified') AS CALC_ICE_DESC,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               ELSE NVL(E.ETHNIC_GRP_CD, 'NSPEC') END AS CALC_INST_NRESA,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'  
               ELSE NVL(T.DESCR50, 'Not Specified') END AS CALC_INST_NRESA_DESC,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_EOAA_CD,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'    
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_EOAA_DESC,     
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_IPEDS_CD,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'  
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_IPEDS_DESC,       
          CASE WHEN E.PRIMARY_INDICATOR = 'Y' THEN 1
             WHEN E.ETHNIC_GRP_CD = 'PACIF' THEN 2
             WHEN E.ETHNIC_GRP_CD = 'AMIND' THEN 3
             WHEN E.ETHNIC_GRP_CD = 'HISPA' THEN 4
             WHEN E.ETHNIC_GRP_CD = 'BLACK' THEN 5  
             WHEN E.ETHNIC_GRP_CD = 'ASIAN' THEN 6
             WHEN E.ETHNIC_GRP_CD = 'WHITE' THEN 7
             WHEN (E.ETHNIC_GRP_CD = 'NSPEC' OR E.ETHNIC_GRP_CD IS NULL) THEN 8
             ELSE 99 END AS PRIMARY_RANK ,
           E.PRIMARY_INDICATOR,
           C.CITIZENSHIP_STATUS  
          
          FROM DW_COMMON.D_HR_CMM_PERS R--HR EMPLIDS
          LEFT JOIN 
                    (SELECT EMPLID, SETID, PRIMARY_INDICATOR,
                    CASE WHEN ETHNIC_GRP_CD IN ('HISP/LAT', 'CHIC/MEX') THEN 'HISPA'
                         ELSE ETHNIC_GRP_CD END AS ETHNIC_GRP_CD
                    FROM  STG_DW.S_DIVERS_ETHNIC E
                    WHERE SRC_UPDT_CD = 'I'
                    AND SETID = 'UMNHR') E
          ON R.EMPLID = E.EMPLID
          
          LEFT JOIN STG_DW.S_ETHNIC_GRP_TBL T
          ON E.SETID = T.SETID
          AND E.ETHNIC_GRP_CD = T.ETHNIC_GRP_CD
          AND T.SRC_UPDT_CD = 'I'
          AND T.EFFDT = (SELECT MAX(T_ED.EFFDT) FROM STG_DW.S_ETHNIC_GRP_TBL T_ED
                          WHERE T.SETID = T_ED.SETID
                          AND T.ETHNIC_GRP_CD = T_ED.ETHNIC_GRP_CD
                           AND T_ED.SRC_UPDT_CD = 'I'
                          AND T_ED.EFFDT <= SYSDATE)
                          
          LEFT JOIN STG_DW.S_CITIZENSHIP C
          ON R.EMPLID = C.EMPLID
          AND C.COUNTRY = 'USA'
          AND C.SRC_UPDT_CD = 'I'
        
          LEFT JOIN
                  (SELECT EMPLID, LISTAGG(ETHNIC_GRP_CD, ',') WITHIN GROUP (ORDER BY EMPLID, ETHNIC_GRP_CD) AS ETHNIC_GROUPS
                    FROM STG_DW.S_DIVERS_ETHNIC
                    WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                    GROUP BY EMPLID) G
          ON R.EMPLID = G.EMPLID
          
          LEFT JOIN
                  (SELECT EMPLID, COUNT(*)
                  FROM STG_DW.S_DIVERS_ETHNIC
                  WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                  AND ETHNIC_GRP_CD NOT IN ('HISPA', 'HISP/LAT', 'CHIC/MEX')
                  GROUP BY EMPLID
                  HAVING COUNT(*) > 1) M
          ON R.EMPLID = M.EMPLID )

    SELECT COUNT(*) INTO BAD_EOAA_ETHN
    FROM 
        (SELECT A.CMM_PERS_SID, A.EMPLID, 
        CP.INST_CALC_ETHN_CD, 
        A.CALC_ICE_CD, 
        CP.INST_CALC_ETHN_DESC, 
        A.CALC_ICE_DESC, 
        CP.INST_CALC_NRESA_ETHN_CD, 
        A.CALC_INST_NRESA, 
        CP.INST_CALC_NRESA_ETHN_DESC, 
        A.CALC_INST_NRESA_DESC,
        CP.EOAA_ETHN_CD, 
        A.CALC_EOAA_CD, 
        CP.EOAA_ETHN_DESC, 
        A.CALC_EOAA_DESC, 
        CP.IPEDS_ETHN_CD, 
        A.CALC_IPEDS_CD, 
        CP.IPEDS_ETHN_DESC, 
        A.CALC_IPEDS_DESC,
        A.PRIMARY_INDICATOR,
        PRIMARY_RANK, 
        CITIZENSHIP_STATUS
        FROM ETH A
        JOIN DW_COMMON.D_HR_CMM_PERS CP
        ON A.EMPLID = CP.EMPLID
        AND CP.SRC_UPDT_CD = 'I'
        WHERE 1=1
        AND A.PRIMARY_RANK = (SELECT MIN(A1.PRIMARY_RANK) FROM ETH A1
                                WHERE A.EMPLID = A1.EMPLID)
        AND A.CMM_PERS_SID <> 0
        )   
    WHERE (EOAA_ETHN_CD <> CALC_EOAA_CD
    OR EOAA_ETHN_DESC <> CALC_EOAA_DESC);  
--------------------------------------------------------------------------------------------------------------
--IPEDS_ETHN_CD
--------------------------------------------------------------------------------------------------------------
    WITH ETH
    AS
        (SELECT DISTINCT
          R.CMM_PERS_SID, R.EMPLID, NVL(E.ETHNIC_GRP_CD, 'NSPEC') AS CALC_ICE_CD, NVL(T.DESCR50, 'Not Specified') AS CALC_ICE_DESC,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               ELSE NVL(E.ETHNIC_GRP_CD, 'NSPEC') END AS CALC_INST_NRESA,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'  
               ELSE NVL(T.DESCR50, 'Not Specified') END AS CALC_INST_NRESA_DESC,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_EOAA_CD,
          CASE WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'    
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_EOAA_DESC,     
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'NRESA'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'HISPA'
               WHEN M.EMPLID IS NOT NULL THEN 'MULTI'  
               WHEN E.ETHNIC_GRP_CD IS NULL THEN 'NSPEC'
               ELSE E.ETHNIC_GRP_CD END AS CALC_IPEDS_CD,
          CASE WHEN C.CITIZENSHIP_STATUS IN ('4', '5') THEN 'Nonresident Alien'
               WHEN (G.ETHNIC_GROUPS LIKE '%HIS%'  OR G.ETHNIC_GROUPS LIKE '%CHIC%') THEN 'Hispanic/Latino'
               WHEN M.EMPLID IS NOT NULL THEN 'Two or More Races'  
               WHEN T.DESCR50 IS NULL THEN 'Not Specified'
               ELSE T.DESCR50 END AS CALC_IPEDS_DESC,       
          CASE WHEN E.PRIMARY_INDICATOR = 'Y' THEN 1
             WHEN E.ETHNIC_GRP_CD = 'PACIF' THEN 2
             WHEN E.ETHNIC_GRP_CD = 'AMIND' THEN 3
             WHEN E.ETHNIC_GRP_CD = 'HISPA' THEN 4
             WHEN E.ETHNIC_GRP_CD = 'BLACK' THEN 5  
             WHEN E.ETHNIC_GRP_CD = 'ASIAN' THEN 6
             WHEN E.ETHNIC_GRP_CD = 'WHITE' THEN 7
             WHEN (E.ETHNIC_GRP_CD = 'NSPEC' OR E.ETHNIC_GRP_CD IS NULL) THEN 8
             ELSE 99 END AS PRIMARY_RANK ,
           E.PRIMARY_INDICATOR,
           C.CITIZENSHIP_STATUS  
          
          FROM DW_COMMON.D_HR_CMM_PERS R--HR EMPLIDS
          LEFT JOIN 
                    (SELECT EMPLID, SETID, PRIMARY_INDICATOR,
                    CASE WHEN ETHNIC_GRP_CD IN ('HISP/LAT', 'CHIC/MEX') THEN 'HISPA'
                         ELSE ETHNIC_GRP_CD END AS ETHNIC_GRP_CD
                    FROM  STG_DW.S_DIVERS_ETHNIC E
                    WHERE SRC_UPDT_CD = 'I'
                    AND SETID = 'UMNHR') E
          ON R.EMPLID = E.EMPLID
          
          LEFT JOIN STG_DW.S_ETHNIC_GRP_TBL T
          ON E.SETID = T.SETID
          AND E.ETHNIC_GRP_CD = T.ETHNIC_GRP_CD
          AND T.SRC_UPDT_CD = 'I'
          AND T.EFFDT = (SELECT MAX(T_ED.EFFDT) FROM STG_DW.S_ETHNIC_GRP_TBL T_ED
                          WHERE T.SETID = T_ED.SETID
                          AND T.ETHNIC_GRP_CD = T_ED.ETHNIC_GRP_CD
                          AND T_ED.SRC_UPDT_CD = 'I'
                          AND T_ED.EFFDT <= SYSDATE)
                          
          LEFT JOIN STG_DW.S_CITIZENSHIP C
          ON R.EMPLID = C.EMPLID
          AND C.COUNTRY = 'USA'
          AND C.SRC_UPDT_CD = 'I'
        
          LEFT JOIN
                  (SELECT EMPLID, LISTAGG(ETHNIC_GRP_CD, ',') WITHIN GROUP (ORDER BY EMPLID, ETHNIC_GRP_CD) AS ETHNIC_GROUPS
                    FROM STG_DW.S_DIVERS_ETHNIC
                    WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                    GROUP BY EMPLID) G
          ON R.EMPLID = G.EMPLID
          
          LEFT JOIN
                  (SELECT EMPLID, COUNT(*)
                  FROM STG_DW.S_DIVERS_ETHNIC
                  WHERE SETID = 'UMNHR' AND SRC_UPDT_CD = 'I'
                  AND ETHNIC_GRP_CD NOT IN ('HISPA', 'HISP/LAT', 'CHIC/MEX')
                  GROUP BY EMPLID
                  HAVING COUNT(*) > 1) M
          ON R.EMPLID = M.EMPLID )

    SELECT COUNT(*) INTO BAD_IPEDS_ETHN
    FROM 
        (SELECT A.CMM_PERS_SID, A.EMPLID, 
        CP.INST_CALC_ETHN_CD, 
        A.CALC_ICE_CD, 
        CP.INST_CALC_ETHN_DESC, 
        A.CALC_ICE_DESC, 
        CP.INST_CALC_NRESA_ETHN_CD, 
        A.CALC_INST_NRESA, 
        CP.INST_CALC_NRESA_ETHN_DESC, 
        A.CALC_INST_NRESA_DESC,
        CP.EOAA_ETHN_CD, 
        A.CALC_EOAA_CD, 
        CP.EOAA_ETHN_DESC, 
        A.CALC_EOAA_DESC, 
        CP.IPEDS_ETHN_CD, 
        A.CALC_IPEDS_CD, 
        CP.IPEDS_ETHN_DESC, 
        A.CALC_IPEDS_DESC,
        A.PRIMARY_INDICATOR,
        PRIMARY_RANK, 
        CITIZENSHIP_STATUS
        FROM ETH A
        JOIN DW_COMMON.D_HR_CMM_PERS CP
        ON A.EMPLID = CP.EMPLID
        AND CP.SRC_UPDT_CD = 'I'
        WHERE 1=1
        AND A.PRIMARY_RANK = (SELECT MIN(A1.PRIMARY_RANK) FROM ETH A1
                                WHERE A.EMPLID = A1.EMPLID)
        AND A.CMM_PERS_SID <> 0
        )   
    WHERE (IPEDS_ETHN_CD <> CALC_IPEDS_CD
    OR IPEDS_ETHN_DESC <> CALC_IPEDS_DESC);     
    
    DBMS_OUTPUT.PUT_LINE('TEST 24 ETHNICITY');
    
    IF (BAD_INST_CALC_ETHN = 0 AND BAD_INST_CALC_NRESA = 0 AND BAD_EOAA_ETHN = 0 AND BAD_IPEDS_ETHN = 0)
    THEN DBMS_OUTPUT.PUT_LINE('PASS');
    ELSE DBMS_OUTPUT.PUT_LINE('**********FAIL**********');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_INST_CALC_ETHN: ', BAD_INST_CALC_ETHN));   
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_INST_CALC_NRESA: ', BAD_INST_CALC_NRESA));   
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_EOAA_ETHN: ', BAD_EOAA_ETHN));   
    DBMS_OUTPUT.PUT_LINE(CONCAT('BAD_IPEDS_ETHN: ', BAD_IPEDS_ETHN));       
    DBMS_OUTPUT.PUT_LINE('-----');    
  
-- Record end time

    DBMS_OUTPUT.PUT_LINE('TIME FINISHED:');
    DBMS_OUTPUT.PUT_LINE(SYSTIMESTAMP);
    
END;