-- Oracle��ѯ�����������     http://www.2cto.com/database/201305/214971.html                �ı����ݱȽ� Notepad++   :   http://jingyan.baidu.com/article/c45ad29cd8634b051753e290.html
-- ���ұ���������������ƣ������У�
select cu.* from user_cons_columns cu, user_constraints au where cu.constraint_name = au.constraint_name and au.constraint_type = 'P' and au.table_name = 'LC_BASE_STORE_PRODUCT';
--  ���ұ��������������ƣ����ñ�ı����Ͷ�Ӧ�ļ����������Ƿֳɶಽ��ѯ��
select * from user_constraints c where c.constraint_type = 'R' and c.table_name = 'LC_BASE_STORE_PRODUCT';
--  ���ұ���������������������������ͣ������У�
select t.*,i.index_type from user_ind_columns t,user_indexes i where t.index_name = i.index_name and t.table_name = i.table_name and t.table_name =  'LC_BASE_STORE_PRODUCT';
-- oracle MINUS��NOT EXISTS��EXISTS��INTERSECT    http://blog.163.com/weiwohappy@126/blog/static/732633302013430104234124/
drop table t_meiyong1;
drop table t_meiyong2;

create table t_meiyong1
(
       ID int ,
       NAME varchar2(20),
       AGE int 
);
create table t_meiyong2
(
       ID int ,
       NAME varchar2(20),
       AGE int 
);

insert into t_meiyong1 values( 1            ,                        'A'          ,                                                22);
insert into t_meiyong1 values( 2             ,                       'B'            ,                                              23);
insert into t_meiyong1 values(3            ,                        'C'             ,                                            null );
insert into t_meiyong1 values( 4           ,                         'D'             ,                                             null );
insert into t_meiyong1 values( 5            ,                        'E'             ,                                             24);
insert into t_meiyong1 values( 6            ,                        'F'             ,                                             25);
insert into t_meiyong1 values( 7            ,                        'G'            ,                                              26);
insert into t_meiyong1 values( 8            ,                        'H'             ,                                             22);

insert into t_meiyong2 values(1               ,                     'A'                  ,                                        22);
insert into t_meiyong2 values(2                ,                    'B'                   ,                                       23);
insert into t_meiyong2 values(3                 ,                   'C'                    ,                                       null);
insert into t_meiyong2 values(4                  ,                  'D'                     ,                                      null  );
insert into t_meiyong2 values(5                   ,                 'E'                      ,                                      24 );
insert into t_meiyong2 values(6                    ,                'F'                       ,                                   25);

select * from t_meiyong1;
select * from t_meiyong2;
-- ��NOT EXISTS�Ĳ�ѯ�����
SELECT * FROM t_meiyong1 t WHERE NOT EXISTS (SELECT * FROM t_meiyong2 t2 WHERE t2.id=t.id);
-- ʹ��MINUS�Ĳ�ѯ�����
SELECT * FROM t_meiyong1 MINUS SELECT * FROM t_meiyong2;
-- ���Կ���ʹ��MINUS��NOT EXISTS�Ľ����һ���ġ�MINUS����˼��ʹ�õ�һ����ѯ�Ľ����Ϊ�������ݼ�ȥ��һ����ѯ�����Ϊ���ս���������Խ���������ǡ�����Ҫ����������ԴA�д��ڣ�������B�в����ڵ����ݼ�����

-- 2���Ƚ�EXISTS��INTERSECTʹ��EXISTS�Ĳ�ѯ�����
SELECT * FROM t_meiyong1 t WHERE EXISTS (SELECT * FROM t_meiyong2 t2 WHERE t2.id=t.id);

-- ʹ��INTERSECT�Ĳ�ѯ�����
SELECT * FROM t_meiyong1 t INTERSECT (SELECT * FROM t_meiyong2 t2);
-- ���Կ���ʹ��EXISTS��INTERSECT�Ĳ�ѯ�����ͬ�� INTERSECT�Ƿ��ز�ѯ�ж����ڵ��У����Խ��������Ϊ������Ҫ����ԴA��B�ж����ڵ����ݡ���
 
--  sql�����ôָ������ֶε�λ�ã���  http://zhidao.baidu.com/link?url=Pe6EnA4Oc9zu-w-yPd-iwS8dhIhxWO-5S_u1Gm6638crc8b8Gxef8-uPpy6kpfluqfL670evB24b0ne7tYdHVq
alter table t_meiyong
add (BARCODE varchar2(30)   null) after xx;

--   ORACLE WITH AS �÷�        http://blog.csdn.net/a9529lty/article/details/4923957/
drop table t_meiyong2;
drop table t_meiyong3;

 create table t_meiyong2(id int);
 create table t_meiyong3(id int); 
 insert into t_meiyong2 values(1);  
 insert into t_meiyong2 values(2);  
  insert into t_meiyong3 values(3);  
  select * from t_meiyong2;  
  select * from t_meiyong3;  
  
   with  
 sql1 as (select * from t_meiyong2),  
 sql2 as (select * from t_meiyong3)  
 select * from t_meiyong2  
 union  
 select * from t_meiyong3;  
