# Sales Analytics SQL Project

A comprehensive **SQL Server** database solution for sales analytics, featuring a well-designed schema, realistic sample data, analytical views, and advanced business intelligence queries.

Perfect for showcasing SQL skills, database design, and analytical thinking in a portfolio or learning project.

## 📋 Project Overview

This project contains a complete **Sales Analytics** database built with T-SQL. It simulates a realistic e-commerce environment with customers, products, orders, and order items, including seasonal trends, discounts, and one cancelled order.

The repository demonstrates best practices in relational database design and advanced SQL analytics.

## ✨ Key Features

- **Relational Database Schema** with proper primary keys, foreign keys, and constraints
- **Performance Indexes** on frequently queried columns
- **Realistic Seed Data**: 10 customers, 12 products, 32 orders spanning 14 months
- **Analytical Views** for quick business reporting
- **Advanced Queries** using CTEs, Window Functions, and aggregations
- Revenue calculation logic: `quantity × unit_price × (1 - discount_rate)`

### Created Views:
1. `monthly_revenue` – Monthly revenue summary
2. `active_90day` – Customers active for 90+ days
3. `vw_top_selling_products` – Top products by total sales

### Advanced Analytics Included:
- Monthly revenue with Month-over-Month (MoM) growth
- Category performance (Last 12 Months)
- Regional sales leaderboard with top product per region
- High-value customer identification

## 🛠️ Technologies

- **SQL Server** (T-SQL)
- Database Design & Normalization
- Indexes and Constraints
- Views
- Common Table Expressions (CTEs)
- Window Functions (`LAG()`, `ROW_NUMBER()`)
- Business Intelligence Reporting

## 📁 Repository Structure
```bash
sales-analytics-sql/
├── sales_analytics.sql     # Main SQL script (DDL + DML + Views + Queries)
└── README.md
```
## 📁 Quick Test Queries:

```sql
-- View monthly revenue
SELECT * FROM monthly_revenue ORDER BY yearly, monthly;

-- Top selling products
SELECT * FROM vw_top_selling_products ORDER BY total_sales DESC;

-- Active customers (90+ days)
SELECT * FROM active_90day ORDER BY customer_id;
