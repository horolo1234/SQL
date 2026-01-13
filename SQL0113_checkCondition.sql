DROP TABLE `member`;

CREATE TABLE `member` (
    `mem_no` INT AUTO_INCREMENT PRIMARY KEY,
    `mem_id` VARCHAR(20) NOT NULL UNIQUE,
    `mem_pass` VARCHAR(20) NOT NULL,
    `mem_name` VARCHAR(20) NOT NULL,
    `gender` VARCHAR(2) CHECK (`gender` IN ('남자', '여자')),
    `age` TINYINT,
    `grade_code` VARCHAR(10) REFERENCES `member_grade`(`grade_code`),
    `enroll_date` DATE DEFAULT CURDATE(),
    -- CHECK(`age` >= 0)
    -- CONSTRAINT ck_member_age CHECK (`age` >= 0 AND `age`<= 120)
    CONSTRAINT ck_member_age CHECK (`age` BETWEEN 0 AND 120)
);


-- check 제약조건으로 인해 성별, 나이가 유효하지 않은 값들은 저장이 불가능
INSERT INTO `member` (`mem_id`, `mem_pass`, `mem_name`, `gender`, `age`, `grade_code`)
VALUES ('hong1234', '1234', '홍길동', '남자', 28, 'vip');

INSERT INTO `member` (`mem_id`, `mem_pass`, `mem_name`, `gender`, `age`, `grade_code`)
VALUES ('lee123', '1234', '이몽룡', '몽룡', 28, 'gold');

INSERT INTO `member` (`mem_id`, `mem_pass`, `mem_name`, `gender`, `age`, `grade_code`)
VALUES ('sung123', '1234', '성춘향', '남자', -28, 'silver');

-- update도 check 제약조건에 위배되면 안됨
UPDATE `member`
SET age = '길동'
WHERE mem_name= '홍길동';