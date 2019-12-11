 C:\Users\Administrator\Desktop\NewProject 


-- SQLite 基本操作--查看数据表信息  https://blog.csdn.net/navioo/article/details/51397243 

 select name from sqlite_master where type='TMP_PRO_MATURITYTYPE';  
 .schema TMP_PRO_MATURITYTYPE  

-- sqlite查询库里所有表名  https://blog.csdn.net/runtime233/article/details/52439881 




    select * from  TMP_PRO_ENTITY; 




   --  nullptr？  https://www.zhihu.com/question/55936870/answer/146970485   https://blog.csdn.net/pkgk2013/article/details/72809796
   
   
   
   
select * fomr 表名A　　left join 表B  on  表A字段=表B的id 　　left join 表c 　on 表A字段=表c的id　　　

 
SELECT XXX
FROM ((A LEFT JOIN B ON A.id = B.id)
LEFT JOIN C ON A.id = C.id)
WHERE B.id Is Not Null






--  nvl的函数用哪个函数代替  http://code.niuc.org/thread-4582-1-1.html 


在SQLite中没有isnull函数，比较郁闷。
在sqlite中想要使用isnull函数，可以使用ifnull函数，跟isnull用法一样。
demo:select ifnull(catid,0) from category 





--   前10条数据  https://blog.csdn.net/chaoyu168/article/details/54844864  

select * from table_name limit 0,10   









 




  











