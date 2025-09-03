--Q1
SELECT first_name, last_name, title, levels
FROM employee
ORDER BY levels DESC
LIMIT 1;

--Q2
SELECT billingcountry, COUNT(*) AS total_invoices
FROM invoice
GROUP BY billingcountry
ORDER BY total_invoices DESC;

--Q3
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

--Q4
SELECT billingcity, SUM(total) AS city_revenue
FROM invoice
GROUP BY billingcity
ORDER BY city_revenue DESC
LIMIT 1;

--Q5
SELECT c.customerid, c.firstname, c.lastname, SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY c.customerid, c.firstname, c.lastname
ORDER BY total_spent DESC
LIMIT 1;

--Q6
SELECT DISTINCT c.email, c.firstname, c.lastname, g.name AS genre
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoice_line il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN genre g ON t.genreid = g.genreid
WHERE g.name = 'Rock'
ORDER BY c.firstname;

--Q7
SELECT a.name AS artist_name, COUNT(t.trackid) AS track_count
FROM artist a
JOIN album al ON a.artistid = al.artistid
JOIN track t ON al.albumid = t.albumid
JOIN genre g ON t.genreid = g.genreid
WHERE g.name = 'Rock'
GROUP BY a.artistid, a.name
ORDER BY track_count DESC
LIMIT 10;

--Q8
SELECT name, milliseconds
FROM track
WHERE milliseconds > (SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;

--Q9
SELECT c.firstname || ' ' || c.lastname AS customer_name,
       a.name AS artist_name,
       SUM(il.unitprice * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
JOIN invoice_line il ON i.invoiceid = il.invoiceid
JOIN track t ON il.trackid = t.trackid
JOIN album al ON t.albumid = al.albumid
JOIN artist a ON al.artistid = a.artistid
GROUP BY c.customerid, a.artistid, customer_name, artist_name
ORDER BY total_spent DESC;

--Q10
WITH genre_purchases AS (
    SELECT c.country, g.name AS genre, COUNT(il.quantity) AS purchases
    FROM customer c
    JOIN invoice i ON c.customerid = i.customerid
    JOIN invoice_line il ON i.invoiceid = il.invoiceid
    JOIN track t ON il.trackid = t.trackid
    JOIN genre g ON t.genreid = g.genreid
    GROUP BY c.country, g.name
)
SELECT country, genre, purchases
FROM genre_purchases g1
WHERE purchases = (
    SELECT MAX(purchases)
    FROM genre_purchases g2
    WHERE g1.country = g2.country
)
ORDER BY country;

--Q11
WITH customer_spending AS (
    SELECT c.country, c.customerid, c.firstname || ' ' || c.lastname AS customer_name,
           SUM(i.total) AS total_spent
    FROM customer c
    JOIN invoice i ON c.customerid = i.customerid
    GROUP BY c.country, c.customerid, customer_name
)
SELECT country, customer_name, total_spent
FROM customer_spending cs1
WHERE total_spent = (
    SELECT MAX(total_spent)
    FROM customer_spending cs2
    WHERE cs1.country = cs2.country
)
ORDER BY country;

--Q12
SELECT a.name AS artist_name, COUNT(il.quantity) AS total_purchases
FROM artist a
JOIN album al ON a.artistid = al.artistid
JOIN track t ON al.albumid = t.albumid
JOIN invoice_line il ON t.trackid = il.trackid
GROUP BY a.artistid, a.name
ORDER BY total_purchases DESC
LIMIT 10;

--Q13
SELECT t.name AS track_name, COUNT(il.quantity) AS purchases
FROM track t
JOIN invoice_line il ON t.trackid = il.trackid
GROUP BY t.trackid, t.name
ORDER BY purchases DESC
LIMIT 1;

--Q14
SELECT g.name AS genre, AVG(t.unitprice) AS avg_price
FROM track t
JOIN genre g ON t.genreid = g.genreid
GROUP BY g.genreid, g.name
ORDER BY avg_price DESC;

--Q15
SELECT billingcountry, COUNT(*) AS purchases
FROM invoice
GROUP BY billingcountry
ORDER BY purchases DESC;

--Window Function
--
--Best Customers Rank
SELECT c.customerid,
       c.firstname || ' ' || c.lastname AS customer_name,
       SUM(i.total) AS total_spent,
       RANK() OVER (ORDER BY SUM(i.total) DESC) AS rank
FROM customer c
JOIN invoice i ON c.customerid = i.customerid
GROUP BY c.customerid, c.firstname, c.lastname
ORDER BY total_spent DESC;

--Top Genres by Popularity
SELECT genre, total_purchases, genre_rank
FROM (
    SELECT g.name AS genre,
           COUNT(il.quantity) AS total_purchases,
           DENSE_RANK() OVER (ORDER BY COUNT(il.quantity) DESC) AS genre_rank
    FROM invoice_line il
    JOIN track t ON il.trackid = t.trackid
    JOIN genre g ON t.genreid = g.genreid
    GROUP BY g.genreid, g.name
) ranked
ORDER BY genre_rank;