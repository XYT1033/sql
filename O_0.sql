-- ��ȡ���ֶΣ� http://www.soso.io/article/12903.html
select * from SYS_SYSTEM;
select * from user_tab_columns where Table_Name='SYS_SYSTEM';    -- order by column_name;
-- ��ѯ�ֶ�ע��
select *  from user_col_comments  where Table_Name = 'SYS_SYSTEM'; 
-- ��ѯ��ע��
select * from user_tab_comments where Table_Name='SYS_SYSTEM';

-- ���ұ���������������ƣ������У�   http://www.2cto.com/database/201305/214971.html
select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = 'P' and au.table_name = 'SYS_SYSTEM';

-- ���ұ��������������ƣ����ñ�ı����Ͷ�Ӧ�ļ����������Ƿֳɶಽ��ѯ��
select * from user_constraints c where c.constraint_type = 'R' and c.table_name =  'SYS_DEPT_USER';

-- ��Oracle��ͬһ�еĶ��м�¼ƴ�ӳ�һ���ַ��� http://zhidao.baidu.com/link?url=mGRA5x3Vu1DhlVfq2WBc3QLgvuy5_6mFDQb_cRV1qpp56ynFKH_f1l6qFRd2N8NoYjLKCyC-Oj3hh-qTwnWDvd7oqDo9KAjYznQDbz2Hxci
select wm_concat(column_name) from user_tab_columns where Table_Name='SYS_SYSTEM';  
--  oracle �������ʱ����ôͬʱ�����˵�� http://zhidao.baidu.com/link?url=h-grCcdXZ1mv8O3gRF1iZea5vK2WOUTmEgzbj3-X5JYCxyaNekJgSCTsoBu3gg_RqEsoKAm-Mo1GFBfkEE0rPK
ʹ�� comment on���ٸ����ӣ�
drop table t_meiyong;
create table t_meiyong
(
empid NUMBER
);

comment on table t_meiyong is 'Ա����Ϣ'; --��ӱ�����  
comment on column t_meiyong.empid is 'Ա�����'; --���������
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

-- �����ӡ������ӡ�ȫ������ http://blog.chinaunix.net/uid-21187846-id-3288525.html
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
insert into t_meiyong values(9,'����');

insert into t_meiyong1 values(8,'����');
insert into t_meiyong1 values(1,'dave');
insert into t_meiyong1 values(2,'bl');
insert into t_meiyong1 values(1,'bl');
insert into t_meiyong1 values(2,'dave');
insert into t_meiyong1 values(3,'dba');
insert into t_meiyong1 values(4,'sf-express');
insert into t_meiyong1 values(5,'dmm');

select * from t_meiyong;
select * from t_meiyong1;
-- ��������
select * from t_meiyong1 t1 left join t_meiyong t on t1.id = t.id;
-- �ã�+����ʵ�֣� ���+�ſ�����������⣺ + ��ʾ���䣬���ĸ����мӺţ���������ƥ������ԼӺ�д���ұ�������ȫ����ʾ�����������ӡ� ע�⣺ �ã�+�� ��Ҫ�ùؼ���where
Select * from t_meiyong1 t1,t_meiyong t where t1.id=t.id(+);
Select * from t_meiyong t,t_meiyong1 t1 where t.id=t1.id(+);

-- ��������
select * from t_meiyong1 t1 right join t_meiyong t on t1.id = t.id;
-- �ã�+����ʵ�֣� ���+�ſ�����������⣺ + ��ʾ���䣬���ĸ����мӺţ���������ƥ������ԼӺ�д������ұ����ȫ����ʾ�����������ӡ�
Select * from t_meiyong1 t1,t_meiyong t where t1.id(+)=t.id;

-- ȫ������ �����ұ��������ƣ����еļ�¼����ʾ��������ĵط���null ��䡣 ȫ�����Ӳ�֧�֣�+������д����
select * from t_meiyong1 t1 full join t_meiyong t on t1.id = t.id;

 
-- Oracle��rownumԭ���ʹ��(���������˵�����)  http://www.cnblogs.com/mabaishui/archive/2009/10/20/1587165.html
drop table t_meiyong;
create table t_meiyong
(
       id int ,
       name varchar2(20)
);
insert into t_meiyong values(1,'��һ');
insert into t_meiyong values(2,'����');
insert into t_meiyong values(3,'����');
insert into t_meiyong values(4,'����');

select * from t_meiyong;
-- rownum�����ǰ���name�������ɵ���š�ϵͳ�ǰ��ռ�¼����ʱ��˳�����¼�ŵĺţ�rowidҲ��˳�����ġ�Ϊ�˽��������⣬����ʹ���Ӳ�ѯ
select rownum ,id,name from t_meiyong order by name;
-- �����ͳ��˰�name���򣬲�����rownum�����ȷ��ţ���С����
select rownum ,id,name from (select * from t_meiyong order by name);

-- ORACLE��ҳ��ѯSQL�﷨�������Ч�ķ�ҳ  http://blog.sina.com.cn/s/blog_8604ca230100vro9.html
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

-- instr http://www.jb51.net/article/31715.htm ��
--instr( string1, string2 [, start_position [, nth_appearance ] ] ) 
����--string1 
����--Դ�ַ�����Ҫ�ڴ��ַ����в��ҡ� 
����--string2 
����--Ҫ��string1�в��ҵ��ַ���. 
����--start_position 
    --���� string1 ���ĸ�λ�ÿ�ʼ���ҡ��˲�����ѡ�����ʡ��Ĭ��Ϊ1. �ַ���������1��ʼ������˲���Ϊ���������ҿ�ʼ����������˲���Ϊ�������ҵ������������Ҫ���ҵ��ַ�����Դ�ַ����еĿ�ʼ������
select instr('abcdefgh','de') position from dual; 
select instr('abcdefghbcXYT','bc',3) position from dual; 

-- INSTR�����ĸ�ʽΪ INSTR(src, subStr,startIndex, count)   src: Դ�ַ���   subStr : Ҫ���ҵ��Ӵ�   startIndex : �ӵڼ����ַ���ʼ��������ʾ����������ҡ� count: Ҫ�ҵ��ڼ���ƥ������ 
����ֵ�� �Ӵ����ַ����е�λ�ã���1��Ϊ1��������Ϊ0. ���ر�ע�⣺���srcΪ���ַ���������ֵΪnull���� 
SELECT instr('syranmo','s') FROM dual; -- ���� 1 
SELECT instr('syranmo','ra') FROM dual; -- ���� 3 
SELECT instr('syran mo','a',1,2) FROM dual; -- ���� 0  ��������������aֻ����һ�Σ����ĸ�����2������˵��2�γ���a��λ�ã���Ȼ��2����û���ٳ����ˣ����Խ������0��ע��ո�Ҳ��һ���ַ���
SELECT instr('syranmo','an',-1,1) FROM dual; -- ���� 4  ���������ҵ�������������λ�û���Ҫ����an'����ߵ�һ����ĸ��λ�ã��������ﷵ��4

