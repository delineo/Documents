-- 사원기본정보 조회
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
            and to_char(sysdate, 'YYYYMMDD')
                between A.VALID_PERIOD_START_DT
                    and A.VALID_PERIOD_END_DT
            and to_char(sysdate, 'YYYYMMDD')
                between B.VALID_PERIOD_START_DT
                    and B.VALID_PERIOD_END_DT
            --and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD           in 
                (
                    'PLH_EMPKIND_CD'   -- 직원구분
                  , 'PLH_EMPLOY_CD'    -- 채용구분
                  , 'PLV_EMP_ST_CD'    -- 직원상태
                  , 'PLH_SEX_CD'       -- 남여성별
                  , 'PLH_LUSOLAR_GBN'  -- 음양구분
                  , 'PLH_FOREIGN_TP'   -- 내/외국인구분
                  , 'PLH_NATION_CD'    -- 국적(국가)
                  , 'PLH_MARRY_CD'     -- 결혼여부
                  , 'PLH_JOBKIND_CD'   -- 직종
                  , 'PLH_JOBPST_CD'    -- 직위
                  , 'PLH_JOBGRD_CD'    -- 직급
                  , 'PLD_WRKGRP_CD'    -- 근무조
                  , 'PLD_WRKTYPE_CD'   -- 근무형태
                  , 'PLH_JOBGBN_CD'    -- 업무구분
                  , 'PLS_PAY_KIND_CD'  -- 급여구분
                  , 'PLH_JOBTIT_CD'    -- 직책코드
                  , 'PLH_TITCALL_CD'   -- 호칭
                  , 'PLH_JOBDUTY_CD'   -- 직무
                  , 'PLH_RETIRETYPE_CD'-- 퇴직구분
                  , 'PLH_WRKTYPEGBN_CD'-- 근무형태
                )
     )
select
       A.COMPANY_CD
     , B.EMP_NO
     , B.EMP_ID -- Win2RP 접속 ID > TB_CM_USER 테이블에 등록필요
     , B.EMP_NM
     , B.ENG_NM
     , B.CHI_NM
     , B.RESIDENT_NO
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_EMPKIND_CD'
              and CD_VAL     = B.EMP_KIND_CD
       ) as EMP_KIND_NM
     , B.EMP_KIND_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_EMPLOY_CD'
              and CD_VAL     = B.EMP_KIND_CD
       ) as EMPLOY_NM
     , B.EMPLOY_CD
     , (
           select EMP_NM
             from TB_PL_HEMP_M
            where COMPANY_CD = B.COMPANY_CD
              and EMP_NO     = B.RCMD_EMP
       ) as RCMD_EMP_NM
     , B.RCMD_EMP
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLV_EMP_ST_CD'
              and CD_VAL     = B.EMP_KIND_CD
       ) as EMP_ST_NM
     , B.EMP_ST_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_SEX_CD'
              and CD_VAL     = B.SEX_CD
       ) as SEX_NM
     , B.SEX_CD
     , B.BIRTH_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_LUSOLAR_GBN'
              and CD_VAL     = B.LU_SOLAR_TP
       ) as LU_SOLAR_NM
     , B.LU_SOLAR_TP
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_FOREIGN_TP'
              and CD_VAL     = B.FOREIGN_TP
       ) as FOREIGN_NM
     , B.FOREIGN_TP
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_NATION_CD'
              and CD_VAL     = B.NATION_CD
       ) as NATION_NM
     , B.NATION_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_MARRY_CD'
              and CD_VAL     = B.MARRY_CD
       ) as MARRY_NM
     , B.MARRY_CD
     , B.EMAIL
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBKIND_CD'
              and CD_VAL     = B.JOBKIND_CD
       ) as JOBKIND_NM
     , B.JOBKIND_CD
     , B.JOBKIND_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBPST_CD'
              and CD_VAL     = B.JOBPST_CD
       ) as JOBPST_NM
     , B.JOBPST_CD
     , B.JOBPST_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBGRD_CD'
              and CD_VAL     = B.JOBGRD_CD
       ) as JOBGRD_NM
     , B.JOBGRD_CD
     , B.JOBGRD_YMD
     , B.AFTER_JOBGRD_YMD
     , (
           select STEP_NM
             from TB_PL_SPAYTB_C
            where COMPANY_CD = B.COMPANY_CD
              and STEP_CD    = B.SAL_STEP
       ) as SAL_STEP_NM
     , B.SAL_STEP
     , B.SAL_STEP_YMD
     , B.NEXT_YEARNUM_YMD
     , A.DEPT_NM, A.DEPT_CD
