-- 경조금기준 목록 조회
select COMPANY_CD
     , CAC_GBN_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_CAC_KIND_CD'
         , A.CAC_GBN_CD  , 'ko'
       ) as CAC_GBN_NM         -- 경조사구분명
     
     , FAM_REL_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLH_FAMREL_CD'
         , A.FAM_REL_CD  , 'ko'
       ) as FAM_REL_NM         -- 가족관계
     , START_YMD
     , END_YMD
     , CAC_AMT
     , CAC_AMT_ALWC_YN
     , CAC_AMT_SBTR_YN
     , CAC_GDS_AMT
     , CAC_GDS_ALWC_YN
     , CAC_GDS_SBTR_YN
     , CAC_WRTH_AMT
     , CAC_WRTH_ALWC_YN
     , CAC_WRTH_SBTR_YN
     , CAC_VACA_DD_CNT
     , CAC_VACA_HDAY_YN
     , REMARKS
  from TB_PL_WCAC_STD_M A
 where COMPANY_CD = 'DEVW'
;

-- 대출기준(대출종류별 기준) 목록조회
select A.BSNS_STD_CD                -- 업무구분코드('LEND_STD' 고정)
     , A.STD_ID                     -- 기준구분코드
     , A.COL1_VAL
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_LEND_KIND_CD'
         , A.COL1_VAL    , 'ko'
       ) as LEND_KIND_NM            -- 대출종류
     , A.COL2_VAL
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_LEND_TYPE_CD'
         , A.COL2_VAL    , 'ko'
       ) as LEND_TYPE_NM            -- 대출구분
     , A.COL3_VAL                   -- 근속월수( ~이상) => 대출가능기준
     , A.COL4_VAL                   -- 대출한도
     , A.COL5_VAL                   -- 거치년수
     , A.COL6_VAL                   -- 연이률(%)
     , A.COL7_VAL                   -- 상환방법콛,
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_INTR_MTHD'
         , A.COL2_VAL    , 'ko'
       ) as INTR_MTHD_NM            -- 상환방법명
     , A.COL8_VAL                   -- 상환한도월수(대출기간한도)
     , A.COL9_VAL                   -- 잔액처리기준코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_RMDR_PROC_CD'
         , A.COL9_VAL    , 'ko'
       ) as RMDR_PROC_NM            -- 잔액처리기준명
     , A.COL10_VAL                  -- 이자계산시작구분코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_LEND_INTR_CAL_CD'
         , A.COL10_VAL    , 'ko'
       ) as LEND_INTR_CAL_NM        -- 이자계산시작구분명
     , A.COL11_VAL                  -- 이자계산시작일
     , A.COL12_VAL                  -- 이자일수계산구분코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLW_LEND_INTRDAY_CAL_GBN'
         , A.COL12_VAL    , 'ko'
       ) as INTRDAY_CAL_GBN_NM      -- 이자계산시작구분명
     , A.COL14_VAL                  -- 중도상환가능여부
     , A.COL15_VAL                  -- 필수서류
     , A.EFF_START_DT               -- 유효시작일
     , A.EFF_END_DT                 -- 유효완료일
  from TB_PL_SSTD_D A
 where A.COMPANY_CD = 'DEVW'
   and A.BSNS_STD_CD= 'LEND_STD'
;


-- 학자금지급기준 목록조회
select A.BSNS_STD_CD                -- 업무구분코드('LEND_STD' 고정)
     , A.STD_ID                     -- 기준구분코드
     , A.COL1_VAL                   -- 학교코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLH_SCH_CD'
         , A.COL1_VAL    , 'ko'
       ) as LEND_KIND_NM            -- 학교명
     , A.COL2_VAL                   -- 지급기준
     , A.EFF_START_DT               -- 유효시작일
     , A.EFF_END_DT                 -- 유효완료일
  from TB_PL_SSTD_D A
 where A.COMPANY_CD = 'DEVW'
   and A.BSNS_STD_CD= 'SHCL_BASE_CNT'
;

select * from TB_PL_WLEND_M