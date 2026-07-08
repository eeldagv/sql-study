-- =====================
-- 1. 성분으로 구분한 아이스크림 총 주문량 
-- =====================
-- 문제: 상반기 동안 각 아이스크림 성분 타입과 성분 타입에 대한 아이스크림의 총주문량을 총주문량이 작은 순서대로 조회하는 SQL 문을 작성해주세요. 이때 총주문량을 나타내는 컬럼명은 TOTAL_ORDER로 지정해주세요.
-- FIRST_HALF 상반기 주문 정보 테이블 : SHIPMENT_ID 출하 번호, FLAVOR 맛, TOTAL_ORDER 총주문량
-- ICECREAM_INFO 성분 정보 테이블 : FLAVOR 아이스크림 맛, INGREDIENT_TYPE 주 성분
-- ICECREAM_INFO 테이블의 FLAVOR는 FIRST_HALF 테이블의 FLAVOR의 외래키
-- 내 생각: 
-- (1) 아이스크림 성분 타입 별로 총 주문량을 구하고, 이것을 오름차순으로 조회 -> 타입별 총 주문량은 계산을 한 결과로 행이 줄어드는 것이므로 GROUP BY를 사용
-- (2) 집계에 필요한 컬럼이 각 테이블에 있으므로 두 테이블을 JOIN 해야함

-- 정답:
SELECT INGREDIENT_TYPE, SUM(TOTAL_ORDER) AS TOTAL_ORDER
FROM FIRST_HALF
JOIN ICECREAM_INFO ON FIRST_HALF.FLAVOR = ICECREAM_INFO.FLAVOR
GROUP BY INGREDIENT_TYPE
ORDER BY TOTAL_ORDER;



-- =====================
-- 2. 진료과별 총 예약 횟수 출력하기
-- =====================
-- 문제: APPOINTMENT 테이블에서 2022년 5월에 예약한 환자 수를 진료과코드 별로 조회하는 SQL문을 작성해주세요. 이때, 컬럼명은 '진료과 코드', '5월예약건수'로 지정해주시고 결과는 진료과별 예약한 환자 수를 기준으로 오름차순 정렬하고, 예약한 환자 수가 같다면 진료과 코드를 기준으로 오름차순 정렬해주세요.
-- APPOINTMENT 진료 예약정보 테이블 : APNT_YMD 진료예약 일시, APNT_NO 진료예약번호, PT_NO 환자번호, MCDP_CD 진료과코드, MDDR_ID 의사ID, APNT_CNCL_YN 예약취소여부, APNT_CNCL_YMD 예약취소날짜
-- 내 생각: 
-- (1) 5월에 예약한 총 건수를 세어야 하므로 COUNT 사용
-- (2) 진료과코드 별로 묶어야 하므로 GROUP BY
-- 진료예약 일시가 2022년 5월인 예약 정보를 추출 -> 거기서 진료과코드별로 묶음 -> 예약'건수'도 진료과별로 COUNT 해야함

-- 정답:
SELECT MCDP_CD AS 진료과코드, COUNT(*) AS 5월예약건수
FROM APPOINTMENT
WHERE MONTH(APNT_YMD) = 5
GROUP BY MCDP_CD
ORDER BY 5월예약건수, 진료과코드;

-- 배운 것: 답을 써놓고도 계속 오답이라고 떠서 삽질을 했는데.. 원인은 alias 때문이었다.
-- 그동안 alias를 쓰면서 영어일 때는 자연스럽게 그냥 썼는데, 한글이라 그런지 무의식중에 따옴표 안에 썼다.
-- alias는 따옴표 안에 쓰면 안 된다. 따옴표 안에 쓰면 그냥 문자열 값이 되기 때문이다.. 
-- 만약 공백이 들어간다면 작은 따옴표가 아니라 반드시 큰 따옴표를 사용해야 한다.



