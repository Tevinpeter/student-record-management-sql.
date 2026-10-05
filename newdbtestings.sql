USE school_record;

-- Insert countries (Tanzania)
INSERT INTO country (name) VALUES ('Tanzania');

-- Insert regions (states)
INSERT INTO state_province (country_id, name) VALUES 
(1, 'Dar es Salaam'), 
(1, 'Arusha'),
(1, 'Kilimanjaro'),
(1, 'Mwanza'),
(1, 'Mbeya');

-- Insert cities
INSERT INTO city (state_id, name) VALUES 
(1, 'Dar es Salaam'), 
(1, 'Kigamboni'),
(2, 'Arusha'),
(2, 'Moshi'),
(3, 'Moshi'),
(3, 'Himo'),
(4, 'Mwanza'),
(4, 'Nyamagana'),
(5, 'Mbeya'),
(5, 'Mbalizi');

-- Insert academic years
INSERT INTO academic_year (name) VALUES 
('2022-2023'), 
('2023-2024');

-- Insert terms
INSERT INTO term (academic_year_id, name) VALUES 
(1, 'Term 1'), (1, 'Term 2'), (1, 'Term 3'),
(2, 'Term 1'), (2, 'Term 2'), (2, 'Term 3');

-- Insert staff positions
INSERT INTO people (first_name, last_name, gender, birth_date, phone, email) VALUES
('John', 'Mkumbo', 'M', '1980-05-15', '+255712345678', 'john.mkumbo@school.edu'),
('Mary', 'Kassim', 'F', '1985-08-22', '+255713456789', 'mary.kassim@school.edu'),
('James', 'Nyirenda', 'M', '1975-03-10', '+255714567890', 'james.nyirenda@school.edu'),
('Grace', 'Mwakasege', 'F', '1990-11-30', '+255715678901', 'grace.mwakasege@school.edu');

INSERT INTO staff (person_id, position, department) VALUES
(1, 'Headmaster', 'Administration'),
(2, 'Deputy Headmaster', 'Administration'),
(3, 'Mathematics Teacher', 'Mathematics'),
(4, 'English Teacher', 'Languages');

-- Insert classes
INSERT INTO class (academic_year_id, name, class_teacher_id) VALUES
(2, 'Form 1', 2),
(2, 'Form 2', 1),
(2, 'Form 3', 2),
(2, 'Form 4', 1);

-- Insert subject categories
INSERT INTO subject_category (name) VALUES 
('Science'), 
('Languages'),
('Humanities'),
('Vocational');

-- Insert subjects
INSERT INTO subject (category_id, name) VALUES
(1, 'Mathematics'),
(1, 'Physics'),
(1, 'Chemistry'),
(1, 'Biology'),
(2, 'English'),
(2, 'Kiswahili'),
(3, 'History'),
(3, 'Geography'),
(3, 'Civics'),
(4, 'Commerce'),
(4, 'Book Keeping');

-- Assign subjects to classes
INSERT INTO class_subject (class_id, subject_id, teacher_id) VALUES
(1, 1, 3), (1, 5, 4), (1, 6, 4),
(2, 1, 3), (2, 2, 3), (2, 5, 4),
(3, 1, 3), (3, 3, 3), (3, 4, 3),
(4, 1, 3), (4, 2, 3), (4, 3, 3);

-- Insert attendance statuses
INSERT INTO attendance_status (name) VALUES 
('Present'), 
('Absent'),
('Late');

-- Insert exam types
INSERT INTO exam_type (name) VALUES 
('Midterm'), 
('End of Term'),
('Annual');

-- Insert grading system
INSERT INTO grading_system (academic_year_id, grade_label, min_score, max_score) VALUES
(2, 'A', 75, 100),
(2, 'B', 65, 74.99),
(2, 'C', 50, 64.99),
(2, 'D', 40, 49.99),
(2, 'F', 0, 39.99);

-- Insert payment methods
INSERT INTO payment_method (name) VALUES 
('Cash'), 
('Bank Transfer'),
('Mobile Money');

-- Insert fee structures
INSERT INTO fee_structure (academic_year_id, term_id, class_id, amount) VALUES
(2, 4, 1, 150000),
(2, 4, 2, 160000),
(2, 4, 3, 170000),
(2, 4, 4, 180000),
(2, 5, 1, 150000),
(2, 5, 2, 160000),
(2, 5, 3, 170000),
(2, 5, 4, 180000);

