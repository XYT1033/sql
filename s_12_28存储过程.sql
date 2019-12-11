-- CM_Sp_InsertDiseaseOrPulseOrTongueSub	病人信息基本表中插入问诊记录各项子表
CREATE PROCEDURE [dbo].[CM_Sp_InsertDiseaseOrPulseOrTongueSub]
	@EmpBasicMainID int,   --病人基本信息单号
	@DiseaseCode char(1000) = '', --问诊记录兼症子表
	@TongueCode char(1000) = '', --问诊记录舌像子表
	@PulseCode char(1000) = ''--问诊记录脉像子表
as

	delete from CM_DiseaseSub where EmpBasicMainID=@EmpBasicMainID
	delete from CM_TongueSub where EmpBasicMainID =@EmpBasicMainID
	delete from CM_PulseSub  where EmpBasicMainID =@EmpBasicMainID
	
	if isnull(@DiseaseCode,'')<>'' 
	begin
		insert into CM_DiseaseSub(EmpBasicMainID,DiseaseCode) 
		select @EmpBasicMainID,code from Gy_Fun_ReturnRecordset(@DiseaseCode)	
	end
	
	if isnull(@TongueCode,'')<>'' 
	begin
		insert into CM_TongueSub(EmpBasicMainID,TongueCode) 
		select @EmpBasicMainID,Code from Gy_Fun_ReturnRecordset(@TongueCode)	
	end	
	if isnull(@PulseCode,'')<>'' 
	begin
		insert into CM_PulseSub(EmpBasicMainID,PulseCode) 
		select @EmpBasicMainID,code from Gy_Fun_ReturnRecordset(@PulseCode)	
	end	
--
exec CM_Sp_InsertDiseaseOrPulseOrTongueSub @EmpBasicMainID=12163,@DiseaseCode='11086,12609,13125,14130,14705,15429',@TongueCode='10371',@PulseCode='10371'	
--Gy_Fun_ReturnRecordset
CREATE FUNCTION [dbo].[Gy_Fun_ReturnRecordset] (@String char(2000)) 
returns @ReturnTable table(Code varchar(2000)) as 
begin 
declare @stringTemp char(500) 
while charindex(',',@String,1)<>0 
begin 
set @stringTemp=substring(@String,1,charindex(',',@String,1)-1) 
Insert @ReturnTable Values(@stringTemp) 
set @String=substring(@String,charindex(',',@String,1)+1,len(@String)) 
end 
if len(@String)<>0 Insert @ReturnTable values(@String) 
return 
END	
--charindex sql  得到的不是角标 而是个数           CHARINDEX ( expression1 ,expression2 [ , start_location ] ) 
第一个例子，假设你要显示 t_meiyong 表前5行联系人列的Last Name。这是前5行数据
          create table t_meiyong
		(
			ContactName varchar(100)
		)
insert into t_meiyong
select 'Maria Anders' union
select 'Ana Trujillo' union
select 'Antonio Moreno' union
select 'Thomas Hardy' union
select 'Christina Berglund'
      你可以看到，CustomName包含客户的First Name和Last Name，它们之间被一个空格隔开。我用CHARINDX函数确定两个名字中间空格的位置。通过这个方法，我们可以分析ContactName列的空格位置，这样我们可以只显示这个列的last name部分。这是显示Northwind的Customer表前5行last name的记录！
               select top 5 substring(ContactName,charindex(’ ’,ContactName)+1 ,
                      len(ContactName)) as [Last Name] from dbo.t_meiyong
下面是这个命令输出的结果。
           Last Name
           ------------------------------ 
           Anders
           Trujillo
           Moreno
           Hardy
           Berglund
	   
--sqlserver substring的用法   得到的不是角标 而是个数
substring('98765',-1,3) 结果：9 
substring('98765',0,3) 结果：98 
substring('98765',1,3) 结果：987 
-- Gy_Fun_ReturnColumnSet 
create FUNCTION [dbo].[Gy_Fun_ReturnColumnSet] (@String char(1000)) 
returns @ReturnTable table(Code varchar(100),Code2 varchar(100)) as 
begin 
declare @stringTemp char(100) 
while charindex('|',@String,1)<>0 
begin 
set @stringTemp=substring(@String,1,charindex('|',@String,1)-1) 
set @String=substring(@String,charindex('|',@String,1)+1,len(@String))
Insert @ReturnTable (code,code2) Values(@stringTemp,@String) 
 
end 

return 
END

--
select A.selTongue,A.TongueCode,Gy_Tongue.TongueName,Gy_Tongue.TongueImage 
from (
select case when CM_TongueSub.TongueCode= Gy_MainTongue.TongueCode then 1 else 0 end as selTongue,
Gy_MainTongue.TongueCode 
from Gy_MainTongue left join CM_TongueSub on CM_TongueSub.TongueCode=Gy_MainTongue.TongueCode and CM_TongueSub.EmpBasicMainID=12074
where Gy_MainTongue.MainSymptomCode=10438) 
A left join Gy_Tongue on Gy_Tongue.TongueCode=A.TongueCode order by A.selTongue desc,Gy_Tongue.TongueName

