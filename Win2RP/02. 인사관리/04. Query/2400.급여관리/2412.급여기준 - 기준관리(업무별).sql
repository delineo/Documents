-- 업무별기준항목 조회
select A.BSNS_TYPE_CD       -- 유형코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLS_BSNS_TYPE_CD'
         , A.BSNS_TYPE_CD, 'ko'
       ) as TYPE_NM         -- 유형명
     , A.BSNS_STD_CD        -- 업무별기준코드
     , A.BSNS_TYPE_NM       -- 기준분류명
     , A.SYS_CD_YN          -- 시스템코드여부
     , A.USE_YN
  from TB_PL_SSTD_M A
 where 1=1
   and A.COMPANY_CD = 'DEVW'
 
 order by A.BSNS_TYPE_CD, A.BSNS_STD_CD
;

-- 업무별기준항목 상세 조회
select A.BSNS_TYPE_CD       -- 유형코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD  , 'PLS_BSNS_TYPE_CD'
         , A.BSNS_TYPE_CD, 'ko'
       ) as TYPE_NM         -- 유형명
     , A.BSNS_STD_CD        -- 업무별기준코드
     , A.BSNS_TYPE_NM       -- 기준분류명
     , B.STD_ID             -- 기준ID
     , B.COL1_VAL	        -- 항목1
     , B.COL2_VAL	        -- 항목2
     , B.COL3_VAL	        -- 항목3
     , B.COL4_VAL	        -- 항목4
     , B.COL5_VAL	        -- 항목5
     , B.COL6_VAL	        -- 항목6
     , B.COL7_VAL	        -- 항목7
     , B.COL8_VAL	        -- 항목8
     , B.COL9_VAL	        -- 항목9
     , B.COL10_VAL	        -- 항목10
     , B.COL11_VAL	        -- 항목11
     , B.COL12_VAL	        -- 항목12
     , B.REMARKS            -- 비고     
  from TB_PL_SSTD_M A
  ,    TB_PL_SSTD_D B
 where A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.BSNS_STD_CD = B.BSNS_STD_CD(+)
   
   and A.COMPANY_CD  = 'DEVW'
;

-- 업무기준별 화면에 사용되는 테이블의 컬럼명 목록 조회
select * 
  from TB_PL_SSTD_FIXN_M
 where COMPANY_CD  = 'DEVW'
   and BSNS_STD_CD = 'PLR_INSU_COPR_CD' -- 업무기준코드
;

-- 지급예외 사항 조회
select    /*+  'PlSdtlexcpC_V01'  */ 
       A.COMPANY_CD       "companyCd"          /* 회사코드 */
     , A.ITEM_CD          "itemCd"             /* 소득공제코드 */
     , A.EFF_START_DT     "effStartDt"         /* 유효시작일 */
     , A.DTL_SET_CD       "dtlSetCd"           /* 상세설정코드 */
     , A.MAIN_SET_CD      "mainSetCd"          /* 주설정코드_사번 */
     , B.EMP_NM           "mainSetNm"          /* 주설정코드_사원명 */
     , A.START_DT         "startDt"            /* 적용시작일 */
     , A.END_YMD          "endYmd"             /* 적용종료일 */
     , A.BASE_TIME_CNT    "baseTimeCnt"        /* 기준시간 */
     , A.CALC_TXT         "calcTxt"            /* 계산수식 */
     , A.REMARKS          "remarks"            /* 비고 */
     , A.ETC_SET1_CD      "etcSet1Cd"          /* 기타설정1 */
     , A.STD_ETC1_AMT     "stdEtc1Amt"         /* 기타설정1금액 */
     , A.STD_ETC1_RATE    "stdEtc1Rate"        /* 기타설정1비율 */
     , A.ETC_SET2_CD      "etcSet2Cd"          /* 기타설정2 */
     , A.STD_ETC2_AMT     "stdEtc2Amt"         /* 기타설정2금액 */
     , A.STD_ETC2_RATE    "stdEtc2Rate"        /* 기타설정2비율 */ 
  from TB_PL_SDTLEXCP_C A, TB_PL_HEMP_M B
 where 1=1
   and A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.MAIN_SET_CD = B.EMP_NO(+)
   
   and A.COMPANY_CD  = 'DEVW'
   and A.ITEM_CD     = :itemCd
   and A.DTL_SET_CD  = :dtlSetCd
   and A.EFF_START_DT= :effStartDt
