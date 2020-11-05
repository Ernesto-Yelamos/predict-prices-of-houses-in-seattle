
-- 1. Create a database called `house_price_regression`.
DROP DATABASE IF EXISTS `house_price_regression`;
CREATE DATABASE `house_price_regression`;
USE `house_price_regression`;

# set sql_safe_updates=0;
# SET sql_mode=(SELECT REPLACE(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));

SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1;

-- 2. Create a table `house_price_data` with the same columns as given in the csv file. Please make sure you use the correct data types for the columns.
drop table house_price_data;
create table house_price_data
(
	house_id VARCHAR(150) UNIQUE NOT NULL,
    date VARCHAR(150), 
    bedrooms INT(100),
    bathrooms FLOAT(2),
    sqft_living INT(100),
    sqft_lot INT(100),
    floors FLOAT(2),
    waterfront INT(100),
    views INT(100),
    house_condition INT(100),
	grade INT(100),
    sqft_above INT(100),
    sqft_basement INT(100),
    yr_built VARCHAR(100),
    yr_renovated VARCHAR(100),
    zipcode VARCHAR(100),
    latitude FLOAT(5),
    longitude FLOAT(5),
    sqft_living15 INT(100),
    sqft_lot15 INT(100),
    price INT(100)
    );

-- 4.  Select all the data from table `house_price_data` to check if the data was imported correctly
select * from house_price_data;

 -- 5.  Use the alter table command to drop the column `date` from the database, as we would not use it in the analysis with SQL. Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE house_price_data
DROP COLUMN date;

select * from house_price_data;

-- 6.  Use sql query to find how many rows of data you have.
select count(*) from house_price_data;

-- 7.  Now we will try to find the unique values in some of the categorical columns:
    -- What are the unique values in the column `bedrooms`?
SELECT count( DISTINCT bedrooms) AS "Number of bedrooms" FROM house_price_data;
    -- What are the unique values in the column `bathrooms`?
SELECT count( DISTINCT bathrooms) AS "Number of bathrooms" FROM house_price_data;
    -- What are the unique values in the column `floors`?
SELECT count( DISTINCT floors) AS "Number of floors" FROM house_price_data;
    -- What are the unique values in the column `condition`?
SELECT count( DISTINCT house_condition) AS "Number of conditions" FROM house_price_data;
    -- What are the unique values in the column `grade`?
SELECT count( DISTINCT grade) AS "Number of grades" FROM house_price_data;

-- 8.  Arrange the data in a decreasing order by the price of the house. Return only the IDs of the top 10 most expensive houses in your data.
select house_id from house_price_data
order by price DESC
limit 10;

-- 9.  What is the average price of all the properties in your data?
select round(avg(price), 2) as 'Average price' from house_price_data;

-- 10. In this exercise we will use simple group by to check the properties of some of the categorical variables in our data
    -- What is the average price of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the prices. Use an alias to change the name of the second column.
select round(avg(price), 2) as 'Average price', bedrooms from house_price_data
group by bedrooms;
   -- What is the average `sqft_living` of the houses grouped by bedrooms? The returned result should have only two columns, bedrooms and Average of the `sqft_living`. Use an alias to change the name of the second column.
select round(avg(sqft_living), 2) as 'Average sqft_living', bedrooms from house_price_data
group by bedrooms;
   -- What is the average price of the houses with a waterfront and without a waterfront? The returned result should have only two columns, waterfront and `Average` of the prices. Use an alias to change the name of the second column.
select round(avg(price), 2) as 'Average price', waterfront from house_price_data
group by waterfront;
   -- Is there any correlation between the columns `condition` and `grade`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select grade, house_condition from house_price_data
order by grade;

-- 11. One of the customers is only interested in the following houses:
	-- Number of bedrooms either 3 or 4
    -- Bathrooms more than 3
    -- One Floor
    -- No waterfront
    -- Condition should be 3 at least
    -- Grade should be 5 at least
    -- Price less than 300000

    -- For the rest of the things, they are not too concerned. Write a simple query to find what are the options available for them?
select * from house_price_data
where bedrooms in (3, 4) and bathrooms>3 and floors=1 and waterfront=0 and house_condition>=3 and grade>=5 and price<300000;

-- 12. Your manager wants to find out the list of properties whose prices are twice more than the average of all the properties in the database. Write a query to show them the list of such properties. You might need to use a sub query for this problem.
select house_id, price, round(avg(price)*2, 2) as Double_average_price from house_price_data
group by house_id;

select house_id, price from (
select house_id, price, round(avg(price)*2, 2) as Double_average_price from house_price_data
group by house_id
) as sub1
where price>=Double_average_price;

-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
create view double_average_price as
select house_id, price from (
select house_id, price, round(avg(price)*2, 2) as Double_average_price from house_price_data
group by house_id
) as sub1
where price>=Double_average_price;

select * from double_average_price;

-- 14. Most customers are interested in properties with three or four bedrooms. What is the difference in average prices of the properties with three and four bedrooms?
select bedrooms, round(avg(price), 2) as Average_price from house_price_data
where bedrooms in (3, 4)
group by bedrooms;

-- 15. What are the different locations where properties are available in your database? (distinct zip codes)
select distinct(zipcode) from house_price_data;

select count(distinct(zipcode)) from house_price_data;

-- 16. Show the list of all the properties that were renovated.
select * from house_price_data
where sqft_living <> sqft_living15;

-- 17. Provide the details of the property that is the 11th most expensive property in your database.
select * from house_price_data
order by price desc
limit 1 offset 10;

select *,
case
	when sqft_living<>sqft_living15 then "yes"
    else "no"
end as "house_renovated",
case
	when sqft_lot<>sqft_lot15 then "yes"
    else "no"
end as "lot_renovated"
from house_price_data;

select count(distinct(house_id)) from house_price_data;
select count(house_id) from house_price_data;






-- avg price by location
select round(avg(price), 2) as average_price, zipcode from house_price_data
group by zipcode;

select round(avg(price), 2) as 'Average price' from house_price_data;

-- location_price_above_avg_price
SELECT a.house_id
FROM house_price_data as a
GROUP BY a.zipcode
Having round(avg(a.price), 2)>(select round(avg(price), 2) as total_average_price from house_price_data);

 
-- avg grade
select avg(grade) as average_grade from house_price_data;

SELECT a.house_id
FROM house_price_data as a
GROUP BY a.house_id
Having avg(a.grade)>(select avg(grade) as total_average_grade from house_price_data);



-- avg sqft by year built
select price, yr_built ;

select yr_renovated from house_price_data
where yr_renovated <> 0;