--CM_Sp_DialecticalZJOne 功能描述:辩证论治    编写人  :lijianwei
CREATE PROCEDURE [dbo].[CM_Sp_DialecticalZJOne]
@EmpBasicMainID int,--病人ID
@OperationType int, --1辩证论治、2直接开方
@DialecticalCode char(20)=null,--症型编码
@CureCode char(20)=null--治则编码
as
 
declare @MainSymptomCode char(20) --主症编码
select @MainSymptomCode=MainSymptomCode 
from CM_EmpBasicMain
where EmpBasicMainID=@EmpBasicMainID
 
if exists (select * from tempdb.dbo.sysobjects where [name] ='#OutTemp')   
                       drop table [dbo].[#OutTemp]
create table #OutTemp
( DialecticalCode char(20),
DialecticalName nvarchar(200),
CureCode char(20)	,
CureName nvarchar(200),
PrescriptionCode char(20),
PrescriptionName nvarchar(50),
Score decimal(20,2),--分数
SubID int--排名
)
if @OperationType=1
begin
delete from CM_InterrogationSub where EmpBasicMainID=@EmpBasicMainID
insert into CM_InterrogationSub(EmpBasicMainID,DiseaseCode,WeightValue,DialecticalCode,PulseCode,TongueCode)
select CM_DiseaseSub.EmpBasicMainID,CM_DiseaseSub.DiseaseCode,WeightValue,DialecticalCode,null,null
from Gy_DiseaseOrDialectical inner join 
CM_DiseaseSub  on CM_DiseaseSub.DiseaseCode=Gy_DiseaseOrDialectical.DiseaseCode 
where Gy_DiseaseOrDialectical.MainSymptomCode=@MainSymptomCode and EmpBasicMainID=@EmpBasicMainID
insert into CM_InterrogationSub(EmpBasicMainID,DiseaseCode,WeightValue,DialecticalCode,PulseCode,TongueCode)
select CM_TongueSub.EmpBasicMainID,null,WeightValue,DialecticalCode,null,CM_TongueSub.TongueCode
from Gy_DiseaseOrDialectical inner join 
CM_TongueSub  on CM_TongueSub.TongueCode=Gy_DiseaseOrDialectical.TongueCode 
where Gy_DiseaseOrDialectical.MainSymptomCode=@MainSymptomCode and CM_TongueSub.EmpBasicMainID=@EmpBasicMainID
insert into CM_InterrogationSub(EmpBasicMainID,DiseaseCode,WeightValue,DialecticalCode,PulseCode,TongueCode)
select CM_PulseSub.EmpBasicMainID,null,WeightValue,DialecticalCode,CM_PulseSub.PulseCode,null
from Gy_DiseaseOrDialectical inner join 
CM_PulseSub  on CM_PulseSub.PulseCode=Gy_DiseaseOrDialectical.PulseCode 
where Gy_DiseaseOrDialectical.MainSymptomCode=@MainSymptomCode and CM_PulseSub.EmpBasicMainID=@EmpBasicMainID
 
insert into #OutTemp(DialecticalCode,DialecticalName,CureCode,CureName,PrescriptionCode,PrescriptionName,Score,SubID) 
select Gy_Dialectical.DialecticalCode,Gy_Dialectical.DialecticalName,Gy_Cure.CureCode,Gy_Cure.CureName,
Gy_PrescriptionMain.PrescriptionCode,Gy_PrescriptionMain.PrescriptionName,Score,
SubID 
from ( 
select AA.DialecticalCode,AA.MainSymptomCode, sum(ISNULL(CC.RowCountValue,0)) as Score,
  row_number() over (order by sum(ISNULL(CC.RowCountValue,0)) desc) as SubID 
from 
(select Gy_DiseaseOrDialectical.DialecticalCode,Gy_DiseaseOrDialectical.MainSymptomCode from Gy_DiseaseOrDialectical left outer join 
(select DiseaseCode from CM_DiseaseSub where EmpBasicMainID=@EmpBasicMainID) A on A.DiseaseCode=Gy_DiseaseOrDialectical.DiseaseCode
where A.DiseaseCode is not null and Gy_DiseaseOrDialectical.MainSymptomCode=@MainSymptomCode 
group by Gy_DiseaseOrDialectical.MainSymptomCode,Gy_DiseaseOrDialectical.DialecticalCode ) AA inner join 
(select Gy_DiseaseOrDialectical.DialecticalCode,Count(*) as RowCountValue  from Gy_DiseaseOrDialectical 
group by Gy_DiseaseOrDialectical.DialecticalCode) CC on CC.DialecticalCode=AA.DialecticalCode 
group by AA.MainSymptomCode, AA.DialecticalCode ) E inner  join
Gy_CureDialectical on E.DialecticalCode=Gy_CureDialectical.DialecticalCode and E.MainSymptomCode=Gy_CureDialectical.MainSymptomCode  inner  join
Gy_PrescriptionMain on ISNULL(Gy_CureDialectical.ZJPrescriptionCode,'')=Gy_PrescriptionMain.PrescriptionCode and DrugFlag=1 left  join
Gy_Dialectical on Gy_CureDialectical.DialecticalCode=Gy_Dialectical.DialecticalCode left outer join
Gy_Cure on Gy_CureDialectical.CureCode=Gy_Cure.CureCode 
end
if @OperationType=2 
begin
--直接筛选出对应的方剂
if ISNULL(@MainSymptomCode,'')<>''
begin
insert into #OutTemp(DialecticalCode,DialecticalName,CureCode,CureName,PrescriptionCode,PrescriptionName,Score,SubID) 
select Gy_Dialectical.DialecticalCode,Gy_Dialectical.DialecticalName,Gy_Cure.CureCode,Gy_Cure.CureName,
Gy_PrescriptionMain.PrescriptionCode,Gy_PrescriptionMain.PrescriptionName,100, 1 
from 
Gy_CureDialectical left outer join
Gy_PrescriptionMain on ISNULL(Gy_CureDialectical.ZJPrescriptionCode,'')=Gy_PrescriptionMain.PrescriptionCode left outer join
Gy_Dialectical on Gy_CureDialectical.DialecticalCode=Gy_Dialectical.DialecticalCode left outer join
Gy_Cure on Gy_CureDialectical.CureCode=Gy_Cure.CureCode 
where Gy_CureDialectical.DialecticalCode=@DialecticalCode and Gy_CureDialectical.CureCode=@CureCode
and Gy_CureDialectical.MainSymptomCode=@MainSymptomCode and Gy_PrescriptionMain.DrugFlag=1
end  
else
begin
   insert into #OutTemp(DialecticalCode,DialecticalName,CureCode,CureName,PrescriptionCode,PrescriptionName,Score,SubID) 
select distinct Gy_Dialectical.DialecticalCode,Gy_Dialectical.DialecticalName,Gy_Cure.CureCode,Gy_Cure.CureName,
Gy_PrescriptionMain.PrescriptionCode,Gy_PrescriptionMain.PrescriptionName,100, 1 
from 
Gy_CureDialectical left outer join
Gy_PrescriptionMain on ISNULL(Gy_CureDialectical.ZJPrescriptionCode,'')=Gy_PrescriptionMain.PrescriptionCode and Gy_PrescriptionMain.DrugFlag=1 left outer join
Gy_Dialectical on Gy_CureDialectical.DialecticalCode=Gy_Dialectical.DialecticalCode left outer join
Gy_Cure on Gy_CureDialectical.CureCode=Gy_Cure.CureCode 
where Gy_CureDialectical.DialecticalCode=@DialecticalCode and Gy_CureDialectical.CureCode=@CureCode  and Gy_PrescriptionMain.DrugFlag=1   
end
end
 
     -- 2966226013
    --delete from CM_ProLunZhiResult 
    
    --insert into CM_ProLunZhiResult(DialecticalCode,DialecticalName,CureCode,CureName,PrescriptionCode,
    --PrescriptionName,Score,SubID,ChineseMedicineCode,ChineseMedicineName)
    declare	@ChineseMedicineCode	char(20),
			@ChineseMedicineName	varchar(400)
    select @ChineseMedicineCode=Gy_ChineseMedicine.ChineseMedicineCode,
			@ChineseMedicineName=ChineseMedicineName 
	from Gy_MainSymptom inner join Gy_ChineseMedicine 
    on  Gy_MainSymptom.ChineseMedicineCode=Gy_ChineseMedicine.ChineseMedicineCode 
    where MainSymptomCode=@MainSymptomCode
    
 select AA.DialecticalCode,AA.DialecticalName,AA.CureCode,AA.CureName, AA.PrescriptionCode,AA.PrescriptionName,AA.Score,
            (case when AA.SubID=1 then '首选'
              when AA.SubID=2 then '次选'
              when AA.SubID=3 then '三选'
              when AA.SubID=4 then '四选'
              when AA.SubID=5 then '五选'
              when AA.SubID=6 then '六选'
              when AA.SubID=7 then '七选'
              when AA.SubID=8 then '八选'
              else '九选' end ) as SubID,
              
              isnull(@ChineseMedicineCode,'') as ChineseMedicineCode,isnull(@ChineseMedicineName,'') as ChineseMedicineName,
              (select top 1 WesternMedicineCode from Gy_DialectcalWesternMedicine A where A.MainSymptomCode=@MainSymptomCode
														 and A.DialecticalCode=AA.DialecticalCode order by WesternMedicineCode)
		as WesternMedicineCode,		
           (select top 1 Gy_WesternMedicine.WesternMedicineName from  Gy_DialectcalWesternMedicine A
	left join Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=A.WesternMedicineCode  where A.MainSymptomCode=@MainSymptomCode
														 and A.DialecticalCode=AA.DialecticalCode order by A.WesternMedicineCode)
		as WesternMedicineName
    from (
    select top 5 #OutTemp.DialecticalCode,#OutTemp.DialecticalName,#OutTemp.CureCode,#OutTemp.CureName,
        #OutTemp.PrescriptionCode,#OutTemp.PrescriptionName,#OutTemp.Score,row_number() over (order by ISNULL(#OutTemp.Score,0) desc) as SubID
        
   from #OutTemp
			    
    where #OutTemp.Score is not null 
    group by #OutTemp.DialecticalCode,#OutTemp.DialecticalName,#OutTemp.CureCode,#OutTemp.CureName,#OutTemp.PrescriptionCode,#OutTemp.PrescriptionName,#OutTemp.Score ) AA
    
    
    order by AA.SubID
--

--CM_Fun_GetFangJiZJValueOne
CREATE FUNCTION [dbo].[CM_Fun_GetFangJiZJValueOne]
(
@RegistrationNum char(20)='',
@DrugFlag int=0
)
returns varchar(8000)  
as
begin
  declare @ReturnValue varchar(8000)
  declare @ReturnValue1 varchar(8000)
  declare @ReturnValue2 varchar(8000)
  declare @ReturnValueZJ varchar(8000)
  declare @ReturnValueStr varchar(8000)
  declare @WesternValue  varchar(8000)
  declare @CheckValue varchar(8000)
  declare @CheckValueOne varchar(8000)
  set @ReturnValue=''
  set @ReturnValue1=''
  set @ReturnValue2=''
  set @ReturnValueZJ=''
  set @WesternValue=''
  set @CheckValue='' 
  set @CheckValueOne=''
  declare @EmpBasicMainID int=0
  
select @EmpBasicMainID=EmpBasicMainID from CM_EmpBasicMain where RegistrationNum=rtrim(@RegistrationNum)

select @ReturnValue=case when ltrim(rtrim(@ReturnValue))<>'' 
then ltrim(rtrim(@ReturnValue))+' ' else '' end 
+ rtrim(convert(varchar(50),ISNULL(Gy_DrugDict.DrugName,'')))+' '
+case when rtrim(SUBSTRING(RTRIM(CM_FangJiDetailSub.Quanitity),len(RTRIM(CM_FangJiDetailSub.Quanitity))-charindex('.',REVERSE(cast(rtrim(CM_FangJiDetailSub.Quanitity) as varchar(50))))+4,1))<>'' and 
      Convert(decimal(18,0),SUBSTRING(RTRIM(CM_FangJiDetailSub.Quanitity),len(RTRIM(CM_FangJiDetailSub.Quanitity))-charindex('.',REVERSE(cast(rtrim(CM_FangJiDetailSub.Quanitity) as varchar(50))))+4,1))>0
      then rtrim(convert(varchar(50),Convert(decimal(18,3),ISNULL(CM_FangJiDetailSub.Quanitity,0))))+ISNULL('g','')+' ' 
      when Convert(decimal(18,0),SUBSTRING(RTRIM(CM_FangJiDetailSub.Quanitity),len(RTRIM(CM_FangJiDetailSub.Quanitity))-charindex('.',REVERSE(cast(rtrim(CM_FangJiDetailSub.Quanitity) as varchar(50))))+3,1))>0
      then rtrim(convert(varchar(50),Convert(decimal(18,2),ISNULL(CM_FangJiDetailSub.Quanitity,0))))+ISNULL('g','')+' ' 
      when Convert(decimal(18,0),SUBSTRING(RTRIM(CM_FangJiDetailSub.Quanitity),len(RTRIM(CM_FangJiDetailSub.Quanitity))-charindex('.',REVERSE(cast(rtrim(CM_FangJiDetailSub.Quanitity) as varchar(50))))+2,1))>0
      then rtrim(convert(varchar(50),Convert(decimal(18,1),ISNULL(CM_FangJiDetailSub.Quanitity,0))))+ISNULL('g','')+' '  
      else rtrim(convert(varchar(50),Convert(decimal(18,0),ISNULL(CM_FangJiDetailSub.Quanitity,0))))+ISNULL('g','')+' ' end  
+ rtrim(convert(varchar(50),ISNULL(Gy_SufferType.SufferTypeName,'')))  
+ (case when rtrim(convert(varchar(50),ISNULL(CM_FangJiDetailSub.DetailMinutes,0)))<>0
  then rtrim(convert(varchar(50),ISNULL(CM_FangJiDetailSub.DetailMinutes,'')))+'分钟' else '' end)+' '
+ rtrim(convert(varchar(50),ISNULL(CM_FangJiDetailSub.Remark,'')))+' '   
from CM_FangJiDetailSub inner join  CM_FangJiSub on CM_FangJiSub.FangJiSubID =CM_FangJiDetailSub.FangJiSubID left outer join 
Gy_SufferType on CM_FangJiDetailSub.SufferTypeCode =Gy_SufferType.SufferTypeCode left outer join 
Gy_DrugDict on CM_FangJiDetailSub.DrugCode =Gy_DrugDict.DrugCode left join
Gy_Unit on Gy_Unit.UnitCode=Gy_DrugDict.Units where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=0 --and HISOrderNum=1

select @ReturnValueZJ=case when ltrim(rtrim(@ReturnValueZJ))<>'' 
then ltrim(rtrim(@ReturnValueZJ))+' ' else '' end 
+ rtrim(convert(varchar(50),ISNULL(Gy_DrugDict.DrugName,'')))+' ' 
from CM_FangJiDetailSub inner join  CM_FangJiSub on CM_FangJiSub.FangJiSubID =CM_FangJiDetailSub.FangJiSubID left outer join 
Gy_DrugDict on CM_FangJiDetailSub.DrugCode =Gy_DrugDict.DrugCode  where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=1  


	declare @SummaryCodeTemp char(10)
	declare @SubIDValue char(10)=''
	declare @CheckFlagstr int=0
	declare @CheckValuestr varchar(3000)=''
	declare @CheckValueOnestr varchar(3000)=''
	declare @WesternValuestr varchar(3000)=''
	declare @FangjiSubID int=0
	declare @i int=1
	declare RsO cursor for select CM_FangJiSub.FangJiSubID from CM_FangJiSub where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=2  
	open RsO
	fetch next from RsO into @FangjiSubID
	while @@fetch_status=0
	begin  
	    set @WesternValuestr=ltrim(rtrim('处方'+ltrim(rtrim(@i))+':'))
		select @WesternValuestr=case when ltrim(rtrim(@WesternValuestr))<>'' 
		then ltrim(rtrim(@WesternValuestr))+' ' else '' end 
		+ rtrim(convert(varchar(50),ISNULL(Gy_DrugDict.DrugName,'')))+' '+rtrim(convert(varchar(50),Ceiling(ISNULL(CM_FangJiDetailSub.Quanitity,0))))+''+ rtrim(ISNULL(Gy_Unit.UnitName,''))+' '   
		from CM_FangJiDetailSub inner join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID left join
		Gy_DrugDict on Gy_DrugDict.DrugCode=CM_FangJiDetailSub.DrugCode left join 
		Gy_Unit on Gy_Unit.UnitCode=Gy_DrugDict.PrescriptionUnit  where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=2 and CM_FangJiSub.FangjiSubID=@FangjiSubID 
	    set @WesternValue=@WesternValue+@WesternValuestr+char(13)+char(10)

	set @i=@i+1
    fetch next from RsO into @FangjiSubID
    end
    close RsO
    deallocate RsO

    set @i=1
	declare RsO cursor for select SubID,SummaryCode from (select  row_number() over (order by ISNULL(AA.SummaryCode,0) ASC) as SubID,AA.SummaryCode
                           from (select SummaryCode from CM_CheckSub where CM_CheckSub.EmpBasicMainID=@EmpBasicMainID and CM_CheckSub.CheckFlag=0  group by SummaryCode) AA ) cc 
	open RsO
	fetch next from RsO into @SubIDValue,@SummaryCodeTemp
	while @@fetch_status=0
	begin  
	   set @CheckValuestr=ltrim(rtrim('检查'+ltrim(rtrim(@SubIDValue))+':'))
       select @CheckValuestr=case when ltrim(rtrim(@CheckValuestr))<>'' 
       then ltrim(rtrim(@CheckValuestr))+' ' else '' end 
       + rtrim(convert(varchar(50),ISNULL(Gy_DetailItem.DetailItemName,'')))+' ' from CM_CheckSub inner join Gy_DetailItem on Gy_DetailItem.DetailItemCode=CM_CheckSub.DetailItemCode 
       where CM_CheckSub.EmpBasicMainID=@EmpBasicMainID and CM_CheckSub.CheckFlag=0 and CM_CheckSub.SummaryCode=@SummaryCodeTemp
	   set @CheckValue=@CheckValue+@CheckValuestr+char(13)+char(10)
	  
	set @i=@i+1
    fetch next from RsO into @SubIDValue,@SummaryCodeTemp
    end
    close RsO
    deallocate RsO
    
    set @i =1
	declare RsO cursor for select SubID,SummaryCode from (select  row_number() over (order by ISNULL(AA.SummaryCode,0) ASC) as SubID,AA.SummaryCode
                           from (select SummaryCode from CM_CheckSub where CM_CheckSub.EmpBasicMainID=@EmpBasicMainID and CM_CheckSub.CheckFlag=1  group by SummaryCode) AA ) cc 
	open RsO
	fetch next from RsO into @SubIDValue,@SummaryCodeTemp
	while @@fetch_status=0
	begin  
	    set @CheckValueOnestr=ltrim(rtrim('检验'+ltrim(rtrim(@SubIDValue))+':'))
	    select @CheckValueOnestr=case when ltrim(rtrim(@CheckValueOnestr))<>'' 
		then ltrim(rtrim(@CheckValueOnestr))+' ' else '' end 
		+ rtrim(convert(varchar(50),ISNULL(Gy_DetailItem.DetailItemName,'')))+' ' from CM_CheckSub inner join Gy_DetailItem on Gy_DetailItem.DetailItemCode=CM_CheckSub.DetailItemCode 
		where CM_CheckSub.EmpBasicMainID=@EmpBasicMainID and CM_CheckSub.CheckFlag=1 and CM_CheckSub.SummaryCode=@SummaryCodeTemp 
		set @CheckValueOne=@CheckValueOne+@CheckValueOnestr+char(13)+char(10)
	  
	set @i=@i+1
    fetch next from RsO into @SubIDValue,@SummaryCodeTemp
    end
    close RsO
    deallocate RsO

if ISNULL(@ReturnValue,'')<>'' and ISNULL(@ReturnValueZJ,'')=''
begin
 set @DrugFlag=0
end
else if ISNULL(@ReturnValue,'')='' and ISNULL(@ReturnValueZJ,'')<>''
begin
 set @DrugFlag=1
end
else 
begin
 set @DrugFlag=0
end


declare @strNeedleTime varchar(10)
select @strNeedleTime=CM_FangJiSub.ZJMinutes from CM_FangJiSub left join CM_EmpBasicMain on CM_EmpBasicMain.EmpBasicMainID=CM_FangJiSub.EmpBasicMainID
                                                where CM_FangJiSub.DrugFlag=1 and CM_EmpBasicMain.RegistrationNum=@RegistrationNum


select @ReturnValueStr=case when ltrim(rtrim(@ReturnValueStr))<>'' 
                       then ltrim(rtrim(@ReturnValueStr))+char(13)+char(10)  else '' end 
                       +'【主诉】'+rtrim(convert(varchar(2000),ISNULL(CM_EmpBasicMain.ChiefComplaint,'')))+char(13)+char(10)
                       +'【现病史】'+rtrim(convert(varchar(2000),ISNULL(CM_EmpBasicMain.HistoryPresent,'')))+char(13)+char(10)
                       +'【既往史】'+rtrim(convert(varchar(2000),ISNULL(CM_EmpBasicMain.HistoryPast,'')))+char(13)+char(10)
                       +'【过敏史】'+rtrim(convert(varchar(2000),ISNULL(CM_EmpBasicMain.HistoryAllergic,'')))+char(13)+char(10)
                       +'【体格检查】'
                       +case when ISNULL(CM_EmpBasicMain.TC,'')<>'' then 'T'+rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.TC,'')))+'℃'+'；' else '' end 
                       +case when ISNULL(CM_EmpBasicMain.PC,'')<>'' then 'P'+rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.PC,'')))+'次/分'+'；' else '' end 
                       +case when ISNULL(CM_EmpBasicMain.RC,'')<>'' then 'R'+rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.RC,'')))+'次/分'+'；' else '' end 
                       +case when ISNULL(CM_EmpBasicMain.BP,'')<>'' and ISNULL(CM_EmpBasicMain.BPOne,'')<>''  then +'BP'+rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.BP,'')))+'/'+
                                      rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.BPOne,'')))+'mmHg'+'；' else '' end 
                       +rtrim(convert(varchar(6000),ISNULL(CM_EmpBasicMain.PhysicalExamination,'')))+char(13)+char(10)
                       +'  主症:'+rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.MainSymptomName,'')))+char(13)+char(10)
                       +'  兼症:'+rtrim(convert(varchar(1000),ISNULL(CM_EmpBasicMain.DiseaseName,'')))+char(13)+char(10)
                       +'  舌象:'+rtrim(convert(varchar(1000),ISNULL(CM_EmpBasicMain.TongueName,'')))+char(13)+char(10)
                       +'  脉象:'+rtrim(convert(varchar(1000),ISNULL(CM_EmpBasicMain.PulseName,'')))+char(13)+char(10)
                       +'【中医病名】'+rtrim(convert(varchar(200),ISNULL(Gy_ChineseMedicine.ChineseMedicineName,'')))+char(13)+char(10)
                       +'【西医病名】'+rtrim(convert(varchar(200),ISNULL(Gy_WesternMedicine.WesternMedicineName,'')))+char(13)+char(10)
                       +'【证型】'+rtrim(convert(varchar(200),ISNULL(Gy_Dialectical.DialecticalName,'')))+char(13)+char(10)
                       +'【治法】'+rtrim(convert(varchar(200),ISNULL(Gy_Cure.CureName,'')))+char(13)+char(10)
                       +'【处方名称】'+rtrim(convert(varchar(200),ISNULL(CM_FangJiSub.FangJiSubName,'')))+char(13)+char(10)
                       +case when ISNULL(@ReturnValue,'')<>'' 
                             then '【中药组成】' + rtrim(convert(varchar(1000),ISNULL(@ReturnValue,'')))+char(13)+char(10)  else '' end              
                       +case when @DrugFlag=0 then '【用法】'+rtrim(convert(varchar(200),ISNULL(CM_FangJiSub.FangJiUsage,'')))+char(13)+char(10) else '' end 
                       +case when @DrugFlag=0 then '【付数】'+rtrim(convert(varchar(200),ISNULL(CM_FangJiSub.UsageCount,'')))+char(13)+char(10) else '' end
                       +case when @DrugFlag=0 then '【医嘱】'+rtrim(convert(varchar(200),ISNULL(CM_FangJiSub.Advice,'')))+char(13)+char(10) else '' end     
                       +case when ISNULL(@ReturnValueZJ,'')<>'' 
                             then '【穴位组成】' + rtrim(convert(varchar(1000),ISNULL(@ReturnValueZJ,'')))+char(13)+char(10) else '' end
                             
                       +case when ISNULL(@ReturnValueZJ,'')<>'' 
							 then '【留针时间】' + rtrim(convert(varchar(1000),ISNULL(@strNeedleTime,0))) +'分钟'+char(13)+char(10)+char(13)+char(10)  else '' end
                                  
                       +case when ISNULL(@WesternValue,'')<>''  
                             then '【西药组成】'+char(13)+char(10)+rtrim(convert(varchar(1000),ISNULL(@WesternValue,'')))+char(13)+char(10)+char(13)+char(10)  else '' end  
                       +case when ISNULL(@CheckValue,'')<>''  
                             then '【检查项目】'+char(13)+char(10)+rtrim(convert(varchar(1000),ISNULL(@CheckValue,'')))+char(13)+char(10)+char(13)+char(10)  else '' end 
                       +case when ISNULL(@CheckValueOne,'')<>''  
                             then '【检验项目】'+char(13)+char(10)+rtrim(convert(varchar(1000),ISNULL(@CheckValueOne,'')))+char(13)+char(10)+char(13)+char(10)  else '' end 
                       
                       +'【治疗评价】'+rtrim(convert(varchar(200),ISNULL(Gy_Evaluation.EvaluationName,'')))+char(13)+char(10)
                       +'【评价说明】'+rtrim(convert(varchar(200),ISNULL(CM_EmpBasicMain.EvaluationRemark,'')))+char(13)+char(10)
                       from CM_EmpBasicMain left join 
                       Gy_ChineseMedicine on Gy_ChineseMedicine.ChineseMedicineCode=CM_EmpBasicMain.ChineseMedicineCode left join 
                       Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=CM_EmpBasicMain.WesternMedicineCode left join 
                       Gy_Dialectical on Gy_Dialectical.DialecticalCode=CM_EmpBasicMain.DialecticalCode left join 
                       Gy_Cure on Gy_Cure.CureCode=CM_EmpBasicMain.CureCode left join 
                       CM_FangJiSub on CM_FangJiSub.EmpBasicMainID=CM_EmpBasicMain.EmpBasicMainID /*and CM_FangJiSub.HISOrderNum=1*/ and CM_FangJiSub.DrugFlag=@DrugFlag left join 
                       Gy_Evaluation on Gy_Evaluation.EvaluationCode=CM_EmpBasicMain.EvaluationCode 
                       where CM_EmpBasicMain.RegistrationNum=rtrim(@RegistrationNum) 
                       
                       
		
  return @ReturnValueStr
