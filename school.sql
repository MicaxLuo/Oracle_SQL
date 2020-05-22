
----------------------------     Q1    --------------------------------
-- creates all tables, fields, constraints and relationships in the database

-- solutions:

--1a
CREATE TABLE Countries (
    countryCode VARCHAR(5) PRIMARY KEY,
    countryName VARCHAR(25),
    continent VARCHAR(15),
    isActive NUMBER(1)
);

CREATE TABLE Courses (
    courseCode VARCHAR(6) PRIMARY KEY,
    courseName VARCHAR(50) NOT NULL,
    isAvailable NUMBER(1) NOT NULL,
    termTaken NUMBER(1)
);

CREATE TABLE Departments (
    deptCode VARCHAR(5) PRIMARY KEY,
    deptName VARCHAR(100) NOT NULL,
    officeNumber VARCHAR(6) NOT NULL,
    displayOrder NUMBER(3)
);

CREATE TABLE Employees (
    empID NUMBER(10) PRIMARY KEY,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(30) NOT NULL,
    prefix VARCHAR(10),
    suffix VARCHAR(10),
    isActive NUMBER(1) NOT NULL,
    SIN VARCHAR(11) NOT NULL,
    DOB DATE NOT NULL,
    email VARCHAR(40) NOT NULL,
    phone VARCHAR(12) NOT NULL
);

CREATE TABLE Term (
    termCode VARCHAR(10) PRIMARY KEY,
    termName VARCHAR(20) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL
);

--1b
CREATE TABLE Advisors (
    empID NUMBER(10) PRIMARY KEY,
    isActive NUMBER(1) NOT NULL,
    CONSTRAINT Advisors_empID_fk FOREIGN KEY (empID) REFERENCES Employees(empID)
    );

CREATE TABLE Professors (
    empID NUMBER(10) PRIMARY KEY,
    deptCode VARCHAR(5) NOT NULL,
    isActive NUMBER(1) NOT NULL,
    CONSTRAINT Professors_empID_fk FOREIGN KEY (empID) REFERENCES Employees(empID),
    CONSTRAINT Professors_deptCode_fk FOREIGN KEY (deptCode) REFERENCES Departments(deptCode)
);

CREATE TABLE Programs (
    progCode VARCHAR(10) PRIMARY KEY,
    progName VARCHAR(70) NOT NULL,
    lengthYears NUMBER(2),
    isCurrent NUMBER(1) NOT NULL,
    deptCode VARCHAR(5) NOT NULL,
    CONSTRAINT Programs_deptCode_fk FOREIGN KEY (deptCode) REFERENCES Departments(deptCode)
);

--1c
CREATE TABLE Sections (
    sectionID VARCHAR(10) PRIMARY KEY,
    sectionLetter VARCHAR(20),
    courseCode VARCHAR(6),
    termCode VARCHAR(10),
    profID NUMBER(10),
    CONSTRAINT Sections_courseCode_fk FOREIGN KEY (courseCode) REFERENCES Courses(courseCode),
    CONSTRAINT Sections_termCode_fk FOREIGN KEY (termCode) REFERENCES Term(termCode),
    CONSTRAINT Sections_profID_fk FOREIGN KEY (profID) REFERENCES Professors(empID)
);

CREATE TABLE Students (
    studentID NUMBER(10) PRIMARY KEY,
    firstName VARCHAR(20) NOT NULL,
    lastName VARCHAR(20) NOT NULL,
    DOB DATE NOT NULL,
    gender VARCHAR(10),
    email VARCHAR(30) NOT NULL,
    homeCountry VARCHAR(5) NOT NULL,
    phone NUMBER(15) NOT NULL,
    advisorID NUMBER(10),
    CONSTRAINT Students_homeCountry_fk FOREIGN KEY (homeCountry) REFERENCES Countries(countryCode),
    CONSTRAINT Students_advisorID_fk FOREIGN KEY (advisorID) REFERENCES Advisors(empID) 
);

--1d
CREATE TABLE Jnc_Prog_Courses (
    progCourseID VARCHAR(10) PRIMARY KEY,
    progCode VARCHAR(10) NOT NULL,
    courseCode VARCHAR(6) NOT NULL,
    isActive NUMBER(1),
    CONSTRAINT JncProgCourses_progCode_fk FOREIGN KEY (progCode) REFERENCES Programs(progCode),
    CONSTRAINT JncProgCourses_courseCode_fk FOREIGN KEY (courseCode) REFERENCES Courses(courseCode)
);

CREATE TABLE Jnc_Prog_Students (
    progCode VARCHAR(10),
    studentID NUMBER(10),
    isActive NUMBER(1),
    PRIMARY KEY (progCode, studentID),
    CONSTRAINT JncProgStudents_progCode_fk FOREIGN KEY (progCode) REFERENCES Programs(progCode),
    CONSTRAINT JncProgStudents_studentID_fk FOREIGN KEY (studentID) REFERENCES Students(studentID)
);

CREATE TABLE Jnc_Students_Courses (
    courseCode VARCHAR(6),
    studentID NUMBER(10),
    isActive NUMBER(1),
    gradeObtained NUMBER(3,2),
    sectionID VARCHAR(10) NOT NULL,
    PRIMARY KEY (courseCode, studentID),
    CONSTRAINT JncStuCourses_courseCode_fk FOREIGN KEY (courseCode) REFERENCES Courses(courseCode),
    CONSTRAINT JncStuCourses_studentID_fk FOREIGN KEY (studentID) REFERENCES Students(studentID),
    CONSTRAINT JncStuCourses_sectionID_fk FOREIGN KEY (sectionID) REFERENCES Sections(sectionID),
    CONSTRAINT JncStuCourses_grade_chk CHECK (gradeObtained BETWEEN 0 AND 1)
);

