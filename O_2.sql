-- decode http://www.2cto.com/database/201410/344141.html
drop TABLE t_meiyong;
CREATE TABLE t_meiyong
(
ID NUMBER(10),
NAME VARCHAR2(10),
JOB VARCHAR2(20)
);
INSERT INTO t_meiyong VALUES(1,'jack','VP');
INSERT INTO t_meiyong VALUES(2,'tony','CEO');
INSERT INTO t_meiyong VALUES(3,'merry','VP');
INSERT INTO t_meiyong VALUES(4,'james','OPERATION');
INSERT INTO t_meiyong VALUES(5,'linda','OPERATION');
select * from t_meiyong;
--现在需要分别统计VP及以上职位的人数、普通雇员的人数，这是使用简单的GROUP BY JOB是不行的，使用DECODE来实现就很简单
SELECT DECODE(JOB,'VP','VP_CEO','CEO','VP_CEO','OPERATION') JOB,
COUNT(*) JOB_CNT
FROM t_meiyong
GROUP BY DECODE(JOB,'VP','VP_CEO','CEO','VP_CEO','OPERATION');
--
drop TABLE t_meiyong1;
CREATE TABLE t_meiyong1
(
ID NUMBER,
DEPT_NAME VARCHAR2(10),
REGION_ID NUMBER(10)
);
INSERT INTO t_meiyong1 VALUES(1,'deptA',12);
INSERT INTO t_meiyong1 VALUES(2,'deptA',10);
INSERT INTO t_meiyong1 VALUES(3,'deptA',9);
INSERT INTO t_meiyong1 VALUES(4,'deptA',7);
INSERT INTO t_meiyong1 VALUES(5,'deptB',12);
INSERT INTO t_meiyong1 VALUES(6,'deptB',13);
INSERT INTO t_meiyong1 VALUES(7,'deptB',22);
INSERT INTO t_meiyong1 VALUES(8,'deptB',9);
INSERT INTO t_meiyong1 VALUES(9,'deptC',8);
INSERT INTO t_meiyong1 VALUES(10,'deptC',10);
INSERT INTO t_meiyong1 VALUES(11,'deptC',11);
select * from t_meiyong1;
--需求：按部门DEPT_NAME排序（A->B->C），对于每个部门内部按区域REGION_ID升序
--分析：这里的部门DEPT_NAME不是数字（varchar2），直接排序时不行的，如果能将DEPT_NAME的每个值转为对应的数字，再排序就可以了。
SELECT ID,DEPT_NAME,REGION_ID
FROM t_meiyong1
ORDER BY DECODE(DEPT_NAME,
'deptA',1,
'deptb',2,
3),
REGION_ID;
-- 需求：若DEPT_NAME为deptA，则按ID升序排列，否则按REGION_ID升序排序
SELECT ID,DEPT_NAME,REGION_ID
FROM t_meiyong1
ORDER BY DECODE(DEPT_NAME,
'deptA',ID,
REGION_ID);
-- 
DROP TABLE t_meiyong2;
CREATE TABLE t_meiyong2
(
STUDENT_NO NUMBER(10),
STUDENT_NAME VARCHAR2(10),
COURSE_TYPE VARCHAR2(10),
COURSE_SCORE NUMBER(10)
);
INSERT INTO t_meiyong2 VALUES(1,'jack','english',80);
INSERT INTO t_meiyong2 VALUES(1,'jack','chinese',90);
INSERT INTO t_meiyong2 VALUES(1,'jack','math',85);
INSERT INTO t_meiyong2 VALUES(2,'tony','english',70);
INSERT INTO t_meiyong2 VALUES(2,'tony','chinese',95);
INSERT INTO t_meiyong2 VALUES(2,'tony','math',80);
select * from t_meiyong2;

-- 实现行转列：
SELECT STUDENT_NAME,DECODE(COURSE_TYPE,'english',COURSE_SCORE) FROM t_meiyong2;
-- 分析这条语句，分组与不分组的差别在哪里？
SELECT STUDENT_NAME,
MAX(DECODE(COURSE_TYPE,'english',COURSE_SCORE)) ENGLISH,
MAX(DECODE(COURSE_TYPE,'chinese',COURSE_SCORE)) CHINESE,
MAX(DECODE(COURSE_TYPE,'math',COURSE_SCORE)) MATH
FROM t_meiyong2
GROUP BY STUDENT_NAME;

--为什么需要MAX？因为要实现行转列，按字段分组，对DECODE中的非分组列必须要有分组函数，当然MIN、SUM
-- AVG等组函数也可以实现，MAX、MIN对任何类型都适用，SUM、AVG只能对数值型

