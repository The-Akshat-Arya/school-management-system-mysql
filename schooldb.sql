-- ============================================================
-- MySQL Case Study Project: School Management System Database
-- Database: SchoolDB
-- Compatible with: MySQL Workbench / MySQL 8+
-- ============================================================

DROP DATABASE IF EXISTS SchoolDB;
CREATE DATABASE SchoolDB;
USE SchoolDB;


-- ============================================================
-- 1. DATABASE CREATION + TABLE DESIGN
-- ============================================================

CREATE TABLE Students (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Class VARCHAR(20) NOT NULL,
    Age INT NOT NULL,
    City VARCHAR(50) NOT NULL
);

CREATE TABLE Marks (
    MarkID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT NOT NULL,
    Subject VARCHAR(50) NOT NULL,
    Marks INT NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);


-- ============================================================
-- 2. INSERT OPERATIONS: SAMPLE RECORDS
-- ============================================================

INSERT INTO Students (Name, Class, Age, City) VALUES
('Aarav Sharma', '10A', 15, 'Ranchi'),
('Ananya Verma', '10A', 14, 'Patna'),
('Rohan Kumar', '10B', 15, 'Ranchi'),
('Priya Singh', '10B', 16, 'Jamshedpur'),
('Kabir Das', '9A', 14, 'Bokaro'),
('Sneha Gupta', '9A', 13, 'Ranchi'),
('Vikram Mehta', '9B', 14, 'Dhanbad'),
('Isha Roy', '10A', 15, 'Ranchi'),
('Manav Sinha', '10B', 16, 'Patna'),
('Nisha Kumari', '9B', 13, 'Jamshedpur');

INSERT INTO Marks (StudentID, Subject, Marks) VALUES
(1, 'Science', 88), (1, 'Maths', 92), (1, 'English', 81),
(2, 'Science', 76), (2, 'Maths', 85), (2, 'English', 79),
(3, 'Science', 91), (3, 'Maths', 89), (3, 'English', 84),
(4, 'Science', 68), (4, 'Maths', 73), (4, 'English', 77),
(5, 'Science', 82), (5, 'Maths', 80), (5, 'English', 74),
(6, 'Science', 95), (6, 'Maths', 90), (6, 'English', 88),
(7, 'Science', 71), (7, 'Maths', 69), (7, 'English', 72),
(8, 'Science', 86), (8, 'Maths', 94), (8, 'English', 91),
(9, 'Science', 64), (9, 'Maths', 70), (9, 'English', 66),
(10, 'Science', 79), (10, 'Maths', 83), (10, 'English', 80);


-- Question: Add a new student record

INSERT INTO Students (Name, Class, Age, City)
VALUES ('Aditya Raj', '10A', 15, 'Ranchi');


-- Store the new student's ID and add marks for him

SET @NewStudentID = LAST_INSERT_ID();

INSERT INTO Marks (StudentID, Subject, Marks) VALUES
(@NewStudentID, 'Science', 84),
(@NewStudentID, 'Maths', 87),
(@NewStudentID, 'English', 82);


-- ============================================================
-- 3. BASIC QUERIES
-- ============================================================

-- Question 1: Display all students

SELECT *
FROM Students;


-- Question 2: Display student names and cities

SELECT Name, City
FROM Students;


-- Question 3: Find students from Ranchi

SELECT *
FROM Students
WHERE City = 'Ranchi';


-- Question 4: Find students older than 14 years

SELECT *
FROM Students
WHERE Age > 14;


-- Question 5: Sort students by name

SELECT *
FROM Students
ORDER BY Name ASC;


-- ============================================================
-- 4. AGGREGATE FUNCTIONS
-- ============================================================

-- Question 6: Count total students

SELECT COUNT(*) AS TotalStudents
FROM Students;


-- Question 7: Calculate average age

SELECT AVG(Age) AS AverageAge
FROM Students;


-- Question 8: Find maximum marks

SELECT MAX(Marks) AS MaximumMarks
FROM Marks;


-- Question 9: Find minimum marks

SELECT MIN(Marks) AS MinimumMarks
FROM Marks;


-- Question 10: Calculate total Science marks

SELECT SUM(Marks) AS TotalScienceMarks
FROM Marks
WHERE Subject = 'Science';


-- ============================================================
-- 5. GROUP BY QUERIES
-- ============================================================

-- Question 11: Count students city-wise

SELECT
    City,
    COUNT(*) AS TotalStudents
FROM Students
GROUP BY City
ORDER BY TotalStudents DESC;


-- Question 12: Calculate average marks subject-wise

SELECT
    Subject,
    ROUND(AVG(Marks), 2) AS AverageMarks
FROM Marks
GROUP BY Subject
ORDER BY AverageMarks DESC;


-- ============================================================
-- 6. JOINS
-- ============================================================

-- Question 13: Display student name, subject and marks

SELECT
    s.Name,
    m.Subject,
    m.Marks
FROM Students AS s
INNER JOIN Marks AS m
    ON s.StudentID = m.StudentID