-- =====================
-- 3. 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- =====================
-- 문제: CAR_RENTAL_COMPANY_CAR 테이블에서 '통풍시트', '열선시트', '가죽시트' 중 하나 이상의 옵션이 포함된 자동차가 자동차 종류 별로 몇 대인지 출력하는 SQL문을 작성해주세요. 이때 자동차 수에 대한 컬럼명은 CARS로 지정하고, 결과는 자동차 종류를 기준으로 오름차순 정렬해주세요.
-- CAR_RENTAL_COMPANY_CAR 대여중인 자동차 정보 테이블 : CAR_ID 자동차 ID, CAR_TYPE 자동차 종류, DAILY_FEE 일일 대여 요금(원), OPTIONS 자동차 옵션
-- 내 생각: 
-- (1) 자동차 종류에 따라 GROUP BY로 묶고, 몇 대인지 COUNT
-- (2) 하나 이상의 옵션이 포함 = 셋 중 하나만 포함되어도 OK -> IN으로 조건

-- 정답:
SELECT CAR_TYPE, COUNT(*) AS CARS
FROM CAR_RENTAL_COMPANY_CAR
WHERE FIND_IN_SET('통풍시트', OPTIONS)
    OR FIND_IN_SET('열선시트', OPTIONS)
    OR FIND_IN_SET('가죽시트', OPTIONS)
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE;

-- 배운 것: 컬럼의 각 행을 돌면서 어떤 값이 하나 이상 포함되어 있는지 찾을 때는 IN을 썼는데, 만약 어떤 문자열 안에서 특정한 값을 찾고 싶을 때는 LIKE를 쓴다.
컬럼 LIKE '찾는값'
-- 이 때 '%찾는값%' 과 같은 형태로 와일드카드를 쓴다면 찾는값 앞뒤로 다른 문자열이 붙을 수 있다.
-- 예를 들어, '%순대%'를 찾는다면 '순대' 말고도 '찰순대'도 찾게 되는 것이다.
-- 만약 콤마로 구분되어 있는 문자열 안에서 특정 값을 찾고 싶다면 FIND_IN_SET이 더 안정적이다.
FIND_IN_SET('찾는값', 컬럼)
-- 찾는 값이 여러개일 때 여러개 중 하나라면 OR로 이어주고, 여러개 모두 포함이라면 AND로 이어준다.


-- =====================
-- 4. 고양이와 개는 몇 마리 있을까
-- =====================
-- 문제: 동물 보호소에 들어온 동물 중 고양이와 개가 각각 몇 마리인지 조회하는 SQL문을 작성해주세요. 이때 고양이를 개보다 먼저 조회해주세요.
-- ANIMAL_INS 동물 정보 테이블 : ANIMAL_ID 동물의 아이디, ANIMAL_TYPE 생물 종, DATETIME 보호 시작일, INTAKE_CONDITION 보호 시작 시 상태, SEX_UPON_INTAKE 성별 및 중성화 여부
-- 내 생각: ANIMAL_TYPE으로 GROUP BY 하고 COUNT, ANIMAL_TYPE을 오름차순으로 정렬한다.

SELECT ANIMAL_TYPE, COUNT(*)
FROM ANIMAL_INS
GROUP BY ANIMAL_TYPE
ORDER BY ANIMAL_TYPE;



-- =====================
-- 5. 동명 동물 수 찾기
-- =====================
-- 문제: 동물 보호소에 들어온 동물 이름 중 두 번 이상 쓰인 이름과 해당 이름이 쓰인 횟수를 조회하는 SQL문을 작성해주세요. 이때 결과는 이름이 없는 동물은 집계에서 제외하며, 결과는 이름 순으로 조회해주세요.
-- ANIMAL_INS 동물 정보 테이블 : ANIMAL_ID 동물의 아이디, ANIMAL_TYPE 생물 종, DATETIME 보호 시작일, INTAKE_CONDITION 보호 시작 시 상태, NAME 이름, SEX_UPON_INTAKE 성별 및 중성화 여부
-- 내 생각: NAME으로 GROUP BY 하고 COUNT, NAME으로 ORDER BY, 두 번 이상 쓰였다는 조건이 있으므로 HAVING으로 조건을 걸어준다.

