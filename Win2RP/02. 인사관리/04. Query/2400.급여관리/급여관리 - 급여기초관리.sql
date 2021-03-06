-- 급여유형별 급여대상자 생성 여부조회
select decode(B.PAY_DT_SEQ_NO,null,'N','Y') as CREATE_YN    -- 생성여부
     , A.CLASS_CD_VALUE as PAY_KIND_CD                      -- 급여유형코드
     , PKG_GLOBAL.GET_CODE_NM
       (
           A.COMPANY_CD    , 'PLS_PAY_KIND_CD'
         , A.CLASS_CD_VALUE, 'ko'
       ) as PAY_KIND_NM                                     -- 급여유형명
     , B.PAY_YM                                             -- 적용년월
     , B.PAY_DT                                             -- 급여일자
     , B.PAY_DT_SEQ_NO                                      -- 급여지급차수
     , B.PAY_TYPE_CD                                        -- 급여지급구분
     , PKG_GLOBAL.GET_CODE_NM
       (
           B.COMPANY_CD    , 'PLS_PAY_TYPE_CD'
         , B.PAY_TYPE_CD   , 'ko'
       ) as PAY_TYPE_NM                                     -- 급여지급구분명
     , B.PAY_APPL_YN                                        -- 급여반영여부
     , B.REMARKS
  from TB_CM_CODE_VALUE A
  ,    TB_PL_SPAYOBJ_M  B
 where 1=1
   and A.COMPANY_CD     = B.COMPANY_CD(+)
   and A.CLASS_CD_VALUE = B.PAY_KIND_CD(+)

   and A.COMPANY_CD     = 'DEVW'
   and A.CLASS_CD       = 'PLS_PAY_KIND_CD' -- 급여구분
   
   and B.PAY_YM(+)      = '201309'          -- 급여대상년월
;

select * from TB_PL_SSTD_D where STD_ID ='PSTD31';

select * 
  from TB_PL_SPAYBASE_INFO_MONTH A
 where 1=1
   and A.COMPANY_CD = 'DEVW'
   and A.PAY_YM     = '201310'
;

-- 지급월별 급여대상자 목록 조회(급여지급대상자 생성시)
select A.COMPANY_CD
     , A.PAY_TYPE_CD
     , A.PAY_YM
     , A.PAY_DT_SEQ_NO
     , A.PAY_GB_NM
     , A.START_DT
     , B.RETIRE_YMD
     , B.EMP_NO
     , B.EMP_NM
     , C.PAY_KIND_CD
     , PKG_GLOBAL.GET_CODE_NM
       (
           C.COMPANY_CD, 'PLS_PAY_KIND_CD'
         , C.PAY_KIND_CD, 'ko'
       ) as PAY_KIND_NM
     , C.*
  from TB_PL_SPAYDT_M     A
  ,    TB_PL_HEMP_M       B
  ,    TB_PL_PAYBASE_INFO C
 where 1=1
   and A.COMPANY_CD = B.COMPANY_CD

   -- 퇴직자는 지급대상에서 제외
   -- 퇴사일을 지급대상일로 볼 경우 퇴사일+1 로 변경
   and A.START_DT  <= nvl(B.RETIRE_YMD, '99991230')

   and B.COMPANY_CD = C.COMPANY_CD
   and B.EMP_NO     = C.EMP_NO
   
   and A.COMPANY_CD = 'DEVW'
   and A.PAY_YM     = '201309'
;

select * from TB_PL_SCONT_MGMT
 where COMPANY_CD = 'DEVW'
  and EMP_NO = '001507'
 --  and 
;

select * from TB_PL_SEMPTAX_FREE_D
 where COMPANY_CD = 'DEVW'