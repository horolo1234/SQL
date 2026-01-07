SELECT emp_name,NVL2(bonus,0.1,0),(salary+(salary*NVL2(bonus,0.1,0)))*12
FROM employee;


-- NULLIF(수식 1, 수식 2)

SELECT NULLIF("123","123"), NULLIF("123","456");
SELECT NULLIF(123,123), NULLIF(123,456);

-- CASE 연산자 
SELECT CASE 15
				WHEN 1 THEN "일"
				WHEN 5 THEN "오"
				WHEN 10 THEN "십"
				ELSE "모름"
			END AS "RESULT";
			
-- WHEN에서 TRUE가 나오면 나머지 조건은 실행x
SELECT CASE
			WHEN 10>20	THEN "10<20"
			WHEN 10=20	THEN "10=20"
			WHEN 10>20	THEN "10>20"
			ELSE "모름"
		END AS "RESULT";
		
-- EMPLOYEE에서 직원명, 급여 , 급여 등급 조회salary
-- 급여 500 초과시 1등급
-- 500이하 350초과일 경우 2등급
-- 350이하 200 초과일 경우 3등급
-- 200 이하는 4등급

SELECT emp_name, 
			salary 
FROM employee
ORDER BY salary desc;


SELECT emp_name, salary,
			case
				when salary >5000000 then "1등급"
				when salary >3500000 then "2등급"
				when salary >2000000 then "2등급"
				ELSE "4등급" 
			END AS "등급"
FROM employee
ORDER BY salary DESC;


-- 문자 처리함수
-- ASCII CHAT 함수
SELECT ASCII("A"),ASCII("홍");

-- BIT_LENGTH(문자열)
-- CHAR_LENGTH(문자열)
-- LENGTH(문자열)
-- 마리아 DB 기본 UTF-8 영어 1바이트, 한글 3바이트

SELECT
	BIT_LENGTH("ABC"),
	CHAR_LENGTH("ABC"),
	LENGTH("ABC"),
	BIT_LENGTH("홍길동"),
	CHAR_LENGTH("홍길동"),
	LENGTH("홍길동");
	
-- CONCAT(문자열 1, 문자열 2, ... ), 자바 + 연산자와 같음
-- CONCAT_WS(구분자, 문자열 1, 문자열 2, ... ) 자바 + 연산자와 같음
SELECT	CONCAT("2026","01","07"), 
			CONCAT_WS("-","2026","01","07");

SELECT 	userID, 
			NAME,
			CONCAT(mobile1,mobile2,mobile3)
FROM usertbl;

SELECT 	userID, 
			NAME,
			CONCAT_WS("-",mobile1,mobile2,mobile3)
FROM usertbl;

-- ELT(위치, 문자열 1, 문자열 2, ...) 
SELECT ELT(1,"A","B","C");

-- FIELD(찾을 문자열, 문자열 1, 문자열 2, ...)
SELECT FIELD("A","A","B","C");
-- FIND_IN_SET(찾을 문자열, 문자열 리스트)
SELECT FIND_IN_SET("B","A,B,C");
-- INSTR(기준 문자열, 부분 문자열)
SELECT INSTR("AASDABC","ABC");
SELECT INSTR("하나 둘 셋","둘");
-- LOCATE(부분 문자열, 기준 문자열)

-- FORMAT 숫자 표현
SELECT FORMAT(10000,0); -- 0은 파라미터 
SELECT FORMAT(1000000.01261235,3); -- 소숫점 3자리만 나오고 이후 반올림

-- INSERT(기준 문자열, 실행위치(3번째 위치), 자르는 개수(4), 끼워넣을 문자
SELECT INSERT("ABCDEFGHI",3,4,"####1234");
SELECT INSERT("000000-1234567",9,7,"******");

SELECT emp_name, INSERT(emp_no,9,7,"******") FROM employee;	

-- LEFT RIGHT
SELECT	LEFT("ABCDEFGH",3),
			RIGHT("ABCDEFGH",3);
			
SELECT emp_name, email, LEFT(email,6) FROM employee;
SELECT emp_name, email, LEFT(email, INSTR(email,"@")-1) FROM employee;

-- LPAD(문자열, 길이, 채울 문자열)
-- RPAD(문자열, 길이, 채울 문자열)
SELECT LPAD("hello",10); -- 기존 문자열을 포함해서 10자리 만듦
SELECT LPAD("hello",4);
SELECT RPAD("hello",10);
SELECT RPAD("hello",4,"#");

SELECT emp_name, LPAD(emp_no,7) from employee;
SELECT emp_name, RPAD(LPAD(emp_no,7),14,"*") from employee;

-- LTRIM RTRIM TRIM
SELECT 	LTRIM("     HELLO     "), -- 왼쪽 공백 제거
			RTRIM("     HELLO     "), -- 오른쪽 공백 제거
			TRIM("     HELLO     "); -- 양쪽 공백 제거

-- TRIM 방향 지정해서 자를 수 있음
SELECT TRIM(BOTH " " FROM "     HELLO     ");
SELECT TRIM(BOTH "Z" FROM "ZZZZZHELLOZZZZZ"); -- Z를 자르다가 아니면 다음으로 넘어감

SELECT 	TRIM(LEADING "Z" FROM "ZZZZZHELLOZZZZZ"), 
			TRIM(TRAILING "Z" FROM "ZZZZZHELLOZZZZZ");
			
-- REPEAT, REVERSE, SPACE
SELECT REPEAT("ABC",3);
SELECT REVERSE("ABC");
SELECT CONCAT("MARIA", SPACE(2),"DB");
SELECT SPACE(5);

-- REPLACE gmail을 naver로 변경
-- (문자열, 기존 존재하는 문자열, 변경할 문자열)
SELECT REPLACE("PARK@gmail.com", "gmail", "naver"),
		REPLACE("PARK@gmail.com","@gmail.com", "");

-- employee 테이블에서 이메일의 ismoon.or.kr을 beyond.com
SELECT emp_name, 
		email,
		REPLACE(email,"ismoon.or.kr", "beyond.com") AS "replaceEmail"
FROM employee;

-- SUBSTRING(문자열, 시작위치, 길이) 시작부터 끝까지 반환
SELECT SUBSTRING("대한민국만세",3),
			SUBSTRING("대한민국만세",3,2),
			SUBSTRING("대한민국만세",-2,2);

SELECT emp_name,
			SUBSTRING(email,1,INSTR(email,"@")-1) AS "ID",
			CASE
				WHEN SUBSTRING(emp_no,8,1) IN ("1","3")THEN "남"
				WHEN SUBSTRING(emp_no,8,1) IN ("2","4")THEN "여"
			END AS "성별"
FROM employee;

-- SUBSTRING_INDEX
SELECT SUBSTRING_INDEX("cafe.naver.com",".",2); -- 오른쪽에서 왼쪽
SELECT SUBSTRING_INDEX("cafe.naver.com",".",-2); -- 왼쪽에서 오른쪽

SELECT emp_name, 
			SUBSTRING_INDEX(email,"@",1),
			email
FROM employee;

