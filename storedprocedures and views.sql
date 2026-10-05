USE school_record;
-- Procedure to enroll a new student
DELIMITER //
CREATE PROCEDURE sp_EnrollStudent(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_gender CHAR(1),
    IN p_birth_date DATE,
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_admission_number VARCHAR(50),
    IN p_class_id INT,
    IN p_academic_year_id INT,
    IN p_street_name VARCHAR(255),
    IN p_postal_code VARCHAR(20),
    IN p_city_id INT
)
BEGIN
    DECLARE v_person_id INT;
    DECLARE v_student_id INT;
    DECLARE v_address_id INT;
    
    -- Insert address first
    INSERT INTO address (street_name, postal_code, city_id)
    VALUES (p_street_name, p_postal_code, p_city_id);
    SET v_address_id = LAST_INSERT_ID();
    
    -- Insert person
    INSERT INTO people (first_name, last_name, gender, birth_date, phone, email, address_id)
    VALUES (p_first_name, p_last_name, p_gender, p_birth_date, p_phone, p_email, v_address_id);
    SET v_person_id = LAST_INSERT_ID();
    
    -- Insert student
    INSERT INTO student (person_id, admission_number)
    VALUES (v_person_id, p_admission_number);
    SET v_student_id = LAST_INSERT_ID();
    
    -- Enroll student in class
    INSERT INTO student_enrollment (student_id, class_id, academic_year_id)
    VALUES (v_student_id, p_class_id, p_academic_year_id);
    
    SELECT v_student_id AS new_student_id;
END //
DELIMITER ;

-- Procedure to assign guardian to student
DELIMITER //
CREATE PROCEDURE sp_AssignGuardian(
    IN p_student_id INT,
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_gender CHAR(1),
    IN p_phone VARCHAR(20),
    IN p_email VARCHAR(100),
    IN p_relationship VARCHAR(50),
    IN p_street_name VARCHAR(255),
    IN p_postal_code VARCHAR(20),
    IN p_city_id INT
)
BEGIN
    DECLARE v_person_id INT;
    DECLARE v_guardian_id INT;
    DECLARE v_address_id INT;
    
    -- Insert address
    INSERT INTO address (street_name, postal_code, city_id)
    VALUES (p_street_name, p_postal_code, p_city_id);
    SET v_address_id = LAST_INSERT_ID();
    
    -- Insert person
    INSERT INTO people (first_name, last_name, gender, phone, email, address_id)
    VALUES (p_first_name, p_last_name, p_gender, p_phone, p_email, v_address_id);
    SET v_person_id = LAST_INSERT_ID();
    
    -- Insert guardian
    INSERT INTO guardian (person_id, relationship)
    VALUES (v_person_id, p_relationship);
    SET v_guardian_id = LAST_INSERT_ID();
    
    -- Assign guardian to student
    INSERT INTO student_guardian (student_id, guardian_id)
    VALUES (p_student_id, v_guardian_id);
    
    SELECT v_guardian_id AS new_guardian_id;
END //
DELIMITER ;

-- Procedure to record attendance
DELIMITER //
CREATE PROCEDURE sp_RecordAttendance(
    IN p_student_id INT,
    IN p_class_id INT,
    IN p_date DATE,
    IN p_status_id INT
)
BEGIN
    -- Check if attendance already exists for this student on this date
    IF NOT EXISTS (SELECT 1 FROM attendance WHERE student_id = p_student_id AND class_id = p_class_id AND date = p_date) THEN
        INSERT INTO attendance (student_id, class_id, date, status_id)
        VALUES (p_student_id, p_class_id, p_date, p_status_id);
    ELSE
        UPDATE attendance SET status_id = p_status_id
        WHERE student_id = p_student_id AND class_id = p_class_id AND date = p_date;
    END IF;
END //
DELIMITER ;

-- Procedure to record exam results
DELIMITER //
CREATE PROCEDURE sp_RecordExamResult(
    IN p_student_id INT,
    IN p_exam_id INT,
    IN p_class_id INT,
    IN p_subject_id INT,
    IN p_score DECIMAL(5,2),
    IN p_teacher_id INT
)
BEGIN
    DECLARE v_grade_id INT;
    
    -- Find the appropriate grade based on score
    SELECT grade_id INTO v_grade_id
    FROM grading_system
    WHERE p_score BETWEEN min_score AND max_score
    AND academic_year_id = (SELECT academic_year_id FROM exam WHERE exam_id = p_exam_id)
    LIMIT 1;
    
    -- Insert or update the result
    IF NOT EXISTS (SELECT 1 FROM exam_result 
                  WHERE student_id = p_student_id 
                  AND exam_id = p_exam_id 
                  AND class_id = p_class_id 
                  AND subject_id = p_subject_id) THEN
        INSERT INTO exam_result (student_id, exam_id, class_id, subject_id, grade_id, teacher_id)
        VALUES (p_student_id, p_exam_id, p_class_id, p_subject_id, v_grade_id, p_teacher_id);
    ELSE
        UPDATE exam_result 
        SET grade_id = v_grade_id, teacher_id = p_teacher_id
        WHERE student_id = p_student_id 
        AND exam_id = p_exam_id 
        AND class_id = p_class_id 
        AND subject_id = p_subject_id;
    END IF;