select instr('hello,java world', 'l') from dual;  -- ��򵥵�һ�֣�����l�ַ�,�׸�lλ�ڵ�3��λ�á� 
select instr('hello,java world', 'l', 4) from dual; -- ����l�ַ�,�ӵ�4��λ�ÿ�ʼ�� 
select instr('hello,java world', 'l', 1, 3) from dual;   --����l�ַ�,�ӵ�1��λ�ÿ�ʼ�ĵ�3�� 
select instr('hello,java world', 'l', -1, 3) from dual;  -- ����l�ַ�,���ұߵ�1��λ�ÿ�ʼ������������ҵ�3����Ҳ���Ǵ����ҵĵ�1���� 
select instr('hello,java world', 'MM') from dual; --  �Ҳ�������0 
-- oracle �� substr�������÷� http://www.cnblogs.com/emmy/archive/2011/01/08/1930945.html
select substr('This is a test', 6, 2)  from dual;   -- return 'is'
select  substr('This is a test', 6) from dual;    -- return 'is'
select substr('TechOnTheNet', -3, 3)  from dual;   -- return 'Net'
select substr('TechOnTheNet', -6, 3) from dual ;  --  return 'The'

select substr('17010001',-4) from dual;  --  0001

--  ��oracle����ô��һ�ű�����ݲ��뵽��һ�ű���  http://zhidao.baidu.com/link?url=gdL_4h1PYGBN4MwZUaVjUGA153u7PTe4JAZT2m5SofbbsygDtjGdZyWIsN7iulNxsbxQxB8J-DWjAn2WjCxsFztSQMDm2xjfxXZ0NTT5bF3
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
comment on table t_meiyong1 is '������е�����_meiyong'; --��ӱ�����
comment on column t_meiyong1.ID is 'ID' ;
comment on column t_meiyong1.CODE is '�������' ;
comment on column t_meiyong1.NAME is '��������' ;
comment on column t_meiyong1.ABBR_PY is 'ƴ������' ;
comment on column t_meiyong1.ENABLE_FLAG is '�Ƿ���ã�1���ã�0����' ;

select * from t_meiyong1;
insert into t_meiyong1  
select 
ID,CODE,NAME,ABBR_PY,ABBR_WB,ENABLE_FLAG,ORDER_ID,REMARK,CREATE_USER_ID,CREATE_USER,CREATE_DATE,LAST_UPDATE_USER_ID,LAST_UPDATE_USER,LAST_UPDATE_DATE from  LC_BASE_PRODUCT_CLASS;

-- oracle lpad ���� http://blog.csdn.net/bjnihao/article/details/6250417
--��lpad ��������߶��ַ���ʹ��ָ�����ַ�������䡣����������˼Ҳ������⣬l��left�ļ�д��pad��������˼������lpad���Ǵ����������˼��
select lpad('abcde',10,'x') from dual;    -- result:xxxxxabcde
select lpad('abcde',10,'oq') from dual;    --  result:oqoqoabcde
select lpad('abcde',2) from dual;    --  result:ab
-- ��lpad������Ӧ����rpad������ ��rpad�������ұ߶��ַ���ʹ��ָ�����ַ�������䣬�﷨��ʽ��lpad��ʽ��ͬ��
select rpad('tech', 7) from dual;  --  result:tech
select rpad('tech', 2) from dual; --  result:te
select rpad('tech', 8, '0') from dual;  -- result:tech0000
select rpad('tech on the net', 15, 'z') from dual;  -- result:tech on the net
select rpad('tech on the net', 16, 'z') from dual;   -- result:tech on the net2

--  NVL  http://blog.sina.com.cn/s/blog_46e9573c01015ik8.html
-- NVL�����ĸ�ʽ���£�NVL(expr1,expr2) �����ǣ����oracle��һ������Ϊ����ô��ʾ�ڶ���������ֵ�������һ��������ֵ��Ϊ�գ�����ʾ��һ������������ֵ��
select scott.emp.*,NVL(comm, -1) from scott.emp;


--  rownum �� rowid ������ http://www.cnblogs.com/qqzy168/archive/2013/09/08/3308648.html
select * from  scott.emp;
select rownum rn, a.* from scott.emp a;
    
select *
from (select rownum rn, a.* from scott.emp a) t
where t.rn between 2 and 10;


-- SQLserver��Oracle��Mysql�﷨���÷��Ա�   http://wenku.baidu.com/link?url=ErGNIhQmQVsKwZTGWTuPEksvKgPfq77-dSgqqbt7QIdLQSs08RpAj50ZWb6j6h0QlsCbCTQuEaxTLa0zGGehL6LihJS7lsWtYWa8QPZwbr7

-- ͨ��USER_SOURCE��DBA_SOURCE��ALL_SOURCE��ѯOralce���ݿ����SQL���   http://blog.itpub.net/299797/viewspace-705949/
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

-- ��SQL��Oracle��ͬһ�еĶ��м�¼ƴ�ӳ�һ���ַ���  http://blog.csdn.net/little_stars/article/details/9066191
DROP TABLE t_meiyong2;  
CREATE TABLE t_meiyong2 (  
L_ID VARCHAR2(32) NOT NULL ,  
L_CONTENT VARCHAR2(512)  ,  
L_TIME VARCHAR2(32) ,  
L_USER VARCHAR2(32) ,  
PRIMARY KEY (L_ID)  
);   
  
COMMENT ON TABLE t_meiyong2 IS '��־��';  
COMMENT ON COLUMN t_meiyong2.L_ID IS '��־ID';  
COMMENT ON COLUMN t_meiyong2.L_CONTENT IS '��־����';  
COMMENT ON COLUMN t_meiyong2.L_TIME IS 'ʱ��';  
COMMENT ON COLUMN t_meiyong2.L_USER IS '������';  
  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('123', '�ڰ�', '111', '12345');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('124', '�װ�', '222', '123456');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('125', '�ڰװ�', '111', '1234567');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('126', '�װװ�', '111', '12345');  
INSERT INTO t_meiyong2 (L_ID, L_CONTENT, L_TIME, L_USER)  VALUES ('127', '�ٺٰ�', '222', '123456');  

select * from t_meiyong2;

