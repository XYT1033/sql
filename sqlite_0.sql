

--  SQLite可视化管理工具汇总  https://blog.csdn.net/shellching/article/details/7979969



-- Notepad++没有插件管理器的解决办法   https://blog.csdn.net/qq_36143023/article/details/78915481 



-- notepad++ sql格式化  https://jingyan.baidu.com/article/0a52e3f4158711bf62ed72e1.html 
 
-- PoorMansTSqlFormatter   https://download.csdn.net/download/yangxinxin_1019/9873016  



--  sqlite integer 列转为 varchar  https://zhidao.baidu.com/question/229580403.html 

  字符串连接用||
select date('now',n || ' day') from table


--  字符串处理函数replace  https://www.cnblogs.com/huangtailang/p/5cfbd242cae2bcc929c81c266d0c875b.html 

select  replace('i am htl','am','name is')



-- SQLite数据库导入和导出   https://blog.csdn.net/y494894353/article/details/44923979 


@ECHO OFF
C:
CD %HOMEPATH%/Desktop
SQLITE3 STUDENT.DB < student.sql //从student.sql文件提取数据导入并创建student.db
SQLITE3 STUDENT.DB .dump > student_result.sql  //从student.db导出数据并创建student_result. 








--  https://blog.csdn.net/flyingroc0209/article/details/51721206 

 output Out.sql  
 
 
 --  查询sqlite数据库表格总共有多少表 
 SELECT name FROM sqlite_master
WHERE type='table'
ORDER BY name;
 
 
 
 
 
 --  合并为一行，数据用逗号分隔   https://blog.csdn.net/chaoyangzhixue/article/details/52411145 
 
 create table t_meiyong3
 (
	UserName   varchar2(20)
 );
insert into t_meiyong3 values('管理员1');
insert into t_meiyong3 values('管理员2');
insert into t_meiyong3 values('管理员3');
insert into t_meiyong3 values('管理员4');
insert into t_meiyong3 values('管理员5');
insert into t_meiyong3 values('管理员6');


 select UserName from t_meiyong3 group by UserName ;
 select stuff((select ',''' +UserName+'''' from t_meiyong3 group by UserName for xml  path('')),1,1,'');
 
 
 --  聚合函数中的 group_concat()  https://blog.csdn.net/mathcompfrac/article/details/53931930 
 

drop table t_meiyong4; 
create table t_meiyong4
( 
DepID int,
StaffName   varchar2(20)
);
insert into t_meiyong4 values(101,'徐益涛');
insert into t_meiyong4 values(101,'毛泽东');
insert into t_meiyong4 values(101,'马克思');
insert into t_meiyong4 values(102,'郭敬明');
insert into t_meiyong4 values(102,'韩寒');
insert into t_meiyong4 values(102,'莫言');
insert into t_meiyong4 values(103,'马化腾');

select * from t_meiyong4;
select DepID,group_concat(StaffName) from t_meiyong4 group by DepID;


--
drop table t_meiyong3;
drop table t_meiyong4;  

create table t_meiyong3
( 
id int,
name   varchar2(20)
);
create table t_meiyong4
( 
id int,
rid int,
name   varchar2(20)
);
 

INSERT INTO t_meiyong3(id, name) VALUES (1, 'ipad'); 
INSERT INTO t_meiyong3(id, name) VALUES (2, 'mac');

INSERT INTO t_meiyong4(id, rid, name) VALUES (1, 1, 'ipad1'); 
INSERT INTO t_meiyong4(id, rid, name) VALUES (2, 1, 'ipad2'); 
INSERT INTO t_meiyong4(id, rid, name) VALUES (3, 1, 'ipad3'); 
INSERT INTO t_meiyong4(id, rid, name) VALUES (4, 2, 'pro'); 
INSERT INTO t_meiyong4(id, rid, name) VALUES (5, 2, 'air'); 
INSERT INTO t_meiyong4(id, rid, name) VALUES (6, 2, 'mini'); 

select * from t_meiyong3;
select * from t_meiyong4;

SELECT 
a.id, 
a.name, 
GROUP_CONCAT(b.name) as version 
FROM t_meiyong3 a JOIN t_meiyong4 b ON a.id = b.rid 
GROUP BY a.id;
 
 --   查询出某个表的所有字段信息  https://blog.csdn.net/aflyeaglenku/article/details/50884837 
 
 PRAGMA  table_info([t_meiyong1]) 
 
  新增一列

alter table t_meiyong1 add column xx varchar;
alter table t_meiyong1 add column yy char(20) default '';

 
 
 
 
 --  获取sqlite3数据库表中所有字段		http://www.jb51.net/article/98469.htm 
select sql from sqlite_master where tbl_name = 't_meiyong1' and type = 'table'
 
 
 
 
 
 
 
 
 
 
 
  
 
 
 
 
 
 
 