GRANT ALL PRIVILEGES ON Advisors TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Countries TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Courses TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Departments TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Employees TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Jnc_prog_courses TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON jnc_prog_students TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON jnc_students_courses TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Professors TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Programs TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Sections TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Students TO db301_193a38, db301_1939, db301_193a06;
GRANT ALL PRIVILEGES ON Term TO db301_193a38, db301_1939, db301_193a06;


----------------------------     Q2    --------------------------------
-- contains insertion scripts for inserting their current program of study
-- For courses you have not yet taken, you may assign an unknown professor (i.e. add a professor named unknown)

-- solutions:
INSERT ALL -- countries
    INTO Countries VALUES ('CA', 'Canada', 'North America', 1)
    INTO Countries VALUES ('CN', 'China', 'Asia', 1)
    INTO Countries VALUES ('IL', 'Israel', 'Asia', 1)
    INTO Countries VALUES ('HU', 'Hungary', 'Europe', 1)
    INTO Countries VALUES ('BR', 'Brazil', 'South America', 1)
    SELECT 1 FROM dual;

INSERT ALL -- courses
    INTO Courses VALUES ('APC100', 'Applied Professional Communications', 1, 1)
    INTO Courses VALUES ('CPR101', 'Computer Principles for Programmers', 1, 1)
    INTO Courses VALUES ('COM101', 'Communicating Across Contexts', 1, 1)
    INTO Courses VALUES ('IPC144', 'Introduction to Programming Using C', 1, 1)
    INTO Courses VALUES ('ULI101', 'Introduction to UNIX/Linux and the Internet', 1, 1)
    INTO Courses VALUES ('db201', 'Introduction to Database Design and SQL', 1, 2)
    INTO Courses VALUES ('DCF255', 'Data Communications Fundamentals', 1, 2)
    INTO Courses VALUES ('OOP244', 'Introduction to Object Oriented Programming', 1, 2)
    INTO Courses VALUES ('WEB222', 'Web Programming Principles', 1, 2)
    INTO Courses VALUES ('NAT112', 'Physiology of Fitness', 1, 2)
    INTO Courses VALUES ('db301', 'Database Design II and SQL Using Oracle', 1, 3)
    INTO Courses VALUES ('SYS366', 'Requirements Gathering Using OO Models', 1, 3)
    INTO Courses VALUES ('WEB322', 'Web Programming Tools and Frameworks', 1, 3)
    INTO Courses VALUES ('LAN115', 'Conversational Spanish for Beginners', 1, 3)
    INTO Courses VALUES ('OOP345', 'Object-Oriented Software Development using C++', 1, 3)
    INTO Courses VALUES ('BCI433', 'IBM Business Computing', 1, 4)
    INTO Courses VALUES ('EAC397', 'Business Report Writing', 1, 4)
    INTO Courses VALUES ('JAC444', 'Introduction to Java for C++ Programmers', 1, 4)
    INTO Courses VALUES ('MAP524', 'Mobile App Development - Android', 1, 5)
    INTO Courses VALUES ('CAN230', 'Women in Canada', 1, 5)
    INTO Courses VALUES ('WTP100', 'Work Term Preparation', 1, 5)
    INTO Courses VALUES ('CPA331', 'Computer Programming and Analysis, Co-op', 1, 5)
    INTO Courses VALUES ('SYS466', 'Analysis and Design Using OO Models', 1, 5)
    INTO Courses VALUES ('WEB422', 'Web Programming for Apps and Services', 1, 5)
    INTO Courses VALUES ('CPA332', 'Computer Programming and Analysis, Co-op II', 1, 6)
    INTO Courses VALUES ('PRJ566', 'Project Planning and Management', 1, 6)
    INTO Courses VALUES ('NAT160', 'Natural Science: Nutrition', 1, 6)
    INTO Courses VALUES ('PRJ666', 'Project Implementation', 1, 6)
    INTO Courses VALUES ('CVI620', 'Computer Vision', 1, 6)
    INTO Courses VALUES ('DBA625', 'Database Administration', 1, 6)
    INTO Courses VALUES ('DBJ565', 'Database Connectivity Using Java', 1, 6)
    INTO Courses VALUES ('GPU610', 'Parallel Programming Fundamentals', 1, 6)
    INTO Courses VALUES ('ISP606', 'iSeries Practicum', 1, 6)
    INTO Courses VALUES ('WSA500', 'Web Services Architecture', 1, 6)
    INTO Courses VALUES ('BAC344', 'Business Applications Using COBOL', 1, 6)
    SELECT 1 FROM dual;

INSERT ALL -- departments
    INTO Departments VALUES ('ICT', 'School of Information and Communications Technology', 'A3058D', 1)
    INTO Departments VALUES ('AVI', 'School of Aviation', 'A3000', 1)
    INTO Departments VALUES ('BSC', 'School of Biological Sciences and Applied Chemistry', 'A4000', 1)
    INTO Departments VALUES ('EMT', 'School of Electronics and Mechanical Engineering Technology', 'A4001', 1)
    INTO Departments VALUES ('ECT', 'School of Environmental and Civil Engineering Technology', 'A4010', 1)
    INTO Departments VALUES ('FPT', 'School of Fire Protection Engineering Technology', 'A3038', 1)
    SELECT 1 FROM dual;

