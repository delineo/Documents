-- 건강보험요율
select
       A.COMPANY_CD                    /* 회사코드    */
     , A.EFF_START_DT                  /* 유효시작일  */
     , A.EFF_END_DT                    /* 유효종료일  */
     , A.STD_YEAR                      /* 기준연도    */
     , A.SELF_RATE                     /* 개인보험율  */
     , A.CO_RATE                       /* 회사보험율  */
     , A.RCUP_INSU_RATE                /* 요양보험율  */
     , A.UP_LMIT_AMT                   /* 최저한도    */
     , A.FL_LMIT_AMT                   /* 최고한도    */
     , A.REMARKS                       /* 비고        */
  from TB_PL_IHLTH_INSU_RATE A
 where A.COMPANY_CD     = 'DEVW'
