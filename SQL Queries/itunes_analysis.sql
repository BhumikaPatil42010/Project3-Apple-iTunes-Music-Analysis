-- CREATE A DATABASE 
CREATE DATABASE IF NOT EXISTS itunes_db;
USE itunes_db;

-- CREATE TABLES OF EACH DATASET
-- MEDIA_TYPE
CREATE TABLE media_type (
    MediaTypeId INT PRIMARY KEY,
    Name VARCHAR(120)
);

-- GENRE
CREATE TABLE genre (
    GenreId INT PRIMARY KEY,
    Name VARCHAR(120)
);

-- ARTIST
CREATE TABLE artist (
    ArtistId INT PRIMARY KEY,
    Name VARCHAR(120)
);

-- EMPLOYEE
CREATE TABLE employee (
    EmployeeId INT PRIMARY KEY,
    LastName VARCHAR(50),
    FirstName VARCHAR(50),
    Title VARCHAR(100),
    ReportsTo INT,
    Levels INT,
    BirthDate DATETIME,
    HireDate DATETIME,
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    Phone VARCHAR(30),
    Fax VARCHAR(30),
    Email VARCHAR(100)
);

-- CUSTOMER
CREATE TABLE customer (
    CustomerId INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Company VARCHAR(100),
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    Country VARCHAR(50),
    PostalCode VARCHAR(20),
    Phone VARCHAR(30),
    Fax VARCHAR(30),
    Email VARCHAR(100),
    SupportRepId INT,

    FOREIGN KEY (SupportRepId)
    REFERENCES employee(EmployeeId)
);

-- ALBUM
CREATE TABLE album (
    AlbumId INT PRIMARY KEY,
    Title VARCHAR(200),
    ArtistId INT,

    FOREIGN KEY (ArtistId)
    REFERENCES artist(ArtistId)
);

-- TRACK
CREATE TABLE track (
    TrackId INT PRIMARY KEY,
    Name VARCHAR(200),
    AlbumId INT,
    MediaTypeId INT,
    GenreId INT,
    Composer VARCHAR(220),
    Milliseconds INT,
    Bytes INT,
    UnitPrice DECIMAL(10,2),

    FOREIGN KEY (AlbumId)
    REFERENCES album(AlbumId),

    FOREIGN KEY (MediaTypeId)
    REFERENCES media_type(MediaTypeId),

    FOREIGN KEY (GenreId)
    REFERENCES genre(GenreId)
);

-- PLAYLIST
CREATE TABLE playlist (
    PlaylistId INT PRIMARY KEY,
    Name VARCHAR(120)
);

-- PLAYLIST_TRACK
CREATE TABLE playlist_track (
    PlaylistId INT,
    TrackId INT,

    PRIMARY KEY (PlaylistId, TrackId),

    FOREIGN KEY (PlaylistId)
    REFERENCES playlist(PlaylistId),

    FOREIGN KEY (TrackId)
    REFERENCES track(TrackId)
);

-- INVOICE
CREATE TABLE invoice (
    InvoiceId INT PRIMARY KEY,
    CustomerId INT,
    InvoiceDate DATETIME,
    BillingAddress VARCHAR(200),
    BillingCity VARCHAR(50),
    BillingState VARCHAR(50),
    BillingCountry VARCHAR(50),
    BillingPostalCode VARCHAR(20),
    Total DECIMAL(10,2),

    FOREIGN KEY (CustomerId)
    REFERENCES customer(CustomerId)
);

-- INVOICE_LINE
CREATE TABLE invoice_line (
    InvoiceLineId INT PRIMARY KEY,
    InvoiceId INT,
    TrackId INT,
    UnitPrice DECIMAL(10,2),
    Quantity INT,

    FOREIGN KEY (InvoiceId)
    REFERENCES invoice(InvoiceId),

    FOREIGN KEY (TrackId)
    REFERENCES track(TrackId)
);

