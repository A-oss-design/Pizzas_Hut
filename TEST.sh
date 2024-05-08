 PIZZA_HUT SALES 

-- Retrieve the total number of orders placed.

SELECT COUNT(order_id) AS Total_Orders FROM orders;

-- Calculate the total revenue generated from pizza sales.

SELECT ROUND(SUM(quantity * price), 2) AS Total_Sales FROM order_details o JOIN pizzas p ON o.pizza_id = p.pizza_id;

-- Identify the highest-priced pizza.

SELECT t.name, price FROM pizza_types t JOIN pizzas p ON t.pizza_type_id = p.pizza_type_id ORDER BY price DESC LIMIT 1;

-- Identify the most common pizza size ordered.

SELECT size, COUNT(order_details_id) AS order_count FROM order_details o JOIN pizzas p ON o.pizza_id = p.pizza_id GROUP BY size ORDER BY order_count DESC;

-- List the top 5 most ordered pizza types along with their quantities.

SELECT name, SUM(quantity) AS quantity FROM pizzas p JOIN order_details o ON p.pizza_id = o.pizza_id JOIN pizza_types t ON t.pizza_type_id = p.pizza_type_id GROUP BY name ORDER BY quantity DESC LIMIT 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT category, SUM(quantity) AS quantity FROM pizza_types t JOIN pizzas p ON p.pizza_type_id = t.pizza_type_id JOIN order_details o ON p.pizza_id = o.pizza_id GROUP BY category order by quantity desc;

-- Determine the distribution of orders by hour of the day. 

SELECT HOUR(order_time) AS hour, COUNT(order_id) AS order_count FROM orders GROUP BY hour;

-- Join relevant tables to find the category-wise distribution of pizzas.

SELECT category, COUNT(name) FROM pizza_types GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT ROUND(AVG(quantity), 0) FROM (SELECT order_date, SUM(quantity) AS quantity FROM orders o JOIN order_details d ON o.order_id = d.order_id GROUP BY order_date) AS order_quantity;

-- Determine the top 3 most ordered pizza types based on revenue.

SELECT name, SUM(quantity * price) AS revenue FROM pizza_types t JOIN pizzas p ON t.pizza_type_id = p.pizza_type_id JOIN order_details o ON o.pizza_id = p.pizza_id GROUP BY name ORDER BY revenue DESC LIMIT 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT category, ROUND(SUM(quantity * price) / (SELECT ROUND(SUM(quantity * price), 2) AS Total_Sales FROM order_details o JOIN pizzas p ON o.pizza_id = p.pizza_id) * 100, 2) AS revenue
FROM pizza_types t JOIN pizzas p ON t.pizza_type_id = p.pizza_type_id JOIN order_details o ON o.pizza_id = p.pizza_id GROUP BY category ORDER BY revenue DESC;

-- Analyze the cumulative revenue generated over time.

SELECT order_date, sum(revenue) over(order by order_date) as cum_revenue FROM (SELECT order_date, sum(quantity*price) as revenue FROM order_details o JOIN pizzas p ON o.pizza_id = p.pizza_id 
JOIN orders r on r.order_id=o.order_id group by order_date) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

SELECT name, revenue from (select category, name, revenue, rank() over(partition by category order by revenue desc) as rn FROM (SELECT category, name, sum(quantity*price) as revenue FROM
pizza_types t JOIN pizzas p ON t.pizza_type_id = p.pizza_type_id JOIN order_details o ON o.pizza_id = p.pizza_id GROUP BY category, name) as a) as b where rn<=3;
