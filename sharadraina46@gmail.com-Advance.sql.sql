--SQL Advance Case Study
select * from DIM_CUSTOMER
select * from DIM_DATE
select * from DIM_LOCATION
select * from DIM_MANUFACTURER
select * from DIM_MODEL
select * from FACT_TRANSACTIONS

--Q1--BEGIN 
	1. List all the states in which we have customers who have bought cellphones
from 2005 till today. 

select distinct state from (

select  DIM_LOCATION.State  , FACT_TRANSACTIONS.Date
from DIM_LOCATION join FACT_TRANSACTIONS on DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation
group by  DIM_LOCATION.State , FACT_TRANSACTIONS.Date
having year(Date) >=2005 ) x


--Q1--END

--Q2--BEGIN
2. What state in the US is buying the most 'Samsung' cell phones? 

select top 1 State from (

select State , count(State) x  from DIM_LOCATION join FACT_TRANSACTIONS on DIM_LOCATION.IDLocation = FACT_TRANSACTIONS.IDLocation
join DIM_MODEL on DIM_MODEL.IDModel = FACT_TRANSACTIONS.IDModel
join DIM_MANUFACTURER on DIM_MANUFACTURER.IDManufacturer = DIM_MODEL.IDManufacturer
WHERE Manufacturer_Name = 'Samsung' and Country = 'US'
group by State) y 
order by x desc

--Q2--END

--Q3--BEGIN      
3. Show the number of transactions for each model per zip code per state. 	

select distinct DIM_MODEL.Model_Name, DIM_LOCATION.ZipCode,DIM_LOCATION.State , count(FACT_TRANSACTIONS.IDModel)  transaction_count    
from DIM_LOCATION join FACT_TRANSACTIONS on FACT_TRANSACTIONS.IDLocation = DIM_LOCATION.IDLocation
join DIM_MODEL on DIM_MODEL.IDModel = FACT_TRANSACTIONS.IDModel
group by  DIM_MODEL.Model_Name, DIM_LOCATION.ZipCode,DIM_LOCATION.State
order by transaction_count desc

--Q3--END

--Q4--BEGIN
4. Show the cheapest cellphone (Output should contain the price also)

select top 1 * from DIM_MODEL 
order by Unit_price asc

--Q4--END

--Q5--BEGIN

5. Find out the average price for each model in the top5 manufacturers in
terms of sales quantity and order by average price. 


select  top 5 DIM_MANUFACTURER.Manufacturer_Name , AVG(FACT_TRANSACTIONS.TotalPrice) as avg_price , SUM( FACT_TRANSACTIONS.Quantity) as sales_qty
from DIM_MANUFACTURER left join DIM_MODEL on DIM_MANUFACTURER.IDManufacturer = DIM_MODEL.IDManufacturer
join FACT_TRANSACTIONS on FACT_TRANSACTIONS.IDModel = DIM_MODEL.IDModel
group by DIM_MANUFACTURER.Manufacturer_Name
order by avg_price desc

--Q5--END

--Q6--BEGIN
6. List the names of the customers and the average amount spent in 2009,
where the average is higher than 500 


select d.Customer_Name, avg(f.totalprice*f.quantity) as avg_amount
from DIM_CUSTOMER d
join FACT_TRANSACTIONS f on d.IDCustomer = f.IDCustomer
where year(date) = 2009
group by d.Customer_Name
having avg(f.totalprice*f.quantity) > 500
order by avg_amount desc

--Q6--END
	
--Q7--BEGIN  
 List if there is any model that was in the top 5 in terms of quantity,
simultaneously in 2008, 2009 and 2010 	

select  top 5 Model_Name , sum(quantity) as qty 
from FACT_TRANSACTIONS f 
join DIM_MODEL d 
on f.IDModel = d.IDModel
where year(date) between 2008 and 2010
group by Model_Name
order by qty desc	

--Q7--END	
--Q8--BEGIN

8. Show the manufacturer with the 2nd top sales in the year of 2009 and the
manufacturer with the 2nd top sales in the year of 2010. 


select top 1 * from 
(select top 2 Manufacturer_Name ,  sum (totalprice*quantity) as sales 
from DIM_MANUFACTURER d 
join DIM_MODEL dm on d.IDManufacturer = dm.IDManufacturer
join FACT_TRANSACTIONS f on f.IDModel = dm.IDModel
where year(date) = 2009 
group by Manufacturer_Name
order by sales desc) x
order by sales asc

union all

select top 1 * from
(select top 2 Manufacturer_Name ,  sum (totalprice*quantity) as sales 
from DIM_MANUFACTURER d 
join DIM_MODEL dm on d.IDManufacturer = dm.IDManufacturer
join FACT_TRANSACTIONS f on f.IDModel = dm.IDModel
where year(date) = 2010 
group by Manufacturer_Name
order by sales desc) x 
order by sales asc 

--Q8--END
--Q9--BEGIN
	
9. Show the manufacturers that sold cellphones in 2010 but did not in 2009. 


select Manufacturer_Name
from DIM_MANUFACTURER dm 
join DIM_MODEL d on dm.IDManufacturer = d.IDManufacturer
join FACT_TRANSACTIONS f on f.IDModel = d.IDModel
where year(date) = 2010
except
select Manufacturer_Name
from DIM_MANUFACTURER dm 
join DIM_MODEL d on dm.IDManufacturer = d.IDManufacturer
join FACT_TRANSACTIONS f on f.IDModel = d.IDModel
where year(date) = 2009


--Q9--END

--Q10--BEGIN
 Find top 100 customers and their average spend, average quantity by each
year. Also find the percentage of change in their spend. 


SELECT TOP 100 CUSTOMER_NAME, 
AVG(CASE WHEN YEAR(DTE) = 2005 THEN TOTALPRICE END) AS AVERAGE_PRICE_2005,
AVG(CASE WHEN YEAR(DTE) = 2005 THEN QUANTITY END) AS AVERAGE_QTY_2005,
AVG(CASE WHEN YEAR(DTE) = 2018 THEN TOTALPRICE END) AS AVERAGE_PRICE_2018,
AVG(CASE WHEN YEAR(DTE) = 2018 THEN QUANTITY END) AS AVERAGE_QTY_2018
FROM DIM_CUSTOMER
INNER JOIN FACT_TRANSACTION T1 ON T1.IDCUSTOMER= DIM_CUSTOMER.IDCUSTOMER
GROUP BY CUSTOMER_NAME
	


















--Q10--END
	