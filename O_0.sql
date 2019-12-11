-- 获取表字段： http://www.soso.io/article/12903.html
select * from SYS_SYSTEM;
select * from user_tab_columns where Table_Name='SYS_SYSTEM';    -- order by column_name;
-- 查询字段注释
select *  from user_col_comments  where Table_Name = 'SYS_SYSTEM'; 
-- 查询表注释
select * from user_tab_comments where Table_Name='SYS_SYSTEM';

-- 查找表的主键（包括名称，构成列）   http://www.2cto.com/database/201305/214971.html
select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = 'P' and au.table_name = 'SYS_SYSTEM';

-- 查找表的外键（包括名称，引用表的表名和对应的键名，下面是分成多步查询）
select * from user_constraints c where c.constraint_type = 'R' and c.table_name =  'SYS_DEPT_USER';

-- 将Oracle中同一列的多行记录拼接成一个字符串 http://zhidao.baidu.com/link?url=mGRA5x3Vu1DhlVfq2WBc3QLgvuy5_6mFDQb_cRV1qpp56ynFKH_f1l6qFRd2N8NoYjLKCyC-Oj3hh-qTwnWDvd7oqDo9KAjYznQDbz2Hxci
select wm_concat(column_name) from user_tab_columns where Table_Name='SYS_SYSTEM';  
--  oracle 创建表的时候怎么同时添加列说明 http://zhidao.baidu.com/link?url=h-grCcdXZ1mv8O3gRF1iZea5vK2WOUTmEgzbj3-X5JYCxyaNekJgSCTsoBu3gg_RqEsoKAm-Mo1GFBfkEE0rPK
使用 comment on，举个例子：
drop table t_meiyong;
create table t_meiyong
(
empid NUMBER
);

comment on table t_meiyong is '员工信息'; --添加表描述  
comment on column t_meiyong.empid is '员工编号'; --添加列描述
-- 

-- decode   http://blog.csdn.net/oscar999/article/details/18399177
drop table t_meiyong;
create table t_meiyong(  
   name varchar2(30),  
   subject varchar2(20),  
   score number(4,1)  
);  

insert into t_meiyong (name,subject,score)values('zhang san','Chinese',90);  
insert into t_meiyong (name,subject,score)values('zhang san','Mathematics',80);  
insert into t_meiyong (name,subject,score)values('zhang san','English',79); 
insert into t_meiyong (name,subject,score)values('li shi','Chinese',96);  
insert into t_meiyong (name,subject,score)values('li shi','Mathematics',86);  
insert into t_meiyong (name,subject,score)values('li shi','English',76);  
  
insert into t_meiyong (name,subject,score)values('wang wu','Chinese',92);  
insert into t_meiyong (name,subject,score)values('wang wu','Mathematics',82);  
insert into t_meiyong (name,subject,score)values('wang wu','English',72);  

select * from t_meiyong;

select name,subject,decode(subject, 'Chinese',score,0) from t_meiyong;

select name,sum(decode(subject, 'Chinese',score,0)) as CHINESE from t_meiyong group by name;  
select name,score as CHINESE from t_meiyong;  

select name,  
sum(decode(subject, 'Chinese', nvl(score, 0), 0)) "Chinese",  
sum(decode(subject, 'Mathematics', nvl(score, 0), 0)) "Mathematics",  
sum(decode(subject, 'English', nvl(score, 0), 0)) "English"  
from t_meiyong  
group by name;  

select name,  
sum(case when subject='Chinese'  
              then nvl(score,0)  
         else 0  
    end) "Chinese",  
sum(case when subject='Mathematics'  
              then nvl(score,0)  
         else 0  
    end) "Mathematics",  
sum(case when subject='English'  
              then nvl(score,0)  
         else 0  
    end) "English"  
from t_meiyong  
group by name;  

-- 左连接、右连接、全外连接 http://blog.chinaunix.net/uid-21187846-id-3288525.html
drop table t_meiyong;
drop table t_meiyong1;

create table t_meiyong
(
       ID int ,
        NAME varchar2(20)
);
create table t_meiyong1
(
       ID int ,
        NAME varchar2(20)
);
insert into t_meiyong values(1,'dave');
insert into t_meiyong values(2,'b1');
insert into t_meiyong values(3,'big bird');
insert into t_meiyong values(4,'exc');
insert into t_meiyong values(9,'怀宁');

insert into t_meiyong1 values(8,'安庆');
insert into t_meiyong1 values(1,'dave');
insert into t_meiyong1 values(2,'bl');
insert into t_meiyong1 values(1,'bl');
insert into t_meiyong1 values(2,'dave');
insert into t_meiyong1 values(3,'dba');
insert into t_meiyong1 values(4,'sf-express');
insert into t_meiyong1 values(5,'dmm');

select * from t_meiyong;
select * from t_meiyong1;
-- 左外连接
select * from t_meiyong1 t1 left join t_meiyong t on t1.id = t.id;
-- 用（+）来实现， 这个+号可以这样来理解： + 表示补充，即哪个表有加号，这个表就是匹配表。所以加号写在右表，左表就是全部显示，故是左连接。 注意： 用（+） 就要用关键字where
Select * from t_meiyong1 t1,t_meiyong t where t1.id=t.id(+);
Select * from t_meiyong t,t_meiyong1 t1 where t.id=t1.id(+);

-- 右外连接
select * from t_meiyong1 t1 right join t_meiyong t on t1.id = t.id;
-- 用（+）来实现， 这个+号可以这样来理解： + 表示补充，即哪个表有加号，这个表就是匹配表。所以加号写在左表，右表就是全部显示，故是右连接。
Select * from t_meiyong1 t1,t_meiyong t where t1.id(+)=t.id;

-- 全外连接 左表和右表都不做限制，所有的记录都显示，两表不足的地方用null 填充。 全外连接不支持（+）这种写法。
select * from t_meiyong1 t1 full join t_meiyong t on t1.id = t.id;

 
-- Oracle的rownum原理和使用(整理几个达人的帖子)  http://www.cnblogs.com/mabaishui/archive/2009/10/20/1587165.html
drop table t_meiyong;
create table t_meiyong
(
       id int ,
       name varchar2(20)
);
insert into t_meiyong values(1,'张一');
insert into t_meiyong values(2,'王二');
insert into t_meiyong values(3,'李三');
insert into t_meiyong values(4,'赵四');

select * from t_meiyong;
-- rownum并不是按照name列来生成的序号。系统是按照记录插入时的顺序给记录排的号，rowid也是顺序分配的。为了解决这个问题，必须使用子查询
select rownum ,id,name from t_meiyong order by name;
-- 这样就成了按name排序，并且用rownum标出正确序号（由小到大）
select rownum ,id,name from (select * from t_meiyong order by name);

-- ORACLE分页查询SQL语法——最高效的分页  http://blog.sina.com.cn/s/blog_8604ca230100vro9.html
SELECT *
  FROM (SELECT ROWNUM AS rowno, t.*
          FROM scott.emp t
         WHERE hiredate BETWEEN TO_DATE ('19810501', 'yyyymmdd')
                             AND TO_DATE ('19870731', 'yyyymmdd')
           AND ROWNUM <= 20) table_alias
 WHERE table_alias.rowno >= 10;
 -- 
 SELECT *
  FROM (SELECT tt.*, ROWNUM AS rowno
          FROM (  SELECT t.*
                    FROM scott.emp t
                   WHERE hiredate BETWEEN TO_DATE ('19810501', 'yyyymmdd')
                                       AND TO_DATE ('19870731', 'yyyymmdd')
                ORDER BY empno desc) tt
         WHERE ROWNUM <= 20) table_alias
 WHERE table_alias.rowno >= 10;

-- instr http://www.jb51.net/article/31715.htm 　
--instr( string1, string2 [, start_position [, nth_appearance ] ] ) 
　　--string1 
　　--源字符串，要在此字符串中查找。 
　　--string2 
　　--要在string1中查找的字符串. 
　　--start_position 
    --代表 string1 的哪个位置开始查找。此参数可选，如果省略默认为1. 字符串索引从1开始。如果此参数为正，从左到右开始检索，如果此参数为负，从右到左检索，返回要查找的字符串在源字符串中的开始索引。
