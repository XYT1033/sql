--select dbo.CM_Fun_test(15) FangjiReturnValue
CREATE FUNCTION [dbo].[CM_Fun_GetFangJiZJValue]
(
@EmpBasicMainID int,
@DrugFlag int=0
)
returns varchar(8000)  
as
begin
  declare @ReturnValue varchar(8000)
  set @ReturnValue=''

if ISNULL(@DrugFlag,0)=0
begin
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
+ rtrim(convert(varchar(50),ISNULL(CM_FangJiDetailSub.Remark,'')))+'|'    
from CM_FangJiDetailSub inner join  CM_FangJiSub on CM_FangJiSub.FangJiSubID =CM_FangJiDetailSub.FangJiSubID left outer join 
Gy_SufferType on CM_FangJiDetailSub.SufferTypeCode =Gy_SufferType.SufferTypeCode left outer join 
Gy_DrugDict on CM_FangJiDetailSub.DrugCode =Gy_DrugDict.DrugCode left join
Gy_Unit on Gy_Unit.UnitCode=Gy_DrugDict.Units where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=0  
end
else if ISNULL(@DrugFlag,0)=1
begin
select @ReturnValue=case when ltrim(rtrim(@ReturnValue))<>'' 
then ltrim(rtrim(@ReturnValue))+' ' else '' end 
+ rtrim(convert(varchar(50),ISNULL(Gy_DrugDict.DrugName,'')))+'|' 
from CM_FangJiDetailSub inner join  CM_FangJiSub on CM_FangJiSub.FangJiSubID =CM_FangJiDetailSub.FangJiSubID left outer join 
Gy_DrugDict on CM_FangJiDetailSub.DrugCode =Gy_DrugDict.DrugCode  where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=1  
end
else if ISNULL(@DrugFlag,0)=2
begin
select @ReturnValue=case when ltrim(rtrim(@ReturnValue))<>'' 
then ltrim(rtrim(@ReturnValue))+' ' else '' end 
+ rtrim(convert(varchar(50),ISNULL(Gy_DrugDict.DrugName,'')))+' '+rtrim(convert(varchar(50),Ceiling(ISNULL(CM_FangJiDetailSub.Quanitity,0))))+''+ rtrim(ISNULL(Gy_Unit.UnitName,''))+'|'    
from CM_FangJiDetailSub inner join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID left join
Gy_DrugDict on Gy_DrugDict.DrugCode=CM_FangJiDetailSub.DrugCode left join 
Gy_Unit on Gy_Unit.UnitCode=Gy_DrugDict.PrescriptionUnit  where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=2  
end
else if ISNULL(@DrugFlag,0)=3
begin
select @ReturnValue=case when ltrim(rtrim(@ReturnValue))<>'' 
then ltrim(rtrim(@ReturnValue))+' ' else '' end 
+ rtrim(convert(varchar(50),ISNULL(CM_FangJiSub.FangJiSubName,'')))+'|'    
from CM_FangJiDetailSub inner join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID 
where CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and CM_FangJiSub.DrugFlag=3  
end
else
begin
 set @ReturnValue=''
end
	
  return @ReturnValue 
end
--
select dbo.CM_Fun_GetFangJiZJValue(12100,1) FangjiReturnValue
--CM_V_EmpBasicMain
SELECT DISTINCT 
  dbo.CM_EmpBasicMain.MecidalNum, dbo.CM_EmpBasicMain.RegistrationNum, (CASE WHEN ISNULL(CM_EmpBasicMain.EmAddress, '') 
  <> '' THEN CM_EmpBasicMain.EmAddress ELSE CM_HISEmpBasicMain.EmAddress END) AS EmAddress, dbo.CM_EmpBasicMain.EmAge, dbo.CM_EmpBasicMain.DeptName, 
  dbo.CM_EmpBasicMain.UserName, dbo.CM_EmpBasicMain.EmName, dbo.CM_EmpBasicMain.EmSex, dbo.CM_EmpBasicMain.OnSetDate, '' AS IsDaiJian, '' AS FangJiUsage, '' AS ZJMinutes, 
  dbo.CM_EmpBasicMain.EmpBasicMainID, dbo.CM_EmpBasicMain.EmpBasicCode, dbo.CM_EmpBasicMain.MainSymptomCode, dbo.CM_EmpBasicMain.ChiefComplaint, 
  dbo.CM_EmpBasicMain.HistoryPresent, dbo.CM_EmpBasicMain.HistoryPast, dbo.CM_EmpBasicMain.HistoryAllergic, ISNULL(dbo.CM_EmpBasicMain.PhysicalExamination, N'') 
  AS PhysicalExamination, dbo.CM_EmpBasicMain.DialecticalCode, dbo.CM_EmpBasicMain.CureCode, dbo.CM_EmpBasicMain.ChineseMedicineCode, 
  dbo.CM_EmpBasicMain.WesternMedicineCode, '' AS Advice, '' AS UsageCount, dbo.Gy_WesternMedicine.WesternMedicineName, dbo.Gy_ChineseMedicine.ChineseMedicineName, 
  '' AS FangJiSubName, dbo.CM_EmpBasicMain.DiagnosisViews, dbo.Gy_Dialectical.DialecticalName, dbo.CM_EmpBasicMain.IsYuFu, dbo.Gy_Cure.CureName, '' AS Remark, 
  dbo.CM_EmpBasicMain.EvaluationCode, dbo.Gy_Evaluation.EvaluationName, dbo.CM_EmpBasicMain.EvaluationRemark, dbo.Gy_MainSymptom.MainSymptomName, 
  ISNULL(dbo.CM_EmpBasicMain.DiseaseName, N'') AS DiseaseName, ISNULL(dbo.CM_EmpBasicMain.MainSymptomName, N'') AS MainSymptomNameOne, 
  ISNULL(dbo.CM_EmpBasicMain.TongueName, N'') AS TongueName, ISNULL(dbo.CM_EmpBasicMain.PulseName, N'') AS PulseName
FROM         dbo.CM_EmpBasicMain LEFT OUTER JOIN
  dbo.Gy_WesternMedicine ON dbo.Gy_WesternMedicine.WesternMedicineCode = dbo.CM_EmpBasicMain.WesternMedicineCode LEFT OUTER JOIN
  dbo.Gy_ChineseMedicine ON dbo.Gy_ChineseMedicine.ChineseMedicineCode = dbo.CM_EmpBasicMain.ChineseMedicineCode LEFT OUTER JOIN
  dbo.Gy_Dialectical ON dbo.Gy_Dialectical.DialecticalCode = dbo.CM_EmpBasicMain.DialecticalCode LEFT OUTER JOIN
  dbo.Gy_Cure ON dbo.Gy_Cure.CureCode = dbo.CM_EmpBasicMain.CureCode LEFT OUTER JOIN
  dbo.Gy_Evaluation ON dbo.Gy_Evaluation.EvaluationCode = dbo.CM_EmpBasicMain.EvaluationCode LEFT OUTER JOIN
  dbo.Gy_MainSymptom ON dbo.Gy_MainSymptom.MainSymptomCode = dbo.CM_EmpBasicMain.MainSymptomCode LEFT OUTER JOIN
  dbo.CM_HISEmpBasicMain ON dbo.CM_EmpBasicMain.RegistrationNum = dbo.CM_HISEmpBasicMain.RegistrationNum

