-- =====================
-- 1. 조건에 부합하는 중고거래 상태 조회하기
-- =====================
-- 문제: 다음은 중고거래 게시판 정보를 담은 USED_GOODS_BOARD 테이블입니다. USED_GOODS_BOARD 테이블은 다음과 같으며 BOARD_ID, WRITER_ID, TITLE, CONTENTS, PRICE, CREATED_DATE, STATUS, VIEWS은 게시글 ID, 작성자 ID, 게시글 제목, 게시글 내용, 가격, 작성일, 거래상태, 조회수를 의미합니다.
-- USED_GOODS_BOARD 테이블에서 2022년 10월 5일에 등록된 중고거래 게시물의 게시글 ID, 작성자 ID, 게시글 제목, 가격, 거래상태를 조회하는 SQL문을 작성해주세요. 거래상태가 SALE 이면 판매중, RESERVED이면 예약중, DONE이면 거래완료 분류하여 출력해주시고, 결과는 게시글 ID를 기준으로 내림차순 정렬해주세요.
-- 내 생각: 거래상태에 따라 표시를 다르게 해야 하기 때문에 CASE WHEN을 사용한다.
-- 또한 조건은 작성일이 '2022년 10월 5일' 인 행으로 한다.

-- 정답:
SELECT BOARD_ID, WRITER_ID, TITLE, PRICE, 
    CASE
        WHEN STATUS = 'SALE' THEN '판매중'
        WHEN STATUS = 'RESERVED' THEN '예약중'
        ELSE '거래완료'
    END AS STATUS
FROM USED_GOODS_BOARD
WHERE CREATED_DATE = '2022-10-05'
ORDER BY BOARD_ID DESC;

-- 배운 것: 날짜를 비교할 때, 특정한 연월일이 명시되어 있다면
WHERE DATE(컬럼) = '0000-00-00'
-- 라고 쓸 수 있다. 만약 컬럼이 원래 DATE 타입이라면
WHERE 컬럼 = '0000-00-00'
-- 라고 써줘도 된다.



-- =====================
-- 2. 자동차 평균 대여 기간 구하기
-- =====================
-- 문제: 다음은 어느 자동차 대여 회사의 자동차 대여 기록 정보를 담은 CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블입니다. CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블은 아래와 같은 구조로 되어있으며, HISTORY_ID, CAR_ID, START_DATE, END_DATE 는 각각 자동차 대여 기록 ID, 자동차 ID, 대여 시작일, 대여 종료일을 나타냅니다.
-- CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 평균 대여 기간이 7일 이상인 자동차들의 자동차 ID와 평균 대여 기간(컬럼명: AVERAGE_DURATION) 리스트를 출력하는 SQL문을 작성해주세요. 평균 대여 기간은 소수점 두번째 자리에서 반올림하고, 결과는 평균 대여 기간을 기준으로 내림차순 정렬해주시고, 평균 대여 기간이 같으면 자동차 ID를 기준으로 내림차순 정렬해주세요.
-- 내 생각: 대여 기간 = 종료일에서 시작일을 뺀 값에서 +1 여기에다 AVG 함수를 쓰면 되나?
-- 조건은 종료일 - 시작일 + 1 이 7 이상

-- 오답:
SELECT CAR_ID, ROUND(AVG(DATEDIFF(END_DATE, START_DATE) + 1), 1) AS AVERAGE_DURATION
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE DATEDIFF(END_DATE, START_DATE) + 1 >= 7
ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC;
-- 틀린 이유:
-- 같은 자동차를 여러번 대여했을 수 있으므로, '자동차별'로 묶어서 평균을 내야 한다.
-- 따라서 조건도 자동차별 평균 대여기간이 아니라 개별 대여기간이라 틀렸다.

-- 정답:
SELECT CAR_ID, ROUND(AVG(DATEDIFF(END_DATE, START_DATE) + 1), 1) AS AVERAGE_DURATION
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
GROUP BY CAR_ID
HAVING AVERAGE_DURATION >= 7
ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC;

-- 배운 것: WHERE에는 SELECT에서 만든 alias를 사용할 수 없지만, HAVING에서는 사용할 수 있다.
-- 왜냐하면 쿼리의 실행은 FROM -> WHERE -> GROUP BY -> SELECT -> ORDER BY 순으로 진행되기 때문이다. 
-- 원래는 SELECT가 HAVING 보다 나중인데, MySQL이 편의상 HAVING에서 alias를 허용해준다.
-- 다만 Oracle 등에서는 안 되는 경우가 있으므로, 안전하게 쓰려면 집계함수를 그대로 반복해서 쓰는 게 좋다.



-- =====================
-- 3. 루시와 엘라 찾기
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- 동물 보호소에 들어온 동물 중 이름이 Lucy, Ella, Pickle, Rogan, Sabrina, Mitty인 동물의 아이디와 이름, 성별 및 중성화 여부를 조회하는 SQL 문을 작성해주세요.
-- 내 생각: 이 경우 WHERE IN 을 사용하여 조건을 건다.