select instr('abcdefgh','de') position from dual; 
select instr('abcdefghbcXYT','bc',3) position from dual; 

-- INSTR方法的格式为 INSTR(src, subStr,startIndex, count)   src: 源字符串   subStr : 要查找的子串   startIndex : 从第几个字符开始。负数表示从右往左查找。 count: 要找到第几个匹配的序号 
返回值： 子串在字符串中的位置，第1个为1；不存在为0. （特别注意：如果src为空字符串，返回值为null）。 
SELECT instr('syranmo','s') FROM dual; -- 返回 1 
SELECT instr('syranmo','ra') FROM dual; -- 返回 3 
SELECT instr('syran mo','a',1,2) FROM dual; -- 返回 0  根据条件，由于a只出现一次，第四个参数2，就是说第2次出现a的位置，显然第2次是没有再出现了，所以结果返回0。注意空格也算一个字符！
SELECT instr('syranmo','an',-1,1) FROM dual; -- 返回 4  就算是由右到左数，索引的位置还是要看‘an'的左边第一个字母的位置，所以这里返回4

select instr('hello,java world', 'l') from dual;  -- 最简单的一种，查找l字符,首个l位于第3个位置。 
select instr('hello,java world', 'l', 4) from dual; -- 查找l字符,从第4个位置开始。 
select instr('hello,java world', 'l', 1, 3) from dual;   --查找l字符,从第1个位置开始的第3个 
select instr('hello,java world', 'l', -1, 3) from dual;  -- 查找l字符,从右边第1个位置开始，从右往左查找第3个（也即是从左到右的第1个） 
select instr('hello,java world', 'MM') from dual; --  找不到返回0 
-- oracle 的 substr函数的用法 http://www.cnblogs.com/emmy/archive/2011/01/08/1930945.html
select substr('This is a test', 6, 2)  from dual;   -- return 'is'
select  substr('This is a test', 6) from dual;    -- return 'is'
select substr('TechOnTheNet', -3, 3)  from dual;   -- return 'Net'
select substr('TechOnTheNet', -6, 3) from dual ;  --  return 'The'

select substr('17010001',-4) from dual;  --  0001

--  在oracle中怎么把一张表的数据插入到另一张表中  http://zhidao.baidu.com/link?url=gdL_4h1PYGBN4MwZUaVjUGA153u7PTe4JAZT2m5SofbbsygDtjGdZyWIsN7iulNxsbxQxB8J-DWjAn2WjCxsFztSQMDm2xjfxXZ0NTT5bF3
drop table t_meiyong1;
create table  t_meiyong1
(
     ID CHAR(24),
     CODE  VARCHAR2(100),
     NAME VARCHAR2(100),
     ABBR_PY VARCHAR2(100),
     ABBR_WB VARCHAR2(100),
     ENABLE_FLAG CHAR(1),
     ORDER_ID  VARCHAR2(20),
     REMARK VARCHAR2(1000),
     CREATE_USER_ID CHAR(24),
     CREATE_USER VARCHAR2(100),
     CREATE_DATE DATE,
     LAST_UPDATE_USER_ID  CHAR(24),
     LAST_UPDATE_USER  VARCHAR2(100),
     LAST_UPDATE_DATE DATE
);
comment on table t_meiyong1 is '消毒器械种类表_meiyong'; --添加表描述
comment on column t_meiyong1.ID is 'ID' ;
comment on column t_meiyong1.CODE is '分类编码' ;
comment on column t_meiyong1.NAME is '分类名称' ;
comment on column t_meiyong1.ABBR_PY is '拼音简码' ;
comment on column t_meiyong1.ENABLE_FLAG is '是否可用：1可用，0禁用' ;

select * from t_meiyong1;
insert into t_meiyong1  
select 
ID,CODE,NAME,ABBR_PY,ABBR_WB,ENABLE_FLAG,ORDER_ID,REMARK,CREATE_USER_ID,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER_ID,LAST_UPDATE_USER,LAST_UPDATE_DATE from  LC_BASE_PRODUCT_CLASS;

-- oracle lpad 函数 http://blog.csdn.net/bjnihao/article/details/6250417
--　lpad 函数从左边对字符串使用指定的字符进行填充。从其字面意思也可以理解，l是left的简写，pad是填充的意思，所以lpad就是从左边填充的意思。
select lpad('abcde',10,'x') from dual;    -- result:xxxxxabcde
select lpad('abcde',10,'oq') from dual;    --  result:oqoqoabcde
select lpad('abcde',2) from dual;    --  result:ab
-- 与lpad函数对应的是rpad函数： 　rpad函数从右边对字符串使用指定的字符进行填充，语法格式与lpad格式相同：
select rpad('tech', 7) from dual;  --  result:tech
select rpad('tech', 2) from dual; --  result:te
select rpad('tech', 8, '0') from dual;  -- result:tech0000
select rpad('tech on the net', 15, 'z') from dual;  -- result:tech on the net
select rpad('tech on the net', 16, 'z') from dual;   -- result:tech on the net2

--  NVL  http://blog.sina.com.cn/s/blog_46e9573c01015ik8.html
-- NVL函数的格式如下：NVL(expr1,expr2) 含义是：如果oracle第一个参数为空那么显示第二个参数的值，如果第一个参数的值不为空，则显示第一个参数本来的值。
select scott.emp.*,NVL(comm, -1) from scott.emp;


--  rownum 和 rowid 的区别 http://www.cnblogs.com/qqzy168/archive/2013/09/08/3308648.html
select * from  scott.emp;
select rownum rn, a.* from scott.emp a;
    
select *
from (select rownum rn, a.* from scott.emp a) t
where t.rn between 2 and 10;


-- SQLserver、Oracle、Mysql语法与用法对比   http://wenku.baidu.com/link?url=ErGNIhQmQVsKwZTGWTuPEksvKgPfq77-dSgqqbt7QIdLQSs08RpAj50ZWb6j6h0QlsCbCTQuEaxTLa0zGGehL6LihJS7lsWtYWa8QPZwbr7

-- 通过USER_SOURCE、DBA_SOURCE、ALL_SOURCE查询Oralce数据库对象SQL语句   http://blog.itpub.net/299797/viewspace-705949/
select  wm_concat(text)  from user_source  where name='HIS_FOR_DEPT'

--   wmsys.wm_concat  http://blog.csdn.net/yy_mm_dd/article/details/3182953
drop table t_meiyong1;
create table t_meiyong1 (id number,name varchar2(30));
insert into t_meiyong1 values(10,'ab');
insert into t_meiyong1 values(10,'bc');
insert into t_meiyong1 values(10,'cd');
insert into t_meiyong1 values(20,'hi');
insert into t_meiyong1 values(20,'ij');
insert into t_meiyong1 values(20,'mn');

select * from t_meiyong1;

select id,wmsys.wm_concat(name) name from t_meiyong1 group by id;
select id,wmsys.wm_concat(name) over (order by id) name from t_meiyong1;
select id,wmsys.wm_concat(name) over (order by id,name) name from t_meiyong1;
select id,wmsys.wm_concat(name) over (partition by id) name from t_meiyong1;
select id,wmsys.wm_concat(name) over (partition by id,name) name from t_meiyong1;

-- 用SQL将Oracle中同一列的多行记录拼接成一个字符串  http://blog.csdn.net/little_stars/article/details/9066191
DROP TABLE t_meiyong2;  
CREATE TABLE t_meiyong2 (  
L_ID VARCHAR2(32) NOT NULL ,  
L_CONTENT VARCHAR2(512)  ,  
L_TIME VARCHAR2(32) ,  
L_USER VARCHAR2(32) ,  
PRIMARY KEY (L_ID)  
);   
  
COMMENT ON TABLE t_meiyong2 IS '日志表';  
COMMENT ON COLUMN t_meiyong2.L_ID IS '日志ID';  
COMMENT ON COLUMN t_meiyong2.L_CONTENT IS '日志内容';  
COMMENT ON COLUMN t_meiyong2.L_TIME IS '时间';  
COMMENT ON COLUMN t_meiyong2.L_USER IS '操作人';  
  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('123', '黑啊', '111', '12345');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('124', '白啊', '222', '123456');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('125', '黑白啊', '111', '1234567');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('126', '白白啊', '111', '12345');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('127', '嘿嘿啊', '222', '123456');  

