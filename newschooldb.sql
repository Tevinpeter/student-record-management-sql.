
CREATE DATABASE IF NOT EXISTS school_record;
USE school_record;


-- 1. Address & Identity Cluster
CREATE TABLE country (
    country_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE state_province (
    state_id INT PRIMARY KEY AUTO_INCREMENT,
    country_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE city (
    city_id INT PRIMARY KEY AUTO_INCREMENT,
    state_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (state_id) REFERENCES state_province(state_id)
);

CREATE TABLE address (
    address_id INT PRIMARY KEY AUTO_INCREMENT,
    street_name VARCHAR(255) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    city_id INT NOT NULL,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE people (
    person_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    gender CHAR(1),
    birth_date DATE,
    phone VARCHAR(20),
    email VARCHAR(100),
    address_id INT,
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- 2. Academic Structure Cluster
CREATE TABLE academic_year (
    academic_year_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE term (
    term_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (academic_year_id) REFERENCES academic_year(academic_year_id)
);

CREATE TABLE staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    position VARCHAR(100),
    department VARCHAR(100),
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

CREATE TABLE class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    class_teacher_id INT,
    FOREIGN KEY (academic_year_id) REFERENCES academic_year(academic_year_id),
    FOREIGN KEY (class_teacher_id) REFERENCES staff(staff_id)
);

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    admission_number VARCHAR(50) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

CREATE TABLE student_enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    academic_year_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    FOREIGN KEY (academic_year_id) REFERENCES academic_year(academic_year_id)
);

-- 3. Subject & Teaching Cluster
CREATE TABLE subject_category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE subject (
    subject_id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES subject_category(category_id)
);

CREATE TABLE class_subject (
    class_subject_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL,
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (teacher_id) REFERENCES staff(staff_id)
);

-- 4. Guardian & Family Cluster
CREATE TABLE guardian (
    guardian_id INT PRIMARY KEY AUTO_INCREMENT,
    person_id INT NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    FOREIGN KEY (person_id) REFERENCES people(person_id)
);

CREATE TABLE student_guardian (
    student_guardian_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    guardian_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (guardian_id) REFERENCES guardian(guardian_id)
);

-- 5. Attendance Cluster
CREATE TABLE attendance_status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    date DATE NOT NULL,
    status_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    FOREIGN KEY (status_id) REFERENCES attendance_status(status_id)
);

-- 6. Examination & Grading Cluster
CREATE TABLE exam_type (
    exam_type_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE exam (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year_id INT NOT NULL,
    term_id INT NOT NULL,
    exam_type_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    FOREIGN KEY (academic_year_id) REFERENCES academic_year(academic_year_id),
    FOREIGN KEY (term_id) REFERENCES term(term_id),
    FOREIGN KEY (exam_type_id) REFERENCES exam_type(exam_type_id)
);

CREATE TABLE grading_system (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year_id INT NOT NULL,
    grade_label VARCHAR(10) NOT NULL,
    min_score DECIMAL(5,2) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (academic_year_id) REFERENCES academic_year(academic_year_id)
);

CREATE TABLE exam_result (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    exam_id INT NOT NULL,
    class_id INT NOT NULL,
    subject_id INT NOT NULL,
    grade_id INT NOT NULL,
    teacher_id INT NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (exam_id) REFERENCES exam(exam_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    FOREIGN KEY (subject_id) REFERENCES subject(subject_id),
    FOREIGN KEY (grade_id) REFERENCES grading_system(grade_id),
    FOREIGN KEY (teacher_id) REFERENCES staff(staff_id)
);

-- 7. Finance Cluster
CREATE TABLE payment_method (
    method_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE fee_structure (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    academic_year_id INT NOT NULL,
    term_id INT NOT NULL,
    class_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (academic_year_id) REFERENCES academic_year(academic_year_id),
    FOREIGN KEY (term_id) REFERENCES term(term_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);

CREATE TABLE fee_payment (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    fee_id INT NOT NULL,
    method_id INT NOT NULL,
    received_by INT NOT NULL,
    payment_date DATE NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (fee_id) REFERENCES fee_structure(fee_id),
    FOREIGN KEY (method_id) REFERENCES payment_method(method_id),
    FOREIGN KEY (received_by) REFERENCES staff(staff_id)
);