END //
DELIMITER ;


-- Procedure to record fee payment
DELIMITER //
CREATE PROCEDURE sp_RecordFeePayment(
    IN p_student_id INT,
    IN p_fee_id INT,
    IN p_method_id INT,
    IN p_received_by INT,
    IN p_payment_date DATE,
    IN p_amount_paid DECIMAL(10,2)
)
BEGIN
    INSERT INTO fee_payment (student_id, fee_id, method_id, received_by, payment_date, amount_paid)
    VALUES (p_student_id, p_fee_id, p_method_id, p_received_by, p_payment_date, p_amount_paid);
    
    -- Return payment summary
    SELECT 
        s.student_id,
        p.first_name,
        p.last_name,
        c.name AS class_name,
        ay.name AS academic_year,
        t.name AS term,
        fp.amount_paid,
        (fs.amount - IFNULL((SELECT SUM(amount_paid) FROM fee_payment WHERE student_id = p_student_id AND fee_id = p_fee_id), 0)) AS balance
    FROM fee_payment fp
    JOIN student s ON fp.student_id = s.student_id
    JOIN people p ON s.person_id = p.person_id
    JOIN fee_structure fs ON fp.fee_id = fs.fee_id
    JOIN class c ON fs.class_id = c.class_id
    JOIN academic_year ay ON fs.academic_year_id = ay.academic_year_id
    JOIN term t ON fs.term_id = t.term_id
    WHERE fp.payment_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- Procedure to generate fee statement
DELIMITER //
CREATE PROCEDURE sp_GenerateFeeStatement(
    IN p_student_id INT,
    IN p_academic_year_id INT
)
BEGIN
    SELECT 
        fs.fee_id,
        ay.name AS academic_year,
        t.name AS term,
        c.name AS class,
        fs.amount AS fee_amount,
        IFNULL(SUM(fp.amount_paid), 0) AS amount_paid,
        (fs.amount - IFNULL(SUM(fp.amount_paid), 0)) AS balance,
        CASE WHEN (fs.amount - IFNULL(SUM(fp.amount_paid), 0)) <= 0 THEN 'Paid' ELSE 'Pending' END AS status
    FROM fee_structure fs
    JOIN class c ON fs.class_id = c.class_id
    JOIN academic_year ay ON fs.academic_year_id = ay.academic_year_id
    JOIN term t ON fs.term_id = t.term_id
    LEFT JOIN fee_payment fp ON fs.fee_id = fp.fee_id AND fp.student_id = p_student_id
    WHERE fs.class_id = (SELECT class_id FROM student_enrollment WHERE student_id = p_student_id AND academic_year_id = p_academic_year_id)
    AND fs.academic_year_id = p_academic_year_id
    GROUP BY fs.fee_id, ay.name, t.name, c.name, fs.amount;
END //
DELIMITER ;


-- View for student directory
CREATE VIEW vw_StudentDirectory AS
SELECT 
    s.student_id,
    p.first_name,
    p.last_name,
    p.gender,
    p.birth_date,
    p.phone,
    p.email,
    s.admission_number,
    c.name AS current_class,
    ay.name AS academic_year,
    CONCAT(a.street_name, ', ', ci.name, ', ', sp.name, ', ', co.name) AS address
FROM student s
JOIN people p ON s.person_id = p.person_id
JOIN student_enrollment se ON s.student_id = se.student_id
JOIN class c ON se.class_id = c.class_id
JOIN academic_year ay ON se.academic_year_id = ay.academic_year_id
LEFT JOIN address a ON p.address_id = a.address_id
LEFT JOIN city ci ON a.city_id = ci.city_id
LEFT JOIN state_province sp ON ci.state_id = sp.state_id
LEFT JOIN country co ON sp.country_id = co.country_id
WHERE se.academic_year_id = (SELECT MAX(academic_year_id) FROM academic_year);

-- View for student guardians
CREATE VIEW vw_StudentGuardians AS
SELECT 
    s.student_id,
    p.first_name AS student_first_name,
    p.last_name AS student_last_name,
    gp.first_name AS guardian_first_name,
    gp.last_name AS guardian_last_name,
    g.relationship,
    gp.phone AS guardian_phone,
    gp.email AS guardian_email
