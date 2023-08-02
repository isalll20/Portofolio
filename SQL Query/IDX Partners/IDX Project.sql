--Exercise :

--1. Identify the top 10 customers and their email so we can reward them
SELECT 
	CONCAT(customer.first_name, ' ', customer.last_name) as FullName, 
	customer.email, 
	SUM(payment.amount) as TotalPurchase
FROM customer
JOIN payment
USING(customer_id)
GROUP BY FullName, customer.email
ORDER BY TotalPurchase DESC
LIMIT 10;



--2. Identify the bottom 10 customers and their emails
SELECT 
	CONCAT(customer.first_name, ' ', customer.last_name) as FullName, 
	customer.email, 
	SUM(payment.amount) as TotalPurchase
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY FullName, customer.email
ORDER BY TotalPurchase ASC
LIMIT 10;

--3. What are the most profitable movie genres (ratings)? 
SELECT  	
	category.name AS GenreFIlm,
	--film.rating,
	SUM(payment.amount) AS total_revenue
FROM film
	JOIN film_category ON film.film_id = film_category.film_id
		JOIN category ON film_category.category_id = category.category_id
			JOIN inventory ON film.film_id = inventory.film_id
				JOIN rental ON inventory.inventory_id = rental.inventory_id
					JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name /*,film.rating*/
ORDER BY total_revenue DESC;

--4. How many rented movies were returned late, early, and on time?
WITH q1 AS (SELECT*, DATE_PART('day', return_date - rental_date)
		   		AS date_difference
		   FROM rental),
	 q2 AS (SELECT rental_duration, date_difference,
		   		CASE
		   			WHEN rental_duration > date_difference THEN 'EARLY'
					WHEN rental_duration < date_difference THEN 'LATE'
					ELSE 'ON TIME'
				END AS Return_status
			FROM film f
			JOIN inventory i ON f.film_id = i.film_id
			JOIN q1 ON i.inventory_id = q1.inventory_id)
SELECT return_status, count(*) AS total_film
FROM q2
GROUP BY return_status
ORDER BY total_film DESC;


--5. What is the customer base in the countries where we have a presence?
SELECT country, 
		count(DISTINCT customer_id) AS customer_base
FROM country
	JOIN city
	USING(country_id)
		JOIN address
		USING(city_id)
			JOIN customer
			USING(address_id)
GROUP BY country
ORDER BY customer_base DESC;

--6. Which country is the most profitable for the business?
SELECT country, 
		SUM(amount) AS total_sales
FROM country
	JOIN city
	USING(country_id)
		JOIN address
		USING(city_id)
			JOIN customer
			USING(address_id)
				JOIN payment
				USING(customer_id)
GROUP BY country
ORDER BY total_sales DESC;

--7. What is the average rental rate per movie genre (rating)?
SELECT c.name AS genre, ROUND(AVG(f.rental_rate),2) AS AverageRentalRate
FROM category c
JOIN film_category fc
USING(category_id)
JOIN film f
USING(film_id)
GROUP BY 1
ORDER BY 2 DESC;
