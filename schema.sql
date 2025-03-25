--  이것도 주석
# 이것도 주석
DROP TABLE users;

-- 사용자 테이블 생성
CREATE TABLE users (
                       user_id INT PRIMARY KEY AUTO_INCREMENT,
                        # PRIMARY KEY : NOT NULL + UNIQUE -> 테이블마다 1개만 존재 가능. 외부 테이블에서 외래키. FOREIGN KEY 로 쓸 수 있게 함.
                        # AUTO_INCREMENT : 추가 시도가 있을 경우 일단 1을 늘리고...
                       username VARCHAR(255) UNIQUE NOT NULL,
                        # NULL? DB에서는 좀... 빈 텍스트로 인식하는 곳도 있고, 진짜 null...
                        # NULL -> 비교가 일반적인 방식으로 안 된다
                        # UNIQUE는 옵션을 지정한 해당 열에 대해서 중복을 허용하지 않음
                        # VARCHAR(길이) -> CHAR => 고정된 길이. VARCHAR => 일단 짧은 것부터 시작하고... 긴게 들어오면 차츰 늘어나요
                       email VARCHAR(255) UNIQUE NOT NULL,
                       age INT, # INT(길이) -> 생략하고 최대 길이를 준 것.
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        # TIMESTAMP 날짜,시간 -> DEFAULT - CURRENT_TIMESTAMP
                        # '시간'은 지역마다... 기준 -> UTC -> 영국시간.
                        # KST or UTC+9
);

ALTER TABLE users RENAME COLUMN username TO nickname;
# alter table users
#                change nickname username varchar(255) not null

INSERT INTO users (username, email, age) values ('john', 'john@gmail.com', 20);
# INSERT INTO users (username, email, age) values ('johnson', 'john@gmail.com', 20);
# email도 중복되면 안된다!
INSERT INTO users (username, email, age) values ('johnson', 'johnson@gmail.com', 20);

SELECT * FROM users; # SELECT * (모든 컬럼) FROM (내가 지정하고자하는 테이블 이름)
# john 5, johnson 6 (저의 경우)
UPDATE users SET age = 2000; # 조건을 꼭 주세요!
DELETE FROM users; # ??????????????????????? 한 번 같이 울고... '잘 하자'
# JPA -> CREATE (유사한 절망...) 이게 H2가 아니라면? local도 아니고 dev 아니고 실서버 production이라면?
# SELECT -> FROM WHERE
# INSERT -> 테이블이름 (컬럼들) values (값들)
# UPDATE -> 테이블이름 set 수정하려는 값 where 조건
# DELETE -> FROM WHERE

SELECT * FROM users;
# 대입연산자도 =이고, 동등(일치)연산자도 =이야.(???)
# 동명이인 이슈. unique면 상관없는데... 모두 kevin이 되었습니다(?) 어랏.
# + 접근을 해야해 => id가 있으면. 우리가 일부러 만들어준 것.
UPDATE users SET username = 'kevin' WHERE username = 'john';
UPDATE users SET username = 'carrol' WHERE user_id = 7; # 자연적이지 않은 일부러 부여한 기본키
DELETE FROM users WHERE user_id = 7; # 다른 조건을 넣어도 되긴 함...
# 어떤 조건이 있는 데이터(튜)들의 id를 모아가지고 그걸 삭제 처리

-- 상품 테이블 생성
CREATE TABLE products (
                          product_id INT PRIMARY KEY AUTO_INCREMENT,
                          product_name VARCHAR(255) NOT NULL,
                          price DECIMAL(10, 2) NOT NULL,
                            # DECIMAL -> 소수점. 전체 10자리 중에 2자리를 소수점에 할당하겠다
                          category VARCHAR(255),
                          stock INT DEFAULT 0
);

-- 주문 테이블 생성
CREATE TABLE orders (
                        order_id INT PRIMARY KEY AUTO_INCREMENT,
                        user_id INT,
                        product_id INT,
                        quantity INT,
                        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        # 이 칼럼은 명시적으로 외부로부터 참조할 것입니다
                        # 연결관계입니다 -> PRIMARY KEY...
                        # cascading -> users 삭제가 되었다 => orders?
                        FOREIGN KEY (user_id) REFERENCES users(user_id),
                        FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 리뷰 테이블 생성
CREATE TABLE reviews (
                         review_id INT PRIMARY KEY AUTO_INCREMENT,
                         user_id INT,
                         product_id INT,
                         rating INT,
                         comment TEXT, # 아주 긴 varchar
                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                         FOREIGN KEY (user_id) REFERENCES users(user_id),
                         FOREIGN KEY (product_id) REFERENCES products(product_id)
);