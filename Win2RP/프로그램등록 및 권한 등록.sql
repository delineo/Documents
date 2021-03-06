/* 화면 등록 및 권한 설정 */
/* 화면명을 위한 다국어 등록 */
insert into TB_CM_LANGUAGE_PACK
(
    MGMT_OBJECT_ID
  , LANGUAGE_CD             , META_ITEM_DESC
  , CREATED_OBJECT_ID       , CREATED_PROGRAM_ID      , CREATION_TIMESTAMP     , CREATION_LOCAL_TIMESTAMP  
)
select (
           select SQ_CM_LANGUAGE_PACK.nextval
             from dual
       ) as MGMT_OBJECT_ID
     , 'KO'             as LANGUAGE_CD
     , '화면명'         as META_ITEM_DESC
     , 'script'         as CREATED_OBJECT_ID
     , 'script'         as CREATED_PROGRAM_ID
     , systimestamp     as CREATION_TIMESTAMP
     , systimestamp     as CREATION_LOCAL_TIMESTAMP
  from dual
;

-- MGMT_OBJECT_ID 을 Screen 명에 등록해야함

-- 이걸로 화면등록... 그리고???
insert into TB_SM_SCREEN
(
    COMPANY_CD
  , PROGRAM_ID      , MODULE_TP       , RESPONSIBILITY_VAL
  , ACCESS_RESP_YN  , EXPORT_RESP_YN  , SAVE_RESP_YN  , DELETE_RESP_YN  , APPROVAL_RESP_YN
  , LANGUAGE_PACK_ID, PAGE_DESC
)
select A.COMPANY_CD
     , B.*
  from
   (
       select COMPANY_CD
         from TB_CM_COMPANY
        where COMPANY_CD = nvl(:COMPANY_CD, COMPANY_CD)
   ) A
  ,(
       select 'programID' as PROGRAM_ID
            , 'CM'        as MODULE_TP
            , ''          as RESPONSIBILITY_VAL  -- 권한지정값 -- 특수권한
            , ''          as ACCESS_RESP_YN      -- 접근권한  (SELECT  )
            , ''          as EXPORT_RESP_YN      -- EXPORT권한(EXPORT  )
            , ''          as SAVE_RESP_YN        -- 저장권한  (SAVE    )
            , ''          as DELETE_RESP_YN      -- 삭제권한  (DELETE  )
            , ''          as APPROVAL_RESP_YN    -- 승인권한  (APPROVAL)
            , 0           as LANGUAGE_PACK_ID
            , (
                  ''
              )           as PAGE_DESC           -- 화면설명
         from dual
   ) B
;

/* 메뉴 등록 및 권한 설정
/* 메뉴명을 위한 다국어 등록 */
insert into TB_CM_LANGUAGE_PACK
(
    MGMT_OBJECT_ID
  , LANGUAGE_CD             , META_ITEM_DESC
  , CREATED_OBJECT_ID       , CREATED_PROGRAM_ID      , CREATION_TIMESTAMP     , CREATION_LOCAL_TIMESTAMP  
)
select (
           select SQ_CM_LANGUAGE_PACK.nextval
             from dual
       ) as MGMT_OBJECT_ID
     , 'KO'             as LANGUAGE_CD
     , '화면명'         as META_ITEM_DESC
     , 'script'         as CREATED_OBJECT_ID
     , 'script'         as CREATED_PROGRAM_ID
     , systimestamp     as CREATION_TIMESTAMP
     , systimestamp     as CREATION_LOCAL_TIMESTAMP
  from dual
;

insert into TB_SM_MENU
;
select A.COMPANY_CD
     , ''                                   as MENU_CD
     , (B.LAST_SEQ_NO + 1)                  as SEQ_NO
     , to_char(to_number(B.MENU_LEVEL)+1)   as MENU_LEVEL
     , B.MENU_CD                            as PARENT_MENU_CD
     , 'N'                                  as MENU_GROUPYN
     , ''                                   as PROGRAM_ID
     , ''                                   as LANGUAGE_PACK_ID
     , 'script'                             as CREATED_OBJECT_ID
     , 'script'                             as CREATED_PROGRAM_ID
     , systimestamp                         as CREATION_TIMESTAMP
     , systimestamp                         as CREATION_LOCAL_TIMESTAMP
  from
   (
       select COMPANY_CD
         from TB_CM_COMPANY
   ) A
  ,(
       select COMPANY_CD, MENU_CD, MENU_LEVEL
            , (
                  select max(SEQ_NO)
                    from TB_SM_MENU
                   where COMPANY_CD = A.COMPANY_CD
                     and PARENT_MENU_CD = A.MENU_CD
                   group by COMPANY_CD
              ) as LAST_SEQ_NO
         from TB_SM_MENU A
   ) B
 where A.COMPANY_CD = B.COMPANY_CD
   and A.COMPANY_CD = nvl(:COMPANY_CD, A.COMPANY_CD)
   and B.MENU_CD    = 'PPG'
;

/* 메뉴 등록했으니 역할 등록 */
select COMPANY_CD, ROLE_CD 
  from TB_SM_ROLE
 where ROLE_CD = 'E' -- 일단 전체권한
;
select * 
  from TB_SM_ROLE_MENU_ASSOCIATION
 where COMPANY_CD = 'DEVW' and ROLE_CD = 'E'