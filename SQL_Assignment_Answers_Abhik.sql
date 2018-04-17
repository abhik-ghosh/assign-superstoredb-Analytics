SET GLOBAL sql_mode = 'ONLY_FULL_GROUP_BY';
select @@GLOBAL.sql_mode;

/*
 Task 1: Understanding the data in hand: (195 words)
 We are provided with a superstore sales data here. The entire dataset consists of 5 tables
 
 > cust_dimen - has primary key as "Cust_ID". No foreign key is present.
 > orders_dimen - has primary key as "Order_ID". "Ord_id" is not foreign key to this table 
   because "Ord_id" is not a primary key to market_fact or any other table. But this field
   is useful for joining with market_fact table
 > prod_dimen - has primary key as "Prod_ID". No foreign key is present.
 > shippinf_dimen - has primary key as "Ship_ID". Foreign key is "Order_ID" - this is the
   primary key for orders_dimen table.
 > market_fact - There are 4 foreign keys("Order_ID", "Prod_ID", "Ship_ID" & "Cust_ID") on 
   this table but no primary key. It is not necessary to have a primary key to have foreign
   keys on the table. A new column "market_fact_id" can be added to this table as primary
   key to get 1NF.
   
   We can get data from two tables without having primary and foreign key relation. The 
   main reason for primary and foreign keys is to enforce data consistency. Here, we lack the 
   consistency because of the absense of primary ley in mark_fact table.
*/

use superstoresdb;

# Task 2: A. Find the total and the average sales (display total_sales and avg_sales)
select sum(sales) as total_sales, avg(sales) as avg_sales
from market_fact;

# Task 2: B. Display the number of customers in each region in decreasing order of no_of_customers. 
# The result should contain columns Region, no_of_customers
select region, count(cust_id) as no_of_customers
from cust_dimen
group by region
order by no_of_customers desc;

# Task 2: C. Find the region having maximum customers 
# (display the region name and max(no_of_customers)

select Region, count(cust_id) as no_of_customers
from cust_dimen
group by region
order by no_of_customers desc
limit 1;


# Task 2: D. Find the number and id of products sold in decreasing order 
# of products sold (display product id, no_of_products sold)
select prod_id, count(Order_Quantity) as no_of_products_sold
from market_fact
group by prod_id
order by no_of_products_sold desc;

# Task 2: E. Find all the customers from Atlantic region who have 
# ever purchased ‘TABLES’ and the number of tables purchased 
# (display the customer name, no_of_tables purchased)
select cust_dimen.Customer_Name, sum(market_fact.Order_Quantity) as no_of_tables_purchased
from market_fact
inner join prod_dimen on (prod_dimen.prod_id = market_fact.prod_id)
inner join cust_dimen on (cust_dimen.Cust_id = market_fact.Cust_id)
where prod_dimen.product_sub_category = 'TABLES' and cust_dimen.region = 'ATLANTIC' 
group by cust_dimen.Customer_Name
order by no_of_tables_purchased desc;



# Task 3: A. Display the product categories in descending order 
# of profits (display the product category wise profits i.e. product_category, profits)?

select prod_dimen.product_category, sum(market_fact.profit) as profits
from market_fact 
inner join prod_dimen on (prod_dimen.prod_id = market_fact.prod_id)
#left outer join prod_dimen on (prod_dimen.prod_id = market_fact.prod_id)
group by prod_dimen.product_category
order by profits desc;


# Task 3: B: Display the product category, product sub-category and the profit within each 
# sub-category in three columns.

select prod.Product_Category, prod.product_sub_category, sum(market.profit) as profits
from market_fact market
inner join prod_dimen prod on (prod.Prod_id = market.Prod_id)
group by prod.Product_Category, prod.Product_Sub_Category
order by prod.Product_Category, profits asc;

# Task 3: C. Where is the least profitable product subcategory shipped the most? For the least 
# profitable product sub-category, display the region-wise no_of_shipments and the profit made 
# in each region in decreasing order of profits (i.e. region, no_of_shipments, profit_in_each_region)

select prod.product_sub_category, sum(market.profit) as profits
from market_fact market
inner join prod_dimen prod on (prod.Prod_id = market.Prod_id)
group by prod.Product_Sub_Category
order by profits asc;

select cust_dimen.Region, count(market_fact.Ship_id) as no_of_shipments, sum(market_fact.Profit) as profit_in_each_region
from market_fact
inner join prod_dimen on (prod_dimen.Prod_id = market_fact.Prod_id)
inner join cust_dimen on (cust_dimen.Cust_id = market_fact.Cust_id)
where prod_dimen.product_sub_category in ('TABLES', 'BOOKCASES', 'SCISSORS, RULERS AND TRIMMERS', 'RUBBER BANDS', 'PENS & ART SUPPLIES') #Finding for 5 least profit category
group by cust_dimen.Region
order by profit_in_each_region desc;









