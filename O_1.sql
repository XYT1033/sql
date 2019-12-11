-- ORA-01861: 文字与格式字符串不匹配    你可以to_date('2005-7-1') 改为to_date('2005-7-1','yyyy-mm-dd') 或者 将NLS_DATE_FORMAT　的值改为：'yyyy-mm-dd'
create table t_meiyong(hire_date  Date);
insert into t_meiyong values( to_date('2105-7-1','yyyy-mm-dd') );
select * from  t_meiyong;
-- http://www.oschina.net/code/snippet_222150_17924
drop  TABLE t_meiyong;
CREATE TABLE t_meiyong(  manager_id int,  employee_name  VARCHAR2(10),  hire_date  Date ,salary int,max_salary int, min_salary int  ) ;
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(10,'xyt', to_date('2014-10-25','yyyy-mm-dd'),2200,2000,2800);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(20,'fjj', to_date('2012-9-2','yyyy-mm-dd'),13000,13000,6000);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(20,'xzz', to_date('2034-4-6','yyyy-mm-dd'),6000,13000,6000);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(30,'xbh', to_date('1992-7-1','yyyy-mm-dd'),11000,11000,2500);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(30,'txc', to_date('1992-9-21','yyyy-mm-dd'),3100,11000,2500);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(30,'xkl', to_date('1952-3-3','yyyy-mm-dd'),2900,11000,2500);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(30,'xyf', to_date('2014-10-25','yyyy-mm-dd'),2800,11000,2500);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(40,'yh', to_date('1984-3-2','yyyy-mm-dd'),2200,2000,2800);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(50,'my', to_date('1982-9-6','yyyy-mm-dd'),3400,7900,2200);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(50,'gjm', to_date('1999-10-25','yyyy-mm-dd'),3500,7900,2200);
insert into t_meiyong (manager_id,employee_name,hire_date,salary,max_salary,min_salary)values(50,'hh', to_date('1999-10-25','yyyy-mm-dd'),5400,7900,2200);
select * from  t_meiyong;

SELECT
manager_id,
 employee_name,
hire_date,
salary,
MIN(salary) KEEP (DENSE_RANK FIRST ORDER BY hire_date) OVER (PARTITION BY manager_id) "Worst",
MAX(salary) KEEP (DENSE_RANK LAST ORDER BY hire_date) OVER (PARTITION BY manager_id) "Best"
FROM t_meiyong
-- DENSE_RANK分析函数的使用  http://www.oschina.net/code/snippet_222150_17924
drop  TABLE t_meiyong;
CREATE TABLE t_meiyong(  V1  VARCHAR2(20),  V2  VARCHAR2(10),  V3  VARCHAR2(10)) ;
Insert into t_meiyong   (V1, V2, V3) Values   ('1', '1', 'm');
Insert into t_meiyong   (V1, V2, V3) Values   ('1', '2', 'f');
Insert into t_meiyong   (V1, V2, V3) Values   ('2', '1', 'n');
Insert into t_meiyong   (V1, V2, V3) Values   ('2', '2', 'g');
Insert into t_meiyong   (V1, V2, V3) Values   ('3', '1', 'b');
Insert into t_meiyong   (V1, V2, V3) Values   ('3', '2', 'a');
Insert into t_meiyong   (V1, V2, V3) Values   ('1', '3', 'a');
select * from  t_meiyong ;
SELECT t.* ,t.rowid FROM t_meiyong t order by v1,v2;
select v1
      ,max(v3) keep (dense_rank first order by v2)
      ,max(v3) keep (dense_rank last order by v2)
  from t_meiyong
group by v1;
--  oracle 分析函数中 keep关键字的使用   http://blog.itpub.net/11813230/viewspace-693153/
drop  TABLE t_meiyong;
create table t_meiyong(id1 int ,id2 int,id3 int);
insert into t_meiyong(id1,id2,id3)
values(1,111,1);
insert into t_meiyong(id1,id2,id3)
values(1,222,1);
insert into t_meiyong(id1,id2,id3)
values(1,333,2);
insert into t_meiyong(id1,id2,id3)
values(1,444,3);
 