sql2 as (select * from t_meiyong3)   -- ��������Կ������㶨����sql1��sql2���͵�������Ŷ����Ȼ�ᱨ��ġ�



 with  
 sql1 as (select * from t_meiyong2),  
 sql2 as (select * from t_meiyong3)  
 select * from sql1  
 union  
 select * from sql2;  
 
 
 with  
  sql1 as (select * from t_meiyong2),  
  sql2 as (select * from t_meiyong3)  
  select * from sql1  
  union  
  select * from sql2  
  where id in(2,3);  
  
  
   with  
  sql1 as (select * from t_meiyong2),  
  sql2 as (select * from t_meiyong3)  
  select * from sql1  
  where id=3  
  union  
  select * from sql2  
  where id=3; 
  
 --  ORACLE: ��һ��sequence�������ˣ���ô��    http://blog.chinaunix.net/uid-20372841-id-1695181.html
 select HC_BASE_ID.currval from dual;
  
 -- Oracle Exists �÷�     http://zlk.iteye.com/blog/903322
 drop table t_meiyong;
drop table t_meiyong1;

create table t_meiyong
(
       ID    int,
       NAME  varchar2(20)
);
insert into t_meiyong values(1,'A1');
insert into t_meiyong values(2,'A2');
insert into t_meiyong values(3,'A3');

create table t_meiyong1
(
       ID    int,
       AID   int,
       NAME  varchar2(20)
);
insert into t_meiyong1 values(1,1,'B1');
insert into t_meiyong1 values(2,2,'B2');
insert into t_meiyong1 values(3,2,'B3');

select * from t_meiyong;
select * from t_meiyong1;
-- ��t_meiyong �ͱ� t_meiyong1 �ǣ��Զ�Ĺ�ϵ   t_meiyong.ID   =>   t_meiyong1.AID 

SELECT   ID,NAME  FROM   t_meiyong  WHERE  EXIST (SELECT * FROM  t_meiyong1  WHERE  t_meiyong.ID=t_meiyong1.AID);
 
--  oracle �����ŷָ�������������  http://zhidao.baidu.com/link?url=b_Ks2Bg_htleUa10CZuo-PNN92zyJJ93cG3zxC647oEk6Y5DV-IzML1PV-C50_rs5lJ_4NGkpp5iHCibZmL8z1AeMGbwS1-9Q7RW7XyPUOW
select ''''||replace('123,456,789',',',''',''')||'''' from dual;

    select  '''' || decode(ASSETS_CLASS_Z,'1',0,'') || '''' ||   '''' ||  decode(ASSETS_CLASS_O,'1','1','')  ||'''' ||  '''' || decode(ASSETS_CLASS_T,'1','2','' ) ||  ''''  from  SYS_USER where id='SYSTEM000001000000393196'

drop table t_meiyong;
create table t_meiyong
(
    NAME varchar2(1000)
);
insert into t_meiyong values('LCJOBS000000000004079684,LCJOBS000000000003519020,LCJOBS000000000003658525,LCJOBS000000000004076793');


select * from t_meiyong;

select ''''||replace(NAME,',',''',''')||'''' from t_meiyong;

 
 
 --  Oracle��distinct���÷�ʵ���Լ�Oracle distince �÷���ɾ���ظ�����  http://blog.csdn.net/haiross/article/details/17138559
 
drop table t_meiyong;
create table t_meiyong
(
       id        int,
       name varchar2(20)
);
insert into t_meiyong values(1,'a');
insert into t_meiyong values(2,'b');
insert into t_meiyong values(3,'c');
insert into t_meiyong values(4,'c');
insert into t_meiyong values(5,'b');

select *  from t_meiyong;
select distinct name from t_meiyong;
select distinct name, id from t_meiyong; -- distinct��ôû�����ã����������˵ģ�������ͬʱ�����������ֶΣ�Ҳ���Ǳ����id��name����ͬ�ĲŻᱻ�ų���������������
--���淽������:
select  *,  count(distinct name) from t_meiyong group by name; 
 
 
-- Oracle��ĳ���ֶ���Ķ��ֵȥƥ������һ�ű�Ķ��ֵ  http://blog.sina.com.cn/s/blog_9f4fd52d0102xal3.html
drop table t_meiyong;
drop table t_meiyong1;
create table t_meiyong
(
   a_urs_id nvarchar2(20) ,
   a int
)
create table t_meiyong1
(
   urs_id int ,
   urs_name?  nvarchar2(20)
)


insert into t_meiyong values('1,2',110); 
insert into t_meiyong values('2,3',120); 

