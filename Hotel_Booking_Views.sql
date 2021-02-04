CREATE VIEW HOTEL_RATING 
AS
(SELECT HOTEL.HOTEL_ID, HOTEL.HOTEL_NAME, HOTEL.HOTEL_ADDRESS, CITY.CITY_NAME, STATE.STATE_NAME, 
	ROUND(AVG(RATING_STAR),1) AS HOTEL_RATING,
    COUNT(RATING_STAR) AS RATING_COUNT
FROM HOTEL
JOIN CITY ON HOTEL.CITY_ID = CITY.CITY_ID
JOIN STATE ON CITY.STATE_ID = STATE.STATE_ID
LEFT JOIN RATING ON HOTEL.HOTEL_ID = RATING.HOTEL_ID
GROUP BY HOTEL.HOTEL_ID, HOTEL.HOTEL_NAME, HOTEL.HOTEL_ADDRESS, CITY.CITY_NAME, STATE.STATE_NAME
ORDER BY HOTEL_RATING DESC);

CREATE VIEW ROOM_PRICE
AS
(SELECT HOTEL.HOTEL_ID, HOTEL.HOTEL_NAME, ROOM.ROOM_ID, ROOM.ROOM_TYPE_NAME, ROOM_TYPE.ROOM_BASE_PRICE, HOTEL_RATING.HOTEL_RATING,
CASE
	WHEN HOTEL_RATING < 1.1 THEN ROUND(.2*ROOM_BASE_PRICE,2)
    WHEN HOTEL_RATING < 2.1 AND HOTEL_RATING >= 1.1 THEN ROUND(.4*ROOM_BASE_PRICE,2)
    WHEN HOTEL_RATING < 3.1 AND HOTEL_RATING >= 2.1 THEN ROUND(.6*ROOM_BASE_PRICE,2)
    WHEN HOTEL_RATING < 4.1 AND HOTEL_RATING >= 3.1 THEN ROUND(.8*ROOM_BASE_PRICE,2)
    WHEN HOTEL_RATING < 5.1 AND HOTEL_RATING >= 4.1 THEN ROOM_BASE_PRICE
    WHEN HOTEL_RATING IS NULL THEN ROUND(.6*ROOM_BASE_PRICE,2)
END AS ROOM_PRICE
FROM HOTEL
JOIN ROOM ON HOTEL.HOTEL_ID = ROOM.HOTEL_ID
JOIN ROOM_TYPE ON ROOM.ROOM_TYPE_NAME = ROOM_TYPE.ROOM_TYPE_NAME
JOIN HOTEL_RATING ON HOTEL.HOTEL_ID = HOTEL_RATING.HOTEL_ID
ORDER BY HOTEL_RATING.HOTEL_RATING, HOTEL.HOTEL_NAME, ROOM.ROOM_TYPE_NAME);

CREATE VIEW PAYMENT_VIEW
AS 
(SELECT PAYMENT.PAYMENT_ID, PAYMENT_TYPE.PAYMENT_TRANSACTION_TYPE, PAYMENT_STATUS.PAYMENT_STATUS_NAME, 
PAYMENT.PAYMENT_DATE, substring(PAYMENT.PAYMENT_CARD, -4) AS "PAYMENT CARD NUMBER"
FROM PAYMENT
JOIN PAYMENT_TYPE ON PAYMENT.PAYMENT_TYPE_ID = PAYMENT_TYPE.PAYMENT_TYPE_ID
JOIN PAYMENT_STATUS ON PAYMENT.PAYMENT_STATUS_ID = PAYMENT_STATUS.PAYMENT_STATUS_ID
);
