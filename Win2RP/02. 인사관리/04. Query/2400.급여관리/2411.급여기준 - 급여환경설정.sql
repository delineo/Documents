/* 급여환경설정 */


-- 급여환경설정
select A.COMPANY_CD, A.BSNS_STD_CD, A.STD_ID 
     , A.EFF_START_DT, A.EFF_END_DT
     , A.COL1_VAL
     , A.COL3_VAL
     , A.COL2_VAL
     , A.COL4_VAL
     , A.REMARKS
  from TB_PL_SSTD_D A
 where A.COMPANY_CD  = 'PHAL' 
   and A.BSNS_STD_CD = 'PAY_ENV_STD_CD'
 order by A.STD_ID
;
select * from TB_PL_SSTD_M
 where BSNS_STD_CD = 'PAY_ENV_STD_CD'
   and COMPANY_CD  = 'PHAL'
;
-- 급여계산 기준일수
select A.COMPANY_CD
     , A.CLASS_CD
     , A.CLASS_CD_VALUE
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD
         , A.CLASS_CD, A.CLASS_CD_VALUE, 'ko'
       ) as CD_NM
  from TB_CM_CODE_VALUE A
 where COMPANY_CD  = 'DEVW'
   and CLASS_CD    = 'PLS_DAY_STD_CD'
;


-- 급여기준관리 > 업무별기준관리 분류유형 목록 조회
select A.COMPANY_CD
     , A.CLASS_CD
     , A.CLASS_CD_VALUE
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD
         , A.CLASS_CD, A.CLASS_CD_VALUE, 'ko'
       ) as CD_NM
  from TB_CM_CODE_VALUE A
 where COMPANY_CD  = 'DEVW'
   and CLASS_CD    = 'PLS_BSNS_TYPE_CD'
;


-- 업무별 기준 목록 조회
select A.BSNS_TYPE_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD
         , 'PLS_BSNS_TYPE_CD', A.BSNS_TYPE_CD, 'ko'
       ) as TYPE_NM
     , A.BSNS_STD_CD
     , A.BSNS_TYPE_NM
  from TB_PL_SSTD_M A
 where COMPANY_CD   = 'DEVW'
   and BSNS_TYPE_CD in
       (
            'PLD'  , 'PLE'  , 'PLH'  , 'PLI'  , 'PLL'
          , 'PLQ'  , 'PLR'  , 'PLS'  , 'PLU'  , 'PLV'
       )
 order by BSNS_TYPE_CD
;

-- 급여 지급항목기준 목록
select * 
  from TB_PL_SPAYBASE_C
 where COMPANY_CD = 'DEVW'
   and ITEM_KIND_CD = '01' -- 지급항목기준
;

-- 급여 공제항목기준 목록
select * 
  from TB_PL_SPAYBASE_C
 where COMPANY_CD = 'DEVW'
   and ITEM_KIND_CD = '02' -- 공제항목기준
;

-- 상여항목기준 목록
select * 
  from TB_PL_SPAYBASE_C
 where COMPANY_CD = 'DEVW'
   and ITEM_KIND_CD = '03' -- 상여항목기준
;

-- 급여항목상세목록
select A.BSNS_STD_CD
     , A.STD_ID
     , A.COL1_VAL
     , B.ITEM_CD, B.ITEM_KIND_CD, B.DTL_SET_NM
  from TB_PL_SSTD_D     A
  ,    TB_PL_SPAYBASE_D B
 where A.COMPANY_CD = B.COMPANY_CD(+)
   and A.STD_ID     = B.DTL_SET_CD(+)
   and A.COMPANY_CD = 'DEVW' 
   and A.BSNS_STD_CD= 'PAY_BASE_CD'
   and A.COL2_VAL   = 'MAIN'    -- MAIN : 상세항목 , EXCP : 제외항목
   and B.ITEM_CD(+) = 'B100'    -- 상위 기준 항목(지급/공제/상여)에 따라서 
;
/
-- 지급수당목록
select
       A.ITEM_CD                        "itemCd"                       /* 소득공제코드 */
     , A.ITEM_KIND_CD                   "itemKindCd"                   /* 소득공제구분 */
     , A.ITEM_CD_HAN                    "itemCdHan"                    /* 소득공제코드한글명 */
     , A.*
  from TB_PL_SPAYBASE_C A

 where A.COMPANY_CD     = 'DEVW'
   and A.ITEM_KIND_CD   = '01'

   and A.EFF_START_DT  <= to_char(sysdate, 'YYYYMMDD')
   and A.EFF_END_DT    >= to_char(sysdate, 'YYYYMMDD')
   and A.USE_YN         = 'Y'
   and A.TYPE_GBN_CD   <> 'S'
