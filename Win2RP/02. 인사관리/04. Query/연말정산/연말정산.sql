-- 연말정산

-- 근로소득 공제기준
select * 
  from TB_PL_YBASESBTR A
 where A.COMPANY_CD = 'DEVW'
 order by STTL_YY, SEQ_NO
;

select * from TB_PL_YBFWRKPLC;