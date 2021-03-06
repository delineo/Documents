-- 월별 근태현황 조회
with V_CODE as
     (
         select SA.CLASS_CD, SA.CLASS_CD_VALUE as CODE_VAL
              , SB.META_ITEM_DESC as CODE_NM
           from TB_CM_CODE_VALUE    SA
           ,    TB_CM_LANGUAGE_PACK SB
          where SA.LANGUAGE_PACK_ID = SB.MGMT_OBJECT_ID
            and SA.COMPANY_CD       = :companyCd
            and SA.CLASS_CD         in
                (
                    'PLD_WRKTYPE_CD', 'PLD_ATTDGBN_CD', 'PLH_JOBGRD_CD', 'PLD_WRKGRP_CD'
                )
            and SB.LANGUAGE_CD      = :languageCd
            and SA.USE_YN           = 'Y'
            and to_char(sysdate, 'YYYYMMDD')
                    between SA.VALID_PERIOD_START_DT 
                        and nvl(SA.VALID_PERIOD_END_DT,' 99991231')
     )
select A.COMPANY_CD     as "companyCd"
     , B.EMP_NM         as "empNm"
     , A.EMP_NO         as "empNo"
     --, B.DEPT_CD, B.JOBGRD_CD, B.WRKGRP_CD, B.EMP_ST_CD, B.RETIRE_YMD
     , (
           select PKG_CMA_UTILS.GET_DEPT_NM
                  (
                      B.COMPANY_CD, B.DEPT_CD
                    , case when B.EMP_ST_CD = '0101' then to_char(sysdate, 'YYYYMMDD')
                           else B.RETIRE_YMD
                      end
                    , '1'
                  ) 
               from dual
       ) as "deptNm"
     , (
           select CODE_NM from V_CODE
            where CLASS_CD = 'PLH_JOBGRD_CD'
              and CODE_VAL = B.JOBGRD_CD
       ) as "jobgrdNm"
     , (
           select CODE_NM from V_CODE
            where CLASS_CD = 'PLD_WRKGRP_CD'
              and CODE_VAL = B.WRKGRP_CD
       ) as "wrkgrpNm"
     , A.COL01         as "col1Val"        
     , A.COL02         as "col2Val"        
     , A.COL03         as "col3Val"        
     , A.COL04         as "col4Val"        
     , A.COL05         as "col5Val"        
     , A.COL06         as "col6Val"        
     , A.COL07         as "col7Val"        
     , A.COL08         as "col8Val"        
     , A.COL09         as "col9Val"        
     , A.COL10         as "col10Val"       
     , A.COL11         as "col11Val"       
     , A.COL12         as "col12Val"       
     , A.COL13         as "col13Val"       
     , A.COL14         as "col14Val"       
     , A.COL15         as "col15Val"       
     , A.COL16         as "col16Val"       
     , A.COL17         as "col17Val"       
     , A.COL18         as "col18Val"       
     , A.COL19         as "col19Val"       
     , A.COL20         as "col20Val"       
     , A.COL21         as "col21Val"       
     , A.COL22         as "col22Val"       
     , A.COL23         as "col23Val"       
     , A.COL24         as "col24Val"       
     , A.COL25         as "col25Val"       
     , A.COL26         as "col26Val"       
     , A.COL27         as "col27Val"       
     , A.COL28         as "col28Val"       
     , A.COL29         as "col29Val"       
     , A.COL30         as "col30Val"       
     , A.COL31         as "col31Val"     
  from 
   (
       select *
         from
          (
              select A.COMPANY_CD, A.EMP_NO
                   , substr(A.ATTD_YMD, 7, 8) as DD
                   , (
                         (
                             select CODE_NM from V_CODE
                              where CLASS_CD = 'PLD_WRKTYPE_CD'
                                and CODE_VAL = nvl(A.WRKTYPECHNG_CD, A.WRKTYPE_CD)
                         )
                      || '\n['
                      || (
                             select CODE_NM from V_CODE
                              where CLASS_CD = 'PLD_ATTDGBN_CD'
                                and CODE_VAL = A.ATTDGBN_CD
                         )
                      || ']'
                     ) as WRKTYPE
                from TB_PL_DDDATTDDTL_M A
               where A.COMPANY_CD = :companyCd
                 and A.ATTD_YMD
                     between to_char(trunc   (to_date(:baseDt, 'YYYYMM'), 'MM'), 'YYYYMMDD') -- 첫날
                         and to_char(last_day(to_date(:baseDt, 'YYYYMM')      ), 'YYYYMMDD') -- 마지막날
          )
        pivot(max(WRKTYPE) for DD in
        (
            '01' as COL01, '02' as COL02, '03' as COL03, '04' as COL04, '05' as COL05
          , '06' as COL06, '07' as COL07, '08' as COL08, '09' as COL09, '10' as COL10
          , '11' as COL11, '12' as COL12, '13' as COL13, '14' as COL14, '15' as COL15
          , '16' as COL16, '17' as COL17, '18' as COL18, '19' as COL19, '20' as COL20
          , '21' as COL21, '22' as COL22, '23' as COL23, '24' as COL24, '25' as COL25
          , '26' as COL26, '27' as COL27, '28' as COL28, '29' as COL29, '30' as COL30
          , '31' as COL31
        ))
   ) A
  ,    TB_PL_HEMP_M B
 where A.COMPANY_CD = B.COMPANY_CD
   and A.EMP_NO     = B.EMP_NO

   and A.EMP_NO     = nvl(:empNo , A.EMP_NO )
   and B.DEPT_CD    = nvl(:deptCd, B.DEPT_CD)

 order by B.DEPT_CD, A.EMP_NO
;

