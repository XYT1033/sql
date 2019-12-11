


oracle横列转换  http://www.360doc.com/content/12/0331/00/15643_199478544.shtml 

drop   TABLE t_meiyong1;
 
  CREATE TABLE t_meiyong1
  (
  
	stdname  varchar(20) ,
	stdsubject varchar(20) ,
	grade  varchar(20) 
	
  );
 
insert into  t_meiyong1 values("徐益涛","语文",58);
insert into  t_meiyong1 values("徐益涛","数学",48);
insert into  t_meiyong1 values("徐益涛","物理",55);
insert into  t_meiyong1 values("徐益涛","化学",100);
insert into  t_meiyong1 values("毛泽东","语文",89);
insert into  t_meiyong1 values("毛泽东","数学",88);
insert into  t_meiyong1 values("毛泽东","物理",90);
insert into  t_meiyong1 values("毛泽东","化学",65);


	
select t.* from t_meiyong1 t;   
select sc.stdname, a.grade 语文, b.grade 数学, c.grade 物理, d.grade 化学   
  from (	select distinct stdname from t_meiyong1	) sc,   
       (	select stdname, grade from t_meiyong1 where stdsubject = '语文'	) a,   
       (	select stdname, grade from t_meiyong1 where stdsubject = '数学'	) b,   
       (	select stdname, grade from t_meiyong1 where stdsubject = '物理'	) c,   
       (	select stdname, grade from t_meiyong1 where stdsubject = '化学'	) d   
 where sc.stdname = a.stdname   
   and sc.stdname = b.stdname   
   and sc.stdname = c.stdname   
   and sc.stdname = d.stdname;




 --  sqlite实现行列转换  https://blog.csdn.net/liumengcheng/article/details/20720729 




-- SQL 将横向数据转为纵向记录   https://zhidao.baidu.com/question/255395259.html 

drop   TABLE t_meiyong2;
 
  CREATE TABLE t_meiyong2
  (
	code  varchar(20) ,
	specA varchar(20) ,
	numberA int ,
	specB  varchar(20) ,
	numberB int ,
	specC  varchar(20) ,
	numberC int
  );
 
  
insert into  t_meiyong2 values('001','28*14',150 ,'26*18.5',1242 ,'',0);
insert into  t_meiyong2 values('002 ','26.5*21',1458 ,'2*38.5',43,'3*12.5',2  );
  select * from t_meiyong2;
  
  


 SELECT 'specA' as x, code, specA , numberA FROM t_meiyong2
UNION ALL
SELECT 'specB' as x,code, specB , numberB FROM t_meiyong2
UNION ALL
SELECT 'specC' as x,code, specC , numberC FROM t_meiyong2





--  Oracle行转列、列转行的Sql语句总结 https://www.2cto.com/database/201501/367164.html 



create table test(id number,name varchar2(20));
 
insert into test values(1,'a');
insert into test values(1,'b');
insert into test values(1,'c');
insert into test values(2,'d');
insert into test values(2,'e');


select wm_concat(name) name from test;



 pivot 列转行 


create table demo(id int,name varchar(20),nums int);  ---- 创建表
insert into demo values(1, '苹果', 1000);
insert into demo values(2, '苹果', 2000);
insert into demo values(3, '苹果', 4000);
insert into demo values(4, '橘子', 5000);
insert into demo values(5, '橘子', 3000);
insert into demo values(6, '葡萄', 3500);
insert into demo values(7, '芒果', 4200);
insert into demo values(8, '芒果', 5500);


 select * from   demo
-- 分组查询 (当然这是不符合查询一条数据的要求的)
select name, sum(nums) nums from demo group by name

-- 行转列查询 
	
select * from (select name, nums from demo) pivot (sum(nums) for name in ('苹果' 苹果, '橘子', '葡萄', '芒果'));


select * from (select sum(nums) 苹果 from demo where name='苹果'),(select sum(nums) 橘子 from demo where name='橘子'),
       (select sum(nums) 葡萄 from demo where name='葡萄'),(select sum(nums) 芒果 from demo where name='芒果');


-- unpivot 行转列 


create table Fruit(id int,name varchar(20), Q1 int, Q2 int, Q3 int, Q4 int);
 