select * from t_meiyong2;

SELECT   
L4.L_TIME  
,MAX(SUBSTR(L4.分组内容,2)) 最终字段值  
FROM(  
        SELECT   
        L3.L_TIME  
        ,SYS_CONNECT_BY_PATH(L3.L_CONTENT,'*') AS 分组内容  
        FROM(  
                SELECT  
                L2.L_TIME  
                ,L2.L_CONTENT  
                ,L2.L_TIME||L2.分组内编号 AS 分组字段加编号,L2.L_TIME||(L2.分组内编号-1) AS 上级分组字段加编号  
                FROM(  
                        SELECT   
                        L1.L_TIME   -- 分组依据  
                        ,L1.L_CONTENT    -- 同一列中 要合并的不同行 的值  
                        ,ROW_NUMBER() OVER (PARTITION BY L1.L_TIME ORDER BY L1.L_CONTENT ASC) 分组内编号   
                        FROM t_meiyong2 L1  
                ) L2  
        ) L3  
        START WITH L3.上级分组字段加编号 LIKE '%0'   
        CONNECT BY PRIOR L3.分组字段加编号=L3.上级分组字段加编号  
) L4  
   
WHERE L_TIME='111'  
GROUP BY L4.L_TIME  
-- ROW_NUMBER() OVER(PARTITION BY A ORDER BY B DESC) 新列名  
-- 根据A分组，在分组内部根据B排序，而此函数计算的值就表示每组内部排序后的顺序编号（组内连续的唯一的)  
  
-- SYS_CONNECT_BY_PATH 函数： 第一个参数是形成树形式的字段，第二个参数是父级和其子级分隔显示用的分隔符  
-- CONNECT BY PRIOR 是标示父子关系的对应  
-- START WITH 代表你要开始遍历的的节点  


-- SYS_CONNECT_BY_PATH  ORACLE  http://www.cnblogs.com/huanghai223/archive/2010/12/10/1902696.html
drop table t_meiyong3;
create table t_meiyong3(deptno  number,deptname varchar2(20),mgrno number);   
insert into t_meiyong3 values(1,'总公司',null);   
insert into t_meiyong3 values(2,'浙江分公司',1);   
insert into t_meiyong3 values(3,'杭州分公司',2);   

select * from t_meiyong3 ;

   
select max(substr(sys_connect_by_path(deptname,','),2)) from t_meiyong3 connect by prior deptno =mgrno;   
select max(substr(sys_connect_by_path(column_name,','),2))   
from (select column_name,rownum rn from user_tab_columns where table_name ='t_meiyong3')   
start with rn=1 connect by rn=rownum ;   




-- oracle for in loop 两例    http://www.cnblogs.com/wuyisky/archive/2009/11/27/oracle_for_in_loop.html
drop table t_meiyong3;
create table t_meiyong3(DATE_CHAR VARCHAR2(8),DATE_DATE DATE);
select * from t_meiyong3;

DECLARE
v_date date;
BEGIN
EXECUTE IMMEDIATE 'truncate table t_meiyong3';
for v_date in 20091001 .. 20091021 LOOP
    INSERT INTO t_meiyong3
      (date_char, date_date)
      SELECT v_date, to_date(v_date, 'YYYY-MM-DD') FROM dual;
END LOOP;
COMMIT;
END;

select * from t_meiyong3;

-- 
drop table t_meiyong3;
drop table t_meiyong4;

create table t_meiyong3(TEXT VARCHAR2(100));
create table t_meiyong4(HZ_NAME VARCHAR2(3));
INSERT INTO t_meiyong4(HZ_NAME)values(' ');
INSERT INTO t_meiyong4(HZ_NAME)values('PRE');
INSERT INTO t_meiyong4(HZ_NAME)values('CUR');
INSERT INTO t_meiyong4(HZ_NAME)values('INS');
INSERT INTO t_meiyong4(HZ_NAME)values('UPD');
select * from t_meiyong4;


declare
P_TABLE_NAME varchar2(100) := 'CFA';
begin
for t_meiyong4 in (select HZ_NAME from t_meiyong4) LOOP
    insert into t_meiyong3
      select 'CREATE TABLE ' || REPLACE(P_TABLE_NAME, 'EDW', 'TMP') ||
             t_meiyong4.HZ_NAME || ' AS select * from ' || P_TABLE_NAME ||
             ' where ROWNUM<1'
        from dual;
END LOOP;
end;

select * from t_meiyong3;

-- 简单的将一列的字段通过空格连接起来 http://www.cnblogs.com/wuyisky/archive/2010/02/09/1666338.html
drop table t_meiyong4;
delete from t_meiyong4;
create table t_meiyong4
(
       id int ,
       sname  VARCHAR2(100)
);
insert into t_meiyong4 values(1,'骆驼祥子');
insert into t_meiyong4 values(1,'福海');
insert into t_meiyong4 values(1,'赵二');
insert into t_meiyong4 values(1,'冯国璋');
insert into t_meiyong4 values(1,'袁世凯');
insert into t_meiyong4 values(6,'段祺瑞');
insert into t_meiyong4 values(1,'周作人');
insert into t_meiyong4 values(8,'张勋');
insert into t_meiyong4 values(1,'曹锟');
insert into t_meiyong4 values(6,'宋庆龄');
insert into t_meiyong4 values(10,'张作霖');
insert into t_meiyong4 values(6,'宋美龄');

select * from t_meiyong4;

SELECT t.id id, MAX(substr(sys_connect_by_path(t.sname, ' '), 2)) str
FROM (SELECT id, sname, row_number() over(PARTITION BY id ORDER BY sname) rn FROM t_meiyong4) t
START WITH rn = 1
CONNECT BY rn = PRIOR rn + 1
AND id = PRIOR id
GROUP BY t.id;
--  oracle的concat方法连接两个字符串时，想给中间加个空格 http://zhidao.baidu.com/link?url=cGJKnxOkZRWR2yLJJdbmfnf-B34uope9KNfpA_KQOMtEbxI9Z0c0g1GhaZ_wwZWbV1dJhYrv0OovJhiTSlTCza
select concat(concat(id,' '),sname) from t_meiyong4
-- 超级牛皮的oracle的分析函数over(Partition by...) 及开窗函数    http://www.cnblogs.com/sumsen/archive/2012/05/30/2525800.html
--统计各班成绩第一名的同学信息
drop table t_meiyong4;
create table t_meiyong4
(
       NAME   varchar(20),
       class int,
       S int
);
insert into t_meiyong4 values('fda',1,80);
insert into t_meiyong4 values('ffd',1,78);
insert into t_meiyong4 values('dss',1,95);
insert into t_meiyong4 values('cfe',2,74);
insert into t_meiyong4 values('gds',2,92);
insert into t_meiyong4 values('gf',3,99);
insert into t_meiyong4 values('ddd',3,99);
insert into t_meiyong4 values('adf',3,45);
insert into t_meiyong4 values('asdf',3,55);
insert into t_meiyong4 values('3dd',3,78);

select * from t_meiyong4;
select * from                                                                       
(                                                                            
select name,class,s,rank()over(partition by class order by s desc) mm from t_meiyong4
)                                                                            
where mm=1 ;

--1.在求第一名成绩的时候，不能用row_number()，因为如果同班有两个并列第一，row_number()只返回一个结果         
--2.rank()和dense_rank()的区别是：
--rank()是跳跃排序，有两个第二名时接下来就是第四名
--dense_rank()l是连续排序，有两个第二名时仍然跟着第三名


-- 分类统计 (并显示信息)
drop table t_meiyong5;
create table t_meiyong5
(
       A   varchar(20),
       B varchar(20),
       C int
);
insert into t_meiyong5 values('m','a',2);
insert into t_meiyong5 values('n','a',3);
insert into t_meiyong5 values('m','a',2);
insert into t_meiyong5 values('n','b',2);
insert into t_meiyong5 values('n','b',1);
insert into t_meiyong5 values('x','b',3);
insert into t_meiyong5 values('x','b',2);
insert into t_meiyong5 values('x','b',4);
insert into t_meiyong5 values('h','b',3);