insert into t_meiyong(id1,id2,id3)
values(2,555,1);
insert into t_meiyong(id1,id2,id3)
values(2,666,2);
insert into t_meiyong(id1,id2,id3)
values(2,777,3);
 
select  * from t_meiyong;
-- 按照ID1分组,ID3排序后，第一个最小的ID2，预期ID1=1的是111 ID1=2的是555
SELECT t.id1, t.id2, t.id3, MIN(t.id2) keep(dense_rank FIRST ORDER BY t.id3) over(PARTITION BY t.id1) AS minval FROM t_meiyong t;
-- 按照ID1分组，ID3排序后，最后一个最小值ID2，预期ID1=1的是444，ID1=2的是777
SELECT t.id1, t.id2, t.id3, MIN(t.id2) keep(dense_rank last ORDER BY t.id3) over(PARTITION BY t.id1) AS minval FROM t_meiyong t;
--  如果ID3有重复，比如ID1=1，ID3=1的两个数据
SELECT t.id1, t.id2, t.id3, MAX(t.id2) keep(dense_rank FIRST ORDER BY t.id3) over(PARTITION BY t.id1) as maxval FROM t_meiyong t;
-- Oracle 中 keep 的用法 http://blog.csdn.net/a9529lty/article/details/6534564
drop  TABLE t_meiyong;
create table t_meiyong(ID  int ,MC  int,SL int);
insert into t_meiyong values(1,111,1);
insert into t_meiyong values(1,222,1);
insert into t_meiyong values(1,333,2);
insert into t_meiyong values(1,555,3);
insert into t_meiyong values(1,666,3);
insert into t_meiyong values(2,111,1);
insert into t_meiyong values(2,222,1);
insert into t_meiyong values(2,333,2);
insert into t_meiyong values(2,555,2);
select *from t_meiyong;
select id,mc,sl,
 min(mc) keep (DENSE_RANK first ORDER BY sl) over(partition by id),
 max(mc) keep (DENSE_RANK last ORDER BY sl) over(partition by id)
 from t_meiyong;
 
select id,mc,sl,
 min(mc) keep (DENSE_RANK first ORDER BY sl) over(partition by id),
 max(mc) keep (DENSE_RANK first ORDER BY sl) over(partition by id),
 min(mc) keep (DENSE_RANK last ORDER BY sl) over(partition by id),
 max(mc) keep (DENSE_RANK last ORDER BY sl) over(partition by id)
 from t_meiyong;
-- Parttion by 关键字是Oracle中分析性函数的一部分，它和聚合函数不同的地方在于它能够返回一个分组中的多条记录，而聚合函数一般只有一条反映统计值的结果。  http://www.cnblogs.com/jak-black/p/4210653.html
 drop  TABLE t_meiyong;
create table t_meiyong(USERID  int ,Salary  int,Deptid int);
insert into t_meiyong values(1,200,1);
insert into t_meiyong values(2,2000,1);
insert into t_meiyong values(3,200,1);
insert into t_meiyong values(4,1000,2);
insert into t_meiyong values(5,1000,2);
insert into t_meiyong values(6,3000,2);
 
select  t_meiyong.userid 工号,t_meiyong.salary 工资,t_meiyong.deptid 部门编号 from t_meiyong;
-- 查询出每个部门工资最低的员工编号【每个部门可能有两个最低的工资员工】  
--  方法一
select t_meiyong.* from t_meiyong 
inner join(select min(salary) as salary,deptid from t_meiyong group by deptid) c
on t_meiyong.salary=c.salary and t_meiyong.deptid=c.deptid 
-- 方法二
select * from t_meiyong 
inner join(select min(salary) as salary,deptid from t_meiyong group by deptid) c
using(salary,deptid)
-- 方法三
--row_number() 顺序排序
select row_number() over(partition by deptid order by salary) my_rank ,deptid,USERID,salary from t_meiyong;
--rank() （跳跃排序，如果有两个第一级别时，接下来是第三级别）
select rank() over(partition by deptid order by salary) my_rank,deptid,USERID,salary from t_meiyong;
--dense_rank（）（连续排序，如果有两个第一级别时，接下来是第二级）
select dense_rank() over(partition by deptid order by salary) my_rank,deptid,USERID,salary from t_meiyong;
-------方案3解决方案
select * from (select rank() over(partition by deptid order by salary) my_rank,deptid,USERID,salary from t_meiyong) where my_rank=1;
select * from (select dense_rank() over(partition by deptid order by salary) my_rank,deptid,USERID,salary from t_meiyong) where my_rank=1;
--  oracle使用using关键字 用using关键字进行简化。 1.查询必须是等值连接。 2.等值连接中的列必须具有相同的名称和数据类型。http://www.2cto.com/database/201503/384694.html unfinish
select * from scott.emp t;
select * from scott.dept d;

