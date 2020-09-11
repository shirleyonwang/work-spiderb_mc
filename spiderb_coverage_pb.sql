use SpiderB

/* for powerBI

SGHZ001026043
SpiderB



Product_Line_Name	Product_Line_Code
AA-AS     	PL001
AA-ATR    	PL002
CG-PAB Other	PL003
AA-OTH    	PL004
AA-PAC    	PL005
AA-PAD    	PL006
AA-PAE    	PL007
AA-PAF Other	PL008
AA-PAG Other	PL009
AA-PAR Other	PL010
AA-PAS    	PL011
CG-PAR	PL012
Air filter	PL014
Battery	PL015
Brake disk fr	PL016
Brake disk Rr	PL017
Brake pad fr	PL018
Brake pad rr	PL019
Brake Shoe	PL020
Brake Wheel Cyl	PL021
Cabin filter	PL022
Fuel filter	PL024
Fuel pump	PL025
Ignition coil	PL026
Lambda sensor	PL027
Oil filter	PL028
Spark plug	PL029
Wiper	PL030
Brake Booster	PL031
Brake Master cylinder	PL032
Brake Slave cylinder	PL033
Brake wear sensor	PL035
Engine Oil	PL036
Transmission oil	PL037
High-pressure injector GDI	PL038
High-pressure pump GDI	PL039

*/
--select distinct Product_Line_Code from spiderb_application_for_powerBI
--(select * from [SpiderB].[dbo].[spb_name_match] where [Scan_Name] is not null) 
--select * from spb_name_match where Product_Line_Code in ('PL027','PL029','PL026','PL022','PL024','PL025')

--������������

  update a
  set HMLPP='UD'
  --select distinct HMLPP 
  from [CommonDB].[dbo].[LevelVehicle] a  
  where HMLPP is null

    update a
  set OEMBrand='UD'
  --select distinct OEMBrand 
  from [CommonDB].[dbo].[LevelVehicle] a  
  where OEMBrand is null or OEMBrand not like '%OEM'
 

  --select distinct ������� 
  --from [CommonDB].[dbo].[LevelVehicle] a  
  --where OEMBrand is null or OEMBrand not like '%OEM'

if OBJECT_ID('map_productline_other') is not null drop table map_productline_other
SELECT *
into map_productline_other
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 new\TS Import\28.OE_productLine_otherӳ��.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 