order by A.CALC_SEQ_NO asc
;

-- 기준별 상세화면 목록
select B.COMPANY_CD     as "companyCd"      /* 회사코드         */
     , B.ITEM_CD        as "itemCd"         /* 소득공제코드     */
     , B.EFF_START_DT   as "effStartDt"     /* 유효시작일       */
     , B.ITEM_KIND_CD   as "itemKindCd"     /* 지급공제구분     */
     , B.DTL_SET_CD     as "dtlSetCd"       /* 상세설정코드     */
     , B.END_YMD        as "effEndDt"       /* 적용종료일       */
     , B.DTL_SET_NM     as "dtlSetNm"       /* 상세설정코드명   */
     , A.COL3_VAL       as "path"           /* 표시화면         */
     , B.EFF_START_DT
     , A.COL2_VAL

  from TB_PL_SSTD_D A , TB_PL_SPAYBASE_D B
 where A.COMPANY_CD    = B.COMPANY_CD
   and A.STD_ID        = B.DTL_SET_CD
   and A.COMPANY_CD    = 'DEVW'
   and A.BSNS_STD_CD   = 'PAY_BASE_CD'
   and A.EFF_START_DT <= to_char(sysdate,'YYYYMMDD')
   and A.EFF_END_DT   >= to_char(sysdate,'YYYYMMDD')
   and B.EFF_START_DT <= to_char(sysdate,'YYYYMMDD')
   
   --and B.ITEM_CD       = 'S015' --:itemCd -- 항목선택 필요
   and B.ITEM_KIND_CD  = '01' -- 01 : 급여, 02 : 공제, 03 : 상여
;

-- 근속연수/직무별/급여종류별 기준내역 (공통코드)
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           B.COMPANY_CD
         , B.CLASS_CD, B.CLASS_CD_VALUE, 'ko'
       ) as CD_NM
  from TB_PL_SDTLCOMN_C A
  ,    TB_CM_CODE_VALUE B
 where A.COMPANY_CD     = B.COMPANY_CD(+)
   and A.MAIN_SET_CD    = B.CLASS_CD_VALUE(+)
   and A.DTL_SET_CD     = B.CLASS_CD(+)

   and A.COMPANY_CD     = 'DEVW'
--   and A.ITEM_CD        = 'S015' -- 근속수당
   and B.USE_YN(+)      = 'Y'

   --and A.DTL_SET_CD     = 'DEPT_CD'             -- 부서별(실제 설정된 정보이나 부서정보는 존재하지 않음)
   --and A.DTL_SET_CD     = 'STEP_CD'             -- 호봉별(실제 설정된 정보이나 호봉정보는 존재하지 않음)
   --and A.DTL_SET_CD     = 'PLS_WORK_TERM_YY'  -- 근속연수
   --and A.DTL_SET_CD     = 'PLH_JOBDUTY_CD'    -- 직무별
   --and A.DTL_SET_CD     = 'PLS_PAY_KIND_CD'   -- 급여종류별
   --and A.DTL_SET_CD     = 'PLD_WRKGRP_CD'     -- 근무조별
   --and A.DTL_SET_CD     = 'PLH_DUTYGRD_CD'    -- 직무등급별
   --and A.DTL_SET_CD     = 'PLH_JOBPST_CD'     -- 직위별
   --and A.DTL_SET_CD      = 'PLH_JOBKIND_CD'   -- 직종별
   --and A.DTL_SET_CD     = 'PLD_WRKGRPGBN_CD'  -- 근무구분별
   --and A.DTL_SET_CD     = 'PLD_WRKGRP_CD'     -- 근태별
   --and A.DTL_SET_CD     = 'PLH_JOBTIT_CD'     -- 직책별
   --and A.DTL_SET_CD     = 'PLK_LBRUNION_CD'   -- 노조별

;

-- 가족기준별내역
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.MERRY_CD
  from TB_PL_SDTLFAMILY_D A
 where A.COMPANY_CD = 'DEVW'
   and A.DTL_SET_CD = 'FMLY_BASE_CD'
;

