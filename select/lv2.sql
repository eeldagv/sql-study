-- =====================
-- 1. 3월에 태어난 여성 회원 목록 출력하기
-- =====================
-- 문제: MEMBER_PROFILE 테이블에서 생일이 3월인 여성 회원의 ID, 이름, 성별, 생년월일을 조회하는 SQL문을 작성해주세요. 이때 전화번호가 NULL인 경우는 출력대상에서 제외시켜 주시고, 결과는 회원ID를 기준으로 오름차순 정렬해주세요.
-- MEMBER_PROFILE : MEMBER_ID, MEMBER_NAME, TLNO, GENDER, DATE_OF_BIRTH
-- 내 생각: (1)id, 이름, 성별, 생년월일 데이터를 조회 (2)조건은 생일이 3월이어야 함 (3)전화번호가 null이면 제외 (4)id 기준 오름차순 정렬

-- 오답1:
SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3 AND TLNO IS NOT NULL
ORDER BY MEMBER_ID;
-- 틀린 이유: '여성' 조건이 들어가지 않았다!!

-- 오답2:
SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3 AND GENDER = 'W' AND TLNO IS NOT NULL
ORDER BY MEMBER_ID;
-- 틀린 이유: 날짜 데이터 포맷!!!!!

-- 정답:
SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3 AND GENDER = 'W' AND TLNO IS NOT NULL
ORDER BY MEMBER_ID;

-- 배운 것: 제발 문제를 잘 읽 자. 조건을 잘 확인하자.



-- =====================
-- 2. 재구매가 일어난 상품과 회원 리스트 구하기
-- =====================
-- 문제: ONLINE_SALE 테이블에서 동일한 회원이 동일한 상품을 재구매한 데이터를 구하여, 재구매한 회원 ID와 재구매한 상품 ID를 출력하는 SQL문을 작성해주세요. 결과는 회원 ID를 기준으로 오름차순 정렬해주시고 회원 ID가 같다면 상품 ID를 기준으로 내림차순 정렬해주세요.
-- ONLINE_SALE : ONLINE_SALE_ID, USER_ID, PRODUCT_ID, SALES_AMOUNT, SALES_DATE
-- 동일한 날짜, 회원 ID, 상품 ID 조합에 대해서는 하나의 판매 데이터만 존재합니다.
-- 내 생각: (1)회원 id, 상품 id 조회 (2)회원 id 기준으로 오름차순 정렬, 같다면 상품 id 기준으로 내림차순 정렬 (4)회원 id 하나 당 상품 id가 2개 이상 조회되는 것.. 을 어떻게 표현할까? (5)그 데이터를 어떻게 하나씩만 추출할까? (6)회원 id, 상품 id를 조회하는데, 개수가 2개 이상인 데이터만 조회 (7)그룹화 하고 조건 처리

-- 오답1:
SELECT USER_ID, COUNT(PRODUCT_ID) AS PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID HAVING PRODUCT_ID >= 2
ORDER BY USER_ID, PRODUCT_ID DESC;
-- 틀린 이유: (1)GROUP BY 기준이 빠짐 - 동일한 회원 + 동일한 상품 조합 (2)HAVING 조건이 다름 - HAVING은 그룹화된 결과에 조건을 거는 것이므로 개수를 세는 COUNT를 사용, 즉 COUNT를 SELECT에서 쓰면 안 됨 (3)SELECT로는 조회하고자 하는 데이터만

-- 정답:
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID HAVING COUNT(PRODUCT_ID) >= 2
ORDER BY USER_ID ASC, PRODUCT_ID DESC;

-- 배운 것: GROUP BY는 '유형별'로 개수를 알고 싶을 때 컬럼을 그룹화 하는 데 사용하고 HAVING은 그룹화 된 컬럼에 조건을 걸 때 사용한다.



-- =====================
-- 3. 업그레이드 된 아이템 구하기
-- =====================
-- 문제: 
-- 내 생각: 



-- 배운 것: 



-- =====================
-- 4. 조건에 맞는 개발자 찾기
-- =====================
-- 문제: 
-- 내 생각: 



-- 배운 것: 



-- =====================
-- 5. 특정 물고기를 잡은 총 수 구하기
-- =====================
-- 문제: 
-- 내 생각: 



-- 배운 것: 



-- =====================
-- 6. 부모의 형질을 모두 가지는 대장균 찾기
-- =====================
-- 문제: 
-- 내 생각: 



-- 배운 것: 