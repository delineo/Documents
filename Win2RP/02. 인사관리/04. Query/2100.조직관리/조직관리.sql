

-- 조직 기초정보 조회
with V_CODES as
     (
         select A.COMPANY_CD, A.CLASS_CD
              , B.CLASS_CD_VALUE as CD_VAL
              , C.META_ITEM_DESC as CD_NAME
           from TB_CM_CODE_CLASS    A
           ,    TB_CM_CODE_VALUE    B
           ,    TB_CM_LANGUAGE_PACK C
          where A.COMPANY_CD          = B.COMPANY_CD(+)
            and A.CLASS_CD            = B.CLASS_CD(+)
            and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID(+)
            and C.LANGUAGE_CD(+)      = 'ko'
            and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD           in 
                (
                    'PLO_DEPTTYPE_CD'   -- 조직유형
                  , 'PLO_DEPTRSN_CD'    -- 조직변경사유
                )
     )
select A.COMPANY_CD
     , A.DEPT_NM, A.DEPT_CD
     , (
           select DEPT_NM 
             from TB_PL_ODEPT_M
            where COMPANY_CD = A.COMPANY_CD
              and DEPT_CD    = A.SUPER_DEPT_CD
              and to_char(sysdate, 'YYYYMMDD')
                  between START_YMD and END_YMD
       ) as SUPER_DEPT_NM
     , A.SUPER_DEPT_CD
     , A.SHORT_NM, A.FULL_NM, A.ENG_NM, A.HR_DEPT_NM
     , (
           select DEPT_NM 
             from TB_PL_ODEPT_M
            where COMPANY_CD = A.COMPANY_CD
              and DEPT_CD    = A.MGR_DEPT_CD
              and to_char(sysdate, 'YYYYMMDD')
                  between START_YMD and END_YMD
       ) as MGR_DEPT_NM
     , A.MGR_DEPT_CD
     , (
           select DEPT_NM 
             from TB_PL_ODEPT_M
            where COMPANY_CD = A.COMPANY_CD
              and DEPT_CD    = A.CONTROL_DEPT_CD
              and to_char(sysdate, 'YYYYMMDD')
                  between START_YMD and END_YMD
       ) as CONTROL_DEPT_NM
     , A.CONTROL_DEPT_CD
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLO_DEPTTYPE_CD'
              and CD_VAL     = A.DEPT_TYPE_CD
       ) as DEPT_TYPE_NM
     , A.DEPT_TYPE_CD
     , A.WORK_AREA_CD -- 무슨의미인지... 현재 부서를 선택하도록 되어있고, 데이터는 코드가 아닌 명칭이 입력되어있음
     , (
           select COST_CENTER_NM
             from TB_CM_COST_CENTER
            where COMPANY_CD   = A.COMPANY_CD
              and USE_YN       = 'Y'
              and COST_CENTER  = A.COST_DEPT_CD
       ) as COST_DEPT_NM
     , A.COST_DEPT_CD
     , A.SQ
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLO_DEPTTYPE_CD'
              and CD_VAL     = A.DEPT_RSN_CD
       ) as DEPT_RSN_NM
     , A.DEPT_RSN_CD
     , A.REG_DEPT_YN
     , A.DEPT_LINE
     , A.DEPT_S_YMD
     , A.DEPT_E_YMD
     , A.NOTE
     , A.DEPT_ID
     , (
           select EMP_NM
             from TB_PL_HEMP_M
            where COMPANY_CD = A.COMPANY_CD
              and EMP_NO     = A.DEPT_REPR_EMP_NO
       ) as DEPT_REPR_EMP_NM
     , A.DEPT_REPR_EMP_NO
     , (
           select BIZ_UNIT_NM from TB_CM_BIZ_UNIT
            where COMPANY_CD  = A.COMPANY_CD
              and BIZ_UNIT_CD = A.BIZ_UNIT_CD
       ) as BIZ_UNIT_NM
     , A.BIZ_UNIT_CD
     , A.START_YMD
     , A.END_YMD
  from TB_PL_ODEPT_M A
 where 1=1
   and A.COMPANY_CD = 'PHAL'
   and to_char(sysdate, 'YYYYMMDD')
       between START_YMD and END_YMD
 start with A.SUPER_DEPT_CD is null
connect by prior A.COMPANY_CD = A.COMPANY_CD
       and prior A.DEPT_CD    = A.SUPER_DEPT_CD
;

-- 코스트센터 조회
select COST_CENTER
     , COST_CENTER_NM
  from TB_CM_COST_CENTER
 where COMPANY_CD   = 'PHAL'
   and USE_YN       = 'Y'
;

-- 사업장 조회
select * from TB_CM_BIZ_UNIT
 where COMPANY_CD = 'PHAL'