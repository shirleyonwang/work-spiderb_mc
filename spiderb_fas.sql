/*

---------------------
level coverage based on count
level coverage based on population

Tuhu top coverage
Tuhu Coverage

FAS coverage simulation

FAS 回流表

？自动生成NR check

导入：
11.TUHU top 6000 vehicles
11.产品销售状态 (for SC)
15.BoschId与FASKey映射关系
16.TuhuId与力洋ID映射关系导入
21.保有量
2020Q2.dbo.report2

-- spider B导出文件：
-- TS导：
--1.匹配spb_tbl_result
--2.车型库
--3.NR

limitation:
	
不导入report1表，只导细节表	
根据细节表计算report1	
局限性	
	partially covered无
	sold coverage根据当月计算
	
有些prkey，两个才算covered.还有些不算	

SpiderB中结算，无partially covered	
relevant NR互转，对MC, SC影响增减都有	

SipderB中计算coverage的prkey是有一个list的

合并：[tbl_ProductLine_SpiderB]
[SpiderB].[dbo].[tbl_CBF_Productline]


到：[SpiderB].[dbo].[spb_name_match]
仍有重复：[tbl_ProductLine]

*/

--select * from spb_imp_tuhu_top
use  spiderB

if OBJECT_ID('spb_imp_tuhu_top') is not null drop table spb_imp_tuhu_top
SELECT *
into spb_imp_tuhu_top
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 04 - product\11.TUHU top 6000 vehicles.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 

 if OBJECT_ID('spb_imp_sales') is not null drop table spb_imp_sales
SELECT *
into spb_imp_sales
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 new\11.产品销售状态.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 



 if OBJECT_ID('spb_imp_tuhuleveID') is not null drop table spb_imp_tuhuleveID
SELECT *
into spb_imp_tuhuleveID
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 04 - product\16.TuhuId与力洋ID映射关系导入.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 

 if OBJECT_ID('spb_imp_vehicle_population') is not null drop table spb_imp_vehicle_population
--SELECT *
--into spb_imp_vehicle_population
-- FROM OpenDataSource
-- ( 'Microsoft.ACE.OLEDB.12.0',
-- 'Data Source=C:\Work\Spider B\start\data prepare 2020 04 - product\21.保有量.xlsx;
-- User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 


select BoschID,'PRC' as Region, carp_2018 as [Target Population], Carp_2019 as [Latest Population] into spb_imp_vehicle_population
from commondb.dbo.LevelVehicle

  if OBJECT_ID('spb_imp_HMLPPOE') is not null drop table spb_imp_HMLPPOE
--SELECT *
--into spb_imp_HMLPPOE
-- FROM OpenDataSource
-- ( 'Microsoft.ACE.OLEDB.12.0',
-- 'Data Source=C:\Work\Spider B\start\data prepare 2020 new\HMLPP_additional vehicle info.xlsx;
-- User ID=Admin;Password=;Extended properties=Excel 12.0')...[HMLPP_XOEM$] 

 select BoschID, 力洋ID, faskey, HMLPP,XOEM
 into spb_imp_HMLPPOE
 from commondb.dbo.LevelVehicle

 /*检查途虎和力洋匹配的比较
  if OBJECT_ID('spb_imp_TuhuMatch') is not null drop table spb_imp_TuhuMatch
SELECT *
into spb_imp_TuhuMatch
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 04 - product\19.途虎匹配关系.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 

 --途虎有匹配，力洋无
 select a.*,b.*,d.[Product_Line_Name],e.SourceId
 from spb_imp_TuhuMatch a inner join [spb_imp_tuhuleveID] e  on a.tid=e.tuhuid  
 left  join spb_tbl_result b on b.source_id=e.[SourceId] and a.prkey=b.appdes
 inner join tbl_ProductKeyProductLine c on a.prkey =c.[ProductKey] 
 inner join [tbl_ProductLine] d on c.productline=d.[Product_Line_Code]
 where b.appdes is null
order by d.[Product_Line_Name],bosch_id


--力洋有匹配，途虎无

 select a.*,b.*,d.[Product_Line_Name]
 from spb_tbl_result b  inner join [spb_imp_tuhuleveID] e  on b.source_id=e.[SourceId] 
 left join  spb_imp_TuhuMatch a on a.prkey=b.appdes and a.tid=e.tuhuid  
 inner join tbl_ProductKeyProductLine c on b.appdes =c.[ProductKey] 
 inner join [tbl_ProductLine] d on c.productline=d.[Product_Line_Code]
 where a.FormPN is null and b.product_number is not null


 --力洋途虎匹配不同

 select a.*,b.*,d.[Product_Line_Name]
 from spb_tbl_result b  inner join [spb_imp_tuhuleveID] e  on b.source_id=e.[SourceId] 
 left join  spb_imp_TuhuMatch a on a.prkey=b.appdes and a.tid=e.tuhuid  
 inner join tbl_ProductKeyProductLine c on b.appdes =c.[ProductKey] 
 inner join [tbl_ProductLine] d on c.productline=d.[Product_Line_Code]
 where a.FormPN <> b.product_number

select top 10 * from spb_tbl_result
 */
---------------------------------
if OBJECT_ID('spb_name_match') is not null drop table spb_name_match
SELECT *
into spb_name_match
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 07\namematch.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 

--select top 10 * from spb_imp_HMLPPOE
 

 ------------------------------------------------------TS导出---------------------------------------------
 use CommonDB
  if OBJECT_ID('CommonDB.dbo.LevelVehicle') is not null drop table [CommonDB].[dbo].[LevelVehicle]
SELECT *
into [CommonDB].[dbo].[LevelVehicle]
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 new\12.bosch主车型.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[车型数据$] 

 --select * 
 delete from [CommonDB].[dbo].[LevelVehicle]
 where [status] =N'删除'

 --select * from [CommonDB].[dbo].[LevelVehicle]

exec sp_rename '[LevelVehicle].XOEM','OEMBrand'

--exec sp_rename '[LevelVehicle].[[LevelVehicle]].OEMBrand]','OEMBrand'

--  alter table [CommonDB].[dbo].[LevelVehicle] add 
--OEMBrand nvarchar(20),
--HMLPP nvarchar(10)

--update a
--set a.OEMBrand=b.XOEM, a.HMLPP=b.HMLPP
--from [CommonDB].[dbo].[LevelVehicle] a, spb_imp_HMLPPOE b
--where a.BoschID=b.boschID

--select * from spb_imp_HMLPPOE a, [CommonDB].[dbo].[LevelVehicle] b
--where a.BoschID=b.boschid and a.XOEM<>b.XOEM

use SpiderB

-- if OBJECT_ID('spb_imp_boschidFaskey') is not null drop table spb_imp_boschidFaskey
--SELECT *
--into spb_imp_boschidFaskey
-- FROM OpenDataSource
-- ( 'Microsoft.ACE.OLEDB.12.0',
-- 'Data Source=C:\Work\Spider B\start\data prepare 2020 new\15.BoschId与FASKey映射关系.xlsx;
-- User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 

if OBJECT_ID('spb_imp_boschidFaskey') is not null drop table spb_imp_boschidFaskey
select distinct boschID, FASKey 
into spb_imp_boschidFaskey
from [CommonDB].[dbo].[LevelVehicle] where faskey is not null and FASKey<>''
--select top 100 * from spb_imp_boschidFaskey

----------------
--  if object_id('tbl_match') is not null drop table tbl_match
--   create table tbl_match
--(
--[BoschID] nvarchar(255)
--	,[LevelID] nvarchar(255)
--	,[PN] nvarchar(15)
--	,[remark_external] nvarchar(255)
--	,[remark_internal] nvarchar(255)
--	,[AppPrkey] nvarchar(255)
--	,[displayMark] nvarchar(255)
--	,[datasource] nvarchar(255)	
--	  )	  
--  BULK INSERT tbl_match
--FROM 'C:/Work/Spider B/start/data prepare 2020 05 - product/TS import/17.match.txt'
--with(   
--    FIELDTERMINATOR='|',   
--    ROWTERMINATOR='\n'  
--)  



--select * from spb_tbl_result where appdes ='347150'

--select * into spb_tbl_result_06 from spb_tbl_result
-------------------0701 以下导入失败：1.全量报错2删掉一部分数据后导入条数少于真实条数------------------------
-- if object_id('spb_tbl_result') is not null drop table spb_tbl_result

--create table spb_tbl_result
--(
--bosch_id nvarchar(255)
--	,source_id nvarchar(255)
--	,product_number nvarchar(255)
--	,category1 nvarchar(255)
--	,category2 nvarchar(255)
--	,categoryCode nvarchar(255)
--	,[AppDes] nvarchar(255)	
--	,[AppDes description] nvarchar(255)	
--	,PCDInfo nvarchar(255)
--	,[remark_internal] nvarchar(255)
--	,[remark_external] nvarchar(255)
--	,[is_deleted] nvarchar(255)	
--	  )

--BULK INSERT spb_tbl_result
--FROM 'C:\Work\Spider B\start\data prepare 2020 new\part_application_0701\export_part_application_with_category.txt'
--with( 
--	KEEPIDENTITY,   
--    FIELDTERMINATOR='|',   
--    ROWTERMINATOR='\n'  
--)

--select top 10 * from spb_tbl_result


--select * from spb_tbl_result
  ------------------------------------------------------level coverage based on count-------------------------------------------
    if OBJECT_ID('report_level_cnt') is not null drop table report_level_cnt
  select aaa.Product_Line_Name,aaa.Product_Line_Code, aaa.relevant_cnt,bbb.covered_cnt, format(bbb.covered_cnt/cast(aaa.relevant_cnt  as float),'0.00%') as MC_cnt
  into report_level_cnt
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,count(BoschID) as relevant_cnt
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,c.标记
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code
  ) aaa left join 
  --covered count
  (
	  select productline, count([bosch_id]) as covered_cnt
	  from
	  (
	  SELECT distinct [bosch_id],
		 b.productline
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b
	  where a.[AppDes] =b.ProductKey
	  ) aa
	  group by productline
  ) bbb
on aaa.Product_Line_Code=bbb.productline
where bbb.covered_cnt is not null
order by Product_Line_Name

------------------------------------------------------level coverage based on population-------------------------------------------
--select top 10 * from spb_imp_vehicle_population



 if OBJECT_ID('report_level_popul') is not null drop table report_level_popul
 select aaa.Product_Line_Name,aaa.Product_Line_Code, aaa.relevant_popul,bbb.covered_popul, format(bbb.covered_popul/cast(aaa.relevant_popul  as float),'0.00%') as MC_popul
 into report_level_popul
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,round(sum([Target Population]),0) as relevant_popul
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,c.标记,d.[Target Population]
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码 inner join spb_imp_vehicle_population d on b.BoschID=d.boschid
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code
  ) aaa left join 
  --covered count
  (
	  select productline, round(sum([Target Population]),0)  as covered_popul
	  from
	  (
	  SELECT distinct [bosch_id],
		 b.productline,c.[Target Population]
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b, spb_imp_vehicle_population c
	  where a.[AppDes] =b.ProductKey and a.[bosch_id]=c.boschid
	  ) aa
	  group by productline
  ) bbb
on aaa.Product_Line_Code=bbb.productline
where bbb.covered_popul is not null
order by Product_Line_Name



------------------------------------------------------Tuhu top coverage-----------------------------------------------------------

--select top 10 * from [CommonDB].[dbo].[LevelVehicle] where boschid is not null
--select top 10 * from report_tuhu_top

 if OBJECT_ID('report_tuhu_top') is not null drop table report_tuhu_top
 select aaa.Product_Line_Name,aaa.Product_Line_Code, aaa.relevant_cnt,bbb.covered_cnt, format(bbb.covered_cnt/cast(aaa.relevant_cnt  as float),'0.00%') as MC_cnt
 into report_tuhu_top
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,count(TID) as relevant_cnt
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,e.TID
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid, [力洋ID] from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码
	  inner join spb_imp_tuhuleveID d on b.[力洋ID]=d.SourceID inner join spb_imp_tuhu_top e on d.tuhuid=e.TID
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code
  ) aaa left join 
  --covered count
  (
	  select productline, count(TID) as covered_cnt
	  from
	  (
	  SELECT distinct TID,
		 b.productline
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b,spb_imp_tuhuleveID d , spb_imp_tuhu_top e
	  where a.[AppDes] =b.ProductKey and a.source_id=d.SourceID and d.tuhuid=e.TID
	  ) aa
	  group by productline
  ) bbb
