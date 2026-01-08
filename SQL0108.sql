-- 수학함수
-- CEILING FROOR TRUNCATE
SELECT CEILING(1.3); -- 올림
SELECT FLOOR(1.51212); -- 내림
SELECT TRUNCATE(2.1234567,3); -- 3자리 이후부터 자름
SELECT TRUNCATE(216.1234567,-1); -- 정수부 기준으로 나머지 버림

-- ROUND

SELECT	ROUND(4.3552,3),	-- 자리수 기준으로 반올림
		 	ROUND(4.3552,2),
			ROUND(4.3552,-1); -- -1인 경우 정수부를 반올림함
			
-- MOD 나머지값 구해줌
SELECT (5%3);
SELECT MOD(5,3);


-- RAND
SELECT 	TRUNCATE(RAND()*10,0),
			FLOOR(RAND()*100),
			TRUNCATE(RAND()*100,0),
			TRUNCATE((RAND()*100)+1,0);

-- SIGN
SELECT 	SIGN(23),
			SIGN(0),
			SIGN(-23);

SELECT DATE(NOW()), TIME(NOW());


-- ADDDATE,SUBDATE(기준날짜, INTERVAL 더하는 일/ 월/ 년)
SELECT ADDDATE(CURDATE(),INTERVAL 7 DAY),
		ADDDATE(CURDATE(),INTERVAL 1 MONTH),
		ADDDATE(CURDATE(),INTERVAL 1 YEAR);
		
SELECT SUBDATE(CURDATE(),INTERVAL 7 DAY),
		SUBDATE(CURDATE(),INTERVAL 1 MONTH),
		SUBDATE(CURDATE(),INTERVAL 1 YEAR);
		
-- EMPLOYEE 테이블에서 직원명, 입사일, 입사일 후 3개월
SELECT emp_name, 
		hire_date, 
		ADDDATE(hire_date, INTERVAL 3 MONTH)
FROM employee;

SELECT ADDTIME(NOW(),"1:0:0"); -- 시:분:초 다 넘겨줘야됨
SELECT SUBTIME(NOW(),"1:0:0");

-- CURDATE CURTIME NOW SYSDATE
SELECT CURDATE(), -- 현재 날짜 정보
		CURTIME(), -- 현재 시간정보
		NOW(), -- 현재 날짜 시간
		SYSDATE(); -- 시스탬상 시간
		
-- YEAR MONTH DAY DATE
SELECT YEAR(NOW()), -- INT 형태로 빼옴
		MONTH(NOW()), -- INT 형태로 빼옴
		DAY(NOW()),  -- INT 형태로 빼옴
		DATE(NOW());

-- HOUR MINUTE SECOND TIME
SELECT HOUR(NOW()), -- INT 형태로 빼옴
		MINUTE(NOW()), -- INT 형태로 빼옴
		SECOND(NOW()),  -- INT 형태로 빼옴
		TIME(NOW());
		
-- DATEDIFF TIMEDIFF
SELECT DATEDIFF(NOW(),SUBDATE(NOW(), INTERVAL 7 DAY));
SELECT DATEDIFF(NOW(),"2025-07-07"); -- 양수값
SELECT DATEDIFF(NOW(),"2026-07-07"); -- 오늘날짜- 미래날짜= 음수
-- D-DAY 구하기 좋음

SELECT TIMEDIFF(CURTIME(),"09:00:00");
SELECT TIMEDIFF(CURTIME(),"18:00:00");

-- 현재날짜 - 입사날짜
SELECT	emp_name,
			hire_date,
			DATEDIFF(CURDATE(), hire_date)
FROM employee;

-- DAYOFWEEK(날짜)
SELECT case DAYOFWEEK(CURDATE())
			when 1	then "일"
			when 2	then "월"
			when 3	then "화"
			when 4	then "수"
			when 5	then "목"
			when 6	then "금"
			when 0	then "토"
END AS "day";

SELECT MONTHNAME(NOW());
SELECT dayofyear(NOW());
SELECT LAST_DAY("2024-02-01");
SELECT LAST_DAY(NOW());

-- makedate() maketime(),period_add() 
-- period_diff() quater(날짜)
SELECT MAKEDATE(2026,177),
		MAKETIME(23,59,59),
		PERIOD_ADD(202606,11), -- 2026.06월에서 11개월 더함
		PERIOD_ADD(202606,202605);
		