--CM_V_DoctorTreatmentAnalysis 根据日期段查询医生就诊记录
select CM_EmpBasicMain.MecidalNum,CM_EmpBasicMain.EmpBasicMainID,CM_EmpBasicMain.RegistrationNum,CM_EmpBasicMain.EmName,CM_EmpBasicMain.EmAge,
	CM_EmpBasicMain.EmAddress,CM_EmpBasicMain.EmSex,case when CM_EmpBasicMain.EmSex=1 then '男' when CM_EmpBasicMain.EmSex=0 then '女' else '' end as EmSexName,
	CONVERT(varchar(100),CM_EmpBasicMain.OnSetDate, 23) as OnSetDate,CM_EmpBasicMain.ChineseMedicineCode,
	CM_EmpBasicMain.WesternMedicineCode,CM_EmpBasicMain.Weight,CM_EmpBasicMain.DialecticalCode,
	CM_EmpBasicMain.CureCode,CM_EmpBasicMain.UserCode,Gy_User.UserName,CM_EmpBasicMain.DeptCode,CM_EmpBasicMain.DeptName,
	Gy_Dialectical.DialecticalName,Gy_Cure.CureName,Gy_ChineseMedicine.ChineseMedicineName,Gy_WesternMedicine.WesternMedicineName,1 as OutpatientCount,
	
	(select CAST(SUM(ISNULL(WholeMoney,0)) as decimal(20,2)) as HerbalMoney
		from CM_FangJiDetailSub inner join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID 
		where CM_FangJiSub.EmpBasicMainID=CM_EmpBasicMain.EmpBasicMainID and CM_FangJiSub.DrugFlag=0) as HerbalMoney, 
	(select CAST(SUM(ISNULL(WholeMoney,0)) as decimal(20,2)) as AcupunctureMoney
		from CM_FangJiDetailSub inner join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID 
		where CM_FangJiSub.EmpBasicMainID=CM_EmpBasicMain.EmpBasicMainID and CM_FangJiSub.DrugFlag=1) as AcupunctureMoney, 
	(select CAST(SUM(ISNULL(WholeMoney,0)) as decimal(20,2)) as WesternMoney
		from CM_FangJiDetailSub inner join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID 
		where CM_FangJiSub.EmpBasicMainID=CM_EmpBasicMain.EmpBasicMainID and CM_FangJiSub.DrugFlag=2) as WesternMoney, 
	(select CAST(SUM(ISNULL(Price,0)) as decimal(20,2)) as InspectionMoney
		from CM_CheckSub left join Gy_DetailItem on Gy_DetailItem.DetailItemCode=CM_CheckSub.DetailItemCode 
		where CM_CheckSub.EmpBasicMainID=CM_EmpBasicMain.EmpBasicMainID and Gy_DetailItem.DetailItemFlag=1) as InspectionMoney, 
	(select CAST(SUM(ISNULL(Price,0)) as decimal(20,2)) as CheckMoney
		from CM_CheckSub left join Gy_DetailItem on Gy_DetailItem.DetailItemCode=CM_CheckSub.DetailItemCode 
		where CM_CheckSub.EmpBasicMainID=CM_EmpBasicMain.EmpBasicMainID and Gy_DetailItem.DetailItemFlag=0) as CheckMoney	
	 
from CM_EmpBasicMain left join Gy_User on Gy_User.UserCode = CM_EmpBasicMain.UserCode
					 left join Gy_Dialectical on Gy_Dialectical.DialecticalCode=CM_EmpBasicMain.DialecticalCode 
					 left join Gy_Cure on Gy_Cure.CureCode=CM_EmpBasicMain.CureCode 
					 left join Gy_ChineseMedicine on Gy_ChineseMedicine.ChineseMedicineCode=CM_EmpBasicMain.ChineseMedicineCode 
					 left join Gy_WesternMedicine on Gy_WesternMedicine.WesternMedicineCode=CM_EmpBasicMain.WesternMedicineCode 

	
--CM_V_EmpMarkMain
SELECT     dbo.CM_EmpMarkMain.EmpBasicMainID, LTRIM(RTRIM(dbo.CM_EmpMarkMain.EmpMarkMainID)) AS EmpMarkMainID, LTRIM(RTRIM(dbo.CM_EmpMarkMain.MarkTypeCode)) AS MarkTypeCode1, 
LTRIM(RTRIM(dbo.CM_EmpMarkMain.EvaluationCode)) AS EvaluationCode, LTRIM(RTRIM(dbo.CM_EmpMarkMain.Remark)) AS Remark, dbo.CM_EmpMarkMain.TotalScore, 
LTRIM(RTRIM(dbo.Gy_MarkType.MarkTypeName)) AS MarkTypeName, LTRIM(RTRIM(dbo.Gy_Evaluation.EvaluationName)) AS EvaluationName, dbo.CM_EmpMarkMain.Remark AS MTRemark, 
LTRIM(RTRIM(dbo.CM_EmpMarkMain.MarkTime)) AS MarkTime,
(SELECT     SUM(MarkScore) AS Expr1
FROM          (SELECT     MAX(dbo.Gy_MarkItemList.MarkScore) AS MarkScore, dbo.Gy_MarkItemList.MarkItemTypeCode
FROM          dbo.Gy_MarkItemList LEFT OUTER JOIN
dbo.Gy_MarkItemType ON dbo.Gy_MarkItemType.MarkItemTypeCode = dbo.Gy_MarkItemList.MarkItemTypeCode LEFT OUTER JOIN
dbo.Gy_MarkType ON dbo.Gy_MarkType.MarkTypeCode = dbo.Gy_MarkItemType.MarkTypeCode
WHERE      (dbo.Gy_MarkType.MarkTypeCode = dbo.CM_EmpMarkMain.MarkTypeCode)
GROUP BY dbo.Gy_MarkItemList.MarkItemTypeCode) AS A	) AS FullScore
FROM         dbo.CM_EmpMarkMain LEFT OUTER JOIN
dbo.Gy_MarkType ON dbo.Gy_MarkType.MarkTypeCode = dbo.CM_EmpMarkMain.MarkTypeCode LEFT OUTER JOIN
dbo.Gy_Evaluation ON dbo.Gy_Evaluation.EvaluationCode = dbo.CM_EmpMarkMain.EvaluationCode		
--
SELECT     MAX(dbo.Gy_MarkItemList.MarkScore) AS MarkScore, dbo.Gy_MarkItemList.MarkItemTypeCode
FROM          dbo.Gy_MarkItemList LEFT OUTER JOIN
dbo.Gy_MarkItemType ON dbo.Gy_MarkItemType.MarkItemTypeCode = dbo.Gy_MarkItemList.MarkItemTypeCode LEFT OUTER JOIN
dbo.Gy_MarkType ON dbo.Gy_MarkType.MarkTypeCode = dbo.Gy_MarkItemType.MarkTypeCode
WHERE      (dbo.Gy_MarkType.MarkTypeCode = 1037)
GROUP BY dbo.Gy_MarkItemList.MarkItemTypeCode				  
--CM_V_InterrogationMeridianCode
SELECT     dbo.CM_InterrogationSub.EmpBasicMainID, dbo.Gy_DiseaseMeridian.MeridianCode, SUM(CASE WHEN ISNULL(Gy_DiseaseMeridian.MeridianCode, '') <> '' THEN 1 ELSE 0 END) AS Score
FROM         dbo.CM_InterrogationSub LEFT OUTER JOIN
dbo.Gy_DiseaseMeridian ON dbo.CM_InterrogationSub.DiseaseCode = dbo.Gy_DiseaseMeridian.DiseaseCode LEFT OUTER JOIN
dbo.CM_EmpBasicMain ON dbo.CM_EmpBasicMain.EmpBasicMainID = dbo.CM_InterrogationSub.EmpBasicMainID LEFT OUTER JOIN
dbo.Gy_MainMeridian ON dbo.Gy_MainMeridian.MainSymptomCode = dbo.CM_EmpBasicMain.MainSymptomCode
WHERE     (dbo.CM_InterrogationSub.DiseaseCode IS NOT NULL)
GROUP BY dbo.Gy_DiseaseMeridian.MeridianCode, dbo.CM_InterrogationSub.EmpBasicMainID
--CM_V_TasteMeridianCode
SELECT     dbo.CM_FangJiSub.EmpBasicMainID, dbo.Gy_Meridian.MeridianName, dbo.Gy_DrugOrMeridian.MeridianCode, SUM(CASE WHEN ISNULL(Gy_DrugOrMeridian.MeridianCode, '') 
                      <> '' THEN 1 ELSE 0 END) AS TasteScore
