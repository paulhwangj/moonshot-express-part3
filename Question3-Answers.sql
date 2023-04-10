-- PROBLEMS FOR THE HOMEWORK
-- ===================================

-- Problem 3.1: Sales volume by product
SELECT Product.description, SUM(ProductInPurchase.quantity) as total_sales
FROM ProductInPurchase JOIN Product ON Product.product_id = ProductInPurchase.product_id
GROUP BY Product.description
ORDER BY total_sales DESC;


-- Problem 3.2: Number of visits by each customer
SELECT customer_id, COUNT(*) as total_visits
FROM Purchase
GROUP BY customer_id; 

-- Problem 3.3a: Most popular products
SELECT Product.product_id, Product.description, SUM(ProductInPurchase.quantity) AS total_quantity
FROM ProductInPurchase JOIN Product ON ProductInPurchase.product_id = Product.product_id
GROUP BY Product.product_id, Product.description
ORDER BY total_quantity DESC;

-- Problem 3.3b: Least popular products
SELECT Product.product_id, Product.description, SUM(ProductInPurchase.quantity) AS total_quantity
FROM ProductInPurchase JOIN Product ON ProductInPurchase.product_id = Product.product_id
GROUP BY Product.product_id, Product.description
ORDER BY total_quantity ASC;

-- Problem 3.4: Customers who haven't placed orders in the past 6 months
SELECT DISTINCT(customer_id)
FROM Purchase
WHERE customer_id
        NOT IN (SELECT DISTINCT(customer_id)
                FROM Purchase
                WHERE time_date_purchase >= DATEADD(month, -6, GETDATE()));

-- Problem 3.5a: How many customers hvae earned a reward for a particular badge?
SELECT COUNT(DISTINCT Customer.customer_id) AS Number_of_Customers
FROM Customer
INNER JOIN CustomerRewardEarn ON Customer.customer_id = CustomerRewardEarn.customer_id
INNER JOIN Reward ON CustomerRewardEarn.reward_id = Reward.reward_id
WHERE Reward.badge_name = 'Gold';

-- Problem 3.5b: What is the total amount of sales tax collected by each employee?
SELECT Barista.first_name, Barista.last_name, SUM(Purchase.sales_tax) AS Total_Sales_Tax
FROM Purchase
INNER JOIN Barista ON Purchase.barista_id = Barista.barista_id
GROUP BY Barista.first_name, Barista.last_name;

-- Problem 3.5c: How many stores are in California?
SELECT COUNT(*) AS store_count
FROM Store
WHERE us_state = 'CA';

-- Problem 3.6: Writing the trigger

-- This trigger executes every time a new purchase is inserted.
-- It selects the customer ID and then queries the number of purchases made.
-- For the example I have it give a gold badge if the count is over 10 and platinum if the count is 20.
-- Only one reward of gold and platinum can be stored at one time.

CREATE TRIGGER [dbo].[LogRewardLevel]
ON [dbo].[Purchase]
AFTER INSERT
AS
BEGIN
    DECLARE @customerId INT
    DECLARE @purchaseCount INT


    SELECT @customerId = inserted.customer_id
    FROM inserted


    SELECT @purchaseCount = COUNT(*)
    FROM Purchase
    WHERE customer_id = @customerId


    IF (@purchaseCount >= 10) AND NOT EXISTS (SELECT *
                                              FROM CustomerRewardEarn
                                              WHERE customer_id = @customerId
                                              AND reward_id = 1)
    BEGIN
        INSERT INTO CustomerRewardEarn (customer_id, reward_id)
        VALUES (@customerId, 1)
        -- 1 is the reward_id for "Gold" badge
    END


    IF (@purchaseCount >= 20) AND NOT EXISTS (SELECT *
                                              FROM CustomerRewardEarn
                                              WHERE customer_id = @customerId
                                              AND reward_id = 2)
    BEGIN
        INSERT INTO CustomerRewardEarn (customer_id, reward_id)
        VALUES (@customerId, 2)
        -- 2 is the reward_id for "Platinum" badge
    END
END