-- Insert students (Tanzanian names)
-- First create addresses
INSERT INTO address (street_name, postal_code, city_id) VALUES
('Mikocheni B', '14112', 1),
('Kariakoo', '12111', 1),
('Njiro', '12345', 3),
('Soweto', '23234', 7),
('Mabatini', '33221', 7),
('Mbalizi Road', '53221', 10);

-- Then insert people
INSERT INTO people (first_name, last_name, gender, birth_date, phone, email, address_id) VALUES
('Juma', 'Mohamed', 'M', '2008-03-15', '+255754123456', 'juma.mohamed@example.com', 1),
('Asha', 'Juma', 'F', '2007-05-22', '+255755234567', 'asha.juma@example.com', 2),
('Baraka', 'Kipengele', 'M', '2007-11-10', '+255756345678', 'baraka.kipengele@example.com', 3),
('Neema', 'Samwel', 'F', '2006-09-30', '+255757456789', 'neema.samwel@example.com', 4),
('Rajabu', 'Mwakalinga', 'M', '2006-07-18', '+255758567890', 'rajabu.mwakalinga@example.com', 5),
('Fatuma', 'Kibwana', 'F', '2005-12-05', '+255759678901', 'fatuma.kibwana@example.com', 6);

-- Then insert students
INSERT INTO student (person_id, admission_number) VALUES
(5, 'F001/2023'),
(6, 'F002/2023'),
(7, 'F003/2023'),
(8, 'F004/2023'),
(9, 'F005/2023'),
(10, 'F006/2023');

-- Enroll students
INSERT INTO student_enrollment (student_id, class_id, academic_year_id) VALUES
(1, 1, 2),
(2, 1, 2),
(3, 2, 2),
(4, 3, 2),
(5, 4, 2),
(6, 4, 2);

-- Insert guardians
INSERT INTO people (first_name, last_name, gender, phone, email, address_id) VALUES
('Mohamed', 'Juma', 'M', '+255714123456', 'mohamed.juma@example.com', 1),
('Aisha', 'Juma', 'F', '+255715234567', 'aisha.juma@example.com', 1),
('Kipengele', 'Mkumbo', 'M', '+255716345678', 'kipengele.mkumbo@example.com', 3),
('Samwel', 'Kassim', 'M', '+255717456789', 'samwel.kassim@example.com', 4),
('Mwakalinga', 'Nyirenda', 'M', '+255718567890', 'mwakalinga.nyirenda@example.com', 5),
('Kibwana', 'Mwakasege', 'M', '+255719678901', 'kibwana.mwakasege@example.com', 6);

INSERT INTO guardian (person_id, relationship) VALUES
(11, 'Father'),
(12, 'Mother'),
(13, 'Father'),
(14, 'Father'),
(15, 'Father'),
(16, 'Father');

INSERT INTO student_guardian (student_id, guardian_id) VALUES
(1, 1), (1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 6),
(6, 6);

-- Insert attendance records (sample for 5 days)
INSERT INTO attendance (student_id, class_id, date, status_id) VALUES
-- Day 1
(1, 1, '2023-09-01', 1),
(2, 1, '2023-09-01', 1),
(3, 2, '2023-09-01', 1),
(4, 3, '2023-09-01', 2), -- Absent
(5, 4, '2023-09-01', 1),
(6, 4, '2023-09-01', 3), -- Late

-- Day 2
(1, 1, '2023-09-02', 1),
(2, 1, '2023-09-02', 2), -- Absent
(3, 2, '2023-09-02', 1),
(4, 3, '2023-09-02', 1),
(5, 4, '2023-09-02', 1),
(6, 4, '2023-09-02', 1),

-- Day 3
(1, 1, '2023-09-03', 1),
(2, 1, '2023-09-03', 1),
(3, 2, '2023-09-03', 3), -- Late
(4, 3, '2023-09-03', 1),
(5, 4, '2023-09-03', 2), -- Absent
(6, 4, '2023-09-03', 1),

