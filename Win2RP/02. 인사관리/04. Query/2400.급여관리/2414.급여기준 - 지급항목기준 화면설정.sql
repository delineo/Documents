-- 지급항목기준 화면설정
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
                    'PLS_ITEM_KIND_CD' -- 소득공제구분
                  , 'PLS_TYPE_GBN_CD'  -- 유형구분
                  , 'PLS_PAY_GROUP_CD' -- 적용그룹코드
                  , 'PLS_PAY_INTVL_CD' -- 지급주기
                  , 'PLS_UNIT_CD'      -- 소수처리단위
                  , 'PLS_DML_PROC_CD'  -- 소수처리방법
                )
     )
select A.COMPANY_CD                  -- 회사코드
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_ITEM_KIND_CD'
              and CD_VAL     = A.ITEM_KIND_CD
       ) as ITEM_KIND_NM
     , A.ITEM_KIND_CD                -- 소득공제구분(01:지급, 02:공제, 03:상여)
     , A.ITEM_CD_HAN                 -- 수당명
     , A.ITEM_CD                     -- 수당코드
     --, A.ITEM_CD_ENG                 -- 소득공제코드영문명 <--화면에 표시되어있지 않고, 사용하지 않는듯.
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_TYPE_GBN_CD'
              and CD_VAL     = A.TYPE_GBN_CD
       ) as TYPE_GBN_NM              -- 유형구분명
     , A.TYPE_GBN_CD                 -- 유형구분
     , A.CALC_SEQ_NO                 -- 계산순서
     , A.PRNT_SEQ_NO                 -- 대장순서(출력순서)
     , A.TAX_YN                      -- 과세여부
     , A.TAX_FREE_LIMIT_AMT          -- 비과세한도금액(원)
     , A.BASE_PAY_YN                 -- 기본급여여부
     , A.STD_PAY_YN                  -- 기준급여여부
     , A.ODRY_WAGE_YN                -- 통상임금포함여부
--     , A.ATTN_YN                     -- 근태여부
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_PAY_INTVL_CD'
              and CD_VAL     = A.PAY_INTVL_CD
       ) as PAY_INTVL_NM             -- 지급주기명
     , A.PAY_INTVL_CD                -- 지급주기
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_UNIT_CD'
              and CD_VAL     = A.UNIT_CD
       ) as UNIT_NM                  -- 소수처리단위
     , A.UNIT_CD                     -- 소수처리단위코드
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_DML_PROC_CD'
              and CD_VAL     = A.DML_PROC_CD
       ) as DML_PROC_NM              -- 소수처리방법
     , A.DML_PROC_CD                 -- 소수처리방법코드
     , A.RETR_YN                     -- 소급가능여부
     , A.PRNT_NM                     -- 출력명칭
     , A.TRNS_ACCTOUNT_YN            -- 이체여부
     , A.EMPL_INSU_YN                -- 고용보험여부
     , A.HLTH_INSU_YN                -- 건강보험여부
     , A.NAT_PENS_YN                 -- 국민연금여부
     , A.UN_DUES_YN                  -- 노조비여부
     , A.TENPRO_YN                   -- 일할적용여부
     , A.AVG_WAGE_AMT_YN             -- 평균임금여부
     , A.PRDT_TAX_FREE_YN            -- 생산직비과세여부
     , A.ATTCH_YN                    -- 압류여부
     , A.BNUS_YN                     -- 상여여부
     , A.CONT_YN                     -- 계약여부
     , A.ETC1_YN                     -- 기타1_급여외항목여부
     , A.ETC2_YN                     -- 기타2_퇴직시지급여부
--     , A.ETC3_YN                     -- 기타3 <-- 화면에 없음
     , A.EMPLOY_BF_DT                -- 입사전적용일자
     , A.EMPLOY_AF_DT                -- 입사후적용일자

     , A.EFF_START_DT                -- 유효시작일
     , A.EFF_END_DT                  -- 유효종료일
     , A.USE_YN                      -- 사용여부

