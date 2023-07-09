CREATE TABLE Customer (
  Customer_Id INT PRIMARY KEY,
  Customer_Name VARCHAR(50)
);

INSERT INTO Customer (Customer_Id, Customer_Name)
VALUES(1, 'John'),
(2, 'Smith'),
(3, 'Ricky'),
(4, 'Walsh'),
(5, 'Stefen'),
(6, 'Fleming'),
(7, 'Thomson'),
(8, 'David');

CREATE TABLE Product (
  Product_Id INT PRIMARY KEY,
  Product_Name VARCHAR(50),
  Product_Price DECIMAL(10, 2)
);

INSERT INTO Product (Product_Id, Product_Name, Product_Price)
VALUES(1, 'Television', 19000),
(2, 'DVD', 3600),
(3, 'Washing Machine', 7600),
(4, 'Computer', 35900),
(5, 'Ipod', 3210),
(6, 'Panasonic Phone', 2100),
(7, 'Chair', 360),
(8, 'Table', 490),
(9, 'Sound System', 12050),
(10, 'Home Theatre', 19350);

CREATE TABLE Orders (
  Order_Id INT PRIMARY KEY,
  Customer_Id INT,
  Ordered_Date DATE,
  FOREIGN KEY (Customer_Id) REFERENCES Customer (Customer_Id)
);

INSERT INTO Orders (Order_Id, Customer_Id, Ordered_Date)
VALUES(1, 4, '2005-01-10'),
(2, 2, '2006-02-10'),
(3, 3, '2005-03-20'),
(4, 3, '2006-03-10'),
(5, 1, '2007-04-05'),
(6, 7, '2006-12-13'),
(7, 6, '2008-03-13'),
(8, 6, '2004-11-29'),
(9, 5, '2005-01-13'),
(10, 1, '2007-12-12');

CREATE TABLE Order_Details (
  Order_Detail_Id INT PRIMARY KEY,
  Order_Id INT,
  Product_Id INT,
  Quantity INT,
  FOREIGN KEY (Order_Id) REFERENCES Orders (Order_Id),
  FOREIGN KEY (Product_Id) REFERENCES Product (Product_Id)
);

INSERT INTO Order_Details (Order_Detail_Id, Order_Id, Product_Id, Quantity)
VALUES(1, 1, 3, 1),
(2, 1, 2, 3),
(3, 2, 10, 2),
(4, 3, 7, 10),
(5, 3, 4, 2),
(6, 3, 5, 4),
(7, 4, 3, 1),
(8, 5, 1, 2),
(9, 5, 2, 1),
(10, 6, 5, 1),
(11, 7, 6, 1),
(12, 8, 10, 2),
(13, 8, 3, 1),
(14, 9, 10, 3),
(15, 10, 1, 1);


-- 1.Fetch all the Customer Details along with the product names that the customer has ordered.

select c.*,p.Product_Name
from Customer c
join orders o on c.Customer_Id= o.Customer_Id
join Order_Details od on o.Order_Id = od.Order_Id
join Product p on od.Product_Id = p.Product_Id;

-- 2.Fetch Order_Id, Ordered_Date, Total Price of the order (product price*qty).

select o.Order_Id,o.Ordered_Date, sum(p.Product_Price * od.Quantity) as Total_Price
from Orders o
join Order_Details od on o.Order_Id = od.Order_Id
join Product p on od.Product_Id = p.Product_Id
group by o.Order_Id,o.Ordered_Date;

-- 3.Fetch the Customer Name, who has not placed any order

select c.Customer_Name
from customer c
left join Orders o on c.customer_Id = o.Customer_Id
where o.Order_Id is null;

-- 4.Fetch the Product Details without any order(purchase)

select p.*
from Product p
left join Order_Details  od on p.Product_Id  = od.Product_Id 
where od.Order_Detail_Id is null;

-- 5.Fetch the Customer name along with the total Purchase Amount

SELECT c.Customer_Name, SUM(p.Product_Price * od.Quantity) AS Total_Purchase_Amount
FROM Customer c
LEFT JOIN Orders o ON c.Customer_Id = o.Customer_Id
LEFT JOIN Order_Details od ON o.Order_Id = od.Order_Id
LEFT JOIN Product p ON od.Product_Id = p.Product_Id
GROUP BY c.Customer_Name;

-- 6.Fetch the Customer details, who has placed the first and last order

SELECT c.Customer_Id, c.Customer_Name, MIN(o.Ordered_Date) AS First_Order_Date, MAX(o.Ordered_Date) AS Last_Order_Date
FROM Customer c
JOIN Orders o ON c.Customer_Id = o.Customer_Id
GROUP BY c.Customer_Id, c.Customer_Name;


-- 7. Fetch the customer details , who has placed more number of orders

select c.*,count(o.Order_Id) as Total_Orders
from Customer c
join Orders o on c.Customer_Id = o.Customer_Id
group by c.Customer_Id,c.Customer_Name
order by Total_Orders desc
limit 1;

-- 8. Fetch the customer details, who has placed multiple orders in the same year

SELECT c.Customer_Id, c.Customer_Name, YEAR(o.Ordered_Date) AS Order_Year, COUNT(DISTINCT o.Order_Id) AS Total_Orders
FROM Customer c
JOIN Orders o ON c.Customer_Id = o.Customer_Id
GROUP BY c.Customer_Id, c.Customer_Name, Order_Year
HAVING COUNT(DISTINCT o.Order_Id) > 1;

-- 9. Fetch the name of the month, in which more number of orders has been placed

SELECT MONTHNAME(o.Ordered_Date) AS Month_Name, COUNT(*) AS Total_Orders
FROM Orders o
GROUP BY MONTHNAME(o.Ordered_Date)
ORDER BY Total_Orders DESC
LIMIT 1;


 -- 10. Fetch the maximum priced Ordered Product

SELECT p.Product_Name, p.Product_Price
FROM Product p
JOIN Order_Details od ON p.Product_Id = od.Product_Id
ORDER BY p.Product_Price DESC
LIMIT 1;








