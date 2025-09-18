------------------------------------------------------
-- 1. Users (회원목록)
CREATE TABLE Users (

id VARCHAR2(50),
name VARCHAR2(30) NOT NULL,
password VARCHAR2(50) NOT NULL,
email VARCHAR2(50) NOT NULL,
mobile VARCHAR2(40) NOT NULL,
point NUMBER DEFAULT 0,
fk_categoryNo NUMBER, -- 추후에 추가되는 카테고리 number
registerday DATE DEFAULT SYSDATE,
passwordChanged DATE DEFAULT SYSDATE,
isDormant NUMBER(1) DEFAULT 0 NOT NULL,
isDeleted NUMBER(1) DEFAULT 0 NOT NULL,

constraint pk_Users 
           primary key (id),
constraint fk_User_Category foreign key (fk_categoryNo) 
           references Category(categoryNo) on delete CASCADE,
constraint ck_Users_isDormant 
           CHECK (isDormant in (1, 0)),
constraint ck_Users_isDeleted 
           CHECK (isDeleted in (1, 0))
);
select *from users;
commit;
// fk_category 없이 회원가입 시 실행.
insert into users(id, name, password, email, mobile)
       values('admin', '관리자', 'qwer1234$', 'shindonghee2@naver.com', '01064396718');
      
// 테스트를 한 후, 회원가입을 진행하였을 시, fk_category 세팅.
insert into users(id, name, password, email, mobile
                  ,fk_category)
       values(admin, '관리자', 'qwer1234$', 'shindonghee2@naver.com', '01064396718', '1');
                        

-- 2. LoginHistory (로그인 기록)
CREATE TABLE login_history (

loginHistoryNo NUMBER,
fk_id VARCHAR2(50) NOT NULL,
lastLogin DATE DEFAULT SYSDATE NOT NULL,
ip VARCHAR2(45) NOT NULL,

constraint pk_LoginHistory 
           primary key (loginHistoryNo),
constraint fk_LoginHistory_Id 
           foreign key (fk_id) references Users(id) on delete CASCADE
);

CREATE SEQUENCE login_history_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;


-- 3. Question (질문)

CREATE TABLE Question (

questionNo NUMBER NOT NULL,
questionContent VARCHAR2(255) NOT NULL,

constraint PK_Question primary key (questionNo)
);

CREATE SEQUENCE question_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;

-- 4. Options (답변)
CREATE TABLE Options (

optionNo NUMBER NOT NULL,
fk_questionNo NUMBER NOT NULL,
optionText VARCHAR2(200),
fk_categoryNo NUMBER,

constraint pk_Option 
           primary key (optionNo),
constraint fk_Option_Question
           foreign key (fk_questionNo) references Question(questionNo) on delete CASCADE,
constraint fk_Option_Category 
           foreign key (fk_categoryNo) references Category(categoryNo)
);

CREATE SEQUENCE options_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;


-- 5. Category (카테고리)

CREATE TABLE Category (

categoryNo NUMBER NOT NULL,
categoryName VARCHAR2(50) NOT NULL,
categoryDescribe VARCHAR2(200),
categoryImagePath VARCHAR2(255),

constraint pK_Category 
           primary key (categoryNo)
);
--insert into category values(category_seq.nextval, '리더형', '', '');
--delete from category where categoryNo = 1;

CREATE SEQUENCE category_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;
drop sequence category_seq;

--- 6. Tag (태그)
CREATE TABLE Tag (

tagNo NUMBER NOT NULL,
fk_categoryNo NUMBER NOT NULL,
tagName VARCHAR2(50),

constraint pk_Tag
           primary key (tagNo),
constraint fk_Tag_category 
           foreign key (fk_categoryNo) references Category(categoryNo) on delete CASCADE

);

CREATE SEQUENCE tag_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOCACHE;

select * from board;

select * from tab;

select *
from users
order by fk_categoryNo;

update users set fk_categoryNo = '2'
where id = 'sai05005';

commit;

desc users;

select * from question;

select * from tabs;

select * from tag;

update users set email='dbals010321@naver.com' where id='jangym';

commit;

select registerday from users order by registerday desc;

select To_char(sysdate,'MM') from users;

select to_char(Registerday, 'yyyymmdd'), count(*) from users
where sysdate - Registerday > 10
group by rollup(to_char(Registerday, 'yyyymmdd'));

   select TO_CHAR(u.registerday,'dd') AS dd,
        count(*)	 AS cnt
	FROM users u
	WHERE EXTRACT(MONTH FROM u.registerday) = :month
	GROUP BY TO_CHAR(u.registerday,'dd');
    
select * from tag;

select * from category C join Board B on C.categoryNo = B.fk_categoryNo join tag t on t.fk_categoryNo = c.categoryNo ;
        
        
select categoryNo, categoryName, categoryImagePath, CATEGORYDESCRIBE,
       LISTAGG(tagName, '# ') WITHIN GROUP (ORDER BY tagNo) AS tags
from category C join tag T
on C.categoryNo = T.fk_categoryNo
where categoryNo = 1
group by (categoryNo, categoryName, categoryImagePath,CATEGORYDESCRIBE);