;
-- 고객사별/업무별 기준항목 내역(세로형)
with V_COLS as
     (
         select *
           from
            (
                select A.COMPANY_CD
                     , A.BSNS_STD_CD
                     , case when B.LVL =  1 then 'COL_TITLE'
                            when B.LVL =  2 then 'MDNT_YN'
                            when B.LVL =  3 then 'COL_TYPE'
                            when B.LVL =  4 then 'COL_DISP_SIZE'
                            when B.LVL =  5 then 'COL_ALIGN'
                            when B.LVL =  6 then 'COL_COMBO_FG'
                            when B.LVL =  7 then 'COL_COMBO_DS'
                            when B.LVL =  8 then 'COL_COMBO_CD'
                            when B.LVL =  9 then 'COL_COM_VAL'
                            when B.LVL = 10 then 'REMARKS'
                       end as STD_ID
                     , to_char(B.LVL, 'fm00') as SORT_ORDER
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL1_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL1_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL2_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL2_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL3_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL3_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL4_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL4_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL5_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL5_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL6_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL6_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL7_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL7_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL8_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL8_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL9_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL9_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL10_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL10_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL11_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL11_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL12_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL12_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL13_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL13_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL14_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL14_VAL
                     , max
                       (
                           case when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  1 then A.COL_TITLE
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  2 then A.MDNT_YN
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  3 then A.COL_TYPE
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  4 then to_char(A.COL_DISP_SIZE)
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  5 then A.COL_ALIGN
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  6 then A.COL_COMBO_FG
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  7 then A.COL_COMBO_DS
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  8 then A.COL_COMBO_CD
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL =  9 then A.COL_COM_VAL
                                when A.COL_VAL_ID = 'COL15_VAL' and B.LVL = 10 then A.REMARKS
                           end
                       ) as COL15_VAL
                     , '' as REMARKS
                  from TB_PL_SSTD_FIXN_M A
                  ,(
                       select level as LVL
                         from dual 
                       connect by level <= 10
                   ) B
                 group by A.COMPANY_CD, A.BSNS_STD_CD
                        , case when B.LVL =  1 then 'COL_TITLE'
                               when B.LVL =  2 then 'MDNT_YN'
                               when B.LVL =  3 then 'COL_TYPE'
                               when B.LVL =  4 then 'COL_DISP_SIZE'
                               when B.LVL =  5 then 'COL_ALIGN'
                               when B.LVL =  6 then 'COL_COMBO_FG'
                               when B.LVL =  7 then 'COL_COMBO_DS'
                               when B.LVL =  8 then 'COL_COMBO_CD'
                               when B.LVL =  9 then 'COL_COM_VAL'
                               when B.LVL = 10 then 'REMARKS'
                          end
                        , to_char(B.LVL, 'fm00')
                union all
                select COMPANY_CD
                     , BSNS_STD_CD
                     , STD_ID
                     , '99' as SORT_ORDER
                     , COL1_VAL , COL2_VAL , COL3_VAL , COL4_VAL , COL5_VAL
                     , COL6_VAL , COL7_VAL , COL8_VAL , COL9_VAL , COL10_VAL
                     , COL11_VAL, COL12_VAL, COL13_VAL, COL14_VAL, COL15_VAL
                     , REMARKS
                  from TB_PL_SSTD_D
            )
     )
   , V_CODES as
     (
         select A.COMPANY_CD, A.CLASS_CD
              , B.CLASS_CD_VALUE as CD_VAL
              , C.META_ITEM_DESC as CD_NAME
           from TB_CM_CODE_CLASS    A
           ,    TB_CM_CODE_VALUE    B
           ,    TB_CM_LANGUAGE_PACK C
          where A.COMPANY_CD          = B.COMPANY_CD(+)
            and A.CLASS_CD            = B.CLASS_CD(+)
            and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID(+)
            and C.LANGUAGE_CD(+)      = 'ko'
            and to_char(sysdate, 'YYYYMMDD')
                between A.VALID_PERIOD_START_DT and A.VALID_PERIOD_END_DT
            and to_char(sysdate, 'YYYYMMDD')
                between B.VALID_PERIOD_START_DT and B.VALID_PERIOD_END_DT
            --and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD           in 
                (
                    'PLS_BSNS_TYPE_CD'   -- 업무구분코드
                )
     )     
