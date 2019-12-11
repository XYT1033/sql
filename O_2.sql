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
--������Ҫ�ֱ�ͳ��VP������ְλ����������ͨ��Ա������������ʹ�ü򵥵�GROUP BY JOB�ǲ��еģ�ʹ��DECODE��ʵ�־ͺܼ�
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
--���󣺰�����DEPT_NAME����A->B->C��������ÿ�������ڲ�������REGION_ID����
--����������Ĳ���DEPT_NAME�������֣�varchar2����ֱ������ʱ���еģ�����ܽ�DEPT_NAME��ÿ��ֵתΪ��Ӧ�����֣�������Ϳ����ˡ�
SELECT ID,DEPT_NAME,REGION_ID
FROM t_meiyong1
ORDER BY DECODE(DEPT_NAME,
'deptA',1,
'deptb',2,
3),
REGION_ID;
-- ������DEPT_NAMEΪdeptA����ID�������У�����REGION_ID��������
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

-- ʵ����ת�У�
SELECT STUDENT_NAME,DECODE(COURSE_TYPE,'english',COURSE_SCORE) FROM t_meiyong2;
-- ����������䣬�����벻����Ĳ�������
SELECT STUDENT_NAME,
MAX(DECODE(COURSE_TYPE,'english',COURSE_SCORE)) ENGLISH,
MAX(DECODE(COURSE_TYPE,'chinese',COURSE_SCORE)) CHINESE,
MAX(DECODE(COURSE_TYPE,'math',COURSE_SCORE)) MATH
FROM t_meiyong2
GROUP BY STUDENT_NAME;

--Ϊʲô��ҪMAX����ΪҪʵ����ת�У����ֶη��飬��DECODE�еķǷ����б���Ҫ�з��麯������ȻMIN��SUM
-- AVG���麯��Ҳ����ʵ�֣�MAX��MIN���κ����Ͷ����ã�SUM��AVGֻ�ܶ���ֵ��

-- oracle�����Զ�����  http://zhidao.baidu.com/link?url=m2o0YvFQLjFDW8IHHkIbaqEuNeNX-RCaC398GSqi6_q6WnaxxMjU3INd8Q4jNxWxyjBeacxGp8q5PgtQAsZdva
drop  table t_meiyong1;
create table t_meiyong1(
  id  number(6) primary key,
  name varchar2(30)
);

drop SEQUENCE sequence_meiyong;
CREATE SEQUENCE sequence_meiyong
INCREMENT BY 1     --ÿ�μӼ�
START WITH 1       --���дӼ���ʼ
minvalue 1
MAXVALUE 9999;

insert into t_meiyong1 values(sequence_meiyong.nextval,'������');
insert into t_meiyong1 values(sequence_meiyong.nextval,'ë��');
insert into t_meiyong1 values(sequence_meiyong.nextval,'�ܶ���');
insert into t_meiyong1 values(sequence_meiyong.nextval,'������');

select * from t_meiyong1;

--  oracle ��ν����ű�ͬ�н��кϲ�  http://www.cnblogs.com/arkia123/archive/2013/01/28/2880703.html
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
insert into t_meiyong1 values(1,'����',20);
insert into t_meiyong1 values(2,'����',22);
insert into t_meiyong1 values(3,'����',25);
insert into t_meiyong1 values(4,'����',23);
insert into t_meiyong1 values(5,'����',22);
insert into t_meiyong1 values(6,'��ǿ',21);

insert into t_meiyong2 values(1,'����',30, to_date('1983','yyyy'));
insert into t_meiyong2 values(2,'����',22,to_date('1991','yyyy'));
insert into t_meiyong2 values(3,'����',25,to_date('1988','yyyy'));

select * from t_meiyong1;
select * from t_meiyong2;
-- ������뽫���ű�ϲ�������ʾ������������ݣ�����Ҫ�õ� union
SELECT t_meiyong1.id , t_meiyong1.name , t_meiyong1.age , null FROM t_meiyong1
UNION
SELECT t_meiyong2.id , t_meiyong2.name , t_meiyong2.age , t_meiyong2.birthday FROM t_meiyong2;

-- Ҳ����ʹ�� union all ����������Ľ����һ����union all ���Ǽ򵥵Ľ����ű�ϲ��������������������union ���ص��ǽ����е�һ�н�������Ĭ���ǵ�һ�У�������õڶ��н������򣬴����޸�����
SELECT t_meiyong1.id , t_meiyong1.name n, t_meiyong1.age , null FROM t_meiyong1
UNION
SELECT t_meiyong2.id , t_meiyong2.name n, t_meiyong2.age , t_meiyong2.birthday FROM t_meiyong2
ORDER BY n ;

--  oracle������mysql��for xml path('')�Ĺ��� http://zhidao.baidu.com/link?url=SX-2HzYY3Bc7tHVAqA61xYfW21yYAgBtxdDzvyp4uEe75s0pUzkDp-i4NfNosU-9knQt3t6ahCpuO5kdN255P_
drop  table t_meiyong1;
create  table t_meiyong1
(
        c_name   varchar2(20),
        c_status    int 
);
insert into t_meiyong1 values('����',1);
insert into t_meiyong1 values('�ܽ���',2);
insert into t_meiyong1 values('��ݮ�ֶ�',1);
insert into t_meiyong1 values('��ӽ��',1);
insert into t_meiyong1 values('�����ֶ�',2);
insert into t_meiyong1 values('������',1);


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
insert into t_meiyong1 values(1,'ƻ��',2);
insert into t_meiyong1 values(2,'����',5);
insert into t_meiyong1 values(1,'����',4);
insert into t_meiyong1 values(3,'����',1);
insert into t_meiyong1 values(3,'�㽶',1);
insert into t_meiyong1 values(1,'����',3);

select * from t_meiyong1;
select u_id, wmsys.wm_concat(goods) goods_sum from t_meiyong1 group by u_id ;

select u_id, wmsys.wm_concat(goods || '(' || num || '��)' ) goods_sum  
from t_meiyong1  
group by u_id;


