-- Data Validation Queries
SELECT COUNT(*) FROM customer;
SELECT COUNT(*) FROM employee;
SELECT COUNT(*) FROM invoice;
SELECT COUNT(*) FROM invoice_line;
SELECT COUNT(*) FROM track;
SELECT COUNT(*) FROM album;
SELECT COUNT(*) FROM artist;
SELECT COUNT(*) FROM genre;
SELECT COUNT(*) FROM playlist;
SELECT COUNT(*) FROM playlist_track;
SELECT COUNT(*) FROM media_type;
-- ✅ Expected Result:

-- Relationship Validation
-- Customer → Invoice
SELECT
c.CustomerId,
c.FirstName,
i.InvoiceId,
i.Total
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
LIMIT 10;

-- Invoice → Invoice Line
SELECT
i.InvoiceId,
il.InvoiceLineId,
il.Quantity
FROM invoice i
JOIN invoice_line il
ON i.InvoiceId = il.InvoiceId
LIMIT 10;

-- Track → Album → Artist
SELECT
t.Name AS Track,
al.Title AS Album,
ar.Name AS Artist
FROM track t
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
LIMIT 10;

-- Track → Genre → Media Type
SELECT
t.Name,
g.Name AS Genre,
m.Name AS MediaType
FROM track t
JOIN genre g ON t.GenreId = g.GenreId
JOIN media_type m ON t.MediaTypeId = m.MediaTypeId
LIMIT 10;

-- Data Quality Checks
-- Customers without invoices
SELECT c.CustomerId
FROM customer c
LEFT JOIN invoice i
ON c.CustomerId = i.CustomerId
WHERE i.InvoiceId IS NULL;

-- Tracks never purchased
SELECT t.TrackId, t.Name
FROM track t
LEFT JOIN invoice_line il
ON t.TrackId = il.TrackId
WHERE il.TrackId IS NULL;

-- Check NULL emails
SELECT *
FROM customer
WHERE Email IS NULL;

-- Exploratory Data Analysis (EDA)
-- Total Revenue
SELECT ROUND(SUM(Total),2) AS Total_Revenue
FROM invoice;
-- Total Customers
SELECT COUNT(CustomerId) AS Total_Customers
FROM customer;
-- Total Tracks
SELECT COUNT(TrackId) AS Total_Tracks
FROM track;
-- Total Orders
SELECT COUNT(InvoiceId) AS Total_Orders
FROM invoice;

-- Customer Analysis
-- Customers by Country
SELECT Country,
COUNT(CustomerId) AS Customer_Count
FROM customer
GROUP BY Country
ORDER BY Customer_Count DESC;

-- Revenue by Country
SELECT BillingCountry,
ROUND(SUM(Total),2) AS Revenue
FROM invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC;

-- Top 10 Customers
SELECT
c.CustomerId,
c.FirstName,
c.LastName,
ROUND(SUM(i.Total),2) AS Total_Spent
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY Total_Spent DESC
LIMIT 10;


-- Music Analysis
-- Most Popular Genres
SELECT
g.Name AS Genre,
COUNT(il.InvoiceLineId) AS Purchases
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Purchases DESC;

-- Top Selling Artists
SELECT
ar.Name AS Artist,
COUNT(il.InvoiceLineId) AS Sales
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY Sales DESC
LIMIT 10;

-- Most Purchased Tracks
SELECT
t.Name,
COUNT(il.InvoiceLineId) AS Purchase_Count
FROM invoice_line il
JOIN track t
ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY Purchase_Count DESC
LIMIT 10;

-- Employee Performance
SELECT
e.FirstName,
e.LastName,
ROUND(SUM(i.Total),2) AS Revenue_Generated
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName
ORDER BY Revenue_Generated DESC;

-- Revenue Trends
-- Monthly Revenue
SELECT
YEAR(InvoiceDate) AS Year,
MONTH(InvoiceDate) AS Month,
ROUND(SUM(Total),2) AS Revenue
FROM invoice
GROUP BY Year, Month
ORDER BY Year, Month;

-- Yearly Revenue
SELECT
YEAR(InvoiceDate) AS Year,
ROUND(SUM(Total),2) AS Revenue
FROM invoice
GROUP BY Year
ORDER BY Year;