/* 화면에 표시되지 않는 항목임. 요곤 다른 화면에서 사용하는 항목인듯.... 오데서??
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_PAY_GROUP_CD'
              and CD_VAL     = A.PAY_GROUP_CD
       ) as PAY_GROUP_NM
     , A.PAY_GROUP_CD                -- 적용그룹코드     <-- 사용하는거이야??
     , A.MAIN_SET_CD                 -- 주설정코드
     , A.CALC_MODE_CD                -- 계산방식코드
     , A.STD_AMT                     -- 기준금액
     , A.STD_RATE                    -- 기준비율
     , A.SEQ_NO                      -- 디스플레이순서
     , A.YY_END_ADJST_MAPP_CD        -- 연말정산매핑코드 <-- 데이터로 봐서는 소득공제코드임.
     , A.CALC_USES_YN                -- 산식사용여부
     , A.ATTN_YN                     -- 근태여부
     , A.REMARKS                     -- 비고
     , A.PRNT_MAPP1_CD               -- 출력매핑코드1    <-- 급여항목출력맵핑 화면에서 설정( 급여명세서 출력시 표시명칭 )
     , A.PRNT_MAPP2_CD               -- 출력매핑코드2    <-- 급여항목출력맵핑 화면에서 설정( 급여대장   출력시 표시명칭 )
     , A.SYS_MAPP_CD                 -- 시스템매핑코드   <-- 급여항목출력맵핑 화면에서 설정( 시스템???         표시명칭 )
     , A.PRNT_MAPP3_CD               -- 임시컬럼
--*/
     , B.M01_DTL_NM,    B.M01_DTL_CD,   B.M01_SCR_ID,   B.M01_SEQ_NO
     , B.M02_DTL_NM,    B.M02_DTL_CD,   B.M02_SCR_ID,   B.M02_SEQ_NO
     , B.E01_DTL_NM,    B.E01_DTL_CD,   B.E01_SCR_ID,   B.E01_SEQ_NO
     , B.E02_DTL_NM,    B.E02_DTL_CD,   B.E02_SCR_ID,   B.E02_SEQ_NO
  from TB_PL_SPAYBASE_C A
  ,(
       select COMPANY_CD
            , ITEM_CD

            , max(decode(RID, 1, DTL_SET_CD)) as M01_DTL_CD
            , max(decode(RID, 1, DTL_SET_NM)) as M01_DTL_NM
            , max(decode(RID, 1, COL3_VAL  )) as M01_SCR_ID
            , max(decode(RID, 1, SEQ_NO    )) as M01_SEQ_NO

            , max(decode(RID, 2, DTL_SET_CD)) as M02_DTL_CD
            , max(decode(RID, 2, DTL_SET_NM)) as M02_DTL_NM
            , max(decode(RID, 2, COL3_VAL  )) as M02_SCR_ID
            , max(decode(RID, 2, SEQ_NO    )) as M02_SEQ_NO

            , max(decode(RID, 3, DTL_SET_CD)) as E01_DTL_CD
            , max(decode(RID, 3, DTL_SET_NM)) as E01_DTL_NM
            , max(decode(RID, 3, COL3_VAL  )) as E01_SCR_ID
            , max(decode(RID, 3, SEQ_NO    )) as E01_SEQ_NO
             -- 사용하지 않는듯
            , max(decode(RID, 4, DTL_SET_CD)) as E02_DTL_CD
            , max(decode(RID, 4, DTL_SET_NM)) as E02_DTL_NM
            , max(decode(RID, 4, COL3_VAL  )) as E02_SCR_ID
            , max(decode(RID, 4, SEQ_NO    )) as E02_SEQ_NO
             -- 사용하지 않는듯
         from
          (
              select row_number() over
                     (
                         partition by A.COMPANY_CD, A.ITEM_CD
                             order by A.COMPANY_CD, A.ITEM_CD, A.SEQ_NO
                     ) as RID
                   , A.COMPANY_CD
                   , A.ITEM_CD
                   , A.DTL_SET_CD
                   , A.DTL_SET_NM
                   , A.SEQ_NO
                   , B.COL1_VAL, B.COL2_VAL, B.COL3_VAL, B.COL4_VAL, B.COL5_VAL
                from TB_PL_SPAYBASE_D A
                ,    TB_PL_SSTD_D     B
               where A.COMPANY_CD = B.COMPANY_CD(+)
                 and A.DTL_SET_CD = B.STD_ID(+)
                 --and A.COMPANY_CD = 'DEVW'
                 and to_char(sysdate, 'YYYYMMDD')
                     between A.EFF_START_DT and A.END_YMD
                 and to_char(sysdate, 'YYYYMMDD')
                     between B.EFF_START_DT and B.EFF_END_DT
                 and B.BSNS_STD_CD(+) = 'PAY_BASE_CD'
                 and B.COL2_VAL(+)    = 'MAIN'
              union
              select row_number() over
                     (
                         partition by A.COMPANY_CD, A.ITEM_CD
                             order by A.COMPANY_CD, A.ITEM_CD, A.SEQ_NO
                           
                     ) + 2 as RID
                   , A.COMPANY_CD
                   , A.ITEM_CD
                   , A.DTL_SET_CD
                   , A.DTL_SET_NM
                   , A.SEQ_NO
                   , B.COL1_VAL, B.COL2_VAL, B.COL3_VAL, B.COL4_VAL, B.COL5_VAL
                from TB_PL_SPAYBASE_D A
                ,    TB_PL_SSTD_D     B
               where A.COMPANY_CD = B.COMPANY_CD(+)
                 and A.DTL_SET_CD = B.STD_ID(+)
                 --and A.COMPANY_CD = 'DEVW'
                 and to_char(sysdate, 'YYYYMMDD')
                     between A.EFF_START_DT and A.END_YMD
                 and to_char(sysdate, 'YYYYMMDD')
                     between B.EFF_START_DT and B.EFF_END_DT
                 and B.BSNS_STD_CD(+) = 'PAY_BASE_CD'
                 and B.COL2_VAL(+)    = 'EXCP'
          )
        group by COMPANY_CD, ITEM_CD
   ) B
 where A.COMPANY_CD   = B.COMPANY_CD(+)
   and A.ITEM_CD      = B.ITEM_CD(+)
   and A.ITEM_KIND_CD = '01' -- 지급
   and A.COMPANY_CD   = 'DEVW'
 
 order by A.ITEM_KIND_CD, A.ITEM_CD
;
