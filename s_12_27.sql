-- 获取表的基本字段属性 --获取SqlServer中表结构  http://blog.csdn.net/ni_hao_ya/article/details/7428897
SELECT syscolumns.name,systypes.name,syscolumns.isnullable,   
syscolumns.length
FROM syscolumns, systypes
WHERE syscolumns.xusertype = systypes.xusertype   -- xusertype smallint 扩展的用户定义数据类型 ID。
AND syscolumns.id=
object_id('你的表名')   --id int 该列所属的表对象 ID
-- 某个表的结构
select * from syscolumns where id = object_id('表名')
--
--查询有今天过生日的没有
SELECT EmployName FROM EMPLOYEE WHERE CAST(MONTH(BIRTHDAY) AS VARCHAR(2))+CAST(DAY(BIRTHDAY) AS VARCHAR(2))=CAST(MONTH(GETDATE()) AS VARCHAR(2))+CAST(DAY(GETDATE()) AS VARCHAR(2))
--或者  （我写的）
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

--执行sp_meiyong	@idoc是	OUTPUT输出参数   @doc 在存储过程里面有赋值 	  
   exec     sp_meiyong @idoc='', @doc='dd'

--STUFF
字符串 abcdef 中删除从第 2 个位置（字符 b）开始的三个字符，然后在删除的起始位置插入第二个字符串，从而创建并返回一个字符串。
SELECT STUFF('abcdef', 2, 3, 'ijklmn');
结果集： 
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
insert into #meiyong2 values('爬山')
insert into #meiyong2 values('游泳')
insert into #meiyong2 values('美食')

select * from #meiyong2
SELECT * FROM #meiyong2 FOR XML PATH   --FOR XML PATH 可以将查询结果根据行输出成XML格式 
-- 那么，如何改变XML行节点的名称呢？代码如下： 
SELECT * FROM #meiyong2 FOR XML PATH('XYTHobby')
--那么列节点如何改变呢？还记的给列起别名的关键字AS吗？对了就是用它!代码如下：
SELECT hobbyID as 'MyCode',hName as 'MyName' FROM #meiyong2 FOR XML PATH('MyHobby')

--既然行的节点与列的节点我们都可以自定义，我们是否可以构建我们喜欢的输出方式呢？还是看代码：没错我们还可以通过符号+号，来对字符串类型字段的输出格式进行定义。结果如下：
SELECT '[ '+hName+' ]' FROM #meiyong2 FOR XML PATH('')
--那么其他类型的列怎么自定义？ 没关系，我们将它们转换成字符串类型就行啦！例如：
SELECT '{'+STR(hobbyID)+'}','[ '+hName+' ]' FROM #meiyong2 FOR XML PATH('')

--FOR XML PATH应用 http://www.cnblogs.com/wangjingblogs/archive/2012/05/16/2504325.html
create table #meiyongStu
(
	stuID int primary key identity(1,1),
	sName nvarchar(100),
	hobby nvarchar(100)
)
insert into #meiyongStu values('徐益涛','爬山')
insert into #meiyongStu values('徐益涛','足球')
insert into #meiyongStu values('莫言','吃饭')
insert into #meiyongStu values('莫言','旅游')
insert into #meiyongStu values('莫言','看电视剧')
insert into #meiyongStu values('余华','读书')
insert into #meiyongStu values('郭敬明','购物')
insert into #meiyongStu values('韩寒','看电影')
select * from  #meiyongStu

SELECT B.sName,LEFT(StuList,LEN(StuList)-1) as hobby FROM (
SELECT sName,
(SELECT hobby+',' FROM #meiyongStu 
  WHERE sName=A.sName 
  FOR XML PATH('')) AS StuList
FROM #meiyongStu A 
GROUP BY sName
) B 
--可以看到StuList列里面的数据都会多出一个逗号，这时随外层的语句:SELECT B.sName,LEFT(StuList,LEN(StuList)-1) as hobby  就是来去掉逗号
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
 