select* from scott.emp e inner join scott.dept d using(deptno)
select e.empno,e.ename,e.sal,deptno,d.dname from scott.emp e inner join scott.dept d using(deptno);
--  ORACLE中RECORD、VARRAY、TABLE的使用详解  http://blog.csdn.net/liangweiwei130/article/details/38223319 unfinish
 drop  TABLE t_meiyong1;
CREATE TABLE t_meiyong1  
(  
ORG_ID INT NOT NULL, --组织机构主键ID  
ORG_NAME VARCHAR2(50),--组织机构名称  
PARENT_ID INT--组织机构的父级  
)   
--一级组织机构  
INSERT INTO t_meiyong1(ORG_ID, ORG_NAME, PARENT_ID) VALUES(1, '一级部门1',0);  
--二级部门  
INSERT INTO t_meiyong1(ORG_ID, ORG_NAME, PARENT_ID) VALUES(2, '二级部门2',1);  
INSERT INTO t_meiyong1(ORG_ID, ORG_NAME, PARENT_ID) VALUES(3, '二级部门3',1);  
INSERT INTO t_meiyong1(ORG_ID, ORG_NAME, PARENT_ID) VALUES(4, '二级部门4',1);  
select * from t_meiyong1


DECLARE   
  TYPE TYPE_ORG_RECORD IS RECORD(  
  V_ORG_NAME t_meiyong1.ORG_NAME%TYPE,  
  V_PARENT_ID t_meiyong1.PARENT_ID%TYPE);  
  V_ORG_RECORD TYPE_ORG_RECORD;  
BEGIN  
  SELECT ORG_NAME,PARENT_ID INTO V_ORG_RECORD  
  FROM t_meiyong1 SO  
  WHERE SO.ORG_ID=&ORG_ID;  
  DBMS_OUTPUT.PUT_LINE('部门名称：' || V_ORG_RECORD.V_ORG_NAME);  
  DBMS_OUTPUT.PUT_LINE('上级部门编码：' || TO_CHAR(V_ORG_RECORD.V_PARENT_ID));  
END;  
-- Oracle 函数大全(字符串函数，数学函数，日期函数，逻辑运算函数，其他函数) http://www.cnblogs.com/wuyisky/archive/2010/02/24/1672344.html 
select ascii('A') A,ascii('a') a,ascii('0') zero,ascii(' ') space from dual; 
select chr(54740) zhao,chr(65) chr65 from dual; 
select concat('010-','88888888')||'转23' 高乾竞电话 from dual; 
select initcap('smith') upp from dual;   -- 返回字符串并将字符串的第一个字母变为大写; 
select instr('oracle traning','ra',1,2) instring from dual;  -- INSTR(C1,C2,I,J) 在一个字符串中搜索指定的字符,返回发现指定的字符的位置; C1 被搜索的字符串 C2 希望搜索的字符串 I 搜索的开始位置,默认为1 J 出现的位置,默认为1 
		select lower('AaBbCcDd')AaBbCcDd from dual;  -- 返回字符串,并将所有的字符小写 
		select upper('AaBbCcDd') upper from dual;  --  返回字符串,并将所有的字符大写 
		select lpad(rpad('gao',10,'*'),17,'*')from dual;  -- RPAD和LPAD(粘贴字符) RPAD 在列的右边粘贴字符 LPAD 在列的左边粘贴字符  不够字符则用*来填满
		select ltrim(rtrim(' gao qian jing ',' '),' ') from dual; 
		select substr('13088888888',3,8) from dual;   -- SUBSTR(string,start,count)  取子字符串,从start开始,取count个 
		select replace('he love you','he','i') from dual; 
  drop   table t_meiyong1;