end
--
select dbo.CM_Fun_GetFangJiZJValueOne('201601130003',0) FangjiReturnValue
select dbo.CM_Fun_GetFangJiZJValueOne('201601190002',0) FangjiReturnValue  
--CM_V_FangJiSub
select EmpBasicMainID,FangJiSubName,DrugName,Quanitity,UsageCount,Advice,SufferTypeName,CM_FangJiSub.FangJiUsage 
		from CM_FangJiDetailSub inner join  CM_FangJiSub on CM_FangJiSub.FangJiSubID =CM_FangJiDetailSub.FangJiSubID
		left outer join Gy_SufferType on CM_FangJiDetailSub.SufferTypeCode =Gy_SufferType.SufferTypeCode
		left outer join Gy_DrugDict on CM_FangJiDetailSub.DrugCode =Gy_DrugDict.DrugCode	
--获取康复方案的主表信息
select CM_EMPKFMain.EmpBasicMainID,CM_EMPKFMain.EMPKFMainID,CM_EMPKFMain.WesternMdeicineCode,
		                                CM_EMPKFMain.ChineseMedicineCode,CM_EMPKFMain.DialecticalCode,CM_EMPKFMain.CureCode,
		                                CM_EMPKFMain.HExplain,CM_EMPKFMain.TExplain,CM_EMPKFMain.KFTarget,Gy_WesternMedicine.WesternMedicineName,
		                                Gy_ChineseMedicine.ChineseMedicineName,Gy_Dialectical.DialecticalName,Gy_Cure.CureName
                                from CM_EMPKFMain left join Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=CM_EMPKFMain.WesternMdeicineCode
				                                  left join Gy_ChineseMedicine on Gy_ChineseMedicine.ChineseMedicineCode=CM_EMPKFMain.ChineseMedicineCode
				                                  left join Gy_Dialectical on Gy_Dialectical.DialecticalCode=CM_EMPKFMain.DialecticalCode
				                                  left join Gy_Cure on Gy_Cure.CureCode=CM_EMPKFMain.CureCode where CM_EMPKFMain.EmpBasicMainID=12027	

															  