-- Media Type Revenue
SELECT
m.Name,
ROUND(SUM(il.UnitPrice * il.Quantity),2) AS Revenue
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN media_type m ON t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY Revenue DESC;

-- Advanced SQL Analysis
-- Top Customers using CTE
WITH customer_spending AS (
SELECT
c.CustomerId,
c.FirstName,
c.LastName,
SUM(i.Total) AS TotalSpent
FROM customer c
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
)

SELECT *
FROM customer_spending
ORDER BY TotalSpent DESC
LIMIT 10;

-- Customer Segmentation
WITH spending AS (
SELECT
c.CustomerId,
SUM(i.Total) AS TotalSpent
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
)

SELECT
CustomerId,
TotalSpent,
CASE
WHEN TotalSpent > 40 THEN 'High Value'
WHEN TotalSpent BETWEEN 20 AND 40 THEN 'Medium Value'
ELSE 'Low Value'
END AS CustomerSegment
FROM spending
ORDER BY TotalSpent DESC;

-- Artist Revenue Ranking
SELECT
ar.Name AS Artist,
SUM(il.UnitPrice * il.Quantity) AS Revenue,
RANK() OVER(
ORDER BY SUM(il.UnitPrice * il.Quantity) DESC
) AS ArtistRank
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name;

-- Genre Revenue Ranking
SELECT
g.Name AS Genre,
SUM(il.UnitPrice * il.Quantity) AS Revenue,
DENSE_RANK() OVER(
ORDER BY SUM(il.UnitPrice * il.Quantity) DESC
) AS GenreRank
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name;

-- Top Track in Each Genre
WITH track_sales AS (
SELECT
g.Name AS Genre,
t.Name AS Track,
COUNT(il.InvoiceLineId) AS Sales,
RANK() OVER(
PARTITION BY g.Name
ORDER BY COUNT(il.InvoiceLineId) DESC
) AS rnk
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name, t.Name
)

SELECT *
FROM track_sales
WHERE rnk = 1;

-- Employee Sales Ranking
SELECT
e.FirstName,
e.LastName,
SUM(i.Total) AS Revenue,
RANK() OVER(
ORDER BY SUM(i.Total) DESC
) AS EmployeeRank
FROM employee e
JOIN customer c ON e.EmployeeId = c.SupportRepId
JOIN invoice i ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId, e.FirstName, e.LastName;

-- 2. Validate Customer → Invoice Relationship
SELECT
c.CustomerId,
c.FirstName,
i.InvoiceId,
i.Total
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
LIMIT 10;
-- If rows appear → relationship working.

-- 3. Validate Invoice → Invoice Line Relationship
SELECT
i.InvoiceId,
il.InvoiceLineId,
il.Quantity
FROM invoice i
JOIN invoice_line il
ON i.InvoiceId = il.InvoiceId
LIMIT 10;
-- Confirms purchase details connected.

-- 4. Validate Track → Album → Artist Connection
SELECT
t.Name AS Track,
al.Title AS Album,
ar.Name AS Artist
FROM track t
JOIN album al
ON t.AlbumId = al.AlbumId
JOIN artist ar
ON al.ArtistId = ar.ArtistId
LIMIT 10;
-- Ensures music ownership structure works.

-- 5. Validate Track → Genre → Media Type
SELECT
t.Name,
g.Name AS Genre,
m.Name AS MediaType
FROM track t
JOIN genre g
ON t.GenreId = g.GenreId
JOIN media_type m
ON t.MediaTypeId = m.MediaTypeId
LIMIT 10;
-- Confirms classification data.

-- 6. Validate Employee → Customer Relationship
-- Check sales representative mapping.
SELECT
e.FirstName AS Employee,
c.FirstName AS Customer
FROM employee e
JOIN customer c
ON e.EmployeeId = c.SupportRepId
LIMIT 10;
-- Employee support system verified.