FROM         dbo.Gy_DrugOrMeridian INNER JOIN
                      dbo.Gy_Meridian ON dbo.Gy_DrugOrMeridian.MeridianCode = dbo.Gy_Meridian.MeridianCode INNER JOIN
                      dbo.CM_FangJiDetailSub ON dbo.CM_FangJiDetailSub.DrugCode = dbo.Gy_DrugOrMeridian.DrugCode INNER JOIN
                      dbo.CM_FangJiSub ON dbo.CM_FangJiSub.FangJiSubID = dbo.CM_FangJiDetailSub.FangJiSubID
WHERE     (dbo.Gy_DrugOrMeridian.MeridianCode IS NOT NULL)
GROUP BY dbo.Gy_DrugOrMeridian.MeridianCode, dbo.Gy_Meridian.MeridianName, dbo.CM_FangJiSub.EmpBasicMainID
--CM_V_MarkItemList
SELECT     LTRIM(RTRIM(dbo.Gy_MarkItemType.MarkTypeCode)) AS MarkTypeCode, LTRIM(RTRIM(dbo.Gy_MarkItemList.MarkItemTypeCode)) AS MarkItemTypeCode, 
                      LTRIM(RTRIM(dbo.Gy_MarkItemType.MarkItemTypeName)) AS MarkItemTypeName, LTRIM(RTRIM(dbo.Gy_MarkItemList.MarkItemListCode)) AS MarkItemListCode, 
                      LTRIM(RTRIM(dbo.Gy_MarkItemList.MarkItemListName)) AS MarkItemListName, dbo.Gy_MarkItemList.MarkScore, LTRIM(RTRIM(dbo.Gy_MarkItemList.Remark)) AS Remark, 0 AS sel
FROM         dbo.Gy_MarkItemList LEFT OUTER JOIN
                      dbo.Gy_MarkItemType ON dbo.Gy_MarkItemType.MarkItemTypeCode = dbo.Gy_MarkItemList.MarkItemTypeCode LEFT OUTER JOIN
                      dbo.Gy_MarkType ON dbo.Gy_MarkType.MarkTypeCode = dbo.Gy_MarkItemType.MarkTypeCode
GROUP BY LTRIM(RTRIM(dbo.Gy_MarkItemType.MarkTypeCode)), LTRIM(RTRIM(dbo.Gy_MarkItemList.MarkItemTypeCode)), LTRIM(RTRIM(dbo.Gy_MarkItemType.MarkItemTypeName)), 
                      LTRIM(RTRIM(dbo.Gy_MarkItemList.MarkItemListCode)), LTRIM(RTRIM(dbo.Gy_MarkItemList.MarkItemListName)), dbo.Gy_MarkItemList.MarkScore, LTRIM(RTRIM(dbo.Gy_MarkItemList.Remark))
--CM_V_FJMain
SELECT     CASE WHEN CM_FangJiSub.DrugFlag = 3 THEN Gy_DetailITem.DetailItemName ELSE Gy_DrugDict.DrugName END AS DrugName, 
                      CASE WHEN CM_FangJiSub.DrugFlag = 1 THEN '' WHEN CM_FangJiSub.DrugFlag = 3 THEN '1' ELSE CAST(CM_FangJiDetailSub.Quanitity AS varchar) END AS Quanitity, dbo.Gy_Unit.UnitName, 
                      CASE WHEN CM_FangJiSub.DrugFlag = 1 THEN '' ELSE CAST(CM_FangJiDetailSub.LPrice AS varchar) END AS LPrice, 
                      CASE WHEN CM_FangJiSub.DrugFlag = 1 THEN '' WHEN CM_FangJiSub.DrugFlag = 3 THEN CAST(1 * CM_FangJiDetailSub.LPrice AS varchar) 
                      ELSE CAST(CM_FangJiDetailSub.WholeMoney AS varchar) END AS WholeMoney, dbo.CM_FangJiDetailSub.DrugCode, dbo.Gy_DrugDict.Units, dbo.CM_FangJiDetailSub.FangJiSubID
FROM         dbo.CM_FangJiDetailSub LEFT OUTER JOIN
                      dbo.Gy_DrugDict ON dbo.Gy_DrugDict.DrugCode = dbo.CM_FangJiDetailSub.DrugCode LEFT OUTER JOIN
                      dbo.Gy_Unit ON dbo.Gy_Unit.UnitCode = dbo.Gy_DrugDict.Units LEFT OUTER JOIN
                      dbo.CM_FangJiSub ON dbo.CM_FangJiSub.FangJiSubID = dbo.CM_FangJiDetailSub.FangJiSubID LEFT OUTER JOIN
                      dbo.Gy_DetailItem ON dbo.Gy_DetailItem.DetailItemCode = dbo.CM_FangJiDetailSub.DrugCode	
--CM_V_DrugByPrescription 根据选中的论治结果里的方剂编码获取该方剂里的草药信息
SELECT     dbo.Gy_PrescriptionSub.PrescriptionCode, dbo.Gy_PrescriptionSub.DrugCode, dbo.Gy_PrescriptionSub.PrescriptionSubID, dbo.Gy_PrescriptionSub.Quanitity, 
dbo.Gy_PrescriptionSub.SufferTypeCode, dbo.Gy_PrescriptionSub.JFlag, dbo.Gy_PrescriptionSub.CFlag, dbo.Gy_PrescriptionSub.ZFlag, dbo.Gy_PrescriptionSub.SFlag, 
dbo.Gy_PrescriptionSub.Remark, dbo.Gy_DrugDict.DrugName, dbo.Gy_Unit.UnitName, ISNULL(dbo.Gy_SufferType.SufferTypeName, '') AS SufferTypeName, '' AS MinutesValue
FROM         dbo.Gy_PrescriptionSub LEFT OUTER JOIN
dbo.Gy_DrugDict ON dbo.Gy_DrugDict.DrugCode = dbo.Gy_PrescriptionSub.DrugCode LEFT OUTER JOIN
dbo.Gy_Unit ON dbo.Gy_Unit.UnitCode = dbo.Gy_DrugDict.Units LEFT OUTER JOIN
dbo.Gy_SufferType ON dbo.Gy_SufferType.SufferTypeCode = dbo.Gy_PrescriptionSub.SufferTypeCode
--
CREATE FUNCTION [dbo].[CM_Fun_GetCheckItemValue]
(
 @EmpBasicMainID int=0,
 @SummaryCode char(20)='',
 @CheckFlag int=0 
)
returns varchar(1000)  
as
begin
  declare @ReturnValue varchar(8000)
  set @ReturnValue=''
   
	select @ReturnValue=case when ltrim(rtrim(@ReturnValue))<>'' 
	then ltrim(rtrim(@ReturnValue))+' ' else '' end 
	+ rtrim(convert(varchar(50),ISNULL(Gy_DetailItem.DetailItemName,'')))+char(13)+char(13) from CM_CheckSub inner join Gy_DetailItem on Gy_DetailItem.DetailItemCode=CM_CheckSub.DetailItemCode 
	where CM_CheckSub.EmpBasicMainID=@EmpBasicMainID and CM_CheckSub.CheckFlag=@CheckFlag and CM_CheckSub.SummaryCode=@SummaryCode 
		
  return @ReturnValue