select * from t_meiyong5;
select a,c,sum(c)over(partition by a) from t_meiyong5 ;      
-- 
drop table t_meiyong5;
create table t_meiyong5
(
  A varchar(20),
  B varchar(20),
  C varchar(20)
);
insert into t_meiyong5 values(1,1,1);
insert into t_meiyong5 values(1,2,2);
insert into t_meiyong5 values(1,3,3);
insert into t_meiyong5 values(2,2,5);
insert into t_meiyong5 values(3,4,6);

select * from t_meiyong5;
-- 将B栏位值相同的对应的C 栏位值加总
select a,b,c, SUM(C) OVER (PARTITION BY B) C_Sum
from t_meiyong5;
--如果不需要已某个栏位的值分割,那就要用 null     eg: 就是将C的栏位值summary 放在每行后面
select a,b,c, SUM(C) OVER (PARTITION BY null) C_Sum
from t_meiyong5;
--  Oracle递归查询 http://www.cnblogs.com/wanghonghu/archive/2012/08/31/2665945.html
drop table t_meiyong6;
CREATE TABLE t_meiyong6
(
  ID         NUMBER(10)                  NOT NULL,
  PARENT_ID  NUMBER(10),
  NAME       VARCHAR2(255 BYTE)          NOT NULL
);

ALTER TABLE t_meiyong6 ADD (
  CONSTRAINT t_meiyong6_PK
 PRIMARY KEY
 (ID));

ALTER TABLE t_meiyong6 ADD (
  CONSTRAINT t_meiyong6_R01 
 FOREIGN KEY (PARENT_ID) 
 REFERENCES t_meiyong6 (ID));
 
 INSERT INTO t_meiyong6(ID,NAME) VALUES(1,'四川省');

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(2,1,'巴中市');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(3,1,'达州市'); 

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(4,2,'巴州区');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(5,2,'通江县');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(6,2,'平昌县');

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(7,3,'通川区');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(8,3,'宣汉县');

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(9,8,'塔河乡');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(10,8,'三河乡');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(11,8,'胡家镇');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(12,8,'南坝镇');
 
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(13,6,'大寨乡');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(14,6,'响滩镇');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(15,6,'龙岗镇');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(16,6,'白衣镇');


-- 查询巴中市下面的所有行政组织(结果包含当前节点):
SELECT *
FROM t_meiyong6
START WITH NAME='巴中市'
CONNECT BY PRIOR ID=PARENT_ID;


-- 查询响滩镇镇所属的市：
SELECT ID,   PARENT_ID,      NAME,     
       CONNECT_BY_ROOT(ID)   CITY_ID,
       CONNECT_BY_ROOT(NAME) CITY_NAME
FROM   t_meiyong6
WHERE  NAME='响滩镇' 
       START WITH PARENT_ID=1
       CONNECT BY PRIOR ID=PARENT_ID;
       
      
--LEVEL:查询节点层次，从1开始。
--CONNECT_BY_ISLEAF：查询节点是否是叶子节点，是则为1，不是则为0
SELECT   ID,   NAME,   PARENT_ID,   LEVEL,   CONNECT_BY_ISLEAF
FROM     t_meiyong6
         START WITH NAME='巴中市'
         CONNECT BY PRIOR ID=PARENT_ID 
         ORDER BY ID;    
         
-- 查询巴中市下行政组织递归路径
SELECT  ID,     NAME,   PARENT_ID,
        SUBSTR(SYS_CONNECT_BY_PATH(NAME,'->'),3)   NAME_PATH
FROM    t_meiyong6
        START   WITH NAME='巴中市'
        CONNECT BY PRIOR ID=PARENT_ID;          


--  Oracle start with.connect by prior子句实现递归查询 http://www.2cto.com/database/201108/101766.html
/*Oracle中的select语句可以用start with...connect by prior子句实现递归查询，connect by 是结构化查询中用到的，其基本语法是：

select ... from <TableName>
where <Conditional-1>
start with <Conditional-2>
connect by <Conditional-3>;

<Conditional-1>：过滤条件，用于对返回的所有记录进行过滤。
<Conditional-2>：查询结果重起始根结点的限定条件。
<Conditional-3>：连接条件*/

create table t_meiyong2(
root_id number,
id number,
name varchar(5),
description varchar(10)
);

insert into t_meiyong2(root_id,id,name,description) values(0,1,'a','aaa');
insert into t_meiyong2(root_id,id,name,description) values(1,2,'a1','aaa1');
insert into t_meiyong2(root_id,id,name,description) values(1,3,'a2','aaa2');
insert into t_meiyong2(root_id,id,name,description) values(0,4,'b','bbb');
insert into t_meiyong2(root_id,id,name,description) values(4,5,'b1','bbb1');
insert into t_meiyong2(root_id,id,name,description) values(4,6,'b2','bbb2');

select * from t_meiyong2;
--获取完整树
select * from t_meiyong2 start with root_id = 0 connect by prior id = root_id; 
 -- 获取特定子树
 select * from t_meiyong2 start with id = 1 connect by prior id = root_id;
select * from t_meiyong2 start with id = 4 connect by prior id = root_id; 
-- 如果connect by prior中的prior被省略，则查询将不进行深层递归。如：
select * from t_meiyong2 start with root_id = 0 connect by id = root_id;
select * from t_meiyong2 start with id = 1 connect by id = root_id;

-- Oracle排名函数(Rank)实例详解 http://blog.csdn.net/cczz_11/article/details/6053539
drop table t_meiyong;
create table t_meiyong
(
  autoid   number  primary key,
  s_id     number(3),
  s_name   char(8) not null,
  sub_name varchar2(20),
  score    number(10,2)
);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (8, 1, '张三    ', '语文', 80);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (9, 2, '李四    ', '数学', 80);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (10, 1, '张三    ', '数学', 0);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (11, 2, '李四    ', '语文', 50);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (12, 3, '张三丰  ', '语文', 10);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (13, 3, '张三丰  ', '数学', null);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (14, 3, '张三丰  ', '体育', 120);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (15, 4, '杨过    ', 'java', 90);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (16, 5, 'mike    ', 'c++', 80);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (3, 3, '张三丰  ', 'oracle', 0);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (4, 4, '杨过    ', 'oracle', 77);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (17, 2, '李四    ', 'oracle', 77);

select *from t_meiyong;
-- 查询各学生科目为Oracle排名(简单排名)
select sc.s_id,sc.s_name,sub_name,sc.score, rank() over (order by score desc) 名次
from t_meiyong sc
where sub_name='oracle';
-- 对比：rank()与dense_rank()：非连续排名与连续排名(都是简单排名)
select sc.s_id,sc.s_name,sub_name,sc.score,dense_rank() over (order by score desc) 名次
from t_meiyong sc
where sub_name='oracle'
-- 查询各学生各科排名(分区排名)
select sc.s_id,sc.s_name,sub_name,sc.score,
 rank() over (partition by sub_name order by score desc) 名次
from t_meiyong sc;
-- 查询各科前2名(分区排名)类似：新闻表,求栏目点击率在前3位的新闻。商品表,求各类别销售额在前10位的商品。
select * from (
select sc.s_id,sc.s_name,sub_name,sc.score,
dense_rank() over
(partition by sub_name order by score desc) 名次
from t_meiyong sc
) x
where x.名次<=2;
-- 查询各同学总分
select s_id,s_name,sum(score) sum_score from t_meiyong
group by s_id,s_name;
-- 根据总分查询各同学名次
select x.*,
rank() over (order by sum_score desc) 名次
from (
select s_id,s_name,sum(score) sum_score from t_meiyong
group by s_id,s_name ) x;

rank() over (order by 排序字段 顺序)
rank() over (partition by 分组字段 order by 排序字段 顺序)
 