select USE_YN as APPLY_YN
     , COMPANY_CD
     , (
           select CD_NAME
             from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PLS_BSNS_TYPE_CD'
              and CD_VAL     = A.BSNS_TYPE_CD
       ) as BSNS_TYPE_NM
     , BSNS_TYPE_CD, BSNS_TYPE_NM, BSNS_STD_CD
     , STD_ID      , SYS_CD_YN   , SORT_ORDER
     , COL1_VAL    , COL2_VAL    , COL3_VAL    , COL4_VAL    , COL5_VAL
     , COL6_VAL    , COL7_VAL    , COL8_VAL    , COL9_VAL    , COL10_VAL
     , COL11_VAL   , COL12_VAL   , COL13_VAL   , COL14_VAL   , COL15_VAL
     , REMARKS
  from
   (
       select 1 as LVL     , B.COMPANY_CD
            , A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM
            , B.USE_YN     , B.SYS_CD_YN as SYS_CD_YN
            , A.BSNS_STD_CD   as STD_ID
            , '00'            as SORT_ORDER
            ,  A.BSNS_TYPE_NM as COL1_VAL         , A.BSNS_TYPE_CD as COL2_VAL
            , null as COL3_VAL , null as COL4_VAL , null as COL5_VAL
            , null as COL6_VAL , null as COL7_VAL , null as COL8_VAL , null as COL9_VAL , null as COL10_VAL 
            , null as COL11_VAL, null as COL12_VAL, null as COL13_VAL, null as COL14_VAL, null as COL15_VAL 
            , B.REMARKS
         from
          (
              select A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM, A.REMARKS
                from TB_PL_SSTD_M A
                ,    V_COLS       B
               where A.COMPANY_CD  = B.COMPANY_CD(+)
                 and A.BSNS_STD_CD = B.BSNS_STD_CD(+)
               group by A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM, A.REMARKS
          ) A
         ,    TB_PL_SSTD_M B
        where A.BSNS_STD_CD = B.BSNS_STD_CD(+)
          and B.COMPANY_CD  = 'DEVW'
       union
       select 2 as LVL     , A.COMPANY_CD
            , A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM
            , A.USE_YN     , A.SYS_CD_YN
            , B.STD_ID     , B.SORT_ORDER
            , B.COL1_VAL   , B.COL2_VAL   , B.COL3_VAL   , B.COL4_VAL   , B.COL5_VAL
            , B.COL6_VAL   , B.COL7_VAL   , B.COL8_VAL   , B.COL9_VAL   , B.COL10_VAL
            , B.COL11_VAL  , B.COL12_VAL  , B.COL13_VAL  , B.COL14_VAL  , B.COL15_VAL
            , B.REMARKS 
         from TB_PL_SSTD_M A
         ,    V_COLS       B
        where A.COMPANY_CD  = B.COMPANY_CD(+)
          and A.BSNS_STD_CD = B.BSNS_STD_CD(+)
          and A.COMPANY_CD  = 'DEVW'
   ) A

 order by A.BSNS_STD_CD, A.LVL, A.SORT_ORDER, A.STD_ID
;
select * from TB_PL_SSTD_M
;
       select A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM, B.STD_ID
         from TB_PL_SSTD_M A
         ,    TB_PL_SSTD_D B
        where A.COMPANY_CD  = B.COMPANY_CD(+)
          and A.BSNS_STD_CD = B.BSNS_STD_CD(+)
          
          and A.COMPANY_CD = 'PSFN'

        group by A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM, B.STD_ID
