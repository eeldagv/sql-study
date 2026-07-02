-- =====================
-- 1. 가격이 제일 비싼 식품의 정보 출력하기
-- =====================
-- 문제: FOOD_PRODUCT 테이블에서 가격이 제일 비싼 식품의 식품 ID, 식품 이름, 식품 코드, 식품분류, 식품 가격을 조회하는 SQL문을 작성해주세요.
-- FOOD_PRODUCT : PORDUCT_ID 식품 ID, PRODUCT_NAME 식품 이름, CATEGORY 식품분류, PRICE 식품가격
-- 내 생각: MAX를 사용! 그런데 이 경우엔 전체 컬럼을 조회하는 거니까 *를 쓰면 될 것 같은데, 가격에 MAX를 사용해야 함.. 방법이 없을까?

-- 정답:
SELECT *
FROM FOOD_PRODUCT
WHERE PRICE = (
    SELECT MAX(PRICE)
    FROM FOOD_PRODUCT
);

-- 배운 것: 컬럼 개수가 몇 개 없다면 하나하나 써 줄 수 있겠지만, 컬럼의 개수가 너무 많을 경우 서브쿼리를 사용할 수 있다. 



-- =====================
-- 2. 최솟값 구하기
-- =====================
-- 문제: 동물 보호소에 가장 먼저 들어온 동물은 언제 들어왔는지 조회하는 SQL 문을 작성해주세요.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: MIN을 사용하여 DATETIME을 조회

-- 정답:
SELECT MIN(DATETIME) AS 시간
FROM ANIMAL_INS;

-- 배운 것: 레벨1에서 풀었던 날짜 문제와 동일하게, 날짜는 과거일수록 최소값이고 미래일수록 최대값이다.



-- =====================
-- 3. 동물 수 구하기
-- =====================
-- 문제: 동물 보호소에 동물이 몇 마리 들어왔는지 조회하는 SQL 문을 작성해주세요.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: 전체 마리수를 조회해야 하므로 COUNT를 사용

-- 정답:
SELECT COUNT(*) FROM ANIMAL_INS;

-- 배운 것: SUM과 COUNT를 혼동하면 안 됨



-- =====================
-- 4. 중복 제거하기
-- =====================
-- 문제: 동물 보호소에 들어온 동물의 이름은 몇 개인지 조회하는 SQL 문을 작성해주세요. 이때 이름이 NULL인 경우는 집계하지 않으며 중복되는 이름은 하나로 칩니다.
-- ANIMAL_INS : ANIMAL_ID, ANIMAL_TYPE, DATETIME, INTAKE_CONDITION, NAME, SEX_UPON_INTAKE
-- 내 생각: COUNT는 전체 컬럼에 대해 조회하지 않는 이상 NULL을 제외한 행의 개수를 세어주므로, 중복을 제거하는 DISTINCT를 사용한다.

-- 정답:
SELECT COUNT(DISTINCT NAME) FROM ANIMAL_INS;

-- 배운 것: COUNT할 때 DISTINCT는 괄호 안에 써준다.



-- =====================
-- 5. 조건에 맞는 아이템들의 가격의 총합 구하기
-- =====================
-- 문제: ITEM_INFO 테이블에서 희귀도가 'LEGEND'인 아이템들의 가격의 총합을 구하는 SQL문을 작성해 주세요. 이때 컬럼명은 'TOTAL_PRICE'로 지정해 주세요.
-- ITEN_INFO 테이블 : ITEM_ID 아이템 ID, ITEM_NAME 아이템명, RARITY 희귀도, PRICE 가격
-- 내 생각: 희귀도 = 'LEGEND'로 조건을 걸고, SUM을 사용해서 가격의 총합을 구한다.

-- 정답:
SELECT SUM(PRICE) AS TOTAL_PRICE
FROM ITEM_INFO
WHERE RARITY = 'LEGEND';



