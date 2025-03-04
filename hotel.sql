CREATE DATABASE hotel;
USE hotel;
-- The first step is to create a copy of the table being used. This is to prevent possible damage to the dataset in situations of any error from my end 
create table hotel_copy
like hotel_reservation_dataset;

insert into hotel_copy
select *
from hotel_reservation_dataset;

SELECT * FROM hotel_copy LIMIT 10;

-- After this, the next step is to solve the problem statements. 
-- 1. What is the total number of reservations in the dataset? 
select count(Booking_ID) as total_number_of_reservations
from hotel_copy;

-- 2 Which meal plan is the most popular among guests?
select type_of_meal_plan, count(type_of_meal_plan) as popular_meal_plan
from hotel_copy
group by type_of_meal_plan
limit 1;

-- 3. What is the average price per room for reservations involving children?
select no_of_children, count(Booking_ID) as num_reservations, avg(avg_price_per_room)
from hotel_copy
where no_of_children > 0 
group by no_of_children;

-- 4. How many reservations were made for the year 20XX (replace XX with the desired year)?
-- The Column (arrival_date) was stored as a text. To run a query that finds the year 2018, arrival_date has to be changed to a `date` column
SET SQL_SAFE_UPDATES = 0;

UPDATE hotel_copy 
SET arrival_date = STR_TO_DATE(arrival_date, '%d/%m/%Y');

SET SQL_SAFE_UPDATES = 1; -- Re-enable safe mode after update

UPDATE hotel_copy
SET arrival_date = STR_TO_DATE(arrival_date, '%d-%m-%Y');

-- After changing the str to date, the next step is to apply the change to the column in the table so it can reflect on the dataset
alter table hotel_copy
modify column arrival_date date;

--- Once that has been done, the next step is to solve the problem statement
select arrival_date
from hotel_copy;

select year(arrival_date), Booking_ID
from hotel_copy
where year(arrival_date) = 2018 
;

select year(arrival_date), count(Booking_ID) as reservation_numbers
from hotel_copy
where year(arrival_date) = 2018
group by year(arrival_date) 
;

-- 5. What is the most commonly booked room type?
select room_type_reserved, COUNT(Booking_ID) as num_bookings
from hotel_copy
group by room_type_reserved
order by num_bookings desc
limit 1;

-- 6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?
select count(Booking_ID) as weekend_reservations
from hotel_copy
where no_of_weekend_nights > 0
;

-- 7. What is the highest and lowest lead time for reservations?
select max(lead_time) as max_lead_time, min(lead_time) as min_lead_time
from hotel_copy;

-- 8. What is the most common market segment type for reservations?
select market_segment_type, count(market_segment_type) as market_segment
from hotel_copy
group by market_segment_type
order by market_segment desc
limit 1;

-- 9. How many reservations have a booking status of "Confirmed"?
select count(Booking_ID) as confirmed_booking_status
from hotel_copy
where booking_status = 'Not_Canceled'
;

-- 10. What is the total number of adults and children across all reservations?
select sum(no_of_adults) as total_adults, sum(no_of_children) as total_children
from hotel_copy;

-- 11. What is the average number of weekend nights for reservations involving children?
select avg(no_of_weekend_nights) as avg_children_weekend_nights
from hotel_copy
where no_of_children > 0
;

-- 12. How many reservations were made in each month of the year?
select month(arrival_date) as `month`, year(arrival_date) as `year`, count(Booking_ID) as monthly_reservations
from hotel_copy
group by month(arrival_date), year(arrival_date)
; 

-- 13. What is the average number of nights (both weekend and weekday) spent by guests for each room type?
select room_type_reserved, avg(no_of_week_nights + no_of_weekend_nights)  as avg_week_nights
from hotel_copy
group by room_type_reserved;

-- 14. For reservations involving children, what is the most common room type, and what is the average price for that room type?
select room_type_reserved, count(Booking_ID) as children_reserve, avg(avg_price_per_room) as avg_price
from hotel_copy
where no_of_children > 0
group by room_type_reserved 
order by children_reserve
limit 1;

-- 15. Find the market segment type that generates the highest average price per room. 
select market_segment_type, avg(avg_price_per_room) as avg_price
from hotel_copy
group by market_segment_type
order by avg_price desc
limit 1 ;

select * from hotel_copy;



