select * 
  from ALL_OBJECTS ao
 where ao.OWNER = 'POSERP'
   and ao.OBJECT_TYPE in ('TABLE', 'VIEW', 'PACKAGE', 'TRIGGER', 'FUNCTION', 'PROCEDURE', 'TYPE')
   and ao.OBJECT_NAME like '%'
;

select * from USER_CONS_COLUMNS ;
/* PK조회 */
select A.TABLE_NAME
     , B.COLUMN_NAME
     , B.DATA_TYPE
     , B.DATA_LENGTH
     , B.NULLABLE
     , B.DATA_DEFAULT
     , (
           select A1.CONSTRAINT_TYPE
             from USER_CONSTRAINTS  A1
             ,    USER_CONS_COLUMNS A2
            where A1.TABLE_NAME      = A.TABLE_NAME
              --and A1.OWNER           = A.OWNER
              and A2.COLUMN_NAME     = B.COLUMN_NAME
              and A1.TABLE_NAME      = A2.TABLE_NAME
              and A1.OWNER           = A2.OWNER
              and A1.CONSTRAINT_NAME = A2.CONSTRAINT_NAME
              and A1.CONSTRAINT_TYPE = 'P'
       ) IS_PK
    from USER_TABLES      A
    ,    USER_TAB_COLUMNS B
   where A.TABLE_NAME = B.TABLE_NAME
     --and A.OWNER      = B.OWNER
     --and A.TABLE_NAME = :TABLE_NM
 order by B.TABLE_NAME, B.COLUMN_ID
;
 
/* Index 조회 */
select INDEX_NAME
     , UNIQUENESS
     , replace(substr(max(sys_connect_by_path
       (
           COLUMN_NAME, '/'
       )), 2), '/', ',') as INDEX_COLUMNS
  from 
   (
       select C.INDEX_NAME
            , I.UNIQUENESS
            , C.COLUMN_NAME
            , C.COLUMN_POSITION COL_POS
         from USER_INDEXES     I
         ,    USER_IND_COLUMNS C
        where I.INDEX_NAME = C.INDEX_NAME
          and I.TABLE_NAME = :TABLE_NM
   )
 start with COL_POS = 1
connect by prior INDEX_NAME = INDEX_NAME 
       and prior COL_POS+1  = COL_POS
 group by INDEX_NAME, UNIQUENESS
 order by UNIQUENESS desc, INDEX_NAME;

;
-- 테이블 목록 조회
select A.TABLE_NAME, B.COMMENTS
  from USER_TABLES       A
  ,    USER_TAB_COMMENTS B
 where A.TABLE_NAME = B.TABLE_NAME
   and A.TABLE_NAME like '%'
;

select * from ALL_TAB_COLUMNS where COLUMN_NAME = 'DEPT_ID'
;
select * from ALL_OBJECTS
 where OWNER = 'POSERP'
   and OBJECT_NAME = 'PKG_PLD_ATTD_UTILS'
;
select * from ALL_SOURCE
 where OWNER = 'POSERP'
   --and NAME  = 'PKG_PLD_ATTD_UTILS'
;

-- 뷰 목록 조회
select * from USER_VIEWS;

-- 프로시져 목록 조회
select * from USER_PROCEDURES;
select * 
  from ALL_PROCEDURES
 where OWNER       = 'POSERP'
   and OBJECT_TYPE = 'PROCEDURE'
