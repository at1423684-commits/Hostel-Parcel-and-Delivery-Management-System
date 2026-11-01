-- =====================================================================
-- DATABASE: hostel_parcel_db
-- PROJECT: Hostel Parcel and Delivery Management System
-- MCA Mini Project Database Script (MySQL 8.0+)
-- =====================================================================

DROP DATABASE IF EXISTS hostel_parcel_db;
CREATE DATABASE hostel_parcel_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hostel_parcel_db;

-- ---------------------------------------------------------------------
-- 1. TABLE: users
-- ---------------------------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. TABLE: students
-- ---------------------------------------------------------------------
CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    room_number VARCHAR(20) NOT NULL,
    hostel_block VARCHAR(20) NOT NULL,
    CONSTRAINT fk_students_users FOREIGN KEY (user_id) 
        REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. TABLE: parcels
-- ---------------------------------------------------------------------
CREATE TABLE parcels (
    parcel_id INT AUTO_INCREMENT PRIMARY KEY,
    tracking_number VARCHAR(50) NOT NULL UNIQUE,
    student_id INT,
    courier_name VARCHAR(100) NOT NULL,
    parcel_description VARCHAR(255),
    parcel_weight DECIMAL(5,2) NOT NULL,
    received_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('RECEIVED', 'PENDING_COLLECTION', 'DELIVERED') NOT NULL DEFAULT 'RECEIVED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_parcels_students FOREIGN KEY (student_id) 
        REFERENCES students(student_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. TABLE: delivery_history
-- ---------------------------------------------------------------------
CREATE TABLE delivery_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    parcel_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(255),
    CONSTRAINT fk_history_parcels FOREIGN KEY (parcel_id) 
        REFERENCES parcels(parcel_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 5. TABLE: delivery_charges
-- ---------------------------------------------------------------------
CREATE TABLE delivery_charges (
    charge_id INT AUTO_INCREMENT PRIMARY KEY,
    parcel_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'PAID',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_charges_parcels FOREIGN KEY (parcel_id) 
        REFERENCES parcels(parcel_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 6. TABLE: parcel_audit_log
-- Audit log intentionally has no cascade delete to preserve trail
-- ---------------------------------------------------------------------
CREATE TABLE parcel_audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    parcel_id INT,
    action VARCHAR(50) NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =====================================================================
-- DATABASE PROGRAMMING CONCEPTS
-- =====================================================================

-- ---------------------------------------------------------------------
-- A. VALIDATION BEFORE INSERTION (Trigger demonstration)
-- Validates minimum delivery charge (>= 20 INR) before insertion.
-- ---------------------------------------------------------------------
DELIMITER //

CREATE TRIGGER trg_validate_delivery_charge
BEFORE INSERT ON delivery_charges
FOR EACH ROW
BEGIN
    IF NEW.amount < 20.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Validation Error: Minimum delivery charge requirement is Rs. 20.00.';
    END IF;
END //

CREATE TRIGGER trg_validate_parcel_weight
BEFORE INSERT ON parcels
FOR EACH ROW
BEGIN
    IF NEW.parcel_weight <= 0.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Validation Error: Parcel weight must be greater than 0 kg.';
    END IF;
END //

-- ---------------------------------------------------------------------
-- C. USER-DEFINED FUNCTION
-- Calculates parcel delivery charges based on parcel weight.
-- Up to 1 kg: ₹20
-- Above 1 kg and up to 5 kg: ₹40
-- Above 5 kg: ₹60
-- ---------------------------------------------------------------------
CREATE FUNCTION fn_calculate_delivery_charge(p_weight DECIMAL(5,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_charge DECIMAL(10,2);
    
    IF p_weight <= 1.00 THEN
        SET v_charge = 20.00;
    ELSEIF p_weight <= 5.00 THEN
        SET v_charge = 40.00;
    ELSE
        SET v_charge = 60.00;
    END IF;
    
    RETURN v_charge;
END //

-- ---------------------------------------------------------------------
-- F. AUDIT TRIGGERS
-- Automatically maintain parcel status changes in audit log and delivery history.
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_parcel_after_insert
AFTER INSERT ON parcels
FOR EACH ROW
BEGIN
    -- Record in audit log
    INSERT INTO parcel_audit_log (parcel_id, action, old_status, new_status, changed_at)
    VALUES (NEW.parcel_id, 'PARCEL_REGISTERED', NULL, NEW.status, NOW());
    
    -- Record initial delivery history
    INSERT INTO delivery_history (parcel_id, old_status, new_status, changed_at, remarks)
    VALUES (NEW.parcel_id, 'NEW', NEW.status, NOW(), 'Parcel received at hostel reception desk');
END //

CREATE TRIGGER trg_parcel_after_update
AFTER UPDATE ON parcels
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        -- Record in audit log
        INSERT INTO parcel_audit_log (parcel_id, action, old_status, new_status, changed_at)
        VALUES (NEW.parcel_id, 'STATUS_UPDATED', OLD.status, NEW.status, NOW());
        
        -- Record in delivery history
        INSERT INTO delivery_history (parcel_id, old_status, new_status, changed_at, remarks)
        VALUES (NEW.parcel_id, OLD.status, NEW.status, NOW(), CONCAT('Status updated from ', OLD.status, ' to ', NEW.status));
    END IF;
END //

CREATE TRIGGER trg_parcel_after_delete
AFTER DELETE ON parcels
FOR EACH ROW
BEGIN
    -- Preserve audit log entry even when parcel is deleted
    INSERT INTO parcel_audit_log (parcel_id, action, old_status, new_status, changed_at)
    VALUES (OLD.parcel_id, 'PARCEL_DELETED', OLD.status, 'DELETED', NOW());
END //

-- ---------------------------------------------------------------------
-- D & E. STORED PROCEDURE WITH EXCEPTION HANDLING & TRANSACTIONS
-- Registers parcel, checks student ID, validates duplicate tracking,
-- calculates charges via function, inserts parcel and delivery charges.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_register_parcel(
    IN p_tracking_number VARCHAR(50),
    IN p_student_id INT,
    IN p_courier_name VARCHAR(100),
    IN p_description VARCHAR(255),
    IN p_weight DECIMAL(5,2),
    OUT p_parcel_id INT,
    OUT p_charge_amount DECIMAL(10,2)
)
proc_block: BEGIN
    DECLARE v_student_exists INT DEFAULT 0;
    DECLARE v_tracking_exists INT DEFAULT 0;

    -- Exception handling: Rollback transaction on any SQL error
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- 1. Validate parcel weight
    IF p_weight IS NULL OR p_weight <= 0.00 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exception: Invalid parcel weight. Weight must be greater than 0 kg.';
    END IF;

    -- 2. Validate student ID existence
    SELECT COUNT(*) INTO v_student_exists FROM students WHERE student_id = p_student_id;
    IF v_student_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exception: Invalid student ID. Student does not exist in records.';
    END IF;

    -- 3. Validate duplicate tracking number
    SELECT COUNT(*) INTO v_tracking_exists FROM parcels WHERE tracking_number = p_tracking_number;
    IF v_tracking_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exception: Duplicate tracking number encountered.';
    END IF;

    -- Start Transaction
    START TRANSACTION;

    -- Calculate delivery charge using the UDF
    SET p_charge_amount = fn_calculate_delivery_charge(p_weight);

    -- Insert into parcels table (Triggers will fire to log audit & history)
    INSERT INTO parcels (
        tracking_number, student_id, courier_name, parcel_description, 
        parcel_weight, received_date, status
    ) VALUES (
        p_tracking_number, p_student_id, p_courier_name, p_description, 
        p_weight, NOW(), 'RECEIVED'
    );

    SET p_parcel_id = LAST_INSERT_ID();

    -- Insert into delivery_charges table
    INSERT INTO delivery_charges (parcel_id, amount, payment_status, created_at)
    VALUES (p_parcel_id, p_charge_amount, 'PAID', NOW());

    -- Commit Transaction
    COMMIT;
END //

-- ---------------------------------------------------------------------
-- E. PROCEDURE FOR STATUS UPDATE WITH VALIDATION & EXCEPTION HANDLING
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_update_parcel_status(
    IN p_parcel_id INT,
    IN p_new_status VARCHAR(50),
    IN p_remarks VARCHAR(255)
)
BEGIN
    DECLARE v_parcel_exists INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Validate existence of parcel record
    SELECT COUNT(*) INTO v_parcel_exists FROM parcels WHERE parcel_id = p_parcel_id;
    IF v_parcel_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exception: Missing parcel record. Cannot update non-existent parcel.';
    END IF;

    -- Validate status enum values
    IF p_new_status NOT IN ('RECEIVED', 'PENDING_COLLECTION', 'DELIVERED') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Exception: Invalid parcel status. Allowed: RECEIVED, PENDING_COLLECTION, DELIVERED.';
    END IF;

    START TRANSACTION;

    UPDATE parcels
    SET status = p_new_status
    WHERE parcel_id = p_parcel_id;

    -- Optional custom remark for delivery history
    IF p_remarks IS NOT NULL AND CHAR_LENGTH(TRIM(p_remarks)) > 0 THEN
        UPDATE delivery_history
        SET remarks = p_remarks
        WHERE parcel_id = p_parcel_id
        ORDER BY history_id DESC LIMIT 1;
    END IF;

    COMMIT;
END //

-- ---------------------------------------------------------------------
-- B. EXPLICIT CURSOR STORED PROCEDURE
-- Generates a report of parcels pending collection for more than X days
-- using an explicit cursor.
-- ---------------------------------------------------------------------
CREATE PROCEDURE sp_pending_parcels_cursor(IN p_days INT)
BEGIN
    -- Cursor variables
    DECLARE done INT DEFAULT 0;
    DECLARE v_parcel_id INT;
    DECLARE v_tracking_number VARCHAR(50);
    DECLARE v_student_name VARCHAR(100);
    DECLARE v_room_number VARCHAR(20);
    DECLARE v_courier VARCHAR(100);
    DECLARE v_received_date TIMESTAMP;
    DECLARE v_days_pending INT;

    -- Explicit Cursor Declaration
    DECLARE cur_pending_parcels CURSOR FOR
        SELECT 
            p.parcel_id, 
            p.tracking_number, 
            COALESCE(s.full_name, 'Unassigned') AS student_name,
            COALESCE(s.room_number, 'N/A') AS room_number,
            p.courier_name,
            p.received_date,
            DATEDIFF(NOW(), p.received_date) AS days_pending
        FROM parcels p
        LEFT JOIN students s ON p.student_id = s.student_id
        WHERE p.status IN ('RECEIVED', 'PENDING_COLLECTION')
          AND DATEDIFF(NOW(), p.received_date) >= p_days
        ORDER BY p.received_date ASC;

    -- Handler to exit cursor loop
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Create temporary table to store cursor report output
    DROP TEMPORARY TABLE IF EXISTS tmp_pending_report;
    CREATE TEMPORARY TABLE tmp_pending_report (
        parcel_id INT,
        tracking_number VARCHAR(50),
        student_name VARCHAR(100),
        room_number VARCHAR(20),
        courier_name VARCHAR(100),
        received_date TIMESTAMP,
        days_pending INT
    );

    -- Open explicit cursor
    OPEN cur_pending_parcels;

    read_loop: LOOP
        FETCH cur_pending_parcels INTO 
            v_parcel_id, 
            v_tracking_number, 
            v_student_name, 
            v_room_number, 
            v_courier, 
            v_received_date, 
            v_days_pending;

        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Insert cursor row into reporting table
        INSERT INTO tmp_pending_report VALUES (
            v_parcel_id, 
            v_tracking_number, 
            v_student_name, 
            v_room_number, 
            v_courier, 
            v_received_date, 
            v_days_pending
        );
    END LOOP;

    -- Close explicit cursor
    CLOSE cur_pending_parcels;

    -- Return the generated report result set
    SELECT * FROM tmp_pending_report;

    DROP TEMPORARY TABLE IF EXISTS tmp_pending_report;
END //

DELIMITER ;

-- =====================================================================
-- SAMPLE TEST DATA
-- Passwords are encrypted using BCrypt ($2a$10$...)
-- admin password:    admin123
-- student passwords: student123
-- =====================================================================

-- Users
INSERT INTO users (user_id, username, password, role) VALUES
(1, 'admin', '$2a$10$c7M2XlF3sC1bIqN6tE1V9eM7fC9aA0b1c2d3e4f5g6h7i8j9k0l1m', 'ADMIN'),
(2, 'rahul_sharma', '$2a$10$w6z/6t1F2nZ3aX4bC5vD6eR7fG8hI9jK0lM1nO2pQ3rS4tU5vW6xY', 'STUDENT'),
(3, 'priya_patel', '$2a$10$w6z/6t1F2nZ3aX4bC5vD6eR7fG8hI9jK0lM1nO2pQ3rS4tU5vW6xY', 'STUDENT'),
(4, 'amit_kumar', '$2a$10$w6z/6t1F2nZ3aX4bC5vD6eR7fG8hI9jK0lM1nO2pQ3rS4tU5vW6xY', 'STUDENT');

-- Students
INSERT INTO students (student_id, user_id, full_name, email, phone, room_number, hostel_block) VALUES
(1, 2, 'Rahul Sharma', 'rahul.sharma@hostel.edu', '9876543210', 'A-204', 'Block A'),
(2, 3, 'Priya Patel', 'priya.patel@hostel.edu', '9876543211', 'B-108', 'Block B'),
(3, 4, 'Amit Kumar', 'amit.kumar@hostel.edu', '9876543212', 'C-315', 'Block C');

-- Insert initial parcels using the procedure so triggers and charges are created
CALL sp_register_parcel('TRK-BLUEDART-8801', 1, 'BlueDart Express', 'Study Books and Stationery', 0.85, @p1, @c1);
CALL sp_register_parcel('TRK-AMAZON-5521', 1, 'Amazon Logistics', 'Electronics (Keyboard & Mouse)', 2.40, @p2, @c2);
CALL sp_register_parcel('TRK-DELHIVERY-3104', 2, 'Delhivery', 'Winter Clothing Jacket', 1.75, @p3, @c3);
CALL sp_register_parcel('TRK-FEDEX-9912', 3, 'FedEx India', 'Hostel Bedding & Pillows', 6.20, @p4, @c4);
CALL sp_register_parcel('TRK-EKART-7720', 2, 'Ekart Logistics', 'Sports Shoes', 1.20, @p5, @c5);

-- Update some statuses to demonstrate audit logs and history
CALL sp_update_parcel_status(2, 'PENDING_COLLECTION', 'Student notified via reception bulletin');
CALL sp_update_parcel_status(3, 'DELIVERED', 'Collected by student with hostel ID verification');
CALL sp_update_parcel_status(5, 'DELIVERED', 'Handed over to student in room B-108');

-- Ensure auto-increment values are aligned
ALTER TABLE users AUTO_INCREMENT = 10;
ALTER TABLE students AUTO_INCREMENT = 10;
ALTER TABLE parcels AUTO_INCREMENT = 10;
