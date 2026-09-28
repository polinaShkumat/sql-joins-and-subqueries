-- =====================================================================
-- University Dining: analysing student meal-card swipes
-- Database: databases/university_dining.sqlite
-- Tables:   students, dorms, dining_halls, swipes
-- =====================================================================

-- Q1. How much did students from Einstein Hall spend in total at North Cafeteria?
SELECT ROUND(SUM(swipes.amount), 2) AS total_spent
FROM swipes
JOIN students     ON swipes.student_id = students.student_id
JOIN dorms        ON students.dorm_id  = dorms.dorm_id
JOIN dining_halls ON swipes.hall_id    = dining_halls.hall_id
WHERE dorms.dorm_name = 'Einstein Hall'
  AND dining_halls.hall_name = 'North Cafeteria';

-- Q2. How many different Einstein Hall students ate at North Cafeteria?
SELECT COUNT(DISTINCT students.student_id) AS students
FROM students
JOIN swipes       ON students.student_id = swipes.student_id
JOIN dining_halls ON swipes.hall_id      = dining_halls.hall_id
JOIN dorms        ON students.dorm_id    = dorms.dorm_id
WHERE dorms.dorm_name = 'Einstein Hall'
  AND dining_halls.hall_name = 'North Cafeteria';

-- Q3. Which Einstein Hall students have NEVER eaten at North Cafeteria?
SELECT students.full_name
FROM students
JOIN dorms ON students.dorm_id = dorms.dorm_id
WHERE dorms.dorm_name = 'Einstein Hall'
  AND students.student_id NOT IN (
      SELECT swipes.student_id
      FROM swipes
      JOIN dining_halls ON swipes.hall_id = dining_halls.hall_id
      WHERE dining_halls.hall_name = 'North Cafeteria'
  );

-- Q4. Which Marie Curie Quad students spend more per meal than the campus average?
SELECT students.full_name,
       ROUND(AVG(swipes.amount), 2) AS avg_meal_cost
FROM students
JOIN dorms  ON students.dorm_id    = dorms.dorm_id
JOIN swipes ON swipes.student_id   = students.student_id
WHERE dorms.dorm_name = 'Marie Curie Quad'
GROUP BY students.student_id, students.full_name
HAVING AVG(swipes.amount) > (SELECT AVG(amount) FROM swipes);