INSERT ALL -- employees
    INTO Employees VALUES (100, 'Clint', 'MacDonald', '', '', 1, 123456789, to_date('1970-08-15', 'yyyy-mm-dd'), 'clint.macdonald@info.ca', 2267892525)
    INTO Employees VALUES (101, 'Ron', 'Tarr', '', '', 1, 133445789, to_date('1966-02-05', 'yyyy-mm-dd'), 'rontarr@info.ca', 2264447777)
    INTO Employees VALUES (102, 'Robert', 'Stewart', '', '', 1, 122444555, to_date('1976-05-15', 'yyyy-mm-dd'), 'robertstu@info.ca', 2264448888)
    INTO Employees VALUES (103, 'Nebojsa', 'Conkic', '', '', 1, 456111222, to_date('1976-06-15', 'yyyy-mm-dd'), 'nebocon@info.ca', 2264447788)
    INTO Employees VALUES (104, 'Asam', 'Gulaid', '', '', 1, 122334555, to_date('1976-09-15', 'yyyy-mm-dd'), 'asamgu@info.ca', 2267548888)
    INTO Employees VALUES (105, 'Mahboob', 'Ali', '', '', 1, 122446555, to_date('1976-05-25', 'yyyy-mm-dd'), 'mabooha@info.ca', 2275448888)
    INTO Employees VALUES (106, 'Nathan', 'Misener', '', '', 1, 122442555, to_date('1976-05-18', 'yyyy-mm-dd'), 'nathanmis@info.ca', 2264446688)
    INTO Employees VALUES (107, 'Cindy', 'Laurin', '', '', 1, 122446355, to_date('1976-08-15', 'yyyy-mm-dd'), 'cindul@info.ca', 2264448888)
    INTO Employees VALUES (108, 'Marc', 'Gurwitz', '', '', 1, 122445255, to_date('1976-07-25', 'yyyy-mm-dd'), 'marcg@info.ca', 2264264888)
    INTO Employees VALUES (109, 'Stanley', 'Ukah', '', '', 1, 122445255, to_date('1976-02-15', 'yyyy-mm-dd'), 'stanluk@info.ca', 2264448888)
    INTO Employees VALUES (110, 'Mehrnaz', 'Zhian', '', '', 1, 122666555, to_date('1976-03-15', 'yyyy-mm-dd'), 'merzha@info.ca', 2264448888)
    INTO Employees VALUES (111, 'Kadeem', 'Best', '', '', 1, 122752555, to_date('1976-04-15', 'yyyy-mm-dd'), 'kadeembe@info.ca', 2264448888)
    INTO Employees VALUES (112, 'James', 'Mwangi', '', '', 1, 122412355, to_date('1986-08-15', 'yyyy-mm-dd'), 'jamesmw@info.ca', 2264448888)
    INTO Employees VALUES (113, 'Nour', 'Hossain', 'Md', '', 1, 122478955, to_date('1996-05-12', 'yyyy-mm-dd'), 'nourho@info.ca', 2264447558)
    INTO Employees VALUES (114, 'Patrick', 'Crawford', '', '', 1, 122445655, to_date('1990-05-14', 'yyyy-mm-dd'), 'patrickc@info.ca', 2264448444)
    INTO Employees VALUES (115, 'Adriana', 'Neil', '', '', 1, 124224555, to_date('1987-05-15', 'yyyy-mm-dd'), 'adriann@info.ca', 2264448888)
    INTO Employees VALUES (116, 'Ryan', 'OConnor', '', '', 1, 122415655, to_date('1989-05-18', 'yyyy-mm-dd'), 'ryanco@info.ca', 2264448958)
    INTO Employees VALUES (117, 'Mary', 'Saith', '', '', 1, 122475555, to_date('1988-05-19', 'yyyy-mm-dd'), 'marysa@info.ca', 2264444568)
    INTO Employees VALUES (118, 'Ian', 'Tipson', '', '', 1, 124525655, to_date('1975-05-18', 'yyyy-mm-dd'), 'iantio@info.ca', 2267858958)
    INTO Employees VALUES (200, 'Trice', 'Brangman', '', '', 1, 122778555, to_date('1969-05-19', 'yyyy-mm-dd'), 'tricebra@info.ca', 2262754568)
    INTO Employees VALUES (201, 'Lisa', 'Ballantyne', '', '', 1, 9774309319, to_date('1972-01-27', 'yyyy-mm-dd'), 'lisa.ballantyne@info.ca', 4433385584)
    INTO Employees VALUES (202, 'Julie', 'Berns', '', '', 1, 1741406073, to_date('1965-07-14', 'yyyy-mm-dd'), 'julie.berns@info.ca', 6439622579)
    INTO Employees VALUES (203, 'Betrice', 'Brangman', '', '', 1, 4040376356, to_date('1976-11-05',  'yyyy-mm-dd'), 'betrice.brangman@info.ca', 4400997704)
    INTO Employees VALUES (204, 'Alexandra', 'Burke', '', '', 1, 4196241922, to_date('1972-07-22', 'yyyy-mm-dd'), 'alexandra.burke@info.ca', 1495753288)
    INTO Employees VALUES (205, 'Joel', 'Colesberry', '', '', 1, 9627863231, to_date('1974-09-21', 'yyyy-mm-dd'), 'joel.colesberry@info.ca', 8896658465)
    INTO Employees VALUES (206, 'Nick', 'Crandell', '', '', 1, 3681980943, to_date('1977-09-26', 'yyyy-mm-dd'), 'nick.crandell@info.ca', 6116353899)
    INTO Employees VALUES (207, 'Lisa', 'Dalla-Zuanna', '', '', 1, 8327377574, to_date('1978-11-06', 'yyyy-mm-dd'), 'lisa.dalla-zuanna@info.ca', 1562892641)
    INTO Employees VALUES (208, 'Nicola', 'Fillier', '', '', 1, 5571346228, to_date('1966-04-18', 'yyyy-mm-dd'), 'nicola.fillier@info.ca', 6413770609)
    INTO Employees VALUES (300, 'Unknown', 'Unknown', '', '', 1, 111111111, '1999-01-01', 'unknown', 1111111111)
    SELECT 1 FROM dual;

