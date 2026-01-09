-- 서브쿼리 실습
-- 하나의 SQL 구문 안에 포함된 또 다른 sql 구문을 서브 쿼리라고 한다

-- 서브쿼리 예시
-- 노홍철 사원과 같은 부서원을 조회

SELECT *
FROM employee e
WHERE e.dept_code IN
	(SELECT dept_code 
		FROM employee
		WHERE emp_name = '노옹철');

SELECT emp_name,
		 dept_code
FROM employee 
WHERE dept_code = (
		SELECT dept_code 
		FROM employee
		WHERE emp_name = '노옹철'
);

-- 서브쿼리 구분
-- 서브쿼리는 서브쿼리를 수행한 행과 열의 개수에 따라 분류할 수 있다.

-- 1. 단일 행 서브 쿼리
-- 서브쿼리의 결과값의 개수가 1개일 떄
-- 전직원의 평균 급여보다 더 많은 급여를 받고있는 직원들의 사번, 직원명, 직급코드, 급여

SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE salary >= (
	SELECT AVG(salary)
	FROM employee
);

-- 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 직원명, 부서명, 급여
-- 부서가 없는 사원들도 조회해야 하니 outer 조인 써야함
SELECT e.emp_id,
		 e.emp_name,
		 d.dept_title,
		 e.salary
FROM employee e
LEFT OUTER JOIN department d ON e.dept_code = d.dept_id
WHERE e.salary >= (
	SELECT salary
	FROM employee
	WHERE emp_name = '노옹철'
);

-- 부서별 급여의 합이 가장 큰 부서의 부서코드 급여의 합
SELECT dept_code,
		 SUM(salary)
FROM employee e
GROUP BY dept_code
ORDER BY SUM(salary) DESC
LIMIT 1;

-- 2. 다중 행 서브쿼리
-- 서브쿼리의 결과값의 개수가 여러 행일 때 => in 연산자 사용해서 집합으로 처리해야함
-- 각 부서별 최고 급여를 받는 직원의 이름, 직급 코드, 부서코드, 급여조회
SELECT emp_name,
		 job_code,
		 dept_code,
		 salary
FROM employee
WHERE salary IN (
	SELECT MAX(salary)
	FROM employee
	GROUP BY dept_code
)
ORDER BY salary DESC;

-- 직원들의 사번, 직원명, 부서코드, 사원/사수 구분

-- 1) 사수에 해당하는 사번인지 조회
SELECT DISTINCT(manager_id)
FROM employee
WHERE manager_id IS NOT NULL;

-- 직원들 조회
-- select 절에서 서브쿼리 사용 예시
SELECT emp_id,
		 emp_name,
		 dept_code,
		 CASE
		 	WHEN emp_id IN(
			 	SELECT DISTINCT(manager_id)
				FROM employee
				WHERE manager_id IS NOT NULL)
			THEN '사수'
			ELSE '사원'
			END AS 'result'
FROM employee;
		 
-- 대리직급인데 과장직급보다 많이 받는 직원의 사번, 이름, 직급코드, 급여
SELECT MIN(salary)
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
WHERE j.job_name = '과장';

-- any를 사용하면 집합의 값중 어느 하나라도 맞으면 true
SELECT e.emp_id,
		 e.emp_name,
		 e.salary
FROM employee e
INNER JOIN job j ON e.job_code = j.job_code
WHERE j.job_name = '대리' 
AND e.salary > ANY (
		SELECT salary
		FROM employee e
		INNER JOIN job j ON e.job_code = j.job_code
		WHERE j.job_name = '과장'
);

--과장 직급임에도 차작 직급의 최대 급여보다 더 많이 박는
-- 직원의 사번, 이름, 직급코드, 급여 조회
-- all은 서브쿼리의 결과 모두가 조건을 만족하면 참이 된다.
SELECT e.emp_id,
		 e.emp_name,
		 e.salary
FROM employee e
INNER JOIN job j ON e.job_code=j.job_code
WHERE j.job_name='과장'
AND e.salary > ALL(
	SELECT salary
	FROM employee e
	INNER JOIN job j ON e.job_code = j.job_code
	WHERE j.job_name = '차장'
);

-- 한번이라도 구매한 적이 있는 회원의 아이디, 이름, 주소
-- EXISTS 연산자 사용
-- 서브쿼리에 결과가 한 건이라도 존재하면 참
-- 원래는 서브쿼리 먼저 실행해야함
-- exists는 처음부터 실행됨
SELECT DISTINCT(u.userID), 
		 u.`name`,
		 u.addr
