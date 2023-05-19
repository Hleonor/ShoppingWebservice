-- easebuy数据库创建

-- 用户表
DROP TABLE users;
CREATE TABLE users (
                       id VARCHAR2(10) NOT NULL PRIMARY KEY, -- uid是保留字，不能用，改为id
                       uname VARCHAR2(20) NOT NULL,
                       upassword VARCHAR2(20) NOT NULL,
                       sex VARCHAR2(1) NOT NULL,
                       birthday DATE NOT NULL,
                       ucode VARCHAR2(60) NOT NULL,
                       email VARCHAR2(80) NOT NULL,
                       mobile VARCHAR2(11) NOT NULL,
                       address VARCHAR2(200) NOT NULL,
                       ustatus NUMBER(6) NOT NULL
);

-- 商品表
DROP TABLE product;
CREATE TABLE product (
                         pid NUMBER PRIMARY KEY,
                         pname VARCHAR2(20) NOT NULL,
                         pdescription VARCHAR2(100) DEFAULT NULL,
                         price NUMBER(10,2) NOT NULL,
                         stock NUMBER(11) NOT NULL, -- 原来是255，执行时报错ORA-01727: 数字精度说明符超出范围 (1 到 38)，修改为11
                         cid NUMBER(11) NOT NULL,
                         childid NUMBER(11) DEFAULT NULL,
                         filename VARCHAR2(200) NOT NULL
);

-- 商品类型
DROP TABLE productcategory;
CREATE TABLE productcategory (
                                 pcid NUMBER PRIMARY KEY,
                                 pcname VARCHAR2(20) NOT NULL,
                                 parentid NUMBER(10) NOT NULL
);

-- 新闻表
DROP TABLE news;
CREATE TABLE news (
                      nid NUMBER PRIMARY KEY,
                      title VARCHAR2(40) NOT NULL,
                      message VARCHAR2(1000) NOT NULL, -- 原来长度是10000太长了，改为1000
                      createTime DATE DEFAULT NULL
);

-- 订单表
DROP TABLE orders;
CREATE TABLE orders (
                        oid NUMBER PRIMARY KEY,
                        id VARCHAR2(10) NOT NULL, -- uid是保留字，不能用，改为id
                        uname VARCHAR2(20) NOT NULL,
                        address VARCHAR2(200) NOT NULL,
                        createtime DATE NOT NULL,
                        cost NUMBER(10,2) NOT NULL,
                        ostatus NUMBER(10) NOT NULL, -- 原来是255，太长了溢出，改为10
                        otype NUMBER(10) NOT NULL -- 原来是255，太长了溢出，改为10
);

-- 订单详细表
DROP TABLE orderdetail;
CREATE TABLE orderdetail (
                             odid NUMBER PRIMARY KEY,
                             oid NUMBER NOT NULL,
                             pid NUMBER NOT NULL,
                             quantity NUMBER NOT NULL,
                             cost NUMBER(10,2) NOT NULL
);

-- 商品评论表
DROP TABLE comments;
CREATE TABLE comments (
                          cid NUMBER PRIMARY KEY,
                          content VARCHAR2(200) NOT NULL,
                          createtime DATE NOT NULL,
                          pid NUMBER NOT NULL,
                          nickname VARCHAR2(10) NOT NULL
);

-- 商品表中商品分类cid与商品类型表中的pcid
ALTER TABLE product ADD CONSTRAINT FK_product_cid FOREIGN KEY (cid) REFERENCES productcategory(pcid);

-- 订单表中用户编号uid与用户表中的uid
ALTER TABLE orders ADD CONSTRAINT FK_orders_uid FOREIGN KEY (id) REFERENCES users(id);

-- 订单详细表中订单编号oid与订单表中的编号oid
ALTER TABLE orderdetail ADD CONSTRAINT FK_orderdetail_oid FOREIGN KEY (oid) REFERENCES orders(oid);

-- 订单详细表中商品编号pid与商品表中的编号pid
ALTER TABLE orderdetail ADD CONSTRAINT FK_orderdetail_pid FOREIGN KEY (pid) REFERENCES product(pid);

-- 商品评论表中编号pid与商品表中编号pid
ALTER TABLE comments ADD CONSTRAINT FK_comments_pid FOREIGN KEY (pid) REFERENCES product(pid);