;

-- 고객새별/업무별 기준항목 내역(가로형) < 아직만들다 말았음... 가로가 나을지 세로가 나을지...
-- 좀 익숙하지 않을 형태일것 같음.
select A.*
     , B.MDNT_YN       , B.COL_TITLE
     , B.COL_TYPE      , B.COL_DISP_SIZE     , B.COL_ALIGN
     , B.COL_COMBO_FG  , B.COL_COMBO_DS      , B.COL_COMBO_CD     , B.COL_COM_VAL
     , B.REMARKS    
  from
   (
       select A.COMPANY_CD, A.BSNS_STD_CD, A.STD_ID
            , (
                  case when B.LVL = 1  then 'COL1_VAL'
                       when B.LVL = 2  then 'COL2_VAL'
                       when B.LVL = 3  then 'COL3_VAL'
                       when B.LVL = 4  then 'COL4_VAL'
                       when B.LVL = 5  then 'COL5_VAL'
                       when B.LVL = 6  then 'COL6_VAL'
                       when B.LVL = 7  then 'COL7_VAL'
                       when B.LVL = 8  then 'COL8_VAL'
                       when B.LVL = 9  then 'COL9_VAL'
                       when B.LVL = 10 then 'COL10_VAL'
                       when B.LVL = 11 then 'COL11_VAL'
                       when B.LVL = 12 then 'COL12_VAL'
                       when B.LVL = 13 then 'COL13_VAL'
                       when B.LVL = 14 then 'COL14_VAL'
                       when B.LVL = 15 then 'COL15_VAL'
                  end
              ) as COL_ID
            , (
                  case when B.LVL = 1  then A.COL1_VAL
                       when B.LVL = 2  then A.COL2_VAL
                       when B.LVL = 3  then A.COL3_VAL
                       when B.LVL = 4  then A.COL4_VAL
                       when B.LVL = 5  then A.COL5_VAL
                       when B.LVL = 6  then A.COL6_VAL
                       when B.LVL = 7  then A.COL7_VAL
                       when B.LVL = 8  then A.COL8_VAL
                       when B.LVL = 9  then A.COL9_VAL
                       when B.LVL = 10 then A.COL10_VAL
                       when B.LVL = 11 then A.COL11_VAL
                       when B.LVL = 12 then A.COL12_VAL
                       when B.LVL = 13 then A.COL13_VAL
                       when B.LVL = 14 then A.COL14_VAL
                       when B.LVL = 15 then A.COL15_VAL
                  end
              ) as COL_VAL
         from TB_PL_SSTD_D A
         ,(
              select level as LVL
                from dual 
              connect by level <= 15
          ) B
   ) A
  ,    TB_PL_SSTD_FIXN_M B
 where A.COMPANY_CD  = B.COMPANY_CD
   and A.BSNS_STD_CD = B.BSNS_STD_CD
   and A.COL_ID      = B.COL_VAL_ID

 order by A.COMPANY_CD, A.BSNS_STD_CD, A.STD_ID, A.COL_ID
;
select A.COMPANY_CD, A.BSNS_STD_CD, A.BSNS_TYPE_CD, A.BSNS_TYPE_NM, A.SYS_CD_YN, A.REMARKS, A.USE_YN
     , B.STD_ID
     , B.COL1_VAL   , B.COL2_VAL   , B.COL3_VAL   , B.COL4_VAL   , B.COL5_VAL
     , B.COL6_VAL   , B.COL7_VAL   , B.COL8_VAL   , B.COL9_VAL   , B.COL10_VAL
     , B.COL11_VAL  , B.COL12_VAL  , B.COL13_VAL  , B.COL14_VAL  , B.COL15_VAL
     
  from TB_PL_SSTD_M A
  ,    TB_PL_SSTD_D B
 where A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.BSNS_STD_CD = B.BSNS_STD_CD(+)
   and A.COMPANY_CD = 'PSFN'
 order by A.COMPANY_CD, A.BSNS_STD_CD, B.STD_ID