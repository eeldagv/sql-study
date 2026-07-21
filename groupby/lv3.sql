-- =====================
-- 1. 자동차 대여 기록에서 대여중 / 대여 가능 여부 구분하기
-- =====================
-- 문제: CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 2022년 10월 16일에 대여 중인 자동차인 경우 '대여중' 이라고 표시하고, 대여 중이지 않은 자동차인 경우 '대여 가능'을 표시하는 컬럼(컬럼명: AVAILABILITY)을 추가하여 자동차 ID와 AVAILABILITY 리스트를 출력하는 SQL문을 작성해주세요. 이때 반납 날짜가 2022년 10월 16일인 경우에도 '대여중'으로 표시해주시고 결과는 자동차 ID를 기준으로 내림차순 정렬해주세요.
-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 자동차 대여 기록 정보 테이블 : HISTORY_ID 대여 기록 ID, CAR_ID 자동차 ID, START_DATE 대여 시작일, END_DATE 대여 종료일
-- 내 생각: 
-- (1) 새로운 컬럼 AVAILABILITY 를 추가한다 <- XX CASE WHEN을 사용
-- (2) 날짜는 미래일수록 과거보다 크니까 범위를 사용해야 하나? 
-- 2022년 10월 16일에 대여중이라면 START_DATE와 END_DATE 사이에 2022-10-16이 있어야 함
-- START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16'
-- (3) 근데 이게 GROUP BY 문제면 GROUP BY를 써야 한단 건데 뭘 묶어야 하는 걸까..
-- 만약에 같은 차라면 가장 최근에 빌리고 반납된 날짜만 봐야 하니까 그걸 걸러야 하는 건가?
-- 그러면 CAR_ID로 GROUP BY를 하는데 START_DATE 값이 더 큰 행만 남겨둬야 하는 건가? <- 근데 어떻게? MAX 함수를 사용해서?
-- (4) 그 결과에 CASE WHEN을 쓰는 거라 인라인 뷰를 써야 하나...? <- 아닌 듯

-- 오답:
SELECT CAR_ID, 
    CASE
        WHEN MAX(START_DATE) <= '2022-10-16' AND MAX(END_DATE) >= '2022-10-16' THEN '대여중'
        ELSE '대여가능'
    END AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
ORDER BY CAR_ID DESC;
-- 틀린 이유: 진짜 GROUP BY를 쓰는 게 맞을까?

-- (1) '10월 16일'을 기준으로 봐야함 즉, START_DATE와 END_DATE 사이에 10월 16일이 포함되어있는지를 봐야함
-- (2) 한 차의 대여기록이 여러개일 경우, 그 여러개 중 하나라도 10월 16일에 대여중인 기록이 있다면 그 차는 '대여중' -> '하나라도' 라는 조건이니까 IN(=OR)을 사용하는 것
CAR_ID IN (
    SELECT CAR_ID
    WHERE START_DATE <= '2022-10-16' AND END_DATE >= '2022-10-16'
)
-- (3) 이 조건을 WHERE에 쓰면, 조건에 맞는 행만 걸러내게 됨 -> 대여 가능한 차량은 사라지게 됨 (위의 쿼리는 10월 16일에 대여중인지를 보는 쿼리니까)
-- (4) 그래서 CASE WHEN 으로 '대여중'과 '대여가능' 모두 반환할 수 있도록 해야함
-- (5) 그런데 CAR_ID가 중복되면 안 됨, 즉 n번 차에 대해서 여러 개의 대여기록이 있어도, 해당 차에 대해서 딱 하나의 기록만 나오게 해야함 -> DISTINCT

-- 정답:
SELECT DISTINCT CAR_ID, 
    CASE
        WHEN CAR_ID IN (
            SELECT CAR_ID
            FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
            WHERE START_DATE <= '2022-10-16'
            AND END_DATE >= '2022-10-16') THEN '대여중'
        ELSE '대여 가능'
    END AS AVAILABILITY
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
ORDER BY CAR_ID DESC;

-- 배운 것: 
-- 'GROUP BY' 카테고리에 있는 문제라고 해서 미리 풀이법을 정하지 말자. 문제가 진짜로 무엇을 물어보는지 파악해야 함!
-- 조건에 따라 다른 값 표시 -> CASE WHEN (JS에서 IF ELSE와 같음)
-- 하나라도 있는지 -> IN + 서브쿼리



