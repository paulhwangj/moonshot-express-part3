-- Creating the database and using it to create tables
CREATE DATABASE MoonshotExpress;
USE MoonshotExpress;

-- Creating the various tables
CREATE TABLE Customer (
    customer_id     INT IDENTITY (1,1) NOT NULL,
    first_name      VARCHAR(30),
    last_name       VARCHAR(30),
    customer_since  DATE,

    CONSTRAINT [PK_Customer] PRIMARY KEY (customer_id)
);

CREATE TABLE Product (
    product_id      INT IDENTITY (1,1) NOT NULL,
    description     VARCHAR(1000),
    size            VARCHAR(6),
    price           FLOAT,

    -- limits options that size can be set to
    CHECK (size in ('Small', 'Medium', 'Large')),   
    CONSTRAINT [PK_Product] PRIMARY KEY (product_id)
);

CREATE TABLE Store (
    store_id INT IDENTITY (1,1) NOT NULL,
    street_address VARCHAR(200),
    city VARCHAR(30),
    us_state VARCHAR(2),
    zipcode INT,

    CONSTRAINT [PK_Store] PRIMARY KEY (store_id)
);

CREATE TABLE Barista (
    barista_id      INT IDENTITY (1,1) NOT NULL,
    first_name      VARCHAR(30),
    last_name       VARCHAR(30),
    hire_date       DATE,
    store_id        INT,   

    CONSTRAINT [PK_Barista] PRIMARY KEY (barista_id),
    CONSTRAINT [FK_STORE] FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE Purchase (
    purchase_id         INT IDENTITY (1,1) NOT NULL,
    time_date_purchase  DATETIME,
    sales_tax           FLOAT CHECK (sales_tax <= 1.00 AND sales_tax >= 0.00),
    barista_id          INT,
    customer_id         INT,
    store_id            INT,

    CONSTRAINT [PK_Purchase] PRIMARY KEY (purchase_id),
    CONSTRAINT [FK_PURCHASE_BARISTA] FOREIGN KEY (barista_id) REFERENCES Barista(barista_id),  
    CONSTRAINT [FK_PURCHASE_CUSTOMER] FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),  
    CONSTRAINT [FK_PURCHASE_STORE] FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

CREATE TABLE ProductInPurchase (
    product_id      INT,
    purchase_id     INT,
    quantity        INT,
    subtotal        FLOAT,

    CONSTRAINT [PK_PRODUCT_IN_PURCHASE] PRIMARY KEY (product_id, purchase_id),
    CONSTRAINT [FK_PRODUCT_IN_PURCHASE] FOREIGN KEY (product_id) REFERENCES Product(product_id),
    CONSTRAINT [FK_ASSOCIATED_PURCHASE] FOREIGN KEY (purchase_id) REFERENCES Purchase(purchase_id)
);

CREATE TABLE Reward (
    reward_id       INT IDENTITY (1,1) NOT NULL,
    badge_name      VARCHAR(50),
    level           INT,

    CONSTRAINT [PK_REWARD] PRIMARY KEY (reward_id)
);

CREATE TABLE CustomerRewardEarn (
    customer_id     INT,
    reward_id       INT,

    CONSTRAINT [PK_CUSTOMERREWARDEARN] PRIMARY KEY (customer_id, reward_id),
    CONSTRAINT [FK_CUSTOMER_EARNING_REWARD] FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    CONSTRAINT [FK_REWARD_BEING_GIVEN] FOREIGN KEY (reward_id) REFERENCES Reward(reward_id),
);

-- Inserting sample data into the tables
INSERT INTO Customer (first_name, last_name, customer_since) VALUES
    ('Joseph', 'Mulligan', '2020-03-05'),
    ('Paul', 'Hwang', '2020-03-22');

INSERT INTO Reward (badge_name, level) VALUES
    ('Three of Kind', 1),
    ('Five Different', 2);

INSERT INTO CustomerRewardEarn (customer_id, reward_id) VALUES
    (1,1),
    (1,2);

INSERT INTO Product (description, size, price) VALUES
    ('Black Coffee', 'Small', 1.59),
    ('Black Coffee', 'Medium', 1.79),
    ('Black Coffee', 'Large', 1.99),
    ('Extra shot of expresso', NULL, 0.50);

INSERT INTO Store (street_address, city, us_state, zipcode) VALUES
    ('12 Fake Street', 'Oshkosh', 'WI', 54901),
    ('21 Real Street', 'Oshkosh', 'WI', 54904);

INSERT INTO Barista (first_name, last_name, hire_date, store_id) VALUES
    ('John', 'Green', '2020-02-25', 1),
    ('Tree', 'Trunk', '2020-02-20', 2);

INSERT INTO Purchase (time_date_purchase, sales_tax, barista_id, customer_id, store_id) VALUES
    (convert(datetime, '2020-12-02 12:01:05', 102), 0.05, 1, 1, 1),
    (convert(datetime, '2020-12-02 12:15:24', 102), 0.05, 2, 2, 2);

INSERT INTO ProductInPurchase (product_id, purchase_id, quantity, subtotal) VALUES
    (1, 1, 2, 3.18),
    (2, 1, 1, 1.79),
    (3, 2, 1, 1.99),
    (4, 2, 1, 0.50);

-- Dropping all the tables
-- DROP TABLE CustomerRewardEarn;
-- DROP TABLE Reward;
-- DROP TABLE ProductInPurchase;
-- DROP TABLE Purchase;
-- DROP TABLE Barista;
-- DROP TABLE Store;
-- DROP TABLE Product;
-- DROP TABLE Customer;