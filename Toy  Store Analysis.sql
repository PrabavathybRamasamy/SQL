---Sales Domain Analysis 
---Toy  Store Analysis

Create database toy_store_sales_db
use toy_store_sales_db
create table sales(sale_ID varchar(max), Date varchar(max), store_ID varchar(max), Units varchar(max))

Select * from sales

Select column_name,data_type from INFORMATION_SCHEMA.COLUMNS

bulk insert sales from 'C:\Users\praba\OneDrive\Documents\DB datas\Projects\Sql\sales.csv' with
(fieldterminator=',',
 rowterminator='\n',
 firstrow=2,
 maxerrors=20);

 Select*from sales

 Create table products (Product_ID varchar(max), Product_Category varchar(max), Product_Cost varchar(max),
 Product_Price varchar(max))

 bulk insert products from 'C:\Users\praba\OneDrive\Documents\DB datas\Projects\Sql\products.csv' with
(fieldterminator=',',
 rowterminator='\n',
 firstrow=2,
 maxerrors=20);

 Select*from products

 create table stores
(Store_ID	varchar(max),Store_Name varchar(max),	Store_City varchar(max),	Store_Location varchar(max),
	Store_Open_Date varchar(max))

	Truncate table stores;

	bulk insert stores
from /* path of the file*/ 'C:\Users\praba\OneDrive\Documents\DB datas\Projects\Sql\stores.csv'
with 
	(fieldterminator=',',
	 rowterminator='\n',
	 firstrow=2,
	 maxerrors=20);


	 Select*from stores

	 create table inventory
(Store_ID varchar(max),	Product_ID varchar(max),Stock_On_Hand varchar(max))

bulk insert inventory
from /* path of the file*/ 'C:\Users\praba\OneDrive\Documents\DB datas\Projects\Sql\inventory.csv'
with 
	(fieldterminator=',',
	 rowterminator='\n',
	 firstrow=2,
	 maxerrors=20);

	 select*from inventory

 select column_name,data_type
from INFORMATION_SCHEMA.columns where table_name='Sales'

select * from sales

---check the sales_id distinct values

select count(distinct sale_id) from sales

--- we'll try to convert the datatype
alter table sales
alter column sale_id int

--- we have found that we have some non numeric values in our sale_id column
-- to check the non numeric values in a numeric column

select * from sales
where isnumeric(sale_id)=0   /* this will check the non numeric values (means any alphanumeric or characters or symbols on it)*/

--- How to remove the anamolies from here..
-- think of it, if we have more than 20000 values like this
--- S0001, s%0001, S-10001
--- we can try some character function or logics , where we can assign this task to SQL

select sale_id, replace(sale_id,substring(sale_id,patindex('%[^0-9]%',Sale_id),1),''),
substring(sale_id,patindex('%[^0-9]%',Sale_id),1),patindex('%[^0-9]%',Sale_id) from sales
where isnumeric(sale_id)=0

--- before updating the value try with the query

update sales set sale_id=replace(sale_id,substring(sale_id,patindex('%[^0-9]%',Sale_id),1),'')
where isnumeric(sale_id)=0

alter table sales
alter column sale_id int

select * from sales
	
--- change the datatype of 'Date' field to date from varchar
alter table sales
alter column [date] int

-- let's check the anamolies in the date column

select date from sales
where isdate(date)=0   -- this is to check the non date formats

select date from sales
-- we'll try to use Try and get method
--- we are using try_convert function 
--- try_convert is similar to convert function but where we have any conversion error it replace with 'Null' values
select sale_id,date, convert(varchar(20),try_convert(date, [date]),23) from sales
where convert(varchar(20),try_convert(date, [date]),23) is null
---- try using this and update the anamoly with the correct date

-- 4/2022/01,, new_value- 01/04/2022

update sales set date= '01/04/2022'
where convert(varchar(20),try_convert(date, [date]),23) is null

alter table sales
alter column date date

select date from sales

select * from sales

alter table sales
alter column store_id int

select * from sales
where isnumeric(store_ID)=0

UPDATE sales 
SET store_id = NULL 
WHERE ISNUMERIC(store_id) = 0;


alter table sales
alter column store_id int;

alter table sales
alter column product_id int

SELECT * 
FROM products 
WHERE ISNUMERIC(product_id) = 0;

UPDATE products 
SET product_id = REPLACE(product_id, SUBSTRING(product_id, PATINDEX('%[^0-9]%', product_id), 1), '')
WHERE ISNUMERIC(product_id) = 0;

alter table products
alter column product_id int

alter table sales
alter column units int

select * from sales
where isnumeric(units)=0

update sales set units= case when units='1A' then 1
							when units='10%' then 10
							else units end

-- products table

select column_name,data_type
from INFORMATION_SCHEMA.columns
where table_name='products'

select * from products
where ISNUMERIC(product_id)=0

alter table products
alter column product_id int

alter table products
alter column product_cost decimal (5,2)


alter table products
alter column product_price decimal (5,2)


--- stores

select column_name,data_type
from INFORMATION_SCHEMA.columns
where table_name='stores'

select * from stores

alter table stores
alter column store_id int

alter table stores
alter column store_open_date date

select * from stores
where isdate(store_open_date)=0

select store_open_date, convert(varchar(20),try_convert(date,store_open_date,105),23) from stores

update stores set store_open_date=convert(varchar(20),try_convert(date,store_open_date,105),23)

select * from inventory

alter table inventory
alter column store_id int

alter table inventory
alter column product_id int

alter table inventory
alter column stock_on_hand int

select column_name, data_type 
from INFORMATION_SCHEMA.columns















select * from sales









