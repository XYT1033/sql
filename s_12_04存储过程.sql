/*功能描述:辩证论治     编写人  :lijianwei
*/
CREATE PROCEDURE [dbo].[CM_Sp_Dialectical]
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
CureCode char(20),
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
select AA.DialecticalCode,AA.MainSymptomCode, cast(sum(isnull(AA.WeightValue,0))*100/sum(ISNULL(CC.WeightValue,0)) as decimal(20,2)) as Score,
row_number() over (order by cast(sum(isnull(AA.WeightValue,0))*100/sum(ISNULL(CC.WeightValue,0)) as decimal(20,2)) desc) as SubID 
from 
(select Gy_DiseaseOrDialectical.DialecticalCode,Gy_DiseaseOrDialectical.MainSymptomCode,sum(Gy_DiseaseOrDialectical.WeightValue) as  WeightValue 
from Gy_DiseaseOrDialectical left outer join 
(select DiseaseCode from CM_DiseaseSub where EmpBasicMainID=@EmpBasicMainID) A on A.DiseaseCode=Gy_DiseaseOrDialectical.DiseaseCode
where A.DiseaseCode is not null and Gy_DiseaseOrDialectical.MainSymptomCode=@MainSymptomCode 
group by Gy_DiseaseOrDialectical.MainSymptomCode,Gy_DiseaseOrDialectical.DialecticalCode ) AA inner join 
(select Gy_DiseaseOrDialectical.DialecticalCode,sum(ISNULL(Gy_DiseaseOrDialectical.WeightValue,0)) as WeightValue  from Gy_DiseaseOrDialectical 
group by Gy_DiseaseOrDialectical.DialecticalCode) CC on CC.DialecticalCode=AA.DialecticalCode 
where ISNULL(CC.WeightValue,0)<>0 
group by AA.MainSymptomCode, AA.DialecticalCode ) E inner join
Gy_CureDialectical on E.DialecticalCode=Gy_CureDialectical.DialecticalCode and E.MainSymptomCode=Gy_CureDialectical.MainSymptomCode left outer join
Gy_PrescriptionMain on Gy_CureDialectical.PrescriptionCode=Gy_PrescriptionMain.PrescriptionCode and Gy_PrescriptionMain.DrugFlag=0 left outer join
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
Gy_PrescriptionMain on Gy_CureDialectical.PrescriptionCode=Gy_PrescriptionMain.PrescriptionCode left outer join
Gy_Dialectical on Gy_CureDialectical.DialecticalCode=Gy_Dialectical.DialecticalCode left outer join
Gy_Cure on Gy_CureDialectical.CureCode=Gy_Cure.CureCode 
where Gy_CureDialectical.DialecticalCode=@DialecticalCode and Gy_CureDialectical.CureCode=@CureCode
and Gy_CureDialectical.MainSymptomCode=@MainSymptomCode and Gy_PrescriptionMain.DrugFlag=0 
end  
else
begin
   insert into #OutTemp(DialecticalCode,DialecticalName,CureCode,CureName,PrescriptionCode,PrescriptionName,Score,SubID) 
