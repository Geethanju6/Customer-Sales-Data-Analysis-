Use Dsales;
-- Checking if data count is matching

Select count(*) from ['Year 2009-2010$']
Select count(*) from ['Year 2010-2011$']

--Count matching with excel
--Next Step, Combine both the tables as a combinedtable
--Created a new table Combinetable
CREATE TABLE CombinedTable (
	[Invoice] [nvarchar](255) NULL,
	[StockCode] [nvarchar](255) NULL,
	[Description] [nvarchar](255) NULL,
	[Quantity] [float] NULL,
	[InvoiceDate] [date] NULL,
	[Price] [float] NULL,
	[CustomerID] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL
)
--Inserting 2009-2010 values into the table
INSERT INTO CombinedTable
SELECT * FROM [dbo].['Year 2009-2010$'];

--Inserting 2010-2011 values into the table
INSERT INTO CombinedTable
SELECT * FROM [dbo].['Year 2010-2011$']
--Checking the count to match the count of both the tables
SELECT count(*) FROM CombinedTable

-- ////////////////////////////////////////////////////////////////////////////--
								--DATA ANALYSIS--
-- Top-selling products by quantity:
SELECT StockCode, Description, SUM(Quantity) AS TotalQuantity
FROM [dbo].[CombinedTable]
GROUP BY StockCode, Description
ORDER BY TotalQuantity DESC
LIMIT 10

--Top-selling products by revenue
SELECT StockCode, Description,ROUND(SUM(Quantity*Price),1) AS Revenue
FROM [dbo].[CombinedTable]
GROUP BY StockCode, Description
ORDER BY Revenue DESC
LIMIT 10;

--Sales trends over time:
SELECT YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month, ROUND(SUM(Quantity * Price),2) AS MonthlyRevenue
FROM [dbo].[CombinedTable]
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY YEAR(InvoiceDate), MONTH(InvoiceDate);

-- Sales trend analysis by year
SELECT YEAR(InvoiceDate) AS Year,
       ROUND(SUM(Quantity * Price),2) AS Revenue
FROM CombinedTable
GROUP BY YEAR(InvoiceDate)
ORDER BY Year;

-- Customer segmentation based on purchasing behavior
SELECT CustomerID,
       COUNT(*) AS TotalOrders,
       ROUND(SUM(Quantity * Price),2) AS TotalSpent
FROM CombinedTable
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

--Customer retention rate:
SELECT YEAR(InvoiceDate) AS Year, 
       COUNT(DISTINCT CustomerID) AS TotalCustomers,
       COUNT(DISTINCT CASE WHEN YEAR(InvoiceDate) = 2009 THEN CustomerID END) AS CustomersIn2009,
       COUNT(DISTINCT CASE WHEN YEAR(InvoiceDate) = 2010 THEN CustomerID END) AS CustomersIn2010
FROM [dbo].[CombinedTable]
GROUP BY YEAR(InvoiceDate);

--Sales performance by country:
SELECT Country, ROUND(SUM(Quantity * Price),2) AS TotalRevenue
FROM [dbo].[CombinedTable]
GROUP BY Country
ORDER BY TotalRevenue DESC;

--Calculated the average revenue generated per customer over their entire lifetime.
SELECT CustomerID, round(SUM(Quantity * Price),2) AS TotalRevenue
FROM [dbo].[CombinedTable]
GROUP BY CustomerID;

--Analyze the performance of each product over time.
SELECT StockCode, Description, YEAR(InvoiceDate) AS Year, MONTH(InvoiceDate) AS Month, 
       SUM(Quantity) AS TotalQuantity, ROUND(SUM(Quantity * Price),2) AS TotalRevenue
FROM [dbo].[CombinedTable]
GROUP BY StockCode, Description, YEAR(InvoiceDate), MONTH(InvoiceDate)
ORDER BY TotalRevenue DESC