--     , (
--           select DEPT_NM
--             from TB_PL_ODEPT_M
--            where COMPANY_CD = B.COMPANY_CD
--              and DEPT_CD    = B.DEPT_CD
--              and to_char(sysdate, 'YYYYMMDD')
--                  between START_YMD and END_YMD
--       ) as DEPT_NM
--     , B.DEPT_CD
     , B.DEPT_YMD
     , B.TEL_NO
     , B.CELL_TEL_NO
     , B.OFFI_TEL_NO
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKGRP_CD'
              and CD_VAL     = B.WRKGRP_CD
       ) as WRKGRP_NM
     , B.WRKGRP_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKTYPE_CD'
              and CD_VAL     = B.WRKTYPE_CD
       ) as WRKTYPE_NM
     , B.WRKTYPE_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBGBN_CD'
              and CD_VAL     = B.JOBGBN_CD
       ) as JOBGBN_NM
     , B.JOBGBN_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PAY_KIND_CD'
              and CD_VAL     = B.PAY_KIND_CD
       ) as PAY_KIND_NM
     , B.PAY_KIND_CD
     , (
           select DEPT_NM
             from TB_PL_ODEPT_M
            where COMPANY_CD = B.COMPANY_CD
              and DEPT_CD    = B.PAY_DEPT_CD
              and to_char(sysdate, 'YYYYMMDD')
                  between START_YMD and END_YMD
       ) as PAY_DEPT_NM
     , B.PAY_DEPT_CD
     , (
           select DEPT_NM
             from TB_PL_ODEPT_M
            where COMPANY_CD = B.COMPANY_CD
              and DEPT_CD    = B.WORK_DEPT_CD
              and to_char(sysdate, 'YYYYMMDD')
                  between START_YMD and END_YMD
       ) as WORK_DEPT_NM
     , B.WORK_DEPT_CD
     , B.WORK_DEPT_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBTIT_CD'
              and CD_VAL     = B.JOBTIT_CD
       ) as JOBTIT_NM
     , B.JOBTIT_CD
     , B.JOBTIT_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_TITCALL_CD'
              and CD_VAL     = B.TITCALL_CD
       ) as TITCALL_NM
     , B.TITCALL_CD
     , B.TITCALL_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBDUTY_CD'
              and CD_VAL     = B.JOBDUTY_CD
       ) as JOBDUTY_NM
     , B.JOBDUTY_CD
     , B.JOBDUTY_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_DUTYGRD_CD'
              and CD_VAL     = B.DUTYGRD_CD
       ) as DUTYGRD_NM
     , B.DUTYGRD_CD
     , B.DUTYGRD_YMD
     , B.PRSV_YY_DDCNT
     , B.BEGIN_EMPLOY_YMD
     , B.EMPLOY_YMD
     , B.ANNUAL_RCKN_YMD
     , B.CNTU_BASE_YMD
     , B.RETI_STTL_YMD
     , B.YY_END_STTL_YMD
     , B.RETIRE_YMD
     , B.RETIRE_PLAN_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_RETIRETYPE_CD'
              and CD_VAL     = B.RETIRE_TYPE_CD
       ) as RETIRE_TYPE_NM
     , B.RETIRE_TYPE_CD
     , B.TRAIN_ST_YMD
     , B.TRAIN_ED_YMD
     , B.EMP_SUB_CD         -- 사용하지 않는 필드인듯
     , B.REPR_JOBDUTY_CD    -- 코드가 아닌 텍스트입력
     , (
           select FACTORY_NM
             from TB_CM_FACTORY
            where COMPANY_CD  = B.COMPANY_CD
              and BIZ_UNIT_CD = B.BIZ_UNIT_CD
              and FACTORY_CD  = B.FACTORY_CD
       ) as FACTORY_NM
     , B.FACTORY_CD         -- 코드는 있으나 사용하지 않는듯
     , (
           select BIZ_UNIT_NM
             from TB_CM_BIZ_UNIT
            where COMPANY_CD  = B.COMPANY_CD
              and BIZ_UNIT_CD = B.BIZ_UNIT_CD
       ) as BIZ_UNIT_NM
     , B.BIZ_UNIT_CD
     , (
           select COST_CENTER_NM
             from TB_CM_COST_CENTER
            where COMPANY_CD  = B.COMPANY_CD
              and COST_CENTER = B.COST_DEPT_CD
       ) as COST_DETP_NM
     , B.COST_DEPT_CD
     , B.NOTE
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CLASS_CD   = 'PLH_WRKTYPEGBN_CD'
              and CD_VAL     = B.WRKTYPE_GBN_CD
       ) as WRKTYPE_GBN_NM
     , B.WRKTYPE_GBN_CD
     , B.PHOTO_FILE_ID
     , B.PHOTO_FILE_NM
  from
   (
       select SA.COMPANY_CD, level as LVL, rownum as RID
            , SA.DEPT_CD, SA.DEPT_NM
            , sys_connect_by_path(SA.DEPT_CD, '.') as SORT_KEY
         from TB_PL_ODEPT_M SA
        where 1=1
          and to_char(sysdate, 'YYYYMMDD')
              between SA.START_YMD and SA.END_YMD
        start with SA.COMPANY_CD = 'PHAL'
               and SA.SUPER_DEPT_CD is null
        connect by prior SA.COMPANY_CD = SA.COMPANY_CD
               and prior SA.DEPT_CD    = SA.SUPER_DEPT_CD
   ) A
  ,    TB_PL_HEMP_M B
 where 1=1
   and A.COMPANY_CD = B.COMPANY_CD
   and A.DEPT_CD    = B.DEPT_CD

   and A.COMPANY_CD = 'PHAL'

 order by SORT_KEY
;

-- 사용자(사원) 목록 조회(사원별 Win2RP 접속계정 등록 여부 확인)
select 
       A.USER_ID
     , A.USER_NM
     , A.EMP_NO
     , A.BIZ_UNIT_CD    -- 사업장코드
     , A.FACTORY_CD     -- 공장코드
     , B.EMP_NO
     , B.EMP_ID
     , B.EMP_NM
     , B.BIZ_UNIT_CD    -- 사업장코드
     , B.FACTORY_CD     -- 공장코드
  from TB_CM_USER   A
  full outer join 
       TB_PL_HEMP_M B 
    on (
           A.COMPANY_CD = B.COMPANY_CD
       and A.EMP_NO     = B.EMP_NO
       )
 where (
           A.COMPANY_CD = 'PHAL'
        or B.COMPANY_CD = 'PHAL'
       )
;


select * from TB_CM_FACTORY;
select * from TB_PL_SPAYTB_C
 where COMPANY_CD = 'PSFN'
 order by SEQ_NO
;

select * from TB_CM_COMPANY
;

