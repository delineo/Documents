-- 근로소득공제
-- 귀속년도 2013년도 기준이 변경됨 (2013년 8월 개정됨)
select 
       A.COMPANY_CD                       /* 회사코드       */
     , A.GBN_CD                           /* 구분코드       */
     , A.EFF_START_DT                     /* 유효시작일     */
     , A.EFF_END_DT                       /* 유효종료일     */
     , A.TERM_EXCS                        /* 초과금액       */
     , A.TERM_DOWN                        /* 미만금액       */
     , A.UP_LMIT_AMT                      /* 공제기준액     */
     , A.CO_RATE                          /* 공제율         */
     , A.GRDUL_SBTR_AMT                   /* 누진공제금액   */
     , A.EXCS_LMIT_AMT                    /* 초과기준금액   */
     , A.DDUCT_LMIT_AMT                   /* 공제한도금액   */
     , A.REMARKS                          /* 비고           */
  from TB_PL_SINCM_DDUCT A
 where A.COMPANY_CD = 'DEVW'
   and A.GBN_CD     = '01' -- 01:급여-근로소득공제, 02:급여-근로소득세액공제, 03:퇴직금-근로소득공제, 04:퇴직금-근로소득세액공제
   
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT

 order by A.TERM_EXCS
;

-- 근로소득세액공제
select 
       A.COMPANY_CD                       /* 회사코드       */
     , A.GBN_CD                           /* 구분코드       */
     , A.EFF_START_DT                     /* 유효시작일     */
     , A.EFF_END_DT                       /* 유효종료일     */
     , A.TERM_EXCS                        /* 초과금액       */
     , A.TERM_DOWN                        /* 미만금액       */
--     , A.UP_LMIT_AMT                      /* 공제기준액     */
     , A.GRDUL_SBTR_AMT                   /* 누진공제금액   */
     , A.EXCS_LMIT_AMT                    /* 초과기준금액   */
     , A.CO_RATE                          /* 공제율         */
     , A.DDUCT_LMIT_AMT                   /* 공제한도금액   */
--     , A.REMARKS                          /* 비고           */
  from TB_PL_SINCM_DDUCT A
 where A.COMPANY_CD = 'DEVW'
   and A.GBN_CD     = '02' -- 01:급여-근로소득공제, 02:급여-근로소득세액공제, 03:퇴직금-근로소득공제, 04:퇴직금-근로소득세액공제
   
   and to_char(sysdate, 'YYYYMMDD')
       between A.EFF_START_DT and A.EFF_END_DT
 order by A.TERM_EXCS