INSERT ALL -- term
    INTO Term VALUES ('F2018', 'Fall 2018', to_date('2018-09-03','yyyy-mm-dd'), to_date('2018-12-13','yyyy-mm-dd'))
    INTO Term VALUES ('W2019', 'Winter 2019', to_date('2019-01-03','yyyy-mm-dd'), to_date('2019-04-13','yyyy-mm-dd'))
    INTO Term VALUES ('S2019', 'Summer 2019', to_date('2019-05-23','yyyy-mm-dd'), to_date('2019-08-29','yyyy-mm-dd'))
    INTO Term VALUES ('F2019', 'Fall 2019', to_date('2019-09-03','yyyy-mm-dd'),to_date('2019-12-13','yyyy-mm-dd'))
    INTO Term VALUES ('W2020', 'Winter 2020', to_date('2020-01-03','yyyy-mm-dd'), to_date('2020-04-13','yyyy-mm-dd'))
    INTO Term VALUES ('S2020', 'Summer 2020', to_date('2020-05-23','yyyy-mm-dd'), to_date('2020-08-29','yyyy-mm-dd'))
    INTO Term VALUES ('F2020', 'Fall 2020', to_date('2020-09-03','yyyy-mm-dd'), to_date('2020-12-13','yyyy-mm-dd'))
    INTO Term VALUES ('W2021', 'Winter 2021', to_date('2021-01-03','yyyy-mm-dd'), to_date('2021-04-13','yyyy-mm-dd'))
    INTO Term VALUES ('S2021', 'Summer 2021', to_date('2021-05-23','yyyy-mm-dd'), to_date('2021-08-29','yyyy-mm-dd'))
    SELECT 1 FROM dual;

        
INSERT ALL -- advisors
    INTO Advisors VALUES (200, 1)
    INTO Advisors VALUES (201, 1)
    INTO Advisors VALUES (202, 1)
    INTO Advisors VALUES (203, 1)
    INTO Advisors VALUES (204, 1)
    INTO Advisors VALUES (205, 1)
    INTO Advisors VALUES (206, 1)
    INTO Advisors VALUES (207, 1)
    INTO Advisors VALUES (208, 1)
    SELECT 1 FROM dual;


INSERT ALL -- profs
    INTO Professors VALUES (100, 'ICT', 1)
    INTO Professors VALUES (101, 'ICT', 1)
    INTO Professors VALUES (102, 'ICT', 1)
    INTO Professors VALUES (103, 'ICT', 1)
    INTO Professors VALUES (104, 'ICT', 1)
    INTO Professors VALUES (105, 'ICT', 1)
    INTO Professors VALUES (106, 'ICT', 1)
    INTO Professors VALUES (107, 'ICT', 1)
    INTO Professors VALUES (108, 'ICT', 1)
    INTO Professors VALUES (109, 'ICT', 1)
    INTO Professors VALUES (110, 'ICT', 1)
    INTO Professors VALUES (111, 'ICT', 1)
    INTO Professors VALUES (112, 'ICT', 1)
    INTO Professors VALUES (113, 'ICT', 1)
    INTO Professors VALUES (114, 'ICT', 1)
    INTO Professors VALUES (115, 'ICT', 1)
    INTO Professors VALUES (116, 'ICT', 1)
    INTO Professors VALUES (117, 'ICT', 1)
    INTO Professors VALUES (118, 'ICT', 1)
    INTO Professors VALUES (300, 'ICT', 1)
    SELECT 1 FROM dual;
    
INSERT ALL -- programs
    INTO Programs VALUES ('CPD', 'Computer Programmer', 2, 1, 'ICT')
    INTO Programs VALUES ('CPA', 'Computer Programming and Analysis', 3, 1,'ICT')
    INTO Programs VALUES ('BSD', 'Honours Bachelor of Technology - Software Development', 4, 1,'ICT')
    SELECT 1 FROM dual;
    
