-- Lab | SQL Subqueries 3.03

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, COUNT(inventory_id) as '# of copies'
FROM film f
INNER JOIN inventory i 
ON f.film_id = i.film_id
WHERE title = "Hunchback Impossible";

-- 2. List all films whose length is longer than the average of all the films.

SELECT title from film
where length > (select AVG(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT concat(first_name, ' ', last_name) as 'actor name'
FROM actor
WHERE actor_id in
	(SELECT actor_id FROM film_actor
	WHERE film_id in 
		(SELECT film_id FROM film
		WHERE title = 'Alone Trip'));


-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. 
-- Identify all movies categorized as family films. 'Family'

SELECT title from film
WHERE film_id in 
	(Select film_id 
    from film_category 
    where category_id in
		(SELECT category_id 
        from category
        where name = 'Family'));


-- 5. Get name and email from customers from Canada using subqueries. 
-- Do the same with joins. Note that to create a join, you will have to identify the correct tables 
-- with their primary keys and foreign keys, that will help you get the relevant information.


-- using subqueries

SELECT first_name, last_name, email from customer
WHERE address_id in (SELECT address_id from address 
	WHERE city_id in (SELECT city_id from city 
		where country_id in (SELECT country_id from country
			where country = 'Canada')));

-- using joins

SELECT country, first_name, last_name, email
FROM customer c
INNER JOIN address a
ON c.address_id = a.address_id
INNER JOIN city ci
ON ci.city_id = a.city_id
INNER JOIN country co
on co.country_id = ci.country_id
WHERE country = 'Canada';

-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor
-- that has acted in the most number of films. First you will have to find the most prolific actor and 
-- then use that actor_id to find the different films that he/she starred.

-- find most prolific actor: GINA DEGENERES actor_id = 107

SELECT a1.actor_id, first_name, last_name, count(DISTINCT(film_id)) as films
FROM actor a1
INNER JOIN film_actor a2 
ON a1.actor_id = a2.actor_id 
GROUP BY actor_id, first_name, last_name
ORDER BY films desc
LIMIT 1;

-- find films starred by them: actor_id = 107

SELECT title from film
WHERE film_id in (SELECT film_id from film_actor 
	WHERE actor_id = 107);


-- 7. Films rented by most profitable customer. You can use the customer table and payment table 
-- to find the most profitable customer ie the customer that has made the largest sum of payments

-- finding most profitable customer:

SELECT c.customer_id, first_name, last_name, SUM(amount) from customer c
JOIN payment p
on c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY SUM(amount) DESC
LIMIT 1;

-- it is KARL SEAL with customer_id = 526

SELECT title from film
where film_id in 
	(SELECT film_id FROM inventory 
    where film_id in 
    (SELECT inventory_id from rental
		where customer_id = 526));
        
	

-- 8. Customers who spent more than the average payments.

SELECT first_name, last_name from customer
	where customer_id in (select customer_id from payment
		where amount > (select AVG(amount) from payment));