--CM_V_DrugByDrugCode
		select 	Gy_DrugDict.DrugCode,Gy_DrugDict.DrugName,Gy_DrugDict.PackageUnits,
				case when isnull(Gy_DrugDict.SingleMeasure,0)=0 then 0 else Gy_DrugDict.SingleMeasure end as SingleMeasure,	
				Gy_DrugDict.SingleMeasureUnit,A.UnitName as SingleMeasureUnitName,Gy_DrugDict.DrugWayCode,
				B.UnitName as TotalAmountUnitName,Gy_DrugDict.PrescriptionUnit,C.UnitName as PrescriptionUnitName,
				Gy_DrugDict.LPrice,0 as Coefficient,0 as UseDays,Gy_DrugDict.MeasurementCoefficient	
		from Gy_DrugDict left join Gy_Unit A on A.UnitCode=Gy_DrugDict.SingleMeasureUnit
						 left join Gy_Unit B on B.UnitCode=Gy_DrugDict.SingleMeasureUnit
						 left join Gy_Unit C on C.UnitCode=Gy_DrugDict.PrescriptionUnit 
-- 创建人：yuzhiyun */功能: 保存兼症与归经、主症的关系 */
create PROCEDURE [dbo].[Gy_Sp_DiseaseMeridianMain] 
	@DiseaseCode char(20)='',		  --兼症编码
	@DiseaseMeridian nvarchar(1000)='',  --兼症与归经的关系
	@DiseaseMainSymptom nvarchar(1000)='' --兼症与主症的关系
