-- =====================
-- 1. 평균 일일 대여 요금 구하기
-- =====================
-- 문제: CAR_RENTAL_COMPANY_CAR 테이블에서 자동차 종류가 'SUV'인 자동차들의 평균 일일 대여 요금을 출력하는 SQL문을 작성해주세요. 이때 평균 일일 대여 요금은 소수 첫 번째 자리에서 반올림하고, 컬럼명은 AVERAGE_FEE 로 지정해주세요.
-- 내 생각: (1)테이블에서 특정 컬럼만 뽑기 (2)평균 구하기 (3)반올림하기 (4)컬럼명을 임의로 지정하기

-- 정답: 
SELECT ROUND(AVG(DAILY_FEE), 0) AS AVERAGE_FEE
FROM CAR_RENTAL_COMPANY_CAR
WHERE CAR_TYPE='SUV';

-- 배운 것: AS, ROUND(), AVG(), WHERE



-- =====================
-- 2. 인기있는 아이스크림
-- =====================
-- 문제: 상반기에 판매된 아이스크림의 맛을 총주문량을 기준으로 내림차순 정렬하고 총주문량이 같다면 출하 번호를 기준으로 오름차순 정렬하여 조회하는 SQL 문을 작성해주세요.
-- 내 생각: (1)맛 컬럼 데이터를 뽑기 (2)총주문량 기준으로 내림차순 정렬 (3)그 중에서 값이 같다면 출하 번호를 기준으로 오름차순 정렬

-- 정답:
SELECT FLAVOR
FROM FIRST_HALF
ORDER BY TOTAL_ORDER DESC, SHIPMENT_ID ASC;

-- 배운 것: ORDER BY 컬럼명 ASC/DESC, 다중정렬



-- =====================
-- 3. 조건에 맞는 도서 리스트 출력하기
-- =====================
-- 문제: BOOK 테이블에서 2021년에 출판된 '인문' 카테고리에 속하는 도서 리스트를 찾아서 도서 ID(BOOK_ID), 출판일 (PUBLISHED_DATE)을 출력하는 SQL문을 작성해주세요. 결과는 출판일을 기준으로 오름차순 정렬해주세요.
-- 내 생각: (1)카테고리가 '인문'이면서 출판연도가 '2021'인 데이터 뽑기 (2)도서ID, 출판일 데이터 뽑기 (3)출판일 오름차순 정렬

-- 오답1:
SELECT BOOK_ID, PUBLISHED_DATE
FROM BOOK
WHERE CATEGORY="인문"
ORDER BY PUBLISHED_DATE ASC;
-- 틀린 이유: 문자열 리터럴은 작은 따옴표를 써야한다. 큰 따옴표는 컬럼, 테이블명.

-- 오답2:
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK
WHERE CATEGORY='인문'
ORDER BY PUBLISHED_DATE ASC;
-- 틀린 이유: '출판연도가 2021'인 조건이 들어가지 않음

-- 정답:
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK
WHERE CATEGORY='인문' AND DATE_FORMAT(PUBLISHED_DATE, '%Y')='2021'
ORDER BY PUBLISHED_DATE ASC;

-- 배운 것: DATE_FORMAT() <- 날짜 포맷을 지정하는 함수
-- YEAR(), MONTH(), DAY() 함수를 사용하면 특정 연월일을 추출할 수 있다. 따라서 조건식은 WHERE CATEGORY='인문' AND YEAR(PUBLISHED_DATE)=2021 이라고 쓰는 게 더 깔끔하다.
-- 함수로 컬럼을 감싸면 인덱스를 못 타는 경우가 있기 때문에, 아래와 같은 방식을 더 선호한다.
AND PUBLISHED_DATE >= '2021-01-01' AND PUBLISHED_DATE < '2022-01-01'
-- 또는
AND PUBLISHED_DATE BETWEEN '2021-01-01' AND '2021-12-31'



-- =====================
-- 4. 12세 이하인 여자 환자 목록 출력하기
-- =====================
-- 문제: PATIENT 테이블에서 12세 이하인 여자환자의 환자이름, 환자번호, 성별코드, 나이, 전화번호를 조회하는 SQL문을 작성해주세요. 이때 전화번호가 없는 경우, 'NONE'으로 출력시켜 주시고 결과는 나이를 기준으로 내림차순 정렬하고, 나이 같다면 환자이름을 기준으로 오름차순 정렬해주세요.
-- 내 생각: (1)AGE가 12 이하이면서 GEND_CD 값이 W인 조건 걸기 (2)TLNO가 NULL 일 때 처리 (3)다중정렬

