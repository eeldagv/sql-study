-- =====================
-- 1. 3월에 태어난 여성 회원 목록 출력하기
-- =====================
-- 문제: MEMBER_PROFILE 테이블에서 생일이 3월인 여성 회원의 ID, 이름, 성별, 생년월일을 조회하는 SQL문을 작성해주세요. 이때 전화번호가 NULL인 경우는 출력대상에서 제외시켜 주시고, 결과는 회원ID를 기준으로 오름차순 정렬해주세요.
-- MEMBER_PROFILE : MEMBER_ID, MEMBER_NAME, TLNO, GENDER, DATE_OF_BIRTH
-- 내 생각: (1)id, 이름, 성별, 생년월일 데이터를 조회 (2)조건은 생일이 3월이어야 함 (3)전화번호가 null이면 제외 (4)id 기준 오름차순 정렬

-- 오답1:
SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3 AND TLNO IS NOT NULL
ORDER BY MEMBER_ID;
-- 틀린 이유: '여성' 조건이 들어가지 않았다!!

-- 오답2:
SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3 AND GENDER = 'W' AND TLNO IS NOT NULL
ORDER BY MEMBER_ID;
-- 틀린 이유: 날짜 데이터 포맷!!!!!

-- 정답:
SELECT MEMBER_ID, MEMBER_NAME, GENDER, DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE MONTH(DATE_OF_BIRTH) = 3 AND GENDER = 'W' AND TLNO IS NOT NULL
ORDER BY MEMBER_ID;

-- 배운 것: 제발 문제를 잘 읽 자. 조건을 잘 확인하자.

-- (+)6/25 추가: 문제에 주어진 날짜 컬럼의 값도 0000-00-00 형태이고, 추출해도 0000-00-00 형태로 나오는데, 왜 데이트 포맷 함수를 적용해야 하는가?
-- 화면에 보이는 것과 실제 데이터 타입은 다를 수 있다. DATE_OF_BIRTH 컬럼은 DB에 DATE 타입으로 저장되어 있다. 화면에 0000-00-00처럼 보여도 DATE라는 타입의 값이다.
-- DATE 타입은 DB나 클라이언트(브라우저, 프로그램)에 따라 표시 형식이 미묘하게 다를 수 있는데, ex) 2022-1-11 혹은 시간까지 붙어서 0000-00-00 00:00:00
-- 따라서 그대로 추출하는 게 아니라 string 타입으로 명시적으로 포맷하면 항상 똑같은 형태로 고정되기 위함이다.



-- =====================
-- 2. 재구매가 일어난 상품과 회원 리스트 구하기
-- =====================
-- 문제: ONLINE_SALE 테이블에서 동일한 회원이 동일한 상품을 재구매한 데이터를 구하여, 재구매한 회원 ID와 재구매한 상품 ID를 출력하는 SQL문을 작성해주세요. 결과는 회원 ID를 기준으로 오름차순 정렬해주시고 회원 ID가 같다면 상품 ID를 기준으로 내림차순 정렬해주세요.
-- ONLINE_SALE : ONLINE_SALE_ID, USER_ID, PRODUCT_ID, SALES_AMOUNT, SALES_DATE
-- 동일한 날짜, 회원 ID, 상품 ID 조합에 대해서는 하나의 판매 데이터만 존재합니다.
-- 내 생각: (1)회원 id, 상품 id 조회 (2)회원 id 기준으로 오름차순 정렬, 같다면 상품 id 기준으로 내림차순 정렬 (4)회원 id 하나 당 상품 id가 2개 이상 조회되는 것.. 을 어떻게 표현할까? (5)그 데이터를 어떻게 하나씩만 추출할까? (6)회원 id, 상품 id를 조회하는데, 개수가 2개 이상인 데이터만 조회 (7)그룹화 하고 조건 처리

