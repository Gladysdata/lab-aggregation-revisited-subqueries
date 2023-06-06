USE sakila ;

#Select the first name, last name, and email address of all the customers who have rented a movie
SELECT DISTINCT(customer.first_name), customer.last_name, customer.email FROM customer
LEFT JOIN rental ON
customer.customer_id = rental.customer_id ;

#What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made)
SELECT customer_id, concat(first_name,' ', last_name) AS name, ROUND(AVG(amount),2) AS payment FROM customer
JOIN payment USING (customer_id)
GROUP BY customer_id, concat(first_name,' ', last_name)
ORDER BY payment DESC ;

#Select the name and email address of all the customers who have rented the "Action" movies
#Write the query using multiple join statements
#Write the query using sub queries with multiple WHERE clause and IN condition
#Verify if the above two queries produce the same results or not

#1
SELECT DISTINCT c.first_name, c.last_name, c.email
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Action' ;

#2
SELECT CONCAT(c.first_name, ' ',c.last_name) AS customer_name, email
FROM customer c
WHERE customer_id IN (
    SELECT r.customer_id
    FROM rental r
    WHERE r.inventory_id IN (
        SELECT i.inventory_id
        FROM inventory i
        WHERE i.film_id IN (
            SELECT f.film_id
            FROM film f
            WHERE f.film_id IN (
                SELECT film_id
                FROM film_category
                WHERE category_id IN (
                    SELECT category_id
                    FROM category
                    WHERE name = 'Action'
                    GROUP BY c.email
                )
            )
        )
    )
) ;

#SAME RESULT IS OBTAINED, 510 ROWS

#Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high
SELECT *,
CASE WHEN amount >=0 AND amount <=2 THEN 'low'
WHEN amount >2 AND amount <=4 THEN 'medium'
WHEN amount >4 THEN 'high'
END AS trans_amount
FROM payment ;