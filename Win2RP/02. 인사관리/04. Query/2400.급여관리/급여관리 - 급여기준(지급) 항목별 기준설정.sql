select A.ITEM_CD, A.ITEM_CD_HAN
  from TB_PL_SPAYBASE_C A
 where A.COMPANY_CD   = 'DEVW'
   and A.ITEM_KIND_CD = '01'  -- 지급
   and A.TYPE_GBN_CD <> 'S'   -- 별도설정이 아닌 항목만 조회
;


with V_CODE as
     (
         select A.COMPANY_CD, A.CLASS_CD
              , B.CLASS_CD_VALUE as CD_VAL
              , C.META_ITEM_DESC as CD_NAME
           from TB_CM_CODE_CLASS    A
           ,    TB_CM_CODE_VALUE    B
           ,    TB_CM_LANGUAGE_PACK C
          where A.COMPANY_CD       = B.COMPANY_CD(+)
            and A.CLASS_CD         = B.CLASS_CD(+)
            and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID(+)
            and C.LANGUAGE_CD(+)   = 'ko'
            and to_char(sysdate, 'YYYYMMDD') between A.VALID_PERIOD_START_DT and A.VALID_PERIOD_END_DT
            and to_char(sysdate, 'YYYYMMDD') between B.VALID_PERIOD_START_DT and B.VALID_PERIOD_END_DT
            --and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD        in 
                (
                    'PLH_JOBTIT_CD'    -- 직책
                )
     )
select * 
  from V_CODE           A
  ,    TB_PL_SDTLCOMN_C B
 where A.COMPANY_CD = B.COMPANY_CD(+)
;



select * from TB_PL_SDTLCOMN_C
 where COMPANY_CD = 'DEVW'










;
         select A.COMPANY_CD, A.CLASS_CD
              , B.CLASS_CD_VALUE as CD_VAL
              , C.META_ITEM_DESC as CD_NAME
           from TB_CM_CODE_CLASS    A
           ,    TB_CM_CODE_VALUE    B
           ,    TB_CM_LANGUAGE_PACK C
          where A.COMPANY_CD       = B.COMPANY_CD(+)
            and A.CLASS_CD         = B.CLASS_CD(+)
            and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID(+)
            and C.LANGUAGE_CD(+)   = 'ko'
            and to_char(sysdate, 'YYYYMMDD') between A.VALID_PERIOD_START_DT and A.VALID_PERIOD_END_DT
            and to_char(sysdate, 'YYYYMMDD') between B.VALID_PERIOD_START_DT and B.VALID_PERIOD_END_DT
            --and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD        in 
                (
                    'PLS_WORK_TERM_YY' -- 근속년수
                  , 'PLH_JOBTIT_CD'    -- 직급
                )
;
select * 
  from TB_CM_CODE_VALUE
 where CLASS_CD = 'PLS_WORK_TERM_YY'
 

;
SELECT	/*+'PlSpaybaseD_V02.view'*/
			B.COMPANY_CD                	"companyCd"                 ,		/* 회사코드 */
			B.ITEM_CD                    	"itemCd"                    ,		/* 소득공제코드 */
			B.EFF_START_DT               	"effStartDt"               	,		/* 유효시작일 */
			B.ITEM_KIND_CD	                "itemKindCd"                ,		/* 지급공제구분*/
			B.DTL_SET_CD               		"dtlSetCd"                 	,		/* 상세설정코드 */
			B.END_YMD                   "effEndDt"                  ,		/* 적용종료일 */
			B.DTL_SET_NM                 	"dtlSetNm"                 	,		/* 상세설정코드명 */
			A.COL3_VAL						"path"                           /* 항목3 */               
			
FROM		TB_PL_SSTD_D A , TB_PL_SPAYBASE_D B
WHERE       A.COMPANY_CD = 'DEVW'
  AND 		A.BSNS_STD_CD = 'PAY_BASE_CD'
  AND 		A.EFF_START_DT  <= '19000101'
  AND 		A.EFF_END_DT >='19000101'
  AND 		A.COMPANY_CD = B.COMPANY_CD
  AND 		A.STD_ID = B.DTL_SET_CD
  AND 		B.EFF_START_DT = '19000101'
  AND 		B.ITEM_CD = 'S015'
  AND 		B.ITEM_KIND_CD = '01'