/*1.顺序：asc|desc  名次与业务相关：
  示例：找求优秀学员：成绩：降序  迟到次数：升序
2.分区字段：根据什么字段进行分区。
 
问题：分区与分组有什么区别?
·分区只是将原始数据进行名次排列(记录数不变),
·分组是对原始数据进行聚合统计(记录数变少,每组返回一条),注意：聚合。*/




-- round
/*SELECT ROUND( number, [ decimal_places ] ) FROM DUAL
参数:
number : 欲处理之数值
decimal_places : 四舍五入 , 小数取几位 ( 预设为 0 )*/
select round(123.456, 0) from dual;          -- 123 
select round(123.456, 1) from dual;          -- 123.5 
select round(123.456, 2) from dual;          -- 123.46 
select round(123.456, 3) from dual;          -- 123.456 
select round(-123.456, 2) from dual;        -- -123.46
--  开窗函数  http://www.cnblogs.com/sumsen/archive/2012/05/30/2525800.html
-- 求个人工资占部门工资的百分比
drop table t_meiyong1;
create table t_meiyong1
(
     NAME varchar(20),
     DEPT int,
     sal int
);
insert into t_meiyong1 values('a',10,2000);
insert into t_meiyong1 values('b',10,3000);
insert into t_meiyong1 values('c',10,5000);
insert into t_meiyong1 values('d',20,4000);

select * from t_meiyong1;
select name,dept,sal,sal*100/sum(sal) over(partition by dept) percent from t_meiyong1;

-- 开窗函数指定了分析函数工作的数据窗口大小，这个数据窗口大小可能会随着行的变化而变化，举例如下： 

drop table t_meiyong3;
create table t_meiyong3
(
       id int,
       mc int 
);
insert into t_meiyong3 values(1,11111);
insert into t_meiyong3 values(2,22222);
insert into t_meiyong3 values(3,33333);
insert into t_meiyong3 values(4,44444);

select * from t_meiyong3;

select t.id,t.mc,to_char((L.rn)||'/'||t.id)e
from t_meiyong3 t,
(select rownum rn from (select max(to_number(id)) mid from t_meiyong3) X connect by rownum <=mid )L
where L.rn<=to_number(t.id)
order by id;

select deptno,ename,sal,lag(ename,2,'example') over(partition by deptno order by ename) from 
scott.emp order by deptno;
-- 求每个部门的平均工资以及每个人与所在部门的工资差额
select deptno,ename,sal ,
     round(avg(sal) over(partition by deptno)) as dept_avg_sal, 
     round(sal-avg(sal) over(partition by deptno)) as dept_sal_diff
from scott.emp;

-- 分析函数(OVER)   http://www.cnblogs.com/wuyisky/archive/2010/02/24/oracle_over.html
drop table t_meiyong2;
create table t_meiyong2
(
CUST_NBR           NUMBER(5) not null ,
REGION_ID         NUMBER(5) not null ,
SALESPERSON_ID     NUMBER(5)not null ,
YEAR               NUMBER(4)not null ,
MONTH              NUMBER(2)not null,
TOT_ORDERS         NUMBER(7)not null,
TOT_SALES          NUMBER(11,2) not null
);
insert into   t_meiyong2 values (11  ,        7          ,   11        ,               2001       ,   7      ,    2  ,    12204);
insert into   t_meiyong2 values (4     ,     5          ,    4               ,          2001     ,    10      ,   2    ,  37802);
insert into   t_meiyong2 values (7   ,       6       ,       7               ,          2001      ,    2     ,     3     ,  3750);
insert into   t_meiyong2 values (10   ,       6        ,      8               ,         2001     ,     1     ,     2    ,  21691);
insert into   t_meiyong2 values (10   ,       6       ,       7              ,          2001     ,     2     ,     3   ,   42624);
insert into   t_meiyong2 values (15    ,      7        ,     12              ,         2000      ,    5     ,     6    ,     24);
insert into   t_meiyong2 values (12   ,       7        ,      9              ,          2000      ,    6    ,      2    ,  50658);
insert into   t_meiyong2 values (1   ,       5       ,       2                ,         2000      ,    3     ,     2    ,  44494);
insert into   t_meiyong2 values (1   ,       5        ,      1               ,          2000      ,    9      ,    2    ,  74864);
insert into   t_meiyong2 values (2    ,      5      ,        4               ,          2000      ,    3     ,     2    ,  35060);
insert into   t_meiyong2 values (2    ,      5       ,       4               ,          2000     ,     4     ,     4    ,   6454);
insert into   t_meiyong2 values (2     ,     5     ,         1              ,           2000     ,    10     ,     4    ,  35580);
insert into   t_meiyong2 values (4     ,     5   ,           4             ,            2000     ,    12     ,     2   ,   39190);
insert into   t_meiyong2 values (10     ,     7     ,         12            ,           2001     ,    5     ,     3   ,  400);
insert into   t_meiyong2 values (4     ,     6   ,           9             ,            2001     ,    11     ,     2   ,   400);

select * from t_meiyong2;
select o.cust_nbr customer,
    o.region_id region,
    sum(o.tot_sales) cust_sales,
    sum(sum(o.tot_sales)) over(partition by o.region_id) region_sales
from t_meiyong2 o
where o.year = 2001
group by o.region_id, o.cust_nbr;
--group by的意图很明显：将数据按区域ID，客户进行分组，那么Over这一部分有什么用呢？假如我们只需要统计每个区域每个客户的订单总额，那么我们只需要group by o.region_id,o.cust_nbr就够了。但我们还想在每一行显示该客户所在区域的订单总额，这一点和前面的不同：需要在前面分组的基础上按区域累加。很显然group by和sum是无法做到这一点的(因为聚集操作的级别不一样，前者是对一个客户，后者是对一批客户)。

-- 这就是over函数的作用了！它的作用是告诉SQL引擎：按区域对数据进行分区，然后累积每个区域每个客户的订单总额(sum(sum(o.tot_sales)))。
-- 现在我们已经知道2001年度每个客户及其对应区域的订单总额，那么下面就是筛选那些个人订单总额占到区域订单总额20%以上的大客户了

-- 按区域查找上一年度订单总额占区域订单总额20%以上的客户，来看看分析函数的应用。
select *
from (select o.cust_nbr customer,
      o.region_id region,
      sum(o.tot_sales) cust_sales,
      sum(sum(o.tot_sales)) over(partition by o.region_id) region_sales
      from t_meiyong2 o
      where o.year = 2001
      group by o.region_id, o.cust_nbr
      ) 
      all_sales
where all_sales.cust_sales > all_sales.region_sales * 0.2;

-- 现在我们已经知道这些大客户是谁了！哦，不过这还不够，如果我们想要知道每个大客户所占的订单比例呢？看看下面的SQL语句，只需要一个简单的Round函数就搞定了。
select all_sales.*,
      100 * round(cust_sales / region_sales, 2) || '%' Percent
      from (select o.cust_nbr customer,
      o.region_id region,
      sum(o.tot_sales) cust_sales,
      sum(sum(o.tot_sales)) over(partition by o.region_id) region_sales
from t_meiyong2 o
where o.year = 2001
group by o.region_id, o.cust_nbr) all_sales
where all_sales.cust_sales > all_sales.region_sales * 0.2;

-- ①Over函数指明在那些字段上做分析，其内跟Partition by表示对数据进行分组。注意Partition by可以有多个字段。
-- ②Over函数可以和其它聚集函数、分析函数搭配，起到不同的作用。例如这里的SUM，还有诸如Rank，Dense_rank

--  ltrim http://www.linuxidc.com/Linux/2014-02/96388.htm
select LTRIM( 'Miss Liu', 'Liu') Result  from dual; --  Miss Lius
select ltrim('caolingxiong','cao') from dual;   --  lingxiong
-- ltrim 左裁剪：第一个参数的第一个字符与第二个参数的每个字符进行匹配， 如果匹配成功则裁剪并进入下一个字符的匹配，如果匹配不成功则中断裁剪。
-- replace http://www.cnblogs.com/BetterWF/archive/2011/12/21/2295937.html
select  replace ('111222333444','222','888') from dual;