-- oracle主键自动增长  http://zhidao.baidu.com/link?url=m2o0YvFQLjFDW8IHHkIbaqEuNeNX-RCaC398GSqi6_q6WnaxxMjU3INd8Q4jNxWxyjBeacxGp8q5PgtQAsZdva
drop  table t_meiyong1;
create table t_meiyong1(
  id  number(6) primary key,
  name varchar2(30)
);

drop SEQUENCE sequence_meiyong;
CREATE SEQUENCE sequence_meiyong
INCREMENT BY 1     --每次加几
START WITH 1       --序列从几开始
minvalue 1
MAXVALUE 9999;

insert into t_meiyong1 values(sequence_meiyong.nextval,'徐益涛');
insert into t_meiyong1 values(sequence_meiyong.nextval,'毛泽东');
insert into t_meiyong1 values(sequence_meiyong.nextval,'周恩来');
insert into t_meiyong1 values(sequence_meiyong.nextval,'朱自清');

select * from t_meiyong1;

--  oracle 如何将两张表不同列进行合并  http://www.cnblogs.com/arkia123/archive/2013/01/28/2880703.html
drop  table t_meiyong1;
drop  table t_meiyong2;
create table t_meiyong1(
  id  int primary key,
  name nvarchar2(20) ,
  age int 
);
create table t_meiyong2(
  id  int primary key,
  name nvarchar2(20) ,
  age int ,
  birthday date
);
insert into t_meiyong1 values(1,'张三',20);
insert into t_meiyong1 values(2,'李四',22);
insert into t_meiyong1 values(3,'王五',25);
insert into t_meiyong1 values(4,'赵六',23);
insert into t_meiyong1 values(5,'张三',22);
insert into t_meiyong1 values(6,'王强',21);

insert into t_meiyong2 values(1,'张三',30, to_date('1983','yyyy'));
insert into t_meiyong2 values(2,'李四',22,to_date('1991','yyyy'));
insert into t_meiyong2 values(3,'王五',25,to_date('1988','yyyy'));

select * from t_meiyong1;
select * from t_meiyong2;
-- 　如果想将两张表合并，并显示表二的所有数据，就需要用到 union
SELECT t_meiyong1.id , t_meiyong1.name , t_meiyong1.age , null FROM t_meiyong1
UNION
SELECT t_meiyong2.id , t_meiyong2.name , t_meiyong2.age , t_meiyong2.birthday FROM t_meiyong2;

-- 也可以使用 union all 方法，排序的结果不一样，union all 就是简单的将两张表合并，并不进行排序操作。union 的特点是将表中的一列进行排序，默认是第一列，如果想让第二列进行排序，代码修改如下
SELECT t_meiyong1.id , t_meiyong1.name n, t_meiyong1.age , null FROM t_meiyong1
UNION
SELECT t_meiyong2.id , t_meiyong2.name n, t_meiyong2.age , t_meiyong2.birthday FROM t_meiyong2
ORDER BY n ;

--  oracle中类似mysql中for xml path('')的功能 http://zhidao.baidu.com/link?url=SX-2HzYY3Bc7tHVAqA61xYfW21yYAgBtxdDzvyp4uEe75s0pUzkDp-i4NfNosU-9knQt3t6ahCpuO5kdN255P_
drop  table t_meiyong1;
create  table t_meiyong1
(
        c_name   varchar2(20),
        c_status    int 
);
insert into t_meiyong1 values('汪峰',1);
insert into t_meiyong1 values('周杰伦',2);
insert into t_meiyong1 values('草莓乐队',1);
insert into t_meiyong1 values('梁咏琪',1);
insert into t_meiyong1 values('花儿乐队',2);
insert into t_meiyong1 values('王心凌',1);


select * from t_meiyong1;
select c_status,replace(wm_concat(c_name),',',';') from t_meiyong1
group by c_status;

--  wm_concat http://www.jb51.net/article/37604.htm
drop  table t_meiyong1;
create table t_meiyong1
(
       u_id       int,
       goods           varchar2(20),
       num int
);
insert into t_meiyong1 values(1,'苹果',2);
insert into t_meiyong1 values(2,'梨子',5);
insert into t_meiyong1 values(1,'西瓜',4);
insert into t_meiyong1 values(3,'葡萄',1);
insert into t_meiyong1 values(3,'香蕉',1);
insert into t_meiyong1 values(1,'橘子',3);

select * from t_meiyong1;
select u_id, wmsys.wm_concat(goods) goods_sum from t_meiyong1 group by u_id ;

select u_id, wmsys.wm_concat(goods || '(' || num || '斤)' ) goods_sum  
from t_meiyong1  
group by u_id;


























