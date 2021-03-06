-- 도대체 얘는 뭘까....??? 일단 쓰지는 않는것 같다.. 키는 존재하나 데이터가 없다.
-- 화면은 있으나(CMB010PR) 표시되진 않고 있네... 환경설정 문제인가...
select * from TB_CM_LOCAL_INFO
;
/* 시스템 언어설정정보 (고객사와 개별)*/
select LANGUAGE_CD              /* 언어코드      */
     , LANGUAGE_DISPLAY_NM      /* 언어표시명    */
     , LANGUAGE_KOREAN_NM       /* 한글언어명    */
     , USE_YN                   /* 사용여부      */
     , FONT_NM                  /* 폰트명        */
     , FONT_SIZE                /* 폰트크기      */
  from TB_SM_LANGUAGE
;
-- 회사정보 조회
with V_CODES as
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
            and A.COMPANY_CD         = 'PHAL'
            and A.CLASS_CD           in 
                (   
                    'CM_BUSINESS_TP'            -- 회사업종구분
                  , 'COMPANY_AREA'              -- 법인이속한권역
                  , 'IMPORT_MGMT_TP'            -- 수입관리구분
                  , 'PURCH_SALES_TAX_CALC_TP'   -- 매입/매출/환산 세금계산구분
                  , 'EXPENSE_PROC_TP'           -- 매입등록기준/부대비용처리구분
                )
     )
select
       A.COMPANY_NM
     , A.COMPANY_CD
     , A.COMPANY_NM_ENG
     , A.COMPANY_REG_NO
     , A.CORP_NO
     , A.FISCAL_YEAR
     , A.START_DT
     , A.END_DT
     , A.FISCAL_PERIOD
     , A.BIZ_ITM
     , A.BUSINESS_CATEGORY
     , A.BUSINESS_CONDITION
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'CM_BUSINESS_TP'
              and CD_VAL     = A.BUSINESS_TP
       ) as BUSINESS_NM
     , A.BUSINESS_TP
     , A.PRESIDENT_NM
     , A.PRESIDENT_NM_ENG
     , A.PRESIDENT_SOCIAL_SECURITY_NO
     , A.E_MAIL
     , A.TEL_NO
     , A.FAX_NO
     , A.INTERNATIONAL_TEL_NO
     , A.INTERNATIONAL_FAX_NO
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'COMPANY_AREA'
              and CD_VAL     = A.COMPANY_AREA
       ) as COMPANY_AREA_NM
     , A.COMPANY_AREA
     , A.ESTABLISHMENT_DT
     , A.CESSATION_DT
     , A.URL
     , A.PARENT_COMPANY_CONNECTION
     , A.USE_YN
     , A.INIT_TRANS_DT
     , A.ACCESS_CERT_YN
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'IMPORT_MGMT_TP'
              and CD_VAL     = A.IMPORT_MGMT_TP
       ) as IMPORT_MGMT_NM
     , A.IMPORT_MGMT_TP
     , A.PUBLIC_ANCD_EXCH_RATE_USE_YN
     , A.ADDRESS_ID     -- TB_CM_ADDRESS    에 등록된 ID
     , A.LOCAL_ID       -- TB_CM_LOCAL_INFO 에 등록된 ID
     , A.CASH_LIMIT
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PURCHASE_TAX_CALC_TP'
              and CD_VAL     = A.SALES_TAX_CALC_TP
       ) as PURCHASE_TAX_CALC_NM
     , A.PURCHASE_TAX_CALC_TP
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PURCH_SALES_TAX_CALC_TP'
              and CD_VAL     = A.SALES_TAX_CALC_TP
       ) as SALES_TAX_CALC_NM
     , A.SALES_TAX_CALC_TP
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'PURCH_SALES_TAX_CALC_TP'
              and CD_VAL     = A.TAX_CALC_TP
       ) as TAX_CALC_NM
     , A.TAX_CALC_TP
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'EXPENSE_PROC_TP'
              and CD_VAL     = A.PURCHASE_KEY_TP
       ) as PURCHASE_KEY_NM
     , A.PURCHASE_KEY_TP
     , (
           select CD_NAME from V_CODES
            where COMPANY_CD = A.COMPANY_CD
              and CLASS_CD   = 'EXPENSE_PROC_TP'
              and CD_VAL     = A.EXPENSE_KEY_TP
       ) as EXPENSE_KEY_NM
     , A.EXPENSE_KEY_TP
     , A.TAX_OFFICE_CD
  from TB_CM_COMPANY A
 where A.COMPANY_CD = 'PHAL'