-- 7.Customers without invoices
SELECT c.CustomerId
FROM customer c
LEFT JOIN invoice i
ON c.CustomerId = i.CustomerId
WHERE i.InvoiceId IS NULL;
-- Every customer has at least one invoice
-- There are NO inactive customers in your dataset.

-- Same Case: Tracks Never Purchased
SELECT t.TrackId, t.Name
FROM track t
LEFT JOIN invoice_line il
ON t.TrackId = il.TrackId
WHERE il.TrackId IS NULL;
-- Every track was purchased at least once.
-- Business meaning: All songs in iTunes catalog generated sales.

-- 8. Check NULL Values (Data Cleaning Validation)
SELECT *
FROM customer
WHERE Email IS NULL;
-- No missing email values
-- Dataset clean
-- No data cleaning required

-- STEP 2 — Exploratory Data Analysis (EDA)
-- SECTION 1 — Overall Business Overview =
-- 1.Total Revenue Generated
SELECT ROUND(SUM(Total),2) AS Total_Revenue
FROM invoice;
-- 2.Total Number of Customers
SELECT COUNT(CustomerId) AS Total_Customers
FROM customer;
-- 3.Total Number of Tracks Available
SELECT COUNT(TrackId) AS Total_Tracks
FROM track;
-- 4.Total Invoices Generated
SELECT COUNT(InvoiceId) AS Total_Orders
FROM invoice;

-- SECTION 2 — Customer Analysis
-- 5.Customers by Country
SELECT Country,
       COUNT(CustomerId) AS Customer_Count
FROM customer
GROUP BY Country
ORDER BY Customer_Count DESC;

-- 6.Revenue by Country
SELECT BillingCountry,
       ROUND(SUM(Total),2) AS Revenue
FROM invoice
GROUP BY BillingCountry
ORDER BY Revenue DESC;

-- 7.Top 10 Spending Customers =
SELECT
c.CustomerId,
c.FirstName,
c.LastName,
ROUND(SUM(i.Total),2) AS Total_Spent
FROM customer c
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
ORDER BY Total_Spent DESC
LIMIT 10;

-- SECTION 3 — Music & Product Analysis
-- 8.Most Popular Genres =
SELECT
g.Name AS Genre,
COUNT(il.InvoiceLineId) AS Total_Purchases
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name
ORDER BY Total_Purchases DESC;

-- 9.Top Selling Artists
SELECT
ar.Name AS Artist,
COUNT(il.InvoiceLineId) AS Sales
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name
ORDER BY Sales DESC
LIMIT 10;

-- 10. Most Purchased Tracks
SELECT
t.Name,
COUNT(il.InvoiceLineId) AS Purchase_Count
FROM invoice_line il
JOIN track t
ON il.TrackId = t.TrackId
GROUP BY t.Name
ORDER BY Purchase_Count DESC
LIMIT 10;

-- SECTION 4 — Employee Performance
-- 1.1.Sales Generated by Employees
SELECT
e.FirstName,
e.LastName,
ROUND(SUM(i.Total),2) AS Revenue_Generated
FROM employee e
JOIN customer c
ON e.EmployeeId = c.SupportRepId
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId
ORDER BY Revenue_Generated DESC;

-- SECTION 5 — Revenue Trend Analysis
-- 1.2.Monthly Revenue Trend
SELECT
MONTH(InvoiceDate) AS Month,
ROUND(SUM(Total),2) AS Revenue
FROM invoice
GROUP BY Month
ORDER BY Month;

-- 1.3.Yearly Revenue Trend
SELECT
YEAR(InvoiceDate) AS Year,
ROUND(SUM(Total),2) AS Revenue
FROM invoice
GROUP BY Year
ORDER BY Year;

-- SECTION 6 — Media Type Analysis
-- 1.4.Revenue by Media Type
SELECT
m.Name,
ROUND(SUM(il.UnitPrice * il.Quantity),2) AS Revenue
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN media_type m ON t.MediaTypeId = m.MediaTypeId
GROUP BY m.Name
ORDER BY Revenue DESC;

