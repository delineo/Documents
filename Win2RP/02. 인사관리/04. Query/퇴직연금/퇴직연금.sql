-- 퇴직연금 보험사 목록 조회
select * 
  from TB_PL_SSTD_D
 where COMPANY_CD = 'DEVW'
   and BSNS_STD_CD = 'PLR_INSU_COPR_CD'
;


select * 
  from TB_PL_SSTD_FIXN_M
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'PLR_INSU_COPR_CD' -- 업무기준코드
;

select * from TB_SM_SCREEN