-- =====================
-- 2. 즐겨찾기가 가장 많은 식당 정보 출력하기
-- =====================
-- 문제: REST_INFO 테이블에서 음식종류별로 즐겨찾기수가 가장 많은 식당의 음식 종류, ID, 식당 이름, 즐겨찾기수를 조회하는 SQL문을 작성해주세요. 이때 결과는 음식 종류를 기준으로 내림차순 정렬해주세요.
-- REST_INFO 식당 정보 테이블 : REST_ID 식당 ID, REST_NAME 식당 이름, FOOD_TYPE 음식 종류, VIEWS 조회수, FAVORITES 즐겨찾기수, PARKING_LOT 주차장 유무, ADDRESS 주소, TEL 전화번호
-- 내 생각: WHERE + 서브쿼리로 '특정 조건에 맞는 행만 걸러내기' 하면 되지 않을까?
-- 중요한 건 FOOD_TYPE이랑 FAVORITES 컬럼
-- '즐겨찾기 수가 가장 많은' 이니까 MAX를 써야함 -> 근데 '음식종류별'
-- 'REST_INFO에서 FOOD_TYPE, REST_ID, REST_NAME, FAVORTIES를 추출할거야, 그런데 FAVORITES가 가장 많은 것에 대해서만 추출할 건데, 전체 중에서가 아니라 각 FOOD_TYPE 에서 가장 많은 행 하나씩만 추출할거야.'

-- 오답:
SELECT FOOD_TYPE, REST_ID, REST_NAME, MAX(FAVORITES) AS FAVORITES
FROM REST_INFO
GROUP BY FOOD_TYPE
ORDER BY FOOD_TYPE DESC;
-- 틀린 이유:
-- GROUP BY로 음식종류별로 묶었으니까, MAX(FAVORITES)는 '각 음식종류별 최댓값'이 맞게 나옴
-- 그런데 REST_ID, REST_NAME은 어떤 걸로 보여줘야 할 지 DB가 알지 못함
-- 사람 입장에선 MAX 값에 해당하는 ID와 NAME을 보여주면 된다고 생각하지만, DB 입장에서는
한식 묶음: { REST_ID: [1, 2], REST_NAME: [김밥천국, 맛있는집], FAVORITES: [50, 80] }
-- 이렇게 되어있기 때문에, 따로 노는 값이라 알아서 연결을 못 시켜줌
-- 따라서 서브쿼리를 사용해서, 'FAVORITES가 최대값이랑 일치하는 그 행 전체'를 통째로 가져오도록 해야함!
-- 즉, GROUP BY + MAX는 '최대값'은 정확히 구하지만, '그 최대값을 가진 행의 다른 정보'는 보장하지 못 함

-- 정답:
SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
FROM REST_INFO AS R
WHERE FAVORITES = (
    SELECT MAX(FAVORITES)
    FROM REST_INFO
    WHERE FOOD_TYPE = R.FOOD_TYPE
)
ORDER BY FOOD_TYPE DESC;
-- WHERE FOOD_TYPE = R.FOOD_TYPE -> '지금 처리하는 이 행과 같은 음식종류 중에서만 MAX를 구해줘'
-- R.FOOD_TYPE이 없으면 그냥 전체에서 MAX를 구해버림 -> 음식종류 구분 없이 딱 한 식당만 나옴
-- '각 식당 행마다, 그 식당과 같은 음식종류 중에서 가장 즐겨찾기가 많은 수를 구해서, 그 값이랑 이 식당의 즐겨찾기 수가 같으면(=1등이면) 출력해라'

-- 배운 것: 
-- '집계값이랑, 그 값을 가진 행의 다른 정보를 같이 보여줘야 하나?'
-- YES -> GROUP BY로는 안 됨 -> WHERE + 서브쿼리
-- 집계값만 필요 -> GROUP BY



-- =====================
-- 3. 카테고리 별 도서 판매량 집계하기
-- =====================
-- 문제: 2022년 1월의 카테고리 별 도서 판매량을 합산하고, 카테고리(CATEGORY), 총 판매량(TOTAL_SALES) 리스트를 출력하는 SQL문을 작성해주세요. 결과는 카테고리명을 기준으로 오름차순 정렬해주세요.
-- BOOK 도서 정보 테이블 : BOOK_ID 도서 ID, CATEGORY 카테고리, AUTHOR_ID 저자 ID, PRICE 판매가, PUBLISHED_DATE 출판일
-- BOOK_SALES 각 도서의 날짜 별 판매량 정보 테이블 : BOOK_ID 도서 ID, SALES_DATE 판매일, SALES 판매량
-- 내 생각: 판매일이 '2022년 1월', '카테고리별'로 '판매량'을 '합산'
-- 일단 두 테이블을 BOOK_ID로 JOIN함
-- YEAR() = 2022 AND MONTH() = 1 <- 조건 
-- 걸러진 행들을 GROUP BY로 CATEGORY로 묶고, SALES를 SUM

SELECT CATEGORY, SUM(SALES) AS TOTAL_SALES
FROM BOOK_SALES
JOIN BOOK ON BOOK_SALES.BOOK_ID = BOOK.BOOK_ID
WHERE YEAR(SALES_DATE) = 2022 AND MONTH(SALES_DATE) = 1
GROUP BY CATEGORY
ORDER BY CATEGORY;