on aaa.Product_Line_Code=bbb.productline
where bbb.covered_cnt is not null
order by Product_Line_Name

--select * from [SpiderB].[dbo].[tbl_NR]
------------------------------------------------------Tuhu Coverage---------------------------------------------------------------------------

if OBJECT_ID('report_tuhu_cnt') is not null drop table report_tuhu_cnt

select aaa.Product_Line_Name,aaa.Product_Line_Code, aaa.relevant_cnt,bbb.covered_cnt, format(bbb.covered_cnt/cast(aaa.relevant_cnt  as float),'0.00%') as MC_cnt
into report_tuhu_cnt
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,count(tuhuid) as relevant_cnt
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,d.tuhuid
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid, [力洋ID] from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码
	  inner join spb_imp_tuhuleveID d on b.[力洋ID]=d.SourceID
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code
  ) aaa left join 
  --covered count
  (
	  select productline, count(tuhuid) as covered_cnt
	  from
	  (
	  SELECT distinct tuhuid,
		 b.productline
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b,spb_imp_tuhuleveID d 
	  where a.[AppDes] =b.ProductKey and a.source_id=d.SourceID
	  ) aa
	  group by productline
  ) bbb
on aaa.Product_Line_Code=bbb.productline
where bbb.covered_cnt is not null
order by Product_Line_Name


------------------------------------------------------HPP MPP LPP by count-------------------------------------------
--select top 10 * from [CommonDB].[dbo].[LevelVehicle]

if OBJECT_ID('report_HMLPP_cnt') is not null drop table report_HMLPP_cnt

select aaa.Product_Line_Name,aaa.Product_Line_Code,aaa.HMLPP, aaa.relevant_cnt,bbb.covered_cnt, format(bbb.covered_cnt/cast(aaa.relevant_cnt  as float),'0.00%') as MC_cnt
into report_HMLPP_cnt
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,HMLPP,count(BoschID) as relevant_cnt
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,HMLPP,c.标记
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid,HMLPP from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code,HMLPP
  ) aaa left join 
  --covered count
  (
	  select productline, HMLPP,count([bosch_id]) as covered_cnt
	  from
	  (
	  SELECT distinct [bosch_id],HMLPP,
		 b.productline
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b,[CommonDB].[dbo].[LevelVehicle] c
	  where a.[AppDes] =b.ProductKey and a.bosch_id=c.BoschID
	  ) aa
	  group by productline, HMLPP
  ) bbb
on aaa.Product_Line_Code=bbb.productline and aaa.HMLPP=bbb.HMLPP
where bbb.covered_cnt is not null
order by Product_Line_Name

------------------------------------------------------HPP MPP LPP by population-------------------------------------------
if OBJECT_ID('report_HMLPP_popul') is not null drop table report_HMLPP_popul

 select aaa.Product_Line_Name,aaa.Product_Line_Code, aaa.relevant_popul,bbb.covered_popul, format(bbb.covered_popul/cast(aaa.relevant_popul  as float),'0.00%') as MC_popul
 into report_HMLPP_popul
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,HMLPP ,round(sum([Target Population]),0) as relevant_popul
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,c.标记,d.[Target Population],HMLPP 
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid ,HMLPP from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码 inner join spb_imp_vehicle_population d on b.BoschID=d.boschid
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code,HMLPP 
  ) aaa left join 
  --covered count
  (
	  select productline,HMLPP , round(sum([Target Population]),0)  as covered_popul
	  from
	  (
	  SELECT distinct [bosch_id],
		 b.productline,c.[Target Population],HMLPP 
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b, spb_imp_vehicle_population c,[CommonDB].[dbo].[LevelVehicle] d
	  where a.[AppDes] =b.ProductKey and a.[bosch_id]=c.boschid and a.bosch_id=d.BoschID
	  ) aa
	  group by productline,HMLPP
  ) bbb
on aaa.Product_Line_Code=bbb.productline and aaa.HMLPP=bbb.HMLPP
where bbb.covered_popul is not null
order by Product_Line_Name


------------------------------------------------------Brand by count-------------------------------------------

if OBJECT_ID('report_OEM_cnt') is not null drop table report_OEM_cnt

select aaa.Product_Line_Name,aaa.Product_Line_Code,aaa.OEMBrand, aaa.relevant_cnt,bbb.covered_cnt, format(bbb.covered_cnt/cast(aaa.relevant_cnt  as float),'0.00%') as MC_cnt
into report_OEM_cnt
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,OEMBrand,count(BoschID) as relevant_cnt
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,OEMBrand,c.标记
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid,OEMBrand from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code,OEMBrand
  ) aaa left join 
  --covered count
  (
	  select productline, OEMBrand,count([bosch_id]) as covered_cnt
	  from
	  (
	  SELECT distinct [bosch_id],OEMBrand,
		 b.productline
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b,[CommonDB].[dbo].[LevelVehicle] c
	  where a.[AppDes] =b.ProductKey and a.bosch_id=c.BoschID
	  ) aa
	  group by productline, OEMBrand
  ) bbb
on aaa.Product_Line_Code=bbb.productline and aaa.OEMBrand=bbb.OEMBrand
where bbb.covered_cnt is not null
order by Product_Line_Name

