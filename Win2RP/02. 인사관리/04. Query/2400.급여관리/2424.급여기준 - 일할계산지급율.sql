-- 일할계산 항목
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
                    'PLS_TENPRO_GROUP_CD'   -- 일할기준그룹
                  , 'PLS_TENPRO_APPL_CD'    -- 일할적용코드

                    -- 일할구분 선택에 따라서 
                  , 'PLD_ATTDGBN_CD'        -- 근태 : 근태대분류코드
                  , 'PLH_PUN_CD'            -- 징계 : 징계유형  코드
                  , 'PLA_APPODTL_CD'        -- 휴직 : 발령세부  코드 중 Attribute1 값이 100 인 항목 
                  , 'PLA_APPOGRP_CD'        -- 발령 : 발령구분  코드
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
              and CLASS_CD   = 'PLS_TENPRO_GROUP_CD'
              and CD_VAL     = A.TENPRO_GROUP_CD
       ) as TENPRO_GROUP_NM
     , A.TENPRO_GROUP_CD                /* 일할기준그룹         */
     , decode
       (   -- 프로그램내부에 요롷게 정의되어 있음
           A.TENPRO_GROUP_CD
         , 'WRK', 'PLD_ATTDGBN_CD'  -- 근태 : 근태대분류코드
         , 'DIS', 'PLH_PUN_CD'      -- 징계 : 징계유형  코드
         , 'ABS', 'PLA_APPODTL_CD'  -- 휴직 : 발령세부  코드 중 Attribute1 값이 100 인 항목 
         , 'APP', 'PLA_APPOGRP_CD'  -- 발령 : 발령구분  코드
       ) as LINK_ITEM_CD                /* 연계코드(CLASS_CD 임)*/
     , A.TENPRO_TYPE_NM                 /* 일할기준명           */ -- 다음 일할기준코드와 다른것임.
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = A.LINK_ITEM_CD
              and CD_VAL     = A.TENPRO_TYPE_CD
       ) as TENPRO_TYPE_CD_NM
     , A.TENPRO_TYPE_CD                 /* 일할기준코드         */
--     , A.GROUP_YN                       /* 그룹여부             */
--     , A.LINK_ITEM_CD                   /* 연계코드             */
     , A.MM_DD_GB                       /* 일월구분             */
     , A.TERM_EXCS                      /* 초과                 */
     , A.TERM_DOWN                      /* 이하                 */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_TENPRO_APPL_CD'
              and CD_VAL     = A.PAY_TENPRO_APPL_CD
       ) as PAY_TENPRO_APPL_NM
     , A.PAY_TENPRO_APPL_CD             /* 급여_일할적용코드    */
     , A.PAY_RATE                       /* 급여_지급율          */
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_TENPRO_APPL_CD'
              and CD_VAL     = A.BNUS_TENPRO_APPL_CD
       ) as BNUS_TENPRO_APPL_NM
     , A.BNUS_TENPRO_APPL_CD            /* 상여_일할적용코드    */
     , A.BNUS_RATE                      /* 상여_지급율          */
     , A.CALC_SEQ_NO                    /* 우선순위(계산순서)   */
  from TB_PL_STENPROWRK_D A
  ,(
       select C.CLASS_CD,
              C.CLASS_CD_VALUE,
              D.META_ITEM_DESC
         from TB_CM_CODE_VALUE C, TB_CM_LANGUAGE_PACK D
        where C.LANGUAGE_PACK_ID = D.MGMT_OBJECT_ID
          and C.USE_YN      = 'Y'

          and C.COMPANY_CD  = 'DEVW'
          and D.LANGUAGE_CD = 'ko'
   ) B
 where A.LINK_ITEM_CD   = B.CLASS_CD(+)
   and A.TENPRO_TYPE_CD = B.CLASS_CD_VALUE(+)
   and A.COMPANY_CD     = 'DEVW'
   and to_char(sysdate, 'YYYYMMDD') 
       between A.EFF_START_DT and A.EFF_END_DT
 
 order by A.CALC_SEQ_NO, A.TENPRO_GROUP_CD, A.TENPRO_TYPE_CD, A.EFF_START_DT