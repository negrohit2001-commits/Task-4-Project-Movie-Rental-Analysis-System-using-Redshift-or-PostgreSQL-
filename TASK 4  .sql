

CREATE TABLE rental_data (
    MOVIE_ID      INTEGER       NOT NULL,
    CUSTOMER_ID   INTEGER       NOT NULL,
    GENRE         VARCHAR(50)   NOT NULL,
    RENTAL_DATE   DATE          NOT NULL,
    RETURN_DATE   DATE          NOT NULL,
    RENTAL_FEE    NUMERIC(8,2)  NOT NULL CHECK (RENTAL_FEE > 0),

    
    CONSTRAINT rental_pk PRIMARY KEY (MOVIE_ID, CUSTOMER_ID, RENTAL_DATE));
    
    
    
    \d rental_data;
    
    
INSERT INTO rental_data (MOVIE_ID, CUSTOMER_ID, GENRE, RENTAL_DATE, RETURN_DATE, RENTAL_FEE) VALUES
(101, 1001, 'Action',  '2025-01-10', '2025-01-12', 4.50),
(102, 1002, 'Drama',   '2025-01-05', '2025-01-08', 3.20),
(103, 1003, 'Comedy',  '2024-12-20', '2024-12-22', 2.80),
(101, 1004, 'Action',  '2024-11-10', '2024-11-12', 4.00),
(104, 1005, 'Horror',  '2024-10-01', '2024-10-03', 3.00),
(105, 1006, 'Action',  '2024-09-15', '2024-09-17', 3.50),
(106, 1007, 'Drama',   '2024-11-20', '2024-11-22', 3.90),
(107, 1008, 'Comedy',  '2024-08-30', '2024-09-01', 2.20),
(103, 1009, 'Comedy',  '2025-01-02', '2025-01-03', 2.90),
(108, 1010, 'Documentary','2025-01-12','2025-01-12', 1.50),
(109, 1011, 'Action',  '2024-12-01', '2024-12-03', 4.20),
(110, 1012, 'Drama',   '2024-10-15', '2024-10-17', 3.10);

select * from rental_data;

/*1(a) drill down to genre */
SELECT 
    GENRE,
    COUNT(*) AS total_rentals,
    SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY GENRE
ORDER BY GENRE;

/* 1(b)drill down to movie level within genre */
SELECT 
    GENRE,
    MOVIE_ID,
    COUNT(*) AS rentals,
    SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY GENRE, MOVIE_ID
ORDER BY GENRE, MOVIE_ID;


/* 2 ROLLUP */

SELECT
    CASE WHEN GROUPING(GENRE) = 1 THEN 'ALL_GENRES'
         ELSE GENRE END AS genre_name,
    SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY ROLLUP (GENRE)
ORDER BY genre_name;


/* 3 ROLLUP */
SELECT
    COALESCE(GENRE, 'ALL_GENRES') AS genre_name,
    COALESCE(RENTAL_DATE::text, 'ALL_DATES') AS rental_date,
    COALESCE(CUSTOMER_ID::text, 'ALL_CUSTOMERS') AS customer,
    SUM(RENTAL_FEE) AS total_fee
FROM rental_data
GROUP BY CUBE (GENRE, RENTAL_DATE, CUSTOMER_ID)
ORDER BY genre_name, rental_date, customer;


/* 4 Slice  */
SELECT *
FROM rental_data
WHERE GENRE = 'Action'
ORDER BY RENTAL_DATE DESC;

/* 5 dice  */
SELECT *
FROM rental_data
WHERE GENRE IN ('Action', 'Drama')
  AND RENTAL_DATE >= CURRENT_DATE - INTERVAL '3 months'
ORDER BY RENTAL_DATE DESC;