INSERT ALL -- sections
    INTO Sections VALUES('19000', 'NAA', 'APC100', 'W2019', 100)
    INTO Sections VALUES('19001', 'NAB', 'APC100', 'W2019', 101)
    INTO Sections VALUES('19002', 'NAA', 'BAC344', 'W2021', 102)
    INTO Sections VALUES('19003', 'NAB', 'BAC344', 'W2021', 103)
    INTO Sections VALUES('19004', 'NAA', 'BCI433', 'W2020', 104)
    INTO Sections VALUES('19005', 'NAB', 'BCI433', 'W2020', 103)
    INTO Sections VALUES('19006', 'NAA', 'CAN230', 'W2020', 105)   
    INTO Sections VALUES('19007', 'NAB', 'CAN230', 'W2020', 106)
    INTO Sections VALUES('19008', 'NAA', 'COM101', 'W2019', 107)
    INTO Sections VALUES('19009', 'NAB', 'COM101', 'W2019', 108)
    INTO Sections VALUES('19010', 'NAA', 'CPA331', 'S2020', 108)
    INTO Sections VALUES('19011', 'NAB', 'CPA331', 'S2020', 109)
    INTO Sections VALUES('19012', 'NAA', 'CPA332', 'S2020', 110)
    INTO Sections VALUES('19013', 'NAB', 'CPA332', 'S2020', 111)
    INTO Sections VALUES('19014', 'NAA', 'CPR101', 'W2019', 114)
    INTO Sections VALUES('19015', 'NAB', 'CPR101', 'W2019', 115)
    INTO Sections VALUES('19016', 'NAA', 'CVI620', 'F2020', 118)
    INTO Sections VALUES('19017', 'NAB', 'CVI620', 'F2020', 109)
    INTO Sections VALUES('19018', 'NAA', 'DBA625', 'F2020', 101)
    INTO Sections VALUES('19019', 'NAB', 'DBA625', 'F2020', 101)
    INTO Sections VALUES('19020', 'NAA', 'DBJ565', 'W2021', 103)
    INTO Sections VALUES('19021', 'NAB', 'DBJ565', 'W2021', 111)
    INTO Sections VALUES('19022', 'NAC', 'db201', 'S2019', 110)
    INTO Sections VALUES('19023', 'NAD', 'db201', 'S2019', 101)
    INTO Sections VALUES('19024', 'NAA', 'db301', 'F2019', 100)
    INTO Sections VALUES('19025', 'NAB', 'db301', 'F2019', 101)
    INTO Sections VALUES('19026', 'NAC', 'db301', 'F2019', 102)
    INTO Sections VALUES('19027', 'NAA', 'db301', 'F2019', 103)
    INTO Sections VALUES('19028', 'NAB', 'DCF255', 'S2019', 110)
    INTO Sections VALUES('19029', 'NAC', 'DCF255', 'S2019', 111)
    INTO Sections VALUES('19030', 'NAD', 'EAC397', 'W2020', 112)
    INTO Sections VALUES('19031', 'NAA', 'EAC397', 'W2020', 113)
    INTO Sections VALUES('19032', 'NAB', 'GPU610', 'W2021', 112)
    INTO Sections VALUES('19033', 'NAC', 'GPU610', 'W2021', 113)
    INTO Sections VALUES('19034', 'NAD', 'IPC144', 'W2019', 116)
    INTO Sections VALUES('19035', 'NAE', 'IPC144', 'W2019', 117)
    INTO Sections VALUES('19036', 'NAD', 'ISP606', 'W2021', 112)
    INTO Sections VALUES('19037', 'NAB', 'ISP606', 'W2021', 113)
    INTO Sections VALUES('19038', 'NAD', 'JAC444', 'W2020', 114)
    INTO Sections VALUES('19039', 'NAA', 'JAC444', 'W2020', 115)
    INTO Sections VALUES('20000', 'NAA', 'LAN115', 'F2019', 117)
    INTO Sections VALUES('20001', 'NAB', 'LAN115', 'F2019', 118)
    INTO Sections VALUES('20002', 'NAA', 'MAP524', 'W2020', 116)
    INTO Sections VALUES('20003', 'NAB', 'MAP524', 'W2020', 117)
    INTO Sections VALUES('20004', 'NAA', 'NAT112', 'S2019', 112)
    INTO Sections VALUES('20005', 'NAB', 'NAT112', 'S2019', 113)
    INTO Sections VALUES('20006', 'NAA', 'NAT160', 'F2020', 112)
    INTO Sections VALUES('20007', 'NAB', 'NAT160', 'F2020', 113)
    INTO Sections VALUES('20008', 'NAA', 'OOP244', 'S2019', 104)
    INTO Sections VALUES('20009', 'NAB', 'OOP244', 'S2019', 105)  
    INTO Sections VALUES('20010', 'NAA', 'OOP345', 'F2019', 104)
    INTO Sections VALUES('20011', 'NAB', 'OOP345', 'F2019', 105)
    INTO Sections VALUES('20012', 'NAA', 'OOP345', 'F2019', 106)
    INTO Sections VALUES('20013', 'NAB', 'PRJ566', 'F2020', 112)
    INTO Sections VALUES('20014', 'NAA', 'PRJ566', 'F2020', 113)
    INTO Sections VALUES('20015', 'NAB', 'PRJ666', 'F2020', 108)
    INTO Sections VALUES('20016', 'NAA', 'PRJ666', 'F2020', 110)
    INTO Sections VALUES('20017', 'NAB', 'SYS366', 'F2019', 107)
    INTO Sections VALUES('20018', 'NAA', 'SYS366', 'F2019', 108)
    INTO Sections VALUES('20019', 'NAB', 'SYS366', 'F2019', 109)
    INTO Sections VALUES('20020', 'NAA', 'SYS366', 'F2019', 110)
    INTO Sections VALUES('20021', 'NAB', 'SYS466', 'S2020', 112)
    INTO Sections VALUES('20022', 'NAA', 'SYS466', 'S2020', 113)
    INTO Sections VALUES('20023', 'NAB', 'ULI101', 'W2019', 108)
    INTO Sections VALUES('20024', 'NAA', 'ULI101', 'W2019', 109)
    INTO Sections VALUES('20025', 'NAB', 'WEB222', 'S2019', 112)
    INTO Sections VALUES('20026', 'NAA', 'WEB222', 'S2019', 113)
    INTO Sections VALUES('20027', 'NAB', 'WEB322', 'F2019', 111)
    INTO Sections VALUES('20028', 'NAA', 'WEB322', 'F2019', 112)
    INTO Sections VALUES('20029', 'NAB', 'WEB322', 'F2019', 113)
    INTO Sections VALUES('21000', 'NAA', 'WEB322', 'F2019', 114)
    INTO Sections VALUES('21001', 'NAB', 'WEB322', 'F2019', 115)
    INTO Sections VALUES('21002', 'NAA', 'WEB322', 'F2019', 116)
    INTO Sections VALUES('21003', 'NAB', 'WEB422', 'S2020', 112)
    INTO Sections VALUES('21004', 'NAA', 'WEB422', 'S2020', 113)
    INTO Sections VALUES('21005', 'NAB', 'WSA500', 'W2021', 109)
    INTO Sections VALUES('21006', 'NAA', 'WSA500', 'W2021', 110)
    INTO Sections VALUES('21007', 'NAB', 'WTP100', 'F2019', 109)
    INTO Sections VALUES('21008', 'NAA', 'WTP100', 'S2020', 109)
    INTO Sections VALUES('21009', 'NAB', 'WTP100', 'S2020', 300)
    SELECT 1 FROM dual;
    
INSERT ALL -- students
    INTO Students VALUES (133777555, 'amy', 'yang', to_date('1996-01-01', 'YYYY-MM-DD'), 'female', 'xluo23@info.ca', 'CA', 2266554545, 200)
    INTO Students VALUES (119409183, 'gee', 'si', to_date('1986-12-13', 'YYYY-MM-DD'), 'male', 'si-gee@info.ca', 'BR', 2266886551, 200)
    INTO Students VALUES (126482181, 'Mark', 'mar', to_date('1988-10-18', 'YYYY-MM-DD'), 'male', 'marm@gmail.com', 'HU', 6471234567, 200)
    INTO Students VALUES (134435189, 'Gwen', 'bash', to_date('1999-05-05', 'YYYY-MM-DD'), 'male', 'gweb@gmail.com', 'IL', 4679876542, 200)
    SELECT 1 FROM dual;

