-- 테이블 생성 실습
-- 회원에 대한 데이터를 담을 수 있는 member 테이블 생성
-- DROP TABLE IF EXISTS `member`;

-- CREATE TABLE `member` (
--     `mem_no` INT NOT NULL,
--     `mem_id` VARCHAR(20) NOT NULL,
--     `mem_pass` VARCHAR(20) NOT NULL,
--     `mem_name` VARCHAR(20) NOT NULL,
--     `enroll_date` DATE DEFAULT CURDATE()
-- );


-- 테이블에 샘플 데이터 추가
-- INSERT INTO `member`
-- VALUES (1, 'lee123', '1234', '홍길동',NULL);
-- 
-- INSERT INTO `member`
-- VALUES (2, 'lee123', '1234', '이몽룡',NULL);
-- 
-- INSERT INTO `member`
-- VALUES (3, 'sung123', '1234', '성춘향','2026-01-11');
-- 
-- INSERT INTO `member`
-- VALUES (4, 'lim123', '1234', '임꺽정',CURDATE());
-- 

-- 에러발생 -> 모든 열에 데이터가 삽입되지 않음
-- INSERT INTO `member`
-- VALUES (4, 'lim123', '1234', '임꺽정');
-- 
-- -- mem_pass 열에 NOT NULL 로 인해 에러발생 
-- INSERT INTO 'member' ('mem_no','mem_id')
-- VALUES (5,'kim1234');
-- 
-- -- NOT NULL 로 인해 NULL로 업데이트 할 수 없음
-- UPDATE 'member'
-- SET 'mem_id' = NULL
-- WHERE 'mem_name' = '홍길동';



-- 제약조건 실습
-- 기본키 ,unique 제약조건 실습
-- 대리키를 쓰는 것이 다른 데이터 변경에 의한 영향이 없음
-- 추가 열들을 생성해야하기 때문에 복잡해질 수 있음
-- DROP TABLE IF EXISTS `member`;
-- CREATE TABLE `member` (
--     `mem_no` INT PRIMARY KEY,  -- 대리키 candidate key
--     `mem_id` VARCHAR(20) UNIQUE,  -- 자연키
--     `mem_pass` VARCHAR(20) NOT NULL,
--     `mem_name` VARCHAR(20) NOT NULL,
--     `enroll_date` DATE DEFAULT CURDATE()
-- );
-- 
-- 
-- INSERT INTO `member`
-- VALUES (1, 'hong123', '1234', '홍길동','2026-01-11');
-- 
-- INSERT INTO `member`
-- VALUES (2, 'lee123', '1234', '이몽룡',CURDATE());
-- 
-- 
-- -- 기본키는 중복되면 안됨
-- INSERT INTO `member`
-- VALUES (1, 'sung123', '1234', '성춘향',DEFAULT);
-- 
-- -- mem_id가 unique 제약조건에 위배
-- INSERT INTO `member`
-- VALUES (3, 'lee123', '1234', '성춘향',DEFAULT);