SELECT   
L4.L_TIME  
,MAX(SUBSTR(L4.��������,2)) �����ֶ�ֵ  
FROM(  
        SELECT   
        L3.L_TIME  
        ,SYS_CONNECT_BY_PATH(L3.L_CONTENT,'*') AS ��������  
        FROM(  
                SELECT  
                L2.L_TIME  
                ,L2.L_CONTENT  
                ,L2.L_TIME||L2.�����ڱ�� AS �����ֶμӱ��,L2.L_TIME||(L2.�����ڱ��-1) AS �ϼ������ֶμӱ��  
                FROM(  
                        SELECT   
                        L1.L_TIME   -- ��������  
                        ,L1.L_CONTENT    -- ͬһ���� Ҫ�ϲ��Ĳ�ͬ�� ��ֵ  
                        ,ROW_NUMBER() OVER (PARTITION BY L1.L_TIME ORDER BY L1.L_CONTENT ASC) �����ڱ��   
                        FROM t_meiyong2 L1  
                ) L2  
        ) L3  
        START WITH L3.�ϼ������ֶμӱ�� LIKE '%0'   
        CONNECT BY PRIOR L3.�����ֶμӱ��=L3.�ϼ������ֶμӱ��  
) L4  
   
WHERE L_TIME='111'  
GROUP BY L4.L_TIME  
-- ROW_NUMBER() OVER(PARTITION BY A ORDER BY B DESC) ������  
-- ����A���飬�ڷ����ڲ�����B���򣬶��˺��������ֵ�ͱ�ʾÿ���ڲ�������˳���ţ�����������Ψһ��)  
  
-- SYS_CONNECT_BY_PATH ������ ��һ���������γ�����ʽ���ֶΣ��ڶ��������Ǹ��������Ӽ��ָ���ʾ�õķָ���  
-- CONNECT BY PRIOR �Ǳ�ʾ���ӹ�ϵ�Ķ�Ӧ  
-- START WITH ������Ҫ��ʼ�����ĵĽڵ�  


-- SYS_CONNECT_BY_PATH  ORACLE  http://www.cnblogs.com/huanghai223/archive/2010/12/10/1902696.html
drop table t_meiyong3;
create table t_meiyong3(deptno  number,deptname varchar2(20),mgrno number);   
insert into t_meiyong3 values(1,'�ܹ�˾',null);   
insert into t_meiyong3 values(2,'�㽭�ֹ�˾',1);   
insert into t_meiyong3 values(3,'���ݷֹ�˾',2);   

select * from t_meiyong3 ;

   
select max(substr(sys_connect_by_path(deptname,','),2)) from t_meiyong3 connect by prior deptno =mgrno;   
select max(substr(sys_connect_by_path(column_name,','),2))   
from (select column_name,rownum rn from user_tab_columns where table_name ='t_meiyong3')   
start with rn=1 connect by rn=rownum ;   




-- oracle for in loop ����    http://www.cnblogs.com/wuyisky/archive/2009/11/27/oracle_for_in_loop.html
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

-- �򵥵Ľ�һ�е��ֶ�ͨ���ո��������� http://www.cnblogs.com/wuyisky/archive/2010/02/09/1666338.html
drop table t_meiyong4;
delete from t_meiyong4;
create table t_meiyong4
(
       id int ,
       sname  VARCHAR2(100)
);
insert into t_meiyong4 values(1,'��������');
insert into t_meiyong4 values(1,'����');
insert into t_meiyong4 values(1,'�Զ�');
insert into t_meiyong4 values(1,'����');
insert into t_meiyong4 values(1,'Ԭ����');
insert into t_meiyong4 values(6,'������');
insert into t_meiyong4 values(1,'������');
insert into t_meiyong4 values(8,'��ѫ');
insert into t_meiyong4 values(1,'���');
insert into t_meiyong4 values(6,'������');
insert into t_meiyong4 values(10,'������');
insert into t_meiyong4 values(6,'������');

select * from t_meiyong4;

SELECT t.id id, MAX(substr(sys_connect_by_path(t.sname, ' '), 2)) str
FROM (SELECT id, sname, row_number() over(PARTITION BY id ORDER BY sname) rn FROM t_meiyong4) t
START WITH rn = 1
CONNECT BY rn = PRIOR rn + 1
AND id = PRIOR id
GROUP BY t.id;
--  oracle��concat�������������ַ���ʱ������м�Ӹ��ո� http://zhidao.baidu.com/link?url=cGJKnxOkZRWR2yLJJdbmfnf-B34uope9KNfpA_KQOMtEbxI9Z0c0g1GhaZ_wwZWbV1dJhYrv0OovJhiTSlTCza
select concat(concat(id,' '),sname) from t_meiyong4
-- ����ţƤ��oracle�ķ�������over(Partition by...) ����������    http://www.cnblogs.com/sumsen/archive/2012/05/30/2525800.html
--ͳ�Ƹ���ɼ���һ����ͬѧ��Ϣ
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

--1.�����һ���ɼ���ʱ�򣬲�����row_number()����Ϊ���ͬ�����������е�һ��row_number()ֻ����һ�����         
--2.rank()��dense_rank()�������ǣ�
--rank()����Ծ�����������ڶ���ʱ���������ǵ�����
--dense_rank()l�����������������ڶ���ʱ��Ȼ���ŵ�����


-- ����ͳ�� (����ʾ��Ϣ)
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
-- ��B��λֵ��ͬ�Ķ�Ӧ��C ��λֵ����
select a,b,c, SUM(C) OVER (PARTITION BY B) C_Sum
from t_meiyong5;
--�������Ҫ��ĳ����λ��ֵ�ָ�,�Ǿ�Ҫ�� null     eg: ���ǽ�C����λֵsummary ����ÿ�к���
select a,b,c, SUM(C) OVER (PARTITION BY null) C_Sum
from t_meiyong5;
--  Oracle�ݹ��ѯ http://www.cnblogs.com/wanghonghu/archive/2012/08/31/2665945.html
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
 
 INSERT INTO t_meiyong6(ID,NAME) VALUES(1,'�Ĵ�ʡ');

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(2,1,'������');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(3,1,'������'); 

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(4,2,'������');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(5,2,'ͨ����');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(6,2,'ƽ����');

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(7,3,'ͨ����');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(8,3,'������');

INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(9,8,'������');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(10,8,'������');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(11,8,'������');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(12,8,'�ϰ���');
 
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(13,6,'��կ��');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(14,6,'��̲��');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(15,6,'������');
INSERT INTO t_meiyong6(ID,PARENT_ID,NAME) VALUES(16,6,'������');


-- ��ѯ���������������������֯(���������ǰ�ڵ�):
SELECT *
FROM t_meiyong6
START WITH NAME='������'
CONNECT BY PRIOR ID=PARENT_ID;


-- ��ѯ��̲�����������У�
SELECT ID,   PARENT_ID,      NAME,     
       CONNECT_BY_ROOT(ID)   CITY_ID,
       CONNECT_BY_ROOT(NAME) CITY_NAME