INSERT ALL -- jnc prog courses
    INTO Jnc_Prog_Courses VALUES ('A100', 'CPD', 'APC100', 1)
    INTO Jnc_Prog_Courses VALUES ('A101', 'CPD', 'CPR101', 1)
    INTO Jnc_Prog_Courses VALUES ('A102', 'CPD', 'COM101', 1)
    INTO Jnc_Prog_Courses VALUES ('A103', 'CPD', 'IPC144', 1)
    INTO Jnc_Prog_Courses VALUES ('A104', 'CPD', 'ULI101', 1)
    INTO Jnc_Prog_Courses VALUES ('A105', 'CPD', 'db201', 1)
    INTO Jnc_Prog_Courses VALUES ('A106', 'CPD', 'DCF255', 1)
    INTO Jnc_Prog_Courses VALUES ('A107', 'CPD', 'OOP244', 1)
    INTO Jnc_Prog_Courses VALUES ('A108', 'CPD', 'WEB222', 1)
    INTO Jnc_Prog_Courses VALUES ('A109', 'CPD', 'NAT112', 1)
    INTO Jnc_Prog_Courses VALUES ('A110', 'CPD', 'db301', 1)
    INTO Jnc_Prog_Courses VALUES ('A111', 'CPD', 'OOP345', 1)
    INTO Jnc_Prog_Courses VALUES ('A112', 'CPD', 'SYS366', 1)
    INTO Jnc_Prog_Courses VALUES ('A113', 'CPD', 'WEB322', 1)
    INTO Jnc_Prog_Courses VALUES ('A114', 'CPD', 'LAN115', 1)
    INTO Jnc_Prog_Courses VALUES ('A115', 'CPD', 'BCI433', 1)
    INTO Jnc_Prog_Courses VALUES ('A116', 'CPD', 'EAC397', 1)
    INTO Jnc_Prog_Courses VALUES ('A117', 'CPD', 'JAC444', 1)
    INTO Jnc_Prog_Courses VALUES ('A118', 'CPD', 'MAP524', 1)
    INTO Jnc_Prog_Courses VALUES ('A119', 'CPD', 'CAN230', 1)
    INTO Jnc_Prog_Courses VALUES ('00', 'CPA', 'APC100', 1)
    INTO Jnc_Prog_Courses VALUES ('01', 'CPA', 'CPR101', 1)
    INTO Jnc_Prog_Courses VALUES ('02', 'CPA', 'COM101', 1)
    INTO Jnc_Prog_Courses VALUES ('03', 'CPA', 'IPC144', 1)
    INTO Jnc_Prog_Courses VALUES ('04', 'CPA', 'ULI101', 1)
    INTO Jnc_Prog_Courses VALUES ('05', 'CPA', 'db201', 1)
    INTO Jnc_Prog_Courses VALUES ('06', 'CPA', 'DCF255', 1)
    INTO Jnc_Prog_Courses VALUES ('07', 'CPA', 'OOP244', 1)
    INTO Jnc_Prog_Courses VALUES ('08', 'CPA', 'WEB222', 1)
    INTO Jnc_Prog_Courses VALUES ('09', 'CPA', 'NAT112', 1)
    INTO Jnc_Prog_Courses VALUES ('10', 'CPA', 'db301', 1)
    INTO Jnc_Prog_Courses VALUES ('11', 'CPA', 'OOP345', 1)
    INTO Jnc_Prog_Courses VALUES ('12', 'CPA', 'SYS366', 1)
    INTO Jnc_Prog_Courses VALUES ('13', 'CPA', 'WEB322', 1)
    INTO Jnc_Prog_Courses VALUES ('14', 'CPA', 'LAN115', 1)
    INTO Jnc_Prog_Courses VALUES ('15', 'CPA', 'BCI433', 1)
    INTO Jnc_Prog_Courses VALUES ('16', 'CPA', 'EAC397', 1)
    INTO Jnc_Prog_Courses VALUES ('17', 'CPA', 'JAC444', 1)
    INTO Jnc_Prog_Courses VALUES ('18', 'CPA', 'MAP524', 1)
    INTO Jnc_Prog_Courses VALUES ('19', 'CPA', 'CAN230', 1)
    INTO Jnc_Prog_Courses VALUES ('20', 'CPA', 'WTP100', 1)
    INTO Jnc_Prog_Courses VALUES ('21', 'CPA', 'CPA331', 1)
    INTO Jnc_Prog_Courses VALUES ('22', 'CPA', 'SYS466', 1)
    INTO Jnc_Prog_Courses VALUES ('23', 'CPA', 'WEB422', 1)
    INTO Jnc_Prog_Courses VALUES ('24', 'CPA', 'CPA332', 1)
    INTO Jnc_Prog_Courses VALUES ('25', 'CPA', 'PRJ566', 1)
    INTO Jnc_Prog_Courses VALUES ('26', 'CPA', 'NAT160', 1)
    INTO Jnc_Prog_Courses VALUES ('27', 'CPA', 'PRJ666', 1)
    INTO Jnc_Prog_Courses VALUES ('28', 'CPA', 'CVI620', 1)
    INTO Jnc_Prog_Courses VALUES ('29', 'CPA', 'DBA625', 1)
    INTO Jnc_Prog_Courses VALUES ('30', 'CPA', 'DBJ565', 1)
    INTO Jnc_Prog_Courses VALUES ('31', 'CPA', 'GPU610', 1)
    INTO Jnc_Prog_Courses VALUES ('32', 'CPA', 'ISP606', 1)
    INTO Jnc_Prog_Courses VALUES ('33', 'CPA', 'WSA500', 1)
    INTO Jnc_Prog_Courses VALUES ('34', 'CPA', 'BAC344', 1)
    SELECT 1 FROM dual;
    