--把12088|1 拆开
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
--NULLIF 以下示例创建 budgets 表以显示部门 (dept) 的当年预算 (current_year) 以及上一年预算 (previous_year)。对于当年预算，那些同上一年相比预算没有改变的部门使用 NULL，那些预算还没有确定的部门使用 0。若要只计算那些接收预算的部门的预算平均值，并包含上一年的预算值（current_year 为 NULL 时，使用 previous_year 的值），请组合使用 NULLIF 和 COALESCE 函数。

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
NULLIF：需要两个参数,如果两个指定的表达式等价，则返回 null 
例子：NULLIF(a,b)  --说明：如果a和b是相等的，那么返回NULL，如果不相等返回a 
select NULLIF('eqeqweqwe','1')  -- 结果是eqeqweqwe 
select NULLIF(1,1)  -- 结果是NULL 

ISNULL：需要两个参数，目标是讲null替换为指定的值，若第一个参数不为null，则返回第一个参数
例子：ISNULL(a,b) 
说明：如果a和b同时为NULL，返回NULL，如果a为NULL，b不为NULL，返回b，如果a不为NULL，b为NULL返回a，如果a和b都不为NULL返回a 
select ISNULL(null,null)结果是null 
select ISNULL(null,33)结果是33 
select ISNULL('ddd',null)结果是ddd 
select ISNULL(44,33)结果是44

select   isnull(ceiling( 3/nullif(2.000000,0) ) * 6 ,0)
-- COALESCE    wages 表中包括以下三列有关雇员的年薪的信息：hourly wage、salary 和 commission。但是，每个雇员只能接受一种付款方式。若要确定支付给所有雇员的金额总数，请使用 COALESCE 函数，它只接受在 hourly_wage、salary 和 commission 中找到的非空值。

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
--如果你想用一个字符串列出他们的全名，下面给出了如何使用SQL Server COALESCE()函数完成此功能：
SELECT FirstName + ' ' +COALESCE(MiddleName,'')+ ' ' +COALESCE(LastName,'')
from  #Persons
--online
-- 包含具有非空参数的 ISNULL 的表达式将视为 NOT NULL，而包含具有非空参数的 COALESCE 的表达式将视为 NULL 在 SQL Server 中，若要对包含具有非空参数的 COALESCE 的表达式创建索引，可以使用 PERSISTED 列属性将计算列持久化，如以下语句所示：
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
--在emp表中给comm列为空的人员设为200
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
insert into t_meiyong values('黄海')
insert into t_meiyong values('卑劣的街头')
insert into t_meiyong values('追击者')
insert into t_meiyong values('漂流欲室')
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
--查询重复数据
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
--重复的只取一条
select  * from t_meiyong where id in(
	select min(id) from t_meiyong group by se_id,sp_id
)
--SQL Server获取重复数据(只有重复数据)的方法：
--1.获取重复的数据的值 2.SQL Server获取重复数据的记录
select  * from t_meiyong where sp_id in
(
select  sp_id  from t_meiyong 
group by sp_id 
having(COUNT (*)>1)
)
--获取多余的重复数据(只有不重复数据)
select * from t_meiyong where sp_id not in
(
	select MAX (sp_id) from t_meiyong
	group  by sp_id
	having(COUNT(*)>1)
)	
--重复的数据可能有这样两种情况，第一种时表中只有某些字段一样，第二种是两行记录完全一样。
select se_id ,sp_id  from t_meiyong group by  se_id ,sp_id having COUNT (*)>1
--我写的
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
insert into t_meiyong values('谁是大哥','不知道','aa','bb')
insert into t_meiyong values('我是哥哥','我是哥哥','q','ma')
insert into t_meiyong values('你是大哥','什么','f','gh')
insert into t_meiyong values('我是哥哥','我是哥哥','k','as')
insert into t_meiyong values('不知道','XX','嘻嘻嘻','嘻嘻嘻')

