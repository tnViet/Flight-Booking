
SET GLOBAL event_scheduler = ON;

USE flight_booking;

DELIMITER //

CREATE EVENT IF NOT EXISTS event_cancel_pending_tickets
ON SCHEDULE EVERY 30 SECOND
DO
BEGIN
    UPDATE bookings 
    SET status = 'CANCELLED' 
    WHERE status = 'PENDING_PAYMENT' 
    AND booking_time <= NOW() - INTERVAL 2 MINUTE;
END //

DELIMITER ;
