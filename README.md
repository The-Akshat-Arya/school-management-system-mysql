# School Management System – MySQL Project

## Project Overview

This project is a MySQL-based School Management System designed to store student information and subject-wise marks.

The database demonstrates relational database design and uses SQL queries to generate academic performance reports, identify top performers, calculate grades, and analyse student results by subject, city, and class.

## Database Structure

The project contains two related tables:

### Students

| Column | Description |
|---|---|
| StudentID | Unique ID for each student |
| Name | Student name |
| Class | Student class |
| Age | Student age |
| City | Student city |

### Marks

| Column | Description |
|---|---|
| MarkID | Unique ID for each marks record |
| StudentID | Connects marks with the student |
| Subject | Subject name |
| Marks | Marks obtained by the student |

The `StudentID` column creates a relationship between the `Students` and `Marks` tables.

## SQL Concepts Used

- Database creation
- Table creation
- Primary keys
- Foreign keys
- INSERT statements
- SELECT queries
- WHERE conditions
- ORDER BY
- Aggregate functions
- GROUP BY
- INNER JOIN
- UPDATE statements
- DELETE statements
- Subqueries
- CASE statements
- DISTINCT
- LIMIT

## Analysis Performed

The project includes queries for:

- Displaying student records
- Filtering students by city and age
- Sorting students alphabetically
- Counting total students
- Calculating average student age
- Finding maximum and minimum marks
- Calculating total Science marks
- Counting students city-wise
- Calculating subject-wise average marks
- Displaying student names with subjects and marks
- Finding students scoring above 80
- Finding the highest-scoring student
- Updating student information
- Increasing Science marks
- Deleting connected records
- Finding students above the overall average
- Finding the second-highest marks
- Generating student grades
- Finding top performers
- Generating subject-wise topper reports
- Analysing city-wise performance
- Analysing class-wise performance

## Grade Classification

| Marks Range | Grade |
|---|---|
| 90 and above | A+ |
| 80–89 | A |
| 70–79 | B |
| 60–69 | C |
| 50–59 | D |
| Below 50 | Fail |

## Project File

- `schooldb.sql` – Complete SQL script containing database creation, sample data, analysis queries, and reports

## Tools Used

- MySQL
- MySQL Workbench

## How to Run the Project

1. Download or clone this repository.
2. Open MySQL Workbench.
3. Open the `schooldb.sql` file.
4. Select the complete script.
5. Execute the script using the lightning icon.
6. Refresh the Schemas panel.
7. Open the `SchoolDB` database.
8. Run individual queries to view the results.

## Database Relationship

```text
Students
   |
   | StudentID
   |
Marks