-- 오답1:
SELECT PT_NO, PT_NAME, GEND_CD, AGE, IFNULL(TLNO, 'NONE') 
FROM PATIENT
WHERE AGE <= 12
ORDER BY AGE DESC, PT_NAME ASC;
-- 틀린 이유: '여자'라는 조건을 추가하지 않음

-- 오답2:
SELECT PT_NO, PT_NAME, GEND_CD, AGE, IFNULL(TLNO, 'NONE') 
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME ASC;
-- 틀린 이유: AS TLNO <- 컬럼명 지정 빼먹음, PT_NO와 PT_NAME 순서가 틀림

-- 정답:
SELECT PT_NAME, PT_NO, GEND_CD, AGE, IFNULL(TLNO, 'NONE') AS TLNO
FROM PATIENT
WHERE AGE <= 12 AND GEND_CD = 'W'
ORDER BY AGE DESC, PT_NAME ASC;


-- 배운 것: NULL 처리, 컬럼 추출 순서도 신경 써야 한다.



-- =====================
-- 5. 과일로 만든 아이스크림 고르기
-- =====================
-- 문제: 상반기 아이스크림 총주문량이 3,000보다 높으면서 아이스크림의 주 성분이 과일인 아이스크림의 맛을 총주문량이 큰 순서대로 조회하는 SQL 문을 작성해주세요.
-- 내 생각: (1)총주문량 > 3000 AND 주성분=과일 (2)총주문량 내림차순

-- 정답:
SELECT FIRST_HALF.FLAVOR
FROM FIRST_HALF
JOIN ICECREAM_INFO ON FIRST_HALF.FLAVOR = ICECREAM_INFO.FLAVOR
WHERE FIRST_HALF.TOTAL_ORDER > 3000 AND ICECREAM_INFO.INGREDIENT_TYPE = 'fruit_based'
ORDER BY FIRST_HALF.TOTAL_ORDER DESC;

-- 배운 것: 테이블 두 개 이상을 붙일 때는 JOIN을 쓴다. JOIN ON은 '어떤 테이블을 어떤 기준으로 붙인다' 로 해석하면 좋다. 



-- =====================
-- 6. 흉부외과 또는 일반외과 의사 목록 출력하기
-- =====================
-- 문제: DOCTOR 테이블에서 진료과가 흉부외과(CS)이거나 일반외과(GS)인 의사의 이름, 의사ID, 진료과, 고용일자를 조회하는 SQL문을 작성해주세요. 이때 결과는 고용일자를 기준으로 내림차순 정렬하고, 고용일자가 같다면 이름을 기준으로 오름차순 정렬해주세요.
-- 내 생각: (1)진료과 = 흉부외과 or 일반외과 (2)의사 이름, id, 진료과, 고용일자 조회 (3)고용일자를 기준으로 내림차순 정렬 (4)고용일자가 같다면 이름 기준으로 오름차순

-- 오답1:
SELECT DR_NAME, DR_ID, MCDP_CD, TLNO
FROM DOCTOR
WHERE MCDP_CD = 'CS' OR 'GS'
ORDER BY HIRE_YMD DESC, DR_NAME ASC;
-- 틀린 이유: OR 뒤에 MCDP_CD = 를 생략하면 안 되는 것 같다. 그리고 전화번호가 아니라 고용일자를 출력해야 한다.

-- 정답:
SELECT DR_NAME, DR_ID, MCDP_CD, DATE_FORMAT(HIRE_YMD, '%Y-%m-%d') AS HIRE_YMD
FROM DOCTOR
WHERE MCDP_CD = 'CS' OR MCDP_CD = 'GS'
ORDER BY HIRE_YMD DESC, DR_NAME ASC;

-- 배운 것: 문제를 잘 읽자. 



-- =====================
-- 7. 조건에 부합하는 중고거래 댓글 조회하기
-- =====================
-- 문제: USED_GOODS_BOARD와 USED_GOODS_REPLY 테이블에서 2022년 10월에 작성된 게시글 제목, 게시글 ID, 댓글 ID, 댓글 작성자 ID, 댓글 내용, 댓글 작성일을 조회하는 SQL문을 작성해주세요. 결과는 댓글 작성일을 기준으로 오름차순 정렬해주시고, 댓글 작성일이 같다면 게시글 제목을 기준으로 오름차순 정렬해주세요.
-- USED_GOODS_BOARD : BOARD_ID, WRITER_ID, TITLE, CONTENTS, PRICE, CREATED_DATE, STATUS, VIEWS
-- USED_GOODS_REPLY : REPLY_ID, BOARD_ID, WRITER_ID, CONTENTS, CREATED_DATE
-- 내 생각: (1)JOIN을 사용 (2)기준 테이블 = BOARD (3)USED_GOODS_BOARD.TITLE, USED_GOODS_BOARD.BOARD_ID, USED_GOODS_REPLY.REPLY_ID, USED_GOODS_REPLY.WRITER_ID, USED_GOODS_REPLY.CONTENTS, USED_GOODS_REPLY.CREATED_DATE (4)다중정렬 : 댓글 작성일 오름차순, 게시글 제목 오름차순