-- 오답:
SELECT NAME, COUNT(*)
FROM ANIMAL_INS
GROUP BY NAME
HAVING COUNT(*) >= 2
ORDER BY NAME;
-- 틀린 이유: 이름이 없는 동물 = 값이 NULL인 행은 집계에서 제외해야 하는데, *로 COUNT하면 NULL을 포함한 모든 행의 개수를 센다. 컬럼명으로 COUNT해야 NULL을 제외한 행의 개수를 집계한다.

-- 정답:
SELECT NAME, COUNT(NAME)
FROM ANIMAL_INS
GROUP BY NAME
HAVING COUNT(NAME) >= 2
ORDER BY NAME;

-- 배운 것: [복기] COUNT에서 괄호 안에 들어갈 수 있는 것은 *, 컬럼명, DISTINCT 컬럼명인데 *는 NULL을 포함한 모든 행의 개수를, 컬럼명은 NULL을 제외한 행의 개수를, DISTINCT 컬럼명은 중복을 제거한 개수를 집계한다.



-- =====================
-- 6. 입양 시각 구하기(1)
-- =====================
-- 문제: 보호소에서는 몇 시에 입양이 가장 활발하게 일어나는지 알아보려 합니다. 09:00부터 19:59까지, 각 시간대별로 입양이 몇 건이나 발생했는지 조회하는 SQL문을 작성해주세요. 이때 결과는 시간대 순으로 정렬해야 합니다.
-- ANIMAL_OUTS 입양 보낸 동물 정보 테이블 : ANIMAL_ID 동물의 아이디, ANIMAL_TYPE 생물 종, DATETIME 보호 시작일, NAME 이름, SEX_UPON_OUTCOME 성별 및 중성화 여부
-- 내 생각: '시간' = HOUR로 GROUP BY해서 COUNT, 오름차순으로 ORDER BY

SELECT HOUR(DATETIME) AS HOUR, COUNT(*) AS COUNT
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) BETWEEN 9 AND 20
GROUP BY HOUR(DATETIME)
ORDER BY HOUR(DATETIME);



-- =====================
-- 7. 가격대 별 상품 개수 구하기
-- =====================
-- 문제: PRODUCT 테이블에서 만원 단위의 가격대 별로 상품 개수를 출력하는 SQL 문을 작성해주세요. 이때 컬럼명은 각각 컬럼명은 PRICE_GROUP, PRODUCTS로 지정해주시고 가격대 정보는 각 구간의 최소금액(10,000원 이상 ~ 20,000 미만인 구간인 경우 10,000)으로 표시해주세요. 결과는 가격대를 기준으로 오름차순 정렬해주세요.
-- PRODUCT 테이블 : PRODUCT_ID 상품 ID, PRODUCT_CODE 상품코드, PRICE 판매가
-- 상품 별로 중복되지 않는 8자리 상품코드 값을 가지며 앞 2자리는 카테고리 코드를 나타냅니다.
-- 내 생각: 
-- (1) 상품코드는 중요하지 않음
-- (2) 묶는 기준이 '가격' 인데, 조건이 '범위'로 걸려있음, 이 '범위' 조건을 어떻게 작성할 것인가
-- (3) 서브쿼리를 사용해서 범위를 나눠줘야 하나?

SELECT
    FLOOR(PRICE/10000) * 10000 AS PRICE_GROUP,
    COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY FLOOR(PRICE/10000)
ORDER BY FLOOR(PRICE/10000);

-- 배운 것: FLOOR는 테이블에 존재하지 않는 가상의 기준으로 데이터를 묶을 때 사용하는 함수 중 하나이다.
-- GROUP BY와 함께 사용할 때, 연속적인 숫자 데이터(연령, 가격, 점수 등)를 동일한 크기의 일정한 구간으로 범주화할 때 사용한다.
-- 메커니즘은 다음과 같다. 예를 들어, 만원 단위로 상품을 묶고 싶다고 한다면,
-- (1) 나눗셈: PRICE/10000 <- 단위를 낮춘다. (ex. 25,600원 -> 2.56)
-- (2) 내림(FLOOR): 소수점을 버려 그룹 번호를 만든다. (ex. 2.56 -> 2)
-- (3) 그룹화(GROUP BY): 같은 정수 결과(2)를 가진 행들을 하나의 그룹으로 묶는다.
-- (4) 복원: 보기 좋게 출력하기 위해 다시 10000을 곱한다. (ex. 2 * 10000 -> 20000원대)
-- 이 외에도 숫자의 불규칙한 구간 분할 뿐만 아니라 문자열, 날짜, 여러 컬럼의 조합 등 사용자가 정의한 비즈니스 로직에 따라 그룹을 생성할 때 사용하는 CASE도 있는데, 사용할 때 자세히 다뤄보기로 하자!