FROM usertbl u
WHERE EXISTS(
	SELECT *
	FROM buytbl b
	WHERE b.userID = u.userID
);
-- 참고 join 활용
SELECT DISTINCT(u.userID), 
		 u.`name`,
		 u.addr
FROM usertbl u
RIGHT OUTER JOIN buytbl b ON u.userID = b.userID;


-- 3. 다중 열 서브 쿼리
-- 서브쿼리의 결과 값이 행은 하나지만 열은 여러개일 떄 
-- 하이유 사원이랑 같은 부서코드를 가지고 같은 직급 코드를 가진 사원들 조회

SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 j.job_code
FROM employee e
INNER JOIN job j ON e.job_code=j.job_code
WHERE (e.emp_name, e.job_code) IN (
	SELECT emp_name, 
			 job_code
	FROM employee
	WHERE emp_name = '하이유' 
	OR job_code = (
		SELECT j.job_code 
		FROM job j
		INNER JOIN employee e ON j.job_code = e.job_code
		WHERE e.emp_name = '하이유'
	)
);

SELECT emp_id,
		 emp_name,
		 dept_code,
		 job_code
FROM employee
-- WHERE (dept_code, job_code) IN (('D5','J5'));
WHERE (dept_code, job_code) IN (
	SELECT dept_code, 
			 job_code
	FROM employee
	WHERE emp_name = '하이유'
);

-- 박나라 사원과 직급 코드가 일치하면서 같은 사수를 가지고 있는 
-- 사원들의 사본 직원명, 직급코드, 사수 사번

-- 1) 박나라 사원의 직급코드와 사수 사번조회
-- (dept_code, manager_id) = (J7, 207)
SELECT dept_code,
		 manager_id
FROM employee
WHERE emp_name = '박나라';

-- 2) 박나라 사원과 직급코드가 일치하면서 같은 사슈를 가지고 있는 사원 조회 
-- = 등호가 가능한 이유는 값이 하나이기 때문
-- where절 서브쿼리의 값이 여러개면 in 사용해야함
SELECT emp_name,
		 dept_code,
		 manager_id
FROM employee e
WHERE (dept_code, manager_id) = (
	SELECT dept_code,
		 manager_id
	FROM employee
	WHERE emp_name = '박나라'
);
		 

-- 4. 다중 행, 다중 열 서브쿼리
-- 서브쿼리의 결과값이 행과 열이 여러개 일 때

-- 각 부서별 최고 급여를 받는 직원의 사번, 직원명, 부서코드, 급여조회
-- 1) 부서별 최고 급여
SELECT dept_code,
		 MAX(salary)
FROM employee
GROUP BY dept_code;

2)직원의 사번, 직원명, 부서코드, 급여조회
-- in 연산자도 결국 동등비교함.
-- 만약 null값이 들어오면 null은 =등호로 비교불가
-- 따라서 검색에서 제외됨

SELECT emp_id,
		 emp_name,
		 dept_code,
		 salary
FROM employee
WHERE (dept_code, salary) IN (
	SELECT dept_code,
		 	 MAX(salary)
	FROM employee
	GROUP BY dept_code
)
ORDER BY dept_code;

-- null 처리 방법
-- ifnull을 사용하여 부서없음으로 처리
SELECT emp_id,
		 emp_name,
		 IFNULL(dept_code, '부서없음'),
		 salary
FROM employee
WHERE (IFNULL(dept_code, '부서없음'), salary) IN (
	SELECT IFNULL(dept_code, '부서없음'),
		 	 MAX(salary)
	FROM employee
	GROUP BY dept_code
)
ORDER BY dept_code;

-- 각 직급별 최소 급여를 받는 직원의 사번, 직원명, 직급코드, 급여조회
-- 1) 각 직급별 최소 급여 조회
SELECT job_code,
		 MIN(salary)
FROM employee
GROUP BY job_code;


--2) 각 직급별 최소급여를 받는 사원을 조회
SELECT emp_name,
		 emp_id,
		 job_code,
		 salary
FROM employee
WHERE (job_code, salary) IN (
	SELECT job_code,
		 MIN(salary)
	FROM employee
	GROUP BY job_code
)
ORDER BY job_code;

-- 인라인 뷰
-- from 절에 서브쿼리를 작성하고 서브쿼리를 수행한 결과를 테이블 대신 사용
SELECT emp.'사번',
		 emp.'이름',
		 emp.'월급',
		 emp.'연봉'
FROM (
	SELECT emp_id AS '사번',
			 emp_name AS '이름',
			 salary AS '월급',
			 salary*12 AS '연봉'
	FROM employee
) AS emp;















