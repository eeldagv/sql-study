-- =====================
-- 1. 서울에 위치한 식당 목록 출력하기
-- =====================
-- 문제: REST_INFO와 REST_REVIEW 테이블에서 서울에 위치한 식당들의 식당 ID, 식당 이름, 음식 종류, 즐겨찾기수, 주소, 리뷰 평균 점수를 조회하는 SQL문을 작성해주세요. 이때 리뷰 평균점수는 소수점 세 번째 자리에서 반올림 해주시고 결과는 평균점수를 기준으로 내림차순 정렬해주시고, 평균점수가 같다면 즐겨찾기수를 기준으로 내림차순 정렬해주세요.
-- 내 생각: (1) REST_ID를 기준으로 두 테이블 JOIN

-- 오답 1:
SELECT REST_INFO.REST_ID, REST_INFO.REST_NAME, REST_INFO.FOOD_TYPE, REST_INFO.FAVORITES, REST_INFO.ADDRESS, ROUND(AVG(REST_REVIEW.REVIEW_SCORE),2) AS SCORE
FROM REST_INFO
JOIN REST_REVIEW ON REST_INFO.REST_ID = REST_REVIEW.REST_ID
WHERE ADDRESS LIKE '서울%'
ORDER BY SCORE DESC, REST_INFO.FAVORITES DESC;
-- 틀린 이유: JOIN은 REST_ID라는 외래키로 각각의 테이블을 이어 붙이기만 할 뿐, 묶어주는 것은 아니다. 어떤 '기준으로 묶기' 위해서는 GROUP BY를 사용해야 한다.

-- 오답 2:
SELECT REST_INFO.REST_ID, REST_INFO.REST_NAME, REST_INFO.FOOD_TYPE, REST_INFO.FAVORITES, REST_INFO.ADDRESS, ROUND(AVG(REST_REVIEW.REVIEW_SCORE),2) AS SCORE
FROM REST_INFO
JOIN REST_REVIEW ON REST_INFO.REST_ID = REST_REVIEW.REST_ID
GROUP BY REST_INFO.REST_ID
WHERE ADDRESS LIKE '서울%'
ORDER BY SCORE DESC, REST_INFO.FAVORITES DESC;
-- 틀린 이유: GROUP BY는 WHERE 다음에 작성한다. WHERE에서 필요 없는 행을 거르고 묶어야 묶음 안에 불필요한 데이터가 섞이지 않는다.

-- 정답:
SELECT REST_INFO.REST_ID, REST_INFO.REST_NAME, REST_INFO.FOOD_TYPE, REST_INFO.FAVORITES, REST_INFO.ADDRESS, ROUND(AVG(REST_REVIEW.REVIEW_SCORE),2) AS SCORE
FROM REST_INFO
JOIN REST_REVIEW ON REST_INFO.REST_ID = REST_REVIEW.REST_ID
WHERE ADDRESS LIKE '서울%'
GROUP BY REST_INFO.REST_ID
ORDER BY SCORE DESC, REST_INFO.FAVORITES DESC;

-- 배운 것: GROUP BY와 JOIN의 차이점, SQL 작성 순서와 실행 순서의 차이

-- *********************
-- JOIN과 GROUP BY
-- *********************
-- JOIN은 단지 두 테이블을 이어 붙여서 = 연결해서 행을 늘린 것 = 펼친 것
-- 외래키를 기준으로 JOIN 한다고 해도, 각 행은 모두 독립적인 행이라고 DB가 인식함
-- 어떤 기준으로 '묶고' 싶을 때 사용하는 것이 GROUP BY
-- 반드시 JOIN 해야만 GROUP BY를 쓸 수 있는 것은 아니다.
-- JOIN은 결과 테이블에 각 테이블의 컬럼을 모두 보여줘야 할 때 사용하므로, 빌려오기만 하고 결과 테이블에서 보여주지 않아도 된다면 서브쿼리를 사용한다.
-- JOIN으로 테이블을 짝지어놓은 상태에서 .을 사용하여 테이블을 명시해주어야 하는 이유는 단지 DB가 헷갈려하기 때문이다.