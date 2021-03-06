-- 계정과목 조회
select A.STD_ID
     , A.COL1_VAL                       -- 사업장코드
     , A.COL2_VAL   as JOBGBN_CD        -- 업무구분
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLH_JOBGBN_CD'
         , A.COL2_VAL    , 'ko'
       )            as JOBGBN_CD_NM     -- 업무구분명
     , A.COL3_VAL   as FIA_COST_TP      -- 사업구분
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'FIA_COST_TP'
         , A.COL3_VAL    , 'ko'
       )            as FIA_COST_TP_NM   -- 사업구분명
     , A.COL4_VAL   as FIA_COLL_TP      -- 협력구분
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'FIA_COLL_TP'
         , A.COL4_VAL    , 'ko'
       )            as FIA_COLL_TP_NM   -- 협력구분명
     , A.REMARKS                        -- 비고
  from TB_PL_SSTD_D A
 where A.COMPANY_CD  = 'DEVW'
   and A.BSNS_STD_CD = 'PAY_FI_INTERFACE'
;

-- 계정과목 관리 테이블 컬럼명 조회
select * 
  from TB_PL_SSTD_FIXN_M
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'PAY_FI_INTERFACE' -- 업무기준코드
;

select * from TB_PL_FI_INTERFACE_MAIN
;

POSSCM.P_PL_FI_INTERFACE_SUM