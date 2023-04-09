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
    price           INT,

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
    subtotal        INT,

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

-- Dropping all the tables
DROP TABLE CustomerRewardEarn;
DROP TABLE Reward;
DROP TABLE ProductInPurchase;
DROP TABLE Purchase;
DROP TABLE Barista;
DROP TABLE Store;
DROP TABLE Product;
DROP TABLE Customer;