INSERT ALL -- JNC STUDENT COURSES
    INTO Jnc_Students_Courses VALUES ('APC100', 119409183, 0, 0.99, 19000)
    INTO Jnc_Students_Courses VALUES ('CPR101', 119409183, 0, 0.97, 19015)
    INTO Jnc_Students_Courses VALUES ('COM101', 119409183, 0, 0.95, 19008)
    INTO Jnc_Students_Courses VALUES ('IPC144', 119409183, 0, 0.99, 19035)
    INTO Jnc_Students_Courses VALUES ('ULI101', 119409183, 0, 0.81, 20024)
    INTO Jnc_Students_Courses VALUES ('db301', 119409183, 0, 0.87, 19026)
    INTO Jnc_Students_Courses VALUES ('DCF255', 119409183, 0, 0.97, 19029)
    INTO Jnc_Students_Courses VALUES ('OOP244', 119409183, 0, 0.82, 20008)
    INTO Jnc_Students_Courses VALUES ('WEB222', 119409183, 0, 0.97, 20026)
    INTO Jnc_Students_Courses VALUES ('NAT112', 119409183, 0, 0.88, 20005)
    INTO Jnc_Students_Courses VALUES ('db301', 119409183, 1, 0.83, 19025)
    INTO Jnc_Students_Courses VALUES ('OOP345', 119409183, 1, 0.91, 20011)
    INTO Jnc_Students_Courses VALUES ('SYS466', 119409183, 1, 0.95, 20022)
    INTO Jnc_Students_Courses VALUES ('WEB322', 119409183, 1, 0.84, 21002)
    INTO Jnc_Students_Courses VALUES ('LAN115', 119409183, 0, 0.82, 20000)
    INTO Jnc_Students_Courses VALUES ('APC100', 133777555, 0, 0.99, 19000)
    INTO Jnc_Students_Courses VALUES ('CPR101', 133777555, 0, 0.97, 19015)
    INTO Jnc_Students_Courses VALUES ('COM101', 133777555, 0, 0.95, 19008)
    INTO Jnc_Students_Courses VALUES ('IPC144', 133777555, 0, 0.99, 19035)
    INTO Jnc_Students_Courses VALUES ('ULI101', 133777555, 0, 0.81, 20024)
    INTO Jnc_Students_Courses VALUES ('db301', 133777555, 0, 0.87, 19026)
    INTO Jnc_Students_Courses VALUES ('DCF255', 133777555, 0, 0.97, 19029)
    INTO Jnc_Students_Courses VALUES ('OOP244', 133777555, 0, 0.82, 20008)
    INTO Jnc_Students_Courses VALUES ('WEB222', 133777555, 0, 0.85, 20026)
    INTO Jnc_Students_Courses VALUES ('NAT112', 133777555, 0, 0.88, 20005)
    INTO Jnc_Students_Courses VALUES ('db301', 133777555, 1, 0.90, 19025)
    INTO Jnc_Students_Courses VALUES ('OOP345', 133777555, 1, 0.91, 20011)
    INTO Jnc_Students_Courses VALUES ('SYS466', 133777555, 1, 0.95, 20022)
    INTO Jnc_Students_Courses VALUES ('WEB322', 133777555, 1, 0.84, 21002)
    INTO Jnc_Students_Courses VALUES ('LAN115', 133777555, 0, 0.82, 20000)
    INTO Jnc_Students_Courses VALUES ('APC100', 126482181, 0, 0.79, 19000)
    INTO Jnc_Students_Courses VALUES ('CPR101', 126482181, 0, 0.97, 19015)
    INTO Jnc_Students_Courses VALUES ('COM101', 126482181, 0, 0.95, 19008)
    INTO Jnc_Students_Courses VALUES ('IPC144', 126482181, 0, 0.99, 19035)
    INTO Jnc_Students_Courses VALUES ('ULI101', 126482181, 0, 0.81, 20024)
    INTO Jnc_Students_Courses VALUES ('db301', 126482181, 0, 0.87, 19026)
    INTO Jnc_Students_Courses VALUES ('DCF255', 126482181, 0, 0.97, 19029)
    INTO Jnc_Students_Courses VALUES ('OOP244', 126482181, 0, 0.82, 20008)
    INTO Jnc_Students_Courses VALUES ('WEB222', 126482181, 0, 0.85, 20026)
    INTO Jnc_Students_Courses VALUES ('NAT112', 126482181, 0, 0.88, 20005)
    INTO Jnc_Students_Courses VALUES ('db301', 126482181, 1, 0.83, 19025)
    INTO Jnc_Students_Courses VALUES ('OOP345', 126482181, 1, 0.91, 20011)
    INTO Jnc_Students_Courses VALUES ('SYS466', 126482181, 1, 0.95, 20022)
    INTO Jnc_Students_Courses VALUES ('WEB322', 126482181, 1, 0.84, 21002)
    INTO Jnc_Students_Courses VALUES ('LAN115', 126482181, 0, 0.82, 20000)
    INTO Jnc_Students_Courses VALUES ('APC100', 134435189, 0, 0.99, 19000)
    INTO Jnc_Students_Courses VALUES ('CPR101', 134435189, 0, 0.97, 19015)
    INTO Jnc_Students_Courses VALUES ('COM101', 134435189, 0, 0.84, 19008)
    INTO Jnc_Students_Courses VALUES ('IPC144', 134435189, 0, 0.99, 19035)
    INTO Jnc_Students_Courses VALUES ('ULI101', 134435189, 0, 0.81, 20024)
    INTO Jnc_Students_Courses VALUES ('db301', 134435189, 0, 0.94, 19026)
    INTO Jnc_Students_Courses VALUES ('DCF255', 134435189, 0, 0.97, 19029)
    INTO Jnc_Students_Courses VALUES ('OOP244', 134435189, 0, 1.00, 20008)
    INTO Jnc_Students_Courses VALUES ('WEB222', 134435189, 0, 0.85, 20026)
    INTO Jnc_Students_Courses VALUES ('NAT112', 134435189, 0, 0.88, 20005)
    INTO Jnc_Students_Courses VALUES ('db301', 134435189, 1, 0.83, 19025)
    INTO Jnc_Students_Courses VALUES ('OOP345', 134435189, 1, 0.91, 20011)
    INTO Jnc_Students_Courses VALUES ('SYS466', 134435189, 1, 0.96, 20022)
    INTO Jnc_Students_Courses VALUES ('WEB322', 134435189, 1, 0.84, 21002)
    INTO Jnc_Students_Courses VALUES ('LAN115', 134435189, 0, 0.82, 20000)
    SELECT 1 FROM dual;