-- exists 是判断exits后面的sql语句是否为真,若为真则整个sql句子成立,否则没有任何记录。  http://jingyan.baidu.com/article/67508eb4df34e69cca1ce420.html
select 1 from dual where exists (select 1 from dual where 2=1);  -- 肯定是没有记录
 select 1 from dual where exists (select 1 from dual where 1=1); -- 有记录返回的

-- SYS_CONNECT_BY_PATH    http://database.51cto.com/art/201010/231125.htm
drop table t_meiyong;
create table t_meiyong (a varchar2(10),b varchar2(10));  
 
INSERT INTO t_meiyong (A, B) VALUES ('1', '我');  
INSERT INTO t_meiyong (A, B) VALUES ('1', '们');  
INSERT INTO t_meiyong (A, B) VALUES ('1', '要');  
INSERT INTO t_meiyong (A, B) VALUES ('2', '一');  
INSERT INTO t_meiyong (A, B) VALUES ('2', '起');  
INSERT INTO t_meiyong (A, B) VALUES ('2', '走');  

 
SELECT A, B FROM t_meiyong  ;
/*
                 现在需要达到如下的效果，  
          A          B  
          ---------- ----------  
          1          我,们,要  
          2          一,起,走 
*/
SELECT A, LTRIM(MAX(SYS_CONNECT_BY_PATH(B, ',')), ',') B  
FROM (SELECT B, A, ROW_NUMBER() OVER(PARTITION BY A ORDER BY B DESC) RN  
          FROM t_meiyong)  
START WITH RN = 1 
CONNECT BY RN - 1 = PRIOR RN  
       AND A = PRIOR A  
GROUP BY A; 
-- 其中，SYS_CONNECT_BY_PATH 函数主要作用是可以把一个父节点下的所有子节点通过某个字符进行区分，然后连接在一个列中显示。row_number 函数的用途是非常广泛，这个函数的功能是为查询出来的每一行记录生成一个序号。生产序号的方法通过over()函数里面的语句来控制。
-- http://www.cnblogs.com/huanghai223/archive/2010/12/10/1902696.html
SELECT * FROM scott.emp;
SELECT *
  FROM scott.emp
 START WITH ename = 'KING'
CONNECT BY PRIOR empno = mgr;

SELECT SYS_CONNECT_BY_PATH(ename, '>') "Path"    
FROM scott.emp    
START WITH ename = 'KING'    
CONNECT BY PRIOR empno = mgr;   

SELECT SYS_CONNECT_BY_PATH(ename, '>') "Path" 
FROM scott.emp 
START WITH ename = 'KING' 
CONNECT BY PRIOR empno = mgr;
-- 其实SYS_CONNECT_BY_PATH这个函数是oracle9i才新提出来的！它一定要和connect by子句合用！第一个参数是形成树形式的字段，第二个参数是父级和其子级分隔显示用的分隔符！START WITH 代表你要开始遍历的的节点！CONNECT BY PRIOR 是标示父子关系的对应！

--  oracle复制表数据，复制表结构  http://www.cnblogs.com/fireman/archive/2013/01/14/2859656.html
select *from t_meiyong4;
drop table t_meiyong5;
drop table t_meiyong6;
-- 完全复制表(包括创建表和复制表中的记录)
create table t_meiyong5 as select * from t_meiyong4 ; -- t_meiyong4 是被复制表
-- 只复制表结构 加入了一个永远不可能成立的条件1=2，则此时表示的是只复制表结构，但是不复制表内容   
create table t_meiyong6 as select * from t_meiyong4 where 1=2;
select *from t_meiyong5;
select *from t_meiyong6;

-- oracle如何很好的比较两个表数据的差异   http://zhidao.baidu.com/link?url=hu_0eqqx68q9XZ7lAAlFi6nqLY7qVQiMozxUpRbX6QQZHYnvc6nYK_5NPpoi21V6oU886D_GpvRwCKBN_g5N-q
drop table t_meiyong1;
drop table t_meiyong2;
create  table t_meiyong1
(
        ID int,
        NAME varchar2(20)
);
drop sequence seq_meiyong1;
Create sequence seq_meiyong1   -- 修改序列用 alter 
Increment by 1
Start with 1
Maxvalue 999999
Minvalue 1 
Nocycle      --不循环
NOCACHE  -- 分配并存入到内存中 一般不采用缓存

create  table t_meiyong2
(
        ID int,
        NAME varchar2(20)
);
drop sequence seq_meiyong2;
Create sequence seq_meiyong2   
Increment by 1
Start with 1
Maxvalue 999999
Minvalue 1 
Nocycle     
NOCACHE  

insert into t_meiyong1 values(seq_meiyong1.nextval,'张三');
insert into t_meiyong1 values(seq_meiyong1.nextval,'李四');
insert into t_meiyong1 values(seq_meiyong1.nextval,'王五');
insert into t_meiyong1 values(seq_meiyong1.nextval,'赵六');

insert into t_meiyong2 values(seq_meiyong2.nextval,'张三');
insert into t_meiyong2 values(seq_meiyong2.nextval,'李四');
insert into t_meiyong2 values(seq_meiyong2.nextval,'杨八');

select * from t_meiyong1;
select * from t_meiyong2;
--   现在要找出两张表有差异的数据，需要用minus及union的方式查找出来，语句如下：
select t1.*
  from (select *
          from t_meiyong1
        minus
        select * from t_meiyong2) t1
union
select t2.*
  from (select *
          from t_meiyong2
        minus
        select * from t_meiyong1) t2;
--  Minus  http://blog.itpub.net/23494139/viewspace-1108100/
/*SQL中有一个MINUS关键字，它运用在两个SQL语句上，它先找出第一条SQL语句所产生的结果，然后看这些结果有没有在第二个SQL语句的结果 中。如果有的话，那这一笔记录就被去除，而不会在最后的结果中出现。如果第二个SQL语句所产生的结果并没有存在于第一个SQL语句所产生的结果内，那这 笔资料就被抛弃，其语法如下：
[SQL Segment 1]
MINUS
[SQL Segment 2]*/
drop table t_meiyong3;
drop table t_meiyong4;
create table t_meiyong3
(
 name varchar(10),
 sex varchar(10)
);
create table t_meiyong4
(
 name varchar(10),
 sex varchar(10)
);


insert into t_meiyong3 values('test','female');
insert into t_meiyong3 values('test1','female');
insert into t_meiyong3 values('test1','female');
insert into t_meiyong3 values('test11','female');
insert into t_meiyong3 values('test111','female');

insert into t_meiyong4 values('test','female');
insert into t_meiyong4 values('test2','female');
insert into t_meiyong4 values('test2','female');
insert into t_meiyong4 values('test22','female');
insert into t_meiyong4 values('test222','female');

select * from t_meiyong3;
select * from t_meiyong4;


select * from t_meiyong3 minus select * from t_meiyong4;
select * from t_meiyong4 minus select * from t_meiyong3;
-- 结论：Minus返回的总是左边表中的数据，它返回的是差集。注意：minus有剃重作用 性能高

-- oracle中使用sys_connect_by_path进行表中行值连接  http://qingfeng825.iteye.com/blog/935466
drop table t_meiyong;
CREATE TABLE t_meiyong  
(  
  DATAID       NUMBER                           NOT NULL,  
  NAME         VARCHAR2(100 BYTE),  
  VALUE        VARCHAR2(100 BYTE),  
  PARENTID     NUMBER,  
  SEQUENCE     NUMBER,  
  DESCRIPTION  VARCHAR2(1000 BYTE)  
);
insert into t_meiyong values(1,'行业数据','行业数据',0,1,null);
insert into t_meiyong values(2,'政务数据','政务数据',0,2,null);
insert into t_meiyong values(3,'出版行业','出版行业',1,1,null);
insert into t_meiyong values(4,'版权行业','版权行业',1,2,null);
insert into t_meiyong values(5,'cip','cip',3,1,null);
insert into t_meiyong values(140,'版次及其他版本形式','版次及其他版本形式',5,1,null);
insert into t_meiyong values(141,'3版','3版',140,3,null);
insert into t_meiyong values(142,'1版','版',140,1,null);
insert into t_meiyong values(143,'2版','2版',140,2,null);
insert into t_meiyong values(144,'4版','4版',140,4,null);
insert into t_meiyong values(145,'5版','5版',140,5,null);