-- 정답:
SELECT ANIMAL_ID, NAME, SEX_UPON_INTAKE
FROM ANIMAL_INS
WHERE NAME IN ('Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty');



-- =====================
-- 4. 이름에 el이 들어가는 동물 찾기
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- 보호소에 돌아가신 할머니가 기르던 개를 찾는 사람이 찾아왔습니다. 이 사람이 말하길 할머니가 기르던 개는 이름에 'el'이 들어간다고 합니다. 동물 보호소에 들어온 동물 이름 중, 이름에 "EL"이 들어가는 개의 아이디와 이름을 조회하는 SQL문을 작성해주세요. 이때 결과는 이름 순으로 조회해주세요. 만약 이름이 같은 경우 아이디를 기준으로 조회해주세요. 단, 이름의 대소문자는 구분하지 않습니다.
-- 내 생각: 특정 문자열이 포함된 것을 찾는 것이므로 LIKE를 사용한다.

-- 정답:
SELECT ANIMAL_ID, NAME
FROM ANIMAL_INS
WHERE ANIMAL_TYPE = 'Dog' AND NAME LIKE('%el%')
ORDER BY NAME, ANIMAL_ID;



-- =====================
-- 5. 중성화 여부 파악하기
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- 보호소의 동물이 중성화되었는지 아닌지 파악하려 합니다. 중성화된 동물은 SEX_UPON_INTAKE 컬럼에 'Neutered' 또는 'Spayed'라는 단어가 들어있습니다. 동물의 아이디와 이름, 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요. 이때 중성화가 되어있다면 'O', 아니라면 'X'라고 표시해주세요.
-- 내 생각: 'Neutered'와 'Spayed'는 암수를 구분하는 단어이고 둘 다 중성화가 되었다는 뜻이므로 IN을 사용한다. XX <- 해당 단어가 '들어있는' 이므로 LIKE를 사용해야 한다.
-- 또한 CASE WHEN을 함께 사용하여 중성화 여부를 표기하도록 한다.

-- 정답:
SELECT ANIMAL_ID, NAME,
    CASE
        WHEN SEX_UPON_INTAKE LIKE '%Neutered%' OR SEX_UPON_INTAKE LIKE '%Spayed%' THEN 'O'
        ELSE 'X'
    END AS 중성화
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;

-- 다른 정답:
SELECT ANIMAL_ID, NAME,
    CASE
        WHEN SEX_UPON_INTAKE REGEXP 'Neutered|Spayed' THEN 'O'
        ELSE 'X'
    END AS 중성화
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;

-- 배운 것: 정규표현식 REGEXP
-- 패턴으로 문자열을 찾는 방법이고, LIKE보다 더 복잡하고 정교한 조건을 표현할 수 있다.
-- LIKE는 와일드카드가 '%(아무 글자 여러 개)', '_(아무 글자 하나)' 두 개 뿐이다.

-- | : 또는(OR) ex) 'A|B' -> A 또는 B
-- ^ : 시작 ex) '^김' -> '김'으로 시작
-- $ : 끝 ex) '수$' -> '수'로 끝남
-- [abc] : a,b,c 중 하나 ex) '[abc]'
-- [0-9] : 숫자 하나 ex) '[0-9]'
-- [a-z] : 소문자 하나 ex) '[a-z]'
-- . : 아무 글자 하나 ex) 'a.c' -> abc, axc 등
-- * : 앞글자 0개 이상 ex) 'ab*' -> * 바로 앞 글자인 b가 0개 이상이면 OK a, ab, abb...
-- + : 앞글자 1개 이상 ex) 'ab+' -> + 바로 앞 글자인 b가 1개 이상 ab, abb...
-- \\ : '이 뒤에 오는 기호를 특수문자가 아니라 문자열로 봐 줘.'

WHERE 이메일 REGEXP '@(gmail|naver|daum)\\.com'
-- gmail.com, naver.com, daum.com 중 하나



-- =====================
-- 6. 카테고리 별 상품 개수 구하기
-- =====================
-- 문제: 다음은 어느 의류 쇼핑몰에서 판매중인 상품들의 정보를 담은 PRODUCT 테이블입니다. PRODUCT 테이블은 아래와 같은 구조로 되어있으며, PRODUCT_ID, PRODUCT_CODE, PRICE는 각각 상품 ID, 상품코드, 판매가를 나타냅니다.
-- 상품 별로 중복되지 않는 8자리 상품코드 값을 가지며, 앞 2자리는 카테고리 코드를 의미합니다.
-- PRODUCT 테이블에서 상품 카테고리 코드(PRODUCT_CODE 앞 2자리) 별 상품 개수를 출력하는 SQL문을 작성해주세요. 결과는 상품 카테고리 코드를 기준으로 오름차순 정렬해주세요.
-- 내 생각: 앞 글자를 추출하는 문자열 함수 LEFT를 사용해서 상품 코드 앞 2자리를 추출한다. 
-- 카테고리 별 상품 개수를 출력해야 하므로 COUNT를 사용한다.

