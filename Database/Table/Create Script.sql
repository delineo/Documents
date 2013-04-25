drop table TB_USERS;
-- USER INFO
create table TB_USERS
(
    USER_ID         varchar(15)     not null    comment '사용자ID'
  , USER_NM         varchar(30)     not null    comment '사용자 명'
  , USER_PWD        varchar(60)     not null    comment '사용자 암호'
  
  , USE_YN          varchar(1)      not null    comment '사용여부'
 
  , primary key PK_USER ( USER_ID )
)
comment = '사용자 정보';
;

insert into TB_USERS
(
    user_id
  , user_nm
  , user_pwd
  , use_yn
)
values
(
    'admin'
  , '관리자'
  , old_password('admin')
  , 'Y'
)

create table TB_PACKAGES
(
    PACKAGE_ID      int unsigned     not null   auto_increment      comment '패키지ID'
  , PACKAGE_CD      varchar(100)                                    comment '패키지코드'
  , UP_PACKAGE_ID   int unsigned                                    comment '상위패키지ID'
  , PACKAGE_NM      varchar(100)                                    comment '패키지명'
  , PACKAGE_DESC    varchar(2000)                                   comment '패키지설명'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_PACKAGES ( PACKAGE_ID )
)
comment = '패키지';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_PACKAGES_INSERT before insert on TB_PACKAGES
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_PACKAGES_UPDATE before update on TB_PACKAGES
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;

--drop table TB_SCRIPTS;
-- JavaScript list
create table TB_SCRIPTS
(
    SCRIPT_ID       int unsigned     not null   auto_increment      comment '스크립트ID'
  , PACKAGE_ID      int unsigned     not null                       comment '패키지ID'
  , SCRIPT_NM       varchar(100)     not null                       comment '스크립트명'
  , SRC_BODY        longtext         not null                       comment '스크립트본체(원본)'
  , SRC_COMPRESS    longtext         not null                       comment '스크립트본체(압축형)'
  , SCRIPT_DESC     text                                            comment '스크립트 설명'

  , VER_MAJ         tinyint unsigned                                comment '버전 Major'
  , VER_MIN         tinyint unsigned                                comment '버전 Minor'
  , VER_MIC         tinyint unsigned                                comment '버전 Micro'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_SCIRPTS ( SCRIPT_ID )
  , unique  key UK_SCIRPTS ( PACKAGE_ID, SCRIPT_NM )
)
comment = '자바스크립트';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_SCRIPTS_INSERT before insert on TB_SCRIPTS
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_SCRIPTS_UPDATE before update on TB_SCRIPTS
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;

--drop table TB_SCRIPTS_HIST;

create table TB_SCRIPTS_HIST
(
    HISTORY_ID      int unsigned     not null                       comment '이력ID'
  , SCRIPT_ID       int unsigned     not null                       comment '스크립트ID'
  , PACKAGE_ID      int unsigned     not null                       comment '패키지ID'
  , SCRIPT_NM       varchar(100)     not null                       comment '스크립트명'
  , SRC_BODY        longtext         not null                       comment '스크립트본체(원본)'
  , SRC_COMPRESS    longtext         not null                       comment '스크립트본체(압축형)'
  , SCRIPT_DESC     text                                            comment '스크립트 설명'

  , VER_MAJ         tinyint unsigned                                comment '버전 Major'
  , VER_MIN         tinyint unsigned                                comment '버전 Minor'
  , VER_MIC         tinyint unsigned                                comment '버전 Micro'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_SCRIPTS_HIST ( HISTORY_ID )
)
comment = '자바스크립트관리이력';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_SCRIPTS_HIST_INSERT before insert on TB_SCRIPTS_HIST
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_SCRIPTS_HIST_UPDATE before update on TB_SCRIPTS_HIST
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;

-----------------------------------------------------