AS
	delete from Gy_DiseaseMeridian where DiseaseCode=@DiseaseCode
	delete from Gy_MainSymptomDisease where DiseaseCode=@DiseaseCode
	--插入新关系	
	--归经
	if isnull(@DiseaseMeridian,'')<>'' 
	begin	
		insert into Gy_DiseaseMeridian(DiseaseCode,MeridianCode)
		select @DiseaseCode,code from Gy_Fun_ReturnRecordset(@DiseaseMeridian)
	end
	--主症
	if ISNULL(@DiseaseMainSymptom,'') <> ''
	begin
		insert into Gy_MainSymptomDisease(MainSymptomCode,DiseaseCode) 
		select code,@DiseaseCode from Gy_Fun_ReturnRecordset(@DiseaseMainSymptom)
	end 						 
--
exec Gy_Sp_DiseaseMeridianMain @DiseaseCode='20000',@DiseaseMeridian='19,21,23,40,51',@DiseaseMainSymptom='10002,10003,10004'                	
--REVERSE  reverse 是把字符串倒置
drop  table t_meiyong
create table t_meiyong
(
	lujin varchar(30) not null
)
insert into t_meiyong values('large\020700\61970b0101.jpg')
select * from t_meiyong
--
要实现一个简单的业务： 使用SQL脚本获取字符串'large\020700\61970b0101.jpg' 中的'61970b0101.jpg'部分。先想到的是C#中的 lastindexof， 但是SQL中没有这个函数，只有 charindex 函数，只好使用现有资源想办法曲线解决了。	
解决思路：
1、使用 REVERSE 函数将字符串反转
2、使用 charindex 找到第一个出现'\'的位置
3、使用left函数找到'\'之前的字符串
4、再次使用REVERSE函数将处理过的字符串反转

具体示例：
DECLARE @Str VARCHAR(50)
SET @Str = 'large\020700\61970b0101.jpg'
SET @Str = REVERSE(@Str)
SET @Str = LEFT(@Str,CHARINDEX('\',@str,0)-1)
SET @Str = REVERSE(@Str)
SELECT @Str	

