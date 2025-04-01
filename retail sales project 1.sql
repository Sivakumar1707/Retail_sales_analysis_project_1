-- create database
CREATE DATABASE retail_sales_db;

-- create table
CREATE TABLE retail_sales 
					(
						transactions_id	INT PRIMARY KEY,
                        sale_date DATE,
                        sale_time TIME,
                        customer_id	INT,
                        gender VARCHAR(15),
                        age	INT,
                        category VARCHAR(15),
                        quantity INT,
                        price_per_unit FLOAT,
                        cogs FLOAT,
                        total_sale FLOAT
					);

-- retrieve table
SELECT * FROM retail_sales;

-- Record Count, Customer Count, Category Count
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- Null Value Check
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- data cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id IS NULL 
    OR 
    sale_date IS NULL
    OR
	sale_time IS NULL 
    OR 
    customer_id IS NULL
    OR 
    gender IS NULL 
    OR 
    age IS NULL
    OR
	category IS NULL 
    OR 
    quantity IS NULL
    OR
    price_per_unit IS NULL 
    OR 
    cogs IS NULL
    OR
	total_sale IS NULL 
   ;


-- updating age null values to 0
UPDATE retail_sales SET age = 0
WHERE age IS NULL;  

-- delete the rows with null values
DELETE FROM retail_sales
WHERE
	transactions_id IS NULL 
    OR 
    sale_date IS NULL
    OR
	sale_time IS NULL 
    OR 
    customer_id IS NULL
    OR 
    gender IS NULL 
    OR 
    age IS NULL
    OR
	category IS NULL 
    OR 
    quantity IS NULL
    OR
    price_per_unit IS NULL 
    OR 
    cogs IS NULL
    OR
	total_sale IS NULL 
   ;

-- total number of sales records we have?
SELECT COUNT(*) as total_sales_records FROM retail_sales;

-- total number of unique customers
SELECT COUNT(DISTINCT customer_id) unique_customerd FROM retail_sales;

-- total number and types of categories
SELECT COUNT(DISTINCT category) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;
-- Data Analysis - Business key Q&A:
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sales
WHERE sale_date = "2022-11-05";

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retail_sales
WHERE sale_date LIKE "2022-11%" AND category = "Clothing" AND quantity >= 4;

-- 3. Write a SQL query to calculate the total sales (total_sale) and sales count for each category.:
SELECT category, SUM(total_sale) as total_sales, count(*) as sales_cnt
FROM retail_sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT * FROM retail_sales
WHERE age = 0;

SELECT COUNT(age) FROM retail_sales
WHERE age != 0;

SELECT ROUND(AVG(age), 2) as avg_age FROM retail_sales
WHERE age != 0 AND category = "Beauty"; -- eliminating age with 0 values

SELECT ROUND(AVG(age), 2) as avg_age FROM retail_sales
WHERE category = "Beauty"; -- including age with 0 values

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender, COUNT(transactions_id) AS total_transactions 
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank_num
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rank_num = 1;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT customer_id, SUM(total_sale) AS total_sales 
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, COUNT(DISTINCT customer_id) AS unique_customer 
FROM retail_sales
GROUP BY category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale AS 
(
SELECT *,
		CASE
			WHEN extract(hour FROM sale_time) < 12 THEN "Morning"
			WHEN extract(hour FROM sale_time) BETWEEN 12 AND 17 THEN "Afternoon"
			ELSE "Evening"
		END as shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;
