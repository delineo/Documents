-- 퇴직연금보험사
with V_CODES as
     (
         select A.COMPANY_CD, A.CLASS_CD
              , B.CLASS_CD_VALUE as CD_VAL
              , C.META_ITEM_DESC as CD_NAME
           from TB_CM_CODE_CLASS    A
           ,    TB_CM_CODE_VALUE    B
           ,    TB_CM_LANGUAGE_PACK C
          where A.COMPANY_CD       = B.COMPANY_CD(+)
            and A.CLASS_CD         = B.CLASS_CD(+)
            and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID(+)
            and C.LANGUAGE_CD(+)   = 'ko'
            and to_char(sysdate, 'YYYYMMDD') between A.VALID_PERIOD_START_DT and A.VALID_PERIOD_END_DT
            and to_char(sysdate, 'YYYYMMDD') between B.VALID_PERIOD_START_DT and B.VALID_PERIOD_END_DT
            and A.COMPANY_CD       = 'DEVW'
            and A.CLASS_CD        in 
                (
                    'PLR_INSU_CORP_CD'      -- 보험사
                )
     )
select
       A.COMPANY_CD             /* 회사코드          */
     , A.BSNS_STD_CD            /* 업무별기준코드    */
     , A.STD_ID                 /* 기준ID            */
     , A.EFF_START_DT           /* 유효시작일        */
     , A.EFF_END_DT             /* 유효종료일        */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CD_VAL     = A.COL1_VAL
       ) as INSU_CORP_NM
     , A.COL1_VAL               /* 퇴직연금보험사코드*/
     , A.COL2_VAL               /* 사업자번호        */
     , A.COL3_VAL               /* 지점명            */
     , A.COL4_VAL               /* 담당자성명        */
     , A.COL5_VAL               /* 직책              */
     , A.COL6_VAL               /* 담당부서          */
     , A.COL7_VAL               /* 전화번호          */
     , A.COL8_VAL               /* 핸드폰            */
     , A.COL9_VAL               /* 팩스번호          */
     , A.COL10_VAL              /* E-Mail            */
     , A.REMARKS                /* 비고              */
  from TB_PL_SSTD_D A
 where A.COMPANY_CD  = 'DEVW'
   and A.BSNS_STD_CD = 'PLR_INSU_COPR_CD' 

 order by A.STD_ID
;

-- 직원별 퇴직연금유형등록
with V_CODES as
     (
         select A.COMPANY_CD, A.CLASS_CD
              , B.CLASS_CD_VALUE as CD_VAL
              , C.META_ITEM_DESC as CD_NAME
           from TB_CM_CODE_CLASS    A
           ,    TB_CM_CODE_VALUE    B
           ,    TB_CM_LANGUAGE_PACK C
          where A.COMPANY_CD       = B.COMPANY_CD(+)
            and A.CLASS_CD         = B.CLASS_CD(+)
            and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID(+)
            and C.LANGUAGE_CD(+)   = 'ko'
            and to_char(sysdate, 'YYYYMMDD') between A.VALID_PERIOD_START_DT and A.VALID_PERIOD_END_DT
            and to_char(sysdate, 'YYYYMMDD') between B.VALID_PERIOD_START_DT and B.VALID_PERIOD_END_DT
            and A.COMPANY_CD       = 'DEVW'
            and A.CLASS_CD        in 
                (
                    'PLR_RETI_ANNT_CD'      -- 퇴직연금가입유형코드
                  , 'PLR_INSU_CORP_CD'      -- 보험사
                  , 'PLH_EMPKIND_CD'        -- 직원구분
                  , 'PLH_JOBGRD_CD'         -- 직급
                  , 'PLH_JOBTIT_CD'         -- 직책
                  , 'PLH_EMPST_CD'          -- 상태(재직,휴직,퇴직)
                )
     )
select
       A.COMPANY_CD                 /* 회사코드        */
     , A.EMP_NM                     /* 사원성명(한글)  */
     , A.EMP_NO                     /* 사원번호        */
     , PKG_CMA_UTILS.GET_DEPT_NM
       (
           A.COMPANY_CD, A.DEPT_CD
         , nvl(null,to_char(sysdate, 'yyyymmdd'))
         , '1'
       ) as DEPT_NM                 /* 발령부서명      */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLH_EMPKIND_CD'
              and CD_VAL     = A.EMP_KIND_CD
       ) as EMP_KIND_NM
--     , A.EMP_KIND_CD                /* 직원구분코드    */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBTIT_CD'
              and CD_VAL     = A.JOBTIT_CD
       ) as JOBTIT_NM
--     , A.JOBTIT_CD                  /* 직책코드        */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBGRD_CD'
              and CD_VAL     = A.JOBGRD_CD
       ) as JOBGRD_NM
--     , A.JOBGRD_CD                  /* 직급코드        */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLH_EMPST_CD'
              and CD_VAL     = A.EMP_ST_CD
       ) as EMPST_NM
--     , A.EMP_ST_CD                  /* 상태코드        */
     , A.EMPLOY_YMD                 /* 입사일자        */
     , A.RETI_STTL_YMD              /* 퇴직정산기준일  */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CD_VAL     = B.RETIRE_PENSION_KIND
       ) as RETIRE_PENSION_KIND_NM
     , B.RETIRE_PENSION_KIND        /* 퇴직연금유형    */
     , B.DC_JOIN_YMD                /* DC형가입일자    */
     --, nvl(C.RETI_ANNT_AMT,0)       /* 퇴직연금총액    */
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = B.COMPANY_CD
              and CD_VAL     = B.INSU_CORP_CD
       ) as INSU_CORP_NM
     , B.INSU_CORP_CD               /* 보험회사코드    */
     , B.REMARKS                    /* 비고            */
  from TB_PL_HEMP_M       A
  ,    TB_PL_PAYBASE_INFO B
 where A.COMPANY_CD = B.COMPANY_CD(+)
   and A.EMP_NO     = B.EMP_NO(+)

   and A.EMP_ST_CD  not in ('0201') -- 퇴직자 제외

   and A.COMPANY_CD = 'DEVW'
;



select * from TB_PL_PAYBASE_INFO
