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

-- 정답: 
SELECT NAME, DATETIME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID DESC;

-- 배운 것: 내가 생각한 게 맞았다.



-- =====================
-- 11. 아픈 동물 찾기
-- =====================
-- 문제: 동물 보호소에 들어온 동물 중 아픈 동물(INTAKE_CONDITION이 Sick 인 경우를 뜻함)의 아이디와 이름을 조회하는 SQL 문을 작성해주세요. 이때 결과는 아이디 순으로 조회해주세요.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: (1)아이디, 이름 데이터를 조회 (2)조건은 condition이 sick인 경우 (3)아이디를 오름차순으로

-- 정답:
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION = 'Sick'
ORDER BY ANIMAL_ID ASC;

-- 배운 것: 배웠던 것 복습!



-- =====================
-- 12. 어린 동물 찾기
-- =====================
-- 문제: 동물 보호소에 들어온 동물 중 젊은 동물(INTAKE_CONDITION이 Aged가 아닌 경우를 뜻함)의 아이디와 이름을 조회하는 SQL 문을 작성해주세요. 이때 결과는 아이디 순으로 조회해주세요.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: (1)아이디, 이름 데이터 조회 (2)조건은 condition이 aged가 아님 (3)아이디 순으로 오름차순 정렬

-- 정답:
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE INTAKE_CONDITION != 'Aged'
ORDER BY ANIMAL_ID;

-- 배운 것: '아니다'의 기호는 !=



-- =====================
-- 13. 동물의 아이디와 이름
-- =====================
-- 문제: 동물 보호소에 들어온 모든 동물의 아이디와 이름을 ANIMAL_ID순으로 조회하는 SQL문을 작성해주세요. 
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: (1)아이디, 이름 데이터 조회 (2)animal_id 오름차순 정렬

-- 정답:
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;

-- 배운 것: 이제 기본적인 건 틀리지 않기



-- =====================
-- 14. 여러 기준으로 정렬하기
-- =====================
-- 문제: 동물 보호소에 들어온 모든 동물의 아이디와 이름, 보호 시작일을 이름 순으로 조회하는 SQL문을 작성해주세요. 단, 이름이 같은 동물 중에서는 보호를 나중에 시작한 동물을 먼저 보여줘야 합니다.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: (1)아이디, 이름, 보호 시작일 데이터 조회 (2)이름으로 데이터 정렬 (3)이름이 같다면 보호 시작일 역순 정렬

-- 정답:
SELECT ANIMAL_ID, NAME, DATETIME
FROM ANIMAL_INS
ORDER BY NAME, DATETIME DESC;

-- 배운 것: 



-- =====================
-- 15. 상위 n개 레코드
-- =====================
-- 문제: 동물 보호소에 가장 먼저 들어온 동물의 이름을 조회하는 SQL 문을 작성해주세요.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: (1)이름 데이터 조회 (2)보호 시작일로 데이터 정렬

-- 오답1:
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME;
-- 틀린 이유: 모든 동물 데이터를 보호 시작일 순서로 정렬하는 게 아니라, 가장 먼저 들어온 동물 데이터 딱 하나를 조회해야 한다.

-- 오답2:
SELECT NAME
FROM ANIMAL_INS
LIMIT 1;
-- 틀린 이유: 보호 시작일로 데이터 정렬을 해야한다.

-- 정답:
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME
LIMIT 1;

-- 배운 것: COUNT는 개수를 세고, LIMIT는 개수를 제한한다. 



-- =====================
-- 16. 조건에 맞는 회원수 구하기
-- =====================
-- 문제: USER_INFO 테이블에서 2021년에 가입한 회원 중 나이가 20세 이상 29세 이하인 회원이 몇 명인지 출력하는 SQL문을 작성해주세요.
-- USER_INFO : USER_ID, GENDER, AGE, JOINED
-- GENDER 컬럼은 비어있거나 0 또는 1의 값을 가지며 0인 경우 남자를, 1인 경우는 여자를 나타냅니다.
-- 내 생각: (1)몇 명인지 출력하기 위해 COUNT 함수를 사용 (2)조건은 가입일이 2021년 AND 나이가 20 이상 29 이하

-- 오답1:
SELECT *
FROM USER_INFO
WHERE YEAR(JOINED) = 2021 AND AGE >= 20 AND AGE <= 29;
-- 틀린 이유: 테스트 한다고 COUNT 함수 뺀 걸 까먹음

-- 정답:
SELECT COUNT(*)
FROM USER_INFO
WHERE YEAR(JOINED) = 2021 AND AGE >= 20 AND AGE <= 29;

-- 배운 것: COUNT 함수 사용하는 방법을 알게 됐다.

-- 더 좋은 답안:
SELECT COUNT(*)
FROM USER_INFO
WHERE YEAR(JOINED) = 2021 AND AGE BETWEEN 20 AND 29;

-- 양쪽 경계값을 포함하는 이상 이하를 표현할 때는 BETWEEN을 쓰면 효율적



-- =====================
-- 17. Python 개발자 찾기
-- =====================
-- 문제: DEVELOPER_INFOS 테이블에서 Python 스킬을 가진 개발자의 정보를 조회하려 합니다. Python 스킬을 가진 개발자의 ID, 이메일, 이름, 성을 조회하는 SQL 문을 작성해 주세요. 결과는 ID를 기준으로 오름차순 정렬해 주세요.
-- DEVELOPER_INFOS : ID, FIRST_NAME, LAST_NAME, EMAIL, SKILL_1, SKILL_2, SKILL_3
-- 내 생각: (1) 아이디, 이메일, 이름, 성 데이터 조회 (2)조건은 스킬1,2,3 중 하나라도 파이썬이 포함 -> or을 사용하면 되지 않을까? (3)아이디 기준 오름차순 정렬