-- 개인별기준내역
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , B.EMP_NM
  from TB_PL_SDTLCOMN_C A
  ,    TB_PL_HEMP_M     B
 where A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.EMP_NO(+)

   --and A.ITEM_CD     = 'S020' -- 직급수당
   and A.DTL_SET_CD  = 'EMP_NO' -- 개인별
;

-- 부서별기준내역(TB_PL_SDTLCOMN_C 테이블에 설정하기 위한 기초 정보로 활용되고 실제 저장은 TB_PL_SDTLCOMN_C 에 저장됨)
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , B.DEPT_NM
  from TB_PL_SDTLCOMN_C A
  ,    TB_PL_ODEPT_M    B
 where A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.DEPT_CD(+)
   
   --and A.ITEM_CD     = ''
   and A.DTL_SET_CD  = 'DEPT_CD'
;

-- 호봉별기준내역(TB_PL_SDTLCOMN_C 테이블에 설정하기 위한 기초 정보로 활용되고 실제 저장은 TB_PL_SDTLCOMN_C 에 저장됨)
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , B.STEP_NM
  from TB_PL_SDTLCOMN_C A
  ,    TB_PL_SPAYTB_C   B
 where A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.STEP_CD(+)
   
   --and A.ITEM_CD     = ''
   and A.DTL_SET_CD  = 'STEP_CD'
;

-- 근태항목별 기준내역
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , B.BSNS_STD_CD, B.COL1_VAL
  from TB_PL_SDTLCOMN_C A
  ,    TB_PL_SSTD_D     B
 where A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.STD_ID(+)
   
   --and A.ITEM_CD     = ''
   --and A.DTL_SET_CD  = 'PAY_BASE_DTL_COM1_CD' -- 직책과근속(??? 노동조합테스트???)
   --and A.DTL_SET_CD  = 'PAY_BASE_DTL_COM2_CD' -- 직무와직책기준(테스트???)
   and A.DTL_SET_CD  = 'PAY_BASE_DTL_WRK_CD' -- 교대와상주기준
;

-- 예외직책별/직책한계시간별 기준항목 내역 --> 사용처가 없는듯 ㅡㅡ^
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           B.COMPANY_CD
         , B.CLASS_CD, B.CLASS_CD_VALUE, 'ko'
       ) as CD_NM
  from TB_PL_SDTLEXCP_C A
   ,   TB_CM_CODE_VALUE B
 where A.COMPANY_CD   = B.COMPANY_CD(+)
   and A.MAIN_SET_CD  = B.CLASS_CD_VALUE(+)
   and A.DTL_SET_CD   = B.CLASS_CD(+)
   and B.USE_YN(+)    = 'Y'
   
   and A.DTL_SET_CD   = 'PLH_JOBTIT_CD'
;

-- 제외사원별 기준항목 내역
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , B.EMP_NM
  from TB_PL_SDTLEXCP_C A, TB_PL_HEMP_M B
 where 1=1
   and A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.EMP_NO(+)
   
   and A.COMPANY_CD  = 'DEVW'
--   and A.ITEM_CD     = :itemCd
   and A.DTL_SET_CD  = 'EXCP_EMP_NO'
;

-- 근태별 기준항목 내역
select A.ITEM_CD
     , (
           select ITEM_CD_HAN
             from TB_PL_SPAYBASE_C SA
            where SA.COMPANY_CD = A.COMPANY_CD
              and SA.ITEM_CD    = A.ITEM_CD
       ) as ITEM_NM
     , A.DTL_SET_CD, A.MAIN_SET_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           B.COMPANY_CD
         , B.CLASS_CD, B.CLASS_CD_VALUE, 'ko'
       ) as CD_NM
  from TB_PL_SDTLWRK_C  A
   ,   TB_CM_CODE_VALUE B
   ,   TB_PL_SSTD_D     C
 where 1=1
   and A.COMPANY_CD   = B.COMPANY_CD(+)
   and A.MAIN_SET_CD  = B.CLASS_CD_VALUE(+)

   and A.COMPANY_CD   = C.COMPANY_CD(+)
   and A.CALC_MODE_CD = C.STD_ID(+)

   and A.COMPANY_CD      = 'DEVW'
   and B.CLASS_CD(+)     = 'PLD_WRKGRP_CD'

   and C.BSNS_STD_CD(+)  = 'PLD_MMATTDTOT_B' 
   and C.EFF_START_DT(+)<= trunc(sysdate, 'DD')
   and C.EFF_END_DT(+)  >= trunc(sysdate, 'DD')
;

-- 급여계산식
select * from TB_PL_SPAYCALC_TXT
;