create table t_meiyong1(xm varchar(8)); 
insert into t_meiyong1 values('weather'); 
insert into t_meiyong1 values('wether'); 
insert into t_meiyong1 values('gao'); 
select * from t_meiyong1;
select xm from t_meiyong1 where soundex(xm)=soundex('weather');  -- SOUNDEX  返回一个与给定的字符串读音相同的字符串 
	select abs(100),abs(-100) from dual;  --  返回指定值的绝对值 
	select ceil(3.1415927) from dual;  -- 返回大于或等于给出数字的最小整数 
	select exp(2),exp(1) from dual;  -- 返回一个数字e的n次方根 
	select mod(10,3),mod(3,3),mod(2,3) from dual;  -- MOD(n1,n2)  返回一个n1除以n2的余数 
	select trunc(124.1666,-2) trunc1,trunc(124.16666,2) from dual;  --  TRUNC  按照指定的精度截取一个数 
	select to_char(add_months(to_date('199912','yyyymm'),2),'yyyymm') from dual;  -- ADD_MONTHS  增加或减去月份 
	select to_char(sysdate,'yyyy.mm.dd'),to_char((sysdate)+1,'yyyy.mm.dd'), last_day(sysdate)   from dual;  --  LAST_DAY  返回日期的最后一天 
	select months_between('19-12月-1999','19-3月-1999') mon_between from dual;  --  给出date2-date1的月份 
	select to_char(sysdate,'yyyy.mm.dd hh24:mi:ss') bj_time,to_char(new_time 
	(sysdate,'PDT','GMT'),'yyyy.mm.dd hh24:mi:ss') los_angles from dual;   --  NEW_TIME(date,'this','that')   给出在this时区=other时区的日期和时间 
	select next_day('18-5月-2001','星期五') next_day from dual;  --NEXT_DAY(date,'day')  给出日期date和星期x之后计算下一个星期的日期 
	select to_char(sysdate,'dd-mm-yyyy day') from dual;  -- SYSDATE  用来得到系统的当前日期 
	select to_char(trunc(sysdate,'hh'),'yyyy.mm.dd hh24:mi:ss') hh, 
	to_char(trunc(sysdate,'mi'),'yyyy.mm.dd hh24:mi:ss') hhmm from dual;  -- trunc(date,fmt)按照给出的要求将日期截断,如果fmt='mi'表示保留分,截断秒 
	select rowid,rowidtochar(rowid),ename from scott.emp;  -- CHARTOROWID 将字符数据类型转换为ROWID类型 
	select convert('strutzEEE','we8hp','f7dec') "conversion" from dual; -- CONVERT(c,dset,sset)  将源字符串 sset从一个语言字符集转换到另一个目的dset字符集 

