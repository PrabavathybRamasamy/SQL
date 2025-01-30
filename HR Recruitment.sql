-- create a database - Hr_recruitmentdb

create database hr_recruitementdb

--- switch the db into hr_recruitementdb

use hr_recruitementdb

-- create a table - hr_rct

create table hr_rct
(Position Varchar(max),	full_name Varchar(max),	Gender Varchar(max),	Salary Varchar(max),	Department Varchar(max),
	DepartmentName Varchar(max),Division Varchar(max),AssignmentCategory Varchar(max),Title	Varchar(max),HiringAnalyst Varchar(max),
	VacancyStatus Varchar(max),	VacancyDate	Varchar(max),BudgetDate Varchar(max),PostingDate Varchar(max),	InterviewDate Varchar(max),
	OfferDate	Varchar(max),AcceptanceDate Varchar(max),SecurityCheckDate Varchar(max), HireDate Varchar(max))

	select * from hr_rct

-- bulk insert to upload the data into the container(table)

bulk insert hr_rct


from 'C:\Users\Crossignite.com\Downloads\Datasets_for_Analytics\hr_recruitement.csv'
with 
	(Fieldterminator=',',
					Rowterminator='\n',
										Firstrow=2,
													Maxerrors=20);

select * from hr_rct

select case when isdate(vacancydate)=0 then 'Date is not valid' 
			when isdate(Budgetdate)=0 then 'Date is not valid' 
			when isdate(postingdate)=0 then 'Date is not valid' 	
			when isdate(interviewdate)=0 then 'Date is not valid'
			when isdate(offerdate)=0 then 'Date is not valid'
			when isdate(acceptancedate)=0 then 'Date is not valid'
			when isdate(securitycheckdate)=0 then 'Date is not valid'
			when isdate(hiredate)=0 then 'Date is not valid'
			else 'Date is valid' End as Date_inspection
			from hr_rct

-- we alter the date columns from varchar to date format

alter table hr_rct
alter column vacancydate date


alter table hr_rct
alter column budgetdate date


alter table hr_rct
alter column postingdate date


alter table hr_rct
alter column interviewdate date


alter table hr_rct
alter column offerdate date


alter table hr_rct
alter column acceptancedate date


alter table hr_rct
alter column securitycheckdate date


alter table hr_rct
alter column hiredate date

select column_name, data_type
from Information_schema.columns

alter table hr_rct
alter column salary money

select * from hr_rct
where isnumeric(salary)=0

-- do the cleaning (but considering that we have n values, 

select salary, replace(salary,substring(salary,patindex('%[!@#$%Z^&*()_+]%',Salary),1),'') from hr_rct,
substring(salary,patindex('%[^0-9]%',salary),1),patindex('%[^0-9]%',salary) from Hr_Rct
where isnumeric(salary)=0


update hr_rct set salary =replace(salary,substring(salary,patindex('%[!--@#$%Z^&*()_+]%',Salary),1),'')
where isnumeric(salary)=0

select * from hr_rct


--- check the data patterns 
-- How the Vacancies distributed by the genders

select gender as 'Gend_distribution',department, count(position) as 'Vacancies_distributed'
from hr_rct
group by gender, department
order by gender

select gender as 'Gend_distribution',department, count(position) as 'Vacancies_distributed'
from hr_rct
group by gender, department
order by gender

-- pivot-- ??

select Department,
		isnull([M],0) as 'Male_vacancy',
		isnull([f],0) as 'Female_vacancy'
from
	(select department, gender, count(position) as 'Vacancies'
		from hr_rct
		where vacancystatus='Filled'
		group by gender,department
		)
As base_table
Pivot
	(sum(vacancies)
	for gender in ([M],[F])
	) As Pivot_table

order by male_vacancy desc



-- Manjunath

 select department, (case when Gender='F' then Gender else '' end) as Female_dist,
(case when Gender='M' then Gender else '' end) as Male_dist, count(Position) as 'vacancies'
from HR_rct
group by Department, Gender


---
select * from hr_rct

select department,count(position) as 'Total_available_pos', sum(case when vacancystatus='filled' then 1 else 0 end) as 'Filled_position',
sum(case when vacancystatus='Vacant' then 1 else 0 end) as 'Vacant_position'
 from hr_rct
group by department
order by Filled_position desc

-- let's check the hiring duration in our data
-- vacancydate (from first vacancy till the last vacancy released as per the data
-- we want to find out the vacancy duration in Years and months

select concat(datediff(Month, min(vacancydate),max(vacancydate))/12,'Years',' ', datediff(month, min(vacancydate),max(vacancydate))%12,' ', 'Month/s' ) as total_hiring_duration
from hr_rct
/* we have the total of 62 years and 1 month hiring data*/

--- min(vacancydate), max(vacancydate)

select min(vacancydate) as 'firstvacancydate', max(vacancydate) as 'lastvacancydaterecrd' from hr_rct

/* firstvacancydate- 1954-10-11, lastdaterecorded- 2016-11-26*/

-- The Hr_department to analyse the last 5 years recruitment summary

select hiredate, dateadd(year,-5,hiredate) from hr_rct  /* 2010-01-30*/

select departmentname, gender,Position,coalesce(avg( case when hiredate>=dateadd(year,-1,max_date) then salary end),0) as 'avg_salrecentlyhired',
									/* Who hired recently*/
							coalesce(avg(case when hiredate<dateadd(year,-5,  max_date ) then salary end),0) as 'hired5yrsback'
from  (select departmentname,hiredate, Position,gender, salary, vacancystatus,(select max(hiredate) from hr_rct) as Max_date
from hr_rct) as Hr_rcd
group by DepartmentName,gender,position

-- Okay, Let's keep this output for your analysis, write a note to check the result for the interpretation along with
-- what are the other things we can  add in this analysi for more clarity or better comparative result.