-- =====================
-- 6. 연도별 대장균 크기의 편차 구하기
-- =====================
-- 문제: 분화된 연도(YEAR), 분화된 연도별 대장균 크기의 편차(YEAR_DEV), 대장균 개체의 ID(ID) 를 출력하는 SQL 문을 작성해주세요. 분화된 연도별 대장균 크기의 편차는 분화된 연도별 가장 큰 대장균의 크기 - 각 대장균의 크기로 구하며 결과는 연도에 대해 오름차순으로 정렬하고 같은 연도에 대해서는 대장균 크기의 편차에 대해 오름차순으로 정렬해주세요.
-- ECOLI_DATA : ID 각 대장균 개체의 ID, PARENT_ID 부모 개체의 ID, SIZE_OF_COLONY 개체의 크기, DIFFERENTIATION_DATE 분회되어 나온 날짜, GENOTYPE 개체의 형질
-- 최초의 대장균 개체의 PARENT_ID는 NULL
-- 내 생각:
-- (1) 필요없는 컬럼 -> PARENT_ID, GENOTYPE
-- (1) '분화된 연도별' 이므로 GROUP BY로 연도별로 묶는다. <- 틀린 추론, GROUP BY는 사용하지 않아도 됨
-- (2) 그 후에 MAX를 사용해서 가장 큰 대장균의 크기를 구한다.

-- (1) SELECT 해야 하는 컬럼 중 분화된 연도별 대장균 크기의 편차 = 가장 큰 크기 - 각각의 크기 <- 이것은 SELECT 단계에서 서브쿼리를 사용해야 함
-- (2) 예를 들어, 2019년의 크기 편차를 구한다고 하면, 먼저 최대 크기를 구해야 한다.
SELECT MAX(SIZE_OF_COLONY)
FROM ECOLI_DATA
WHERE YEAR(DIFFERENTIATION_DATE) = 2019;
-- (3) 여기서 각 행의 SIZE_OF_COLONY 를 빼주어야 하는데, 이대로 쓰면 연도가 고정되어버리므로 '지금 처리하고 있는 날짜의 연도'를 맞춰주어야 한다. 이 때에는 서브쿼리 바깥의 FROM 테이블에 별명을 붙여 사용할 수 있다.

-- 정답1:
SELECT 
    YEAR(DIFFERENTIATION_DATE) AS YEAR,
    ( 
        SELECT MAX(SIZE_OF_COLONY)
        FROM ECOLI_DATA
        WHERE YEAR(DIFFERENTIATION_DATE) = YEAR(E.DIFFERENTIATION_DATE)
    ) - SIZE_OF_COLONY AS YEAR_DEV,
    ID
FROM ECOLI_DATA AS E
ORDER BY YEAR(DIFFERENTIATION_DATE), YEAR_DEV;

-- 정답2:
SELECT 
    YEAR(DIFFERENTIATION_DATE) AS YEAR,
    MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE)) - SIZE_OF_COLONY AS YEAR_DEV,
    ID
FROM ECOLI_DATA
ORDER BY YEAR(DIFFERENTIATION_DATE), YEAR_DEV;

-- 배운 것: 
-- (1) 서브쿼리는 SELECT에서도 사용할 수 있다.
-- (2) 테이블을 두 개 JOIN 할 때 뿐만 아니라, 자기 자신의 테이블을 서브쿼리 안에서 한 번 더 참조할 때도 별명을 쓸 수 있다. (별명을 붙일 때는 굳이 의미 있는 이름을 붙이기 어려우면 테이블의 첫 글자나 두세 글자로 줄여쓰는 게 관례라고 한다..)
-- (3) 처음엔 연도'별' 이라는 키워드만 보고 GROUP BY 라고 생각했는데 왜 적절하지 않았을까? -> GROUP BY가 필요한 경우 : 결과의 행이 줄어들어도 될 때. 즉, 집계값만 필요할 때. 추출해야 하는 결과가 묶여서 줄어들어야 하면 GROUP BY가 맞음. 여기서는 각 행마다 계산이 필요하고 원본의 행 개수만큼 추출해야 했기 때문에 맞지 않음.
-- (4) 그러면 뭘 사용해야 하느냐? 정답1처럼 서브쿼리를 사용해도 되지만, '윈도우 함수'라는 것을 사용한다. 윈도우 함수는 원본 행을 유지하면서 집계값도 필요할 때 사용한다. 보통 집계함수(AVG, SUM, MAX, MIN, COUNT)에 'OVER'가 붙으면 윈도우 함수가 된다. OVER는 '범위'를 정해준다는 의미이다(큰 창문=큰 범위, 작은 창문=작은 범위). 만약 OVER() 로만 쓰면 전체 테이블을 하나의 범위로 보겠다는 뜻이고, OVER(PARTITION BY ~)로 기준을 정하면 기준별로 나눠서 각각 값을 추출하겠다는 뜻이다.