end
--/* 功能：获取证型治法界面的兼症舌像脉象列表数据 */  /* 创建人: yuzhiyun */  Gy_V_DiseasePulseTongue
select ltrim(rtrim(A.MainSymptomCode1)) as MainSymptomCode1,ltrim(rtrim(A.DiseaseCode)) as DiseaseCode,A.DiseaseName,
		ltrim(rtrim(A.PulseCode)) as PulseCode,A.PulseName,LTRIM(RTRIM(A.TongueCode)) as TongueCode,A.TongueName
	from (
		select Gy_MainSymptomDisease.MainSymptomCode as MainSymptomCode1,Gy_MainSymptomDisease.DiseaseCode,Gy_Disease.DiseaseName,'' as PulseCode,'' as PulseName,'' as TongueCode,'' as TongueName
		from Gy_MainSymptomDisease left join Gy_Disease on Gy_Disease.DiseaseCode = Gy_MainSymptomDisease.DiseaseCode
		union
		select Gy_MainPulse.MainSymptomCode as MainSymptomCode1,'' as DiseaseCode,'' as DiseaseName,Gy_MainPulse.PulseCode,Gy_Pulse.PulseName,'' as TongueCode,'' as TongueName 
		from Gy_MainPulse left join Gy_Pulse on Gy_Pulse.PulseCode = Gy_MainPulse.PulseCode
		union
		select Gy_MainTongue.MainSymptomCode as MainSymptomCode1,'' as DiseaseCode,'' as DiseaseName,'' as PulseCode,'' as PulseName,Gy_MainTongue.TongueCode,Gy_Tongue.TongueName 
		from Gy_MainTongue left join Gy_Tongue on Gy_Tongue.TongueCode = Gy_MainTongue.TongueCode) A
--CM_V_DCW
select distinct Gy_MainSymptom.MainSymptomCode,Gy_MainSymptom.MainSymptomName,Gy_MainSymptom.PinYinCode,
ISNULL(CM_MaxMainSymptom.Soue,0) as Soue,Gy_MainSymptomSystem.SystemCode,
Gy_Cure.CureName,Gy_Cure.PinYinCode as CurePinYinCode,Gy_Dialectical.DialecticalName,
Gy_Dialectical.PinYinCode as DialecticalPinYinCode,
ISNULL(Gy_ChineseMedicine.ChineseMedicineName,'') ChineseMedicineName,Gy_MainSymptom.ChineseMedicineCode,
Gy_DialectcalWesternMedicine.WesternMedicineCode,
ISNULL(Gy_WesternMedicine.WesternMedicineName,'') WesternMedicineName,CM_MaxMainSymptom.UserCode,Gy_User.DeptCode
from Gy_MainSymptom left join Gy_MainSymptomSystem on Gy_MainSymptomSystem.MainSymptomCode=Gy_MainSymptom.MainSymptomCode
left join Gy_SymptomOrDosage on Gy_SymptomOrDosage.MainSymptomCode=Gy_MainSymptom.MainSymptomCode 
left join CM_MaxMainSymptom on CM_MaxMainSymptom.MainSymptomCode=Gy_MainSymptom.MainSymptomCode               
left outer join Gy_DialecticalMainSymptom on Gy_DialecticalMainSymptom.MainSymptomCode=Gy_MainSymptom.MainSymptomCode
left outer join Gy_CureDialectical on Gy_CureDialectical.DialecticalCode=Gy_DialecticalMainSymptom.DialecticalCode
and Gy_DialecticalMainSymptom.MainSymptomCode=Gy_CureDialectical.MainSymptomCode
left outer join Gy_Dialectical on Gy_Dialectical.DialecticalCode=Gy_DialecticalMainSymptom.DialecticalCode
left outer join Gy_Cure on Gy_Cure.CureCode=Gy_CureDialectical.CureCode
left join Gy_ChineseMedicine on Gy_MainSymptom.ChineseMedicineCode=Gy_ChineseMedicine.ChineseMedicineCode left outer join
Gy_DialectcalWesternMedicine on Gy_DialecticalMainSymptom.MainSymptomCode=Gy_DialectcalWesternMedicine.MainSymptomCode
and  Gy_DialecticalMainSymptom.DialecticalCode=Gy_DialectcalWesternMedicine.DialecticalCode        
left join Gy_WesternMedicine on Gy_DialectcalWesternMedicine.WesternMedicineCode=Gy_WesternMedicine.WesternMedicineCode 
left outer join Gy_User on CM_MaxMainSymptom.UserCode=Gy_User.UserCode
 --
 Text
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* wjg add */
/* 功能: 保存兼症、脉象、舌像、治则、方剂的关系 */

CREATE PROCEDURE [dbo].[Gy_Sp_DialecticalDiseaseCurePrescription] 
	@DialecticalCode char(20)='',			--症型编码
	@MainSymptomCode char(20)='',			--主症编码
	@DiseaseCode nvarchar(1000)='',			--症型与兼症的关系
	@PulseCode nvarchar(1000)='',			--症型与脉象的关系
	@TongueCode nvarchar(1000)='',			--症型与舌像的关系
	@CureCode nvarchar(1000),				--症型与治则关系
	@PrescriptionCode char(20)='',			--治则与处方关系
	@PrescriptionCureCode nvarchar(1000),	--治则方剂编码
	@WesternMedicineCode  nvarchar(1000)='' --西医病名编码
	
