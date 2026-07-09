-- SQL Retail Sales Analysis --


-- CREATE TABLE --
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
	transactions_id INT PRIMARY KEY, 
	sale_date DATE, 
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);


-- DATA CLEANING -- 
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
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;

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
	category IS NULL
	OR 
	quantity IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL;


-- DATA EXPLORATION -- 

-- How many total sales?
SELECT COUNT(*) as total_sales FROM retail_sales;

-- How many unique customers?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- How many unique categories?
SELECT DISTINCT category FROM retail_sales;


-- DATA ANALYSIS & BUSINESS KEY PROBLEMS AND ANSWERS --

-- 1. Retrieve cols for sales made 2022-11-05.
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- 2. Retrieve all trans where the category is 'Clothing' and the qty sold is >= 4 in the month of November 2022.
SELECT * FROM retail_sales
WHERE category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantity >= 4;

-- 3. Calculate the total sales for each category.
SELECT category, SUM(total_sale) as total_sales FROM retail_sales
GROUP BY category;

-- 4. Find average age of cust who purchased from the 'Beauty' category.
SELECT ROUND(AVG(age), 2) AS average_age FROM retail_sales
WHERE category = 'Beauty';

-- 5. Find all transactions where total sales are > 1000.
SELECT * from retail_sales
WHERE total_sale > 1000;

-- 6. Find the total number of transactions made by each gender in each category.
SELECT category, gender, COUNT(transactions_id) AS total_transactions FROM retail_sales
GROUP BY gender, category
ORDER BY category;

-- 7. Calculate the average sale for each month. Find the best selling month in each year.
SELECT year, month, avg_sales 
FROM 
	(
	SELECT 
		EXTRACT(YEAR FROM sale_date) AS year, 
		EXTRACT(MONTH FROM sale_date) AS month, 
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY year, month
)
WHERE rank = 1;

-- 8. Find the top 5 customers based on the highest total sales.
SELECT customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Find the number of unique customers who purchased items from each category.
SELECT 
	category, 
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- 10. Create each shift and the # of orders (Morning < 12, Afternoon >= 12 & <= 17, Evening > 17).
WITH hourly_sale AS 
	(
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END as shift
	FROM retail_sales
	)
SELECT shift, COUNT(*) AS total_orders FROM hourly_sale
GROUP BY shift;


-- END --