FROM student s
JOIN people p ON s.person_id = p.person_id
JOIN student_guardian sg ON s.student_id = sg.student_id
JOIN guardian g ON sg.guardian_id = g.guardian_id
JOIN people gp ON g.person_id = gp.person_id;


-- View for student performance summary
CREATE VIEW vw_StudentPerformance AS
SELECT 
    s.student_id,
    p.first_name,
    p.last_name,
    c.name AS class,
    sub.name AS subject,
    e.name AS exam,
    et.name AS exam_type,
    t.name AS term,
    ay.name AS academic_year,
    er.grade_id,
    gs.grade_label,
    (gs.min_score + gs.max_score)/2 AS average_score
FROM exam_result er
JOIN student s ON er.student_id = s.student_id
JOIN people p ON s.person_id = p.person_id
JOIN class c ON er.class_id = c.class_id
JOIN subject sub ON er.subject_id = sub.subject_id
JOIN exam e ON er.exam_id = e.exam_id
JOIN exam_type et ON e.exam_type_id = et.exam_type_id
JOIN term t ON e.term_id = t.term_id
JOIN academic_year ay ON e.academic_year_id = ay.academic_year_id
JOIN grading_system gs ON er.grade_id = gs.grade_id;

-- View for class performance by subject
CREATE VIEW vw_ClassSubjectPerformance AS
SELECT 
    c.class_id,
    c.name AS class,
    sub.subject_id,
    sub.name AS subject,
    ay.academic_year_id,
    ay.name AS academic_year,
    t.term_id,
    t.name AS term,
    e.exam_id,
    e.name AS exam,
    COUNT(er.student_id) AS students_count,
    AVG((gs.min_score + gs.max_score)/2) AS average_score,
    MAX((gs.min_score + gs.max_score)/2) AS highest_score,
    MIN((gs.min_score + gs.max_score)/2) AS lowest_score
FROM exam_result er
JOIN class c ON er.class_id = c.class_id
JOIN subject sub ON er.subject_id = sub.subject_id
JOIN exam e ON er.exam_id = e.exam_id
JOIN academic_year ay ON e.academic_year_id = ay.academic_year_id
JOIN term t ON e.term_id = t.term_id
JOIN grading_system gs ON er.grade_id = gs.grade_id
GROUP BY c.class_id, c.name, sub.subject_id, sub.name, ay.academic_year_id, ay.name, t.term_id, t.name, e.exam_id, e.name;

-- View for student attendance summary
CREATE VIEW vw_StudentAttendanceSummary AS
SELECT 
    s.student_id,
    p.first_name,
    p.last_name,
    c.name AS class,
    ay.name AS academic_year,
    COUNT(CASE WHEN a.status_id = 1 THEN 1 END) AS present_days,
    COUNT(CASE WHEN a.status_id = 2 THEN 1 END) AS absent_days,
    COUNT(CASE WHEN a.status_id = 3 THEN 1 END) AS late_days,
    COUNT(*) AS total_days,
    ROUND((COUNT(CASE WHEN a.status_id = 1 THEN 1 END) / COUNT(*)) * 100, 2) AS attendance_percentage
FROM attendance a
JOIN student s ON a.student_id = s.student_id
JOIN people p ON s.person_id = p.person_id
JOIN class c ON a.class_id = c.class_id
JOIN academic_year ay ON c.academic_year_id = ay.academic_year_id
GROUP BY s.student_id, p.first_name, p.last_name, c.name, ay.name;

-- View for fee payment summary
CREATE VIEW vw_FeePaymentSummary AS
SELECT 
    s.student_id,
    p.first_name,
    p.last_name,
    c.name AS class,
    ay.name AS academic_year,
    t.name AS term,
    fs.amount AS expected_amount,
    SUM(fp.amount_paid) AS paid_amount,
    (fs.amount - SUM(fp.amount_paid)) AS balance,
    CASE WHEN (fs.amount - SUM(fp.amount_paid)) <= 0 THEN 'Paid' ELSE 'Pending' END AS status
FROM fee_structure fs
JOIN class c ON fs.class_id = c.class_id
JOIN academic_year ay ON fs.academic_year_id = ay.academic_year_id
JOIN term t ON fs.term_id = t.term_id
JOIN student_enrollment se ON c.class_id = se.class_id AND ay.academic_year_id = se.academic_year_id
JOIN student s ON se.student_id = s.student_id
JOIN people p ON s.person_id = p.person_id
LEFT JOIN fee_payment fp ON fs.fee_id = fp.fee_id AND s.student_id = fp.student_id
GROUP BY s.student_id, p.first_name, p.last_name, c.name, ay.name, t.name, fs.amount;