--drop table TB_CSS;
-- JavaScript list
create table TB_CSS
(
    CSS_ID          int unsigned     not null   auto_increment      comment '스타일시트ID'
  , PACKAGE_ID      int unsigned     not null                       comment '패키지ID'
  , CSS_NM          varchar(100)     not null                       comment '스타일시트명'
  , SRC_BODY        longtext         not null                       comment '스타일시트본체(원본)'
  , SRC_COMPRESS    longtext         not null                       comment '스타일시트본체(압축형)'
  , CSS_DESC        text                                            comment '스타일시트 설명'

  , VER_MAJ         tinyint unsigned                                comment '버전 Major'
  , VER_MIN         tinyint unsigned                                comment '버전 Minor'
  , VER_MIC         tinyint unsigned                                comment '버전 Micro'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_CSS ( CSS_ID )
  , unique  key UK_CSS ( PACKAGE_ID, CSS_NM )
)
comment = '스타일시트';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_CSS_INSERT before insert on TB_CSS
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_CSS_UPDATE before update on TB_CSS
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;

--drop table TB_CSS_HIST;

create table TB_CSS_HIST
(
    HISTORY_ID      int unsigned     not null                       comment '이력ID'
  , CSS_ID          int unsigned     not null                       comment '스타일시트ID'
  , PACKAGE_ID      int unsigned     not null                       comment '패키지ID'
  , CSS_NM          varchar(100)     not null                       comment '스타일시트명'
  , SRC_BODY        longtext         not null                       comment '스타일시트본체(원본)'
  , SRC_COMPRESS    longtext         not null                       comment '스타일시트본체(압축형)'
  , SCRIPT_DESC     text                                            comment '스타일시트설명'

  , VER_MAJ         tinyint unsigned                                comment '버전 Major'
  , VER_MIN         tinyint unsigned                                comment '버전 Minor'
  , VER_MIC         tinyint unsigned                                comment '버전 Micro'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_CSS_HIST ( HISTORY_ID )
)
comment = '스타일시트관리이력';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_CSS_HIST_INSERT before insert on TB_CSS_HIST
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_CSS_HIST_UPDATE before update on TB_CSS_HIST
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;


--drop table TB_SYS_CONFIG;

create table TB_SYS_CONFIG
(
    CONFIG_ID       int unsigned     not null   auto_increment      comment '설정ID'
  , PARENT_ID       int unsigned                                    comment '상위설정ID'
  , KEY_NM          varchar(50)      not null                       comment '설정키명'
  , KEY_VAL         varchar(255)                                    comment '설정키값'
  , KEY_DESC        text                                            comment '설정키설명'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_SYS_CONFIG ( CONFIG_ID )
  , unique  key UK_SYS_CONFIG ( PARENT_ID, KEY_NM )
  , foreign key FK_SYS_CONNECT( PARENT_ID )
        references TB_SYS_CONFIG ( CONFIG_ID )
)
comment = '시스템설정';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_SYS_CONFIG_INSERT before insert on TB_SYS_CONFIG
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_SYS_CONFIG_UPDATE before update on TB_SYS_CONFIG
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;


insert into TB_SYS_CONFIG
(
    PARENT_ID, KEY_NM, KEY_VAL, KEY_DESC
  , CREATE_USER, UPDATE_USER
)
values
(
    null, 'DB_CONFIG', '', 'Database Configuration'
  , 'admin', 'admin'
);
insert into TB_SYS_CONFIG
(
    PARENT_ID, KEY_NM, KEY_VAL, KEY_DESC
  , CREATE_USER, UPDATE_USER
)
select (
           select CONFIG_ID from TB_SYS_CONFIG
            where KEY_NM='DB_CONFIG'
       ) as PARENT_ID
      , 'DS_DEFAULT', 'DS_PLANZ', 'Default Datasource'
      , 'admin', 'admin'
;


drop function if exists tb_sys_config_path;

delimiter //

/* oracle sys_connect_by_path 대체함수 - TB_SYS_CONFIG 테이블 전용 */
create function tb_sys_config_path(node int)
returns text
not deterministic
reads sql data
begin

    declare _key        text;
    declare _path       text;
    declare _id         int;

    /* 예외 핸들러 : select 구문에서 Record를 찾지 못할 경우 */
    declare exit handler for not found
        return _path;
    
    set _path = null;
    set _id   = node;

    loop
        select KEY_NM, PARENT_ID
          into _key, _id
          from TB_SYS_CONFIG
         where CONFIG_ID = _id;
        
        if _path is not null then
            set _path = concat(_key, '.', _path);
        else
            set _path = _key;
        end if;
                
    end loop;
end //
delimiter ;


