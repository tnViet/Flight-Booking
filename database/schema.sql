CREATE DATABASE IF NOT EXISTS flight_booking;
USE flight_booking;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  role ENUM('USER','ADMIN') NOT NULL DEFAULT 'USER',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Aircrafts Table
CREATE TABLE IF NOT EXISTS aircrafts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  model_name VARCHAR(50) NOT NULL,
  total_rows INT NOT NULL,
  columns_per_row INT NOT NULL,
  column_names VARCHAR(20) NOT NULL
);

-- 3. Flights Table
CREATE TABLE IF NOT EXISTS flights (
  id INT AUTO_INCREMENT PRIMARY KEY,
  flight_no VARCHAR(20) NOT NULL UNIQUE,
  origin VARCHAR(80) NOT NULL,
  destination VARCHAR(80) NOT NULL,
  departure_time DATETIME NOT NULL,
  arrival_time DATETIME NOT NULL,
  aircraft_id INT NULL,
  base_price DECIMAL(12,2) NOT NULL,
  total_seats INT NOT NULL DEFAULT 0,
  CONSTRAINT fk_flight_aircraft FOREIGN KEY (aircraft_id) REFERENCES aircrafts(id) ON DELETE SET NULL
);

-- 4. Bookings Table
CREATE TABLE IF NOT EXISTS bookings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NULL, -- NULL allowed for guest bookings
  flight_id INT NOT NULL,
  booking_code VARCHAR(30) NOT NULL UNIQUE,
  total_price DECIMAL(12,2) NOT NULL DEFAULT 0,
  payment_method VARCHAR(50),
  status VARCHAR(30) NOT NULL,
  booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_book_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
  CONSTRAINT fk_book_flight FOREIGN KEY (flight_id) REFERENCES flights(id) ON DELETE CASCADE
);

-- 5. Booking Passengers Table
CREATE TABLE IF NOT EXISTS booking_passengers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  full_name VARCHAR(120) NOT NULL,
  id_card VARCHAR(20) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  email VARCHAR(150) NOT NULL,
  gender VARCHAR(10) NOT NULL,
  birth_date DATE,
  CONSTRAINT fk_bp_booking FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- 6. Booking Seats Table
CREATE TABLE IF NOT EXISTS booking_seats (
  id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id INT NOT NULL,
  passenger_id INT NOT NULL,
  flight_id INT NOT NULL,
  seat_no VARCHAR(10) NOT NULL,
  seat_class VARCHAR(30) NOT NULL,
  seat_price DECIMAL(12,2) NOT NULL,
  luggage_weight INT NOT NULL DEFAULT 0,
  luggage_price DECIMAL(12,2) NOT NULL DEFAULT 0,
  CONSTRAINT fk_bs_booking FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
  CONSTRAINT fk_bs_passenger FOREIGN KEY (passenger_id) REFERENCES booking_passengers(id) ON DELETE CASCADE,
  CONSTRAINT fk_bs_flight FOREIGN KEY (flight_id) REFERENCES flights(id) ON DELETE CASCADE,
  UNIQUE KEY uq_flight_seat (flight_id, seat_no)
);


