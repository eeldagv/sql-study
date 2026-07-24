-- =====================
-- 1. 자동차 대여 기록에서 장기/단기 대여 구분하기
-- =====================
-- 문제: 다음은 어느 자동차 대여 회사의 자동차 대여 기록 정보를 담은 CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블입니다. CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블은 아래와 같은 구조로 되어있으며, HISTORY_ID, CAR_ID, START_DATE, END_DATE 는 각각 자동차 대여 기록 ID, 자동차 ID, 대여 시작일, 대여 종료일을 나타냅니다.
-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 대여 시작일이 2022년 9월에 속하는 대여 기록에 대해서 대여 기간이 30일 이상이면 '장기 대여' 그렇지 않으면 '단기 대여' 로 표시하는 컬럼(컬럼명: RENT_TYPE)을 추가하여 대여기록을 출력하는 SQL문을 작성해주세요. 결과는 대여 기록 ID를 기준으로 내림차순 정렬해주세요.
-- 내 생각: 조건이 START_DATE의 YEAR가 2022면서 MONTH가 9 여야 한다.
-- 대여기간이 30일 이상이라는 것은 대여 종료일 - 대여 시작일을 했을 때 값이 30 이상이어야 한다.

-- 정답:
SELECT *, 
    CASE
        WHEN DATEDIFF(END_DATE, START_DATE) + 1 >= 30
        THEN '장기 대여'
        ELSE '단기 대여'
    END AS RENT_TYPE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE YEAR(START_DATE) = 2022 AND MONTH(START_DATE) = 9
ORDER BY HISTORY_ID DESC;

-- 배운 것: 
-- 날짜의 차이를 구하는 함수는 DATEDIFF와 TIMESTAMPDIFF가 있다.
-- DATEDIFF(날짜1, 날짜2) -> 일(day) 단위 차이를 구한다. 날짜1(앞)에서 날짜2(뒤)를 뺀다.
-- ex) DATEDIFF('2022-10-20', '2022-10-15) -> 5
-- TIMESTAMPDIFF(단위, 날짜1, 날짜2) -> 원하는 단위로 차이를 구한다.
-- ex) TIMESTAMPDIFF(DAY, '2022-10-15', '2022-10-20') -> 5일
-- TIMESTAMPDIFF(MONTH, '2022-01-01', '2022-10-01') -> 9개월
-- TIMESTAMPDIFF(YEAR, '2000-01-01', '2022-10-01') -> 22년
-- 주의할 점은, 그냥 날짜1 - 날짜2를 한 결과는 날짜 간의 '간격' 이므로, '대여기간' 같은 '일수'를 구해야 한다면 +1을 해야 한다(대여 시작일도 포함이기 때문).



-- =====================
-- 2. 특정 옵션이 포함된 자동차 리스트 구하기
-- =====================
-- 문제: 다음은 어느 자동차 대여 회사에서 대여중인 자동차들의 정보를 담은 CAR_RENTAL_COMPANY_CAR 테이블입니다. CAR_RENTAL_COMPANY_CAR 테이블은 아래와 같은 구조로 되어있으며, CAR_ID, CAR_TYPE, DAILY_FEE, OPTIONS 는 각각 자동차 ID, 자동차 종류, 일일 대여 요금(원), 자동차 옵션 리스트를 나타냅니다.
-- 자동차 종류는 '세단', 'SUV', '승합차', '트럭', '리무진' 이 있습니다. 자동차 옵션 리스트는 콤마(',')로 구분된 키워드 리스트(옵션 리스트 값 예시: '열선시트', '스마트키', '주차감지센서')로 되어있으며, 키워드 종류는 '주차감지센서', '스마트키', '네비게이션', '통풍시트', '열선시트', '후방카메라', '가죽시트' 가 있습니다.
-- CAR_RENTAL_COMPANY_CAR 테이블에서 '네비게이션' 옵션이 포함된 자동차 리스트를 출력하는 SQL문을 작성해주세요. 결과는 자동차 ID를 기준으로 내림차순 정렬해주세요.
-- 내 생각: LKIE를 사용하여 욥션에 '네비게이션'이 있는지를 조건으로 걸어준다.

-- 정답:
SELECT *
FROM CAR_RENTAL_COMPANY_CAR
WHERE OPTIONS LIKE '%네비게이션%'
ORDER BY CAR_ID DESC;



-- =====================
-- 3. 한 해에 잡은 물고기 수 구하기
-- =====================
-- 문제: 낚시앱에서 사용하는 FISH_INFO 테이블은 잡은 물고기들의 정보를 담고 있습니다. FISH_INFO 테이블의 구조는 다음과 같으며 ID, FISH_TYPE, LENGTH, TIME은 각각 잡은 물고기의 ID, 물고기의 종류(숫자), 잡은 물고기의 길이(cm), 물고기를 잡은 날짜를 나타냅니다.
-- 단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.
-- FISH_INFO 테이블에서 2021년도에 잡은 물고기 수를 출력하는 SQL 문을 작성해주세요. 이 때 컬럼명은 'FISH_COUNT' 로 지정해주세요.
-- 내 생각: 전체를 COUNT하는데, 조건을 TIME의 YEAR가 2021으로 건다.

-- 정답:
SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO
WHERE YEAR(TIME) = 2021;