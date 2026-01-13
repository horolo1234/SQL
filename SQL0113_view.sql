-- 뷰 실습
-- 뷰는 가상의 테이블, 실제 데이터가 담겨있는 것은 아니다.
-- 1. 뷰 생성
-- 사원들의 사번, 직원명, 부서명, 직급명, 입사일 조회
CREATE VIEW v_employee
AS SELECT e.emp_id,
		 	 e.emp_name,
		 	 d.dept_title,
		 	 j.job_name,
		 	 e.hire_date
FROM employee e
LEFT OUTER JOIN department d ON e.dept_code = d.dept_id
LEFT OUTER JOIN job j ON e.job_code =  j.job_code;

SELECT * 
FROM v_employee;

-- 부서가 없는 사원의 모든 데이터 조회
SELECT *
FROM v_employee
WHERE dept_title IS NULL;



-- 사원의 사번, 직원명, 성별, 급여
-- IF(조건, 참일때 출력, 거짓일 때 출력 )
-- 이름이 같으면 안만들어짐 (create인 경우)
-- create or replace 존재하면 덮어쓰고 없으면 새로 만들어짐
CREATE OR REPLACE VIEW v_employee
AS SELECT emp_id,
		 	 emp_name,
		 	 IF(SUBSTRING(emp_no,8,1) = '1', '남자', '여자') AS 'gender',
		 	 salary
FROM employee;

-- select 구문에 함수나 산술 연산이 기술되는 경우 별칭 지정해야함
SELECT emp_id,
		 gender
FROM v_employee;

-- 2. view 수정
-- 회원의 아이디, 이름, 구매제품, 주소, 연락처를 조회
CREATE VIEW v_userbuytbl
AS SELECT u.userID,
		 u.`name`,
		 b.prodName,
		 u.addr,
		 CONCAT_WS('-', u.mobile1, u.mobile2, u.mobile3)
FROM usertbl u
INNER JOIN buytbl b ON u.userID = b.userID;

-- alter 구문으로 view 수정
ALTER VIEW v_userbuytbl
AS SELECT u.userID,
		 	 u.`name`,
		 	 b.prodName,
		 	 u.addr,
		 	 CONCAT_WS('-', u.mobile1, u.mobile2, u.mobile3) AS mobile
	FROM usertbl u
	INNER JOIN buytbl b ON u.userID = b.userID;
	

SELECT *
FROM v_userbuytbl
WHERE `name` = '김범수';

-- 3. 뷰를 이용한 DML(insert, update, delete) 실습
CREATE VIEW v_job
AS SELECT *
	FROM job;
	

-- select
SELECT job_code,
		 job_name
FROM v_job;

-- INSERT
INSERT INTO v_job
VALUES ('j8','알바');

-- UPDATE 여러개 수정 가능
UPDATE v_job SET job_name = '인턴' , job_code = 'J8'
WHERE job_code = 'j8'; 

-- DELETE
DELETE
FROM v_job
WHERE job_code = 'J8';


-- 4. DML 조작이 불가능한 경우
-- 1) 뷰의 정의에 포함되지 않은 열을 조작하는 경우
CREATE OR REPLACE VIEW v_job
AS SELECT job_code
	FROM job;
	
-- select
SELECT * FROM v_job;

-- insert job_name 없어서 insert 안됨
INSERT INTO v_job VALUES ('J8', '알바');

-- update job_name이 없어서 업데이트 안됨
UPDATE v_job SET job_name = '인턴' , job_code = 'J8'
WHERE job_code = 'j8';

-- delete job_name이 없어서 업데이트 안됨
DELETE                
FROM v_job            
WHERE job_name = '사원';


-- 2) 산술연산으로 정의된 열을 조작하는 경우
-- 직원들의 사번, 이름, 주민번호, 연봉 조회 뷰
CREATE OR REPLACE VIEW v_emp_salary
AS SELECT emp_id,
		 	 emp_name,
		 	 emp_no,
		 	 salary *12 AS 'salary'
	FROM employee;

-- select
SELECT * FROM v_emp_salary;

-- insert
-- 산술 연산으로 정의된 컬럼은 데이터 삽입 불가능
INSERT INTO v_emp_salary
VALUES ('300', '홍길동', '260113-3334444',50000000);

INSERT INTO v_emp_salary (emp_id, emp_name, emp_no)
VALUES ('300', '홍길동', '260113-3334444');

-- update
-- column 'salary' not updatable
-- salary는 내가 만든 가상의 열
-- 산술연산으로 정의되지 않은 나머지 열들은 업데이트 가능
UPDATE v_emp_salary
SET salary = 50000000
WHERE emp_name = '홍길동';

-- delete
-- 쿼리 실행이 됨
-- 산술연산으로 정의된 컬럼을 조건으로 사용해서 데이터 삭제 가능
-- min, max, distinct 등 뷰에서 DML 조작 안됨
DELETE
FROM v_emp_salary
WHERE salary = 57600000;


-- 5. WITH CHECK OPTION
-- 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류발생
CREATE OR REPLACE VIEW v_employee
AS SELECT *
	FROM employee
	WHERE salary >= 3000000
WITH CHECK OPTION;
	
-- view로 값 변경하면 실제 테이블의 값도 변경됨
-- WITH CHECK OPTION으로 인해 변경안됨 200만원 이하
UPDATE v_employee
SET salary = 2000000
WHERE emp_id = '200';	

-- 선동일의 급여가 4,000,000원일 경우 가능
-- check option에 부합하기 때문에 400만원으로 업데이트 가능
UPDATE v_employee
SET salary = 4000000
WHERE emp_id = '200';	

SELECT * FROM v_employee;



-- 6. view 삭제
DROP VIEW v_userbuytbl;
DROP VIEW v_job, v_emp_salary, v_employee;









