-- Pivot 테이블 형식으로 만들어보자~~~ ㅠㅠ

-- 호봉코드관리
select * 
  from TB_PL_SPAYTB_C
 where COMPANY_CD = 'DEVW'
;

select * 
  from TB_PL_SPAYTB_D
 where COMPANY_CD = 'PHAL'
;

-- 호봉변경내역 => 반영시점별 이력관리함.
select *
  from TB_PL_SPAYTB_H
;