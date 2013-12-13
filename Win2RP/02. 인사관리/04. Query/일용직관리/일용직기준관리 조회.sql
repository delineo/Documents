/* 일용직기준관리 */

-- 일용직관리 분류 코드 목록
select * from TB_PL_SSTD_M
 where COMPANY_CD  = 'DEVW'
   and BSNS_TYPE_CD= 'PLV'
;

-- COMPVPAYCD              회사별 일용직 급여설정
-- CRTE_EMPNO	           일용직 사번 채번 시작 번호
-- LNG_RCUP_SBTREXEM_RATE  장기요양감면요율
-- VEARN_INCM_SET          근로소득신고기초자료셋팅
-- VEMPATTDST              근태연장기준설정관리

select * from TB_PL_SSTD_D 
 where COMPANY_CD  = 'DEVW' 
   and BSNS_STD_CD = 'COMPVPAYCD'
;

select * from TB_CM_CODE_VALUE
 where COMPANY_CD  = 'DEVW'
   and CLASS_CD    = 'PLS_BSNS_TYPE_CD'
;

select * from TB_CM_CODE_VALUE
 where COMPANY_CD  = 'DEVW'
   and CLASS_CD    = 'PLS_UNIT_CD'
;