;

SELECT	/*+'PlSdtlcomnC_V01'*/
			A.COMPANY_CD                 	"companyCd"                 	,		/* 회사코드 */
			A.ITEM_CD                    	"itemCd"                    	,		/* 소득공제코드 */
			A.EFF_START_DT               	"effStartDt"               	,		/* 유효시작일 */
			A.DTL_SET_CD                 	"dtlSetCd"                 	,		/* 상세설정코드 */
			A.MAIN_SET_CD                	"mainSetCd"                	,		/* 주설정코드_사번 */
            B.META_ITEM_DESC                "mainSetNm"                	,		/* 주설정코드_사번 */
			A.START_DT                   	"startDt"                   	,		/* 적용시작일 */
			A.END_YMD                    	"endYmd"                    	,		/* 적용종료일 */
			A.CALC_MODE_CD               	"calcModeCd"               	,		/* 계산방식코드 */
			A.PAY_ITEM_CD                	"payItemCd"                	,		/* 급여항목코드 */
			A.BASE_TIME_CNT              	"baseTimeCnt"              	,		/* 기준시간 */
			A.CALC_TXT                   	"calcTxt"                   	,		/* 계산수식 */
			A.STD_AMT                    	"stdAmt"                    	,		/* 기준금액 */
			A.STD_RATE                   	"stdRate"                   	,		/* 기준비율 */
			A.ADD_AMT                    	"addAmt"                    	,		/* 가산금액 */
			A.REMARKS                    	"remarks"                    	,		/* 비고 */
			A.TIME_CALC_TXT              	"timeCalcTxt"              	,		/* 시간고정산식 */
			A.ETC_SET1_CD                	"etcSet1Cd"                	,		/* 기타설정1 */
			A.STD_ETC1_AMT               	"stdEtc1Amt"               	,		/* 기타설정1금액 */
			A.STD_ETC1_RATE              	"stdEtc1Rate"              	,		/* 기타설정1비율 */
			A.ETC_SET2_CD                	"etcSet2Cd"                	,		/* 기타설정2 */
			A.STD_ETC2_AMT               	"stdEtc2Amt"               	,		/* 기타설정2금액 */
			A.STD_ETC2_RATE              	"stdEtc2Rate"              	, 		/* 기타설정2비율 */
			A.CREATED_OBJECT_ID          	"createdObjectId"          	,		/* 생성ObjectID */
			A.CREATED_PROGRAM_ID         	"createdProgramId"         	,		/* 생성프로그램ID */
			A.CREATION_TIMESTAMP         	"creationTimestamp"         ,		/* 생성일시 */
			A.CREATION_LOCAL_TIMESTAMP   	"creationLocalTimestamp"   	,		/* 생성회사일시 */
			A.LAST_UPDATED_OBJECT_ID     	"lastUpdatedObjectId"     	,		/* 최종변경ObjectID */
			A.LAST_UPDATE_PROGRAM_ID     	"lastUpdateProgramId"     	,		/* 최종변경프로그램ID */
			A.LAST_UPDATE_TIMESTAMP      	"lastUpdateTimestamp"      	,		/* 최종변경일자 */
			A.LAST_UPDATE_LOCAL_TIMESTAMP	"lastUpdateLocalTimestamp"			/* 최종변경회사일자 */
FROM		TB_PL_SDTLCOMN_C A , VI_PLS_CODE_VALUE B
WHERE       A.COMPANY_CD = 'PHAL'
  AND       A.ITEM_CD = 'S015'
  AND       A.DTL_SET_CD = 'PLH_JOBTIT_CD'
  AND       A.EFF_START_DT = '19000101'
  AND       A.COMPANY_CD = B.COMPANY_CD(+)
  AND       A.MAIN_SET_CD = B.CLASS_CD_VALUE(+)
  AND       B.USE_YN(+) = 'Y'
  AND       B.LANGUAGE_CD(+) =  'ko'
  AND       B.CLASS_CD(+) = 'PLH_JOBTIT_CD'
ORDER BY SORT_ORDER
;

select * from TB_PL_SDTLCOMN_C