-- 오답1:
SELECT USER_ID, COUNT(PRODUCT_ID) AS PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID HAVING PRODUCT_ID >= 2
ORDER BY USER_ID, PRODUCT_ID DESC;
-- 틀린 이유: (1)GROUP BY 기준이 빠짐 - 동일한 회원 + 동일한 상품 조합 (2)HAVING 조건이 다름 - HAVING은 그룹화된 결과에 조건을 거는 것이므로 개수를 세는 COUNT를 사용, 즉 COUNT를 SELECT에서 쓰면 안 됨 (3)SELECT로는 조회하고자 하는 데이터만

-- 정답:
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID HAVING COUNT(PRODUCT_ID) >= 2
ORDER BY USER_ID ASC, PRODUCT_ID DESC;

-- 배운 것: GROUP BY는 '유형별'로 개수를 알고 싶을 때 컬럼을 그룹화 하는 데 사용하고 HAVING은 그룹화 된 컬럼에 조건을 걸 때 사용한다.

-- (+)6/25 추가:
-- 다시 풀었을 때 답을
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(USER_ID = PRODUCT_ID) >= 2
ORDER BY USER_ID, PRODUCT_ID DESC;
-- 라고 적었는데, 운 좋게 통과는 됐지만 HAVING 조건이 틀리다.
-- GROUP BY에서 그룹화 된 순간 DB가 이미 해당 묶음 개수를 알고 있기 때문
-- 따라서
-- 정답:
SELECT USER_ID, PRODUCT_ID
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >= 2
ORDER BY USER_ID, PRODUCT_ID DESC



-- =====================
-- 3. 업그레이드 된 아이템 구하기
-- =====================
-- 문제: 아이템의 희귀도가 'RARE'인 아이템들의 모든 다음 업그레이드 아이템의 아이템 ID(ITEM_ID), 아이템 명(ITEM_NAME), 아이템의 희귀도(RARITY)를 출력하는 SQL 문을 작성해 주세요. 이때 결과는 아이템 ID를 기준으로 내림차순 정렬주세요.
-- 아이템 정보 ITEM_INFO : ITEM_ID 아이템 ID, ITEM_NAME 아이템명, RARITY 희귀도, PRICE 가격
-- 아이템 관계 ITEM_TREE : ITEM_ID 아이템 ID, PARENT_ITEM_ID PARENT 아이템의 ID
-- ITEM_A -> ITEM_B 와 같이 업그레이드 가능할 때, ITEM_A를 ITEM_B의 PARENT ITEM이라 하고, PARENT 아이템이 없는 아이템을 ROOT 아이템이라고 함
-- 예를 들어, ITEM_A -> ITEM_B -> ITEM_C 와 같이 업그레이드가 가능하다면, ITEM_C의 PARENT 아이템은 ITEM_B, ITEM_B의 PARENT 아이템은 ITEM_A, ROOT 아이템은 ITME_A
-- 단, 각 아이템들은 오직 하나의 PARENT 아이템 ID를 가지며, ROOT 아이템의 PARENT 아이템 ID는 NULL 입니다. ROOT 아이템이 없는 경우는 존재하지 않습니다.
-- RARE : A -> B, C / B -> D, E / D, E -> 업그레이드 불가능

-- 내 생각:
-- (1) ITEM_TREE 테이블은 바꿔 말하면,
-- PARENT_ITEM_ID = 0 = ITEM_A -> PARENT_ITEM_ID = 1 = B / PARENT_ITEM_ID = 2 = C 로 업그레이드 가능
-- PARENT_ITEM_ID = 1 = ITEM_B -> PARENT_ITEM_ID = 3 = D / PARENT_ITEM_ID = 4 = E 로 업그레이드 가능
-- (2) RARITY가 RARE인 ITEM_NAME : ITEM_A, ITEM_B, ITEM_D, ITEM_E = ITEM_ID : 0, 1, 3, 4
-- (3) 0 -> 1, 2 가능 / 1 -> 3, 4 가능 / 3, 4 -> 불가능
-- (4) 따라서 ITEM_ID가 1, 2, 3, 4 인 행들의 값을 ITME_ID 기준 내림차순 정렬

