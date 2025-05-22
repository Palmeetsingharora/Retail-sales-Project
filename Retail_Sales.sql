--SQL Retail sales database - p1
CREATE DATABASE sql_project_p2;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
		      transactions_id	INT PRIMARY KEY,
			  sale_date	DATE,
			  sale_time	TIME,
			  customer_id INT,
			  gender VARCHAR(15),
			  age INT,
			  category	VARCHAR(15),
			  quantiy	INT,
			  price_per_unit	FLOAT,
			  cogs	FLOAT,
			  total_sale FLOAT

)

SELECT * FROM retail_sales
LIMIT 10;

select count(*)
from retail_sales;
--DATA CLEANING 
SELECT * FROM retail_sales
WHERE sale_time IS NULL
	or customer_id IS NULL
	or gender IS NULL
	or age IS NULL
	or category IS NULL
	or quantiy IS NULL
	or price_per_unit IS NULL
	or cogs IS NULL
	or total_sale IS NULL;


DELETE FROM retail_sales
WHERE sale_time IS NULL
	or customer_id IS NULL
	or gender IS NULL
	or age IS NULL
	or category IS NULL
	or quantiy IS NULL
	or price_per_unit IS NULL
	or cogs IS NULL
	or total_sale IS NULL;

SELECT COUNT(*) FROM retail_sales

ALTER TABLE retail_sales RENAME COLUMN quantiy TO quantity;

SELECT * FROM retail_sales;

--DATA EXPLORATION
--HoW Many Sales we have?
SELECT count(*) as total_sale 
FROM retail_sales;


--How many unique customer do we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

--What all categories we have in retail sales?
SELECT DISTINCT category 
from retail_sales;

--Data Analysis & Business Key Problems and Answers:

--Write a SQL query to retrieve all columns for sales made on '2022-11-05'?
select * 
from retail_sales
where sale_date='2022-11-05';

--Write a SQL query to retrieve all transactions where the category is 'clothing'
--and the quanitty sold is more than 4 in the month of Nov, 2022.


select *
from retail_sales
where category = 'Clothing' and TO_CHAR(sale_date, 'YYYY-MM')='2022-11' 
and quantity>3;


--write the sql query to calculate total_sale for each category?
SELECT sum(total_sale), category
from retail_sales
group by category;


--What is the average age of the customers who purchased items from the 'Beauty' category?
SELECT category, round(avg(age),2) as avg_age
FROM retail_sales
WHERE category='Beauty'
group by category;


--Find all the transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale>1000;


--What is the total_number of transactions made by each gender in each category?
select count(transactions_id), gender, category
from retail_sales
group by gender, category
order by category;

--What is the average sales for each month. Find out best selling month in each year?
SELECT year, month, avg_sale 
from
(
select avg(total_sale) as avg_sale,
	EXTRACT(YEAR from sale_date) as year,
	EXTRACT(MONTH from sale_date) as month,
	RANK() OVER(PARTITION BY EXTRACT(YEAR from sale_date) ORDER BY avg(total_sale) DESC) AS rank
from retail_sales
group by month, year
) as t1
where rank=2;


--who are the Top 5 customers are bases on their total highest sales?
select * from retail_sales;

select customer_id, sum(total_sale) as tot
from retail_sales
group by customer_id
order by tot DESC
LIMIT 5;


--Find the unique customers who purchased items from each category?
select count(distinct customer_id) as unique_customers, category
from retail_sales
group by category

--Create each shift and number of orders (Example Morning <=12, Afternoon between 
--12 & 17 , & Evening >17)

WITH hourly_sale
as 
(
SELECT * ,
	CASE
	    WHEN EXTRACT (HOUR FROM sale_time) <12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift 
FROM retail_sales
)
select count(transactions_id) as total_orders, shift
from hourly_Sale
GROUP BY shift 