insert into t_meiyong values(146,'影印本','影印本',140,6,null);
insert into t_meiyong values(147,'修订本','修订本',140,7,null);
insert into t_meiyong values(148,'增订本','增订本',140,8,null);
insert into t_meiyong values(149,'2版(修订本)','2版(修订本)',140,9,null);

insert into t_meiyong values(150,'常用附件','常用附件',5,2,null);
insert into t_meiyong values(151,'DVD','DVD',150,1,null);
insert into t_meiyong values(152,'CD','CD',150,2,null);
insert into t_meiyong values(153,'MP3','MP3',150,3,null);
insert into t_meiyong values(154,'磁带','磁带',150,4,null);
insert into t_meiyong values(155,'光盘','光盘',150,5,null);

select *from t_meiyong;
-- 取按照parentid分组，组内部按照dataid排序后的行号
select t.parentid,
       t.value,
       t.dataid,
       (row_number() /* 按照parentid分组，组内部按照dataid排序后的行号*/
        over(partition by parentid order by dataid)) numid
  from t_meiyong t;
-- 按照上面的行号进行轮循，进行组内每行字符串的连接。
select parentid,
       parentValue,
       ltrim(sys_connect_by_path(value, '*'), '*') valuues
  from (select t.parentid,
               t.value,
               t.dataid,
               parent.VALUE as parentValue,
               (row_number() /* 按照parentid分组，组内部按照dataid排序后的行号*/
                over(partition by t.parentid order by t.dataid)) numid
          from t_meiyong t, t_meiyong parent
         where t.PARENTID = parent.DATAID)
 WHERE connect_by_isleaf = 1
 start with numid = 1
connect by numid - 1 = prior numid
       and parentid = prior parentid;
/*重点函数：sys_connect_by_path(value, '*')
     value 表示要连接的字段，‘*’表示连接符。
    使用这个方法之前必须在where条件中构建树
    where start with 条件1  connect by prior 条件2
   条件1 ：表示起始条件，例如，起始条件为组内排序后的rownum为1。
   条件2 ：表示要连接的下一行与上一行的关系，例如上面第一记录，valuues  对应的值是：“出版行业*版权行业”。那么“版权行业”与“出版行业”之间的关系是：相同的parentId中的numid+1，所以其条件为：
        start with numid = 1 
       connect by numid - 1 = prior numid    and parentid = prior parentid;
其中，prior.列名：代表上一行的列。
 
SYS_CONNECT_BY_PATH ：实现将从父节点到当前行内容以“path”或者层次元素列表的形式显示出来
 
CONNECT_BY_ROOT： 它用在列名之前用于返回当前层的根节点
 
connect_by_isleaf：来判断当前行是不是叶子。如 果是叶子就会在伪列中显示“1”，如果不是叶子而是一个分支（例如当前内容是其他行的父亲）就显示“0”。*/

--  Oracle中 EXISTS、IN、NOT EXISTS、NOT IN的效率区别   http://blog.chinaunix.net/uid-16844439-id-3330063.html
drop table t_meiyong1;
drop table t_meiyong2;
create table t_meiyong1 (c1 varchar2(20),c2 varchar2(20));
create table t_meiyong2 (c1 varchar2(20),c2 varchar2(20));

insert into t_meiyong1 values ('徐','涛');
insert into t_meiyong1 values ('徐','肇喆');
insert into t_meiyong1 values ('毛','泽东');
insert into t_meiyong1 values ('陶','肇喆');
insert into t_meiyong2 values ('徐','涛');
insert into t_meiyong2 values ('周','杰伦');
insert into t_meiyong2 values ('徐',null);

select * from t_meiyong1;
select * from t_meiyong2;

select * from t_meiyong1 where c2 not in (select c2 from t_meiyong2);
select * from t_meiyong1 where not exists (select 1 from t_meiyong2 where t_meiyong1.c2=t_meiyong2.c2);

--^^
select * from t_meiyong2 where '涛'=t_meiyong2.c2;
select * from t_meiyong2 where '肇喆'=t_meiyong2.c2;

--正如所看到的，not in 出现了不期望的结果集，存在逻辑错误。如果看一下上述两个select语句的执行计划，也会不同。后者使用了hash_aj。
--因此，请尽量不要使用not in(它会调用子查询)，而尽量使用not exists(它会调用关联子查询)。如果子查询中返回的任意一条记录含有空值，则查询将不返回任何记录，正如上面例子所示。
--除非子查询字段有非空限制，这时可以使用not in ,并且也可以通过提示让它使用hasg_aj或merge_aj连接

--   1 性能上的比较  http://wenku.baidu.com/link?url=vWNvbPvgPQUo-tU6QIffwvwb8KB531mCl4J0sBDPE4NJWPeTZP3QpPaZLjMuEBtNj7R5U3WqRQvBrpkifmf5cliUPzgQTiFwsJdnjZSJvHa
select *from t_meiyong1 where C2 IN(select C2 from t_meiyong2);
-- 相当于
select * from t_meiyong1,(select distinct  C2 from t_meiyong2)t2
where t_meiyong1.C2 =  t2.c2 ;     

-- 相对的
select * from t_meiyong1 where exists ( select null from t_meiyong2 where t_meiyong2.c2=t_meiyong1.c2);
-- 执行过程相当于：
-- 表 t_meiyong1 ?不可避免的要被完全扫描一遍?   

 
-- Oracle 树操作(select…start with…connect by…prior)   http://www.cnblogs.com/linjiqin/archive/2013/06/24/3152674.html
drop table t_meiyong;
create table t_meiyong(
id number(10) not null, --主键id
 title varchar2(50), --标题
parent number(10) --parent id
);

--父菜单
insert into t_meiyong(id, title, parent) values(1, '父菜单1',null);
insert into t_meiyong(id, title, parent) values(2, '父菜单2',null);
insert into t_meiyong(id, title, parent) values(3, '父菜单3',null);
insert into t_meiyong(id, title, parent) values(4, '父菜单4',null);
insert into t_meiyong(id, title, parent) values(5, '父菜单5',null);
--一级菜单
insert into t_meiyong(id, title, parent) values(6, '一级菜单6',1);
insert into t_meiyong(id, title, parent) values(7, '一级菜单7',1);
insert into t_meiyong(id, title, parent) values(8, '一级菜单8',1);
insert into t_meiyong(id, title, parent) values(9, '一级菜单9',2);
insert into t_meiyong(id, title, parent) values(10, '一级菜单10',2);
insert into t_meiyong(id, title, parent) values(11, '一级菜单11',2);
insert into t_meiyong(id, title, parent) values(12, '一级菜单12',3);
insert into t_meiyong(id, title, parent) values(13, '一级菜单13',3);
insert into t_meiyong(id, title, parent) values(14, '一级菜单14',3);
insert into t_meiyong(id, title, parent) values(15, '一级菜单15',4);
insert into t_meiyong(id, title, parent) values(16, '一级菜单16',4);
insert into t_meiyong(id, title, parent) values(17, '一级菜单17',4);
insert into t_meiyong(id, title, parent) values(18, '一级菜单18',5);
insert into t_meiyong(id, title, parent) values(19, '一级菜单19',5);
insert into t_meiyong(id, title, parent) values(20, '一级菜单20',5);
--二级菜单
insert into t_meiyong(id, title, parent) values(21, '二级菜单21',6);
insert into t_meiyong(id, title, parent) values(22, '二级菜单22',6);
insert into t_meiyong(id, title, parent) values(23, '二级菜单23',7);
insert into t_meiyong(id, title, parent) values(24, '二级菜单24',7);
insert into t_meiyong(id, title, parent) values(25, '二级菜单25',8);
insert into t_meiyong(id, title, parent) values(26, '二级菜单26',9);
insert into t_meiyong(id, title, parent) values(27, '二级菜单27',10);
insert into t_meiyong(id, title, parent) values(28, '二级菜单28',11);
insert into t_meiyong(id, title, parent) values(29, '二级菜单29',12);
insert into t_meiyong(id, title, parent) values(30, '二级菜单30',13);
insert into t_meiyong(id, title, parent) values(31, '二级菜单31',14);
insert into t_meiyong(id, title, parent) values(32, '二级菜单32',15);
insert into t_meiyong(id, title, parent) values(33, '二级菜单33',16);
insert into t_meiyong(id, title, parent) values(34, '二级菜单34',17);
insert into t_meiyong(id, title, parent) values(35, '二级菜单35',18);
insert into t_meiyong(id, title, parent) values(36, '二级菜单36',19);
insert into t_meiyong(id, title, parent) values(37, '二级菜单37',20);
--三级菜单
insert into t_meiyong(id, title, parent) values(38, '三级菜单38',21);
insert into t_meiyong(id, title, parent) values(39, '三级菜单39',22);
insert into t_meiyong(id, title, parent) values(40, '三级菜单40',23);
insert into t_meiyong(id, title, parent) values(41, '三级菜单41',24);
insert into t_meiyong(id, title, parent) values(42, '三级菜单42',25);
insert into t_meiyong(id, title, parent) values(43, '三级菜单43',26);
insert into t_meiyong(id, title, parent) values(44, '三级菜单44',27);
insert into t_meiyong(id, title, parent) values(45, '三级菜单45',28);
insert into t_meiyong(id, title, parent) values(46, '三级菜单46',28);
insert into t_meiyong(id, title, parent) values(47, '三级菜单47',29);
insert into t_meiyong(id, title, parent) values(48, '三级菜单48',30);
insert into t_meiyong(id, title, parent) values(49, '三级菜单49',31);
insert into t_meiyong(id, title, parent) values(50, '三级菜单50',31);