------------------------------------------------------Brand by population-------------------------------------------
if OBJECT_ID('report_OEM_popul') is not null drop table report_OEM_popul
--select * from report_OEM_popul
select aaa.Product_Line_Name,aaa.Product_Line_Code, aaa.OEMBrand,aaa.relevant_popul,bbb.covered_popul, format(bbb.covered_popul/cast(aaa.relevant_popul  as float),'0.00%') as MC_popul
into report_OEM_popul
  from
  --relevant count
  (
	  select Product_Line_Name,Product_Line_Code,OEMBrand ,round(sum([Target Population]),0) as relevant_popul
	  from
	  (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,c.标记,d.[Target Population],OEMBrand 
	  FROM  [SpiderB].[dbo].[tbl_ProductLine] a CROSS join (select distinct boschid ,OEMBrand from [CommonDB].[dbo].[LevelVehicle] where boschid is not null) b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.产品线代码 inner join spb_imp_vehicle_population d on b.BoschID=d.boschid
	  where c.标记 is null
	  ) aa
	  group by Product_Line_Name,Product_Line_Code,OEMBrand 
  ) aaa left join 
  --covered count
  (
	  select productline,OEMBrand , round(sum([Target Population]),0)  as covered_popul
	  from
	  (
	  SELECT distinct [bosch_id],
		 b.productline,c.[Target Population],OEMBrand 
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b, spb_imp_vehicle_population c,[CommonDB].[dbo].[LevelVehicle] d
	  where a.[AppDes] =b.ProductKey and a.[bosch_id]=c.boschid and a.bosch_id=d.BoschID
	  ) aa
	  group by productline,OEMBrand
  ) bbb
on aaa.Product_Line_Code=bbb.productline and aaa.OEMBrand=bbb.OEMBrand
where bbb.covered_popul is not null
order by Product_Line_Name



------------------------------------------------------FAS coverage simulation----------------------------------------------
------------------------------------------------------FAS coverage simulation----------------------------------------------
------------------------------------------------------FAS coverage simulation----------------------------------------------
------------------------------------------------------FAS coverage simulation----------------------------------------------
------------------------------------------------------FAS coverage simulation----------------------------------------------

--select top 10 * from spb_imp_boschidFaskey
--select top 10 * from [2020Q2].[dbo].[report_2]

--select top 100 * from spb_name_match
use SpiderB

--KBPRC MB 000要处理

update [2020Q2].dbo.KBPRC set [FAS Key]=replace([FAS Key],' ','') where [FAS Key] like '% %'

--select * from  [2020Q2].[dbo].[report_2] where [FASKey] like '% %'

--替代原来的FAS_quip,季度导入到spider B.能对应main nr的对应，scan没有连接的显示KBPRC的连接 替代不了，模板里没有产品线，
--以Scan为主，main number提取KBPRC。包含GAP
--包含KBPRC连过的料号
if OBJECT_ID('PN_SCAN_KBPRC_ALL') is not null drop table PN_SCAN_KBPRC_ALL
select distinct a.FASkey,a.product, a.[ESCHL] as prkey,a.MATERIAL,c.[Main Nr],isnull([ESCHL],c.[Main Nr prod key]) as [Main Nr prod key],c.[Main Nr spec case],a.RG_POPULATION, cast('' as nvarchar(255)) as remark_forMBL
into PN_SCAN_KBPRC_ALL
from 
(
SELECT [PRODUCT] 
	  ,[FASKey]         
      ,[MATERIAL]     
      ,[SPECIAL_CASE]
      ,[ESCHL]      
      --,[RELEVANT_POPULATION]
      --,[COVERED_POPULATION]
      --,[SOLD_POPULATION]
      ,[RG_POPULATION]
       
  FROM [2020Q2].[dbo].[report_2]
  where land ='PRC' and VEHICLE_CATEGORY='PC/LCV'and material is not null
  ) a inner join spb_name_match b on a.product=b.Scan_name left join 
  (
  SELECT [FAS key]     
	  ,Product 
      ,[Relevant Nr]     
      ,[Main Nr]	
      ,[Main Nr prod key]      
      ,[Main Nr spec case]     
      ,[OE Nr]
      ,[Population RG]
  FROM [2020Q2].dbo.KBPRC
  where [Main Nr] is not null
  ) c on a.product=b.Scan_Name and b.procom_name=c.product and a.faskey=c.[FAS key] and a.material=c.[Relevant Nr]
  union all
  select distinct aa.FASkey,aa.product,aa.ESCHL,aa.MATERIAL,cc.[Main Nr],isnull([ESCHL],cc.[Main Nr prod key]) as [Main Nr prod key],cc.[Main Nr spec case],aa.RG_POPULATION, cast('' as nvarchar(255)) as remark_forMBL
  from
  (select *   FROM [2020Q2].[dbo].[report_2] where  land ='PRC' and VEHICLE_CATEGORY='PC/LCV' and material is null) aa 
  inner join spb_name_match bb on aa.product=bb.Scan_name 
  left join 
  (
  SELECT [FAS key]     
	  ,Product 
      ,[Relevant Nr]     
      ,[Main Nr]	
      ,[Main Nr prod key]      
      ,[Main Nr spec case]     
      ,[OE Nr]
      ,[Population RG]
  FROM [2020Q2].dbo.KBPRC
  where [Main Nr] is not null
  ) cc on aa.product=bb.Scan_Name and bb.procom_name=cc.product and aa.faskey=cc.[FAS key]

--0826 new add. because some disconnect number actually is not main NR
--pre sucessor.只管到一级，应该还有多级的.此步可取消，但接下来的语句执行太慢，所以减少一些。
update a
set a.[Main Nr] = c.[Main Nr],a.[Main Nr prod key]=c.[Main Nr prod key], a.[Main Nr Spec case]=c.[Main Nr Spec case],a.remark_forMBL='successor'
--select a.*,c.[Main Nr]
from PN_SCAN_KBPRC_ALL a, [z08mm_ersvwket] b, [2020Q2].dbo.KBPRC c
where a.MATERIAL=b.successor and b.pre=c.[Main Nr] and   a.faskey=c.[fas key] and (a.[Main Nr] is null or a.MATERIAL<>a.[Main Nr])

--select * from PN_SCAN_KBPRC_ALL


--select distinct remark_forMBL -- a.*
--from PN_SCAN_KBPRC_ALL a
--where a.remark_forMBL <>'' --and a.[Main Nr] is null


--38 seconds
update a
set a.[Main Nr] = c.[Main Nr],a.[Main Nr prod key]=c.[Main Nr prod key], a.[Main Nr Spec case]=c.[Main Nr Spec case],a.remark_forMBL=dbo.ufcompare2PNs(c.[Main Nr],a.MATERIAL)
--select a.*,c.[Main Nr]
from PN_SCAN_KBPRC_ALL a,  [2020Q2].dbo.KBPRC c
where c.[Main Nr] is not null and a.[Main Nr prod key]=c.[Main Nr prod key]  and a.faskey=c.[fas key] and dbo.ufcompare2PNs(c.[Main Nr],a.MATERIAL)<>'N' 
and (a.[Main Nr] is null )--太慢，去掉or a.MATERIAL<>a.[Main Nr] and a.remark_forMBL='')

--select * from PN_SCAN_KBPRC_ALL where [faskey]='CRY0000033' and product='Brake Pad front'

--去重
delete A2 from (
select row_Number() over(partition by FASkey,product,MATERIAL,[Main Nr],[Main Nr prod key] order by FASkey,product,MATERIAL) as keyId_e,* from PN_SCAN_KBPRC_ALL
) as A2 where A2.keyId_e >1 --order by Material

--select * from PN_SCAN_KBPRC_ALL
  --select distinct VEHICLE_CATEGORY from [2020Q2].[dbo].[report_2]
  --select * from PN_SCAN_KBPRC_ALL where material is null and [main nr] is not null
--use SpiderB
/*
--用c只为找fas product全集，只考虑了FAS的相关性，未考虑spider B的相关性
 if OBJECT_ID('report_FAS_popul_CoveredPN') is not null drop table report_FAS_popul_CoveredPN
SELECT distinct c.FASKey,c.PRODUCT,c.RG_POPULATION,a.appdes,a.product_number	, 0 as connected_cnt, 0 as sales, cast(0 as float) as covered_population, cast(0 as float) as sold_population, cast('' as nvarchar(50)) as newStatus
into report_FAS_popul_CoveredPN
	  FROM [spb_tbl_result] a, [tbl_ProductKeyProductLine] b, PN_SCAN_KBPRC_ALL c, spb_imp_boschidFaskey d, [spb_name_match] e, FRC.dbo.PCDAll f
	  where a.[AppDes] =b.ProductKey and a.[bosch_id]=d.boschid and c.FASKey=d.FASkey and b.ProductLine=e.product_line_Code and c.PRODUCT=e.Scan_Name and a.product_number=f.PN
	  and (f.[Status]='40' or f.[Status]='49')

*/
--只考虑spider B的相关性.只有covered,无gap
 if OBJECT_ID('PN_SpiderB2FAS_Covered') is not null drop table PN_SpiderB2FAS_Covered
