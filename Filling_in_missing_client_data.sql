/*Question: When you log in to your retailer client's database, you notice that their product catalog data is full of gaps in the category column. Can you write a SQL query that returns the product catalog with the missing data filled in?

Answer:
In this case we will assume that all the products listed belong to the same category that are in sequence therefore, the first product in the group will have its category defined. We will start off my labelling the products that fall under the same category so we can tell them apart.

In order to accomplish the above, we can use COUNT as a window function to assign a number for each type of category. The COUNT function will compute the number of rows with non-null values in the category column. We are performing that statement to understand the category groups so that we know which value should fill in the NULLs */

SELECT
	product_id,
	category,
	name,
COUNT(category) OVER (ORDER BY product_id) AS category_group
FROM products;

/* On the basis of newly generated column named category_group, we will now fill in the missing category for each product. In order to do that we will use another window function: FIRST VALUE.*/

WITH fill_products AS (
SELECT
 	 product_id,
  	 category,
  	 name,
COUNT(category) OVER (ORDER BY product_id) AS category_group
FROM products)

SELECT
  	product_id,
  	FIRST_VALUE (category) OVER (
  	PARTITION BY category_group
ORDER BY product_id) AS category, name
FROM fill_products;