;

select * from TB_CM_ADDRESS
where COMPANY_CD = 'PHAL'
;

-- 사업장 정보
with V_CODE as
     (
         select A.CLASS_CD
              , A.CLASS_CD_VALUE as CODE_VAL
              , B.META_ITEM_DESC as CODE_NM
           from TB_CM_CODE_VALUE    A
           ,    TB_CM_LANGUAGE_PACK B
          where A.LANGUAGE_PACK_ID = B.MGMT_OBJECT_ID(+)
            and B.LANGUAGE_CD(+)   = 'ko'
            and A.COMPANY_CD       = 'DEVW'
            and A.CLASS_CD         in 
                (
                    'TAX_OFFICE_CD'     -- 세무소코드
                )
     )
select
       COMPANY_CD                      /* 회사코드          */
       /* 기본정보 */
     , BIZ_UNIT_CD                     /* 사업장코드        */
     , BIZ_UNIT_NM                     /* 사업장명          */
     , BIZ_UNIT_NM_ENG                 /* 영문사업장명      */
     , BIZ_UNIT_NO                     /* 사업자등록번호    */
     , CORP_NO                         /* 법인번호          */
     , FISCAL_YEAR                     /* 회계년도          */
     , START_DT                        /* 회계시작일        */
     , END_DT                          /* 회계종료일        */
     , BIZ_TP                          /* 업태              */
     , BIZ_ITM                         /* 종목              */
     , MAIN_BIZ_ITM_CD                 /* 주업종코드        */
     , PRESIDENT_NM                    /* 대표자명          */
     , PRESIDENT_NM_ENG                /* 대표자영문명      */
     , PRESIDENT_SOCIAL_SECURITY_NO    /* 대표자주민번호    */
     , NATIVE_YN                       /* 내외국인구분      */
     , FOREIGN_SOCIAL_SECURITY_NO      /* 외국인등록번호    */
     , TEL_NO                          /* 전화번호          */
     , FAX_NO                          /* 팩스번호          */
     , ZIP_CD                          /* 우편번호          */
     , BIZ_UNIT_ADDRESS                /* 사업부주소        */
     , ADDRESS_ENG                     /* 영문주소          */
     , ESTABLISHMENT_DT                /* 사업시작일        */
     , CESSATION_DT                    /* 폐업일자          */

       /* 상세정보 */
     , MAIN_COMPANY_YN                 /* 본점여부          */
     , CORP_TP                         /* 법인구분          */
     , INIT_STOCK_TRANSFER_DT          /* 초기재고이월년월  */
     , PRICE_APPLYING_STANDARD         /* 가격적용기준      */
     , STOCK_ASSET_EVALUATION_STANDAD  /* 재고자산평가기준  */
     , E_REPORT_ID                     /* 전자신고ID        */
     , TAX_OFFICE_NM                   /* 세무서명          */
     , TAX_OFFICE_CD                   /* 세무서코드        */
     , NATIONAL_TAX_RETURN_ACCOUNT_CD  /* 국세환급계좌      */
     
       /* 일단화면에서 보이지 않음 (컨트롤은 있음) */
     , E_REPORT_CHARGER                /* 전자신고담당      */
     , FISCAL_MONTH                    /* 회계월            */
     , ACCESS_CERT_YN                  /* 접속자인증관리    */
     , PASSWD                          /* 패스워드          */
     , SLIP_APPROVE_YN                 /* 전표승인처리여부  */
     , TOTAL_PAYMENT_YN                /* 총괄납부여부      */
     , PERFORM_CONDITION_REPORT_YN     /* 이행상황신고      */
     , JURISDICTION_TAX_OFFICE         /* 관할세무서        */
     , INHABIT_TAX_PAY_PLACE           /* 주민세납세지      */

  from TB_CM_BIZ_UNIT
 where COMPANY_CD = 'DEVW'
