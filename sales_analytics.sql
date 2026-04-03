--DDL 
--1: CREATE DATABASE
CREATE DATABASE SalesAnalytics;
GO

USE SalesAnalytics;
GO
-- 2: CREATE TABLES (DDL)
CREATE TABLE customers (
    customer_id INT           IDENTITY(1,1) PRIMARY KEY,
    name        NVARCHAR(100) NOT NULL,
    email       NVARCHAR(150) NOT NULL UNIQUE,
    created_at  DATE          NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    region      NVARCHAR(50)  NOT NULL
);

CREATE TABLE products (
    product_id INT            IDENTITY(1,1) PRIMARY KEY,
    name       NVARCHAR(100)  NOT NULL,
    category   NVARCHAR(50)   NOT NULL,
    price      DECIMAL(10,2)  NOT NULL
);

CREATE TABLE orders (
    order_id    INT           IDENTITY(1,1) PRIMARY KEY,
    customer_id INT           NOT NULL REFERENCES customers(customer_id),
    order_date  DATE          NOT NULL,
    status      NVARCHAR(20)  NOT NULL   -- 'shipped','delivered','cancelled'
);

CREATE TABLE order_items (
    order_item_id INT           IDENTITY(1,1) PRIMARY KEY,
    order_id      INT           NOT NULL REFERENCES orders(order_id),
    product_id    INT           NOT NULL REFERENCES products(product_id),
    quantity      INT           NOT NULL DEFAULT 1,
    unit_price    DECIMAL(10,2) NOT NULL,
    discount_rate DECIMAL(4,3)  NOT NULL DEFAULT 0.0  -- e.g. 0.10 = 10%
);
GO
 
--   3: INDEXES
CREATE INDEX idx_orders_customer   ON orders(customer_id);
CREATE INDEX idx_orders_date       ON orders(order_date);
CREATE INDEX idx_orders_status     ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_prod  ON order_items(product_id);
GO
 
--   4: SEED DATA
--   10 customers, 12 products, 32 orders across 14 months
--   Seasonal spikes in Nov/Dec, discounts, one cancelled order
--   Revenue = quantity * unit_price * (1 - discount_rate)
--   Completed = status IN ('shipped','delivered')
 

INSERT INTO customers (name, email, created_at, region) VALUES
  ('Alice Martin',  'alice@example.com',  '2023-01-10', 'North'),
  ('Bob Hassan',    'bob@example.com',    '2023-02-15', 'South'),
  ('Carol Nour',    'carol@example.com',  '2023-03-20', 'East'),
  ('David Kim',     'david@example.com',  '2023-04-05', 'West'),
  ('Eva Petrov',    'eva@example.com',    '2023-05-18', 'North'),
  ('Frank Diaz',    'frank@example.com',  '2023-06-22', 'South'),
  ('Grace Liu',     'grace@example.com',  '2023-07-30', 'East'),
  ('Hana Yilmaz',   'hana@example.com',   '2023-08-14', 'West'),
  ('Ivan Osei',     'ivan@example.com',   '2023-09-09', 'North'),
  ('Julia Brown',   'julia@example.com',  '2023-10-01', 'South');

INSERT INTO products (name, category, price) VALUES
  ('Laptop Pro 15',      'Electronics',  1200.00),
  ('Wireless Mouse',     'Electronics',    25.00),
  ('USB-C Hub',          'Electronics',    45.00),
  ('Office Chair',       'Furniture',     320.00),
  ('Standing Desk',      'Furniture',     550.00),
  ('Notebook A5',        'Stationery',      5.00),
  ('Ballpoint Pens x10', 'Stationery',      8.00),
  ('Python Book',        'Books',          40.00),
  ('SQL Mastery',        'Books',          35.00),
  ('Headphones BT',      'Electronics',   150.00),
  ('Monitor 27"',        'Electronics',   400.00),
  ('Ergonomic Keyboard', 'Electronics',    90.00);