if OBJECT_ID('other_detail') is not null drop table other_detail
SELECT [_Level ID] as levelID,
[�����Ȧ_OE��],
[��ѹ������_OE��],
[��ѹ�ͱ�_OE��],
[����������_OE��],
[���ƶ���/��_OE��],
[���ƶ�Ƭ/��_OE��],
[����_OE��],
[����������_OE��],
[����������_OE��],
[�յ�������_OE��],
[ǰ��������_OE��],
[ǰ�ƶ��ֱ�_OE��],
[ǰ�ƶ���_OE��],
[ǰ�ƶ�Ƭ_OE��],
[ȼ�ͱ�_OE��],
[ȼ��������_OE��],
[����_OE��],
[���������_OE��],
[�ƶ��ܱ�_OE��],
[�ƶ�����_OE��],
[�ƶ��ֱ�_OE��]
into other_detail
 FROM OpenDataSource
 ( 'Microsoft.ACE.OLEDB.12.0',
 'Data Source=C:\Work\Spider B\start\data prepare 2020 new\TS Import\other_0821.xlsx;
 User ID=Admin;Password=;Extended properties=Excel 12.0')...[Sheet1$] 


 --select * from other_detail
 if OBJECT_ID('other_detail_v') is not null drop table other_detail_v
select levelID, N'�����Ȧ_OE��' as  product , [�����Ȧ_OE��] as OENumber into other_detail_v from other_detail 
union  select levelID, N'��ѹ������_OE��' as  product , [��ѹ������_OE��] as OENumber from other_detail 
union  select levelID, N'��ѹ�ͱ�_OE��' as  product , [��ѹ�ͱ�_OE��] as OENumber from other_detail 
union  select levelID, N'����������_OE��' as  product , [����������_OE��] as OENumber from other_detail 
union  select levelID, N'���ƶ���/��_OE��' as  product , [���ƶ���/��_OE��] as OENumber from other_detail 
union  select levelID, N'���ƶ�Ƭ/��_OE��' as  product , [���ƶ�Ƭ/��_OE��] as OENumber from other_detail 
union  select levelID, N'����_OE��' as  product , [����_OE��] as OENumber from other_detail 
union  select levelID, N'����������_OE��' as  product , [����������_OE��] as OENumber from other_detail 
union  select levelID, N'����������_OE��' as  product , [����������_OE��] as OENumber from other_detail 
union  select levelID, N'�յ�������_OE��' as  product , [�յ�������_OE��] as OENumber from other_detail 
union  select levelID, N'ǰ��������_OE��' as  product , [ǰ��������_OE��] as OENumber from other_detail 
union  select levelID, N'ǰ�ƶ��ֱ�_OE��' as  product , [ǰ�ƶ��ֱ�_OE��] as OENumber from other_detail 
union  select levelID, N'ǰ�ƶ���_OE��' as  product , [ǰ�ƶ���_OE��] as OENumber from other_detail 
union  select levelID, N'ǰ�ƶ�Ƭ_OE��' as  product , [ǰ�ƶ�Ƭ_OE��] as OENumber from other_detail 
union  select levelID, N'ȼ�ͱ�_OE��' as  product , [ȼ�ͱ�_OE��] as OENumber from other_detail 
union  select levelID, N'ȼ��������_OE��' as  product , [ȼ��������_OE��] as OENumber from other_detail 
union  select levelID, N'����_OE��' as  product , [����_OE��] as OENumber from other_detail 
union  select levelID, N'���������_OE��' as  product , [���������_OE��] as OENumber from other_detail 
union  select levelID, N'�ƶ��ܱ�_OE��' as  product , [�ƶ��ܱ�_OE��] as OENumber from other_detail 
union  select levelID, N'�ƶ�����_OE��' as  product , [�ƶ�����_OE��] as OENumber from other_detail 
union  select levelID, N'�ƶ��ֱ�_OE��' as  product , [�ƶ��ֱ�_OE��] as OENumber from other_detail 
union  select levelID, N'���ƶ�Ƭ/��_OE��' as  product , [���ƶ�Ƭ/��_OE��] as OENumber from other_detail 


if OBJECT_ID('spiderb_application_for_powerBI') is not null drop table spiderb_application_for_powerBI
select aa.Product_Line_Code,aa.Product_Line_Name,aa.boschid as bosch_id,bb.appdes,bb.product_number,CAST(aa.���±����� AS nvarchar(255)) as [latest_popul],cast(aa.Ŀ�걣���� as nvarchar(255)) as [target_popul]--aa.Ʒ��,aa.����,aa.������� as SOP, aa.FASkey,aa.HMLPP,aa.OEMBrand-- ,cast('' as nvarchar(255)) as OENumber
		,0 as cnt, cast(0 as float ) as sales,cast(0 as float ) as relevant_target_popul,cast(0 as float ) as relevant_latest_popul, cast('' as nvarchar(20)) as application_status
into spiderb_application_for_powerBI
from
	 (
	  SELECT distinct a.Product_Line_Name,a.Product_Line_Code,b.BoschID,b.Ʒ��,b.����,b.�������,CAST(b.Carp_2018 AS nvarchar(255)) as [Ŀ�걣����],CAST(b.Carp_2019 AS nvarchar(255)) as [���±�����],b.FASkey,b.HMLPP,b.OEMBrand
	  FROM  --(select * from spb_name_match where Product_Line_Code in ('PL027','PL029','PL026','PL022','PL024','PL025')) a 
	  --spb_name_match a
	  (select * from spb_name_match where Product_Line_Code >'PL013' ) a 
	  CROSS join [CommonDB].[dbo].[LevelVehicle] b  left join [SpiderB].[dbo].[tbl_NR] c on b.boschid=c.BoschId and a.product_line_code =c.��Ʒ�ߴ���
	  where c.��� is null
	  ) aa
	  left join
	  (
	  SELECT distinct a.*,b.productline
	  FROM [SpiderB].[dbo].[spb_tbl_result] a, [SpiderB].[dbo].[tbl_ProductKeyProductLine] b, (select * from [SpiderB].[dbo].[Mara] where [MSTAE] in ('40','49'))c
	  where a.[AppDes] =b.ProductKey and a.product_number=c.MATNR
	  ) bb on aa.BoschID=bb.bosch_id and aa.Product_Line_Code=bb.ProductLine

--select count(*) from spiderb_application_for_powerBI
--select * from [CommonDB].[dbo].[LevelVehicle] where ������� is null

-- add columns
--alter table spiderb_application_for_powerBI add
--cnt int,
--relevant_target_popul float,
--sales int,
--relevant_latest_popul float

--update a
--set a.OENumber=c.OENumber -- select *
--from spiderb_application_for_powerBI a,map_productline_other b,other_detail_v c,[CommonDB].[dbo].[LevelVehicle] d
--where a.Product_Line_Code=b.[product line] and b.[other name]=c.product and a.bosch_id=d.BoschID and c.levelID=d.����ID




--udpate cnt
update a
set a.cnt= b.cnt,a.relevant_target_popul= cast([target_popul] as float)/b.cnt,a.relevant_latest_popul=cast([latest_popul] as float)/b.cnt
from spiderb_application_for_powerBI a,
(select Product_Line_Code,bosch_id,count(*) as cnt from spiderb_application_for_powerBI --where product_number is null
group by Product_Line_Code,Product_Line_Name,bosch_id
) b 
where a.Product_Line_Code=b.Product_Line_Code and a.bosch_id=b.bosch_id

--udpate sales 12mins
update a
set a.sales=b.sales
from spiderb_application_for_powerBI a, [spb_imp_sales] b
where a.product_number=b.product_number and b.sale_org='PRC'

--update application_status
update spiderb_application_for_powerBI
set application_status=iif(sales>0,'Sold',iif(product_number is not null, 'Unsold','Gap'))

update spiderb_application_for_powerBI
set application_status='Gap'
where application_status is null or application_status =''

--select top 100 * from spiderb_application_for_powerBI where product_number is  null

--select top 100 relevant_target_popul, * from spiderb_application_for_powerBI where relevant_target_popul is null

/***************************************************************OE Number*************************************************************/
--OE ��

select * from other_detail_v where OENumber is not null

if OBJECT_ID('tbl_other_detail_v_single') is not null drop table tbl_other_detail_v_single

select distinct a.levelID,a.product,OENumber = substring(a.OENumber , b.number , charindex(',' , a.OENumber + ',' , b.number) - b.number)
into tbl_other_detail_v_single
from other_detail_v a join master..spt_values  b
on b.type='p' and b.number between 1 and len(a.OENumber)
where substring(',' + a.OENumber , b.number , 1) = ','


--OE table
if OBJECT_ID('spiderb_OE_for_powerBI') is not null drop table spiderb_OE_for_powerBI
select a.[product line] as Product_Line_Code,b.BoschID as bosch_id,c.OENumber,cast(0 as float) as OE_target_popul,cast(0 as float) as OE_latest_popul, 0 as cnt
		,cast('' as nvarchar(20)) as application_status
into spiderb_OE_for_powerBI
from map_productline_other a,tbl_other_detail_v_single c,[CommonDB].[dbo].[LevelVehicle] b
where a.[other name]=c.product and c.levelID=b.����ID and c.OENumber is not null

--udpate cnt
update a
set a.cnt= b.cnt,a.OE_target_popul= cast(c.Carp_2018 as float)/b.cnt,a.OE_latest_popul=cast(c.Carp_2019 as float)/b.cnt
--select * 
from spiderb_OE_for_powerBI a,
(select Product_Line_Code,bosch_id,count(*) as cnt from spiderb_OE_for_powerBI where OENumber is not null
group by Product_Line_Code,bosch_id
) b ,[CommonDB].[dbo].[LevelVehicle] c
where a.Product_Line_Code=b.Product_Line_Code and a.bosch_id=b.bosch_id and a.bosch_id=c.BoschID

--update sold
update a
set a.application_status=b.application_status
--select * ,a.application_status
from spiderb_OE_for_powerBI a, (select * from spiderb_application_for_powerBI where application_status='Sold') b
where a.bosch_id=b.bosch_id and a.Product_Line_Code=b.Product_Line_Code

--update unsold
update a
set a.application_status=b.application_status
--select * ,a.application_status
from spiderb_OE_for_powerBI a, (select * from spiderb_application_for_powerBI where application_status='Unsold') b
where a.bosch_id=b.bosch_id and a.Product_Line_Code=b.Product_Line_Code
and (a.application_status is null or a.application_status ='')

--update gap
update a
set a.application_status=b.application_status
--select * ,a.application_status
from spiderb_OE_for_powerBI a, (select * from spiderb_application_for_powerBI where application_status='Gap') b
where a.bosch_id=b.bosch_id and a.Product_Line_Code=b.Product_Line_Code
and (a.application_status is null or a.application_status ='')

select * from spiderb_OE_for_powerBI where application_status is null
--select  application_status from (select distinct application_status from spiderb_application_for_powerBI) a
--order by CHARINDEX(application_status, 'SoldUnsoldGap') 


--alter table spiderb_OE_for_powerBI add
--application_status nvarchar(20)

--select top 100 * from spiderb_application_for_powerBI where SOP is null
--select distinct SOP from spiderb_application_for_powerBI


--exec master..xp_cmdshell 'bcp "select ''Product_Line_Code'',''Product_Line_Name'',''bosch_id'',''appdes'',''product_number'',''FASkey'',''HMLPP'',''OEMBrand'',''���±�����'',''Ŀ�걣����'',''OENumber'' union all select top 10 *  from [SpiderB].[dbo].[spiderb_application_for_powerBI] " queryout "C:\Work\Spider B\start\data prepare 2020 new\spiderB_application.txt" -c -t"|" -T'

--exec master..xp_cmdshell 'bcp " select  * from [SpiderB].[dbo].[spiderb_application_for_powerBI]  " queryout "C:\Work\Spider B\start\data prepare 2020 new\spiderB_application.txt" -c -t"|" -T'

--Product_Line_Code|Product_Line_Name|bosch_id|appdes|product_number|FASkey|HMLPP|OEMBrand|���±�����|Ŀ�걣����|OENumber

--exec master..xp_cmdshell 'bcp "select ''Product_Line_Code'',''Product_Line_Name'',''bosch_id'',''appdes'',''product_number'',''FASkey'',''HMLPP'',''OEMBrand'',''latest_population'',''target_population'',''OENumber'' union all select * from [SpiderB].[dbo].[spiderb_application_for_powerBI] " queryout "C:\Work\Spider B\start\data prepare 2020 new\spiderB_application2.txt" -c -t"|" -T'
if OBJECT_ID('tbl_vehicle_population') is not null drop table tbl_vehicle_population
select BoschID, 'target_population' as Carpac_Type ,Carp_2018 as carparc 
into tbl_vehicle_population
from CommonDB.dbo.LevelVehicle 
union all
select BoschID, 'latest_population', Carp_2019 from CommonDB.dbo.LevelVehicle 

update tbl_vehicle_population set carparc=0 where carparc is null