INSERT ALL -- JNC PROG STUDENTS
    INTO Jnc_Prog_Students VALUES ('CPA', 119409183, 1)
    INTO Jnc_Prog_Students VALUES ('CPD', 133777555, 1)
    INTO Jnc_Prog_Students VALUES ('CPA', 126482181, 1)
    INTO Jnc_Prog_Students VALUES ('CPD', 134435189, 1)
    SELECT 1 FROM dual;


----------------------------     Q3    --------------------------------
-- Create individual views that will produce:
-- i.	A student transcript that contains all the courses taken and the marks obtained for each student
-- ii.	A Class list for students enrolled in a particular course section
-- iii.	The average mark for each section and the professor whom instructed it
-- iv.	An output of all the courses required for each program sorted by program name and the term required.
-- v.	A term specific list of which professors are teaching which courses and how many students are enrolled in each course 
--      section.  Remember that professors can teach more than one section of the same course each term.

-- solutions:

-- i
CREATE OR REPLACE VIEW vwStudentTranscript AS (
    SELECT studentid, firstname, lastname, coursecode, gradeobtained
        FROM Students JOIN JNC_Students_courses USING(studentid) 
);
SELECT * FROM vwStudentTranscript;

-- ii
CREATE OR REPLACE VIEW vwClassList AS (
    SELECT s.sectionid, sectionletter, s.coursecode, st.studentid, firstname, lastname
        FROM sections s JOIN courses c ON (s.coursecode = c.coursecode)
            JOIN jnc_students_courses sc ON (s.sectionid = sc.sectionid)
            JOIN students st ON (st.studentid = sc.studentid)
        WHERE s.sectionletter LIKE upper('&sectionLetter') AND s.courseCode LIKE upper('&courseCode')
);
SELECT * FROM vwClassList;

-- iii
CREATE OR REPLACE VIEW vwSectionAvg AS (
    SELECT sectionLetter AS "Section", sc.courseCode AS "Course", sc.sectionID, firstName || ' ' || lastName AS "Professor" , avg(sc.gradeObtained) * 100 AS "Average Grade"
    FROM Sections s JOIN Professors ON (empId = profId ) JOIN Employees USING (empId)
    JOIN Jnc_Students_Courses sc ON ( sc.sectionId = s.sectionId AND sc.courseCode = s.courseCode)
    GROUP BY sectionLetter,sc.courseCode,sc.sectionID,firstName,lastName) ;

SELECT * FROM vwSectionAvg;


-- iv
CREATE OR REPLACE VIEW vwProgramCourses AS (
    SELECT progname, coursecode, coursename, termname 
        FROM (
            SELECT DISTINCT p.progcode, p.progname, c.coursecode, c.coursename, t.termname, startdate
                FROM programs p JOIN jnc_prog_courses pc ON (p.progcode = pc.progcode)
                    JOIN courses c ON (pc.coursecode = c.coursecode)
                    JOIN sections s ON (c.coursecode = s.coursecode)
                    JOIN term t ON (s.termcode = t.termcode)
        )
) ORDER BY progName;
SELECT * FROM vwProgramCourses;

-- v
CREATE OR REPLACE VIEW vwTermInfo AS (
    SELECT termname, coursecode, professor, coursename, sectionID, count(studentid) AS number_students
        FROM (
            SELECT s.termcode, termname, firstname ||' '|| lastname AS professor, s.coursecode, coursename, studentid, sc.sectionid
                FROM employees e JOIN professors p ON (e.empid = p.empid)
                    JOIN sections s ON (p.empid = s.profid)
                    JOIN term t ON (s.termcode = t.termcode)
                    JOIN courses c ON (s.coursecode = c.coursecode)
                    JOIN jnc_students_courses sc ON (s.sectionid = sc.sectionid)
        )
        GROUP BY termname, coursecode,  courseName, professor, sectionID
) ORDER BY termName;
SELECT * FROM vwTermInfo;


-- Grant permission for Clint

GRANT READ ON Advisors TO db301_191B45;
GRANT READ ON Countries TO db301_191B45;
GRANT READ ON Courses TO db301_191B45;
GRANT READ ON Departments TO db301_191B45;
GRANT READ ON Employees TO db301_191B45;
GRANT READ ON Jnc_prog_courses TO db301_191B45;
GRANT READ ON jnc_prog_students TO db301_191B45;
GRANT READ ON jnc_students_courses TO db301_191B45;
GRANT READ ON Professors TO db301_191B45;
GRANT READ ON Programs TO db301_191B45;
GRANT READ ON Sections TO db301_191B45;
GRANT READ ON Students TO db301_191B45;
GRANT READ ON Term TO db301_191B45;
GRANT READ ON vwStudentTranscript TO db301_191B45;
GRANT READ ON vwClassList TO db301_191B45;
GRANT READ ON vwSectionAvg TO db301_191B45;
GRANT READ ON vwProgramCourses TO db301_191B45;
GRANT READ ON vwTermInfo TO db301_191B45;

----------------------------------------------------------------
-- END OF FILE
----------------------------------------------------------------