FROM   t_meiyong6
WHERE  NAME='��̲��' 
       START WITH PARENT_ID=1
       CONNECT BY PRIOR ID=PARENT_ID;
       
      
--LEVEL:��ѯ�ڵ��Σ���1��ʼ��
--CONNECT_BY_ISLEAF����ѯ�ڵ��Ƿ���Ҷ�ӽڵ㣬����Ϊ1��������Ϊ0
SELECT   ID,   NAME,   PARENT_ID,   LEVEL,   CONNECT_BY_ISLEAF
FROM     t_meiyong6
         START WITH NAME='������'
         CONNECT BY PRIOR ID=PARENT_ID 
         ORDER BY ID;    
         
-- ��ѯ��������������֯�ݹ�·��
SELECT  ID,     NAME,   PARENT_ID,
        SUBSTR(SYS_CONNECT_BY_PATH(NAME,'->'),3)   NAME_PATH
FROM    t_meiyong6
        START   WITH NAME='������'
        CONNECT BY PRIOR ID=PARENT_ID;          


--  Oracle start with.connect by prior�Ӿ�ʵ�ֵݹ��ѯ http://www.2cto.com/database/201108/101766.html
/*Oracle�е�select��������start with...connect by prior�Ӿ�ʵ�ֵݹ��ѯ��connect by �ǽṹ����ѯ���õ��ģ�������﷨�ǣ�

select ... from <TableName>
where <Conditional-1>
start with <Conditional-2>
connect by <Conditional-3>;

<Conditional-1>���������������ڶԷ��ص����м�¼���й��ˡ�
<Conditional-2>����ѯ�������ʼ�������޶�������
<Conditional-3>����������*/

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
--��ȡ������
select * from t_meiyong2 start with root_id = 0 connect by prior id = root_id; 
 -- ��ȡ�ض�����
 select * from t_meiyong2 start with id = 1 connect by prior id = root_id;
select * from t_meiyong2 start with id = 4 connect by prior id = root_id; 
-- ���connect by prior�е�prior��ʡ�ԣ����ѯ�����������ݹ顣�磺
select * from t_meiyong2 start with root_id = 0 connect by id = root_id;
select * from t_meiyong2 start with id = 1 connect by id = root_id;

-- Oracle��������(Rank)ʵ����� http://blog.csdn.net/cczz_11/article/details/6053539
drop table t_meiyong;
create table t_meiyong
(
  autoid   number  primary key,
  s_id     number(3),
  s_name   char(8) not null,
  sub_name varchar2(20),
  score    number(10,2)
);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (8, 1, '����    ', '����', 80);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (9, 2, '����    ', '��ѧ', 80);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (10, 1, '����    ', '��ѧ', 0);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (11, 2, '����    ', '����', 50);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (12, 3, '������  ', '����', 10);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (13, 3, '������  ', '��ѧ', null);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (14, 3, '������  ', '����', 120);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (15, 4, '���    ', 'java', 90);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (16, 5, 'mike    ', 'c++', 80);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (3, 3, '������  ', 'oracle', 0);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (4, 4, '���    ', 'oracle', 77);
insert into t_meiyong (autoid, s_id, s_name, sub_name, score)values (17, 2, '����    ', 'oracle', 77);

select *from t_meiyong;
-- ��ѯ��ѧ����ĿΪOracle����(������)
select sc.s_id,sc.s_name,sub_name,sc.score, rank() over (order by score desc) ����
from t_meiyong sc
where sub_name='oracle';
-- �Աȣ�rank()��dense_rank()����������������������(���Ǽ�����)
select sc.s_id,sc.s_name,sub_name,sc.score,dense_rank() over (order by score desc) ����
from t_meiyong sc
where sub_name='oracle'
-- ��ѯ��ѧ����������(��������)
select sc.s_id,sc.s_name,sub_name,sc.score,
 rank() over (partition by sub_name order by score desc) ����
from t_meiyong sc;
-- ��ѯ����ǰ2��(��������)���ƣ����ű�,����Ŀ�������ǰ3λ�����š���Ʒ��,���������۶���ǰ10λ����Ʒ��
select * from (
select sc.s_id,sc.s_name,sub_name,sc.score,
dense_rank() over
(partition by sub_name order by score desc) ����
from t_meiyong sc
) x
where x.����<=2;
-- ��ѯ��ͬѧ�ܷ�
select s_id,s_name,sum(score) sum_score from t_meiyong
group by s_id,s_name;
-- �����ֲܷ�ѯ��ͬѧ����
select x.*,
rank() over (order by sum_score desc) ����
from (
select s_id,s_name,sum(score) sum_score from t_meiyong
group by s_id,s_name ) x;

rank() over (order by �����ֶ� ˳��)
rank() over (partition by �����ֶ� order by �����ֶ� ˳��)
 
/*1.˳��asc|desc  ������ҵ����أ�
  ʾ������������ѧԱ���ɼ�������  �ٵ�����������
2.�����ֶΣ�����ʲô�ֶν��з�����
 
���⣺�����������ʲô����?
������ֻ�ǽ�ԭʼ���ݽ�����������(��¼������),
�������Ƕ�ԭʼ���ݽ��оۺ�ͳ��(��¼������,ÿ�鷵��һ��),ע�⣺�ۺϡ�*/




-- round
/*SELECT ROUND( number, [ decimal_places ] ) FROM DUAL
����:
number : ������֮��ֵ
decimal_places : �������� , С��ȡ��λ ( Ԥ��Ϊ 0 )*/
select round(123.456, 0) from dual;          -- 123 
select round(123.456, 1) from dual;          -- 123.5 
select round(123.456, 2) from dual;          -- 123.46 
select round(123.456, 3) from dual;          -- 123.456 
select round(-123.456, 2) from dual;        -- -123.46
--  ��������  http://www.cnblogs.com/sumsen/archive/2012/05/30/2525800.html
-- ����˹���ռ���Ź��ʵİٷֱ�
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

-- ��������ָ���˷����������������ݴ��ڴ�С��������ݴ��ڴ�С���ܻ������еı仯���仯���������£� 

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
-- ��ÿ�����ŵ�ƽ�������Լ�ÿ���������ڲ��ŵĹ��ʲ��
select deptno,ename,sal ,
     round(avg(sal) over(partition by deptno)) as dept_avg_sal, 
     round(sal-avg(sal) over(partition by deptno)) as dept_sal_diff
from scott.emp;