insert into t_meiyong1 values(1,'���');
insert into t_meiyong1 values(2,'�׷�');
insert into t_meiyong1 values(3,'����');

select * from t_meiyong;
select * from t_meiyong1;


-- Oracleʱ��ת�����ַ���  http://blog.csdn.net/shipeng22022/article/details/24640109
  select to_char(sysdate,'yyyy-MM-dd') from dual;
 
 -- oracle��ѯĳ����¼�ڵڼ��� http://blog.sina.com.cn/s/blog_4a94a0db01014vbk.html
 select tt.rowno
  from (select t.*, row_number() over(order by 1) rowno from TableName t) tt
 where tt.orderno = 'S52117032124';
 
 -- ��β������û�е�����
  -- ��ͨ��������-����û�����  --  select * from  HC_BASE_AUDIT_USER    
insert into HC_BASE_AUDIT_USER
(AUDIT_USER_ID,
 CONFIG_ID,
 CREATE_USER_ID,
 CREATE_USER,
 CREATE_DATE
)
select
'SYSTEM000001000000393196',
'HCBASE000000000903278780',
'SYSTEM000001000000393196',
'����ͤ',
sysdate 
from dual
where not exists
(select 1 from HC_BASE_AUDIT_USER 
where AUDIT_USER_ID = 'SYSTEM000001000000393196' 
  and CONFIG_ID= 'HCBASE000000000903278780'
) 
--^^
select * from HC_BASE_AUDIT_USER  -- ��ֵ��ͨ�����������Ա��
where AUDIT_USER_ID = 'SYSTEM000001000000393196' 
  and CONFIG_ID= 'HCBASE000000000903278780'
 
 
 --  oracle��θ�һ�е����ݶ���һ���ַ� https://zhidao.baidu.com/question/1766873732980890100.html
select * from t_meiyong;
update t_meiyong set name=('meiyong'||name) where name like '%��%';
 
 
 --  ����ROWIDȥ���ظ���   ����ǰ2�� ������������ж���һ���ģ������ն˻����ж�����������ɾ��ǰ2�У�ֻ�������һ�У�ǰ2�����û���ǰ���ù��Ļ��ͣ������ļ�¼���û�Ŀǰʹ�õĻ��ͣ�������Ҫ�������ļ�¼���������뻹�ܶ�������������ֶ�һ����ɾ�����ġ��� http://blog.itpub.net/22918188/viewspace-1029033/
 
 drop table t_meiyong7;
 create table t_meiyong7 (phone number,dishi varchar(10),jixing varchar(20));
insert into t_meiyong7 
select 13333334444,'����','HS-D90' from dual
union
select 13333334444,'����','HS-D907' from dual
union
select 13333334455,'����','HS-D908' from dual
union
select 13333334455,'����','HS-D909' from dual
union
select 13333334455,'����','LG-KV755' from dual;

select * from t_meiyong7;

select * from t_meiyong7 where rowid not in  -- delete 
(select max(rowid) from t_meiyong7 group by phone,dishi);
 
 --   Oracle��ͳ�Ʊ���ÿ���ֶη�������������   http://blog.itpub.net/22918188/viewspace-1054000/
 CREATE TABLE t_meiyong8(a VARCHAR2(8),b NUMBER);
INSERT INTO t_meiyong8
SELECT 'name1',1 FROM dual
UNION
SELECT 'name1',0 FROM dual
UNION
SELECT 'name2',1 FROM dual
UNION
SELECT 'name3',1 FROM dual
UNION
SELECT 'name4',0 FROM dual
UNION
SELECT 'name4',1 FROM dual;

select * from t_meiyong8;
SELECT a,count(*) as ������,
sum(case when b=1 then 1 else 0 end) as ����Ϊ1������,
sum(case when b=0 then 1 else 0 end) as ����Ϊ0������ 
from t_meiyong8
GROUP by a ORDER BY a;
 
 
--   wm_concat��������            http://blog.163.com/shuzhen_an/blog/static/11939930420131019103351170/ 
-- wm_concat����ת�е�ʱ��ǳ����ã�������ת�еĹ����е��������ⳣ�����Կ��ơ� �ɼ��������ӣ�
drop table t_meiyong;
create table t_meiyong(SIGN varchar2(20) ,CODE  varchar2(20) );

insert into t_meiyong values('0001','01');
insert into t_meiyong values('0001','02');
insert into t_meiyong values('0001','03');
insert into t_meiyong values('0001','04');
insert into t_meiyong values('0002','05');
insert into t_meiyong values('0002','06');
insert into t_meiyong values('0001','07');
insert into t_meiyong values('0001','08');
insert into t_meiyong values('0002','09');

