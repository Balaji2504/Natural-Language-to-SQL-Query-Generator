CREATE DATABASE StudentDB;
CREATE TABLE StudentsMaster (
    StudentName VARCHAR(100),
    Gender CHAR(1),
    DOB DATE,
    FatherName VARCHAR(100),
    MotherName VARCHAR(100),
    FathersOccupation VARCHAR(100),
    FathersIncome DECIMAL(10, 2),
    BloodGroup VARCHAR(3),
    Address TEXT,
    City VARCHAR(50),
    State VARCHAR(50),
    DateOfJoining DATE,
    DateOfRecordCreation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UniqueStudentRegNo VARCHAR(15) PRIMARY KEY
);

DELIMITER $$

CREATE PROCEDURE GenerateStudents(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;

    WHILE i < num_rows DO
        INSERT INTO StudentsMaster (
            StudentName, Gender, DOB, FatherName, MotherName, FathersOccupation, FathersIncome,
            BloodGroup, Address, City, State, DateOfJoining, UniqueStudentRegNo
        ) VALUES (
            CONCAT('Student_', FLOOR(1 + (RAND() * 10000))),  -- Random student name
            IF(RAND() > 0.5, 'M', 'F'),                      -- Random gender
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 15 + 5) YEAR), -- Random DOB (5-15 years ago)
            CONCAT('Father_', FLOOR(1 + (RAND() * 10000))),   -- Random father name
            CONCAT('Mother_', FLOOR(1 + (RAND() * 10000))),   -- Random mother name
            IF(RAND() > 0.5, 'Engineer', 'Teacher'),          -- Random occupation
            ROUND(20000 + RAND() * 80000, 2),                -- Random income between 20k and 100k
            IF(RAND() > 0.33, 'O+', IF(RAND() > 0.5, 'A+', 'B+')), -- Random blood group
            CONCAT(FLOOR(RAND() * 100), ', Random Street'),   -- Random address
            IF(RAND() > 0.5, 'Chennai', 'Mumbai'),           -- Random city
            IF(RAND() > 0.5, 'Tamil Nadu', 'Maharashtra'),   -- Random state
            DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 3 + 1) YEAR), -- Random joining date
            CONCAT('S', FLOOR(RAND() * 100000))              -- Random unique registration number
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL GenerateStudents(250);

CREATE TABLE StudentsMarksheet (
    UniqueStudentRegNo VARCHAR(15),
    Class INT,
    Section CHAR(1),
    TestTerm VARCHAR(10),
    Tamil INT,
    English INT,
    Maths INT,
    Science INT,
    SocialScience INT,
    Total INT,
    Average DECIMAL(5, 2),
    Grade CHAR(1),
    PRIMARY KEY (UniqueStudentRegNo, TestTerm),
    FOREIGN KEY (UniqueStudentRegNo) REFERENCES StudentsMaster(UniqueStudentRegNo)
);

DROP PROCEDURE IF EXISTS GenerateMarks;
DELIMITER $$

CREATE PROCEDURE GenerateMarks(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 0;

    WHILE i < num_rows DO
        -- Fetch a random UniqueStudentRegNo from StudentsMaster
        SET @RandomRegNo = (SELECT UniqueStudentRegNo FROM StudentsMaster ORDER BY RAND() LIMIT 1);

        -- Generate a random test term
        SET @TestTerm = CONCAT('Term ', FLOOR(RAND() * 3 + 1)); -- Random Term 1, 2, or 3

        -- Check if the combination already exists
        IF NOT EXISTS (
            SELECT 1
            FROM StudentsMarksheet
            WHERE UniqueStudentRegNo = @RandomRegNo AND TestTerm = @TestTerm
        ) THEN
            -- Generate random data for marks and calculate totals and averages
            SET @Tamil = FLOOR(RAND() * 50 + 51); -- Random marks between 51 and 100
            SET @English = FLOOR(RAND() * 50 + 51);
            SET @Maths = FLOOR(RAND() * 50 + 51);
            SET @Science = FLOOR(RAND() * 50 + 51);
            SET @SocialScience = FLOOR(RAND() * 50 + 51);
            SET @Total = @Tamil + @English + @Maths + @Science + @SocialScience;
            SET @Average = @Total / 5;

            -- Assign grade based on average
            SET @Grade = CASE
                WHEN @Average >= 90 THEN 'A'
                WHEN @Average >= 75 THEN 'B'
                WHEN @Average >= 60 THEN 'C'
                ELSE 'D'
            END;

            -- Insert data into StudentsMarksheet table
            INSERT INTO StudentsMarksheet (
                UniqueStudentRegNo, Class, Section, TestTerm, Tamil, English, Maths, Science, SocialScience, Total, Average, Grade
            ) VALUES (
                @RandomRegNo,
                FLOOR(RAND() * 3 + 9), -- Random class (9, 10, 11)
                CHAR(65 + FLOOR(RAND() * 3)), -- Random section (A, B, C)
                @TestTerm,
                @Tamil, @English, @Maths, @Science, @SocialScience,
                @Total, @Average, @Grade
            );

            SET i = i + 1; -- Increment counter only on successful insertion
        END IF;

    END WHILE;
END$$

DELIMITER ;


CALL GenerateMarks(250);


SELECT * FROM StudentsMaster LIMIT 10;

SELECT * FROM StudentsMarksheet LIMIT 10;

-- Fetch Students Scoring Above 80% with Grade 'A'
SELECT 
    sm.StudentName, 
    sm.UniqueStudentRegNo, 
    smt.Class, 
    smt.Section, 
    smt.Total, 
    smt.Average, 
    smt.Grade
FROM 
    StudentsMaster sm
JOIN 
    StudentsMarksheet smt 
ON 
    sm.UniqueStudentRegNo = smt.UniqueStudentRegNo
WHERE 
    smt.Average > 80 
    AND smt.Grade = 'A';

--  Fetch Students from Low-Income Families Scoring Above 75%
SELECT 
    sm.StudentName, 
    sm.UniqueStudentRegNo, 
    sm.FatherName, 
    sm.FathersOccupation, 
    sm.FathersIncome, 
    smt.Class, 
    smt.Section, 
    smt.Total, 
    smt.Average, 
    smt.Grade
FROM 
    StudentsMaster sm
JOIN 
    StudentsMarksheet smt 
ON 
    sm.UniqueStudentRegNo = smt.UniqueStudentRegNo
WHERE 
    sm.FathersIncome < 200000 
    AND smt.Average > 75;

-- Count Students Admitted in a Specific Academic Year
SELECT 
    COUNT(*) AS StudentCount
FROM 
    StudentsMaster
WHERE 
    YEAR(DateOfJoining) = 2023;
DESCRIBE studentsmaster;