-- ��������(OVER)   http://www.cnblogs.com/wuyisky/archive/2010/02/24/oracle_over.html
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
--group by����ͼ�����ԣ������ݰ�����ID���ͻ����з��飬��ôOver��һ������ʲô���أ���������ֻ��Ҫͳ��ÿ������ÿ���ͻ��Ķ����ܶ��ô����ֻ��Ҫgroup by o.region_id,o.cust_nbr�͹��ˡ������ǻ�����ÿһ����ʾ�ÿͻ���������Ķ����ܶ��һ���ǰ��Ĳ�ͬ����Ҫ��ǰ�����Ļ����ϰ������ۼӡ�����Ȼgroup by��sum���޷�������һ���(��Ϊ�ۼ������ļ���һ����ǰ���Ƕ�һ���ͻ��������Ƕ�һ���ͻ�)��

-- �����over�����������ˣ����������Ǹ���SQL���棺����������ݽ��з�����Ȼ���ۻ�ÿ������ÿ���ͻ��Ķ����ܶ�(sum(sum(o.tot_sales)))��
-- ���������Ѿ�֪��2001���ÿ���ͻ������Ӧ����Ķ����ܶ��ô�������ɸѡ��Щ���˶����ܶ�ռ�����򶩵��ܶ�20%���ϵĴ�ͻ���

-- �����������һ��ȶ����ܶ�ռ���򶩵��ܶ�20%���ϵĿͻ�������������������Ӧ�á�
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

-- ���������Ѿ�֪����Щ��ͻ���˭�ˣ�Ŷ�������⻹���������������Ҫ֪��ÿ����ͻ���ռ�Ķ��������أ����������SQL��䣬ֻ��Ҫһ���򵥵�Round�����͸㶨�ˡ�
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

-- ��Over����ָ������Щ�ֶ��������������ڸ�Partition by��ʾ�����ݽ��з��顣ע��Partition by�����ж���ֶΡ�
-- ��Over�������Ժ������ۼ������������������䣬�𵽲�ͬ�����á����������SUM����������Rank��Dense_rank

--  ltrim http://www.linuxidc.com/Linux/2014-02/96388.htm
select LTRIM( 'Miss Liu', 'Liu') Result  from dual; --  Miss Lius
select ltrim('caolingxiong','cao') from dual;   --  lingxiong
-- ltrim ��ü�����һ�������ĵ�һ���ַ���ڶ���������ÿ���ַ�����ƥ�䣬 ���ƥ��ɹ���ü���������һ���ַ���ƥ�䣬���ƥ�䲻�ɹ����жϲü���
-- replace http://www.cnblogs.com/BetterWF/archive/2011/12/21/2295937.html
select  replace ('111222333444','222','888') from dual;


-- exists ���ж�exits�����sql����Ƿ�Ϊ��,��Ϊ��������sql���ӳ���,����û���κμ�¼��  http://jingyan.baidu.com/article/67508eb4df34e69cca1ce420.html
select 1 from dual where exists (select 1 from dual where 2=1);  -- �϶���û�м�¼
 select 1 from dual where exists (select 1 from dual where 1=1); -- �м�¼���ص�

-- SYS_CONNECT_BY_PATH    http://database.51cto.com/art/201010/231125.htm
drop table t_meiyong;
create table t_meiyong (a varchar2(10),b varchar2(10));  
 
INSERT INTO t_meiyong (A, B) VALUES ('1', '��');  
INSERT INTO t_meiyong (A, B) VALUES ('1', '��');  
INSERT INTO t_meiyong (A, B) VALUES ('1', 'Ҫ');  
INSERT INTO t_meiyong (A, B) VALUES ('2', 'һ');  
INSERT INTO t_meiyong (A, B) VALUES ('2', '��');  
INSERT INTO t_meiyong (A, B) VALUES ('2', '��');  

 
SELECT A, B FROM t_meiyong  ;
/*
                 ������Ҫ�ﵽ���µ�Ч����  
          A          B  
          ---------- ----------  
          1          ��,��,Ҫ  
          2          һ,��,�� 
*/
SELECT A, LTRIM(MAX(SYS_CONNECT_BY_PATH(B, ',')), ',') B  
FROM (SELECT B, A, ROW_NUMBER() OVER(PARTITION BY A ORDER BY B DESC) RN  
          FROM t_meiyong)  
START WITH RN = 1 
CONNECT BY RN - 1 = PRIOR RN  
       AND A = PRIOR A  
GROUP BY A; 
-- ���У�SYS_CONNECT_BY_PATH ������Ҫ�����ǿ��԰�һ�����ڵ��µ������ӽڵ�ͨ��ĳ���ַ��������֣�Ȼ��������һ��������ʾ��row_number ��������;�Ƿǳ��㷺����������Ĺ�����Ϊ��ѯ������ÿһ�м�¼����һ����š�������ŵķ���ͨ��over()�����������������ơ�
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
-- ��ʵSYS_CONNECT_BY_PATH���������oracle9i����������ģ���һ��Ҫ��connect by�Ӿ���ã���һ���������γ�����ʽ���ֶΣ��ڶ��������Ǹ��������Ӽ��ָ���ʾ�õķָ�����START WITH ������Ҫ��ʼ�����ĵĽڵ㣡CONNECT BY PRIOR �Ǳ�ʾ���ӹ�ϵ�Ķ�Ӧ��

--  oracle���Ʊ����ݣ����Ʊ�ṹ  http://www.cnblogs.com/fireman/archive/2013/01/14/2859656.html
select *from t_meiyong4;
drop table t_meiyong5;
drop table t_meiyong6;
-- ��ȫ���Ʊ�(����������͸��Ʊ��еļ�¼)
create table t_meiyong5 as select * from t_meiyong4 ; -- t_meiyong4 �Ǳ����Ʊ�
-- ֻ���Ʊ�ṹ ������һ����Զ�����ܳ���������1=2�����ʱ��ʾ����ֻ���Ʊ�ṹ�����ǲ����Ʊ�����   
create table t_meiyong6 as select * from t_meiyong4 where 1=2;
select *from t_meiyong5;
select *from t_meiyong6;

-- oracle��κܺõıȽ����������ݵĲ���   http://zhidao.baidu.com/link?url=hu_0eqqx68q9XZ7lAAlFi6nqLY7qVQiMozxUpRbX6QQZHYnvc6nYK_5NPpoi21V6oU886D_GpvRwCKBN_g5N-q
drop table t_meiyong1;
drop table t_meiyong2;
create  table t_meiyong1
(
        ID int,
        NAME varchar2(20)
);
drop sequence seq_meiyong1;
Create sequence seq_meiyong1   -- �޸������� alter 
Increment by 1
Start with 1
Maxvalue 999999
Minvalue 1 
Nocycle      --��ѭ��
NOCACHE  -- ���䲢���뵽�ڴ��� һ�㲻���û���

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

insert into t_meiyong1 values(seq_meiyong1.nextval,'����');
insert into t_meiyong1 values(seq_meiyong1.nextval,'����');
insert into t_meiyong1 values(seq_meiyong1.nextval,'����');
insert into t_meiyong1 values(seq_meiyong1.nextval,'����');

