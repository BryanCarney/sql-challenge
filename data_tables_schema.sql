CREATE TABLE departments (
    dept_no CHAR(4) PRIMARY KEY,
    dept_name VARCHAR(100)
);

CREATE TABLE titles (
    title_id CHAR(5) PRIMARY KEY,
    title VARCHAR(20) NOT NULL
);

-- intial import of data was unsuccessful, once date parameters were reformatted the file was able to be loaded successfully
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