INSERT INTO orders (customer_id, order_date, status) VALUES
  (1,  '2024-01-05', 'delivered'),   -- 1
  (2,  '2024-01-18', 'shipped'),     -- 2
  (3,  '2024-02-02', 'delivered'),   -- 3
  (4,  '2024-02-20', 'delivered'),   -- 4
  (5,  '2024-03-08', 'shipped'),     -- 5
  (6,  '2024-03-25', 'cancelled'),   -- 6  cancelled order
  (7,  '2024-04-10', 'delivered'),   -- 7
  (8,  '2024-04-28', 'delivered'),   -- 8
  (1,  '2024-05-03', 'shipped'),     -- 9
  (9,  '2024-05-19', 'delivered'),   -- 10
  (2,  '2024-06-07', 'delivered'),   -- 11
  (10, '2024-06-22', 'shipped'),     -- 12
  (3,  '2024-07-14', 'delivered'),   -- 13
  (4,  '2024-07-29', 'shipped'),     -- 14
  (5,  '2024-08-05', 'delivered'),   -- 15
  (6,  '2024-08-20', 'delivered'),   -- 16
  (7,  '2024-09-11', 'shipped'),     -- 17
  (8,  '2024-09-30', 'delivered'),   -- 18
  (9,  '2024-10-06', 'delivered'),   -- 19
  (10, '2024-10-21', 'shipped'),     -- 20
  (1,  '2024-11-01', 'delivered'),   -- 21  (November spike)
  (2,  '2024-11-05', 'delivered'),   -- 22
  (3,  '2024-11-10', 'shipped'),     -- 23
  (4,  '2024-11-15', 'delivered'),   -- 24
  (5,  '2024-11-22', 'delivered'),   -- 25
  (6,  '2024-12-01', 'delivered'),   -- 26  (December spike)
  (7,  '2024-12-05', 'shipped'),     -- 27
  (8,  '2024-12-10', 'delivered'),   -- 28
  (9,  '2024-12-18', 'delivered'),   -- 29
  (10, '2024-12-26', 'shipped'),     -- 30
  (1,  '2025-01-08', 'delivered'),   -- 31  (14th month)
  (2,  '2025-01-20', 'shipped');     -- 32

INSERT INTO order_items (order_id, product_id, quantity, unit_price, discount_rate) VALUES
  (1,  1, 1, 1200.00, 0.000),
  (1,  2, 1,   25.00, 0.000),
  (2,  3, 2,   45.00, 0.050),
  (3,  4, 1,  320.00, 0.100),
  (4,  5, 1,  550.00, 0.000),
  (5,  6, 5,    5.00, 0.000),
  (5,  7, 2,    8.00, 0.000),
  (6,  8, 1,   40.00, 0.000),
  (7,  9, 1,   35.00, 0.000),
  (7, 10, 1,  150.00, 0.000),
  (8, 11, 1,  400.00, 0.050),
  (9, 12, 1,   90.00, 0.000),
  (10, 1, 1, 1200.00, 0.150),
  (11, 2, 3,   25.00, 0.000),
  (11, 3, 1,   45.00, 0.000),
  (12, 4, 1,  320.00, 0.000),
  (13, 5, 1,  550.00, 0.100),
  (14, 6,10,    5.00, 0.000),
  (14, 7, 5,    8.00, 0.000),
  (15, 8, 2,   40.00, 0.050),
  (16, 9, 1,   35.00, 0.000),
  (16,10, 1,  150.00, 0.100),
  (17,11, 2,  400.00, 0.000),
  (18,12, 1,   90.00, 0.050),
  (19, 1, 1, 1200.00, 0.200),
  (20, 2, 4,   25.00, 0.000),
  (21, 1, 1, 1200.00, 0.100),
  (21,11, 1,  400.00, 0.100),
  (22, 5, 1,  550.00, 0.000),
  (22,12, 2,   90.00, 0.050),
  (23,10, 2,  150.00, 0.000),
  (23, 4, 1,  320.00, 0.050),
  (24, 9, 2,   35.00, 0.000),
  (24, 8, 3,   40.00, 0.050),
  (25, 1, 1, 1200.00, 0.000),
  (25, 3, 3,   45.00, 0.000),
  (26, 1, 2, 1200.00, 0.150),
  (26,10, 1,  150.00, 0.000),
  (27, 5, 1,  550.00, 0.050),
  (27,11, 1,  400.00, 0.100),
  (28, 4, 2,  320.00, 0.000),
  (28,12, 1,   90.00, 0.000),
  (29, 1, 1, 1200.00, 0.100),
  (29, 2, 5,   25.00, 0.000),
  (30, 9, 3,   35.00, 0.000),
  (30, 8, 4,   40.00, 0.050),
  (31, 1, 1, 1200.00, 0.050),
  (32, 3, 2,   45.00, 0.000);
