-- JOIN UNION
-- inner join
-- 사번, 직원명, 부서코드, 부서명
SELECT e.emp_id, e.emp_name, d.dept_id,d.dept_title
FROM employee e 
INNER JOIN department d ON e.dept_code = d.dept_id;

SELECT  e.emp_id, e.emp_name, d.dept_id,d.dept_title
FROM employee e RIGHT OUTER JOIN department d ON e.dept_code = d.dept_id;

SELECT  e.emp_id, e.emp_name, d.dept_id,d.dept_title
FROM employee e LEFT OUTER JOIN department d ON e.dept_code = d.dept_id;

-- 각 사원들의 사번, 직원명, 직급코드, 직급명
-- 연결할 테이블의 이름이 같은 경우 어떤 테이블의 것인지 명시해주면됨
SELECT e.emp_id, e.emp_name, j.job_code, j.job_name
FROM job j 
INNER JOIN employee e ON e.job_code=j.job_code;

-- natural join 실무에서 잘 사용 안함
SELECT 	emp_id,
			emp_name,
			job_code,
			job_name
FROM employee NATURAL JOIN job;

-- usertbl에서 buytbl 조인 
-- jyp라는 id를 가진 회원의 이름 주소, 연락처, 주문상품
SELECT 	u.name,u.addr,	
			CONCAT_WS("-",u.mobile1,u.mobile2,u.mobile3) AS "phone",
			b.prodName
from usertbl u 
INNER JOIN buytbl b ON u.userID  = b.userID	-- 조인조건
WHERE u.userID="JYP";	-- 검색조건

-- 실습 문제
-- employee 테이블과 department 테이블을 조인하여 
-- 보너스를 받는 사원들의 사번, 직원명, 보너스, 부서명을 조회
SELECT e.emp_id, 
		 e.emp_name, 
		 e.bonus,
		 d.dept_title
FROM employee e 
INNER JOIN department d ON e.dept_code = d.dept_id
WHERE e.bonus IS NOT NULL;


-- employee 테이블과 department 테이블을 조인하여 
-- 인사관리부가 아닌 사원들의 직원명, 부서명, 급여를 조회
SELECT e.emp_name, 
		 d.dept_title,
		 e.salary
FROM employee e 
INNER JOIN department d ON e.dept_code = d.dept_id
WHERE d.dept_title != "인사관리부";

-- employee 테이블과 department 테이블, job 테이블을 조인하여 
-- 사번, 직원명, 부서명, 직급명 조회

SELECT 	e.emp_id,
			e.emp_name,
			d.dept_title,
			j.job_name
FROM employee e 
INNER JOIN department d ON e.dept_code = d.dept_id  -- employee와 department 먼저 조인
INNER JOIN job j ON e.job_code = j.job_code; -- 그 후 job 조인

-- outer join 실습 
-- left는 왼쪽 데이터(조건에 만족하지 않음) 다 보여줌
-- 부서코드 없는 애들이 조회됨
-- outer 생략 가능
SELECT  e.emp_name,
		  d.dept_title,
		  e.salary
FROM employee e 
LEFT OUTER JOIN department d ON e.dept_code = d.dept_id;

-- right는 오른쪽  데이터(조건에 만족하지 않음) 다 보여줌
-- 사원이 없는 부서들도 출력이 됨
SELECT  e.emp_name,
		  d.dept_title,
		  e.salary
FROM employee e 
RIGHT OUTER JOIN department d ON e.dept_code = d.dept_id
ORDER BY e.emp_id;

-- cross join
SELECT e.emp_name,
		 d.dept_title
FROM employee e
CROSS JOIN department d;

-- self join employee
SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 m.emp_id,
		 m.emp_name
FROM employee e
INNER JOIN employee m ON e.manager_id=m.emp_id;

-- NON EQUAL JOIN 실습
-- 조인 조건에 등호를 사용하지 않는 조인을 비등가조인 이라고 함
-- inner join으로 찾을 수 없는 경우 left outer나 where 조건으로 처리함
SELECT e.emp_name,
		 e.salary,
		 s.sal_level
