-- 일할일수기준
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
            --and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD        in 
                (
                    'PLS_PAY_KIND_CD'  -- 급여구분
                  , 'PLS_DAY_STD_CD'   -- 일수기준
                )
     )
select
       A.COMPANY_CD                     /* 회사코드             */
     , A.EFF_START_DT                   /* 유효시작일           */
     , A.EFF_END_DT                     /* 유효종료일           */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_PAY_KIND_CD'
              and CD_VAL     = A.PAY_KIND_CD
       ) as PAY_KIND_NM
     , A.PAY_KIND_CD                    /* 급여구분코드         */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_DAY_STD_CD'
              and CD_VAL     = A.DAY_STD_CD
       ) as DAY_STD_NM
     , A.DAY_STD_CD                     /* 일수기준코드         */
     , A.BASE_DD_CNT                    /* 기준일수             */
     , A.BASE_TIME_CNT                  /* 기준시간             */
     , A.BUSS_DAY_APPL_YN               /* 평일적용여부         */
     , A.SAT_APPL_YN                    /* 토요일적용여부       */
     , A.HOLY_APPL_YN                   /* 휴일적용여부         */

  from TB_PL_STENPRODAYCNT_D A
 where A.COMPANY_CD    = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT

 order by A.PAY_KIND_CD, A.EFF_START_DT
;

-- 시간고정 일할기준
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
                    'PLS_TIME_CD'      -- 시간고정
                  , 'PLS_DAY_STD_CD'   -- 일수기준
                  , 'PLS_DML_PROC_CD'  -- 소수처리
                  , 'PLS_UNIT_CD'      -- 단위코드
                )
     )
select
       A.COMPANY_CD                     /* 회사코드       */
     , A.EFF_START_DT                   /* 유효시작일     */
     , A.EFF_END_DT                     /* 유효종료일     */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_TIME_CD'
              and CD_VAL     = A.TIME_CD
       ) as TIME_NM
     , A.TIME_CD                        /* 시간고정코드   */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_DAY_STD_CD'
              and CD_VAL     = A.DAY_STD_CD
       ) as DAY_STD_NM
     , A.DAY_STD_CD                     /* 일수기준코드   */
     , A.USE_YN                         /* 적용여부       */
     , A.BASE_DD_CNT                    /* 기준일수       */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_DML_PROC_CD'
              and CD_VAL     = A.PAY_SINGULAR_TYPE_CD
       ) as PAY_SINGULAR_TYPE_NM
     , A.PAY_SINGULAR_TYPE_CD           /* 단수구분코드   */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_UNIT_CD'
              and CD_VAL     = A.PAY_SINGULAR_UNIT_CD
       ) as PAY_SINGULAR_UNIT_NM
     , A.PAY_SINGULAR_UNIT_CD           /* 단수단위코드   */
  from TB_PL_STENPROFIXTIME_D A
 where A.COMPANY_CD = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT

 order by A.TIME_CD, EFF_START_DT
;

-- 상여 지급비율 기준
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
                    'PLS_LINK_ITEM_CD' -- 연계항목
                  , 'PLS_CALC_MODE_CD' -- 계산방식
                )
     )
select
       A.COMPANY_CD                     /* 회사코드       */
     , A.EFF_START_DT                   /* 유효시작일     */
     , A.EFF_END_DT                     /* 유효종료일     */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_LINK_ITEM_CD'
              and CD_VAL     = A.LINK_ITEM_CD
       ) as LINK_ITEM_CD
     , A.LINK_ITEM_CD                   /* 기준코드       */
     , A.SEQ_NO                         /* 순번           */
     , A.TERM_EXCS                      /* 초과           */
     , A.TERM_DOWN                      /* 이하           */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_CALC_MODE_CD'
              and CD_VAL     = A.CALC_MODE_CD
       ) as CALC_MODE_NM
     , A.CALC_MODE_CD                   /* 적용방법코드   */
     , A.BASE_DD_CNT                    /* 기준일수_비율  */
     , A.REMARKS                        /* 비고           */
  from TB_PL_STENPROBNUS_D A
 where A.COMPANY_CD = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT

 order by A.SEQ_NO, A.LINK_ITEM_CD, A.TERM_EXCS, A.EFF_START_DT
;