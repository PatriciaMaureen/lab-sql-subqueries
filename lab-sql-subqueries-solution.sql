USE sakila;

-- 1. 
SELECT COUNT(inventory_id) AS num_of_copies FROM sakila.inventory
WHERE film_id = (SELECT film_id FROM sakila.film
WHERE title = 'Hunchback Impossible');

-- 2.
SELECT title, length FROM sakila.film
WHERE length > (SELECT AVG(length) FROM sakila.film)
ORDER BY length DESC;

-- 3. 
SELECT actor_id, CONCAT (first_name, ' ', last_name) AS actor_name FROM sakila.actor
WHERE actor_id IN (SELECT actor_id FROM sakila.film_actor 
WHERE film_id = (SELECT film_id FROM sakila.film
WHERE title = 'Alone Trip'));

-- 4.
SELECT title FROM sakila.film 
WHERE film_id IN (SELECT film_id FROM sakila.film_category
WHERE category_id IN (SELECT category_id FROM sakila.category
WHERE name = 'Family'));

-- 5. Using Subqueries
SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN (SELECT address_id FROM sakila.address WHERE city_id IN 
(SELECT city_id FROM sakila.city WHERE country_id IN 
(SELECT country_id FROM sakila.country WHERE country = 'Canada')));

-- 5. Using Join
SELECT c.first_name, c.last_name, c.email
FROM sakila.customer c
JOIN sakila.address a
ON c.address_id = a.address_id
JOIN sakila.city ci
ON a.city_id = ci.city_id
JOIN sakila.country co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- 6. 
SELECT title FROM sakila.film
WHERE film_id IN (SELECT film_id FROM sakila.film_actor
WHERE actor_id = (SELECT actor_id FROM (SELECT actor_id, COUNT(film_id) AS num_of_films FROM sakila.film_actor
GROUP BY actor_id
ORDER BY num_of_films DESC
LIMIT 1) AS most_prolific_actor));

-- 7. I assume the most profitable customer is the one that has made the largest sum of payments
SELECT title FROM sakila.film
WHERE film_id IN (SELECT inventory_id FROM sakila.rental 
WHERE customer_id = (SELECT customer_id FROM sakila.payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1)); 

-- 8. 
SELECT customer_id, total_amount_spent FROM 
(SELECT customer_id, SUM(amount) AS total_amount_spent FROM sakila.payment
GROUP BY customer_id) AS customer_payments
WHERE total_amount_spent > (SELECT AVG(total_amount_spent) FROM 
(SELECT SUM(amount) AS total_amount_spent FROM sakila.payment
GROUP BY customer_id) AS avg_payments)
ORDER BY total_amount_spent DESC;