SELECT distinct aa.FASKey,aa.scan_name as product,aa.appdes,aa.product_number	,0 as RG_POPULATION, 0 as connected_cnt, 0 as sales, cast(0 as float) as [relevant_population], cast(0 as float) as covered_population, cast(0 as float) as sold_population, cast('' as nvarchar(50)) as newStatus
into PN_SpiderB2FAS_Covered
FROM (select FASKey,scan_name,appdes, product_number,productline,bosch_id from [spb_tbl_result] a, [tbl_ProductKeyProductLine] b,  spb_imp_boschidFaskey d, [spb_name_match] e, PCDAll f
			where a.[AppDes] =b.ProductKey and a.[bosch_id]=d.boschid  and  b.ProductLine=e.product_line_Code  and a.product_number=f.PN and e.scan_name is not null
			and (f.[Status]='40' or f.[Status]='49')
			and a.appdes in (  select distinct ESCHL from [2020Q2].[dbo].[report_2]) --prkey必须在FAS衡量的group 里			
	) aa left join [SpiderB].[dbo].[tbl_NR] c on aa.ProductLine=c.产品线代码 and c.BoschId=aa.bosch_id and c.标记='NR'
where c.BoschId is null
--and product_number='F01R00S268'
--select * from PN_SpiderB2FAS_Covered
/*
999991	Lambda Sensor for Common in SpiderB	前后通用氧传感器			相当于：782005， 782006
999992	Wear sensor brake pad for Common in SpiderB	前后通用报警线		相当于：778305， 778306

*/
---------------------------------------------------999991--------------------------------------------------------
insert into PN_SpiderB2FAS_Covered
SELECT  [FASKey]
      ,[product]
      ,'782005'
      ,[product_number]
      ,[RG_POPULATION]
      ,[connected_cnt]
      ,[sales]
	  ,[relevant_population]
      ,[covered_population]
      ,[sold_population]
      ,[newStatus]
  FROM [SpiderB].[dbo].[PN_SpiderB2FAS_Covered]
  where appdes ='999991'


insert into PN_SpiderB2FAS_Covered
SELECT  [FASKey]
      ,[product]
      ,'782006'
      ,[product_number]
      ,[RG_POPULATION]
      ,[connected_cnt]
      ,[sales]
	  ,[relevant_population]
      ,[covered_population]
      ,[sold_population]
      ,[newStatus]
  FROM [SpiderB].[dbo].[PN_SpiderB2FAS_Covered]
  where appdes ='999991'

  delete from PN_SpiderB2FAS_Covered where appdes ='999991'
-----------------------------------------------------------------------------------------------------------
---------------------------------------------------999992--------------------------------------------------------
insert into PN_SpiderB2FAS_Covered
SELECT  [FASKey]
      ,[product]
      ,'778305'
      ,[product_number]
      ,[RG_POPULATION]
      ,[connected_cnt]
      ,[sales]
	  ,[relevant_population]
      ,[covered_population]
      ,[sold_population]
      ,[newStatus]
  FROM [SpiderB].[dbo].[PN_SpiderB2FAS_Covered]
  where appdes ='999992'


insert into PN_SpiderB2FAS_Covered
SELECT  [FASKey]
      ,[product]
      ,'778306'
      ,[product_number]
      ,[RG_POPULATION]
      ,[connected_cnt]
      ,[sales]
	  ,[relevant_population]
      ,[covered_population]
      ,[sold_population]
      ,[newStatus]
  FROM [SpiderB].[dbo].[PN_SpiderB2FAS_Covered]
  where appdes ='999992'

  delete from PN_SpiderB2FAS_Covered where appdes ='999992'
-----------------------------------------------------------------------------------------------------------

 if OBJECT_ID('FAS_Vehicle') is not null drop table FAS_Vehicle
 select distinct FASKey,RG_Population
 into FAS_Vehicle
 from PN_SCAN_KBPRC_ALL


update a
set a.RG_POPULATION=b.RG_POPULATION
from PN_SpiderB2FAS_Covered a, FAS_Vehicle b
where a.faskey=b.FASKey
--select distinct product,  [RG_POPULATION],FASKey FROM PN_SCAN_KBPRC_ALL 
--select distinct product, [population RG] as [RG_POPULATION],[fas key] as FASKey FROM PN_SCAN_KBPRC_ALL where [population RG] is not null
--select top 10 * from [spb_name_match]
--select * from [PN_SpiderB2FAS_Covered] where newStatus<>'Covered' and appdes<>'999991'

--select * from PN_SCAN_KBPRC_ALL

--select * from ymtk00404x

--“A” represents will be taken into consideration for coverage. Whereas “B” indicates a group requirement and “C” indicates that the part number will have no effect on the calculation.
--First I check if vehicles are covered 100% with A logic Product Keys. 
--Next step is to check if vehicles are covered 100% with B logic product keys (pairs) 
--and finally for all of the vehicles not covered 100% by A or B logic, we check if each month is covered with A or B and summarize covered months to get MC of the vehicle. 
--For SC, calculated MC is a starting point and we split population to equal shares, depending on the number of materials relevant.

--'A'
update a 
set a.newStatus='Covered'
--select distinct a.*,b.art,b.grp 
from PN_SpiderB2FAS_Covered a,ymtk00404x b
where a.AppDes=b.eschl and b.art='A'



--'B' --只能找到两个就满足的。如果同一组有多个，应该是多个都有才covered，这里有点问题，只需要有两个就算covered了。
update a1
set a1.newStatus='Covered'
--select distinct a1.*,b1.art,b1.grp ,b2.art,b2.grp 
from PN_SpiderB2FAS_Covered a1, PN_SpiderB2FAS_Covered a2,ymtk00404x b1,ymtk00404x b2
where a1.AppDes=b1.eschl and b1.art='B' and a2.AppDes=b2.eschl and b1.grp=b2.grp and b1.eschl<>b2.eschl and b2.art='B' 
and a1.faskey=a2.faskey and a1.product=a2.product
--and a1.product not like '%Wiper%' and a1.product not like '%O2 Sensor%'
--order by b1.grp

--select * from [PN_SpiderB2FAS_Covered] where newStatus<>'Covered'


update a
set a.connected_cnt=b.cnt, a.covered_population=cast(a.RG_POPULATION as float)/cast(b.cnt as float),a.relevant_population=cast(a.RG_POPULATION as float)/cast(b.cnt as float)
--select * 
from PN_SpiderB2FAS_Covered a, (
	  select faskey, product, count(product_number) as cnt
	  from PN_SpiderB2FAS_Covered
	  group by faskey, product) b
where a.faskey=b.faskey and a.product=b.product and newstatus<>''
--and a.faskey='ACU0000072' and a.product='Wiper (front)'

update a
set a.sales=0
from PN_SpiderB2FAS_Covered  a

update a
set a.sales=b.sales, a.sold_population= iif(b.sales>0,a.covered_population,0)
from PN_SpiderB2FAS_Covered a, spb_imp_sales b
where a.product_number=b.product_number and b.sale_org='PRC'


--模拟coverage
if OBJECT_ID('report_FAS_popul_simul') is not null drop table report_FAS_popul_simul
select aa.product, aa.relvent_popul as relevant_popul_simul,bb.covered_popul as covered_popul_simul,bb.sold_popul as sold_popul_simul,format(bb.covered_popul/aa.relvent_popul,'0.00%') as MC_simul,format(bb.sold_popul/aa.relvent_popul,'0.00%') as SC_simul,
cc.relevant_population,cc.COVERED_POPULATION,cc.SOLD_POPULATION,cc.[MARKET_COVERAGE_%],cc.[SOLD_COVERAGE_%]
into report_FAS_popul_simul
from 
(SELECT   [PRODUCT]   ,sum(RG_POPULATION) as relvent_popul        FROM PN_SCAN_KBPRC_ALL group by product) aa left join

(select product,sum(covered_population) as covered_popul, sum(sold_population) as sold_popul
from PN_SpiderB2FAS_Covered
group by product
) bb
on aa.product=bb.product
right join(
select product, relevant_population,Covered_population,sold_population,[MARKET_COVERAGE_%],[SOLD_COVERAGE_%] FROM [2020Q2].[dbo].[report_1] where country='PRC'
) cc on aa.product=cc.product
--select * from report_FAS_popul_simul


-----------
--use SpiderB
----------------------------------------------ScanTool
--covered population
 if OBJECT_ID('PN_SCAN_Report2') is not null drop table PN_SCAN_Report2
SELECT distinct faskey, product,prkey,material,RG_POPULATION	, 0 as connected_cnt, 0 as sales, cast(0 as float) as relevant_population, cast(0 as float) as covered_population, cast(0 as float) as sold_population
into PN_SCAN_Report2
FROM PN_SCAN_KBPRC_ALL

--select * from PN_SCAN_report2
--
--select a.*,b.material,b.COVERED_POPULATION,b.COVERED_POPULATION-a.covered_population ,b.RELEVANT_POPULATION,b.RELEVANT_POPULATION-a.relevant_population
--from PN_SCAN_Report2 a left join [2020Q2].dbo.REPORT_2  b on a.product=b.product and a.faskey=b.faskey and a.MATERIAL=b.MATERIAL and b.land='PRC'
-- select * from PN_SCAN_Report2

update a
set a.connected_cnt=b.cnt, a.covered_population=iif(b.cnt<>0, cast(a.RG_POPULATION as float)/cast(b.cnt as float),0), a.relevant_population=iif(b.cnt<>0,cast(a.RG_POPULATION as float)/cast(b.cnt as float),a.rg_population)
from PN_SCAN_Report2 a, (
	  select faskey, product, count(MATERIAL) as cnt
	  from PN_SCAN_Report2
	  group by faskey, product) b