AS
	if ISNULL(@DialecticalCode,'') = '' and ISNULL(@MainSymptomCode,'') = ''
		return
		
	else
	begin	
		delete from Gy_DiseaseOrDialectical where DialecticalCode=@DialecticalCode and MainSymptomCode=@MainSymptomCode
		delete from Gy_CureDialectical where DialecticalCode=@DialecticalCode and MainSymptomCode=@MainSymptomCode	
	    delete from Gy_DialectcalWesternMedicine where DialecticalCode=@DialecticalCode and MainSymptomCode=@MainSymptomCode	
	end
	
	--创建症型兼症关系临时表
	if object_id('tempdb..#DialecticalDisease') is not null   
		drop table [dbo].[#DialecticalDisease]
	create table #DialecticalDisease
	(		
		DiseaseCodeValue	varchar(100)
	)
	--创建症型脉象关系临时表
	if object_id('tempdb..#DialecticalPulse') is not null   
		drop table [dbo].[#DialecticalPulse]
	create table #DialecticalPulse
	(		
		PulseCodeValue	varchar(100)
	)
	--创建症型舌像关系临时表
	if object_id('tempdb..#DialecticalTongue') is not null   
		drop table [dbo].[#DialecticalTongue]
	create table #DialecticalTongue
	(		
		TongueCodeValue	varchar(100)
	)
	
	--创建治则方剂关系临时表
	if object_id('tempdb..#PrescriptionCure') is not null   
		drop table [dbo].[#PrescriptionCure]
	create table #PrescriptionCure
	(		
		PrescriptionCureStr	varchar(100)
	)
	--插入新关系
		
	--兼症
	if isnull(@DiseaseCode,'')<>''
	begin
		insert into #DialecticalDisease(DiseaseCodeValue) select code from Gy_Fun_ReturnRecordset(@DiseaseCode)
		
		insert into Gy_DiseaseOrDialectical (MainSymptomCode,DiseaseCode,WeightValue,DialecticalCode)  
		select @MainSymptomCode,SUBSTRING(DiseaseCodeValue,1,CHARINDEX('|',DiseaseCodeValue)-1),
		cast(SUBSTRING(ltrim(rtrim(DiseaseCodeValue)),CHARINDEX('|',ltrim(rtrim(DiseaseCodeValue)))+1,LEN(ltrim(rtrim(DiseaseCodeValue)))-CHARINDEX('|',ltrim(rtrim(DiseaseCodeValue)))) as decimal),
		@DialecticalCode from #DialecticalDisease
			
	end
	
	select * from #DialecticalDisease
	--脉象
	if isnull(@PulseCode,'')<>''
	begin
		insert into #DialecticalPulse(PulseCodeValue) select code from Gy_Fun_ReturnRecordset(@PulseCode)
		
		insert into Gy_DiseaseOrDialectical (MainSymptomCode,PulseCode,WeightValue,DialecticalCode)
		select @MainSymptomCode,SUBSTRING(PulseCodeValue,1,CHARINDEX('|',PulseCodeValue)-1),
		cast(SUBSTRING(ltrim(rtrim(PulseCodeValue)),CHARINDEX('|',ltrim(rtrim(PulseCodeValue)))+1,LEN(ltrim(rtrim(PulseCodeValue)))-CHARINDEX('|',ltrim(rtrim(PulseCodeValue)))) as decimal),
		@DialecticalCode from #DialecticalPulse	
			
	end
	
	
	--舌像
	if isnull(@TongueCode,'')<>''
	begin
		insert into #DialecticalTongue(TongueCodeValue) select code from Gy_Fun_ReturnRecordset(@TongueCode)			
			   
		insert into Gy_DiseaseOrDialectical (MainSymptomCode,TongueCode,WeightValue,DialecticalCode) 
		select @MainSymptomCode,SUBSTRING(TongueCodeValue,1,CHARINDEX('|',TongueCodeValue)-1),
		cast(SUBSTRING(ltrim(rtrim(TongueCodeValue)),CHARINDEX('|',ltrim(rtrim(TongueCodeValue)))+1,LEN(ltrim(rtrim(TongueCodeValue)))-CHARINDEX('|',ltrim(rtrim(TongueCodeValue)))) as decimal),
		@DialecticalCode from #DialecticalTongue	
			
	end
	
	if rtrim(isnull(@WesternMedicineCode,''))<>''
	begin
	    delete from CM_FangjiDetailSubValue
		insert into CM_FangjiDetailSubValue(FangjiDetailSubValue) select code from Gy_Fun_ReturnRecordset(@WesternMedicineCode)
		
		insert into Gy_DialectcalWesternMedicine(MainSymptomCode,DialecticalCode,WesternMedicineCode)
		select @MainSymptomCode,@DialecticalCode,
		SUBSTRING(ltrim(rtrim(FangjiDetailSubValue)),CHARINDEX('|',ltrim(rtrim(FangjiDetailSubValue)))+1,LEN(ltrim(rtrim(FangjiDetailSubValue)))-CHARINDEX('|',ltrim(rtrim(FangjiDetailSubValue)))) 
	    from CM_FangjiDetailSubValue			
	end
	
	
	if isnull(@PrescriptionCureCode,'')<>''
	begin
		insert into #PrescriptionCure(PrescriptionCureStr) select code from Gy_Fun_ReturnRecordset(@PrescriptionCureCode)
		
		select * from #PrescriptionCure
		
		insert into Gy_CureDialectical (DialecticalCode,CureCode,PrescriptionCode,MainSymptomCode,ZJPrescriptionCode)
		select @DialecticalCode,SUBSTRING(PrescriptionCureStr,1,CHARINDEX('|',PrescriptionCureStr)-1),
		NULLIF(SUBSTRING(ltrim(rtrim(PrescriptionCureStr)),CHARINDEX('|',ltrim(rtrim(PrescriptionCureStr)))+1,LEN(ltrim(rtrim(PrescriptionCureStr)))-len(ltrim(ltrim(SUBSTRING(PrescriptionCureStr,1,CHARINDEX('|',PrescriptionCureStr)-1))))-LEN(ltrim(rtrim(SUBSTRING(ltrim(rtrim(PrescriptionCureStr)),CHARINDEX(';',ltrim(rtrim(PrescriptionCureStr)))+1,LEN(ltrim(rtrim(PrescriptionCureStr)))))))-2) ,'*'),
		@MainSymptomCode,
		NULLIF( SUBSTRING(ltrim(rtrim(PrescriptionCureStr)),CHARINDEX(';',ltrim(rtrim(PrescriptionCureStr)))+1,LEN(ltrim(rtrim(PrescriptionCureStr)))) ,'*')
		from #PrescriptionCure

	end

--从上面摘录 
select '10511',SUBSTRING(DiseaseCodeValue,1,CHARINDEX('|',DiseaseCodeValue)-1),
		cast(SUBSTRING(ltrim(rtrim(DiseaseCodeValue)),CHARINDEX('|',ltrim(rtrim(DiseaseCodeValue)))+1,LEN(ltrim(rtrim(DiseaseCodeValue)))-CHARINDEX('|',ltrim(rtrim(DiseaseCodeValue)))) as decimal),
		'12666' from #DialecticalDisease
--
  Exec Gy_Sp_DialecticalDiseaseCurePrescription @DialecticalCode='12666',@MainSymptomCode='10511',@DiseaseCode='11037|5,11106|7,11937|3,12088|1,12426|2,13400|8,14075|5,14930|6',@PulseCode='11037|5,11106|7,11937|3,12088|1,12426|2,13400|8,14075|5,14930|6',@TongueCode='',@CureCode='10804,10804,10002',@PrescriptionCode='14809,,',@PrescriptionCureCode='10804|14809;*,10804|*;12887,10002|*;12887',@WesternMedicineCode='01.011'
--
Exec Gy_Sp_DialecticalDiseaseCurePrescription @DialecticalCode='10003',@MainSymptomCode='10251',@DiseaseCode='10607|8,11043|7,13894|6,14073|6,14375|9,14608|6',@PulseCode='10262|2',@TongueCode='10250|2',@CureCode='11114,11114,10002',@PrescriptionCode='10441,,',@PrescriptionCureCode='11114|10441;*,11114|*;12887,10002|*;12887'
  

6228 4807 4130 7436 419
15872933486
--Gy_sp_GetMDCure
CREATE procedure [dbo].[Gy_sp_GetMDCure]
@MDMainID int,
@MDSubID  int

as
begin
  select Gy_MDCureSub.MDMainID,Gy_MDSub.DialecticalCode,Gy_Dialectical.DialecticalName,Gy_MDCureSub.MDSubID,Gy_MDCureSub.CureCode,Gy_Cure.CureName,
		Gy_MDCureSub.MDCureSubID,a.PrescriptionCode,a.PrescriptionName,
		b.PrescriptionCode as ZJPrescriptionCode,b.PrescriptionName as ZJPrescriptionName
	  from Gy_MDCureSub 
	    left join Gy_Cure on Gy_MDCureSub.CureCode =Gy_Cure.CureCode
		left join Gy_PrescriptionMain as a on  Gy_MDCureSub.PrescriptionCode = a.PrescriptionCode AND a.DrugFlag=0
		left join Gy_PrescriptionMain as b on Gy_MDCureSub.PrescriptionCode = b.PrescriptionCode  AND b.DrugFlag=1
		left join Gy_MDSub on Gy_MDSub.MDMainID=Gy_MDCureSub.MDMainID and Gy_MDSub.MDSubID=Gy_MDCureSub.MDSubID
		left join Gy_Dialectical on Gy_Dialectical.DialecticalCode=Gy_MDSub.DialecticalCode  
	 where Gy_MDCureSub.MDMainID =@MDMainID and Gy_MDCureSub.MDSubID=@MDSubID 
	  end
--
exec Gy_sp_GetMDCure @MDMainID='4011',@MDSubID='46058'
--
create FUNCTION [dbo].[CM_Fun_GetPrescriptionValue]
(
@PrescriptionCode varchar(20)
)
returns varchar(8000)  
as
begin
  declare @ReturnValue varchar(8000)
  set @ReturnValue=''

select @ReturnValue=case when ltrim(rtrim(@ReturnValue))<>'' 
then ltrim(rtrim(@ReturnValue))+' ' else '' end
+ltrim(Gy_DrugDict.DrugName)+space(1+(7-LEN(Gy_DrugDict.DrugName))*1.5)
+convert(char(5),ltrim(cast(Gy_PrescriptionSub.Quanitity as float))+Gy_Unit.UnitName)+'|' 
 from Gy_PrescriptionSub inner join 
 Gy_DrugDict on Gy_DrugDict.DrugCode=Gy_PrescriptionSub.DrugCode inner join
 Gy_Unit on Gy_Unit.UnitCode=Gy_DrugDict.Units   
 where Gy_PrescriptionSub.PrescriptionCode=@PrescriptionCode and DrugFlag=0 order by Gy_PrescriptionSub.PrescriptionSubID

return @ReturnValue

end
--
CREATE PROCEDURE [dbo].[CM_Sp_DeptWorkloadStatistics_1]
	@BeginDate datetime,
	@Enddate datetime,
	@UserCode varchar(50)=''
as
select  
   CC.DeptCode,CC.DeptName,SUM (CC.DeptNum) as DeptNum , SUM(CC.SumZMoney) as SumZMoney,SUM (CC.SumZJMoney)as SumZJMoney  ,SUM (CC.SumWMoney) as  SumWMoney,SUM (CC.SumCheckMoney) as SumCheckMoney,SUM (SumInspectionMoney) as  SumInspectionMoney from 
		(
		select CM_EmpBasicMain.DeptCode,Gy_DeptMent.DeptName,COUNT(CM_EmpBasicMain.RegistrationNum) as DeptNum,
			SUM(ISNULL(A.ZMoney,0)) as SumZMoney,SUM(ISNULL(A.ZJMoney,0)) as SumZJMoney,SUM(ISNULL(A.WMoney,0)) as SumWMoney,
			SUM(ISNULL(A.CheckMoney,0)) as SumCheckMoney,SUM(ISNULL(A.InspectionMoney,0)) as SumInspectionMoney,CM_EmpBasicMain.UserCode 
	from CM_EmpBasicMain 
		left outer join Gy_DeptMent on Gy_DeptMent.DeptCode=CM_EmpBasicMain.DeptCode 
		left outer join ( select EmpBasicMainID,SUM(ZMoney) as ZMoney,SUM(ZJMoney) as ZJMoney,SUM(WMoney) as WMoney,  SUM(CheckMoney) as CheckMoney, 
								 SUM(InspectionMoney) as InspectionMoney 
						  from (select CM_FangJiSub.EmpBasicMainID, 
										case when DrugFlag=0 then ISNULL(WholeMoney,0) else 0 end as ZMoney,
										case when DrugFlag=1 then ISNULL(WholeMoney,0) else 0 end as ZJMoney,
										case when DrugFlag=2 then ISNULL(WholeMoney,0) else 0 end as WMoney,										
										0 as CheckMoney,0 as InspectionMoney
								from CM_FangJiSub left join CM_FangJiDetailSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID
								union all
								select CM_CheckSub.EmpBasicMainID,0 as ZMoney,0 as ZJMoney,0 as WMoney,
										case when Gy_DetailItem.DetailItemFlag=0 then ISNULL(Price,0) else 0 end as CheckMoney,
										case when Gy_DetailItem.DetailItemFlag=1 then ISNULL(Price,0) else 0 end as InspectionMoney
								from CM_CheckSub left outer join Gy_DetailItem on CM_CheckSub.DetailItemCode=Gy_DetailItem.DetailItemCode
							   ) f 
						  group by EmpBasicMainID
						 ) A  on CM_EmpBasicMain.EmpBasicMainID=A.EmpBasicMainID
	where CM_EmpBasicMain.UserCode in (select Gy_UserQueryRight.QueryUserCode from Gy_UserQueryRight where Gy_UserQueryRight.UserCode=@UserCode and BusTypeCode='10') and CM_EmpBasicMain.MakeDate>=@BeginDate and CM_EmpBasicMain.MakeDate<=@Enddate 
	group by CM_EmpBasicMain.DeptCode,Gy_DeptMent.DeptName,CM_EmpBasicMain.UserCode
	
	)
	CC   group by CC.DeptCode,CC.DeptName  order by CC.DeptCode

--
exec CM_Sp_DeptWorkloadStatistics_1 @BeginDate='2016-01-25 00:00:00',@Enddate='2015-01-26 00:00:00',@UserCode='xyt001'
--
-- Author:		<cf>
-- Create date: <2016-01-18>
-- Description:	<自动生成编码>
-- =============================================
CREATE PROCEDURE [dbo].[Gy_Sp_GetCode]
@TableName nvarchar(100),
@Code int output
AS
BEGIN
if @TableName='藏医编码'
begin
select @Code=isnull(MAX(ZWMedicineCode)+1,1000) from Gy_ZWMedicine;
select @Code 
end

if @TableName='藏药字典'
begin
select @Code=isnull(MAX(DrugCode)+1,1000) from Gy_DrugDict;
select @Code 
end

if @TableName='藏药处方编码'
begin
select @Code=isnull(MAX(PrescriptionCode)+1,1000) from Gy_PrescriptionMain;
select @Code 
end

if @TableName='门诊挂号序号ID'
begin
select @Code=isnull(MAX(RegistrationNumMainID)+1,100) from CM_HISEmpBasicMain;
select @Code 
end

END
--
exec Gy_Sp_GetCode @TableName='藏药字典',@Code=0

--CM_V_FJSub功能： 获取方剂子表信息（中药、针灸、西药、临床治疗） 创建人：yzy 20150827
CREATE view [dbo].[CM_V_FJSub]
	as
		
		select  case when CM_FangJiSub.DrugFlag=3 then Gy_DetailITem.DetailItemName else Gy_DrugDict.DrugName end as DrugName,
				case when CM_FangJiSub.DrugFlag=1 then '' 
					 when CM_FangJiSub.DrugFlag=3 then '1'	
					 else cast(CM_FangJiDetailSub.Quanitity as varchar) end as Quanitity,
				Gy_Unit.UnitName,
				case when CM_FangJiSub.DrugFlag=1 then '' else cast(CM_FangJiDetailSub.LPrice as varchar) end as LPrice,
				case when CM_FangJiSub.DrugFlag=1 then '' 
					 when CM_FangJiSub.DrugFlag=3 then cast(1 * CM_FangJiDetailSub.LPrice as varchar) 
					 else cast(CM_FangJiDetailSub.WholeMoney as varchar) end as WholeMoney,
				CM_FangJiDetailSub.DrugCode,Gy_DrugDict.Units,CM_FangJiDetailSub.FangJiSubID
		from CM_FangJiDetailSub left join Gy_DrugDict on Gy_DrugDict.DrugCode=CM_FangJiDetailSub.DrugCode
								left join Gy_Unit on Gy_Unit.UnitCode=Gy_DrugDict.Units 
								left join CM_FangJiSub on CM_FangJiSub.FangJiSubID=CM_FangJiDetailSub.FangJiSubID
								left join Gy_DetailITem on Gy_DetailITem.DetailItemCode=CM_FangJiDetailSub.DrugCode

--Gy_Sp_SaveWesternCureFinishFangjiDetail
CREATE PROCEDURE [dbo].[Gy_Sp_SaveWesternCureFinishFangjiDetail]
   @OperaType int=0,					--操作类型：0 新增；1修改
   @FangJiSubCode varchar(20)='',		--方剂编码
   @FangJiSubID int=0,				    --方剂ID
   @EmpBasicMainID int=0,
   @DetailCodeValue varchar(1000)='',		--明细编码
   @ConsumptionValue varchar(1000)='',	--用量   
   @DrugWayCodeValue varchar(1000)='',	--用药方式
   @FrequencyCodeValue varchar(1000)='',--用药频率
   @UseDaysValue varchar(1000)='',		--用药天数
   @TotalAmountValue varchar(1000)='',	--总量
   @QuanitityValue varchar(1000)='',	--领量
   @LPriceValue	varchar(1000)='',		--单价
   @WholeMoneyValue varchar(1000)=''			--金额
as
	--通过@DetailCodeValue是否有值判断有没有明细项目，如果没有处方明细就删除处方主表信息
	if ISNULL(@DetailCodeValue,'')=''
	begin
		delete from CM_FangJiSub where CM_FangJiSub.FangJiSubID=@FangJiSubID and CM_FangJiSub.EmpBasicMainID=@EmpBasicMainID and DrugFlag=3 
		return
	end	
	
	--创建明细项目编码临时表
	if object_id('tempdb..#WesternCureDrug') is not null   
		drop table [dbo].[#WesternCureDrug]
	create table #WesternCureDrug
	(		
		DetailCode char(20),
		Consumption decimal(20,6),	--用量   
	    DrugWayCode char(20),	--用药方式
	    FrequencyCode char(20),--用药频率
	    UseDays int,		--用药天数
	    TotalAmount decimal(20,6),	--总量
	    Quanitity decimal(20,6),	--领量
	    LPrice	decimal(20,6),		--单价
		WholeMoney decimal(20,6)	--金额	
	)
	
	if isnull(@DetailCodeValue,'')<>''
	begin
		insert into #WesternCureDrug(DetailCode) select code from Gy_Fun_ReturnRecordset(@DetailCodeValue) 
	end
	
	--向临时表中更新用量
	if isnull(@ConsumptionValue,'')<>''
	begin
		update #WesternCureDrug set Consumption=B.Consumption
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then 0 
			 else convert(decimal(20,6),REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'')) end as Consumption 
		from (select code from Gy_Fun_ReturnRecordset(@ConsumptionValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	--向临时表中更新用药方式
	if isnull(@DrugWayCodeValue,'')<>''
	begin
		update #WesternCureDrug set DrugWayCode=B.DrugWayCode
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then '' 
			 else REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'') end as DrugWayCode 
		from (select code from Gy_Fun_ReturnRecordset(@DrugWayCodeValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	--向临时表中更新用药方式
	if isnull(@FrequencyCodeValue,'')<>''
	begin
		update #WesternCureDrug set FrequencyCode=B.FrequencyCode
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then '' 
			 else REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'') end as FrequencyCode 
		from (select code from Gy_Fun_ReturnRecordset(@FrequencyCodeValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	--向临时表中更新天数
	if isnull(@UseDaysValue,'')<>''
	begin
		update #WesternCureDrug set UseDays=B.UseDays
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then '' 
			 else convert(int,REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'')) end as UseDays 
		from (select code from Gy_Fun_ReturnRecordset(@UseDaysValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end	

 --  @WholeMoney varchar(1000)=''			--金额
	
	--向临时表中更新总量
	if isnull(@TotalAmountValue,'')<>''
	begin
		update #WesternCureDrug set TotalAmount=B.TotalAmount
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then 0 
			 else convert(decimal(20,6),REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'')) end as TotalAmount 
		from (select code from Gy_Fun_ReturnRecordset(@TotalAmountValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	--向临时表中更新领量
	if isnull(@QuanitityValue,'')<>''
	begin
		update #WesternCureDrug set Quanitity=B.Quanitity
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then 0 
			 else convert(decimal(20,6),REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'')) end as Quanitity 
		from (select code from Gy_Fun_ReturnRecordset(@QuanitityValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	--向临时表中更新单价
	if isnull(@LPriceValue,'')<>''
	begin
		update #WesternCureDrug set LPrice=B.LPrice
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then 0 
			 else convert(decimal(20,6),REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'')) end as LPrice 
		from (select code from Gy_Fun_ReturnRecordset(@LPriceValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	--向临时表中更新金额
	if isnull(@WholeMoneyValue,'')<>''
	begin
		update #WesternCureDrug set WholeMoney=B.WholeMoney
		from
		(select SUBSTRING(A.code,1,CHARINDEX('|',A.Code)-1) as DetailCode,
		case when len(REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),''))=0 then 0 
			 else convert(decimal(20,6),REPLACE(A.Code,SUBSTRING(A.code,1,CHARINDEX('|',A.Code)),'')) end as WholeMoney 
		from (select code from Gy_Fun_ReturnRecordset(@WholeMoneyValue)) A) B 
		where #WesternCureDrug.DetailCode=B.DetailCode
	end
	
	select * from #WesternCureDrug
	
	--新增  向CM_FangJiDetailSub插入西药处方明细	
	if @OperaType=0
	begin	
		declare @FJSubID int
		select @FJSubID=FangJiSubID from CM_FangJiSub where EmpBasicMainID=@EmpBasicMainID and DrugFlag=3 and FangJiSubCode=@FangJiSubCode
		
		insert into CM_FangJiDetailSub(DrugCode,FangJiSubID,Consumption,DrugWayCode,FrequencyCode,UseDays,TotalAmount,
										Quanitity,LPrice,WholeMoney,SufferTypeCode)
		select #WesternCureDrug.DetailCode,@FJSubID,#WesternCureDrug.Consumption,#WesternCureDrug.DrugWayCode,
				#WesternCureDrug.FrequencyCode,#WesternCureDrug.UseDays,#WesternCureDrug.TotalAmount,#WesternCureDrug.Quanitity,
				#WesternCureDrug.LPrice,#WesternCureDrug.WholeMoney,'' as SufferTypeCode from #WesternCureDrug
	end
	
	--修改  向CM_FangJiDetailSub更新西药处方明细(先删除后插入)
	if @OperaType=1
	begin	
		delete from CM_FangJiDetailSub where FangJiSubID=@FangJiSubID
		insert into CM_FangJiDetailSub(DrugCode,FangJiSubID,Consumption,DrugWayCode,FrequencyCode,UseDays,TotalAmount,
										Quanitity,LPrice,WholeMoney,SufferTypeCode)
		select #WesternCureDrug.DetailCode,@FangJiSubID,#WesternCureDrug.Consumption,#WesternCureDrug.DrugWayCode,
				#WesternCureDrug.FrequencyCode,#WesternCureDrug.UseDays,#WesternCureDrug.TotalAmount,#WesternCureDrug.Quanitity,
				#WesternCureDrug.LPrice,#WesternCureDrug.WholeMoney,'' as SufferTypeCode from #WesternCureDrug
	end
--
exec Gy_Sp_SaveWesternCureFinishFangjiDetail 0,@FangJiSubCode='15148',@FangJiSubID=0,@EmpBasicMainID='12112',@DetailCodeValue='XD001',@ConsumptionValue='XD001|0',@DrugWayCodeValue='XD001|',@FrequencyCodeValue='XD001|',@UseDaysValue='XD001|0',@TotalAmountValue='XD001|0',@QuanitityValue='XD001|0',@LPriceValue='XD001|27.00',@WholeMoneyValue='XD001|0.00'

--
/* 创建人:yuzhiyun */
/* 功能: 保存主症与归经、脉象、舌像、兼症的关系 */
CREATE PROCEDURE [dbo].[Gy_Sp_MainMeridianPulseTongue] 
	@MainSymptomCode	char(20)=null,		--主症编码	
	@MeridianCode		nvarchar(1000)='',		--归经编码
	@PulseCode			nvarchar(2000)='',		--脉象编码
	@TongueCode			nvarchar(2000)='',		--舌像编码
	@DiseaseCode		nvarchar(2000)='',		--兼症编码
	@SystemCode			nvarchar(1000)=''		--系统编码
	
AS	
		
	if not exists(select * from Gy_MainSymptom where MainSymptomCode=@MainSymptomCode)
		return
	else
	begin
		delete from Gy_MainMeridian where MainSymptomCode=@MainSymptomCode		
		delete from Gy_MainPulse where MainSymptomCode=@MainSymptomCode		
		delete from Gy_MainTongue where MainSymptomCode=@MainSymptomCode
		delete from Gy_MainSymptomDisease where MainSymptomCode=@MainSymptomCode
		delete from Gy_MainSymptomSystem where MainSymptomCode=@MainSymptomCode
	end
	
	--创建主症脉象关系临时表
	if object_id('tempdb..#MainPulse') is not null   
		drop table [dbo].[#MainPulse]
	create table #MainPulse
	(		
		PulseCodeValue	varchar(100)
	)
	--创建主症归经舌像关系临时表
	if object_id('tempdb..#MainTongue') is not null 
		drop table [dbo].[#MainTongue]
	create table #MainTongue
	(		
		TongueCodeValue	char(100)	
	)
	
	--插入新关系
	
	--归经	
	if isnull(@MeridianCode,'')<>'' 
	begin	
		insert into Gy_MainMeridian(MainSymptomCode,MeridianCode) select @MainSymptomCode,code from Gy_Fun_ReturnRecordset(@MeridianCode)	
	end		
	
	
	--脉象
	
	if isnull(@PulseCode,'')<>'' 
	begin	
		insert into Gy_MainPulse(MainSymptomCode,PulseCode) select @MainSymptomCode,code from Gy_Fun_ReturnRecordset(@PulseCode)	
	end	
	
	--舌像		
	
	if isnull(@TongueCode,'')<>'' 
	begin	
		insert into Gy_MainTongue(MainSymptomCode,TongueCode) select @MainSymptomCode,code from Gy_Fun_ReturnRecordset(@TongueCode)	
	end	
	
	
	--兼症
	print '兼症关系'
	print @DiseaseCode
	if isnull(@DiseaseCode,'')<>'' 
	begin	
		insert into Gy_MainSymptomDisease(MainSymptomCode,DiseaseCode) select @MainSymptomCode,code from Gy_Fun_ReturnRecordset(@DiseaseCode)	
	end	
	select * from Gy_MainSymptomDisease
	
	--系统
	if isnull(@SystemCode,'')<>'' 
	begin	
		insert into Gy_MainSymptomSystem(MainSymptomCode,SystemCode) select @MainSymptomCode,code from Gy_Fun_ReturnRecordset(@SystemCode)	
	end		
	
--
exec Gy_Sp_MainMeridianPulseTongue @MainSymptomCode='10001',@MeridianCode='01,03,07,11,20,22,25,46',@PulseCode='10010,10014,10261,10160,10199,10206,10216',@TongueCode='10268,10271,10274,10278,10342,10465',@DiseaseCode='14073,10632,10942,14102,14499,10951,14488,11037,12662,13538,10781,12132,10229,10939,12106,14839,11096,14404,14731,14346,10949,13386,12813,10952,10940,10941,14311,12231,14615,14765,12795,14917,14783,14788,14469,13427,10001,10002,10003,10711,11957,11052',@SystemCode='01'

--
/* 创建人：yuzhiyun */ 功能：保存中医病名和处方的关系 
CREATE PROCEDURE [dbo].[Gy_Sp_ChineseMedicinePrescription] 
	@ChineseMedicineCode char(20)='',				--中医病名编码 	
	@PrescriptionCode nvarchar(1000)	--与中医病名与处方的关系
	
AS
		
	if not exists(select 1 from Gy_ChineseMedicine where ChineseMedicineCode=@ChineseMedicineCode)
	begin
		return
	end
	else
	begin
		delete from Gy_CMedicinePrescription where ChineseMedicineCode=@ChineseMedicineCode
		
		if isnull(@PrescriptionCode,'')<>'' 
		begin
			insert into Gy_CMedicinePrescription(ChineseMedicineCode,PrescriptionCode) 
			select @ChineseMedicineCode,code from Gy_Fun_ReturnRecordset(@PrescriptionCode)	
		end		
	end
--
exec Gy_Sp_ChineseMedicinePrescription @ChineseMedicineCode='11292',@PrescriptionCode='10009,10012'






							