select * from t_meiyong
--张宇写的
select * from t_meiyong where se_id in (
select se_id   from t_meiyong  group by se_id,sp_id having (COUNT(*)>1))
and sp_id in(
select sp_id   from t_meiyong  group by se_id,sp_id having (COUNT(*)>1))
--sqlserver 语句如何修改表中字段的名字
EXEC sp_rename '表名.[原列名]', '新列名', 'column' 
--如何用sql语句将某列设为主键  http://zhidao.baidu.com/link?url=mzv9buI0pZUCeSXbQwXp31Cskv4ucXTwC7mvyzh7uB2rj1fx9VmfCPabsB2SY2KEfowqBJeL0RkEocOrr8Hms_
alter table 表名 add constraint PK_主键约束 primary key （lie）
--row_number() over
create table #meiyong
(
	empid int primary key identity(1,1),
	deptid int not null,
	salary decimal(18,2) not null,
	rank int not null  --工资等级
	
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
insert into  #meiyong values('周杰伦结婚了','小狗崽','结婚地点在比利时 时间持续6小时','结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人',null)
insert into  #meiyong values('韩寒结婚了','小狗崽','结婚地点在上海 时间持续6小时','结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人',null)
insert into  #meiyong values('郭敬明结婚了','小狗崽','结婚地点在上海 时间持续6小时','结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人结婚来了很多人',null)
insert into  #meiyong values('郭敬明结婚了','小狗崽','结婚地点在上海 时间持续6小时','结婚好',null)
insert into  #meiyong values('杨幂结婚了','小狗崽','结婚地点在北京','对象是谁',null)
insert into  #meiyong values('杨幂结婚了','小狗崽','结婚地点在北京','对象是谁',null)
insert into  #meiyong values('杨幂结婚了','小狗崽','结婚地点在北京','对象是谁',null)
insert into  #meiyong values('杨幂结婚了','小狗崽','结婚地点在北京','对象是谁',null)
insert into  #meiyong values('原子弹诞生了','小圆眼','好的','好好好好好好',null)
insert into  #meiyong values('原子弹诞生了','小圆眼','好的','好好好好好好',null)
insert into  #meiyong values('原子弹诞生了','小圆眼','好的','好好好好好好',null)
insert into  #meiyong values('原子弹诞生了','小圆眼','好的','好好好好好好',null)
insert into  #meiyong values('马云儿子留学归来','小云云','有钱','有钱有钱有钱有钱',null)

select *from #meiyong
--方法1：
SELECT TOP 5 *     -- 5是 页大小
FROM #meiyong
WHERE news_id NOT IN
          (
          SELECT TOP (5*(3-1)) news_id FROM #meiyong ORDER BY news_id    --3是页数 
          )
ORDER BY news_id
--方法2：	
SELECT TOP 5 *  -- 5是 页大小
FROM #meiyong
WHERE news_id >
          (
          SELECT ISNULL(MAX(news_id),0) 
          FROM 
                (
                SELECT TOP (5*(3-1)) news_id FROM #meiyong ORDER BY news_id --3是页数 
                ) A
          )
ORDER BY news_id
--方法3：
SELECT TOP 5 *  -- 5是 页大小
FROM 
        (
        SELECT ROW_NUMBER() OVER (ORDER BY news_id) AS RowNumber,* FROM #meiyong
        ) A
WHERE RowNumber > 5*(3-1)  --3是页数 

select  top 10 * (select row_number()over (order by SubHealthItemCode)as  RowNumber, SubHealthItemCode,SubHealthItemName from   Gy_SubHealthItemSet where  SubHealthCode='SH1001 ' and NoTakeFlag=0) A where RowNumber > 10*(2-1)
--http://zhidao.baidu.com/link?url=LKJbLy_MoRpSqzaNiWUIpV-feX42pRx30B4BhAEZJRz7rmVzjKidGhFf6o-nSfP5ef7piS2LpVJ3DjOKujQMWq
--如何自增列从001开始
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
--如何把sql里某一列的值全部用逗号拼接起来 http://zhidao.baidu.com/link?url=zDr5kKj6Yb2alg3LEpcUbGuBuvXhyNHYmSqFOt6KDSJoOilvO3bzr_IDO5yWjaWi0i3sAl1_O2iq58COU1oD-lsPB7t_aAX1fzWdk9aCdz7
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
--for xml path的巧用
select 'T1' M, stuff((select ',' + CAST(T1 as varchar) from #Table_1 for xml path('')),1,1,'') N
union
select 'T2' M, stuff((select ',' + CAST(T2 as varchar) from #Table_2 for xml path('')),1,1,'') N
--SQL STUFF函数 拼接字符串  http://www.cnblogs.com/yongheng178/archive/2012/06/27/2565631.html       tony_cheung@tcmworld.com
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
alter PROCEDURE sp_meiyong   --给t_meiyong循环赋值
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
SELECT  COUNT(*)                                -- 查询结果是200
FROM    ( SELECT    *
          FROM      t_meiyong
          UNION
          SELECT    *
          FROM      t_meiyong1
        ) AS T;
-- http://www.cnblogs.com/lyhabc/p/4176269.html  加法去重 union 运算符排除重复的，但是有bug，在某些情形下不能简单表示结果集一致，相当于无效
select * from t_meiyong
select * from t_meiyong1

INSERT INTO t_meiyong( [id],[log_time] ) VALUES(1,''),(3,''),(4,'')
INSERT INTO t_meiyong1( [id],[log_time] )VALUES(1,''),(2,''),(3,'')

select * from t_meiyong
select * from t_meiyong1



SELECT  COUNT(*)                              -- 查询结果是4 
FROM    ( SELECT    *
          FROM      t_meiyong
          UNION
          SELECT    *
          FROM     t_meiyong1
        ) AS T;
--  方法三：EXCEPT  减法归零
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
--  方法四：用全表INNER JOIN，这个也是最烂的做法，当然这里指的是在表记录数超级多的情况下
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
                                    AND [b].[log_time] = [a].[log_time] --如果表中还有其他字段的自行添加
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
-- SQL Server 游标语句 声明/打开/循环实例  http://www.jb51.net/article/36052.htm
create table #a 
( 
id varchar(20), 
name varchar(20) 
) 
insert into #a select 1,'jack' 
insert into #a select 2,'join' 
insert into #a select 3,'make' 
select * from  #a

declare mycursor cursor --声明一个游标  定义一个叫MyCursor的游标，存放for select 后的数据  
for select * from #a 
open mycursor   --打开一个游标  即打开这个数据集 
declare @id varchar(20),@name varchar(20)   
fetch next from mycursor into @id,@name  -- 移动游标指向到第一条数据，提取第一条数据存放在变量中  
while @@fetch_status=0    -- 如果上一次操作成功则继续循环 
begin 
select @id,@name 
fetch next from mycursor into @id,@name   --继续提下一行 
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
    
--添加测试数据
    Insert into t_meiyong values(1,'男',20)
    Insert into t_meiyong values(2,'女',22)
    Insert into t_meiyong values(3,'男',23)
    Insert into t_meiyong values(4,'男',22)
    Insert into t_meiyong values(1,'男',24)
    Insert into t_meiyong values(2,'女',19)
    Insert into t_meiyong values(4,'男',26)
    Insert into t_meiyong values(1,'男',24)
    Insert into t_meiyong values(1,'男',20)
    Insert into t_meiyong values(2,'女',22)
    Insert into t_meiyong values(3,'男',23)
    Insert into t_meiyong values(4,'男',22)
    Insert into t_meiyong values(1,'男',24)
    Insert into t_meiyong values(2,'女',19)
    select * from t_meiyong
    
    select COUNT(*)as '>20岁人数',classid  from t_meiyong where sex='男' group by classid,age having age>20 
-- 小猛问题
drop table t_meiyong
create table t_meiyong
(
 n1 nvarchar(20) not null,
 n2 nvarchar(20) not null,
 i1 int ,
 i2 int 
)
insert into t_meiyong values('河北邯郸','湖北荆州',2,45)
insert into t_meiyong values('湖南长沙','湖南张家界',9,45)
insert into t_meiyong values('湖北荆州','湖北武汉',null,45)
insert into t_meiyong values('河北邯郸','湖北荆州',2,65)
insert into t_meiyong values('河北邯郸','湖北荆州',2,45)
insert into t_meiyong values('湖北荆州','荆州沙市',9,32)
insert into t_meiyong values('湖北荆门','湖北荆州',2,45)
insert into t_meiyong values('湖北武汉','湖北荆门',88,32)
insert into t_meiyong values('湖南张家界','湖南湘潭',7,22)
insert into t_meiyong values('湖北武汉','湖北黄石',null,44)
--
 drop proc  sp_meiyong
alter proc sp_meiyong
as
declare @i1 int 
set @i1=(select top 1 a.i1 from t_meiyong a left join t_meiyong b
on a.n1=b.n2 where a.i1 is not null  and a.n1='湖北荆州')
update t_meiyong set i2=@i1 where n2='湖北荆州'
-- 循环怎么写 未完  http://jingyan.baidu.com/article/a681b0decb014b3b1843463d.html
drop table t_meiyong
create table t_meiyong
(
	code int primary key identity(1,1),
	salary int ,
	city  nvarchar(20)
)
insert into t_meiyong values(8000,'北京')
insert into t_meiyong values(8200,'上海')
insert into t_meiyong values(5500,'武汉')
insert into t_meiyong values(6100,'天津')
insert into t_meiyong values(6300,'神农架')
--  这里ID是主键 不考虑id相同而name 和age 不同的问题 已经 name age 为null的问题 http://blog.csdn.net/windren06/article/details/8188136
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
insert into t_meiyong values(1,'徐益涛',22)
insert into t_meiyong values(3,'程冠希',33)
insert into t_meiyong values(4,'霍建华',35)
insert into t_meiyong values(5,'林心如',34)
insert into t_meiyong values(7,'东永裴',28)

insert into t_meiyong1 values(1,'徐益涛',22)
insert into t_meiyong1 values(2,'成龙',56)
insert into t_meiyong1 values(4,'霍建华',35)
insert into t_meiyong1 values(5,'胡歌',31)
insert into t_meiyong1 values(6,'林心如',34)
select * from  t_meiyong
select * from  t_meiyong1

-- 使用 not in ,容易理解,效率低  
select  * from t_meiyong A where A.ID not in(select ID from t_meiyong1 )
-- 使用 left join...on... , "B.ID isnull" 表示左连接之后在B.ID 字段为 null的记录
select t_meiyong.ID from t_meiyong left join t_meiyong1 on t_meiyong.ID=t_meiyong1.ID where t_meiyong1.ID is null
-- 逻辑相对复杂,但是速度最快  
select * from t_meiyong
where (select count(1) as num from t_meiyong1 where t_meiyong1.ID = t_meiyong.ID) = 0

select * from MedicalCareERP.dbo.Gy_WesternMedicine A
where A.WesternMedicineCode not in(select WesternMedicineCode  from  Gy_WesternMedicine )

select  *  from MedicalCareERP.dbo.Gy_KFMedMain A where A.WesternMedicineCode not  in
( select WesternMedicineCode  from Gy_WesternMedicine  )

--
--我插入的 
select * from Gy_WesternMedicine where WesternMedicineCode  in('I64.X04 ','E14.901','R33.X01','I49.804 ','M54.561  ','K29.502 ','zzxy32 ','I00.X02','zzxy33 ','J42.X02','R16.201')
-- 本来就有的
select 
 A.WesternMedicineCode,A.WesternMedicineName,B.WesternMedicineCode
 from (
select * from Gy_WesternMedicine where WesternMedicineCode in ('R33.X01','M54.561','K29.502','I00.X02','J42.X02')
)A left join GXMedicalCareERP.dbo.Gy_WesternMedicine B on B.WesternMedicineName=A.WesternMedicineName
--  SqlServer中截取小数位数 http://zhidao.baidu.com/link?url=xtrPrj1VkgT5kpzIdIr7_aQB6GloIhHDmSPwbEtBayC3hDlkEc86V5Yq0BKrmENIuz7E6miettJztZWIlM6bwp6WyOE1-VvGSb9FWafeHd7
select cast(1234.9678 as int)
-- 
                                                     						