-- 근태코드기준
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
                    'PLD_ATTDGBN_CD'   -- 근태구분
                  , 'PLD_ATTDAPPL_CD'  -- 근무적용
                )
     )
select A.COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_ATTDGBN_CD'
              and CD_VAL     = A.ATTDGBN_CD
       ) as ATTDGBN_NM
     , A.ATTDGBN_CD
     , A.START_YMD
     , A.END_YMD
     , A.YY_SBTR_DDCNT
     , A.MM_SBTR_DDCNT
     , A.WEEKDD_SBTR_DDCNT
     , A.SAT_SBTR_DDCNT
     , A.HDAY_SBTR_DDCNT
     , A.LHDAY_SBTR_DDCNT
     , A.RQST_LIMIT_DDCNT
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_ATTDAPPL_CD'
              and CD_VAL     = A.WEEKDD_APPL_CD
       ) as WEEKDD_APPL_NM
     , A.WEEKDD_APPL_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_ATTDAPPL_CD'
              and CD_VAL     = A.SAT_APPL_CD
       ) as SAT_APPL_NM
     , A.SAT_APPL_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_ATTDAPPL_CD'
              and CD_VAL     = A.HDAY_APPL_CD
       ) as HDAY_APPL_NM
     , A.HDAY_APPL_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_ATTDAPPL_CD'
              and CD_VAL     = A.LHDAY_APPL_CD
       ) as LHDAY_APPL_CD
     , A.LHDAY_APPL_CD
     , A.BAKGRD_COLR
     , A.CHAR_COLR
     , A.WRK_YN
     , A.REAL_WRK_YN
     , A.PAYAPPL_YN
     , A.BNSAPPL_YN
     , A.PAYMT_YN
     , A.ALWC_WITH_YN       -- 수당포함여부 -> 사용안하는듯 > 입력란없음
     , A.ALWC_CNNT_CD       -- 수당포함여부 -> 사용안하는듯 > 입력란없음
     , A.CALCMODE_CD        -- 수당포함여부 -> 사용안하는듯 > 입력란없음
     , A.BASE_VAL           -- 사용안하는듯 > 입력란없음
     , A.CHRG_FD_PAY_YN     -- 사용안하는듯 > 입력란없음
     , A.INQ_YN
     , A.USE_YN
     , A.NOTE
  from TB_PL_DDDATTDBASE_M A

 where A.COMPANY_CD = 'DEVW'
;

-- 추가인정시간기준관리
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
                    'PLD_DAYWKGBN_CD'   -- 요일구분
                  , 'PLD_WRKGRP_CD'     -- 근무조
                  , 'PLD_WRKGRPGBN_CD'  -- 근무조구분
                )
     )
select 
       A.COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKGRP_CD'
              and CD_VAL     = A.WRKGRP_CD
       ) as WRKGRP_NM
     , A.WRKGRP_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_DAYWKGBN_CD'
              and CD_VAL     = A.DAY_WK_GBN_CD
       ) as DAY_WK_GBN_NM
     , A.DAY_WK_GBN_CD
     , A.START_YMD
     , A.END_YMD
     , A.HDAY_APPL_YN
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKGRPGBN_CD'
              and CD_VAL     = A.WRKGRP_GBN_CD
       ) as WRKGRP_GBN_CD
     , A.WRKGRP_GBN_CD
     , A.ALWC_CNNT_CD
     , A.CALCMODE_CD
     , A.BASE_VAL
     , A.APPL_TM
     , A.USE_YN
     , A.NOTE
  from TB_PL_DADDAPPRBASE_M A
 where A.COMPANY_CD = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD')
       between A.START_YMD and A.END_YMD
 order by A.WRKGRP_CD, A.DAY_WK_GBN_CD 
;

-- 근무조기준
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
                    'PLD_HDAYAPPLGBN_CD'-- 휴무인정구분
                  , 'PLD_WRKGRP_CD'     -- 근무조
                  , 'PLD_WRKGRPGBN_CD'  -- 근무조구분
                )
     )
select A.COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKGRP_CD'
              and CD_VAL     = A.WRKGRP_CD
       ) as WRKGRP_NM
     , A.WRKGRP_CD
     , A.START_YMD
     , A.END_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKGRPGBN_CD'
              and CD_VAL     = A.WRKGRP_GBN_CD
       ) as WRKGRP_GBN_NM
     , A.WRKGRP_GBN_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_HDAYAPPLGBN_CD'
              and CD_VAL     = A.HDAYAPPL_GBN_CD
       ) as HDAYAPPL_GBN_NM
     , A.HDAYAPPL_GBN_CD
     , A.USE_YN
     , A.NOTE
  from TB_PL_DWRKGRPBASE_M A
 where A.COMPANY_CD = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD')
       between A.START_YMD and A.END_YMD
;
-- 근무형태기준관리
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
                    'PLD_WRKTYPE_CD'    -- 근무형태
                  , 'PLD_ATTDGBN_CD'    -- 근태구분
                )
     )
select A.COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKTYPE_CD'
              and CD_VAL     = A.WRKTYPE_CD
       ) as WRKTYPE_NM
     , A.WRKTYPE_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_ATTDGBN_CD'
              and CD_VAL     = A.ATTD_GBN_CD
       ) as ATTD_GBN_CD
     , A.ATTD_GBN_CD
     , A.START_YMD
     , A.END_YMD
     , A.WRK_TYPE_SHRT_NM
     , A.START_TM
     , A.END_TM
     , A.LATE_STBL
     , A.MIDNIGHT_APPL
     , A.LATE_SBTR
     , A.LEAV_SBTR
     , A.CUT_UNIT
     , A.APPL_TM
     , A.BASE_TM
     , A.USE_YN
     , A.NOTE
  from TB_PL_DWRKTYPEBASE_M A
 where A.COMPANY_CD = 'DEVW'
;

-- 휴게시간기준
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
                    'PLD_WRKTYPE_CD'    -- 근무형태
                  , 'PLD_BRKTYPE_CD'    -- 휴계형태
                )
     )
select A.COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_WRKTYPE_CD'
              and CD_VAL     = A.WRKTYPE_CD
       ) as WRKTYPE_NM
     , A.WRKTYPE_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_BRKTYPE_CD'
              and CD_VAL     = A.BRKTYPE_CD
       ) as BRKTYPE_NM
     , A.BRKTYPE_CD
     , A.START_YMD
     , A.END_YMD
     , A.START_TM
     , A.END_TM
     , A.TOT_BRK_TM
     , A.SBTR_TM
     , A.USE_YN
     , A.NOTE
  from TB_PL_DBRKBASE_M A
 where A.COMPANY_CD = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD')
       between A.START_YMD and A.END_YMD
;

-- 월차기준관리
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
                    'PLD_PAYORACUM_CD'  -- 지급과누적구분코드(월차)
                  , 'PLD_APPLRANGE_CD'  -- 적용범위
                )
     )
select A.COMPANY_CD
     , A.START_YMD
     , A.END_YMD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_PAYORACUM_CD'
              and CD_VAL     = A.PAY_OR_ACUM_CD
       ) as PAY_OR_ACUM_NM
     , A.PAY_OR_ACUM_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLD_APPLRANGE_CD'
              and CD_VAL     = A.APPL_RANGE_CD
       ) as APPL_RANGE_NM
     , A.APPL_RANGE_CD
     , A.USE_YN
     , A.NOTE
  from TB_PL_DMONTHBASE_M A
 where A.COMPANY_CD = 'DEVW'
;