select user from dual;  -- 返回当前用户的名字 
select username,user_id from dba_users where user_id=uid;  --  UID  返回标识当前用户的唯一整数 
select userenv('isdba') from dual; -- 返回当前用户环境的信息,opt 可以是:  ENTRYID,SESSIONID,TERMINAL,ISDBA,LABLE,LANGUAGE,CLIENT_INFO,LANG,VSIZE 
select userenv('isdba') from dual;  -- ISDBA 查看当前用户是否是DBA如果是则返回true 
select userenv('sessionid') from dual; --  SESSION  返回会话标志 
select userenv('language') from dual;  -- LANGUAGE  返回当前环境变量 
drop  table t_meiyong;
create table t_meiyong(xm varchar(8),sal number(7,2)); 
insert into t_meiyong values('gao',1111.11); 
insert into t_meiyong values('gao',1111.11); 
insert into t_meiyong values('zhu',5555.55); 
select avg(distinct sal),avg(all sal), max(distinct sal),min(all sal)    from  t_meiyong;  -- .MAX(DISTINCT|ALL)  求最大值,ALL表示对所有的值求最大值,DISTINCT表示对不同的值求最大值,相同的只取一次 MIN(DISTINCT|ALL)  求最小值,ALL表示对所有的值求最小值,DISTINCT表示对不同的值求最小值,相同的只取一次  
select stddev(sal) from scott.emp;  --  STDDEV(distinct|all)  求标准差,ALL表示对所有的值求标准差,DISTINCT表示只对不同的值求标准差 
-- Oracle高级查询之OVER (PARTITION BY ..)  http://www.cnblogs.com/shined/archive/2013/01/16/2862809.html
select * from   scott.emp;
select * from   scott.dept;
-- 现在客户有这样一个需求，查询每个部门工资最高的雇员的信息，相信有一定oracle应用知识的同学都能写出下面的SQL语句：
select e.ename, e.job, e.sal, e.deptno  
  from scott.emp e,  
       (select e.deptno, max(e.sal) sal from scott.emp e group by e.deptno) me  
 where e.deptno = me.deptno  
   and e.sal = me.sal;
-- 在满足客户需求的同时，大家应该习惯性的思考一下是否还有别的方法。这个是肯定的，就是使用本小节标题中rank() over(partition by...)或dense_rank() over(partition by...)语法，SQL分别如下：
   select e.ename, e.job, e.sal, e.deptno  
  from (select e.ename,  
               e.job,  
               e.sal,  
               e.deptno,  
               rank() over(partition by e.deptno order by e.sal desc) rank  
          from scott.emp e) e  
 where e.rank = 1;  
 
 select e.ename, e.job, e.sal, e.deptno  
  from (select e.ename,  
               e.job,  
               e.sal,  
               e.deptno,  
               dense_rank() over(partition by e.deptno order by e.sal desc) rank  
          from scott.emp e) e  
 where e.rank = 1;  
/* 为什么会得出跟上面的语句一样的结果呢？这里补充讲解一下rank()/dense_rank() over(partition by e.deptno order by e.sal desc)语法。
over:  在什么条件之上。
partition by e.deptno:  按部门编号划分（分区）。
order by e.sal desc:  按工资从高到低排序（使用rank()/dense_rank() 时，必须要带order by否则非法）
rank()/dense_rank():  分级
整个语句的意思就是：在按部门划分的基础上，按工资从高到低对雇员进行分级，“级别”由从小到大的数字表示（最小值一定为1）。
那么rank()和dense_rank()有什么区别呢？
rank():  跳跃排序，如果有两个第一级时，接下来就是第三级。
dense_rank():  连续排序，如果有两个第一级时，接下来仍然是第二级。 */

--现在我们已经查询得到了部门最高/最低工资，客户需求又来了，查询雇员信息的同时算出雇员工资与部门最高/最低工资的差额。这个还是比较简单，在第一节的groupby语句的基础上进行修改如下：
select e.ename,  
         e.job,  
         e.sal,  
         e.deptno,  
         e.sal - me.min_sal diff_min_sal,  
         me.max_sal - e.sal diff_max_sal  
    from scott.emp e,  
         (select e.deptno, min(e.sal) min_sal, max(e.sal) max_sal  
            from scott.emp e  
           group by e.deptno) me  
   where e.deptno = me.deptno  
   order by e.deptno, e.sal;  

-- 上面我们用到了min()和max()，前者求最小值，后者求最大值。如果这两个方法配合over(partition by ...)使用会是什么效果呢？大家看看下面的SQL语句：
select e.ename,  
       e.job,  
       e.sal,  
       e.deptno,  
       nvl(e.sal - min(e.sal) over(partition by e.deptno), 0) diff_min_sal,  
       nvl(max(e.sal) over(partition by e.deptno) - e.sal, 0) diff_max_sal  
  from scott.emp e;  
-- oracle中rownum和rowid的区别 http://blog.csdn.net/wonder1053/article/details/7268620
select *
  from (select rownum rn, a.* from scott.emp a) t