-- =====================
-- 8. 조건에 맞는 사원 정보 조회하기
-- =====================
-- 문제: HR_DEPARTMENT, HR_EMPLOYEES, HR_GRADE 테이블에서 2022년도 한해 평가 점수가 가장 높은 사원 정보를 조회하려 합니다. 2022년도 평가 점수가 가장 높은 사원들의 점수, 사번, 성명, 직책, 이메일을 조회하는 SQL문을 작성해주세요. 2022년도의 평가 점수는 상,하반기 점수의 합을 의미하고, 평가 점수를 나타내는 컬럼의 이름은 SCORE로 해주세요.
-- HR_DEPARTMENT 부서 정보 테이블 : DEPT_ID 부서 ID, DEPT_NAME_KR 국문 부서명, DEPT_NAME_EN 영문 부서명, LOCATION 부서 위치
-- HR_EMPLOYEES 사원 정보 테이블 : EMP_NO 사번, EMP_NAME 성명, DEPT_ID 부서 ID, POSITION 직책, EMAIL 이메일, COMP_TEL 전화번호, HIRE_DATE 입사일, SAL 연봉
-- HR_GRADE 2022년 사원 평가 정보 테이블 : EMP_NO 사번, YEAR 연도, HALF_YEAR 반기, SCORE 평가 점수
-- 내 생각: 
-- (1) 필요 없는 컬럼 - 부서 정보 테이블, 전화번호, 입사일, 연봉
-- (2) 평가 점수는 상, 하반기 점수를 합해야 하므로 HR_GRADE 테이블을 이용해 사번으로 묶어 SCORE를 SUM 해야 한다. <- HR_GRADE 테이블을 HR_EMPLOYEES 테이블에 JOIN
-- (3) '점수가 가장 높은' 것을 추출하는 것은 WHERE+서브쿼리를 사용한다.

SELECT *
FROM (
    SELECT SUM(HR_GRADE.SCORE) AS SCORE,
    HR_EMPLOYEES.EMP_NO,
    HR_EMPLOYEES.EMP_NAME,
    HR_EMPLOYEES.POSITION,
    HR_EMPLOYEES.EMAIL
    FROM HR_EMPLOYEES
    JOIN HR_GRADE ON HR_EMPLOYEES.EMP_NO = HR_GRADE.EMP_NO
    GROUP BY HR_EMPLOYEES.EMP_NO
) AS EMP_SCORES
WHERE SCORE = (SELECT MAX(SCORE) FROM(
    SELECT SUM(HR_GRADE.SCORE) AS SCORE,
    HR_EMPLOYEES.EMP_NO,
    HR_EMPLOYEES.EMP_NAME,
    HR_EMPLOYEES.POSITION,
    HR_EMPLOYEES.EMAIL
    FROM HR_EMPLOYEES
    JOIN HR_GRADE ON HR_EMPLOYEES.EMP_NO = HR_GRADE.EMP_NO
    GROUP BY HR_EMPLOYEES.EMP_NO
) AS EMP_SCORES
);