insert into t_meiyong2 values(seq_meiyong2.nextval,'����');
insert into t_meiyong2 values(seq_meiyong2.nextval,'����');
insert into t_meiyong2 values(seq_meiyong2.nextval,'���');

select * from t_meiyong1;
select * from t_meiyong2;
--   ����Ҫ�ҳ����ű��в�������ݣ���Ҫ��minus��union�ķ�ʽ���ҳ�����������£�
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
/*SQL����һ��MINUS�ؼ��֣�������������SQL����ϣ������ҳ���һ��SQL����������Ľ����Ȼ����Щ�����û���ڵڶ���SQL���Ľ�� �С�����еĻ�������һ�ʼ�¼�ͱ�ȥ���������������Ľ���г��֡�����ڶ���SQL����������Ľ����û�д����ڵ�һ��SQL����������Ľ���ڣ����� �����Ͼͱ����������﷨���£�
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
-- ���ۣ�Minus���ص�������߱��е����ݣ������ص��ǲ��ע�⣺minus���������� ���ܸ�

-- oracle��ʹ��sys_connect_by_path���б�����ֵ����  http://qingfeng825.iteye.com/blog/935466
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
insert into t_meiyong values(1,'��ҵ����','��ҵ����',0,1,null);
insert into t_meiyong values(2,'��������','��������',0,2,null);
insert into t_meiyong values(3,'������ҵ','������ҵ',1,1,null);
insert into t_meiyong values(4,'��Ȩ��ҵ','��Ȩ��ҵ',1,2,null);
insert into t_meiyong values(5,'cip','cip',3,1,null);
insert into t_meiyong values(140,'��μ������汾��ʽ','��μ������汾��ʽ',5,1,null);
insert into t_meiyong values(141,'3��','3��',140,3,null);
insert into t_meiyong values(142,'1��','��',140,1,null);
insert into t_meiyong values(143,'2��','2��',140,2,null);
insert into t_meiyong values(144,'4��','4��',140,4,null);
insert into t_meiyong values(145,'5��','5��',140,5,null);

insert into t_meiyong values(146,'Ӱӡ��','Ӱӡ��',140,6,null);
insert into t_meiyong values(147,'�޶���','�޶���',140,7,null);
insert into t_meiyong values(148,'������','������',140,8,null);
insert into t_meiyong values(149,'2��(�޶���)','2��(�޶���)',140,9,null);

insert into t_meiyong values(150,'���ø���','���ø���',5,2,null);
insert into t_meiyong values(151,'DVD','DVD',150,1,null);
insert into t_meiyong values(152,'CD','CD',150,2,null);
insert into t_meiyong values(153,'MP3','MP3',150,3,null);
insert into t_meiyong values(154,'�Ŵ�','�Ŵ�',150,4,null);
insert into t_meiyong values(155,'����','����',150,5,null);

select *from t_meiyong;
-- ȡ����parentid���飬���ڲ�����dataid�������к�
select t.parentid,
       t.value,
       t.dataid,
       (row_number() /* ����parentid���飬���ڲ�����dataid�������к�*/
        over(partition by parentid order by dataid)) numid
  from t_meiyong t;
-- ����������кŽ�����ѭ����������ÿ���ַ��������ӡ�
select parentid,
       parentValue,
       ltrim(sys_connect_by_path(value, '*'), '*') valuues
  from (select t.parentid,
               t.value,
               t.dataid,
               parent.VALUE as parentValue,
               (row_number() /* ����parentid���飬���ڲ�����dataid�������к�*/
                over(partition by t.parentid order by t.dataid)) numid
          from t_meiyong t, t_meiyong parent
         where t.PARENTID = parent.DATAID)
 WHERE connect_by_isleaf = 1
 start with numid = 1
connect by numid - 1 = prior numid
       and parentid = prior parentid;
/*�ص㺯����sys_connect_by_path(value, '*')
     value ��ʾҪ���ӵ��ֶΣ���*����ʾ���ӷ���
    ʹ���������֮ǰ������where�����й�����
    where start with ����1  connect by prior ����2
   ����1 ����ʾ��ʼ���������磬��ʼ����Ϊ����������rownumΪ1��
   ����2 ����ʾҪ���ӵ���һ������һ�еĹ�ϵ�����������һ��¼��valuues  ��Ӧ��ֵ�ǣ���������ҵ*��Ȩ��ҵ������ô����Ȩ��ҵ���롰������ҵ��֮��Ĺ�ϵ�ǣ���ͬ��parentId�е�numid+1������������Ϊ��
        start with numid = 1 
       connect by numid - 1 = prior numid    and parentid = prior parentid;
���У�prior.������������һ�е��С�
 
SYS_CONNECT_BY_PATH ��ʵ�ֽ��Ӹ��ڵ㵽��ǰ�������ԡ�path�����߲��Ԫ���б����ʽ��ʾ����
 
CONNECT_BY_ROOT�� ����������֮ǰ���ڷ��ص�ǰ��ĸ��ڵ�
 
connect_by_isleaf�����жϵ�ǰ���ǲ���Ҷ�ӡ��� ����Ҷ�Ӿͻ���α������ʾ��1�����������Ҷ�Ӷ���һ����֧�����統ǰ�����������еĸ��ף�����ʾ��0����*/

--  Oracle�� EXISTS��IN��NOT EXISTS��NOT IN��Ч������   http://blog.chinaunix.net/uid-16844439-id-3330063.html
drop table t_meiyong1;
drop table t_meiyong2;
create table t_meiyong1 (c1 varchar2(20),c2 varchar2(20));
create table t_meiyong2 (c1 varchar2(20),c2 varchar2(20));

insert into t_meiyong1 values ('��','��');
insert into t_meiyong1 values ('��','�؆�');
insert into t_meiyong1 values ('ë','��');
insert into t_meiyong1 values ('��','�؆�');
insert into t_meiyong2 values ('��','��');
insert into t_meiyong2 values ('��','����');
insert into t_meiyong2 values ('��',null);

select * from t_meiyong1;
select * from t_meiyong2;

select * from t_meiyong1 where c2 not in (select c2 from t_meiyong2);
select * from t_meiyong1 where not exists (select 1 from t_meiyong2 where t_meiyong1.c2=t_meiyong2.c2);

--^^
select * from t_meiyong2 where '��'=t_meiyong2.c2;
select * from t_meiyong2 where '�؆�'=t_meiyong2.c2;

--�����������ģ�not in �����˲������Ľ�����������߼����������һ����������select����ִ�мƻ���Ҳ�᲻ͬ������ʹ����hash_aj��
--��ˣ��뾡����Ҫʹ��not in(��������Ӳ�ѯ)��������ʹ��not exists(������ù����Ӳ�ѯ)������Ӳ�ѯ�з��ص�����һ����¼���п�ֵ�����ѯ���������κμ�¼����������������ʾ��
--�����Ӳ�ѯ�ֶ��зǿ����ƣ���ʱ����ʹ��not in ,����Ҳ����ͨ����ʾ����ʹ��hasg_aj��merge_aj����

