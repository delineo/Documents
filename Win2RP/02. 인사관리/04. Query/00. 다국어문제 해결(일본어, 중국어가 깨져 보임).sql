-- 다국어 지원시 문제점 해결
-- http://blog.naver.com/PostView.nhn?blogId=lcoguss&logNo=188493336

-- 다국어 지원하기 위해서는 문자열은 NVARCHAR를 사용해야함
-- 또한, CHARACTER SET 은 AL32UTF8로 지정해야함.
-- 이렇게 변경할때 기존에 저장된 한글은 모두 깨져버림.
-- 따라서, 반드시 백업하고, 수행할것.
;
-- SYS 권한이 필요하구만 ㅡㅡ^
select distinct
       (NLS_CHARSET_NAME(CHARSETID)) as CHARACTER_SET
     , decode
       (
           TYPE#
         ,  1, decode
               (
                   CHARSETFORM
                 , 1, 'VARCHAR2'
                 , 2, 'NVARCHAR2'
                 , 'UNKNOWN'
               )
         ,  9, decode
               (
                   CHARSETFORM
                 , 1, 'VARCHAR'
                 , 2, 'NCHAR VARYING'
                 , 'UNKNOWN'
               )
         , 96, decode
               (
                   CHARSETFORM
                 , 1, 'CHAR'
                 , 2, 'NCHAR'
                 , 'UNKNOWN'
               )
         ,112, decode
               (
                   CHARSETFORM
                 , 1, 'CLOB'
                 , 2, 'NCLOB'
                 , 'UNKNOWN'
               )
       )
  from SYS.COL$
 where CHARSETFORM in (1, 2)
   and TYPE# in ( 1, 9, 96, 112 )
;


--        펌...
--        EXP-00008: ORACLE 오류 6552가 발생했습니다
--        ORA-06552: PL/SQL: Compilation unit analysis terminated
--        ORA-06553: PLS-553: 알 수 없는 문자 집합 이름입니다
--         character set 이 섞였기 때문이다.
--         
--        /* Formatted on 2009/01/31 00:30 (Formatter Plus v4.8.8) */
--        SELECT DISTINCT (NLS_CHARSET_NAME (CHARSETID)) CHARACTERSET,
--                        DECODE (type#,
--                                1, DECODE (CHARSETFORM,
--                                           1, 'VARCHAR2',
--                                           2, 'NVARCHAR2',
--                                           'UNKOWN'
--                                          ),
--                                9, DECODE (CHARSETFORM,
--                                           1, 'VARCHAR',
--                                           2, 'NCHAR VARYING',
--                                           'UNKOWN'
--                                          ),
--                                96, DECODE (CHARSETFORM,
--                                            1, 'CHAR',
--                                            2, 'NCHAR',
--                                            'UNKOWN'
--                                           ),
--                                112, DECODE (CHARSETFORM,
--                                             1, 'CLOB',
--                                             2, 'NCLOB',
--                                             'UNKOWN'
--                                            )
--                               ) types_used_in
--                   FROM SYS.col$
--                  WHERE CHARSETFORM IN (1, 2) AND type# IN (1, 9, 96, 112);
--
--        결과에서
--        CHARACTERSET                            TYPES_USED_IN
--        -----------------------------------------------------
--        AL16UTF16                               NCHAR
--        AL16UTF16                               NVARCHAR2
--        AL16UTF16                               NCLOB
--        AL32UTF8                                CHAR
--        AL32UTF8                                VARCHAR2
--        AL32UTF8                                CLOB
--
--        위처럼이 아니라
--         
--        CHARACTERSET                            TYPES_USED_IN
--        -----------------------------------------------------
--         AL16UTF16                               NCHAR
--         AL16UTF16                               NVARCHAR2
--         AL16UTF16                               NCLOB
--         US7ASCII                                CHAR
--         US7ASCII                                VARCHAR2
--         WE8DEC                                  VARCHAR2
--        US7ASCII                                CLOB
--
--        이런 식으로 하나의 varchar2 에 대해 2개의 characterset 이 나온다면 mix 된 것이다.
--         
--        이 문제에 대한 처리는 아래처럼 하도록 한다.
--         
--        a) INIT.ORA 안에 있는 parallel_server parameter 가 false 거나 아예 세팅되어있지 않은지 확인한다
--           SQL>show parameter parallel_server
--
--        b) 다음스크립트를 SQLPLUS 에서 "as sysdba"로 수행한다.
--           (물론 백업을 해두는 것도 있지 말자!)
--
--           SHUTDOWN IMMEDIATE;
--           STARTUP MOUNT;
--           ALTER SYSTEM ENABLE RESTRICTED SESSION;
--           ALTER SYSTEM SET JOB_QUEUE_PROCESSES=0;
--           ALTER SYSTEM SET AQ_TM_PROCESSES=0;
--           ALTER DATABASE OPEN;
--           COL VALUE NEW_VALUE CHARSET
--           SELECT VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER='NLS_CHARACTERSET';
--           COL VALUE NEW_VALUE NCHARSET
--           SELECT VALUE FROM NLS_DATABASE_PARAMETERS WHERE PARAMETER='NLS_NCHAR_CHARACTERSET';
--           ALTER DATABASE CHARACTER SET INTERNAL_USE &CHARSET;
--           ALTER DATABASE NATIONAL CHARACTER SET INTERNAL_USE &NCHARSET;
--           SHUTDOWN IMMEDIATE;
--           STARTUP;
--           -- yes, 2 times startup/shutdown . This is not a typo
--           SHUTDOWN IMMEDIATE;
--           STARTUP;
--
--        c) 만약 parallel_server parameter 를 고쳤다면 다시 원상복구한다.
--         
--        This script doesn't change anything for the data that is already stored, but it 
--        re-enforces database character set to be known in all places where it should be 
--        stored
--         
--        위 스크립트는 이미 저장된 데이터들을 바꾸지는 않는다. 단지 database 의 character set 을 그것이 저장되어지는 모든 장소에 다시 강제적으로 세팅할 뿐이다.