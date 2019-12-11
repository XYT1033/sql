use MedicalCareERP

select TZTypeName  from Gy_TZType where TZTypeCode in('TZ1001','TZ1002')
select * from Gy_TZType
select *from dbo.Gy_TZPDItem
select * from Gy_TZPDItemSet where TZTypeCode='TZ1001'
select *from dbo.Gy_TZPDMain


select * from Gy_TZPDItem where EmpBasicMainID=0 and TZPDItemCode in (select TZPDItemCode from Gy_TZPDItemSet where TZTypeCode='TZ1001' )

select stztypecode,jbstztypecode,QXSTZTypeCode  from Gy_TZPDMain where  EmpBasicMainID=0

select * from Gy_TZType where tztypecode in ('tz1001','tz1002')
select * from Gy_TZType where tztypecode in ('TZ1003','TZ1001','TZ1002','TZ1004','TZ1006','TZ1008','TZ1007')

select UsedPhrasesType,UsedPhrasesName,PinYinCode,UsedPhrasesContent,RemarkSub 
                    from CM_UsedPhrases  where UsedPhrasesType=40 and DeptCode like '%10004%'
select * from    CM_UsedPhrases                 

create proc Gy_SP_GetTZPDFlag
 @EmpBasicMainID int=0,
 @TZTypeCode char(20) 
as
begin
	select * from Gy_TZPDItem where EmpBasicMainID=@EmpBasicMainID and TZPDItemCode in (select TZPDItemCode from Gy_TZPDItemSet where TZTypeCode=@TZTypeCode )
end

exec Gy_SP_GetTZPDFlag @EmpBasicMainID=0,@TZTypeCode='TZ1002'


alter proc Gy_SP_ConverScore 
@rawsocres decimal(18,6),  --ԭʼ��
@count int   --��Ŀ��
as 
begin
	
	 select ((@rawsocres-@count)/(@count*4))*100 rawsocres  --ת����
end

exec Gy_SP_ConverScore 
@rawsocres=22,@count=7	

drop proc Gy_SP_Judgment


alter  proc Gy_SP_Judgment
@EmpBasicMainID int=0,  --����ID Ĭ����0
@PHTZTypeCode decimal(18,6), --ƽ�����ʷ���
@QXTZTypeCode decimal(18,6),--�������ʷ���
@YXTZTypeCode decimal(18,6),--�������ʷ���
@YinXTZTypeCode decimal(18,6),--�������ʷ���
@TSTZTypeCode decimal(18,6),--̵ʪ���ʷ���
@SRTZTypeCode decimal(18,6),--ʪ�����ʷ���
@XYTZTypeCode decimal(18,6),--Ѫ�����ʷ���
@QYTZTypeCode decimal(18,6),--�������ʷ���
@TBTZTypeCode decimal(18,6),--�������ʷ���
--@STZTypeCode  Nvarchar(50) output ,     --���ʷ�����루�ǣ�
--@JBSTZTypeCode Nvarchar(50)output , --���ʷ�����루�����ǣ�
--@QXSTZTypeCode Nvarchar(50) output  , --���ʷ�����루�����ǣ�

    @S Nvarchar(50)='' ,
@JBS  Nvarchar(50)='',
@QXS  Nvarchar(50)='' 
/*
SET @S=@STZTypeCode
SET @JB=@JBSTZTypeCode
SET @QXS=@QXSTZTypeCode

  print @S
print @JB
print @QXS
*/
as
begin
	if @PHTZTypeCode>=60 and  (@QXTZTypeCode<30 and @YXTZTypeCode<30  and @YinXTZTypeCode<30 and  @TSTZTypeCode<30 and @SRTZTypeCode<30 and  @XYTZTypeCode<30 and @QYTZTypeCode<30 and @TBTZTypeCode<30) 
	begin
		 --print 'TZ1009'	  --��ƽ������
		--print @STZTypeCode
		set @S=@S +'TZ1009,'
	end
	else if @PHTZTypeCode>=60 and  (@QXTZTypeCode<40 and @YXTZTypeCode<40  and @YinXTZTypeCode<40 and  @TSTZTypeCode<40 and @SRTZTypeCode<40 and  @XYTZTypeCode<40 and @QYTZTypeCode<40 and @TBTZTypeCode<40)
	begin 
		   set  @JBS='TZ1009'	--������ƽ������
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

declare @S Nvarchar(50) ,
@JBS  Nvarchar(50) ,
@QXS  Nvarchar(50) 

exec Gy_SP_Judgment @PHTZTypeCode=45,@QXTZTypeCode=33,@YXTZTypeCode=33,@YinXTZTypeCode=44,@TSTZTypeCode=33,@SRTZTypeCode=44,@XYTZTypeCode=55,@QYTZTypeCode=55,@TBTZTypeCode=55,@EmpBasicMainID=11965

print @S
print @JBS
print @QXS