insert into t_meiyong values('0002','10');
insert into t_meiyong values('0001','11');
insert into t_meiyong values('0001','12');
insert into t_meiyong values('0002','13');
insert into t_meiyong values('0002','14');
insert into t_meiyong values('0001','15');
insert into t_meiyong values('0001','16');
insert into t_meiyong values('0002','17');
insert into t_meiyong values('0001','18');
insert into t_meiyong values('0001','19');
insert into t_meiyong values('0001','20');

select * from t_meiyong;
select a.sign,wm_concat(a.code) from t_meiyong a group by a.sign;
-- �ɼ�wm_concat���˳��û�а���->С����С->���˳�� ���ս��˼·��
select b.sign, max(b.r)  code
        from
        (select
            a.sign,
            wm_concat(a.code) over (partition by a.sign  order by a.code) r 
        from t_meiyong a 
        ) b 
    group by b.sign

-- Oracle����֮GREATEST�������ʵ��        http://www.linuxidc.com/Linux/2014-07/103980.htm
-- GREATEST(expr_1, expr_2, ...expr_n)�����ӱ��ʽ���С�����������ֵ��expr_1, expr_2, ... expr_n�����ҳ����������ء��ڱȽ�ʱ��OracIe���Զ������ʽ���������ͽ��бȽϣ���expr_1����������Ϊ׼��
SELECT GREATEST(2, 5, 12, 3, 16, 8, 9) A FROM DUAL;	    -- expr_1Ϊ��ֵ�͡�����С���бȽϡ� ȫ��Ϊ��ֵ�ͣ�ȡ�����ֵΪ16��
SELECT GREATEST(sysdate,TO_DATE('2014-08-01','YYYY-MM-DD')) A FROM DUAL; -- expr_1Ϊʱ�����͡� ȫ��Ϊʱ�����ͣ�


--  Oracle�������SQL��������ж��ٸ��ֶΣ��У� https://zhidao.baidu.com/question/1540677497330229027.html
select max(column_id) from user_tab_columns where table_name=upper('HC_JOBS_PREPARE_DETAIL')














 
 
 
 
 
 
 
 
-- 
CREATE OR REPLACE FUNCTION GET_ME_ORDER_PRODUCT_NAMES(TMP_ID VARCHAR2) return VARCHAR2 IS
  NAMES VARCHAR2(4000);
begin
  NAMES := '';

  FOR CUR IN (SELECT bp.PRODUCT_NAME
                FROM ME_JOBS_ORDER_DETAIL jod, ME_BASE_PRODUCT bp
               WHERE jod.PRODUCT_ID = bp.ID
                 AND jod.ORDER_ID = TMP_ID
               GROUP BY bp.PRODUCT_NAME) LOOP
    NAMES := NAMES || '��' || CUR.PRODUCT_NAME;
  END LOOP;

  NAMES := LTRIM(NAMES, '��');

  IF NAMES IS NULL THEN
    NAMES := '-';
  END IF;

  return NAMES;

EXCEPTION
  --WHEN NO_DATA_FOUND THEN RETURN '-';
  WHEN OTHERS THEN
    RETURN '-';
END;

--^^
 select GET_ME_ORDER_PRODUCT_NAMES('MEJOBS000000000000600392') from  dual 
  
  
  
  
  
  
  
  
  
   
  --  
 CREATE OR REPLACE FUNCTION GET_LC_RK_RECEIVE_CODE_NEW(v_store_id varchar2,
                                                      v_rkd_type number)
  return VARCHAR2 IS
  v_CODE       VARCHAR2(100);
  v_store_code VARCHAR2(100);
begin
  v_CODE       := '';
  v_store_code := '';

  select b.code
    into v_store_code
    from lc_base_store b
   where b.id = v_store_id;
  if v_store_code = '' then
    return '';
  end if;

  select 'RKD' || v_store_code || to_char(sysdate, 'YY') ||
         LPAD((nvl(MAX(SUBSTR(a.receive_code, -7)), '0') + 1), 7, '0') as CODE
    into v_CODE
    from LC_JOBS_RECEIVE a
   where a.store_id = v_store_id
        --����ҽԺ��������������֣�������ⵥ��ˮ������
        --and a.type = v_rkd_type
     and a.create_date between trunc(sysdate, 'yyyy') and
         add_months(trunc(sysdate, 'YYYY'), 12) ;

   return v_CODE;

EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;

--^^
select   GET_LC_RK_RECEIVE_CODE_NEW('LCBASE000000000005369866',10) from dual ;    --  select   * from lc_base_store where id='LCBASE000000000005369866'; -->  meiyong_�ⷿ
  
  
  
  --
  
  CREATE OR REPLACE FUNCTION GET_HC_BARCODE_NEW return VARCHAR2 IS
  v_BARCODE VARCHAR2(100);
