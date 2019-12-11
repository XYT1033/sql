	
	
	 alter proc Cy_Sp_GetRowCode
 @EmpBasicMainID int ,
 @PHTZTypeCode  int  output ,
@QXTZTypeCode int   output,
@YXTZTypeCode int output,
@YinXTZTypeCode  int output, 
@TSTZTypeCode  int  output, 
@SRTZTypeCode int output , 
@XYTZTypeCode  int output, 
@QYTZTypeCode  int  output, 
@TBTZTypeCode  int output
as
begin
     select * into #PSco from 
	(select Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName,
		SUM(
		case  
		 when OrderFlag=1 and NoFlag=1 then 5
		  when OrderFlag=1 and FewFlag=1 then 4
		    when OrderFlag=1 and OftenFlag=1 then 2
		    when OrderFlag=1 and AllFlag=1 then 1
		    
		 when NoFlag=1 then 1 
		 when FewFlag=1 then 1 
		 when LittleFlag=1 then 3
		 when OftenFlag=1 then 4 
	     when AllFlag=1 then 7 
		 else 0 
		end 
		 ) as PScore  
from Gy_TZPDItem inner join Gy_TZPDItemSet on Gy_TZPDItemSet.TZPDItemCode=Gy_TZPDItem.TZPDItemCode 
				 inner join Gy_TZType on Gy_TZType.TZTypeCode=Gy_TZPDItemSet.TZTypeCode
 where EmpBasicMainID=0
 group by Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName) as TSco
 
 set  @PHTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1009')
 set  @QXTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1003')
 set  @YXTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1001')
 set  @YinXTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1002')
  set  @TSTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1004')
 set  @SRTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1005')
 set  @XYTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1008')
 set  @TBTZTypeCode=(select  pscore from  #PSco where tztypecode ='TZ1007')
 
end

declare @ph int,
@qx int,
@yx int,
@yinx int,
@ts int,
@sr int,
@xy int,
@qy int,
@tb int
exec Cy_Sp_GetRowCode  @EmpBasicMainID=0,@PHTZTypeCode=@ph  output ,
@QXTZTypeCode=@qx output,@YXTZTypeCode=@yx output ,@YinXTZTypeCode=@yinx output,@TSTZTypeCode=@ts output,
@SRTZTypeCode=@sr output,@XYTZTypeCode=@xy output,@QYTZTypeCode=@qy  output,@TBTZTypeCode=@tb output
print @qx
print @qx
print @yx
print @yinx
			
 select 
*
  from Gy_TZPDItem inner join Gy_TZPDItemSet on Gy_TZPDItemSet.TZPDItemCode=Gy_TZPDItem.TZPDItemCode
 inner join Gy_TZType on Gy_TZType.TZTypeCode=Gy_TZPDItemSet.TZTypeCode
  group by Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName
 
 
 select * from Gy_TZPDItem
 select * from Gy_TZPDItemSet
 select * from Gy_TZType
 