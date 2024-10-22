
----------------------------------------------------------------solving----------------------------------------------------------------------
-- STEP 1
-- 1.1 DROP product_lines and payments. First, drop constraint products_ibfk_1 from 

ALTER TABLE products
DROP CONSTRAINT products_ibfk_1;

DROP TABLE product_lines;
DROP TABLE payments;



-- 1.2 Delete lines from employees WHERE jobTitle = "President" OR jobTitle LIKE '%VP%' OR jobTitle LIKE '%Manager%'
-- disable employees_ibfk_1 from employees

ALTER TABLE employees NOCHECK CONSTRAINT employees_ibfk_1;

DELETE FROM employees
WHERE jobTitle = 'President' OR jobTitle LIKE '%VP%' OR jobTitle LIKE '%Manager%';

ALTER TABLE employees CHECK CONSTRAINT employees_ibfk_1;


-- 1.3 Delete the addressLine2 field from the offices table.

ALTER TABLE offices
DROP COLUMN addressLine2;


-- Step 2 - Join all tables

SELECT *
FROM ORDERS ord
LEFT JOIN order_details ord_details
	ON ord.ordernumber = ord_details.ordernumber
LEFT JOIN products prod
	ON ord_details.productcode = prod.productcode
LEFT JOIN customers cust
	ON ord.customernumber = cust.customernumber
LEFT JOIN employees emp
	ON cust.salesrepemployeenumber = emp.employeenumber
LEFT JOIN offices offs
	ON emp.officecode = offs.officecode


-- STEP 3 and 4. Select specified fields only

SELECT 
    emp.EMPLOYEENUMBER,
    emp.LASTNAME,
    emp.FIRSTNAME,
    emp.OFFICECODE,
    emp.JOBTITLE,
    offs.officeCode ,
	offs.city,
	offs.addressLine1 ,
	offs.country,
	cust.customerNumber,
	cust.customerName,
	cust.contactLastName,
	cust.contactFirstName,
	cust.salesRepEmployeeNumber,
	ord.orderNumber,
	ord.orderDate,
	ord.shippedDate,
	ord.customerNumber,
	ord_details.orderNumber,
	ord_details.productCode,
	ord_details.quantityOrdered,
	ord_details.priceEach,
	ROUND(ord_details.priceEach, 1) AS roundedpriceEach,
	prod.productCode,
	prod.productName,
	prod.productLine,
	prod.buyPrice,
	ROUND(prod.buyPrice,1) AS roundedbuyPrice,
	prod.quantityInStock
FROM ORDERS ord
LEFT JOIN order_details ord_details
	ON ord.ordernumber = ord_details.ordernumber
LEFT JOIN products prod
	ON ord_details.productcode = prod.productcode
LEFT JOIN customers cust
	ON ord.customernumber = cust.customernumber
LEFT JOIN employees emp
	ON cust.salesrepemployeenumber = emp.employeenumber
LEFT JOIN offices offs
	ON emp.officecode = offs.officecode
WHERE
prod.PRODUCTLINE <> 'planes'
AND
ord.shippedDate IS NOT NULL
AND
ord.requiredDate > ord.shippedDate
ORDER BY ORDERDATE DESC;