-- 
-- DROP TABLE IF EXISTS `member`;
-- 
-- 시스템에서 자동으로 기본키 생성하고록 수정
-- CREATE TABLE `member` (
--     `mem_no` INT AUTO_INCREMENT PRIMARY KEY,  -- 대리키 candidate key
--     `mem_id` VARCHAR(20) NOT NULL UNIQUE,  -- 자연키
--     `mem_pass` VARCHAR(20) NOT NULL,
--     `mem_name` VARCHAR(20) NOT NULL,
--     `enroll_date` DATE DEFAULT CURDATE()
-- );
-- 
-- 
-- 
-- INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`)
-- VALUES ('hong123', '1234', '홍길동');
-- 
-- INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`)
-- VALUES ('lee123', '1234', '이몽룡');
-- 
-- INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`)
-- VALUES ('sung123', '1234', '성춘향');
-- 


-- DROP TABLE IF EXISTS `member`;
-- 
-- -- 시스템에서 자동으로 기본키 생성하고록 수정
-- CREATE TABLE `member` (
--     `mem_no` INT AUTO_INCREMENT, 
--     `mem_id` VARCHAR(20) NOT NULL,
--     `mem_pass` VARCHAR(20) NOT NULL,
--     `mem_name` VARCHAR(20) NOT NULL,
--     `enroll_date` DATE DEFAULT (CURRENT_DATE),
--     /*CONSTRAINT*/ PRIMARY KEY (`mem_no`),  -- 제약조건 생략가능
--     CONSTRAINT uq_member_mem_id UNIQUE (`mem_id`)
-- );
-- -- CONSTRAINT 생략 가능 여러개 정의 못함 이름 설정안해도됨
-- -- unique 제약조건도 여러개의 열을 묶어서 하나의 제약조건으로 생성할 수 있다. 
-- -- unique 등의 기본키 이외 제약조건은 이름 정의
-- -- ex) UNIQUE('mem_no','mem_id')
-- 
-- 
-- INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`)
-- VALUES ('hong123', '1234', '홍길동');
-- 
-- INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`)
-- VALUES ('lee123', '1234', '이몽룡');
-- 
-- INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`)
-- VALUES ('sung123', '1234', '성춘향');
-- 
-- ``````````` 1번옆에


-- 외래키(foreign key) 제약조건 실습

-- 부모테이블 생성
CREATE TABLE `member_grade`(
	grade_code VARCHAR(10) PRIMARY KEY,
	grade_name VARCHAR(10) NOT NULL
);

INSERT INTO `member_grade` VALUES('vip','VIP회원');
INSERT INTO `member_grade` VALUES('gold','GOLD회원');
INSERT INTO `member_grade` VALUES('silver','SILVER회원');


-- 자식 테이블 생성
CREATE TABLE `member` (
    `mem_no` INT AUTO_INCREMENT PRIMARY KEY,  -- 대리키 candidate key
    `mem_id` VARCHAR(20) NOT NULL UNIQUE,  -- 자연키
    `mem_pass` VARCHAR(20) NOT NULL,
    `mem_name` VARCHAR(20) NOT NULL,
    -- `grade_code` VARCHAR(10) REFERENCES `member_grade`, 
	 -- 참조할 열 생략시 참조테이블의 기본키를 외래키로 참조
    `grade_code` VARCHAR(10) REFERENCES `member_grade`(`grade_code`),
    `enroll_date` DATE DEFAULT CURDATE()
);


INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`,`grade_code`)
VALUES ('hong123', '1234', '홍길동','vip');

--grade_code 열에 bronze 값이 없어서 외래키 제약조건에 위배
INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`,`grade_code`)
VALUES ('lee123', '1234', '이몽룡','bronze');

-- grade_code 열에 NULL을 넣는건 가능
INSERT INTO `member`(`mem_id`, `mem_pass`, `mem_name`,`grade_code`)
VALUES ('sung123', '1234', '성춘향',null);

-- 근데 null값은 포함됨
SELECT * 
FROM `member`;

-- member, member_grade 테이블 조인해서 회원번호, 아이디 , 이름,  계정등급 조회
SELECT * 
FROM member
LEFT OUTER JOIN member_grade ON member.grade_code = member_grade.grade_code;


-- member_grade 테이블에서 grade_code가 vip인 데이터 삭제
-- 현재 참조되고 있는 값에 대해서는 삭제나 수정이 불가능
DELETE
FROM `member_grade`
WHERE grade_code = 'vip';

-- member_grade 테이블에서 grade_code가 vip인 데이터 수정
UPDATE `member_grade`
SET `grade_code` = 'vvip'
WHERE `grade_code` = 'vip';

SELECT * FROM `member_grade`;
SELECT * FROM `member`;


-- delete 했을 때 cascade로 설정하면 참조하고 있는 모든 데이터가 삭제됨
-- update는 cascade 간혹 씀 업데이트시 잠조하는 모든 데이터가 수정됨













