# 📊 Regional Sales Bottleneck Analysis – SQL & Business Dashboard

An end-to-end data analysis project built to identify sales bottlenecks, revenue loss patterns, and agent performance using SQL queries on a regional sales dataset. This project covers SQL analysis, DAX-inspired query logic, and a Power BI Business Dashboard — complete with KPI cards, heatmaps, and trend charts.

---

## 🚀 Project Overview

This project was built as a data analysis exam assignment. It analyzes the `RegionalSales2025.csv` dataset to uncover:
- Monthly sales trends across regions
- Cancellation and return patterns
- Revenue loss by region and product
- Top-performing sales agents
- Category-wise contribution to total revenue
- Customers with repeat return behavior

---

## 🎬 Project Demo Video

> 📺 *(Add your Google Drive or YouTube walkthrough link here)*

---

## 📁 Project Files

| File | Description |
|------|-------------|
| 📄 `SalesBottleneck.sql` | SQL script with all 7 analysis queries |
| 📊 `BottleneckDashboard.pbix` | Power BI Dashboard file |
| 📝 `ExecutiveSummary.txt` | Key insights & suggested actions |
| 📁 `files used/` | Source CSV dataset |
| 📷 `Project images/` | Task screenshots & SQL output images |
| 📘 `README.md` | Project readme |

---

## 📁 Data Source

**File:** `RegionalSales2025.csv`

| Column | Description |
|--------|-------------|
| `OrderID` | Unique order identifier |
| `Date` | Date of transaction |
| `CustomerID` | Unique customer |
| `Region` | Region of sale (East, West, North, South) |
| `ProductName` | Name of product |
| `Category` | Product category |
| `Quantity` | No. of units sold |
| `UnitPrice` | Unit selling price |
| `TotalAmount` | Total sales amount = Quantity × UnitPrice |
| `OrderStatus` | Completed, Cancelled, Returned |
| `SalesAgent` | Assigned agent for region |

---

## 🧩 Project Tasks Breakdown

---

### 🔹 PART 1 – SQL Analysis

All queries are written for the `RegionalSales2025` table.

---

#### 1️⃣ Monthly Trend of Sales Across All Regions

```sql
SELECT 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    Region,
    SUM(TotalAmount) AS TotalSales
FROM RegionalSales2025
GROUP BY DATE_FORMAT(Date, '%Y-%m'), Region;
```

**Purpose:** Shows how sales volume changes month by month for each region — useful for spotting seasonal patterns or regional dips.

**📊 Query Output:**

![SQL Q1 Output](Project%20images/SQL_Q1.png)

> 💡 **Insight:** North Region peaked in April 2025 at ₹2,07,751 — the highest single-region monthly sales recorded.

---

#### 2️⃣ Percentage of Cancelled and Returned Orders Per Region

```sql
SELECT
    Region,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders,
    SUM(CASE WHEN OrderStatus = 'Returned' THEN 1 ELSE 0 END) AS ReturnedOrders,
    ROUND(
        (SUM(CASE WHEN OrderStatus IN ('Cancelled', 'Returned') THEN 1 ELSE 0 END) * 100.0)
        / COUNT(*), 2
    ) AS LossPercentage
FROM RegionalSales2025
GROUP BY Region
ORDER BY LossPercentage DESC;
```

**Purpose:** Identifies which regions have the highest rate of order loss — crucial for operations and logistics review.

**📊 Query Output:**

![SQL Q2 Output](Project%20images/SQL_Q2.png)

> ⚠️ **Insight:** South Region has the highest loss rate at **73.98%** — nearly 3 out of 4 orders are either cancelled or returned. Immediate attention needed!

---

#### 3️⃣ Top 3 Regions/Products with Most Revenue Loss (Cancelled/Returned)

```sql
SELECT
    Region,
    ProductName,
    SUM(TotalAmount) AS RevenueLoss
FROM RegionalSales2025
WHERE OrderStatus IN ('Cancelled', 'Returned')
GROUP BY Region, ProductName
ORDER BY RevenueLoss DESC
LIMIT 3;
```

**Purpose:** Pinpoints which region-product combinations are losing the most revenue — actionable for product quality or delivery improvements.

**📊 Query Output:**

![SQL Q3 Output](Project%20images/SQL_Q3.png)

> 🔴 **Insight:** **South – Tablet** is the biggest revenue drain at ₹1,40,152.65 lost. This could indicate quality, delivery, or pricing issues in the South region for electronics.

---

#### 4️⃣ Average Order Value by Product Category

```sql
SELECT
    Category,
    ROUND(AVG(TotalAmount), 2) AS AvgOrderValue
FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY Category
ORDER BY AvgOrderValue DESC;
```

**Purpose:** Reveals which product categories generate the highest average order value — useful for pricing and promotion strategy.

**📊 Query Output:**

![SQL Q4 Output](Project%20images/SQL_Q4.png)

> 💡 **Insight:** **Electronics** has the highest average order value at ₹11,467 — making it the most valuable category per transaction.

---

#### 5️⃣ Top 5 Performing Sales Agents (by Completed Revenue)

```sql
SELECT 
    SalesAgent, 
    SUM(TotalAmount) AS Revenue
FROM RegionalSales2025
WHERE OrderStatus = 'Completed'
GROUP BY SalesAgent
ORDER BY Revenue DESC 
LIMIT 5;
```