SELECT QUARTER(NOW()),
		TIME_TO_SEC(NOW()); -- 00:00:00 기준으로 초를 만들어서 줌



-- 윈도우 함수
-- 순위함수
-- 키큰 순에 따라 순위 이름, 주소, 키
SELECT NAME,
		addr,
		height
from usertbl
ORDER BY height DESC;

SELECT ROW_NUMBER() OVER(ORDER BY height DESC, NAME asc) AS "Rank", -- OVER라는 절이 같이 들어가야함
		NAME,
		addr,
		height
from usertbl;

-- 지역별로 순위를 매겨서 이름 주소 키 조회
-- PARTITION BY 로 파티션에 따라 랭킹을 줄 수 있음
SELECT ROW_NUMBER() OVER(PARTITION BY addr ORDER BY height DESC, name asc) AS "Rank", -- OVER라는 절이 같이 들어가야함
		NAME,
		addr,
		height
from usertbl;


SELECT RANK() OVER(ORDER BY height DESC) AS "Rank", -- rank 만드는데 동순위(2등) 후 4등
		NAME,
		addr,
		height
from usertbl;

SELECT DENSE_RANK() OVER(ORDER BY height DESC) AS "Rank", -- rank 만드는데 동순위(2등) 후 3등
		NAME,
		addr,
		height
from usertbl;

-- 지역별로 순위를 매겨서 이름 주소 키 조회
-- 동일한 순위 이후 등수를 동일한 인원수만큼 건너뛰고 증가
SELECT RANK() OVER(PARTITION BY addr ORDER BY height DESC) AS "Rank", -- rank 만드는데 동순위(2등) 후 4등
		NAME,
		addr,
		height
from usertbl;

-- 지역별로 순위를 매겨서 이름 주소 키 조회
-- 동일한 순위 이후 등수를 이후 1증가
SELECT DENSE_RANK() OVER(PARTITION BY addr ORDER BY height DESC) AS "Rank", -- rank 만드는데 동순위(2등) 후 4등
		NAME,
		addr,
		height
from usertbl;

-- employee 테이블에서 급여가 높은 상위 10명의 순위, 직원명, 급여조회
-- LIMIT 10 사용해서 10명만 가져올 수 있음
SELECT RANK() OVER(ORDER BY salary DESC) AS "rank",
		emp_name,
		salary
FROM employee
LIMIT 10;

-- limit을 못쓰는 경우 서브쿼리로 테이블 만든 후 그 안에서 조회
SELECT emp.rank,
		emp.emp_name,
		emp.salary
FROM(
	SELECT RANK() OVER(ORDER BY salary DESC) AS "rank",
		emp_name,
		salary
	FROM employee
)emp
WHERE emp.rank BETWEEN 1 AND 10;


SELECT NTILE(4) OVER(ORDER BY height DESC) AS "Rank", -- rank 만드는데 동순위(2등) 후 3등
		NAME,
		addr,
		height
FROM usertbl;

SELECT NTILE(3) OVER(ORDER BY height DESC) AS "Rank", -- rank 만드는데 동순위(2등) 후 3등
		NAME,
		addr,
		height
FROM usertbl;


-- 분석함수
-- usertbl 키 순서대로 정렬후 다음 사람과의 키차이 조회
SELECT NAME,
		addr,
		height,
		(height-LEAD(height,1) OVER(ORDER BY height DESC)) -- LEAD() 현재 행의 다음행을 읽음
FROM usertbl;

SELECT NAME,
		addr,
		height,
		(height-LAG(height,1) OVER(ORDER BY height DESC)) -- LAG() 현재행의 이전행을 읽음
FROM usertbl; 

-- usertbl 테이블에서 키 순서대로 조회후 가장 키큰 사람과 키 차이 조회

SELECT NAME,
		addr,
		height,
		(height-FIRST_VALUE(height) OVER(ORDER BY height DESC)) -- 제일 첫번째 값
FROM usertbl; 

SELECT NAME,
		addr,
		height,
		-- 지역별로 가장 키큰사람과의 차이 조회
		(height-FIRST_VALUE(height) OVER(partition by addr ORDER BY height DESC)) -- 제일 첫번째 값
FROM usertbl; 







