-- union
-- employee 테이브렝서 부서코드가 d5인 사원들의 사번, 직원명, 부서코드, 급여 조회

-- employee 테이블에서 급여가 300만원 초과인 사원들의 사번, 직원명, 부서코드, 급여 조회

SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 e.salary
FROM employee e
WHERE e.dept_code = 'D5'

UNION

SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 e.salary
FROM employee e
WHERE e.salary > 3000000;

-- union all
SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 e.salary
FROM employee e
WHERE e.dept_code = 'D5'

UNION ALL -- 중복된 행까지 조회함

SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 e.salary
FROM employee e
WHERE e.salary > 3000000
ORDER BY emp_id;
-- union은 조회하는 요소의 순서가 중요함(둘이 같아야함)


-- union 대신 where 절에 or 조합해서 사용해도 같은 결과 만들 수 있음
SELECT e.emp_id,
		 e.emp_name,
		 e.dept_code,
		 e.salary
FROM employee e
WHERE e.dept_code = 'D5' OR e.salary > 3000000
ORDER BY emp_id;












