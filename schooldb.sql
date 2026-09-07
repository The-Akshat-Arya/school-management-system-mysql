-- School Management System practice project
-- Basic Students + Marks schema with some sample data and the queries
-- I used to practice joins, subqueries, grouping, and a few small reports.
-- MySQL 8+ (uses a CHECK constraint and a window function below)

DROP DATABASE IF EXISTS SchoolDB;
CREATE DATABASE SchoolDB;
USE SchoolDB;

-- schema

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
    Marks INT NOT NULL CHECK (Marks BETWEEN 0 AND 100),
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID)
);

-- sample data

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

-- adding one more student to test the insert/delete flow below

INSERT INTO Students (Name, Class, Age, City)
VALUES ('Aditya Raj', '10A', 15, 'Ranchi');

SET @NewStudentID = LAST_INSERT_ID();

INSERT INTO Marks (StudentID, Subject, Marks) VALUES
(@NewStudentID, 'Science', 84),
(@NewStudentID, 'Maths', 87),
(@NewStudentID, 'English', 82);

-- basic selects

SELECT * FROM Students;

SELECT Name, City FROM Students;

-- students from Ranchi
SELECT * FROM Students WHERE City = 'Ranchi';

-- older than 14
SELECT * FROM Students WHERE Age > 14;

SELECT * FROM Students ORDER BY Name ASC;

-- aggregates

SELECT COUNT(*) AS TotalStudents FROM Students;

SELECT AVG(Age) AS AverageAge FROM Students;

SELECT MAX(Marks) AS MaximumMarks FROM Marks;

SELECT MIN(Marks) AS MinimumMarks FROM Marks;

-- total marks scored in Science across everyone
SELECT SUM(Marks) AS TotalScienceMarks
FROM Marks
WHERE Subject = 'Science';

-- group by

-- students per city
SELECT City, COUNT(*) AS TotalStudents
FROM Students
GROUP BY City
ORDER BY TotalStudents DESC;

-- avg marks per subject
SELECT Subject, ROUND(AVG(Marks), 2) AS AverageMarks
FROM Marks
GROUP BY Subject
ORDER BY AverageMarks DESC;

-- joins

SELECT s.Name, m.Subject, m.Marks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
ORDER BY s.Name, m.Subject;

-- who scored above 80
SELECT s.Name, s.Class, m.Subject, m.Marks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
WHERE m.Marks > 80
ORDER BY m.Marks DESC;

-- single highest score in the whole dataset
SELECT s.Name, s.Class, m.Subject, m.Marks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
WHERE m.Marks = (SELECT MAX(Marks) FROM Marks);

-- updates / cleanup

UPDATE Students
SET City = 'Ranchi'
WHERE StudentID = 2;

SELECT * FROM Students WHERE StudentID = 2;

-- bump every Science mark by 5, capped at 100
UPDATE Marks
SET Marks = LEAST(Marks + 5, 100)
WHERE Subject = 'Science';

SELECT s.Name, m.Subject, m.Marks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
WHERE m.Subject = 'Science'
ORDER BY m.Marks DESC;

-- remove the test student added earlier
-- (marks first, since Marks references Students)
DELETE FROM Marks WHERE StudentID = @NewStudentID;
DELETE FROM Students WHERE StudentID = @NewStudentID;

SELECT * FROM Students;

-- subqueries / window functions

-- students scoring above the overall average
SELECT DISTINCT s.StudentID, s.Name, s.Class
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
WHERE m.Marks > (SELECT AVG(Marks) FROM Marks)
ORDER BY s.Name;

-- second-highest mark and who got it, using DENSE_RANK instead of a
-- nested MAX() subquery — handles ties properly and reads a lot cleaner
WITH RankedMarks AS (
    SELECT s.Name, s.Class, m.Subject, m.Marks,
           DENSE_RANK() OVER (ORDER BY m.Marks DESC) AS Rnk
    FROM Students AS s
    JOIN Marks AS m ON s.StudentID = m.StudentID
)
SELECT Name, Class, Subject, Marks
FROM RankedMarks
WHERE Rnk = 2;

-- reports

-- grade per mark
SELECT
    s.StudentID, s.Name, s.Class, m.Subject, m.Marks,
    CASE
        WHEN m.Marks >= 90 THEN 'A+'
        WHEN m.Marks >= 80 THEN 'A'
        WHEN m.Marks >= 70 THEN 'B'
        WHEN m.Marks >= 60 THEN 'C'
        WHEN m.Marks >= 50 THEN 'D'
        ELSE 'Fail'
    END AS Grade
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
ORDER BY s.StudentID, m.Subject;

-- top 5 by average
SELECT
    s.StudentID, s.Name, s.Class,
    ROUND(AVG(m.Marks), 2) AS AverageMarks,
    SUM(m.Marks) AS TotalMarks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
GROUP BY s.StudentID, s.Name, s.Class
ORDER BY AverageMarks DESC
LIMIT 5;

-- topper per subject
SELECT m.Subject, s.Name AS TopperName, s.Class, m.Marks AS HighestMarks
FROM Marks AS m
JOIN Students AS s ON m.StudentID = s.StudentID
WHERE m.Marks = (
    SELECT MAX(m2.Marks) FROM Marks AS m2 WHERE m2.Subject = m.Subject
)
ORDER BY m.Subject;

-- city-wise summary
SELECT
    s.City,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    ROUND(AVG(m.Marks), 2) AS AverageMarks,
    MAX(m.Marks) AS HighestMarks,
    MIN(m.Marks) AS LowestMarks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
GROUP BY s.City
ORDER BY AverageMarks DESC;

-- class-wise summary
SELECT
    s.Class,
    COUNT(DISTINCT s.StudentID) AS TotalStudents,
    ROUND(AVG(m.Marks), 2) AS AverageMarks,
    SUM(m.Marks) AS TotalMarks
FROM Students AS s
JOIN Marks AS m ON s.StudentID = m.StudentID
GROUP BY s.Class
ORDER BY AverageMarks DESC;