--   1 �����ϵıȽ�  http://wenku.baidu.com/link?url=vWNvbPvgPQUo-tU6QIffwvwb8KB531mCl4J0sBDPE4NJWPeTZP3QpPaZLjMuEBtNj7R5U3WqRQvBrpkifmf5cliUPzgQTiFwsJdnjZSJvHa
select *from t_meiyong1 where C2 IN(select C2 from t_meiyong2);
-- �൱��
select * from t_meiyong1,(select distinct  C2 from t_meiyong2)t2
where t_meiyong1.C2 =  t2.c2 ;     

-- ��Ե�
select * from t_meiyong1 where exists ( select null from t_meiyong2 where t_meiyong2.c2=t_meiyong1.c2);
-- ִ�й����൱�ڣ�
-- �� t_meiyong1 ?���ɱ����Ҫ����ȫɨ��һ��?   

 
-- Oracle ������(select��start with��connect by��prior)   http://www.cnblogs.com/linjiqin/archive/2013/06/24/3152674.html
drop table t_meiyong;
create table t_meiyong(
id number(10) not null, --����id
 title varchar2(50), --����
parent number(10) --parent id
);

--���˵�
insert into t_meiyong(id, title, parent) values(1, '���˵�1',null);
insert into t_meiyong(id, title, parent) values(2, '���˵�2',null);
insert into t_meiyong(id, title, parent) values(3, '���˵�3',null);
insert into t_meiyong(id, title, parent) values(4, '���˵�4',null);
insert into t_meiyong(id, title, parent) values(5, '���˵�5',null);
--һ���˵�
insert into t_meiyong(id, title, parent) values(6, 'һ���˵�6',1);
insert into t_meiyong(id, title, parent) values(7, 'һ���˵�7',1);
insert into t_meiyong(id, title, parent) values(8, 'һ���˵�8',1);
insert into t_meiyong(id, title, parent) values(9, 'һ���˵�9',2);
insert into t_meiyong(id, title, parent) values(10, 'һ���˵�10',2);
insert into t_meiyong(id, title, parent) values(11, 'һ���˵�11',2);
insert into t_meiyong(id, title, parent) values(12, 'һ���˵�12',3);
insert into t_meiyong(id, title, parent) values(13, 'һ���˵�13',3);
insert into t_meiyong(id, title, parent) values(14, 'һ���˵�14',3);
insert into t_meiyong(id, title, parent) values(15, 'һ���˵�15',4);
insert into t_meiyong(id, title, parent) values(16, 'һ���˵�16',4);
insert into t_meiyong(id, title, parent) values(17, 'һ���˵�17',4);
insert into t_meiyong(id, title, parent) values(18, 'һ���˵�18',5);
insert into t_meiyong(id, title, parent) values(19, 'һ���˵�19',5);
insert into t_meiyong(id, title, parent) values(20, 'һ���˵�20',5);
--�����˵�
insert into t_meiyong(id, title, parent) values(21, '�����˵�21',6);
insert into t_meiyong(id, title, parent) values(22, '�����˵�22',6);
insert into t_meiyong(id, title, parent) values(23, '�����˵�23',7);
insert into t_meiyong(id, title, parent) values(24, '�����˵�24',7);
insert into t_meiyong(id, title, parent) values(25, '�����˵�25',8);
insert into t_meiyong(id, title, parent) values(26, '�����˵�26',9);
insert into t_meiyong(id, title, parent) values(27, '�����˵�27',10);
insert into t_meiyong(id, title, parent) values(28, '�����˵�28',11);
insert into t_meiyong(id, title, parent) values(29, '�����˵�29',12);
insert into t_meiyong(id, title, parent) values(30, '�����˵�30',13);
insert into t_meiyong(id, title, parent) values(31, '�����˵�31',14);
insert into t_meiyong(id, title, parent) values(32, '�����˵�32',15);
insert into t_meiyong(id, title, parent) values(33, '�����˵�33',16);
insert into t_meiyong(id, title, parent) values(34, '�����˵�34',17);
insert into t_meiyong(id, title, parent) values(35, '�����˵�35',18);
insert into t_meiyong(id, title, parent) values(36, '�����˵�36',19);
insert into t_meiyong(id, title, parent) values(37, '�����˵�37',20);
--�����˵�
insert into t_meiyong(id, title, parent) values(38, '�����˵�38',21);
insert into t_meiyong(id, title, parent) values(39, '�����˵�39',22);
insert into t_meiyong(id, title, parent) values(40, '�����˵�40',23);
insert into t_meiyong(id, title, parent) values(41, '�����˵�41',24);
insert into t_meiyong(id, title, parent) values(42, '�����˵�42',25);
insert into t_meiyong(id, title, parent) values(43, '�����˵�43',26);
insert into t_meiyong(id, title, parent) values(44, '�����˵�44',27);
insert into t_meiyong(id, title, parent) values(45, '�����˵�45',28);
insert into t_meiyong(id, title, parent) values(46, '�����˵�46',28);
insert into t_meiyong(id, title, parent) values(47, '�����˵�47',29);
insert into t_meiyong(id, title, parent) values(48, '�����˵�48',30);
insert into t_meiyong(id, title, parent) values(49, '�����˵�49',31);
insert into t_meiyong(id, title, parent) values(50, '�����˵�50',31);

select * from t_meiyong;
-- parent�ֶδ洢�����ϼ�id������Ƕ������ڵ㣬��parentΪnull(�ò���һ�䣬������ȷ��������Ƶģ���������֪����������ñ���null��¼���������ȫ��ɨ�裬����ĳ�0����)��
-- 1)���������е����ж������ڵ㣨��������ˣ��� ����������Ǹ�Ŀ¼�ṹ����ô��һ�����������ҳ����еĶ����ڵ㣬�ٸ��ݸýڵ��ҵ��������ڵ㡣
select * from t_meiyong m where m.parent is null;
-- 2)������һ���ڵ��ֱ���ӽڵ㣨���ж��ӣ��� ������ҵ���ֱ������ڵ㣬Ҳ�ǲ����õ����Ͳ�ѯ�ġ�
select * from t_meiyong m where m.parent=1;
--  3)������һ���ڵ������ֱ���ӽڵ㣨���к������
select * from t_meiyong m start with m.id=1 connect by m.parent=prior m.id; -- ������ҵ���idΪ1�Ľڵ��µ�����ֱ������ڵ㣬�����ӱ��ĺ����ӱ�������ֱ���ڵ㡣
-- 4)������һ���ڵ��ֱ�����ڵ㣨���ף��� ������ҵ��ǽڵ��ֱ�����ڵ㣬Ҳ�ǲ����õ����Ͳ�ѯ�ġ�
select c.id, c.title, p.id parent_id, p.title parent_title
from t_meiyong c, t_meiyong p
where c.parent=p.id and c.id=6;
-- 5)������һ���ڵ������ֱ�����ڵ㣨���ڣ���
select * from t_meiyong m start with m.id=38 connect by prior m.parent=m.id;