-- 오답1:
SELECT USED_GOODS_BOARD.TITLE, USED_GOODS_BOARD.BOARD_ID, USED_GOODS_REPLY.REPLY_ID, USED_GOODS_REPLY.WRITER_ID, USED_GOODS_REPLY.CONTENTS, DATE_FORMAT(USED_GOODS_REPLY.CREATED_DATE, '%Y-%m-%d') AS CREATED_DATE
FROM USED_GOODS_BOARD
JOIN USED_GOODS_REPLY ON MONTH(USED_GOODS_BOARD.CREATED_DATE) = MONTH(USED_GOODS_REPLY.CREATED_DATE)
ORDER BY USED_GOODS_REPLY.CREATED_DATE ASC, USED_GOODS_BOARD.TITLE ASC;
-- 틀린 이유: ON 조건이 잘못됨, ON은 두 테이블을 연결하는 기준이다. 게시글이랑 댓글을 연결하려면 뭘 기준으로 붙여야 할 지? 두 테이블에 공통으로 있는 컬럼이 뭔지? 그리고 2022년 10월 조건은 어디에?

-- 정답:
SELECT USED_GOODS_BOARD.TITLE, USED_GOODS_BOARD.BOARD_ID, USED_GOODS_REPLY.REPLY_ID, USED_GOODS_REPLY.WRITER_ID, USED_GOODS_REPLY.CONTENTS, DATE_FORMAT(USED_GOODS_REPLY.CREATED_DATE, '%Y-%m-%d') AS CREATED_DATE
FROM USED_GOODS_BOARD
JOIN USED_GOODS_REPLY ON USED_GOODS_BOARD.BOARD_ID = USED_GOODS_REPLY.BOARD_ID
WHERE YEAR(USED_GOODS_BOARD.CREATED_DATE) = 2022 AND MONTH(USED_GOODS_BOARD.CREATED_DATE) = 10
ORDER BY USED_GOODS_REPLY.CREATED_DATE ASC, USED_GOODS_BOARD.TITLE ASC;

-- 배운 것: ON 조건은 두 테이블을 연결하는 공통 컬럼이다. 조건을 빼먹지 말자.



-- =====================
-- 8. 강원도에 위치한 생산공장 목록 출력하기
-- =====================
-- 문제: FOOD_FACTORY 테이블에서 강원도에 위치한 식품공장의 공장 ID, 공장 이름, 주소를 조회하는 SQL문을 작성해주세요. 이때 결과는 공장 ID를 기준으로 오름차순 정렬해주세요.
-- FOOD_FACTORY : FACTORY_ID, FACTORY_NAME, ADDRESS, TLNO
-- 내 생각: (1)주소 데이터에 '강원도' 포함 (2)ORDER BY 공장ID ASC

-- 정답:
SELECT FACTORY_ID, FACTORY_NAME, ADDRESS
FROM FOOD_FACTORY
WHERE ADDRESS LIKE '강원도%'
ORDER BY FACTORY_ID ASC;

-- 배운 것: 원하는 문자열을 찾는 함수는 LIKE 함수이고 함께 사용하는 와일드카드 문자로는 %,_가 있다.



-- =====================
-- 9. 모든 레코드 조회하기
-- =====================
-- 문제: 동물 보호소에 들어온 모든 동물의 정보를 ANIMAL_ID순으로 조회하는 SQL문을 작성해주세요.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: ANIMAL_INS 테이블에서 모든 정보를 조회하되, 기준을 ANIMAL_ID로

-- 정답 같은 오답1:
SELECT *
FROM ANIMAL_INS;
-- 틀린 이유: ANIMAL_ID를 기준으로 정리하지 않았음

-- 정답:
SELECT *
FROM ANIMAL_INS
ORDER BY ANIMAL_ID ASC;

-- 배운 것: ASC를 생략할 수 있는 건 ORDER BY를 썼을 때이다.



-- =====================
-- 10. 역순 정렬하기
-- =====================
-- 문제: 동물 보호소에 들어온 모든 동물의 이름과 보호 시작일을 조회하는 SQL문을 작성해주세요. 이때 결과는 ANIMAL_ID 역순으로 보여주세요. 
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: 기본값이 ASC이니까, 역순이라면 DESC

SELECT NAME, DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC;

-- 배운 것: 내가 생각한 게 맞았다.