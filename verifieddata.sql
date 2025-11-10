SELECT * FROM employee_dropout;

SELECT district, COUNT(*) AS dropout_count
FROM employee_dropout
GROUP BY district;

SELECT employee_name, job_title, dropout_date
FROM employee_dropout;
