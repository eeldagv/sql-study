-- =====================
-- 1. 평균 일일 대여 요금 구하기
-- =====================
-- 문제: CAR_RENTAL_COMPANY_CAR 테이블에서 자동차 종류가 'SUV'인 자동차들의 평균 일일 대여 요금을 출력하는 SQL문을 작성해주세요. 이때 평균 일일 대여 요금은 소수 첫 번째 자리에서 반올림하고, 컬럼명은 AVERAGE_FEE 로 지정해주세요.
-- 내 생각: (1)테이블에서 특정 컬럼만 뽑기 (2)평균 구하기 (3)반올림하기 (4)컬럼명을 임의로 지정하기

SELECT ROUND(AVG(DAILY_FEE), 0) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE='SUV';

-- 배운 것: AS, ROUND(), AVG(), WHERE



-- =====================
-- 2. 인기있는 아이스크림
-- =====================
-- 문제: 상반기에 판매된 아이스크림의 맛을 총주문량을 기준으로 내림차순 정렬하고 총주문량이 같다면 출하 번호를 기준으로 오름차순 정렬하여 조회하는 SQL 문을 작성해주세요.
-- 내 생각: (1)맛 컬럼 데이터를 뽑기 (2)총주문량 기준으로 내림차순 정렬 (3)그 중에서 값이 같다면 출하 번호를 기준으로 오름차순 정렬

SELECT FLAVOR
FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID ASC;

-- 배운 것: ORDER BY 컬럼명 ASC/DESC, 다중정렬