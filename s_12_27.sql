-- ��ȡ��Ļ����ֶ����� --��ȡSqlServer�б�ṹ  http://blog.csdn.net/ni_hao_ya/article/details/7428897
SELECT syscolumns.name,systypes.name,syscolumns.isnullable,   
syscolumns.length
FROM syscolumns, systypes
WHERE syscolumns.xusertype = systypes.xusertype   -- xusertype smallint ��չ���û������������� ID��
AND syscolumns.id=
object_id('��ı���')   --id int ���������ı���� ID
-- ĳ����Ľṹ
select * from syscolumns where id = object_id('����')
--
--��ѯ�н�������յ�û��
SELECT EmployName FROM EMPLOYEE WHERE CAST(MONTH(BIRTHDAY) AS VARCHAR(2))+CAST(DAY(BIRTHDAY) AS VARCHAR(2))=CAST(MONTH(GETDATE()) AS VARCHAR(2))+CAST(DAY(GETDATE()) AS VARCHAR(2))
--����  ����д�ģ�
select   * from  EMPLOYEE where   MONTH (Birthday )+DAY (Birthday)=MONTH(GETDATE ())+DAY (GETDATE ())
--  OPENXML
drop proc  sp_meiyong
create proc  sp_meiyong
 @idoc int,
 @doc varchar(1000)
 as
SET @doc ='
<ROOT>
<Customer CustomerID="VINET" ContactName="Paul Henriot">
   <Order CustomerID="VINET" EmployeeID="5" OrderDate="1996-07-04T00:00:00">
      <OrderDetail OrderID="10248" ProductID="11" Quantity="12"/>
      <OrderDetail OrderID="10248" ProductID="42" Quantity="10"/>
   </Order>
</Customer>
<Customer CustomerID="LILAS" ContactName="Carlos Gonzlez">
   <Order CustomerID="LILAS" EmployeeID="3" OrderDate="1996-08-16T00:00:00">
      <OrderDetail OrderID="10283" ProductID="72" Quantity="3"/>
   </Order>
</Customer>
</ROOT>'
EXEC sp_xml_preparedocument @idoc OUTPUT, @doc   --Create an internal representation of the XML document.
SELECT    *
FROM       OPENXML (@idoc, '/ROOT/Customer',1)
            WITH (CustomerID  varchar(10),
                  ContactName varchar(20)) -- Execute a SELECT statement that uses the OPENXML rowset provider.

--ִ��sp_meiyong	@idoc��	OUTPUT�������   @doc �ڴ洢���������и�ֵ 	  
   exec     sp_meiyong @idoc='', @doc='dd'

--STUFF
�ַ��� abcdef ��ɾ���ӵ� 2 ��λ�ã��ַ� b����ʼ�������ַ���Ȼ����ɾ������ʼλ�ò���ڶ����ַ������Ӷ�����������һ���ַ�����
SELECT STUFF('abcdef', 2, 3, 'ijklmn');
������� 
aijklmnef 
--LEFT
select left('abcdef',3)    
-- FOR xml PATH
create proc  sp_meiyong

 @docHandle int,
 @xmlDocument nvarchar(max) -- or xml type
as
if exists (select * from tempdb.dbo.sysobjects where [name] ='#Customers')   
                       drop table [dbo].[#Customers]
CREATE TABLE #Customers (CustomerID varchar(20) primary key,
                ContactName varchar(20), 
                CompanyName varchar(20))