-- HINT:
-- (1) RARE인 아이템의 ID 목록을 구한다 -> ITEM_INFO에서
-- (2) ITEM_TREE에서 PARENT_ITEM_ID가 그 목록에 있는 행을 찾는다 -> 그게 '자식'
-- (3) 그 자식들의  ITME_ID로 ITEM_INFO에서 이름, 희귀도를 가져온다

-- '희귀도가 RARE인 아이템들의 모든 다음 업그레이드 아이템' = '희귀도가 RARE인 아이템들의 모든 자식 아이템'의 어쩌구를 구하기
-- 희귀도가 RARE인 아이템 <- ITEM_INFO 의 자식 아이템을 구하려면?
-- 자식과 부모 관계를 나타내는 ITEM_TREE 를 통해서 구하면 됨
-- 즉, ITEM_INFO로 구한 희귀도가 RARE인 아이템은 곧 부모 아이템이 되는 거니까
-- ITEM_INFO로 구한 희귀도가 RARE인 아이템 = ITEM_TREE의 PARENT_ITEM_ID
-- 짝지어서 각각의 ITEM_ID = 자식을 구하기
-- 그 자식들로 id, 이름, 희귀도 뽑기 <- ITEM_INFO로, 최종 결과물

-- 정답:
SELECT CHILD.ITEM_ID, CHILD.ITEM_NAME, CHILD.RARITY
FROM ITEM_INFO AS PARENT
JOIN ITEM_TREE ON PARENT.ITEM_ID = ITEM_TREE.PARENT_ITEM_ID
JOIN ITEM_INFO AS CHILD ON ITEM_TREE.ITEM_ID = CHILD.ITEM_ID
WHERE PARENT.RARITY = 'RARE'
ORDER BY ITEM_ID DESC;
-- 설명:
-- (1) ITEM_INFO 테이블에서, WHERE로 희귀도가 RARE인 아이템을 걸러낸다.
-- (2) 희귀도가 RARE인 아이템들의 모든 다음 업그레이드 아이템 = 희귀도가 RARE인 아이템들의 모든 자식 아이템 이라는 뜻이다. 즉, '희귀도가 RARE인 아이템'은 부모 아이템이 된다. 따라서 '희귀도가 RARE'인 기준으로 걸러진 ITEM_INFO 테이블에 PARENT라는 별명을 붙인다.
-- (3) '희귀도가 RARE인 아이템'의 ITEM_ID는 각각 0, 1, 3, 4이다. 이 ID의 자식이 되는 ITEM_ID를 찾기 위해 부모-자식 관계를 나타나내는 ITEM_TREE 테이블을 가져와 붙인다.
-- (4) PARENT 테이블의 ITEM_ID는 말 그대로 부모의 아이템 ID이므로, ITEM_TREE 테이블의 PARENT_ITEM_ID 와 일치하는 값끼리 연결하여 붙인다. 이 과정에서, ITEM_ID가 3과 4인 것은 업그레이드가 불가하므로 자연스럽게 걸러진다.
-- (5) 이 자식 아이템 ID의 정보를 가져오기 위해서는 다시 가장 처음의 ITEM_INFO 테이블을 붙여주어야 한다. 이 때, PARENT 테이블과 구분하기 위해 이 테이블에는 CHILD 라는 별명을 붙여준다.
-- (6) 자식 아이템 ID를 나타내는 컬럼은 ITEM_TREE.ITEM_ID 이므로, CHILD를 JOIN 할 때 해당 값과 CHILD.ITEM_ID 를 짝지어 연결시킨다. 
-- (7) 가져와야 하는 컬럼은 JOIN한 상태에서, CHILD 테이블의 것이므로 CHILD.ITEM_ID, CHILD.ITEM_NAME, CHILD.RARITY 가 된다.


