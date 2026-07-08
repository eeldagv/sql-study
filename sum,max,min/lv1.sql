-- =====================
-- 1. 가장 비싼 상품 구하기
-- =====================
-- 문제: PRODUCT 테이블에서 판매 중인 상품 중 가장 높은 판매가를 출력하는 SQL문을 작성해주세요. 이때 컬럼명은 MAX_PRICE로 지정해주세요.
-- PRODUCT 테이블 : PRODUCT_ID 상품 ID, PROUCT_CODE 상품코드, PRICE 판매가
-- 내 생각: 상품 ID, 상품가는 중요하지 않으므로 신경쓰지 않고, PRICE 컬럼에서 MAX를 통해 가격의 최대값을 출력한다.

-- 정답:
SELECT MAX(PRICE) AS MAX_PRICE
FROM PRODUCT;

-- 배운 것: 집계함수는 SELECT 바로 뒤에 써주고, 괄호 안에 컬럼명을 작성한다.



-- =====================
-- 2. 최댓값 구하기
-- =====================
-- 문제: 가장 최근에 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.
-- ANIMAL_INS 테이블 = 동물 보호소에 들어온 동물의 정보 : ANIMAL_ID 동물의 아이디, ANIMAL_TYPE 생물 종, DATETIME 보호 시작일, INTAKE_CONDITION 보호 시작 시 상태, NAME 이름, SEX_UPON_INTAKE 성별 및 중성화 여부
-- 내 생각: 가장 최근에 들어온 동물이 '언제' 들어왔는지만 조회하면 되므로 DATETIME 외의 컬럼들은 신경쓰지 않음. 데이트 포맷에 대한 조건은 따로 없기 때문에 DATE 만 사용해도 될 듯.

-- 정답:
SELECT MAX(DATETIME) AS 시간
FROM ANIMAL_INS;

-- 배운 것: 날짜는 과거보다 미래일수록 최대값이다.



-- =====================
-- 3. 잡은 물고기 중 가장 큰 물고기의 길이 구하기
-- =====================
-- 문제: FISH_INFO 테이블에서 잡은 물고기 중 가장 큰 물고기의 길이를 'cm' 를 붙여 출력하는 SQL 문을 작성해주세요. 이 때 컬럼명은 'MAX_LENGTH' 로 지정해주세요.
-- FISH_INFO = 잡은 물고기들의 정보 : ID 물고기의 ID, FISH_TYPE 물고기의 종류(숫자), LENGTH 잡은 물고기의 길이(cm), TIME 물고기를 잡은 날짜
-- 내 생각:
-- (1) LENGTH 컬럼만 추출하면 되고 MAX를 사용
-- (2) 추출한 값에 문자열을 붙이려면 무엇을 써야할까?

-- 정답:
SELECT CONCAT(MAX(LENGTH), 'cm') AS MAX_LENGTH
FROM FISH_INFO;

-- 배운 것: 원하는 문자열을 연결할 때는 CONCAT을 사용한다. SELECT 바로 뒤에 써주고, 콤마로 연결한다. 