
CREATE TABLE employees_temp (
    emp_no INTEGER PRIMARY KEY,
    emp_title_id CHAR(5) NOT NULL,
    birth_date TEXT, 
    first_name VARCHAR(20) NOT NULL,
    last_name VARCHAR(20),
    sex CHAR(1) NOT NULL,
    hire_date TEXT NOT NULL,
    FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
);

INSERT INTO employees (emp_no, emp_title_id, birth_date, first_name, last_name, sex, hire_date)
SELECT 
	et.emp_no, 
	et.emp_title_id, 
	TO_DATE(et.birth_date, 'MM-DD-YYYY'),
	et.first_name, 
	et.last_name,
	et.sex,
	TO_DATE(et.hire_date, 'MM-DD-YYYY')
FROM employees_temp AS et;


SELECT * FROM employees;

DROP TABLE employees_temp;

