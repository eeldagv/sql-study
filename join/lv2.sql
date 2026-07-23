-- =====================
-- 1. 조건에 맞는 도서와 저자 리스트 출력하기
-- =====================
-- 문제: '경제' 카테고리에 속하는 도서들의 도서 ID(BOOK_ID), 저자명(AUTHOR_NAME), 출판일(PUBLISHED_DATE) 리스트를 출력하는 SQL문을 작성해주세요. 결과는 출판일을 기준으로 오름차순 정렬해주세요.
-- BOOK 테이블 : BOOK_ID, CATEGORY, AUTHOR_ID, PRICE, PUBLISHED_DATE
-- AUTHOR 테이블 : AUTHOR_ID, AUTHOR_NAME
-- PUBLISHED_DATE의 데이트 포맷이 예시(yyyy-mm-dd)와 동일해야 정답처리 됩니다.
-- 내 생각: AUTHOR_ID 컬럼을 이용하여 두 테이블을 JOIN 한다.

-- 정답:
SELECT BOOK_ID, AUTHOR_NAME, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK
JOIN AUTHOR ON BOOK.AUTHOR_ID = AUTHOR.AUTHOR_ID
WHERE CATEGORY = '경제'
ORDER BY PUBLISHED_DATE;

-- 배운 것: 데이트 포맷에 대한 언급이 있다면 명시적으로 날짜 포맷을 써주는 습관이 좋다.



-- =====================
-- 2. 상품 별 오프라인 매출 구하기
-- =====================
-- 문제: PRODUCT 테이블과 OFFLINE_SALE 테이블에서 상품코드 별 매출액(판매가 * 판매량) 합계를 출력하는 SQL문을 작성해주세요. 결과는 매출액을 기준으로 내림차순 정렬해주시고 매출액이 같다면 상품코드를 기준으로 오름차순 정렬해주세요.
-- PRODUCT 테이블 : PRODUCT_ID, PRODUCT_CODE, PRICE
-- OFFLINE_SALE 테이블 : OFFLINE_SALE_ID, PRODUCT_ID, SALES_AMOUNT, SALES_DATE 
-- 내 생각: 우선 두 테이블을 PRODUCT_ID 컬럼으로 JOIN 한다. 

-- 정답:
SELECT PRODUCT_CODE, SUM(PRICE * SALES_AMOUNT) AS SALES
FROM PRODUCT
JOIN OFFLINE_SALE ON PRODUCT.PRODUCT_ID = OFFLINE_SALE.PRODUCT_ID
GROUP BY PRODUCT_CODE
ORDER BY SALES DESC, PRODUCT_CODE;

-- 배운 것: 컬럼끼리 곱할때는 컬럼1 * 컬럼2 로 작성해줄 수 있다.