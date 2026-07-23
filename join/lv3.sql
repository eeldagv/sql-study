-- =====================
-- 1. 없어진 기록 찾기
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- ANIMAL_OUTS 테이블은 동물 보호소에서 입양 보낸 동물의 정보를 담은 테이블입니다. ANIMAL_OUTS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, NAME, SEX_UPON_OUTCOME는 각각 동물의 아이디, 생물 종, 입양일, 이름, 성별 및 중성화 여부를 나타냅니다. ANIMAL_OUTS 테이블의 ANIMAL_ID는 ANIMAL_INS의 ANIMAL_ID의 외래 키입니다.
-- 천재지변으로 인해 일부 데이터가 유실되었습니다. 입양을 간 기록은 있는데, 보호소에 들어온 기록이 없는 동물의 ID와 이름을 ID 순으로 조회하는 SQL문을 작성해주세요.
-- 내 생각: 우선 ANIMAL_ID 컬럼으로 두 테이블을 JOIN 한다.
-- 이 때, 기존 방식대로 JOIN(INNER JOIN) 하면, JOIN한 결과에서 들어온 기록이 없는 동물에 대한 행이 아예 사라지게 된다.
-- 들어온 기록이 없는 동물에 대한 행도 살리기 위해서는 LEFT JOIN이 필요하다.
-- JOIN 후, ANIMAL_INS의 ANIMAL_ID가 NULL인 값만 추출한다.

-- 정답:
SELECT ANIMAL_OUTS.ANIMAL_ID, ANIMAL_OUTS.NAME
FROM ANIMAL_OUTS
LEFT JOIN ANIMAL_INS ON ANIMAL_OUTS.ANIMAL_ID = ANIMAL_INS.ANIMAL_ID
WHERE ANIMAL_INS.ANIMAL_ID IS NULL
ORDER BY ANIMAL_OUTS.ANIMAL_ID;

-- 배운 것: 기존의 JOIN = INNER JOIN은 일치하는 값이 없으면 행이 알아서 걸러진다.
-- LEFT JOIN은 걸러지지 않고 NULL로 JOIN 되어 보여진다.



-- =====================
-- 2. 있었는데요 없었습니다
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- ANIMAL_OUTS 테이블은 동물 보호소에서 입양 보낸 동물의 정보를 담은 테이블입니다. ANIMAL_OUTS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, NAME, SEX_UPON_OUTCOME는 각각 동물의 아이디, 생물 종, 입양일, 이름, 성별 및 중성화 여부를 나타냅니다. ANIMAL_OUTS 테이블의 ANIMAL_ID는 ANIMAL_INS의 ANIMAL_ID의 외래 키입니다.
-- 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었습니다. 보호 시작일보다 입양일이 더 빠른 동물의 아이디와 이름을 조회하는 SQL문을 작성해주세요. 이때 결과는 보호 시작일이 빠른 순으로 조회해야합니다.
-- 내 생각: 먼저 두 테이블을 ANIMAL_ID로 JOIN 한다.
-- 날짜는 미래가 과거보다 더 큰 수이므로, 관계연산자를 사용하여 날짜를 비교한다.

-- 정답:
SELECT ANIMAL_INS.ANIMAL_ID, ANIMAL_INS.NAME
FROM ANIMAL_INS
JOIN ANIMAL_OUTS ON ANIMAL_INS.ANIMAL_ID = ANIMAL_OUTS.ANIMAL_ID
WHERE ANIMAL_INS.DATETIME > ANIMAL_OUTS.DATETIME
ORDER BY ANIMAL_INS.DATETIME;



-- =====================
-- 3. 오랜 기간 보호한 동물(1)
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- ANIMAL_OUTS 테이블은 동물 보호소에서 입양 보낸 동물의 정보를 담은 테이블입니다. ANIMAL_OUTS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, NAME, SEX_UPON_OUTCOME는 각각 동물의 아이디, 생물 종, 입양일, 이름, 성별 및 중성화 여부를 나타냅니다. ANIMAL_OUTS 테이블의 ANIMAL_ID는 ANIMAL_INS의 ANIMAL_ID의 외래 키입니다.
-- 아직 입양을 못 간 동물 중, 가장 오래 보호소에 있었던 동물 3마리의 이름과 보호 시작일을 조회하는 SQL문을 작성해주세요. 이때 결과는 보호 시작일 순으로 조회해야 합니다.
-- 내 생각: 아직 입양을 못 갔다면 ANIMAL_OUTS에 기록이 없어야 한다.
-- 따라서 LEFT JOIN으로 입양 기록이 없는 행까지 살려야 한다.
-- '가장 오래된 날짜 3개'는 ORDER BY와 함께 LIMIT을 사용하여 추출한다.

-- 정답:
SELECT ANIMAL_INS.NAME, ANIMAL_INS.DATETIME
FROM ANIMAL_INS
LEFT JOIN ANIMAL_OUTS ON ANIMAL_INS.ANIMAL_ID = ANIMAL_OUTS.ANIMAL_ID
WHERE ANIMAL_OUTS.DATETIME IS NULL
ORDER BY ANIMAL_INS.DATETIME
LIMIT 3;

-- 배운 것:
-- LIMIT는 ORDER BY와 함께 쿼리 결과에서 반환할 행의 개수를 제한할 때 사용하는 구문이다.
-- ex) ORDER BY 컬럼 LIMIT 3 -> 오름차순 = 작은 순서대로 정렬하고, 반환할 행의 개수를 3개로 제한
-- n개를 건너뛰고 그 다음 순서부터 추출하고 싶다면 OFFSET을 사용한다.
-- ex) LIMIT 3 OFFSET 5 -> 5개 건너뛰고 그 다음 순서부터 3개
-- 만약 ORDER BY를 안 쓰고 LIMIT를 사용한다면, 오류가 나는 것은 아니지만 DB에 저장된 순서대로 n개를 반환한다. 즉, 순서에 크게 의미가 없다.
-- 랜덤하게 반환하고 싶다면, RAND 함수와 함께 사용한다.