-- 배운 것: '인라인 뷰'란, 쿼리의 결과를 참조할 수 있는 테이블처럼 사용하는 것이다.
-- 예를 들어, 학생 시험 결과 테이블이 있다고 할 때, 반 별 점수 합계를 구한 후 그 결과에서 조건을 걸고 싶다고 한다면
-- 먼저 반 별 합계를 구하는 쿼리를 작성하는데, 이 때 쿼리의 결과가 테이블의 형태로 나타나는 것 뿐, 진짜 '테이블'은 아니라서 여기에 조건을 걸 수 없다.
-- 이 때 '인라인 뷰'로 쿼리 결과를 테이블처럼 FROM 절에 넣어버리는 것이다(임시 테이블처럼 사용하기 위해).
SELECT *
FROM (
    SELECT 반, SUM(점수) AS 합계
    FROM 시험결과
    GROUP BY 반
) AS 반별합계 -- <- 쿼리 결과에 별칭(이름)을 붙여 테이블처럼 만드는 것!
WHERE 합계 >= 150;
-- 실제 DB가 처리하는 순서는 서브쿼리 -> 메인쿼리 순이다.
-- 또한 인라인 뷰는 해당하는 FROM 절 내 범위에서만 참조할 수 있고, 바깥에서는 참조할 수 없다.
-- 즉 만들어진 임시 테이블을 바깥의 FROM에서 또 불러오는 것이 불가능하다.

-- 서브쿼리 위치에 따른 목적과 결과
-- (1) WHERE 안 : '서브쿼리' -> 조건 확인용 빌려오기 & 값 또는 목록
-- (2) SELECT 안 : '스칼라 서브쿼리' -> 각 행마다 계산값 붙이기 & 값 딱 하나
-- (3) FROM 안 : '인라인 뷰' -> 쿼리 결과를 임시 테이블로 & 테이블



-- =====================
-- 9. 노선별 평균 역 사이 거리 조회하기
-- =====================
-- 문제: SUBWAY_DISTANCE 테이블에서 노선별로 노선, 총 누계 거리, 평균 역 사이 거리를 노선별로 조회하는 SQL문을 작성해주세요. 총 누계거리는 테이블 내 존재하는 역들의 역 사이 거리의 총 합을 뜻합니다. 총 누계 거리와 평균 역 사이 거리의 컬럼명은 각각 TOTAL_DISTANCE, AVERAGE_DISTANCE로 해주시고, 총 누계거리는 소수 둘째자리에서, 평균 역 사이 거리는 소수 셋째 자리에서 반올림 한 뒤 단위(km)를 함께 출력해주세요. 결과는 총 누계 거리를 기준으로 내림차순 정렬해주세요.
-- SUBWAY_DISTANCE 역 간 거리 정보 테이블 : LINE 호선, NO 순번, ROUTE 노선, STATION_NAME 역 이름, D_BETWEEN_DIST 역 사이 거리, D_CUMULATIVE 누계 거리
-- 내 생각:
-- (1) 총 누계 거리 = SUM = 역 사이 거리의 총합, 소수 둘째자리 반올림 = ROUND(~, 2)
-- (2) 평균 역 사이 거리 = AVG, 소수 셋째자리 반올림 = ROUND(~, 3)
-- (3) CONCAT으로 km 붙이기

-- 오답1:
SELECT ROUTE,
    CONCAT(ROUND(SUM(D_BETWEEN_DIST), 2), 'km') AS TOTAL_DISTANCE,
    CONCAT(ROUND(AVG(D_BETWEEN_DIST), 3), 'km') AS AVERAGE_DISTANCE 
FROM SUBWAY_DISTANCE
GROUP BY ROUTE
ORDER BY TOTAL_DISTANCE DESC;
-- 틀린 이유: 총 누계 거리를 기준으로 내림차순 정렬을 하려면 값이 숫자여야 하는데, TOTAL_DISTANCE는 CONCAT 때문에 문자열을 반환한다.

-- 오답2:
SELECT ROUTE,
    CONCAT(ROUND(SUM(D_BETWEEN_DIST), 2), 'km') AS TOTAL_DISTANCE,
    CONCAT(ROUND(AVG(D_BETWEEN_DIST), 3), 'km') AS AVERAGE_DISTANCE 