-- =====================
-- 4. 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기
-- =====================
-- 문제: CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 대여 시작일을 기준으로 2022년 8월부터 2022년 10월까지 총 대여 횟수가 5회 이상인 자동차들에 대해서 해당 기간 동안의 월별 자동차 ID 별 총 대여 횟수(컬럼명: RECORDS) 리스트를 출력하는 SQL문을 작성해주세요. 결과는 월을 기준으로 오름차순 정렬하고, 월이 같다면 자동차 ID를 기준으로 내림차순 정렬해주세요. 특정 월의 총 대여 횟수가 0인 경우에는 결과에서 제외해주세요.
-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 자동차 대여 기록 정보 테이블 : HISTORY_ID 자동차 대여 기록 ID, CAR_ID 자동차 ID, START_DATE 대여 시작일, END_DATE 대여 종료일
-- 내 생각: 
-- START_DATE가 '2022-08-01' 이상이고, END_DATE가 '2022-10-31' 이하 <- WHERE 조건
-- '월별' '자동차 ID 별' <- 거른 후 GROUP BY
-- 총 대여 횟수가 5회 이상 = CAR_ID를 COUNT 했을 때 5 이상 <- 거른 후 조건
-- 특정 월 COUNT 값이 0이면 = NULL이면 제외 -> 컬럼명으로 COUNT

-- 오답:
SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(CAR_ID) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
GROUP BY MONTH(START_DATE), CAR_ID
HAVING COUNT(CAR_ID) >= 5
ORDER BY MONTH(START_DATE), CAR_ID DESC;
-- 틀린 이유:
-- 2022년 8월 1일 ~ 2022년 10월 31일 이 기간까지 총 대여 횟수가 5회 이상인 자동차들에 대해서, 월별 대여 횟수를 출력해야 하는데
HAVING COUNT(CAR_ID) >= 5
-- 이 조건은 이미 월별로 묶은 다음에 5회 이상인 걸 확인하고 있기 때문에, 8월에 5회 이상, 9월에 5회 이상 이렇게 각 월마다 5회 이상인 걸 찾고 있음!
-- 그래서 서브쿼리로 두 조건을 모두 만족하는 값을 먼저 뽑고 = 조건에 서브쿼리를 써주어야 함
-- 메인쿼리에서 그 중에서 월별 횟수를 구해야 한다.

-- 정답:
SELECT MONTH(START_DATE) AS MONTH, CAR_ID, COUNT(CAR_ID) AS RECORDS
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE CAR_ID IN (
    SELECT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
    GROUP BY CAR_ID
    HAVING COUNT(*) >= 5
    ) AND START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
GROUP BY MONTH(START_DATE), CAR_ID
ORDER BY MONTH(START_DATE), CAR_ID DESC;

-- 배운 것: 
-- (1) 조건이 걸리는 단위와 범위를 정확히 파악해야 한다. (5회 이상이라는 조건은 묶고 나서가 아니라 묶기 전이어야 함)
-- (2) 서브쿼리와 메인쿼리는 독립적인 범위이므로, 조건도 각각 설정해주어야 한다. (기간에 대한 조건은 서브쿼리와 메인쿼리 모두에 적용해야 함, 스코프 개념)



-- =====================
-- 5. 조건에 맞는 사용자와 총 거래금액 조회하기
-- =====================
-- 문제: USED_GOODS_BOARD와 USED_GOODS_USER 테이블에서 완료된 중고 거래의 총금액이 70만 원 이상인 사람의 회원 ID, 닉네임, 총거래금액을 조회하는 SQL문을 작성해주세요. 결과는 총거래금액을 기준으로 오름차순 정렬해주세요.
-- USED_GOODS_BOARD 중고 거래 게시판 정보 테이블 : BOARD_ID 게시글 ID, WRITER_ID 작성자 ID, TITLE 게시글 제목, CONTENTS 게시글 내용, PRICE 가격, CREATED_DATE 작성일, STATUS 거래상태, VIEWS 조회수
-- USED_GOODS_USER 중고 거래 게시판 사용자 정보 테이블 : USER_ID 회원 ID, NICKNAME 닉네임, CITY 시, STREET_ADDRESS1 도로명 주소, STREET_ADDRESS2 상세 주소, TLNO 전화번호
-- 내 생각: USER_ID, NICKNAME, SUM(PRICE)
-- 게시판 테이블의 WRITER_ID = 사용자 테이블의 USER_ID <- 이걸로 JOIN
-- 상태가 거래완료된 상태여야 함, 총 금액이 70만원 이상이어야 함 <- 조건 (주의할 점은, WHERE에는 집계함수를 못 쓴다)
-- '사람별' = '회원별' 총 금액이 70만원인 게 조건

