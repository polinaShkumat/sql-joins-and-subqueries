-- =====================================================================
-- Project Allocation: analysing employee timesheets per project
-- Database: databases/project_allocation.sqlite
-- Tables:   employees, departments, projects, timesheets
-- =====================================================================

-- Q1. How many hours did the IT department spend on 'Cloud Migration'?
SELECT SUM(timesheets.hours_spent) AS total_hours
FROM timesheets
JOIN projects    ON timesheets.project_id = projects.project_id
JOIN employees   ON timesheets.emp_id     = employees.emp_id
JOIN departments ON employees.dept_id     = departments.dept_id
WHERE projects.title = 'Cloud Migration'
  AND departments.dept_name = 'Information Technology';

-- Q2. How many different R&D employees worked on 'Mobile App v2'?
SELECT COUNT(DISTINCT employees.emp_id) AS distinct_rd_employees
FROM timesheets
JOIN projects    ON timesheets.project_id = projects.project_id
JOIN employees   ON timesheets.emp_id     = employees.emp_id
JOIN departments ON employees.dept_id     = departments.dept_id
WHERE projects.title = 'Mobile App v2'
  AND departments.dept_name = 'Research & Development';

-- Q3. Which Marketing & Sales employees did NOT work on 'Global Marketing Drive'?
SELECT employees.full_name, employees.email
FROM employees
JOIN departments ON employees.dept_id = departments.dept_id
WHERE departments.dept_name = 'Marketing & Sales'
  AND employees.emp_id NOT IN (
      SELECT timesheets.emp_id
      FROM timesheets
      JOIN projects ON timesheets.project_id = projects.project_id
      WHERE projects.title = 'Global Marketing Drive'
  );

-- Q4. Who worked on the project with the most hours logged in total?
SELECT DISTINCT employees.full_name,
                employees.email,
                departments.dept_name
FROM timesheets
JOIN employees   ON timesheets.emp_id = employees.emp_id
JOIN departments ON employees.dept_id = departments.dept_id
WHERE timesheets.project_id = (
    SELECT project_id
    FROM timesheets
    GROUP BY project_id
    ORDER BY SUM(hours_spent) DESC
    LIMIT 1
)
ORDER BY employees.full_name;