FROM SUBWAY_DISTANCE
GROUP BY ROUTE
ORDER BY SUM(D_BETWEEN_DIST) DESC;
-- 틀린 이유: 반올림 함수 ROUND(숫자,N)에서 N은 소수 몇번째자리'까지' '남길지'를 말하는 것이다!
-- 그래서 예를 들어 ROUND(3.14159, 1)이면 소수 첫번째자리까지 남긴다는 뜻이어서 3.1이 된다.
-- 보통 문제에서는 소수 N자리'에서' 반올림하라고 나오는데, 즉 소수 N자리'에서' 반올림해서 N자리는 버리고, N-1자리'까지' 나타내라고 하는 뜻이다.
-- 이 문제에서는 각각 소수 둘째자리, 셋째자리'에서' 반올림하라고 했으므로, 소수 첫째자리, 둘째자리'까지' 표현해야 한다.

-- 정답:
SELECT ROUTE,
    CONCAT(ROUND(SUM(D_BETWEEN_DIST), 1), 'km') AS TOTAL_DISTANCE,
    CONCAT(ROUND(AVG(D_BETWEEN_DIST), 2), 'km') AS AVERAGE_DISTANCE 
FROM SUBWAY_DISTANCE
GROUP BY ROUTE
ORDER BY SUM(D_BETWEEN_DIST) DESC;

-- 배운 것: 항상 ROUND를 쓸 때 소수 자리수가 헷갈렸는데 이제 안 틀릴 수 있을 것 같다..
-- ROUND에 쓰는 숫자는 어디까지 남길지를 정하는 것, 그래서 'n째자리에서 반올림' 이라고 하면 ROUND(숫자, n-1) 이라고 써야함!



-- =====================
-- 10. 물고기 종류 별 잡은 수 구하기
-- =====================
-- 문제: FISH_NAME_INFO에서 물고기의 종류 별 물고기의 이름과 잡은 수를 출력하는 SQL문을 작성해주세요. 물고기의 이름 컬럼명은 FISH_NAME, 잡은 수 컬럼명은 FISH_COUNT로 해주세요. 결과는 잡은 수 기준으로 내림차순 정렬해주세요.
-- FISH_INFO 잡은 물고기 정보 테이블 : ID 물고기의 ID, FISH_TYPE 물고기의 종류(숫자), LENGTH 잡은 물고기의 길이(cm), TIME 물고기 잡은 날짜
-- FISH_NAME_INFO 물고기 이름 정보 테이블 : FISH_TYPE 물고기의 종류(숫자), FISH_NAME 물고기의 이름(문자)
-- 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH가 NULL임
-- 내 생각: FISH_TYPE으로 두 테이블 JOIN 하고 FISH_NAME으로 GROUP BY 해서 COUNT

-- 정답:
SELECT COUNT(*) AS FISH_COUNT, FISH_NAME_INFO.FISH_NAME
FROM FISH_INFO
JOIN FISH_NAME_INFO ON FISH_INFO.FISH_TYPE = FISH_NAME_INFO.FISH_TYPE
GROUP BY FISH_NAME_INFO.FISH_NAME
ORDER BY FISH_COUNT DESC;

-- 배운 것: JOIN, GROUP BY 기본기 복습!



-- =====================
-- 11. 월별 잡은 물고기 수 구하기
-- =====================
-- 문제: 월별 잡은 물고기의 수와 월을 출력하는 SQL문을 작성해주세요. 잡은 물고기 수 컬럼명은 FISH_COUNT, 월 컬럼명은 MONTH로 해주세요. 결과는 월을 기준으로 오름차순 정렬해주세요. 단, 월은 숫자형태 (1~12) 로 출력하며 9 이하의 숫자는 두 자리로 출력하지 않습니다. 잡은 물고기가 없는 월은 출력하지 않습니다.
-- FISH_INFO 잡은 물고기 정보 테이블 : ID 물고기의 ID, FISH_TYPE 물고기의 종류(숫자), LENGTH 잡은 물고기의 길이(cm), TIME 물고기 잡은 날짜
-- 내 생각: TIME 컬럼을 사용해 월별로 GROUP BY 하고 COUNT

SELECT COUNT(*) AS FISH_COUNT, MONTH(TIME) AS MONTH
FROM FISH_INFO
GROUP BY MONTH
ORDER BY MONTH;