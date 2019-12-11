declare @PHTZTypeCode  decimal(18,6) ,
			@QXTZTypeCode  decimal(18, 6) ,
			@YXTZTypeCode  decimal(18, 6) ,
			@YinXTZTypeCode  decimal(18, 6) , 
			@TSTZTypeCode  decimal(18, 6) , 
			@SRTZTypeCode  decimal(18, 6) , 
			@XYTZTypeCode  decimal(18, 6) , 
			@QYTZTypeCode  decimal(18, 6) , 
			@TBTZTypeCode  decimal(18, 6)
			
			begin
				 select * into #PSco from 
	(select Gy_TZType.TZTypeCode,Gy_TZType.TZTypeName,
		SUM(
		case  
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
	 	