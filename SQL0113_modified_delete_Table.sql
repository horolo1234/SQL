-- 테이블 열 추가 수정 삭제
-- alter 사용해서 함
-- usertbl 테이블에 홈페이지 열 추가
ALTER TABLE usertbl ADD homepage VARCHAR(20) DEFAULT NULL;
ALTER TABLE usertbl MODIFY homepage VARCHAR(30) DEFAULT NULL;

-- 테ㅂ이블에 gender 추가 기본값은 남자
ALTER TABLE usertbl ADD gender VARCHAR(2) DEFAULT '남자' NOT NULL;

-- birthyeara 뒤로 age가 오게 추가 할 수 있음
ALTER TABLE usertbl ADD age TINYINT DEFAULT 0 AFTER birthyear;

ALTER TABLE usertbl MODIFY `name` CHAR(15) NULL;

ALTER TABLE usertbl MODIFY `name` CHAR(1) NULL;

-- 값이 존재해서 변경 불가
ALTER TABLE usertbl MODIFY `name` INT;

-- usertbl 테이블에서 데이터 유형을 INT로 바꿈
-- 값이 존재하지 않아서 변경 가능
ALTER TABLE usertbl MODIFY `homepage` INT;

-- usertbl에서 name열의 이름을  uname 으로 변경
ALTER TABLE usertbl RENAME COLUMN `name` TO `uname`;

-- 위 두 과정을 한번에 변경
ALTER TABLE usertbl 
CHANGE COLUMN `uname` `name` VARCHAR(20) DEFAULT '없음' NOT NULL;



-- ==================== 3)열 삭제 =======================
ALTER TABLE usertbl DROP COLUMN age;
ALTER TABLE usertbl DROP COLUMN homepage;
ALTER TABLE usertbl DROP COLUMN gender;

-- usertbl 에서 userid 열 삭제 불가
-- buytbl이 usertbl에 userID를 참조함
-- 참조되고 있는 열이 있으면 삭제 불가능
-- 삭제하려면 제약조건을 삭제하거나 참조하는 열이 없도록 한 후에 삭제해야 한다.
ALTER TABLE usertbl DROP COLUMN userid;


-- dept_copy 테이블을 생성하고 모든 열을 삭제
CREATE TABLE dept_copy(
	SELECT *
	FROM department
);

ALTER TABLE dept_copy DROP COLUMN dept_id;
ALTER TABLE dept_copy DROP COLUMN dept_title;

-- 테이블은 무조건 최소 한개의 열은 존재해야한다
ALTER TABLE dept_copy DROP COLUMN location_id;

-- 테이블 삭제할거면 DROP을 사용하는게 좋음


-- 열의 제약조건 추가, 삭제
-- 테스트 테이블 생성

DROP TABLE `member`, `member_grade`;

CREATE TABLE `member_grade`(
	grade_code VARCHAR(10) ,
	grade_name VARCHAR(10) NOT NULL
);

CREATE TABLE `member` (
    `mem_no` INT, 
    `mem_id` VARCHAR(20) NOT NULL,
    `mem_pass` VARCHAR(20) NOT NULL,
    `mem_name` VARCHAR(20) NOT NULL,
    `enroll_date` DATE DEFAULT CURDATE()
);

-- 1) 열의 제약조건 추가
-- member_grade 테이블에 primary key 제약조건 추가
ALTER TABLE member_grade ADD CONSTRAINT PRIMARY KEY(grade_code);


-- member 테이블에 primary key 제약조건, auto_increment 설정 추가
ALTER TABLE `member` ADD CONSTRAINT PRIMARY KEY(mem_no)
ALTER TABLE `member` MODIFY mem_no INT AUTO_INCREMENT;


-- member 테이블에 unique 제약조건 추가
ALTER TABLE `member` ADD CONSTRAINT `uq_member_memID` UNIQUE(mem_id);


-- member 테이블에 grade_code 열 생성 후 foreign key 제약조건 추가
-- FOREIGN KEY는 어느 테이블에 어떤 열을 참조할지 결정해야함
ALTER TABLE `member` ADD `grade_code` VARCHAR(10) AFTER `mem_name`;
ALTER TABLE `member` ADD CONSTRAINT 
FOREIGN KEY(`grade_code`) REFERENCES `member_grade`(`grade_code`);

-- member 테이블에 gender 열을 생성 후 check 제약조건을 추가
ALTER TABLE `member` ADD `gender` CHAR(2) AFTER `mem_name`;
ALTER TABLE `member` ADD CONSTRAINT 
CHECK (`gender` IN ('남자', '여자'));

-- member 테이블에 age 열을 생성 후 check 제약조건을 추가
ALTER TABLE `member` ADD `age` TINYINT AFTER `gender`;
ALTER TABLE `member` ADD CONSTRAINT
CHECK (`age` BETWEEN 0 AND 120);

-- ==================== 실습 ====================
-- employee의 emp_no UNIQUE 제약조건 추가
ALTER TABLE employee ADD UNIQUE(emp_no);


-- employee 테이블에 dept_code에 FK 제약 조건 추가
ALTER TABLE `employee` ADD CONSTRAINT 
FOREIGN KEY(`dept_code`) REFERENCES `department` (`dept_id`);


-- employee 테이블에 job_code에 FK 제약 조건 추가
ALTER TABLE `employee` ADD CONSTRAINT 
FOREIGN KEY(`job_code`) REFERENCES `job` (`job_code`);

-- department 테이블에 location_id에 FK 제약 조건 추가
ALTER TABLE `department` ADD CONSTRAINT 
FOREIGN KEY(`location_id`) REFERENCES `location` (`local_code`);

-- location 테이블에 national_id에 FK 제약 조건 추가
ALTER TABLE `location` ADD CONSTRAINT 
FOREIGN KEY(`national_code`) REFERENCES `national` (`national_code`);
-- ==============================================
-- ----------------------------------------------------------

-- 2) 제약 조건 삭제
-- member 테이블에서 PRIMARY KEY 제약 조건 삭제
ALTER TABLE `member` MODIFY `mem_no` INT; -- AUTO_INCREMENT 해제
ALTER TABLE `member` DROP CONSTRAINT PRIMARY KEY;

-- member 테이블에서 UNIQUE 제약 조건 삭제
ALTER TABLE `member` DROP CONSTRAINT uq_member_mem_id;

-- member 테이블에서 FOREIGN KEY 제약 조건 삭제
ALTER TABLE `member` DROP CONSTRAINT member_ibfk_1;

-- member 테이블에서 CHECK 제약 조건 삭제
ALTER TABLE `member` DROP CONSTRAINT CONSTRAINT_1;
ALTER TABLE `member` DROP CONSTRAINT ck_member_age;

-- ----------------------------------------------------------

-- 3. 테이블 이름 변경
RENAME TABLE usertbl TO usertbl_rename;

RENAME TABLE usertbl_rename TO usertbl;


-- 4. 테이블 삭제
DROP TABLE dept_copy;

-- 외래키 참조되고 있는 경우 테이블 삭제 불가능
-- 삭제하려면 제약조건을 제거하거나 자식 테이블 부터 삭제
DROP TABLE `member`,`member_grade`;




