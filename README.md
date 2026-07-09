# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis   
**Database**: `p1_retail_db`

This project was created to practice fundamental SQL skills using PostgreSQL. The focus was on designing a relational database, importing retail sales data, performing data cleaning, and writing analytical SQL queries to answer common business questions.

While simple in scope, this project helped me become comfortable with the end-to-end workflow of working with a relational database.

## Tech Stack

- PostgreSQL
- SQL

## Dataset


Source:
Retail Sales Dataset from Kaggle

The dataset contains retail transactions including:

- transactions_id	
- sale_date
- sale_time
- customer_id
- gender
- age
- category
- quantiy
- price_per_unit
- cogs
- total_sale




## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Retrieve all columns for sales made 2022-11-05**:
```sql
SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';
```

2. **Retrieve all trans where the category is 'Clothing' and the qty sold is >= 4 in the month of November 2022**:
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' AND quantity >= 4;
```

3. **Calculate the total sales for each category**:
```sql
SELECT category, SUM(total_sale) as total_sales FROM retail_sales
GROUP BY category;
```

4. **Find average age of cust who purchased from the 'Beauty' category**:
```sql
SELECT ROUND(AVG(age), 2) AS average_age FROM retail_sales
WHERE category = 'Beauty';
```

5. **Find all transactions where total sales are > 1000**:
```sql
SELECT * from retail_sales
WHERE total_sale > 1000;
```

6. **Find the total number of transactions made by each gender in each category**:
```sql
SELECT category, gender, COUNT(transactions_id) AS total_transactions FROM retail_sales
GROUP BY gender, category
ORDER BY category;
```

7. **Calculate the average sale for each month. Find the best selling month in each year**:
```sql
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
```

8. **Find the top 5 customers based on the highest total sales**:
```sql
SELECT customer_id, SUM(total_sale) AS total_sales FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

9. **Find the number of unique customers who purchased items from each category**:
```sql
SELECT 
	category, 
	COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

10. **Create each shift and the # of orders (Morning < 12, Afternoon >= 12 & <= 17, Evening > 17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
