-- 퇴직금환경 (마스터정보는 일단 제외한다.)
select A.COMPANY_CD
     , A.BSNS_STD_CD
     , A.STD_ID
     , A.EFF_START_DT
     , A.EFF_END_DT
     , A.COL1_VAL
     , A.COL2_VAL
     , A.COL3_VAL
     , A.COL4_VAL
     , A.COL5_VAL
     , '' as REMARK
  from TB_PL_SSTD_D A
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'RETI_STD_CD'
;

-- 퇴직금기준관리 목록
select * from TB_PL_SSTD_M A
 where A.COMPANY_CD   = 'DEVW'
   and A.BSNS_TYPE_CD = 'PLR'
   and A.SYS_CD_YN    = 'N'
;

-- 임원퇴직금 누진율관리
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
                    'PLH_JOBGRD_CD'         -- 직급
                )
     )
select A.COMPANY_CD
     , A.BSNS_STD_CD
     , A.STD_ID
     , A.EFF_START_DT
     , A.EFF_END_DT
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CD_VAL     = A.COL1_VAL
       ) as JOBGRD_NM
     , A.COL1_VAL       -- 직급코드
     , A.COL2_VAL       -- 누진률/누진일
     , '' as REMARK
  from TB_PL_SSTD_D A
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'RETI_BRD_MBER_STD'
;

-- 퇴직보험사정보
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
select A.COMPANY_CD
     , A.BSNS_STD_CD
     , A.STD_ID
     , A.EFF_START_DT
     , A.EFF_END_DT
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CD_VAL     = A.COL1_VAL
       ) as JOBGRD_NM
     , A.COL1_VAL       -- 퇴직연금사업자코드
     , A.COL2_VAL       -- 사업자등록번호
     , '' as REMARK
  from TB_PL_SSTD_D A
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'RETI_INSU_CORP'
;

-- 퇴직소득공제기준
select 
       A.COMPANY_CD                       /* 회사코드       */
     , A.GBN_CD                           /* 구분코드       */
     , A.EFF_START_DT                     /* 유효시작일     */
     , A.EFF_END_DT                       /* 유효종료일     */
     , A.TERM_EXCS                        /* 초과금액       */
     , A.TERM_DOWN                        /* 미만금액       */
     , A.UP_LMIT_AMT                      /* 기본공제액     */
--     , A.CO_RATE                          /* 공제율         */
--     , A.GRDUL_SBTR_AMT                   /* 누진공제금액   */
--     , A.EXCS_LMIT_AMT                    /* 초과기준금액   */
     , A.DDUCT_LMIT_AMT                   /* 최대금액       */
     , A.REMARKS                          /* 비고           */
  from TB_PL_SINCM_DDUCT A
 where A.COMPANY_CD = 'DEVW'
   and A.GBN_CD     = '03' -- 01:급여-근로소득공제, 02:급여-근로소득세액공제, 03:퇴직금-퇴직소득공제, 04:퇴직금-퇴딕소득세율
   
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT

 order by A.TERM_EXCS
;

-- 퇴직소득세율
select 
       A.COMPANY_CD                       /* 회사코드       */
     , A.GBN_CD                           /* 구분코드       */
     , A.EFF_START_DT                     /* 유효시작일     */
     , A.EFF_END_DT                       /* 유효종료일     */
     , A.TERM_EXCS                        /* 초과금액       */
     , A.TERM_DOWN                        /* 미만금액       */
--     , A.UP_LMIT_AMT                      /* 기본공제액     */
     , A.CO_RATE                          /* 공제율         */
--     , A.GRDUL_SBTR_AMT                   /* 누진공제금액   */
--     , A.EXCS_LMIT_AMT                    /* 초과기준금액   */
     , A.DDUCT_LMIT_AMT                   /* 최대금액       */
     , A.REMARKS                          /* 비고           */
  from TB_PL_SINCM_DDUCT A
 where A.COMPANY_CD = 'DEVW'
   and A.GBN_CD     = '04' -- 01:급여-근로소득공제, 02:급여-근로소득세액공제, 03:퇴직금-퇴직소득공제, 04:퇴직금-퇴딕소득세율
   
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT

 order by A.TERM_EXCS
;
