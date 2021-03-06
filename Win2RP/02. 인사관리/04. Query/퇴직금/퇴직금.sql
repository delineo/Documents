-- 퇴직금계산방법
select *
  from TB_PL_SSTD_D
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'RETI_STD_CD'
   and STD_ID      = 'RSTD17'
;
select * from TB_CM_CODE_VALUE
 where COMPANY_CD = 'DEVW'
   and CLASS_CD= 'RETI_BRD_MBER_STD'
;
/* 퇴직소득공제 기준 항목 조회 */
select * 
  from TB_PL_SINCM_DDUCT
 where COMPANY_CD = 'DEVW'
   and GBN_CD     = '03' -- 퇴직소득공제
;

/* 퇴직소득세율 기준 항목 조회 */
select * 
  from TB_PL_SINCM_DDUCT
 where COMPANY_CD = 'DEVW'
   and GBN_CD     = '04' -- 퇴직소득세율
;

