CREATE TABLE hotels (
  hotel_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  address VARCHAR(200),
  city VARCHAR(50),
  country VARCHAR(50),
  rating FLOAT
);

CREATE TABLE rooms (
  room_id INT PRIMARY KEY AUTO_INCREMENT,
  hotel_id INT,
  room_number VARCHAR(10),
  room_type VARCHAR(50),
  price DECIMAL(10, 2),
  capacity INT,
  availability ENUM('Available', 'Booked') DEFAULT 'Available',
  FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

CREATE TABLE guests (
  guest_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone_number VARCHAR(20),
  nationality VARCHAR(50)
);

CREATE TABLE reservations (
  reservation_id INT PRIMARY KEY AUTO_INCREMENT,
  room_id INT,
  guest_id INT,
  check_in_date DATE,
  check_out_date DATE,
  FOREIGN KEY (room_id) REFERENCES rooms(room_id),
  FOREIGN KEY (guest_id) REFERENCES guests(guest_id)
);

CREATE TABLE invoices (
  invoice_id INT PRIMARY KEY AUTO_INCREMENT,
  reservation_id INT,
  total_amount DECIMAL(10, 2),
  issue_date DATE,
  FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
);


CREATE TABLE payments (
  payment_id INT PRIMARY KEY AUTO_INCREMENT,
  invoice_id INT,
  amount DECIMAL(10, 2),
  payment_date DATE,
  FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id)
);
#table filling
INSERT INTO `hotel_management_system`.`hotels` (`hotel_id`, `name`, `address`, `city`, `country`, `rating`)
 VALUES ('1', 'The Yankies', 'b-261 najafgarh', 'New Delhi', 'india', '4.9'),
('2', 'mac donals', 'shastri nagar', 'mumbai', 'india', '4.5'),
('3', 'bikaner', 'nangli', 'New Delhi', 'india', '4.8'),
('4', 'aggarwal', 'dwarka', 'New delhi', 'India', '4.9');

INSERT INTO `hotel_management_system`.`rooms` (`room_id`, `hotel_id`, `room_number`, `room_type`, `price`, `capacity`, `availability`) 
VALUES ('01', '1', '101', 'single', '2000', '2','Available'),
('02', '1', '102', 'single', '2000', '2','Available'),
('03', '1', '103', 'double', '3000', '3','Available'),
('04', '1', '104', 'double', '3000', '3','Available'),
('05', '1', '105', 'double', '3000', '3','Available'),
('06', '1', '106', 'single', '2000', '2','Available'),
('07', '1', '107', 'triple', '5000', '5', 'Booked'),
('08', '1', '108', 'triple', '5000', '5', 'Booked'),
('09', '1', '109', 'triple', '5000', '5', 'Booked'),
 ('10', '1', '110', 'single', '2000', '2','Available');
 
 
 INSERT INTO `hotel_management_system`.`reservations` (`reservation_id`, `room_id`, `guest_id`, `check_in_date`, `check_out_date`) 
 VALUES ('601', '7', '1', '01-07-23', '04-07-23'),
('602', '7', '2', '01-07-23', '04-07-23'),
('603', '7', '3', '01-07-23', '04-07-23');



INSERT INTO `hotel_management_system`.`invoices` (`invoice_id`, `reservation_id`, `total_amount`, `issue_date`)
 VALUES ('1', '601', '5400', '05-07-23'),
 ('2', '602', '5600', '05-07-23'),
('3', '603', '8500', '05-07-23');

INSERT INTO `hotel_management_system`.`payments` (`payment_id`, `invoice_id`, `amount`, `payment_date`) 
VALUES ('1', '1', '5400', '05-07-23'),
	('2', '2', '5600', '05-07-23'),
	('3', '3', '8500', '05-07-23');



INSERT INTO `hotel_management_system`.`guests` (`guest_id`, `first_name`, `last_name`, `email`, `phone_number`, `nationality`) 
VALUES ('1', 'mayank', 'arya', 'mayank@gmail.com', '8787987895', 'indian');
INSERT INTO `hotel_management_system`.`guests` (`guest_id`, `first_name`, `last_name`, `email`, `phone_number`, `nationality`) 
VALUES ('2', 'shivam', 'sood', 'shivam@gmail.com', '8787988587', 'indian');
INSERT INTO `hotel_management_system`.`guests` (`guest_id`, `first_name`, `last_name`, `email`, `phone_number`, `nationality`) 
VALUES ('3', 'vineeet', 'kundu', 'VINEET@GMAIL.COM', '8758454215', 'indian');
INSERT INTO `hotel_management_system`.`guests` (`guest_id`, `first_name`, `last_name`, `email`, `phone_number`, `nationality`) 
VALUES ('4', 'prashant', 'singh', 'prashant@gmail.com', '8978987456', 'indian');
INSERT INTO `hotel_management_system`.`guests` (`guest_id`, `first_name`, `last_name`, `email`, `phone_number`, `nationality`)
VALUES ('5', 'rajan', 'kumar', 'rajan@gmail.com', '8587989654', 'ukraine');


-- Create a view to join the tables and retrieve the required information
CREATE VIEW HotelReservationDetails AS
SELECT
  h.name AS hotel_name,
  r.room_number,
  r.room_type,
  g.first_name,
  g.last_name,
  res.check_in_date,
  res.check_out_date,
  i.total_amount,
  p.amount AS payment_amount
FROM
  reservations res
JOIN
  rooms r ON res.room_id = r.room_id
JOIN
  guests g ON res.guest_id = g.guest_id
JOIN
  hotels h ON r.hotel_id = h.hotel_id
LEFT JOIN
  invoices i ON res.reservation_id = i.reservation_id
LEFT JOIN
  payments p ON i.invoice_id = p.invoice_id;

select * from hotelreservationdetails;

delimiter 
CREATE TRIGGER update_room_availability
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
  UPDATE rooms
  SET availability = 'Booked'
  WHERE room_id = NEW.room_id;
END;


CREATE TRIGGER update_invoice_total
AFTER UPDATE ON reservations
FOR EACH ROW
BEGIN
  DECLARE reservation_total DECIMAL(10, 2);
  SET reservation_total = (SELECT price FROM rooms WHERE room_id = NEW.room_id);
  UPDATE invoices
  SET total_amount = reservation_total
  WHERE reservation_id = NEW.reservation_id;
END;

CREATE TRIGGER update_room_availability
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
  UPDATE rooms
  SET availability = 'Booked'
  WHERE room_id = NEW.room_id;
END;