ORDER BY s.Name, m.Subject;


-- Question 14: Find students scoring above 80

SELECT
    s.Name,
    s.Class,
    m.Subject,
    m.Marks
FROM Students AS s
INNER JOIN Marks AS m
    ON s.StudentID = m.StudentID
WHERE m.Marks > 80
ORDER BY m.Marks DESC;


-- Question 15: Find the highest-scoring student overall

SELECT
    s.Name,
    s.Class,
    m.Subject,
    m.Marks
FROM Students AS s
INNER JOIN Marks AS m
    ON s.StudentID = m.StudentID
WHERE m.Marks = (
    SELECT MAX(Marks)
    FROM Marks
);


-- ============================================================
-- 7. UPDATE AND DELETE
-- ============================================================

-- Question 16: Update city information

UPDATE Students
SET City = 'Ranchi'
WHERE StudentID = 2;

SELECT *
FROM Students
WHERE StudentID = 2;


-- Question 17: Increase Science marks by 5 without exceeding 100

UPDATE Marks
SET Marks = LEAST(Marks + 5, 100)
WHERE Subject = 'Science'
  AND MarkID > 0;


-- Display updated Science marks

SELECT *
FROM Marks
WHERE Subject = 'Science'
  AND MarkID > 0;


-- Display updated Science marks with student names

SELECT
    s.Name,
    m.Subject,
    m.Marks
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
WHERE m.Subject = 'Science'
ORDER BY m.Marks DESC;


-- Question 18: Delete the newly added student record
-- First delete marks because Marks is connected to Students

DELETE FROM Marks
WHERE StudentID = @NewStudentID;

DELETE FROM Students
WHERE StudentID = @NewStudentID;

SELECT *
FROM Students;


-- ============================================================
-- 8. SUBQUERIES
-- ============================================================

-- Question 19: Find students who scored above the overall average marks

SELECT DISTINCT
    s.StudentID,
    s.Name,
    s.Class
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
WHERE m.Marks > (
    SELECT AVG(Marks)
    FROM Marks
)
ORDER BY s.Name;


-- Question 20: Find the second-highest marks value

SELECT MAX(Marks) AS SecondHighestMarks
FROM Marks
WHERE Marks < (
    SELECT MAX(Marks)
    FROM Marks
);


-- Question 21: Show student(s) who got the second-highest marks

SELECT
    s.Name,
    s.Class,
    m.Subject,
    m.Marks
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
WHERE m.Marks = (
    SELECT MAX(Marks)
    FROM Marks
    WHERE Marks < (
        SELECT MAX(Marks)
        FROM Marks
    )
);


-- ============================================================
-- 9. BUSINESS REPORTS
-- ============================================================

-- Question 22: Generate grade reports

SELECT
    s.StudentID,
    s.Name,
    s.Class,
    m.Subject,
    m.Marks,
    CASE
        WHEN m.Marks >= 90 THEN 'A+'
        WHEN m.Marks >= 80 THEN 'A'
        WHEN m.Marks >= 70 THEN 'B'
        WHEN m.Marks >= 60 THEN 'C'
        WHEN m.Marks >= 50 THEN 'D'
        ELSE 'Fail'
    END AS Grade
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
ORDER BY s.StudentID, m.Subject;


-- Question 23: Find top performers based on average marks

SELECT
    s.StudentID,
    s.Name,
    s.Class,
    ROUND(AVG(m.Marks), 2) AS AverageMarks,
    SUM(m.Marks) AS TotalMarks
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
GROUP BY
    s.StudentID,
    s.Name,
    s.Class
ORDER BY AverageMarks DESC
LIMIT 5;


-- Question 24: Generate subject-wise topper report

SELECT
    m.Subject,
    s.Name AS TopperName,
    s.Class,
    m.Marks AS HighestMarks
FROM Marks AS m
JOIN Students AS s
    ON m.StudentID = s.StudentID
WHERE m.Marks = (
    SELECT MAX(m2.Marks)
    FROM Marks AS m2
    WHERE m2.Subject = m.Subject
)
ORDER BY m.Subject;


-- Question 25: Generate city-wise performance report

SELECT
    s.City,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    ROUND(AVG(m.Marks), 2) AS AverageMarks,
    MAX(m.Marks) AS HighestMarks,
    MIN(m.Marks) AS LowestMarks
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
GROUP BY s.City
ORDER BY AverageMarks DESC;


-- Question 26: Generate class-wise performance report

SELECT
    s.Class,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    ROUND(AVG(m.Marks), 2) AS AverageMarks,
    SUM(m.Marks) AS TotalMarks
FROM Students AS s
JOIN Marks AS m
    ON s.StudentID = m.StudentID
GROUP BY s.Class
ORDER BY AverageMarks DESC;


-- ============================================================
-- 10. SHOW ALL TABLE DATA AT THE END
-- ============================================================

SELECT *
FROM Students;

SELECT *
FROM Marks;
