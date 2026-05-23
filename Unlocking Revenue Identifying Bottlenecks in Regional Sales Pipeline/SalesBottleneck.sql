Exam Title: “Unlocking Revenue: Identifying Bottlenecks in Regional Sales Pipeline”

#Data


CREATE DATABASE RegionalSales2025;
USE RegionalSales2025;

CREATE TABLE regionalSales2025 (
    OrderID INT PRIMARY KEY,
    Date DATE,
    CustomerID VARCHAR(10),
    Region VARCHAR(20),
    ProductName VARCHAR(50),
    Category VARCHAR(30),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20),
    SalesAgent VARCHAR(50)
);


🔧 PART 1 – SQL Analysis

# Q1 📈 Monthly trend of sales across all regions.

SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    Region,
    SUM(TotalAmount) AS TotalSales
FROM regionalSales2025_500_rows
GROUP BY DATE_FORMAT(Date, '%Y-%m'), Region;

# Q2 🚫 Percentage of canceled and returned orders per region.

SELECT
    Region,
    
    COUNT(*) AS TotalOrders,

    SUM(
        CASE
            WHEN OrderStatus = 'Cancelled'
            THEN 1
            ELSE 0
        END
    ) AS CancelledOrders,

    SUM(
        CASE
            WHEN OrderStatus = 'Returned'
            THEN 1
            ELSE 0
        END
    ) AS ReturnedOrders,

    ROUND(
        (
            SUM(
                CASE
                    WHEN OrderStatus IN ('Cancelled', 'Returned')
                    THEN 1
                    ELSE 0
                END
            ) * 100.0
        ) / COUNT(*),
        2
    ) AS LossPercentage

FROM RegionalSales2025

GROUP BY Region

ORDER BY LossPercentage DESC;

# Q3 📉 Identify 3 regions/products with most revenue loss (cancelled/returned).

SELECT
    Region,
    ProductName,
    SUM(TotalAmount) AS RevenueLoss
FROM RegionalSales2025
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY Region, ProductName
ORDER BY RevenueLoss DESC
LIMIT 3;

# Q4 🧮 Average order value by product category.

SELECT
    Category,

    ROUND(
        AVG(TotalAmount),
        2
    ) AS AvgOrderValue

FROM RegionalSales2025

WHERE OrderStatus='Completed'

GROUP BY Category

ORDER BY AvgOrderValue DESC;

# Q5 🧍 Top 5 performing sales agents (by completed revenue).

SELECT 
    SalesAgent, 
    SUM(TotalAmount) AS Revenue
FROM RegionalSales2025
WHERE OrderStatus='Completed'
GROUP BY SalesAgent
ORDER BY Revenue DESC 
LIMIT 5

# Q6 📊 Category-wise total sales and contribution to grand total.

WITH CategorySales AS
(
SELECT
Category,

SUM(TotalAmount) AS Sales
FROM RegionalSales2025
WHERE OrderStatus='Completed'
GROUP BY Category
)

SELECT
Category,

Sales,

ROUND(
Sales*100.0/
SUM(Sales) OVER(),
2
) AS ContributionPercent

FROM CategorySales

ORDER BY Sales DESC;

# Q7 🏆 List customers with highest frequency of returns (≥ 3 times).

SELECT
    CustomerID,
    COUNT(*) AS ReturnCount

FROM RegionalSales2025

WHERE OrderStatus='Returned'

GROUP BY CustomerID

ORDER BY ReturnCount DESC;


