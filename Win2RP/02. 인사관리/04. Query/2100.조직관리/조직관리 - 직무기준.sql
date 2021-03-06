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
            and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD        in 
                (
                    'PLH_JOBDUTY_CD'    -- 직무코드
                )
     )
select 
       A.COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLH_JOBDUTY_CD'
              and CD_VAL     = A.JOBDUTY_CD
       ) as JOBDUTY_CD
     , A.JOBDUTY_CD
     , A.START_YMD
     , A.END_YMD
     , A.DUTY_BASE_DESC
     , A.NOTE
  from TB_PL_OJOBDUTYBASE_M A
 where 1=1
   and A.COMPANY_CD = 'DEVW'
;

