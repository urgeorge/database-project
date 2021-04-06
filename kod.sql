CREATE TABLE loggingdata (
    idloggingdata   NUMBER(6) PRIMARY KEY,
    login           VARCHAR2(20) NOT NULL,
    passwd          VARCHAR2(255) NOT NULL,
    CONSTRAINT loggingdata_login_UN UNIQUE (login)
);

CREATE TABLE student (
    idstudent       NUMBER(7) PRIMARY KEY,
    indexnumber     VARCHAR2(6) NOT NULL,
    pesel           VARCHAR2(11),
    surname         VARCHAR2(30) NOT NULL,
    firstname       VARCHAR2(20) NOT NULL,
    yearofstudy     NUMBER(1) NOT NULL,
    idloggingdata   NUMBER(5) NOT NULL,
    
    CONSTRAINT student_indexnumber_UN UNIQUE (indexnumber),
    CONSTRAINT student_pesel_UN UNIQUE (pesel)
);

ALTER TABLE student
    ADD CONSTRAINT student_loggingdata_fk FOREIGN KEY ( idloggingdata )
        REFERENCES loggingdata ( idloggingdata );

CREATE TABLE examiner (
    idexaminer      NUMBER(4) PRIMARY KEY,
    firstname       VARCHAR2(20) NOT NULL,
    surname         VARCHAR2(30) NOT NULL,
    academictitle   VARCHAR2(50) NOT NULL,
    idloggingdata   NUMBER(5) NOT NULL
);

ALTER TABLE examiner
    ADD CONSTRAINT examiner_loggingdata_fk FOREIGN KEY ( idloggingdata )
        REFERENCES loggingdata ( idloggingdata );
		
CREATE UNIQUE INDEX student__idx ON
    student (
        idloggingdata
    ASC );
		
CREATE UNIQUE INDEX examiner__idx ON
    examiner (
        idloggingdata
    ASC );
	
CREATE TABLE course (
    idcourse     NUMBER(5) PRIMARY KEY,
    coursename   VARCHAR2(40) NOT NULL,
    CONSTRAINT course_coursename_UN UNIQUE (coursename)
);

CREATE TABLE exam (
    idexam          NUMBER(6) PRIMARY KEY,
    idexaminer      NUMBER(4) NOT NULL,
    passingscore    NUMBER(3) NOT NULL,
    maxpoints       NUMBER(3) NOT NULL,
    questioncount   NUMBER(3) NOT NULL,
    startdate       DATE NOT NULL,
    maxduration     NUMBER(5) NOT NULL,
    pointsfor5      NUMBER(3) NOT NULL,
    pointsfor4      NUMBER(3) NOT NULL,
    pointsfor3      NUMBER(3) NOT NULL,
    idcourse        NUMBER(5) NOT NULL
);

ALTER TABLE exam
    ADD CONSTRAINT exam_course_fk FOREIGN KEY ( idcourse )
        REFERENCES course ( idcourse );

ALTER TABLE exam
    ADD CONSTRAINT exam_examiner_fk FOREIGN KEY ( idexaminer )
        REFERENCES examiner ( idexaminer );

CREATE TABLE examscore (
    scorevalue              NUMBER(3) NOT NULL,
    examdurationinseconds   NUMBER(5) NOT NULL,
    idstudent               NUMBER(7) NOT NULL,
    idexam                  NUMBER(6) NOT NULL
);

ALTER TABLE examscore ADD CONSTRAINT examscore_pk PRIMARY KEY ( idstudent,
                                                                idexam );

ALTER TABLE examscore
    ADD CONSTRAINT examscore_exam_fk FOREIGN KEY ( idexam )
        REFERENCES exam ( idexam );

ALTER TABLE examscore
    ADD CONSTRAINT examscore_student_fk FOREIGN KEY ( idstudent )
        REFERENCES student ( idstudent );
		
CREATE TABLE question (
    idquestion  NUMBER(6) PRIMARY KEY,
    contentText VARCHAR2(400) NOT NULL,
    maxpoints   NUMBER(2) NOT NULL,
    idcourse    NUMBER(5) NOT NULL,
    isopen      CHAR(1) NOT NULL,
    
    CONSTRAINT question_contentText_UN UNIQUE (contentText)
);

ALTER TABLE question
    ADD CONSTRAINT question_course_fk FOREIGN KEY ( idcourse )
        REFERENCES course ( idcourse );	
		
CREATE TABLE exam_question (
    idexam       NUMBER(6) NOT NULL,
    idquestion   NUMBER(6) NOT NULL
);
		
ALTER TABLE exam_question ADD CONSTRAINT exam_question_pk PRIMARY KEY ( idexam,
                                                                        idquestion );

ALTER TABLE exam_question
    ADD CONSTRAINT exam_question_exam_fk FOREIGN KEY ( idexam )
        REFERENCES exam ( idexam );

ALTER TABLE exam_question
    ADD CONSTRAINT exam_question_question_fk FOREIGN KEY ( idquestion )
        REFERENCES question ( idquestion );
		

CREATE TABLE studentanswer (
    idstudentanswer     NUMBER(7) PRIMARY KEY,
    idquestion          NUMBER(6) NOT NULL,
    gainedpoints        NUMBER(2) NOT NULL,
    openanswercontent   VARCHAR2(400),
    idstudent           NUMBER(5) NOT NULL,
    idexam              NUMBER(6) NOT NULL
);

ALTER TABLE studentanswer
    ADD CONSTRAINT studentanswer_examscore_fk FOREIGN KEY ( idstudent, idexam )
        REFERENCES examscore ( idstudent, idexam );

ALTER TABLE studentanswer
    ADD CONSTRAINT studentanswer_question_fk FOREIGN KEY ( idquestion )
        REFERENCES question ( idquestion );
		
CREATE TABLE closedanswer (
    idclosedanswer   NUMBER(7) PRIMARY KEY,
    idquestion       NUMBER(6),
    contentText      VARCHAR2(200) NOT NULL,
    iscorrect        CHAR(1) NOT NULL
);

ALTER TABLE closedanswer
    ADD CONSTRAINT closedanswer_question_fk FOREIGN KEY ( idquestion )
        REFERENCES question ( idquestion );

CREATE TABLE studentanswer_closedanswer (
    idstudentanswer   NUMBER(7) NOT NULL,
    idclosedanswer    NUMBER(7) NOT NULL
);
		
ALTER TABLE studentanswer_closedanswer ADD CONSTRAINT studentanswer_closedanswer_pk PRIMARY KEY ( idstudentanswer,
                                                                                                  idclosedanswer );

ALTER TABLE studentanswer_closedanswer
    ADD CONSTRAINT closedanswer_fk FOREIGN KEY ( idclosedanswer )
        REFERENCES closedanswer ( idclosedanswer );

ALTER TABLE studentanswer_closedanswer
    ADD CONSTRAINT studentanswer_fk FOREIGN KEY ( idstudentanswer )
        REFERENCES studentanswer ( idstudentanswer );