--�����г��������Ͳ�ѯ��ʽ����3�����͵�5����䣬���������֮�����������prior�ؼ��ֵ�λ�ò�ͬ�����Ծ����˲�ѯ�ķ�ʽ��ͬ�� ��parent = prior idʱ�����ݿ����ݵ�ǰ��id������parent���id��ͬ�ļ�¼�����Բ�ѯ�Ľ���ǵ����������е������¼����prior parent = idʱ�����ݿ����ݵ�ǰ��parent���������뵱ǰ��parent��ͬ��id�ļ�¼�����Բ�ѯ�����Ľ���������еĸ�������

������һϵ��������ṹ�ĸ����εĲ�ѯ������Ĳ�ѯ��һ�������ŵĲ�ѯ��ʽ������ֻ�����е�һ��ʵ�ֶ��ѡ�

-- 6)����ѯһ���ڵ���ֵܽڵ㣨���ֵܣ���
select * from t_meiyong m
where exists (select * from t_meiyong m2 where m.parent=m2.parent and m2.id=6);


-- 7)����ѯ��һ���ڵ�ͬ���Ľڵ㣨���ֵܣ��� ����ڱ��������˼�����ֶΣ���ô���������ѯʱ������ɣ�ͬһ����ľ������Ǹ��ڵ�ͬ���ģ��������г���ʹ�ø��ֶ�ʱ��ʵ��! ����ʹ���������ɣ�һ����ʹ����level����ʶÿ���ڵ��ڱ��еļ��𣬻��о���ʹ��with�﷨ģ�����һ�Ŵ��м������ʱ��
with tmp as(
      select a.*, level leaf        
      from t_meiyong a                
      start with a.parent is null     
      connect by a.parent = prior a.id)
select *                               
from tmp                             
where leaf = (select leaf from tmp where id = 50);
-- 8)����ѯһ���ڵ�ĸ��ڵ�ĵ��ֵܽڵ㣨�������常����  
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
                from tmp x, --�游
                     tmp y, --����
                     (select *
                      from tmp
                      where id = 21 and lev > 2) z --����
                where y.id = z.parent and x.id = y.parent);
/*�����ѯ�ֳ����¼�����
���ȣ�����7��һ������ȫ��ʹ����ʱ����ϼ���
��Σ����ݼ������ж��м������ͣ��������оٵ�������˵�������������
��1����ǰ�ڵ�Ϊ�����ڵ㣬����ѯ������levֵΪ1����ô��û���ϼ��ڵ㣬���迼�ǡ�
��2����ǰ�ڵ�Ϊ2���ڵ㣬��ѯ������levֵΪ2����ô��ֻҪ��֤lev����Ϊ1�ľ������ϼ��ڵ���ֵܽڵ㡣
��3�������������3�Լ����ϼ�����ô��Ҫѡ��ѯ�������ϼ����ϼ��ڵ㣨�游���������ж��游���¼��ڵ㶼�����ڸýڵ���ϼ��ڵ���ֵܽڵ㡣
��󣬾���ʹ��union����ѯ�����Ľ�����н���������γɽ������
*/                
-- 9)����ѯһ���ڵ�ĸ��ڵ��ͬ���ڵ㣨���壩�������ʵ����7���������ͬ�ġ�
with tmp as(
      select a.*, level leaf        
      from t_meiyong a                
      start with a.parent is null     
      connect by a.parent = prior a.id)
select *                               
from tmp                             
where leaf = (select leaf from tmp where id = 6) - 1;
-- 10)������Ҫ�г�����ȫ��·����
���ﳣ���������������һ���ǴӶ����г���ֱ����ǰ�ڵ�����ƣ������������ԣ���һ���Ǵӵ�ǰ�ڵ��г���ֱ�������ڵ�����ƣ����������ԣ����ٵ�ַΪ�������ڵ�ϰ���Ǵ�ʡ��ʼ�����С����ء�����ί��ģ��������ϰ�������෴����ʦ˵�ģ���û�ӹ�������ʼ���˭�ܼĸ����  ����
�Ӷ�����ʼ��

select sys_connect_by_path (title, '/')
from t_meiyong
where id = 50
start with parent is null
connect by parent = prior id;

-- �ӵ�ǰ�ڵ㿪ʼ:
select sys_connect_by_path (title, '/')
from t_meiyong
start with id = 50
connect by prior parent = id;


/*���������ֲ��ò��Ÿ���ɧ�ˡ�oracleֻ�ṩ��һ��sys_connect_by_path������ȴ�����ַ��������ӵ�˳��������������У���һ��sql�ǴӸ��ڵ㿪ʼ���������ڶ���sql��ֱ���ҵ���ǰ�ڵ㣬��Ч������˵�Ѿ���ǧ����𣬸��ؼ����ǵ�һ��sqlֻ��ѡ��һ���ڵ㣬���ڶ���sqlȴ�Ǳ�������һ���������ٴ�psһ�¡�

sys_connect_by_path�������Ǵ�start with��ʼ�ĵط���ʼ��������������������Ľڵ㣬start with��ʼ�ĵط�����Ϊ���ڵ㣬����������·�����ݺ����еķָ��������һ���µ��ַ�����������ܻ��Ǻ�ǿ��ġ�*/

-- 11)���г���ǰ�ڵ�ĸ��ڵ㡣��ǰ��˵�������ڵ����start with��ʼ�ĵط��� connect_by_root���������е�ǰ�棬��¼���ǵ�ǰ�ڵ�ĸ��ڵ�����ݡ�
select connect_by_root title, t_meiyong.*
from t_meiyong
start with id = 50
connect by prior parent = id;

-- 12)���г���ǰ�ڵ��Ƿ�ΪҶ�ӡ�����Ƚϳ����������ڶ�̬Ŀ¼�У��ڲ���������Ƿ����¼��ڵ�ʱ����������Ǻ����õġ�
select connect_by_isleaf, t_meiyong.*
from t_meiyong
start with parent is null
connect by parent = prior id;
-- connect_by_isleaf���������жϵ�ǰ�ڵ��Ƿ�����¼��ڵ㣬��������Ļ���˵������Ҷ�ӽڵ㣬���ﷵ��0����֮������������¼��ڵ㣬���ﷵ��1��


























