**Purpose:** Ranks agents by actual completed revenue (excluding cancellations/returns) — ideal for performance reviews and incentives.

**📊 Query Output:**

![SQL Q5 Output](Project%20images/SQL_Q5.png)

> 🏆 **Insight:** **Fiona** is the top performer with ₹2,90,772 in completed revenue — leading by ₹23,792 over second-place Alice.

---

#### 6️⃣ Category-wise Total Sales and Contribution to Grand Total

```sql
WITH CategorySales AS (
    SELECT
        Category,
        SUM(TotalAmount) AS Sales
    FROM RegionalSales2025
    WHERE OrderStatus = 'Completed'
    GROUP BY Category
)
SELECT
    Category,
    Sales,
    ROUND(Sales * 100.0 / SUM(Sales) OVER(), 2) AS ContributionPercent
FROM CategorySales
ORDER BY Sales DESC;
```

**Purpose:** Shows each category's share of total revenue using a window function — great for understanding product mix and focus areas.

**📊 Query Output:**

![SQL Q6 Output](Project%20images/SQL_Q6.png)

> 📊 **Insight:** **Furniture** leads with 28.44% of total revenue (₹4.59L), followed closely by Electronics at 26.26%. Revenue is fairly balanced across all 4 categories.

---

#### 7️⃣ List Customers with Highest Frequency of Returns (≥ 3 Times)

```sql
SELECT
    CustomerID,
    COUNT(*) AS ReturnCount
FROM RegionalSales2025
WHERE OrderStatus = 'Returned'
GROUP BY CustomerID
HAVING COUNT(*) >= 3
ORDER BY ReturnCount DESC;
```

**Purpose:** Flags high-return customers — useful for fraud detection, product feedback loops, or targeted support outreach.

**📊 Query Output:**

![SQL Q7 Output](Project%20images/SQL_Q7.png)

> 📝 **Note:** In this 500-row sample dataset, no customer has returned 3 or more times — all return counts are 1. This query will become more meaningful with a larger dataset where repeat return behavior is more likely to appear.

> 💾 **Output:** SQL results saved in CSV format or as temporary tables for dashboard use.

---

### 🔹 PART 2 – Power BI Business Dashboard

Built on SQL results or the original dataset, the dashboard includes:

#### 📌 KPI Cards
- ✅ **Total Completed Sales** → ₹16,15,875.39
- ❌ **Total Cancellations** → 169
- 💰 **Average Order Value** → ₹10,530
- 🔁 **Most Returned Product** → Cooking Oil

#### 📊 Visualizations

| Visual | Description |
|--------|-------------|
| **Heatmap / Matrix** | Region vs Category Sales — shows sales distribution across all region-category combinations |
| **Stacked Bar Chart** | OrderStatus by Region — compares Completed, Cancelled, Returned counts per region |
| **Line Chart** | Monthly Sales Trends — tracks TotalAmount over time across all months |

#### 🎛️ Filters / Slicers
- **Region** (East, West, North, South)
- **Category** (Clothing, Electronics, Furniture, Groceries)
- **SalesAgent** (Alice, Brian, Catherine, David, Ethan, Fiona, George…)

---

## 📸 Dashboard Preview

![Regional Sales Performance Dashboard](Project%20images/dashboard_preview.png)

---

## 📈 How to Use

1. Download or clone the repository
2. Open `SalesBottleneck.sql` in MySQL Workbench or any SQL client
3. Run queries against the `RegionalSales2025` table
4. Open `BottleneckDashboard.pbix` in Power BI Desktop
5. Use slicers to filter by **Region**, **Category**, or **SalesAgent**
6. Review `ExecutiveSummary.txt` for key business insights and recommended actions

---

## 🔍 Key Findings Summary

| # | Finding |
|---|---------|
| 1 | North Region peaked at ₹2,07,751 in April 2025 — highest single-month regional sales |
| 2 | South Region has 73.98% order loss rate — highest cancellations + returns combined |
| 3 | South – Tablet is the #1 revenue loss combo at ₹1,40,152 lost |
| 4 | Electronics has the highest avg order value at ₹11,467 per completed order |
| 5 | Fiona is the top sales agent with ₹2,90,772 in completed revenue |
| 6 | Furniture contributes the most to revenue at 28.44% of grand total |
| 7 | No repeat returners (≥3 returns) found — dataset may need expansion for deeper fraud analysis |

---

## 🛠️ Tools & Technologies Used

| Tool | Usage |
|------|-------|
| **MySQL / SQL** | All 7 analysis queries |
| **Power BI Desktop** | Dashboard with KPI cards, charts, slicers |
| **DAX / Power Query** | Measures and data transformation |
| **CSV** | Source dataset format |

---

## 📋 Final Submission Checklist

| File | Status | Description |
|------|--------|-------------|
| `SalesBottleneck.sql` | ✅ | SQL script with all 7 analysis queries |
| `BottleneckDashboard.pbix` | ✅ | Completed Power BI dashboard |
| `ExecutiveSummary.txt` | ✅ | Key insights & suggested actions |

---

## 👩‍💻 Priya Savaliya
📍 Ahmedabad

⭐ If you found this project helpful — give it a ⭐ and feel free to fork or contribute!

🎓 *Clean SQL. Real Outputs. Clear Insights. Complete Dashboard.*