where t.rn between 2 and 10;
--  http://zhidao.baidu.com/link?url=qKNpfEmImovJQ0fNFjzjBtDMNhoymu7PHQMxP_cOA0IduSQDkAJOwMTMqhMGKPlQMowU68E1Xu9ib__Z0dhMCq
drop  TABLE t_meiyong;
create table t_meiyong(GROUP_ID int ,JOB VARCHAR2(50),NAME  VARCHAR2(50),SALARY int );
insert into  t_meiyong values(10,'Coding','Bruce',1000);
insert into  t_meiyong values(10,'Programmer','Clair',1000);
insert into  t_meiyong values(10,'Architect','Gideon',1000);
insert into  t_meiyong values(10,'Director','Hill',1000);
insert into  t_meiyong values(20,'Coding','Jason',2000);
insert into  t_meiyong values(20,'Programmer','Joey',2000);
insert into  t_meiyong values(20,'Architect','Martin',2000);
insert into  t_meiyong values(20,'Director','Michael',2000);
insert into  t_meiyong values(30,'Coding','xyt',3000);
insert into  t_meiyong values(30,'Programmer','xbh',3000);
insert into  t_meiyong values(30,'Architect','xyf',3000);
insert into  t_meiyong values(30,'Director','fjj',3000);
insert into  t_meiyong values(40,'Coding','yh',4000);
insert into  t_meiyong values(40,'Programmer','my',4000);
insert into  t_meiyong values(40,'Architect','gjm',4000);
insert into  t_meiyong values(40,'Director','hh',4000);
select * from  t_meiyong;
select group_id,job,name,sum(salary) from t_meiyong group by rollup(group_id,job,name);
select * from  t_meiyong;
select group_id,job,name,sum(salary) from t_meiyong group by rollup(group_id,job,name); -- 使用rollup函数查询 等价于：
select group_id,job,name,sum(salary) from t_meiyong group by group_id,job,name
union all
select group_id,job,null,sum(salary) from t_meiyong group by group_id,job
union all
select group_id,null,null,sum(salary) from t_meiyong group by group_id
union all
select null,null,null,sum(salary) from t_meiyong

select group_id,job,name,sum(salary) from t_meiyong group by cube(group_id,job,name); --使用cube函数  等价于：
select group_id,job,name,sum(salary) from t_meiyong group by group_id,job,name
union all
select group_id,job,null,sum(salary) from t_meiyong group by group_id,job
union all
select group_id,null,name,sum(salary) from t_meiyong group by group_id,name
union all
select group_id,null,null,sum(salary) from t_meiyong group by group_id
union all
select null,job,name,sum(salary) from t_meiyong group by job,name
union all
select null,job,null,sum(salary) from t_meiyong group by job
union all
select null,null,name,sum(salary) from t_meiyong group by name
union all
select null,null,null,sum(salary) from t_meiyong;

-- 由此可见两个函数对于汇总统计来说要比普通函数好用的多，另外还有一个配套使用的函数 grouping(**):当**字段为null的时候值为1，当字段**非null的时候值为0；
select grouping(group_id),job,name,sum(salary) from t_meiyong group by rollup(group_id,job,name);
-- 添加一列用来直观的显示所有的汇总字段：
select group_id,job,name,
 case when name is null and nvl(group_id,0)=0 and job is null   then '全表聚合'
   when name is null and nvl(group_id,0)=0 and job is not null then 'JOB聚合'
   when name is null and  grouping(group_id)=0 and job is null then 'GROUPID聚合'
   when name is not null and nvl(group_id,0)=0 and job is null   then 'Name聚合'
   when name is not null and grouping(group_id)=0 and job is null   then 'GROPName聚合'
   when name is not null and grouping(group_id)=1 and job is not null   then 'JOBName聚合'
   when name is  null and grouping(group_id)=0 and job is not null   then 'GROUPJOB聚合'
    else
 '三列汇总' end ,
sum(salary) from t_meiyong group by cube(group_id,job,name) ;






