;
`
   and TYPE  = 'PROCEDURE'
;
-- 트리거 목록 조회
select * from USER_TRIGGERS;

-- DB Link 목록 조회
select * from ALL_DB_LINKS;
 
-- 소스 조회
select * 
  from USER_SOURCE
 where TEXT like '%TB_PL_RPAYRATE%'
;

-- 모듈 분류목록조회
select A.CLASS_CD, A.CLASS_CD_VALUE, B.META_ITEM_DESC, A.SORT_ORDER
  from TB_CM_CODE_VALUE    A
  ,    TB_CM_LANGUAGE_PACK B
 where A.LANGUAGE_PACK_ID = B.MGMT_OBJECT_ID
   and A.COMPANY_CD  = 'DEVW'
   and A.CLASS_CD    = 'MODULE_TP'
   and B.LANGUAGE_CD = 'ko'
;

-- 메시지 조회
select * from PFM_COMMSG
;

-- 메뉴목록 조회
select A.MODULE_TP, A.MENU_CD, A.PROGRAM_ID
     , decode(A.LVL, 1, B.META_ITEM_DESC) as LEVEL_1
     , decode(A.LVL, 2, B.META_ITEM_DESC) as LEVEL_2
     , decode(A.LVL, 3, B.META_ITEM_DESC) as LEVEL_3
     , decode(A.LVL, 4, B.META_ITEM_DESC) as LEVEL_4
     , A.PAGE_DESC
  from 
   (
       select level as LVL
            , A.COMPANY_CD, B.MODULE_TP , A.MENU_CD, A.PARENT_MENU_CD
            , A.MENU_LEVEL, A.SEQ_NO
            , A.PROGRAM_ID
            , A.LANGUAGE_PACK_ID
            , B.PAGE_DESC
         from TB_SM_MENU        A
         ,    TB_SM_SCREEN      B
        where 1=1
          and A.COMPANY_CD      = B.COMPANY_CD(+)
          and A.PROGRAM_ID      = B.PROGRAM_ID(+)
        start with A.COMPANY_CD = 'DEVW'
--               and A.MENU_CD    = 'PL'
               and A.PARENT_MENU_CD is null
                 
       connect by prior A.MENU_CD    = A.PARENT_MENU_CD
              and prior A.COMPANY_CD = A.COMPANY_CD
   ) A
  , TB_CM_LANGUAGE_PACK B
 where A.LANGUAGE_PACK_ID = B.MGMT_OBJECT_ID
   and B.LANGUAGE_CD      = 'ko'
;

-- 프로그램별 사이트 적용 내역
select *
  from TM_SEL_FILES A
  full outer join
  (
       select * from
          (
              select A.COMPANY_CD
                   , A.MODULE_TP 
                   , A.PROGRAM_ID, A.PROGRAM_NM
                   , A.PAGE_DESC
                   , B.MENU_CD
                   , B.MENU_NM   , B.SORT_KEY
                from
                 (   -- 시스템에 등록된 화면 목록
                     select A.COMPANY_CD, A.MODULE_TP
                          , A.PROGRAM_ID, max(B.META_ITEM_DESC) as PROGRAM_NM
                          , max(A.PAGE_DESC) as PAGE_DESC
                       from TB_SM_SCREEN        A
                       ,    TB_CM_LANGUAGE_PACK B
                      where A.LANGUAGE_PACK_ID = B.MGMT_OBJECT_ID
                        and B.LANGUAGE_CD      = 'ko'
                      group by A.COMPANY_CD, A.MODULE_TP
                             , A.PROGRAM_ID
                 ) A
                ,(
                     -- 고객사별 메뉴 구성
                     select A.COMPANY_CD, A.MENU_CD, A.PROGRAM_ID
                          , max(sys_connect_by_path(A.MENU_NM, '〉')) as MENU_NM
                          , max(sys_connect_by_path(to_char(A.SEQ_NO,'000') , '.' )) as SORT_KEY
                       from
                        (
                            select /*+ index(B TM_CM_LANGUAGE_PACK_PK) */
                                   A.COMPANY_CD, A.MENU_CD, A.PARENT_MENU_CD
                                 , A.PROGRAM_ID, A.LANGUAGE_PACK_ID
                                 , A.MENU_LEVEL, A.SEQ_NO
                                 , B.META_ITEM_DESC as MENU_NM
                              from TB_SM_MENU          A
                              ,    TB_CM_LANGUAGE_PACK B
                             where A.LANGUAGE_PACK_ID = B.MGMT_OBJECT_ID
                               and B.LANGUAGE_CD      = 'ko'
                        ) A
                      start with A.PARENT_MENU_CD is null
                     connect by prior A.MENU_CD    = A.PARENT_MENU_CD
                            and prior A.COMPANY_CD = A.COMPANY_CD
                      group by A.COMPANY_CD, A.MENU_CD, A.PROGRAM_ID
                 ) B
               where A.COMPANY_CD = B.COMPANY_CD(+)
                 and A.PROGRAM_ID = B.PROGRAM_ID(+) 
          )
       pivot
       (
           max(nvl2(SORT_KEY, 'Y', 'N'))
           for COMPANY_CD in
           (
               'DBGI',    'DEVW',    'DSNG',    'GBGI',    'GDRP'
             , 'GEMT',    'GEST',    'GHSI',    'PACM',    'PDIC'
             , 'PGRI',    'PHAL',    'PHIS',    'PKRT',    'PPTR'
             , 'PSFN',    'PSNG'
           )
       )
  ) B on(
            A.MODULE_TP = B.MODULE_TP
        and A.FILE_NM   = B.PROGRAM_ID||'.sel'
        )
order by nvl(A.MODULE_TP, B.MODULE_TP), nvl(A.FILE_NM, B.PROGRAM_ID)
;

-- 화면목록 조회
select '['||A.COMPANY_CD||'] '||A.COMPANY_NM as COMPANY
     , B.MODULE_TP
     , B.PROGRAM_ID, C.META_ITEM_DESC as PROGRAM_NM
     , B.PAGE_DESC 
  from TB_CM_COMPANY       A
  ,    TB_SM_SCREEN        B
  ,    TB_CM_LANGUAGE_PACK C
 where A.COMPANY_CD       = B.COMPANY_CD
   and B.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID
   and C.LANGUAGE_CD      = 'ko'
;
select A.COMPANY_CD, B.COMPANY_NM
     , A.MODULE_TP, A.PROGRAM_ID, C.META_ITEM_DESC as PROGRAM_NM
     , A.PAGE_DESC
  from TB_SM_SCREEN        A
  ,    TB_CM_COMPANY       B
  ,    TB_CM_LANGUAGE_PACK C
 where A.COMPANY_CD       = B.COMPANY_CD
   and A.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID
   and C.LANGUAGE_CD      = 'ko'
;
select * from TB_CM_LANGUAGE_PACK ;

select A.FILE_NM, B.*
  from TM_SEL_FILES        A
  full outer join
  (
       select A.MODULE_TP, A.PROGRAM_ID, C.META_ITEM_DESC as PROGRAM_NM, A.PAGE_DESC, A.COMPANY_CD, B.COMPANY_NM
         from TB_SM_SCREEN        A
         ,    TB_CM_COMPANY       B
         ,    TB_CM_LANGUAGE_PACK C
        where A.COMPANY_CD       = B.COMPANY_CD
          and A.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID
          and C.LANGUAGE_CD      = 'ko'
  ) B on
      (
          A.MODULE_TP = B.MODULE_TP
      and A.FILE_NM   = B.PROGRAM_ID||'.sel'
      )
    
;
with V_SCREEN as
     (
         select * from
            (
                select nvl(A.MODULE_TP, B.MODULE_TP) as MODULE_TP
                     , B.PROGRAM_ID, A.FILE_NM
                     , B.PROGRAM_NM
                     , B.PAGE_DESC
                     , B.COMPANY_CD, B.COMPANY_NM
                  from TM_SEL_FILES        A
                  full outer join
                  (
                       select A.MODULE_TP
                            , A.PROGRAM_ID, C.META_ITEM_DESC as PROGRAM_NM
                            , A.PAGE_DESC, A.COMPANY_CD, B.COMPANY_NM
                         from TB_SM_SCREEN        A
                         ,    TB_CM_COMPANY       B
                         ,    TB_CM_LANGUAGE_PACK C
                        where A.COMPANY_CD       = B.COMPANY_CD
                          and A.LANGUAGE_PACK_ID = C.MGMT_OBJECT_ID
                          and C.LANGUAGE_CD      = 'ko'
                  ) B on
                      (
                          A.MODULE_TP = B.MODULE_TP
                      and A.FILE_NM   = B.PROGRAM_ID||'.sel'
                      )
            )
         pivot
         (
             max(COMPANY_NM)
             for COMPANY_CD in
             (
                'DBGI',    'DEVW',    'DSNG',    'GBGI',    'GDRP'
              , 'GEMT',    'GEST',    'GHSI',    'PACM',    'PDIC'
              , 'PGRI',    'PHAL',    'PHIS',    'PKRT',    'PPTR'
              , 'PSFN',    'PSNG'
             )
         )
     )
select * 
  from V_SCREEN A

order by 1, 2
;
select * from TB_SM_SCREEN;
-- 객체별 테이블 참조 내역 조회
select A.NAME
     , A.TYPE
     , A.REFERENCED_NAME
     , A.REFERENCED_TYPE
  from DBA_DEPENDENCIES A
  ,    DBA_TABLES       B
 where A.OWNER           = B.OWNER(+)
   and A.REFERENCED_NAME = B.TABLE_NAME(+)
   
   and A.OWNER           = 'POSERP'
   and A.TYPE            in
       (
           'FUNCTION', 'PROCEDURE', 'PACKAGE BODY'
         , 'TRIGGER'
         , 'VIEW'    , 'TYPE'
       )
 order by A.TYPE, A.NAME
;

-- 최근 실행 쿼리 조회
select T1.SQL_TEXT 
  from
   ( 
       select SQL_TEXT 
         from V$SQL 
        where SQL_TEXT like '%TB_PL_ODEPT_M%'
        order by FIRST_LOAD_TIME desc
   ) T1
 where 1=1
--   and rownum = 1
;


-- 고객사별 공통코드 사용여부
select * from
   (
       select A.COMPANY_CD                     -- 회사코드
            , A.MODULE_TP                      -- 업무구분
            , (
                  select META_ITEM_DESC 
                    from TB_CM_LANGUAGE_PACK
                   where LANGUAGE_CD = 'ko'
                     and MGMT_OBJECT_ID = A.LANGUAGE_PACK_ID
              ) as CLASS_NM                    -- 유형명
            , A.CLASS_CD                       -- 유형코드
            , (
                  select META_ITEM_DESC 
                    from TB_CM_LANGUAGE_PACK
                   where LANGUAGE_CD = 'ko'
                     and MGMT_OBJECT_ID = B.LANGUAGE_PACK_ID
              ) as CLASS_CD_NM                 -- 유형별코드명     
            , B.CLASS_CD_VALUE                 -- 유형별코드값
            , case when A.USE_YN != 'Y' then 'N'
                   else decode(B.USE_YN, 'Y', 'Y', 'N')
              end as USE_YN                    -- 사용여부
         from TB_CM_CODE_CLASS    A
         ,    TB_CM_CODE_VALUE    B
        where 1=1
          and A.COMPANY_CD  = B.COMPANY_CD(+)
          and A.CLASS_CD    = B.CLASS_CD(+)
   )
pivot
(
    max(USE_YN) for COMPANY_CD in
    (
        'DBGI',    'DEVW',    'DSNG',    'GBGI',    'GDRP'
      , 'GEMT',    'GEST',    'GHSI',    'PACM',    'PDIC'
      , 'PGRI',    'PHAL',    'PHIS',    'PKRT',    'PPTR'
      , 'PSFN',    'PSNG'
    )
)
 order by MODULE_TP, CLASS_CD, CLASS_CD_VALUE
 ;
select * from TB_CM_CODE_CLASS where COMPANY_CD = 'PHAL';


;
select *
  from
   (
       select 'Y' as APPLY_YN
            , A.COMPANY_CD     , A.MODULE_TP
            , 'TB_CM_CODE_CLASS' as TABLE_NM
            , (
                  select '▷ '||META_ITEM_DESC 
                    from TB_CM_LANGUAGE_PACK
                   where LANGUAGE_CD    = 'ko'
                     and MGMT_OBJECT_ID = A.LANGUAGE_PACK_ID
              ) as CLASS_NM
            , A.LANGUAGE_PACK_ID as CLASS_LANG_ID
            , A.CLASS_CD
            , ''   as CODE_NM
            , null as CODE_LANG_ID
            , ' '  as CLASS_CD_VALUE
            , A.USE_YN
            , null as SORT_ORDER
--            , A.CD_VALUE_MAX_LTH, A.CODE_TBL_USE_YN
--            , A.LOV_YN          , A.MANAGE_RESP_YN 
            , to_char(A.CD_VALUE_MAX_LTH)  as ATTRIBUTE1
            , A.CODE_TBL_USE_YN    as ATTRIBUTE2
            , A.LOV_YN             as ATTRIBUTE3, A.MANAGE_RESP_YN  as ATTRIBUTE4
            , '' as ATTRIBUTE5
            , '' as ATTRIBUTE6, '' as ATTRIBUTE7, '' as ATTRIBUTE8, '' as ATTRIBUTE9, '' as ATTRIBUTE10
         from TB_CM_CODE_CLASS A
        where A.COMPANY_CD = 'PHAL'
       union
       select nvl2(B.COMPANY_CD, 'Y', 'N') as APPLY_YN
            , B.COMPANY_CD     , A.MODULE_TP
            , 'TB_CM_CODE_VALUE' as TABLE_NM
            , (
                  select META_ITEM_DESC 
                    from TB_CM_LANGUAGE_PACK
                   where LANGUAGE_CD    = 'ko'
                     and MGMT_OBJECT_ID = A.CLASS_LANG_ID
              ) as CLASS_NM
            , A.CLASS_LANG_ID
            , A.CLASS_CD
            , (
                  select META_ITEM_DESC 
                    from TB_CM_LANGUAGE_PACK
                   where LANGUAGE_CD = 'ko'
                     and MGMT_OBJECT_ID = B.CODE_LANG_ID
              ) as CODE_NM
            , B.CODE_LANG_ID
            , A.CLASS_CD_VALUE
            , B.CODE_USE_YN as USE_YN
            , B.SORT_ORDER
--            , B.CD_VALUE_MAX_LTH, B.CODE_TBL_USE_YN
--            , B.LOV_YN          , B.MANAGE_RESP_YN 
            , B.ATTRIBUTE1    , B.ATTRIBUTE2    , B.ATTRIBUTE3    , B.ATTRIBUTE4    , B.ATTRIBUTE5
            , B.ATTRIBUTE6    , B.ATTRIBUTE7    , B.ATTRIBUTE8    , B.ATTRIBUTE9    , B.ATTRIBUTE10
         from
          (
              select A.MODULE_TP       , A.CLASS_CD
                   , A.LANGUAGE_PACK_ID as CLASS_LANG_ID
                   , A.CD_VALUE_MAX_LTH, A.CODE_TBL_USE_YN
                   , A.LOV_YN          --, MANAGE_RESP_YN  -- 고객사별로 다름
                   , B.CLASS_CD_VALUE
                   --, B.LANGUAGE_PACK_ID as CODE_LANG_ID  -- 고객사별로 다름
                from TB_CM_CODE_CLASS A
                ,    TB_CM_CODE_VALUE B
               where A.COMPANY_CD = B.COMPANY_CD(+)
                 and A.CLASS_CD   = B.CLASS_CD(+)
               group by A.MODULE_TP       , A.CLASS_CD
                      , A.LANGUAGE_PACK_ID
                      , A.CD_VALUE_MAX_LTH, A.CODE_TBL_USE_YN
                      , A.LOV_YN          --, MANAGE_RESP_YN
                      , B.CLASS_CD_VALUE
                      --, B.LANGUAGE_PACK_ID
          ) A
         ,(
              select A.COMPANY_CD      , A.MODULE_TP       , A.CLASS_CD
                   , A.LANGUAGE_PACK_ID as CLASS_LANG_ID
                   , A.USE_YN as CLASS_USE_YN
                   , A.CD_VALUE_MAX_LTH, A.CODE_TBL_USE_YN
                   , A.LOV_YN          , A.MANAGE_RESP_YN 
                   , B.CLASS_CD_VALUE
                   , B.LANGUAGE_PACK_ID as CODE_LANG_ID
                   , B.SORT_ORDER
                   , B.USE_YN  as CODE_USE_YN
                   , B.ATTRIBUTE1    , B.ATTRIBUTE2    , B.ATTRIBUTE3    , B.ATTRIBUTE4    , B.ATTRIBUTE5
                   , B.ATTRIBUTE6    , B.ATTRIBUTE7    , B.ATTRIBUTE8    , B.ATTRIBUTE9    , B.ATTRIBUTE10
                from TB_CM_CODE_CLASS A
                ,    TB_CM_CODE_VALUE B
               where A.COMPANY_CD = B.COMPANY_CD(+)
                 and A.CLASS_CD   = B.CLASS_CD(+)
                 and A.COMPANY_CD = 'PHAL'
          ) B
        where A.MODULE_TP      = B.MODULE_TP(+)
          and A.CLASS_CD       = B.CLASS_CD(+)
          and A.CLASS_CD_VALUE = B.CLASS_CD_VALUE(+)
   )
 order by MODULE_TP, CLASS_CD, CLASS_CD_VALUE
;

select * from TB_CM_COMPANY
;
-- 고객사별 공통코드 조회
select A.COMPANY_CD                     -- 회사코드
     , A.MODULE_TP                      -- 업무구분
     , (
           select META_ITEM_DESC 
             from TB_CM_LANGUAGE_PACK
            where LANGUAGE_CD = 'ko'
              and MGMT_OBJECT_ID = A.LANGUAGE_PACK_ID
       ) as CLASS_NM                    -- 유형명
     , A.LANGUAGE_PACK_ID as CLASS_PACK_ID
     , A.CLASS_CD                       -- 유형코드
     , (
           select META_ITEM_DESC 
             from TB_CM_LANGUAGE_PACK
            where LANGUAGE_CD = 'ko'
              and MGMT_OBJECT_ID = B.LANGUAGE_PACK_ID
       ) as CLASS_CD_NM                 -- 유형별코드명
     , B.LANGUAGE_PACK_ID as CODE_PACK_ID
     , B.CLASS_CD_VALUE                 -- 유형별코드값
     --, B.SORT_ORDER                     -- 정렬순서
     , B.USE_YN                         -- 사용여부
     , B.ATTRIBUTE1	                    -- 속성값1
     , B.ATTRIBUTE2	                    -- 속성값2
     , B.ATTRIBUTE3	                    -- 속성값3
     , B.ATTRIBUTE4	                    -- 속성값4
     , B.ATTRIBUTE5	                    -- 속성값5
     , B.ATTRIBUTE6	                    -- 속성값6
     , B.ATTRIBUTE7	                    -- 속성값7
     , B.ATTRIBUTE8	                    -- 속성값8
     , B.ATTRIBUTE9	                    -- 속성값9
     , B.ATTRIBUTE10                    -- 속성값10 
  from TB_CM_CODE_CLASS    A
  ,    TB_CM_CODE_VALUE    B
 where 1=1
   and A.COMPANY_CD  = B.COMPANY_CD(+)
   and A.CLASS_CD    = B.CLASS_CD(+)
   and A.COMPANY_CD  = 'PHAL' -- 포스하이알

   --and B.CLASS_CD_VALUE like '%'||nvl(:CD_VALUE, B.CLASS_CD_VALUE)||'%'

 order by A.COMPANY_CD, A.MODULE_TP, A.CLASS_CD, B.SORT_ORDER
;

select * from DBA_DEPENDENCIES;
select * from TB_CM_CODE_VALUE where LANGUAGE_PACK_ID = 1166237;
select * from TB_SM_SCREEN;
select * from TB_SM_MENU A, TB_SM_SCREEN B where A.COMPANY_CD = B.COMPANY_CD and A.PROGRAM_ID = B.PROGRAM_ID ;
select * from TB_SM_MENU where PARENT_MENU_CD is null;
select * from TB_SM_UI_TABLE;


-- 화면파일관리
drop table TM_SEL_FILES;
create table TM_SEL_FILES
(
    MODULE_TP   varchar2(   2)      not null
  , FILE_NM     varchar2( 200)      not null

  , constraint PK_SEL_FILES primary key
    (
        MODULE_TP, FILE_NM
    )
);
select * from TB_CM_LANGUAGE_PACK;

-- 코드목록 조회
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
                    'PLH_JOBPST_CD'     -- 직책명
                  , 'PLH_JOBGRD_CD'     -- 직급명
                  , 'PLH_JOBTIT_CD'     -- 직위명
                  , 'PLD_WRKGRP_CD'     -- 근무조명
                  , 'PLD_WRKTYPE_CD'    -- 근무형태명
                )
     )
select * from V_CODE
;


select * from
   (
       select MGMT_OBJECT_ID, LANGUAGE_CD, META_ITEM_DESC
         from TB_CM_LANGUAGE_PACK
        where LANGUAGE_CD in
              (
                  'ko',    'en' 
                --, 'ja',    'zh'  -- DB에서 다국어지원 설정이 제대로 안되어 있어 깨져나오므로 일단 무시
              )
        order by MGMT_OBJECT_ID, LANGUAGE_CD
   )
pivot
(
    max(META_ITEM_DESC)
    for LANGUAGE_CD in
    (
        'ko',    'en' 
      --, 'ja',    'zh'  -- DB에서 다국어지원 설정이 제대로 안되어 있어 깨져나오므로 일단 무시
    )
)
;