GO






GO
create or alter view monthly_revenue as --1 view
select month(order_date)as monthly, year(order_date)as yearly ,sum(quantity*unit_price*(1-discount_rate))as revenue
from orders o inner join order_items oi 
on o.order_id =oi.order_id
group by month(order_date),year(order_date),status
having status in ('shipped','delivered' );
GO
--run view
select * from monthly_revenue
order by monthly



GO
create view active_90day as --2 view
SELECT c.customer_id,name,MIN(order_date) AS first_order_date,MAX(order_date) AS last_order_date,
DATEDIFF(DAY, MIN(order_date), MAX(order_date)) AS active_days
FROM Customers c JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,name
HAVING DATEDIFF(DAY, MIN(order_date), MAX(order_date)) >= 90;
GO
--run view 
select * from active_90day
order by customer_id


GO
CREATE OR ALTER VIEW vw_top_selling_products AS --3 view
SELECT p.product_id, p.name, SUM(i.quantity * i.unit_price * (1 - i.discount_rate)) AS total_sales
FROM products p 
INNER JOIN order_items i ON p.product_id = i.product_id
GROUP BY p.product_id, p.name;
GO
--run 
SELECT * FROM vw_top_selling_products
order by total_sales DESC; 



--- nested query
SELECT *
FROM (
 SELECT 
 c.customer_id,
 c.name,
 SUM(oi.quantity * oi.unit_price * (1 - oi.discount_rate)) AS total_spent
 FROM customers c
 JOIN orders o 
 ON c.customer_id = o.customer_id
 JOIN order_items oi 
 ON o.order_id = oi.order_id
 WHERE o.status IN ('shipped','delivered')
 GROUP BY c.customer_id, c.name
) AS customer_spending
WHERE total_spent > 2000
ORDER BY total_spent DESC;

--- 1. Monthly Revenue with Growth
WITH monthly_totals AS (
    SELECT 
        DATEFROMPARTS(YEAR(o.order_date), MONTH(o.order_date), 1) AS month,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_rate)) AS revenue
    FROM orders o JOIN order_items oi 
    ON o.order_id = oi.order_id
    GROUP BY DATEFROMPARTS(YEAR(o.order_date), MONTH(o.order_date), 1)
)
SELECT month,revenue,
    LAG(revenue) OVER (ORDER BY month) AS prev_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month)) / 
    NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100, 2) AS mom_growth_pct
FROM monthly_totals
ORDER BY month;


----2. Category Performance (L12M)
SELECT 
    p.category,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.quantity) AS items,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount_rate)) AS revenue,
    ROUND(
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_rate)) / 
        COUNT(DISTINCT o.order_id), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= DATEADD(month, -12, GETDATE())
GROUP BY p.category
ORDER BY revenue DESC;


---3. Regional Leaderboard
WITH regional_stats AS (
    SELECT 
        c.region,
        COUNT(DISTINCT c.customer_id) AS customers,
        SUM(oi.quantity * oi.unit_price * (1 - oi.discount_rate)) AS revenue
    FROM customers c
    JOIN orders o 
    ON c.customer_id = o.customer_id
    JOIN order_items oi 
    ON o.order_id = oi.order_id
    GROUP BY c.region
),product_revenue_by_region AS (
    SELECT c.region,p.name AS product_name,
    SUM(oi.quantity * oi.unit_price * (1 - oi.discount_rate)) AS product_revenue
    FROM customers c
    JOIN orders o
     ON c.customer_id = o.customer_id
    JOIN order_items oi 
    ON o.order_id = oi.order_id
    JOIN products p 
    ON oi.product_id = p.product_id
    GROUP BY c.region, p.name
),
top_product_per_region AS (
    SELECT region,product_name,ROW_NUMBER() OVER (PARTITION BY region ORDER BY product_revenue DESC) AS rn
    FROM product_revenue_by_region
)
SELECT rs.region,rs.customers,rs.revenue,tp.product_name AS top_product_by_revenue
FROM regional_stats rs
LEFT JOIN top_product_per_region tp 
    ON rs.region = tp.region AND tp.rn = 1
ORDER BY rs.revenue DESC;