where a.faskey=b.faskey and a.product=b.product 

update a
set a.sales=0
from PN_SCAN_Report2  a

update a
set a.sales=b.sales, a.sold_population= iif(b.sales>0,a.covered_population,0)
from PN_SCAN_Report2 a, spb_imp_sales b
where a.MATERIAL=b.product_number and b.sale_org='PRC'

-------------[2020Q2].[dbo].[report_1]
--select * from PN_SCAN_Report2
--检验此report与Report1
select [PRODUCT], sum(Relevant_PopuLation) as [Relevant_population],sum(Covered_PopuLation) as [covered_population], sum([SOLD_POPULATION]) as [sold_population], format(sum(Covered_PopuLation) /sum(Relevant_PopuLation),'0%') as [MARKET_COVERAGE_%],format(sum([SOLD_POPULATION]) /sum(Relevant_PopuLation),'0%') as [SOLD_COVERAGE_%]
 --into report_1
from PN_SCAN_Report2
group by product

select * from [2020Q2].dbo.REPORT_1  where [COUNTRY]='PRC'

--select * from PN_SCAN_Report2
----------------------------------------------------------------
--差距为patially covered
select  b.[PRODUCT], a.covered_population as cal_covered, b.COVERED_POPULATION as repor1_covered,
 round(a.[RELEVANT_POPULATION] -b.Relevant_PopuLation,0) as [Relevant_populationDiff],
 round(a.[COVERED_POPULATION]-b.Covered_PopuLation,0) as [covered_populationDiff],
 round(a.[SOLD_POPULATION] -b.[SOLD_POPULATION],0) as [sold_populationDiff],
format(iif(a.Relevant_PopuLation>0,a.Covered_PopuLation /a.Relevant_PopuLation,0)-cast(replace(b.[MARKET_COVERAGE_%],'%','') as float)/100, '0.0%') as [MARKET_COVERAGE_Diff%],
format(iif(a.Relevant_PopuLation>0,a.[SOLD_POPULATION] /a.Relevant_PopuLation,0)-cast(replace(b.[SOLD_COVERAGE_%],'%','') as float)/100, '0.0%') as [SOLD_COVERAGE_%]
from (select a.[PRODUCT], 
		sum(a.[RELEVANT_POPULATION]) as [RELEVANT_POPULATION] ,
		sum(a.[COVERED_POPULATION]) as [COVERED_POPULATION],
		sum(a.[SOLD_POPULATION]) as [SOLD_POPULATION],
		format(sum(a.Covered_PopuLation) /sum(a.Relevant_PopuLation),'0.0%') as [MARKET_COVERAGE_Diff%],
		format(sum(a.[SOLD_POPULATION]) /sum(a.Relevant_PopuLation),'0.0%') as [SOLD_COVERAGE_%]
		from PN_SCAN_Report2 a 	
		group by a.product ) a 
		left join [2020Q2].dbo.REPORT_1 b on b.[COUNTRY]='PRC' and a.product=b.product 

--select * from PN_SCAN_Report2 where product='Cabin-Filter' and material is not null
--select * from [2020Q2].dbo.REPORT_2 where product='Cabin-Filter' and land='PRC'
-----------------------------------------------------
/*

--特殊模拟--只看新增GAP：
if OBJECT_ID('report_FAS_popul_simul_replacement') is not null drop table report_FAS_popul_simul_replacement
select distinct [EKTNR], PN
into report_FAS_popul_simul_replacement
from
(
SELECT  
      [EKTNR]
      ,[ERFNR]
      ,left([MNRVG],10) as PN     
  FROM [2020Q2].[dbo].[z08mm_ersvwket]
  where left([MNRVG],10)<>left([MNRNF],10)
  union all

  SELECT  
      [EKTNR]
      ,[ERFNR]   
      ,left([MNRNF],10) as PN  
  FROM [2020Q2].[dbo].[z08mm_ersvwket]
  where left([MNRVG],10)<>left([MNRNF],10)
   
) a
 order by [EKTNR]
 select * from report_FAS_popul_simul_replacement 

 */
 --SpiderB中所有covered,对应的FAS中料号，还缺FAS有spiderB无的
 --select * into PN_SpiderB_FAS_Covered_Merge from report_FAS_popul_simul_Detail
 --drop table report_FAS_popul_simul_Detail
if OBJECT_ID('PN_SpiderB_FAS_Covered_Merge') is not null drop table PN_SpiderB_FAS_Covered_Merge
select distinct *,cast('' as nvarchar(10)) as 'ProCoM_Status'  into PN_SpiderB_FAS_Covered_Merge
from (
--有替代关系的
	select distinct iif(a.product is null, b.product, a.product) as product,iif(a.FASKey is null, b.FASKey, a.FASKey) as FasKey,a.RG_POPULATION,a.appdes,a.product_number,a.relevant_population,a.covered_population,a.sold_population, a.newStatus
		  ,b.prkey as Prkey_ProCoM
		  ,b.[MATERIAL] as [MATERIAL_ProCoM]    
		  ,b.[RELEVANT_POPULATION] as [RELEVANT_POPULATION_ProCoM]
		  ,b.[COVERED_POPULATION] as [COVERED_POPULATION_ProCoM]
		  ,b.[SOLD_POPULATION] as [SOLD_POPULATION_ProCoM]
		  --,e.CoveredStatus
		  --,c.*
		  --,d.*
	 from PN_SpiderB2FAS_Covered a left join (select * from PN_SCAN_Report2 where  covered_population>0 ) b on a.FASKey=b.FASKey and a.product=b.PRODUCT --and a.product_number=b.MATERIAL
	 left join report_FAS_popul_simul_replacement c on a.product_number=c.PN
	 left join report_FAS_popul_simul_replacement d on b.MATERIAL = d.PN and c.EKTNR=d.EKTNR
	 where c.PN is not null and d.PN is not null
	 --and product_number='F01R00S268'
	 --select * from report_FAS_popul_simul_replacement  where PN='0986AF3214'
	 -- left join (select distinct Product, FASkey, iif(material is not null, 'Covered','GAP') as CoveredStatus from PN_SCAN_KBPRC_ALL where land='PRC') e on b.PRODUCT=e.product and b.faskey=e.faskey
	-- order by iif(a.product is null, b.product, a.product),iif(a.FASKey is null, b.FASKey, a.FASKey)
	union all
--相同料号的（不在替代关系里)	
	select distinct iif(a.product is null, b.product, a.product) as product,iif(a.FASKey is null, b.FASKey, a.FASKey) as FasKey,a.RG_POPULATION,a.appdes, a.product_number,a.relevant_population,a.covered_population,a.sold_population, a.newStatus
		  ,b.prkey as Prkey_ProCoM
		  ,b.[MATERIAL] as [MATERIAL_ProCOM]    
		  ,b.[RELEVANT_POPULATION] as [RELEVANT_POPULATION_ProCoM]
		  ,b.[COVERED_POPULATION] as [COVERED_POPULATION_ProCoM]
		  ,b.[SOLD_POPULATION] as [SOLD_POPULATION_ProCoM]
		  --,e.CoveredStatus
	 from PN_SpiderB2FAS_Covered a left join (select * from PN_SCAN_Report2 --where  covered_population>0  去此，因为wiper等需要两个料号的，如果只连了一个料号 covered_population是0
											 ) b on a.FASKey=b.FASKey and a.product=b.PRODUCT and a.product_number=b.MATERIAL	
	 --where b.MATERIAL='F01R00S268' and a.faskey='WUL0000074'
	 --select * from PN_SCAN_Report2 where MATERIAL='3397007309' and faskey='BMW0001590'
	 --left join (select distinct Product, FASkey, iif(material is not null, 'Covered','GAP') as CoveredStatus from PN_SCAN_KBPRC_ALL where land='PRC') e on b.PRODUCT=e.product and b.faskey=e.faskey	
	--order by iif(a.product is null, b.product, a.product),iif(a.FASKey is null, b.FASKey, a.FASKey)	
) aaa
order by product,FASKey

--select* from PN_SpiderB_FAS_Covered_Merge where faskey='WUL0000074' and product='Fuel Pump'

--FAS有spiderB无的
insert into PN_SpiderB_FAS_Covered_Merge
select distinct  b.product, b.FASKey,cast(b.RG_POPULATION as int),a.appdes, a.product_number,a.relevant_population,0 as covered_population, 0 as sold_population, a.newStatus 
    ,b.prkey as Prkey_ProCoM
	,b.[MATERIAL] as [MATERIAL_ProCoM]    
	,b.[RELEVANT_POPULATION] as [RELEVANT_POPULATION_ProCoM]
	,b.[COVERED_POPULATION] as [COVERED_POPULATION_ProCoM]
	,b.[SOLD_POPULATION] as [SOLD_POPULATION_ProCoM]
	,cast('' as nvarchar(10)) as 'ProCoM_Status'
