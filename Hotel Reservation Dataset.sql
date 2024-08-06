USE internship;

CREATE TABLE hotel (
    id INT NOT NULL AUTO_INCREMENT,
    Booking_ID VARCHAR(255) NOT NULL,
    no_of_adults INT NOT NULL,
    no_of_children INT NOT NULL,
    no_of_weekend_nights INT NOT NULL,
    no_of_week_nights INT NOT NULL,
    type_of_meal_plan VARCHAR(255) NOT NULL,
    room_type_reserved VARCHAR(255) NOT NULL,
    lead_time INT NOT NULL,
    arrival_date DATE NOT NULL,
    market_segment_type VARCHAR(255) NOT NULL,
    avg_price_per_room DOUBLE NOT NULL,
    booking_status VARCHAR(255) NOT NULL, 
    PRIMARY KEY(id)
);
SET GLOBAL local_infile='ON';
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:\\Users\\hp\\Downloads\\Hotel Reservation Dataset.csv'
INTO TABLE hotel
FIELDS TERMINATED BY ','
IGNORE 1 ROWS
(Booking_ID, no_of_adults, no_of_children, no_of_weekend_nights, no_of_week_nights, type_of_meal_plan, room_type_reserved, lead_time, @arrival_date, market_segment_type, avg_price_per_room, booking_status)
SET arrival_date = STR_TO_DATE(@arrival_date, '%d-%m-%Y');


SELECT * FROM hotel;

-- 1. What is the total number of reservations in the dataset?
SELECT COUNT(*) AS total_reservations
FROM hotel;
-- 2. Which meal plan is the most popular among guests?
SELECT type_of_meal_plan, COUNT(*) AS count
FROM hotel
GROUP BY type_of_meal_plan
ORDER BY count DESC
LIMIT 1;
-- 3. What is the average price per room for reservations involving children?
SELECT AVG(avg_price_per_room) AS average_price_per_room
FROM hotel
WHERE no_of_children > 0;
-- 4. How many reservations were made for the year 20XX (replace XX with the desired year)?
SELECT COUNT(*) AS total_reservations
FROM hotel
WHERE YEAR(arrival_date) = 2017;
-- 5. What is the most commonly booked room type?
SELECT room_type_reserved, COUNT(*) AS count
FROM hotel
GROUP BY room_type_reserved
ORDER BY count DESC
LIMIT 1;
-- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?
SELECT COUNT(*) AS total_reservations
FROM hotel
WHERE no_of_weekend_nights > 0;
-- 7. What is the highest and lowest lead time for reservations?
SELECT 
    MAX(lead_time) AS highest_lead_time,
    MIN(lead_time) AS lowest_lead_time
FROM hotel;
-- 8. What is the most common market segment type for reservations?
SELECT market_segment_type, COUNT(*) AS count
FROM hotel
GROUP BY market_segment_type
ORDER BY count DESC
LIMIT 1;
-- 9. How many reservations have a booking status of "Confirmed"?
SELECT COUNT(*) AS total_confirmed_reservations
FROM hotel
WHERE booking_status = 'Confirmed';

SELECT COUNT(*) AS total_confirmed_reservations
FROM hotel
WHERE booking_status = 'Not_Canceled';
-- 10. What is the total number of adults and children across all reservations?
SELECT 
    SUM(no_of_adults) AS total_adults,
    SUM(no_of_children) AS total_children
FROM hotel;
-- 11. What is the average number of weekend nights for reservations involving children?
SELECT AVG(no_of_weekend_nights) AS avg_weekend_nights_with_children
FROM hotel
WHERE no_of_children > 0;
-- 12. How many reservations were made in each month of the year?
SELECT 
    YEAR(arrival_date) AS year,
    MONTH(arrival_date) AS month,
    COUNT(*) AS reservations_count
FROM hotel
GROUP BY year, month
ORDER BY year, month;
-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?
SELECT 
    room_type_reserved,
    AVG(no_of_weekend_nights + no_of_week_nights) AS avg_total_nights
FROM hotel
GROUP BY room_type_reserved;
-- 14. For reservations involving children, what is the most common room type, and what is the average price for that room type?
SELECT 
    room_type_reserved,
    COUNT(*) AS count_children_reservations,
    AVG(avg_price_per_room) AS avg_price_for_room_type
FROM hotel
WHERE no_of_children > 0
GROUP BY room_type_reserved
ORDER BY count_children_reservations DESC
LIMIT 1;
-- 15. Find the market segment type that generates the highest average price per room.
SELECT 
    market_segment_type,
    AVG(avg_price_per_room) AS avg_price_per_room
FROM hotel
GROUP BY market_segment_type
ORDER BY avg_price_per_room DESC
LIMIT 1;
