-- 지급항목(수당)별/호봉별 지급기준
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
                    'PLS_CALC_MODE_CD' -- 계산방식
                  , 'PLS_PAY_ITEM_CD'  -- 개인별 기준급여항목
                )
     )
select
       A.COMPANY_CD                     /* 회사코드            */
     , A.ITEM_CD                        /* 소득공제코드        */
     , A.EFF_START_DT                   /* 유효시작일          */
     , A.DTL_SET_CD                     /* 상세설정코드        */
     , A.START_DT                       /* 적용시작일          */
     , A.END_YMD                        /* 적용종료일          */
     , B.STEP_NM                        /* 호봉명              */
     , A.MAIN_SET_CD                    /* 호봉코드            */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_CALC_MODE_CD'
              and CD_VAL     = A.CALC_MODE_CD
       ) as CALC_MODE_NM     
     , A.CALC_MODE_CD                   /* 계산방식코드        */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_PAY_ITEM_CD'
              and CD_VAL     = A.PAY_ITEM_CD
       ) as PAY_ITEM_NM     
     , A.PAY_ITEM_CD                    /* 급여항목코드        */
--     , A.BASE_TIME_CNT                  /* 기준시간            */
     , A.STD_AMT                        /* 기준금액            */
     , A.STD_RATE                       /* 기준비율            */
     , A.ADD_AMT                        /* 가산금액            */
     , A.CALC_TXT                       /* 계산수식            */
     , A.REMARKS                        /* 비고                */
--     , A.TIME_CALC_TXT                  /* 시간고정산식        */
--     , A.ETC_SET1_CD                    /* 기타설정1           */
--     , A.STD_ETC1_AMT                   /* 기타설정1금액       */
--     , A.STD_ETC1_RATE                  /* 기타설정1비율       */
--     , A.ETC_SET2_CD                    /* 기타설정2           */
--     , A.STD_ETC2_AMT                   /* 기타설정2금액       */
--     , A.STD_ETC2_RATE                  /* 기타설정2비율       */
  from TB_PL_SDTLCOMN_C A
  ,    TB_PL_SPAYTB_C   B
 where 1=1
   and A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.STEP_CD(+)
   and A.DTL_SET_CD  = 'STEP_CD'
   and A.EFF_START_DT= '19000101'
   and A.COMPANY_CD  = 'DEVW'
   and A.ITEM_CD = 'S240'
   and to_char(sysdate, 'YYYYMMDD')
       between B.EFF_START_DT and B.EFF_END_DT