from PN_SpiderB_FAS_Covered_Merge a right join (select * from PN_SCAN_Report2 --where  covered_population>0   包含relevant
												) b on a.FASKey=b.FASKey and a.product=b.PRODUCT and a.MATERIAL_ProCOM=b.MATERIAL
where a.MATERIAL_ProCOM is null



--select * from PN_SpiderB2FAS_Covered where product_number='F01R00S268' and faskey='WUL0000074'
use SpiderB
--select * from PN_SpiderB_FAS_Covered_Merge  
--spiderB中所有relevant

--spiderb relevant 与procom relevant covered 对接，找出relevant差距
if OBJECT_ID('PN_SpiderB_FAS_Relevant_Merge') is not null drop table PN_SpiderB_FAS_Relevant_Merge
select distinct isnull(aaa.faskey, bbb.faskey) as faskey, isnull(aaa.product,bbb.product) as product,RG_POPULATION,	appdes,	product_number,iif(aaa.faskey is null, 0, relevant_population) as relevant_population,	covered_population,	sold_population,	iif(aaa.faskey is null, 'NR',newStatus) as newStatus,
prkey_procom,MATERIAL_ProCOM,	RELEVANT_POPULATION_ProCoM,	COVERED_POPULATION_ProCoM,	SOLD_POPULATION_ProCoM,	ProCoM_Status
into PN_SpiderB_FAS_Relevant_Merge
--aaa.*,bbb.*
from
(
	SELECT distinct bb.FASKey,aa.product--,cc.*--spiderB中所有relevant，缺没有匹配levelid的faskey
	FROM (select b.Scan_name as product, c.BoschId from (select * from [spb_name_match] where scan_name is not null) b CROSS join  [CommonDB].[dbo].[LevelVehicle] c left join [tbl_NR] a on a.BoschId=c.boschid and a.标记='NR' and b.product_line_code=a.产品线代码 where a.BoschId is null
		 ) aa inner join spb_imp_boschidFaskey bb on aa.[boschid]=bb.boschid   --	where faskey='BMW0000740'  and product='Air filter'
	union all --没有匹配levelid的faskey
	select  distinct bb.FASKey,aa.scan_name as product
	from (select * from [spb_name_match] where scan_name is not null) aa 
	CROSS join
	(select distinct a.FASKey from FAS_Vehicle a left join (select distinct a1.faskey from spb_imp_boschidFaskey a1,(select * from [CommonDB].[dbo].[LevelVehicle] --where carp_2018>0
	) a2 where a1.boschiD=a2.boschID) b on a.FASKey=b.faskey   
	where b.faskey is null and a.RG_POPULATION>0		
	) bb --where bb.faskey='WUL0000074' and scan_name='Fuel Pump'
) aaa
full outer  join PN_SpiderB_FAS_Covered_Merge bbb on aaa.product=bbb.product and aaa.faskey=bbb.FasKey
--where aaa.faskey='FAW0105510' and aaa.product='Wiper (front)'

--select* from PN_SpiderB_FAS_Relevant_Merge where faskey='BMW0000740'  and product='Air filter'
--where aaa.faskey is null
--
/*FAS不存在，力洋存在的faskey
select distinct bb.* from FAS_Vehicle aa 
right join( select b2.* from spb_imp_boschidFaskey b1, [CommonDB].[dbo].[LevelVehicle] b2 where b1.boschid=b2.boschid) bb on aa.faskey=bb.faskey
where aa.faskey is null and carp_2018>0


select * from PN_SpiderB_FAS_Relevant_Merge 
where -- covered_population_procom=0
material_Procom ='3397007309'
--product_number ='3397007309'
and faskey='BMW0001590'

*/

update PN_SpiderB_FAS_Relevant_Merge
set ProCoM_Status='NR'
----------------------------------
update a
set a.ProCoM_Status=b.CoveredStatus
from PN_SpiderB_FAS_Relevant_Merge a,(select distinct Product, FASkey, iif(material is not null, 'Covered','GAP') as CoveredStatus from PN_SCAN_Report2) b
where b.PRODUCT=a.product and b.faskey=a.faskey

update PN_SpiderB_FAS_Relevant_Merge
set newStatus='GAP'
where 	newStatus is null

--select * from PN_SpiderB_FAS_Relevant_Merge where faskey='BEI0000082' and product ='Wiper (front)'

update a
set newStatus=NULL
from PN_SpiderB_FAS_Relevant_Merge a, PN_SpiderB_FAS_Relevant_Merge b
where 	(a.newStatus is null or a.newStatus ='GAP')and a.faskey=b.faskey and a.product=b.product and b.newStatus='Covered'



update PN_SpiderB_FAS_Relevant_Merge
set relevant_population=RG_POPULATION
where 	relevant_population is null and newstatus is not null

update a
set a.RG_POPULATION=b.RG_POPULATION
from PN_SpiderB_FAS_Relevant_Merge a, FAS_Vehicle b
where a.faskey=b.FASKey  and newstatus is not null

--select  * from PN_SpiderB_FAS_Relevant_Merge where newStatus='NR'
--order by product, faskey

--去掉重复出现的
delete a from PN_SpiderB_FAS_Relevant_Merge a,PN_SpiderB_FAS_Relevant_Merge b
where a.faskey=b.faskey and a.product_number=b.product_number and a.MATERIAL_ProCOM is null and b.MATERIAL_ProCOM is not null

delete a from PN_SpiderB_FAS_Relevant_Merge a,PN_SpiderB_FAS_Relevant_Merge b
where a.faskey=b.faskey and a.MATERIAL_ProCOM=b.MATERIAL_ProCOM and a.product_number is null and b.product_number is not null
------------------------------------------------------FAS 回流表--分为四种--------------------------------------------------------
/*
--连：增
select  distinct *,'Connect' as actions
from PN_SpiderB_FAS_Relevant_Merge 
where product_number is not null and MATERIAL_ProCOM is null and RG_POPULATION>0
--order by product,RG_POPULATION desc
union all 
--断：删
select  distinct *,'DisConnect' as actions
from PN_SpiderB_FAS_Relevant_Merge 
where product_number is null and MATERIAL_ProCOM is not null and RG_POPULATION>0
--and faskey='AUD0002292' and product='Cabin-Filter'
union all 
--设NR
select  distinct *,'set NR' as actions
from PN_SpiderB_FAS_Relevant_Merge 
where newStatus='NR' and ProCoM_Status<>'NR'
--order by product,RG_POPULATION desc
union all 
--取消NR
select  distinct *,'set Relevant' as actions
from PN_SpiderB_FAS_Relevant_Merge 
where newStatus<>'NR' and ProCoM_Status='NR'
order by product,RG_POPULATION desc,faskey
*/

if OBJECT_ID('PN_Back2FAS_Detail') is not null drop table PN_Back2FAS_Detail
--连：增
select distinct faskey, product, appdes, product_number, relevant_population,Procom_status,'Connect' as actions into PN_Back2FAS_Detail
from PN_SpiderB_FAS_Relevant_Merge 
where product_number is not null and MATERIAL_ProCOM is null and RG_POPULATION>0
--order by product,RG_POPULATION desc
union all 
--断：删
select  distinct  faskey, product, Prkey_ProCoM, MATERIAL_ProCoM, relevant_population,Procom_status,'DisConnect' as actions
from PN_SpiderB_FAS_Relevant_Merge 
where product_number is null and MATERIAL_ProCOM is not null and RG_POPULATION>0
--and faskey='AUD0002292' and product='Cabin-Filter'
union all 
--设NR
select  distinct   faskey, product, Prkey_ProCoM, MATERIAL_ProCoM, relevant_population,Procom_status,'set NR' as actions
from PN_SpiderB_FAS_Relevant_Merge 
where newStatus='NR' and ProCoM_Status<>'NR'
--order by product,RG_POPULATION desc
union all 
--取消NR
select  distinct  faskey, product, appdes, product_number, relevant_population,Procom_status,iif(product_number is not null, 'set Relevant & Connect','Set Relevant') as actions
from PN_SpiderB_FAS_Relevant_Merge 
where newStatus<>'NR' and ProCoM_Status='NR'
order by product,faskey,relevant_population desc,actions

--Main Nr

alter table PN_Back2FAS_Detail add 
remark_forMBL nvarchar(255),
[MainNr]  nvarchar(20)


update a
set a.remark_forMBL=b.remark_forMBL,a.mainNr=b.[Main Nr]
--select * 
from PN_Back2FAS_Detail a, PN_SCAN_KBPRC_ALL b
where a.faskey=b.faskey and (a.product_number=b.[Main Nr] or a.product_number=b.material)
--and a.faskey='MB0005925' and b.product='Brake Pad front'


--select a.*,c.[Main Nr]
--from PN_SCAN_KBPRC_ALL a,  [2020Q2].dbo.KBPRC c
--where a.[Main Nr] is null --and a.[Main Nr prod key]=c.[Main Nr prod key]  
--and a.faskey=c.[fas key] --and dbo.ufcompare2PNs(c.[Main Nr],a.MATERIAL)<>'N' 
--and a.faskey='MB0005925' and a.product='Brake Pad front'