-- 정답:
SELECT USER_ID, NICKNAME, SUM(PRICE) AS TOTAL_PRICE
FROM USED_GOODS_USER
JOIN USED_GOODS_BOARD ON USED_GOODS_USER.USER_ID = USED_GOODS_BOARD.WRITER_ID
WHERE STATUS = 'DONE'
GROUP BY NICKNAME
HAVING SUM(PRICE) >= 700000
ORDER BY TOTAL_PRICE;

-- 배운 것: 여기서는 정답처리 되었지만, 닉네임으로 묶으면 닉네임이 중복되는 경우도 있기 때문에 닉네임보다 더 고유한 정보인 USER_ID로 묶는 게 더 안전하다.



-- =====================
-- 6. 부서별 평균 연봉 조회하기
-- =====================
-- 문제: HR_DEPARTMENT와 HR_EMPLOYEES 테이블을 이용해 부서별 평균 연봉을 조회하려 합니다. 부서별로 부서 ID, 영문 부서명, 평균 연봉을 조회하는 SQL문을 작성해주세요. 평균연봉은 소수점 첫째 자리에서 반올림하고 컬럼명은 AVG_SAL로 해주세요. 결과는 부서별 평균 연봉을 기준으로 내림차순 정렬해주세요.
-- HR_DEPARTMENT 회사 부서 정보 테이블 : DEPT_ID 부서 ID, DEPT_NAME_KR 국문 부서명, DEPT_NAME_EN 영문 부서명, LOCATION 부서 위치 
-- HR_EMPLOYEES 회사 사원 정보 테이블 : EMP_NO 사번, EMP_NAME 성명, DEPT_ID 부서 ID, POSITION 직책, EMAIL 이메일, COMP_TEL 전화번호, HIRE_DATE 입사일, SAL 연봉 
-- 내 생각: '부서별' '평균 연봉' -> 구하려는 값이 하나이므로, GROUP BY를 사용

-- 정답:
SELECT HR_DEPARTMENT.DEPT_ID, DEPT_NAME_EN, ROUND(AVG(SAL),0) AS AVG_SAL
FROM HR_DEPARTMENT
JOIN HR_EMPLOYEES ON HR_DEPARTMENT.DEPT_ID = HR_EMPLOYEES.DEPT_ID
GROUP BY HR_DEPARTMENT.DEPT_ID
ORDER BY AVG_SAL DESC;



-- =====================
-- 7. 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기
-- =====================
-- 문제: FISH_INFO에서 평균 길이가 33cm 이상인 물고기들을 종류별로 분류하여 잡은 수, 최대 길이, 물고기의 종류를 출력하는 SQL문을 작성해주세요. 결과는 물고기 종류에 대해 오름차순으로 정렬해주시고, 10cm이하의 물고기들은 10cm로 취급하여 평균 길이를 구해주세요. 컬럼명은 물고기의 종류 'FISH_TYPE', 잡은 수 'FISH_COUNT', 최대 길이 'MAX_LENGTH'로 해주세요.
-- FISH_INFO 잡은 물고기 정보 테이블 : ID 물고기 ID, FISH_TYPE 물고기 종류(숫자), LENGTH 물고기 길이(cm), TIME 물고기 잡은 날짜
-- 단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH가 NULL이며, LENGTH에 NULL만 있는 경우는 없습니다.
-- 내 생각: 
-- '평균 길이가 33cm 이상' <- 서브쿼리의 where 조건 XX <- 집계값에 거는 조건이므로 HAVING
-- 만약에 물고기 길이가 10cm 이하면 10cm로 취급해서 평균 길이 계산 <- 이건 CASE WHEN으로 써야 하나? XX, IFNULL을 사용하면 됨 
-- 10cm 이하면 값이 NULL이니까, 값이 NULL이면 LENGTH = 10 <- 평균을 구할 때
-- 잡은 수 = COUNT(FISH_TYPE), 최대 길이 = MAX(LENGTH)

-- 정답:
SELECT COUNT(FISH_TYPE) AS FISH_COUNT, MAX(LENGTH) AS MAX_LENGTH, FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING AVG(IFNULL(LENGTH, 10)) >= 33
ORDER BY FISH_TYPE;

-- 배운 것: 
-- (1) 집계값에 조건을 거는 거니까 서브쿼리가 아니라 HAVING이다. 조건이 개별행에 걸려서 특정 하나를 찾는다면 서브쿼리를 쓰지만, 그룹 전체에 걸리는 거니까 HAVING!
-- (2) 10cm이하인 경우는 값이 NULL인데, 계산할 때만 NULL을 10으로 취급해서 계산하라고 했으니까 평균을 계산하는 집계함수에만 조건을 걸어주면 된다.