-- STEP 3 — ADVANCED SQL ANALYSIS
-- 1. Customer Spending Analysis (CTE)
-- Find Highest Paying Customers
WITH customer_spending AS (
    SELECT
        c.CustomerId,
        c.FirstName,
        c.LastName,
        SUM(i.Total) AS TotalSpent
    FROM customer c
    JOIN invoice i
    ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
)

SELECT *
FROM customer_spending
ORDER BY TotalSpent DESC
LIMIT 10;
-- Identify premium customers.

-- 2. Customer Segmentation (BIG INTERVIEW QUESTION 🔥)
-- Divide customers into categories.
WITH spending AS (
    SELECT
        c.CustomerId,
        SUM(i.Total) AS TotalSpent
    FROM customer c
    JOIN invoice i
    ON c.CustomerId = i.CustomerId
    GROUP BY c.CustomerId
)

SELECT CustomerId,
       TotalSpent,
       CASE
           WHEN TotalSpent > 40 THEN 'High Value'
           WHEN TotalSpent BETWEEN 20 AND 40 THEN 'Medium Value'
           ELSE 'Low Value'
       END AS CustomerSegment
FROM spending
ORDER BY TotalSpent DESC;
-- Marketing targeting.

-- 3. Rank Artists by Revenue (Window Function)
SELECT
ar.Name AS Artist,
SUM(il.UnitPrice * il.Quantity) AS Revenue,
RANK() OVER(
ORDER BY SUM(il.UnitPrice * il.Quantity) DESC
) AS ArtistRank
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN album al ON t.AlbumId = al.AlbumId
JOIN artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.Name;
-- Finds top-performing artists.

-- 4. Genre Revenue Ranking
SELECT
g.Name AS Genre,
SUM(il.UnitPrice * il.Quantity) AS Revenue,
DENSE_RANK() OVER(
ORDER BY SUM(il.UnitPrice * il.Quantity) DESC
) AS GenreRank
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name;

-- 5. Top Track in Each Genre (ADVANCED ⭐)
WITH track_sales AS (
SELECT
g.Name AS Genre,
t.Name AS Track,
COUNT(il.InvoiceLineId) AS Sales,
RANK() OVER(
PARTITION BY g.Name
ORDER BY COUNT(il.InvoiceLineId) DESC
) AS rnk
FROM invoice_line il
JOIN track t ON il.TrackId = t.TrackId
JOIN genre g ON t.GenreId = g.GenreId
GROUP BY g.Name, t.Name
)

SELECT *
FROM track_sales
WHERE rnk = 1;

-- 6. Employee Sales Ranking
SELECT
e.FirstName,
e.LastName,
SUM(i.Total) AS Revenue,
RANK() OVER(
ORDER BY SUM(i.Total) DESC
) AS EmployeeRank
FROM employee e
JOIN customer c
ON e.EmployeeId = c.SupportRepId
JOIN invoice i
ON c.CustomerId = i.CustomerId
GROUP BY e.EmployeeId;

-- 7. Monthly Revenue Growth Analysis
SELECT
YEAR(InvoiceDate) AS Year,
MONTH(InvoiceDate) AS Month,
SUM(Total) AS Revenue,
LAG(SUM(Total)) OVER(
ORDER BY YEAR(InvoiceDate), MONTH(InvoiceDate)
) AS PreviousMonthRevenue
FROM invoice
GROUP BY Year, Month;
-- Used for growth comparison.

-- 8. Identify Best Selling Media Type
SELECT
m.Name,
SUM(il.Quantity) AS TotalSales,
RANK() OVER(
ORDER BY SUM(il.Quantity) DESC
) AS RankNo
FROM invoice_line il
JOIN track t ON il.TrackId=t.TrackId
JOIN media_type m ON t.MediaTypeId=m.MediaTypeId
GROUP BY m.Name;

-- 9. Playlist Popularity Analysis
SELECT
p.Name,
COUNT(pt.TrackId) AS TotalTracks
FROM playlist p
JOIN playlist_track pt
ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name
ORDER BY TotalTracks DESC;