----select * from [2020Q2].dbo.KBPRC where [fas key]='MB0005925' and product='Brake Pad fr'

--select * from PN_SCAN_KBPRC_ALL where [faskey]='CRY0000033' and product='Brake Pad front'
--select distinct remark_forMBL from PN_SCAN_KBPRC_ALL where remark_forMBL <>''

--结果表
use spiderb
select * from PN_Back2FAS_Detail 
--select * from PN_SpiderB_FAS_Relevant_Merge
 


--select * from PN_Back2FAS_Detail where faskey='MB0005925' and product='Brake Pad front'
--select * from PN_SCAN_Report2 where faskey='MB0005925' and product='Brake Pad front'

--select * from PN_SCAN_KBPRC_ALL where faskey='MB0005925' and product='Brake Pad front'
----select * from PN_SCAN_KBPRC_ALL where faskey='MB0005925' and product='Brake Pad front'
--select * from PN_SCAN_KBPRC_ALL where [Main Nr] is null and MATERIAL is not null order by product

------------------------------------------------------FAS 回流表 end-----------------------------------------------------------
--select * from PN_Back2FAS_Detail

--select faskey, product, appdes, product_number, relevant_population

--select * from PN_SpiderB_FAS_Relevant_Merge where faskey='BOR0100058' and -- product='Cabin-Filter'
--product_number='3397013888'



--只看GAP
--select  * from PN_SpiderB_FAS_Covered_Merge where  product not like N'%Brake Master Cylinder%'  and ProCoM_Status='GAP'

--所有新增
--if OBJECT_ID('report_Connect') is not null drop table report_Connect
--SELECT [product]
--      ,[FasKey]
--      ,[RG_POPULATION]
--      ,[appdes]
--      ,[product_number]
--      ,round([covered_population],0) as [covered_population]
--      ,round([sold_population],0) as [sold_population]
--      ,[newStatus]
--      --,[MATERIAL_ProCOM]
--      --,[RELEVANT_POPULATION_ProCoM]
--      --,[COVERED_POPULATION_ProCoM]
--      --,[SOLD_POPULATION_ProCoM]
--      ,[ProCoM_Status]
--into report_Connect
--from PN_SpiderB_FAS_Covered_Merge where  product not like N'%Brake Master Cylinder%'  and MATERIAL_ProCOM is null --and newstatus<>'Covered'
--and product_number is not null and [RG_POPULATION]>0

--所有需断开

--if OBJECT_ID('report_DisConnect') is not null drop table report_DisConnect
--SELECT [product]
--      ,[FasKey]
--      --,[RG_POPULATION]
--      --,[appdes]
--      --,[product_number]
--      --,[covered_population]
--      --,[sold_population]
--      --,[newStatus]
--      ,[MATERIAL_ProCOM]
--      ,round([RELEVANT_POPULATION_ProCoM],0) as [RELEVANT_POPULATION_ProCoM]
--      ,round([COVERED_POPULATION_ProCoM],0) as [COVERED_POPULATION_ProCoM]
--      ,round([SOLD_POPULATION_ProCoM],0) as [SOLD_POPULATION_ProCoM]
--      ,[ProCoM_Status]
	  
--into report_DisConnect
--from PN_SpiderB_FAS_Covered_Merge where  product not like N'%Brake Master Cylinder%'  and product_number is null

--select * from report_DisConnect

--  alter table report_DisConnect add 
--MainNumber nvarchar(20)

--update a
--set a.MainNumber=b.[Main Nr]
--from report_DisConnect a,(SELECT 
--      [FASkey]
   
--      ,material     
--      ,[Main Nr]
--      ,[Main Nr prod key]     
--      ,[Main Nr spec case]     
--  FROM PN_SCAN_KBPRC_ALL) b
--  where a.MATERIAL_ProCOM=b.material


--select * from report_DisConnect a full outer join PN_Back2FAS_Detail b
--on a.faskey=b.faskey and a.product=b.product and a.MATERIAL_ProCoM=b.product_number
--where b.actions='Disconnect' and a.MATERIAL_ProCoM is null


  --select * from report_DisConnect
  -- select * from report_DisConnectOri

--select * from PN_SCAN_KBPRC_ALL where land ='PRC' and material ='0986480966'

------------------------------------------------------只增GAP，模拟coverage-----------------------------------------------------------
select * from PN_SpiderB_FAS_Relevant_Merge where product='fuel pump'

if OBJECT_ID('report_FAS_popul_simul_increase') is not null drop table report_FAS_popul_simul_increase
select aa.product, aa.relvent_popul as relevant_popul_simul,bb.covered_popul as covered_popul_simul,bb.sold_popul as sold_popul_simul,
bb.covered_popul/aa.relvent_popul as MC_simul_increase,bb.sold_popul/aa.relvent_popul as SC_simul_increase
--,cc.relevant_population,cc.COVERED_POPULATION,cc.SOLD_POPULATION,cc.[MARKET_COVERAGE_%],cc.[SOLD_COVERAGE_%]
--,format(bb.covered_popul/aa.relvent_popul+cast(replace(cc.[MARKET_COVERAGE_%],'%','') as float)/100,'0.00%') as MC_simul,
--format(bb.sold_popul/aa.relvent_popul+cast(replace(cc.[SOLD_COVERAGE_%],'%','') as float)/100,'0.00%') as SC_simul
into report_FAS_popul_simul_increase
from 
(SELECT   [PRODUCT]   ,sum(relevant_population) as relvent_popul   FROM PN_SCAN_Report2 group by product) aa left join

(select product,sum(covered_population) as covered_popul, sum(sold_population) as sold_popul
from (select distinct faskey,appdes,product_number, product,rg_population,covered_population,sold_population from PN_SpiderB_FAS_Relevant_Merge where ProCoM_Status='GAP' and product_number is not null ) b
group by product
) bb
on aa.product=bb.product
--right join(
--select product, relevant_population,Covered_population,sold_population,[MARKET_COVERAGE_%],[SOLD_COVERAGE_%] FROM [2020Q2].[dbo].[report_1] where country='PRC'
--) cc on aa.product=cc.product
--where aa.product is not null
--select distinct faskey,appdes,product_number, product,rg_population,covered_population,sold_population from PN_SpiderB_FAS_Relevant_Merge 
--where ProCoM_Status='GAP' and product_number is not null and product ='Wiper (front)'
---------------------------------------------跌----------------------------------------
if OBJECT_ID('report_FAS_popul_simul_decrease') is not null drop table report_FAS_popul_simul_decrease
select aa.product, aa.relvent_popul as relevant_popul_simul,bb.covered_popul as covered_popul_simul,bb.sold_popul as sold_popul_simul,
-bb.covered_popul/aa.relvent_popul as MC_simul_decrease,-bb.sold_popul/aa.relvent_popul as SC_simul_decrease
--,cc.relevant_population,cc.COVERED_POPULATION,cc.SOLD_POPULATION,cc.[MARKET_COVERAGE_%],cc.[SOLD_COVERAGE_%]
--,format(-bb.covered_popul/aa.relvent_popul+cast(replace(cc.[MARKET_COVERAGE_%],'%','') as float)/100,'0.00%') as MC_simul,
--format(-bb.sold_popul/aa.relvent_popul+cast(replace(cc.[SOLD_COVERAGE_%],'%','') as float)/100,'0.00%') as SC_simul
into report_FAS_popul_simul_decrease
from 
(SELECT   [PRODUCT]   ,sum(relevant_population) as relvent_popul   FROM PN_SCAN_Report2 group by product) aa left join

(select product,sum(covered_population_procom) as covered_popul, sum(sold_population_procom) as sold_popul --因为同一个料号有用不同product key连两次的,所以加prkey_procom
from (select distinct faskey,prkey_procom,MATERIAL_ProCoM, product,rg_population,covered_population_procom,sold_population_procom from PN_SpiderB_FAS_Relevant_Merge where newStatus='GAP' and ProCoM_Status='Covered' ) b
group by product
) bb
on aa.product=bb.product
--right join(
--select product, relevant_population,Covered_population,sold_population,[MARKET_COVERAGE_%],[SOLD_COVERAGE_%] FROM [2020Q2].[dbo].[report_1] where country='PRC'
--) cc on aa.product=cc.product
--where aa.product is not null
--select * from PN_SpiderB_FAS_Relevant_Merge where ProCoM_Status='GAP'

--select * from PN_SpiderB_FAS_Relevant_Merge where faskey='BEI0000082' and product like '%wiper%'
--select * from PN_SpiderB_FAS_Relevant_Merge where   product like '%wiper%' 

--select distinct faskey,MATERIAL_ProCoM, product,rg_population,covered_population_procom,sold_population_procom 
--from PN_SpiderB_FAS_Relevant_Merge where newStatus='GAP' and ProCoM_Status='Covered'and product like '%wiper%'
--order by faskey

--select product,sum(rg_population) as covered_popul, sum(rg_population) as sold_popul --不用covered_population是因为同一个料号有用不同product key连两次的
--from (select distinct faskey, product,rg_population from PN_SpiderB_FAS_Relevant_Merge where newStatus='GAP' and ProCoM_Status='Covered' ) b
--group by product