select * from t_meiyong;
-- parent字段存储的是上级id，如果是顶级父节点，该parent为null(得补充一句，当初的确是这样设计的，不过现在知道，表中最好别有null记录，这会引起全文扫描，建议改成0代替)。
-- 1)、查找树中的所有顶级父节点（辈份最长的人）。 假设这个树是个目录结构，那么第一个操作总是找出所有的顶级节点，再根据该节点找到其下属节点。
select * from t_meiyong m where m.parent is null;
-- 2)、查找一个节点的直属子节点（所有儿子）。 如果查找的是直属子类节点，也是不用用到树型查询的。
select * from t_meiyong m where m.parent=1;
--  3)、查找一个节点的所有直属子节点（所有后代）。
select * from t_meiyong m start with m.id=1 connect by m.parent=prior m.id; -- 这个查找的是id为1的节点下的所有直属子类节点，包括子辈的和孙子辈的所有直属节点。
-- 4)、查找一个节点的直属父节点（父亲）。 如果查找的是节点的直属父节点，也是不用用到树型查询的。
select c.id, c.title, p.id parent_id, p.title parent_title
from t_meiyong c, t_meiyong p
where c.parent=p.id and c.id=6;
-- 5)、查找一个节点的所有直属父节点（祖宗）。
select * from t_meiyong m start with m.id=38 connect by prior m.parent=m.id;

--上面列出两个树型查询方式，第3条语句和第5条语句，这两条语句之间的区别在于prior关键字的位置不同，所以决定了查询的方式不同。 当parent = prior id时，数据库会根据当前的id迭代出parent与该id相同的记录，所以查询的结果是迭代出了所有的子类记录；而prior parent = id时，数据库会跟据当前的parent来迭代出与当前的parent相同的id的记录，所以查询出来的结果就是所有的父类结果。

以下是一系列针对树结构的更深层次的查询，这里的查询不一定是最优的查询方式，或许只是其中的一种实现而已。

-- 6)、查询一个节点的兄弟节点（亲兄弟）。
select * from t_meiyong m
where exists (select * from t_meiyong m2 where m.parent=m2.parent and m2.id=6);


-- 7)、查询与一个节点同级的节点（族兄弟）。 如果在表中设置了级别的字段，那么在做这类查询时会很轻松，同一级别的就是与那个节点同级的，在这里列出不使用该字段时的实现! 这里使用两个技巧，一个是使用了level来标识每个节点在表中的级别，还有就是使用with语法模拟出了一张带有级别的临时表。
with tmp as(
      select a.*, level leaf        
      from t_meiyong a                
      start with a.parent is null     
      connect by a.parent = prior a.id)
select *                               
from tmp                             
where leaf = (select leaf from tmp where id = 50);
-- 8)、查询一个节点的父节点的的兄弟节点（伯父与叔父）。  
with tmp as(
    select t_meiyong.*, level lev
    from t_meiyong
    start with parent is null
    connect by parent = prior id)
    
select b.*
from tmp b,(select *
            from tmp
            where id = 21 and lev = 2) a
where b.lev = 1
 
union all
 
select *
from tmp
where parent = (select distinct x.id
                from tmp x, --祖父
                     tmp y, --父亲
                     (select *
                      from tmp
                      where id = 21 and lev > 2) z --儿子
                where y.id = z.parent and x.id = y.parent);
/*这里查询分成以下几步。
首先，将第7个一样，将全表都使用临时表加上级别；
其次，根据级别来判断有几种类型，以上文中举的例子来说，有三种情况：
（1）当前节点为顶级节点，即查询出来的lev值为1，那么它没有上级节点，不予考虑。
（2）当前节点为2级节点，查询出来的lev值为2，那么就只要保证lev级别为1的就是其上级节点的兄弟节点。
（3）其它情况就是3以及以上级别，那么就要选查询出来其上级的上级节点（祖父），再来判断祖父的下级节点都是属于该节点的上级节点的兄弟节点。
最后，就是使用union将查询出来的结果进行结合起来，形成结果集。
*/                
-- 9)、查询一个节点的父节点的同级节点（族叔）。这个其实跟第7种情况是相同的。
with tmp as(
      select a.*, level leaf        
      from t_meiyong a                
      start with a.parent is null     
      connect by a.parent = prior a.id)
select *                               
from tmp                             
where leaf = (select leaf from tmp where id = 6) - 1;
-- 10)、名称要列出名称全部路径。
这里常见的有两种情况，一种是从顶级列出，直到当前节点的名称（或者其它属性）；一种是从当前节点列出，直到顶级节点的名称（或其它属性）。举地址为例：国内的习惯是从省开始、到市、到县、到居委会的，而国外的习惯正好相反（老师说的，还没接过国外的邮件，谁能寄个瞅瞅  ）。
从顶部开始：

select sys_connect_by_path (title, '/')
from t_meiyong
where id = 50
start with parent is null
connect by parent = prior id;

-- 从当前节点开始:
select sys_connect_by_path (title, '/')
from t_meiyong
start with id = 50
connect by prior parent = id;


/*在这里我又不得不放个牢骚了。oracle只提供了一个sys_connect_by_path函数，却忘了字符串的连接的顺序。在上面的例子中，第一个sql是从根节点开始遍历，而第二个sql是直接找到当前节点，从效率上来说已经是千差万别，更关键的是第一个sql只能选择一个节点，而第二个sql却是遍历出了一颗树来。再次ps一下。

sys_connect_by_path函数就是从start with开始的地方开始遍历，并记下其遍历到的节点，start with开始的地方被视为根节点，将遍历到的路径根据函数中的分隔符，组成一个新的字符串，这个功能还是很强大的。*/

-- 11)、列出当前节点的根节点。在前面说过，根节点就是start with开始的地方。 connect_by_root函数用来列的前面，记录的是当前节点的根节点的内容。
select connect_by_root title, t_meiyong.*
from t_meiyong
start with id = 50
connect by prior parent = id;

-- 12)、列出当前节点是否为叶子。这个比较常见，尤其在动态目录中，在查出的内容是否还有下级节点时，这个函数是很适用的。
select connect_by_isleaf, t_meiyong.*
from t_meiyong
start with parent is null
connect by parent = prior id;
-- connect_by_isleaf函数用来判断当前节点是否包含下级节点，如果包含的话，说明不是叶子节点，这里返回0；反之，如果不包含下级节点，这里返回1。


























