-- Day 4
(1, 1, '2023-09-04', 1),
(2, 1, '2023-09-04', 1),
(3, 2, '2023-09-04', 1),
(4, 3, '2023-09-04', 1),
(5, 4, '2023-09-04', 1),
(6, 4, '2023-09-04', 1),

-- Day 5
(1, 1, '2023-09-05', 2), -- Absent
(2, 1, '2023-09-05', 1),
(3, 2, '2023-09-05', 1),
(4, 3, '2023-09-05', 1),
(5, 4, '2023-09-05', 1),
(6, 4, '2023-09-05', 3); -- Late

-- Insert exams
INSERT INTO exam (academic_year_id, term_id, exam_type_id, name) VALUES
(2, 4, 1, 'Form 1 Midterm 1'),
(2, 4, 1, 'Form 2 Midterm 1'),
(2, 4, 1, 'Form 3 Midterm 1'),
(2, 4, 1, 'Form 4 Midterm 1');

-- Insert exam results
-- For Form 1 students in Mathematics
CALL sp_RecordExamResult(1, 1, 1, 1, 78, 3);
CALL sp_RecordExamResult(2, 1, 1, 1, 65, 3);

-- For Form 1 students in English
CALL sp_RecordExamResult(1, 1, 1, 5, 82, 4);
CALL sp_RecordExamResult(2, 1, 1, 5, 70, 4);

-- For Form 2 student in Mathematics
CALL sp_RecordExamResult(3, 2, 2, 1, 88, 3);

-- For Form 3 student in Chemistry
CALL sp_RecordExamResult(4, 3, 3, 3, 72, 3);

-- For Form 4 students in Physics
CALL sp_RecordExamResult(5, 4, 4, 2, 68, 3);
CALL sp_RecordExamResult(6, 4, 4, 2, 55, 3);

-- Insert fee payments
CALL sp_RecordFeePayment(1, 1, 3, 1, '2023-09-01', 50000);
CALL sp_RecordFeePayment(1, 1, 3, 1, '2023-09-15', 50000);
CALL sp_RecordFeePayment(1, 1, 3, 1, '2023-09-30', 50000);

CALL sp_RecordFeePayment(2, 1, 1, 2, '2023-09-05', 150000);

CALL sp_RecordFeePayment(3, 2, 2, 1, '2023-09-10', 80000);
CALL sp_RecordFeePayment(3, 2, 3, 1, '2023-09-25', 80000);

CALL sp_RecordFeePayment(4, 3, 1, 2, '2023-09-12', 170000);

CALL sp_RecordFeePayment(5, 4, 3, 1, '2023-09-08', 90000);
CALL sp_RecordFeePayment(5, 4, 3, 1, '2023-09-22', 90000);

CALL sp_RecordFeePayment(6, 4, 2, 1, '2023-09-18', 180000);


-- Enroll a new student
CALL sp_EnrollStudent(
    'Amani', 
    'Kimambo', 
    'M', 
    '2007-04-12', 
    '+255755112233', 
    'amani.kimambo@example.com', 
    'F007/2023', 
    1, 
    2,
    'Mbezi Beach', 
    '14113', 
    1
);


-- Assign guardian to the new student
CALL sp_AssignGuardian(
    7, -- New student ID
    'Robert', 
    'Kimambo', 
    'M', 
    '+255714112233', 
    'robert.kimambo@example.com', 
    'Father',
    'Mbezi Beach', 
    '14113', 
    1
);

-- Record attendance for the new student
CALL sp_RecordAttendance(7, 1, '2023-09-06', 1); -- Present
CALL sp_RecordAttendance(7, 1, '2023-09-07', 3); -- Late

-- Record fee payment for the new student
CALL sp_RecordFeePayment(7, 1, 3, 1, '2023-09-20', 75000);

-- View student directory
SELECT * FROM vw_StudentDirectory;

-- View student guardians
SELECT * FROM vw_StudentGuardians WHERE student_id = 1;

-- View student performance
SELECT * FROM vw_StudentPerformance WHERE student_id = 1;

-- View class performance
SELECT * FROM vw_ClassSubjectPerformance WHERE class_id = 1;

-- View attendance summary
SELECT * FROM vw_StudentAttendanceSummary;

-- View fee payment summary
SELECT * FROM vw_FeePaymentSummary;


-- Generate fee statement for a student
CALL sp_GenerateFeeStatement(1, 2);