/*
insert into TB_SYS_CONFIG
(
    PARENT_ID, KEY_NM, KEY_VAL, KEY_DESC
  , CREATE_USER, UPDATE_USER
)
select (
           select CONFIG_ID from TB_SYS_CONFIG
            where KEY_NM = 'DB_CONFIG'
       ) as PARENT_ID
     , 'DATA_SOURCES' as KEY_NM
     , ''             as KEY_VAL
     , 'Data source list' as KEY_DESC
     , 'admin' as CREATE_USER
     , 'admin' as UPDATE_USER
;



/* 지정한 노드로부터 최상위 노드까지의 경로 탐색 */
select concat(repeat('  ', level  - 1), d.KEY_NM) as name
     , d.CONFIG_ID, d.PARENT_ID
     , func.level
  from
   (
       select B._id, @lv2 := @lv2 + 1 AS level
         from
          (
              select @r as _id
                   , (
                         select @r := Parent_Id
                           from TB_SYS_CONFIG
                          where CONFIG_ID = _id
                     ) as parent
                   , @l := @l +1 AS lv
                from 
                 (
                     select @r := 2 -- start id
                          , @l := 0 -- level id (fixed)
                 ) vars
                ,    TB_SYS_CONFIG d
               where @r <> 0
               order by lv desc
          ) B
         ,(
              select @lv2 := 0
          ) vars2
   ) func
  join TB_SYS_CONFIG d 
    on func._id = d.CONFIG_ID
;

/* Tree 로 조회하기위한 함수 */
drop function if exists connect_by_parent;

delimiter //

create function connect_by_parent
(
       
) returns int
not deterministic
reads sql data
begin
    declare _id INT;
    declare _parent INT;
    declare continue HANDLER for not FOUND set @id = null;
 
    set _parent = @id;
    set _id = -1;

    if @id is null then
        return null;
    end if;
 
    loop
        select min(Id)
          into @id
          from Dept
         where Parent_id = _parent
           and Id > _id;
        
        if @id is not null or _parent = @start_with then
            set @level = @level + 1;
            return @id;
        end if;
  
        set @level := @level - 1;
        
        select Id, Parent_id
          into _id, _parent
          from Dept
         where Id = _parent;
    end loop;
end //
delimiter ;


*/



















--drop table TB_DATASOURCE;

create table TB_DATASOURCE
(
    DS_NM           varchar(50)      not null                       comment 'DataSoruce 명'
  , DS_TYPE         varchar(255)     not null                       comment 'DataSoruce 유형'
  , URL             varchar(255)     not null                       comment 'DataSoruce 경로'
  , DRIVER          varchar(255)     not null                       comment 'Driver 클래스 명'

  , USER_ID         varchar(50)      not null                       comment '사용자 ID'
  , USER_PWD        varchar(50)      not null                       comment '사용자 인증 암호'

  , CONN_MAX_CNT    int unsigned                                    comment '연결자 최대수 ( 0 : 무제한 )'
  , CONN_IDLE_CNT   int unsigned                                    comment '동시대기 연결자 최대수 ( 0 : 무제한 )'
  , CONN_WAIT_TMOUT int unsigned                                    comment '연결자 최대 대기시간'
  
  , QUERY_TMOUT     int unsigned                                    comment '쿼리 최대 실행시간'
  , QUERY_TEST      varchar(255)                                    comment '테스트용 쿼리'

  , CREATE_DT       datetime         default '1000-00-00 00:00:00'  comment '생성일시'
  , CREATE_USER     varchar(15)      not null                       comment '생성자ID'
  , UPDATE_DT       datetime         default '1000-00-00 00:00:00'  comment '수정일시'
  , UPDATE_USER     varchar(15)      not null                       comment '수정자ID'                    

  , primary key PK_DATASOURCE ( DS_NM )

)
comment = 'DataSource';

-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_DATASOURCE_INSERT before insert on TB_DATASOURCE
for each row
begin

    -- Set the creation date
    set new.CREATE_DT = now();

    -- Set the udpate date
    set new.UPDATE_DT = now();

end //
delimiter ;
-- CREATE_DT, UPDATE_DT 기본값을 지정하기 위한 트리거
delimiter //
create trigger TB_DATASOURCE_UPDATE before update on TB_DATASOURCE
for each row
begin
    -- Set the udpate date
    set new.UPDATE_DT = now();
end //
delimiter ;