--select * from PN_SpiderB_FAS_Relevant_Merge where product ='Wiper (front)'
------------------------------------------------------断开-----------------------------------------------------------------------------


--模拟coverage---FAS当前（SC较新），增加，减少，其他变动(NR,R)，最终
if OBJECT_ID('report_FAS_popul_simul') is not null drop table report_FAS_popul_simul
select bb.[PRODUCT],bb.FAS_RELEVANT_POPULATION,bb.FAS_COVERED_POPULATION
,format(bb.[FAS_MARKET_COVERAGE%],'0.0%') as [FAS_MARKET_COVERAGE%],format(bb.[FAS_SOLD_COVERAGE%],'0.0%')  as [FAS_SOLD_COVERAGE%]
,format(cc.MC_simul_increase,'0.0%') as MC_simul_increase,format(cc.SC_simul_increase,'0.0%') as SC_simul_increase,format(dd.MC_simul_decrease,'0.0%') as MC_simul_decrease,format(dd.SC_simul_decrease,'0.0%') as SC_simul_decrease
,format(cast(isnull(aa.New_MC,0) as float)-cast(isnull(bb.[FAS_MARKET_COVERAGE%],0) as float)-cast(isnull(cc.MC_simul_increase,0) as float)-cast(isnull(dd.MC_simul_decrease,0) as float),'0.0%') as MC_other_change
,format(cast(aa.New_SC as float)-cast(bb.[FAS_SOLD_COVERAGE%] as float)-cast(cc.SC_simul_increase as float)-cast(dd.SC_simul_decrease as float),'0.0%') as SC_other_change
,aa.New_relevant_popul,aa.New_covered_popul,aa.New_sold_popul
,format(aa.New_MC,'0.0%') as New_MC,format(aa.New_SC,'0.0%') as New_SC
into report_FAS_popul_simul
from
	(
	select a.product, sum(a.relevant_population) as New_relevant_popul,sum(covered_population) as New_covered_popul,sum(sold_population) as New_sold_popul,
	sum(covered_population)/sum(a.relevant_population) as New_MC,sum(sold_population)/sum(a.relevant_population) as New_SC
	--into report_FAS_popul_simul
	from 
	(select distinct faskey,product,RG_POPULATION,product_number,relevant_population,covered_population,sold_population,newStatus from PN_SpiderB_FAS_Relevant_Merge 
	where newstatus <>'NR' --and product like '%wiper%'
	) a
	group by product) aa, 
(select a.[PRODUCT], 
		sum(a.[RELEVANT_POPULATION]) as [FAS_RELEVANT_POPULATION] ,
		sum(a.[COVERED_POPULATION]) as [FAS_COVERED_POPULATION],
		sum(a.[SOLD_POPULATION]) as [FAS_SOLD_POPULATION],
		sum(a.Covered_PopuLation) /sum(a.Relevant_PopuLation) as [FAS_MARKET_COVERAGE%],
		sum(a.[SOLD_POPULATION]) /sum(a.Relevant_PopuLation) as [FAS_SOLD_COVERAGE%]
		from PN_SCAN_Report2 a 	
		group by a.product ) bb,
report_FAS_popul_simul_increase cc,
report_FAS_popul_simul_decrease dd
where aa.product=bb.product and aa.product=cc.product and aa.product=dd.product --and aa.New_MC is not null

use SpiderB
select * from report_FAS_popul_simul

--if OBJECT_ID('report_FAS_popul_simul') is not null drop table report_FAS_popul_simul
--select bb.*
--,cc.MC_simul_increase,cc.SC_simul_increase,dd.MC_simul_decrease,dd.SC_simul_decrease
--,format(cast(isnull(aa.New_MC,0) as float),'0.00%')
-----cast(bb.[FAS_MARKET_COVERAGE%] as float)-cast(cc.MC_simul_increase as float)-cast(dd.MC_simul_decrease as float),'0.0%') as MC_other_change
----,format(cast(aa.New_SC as float)-cast(bb.[FAS_SOLD_COVERAGE_%] as float)-cast(cc.SC_simul_increase as float)-cast(dd.SC_simul_decrease as float),'0.0%') as SC_other_change
--,aa.New_relevant_popul,aa.New_covered_popul,aa.New_sold_popul,aa.New_MC,aa.New_SC
--from
--	(
--	select a.product, sum(a.relevant_population) as New_relevant_popul,sum(covered_population) as New_covered_popul,sum(sold_population) as New_sold_popul,
--	format(sum(covered_population)/sum(a.relevant_population),'0.00%') as New_MC,format(sum(sold_population)/sum(a.relevant_population),'0.00%') as New_SC
--	--into report_FAS_popul_simul
--	from 
--	(select distinct faskey,product,RG_POPULATION,product_number,relevant_population,covered_population,sold_population,newStatus from PN_SpiderB_FAS_Relevant_Merge 
--	where newstatus <>'NR'
--	) a
--	group by product) aa, 
--(select a.[PRODUCT], 
--		sum(a.[RELEVANT_POPULATION]) as [FAS_RELEVANT_POPULATION] ,
--		sum(a.[COVERED_POPULATION]) as [FAS_COVERED_POPULATION],
--		sum(a.[SOLD_POPULATION]) as [FAS_SOLD_POPULATION],
--		format(sum(a.Covered_PopuLation) /sum(a.Relevant_PopuLation),'0.0%') as [FAS_MARKET_COVERAGE%],
--		format(sum(a.[SOLD_POPULATION]) /sum(a.Relevant_PopuLation),'0.0%') as [FAS_SOLD_COVERAGE_%]
--		from PN_SCAN_Report2 a 	
--		group by a.product ) bb,
--report_FAS_popul_simul_increase cc,
--report_FAS_popul_simul_decrease dd
--where aa.product=bb.product and aa.product=cc.product and aa.product=dd.product --and aa.New_MC is not null


------wiper试一下，是否真这么低
--select distinct faskey,product,RG_POPULATION,relevant_population,covered_population,sold_population,newStatus from PN_SpiderB_FAS_Relevant_Merge 
--	where newstatus <>'NR' and product like '%wiper%'

--	select * from PN_SpiderB_FAS_Relevant_Merge where product like '%wiper%'

--select distinct faskey,product,RG_POPULATION,relevant_population,covered_population,sold_population,newStatus from PN_SpiderB_FAS_Relevant_Merge 
--	where newstatus is null

	--and faskey='AUD0001977'
--select  b.[PRODUCT], a.covered_population as cal_covered, b.COVERED_POPULATION as repor1_covered,
-- round(a.[RELEVANT_POPULATION] -b.Relevant_PopuLation,0) as [Relevant_populationDiff],
-- round(a.[COVERED_POPULATION]-b.Covered_PopuLation,0) as [covered_populationDiff],
-- round(a.[SOLD_POPULATION] -b.[SOLD_POPULATION],0) as [sold_populationDiff],
--format(iif(a.Relevant_PopuLation>0,a.Covered_PopuLation /a.Relevant_PopuLation,0)-cast(replace(b.[MARKET_COVERAGE_%],'%','') as float)/100, '0.0%') as [MARKET_COVERAGE_Diff%],
--format(iif(a.Relevant_PopuLation>0,a.[SOLD_POPULATION] /a.Relevant_PopuLation,0)-cast(replace(b.[SOLD_COVERAGE_%],'%','') as float)/100, '0.0%') as [SOLD_COVERAGE_%]
--from (select a.[PRODUCT], 
--		sum(a.[RELEVANT_POPULATION]) as [RELEVANT_POPULATION] ,
--		sum(a.[COVERED_POPULATION]) as [COVERED_POPULATION],
--		sum(a.[SOLD_POPULATION]) as [SOLD_POPULATION],
--		format(sum(a.Covered_PopuLation) /sum(a.Relevant_PopuLation),'0.0%') as [MARKET_COVERAGE_Diff%],
--		format(sum(a.[SOLD_POPULATION]) /sum(a.Relevant_PopuLation),'0.0%') as [SOLD_COVERAGE_%]
--		from PN_SCAN_Report2 a 	
--		group by a.product ) a 
--		left join [2020Q2].dbo.REPORT_1 b on b.[COUNTRY]='PRC' and a.product=b.product 


--select * from spb_tbl_result

--检查无效料号具体连接情况
	  SELECT a.*,c.[Target Population],f.[Status]
	  FROM [SpiderB].[dbo].[spb_tbl_result] a inner join [SpiderB].[dbo].[tbl_ProductKeyProductLine] b on a.[AppDes] =b.ProductKey
	  left join spb_imp_vehicle_population c on a.[bosch_id]=c.boschid
	  left join PCDAll f on a.product_number=f.PN  
	  where  
	  b.productline ='PL025' and (f.[Status] not in ('40','49') or f.Status is null)
	 and [Target Population]>0 
	  -- and product_number='F01R00S268'


	--select * from PCDAll where --[status] not in ('40','49','50')
	--PN='F01R00S268'

--use spiderb

--select * from report_FAS_popul_simul