select distinct Gy_Dialectical.DialecticalCode,Gy_Dialectical.DialecticalName,Gy_Cure.CureCode,Gy_Cure.CureName,
Gy_PrescriptionMain.PrescriptionCode,Gy_PrescriptionMain.PrescriptionName,100, 1 
from 
Gy_CureDialectical left outer join
Gy_PrescriptionMain on Gy_CureDialectical.PrescriptionCode=Gy_PrescriptionMain.PrescriptionCode  left outer join
Gy_Dialectical on Gy_CureDialectical.DialecticalCode=Gy_Dialectical.DialecticalCode left outer join
Gy_Cure on Gy_CureDialectical.CureCode=Gy_Cure.CureCode 
where Gy_CureDialectical.DialecticalCode=@DialecticalCode and Gy_CureDialectical.CureCode=@CureCode  and Gy_PrescriptionMain.DrugFlag=0 
end
end
				
				declare	@ChineseMedicineCode	char(20),
						@ChineseMedicineName	varchar(200)
				--提取中医病名
				select @ChineseMedicineCode=Gy_MainSymptom.ChineseMedicineCode,
					   @ChineseMedicineName=Gy_ChineseMedicine.ChineseMedicineName 
				from Gy_MainSymptom  left join 
					  Gy_ChineseMedicine on Gy_ChineseMedicine.ChineseMedicineCode=Gy_MainSymptom.ChineseMedicineCode
				where  Gy_MainSymptom.MainSymptomCode=@MainSymptomCode
				
              --返回辨证后的结果
              select ChineseMedicineCode,
					 ChineseMedicineName,					 
                     CureCode,
                     CureName,
                     DialecticalCode,
                     DialecticalName,
                     PrescriptionCode,
                     PrescriptionName,
                     Score,
                     SubID,
                     WesternMedicineCode,
                     WesternMedicineName,
                     lishu,
                     case when ISNULL(lishu,0)<>0
                     then CONVERT(decimal(26,1),(haozhuang*100/lishu)) else '0.0' end  as haozhuang
              from (
              select top 5 @ChineseMedicineCode as ChineseMedicineCode,@ChineseMedicineName as ChineseMedicineName,
				   A.CureCode,A.CureName,A.DialecticalCode,A.DialecticalName,
				   A.PrescriptionCode,A.PrescriptionName,A.Score,
				  (case when A.SubID=1 then '首选'
				  when A.SubID=2 then '次选'
				  when A.SubID=3 then '三选'
				  when A.SubID=4 then '四选'
				  when A.SubID=5 then '五选'
				  when A.SubID=6 then '六选'
				  when A.SubID=7 then '七选'
				  when A.SubID=8 then '八选'
				  else '九选' end ) as SubID, 
				  (select top 1 Gy_DialectcalWesternMedicine.WesternMedicineCode from Gy_DialectcalWesternMedicine where 
					Gy_DialectcalWesternMedicine.MainSymptomCode=@MainSymptomCode and Gy_DialectcalWesternMedicine.DialecticalCode=A.DialecticalCode order by Gy_DialectcalWesternMedicine.DialecticalCode  ) as WesternMedicineCode,
				  (select top 1 Gy_WesternMedicine.WesternMedicineName from Gy_DialectcalWesternMedicine inner join 
				  Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=Gy_DialectcalWesternMedicine.WesternMedicineCode where 
				Gy_DialectcalWesternMedicine.MainSymptomCode=@MainSymptomCode and Gy_DialectcalWesternMedicine.DialecticalCode=A.DialecticalCode order by Gy_DialectcalWesternMedicine.DialecticalCode  ) as  WesternMedicineName, 
                (select COUNT(*) as RowNumFangJi from CM_FangJiSub inner join 
                (select * from CM_EmpBasicMain where EvaluationCode in ('10001','10002','10003')) AA 
                on AA.EmpBasicMainID=CM_FangJiSub.EmpBasicMainID and CM_FangJiSub.DrugFlag=0 where
                 CM_FangJiSub.FangJiSubCode=A.PrescriptionCode ) as haozhuang, 
	            (select COUNT(*) from CM_FangJiSub where DrugFlag=0 and CM_FangJiSub.FangJiSubCode=A.PrescriptionCode) as lishu
               from   (select DialecticalCode,DialecticalName,CureCode,CureName,
               PrescriptionCode,PrescriptionName,Score,row_number() over (order by SubID) as SubID  from #OutTemp where ISNULL(PrescriptionCode,'')<>'' ) A) CC
               where ISNULL(PrescriptionCode,'')<>'' 
              order by CC.Score DESC
--
exec CM_Sp_Dialectical @EmpBasicMainID='12100',@OperationType=2,@DialecticalCode='10978',@CureCode='10461'		
执行出的结果 PrescriptCode 10017	   白虎汤
--	王哥写的	  
CREATE PROCEDURE [dbo].[CM_Sp_YinMeridian]
	@StrYinCode varchar(1000)=''
as
 

	if exists (select * from tempdb.dbo.sysobjects where [name] ='#YinOutTemp')   
						   drop table [dbo].[#TastOutTemp]
	create table #YinOutTemp
	( 
		DrugCode char(20),	--中药编码
		DrugName nvarchar(200),	--中药名称
		InputCode char(20),		--拼音码
		Unit nvarchar(500) --引经拼接字符串
	)
    create table #YinTempOut
	(
		DrugCode char(20),	--中药编码
		DrugName nvarchar(200),	--中药名称
		InputCode char(20),		--拼音码
		YinCol nvarchar(500) --性味拼接字符串
	)
		
	declare @sqlStr varchar(3000) 
	set @sqlStr='insert into #YinOutTemp(DrugCode,DrugName,InputCode,Unit)
	select ltrim(rtrim(Gy_DrugOrYinMeridian.DrugCode)) as DrugCode ,DrugName,InputCode,
(rtrim(Gy_DrugOrYinMeridian.MeridianCode)+'':''+MeridianName) as Unit from Gy_DrugOrYinMeridian
left join Gy_DrugDict on Gy_DrugOrYinMeridian.DrugCode=Gy_DrugDict.DrugCode
left join Gy_Meridian on Gy_DrugOrYinMeridian.MeridianCode=Gy_Meridian.MeridianCode where 1=1 '
	if @StrYinCode<>''
	begin
		set @sqlStr=@sqlStr+ ' and Gy_DrugOrYinMeridian.MeridianCode in (select code from dbo.Gy_Fun_ReturnRecordset('''+@StrYinCode+'''))'  
	end
	print @sqlStr
	exec (@sqlStr)
	
	--查询临时表
	if @StrYinCode=''
	begin
    select DrugCode,DrugName,InputCode,
    stuff((
        SELECT 
            ';'+Unit
        FROM #YinOutTemp AS tb01 where tb01.DrugCode=tb02.DrugCode
        FOR xml PATH('')),1,1,'') AS Units 
 FROM  #YinOutTemp AS tb02 
 GROUP BY DrugCode,DrugName,InputCode
 end
 if @StrYinCode<>''
 begin
 insert into #YinTempOut(DrugCode,DrugName,InputCode,YinCol)
	   select tb03.DrugCode,tb03.DrugName,tb03.InputCode,(rtrim(Gy_DrugOrYinMeridian.MeridianCode)+':'+rtrim(MeridianName)) as YinCol from (
select DrugCode,DrugName,InputCode,
    stuff((
        SELECT 
            ';'+Unit
        FROM #YinOutTemp AS tb01 where tb01.DrugCode=tb02.DrugCode
        FOR xml PATH('')),1,1,'') AS Units 
 FROM  #YinOutTemp AS tb02 
 GROUP BY DrugCode,DrugName,InputCode
	 ) as tb03
	 left join Gy_DrugOrYinMeridian on tb03.DrugCode=Gy_DrugOrYinMeridian.DrugCode
	 left join Gy_Meridian on Gy_DrugOrYinMeridian.MeridianCode=Gy_Meridian.MeridianCode
	 
	 select DrugCode,DrugName,InputCode,
		stuff((
			SELECT 
				';'+YinCol
			FROM #YinTempOut AS tb01 where tb01.DrugCode=tb02.DrugCode
			FOR xml PATH('')),1,1,'') AS Units 
	 FROM  #YinTempOut AS tb02 
	 GROUP BY DrugCode,DrugName,InputCode
 end
--
exec CM_Sp_YinMeridian @StrYinCode='04,05,08,09,12'
--根据主症编码获取对应的证型及治法  2620行
select CC.ChineseMedicineName,CC.CureName,CC.MainSymptomCode,CC.CurePinYinCode,CC.DialecticalPinYinCode,CC.DialecticalName,CC.MainSymptomName,CC.WesternMedicineName from (select distinct AA.MainSymptomName,Gy_Cure.CureName,Gy_Cure.PinYinCode as CurePinYinCode,Gy_Dialectical.DialecticalName,
                                  Gy_Dialectical.PinYinCode as DialecticalPinYinCode,ISNULL(Gy_ChineseMedicine.ChineseMedicineName,'') ChineseMedicineName,
                                  Soue,ISNULL(Gy_WesternMedicine.WesternMedicineName,'') WesternMedicineName,AA.MainSymptomCode  
                                  from (select distinct Gy_MainSymptom.MainSymptomCode,Gy_MainSymptom.MainSymptomName,Gy_MainSymptom.PinYinCode,Gy_MainSymptomType.MainSymptomTypeName,
                                  ISNULL(CM_MaxMainSymptom.Soue,0) as Soue from Gy_MainSymptom left join 
                                  Gy_SymptomOrDosage on Gy_SymptomOrDosage.MainSymptomCode=Gy_MainSymptom.MainSymptomCode and Gy_SymptomOrDosage.DeptCode='10004' left join 
                                  Gy_MainSymptomType on Gy_MainSymptomType.MainSymptomTypeCode=Gy_MainSymptom.MainSymptomTypeCode left join
                                  CM_MaxMainSymptom on CM_MaxMainSymptom.MainSymptomCode=Gy_MainSymptom.MainSymptomCode and CM_MaxMainSymptom.UserCode='xyt001' ) AA right join 
                                  Gy_DialecticalMainSymptom on Gy_DialecticalMainSymptom.MainSymptomCode=AA.MainSymptomCode inner join 
                                  Gy_CureDialectical on Gy_CureDialectical.DialecticalCode=Gy_DialecticalMainSymptom.DialecticalCode 
                                  and Gy_DialecticalMainSymptom.MainSymptomCode=Gy_CureDialectical.MainSymptomCode inner join 
                                  Gy_Dialectical on Gy_Dialectical.DialecticalCode=Gy_CureDialectical.DialecticalCode inner join 
                                  Gy_Cure on Gy_Cure.CureCode=Gy_CureDialectical.CureCode left join
                                  Gy_MainSymptom on Gy_MainSymptom.MainSymptomCode=AA.MainSymptomCode left join 
                                  Gy_ChineseMedicine on Gy_MainSymptom.ChineseMedicineCode=Gy_ChineseMedicine.ChineseMedicineCode left join 
                                  Gy_WesternMedicine on Gy_DialecticalMainSymptom.WesternMedicineCode=Gy_WesternMedicine.WesternMedicineCode) CC order by CC.Soue DESC
--根据科室编码获取常用的主症对象 前台论治和中医处方操作 yyc
select distinct * from (select distinct Gy_MainSymptom.MainSymptomCode,Gy_MainSymptom.MainSymptomName,Gy_MainSymptom.PinYinCode,Gy_MainSymptomType.MainSymptomTypeName,
ISNULL(CM_MaxMainSymptom.Soue,0) as Soue,ISNULL(Gy_SymptomOrDosage.DeptCode,'') as DeptCode  from Gy_MainSymptom left join 
Gy_SymptomOrDosage on Gy_SymptomOrDosage.MainSymptomCode=Gy_MainSymptom.MainSymptomCode and Gy_SymptomOrDosage.DeptCode=10004  left join 
Gy_MainSymptomType on Gy_MainSymptomType.MainSymptomTypeCode=Gy_MainSymptom.MainSymptomTypeCode left join
CM_MaxMainSymptom on CM_MaxMainSymptom.MainSymptomCode=Gy_MainSymptom.MainSymptomCode and CM_MaxMainSymptom.UserCode='xyt001' ) AA order by AA.Soue DESC,AA.DeptCode DESC  			
-- 针灸系统 根据科室编码获取常用的主症对象
select * from (select distinct Gy_MainSymptom.MainSymptomCode,Gy_MainSymptom.MainSymptomName,Gy_MainSymptom.PinYinCode,Gy_MainSymptomType.MainSymptomTypeName,
ISNULL(CM_MaxMainSymptom.Soue,0) as Soue,ISNULL(Gy_SymptomOrDosage.DeptCode,'') as DeptCode  from Gy_MainSymptom 
left join Gy_MainSymptomSystem on Gy_MainSymptomSystem.MainSymptomCode=Gy_MainSymptom.MainSymptomCode left join 
Gy_SymptomOrDosage on Gy_SymptomOrDosage.MainSymptomCode=Gy_MainSymptom.MainSymptomCode and Gy_SymptomOrDosage.DeptCode='10004'  left join 
Gy_MainSymptomType on Gy_MainSymptomType.MainSymptomTypeCode=Gy_MainSymptom.MainSymptomTypeCode left join
CM_MaxMainSymptom on CM_MaxMainSymptom.MainSymptomCode=Gy_MainSymptom.MainSymptomCode and CM_MaxMainSymptom.UserCode='xyt001'
where Gy_MainSymptomSystem.SystemCode='02') AA order by AA.Soue DESC,AA.DeptCode DESC													   
--获取HIS系统住院病人基本信息方法
select  CM_EmpBasicMain.*, Gy_WesternMedicine.WesternMedicineName,Gy_ChineseMedicine.ChineseMedicineName,Gy_Dialectical.DialecticalName,Gy_Cure.CureName,
	(select top 1 ISNULL(Gy_User.UserName,'') from Gy_User left join 
CM_EmpBasicMain on Gy_User.HISUserCode=CM_EmpBasicMain.UserCode and Gy_User.DeptCode=CM_EmpBasicMain.DeptCode where CM_EmpBasicMain.RegistrationNum='201601130002') as strUserName,
(select top 1 ISNULL(DeptName,'') from Gy_DeptMent where Gy_DeptMent.DeptCode=CM_EmpBasicMain.DeptCode and CM_EmpBasicMain.RegistrationNum='201601130002' ) as strDeptName,
CM_HISEmpBasicMain.OnSetDate,CM_HISEmpBasicMain.[Weight],CM_HISEmpBasicMain.IsYuFu from CM_EmpBasicMain left join 
 Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=CM_EmpBasicMain.WesternMedicineCode left join 
 Gy_ChineseMedicine on Gy_ChineseMedicine.ChineseMedicineCode=CM_EmpBasicMain.ChineseMedicineCode left join 
 Gy_Dialectical on Gy_Dialectical.DialecticalCode=CM_EmpBasicMain.DialecticalCode left join 
 Gy_Cure on Gy_Cure.CureCode=CM_EmpBasicMain.CureCode left join CM_HISEmpBasicMain 
 on CM_HISEmpBasicMain.RegistrationNum= CM_EmpBasicMain.RegistrationNum  where CM_EmpBasicMain.RegistrationNum='201601130002' 

--
 康复系统ToolStripMenuItem
--视图 CM_V_DCW
SELECT DISTINCT 
                      dbo.Gy_MainSymptom.MainSymptomCode, dbo.Gy_MainSymptom.MainSymptomName, dbo.Gy_MainSymptom.PinYinCode, ISNULL(dbo.CM_MaxMainSymptom.Soue, 0) AS Soue, 
                      dbo.Gy_MainSymptomSystem.SystemCode, dbo.Gy_Cure.CureName, dbo.Gy_Cure.PinYinCode AS CurePinYinCode, dbo.Gy_Dialectical.DialecticalName, 
                      dbo.Gy_Dialectical.PinYinCode AS DialecticalPinYinCode, ISNULL(dbo.Gy_ChineseMedicine.ChineseMedicineName, '') AS ChineseMedicineName, dbo.Gy_MainSymptom.ChineseMedicineCode, 
                      dbo.Gy_DialectcalWesternMedicine.WesternMedicineCode, ISNULL(dbo.Gy_WesternMedicine.WesternMedicineName, '') AS WesternMedicineName, dbo.CM_MaxMainSymptom.UserCode, 
                      dbo.Gy_User.DeptCode
FROM         dbo.Gy_MainSymptom LEFT OUTER JOIN
                      dbo.Gy_MainSymptomSystem ON dbo.Gy_MainSymptomSystem.MainSymptomCode = dbo.Gy_MainSymptom.MainSymptomCode LEFT OUTER JOIN
                      dbo.Gy_SymptomOrDosage ON dbo.Gy_SymptomOrDosage.MainSymptomCode = dbo.Gy_MainSymptom.MainSymptomCode LEFT OUTER JOIN
                      dbo.CM_MaxMainSymptom ON dbo.CM_MaxMainSymptom.MainSymptomCode = dbo.Gy_MainSymptom.MainSymptomCode LEFT OUTER JOIN
                      dbo.Gy_DialecticalMainSymptom ON dbo.Gy_DialecticalMainSymptom.MainSymptomCode = dbo.Gy_MainSymptom.MainSymptomCode LEFT OUTER JOIN
                      dbo.Gy_CureDialectical ON dbo.Gy_CureDialectical.DialecticalCode = dbo.Gy_DialecticalMainSymptom.DialecticalCode AND 
                      dbo.Gy_DialecticalMainSymptom.MainSymptomCode = dbo.Gy_CureDialectical.MainSymptomCode LEFT OUTER JOIN
                      dbo.Gy_Dialectical ON dbo.Gy_Dialectical.DialecticalCode = dbo.Gy_DialecticalMainSymptom.DialecticalCode LEFT OUTER JOIN
                      dbo.Gy_Cure ON dbo.Gy_Cure.CureCode = dbo.Gy_CureDialectical.CureCode LEFT OUTER JOIN
                      dbo.Gy_ChineseMedicine ON dbo.Gy_MainSymptom.ChineseMedicineCode = dbo.Gy_ChineseMedicine.ChineseMedicineCode LEFT OUTER JOIN
                      dbo.Gy_DialectcalWesternMedicine ON dbo.Gy_DialecticalMainSymptom.MainSymptomCode = dbo.Gy_DialectcalWesternMedicine.MainSymptomCode AND 
                      dbo.Gy_DialecticalMainSymptom.DialecticalCode = dbo.Gy_DialectcalWesternMedicine.DialecticalCode LEFT OUTER JOIN
                      dbo.Gy_WesternMedicine ON dbo.Gy_DialectcalWesternMedicine.WesternMedicineCode = dbo.Gy_WesternMedicine.WesternMedicineCode LEFT OUTER JOIN
                      dbo.Gy_User ON dbo.CM_MaxMainSymptom.UserCode = dbo.Gy_User.UserCode		

-- 根据主症编码和病人信息单号获取该病人的兼症信息
select A.selDisease,A.DiseaseCode,Gy_Disease.DiseaseName 
                                from (
                                select case when CM_DiseaseSub.DiseaseCode= Gy_MainSymptomDisease.DiseaseCode then 1 else 0 end as selDisease,
		                                Gy_MainSymptomDisease.DiseaseCode 
                                from Gy_MainSymptomDisease left join CM_DiseaseSub on CM_DiseaseSub.DiseaseCode=Gy_MainSymptomDisease.DiseaseCode and CM_DiseaseSub.EmpBasicMainID=12027
                                where Gy_MainSymptomDisease.MainSymptomCode='10472') 
                                A left join Gy_Disease on Gy_Disease.DiseaseCode=A.DiseaseCode order by A.selDisease desc,Gy_Disease.DiseaseName
--CM_V_GetPatientInfo
SELECT     c.RegistrationNum, ISNULL(a.MecidalTypeName, '') AS MecidalTypeName, c.MecidalNum, ISNULL(b.MecidalTypeName, '') AS EmTypeName, c.EmName, c.EmSex, c.EmAge, c.DeptName, 
                      c.UserName, c.EmPreferentialNum, c.EmHealthCardNum, c.EmComName, c.EmMobile, c.EmNum, c.EmAddress, c.Maker, c.MakeDate, c.Weight, c.IsYuFu, c.OnSetDate
FROM         dbo.CM_HISEmpBasicMain AS c LEFT OUTER JOIN
                      dbo.Gy_MecidalType AS a ON c.MecidalType = a.MecidalTypeCode LEFT OUTER JOIN
                      dbo.Gy_MecidalType AS b ON c.EmType = b.MecidalTypeCode
								
-- CM_V_EmpBasicMain  功能描述:病人信息表     编写人  :yyc

CREATE view [dbo].[CM_V_EmpBasicMain]
	as

select distinct CM_EmpBasicMain.MecidalNum,CM_EmpBasicMain.RegistrationNum,
(case when ISNULL(CM_EmpBasicMain.EmAddress,'')<>'' 
then CM_EmpBasicMain.EmAddress else  CM_HISEmpBasicMain.EmAddress end) as EmAddress  ,
CM_EmpBasicMain.EmAge,CM_EmpBasicMain.DeptName,CM_EmpBasicMain.UserName,
CM_EmpBasicMain.EmName,CM_EmpBasicMain.EmSex,CM_EmpBasicMain.OnSetDate,'' as IsDaiJian,'' as FangJiUsage,'' as ZJMinutes,
        CM_EmpBasicMain.EmpBasicMainID,EmpBasicCode,CM_EmpBasicMain.MainSymptomCode,ChiefComplaint,HistoryPresent,HistoryPast,HistoryAllergic,
		ISNULL(CM_EmpBasicMain.PhysicalExamination,'') as PhysicalExamination,CM_EmpBasicMain.DialecticalCode,CM_EmpBasicMain.CureCode,CM_EmpBasicMain.ChineseMedicineCode,CM_EmpBasicMain.WesternMedicineCode,'' as Advice,'' as UsageCount,
		Gy_WesternMedicine.WesternMedicineName,Gy_ChineseMedicine.ChineseMedicineName,'' as FangJiSubName,
		CM_EmpBasicMain.DiagnosisViews,Gy_Dialectical.DialecticalName,CM_EmpBasicMain.IsYuFu,Gy_Cure.CureName,'' as Remark,
		CM_EmpBasicMain.EvaluationCode,Gy_Evaluation.EvaluationName,CM_EmpBasicMain.EvaluationRemark,Gy_MainSymptom.MainSymptomName as MainSymptomName,
		ISNULL(CM_EmpBasicMain.DiseaseName,'') as DiseaseName,ISNULL(CM_EmpBasicMain.MainSymptomName,'') as MainSymptomNameOne,
		ISNULL(CM_EmpBasicMain.TongueName,'') as TongueName,ISNULL(CM_EmpBasicMain.PulseName,'') as PulseName      
		from CM_EmpBasicMain left join 
		Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=CM_EmpBasicMain.WesternMedicineCode left join 
		Gy_ChineseMedicine on Gy_ChineseMedicine.ChineseMedicineCode=CM_EmpBasicMain.ChineseMedicineCode left join 
		Gy_Dialectical on Gy_Dialectical.DialecticalCode=CM_EmpBasicMain.DialecticalCode left join 
		Gy_Cure on Gy_Cure.CureCode=CM_EmpBasicMain.CureCode left join 
		Gy_Evaluation on Gy_Evaluation.EvaluationCode=CM_EmpBasicMain.EvaluationCode left join 
		Gy_MainSymptom on Gy_MainSymptom.MainSymptomCode=CM_EmpBasicMain.MainSymptomCode  left join
		CM_HISEmpBasicMain on CM_EmpBasicMain.RegistrationNum = CM_HISEmpBasicMain.RegistrationNum
--Gy_SP_GetPreByCodeOrNameOrDrugName
CREATE procedure [dbo].[Gy_SP_GetPreByCodeOrNameOrDrugName]
@PrescriptionCode char(20),
@PrescriptionName nvarchar(50),
@DrugName nvarchar(50),
@DrugFlag char(2)
as
begin
declare @StrSql nvarchar(3000)=''
set @StrSql='select Gy_PrescriptionMain.PrescriptionCode,Gy_PrescriptionMain.PrescriptionName,Gy_PrescriptionMain.PinYinCode,
 Gy_PrescriptionMain.Effect,Gy_PrescriptionMain.Attend,Gy_PrescriptionMain.Calcite,Gy_PrescriptionMain.Source,
 case when Gy_PrescriptionMain.SysFlag=0 then ''系统'' when Gy_PrescriptionMain.SysFlag=1 then ''用户'' end as SysFlag ,
 Gy_PrescriptionMain.JRate,Gy_PrescriptionMain.CRate,Gy_PrescriptionMain.ZRate,Gy_PrescriptionMain.SRate,
 Gy_PrescriptionMain.Remark,Gy_PrescriptionMain.MakeDate,Gy_PrescriptionMain.ModifyCode,Gy_PrescriptionMain.ModifyDate,
 ISNULL(Gy_User.UserName,''超级用户'') as MakeName
 from Gy_PrescriptionMain 
 left join Gy_User on Gy_User.UserCode=Gy_PrescriptionMain.Maker where 1=1 and DrugFlag='+@DrugFlag+''
if @PrescriptionCode<>''
begin
  set @StrSql+=' and Gy_PrescriptionMain.PrescriptionCode like ''%'+@PrescriptionCode+'%'''
end
if @PrescriptionName<>''
begin
  set @StrSql+=' and Gy_PrescriptionMain.PrescriptionName like ''%'+@PrescriptionName+'%'''
end
if @DrugName<>''
begin
  set @StrSql+=' and Gy_PrescriptionMain.PrescriptionCode in  (select distinct Gy_PrescriptionSub.PrescriptionCode from Gy_PrescriptionSub
 left join Gy_DrugDict on Gy_PrescriptionSub.DrugCode=Gy_DrugDict.DrugCode
 where Gy_DrugDict.DrugName like ''%'+@DrugName+'%'')'
end
  set @StrSql+=' order by Gy_PrescriptionMain.PrescriptionCode desc'
  
  exec sp_executesql @StrSql
end
--
exec Gy_SP_GetPreByCodeOrNameOrDrugName @PrescriptionCode='',@PrescriptionName='',@DrugName='',@DrugFlag=0
--  CM_V_WesternDrugByEmpBasicMainID
CREATE view [dbo].[CM_V_WesternDrugByEmpBasicMainID]
	as
		select 	CM_FangJiSub.EmpBasicMainID,CM_FangJiSub.DrugFlag,CM_FangJiDetailSub.DrugCode,Gy_DrugDict.DrugName,
				Gy_DrugDict.PackageUnits,A.UnitName as SingleMeasureUnitName,B.UnitName as TotalAmountUnitName,
				C.UnitName as PrescriptionUnitName,CM_FangJiDetailSub.Consumption as SingleMeasure,CM_FangJiDetailSub.DrugWayCode,
				CM_FangJiDetailSub.FrequencyCode,Gy_Frequency.Coefficient as Coefficient,CM_FangJiDetailSub.UseDays,
				CM_FangJiDetailSub.TotalAmount,CM_FangJiDetailSub.Quanitity,CM_FangJiDetailSub.LPrice,
				ISNULL(CM_FangJiDetailSub.LPrice,0) * ISNULL(CM_FangJiDetailSub.Quanitity,0) as WholeMoney,
				Gy_DrugDict.MeasurementCoefficient,'删除' as [Delete],Gy_Frequency.FrequencyName,Gy_DrugWay.DrugWayName,CM_FangJiDetailSub.FangJiSubID
				
		from CM_FangJiDetailSub left join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID
						 left join Gy_DrugDict on Gy_DrugDict.DrugCode=CM_FangJiDetailSub.DrugCode
						 left join Gy_Unit A on A.UnitCode=Gy_DrugDict.SingleMeasureUnit
						 left join Gy_Unit B on B.UnitCode=Gy_DrugDict.SingleMeasureUnit
						 left join Gy_Unit C on C.UnitCode=Gy_DrugDict.PrescriptionUnit
						 left join Gy_Frequency on Gy_Frequency.FrequencyCode=CM_FangJiDetailSub.FrequencyCode
						 left join Gy_DrugWay on Gy_DrugWay.DrugWayCode=CM_FangJiDetailSub.DrugWayCode



<?xml version="1.0" encoding="UTF-8" ?><dogformat root="dog_info"><feature><attribute name="id"/>  <element name="license" /> </feature></dogformat>


