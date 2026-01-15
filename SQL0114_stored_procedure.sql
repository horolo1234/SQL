-- 스토어드 프로시저 실
-- $$으로 문장의 끝을 변경
-- ; 종료문자 설정 잘 해야함
-- DELIMITER $$ 로 먼저 $$가 종료문자임을 설정하고
-- 프로시저를 생성한 후 다시 DELIMITER ;로 ;를 종료문자로 설정해야함

DELIMITER $$ 
CREATE PROCEDURE userProc()
BEGIN
    SELECT * FROM usertbl;
END $$
DELIMITER ;

CALL userProc;

-- 매개변수 사용
-- 회원의 이름을 입력받아서 조회하는 프로시저 생성
DROP PROCEDURE IF EXISTS userProc;

DELIMITER $$ 
CREATE PROCEDURE userProc(
	IN userName VARCHAR(10)
)
BEGIN
    SELECT * 
	 FROM usertbl
	 WHERE `name` = userName;
END $$
DELIMITER ;

CALL userProc('성시경');

-- 사용자의 아이디를 입력받아서 이름을 돌려주는 프로시저 생성
SET @gender = '남자';
SELECT @gender;


-- CALL userProc('BBK',@uname); 여기서 id를 받으면
-- userProc(
-- 	IN id CHAR(8),
-- 	OUT userName VARCHAR(20)
-- )
-- 여기서 id에 값을 넣음
-- 그러면 WHERE `userID` = id; 로 `name`을 조회 후
-- INTO userName 으로 userName으로 들어감
-- 그후 OUT userName VARCHAR(20) 조회된 값을 던짐

DELIMITER $$
CREATE PROCEDURE userProc(
	IN id CHAR(8),
	OUT userName VARCHAR(20)
)
BEGIN
    SELECT `name`
    INTO userName  	-- 조회한 결과(name)를 userName에 담아줌 
	 FROM usertbl
	 WHERE `userID` = id;
END $$
DELIMITER ;

-- IN 값은 ssk OUT 값은 @uname
-- @uname은 사용자 정의 변수
CALL userProc('BBK',@uname);
SELECT @uname;

-- ================== 제어문 ==================
-- 1) 조건문
-- 1-1 IF
DELIMITER $$
CREATE OR REPLACE PROCEDURE empProc(
	IN id CHAR(3)
)
BEGIN
	DECLARE `year` INT; -- 지역변수 선언

	SELECT YEAR(hire_date)
	INTO `year`
	FROM employee 
	WHERE emp_id = id;
	
	-- if else 구문
	IF `year` >= 2010 THEN
		SELECT '2010년대 입사 하셨습니다.';
	ELSEIF `year` >= 2000 THEN
		SELECT '2000년대에 입사하셨습니다.';
	ELSE
		SELECT '1990년대 입사하셨습니다.';
	END IF;
END$$
DELIMITER ;


CALL empProc('210');

SELECT YEAR(hire_date) FROM employee WHERE emp_id = '200';

-- 1-2 CASE 실습
DELIMITER $$
CREATE OR REPLACE PROCEDURE gradeProc(
	IN score TINYINT
)
BEGIN
	DECLARE grade CHAR(1);
	
	CASE
		WHEN score >= 90 THEN SET grade = 'A';
		WHEN score >= 80 THEN SET grade = 'B';
		WHEN score >= 70 THEN SET grade = 'C';
		WHEN score >= 60 THEN SET grade = 'D';
		ELSE
			SET grade = 'F';
	END CASE
	
END$$
DELIMITER ;

CALL gradeProc(59);

-- 2. 반복문
-- 2-1 WHILE
-- 1-10까지의 합계
DELIMITER $$
CREATE PROCEDURE sumProc()
BEGIN
	DECLARE `i` INT;
	DECLARE `sum` INT;
	
	SET `i`  = 1;
	SET `sum` = 0;
	WHILE (`i` <= 10) DO
		SET `sum` = `sum` + `i`;
		SET `i` = `i` + 1;
	END WHILE;
	
	SELECT CONCAT('1 부터 10까지의 합 : ', `sum`) AS 'result';	

END$$
DELIMITER ;


CALL sumProc();

-- 구구단 출력
DELIMITER $$
CREATE OR REPLACE PROCEDURE multiProc(
	IN i INT
)
BEGIN
	DECLARE n INT;
	DECLARE result VARCHAR(100);
	SET n = 1;
	SET result = '';
	
	WHILE (n <= 9) DO
		SET result = CONCAT(result, i, ' * ', n, ' = ', i * n,' ');
		SET n = n + 1;	    
	END WHILE;
	
	SELECT result;
END$$
DELIMITER ;

CALL multiProc(2);

-- ======================= 오류, 예외  처리 ==========================
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
    DECLARE CONTINUE HANDLER FOR 1146 SELECT '테이블이 없어요ㅠㅠ' AS '메시지';
    SELECT * FROM noTable;
END $$
DELIMITER ;

CALL errorProc();

-- =============== 프로시저 삭제 ===============
DROP PROCEDURE empProc;
DROP PROCEDURE errorProc;
DROP PROCEDURE gradeProc;
DROP PROCEDURE multiProc;
DROP PROCEDURE sumProc;
DROP PROCEDURE test_db.userProc;




