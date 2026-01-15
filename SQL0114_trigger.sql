-- 트리거
-- 삽입 삭제 수정 DML 작업이 발생했을 때 자동으로 작동되는 개체
-- 삽입 삭제 수정 작업 전에 작동하는 트리거 BEFORE 트리거
-- :: 작업 후 작동하는 트리거 AFTER 트리커
-- 트리거는 직접 실행시키지 않음
-- 1. 상품에 대한 데이터를 보관할 테이블 생성
CREATE OR REPLACE TABLE product(
	pcode INT AUTO_INCREMENT PRIMARY KEY, -- 상품 번호
	pname VARCHAR(100),						  -- 상품 이름
	brand VARCHAR(100),						  -- 브랜드 이름
	price INT,									  -- 가격
	stock INT DEFAULT 0,						  -- 상품 재고
	createAt DATE DEFAULT CURDATE()		  -- 상품 등록 날짜
);

INSERT INTO product (pname, brand, price) 
VALUES('아이폰15 프로', '애플', 1200000);

INSERT INTO product (pname, brand, price) 
VALUES('갤럭시 z플립', '삼성', 1500000);

-- 2. 상품 입/출고 이력을 보관할 테이블 생성
CREATE OR REPLACE TABLE product_detail(
	dcode INT AUTO_INCREMENT PRIMARY KEY, 								 -- 입출고 이력 번호
	`status` VARCHAR(2) CHECK(`status` IN('입고', '출고')),		-- 상태
	amount INT,						  								 			 -- 입출고 수량
	pcode INT REFERENCES product(pcode),								 -- 상품 코드 외래키
	createAt DATE DEFAULT CURDATE()		  								 -- 입출고 등록 날짜
);

-- 1번 상품이 2026-01-11 날짜로 10개가 입고
INSERT INTO product_detail (`status`, amount, pcode, createAt) 
VALUES('입고', 10, 1,'2026-01-11');

-- 1번 상품의 재고 수량을 변경해야한다
UPDATE product
SET stock = stock + 10
WHERE pcode = 1;

-- 1번 상품이 2026-01-11 날짜로 5개 출고
INSERT INTO product_detail (`status`, amount, pcode, createAt) 
VALUES('출고', 5, 1,'2026-01-11');

UPDATE product
SET stock = stock - 5
WHERE pcode = 1;

-- 2번 상품이 2026-01-13 날짜로 20개 입고
INSERT INTO product_detail (`status`, amount, pcode, createAt) 
VALUES('입고', 20, 2,'2026-01-13');

-- 2번 상품의 재고 수량 변경
UPDATE product
SET stock = stock + 20
WHERE pcode = 2;


-- product_detail에 데이터 입력시
-- product 테이블에 재고 수량이 자동으로 업데이트 되도록 트리거 생성

DELIMITER $$
CREATE TRIGGER trg_product_stock
AFTER INSERT ON product_detail
FOR EACH ROW  -- 행단위로 실행되도록 함
BEGIN

	-- 상품이 입고된 경우 재고 증가
	IF NEW.status = '입고' THEN -- NEW라는 테이블에 status라는 값이 임시로 생김
		UPDATE product
		SET stock = stock + NEW.amount
		WHERE pcode = NEW.pcode;
	END IF;
	
	-- 상품이 출고된 경우 재고 감소
	IF NEW.status = '출고' THEN
		UPDATE product
		SET stock = stock - NEW.amount
		WHERE pcode = NEW.pcode;
	END IF;
	
END$$

DELIMITER ;

-- 2번 상품이 2026-01-13 날짜로 20개 입고
INSERT INTO product_detail (`status`, amount, pcode, createAt) 
VALUES('입고', 20, 2,'2026-01-13');

-- 2번 상품이 2026-01-14 날짜로 15개 출고
INSERT INTO product_detail (`status`, amount, pcode, createAt) 
VALUES('출고', 15, 2,'2026-01-14');


-- ================== 트리거 단점=====================
-- 트리거는 롤백이 안됨 / 트랜잭션 처리 불가능
-- 트리거 되는 코드가 실행되면 그때 트리거 작동함
-- 만약 코드가 수행되었는데 트리거가 처리되지 않았다면
-- 롤백이 불가능함











