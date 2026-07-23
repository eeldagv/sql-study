-- =====================
-- 1. 경기도에 위치한 식품창고 목록 출력하기
-- =====================
-- 문제: 다음은 식품창고의 정보를 담은 FOOD_WAREHOUSE 테이블입니다. FOOD_WAREHOUSE 테이블은 다음과 같으며 WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, TLNO, FREEZER_YN는 창고 ID, 창고 이름, 창고 주소, 전화번호, 냉동시설 여부를 의미합니다.
-- FOOD_WAREHOUSE 테이블에서 경기도에 위치한 창고의 ID, 이름, 주소, 냉동시설 여부를 조회하는 SQL문을 작성해주세요. 이때 냉동시설 여부가 NULL인 경우, 'N'으로 출력시켜 주시고 결과는 창고 ID를 기준으로 오름차순 정렬해주세요.
-- 내 생각: IFNULL을 사용해서 NULL일 경우 대체값을 넣어서 출력한다.

-- 정답:
SELECT WAREHOUSE_ID, WAREHOUSE_NAME, ADDRESS, IFNULL(FREEZER_YN, 'N') AS FREEZER_YN
FROM FOOD_WAREHOUSE
WHERE ADDRESS LIKE '%경기%'
ORDER BY WAREHOUSE_ID;

-- 배운 것: 원하는 문자열을 찾는 'LIKE' 까먹지 말자!



-- =====================
-- 2. 이름이 없는 동물의 아이디
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- 동물 보호소에 들어온 동물 중, 이름이 없는 채로 들어온 동물의 ID를 조회하는 SQL 문을 작성해주세요. 단, ID는 오름차순 정렬되어야 합니다.
-- 내 생각: 이름이 없음 = 이름 컬럼의 값이 NULL임, 따라서 조건을 IS NULL인지로 걸어야 한다.

-- 정답: 
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NULL
ORDER BY ANIMAL_ID;



-- =====================
-- 3. 이름이 있는 동물의 아이디
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- 동물 보호소에 들어온 동물 중, 이름이 있는 동물의 ID를 조회하는 SQL 문을 작성해주세요. 단, ID는 오름차순 정렬되어야 합니다.
-- 내 생각: 이름이 있다면 값이 NULL이 아니므로 이 때는 IS NOT NULL을 사용한다.

-- 정답: 
SELECT ANIMAL_ID
FROM ANIMAL_INS
WHERE NAME IS NOT NULL
ORDER BY ANIMAL_ID;



-- =====================
-- 4. 나이 정보가 없는 회원 수 구하기
-- =====================
-- 문제: 다음은 어느 의류 쇼핑몰에 가입한 회원 정보를 담은 USER_INFO 테이블입니다. USER_INFO 테이블은 아래와 같은 구조로 되어있으며, USER_ID, GENDER, AGE, JOINED는 각각 회원 ID, 성별, 나이, 가입일을 나타냅니다. GENDER 컬럼은 비어있거나 0 또는 1의 값을 가지며 0인 경우 남자를, 1인 경우는 여자를 나타냅니다.
-- USER_INFO 테이블에서 나이 정보가 없는 회원이 몇 명인지 출력하는 SQL문을 작성해주세요. 이때 컬럼명은 USERS로 지정해주세요.
-- 내 생각: 나이 정보가 '없는' 행을 찾아야 하고, 몇 개인지 세어야 하므로 IS NULL과 COUNT를 사용한다.

-- 정답:
SELECT COUNT(*) AS USERS
FROM USER_INFO
WHERE AGE IS NULL;

-- 배운 것: COUNT 함수는 괄호 안의 값이 *일 때 NULL을 포함한 모든 행의 개수를 세고, 컬럼명일 때는 NULL을 제외한 행의 개수를 센다. DISTINCT 컬럼명을 써주면 중복을 제거한 개수를 세어준다. 잊지 말자!



-- =====================
-- 5. 잡은 물고기의 평균 길이 구하기
-- =====================
-- 문제: 낚시앱에서 사용하는 FISH_INFO 테이블은 잡은 물고기들의 정보를 담고 있습니다. FISH_INFO 테이블의 구조는 다음과 같으며 ID, FISH_TYPE, LENGTH, TIME은 각각 잡은 물고기의 ID, 물고기의 종류(숫자), 잡은 물고기의 길이(cm), 물고기를 잡은 날짜를 나타냅니다. 단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH 가 NULL 이며, LENGTH 에 NULL 만 있는 경우는 없습니다.
-- 잡은 물고기의 평균 길이를 출력하는 SQL문을 작성해주세요. 평균 길이를 나타내는 컬럼 명은 AVERAGE_LENGTH로 해주세요. 평균 길이는 소수점 3째자리에서 반올림하며, 10cm 이하의 물고기들은 10cm 로 취급하여 평균 길이를 구해주세요.
-- 내 생각: 평균 길이를 구해야 하므로 AVG 함수를 사용한다.
-- 물고기 길이가 10cm 이하면 값이 NULL인데, 계산할 때는 10cm로 취급해야 하므로 IFNULL을 사용해서 대체값으로 설정해준다.

-- 정답: 
SELECT ROUND(AVG(IFNULL(LENGTH, 10)),2) AS AVERAGE_LENGTH
FROM FISH_INFO;

-- 배운 것: LENGTH가 숫자 컬럼이라서 대체값도 숫자이므로 따옴표 안에 쓰면 안 된다.