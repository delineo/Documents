-- 년차발생기준
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
                    'PLD_APPLRANGE_CD' -- 적용범위코드 (1년미만근속자생성범위코드)
                  , 'PLS_DML_PROC_CD'  -- 소수처리코드 (근속년수계산소수처리코드)
                )
     )
select A.COMPANY_CD                  -- 회사코드
     , A.BASE_YY                     -- 기준년도 -->  별의미가 없는듯. 년도별로 관리하기위한 항목인듯 함.
     , A.START_YMD                   -- 적용시작일자
     , A.END_YMD                     -- 적용종료일자
     , A.OCUR_DDCNT                  -- 최초발생일수
     , A.DUTY_USE_DDCNT	             -- 의무사용일수
     , A.PAY_APPR_DDCNT              -- 수당최대인정일수
     , A.ADD_BASE_YYCNT              -- 연차증가기준년수
     , A.ADD_BASE_DDCNT              -- 연차증가기준일수
     , A.MAX_OCUR_DDCNT	             -- 최대발생일수
     , decode
       (
           A.FRONT_REAR_GBN
         , 1, '선연차사용'
         , 2, '후연차사용'
       ) as FRONT_REAR_NM
     , A.FRONT_REAR_GBN              -- 선후연차_구분
     , decode
       (
           A.STTL_TP
         , 1, '기산일'
         , 2, '회계년도'
       ) as STTL_NM
     , A.STTL_TP                     -- 연차정산구분
     , A.ACUNTBASE_YMD               -- 회계년도기준일
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_APPLRANGE_CD'
              and CD_VAL     = A.ONE_YYMIN_RANGE_CD
       ) as ONE_YYMIN_RANGE_NM
     , A.ONE_YYMIN_RANGE_CD          -- 1년미만근속자생성범위코드
     , A.ONE_YYMIN_GOWRK_RATE        -- 1년미만근속자연단위연차생성출근율
     , A.CARR_FWRD_MAX_DDCNT         -- 이월최대일수
     , A.MAX_ADDUSE_DDCNT            -- 최대추가사용일수
     , A.REST_COMP_USE_YN            -- 잔여일수제한여부
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_DML_PROC_CD'
              and CD_VAL     = A.DML_PROC_CD
       ) as DML_PROC_NM
     , A.DML_PROC_CD                 -- 근속년수계산소수처리코드
     , A.FIX_LBR_DDCNT               -- 소정근로일수
     , A.MAILUSE_YN                  -- 연차사용알림메일_여부
     , A.MAILUSE_MM                  -- 연차사용알림메일기간
     , A.MAILUSE_CTNT                -- 연차사용알림메일내용
     , A.USE_YN                      -- 사용여부
     , A.NOTE                        -- 비고
       
  from TB_PL_DYEARBASE_M A
 where A.COMPANY_CD = 'DEVW'
;

-- 연차감산기준
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
                    'PLS_CALC_MODE_CD' -- 계산방식코드 (감산적용방법코드)
                  , 'PLS_DML_PROC_CD'  -- 소수처리코드 (근속년수계산소수처리코드)
                )
     )
select 
       A.COMPANY_CD                     /* 회사코드            */
     , A.BASE_YY                        /* 기준년도            */
     , A.START_YMD                      /* 적용시작일자        */
     , A.END_YMD                        /* 적용종료일자        */
     , A.GOWRK_RATE_FR                  /* 출근율FR            */
     , A.GOWRK_RATE_TO                  /* 출근율TO            */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_CALC_MODE_CD'
              and CD_VAL     = A.CALCMODE_CD
       ) as CALCMODE_NM
     , A.CALCMODE_CD                    /* 감산적용방법코드    */
     , A.BASE_VAL                       /* 감산적용값          */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_DML_PROC_CD'
              and CD_VAL     = A.DML_PROC_CD
       ) as DML_PROC_NM
     , A.DML_PROC_CD                    /* 소수처리코드        */
     , A.USE_YN                         /* 사용여부            */
     , A.NOTE                           /* 비고                */
  from TB_PL_DYEARMINUSBASE_M A
 where 1=1
   and A.COMPANY_CD = 'DEVW'
 order by A.BASE_YY, A.GOWRK_RATE_FR, A.START_YMD desc
;