-- 정답:
SELECT LEFT(PRODUCT_CODE, 2) AS CATEGORY, COUNT(*) AS PRODUCTS
FROM PRODUCT
GROUP BY CATEGORY
ORDER BY CATEGORY;

-- 배운 것: 
-- LEFT(컬럼, N) -> 왼쪽에서 N글자만
-- RIGHT(컬럼, N) -> 오른쪽에서 N글자만
-- SUBSTRING(컬럼, 시작위치, 길이) -> 시작위치로부터 길이만큼, 길이를 안 쓰면 끝까지



-- =====================
-- 7. DATETIME에서 DATE로 형 변환
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- ANIMAL_INS 테이블에 등록된 모든 레코드에 대해, 각 동물의 아이디와 이름, 들어온 날짜(시각(시-분-초)을 제외한 날짜(년-월-일)만 보여주세요.)를 조회하는 SQL문을 작성해주세요. 이때 결과는 아이디 순으로 조회해야 합니다.
-- 내 생각: DATE를 사용해서 날짜의 시각을 제외하고 날짜만을 추출한다.

-- 정답:
SELECT ANIMAL_ID, NAME, DATE(DATETIME) AS DATE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;



-- =====================
-- 8. 연도 별 평균 미세먼지 농도 조회하기
-- =====================
-- 문제: AIR_POLLUTION 테이블은 전국의 월별 미세먼지 정보를 담은 테이블입니다. AIR_POLLUTION 테이블의 구조는 다음과 같으며 LOCATION1, LOCATION2, YM, PM_VAL1, PM_VAL2은 각각 지역구분1, 지역구분2, 측정일, 미세먼지 오염도, 초미세먼지 오염도를 의미합니다.
-- AIR_POLLUTION 테이블에서 수원 지역의 연도 별 평균 미세먼지 오염도와 평균 초미세먼지 오염도를 조회하는 SQL문을 작성해주세요. 이때, 평균 미세먼지 오염도와 평균 초미세먼지 오염도의 컬럼명은 각각 PM10, PM2.5로 해 주시고, 값은 소수 셋째 자리에서 반올림해주세요. 결과는 연도를 기준으로 오름차순 정렬해주세요.
-- 내 생각: 조건은 지역 = LOCATION2가 수원이어야 한다.
-- YM 컬럼에서 연도만 추출해서 연도별로 묶어준더.

-- 정답:
SELECT YEAR(YM) AS YEAR, ROUND(AVG(PM_VAL1), 2) AS PM10, ROUND(AVG(PM_VAL2), 2) AS 'PM2.5'
FROM AIR_POLLUTION
WHERE LOCATION2 = '수원'
GROUP BY YEAR(YM)
ORDER BY YEAR(YM);



-- =====================
-- 9. 분기별 분화된 대장균의 개체 수 구하기
-- =====================
-- 문제: 대장균들은 일정 주기로 분화하며, 분화를 시작한 개체를 부모 개체, 분화가 되어 나온 개체를 자식 개체라고 합니다.
-- 다음은 실험실에서 배양한 대장균들의 정보를 담은 ECOLI_DATA 테이블입니다. ECOLI_DATA 테이블의 구조는 다음과 같으며, ID, PARENT_ID, SIZE_OF_COLONY, DIFFERENTIATION_DATE, GENOTYPE 은 각각 대장균 개체의 ID, 부모 개체의 ID, 개체의 크기, 분화되어 나온 날짜, 개체의 형질을 나타냅니다. 최초의 대장균 개체의 PARENT_ID 는 NULL 값입니다.
-- 각 분기(QUARTER)별 분화된 대장균의 개체의 총 수(ECOLI_COUNT)를 출력하는 SQL 문을 작성해주세요. 이때 각 분기에는 'Q' 를 붙이고 분기에 대해 오름차순으로 정렬해주세요. 대장균 개체가 분화되지 않은 분기는 없습니다.
-- 내 생각: 날짜가 몇 분기인지 알려주는 QUARTER 함수와 분화되어 나온 날짜 컬럼을 사용하여 분기를 구한다. 

-- 정답:
SELECT CONCAT(QUARTER(DIFFERENTIATION_DATE), 'Q') AS QUARTER, COUNT(*) AS ECOLI_COUNT
FROM ECOLI_DATA
GROUP BY QUARTER(DIFFERENTIATION_DATE)
ORDER BY QUARTER(DIFFERENTIATION_DATE);

-- 배운 것: QUARTER(날짜) 함수는 날짜가 몇 분기인지 알려주는 함수이다.