FROM employee e
INNER JOIN sal_grade s ON e.salary BETWEEN s.min_sal AND s.max_sal;



-- 실습 문제
-- 이름에 '형'자가 들어있는 직원들의 사번, 직원명, 직급명을 조회하세요.
SELECT e.emp_no,
		 e.emp_name,
		 j.job_name
FROM employee e
INNER JOIN department d ON e.dept_code=d.dept_id
INNER JOIN job j ON e.job_code = j.job_code 
WHERE e.emp_name LIKE "%형%";


-- 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 직원명, 주민번호, 부서명, 직급명을 조회하세요.
SELECT e.emp_name,
		 e.emp_no,
		 d.dept_title,
		 j.job_name
FROM employee e
INNER JOIN department d ON e.dept_code = d.dept_id
INNER JOIN job j ON e.job_code = j.job_code
WHERE e.emp_no LIKE "7%" 
AND SUBSTRING(emp_no,8,1) IN ("2")
AND e.emp_name LIKE ("전%");


-- 각 부서별 평균 급여를 조회하여 부서명, 평균 급여를 조회하세요.
-- 단, 부서 배치가 안된 사원들의 평균도 같이 나오게끔 조회해 주세요.
-- 10원 단위 기준으로 반올림함
SELECT IFNULL(d.dept_title,"부서없음"),
		 ROUND(AVG(e.salary),-1) AS ",avg"
FROM employee e
LEFT OUTER JOIN department d ON e.dept_code=d.dept_id
GROUP BY (d.dept_id);


-- 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회하세요.
SELECT d.dept_title,
		 SUM(e.salary) AS sumSalary
FROM employee e
LEFT OUTER JOIN department d ON e.dept_code = d.dept_id
GROUP BY (d.dept_id) HAVING sumSalary >= 10000000 ;


-- 해외영업팀에 근무하는 직원들의 직원명, 직급명, 부서 코드, 부서명을 조회하세요.
SELECT e.emp_name,
		 j.job_name,
		 d.dept_id,
		 d.dept_title
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
INNER JOIN department d ON e.dept_code = d.dept_id
INNER JOIN location l ON d.location_id = l.local_code
INNER JOIN national n ON l.national_code = n.national_code
WHERE d.dept_title LIKE "해외영업%";


-- 테이블을 다중 JOIN 하여 사번, 직원명, 부서명, 지역명, 국가명 조회하세요.
SELECT e.emp_id,
		 e.emp_name,
		 d.dept_title,
		 l.local_name,
		 n.national_name
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
INNER JOIN department d ON e.dept_code = d.dept_id
INNER JOIN location l ON d.location_id = l.local_code
INNER JOIN national n ON l.national_code = n.national_code;


-- 테이블을 다중 JOIN 하여 사번, 직원명, 부서명, 지역명, 국가명, 급여 등급 조회하세요.
SELECT e.emp_id,
		 e.emp_name,
		 d.dept_title,
		 l.local_name,
		 n.national_name,
		 s.sal_level
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
INNER JOIN department d ON e.dept_code = d.dept_id
INNER JOIN location l ON d.location_id = l.local_code
INNER JOIN national n ON l.national_code = n.national_code
INNER JOIN sal_grade s ON e.salary BETWEEN s.min_sal AND s.max_sal;


-- 부서가 있는 직원들의 직원명, 직급명, 부서명, 지역명을 조회하세요.
SELECT e.emp_name,
		 j.job_name,
		 d.dept_title,
		 l.local_name
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
INNER JOIN department d ON e.dept_code = d.dept_id
INNER JOIN location l ON d.location_id = l.local_code;


-- 한국과 일본에서 근무하는 직원들의 직원명, 부서명, 지역명, 근무 국가를 조회하세요.
SELECT e.emp_name,
		 d.dept_title,
		 l.local_name,
		 n.national_name
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
INNER JOIN department d ON e.dept_code = d.dept_id
INNER JOIN location l ON d.location_id = l.local_code
INNER JOIN national n ON l.national_code = n.national_code
WHERE n.national_name IN ("한국","일본");