-- 배운 것: 쿼리를 쓸 때는 무조건 SELECT부터 쓰는 게 아니라 먼저 테이블 관계를 파악해야 한다. 무엇에서 시작해서, 어떻게 연결해서, 무엇을 구하는지의 흐름을 먼저 그려보고 그 흐름에 SQL절을 매칭한다. 



-- =====================
-- 4. 조건에 맞는 개발자 찾기
-- =====================
-- 문제: DEVELOPERS 테이블에서 Python이나 C# 스킬을 가진 개발자의 정보를 조회하려 합니다. 조건에 맞는 개발자의 ID, 이메일, 이름, 성을 조회하는 SQL 문을 작성해 주세요. 결과는 ID를 기준으로 오름차순 정렬해 주세요.
-- SKILLCODES 테이블 : NAME 스킬의 이름, CATEGORY 스킬의 범주, CODE 스킬의 코드
-- DEVELOPERS 테이블 : ID 개발자의 아이디, FIRST_NAME 이름, LAST_NAME 성, EMAIL 이메일, SKILL_CODE 스킬 코드
-- 예를 들어 어떤 개발자의 SKILL_CODE가 400 (=b'110010000')이라면, 이는 SKILLCODE 테이블에서 CODE가 256 (=b'100000000'), 128 (=b'10000000'), 16 (=b'10000')에 해당하는 스킬을 가졌다는 것을 의미합니다.
-- SKILL_CODE가 8452 = 8192 + 256 + 4 -> Vue, Python, Cpp
-- SKILL_CODE가 1024 -> C#
-- SKILL_CODE가 400 = 256 + 128 + 16 -> Python, Java, JavaScript

-- 내 생각: 
-- (1) DEVELOPERS 테이블에서 스킬이 Python 혹은 C# 기준으로 걸러야 하는데, 해당 테이블에는 스킬 이름이 아닌 스킬 코드만 있기 때문에, SKILLCODES 테이블을 JOIN 해야함
-- (2) DEVELOPERS 테이블에서 SKILL_CODE는 보유하고 있는 각각의 스킬 CODE를 합한 값으로 표현되어 있음
-- (3) SKILLCODES 테이블에서 각 스킬의 CODE는 2의 거듭제곱 형태로 표현되어 있음
-- (4) 각 테이블의 CODE 컬럼과 SKILL_CODE 컬럼을 이용해서 JOIN SKILLCODE on DEVELOPERS 해야 할 것 같은데, SKILL_CODE 가 CODE 컬럼 행들의 합이라는 걸 어떻게 작성할 것인가 
-- (5) SKILLCODES 테이블을 DEVELOPERS 테이블에 연결할 때, 비트 연산을 이용해서 DEVELOPERS 테이블의 SKILL_CODE 값에, SKILLCODES 테이블의 각 CODE가 자리에 있는지를 체크하여 0이 아닌 것끼리 (= 0이 아니면 해당 자리에 값이 있다는 뜻) 연결함

-- 오답:
SELECT DEVELOPERS.ID, DEVELOPERS.EMAIL, DEVELOPERS.FIRST_NAME, DEVELOPERS.LAST_NAME
FROM DEVELOPERS
JOIN SKILLCODES ON DEVELOPERS.SKILL_CODE & SKILLCODES.CODE != 0
WHERE SKILLCODES.NAME IN ('Python', 'C#')
ORDER BY DEVELOPERS.ID;
-- 틀린 이유: 파이썬 '또는' C# <- 이라는 조건 때문에 중복 행이 발생할 수 있다. 

-- 정답:
SELECT DISTINCT DEVELOPERS.ID, DEVELOPERS.EMAIL, DEVELOPERS.FIRST_NAME, DEVELOPERS.LAST_NAME
FROM DEVELOPERS
JOIN SKILLCODES ON DEVELOPERS.SKILL_CODE & SKILLCODES.CODE != 0
WHERE SKILLCODES.NAME IN ('Python', 'C#')
ORDER BY DEVELOPERS.ID;