-- 정답:
SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPER_INFOS
WHERE SKILL_1 = 'Python' OR SKILL_2 = 'Python' OR SKILL_3 = 'Python'
ORDER BY ID;

-- 더 좋은 답안:
SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPER_INFOS
WHERE 'Python' IN (SKILL_1, SKILL_2, SKILL_3)
ORDER BY ID;

-- 배운 것: AND와 OR 을 각각 대체할 수 있는 것은 BETWEEN과 IN이다.



-- =====================
-- 18. 잔챙이 잡은 수 구하기
-- =====================
-- 문제: 잡은 물고기 중 길이가 10cm 이하인 물고기의 수를 출력하는 SQL 문을 작성해주세요. 물고기의 수를 나타내는 컬럼 명은 FISH_COUNT로 해주세요.
-- 단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.
-- FISH_INFO : ID, FISH_TYPE, LENGTH, TIME
-- 내 생각: (1)COUNT 함수를 쓰되, 길이가 10 이하일 경우에는 값이 null이므로 null까지 포함해서 개수를 세는 * 파라미터를 사용 (2)조건이 10 이하여야 하는데 이러면 값이 null인데.. 이걸 어떻게 써야 할까
-- 시도: WHERE LENGTH = NULL (X)

SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO
WHERE LENGTH IS NULL;

-- 배운 것: IS NULL = 값이 NULL인 것만 / IS NOT NULL = 값이 NULL이 아닌 것만 / IFNULL(data, '대체값') = data가 NULL일 경우 대체값으로 출력



-- =====================
-- 19. 가장 큰 물고기 10마리 구하기
-- =====================
-- 문제: FISH_INFO 테이블에서 가장 큰 물고기 10마리의 ID와 길이를 출력하는 SQL 문을 작성해주세요. 결과는 길이를 기준으로 내림차순 정렬하고, 길이가 같다면 물고기의 ID에 대해 오름차순 정렬해주세요. 단, 가장 큰 물고기 10마리 중 길이가 10cm 이하인 경우는 없습니다. ID 컬럼명은 ID, 길이 컬럼명은 LENGTH로 해주세요.
-- 단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.
-- FISH_INFO : ID, FISH_TYPE, LENGTH, TIME
-- 내 생각: (1)id, 길이 조회 (2)길이로 내림차순 정렬, 같다면 id로 오름차순 정렬 (3)상위 10마리 중 10 이하는 없음(=null은 없음) (4)개수가 아니기 때문에 count가 아니라 limit

SELECT ID, LENGTH
FROM FISH_INFO
ORDER BY LENGTH DESC, ID ASC
LIMIT 10;

-- 배운 것: count랑 limit를 잘 구분하기



-- =====================
-- 20. 특정 형질을 가지는 대장균 찾기
-- =====================
-- 대장균들은 일정 주기로 분화하며, 분화를 시작한 개체를 부모 개체, 분화가 되어 나온 개체를 자식 개체라고 합니다. 다음은 실험실에서 배양한 대장균들의 정보를 담은 ECOLI_DATA 테이블입니다. ECOLI_DATA 테이블의 구조는 다음과 같으며, ID, PARENT_ID, SIZE_OF_COLONY, DIFFERENTIATION_DATE, GENOTYPE 은 각각 대장균 개체의 ID, 부모 개체의 ID, 개체의 크기, 분화되어 나온 날짜, 개체의 형질을 나타냅니다.
-- 문제: 2번 형질이 보유하지 않으면서 1번이나 3번 형질을 보유하고 있는 대장균 개체의 수(COUNT)를 출력하는 SQL 문을 작성해주세요. 1번과 3번 형질을 모두 보유하고 있는 경우도 1번이나 3번 형질을 보유하고 있는 경우에 포함합니다.
-- ECOLI_DATA : ID, PARENT_ID, SIZE_OF_COLONY, DIFFERENTIATION_DATE, GENOTYPE
-- 최초의 대장균 개체의 PARENT_ID 는 NULL 값입니다.
-- 각 대장균 별 형질을 2진수로 나타내면 다음과 같습니다. : ID 1 : 1000₍₂₎ / ID 2 : 1111₍₂₎ / ID 3 : 1₍₂₎ / ID 4 : 1101₍₂₎
-- 각 대장균 별 보유한 형질을 다음과 같습니다. : ID 1 : 4 / ID 2 : 1, 2, 3, 4 / ID 3 : 1 / ID 4 : 1, 3, 4
-- 따라서 2번 형질이 없는 대장균 개체는 ID 1, ID 3, ID 4 이며 이 중 1번이나 3번 형질을 보유한 대장균 개체는 ID 3, ID 4 입니다.
-- 내 생각: (1)개체 수를 출력해야 하므로 count (2)조건은 1번과 3번 형질 둘 중 하나만 보유하고 있어도 됨

SELECT COUNT(*) AS COUNT
FROM ECOLI_DATA
WHERE GENOTYPE & 2 = 0 AND (GENOTYPE & 1 != 0 OR GENOTYPE & 4 != 0);

-- 배운 것: '&'는 '이 자리에 체크가 됐는지' 확인하는 비트 연산자이다... 근데 개념이 너무 어려워서 따로 찾아볼 것!