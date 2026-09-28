# SQL: Joins and Subqueries

Analytical SQL queries on two SQLite databases: a **university dining** system (meal-card swipes) and a **company project allocation** system (employee timesheets). Every query answers a real business question using multi-table `JOIN`s, aggregation and subqueries.

## Databases

### University Dining

```mermaid
erDiagram
    DORMS ||--o{ STUDENTS : houses
    STUDENTS ||--o{ SWIPES : makes
    DINING_HALLS ||--o{ SWIPES : records
    DORMS { int dorm_id PK
            text dorm_name
            text address }
    STUDENTS { int student_id PK
               text full_name
               text email
               int dorm_id FK }
    DINING_HALLS { int hall_id PK
                   text hall_name
                   text address }
    SWIPES { int swipe_id PK
             int student_id FK
             int hall_id FK
             text swipe_time
             real amount }
```

### Project Allocation

```mermaid
erDiagram
    DEPARTMENTS ||--o{ EMPLOYEES : employs
    EMPLOYEES ||--o{ TIMESHEETS : logs
    PROJECTS ||--o{ TIMESHEETS : receives
    DEPARTMENTS { int dept_id PK
                  text dept_name
                  text office_floor }
    EMPLOYEES { int emp_id PK
                text full_name
                text email
                int dept_id FK }
    PROJECTS { int project_id PK
               text title
               text deadline_date }
    TIMESHEETS { int timesheet_id PK
                 int emp_id FK
                 int project_id FK
                 text work_date
                 real hours_spent
                 text assigned_role }
```

## Questions answered

| Database | Question | Techniques |
|---|---|---|
| Dining | Total spent by Einstein Hall students at North Cafeteria | 4-table `JOIN`, `SUM` |
| Dining | Number of distinct students who ate there | `COUNT(DISTINCT …)` |
| Dining | Students who **never** ate there | `NOT IN` subquery |
| Dining | Students spending above the campus average per meal | `GROUP BY` + `HAVING` with subquery |
| Projects | Hours the IT department spent on Cloud Migration | 4-table `JOIN`, `SUM` |
| Projects | Distinct R&D employees on Mobile App v2 | `COUNT(DISTINCT …)` |
| Projects | Marketing employees **not** on Global Marketing Drive | `NOT IN` subquery |
| Projects | Everyone on the project with the most logged hours | subquery with `ORDER BY … LIMIT 1` |

All queries are in [`queries/`](queries/).

## How to run

Open the `.sqlite` files in [DB Browser for SQLite](https://sqlitebrowser.org/) or DataGrip and paste a query, or run all of them at once with Python (standard library only):

```bash
python run_queries.py                      # all queries
python run_queries.py university_dining    # one database
```

## Example output

```
Q4. Which Marie Curie Quad students spend more per meal than the campus average?
  full_name  | avg_meal_cost
  -----------+--------------
  Mila Adams | 13.17
  (1 row)
```

## What I practised

Joining several tables through foreign keys, the difference between `WHERE` and `HAVING`, correlated vs. scalar subqueries, and finding "missing" records with `NOT IN`.