BEGIN
  v_BARCODE := '';
  --��ֵ�Ĳ�����
   SELECT '1'||LPAD(NVL(MAX(BARCODE), '0') + 1, 12, '0') AS BARCODE
    INTO v_BARCODE
    FROM
    (
      SELECT SUBSTR(MAX(BARCODE),2) AS BARCODE
        FROM HC_JOBS_PREPARE_BARCODE
       WHERE BARCODE LIKE '1%'
      UNION ALL
      SELECT SUBSTR(MAX(BARCODE),2) AS BARCODE
        FROM HC_JOBS_BARCODE
       WHERE BARCODE LIKE '1%'
    );

   return v_BARCODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;
--^^ 
  SELECT GET_HC_BARCODE_NEW() AS BARCODE FROM dual
  
  
  
CREATE OR REPLACE FUNCTION GET_LC_REQUEST_CODE(v_store_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_COD := '';

  select 'QLD' || to_char(sysdate, 'YYYY')  ||
         LPAD((nvl(MAX(SUBSTR(a.REQUEST_CODE, -5)), '0') + 1), 5, '0') as CODE
    into v_CODE
    from LC_JOBS_REQUEST a
   where a.REQUEST_CODE like 'QLD' || to_char(sysdate, 'YYYY') || '_____';

   return v_CODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;

--^^
select GET_LC_REQUEST_CODE('LCBASE000000000005369866') as CODE from dual   ;
select 'QLD' || to_char(sysdate, 'YYYY')  || LPAD((nvl(MAX(SUBSTR(a.REQUEST_CODE, -5)), '0') + 1), 5, '0') as CODE from  LC_JOBS_REQUEST a  where a.REQUEST_CODE like 'QLD' || to_char(sysdate, 'YYYY') || '_____';
  
  
  

  
  --  ��ɰ�
  CREATE OR REPLACE FUNCTION GET_LC_TB_CODE(v_store_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_CODE := '';

  select  substr(to_char(sysdate,'YYYYMM') ,-4)   ||
         LPAD((nvl(MAX(SUBSTR(a.CODE, -3)), '0') + 1), 3, '0') as CODE
    into v_CODE
    from LC_BASE_DEPT_PROD_PACKAGE a
   where a.CODE like   substr(to_char(sysdate, 'YYYYMM'),-4)  || '___' ;

   return v_CODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;
--^^
  select GET_LC_TB_CODE('LCBASE000000000005369866') as CODE from dual   ;
  
  -- woqiao 
  CREATE OR REPLACE FUNCTION GET_LC_TB_CODE(v_store_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_CODE := '';

  select 'TB' || to_char(sysdate, 'YYYY')  ||
         LPAD((nvl(MAX(SUBSTR(a.CODE, -5)), '0') + 1), 5, '0') as CODE
    into v_CODE
    from LC_BASE_DEPT_PROD_PACKAGE a
   where a.CODE like 'TB' || to_char(sysdate, 'YYYY') || '_____';

   return v_CODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;

  
  
--^^
CREATE OR REPLACE FUNCTION GET_LC_TB_CODE(v_store_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_CODE := '';

  select to_char(sysdate, 'YYYY')  ||
         LPAD((nvl(MAX(SUBSTR(a.CODE, -3)), '0') + 1), 3, '0') as CODE
    into v_CODE
    from LC_BASE_DEPT_PROD_PACKAGE a
   where a.CODE like   to_char(sysdate, 'YYYY') || '___';

   return v_CODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;



-- ��ɰ�  �������� select ֮��Ӷ��� 
CREATE OR REPLACE FUNCTION Get_LC_DeptReject_CODE(v_store_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_CODE := '';
      select 'KST' || to_char(sysdate, 'YYMMDD')|| lpad(nvl(max(substr(a.REJECT_CODE,-3)),'0') + 1, 3, '0') as CODE
    into v_CODE
  from LC_JOBS_REJECT_DEPT a

 where a.REJECT_CODE like 'KST' || to_char(sysdate, 'YYMMDD')  || '___';


   return v_CODE;

EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;

--^^
select Get_LC_DeptReject_CODE('0593') as CODE from dual;



  
  -- woqiao   ԭʼ 
  CREATE OR REPLACE FUNCTION Get_LC_DeptReject_CODE(v_store_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_CODE := '';
      select 'KST' || to_char(sysdate, 'YYYYMMDD') || '0593' || lpad(nvl(max(substr(REJECT_CODE,-3)),'0') + 1, 3, '0') as CODE 
	  into v_CODE
  from LC_JOBS_REJECT_DEPT a
 where a.REJECT_CODE like 'KST' || to_char(sysdate, 'YYYYMMDD') || '0593' || '___';
      
   return v_CODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;









  
  CREATE OR REPLACE FUNCTION GET_LC_REQUEST_CODE_CF(v_request_id varchar2) return VARCHAR2 IS
  v_CODE VARCHAR2(100);
begin
  v_CODE := '';

  select 'QLD' || to_char(sysdate, 'YYYY')  ||
         LPAD((nvl(MAX(SUBSTR(a.REQUEST_CODE, -5)), '0') + 1), 5, '0') as CODE
    into v_CODE
    from LC_JOBS_REQUEST a
   where a.REQUEST_CODE like 'QLD' || to_char(sysdate, 'YYYY') || '_____';

   return v_CODE;
EXCEPTION
  WHEN OTHERS THEN
    RETURN '';
END;

 --^^
select GET_LC_REQUEST_CODE_CF('LCBASE000000000000043662') as CODE
from dual 
  
  
   -- GET_SYS_USER_DEPTNAMES
   CREATE OR REPLACE FUNCTION GET_SYS_USER_DEPTNAMES(TMP_ID VARCHAR2) return VARCHAR2 IS
  NAMES VARCHAR2(4000);
begin
  NAMES := '';

  FOR CUR IN (SELECT NVL(sd.NAME, '-') DEPT_NAME
                FROM SYS_DEPT_USER sdu, SYS_DEPT sd
               WHERE sdu.dept_id = sd.id
                 AND sdu.user_id = TMP_ID
               ORDER BY sd.CODE) LOOP
    NAMES := NAMES || '��' || CUR.DEPT_NAME;
  END LOOP;

  NAMES := LTRIM(NAMES, '��');

  IF NAMES IS NULL THEN
    NAMES := '-';
  END IF;

  return NAMES;

EXCEPTION
  --WHEN NO_DATA_FOUND THEN RETURN '-';
  WHEN OTHERS THEN
    RETURN '-';
END;

--^^
select    GET_SYS_USER_DEPTNAMES('SYSTEM000000000004055442')  from dual
  
  
  
  
  
  
  
  
  
  
  
-- P_SYS_MESSAGE_PUSH
  
  CREATE OR REPLACE PROCEDURE P_SYS_MESSAGE_PUSH(v_ACTION in VARCHAR2, v_ORDER_ID in VARCHAR2, v_ATTACH_PARAM in VARCHAR2, v_UserID in VARCHAR2, v_UserName in VARCHAR2, v_ErrMsg OUT VARCHAR2)
as
  -- Hospital��***������Ϣ����***
  -- Author  : ������
  -- Created : 2016-08-12 09:00:00
  -- Purpose : ��������ƽ̨������Ϣ
  -- Parameter : action������ID�����Ӳ�����������ID�����������ơ�������롢������Ϣ
  v_EXEC_TAG VARCHAR2(100);--ִ�в���˵��
  v_CUSTOM_RESULT VARCHAR2(8);--�Զ���������Ϣִ�н��
  SYS_SYSTEM_ID CHAR(24 BYTE);--�û�ϵͳ
  LC_SYSTEM_ID CHAR(24 BYTE);--��ֵ
  HC_SYSTEM_ID CHAR(24 BYTE);--��ֵ
  NC_SYSTEM_ID CHAR(24 BYTE);--����
  ME_SYSTEM_ID CHAR(24 BYTE);--�豸
  RG_SYSTEM_ID CHAR(24 BYTE);--�Լ�
begin
  SYS_SYSTEM_ID := '000000000000000000000001';
  LC_SYSTEM_ID := '000000000000000000000002';
  HC_SYSTEM_ID := '000000000000000000000003';
  NC_SYSTEM_ID := '000000000000000000000004';
  RG_SYSTEM_ID := '000000000000000000000005';
  ME_SYSTEM_ID := '000000000000000000000009';
  v_ErrMsg:= '';
  v_EXEC_TAG:= 'F_SYS_MESSAGE_PUSH_CUSTOM��'||v_ORDER_ID;
  --ִ���Զ���������Ϣ
  SELECT F_SYS_MESSAGE_PUSH_CUSTOM(v_ACTION, v_ORDER_ID, v_ATTACH_PARAM, v_UserID, v_UserName) INTO v_CUSTOM_RESULT FROM DUAL;
  if v_CUSTOM_RESULT = '1' then
    goto FINISH_COMMIT;
  end if;

  v_EXEC_TAG:= 'P_SYS_MESSAGE_PUSH��'||v_ACTION||v_ORDER_ID;
--�û�ϵͳ$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
--��ֵϵͳ$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  if v_ACTION = '��ֵ-���쵥���-�����' then
    DECLARE
      v_RECEIVE_ID CHAR(24);--��ⵥID
      v_RECEIVE_CODE VARCHAR2(100);--��ⵥ��
    BEGIN
      FOR v_row_S_VIEW IN (
          SELECT DISTINCT bpau.AUDIT_USER_ID as USER_ID
             FROM LC_BASE_AUDIT_CONFIG bac, LC_BASE_AUDIT_USER bpau, LC_JOBS_AUDIT jpa,
               (SELECT jr.AUDIT_NO + 1 as AUDIT_NO --��˼���
                  FROM LC_JOBS_REQUEST jr
                 WHERE jr.ID = v_ORDER_ID --����ID
                   AND jr.STATE = 20) ywdj
            WHERE bpau.CONFIG_ID = jpa.CONFIG_ID
              AND bac.AUDIT_RANGE IN ('0','3') --��˷�Χ��0ȫԺ��3���ֿ���
              AND bac.ID = jpa.CONFIG_ID
              AND jpa.OPERATE_TYPE = '0' --δ���
              AND jpa.SOURCE_ID = v_ORDER_ID --����ID
              AND jpa.AUDIT_NO = ywdj.AUDIT_NO --��˼���
          UNION
          SELECT DISTINCT sduSH.USER_ID
          FROM SYS_USER_ROLE sur, SYS_ROLE_MODULE srm, LC_BASE_AUDIT_CONFIG bac, LC_JOBS_AUDIT jpa, SYS_DEPT_USER sduSH,
               (SELECT jr.DEPT_ID,
                       jr.AUDIT_NO + 1 as AUDIT_NO --��˼���
                  FROM LC_JOBS_REQUEST jr
                 WHERE jr.ID = v_ORDER_ID --����ID
                   AND jr.STATE = 20) ywdj
          WHERE srm.MODULE_ID in ('000000000000000000020211','000000000000000000020307') --�������쵥���
            AND srm.ROLE_ID = sur.ROLE_ID
            AND sur.USER_ID = sduSH.USER_ID
            AND ywdj.DEPT_ID = sduSH.DEPT_ID
            AND bac.AUDIT_RANGE IN ('1','2') --��˷�Χ��1�����ң�2����(�Է�)����
            AND bac.ID = jpa.CONFIG_ID
            AND jpa.OPERATE_TYPE = '0' --δ���
            AND jpa.SOURCE_ID = v_ORDER_ID --����ID
            AND jpa.AUDIT_NO = ywdj.AUDIT_NO --��˼���
       )
      LOOP
        INSERT INTO SYS_REMIND_PLATFORM
          (ID,
           SYSTEM_ID,
           TO_USER_ID,
           NAVIGATE_ACTION,
           NAVIGATE_PARAMETERS,
           TITLE,
           CONTENT,
           CREATE_USER_ID,
           CREATE_USER,
           CREATE_DATE)
        SELECT
           SYS_REMIND.Nextval, --ID
           LC_SYSTEM_ID, --SYSTEM_ID
           v_row_S_VIEW.USER_ID, --TO_USER_ID
           v_ACTION,--NAVIGATE_ACTION
           v_ORDER_ID,--NAVIGATE_PARAMETERS

           (SELECT nvl(MAX(ABBR),'��Ϣ��ʾ') FROM SYS_SYSTEM WHERE ID = LC_SYSTEM_ID),--TITLE
           '<Section xml:space="preserve" HasTrailingParagraphBreakOnPaste="False" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation">'
           ||'<Paragraph>'
           ||'<Run FontSize="13.3">��1�����쵥����</Run>'
           ||'<LineBreak/><LineBreak/>'
           ||'<Run FontSize="13.3">������ң�'||jr.DEPT_NAME||'</Run>'
           ||'<LineBreak/><LineBreak/>'
           ||'<Hyperlink FontSize="13.3" Foreground="#FF337BFE" FontStyle="Italic">'
           ||'����������쵥�š�'||jr.REQUEST_CODE||'��'
           ||'</Hyperlink>'
           ||'</Paragraph>'
           ||'</Section>',--CONTENT
           v_UserID, --CREATE_USER_ID
           v_UserName, --CREATE_USER
           sysdate --CREATE_DATE
         FROM LC_JOBS_REQUEST jr
        WHERE jr.ID = v_ORDER_ID --����ID
        ;
      END LOOP;
    END;
    goto FINISH_COMMIT;
  end if;
  if v_ACTION = '��ֵ-���Ҳɹ������-�����' then
      
    DECLARE
      v_RECEIVE_ID CHAR(24);--��ⵥID
      v_RECEIVE_CODE VARCHAR2(100);--��ⵥ��

    BEGIN
      FOR v_row_S_VIEW IN (
          SELECT DISTINCT bpau.AUDIT_USER_ID as USER_ID
             FROM LC_BASE_AUDIT_CONFIG bac, LC_BASE_AUDIT_USER bpau, LC_JOBS_AUDIT jpa,
               (SELECT jp.AUDIT_NO + 1 as AUDIT_NO --��˼���
                  FROM LC_JOBS_PURCHASE jp
                 WHERE jp.ID = v_ORDER_ID --����ID
                   AND jp.STATE = 20) ywdj
            WHERE bpau.CONFIG_ID = jpa.CONFIG_ID
              AND bac.AUDIT_RANGE IN ('0','3') --��˷�Χ��0ȫԺ��3���ֿ���
              AND bac.ID = jpa.CONFIG_ID
              AND jpa.OPERATE_TYPE = '0' --δ���
              AND jpa.SOURCE_ID = v_ORDER_ID --����ID
              AND jpa.AUDIT_NO = ywdj.AUDIT_NO --��˼���
          UNION
          SELECT DISTINCT sduSH.USER_ID
          FROM SYS_USER_ROLE sur, SYS_ROLE_MODULE srm, LC_BASE_AUDIT_CONFIG bac, LC_JOBS_AUDIT jpa, SYS_DEPT_USER sduSH,
               (SELECT jp.DEPT_ID,
                       jp.AUDIT_NO + 1 as AUDIT_NO --��˼���
                  FROM LC_JOBS_PURCHASE jp
                 WHERE jp.ID = v_ORDER_ID --����ID
                   AND jp.STATE = 20) ywdj
          WHERE srm.MODULE_ID in ('000000000000000000020211','000000000000000000020307') --�������쵥���
            AND srm.ROLE_ID = sur.ROLE_ID
            AND sur.USER_ID = sduSH.USER_ID
            AND ywdj.DEPT_ID = sduSH.DEPT_ID
            AND bac.AUDIT_RANGE IN ('1','2') --��˷�Χ��1�����ң�2����(�Է�)����
            AND bac.ID = jpa.CONFIG_ID
            AND jpa.OPERATE_TYPE = '0' --δ���
            AND jpa.SOURCE_ID = v_ORDER_ID --����ID
            AND jpa.AUDIT_NO = ywdj.AUDIT_NO --��˼���
       )
      LOOP
        INSERT INTO SYS_REMIND_PLATFORM
          (ID,
           SYSTEM_ID,
           TO_USER_ID,
           NAVIGATE_ACTION,
           NAVIGATE_PARAMETERS,
           TITLE,
           CONTENT,
           CREATE_USER_ID,
           CREATE_USER,
           CREATE_DATE)
        SELECT
           SYS_REMIND.Nextval, --ID
           LC_SYSTEM_ID, --SYSTEM_ID
           v_row_S_VIEW.USER_ID, --TO_USER_ID
           v_ACTION,--NAVIGATE_ACTION
           v_ORDER_ID,--NAVIGATE_PARAMETERS

           (SELECT nvl(MAX(ABBR),'��Ϣ��ʾ') FROM SYS_SYSTEM WHERE ID = LC_SYSTEM_ID),--TITLE
           '<Section xml:space="preserve" HasTrailingParagraphBreakOnPaste="False" xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation">'
           ||'<Paragraph>'
           ||'<Run FontSize="13.3">��1�Ųɹ�������</Run>'
           ||'<LineBreak/><LineBreak/>'
           ||'<Run FontSize="13.3">������ң�'||jp.DEPT_NAME||'</Run>'
           ||'<LineBreak/><LineBreak/>'
           ||'<Hyperlink FontSize="13.3" Foreground="#FF337BFE" FontStyle="Italic">'
           ||'��������ɹ����š�'||jp.PURCHASE_CODE||'��'
           ||'</Hyperlink>'
           ||'</Paragraph>'
           ||'</Section>',--CONTENT
           v_UserID, --CREATE_USER_ID
           v_UserName, --CREATE_USER
           sysdate --CREATE_DATE
         FROM LC_JOBS_PURCHASE jp
        WHERE jp.ID = v_ORDER_ID --����ID
        ;
      END LOOP;
    END;
    goto FINISH_COMMIT;
  end if;

  if v_ACTION = '��ֵ-�ɹ������-�����' then
    goto FINISH_COMMIT;
  end if;
  if v_ACTION = '��ֵ-��ⵥ���-�����' then
    goto FINISH_COMMIT;
  end if;
  if v_ACTION = '��ֵ-��Ʒ��������-�����' then
    goto FINISH_COMMIT;
  end if;
  if v_ACTION = '��ֵ-��Ʒ��������-�����' then
    goto FINISH_COMMIT;
  end if;
  if v_ACTION = '��ֵ-���˵����-�����' then
    goto FINISH_COMMIT;
  end if;

--��ֵϵͳ$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
--����ϵͳ$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
--�豸ϵͳ$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


--�ɹ��ύ------------------------------------------------------------------------------------------
  <<FINISH_COMMIT>>
  COMMIT;

-- �쳣����
EXCEPTION
   WHEN OTHERS THEN
        ROLLBACK;
        v_ErrMsg:= sqlerrm||'';
        p_hc_his_sync_log('0', v_ACTION, v_EXEC_TAG, v_ErrMsg);
end;

  -- 
  exec  P_SYS_MESSAGE_PUSH('��ֵ-���쵥���-�����', 'LCJOBS000000000004084499', '', 'SYSTEM000001000000393196', '����ͤ', null) 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  