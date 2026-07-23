-- =====================
-- 1. NULL 처리하기
-- =====================
-- 문제: ANIMAL_INS 테이블은 동물 보호소에 들어온 동물의 정보를 담은 테이블입니다. ANIMAL_INS 테이블 구조는 다음과 같으며, ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE는 각각 동물의 아이디, 생물 종, 보호 시작일, 보호 시작 시 상태, 이름, 성별 및 중성화 여부를 나타냅니다.
-- 입양 게시판에 동물 정보를 게시하려 합니다. 동물의 생물 종, 이름, 성별 및 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요. 이때 프로그래밍을 모르는 사람들은 NULL이라는 기호를 모르기 때문에, 이름이 없는 동물의 이름은 "No name"으로 표시해 주세요.
-- 내 생각: IFNULL을 사용해서 NULL 값을 No name으로 대체한다.

SELECT ANIMAL_TYPE, IFNULL(NAME, 'No name') AS NAME, SEX_UPON_INTAKE
FROM ANIMAL_INS
ORDER BY ANIMAL_ID;



-- =====================
-- 2. ROOT 아이템 구하기
-- =====================
-- 문제: 어느 한 게임에서 사용되는 아이템들은 업그레이드가 가능합니다. 'ITEM_A'->'ITEM_B'와 같이 업그레이드가 가능할 때 'ITEM_A'를 'ITEM_B'의 PARENT 아이템, PARENT 아이템이 없는 아이템을 ROOT 아이템이라고 합니다.
-- 예를 들어 'ITEM_A'->'ITEM_B'->'ITEM_C' 와 같이 업그레이드가 가능한 아이템이 있다면 'ITEM_C'의 PARENT 아이템은 'ITEM_B', 'ITEM_B'의 PARENT 아이템은 'ITEM_A', ROOT 아이템은 'ITEM_A'가 됩니다.
-- 다음은 해당 게임에서 사용되는 아이템 정보를 담은 ITEM_INFO 테이블과 아이템 관계를 나타낸 ITEM_TREE 테이블입니다. ITEM_INFO 테이블은 다음과 같으며, ITEM_ID, ITEM_NAME, RARITY, PRICE는 각각 아이템 ID, 아이템 명, 아이템의 희귀도, 아이템의 가격을 나타냅니다.
-- ITEM_TREE 테이블은 다음과 같으며, ITEM_ID, PARENT_ITEM_ID는 각각 아이템 ID, PARENT 아이템의 ID를 나타냅니다.
-- 단, 각 아이템들은 오직 하나의 PARENT 아이템 ID를 가지며, ROOT 아이템의 PARENT 아이템 ID는 NULL 입니다. ROOT 아이템이 없는 경우는 존재하지 않습니다.
-- ROOT 아이템을 찾아 아이템 ID(ITEM_ID), 아이템 명(ITEM_NAME)을 출력하는 SQL문을 작성해 주세요. 이때, 결과는 아이템 ID를 기준으로 오름차순 정렬해 주세요.
-- 내 생각: 먼저 ITEM_ID 컬럼을 이용해 두 테이블을 JOIN 한다
-- ROOT 아이템은 PARENT 아이템이 없는 아이디이므로, 두 테이블을 JOIN 했을 때 PARENT_ITEM_ID가 NULL인 행이다.

-- 정답:
SELECT ITEM_INFO.ITEM_ID, ITEM_NAME
FROM ITEM_INFO
JOIN ITEM_TREE ON ITEM_INFO.ITEM_ID = ITEM_TREE.ITEM_ID
WHERE PARENT_ITEM_ID IS NULL;