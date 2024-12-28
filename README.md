# sql-challenge

# Module 9 Challenge files

**.csv Files for Analysis**

[.csv Files](https://static.bc-edx.com/data/dl-1-2/m9/lms/starter/Starter_Code.zip)

**Data Reformatting**

[Data Reformatting.sql](https://github.com/BryanCarney/sql-challenge/blob/main/data_formatting.sql)

**Data Table Schema**

[Data_Tables_Schema.sql](https://github.com/BryanCarney/sql-challenge/blob/main/data_tables_schema.sql)

**Data Analysis**

[Data_Analysis.sql](https://github.com/BryanCarney/sql-challenge/blob/main/data_analysis.sql)

# Data Modeling

Using the CSV files, the below Entity Relationship Diagram was created to map out the relationships.

![image](https://github.com/user-attachments/assets/922b5ded-0c26-411d-8236-14859414197b)

![image](https://github.com/user-attachments/assets/322627d1-df84-43f2-a575-dfaa8df0fc0e)

# Data Engineering

Table Schema created for each of the six CSV files

    CREATE TABLE departments (
        dept_no CHAR(4) PRIMARY KEY,
        dept_name VARCHAR(100)
    );
    
    CREATE TABLE titles (
        title_id CHAR(5) PRIMARY KEY,
        title VARCHAR(20) NOT NULL
    );
    
    --intial import of data was unsuccessful, once date parameters were reformatted the file was able to be loaded successfully
    CREATE TABLE employees (
        emp_no INTEGER PRIMARY KEY,
        emp_title_id CHAR(5) NOT NULL,
        birth_date DATE, 
        first_name VARCHAR(20) NOT NULL,
        last_name VARCHAR(20),
        sex CHAR(1) NOT NULL,
        hire_date DATE NOT NULL,
        FOREIGN KEY (emp_title_id) REFERENCES titles(title_id)
    );
    
    CREATE TABLE dept_emp (
        emp_no INTEGER NOT NULL,
        dept_no CHAR(4) NOT NULL,
        PRIMARY KEY (emp_no, dept_no),
        FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
        FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
    );
    
    CREATE TABLE dept_manager (
        dept_no CHAR(4) NOT NULL,
        emp_no INTEGER NOT NULL,
        PRIMARY KEY (dept_no, emp_no),
        FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
        FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
    );
    
    CREATE TABLE salaries (
        emp_no INTEGER NOT NULL PRIMARY KEY, 
        salary INTEGER DEFAULT 0 CHECK (salary >= 0), 
        FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
    );

# Data Reformatting 

Due to formatting issues with importing the employees file, a temporary table was created in order to successfully import the data to reformat the date into the correct format. **This step was uncovered based on a question of data formatting asked during class**

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
    
    INSERT INTO employees (emp_no, emp_title_id, birth_date, first_name, last_name,sex,hire_date)
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

# Data Analysis

List the employee number, last name, first name, sex, and salary of each employee.

    SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
    FROM employees as e    	
    JOIN salaries as s ON e.emp_no = s.emp_no    
    ORDER BY e.emp_no;

![image](https://github.com/user-attachments/assets/552c8926-1c60-429c-b2ae-a93cdeb9ce76)

List the first name, last name, and hire date for the employees who were hired in 1986.

    SELECT first_name, last_name, hire_date
    FROM employees
    WHERE hire_date >= '1986-01-01' AND hire_date <= '1986-12-31'
    ORDER BY hire_date;

![image](https://github.com/user-attachments/assets/f4fccaa5-6b29-4516-bdab-ba265bd9f190)

List the manager of each department along with their department number, department name, employee number, last name, and first name.

    SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
    FROM departments as d
    	JOIN dept_manager as dm ON d.dept_no = dm.dept_no
    	JOIN employees as e ON dm.emp_no = e.emp_no
    ORDER BY d.dept_no;

![image](https://github.com/user-attachments/assets/4534dda8-85de-4b80-980e-1ff1b830ebbd)

List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

    SELECT e.emp_no, e.last_name, e.first_name, de.dept_no, d.dept_name
    FROM employees as e
    	JOIN dept_emp as de ON e.emp_no = de.emp_no
    	JOIN departments as d ON de.dept_no = d.dept_no
    ORDER BY e.emp_no;

![image](https://github.com/user-attachments/assets/70d2b6c6-bf7b-4b99-a0c0-896709e3c4df)

List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B.

    SELECT first_name, last_name, sex 
    FROM employees 
    WHERE 
    	first_name = 'Hercules'
    	AND
    	last_name LIKE 'B%'
    ORDER BY sex,last_name;

![image](https://github.com/user-attachments/assets/97f28d3f-2cd4-461d-95c8-b57b7632ba76)

List each employee in the Sales department, including their employee number, last name, and first name.

    SELECT e.emp_no, e.last_name, e.first_name
    FROM employees as e
    	JOIN dept_emp as de ON e.emp_no = de.emp_no
    	JOIN departments as d ON de.dept_no = d.dept_no
    		WHERE dept_name = 'Sales';

![image](https://github.com/user-attachments/assets/41b869a8-82fb-45f5-a62a-b8673c406258)

List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name.

    WITH sales_development as (SELECT * FROM departments as d
    WHERE dept_name IN ('Sales', 'Development')
    )
    SELECT e.emp_no, e.last_name, e.first_name, sd.dept_name
    FROM employees as e
    	JOIN dept_emp as de ON e.emp_no = de.emp_no
    	JOIN sales_development as sd ON de.dept_no = sd.dept_no
    ORDER BY dept_name;

![image](https://github.com/user-attachments/assets/bf0a71ba-e935-4015-9a65-55e3313ba4eb)

List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name).

    SELECT last_name, COUNT(last_name) as frequency_counts
    FROM employees 
    GROUP BY last_name
    ORDER BY frequency_counts DESC;

![image](https://github.com/user-attachments/assets/21c5c35b-d7da-4c3a-8c82-668b48d9dc6d)