if exists (select * from tempdb.dbo.sysobjects where [name] ='#Orders')   
                       drop table [dbo].[#Orders]
CREATE TABLE #Orders( CustomerID varchar(20), OrderDate datetime)

SET @xmlDocument = N'<ROOT>
<Customers CustomerID="XYZAA" ContactName="Joe" CompanyName="Company1">
<Orders CustomerID="XYZAA" OrderDate="2000-08-25T00:00:00"/>
<Orders CustomerID="XYZAA" OrderDate="2000-10-03T00:00:00"/>
</Customers>
<Customers CustomerID="XYZBB" ContactName="Steve"
CompanyName="Company2">No Orders yet!
</Customers>
</ROOT>'
EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument
-- Use OPENXML to provide rowset consisting of customer data.
INSERT #Customers (CustomerID,ContactName,CompanyName)
SELECT * 
FROM OPENXML(@docHandle, N'/ROOT/Customers') 
  WITH Customers
-- Use OPENXML to provide rowset consisting of order data.
INSERT #Orders (CustomerID,OrderDate)
SELECT * 
FROM OPENXML(@docHandle, N'//Orders') 
  WITH Orders
-- Using OPENXML in a SELECT statement.
SELECT * FROM OPENXML(@docHandle, N'/ROOT/Customers/Orders') WITH (CustomerID nchar(5) '../@CustomerID', OrderDate datetime)
-- Remove the internal representation of the XML document.
EXEC sp_xml_removedocument @docHandle 

--http://www.cnblogs.com/doubleliang/archive/2011/07/06/2098775.html  FOR XML PATH
create  table #meiyong2
(
	hobbyID int primary key identity(1,1) ,
	hName nvarchar(50)
)
insert into #meiyong2 values('��ɽ')
insert into #meiyong2 values('��Ӿ')
insert into #meiyong2 values('��ʳ')

select * from #meiyong2
SELECT * FROM #meiyong2 FOR XML PATH   --FOR XML PATH ���Խ���ѯ��������������XML��ʽ 
-- ��ô����θı�XML�нڵ�������أ��������£� 
SELECT * FROM #meiyong2 FOR XML PATH('XYTHobby')
--��ô�нڵ���θı��أ����ǵĸ���������Ĺؼ���AS�𣿶��˾�������!�������£�
SELECT hobbyID as 'MyCode',hName as 'MyName' FROM #meiyong2 FOR XML PATH('MyHobby')

--��Ȼ�еĽڵ����еĽڵ����Ƕ������Զ��壬�����Ƿ���Թ�������ϲ���������ʽ�أ����ǿ����룺û�����ǻ�����ͨ������+�ţ������ַ��������ֶε������ʽ���ж��塣������£�
SELECT '[ '+hName+' ]' FROM #meiyong2 FOR XML PATH('')
--��ô�������͵�����ô�Զ��壿 û��ϵ�����ǽ�����ת�����ַ������;����������磺
SELECT '{'+STR(hobbyID)+'}','[ '+hName+' ]' FROM #meiyong2 FOR XML PATH('')

--FOR XML PATHӦ�� http://www.cnblogs.com/wangjingblogs/archive/2012/05/16/2504325.html
create table #meiyongStu
(
	stuID int primary key identity(1,1),
	sName nvarchar(100),
	hobby nvarchar(100)
)
insert into #meiyongStu values('������','��ɽ')
insert into #meiyongStu values('������','����')
insert into #meiyongStu values('Ī��','�Է�')
insert into #meiyongStu values('Ī��','����')
insert into #meiyongStu values('Ī��','�����Ӿ�')
insert into #meiyongStu values('�໪','����')
insert into #meiyongStu values('������','����')
insert into #meiyongStu values('����','����Ӱ')
select * from  #meiyongStu

SELECT B.sName,LEFT(StuList,LEN(StuList)-1) as hobby FROM (
SELECT sName,
(SELECT hobby+',' FROM #meiyongStu 
  WHERE sName=A.sName 
  FOR XML PATH('')) AS StuList
FROM #meiyongStu A 
GROUP BY sName
) B 
--���Կ���StuList����������ݶ�����һ�����ţ���ʱ���������:SELECT B.sName,LEFT(StuList,LEN(StuList)-1) as hobby  ������ȥ������
--  http://zhidao.baidu.com/link?url=YKWKuaAk3HjU_bhS5QGVt9h56nSmROyLBo1gMgQ-P7jDOHEjzBECZ2PPolWfg_MD0hnwRTITt4TbrsBtzX6j_a
 drop table t_meiyong
  create  table  t_meiyong
  (
	fieldname nvarchar(20) not null
  )
insert into t_meiyong values('AAA')
insert into t_meiyong values('BBB')
insert into t_meiyong values('CCC')
select * from t_meiyong
 SELECT  stuff((select ',' + fieldname  from t_meiyong for xml path('')),1,1,'')
 
--��12088|1 ��
create table #meiyong
(
DiseaseCodeValue	varchar(100)
)
insert into #meiyong(DiseaseCodeValue)
select '12088|1' union
 select '11106|7' union
 select '11937|3' 
 
 select * from #meiyong
 
 select '10511',SUBSTRING(DiseaseCodeValue,1,CHARINDEX('|',DiseaseCodeValue)-1),
		cast(SUBSTRING(DiseaseCodeValue,CHARINDEX('|',DiseaseCodeValue)+1,LEN(DiseaseCodeValue)-CHARINDEX('|',DiseaseCodeValue)) as decimal),
		'12666' from #meiyong
--NULLIF ����ʾ������ budgets ������ʾ���� (dept) �ĵ���Ԥ�� (current_year) �Լ���һ��Ԥ�� (previous_year)�����ڵ���Ԥ�㣬��Щͬ��һ�����Ԥ��û�иı�Ĳ���ʹ�� NULL����ЩԤ�㻹û��ȷ���Ĳ���ʹ�� 0����Ҫֻ������Щ����Ԥ��Ĳ��ŵ�Ԥ��ƽ��ֵ����������һ���Ԥ��ֵ��current_year Ϊ NULL ʱ��ʹ�� previous_year ��ֵ���������ʹ�� NULLIF �� COALESCE ������

if exists (select * from tempdb.dbo.sysobjects where [name] ='#OutTemp')   
                       drop table [dbo].[#budgets]
CREATE TABLE #budgets
(
   dept            tinyint   IDENTITY,
   current_year      decimal   NULL,
   previous_year   decimal   NULL
);
INSERT #budgets VALUES(10, 15);
INSERT #budgets VALUES(NULL, 30);
INSERT #budgets VALUES(0, 10);
INSERT #budgets VALUES(NULL, 15);
INSERT #budgets VALUES(30, 25);

select * from #budgets
SELECT AVG(NULLIF(COALESCE(current_year,
   previous_year), 0.00)) AS 'Average Budget'
FROM #budgets;
--online
NULLIF����Ҫ��������,�������ָ���ı��ʽ�ȼۣ��򷵻� null 
���ӣ�NULLIF(a,b)  --˵�������a��b����ȵģ���ô����NULL���������ȷ���a 
select NULLIF('eqeqweqwe','1')  -- �����eqeqweqwe 
select NULLIF(1,1)  -- �����NULL 

ISNULL����Ҫ����������Ŀ���ǽ�null�滻Ϊָ����ֵ������һ��������Ϊnull���򷵻ص�һ������
���ӣ�ISNULL(a,b) 
˵�������a��bͬʱΪNULL������NULL�����aΪNULL��b��ΪNULL������b�����a��ΪNULL��bΪNULL����a�����a��b����ΪNULL����a 
select ISNULL(null,null)�����null 
select ISNULL(null,33)�����33 
select ISNULL('ddd',null)�����ddd 
select ISNULL(44,33)�����44

select   isnull(ceiling( 3/nullif(2.000000,0) ) * 6 ,0)
-- COALESCE    wages ���а������������йع�Ա����н����Ϣ��hourly wage��salary �� commission�����ǣ�ÿ����Աֻ�ܽ���һ�ָ��ʽ����Ҫȷ��֧�������й�Ա�Ľ����������ʹ�� COALESCE ��������ֻ������ hourly_wage��salary �� commission ���ҵ��ķǿ�ֵ��

if exists (select * from tempdb.dbo.sysobjects where [name] ='#wages')   
                       drop table [dbo].[#wages]
CREATE TABLE #wages
(
   emp_id      tinyint    identity,
   hourly_wage   decimal   NULL,
   salary      decimal    NULL,
   commission   decimal   NULL,
   num_sales   tinyint   NULL
);
INSERT #wages VALUES(10.00, NULL, NULL, NULL);
INSERT #wages VALUES(20.00, NULL, NULL, NULL);
INSERT #wages VALUES(30.00, NULL, NULL, NULL);
INSERT #wages VALUES(40.00, NULL, NULL, NULL);
INSERT #wages VALUES(NULL, 10000.00, NULL, NULL);
INSERT #wages VALUES(NULL, 20000.00, NULL, NULL);
INSERT #wages VALUES(NULL, 30000.00, NULL, NULL);
INSERT #wages VALUES(NULL, 40000.00, NULL, NULL);
INSERT #wages VALUES(NULL, NULL, 15000, 3);
INSERT #wages VALUES(NULL, NULL, 25000, 2);
INSERT #wages VALUES(NULL, NULL, 20000, 6);
INSERT #wages VALUES(NULL, NULL, 14000, 4);

select * from #wages
SELECT CAST(COALESCE(hourly_wage * 40 * 52, 
   salary, 
   commission * num_sales) AS money) AS 'Total Salary' 
FROM #wages;		
 
SELECT COALESCE( 12,null,0 ) 
--online
 create table #Persons
 (
	FirstName nvarchar(100),
	MiddleName  nvarchar(100),
	LastName  nvarchar(100)
 )
insert into #Persons values('John ','A.','MacDonald   ')
insert into #Persons values('Franklin ','D.	','Roosevelt ')
insert into #Persons values('Madonna ',null ,null )
insert into #Persons values('Cher ',null ,null)
insert into #Persons values('Mary ','Weilage ','MacDonald ')
 select * from #Persons
--���������һ���ַ����г����ǵ�ȫ����������������ʹ��SQL Server COALESCE()������ɴ˹��ܣ�
SELECT FirstName + ' ' +COALESCE(MiddleName,'')+ ' ' +COALESCE(LastName,'')
from  #Persons
--online
-- �������зǿղ����� ISNULL �ı��ʽ����Ϊ NOT NULL�����������зǿղ����� COALESCE �ı��ʽ����Ϊ NULL �� SQL Server �У���Ҫ�԰������зǿղ����� COALESCE �ı��ʽ��������������ʹ�� PERSISTED �����Խ������г־û��������������ʾ��
 CREATE TABLE #CheckSumTest   
     (  
         ID int identity ,  
         Num int DEFAULT ( RAND() * 100 ) ,  
         RowCheckSum AS COALESCE( CHECKSUM( id , num ) , 0 ) PERSISTED PRIMARY KEY  
     ); 
     
   select * from #CheckSumTest
   insert into #CheckSumTest values('23')
      insert into #CheckSumTest values('56')
    insert into #CheckSumTest values('')
    insert into #CheckSumTest values(null )
--online
IF OBJECT_ID('#x') IS NOT NULL   DROP TABLE #
CREATE TABLE #x(
    COL1 VARCHAR(10),
    COL2 VARCHAR(10),
    COL3 VARCHAR(10)
)
INSERT INTO #x SELECT NULL,'COL2',''

SELECT * FROM #x
SELECT coalesce(COL1,COL2,COL3) FROM #x
--online
--��emp���и�comm��Ϊ�յ���Ա��Ϊ200
drop table #y
create table #y
(
	EMPNO  int  primary key,
	 ENAME  varchar(50),
	 COMM    decimal
)
insert into #y values(7369 ,'SMITH',null)
insert into #y values(7499  ,'ALLEN    ',null  )
insert into #y values(7521 ,'WARD   ',300      )
insert into #y values(7566  ,'JONES   ',500   )
insert into #y values(7654  ,'MARTIN   ',1400    )
insert into #y values(7698  ,'BLAKE ',null)
insert into #y values(7782   ,'CLARK',null  )
insert into #y values(7788  ,'SCOTT',null    )
insert into #y values(7839   ,'KING ',null   )
insert into #y values(7844   ,'TURNER  ',	0  )
insert into #y values(7876   ,'ADAMS ',null    )

select * from #y
 select a.empno,a.ename,comm,coalesce(comm,200)new_comm from #y a;
 --
drop   table t_meiyong
create table t_meiyong
(
		name nvarchar(20)
)
insert into t_meiyong values('�ƺ�')
insert into t_meiyong values('���ӵĽ�ͷ')
insert into t_meiyong values('׷����')
insert into t_meiyong values('Ư������')
select * from t_meiyong

alter FUNCTION fun_meiyong
(
@EmpBasicMainID int
)
returns varchar(8000) 
as
begin
declare @ReturnValue varchar(8000)
 set @ReturnValue=''
 if isnull(@EmpBasicMainID,'')<>''
 begin
		select  @ReturnValue=dbo.x.name
		from  dbo.x
end
return @ReturnValue
end

select  fun_meiyong(23)
--	
--��ѯ�ظ�����
drop table t_meiyong
create table t_meiyong
( id int identity(1,1),
se_id varchar(2),
sp_id varchar(2)
)
insert into t_meiyong values('1','A')
insert into t_meiyong values('1','A')
insert into t_meiyong values('2','B')
insert into t_meiyong values('2','C')
insert into t_meiyong values('3','A')
insert into t_meiyong values('3','A')
insert into t_meiyong values('79','B')
select * from t_meiyong
--�ظ���ֻȡһ��
select  * from t_meiyong where id in(
	select min(id) from t_meiyong group by se_id,sp_id
)
--SQL Server��ȡ�ظ�����(ֻ���ظ�����)�ķ�����
--1.��ȡ�ظ������ݵ�ֵ 2.SQL Server��ȡ�ظ����ݵļ�¼
select  * from t_meiyong where sp_id in
(
select  sp_id  from t_meiyong 
group by sp_id 
having(COUNT (*)>1)
)
--��ȡ������ظ�����(ֻ�в��ظ�����)
select * from t_meiyong where sp_id not in
(
	select MAX (sp_id) from t_meiyong
	group  by sp_id
	having(COUNT(*)>1)
)	
--�ظ������ݿ��������������������һ��ʱ����ֻ��ĳЩ�ֶ�һ�����ڶ��������м�¼��ȫһ����
select se_id ,sp_id  from t_meiyong group by  se_id ,sp_id having COUNT (*)>1
--��д��
delete from t_meiyong  where se_id in  
(
select  se_id from t_meiyong group by  se_id,sp_id having COUNT (*)>1
)
and sp_id in
(
select  sp_id from t_meiyong group by  se_id,sp_id having COUNT (*)>1
)
--
drop table t_meiyong
create table t_meiyong
( id int identity(1,1),
se_id varchar(100),
sp_id varchar(100),
xx varchar(100),
yy varchar(100)
)
insert into t_meiyong values('˭�Ǵ��','��֪��','aa','bb')
insert into t_meiyong values('���Ǹ��','���Ǹ��','q','ma')
insert into t_meiyong values('���Ǵ��','ʲô','f','gh')
insert into t_meiyong values('���Ǹ��','���Ǹ��','k','as')
insert into t_meiyong values('��֪��','XX','������','������')

select * from t_meiyong
--����д��
select * from t_meiyong where se_id in (
select se_id   from t_meiyong  group by se_id,sp_id having (COUNT(*)>1))
and sp_id in(
select sp_id   from t_meiyong  group by se_id,sp_id having (COUNT(*)>1))
--sqlserver �������޸ı����ֶε�����
EXEC sp_rename '����.[ԭ����]', '������', 'column' 
--�����sql��佫ĳ����Ϊ����  http://zhidao.baidu.com/link?url=mzv9buI0pZUCeSXbQwXp31Cskv4ucXTwC7mvyzh7uB2rj1fx9VmfCPabsB2SY2KEfowqBJeL0RkEocOrr8Hms_
alter table ���� add constraint PK_����Լ�� primary key ��lie��
--row_number() over
create table #meiyong
(
	empid int primary key identity(1,1),
	deptid int not null,
	salary decimal(18,2) not null,
	rank int not null  --���ʵȼ�
	
)
insert into #meiyong values (10,13000,1)
insert into #meiyong values (20,3000,3)
insert into #meiyong values (20,8000,2)
insert into #meiyong values (30,9000,2)
insert into #meiyong values (10,2900,3)

SELECT *, Row_Number() OVER (partition by deptid ORDER BY salary desc) rank FROM #meiyong
--http://zhidao.baidu.com/link?url=ZAeWnbabFTgkzjHxl_VEd8E9nYX9tbFwXko_7aVsFWjGt-Cyd5RCIvar6xGyrn235sVoUvLRaNsSDu-ygywQNLyYIx_RllOPDWj53REIm3W
create table #meiyong
(
 news_id int primary key identity(1,1),
 news_title varchar(50) not null,
 news_author varchar(20) ,
 news_summary varchar(50),
 news_content text not null,
 news_pic varchar(50)
)
insert into  #meiyong values('�ܽ��׽����','С����','���ص��ڱ���ʱ ʱ�����6Сʱ','������˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ���',null)
insert into  #meiyong values('���������','С����','���ص����Ϻ� ʱ�����6Сʱ','������˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ���',null)
insert into  #meiyong values('�����������','С����','���ص����Ϻ� ʱ�����6Сʱ','������˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ��˽�����˺ܶ���',null)
insert into  #meiyong values('�����������','С����','���ص����Ϻ� ʱ�����6Сʱ','����',null)
insert into  #meiyong values('���ݽ����','С����','���ص��ڱ���','������˭',null)
insert into  #meiyong values('���ݽ����','С����','���ص��ڱ���','������˭',null)
insert into  #meiyong values('���ݽ����','С����','���ص��ڱ���','������˭',null)
insert into  #meiyong values('���ݽ����','С����','���ص��ڱ���','������˭',null)
insert into  #meiyong values('ԭ�ӵ�������','СԲ��','�õ�','�úúúúú�',null)
insert into  #meiyong values('ԭ�ӵ�������','СԲ��','�õ�','�úúúúú�',null)
insert into  #meiyong values('ԭ�ӵ�������','СԲ��','�õ�','�úúúúú�',null)
insert into  #meiyong values('ԭ�ӵ�������','СԲ��','�õ�','�úúúúú�',null)
insert into  #meiyong values('���ƶ�����ѧ����','С����','��Ǯ','��Ǯ��Ǯ��Ǯ��Ǯ',null)

select *from #meiyong
--����1��
SELECT TOP 5 *     -- 5�� ҳ��С
FROM #meiyong
WHERE news_id NOT IN
          (
          SELECT TOP (5*(3-1)) news_id FROM #meiyong ORDER BY news_id    --3��ҳ�� 
          )
ORDER BY news_id
--����2��	
SELECT TOP 5 *  -- 5�� ҳ��С
FROM #meiyong
WHERE news_id >
          (
          SELECT ISNULL(MAX(news_id),0) 
          FROM 
                (
                SELECT TOP (5*(3-1)) news_id FROM #meiyong ORDER BY news_id --3��ҳ�� 
                ) A
          )
ORDER BY news_id
--����3��
SELECT TOP 5 *  -- 5�� ҳ��С
FROM 
        (
        SELECT ROW_NUMBER() OVER (ORDER BY news_id) AS RowNumber,* FROM #meiyong
        ) A
WHERE RowNumber > 5*(3-1)  --3��ҳ�� 

select  top 10 * (select row_number()over (order by SubHealthItemCode)as  RowNumber, SubHealthItemCode,SubHealthItemName from   Gy_SubHealthItemSet where  SubHealthCode='SH1001 ' and NoTakeFlag=0) A where RowNumber > 10*(2-1)
--http://zhidao.baidu.com/link?url=LKJbLy_MoRpSqzaNiWUIpV-feX42pRx30B4BhAEZJRz7rmVzjKidGhFf6o-nSfP5ef7piS2LpVJ3DjOKujQMWq
--��������д�001��ʼ
CREATE TABLE #meiyong (
  id    INT  IDENTITY(1, 1)  PRIMARY KEY,
  code  AS   RIGHT(Cast((1000 + id) as varchar), 3),
  val   VARCHAR(10)
);   

INSERT INTO #meiyong(val) VALUES ('NO id');
INSERT INTO #meiyong(val) VALUES ('NO id2');
SELECT * FROM #meiyong;

select LEFT('SQL_Server_2008',4 );  
select RIGHT('SQL_Server_2008',4 ); 
select Cast((1000 + 1) as varchar)  
select RIGHT(Cast((1000 + 1) as varchar),3);  
--��ΰ�sql��ĳһ�е�ֵȫ���ö���ƴ������ http://zhidao.baidu.com/link?url=zDr5kKj6Yb2alg3LEpcUbGuBuvXhyNHYmSqFOt6KDSJoOilvO3bzr_IDO5yWjaWi0i3sAl1_O2iq58COU1oD-lsPB7t_aAX1fzWdk9aCdz7
create table #TABLE_1 
(
	T1 nvarchar(20)  
)
create table #TABLE_2
(
	T2 nvarchar(20)  
)
create table #TABLE_3
(
	M nvarchar(20)  ,
	N nvarchar(20)  
)
insert into  #TABLE_1 values('xyt')
insert into  #TABLE_1 values('sm')
insert into  #TABLE_1 values('32')
insert into  #TABLE_2 values('wcl')
insert into  #TABLE_2 values('45')
insert into  #TABLE_2 values('23')
insert into  #TABLE_2 values('love')
select * from #TABLE_1
select * from #TABLE_2

select distinct T1 M, stuff((select ','+cast(b.t1 as varchar) from #TABLE_1 b where 1=1 for xml path('')),1,1,'')  N
from #TABLE_1 a 
union all
select distinct T2 M, stuff((select ','+cast(b.t2 as varchar) from #TABLE_2 b where 1=1 for xml path('')),1,1,'')  N
from #TABLE_2 a
--for xml path������
select 'T1' M, stuff((select ',' + CAST(T1 as varchar) from #Table_1 for xml path('')),1,1,'') N
union
select 'T2' M, stuff((select ',' + CAST(T2 as varchar) from #Table_2 for xml path('')),1,1,'') N
--SQL STUFF���� ƴ���ַ���  http://www.cnblogs.com/yongheng178/archive/2012/06/27/2565631.html       tony_cheung@tcmworld.com
create table #tb(id int, value varchar(10))
insert into #tb values(1,'aa')
insert into #tb values(1,'bb')
insert into #tb values(2,'aaa')
insert into #tb values(2,'bbb')
insert into #tb values(2,'ccc')
select * from #tb

SELECT id, 
                      value = stuff
                          ((SELECT     ',' + value
                              FROM         #tb AS t
                              WHERE     t .id = #tb.id FOR xml path('')), 1, 1, '')
FROM         #tb
GROUP BY id
--http://zhidao.baidu.com/link?url=zdJ0-n2uyQZ0dYw_8LAHIc3MZVZKL7Q6TTf0WPmEUOHf3ACCnlx0vaNB3mMHZMwZZm-GBBlkcsP0Z3i4IPEh273rxhO_Bdhq15dSSa8SEnq
 drop   TABLE t_meiyong 
 CREATE TABLE t_meiyong (
  id int NOT NULL,
  Ptrack int 
) 
insert into t_meiyong values(1,null )
insert into t_meiyong values(2,null)
insert into t_meiyong values(3,null)
insert into t_meiyong values(4,null)
insert into t_meiyong values(5,null)
insert into t_meiyong values(6,null)
insert into t_meiyong values(7,null)
insert into t_meiyong values(8,null)
insert into t_meiyong values(9,null)
select * from  t_meiyong

 drop   PROCEDURE sp_meiyong
CREATE PROCEDURE sp_meiyong
as
declare @i int
declare @maxid int
set @i=0
select @maxid=max(id) from t_meiyong
begin
  while @i<@maxid
    begin
      update t_meiyong set Ptrack = @i+1 where id=@i+1
      set @i=@i+1
      if @i=7
         begin
           set @i=0
           break
         end
    end
end

exec  sp_meiyong
--  http://www.cnblogs.com/lyhabc/p/4176269.html 
 drop   TABLE t_meiyong 
 drop   TABLE t_meiyong1
 CREATE TABLE t_meiyong (
  id int NOT NULL,
  log_time DATETIME DEFAULT ''
) 
 CREATE TABLE t_meiyong1 (
  id int NOT NULL,
  log_time DATETIME DEFAULT ''
) 
	select 1 ,GETDATE() 
alter PROCEDURE sp_meiyong   --��t_meiyongѭ����ֵ
as
declare @i int=1
while  @i<101
	begin
		insert into t_meiyong
		select @i,GETDATE() 
		set @i=@i+1
	end
	
exec  sp_meiyong

select * from t_meiyong
select * from t_meiyong1
SELECT  COUNT(*)                                -- ��ѯ�����200
FROM    ( SELECT    *
          FROM      t_meiyong
          UNION
          SELECT    *
          FROM      t_meiyong1
        ) AS T;
-- http://www.cnblogs.com/lyhabc/p/4176269.html  �ӷ�ȥ�� union ������ų��ظ��ģ�������bug����ĳЩ�����²��ܼ򵥱�ʾ�����һ�£��൱����Ч
select * from t_meiyong
select * from t_meiyong1

INSERT INTO t_meiyong( [id],[log_time] ) VALUES(1,''),(3,''),(4,'')
INSERT INTO t_meiyong1( [id],[log_time] )VALUES(1,''),(2,''),(3,'')

select * from t_meiyong
select * from t_meiyong1



SELECT  COUNT(*)                              -- ��ѯ�����4 
FROM    ( SELECT    *
          FROM      t_meiyong
          UNION
          SELECT    *
          FROM     t_meiyong1
        ) AS T;
--  ��������EXCEPT  ��������
SELECT  COUNT(*)
FROM    ( SELECT    *
          FROM       t_meiyong
          EXCEPT
          SELECT    *
          FROM    t_meiyong1
        ) AS T;
        
SELECT  COUNT(*)
FROM    ( SELECT    *
          FROM      t_meiyong1
          EXCEPT
          SELECT    *
          FROM       t_meiyong
        ) AS T;
--  �����ģ���ȫ��INNER JOIN�����Ҳ�����õ���������Ȼ����ָ�����ڱ��¼��������������
drop proc sp_meiyong
create PROCEDURE sp_meiyong 
as
DECLARE @t1_newcount BIGINT
DECLARE @count BIGINT

SELECT  @t1_newcount = COUNT(*)
FROM    t_meiyong1

SELECT  @count = COUNT(*)
FROM    t_meiyong AS a
        INNER JOIN t_meiyong1  AS b ON [b].[id] = [a].[id]
                                    AND [b].[log_time] = [a].[log_time] --������л��������ֶε��������
PRINT @count
PRINT @t1_newcount
IF ( @count = @t1_newcount )
    BEGIN 
        SELECT  'equal'
    END 
ELSE
    BEGIN
        SELECT  'not equal'

    END 
    
    select * from t_meiyong
select * from t_meiyong1
    exec  sp_meiyong
-- SQL Server �α���� ����/��/ѭ��ʵ��  http://www.jb51.net/article/36052.htm
create table #a 
( 
id varchar(20), 
name varchar(20) 
) 
insert into #a select 1,'jack' 
insert into #a select 2,'join' 
insert into #a select 3,'make' 
select * from  #a

declare mycursor cursor --����һ���α�  ����һ����MyCursor���α꣬���for select �������  
for select * from #a 
open mycursor   --��һ���α�  ����������ݼ� 
declare @id varchar(20),@name varchar(20)   
fetch next from mycursor into @id,@name  -- �ƶ��α�ָ�򵽵�һ�����ݣ���ȡ��һ�����ݴ���ڱ�����  
while @@fetch_status=0    -- �����һ�β����ɹ������ѭ�� 
begin 
select @id,@name 
fetch next from mycursor into @id,@name   --��������һ�� 
end 
close mycursor 
deallocate mycursor 
-- http://www.cnblogs.com/wang-123/archive/2012/01/05/2312676.html
drop  TABLE t_meiyong
create TABLE t_meiyong
    (
        ID int identity(1,1) primary key NOT NULL,   
        classid int, 
        sex varchar(10),
        age int, 
    ) 
    
--��Ӳ�������
    Insert into t_meiyong values(1,'��',20)
    Insert into t_meiyong values(2,'Ů',22)
    Insert into t_meiyong values(3,'��',23)
    Insert into t_meiyong values(4,'��',22)
    Insert into t_meiyong values(1,'��',24)
    Insert into t_meiyong values(2,'Ů',19)
    Insert into t_meiyong values(4,'��',26)
    Insert into t_meiyong values(1,'��',24)
    Insert into t_meiyong values(1,'��',20)
    Insert into t_meiyong values(2,'Ů',22)
    Insert into t_meiyong values(3,'��',23)
    Insert into t_meiyong values(4,'��',22)
    Insert into t_meiyong values(1,'��',24)
    Insert into t_meiyong values(2,'Ů',19)
    select * from t_meiyong
    
    select COUNT(*)as '>20������',classid  from t_meiyong where sex='��' group by classid,age having age>20 
-- С������
drop table t_meiyong
create table t_meiyong
(
 n1 nvarchar(20) not null,
 n2 nvarchar(20) not null,
 i1 int ,
 i2 int 
)
insert into t_meiyong values('�ӱ�����','��������',2,45)
insert into t_meiyong values('���ϳ�ɳ','�����żҽ�',9,45)
insert into t_meiyong values('��������','�����人',null,45)
insert into t_meiyong values('�ӱ�����','��������',2,65)
insert into t_meiyong values('�ӱ�����','��������',2,45)
insert into t_meiyong values('��������','����ɳ��',9,32)
insert into t_meiyong values('��������','��������',2,45)
insert into t_meiyong values('�����人','��������',88,32)
insert into t_meiyong values('�����żҽ�','������̶',7,22)
insert into t_meiyong values('�����人','������ʯ',null,44)
--
 drop proc  sp_meiyong
alter proc sp_meiyong
as
declare @i1 int 
set @i1=(select top 1 a.i1 from t_meiyong a left join t_meiyong b
on a.n1=b.n2 where a.i1 is not null  and a.n1='��������')
update t_meiyong set i2=@i1 where n2='��������'
-- ѭ����ôд δ��  http://jingyan.baidu.com/article/a681b0decb014b3b1843463d.html
drop table t_meiyong
create table t_meiyong
(
	code int primary key identity(1,1),
	salary int ,
	city  nvarchar(20)
)
insert into t_meiyong values(8000,'����')
insert into t_meiyong values(8200,'�Ϻ�')
insert into t_meiyong values(5500,'�人')
insert into t_meiyong values(6100,'���')
insert into t_meiyong values(6300,'��ũ��')
--  ����ID������ ������id��ͬ��name ��age ��ͬ������ �Ѿ� name age Ϊnull������ http://blog.csdn.net/windren06/article/details/8188136
drop table t_meiyong
drop table t_meiyong1
create table t_meiyong
(
ID int primary key ,
name nvarchar(20)not null,
age int not null,
)
create table t_meiyong1
(
ID int primary key not null ,
name nvarchar(20) not null,
age int not null,
)
insert into t_meiyong values(1,'������',22)
insert into t_meiyong values(3,'�̹�ϣ',33)
insert into t_meiyong values(4,'������',35)
insert into t_meiyong values(5,'������',34)
insert into t_meiyong values(7,'������',28)

insert into t_meiyong1 values(1,'������',22)
insert into t_meiyong1 values(2,'����',56)
insert into t_meiyong1 values(4,'������',35)
insert into t_meiyong1 values(5,'����',31)
insert into t_meiyong1 values(6,'������',34)
select * from  t_meiyong
select * from  t_meiyong1

-- ʹ�� not in ,�������,Ч�ʵ�  
select  * from t_meiyong A where A.ID not in(select ID from t_meiyong1 )
-- ʹ�� left join...on... , "B.ID isnull" ��ʾ������֮����B.ID �ֶ�Ϊ null�ļ�¼
select t_meiyong.ID from t_meiyong left join t_meiyong1 on t_meiyong.ID=t_meiyong1.ID where t_meiyong1.ID is null
-- �߼���Ը���,�����ٶ����  
select * from t_meiyong
where (select count(1) as num from t_meiyong1 where t_meiyong1.ID = t_meiyong.ID) = 0

select * from MedicalCareERP.dbo.Gy_WesternMedicine A
where A.WesternMedicineCode not in(select WesternMedicineCode  from  Gy_WesternMedicine )

select  *  from MedicalCareERP.dbo.Gy_KFMedMain A where A.WesternMedicineCode not  in
( select WesternMedicineCode  from Gy_WesternMedicine  )

--
--�Ҳ���� 
select * from Gy_WesternMedicine where WesternMedicineCode  in('I64.X04 ','E14.901','R33.X01','I49.804 ','M54.561  ','K29.502 ','zzxy32 ','I00.X02','zzxy33 ','J42.X02','R16.201')
-- �������е�
select 
 A.WesternMedicineCode,A.WesternMedicineName,B.WesternMedicineCode
 from (
select * from Gy_WesternMedicine where WesternMedicineCode in ('R33.X01','M54.561','K29.502','I00.X02','J42.X02')
)A left join GXMedicalCareERP.dbo.Gy_WesternMedicine B on B.WesternMedicineName=A.WesternMedicineName
--  SqlServer�н�ȡС��λ�� http://zhidao.baidu.com/link?url=xtrPrj1VkgT5kpzIdIr7_aQB6GloIhHDmSPwbEtBayC3hDlkEc86V5Yq0BKrmENIuz7E6miettJztZWIlM6bwp6WyOE1-VvGSb9FWafeHd7
select cast(1234.9678 as int)
-- 
                                                     						