-- 배운 것: 
-- (1) & 연산은 '이 자리가 켜져 있냐', '이 자리에 값이 있냐'를 확인하는 것이고, 결과가 0이면 없음, 0이 아니면 있음이라는 뜻이다. ON이나 WHERE에 쓸 수 있다.
-- (2) 중복된 행을 제거할 때는 DISTINCT를 사용하고, SELECT 바로 뒤에 붙여준다.


-- =====================
-- 5. 특정 물고기를 잡은 총 수 구하기
-- =====================
-- 문제: FISH_INFO 테이블에서 잡은 BASS와 SNAPPER의 수를 출력하는 SQL문을 작성해주세요. 컬럼명은 'FISH_COUNT'로 해주세요.
-- FISH_INFO 테이블 : ID 물고기 아이디, FISH_TYPE 물고기 종류(숫자), LENGTH 물고기 길이, TIME 잡은 날짜 -> 잡은 물고기들의 정보
-- 단, 잡은 물고기의 길이가 10cm 이하일 경우에는 LENGTH가 NULL이며, NULL만 있는 경우는 없음
-- FISH_NAME_INFO 테이블 : FISH_TYPE 물고기의 종류(숫자), FISH_NAME 물고기의 이름(문자) -> 물고기의 이름에 대한 정보
-- 내 생각:
-- (1) 물고기 길이, 잡은 날짜는 중요한 정보가 아님
-- (2) 각 테이블에서 공통된 컬럼인 FISH_TYPE(숫자)로 두 테이블을 JOIN
-- (3) COUNT를 사용하여 FISH_NAME이 BASS, SNAPPER 인 것을 세기  

-- 정답:
SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO
JOIN FISH_NAME_INFO ON FISH_INFO.FISH_TYPE = FISH_NAME_INFO.FISH_TYPE
WHERE FISH_NAME_INFO.FISH_NAME IN ('BASS', 'SNAPPER');

-- 정답2:
SELECT COUNT(*) AS FISH_COUNT
FROM FISH_INFO
WHERE FISH_TYPE IN (
    SELECT FISH_TYPE
    FROM FISH_NAME_INFO
    WHERE FISH_NAME IN ('BASS', 'SNAPPER')
);
-- 해당 문제처럼 다른 테이블의 컬럼이 빌려오는 용도로만 사용된다면 서브쿼리를 사용하는 것이 훨씬 간단하고 직관적이다.

-- 배운 것: WHERE는 JOIN ON 다음에 써야함!! SQL 작성 순서를 헷갈리지 말자.



-- =====================
-- 6. 부모의 형질을 모두 가지는 대장균 찾기
-- =====================
-- 문제: 부모의 형질을 모두 보유한 대장균의 ID(ID), 대장균의 형질(GENOTYPE), 부모 대장균의 형질(PARENT_GENOTYPE)을 출력하는 SQL문을 작성해주세요. 이때 결과는 ID에 대해 오름차순 정렬해주세요.
-- ECOLI_DATA 테이블 : ID 대장균 개체의 ID, PARENT_ID 부모 개체의 ID, SIZE_OF_COLONY 개체의 크기, DIFFERENTIATION_DATE 분화되어 나온 날짜, GENOTYPE 개체의 형질
-- 부모 개체 : 분화를 시작한 개체 / 자식 개체 : 분화되어 나온 개체
-- 최초 대장균 개체의 PARENT_ID는 NULL

-- 내 생각: 
-- (1) 여기에서 개체의 크기, 날짜는 중요한 컬럼이 아님
-- (2) '부모의 형질'을 보유해야 하므로 ID 1은 포함될 수 없음
-- (3) ID 2는 1번 형질을 보유하고 있고, 부모인 ID 1은 1번 형질을 보유하고 있으므로, ID 2의 부모 형질을 보유하고 있다.
-- ID 3은 3번 형질을 보유하고 있고, 부모인 ID 1은 1번 형질을 보유하고 



-- 배운 것: 