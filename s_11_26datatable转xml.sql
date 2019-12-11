--��ɰ�
CREATE PROCEDURE [dbo].[CM_Sp_Test]
 @EmpBasicMainID  int,
 --@EmpTZPDMainID int,    --0325
 --@EmpTZPDItemSubID int, --0325
 @Maker char(20),
 @TZPDXml xml
as 
	--�����ж�����
	if  EXISTS(select * from Gy_TZPDItem where EmpBasicMainID=@EmpBasicMainID)
	begin
		delete from Gy_TZPDItem where EmpBasicMainID=@EmpBasicMainID
	end
	declare @docHandle int	
	
	--ϵͳ���ô洢���� ��������xml����
	Exec sp_xml_preparedocument @docHandle OUTPUT,@TZPDXml
	
	insert into Gy_TZPDItem(EmpBasicMainID,EmpTZPDMainID,EmpTZPDItemSubID,TZPDItemCode,NoFlag,FewFlag,LittleFlag,OftenFlag,AllFlag)
	SELECT * FROM OPENXML(@docHandle,'/DocumentElement/TZPDTemp',3)
	with
	(
	EmpBasicMainID int,
	--EmpTZPDMainID int,  --0325
	--EmpTZPDItemSubID int, --0325 
	TZPDItemCode char(20),
	NoFlag bit,
	FewFlag bit,
	LittleFlag bit,
	OftenFlag bit,
	AllFlag bit	
	) 
	--����ԭʼ�� 
	--����ת����
			declare  @PHTZTypeCode decimal(18,6), --ƽ�����ʷ���
			  @QXTZTypeCode decimal(18,6),--�������ʷ���
			 @YXTZTypeCode decimal(18,6),--�������ʷ���
			 @YinXTZTypeCode decimal(18,6),--�������ʷ���
			 @TSTZTypeCode decimal(18,6),--̵ʪ���ʷ���
			 @SRTZTypeCode decimal(18,6),--ʪ�����ʷ���
			 @XYTZTypeCode decimal(18,6),--Ѫ�����ʷ���
			 @QYTZTypeCode decimal(18,6),--�������ʷ���
			 @TBTZTypeCode decimal(18,6) --�������ʷ���	 
	if  exists(select * from tempdb.dbo.sysobjects where[name]='#PSco')
	begin
		  drop table[dbo].[#PSco]
	end
	  select *  into #PSco from (  
select *, ConverSoce =
(((C.PScore-C.Pcount)*0.1)/((C.Pcount*4)*0.1))*100
from 
(select A.TZTypeCode,A.TZTypeName ,A.PScore,B.Pcount from (
select  Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName,
SUM(case 
when NoFlag=1 and OrderFlag=0 then 1
when NoFlag=1 and OrderFlag=1 then 5
     when FewFlag=1 and OrderFlag=0 then 2 
     when FewFlag=1 and OrderFlag=1 then 4
     when LittleFlag=1 and OrderFlag=0 then 3
      when LittleFlag=1 and OrderFlag=1 then 3
when OftenFlag=1 and OrderFlag=0 then 4 
when OftenFlag=1 and OrderFlag=1 then 2
when AllFlag=1 and OrderFlag=0 then 5
when AllFlag=1 and OrderFlag=1 then 1
  else 0 end) as PScore  
from Gy_TZPDItem inner join Gy_TZPDItemSet on Gy_TZPDItemSet.TZPDItemCode=Gy_TZPDItem.TZPDItemCode 
inner join Gy_TZType on Gy_TZType.TZTypeCode=Gy_TZPDItemSet.TZTypeCode
where EmpBasicMainID=@EmpBasicMainID  and  EmpTZPDItemSubID=@EmpTZPDItemSubID 
group by Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName) A inner join (
 
Select Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName,COUNT(*) as Pcount
from Gy_TZPDItem inner join Gy_TZPDItemSet on Gy_TZPDItemSet.TZPDItemCode=Gy_TZPDItem.TZPDItemCode 
inner join Gy_TZType on Gy_TZType.TZTypeCode=Gy_TZPDItemSet.TZTypeCode
where EmpBasicMainID=@EmpBasicMainID and  EmpTZPDItemSubID=@EmpTZPDItemSubID
group by Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName) B
on A.TZTypeCode=B.TZTypeCode) as C ) as R

	 set @PHTZTypeCode=(select #PSco.Conversoce from  #PSco where TZTypeCode='TZ1009')
	set @QXTZTypeCode=(select #PSco.Conversoce from  #PSco where TZTypeCode='TZ1003')
	set @YXTZTypeCode=(select #PSco.Conversoce from  #PSco where TZTypeCode='TZ1001')
	set @YinXTZTypeCode=(select  #PSco.Conversoce from  #PSco where TZTypeCode='TZ1002')
	set @TSTZTypeCode=(select  #PSco.Conversoce from  #PSco where TZTypeCode='TZ1004')
	set @SRTZTypeCode=(select  #PSco.Conversoce from  #PSco where TZTypeCode='TZ1005')
	set @XYTZTypeCode=(select  #PSco.Conversoce from  #PSco where TZTypeCode='TZ1006')
	set @QYTZTypeCode=(select  #PSco.Conversoce from  #PSco where TZTypeCode='TZ1008')
	set @TBTZTypeCode=(select  #PSco.Conversoce from  #PSco where TZTypeCode='TZ1007')

 
    delete from Gy_TZPDMain where EmpTZPDMainID=@EmpTZPDMainID    --EmpBasicMainID ���� EmpTZPDMainID 
   
	insert into Gy_TZPDMain (EmpBasicMainID,EmpTZPDMainID,PHTZTypeCode,QXTZTypeCode,YXTZTypeCode,YinXTZTypeCode,TSTZTypeCode,
		                         SRTZTypeCode,XYTZTypeCode,QYTZTypeCode,TBTZTypeCode,Maker,MakeDate,STZTypeCode,JBSTZTypeCode,QXSTZTypeCode)  
		            values (@EmpBasicMainID,@EmpTZPDMainID,,@PHTZTypeCode,@QXTZTypeCode,@YXTZTypeCode,@YinXTZTypeCode,@TSTZTypeCode,@SRTZTypeCode,@XYTZTypeCode,@QYTZTypeCode,@TBTZTypeCode,@Maker,CONVERT(varchar(100), GETDATE(),120),'','','')
	
	--�����ж����
		declare  @S Nvarchar(100)='' ,
		@JBS  Nvarchar(50)='',
		@QXS  Nvarchar(100)='' 
 begin
	if @PHTZTypeCode>=60 and  (@QXTZTypeCode<30 and @YXTZTypeCode<30  and @YinXTZTypeCode<30 and  @TSTZTypeCode<30 and @SRTZTypeCode<30 and  @XYTZTypeCode<30 and @QYTZTypeCode<30 and @TBTZTypeCode<30) 
	begin
		 --print 'TZ1009'	  --��ƽ������
		--print @STZTypeCode
		set @S=@S +'TZ1009,'
	end
	else if @PHTZTypeCode>=60 and  (@QXTZTypeCode<40 and @YXTZTypeCode<40  and @YinXTZTypeCode<40 and  @TSTZTypeCode<40 and @SRTZTypeCode<40 and  @XYTZTypeCode<40 and @QYTZTypeCode<40 and @TBTZTypeCode<40)
	begin 
		   set  @JBS='TZ1009,'	--������ƽ������
	end
    else   --����ƽ������
    begin
		 	--print 'TZ1009'	
		 	if @QXTZTypeCode>=40 
		 	begin
		 		--print 'TZ1003'   ----����������
		 		set @S=@S +'TZ1003,'
		 	end
		    else if  @QXTZTypeCode>=30 and @QXTZTypeCode<40
		    begin
		 		--print 'TZ1003'    ----��������������
		 		set @QXS=@QXS+ 'TZ1003,'
		 	end
		 	
		 	if @YXTZTypeCode>=40 
		 	begin
		 		set @S=@S +'TZ1001,'  ----����������
		 	end
		    else if  @YXTZTypeCode>=30 and @YXTZTypeCode<40
		    begin
		 		set @QXS=@QXS+ 'TZ1001,' ----��������������
		 	end
		 	
		 	if @YinXTZTypeCode>=40 
		 	begin
		 		set @S=@S +'TZ1002,'     ----����������
		 	end
		    else if  @YinXTZTypeCode>=30 and @YinXTZTypeCode<40
		    begin
		 				set @QXS=@QXS+ 'TZ1002,'    ----��������������
		 	end
		 	
		 	 	if @TSTZTypeCode>=40 
		 	begin
		 		set @S=@S +'TZ1004,'     ----��̵ʪ����
		 	end
		    else if  @TSTZTypeCode>=30 and @TSTZTypeCode<40
		    begin
		 		set @QXS=@QXS+ 'TZ1004,'       ----������̵ʪ����
		 	end
		 	
		 		if @SRTZTypeCode>=40 
		 	begin
		 		set @S=@S +'TZ1005,'     ----��ʪ������
		 	end
		    else if  @SRTZTypeCode>=30 and @SRTZTypeCode<40
		    begin
		 		set @QXS=@QXS+ 'TZ1005,'     ----������ʪ������
		 	end
		 	
		 	if @XYTZTypeCode>=40 
		 	begin
		 		set @S=@S +'TZ1006,'    ----��Ѫ������
		 	end
		    else if  @XYTZTypeCode>=30 and @XYTZTypeCode<40
		    begin
		 			set @QXS=@QXS+ 'TZ1006,'    ----������Ѫ������
		 	end
		 	
		 	 	if @QYTZTypeCode>=40 
		 	begin
		 		set @S=@S +'TZ1008,'  ----����������
		 	end
		    else if  @QYTZTypeCode>=30 and @QYTZTypeCode<40
		    begin
		 		set @QXS=@QXS+ 'TZ1008,'     ----��������������
		 	end
		 	
		 		if @TBTZTypeCode>=40 
		 	begin
		 			set @S=@S +'TZ1007,'  ----����������
		 	end
		    else if  @TBTZTypeCode>=30 and @TBTZTypeCode<40
		    begin
		 		set @QXS=@QXS+ 'TZ1007,'     ----��������������
		 	end
    end
    update Gy_TZPDMain set STZTypeCode=@S ,JBSTZTypeCode=@JBS,QXSTZTypeCode=@QXS where  EmpBasicMainID=@EmpBasicMainID
end


select Score from  Gy_SubHealthItem where EmpBasicMainID='12112' and SubHealthItemCode='0015'
select Score from  Gy_SubHealthItem where EmpBasicMainID='12112' and SubHealthItemCode='0028'
select Score from  Gy_SubHealthItem where EmpBasicMainID='12112' and SubHealthItemCode='0038'
select Score from  Gy_SubHealthItem where EmpBasicMainID='12112' and SubHealthItemCode='0039'

@phyLevelCode int ,    --����������
@psyLevelCode int , --����������
@socLevelCode int ,
@totalLevelCode int , 