insert into Fruit values(1,'苹果',1000,2000,3300,5000);
insert into Fruit values(2,'橘子',3000,3000,3200,1500);
insert into Fruit values(3,'香蕉',2500,3500,2200,2500); 
insert into Fruit values(4,'葡萄',1500,2500,1200,3500);
select * from Fruit

-- 列转行查询

select id , name, jidu, xiaoshou from Fruit unpivot (xiaoshou for jidu in (q1, q2, q3, q4) ) 

select id, name ,'Q1' jidu, (select q1 from fruit where id=f.id) xiaoshou from Fruit f
union
select id, name ,'Q2' jidu, (select q2 from fruit where id=f.id) xiaoshou from Fruit f
union
select id, name ,'Q3' jidu, (select q3 from fruit where id=f.id) xiaoshou from Fruit f
union
select id, name ,'Q4' jidu, (select q4 from fruit where id=f.id) xiaoshou from Fruit f







  





SELECT t.C3_DEVEVDOILWELLS
	,t.C3_DEVEHOILWELLS
	,t.C3_DEVEVDGASWELLS
	,t.C3_DEVEHGASWELLS
	,t.C3_DEVEINWELLS
FROM TMP_DEP_HEADER p
	,TMP_DEVELOP_DEP_TSD t
WHERE p.PROJECTCODE = t.PROJECTCODE
	AND p.VERSION_NUMBER = t.VERSION_NUMBER
	AND p.YEAR = t.YEAR
	AND p.PROJECTCODE = 'APC.APC.DIS'
	AND p.VERSION_NUMBER = '1'
	AND p.YEAR = '2018' limit 12
	,24






	for (size_t iFs =0; iFs < CSfields.size(); iFs ++)
	{
		CSfield= CSfields[iFs];
		SQLStrAccumu.Format(_T("   t.%s  ,"), CSfield);
		SQLStr += SQLStrAccumu;
	}




SELECT t.C3_DEVEVDOILWELLS
	,t.C3_DEVEHOILWELLS
	,t.C3_DEVEVDGASWELLS
	,t.C3_DEVEHGASWELLS
	,t.C3_DEVEINWELLS
FROM TMP_DEP_HEADER p
	,TMP_DEVELOP_DEP_TSD t
WHERE p.PROJECTCODE = t.PROJECTCODE
	AND p.VERSION_NUMBER = t.VERSION_NUMBER
	AND p.YEAR = t.YEAR
	AND p.PROJECTCODE = 'APC.APC.DIS'
	AND p.VERSION_NUMBER = '1'
	AND p.YEAR = '2018' limit 12
	,24




SELECT t.C3_DEVEVDOILWELLS
	,t.C3_DEVEHOILWELLS
	,t.C3_DEVEVDGASWELLS
	,t.C3_DEVEHGASWELLS
	,t.C3_DEVEINWELLS
FROM TMP_DEP_HEADER p
	,TMP_DEVELOP_DEP_TSD t
WHERE p.PROJECTCODE = t.PROJECTCODE
	AND p.VERSION_NUMBER = t.VERSION_NUMBER
	AND p.YEAR = t.YEAR
	AND p.PROJECTCODE = 'APC.APC.DIS'
	AND p.VERSION_NUMBER = '1'
	AND p.YEAR = '2018' limit 0
	,12






SELECT t.C3_DEVEVDOILWELLS
	,t.C3_DEVEHOILWELLS
	,t.C3_DEVEVDGASWELLS
	,t.C3_DEVEHGASWELLS
	,t.C3_DEVEINWELLS
FROM TMP_DEP_HEADER p
	,TMP_DEVELOP_DEP_TSD t
WHERE p.PROJECTCODE = t.PROJECTCODE
	AND p.VERSION_NUMBER = t.VERSION_NUMBER
	AND p.YEAR = t.YEAR
	AND p.PROJECTCODE = 'APC.APC.DIS'
	AND p.VERSION_NUMBER = '1'
	AND p.YEAR = '2018' limit 12
	,24

	
	
	
	
	
	
	
	  
	
	
	
	
	
	



	
	  











  
  
  
  