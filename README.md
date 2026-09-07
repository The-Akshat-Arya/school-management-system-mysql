# School Management System – MySQL Project

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)

A small MySQL database for tracking students and their subject-wise marks — built to practice schema design, joins, subqueries, and a few reporting queries.

## Schema

**Students** — StudentID, Name, Class, Age, City
**Marks** — MarkID, StudentID, Subject, Marks

Each row in `Marks` links back to a student via `StudentID` (one-to-many). `Marks` also has a `CHECK (Marks BETWEEN 0 AND 100)` constraint so bad data can't sneak in.

## What's in the script

- Table creation with a primary/foreign key relationship and a CHECK constraint
- Sample data for 10 students across 3 subjects
- Basic selects, filters, and sorting
- Aggregates and GROUP BY (per-city, per-subject)
- Joins, including finding the single highest score and everyone above 80
- An UPDATE that caps values with `LEAST()`, and a FK-aware DELETE (marks before students)
- Subqueries for above-average performers
- A CTE + `DENSE_RANK()` for the second-highest mark — cleaner than nesting `MAX()` subqueries, and handles ties correctly
- Grade classification with `CASE`, plus top-5, subject-topper, city-wise, and class-wise reports

## Grade scale

| Marks | Grade |
|---|---|
| 90+ | A+ |
| 80–89 | A |
| 70–79 | B |
| 60–69 | C |
| 50–59 | D |
| Below 50 | Fail |

## Running it

1. Open `schooldb.sql` in MySQL Workbench (or any MySQL 8+ client).
2. Run the whole script — it drops/recreates `SchoolDB` from scratch.
3. Query results appear as each statement runs; scroll through or run sections individually to inspect specific reports.

## Author

**Akshat Arya**
📫 [akshatarya81@gmail.com](mailto:akshatarya81@gmail.com)
🔗 [LinkedIn](https://www.linkedin.com/in/akshat-arya-a6644740b) · [GitHub](https://github.com/The-Akshat-Arya)