;

-- 기본설정
select /*+  'SmCompanyProfile'  */ 
       DATE_TIME_DISPLAY_MASK   "dateTimeDisplayMask"       /* 날짜시간화면출력포맷 */
     , DEFAULT_TRADE_CURRENCY   "defaultTradeCurrency"      /* 주거래외화통화       */
     , COMPANY_CD               "companyCd"                 /* 회사코드             */
     , COUNTRY_CD               "countryCd"                 /* 국가코드             */
     , LANGUAGE_CD              "languageCd"                /* 언어코드             */
     , FUNCTIONAL_CURRENCY      "functionalCurrency"        /* 기준통화             */
     , DATE_DISPLAY_FORMAT      "dateDisplayFormat"         /* 날짜표시형식         */
     , TIME_DISPLAY_FORMAT      "timeDisplayFormat"         /* 시간표시형식         */
     , ACCOUNT_CD_LTH           "accountCdLth"              /* 계정코드길이         */
     , WGT_UOM                  "wgtUom"                    /* 중량UOM              */
     , LTH_UOM                  "lthUom"                    /* 길이UOM              */
     , LOCAL_TIME_CONV_YN       "localTimeConvYn"           /* 회사별시간변환여부   */
     , LOCAL_UTC_TIMEZONE       "localUtcTimezone"          /* 표준시간대           */
     , SUMMER_TIME_APPLY_YN     "summerTimeApplyYn"         /* 썸머타임적용여부     */
     , SUMMER_TIME_START_DT     "summerTimeStartDt"         /* 썸머타임적용시작일   */
     , SUMMER_TIME_END_DT       "summerTimeEndDt"           /* 썸머타임적용종료일   */
     , SUMMER_TIME_GAP          "summerTimeGap"             /* 썸머타임시간차       */
     , PORTAL_USE_YN            "portalUseYn" 
  from TB_SM_COMPANY_PROFILE A
 where A.COMPANY_CD = 'PHAL'
;

-- 유효자리수 <-- 현재 인사쪽에서는 별의미가 없음. 향후 급여계산, 년말정산 등 금전계산에 따른 옵션이 필요할 경우 설정해서 사용해볼것.
select /*+'SmCompanyProfileDigit_V.view'*/
       A.COMPANY_CD             "companyCd"                 /* 회사코드       */
     , A.META_ITEM_ID           "metaItemId"                /* META항목ID     */
     , A.DECIMAL_LTH            "decimalLth"                /* 소수점이하길이 */
     , A.ROUND_MODE             "roundMode"                 /* 반올림방식     */
     , C.META_ITEM_DESC         "metaItemDesc"
  from TB_SM_COMPANY_PROFILE_DIGIT A
  ,    TB_CM_META_DATA             B
  ,    TB_CM_LANGUAGE_PACK         C
 where 1=1
   and A.META_ITEM_ID     = B.META_ITEM_ID
   and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID
   and A.COMPANY_CD       = 'PHAL'
   and C.LANGUAGE_CD      = 'ko'
;

-- 출력물양식 <-- 요놈은 음... 현재 인사 쪽에서는 별의미가 없음. 그냥 정보성으로 관리
select /*+'SmCompanyProfilePrint_V.view'*/
       A.COMPANY_CD             "companyCd"                 /* 회사코드   */
     , A.META_ITEM_ID           "metaItemId"                /* META항목ID */
     , A.PRINT_FORM_ID          "printFormId"               /* 출력물양식 */
     , A.PRINT_PAPER            "printPaper"                /* 출력용지   */
     , A.PRINT_CNT              "printCnt"                  /* 출력매수   */
     , C.META_ITEM_DESC         "metaItemDesc"
  from TB_SM_COMPANY_PROFILE_PRINT A
  ,    TB_CM_META_DATA             B
  ,    TB_CM_LANGUAGE_PACK         C
 where 1=1
   and A.META_ITEM_ID     = B.META_ITEM_ID
   and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID
   and A.COMPANY_CD       = 'PHAL'
   and C.LANGUAGE_CD      = 'ko'
;


